local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local MENU_KEY = Enum.KeyCode.RightShift

local oldGui = PlayerGui:FindFirstChild("NEVERBLOX_V2_CLEAN")
if oldGui then
	oldGui:Destroy()
end

local Theme = {
	BG = Color3.fromRGB(8, 9, 14),
	Sidebar = Color3.fromRGB(5, 17, 28),
	Panel = Color3.fromRGB(0, 24, 48),
	PanelDark = Color3.fromRGB(3, 9, 18),
	Accent = Color3.fromRGB(39, 156, 255),
	Text = Color3.fromRGB(255, 255, 255),
	Muted = Color3.fromRGB(150, 160, 175),
	Off = Color3.fromRGB(72, 84, 96),
	Red = Color3.fromRGB(255, 75, 85),
	Green = Color3.fromRGB(70, 255, 145),
	Yellow = Color3.fromRGB(255, 210, 80)
}

local State = {
	MenuOpen = true,

	-- Rage Bot
	RageBot = false,
	RageActivation = "Always",
	RageTeamCheck = true,
	RageWallCheck = false,
	RageHitbox = "Head",
	RageTargetSelection = "FOV",
	RageFOV = 260,
	RageSmooth = 1,
	RagePrediction = 0.08,
	RageMaxDistance = 2500,
	RageAutoFire = false,
	RageDoubleTap = false,
	RageQuickStop = false,
	RageHitchance = 100,

	-- Legit Bot
	LegitBot = false,
	LegitActivation = "Hold RMB",
	LegitTeamCheck = true,
	LegitWallCheck = true,
	LegitHitbox = "Head",
	LegitFOV = 110,
	LegitSmooth = 30,
	LegitPrediction = 0.03,
	LegitMaxDistance = 1500,
	LegitTriggerbot = false,
	LegitTriggerDelay = 120,

	-- Visuals
	VisualsEnabled = true,
	TeamCheck = false,
	BoxESP = true,
	CornerBox = false,
	NameESP = true,
	HealthESP = true,
	DistanceESP = true,
	Chams = true,
	Glow = true,
	ChamsXRay = true,
	ESPMaxDistance = 2500,
	FOVCircles = true,

	-- World
	Nightmode = false,
	Fullbright = false,
	RemoveFog = false,
	SkyColor = "Default",
	Brightness = 2,
	CameraFOV = 70,

	-- Movement
	BunnyHop = false,
	AutoStrafer = false,
	AutoStraferMode = "Legit",
	FastStop = false,

	-- Misc
	Thirdperson = false,
	ThirdpersonDistance = 12,
	Hitsounds = false,
	HitSoundType = "Neverlose",

	-- UI
	Indicators = true,
	Watermark = true,
	KeybindList = true
}

local OldLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}

local OldCamera = {
	Mode = LocalPlayer.CameraMode,
	MinZoom = LocalPlayer.CameraMinZoomDistance,
	MaxZoom = LocalPlayer.CameraMaxZoomDistance
}

local Keys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false
}

local HoldingRMB = false
local LastFire = 0
local LastTrigger = 0

local ToggleControls = {}
local SliderControls = {}
local DropdownControls = {}

local HitSounds = {
	Neverlose = "rbxassetid://6895079853",
	Skeet = "rbxassetid://10066931761",
	Bell = "rbxassetid://9118823100",
	Metal = "rbxassetid://8917041751",
	Ding = "rbxassetid://6026984224",
	Click = "rbxassetid://12221967"
}

local function New(className, props, parent)
	local obj = Instance.new(className)

	for k, v in pairs(props or {}) do
		obj[k] = v
	end

	if parent then
		obj.Parent = parent
	end

	return obj
end

local function Corner(obj, radius)
	return New("UICorner", {
		CornerRadius = UDim.new(0, radius or 6)
	}, obj)
end

local function GetChar(plr)
	plr = plr or LocalPlayer
	return plr.Character
end

local function GetRoot(plr)
	local char = GetChar(plr)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(plr)
	local char = GetChar(plr)
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function IsEnemyForVisuals(plr)
	if not plr or plr == LocalPlayer then
		return false
	end

	if State.TeamCheck and LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
		return false
	end

	return true
end

local function IsEnemyForAim(plr, teamCheck)
	if not plr or plr == LocalPlayer then
		return false
	end

	if teamCheck and LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
		return false
	end

	return true
end

--// GUI

local Gui = New("ScreenGui", {
	Name = "NEVERBLOX_V2_CLEAN",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 20,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local Main = New("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(820, 630),
	Position = UDim2.new(0.5, -410, 0.5, -315),
	BackgroundColor3 = Theme.BG,
	BorderSizePixel = 0,
	ZIndex = 50
}, Gui)
Corner(Main, 6)

local Sidebar = New("Frame", {
	Name = "Sidebar",
	Size = UDim2.fromOffset(210, 630),
	BackgroundColor3 = Theme.Sidebar,
	BorderSizePixel = 0,
	ZIndex = 51
}, Main)

New("TextLabel", {
	Size = UDim2.fromOffset(180, 40),
	Position = UDim2.fromOffset(18, 16),
	BackgroundTransparency = 1,
	Text = "NEVERBLOX",
	TextColor3 = Theme.Text,
	TextSize = 28,
	Font = Enum.Font.FredokaOne,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 52
}, Sidebar)

New("TextLabel", {
	Size = UDim2.fromOffset(170, 18),
	Position = UDim2.fromOffset(20, 47),
	BackgroundTransparency = 1,
	Text = "by Nyrex",
	TextColor3 = Theme.Accent,
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 52
}, Sidebar)

local TabHolder = New("Frame", {
	Size = UDim2.fromOffset(190, 455),
	Position = UDim2.fromOffset(10, 88),
	BackgroundTransparency = 1,
	ZIndex = 52
}, Sidebar)

New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 7)
}, TabHolder)

local ProfileLine = New("Frame", {
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -68),
	BackgroundColor3 = Color3.fromRGB(24, 54, 82),
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	ZIndex = 52
}, Sidebar)

local Avatar = New("ImageLabel", {
	Size = UDim2.fromOffset(44, 44),
	Position = UDim2.fromOffset(14, 12),
	BackgroundTransparency = 1,
	Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png",
	ZIndex = 53
}, ProfileLine)
Corner(Avatar, 50)

New("TextLabel", {
	Size = UDim2.fromOffset(125, 22),
	Position = UDim2.fromOffset(68, 11),
	BackgroundTransparency = 1,
	Text = LocalPlayer.Name,
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 53
}, ProfileLine)

New("TextLabel", {
	Size = UDim2.fromOffset(125, 18),
	Position = UDim2.fromOffset(68, 34),
	BackgroundTransparency = 1,
	Text = "RightShift",
	TextColor3 = Theme.Accent,
	TextSize = 12,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 53
}, ProfileLine)

local Top = New("Frame", {
	Size = UDim2.new(1, -210, 0, 70),
	Position = UDim2.fromOffset(210, 0),
	BackgroundTransparency = 1,
	ZIndex = 52
}, Main)

local PageTitle = New("TextLabel", {
	Size = UDim2.fromOffset(270, 40),
	Position = UDim2.fromOffset(24, 16),
	BackgroundTransparency = 1,
	Text = "Rage Bot",
	TextColor3 = Theme.Text,
	TextSize = 22,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 53
}, Top)

