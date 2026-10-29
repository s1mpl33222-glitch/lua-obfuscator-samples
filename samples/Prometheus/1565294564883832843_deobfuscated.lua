-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = game:GetService("Players")
}
local RunService = game:GetService("RunService")

t1.value2 = game:GetService("UserInputService")

local game_ = game

t1.value3 = game_.GetService(game_, "VirtualInputManager")

local game_2 = game

t1.value4 = game_2.GetService(game_2, "TweenService")
t1.value5 = game:GetService("GuiService")
t1.value6 = game:GetService("Lighting")

local game_3 = game

t1.value7 = game_3.GetService(game_3, "ReplicatedStorage")
t1.value8 = game:GetService("HttpService")
t1.value9 = nil
t1.value10 = t1.value1.LocalPlayer
t1.value11 = t1.value10:WaitForChild("PlayerGui")
t1.value12 = {
	AutoGreatZone = false,
	GreatZoneOffset = 105,
	HitWindow = 14,
	ESPEnabled = false,
	SpeedEnabled = false,
	SpeedValue = 24,
	SpeedKey = Enum.KeyCode.B,
	NoclipEnabled = false,
	NoclipKey = Enum.KeyCode.N,
	AutoWiggle = false,
	AutoHeal = false,
	NoFall = false,
	AutoPallet = false,
	PalletStunDist = 12,
	FastVault = false,
	GenESPEnabled = false,
	FullbrightEnabled = false,
	AutoParry = false,
	ParryDistance = 13,
	SilentAim = false,
	ShowTracer = true,
	TracerColor = Color3.fromRGB(255, 60, 80),
	AimTarget = "Killer",
	UIVisible = true,
	ToggleKey = Enum.KeyCode.RightControl,
	UITheme = "Crimson",
	StreamerMode = true,
	StreamerPort = 8765
}
t1.value13 = {
	Crimson = {
		Accent = Color3.fromRGB(255, 75, 90),
		AccentDim = Color3.fromRGB(220, 45, 70),
		Bg = Color3.fromRGB(16, 12, 16),
		Header = Color3.fromRGB(18, 14, 18),
		Sidebar = Color3.fromRGB(14, 11, 14),
		Card = Color3.fromRGB(22, 16, 20),
		CardOn = Color3.fromRGB(32, 18, 24),
		CardHover = Color3.fromRGB(34, 22, 28),
		TabOn = Color3.fromRGB(42, 18, 26),
		TabOff = Color3.fromRGB(16, 12, 16),
		Stroke = Color3.fromRGB(52, 24, 34),
		StrokeOn = Color3.fromRGB(255, 70, 88),
		Text = Color3.fromRGB(244, 236, 240),
		TextMuted = Color3.fromRGB(150, 136, 146),
		Track = Color3.fromRGB(32, 20, 26),
		BoxOff = Color3.fromRGB(32, 22, 28),
		WindowStroke = Color3.fromRGB(58, 26, 36),
		HeaderLine = Color3.fromRGB(86, 28, 42)
	},
	Ocean = {
		Accent = Color3.fromRGB(80, 168, 255),
		AccentDim = Color3.fromRGB(48, 130, 220),
		Bg = Color3.fromRGB(12, 16, 22),
		Header = Color3.fromRGB(14, 18, 26),
		Sidebar = Color3.fromRGB(11, 14, 20),
		Card = Color3.fromRGB(16, 22, 30),
		CardOn = Color3.fromRGB(18, 32, 48),
		CardHover = Color3.fromRGB(22, 34, 48),
		TabOn = Color3.fromRGB(20, 40, 62),
		TabOff = Color3.fromRGB(14, 18, 24),
		Stroke = Color3.fromRGB(28, 48, 70),
		StrokeOn = Color3.fromRGB(80, 168, 255),
		Text = Color3.fromRGB(230, 238, 248),
		TextMuted = Color3.fromRGB(130, 150, 170),
		Track = Color3.fromRGB(20, 30, 42),
		BoxOff = Color3.fromRGB(22, 30, 40),
		WindowStroke = Color3.fromRGB(32, 52, 74),
		HeaderLine = Color3.fromRGB(36, 70, 110)
	},
	Sage = {
		Accent = Color3.fromRGB(72, 196, 140),
		AccentDim = Color3.fromRGB(46, 160, 110),
		Bg = Color3.fromRGB(12, 16, 14),
		Header = Color3.fromRGB(14, 18, 16),
		Sidebar = Color3.fromRGB(11, 15, 13),
		Card = Color3.fromRGB(16, 22, 18),
		CardOn = Color3.fromRGB(18, 36, 28),
		CardHover = Color3.fromRGB(22, 36, 28),
		TabOn = Color3.fromRGB(20, 44, 34),
		TabOff = Color3.fromRGB(14, 18, 16),
		Stroke = Color3.fromRGB(28, 52, 40),
		StrokeOn = Color3.fromRGB(72, 196, 140),
		Text = Color3.fromRGB(232, 242, 236),
		TextMuted = Color3.fromRGB(132, 154, 142),
		Track = Color3.fromRGB(20, 32, 26),
		BoxOff = Color3.fromRGB(22, 32, 26),
		WindowStroke = Color3.fromRGB(32, 56, 42),
		HeaderLine = Color3.fromRGB(36, 90, 64)
	},
	Violet = {
		Accent = Color3.fromRGB(176, 132, 255),
		AccentDim = Color3.fromRGB(140, 96, 230),
		Bg = Color3.fromRGB(16, 12, 22),
		Header = Color3.fromRGB(18, 14, 26),
		Sidebar = Color3.fromRGB(14, 11, 20),
		Card = Color3.fromRGB(22, 16, 32),
		CardOn = Color3.fromRGB(34, 22, 52),
		CardHover = Color3.fromRGB(36, 24, 52),
		TabOn = Color3.fromRGB(42, 26, 64),
		TabOff = Color3.fromRGB(16, 12, 22),
		Stroke = Color3.fromRGB(52, 32, 78),
		StrokeOn = Color3.fromRGB(176, 132, 255),
		Text = Color3.fromRGB(240, 234, 250),
		TextMuted = Color3.fromRGB(150, 136, 170),
		Track = Color3.fromRGB(30, 22, 42),
		BoxOff = Color3.fromRGB(30, 22, 40),
		WindowStroke = Color3.fromRGB(56, 36, 82),
		HeaderLine = Color3.fromRGB(90, 50, 140)
	},
	Amber = {
		Accent = Color3.fromRGB(255, 178, 62),
		AccentDim = Color3.fromRGB(220, 140, 40),
		Bg = Color3.fromRGB(18, 14, 10),
		Header = Color3.fromRGB(20, 16, 12),
		Sidebar = Color3.fromRGB(16, 12, 10),
		Card = Color3.fromRGB(24, 18, 12),
		CardOn = Color3.fromRGB(40, 28, 14),
		CardHover = Color3.fromRGB(40, 28, 16),
		TabOn = Color3.fromRGB(48, 32, 14),
		TabOff = Color3.fromRGB(18, 14, 10),
		Stroke = Color3.fromRGB(62, 42, 18),
		StrokeOn = Color3.fromRGB(255, 178, 62),
		Text = Color3.fromRGB(248, 238, 226),
		TextMuted = Color3.fromRGB(160, 142, 118),
		Track = Color3.fromRGB(36, 26, 14),
		BoxOff = Color3.fromRGB(34, 26, 16),
		WindowStroke = Color3.fromRGB(70, 46, 18),
		HeaderLine = Color3.fromRGB(120, 78, 24)
	},
	Graphite = {
		Accent = Color3.fromRGB(220, 220, 228),
		AccentDim = Color3.fromRGB(180, 180, 190),
		Bg = Color3.fromRGB(18, 18, 20),
		Header = Color3.fromRGB(22, 22, 24),
		Sidebar = Color3.fromRGB(16, 16, 18),
		Card = Color3.fromRGB(24, 24, 26),
		CardOn = Color3.fromRGB(36, 36, 40),
		CardHover = Color3.fromRGB(38, 38, 42),
		TabOn = Color3.fromRGB(42, 42, 46),
		TabOff = Color3.fromRGB(18, 18, 20),
		Stroke = Color3.fromRGB(52, 52, 58),
		StrokeOn = Color3.fromRGB(220, 220, 228),
		Text = Color3.fromRGB(244, 244, 248),
		TextMuted = Color3.fromRGB(148, 148, 158),
		Track = Color3.fromRGB(32, 32, 36),
		BoxOff = Color3.fromRGB(34, 34, 38),
		WindowStroke = Color3.fromRGB(58, 58, 64),
		HeaderLine = Color3.fromRGB(70, 70, 78)
	}
}
t1.value14 = tick()
t1.value15 = {
	Active = false,
	Fired = false,
	PrevAngle = 0,
	TotalRotated = 0,
	LastGoalAngle = -1
}

function t1.value16()
	local hui = gethui and gethui()

	if hui then
		return hui
	end

	local ok, parent = pcall(game.GetService, game, "CoreGui")

	if ok then
		ok = parent
	end

	if ok and pcall(function()
		local Folder = Instance.new("Folder")

		Folder.Parent = parent
		Folder:Destroy()
	end) then
		return parent
	else
		return t1.value11
	end
end

local function v11()
	local function v12()
		t1.value3:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	end

	pcall(v12)

	if keypress then
		pcall(function()
			keypress(32)
		end)
	end

	task.spawn(function()
		task.wait(0.02)

		local function v13()
			t1.value3:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		end

		pcall(v13)

		if not keyrelease then
			return
		end

		pcall(function()
			keyrelease(32)
		end)
	end)
end

function t1.value17()
	for _, v in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
		local v16 = t1.value11:FindFirstChild(v)
		local isScreenGui = v16 and v16:IsA("ScreenGui")

		if isScreenGui then
			isScreenGui = v16.Enabled
		end

		if isScreenGui then
			local Check = v16:FindFirstChild("Check")
			local isFrame

			if Check then
				isFrame = Check:IsA("Frame")

				if isFrame then
					isFrame = Check.Visible
				end
			else
				isFrame = Check
			end

			if isFrame then
				local Line = Check:FindFirstChild("Line")
				local Goal = Check:FindFirstChild("Goal")

				if Line and Goal then
					local v22

					if Line.Visible == false then
						v22 = false
					else
						v22 = Goal.Visible ~= false
					end

					if v22 then
						return Line, Goal
					end
				end
			end
		end
	end

	return nil, nil
end

RunService.RenderStepped:Connect(function()
	if not t1.value12.AutoGreatZone then
		t1.value15.Active = false
		t1.value15.Fired = false
		t1.value15.PrevAngle = 0
		t1.value15.TotalRotated = 0
		t1.value15.LastGoalAngle = -1

		return
	end

	local v23, v24 = t1.value17()

	if v23 and v24 then
		local prevAngle = v23.Rotation % 360
		local lastGoalAngle = v24.Rotation % 360
		local v27 = not t1.value15.Active

		if not v27 then
			if t1.value15.LastGoalAngle >= 0 then
				local v28 = lastGoalAngle - t1.value15.LastGoalAngle

				v27 = math.abs(v28) > 2
			else
				v27 = false
			end
		end

		local Fired = t1.value15.Fired

		if Fired then
			if prevAngle < 30 then
				Fired = t1.value15.PrevAngle > 90
			else
				Fired = false
			end
		end

		if v27 or Fired then
			t1.value15.Active = true
			t1.value15.Fired = false
			t1.value15.PrevAngle = prevAngle
			t1.value15.TotalRotated = 0
			t1.value15.LastGoalAngle = lastGoalAngle

			if v27 then
				v27 = not Fired
			end

			if v27 then
				return
			end
		end

		local v30 = (prevAngle - t1.value15.PrevAngle) % 360
		local v31

		if v30 > 180 then
			v30 = v30 - 360
			v31 = v30
		else
			v31 = v30
		end

		local v32 = math.clamp(v30, 0, 40)

		t1.value15.TotalRotated = t1.value15.TotalRotated + v32

		if t1.value15.Fired or t1.value15.TotalRotated < 35 then
			t1.value15.PrevAngle = prevAngle

			return
		end

		local value15 = t1.value15
		local v34 = (prevAngle - lastGoalAngle) % 360
		local v35 = (value15.PrevAngle - lastGoalAngle) % 360
		local GreatZoneOffset = t1.value12.GreatZoneOffset
		local HitWindow = t1.value12.HitWindow
		local v38 = GreatZoneOffset <= v34
		local v39 = GreatZoneOffset + HitWindow

		if v38 then
			v38 = v34 <= v39
		end

		local v40 = (v34 - v35) % 360

		if v40 > 180 then
			v40 = v40 - 360
		end

		local v41 = v35 < GreatZoneOffset

		if v41 then
			if GreatZoneOffset <= v34 and v40 > 0 then
				v41 = v40 < 50
			else
				v41 = false
			end
		end

		if not (v38 or v41) then
			t1.value15.PrevAngle = prevAngle

			return
		end

		t1.value15.Fired = true
		v11()
		t1.value15.PrevAngle = prevAngle
	else
		if not t1.value15.Active then
			return
		end

		t1.value15.Active = false
		t1.value15.Fired = false
		t1.value15.PrevAngle = 0
		t1.value15.TotalRotated = 0
		t1.value15.LastGoalAngle = -1
	end
end)
t1.value18 = {}

function t1.value19(p1, p2)
	local v42 = not p1

	if v42 then
		return false
	else
		local Team

		if p2 then
			Team = p2.Team
		else
			Team = p2
		end

		if Team then
			v42 = p2.Team.Name

			local v44 = v42:lower()

			if v44:find("killer") or (v44:find("slasher") or v44:find("hunter")) then
				return true
			elseif v44:find("survivor") or v44:find("spectat") then
				return false
			elseif p1:GetAttribute("BloodLust") ~= nil or (p1:GetAttribute("SuspenseRadius") ~= nil and true or p1:GetAttribute("Chasemusic") ~= nil) then
				return true
			elseif p1:FindFirstChild("Weapon") or (p1:FindFirstChild("Instinct") or (p1:FindFirstChild("Lookscriptkiller") or p1:FindFirstChild("Killerost"))) then
				return true
			elseif p1:GetAttribute("HookedProgress") ~= nil and true or p1:GetAttribute("Knocked") ~= nil then
				return false
			else
				return (p1:GetAttribute("Role") == "Killer" or p1:GetAttribute("IsKiller") == true) and true or (p2 and (p2:GetAttribute("Role") == "Killer" or (p2:GetAttribute("IsKiller") == true or (p2.GetAttribute(p2, "SelectedKiller") ~= nil or p2:GetAttribute("killeraura") ~= nil))) and true or false)
			end
		elseif p1:GetAttribute("BloodLust") ~= nil or (p1:GetAttribute("SuspenseRadius") ~= nil and true or p1:GetAttribute("Chasemusic") ~= nil) then
			return true
		elseif p1:FindFirstChild("Weapon") or (p1:FindFirstChild("Instinct") or (p1:FindFirstChild("Lookscriptkiller") or p1:FindFirstChild("Killerost"))) then
			return true
		elseif p1:GetAttribute("HookedProgress") ~= nil and true or p1:GetAttribute("Knocked") ~= nil then
			return false
		else
			return (p1:GetAttribute("Role") == "Killer" or p1:GetAttribute("IsKiller") == true) and true or (p2 and (p2:GetAttribute("Role") == "Killer" or (p2:GetAttribute("IsKiller") == true or (p2.GetAttribute(p2, "SelectedKiller") ~= nil or p2:GetAttribute("killeraura") ~= nil))) and true or false)
		end
	end
end
function t1.value20(p3)
	if not t1.value18[p3] then
		return
	end

	local v45 = t1.value18[p3]
	local hl = v45.hl

	if hl then
		hl = v45.hl.Parent
	end

	if hl then
		pcall(function()
			v45.hl:Destroy()
		end)
	end

	local bbg = v45.bbg

	if bbg then
		bbg = v45.bbg.Parent
	end

	if bbg then
		pcall(function()
			v45.bbg:Destroy()
		end)
	end

	local nameGui = v45.nameGui

	if nameGui then
		nameGui = v45.nameGui.Parent
	end

	if nameGui then
		pcall(function()
			v45.nameGui:Destroy()
		end)
	end

	t1.value18[p3] = nil
end

local function v49()
	for k, _ in pairs(t1.value18) do
		t1.value20(k)
	end

	table.clear(t1.value18)
end

function t1.value21(p4, p5)
	local ipairs_ = ipairs
	local v53, v54, v55 = ipairs_({
		"SelectedKiller",
		"KillerName",
		"KillerType",
		"EquippedKiller",
		"CharacterName"
	})

	local function v56(p6, p7)
		if not p6 then
			return nil
		end

		local attribute = p6:GetAttribute(p7)
		local v58

		if typeof(attribute) == "string" then
			v58 = attribute ~= ""
		else
			v58 = false
		end

		if v58 then
			return attribute
		end

		local pairs_ = pairs
		local v60, v61, v62 = pairs_(p6:GetAttributes())

		while true do
			local v63

			v62, v63 = v60(v61, v62)

			if not v62 then
				break
			end

			local lower = v62.lower
			local lower2 = p7.lower
			local v66 = lower(v62) == lower2(p7)

			if v66 then
				if typeof(v63) == "string" then
					v66 = v63 ~= ""
				else
					v66 = false
				end
			end

			if v66 then
				return v63
			end
		end

		local v67 = p6:FindFirstChild(p7, true)
		local isStringValue = v67 and v67:IsA("StringValue")

		if isStringValue then
		elseif isStringValue then
			return v67.Value
		else
			return nil
		end

		isStringValue = v67.Value ~= ""

		if isStringValue then
			return v67.Value
		else
			return nil
		end
	end

	while true do
		local v69

		v55, v69 = v53(v54, v55)

		if not v55 then
			break
		end

		local v70 = v56(p5, v69) or v56(p4, v69)
		local v71

		if typeof(v70) == "string" then
			v71 = v70 ~= ""
		else
			v71 = false
		end

		if v71 then
			return v70
		end
	end

	local v72 = not p5

	if v72 then
	elseif v72 then
		return p4.Name
	else
		return nil
	end

	if p4 then
		local Name = p4.Name

		if typeof(Name) == "string" then
			v72 = p4.Name ~= ""
		else
			v72 = false
		end
	else
		v72 = p4
	end

	if v72 then
		return p4.Name
	else
		return nil
	end
end

t1.value22 = nil

function t1.value22(p8, p9, p10)
	if t1.value12.StreamerMode then
		return
	end

	if not t1.value12.ESPEnabled then
		return
	end

	if not (p8 and p8.Parent) then
		return
	end

	if p8 == t1.value10.Character then
		return
	end

	local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart") or p8:FindFirstChild("Torso")

	if not HumanoidRootPart then
		return
	end

	t1.value20(p8)

	local v75 = t1.value19(p8, p9)
	local color3

	if v75 then
		color3 = Color3.fromRGB(255, 45, 45)
	else
		color3 = v75
	end

	local color32 = color3 or Color3.fromRGB(45, 255, 45)
	local v78

	if v75 then
		v78 = t1.value21(p8, p9)
	else
		v78 = v75
	end

	local v79 = v78 or nil
	local v80 = v75 and "  " or v75 or "  "
	local Highlight = Instance.new("Highlight")

	Highlight.Name = "SBB_Highlight"
	Highlight.Adornee = p8
	Highlight.FillColor = color32
	Highlight.OutlineColor = color32
	Highlight.FillTransparency = 0.75
	Highlight.OutlineTransparency = 0.1
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = p8

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "SBB_ESP_Box"
	BillboardGui.Adornee = HumanoidRootPart
	BillboardGui.Size = UDim2.new(4.4, 0, 5.8, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	BillboardGui.LightInfluence = 0
	BillboardGui.Parent = HumanoidRootPart

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.BackgroundTransparency = 0.92
	Frame.BackgroundColor3 = color32
	Frame.BorderSizePixel = 0
	Frame.Parent = BillboardGui

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = color32
	UIStroke.Thickness = 1.8
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 3)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 24)
	TextLabel.Position = UDim2.new(0, 0, 0, -28)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 11
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = false
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel.TextTransparency = 0
	TextLabel.ZIndex = 10
	TextLabel.TextColor3 = color32
	TextLabel.TextStrokeTransparency = 0.3
	TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.Text = v80 .. p10

	if not v79 then
		TextLabel.Parent = BillboardGui
		v94 = Instance.new("BillboardGui")
		v94.Name = "SBB_ESP_Name"
		v94.Adornee = HumanoidRootPart
		v94.Size = UDim2.fromOffset(320, 32)
		v94.StudsOffset = Vector3.new(0, 4.2, 0)
		v94.AlwaysOnTop = true
		v94.MaxDistance = math.huge
		v94.LightInfluence = 0
		v94.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		v94.Parent = t1.value11
		v95 = Instance.new("TextLabel")
		v95.Name = "KillerNameLabel"
		v95.Size = UDim2.fromScale(1, 1)
		v95.BackgroundTransparency = 1
		v95.Font = Enum.Font.GothamBold
		v95.TextSize = 14
		v95.TextScaled = false
		v95.TextWrapped = false
		v95.TextXAlignment = Enum.TextXAlignment.Center
		v95.TextYAlignment = Enum.TextYAlignment.Center
		v95.TextColor3 = color32
		v95.TextStrokeTransparency = 0.15
		v95.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		v95.Text = TextLabel.Text
		v95.Parent = v94
		TextLabel.Visible = false
		t1.value18[p8] = {
			hl = Highlight,
			bbg = BillboardGui,
			nameGui = v94,
			tag = v95,
			root = HumanoidRootPart,
			prefix = v80,
			name = p10,
			killerType = v79,
			isKiller = v75
		}

		return
	end

	TextLabel.Text = "[KILLER: " .. v79 .. "] " .. p10
	TextLabel.Parent = BillboardGui

	local BillboardGui2 = Instance.new("BillboardGui")

	BillboardGui2.Name = "SBB_ESP_Name"
	BillboardGui2.Adornee = HumanoidRootPart
	BillboardGui2.Size = UDim2.fromOffset(320, 32)
	BillboardGui2.StudsOffset = Vector3.new(0, 4.2, 0)
	BillboardGui2.AlwaysOnTop = true
	BillboardGui2.MaxDistance = math.huge
	BillboardGui2.LightInfluence = 0
	BillboardGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	BillboardGui2.Parent = t1.value11

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "KillerNameLabel"
	TextLabel2.Size = UDim2.fromScale(1, 1)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 14
	TextLabel2.TextScaled = false
	TextLabel2.TextWrapped = false
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel2.TextColor3 = color32
	TextLabel2.TextStrokeTransparency = 0.15
	TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel2.Text = TextLabel.Text
	TextLabel2.Parent = BillboardGui2
	TextLabel.Visible = false
	t1.value18[p8] = {
		hl = Highlight,
		bbg = BillboardGui,
		nameGui = BillboardGui2,
		tag = TextLabel2,
		root = HumanoidRootPart,
		prefix = v80,
		name = p10,
		killerType = v79,
		isKiller = v75
	}
end
function t1.value23()
	if t1.value12.StreamerMode then
		v49()
	elseif t1.value12.ESPEnabled then
		local ipairs_ = ipairs
		local value1 = t1.value1
		local v90, v91, v92 = ipairs_(value1.GetPlayers(value1))

		while true do
			local v93

			v92, v93 = v90(v91, v92)

			if not v92 then
				break
			end

			local v96

			if v93 == t1.value10 then
				v96 = false
			else
				v96 = v93.Character
			end

			if v96 then
				t1.value22(v93.Character, v93, v93.DisplayName or v93.Name)
			end
		end

		local ipairs_2 = ipairs
		local workspace_ = workspace

		for _, child in ipairs_2(workspace_.GetChildren(workspace_)) do
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child:FindFirstChild("Humanoid")

				if isModel then
					isModel = child ~= t1.value10.Character
				end
			end

			if isModel and not t1.value18[child] then
				ipairs_2 = t1.value1

				local playerFromCharacter = ipairs_2:GetPlayerFromCharacter(child)

				if playerFromCharacter ~= t1.value10 then
					ipairs_2 = t1.value22

					local DisplayName

					if playerFromCharacter then
						DisplayName = playerFromCharacter.DisplayName or playerFromCharacter.Name
					else
						DisplayName = playerFromCharacter
					end

					ipairs_2(child, playerFromCharacter, DisplayName or child.Name)
				end
			end
		end

		return
	else
		v49()

		return
	end
end

RunService.RenderStepped:Connect(function()
	if not t1.value12.ESPEnabled then
		return
	end

	local Character = t1.value10.Character
	local Parent, playerFromCharacter, Team, attribute, v107, Magnitude, v109, v110

	if not Character then
		v120 = pairs

		for k, v in v120(t1.value18) do
			if k then
				Parent = k.Parent

				if Parent then
					Parent = v.root

					if Parent then
						Parent = v.root.Parent

						if Parent then
							Parent = v.tag
						end
					end
				end
			else
				Parent = k
			end

			if Parent then
				v120 = t1.value1
				playerFromCharacter = v120:GetPlayerFromCharacter(k)

				if playerFromCharacter then
					Team = playerFromCharacter.Team

					if Team then
						Team = playerFromCharacter.Team.Name == "Killer"
					end
				else
					Team = playerFromCharacter
				end

				if Team then
					v.isKiller = true
					attribute = playerFromCharacter:GetAttribute("SelectedKiller")

					if typeof(attribute) == "string" then
						v107 = attribute ~= ""
					else
						v107 = false
					end

					if v107 then
						v.killerType = attribute
						v120 = "killerType"
					else
						v.killerType = t1.value21(k, playerFromCharacter)
						v120 = "killerType"
					end
				end

				if Character then
					Magnitude = (v.root.Position - Character.Position).Magnitude
					v109 = math.floor(Magnitude)
					v110 = v.prefix .. v.name

					if v.killerType then
						v110 = "[KILLER: " .. v.killerType .. "] " .. v.name
						v120 = v110
					else
						v120 = v110
					end

					v.tag.Text = v110 .. " [" .. v109 .. "m]"
				end
			else
				t1.value20(k)
			end
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	local pairs_ = pairs

	for k, v in pairs_(t1.value18) do
		if k then
			Parent = k.Parent

			if Parent then
				Parent = v.root

				if Parent then
					Parent = v.root.Parent

					if Parent then
						Parent = v.tag
					end
				end
			end
		else
			Parent = k
		end

		if Parent then
			pairs_ = t1.value1
			playerFromCharacter = pairs_:GetPlayerFromCharacter(k)

			if playerFromCharacter then
				Team = playerFromCharacter.Team

				if Team then
					Team = playerFromCharacter.Team.Name == "Killer"
				end
			else
				Team = playerFromCharacter
			end

			if Team then
				v.isKiller = true
				attribute = playerFromCharacter:GetAttribute("SelectedKiller")

				if typeof(attribute) == "string" then
					v107 = attribute ~= ""
				else
					v107 = false
				end

				if v107 then
					v.killerType = attribute
					pairs_ = "killerType"
				else
					v.killerType = t1.value21(k, playerFromCharacter)
					pairs_ = "killerType"
				end
			end

			if Character then
				Magnitude = (v.root.Position - Character.Position).Magnitude
				v109 = math.floor(Magnitude)
				v110 = v.prefix .. v.name

				if v.killerType then
					v110 = "[KILLER: " .. v.killerType .. "] " .. v.name
					pairs_ = v110
				else
					pairs_ = v110
				end

				v.tag.Text = v110 .. " [" .. v109 .. "m]"
			end
		else
			t1.value20(k)
		end
	end
end)
task.spawn(function()
	while true do
		repeat
			task.wait(1.5)
		until t1.value12.ESPEnabled

		t1.value23()
	end
end)
t1.value24 = {}

