-- This file was generated at discord.gg/syncrypt

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/welomenchaina/GoofyScripts/refs/heads/main/Rayfield", true))()
local t1 = {
	Name = "Dicky Wicky Hub",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "DickyWicky"
	}
}
local v3 = lib:CreateWindow(t1):CreateTab("Key System", 4483362458)

v3.CreateInput(v3, {
	Name = "Key",
	PlaceholderText = "Enter Key",
	RemoveTextAfterFocusLost = false,
	Callback = function(p1)
		key = p1
	end
})
v3.CreateButton(v3, {
	Name = "Inject Key",
	Callback = function()
		if key == "IEHOFUHWUEFWI11QOH0822Q11QYR083322QQ22Q0FUOHWIEHFIWPHE9IWY022Q8Y33Q.....DESIREHUBINITIATE" then
			lib:Notify({
				Title = "Key System",
				Content = "Thanks for using Dicky Wicky Hub",
				Duration = 5
			})
			loadstring(game:HttpGet("https://raw.githubusercontent.com/welomenchaina/Desire-Hub-s-Entry/refs/heads/main/DESIREHUB", true))()
		else
			lib:Notify({
				Title = "Key System",
				Content = "Incorrect key press get key",
				Duration = 5
			})
		end
	end
})
v3.CreateButton(v3, {
	Name = "Get Key",
	Callback = function()
		setclipboard("https://ads.luarmor.net/get_key?for=Dicky_Wicky_Hub_-LQIJRHpBuuLV")
		lib:Notify({
			Title = "Key System",
			Content = "Key Link Copied To Clipboard",
			Duration = 5
		})
	end
})
