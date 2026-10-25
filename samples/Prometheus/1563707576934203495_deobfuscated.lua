-- This file was generated at discord.gg/syncrypt

local lib = loadstring(game:HttpGet("https://pastebin.com/raw/4HTPeEp7"))()
local Players = game:GetService("Players")

game:GetService("RunService")
game:GetService("UserInputService")
game:GetService("Teams")

local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t1 = {
	Debug = true,
	FastTriggerAbilities = {
		["EXTEND-O ARM"] = true,
		["DAGGER DASH"] = true,
		["DARK REVERSAL"] = true
	},
	DoublePressAbilities = {
		["SHADOW CLONE"] = true
	},
	Keybinds = {
		Enum.KeyCode.One,
		Enum.KeyCode.Two,
		Enum.KeyCode.Three,
		Enum.KeyCode.Four
	},
	AutoParryToggleKey = Enum.KeyCode.RightControl,
	ParryAbilities = {
		"UPPER CUT",
		"EXTEND-O ARM",
		"DRAGON RUSH",
		"FAKE BALL",
		"LEAP STRIKE",
		"SHADOW RAMPAGE",
		"ICE SLIDE",
		"ZAP FREEZE",
		"SPIRIT WALL",
		"DARK REVERSAL",
		"CHARGED KICK",
		"INSTANT TRAVEL",
		"ORBITAL CANNON",
		"DREAD SPHERE",
		"PHANTOM GRASP",
		"SIDESTEP",
		"BUNGEE",
		"KI BLAST",
		"JUGGLING BLAST",
		"GLASS WALL",
		"SONIC SLIDE",
		"GROUND WALLS",
		"CHAIN SPEAR",
		"HANDGUN",
		"ASSASIN INVISIBILITY",
		"LIGHTNING INTERCEPT",
		"FOX ARMOR",
		"FIST BARRAGE",
		"STANDOFF",
		"REVENGE",
		"BLINK",
		"RULER HOLD",
		"ARISE",
		"CLONE PARRY"
	}
}
local Character = nil

local function v8()
	Character = LocalPlayer.Character

	if not Character then
		return
	end

	Character:FindFirstChildWhichIsA("Humanoid")
end

Character = LocalPlayer.Character

if Character then
	Character:FindFirstChildWhichIsA("Humanoid")
end

LocalPlayer.CharacterAdded:Connect(v8)

local v9 = nil
local u10 = nil

local function v11(p1, p2, p3)
	local v12 = t1.Keybinds[p1]

	if not v12 then
		return
	end

	v9("Pressing key for ability:", p3)

	if t1.DoublePressAbilities[p3] then
		for _ = 1, 2 do
			VirtualInputManager:SendKeyEvent(true, v12, false, game)
			VirtualInputManager:SendKeyEvent(false, v12, false, game)
			task.wait(0.05)
		end
	else
		VirtualInputManager:SendKeyEvent(true, v12, false, game)
		VirtualInputManager:SendKeyEvent(false, v12, false, game)
	end

	local isGuiObject

	if p2 then
		isGuiObject = p2:IsA("GuiObject")
	else
		isGuiObject = p2
	end

	if not isGuiObject then
		return
	end

	local BackgroundColor3 = p2.BackgroundColor3

	p2.BackgroundColor3 = Color3.new(1, 1, 0)
	task.delay(0.25, function()
		if not p2 then
			return
		end

		p2.BackgroundColor3 = BackgroundColor3
	end)
end

v9 = function(...)
	if not t1.Debug then
		return
	end

	print("[DEBUG]", ...)
end

local function v16(p4)
	for i, v in ipairs(p4) do
		if v then
			local AbilityNameLabel = v:FindFirstChild("AbilityNameLabel")
			local Cooldown = v:FindFirstChild("Cooldown")
			local v21 = v.FindFirstChild(v, "LockLabel")
			local v22

			if AbilityNameLabel then
				v22 = table.find(t1.ParryAbilities, AbilityNameLabel.Text)
			else
				v22 = AbilityNameLabel
			end

			if v22 then
				if Cooldown then
					local v23 = not Cooldown.Visible

					if v23 then
						if v21 then
							v21 = not v21.Visible
						end
					else
						v21 = v23
					end
				else
					v21 = Cooldown
				end

				if v21 then
					v9("Ready parry ability:", AbilityNameLabel.Text, "at", i)

					return i, v, AbilityNameLabel.Text
				end

				v9("Ability not ready:", AbilityNameLabel.Text)
			end
		end
	end

	return nil
end

u10 = false

local function v24(p5, p6, p7)
	local Highlight

	if p5 then
		Highlight = p5:FindFirstChild("Highlight")
	else
		Highlight = p5
	end

	if Highlight then
		if p5.Highlight.FillColor == Color3.new(1, 0, 0) then
			local v26 = LocalPlayer
			local v27 = (tick() - p6) * 1000
			local v28 = v26:GetNetworkPing() * 1000
			local n1, n2

			if v28 < 50 then
				n1 = 800
				n2 = 400
			elseif v28 < 100 then
				n1 = 700
				n2 = 300
			else
				n1 = 600
				n2 = 250
			end

			return (t1.FastTriggerAbilities[p7] == true and n2 and n2 or n1) <= v27
		else
			return false
		end
	else
		return false
	end
