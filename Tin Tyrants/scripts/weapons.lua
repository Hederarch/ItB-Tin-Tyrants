
local path = mod_loader.mods[modApi.currentMod].resourcePath

modApi:appendAsset("img/weapons/disperser_icon.png", path .."img/weapons/disperser_icon.png")
modApi:appendAsset("img/weapons/commune_icon.png", path .."img/weapons/commune_icon.png")
modApi:appendAsset("img/weapons/silodrop_icon.png", path .."img/weapons/silodrop_icon.png")
modApi:appendAsset("img/effects/shot_assembly.png", path .."img/effects/shot_assembly.png")
modApi:appendAsset("img/effects/shotup_no_missile.png", path .."img/effects/shotup_no_missile.png")
modApi:appendAsset("img/combat/structures/str_fort_on.png", path .."img/structures/str_fort_on.png")
modApi:appendAsset("img/combat/structures/str_fort_off.png", path .."img/structures/str_fort_off.png")
modApi:appendAsset("img/combat/structures/str_fort_broken.png", path .."img/structures/str_fort_broken.png")

TT_GroupLoader = ArtilleryDefault:new{
	Name = "Commune Cannon",
	Description = "Fires an artillery that gains damage for every adjacent Building and Mech.",
	Class = "Ranged",
	Icon = "weapons/commune_icon.png",
	Range = RANGE_ARTILLERY,	
	ArtilleryStart = 2,
	ArtillerySize = 8,
	BounceAmount = 3,
	BounceOuterAmount = 0,  --REMOVED BECAUSE CAUSES RENDER ORDER ISSUE IF PUSHING UNITS DOWN/LEFT
	BuildingDamage = true,
	Gain = 1,
	Push = 1,
	DamageOuter = 0,
	DamageCenter = 0,
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	Damage = 4,---USED FOR TOOLTIPS
	MinDamage = 0, ---USED FOR TOOLTIPS
	Upgrades = 2,
	UpgradeCost = { 2, 2 },
	UpgradeList = { "+1 Base Damage",  "+1 Damage Gain"  },
	Explosion = "",
	ExplosionCenter = "ExploArt1",
	ExplosionOuter = "",
	OuterAnimation = "airpush_",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,4),
		Friendly1 = Point(3,3),
		Friendly2 = Point(1,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

function TT_GroupLoader:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2,self.MinDamage)
	local delay = 0
	damage.sAnimation = self.ExplosionCenter
	
	for dir = 0, 3 do
	local curr = (p1 + DIR_VECTORS[dir])
		if Board:IsBuilding(curr) or Board:IsPawnTeam(curr,TEAM_PLAYER) then
			damage.iDamage = damage.iDamage + self.Gain
			Board:Ping(curr,GL_Color(250, 250, 250, 0.2))
			local dummy = SpaceDamage(p1,0)
			delay = delay + 0.1
			dummy.bHidePath = true
			ret:AddBounce(curr,-4)
			ret:AddArtillery(curr,dummy,"effects/shot_assembly.png",0.1)
		end
	end
	
	ret:AddDelay(delay + 0.5)
	
	if not self.BuildingDamage and Board:IsBuilding(p2) then		-- Target Buildings - 
		damage.iDamage = DAMAGE_ZERO
	end
	
	if damage.iDamage > 0 then
		ret:AddBounce(p1, 5)
		ret:AddArtillery(damage, "effects/shotup_tribomb_missile.png")
	else
		damage.sAnimation = ""
		ret:AddArtillery(damage, "effects/shotup_no_missile.png")
	end
	
	local damagepush = SpaceDamage(p2 + DIR_VECTORS[(direction+1)%4], 0, (direction+1)%4)
	damagepush.sAnimation = "airpush_"..((direction+1)%4)
	ret:AddDamage(damagepush) 
	damagepush = SpaceDamage(p2 + DIR_VECTORS[(direction-1)%4], 0, (direction-1)%4)
	damagepush.sAnimation = "airpush_"..((direction-1)%4)
	ret:AddDamage(damagepush)

	return ret
end	

TT_GroupLoader_A = TT_GroupLoader:new{
	UpgradeDescription = "Increases minimum damage by 1.",
	Damage = 5,
	MinDamage = 1, 
	ExplosionCenter = "ExploArt2",
}

