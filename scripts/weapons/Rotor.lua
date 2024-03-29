-------------- Prime - Spinfist ---------------------------

local customAnim = require(mod_loader.mods[modApi.currentMod].scriptPath .."libs/customAnim")
require(mod_loader.mods[modApi.currentMod].scriptPath .."libs/status")
AngryM_Tornado_Rotor_Wep = Skill:new{
	Name = "Mercury Rotor",
	Class = "Brute",
	Icon = "weapons/prime_spinfist.png",
	Description = "Push all adjacent tiles to the left or right.",
	Rarity = 3,
	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 0,
	Push = 1,
	TwoClick = true,
	Halt = false,
	Flame = false,
	PowerCost = 0, --AE Change
	Upgrades = 2,
	Confusion = false,
	ZoneTargeting = ZONE_ALL,
 	UpgradeList = { "Halt and Flame","Confusion"},
	UpgradeCost = { 2 , 2 },
	TipImage = {
		Unit = Point(2,2),
		Enemy1 = Point(2,1),
		Target = Point(2,1),
		Enemy2 = Point(1,2),
		Smoke = Point(3,2),
		Friendly = Point(1,3),
		Building = Point(1,1),
		Second_Click = Point(1,1),
		CustomPawn = "AngryM_Tornado_Rotor",
	}
}

function AngryM_Tornado_Rotor_Wep:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
	end
	return ret
end

function AngryM_Tornado_Rotor_Wep:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p1,0)
	
	for i = DIR_START,DIR_END do
		damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage)
		ret:AddDamage(damage)
	end
	
	return ret
end	

function AngryM_Tornado_Rotor_Wep:GetSecondTargetArea(p1,p2)
	-- Force you to target left or right for your click#1
	local ret = PointList()
	local dir = GetDirection(p2 - p1)
	ret:push_back(p2+DIR_VECTORS[(dir+1)%4])
	ret:push_back(p2+DIR_VECTORS[(dir+3)%4])
	return ret
end

function AngryM_Tornado_Rotor_Wep:GetCollateral(q1)
	if Board:IsBuilding(q1) then
		return true
	elseif (Board:IsPawnSpace(q1) and Board:IsPawnTeam(q1, TEAM_MECH)) then--mechs can tank damage whereas most allied units cannot
		return false
	elseif (Board:IsPawnSpace(q1) and Board:IsPawnTeam(q1, TEAM_PLAYER)) then
		return true
	else
		return false
	end
end

function AngryM_Tornado_Rotor_Wep:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local aim = GetDirection(p2 - p1)
	local turn = GetDirection(p3 - p2)
	local clockwise = ((aim - turn)%4==3)
	local damage = SpaceDamage(p1, 0)
	local collat = Point(-1,-1)
	if clockwise then
		for i = DIR_START,DIR_END do
			collat = p1 + DIR_VECTORS[i]+DIR_VECTORS[(i+1)%4]
			if self.Halt and self:GetCollateral(collat) or (Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_PLAYER) and not Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_MECH)) then
				damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage)
				damage.sAnimation = "airpush_"..(i+1)%4
			else
				damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage, (i+1)%4)
				damage.sAnimation = "airpush_"..(i+1)%4
			end
			if Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_ENEMY) and self.Confusion then
				damage.sImageMark = "combat/icons/Nico_icon_mind_glow.png"
				ret:AddScript(string.format("Status.ApplyConfusion(%s, 3)", Board:GetPawn(p1 + DIR_VECTORS[i]):GetId()))
			end
			if self.Flame and Board:IsSmoke(damage.loc) then
				if not (Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_ENEMY) and self.Confusion) then
					damage.sImageMark = "combat/icons/Nico_Smoke_remove.png" end
				damage.iSmoke = EFFECT_REMOVE
				local flame1 = SpaceDamage(p1 + DIR_VECTORS[i]+DIR_VECTORS[(i+1)%4],0)
				flame1.iFire = EFFECT_CREATE
				ret:AddDamage(flame1)
				local flame2 = SpaceDamage(p1 + DIR_VECTORS[i]+DIR_VECTORS[(i+1)%4]+DIR_VECTORS[(i+1)%4],0)
				flame2.sAnimation = "flamethrower2_"..((i+1)%4)
				flame2.iFire = EFFECT_CREATE
				ret:AddDamage(flame2)
			end
			ret:AddDamage(damage)
			damage.sImageMark = ""
		end
	else
		for i = DIR_START,DIR_END do
			collat = p1 + DIR_VECTORS[i]+DIR_VECTORS[(i-1)%4]
			damage.sAnimation = "airpush_"..(i-1)%4
			if self.Halt and self:GetCollateral(collat) or (Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_PLAYER) and not Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_MECH)) then
				damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage)
				damage.sAnimation = "airpush_"..(i-1)%4
			else
				damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage, (i-1)%4)
				damage.sAnimation = "airpush_"..(i-1)%4
			end
			if Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_ENEMY) and self.Confusion then
				damage.sImageMark = "combat/icons/Nico_icon_mind_glow.png"
				ret:AddScript(string.format("Status.ApplyConfusion(%s, 3)", Board:GetPawn(p1 + DIR_VECTORS[i]):GetId()))
			end
			if self.Flame and Board:IsSmoke(damage.loc) then
				if not (Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_ENEMY) and self.Confusion) then
					damage.sImageMark = "combat/icons/Nico_Smoke_remove.png" end
				damage.iSmoke = EFFECT_REMOVE
				local flame1 = SpaceDamage(p1 + DIR_VECTORS[i]+DIR_VECTORS[(i-1)%4],0)
				flame1.iFire = EFFECT_CREATE
				ret:AddDamage(flame1)
				local flame2 = SpaceDamage(p1 + DIR_VECTORS[i]+DIR_VECTORS[(i-1)%4]+DIR_VECTORS[(i-1)%4],0)
				flame2.sAnimation = "flamethrower2_"..(((i-1))%4)
				flame2.iFire = EFFECT_CREATE
				ret:AddDamage(flame2)
			end
			ret:AddDamage(damage)
			damage.sImageMark = ""
		end
	end
	
	return ret
end

AngryM_Tornado_Rotor_Wep_A = AngryM_Tornado_Rotor_Wep:new{
	UpgradeDescription = "Avoids pushing targets into buildings and non-Mech allies. Ignites Smoke, removing it.",
	Halt = true,
	Flame = true,
}

AngryM_Tornado_Rotor_Wep_B = AngryM_Tornado_Rotor_Wep:new{
	UpgradeDescription = "Confuses all enemy targets, making them make bad choices for 3 turns. Like targeting other Vek.",
	Confusion = true,
}

AngryM_Tornado_Rotor_Wep_AB = AngryM_Tornado_Rotor_Wep_B:new{
	Halt = true,
	Flame = true,
}