end
local function v31()
	local HUD = PlayerGui:WaitForChild("HUD")
	local ToolbarButtons = HUD.HolderBottom.ToolbarButtons
	local DeflectButton = ToolbarButtons:FindFirstChild("DeflectButton")
	local n3 = 0

	while task.wait(0.05) do
		if HUD and ToolbarButtons then
			local Visible

			if DeflectButton then
				Visible = DeflectButton.Cooldown.Visible
			else
				Visible = DeflectButton
			end

			if Visible then
				if n3 == 0 then
					n3 = tick()
				end

				local Part = workspace:FindFirstChild("Part")
				local v38, v39, v40 = v16({
					ToolbarButtons:FindFirstChild("AbilityButton1"),
					ToolbarButtons:FindFirstChild("AbilityButton2"),
					ToolbarButtons:FindFirstChild("AbilityButton3"),
					ToolbarButtons.FindFirstChild(ToolbarButtons, "AbilityButton4")
				})

				if v38 then
					if Part then
						Part = v24(Part, n3, v40)
					end
				else
					Part = v38
				end

				if Part then
					v11(v38, v39, v40)
					n3 = 0
				end
			else
				n3 = 0
			end
		end
	end
end

lib:Notify({
	Title = "Key System",
	Content = "Link Copied!!🗝️",
	Duration = 20.5,
	Image = "key-round"
})
setclipboard("https://loot-link.com/s?a7825yMi")

local v41 = lib.CreateWindow(lib, {
	Name = "Fluxin Hub",
	Icon = "gamepad",
	LoadingTitle = "Fluxin Hub Loading",
	LoadingSubtitle = "by Exclusionz",
	Theme = "Amethyst",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,
	ConfigurationSaving = {
		Enabled = true,
		FileName = "UltimateHubConfig"
	},
	Discord = {
		Enabled = true,
		Invite = "7BWAuArqJk",
		RememberJoins = true
	},
	KeySystem = false,
	KeySettings = {
		Title = "Enter Access Key",
		Subtitle = "Key Verification",
		Note = "Link Copied!🗝️🕸️",
		FileName = "UltimateHubKey2",
		SaveKey = true,
		GrabKeyFromSite = true,
		Key = { "https://script.google.com/macros/s/AKfycbzrfROD0ZBsmgJXFDRwsi-4M4bLPNlSre-c47kn3_EVGfCOJo7onzmWzXsYUk6CfxbtHg/exec" }
	}
})
local Abilities = v41:CreateTab("Abilities", "zap")
local Settings = v41:CreateTab("Settings", "settings")
local Key = v41:CreateTab("Key", "key")

Abilities:CreateSection("Ability Controls")

local t2 = {
	Name = "Auto Parry Spam",
	CurrentValue = false,
	Flag = "AutoParryToggle",
	Callback = function(p8)
		u10 = p8
		lib:Notify({
			Title = "Auto Parry",
			Content = u10 and "Enabled" or "Disabled",
			Duration = 1.5,
			Image = u10 and "check" or "x"
		})
	end
}

Abilities.CreateToggle(Abilities, t2)
Abilities.CreateKeybind(Abilities, {
	Name = "Toggle Auto Parry Keybind",
	CurrentKeybind = t1.AutoParryToggleKey.Name,
	HoldToInteract = false,
	Flag = "AutoParryKeybind",
	Callback = function()
		u10 = not u10
		lib:Notify({
			Title = "Auto Parry",
			Content = u10 and "Enabled" or "Disabled",
			Duration = 1.5,
			Image = u10 and "check" or "x"
		})
	end
})
Settings:CreateToggle({
	Name = "Enable Debug Mode",
	CurrentValue = t1.Debug,
	Flag = "DebugMode",
	Callback = function(p9)
		t1.Debug = p9
		v9("Debug mode set to:", p9)
	end
})

local t3 = {
	Name = "Fast Trigger Abilities",
	CurrentValue = true,
	Flag = "FastTrigger",
	Callback = function(p10)
		for k in pairs(t1.FastTriggerAbilities) do
			t1.FastTriggerAbilities[k] = p10
		end

		v9("Fast trigger abilities set to:", p10)
	end
}

Abilities.CreateToggle(Abilities, t3)

local t4 = {
	Name = "Double Press Abilities",
	CurrentValue = true,
	Flag = "DoublePress",
	Callback = function(p11)
		for k in pairs(t1.DoublePressAbilities) do
			t1.DoublePressAbilities[k] = p11
		end

		v9("Double press abilities set to:", p11)
	end
}

Abilities.CreateToggle(Abilities, t4)
Settings.CreateButton(Settings, {
	Name = "Destroy UI",
	Callback = function()
		lib:Destroy()
	end
})
Key:CreateSection("Get Your Key")
Key.CreateButton(Key, {
	Name = "Copy Discord Invite",
	Info = "Click to copy the Discord invite link to your clipboard.",
	Callback = function()
		setclipboard("https://discord.com/invite/7BWAuArqJk")
		lib:Notify({
			Title = "Discord Link Copied!",
			Content = "The Discord invite link has been copied to your clipboard. Join us to get your key!",
			Duration = 5,
			Image = "check"
		})
	end
})
Key:CreateParagraph({
	Title = "Free Key Access",
	Content = "Join our Discord server using the link above! We provide free keys there, along with updates, support, and a great community."
})
Settings:CreateSection("Configuration")
Settings.CreateParagraph(Settings, {
	Title = "Script Settings",
	Content = "Configure the behavior of the Fluxin Hub script using the options below."
})
spawn(function()
	v31()
end)
spawn(function()
	local color3 = Color3.new(1, 0, 0)

	while task.wait(0.05) do
		if u10 then
			local Part = workspace:FindFirstChild("Part")
			local Highlight

			if Part then
				Highlight = Part:FindFirstChild("Highlight")

				if Highlight then
					Highlight = Part.Highlight.FillColor == color3
				end
			else
				Highlight = Part
			end

			if Highlight then
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
				lib:Notify({
					Title = "Parry Triggered!",
					Content = "",
					Duration = 0.2,
					Image = "shield"
				})
			end
		end
	end
end)
