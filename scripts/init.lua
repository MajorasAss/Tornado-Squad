local mod = {
	id = "AngryM_Tornado_Squad",
	name = "Turbulent Tricksters",
	version = "0",
	requirements = {},
	icon = "img/mod_icon.png"
}

function mod:init()
	-- rem effect image mark
	modApi:copyAsset("img/combat/icons/icon_smoke_immune_glow.png", "img/combat/icons/Nico_Smoke_remove.png")
	modApi:copyAsset("img/combat/icons/icon_acid_immune_glow.png", "img/combat/icons/Nico_Acid_remove.png")
	modApi:copyAsset("img/combat/icons/icon_fire_immune_glow.png", "img/combat/icons/Nico_Fire_remove.png")
	modApi:appendAsset("img/combat/icons/Nico_Ice_remove.png", self.resourcePath .."img/icon_frozen_immune.png")
	Location["combat/icons/Nico_Ice_remove.png"] = Point(-10,8)
	Location["combat/icons/Nico_Smoke_remove.png"] = Point(-10,8)
	Location["combat/icons/Nico_Acid_remove.png"] = Point(-10,8)
	Location["combat/icons/Nico_Fire_remove.png"] = Point(-10,8)
	modApi:copyAsset("img/combat/icons/icon_mind_glow.png", "img/combat/icons/Nico_icon_mind_glow.png")
	Location["combat/icons/Nico_icon_mind_glow.png"] = Point(-12,12)
	modApi:addPalette{
        Image = "img/units/player/AngryM_Tornado_gust_ns.png",
		ID = "AngryM_Tornado_Palette",
		Name = "Turbulent Tricksters' Amethist",
		PlateHighlight = {30,220,230},--lights
		PlateLight     = {118,96,146},--main highlight
		PlateMid       = {84,59,114},--main light
		PlateDark      = {45,22,75},--main mid
		PlateOutline   = {26,6,50},--main dark
		BodyHighlight  = {231,165,33},--metal light
		BodyColor      = {161,78,16},--metal mid
		PlateShadow    = {90,31,5},--metal dark
	}
	require(self.scriptPath .."pawns")
	require(self.scriptPath .."assets")
	require(self.scriptPath .."weapons/weapons")
end

function mod:load(options, version)
    -- after we have added our mechs, we can add a squad using them.
	modApi:addSquad(
		{
			"Turbulent Tricksters",-- title
			"AngryM_Tornado_Rotor",-- mech #1
			"AngryM_Tornado_Fan",-- mech #3
			"AngryM_Tornado_Bike",-- mech #2
		},
		"Turbulent Tricksters",
		"To Be Added UwU.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
