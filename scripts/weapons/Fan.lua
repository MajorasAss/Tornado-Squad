
modApi:copyAsset("img/combat/icons/icon_smoke_immune_glow.png", "img/combat/icons/Nico_Smoke_remove.png")
Location["combat/icons/Nico_Smoke_remove.png"] = Point(-10,9)
AngryM_Tornado_Fan_Wep = Skill:new{
	Name = "Ventus Turbine",
	Description = "Pushes 3 units in front of Mech outwards, pushes the unit behind Mech inwards.",
	Class = "Science",
	Icon = "weapons/prime_sword.png",
	Rarity = 1,
	PathSize = 1,
	Damage = 0,
	Push = 1,
	BackShield = false,
	Spread = false,
	PowerCost = 0, --AE Change
	Upgrades = 2,
	UpgradeCost = { 1, 2},
 	UpgradeList = { "Anti-Bumps", "Spread" },
	LaunchSound = "/weapons/wind",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,4),
		Target = Point(2,2)
	}
}
AngryM_Tornado_Fan_Wep_A = AngryM_Tornado_Fan_Wep:new{UpgradeDescription = "if pushing the tile behing Mech would cause a bump, shields Mech.",BackShield=true}
AngryM_Tornado_Fan_Wep_B = AngryM_Tornado_Fan_Wep:new{UpgradeDescription = "Spreads the effects of the tile behing Mech to the 3 tiles infront, smoke gets removed, fire, A.C.I.D. and ice do not.", Spread=true}
AngryM_Tornado_Fan_Wep_AB = AngryM_Tornado_Fan_Wep_B:new{BackShield=true}

AngryM_Tornado_Fan_Wep_B.TipImage = {
	Unit = Point(2,3),
	Enemy = Point(2,2),
	Enemy2 = Point(3,2),
	Enemy3 = Point(2,4),
	Enemy4 = Point(3,3),
	Fire = Point(2,4),
	Smoke = Point(1,3),
	Second_Origin = Point(2,3),
	Target = Point(2,2),
	Second_Target = Point(3,3),
}
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
		if self.Spread and Board:IsSmoke(damage.loc) then damage.iSmoke = EFFECT_REMOVE damage.sImageMark = "combat/icons/Nico_Smoke_remove.png" end
		damage.iPush = direction
		ret:AddEmitter(damage.loc,"Emitter_Wind_"..direction)
		ret:AddAnimation(damage.loc,"airpush_"..GetDirection(p1 - p2), ANIM_REVERSE)
		ret:AddDelay(0.1)
		ret:AddDamage(damage)
		damage.sImageMark = ""
		damage.iSmoke = 0
		if self.Spread then
			if Board:IsFire(damage.loc) then damage.iFire = 1 end
			if Board:IsSmoke(damage.loc) then damage.iSmoke = 1 end
			if Board:IsAcid(damage.loc)	then damage.iAcid = 1 end
			if Board:IsFrozen(damage.loc) then damage.iFrozen = 1 end
		end
	end
	damage.sAnimation = "airpush_"..direction
	damage.iPush = direction
	damage.loc = p2
	ret:AddDamage(damage)
	damage.loc = p2 + DIR_VECTORS[(direction + 1)% 4]
	ret:AddDamage(damage)
	damage.loc = p2 - DIR_VECTORS[(direction + 1)% 4]
	ret:AddDamage(damage)
	
	return ret
end