-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local t1 = {
	value1 = game:GetService("RunService"),
	value2 = game:GetService("Workspace"),
	value3 = game:GetService("UserInputService"),
	value4 = game:GetService("ReplicatedStorage"),
	value5 = game:GetService("TweenService"),
	value6 = game:GetService("ContextActionService"),
	value7 = game:GetService("Lighting"),
	value8 = Players.LocalPlayer
}

t1.value9 = t1.value2.CurrentCamera
t1.value8:GetMouse()

local Weapons = t1.value4:WaitForChild("Database"):WaitForChild("Custom"):WaitForChild("Weapons")

t1.value10 = {}

local t2 = {}
local t3 = {
	AWP = true,
	["SSG 08"] = true,
	G3SG1 = true,
	["SCAR-20"] = true
}

for _, child in ipairs(Weapons.GetChildren(Weapons)) do
	if child:IsA("ModuleScript") then
		local ok, result = pcall(require, child)

		if ok then
			ok = type(result) == "table"
		end

		if ok then
			setreadonly(result, false)

			local s1 = "WalkSpeed"
			local WalkSpeed = result.WalkSpeed
			local s2 = "FireRate"
			local FireRate = result.FireRate
			local s3 = "Automatic"
			local Automatic = result.Automatic
			local s4 = "Penetration"
			local Penetration = result.Penetration
			local s5 = "WallbangMultiplier"
			local WallbangMultiplier = result.WallbangMultiplier
			local s6 = "RecoilScale"

			t2.value5 = result.Recoil

			local value5 = t2.value5

			if t2.value5 then
				value5 = result.Recoil.Scale
			end

			local v22 = value5 or nil

			t2.value1 = "RecoilCameraScale"
			t2.value2 = result.Recoil
			t2.value5 = t2.value2

			if t2.value2 then
				t2.value5 = result.Recoil.CameraScale
			end

			local value52 = t2.value5 or nil
			local s7 = "Spread"

			t2.value3 = result.Spread
			t2.value2 = t2.value3

			if t2.value3 then
				t2.value6 = result.Spread.Range
				t2.value7 = result.Spread.PerShot
				t2.value8 = result.Spread.MovementMultiplier
				t2.value10 = result.Spread.JumpShotMinimum
				t2.value2 = {
					Range = t2.value6,
					PerShot = t2.value7,
					MovementMultiplier = t2.value8,
					JumpShotMinimum = t2.value10
				}
			end

			t2.value5 = t2.value2 or nil
			t2.value2 = {}

			local t4 = {
				[s1] = WalkSpeed,
				[s2] = FireRate,
				[s3] = Automatic,
				[s4] = Penetration,
				[s5] = WallbangMultiplier,
				[s6] = v22,
				[v824] = value52,
				[s7] = t2.value5,
				FireModes = t2.value2
			}

			if result.FireModes then
				for k, fireMode in pairs(result.FireModes) do
					if fireMode.Spread then
						local FireModes = t4.FireModes
						local Range = fireMode.Spread.Range

						t2.value1 = fireMode.Spread.PerShot

						local MovementMultiplier = fireMode.Spread.MovementMultiplier

						t2.value4 = fireMode.Spread.JumpShotMinimum
						FireModes[k] = {
							Spread = {
								Range = Range,
								PerShot = t2.value1,
								MovementMultiplier = MovementMultiplier,
								JumpShotMinimum = t2.value4
							}
						}
					end
				end
			end

			t1.value10[child.Name] = {
				Data = result,
				Original = t4,
				IsSniper = t3[child.Name] or false
			}
			setreadonly(result, true)
		end
	end
end

local s8 = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

t1.value11 = loadstring(game:HttpGet(s8 .. "Library.lua"))()

local lib = loadstring(game:HttpGet(s8 .. "addons/ThemeManager.lua"))()
local lib2 = loadstring(game:HttpGet(s8 .. "addons/SaveManager.lua"))()

t1.value12 = t1.value11.Options
t1.value13 = t1.value11.Toggles

local v34 = t1.value11:CreateWindow({
	Title = "Dark Hub",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true
})

v34:SetCornerRadius(8)

local t5 = {
	Combat = v34:AddTab("Combat", "swords"),
	ESP = v34:AddTab("ESP", "eye"),
	Skins = v34:AddTab("Skins", "palette"),
	Viewmodel = v34:AddTab("Viewmodel", "camera"),
	World = v34:AddTab("World & Render", "sun"),
	Misc = v34:AddTab("Misc", "zap"),
	Settings = v34:AddTab("Settings", "settings")
}
local t6 = {
	"Plastic",
	"SmoothPlastic",
	"Neon",
	"ForceField",
	"Glass",
	"Foil",
	"Metal",
	"Wood",
	"Marble",
	"Fabric"
}
local v37 = t5.Combat:AddLeftGroupbox("Aimbot Assist (Smooth)")

v37:AddToggle("AimbotEnabled", {
	Text = "Enable Smooth Aim",
	Default = false
})
v37:AddLabel("Aim Key"):AddKeyPicker("AimbotKey", {
	Default = "E",
	Mode = "Hold",
	Text = "Aim"
})
v37:AddDropdown("AimbotTargetPart", {
	Values = { "Head", "HumanoidRootPart" },
	Default = 1,
	Text = "Target Part"
})
v37:AddSlider("AimbotSmoothing", {
	Text = "Smoothing",
	Default = 3,
	Min = 1,
	Max = 10,
	Rounding = 1
})
t5.Combat:AddLeftGroupbox("Aimbot Checkers"):AddToggle("AimbotWallCheck", {
	Text = "Wall Check (Visibility)",
	Default = true
})

local v38 = t5.Combat:AddLeftGroupbox("Field of View (FOV)")

v38:AddToggle("ShowFOV", {
	Text = "Show FOV Circle",
	Default = false
}):AddColorPicker("ColorFOV", {
	Default = Color3.fromRGB(220, 20, 60),
	Title = "FOV Color"
})
v38:AddSlider("FOVRadius", {
	Text = "FOV Radius",
	Default = 100,
	Min = 10,
	Max = 500,
	Rounding = 1
})

local v39 = t5.Combat:AddLeftGroupbox("Anti-Aim System")

v39:AddToggle("AAEnabled", {
	Text = "Enable Anti-Aim",
	Default = false
})
v39.AddDropdown(v39, "AAYaw", {
	Text = "Yaw Angle (X/Z)",
	Values = {
		"Spinbot",
		"Jitter",
		"Backward",
		"Sideways"
	},
	Default = 1
})
v39:AddSlider("AASpeed", {
	Text = "Spin Speed",
	Default = 50,
	Min = 10,
	Max = 150,
	Rounding = 0
})

local TriggerBot = t5.Combat:AddRightGroupbox("TriggerBot")

TriggerBot:AddToggle("TriggerBotEnabled", {
	Text = "Enable TriggerBot",
	Default = false
})
TriggerBot:AddSlider("TriggerBotDelay", {
	Text = "Shot Delay (ms)",
	Default = 0,
	Min = 0,
	Max = 500,
	Rounding = 0,
	Suffix = "ms"
})

local v41 = t5.Combat:AddRightGroupbox("Combat Exploits")

v41:AddToggle("HitboxEnabled", {
	Text = "Expand Hitboxes",
	Default = false
})
v41:AddSlider("HitboxSize", {
	Text = "Hitbox Size",
	Default = 3,
	Min = 1,
	Max = 3,
	Rounding = 1
})
v41:AddSlider("HitboxTransparency", {
	Text = "Hitbox Transparency",
	Default = 100,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Suffix = "%"
})

local v42 = t5.Combat:AddRightGroupbox("Gun Mechanics & Mods")

v42:AddToggle("NoSpreadNonSnipers", {
	Text = "No Spread (Except Snipers)",
	Default = false,
	Tooltip = "Activates Laser Mode on everything except AWP/Scout."
})
v42:AddToggle("NoRecoilToggle", {
	Text = "No Recoil",
	Default = false,
	Tooltip = "Removes weapon recoil safely."
})
v42:AddToggle("RapidFireToggle", {
	Text = "Rapid Fire",
	Default = false,
	Tooltip = "Increases rate of fire."
})
v42:AddToggle("AutoFireToggle", {
	Text = "Force Full Auto",
	Default = false,
	Tooltip = "Converts semi-auto weapons into automatic."
})

local v43 = t5.ESP:AddLeftGroupbox("Visual Settings")

v43:AddToggle("EnableESP", {
	Text = "Enable Master ESP",
	Default = false
})

local ESP_WallCheck = v43:AddToggle("ESP_WallCheck", {
	Text = "Change Color if Visible",
	Default = false
})

t2.value5 = Color3.fromRGB(0, 255, 0)
ESP_WallCheck:AddColorPicker("Color_ESP_Visible", {
	Default = t2.value5,
	Title = "Visible Color"
})
v43:AddDivider()

local ESP_Box = v43:AddToggle("ESP_Box", {
	Text = "Show 2D Box",
	Default = true
})
local AddColorPicker = ESP_Box.AddColorPicker

t2.value5 = Color3.fromRGB(220, 20, 60)
AddColorPicker(ESP_Box, "Color_ESP_Box", {
	Default = t2.value5,
	Title = "Hidden Color"
})

local ESP_Name = v43:AddToggle("ESP_Name", {
	Text = "Show Name",
	Default = true
})

t2.value5 = Color3.fromRGB(255, 255, 255)
ESP_Name:AddColorPicker("Color_ESP_Name", {
	Default = t2.value5,
	Title = "Name Color"
})
v43:AddToggle("ESP_Distance", {
	Text = "Show Distance",
	Default = true
})

local ESP_HeadDot = v43:AddToggle("ESP_HeadDot", {
	Text = "Show Head Dot",
	Default = false
})
local AddColorPicker2 = ESP_HeadDot.AddColorPicker

t2.value5 = Color3.fromRGB(255, 255, 0)
AddColorPicker2(ESP_HeadDot, "Color_ESP_HeadDot", {
	Default = t2.value5,
	Title = "Head Dot Color"
})

local ESP_Tracers = v43:AddToggle("ESP_Tracers", {
	Text = "Show Snaplines / Tracers",
	Default = false
})
local color3 = Color3.fromRGB
local AddColorPicker3 = ESP_Tracers.AddColorPicker

