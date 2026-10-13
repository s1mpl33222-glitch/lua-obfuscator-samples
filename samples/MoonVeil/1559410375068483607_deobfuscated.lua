-- This file was generated at discord.gg/syncrypt

local v1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local Options = v1.Options
local _ = v1.Toggles
local s1 = ""
local v5 = v1:CreateWindow({
	Title = "Yabujin - Key System",
	Footer = "Enter key to continue",
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = true,
})
local v6 = v5:AddTab("Key System", "key")
local v7 = v6:AddLeftGroupbox("Verification", "shield")

v7:AddInput("KeyInput", {
	Text = "Enter Key",
	Default = "",
	Placeholder = "Paste key here...",
	Callback = function(p1)
		s1 = p1
	end,
})

local t1 = {
	Text = "Redeem Key",
}
local u9 = v1
local u10 = v5

function t1.Func()
	if (s1 or "") ~= "key-399j-43ij-$3['-@][4-394k-c$OCKOKS$£c9i34cjuhsdgjio3kd3]'4d]'#d;f£$@f]'#d'sf34iji" then
		u9:Notify({
			Title = "Error",
			Description = "Invalid Key!",
			Time = 5,
		})

		return
	end

	u9:Notify({
		Title = "Success!",
		Description = "Loading Yabujin...",
		Time = 4,
	})
	task.wait(1)
	pcall(function()
		u10:SetVisible(false)
	end)
	loadstring(game:HttpGet("https://pastefy.app/lutwr2do/raw"))()
end

v7:AddButton(t1)

local v11 = v6:AddRightGroupbox("Get Key", "link")
local t2 = {
	Text = "Copy Key Link",
}
local u13 = v1

function t2.Func()
	setclipboard("https://work.ink/2zSo/permanent-yabujin-key-step-12")
	u13:Notify({
		Title = "Copied!",
		Description = "Link copied to clipboard",
		Time = 5,
	})
end

v11:AddButton(t2)
v6:AddRightGroupbox("Keybind", "keyboard"):AddLabel("Menu Toggle Key"):AddKeyPicker("MenuKeybind", {
	Default = "RightShift",
	NoUI = true,
	Text = "Toggle GUI",
})

local spawn = task.spawn
local u15 = v1
local u16 = Options

spawn(function()
	task.wait(1)
	u15.ToggleKeybind = u16.MenuKeybind
end)
v6:Select()
v1:Notify({
	Title = "Yabujin",
	Description = "Key system loaded\nRightShift = Open/Close Menu",
	Time = 8,
})
