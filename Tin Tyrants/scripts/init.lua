
local mod = {
	id = "hedera_militia_squad",
	name = "Tin Tyrants", 
	version = "1.0.0",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	require(self.scriptPath .."palettes")
	require(self.scriptPath .."pawns")
	require(self.scriptPath .."weapons")
	
end

    modApi:addWeaponDrop("DEMO_PrimeSkill")
    modApi:addWeaponDrop("DEMO_RangedSkill")
    modApi:addWeaponDrop("DEMO_BruteSkill")

function mod:load(options, version)
	modApi:addSquad(
		{
			"Tin Tyrants",		
			"TT_RiotMech",			
			"TT_LoaderMech",			
			"TT_ArmoryMech"			
		},
		"Tin Tyrants",
		"A squad which harnesses local infrastructure to fuel its powerful defenses.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