function t1.value25(p11)
	if not (p11 and p11.Parent) then
		return false
	end

	if p11:GetAttribute("Completed") == true then
		return false
	end

	local attribute = p11:GetAttribute("RepairProgress")

	if not attribute then
		return not attribute
	end

	if type(attribute) == "number" then
		attribute = attribute >= 99.9
	else
		attribute = false
	end

	return not attribute
end
function t1.value26(p12)
	if p12 then
		local attribute = p12:GetAttribute("RepairProgress")
		local v118

		if attribute then
			v118 = type(attribute) == "number"
		else
			v118 = attribute
		end

		return not v118 and 0 or math.clamp(math.floor(attribute), 0, 100)
	else
		return 0
	end
end

t1.value27 = {
	List = {},
	LastRefresh = 0,
	RefreshInterval = 1
}

function t1.value28()
	local now = os.clock()

	if now - t1.value27.LastRefresh < t1.value27.RefreshInterval then
		return t1.value27.List
	end

	local list = {}
	local Map = workspace:FindFirstChild("Map")

	if Map then
		local Generators = Map:FindFirstChild("Generators")

		if Generators then
			local GetChildren = Generators.GetChildren

			for _, v in ipairs(GetChildren(Generators)) do
				if v:IsA("Model") then
					table.insert(list, v)
				end
			end
		end
	end

	if #list ~= 0 then
		t1.value27.List = list
		t1.value27.LastRefresh = now

		return list
	end

	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		local isModel = descendant:IsA("Model")

		if isModel then
			isModel = descendant.Name == "Generator" and true or descendant.Name:match("^Gen")
		end

		if isModel then
			ipairs_ = table.insert
			ipairs_(list, descendant)
		end
	end

	t1.value27.List = list
	t1.value27.LastRefresh = now

	return list
end
function t1.value29(p13)
	if not t1.value24[p13] then
		return
	end

	local v131 = t1.value24[p13]
	local hl = v131.hl

	if hl then
		hl = v131.hl.Parent
	end

	if hl then
		pcall(function()
			v131.hl:Destroy()
		end)
	end

	local bbg = v131.bbg

	if bbg then
		bbg = v131.bbg.Parent
	end

	if bbg then
		pcall(function()
			v131.bbg:Destroy()
		end)
	end

	t1.value24[p13] = nil
end
function t1.value30()
	for k, _ in pairs(t1.value24) do
		t1.value29(k)
	end

	table.clear(t1.value24)
end
function t1.value31(p14)
	if t1.value12.StreamerMode then
	elseif t1.value12.GenESPEnabled then
		if p14 and p14.Parent then
			if t1.value25(p14) then
				if t1.value24[p14] then
					return
				else
					local RootPart = p14:FindFirstChild("RootPart") or (p14:FindFirstChild("Gen Invis") or (p14.PrimaryPart or p14:FindFirstChildWhichIsA("BasePart")))

					if RootPart then
						local color3 = Color3.fromRGB(255, 185, 45)
						local Highlight = Instance.new("Highlight")

						Highlight.Name = "SBB_GenHighlight"
						Highlight.Adornee = p14
						Highlight.FillColor = color3
						Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						Highlight.FillTransparency = 0.65
						Highlight.OutlineTransparency = 0.1
						Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						Highlight.Parent = p14

						local BillboardGui = Instance.new("BillboardGui")

						BillboardGui.Name = "SBB_Gen_ESP"
						BillboardGui.Adornee = RootPart
						BillboardGui.Size = UDim2.new(0, 160, 0, 32)
						BillboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
						BillboardGui.AlwaysOnTop = true
						BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						BillboardGui.LightInfluence = 0
						BillboardGui.Parent = RootPart

						local TextLabel = Instance.new("TextLabel")

						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.BackgroundTransparency = 1
						TextLabel.Font = Enum.Font.GothamBold
						TextLabel.TextSize = 11
						TextLabel.TextColor3 = color3
						TextLabel.TextStrokeTransparency = 0.2
						TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						TextLabel.Text = "⚙️ [GEN " .. t1.value26(p14) .. "%]"
						TextLabel.Parent = BillboardGui
						t1.value24[p14] = {
							hl = Highlight,
							bbg = BillboardGui,
							tag = TextLabel,
							root = RootPart,
							gen = p14
						}

						return
					else
						return
					end
				end
			else
				t1.value29(p14)

				return
			end
		else
			return
		end
	else
		return
	end
end
function t1.value32()
	if t1.value12.StreamerMode then
		t1.value30()
	elseif t1.value12.GenESPEnabled then
		local v141 = t1.value28()

		for _, v in ipairs(v141) do
			if t1.value25(v) then
				t1.value31(v)
			else
				t1.value29(v)
			end
		end

		return
	else
		t1.value30()

		return
	end
end

RunService.RenderStepped:Connect(function()
	if not t1.value12.GenESPEnabled then
		return
	end

	local Character = t1.value10.Character
	local Parent, v146, Magnitude, v148

	if not Character then
		v158 = pairs

		for k, v in v158(t1.value24) do
			if k then
				Parent = k.Parent

				if Parent then
					Parent = v.root

					if Parent then
						Parent = v.root.Parent

						if Parent then
							Parent = v.tag
						end
					end
				end
			else
				Parent = k
			end

			if Parent then
				if t1.value25(k) then
					v146 = t1.value26(k)

					if Character then
						Magnitude = (v.root.Position - Character.Position).Magnitude
						v148 = " [" .. math.floor(Magnitude) .. "m]"
						v158 = v148
					else
						v148 = ""
						v158 = ""
					end

					v.tag.Text = "⚙️ [GEN " .. v146 .. "%]" .. v148
				else
					v158 = t1.value29
					v158(k)
				end
			else
				t1.value29(k)
			end
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	local pairs_ = pairs

	for k, v in pairs_(t1.value24) do
		if k then
			Parent = k.Parent

			if Parent then
				Parent = v.root

				if Parent then
					Parent = v.root.Parent

					if Parent then
						Parent = v.tag
					end
				end
			end
		else
			Parent = k
		end

		if Parent then
			if t1.value25(k) then
				v146 = t1.value26(k)

				if Character then
					Magnitude = (v.root.Position - Character.Position).Magnitude
					v148 = " [" .. math.floor(Magnitude) .. "m]"
					pairs_ = v148
				else
					v148 = ""
					pairs_ = ""
				end

				v.tag.Text = "⚙️ [GEN " .. v146 .. "%]" .. v148
			else
				pairs_ = t1.value29
				pairs_(k)
			end
		else
			t1.value29(k)
		end
	end
end)
task.spawn(function()
	while true do
		repeat
			task.wait(1.5)
		until t1.value12.GenESPEnabled

		t1.value32()
	end
end)

function t1.value33()
	local v154, v155, v156 = ipairs({ "pcprompts", "consoleprompts" })

	while true do
		local v157

		v156, v157 = v154(v155, v156)

		if not v156 then
			break
		end

		local v159 = t1.value11:FindFirstChild(v157)
		local isScreenGui

		if v159 then
			isScreenGui = v159:IsA("ScreenGui")

			if isScreenGui then
				isScreenGui = v159.Enabled
			end
		else
			isScreenGui = v159
		end

		if isScreenGui then
			local Frame = v159:FindFirstChild("Frame")
			local Visible

			if Frame then
				Visible = Frame.Visible
			else
				Visible = Frame
			end

			if Visible then
				local FreeYourself = Frame:FindFirstChild("FreeYourself")

				if FreeYourself then
					FreeYourself = FreeYourself.Visible
				end

				if FreeYourself then
					return true
				end
			end
		end
	end

	local Character = t1.value10.Character

	if not Character then
		return false
	end

	if Character:GetAttribute("BeingCarried") == true or (Character:GetAttribute("Carried") == true and true or Character:GetAttribute("isCarried") == true) then
		return true
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return false
	end

	local ipairs_ = ipairs

	for _, child in ipairs_(HumanoidRootPart.GetChildren(HumanoidRootPart)) do
		local isWeld = child:IsA("Weld") or (child:IsA("Motor6D") or child:IsA("WeldConstraint"))

		if isWeld then
			isWeld = child.Part0

			if isWeld then
				isWeld = child.Part1
			end
		end

		if isWeld then
			local Part1

			if child.Part0 == HumanoidRootPart then
				Part1 = child.Part1
			else
				Part1 = false
			end

			local Part0 = Part1 or child.Part0
			local Parent

			if Part0 then
				Parent = Part0.Parent

				if Parent then
					if Part0.Parent == Character then
						Parent = false
					else
						Parent = Part0.Parent:FindFirstChild("Humanoid")
					end
				end
			else
				Parent = Part0
			end

			if Parent then
				return true
			end
		end
	end

	return false
end

task.spawn(function()
	local v172 = false

	while true do
		task.wait(0.05)

		local AutoWiggle = t1.value12.AutoWiggle

		if AutoWiggle then
			AutoWiggle = t1.value33()
		end

		if AutoWiggle then
			v172 = not v172

			if v172 then
				pcall(function()
					t1.value3:SendKeyEvent(true, Enum.KeyCode.A, false, game)
					task.wait(0.01)
					t1.value3:SendKeyEvent(false, Enum.KeyCode.A, false, game)
				end)

				local keypress_ = keypress

				if keypress_ then
					keypress_ = keyrelease
				end

				if keypress_ then
					pcall(function()
						keypress(65)
						task.wait(0.01)
						keyrelease(65)
					end)
				end
			else
				local function v175()
					t1.value3:SendKeyEvent(true, Enum.KeyCode.D, false, game)
					task.wait(0.01)
					t1.value3:SendKeyEvent(false, Enum.KeyCode.D, false, game)
				end

				pcall(v175)

				local keypress_ = keypress

				if keypress_ then
					keypress_ = keyrelease
				end

				if keypress_ then
					pcall(function()
						keypress(68)
						task.wait(0.01)
						keyrelease(68)
					end)
				end
			end

			local function v177()
				t1.value3:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				task.wait(0.01)
				t1.value3:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
			end

			pcall(v177)

			local keypress_ = keypress

			if keypress_ then
				keypress_ = keyrelease
			end

			if keypress_ then
				pcall(function()
					keypress(32)
					task.wait(0.01)
					keyrelease(32)
				end)
			end
		end
	end
end)
RunService.Heartbeat:Connect(function(dt)
	if not t1.value12.SpeedEnabled then
		return
	end

	local Character = t1.value10.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
	local v182

	if Humanoid then
		if HumanoidRootPart then
			if Humanoid.Health > 0 then
				v182 = Humanoid.MoveDirection.Magnitude > 0
			else
				v182 = false
			end
		else
			v182 = HumanoidRootPart
		end
	else
		v182 = Humanoid
	end

	if not v182 then
		return
	end

	local SpeedValue = t1.value12.SpeedValue or 24
	local v184 = math.max(0, SpeedValue - 16)

	if not (v184 > 0) then
		return
	end

	local v185 = Humanoid.MoveDirection * (v184 * dt)

	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + v185
end)
t1.value34 = nil
t1.value34 = {}

function t1.value35()
	for k, v in pairs(t1.value34) do
		local Parent

		if k then
			Parent = k.Parent
		else
			Parent = k
		end

		if Parent then
			k.CanCollide = v
		end
	end

	table.clear(t1.value34)
end

RunService.Stepped:Connect(function()
	local Character = t1.value10.Character

	if t1.value12.NoclipEnabled then
		if Character then
			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if t1.value34[descendant] == nil then
						t1.value34[descendant] = descendant.CanCollide
					end

					descendant.CanCollide = false
				end
			end

			return
		else
			return
		end
	else
		t1.value35()
	end
end)
t1.value10.CharacterAdded:Connect(function()
	t1.value35()
end)

function t1.value36()
	local pairs_ = pairs
	local v193, v194, v195 = pairs_(t1.value18)

	while true do
		local v196

		v195, v196 = v193(v194, v195)

		if not v195 then
			break
		end

		local Humanoid

		if v195 then
			Humanoid = v195:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = v195
		end

		local isKiller = v196.isKiller

		if isKiller then
			isKiller = v196.root

			if isKiller then
				isKiller = v196.root.Parent

				if isKiller then
					isKiller = not Humanoid or Humanoid.Health > 0
				end
			end
		end

		if isKiller then
			return v196.root, v195
		end
	end

	local v199, v200, v201 = ipairs(t1.value1:GetPlayers())

	while true do
		local v202

		v201, v202 = v199(v200, v201)

		if not v201 then
			break
		end

		local v203

		if v202 == t1.value10 then
			v203 = false
		else
			v203 = v202.Character
		end

		if v203 then
			local Humanoid = v202.Character:FindFirstChildOfClass("Humanoid")
			local v205 = t1.value19(v202.Character, v202)

			if v205 then
				v205 = not Humanoid or Humanoid.Health > 0
			end

			if v205 then
				local HumanoidRootPart = v202.Character:FindFirstChild("HumanoidRootPart") or v202.Character:FindFirstChild("Torso")
				local v207

				if HumanoidRootPart then
					v207 = not Humanoid or Humanoid.Health > 0
				else
					v207 = HumanoidRootPart
				end

				if v207 then
					return HumanoidRootPart, v202.Character
				end
			end
		end
	end

	local Teams = game:FindFirstChild("Teams")

	if Teams then
		Teams = Teams.FindFirstChild(Teams, "Killer") or Teams:FindFirstChild("Killers")
	end

	local isTeam

	if Teams then
		isTeam = Teams:IsA("Team")
	else
		isTeam = Teams
	end

	local isModel, value19, value1, v213, HumanoidRootPart

	if not isTeam then
		v228 = ipairs
		v229 = workspace

		for _, child in v228(v229.GetChildren(v229)) do
			isModel = child:IsA("Model")

			if isModel then
				if child == t1.value10.Character then
					isModel = false
				else
					isModel = child:FindFirstChildOfClass("Humanoid")
				end
			end

			if isModel then
				v228 = child:FindFirstChildOfClass("Humanoid")
				value19 = t1.value19
				value1 = t1.value1
				v213 = value19(child, value1.GetPlayerFromCharacter(value1, child))

				if v213 then
					v213 = not v228 or v228.Health > 0
				end

				if v213 then
					HumanoidRootPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso")

					if HumanoidRootPart then
						return HumanoidRootPart, child
					end
				end
			end
		end

		return nil, nil
	end

	for _, player in ipairs(Teams.GetPlayers(Teams)) do
		local v219

		if player == t1.value10 then
			v219 = false
		else
			v219 = player.Character
		end

		if v219 then
			local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
			local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local v222

			if HumanoidRootPart2 then
				v222 = not Humanoid or Humanoid.Health > 0
			else
				v222 = HumanoidRootPart2
			end

			if v222 then
				return HumanoidRootPart2, player.Character
			end
		end
	end

	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, child in ipairs_(workspace_.GetChildren(workspace_)) do
		isModel = child:IsA("Model")

		if isModel then
			if child == t1.value10.Character then
				isModel = false
			else
				isModel = child:FindFirstChildOfClass("Humanoid")
			end
		end

		if isModel then
			ipairs_ = child:FindFirstChildOfClass("Humanoid")
			value19 = t1.value19
			value1 = t1.value1
			v213 = value19(child, value1.GetPlayerFromCharacter(value1, child))

			if v213 then
				v213 = not ipairs_ or ipairs_.Health > 0
			end

			if v213 then
				HumanoidRootPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso")

				if HumanoidRootPart then
					return HumanoidRootPart, child
				end
			end
		end
	end

	return nil, nil
end

t1.value37 = {
	IsHealing = false
}

function t1.value38()
	for _, v in ipairs({ "pcprompts", "consoleprompts" }) do
		local v230 = t1.value11:FindFirstChild(v)
		local isScreenGui

		if v230 then
			isScreenGui = v230:IsA("ScreenGui")

			if isScreenGui then
				isScreenGui = v230.Enabled
			end
		else
			isScreenGui = v230
		end

		if isScreenGui then
			local Frame = v230:FindFirstChild("Frame")
			local Visible

			if Frame then
				Visible = Frame.Visible
			else
				Visible = Frame
			end

			if Visible then
				local PlayerHeal = Frame:FindFirstChild("PlayerHeal")

				if PlayerHeal then
					PlayerHeal = PlayerHeal.Visible
				end

				if PlayerHeal then
					return true
				end
			end
		end
	end

	return false
end
function t1.value39()
	local Character = t1.value10.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

		if HumanoidRootPart then
			local ipairs_ = ipairs
			local value1 = t1.value1

			for _, player in ipairs_(value1.GetPlayers(value1)) do
				local Character2 = player ~= t1.value10 and player.Character

				if Character2 then
					Character2 = player.Character.Parent
				end

				if Character2 then
					local Character3 = player.Character

					if not t1.value19(Character3, player) then
						local Humanoid = Character3:FindFirstChild("Humanoid")
						local HumanoidRootPart2 = Character3:FindFirstChild("HumanoidRootPart") or Character3:FindFirstChild("Torso")
						local v244

						if Humanoid then
							if HumanoidRootPart2 then
								if Humanoid.Health > 0 then
									v244 = Humanoid.Health < Humanoid.MaxHealth
								else
									v244 = false
								end
							else
								v244 = HumanoidRootPart2
							end
						else
							v244 = Humanoid
						end

						if v244 and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 8.5 then
							return Character3, HumanoidRootPart2, Humanoid
						end

						local v245

						if HumanoidRootPart2 then
							v245 = Character3:GetAttribute("Knocked") == true

							if not v245 then
								v245 = Character3:GetAttribute("Downed") == true

								if not v245 then
									if Humanoid then
										v245 = Humanoid.Health <= 1
									else
										v245 = Humanoid
									end
								end
							end
						else
							v245 = HumanoidRootPart2
						end

						if v245 and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 8.5 then
							return Character3, HumanoidRootPart2, Humanoid
						end
					end
				end
			end

			return nil
		else
			return nil
		end
	else
		return nil
	end
end
function t1.value40(p15)
	if p15 then
		pcall(function()
			if not mouse1press then
				t1.value3:SendMouseButtonEvent(0, 0, 0, true, game, 0)
				t1.value3:SendKeyEvent(true, Enum.KeyCode.E, false, game)

				return
			end

			mouse1press()
			t1.value3:SendMouseButtonEvent(0, 0, 0, true, game, 0)
			t1.value3:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		end)
	else
		local function v246()
			if not mouse1release then
				t1.value3:SendMouseButtonEvent(0, 0, 0, false, game, 0)
				t1.value3:SendKeyEvent(false, Enum.KeyCode.E, false, game)

				return
			end

			mouse1release()
			t1.value3:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			t1.value3:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		end

		pcall(v246)
	end
end

task.spawn(function()
	while true do
		while true do
			task.wait(0.1)

			if not t1.value12.AutoHeal then
				break
			end

			if t1.value38() or t1.value39() then
				if not t1.value37.IsHealing then
					t1.value37.IsHealing = true
					t1.value40(true)
				end
			elseif t1.value37.IsHealing then
				t1.value37.IsHealing = false
				t1.value40(false)
			end
		end

		if t1.value37.IsHealing then
			t1.value37.IsHealing = false
			t1.value40(false)
		end
	end
end)

local function v247(character)
	if not character then
		return
	end

	local v248 = character.WaitForChild(character, "Humanoid", 3)

	if not (v248 and character:WaitForChild("HumanoidRootPart", 3)) then
		return
	end

	v248.StateChanged:Connect(function(_, new)
		if not t1.value12.NoFall then
			return
		end

		if not (new == Enum.HumanoidStateType.Landed and true or new == Enum.HumanoidStateType.Freefall) then
			return
		end

		task.defer(function()
			if t1.value12.NoFall then
				v248:ChangeState(Enum.HumanoidStateType.Running)
				v248.PlatformStand = false
			end
		end)
	end)
	v248.AnimationPlayed:Connect(function(p16)
		if not t1.value12.NoFall then
			return
		end

		local v249 = (p16.Name or ""):lower()
		local Animation = p16.Animation

		if Animation then
			Animation = (Animation.Name or ""):lower()
		end

		local v251 = Animation or ""

		if not (v249:find("fall") or (v249:find("land") or (v249:find("stagger") or (v249:find("stun") or (v251:find("fall") or (v251:find("land") or v251:find("stagger"))))))) then
			return
		end

		p16:Stop(0)
		v248:ChangeState(Enum.HumanoidStateType.Running)
	end)
end

if t1.value10.Character then
	task.spawn(v247, t1.value10.Character)
end

t1.value10.CharacterAdded:Connect(v247)
RunService.Heartbeat:Connect(function()
	if not t1.value12.NoFall then
		return
	end

	local Character = t1.value10.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not (Humanoid and HumanoidRootPart) then
		return
	end

	if not (HumanoidRootPart.AssemblyLinearVelocity.Y < -28) then
		return
	end

	local ray = Ray.new(HumanoidRootPart.Position, Vector3.new(0, -6, 0))

	if not workspace:FindPartOnRayWithIgnoreList(ray, { Character }) then
		return
	end

	HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, -2, HumanoidRootPart.AssemblyLinearVelocity.Z)
	Humanoid:ChangeState(Enum.HumanoidStateType.Running)

	for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
		local v258 = (v.Name or ""):lower()

		if v258:find("fall") or (v258:find("land") or v258:find("stagger")) then
			v:Stop(0)
		end
	end
end)
t1.value41 = {
	LastDropTick = 0
}

local function v259()
	for _, v in ipairs({ "pcprompts", "consoleprompts" }) do
		local v262 = t1.value11:FindFirstChild(v)
		local isScreenGui

		if v262 then
			isScreenGui = v262:IsA("ScreenGui")

			if isScreenGui then
				isScreenGui = v262.Enabled
			end
		else
			isScreenGui = v262
		end

		if isScreenGui then
			local Frame = v262:FindFirstChild("Frame")
			local Visible

			if Frame then
				Visible = Frame.Visible
			else
				Visible = Frame
			end

			if Visible then
				local PalletDropPromptGui = Frame:FindFirstChild("PalletDropPromptGui")

				if PalletDropPromptGui then
					PalletDropPromptGui = PalletDropPromptGui.Visible
				end

				if PalletDropPromptGui then
					return true
				end
			end
		end
	end

	return false
end

function t1.value42(p17)
	local Character = t1.value10.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

		if HumanoidRootPart then
			local v269 = nil
			local Map = workspace:FindFirstChild("Map") or workspace
			local GetDescendants = Map.GetDescendants
			local v272 = v269
			local v273 = p17 or 8.5

			for _, v in ipairs(GetDescendants(Map)) do
				local isModel = v:IsA("Model")

				if isModel then
					isModel = v.Name:lower():find("pallet")
				end

				if isModel then
					local PalletPoint = v:FindFirstChild("PalletPoint") or (v:FindFirstChild("PrimaryPartPallet") or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")))

					if PalletPoint then
						local Magnitude = (PalletPoint.Position - HumanoidRootPart.Position).Magnitude

						if Magnitude < v273 then
							v272 = v
							v273 = Magnitude
						end
					end
				end
			end

			return v272, v273
		else
			return nil
		end
	else
		return nil
	end
end
function t1.value43(p18)
	local function v279()
		t1.value3:SendKeyEvent(true, Enum.KeyCode.Space, false, game)

		if keypress then
			keypress(32)
		end

		local function v280()
			t1.value3:SendKeyEvent(false, Enum.KeyCode.Space, false, game)

			if not keyrelease then
				return
			end

			keyrelease(32)
		end

		task.delay(0.08, v280)
	end

	pcall(v279)

	local function v281()
		local Remotes = t1.value7:FindFirstChild("Remotes")

		if Remotes then
			Remotes = t1.value7.Remotes:FindFirstChild("Pallet")

			if Remotes then
				Remotes = t1.value7.Remotes.Pallet:FindFirstChild("PalletDropEvent")
			end
		end

		local v283

		if Remotes then
			v283 = p18
		else
			v283 = Remotes
		end

		if not v283 then
			return
		end

		Remotes:FireServer(p18)
	end

	pcall(v281)
end

RunService.Heartbeat:Connect(function()
	if not t1.value12.AutoPallet then
		return
	end

	local now = tick()

	if now - t1.value41.LastDropTick < 1.2 then
		return
	end

	local Character = t1.value10.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	if not HumanoidRootPart then
		return
	end

	local v287 = v259()
	local v288 = t1.value42(8.5)

	if not (v287 or v288) then
		return
	end

	local v289 = t1.value36()

	if not v289 then
		return
	end

	local PalletPoint

	if v288 then
		PalletPoint = v288:FindFirstChild("PalletPoint")

		if PalletPoint then
			PalletPoint = v288.PalletPoint.Position
		end
	else
		PalletPoint = v288
	end

	local Position = PalletPoint or HumanoidRootPart.Position

	if not ((v289.Position - Position).Magnitude <= (t1.value12.PalletStunDist or 12)) then
		return
	end

	t1.value41.LastDropTick = now
	t1.value43(v288)
end)

local function v293()
	for _, v in ipairs({ "pcprompts", "consoleprompts" }) do
		local v296 = t1.value11:FindFirstChild(v)
		local isScreenGui

		if v296 then
			isScreenGui = v296:IsA("ScreenGui")

			if isScreenGui then
				isScreenGui = v296.Enabled
			end
		else
			isScreenGui = v296
		end

		if isScreenGui then
			local Frame = v296:FindFirstChild("Frame")
			local Visible

			if Frame then
				Visible = Frame.Visible
			else
				Visible = Frame
			end

			if Visible then
				local VaultPromptGui = Frame:FindFirstChild("VaultPromptGui") or Frame:FindFirstChild("PalletSlidePromptGui")
				local Visible2

				if VaultPromptGui then
					Visible2 = VaultPromptGui.Visible
				else
					Visible2 = VaultPromptGui
				end

				if Visible2 then
					return true, VaultPromptGui.Name
				end
			end
		end
	end

	return false, nil
end

RunService.RenderStepped:Connect(function()
	if not t1.value12.FastVault then
		return
	end

	local Character = t1.value10.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
	local Humanoid = Character:FindFirstChild("Humanoid")

	if not (HumanoidRootPart and Humanoid) then
		return
	end

	if not v293() then
		return
	end

	local MoveDirection = Humanoid.MoveDirection

	if MoveDirection.Magnitude > 0.1 then
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * 28, HumanoidRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * 28)
	end

	local function v306()
		local Remotes = t1.value7:FindFirstChild("Remotes")

		if Remotes then
			Remotes = t1.value7.Remotes:FindFirstChild("Window")
		end

		if not Remotes then
			return
		end

		local fastvault = Remotes:FindFirstChild("fastvault")

		if fastvault then
			fastvault:FireServer()
		end

		local SurvivorFastVault = Remotes:FindFirstChild("SurvivorFastVault")
		local isRemoteEvent

		if SurvivorFastVault then
			isRemoteEvent = SurvivorFastVault:IsA("RemoteEvent")
		else
			isRemoteEvent = SurvivorFastVault
		end

		if not isRemoteEvent then
			return
		end

		SurvivorFastVault:FireServer()
	end

	pcall(v306)
end)

