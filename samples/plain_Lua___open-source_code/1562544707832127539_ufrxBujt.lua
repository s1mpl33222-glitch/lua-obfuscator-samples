--[[
	Baltika Hub | [AOTL]
	Game: Aisles Of The Locust [AOTL]
	UI Library: Obsidian UI
]]

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local ThemeManager, SaveManager
pcall(function()
	ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
	SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
end)

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
	Title = "Baltika Hub | [AOTL]",
	Footer = "Baltika Hub | [AOTL] Edition",
	Icon = "rbxassetid://4384403532",
	NotifySide = "Right",
	ShowCustomCursor = false,
	EnableCompacting = true,
	SidebarCompacted = true
})

local Tabs = {
	Visual = Window:AddTab("Visuals", "eye"),
	Player = Window:AddTab("Player", "person-standing"),
	Server = Window:AddTab("Server & Map", "atom"),
	UISettings = Window:AddTab("UI Settings", "cog")
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- 1. VISUALS (ИСПРАВЛЕННАЯ СМЕНА СТИЛЯ И ВОЗВРАТ ОСВЕЩЕНИЯ)
---------------------------------------------------------
local VisGroup = Tabs.Visual:AddLeftGroupbox("ESP Controls")

local ESP_Storage = {}

local function ClearESP()
	for _, v in pairs(ESP_Storage) do
		if v and v.Parent then v:Destroy() end
	end
	table.clear(ESP_Storage)
end

VisGroup:AddDropdown("ESPStyle", {
	Values = { "Highlight", "Box", "Both" },
	Default = 1,
	Multi = false,
	Text = "ESP Style Mode",
	Callback = function()
		ClearESP() -- Очистка элементов при смене стиля
	end
})

VisGroup:AddToggle("MonsterESP", { Text = "The Locust ESP (Through Walls)", Default = false }):AddColorPicker("MonsterColor", { Default = Color3.fromRGB(255, 30, 30) })
VisGroup:AddToggle("ExitESP", { Text = "Green Exit Zone ESP (Through Walls)", Default = false }):AddColorPicker("ExitColor", { Default = Color3.fromRGB(0, 255, 120) })

local VisLightGroup = Tabs.Visual:AddRightGroupbox("Lighting & Fog Removal")

-- Сохранение оригинального освещения карты
local OriginalLighting = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	GlobalShadows = Lighting.GlobalShadows
}

VisLightGroup:AddToggle("Fullbright", {
	Text = "Remove Darkness & Shadows",
	Default = false,
	Callback = function(Value)
		if Value then
			OriginalLighting.Ambient = Lighting.Ambient
			OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
			OriginalLighting.Brightness = Lighting.Brightness
			OriginalLighting.GlobalShadows = Lighting.GlobalShadows

			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			Lighting.Brightness = 2
			Lighting.GlobalShadows = false
		else
			-- Возврат оригинальной темноты
			Lighting.Ambient = OriginalLighting.Ambient
			Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
			Lighting.Brightness = OriginalLighting.Brightness
			Lighting.GlobalShadows = OriginalLighting.GlobalShadows
		end
	end
})

local SavedAtmospheres = {}

VisLightGroup:AddToggle("NoFog", {
	Text = "Remove Fog (Complete Clean)",
	Default = false,
	Callback = function(Value)
		if Value then
			Lighting.FogEnd = 1e6
			Lighting.FogStart = 0
			for _, obj in pairs(Lighting:GetChildren()) do
				if obj:IsA("Atmosphere") or obj:IsA("DepthOfFieldEffect") or obj:IsA("PostEffect") then
					table.insert(SavedAtmospheres, {Obj = obj, Parent = obj.Parent})
					obj.Parent = nil
				end
			end
			for _, obj in pairs(Workspace:GetChildren()) do
				if obj:IsA("Atmosphere") or obj:IsA("DepthOfFieldEffect") then
					table.insert(SavedAtmospheres, {Obj = obj, Parent = obj.Parent})
					obj.Parent = nil
				end
			end
		else
			Lighting.FogEnd = 1000
			Lighting.FogStart = 0
			for _, item in pairs(SavedAtmospheres) do
				if item.Obj and item.Parent then
					item.Obj.Parent = item.Parent
				end
			end
			table.clear(SavedAtmospheres)
		end
	end
})