local PresetButton = New("TextButton", {
	Size = UDim2.fromOffset(95, 34),
	Position = UDim2.new(1, -235, 0, 18),
	BackgroundColor3 = Theme.PanelDark,
	BackgroundTransparency = 0.35,
	BorderSizePixel = 0,
	Text = "Preset",
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 53
}, Top)
Corner(PresetButton, 4)

local InfoButton = New("TextButton", {
	Size = UDim2.fromOffset(95, 34),
	Position = UDim2.new(1, -125, 0, 18),
	BackgroundColor3 = Theme.PanelDark,
	BackgroundTransparency = 0.35,
	BorderSizePixel = 0,
	Text = "Info",
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 53
}, Top)
Corner(InfoButton, 4)

New("Frame", {
	Size = UDim2.new(1, -230, 0, 1),
	Position = UDim2.fromOffset(220, 70),
	BackgroundColor3 = Color3.fromRGB(40, 50, 65),
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	ZIndex = 52
}, Main)

local Content = New("Frame", {
	Size = UDim2.new(1, -230, 1, -86),
	Position = UDim2.fromOffset(220, 80),
	BackgroundTransparency = 1,
	ZIndex = 52
}, Main)

local NotifyHolder = New("Frame", {
	Name = "NotifyHolder",
	Size = UDim2.fromOffset(320, 700),
	Position = UDim2.new(1, -340, 0, 20),
	BackgroundTransparency = 1,
	ZIndex = 199
}, Gui)

New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
	HorizontalAlignment = Enum.HorizontalAlignment.Right
}, NotifyHolder)

local function Notify(title, text)
	local frame = New("Frame", {
		Size = UDim2.fromOffset(0, 66),
		BackgroundColor3 = Color3.fromRGB(13, 24, 38),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		ZIndex = 200
	}, NotifyHolder)
	Corner(frame, 5)

	local line = New("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 1, -4),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 201
	}, frame)
	Corner(line, 5)

	New("TextLabel", {
		Size = UDim2.fromOffset(230, 22),
		Position = UDim2.fromOffset(16, 9),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 201
	}, frame)

	New("TextLabel", {
		Size = UDim2.fromOffset(250, 22),
		Position = UDim2.fromOffset(16, 34),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.fromRGB(215, 220, 230),
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 201
	}, frame)

	TweenService:Create(frame, TweenInfo.new(0.22), {
		Size = UDim2.fromOffset(285, 66)
	}):Play()

	TweenService:Create(line, TweenInfo.new(2.1), {
		Size = UDim2.new(0, 0, 0, 4)
	}):Play()

	task.delay(2.35, function()
		if frame then
			TweenService:Create(frame, TweenInfo.new(0.22), {
				Size = UDim2.fromOffset(0, 66),
				BackgroundTransparency = 1
			}):Play()

			task.wait(0.25)
			frame:Destroy()
		end
	end)
end

local Pages = {}
local Tabs = {}

local function SetTab(name)
	for pageName, page in pairs(Pages) do
		page.Visible = pageName == name
	end

	for tabName, data in pairs(Tabs) do
		local active = tabName == name

		TweenService:Create(data.Button, TweenInfo.new(0.18), {
			BackgroundTransparency = active and 0.15 or 1
		}):Play()

		TweenService:Create(data.Label, TweenInfo.new(0.18), {
			TextColor3 = active and Theme.Text or Color3.fromRGB(165, 170, 180)
		}):Play()
	end

	PageTitle.Text = name
end

local function MakePage(name)
	local tab = New("TextButton", {
		Name = name,
		Size = UDim2.fromOffset(182, 31),
		BackgroundColor3 = Color3.fromRGB(13, 98, 144),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 53
	}, TabHolder)
	Corner(tab, 4)

	local label = New("TextLabel", {
		Size = UDim2.fromOffset(150, 20),
		Position = UDim2.fromOffset(14, 6),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = Color3.fromRGB(165, 170, 180),
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 54
	}, tab)

	local page = New("ScrollingFrame", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromOffset(0, 0),
		Visible = false,
		ZIndex = 53
	}, Content)

	local left = New("Frame", {
		Name = "LeftColumn",
		Size = UDim2.new(0.5, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 53
	}, page)

	local right = New("Frame", {
		Name = "RightColumn",
		Size = UDim2.new(0.5, -8, 0, 0),
		Position = UDim2.new(0.5, 8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 53
	}, page)

	New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 13)
	}, left)

	New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 13)
	}, right)

	Pages[name] = page
	Tabs[name] = {
		Button = tab,
		Label = label
	}

	tab.MouseButton1Click:Connect(function()
		SetTab(name)
	end)

	return page
end

local function MakeSection(page, title, side)
	local parent = side == "right" and page.RightColumn or page.LeftColumn

	local section = New("Frame", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 54
	}, parent)
	Corner(section, 8)

	New("TextLabel", {
		Size = UDim2.new(1, -20, 0, 38),
		Position = UDim2.fromOffset(10, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 16,
		Font = Enum.Font.SourceSansBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 55
	}, section)

	New("Frame", {
		Size = UDim2.new(1, -18, 0, 1),
		Position = UDim2.fromOffset(9, 39),
		BackgroundColor3 = Color3.fromRGB(23, 50, 83),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		ZIndex = 55
	}, section)

	local holder = New("Frame", {
		Name = "Holder",
		Size = UDim2.new(1, -12, 0, 0),
		Position = UDim2.fromOffset(6, 48),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 55
	}, section)

	local layout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	}, holder)

	local function Resize()
		task.defer(function()
			section.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 58)
		end)
	end

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
	Resize()

	return holder
end

local function AddToggle(parent, key, title, callback)
	local value = State[key] == true

	local row = New("TextButton", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 56
	}, parent)

	New("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 57
	}, row)

	local frame = New("Frame", {
		Size = UDim2.fromOffset(38, 15),
		Position = UDim2.new(1, -48, 0.5, -7),
		BackgroundColor3 = Theme.PanelDark,
		BorderSizePixel = 0,
		ZIndex = 57
	}, row)
	Corner(frame, 50)

	local dot = New("Frame", {
		Size = UDim2.fromOffset(17, 17),
		Position = UDim2.fromOffset(0, -1),
		BackgroundColor3 = Theme.Off,
		BorderSizePixel = 0,
		ZIndex = 58
	}, frame)
	Corner(dot, 50)

	local function Render()
		if value then
			TweenService:Create(dot, TweenInfo.new(0.18), {
				Position = UDim2.fromOffset(20, -1),
				BackgroundColor3 = Theme.Accent
			}):Play()
		else
			TweenService:Create(dot, TweenInfo.new(0.18), {
				Position = UDim2.fromOffset(0, -1),
				BackgroundColor3 = Theme.Off
			}):Play()
		end
	end

	local function SetRaw(v)
		value = v == true
		State[key] = value
		Render()

		if callback then
			callback(value)
		end
	end

	row.MouseButton1Click:Connect(function()
		SetRaw(not value)
	end)

	SetRaw(value)

	ToggleControls[key] = {
		Set = function(_, v)
			SetRaw(v)
		end,
		Get = function()
			return value
		end
	}

	return ToggleControls[key]
end