local value44 = {
	Saved = false,
	Brightness = 1,
	ClockTime = 14,
	Ambient = Color3.fromRGB(0, 0, 0),
	OutdoorAmbient = Color3.fromRGB(128, 128, 128),
	GlobalShadows = true,
	ExposureCompensation = 0,
	FogEnd = 1000,
	FogStart = 0,
	AtmosphereDensity = 0.3,
	AtmosphereHaze = 0,
	AtmosphereGlare = 0,
	DarknessGuis = {}
}

t1.value44 = nil
t1.value44 = value44

function t1.value45()
	if t1.value44.Saved then
		return
	end

	local function v312()
		t1.value44.Brightness = t1.value6.Brightness
		t1.value44.ClockTime = t1.value6.ClockTime
		t1.value44.Ambient = t1.value6.Ambient
		t1.value44.OutdoorAmbient = t1.value6.OutdoorAmbient
		t1.value44.GlobalShadows = t1.value6.GlobalShadows
		t1.value44.ExposureCompensation = t1.value6.ExposureCompensation
		t1.value44.FogEnd = t1.value6.FogEnd
		t1.value44.FogStart = t1.value6.FogStart

		local Atmosphere = t1.value6:FindFirstChildOfClass("Atmosphere")

		if not Atmosphere then
			t1.value44.Saved = true

			return
		end

		t1.value44.AtmosphereDensity = Atmosphere.Density
		t1.value44.AtmosphereHaze = Atmosphere.Haze
		t1.value44.AtmosphereGlare = Atmosphere.Glare
		t1.value44.Saved = true
	end

	pcall(v312)
end
function t1.value46()
	local function v314()
		t1.value45()
		t1.value6.Brightness = 2
		t1.value6.ClockTime = 14
		t1.value6.Ambient = Color3.fromRGB(135, 135, 140)
		t1.value6.OutdoorAmbient = Color3.fromRGB(135, 135, 140)
		t1.value6.GlobalShadows = false
		t1.value6.ExposureCompensation = 0.2
		t1.value6.FogEnd = 100000
		t1.value6.FogStart = 0

		local Atmosphere = t1.value6:FindFirstChildOfClass("Atmosphere")

		if Atmosphere then
			Atmosphere.Density = 0
			Atmosphere.Haze = 0
			Atmosphere.Glare = 0
		end

		local Darkness = t1.value11:FindFirstChild("Darkness")
		local isScreenGui

		if Darkness then
			isScreenGui = Darkness:IsA("ScreenGui")
		else
			isScreenGui = Darkness
		end

		if not isScreenGui then
			return
		end

		local ImageLabel = Darkness:FindFirstChild("ImageLabel")
		local isImageLabel

		if ImageLabel then
			isImageLabel = ImageLabel:IsA("ImageLabel")

			if isImageLabel then
				isImageLabel = ImageLabel.Visible
			end
		else
			isImageLabel = ImageLabel
		end

		if not isImageLabel then
			return
		end

		ImageLabel.Visible = false
		t1.value44.DarknessGuis[ImageLabel] = true
	end

	pcall(v314)
end
function t1.value47()
	pcall(function()
		if not t1.value44.Saved then
			return
		end

		t1.value6.Brightness = t1.value44.Brightness
		t1.value6.ClockTime = t1.value44.ClockTime
		t1.value6.Ambient = t1.value44.Ambient
		t1.value6.OutdoorAmbient = t1.value44.OutdoorAmbient
		t1.value6.GlobalShadows = t1.value44.GlobalShadows
		t1.value6.ExposureCompensation = t1.value44.ExposureCompensation
		t1.value6.FogEnd = t1.value44.FogEnd
		t1.value6.FogStart = t1.value44.FogStart

		local Atmosphere = t1.value6:FindFirstChildOfClass("Atmosphere")
		local Parent

		if not Atmosphere then
			for k, darknessGui in pairs(t1.value44.DarknessGuis) do
				if k then
					Parent = k.Parent
				else
					Parent = k
				end

				if Parent then
					k.Visible = true
				end
			end

			t1.value44.DarknessGuis = {}

			return
		end

		Atmosphere.Density = t1.value44.AtmosphereDensity
		Atmosphere.Haze = t1.value44.AtmosphereHaze
		Atmosphere.Glare = t1.value44.AtmosphereGlare

		for k, darknessGui in pairs(t1.value44.DarknessGuis) do
			if k then
				Parent = k.Parent
			else
				Parent = k
			end

			if Parent then
				k.Visible = true
			end
		end

		t1.value44.DarknessGuis = {}
	end)
end

task.spawn(function()
	while true do
		repeat
			task.wait(1.5)
		until t1.value12.FullbrightEnabled

		t1.value46()
	end
end)
t1.value48 = {
	LastParryTick = 0,
	ParryCircle = nil
}

function t1.value49()
	local Character = t1.value10.Character

	if Character then
		local attribute = t1.value10:GetAttribute("EquippedItem")
		local v328

		if typeof(attribute) == "string" then
			v328 = attribute ~= ""
		else
			v328 = false
		end

		if v328 then
			local v329 = attribute:lower()

			return (v329:find("parry") or (v329:find("dagger") or v329:find("sword"))) and true or false
		elseif Character:FindFirstChild("Parrying Dagger") then
			return true
		else
			local GetChildren = Character.GetChildren

			for _, v in ipairs(GetChildren(Character)) do
				local v333 = v.Name:lower()

				if v333:find("parry") or v333:find("dagger") then
					return true
				end
			end

			return false
		end
	else
		return false
	end
end
function t1.value50()
	local now = tick()

	if now - t1.value48.LastParryTick < 0.5 then
		return
	end

	t1.value48.LastParryTick = now

	local function v335()
		local Remotes = t1.value7:FindFirstChild("Remotes")

		if Remotes then
			Remotes = Remotes:FindFirstChild("Items")
		end

		if Remotes then
			Remotes = Remotes:FindFirstChild("Parrying Dagger")
		end

		if Remotes then
			Remotes = Remotes:FindFirstChild("parry")
		end

		local isRemoteEvent

		if Remotes then
			isRemoteEvent = Remotes:IsA("RemoteEvent")
		else
			isRemoteEvent = Remotes
		end

		if isRemoteEvent then
			Remotes:FireServer()
		end

		t1.value3:SendMouseButtonEvent(0, 0, 1, true, game, 1)
		task.delay(0.06, function()
			t1.value3:SendMouseButtonEvent(0, 0, 1, false, game, 1)
		end)
	end

	pcall(v335)
end

t1.value51 = {
	"attack",
	"slash",
	"swing",
	"lunge",
	"strike",
	"frenzy",
	"swipe",
	"cleave",
	"stab",
	"m1"
}
t1.value52 = {
	"idle",
	"walk",
	"run",
	"jump",
	"fall",
	"vault",
	"slide",
	"crouch",
	"heal",
	"carry",
	"hook",
	"pickup",
	"emote",
	"stun",
	"pallet",
	"drop",
	"repair",
	"wiggle",
	"struggle"
}

function t1.value53(p19, p20)
	local v338 = p20.Position - p19.Position

	return v338.Magnitude < 0.05 and true or p19.CFrame.LookVector:Dot(v338.Unit) > 0.05
end
function t1.value54(p21)
	local v339, v340, v341 = ipairs(t1.value52)

	while true do
		local v342

		v341, v342 = v339(v340, v341)

		if not v341 then
			break
		end

		if p21:find(v342, 1, true) then
			return false
		end
	end

	for _, v in ipairs(t1.value51) do
		if p21:find(v, 1, true) then
			return true
		end
	end

	return nil
end
function t1.value55(p22, p23, p24, _)
	if not (p22 and (p23 and p24)) then
		return false
	end

	local Humanoid = p22:FindFirstChildOfClass("Humanoid")
	local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

	if not Animator then
		return false
	end

	for _, v in ipairs(Animator:GetPlayingAnimationTracks()) do
		if v.IsPlaying then
			local v349 = (v.Name or ""):lower()
			local Animation = v.Animation

			if Animation then
				Animation = (Animation.Name or ""):lower()
			end

			local v351 = v349 .. " " .. (Animation or "")
			local v352 = t1.value54(v351)

			if v352 == true then
				return true
			end

			local v353

			if v352 == nil then
				v353 = t1.value53(p23, p24)
			else
				v353 = false
			end

			if v353 then
				local Priority = v.Priority

				if Priority == Enum.AnimationPriority.Action or ((Priority == Enum.AnimationPriority.Action2 or Priority == Enum.AnimationPriority.Action3) and true or Priority == Enum.AnimationPriority.Action4) then
					return true
				end
			end
		end
	end

	return false
end

local function v355()
	if not t1.value12.AutoParry then
		return
	end

	if not t1.value49() then
		return
	end

	local Character = t1.value10.Character
	local Magnitude

	if not Character then
		v364, v365 = t1.value36()

		if Character and (v364 and v365) then
			Magnitude = (v364.Position - Character.Position).Magnitude

			if (t1.value12.ParryDistance or 13) < Magnitude then
				return
			elseif t1.value55(v365, v364, Character, Magnitude) then
				t1.value50()

				return
			else
				return
			end
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	local v358, v359 = t1.value36()

	if Character and (v358 and v359) then
		Magnitude = (v358.Position - Character.Position).Magnitude

		if (t1.value12.ParryDistance or 13) < Magnitude then
			return
		elseif t1.value55(v359, v358, Character, Magnitude) then
			t1.value50()

			return
		else
			return
		end
	end
end

RunService.Heartbeat:Connect(function()
	if not t1.value12.AutoParry then
		return
	end

	if not t1.value49() then
		return
	end

	local Character = t1.value10.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	if not HumanoidRootPart then
		return
	end

	local v362, v363 = t1.value36()

	if not (v362 and v363) then
		return
	end

	local Magnitude = (v362.Position - HumanoidRootPart.Position).Magnitude

	if not (Magnitude <= (t1.value12.ParryDistance or 13) and t1.value55(v363, v362, HumanoidRootPart, Magnitude)) then
		return
	end

	t1.value50()
end)
pcall(function()
	local Remotes = t1.value7:FindFirstChild("Remotes")

	if not Remotes then
		return
	end

	local t2 = {}
	local Attacks = Remotes:FindFirstChild("Attacks")

	if Attacks then
		for _, v in ipairs({
			"BasicAttack",
			"Lunge",
			"LungeDetect",
			"TrailEvent"
		}) do
			local v370 = Attacks:FindFirstChild(v)

			if v370 then
				table.insert(t2, v370)
			end
		end
	end

	local AttackEvent = Remotes:FindFirstChild("AttackEvent")

	if AttackEvent then
		table.insert(t2, AttackEvent)
	end

	local Killers = Remotes:FindFirstChild("Killers")

	if Killers then
		Killers = Killers:FindFirstChild("SlowAttack")
	end

	if Killers then
		table.insert(t2, Killers)
	end

	for _, v in ipairs(t2) do
		if v:IsA("RemoteEvent") then
			local function v375()
				v355()
			end

			v.OnClientEvent:Connect(v375)
		elseif v:IsA("BindableEvent") then
			v.Event:Connect(function()
				v355()
			end)
		end
	end
end)

local function v376()
	local ParryCircle = t1.value48.ParryCircle

	if ParryCircle then
		ParryCircle = t1.value48.ParryCircle.Parent
	end

	if not ParryCircle then
		local CylinderHandleAdornment = Instance.new("CylinderHandleAdornment")

		CylinderHandleAdornment.Name = "SBB_ParryCircle"
		CylinderHandleAdornment.Height = 0.08
		CylinderHandleAdornment.Color3 = Color3.fromRGB(255, 255, 255)
		CylinderHandleAdornment.Transparency = 0.15
		CylinderHandleAdornment.AlwaysOnTop = true
		CylinderHandleAdornment.ZIndex = 2
		CylinderHandleAdornment.CFrame = CFrame.new(0, -2.85, 0) * CFrame.Angles(math.rad(90), 0, 0)
		pcall(function()
			local v379 = CylinderHandleAdornment
			local v380 = (t1.value12.ParryDistance or 13) - 0.14

			v379.InnerRadius = math.max(v380, 0.1)
		end)
		CylinderHandleAdornment.Parent = t1.value11
		t1.value48.ParryCircle = CylinderHandleAdornment

		return CylinderHandleAdornment
	end

	if not t1.value12.StreamerMode then
		return t1.value48.ParryCircle
	end

	t1.value48.ParryCircle.Visible = false

	return t1.value48.ParryCircle
end

RunService.RenderStepped:Connect(function()
	local v381 = v376()

	if not t1.value12.AutoParry or t1.value12.StreamerMode then
		v381.Visible = false

		return
	end

	local Character = t1.value10.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	if not HumanoidRootPart then
		v381.Visible = false

		return
	end

	local ParryDistance = t1.value12.ParryDistance or 13

	v381.Adornee = HumanoidRootPart
	v381.Radius = ParryDistance
	pcall(function()
		local v385 = v381
		local v386 = ParryDistance - 0.14

		v385.InnerRadius = math.max(v386, 0.1)
	end)
	v381.Color3 = Color3.fromRGB(255, 255, 255)
	v381.Transparency = 0.15
	v381.Visible = true
end)
t1.value56 = {
	IsAiming = false,
	IsFiring = false,
	HasGun = false,
	CachedTarget = nil,
	TargetPart = nil,
	CachedTargetPos = nil,
	CachedTargetOffset = nil,
	CachedOrigin = nil,
	CachedDir = nil,
	CachedTargetModel = nil,
	Muzzle = nil,
	LastTargetRefresh = 0,
	TargetRefreshInterval = 0.08,
	LastAimPointRefresh = 0,
	AimPointRefreshInterval = 0.03,
	AimLeadTime = 0.08,
	LastLeadRefresh = 0,
	GunModel = nil,
	FireRemote = nil,
	VisualRemote = nil
}
t1.value2.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		t1.value56.IsAiming = true

		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	t1.value56.IsFiring = true
end)
t1.value2.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		t1.value56.IsAiming = false

		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	t1.value56.IsFiring = false
end)
t1.value57 = nil

function t1.value58()
	local Remotes = t1.value7:FindFirstChild("Remotes")

	if Remotes then
		Remotes = Remotes:FindFirstChild("Items")
	end

	if Remotes then
		Remotes = Remotes:FindFirstChild("Twist of Fate")
	end

	if not Remotes then
		return
	end

	local FireRemote = t1.value56.FireRemote

	if FireRemote then
		FireRemote = t1.value56.FireRemote.Parent
	end

	if not FireRemote then
		t1.value56.FireRemote = Remotes:FindFirstChild("Fire")
	end

	local VisualRemote = t1.value56.VisualRemote

	if VisualRemote then
		VisualRemote = t1.value56.VisualRemote.Parent
	end

	if VisualRemote then
		return t1.value56.FireRemote
	end

	t1.value56.VisualRemote = Remotes:FindFirstChild("VisualizeBullet")

	return t1.value56.FireRemote
end

t1.value59 = RaycastParams.new()
t1.value59.FilterType = Enum.RaycastFilterType.Exclude
t1.value59.IgnoreWater = true
t1.value60 = {
	"UpperTorso",
	"Torso",
	"HumanoidRootPart",
	"Head",
	"Left Arm",
	"Right Arm",
	"LeftUpperArm",
	"RightUpperArm",
	"LeftLowerArm",
	"RightLowerArm",
	"LeftHand",
	"RightHand",
	"Left Leg",
	"Right Leg",
	"LeftUpperLeg",
	"RightUpperLeg",
	"LeftLowerLeg",
	"RightLowerLeg",
	"LeftFoot",
	"RightFoot"
}
t1.value61 = 5000

function t1.value62(p25)
	if p25 then
		for _, v in ipairs({
			"Muzzle",
			"MuzzleAttachment",
			"FirePoint",
			"Barrel",
			"Handle"
		}) do
			local v392 = p25:FindFirstChild(v, true)
			local isAttachment

			if v392 then
				isAttachment = v392:IsA("Attachment") or v392:IsA("BasePart")
			else
				isAttachment = v392
			end

			if isAttachment then
				return v392
			end
		end

		return nil
	else
		return nil
	end
end
function t1.value63(p26, p27)
	local Muzzle = t1.value56.Muzzle
	local Parent

	if p26 then
		if Muzzle then
			Parent = Muzzle.Parent

			if Parent then
				Parent = Muzzle:IsDescendantOf(p26)
			end
		else
			Parent = Muzzle
		end
	else
		Parent = p26
	end

	if not Parent then
		Muzzle = t1.value62(p26)
		t1.value56.Muzzle = Muzzle
	end

	if Muzzle then
		if Muzzle:IsA("Attachment") then
			return Muzzle.WorldPosition
		end

		if Muzzle:IsA("BasePart") then
			return Muzzle.Position
		end
	end

	if not p27 then
		return p27 or nil
	end

	p27 = p27.CFrame.Position

	return p27 or nil
end
function t1.value64()
	local now = os.clock()

	if now - t1.value56.LastLeadRefresh < 0.25 then
		return t1.value56.AimLeadTime
	end

	local AimLeadTime = t1.value56.AimLeadTime
	local aimLeadTime = nil

	local function v399()
		local networkPing = t1.value10:GetNetworkPing()
		local v401

		if typeof(networkPing) == "number" then
			v401 = networkPing > 0
		else
			v401 = false
		end

		if not v401 then
			return
		end

		aimLeadTime = math.clamp(networkPing, 0.03, 0.15)
	end

	aimLeadTime = AimLeadTime or 0.08
	pcall(v399)
	t1.value56.AimLeadTime = aimLeadTime
	t1.value56.LastLeadRefresh = now

	return aimLeadTime
end
function t1.value65(p28, p29, p30)
	local v402 = p28.Size * 0.48
	local CFrame_ = p28.CFrame
	local v404 = CFrame_.PointToObjectSpace(CFrame_, p29)
	local X = v404.X
	local v406 = math.abs(X)
	local X2 = v402.X
	local v408 = v406 / math.max(X2, 0.01)
	local v409 = math.abs(v404.Y)
	local Y = v402.Y
	local v411 = v409 / math.max(Y, 0.01)
	local Z = v404.Z
	local v413 = math.abs(Z)
	local Z2 = v402.Z
	local v415 = v413 / math.max(Z2, 0.01)
	local v416 = v408 <= v411
	local s1 = "X"

	if v416 then
		v416 = v415 <= v411
	end

	local s2

	if v416 then
		s2 = "Y"
	else
		local v419

		if v408 <= v415 then
			v419 = v411 <= v415
		else
			v419 = false
		end

		s2 = v419 and "Z" or s1
	end

	local v420

	if s2 == "X" then
		v420 = v404.X >= 0 and 1 or -1
	elseif s2 == "Y" then
		v420 = v404.Y >= 0 and 1 or -1
	else
		v420 = v404.Z >= 0 and 1 or -1
	end

	local function v421(p31)
		local v422 = p28.CFrame * p31
		local v423 = v422 - p29
		local Magnitude = v423.Magnitude

		if Magnitude <= 0.05 and true or t1.value61 < Magnitude then
			return nil, nil, nil
		end

		local hit = workspace:Raycast(p29, v423, t1.value59)

		if not hit then
			return p28, p31, v422
		end

		local Instance_ = hit.Instance

		if Instance_ then
		elseif Instance_ then
			if hit.Instance:IsA("BasePart") then
				return hit.Instance, hit.Instance.CFrame:PointToObjectSpace(hit.Position), hit.Position
			else
				return p28, p31, v422
			end
		else
			return nil, nil, nil
		end

		Instance_ = hit.Instance:IsDescendantOf(p30)

		if Instance_ then
			if hit.Instance:IsA("BasePart") then
				return hit.Instance, hit.Instance.CFrame:PointToObjectSpace(hit.Position), hit.Position
			else
				return p28, p31, v422
			end
		else
			return nil, nil, nil
		end
	end

	local t3 = { 0, -0.78, 0.78 }

	for _, v in ipairs(t3) do
		for _, v2 in ipairs(t3) do
			local vector3

			if s2 == "X" then
				vector3 = Vector3.new(v420 * v402.X, v * v402.Y, v2 * v402.Z)
			elseif s2 == "Y" then
				vector3 = Vector3.new(v * v402.X, v420 * v402.Y, v2 * v402.Z)
			else
				vector3 = Vector3.new(v * v402.X, v2 * v402.Y, v420 * v402.Z)
			end

			local v433, v434, v435 = v421(vector3)

			if v433 then
				return v433, v434, v435
			end
		end
	end

	return nil, nil, nil
end
function t1.value66(p32, p33, p34, p35)
	if not (p32 and p34) then
		return nil, nil, nil
	end

	local Model = p35 or (p34:FindFirstAncestorOfClass("Model") or p34.Parent)

	if not Model then
		return p34, p34.Position, Vector3.zero
	end

	local filterDescendantsInstances = {}

	if p33 then
		table.insert(filterDescendantsInstances, p33)
	end

	local GunModel = t1.value56.GunModel

	if GunModel then
		table.insert(filterDescendantsInstances, GunModel)
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		table.insert(filterDescendantsInstances, CurrentCamera)
	end

	t1.value59.FilterDescendantsInstances = filterDescendantsInstances

	for _, v in ipairs(t1.value60) do
		local v442 = Model:FindFirstChild(v)
		local isBasePart

		if v442 then
			isBasePart = v442:IsA("BasePart")
		else
			isBasePart = v442
		end

		if isBasePart then
			local v444, v445, v446 = t1.value65(v442, p32, Model)

			if v444 then
				local AssemblyLinearVelocity = v444.AssemblyLinearVelocity
				local v448

				if typeof(AssemblyLinearVelocity) == "Vector3" then
					v448 = AssemblyLinearVelocity.Magnitude > 0.5
				else
					v448 = false
				end

				if not v448 then
					return v444, v446, v445
				end

				v446 = v446 + AssemblyLinearVelocity * t1.value64()

				return v444, v446, v445
			end
		end
	end

	return nil, nil, nil
end
function t1.value67(p36)
	if not p36 then
		return nil
	end

	local attribute = t1.value10:GetAttribute("EquippedItem")
	local v450 = typeof(attribute) == "string"
	local TwistOfFate, GetChildren, v453, isTool

	if not v450 then
		v474 = v450 and (p36:FindFirstChild(attribute) or p36:FindFirstChild("Twist of Fate"))

		if v474 then
			return v474
		else
			TwistOfFate = p36:FindFirstChild("Twist of Fate")

			if TwistOfFate then
				return TwistOfFate
			else
				GetChildren = p36.GetChildren

				for _, v in ipairs(GetChildren(p36)) do
					v453 = v.Name:lower()

					if v453:find("twist") or (v453:find("fate") or (v453:find("gun") or (v453:find("revolver") or (v453:find("pistol") or v453:find("firearm"))))) then
						return v
					end

					isTool = v:IsA("Tool")

					if isTool then
						isTool = not v453:find("dagger") or v453:find("parry") or (v453:find("med") or v453:find("bandage"))
					end

					if isTool then
						return v
					end
				end

				return nil
			end
		end
	end

	v450 = attribute:lower():find("twist")

	if v450 then
		v474 = v450 and (p36:FindFirstChild(attribute) or p36:FindFirstChild("Twist of Fate"))

		if v474 then
			return v474
		else
			TwistOfFate = p36:FindFirstChild("Twist of Fate")

			if TwistOfFate then
				return TwistOfFate
			else
				GetChildren = p36.GetChildren

				for _, v in ipairs(GetChildren(p36)) do
					v453 = v.Name:lower()

					if v453:find("twist") or (v453:find("fate") or (v453:find("gun") or (v453:find("revolver") or (v453:find("pistol") or v453:find("firearm"))))) then
						return v
					end

					isTool = v:IsA("Tool")

					if isTool then
						isTool = not v453:find("dagger") or v453:find("parry") or (v453:find("med") or v453:find("bandage"))
					end

					if isTool then
						return v
					end
				end

				return nil
			end
		end
	end

	v450 = attribute.lower(attribute):find("gun")

	if v450 then
		v474 = v450 and (p36:FindFirstChild(attribute) or p36:FindFirstChild("Twist of Fate"))

		if v474 then
			return v474
		else
			TwistOfFate = p36:FindFirstChild("Twist of Fate")

			if TwistOfFate then
				return TwistOfFate
			else
				GetChildren = p36.GetChildren

				for _, v in ipairs(GetChildren(p36)) do
					v453 = v.Name:lower()

					if v453:find("twist") or (v453:find("fate") or (v453:find("gun") or (v453:find("revolver") or (v453:find("pistol") or v453:find("firearm"))))) then
						return v
					end

					isTool = v:IsA("Tool")

					if isTool then
						isTool = not v453:find("dagger") or v453:find("parry") or (v453:find("med") or v453:find("bandage"))
					end

					if isTool then
						return v
					end
				end

				return nil
			end
		end
	end

	local v461 = attribute:lower()

	v450 = v461.find(v461, "fate") or attribute:lower():find("revolver")

	local TwistOfFate2 = v450 and (p36:FindFirstChild(attribute) or p36:FindFirstChild("Twist of Fate"))

	if TwistOfFate2 then
		return TwistOfFate2
	else
		TwistOfFate = p36:FindFirstChild("Twist of Fate")

		if TwistOfFate then
			return TwistOfFate
		else
			GetChildren = p36.GetChildren

			for _, v in ipairs(GetChildren(p36)) do
				v453 = v.Name:lower()

				if v453:find("twist") or (v453:find("fate") or (v453:find("gun") or (v453:find("revolver") or (v453:find("pistol") or v453:find("firearm"))))) then
					return v
				end

				isTool = v:IsA("Tool")

				if isTool then
					isTool = not v453:find("dagger") or v453:find("parry") or (v453:find("med") or v453:find("bandage"))
				end

				if isTool then
					return v
				end
			end

			return nil
		end
	end
