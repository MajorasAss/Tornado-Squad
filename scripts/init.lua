local mod = {
	id = "AngryM_Tornado_Squad",
	name = "Turbulent Tricksters",
	version = "0",
	requirements = {},
	icon = "img/mod_icon.png"
}

function mod:init()
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