local function AddSlider(parent, key, title, min, max, default, step, callback)
	local value = State[key] or default
	step = step or 1

	local row = New("Frame", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		ZIndex = 56
	}, parent)

	New("TextLabel", {
		Size = UDim2.new(0, 110, 0, 18),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 57
	}, row)

	local valueBox = New("TextBox", {
		Size = UDim2.fromOffset(48, 17),
		Position = UDim2.new(1, -54, 0, 1),
		BackgroundColor3 = Theme.PanelDark,
		BorderSizePixel = 0,
		Text = tostring(value),
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false,
		ZIndex = 57
	}, row)
	Corner(valueBox, 3)

	local bar = New("Frame", {
		Size = UDim2.new(1, -145, 0, 2),
		Position = UDim2.fromOffset(116, 14),
		BackgroundColor3 = Color3.fromRGB(3, 30, 58),
		BorderSizePixel = 0,
		ZIndex = 57
	}, row)

	local fill = New("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 58
	}, bar)

	local dot = New("Frame", {
		Size = UDim2.fromOffset(17, 17),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 59
	}, bar)
	Corner(dot, 50)

	local draggingSlider = false

	local function RoundToStep(n)
		return math.floor((n / step) + 0.5) * step
	end

	local function SetRaw(v)
		local num = tonumber(v) or min
		num = math.clamp(RoundToStep(num), min, max)

		value = num
		State[key] = value

		local pct = (value - min) / (max - min)
		fill.Size = UDim2.fromScale(pct, 1)
		dot.Position = UDim2.new(pct, -8, 0, -8)

		if step < 1 then
			valueBox.Text = string.format("%.2f", value)
		else
			valueBox.Text = tostring(math.floor(value))
		end

		if callback then
			callback(value)
		end
	end

	local function FromX(x)
		local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		SetRaw(min + (max - min) * pct)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
			FromX(input.Position.X)
		end
	end)

	dot.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
			FromX(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			FromX(input.Position.X)
		end
	end)

	valueBox.FocusLost:Connect(function()
		SetRaw(valueBox.Text)
	end)

	SetRaw(value)

	SliderControls[key] = {
		Set = function(_, v)
			SetRaw(v)
		end,
		Get = function()
			return value
		end
	}

	return SliderControls[key]
end

local function AddDropdown(parent, key, title, list, default, callback)
	local selected = State[key] or default or list[1]

	local row = New("TextButton", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 31),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 80
	}, parent)

	New("TextLabel", {
		Size = UDim2.new(0, 110, 0, 26),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 81
	}, row)

	local box = New("TextButton", {
		Size = UDim2.fromOffset(130, 21),
		Position = UDim2.new(1, -137, 0, 2),
		BackgroundColor3 = Theme.PanelDark,
		BorderSizePixel = 0,
		Text = selected,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false,
		ZIndex = 81
	}, row)
	Corner(box, 3)

	local drop = New("Frame", {
		Size = UDim2.fromOffset(130, 0),
		Position = UDim2.new(1, -137, 0, 25),
		BackgroundColor3 = Color3.fromRGB(0, 18, 35),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 100
	}, row)
	Corner(drop, 3)

	New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2)
	}, drop)

	local opened = false

	local function Close()
		opened = false

		TweenService:Create(drop, TweenInfo.new(0.16), {
			Size = UDim2.fromOffset(130, 0)
		}):Play()

		task.delay(0.17, function()
			if not opened then
				drop.Visible = false
			end
		end)
	end

	local function Open()
		opened = true
		drop.Visible = true

		TweenService:Create(drop, TweenInfo.new(0.16), {
			Size = UDim2.fromOffset(130, math.min(#list * 24 + 4, 165))
		}):Play()
	end

	local function SetRaw(v)
		selected = v
		State[key] = v
		box.Text = v

		if callback then
			callback(v)
		end
	end

	for _, item in ipairs(list) do
		local itemButton = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			Text = "  " .. item,
			TextColor3 = Theme.Text,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			ZIndex = 101
		}, drop)

		itemButton.MouseButton1Click:Connect(function()
			SetRaw(item)
			Close()
		end)
	end

	box.MouseButton1Click:Connect(function()
		if opened then
			Close()
		else
			Open()
		end
	end)

	SetRaw(selected)

	DropdownControls[key] = {
		Set = function(_, v)
			SetRaw(v)
		end,
		Get = function()
			return selected
		end
	}

	return DropdownControls[key]
end

local function AddButton(parent, title, callback)
	local button = New("TextButton", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = Theme.PanelDark,
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 56
	}, parent)
	Corner(button, 4)

	New("TextLabel", {
		Size = UDim2.new(1, -18, 1, 0),
		Position = UDim2.fromOffset(9, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 57
	}, button)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.18), {
			BackgroundTransparency = 0.2
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.18), {
			BackgroundTransparency = 0.45
		}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	return button
end

--// Keybind system

local BindModes = {"Toggle", "Hold", "Always"}
local Keybinds = {}
local ListeningBind = nil

local function SetBoundState(stateKey, value)
	if ToggleControls[stateKey] then
		ToggleControls[stateKey]:Set(value)
	else
		State[stateKey] = value
	end
end

local function GetBoundState(stateKey)
	if ToggleControls[stateKey] then
		return ToggleControls[stateKey]:Get()
	end

	return State[stateKey] == true
end

local function KeyToText(key)
	if not key or key == Enum.KeyCode.Unknown then
		return "None"
	end

	return key.Name
end