end
function t1.value68()
	local Character = t1.value10.Character
	local v466 = t1.value67(Character)

	t1.value56.GunModel = v466
	t1.value56.HasGun = typeof(v466) == "Instance"

	local function v467()
		return t1.value2:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	end

	t1.value58()

	local ok, isAiming = pcall(v467)

	if ok then
		t1.value56.IsAiming = isAiming
	end

	local function v470()
		return t1.value2:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	end

	local ok2, isFiring = pcall(v470)

	if ok2 then
		t1.value56.IsFiring = isFiring
	end

	local ShowTracer = not t1.value12.SilentAim and t1.value12.ShowTracer

	if ShowTracer then
		ShowTracer = t1.value56.HasGun
	end

	if not ShowTracer then
		t1.value56.CachedTarget = nil
		t1.value56.TargetPart = nil
		t1.value56.CachedTargetModel = nil
		t1.value56.CachedTargetPos = nil
		t1.value56.CachedTargetOffset = nil
		t1.value56.CachedOrigin = nil
		t1.value56.CachedDir = nil
		t1.value56.LastTargetRefresh = 0
		t1.value56.LastAimPointRefresh = 0

		return
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		CurrentCamera = CurrentCamera.CFrame.Position
	end

	local cachedOrigin = CurrentCamera or t1.value63(v466, nil)

	if not cachedOrigin and Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

		if HumanoidRootPart then
			cachedOrigin = HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
		end
	end

	t1.value56.CachedOrigin = cachedOrigin
	t1.value64()

	local now = os.clock()
	local TargetPart = t1.value56.TargetPart
	local v479

	if now - t1.value56.LastTargetRefresh >= t1.value56.TargetRefreshInterval then
		local v480

		TargetPart, v480 = t1.value57()
		t1.value56.TargetPart = TargetPart
		t1.value56.CachedTargetModel = v480
		t1.value56.LastTargetRefresh = now
		v479 = true
	else
		v479 = false
	end

	local v481

	if not (v479 or now - t1.value56.LastAimPointRefresh >= t1.value56.AimPointRefreshInterval) then
		v496 = t1.value56.CachedTargetPos

		if cachedOrigin and v496 then
			v481 = v496 - cachedOrigin
			t1.value56.CachedDir = v481.Magnitude > 0.001 and v481.Unit or nil
		else
			t1.value56.CachedDir = nil
		end

		return
	end

	local v482, v483, v484 = t1.value66(cachedOrigin, Character, TargetPart, t1.value56.CachedTargetModel)

	t1.value56.CachedTarget = v482
	t1.value56.CachedTargetPos = v483
	t1.value56.CachedTargetOffset = v484
	t1.value56.LastAimPointRefresh = now

	local CachedTargetPos = t1.value56.CachedTargetPos

	if cachedOrigin and CachedTargetPos then
		v481 = CachedTargetPos - cachedOrigin
		t1.value56.CachedDir = v481.Magnitude > 0.001 and v481.Unit or nil
	else
		t1.value56.CachedDir = nil
	end
end

t1.value69 = {
	Beam = nil,
	Att0 = nil,
	Att1 = nil,
	OriginPart = nil,
	LineParts = {},
	OverlayGui = nil,
	OverlayLine = nil,
	OverlayDot = nil,
	LastFallbackRefresh = 0
}
t1.value70 = 0.18
t1.value71 = 900

function t1.value72(p37)
	if t1.value69.Beam then
		t1.value69.Beam.Enabled = p37
	end

	if t1.value69.OverlayLine then
		t1.value69.OverlayLine.Visible = p37
	end

	local Parent

	if not t1.value69.OverlayDot then
		for _, linePart in ipairs(t1.value69.LineParts) do
			if linePart then
				Parent = linePart.Parent
			else
				Parent = linePart
			end

			if Parent then
				linePart.Transparency = p37 and 0.03 or 1
			end
		end

		return
	end

	t1.value69.OverlayDot.Visible = p37

	for _, linePart in ipairs(t1.value69.LineParts) do
		if linePart then
			Parent = linePart.Parent
		else
			Parent = linePart
		end

		if Parent then
			linePart.Transparency = p37 and 0.03 or 1
		end
	end
end
function t1.value73(p38)
	local v491 = t1.value69.LineParts[p38]
	local Parent

	if v491 then
		Parent = v491.Parent
	else
		Parent = v491
	end

	if Parent then
		return v491
	else
		local Part = Instance.new("Part")

		Part.Name = "SBB_TracerLine_" .. p38
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = false
		Part.Material = Enum.Material.Neon
		Part.Transparency = 1
		Part.Size = Vector3.new(t1.value70, t1.value70, 0.1)
		Part.Parent = workspace
		t1.value69.LineParts[p38] = Part

		return Part
	end
end
function t1.value74(p39, p40, p41)
	local v494 = p40 - p39
	local Magnitude = v494.Magnitude

	if Magnitude <= 0.05 then
		t1.value72(false)

		return false
	else
		local clamp = math.clamp
		local v497 = Magnitude / t1.value71
		local v498 = clamp(math.ceil(v497), 1, 6)
		local Unit = v494.Unit
		local v500 = Magnitude / v498

		for i = 1, v498 do
			local v502 = p39 + Unit * ((i - 1) * v500)
			local v503 = p39 + Unit * (i * v500)
			local v504 = t1.value73(i)

			v504.Color = p41
			v504.Transparency = 0.03
			v504.Size = Vector3.new(t1.value70, t1.value70, v500)
			v504.CFrame = CFrame.lookAt((v502 + v503) * 0.5, v503)
		end

		for i = v498 + 1, #t1.value69.LineParts do
			local v506 = t1.value69.LineParts[i]
			local Parent

			if v506 then
				Parent = v506.Parent
			else
				Parent = v506
			end

			if Parent then
				v506.Transparency = 1
			end
		end

		return true
	end
end
function t1.value75()
	local OverlayGui = t1.value69.OverlayGui

	if OverlayGui then
		OverlayGui = OverlayGui.Parent
	end

	if OverlayGui then
		return t1.value69.OverlayLine, t1.value69.OverlayDot
	end

	local SBB_TracerOverlay = t1.value11:FindFirstChild("SBB_TracerOverlay")

	if not SBB_TracerOverlay then
		v526 = Instance.new("ScreenGui")
		v526.Name = "SBB_TracerOverlay"
		v526.ResetOnSpawn = false
		v526.IgnoreGuiInset = true
		v526.DisplayOrder = 2147483646
		v526.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		v526.Parent = t1.value11
		v527 = Instance.new("Frame")
		v527.Name = "Line"
		v527.AnchorPoint = Vector2.new(0, 0.5)
		v527.BorderSizePixel = 0
		v527.BackgroundTransparency = 0.05
		v527.Size = UDim2.fromOffset(1, 3)
		v527.Visible = false
		v527.ZIndex = 10000
		v527.Parent = v526
		Instance.new("UICorner", v527).CornerRadius = UDim.new(1, 0)
		v528 = Instance.new("UIStroke")
		v528.Thickness = 1
		v528.Transparency = 0.25
		v528.Parent = v527
		v529 = Instance.new("Frame")
		v529.Name = "Endpoint"
		v529.AnchorPoint = Vector2.new(0.5, 0.5)
		v529.BorderSizePixel = 0
		v529.BackgroundTransparency = 0.02
		v529.Size = UDim2.fromOffset(8, 8)
		v529.Visible = false
		v529.ZIndex = 10001
		v529.Parent = v526
		Instance.new("UICorner", v529).CornerRadius = UDim.new(1, 0)
		v530 = Instance.new("UIStroke")
		v530.Thickness = 1
		v530.Transparency = 0.15
		v530.Color = Color3.new(1, 1, 1)
		v530.Parent = v529
		t1.value69.OverlayGui = v526
		t1.value69.OverlayLine = v527
		t1.value69.OverlayDot = v529

		return v527, v529
	end

	pcall(function()
		SBB_TracerOverlay:Destroy()
	end)

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "SBB_TracerOverlay"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 2147483646
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = t1.value11

	local Frame = Instance.new("Frame")

	Frame.Name = "Line"
	Frame.AnchorPoint = Vector2.new(0, 0.5)
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 0.05
	Frame.Size = UDim2.fromOffset(1, 3)
	Frame.Visible = false
	Frame.ZIndex = 10000
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1
	UIStroke.Transparency = 0.25
	UIStroke.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Endpoint"
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.BorderSizePixel = 0
	Frame2.BackgroundTransparency = 0.02
	Frame2.Size = UDim2.fromOffset(8, 8)
	Frame2.Visible = false
	Frame2.ZIndex = 10001
	Frame2.Parent = ScreenGui
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1
	UIStroke2.Transparency = 0.15
	UIStroke2.Color = Color3.new(1, 1, 1)
	UIStroke2.Parent = Frame2
	t1.value69.OverlayGui = ScreenGui
	t1.value69.OverlayLine = Frame
	t1.value69.OverlayDot = Frame2

	return Frame, Frame2
end
function t1.value76()
	local GunModel = t1.value56.GunModel
	local v516 = t1.value63(GunModel, nil)

	if v516 then
		return v516
	end

	local Character = t1.value10.Character

	if Character then
	elseif Character then
		return Character.Position + Vector3.new(0, 1.35, 0)
	else
		return t1.value56.CachedOrigin
	end

	Character = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

	if Character then
		return Character.Position + Vector3.new(0, 1.35, 0)
	else
		return t1.value56.CachedOrigin
	end
end
function t1.value57()
	local Character = t1.value10.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
	end

	if not Character then
		return nil, nil
	end

	local AimTarget = t1.value12.AimTarget or "Killer"

	if AimTarget == "Killer" then
		local v520, v521 = t1.value36()

		if v520 and v521 then
			return v520, v521
		end

		local huge = math.huge
		local ipairs_ = ipairs
		local value1 = t1.value1
		local v525 = nil
		local Character2 = nil

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			local v531

			if player == t1.value10 then
				v531 = false
			else
				v531 = player.Character
			end

			if v531 then
				local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
				local v532

				if HumanoidRootPart then
					v532 = not Humanoid or Humanoid.Health > 0
				else
					v532 = HumanoidRootPart
				end

				if v532 then
					local Magnitude = (HumanoidRootPart.Position - Character.Position).Magnitude

					if Magnitude < huge then
						Character2 = player.Character
						v525 = HumanoidRootPart
						huge = Magnitude
					end
				end
			end
		end

		if v525 and Character2 then
			return v525, Character2
		end
	end

	if AimTarget == "Survivor" then
		local huge = math.huge
		local ipairs_ = ipairs
		local value1 = t1.value1
		local Head = nil
		local Character2 = nil

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			local v541

			if player == t1.value10 then
				v541 = false
			else
				v541 = player.Character
			end

			if v541 and not t1.value19(player.Character, player) then
				local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid = Humanoid.Health > 0
				end

				if Humanoid then
					local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")

					if HumanoidRootPart then
						local Magnitude = (HumanoidRootPart.Position - Character.Position).Magnitude

						if Magnitude < huge then
							Head = player.Character:FindFirstChild("Head") or HumanoidRootPart
							Character2 = player.Character
							huge = Magnitude
						end
					end
				end
			end
		end

		if Head then
			return Head, Character2
		end
	end

	if AimTarget == "Zombie" then
	elseif AimTarget == "Killer" then
		local v545, v546 = t1.value36()

		if v545 and v546 then
			return v545, v546
		else
			return nil, nil
		end
	else
		return nil, nil
	end

	local huge = math.huge
	local Head = nil
	local u549 = nil

	local function v550(p42, p43, p44)
		if not p42 or (not p42:IsA("Model") or p42 == t1.value10.Character) then
			return
		end

		local playerFromCharacter = t1.value1:GetPlayerFromCharacter(p42)

		if t1.value19(p42, playerFromCharacter) then
			return
		end

		if not p43 or p43.Health <= 0 then
			return
		end

		local v552 = p42.Name:lower()

		if v552:find("cure", 1, true) then
			return
		end

		local v553 = p42:GetAttribute("IsZombie") ~= nil or (p42.GetAttribute(p42, "Zombie") ~= nil or (p42:GetAttribute("IsCorpse") ~= nil or (p42:GetAttribute("Corpse") ~= nil or (p42:GetAttribute("Infected") ~= nil or (p42:GetAttribute("IsInfected") ~= nil and true or p42:GetAttribute("Minion") ~= nil)))))
		local pos = v552:find("corpse", 1, true) or (v552:find("zombie", 1, true) or (v552.find(v552, "minion", 1, true) or v552:find("infected", 1, true) or (v552:find("thrall", 1, true) or v552:find("undead", 1, true))))

		if v553 then
			p44 = v553
		elseif pos then
			p44 = pos
		elseif p44 then
			p44 = playerFromCharacter == nil
		end

		if not p44 then
			return
		end

		local HumanoidRootPart = p42:FindFirstChild("HumanoidRootPart") or (p42:FindFirstChild("Torso") or p42:FindFirstChild("UpperTorso"))

		if not HumanoidRootPart then
			return
		end

		if not ((HumanoidRootPart.Position - Character.Position).Magnitude < huge) then
			return
		end

		Head = p42:FindFirstChild("Head") or HumanoidRootPart
		u549 = p42
	end

	local v556, v557, v558 = ipairs(workspace:GetDescendants())
	local v559 = u549

	while true do
		local v560

		v558, v560 = v556(v557, v558)

		if not v558 then
			break
		end

		if v560:IsA("Humanoid") then
			v550(v560.Parent, v560, false)
		end
	end

	if Head then
		if Head then
			return Head, v559
		else
			return nil, nil
		end
	end

	local _ = math.huge

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Humanoid") then
			v550(descendant.Parent, descendant, true)
		end
	end

	if Head then
		return Head, v559
	else
		return nil, nil
	end
end
function t1.value77()
	local CachedTarget = t1.value56.CachedTarget
	local CachedOrigin = t1.value56.CachedOrigin
	local CachedTargetPos = t1.value56.CachedTargetPos
	local v567

	if CachedTarget then
		v567 = CachedOrigin and CachedTargetPos
	else
		v567 = CachedTarget
	end

	if v567 then
		return CachedTarget, CachedOrigin, CachedTargetPos
	end

	local now = os.clock()

	if now - t1.value69.LastFallbackRefresh < 0.1 then
		return nil, nil, nil
	end

	t1.value69.LastFallbackRefresh = now

	local CurrentCamera = workspace.CurrentCamera
	local Character = t1.value10.Character

	if not (CurrentCamera and Character) then
		return nil, nil, nil
	end

	local Position = CurrentCamera.CFrame.Position
	local TargetPart = t1.value56.TargetPart
	local CachedTargetModel = t1.value56.CachedTargetModel
	local v574, v575, v576, v577

	if TargetPart and TargetPart.Parent then
		if TargetPart then
			v574, v575, v576 = t1.value66(Position, Character, TargetPart, CachedTargetModel)

			if v574 and v575 then
				t1.value56.CachedOrigin = Position
				t1.value56.CachedTarget = v574
				t1.value56.CachedTargetPos = v575
				t1.value56.CachedTargetOffset = v576
				v577 = v575 - Position
				t1.value56.CachedDir = v577.Magnitude > 0.001 and v577.Unit or nil

				return v574, Position, v575
			else
				return nil, nil, nil
			end
		else
			return nil, nil, nil
		end
	end

	TargetPart, CachedTargetModel = t1.value57()
	t1.value56.TargetPart = TargetPart
	t1.value56.CachedTargetModel = CachedTargetModel

	if TargetPart then
		v574, v575, v576 = t1.value66(Position, Character, TargetPart, CachedTargetModel)

		if v574 and v575 then
			t1.value56.CachedOrigin = Position
			t1.value56.CachedTarget = v574
			t1.value56.CachedTargetPos = v575
			t1.value56.CachedTargetOffset = v576
			v577 = v575 - Position
			t1.value56.CachedDir = v577.Magnitude > 0.001 and v577.Unit or nil

			return v574, Position, v575
		else
			return nil, nil, nil
		end
	else
		return nil, nil, nil
	end
end
function t1.value78()
	if t1.value12.StreamerMode then
		t1.value72(false)

		return
	end

	if not t1.value12.ShowTracer then
		t1.value72(false)

		return
	end

	local v578, v579, v580 = t1.value77()

	if not (v578 and (v579 and v580)) then
		t1.value72(false)

		return
	end

	local TracerColor = t1.value12.TracerColor or Color3.fromRGB(255, 60, 80)
	local v582 = t1.value76() or v579

	t1.value74(v582, v580, TracerColor)

	if t1.value69.OverlayLine then
		t1.value69.OverlayLine.Visible = false
	end

	if t1.value69.OverlayDot then
		t1.value69.OverlayDot.Visible = false
	end

	local Attachment, Attachment2, Beam

	if t1.value69.OriginPart and t1.value69.OriginPart.Parent then
		t1.value69.OriginPart.CFrame = CFrame.new(v582)

		if t1.value69.Att0 and t1.value69.Att0.Parent then
			t1.value69.Att0.Parent = t1.value69.OriginPart
		else
			Attachment = Instance.new("Attachment")
			Attachment.Name = "SBB_TracerAtt0"
			Attachment.Parent = t1.value69.OriginPart
			t1.value69.Att0 = Attachment
		end

		if t1.value69.Att1 and t1.value69.Att1.Parent then
			t1.value69.Att1.Parent = v578
		else
			Attachment2 = Instance.new("Attachment")
			Attachment2.Name = "SBB_TracerAtt1"
			Attachment2.Parent = v578
			t1.value69.Att1 = Attachment2
		end

		t1.value69.Att0.Position = Vector3.zero
		t1.value69.Att1.Position = v578.CFrame:PointToObjectSpace(v580)

		if t1.value69.Beam and t1.value69.Beam.Parent then
			t1.value69.Beam.Attachment0 = t1.value69.Att0
			t1.value69.Beam.Attachment1 = t1.value69.Att1
			t1.value69.Beam.Color = ColorSequence.new(TracerColor)
			t1.value69.Beam.Enabled = true
		else
			Beam = Instance.new("Beam")
			Beam.Name = "SBB_TracerBeam"
			Beam.Attachment0 = t1.value69.Att0
			Beam.Attachment1 = t1.value69.Att1
			Beam.Width0 = 0.16
			Beam.Width1 = 0.16
			Beam.FaceCamera = true
			Beam.LightEmission = 1
			Beam.LightInfluence = 0
			Beam.Transparency = NumberSequence.new(0.1)
			Beam.Color = ColorSequence.new(TracerColor)
			Beam.Enabled = true
			Beam.Parent = workspace
			t1.value69.Beam = Beam
		end

		return
	end

	local Part = Instance.new("Part")

	Part.Name = "SBB_TracerOrigin"
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Transparency = 1
	Part.Size = Vector3.new(0.05, 0.05, 0.05)
	Part.Parent = workspace
	t1.value69.OriginPart = Part
	t1.value69.OriginPart.CFrame = CFrame.new(v582)

	if t1.value69.Att0 and t1.value69.Att0.Parent then
		t1.value69.Att0.Parent = t1.value69.OriginPart
	else
		Attachment = Instance.new("Attachment")
		Attachment.Name = "SBB_TracerAtt0"
		Attachment.Parent = t1.value69.OriginPart
		t1.value69.Att0 = Attachment
	end

	if t1.value69.Att1 and t1.value69.Att1.Parent then
		t1.value69.Att1.Parent = v578
	else
		Attachment2 = Instance.new("Attachment")
		Attachment2.Name = "SBB_TracerAtt1"
		Attachment2.Parent = v578
		t1.value69.Att1 = Attachment2
	end

	t1.value69.Att0.Position = Vector3.zero
	t1.value69.Att1.Position = v578.CFrame:PointToObjectSpace(v580)

	if t1.value69.Beam and t1.value69.Beam.Parent then
		t1.value69.Beam.Attachment0 = t1.value69.Att0
		t1.value69.Beam.Attachment1 = t1.value69.Att1
		t1.value69.Beam.Color = ColorSequence.new(TracerColor)
		t1.value69.Beam.Enabled = true
	else
		Beam = Instance.new("Beam")
		Beam.Name = "SBB_TracerBeam"
		Beam.Attachment0 = t1.value69.Att0
		Beam.Attachment1 = t1.value69.Att1
		Beam.Width0 = 0.16
		Beam.Width1 = 0.16
		Beam.FaceCamera = true
		Beam.LightEmission = 1
		Beam.LightInfluence = 0
		Beam.Transparency = NumberSequence.new(0.1)
		Beam.Color = ColorSequence.new(TracerColor)
		Beam.Enabled = true
		Beam.Parent = workspace
		t1.value69.Beam = Beam
	end
end

RunService.RenderStepped:Connect(function()
	pcall(t1.value68)
	pcall(t1.value78)
end)
pcall(function()
	local hookmetamethod_ = hookmetamethod

	if typeof(hookmetamethod_) ~= "function" then
		return
	end

	local newcclosure_ = newcclosure
	local newcclosure_2

	if typeof(newcclosure_) == "function" then
		newcclosure_2 = newcclosure
	else
		newcclosure_2 = false
	end

	local v590 = newcclosure_2 or function(p45)
		return p45
	end

	local function v591(p46, p47)
		if typeof(p46) == "Instance" then
			if p46 == t1.value56.FireRemote and true or p46 == t1.value56.VisualRemote then
				return true
			else
				local name = p47(p46, "Name")
				local v593

				if name == "Fire" then
					v593 = false
				else
					v593 = name ~= "VisualizeBullet"
				end

				if v593 then
					return false
				else
					local parent = p47(p46, "Parent")
					local v595

					if parent == nil then
						v595 = false
					else
						v595 = p47(parent, "Name") == "Twist of Fate"
					end

					return v595
				end
			end
		else
			return false
		end
	end
	local function v596(...)
		local CachedDir = t1.value56.CachedDir
		local CachedTarget = t1.value56.CachedTarget
		local CachedOrigin = t1.value56.CachedOrigin
		local Parent

		if CachedTarget then
			Parent = CachedTarget.Parent and CachedOrigin
		else
			Parent = CachedTarget
		end

		if Parent then
			local CachedTargetOffset = t1.value56.CachedTargetOffset or Vector3.zero
			local v602 = CachedTarget.CFrame * CachedTargetOffset
			local AssemblyLinearVelocity = CachedTarget.AssemblyLinearVelocity
			local v604

			if typeof(AssemblyLinearVelocity) == "Vector3" then
				v604 = AssemblyLinearVelocity.Magnitude > 0.5
			else
				v604 = false
			end

			if v604 then
				v602 = v602 + AssemblyLinearVelocity * t1.value56.AimLeadTime
			end

			local v605 = v602 - CachedOrigin

			if v605.Magnitude > 0.001 then
				CachedDir = v605.Unit
			end
		end

		local value, t4, v608

		if CachedDir then
			if CachedDir then
				value = select("#", ...)

				if value < 2 then
					return nil
				else
					t4 = { ... }
					v608 = t4[2]

					if typeof(v608) == "Vector3" then
						t4[2] = CachedDir

						return t4, value
					else
						return nil
					end
				end
			else
				return nil
			end
		end

		local CachedOrigin2 = t1.value56.CachedOrigin
		local CachedTargetPos = t1.value56.CachedTargetPos

		if CachedOrigin2 and CachedTargetPos then
		elseif CachedDir then
			value = select("#", ...)

			if value < 2 then
				return nil
			else
				t4 = { ... }
				v608 = t4[2]

				if typeof(v608) == "Vector3" then
					t4[2] = CachedDir

					return t4, value
				else
					return nil
				end
			end
		else
			return nil
		end

		local v611 = CachedTargetPos - CachedOrigin2

		if v611.Magnitude > 0.001 then
		elseif CachedDir then
			value = select("#", ...)

			if value < 2 then
				return nil
			else
				t4 = { ... }
				v608 = t4[2]

				if typeof(v608) == "Vector3" then
					t4[2] = CachedDir

					return t4, value
				else
					return nil
				end
			end
		else
			return nil
		end

		CachedDir = v611.Unit

		if CachedDir then
			value = select("#", ...)

			if value < 2 then
				return nil
			else
				t4 = { ... }
				v608 = t4[2]

				if typeof(v608) == "Vector3" then
					t4[2] = CachedDir

					return t4, value
				else
					return nil
				end
			end
		else
			return nil
		end
	end

	local v612 = nil

	v612 = hookmetamethod(game, "__index", v590(function(p48, p49)
		local SilentAim = t1.value12.SilentAim

		if SilentAim then
			SilentAim = t1.value56.HasGun

			if SilentAim then
				SilentAim = t1.value56.CachedTargetPos
			end
		end

		if not SilentAim then
			return v612(p48, p49)
		end

		local v614 = p49 == "Hit" or (p49 == "Target" or ((p49 == "hit" or p49 == "target") and true or p49 == "UnitRay"))
		local CachedTargetPos, CachedOrigin

		if v614 then
		elseif v614 and v612(p48, "ClassName") == "Mouse" then
			CachedTargetPos = t1.value56.CachedTargetPos

			if p49 == "Hit" and true or p49 == "hit" then
				return CFrame.new(CachedTargetPos)
			elseif p49 == "UnitRay" then
				CachedOrigin = t1.value56.CachedOrigin or Vector3.zero

				return Ray.new(CachedOrigin, (CachedTargetPos - CachedOrigin).Unit * 5000)
			else
				return t1.value56.CachedTarget
			end
		else
			return v612(p48, p49)
		end

		v614 = typeof(p48) == "Instance"

		if v614 and v612(p48, "ClassName") == "Mouse" then
			CachedTargetPos = t1.value56.CachedTargetPos

			if p49 == "Hit" and true or p49 == "hit" then
				return CFrame.new(CachedTargetPos)
			elseif p49 == "UnitRay" then
				CachedOrigin = t1.value56.CachedOrigin or Vector3.zero

				return Ray.new(CachedOrigin, (CachedTargetPos - CachedOrigin).Unit * 5000)
			else
				return t1.value56.CachedTarget
			end
		else
			return v612(p48, p49)
		end
	end))

	local u617 = false

	local function v618(p50, p51, ...)
		if u617 then
			return p51(p50, ...)
		end

		local function v619(...)
			local SilentAim = t1.value12.SilentAim
			local v621, v622

			if SilentAim then
			elseif SilentAim then
				v621, v622 = v596(...)

				if v621 then
					return p51(p50, unpack(v621, 1, v622))
				else
					return p51(p50, ...)
				end
			else
				return p51(p50, ...)
			end

			SilentAim = v591(p50, v612)

			if SilentAim then
				v621, v622 = v596(...)

				if v621 then
					return p51(p50, unpack(v621, 1, v622))
				else
					return p51(p50, ...)
				end
			else
				return p51(p50, ...)
			end
		end

		local t5 = { pcall(v619, ...) }
		local v624 = t5[5]
		local v625 = t5[4]
		local v626 = t5[6]
		local v627 = t5[3]
		local v628 = t5[2]

		u617 = false

		if t5[1] then
			return v628, v627, v625, v624, v626
		else
			return p51(p50, ...)
		end
	end

	local v629 = nil

	v629 = hookmetamethod(game, "__namecall", v590(function(p52, ...)
		local v630 = getnamecallmethod()
		local v631 = v630 == "FireServer" and true or v630 == "fireServer"

		if v631 then
			v631 = not u617
		end

		if not v631 then
			return v629(p52, ...)
		end

		local function v632(...)
			local SilentAim = t1.value12.SilentAim

			if SilentAim then
				SilentAim = v591(p52, v612)
			end

			local setnamecallmethod_

			if SilentAim then
				local v635, v636 = v596(...)

				if v635 then
					local setnamecallmethod_2 = setnamecallmethod

					if typeof(setnamecallmethod_2) ~= "function" then
						return v629(p52, unpack(v635, 1, v636))
					end

					setnamecallmethod(v630)

					return v629(p52, unpack(v635, 1, v636))
				else
					setnamecallmethod_ = setnamecallmethod

					if typeof(setnamecallmethod_) ~= "function" then
						return v629(p52, ...)
					end

					setnamecallmethod(v630)

					return v629(p52, ...)
				end
			else
				setnamecallmethod_ = setnamecallmethod

				if typeof(setnamecallmethod_) ~= "function" then
					return v629(p52, ...)
				end

				setnamecallmethod(v630)

				return v629(p52, ...)
			end
		end

		local ok, result, result2, result3, result4, result5 = pcall(v632, ...)

		if ok then
			return result, result2, result3, result4, result5
		else
			return v629(p52, ...)
		end
	end))

	local hookfunction_ = hookfunction

	if typeof(hookfunction_) ~= "function" then
		return
	end

	pcall(function()
		local RemoteEvent = Instance.new("RemoteEvent")
		local v646 = nil
		local v647 = hookfunction(RemoteEvent.FireServer, v590(function(p53, ...)
			return v618(p53, v646, ...)
		end))
		local Destroy = RemoteEvent.Destroy

		v646 = v647
		Destroy(RemoteEvent)
	end)
end)
t1.value79 = {
	Connected = false,
	LastSync = 0,
	OverlayReady = false,
	LastError = nil,
	FallbackScheduled = false
}