t2.value5 = color3(255, 255, 255)
AddColorPicker3(ESP_Tracers, "Color_ESP_Tracers", {
	Default = t2.value5,
	Title = "Tracer Color"
})

local ESP_Chams = v43:AddToggle("ESP_Chams", {
	Text = "Show Chams (Wallhack)",
	Default = false
})

t2.value5 = Color3.fromRGB(220, 20, 60)
ESP_Chams:AddColorPicker("Color_ESP_Chams", {
	Default = t2.value5,
	Title = "Chams Color"
})
v43:AddToggle("ESP_Bar", {
	Text = "Show Health Bar",
	Default = true
})
v43:AddToggle("ESP_Text", {
	Text = "Show Health Text",
	Default = true
})
t5.Viewmodel:AddLeftGroupbox("Master"):AddToggle("EnableVM", {
	Text = "Enable Viewmodel Colors",
	Default = false
})

local Weapon = t5.Viewmodel:AddLeftGroupbox("Weapon")
local Color = Weapon:AddLabel("Color")

t2.value2 = Color3
t2.value1 = Color.AddColorPicker
t2.value2 = t2.value2.fromRGB(220, 20, 60)
t2.value1(Color, "Color_Weapon", {
	Default = t2.value2
})
Weapon:AddDropdown("Mat_Weapon", {
	Values = t6,
	Default = 3
})
t2.value1 = t5.Viewmodel:AddLeftGroupbox("Arms")

local Color2 = t2.value1:AddLabel("Color")

t2.value2 = Color3.fromRGB
Color2.AddColorPicker(Color2, "Color_Arms", {
	Default = t2.value2(255, 255, 255)
})
t2.value1:AddDropdown("Mat_Arms", {
	Values = t6,
	Default = 2
})

local Gloves = t5.Viewmodel:AddRightGroupbox("Gloves")
local Color4 = Gloves:AddLabel("Color")
local color32 = Color3.fromRGB
local AddColorPicker4 = Color4.AddColorPicker

t2.value3 = color32(20, 20, 20)
AddColorPicker4(Color4, "Color_Gloves", {
	Default = t2.value3
})
Gloves:AddDropdown("Mat_Gloves", {
	Values = t6,
	Default = 2
})

local Sleeves = t5.Viewmodel:AddRightGroupbox("Sleeves")
local Color5 = Sleeves:AddLabel("Color")

t2.value5 = Color5.AddColorPicker

local t7 = {
	Default = Color3.fromRGB(40, 40, 40)
}

t2.value5(Color5, "Color_Sleeves", t7)
Sleeves:AddDropdown("Mat_Sleeves", {
	Values = t6,
	Default = 2
})
t2.value5 = t5.World:AddLeftGroupbox("Lighting & Environment")
t2.value5:AddToggle("FullbrightToggle", {
	Text = "Fullbright (Remove Shadows)",
	Default = false
})
t2.value5:AddToggle("NightModeToggle", {
	Text = "Night Mode",
	Default = false
})
t2.value5:AddSlider("WorldTimeSlider", {
	Text = "Time of Day (Clock)",
	Default = 14,
	Min = 0,
	Max = 24,
	Rounding = 1
})
t2.value4 = t5.World:AddRightGroupbox("Camera World FOV")
t2.value4:AddToggle("EnableCustomFOV", {
	Text = "Enable Custom Camera FOV",
	Default = false
})
t2.value4:AddSlider("WorldFOVVal", {
	Text = "Camera FOV",
	Default = 90,
	Min = 70,
	Max = 130,
	Rounding = 0
})
t2.value2 = t5.World:AddRightGroupbox("Custom Crosshair")

local EnableCrosshair = t2.value2:AddToggle("EnableCrosshair", {
	Text = "Enable Custom Crosshair",
	Default = false
})

t2.value7 = Color3.fromRGB(0, 255, 0)
EnableCrosshair:AddColorPicker("ColorCrosshair", {
	Default = t2.value7,
	Title = "Crosshair Color"
})
t2.value2:AddSlider("CrosshairSize", {
	Text = "Size",
	Default = 8,
	Min = 2,
	Max = 30,
	Rounding = 0
})
t2.value3 = {
	Text = "Gap",
	Default = 4,
	Min = 0,
	Max = 15,
	Rounding = 0
}
t2.value2:AddSlider("CrosshairGap", t2.value3)

local Utilities = t5.Misc:AddLeftGroupbox("Utilities")

Utilities:AddToggle("BunnyHop", {
	Text = "Perfect Bunny Hop",
	Default = false
})
Utilities:AddToggle("InfiniteJumpToggle", {
	Text = "Infinite Jump (Air Jump)",
	Default = false
})
t2.value3 = t5.Misc:AddLeftGroupbox("Effects Removers")
t2.value3:AddToggle("AntiFlashToggle", {
	Text = "Anti-Flashbang",
	Default = false
})
t2.value3:AddToggle("AntiSmokeToggle", {
	Text = "Anti-Smoke",
	Default = false
})

local v66 = t5.Misc:AddRightGroupbox("Movement Mods")

v66:AddToggle("WalkSpeedMod", {
	Text = "Enable Super Speed",
	Default = false
})
v66:AddSlider("SpeedSlider", {
	Text = "Target Speed",
	Default = 60,
	Min = 16,
	Max = 150,
	Rounding = 1,
	Suffix = " studs"
})
t2.value6 = t5.Misc:AddRightGroupbox("Camera Mods (Third Person)")
t2.value6:AddToggle("TPEnabled", {
	Text = "Enable Third Person",
	Default = false
}):AddKeyPicker("TPKey", {
	Default = "V",
	SyncToggleState = true,
	Mode = "Toggle",
	Text = "Third Person"
})
t2.value6:AddToggle("TPHideVM", {
	Text = "Hide Viewmodel in TP",
	Default = true
})
t2.value6:AddSlider("TPDistance", {
	Text = "Camera Distance",
	Default = 10,
	Min = 5,
	Max = 30,
	Rounding = 1
})
t2.value6:AddSlider("TPOffsetX", {
	Text = "Shoulder Offset",
	Default = 2,
	Min = -5,
	Max = 5,
	Rounding = 1
})

local function v67(p1, p2, p3)
	if p1 and p2 then
		pcall(setreadonly, p1, false)

		if p3 then
			if p1.Range then
				p1.Range = NumberRange.new(0, 0)
			end

			if p1.PerShot then
				p1.PerShot = 0
			end

			if p1.MovementMultiplier then
				p1.MovementMultiplier = 0
			end

			if not p1.JumpShotMinimum then
				pcall(setreadonly, p1, true)

				return
			end

			p1.JumpShotMinimum = 0
		else
			if p1.Range then
				p1.Range = p2.Range
			end

			if p1.PerShot then
				p1.PerShot = p2.PerShot
			end

			if p1.MovementMultiplier then
				p1.MovementMultiplier = p2.MovementMultiplier
			end

			if not p1.JumpShotMinimum then
				pcall(setreadonly, p1, true)

				return
			end

			p1.JumpShotMinimum = p2.JumpShotMinimum
		end

		pcall(setreadonly, p1, true)
	end
end

t1.value13.NoSpreadNonSnipers:OnChanged(function(p4)
	for _, v in pairs(t1.value10) do
		if not v.IsSniper then
			setreadonly(v.Data, false)

			local Spread = v.Data.Spread

			if Spread then
				Spread = v.Original.Spread
			end

			if Spread then
				v67(v.Data.Spread, v.Original.Spread, p4)
			end

			if v.Data.FireModes then
				for k, fireMode in pairs(v.Data.FireModes) do
					local Spread2 = fireMode.Spread

					if Spread2 then
						Spread2 = v.Original.FireModes[k]

						if Spread2 then
							Spread2 = v.Original.FireModes[k].Spread
						end
					end

					if Spread2 then
						v67(fireMode.Spread, v.Original.FireModes[k].Spread, p4)
					end
				end
			end

			setreadonly(v.Data, true)
		end
	end
end)

local function v74()
	local NoRecoilToggle = t1.value13.NoRecoilToggle

	if NoRecoilToggle then
		NoRecoilToggle = t1.value13.NoRecoilToggle.Value
	end

	local RapidFireToggle = t1.value13.RapidFireToggle

	if RapidFireToggle then
		RapidFireToggle = t1.value13.RapidFireToggle.Value
	end

	local AutoFireToggle = t1.value13.AutoFireToggle
	local Data, Original, Recoil, Recoil2

	if not AutoFireToggle then
		for _, v in pairs(t1.value10) do
			Data = v.Data
			Original = v.Original
			pcall(setreadonly, Data, false)
			Recoil = Data.Recoil

			if Recoil then
				Recoil2 = Data.Recoil

				if type(Recoil2) == "table" then
					Recoil = Original.RecoilScale ~= nil
				else
					Recoil = false
				end
			end

			if Recoil then
				pcall(setreadonly, Data.Recoil, false)
				Data.Recoil.Scale = NoRecoilToggle and 0 or Original.RecoilScale
				Data.Recoil.CameraScale = NoRecoilToggle and 0 or Original.RecoilCameraScale
				pcall(setreadonly, Data.Recoil, true)
			end

			if Original.FireRate then
				Data.FireRate = RapidFireToggle and 0.02 or Original.FireRate
			end

			if Original.Automatic ~= nil then
				Data.Automatic = AutoFireToggle and true or Original.Automatic
			end

			pcall(setreadonly, Data, true)
		end

		return
	end

	AutoFireToggle = t1.value13.AutoFireToggle.Value

	for _, v in pairs(t1.value10) do
		Data = v.Data
		Original = v.Original
		pcall(setreadonly, Data, false)
		Recoil = Data.Recoil

		if Recoil then
			Recoil2 = Data.Recoil

			if type(Recoil2) == "table" then
				Recoil = Original.RecoilScale ~= nil
			else
				Recoil = false
			end
		end

		if Recoil then
			pcall(setreadonly, Data.Recoil, false)
			Data.Recoil.Scale = NoRecoilToggle and 0 or Original.RecoilScale
			Data.Recoil.CameraScale = NoRecoilToggle and 0 or Original.RecoilCameraScale
			pcall(setreadonly, Data.Recoil, true)
		end

		if Original.FireRate then
			Data.FireRate = RapidFireToggle and 0.02 or Original.FireRate
		end

		if Original.Automatic ~= nil then
			Data.Automatic = AutoFireToggle and true or Original.Automatic
		end

		pcall(setreadonly, Data, true)
	end