local function AddBindRow(parent, stateKey, title, defaultKey, defaultMode)
	local key = Enum.KeyCode[defaultKey] or Enum.KeyCode.Unknown
	local mode = defaultMode or "Toggle"

	Keybinds[stateKey] = {
		Title = title,
		Key = key,
		Mode = mode
	}

	local row = New("Frame", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		ZIndex = 56
	}, parent)

	New("TextLabel", {
		Size = UDim2.new(1, -150, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 57
	}, row)

	local keyButton = New("TextButton", {
		Size = UDim2.fromOffset(58, 22),
		Position = UDim2.new(1, -135, 0.5, -11),
		BackgroundColor3 = Theme.PanelDark,
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
		Text = KeyToText(key),
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 57
	}, row)
	Corner(keyButton, 4)

	local modeButton = New("TextButton", {
		Size = UDim2.fromOffset(68, 22),
		Position = UDim2.new(1, -70, 0.5, -11),
		BackgroundColor3 = Theme.PanelDark,
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
		Text = mode,
		TextColor3 = Theme.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 57
	}, row)
	Corner(modeButton, 4)

	keyButton.MouseButton1Click:Connect(function()
		ListeningBind = stateKey
		keyButton.Text = "..."
	end)

	modeButton.MouseButton1Click:Connect(function()
		local currentIndex = table.find(BindModes, Keybinds[stateKey].Mode) or 1
		local nextIndex = currentIndex + 1

		if nextIndex > #BindModes then
			nextIndex = 1
		end

		local newMode = BindModes[nextIndex]
		Keybinds[stateKey].Mode = newMode
		modeButton.Text = newMode

		if newMode == "Always" then
			SetBoundState(stateKey, true)
		end
	end)

	Keybinds[stateKey].UpdateText = function()
		keyButton.Text = KeyToText(Keybinds[stateKey].Key)
		modeButton.Text = Keybinds[stateKey].Mode
	end
end

local function ProcessBindInput(input, began)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return false
	end

	if ListeningBind and began then
		Keybinds[ListeningBind].Key = input.KeyCode
		Keybinds[ListeningBind].UpdateText()
		Notify("Bind", Keybinds[ListeningBind].Title .. " = " .. input.KeyCode.Name)
		ListeningBind = nil
		return true
	end

	if UIS:GetFocusedTextBox() then
		return false
	end

	for stateKey, bind in pairs(Keybinds) do
		if bind.Key == input.KeyCode then
			if bind.Mode == "Toggle" and began then
				SetBoundState(stateKey, not GetBoundState(stateKey))
				return true
			end

			if bind.Mode == "Hold" then
				SetBoundState(stateKey, began)
				return true
			end

			if bind.Mode == "Always" and began then
				SetBoundState(stateKey, true)
				return true
			end
		end
	end

	return false
end

local function ApplyAlwaysBinds()
	for stateKey, bind in pairs(Keybinds) do
		if bind.Mode == "Always" and not GetBoundState(stateKey) then
			SetBoundState(stateKey, true)
		end
	end
end

--// Pages

local RagePage = MakePage("Rage Bot")
local LegitPage = MakePage("Legit Bot")
local VisualsPage = MakePage("Visuals")
local WorldPage = MakePage("World")
local MovementPage = MakePage("Movement")
local MiscPage = MakePage("Misc")
local ConfigPage = MakePage("Configs")
local BindsPage = MakePage("Binds")

--// Rage Bot page

local RageMain = MakeSection(RagePage, "Rage Bot", "left")
AddToggle(RageMain, "RageBot", "Enabled")
AddDropdown(RageMain, "RageActivation", "Activation", {"Always", "Hold RMB"}, "Always")
AddToggle(RageMain, "RageTeamCheck", "Team Check")
AddToggle(RageMain, "RageWallCheck", "Wall Check")
AddDropdown(RageMain, "RageHitbox", "Hitbox", {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}, "Head")
AddDropdown(RageMain, "RageTargetSelection", "Target By", {"FOV", "Distance", "Health"}, "FOV")

local RageAccuracy = MakeSection(RagePage, "Accuracy", "right")
AddSlider(RageAccuracy, "RageFOV", "FOV", 20, 700, 260, 1)
AddSlider(RageAccuracy, "RageSmooth", "Smooth", 1, 40, 1, 1)
AddSlider(RageAccuracy, "RagePrediction", "Prediction", 0, 1, 0.08, 0.01)
AddSlider(RageAccuracy, "RageMaxDistance", "Max Distance", 100, 5000, 2500, 50)
AddSlider(RageAccuracy, "RageHitchance", "Hitchance %", 1, 100, 100, 1)

local RageFire = MakeSection(RagePage, "Fire Control", "right")
AddToggle(RageFire, "RageAutoFire", "Auto Fire")
AddToggle(RageFire, "RageDoubleTap", "Double Tap")
AddToggle(RageFire, "RageQuickStop", "Quick Stop")

--// Legit Bot page

local LegitMain = MakeSection(LegitPage, "Legit Bot", "left")
AddToggle(LegitMain, "LegitBot", "Enabled")
AddDropdown(LegitMain, "LegitActivation", "Activation", {"Hold RMB", "Always"}, "Hold RMB")
AddToggle(LegitMain, "LegitTeamCheck", "Team Check")
AddToggle(LegitMain, "LegitWallCheck", "Wall Check")
AddDropdown(LegitMain, "LegitHitbox", "Hitbox", {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}, "Head")

local LegitTune = MakeSection(LegitPage, "Fine Tuning", "right")
AddSlider(LegitTune, "LegitFOV", "FOV", 20, 350, 110, 1)
AddSlider(LegitTune, "LegitSmooth", "Smooth", 1, 100, 30, 1)
AddSlider(LegitTune, "LegitPrediction", "Prediction", 0, 0.5, 0.03, 0.01)
AddSlider(LegitTune, "LegitMaxDistance", "Max Distance", 100, 3000, 1500, 50)

local LegitTrigger = MakeSection(LegitPage, "Triggerbot", "left")
AddToggle(LegitTrigger, "LegitTriggerbot", "Enabled")
AddSlider(LegitTrigger, "LegitTriggerDelay", "Delay MS", 0, 600, 120, 5)

--// Visuals page

local ESPMain = MakeSection(VisualsPage, "Player ESP", "left")
AddToggle(ESPMain, "VisualsEnabled", "Enabled")
AddToggle(ESPMain, "TeamCheck", "Team Check")
AddToggle(ESPMain, "BoxESP", "Box")
AddToggle(ESPMain, "CornerBox", "Corner Box")
AddToggle(ESPMain, "NameESP", "Name")
AddToggle(ESPMain, "HealthESP", "Health")
AddToggle(ESPMain, "DistanceESP", "Distance")
AddSlider(ESPMain, "ESPMaxDistance", "Max Distance", 100, 5000, 2500, 50)

local ChamsMain = MakeSection(VisualsPage, "Chams / Glow", "right")
AddToggle(ChamsMain, "Chams", "Chams")
AddToggle(ChamsMain, "Glow", "Glow")
AddToggle(ChamsMain, "ChamsXRay", "X-Ray")

local IndicatorsSec = MakeSection(VisualsPage, "Screen", "right")
AddToggle(IndicatorsSec, "FOVCircles", "FOV Circles")
AddToggle(IndicatorsSec, "Indicators", "Indicators")
AddToggle(IndicatorsSec, "Watermark", "Watermark")
AddToggle(IndicatorsSec, "KeybindList", "Keybind List")

--// World page

local WorldMain = MakeSection(WorldPage, "World", "left")
AddToggle(WorldMain, "Nightmode", "Nightmode")
AddToggle(WorldMain, "Fullbright", "Fullbright")
AddToggle(WorldMain, "RemoveFog", "Remove Fog")
AddDropdown(WorldMain, "SkyColor", "Sky Color", {"Default", "Blue", "Purple", "Red", "Black"}, "Default")
AddSlider(WorldMain, "Brightness", "Brightness", 0, 10, 2, 0.1)
AddSlider(WorldMain, "CameraFOV", "Camera FOV", 50, 120, 70, 1, function(v)
	Camera.FieldOfView = v
end)

--// Movement page

local MovementMain = MakeSection(MovementPage, "Movement", "left")
AddToggle(MovementMain, "BunnyHop", "BunnyHop")
AddToggle(MovementMain, "AutoStrafer", "Auto Strafer")
AddDropdown(MovementMain, "AutoStraferMode", "Strafe Mode", {"Legit", "Rage"}, "Legit")
AddToggle(MovementMain, "FastStop", "Fast Stop")

local MovementInfo = MakeSection(MovementPage, "Info", "right")
AddButton(MovementInfo, "How it works", function()
	Notify("Movement", "Works only on your character in your game")
end)

--// Misc page

local MiscMain = MakeSection(MiscPage, "Misc", "left")
AddToggle(MiscMain, "Thirdperson", "Thirdperson")
AddSlider(MiscMain, "ThirdpersonDistance", "Thirdperson Distance", 6, 30, 12, 1)
AddToggle(MiscMain, "Hitsounds", "Hitsounds")
AddDropdown(MiscMain, "HitSoundType", "Hit Sound", {"Neverlose", "Skeet", "Bell", "Metal", "Ding", "Click"}, "Neverlose")

local MiscInfo = MakeSection(MiscPage, "Info", "right")
AddButton(MiscInfo, "Test Hitsound", function()
	local sound = Instance.new("Sound")
	sound.SoundId = HitSounds[State.HitSoundType] or HitSounds.Neverlose
	sound.Volume = 0.7
	sound.Parent = SoundService
	sound:Play()

	task.delay(2, function()
		if sound then
			sound:Destroy()
		end
	end)
end)

--// Config page

local Presets = MakeSection(ConfigPage, "Presets", "left")
AddButton(Presets, "Rage Preset", function()
	ToggleControls.RageBot:Set(true)
	ToggleControls.RageAutoFire:Set(true)
	ToggleControls.RageDoubleTap:Set(true)
	ToggleControls.RageQuickStop:Set(true)
	DropdownControls.RageActivation:Set("Always")
	DropdownControls.RageTargetSelection:Set("FOV")
	SliderControls.RageFOV:Set(360)
	SliderControls.RageSmooth:Set(1)
	SliderControls.RagePrediction:Set(0.1)
	SliderControls.RageHitchance:Set(100)
	Notify("Preset", "Rage preset loaded")
end)

AddButton(Presets, "Legit Preset", function()
	ToggleControls.LegitBot:Set(true)
	ToggleControls.LegitTriggerbot:Set(false)
	DropdownControls.LegitActivation:Set("Hold RMB")
	SliderControls.LegitFOV:Set(90)
	SliderControls.LegitSmooth:Set(45)
	SliderControls.LegitPrediction:Set(0.03)
	Notify("Preset", "Legit preset loaded")
end)

AddButton(Presets, "Visuals Preset", function()
	ToggleControls.VisualsEnabled:Set(true)
	ToggleControls.BoxESP:Set(true)
	ToggleControls.CornerBox:Set(false)
	ToggleControls.NameESP:Set(true)
	ToggleControls.HealthESP:Set(true)
	ToggleControls.DistanceESP:Set(true)
	ToggleControls.Chams:Set(true)
	ToggleControls.Glow:Set(true)
	Notify("Preset", "Visuals preset loaded")
end)

AddButton(Presets, "Clean Preset", function()
	ToggleControls.VisualsEnabled:Set(true)
	ToggleControls.BoxESP:Set(false)
	ToggleControls.CornerBox:Set(true)
	ToggleControls.NameESP:Set(true)
	ToggleControls.HealthESP:Set(true)
	ToggleControls.DistanceESP:Set(false)
	ToggleControls.Chams:Set(false)
	ToggleControls.Glow:Set(false)
	Notify("Preset", "Clean preset loaded")
end)

local ResetSec = MakeSection(ConfigPage, "Reset", "right")
AddButton(ResetSec, "Reset Aim", function()
	ToggleControls.RageBot:Set(false)
	ToggleControls.RageAutoFire:Set(false)
	ToggleControls.RageDoubleTap:Set(false)
	ToggleControls.LegitBot:Set(false)
	ToggleControls.LegitTriggerbot:Set(false)
	Notify("Reset", "Aim reset")
end)

AddButton(ResetSec, "Reset Visuals", function()
	ToggleControls.VisualsEnabled:Set(false)
	ToggleControls.BoxESP:Set(false)
	ToggleControls.CornerBox:Set(false)
	ToggleControls.NameESP:Set(false)
	ToggleControls.HealthESP:Set(false)
	ToggleControls.DistanceESP:Set(false)
	ToggleControls.Chams:Set(false)
	ToggleControls.Glow:Set(false)
	Notify("Reset", "Visuals reset")
end)

AddButton(ResetSec, "Reset World", function()
	ToggleControls.Nightmode:Set(false)
	ToggleControls.Fullbright:Set(false)
	ToggleControls.RemoveFog:Set(false)
	DropdownControls.SkyColor:Set("Default")
	SliderControls.CameraFOV:Set(70)

	Lighting.Brightness = OldLighting.Brightness
	Lighting.ClockTime = OldLighting.ClockTime
	Lighting.FogEnd = OldLighting.FogEnd
	Lighting.FogStart = OldLighting.FogStart
	Lighting.GlobalShadows = OldLighting.GlobalShadows
	Lighting.Ambient = OldLighting.Ambient
	Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient

	Notify("Reset", "World reset")
end)

AddButton(ResetSec, "Unload UI", function()
	Gui:Destroy()
end)

--// Binds page

local AimBinds = MakeSection(BindsPage, "Aim Binds", "left")
AddBindRow(AimBinds, "RageBot", "Rage Bot", "F1", "Toggle")
AddBindRow(AimBinds, "RageAutoFire", "Rage Auto Fire", "F2", "Toggle")
AddBindRow(AimBinds, "LegitBot", "Legit Bot", "F3", "Toggle")
AddBindRow(AimBinds, "LegitTriggerbot", "Triggerbot", "F4", "Toggle")

local VisualBinds = MakeSection(BindsPage, "Visual Binds", "left")
AddBindRow(VisualBinds, "VisualsEnabled", "Visuals", "F5", "Toggle")
AddBindRow(VisualBinds, "BoxESP", "Box ESP", "F6", "Toggle")
AddBindRow(VisualBinds, "NameESP", "Name ESP", "F7", "Toggle")
AddBindRow(VisualBinds, "HealthESP", "Health ESP", "F8", "Toggle")
AddBindRow(VisualBinds, "Chams", "Chams", "F9", "Toggle")
AddBindRow(VisualBinds, "Glow", "Glow", "F10", "Toggle")

local MoveBinds = MakeSection(BindsPage, "Movement / Misc", "right")
AddBindRow(MoveBinds, "Thirdperson", "Thirdperson", "V", "Toggle")
AddBindRow(MoveBinds, "BunnyHop", "BunnyHop", "B", "Toggle")
AddBindRow(MoveBinds, "AutoStrafer", "Auto Strafer", "N", "Toggle")
AddBindRow(MoveBinds, "FastStop", "Fast Stop", "X", "Hold")
AddBindRow(MoveBinds, "Hitsounds", "Hitsounds", "H", "Toggle")
AddBindRow(MoveBinds, "Nightmode", "Nightmode", "J", "Toggle")

SetTab("Rage Bot")

--// Overlay

local Overlay = New("Frame", {
	Name = "Overlay",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ZIndex = 1
}, Gui)

local RageCircle = New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(State.RageFOV * 2, State.RageFOV * 2),
	BackgroundTransparency = 1,
	Visible = true,
	ZIndex = 4
}, Overlay)
Corner(RageCircle, 999)

