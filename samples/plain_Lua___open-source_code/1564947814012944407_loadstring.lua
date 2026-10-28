local ids = {
	[18901165922] = "PETSGO",
	[8737899170] = "PETSIM99",
	[16498369169] = "PETSIM99",
	[17503543197] = "PETSIM99",
	[85896571713843] = "BGSI",
	[140403681187145] = "PETSIM99",
	[15502339080] = "TRADINGPLAZA",
	[15588442388] = "TRADINGPLAZA"
}

local currentgame = ids[game.PlaceId] or nil
local executorlevel = getthreadidentity() or getthreadcontext() or 0

if executorlevel < 4 then
	warn("EXECUTOR NOT SUPPORTED")
	return
end

if currentgame then
	if currentgame == "PETSGO" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/PetsGo.lua"))()
	elseif currentgame == "PETSIM99" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/PS99.lua"))()
	elseif currentgame == "BGSI" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/VRTBGSI.lua"))()
	end
else
	warn("GAME/PLACE NOT SUPPORTED")
end