-- Стабильный цикл отрисовки ESP
task.spawn(function()
	while task.wait(0.3) do
		ClearESP()
		local char = LocalPlayer.Character
		local mode = Options.ESPStyle and Options.ESPStyle.Value or "Highlight"

		-- Подсветка "The Locust" сквозь стены
		if Toggles.MonsterESP and Toggles.MonsterESP.Value then
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:IsA("Model") and obj ~= char then
					local isLocustName = obj.Name == "The Locust" or obj.Name:lower():find("locust") or obj.Name:lower():find("bug")
					local hasLocustFolder = obj:FindFirstChild("LocustAnimations") ~= nil
					local isNotPlayer = not Players:GetPlayerFromCharacter(obj)

					if (isLocustName or hasLocustFolder) and isNotPlayer then
						if mode == "Highlight" or mode == "Both" then
							local hl = Instance.new("Highlight")
							hl.FillColor = Options.MonsterColor.Value
							hl.OutlineColor = Color3.fromRGB(255, 255, 255)
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.Adornee = obj
							hl.Parent = obj
							table.insert(ESP_Storage, hl)
						end
						if mode == "Box" or mode == "Both" then
							local box = Instance.new("SelectionBox")
							box.Color3 = Options.MonsterColor.Value
							box.LineThickness = 0.05
							box.AlwaysOnTop = true
							box.Adornee = obj
							box.Parent = obj
							table.insert(ESP_Storage, box)
						end
					end
				end
			end
		end

		-- Зелёная зона выхода сквозь стены
		if Toggles.ExitESP and Toggles.ExitESP.Value then
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj.Name:lower():find("exit") or obj.Name:lower():find("spawn") or obj.Name:lower():find("escape") or obj:IsA("SpawnLocation") then
					if mode == "Box" then
						local box = Instance.new("SelectionBox")
						box.Color3 = Options.ExitColor.Value
						box.AlwaysOnTop = true
						box.Adornee = obj
						box.Parent = obj
						table.insert(ESP_Storage, box)
					else
						local hl = Instance.new("Highlight")
						hl.FillColor = Options.ExitColor.Value
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Adornee = obj
						hl.Parent = obj
						table.insert(ESP_Storage, hl)
					end
				end
			end
		end
	end
end)

---------------------------------------------------------
-- 2. PLAYER (INVENTORY, JUMP & SPEED)
---------------------------------------------------------
local InvGroup = Tabs.Player:AddLeftGroupbox("Inventory Controls")

InvGroup:AddButton({
	Text = "Restore / Unlock Inventory",
	Func = function()
		pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
		local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if pgui then
			for _, v in pairs(pgui:GetDescendants()) do
				if v.Name:lower():find("inventory") or v.Name:lower():find("hotbar") or v.Name:lower():find("item") then
					if v:IsA("Frame") or v:IsA("TextButton") then
						v.Visible = true
					elseif v:IsA("ScreenGui") then
						v.Enabled = true
					end
				end
			end
		end
	end
})

local PlayerLocustGroup = Tabs.Player:AddLeftGroupbox("Locust Management")

PlayerLocustGroup:AddButton({
	Text = "Delete Locust Model",
	Func = function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name == "The Locust" or obj.Name:lower():find("locust") then
				obj:Destroy()
			end
		end
	end
})

local JumpGroup = Tabs.Player:AddLeftGroupbox("Jump Mechanics Fixer")

JumpGroup:AddToggle("UnlockJump", { Text = "Bypass & Unlock Jump Mechanics", Default = false })
JumpGroup:AddSlider("JumpPowerVal", { Text = "Jump Height Power", Default = 50, Min = 30, Max = 150, Rounding = 0 })
JumpGroup:AddToggle("InfJump", { Text = "Infinite Jump", Default = false })

local MoveGroup = Tabs.Player:AddRightGroupbox("Movement & Speed")