New("UIStroke", {
	Color = Theme.Red,
	Transparency = 0.45,
	Thickness = 1
}, RageCircle)

local LegitCircle = New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(State.LegitFOV * 2, State.LegitFOV * 2),
	BackgroundTransparency = 1,
	Visible = true,
	ZIndex = 4
}, Overlay)
Corner(LegitCircle, 999)

New("UIStroke", {
	Color = Theme.Accent,
	Transparency = 0.35,
	Thickness = 1
}, LegitCircle)

--// Dragging

local draggingMenu = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingMenu and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--// Inputs

UIS.InputBegan:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		HoldingRMB = true
	end

	if input.KeyCode == Enum.KeyCode.W then Keys.W = true end
	if input.KeyCode == Enum.KeyCode.A then Keys.A = true end
	if input.KeyCode == Enum.KeyCode.S then Keys.S = true end
	if input.KeyCode == Enum.KeyCode.D then Keys.D = true end
	if input.KeyCode == Enum.KeyCode.Space then Keys.Space = true end

	if input.KeyCode == MENU_KEY and not UIS:GetFocusedTextBox() then
		State.MenuOpen = not State.MenuOpen
		Main.Visible = State.MenuOpen
		return
	end

	if ProcessBindInput(input, true) then
		return
	end

	if gp then return end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		HoldingRMB = false
	end

	if input.KeyCode == Enum.KeyCode.W then Keys.W = false end
	if input.KeyCode == Enum.KeyCode.A then Keys.A = false end
	if input.KeyCode == Enum.KeyCode.S then Keys.S = false end
	if input.KeyCode == Enum.KeyCode.D then Keys.D = false end
	if input.KeyCode == Enum.KeyCode.Space then Keys.Space = false end

	ProcessBindInput(input, false)