end

if t1.value13.NoRecoilToggle then
	t1.value13.NoRecoilToggle:OnChanged(v74)
end

if t1.value13.RapidFireToggle then
	t1.value13.RapidFireToggle:OnChanged(v74)
end

if t1.value13.AutoFireToggle then
	t1.value13.AutoFireToggle:OnChanged(v74)
end

function t1.value14()
	local WalkSpeedMod = t1.value13.WalkSpeedMod

	if WalkSpeedMod then
		WalkSpeedMod = t1.value13.WalkSpeedMod.Value
	end

	local SpeedSlider = t1.value12.SpeedSlider

	if not SpeedSlider then
		v92 = SpeedSlider or 16

		for _, v in pairs(t1.value10) do
			if v.Original.WalkSpeed then
				setreadonly(v.Data, false)
				v.Data.WalkSpeed = WalkSpeedMod and v92 or v.Original.WalkSpeed
				setreadonly(v.Data, true)
			end
		end

		return
	end

	SpeedSlider = t1.value12.SpeedSlider.Value

	local v90 = SpeedSlider or 16

	for _, v in pairs(t1.value10) do
		if v.Original.WalkSpeed then
			setreadonly(v.Data, false)
			v.Data.WalkSpeed = WalkSpeedMod and v90 or v.Original.WalkSpeed
			setreadonly(v.Data, true)
		end
	end
end

t2.value8 = t1.value13

if t2.value8.WalkSpeedMod then
	local WalkSpeedMod = t1.value13.WalkSpeedMod

	t2.value9 = t1.value14
	WalkSpeedMod:OnChanged(t2.value9)
end

t2.value8 = t1.value12

if t2.value8.SpeedSlider then
	local SpeedSlider = t1.value12.SpeedSlider

	function t2.value9()
		local WalkSpeedMod = t1.value13.WalkSpeedMod

		if WalkSpeedMod then
			WalkSpeedMod = t1.value13.WalkSpeedMod.Value
		end

		if not WalkSpeedMod then
			return
		end

		t1.value14()
	end

	SpeedSlider:OnChanged(t2.value9)
end

t2.value8 = t1.value2:WaitForChild("Characters", 10)
t1.value15 = t2.value8

function t2.value10()
	local value15 = t1.value15

	if not value15 then
		return value15
	end

	value15 = t1.value15:FindFirstChild("Counter-Terrorists")

	return value15
end

t1.value16 = nil
t1.value16 = t2.value10
t1.value17 = nil

function t1.value17()
	local value15 = t1.value15

	if value15 then
		value15 = t1.value15:FindFirstChild("Terrorists")
	end

	local v98 = t1.value16()

	if not value15 then
		if value15 then
			v98 = value15
		else
			if not v98 then
				return v98
			end

			v98 = v98:FindFirstChild(t1.value8.Name)
		end

		return v98
	end

	value15 = value15:FindFirstChild(t1.value8.Name)

	if value15 then
		v98 = value15
	else
		if not v98 then
			return v98
		end

		v98 = v98:FindFirstChild(t1.value8.Name)
	end

	return v98
end
function t1.value18()
	if not t1.value17() then
		return nil
	end

	local value15 = t1.value15

	if value15 then
		value15 = t1.value15:FindFirstChild("Terrorists")
	end

	local v100 = t1.value16()
	local v101

	if value15 then
		v101 = value15:FindFirstChild(t1.value8.Name)
	else
		v101 = value15
	end

	if v101 then
		return v100
	end

	if v100 then
	elseif v100 then
		return value15
	else
		return nil
	end

	v100 = v100:FindFirstChild(t1.value8.Name)

	if v100 then
		return value15
	else
		return nil
	end
end
function t1.value19(p5)
	local Humanoid = p5:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		return Humanoid.Health, Humanoid.MaxHealth
	else
		return 100, 100
	end
end
function t1.value20(p6, p7)
	local Position = t1.value9.CFrame.Position
	local v104 = p6.Position - Position
	local filterDescendantsInstances = { t1.value9 }

	if t1.value8.Character then
		local Character = t1.value8.Character

		table.insert(filterDescendantsInstances, Character)
	end

	if not p7 then
		v112 = RaycastParams.new()
		v112.FilterType = Enum.RaycastFilterType.Exclude
		v112.FilterDescendantsInstances = filterDescendantsInstances

		return t1.value2:Raycast(Position, v104, v112) == nil
	end

	table.insert(filterDescendantsInstances, p7)

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances

	return t1.value2:Raycast(Position, v104, raycastParams) == nil
end

t1.value21 = {}
t1.value22 = {}
task.spawn(function()
	while task.wait(0.2) do
		local v108 = t1.value18()

		if v108 then
			local GetChildren = v108.GetChildren

			for _, v in ipairs(GetChildren(v108)) do
				local Head = v:FindFirstChild("Head")
				local Humanoid = v:FindFirstChildOfClass("Humanoid")

				if Head then
					if Humanoid then
						Humanoid = Humanoid.Health > 0
					end
				else
					Humanoid = Head
				end

				if Humanoid then
					if not t1.value21[Head] then
						t1.value21[Head] = Head.Size
					end

					local HitboxEnabled = t1.value13.HitboxEnabled

					if HitboxEnabled then
						HitboxEnabled = t1.value13.HitboxEnabled.Value
					end

					if HitboxEnabled then
						local Value = t1.value12.HitboxSize.Value
						local transparency = t1.value12.HitboxTransparency.Value / 100

						if not (t1.value22[Head] and t1.value22[Head].Parent) then
							local Part = Instance.new("Part")

							Part.Name = "DarkHubFakeHead"
							Part.Size = t1.value21[Head]
							Part.CFrame = Head.CFrame
							Part.Color = Head.Color
							Part.Material = Head.Material
							Part.Transparency = 0
							Part.CanCollide = false
							Part.Massless = true
							Part.CastShadow = false

							local face = Head:FindFirstChild("face") or Head:FindFirstChildOfClass("Decal")

							if face then
								face:Clone().Parent = Part
							end

							local WeldConstraint = Instance.new("WeldConstraint")

							WeldConstraint.Part0 = Head
							WeldConstraint.Part1 = Part
							WeldConstraint.Parent = Part
							Part.Parent = v
							t1.value22[Head] = Part
						end

						Head.Size = Vector3.new(Value, Value, Value)
						Head.CanCollide = false
						Head.Transparency = transparency

						local GetChildren2 = Head.GetChildren

						for _, v2 in ipairs(GetChildren2(Head)) do
							if v2:IsA("Decal") then
								v2.Transparency = 1
							end
						end
					else
						local v123 = t1.value21[Head]

						if v123 then
							v123 = Head.Size ~= t1.value21[Head]
						end

						if v123 then
							Head.Size = t1.value21[Head]
							Head.Transparency = 0

							for _, child in ipairs(Head.GetChildren(Head)) do
								if child:IsA("Decal") then
									child.Transparency = 0
								end
							end
						end

						if t1.value22[Head] then
							t1.value22[Head]:Destroy()
							t1.value22[Head] = nil
						end
					end
				end
			end
		end
	end
end)
task.spawn(function()
	while task.wait(0.01) do
		local TriggerBotEnabled = t1.value13.TriggerBotEnabled

		if TriggerBotEnabled then
			TriggerBotEnabled = t1.value13.TriggerBotEnabled.Value

			if TriggerBotEnabled then
				TriggerBotEnabled = t1.value17()
			end
		end

		if TriggerBotEnabled then
			local ViewportSize = t1.value9.ViewportSize
			local v128 = t1.value9:ViewportPointToRay(ViewportSize.X / 2, ViewportSize.Y / 2)
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local filterDescendantsInstances = { t1.value9 }

			if t1.value8.Character then
				local Character = t1.value8.Character

				table.insert(filterDescendantsInstances, Character)
			end

			raycastParams.FilterDescendantsInstances = filterDescendantsInstances

			local hit = t1.value2:Raycast(v128.Origin, v128.Direction * 1000, raycastParams)
			local Instance_

			if hit then
				Instance_ = hit.Instance
			else
				Instance_ = hit
			end

			if Instance_ then
				local Model = hit.Instance:FindFirstAncestorOfClass("Model")
				local Humanoid

				if Model then
					Humanoid = Model:FindFirstChildOfClass("Humanoid")
				else
					Humanoid = Model
				end

				if Humanoid then
					local v136 = t1.value18()

					if v136 then
						v136 = Model.Parent == v136
					end

					if v136 then
						local Humanoid2 = Model:FindFirstChildOfClass("Humanoid")

						if Humanoid2 then
							Humanoid2 = Humanoid2.Health > 0
						end

						if Humanoid2 then
							local TriggerBotDelay = t1.value12.TriggerBotDelay

							if TriggerBotDelay then
								TriggerBotDelay = t1.value12.TriggerBotDelay.Value
							end

							local v139 = TriggerBotDelay or 0

							if v139 > 0 then
								task.wait(v139 / 1000)
							end

							if t1.value9:FindFirstChild("R8 Revolver") then
								local NoSpreadNonSnipers = t1.value13.NoSpreadNonSnipers

								if NoSpreadNonSnipers then
									NoSpreadNonSnipers = not t1.value13.NoSpreadNonSnipers.Value
								end

								if NoSpreadNonSnipers then
									t1.value13.NoSpreadNonSnipers:SetValue(true)
								end

								if mouse2click then
									mouse2click()
								end
							elseif mouse1click then
								mouse1click()
							end

							task.wait(0.05)
						end
					end
				end
			end
		end
	end
end)
t1.value23 = Drawing.new("Circle")
t1.value23.Filled = false
t1.value23.Thickness = 1
t1.value23.Visible = false

