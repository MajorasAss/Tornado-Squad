
AngryM_Tornado_Fan_Wep = Skill:new{
	Name = "Ventus Turbine",
	Description = "Pushes away 3 units in front and pulls the unit behind, or vice versa.",
	Class = "Science",
	Icon = "weapons/prime_sword.png",
	Rarity = 1,
	PathSize = 1,
	Damage = 0,
	Push = 1,
	TwoClick = true,
	BackShield = false,
	Spread = false,
	PowerCost = 0, --AE Change
	Upgrades = 2,
	UpgradeCost = { 1, 2},
 	UpgradeList = { "Auto-Shield", "Spread" },
	LaunchSound = "/weapons/wind",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,4),
		Target = Point(2,2),
		Second_Click = Point(3,2)
	}
}
AngryM_Tornado_Fan_Wep_A = AngryM_Tornado_Fan_Wep:new{UpgradeDescription = "Shield the Mech when taking bump damage.",BackShield=true}
AngryM_Tornado_Fan_Wep_B = AngryM_Tornado_Fan_Wep:new{UpgradeDescription = "Consume the environmental effect of the solo target and spread it to the other three.", Spread=true}
AngryM_Tornado_Fan_Wep_AB = AngryM_Tornado_Fan_Wep_B:new{BackShield = true}

AngryM_Tornado_Fan_Wep_B.TipImage = {
	Unit = Point(2,3),
	Enemy = Point(2,2),
	Enemy2 = Point(3,2),
	Enemy3 = Point(2,4),
	Fire = Point(2,4),
	Target = Point(2,2),
	Second_Click = Point(3,2),
}

function AngryM_Tornado_Fan_Wep:GetSecondTargetArea(p1,p2)
	local ret = PointList()
	local direction = GetDirection(p2 - p1)
	ret:push_back(p2 + DIR_VECTORS[(direction + 1)% 4])
	ret:push_back(p2 - DIR_VECTORS[(direction + 1)% 4])
	ret:push_back(p1-DIR_VECTORS[direction])
	return ret
end

function AngryM_Tornado_Fan_Wep:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p1, self.Damage)
	if Board:IsValid(p1 - DIR_VECTORS[direction]) then
		if self.BackShield and (Board:IsPawnSpace(p1 - DIR_VECTORS[direction]) and not Board:GetPawn(p1 - DIR_VECTORS[direction]):IsGuarding()) then
			damage.iShield = 1
			ret:AddDamage(damage)
			damage.iShield = 0
		end
		damage.loc = p1 - DIR_VECTORS[direction]
		damage.iPush = direction
		ret:AddDelay(0.1)
		ret:AddDamage(damage)
		damage.sImageMark = ""
	end
	damage.sAnimation = "airpush_"..direction
	damage.iPush = direction
	damage.loc = p2
	ret:AddDamage(damage)
	
	return ret
end

function AngryM_Tornado_Fan_Wep:GetFinalEffect(p1,p2,p3)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p1, self.Damage)
	if Board:IsValid(p1 - DIR_VECTORS[direction]) then
		if self.BackShield and (Board:IsPawnSpace(p1 - DIR_VECTORS[direction]) and not Board:GetPawn(p1 - DIR_VECTORS[direction]):IsGuarding()) then
			damage.iShield = 1
			ret:AddDamage(damage)
			damage.iShield = 0
		end
		if p2:Manhattan(p3) == 1 then
			damage.loc = p1 - DIR_VECTORS[direction]
		else
			damage.loc = p2
		end
		if self.Spread then
			if Board:IsSmoke(damage.loc) then damage.iSmoke = EFFECT_REMOVE damage.sImageMark = "combat/icons/Nico_Smoke_remove.png" end
			if Board:IsFire(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsFire()) then damage.iFire = EFFECT_REMOVE damage.sImageMark = "combat/icons/Nico_Fire_remove.png" end
			if Board:IsAcid(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsAcid()) then
				damage.iAcid = 2 damage.sImageMark = "combat/icons/Nico_Acid_remove.png"
				ret:AddScript(string.format("Board:SetAcid(%s,false)", damage.loc:GetString())) end
			if Board:IsFrozen(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsFrozen()) then damage.iFrozen = EFFECT_REMOVE damage.sImageMark = "combat/icons/Nico_Ice_remove.png"
			elseif Board:IsTerrain(damage.loc,TERRAIN_ICE) then
				damage.sImageMark = "combat/icons/Nico_Ice_remove.png"
				ret:AddScript(string.format("Board:SetTerrain(%s, TERRAIN_WATER)", damage.loc:GetString()))
			end
		end
		damage.iPush = direction
		ret:AddEmitter(damage.loc,"Emitter_Wind_"..direction)
		ret:AddAnimation(damage.loc,"airpush_"..GetDirection(p1 - p2), ANIM_REVERSE)
		ret:AddDelay(0.1)
		ret:AddDamage(damage)
		damage.sImageMark = ""
		damage.iSmoke = 0
		if self.Spread then
			if Board:IsFire(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsFire()) then damage.iFire = 1 end
			if Board:IsSmoke(damage.loc) then damage.iSmoke = 1 end
			if Board:IsAcid(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsAcid()) then damage.iAcid = 1 end
			if Board:IsFrozen(damage.loc) or (Board:IsPawnSpace(damage.loc) and Board:GetPawn(damage.loc):IsFrozen()) or Board:IsTerrain(damage.loc,TERRAIN_ICE) then damage.iFrozen = 1 end
		end
	end
	damage.sAnimation = "airpush_"..direction
	damage.iPush = direction
	if p2:Manhattan(p3) == 1 then
		damage.loc = p2
	else
		damage.loc = p1 - DIR_VECTORS[direction]
	end
	ret:AddDamage(damage)
	if p2:Manhattan(p3) == 1 then
		damage.loc = p2 + DIR_VECTORS[(direction + 1)% 4]
		ret:AddDamage(damage)
		damage.loc = p2 - DIR_VECTORS[(direction + 1)% 4]
		ret:AddDamage(damage)
	else
		damage.loc = p1 - DIR_VECTORS[direction] + DIR_VECTORS[(direction + 1)% 4]
		ret:AddDamage(damage)
		damage.loc = p1 - DIR_VECTORS[direction] - DIR_VECTORS[(direction + 1)% 4]
		ret:AddDamage(damage)
	end
	
	return ret
end