end)

--// ESP

local ESPCache = {}

local function ClearESP(plr)
	local data = ESPCache[plr]
	if not data then return end

	for _, obj in pairs(data.Objects) do
		if obj and obj.Destroy then
			obj:Destroy()
		end
	end

	ESPCache[plr] = nil
end

local function CreateESP(plr)
	if plr == LocalPlayer or ESPCache[plr] then return end

	local box = New("Frame", {
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 8
	}, Overlay)

	local boxStroke = New("UIStroke", {
		Color = Theme.Accent,
		Transparency = 0.05,
		Thickness = 1
	}, box)

	local corners = {}
	for i = 1, 8 do
		corners[i] = New("Frame", {
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 9
		}, Overlay)
	end

	local name = New("TextLabel", {
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.Text,
		TextStrokeTransparency = 0.1,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 11
	}, Overlay)

	local bottom = New("TextLabel", {
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.Text,
		TextStrokeTransparency = 0.1,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		Visible = false,
		ZIndex = 11
	}, Overlay)

	local hpBack = New("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 8
	}, Overlay)

	local hpFill = New("Frame", {
		BackgroundColor3 = Theme.Green,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 9
	}, hpBack)

	local highlight = New("Highlight", {
		Enabled = false,
		FillColor = Theme.Accent,
		OutlineColor = Color3.fromRGB(230, 245, 255),
		FillTransparency = 0.78,
		OutlineTransparency = 0.08
	}, Gui)

	local objects = {box, boxStroke, name, bottom, hpBack, hpFill, highlight}
	for _, c in ipairs(corners) do
		table.insert(objects, c)
	end

	ESPCache[plr] = {
		Objects = objects,
		Box = box,
		BoxStroke = boxStroke,
		Corners = corners,
		Name = name,
		Bottom = bottom,
		HPBack = hpBack,
		HPFill = hpFill,
		Highlight = highlight
	}
end

local function HideESP(data)
	data.Box.Visible = false
	data.Name.Visible = false
	data.Bottom.Visible = false
	data.HPBack.Visible = false
	data.Highlight.Enabled = false

	for _, c in ipairs(data.Corners) do
		c.Visible = false
	end
end

local function GetBox2D(char)
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")

	if not root or not hum then
		return nil
	end

	local topWorld = root.Position + Vector3.new(0, 3.2, 0)
	local bottomWorld = root.Position - Vector3.new(0, 3.2, 0)

	local top, topOn = Camera:WorldToViewportPoint(topWorld)
	local bottom, bottomOn = Camera:WorldToViewportPoint(bottomWorld)

	if top.Z <= 0 or bottom.Z <= 0 then return nil end
	if not topOn and not bottomOn then return nil end

	local h = math.abs(bottom.Y - top.Y)
	local w = h * 0.45

	local x1 = bottom.X - w / 2
	local x2 = bottom.X + w / 2
	local y1 = top.Y
	local y2 = bottom.Y

	return x1, y1, x2, y2
end

local function SetCornerBox(corners, x, y, w, h, color)
	local len = math.clamp(math.min(w, h) * 0.25, 8, 22)
	local thick = 2

	local p = {
		{x, y, len, thick}, {x, y, thick, len},
		{x + w - len, y, len, thick}, {x + w - thick, y, thick, len},
		{x, y + h - thick, len, thick}, {x, y + h - len, thick, len},
		{x + w - len, y + h - thick, len, thick}, {x + w - thick, y + h - len, thick, len}
	}

	for i, c in ipairs(corners) do
		c.Visible = true
		c.Position = UDim2.fromOffset(p[i][1], p[i][2])
		c.Size = UDim2.fromOffset(p[i][3], p[i][4])
		c.BackgroundColor3 = color
	end
end

local function UpdateESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			CreateESP(plr)

			local data = ESPCache[plr]
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local myRoot = GetRoot(LocalPlayer)

			if not data or not char or not root or not hum or hum.Health <= 0 or not myRoot then
				if data then
					HideESP(data)
				end
				continue
			end

			local distance = (root.Position - myRoot.Position).Magnitude

			if not State.VisualsEnabled or not IsEnemyForVisuals(plr) or distance > State.ESPMaxDistance then
				HideESP(data)
				continue
			end

			local x1, y1, x2, y2 = GetBox2D(char)
			if not x1 then
				HideESP(data)
				continue
			end

			local color = Theme.Accent
			local w = x2 - x1
			local h = y2 - y1

			data.Box.Visible = State.BoxESP and not State.CornerBox
			data.Box.Position = UDim2.fromOffset(x1, y1)
			data.Box.Size = UDim2.fromOffset(w, h)
			data.BoxStroke.Color = color

			for _, c in ipairs(data.Corners) do
				c.Visible = false
			end

			if State.CornerBox then
				SetCornerBox(data.Corners, x1, y1, w, h, color)
			end

			data.Highlight.Adornee = char
			data.Highlight.Enabled = State.Chams or State.Glow
			data.Highlight.FillColor = color
			data.Highlight.OutlineColor = State.Glow and Theme.Accent or Color3.fromRGB(230, 245, 255)
			data.Highlight.FillTransparency = State.Chams and 0.78 or 1
			data.Highlight.OutlineTransparency = State.Glow and 0.08 or 1
			data.Highlight.DepthMode = State.ChamsXRay and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

			local topParts = {}
			local bottomParts = {}

			if State.NameESP then
				table.insert(topParts, plr.Name)
			end

			if State.DistanceESP then
				table.insert(bottomParts, math.floor(distance) .. " studs")
			end

			if State.HealthESP then
				table.insert(bottomParts, "HP: " .. math.floor(hum.Health))
			end

			data.Name.Visible = #topParts > 0
			data.Name.Text = table.concat(topParts, " | ")
			data.Name.Position = UDim2.fromOffset(x1 - 40, y1 - 18)
			data.Name.Size = UDim2.fromOffset(w + 80, 16)

			data.Bottom.Visible = #bottomParts > 0
			data.Bottom.Text = table.concat(bottomParts, " | ")
			data.Bottom.Position = UDim2.fromOffset(x1 - 50, y2 + 2)
			data.Bottom.Size = UDim2.fromOffset(w + 100, 16)

			data.HPBack.Visible = State.HealthESP
			data.HPBack.Position = UDim2.fromOffset(x1 - 7, y1)
			data.HPBack.Size = UDim2.fromOffset(4, h)

			local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
			data.HPFill.Size = UDim2.new(1, 0, hp, 0)
			data.HPFill.Position = UDim2.new(0, 0, 1 - hp, 0)
			data.HPFill.BackgroundColor3 = hp > 0.5 and Theme.Green or Theme.Red
		end
	end
