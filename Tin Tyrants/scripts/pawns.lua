
local mod = modApi:getCurrentMod()
local autoOffset = 0

local id = modApi:getPaletteImageOffset(mod.id)
if id ~= nil then
	autoOffset = id
end

local path = mod_loader.mods[modApi.currentMod].resourcePath

local mechPath = path .."img/units/riot/"

local files = {
	"mech.png",
	"mech_a.png",
	"mech_w.png",
	"mech_w_broken.png", 
	"mech_broken.png", 
	"mech_ns.png", 
	"mech_h.png"
}


for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/riot_".. file, mechPath .. file)
end

local a = ANIMS
a.riot_mech =			a.MechUnit:new{Image = "units/player/riot_mech.png", PosX = -20, PosY = -10}
a.riot_mecha =			a.MechUnit:new{Image = "units/player/riot_mech_a.png", PosX = -21, PosY = -4, NumFrames = 4 }
a.riot_mechw =			a.MechUnit:new{Image = "units/player/riot_mech_w.png", PosX = -21, PosY = 6 } 
a.riot_mech_broken =	a.MechUnit:new{Image = "units/player/riot_mech_broken.png", PosX = -21, PosY = -5 }
a.riot_mechw_broken =	a.MechUnit:new{Image = "units/player/riot_mech_w_broken.png", PosX = -21, PosY = 6 }
a.riot_mech_ns =		a.MechIcon:new{Image = "units/player/riot_mech_ns.png"}

mechPath = path .."img/units/loader/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/loader_".. file, mechPath .. file)
end

a.loader_mech =			a.MechUnit:new{Image = "units/player/loader_mech.png", PosX = -20, PosY = -6} 
a.loader_mecha =			a.MechUnit:new{Image = "units/player/loader_mech_a.png", PosX = -21, PosY = -6, NumFrames = 4 }
a.loader_mechw =			a.MechUnit:new{Image = "units/player/loader_mech_w.png", PosX = -19, PosY = 8 }
a.loader_mech_broken =	a.MechUnit:new{Image = "units/player/loader_mech_broken.png", PosX = -22, PosY = -5  }
a.loader_mechw_broken =	a.MechUnit:new{Image = "units/player/loader_mech_w_broken.png", PosX = -21, PosY = 3 }
a.loader_mech_ns =		a.MechIcon:new{Image = "units/player/loader_mech_ns.png"}

mechPath = path .."img/units/armory/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/armory_".. file, mechPath .. file)
end

a.armory_mech =			a.MechUnit:new{Image = "units/player/armory_mech.png", PosX = -23, PosY = -2} 
a.armory_mecha =			a.MechUnit:new{Image = "units/player/armory_mech_a.png", PosX = -24, PosY = -2, NumFrames = 4 }
a.armory_mechw =			a.MechUnit:new{Image = "units/player/armory_mech_w.png", PosX = -22, PosY = 5 } 
a.armory_mech_broken =	a.MechUnit:new{Image = "units/player/armory_mech_broken.png", PosX = -23, PosY = -2 }
a.armory_mechw_broken =	a.MechUnit:new{Image = "units/player/armory_mech_w_broken.png", PosX = -24, PosY = 8 }
a.armory_mech_ns =		a.MechIcon:new{Image = "units/player/armory_mech_ns.png"}

TT_RiotMech = Pawn:new{
	Name = "Riot Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	Armor = true,
	Image = "riot_mech",
	
	ImageOffset = autoOffset,

	SkillList = { "TT_BigBlaster"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

TT_LoaderMech = Pawn:new{
	Name = "Loader Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Massive = true,
	Image = "loader_mech", 
	
	ImageOffset = autoOffset,

	SkillList = {"TT_GroupLoader"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

TT_ArmoryMech = Pawn:new{
	Name = "Armory Mech",
	Class = "Science",
	Health = 3,
	MoveSpeed = 4,
	Massive = true,
	Image = "armory_mech", 
	
	ImageOffset = autoOffset,

	SkillList = {"TT_SiloDrop"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}