local mod = modApi:getCurrentMod()

local palette = {
    id = mod.id,
    name = "Sovereign Silver", 
    image = "img/units/player/riot_mech.png", --change MyMech by the name of the mech you want to display
    colorMap = {
        lights =         { 89, 208, 208 }, --PlateHighlight
        main_highlight = { 89, 125,  122 }, --PlateLight
        main_light =     {  37,  63,  68 }, --PlateMid
        main_mid =       {  19,  32,  45 }, --PlateDark
        main_dark =      {  9,  18,  35 }, --PlateOutline
        metal_light =    { 164,  173,  189 }, --BodyHighlight
        metal_mid =      {  104,  107,  123 }, --BodyColor
        metal_dark =     {  45, 45, 59 }, --PlateShadow
    },
}

modApi:addPalette(palette)

 