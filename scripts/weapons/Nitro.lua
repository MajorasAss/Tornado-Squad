
AngryM_Tornado_Nitro_Wep = Leap_Attack:new{
	Name = "Hermes Boosters",
	Description = "Can jump forward, smoking the tile it lands on, after that, fly in a line and slam into the target, pushing and damaging it.",
	Class = "Brute",
	Icon = "weapons/brute_boosters.png",
	Damage = 1,
	Rarity = 1,
	Range = 3,
	PowerCost = 0,
	TwoClick = true,
	Upgrades = 2,
	UpgradeCost = {2,1},
	UpgradeList = {"+2 Range","+1 Damage"},
	Push = 0,
	Fly = 1,
	SelfDamage = 0,
	LaunchSound = "/weapons/boosters",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(4,2),
		Target = Point(2,2),
		Second_Click = Point(4,2),
	}
}
AngryM_Tornado_Nitro_Wep_A = AngryM_Tornado_Nitro_Wep:new{UpgradeDescription = "Increases jump range by 2",Range = 5,}
AngryM_Tornado_Nitro_Wep_B = AngryM_Tornado_Nitro_Wep:new{UpgradeDescription = "Increases charge damage by 1.",Damage = 2}
AngryM_Tornado_Nitro_Wep_AB = AngryM_Tornado_Nitro_Wep_B:new{Range = 5,}
AngryM_Tornado_Nitro_Wep_A.TipImage = {
	Unit = Point(2,5),
	Enemy = Point(4,1),
	Target = Point(2,1),
	Second_Click = Point(4,1),
}
function Leap_Attack:GetTargetArea(p1)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		for k = 1, self.Range do
			local curr = DIR_VECTORS[i]*k + p1
			if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + p1)
			end
		end
	end
	ret:push_back(p1)
	
	return ret
end

function AngryM_Tornado_Nitro_Wep:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	if p1==p2 then
		ret:AddDamage(SpaceDamage(p2))
		return ret
	end
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)
	local backwards = (dir + 2) % 4
	for i = DIR_START, DIR_END do
		if p1:Manhattan(p1) ~= 1 or i ~= backwards then
			local dam = SpaceDamage(p1 + DIR_VECTORS[i], 0)
			if self.Push == 1 then dam.iPush = i end
			dam.sAnimation = PUSH_ANIMS[i]
			if self.PushAnimation == 1 then dam.sAnimation = PUSHEXPLO1_ANIMS[i]   --JUSTIN ADDED
			elseif self.PushAnimation == 2 then dam.sAnimation = PUSHEXPLO2_ANIMS[i] end
			
			if not self.BuildingDamage and Board:IsBuilding(p1 + DIR_VECTORS[i]) then		-- Target Buildings - 
				dam.iDamage = 0
			end
			ret:AddDamage(dam)
		end
	end
	ret:AddLeap(move, FULL_DELAY)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)

	local damage = SpaceDamage(p2, self.SelfDamage)
	damage.sAnimation = self.SelfAnimation
	damage.iSmoke = EFFECT_CREATE
	ret:AddDamage(damage)
	ret:AddBounce(p1,3)
	
	return ret
end

function AngryM_Tornado_Nitro_Wep:GetSecondTargetArea(p1,p2)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 1, 8 do
			local curr = Point(p2 + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			
			ret:push_back(curr)
			
			if Board:IsBlocked(curr, PATH_PROJECTILE) and not (Board:IsPawnSpace(curr) and Board:IsPawnTeam(curr,TEAM_PLAYER)) and curr ~= p1 then
				break
			end
		end
	end
	return ret
end

function AngryM_Tornado_Nitro_Wep:GetFinalEffect(p1, p2, p3)
	local ret = self:GetSkillEffect(p1,p2)
	local direction = GetDirection(p3 - p2)
	local backwards = (direction + 2) % 4
	local dam = SpaceDamage(p2-DIR_VECTORS[direction], 0)
	dam.sAnimation = "airpush_"..backwards
	ret:AddDamage(dam)
	local pathing = PATH_PROJECTILE
	if self.Fly == 0 then pathing = Pawn:GetPathProf() end
	local doDamage = true
	local target = GetProjectileEnd(p2,p3,pathing)
	if target == p1 then -- dont attack yourself, keep going
		local temp_target = GetProjectileEnd(target,target + DIR_VECTORS[direction],pathing)
		target = temp_target
	end
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	local distance = p2:Manhattan(target)
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "ExploAir1"
	damage.sSound = self.ImpactSound
	if distance == 1 and doDamage then
		ret:AddMelee(p2,damage, NO_DELAY)
		if doDamage then ret:AddDamage(SpaceDamage( target - DIR_VECTORS[direction] , self.SelfDamage)) end
	else
		ret:AddCharge(Board:GetPath(p2, target - DIR_VECTORS[direction],PATH_FLYER), NO_DELAY)--FULL_DELAY)
		local temp = p2 
		while temp ~= target  do 
			ret:AddBounce(temp,-3)
			temp = temp + DIR_VECTORS[direction]
			if temp ~= target then
				ret:AddDelay(0.06)
			end
		end
		if doDamage then
			ret:AddDamage(damage)
			ret:AddDamage(SpaceDamage( target - DIR_VECTORS[direction] , self.SelfDamage))
		end
	end
	return ret
end