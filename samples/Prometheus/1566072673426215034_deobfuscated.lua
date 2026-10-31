-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = Workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local Event = ReplicatedStorage:WaitForChild("Event", 10)
local VirtualUser = game:GetService("VirtualUser")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "DDARIUSPR_Notifications"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Name = "NotificationHolder"
Frame.AnchorPoint = Vector2.new(1, 0)
Frame.Position = UDim2.new(1, -22, 0, 22)
Frame.Size = UDim2.new(0, 330, 1, -44)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = UDim.new(0, 9)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Frame

local layoutOrder = 0
local t1 = {
	Base = Color3.fromRGB(7, 9, 16),
	Panel = Color3.fromRGB(12, 15, 25),
	Panel2 = Color3.fromRGB(16, 20, 32),
	Line = Color3.fromRGB(38, 47, 68),
	Text = Color3.fromRGB(232, 238, 248),
	Muted = Color3.fromRGB(132, 145, 168),
	Accent = Color3.fromRGB(83, 224, 255),
	Accent2 = Color3.fromRGB(145, 102, 255),
	Success = Color3.fromRGB(93, 232, 170),
	Error = Color3.fromRGB(255, 92, 110),
	Warning = Color3.fromRGB(255, 190, 85),
	Info = Color3.fromRGB(83, 224, 255)
}

local function createUICorner(p1, p2)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p2 or 12)
	UICorner.Parent = p1

	return UICorner
end
local function createUIStroke(p3, p4, p5, p6)
	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = p4
	UIStroke.Thickness = p5 or 1
	UIStroke.Transparency = p6 or 0
	UIStroke.Parent = p3

	return UIStroke
end

local v22 = nil

local function v23(p7, p8)
	v22("SUCCESS", p7, p8 or 3, "success")
end