function t1.value80()
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if syn_ then
		return syn_
	end

	syn_ = http

	if syn_ then
		syn_ = http.request
	end

	if syn_ then
		return syn_
	end

	syn_ = http_request

	if syn_ then
		return syn_
	end

	syn_ = not request and fluxus

	if not syn_ then
		return syn_
	end

	syn_ = fluxus.request

	return syn_
end
function t1.value81(p54)
	return p54 and p54.StatusCode or (p54.status_code or p54.Status)
end

local function v650(p55, p56, p57)
	local v651 = t1.value80()

	if not v651 then
		return false, nil
	end

	local StreamerPort = t1.value12.StreamerPort or 8765
	local t6 = {
		Url = "http://127.0.0.1:" .. tostring(StreamerPort) .. p56,
		Method = p55,
		Headers = {
			["Content-Type"] = "application/json"
		}
	}

	if p57 then
		t6.Body = p57
	end

	local ok, result = pcall(v651, t6)

	if not (ok and result) then
		return false, result
	end

	local v656 = t1.value81(result)

	if v656 then
		if v656 >= 200 then
			v656 = v656 < 300
		else
			v656 = false
		end
	end

	if v656 then
		return v656 == true, result
	end

	if type(result) == "table" then
		v656 = result.Success == true
	else
		v656 = false
	end

	return v656 == true, result
end

function t1.value82()
	task.spawn(function()
		v650("POST", "/clear")
	end)
