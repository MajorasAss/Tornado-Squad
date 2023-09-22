
-- this line just gets the file path for your mod, so you can find all your files easily.

local path = mod_loader.mods[modApi.currentMod].resourcePath
-- locate our mech assets.
local mechPath = "img/units/player/"
-- make a list of our files.
local files = {
	"AngryM_Tornado_nitro.png",
	"AngryM_Tornado_nitro_a.png",
	"AngryM_Tornado_nitro_w.png",
	"AngryM_Tornado_nitro_w_broken.png",
	"AngryM_Tornado_nitro_broken.png",
	"AngryM_Tornado_nitro_ns.png",
	"AngryM_Tornado_nitro_h.png",
	"AngryM_Tornado_tornado.png",
	"AngryM_Tornado_tornado_a.png",
	"AngryM_Tornado_tornado_w.png",
	"AngryM_Tornado_tornado_w_broken.png",
	"AngryM_Tornado_tornado_broken.png",
	"AngryM_Tornado_tornado_ns.png",
	"AngryM_Tornado_tornado_h.png",
	"AngryM_Tornado_gust.png",
	"AngryM_Tornado_gust_a.png",
	"AngryM_Tornado_gust_w_broken.png",
	"AngryM_Tornado_gust_broken.png",
	"AngryM_Tornado_gust_ns.png",
	"AngryM_Tornado_gust_h.png",
}
for _, file in ipairs(files) do
	modApi:appendAsset(mechPath.. file, path .."img/units/player/".. file)
end
local a=ANIMS
--Nitro
	a.AngryM_Tornado_nitro =a.MechUnit:new{Image="units/player/AngryM_Tornado_nitro.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_nitroa = a.MechUnit:new{Image="units/player/AngryM_Tornado_nitro_a.png",  PosX = -17, PosY = -1, NumFrames = 7 }
	a.AngryM_Tornado_nitrow = a.MechUnit:new{Image="units/player/AngryM_Tornado_nitro_w.png", PosX = -17, PosY = 10}
	a.AngryM_Tornado_nitro_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_nitro_broken.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_nitrow_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_nitro_w_broken.png", PosX = -17, PosY = 10 }
	a.AngryM_Tornado_nitro_ns = a.MechIcon:new{Image="units/player/AngryM_Tornado_nitro_ns.png" }
--Tornado
	a.AngryM_Tornado_tornado =	a.MechUnit:new{Image = "units/player/AngryM_Tornado_tornado.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_tornadoa =	a.MechUnit:new{Image = "units/player/AngryM_Tornado_tornado_a.png", PosX = -17, PosY = -1, NumFrames = 4, Time = 0.2}
	a.AngryM_Tornado_tornadow =	a.MechUnit:new{Image = "units/player/AngryM_Tornado_tornado_w.png", PosX = -17, PosY = 10}
	a.AngryM_Tornado_tornado_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_tornado_broken.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_tornadow_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_tornado_w_broken.png", PosX = -17, PosY = 10 }
	a.AngryM_Tornado_tornado_ns = a.MechIcon:new{Image="units/player/AngryM_Tornado_tornado_ns.png" }
--Gust
	a.AngryM_Tornado_gust =a.MechUnit:new{Image="units/player/AngryM_Tornado_gust.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_gusta = a.MechUnit:new{Image="units/player/AngryM_Tornado_gust_a.png",  PosX = -17, PosY = -1, NumFrames = 5 }
	a.AngryM_Tornado_gust_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_gust_broken.png", PosX = -17, PosY = -1}
	a.AngryM_Tornado_gustw_broken = a.MechUnit:new{Image="units/player/AngryM_Tornado_gust_w_broken.png", PosX = -17, PosY = 10 }
	a.AngryM_Tornado_gust_ns = a.MechIcon:new{Image="units/player/AngryM_Tornado_gust_ns.png" }