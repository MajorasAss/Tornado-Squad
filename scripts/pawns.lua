AngryM_Tornado_Rotor = Pawn:new{
	Name = "Tornado Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "AngryM_Tornado_tornado",
    ImageOffset = modApi:getPaletteImageOffset("AngryM_Tornado_Palette"),
	SkillList = { "AngryM_Tornado_Rotor_Wep" },
	SoundLocation = "/mech/distance/artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
AngryM_Tornado_Bike = Pawn:new{
	Name = "Nitro Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 4,
	Image = "AngryM_Tornado_nitro",
    ImageOffset = modApi:getPaletteImageOffset("AngryM_Tornado_Palette"),
	SkillList = {"AngryM_Tornado_Nitro_Wep"},
	SoundLocation = "/mech/brute/charge_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
AngryM_Tornado_Fan = Pawn:new{
	Name = "Gust Mech",
	Class = "Science",
	Health = 3,
	Image = "AngryM_Tornado_gust",
	MoveSpeed = 4,
	Flying = true,
	Armor = true,
    ImageOffset = modApi:getPaletteImageOffset("AngryM_Tornado_Palette"),
	SkillList = { "Ranged_Ice" },
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

--Nitro Mech's movement skill

local original_MoveGetTargetArea = Move.GetTargetArea

local original_MoveGetSkillEffect = Move.GetSkillEffect
function Move:GetSkillEffect(p1, p2)
	local ret

	if Pawn:GetMechName() == "Nitro Mech" then
		ret = AngryM_Tornado_BikeMove:GetSkillEffect(p1, p2)
	else
		ret = original_MoveGetSkillEffect(self, p1, p2)
	end

    return ret
end

AngryM_Tornado_BikeMove = Move:new{}
function AngryM_Tornado_BikeMove:GetSkillEffect(p1, p2)

	local ret = SkillEffect()
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	local pathing = self.Phase and PATH_PHASING or PATH_PROJECTILE
	move:push_back(GetProjectileEnd(p1,p2,pathing))

	ret:AddMove(Board:GetPath(p1, p2, Pawn:GetPathProf()), NO_DELAY)
	local path = extract_table(Board:GetPath(p1, p2, Pawn:GetPathProf()))
	for i = 1, #path do
		local p = path[i]
		ret:AddBounce(p, -2)
		ret:AddBurst(p,"Emitter_Crack_Start", DIR_NONE)
		ret:AddDelay(0.05)
	end

	return ret
end