MoveGroup:AddToggle("BypassSpeed", { Text = "Bypass Speed (CFrame)", Default = false })
MoveGroup:AddSlider("SpeedVal", { Text = "Speed Multiplier", Default = 22, Min = 16, Max = 70, Rounding = 0 })

-- Разблокировка прыжка
task.spawn(function()
	while task.wait(0.1) do
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum and Toggles.UnlockJump and Toggles.UnlockJump.Value then
				hum.UseJumpPower = true
				hum.JumpPower = Options.JumpPowerVal.Value
				hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			end

			if Toggles.UnlockJump and Toggles.UnlockJump.Value then
				local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				if pgui then
					local touchGui = pgui:FindFirstChild("TouchGui")
					if touchGui then
						local jumpBtn = touchGui:FindFirstChild("JumpButton", true)
						if jumpBtn then jumpBtn.Visible = true end
					end
				end
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			if (Toggles.UnlockJump and Toggles.UnlockJump.Value) or (Toggles.InfJump and Toggles.InfJump.Value) then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

-- Обход скорости
RunService.Heartbeat:Connect(function(dt)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

		if Toggles.BypassSpeed and Toggles.BypassSpeed.Value then
			if hum and hum.MoveDirection.Magnitude > 0 then
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Options.SpeedVal.Value / 10) * dt * 10)
			end
		end
	end
end)

---------------------------------------------------------
-- 3. SERVER & MAP (AUTO-GRAB, CARTS & LEGS REMOVAL)
---------------------------------------------------------
local AutoGroup = Tabs.Server:AddLeftGroupbox("Automation")

AutoGroup:AddToggle("NearAutoGrab", { Text = "Auto-Grab Nearby Items", Default = false })

task.spawn(function()
	while task.wait(0.25) do
		if Toggles.NearAutoGrab and Toggles.NearAutoGrab.Value and LocalPlayer.Character then
			local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _, prompt in pairs(Workspace:GetDescendants()) do
					if prompt:IsA("ProximityPrompt") then
						local part = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
						if part and (part.Position - hrp.Position).Magnitude <= prompt.MaxActivationDistance then
							fireproximityprompt(prompt)
						end
					end
				end
			end
		end
	end
end)

local CartCleanGroup = Tabs.Server:AddRightGroupbox("Shopping Cart Clean")

CartCleanGroup:AddButton({
	Text = "Delete Shopping Carts",
	Func = function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("cart") or obj.Name:lower():find("trolley") then
				obj:Destroy()
			end
		end
	end
})

CartCleanGroup:AddButton({
	Text = "Delete Cart Wheels / Legs",
	Func = function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("wheel") or obj.Name:lower():find("leg") then
				if obj.Parent and (obj.Parent.Name:lower():find("cart") or obj.Parent.Name:lower():find("trolley")) then
					obj:Destroy()
				end
			end
		end
	end
})

CartCleanGroup:AddButton({
	Text = "Delete Player Legs",
	Func = function()
		if LocalPlayer.Character then
			for _, p in pairs(LocalPlayer.Character:GetChildren()) do
				if p:IsA("BasePart") and (p.Name:find("Leg") or p.Name:find("Foot")) then
					p:Destroy()
				end
			end
		end
	end
})

---------------------------------------------------------
-- 4. UI SETTINGS & REJOIN
---------------------------------------------------------
local ServerControl = Tabs.UISettings:AddLeftGroupbox("Server Options")

ServerControl:AddButton({
	Text = "Rejoin Server",
	Func = function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
})

ServerControl:AddButton({
	Text = "Server Hop (New Server)",
	Func = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end
})

-- Восстановление после смерти
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	task.wait(1)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
end)

if ThemeManager and SaveManager then
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
	ThemeManager:SetFolder("BaltikaProject")
	SaveManager:SetFolder("BaltikaProject/AOTL")
	SaveManager:BuildConfigSection(Tabs.UISettings)
	ThemeManager:ApplyToTab(Tabs.UISettings)
end

Library.ToggleKeybind = Options.MenuKeybind
Library:SelectTab(1)