TT_GroupLoader_B = TT_GroupLoader:new{
	UpgradeDescription = "Increases the added damage from allies by 1 each.",
	Damage = 8,
	MinDamage = 0,
	Gain = 2,
		ExplosionCenter = "ExploArt2",
}

TT_GroupLoader_AB = TT_GroupLoader:new{
	Damage = 9,
	MinDamage = 1, 
	Gain = 2,
	ExplosionCenter = "ExploArt3",
}

TT_BigBlaster = Skill:new{
	Name = "Disperser",
	Description = "Fires a shotgun with intense recoil, pushing back the Mech that uses it.",
	Icon = "weapons/disperser_icon.png",
	Class = "Prime",
	Damage = 2,
	PathSize = 1,
	Upgrades = 2,
	UpgradeCost = { 1, 2 },
	UpgradeList = { "Brace",  "+1 Damage"  },
	Brace = false,
	LaunchSound = "/weapons/localized_burst",
	TipImage = {
		Unit = Point(2,3),
		Enemy1 = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
	}
}

function TT_BigBlaster:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "explopush2_"..direction
	ret:AddDamage(damage)
	local kick = SpaceDamage(p2 + DIR_VECTORS[direction], self.Damage - 1, direction)
	kick.sAnimation = "explopush1_"..direction
	ret:AddDamage(kick)
	
	local recoil = SpaceDamage(p1,0, (direction-2)%4)
	recoil.sAnimation = "airpush_"..(direction-2)%4
	
	if Board:IsBuilding(p1 - DIR_VECTORS[direction]) and self.Brace then
		local shield = SpaceDamage(p1,0)
		shield.iShield = EFFECT_CREATE
		shield.sAnimation = "airpush_"..(direction-2)%4
		ret:AddDamage(shield)
		shield.loc = p1 - DIR_VECTORS[direction]
		ret:AddDamage(shield)
	else
		ret:AddDamage(recoil)
	end
	return ret
end

TT_BigBlaster_A = TT_BigBlaster:new{
	UpgradeDescription = "When recoil would push the user into a Building, shield them both.",
	Brace = true,
	TipImage = {
		Unit = Point(2,3),
		Enemy1 = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
		Building = Point(2,4),
	}
}

TT_BigBlaster_B = TT_BigBlaster:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

TT_BigBlaster_AB = TT_BigBlaster:new{
	Brace = true,
	Damage = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy1 = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
		Building = Point(2,4),
	}
}

TT_SiloDrop = LineArtillery:new{ 
	Name = "Silo Drop",
	Description = "Fires a missile from any silo, or creates a silo under the shooter.",
	Icon = "weapons/silodrop_icon.png",
	Class = "Science",
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	TwoClick = true,
	BuildingDamage = true,
	Range = 2,
	Explosion = "",
	PowerCost = 1,
	BumpDamage = 1,
	DeployTile = "square_missilesilo2.png",
	Damage = 2,
	Upgrades = 2,
	UpgradeList = { "+1 Damage",  "+1 Range"  },
	UpgradeCost	= { 2, 1 },
	CustomTipImage = "TT_Silo_Showcase_Tip",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2),
	},
}

TT_Silo_Showcase_Tip = TT_SiloDrop:new{
	TwoClick = false,
}

function TT_Silo_Showcase_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dummy = SpaceDamage(p1,0)
	ret:AddScript(string.format("Board:SetCustomTile(Point(%d,%d),\"%s\")",p1.x,p1.y,self.DeployTile))
	dummy.iTerrain = TERRAIN_ROAD
	dummy.sAnimation = "explodrill"
	ret:AddBounce(p1,6)

	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],self.BumpDamage, dir)
		if Board:IsBuilding(p2 + DIR_VECTORS[dir]) and not self.BuildingDamage then
			damage.iDamage = DAMAGE_ZERO
			damage.sAnimation = "airpush_"..dir
		else
			damage.sAnimation = "explopush1_"..dir
		end
		ret:AddDamage(damage)
	end
	
	ret:AddDamage(dummy)
	
	ret:AddDelay(0.5)
	ret:AddMove(Board:GetPath(Point(2,2), Point(2,3), PATH_GROUND), FULL_DELAY)
	ret:AddDelay(0.5)
	
	ret:AddBounce(p2,5)
	local launch = SpaceDamage(Point(2,0), self.Damage)
	launch.sAnimation = "ExploArt2"
	ret:AddArtillery(p2, launch, "effects/shotup_tricrack.png")
	for dir = 0, 3 do
		local damagepush = SpaceDamage(Point(2,0) + DIR_VECTORS[dir], 0, dir)
		damagepush.sAnimation = "airpush_".. dir
		ret:AddDamage(damagepush)
	end

	return ret
