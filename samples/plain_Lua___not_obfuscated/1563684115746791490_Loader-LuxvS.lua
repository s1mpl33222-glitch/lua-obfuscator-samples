--[[

██╗     ██╗   ██╗██╗  ██╗██╗   ██╗███████╗     ██████╗ ██████╗ ███╗   ███╗███╗   ███╗██╗   ██╗███╗   ██╗██╗████████╗██╗   ██╗
██║     ██║   ██║╚██╗██╔╝██║   ██║██╔════╝    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██║   ██║████╗  ██║██║╚══██╔══╝╚██╗ ██╔╝
██║     ██║   ██║ ╚███╔╝ ██║   ██║███████╗    ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║    ╚████╔╝ 
██║     ██║   ██║ ██╔██╗ ██║   ██║╚════██║    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║     ╚██╔╝  
███████╗╚██████╔╝██╔╝ ██╗╚██████╔╝███████║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║      ██║   
╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝      ╚═╝   
Developed by Louissxe - https://louissxe.store - https://www.tiktok.com/@louissxe.store - https://discord.gg/BGV6x4f7Zk
]]--

repeat
	task.wait()
until game:IsLoaded()

local LuxvsHub = {}

LuxvsHub.Universal = "https://raw.githubusercontent.com/louissxe/Lua/main/keyless/Universal.lua"
LuxvsHub.Games = {}

local function RegisterGame(placeIds, name, url)
	for _, placeId in ipairs(placeIds) do
		LuxvsHub.Games[placeId] = {
			name = name,
			url = url
		}
	end
end

RegisterGame(
	{89469502395769},
	"Kick a lucky block",
	"https://raw.githubusercontent.com/louissxe/Lua/main/keyless/kickalucky.lua"
)

RegisterGame(
	{92416421522960},
	"Slime RNG",
	"https://raw.githubusercontent.com/louissxe/Lua/main/keyless/slimerng.lua"
)

RegisterGame(
	{70845479499574},
	"Bite by night",
	"https://raw.githubusercontent.com/louissxe/Lua/main/keyless/bitebynight.lua"
)

RegisterGame(
	{130274245431977},
	"Climb and Plunge",
	"https://raw.githubusercontent.com/louissxe/Lua/main/keyless/ClimbAndPlunge.lua"
)

RegisterGame(
	{111385005478215, 90457367396205},
	"Fish and Monsters",
	"https://raw.githubusercontent.com/louissxe/Lua/main/keyless/fam.lua"
)

function LuxvsHub.Notify(title, text, duration)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 5
		})
	end)
end

function LuxvsHub.Load(url)
	local success, result = pcall(function()
		return loadstring(game:HttpGet(url))()
	end)

	if success then
		LuxvsHub.Notify("LuxvsHub", "Successfully loaded script!", 5)
	else
		LuxvsHub.Notify("LuxvsHub Error", tostring(result), 8)
	end

	return result
end

local gameData = LuxvsHub.Games[game.PlaceId]

LuxvsHub.Notify(
	"LuxvsHub",
	"Loading " .. (gameData and gameData.name or "Universal") .. "...",
	5
)

LuxvsHub.Load(gameData and gameData.url or LuxvsHub.Universal)