end

Players.PlayerRemoving:Connect(ClearESP)

--// Aim system

local function GetAimPart(char, hitbox)
	local part = char:FindFirstChild(hitbox)

	if not part then
		part = char:FindFirstChild("Head")
			or char:FindFirstChild("HumanoidRootPart")
			or char:FindFirstChild("UpperTorso")
			or char:FindFirstChild("Torso")
	end

	return part
end

local function IsVisible(part, targetChar)
	local myChar = GetChar(LocalPlayer)
	if not myChar then return true end

	local origin = Camera.CFrame.Position
	local direction = part.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {myChar}

	local result = workspace:Raycast(origin, direction, params)
	if not result then
		return true
	end

	return result.Instance:IsDescendantOf(targetChar)
end

local function GetBestAimTarget(mode)
	local isRage = mode == "Rage"

	local enabled = isRage and State.RageBot or State.LegitBot
	if not enabled then return nil end

	local activation = isRage and State.RageActivation or State.LegitActivation
	if activation == "Hold RMB" and not HoldingRMB then
		return nil
	end

	local teamCheck = isRage and State.RageTeamCheck or State.LegitTeamCheck
	local wallCheck = isRage and State.RageWallCheck or State.LegitWallCheck
	local hitbox = isRage and State.RageHitbox or State.LegitHitbox
	local fov = isRage and State.RageFOV or State.LegitFOV
	local maxDistance = isRage and State.RageMaxDistance or State.LegitMaxDistance
	local selection = isRage and State.RageTargetSelection or "FOV"

	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	local bestPart = nil
	local bestPlr = nil
	local bestScore = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if IsEnemyForAim(plr, teamCheck) then
			local char = plr.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local part = char and GetAimPart(char, hitbox)

			if hum and hum.Health > 0 and root and part then
				local worldDistance = (part.Position - Camera.CFrame.Position).Magnitude

				if worldDistance <= maxDistance then
					if not wallCheck or IsVisible(part, char) then
						local screen, onScreen = Camera:WorldToViewportPoint(part.Position)

						if onScreen and screen.Z > 0 then
							local screenDistance = (Vector2.new(screen.X, screen.Y) - center).Magnitude

							if screenDistance <= fov then
								local score = screenDistance

								if selection == "Distance" then
									score = worldDistance
								elseif selection == "Health" then
									score = hum.Health
								end

								if score < bestScore then
									bestScore = score
									bestPart = part
									bestPlr = plr
								end
							end
						end
					end
				end
			end
		end
	end

	return bestPart, bestPlr
end

local function AimAt(part, smooth, prediction)
	if not part then return end

	local velocity = part.AssemblyLinearVelocity or Vector3.zero
	local targetPos = part.Position + velocity * prediction

	local current = Camera.CFrame
	local wanted = CFrame.new(current.Position, targetPos)

	local alpha = math.clamp(1 / math.max(smooth, 1), 0.01, 1)
	Camera.CFrame = current:Lerp(wanted, alpha)
end

local function GetEquippedTool()
	local char = GetChar(LocalPlayer)
	if not char then return nil end
	return char:FindFirstChildOfClass("Tool")
end

local function FireWeapon(doubleTap)
	local now = os.clock()
	if now - LastFire < 0.06 then
		return
	end

	LastFire = now

	local tool = GetEquippedTool()
	if not tool then return end

	pcall(function()
		tool:Activate()
	end)

	if doubleTap then
		task.delay(0.035, function()
			local secondTool = GetEquippedTool()
			if secondTool then
				pcall(function()
					secondTool:Activate()
				end)
			end
		end)
	end
end

local function ApplyQuickStop()
	local root = GetRoot(LocalPlayer)
	local hum = GetHumanoid(LocalPlayer)

	if not root or not hum then return end
	if hum.FloorMaterial == Enum.Material.Air then return end

	local v = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(v.X * 0.12, v.Y, v.Z * 0.12)
end

local function UpdateAim()
	if State.RageBot then
		local target = GetBestAimTarget("Rage")

		if target then
			if State.RageQuickStop then
				ApplyQuickStop()
			end

			AimAt(target, State.RageSmooth, State.RagePrediction)

			if State.RageAutoFire then
				if math.random(1, 100) <= State.RageHitchance then
					FireWeapon(State.RageDoubleTap)
				end
			end
		end
	end

	if State.LegitBot then
		local target = GetBestAimTarget("Legit")

		if target then
			AimAt(target, State.LegitSmooth, State.LegitPrediction)
		end
	end
end

local function UpdateTriggerbot()
	if not State.LegitTriggerbot then return end

	local now = os.clock()
	if now - LastTrigger < State.LegitTriggerDelay / 1000 then
		return
	end

	local ray = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	local myChar = GetChar(LocalPlayer)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = myChar and {myChar} or {}

	local result = workspace:Raycast(ray.Origin, ray.Direction * State.LegitMaxDistance, params)
	if not result then return end

	local model = result.Instance:FindFirstAncestorOfClass("Model")
	if not model then return end

	local plr = Players:GetPlayerFromCharacter(model)
	if not IsEnemyForAim(plr, State.LegitTeamCheck) then return end

	local hum = model:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	LastTrigger = now
	FireWeapon(false)
end

--// World

local function ApplyWorld()
	Camera.FieldOfView = State.CameraFOV

	if State.Nightmode then
		Lighting.ClockTime = 0
		Lighting.Brightness = 1
		Lighting.Ambient = Color3.fromRGB(45, 55, 85)
		Lighting.OutdoorAmbient = Color3.fromRGB(25, 30, 50)
	else
		Lighting.ClockTime = OldLighting.ClockTime
	end

	if State.Fullbright then
		Lighting.Brightness = State.Brightness
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	elseif not State.Nightmode then
		Lighting.Brightness = OldLighting.Brightness
		Lighting.GlobalShadows = OldLighting.GlobalShadows
		Lighting.Ambient = OldLighting.Ambient
		Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
	end

	if State.RemoveFog then
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
	else
		Lighting.FogEnd = OldLighting.FogEnd
		Lighting.FogStart = OldLighting.FogStart
	end

	if State.SkyColor == "Blue" then
		Lighting.Ambient = Color3.fromRGB(50, 90, 160)
	elseif State.SkyColor == "Purple" then
		Lighting.Ambient = Color3.fromRGB(90, 50, 140)
	elseif State.SkyColor == "Red" then
		Lighting.Ambient = Color3.fromRGB(120, 45, 45)
	elseif State.SkyColor == "Black" then
		Lighting.Ambient = Color3.fromRGB(10, 10, 15)
	end
end

--// Movement

