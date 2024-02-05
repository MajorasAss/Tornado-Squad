AngryM_Tornado_Nitro_Wep = Leap_Attack:new{
	Class = "Brute",
	Icon = "weapons/brute_boosters.png",	
	Rarity = 1,
	Range = 2,
	PowerCost = 0,
	TwoClick = true,
	Upgrades =0,
	Push = 0,
	SelfDamage = 0,
	LaunchSound = "/weapons/boosters",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
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
	
	return ret
end

function AngryM_Tornado_Nitro_Wep:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)
	ret:AddLeap(move, FULL_DELAY)
	ret:AddBurst(p2,"Emitter_Burst_$tile",DIR_NONE)
	
	local backwards = (dir + 2) % 4
	for i = DIR_START, DIR_END do
		if p1:Manhattan(p2) ~= 1 or i ~= backwards then
			local dam = SpaceDamage(p2 + DIR_VECTORS[i], 0)
			if self.Push == 1 then dam.iPush = i end
			dam.sAnimation = PUSH_ANIMS[i]
			if self.PushAnimation == 1 then dam.sAnimation = PUSHEXPLO1_ANIMS[i]   --JUSTIN ADDED
			elseif self.PushAnimation == 2 then dam.sAnimation = PUSHEXPLO2_ANIMS[i] end
			
			if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[i]) then		-- Target Buildings - 
				dam.iDamage = 0
			end
			ret:AddDamage(dam)
		end
	end

	local damage = SpaceDamage(p2, self.SelfDamage)
	damage.sAnimation = self.SelfAnimation
	if self.SelfDamage ~= 0 then ret:AddDamage(damage) end
	ret:AddBounce(p2,3)
	
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
			
			if Board:IsBlocked(curr, PATH_PROJECTILE) then
				break
			end
		end
	end
	
	ret:push_back(p1)
	self:RemoveBackwards(ret,p1,p2)
	return ret
end

function AngryM_Tornado_Nitro_Wep:GetFinalEffect(p1, p2, p3)
	local ret = self:GetSkillEffect(p1,p2)
	if p1 == p3 then return ret end
	
	local direction = GetDirection(p3 - p2)

	local pathing = PATH_PROJECTILE
	if self.Fly == 0 then pathing = Pawn:GetPathProf() end

	local doDamage = true
	local target = GetProjectileEnd(p2,p3,pathing)
	local distance = p2:Manhattan(target)
	
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	if self.BackSmoke == 1 then
		local smoke = SpaceDamage(p2 - DIR_VECTORS[direction], 0)
		smoke.iSmoke = 1
		ret:AddDamage(smoke)
	end
	
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "ExploAir2"
	damage.sSound = self.ImpactSound
	
	if distance == 1 and doDamage then
		ret:AddMelee(p2,damage, NO_DELAY)
		if doDamage then ret:AddDamage(SpaceDamage( target - DIR_VECTORS[direction] , self.SelfDamage)) end
	else
		ret:AddCharge(Board:GetSimplePath(p2, target - DIR_VECTORS[direction]), NO_DELAY)--FULL_DELAY)

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