end
function t1.value83()
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return nil
	end

	local Character = t1.value10.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
	else
		HumanoidRootPart = Character
	end

	if HumanoidRootPart then
		HumanoidRootPart = HumanoidRootPart.Position
	end

	local vector3 = HumanoidRootPart or Vector3.zero
	local t7 = {}

	local function v662(p58, p59)
		if not p58 or (not p58.Parent or p58 == Character) then
			return
		end

		local HumanoidRootPart2 = p58:FindFirstChild("HumanoidRootPart") or p58:FindFirstChild("Torso")

		if not HumanoidRootPart2 then
			return
		end

		local v664, v665 = CurrentCamera:WorldToViewportPoint(HumanoidRootPart2.Position)

		if v665 then
			v665 = v664.Z > 0
		end

		if not v665 then
			return
		end

		local v666 = CurrentCamera
		local Position = HumanoidRootPart2.Position
		local Vector3_ = Vector3
		local v669 = v666.WorldToViewportPoint(v666, Position + Vector3_.new(0, 3.2, 0))
		local v670 = CurrentCamera
		local v671 = HumanoidRootPart2.Position - Vector3.new(0, 3.2, 0)
		local v672 = v670.WorldToViewportPoint(v670, v671)
		local clamp = math.clamp
		local v674 = v672.Y - v669.Y
		local v675 = clamp(math.abs(v674), 16, 800)
		local math_ = math
		local v677 = v675 * 0.62
		local v678 = math_.floor((HumanoidRootPart2.Position - vector3).Magnitude)
		local v679 = t1.value19(p58, p59)
		local v680

		if v679 then
			v680 = t1.value21(p58, p59) or nil
		else
			v680 = nil
		end

		local DisplayName = p59 and p59.DisplayName or (p59.Name or p58.Name)

		if v680 then
			DisplayName = "[KILLER: " .. v680 .. "] " .. DisplayName
		end

		local insert = table.insert
		local v683 = t7
		local X = v664.X
		local v685 = math.floor(X)
		local Y = v664.Y

		insert(v683, {
			x = v685,
			y = math.floor(Y),
			w = math.floor(v677),
			h = math.floor(v675),
			dist = v678,
			name = DisplayName,
			is_killer = v679
		})
	end

	local v687, v688, v689 = ipairs(t1.value1:GetPlayers())

	while true do
		local v690

		v689, v690 = v687(v688, v689)

		if not v689 then
			break
		end

		local v691

		if v690 == t1.value10 then
			v691 = false
		else
			v691 = v690.Character
		end

		if v691 then
			v662(v690.Character, v690)
		end
	end

	local ipairs_ = ipairs
	local v693, v694, v695 = ipairs_(workspace:GetChildren())

	while true do
		local v696

		v695, v696 = v693(v694, v695)

		if not v695 then
			break
		end

		local isModel = v696:IsA("Model")

		if isModel then
			isModel = v696:FindFirstChild("Humanoid")

			if isModel then
				isModel = v696 ~= Character
			end
		end

		if isModel then
			ipairs_ = t1.value1

			local playerFromCharacter = ipairs_:GetPlayerFromCharacter(v696)

			if playerFromCharacter ~= t1.value10 then
				ipairs_ = v662(v696, playerFromCharacter)
			end
		end
	end

	local t8 = {}

	if t1.value12.GenESPEnabled then
		local v700 = t1.value28()

		for _, v in ipairs(v700) do
			if t1.value25(v) then
				local RootPart = v:FindFirstChild("RootPart") or (v:FindFirstChild("Gen Invis") or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")))

				if RootPart then
					local v704, v705 = CurrentCamera:WorldToViewportPoint(RootPart.Position)

					if v705 then
						v705 = v704.Z > 0
					end

					if v705 then
						local Magnitude = (RootPart.Position - vector3).Magnitude
						local v707 = math.floor(Magnitude)
						local v708 = t1.value26(v)
						local insert = table.insert
						local X = v704.X
						local v711 = math.floor(X)
						local Y = v704.Y

						insert(t8, {
							x = v711,
							y = math.floor(Y),
							pct = v708,
							dist = v707
						})
					end
				end
			end
		end
	end

	local v713 = nil

	if not t1.value12.ShowTracer then
		return {
			players = t7,
			gens = t8,
			tracer = v713,
			config = {
				AutoGreatZone = t1.value12.AutoGreatZone,
				ESPEnabled = t1.value12.ESPEnabled,
				SpeedEnabled = t1.value12.SpeedEnabled,
				SpeedValue = t1.value12.SpeedValue,
				NoclipEnabled = t1.value12.NoclipEnabled,
				AutoWiggle = t1.value12.AutoWiggle,
				AutoHeal = t1.value12.AutoHeal,
				NoFall = t1.value12.NoFall,
				AutoPallet = t1.value12.AutoPallet,
				FastVault = t1.value12.FastVault,
				GenESPEnabled = t1.value12.GenESPEnabled,
				FullbrightEnabled = t1.value12.FullbrightEnabled,
				AutoParry = t1.value12.AutoParry,
				ParryDistance = t1.value12.ParryDistance,
				SilentAim = t1.value12.SilentAim,
				ShowTracer = t1.value12.ShowTracer,
				AimTarget = t1.value12.AimTarget,
				StreamerMode = t1.value12.StreamerMode
			}
		}
	end

	local v714, v715, v716 = t1.value77()

	if v714 then
		v714 = v715 and v716
	end

	if not v714 then
		return {
			players = t7,
			gens = t8,
			tracer = v713,
			config = {
				AutoGreatZone = t1.value12.AutoGreatZone,
				ESPEnabled = t1.value12.ESPEnabled,
				SpeedEnabled = t1.value12.SpeedEnabled,
				SpeedValue = t1.value12.SpeedValue,
				NoclipEnabled = t1.value12.NoclipEnabled,
				AutoWiggle = t1.value12.AutoWiggle,
				AutoHeal = t1.value12.AutoHeal,
				NoFall = t1.value12.NoFall,
				AutoPallet = t1.value12.AutoPallet,
				FastVault = t1.value12.FastVault,
				GenESPEnabled = t1.value12.GenESPEnabled,
				FullbrightEnabled = t1.value12.FullbrightEnabled,
				AutoParry = t1.value12.AutoParry,
				ParryDistance = t1.value12.ParryDistance,
				SilentAim = t1.value12.SilentAim,
				ShowTracer = t1.value12.ShowTracer,
				AimTarget = t1.value12.AimTarget,
				StreamerMode = t1.value12.StreamerMode
			}
		}
	end

	local v717, v718 = CurrentCamera:WorldToViewportPoint(t1.value76() or v715)
	local v719, v720 = CurrentCamera:WorldToViewportPoint(v716)

	if not (v718 or v720) then
		return {
			players = t7,
			gens = t8,
			tracer = v713,
			config = {
				AutoGreatZone = t1.value12.AutoGreatZone,
				ESPEnabled = t1.value12.ESPEnabled,
				SpeedEnabled = t1.value12.SpeedEnabled,
				SpeedValue = t1.value12.SpeedValue,
				NoclipEnabled = t1.value12.NoclipEnabled,
				AutoWiggle = t1.value12.AutoWiggle,
				AutoHeal = t1.value12.AutoHeal,
				NoFall = t1.value12.NoFall,
				AutoPallet = t1.value12.AutoPallet,
				FastVault = t1.value12.FastVault,
				GenESPEnabled = t1.value12.GenESPEnabled,
				FullbrightEnabled = t1.value12.FullbrightEnabled,
				AutoParry = t1.value12.AutoParry,
				ParryDistance = t1.value12.ParryDistance,
				SilentAim = t1.value12.SilentAim,
				ShowTracer = t1.value12.ShowTracer,
				AimTarget = t1.value12.AimTarget,
				StreamerMode = t1.value12.StreamerMode
			}
		}
	end

	local TracerColor = t1.value12.TracerColor or Color3.fromRGB(255, 60, 80)
	local format = string.format
	local v723 = TracerColor.R * 255
	local v724 = math.floor(v723)
	local v725 = TracerColor.G * 255
	local v726 = math.floor(v725)
	local v727 = TracerColor.B * 255
	local v728 = format("#%02x%02x%02x", v724, v726, (math.floor(v727)))
	local X = v717.X
	local v730 = math.floor(X)
	local Y = v717.Y
	local v732 = math.floor(Y)
	local X2 = v719.X
	local v734 = math.floor(X2)
	local Y2 = v719.Y

	v713 = {
		visible = true,
		x1 = v730,
		y1 = v732,
		x2 = v734,
		y2 = math.floor(Y2),
		color = v728
	}

	return {
		players = t7,
		gens = t8,
		tracer = v713,
		config = {
			AutoGreatZone = t1.value12.AutoGreatZone,
			ESPEnabled = t1.value12.ESPEnabled,
			SpeedEnabled = t1.value12.SpeedEnabled,
			SpeedValue = t1.value12.SpeedValue,
			NoclipEnabled = t1.value12.NoclipEnabled,
			AutoWiggle = t1.value12.AutoWiggle,
			AutoHeal = t1.value12.AutoHeal,
			NoFall = t1.value12.NoFall,
			AutoPallet = t1.value12.AutoPallet,
			FastVault = t1.value12.FastVault,
			GenESPEnabled = t1.value12.GenESPEnabled,
			FullbrightEnabled = t1.value12.FullbrightEnabled,
			AutoParry = t1.value12.AutoParry,
			ParryDistance = t1.value12.ParryDistance,
			SilentAim = t1.value12.SilentAim,
			ShowTracer = t1.value12.ShowTracer,
			AimTarget = t1.value12.AimTarget,
			StreamerMode = t1.value12.StreamerMode
		}
	}
end
function t1.value84(p60)
	if not (not p60 or type(p60) ~= "table") then
		for k, v in pairs(p60) do
			if t1.value12[k] ~= nil then
				local v738 = t1.value12[k]

				t1.value12[k] = v

				if v738 ~= v then
					print(string.format("[SBB-DEBUG] Config Changed: %s -> %s", tostring(k), (tostring(v))))
				end

				local v739

				if k == "StreamerMode" then
					v739 = not v
				else
					v739 = false
				end

				if v739 then
					if t1.value9 then
						t1.value9(false)
					end
				else
					local v740

					if k == "FullbrightEnabled" then
						v740 = v738 ~= v
					else
						v740 = false
					end

					if v740 then
						if v then
							if t1.value46 then
								pcall(t1.value46)
							end
						elseif t1.value47 then
							pcall(t1.value47)
						end
					else
						local v741

						if k == "AutoGreatZone" then
							v741 = not v
						else
							v741 = false
						end

						if v741 then
							t1.value15.Active = false
							t1.value15.Fired = false
						else
							local v742

							if k == "NoclipEnabled" then
								v742 = not v
							else
								v742 = false
							end

							if v742 then
								if t1.value35 then
									pcall(t1.value35)
								end
							else
								local v743

								if k == "ESPEnabled" then
									v743 = v738 ~= v
								else
									v743 = false
								end

								if v743 then
									if not t1.value12.StreamerMode then
										if v then
											t1.value23()
										else
											v49()
										end
									end
								else
									local v744

									if k == "GenESPEnabled" then
										v744 = v738 ~= v
									else
										v744 = false
									end

									if v744 and not t1.value12.StreamerMode then
										if v then
											t1.value32()
										else
											t1.value30()
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
function t1.value85(p61)
	local SBB_Hub = t1.value16():FindFirstChild("SBB_Hub") or t1.value11:FindFirstChild("SBB_Hub")

	if not SBB_Hub then
		return
	end

	SBB_Hub.Enabled = p61

	local Main = SBB_Hub:FindFirstChild("Main")

	if Main then
		Main.Visible = p61
	end

	local SBB_MobileToggle = SBB_Hub:FindFirstChild("SBB_MobileToggle")

	if SBB_MobileToggle then
		SBB_MobileToggle.Visible = p61
	end

	if not p61 then
		return
	end

	t1.value12.UIVisible = true
end
function t1.value9(p62)
	t1.value12.StreamerMode = p62

	if not p62 then
		t1.value79.OverlayReady = false

		local value82 = t1.value82

		value82()

		if t1.value12.ESPEnabled then
			value82 = t1.value23
			value82()
		end

		if t1.value12.GenESPEnabled then
			value82 = t1.value32
			value82()
		end

		local value48 = t1.value48

		if value48 then
			value48 = t1.value48.ParryCircle

			if value48 then
				value48 = t1.value12.AutoParry
			end
		end

		if value48 then
			t1.value48.ParryCircle.Visible = true
		end

		t1.value85(true)

		return
	end

	if t1.value79.OverlayReady then
		v49()
		t1.value30()
		t1.value72(false)

		local value48 = t1.value48

		if value48 then
			value48 = t1.value48.ParryCircle
		end

		if not value48 then
			t1.value85(false)

			if closeWindow then
				pcall(closeWindow)

				return
			else
				return
			end
		end

		t1.value48.ParryCircle.Visible = false
		t1.value85(false)

		if closeWindow then
			pcall(closeWindow)

			return
		else
			return
		end
	end

	t1.value85(false)

	if t1.value79.FallbackScheduled then
		return
	end

	t1.value79.FallbackScheduled = true
	task.delay(3, function()
		t1.value79.FallbackScheduled = false

		local StreamerMode = t1.value12.StreamerMode

		if StreamerMode then
			StreamerMode = not t1.value79.OverlayReady
		end

		if not StreamerMode then
			return
		end

		t1.value85(true)
	end)
end
function _G.dumpStatus()
	print("========================================")
	print("      SBB HUB - SYSTEM STATUS DUMP      ")
	print("========================================")

	local print_ = print
	local StreamerMode = t1.value12.StreamerMode

	print_("[+] StreamerMode: " .. tostring(StreamerMode))

	local print_2 = print
	local AutoGreatZone = t1.value12.AutoGreatZone

	print_2("[+] AutoGreatZone: " .. tostring(AutoGreatZone))

	local print_3 = print
	local SpeedEnabled = t1.value12.SpeedEnabled
	local v758 = tostring(SpeedEnabled)
	local SpeedValue = t1.value12.SpeedValue

	print_3("[+] SpeedEnabled: " .. v758 .. " (Value: " .. tostring(SpeedValue) .. ")")

	local print_4 = print
	local NoclipEnabled = t1.value12.NoclipEnabled

	print_4("[+] NoclipEnabled: " .. tostring(NoclipEnabled))

	local print_5 = print
	local AutoWiggle = t1.value12.AutoWiggle

	print_5("[+] AutoWiggle: " .. tostring(AutoWiggle))

	local print_6 = print
	local AutoHeal = t1.value12.AutoHeal

	print_6("[+] AutoHeal: " .. tostring(AutoHeal))

	local print_7 = print
	local NoFall = t1.value12.NoFall

	print_7("[+] NoFall: " .. tostring(NoFall))

	local print_8 = print
	local AutoPallet = t1.value12.AutoPallet

	print_8("[+] AutoPallet: " .. tostring(AutoPallet))

	local print_9 = print
	local FastVault = t1.value12.FastVault

	print_9("[+] FastVault: " .. tostring(FastVault))

	local print_10 = print
	local GenESPEnabled = t1.value12.GenESPEnabled

	print_10("[+] GenESPEnabled: " .. tostring(GenESPEnabled))

	local print_11 = print
	local FullbrightEnabled = t1.value12.FullbrightEnabled

	print_11("[+] FullbrightEnabled: " .. tostring(FullbrightEnabled))

	local print_12 = print
	local AutoParry = t1.value12.AutoParry
	local v778 = tostring(AutoParry)
	local ParryDistance = t1.value12.ParryDistance

	print_12("[+] AutoParry: " .. v778 .. " (Dist: " .. tostring(ParryDistance) .. ")")

	local print_13 = print
	local SilentAim = t1.value12.SilentAim

	print_13("[+] SilentAim: " .. tostring(SilentAim))

	local print_14 = print
	local ShowTracer = t1.value12.ShowTracer

	print_14("[+] ShowTracer: " .. tostring(ShowTracer))

	local print_15 = print
	local Connected = t1.value79.Connected

	print_15("[+] Streamer Pipeline Connected: " .. tostring(Connected))
	print("========================================")
end
function _G.diagnoseVD()
	print("========================================")
	print("      SBB HUB - SYSTEM DIAGNOSTICS      ")
	print("========================================")

	local Character = t1.value10.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
	else
		HumanoidRootPart = Character
	end

	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	local print_ = print
	local v790

	if Character then
		v790 = "OK (" .. Character.Name .. ")"
	else
		v790 = Character
	end

	print_("[1] Character: " .. (v790 or "FAIL (Nil)"))
	print("[2] HumanoidRootPart: " .. (HumanoidRootPart and "OK" or HumanoidRootPart) or "FAIL (Nil)")

	local print_2 = print

	if Humanoid then
		local Health = Humanoid.Health

		Humanoid = "OK (HP: " .. tostring(Health) .. ")"
	end

	print_2("[3] Humanoid: " .. (Humanoid or "FAIL (Nil)"))

	local v793, Name = t1.value36()
	local print_3 = print

	if v793 then
		local s3 = "YES ("

		if Name then
			Name = Name.Name
		end

		v793 = s3 .. (Name or "Unknown") .. ")"
	end

	print_3("[4] Killer Detected: " .. (v793 or "NO KILLER FOUND (In Lobby / Not Spawned)"))

	local v797 = t1.value49()

	print("[5] Parrying Dagger Equipped: " .. (v797 and "YES" or v797 or "NO"))

	local v798 = t1.value67(Character)
	local print_4 = print

	if v798 then
		v798 = "YES (" .. v798.Name .. ")"
	end

	print_4("[6] Gun Equipped: " .. (v798 or "NO GUN IN HAND"))

	local v800, Name2 = t1.value57()
	local print_5 = print

	if v800 then
		local s4 = "LOCKED ON: "

		if Name2 then
			Name2 = Name2.Name
		end

		v800 = s4 .. (Name2 or v800.Name)
	end

	print_5("[7] Silent Aim Target: " .. v800 or "NO TARGET FOUND")

	local CurrentCamera = workspace.CurrentCamera
	local print_6 = print
	local v806

	if "[8] Camera: " .. CurrentCamera then
		local ViewportSize = CurrentCamera.ViewportSize

		v806 = "OK (" .. tostring(ViewportSize) .. ")" or "FAIL"
	else
		v806 = "FAIL"
	end

	print_6(v806)

	local print_7 = print
	local Connected = t1.value79.Connected

	if not Connected then
		print_7("[9] Streamer Connection: " .. (Connected or "DISCONNECTED / WAITING OVERLAY"))
		print("========================================")

		return
	end

	local StreamerPort = t1.value12.StreamerPort or 8765

	Connected = "CONNECTED (Port " .. tostring(StreamerPort) .. ")"
	print_7("[9] Streamer Connection: " .. (Connected or "DISCONNECTED / WAITING OVERLAY"))
	print("========================================")
end
function _G.scanInventory()
	print("========================================")
	print("       SBB HUB - INVENTORY SCANNER      ")
	print("========================================")

	local Character = t1.value10.Character

	print("[+] EquippedItem Attribute: " .. tostring(t1.value10:GetAttribute("EquippedItem")))
	print("[+] Items/Tools in Character:")

	if not Character then
		print("========================================")

		return
	end

	local GetChildren = Character.GetChildren

	for _, v in ipairs(GetChildren(Character)) do
		if v:IsA("Tool") or v:IsA("Model") then
			print(string.format("    - [%s] %s", v.ClassName, v.Name))
		end
	end

	print("========================================")
end
function _G.scanPlayers()
	print("========================================")
	print("        SBB HUB - PLAYERS SCANNER       ")
	print("========================================")

	local players = t1.value1:GetPlayers()

	print("Total Players in Server: " .. tostring(#players))

	local ipairs_ = ipairs

	for _, player in ipairs_(players) do
		local Team = player.Team

		if Team then
			Team = player.Team.Name
		end

		local v820 = Team or "No Team"
		local Character = player.Character
		local v822 = t1.value19(Character, player)

		ipairs_ = print

		local format = string.format
		local s5 = "• %s | Team: %s | Char: %s | isKiller: %s"
		local Name = player.Name

		if Character then
			Character = Character.Name
		end

		ipairs_(format(s5, Name, v820, Character or "Nil", (tostring(v822))))
	end

	print("========================================")
end

task.spawn(function()
	local v826 = false

	while true do
		repeat
			task.wait(t1.value12.StreamerMode and 0.033 or 0.25)
		until not v826

		local v827 = t1.value83()
		local v828 = t1.value80()

		if v827 and v828 then
			local function v829()
				return t1.value8:JSONEncode(v827)
			end

			local ok, result = pcall(v829)

			if ok and result then
				local u832 = true

				task.spawn(function()
					local pcall_ = pcall
					local v834 = v828
					local StreamerPort = t1.value12.StreamerPort or 8765
					local ok2, result2 = pcall_(v834, {
						Url = "http://127.0.0.1:" .. tostring(StreamerPort) .. "/sync",
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json"
						},
						Body = result
					})

					u832 = false

					local v838 = t1.value81(result2)
					local Body

					if result2 then
						Body = result2.Body or result2.body
					else
						Body = result2
					end

					if ok2 then
						if v838 then
							if v838 >= 200 then
								v838 = v838 < 300
							else
								v838 = false
							end
						end

						if v838 then
							result2 = v838
						elseif result2 then
							result2 = result2.Success
						end
					else
						result2 = ok2
					end

					if not (result2 and Body) then
						t1.value79.Connected = false
						t1.value79.LastError = "Overlay unavailable"

						if not t1.value79.OverlayReady then
							return
						end

						t1.value79.OverlayReady = false
						t1.value85(true)

						return
					end

					t1.value79.Connected = true
					t1.value79.LastSync = tick()
					t1.value79.LastError = nil

					local function v840()
						return t1.value8:JSONDecode(Body)
					end

					local ok3, result3 = pcall(v840)

					if ok3 then
						if result3 then
							ok3 = result3.updates
						else
							ok3 = result3
						end
					end

					if ok3 then
						t1.value84(result3.updates)
					end

					local StreamerMode = t1.value12.StreamerMode

					if not StreamerMode then
						if StreamerMode then
							t1.value79.OverlayReady = true
							t1.value9(true)
						end

						return
					end

					StreamerMode = not t1.value79.OverlayReady

					if StreamerMode then
						t1.value79.OverlayReady = true
						t1.value9(true)
					end
				end)
				v826 = u832
			end
		end
	end
end);
(function()
	local UIStroke = t1.value16()
	local t9 = {}
	local t10 = {}

	local function v847(p63)
		local Crimson = t1.value13[p63] or t1.value13.Crimson

		for k, v in pairs(Crimson) do
			t9[k] = v
		end
	end

	v847(t1.value12.UITheme or "Crimson")

	local function v851(p64, p65, p66)
		p64[p65] = t9[p66]

		local function v852()
			local Parent = p64

			if Parent then
				Parent = p64.Parent
			end

			if not Parent then
				return
			end

			p64[p65] = t9[p66]
		end

		local v854 = t10

		table.insert(v854, v852)
	end
	local function v855(p67)
		if t1.value13[p67] then
			t1.value12.UITheme = p67
			v847(p67)

			for _, v in ipairs(t10) do
				pcall(v)
			end
		end
	end

	local SBB_Hub = UIStroke:FindFirstChild("SBB_Hub") or t1.value11:FindFirstChild("SBB_Hub")

	if SBB_Hub then
		SBB_Hub:Destroy()
	end

	SBB_Hub = Instance.new("ScreenGui")
	SBB_Hub.Name = "SBB_Hub"
	SBB_Hub.ResetOnSpawn = false
	SBB_Hub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SBB_Hub.DisplayOrder = 2147483647
	SBB_Hub.IgnoreGuiInset = true
	SBB_Hub.Parent = UIStroke

	local uDim2 = UDim2.new(0, 700, 0, 500)
	local uDim22 = UDim2.new(0.05, 0, 0.16, 0)
	local u861 = false
	local u862 = false
	local Frame = Instance.new("Frame")

	Frame.Name = "Main"
	Frame.Size = uDim2
	Frame.Position = uDim22
	Frame.BackgroundColor3 = t9.Bg
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.ClipsDescendants = true
	Frame.ZIndex = 100
	Frame.Parent = SBB_Hub
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
	UIStroke = Instance.new("UIStroke", Frame)
	UIStroke.Thickness = 1.4
	v851(UIStroke, "Color", "WindowStroke")
	v851(Frame, "BackgroundColor3", "Bg")

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Header"
	Frame2.Size = UDim2.new(1, 0, 0, 48)
	Frame2.BackgroundColor3 = t9.Header
	Frame2.BorderSizePixel = 0
	Frame2.Active = true
	Frame2.ZIndex = 101
	Frame2.Parent = Frame
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 14)
	v851(Frame2, "BackgroundColor3", "Header")
	UIStroke = Instance.new("Frame")
	UIStroke.Size = UDim2.new(1, 0, 0, 1)
	UIStroke.Position = UDim2.new(0, 0, 1, -1)
	UIStroke.BackgroundColor3 = t9.HeaderLine
	UIStroke.BorderSizePixel = 0
	UIStroke.ZIndex = 102
	UIStroke.Parent = Frame2
	v851(UIStroke, "BackgroundColor3", "HeaderLine")

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0, 76, 1, 0)
	Frame3.Position = UDim2.new(0, 14, 0, 0)
	Frame3.BackgroundTransparency = 1
	Frame3.ZIndex = 103
	Frame3.Parent = Frame2
	UIStroke = function(p68, p69, p70, p71, p72)
		local TextButton = Instance.new("TextButton")

		TextButton.Size = UDim2.new(0, 13, 0, 13)
		TextButton.Position = UDim2.new(0, p71, 0.5, -6.5)
		TextButton.BackgroundColor3 = p68
		TextButton.Text = ""
		TextButton.Font = Enum.Font.GothamBold
		TextButton.TextSize = 9
		TextButton.TextColor3 = Color3.fromRGB(40, 10, 10)
		TextButton.AutoButtonColor = false
		TextButton.ZIndex = 104
		TextButton.Parent = Frame3
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)

		local UIStroke2 = Instance.new("UIStroke", TextButton)
		local Color3_ = Color3

		UIStroke2.Color = p68.Lerp(p68, Color3_.fromRGB(0, 0, 0), 0.3)
		UIStroke2.Thickness = 0.8
		TextButton.MouseEnter:Connect(function()
			TextButton.Text = p70

			local value4 = t1.value4
			local v870 = TextButton
			local TweenInfo_ = TweenInfo
			local t11 = {
				BackgroundColor3 = p69
			}

			value4.Create(value4, v870, TweenInfo_.new(0.15), t11):Play()
		end)
		TextButton.MouseLeave:Connect(function()
			TextButton.Text = ""

			local value4 = t1.value4
			local v874 = TextButton
			local TweenInfo_ = TweenInfo
			local t12 = {
				BackgroundColor3 = p68
			}

			value4.Create(value4, v874, TweenInfo_.new(0.15), t12):Play()
		end)
		TextButton.MouseButton1Click:Connect(p72)

		return TextButton
	end

	local v877 = nil
	local v878 = nil
	local v879 = nil
	local v880 = UIStroke(Color3.fromRGB(255, 95, 86), Color3.fromRGB(255, 125, 115), "✕", 0, function()
		v877()
	end)
	local v881 = UIStroke(Color3.fromRGB(255, 189, 46), Color3.fromRGB(255, 215, 85), "−", 22, function()
		v878()
	end)
	local v882 = UIStroke(Color3.fromRGB(39, 201, 63), Color3.fromRGB(75, 230, 100), "⤢", 44, function()
		v879()
	end)

	UIStroke = Instance.new("TextLabel")
	UIStroke.Text = "sixbabyboy"
	UIStroke.Font = Enum.Font.GothamBold
	UIStroke.TextSize = 16
	UIStroke.TextColor3 = t9.Accent
	UIStroke.Size = UDim2.new(0, 110, 1, 0)
	UIStroke.Position = UDim2.new(0, 96, 0, 0)
	UIStroke.TextXAlignment = Enum.TextXAlignment.Left
	UIStroke.BackgroundTransparency = 1
	UIStroke.Active = false
	UIStroke.ZIndex = 102
	UIStroke.Parent = Frame2
	v851(UIStroke, "TextColor3", "Accent")
	UIStroke = Instance.new("TextLabel")
	UIStroke.Text = "Violence District"
	UIStroke.Font = Enum.Font.GothamMedium
	UIStroke.TextSize = 11
	UIStroke.TextColor3 = Color3.fromRGB(160, 140, 155)
	UIStroke.Size = UDim2.new(0, 180, 1, 0)
	UIStroke.Position = UDim2.new(0, 185, 0, 0)
	UIStroke.TextXAlignment = Enum.TextXAlignment.Left
	UIStroke.BackgroundTransparency = 1
	UIStroke.Active = false
	UIStroke.ZIndex = 102
	UIStroke.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "Sidebar"
	Frame4.Size = UDim2.new(0, 168, 1, -56)
	Frame4.Position = UDim2.new(0, 8, 0, 52)
	Frame4.BackgroundColor3 = t9.Sidebar
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 101
	Frame4.Parent = Frame
	Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 10)
	v851(Frame4, "BackgroundColor3", "Sidebar")
	UIStroke = Instance.new("UIListLayout", Frame4)
	UIStroke.Padding = UDim.new(0, 4)
	UIStroke.SortOrder = Enum.SortOrder.LayoutOrder
	UIStroke.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIStroke = Instance.new("UIPadding")
	UIStroke.PaddingTop = UDim.new(0, 8)
	UIStroke.PaddingBottom = UDim.new(0, 100)
	UIStroke.Parent = Frame4

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "Content"
	Frame5.Size = UDim2.new(1, -192, 1, -56)
	Frame5.Position = UDim2.new(0, 184, 0, 52)
	Frame5.BackgroundColor3 = t9.Sidebar
	Frame5.BorderSizePixel = 0
	Frame5.ZIndex = 101
	Frame5.Parent = Frame
	Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 10)
	v851(Frame5, "BackgroundColor3", "Sidebar")

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(0, 60, 0, 2.5)
	Frame6.Position = UDim2.new(0, 14, 0, 24)
	Frame6.BackgroundColor3 = t9.Accent
	Frame6.BorderSizePixel = 0
	Frame6.ZIndex = 103
	Frame6.Parent = Frame5
	Instance.new("UICorner", Frame6).CornerRadius = UDim.new(1, 0)
	v851(Frame6, "BackgroundColor3", "Accent")
	task.spawn(function()
		while true do
			local value4 = t1.value4
			local v887 = Frame6
			local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t13 = {
				BackgroundTransparency = 0.45,
				Size = UDim2.new(0, 72, 0, 2.5)
			}

			value4.Create(value4, v887, tweenInfo, t13):Play()
			task.wait(1.2)

			local value42 = t1.value4
			local v891 = Frame6
			local tweenInfo2 = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t14 = {
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 56, 0, 2.5)
			}

			value42.Create(value42, v891, tweenInfo2, t14):Play()
			task.wait(1.2)
		end
	end)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Text = "Main"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 15
	TextLabel.TextColor3 = t9.Text
	TextLabel.Size = UDim2.new(0, 120, 0, 28)
	TextLabel.Position = UDim2.new(1, -134, 0, 8)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel.BackgroundTransparency = 1
	TextLabel.ZIndex = 103
	TextLabel.Parent = Frame5

	local t15 = {}
	local t16 = {}
	local s6 = "Main"

	UIStroke = function(p73)
		local ScrollingFrame = Instance.new("ScrollingFrame")

		ScrollingFrame.Name = p73 .. "Page"
		ScrollingFrame.Size = UDim2.new(1, -20, 1, -44)
		ScrollingFrame.Position = UDim2.new(0, 10, 0, 38)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ScrollBarThickness = 3
		ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 25, 40)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollingFrame.Visible = p73 == "Main"
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.Parent = Frame5

		local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		t16[p73] = ScrollingFrame

		return ScrollingFrame
	end

	local Main = UIStroke("Main")
	local Movement = UIStroke("Movement")
	local Combat = UIStroke("Combat")
	local Survival = UIStroke("Survival")
	local Visuals = UIStroke("Visuals")

	UIStroke = UIStroke("Settings")

	local function v905(p74)
		local v906, v907, v908 = pairs(t16)

		while true do
			local v909

			v908, v909 = v906(v907, v908)

			if not v908 then
				break
			end

			if v908 == p74 then
				v909.Visible = true
				v909.Position = UDim2.new(0, 16, 0, 38)

				local value4 = t1.value4
				local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				local UDim2_ = UDim2

				value4.Create(value4, v909, tweenInfo, {
					Position = UDim2_.new(0, 10, 0, 38)
				}):Play()
			else
				v909.Visible = false
			end
		end

		for k, v in pairs(t15) do
			local v915 = k == p74
			local Indicator = v:FindFirstChild("Indicator")
			local value4

			if Indicator then
				value4 = t1.value4

				local tweenInfo = TweenInfo.new(0.2)
				local s7 = "BackgroundTransparency"
				local n1 = 1
				local n2 = 0

				if v915 then
					n1 = n2 or n1
				end

				local s8 = "Size"
				local uDim23

				if v915 then
					uDim23 = UDim2.new(0, 3, 0, 16)
				else
					uDim23 = v915
				end

				value4:Create(Indicator, tweenInfo, {
					[s7] = n1,
					[s8] = uDim23 or UDim2.new(0, 3, 0, 6)
				}):Play()
			else
				value4 = Indicator
			end

			local TabLabel = v:FindFirstChild("TabLabel")

			if TabLabel then
				local value42 = t1.value4
				local tweenInfo = TweenInfo.new(0.2)
				local s9 = "TextColor3"
				local Accent

				if v915 then
					Accent = t9.Accent
				else
					Accent = v915
				end

				local TextMuted = Accent or t9.TextMuted

				value42.Create(value42, TabLabel, tweenInfo, {
					[s9] = TextMuted
				}):Play()
			end

			local value42 = t1.value4
			local tweenInfo = TweenInfo.new(0.2)
			local s10 = "BackgroundColor3"

			if v915 then
				v915 = t9.TabOn
			end

			value42:Create(v, tweenInfo, {
				[s10] = v915 or t9.TabOff
			}):Play()

			if Indicator then
				Indicator.BackgroundColor3 = t9.Accent
			end
		end

		TextLabel.Text = p74
		s6 = p74
	end
	local function createTextButton(p75, p76)
		local TextButton = Instance.new("TextButton")

		TextButton.Name = p75 .. "Tab"
		TextButton.Size = UDim2.new(0.92, 0, 0, 40)

		local textColor3 = p75 == "Main"
		local TabOn

		if textColor3 then
			TabOn = t9.TabOn
		else
			TabOn = textColor3
		end

		TextButton.BackgroundColor3 = TabOn or t9.TabOff
		TextButton.Text = ""
		TextButton.AutoButtonColor = false
		TextButton.LayoutOrder = p76
		TextButton.ZIndex = 102
		TextButton.Parent = Frame4
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

		local Frame7 = Instance.new("Frame")

		Frame7.Name = "Indicator"

		local uDim23

		if textColor3 then
			uDim23 = UDim2.new(0, 3, 0, 18)
		else
			uDim23 = textColor3
		end

		Frame7.Size = uDim23 or UDim2.new(0, 3, 0, 6)
		Frame7.Position = UDim2.new(0, 6, 0.5, -9)
		Frame7.BackgroundColor3 = t9.Accent
		Frame7.BorderSizePixel = 0
		Frame7.BackgroundTransparency = textColor3 and 0 or 1
		Frame7.ZIndex = 104
		Frame7.Parent = TextButton
		Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Name = "TabLabel"
		TextLabel2.Size = UDim2.new(1, -22, 1, 0)
		TextLabel2.Position = UDim2.new(0, 18, 0, 0)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 13

		if textColor3 then
			textColor3 = t9.Accent
		end

		TextLabel2.TextColor3 = textColor3 or t9.TextMuted
		TextLabel2.Text = p75
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Active = false
		TextLabel2.ZIndex = 103
		TextLabel2.Parent = TextButton
		t15[p75] = TextButton

		local function v940()
			if not TextButton.Parent then
				return
			end

			local v941 = s6 == p75

			TextButton.BackgroundColor3 = v941 and t9.TabOn or t9.TabOff
			Frame7.BackgroundColor3 = t9.Accent

			local v942 = TextLabel2
			local s11 = "TextColor3"

			if not v941 then
				v942[s11] = v941 or t9.TextMuted

				return
			end

			v941 = t9.Accent
			v942[s11] = v941 or t9.TextMuted
		end

		table.insert(t10, v940)
		TextButton.MouseButton1Click:Connect(function()
			v905(p75)
		end)

		return TextButton
	end

	createTextButton("Main", 1)
	createTextButton("Movement", 2)
	createTextButton("Combat", 3)
	createTextButton("Survival", 4)
	createTextButton("Visuals", 5)
	createTextButton("Settings", 6)

	local Frame7 = Instance.new("Frame")

	Frame7.Name = "ProfileCard"
	Frame7.Size = UDim2.new(0.92, 0, 0, 86)
	Frame7.Position = UDim2.new(0.5, 0, 1, -10)
	Frame7.AnchorPoint = Vector2.new(0.5, 1)
	Frame7.BackgroundColor3 = t9.Card
	Frame7.BorderSizePixel = 0
	Frame7.ZIndex = 103
	Frame7.Parent = Frame4
	Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 12)
	createTextButton = Instance.new("UIStroke", Frame7)
	createTextButton.Thickness = 1
	v851(Frame7, "BackgroundColor3", "Card")
	v851(createTextButton, "Color", "Stroke")
	Frame7.MouseEnter:Connect(function()
		local value4 = t1.value4
		local v946 = Frame7
		local tweenInfo = TweenInfo.new(0.18)

		value4.Create(value4, v946, tweenInfo, {
			BackgroundColor3 = t9.CardHover
		}):Play()
	end)
	Frame7.MouseLeave:Connect(function()
		local value4 = t1.value4
		local v949 = Frame7
		local tweenInfo = TweenInfo.new(0.18)
		local t17 = {
			BackgroundColor3 = t9.Card
		}

		value4.Create(value4, v949, tweenInfo, t17):Play()
	end)
	createTextButton = Instance.new("Frame")
	createTextButton.Size = UDim2.new(1, -16, 0, 1)
	createTextButton.Position = UDim2.new(0, 8, 0, 54)
	createTextButton.BorderSizePixel = 0
	createTextButton.BackgroundTransparency = 0.55
	createTextButton.ZIndex = 104
	createTextButton.Parent = Frame7
	v851(createTextButton, "BackgroundColor3", "Stroke")
	createTextButton = Instance.new("Frame")
	createTextButton.Size = UDim2.new(0, 40, 0, 40)
	createTextButton.Position = UDim2.new(0, 10, 0, 8)
	createTextButton.BackgroundColor3 = t9.Accent
	createTextButton.BorderSizePixel = 0
	createTextButton.ZIndex = 104
	createTextButton.Parent = Frame7
	Instance.new("UICorner", createTextButton).CornerRadius = UDim.new(1, 0)
	v851(createTextButton, "BackgroundColor3", "Accent")

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "Avatar"
	ImageLabel.Size = UDim2.new(1, -2, 1, -2)
	ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.BackgroundColor3 = t9.Header
	ImageLabel.BorderSizePixel = 0
	ImageLabel.ScaleType = Enum.ScaleType.Crop
	ImageLabel.ZIndex = 105
	ImageLabel.Parent = createTextButton
	Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
	v851(ImageLabel, "BackgroundColor3", "Header")
	task.spawn(function()
		for _ = 1, 8 do
			local function v954()
				return t1.value1:GetUserThumbnailAsync(t1.value10.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			end

			local ok, image = pcall(v954)

			if ok then
				if typeof(image) == "string" then
					ok = image ~= ""
				else
					ok = false
				end
			end

			if ok then
				ImageLabel.Image = image

				return
			end

			task.wait(1.5)
		end
	end)
	createTextButton = t1.value10.DisplayName

	local v957

	if not createTextButton or createTextButton == "" then
		createTextButton = t1.value10.Name
		v957 = createTextButton
	else
		v957 = createTextButton
	end

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -58, 0, 16)
	TextLabel2.Position = UDim2.new(0, 56, 0, 10)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 13
	TextLabel2.TextColor3 = t9.Text
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel2.Text = createTextButton
	TextLabel2.ZIndex = 105
	TextLabel2.Parent = Frame7
	v851(TextLabel2, "TextColor3", "Text")
	TextLabel2 = Instance.new("TextLabel")
	TextLabel2.Size = UDim2.new(1, -58, 0, 14)
	TextLabel2.Position = UDim2.new(0, 56, 0, 28)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 11
	TextLabel2.TextColor3 = t9.TextMuted
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel2.Text = "@" .. t1.value10.Name
	TextLabel2.ZIndex = 105
	TextLabel2.Parent = Frame7
	v851(TextLabel2, "TextColor3", "TextMuted")

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 7, 0, 7)
	Frame8.Position = UDim2.new(0, 12, 1, -18)
	Frame8.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	Frame8.BorderSizePixel = 0
	Frame8.ZIndex = 106
	Frame8.Parent = Frame7
	Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -28, 0, 16)
	TextLabel3.Position = UDim2.new(0, 24, 1, -22)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 11
	TextLabel3.TextColor3 = t9.TextMuted
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Text = "Online  ·  00:00"
	TextLabel3.ZIndex = 106
	TextLabel3.Parent = Frame7
	v851(TextLabel3, "TextColor3", "TextMuted")

	local function v961(p77)
		local v962 = math.floor(p77)
		local v963 = math.max(0, v962)
		local v964 = v963 / 3600
		local v965 = math.floor(v964)
		local v966 = v963 % 3600 / 60
		local v967 = math.floor(v966)
		local v968 = v963 % 60

		if v965 > 0 then
			return string.format("%d:%02d:%02d", v965, v967, v968)
		else
			return string.format("%02d:%02d", v967, v968)
		end
	end

	task.spawn(function()
		local v969 = true

		while Frame7.Parent do
			TextLabel3.Text = "Online  ·  " .. v961(tick() - t1.value14)

			local value4 = t1.value4
			local v971 = Frame8
			local tweenInfo = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

			value4.Create(value4, v971, tweenInfo, {
				BackgroundTransparency = v969 and 0.45 or 0
			}):Play()
			task.wait(1)
			v969 = not v969
		end
	end)

	local t18 = {}

	TextLabel2 = function(p78, p79, p80, p81, p82, p83)
		local TextButton = Instance.new("TextButton")

		TextButton.Size = UDim2.new(1, -4, 0, p80 and 64 or 54)

		local CardOn

		if p81 then
			CardOn = t9.CardOn
		else
			CardOn = p81
		end

		TextButton.BackgroundColor3 = CardOn or t9.Card
		TextButton.AutoButtonColor = false
		TextButton.Text = ""
		TextButton.ZIndex = 103
		TextButton.LayoutOrder = p83 or 1
		TextButton.Parent = p78
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

		local UIStroke2 = Instance.new("UIStroke", TextButton)
		local StrokeOn

		if p81 then
			StrokeOn = t9.StrokeOn
		else
			StrokeOn = p81
		end

		UIStroke2.Color = StrokeOn or t9.Stroke
		UIStroke2.Thickness = 1.2

		local Frame9 = Instance.new("Frame")

		Frame9.Size = UDim2.new(0, 24, 0, 24)
		Frame9.Position = UDim2.new(0, 14, 0.5, -12)

		local AccentDim

		if p81 then
			AccentDim = t9.AccentDim
		else
			AccentDim = p81
		end

		Frame9.BackgroundColor3 = AccentDim or t9.BoxOff
		Frame9.BorderSizePixel = 0
		Frame9.ZIndex = 104
		Frame9.Parent = TextButton
		Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 6)

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Text = p81 and "✓" or ""
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextSize = 16
		TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel4.Size = UDim2.new(1, 0, 1, 0)
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.Active = false
		TextLabel4.ZIndex = 105
		TextLabel4.Parent = Frame9

		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Text = p79
		TextLabel5.Font = Enum.Font.GothamBold
		TextLabel5.TextSize = 15
		TextLabel5.TextColor3 = t9.Text
		TextLabel5.Size = UDim2.new(1, -54, 0, 22)
		TextLabel5.Position = UDim2.new(0, 48, p80 and 0.14 or 0.5, p80 and 0 or -11)
		TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel5.BackgroundTransparency = 1
		TextLabel5.Active = false
		TextLabel5.ZIndex = 104
		TextLabel5.Parent = TextButton

		if p80 then
			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Text = p80
			TextLabel6.Font = Enum.Font.Gotham
			TextLabel6.TextSize = 12
			TextLabel6.TextColor3 = t9.TextMuted
			TextLabel6.Size = UDim2.new(1, -54, 0, 18)
			TextLabel6.Position = UDim2.new(0, 48, 0.54, 0)
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Active = false
			TextLabel6.ZIndex = 104
			TextLabel6.Parent = TextButton
		end

		local u983 = p81

		local function v984()
			TextLabel4.Text = u983 and "✓" or ""
			Frame9.Size = UDim2.new(0, 20, 0, 20)
			Frame9.Position = UDim2.new(0, 16, 0.5, -10)

			local value4 = t1.value4
			local v986 = Frame9
			local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local uDim23 = UDim2.new(0, 24, 0, 24)
			local uDim24 = UDim2.new(0, 14, 0.5, -12)
			local AccentDim2 = u983

			if AccentDim2 then
				AccentDim2 = t9.AccentDim
			end

			value4:Create(v986, tweenInfo, {
				Size = uDim23,
				Position = uDim24,
				BackgroundColor3 = AccentDim2 or t9.BoxOff
			}):Play()

			local value42 = t1.value4
			local v992 = UIStroke2
			local tweenInfo2 = TweenInfo.new(0.18)
			local StrokeOn2 = u983

			if StrokeOn2 then
				StrokeOn2 = t9.StrokeOn
			end

			local Stroke = StrokeOn2 or t9.Stroke

			value42.Create(value42, v992, tweenInfo2, {
				Color = Stroke
			}):Play()

			local value43 = t1.value4
			local v997 = TextButton
			local tweenInfo3 = TweenInfo.new(0.12)
			local CardOn2 = u983

			if not CardOn2 then
				value43:Create(v997, tweenInfo3, {
					BackgroundColor3 = CardOn2 or t9.Card
				}):Play()

				return
			end

			CardOn2 = t9.CardOn
			value43:Create(v997, tweenInfo3, {
				BackgroundColor3 = CardOn2 or t9.Card
			}):Play()
		end

		TextButton.MouseEnter:Connect(function()
			t1.value4:Create(TextButton, TweenInfo.new(0.15), {
				BackgroundColor3 = t9.CardHover
			}):Play()
		end)
		TextButton.MouseLeave:Connect(function()
			local value4 = t1.value4
			local v1001 = TextButton
			local tweenInfo = TweenInfo.new(0.15)
			local CardOn2 = u983

			if not CardOn2 then
				value4:Create(v1001, tweenInfo, {
					BackgroundColor3 = CardOn2 or t9.Card
				}):Play()

				return
			end

			CardOn2 = t9.CardOn
			value4:Create(v1001, tweenInfo, {
				BackgroundColor3 = CardOn2 or t9.Card
			}):Play()
		end)

		local function v1004(p84)
			if p84 == nil then
				u983 = not u983
			else
				u983 = p84
			end

			v984()

			if not p82 then
				task.wait(0.25)

				return
			end

			p82(u983)
			task.wait(0.25)
		end

		TextButton.MouseButton1Click:Connect(function()
			v1004()
		end)
		table.insert(t10, function()
			if not TextButton.Parent then
				return
			end

			TextLabel5.TextColor3 = t9.Text

			local v1005 = UIStroke2
			local s12 = "Color"
			local StrokeOn2 = u983

			if StrokeOn2 then
				StrokeOn2 = t9.StrokeOn
			end

			v1005[s12] = StrokeOn2 or t9.Stroke

			local v1008 = TextButton
			local s13 = "BackgroundColor3"
			local CardOn2 = u983

			if CardOn2 then
				CardOn2 = t9.CardOn
			end

			v1008[s13] = CardOn2 or t9.Card

			local v1011 = Frame9
			local s14 = "BackgroundColor3"
			local AccentDim2 = u983

			if not AccentDim2 then
				v1011[s14] = AccentDim2 or t9.BoxOff

				return
			end

			AccentDim2 = t9.AccentDim
			v1011[s14] = AccentDim2 or t9.BoxOff
		end)

		local t19 = {
			row = TextButton,
			toggle = v1004,
			get = function()
				return u983
			end
		}

		table.insert(t18, t19)

		return t19
	end

	local t20 = {}

	createTextButton = function(p85, p86, p87, p88, p89, p90, p91, p92, p93, p94)
		local Frame9 = Instance.new("Frame")

		Frame9.Name = "SliderContainer"
		Frame9.Size = UDim2.new(1, 0, 0, 72)
		Frame9.BackgroundTransparency = 1
		Frame9.LayoutOrder = p92 or 1
		Frame9.Parent = p85

		local Frame10 = Instance.new("Frame")

		Frame10.Name = "SliderRow"
		Frame10.Size = UDim2.new(1, -8, 1, 0)
		Frame10.Position = UDim2.new(0, 1, 0, 0)
		Frame10.BackgroundColor3 = t9.Card
		Frame10.BorderSizePixel = 0
		Frame10.ZIndex = 103
		Frame10.Parent = Frame9
		Instance.new("UICorner", Frame10).CornerRadius = UDim.new(0, 8)

		local UIStroke2 = Instance.new("UIStroke", Frame10)

		UIStroke2.Color = t9.Stroke
		UIStroke2.Thickness = 1.2

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Text = p86
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextSize = 14
		TextLabel4.TextColor3 = t9.Text
		TextLabel4.Size = UDim2.new(1, -95, 0, 16)
		TextLabel4.Position = UDim2.new(0, 12, 0, 6)
		TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.ZIndex = 104
		TextLabel4.Parent = Frame10

		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Font = Enum.Font.GothamBold
		TextLabel5.TextSize = 14
		TextLabel5.TextColor3 = t9.Accent
		TextLabel5.Size = UDim2.new(0, 75, 0, 16)
		TextLabel5.Position = UDim2.new(1, -87, 0, 6)
		TextLabel5.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel5.BackgroundTransparency = 1
		TextLabel5.ZIndex = 104
		TextLabel5.Parent = Frame10

		local TextLabel6 = Instance.new("TextLabel")

		TextLabel6.Font = Enum.Font.Gotham
		TextLabel6.TextSize = 12
		TextLabel6.TextColor3 = t9.TextMuted
		TextLabel6.Size = UDim2.new(1, -24, 0, 15)
		TextLabel6.Position = UDim2.new(0, 12, 0, 26)
		TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel6.BackgroundTransparency = 1
		TextLabel6.ZIndex = 104
		TextLabel6.Parent = Frame10

		local Frame11 = Instance.new("Frame")

		Frame11.Name = "SliderTrack"
		Frame11.Size = UDim2.new(1, -24, 0, 6)
		Frame11.Position = UDim2.new(0, 16, 0, 52)
		Frame11.BackgroundColor3 = t9.Track
		Frame11.BorderSizePixel = 0
		Frame11.ZIndex = 104
		Frame11.Parent = Frame10
		Instance.new("UICorner", Frame11).CornerRadius = UDim.new(1, 0)

		local Frame12 = Instance.new("Frame")

		Frame12.Name = "SliderFill"
		Frame12.BackgroundColor3 = t9.AccentDim
		Frame12.BorderSizePixel = 0
		Frame12.ZIndex = 105
		Frame12.Parent = Frame11
		Instance.new("UICorner", Frame12).CornerRadius = UDim.new(1, 0)

		local Frame13 = Instance.new("Frame")

		Frame13.Name = "SliderKnob"
		Frame13.Size = UDim2.new(0, 14, 0, 14)
		Frame13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame13.BorderSizePixel = 0
		Frame13.ZIndex = 106
		Frame13.Parent = Frame11
		Instance.new("UICorner", Frame13).CornerRadius = UDim.new(1, 0)

		local UIStroke3 = Instance.new("UIStroke", Frame13)

		UIStroke3.Color = Color3.fromRGB(200, 200, 210)
		UIStroke3.Thickness = 1

		local Frame14 = Instance.new("Frame")

		Frame14.Size = UDim2.new(0, 20, 0, 20)
		Frame14.Position = UDim2.new(0.5, -10, 0.5, -10)
		Frame14.BackgroundColor3 = t9.Accent
		Frame14.BackgroundTransparency = 0.85
		Frame14.BorderSizePixel = 0
		Frame14.ZIndex = 105
		Frame14.Parent = Frame13
		Instance.new("UICorner", Frame14).CornerRadius = UDim.new(1, 0)

		local u1027 = math.clamp(p90, p88, p89)
		local u1028 = false
		local u1029 = false

		local function v1030(p95)
			return not p93 and (p95 <= 16 and (p87 or "ความเร็วปกติ (Default 16)") or (p95 <= 22 and "Ghost Walk — เนียนตาสุดๆ ฆาตกรดูไม่ออก" or (p95 <= 28 and "Balanced Boost — วิ่งฉีกระยะพอดีๆ ปลอดภัยและเนียนตา (แนะนำ)" or (p95 <= 45 and "Fast Runner — ฉีกระยะห่างจากฆาตกรสบาย" or (p95 <= 70 and "Sonic Rush — สปีดสูง วิ่งข้ามแมพในพริบตา" or "Flash God — ความเร็วสูงสุด (100 spd)!"))))) or p93(p95)
		end
		local function v1031(p96, p97)
			if not p97 then
				local v1032 = (p96 - p88) / (p89 - p88)

				p97 = math.clamp(v1032, 0, 1)
			end

			Frame12.Size = UDim2.new(p97, 0, 1, 0)
			Frame13.Position = UDim2.new(p97, -7, 0.5, -7)
			TextLabel5.Text = tostring(p96) .. (p94 or " spd")
			TextLabel6.Text = v1030(p96)

			local v1033 = p96 > 28

			if v1033 == nil then
				return
			end

			local value4 = t1.value4
			local v1035 = UIStroke2
			local tweenInfo = TweenInfo.new(0.15)
			local StrokeOn = v1033 and t9.StrokeOn or t9.Stroke

			value4.Create(value4, v1035, tweenInfo, {
				Color = StrokeOn
			}):Play()
		end
		local function v1038(p98, p99)
			local v1039 = p98 + 0.5
			local v1040 = math.floor(v1039)
			local v1041 = p88
			local v1042 = p89
			local v1043 = math.clamp(v1040, v1041, v1042)

			u1027 = v1043
			v1031(v1043)

			local v1044 = p91

			if v1044 then
				v1044 = not p99

				if v1044 then
					v1044 = not u1028
				end
			end

			if not v1044 then
				return
			end

			p91(u1027)
			u1028 = false
		end

		v1038(u1027, true)

		local function v1045(p100)
			local X = Frame11.AbsolutePosition.X
			local X2 = Frame11.AbsoluteSize.X

			if X2 <= 0 then
				return
			end

			local v1048 = (p100.X - X) / X2
			local v1049 = math.clamp(v1048, 0, 1)
			local v1050 = p88 + v1049 * (p89 - p88)
			local clamp = math.clamp
			local v1052 = v1050 + 0.5
			local v1053 = clamp(math.floor(v1052), p88, p89)

			v1031(v1053, v1049)

			if v1053 == u1027 then
				return
			end

			u1027 = v1053

			local v1054 = p91

			if v1054 then
				v1054 = not u1028
			end

			if not v1054 then
				return
			end

			p91(u1027)
		end
		local function v1055(p101)
			u1029 = true
			t1.value4:Create(Frame14, TweenInfo.new(0.12), {
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0.5, -12, 0.5, -12),
				BackgroundTransparency = 0.5
			}):Play()
			v1045(p101)
		end
		local function v1056()
			if not u1029 then
				return
			end

			u1029 = false

			local value4 = t1.value4
			local v1058 = Frame14
			local tweenInfo = TweenInfo.new(0.15)
			local uDim23 = UDim2.new(0, 20, 0, 20)

			value4.Create(value4, v1058, tweenInfo, {
				Size = uDim23,
				Position = UDim2.new(0.5, -10, 0.5, -10),
				BackgroundTransparency = 0.85
			}):Play()
			v1031(u1027)
		end

		local TextButton = Instance.new("TextButton")

		TextButton.Text = ""
		TextButton.BackgroundTransparency = 1
		TextButton.Size = UDim2.new(1, 0, 0, 26)
		TextButton.Position = UDim2.new(0, 0, 0, 31)
		TextButton.ZIndex = 107
		TextButton.Parent = Frame10
		TextButton.InputBegan:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			v1055(input.Position)
		end)
		t1.value2.InputChanged:Connect(function(input)
			local v1062 = u1029

			if v1062 then
				v1062 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
			end

			if not v1062 then
				return
			end

			v1045(input.Position)
		end)
		t1.value2.InputEnded:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			v1056()
		end)

		local t21 = {
			row = Frame10,
			track = Frame11,
			processInput = v1045,
			isDragging = function()
				return u1029
			end,
			setDragging = function(p102)
				u1029 = p102

				if p102 then
					return
				end

				v1056()
			end,
			getValue = function()
				return u1027
			end,
			setValue = function(p103)
				if u1029 then
					return
				end

				v1038(p103, true)
			end
		}

		local function v1064()
			if Frame10.Parent then
				Frame10.BackgroundColor3 = t9.Card
				UIStroke2.Color = t9.Stroke
				TextLabel4.TextColor3 = t9.Text
				TextLabel5.TextColor3 = t9.Accent
				TextLabel6.TextColor3 = t9.TextMuted
				Frame11.BackgroundColor3 = t9.Track
				Frame12.BackgroundColor3 = t9.AccentDim
				Frame14.BackgroundColor3 = t9.Accent
			end
		end

		table.insert(t10, v1064)

		local v1065 = t20

		table.insert(v1065, t21)

		return t21
	end

	local function createFrame(p104, p105, p106)
		local Frame9 = Instance.new("Frame")

		Frame9.Name = "SectionHeader"
		Frame9.Size = UDim2.new(1, -4, 0, 28)
		Frame9.BackgroundTransparency = 1
		Frame9.LayoutOrder = p106 or 1
		Frame9.ZIndex = 103
		Frame9.Parent = p104

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Text = p105
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextSize = 14
		TextLabel4.TextColor3 = t9.Accent
		TextLabel4.Size = UDim2.new(1, 0, 1, 0)
		TextLabel4.Position = UDim2.new(0, 4, 0, 0)
		TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.ZIndex = 104
		TextLabel4.Parent = Frame9
		v851(TextLabel4, "TextColor3", "Accent")

		return Frame9
	end

	createFrame(Main, "Top 3 Core Features", 1)

	local autoSkillCheck = nil
	local autoSkillCheck2 = TextLabel2(Main, "Auto Skill Check", "ปั่นไฟให้อัตโนมัติทุกรอบ", t1.value12.AutoGreatZone, function(p107)
		t1.value12.AutoGreatZone = p107

		if not autoSkillCheck then
			return
		end

		local function v1071()
			autoSkillCheck.toggle(p107)
		end

		pcall(v1071)
	end, 2)
	local smoothSpeedBoost = nil
	local smoothSpeedBoost2 = TextLabel2(Main, "Smooth Speed Boost", "วิ่งเร็ว", t1.value12.SpeedEnabled, function(p108)
		t1.value12.SpeedEnabled = p108

		if not smoothSpeedBoost then
			return
		end

		local function v1074()
			smoothSpeedBoost.toggle(p108)
		end

		pcall(v1074)
	end, 3)
	local speedLevel = nil
	local speedLevel2 = createTextButton(Main, "Speed Level", "สปีด CFrame ปรับได้อิสระ 16 - 100 (แนะนำ 21-28 เพื่อความเนียน)", 16, 100, t1.value12.SpeedValue, function(p109)
		t1.value12.SpeedValue = p109

		if not speedLevel then
			return
		end

		local function v1077()
			speedLevel.setValue(p109)
		end

		pcall(v1077)
	end, 4)
	local v1078 = nil
	local v1079 = TextLabel2(Main, "Player & Killer ESP (Box 3D)", "กล่องแดง: Killer  |  กล่องเขียว: Player ", t1.value12.ESPEnabled, function(p110)
		t1.value12.ESPEnabled = p110
		t1.value23()

		if not v1078 then
			return
		end

		pcall(function()
			v1078.toggle(p110)
		end)
	end, 5)

	createFrame(Movement, "ความเร็วและการเดิน (Speed & Motion)", 1)
	smoothSpeedBoost = TextLabel2(Movement, "Smooth Speed Boost", "ระบบบูสต์ความเร็ว CFrame เนียนตา ไม่ดีด ไม่กระตุก", t1.value12.SpeedEnabled, function(p111)
		t1.value12.SpeedEnabled = p111

		if not smoothSpeedBoost2 then
			return
		end

		local function v1080()
			smoothSpeedBoost2.toggle(p111)
		end

		pcall(v1080)
	end, 2)
	speedLevel = createTextButton(Movement, "Speed Level", "สปีด CFrame ปรับได้อิสระ 16 - 100 (แนะนำ 21-28 เพื่อความเนียน)", 16, 100, t1.value12.SpeedValue, function(p112)
		t1.value12.SpeedValue = p112

		if not speedLevel2 then
			return
		end

		local function v1081()
			speedLevel2.setValue(p112)
		end

		pcall(v1081)
	end, 3)

	local noclip = TextLabel2(Movement, "Noclip", "เดินทะลุกำแพง ประตูล็อก สิ่งกีดขวาง ไม่ร่วงตกแมพ", t1.value12.NoclipEnabled, function(p113)
		t1.value12.NoclipEnabled = p113
	end, 4)

	createFrame(Movement, "กายภาพและการเคลื่อนไหวพิเศษ (Advanced Mobility)", 5)
	TextLabel2(Movement, "No Fall Stun (ตกจากที่สูงไม่สตั้น)", "โดดลงจากที่สูงไม่มีดีเลย์/กระตุก วิ่งต่อได้ทันที 100%", t1.value12.NoFall, function(p114)
		t1.value12.NoFall = p114
	end, 6)
	TextLabel2(Movement, "Fast Vault Helper (ข้ามหน้าต่างเร็ว)", "เร่งโมเมนตัมพุ่งข้ามหน้าต่างและแผ่นไม้ระดับ Fast Vault", t1.value12.FastVault, function(p115)
		t1.value12.FastVault = p115
	end, 7)
	createFrame(Combat, "Parrying Dagger", 1)
	TextLabel2(Combat, "Auto Parry", "ออโต้เคาท์เตอร์", t1.value12.AutoParry, function(p116)
		t1.value12.AutoParry = p116
	end, 2)
	Movement = function(p117)
		t1.value12.ParryDistance = p117
	end
	createTextButton(Combat, "ระยะ Parry", "แนะนำ 11 - 14 studs", 8, 20, t1.value12.ParryDistance or 13, Movement, 3)
	createFrame(Combat, "Twist of Fate & Firearms", 4)
	TextLabel2(Combat, "Silent Aim", "กระสุนติดตาม", t1.value12.SilentAim, function(p118)
		t1.value12.SilentAim = p118
	end, 5)
	TextLabel2(Combat, "Show Tracer Line", "แสดงแนวยิงจริงเมื่อถือปืนและพบเป้าหมาย", t1.value12.ShowTracer, function(p119)
		t1.value12.ShowTracer = p119
	end, 6)
	createFrame(Combat, "Silent Aim Target", 7)
	Movement = Instance.new("Frame")
	Movement.Size = UDim2.new(1, -4, 0, 60)
	Movement.BackgroundColor3 = Color3.fromRGB(18, 14, 20)
	Movement.LayoutOrder = 8
	Movement.ZIndex = 103
	Movement.Parent = Combat
	Instance.new("UICorner", Movement).CornerRadius = UDim.new(0, 8)
	Main = Instance.new("UIStroke", Movement)
	Main.Color = Color3.fromRGB(50, 22, 32)
	Main.Thickness = 1.2
	Main = Instance.new("TextLabel")
	Main.Text = "เลือกประเภทเป้าหมายที่ต้องการล็อกและแสดงเส้น:"
	Main.Font = Enum.Font.GothamBold
	Main.TextSize = 11
	Main.TextColor3 = Color3.fromRGB(180, 170, 185)
	Main.Size = UDim2.new(1, -20, 0, 16)
	Main.Position = UDim2.new(0, 12, 0, 6)
	Main.TextXAlignment = Enum.TextXAlignment.Left
	Main.BackgroundTransparency = 1
	Main.ZIndex = 104
	Main.Parent = Movement
	Main = Instance.new("Frame")
	Main.Size = UDim2.new(1, -24, 0, 26)
	Main.Position = UDim2.new(0, 12, 0, 26)
	Main.BackgroundTransparency = 1
	Main.ZIndex = 104
	Main.Parent = Movement
	Movement = Instance.new("UIListLayout", Main)
	Movement.FillDirection = Enum.FillDirection.Horizontal
	Movement.Padding = UDim.new(0, 8)
	Movement.SortOrder = Enum.SortOrder.LayoutOrder

	local v1083 = smoothSpeedBoost
	local v1084 = v878
	local t22 = {}

	for i, v in ipairs({
		{
			Id = "Killer",
			Label = "Killer"
		},
		{
			Id = "Survivor",
			Label = "Survivor"
		},
		{
			Id = "Zombie",
			Label = "Zombie"
		}
	}) do
		v1266 = Instance.new("TextButton")
		v1266.Name = "Target_" .. v.Id
		v1266.Size = UDim2.new(0.31, 0, 1, 0)
		v1189 = t1.value12.AimTarget == v.Id
		v1266.BackgroundColor3 = v1189 and Color3.fromRGB(160, 25, 45) or Color3.fromRGB(26, 20, 28)
		v1266.Text = v.Label
		v1188 = "TextColor3"

		if v1189 then
			v1187 = Color3.fromRGB(255, 255, 255)
		else
			v1187 = v1189
		end

		v1266[v1188] = v1187 or Color3.fromRGB(160, 150, 165)
		v1266.Font = Enum.Font.GothamBold
		v1266.TextSize = 10
		v1266.AutoButtonColor = false
		v1266.LayoutOrder = i
		v1266.ZIndex = 105
		v1266.Parent = Main
		Instance.new("UICorner", v1266).CornerRadius = UDim.new(0, 6)
		v1187 = Instance.new("UIStroke", v1266)
		v1188 = "Color"

		if v1189 then
			i = Color3.fromRGB(255, 55, 75)
		else
			i = v1189
		end

		v1187[v1188] = i or Color3.fromRGB(45, 30, 40)
		v1187.Thickness = v1189 and 1.4 or 1
		t22[v.Id] = {
			btn = v1266,
			stroke = v1187,
			id = v.Id
		}
		v1187 = function()
			t1.value12.AimTarget = v.Id

			for _, v2 in pairs(t22) do
				local v1090 = v2.id == v.Id
				local btn = v2.btn
				local s15 = "BackgroundColor3"
				local color3

				if v1090 then
					color3 = Color3.fromRGB(160, 25, 45)
				else
					color3 = v1090
				end

				btn[s15] = color3 or Color3.fromRGB(26, 20, 28)

				local btn2 = v2.btn
				local s16 = "TextColor3"
				local color32

				if v1090 then
					color32 = Color3.fromRGB(255, 255, 255)
				else
					color32 = v1090
				end

				btn2[s16] = color32 or Color3.fromRGB(160, 150, 165)

				local stroke = v2.stroke
				local s17 = "Color"
				local color33

				if v1090 then
					color33 = Color3.fromRGB(255, 55, 75)
				else
					color33 = v1090
				end

				stroke[s17] = color33 or Color3.fromRGB(45, 30, 40)
				v2.stroke.Thickness = v1090 and 1.4 or 1
			end
		end
		v1266.MouseButton1Click:Connect(v1187)
	end

	createFrame(Combat, "สีเส้นเล็งเป้าหมาย (Tracer Line Color)", 9)

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, -4, 0, 56)
	Frame9.BackgroundColor3 = Color3.fromRGB(18, 14, 20)
	Frame9.LayoutOrder = 10
	Frame9.ZIndex = 103
	Frame9.Parent = Combat
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 8)

	local UIStroke2 = Instance.new("UIStroke", Frame9)

	UIStroke2.Color = Color3.fromRGB(50, 22, 32)
	UIStroke2.Thickness = 1.2
	UIStroke2 = Instance.new("TextLabel")
	UIStroke2.Text = "เลือกโทนสีเส้น Tracer ที่ต้องการ:"
	UIStroke2.Font = Enum.Font.GothamBold
	UIStroke2.TextSize = 11
	UIStroke2.TextColor3 = Color3.fromRGB(180, 170, 185)
	UIStroke2.Size = UDim2.new(1, -20, 0, 16)
	UIStroke2.Position = UDim2.new(0, 12, 0, 6)
	UIStroke2.TextXAlignment = Enum.TextXAlignment.Left
	UIStroke2.BackgroundTransparency = 1
	UIStroke2.ZIndex = 104
	UIStroke2.Parent = Frame9
	UIStroke2 = Instance.new("Frame")
	UIStroke2.Size = UDim2.new(1, -24, 0, 24)
	UIStroke2.Position = UDim2.new(0, 12, 0, 26)
	UIStroke2.BackgroundTransparency = 1
	UIStroke2.ZIndex = 104
	UIStroke2.Parent = Frame9
	Frame9 = Instance.new("UIListLayout", UIStroke2)
	Frame9.FillDirection = Enum.FillDirection.Horizontal
	Frame9.Padding = UDim.new(0, 8)
	Frame9.SortOrder = Enum.SortOrder.LayoutOrder
	Frame9 = {
		Name = "Red",
		Color = Color3.fromRGB(255, 60, 80)
	}

	local t23 = {
		Name = "Purple",
		Color = Color3.fromRGB(185, 75, 255)
	}
	local t24 = {
		Name = "Cyan",
		Color = Color3.fromRGB(0, 230, 255)
	}
	local t25 = {
		Name = "Lime",
		Color = Color3.fromRGB(80, 255, 120)
	}
	local parent = {
		Name = "Gold",
		Color = Color3.fromRGB(255, 215, 0)
	}

	Combat = {
		Name = "White",
		Color = Color3.fromRGB(255, 255, 255)
	}

	local t26 = {}

	for i, v in ipairs({
		Frame9,
		t23,
		t24,
		t25,
		parent,
		Combat
	}) do
		t25 = Instance.new("TextButton")
		t25.Name = "Color_" .. v.Name
		t25.Size = UDim2.new(0, 24, 0, 24)
		t25.BackgroundColor3 = v.Color
		t25.Text = ""
		t25.AutoButtonColor = false
		t25.LayoutOrder = i
		t25.ZIndex = 105
		t25.Parent = UIStroke2
		Instance.new("UICorner", t25).CornerRadius = UDim.new(1, 0)
		i = Instance.new("UIStroke", t25)
		parent = "Color"

		if t1.value12.TracerColor == v.Color then
			Combat = Color3.fromRGB(255, 255, 255)
		else
			Combat = false
		end

		i[parent] = Combat or Color3.fromRGB(40, 30, 35)
		i.Thickness = t1.value12.TracerColor == v.Color and 2 or 1
		t26[v.Name] = {
			btn = t25,
			stroke = i,
			color = v.Color
		}
		t25.MouseButton1Click:Connect(function()
			t1.value12.TracerColor = v.Color

			for _, v2 in pairs(t26) do
				local v1111 = v2.color == v.Color
				local stroke = v2.stroke
				local s18 = "Color"
				local color3

				if v1111 then
					color3 = Color3.fromRGB(255, 255, 255)
				else
					color3 = v1111
				end

				stroke[s18] = color3 or Color3.fromRGB(40, 30, 35)
				v2.stroke.Thickness = v1111 and 2 or 1
			end
		end)
	end

	createFrame(Survival, "Objectives & Health", 1)
	autoSkillCheck = TextLabel2(Survival, "Auto Skill Check", "ปั่นไฟให้อัตโนมัติทุกรอบ", t1.value12.AutoGreatZone, function(p120)
		t1.value12.AutoGreatZone = p120

		if not autoSkillCheck2 then
			return
		end

		local function v1115()
			autoSkillCheck2.toggle(p120)
		end

		pcall(v1115)
	end, 2)
	TextLabel2(Survival, "Auto Heal Teammate (รักษาเพื่อนอัตโนมัติ)", "ช่วยรักษาเพื่อนร่วมทีมทันทีเมื่อเดินเข้าไปใกล้", t1.value12.AutoHeal, function(p121)
		t1.value12.AutoHeal = p121
	end, 3)
	createFrame(Survival, "การป้องกันตัว & โต้กลับฆาตกร (Defense & Counter)", 4)
	TextLabel2(Survival, "Auto Wiggle / Struggle", "ดิ้นหลุดจากไหล่ฆาตกรอัตโนมัติ", t1.value12.AutoWiggle, function(p122)
		t1.value12.AutoWiggle = p122
	end, 5)
	TextLabel2(Survival, "Auto Pallet Drop", "พับแผ่นไม้ใส่ฆาตกรทันทีเมื่ออยู่ในระยะ Stun 12 studs", t1.value12.AutoPallet, function(p123)
		t1.value12.AutoPallet = p123
	end, 6)
	createFrame(Visuals, "ระบบเรดาร์ทะลุกำแพง (ESP Wallhacks)", 1)
	v1078 = TextLabel2(Visuals, "Player & Killer ESP (Box 3D)", "กล่องแดง: Killer  |  กล่องเขียว: Player", t1.value12.ESPEnabled, function(p124)
		t1.value12.ESPEnabled = p124
		t1.value23()

		if not v1079 then
			return
		end

		local function v1116()
			v1079.toggle(p124)
		end

		pcall(v1116)
	end, 2)
	TextLabel2(Visuals, "Generator Aura ESP", "แสดง Aura เรืองแสงสีส้มทองเฉพาะเครื่องที่ยังไม่เสร็จ พร้อม %", t1.value12.GenESPEnabled, function(p125)
		t1.value12.GenESPEnabled = p125
		t1.value32()
	end, 3)
	createFrame(Visuals, "Fullbright", 4)
	TextLabel2(Visuals, "Fullbright", "ปรับแสงสว่างพอเหมาะ ไม่แสบตา ล้างหมอกควัน มืดแค่ไหนก็มองเห็นชัด", t1.value12.FullbrightEnabled, function(p126)
		t1.value12.FullbrightEnabled = p126

		if p126 then
			t1.value46()
		else
			t1.value47()
		end
	end, 5)
	createFrame(Visuals, "Live Match Radar", 6)
	Frame9 = function(p127, p128, p129, p130)
		local Frame10 = Instance.new("Frame")

		Frame10.Size = UDim2.new(1, -4, 0, 62)
		Frame10.BackgroundColor3 = t9.Card
		Frame10.LayoutOrder = p130
		Frame10.ZIndex = 103
		Frame10.Parent = p127
		Instance.new("UICorner", Frame10).CornerRadius = UDim.new(0, 10)

		local UIStroke3 = Instance.new("UIStroke", Frame10)

		UIStroke3.Color = t9.Stroke
		UIStroke3.Thickness = 1
		v851(Frame10, "BackgroundColor3", "Card")
		v851(UIStroke3, "Color", "Stroke")

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Text = p128
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextSize = 14
		TextLabel4.TextColor3 = t9.Accent
		TextLabel4.Size = UDim2.new(1, -20, 0, 18)
		TextLabel4.Position = UDim2.new(0, 12, 0, 8)
		TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.ZIndex = 104
		TextLabel4.Parent = Frame10

		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Text = p129
		TextLabel5.Font = Enum.Font.Gotham
		TextLabel5.TextSize = 11
		TextLabel5.TextColor3 = Color3.fromRGB(180, 175, 190)
		TextLabel5.Size = UDim2.new(1, -20, 0, 18)
		TextLabel5.Position = UDim2.new(0, 12, 0, 26)
		TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel5.BackgroundTransparency = 1
		TextLabel5.ZIndex = 104
		TextLabel5.Parent = Frame10

		return TextLabel5
	end

	local killerStatus = Frame9(Visuals, "Killer Status", "กำลังสแกนหาฆาตกรในห้อง...", 7)

	UIStroke2 = #t1.value1:GetPlayers()

	local survivorCount = Frame9(Visuals, "Survivor Count", "ผู้เล่นในเซิร์ฟเวอร์: " .. tostring(UIStroke2) .. " คน", 8)
	local clientPerformance = Frame9(Visuals, "Client Performance", "FPS: 60  •  Ping: 0 ms", 9)

	task.spawn(function()
		while true do
			task.wait(0.8)

			local function v1124()
				local s19 = "ไม่พบฆาตกร"
				local s20 = ""
				local Character = t1.value10.Character

				if Character then
					Character = Character.FindFirstChild(Character, "HumanoidRootPart") or Character:FindFirstChild("Torso")
				end

				local pairs_ = pairs

				for _, v in pairs_(t1.value18) do
					local isKiller = v.isKiller

					if isKiller then
						isKiller = v.root

						if isKiller then
							isKiller = v.root.Parent
						end
					end

					if isKiller then
						s19 = v.name

						if not Character then
							killerStatus.Text = "ฆาตกร: " .. s19 .. s20
							v1228 = survivorCount
							v1229 = #t1.value1:GetPlayers()
							v1228.Text = "ผู้เล่นทั้งหมดในห้อง: " .. tostring(v1229) .. " คน (พร้อมเล่น)"
							v1230 = t1.value10:GetNetworkPing() * 1000
							v1231 = math.floor(v1230)
							clientPerformance.Text = "Ping: " .. tostring(v1231) .. " ms  •  ระบบพร้อมทำงาน 100%"

							return
						end

						local Magnitude = (v.root.Position - Character.Position).Magnitude

						s20 = " (ระยะ: " .. math.floor(Magnitude) .. "m)"

						break
					end
				end

				killerStatus.Text = "ฆาตกร: " .. s19 .. s20

				local v1133 = survivorCount
				local v1134 = #t1.value1:GetPlayers()

				v1133.Text = "ผู้เล่นทั้งหมดในห้อง: " .. tostring(v1134) .. " คน (พร้อมเล่น)"

				local v1135 = t1.value10:GetNetworkPing() * 1000
				local v1136 = math.floor(v1135)

				clientPerformance.Text = "Ping: " .. tostring(v1136) .. " ms  •  ระบบพร้อมทำงาน 100%"
			end

			pcall(v1124)
		end
	end)
	createFrame(UIStroke, "Theme Color", 1)

	local t27 = {
		"Crimson",
		"Ocean",
		"Sage",
		"Violet",
		"Amber",
		"Graphite"
	}

	Frame9 = table.find(t27, t1.value12.UITheme) or 1

	local uiTheme = createTextButton(UIStroke, "UI Theme", "เลื่อนแถบด้านบนเพื่อเลือกโทนสีของแผงควบคุม", 1, #t27, Frame9, function(p131)
		local v1139 = t27
		local v1140 = p131 + 0.5
		local v1141 = math.floor(v1140)
		local v1142 = #t27
		local v1143 = v1139[math.clamp(v1141, 1, v1142)]
		local v1144

		if v1143 then
			v1144 = v1143 ~= t1.value12.UITheme
		else
			v1144 = v1143
		end

		if not v1144 then
			return
		end

		v855(v1143)
	end, 2, function(p132)
		local v1145 = p132 + 0.5
		local v1146 = math.floor(v1145)
		local v1147 = #t27

		return "โทนสีที่เลือก: " .. (t27[math.clamp(v1146, 1, v1147)] or "Crimson")
	end, "")

	Frame9 = Instance.new("Frame")
	Frame9.Size = UDim2.new(1, -4, 0, 54)
	Frame9.BackgroundColor3 = Color3.fromRGB(18, 14, 20)
	Frame9.LayoutOrder = 3
	Frame9.ZIndex = 103
	Frame9.Parent = UIStroke
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 8)
	UIStroke2 = Instance.new("UIStroke", Frame9)
	UIStroke2.Color = Color3.fromRGB(50, 22, 32)
	UIStroke2.Thickness = 1.2
	UIStroke2 = Instance.new("TextLabel")
	UIStroke2.Text = "แตะเพื่อสลับโทนสีโดยตรง:"
	UIStroke2.Font = Enum.Font.GothamBold
	UIStroke2.TextSize = 10
	UIStroke2.TextColor3 = Color3.fromRGB(180, 170, 185)
	UIStroke2.Size = UDim2.new(1, -20, 0, 14)
	UIStroke2.Position = UDim2.new(0, 12, 0, 5)
	UIStroke2.TextXAlignment = Enum.TextXAlignment.Left
	UIStroke2.BackgroundTransparency = 1
	UIStroke2.ZIndex = 104
	UIStroke2.Parent = Frame9
	UIStroke2 = Instance.new("Frame")
	UIStroke2.Size = UDim2.new(1, -20, 0, 26)
	UIStroke2.Position = UDim2.new(0, 10, 0, 22)
	UIStroke2.BackgroundTransparency = 1
	UIStroke2.ZIndex = 104
	UIStroke2.Parent = Frame9
	Frame9 = Instance.new("UIListLayout", UIStroke2)
	Frame9.FillDirection = Enum.FillDirection.Horizontal
	Frame9.Padding = UDim.new(0, 5)
	Frame9.SortOrder = Enum.SortOrder.LayoutOrder

	local t28 = {}

	for i, v in ipairs(t27) do
		t24 = t1.value13[v]
		t25 = Instance.new("TextButton")
		t25.Size = UDim2.new(0, 92, 1, 0)
		t25.BackgroundColor3 = t24.Accent
		t25.Text = v
		t25.Font = Enum.Font.GothamMedium
		t25.TextSize = 10
		t24 = "TextColor3"

		if v == "Graphite" then
			parent = Color3.fromRGB(20, 20, 24)
		else
			parent = false
		end

		t25[t24] = parent or Color3.fromRGB(255, 255, 255)
		t25.AutoButtonColor = false
		t25.LayoutOrder = i
		t25.ZIndex = 105
		t25.Parent = UIStroke2
		t25.TextStrokeTransparency = 0.5
		t25.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		Instance.new("UICorner", t25).CornerRadius = UDim.new(0, 6)
		t24 = Instance.new("UIStroke", t25)
		parent = t1.value12.UITheme == v
		createTextButton = "Color"

		if parent then
			Visuals = Color3.fromRGB(20, 20, 24)
		end

		t24[createTextButton] = Visuals or Color3.fromRGB(40, 30, 35)
		t24.Thickness = parent and 2 or 1
		t24.Transparency = parent and 0.3 or 0
		t28[v] = {
			btn = t25,
			stroke = t24
		}
		t25.MouseButton1Click:Connect(function()
			if t1.value12.UITheme ~= v then
				v855(v)
				uiTheme.setValue(i)

				for k, v2 in pairs(t28) do
					local v1153 = k == v
					local stroke = v2.stroke
					local s21 = "Color"
					local color3

					if v1153 then
						color3 = Color3.fromRGB(255, 255, 255)
					else
						color3 = v1153
					end

					stroke[s21] = color3 or Color3.fromRGB(40, 30, 35)
					v2.stroke.Thickness = v1153 and 2 or 1
				end
			end
		end)
	end

	createFrame(UIStroke, "Discord Community (เข้ามากันเยอะๆ เป็นกำลังใจให้ DEV)", 4)
	Frame9 = Instance.new("TextButton")
	Frame9.Size = UDim2.new(1, -4, 0, 58)
	Frame9.BackgroundColor3 = Color3.fromRGB(24, 15, 22)
	Frame9.AutoButtonColor = false
	Frame9.Text = ""
	Frame9.LayoutOrder = 5
	Frame9.ZIndex = 103
	Frame9.Parent = UIStroke
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 8)

	local UIStroke3 = Instance.new("UIStroke", Frame9)

	UIStroke3.Color = Color3.fromRGB(200, 55, 75)
	UIStroke3.Thickness = 1.3
	UIStroke2 = Instance.new("TextLabel")
	UIStroke2.Text = "sixbabyboy discord"
	UIStroke2.Font = Enum.Font.GothamBold
	UIStroke2.TextSize = 13
	UIStroke2.TextColor3 = Color3.fromRGB(255, 75, 90)
	UIStroke2.Size = UDim2.new(1, -28, 0, 18)
	UIStroke2.Position = UDim2.new(0, 14, 0, 9)
	UIStroke2.TextXAlignment = Enum.TextXAlignment.Left
	UIStroke2.BackgroundTransparency = 1
	UIStroke2.ZIndex = 104
	UIStroke2.Parent = Frame9

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Text = "https://discord.gg/TEv68MzVtb  •  [คลิกเพื่อคัดลอกลิงก์]"
	TextLabel4.Font = Enum.Font.GothamMedium
	TextLabel4.TextSize = 11
	TextLabel4.TextColor3 = Color3.fromRGB(195, 185, 200)
	TextLabel4.Size = UDim2.new(1, -28, 0, 18)
	TextLabel4.Position = UDim2.new(0, 14, 0, 29)
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.ZIndex = 104
	TextLabel4.Parent = Frame9
	Frame9.MouseButton1Click:Connect(function()
		pcall(function()
			if setclipboard then
				setclipboard("https://discord.gg/TEv68MzVtb")

				return
			end

			if toclipboard then
				toclipboard("https://discord.gg/TEv68MzVtb")

				return
			end

			local syn_ = getfenv().syn

			if syn_ then
				syn_ = getfenv().syn.write_clipboard
			end

			if not syn_ then
				return
			end

			syn.write_clipboard("https://discord.gg/TEv68MzVtb")
		end)
		TextLabel4.Text = "คัดลอกลิงก์เรียบร้อยแล้ว!"
		TextLabel4.TextColor3 = Color3.fromRGB(45, 255, 120)

		local value4 = t1.value4
		local v1161 = UIStroke3
		local tweenInfo = TweenInfo.new(0.2)
		local color3 = Color3.fromRGB

		value4.Create(value4, v1161, tweenInfo, {
			Color = color3(45, 255, 120)
		}):Play()
		task.delay(2.5, function()
			TextLabel4.Text = "https://discord.gg/TEv68MzVtb  •  [คลิกเพื่อคัดลอกลิงก์]"
			TextLabel4.TextColor3 = Color3.fromRGB(195, 185, 200)

			local value42 = t1.value4
			local v1165 = UIStroke3
			local tweenInfo2 = TweenInfo.new(0.2)
			local Color3_ = Color3

			value42.Create(value42, v1165, tweenInfo2, {
				Color = Color3_.fromRGB(200, 55, 75)
			}):Play()
		end)
	end)
	createFrame(UIStroke, "Hotkeys (ปุ่มลัด)", 6)
	Frame9 = Instance.new("Frame")
	Frame9.Size = UDim2.new(1, -4, 0, 130)
	Frame9.BackgroundColor3 = Color3.fromRGB(16, 14, 18)
	Frame9.LayoutOrder = 7
	Frame9.ZIndex = 103
	Frame9.Parent = UIStroke
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 8)
	UIStroke2 = Instance.new("UIStroke", Frame9)
	UIStroke2.Color = Color3.fromRGB(34, 22, 30)
	UIStroke2.Thickness = 1
	UIStroke2 = Instance.new("UIListLayout", Frame9)
	UIStroke2.Padding = UDim.new(0, 5)
	UIStroke2.SortOrder = Enum.SortOrder.LayoutOrder
	UIStroke2 = Instance.new("UIPadding", Frame9)
	UIStroke2.PaddingLeft = UDim.new(0, 12)
	UIStroke2.PaddingRight = UDim.new(0, 12)
	UIStroke2.PaddingTop = UDim.new(0, 10)
	UIStroke2.PaddingBottom = UDim.new(0, 10)

	for i, v in ipairs({
		{
			key = "Right Ctrl",
			desc = "ซ่อน / เปิดแผงควบคุม"
		},
		{
			key = "B",
			desc = "เปิด / ปิด Smooth Speed Boost"
		},
		{
			key = "N",
			desc = "เปิด / ปิด Ghost Noclip"
		}
	}) do
		parent = Instance.new("Frame")
		parent.Size = UDim2.new(1, 0, 0, 26)
		parent.BackgroundTransparency = 1
		parent.LayoutOrder = i
		parent.ZIndex = 104
		parent.Parent = Frame9
		i = Instance.new("TextButton")
		i.Size = UDim2.new(0, 96, 1, 0)
		i.BackgroundColor3 = Color3.fromRGB(28, 20, 26)
		i.AutoButtonColor = false
		i.Font = Enum.Font.GothamBold
		i.TextSize = 11
		i.TextColor3 = Color3.fromRGB(210, 190, 205)
		i.Text = "[" .. v.key .. "]"
		i.ZIndex = 105
		i.Parent = parent
		Instance.new("UICorner", i).CornerRadius = UDim.new(0, 5)
		i = Instance.new("TextLabel")
		i.Size = UDim2.new(1, -106, 1, 0)
		i.Position = UDim2.new(0, 106, 0, 0)
		i.BackgroundTransparency = 1
		i.Font = Enum.Font.Gotham
		i.TextSize = 11
		i.TextColor3 = Color3.fromRGB(150, 140, 155)
		i.Text = v.desc
		i.TextXAlignment = Enum.TextXAlignment.Left
		i.ZIndex = 105
		i.Parent = parent
	end

	createFrame(UIStroke, "Window Controls", 8)
	Frame9 = Instance.new("TextButton")
	Frame9.Size = UDim2.new(1, -4, 0, 42)
	Frame9.BackgroundColor3 = Color3.fromRGB(24, 16, 24)
	Frame9.Font = Enum.Font.GothamBold
	Frame9.TextSize = 12
	Frame9.TextColor3 = Color3.fromRGB(230, 220, 230)
	Frame9.Text = "Reset Window Position"
	Frame9.LayoutOrder = 9
	Frame9.ZIndex = 103
	Frame9.Parent = UIStroke
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 8)
	UIStroke2 = Instance.new("UIStroke", Frame9)
	UIStroke2.Color = Color3.fromRGB(60, 25, 38)
	UIStroke2.Thickness = 1
	UIStroke2 = function()
		local value4 = t1.value4
		local v1171 = Frame
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
		local uDim2New = UDim2.new
		local v1174 = -Frame.Size.X.Offset / 2
		local Y = Frame.Size.Y

		value4.Create(value4, v1171, tweenInfo, {
			Position = uDim2New(0.5, v1174, 0.5, -Y.Offset / 2)
		}):Play()
	end
	Frame9 = Frame9.MouseButton1Click
	Frame9.Connect(Frame9, UIStroke2)
	createFrame(UIStroke, "Streamer Mode (Discord Streamproof)", 10)
	TextLabel2(UIStroke, "Streamer Mode (External Overlay)", "ซ่อน UI และ ESP ในเกม 100% แล้วย้ายไปแสดงผลบน External Streamproof Overlay (คนดู Discord ไม่เห็นแน่นอน)", t1.value12.StreamerMode, function(p133)
		t1.value9(p133)
	end, 11)
	v877 = function()
		if not t1.value12.UIVisible then
			return
		end

		t1.value12.UIVisible = false

		local value4 = t1.value4
		local v1177 = Frame
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		local uDim2New = UDim2.new
		local X = Frame.Size.X
		local v1181 = value4.Create(value4, v1177, tweenInfo, {
			Size = uDim2New(0, X.Offset * 0.85, 0, Frame.Size.Y.Offset * 0.85),
			BackgroundTransparency = 1
		})

		v1181:Play()
		v1181.Completed:Connect(function()
			Frame.Visible = false
			Frame.BackgroundTransparency = 0
			Frame.Size = uDim2
		end)
	end

	local function v1182()
		t1.value12.UIVisible = true
		Frame.Visible = true
		Frame.BackgroundTransparency = 0.6

		local uDim23 = u862

		if not uDim23 then
			v1282 = uDim23 or uDim2
			Frame.Size = UDim2.new(0, v1282.X.Offset * 0.9, 0, v1282.Y.Offset * 0.9)
			t1.value4:Create(Frame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = v1282,
				BackgroundTransparency = 0
			}):Play()

			return
		end

		uDim23 = UDim2.new(0, 920, 0, 620)

		local v1184 = uDim23 or uDim2

		Frame.Size = UDim2.new(0, v1184.X.Offset * 0.9, 0, v1184.Y.Offset * 0.9)
		t1.value4:Create(Frame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = v1184,
			BackgroundTransparency = 0
		}):Play()
	end

	Frame9 = function()
		local value4, v1186, tweenInfo, uDim23, value42, v1190, tweenInfo2, t29

		if not u861 then
			u862 = not u862

			if u862 then
				uDim22 = Frame.Position
				value4 = t1.value4
				v1186 = Frame
				tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				uDim23 = UDim2.new(0, 920, 0, 620)
				value4.Create(value4, v1186, tweenInfo, {
					Size = uDim23,
					Position = UDim2.new(0.5, -460, 0.5, -310)
				}):Play()
			else
				value42 = t1.value4
				v1190 = Frame
				tweenInfo2 = TweenInfo.new(0.32, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				t29 = {
					Size = uDim2,
					Position = uDim22
				}
				value42.Create(value42, v1190, tweenInfo2, t29):Play()
			end

			return
		end

		v1084()
		u862 = not u862

		if u862 then
			uDim22 = Frame.Position
			value4 = t1.value4
			v1186 = Frame
			tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			uDim23 = UDim2.new(0, 920, 0, 620)
			value4.Create(value4, v1186, tweenInfo, {
				Size = uDim23,
				Position = UDim2.new(0.5, -460, 0.5, -310)
			}):Play()
		else
			value42 = t1.value4
			v1190 = Frame
			tweenInfo2 = TweenInfo.new(0.32, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			t29 = {
				Size = uDim2,
				Position = uDim22
			}
			value42.Create(value42, v1190, tweenInfo2, t29):Play()
		end
	end
	v878 = function()
		u861 = not u861

		if u861 then
			Frame4.Visible = false
			Frame5.Visible = false

			local value4 = t1.value4
			local v1194 = Frame
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value4.Create(value4, v1194, tweenInfoNew(0.28, EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, Frame.Size.X.Offset, 0, 42)
			}):Play()

			return
		end

		local v1197 = u862 and 620 or 500
		local value4 = t1.value4
		local v1199 = Frame
		local tweenInfoNew = TweenInfo.new
		local Back = Enum.EasingStyle.Back
		local Out = Enum.EasingDirection.Out
		local v1203 = value4.Create(value4, v1199, tweenInfoNew(0.3, Back, Out), {
			Size = UDim2.new(0, Frame.Size.X.Offset, 0, v1197)
		})

		v1203:Play()
		v1203.Completed:Connect(function()
			if u861 then
				return
			end

			Frame4.Visible = true
			Frame5.Visible = true
		end)
	end
	v879 = Frame9

	local u1204 = false
	local vector3 = Vector3.zero
	local uDim23 = UDim2.new()

	Frame2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u1204 = true
		vector3 = input.Position
		uDim23 = Frame.Position

		local connection = nil

		connection = input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u1204 = false

			if not connection then
				return
			end

			connection:Disconnect()
		end)
	end)
	t1.value2.InputChanged:Connect(function(input)
		local v1208 = u1204

		if v1208 then
			v1208 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v1208 then
			return
		end

		local v1209 = input.Position - vector3

		Frame.Position = UDim2.new(uDim23.X.Scale, uDim23.X.Offset + v1209.X, uDim23.Y.Scale, uDim23.Y.Offset + v1209.Y)
	end)
	t1.value2.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
	end)

	local function v1211(p134, p135, p136)
		if not (p134 and p134.Visible) then
			return false
		end

		local AbsolutePosition = p134.AbsolutePosition
		local AbsoluteSize = p134.AbsoluteSize
		local v1214 = AbsolutePosition.X <= p135

		if not v1214 then
			return v1214
		end

		v1214 = p135 <= AbsolutePosition.X + AbsoluteSize.X

		if not v1214 then
			return v1214
		end

		if AbsolutePosition.Y <= p136 then
			v1214 = p136 <= AbsolutePosition.Y + AbsoluteSize.Y
		else
			v1214 = false
		end

		return v1214
	end

	t1.value2.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == t1.value12.ToggleKey then
			if t1.value12.StreamerMode then
				return
			elseif t1.value12.UIVisible then
				v877()

				return
			else
				v1182()

				return
			end
		end

		if input.KeyCode == t1.value12.SpeedKey then
			t1.value12.SpeedEnabled = not t1.value12.SpeedEnabled

			local function v1215()
				if not v1083 then
					return
				end

				v1083.toggle(t1.value12.SpeedEnabled)
			end

			pcall(v1215)
			pcall(function()
				if not smoothSpeedBoost2 then
					return
				end

				smoothSpeedBoost2.toggle(t1.value12.SpeedEnabled)
			end)

			return
		end

		if input.KeyCode == t1.value12.NoclipKey then
			t1.value12.NoclipEnabled = not t1.value12.NoclipEnabled

			local function v1216()
				if not noclip then
					return
				end

				noclip.toggle(t1.value12.NoclipEnabled)
			end

			pcall(v1216)

			return
		end

		local u1217 = false

		pcall(function()
			u1217 = t1.value5.MenuIsOpen
		end)

		if not u1217 then
			return
		end

		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		if not (t1.value12.UIVisible and Frame.Visible) then
			return
		end

		local X = input.Position.X
		local Y = input.Position.Y

		if v1211(v880, X, Y) then
			v877()

			return
		end

		if v1211(v881, X, Y) then
			v878()

			return
		end

		if v1211(v882, X, Y) then
			v879()

			return
		end

		local v1220, v1221, v1222 = pairs(t15)

		while true do
			local v1223

			v1222, v1223 = v1220(v1221, v1222)

			if not v1222 then
				break
			end

			if v1211(v1223, X, Y) then
				v905(v1222)

				return
			end
		end

		local v1224, v1225, v1226 = ipairs(t18)

		while true do
			local v1227

			v1226, v1227 = v1224(v1225, v1226)

			if not v1226 then
				break
			end

			if v1211(v1227.row, X, Y) then
				v1227.toggle()

				return
			end
		end

		local v1232, v1233, v1234 = ipairs(t20)

		while true do
			local v1235

			v1234, v1235 = v1232(v1233, v1234)

			if not v1234 then
				break
			end

			if v1211(v1235.row, X, Y) then
				v1235.processInput(input.Position)
				v1235.setDragging(true)

				return
			end
		end

		if not v1211(Frame2, X, Y) then
			return
		end

		local _ = input.Position
		local _ = Frame.Position
	end)
	t1.value2.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		for _, v in ipairs(t20) do
			if v.isDragging() then
				v.processInput(input.Position)
			end
		end
	end)
	t1.value2.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		for _, v in ipairs(t20) do
			v.setDragging(false)
		end
	end)

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "SBB_MobileToggle"
	ImageButton.Size = UDim2.new(0, 52, 0, 52)
	ImageButton.Position = UDim2.new(0, 16, 0.45, 0)
	ImageButton.BackgroundColor3 = Color3.fromRGB(20, 14, 22)
	ImageButton.BorderSizePixel = 0
	ImageButton.AutoButtonColor = false
	ImageButton.Active = true
	ImageButton.ZIndex = 200
	ImageButton.Parent = SBB_Hub

	if t1.value12.StreamerMode then
		ImageButton.Visible = false
	end

	Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(1, 0)
	Frame9 = Instance.new("UIStroke", ImageButton)
	Frame9.Color = Color3.fromRGB(255, 60, 80)
	Frame9.Thickness = 1.8
	Frame9 = Instance.new("Frame")
	Frame9.Size = UDim2.new(1, 8, 1, 8)
	Frame9.Position = UDim2.new(0, -4, 0, -4)
	Frame9.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
	Frame9.BackgroundTransparency = 0.88
	Frame9.BorderSizePixel = 0
	Frame9.ZIndex = 199
	Frame9.Parent = ImageButton
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Name = "LogoImage"
	ImageLabel2.Size = UDim2.new(0.85, 0, 0.85, 0)
	ImageLabel2.Position = UDim2.new(0.075, 0, 0.075, 0)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.ScaleType = Enum.ScaleType.Fit
	ImageLabel2.ZIndex = 201
	ImageLabel2.Parent = ImageButton

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Name = "FallbackText"
	TextLabel5.Size = UDim2.new(1, 0, 1, 0)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Font = Enum.Font.GothamBold
	TextLabel5.Text = "SB"
	TextLabel5.TextSize = 18
	TextLabel5.TextColor3 = Color3.fromRGB(255, 75, 90)
	TextLabel5.Visible = true
	TextLabel5.ZIndex = 201
	TextLabel5.Parent = ImageButton
	Frame9 = function()
		pcall(function()
			local getcustomasset_ = getcustomasset or getsynasset
			local writefile_

			if getcustomasset_ then
				writefile_ = writefile
			else
				writefile_ = getcustomasset_
			end

			if not writefile_ then
				return
			end

			local isfile_ = isfile

			if isfile_ then
				isfile_ = isfile("sbb_logo.png")
			end

			if not isfile_ then
				local s22 = "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"
				local s23 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
				local t30 = {}
				local n3 = 1

				for i = 1, 18176, 4 do
					local pos = s23:find(unpack_({ s22.sub(s22, i, i) }))
					local v1250 = i + 1
					local v1251 = i + 1
					local sub = s22.sub
					local v1253 = s23.find(s23, sub(s22, v1250, v1251))
					local pos2 = s23:find(unpack_({ s22.sub(s22, i + 2, i + 2) }))
					local v1255 = i + 3
					local pos3 = s23:find(unpack_({ s22.sub(s22, i + 3, v1255) }))

					if pos and v1253 then
						local v1257 = pos - 1
						local string_ = string
						local v1259 = v1253 - 1
						local char = string_.char
						local v1261 = v1257 * 4
						local v1262 = v1259 / 16

						t30[n3] = char(v1261 + math.floor(v1262))
						n3 = n3 + 1

						if pos2 then
							local string_2 = string
							local v1264 = pos2 - 1
							local char2 = string_2.char
							local v1267 = v1259 % 16 * 16
							local v1268 = v1264 / 4

							t30[n3] = char2(v1267 + math.floor(v1268))
							n3 = n3 + 1

							if pos3 then
								local v1269 = pos3 - 1
								local v1270 = v1264 % 4 * 64 + v1269

								t30[n3] = string.char(v1270)
								n3 = n3 + 1
							end
						end
					end
				end

				writefile("sbb_logo.png", table.concat(t30))
			end

			local v1271 = getcustomasset_("sbb_logo.png")

			if not v1271 then
				return
			end

			ImageLabel2.Image = v1271
			TextLabel5.Visible = false
		end)
	end
	task.spawn(Frame9)

	local u1272 = false
	local vector32 = Vector3.zero
	local uDim24 = UDim2.new()
	local n4 = 0

	ImageButton.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u1272 = true
		vector32 = input.Position
		uDim24 = ImageButton.Position
		n4 = 0

		local value4 = t1.value4
		local v1276 = ImageButton
		local tweenInfo = TweenInfo.new(0.12)
		local t31 = {
			Size = UDim2.new(0, 47, 0, 47)
		}

		value4.Create(value4, v1276, tweenInfo, t31):Play()
	end)
	t1.value2.InputChanged:Connect(function(input)
		if not (u1272 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		local v1279 = n4
		local v1280 = input.Position - vector32
		local X = v1280.X
		local v1283 = v1279 + math.abs(X)
		local Y = v1280.Y

		n4 = v1283 + math.abs(Y)
		ImageButton.Position = UDim2.new(uDim24.X.Scale, uDim24.X.Offset + v1280.X, uDim24.Y.Scale, uDim24.Y.Offset + v1280.Y)
	end)
	t1.value2.InputEnded:Connect(function(input)
		if not ((input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) and u1272) then
			return
		end

		local value4 = t1.value4
		local v1285 = ImageButton
		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local uDim2New = UDim2.new

		value4.Create(value4, v1285, tweenInfo, {
			Size = uDim2New(0, 52, 0, 52)
		}):Play()

		if not (n4 < 14) then
			return
		end

		if t1.value12.StreamerMode then
			return
		end

		if t1.value12.UIVisible then
			v877()

			return
		end

		v1182()
	end)
	Frame9 = t1.value12.StreamerMode

	if Frame9 then
		Frame9 = not t1.value79.OverlayReady
	end

	if not Frame9 then
		return
	end

	SBB_Hub.Enabled = false
	Frame.Visible = false
end)()
task.defer(function()
	local StreamerMode = t1.value12.StreamerMode

	if StreamerMode then
		StreamerMode = t1.value9
	end

	if not StreamerMode then
		return
	end

	t1.value9(true)
end)