local function ApplyMovement()
	local hum = GetHumanoid(LocalPlayer)
	local root = GetRoot(LocalPlayer)

	if not hum or not root then return end

	if State.BunnyHop and Keys.Space and hum.FloorMaterial ~= Enum.Material.Air then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end

	if State.AutoStrafer and hum.FloorMaterial == Enum.Material.Air then
		local move = Vector3.zero

		if State.AutoStraferMode == "Legit" then
			if Keys.A then move -= Camera.CFrame.RightVector end
			if Keys.D then move += Camera.CFrame.RightVector end
		else
			local side = math.sin(os.clock() * 10) > 0 and 1 or -1
			move = Camera.CFrame.RightVector * side
		end

		if move.Magnitude > 0 then
			hum:Move(move, false)
		end
	end

	if State.FastStop and hum.FloorMaterial ~= Enum.Material.Air then
		local moving = Keys.W or Keys.A or Keys.S or Keys.D
		if not moving then
			local v = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(v.X * 0.2, v.Y, v.Z * 0.2)
		end
	end
end

--// Thirdperson

local function ApplyThirdperson()
	if State.Thirdperson then
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		LocalPlayer.CameraMinZoomDistance = State.ThirdpersonDistance
		LocalPlayer.CameraMaxZoomDistance = State.ThirdpersonDistance
	else
		LocalPlayer.CameraMode = OldCamera.Mode
		LocalPlayer.CameraMinZoomDistance = OldCamera.MinZoom
		LocalPlayer.CameraMaxZoomDistance = OldCamera.MaxZoom
	end
end

--// Hitsounds

local LastHealth = {}
local LastSound = 0

local function PlayHitSound()
	if not State.Hitsounds then return end

	if os.clock() - LastSound < 0.08 then
		return
	end

	LastSound = os.clock()

	local sound = Instance.new("Sound")
	sound.SoundId = HitSounds[State.HitSoundType] or HitSounds.Neverlose
	sound.Volume = 0.7
	sound.Parent = SoundService
	sound:Play()

	task.delay(2, function()
		if sound then
			sound:Destroy()
		end
	end)
end

local function WatchHumanoid(plr, hum)
	if not hum or LastHealth[hum] then return end

	LastHealth[hum] = hum.Health

	hum.HealthChanged:Connect(function(newHealth)
		local old = LastHealth[hum] or newHealth

		if plr ~= LocalPlayer and newHealth < old then
			PlayHitSound()
		end

		LastHealth[hum] = newHealth
	end)
end

local function WatchPlayer(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(0.3)

		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			WatchHumanoid(plr, hum)
		end
	end)

	if plr.Character then
		local hum = plr.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			WatchHumanoid(plr, hum)
		end
	end
end

for _, plr in ipairs(Players:GetPlayers()) do
	WatchPlayer(plr)
end

Players.PlayerAdded:Connect(WatchPlayer)

--// Indicators

local IndicatorFrame = New("Frame", {
	Size = UDim2.fromOffset(220, 260),
	Position = UDim2.fromOffset(18, 120),
	BackgroundTransparency = 1,
	ZIndex = 30
}, Gui)

New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 4)
}, IndicatorFrame)

local KeybindFrame = New("Frame", {
	Size = UDim2.fromOffset(240, 260),
	Position = UDim2.new(1, -260, 0, 120),
	BackgroundTransparency = 1,
	ZIndex = 30
}, Gui)

New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 4)
}, KeybindFrame)

local Watermark = New("TextLabel", {
	Size = UDim2.fromOffset(280, 26),
	Position = UDim2.fromOffset(18, 18),
	BackgroundColor3 = Color3.fromRGB(8, 16, 26),
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Text = "  NEVERBLOX v2 | " .. LocalPlayer.Name,
	TextColor3 = Theme.Text,
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 31
}, Gui)
Corner(Watermark, 5)

local ActiveIndicators = {}
local ActiveBindLabels = {}

local function MakeSmallLabel(parent, text, color)
	local item = New("TextLabel", {
		Size = UDim2.fromOffset(220, 22),
		BackgroundColor3 = Color3.fromRGB(8, 16, 26),
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Text = "  " .. text,
		TextColor3 = color or Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 31
	}, parent)

	Corner(item, 4)
	return item
end

local function UpdateIndicators()
	for _, obj in ipairs(ActiveIndicators) do
		obj:Destroy()
	end

	for _, obj in ipairs(ActiveBindLabels) do
		obj:Destroy()
	end

	table.clear(ActiveIndicators)
	table.clear(ActiveBindLabels)

	Watermark.Visible = State.Watermark
	IndicatorFrame.Visible = State.Indicators
	KeybindFrame.Visible = State.KeybindList

	if State.Indicators then
		local items = {}

		if State.RageBot then table.insert(items, {"RAGE", Theme.Red}) end
		if State.RageAutoFire then table.insert(items, {"AUTOFIRE", Theme.Red}) end
		if State.LegitBot then table.insert(items, {"LEGIT", Theme.Accent}) end
		if State.LegitTriggerbot then table.insert(items, {"TRIGGER", Theme.Yellow}) end
		if State.VisualsEnabled then table.insert(items, {"VISUALS", Theme.Accent}) end
		if State.Chams then table.insert(items, {"CHAMS", Theme.Accent}) end
		if State.Glow then table.insert(items, {"GLOW", Theme.Accent}) end
		if State.BunnyHop then table.insert(items, {"BHOP", Theme.Green}) end
		if State.AutoStrafer then table.insert(items, {"STRAFE " .. State.AutoStraferMode, Theme.Green}) end
		if State.FastStop then table.insert(items, {"FAST STOP", Theme.Yellow}) end
		if State.Thirdperson then table.insert(items, {"THIRDPERSON", Theme.Accent}) end
		if State.Nightmode then table.insert(items, {"NIGHTMODE", Theme.Accent}) end
		if State.Hitsounds then table.insert(items, {"HITSOUNDS", Theme.Yellow}) end

		for _, item in ipairs(items) do
			table.insert(ActiveIndicators, MakeSmallLabel(IndicatorFrame, item[1], item[2]))
		end
	end

	if State.KeybindList then
		table.insert(ActiveBindLabels, MakeSmallLabel(KeybindFrame, "KEYBINDS", Theme.Accent))

		for stateKey, bind in pairs(Keybinds) do
			local active = GetBoundState(stateKey)

			if bind.Mode == "Always" or active then
				local text = bind.Title .. " [" .. KeyToText(bind.Key) .. "] " .. bind.Mode
				table.insert(ActiveBindLabels, MakeSmallLabel(KeybindFrame, text, Theme.Text))
			end
		end
	end
end

--// Runtime

local lastSlowUpdate = 0

RunService.RenderStepped:Connect(function()
	Camera = workspace.CurrentCamera or Camera

	ApplyAlwaysBinds()

	RageCircle.Visible = State.FOVCircles and State.RageBot
	RageCircle.Size = UDim2.fromOffset(State.RageFOV * 2, State.RageFOV * 2)

	LegitCircle.Visible = State.FOVCircles and State.LegitBot
	LegitCircle.Size = UDim2.fromOffset(State.LegitFOV * 2, State.LegitFOV * 2)

	UpdateAim()
	UpdateTriggerbot()
	UpdateESP()
	ApplyMovement()
	ApplyThirdperson()

	if os.clock() - lastSlowUpdate > 0.2 then
		lastSlowUpdate = os.clock()
		ApplyWorld()
		UpdateIndicators()
	end
end)

PresetButton.MouseButton1Click:Connect(function()
	SetTab("Configs")
end)

InfoButton.MouseButton1Click:Connect(function()
	Notify("NEVERBLOX", "Menu key: RightShift")
end)

Notify("Welcome", "NEVERBLOX v2 Aim loaded")