v22 = function(p9, p10, p11, p12)
	local v24 = p11 or 4
	local v25 = string.lower(p12 or "info")

	layoutOrder = layoutOrder + 1

	local Info = t1.Info
	local text = "◆"

	if v25 == "success" then
		Info = t1.Success
		text = "✓"
	elseif v25 == "error" then
		Info = t1.Error
		text = "!"
	elseif v25 == "warning" then
		Info = t1.Warning
		text = "!"
	end

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Notification_" .. layoutOrder
	Frame2.Size = UDim2.new(1, 0, 0, 76)
	Frame2.BackgroundColor3 = t1.Base
	Frame2.BackgroundTransparency = 1
	Frame2.BorderSizePixel = 0
	Frame2.LayoutOrder = layoutOrder
	Frame2.ClipsDescendants = true
	Frame2.Parent = Frame
	createUICorner(Frame2, 13)

	local v29 = createUIStroke(Frame2, t1.Line, 1, 1)
	local Frame3 = Instance.new("Frame")

	Frame3.Name = "Accent"
	Frame3.Size = UDim2.new(0, 3, 0, 0)
	Frame3.Position = UDim2.new(0, 0, 0.5, 0)
	Frame3.AnchorPoint = Vector2.new(0, 0.5)
	Frame3.BackgroundColor3 = Info
	Frame3.BackgroundTransparency = 1
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2
	createUICorner(Frame3, 3)

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 34, 0, 34)
	Frame4.Position = UDim2.new(0, 13, 0, 13)
	Frame4.BackgroundColor3 = Info
	Frame4.BackgroundTransparency = 1
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame2
	createUICorner(Frame4, 10)

	local v32 = createUIStroke(Frame4, Info, 1, 1)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = text
	TextLabel.TextColor3 = Info
	TextLabel.TextTransparency = 1
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextSize = 15
	TextLabel.Parent = Frame4

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Position = UDim2.new(0, 59, 0, 10)
	TextLabel2.Size = UDim2.new(1, -72, 0, 18)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "DDARIUSPR  /  " .. tostring(p9)
	TextLabel2.TextColor3 = t1.Text
	TextLabel2.TextTransparency = 1
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 10
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame2

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Position = UDim2.new(0, 59, 0, 29)
	TextLabel3.Size = UDim2.new(1, -72, 0, 28)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = tostring(p10)
	TextLabel3.TextColor3 = t1.Muted
	TextLabel3.TextTransparency = 1
	TextLabel3.Font = Enum.Font.GothamMedium
	TextLabel3.TextSize = 9
	TextLabel3.TextWrapped = true
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel3.Parent = Frame2

	local Frame5 = Instance.new("Frame")

	Frame5.Position = UDim2.new(0, 13, 1, -5)
	Frame5.Size = UDim2.new(1, -26, 0, 2)
	Frame5.BackgroundColor3 = t1.Line
	Frame5.BackgroundTransparency = 1
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame2
	createUICorner(Frame5, 2)

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(1, 0, 1, 0)
	Frame6.BackgroundColor3 = Info
	Frame6.BackgroundTransparency = 1
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5
	createUICorner(Frame6, 2)
	Frame2.Position = UDim2.new(1, 35, 0, 0)

	local tweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v39 = TweenService

	v39.Create(v39, Frame2, tweenInfo, {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.05
	}):Play()
	TweenService:Create(v29, tweenInfo, {
		Transparency = 0.25
	}):Play()

	local v40 = TweenService
	local UDim2_ = UDim2

	v40.Create(v40, Frame3, tweenInfo, {
		Size = UDim2_.new(0, 3, 0, 46),
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(Frame4, tweenInfo, {
		BackgroundTransparency = 0.86
	}):Play()
	TweenService:Create(v32, tweenInfo, {
		Transparency = 0.35
	}):Play()
	TweenService:Create(TextLabel, tweenInfo, {
		TextTransparency = 0
	}):Play()
	TweenService:Create(TextLabel2, tweenInfo, {
		TextTransparency = 0
	}):Play()
	TweenService:Create(TextLabel3, tweenInfo, {
		TextTransparency = 0
	}):Play()
	TweenService:Create(Frame5, tweenInfo, {
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(Frame6, tweenInfo, {
		BackgroundTransparency = 0
	}):Play()
	task.delay(0.35, function()
		if Frame2.Parent then
			local v42 = TweenService
			local v43 = Frame6
			local tweenInfoNew = TweenInfo.new
			local v45 = v24 - 0.35

			v42:Create(v43, tweenInfoNew(math.max(v45, 0.1), Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 1, 0)
			}):Play()
		end
	end)

	local function v46()
		if not (Frame2 and Frame2.Parent) then
			return
		end

		local tweenInfo2 = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

		TweenService:Create(Frame2, tweenInfo2, {
			Position = UDim2.new(1, 35, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(v29, tweenInfo2, {
			Transparency = 1
		}):Play()
		TweenService:Create(Frame3, tweenInfo2, {
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(Frame4, tweenInfo2, {
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(v32, tweenInfo2, {
			Transparency = 1
		}):Play()
		TweenService:Create(TextLabel, tweenInfo2, {
			TextTransparency = 1
		}):Play()
		TweenService:Create(TextLabel2, tweenInfo2, {
			TextTransparency = 1
		}):Play()
		TweenService:Create(TextLabel3, tweenInfo2, {
			TextTransparency = 1
		}):Play()
		TweenService:Create(Frame5, tweenInfo2, {
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(Frame6, tweenInfo2, {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.35)

		if not Frame2 then
			return
		end

		Frame2:Destroy()
	end

	task.delay(v24, v46)
end

local function v48(p13, p14)
	v22("INFO", p13, p14 or 3, "info")
end
local function v49(p15, p16)
	v22("ERROR", p15, p16 or 4, "error")
end

local genv = getgenv()
local nw = {
	Aimbot = {
		Enabled = false,
		PlaneAimbot = false,
		BulletSpeed = 800,
		Gravity = 196.2
	},
	ESP = {
		Players = false,
		Vehicles = false,
		Islands = false,
		Harbors = false
	},
	Weapon = {
		RapidFire = false,
		ShootRPG = false,
		KillAll = false,
		InfiniteAmmo = false
	},
	Movement = {
		Speed = false,
		SpeedVal = 32,
		ShipSpeed = false,
		ShipSpeedVal = 2,
		WalkOnWater = false
	},
	Misc = {
		Godmode = false,
		AntiAFK = false,
		AutoWinUSA = false,
		AutoWinJAPAN = false
	},
	Settings = {
		ToggleKey = Enum.KeyCode.Z,
		MobileButton = false
	}
}

genv.NW = nw

local v52 = nil

local function v53()
	local Character = LocalPlayer.Character

	if not Character then
		return Character
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	return Character
end
local function v55(p17)
	Event:FireServer("VSpawn", "Bomber")
	v23("Bomber spawned for " .. p17)
end
local function v56(p18)
	local Name = LocalPlayer.Name

	for _, child in pairs(Workspace:GetChildren()) do
		if child.Name == "Bomber" then
			local Seat = child:FindFirstChild("Seat")

			if Seat then
				local BillboardGui = Seat:FindFirstChild("BillboardGui")

				if BillboardGui then
					local TextLabel = BillboardGui:FindFirstChild("TextLabel")

					if TextLabel then
						TextLabel = TextLabel.Text == Name
					end

					if TextLabel then
						v48("Starting bombing run • " .. p18, 3)

						for i = 1, 28 do
							LocalPlayer.Character:MoveTo(Seat.Position)
							task.wait(2)
							child:MoveTo(child:GetPivot().Position)
							task.wait(0.3)
							Event:FireServer("bomb")
							task.wait(0.2)
							Event:FireServer("stopEngine")

							if i % 5 == 0 and true or i == 28 then
								v48("Bomb " .. i .. "/28 dropped", 2.2)
							end
						end

						v23("Bombing complete • " .. p18, 4)

						return
					end
				end
			end
		end
	end

	v49("No Bomber found for " .. Name, 5)
end
local function v64()
	local Character = LocalPlayer.Character

	if not Character then
		return Character
	end

	Character = Character:FindFirstChildOfClass("Humanoid")

	return Character
end
local function v66(p19)
	local v67 = v52()

	return not (v67 and p19) and math.huge or (v67.Position - p19.Position).Magnitude
end

v52 = v53

local function v68(p20)
	if p20 == LocalPlayer then
		return false
	elseif LocalPlayer.Team and p20.Team then
		return p20.TeamColor ~= LocalPlayer.TeamColor
	else
		return false
	end
end
local function v69(p21, p22, p23, p24)
	local v70 = CFrame.lookAt(p21, p22).LookVector:Dot(p23.Unit)
	local v71 = Workspace.Gravity - getgenv().NW.Aimbot.Gravity
	local v72 = (p22 - p21).Magnitude / (p24 - p23.Magnitude * v70)

	if v72 < 0 and true or v72 ~= v72 then
		return nil
	else
		local v73 = p22 - p21

		for _ = 1, 100 do
			local v75 = (v73.X + p23.X * v72) ^ 2 + (v73.Z + p23.Z * v72) ^ 2
			local v76 = math.sqrt(v75)
			local v77 = p24 ^ 4 - v71 * (v71 * v76 ^ 2 + 2 * (v73.Y + p23.Y * v72) * p24 ^ 2)
			local v78 = math.sqrt(v77)

			if v78 < 0 then
				return nil
			end

			local v79 = (p24 ^ 2 - v78) / (v71 * v76)
			local v80 = math.atan(v79)
			local v81 = v76 / (p24 * math.cos(v80)) - v72

			if math.abs(v81) <= 0.00001 then
				local v82 = p22 + p23 * v72 - p21
				local X = v82.X
				local Z = v82.Z

				return math.atan2(X, Z) + 3.141592653589793, v80, v76, v72
			end

			local v85 = (v73.X + p23.X * v72) * p23.X
			local v86 = v73.Z + p23.Z * v72
			local Z = p23.Z
			local v88 = -v71
			local v89 = (v85 + v86 * Z) / v76
			local v90 = (-(v88 * (v71 * v76 * v89 + p23.Y * p24 ^ 2) / v78) * v76 - (p24 ^ 2 - v78) * v89) / (v71 * v76 ^ 3 + (p24 ^ 2 - v78) ^ 2)
			local v91 = math.cos(v80)
			local v92 = v76 * math.sin(v80) * v90
			local v93 = p24 * v91 ^ 2
			local v94 = v89 / (p24 * v91) + v92 / v93 - 1

			if v94 == nil and true or v94 == 0 then
				return nil
			end

			v72 = v72 - v81 / v94
		end

		return nil
	end
end
local function v95()
	local v96 = Players
	local huge = math.huge
	local v98 = nil

	for _, player in pairs(v96.GetPlayers(v96)) do
		local Character = v68(player) and player.Character

		if Character then
			Character = player.Character:FindFirstChild("HumanoidRootPart")
		end

		if Character then
			local v102 = v66(player.Character.HumanoidRootPart)

			if v102 < huge then
				v98 = player
				huge = v102
			end
		end
	end

	return v98, huge
end

local Target = nil
local vector3 = nil
local t2 = {}
local Folder = Instance.new("Folder")

Folder.Name = "NWESPFolder"
Folder.Parent = Workspace

local function v107(p25, p26, p27, p28)
	local v108 = t2[p25]
	local adorn = v108 and v108.adorn

	if adorn then
		adorn = v108.adorn.Parent
	end

	if not adorn then
		local BoxHandleAdornment = Instance.new("BoxHandleAdornment")

		BoxHandleAdornment.Name = "NWESP"
		BoxHandleAdornment.Adornee = p26
		BoxHandleAdornment.AlwaysOnTop = true
		BoxHandleAdornment.Size = p26.Size + Vector3.new(1, 1, 1)
		BoxHandleAdornment.Color3 = p27
		BoxHandleAdornment.Transparency = 0.5
		BoxHandleAdornment.ZIndex = 1
		BoxHandleAdornment.Parent = Folder

		local BillboardGui = Instance.new("BillboardGui")

		BillboardGui.Name = "NWESPLabel"
		BillboardGui.Adornee = p26
		BillboardGui.Size = UDim2.new(0, 120, 0, 40)
		BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Parent = Folder

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p28 or ""
		TextLabel.TextColor3 = p27
		TextLabel.TextStrokeTransparency = 0.5
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 12
		TextLabel.Parent = BillboardGui
		t2[p25] = {
			adorn = BoxHandleAdornment,
			billboard = BillboardGui,
			label = TextLabel
		}

		return t2[p25]
	end

	v108.adorn.Color3 = p27
	v108.label.Text = p28 or ""
	v108.label.TextColor3 = p27

	if v108.adorn.Adornee == p26 then
		return v108
	end

	v108.adorn.Adornee = p26
	v108.billboard.Adornee = p26

	return v108
end
local function v113(p29)
	local v114 = t2[p29]

	if not v114 then
		return
	end

	if v114.adorn then
		pcall(function()
			v114.adorn:Destroy()
		end)
	end

	if v114.billboard then
		pcall(function()
			v114.billboard:Destroy()
		end)
	end

	t2[p29] = nil
end
local function v115()
	for k, _ in pairs(t2) do
		v113(k)
	end

	t2 = {}
end

local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "DariusPR_NavalCommand"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui2.Parent = PlayerGui

local t3 = {
	Base = Color3.fromRGB(7, 9, 16),
	Panel = Color3.fromRGB(12, 15, 25),
	Panel2 = Color3.fromRGB(16, 20, 32),
	Line = Color3.fromRGB(38, 47, 68),
	Text = Color3.fromRGB(232, 238, 248),
	Muted = Color3.fromRGB(132, 145, 168),
	Accent = Color3.fromRGB(83, 224, 255),
	Accent2 = Color3.fromRGB(145, 102, 255),
	Danger = Color3.fromRGB(255, 92, 110),
	Good = Color3.fromRGB(93, 232, 170)
}
local v120 = nil

local function createUIStroke2(p30, p31, p32, p33)
	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = p31
	UIStroke.Thickness = p32 or 1
	UIStroke.Transparency = p33 or 0
	UIStroke.Parent = p30

	return UIStroke
end
local function createTextLabel(p34, p35, p36, p37, p38, p39, p40)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p35
	TextLabel.TextSize = p36 or 12
	TextLabel.Font = p38 or Enum.Font.Gotham
	TextLabel.TextColor3 = p39 or v120.Text
	TextLabel.Position = p37 or UDim2.new()
	TextLabel.Size = UDim2.new(1, 0, 0, p36 + 8)
	TextLabel.TextXAlignment = p40 or Enum.TextXAlignment.Left
	TextLabel.Parent = p34

	return TextLabel
end

v120 = t3

local function createUICorner2(p41, p42)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p42 or 10)
	UICorner.Parent = p41

	return UICorner
end

local Frame2 = Instance.new("Frame")

Frame2.Name = "CommandDeck"
Frame2.Size = UDim2.new(0, 720, 0, 455)
Frame2.Position = UDim2.new(0.5, -360, 0.5, -228)
Frame2.BackgroundColor3 = v120.Base
Frame2.BorderSizePixel = 0
Frame2.ClipsDescendants = true
Frame2.Parent = ScreenGui2
createUICorner2(Frame2, 18)
createUIStroke2(Frame2, v120.Line, 1.2, 0.1)

local UIScale = Instance.new("UIScale")

UIScale.Scale = 1
UIScale.Parent = Frame2

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, -28, 0, 2)
Frame3.Position = UDim2.new(0, 14, 0, 12)
Frame3.BackgroundColor3 = v120.Accent
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame2
createUICorner2(Frame3, 2)

local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(1, -32, 0, 64)
Frame4.Position = UDim2.new(0, 16, 0, 20)
Frame4.BackgroundTransparency = 1
Frame4.Parent = Frame2

local Frame5 = Instance.new("Frame")

Frame5.Size = UDim2.new(0, 42, 0, 42)
Frame5.Position = UDim2.new(0, 0, 0, 7)
Frame5.BackgroundColor3 = v120.Panel2
Frame5.BorderSizePixel = 0
Frame5.Parent = Frame4
createUICorner2(Frame5, 12)
createUIStroke2(Frame5, v120.Accent2, 1, 0.25)
createTextLabel(Frame5, "DD", 14, UDim2.new(0, 0, 0, 8), Enum.Font.GothamBlack, v120.Accent, Enum.TextXAlignment.Center).Size = UDim2.new(1, 0, 0, 20)
createTextLabel(Frame4, "DDARIUSPR", 20, UDim2.new(0, 54, 0, 5), Enum.Font.GothamBlack, v120.Text).Size = UDim2.new(0, 300, 0, 25)
createTextLabel(Frame4, "NAVAL GUI  /  READY", 10, UDim2.new(0, 55, 0, 31), Enum.Font.GothamMedium, v120.Muted).Size = UDim2.new(0, 330, 0, 16)

local Frame6 = Instance.new("Frame")

Frame6.Size = UDim2.new(0, 122, 0, 30)
Frame6.Position = UDim2.new(1, -205, 0, 13)
Frame6.BackgroundColor3 = v120.Panel2
Frame6.BorderSizePixel = 0
Frame6.Parent = Frame4
createUICorner2(Frame6, 15)
createUIStroke2(Frame6, v120.Line, 1)

local Frame7 = Instance.new("Frame")

Frame7.Size = UDim2.new(0, 7, 0, 7)
Frame7.Position = UDim2.new(0, 12, 0.5, -3)
Frame7.BackgroundColor3 = v120.Good
Frame7.BorderSizePixel = 0
Frame7.Parent = Frame6
createUICorner2(Frame7, 10)
createTextLabel(Frame6, "READY TO USE", 9, UDim2.new(0, 27, 0, 6), Enum.Font.GothamBold, v120.Muted).Size = UDim2.new(1, -30, 0, 18)

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 32, 0, 32)
TextButton.Position = UDim2.new(1, -32, 0, 12)
TextButton.BackgroundColor3 = v120.Panel2
TextButton.Text = "×"
TextButton.TextColor3 = v120.Muted
TextButton.Font = Enum.Font.GothamMedium
TextButton.TextSize = 22
TextButton.BorderSizePixel = 0
TextButton.AutoButtonColor = false
TextButton.Parent = Frame4
createUICorner2(TextButton, 10)
TextButton.MouseEnter:Connect(function()
	TextButton.TextColor3 = v120.Danger
end)
TextButton.MouseLeave:Connect(function()
	TextButton.TextColor3 = v120.Muted
end)

local Frame8 = Instance.new("Frame")

Frame8.Size = UDim2.new(0, 150, 1, -108)
Frame8.Position = UDim2.new(0, 16, 0, 92)
Frame8.BackgroundColor3 = v120.Panel
Frame8.BorderSizePixel = 0
Frame8.Parent = Frame2
createUICorner2(Frame8, 14)
createUIStroke2(Frame8, v120.Line, 1, 0.15)
createTextLabel(Frame8, "MODULES", 9, UDim2.new(0, 15, 0, 12), Enum.Font.GothamBold, v120.Muted).Size = UDim2.new(1, -30, 0, 18)

local Frame9 = Instance.new("Frame")

Frame9.Size = UDim2.new(1, -16, 1, -48)
Frame9.Position = UDim2.new(0, 8, 0, 38)
Frame9.BackgroundTransparency = 1
Frame9.Parent = Frame8

local UIListLayout2 = Instance.new("UIListLayout")

UIListLayout2.Padding = UDim.new(0, 5)
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.Parent = Frame9

local Frame10 = Instance.new("Frame")

Frame10.Size = UDim2.new(1, -182, 1, -108)
Frame10.Position = UDim2.new(0, 174, 0, 92)
Frame10.BackgroundColor3 = v120.Panel
Frame10.BorderSizePixel = 0
Frame10.Parent = Frame2
createUICorner2(Frame10, 14)
createUIStroke2(Frame10, v120.Line, 1, 0.15)

local Frame11 = Instance.new("Frame")

Frame11.Size = UDim2.new(1, -24, 1, -58)
Frame11.Position = UDim2.new(0, 12, 0, 48)
Frame11.BackgroundTransparency = 1
Frame11.Parent = Frame10

local v140 = createTextLabel(Frame10, "", 16, UDim2.new(0, 16, 0, 10), Enum.Font.GothamBlack, v120.Text)

v140.Size = UDim2.new(1, -32, 0, 22)

local v141 = createTextLabel(Frame10, "", 9, UDim2.new(0, 16, 0, 29), Enum.Font.GothamMedium, v120.Muted)

v141.Size = UDim2.new(1, -32, 0, 15)

local v142 = nil

local function v143(p43)
	for _, v in ipairs(v142) do
		local visible = v.Name == p43

		v.Page.Visible = visible
		v.Button.BackgroundColor3 = visible and Color3.fromRGB(23, 28, 43) or v120.Panel2
		v.Button.TextColor3 = visible and v120.Text or v120.Muted
		v.Accent.Visible = visible

		if visible then
			v140.Text = v.Name
			v141.Text = v.Hint or ""
		end
	end
end
local function v147(p44)
	for k in pairs(t2) do
		local v149 = #p44

		if string.sub(k, 1, v149) == p44 then
			v113(k)
		end
	end
end

v142 = {}

local function v150(p45, p46, p47, p48, p49)
	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(1, 0, 0, 52)
	Frame12.BackgroundColor3 = v120.Panel2
	Frame12.BorderSizePixel = 0
	Frame12.LayoutOrder = p47
	Frame12.Parent = p45
	createUICorner2(Frame12, 11)
	createUIStroke2(Frame12, v120.Line, 1, 0.35)
	createTextLabel(Frame12, p46, 11, UDim2.new(0, 13, 0, 7), Enum.Font.GothamBold, v120.Text).Size = UDim2.new(1, -75, 0, 18)
	createTextLabel(Frame12, p49 or "", 8, UDim2.new(0, 13, 0, 27), Enum.Font.GothamMedium, v120.Muted).Size = UDim2.new(1, -75, 0, 15)

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0, 48, 0, 26)
	TextButton2.Position = UDim2.new(1, -60, 0.5, -13)
	TextButton2.BackgroundColor3 = Color3.fromRGB(28, 34, 49)
	TextButton2.Text = "OFF"
	TextButton2.TextColor3 = v120.Muted
	TextButton2.Font = Enum.Font.GothamBlack
	TextButton2.TextSize = 8
	TextButton2.BorderSizePixel = 0
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = Frame12
	createUICorner2(TextButton2, 8)

	local u153 = false

	local function v154(p50)
		u153 = p50 and true or false
		TextButton2.Text = u153 and "ON" or "OFF"
		TextButton2.BackgroundColor3 = u153 and v120.Accent2 or Color3.fromRGB(28, 34, 49)
		TextButton2.TextColor3 = u153 and Color3.fromRGB(255, 255, 255) or v120.Muted
		createUIStroke2(TextButton2, u153 and v120.Accent or v120.Line, 1, 0.15)
	end

	TextButton2.MouseButton1Click:Connect(function()
		v154(not u153)
		p48(u153)
	end)
	v154(false)

	return Frame12, function()
		return u153
	end, v154
end
local function createTextButton(p51, p52, p53, p54, p55)
	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, 0, 0, 48)
	TextButton2.BackgroundColor3 = v120.Panel2
	TextButton2.Text = ""
	TextButton2.BorderSizePixel = 0
	TextButton2.LayoutOrder = p53
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = p51
	createUICorner2(TextButton2, 11)
	createUIStroke2(TextButton2, v120.Line, 1, 0.35)
	createTextLabel(TextButton2, p52, 10, UDim2.new(0, 13, 0, 7), Enum.Font.GothamBold, v120.Text).Size = UDim2.new(1, -40, 0, 18)
	createTextLabel(TextButton2, p55 or "EXECUTE", 8, UDim2.new(0, 13, 0, 26), Enum.Font.GothamMedium, v120.Muted).Size = UDim2.new(1, -40, 0, 14)

	local v157 = createTextLabel(TextButton2, "›", 18, UDim2.new(1, -28, 0, 12), Enum.Font.GothamMedium, v120.Accent)

	v157.Size = UDim2.new(0, 18, 0, 22)
	v157.TextXAlignment = Enum.TextXAlignment.Center
	TextButton2.MouseEnter:Connect(function()
		TextButton2.BackgroundColor3 = Color3.fromRGB(22, 28, 43)
	end)
	TextButton2.MouseLeave:Connect(function()
		TextButton2.BackgroundColor3 = v120.Panel2
	end)
	TextButton2.MouseButton1Click:Connect(p54)

	return TextButton2
end

local t4 = {}

local function createScrollingFrame(p56, p57, p58)
	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = p56
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = v120.Accent
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.CanvasSize = UDim2.new()
	ScrollingFrame.Visible = false
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.Parent = Frame11

	local UIListLayout3 = Instance.new("UIListLayout")

	UIListLayout3.Padding = UDim.new(0, 7)
	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.Parent = ScrollingFrame

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingBottom = UDim.new(0, 12)
	UIPadding.Parent = ScrollingFrame

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Name = p56 .. "Button"
	TextButton2.Size = UDim2.new(1, 0, 0, 36)
	TextButton2.BackgroundColor3 = v120.Panel2
	TextButton2.Text = "  " .. p57 .. "   " .. p56
	TextButton2.TextColor3 = v120.Muted
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 11
	TextButton2.TextXAlignment = Enum.TextXAlignment.Left
	TextButton2.BorderSizePixel = 0
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = Frame9
	createUICorner2(TextButton2, 10)

	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(0, 3, 0, 20)
	Frame12.Position = UDim2.new(0, 0, 0.5, -10)
	Frame12.BackgroundColor3 = v120.Accent
	Frame12.BorderSizePixel = 0
	Frame12.Visible = false
	Frame12.Parent = TextButton2
	createUICorner2(Frame12, 3)

	local t5 = {
		Page = ScrollingFrame,
		Button = TextButton2,
		Accent = Frame12,
		Name = p56,
		Hint = p58
	}
	local v166 = v142

	table.insert(v166, t5)

	local v167 = t4

	table.insert(v167, t5)

	return ScrollingFrame
end
local function createFrame(p59, p60, p61, p62, p63, p64, p65)
	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(1, 0, 0, 58)
	Frame12.BackgroundColor3 = v120.Panel2
	Frame12.BorderSizePixel = 0
	Frame12.LayoutOrder = p61
	Frame12.Parent = p59
	createUICorner2(Frame12, 11)
	createUIStroke2(Frame12, v120.Line, 1, 0.35)

	local v170 = createTextLabel(Frame12, p60 .. "   " .. tostring(p64), 10, UDim2.new(0, 13, 0, 7), Enum.Font.GothamBold, v120.Text)

	v170.Size = UDim2.new(1, -26, 0, 18)

	local Frame13 = Instance.new("Frame")

	Frame13.Size = UDim2.new(1, -26, 0, 5)
	Frame13.Position = UDim2.new(0, 13, 0, 38)
	Frame13.BackgroundColor3 = Color3.fromRGB(31, 38, 54)
	Frame13.BorderSizePixel = 0
	Frame13.Parent = Frame12
	createUICorner2(Frame13, 5)

	local Frame14 = Instance.new("Frame")
	local uDim2New = UDim2.new
	local v174 = (p64 - p62) / (p63 - p62)

	Frame14.Size = uDim2New(math.clamp(v174, 0, 1), 0, 1, 0)
	Frame14.BackgroundColor3 = v120.Accent
	Frame14.BorderSizePixel = 0
	Frame14.Parent = Frame13
	createUICorner2(Frame14, 5)

	local Frame15 = Instance.new("Frame")

	Frame15.Size = UDim2.new(0, 10, 0, 10)
	Frame15.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame15.Position = UDim2.new(Frame14.Size.X.Scale, 0, 0.5, 0)
	Frame15.BackgroundColor3 = v120.Text
	Frame15.BorderSizePixel = 0
	Frame15.Parent = Frame13
	createUICorner2(Frame15, 8)

	local u176 = false

	local function v177(p66)
		local v178 = math.clamp((p66 - Frame13.AbsolutePosition.X) / Frame13.AbsoluteSize.X, 0, 1)
		local v179 = p62 + v178 * (p63 - p62) + 0.5
		local v180 = math.floor(v179)

		Frame14.Size = UDim2.new(v178, 0, 1, 0)
		Frame15.Position = UDim2.new(v178, 0, 0.5, 0)
		v170.Text = p60 .. "   " .. tostring(v180)
		p65(v180)
	end

	Frame13.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u176 = true
		v177(input.Position.X)
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not (u176 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		v177(input.Position.X)
	end)
	UserInputService.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
	end)

	return Frame12
end
local function createFrame2(p67, p68, p69)
	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(1, 0, 0, 22)
	Frame12.BackgroundTransparency = 1
	Frame12.LayoutOrder = p69
	Frame12.Parent = p67

	local Frame13 = Instance.new("Frame")

	Frame13.Size = UDim2.new(0, 3, 0, 12)
	Frame13.Position = UDim2.new(0, 0, 0.5, -6)
	Frame13.BackgroundColor3 = v120.Accent2
	Frame13.BorderSizePixel = 0
	Frame13.Parent = Frame12
	createUICorner2(Frame13, 3)
	createTextLabel(Frame12, p68, 9, UDim2.new(0, 11, 0, 2), Enum.Font.GothamBold, v120.Muted).Size = UDim2.new(1, -11, 0, 18)

	return Frame12
end

local aim = createScrollingFrame("AIM", "◈", "Precision controls / target acquisition")

createFrame2(aim, "PLANE TARGETING", 1)
v150(aim, "Plane Aimbot", 2, function(p70)
	getgenv().NW.Aimbot.PlaneAimbot = p70
end, "Enable guided plane targeting")
v150(aim, "Auto Target", 3, function(p71)
	getgenv().NW.Aimbot.Enabled = p71
end, "Lock onto the nearest valid target")
createFrame(aim, "Bullet Speed", 4, 200, 2000, 800, function(p72)
	getgenv().NW.Aimbot.BulletSpeed = p72
end)

local esp = createScrollingFrame("ESP", "◎", "Each visual layer works independently")

createFrame2(esp, "INDEPENDENT ESP", 1)
v150(esp, "Player ESP", 2, function(p73)
	getgenv().NW.ESP.Players = p73

	if p73 then
		return
	end

	v147("player_")
end, "Players only / team / distance")
v150(esp, "Vehicle ESP", 3, function(p74)
	getgenv().NW.ESP.Vehicles = p74

	if p74 then
		return
	end

	v147("vehicle_")
end, "Vehicles only / HP / distance")
v150(esp, "Island ESP", 4, function(p75)
	getgenv().NW.ESP.Islands = p75

	if p75 then
		return
	end

	v147("island_")
end, "Islands only / code / distance")
v150(esp, "Harbor ESP", 5, function(p76)
	getgenv().NW.ESP.Harbors = p76

	if p76 then
		return
	end

	v147("harbor_")
end, "Harbors only / HP / distance")

local weapons = createScrollingFrame("WEAPONS", "✦", "Weapon controls / manual activation")

createFrame2(weapons, "FIRE CONTROL", 1)
v150(weapons, "Rapid Fire", 2, function(p77)
	getgenv().NW.Weapon.RapidFire = p77
end, "Continuous tool activation")
v150(weapons, "Spam RPG", 3, function(p78)
	getgenv().NW.Weapon.ShootRPG = p78
end, "Fire RPG at mouse position every 0.1s")
v150(weapons, "Kill All Enemies", 4, function(p79)
	getgenv().NW.Weapon.KillAll = p79
end, "Throttled server targeting")

local move = createScrollingFrame("MOVE", "↯", "Mobility / movement tuning")

createFrame2(move, "PLAYER", 1)
createFrame(move, "WalkSpeed", 2, 16, 200, 32, function(p80)
	getgenv().NW.Movement.SpeedVal = p80
end)
v150(move, "Speed Boost", 3, function(p81)
	getgenv().NW.Movement.Speed = p81
end, "Apply selected walk speed")
createFrame(move, "Ship Speed", 4, 1, 10, 2, function(p82)
	getgenv().NW.Movement.ShipSpeedVal = p82
end)
v150(move, "Ship Speed Boost", 5, function(p83)
	getgenv().NW.Movement.ShipSpeed = p83
end, "Ship movement switch")

local Water = workspace:WaitForChild("Setting"):WaitForChild("VisualScene"):WaitForChild("Water")
local Setting = workspace:WaitForChild("Setting")
local v191 = Setting.WaitForChild(Setting, "WaterColliders")

local function v192(p84)
	local v193 = not p84:FindFirstChildOfClass("Humanoid")
	local v194 = p84.FindFirstChild(p84, "HumanoidRootPart")

	if v193 or not v194 then
		return
	end

	local Y = Water.Position.Y
	local v196 = Water.Size.Y / 2
	local GetBoundingBox = p84.GetBoundingBox
	local v198 = Y + v196
	local _, v200 = GetBoundingBox(p84)
	local v201 = v198 + v200.Y / 2 - 0.1
	local AssemblyLinearVelocity = v194.AssemblyLinearVelocity
	local cFrame = CFrame.new(v194.Position.X, v201, v194.Position.Z)
	local cFrame2 = CFrame.Angles
	local Y2 = v194.Orientation.Y

	v194.CFrame = cFrame * cFrame2(0, math.rad(Y2), 0)

	if not (AssemblyLinearVelocity.Y < 0) then
		return
	end

	v194.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
end
local function v206(p85)
	local GetDescendants = p85.GetDescendants
	local v208, v209, v210 = ipairs(GetDescendants(p85))
	local t6 = {}

	while true do
		local v212

		v210, v212 = v208(v209, v210)

		if not v210 then
			break
		end

		if v212:IsA("BasePart") then
			table.insert(t6, v212)
		end
	end

	if #t6 == 0 then
		return false
	else
		local v213 = v191

		for _, child in ipairs(v213.GetChildren(v213)) do
			if child:IsA("BasePart") then
				local partsInPart = workspace:GetPartsInPart(child)

				for _, v in ipairs(partsInPart) do
					if v:IsDescendantOf(p85) then
						return true
					end
				end
			end
		end

		return false
	end
end

local u219 = nil
local u220 = false

local function v221()
	if not u219 then
		u220 = false

		return
	end

	u219:Disconnect()
	u219 = nil
	u220 = false
end

v150(move, "Walk on Water", 6, function(p86)
	getgenv().NW.Movement.WalkOnWater = p86

	if not p86 then
		v221()

		return
	end

	if u219 then
		u219:Disconnect()
	end

	RunService.Heartbeat:Connect(function()
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		if not Character:FindFirstChildOfClass("Humanoid") then
			return
		end

		local v223 = v206(Character)
		local v224

		if v223 then
			v224 = not u220
		else
			v224 = v223
		end

		if v224 then
			u220 = true
			v192(Character)
		end

		if not v223 then
			u220 = false
		end

		local HumanoidRootPart = u220 and Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

		if not (AssemblyLinearVelocity.Y < 0) then
			return
		end

		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
	end)
end, "Snap to water surface using water colliders")

local teleport = createScrollingFrame("TELEPORT", "⌖", "Navigation / instant destinations")

createFrame2(teleport, "LOBBIES", 1)
createTextButton(teleport, "Japan Lobby", 2, function()
	local v228 = v52()

	if not v228 then
		return
	end

	v228.CFrame = CFrame.new(-4.1, -295.5, -36.6)
end, "TELEPORT")
createTextButton(teleport, "USA Lobby", 3, function()
	local v229 = v52()

	if not v229 then
		return
	end

	v229.CFrame = CFrame.new(15, -295.5, 46.5)
end, "TELEPORT")
createFrame2(teleport, "ISLANDS", 4)
createTextButton(teleport, "Island A", 5, function()
	local v230 = v52()

	if v230 then
		local v231 = Workspace

		for _, child in pairs(v231.GetChildren(v231)) do
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child.Name == "Island"
			end

			if isModel then
				local IslandCode = child:FindFirstChild("IslandCode")
				local Flag = child:FindFirstChild("Flag")

				if IslandCode then
					if IslandCode.Value == "A" then
						IslandCode = Flag
					else
						IslandCode = false
					end
				end

				if IslandCode then
					local Post = Flag:FindFirstChild("Post")

					if Post then
						v230.CFrame = Post.CFrame + Vector3.new(0, 5, 0)
					end
				end
			end
		end
	end
end, "TELEPORT")
createTextButton(teleport, "Island B", 6, function()
	local v238 = v52()

	if v238 then
		local v239 = Workspace

		for _, child in pairs(v239.GetChildren(v239)) do
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child.Name == "Island"
			end

			if isModel then
				local IslandCode = child:FindFirstChild("IslandCode")
				local v244 = child.FindFirstChild(child, "Flag")

				if IslandCode then
					if IslandCode.Value == "B" then
						IslandCode = v244
					else
						IslandCode = false
					end
				end

				if IslandCode then
					local Post = v244:FindFirstChild("Post")

					if Post then
						v238.CFrame = Post.CFrame + Vector3.new(0, 5, 0)
					end
				end
			end
		end
	end
end, "TELEPORT")
createTextButton(teleport, "Island C", 7, function()
	local v246 = v52()

	if v246 then
		local v247 = Workspace

		for _, child in pairs(v247.GetChildren(v247)) do
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child.Name == "Island"
			end

			if isModel then
				local IslandCode = child:FindFirstChild("IslandCode")
				local v252 = child.FindFirstChild(child, "Flag")

				if IslandCode then
					if IslandCode.Value == "C" then
						IslandCode = v252
					else
						IslandCode = false
					end
				end

				if IslandCode then
					local Post = v252:FindFirstChild("Post")

					if Post then
						v246.CFrame = Post.CFrame + Vector3.new(0, 5, 0)
					end
				end
			end
		end
	end
end, "TELEPORT")
createFrame2(teleport, "HARBORS", 8)
createTextButton(teleport, "Japan Harbor", 9, function()
	local v254 = v52()

	if not v254 then
		return
	end

	v254.CFrame = CFrame.new(-150.5, 23, -8160.2)
end, "TELEPORT")
createTextButton(teleport, "USA Harbor", 10, function()
	local v255 = v52()

	if not v255 then
		return
	end

	v255.CFrame = CFrame.new(-51, 23, 8129.6)
end, "TELEPORT")
createTextButton(teleport, "Nearest Enemy", 11, function()
	local v256 = v52()

	if not v256 then
		return
	end

	local v257 = v95()
	local Character = v257 and v257.Character

	if Character then
		Character = v257.Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	v256.CFrame = v257.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
end, "TELEPORT")

local misc = createScrollingFrame("MISC", "◇", "Utilities / optional helpers")

createFrame2(misc, "SYSTEM", 1)
v150(misc, "Godmode", 2, function(p87)
	getgenv().NW.Misc.Godmode = p87
end, "Max health + ForceField")
v150(misc, "Anti-AFK", 3, function(p88)
	getgenv().NW.Misc.AntiAFK = p88
end, "Prevent idle kick")
createTextButton(misc, "Load Infinite Yield", 4, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end, "LOAD EXTERNAL UTILITY")
createFrame2(misc, "AUTO WIN", 5)
v150(misc, "Auto Win USA", 6, function(p89)
	getgenv().NW.Misc.AutoWinUSA = p89

	if not p89 then
		return
	end

	local function v260()
		v55("USA")
		task.wait(1)
		v56("USA")
		getgenv().NW.Misc.AutoWinUSA = false
	end

	spawn(v260)
end, "Spawn bomber and bomb enemy base (USA)")
v150(misc, "Auto Win JAPAN", 7, function(p90)
	getgenv().NW.Misc.AutoWinJAPAN = p90

	if not p90 then
		return
	end

	local function v261()
		v55("JAPAN")
		task.wait(1)
		v56("JAPAN")
		getgenv().NW.Misc.AutoWinJAPAN = false
	end

	spawn(v261)
end, "Spawn bomber and bomb enemy base (JAPAN)")

local settings = createScrollingFrame("SETTINGS", "⚙", "Configuration & preferences")

createFrame2(settings, "GUI TOGGLE", 1)

local Frame12 = Instance.new("Frame")

Frame12.Size = UDim2.new(1, 0, 0, 48)
Frame12.BackgroundColor3 = v120.Panel2
Frame12.BorderSizePixel = 0
Frame12.LayoutOrder = 2
Frame12.Parent = settings
createUICorner2(Frame12, 11)
createUIStroke2(Frame12, v120.Line, 1, 0.35)
createTextLabel(Frame12, "Toggle GUI Keybind:", 10, UDim2.new(0, 13, 0, 6), Enum.Font.GothamBold, v120.Text).Size = UDim2.new(0, 140, 0, 18)

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(0, 60, 0, 30)
TextLabel.Position = UDim2.new(0, 160, 0, 9)
TextLabel.BackgroundColor3 = Color3.fromRGB(28, 34, 49)
TextLabel.TextColor3 = v120.Accent
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextSize = 12

local Name = getgenv().NW.Settings.ToggleKey.Name

TextLabel.Text = tostring(Name)
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.BorderSizePixel = 0
TextLabel.Parent = Frame12
createUICorner2(TextLabel, 6)

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0, 80, 0, 30)
TextButton2.Position = UDim2.new(1, -93, 0, 9)
TextButton2.BackgroundColor3 = v120.Accent2
TextButton2.Text = "Change"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 9
TextButton2.BorderSizePixel = 0
TextButton2.AutoButtonColor = false
TextButton2.Parent = Frame12
createUICorner2(TextButton2, 6)

local connection = nil

local function v268()
	local v269 = TextLabel
	local Name2 = getgenv().NW.Settings.ToggleKey.Name

	v269.Text = tostring(Name2)
end

TextButton2.MouseButton1Click:Connect(function()
	TextButton2.Text = "Press any key..."
	TextButton2.BackgroundColor3 = v120.Danger
	connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local KeyCode = input.KeyCode

		if KeyCode == Enum.KeyCode.Unknown then
			return
		end

		getgenv().NW.Settings.ToggleKey = KeyCode
		v268()
		v23("Keybind set to " .. KeyCode.Name, 2)
		TextButton2.Text = "Change"
		TextButton2.BackgroundColor3 = v120.Accent2

		if not connection then
			return
		end

		connection:Disconnect()
		connection = nil
	end)
end)
createFrame2(settings, "MOBILE", 3)

local mobileButton = false
local ScreenGui3 = nil
local Frame13 = nil

local function v275()
	if ScreenGui3 then
		return
	end

	ScreenGui3 = Instance.new("ScreenGui")
	ScreenGui3.Name = "DariusPR_MobileToggle"
	ScreenGui3.ResetOnSpawn = false
	ScreenGui3.IgnoreGuiInset = true
	ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui3.Parent = PlayerGui
	Frame13 = Instance.new("Frame")
	Frame13.Name = "ToggleButton"
	Frame13.Size = UDim2.new(0, 60, 0, 60)
	Frame13.Position = UDim2.new(0, 20, 0, 100)
	Frame13.BackgroundColor3 = v120.Accent2
	Frame13.BorderSizePixel = 0
	Frame13.Parent = ScreenGui3
	createUICorner2(Frame13, 30)
	createUIStroke2(Frame13, v120.Line, 1, 0.2)

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "≡"
	TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 28
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel2.Parent = Frame13

	local u277 = false
	local Position = nil
	local Position2 = nil

	local function v280(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u277 = true
		Position = input.Position
		Position2 = Frame13.Position
	end
	local function v281(input)
		if not (u277 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		local v282 = input.Position - Position

		Frame13.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v282.X, Position2.Y.Scale, Position2.Y.Offset + v282.Y)
	end
	local function v283(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u277 = false
	end

	Frame13.InputBegan:Connect(v280)
	UserInputService.InputChanged:Connect(v281)
	UserInputService.InputEnded:Connect(v283)
	Frame13.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		task.wait(0.1)

		if u277 then
			return
		end

		Frame2.Visible = not Frame2.Visible
	end)
end
local function v284()
	if not ScreenGui3 then
		return
	end

	ScreenGui3:Destroy()
end

local v285 = nil

local function v286(p91)
	mobileButton = p91 and true or false
	getgenv().NW.Settings.MobileButton = mobileButton

	if mobileButton then
		v275()
		v48("Mobile button created – drag to reposition", 2)
	else
		v285()
	end
end

v285 = v284

local Frame14 = Instance.new("Frame")

Frame14.Size = UDim2.new(1, 0, 0, 52)
Frame14.BackgroundColor3 = v120.Panel2
Frame14.BorderSizePixel = 0
Frame14.LayoutOrder = 4
Frame14.Parent = settings
createUICorner2(Frame14, 11)
createUIStroke2(Frame14, v120.Line, 1, 0.35)
createTextLabel(Frame14, "Mobile GUI Button", 11, UDim2.new(0, 13, 0, 7), Enum.Font.GothamBold, v120.Text).Size = UDim2.new(1, -75, 0, 18)
createTextLabel(Frame14, "Show a draggable toggle button", 8, UDim2.new(0, 13, 0, 27), Enum.Font.GothamMedium, v120.Muted).Size = UDim2.new(1, -75, 0, 15)

local TextButton3 = Instance.new("TextButton")

TextButton3.Size = UDim2.new(0, 48, 0, 26)
TextButton3.Position = UDim2.new(1, -60, 0.5, -13)
TextButton3.BackgroundColor3 = Color3.fromRGB(28, 34, 49)
TextButton3.Text = "OFF"
TextButton3.TextColor3 = v120.Muted
TextButton3.Font = Enum.Font.GothamBlack
TextButton3.TextSize = 8
TextButton3.BorderSizePixel = 0
TextButton3.AutoButtonColor = false
TextButton3.Parent = Frame14
createUICorner2(TextButton3, 8)

local function v289(p92)
	TextButton3.Text = p92 and "ON" or "OFF"
	TextButton3.BackgroundColor3 = p92 and v120.Accent2 or Color3.fromRGB(28, 34, 49)
	TextButton3.TextColor3 = p92 and Color3.fromRGB(255, 255, 255) or v120.Muted
	createUIStroke2(TextButton3, p92 and v120.Accent or v120.Line, 1, 0.15)
end

local u290 = false

TextButton3.MouseButton1Click:Connect(function()
	u290 = not u290
	v289(u290)
	v286(u290)
end)
TextButton3.Text = "OFF"
TextButton3.BackgroundColor3 = Color3.fromRGB(28, 34, 49)
TextButton3.TextColor3 = v120.Muted
createUIStroke2(TextButton3, v120.Line, 1, 0.15)

local v291 = v142
local v292 = u219
local v293 = v52
local v294 = t2
local u295 = u220

for _, v in ipairs(v291) do
	v.Button.MouseButton1Click:Connect(function()
		v143(v.Name)
	end)
	v.Page:GetPropertyChangedSignal("CanvasPosition"):Connect(function() end)
end

v143("AIM")

local u298 = false
local Position = nil
local Position2 = nil

Frame4.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u298 = true
	Position = input.Position
	Position2 = Frame2.Position
end)
UserInputService.InputChanged:Connect(function(input)
	if not (u298 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local v301 = input.Position - Position

	Frame2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v301.X, Position2.Y.Scale, Position2.Y.Offset + v301.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
end)
TextButton.MouseButton1Click:Connect(function()
	Frame2.Visible = false
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if not (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == getgenv().NW.Settings.ToggleKey) then
		return
	end

	Frame2.Visible = not Frame2.Visible
end)
getgenv().NW.Aimbot.Enabled = false
getgenv().NW.Aimbot.PlaneAimbot = false
getgenv().NW.ESP.Players = false
getgenv().NW.ESP.Vehicles = false
getgenv().NW.ESP.Islands = false
getgenv().NW.ESP.Harbors = false
getgenv().NW.Weapon.RapidFire = false
getgenv().NW.Weapon.ShootRPG = false
getgenv().NW.Weapon.KillAll = false
getgenv().NW.Movement.Speed = false
getgenv().NW.Movement.ShipSpeed = false
getgenv().NW.Movement.WalkOnWater = false
getgenv().NW.Misc.Godmode = false
getgenv().NW.Misc.AntiAFK = false
getgenv().NW.Misc.AutoWinUSA = false
getgenv().NW.Misc.AutoWinJAPAN = false
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	v115()

	if not getgenv().NW.Movement.WalkOnWater then
		return
	end

	v221()

	if v292 then
		v292:Disconnect()
	end

	RunService.Heartbeat:Connect(function()
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		if not Character:FindFirstChildOfClass("Humanoid") then
			return
		end

		local v304 = v206(Character)
		local v305

		if v304 then
			v305 = not u295
		else
			v305 = v304
		end

		if v305 then
			u295 = true
			v192(Character)
		end

		if not v304 then
			u295 = false
		end

		local HumanoidRootPart = u295 and Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

		if not (AssemblyLinearVelocity.Y < 0) then
			return
		end

		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
	end)
end)
v23("Naval Command Deck loaded", 4)
task.delay(0.55, function()
	local v308 = v48
	local Name2 = getgenv().NW.Settings.ToggleKey.Name

	v308("Press " .. tostring(Name2) .. " to toggle GUI", 4)
end)
spawn(function()
	while task.wait(0.35) do
		local ESP = getgenv().NW.ESP
		local t7 = {}

		if ESP.Players then
			local v312 = Players

			for _, player in ipairs(v312.GetPlayers(v312)) do
				local v315

				if player == LocalPlayer then
					v315 = false
				else
					v315 = player.Character
				end

				if v315 then
					local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart then
						local v317 = "player_" .. player.UserId

						t7[v317] = true

						local v318 = v68(player)
						local color3 = v318 and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(80, 190, 255)
						local v320 = v318 and "ENEMY" or "ALLY"
						local v321 = v66(HumanoidRootPart)
						local v322 = math.floor(v321)

						v107(v317, HumanoidRootPart, color3, player.Name .. "\n" .. v320 .. " [" .. v322 .. "m]")
					end
				end
			end
		end

		if ESP.Vehicles then
			local v323 = Workspace

			for _, descendant in ipairs(v323.GetDescendants(v323)) do
				local Team = descendant:IsA("Model") and descendant:FindFirstChild("Team")

				if Team then
					Team = descendant:FindFirstChild("MainBody")
				end

				if Team then
					local HP = descendant:FindFirstChild("HP")
					local Team2 = descendant:FindFirstChild("Team")
					local isBasePart

					if HP then
						if Team2 then
							isBasePart = descendant.MainBody:IsA("BasePart")
						else
							isBasePart = Team2
						end
					else
						isBasePart = HP
					end

					if isBasePart then
						local v330 = "vehicle_" .. descendant:GetFullName()

						t7[v330] = true

						if Team2.Value ~= LocalPlayer.Team then
							local _ = LocalPlayer.Team.Name
						end

						local color3 = Color3.fromRGB(255, 160, 0) or Color3.fromRGB(0, 220, 120)
						local v333 = v107
						local MainBody = descendant.MainBody
						local Name2 = descendant.Name
						local Value = HP.Value
						local v337 = tostring(Value)
						local v338 = v66(descendant.MainBody)

						v333(v330, MainBody, color3, Name2 .. "\nHP:" .. v337 .. " [" .. math.floor(v338) .. "m]")
					end
				end
			end
		end

		if ESP.Islands then
			local v339 = Workspace

			for _, child in ipairs(v339.GetChildren(v339)) do
				local isModel = child:IsA("Model")

				if isModel then
					isModel = child.Name == "Island"
				end

				if isModel then
					local IslandCode = child:FindFirstChild("IslandCode")
					local Flag = child:FindFirstChild("Flag")
					local HP = child:FindFirstChild("HP")

					if Flag then
						Flag = Flag:FindFirstChild("Post")
					end

					local isBasePart

					if IslandCode then
						if Flag then
							isBasePart = Flag:IsA("BasePart")
						else
							isBasePart = Flag
						end
					else
						isBasePart = IslandCode
					end

					if isBasePart then
						local Value = IslandCode.Value
						local v348 = "island_" .. tostring(Value)

						t7[v348] = true

						if HP then
							local Value2 = HP.Value

							HP = " HP:" .. tostring(Value2)
						end

						local v350 = v107
						local color3 = Color3.fromRGB(255, 220, 40)
						local Value2 = IslandCode.Value
						local v353 = tostring(Value2)
						local v354 = v66(Flag)

						v350(v348, Flag, color3, "Island " .. v353 .. (HP or "") .. "\n[" .. math.floor(v354) .. "m]")
					end
				end
			end
		end

		if ESP.Harbors then
			for _, v in ipairs({ "JapanDock", "USDock" }) do
				local v357 = Workspace:FindFirstChild(v)
				local MainBody

				if v357 then
					MainBody = v357:FindFirstChild("MainBody")
				else
					MainBody = v357
				end

				local isBasePart

				if MainBody then
					isBasePart = MainBody:IsA("BasePart")
				else
					isBasePart = MainBody
				end

				if isBasePart then
					local HP = v357:FindFirstChild("HP")
					local v361 = "harbor_" .. v

					t7[v361] = true

					if HP then
						local Value = HP.Value

						HP = " HP:" .. tostring(Value)
					end

					local color3 = v == "JapanDock" and Color3.fromRGB(255, 90, 90) or Color3.fromRGB(100, 160, 255)
					local v364 = v107
					local v365 = v66(MainBody)

					v364(v361, MainBody, color3, v .. (HP or "") .. "\n[" .. math.floor(v365) .. "m]")
				end
			end
		end

		for k in pairs(v294) do
			local v367 = string.match(k, "^(%a+_)")
			local Players2

			if v367 == "player_" then
				Players2 = ESP.Players
			else
				Players2 = false
			end

			if not Players2 then
				Players2 = v367 == "vehicle_" and ESP.Vehicles or v367 == "island_" and ESP.Islands

				if not Players2 then
					if v367 == "harbor_" then
						Players2 = ESP.Harbors
					else
						Players2 = false
					end
				end
			end

			if not (Players2 and t7[k]) then
				v113(k)
			end
		end
	end
end)

local n1 = 0
local t8 = {}

local function v371()
	table.clear(t8)

	local Name2 = LocalPlayer.Team and LocalPlayer.Team.Name or ""
	local v373 = Workspace

	for _, descendant in ipairs(v373.GetDescendants(v373)) do
		if descendant:IsA("Model") then
			local MainBody = descendant:FindFirstChild("MainBody")
			local v377 = descendant.FindFirstChild(descendant, "Team")

			if MainBody then
				local isBasePart = MainBody:IsA("BasePart")

				if isBasePart then
					if v377 then
						v377 = v377.Value ~= Name2
					end
				else
					v377 = isBasePart
				end
			else
				v377 = MainBody
			end

			if v377 then
				t8[#t8 + 1] = MainBody
			end
		end
	end
end

local RenderPriority = Enum.RenderPriority

local function v380(p93)
	if not getgenv().NW.Aimbot.PlaneAimbot then
		Target = nil

		return
	end

	local v381 = v293()

	if not v381 then
		return
	end

	n1 = n1 + p93

	if n1 >= 0.12 then
		v371()
	end

	if getgenv().NW.Aimbot.Enabled then
		local huge = math.huge
		local v383 = nil

		for _, v in ipairs(t8) do
			local Parent

			if v then
				Parent = v.Parent
			else
				Parent = v
			end

			if Parent then
				local Magnitude = (v381.Position - v.Position).Magnitude

				if Magnitude < huge then
					v383 = v
					huge = Magnitude
				end
			end
		end

		if v383 then
			Target = v383
			vector3 = Vector3.zero
		end
	end

	if not (Target and Target.Parent) then
		return
	end

	local Position3 = v381.Position
	local vector32 = Target.Position - vector3 or Vector3.zero
	local AssemblyLinearVelocity = Target.AssemblyLinearVelocity
	local BulletSpeed = getgenv().NW.Aimbot.BulletSpeed
	local v392 = math.max(1, BulletSpeed)
	local v393 = (vector32 - Position3).Magnitude / v392
	local v394, v395, v396 = v69(Position3, vector32 + AssemblyLinearVelocity * math.clamp(v393, 0.03, 1.25), AssemblyLinearVelocity, v392)

	if not v396 then
		return
	end

	local v397 = CFrame.fromOrientation(v395, v394, 0).LookVector * v396
	local v398 = CurrentCamera
	local t9 = { v398.WorldToViewportPoint(v398, Position3 + v397) }
	local v400 = t9[1]

	if not t9[2] then
		return
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local v402 = v400.X - mouseLocation.X
	local v403 = math.clamp(v402, -180, 180)
	local v404 = v400.Y - mouseLocation.Y
	local v405 = math.clamp(v404, -180, 180)

	pcall(function()
		mousemoverel(v403, v405)
	end)
end

RunService.BindToRenderStep(RunService, "NWAimbot", RenderPriority.Camera.Value + 1, v380)
mouse.Button2Down:Connect(function()
	if not getgenv().NW.Aimbot.PlaneAimbot then
		return
	end

	if not mouse.Target then
		return
	end

	Target = mouse.Target

	local _ = mouse.Target.Position - mouse.Hit.Position
end)
mouse.Button2Up:Connect(function() end)
RunService:BindToRenderStep("NWSpeed", Enum.RenderPriority.Character.Value + 1, function()
	local v407 = v64()

	if not v407 then
		return
	end

	if getgenv().NW.Movement.Speed then
		local SpeedVal = getgenv().NW.Movement.SpeedVal
		local v409 = tonumber(SpeedVal) or 16
		local walkSpeed = math.clamp(v409, 16, 200)

		if v407.WalkSpeed == walkSpeed then
			return
		else
			v407.WalkSpeed = walkSpeed

			return
		end
	end

	if v407.WalkSpeed == 16 then
		return
	end

	v407.WalkSpeed = 16
end)

local u411 = nil

RunService.Heartbeat:Connect(function()
	if not getgenv().NW.Weapon.RapidFire then
		return
	end

	local Character = LocalPlayer.Character

	if not Character then
		return
	end

	local v413 = Character.FindFirstChildOfClass(Character, "Tool")

	if not v413 then
		return
	end

	pcall(function()
		v413:Activate()
	end)
end)
spawn(function()
	while task.wait(0.1) do
		local ShootRPG = getgenv().NW.Weapon.ShootRPG and Event

		if ShootRPG then
			ShootRPG = mouse
		end

		if ShootRPG then
			local function v415()
				Event:FireServer("fireRPG", { mouse.Hit.p })
			end

			pcall(v415)
		end
	end
end)

local t10 = {}

local function v417()
	table.clear(t10)

	local Team = LocalPlayer.Team
	local v419 = Players

	for _, player in ipairs(v419.GetPlayers(v419)) do
		local v422

		if player == LocalPlayer then
			v422 = false
		else
			v422 = player.Team ~= Team
		end

		if v422 then
			local Character = player.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			local v425

			if Humanoid then
				if Character then
					v425 = Humanoid.Health > 0
				else
					v425 = Character
				end
			else
				v425 = Humanoid
			end

			if v425 then
				t10[#t10 + 1] = {
					humanoid = Humanoid,
					root = Character
				}
			end
		end
	end

	u411 = 1
end

local n2 = 0
local n3 = 0

u411 = 1

local Heartbeat = RunService.Heartbeat

Heartbeat.Connect(Heartbeat, function(p94)
	if not (getgenv().NW.Weapon.KillAll and Event) then
		return
	end

	n2 = n2 + p94
	n3 = n3 + p94

	if n2 >= 0.2 then
		v417()
	end

	if n3 < 0.045 then
		return
	end

	local n4 = 0

	while true do
		local v430

		if n4 < 2 then
			v430 = #t10 > 0
		else
			v430 = false
		end

		if not v430 then
			return
		end

		if u411 > #t10 then
			u411 = 1
		end

		local v431 = t10[u411]

		u411 = u411 + 1

		local humanoid

		if v431 then
			humanoid = v431.humanoid

			if humanoid then
				humanoid = v431.root and v431.humanoid.Parent

				if humanoid then
					humanoid = v431.humanoid.Health > 0
				end
			end
		else
			humanoid = v431
		end

		if humanoid then
			local function v433()
				local v434 = Event
				local v435 = v431

				v434.FireServer(v434, "shootRifle", "", { v435.root })

				local v436 = Event

				v436.FireServer(v436, "shootRifle", "hit", { v431.humanoid })
			end

			pcall(v433)
			n4 = n4 + 1
		end
	end
end)
RunService.Heartbeat:Connect(function()
	local Godmode = getgenv().NW.Misc.Godmode
	local Character = LocalPlayer.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if Godmode then
		if Humanoid.MaxHealth == 9000000000 then
			if Character:FindFirstChild("ForceField") then
				return
			else
				Instance.new("ForceField").Parent = Character

				return
			end
		end

		Humanoid.MaxHealth = 9000000000
		Humanoid.Health = 9000000000

		if Character:FindFirstChild("ForceField") then
			return
		else
			Instance.new("ForceField").Parent = Character

			return
		end
	else
		if Humanoid.MaxHealth == 100 then
			for _, child in pairs(Character:GetChildren()) do
				if child:IsA("ForceField") then
					child:Destroy()
				end
			end

			return
		end

		Humanoid.MaxHealth = 100
		Humanoid.Health = 100

		for _, child in pairs(Character:GetChildren()) do
			if child:IsA("ForceField") then
				child:Destroy()
			end
		end
	end
end)
spawn(function()
	while task.wait(60) do
		if getgenv().NW.Misc.AntiAFK then
			local function v444()
				VirtualUser:CaptureButton1()
				VirtualUser:ClickButton1(Vector2.new())
			end

			pcall(v444)
		end
	end
end)