function t1.value24()
	local v141 = nil
	local Value = t1.value12.FOVRadius.Value
	local v143 = t1.value18()

	if v143 and t1.value13.AimbotEnabled.Value then
		local mouseLocation = t1.value3:GetMouseLocation()
		local Value2 = t1.value12.AimbotTargetPart.Value
		local GetChildren = v143.GetChildren

		for _, v in ipairs(GetChildren(v143)) do
			local Humanoid = v:FindFirstChildOfClass("Humanoid")
			local Head = v:FindFirstChild(Value2) or v:FindFirstChild("Head")

			if Humanoid then
				if Humanoid.Health > 0 then
					Humanoid = Head
				else
					Humanoid = false
				end
			end

			if Humanoid then
				local Value3 = t1.value13.AimbotWallCheck.Value

				if Value3 then
					Value3 = not t1.value20(Head, v)
				end

				if not Value3 then
					local t8 = { t1.value9:WorldToViewportPoint(Head.Position) }
					local v153 = t8[1]

					if t8[2] then
						local Magnitude = (Vector2.new(v153.X, v153.Y) - mouseLocation).Magnitude

						if Magnitude < Value then
							v141 = Head
							Value = Magnitude
						end
					end
				end
			end
		end

		return v141
	else
		return nil
	end
end

t1.value25 = t1.value4:WaitForChild("Assets"):WaitForChild("Skins")
t1.value26 = false
t1.value27 = {}
t1.value28 = {}

local t9 = {
	Karambit = true,
	["Butterfly Knife"] = true,
	["M9 Bayonet"] = true,
	["Flip Knife"] = true,
	["Gut Knife"] = true,
	["T Knife"] = true,
	["CT Knife"] = true
}

t1.value29 = {
	["Sports Gloves"] = true
}

local v156 = t5.Skins:AddLeftGroupbox("Master Skin Changer")

v156.AddToggle(v156, "SkinChangerToggle", {
	Text = "Enable Skin Changer",
	Default = false,
	Callback = function(p8)
		t1.value26 = p8

		if p8 then
			return
		end

		for _, child in ipairs(t1.value9:GetChildren()) do
			child:SetAttribute("SkinApplied", nil)
		end
	end
})
v156.AddButton(v156, {
	Text = "Randomize Skins",
	Func = function()
		for k, v in pairs(t1.value28) do
			local v161, v162, v163 = ipairs(v)
			local t10 = {}

			while true do
				local v165

				v163, v165 = v161(v162, v163)

				if not v163 then
					break
				end

				local v166

				if v165 == "Stock" then
					v166 = false
				else
					v166 = v165 ~= "Vanilla"
				end

				if v166 then
					table.insert(t10, v165)
				end
			end

			if #t10 > 0 then
				local v167 = t10[math.random(1, #t10)]

				if t1.value12["Skin_" .. k] then
					t1.value12["Skin_" .. k]:SetValue(v167)
				end
			end
		end
	end
})

local v168 = t5.Skins:AddLeftGroupbox("Custom Knives and Gloves")
local v169 = t5.Skins:AddRightGroupbox("CT Weapons")
local v170 = t5.Skins:AddRightGroupbox("T Weapons")
local v171 = t5.Skins:AddRightGroupbox("Shared Weapons")

function t1.value30(p9)
	if not (p9 and (t1.value26 and t1.value17())) then
		return
	end

	local v172 = t1.value27[p9.Name]

	if not v172 then
		return
	end

	local function v173()
		local v174 = t1.value25:FindFirstChild(p9.Name)

		if not v174 then
			return
		end

		local v175 = v174:FindFirstChild(v172)
		local Camera

		if v175 then
			Camera = v175:FindFirstChild("Camera")

			if Camera then
				Camera = v175.Camera:FindFirstChild("Factory New")
			end
		else
			Camera = v175
		end

		if not Camera then
			return
		end

		local v177, v178, v179 = ipairs(t1.value9:GetChildren())

		while true do
			local v180

			v179, v180 = v177(v178, v179)

			if not v179 then
				break
			end

			if v180:FindFirstChild("Left Arm") or v180:FindFirstChild("Right Arm") then
				local SportsGloves = t1.value25:FindFirstChild("Sports Gloves")

				if SportsGloves then
					SportsGloves = SportsGloves:FindFirstChild(t1.value27["Sports Gloves"] or "")
				end

				local Camera2

				if SportsGloves then
					Camera2 = SportsGloves:FindFirstChild("Camera")

					if Camera2 then
						Camera2 = SportsGloves.Camera:FindFirstChild("Factory New")
					end
				else
					Camera2 = SportsGloves
				end

				if Camera2 then
					for _, v in ipairs({ "Left Arm", "Right Arm" }) do
						local FindFirstChild = Camera2.FindFirstChild
						local v186 = v180:FindFirstChild(v)
						local v187 = FindFirstChild(Camera2, v)

						if v186 and v187 then
							local Glove = v186:FindFirstChild("Glove")

							if Glove then
								local SurfaceAppearance = Glove:FindFirstChildOfClass("SurfaceAppearance")

								if SurfaceAppearance then
									SurfaceAppearance:Destroy()
								end

								local clone = v187:Clone()

								clone.Name = "SurfaceAppearance"
								clone.Parent = Glove
							end
						end
					end
				end
			end
		end

		local Weapon2 = not t1.value29[p9.Name] and p9:FindFirstChild("Weapon")

		if not Weapon2 then
			p9:SetAttribute("SkinApplied", v172)

			return
		end

		local GetDescendants = Weapon2.GetDescendants

		for _, v in ipairs(GetDescendants(Weapon2)) do
			if v:IsA("BasePart") then
				local VName = Camera:FindFirstChild(v.Name)

				if VName then
					local SurfaceAppearance = v:FindFirstChildOfClass("SurfaceAppearance")

					if SurfaceAppearance then
						SurfaceAppearance:Destroy()
					end

					local clone = VName:Clone()

					clone.Name = "SurfaceAppearance"
					clone.Parent = v
				end
			end
		end

		p9:SetAttribute("SkinApplied", v172)
	end

	pcall(v173)
end

local v198, v199, v200 = pairs(t9)

local function v201(p10, p11)
	local v202 = t1.value25:FindFirstChild(p11)

	if not v202 then
		return
	end

	local GetChildren = v202.GetChildren
	local v204, v205, v206 = ipairs(GetChildren(v202))
	local t11 = {}

	while true do
		local v208

		v206, v208 = v204(v205, v206)

		if not v206 then
			break
		end

		local Name = v208.Name

		table.insert(t11, Name)
	end

	t1.value28[p11] = t11

	if not t1.value27[p11] then
		t1.value27[p11] = t11[1]
	end

	local v210 = "Skin_" .. p11
	local t12 = {
		Values = t11,
		Default = 1,
		Multi = false,
		Text = p11,
		Callback = function(p12)
			t1.value27[p11] = p12

			local ipairs_ = ipairs
			local value9 = t1.value9

			for _, child in ipairs_(value9.GetChildren(value9)) do
				child:SetAttribute("SkinApplied", nil)
				t1.value30(child)
			end
		end
	}

	p10.AddDropdown(p10, v210, t12)
end

local t13 = {
	["USP-S"] = true,
	["Five-SeveN"] = true,
	MP9 = true,
	FAMAS = true,
	["M4A1-S"] = true,
	M4A4 = true,
	AUG = true,
	["MAG-7"] = true,
	["SCAR-20"] = true,
	MP7 = true
}
local t14 = {
	["Glock-18"] = true,
	["Tec-9"] = true,
	["MAC-10"] = true,
	["Galil AR"] = true,
	["AK-47"] = true,
	["SG 553"] = true,
	["Sawed-Off"] = true,
	G3SG1 = true
}
local t15 = {
	P250 = true,
	["Desert Eagle"] = true,
	["Dual Berettas"] = true,
	["R8 Revolver"] = true,
	Negev = true,
	M249 = true,
	P90 = true,
	["UMP-45"] = true,
	["PP-Bizon"] = true,
	Nova = true,
	XM1014 = true,
	AWP = true,
	["SSG 08"] = true,
	["Zeus x27"] = true
}
local t16 = {
	["HE Grenade"] = true,
	["Incendiary Grenade"] = true,
	Molotov = true,
	["Smoke Grenade"] = true,
	Flashbang = true,
	["Decoy Grenade"] = true,
	C4 = true,
	["CT Glove"] = true,
	["T Glove"] = true
}

while true do
	v200 = v198(v199, v200)

	if not v200 then
		break
	end

	v201(v168, v200)
end

for k in pairs(t1.value29) do
	v201(v168, k)
end

local v221, v222, v223 = pairs(t13)

while true do
	v223 = v221(v222, v223)

	if not v223 then
		break
	end

	v201(v169, v223)
end

for k in pairs(t14) do
	v201(v170, k)
end

local v225, v226, v227 = pairs(t15)

while true do
	v227 = v225(v226, v227)

	if not v227 then
		break
	end

	v201(v171, v227)
end

local ipairs_ = ipairs
local value25 = t1.value25

for _, child in ipairs_(value25.GetChildren(value25)) do
	local Name = child.Name
	local v233 = not t16[Name]

	if v233 then
		v233 = not t9[Name]

		if v233 then
			v233 = not t1.value29[Name]

			if v233 then
				t2.value11 = not t13[Name]
				v233 = t2.value11

				if t2.value11 then
					v233 = not t14[Name]

					if v233 then
						v233 = not t15[Name]
					end
				end
			end
		end
	end

	if v233 then
		v201(v171, Name)
	end
end

t1.value9.ChildAdded:Connect(function(child)
	local value26 = t1.value26

	if value26 then
		value26 = t1.value17()
	end

	if not value26 then
		return
	end

	task.wait(0.1)
	t1.value30(child)
end)
t1.value31 = false
t1.value32 = "Butterfly Knife"
t1.value33 = false
t1.value34 = false
t1.value35 = false
t1.value36 = 0
t1.value37 = nil
t1.value38 = nil
t1.value39 = nil
t1.value40 = nil
t1.value41 = nil
t1.value42 = nil
t1.value43 = nil
t1.value44 = nil
t1.value45 = {
	Karambit = {
		Offset = CFrame.new(0, -1.5, 1.5)
	},
	["Butterfly Knife"] = {
		Offset = CFrame.new(0, -1.5, 1.5)
	},
	["M9 Bayonet"] = {
		Offset = CFrame.new(0, -1.5, 1)
	},
	["Flip Knife"] = {
		Offset = CFrame.new(0, -1.5, 1.25)
	},
	["Gut Knife"] = {
		Offset = CFrame.new(0, -1.5, 0.5)
	}
}
t1.value46 = nil

function t1.value46(p13)
	if p13:IsA("BasePart") then
		p13.CanCollide = false
		p13.Anchored = false
		p13.CastShadow = false
		p13.CanTouch = false
		p13.CanQuery = false
	end
end
function t1.value47(p14, p15, p16, p17, p18)
	local value37 = t1.value37
	local v236 = value37.FindFirstChild(value37, p15)

	if v236 then
		local clone = p14:WaitForChild(p16):Clone()

		t1.value46(clone)
		clone.Name = p17
		clone.Parent = v236

		local Motor6D = Instance.new("Motor6D")

		Motor6D.Part0 = v236
		Motor6D.Part1 = clone
		Motor6D.C0 = p18
		Motor6D.Parent = v236
	end
end
function t1.value48()
	t1.value33 = false
	t1.value6:UnbindAction("InspectKnifeAction")
	t1.value6:UnbindAction("AttackKnifeAction")

	if not t1.value37 then
		t1.value38 = nil
		t1.value34 = false
		t1.value35 = false

		return
	end

	t1.value37:Destroy()
	t1.value37 = nil
	t1.value38 = nil
	t1.value34 = false
	t1.value35 = false
end
function t1.value49(p19, p20)
	if p20 ~= Enum.UserInputState.Begin or not (t1.value33 and (t1.value38 and t1.value17())) then
		return Enum.ContextActionResult.Pass
	end

	if p19 == "InspectKnifeAction" then
		local value39 = t1.value39

		if value39 then
			value39 = t1.value39.IsPlaying
		end

		if value39 or (t1.value34 or t1.value35) then
			return Enum.ContextActionResult.Pass
		end

		t1.value34 = true

		if t1.value40 then
			t1.value40:Stop()
		end

		t1.value41:Play()
		t1.value41.Stopped:Once(function()
			t1.value34 = false
		end)
	else
		if p19 ~= "AttackKnifeAction" then
			return Enum.ContextActionResult.Pass
		end

		local now = os.clock()
		local value39 = t1.value39

		if value39 then
			value39 = t1.value39.IsPlaying
		end

		if value39 or now - t1.value36 < 1 then
			return Enum.ContextActionResult.Pass
		end

		if t1.value34 then
			t1.value34 = false

			if t1.value41 then
				t1.value41:Stop()
			end
		end

		t1.value35 = true

		if t1.value40 then
			t1.value40:Stop()
		end

		local t17 = { t1.value42, t1.value43, t1.value44 }
		local v243 = t17[math.random(1, #t17)]

		v243:Play()
		v243.Stopped:Once(function()
			t1.value35 = false
		end)
	end

	return Enum.ContextActionResult.Pass
end
function t1.value50(p21)
	if not (t1.value33 or not t1.value31) then
		local v244 = t1.value17()

		if v244 then
			t1.value33 = true
			t1.value37 = t1.value4.Assets.Weapons:WaitForChild(t1.value32):WaitForChild("Camera"):Clone()

			local value37 = t1.value37
			local value372 = t1.value37
			local value9 = t1.value9

			value37.Name = t1.value32
			value372.Parent = value9

			local v248, v249, v250 = ipairs(t1.value37:GetDescendants())

			while true do
				local v251

				v250, v251 = v248(v249, v250)

				if not v250 then
					break
				end

				t1.value46(v251)
			end

			for _, descendant in ipairs(p21.GetDescendants(p21)) do
				if descendant:IsA("BasePart") or (descendant:IsA("MeshPart") or descendant:IsA("Texture")) then
					descendant.Transparency = 1
				end
			end

			if v244.Parent.Name == "Terrorists" then
				local TGlove = t1.value4.Assets.Weapons:WaitForChild("T Glove")

				t1.value47(TGlove, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))
				t1.value47(TGlove, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))
			else
				local IDF = t1.value4.Assets.Sleeves:WaitForChild("IDF")
				local CTGlove = t1.value4.Assets.Weapons:WaitForChild("CT Glove")

				t1.value47(IDF, "Left Arm", "Left Arm", "Sleeve", CFrame.new(0, 0, 0.5))
				t1.value47(CTGlove, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))
				t1.value47(IDF, "Right Arm", "Right Arm", "Sleeve", CFrame.new(0, 0, 0.5))
				t1.value47(CTGlove, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))
			end

			local AnimationController = t1.value37:FindFirstChildOfClass("AnimationController") or t1.value37:FindFirstChildOfClass("Animator")

			t1.value38 = AnimationController:FindFirstChildWhichIsA("Animator") or AnimationController

			local CameraAnimations = t1.value4.Assets.WeaponAnimations:WaitForChild(t1.value32):WaitForChild("CameraAnimations")

			t1.value39 = t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Equip"))
			t1.value40 = t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Idle"))
			t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Inspect"))
			t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Heavy Swing"))
			t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Swing1"))
			t1.value38:LoadAnimation(CameraAnimations:WaitForChild("Swing2"))
			t1.value37:SetPrimaryPartCFrame(t1.value9.CFrame * CFrame.new(0, -1.5, 5))

			local value5 = t1.value5
			local PrimaryPart = t1.value37.PrimaryPart
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local CFrame_ = t1.value9.CFrame

			value5.Create(value5, PrimaryPart, tweenInfo, {
				CFrame = CFrame_ * t1.value45[t1.value32].Offset
			}):Play()
			t1.value39:Play()
			t1.value6:BindAction("InspectKnifeAction", t1.value49, false, Enum.KeyCode.F)
			t1.value6:BindAction("AttackKnifeAction", t1.value49, false, Enum.UserInputType.MouseButton1)

			return
		else
			return
		end
	end
