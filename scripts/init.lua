local mod = {
	id = "AngryM_Tornado_Squad",
	name = "Turbulent Tricksters",
	version = "0",
	requirements = {},
	icon = "img/icon.png"
}

function mod:init()
	modApi:addPalette{
        Image = "img/units/player/AngryM_Tornado_gust_ns.png",
		ID = "AngryM_Tornado_Palette",
		Name = "Turbulent Tricksters' Lemon",
		PlateHighlight = {75,229,193},--lights
		PlateLight     = {226,186,46},--main highlight
		PlateMid       = {210,151,36},--main light
		PlateDark      = {118,82,30},--main mid
		PlateOutline   = {27,35,25},--main dark
		BodyHighlight  = {177,211,108},--metal light
		BodyColor      = {76,130,79},--metal mid
		PlateShadow    = {49,74,54},--metal dark
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
