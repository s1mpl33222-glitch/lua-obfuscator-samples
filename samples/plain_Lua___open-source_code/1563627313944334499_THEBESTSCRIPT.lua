
repeat task.wait() until game:IsLoaded()
task.wait()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/aymanabdo0355-ctrl/SUIT/refs/heads/main/EthosSuiterrrrr-obfuscated.lua"))()

local gameName = "Hub"
pcall(function()
	local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	if info and info.Name then
		gameName = info.Name
	end
end)

local Window = Library:CreateWindow({
	Title = "",
	GameName = gameName,
})

local GetScript = Window:AddCategory("GET THE SCRIPT")
local Tab = GetScript:AddTab(gameName)
local Box = Tab:AddGroupbox(gameName)

Box:AddLabel("OVER 100 FEATURES FOR " .. gameName)
Box:AddLabel("NO KEY SYSTEM OR ADS")
Box:AddLabel("Thanks for all the support ❤️ We update every single day!")

Box:AddButton({
	Text = "GET THE SCRIPT HERE",
	Func = function()
		local link = "discord.gg/getzerohub"
		if setclipboard then
			setclipboard(link)
		end

		game.Players.LocalPlayer:Kick(
			"Get The Script Here: discord.gg/getzerohub\n\n" ..
			"Thanks for all the support ❤️\n" ..
			"We Update Every Single Day"
		)
	end,
})