end

v168.AddToggle(v168, "CustomKnifeToggle", {
	Text = "Enable Custom Knives",
	Default = false,
	Callback = function(p22)
		t1.value31 = p22

		if p22 then
			return
		end

		t1.value48()
	end
})
v168:AddDropdown("SelectCustomKnife", {
	Values = {
		"Butterfly Knife",
		"Karambit",
		"M9 Bayonet",
		"Flip Knife",
		"Gut Knife"
	},
	Default = 1,
	Callback = function(p23)
		t1.value32 = p23

		if not t1.value33 then
			return
		end

		t1.value48()
	end
})
v168:AddDivider()
t1.value51 = {}
t1.value52 = nil

function t1.value52(p24, p25, p26)
	if not p24 or (not p24:IsA("BasePart") or p24.Name == "Hitbox") then
		return
	end

	if p24.Color ~= p25 then
		p24.Color = p25
	end

	if p24.Material ~= p26 then
		p24.Material = p26
	end

	local isMeshPart = p24:IsA("MeshPart")

	if isMeshPart then
		isMeshPart = p24.TextureID ~= ""
	end

	local isSpecialMesh

	if not isMeshPart then
		for _, child in ipairs(p24:GetChildren()) do
			isSpecialMesh = child:IsA("SpecialMesh")

			if isSpecialMesh then
				isSpecialMesh = child.TextureId ~= ""
			end

			if isSpecialMesh then
				child.TextureId = ""
			elseif (child:IsA("SurfaceAppearance") or (child:IsA("Texture") or child:IsA("Decal"))) and not (child:IsA("WeldConstraint") or (child:IsA("Weld") or child:IsA("ManualWeld"))) then
				child:Destroy()
			end
		end

		return
	end

	p24.TextureID = ""

	for _, child in ipairs(p24:GetChildren()) do
		isSpecialMesh = child:IsA("SpecialMesh")

		if isSpecialMesh then
			isSpecialMesh = child.TextureId ~= ""
		end

		if isSpecialMesh then
			child.TextureId = ""
		elseif (child:IsA("SurfaceAppearance") or (child:IsA("Texture") or child:IsA("Decal"))) and not (child:IsA("WeldConstraint") or (child:IsA("Weld") or child:IsA("ManualWeld"))) then
			child:Destroy()
		end
	end
end
function t1.value53(p27, p28, p29, p30, p31, p32, p33)
	if p27 then
		t1.value52(p27, p28, p29)

		local GetDescendants = p27.GetDescendants

		for _, v in ipairs(GetDescendants(p27)) do
			if v:IsA("BasePart") then
				if v.Name == "Glove" then
					t1.value52(v, p30, p31)
				elseif v.Name == "Sleeve" then
					t1.value52(v, p32, p33)
				else
					t1.value52(v, p28, p29)
				end
			elseif v:IsA("SpecialMesh") then
				v.TextureId = ""
			elseif (v:IsA("SurfaceAppearance") or (v:IsA("Texture") or v:IsA("Decal"))) and not (v:IsA("WeldConstraint") or (v:IsA("Weld") or v:IsA("ManualWeld"))) then
				v:Destroy()
			end
		end
	end
end

t1.value54 = 0
t1.value1.Heartbeat:Connect(function(dt)
	local AAEnabled = t1.value17()

	if AAEnabled then
		AAEnabled = t1.value13.AAEnabled

		if AAEnabled then
			AAEnabled = t1.value13.AAEnabled.Value

			if AAEnabled then
				AAEnabled = t1.value12.AAYaw

				if AAEnabled then
					AAEnabled = t1.value12.AASpeed
				end
			end
		end
	end

	if not AAEnabled then
		return
	end

	local Character = t1.value8.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local Humanoid

	if HumanoidRootPart then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid = Character:FindFirstChildOfClass("Humanoid").Health > 0
		end
	else
		Humanoid = HumanoidRootPart
	end

	if not Humanoid then
		return
	end

	local Value = t1.value12.AAYaw.Value
	local n1 = 0

	if Value == "Spinbot" then
		t1.value54 = t1.value54 + t1.value12.AASpeed.Value * dt * 10

		local value54 = t1.value54

		n1 = math.rad(value54)
	elseif Value == "Jitter" then
		local v279 = math.random(-180, 180)

		n1 = math.rad(v279)
	elseif Value == "Backward" then
		local LookVector = t1.value9.CFrame.LookVector
		local v281 = -LookVector.X
		local v282 = -LookVector.Z

		n1 = math.atan2(v281, v282) + 3.141592653589793
	elseif Value == "Sideways" then
		local LookVector = t1.value9.CFrame.LookVector
		local v284 = -LookVector.X
		local v285 = -LookVector.Z

		n1 = math.atan2(v284, v285) + 1.5707963267948966
	end

	HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, n1, 0)
end)

local value1 = t1.value1
local Enum_ = Enum