end

function TT_SiloDrop:GetTargetArea(point)  --This is a copy of the GetTargetArea for LineArtillery
	local ret = PointList()
	
	if not Board:IsTerrain(point,TERRAIN_WATER) and not Board:IsTerrain(point,TERRAIN_ACID) and not Board:IsTerrain(point,TERRAIN_LAVA) then
		ret:push_back(point)
	end
	
	local board_size = Board:GetSize()
	for i = 0, 7 do
		for j = 0, 7  do
			local point = Point(i,j)
			if Board:GetCustomTile(point) == self.DeployTile then
				ret:push_back(point)
			end
		end
	end
	
	return ret
end


function TT_SiloDrop:IsTwoClickException(p1,p2)
	if p1 ~= p2 then
		-- when twoclick proceeds to second target area
		return false
	end
	-- stops twoclick and executes
	return true
end


function TT_SiloDrop:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dummy = SpaceDamage(p1,0)
	if p1 == p2 then
		ret:AddScript(string.format("Board:SetCustomTile(Point(%d,%d),\"%s\")",p1.x,p1.y,self.DeployTile))
		dummy.iTerrain = TERRAIN_ROAD
		dummy.sAnimation = "explodrill"
		ret:AddBounce(p1,6)
		for dir = 0, 3 do
			damage = SpaceDamage(p2 + DIR_VECTORS[dir],self.BumpDamage, dir)
			if Board:IsBuilding(p2 + DIR_VECTORS[dir]) and not self.BuildingDamage then
				damage.iDamage = DAMAGE_ZERO
				damage.sAnimation = "airpush_"..dir
			else
				damage.sAnimation = "explopush1_"..dir
			end
			ret:AddDamage(damage)
		end
	end
	ret:AddDamage(dummy)
	return ret
end

function TT_SiloDrop:GetSecondTargetArea(p1, p2)
	return general_DiamondTarget(p2,self.Range)
end

function TT_SiloDrop:GetFinalEffect(p1, p2, p3)
	local ret = self:GetSkillEffect(p1,p2)
	ret:AddBounce(p2,5)
	if Board:IsPawnSpace(p2) then
		local backfire = SpaceDamage(p2,self.Damage)
		backfire.sAnimation = "ExploArt2"
		backfire.sImageMark = "advanced/combat/icons/icon_throwblocked_glow.png"
		ret:AddDamage(backfire)
		return ret
	end
	if Board:IsValid(p3) then
		local launch = SpaceDamage(p3, self.Damage)
		launch.sAnimation = "ExploArt2"
		ret:AddArtillery(p2, launch, "effects/shotup_tricrack.png")
		for dir = 0, 3 do
			local damagepush = SpaceDamage(p3 + DIR_VECTORS[dir], 0, dir)
			damagepush.sAnimation = "airpush_".. dir
			ret:AddDamage(damagepush)
		end
	end
	
	return ret
end

TT_SiloDrop_A = TT_SiloDrop:new{
		UpgradeDescription = "Increases missile damage by 1.",
		Damage = 3, 
}

TT_SiloDrop_B = TT_SiloDrop:new{
		UpgradeDescription = "Missiles can now travel farther.",
		Range = 3,
}

TT_SiloDrop_AB = TT_SiloDrop:new{
		Damage = 3, 
		Range = 3,
}

function general_DiamondTarget(center, size)

	local ret = PointList()
	
	local corner = center - Point(size, size)
	
	local p = Point(corner)
		
	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = center - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and dist <= size then
			ret:push_back(p)
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end
	
	return ret
	
end