value1.BindToRenderStep(value1, "ThirdPersonOverride", Enum_.RenderPriority.Camera.Value + 1, function()
	local v288 = t1.value17()
	local TPEnabled = t1.value13.TPEnabled

	if TPEnabled then
		TPEnabled = t1.value13.TPEnabled.Value

		if TPEnabled then
			if v288 then
				TPEnabled = t1.value12.TPDistance

				if TPEnabled then
					TPEnabled = t1.value12.TPOffsetX
				end
			else
				TPEnabled = v288
			end
		end
	end

	if TPEnabled then
		local Character = t1.value8.Character
		local Head

		if Character then
			Head = Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
		else
			Head = Character
		end

		if not Head then
			return
		end

		local Value = t1.value12.TPDistance.Value
		local Value2 = t1.value12.TPOffsetX.Value
		local cFrame = CFrame.new(Value2, 1.5, Value)

		t1.value9.CFrame = CFrame.new(Head.Position) * t1.value9.CFrame.Rotation * cFrame

		local GetDescendants = Character.GetDescendants
		local v296, v297, v298 = ipairs(GetDescendants(Character))

		while true do
			local v299

			v298, v299 = v296(v297, v298)

			if not v298 then
				break
			end

			local isBasePart = v299:IsA("BasePart")

			if isBasePart then
				isBasePart = v299.Name ~= "HumanoidRootPart"
			end

			if isBasePart and v299.LocalTransparencyModifier > 0.5 then
				v299.LocalTransparencyModifier = 0
			end
		end

		local TPHideVM = t1.value13.TPHideVM

		if TPHideVM then
			TPHideVM = t1.value13.TPHideVM.Value
		end

		if not TPHideVM then
			return
		end

		local value37 = t1.value37

		if value37 then
			value37 = t1.value37.Parent
		end

		local isModel, GetDescendants2

		if not value37 then
			v333 = ipairs
			v334 = t1.value9

			for _, child in v333(v334.GetChildren(v334)) do
				isModel = child:IsA("Model")

				if isModel then
					isModel = child ~= t1.value37
				end

				if isModel then
					GetDescendants2 = child.GetDescendants

					for _, v in ipairs(GetDescendants2(child)) do
						if v:IsA("BasePart") or v:IsA("MeshPart") then
							v.LocalTransparencyModifier = 1
						end
					end
				end
			end

			return
		end

		local ipairs_2 = ipairs
		local value372 = t1.value37

		for _, descendant in ipairs_2(value372.GetDescendants(value372)) do
			if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
				descendant.LocalTransparencyModifier = 1
			end
		end

		local ipairs_3 = ipairs
		local value9 = t1.value9

		for _, child in ipairs_3(value9.GetChildren(value9)) do
			isModel = child:IsA("Model")

			if isModel then
				isModel = child ~= t1.value37
			end

			if isModel then
				GetDescendants2 = child.GetDescendants

				for _, v in ipairs(GetDescendants2(child)) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						v.LocalTransparencyModifier = 1
					end
				end
			end
		end
	else
		if not v288 then
			return
		end

		local value37 = t1.value37

		if value37 then
			value37 = t1.value37.Parent
		end

		if value37 then
			local ipairs_2 = ipairs
			local value372 = t1.value37

			for _, descendant in ipairs_2(value372.GetDescendants(value372)) do
				if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
					descendant.LocalTransparencyModifier = 0
				end
			end
		end

		local ipairs_2 = ipairs
		local value9 = t1.value9

		for _, child in ipairs_2(value9.GetChildren(value9)) do
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child ~= t1.value37
			end

			if isModel then
				local GetDescendants = child.GetDescendants

				for _, v in ipairs(GetDescendants(child)) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		end
	end
end)
t1.value55 = {}

function t1.value56()
	local t18 = {
		Box = Drawing.new("Square"),
		Name = Drawing.new("Text"),
		HBBg = Drawing.new("Square"),
		HB = Drawing.new("Square"),
		HText = Drawing.new("Text"),
		Tracer = Drawing.new("Line"),
		HeadDot = Drawing.new("Circle")
	}

	t18.Box.Thickness = 1
	t18.Box.Filled = false
	t18.Name.Size = 14
	t18.Name.Center = true
	t18.Name.Outline = true
	t18.HBBg.Filled = true
	t18.HBBg.Color = Color3.new(0, 0, 0)
	t18.HB.Filled = true
	t18.HText.Size = 12
	t18.HText.Center = true
	t18.HText.Outline = true
	t18.Tracer.Thickness = 1
	t18.HeadDot.Filled = true
	t18.HeadDot.Radius = 3

	return t18
end

t1.value57 = {
	Top = Drawing.new("Line"),
	Bottom = Drawing.new("Line"),
	Left = Drawing.new("Line"),
	Right = Drawing.new("Line")
}

local function v335()
	return t1.value9:FindFirstChild("T Knife") or t1.value9:FindFirstChild("CT Knife")
end

for _, v in pairs(t1.value57) do
	v.Thickness = 1.5
	v.Visible = false
end

local RenderStepped = t1.value1.RenderStepped

RenderStepped.Connect(RenderStepped, function()
	local EnableCustomFOV = t1.value13.EnableCustomFOV

	if EnableCustomFOV then
		EnableCustomFOV = t1.value13.EnableCustomFOV.Value

		if EnableCustomFOV then
			EnableCustomFOV = t1.value12.WorldFOVVal
		end
	end

	if EnableCustomFOV then
		t1.value9.FieldOfView = t1.value12.WorldFOVVal.Value
	end

	local FullbrightToggle = t1.value13.FullbrightToggle

	if FullbrightToggle then
		FullbrightToggle = t1.value13.FullbrightToggle.Value
	end

	if FullbrightToggle then
		t1.value7.Ambient = Color3.new(1, 1, 1)
		t1.value7.OutdoorAmbient = Color3.new(1, 1, 1)
		t1.value7.GlobalShadows = false
	end

	local NightModeToggle = t1.value13.NightModeToggle

	if NightModeToggle then
		NightModeToggle = t1.value13.NightModeToggle.Value
	end

	if NightModeToggle then
		t1.value7.ClockTime = 0
	elseif t1.value12.WorldTimeSlider then
		t1.value7.ClockTime = t1.value12.WorldTimeSlider.Value
	end

	local EnableCrosshair2 = t1.value13.EnableCrosshair

	if EnableCrosshair2 then
		EnableCrosshair2 = t1.value13.EnableCrosshair.Value

		if EnableCrosshair2 then
			EnableCrosshair2 = t1.value12.CrosshairSize

			if EnableCrosshair2 then
				EnableCrosshair2 = t1.value12.CrosshairGap

				if EnableCrosshair2 then
					EnableCrosshair2 = t1.value12.ColorCrosshair
				end
			end
		end
	end

	if EnableCrosshair2 then
		local mouseLocation = t1.value3:GetMouseLocation()
		local Value = t1.value12.CrosshairSize.Value
		local Value2 = t1.value12.CrosshairGap.Value
		local Value3 = t1.value12.ColorCrosshair.Value

		t1.value57.Top.From = Vector2.new(mouseLocation.X, mouseLocation.Y - Value2)
		t1.value57.Top.To = Vector2.new(mouseLocation.X, mouseLocation.Y - Value2 - Value)
		t1.value57.Top.Color = Value3
		t1.value57.Top.Visible = true
		t1.value57.Bottom.From = Vector2.new(mouseLocation.X, mouseLocation.Y + Value2)
		t1.value57.Bottom.To = Vector2.new(mouseLocation.X, mouseLocation.Y + Value2 + Value)
		t1.value57.Bottom.Color = Value3
		t1.value57.Bottom.Visible = true
		t1.value57.Left.From = Vector2.new(mouseLocation.X - Value2, mouseLocation.Y)
		t1.value57.Left.To = Vector2.new(mouseLocation.X - Value2 - Value, mouseLocation.Y)
		t1.value57.Left.Color = Value3
		t1.value57.Left.Visible = true
		t1.value57.Right.From = Vector2.new(mouseLocation.X + Value2, mouseLocation.Y)
		t1.value57.Right.To = Vector2.new(mouseLocation.X + Value2 + Value, mouseLocation.Y)
		t1.value57.Right.Color = Value3
		t1.value57.Right.Visible = true
	else
		for _, v in pairs(t1.value57) do
			v.Visible = false
		end
	end

	local ShowFOV = t1.value13.ShowFOV

	if ShowFOV then
		ShowFOV = t1.value13.ShowFOV.Value

		if ShowFOV then
			ShowFOV = t1.value12.FOVRadius

			if ShowFOV then
				ShowFOV = t1.value12.ColorFOV
			end
		end
	end

	if ShowFOV then
		t1.value23.Position = t1.value3:GetMouseLocation()
		t1.value23.Radius = t1.value12.FOVRadius.Value
		t1.value23.Color = t1.value12.ColorFOV.Value
		t1.value23.Visible = true
	else
		t1.value23.Visible = false
	end

	local AimbotEnabled = t1.value13.AimbotEnabled

	if AimbotEnabled then
		AimbotEnabled = t1.value13.AimbotEnabled.Value

		if AimbotEnabled then
			AimbotEnabled = t1.value12.AimbotKey

			if AimbotEnabled then
				AimbotEnabled = t1.value12.AimbotKey:GetState()

				if AimbotEnabled then
					AimbotEnabled = t1.value12.AimbotSmoothing

					if AimbotEnabled then
						AimbotEnabled = t1.value17()
					end
				end
			end
		end
	end

	local v349 = AimbotEnabled and t1.value24()

	if v349 then
		local v350, v351 = t1.value9:WorldToViewportPoint(v349.Position)

		if v351 then
			local mouseLocation = t1.value3:GetMouseLocation()
			local Value = t1.value12.AimbotSmoothing.Value
			local v354 = (v350.X - mouseLocation.X) / Value
			local v355 = (v350.Y - mouseLocation.Y) / Value

			if mousemoverel then
				mousemoverel(v354, v355)
			end
		end
	end

	local BunnyHop = t1.value13.BunnyHop

	if BunnyHop then
		BunnyHop = t1.value13.BunnyHop.Value

		if BunnyHop then
			BunnyHop = t1.value3:IsKeyDown(Enum.KeyCode.Space)
		end
	end

	local v357 = BunnyHop and t1.value17()

	if v357 then
		local Humanoid = v357:FindFirstChildOfClass("Humanoid")
		local v359

		if Humanoid then
			v359 = Humanoid.FloorMaterial ~= Enum.Material.Air
		else
			v359 = Humanoid
		end

		if v359 then
			Humanoid.Jump = true
		end
	end

	local v360 = t1.value18()
	local t19 = {}
	local EnableESP

	if v360 then
		EnableESP = t1.value13.EnableESP

		if EnableESP then
			EnableESP = t1.value13.EnableESP.Value
		end
	else
		EnableESP = v360
	end

	if EnableESP then
		local GetChildren = v360.GetChildren

		for _, v in ipairs(GetChildren(v360)) do
			if v:IsA("Model") then
				t19[v] = true
			end
		end
	end

	local v366, v367, v368 = pairs(t1.value55)

	while true do
		local v369

		v368, v369 = v366(v367, v368)

		if not v368 then
			break
		end

		if not t19[v368] then
			v369.Box.Visible = false
			v369.Name.Visible = false
			v369.HBBg.Visible = false
			v369.HB.Visible = false
			v369.HText.Visible = false
			v369.Tracer.Visible = false
			v369.HeadDot.Visible = false

			if v368:FindFirstChild("DarkHubChams") then
				v368.DarkHubChams:Destroy()
			end
		end
	end

	local v370, v371, v372 = pairs(t19)

	while true do
		local v373

		v372, v373 = v370(v371, v372)

		if not v372 then
			break
		end

		if not t1.value55[v372] then
			t1.value55[v372] = t1.value56()
		end

		local v374 = t1.value55[v372]
		local HumanoidRootPart = v372:FindFirstChild("HumanoidRootPart") or (v372:FindFirstChild("Torso") or v372.PrimaryPart)
		local Head = v372:FindFirstChild("Head") or HumanoidRootPart
		local v377, v378 = t1.value19(v372)
		local v379

		if HumanoidRootPart then
			if Head then
				v379 = v377 > 0
			else
				v379 = Head
			end
		else
			v379 = HumanoidRootPart
		end

		if v379 then
			local v380, v381 = t1.value9:WorldToViewportPoint(HumanoidRootPart.Position)
			local v382 = t1.value9:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
			local value9 = t1.value9
			local Position = HumanoidRootPart.Position
			local Vector3_ = Vector3
			local v386 = value9.WorldToViewportPoint(value9, Position - Vector3_.new(0, 3, 0))

			if v381 then
				v381 = v380.Z > 0
			end

			if v381 then
				local v387 = v382.Y - v386.Y
				local v388 = math.abs(v387)
				local v389 = v388 * 0.65
				local v390 = v380.X - v389 / 2
				local Y = v382.Y
				local Color_ESP_Box = t1.value12.Color_ESP_Box

				if Color_ESP_Box then
					Color_ESP_Box = t1.value12.Color_ESP_Box.Value
				end

				local color33 = Color_ESP_Box or Color3.fromRGB(220, 20, 60)
				local ESP_WallCheck2 = t1.value13.ESP_WallCheck

				if ESP_WallCheck2 then
					ESP_WallCheck2 = t1.value13.ESP_WallCheck.Value

					if ESP_WallCheck2 then
						ESP_WallCheck2 = t1.value20(Head, v372)
					end
				end

				if ESP_WallCheck2 then
					local Color_ESP_Visible = t1.value12.Color_ESP_Visible

					if Color_ESP_Visible then
						Color_ESP_Visible = t1.value12.Color_ESP_Visible.Value
					end

					color33 = Color_ESP_Visible or Color3.fromRGB(0, 255, 0)
				end

				local ESP_Box2 = t1.value13.ESP_Box

				if ESP_Box2 then
					ESP_Box2 = t1.value13.ESP_Box.Value
				end

				if ESP_Box2 then
					v374.Box.Color = color33
					v374.Box.Size = Vector2.new(v389, v388)
					v374.Box.Position = Vector2.new(v390, Y)
					v374.Box.Visible = true
				else
					v374.Box.Visible = false
				end

				local ESP_Name2 = t1.value13.ESP_Name

				if ESP_Name2 then
					ESP_Name2 = t1.value13.ESP_Name.Value
				end

				if ESP_Name2 then
					local Name = v374.Name
					local s9 = "Color"
					local Color_ESP_Name = t1.value12.Color_ESP_Name

					if Color_ESP_Name then
						Color_ESP_Name = t1.value12.Color_ESP_Name.Value
					end

					Name[s9] = Color_ESP_Name or Color3.fromRGB(255, 255, 255)

					local ESP_Distance = t1.value13.ESP_Distance

					if ESP_Distance then
						ESP_Distance = t1.value13.ESP_Distance.Value
					end

					if ESP_Distance then
						local format = string.format
						local Magnitude = (HumanoidRootPart.Position - t1.value9.CFrame.Position).Magnitude

						ESP_Distance = format(" [%dm]", (math.floor(Magnitude)))
					end

					v374.Name.Text = v372.Name .. (ESP_Distance or "")
					v374.Name.Position = Vector2.new(v380.X, Y - 18)
					v374.Name.Visible = true
				else
					v374.Name.Visible = false
				end

				local v404 = v377 / v378
				local v405 = math.clamp(v404, 0, 1)
				local v406 = v388 * v405
				local ESP_Bar = t1.value13.ESP_Bar

				if ESP_Bar then
					ESP_Bar = t1.value13.ESP_Bar.Value
				end

				if ESP_Bar then
					v374.HBBg.Size = Vector2.new(2, v388)
					v374.HBBg.Position = Vector2.new(v390 - 6, Y)
					v374.HBBg.Visible = true
					v374.HB.Color = Color3.new(1 - v405, v405, 0)
					v374.HB.Size = Vector2.new(2, v406)

					local HB = v374.HB
					local vector2New = Vector2.new
					local v410 = Y + (v388 - v406)

					HB.Position = vector2New(v390 - 6, v410)
					v374.HB.Visible = true
				else
					v374.HBBg.Visible = false
					v374.HB.Visible = false
				end

				local ESP_Text = t1.value13.ESP_Text

				if ESP_Text then
					ESP_Text = t1.value13.ESP_Text.Value
				end

				if ESP_Text then
					local HText = v374.HText
					local v413 = math.floor(v377)

					HText.Text = tostring(v413)
					v374.HText.Color = Color3.new(1 - v405, v405, 0)

					local HText2 = v374.HText
					local vector2New = Vector2.new
					local v416 = Y + (v388 - v406) - 6

					HText2.Position = vector2New(v390 - 18, v416)
					v374.HText.Visible = true
				else
					v374.HText.Visible = false
				end

				local ESP_Tracers2 = t1.value13.ESP_Tracers

				if ESP_Tracers2 then
					ESP_Tracers2 = t1.value13.ESP_Tracers.Value
				end

				if ESP_Tracers2 then
					v374.Tracer.From = Vector2.new(t1.value9.ViewportSize.X / 2, t1.value9.ViewportSize.Y)
					v374.Tracer.To = Vector2.new(v380.X, v380.Y)

					local Tracer = v374.Tracer
					local s10 = "Color"
					local Color_ESP_Tracers = t1.value12.Color_ESP_Tracers

					if Color_ESP_Tracers then
						Color_ESP_Tracers = t1.value12.Color_ESP_Tracers.Value
					end

					Tracer[s10] = Color_ESP_Tracers or Color3.fromRGB(255, 255, 255)
					v374.Tracer.Visible = true
				else
					v374.Tracer.Visible = false
				end

				local ESP_HeadDot2 = t1.value13.ESP_HeadDot

				if ESP_HeadDot2 then
					ESP_HeadDot2 = t1.value13.ESP_HeadDot.Value
				end

				if ESP_HeadDot2 then
					local v422 = t1.value9:WorldToViewportPoint(Head.Position)

					v374.HeadDot.Position = Vector2.new(v422.X, v422.Y)

					local HeadDot = v374.HeadDot
					local s11 = "Color"
					local Color_ESP_HeadDot = t1.value12.Color_ESP_HeadDot

					if Color_ESP_HeadDot then
						Color_ESP_HeadDot = t1.value12.Color_ESP_HeadDot.Value
					end

					HeadDot[s11] = Color_ESP_HeadDot or Color3.fromRGB(255, 255, 0)
					v374.HeadDot.Visible = true
				else
					v374.HeadDot.Visible = false
				end

				local ESP_Chams2 = t1.value13.ESP_Chams

				if ESP_Chams2 then
					ESP_Chams2 = t1.value13.ESP_Chams.Value
				end

				if ESP_Chams2 then
					local ESP_WallCheck3 = t1.value13.ESP_WallCheck

					if ESP_WallCheck3 then
						ESP_WallCheck3 = t1.value13.ESP_WallCheck.Value

						if ESP_WallCheck3 then
							ESP_WallCheck3 = t1.value20(Head, v372)
						end
					end

					if ESP_WallCheck3 then
						local Color_ESP_Visible = t1.value12.Color_ESP_Visible

						if Color_ESP_Visible then
							Color_ESP_Visible = t1.value12.Color_ESP_Visible.Value
						end

						ESP_WallCheck3 = Color_ESP_Visible or Color3.fromRGB(0, 255, 0)
					end

					if not ESP_WallCheck3 then
						local Color_ESP_Chams = t1.value12.Color_ESP_Chams

						if Color_ESP_Chams then
							Color_ESP_Chams = t1.value12.Color_ESP_Chams.Value
						end

						ESP_WallCheck3 = Color_ESP_Chams or Color3.fromRGB(220, 20, 60)
					end

					local DarkHubChams = v372:FindFirstChild("DarkHubChams")

					if not DarkHubChams then
						DarkHubChams = Instance.new("Highlight", v372)
						DarkHubChams.Name = "DarkHubChams"
					end

					DarkHubChams.FillColor = ESP_WallCheck3
					DarkHubChams.FillTransparency = 0.5
					DarkHubChams.OutlineTransparency = 1
					DarkHubChams.Enabled = true
					DarkHubChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				elseif v372:FindFirstChild("DarkHubChams") then
					v372.DarkHubChams:Destroy()
				end
			else
				v374.Box.Visible = false
				v374.Name.Visible = false
				v374.HBBg.Visible = false
				v374.HB.Visible = false
				v374.HText.Visible = false
				v374.Tracer.Visible = false
				v374.HeadDot.Visible = false

				if v372:FindFirstChild("DarkHubChams") then
					v372.DarkHubChams:Destroy()
				end
			end
		end
	end

	local EnableVM = t1.value13.EnableVM

	if EnableVM then
		EnableVM = t1.value13.EnableVM.Value

		if EnableVM then
			EnableVM = t1.value12.Color_Weapon

			if EnableVM then
				EnableVM = t1.value12.Mat_Weapon

				if EnableVM then
					EnableVM = t1.value12.Color_Arms

					if EnableVM then
						EnableVM = t1.value12.Mat_Arms

						if EnableVM then
							EnableVM = t1.value12.Color_Gloves

							if EnableVM then
								EnableVM = t1.value12.Mat_Gloves

								if EnableVM then
									EnableVM = t1.value12.Color_Sleeves

									if EnableVM then
										EnableVM = t1.value12.Mat_Sleeves
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if EnableVM then
		local Value = t1.value12.Color_Weapon.Value
		local Name = Enum.Material[t1.value12.Mat_Weapon.Value].Name
		local Value2 = t1.value12.Color_Arms.Value
		local Name2 = Enum.Material[t1.value12.Mat_Arms.Value].Name
		local Value3 = t1.value12.Color_Gloves.Value
		local Name3 = Enum.Material[t1.value12.Mat_Gloves.Value].Name
		local Value4 = t1.value12.Color_Sleeves.Value
		local Name4 = Enum.Material[t1.value12.Mat_Sleeves.Value].Name
		local ipairs_2 = ipairs
		local value9 = t1.value9

		for _, child in ipairs_2(value9.GetChildren(value9)) do
			if child:IsA("Model") then
				local v444 = child.Name .. Name .. Name2 .. tostring(Value)

				if t1.value51[child] ~= v444 then
					local Weapon2 = child:FindFirstChild("Weapon")

					if not Weapon2 then
						if child.Name == t1.value32 then
							Weapon2 = child
						else
							Weapon2 = false
						end
					end

					if Weapon2 then
						for _, descendant in ipairs(Weapon2.GetDescendants(Weapon2)) do
							t1.value52(descendant, Value, Enum.Material[Name])
						end
					end

					local LeftArm = child:FindFirstChild("Left Arm")

					if LeftArm then
						t1.value53(LeftArm, Value2, Enum.Material[Name2], Value3, Enum.Material[Name3], Value4, Enum.Material[Name4])
					end

					local RightArm = child:FindFirstChild("Right Arm")

					if RightArm then
						t1.value53(RightArm, Value2, Enum.Material[Name2], Value3, Enum.Material[Name3], Value4, Enum.Material[Name4])
					end

					t1.value51[child] = v444
				end
			end
		end
	else
		t1.value51 = {}
	end

	local value31 = t1.value31

	if value31 then
		value31 = t1.value37

		if value31 then
			value31 = t1.value37.PrimaryPart
		end
	end

	if not value31 then
		return
	end

	t1.value37.PrimaryPart.CFrame = t1.value9.CFrame * t1.value45[t1.value32].Offset

	local value39 = t1.value39

	if value39 then
		value39 = t1.value39.IsPlaying
	end

	local v452 = not value39

	if v452 then
		v452 = not t1.value34

		if v452 then
			v452 = not t1.value35
		end
	end

	if not v452 then
		return
	end

	local value40 = t1.value40

	if value40 then
		value40 = not t1.value40.IsPlaying
	end

	if not value40 then
		return
	end

	t1.value40:Play()
end)
t1.value3.JumpRequest:Connect(function()
	local InfiniteJumpToggle = t1.value13.InfiniteJumpToggle

	if InfiniteJumpToggle then
		InfiniteJumpToggle = t1.value13.InfiniteJumpToggle.Value
	end

	if not InfiniteJumpToggle then
		return
	end

	local v455 = t1.value17()
	local Humanoid = v455 and v455:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
task.spawn(function()
	while task.wait(0.1) do
		local v457 = t1.value17()
		local v458 = v335()
		local value31 = t1.value31

		if value31 then
			if v457 then
				if v458 then
					value31 = not t1.value33
				else
					value31 = v458
				end
			else
				value31 = v457
			end
		end

		if value31 then
			t1.value50(v458)
		else
			local v460 = not (t1.value31 and (v458 and v457))

			if v460 then
				v460 = t1.value33
			end

			if v460 then
				t1.value48()
			end
		end

		if t1.value26 and v457 then
			local ipairs_2 = ipairs
			local value9 = t1.value9

			for _, child in ipairs_2(value9.GetChildren(value9)) do
				local v465 = t1.value27[child.Name]

				if v465 then
					v465 = child:GetAttribute("SkinApplied") ~= t1.value27[child.Name]
				end

				if v465 then
					t1.value30(child)
				end
			end
		end
	end
end)
task.spawn(function()
	while task.wait(0.2) do
		local AntiFlashToggle = t1.value13.AntiFlashToggle

		if AntiFlashToggle then
			AntiFlashToggle = t1.value13.AntiFlashToggle.Value
		end

		if AntiFlashToggle then
			local PlayerGui = t1.value8:FindFirstChild("PlayerGui")
			local FlashbangEffect = PlayerGui and PlayerGui:FindFirstChild("FlashbangEffect")

			if FlashbangEffect then
				FlashbangEffect:Destroy()
			end

			local FlashbangColorCorrection = t1.value7:FindFirstChild("FlashbangColorCorrection")

			if FlashbangColorCorrection then
				FlashbangColorCorrection:Destroy()
			end
		end
	end
end)
task.spawn(function()
	while task.wait(0.5) do
		local AntiSmokeToggle = t1.value13.AntiSmokeToggle

		if AntiSmokeToggle then
			AntiSmokeToggle = t1.value13.AntiSmokeToggle.Value
		end

		local Debris = AntiSmokeToggle and t1.value2:FindFirstChild("Debris")

		if Debris then
			for _, child in ipairs(Debris:GetChildren()) do
				if string.match(child.Name, "Voxel") then
					child:ClearAllChildren()
					child:Destroy()
				end
			end
		end
	end
end)
t5.Settings:AddLeftGroupbox("Menu"):AddButton({
	Text = "Unload Script",
	Func = function()
		t1.value11:Unload()
	end
})
lib:SetLibrary(t1.value11)
lib2:SetLibrary(t1.value11)
lib2:IgnoreThemeSettings()
lib2:SetIgnoreIndexes({ "MenuKeybind" })
lib:SetFolder("DarkHub")
lib2:SetFolder("DarkHub/Config")
lib2:BuildConfigSection(t5.Settings)
lib:ApplyToTab(t5.Settings)
lib2:LoadAutoloadConfig()
t1.value11.AccentColor = Color3.fromRGB(220, 20, 60)
t1.value11.MainColor = Color3.fromRGB(25, 25, 25)
t1.value11.BackgroundColor = Color3.fromRGB(15, 15, 15)
t1.value11.OutlineColor = Color3.fromRGB(50, 50, 50)
t1.value11:UpdateColorsUsingRegistry()
t1.value11:OnUnload(function()
	t1.value23:Remove()

	local v474, v475, v476 = pairs(t1.value57)

	while true do
		local v477

		v476, v477 = v474(v475, v476)

		if not v476 then
			break
		end

		v477:Remove()
	end

	t1.value1:UnbindFromRenderStep("ThirdPersonOverride")

	local v478, Parent, GetChildren, v481

	if not t1.value17() then
		v503, v504, v505 = pairs(t1.value21)

		while true do
			v505, v478 = v503(v504, v505)

			if not v505 then
				break
			end

			if v505 then
				Parent = v505.Parent
			else
				Parent = v505
			end

			if Parent then
				v505.Size = v478
				v505.Transparency = 0
				GetChildren = v505.GetChildren

				for _, v in ipairs(GetChildren(v505)) do
					if v:IsA("Decal") then
						v.Transparency = 0
					end
				end
			end
		end

		v507, v508, v509 = pairs(t1.value22)

		while true do
			v509, v481 = v507(v508, v509)

			if not v509 then
				break
			end

			if v481 then
				v481:Destroy()
			end
		end

		for _, v in pairs(t1.value55) do
			v.Box:Remove()
			v.Name:Remove()
			v.HBBg:Remove()
			v.HB:Remove()
			v.HText:Remove()
			v.Tracer:Remove()
			v.HeadDot:Remove()
		end

		table.clear(t1.value55)
		table.clear(t1.value51)

		return
	end

	local value37 = t1.value37

	if value37 then
		value37 = t1.value37.Parent
	end

	if value37 then
		local ipairs_2 = ipairs
		local value372 = t1.value37

		for _, descendant in ipairs_2(value372.GetDescendants(value372)) do
			if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
				descendant.LocalTransparencyModifier = 0
			end
		end
	end

	local ipairs_2 = ipairs
	local value9 = t1.value9

	for _, child in ipairs_2(value9.GetChildren(value9)) do
		local isModel = child:IsA("Model")

		if isModel then
			isModel = child ~= t1.value37
		end

		if isModel then
			for _, descendant in ipairs(child.GetDescendants(child)) do
				if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
					descendant.LocalTransparencyModifier = 0
				end
			end
		end
	end

	local v498, v499, v500 = pairs(t1.value21)

	while true do
		v500, v478 = v498(v499, v500)

		if not v500 then
			break
		end

		if v500 then
			Parent = v500.Parent
		else
			Parent = v500
		end

		if Parent then
			v500.Size = v478
			v500.Transparency = 0
			GetChildren = v500.GetChildren

			for _, v in ipairs(GetChildren(v500)) do
				if v:IsA("Decal") then
					v.Transparency = 0
				end
			end
		end
	end

	local v506, v510, v511 = pairs(t1.value22)

	while true do
		v511, v481 = v506(v510, v511)

		if not v511 then
			break
		end

		if v481 then
			v481:Destroy()
		end
	end

	for _, v in pairs(t1.value55) do
		v.Box:Remove()
		v.Name:Remove()
		v.HBBg:Remove()
		v.HB:Remove()
		v.HText:Remove()
		v.Tracer:Remove()
		v.HeadDot:Remove()
	end

	table.clear(t1.value55)
	table.clear(t1.value51)
end)
