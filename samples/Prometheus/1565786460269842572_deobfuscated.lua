-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = game:GetService("HttpService")
}
local Players = game:GetService("Players")

t1.value2 = game:GetService("Stats")
t1.value3 = game:GetService("MarketplaceService")

local UserInputService = game:GetService("UserInputService")

t1.value4 = Players.LocalPlayer
t1.value5 = "https://nexvoid-logs.onrender.com/api/"
t1.value6 = "SysData_" .. t1.value4.UserId .. ".txt"
t1.value7 = 1
pcall(function()
	local isfile_ = isfile

	if isfile_ then
		isfile_ = isfile(t1.value6)
	end

	if isfile_ then
		local v6 = readfile(t1.value6)
		local v7 = string.match(v6, "%d+")

		if v7 then
			t1.value7 = tonumber(v7) + 1
		end
	end

	if not writefile then
		return
	end

	local writefile_ = writefile
	local value6 = t1.value6
	local value7 = t1.value7

	writefile_(value6, "SysCore_" .. tostring(value7))
end)
t1.value8 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Mobile" or "PC"
t1.value9 = t1.value7 == 1 and "Sim" or "Nao"
t1.value10 = "Unknown"
pcall(function()
	if not gethwid then
		return
	end

	t1.value10 = gethwid()
end)
t1.value11 = "Unknown"
pcall(function()
	if identifyexecutor then
		t1.value11 = identifyexecutor()

		return
	end

	if not getexecutorname then
		return
	end

	t1.value11 = getexecutorname()
end)

local Name = game.Name

t1.value12 = nil
t1.value12 = Name
pcall(function()
	local productInfo = t1.value3:GetProductInfo(game.PlaceId)

	if not productInfo then
		return
	end

	t1.value12 = productInfo.Name
end)
t1.value13 = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. t1.value4.UserId .. "&width=420&height=420&format=png"

local function v13(p1, p2)
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if not syn_ then
		local http_ = http

		if http_ then
			http_ = http.request
		end

		syn_ = http_ or (http_request or (fluxus and fluxus.request or request))
	end

	if not syn_ then
		return
	end

	local function v16()
		syn_({
			Url = t1.value5 .. p1,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = t1.value1:JSONEncode(p2)
		})
	end

	pcall(v16)
end
local function v17()
	local n1 = 0

	local function v19()
		local v20 = t1.value4:GetNetworkPing() * 1000

		n1 = math.floor(v20)
	end

	pcall(v19)

	local realPhysicsFPS = workspace:GetRealPhysicsFPS()
	local v22 = math.floor(realPhysicsFPS)
	local totalMemoryUsageMb = t1.value2:GetTotalMemoryUsageMb()
	local v24 = math.floor(totalMemoryUsageMb)
	local UserId = t1.value4.UserId
	local v26 = tostring(UserId)
	local Name2 = t1.value4.Name
	local AccountAge = t1.value4.AccountAge
	local v29 = tostring(AccountAge)
	local value9 = t1.value9
	local v31 = n1
	local v32 = tostring(v31)
	local v33 = tostring(v22)
	local v34 = tostring(v24)
	local value8 = t1.value8
	local value7 = t1.value7
	local v37 = tostring(value7)
	local value12 = t1.value12
	local PlaceId = game.PlaceId

	return {
		UserId = v26,
		Name = Name2,
		Age = v29,
		NewUser = value9,
		Ping = v32,
		FPS = v33,
		Ram = v34,
		Device = value8,
		Execs = v37,
		Game = value12,
		PlaceId = tostring(PlaceId),
		Exec = t1.value11,
		HWID = t1.value10,
		AvatarUrl = t1.value13
	}
end

task.spawn(function()
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if not syn_ then
		local http_ = http

		if http_ then
			http_ = http.request
		end

		syn_ = http_ or (http_request or fluxus and fluxus.request or request)
	end

	if not syn_ then
		while task.wait(15) do
			v13("ping", (v17()))
		end

		return
	end

	local function v42()
		local v43 = syn_({
			Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. t1.value4.UserId .. "&size=420x420&format=Png&isCircular=false",
			Method = "GET"
		})
		local data = t1.value1:JSONDecode(v43.Body)
		local data2

		if data then
			data2 = data.data and data.data[1]

			if data2 then
				data2 = data.data[1].imageUrl
			end
		else
			data2 = data
		end

		if not data2 then
			return
		end

		local _ = data.data[1].imageUrl
	end

	pcall(v42)

	while task.wait(15) do
		v13("ping", (v17()))
	end
end)
Players.PlayerRemoving:Connect(function(player)
	if player ~= t1.value4 then
		return
	end

	local v47 = v13
	local UserId = t1.value4.UserId

	v47("disconnect", {
		UserId = tostring(UserId)
	})
end)

function _G.NexVoidLog(p3, p4, p5)
	local v49 = tostring(p4)
	local action

	if p3 == "Toggle" then
		action = string.format("%s %s %s", p5 and "+" or "-", p5 and "Ativou" or "Desativou", v49)
	elseif p3 == "Button" then
		action = string.format("+ Clicou %s", v49)
	elseif (p3 == "Slider" or p3 == "Input") and true or p3 == "Dropdown" then
		action = string.format("+ Alterou %s ➔ %s", v49, (tostring(p5)))
	else
		action = string.format("+ Interagiu %s", v49)
	end

	local v51 = v17()

	v51.Action = action
	task.spawn(function()
		v13("log", v51)
	end)
end

_G.ActionLog = _G.NexVoidLog
t1.value14 = game:GetService("Players")
t1.value15 = game:GetService("UserInputService")
t1.value16 = game:GetService("TweenService")
t1.value17 = game:GetService("RunService")
t1.value18 = game:GetService("HttpService")
t1.value19 = game:GetService("CoreGui")
t1.value20 = game:GetService("Lighting")
t1.value21 = game:GetService("ReplicatedStorage")
game:GetService("VirtualInputManager")
t1.value22 = game:GetService("Workspace")

local _ = t1.value22.CurrentCamera

t1.value23 = t1.value14.LocalPlayer

if not t1.value23 then
	local _ = t1.value14.LocalPlayer

	repeat
		task.wait()
	until t1.value14.LocalPlayer

	t1.value23 = t1.value14.LocalPlayer
end

t1.value24 = "NexVoidConfigs"
t1.value25 = t1.value24 .. "/default_config.txt"
t1.value26 = t1.value24 .. "/NVBackground.txt"
t1.value27 = {
	ToggleKey = "K"
}
pcall(function()
	local makefolder_ = makefolder

	if makefolder_ then
		makefolder_ = not isfolder(t1.value24)
	end

	if not makefolder_ then
		return
	end

	makefolder(t1.value24)
end)

function t1.value28(p6)
	pcall(function()
		if not isfolder(t1.value24) then
			makefolder(t1.value24)
		end

		if not writefile then
			return
		end

		local v55 = p6

		writefile(t1.value26, (tostring(v55)))
	end)
end

local v56 = (function()
	local u57 = nil

	local function v58()
		local isfile_ = isfile and isfile(t1.value26)

		if isfile_ then
			isfile_ = readfile
		end

		if not isfile_ then
			return
		end

		u57 = readfile(t1.value26)
	end

	u57 = nil
	pcall(v58)

	local v60 = u57

	if not v60 then
		return v60 and u57 or "79344922826816"
	end

	v60 = u57 ~= ""

	return v60 and u57 or "79344922826816"
end)()

t1.value29 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
t1.value30 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

function t1.value31(p7, p8, p9)
	local text = p9 or "NexVoid V2.8"
	local v62 = p8 or 4
	local PlayerGui = t1.value23:WaitForChild("PlayerGui", 5)

	if not PlayerGui then
		return
	end

	local NexVoidNotifyGui = PlayerGui:FindFirstChild("NexVoidNotifyGui")

	if not NexVoidNotifyGui then
		NexVoidNotifyGui = Instance.new("ScreenGui", PlayerGui)
		NexVoidNotifyGui.Name = "NexVoidNotifyGui"
		NexVoidNotifyGui.ResetOnSpawn = false
		NexVoidNotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	end

	local ImageLabel = Instance.new("ImageLabel", NexVoidNotifyGui)

	ImageLabel.Size = UDim2.new(0, 240, 0, 65)
	ImageLabel.AnchorPoint = Vector2.new(1, 1)
	ImageLabel.Position = UDim2.new(1, 300, 1, -25)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxassetid://98380525204267"
	ImageLabel.ScaleType = Enum.ScaleType.Crop
	ImageLabel.BorderSizePixel = 0
	ImageLabel.ZIndex = 1000
	Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 6)

	local UIStroke = Instance.new("UIStroke", ImageLabel)

	UIStroke.Color = Color3.fromRGB(40, 40, 40)
	UIStroke.Thickness = 1

	local TextLabel = Instance.new("TextLabel", ImageLabel)

	TextLabel.Size = UDim2.new(1, -30, 0, 20)
	TextLabel.Position = UDim2.new(0, 15, 0, 10)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = text
	TextLabel.TextSize = 14
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 1001

	local TextLabel2 = Instance.new("TextLabel", ImageLabel)

	TextLabel2.Size = UDim2.new(1, -30, 0, 16)
	TextLabel2.Position = UDim2.new(0, 15, 0, 32)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.Text = p7
	TextLabel2.TextSize = 12
	TextLabel2.TextColor3 = Color3.fromRGB(170, 170, 170)
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.RichText = true
	TextLabel2.ZIndex = 1001

	local Frame = Instance.new("Frame", ImageLabel)

	Frame.Size = UDim2.new(1, 0, 0, 3)
	Frame.Position = UDim2.new(0, 0, 1, -3)
	Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 1001

	local Frame2 = Instance.new("Frame", Frame)

	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 1002

	local value16 = t1.value16
	local value29 = t1.value29
	local UDim2_ = UDim2

	value16.Create(value16, ImageLabel, value29, {
		Position = UDim2_.new(1, -20, 1, -25)
	}):Play()

	local value162 = t1.value16
	local tweenInfo = TweenInfo.new(v62, Enum.EasingStyle.Linear)
	local uDim2New = UDim2.new

	value162.Create(value162, Frame2, tweenInfo, {
		Size = uDim2New(0, 0, 1, 0)
	}):Play()
	task.delay(v62, function()
		local value163 = t1.value16
		local v78 = ImageLabel
		local value30 = t1.value30
		local uDim2New2 = UDim2.new

		value163.Create(value163, v78, value30, {
			Position = uDim2New2(1, 300, 1, -25)
		}):Play()
		task.wait(0.35)
		ImageLabel:Destroy()
	end)
end

task.spawn(function()
	t1.value31("Welcome, <b><font color=\'rgb(255,255,255)\'>" .. t1.value23.Name .. "</font></b>.", 5, "NexVoid V2.8")
end)
t1.value32 = nil

local ok, value32 = pcall(function()
	return gethui()
end)

if ok and value32 then
	t1.value32 = value32
else
	local ok2, value322 = pcall(function()
		return getgenv().gethui()
	end)

	if ok2 and value322 then
		t1.value32 = value322
	else
		local ok3, value323 = pcall(function()
			return game:GetService("CoreGui")
		end)

		if ok3 and value323 then
			t1.value32 = value323
		else
			t1.value32 = t1.value23:WaitForChild("PlayerGui")
		end
	end
end

pcall(function()
	if t1.value23.PlayerGui:FindFirstChild("NexVoidHub") then
		t1.value23.PlayerGui.NexVoidHub:Destroy()
	end

	if not t1.value32:FindFirstChild("NexVoidHub") then
		return
	end

	t1.value32.NexVoidHub:Destroy()
end)
t1.value33 = Instance.new("ScreenGui")
t1.value33.Name = "NexVoidHub"
t1.value33.Parent = t1.value32
t1.value33.ResetOnSpawn = false
t1.value33.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value33.IgnoreGuiInset = true
t1.value33.DisplayOrder = 10000
t1.value33.Enabled = true

local TouchEnabled = t1.value15.TouchEnabled

if TouchEnabled then
	TouchEnabled = not t1.value15.MouseEnabled
end

t1.value34 = TouchEnabled
t1.value35 = {
	MainSize = t1.value34 and UDim2.new(0, 520, 0, 365) or UDim2.new(0, 600, 0, 420),
	SidebarWidth = t1.value34 and 130 or 150,
	FooterHeight = 18,
	BtnHeight = t1.value34 and 24 or 28,
	ListPadding = UDim.new(0, 2),
	FontSize = t1.value34 and 10 or 12,
	IconSize = t1.value34 and 13 or 16
}
t1.value36 = {
	ItemHeightNew = 30,
	ItemHeightOld = 35,
	PlayerCardHeight = 45,
	ItemPadding = UDim.new(0, 4)
}
t1.value37 = {
	FrameColor = Color3.fromRGB(12, 12, 12),
	ContentColor = Color3.fromRGB(20, 20, 20),
	ItemColor = Color3.fromRGB(30, 30, 30),
	ItemStroke = Color3.fromRGB(60, 60, 60),
	SwitchOff = Color3.fromRGB(40, 40, 40),
	Accent = Color3.fromRGB(240, 240, 240),
	AccentDark = Color3.fromRGB(160, 160, 160),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(150, 150, 150),
	Font = Enum.Font.GothamBold,
	CloseRed = Color3.fromRGB(100, 100, 100)
}
t1.value38 = {
	OnlyBeast = false,
	HideNames = false,
	BeastHighlight = Color3.fromRGB(0, 255, 255),
	Survivor = Color3.fromRGB(0, 255, 0),
	Beast = Color3.fromRGB(255, 0, 0),
	Pod = Color3.fromRGB(0, 255, 255),
	TracerThickness = 1.5,
	OutlineSurvivor = Color3.fromRGB(0, 0, 0),
	OutlineBeast = Color3.fromRGB(0, 0, 0),
	OutlineComp = Color3.fromRGB(0, 0, 0),
	OutlinePod = Color3.fromRGB(0, 0, 0),
	OutlineDoor = Color3.fromRGB(0, 0, 0)
}
t1.value39 = 24
t1.value40 = false
t1.value41 = Instance.new("ImageLabel")
t1.value41.Name = "MobileCrosshair"
t1.value41.Size = UDim2.new(0, t1.value39, 0, t1.value39)
t1.value41.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value41.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value41.BackgroundTransparency = 1
t1.value41.Visible = false
t1.value41.ZIndex = 99
t1.value41.Parent = t1.value33
t1.value42 = Instance.new("ImageLabel")
t1.value42.Name = "PCCursor"
t1.value42.Size = UDim2.new(0, t1.value39, 0, t1.value39)
t1.value42.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value42.BackgroundTransparency = 1
t1.value42.Visible = false
t1.value42.ZIndex = 10000
t1.value42.Parent = t1.value33

local function v88(p10)
	t1.value39 = p10
	t1.value41.Size = UDim2.new(0, p10, 0, p10)
	t1.value42.Size = UDim2.new(0, p10, 0, p10)
end

function t1.value43(p11)
	t1.value40 = p11
end

t1.value17.RenderStepped:Connect(function()
	if t1.value40 then
		t1.value15.MouseIconEnabled = false

		local mouseLocation = t1.value15:GetMouseLocation()

		t1.value42.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)

		return
	end

	local v90

	if t1.value15.MouseIconEnabled == false then
		v90 = not t1.value40
	else
		v90 = false
	end

	if not v90 then
		return
	end

	t1.value15.MouseIconEnabled = true
end)

local function v91(p12, p13, p14, p15)
	local UIGradient = p12:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p13), ColorSequenceKeypoint.new(1, p14) })
	UIGradient.Rotation = p15 or 45
	UIGradient.Parent = p12

	return UIGradient
end

t1.value44 = {}

function t1.value45(p16)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(170, 170, 170)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.65, Color3.fromRGB(170, 170, 170)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))
	})
	UIGradient.Rotation = 20
	UIGradient.Parent = p16

	local value44 = t1.value44

	table.insert(value44, UIGradient)

	return UIGradient
end

t1.value17.RenderStepped:Connect(function()
	local v95 = tick() * 0.6 % 2 - 1

	for i = #t1.value44, 1, -1 do
		local v97 = t1.value44[i]
		local Parent

		if v97 then
			Parent = v97.Parent
		else
			Parent = v97
		end

		if Parent then
			v97.Offset = Vector2.new(v95, 0)
		else
			table.remove(t1.value44, i)
		end
	end
end)

function t1.value46()
	local s1 = "config_1"

	local function v100()
		local isfile_ = isfile

		if isfile_ then
			isfile_ = isfile(t1.value25)
		end

		if not isfile_ then
			return
		end

		s1 = readfile(t1.value25)
	end

	pcall(v100)

	return s1
end

local v102 = t1.value46()

function t1.value47(p17)
	local v103 = Enum.Font[p17]

	if not v103 then
		return
	end

	t1.value37.Font = v103

	local ipairs_ = ipairs
	local value33 = t1.value33

	for _, descendant in ipairs_(value33.GetDescendants(value33)) do
		if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
			descendant.Font = v103
		end
	end
end

t1.value48 = Enum.KeyCode[t1.value27.ToggleKey] or Enum.KeyCode.K

function t1.value49(p18)
	t1.value27.ToggleKey = t1.value48.Name

	local function v108()
		if not isfolder(t1.value24) then
			makefolder(t1.value24)
		end

		if not writefile then
			return
		end

		writefile(t1.value24 .. "/" .. p18 .. ".json", t1.value18:JSONEncode(t1.value27))
	end

	pcall(v108)
end
function t1.value50(p19)
	local v109 = nil

	local function v110()
		if not isfolder(t1.value24) then
			makefolder(t1.value24)
		end

		if not writefile then
			return
		end

		writefile(t1.value25, v109)
	end

	v109 = p19
	pcall(v110)
end
function t1.value51()
	pcall(function()
		local delfolder_ = delfolder

		if delfolder_ then
			delfolder_ = isfolder(t1.value24)
		end

		if not delfolder_ then
			return
		end

		delfolder(t1.value24)
	end)
	t1.value27 = {
		ToggleKey = "K"
	}
	t1.value48 = Enum.KeyCode.K
end

local function v112(p20, p21)
	local u113 = nil
	local u114 = nil
	local Position = nil
	local Position2 = nil

	p20.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u113 = true
		Position = input.Position
		Position2 = p21.Position
	end)
	p20.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u114 = input
	end)
	t1.value15.InputChanged:Connect(function(input)
		local v117

		if input == u114 then
			v117 = u113
		else
			v117 = false
		end

		if not v117 then
			return
		end

		local v118 = input.Position - Position

		p21.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v118.X, Position2.Y.Scale, Position2.Y.Offset + v118.Y)
	end)
	p20.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
	end)
end

t1.value52 = Instance.new("Frame")
t1.value52.Name = "MainFrame"
t1.value52.Size = t1.value35.MainSize
t1.value52.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value52.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value52.BackgroundColor3 = t1.value37.FrameColor
t1.value52.BorderSizePixel = 0
t1.value52.Active = true
t1.value52.Draggable = false
t1.value52.ClipsDescendants = true
t1.value52.Visible = true
t1.value52.Parent = t1.value33

local TextButton = Instance.new("TextButton")

TextButton.Name = "FirstPersonFix"
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundTransparency = 1
TextButton.ZIndex = -99
TextButton.Text = ""
TextButton.Modal = true
TextButton.Parent = t1.value52

local UIStroke = Instance.new("UIStroke")

UIStroke.Parent = t1.value52
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.2
v91(UIStroke, t1.value37.Accent, Color3.fromRGB(20, 20, 20), -45)
t1.value53 = Instance.new("ImageLabel")
t1.value53.Name = "AnimeBackground"
t1.value53.Size = UDim2.new(1, 0, 1, 0)
t1.value53.Image = "rbxassetid://" .. v56
t1.value53.ScaleType = Enum.ScaleType.Crop
t1.value53.BackgroundTransparency = 1
t1.value53.ZIndex = 1
t1.value53.Parent = t1.value52

local Frame = Instance.new("Frame")

Frame.Name = "DarkOverlay"
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.65
Frame.ZIndex = 2
Frame.Parent = t1.value52
t1.value54 = Instance.new("Frame")
t1.value54.Size = UDim2.new(1, 0, 0, 40)
t1.value54.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value54.BackgroundTransparency = 0.5
t1.value54.BorderSizePixel = 0
t1.value54.ZIndex = 3
t1.value54.Parent = t1.value52
v112(t1.value54, t1.value52)

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 1)
Frame2.Position = UDim2.new(0, 0, 1, 0)
Frame2.BorderSizePixel = 0
Frame2.Parent = t1.value54
v91(Frame2, Color3.new(0, 0, 0), t1.value37.Accent, 0)

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "TitleLabel"
TextLabel.Text = "Nex<font color=\'rgb(150,150,150)\'>Void V2.8</font>"
TextLabel.RichText = true
TextLabel.Size = UDim2.new(0, 180, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = t1.value37.Font
TextLabel.TextSize = t1.value34 and 14 or 16
TextLabel.TextColor3 = t1.value37.Text
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Position = UDim2.new(0, 45, 0, 0)
TextLabel.ZIndex = 4
TextLabel.Parent = t1.value54
t1.value55 = Instance.new("ImageButton")
t1.value55.Name = "OpenButton"
t1.value55.Size = UDim2.new(0, 45, 0, 45)
t1.value55.AnchorPoint = Vector2.new(0, 0)
t1.value55.Position = UDim2.new(0, 15, 0, 60)
t1.value55.BackgroundColor3 = t1.value37.FrameColor
t1.value55.Image = "rbxassetid://92493482879185"
t1.value55.Visible = false
t1.value55.Active = true
t1.value55.Draggable = true
t1.value55.Parent = t1.value33
Instance.new("UICorner", t1.value55).CornerRadius = UDim.new(0, 4)

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = t1.value37.Accent
UIStroke2.Thickness = 1.5
UIStroke2.Parent = t1.value55
v91(UIStroke2, t1.value37.Accent, Color3.fromRGB(50, 50, 50), 45)
v112(t1.value55, t1.value55)

local function v126(p22, p23, p24, p25)
	local ImageButton

	if p25 then
		ImageButton = Instance.new("ImageButton")
		ImageButton.Image = "rbxassetid://" .. p23
		ImageButton.ScaleType = Enum.ScaleType.Fit
		ImageButton.ImageTransparency = 1

		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Size = UDim2.new(0, 14, 0, 14)
		ImageLabel.Position = UDim2.new(0.5, -7, 0.5, -7)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxassetid://" .. p23
		ImageLabel.ImageColor3 = t1.value37.TextDark
		ImageLabel.ScaleType = Enum.ScaleType.Fit
		ImageLabel.ZIndex = 4
		ImageLabel.Parent = ImageButton
		ImageButton.MouseEnter:Connect(function()
			ImageLabel.ImageColor3 = t1.value37.Accent
		end)
		ImageButton.MouseLeave:Connect(function()
			ImageLabel.ImageColor3 = t1.value37.TextDark
		end)
	else
		ImageButton = Instance.new("TextButton")
		ImageButton.Text = p23
		ImageButton.Font = Enum.Font.GothamBlack
		ImageButton.TextSize = 14
		ImageButton.TextColor3 = t1.value37.TextDark

		if p23 == "-" then
			ImageButton.Text = ""

			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(0, 10, 0, 2)
			Frame3.Position = UDim2.new(0.5, -5, 0.5, 0)
			Frame3.BackgroundColor3 = t1.value37.TextDark
			Frame3.BorderSizePixel = 0
			Frame3.ZIndex = 4
			Frame3.Parent = ImageButton
			ImageButton.MouseEnter:Connect(function()
				Frame3.BackgroundColor3 = t1.value37.Accent
			end)
			ImageButton.MouseLeave:Connect(function()
				Frame3.BackgroundColor3 = t1.value37.TextDark
			end)
		elseif p22 == "Language" then
			ImageButton.MouseEnter:Connect(function()
				ImageButton.TextColor3 = t1.value37.Accent
			end)
			ImageButton.MouseLeave:Connect(function()
				ImageButton.TextColor3 = t1.value37.TextDark
			end)
		else
			ImageButton.MouseEnter:Connect(function()
				ImageButton.TextColor3 = t1.value37.CloseRed
			end)
			ImageButton.MouseLeave:Connect(function()
				ImageButton.TextColor3 = t1.value37.TextDark
			end)
		end
	end

	ImageButton.Name = p22
	ImageButton.Parent = t1.value54
	ImageButton.BackgroundTransparency = 1
	ImageButton.ZIndex = 4
	ImageButton.Position = UDim2.new(1, -(35 * p24), 0, 0)
	ImageButton.Size = UDim2.new(0, 35, 1, 0)

	return ImageButton
end

local Close = v126("Close", "X", 1, false)
local Minimize = v126("Minimize", "-", 2, false)
local Info = v126("Info", "5832745500", 3, true)

t1.value56 = v126("Language", "EN", 4, false)

local Frame3 = Instance.new("Frame")

Frame3.Name = "SearchContainer"
Frame3.Size = UDim2.new(0, t1.value34 and 90 or 110, 0, 24)

local n2 = -140

Frame3.Position = UDim2.new(1, t1.value34 and n2 and n2 or -155, 0.5, 0)
Frame3.AnchorPoint = Vector2.new(1, 0.5)
Frame3.BackgroundColor3 = Color3.new(0, 0, 0)
Frame3.BackgroundTransparency = 0.45
Frame3.BorderSizePixel = 0
Frame3.ClipsDescendants = true
Frame3.ZIndex = 4
Frame3.Parent = t1.value54
Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Frame3).Color = Color3.fromRGB(40, 40, 40)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Size = UDim2.new(0, 12, 0, 12)
ImageLabel.Position = UDim2.new(0, 8, 0.5, -6)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://104986431790017"
ImageLabel.ImageColor3 = t1.value37.TextDark
ImageLabel.ZIndex = 5
ImageLabel.Parent = Frame3
t1.value57 = Instance.new("TextBox")
t1.value57.Size = UDim2.new(1, -26, 1, 0)
t1.value57.Position = UDim2.new(0, 24, 0, 0)
t1.value57.BackgroundTransparency = 1
t1.value57.Text = ""
t1.value57.PlaceholderText = "Search..."
t1.value57.TextColor3 = t1.value37.Text
t1.value57.PlaceholderColor3 = t1.value37.TextDark
t1.value57.Font = t1.value37.Font
t1.value57.TextSize = 10
t1.value57.TextXAlignment = Enum.TextXAlignment.Left
t1.value57.ClearTextOnFocus = false
t1.value57.ZIndex = 5
t1.value57.Parent = Frame3

local Frame4 = Instance.new("Frame")

Frame4.Name = "CenterContainer"
Frame4.Size = UDim2.new(1, 0, 1, -(40 + t1.value35.FooterHeight))
Frame4.Position = UDim2.new(0, 0, 0, 40)
Frame4.BackgroundTransparency = 1
Frame4.ZIndex = 3
Frame4.Parent = t1.value52
t1.value58 = Instance.new("Frame")
t1.value58.Name = "Sidebar"
t1.value58.Size = UDim2.new(0, t1.value35.SidebarWidth, 1, 0)
t1.value58.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value58.BackgroundTransparency = 0.6
t1.value58.BorderSizePixel = 0
t1.value58.ZIndex = 3
t1.value58.Parent = Frame4

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = t1.value35.ListPadding
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = t1.value58

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.Parent = t1.value58
t1.value59 = Instance.new("Frame")
t1.value59.Name = "ContentArea"
t1.value59.Size = UDim2.new(1, -t1.value35.SidebarWidth, 1, 0)
t1.value59.Position = UDim2.new(0, t1.value35.SidebarWidth, 0, 0)
t1.value59.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value59.BackgroundTransparency = 0.7
t1.value59.BorderSizePixel = 0
t1.value59.ZIndex = 3
t1.value59.Parent = Frame4

local Frame5 = Instance.new("Frame")

Frame5.Size = UDim2.new(1, 0, 0, t1.value35.FooterHeight)
Frame5.Position = UDim2.new(0, 0, 1, -t1.value35.FooterHeight)
Frame5.BackgroundColor3 = Color3.new(0, 0, 0)
Frame5.BackgroundTransparency = 0.5
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 5
Frame5.Parent = t1.value52

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.RichText = true
TextLabel2.Text = "Discord: <font color=\'rgb(200,200,200)\'>.gg/uxPjBvxPY6</font>"
TextLabel2.Size = UDim2.new(1, -10, 1, 0)
TextLabel2.Position = UDim2.new(0, 10, 0, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextColor3 = t1.value37.Text
TextLabel2.Font = t1.value37.Font
TextLabel2.TextSize = 10
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.ZIndex = 6
TextLabel2.Parent = Frame5

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.RichText = true
TextLabel3.Text = "NexVoid V2.8 <font color=\'rgb(200,200,200)\'>" .. (t1.value34 and "Mobile" or "PC") .. "</font> | Thank you for using NexVoid."
TextLabel3.Size = UDim2.new(1, -10, 1, 0)
TextLabel3.Position = UDim2.new(0, 0, 0, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.TextColor3 = t1.value37.Text
TextLabel3.Font = t1.value37.Font
TextLabel3.TextSize = 10
TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
TextLabel3.ZIndex = 6
TextLabel3.Parent = Frame5
t1.value60 = Instance.new("Frame")
t1.value60.Size = UDim2.new(1, 0, 1, 0)
t1.value60.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value60.BackgroundTransparency = 0.5
t1.value60.Visible = false
t1.value60.ZIndex = 10
t1.value60.Parent = t1.value52
t1.value61 = Instance.new("Frame")
t1.value61.Size = UDim2.new(0, 310, 0, 165)
t1.value61.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value61.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value61.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value61.BackgroundTransparency = 0.15
t1.value61.BorderSizePixel = 0
t1.value61.ZIndex = 11
t1.value61.Visible = false
t1.value61.Parent = t1.value60
Instance.new("UICorner", t1.value61).CornerRadius = UDim.new(0, 10)

local UIStroke3 = Instance.new("UIStroke")

UIStroke3.Color = Color3.fromRGB(40, 40, 40)
UIStroke3.Thickness = 1.5
UIStroke3.Parent = t1.value61

local Frame6 = Instance.new("Frame")

Frame6.Size = UDim2.new(1, 0, 0, 4)
Frame6.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Frame6.BorderSizePixel = 0
Frame6.ZIndex = 12
Frame6.Parent = t1.value61
Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 10)

local Frame7 = Instance.new("Frame")

Frame7.Size = UDim2.new(1, 0, 0, 2)
Frame7.Position = UDim2.new(0, 0, 1, -2)
Frame7.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Frame7.BorderSizePixel = 0
Frame7.ZIndex = 12
Frame7.Parent = Frame6
v91(Frame6, Color3.fromRGB(255, 80, 80), Color3.fromRGB(150, 20, 20), 0)

local TextLabel4 = Instance.new("TextLabel")

TextLabel4.Size = UDim2.new(1, 0, 0, 40)
TextLabel4.Position = UDim2.new(0, 0, 0, 15)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Exit NexVoidHub"
TextLabel4:SetAttribute("OriginalText", "Exit NexVoidHub")
TextLabel4.Font = Enum.Font.GothamBlack
TextLabel4.TextSize = 18
TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel4.ZIndex = 12
TextLabel4.Parent = t1.value61

local TextLabel5 = Instance.new("TextLabel")

TextLabel5.Size = UDim2.new(1, -40, 0, 40)
TextLabel5.Position = UDim2.new(0, 20, 0, 50)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "Are you sure you want to close the script? You will need to re-execute to open it again."
TextLabel5:SetAttribute("OriginalText", "Are you sure you want to close the script? You will need to re-execute to open it again.")
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.TextSize = 12
TextLabel5.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel5.TextWrapped = true
TextLabel5.ZIndex = 12
TextLabel5.Parent = t1.value61
t1.value62 = Instance.new("TextButton")
t1.value62.Size = UDim2.new(0.42, 0, 0, 36)
t1.value62.Position = UDim2.new(0.06, 0, 0, 110)
t1.value62.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value62.BackgroundTransparency = 0.45
t1.value62.Text = "Cancel"
t1.value62:SetAttribute("OriginalText", "Cancel")
t1.value62.Font = Enum.Font.GothamBold
t1.value62.TextSize = 13
t1.value62.TextColor3 = Color3.fromRGB(200, 200, 200)
t1.value62.ZIndex = 12
t1.value62.Parent = t1.value61
Instance.new("UICorner", t1.value62).CornerRadius = UDim.new(0, 6)
t1.value63 = Instance.new("UIStroke")
t1.value63.Color = Color3.fromRGB(40, 40, 40)
t1.value63.Thickness = 1
t1.value63.Parent = t1.value62
t1.value64 = Instance.new("TextButton")
t1.value64.Size = UDim2.new(0.42, 0, 0, 36)
t1.value64.Position = UDim2.new(0.52, 0, 0, 110)
t1.value64.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
t1.value64.Text = "Yes, Exit"
t1.value64:SetAttribute("OriginalText", "Yes, Exit")
t1.value64.Font = Enum.Font.GothamBold
t1.value64.TextSize = 13
t1.value64.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value64.ZIndex = 12
t1.value64.Parent = t1.value61
Instance.new("UICorner", t1.value64).CornerRadius = UDim.new(0, 6)

local UIStroke4 = Instance.new("UIStroke")

UIStroke4.Color = Color3.fromRGB(100, 20, 20)
UIStroke4.Thickness = 1
UIStroke4.Parent = t1.value64
v91(t1.value64, Color3.fromRGB(255, 60, 60), Color3.fromRGB(180, 20, 20), 90)
t1.value62.MouseEnter:Connect(function()
	local value16 = t1.value16
	local value62 = t1.value62
	local tweenInfo = TweenInfo.new(0.2)
	local Color3_ = Color3

	value16.Create(value16, value62, tweenInfo, {
		BackgroundColor3 = Color3_.fromRGB(40, 40, 40)
	}):Play()

	local value162 = t1.value16
	local value63 = t1.value63
	local tweenInfo2 = TweenInfo.new(0.2)
	local color3 = Color3.fromRGB

	value162.Create(value162, value63, tweenInfo2, {
		Color = color3(100, 100, 100)
	}):Play()
end)
t1.value62.MouseLeave:Connect(function()
	local value16 = t1.value16
	local value62 = t1.value62
	local tweenInfo = TweenInfo.new(0.2)
	local Color3_ = Color3

	value16.Create(value16, value62, tweenInfo, {
		BackgroundColor3 = Color3_.new(0, 0, 0)
	}):Play()

	local value162 = t1.value16
	local value63 = t1.value63
	local tweenInfo2 = TweenInfo.new(0.2)
	local Color3_2 = Color3

	value162.Create(value162, value63, tweenInfo2, {
		Color = Color3_2.fromRGB(40, 40, 40)
	}):Play()
end)
t1.value64.MouseEnter:Connect(function()
	local value16 = t1.value16
	local value64 = t1.value64
	local tweenInfo = TweenInfo.new(0.2)
	local color3 = Color3.fromRGB

	value16.Create(value16, value64, tweenInfo, {
		BackgroundColor3 = color3(255, 60, 60)
	}):Play()
end)
t1.value64.MouseLeave:Connect(function()
	t1.value16:Create(t1.value64, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(220, 40, 40)
	}):Play()
end)
t1.value62.MouseButton1Click:Connect(function()
	local value16 = t1.value16
	local value61 = t1.value61
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local uDim2New = UDim2.new

	value16.Create(value16, value61, tweenInfo, {
		Size = uDim2New(0, 0, 0, 0)
	}):Play()
	task.delay(0.2, function()
		t1.value60.Visible = false
		t1.value61.Visible = false
	end)
end)
t1.value64.MouseButton1Click:Connect(function()
	t1.value33:Destroy()
end)
t1.value65 = (function(p26)
	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 300, 0, p26)
	Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame8.BackgroundTransparency = 0.15
	Frame8.BorderSizePixel = 0
	Frame8.ZIndex = 11
	Frame8.Visible = false
	Frame8.Parent = t1.value60

	local UIStroke5 = Instance.new("UIStroke")

	UIStroke5.Color = Color3.fromRGB(40, 40, 40)
	UIStroke5.Parent = Frame8

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, 0, 0, 2)
	Frame9.BackgroundColor3 = t1.value37.Accent
	Frame9.BorderSizePixel = 0
	Frame9.ZIndex = 12
	Frame9.Parent = Frame8
	v91(Frame9, t1.value37.Accent, t1.value37.AccentDark, 0)

	return Frame8
end)(350)

local TextLabel6 = Instance.new("TextLabel")

TextLabel6.Parent = t1.value65
TextLabel6.Text = "SCRIPT INFO"
TextLabel6:SetAttribute("OriginalText", "SCRIPT INFO")
TextLabel6.Size = UDim2.new(1, 0, 0, 35)
TextLabel6.TextColor3 = t1.value37.Accent
TextLabel6.BackgroundTransparency = 1
TextLabel6.Font = t1.value37.Font
TextLabel6.TextSize = 14

local TextButton2 = Instance.new("TextButton")

TextButton2.Parent = t1.value65
TextButton2.Text = "Close"
TextButton2:SetAttribute("OriginalText", "Close")
TextButton2.Size = UDim2.new(0, 260, 0, 30)
TextButton2.Position = UDim2.new(0, 20, 1, -40)
TextButton2.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton2.BackgroundTransparency = 0.45
TextButton2.TextColor3 = t1.value37.TextDark
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton2).Color = Color3.fromRGB(40, 40, 40)
t1.value66 = Instance.new("ScrollingFrame", t1.value65)
t1.value66.Size = UDim2.new(1, 0, 1, -85)
t1.value66.Position = UDim2.new(0, 0, 0, 35)
t1.value66.BackgroundTransparency = 1
t1.value66.BorderSizePixel = 0
t1.value66.ScrollBarThickness = 2
t1.value66.ScrollBarImageColor3 = t1.value37.Accent

local UIListLayout2 = Instance.new("UIListLayout", t1.value66)

UIListLayout2.Padding = UDim.new(0, 10)
UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
Close.MouseButton1Click:Connect(function()
	t1.value60.Visible = true
	t1.value61.Size = UDim2.new(0, 0, 0, 0)
	t1.value61.Visible = true

	local value16 = t1.value16
	local value61 = t1.value61
	local tweenInfoNew = TweenInfo.new
	local Enum_ = Enum

	value16.Create(value16, value61, tweenInfoNew(0.4, Enum_.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 310, 0, 165)
	}):Play()
	t1.value65.Visible = false
end)
Info.MouseButton1Click:Connect(function()
	t1.value60.Visible = true
	t1.value65.Visible = true
	t1.value61.Visible = false
end)
TextButton2.MouseButton1Click:Connect(function()
	t1.value60.Visible = false
	t1.value65.Visible = false
end)
t1.value67 = 1
t1.value68 = { "EN", "PT", "ES" }
t1.value56.MouseButton1Click:Connect(function()
	t1.value67 = t1.value67 + 1

	if t1.value67 > #t1.value68 then
		t1.value67 = 1
	end

	local v182 = t1.value68[t1.value67]

	t1.value56.Text = v182
	task.spawn(function()
		local ok2, result = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Translation2.8"))()
		end)

		if not (ok2 and result) then
			return
		end

		local Translate

		if type(result) == "table" then
			Translate = result.Translate
		else
			Translate = false
		end

		if Translate then
			result.Translate(t1.value33, v182)

			return
		end

		if type(result) ~= "function" then
			return
		end

		result(t1.value33, v182)
	end)
end)
t1.value57:GetPropertyChangedSignal("Text"):Connect(function()
	local v186 = t1.value57.Text:lower()
	local pairs_ = pairs
	local value59 = t1.value59

	for _, child in pairs_(value59.GetChildren(value59)) do
		if child:IsA("ScrollingFrame") then
			if child:GetAttribute("OldStyle") then
				local GetChildren = child.GetChildren

				for _, v in pairs(GetChildren(child)) do
					if v:IsA("Frame") or v:IsA("TextButton") then
						local TextLabel7 = v:FindFirstChildWhichIsA("TextLabel") or (v:IsA("TextButton") and v and v or nil)

						if (TextLabel7 and TextLabel7.Text or ""):lower():find(v186) then
							v.Visible = true
						elseif v186 ~= "" then
							v.Visible = false
						end
					end
				end
			else
				for _, child2 in pairs(child.GetChildren(child)) do
					if child2:IsA("Frame") and child2.Name == "LeftCol" and true or child2.Name == "RightCol" then
						for _, child3 in pairs(child2.GetChildren(child2)) do
							local isFrame = child3:IsA("Frame")

							if isFrame then
								isFrame = child3.Name:match("^CategoryBox_")
							end

							if isFrame then
								local GetChildren = child3.GetChildren
								local v201 = false

								for _, v in pairs(GetChildren(child3)) do
									if v:IsA("Frame") or v:IsA("TextButton") then
										if v.Name ~= "HeaderContainer" then
											local TextLabel7 = v:FindFirstChildWhichIsA("TextLabel") or (v:IsA("TextButton") and v and v or nil)

											if (TextLabel7 and TextLabel7.Text or ""):lower():find(v186) then
												v.Visible = true
												v201 = true
											elseif v186 ~= "" then
												v.Visible = false
											end
										end
									end
								end

								local v205

								if v186 == "" then
									v205 = false
								else
									v205 = not v201
								end

								if v205 then
									child3.Visible = false
								else
									child3.Visible = true
								end
							end
						end
					end
				end
			end
		end
	end
end)
t1.value15.InputBegan:Connect(function(input, gameProcessed)
	local v206 = not gameProcessed

	if v206 then
		v206 = input.KeyCode == t1.value48
	end

	if not v206 then
		return
	end

	if t1.value52.Visible then
		t1.value52.Visible = false
		t1.value55.Visible = false

		return
	end

	t1.value52.Visible = true
	t1.value55.Visible = false
end)
Minimize.MouseButton1Click:Connect(function()
	t1.value52.Visible = false
	t1.value55.Visible = true
end)
t1.value55.MouseButton1Click:Connect(function()
	t1.value52.Visible = true
	t1.value55.Visible = false
end)
t1.value69 = {}
t1.value69.CurrentSections = {}
t1.value69.Registry = {}
t1.value70 = {}
t1.value71 = {}
t1.value72 = {}

function t1.value73(p27)
	if p27:GetAttribute("OldStyle") then
		return t1.value71[p27] or p27
	elseif t1.value69.CurrentSections[p27] then
		return t1.value69.CurrentSections[p27]
	else
		return p27:FindFirstChild("LeftCol") or p27
	end
end
function t1.value74(p28)
	local v207 = t1.value24 .. "/" .. p28 .. ".json"

	local function v208()
		local isfile_ = isfile and isfile(v207)

		if isfile_ then
			isfile_ = readfile
		end

		local v210 = isfile_ and readfile(v207)

		if not v210 then
			return
		end

		local data = t1.value18:JSONDecode(v210)

		if type(data) ~= "table" then
			return
		end

		for k, v in pairs(data) do
			if k ~= "SettingsPage_UI Background" and k ~= "SettingsPage_Custom Background ID" then
				t1.value27[k] = v

				if t1.value69.Registry[k] then
					pcall(t1.value69.Registry[k].Set, v)
				end
			end
		end
	end

	pcall(v208)
end

t1.value74(v102)

local function createScrollingFrame(p29, p30, p31, p32)
	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = p30 .. "Page"
	ScrollingFrame.Size = UDim2.new(1, -20, 1, -10)
	ScrollingFrame.Position = UDim2.new(0, 10, 0, 5)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = t1.value37.Accent
	ScrollingFrame.ScrollBarImageTransparency = 0
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.Visible = false
	ScrollingFrame.Parent = t1.value59
	ScrollingFrame:SetAttribute("OldStyle", p32 == true)

	if p32 then
		local UIListLayout3 = Instance.new("UIListLayout")

		UIListLayout3.Padding = t1.value36.ItemPadding
		UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout3.Parent = ScrollingFrame

		local UIPadding2 = Instance.new("UIPadding")

		UIPadding2.PaddingBottom = UDim.new(0, 10)
		UIPadding2.Parent = ScrollingFrame
	else
		local UIListLayout3 = Instance.new("UIListLayout")

		UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout3.Padding = UDim.new(0, 12)
		UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout3.Parent = ScrollingFrame

		local UIPadding2 = Instance.new("UIPadding")

		UIPadding2.PaddingBottom = UDim.new(0, 10)
		UIPadding2.Parent = ScrollingFrame

		local Frame8 = Instance.new("Frame")

		Frame8.Name = "LeftCol"
		Frame8.Size = UDim2.new(0.5, -6, 0, 0)
		Frame8.AutomaticSize = Enum.AutomaticSize.Y
		Frame8.BackgroundTransparency = 1
		Frame8.Parent = ScrollingFrame

		local UIListLayout4 = Instance.new("UIListLayout")

		UIListLayout4.Padding = UDim.new(0, 10)
		UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout4.Parent = Frame8

		local Frame9 = Instance.new("Frame")

		Frame9.Name = "RightCol"
		Frame9.Size = UDim2.new(0.5, -6, 0, 0)
		Frame9.AutomaticSize = Enum.AutomaticSize.Y
		Frame9.BackgroundTransparency = 1
		Frame9.Parent = ScrollingFrame

		local UIListLayout5 = Instance.new("UIListLayout")

		UIListLayout5.Padding = UDim.new(0, 10)
		UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout5.Parent = Frame9

		local IntValue = Instance.new("IntValue")

		IntValue.Name = "SectionCount"
		IntValue.Value = 0
		IntValue.Parent = ScrollingFrame
	end

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, 0, 0, t1.value35.BtnHeight)
	TextButton3.BackgroundTransparency = 1
	TextButton3.Text = ""
	TextButton3.Parent = t1.value58

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 3, 0.7, 0)
	Frame8.Position = UDim2.new(0, 0, 0.15, 0)
	Frame8.BackgroundColor3 = t1.value37.Accent
	Frame8.BackgroundTransparency = 1
	Frame8.BorderSizePixel = 0
	Frame8.Parent = TextButton3
	v91(Frame8, t1.value37.Accent, t1.value37.AccentDark, 90)

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Image = "rbxassetid://" .. p29
	ImageLabel2.Size = UDim2.new(0, t1.value35.IconSize, 0, t1.value35.IconSize)
	ImageLabel2.Position = UDim2.new(0, 12, 0.5, -(t1.value35.IconSize / 2))
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.ScaleType = Enum.ScaleType.Fit
	ImageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel2.ImageTransparency = 0.2
	ImageLabel2.Parent = TextButton3

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Text = p30
	TextLabel7:SetAttribute("OriginalText", p30)
	TextLabel7.Size = UDim2.new(0, 100, 1, 0)
	TextLabel7.Position = UDim2.new(0, 34, 0, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextSize = t1.value35.FontSize
	TextLabel7.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel7.TextTransparency = 0.2
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.Parent = TextButton3
	t1.value45(TextLabel7)

	local function v229()
		for _, v in pairs(t1.value70) do
			v.Page.Visible = false
			v.Indicator.BackgroundTransparency = 1
			v.Label.TextTransparency = 0.2
			v.Icon.ImageTransparency = 0.2
		end

		ScrollingFrame.Visible = true
		Frame8.BackgroundTransparency = 0
		TextLabel7.TextTransparency = 0
		ImageLabel2.ImageTransparency = 0
	end

	TextButton3.MouseButton1Click:Connect(v229)

	local value70 = t1.value70

	table.insert(value70, {
		Page = ScrollingFrame,
		Indicator = Frame8,
		Label = TextLabel7,
		Icon = ImageLabel2
	})

	if not p31 then
		return ScrollingFrame
	end

	task.spawn(function()
		pcall(function()
			p31(ScrollingFrame)
		end)
	end)

	return ScrollingFrame
end

function t1.value69.CreateSection(_, p33, p34, p35)
	if not p33:GetAttribute("OldStyle") then
		local LeftCol

		if p35 == "Left" then
			LeftCol = p33.LeftCol
		elseif p35 == "Right" then
			LeftCol = p33.RightCol
		else
			p33.SectionCount.Value = p33.SectionCount.Value + 1
			LeftCol = p33.SectionCount.Value % 2 == 1 and p33.LeftCol or p33.RightCol
		end

		local Frame8 = Instance.new("Frame")

		Frame8.Name = "CategoryBox_" .. p34
		Frame8.Size = UDim2.new(1, -2, 0, 0)
		Frame8.Position = UDim2.new(0, 1, 0, 0)
		Frame8.AutomaticSize = Enum.AutomaticSize.Y
		Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
		Frame8.BackgroundTransparency = 0.45
		Frame8.BorderSizePixel = 0
		Frame8.Parent = LeftCol
		Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke")

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		UIStroke5.Parent = Frame8

		local UIListLayout3 = Instance.new("UIListLayout")

		UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout3.Padding = t1.value36.ItemPadding
		UIListLayout3.Parent = Frame8

		local UIPadding2 = Instance.new("UIPadding")

		UIPadding2.PaddingTop = UDim.new(0, 8)
		UIPadding2.PaddingBottom = UDim.new(0, 8)
		UIPadding2.PaddingLeft = UDim.new(0, 10)
		UIPadding2.PaddingRight = UDim.new(0, 10)
		UIPadding2.Parent = Frame8

		local Frame9 = Instance.new("Frame")

		Frame9.Name = "HeaderContainer"
		Frame9.Size = UDim2.new(1, 0, 0, 20)
		Frame9.BackgroundTransparency = 1
		Frame9.Parent = Frame8

		local TextLabel7 = Instance.new("TextLabel")

		TextLabel7.Size = UDim2.new(1, 0, 1, 0)
		TextLabel7.BackgroundTransparency = 1
		TextLabel7.Text = p34
		TextLabel7:SetAttribute("OriginalText", p34)
		TextLabel7.Font = t1.value37.Font
		TextLabel7.TextSize = 12
		TextLabel7.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel7.Parent = Frame9
		t1.value69.CurrentSections[p33] = Frame8

		return
	end

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, -2, 0, 25)
	Frame8.Position = UDim2.new(0, 1, 0, 0)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = p33

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(1, 0, 1, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p34
	TextLabel7:SetAttribute("OriginalText", p34)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextSize = 13
	TextLabel7.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.Parent = Frame8
	t1.value45(TextLabel7)

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, -(TextLabel7.TextBounds.X + 16), 0, 1)
	Frame9.Position = UDim2.new(0, TextLabel7.TextBounds.X + 8, 0.5, 0)
	Frame9.BackgroundColor3 = t1.value37.ItemStroke
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame8
	v91(Frame9, t1.value37.Accent, Color3.new(0, 0, 0), 0)
	TextLabel7:GetPropertyChangedSignal("TextBounds"):Connect(function()
		Frame9.Size = UDim2.new(1, -(TextLabel7.TextBounds.X + 16), 0, 1)
		Frame9.Position = UDim2.new(0, TextLabel7.TextBounds.X + 8, 0.5, 0)
	end)
end
function t1.value69.CreateButton(_, p36, p37, p38)
	local attribute = p36:GetAttribute("OldStyle")
	local v244 = t1.value73(p36)
	local ItemHeightOld

	if attribute then
		ItemHeightOld = t1.value36.ItemHeightOld
	else
		ItemHeightOld = attribute
	end

	local ItemHeightNew = ItemHeightOld or t1.value36.ItemHeightNew
	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightNew)
	TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	TextButton3.Text = ""
	TextButton3.Parent = v244

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(1, -10, 1, 0)
	TextLabel7.Position = UDim2.new(0, 5, 0, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p37
	TextLabel7:SetAttribute("OriginalText", p37)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	if attribute then
		TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
		TextButton3.BackgroundTransparency = 0.45
		Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke")

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		UIStroke5.Parent = TextButton3
		TextLabel7.Position = UDim2.new(0, 10, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		TextButton3.BackgroundTransparency = 1
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	TextButton3.MouseButton1Click:Connect(function()
		if not _G.NexVoidLog then
			pcall(p38)

			return
		end

		task.spawn(function()
			_G.NexVoidLog("Button", p37)
		end)
		pcall(p38)
	end)

	if attribute then
		return
	end

	TextButton3.MouseEnter:Connect(function()
		t1.value16:Create(TextLabel7, TweenInfo.new(0.2), {
			TextColor3 = t1.value37.Accent
		}):Play()
	end)

	local function v251()
		local value16 = t1.value16
		local v253 = TextLabel7
		local tweenInfo = TweenInfo.new(0.2)
		local value37 = t1.value37

		value16.Create(value16, v253, tweenInfo, {
			TextColor3 = value37.TextDark
		}):Play()
	end

	TextButton3.MouseLeave:Connect(v251)
end
function t1.value69.CreateToggle(_, p39, p40, p41, p42)
	local attribute = p39:GetAttribute("OldStyle")
	local v257 = t1.value73(p39)
	local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
	local v259 = p39.Name .. "_" .. p40
	local u260 = t1.value27[v259]

	if u260 == nil then
		u260 = p41 or false
	end

	t1.value27[v259] = u260

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
	TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	TextButton3.Text = ""
	TextButton3.Parent = v257

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(1, -40, 1, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p40
	TextLabel7:SetAttribute("OriginalText", p40)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	if attribute then
		TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
		TextButton3.BackgroundTransparency = 0.45
		Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke")

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		UIStroke5.Parent = TextButton3
		TextLabel7.Position = UDim2.new(0, 12, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		TextButton3.BackgroundTransparency = 1
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	local n3, n4, n5

	if attribute then
		n3 = 34
		n4 = 18
		n5 = 14
	else
		n3 = 30
		n4 = 14
		n5 = 12
	end

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, n3, 0, n4)
	Frame8.Position = attribute and UDim2.new(1, -46, 0.5, -9) or UDim2.new(1, -30, 0.5, -7)
	Frame8.BackgroundColor3 = t1.value37.SwitchOff
	Frame8.Parent = TextButton3
	Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)

	local v269 = v91(Frame8, t1.value37.SwitchOff, t1.value37.SwitchOff, 90)
	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(0, n5, 0, n5)
	Frame9.Position = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)
	Frame9.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	Frame9.Parent = Frame8
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

	local function v271(p43)
		local uDim2 = attribute and UDim2.new(1, -16, 0.5, -7) or UDim2.new(1, -13, 0.5, -6)
		local uDim22 = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)

		if u260 then
			t1.value16:Create(Frame8, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value37.Accent
			}):Play()
			v269.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.Accent), ColorSequenceKeypoint.new(1, t1.value37.AccentDark) })
			t1.value16:Create(Frame9, TweenInfo.new(0.2), {
				Position = uDim2,
				BackgroundColor3 = Color3.new(0, 0, 0)
			}):Play()

			if not attribute then
				local value16 = t1.value16
				local v275 = TextLabel7
				local tweenInfo = TweenInfo.new(0.2)
				local value37 = t1.value37

				value16.Create(value16, v275, tweenInfo, {
					TextColor3 = value37.Text
				}):Play()
			end
		else
			t1.value16:Create(Frame8, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value37.SwitchOff
			}):Play()
			v269.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.SwitchOff), ColorSequenceKeypoint.new(1, t1.value37.SwitchOff) })

			local value16 = t1.value16
			local v279 = Frame9
			local TweenInfo_ = TweenInfo

			value16.Create(value16, v279, TweenInfo_.new(0.2), {
				Position = uDim22,
				BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			}):Play()

			if not attribute then
				local value162 = t1.value16
				local v282 = TextLabel7
				local tweenInfo = TweenInfo.new(0.2)

				value162.Create(value162, v282, tweenInfo, {
					TextColor3 = t1.value37.TextDark
				}):Play()
			end
		end

		if not p43 then
			return
		end

		pcall(p42, u260)
	end
	local function v284(p44)
		u260 = p44
		t1.value27[v259] = u260
		v271(true)
	end

	TextButton3.MouseButton1Click:Connect(function()
		u260 = not u260
		v284(u260)

		if not _G.NexVoidLog then
			return
		end

		task.spawn(function()
			_G.NexVoidLog("Toggle", p40, u260)
		end)
	end)
	t1.value69.Registry[v259] = {
		Type = "Toggle",
		Set = v284,
		Default = p41 or false
	}

	if not u260 then
		v271(false)

		return {
			Set = v284
		}
	end

	task.spawn(function()
		pcall(p42, u260)
	end)
	v271(false)

	return {
		Set = v284
	}
end
function t1.value69.CreateToggleKeybind(_, p45, p46, p47, p48, p49)
	local attribute = p45:GetAttribute("OldStyle")
	local v286 = t1.value73(p45)
	local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
	local v288 = p45.Name .. "_" .. p46 .. "_State"
	local v289 = p45.Name .. "_" .. p46 .. "_Key"
	local u290 = t1.value27[v288]

	if u290 == nil then
		u290 = p47 or false
	end

	t1.value27[v288] = u290

	local v291 = t1.value27[v289]
	local v292 = v291 == nil and (p48 or "None") or v291

	t1.value27[v289] = v292

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
	TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	TextButton3.Text = ""
	TextButton3.Parent = v286

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(1, -110, 1, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p46
	TextLabel7:SetAttribute("OriginalText", p46)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	if attribute then
		TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
		TextButton3.BackgroundTransparency = 0.45
		Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke")

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		UIStroke5.Parent = TextButton3
		TextLabel7.Position = UDim2.new(0, 12, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		TextButton3.BackgroundTransparency = 1
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	local TextButton4 = Instance.new("TextButton")

	TextButton4.Size = attribute and UDim2.new(0, 45, 0, 20) or UDim2.new(0, 32, 0, 16)
	TextButton4.Position = attribute and UDim2.new(1, -100, 0.5, -10) or UDim2.new(1, -66, 0.5, -8)
	TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
	TextButton4.BackgroundTransparency = 0.45
	TextButton4.Text = v292 == "None" and attribute and "Set Key" or "Key" or v292
	TextButton4.TextColor3 = t1.value37.TextDark
	TextButton4.Font = Enum.Font.Gotham
	TextButton4.TextSize = 10
	TextButton4.Parent = TextButton3
	Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", TextButton4).Color = Color3.fromRGB(40, 40, 40)

	local TextButton5 = Instance.new("TextButton")

	TextButton5.Size = attribute and UDim2.new(0, 40, 0, 20) or UDim2.new(0, 26, 0, 16)
	TextButton5.Position = attribute and UDim2.new(1, -148, 0.5, -10) or UDim2.new(1, -96, 0.5, -8)
	TextButton5.BackgroundColor3 = Color3.new(0, 0, 0)
	TextButton5.BackgroundTransparency = 0.45
	TextButton5.Text = attribute and "Reset" or "Del"
	TextButton5.TextColor3 = t1.value37.CloseRed
	TextButton5.Font = Enum.Font.Gotham
	TextButton5.TextSize = 10
	TextButton5.Parent = TextButton3
	Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", TextButton5).Color = Color3.fromRGB(40, 40, 40)

	local n6, n7, n8

	if attribute then
		n6 = 34
		n7 = 18
		n8 = 14
	else
		n6 = 30
		n7 = 14
		n8 = 12
	end

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, n6, 0, n7)
	Frame8.Position = attribute and UDim2.new(1, -46, 0.5, -9) or UDim2.new(1, -30, 0.5, -7)
	Frame8.BackgroundColor3 = t1.value37.SwitchOff
	Frame8.Parent = TextButton3
	Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)

	local v303 = v91(Frame8, t1.value37.SwitchOff, t1.value37.SwitchOff, 90)
	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(0, n8, 0, n8)
	Frame9.Position = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)
	Frame9.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	Frame9.Parent = Frame8
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

	local function v305(p50)
		local uDim2 = attribute

		if uDim2 then
			uDim2 = UDim2.new(1, -16, 0.5, -7)
		end

		local uDim22 = uDim2 or UDim2.new(1, -13, 0.5, -6)
		local uDim23 = attribute

		if uDim23 then
			uDim23 = UDim2.new(0, 2, 0.5, -7)
		end

		local uDim24 = uDim23 or UDim2.new(0, 1, 0.5, -6)

		if u290 then
			local value16 = t1.value16
			local v311 = Frame8
			local tweenInfo = TweenInfo.new(0.2)
			local value37 = t1.value37

			value16.Create(value16, v311, tweenInfo, {
				BackgroundColor3 = value37.Accent
			}):Play()
			v303.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.Accent), ColorSequenceKeypoint.new(1, t1.value37.AccentDark) })

			local value162 = t1.value16
			local v315 = Frame9
			local tweenInfo2 = TweenInfo.new(0.2)
			local color3New = Color3.new

			value162.Create(value162, v315, tweenInfo2, {
				Position = uDim22,
				BackgroundColor3 = color3New(0, 0, 0)
			}):Play()

			if not attribute then
				local value163 = t1.value16
				local v319 = TextLabel7
				local TweenInfo_ = TweenInfo

				value163.Create(value163, v319, TweenInfo_.new(0.2), {
					TextColor3 = t1.value37.Text
				}):Play()
			end
		else
			local value16 = t1.value16
			local v322 = Frame8
			local tweenInfo = TweenInfo.new(0.2)

			value16.Create(value16, v322, tweenInfo, {
				BackgroundColor3 = t1.value37.SwitchOff
			}):Play()
			v303.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.SwitchOff), ColorSequenceKeypoint.new(1, t1.value37.SwitchOff) })

			local value162 = t1.value16
			local v325 = Frame9
			local tweenInfo2 = TweenInfo.new(0.2)

			value162.Create(value162, v325, tweenInfo2, {
				Position = uDim24,
				BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			}):Play()

			if not attribute then
				local value163 = t1.value16
				local v328 = TextLabel7
				local tweenInfo3 = TweenInfo.new(0.2)
				local value37 = t1.value37

				value163.Create(value163, v328, tweenInfo3, {
					TextColor3 = value37.TextDark
				}):Play()
			end
		end

		if not p50 then
			return
		end

		pcall(p49, u290)
	end

	local v331 = nil

	local function v332(p51)
		u290 = p51
		t1.value27[v288] = u290
		v331(true)
	end

	v331 = v305

	local function v333(p52)
		t1.value27[v289] = p52
		TextButton4.Text = p52 == "None" and attribute and "Set Key" or "Key" or p52
	end

	TextButton3.MouseButton1Click:Connect(function()
		u290 = not u290
		u290 = u290
		t1.value27[v288] = u290
		v331(true)

		if not _G.NexVoidLog then
			return
		end

		task.spawn(function()
			_G.NexVoidLog("Toggle", p46, u290)
		end)
	end)
	TextButton5.MouseButton1Click:Connect(function()
		t1.value27[v289] = "None"
		TextButton4.Text = attribute and "Set Key" or "Key" or "None"
	end)
	TextButton4.MouseButton1Click:Connect(function()
		TextButton4.Text = "..."

		local connection = nil

		connection = t1.value15.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if input.KeyCode == Enum.KeyCode.Escape and true or input.KeyCode == Enum.KeyCode.Backspace then
				t1.value27[v289] = "None"
				TextButton4.Text = attribute and "Set Key" or "Key" or "None"
			else
				local Name2 = input.KeyCode.Name

				t1.value27[v289] = Name2
				TextButton4.Text = Name2 == "None" and attribute and "Set Key" or "Key" or Name2
			end

			if not connection then
				return
			end

			connection:Disconnect()
		end)
	end)
	t1.value15.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local v336 = t1.value27[v289]

		if v336 then
			if v336 == "None" then
				v336 = false
			else
				v336 = input.KeyCode.Name == v336
			end
		end

		if not v336 then
			return
		end

		u290 = not u290
		u290 = u290
		t1.value27[v288] = u290
		v331(true)

		if not _G.NexVoidLog then
			return
		end

		task.spawn(function()
			_G.NexVoidLog("Toggle", p46 .. " (Keybind)", u290)
		end)
	end)
	t1.value69.Registry[v288] = {
		Type = "ToggleKeybindState",
		Set = v332,
		Default = p47 or false
	}
	t1.value69.Registry[v289] = {
		Type = "ToggleKeybindKey",
		Set = v333,
		Default = p48 or "None"
	}

	if not u290 then
		v331(false)

		return {
			Set = v332
		}
	end

	task.spawn(function()
		pcall(p49, u290)
	end)
	v331(false)

	return {
		Set = v332
	}
end
function t1.value69.CreateSlider(_, p53, p54, p55, p56, p57, p58)
	local attribute = p53:GetAttribute("OldStyle")
	local v338 = t1.value73(p53)
	local ItemHeightOld

	if attribute then
		ItemHeightOld = t1.value36.ItemHeightOld
	else
		ItemHeightOld = attribute
	end

	local v340 = ItemHeightOld or t1.value36.ItemHeightNew + 5
	local v341 = p53.Name .. "_" .. p54
	local v342 = t1.value27[v341]

	if v342 == nil then
		v342 = p57
	end

	local u343 = math.clamp(v342, p55, p56)

	t1.value27[v341] = u343

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, attribute and -2 or 0, 0, v340)
	Frame8.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	Frame8.Parent = v338

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p54
	TextLabel7:SetAttribute("OriginalText", p54)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextSize = 11
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = Frame8

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Size = UDim2.new(0, 40, 0, 20)
	TextLabel8.AnchorPoint = Vector2.new(1, 0)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = tostring(u343)
	TextLabel8.Font = t1.value37.Font
	TextLabel8.TextSize = 11
	TextLabel8.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel8.Parent = Frame8

	if attribute then
		Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
		Frame8.BackgroundTransparency = 0.45
		Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke", Frame8)

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		TextLabel7.Size = UDim2.new(1, -45, 0, 20)
		TextLabel7.Position = UDim2.new(0, 10, 0, 2)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
		TextLabel8.Position = UDim2.new(1, -10, 0, 2)
		TextLabel8.TextColor3 = t1.value37.TextDark
	else
		Frame8.BackgroundTransparency = 1
		TextLabel7.Size = UDim2.new(1, -45, 0, 20)
		TextLabel7.Position = UDim2.new(0, 5, 0, 2)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
		TextLabel8.Position = UDim2.new(1, -5, 0, 2)
		TextLabel8.TextColor3 = t1.value37.Text
	end

	local Frame9 = Instance.new("Frame")

	Frame9.Size = attribute and UDim2.new(1, -20, 0, 8) or UDim2.new(1, -10, 0, 8)
	Frame9.Position = attribute and UDim2.new(0, 10, 0, 25) or UDim2.new(0, 5, 0, 25)
	Frame9.BackgroundColor3 = t1.value37.SwitchOff
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame8
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

	local Frame10 = Instance.new("Frame")

	Frame10.Size = UDim2.new((u343 - p55) / (p56 - p55), 0, 1, 0)
	Frame10.BackgroundColor3 = t1.value37.Accent
	Frame10.BorderSizePixel = 0
	Frame10.Parent = Frame9
	Instance.new("UICorner", Frame10).CornerRadius = UDim.new(1, 0)
	v91(Frame10, t1.value37.Accent, t1.value37.AccentDark, 0)

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, 0, 1, 0)
	TextButton3.BackgroundTransparency = 1
	TextButton3.Text = ""
	TextButton3.Parent = Frame9

	local u352 = false

	local function v353(p59)
		local v354 = p55
		local v355 = p56

		u343 = math.clamp(p59, v354, v355)

		local v356 = (u343 - p55) / (p56 - p55)

		t1.value16:Create(Frame10, TweenInfo.new(0.2), {
			Size = UDim2.new(v356, 0, 1, 0)
		}):Play()

		local v357 = u343

		TextLabel8.Text = tostring(v357)
		t1.value27[v341] = u343
		pcall(p58, u343)
	end
	local function v358(p60)
		local v359 = p55
		local v360 = p56 - p55
		local uDim2New = UDim2.new
		local v362 = (p60.Position.X - Frame9.AbsolutePosition.X) / Frame9.AbsoluteSize.X
		local v363 = v359 + v360 * uDim2New(math.clamp(v362, 0, 1), 0, 1, 0).X.Scale

		v353((math.floor(v363)))
	end
	local function v364(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u352 = true
		v358(input)
	end

	TextButton3.InputBegan:Connect(v364)
	t1.value15.InputEnded:Connect(function(input)
		if not ((input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) and u352) then
			return
		end

		u352 = false

		if not _G.NexVoidLog then
			return
		end

		task.spawn(function()
			_G.NexVoidLog("Slider", p54, u343)
		end)
	end)
	t1.value15.InputChanged:Connect(function(input)
		if not (u352 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		v358(input)
	end)
	t1.value69.Registry[v341] = {
		Type = "Slider",
		Set = v353,
		Default = p57
	}
	task.spawn(function()
		pcall(p58, u343)
	end)

	return {
		Set = v353
	}
end
function t1.value69.CreateInput(_, p61, p62, p63, p64)
	local attribute = p61:GetAttribute("OldStyle")
	local v366 = t1.value73(p61)
	local ItemHeightOld

	if attribute then
		ItemHeightOld = t1.value36.ItemHeightOld
	else
		ItemHeightOld = attribute
	end

	local ItemHeightNew = ItemHeightOld or t1.value36.ItemHeightNew
	local v369 = p61.Name .. "_" .. p62
	local u370 = t1.value27[v369]

	if u370 == nil then
		u370 = p63
	end

	t1.value27[v369] = u370

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightNew)
	Frame8.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	Frame8.Parent = v366

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p62
	TextLabel7:SetAttribute("OriginalText", p62)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = Frame8

	local TextBox = Instance.new("TextBox")

	TextBox.BackgroundColor3 = t1.value37.SwitchOff
	TextBox.Text = tostring(u370)
	TextBox.TextColor3 = t1.value37.Text
	TextBox.Font = t1.value37.Font
	TextBox.TextSize = 12
	TextBox.TextScaled = false
	TextBox.ClipsDescendants = true
	TextBox.Parent = Frame8
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

	local v375 = t1.value72[p61]

	if attribute then
		if v375 then
			Frame8.BackgroundTransparency = 1
			TextBox.BackgroundColor3 = Color3.new(0, 0, 0)
			TextBox.BackgroundTransparency = 0.45

			local UIStroke5 = Instance.new("UIStroke", TextBox)

			UIStroke5.Color = Color3.fromRGB(40, 40, 40)
			UIStroke5.Thickness = 1
		else
			Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
			Frame8.BackgroundTransparency = 0.45
			Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

			local UIStroke5 = Instance.new("UIStroke", Frame8)

			UIStroke5.Color = Color3.fromRGB(40, 40, 40)
			UIStroke5.Thickness = 1
		end

		TextLabel7.Size = UDim2.new(1, -90, 1, 0)
		TextLabel7.Position = UDim2.new(0, 10, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
		TextBox.Size = UDim2.new(0, 70, 0, 26)
		TextBox.Position = UDim2.new(1, -80, 0.5, -13)
	else
		Frame8.BackgroundTransparency = 1
		TextLabel7.Size = UDim2.new(1, -75, 1, 0)
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
		TextBox.Size = UDim2.new(0, 60, 0, 24)
		TextBox.Position = UDim2.new(1, -65, 0.5, -12)
	end

	local function v378(p65)
		u370 = p65
		TextBox.Text = tostring(p65)
		t1.value27[v369] = p65
		pcall(p64, p65)
	end

	TextBox.FocusLost:Connect(function()
		local Text = TextBox.Text
		local Text2 = tonumber(Text) or (TextBox.Text ~= "" and TextBox.Text or u370)

		u370 = Text2
		TextBox.Text = tostring(Text2)
		t1.value27[v369] = Text2
		pcall(p64, Text2)

		if not _G.NexVoidLog then
			return
		end

		task.spawn(function()
			local v381 = Text2

			_G.NexVoidLog("Input", p62, (tostring(v381)))
		end)
	end)
	t1.value69.Registry[v369] = {
		Type = "Input",
		Set = v378,
		Default = p63
	}
	task.spawn(function()
		pcall(p64, u370)
	end)

	return {
		Set = v378
	}
end
function t1.value69.CreateDropdown(_, p66, p67, p68, p69, p70)
	local v382 = p66.GetAttribute(p66, "OldStyle")
	local v383 = t1.value73(p66)
	local ItemHeightOld = v382 and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
	local v385 = p66.Name .. "_" .. p67
	local u386 = t1.value27[v385] or (p69 or p68[1])

	t1.value27[v385] = u386

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, v382 and -2 or 0, 0, ItemHeightOld)
	Frame8.Position = UDim2.new(0, v382 and 1 or 0, 0, 0)
	Frame8.ClipsDescendants = true
	Frame8.Parent = v383

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
	TextButton3.BackgroundTransparency = 1
	TextButton3.Text = ""
	TextButton3.Parent = Frame8

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p67 .. ": " .. tostring(u386)
	TextLabel7:SetAttribute("OriginalText", p67)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	local v391 = t1.value72[p66]

	if v382 then
		if v391 then
			Frame8.BackgroundTransparency = 1
		else
			Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
			Frame8.BackgroundTransparency = 0.45
			Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

			local UIStroke5 = Instance.new("UIStroke", Frame8)

			UIStroke5.Color = Color3.fromRGB(40, 40, 40)
			UIStroke5.Thickness = 1
		end

		TextLabel7.Size = UDim2.new(1, -40, 1, 0)
		TextLabel7.Position = UDim2.new(0, 15, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		Frame8.BackgroundTransparency = 1
		TextLabel7.Size = UDim2.new(1, -25, 1, 0)
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	if not v382 then
		TextButton3.MouseEnter:Connect(function()
			local value16 = t1.value16
			local v394 = TextLabel7
			local TweenInfo_ = TweenInfo

			value16.Create(value16, v394, TweenInfo_.new(0.2), {
				TextColor3 = t1.value37.Accent
			}):Play()
		end)
		TextButton3.MouseLeave:Connect(function()
			local value16 = t1.value16
			local v397 = TextLabel7
			local tweenInfo = TweenInfo.new(0.2)

			value16.Create(value16, v397, tweenInfo, {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end)
	end

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Size = UDim2.new(0, 20, 0, 20)
	TextLabel8.Position = v382 and UDim2.new(1, -30, 0.5, -10) or UDim2.new(1, -20, 0.5, -10)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = "▼"
	TextLabel8.TextColor3 = t1.value37.TextDark
	TextLabel8.Font = Enum.Font.Gotham
	TextLabel8.TextSize = 12
	TextLabel8.Parent = TextButton3

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, 0, 1, -ItemHeightOld)
	Frame9.Position = UDim2.new(0, 0, 0, ItemHeightOld)
	Frame9.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame9.BackgroundTransparency = 0.45
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame8

	local Frame10 = Instance.new("Frame")

	Frame10.Size = UDim2.new(0, 2, 1, 0)
	Frame10.Position = UDim2.new(1, -2, 0, 0)
	Frame10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame10.BorderSizePixel = 0
	Frame10.ZIndex = 5
	Frame10.Parent = Frame9

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Size = UDim2.new(1, -4, 1, 0)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = t1.value37.Accent
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Parent = Frame9

	local UIListLayout3 = Instance.new("UIListLayout")

	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.Parent = ScrollingFrame

	local u404 = false

	local function v405(p71)
		u386 = p71
		t1.value27[v385] = u386

		if TextLabel7:GetAttribute("OriginalText") then
			local Text = TextLabel7.Text
			local v407 = u386

			TextLabel7.Text = string.split(Text, ": ")[1] .. ": " .. tostring(v407)
		else
			local v408 = u386

			TextLabel7.Text = p67 .. ": " .. tostring(v408)
		end

		local v409 = ScrollingFrame

		for _, child in pairs(v409.GetChildren(v409)) do
			if child:IsA("TextButton") then
				if child.Text == tostring(p71) then
					child.TextColor3 = t1.value37.Text
					child.Font = Enum.Font.GothamBold
				else
					child.TextColor3 = t1.value37.TextDark
					child.Font = Enum.Font.Gotham
				end
			end
		end

		pcall(p70, u386)
	end

	TextButton3.MouseButton1Click:Connect(function()
		u404 = not u404

		if u404 then
			local v412 = v382 and 30 or 26
			local v413 = v382 and 180 or 160
			local value16 = t1.value16
			local v415 = Frame8
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local Create = value16.Create
			local uDim2New = UDim2.new
			local v419 = v382 and -2 or 0
			local v420 = ItemHeightOld + #p68 * v412

			Create(value16, v415, tweenInfo, {
				Size = uDim2New(1, v419, 0, (math.min(v420, v413)))
			}):Play()
			TextLabel8.Text = "▲"

			local value162 = t1.value16
			local v422 = TextLabel8
			local tweenInfo2 = TweenInfo.new(0.3)
			local value37 = t1.value37

			value162.Create(value162, v422, tweenInfo2, {
				TextColor3 = value37.Accent
			}):Play()
		else
			local value16 = t1.value16
			local v426 = Frame8
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local UDim2_ = UDim2

			value16.Create(value16, v426, tweenInfo, {
				Size = UDim2_.new(1, v382 and -2 or 0, 0, ItemHeightOld)
			}):Play()
			TextLabel8.Text = "▼"

			local value162 = t1.value16
			local v430 = TextLabel8
			local TweenInfo_ = TweenInfo

			value162.Create(value162, v430, TweenInfo_.new(0.3), {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end
	end)

	local function v432(p72)
		local TextButton4 = Instance.new("TextButton")

		TextButton4.Size = UDim2.new(1, 0, 0, v382 and 30 or 26)
		TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
		TextButton4.BackgroundTransparency = 1
		TextButton4.Text = tostring(p72)
		TextButton4.TextColor3 = u386 == p72 and t1.value37.Text or t1.value37.TextDark
		TextButton4.Font = u386 == p72 and Enum.Font.GothamBold or Enum.Font.Gotham
		TextButton4.TextSize = 11
		TextButton4.TextXAlignment = Enum.TextXAlignment.Center
		TextButton4.Parent = ScrollingFrame

		local Frame11 = Instance.new("Frame")

		Frame11.Size = UDim2.new(1, -20, 0, 1)
		Frame11.Position = UDim2.new(0, 10, 1, -1)
		Frame11.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Frame11.BorderSizePixel = 0
		Frame11.Parent = TextButton4
		TextButton4.MouseEnter:Connect(function()
			if u386 == p72 then
				return
			end

			local value16 = t1.value16
			local v436 = TextButton4
			local tweenInfo = TweenInfo.new(0.2)

			value16.Create(value16, v436, tweenInfo, {
				TextColor3 = t1.value37.Text
			}):Play()
		end)
		TextButton4.MouseLeave:Connect(function()
			if u386 == p72 then
				return
			end

			t1.value16:Create(TextButton4, TweenInfo.new(0.2), {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end)
		TextButton4.MouseButton1Click:Connect(function()
			v405(p72)

			local value16 = t1.value16
			local v439 = Frame8
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local uDim2New = UDim2.new
			local v442 = v382

			value16.Create(value16, v439, tweenInfo, {
				Size = uDim2New(1, v442 and -2 or 0, 0, ItemHeightOld)
			}):Play()
			TextLabel8.Text = "▼"

			local value162 = t1.value16
			local v444 = TextLabel8
			local tweenInfo2 = TweenInfo.new(0.3)
			local value37 = t1.value37

			value162.Create(value162, v444, tweenInfo2, {
				TextColor3 = value37.TextDark
			}):Play()

			if not _G.NexVoidLog then
				return
			end

			task.spawn(function()
				local v447 = p72

				_G.NexVoidLog("Dropdown", p67, (tostring(v447)))
			end)
		end)
	end

	for _, v in ipairs(p68) do
		v432(v)
	end

	t1.value69.Registry[v385] = {
		Type = "Dropdown",
		Set = v405,
		Default = p69 or p68[1]
	}
	task.spawn(function()
		pcall(p70, u386)
	end)

	return {
		Set = v405
	}
end
function t1.value69.CreatePlayerDropdown(_, p73, p74, p75, p76)
	local v450 = p73.GetAttribute(p73, "OldStyle")
	local v451 = t1.value73(p73)
	local ItemHeightOld = v450 and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
	local v453 = p73.Name .. "_" .. p74
	local u454 = t1.value27[v453] or (p75 or "Select Player")

	t1.value27[v453] = u454

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, v450 and -2 or 0, 0, ItemHeightOld)
	Frame8.Position = UDim2.new(0, v450 and 1 or 0, 0, 0)
	Frame8.ClipsDescendants = true
	Frame8.Parent = v451

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
	TextButton3.BackgroundTransparency = 1
	TextButton3.Text = ""
	TextButton3.Parent = Frame8

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p74 .. ": " .. tostring(u454)
	TextLabel7:SetAttribute("OriginalText", p74)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	if v450 then
		Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
		Frame8.BackgroundTransparency = 0.45
		Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke", Frame8)

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		TextLabel7.Size = UDim2.new(1, -40, 1, 0)
		TextLabel7.Position = UDim2.new(0, 15, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		Frame8.BackgroundTransparency = 1
		TextLabel7.Size = UDim2.new(1, -40, 1, 0)
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	if not v450 then
		local function v460()
			local value16 = t1.value16
			local v462 = TextLabel7
			local TweenInfo_ = TweenInfo

			value16.Create(value16, v462, TweenInfo_.new(0.3), {
				TextColor3 = t1.value37.Accent
			}):Play()
		end

		TextButton3.MouseEnter:Connect(v460)

		local function v464()
			local value16 = t1.value16
			local v466 = TextLabel7
			local tweenInfo = TweenInfo.new(0.3)
			local value37 = t1.value37

			value16.Create(value16, v466, tweenInfo, {
				TextColor3 = value37.TextDark
			}):Play()
		end

		TextButton3.MouseLeave:Connect(v464)
	end

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Size = UDim2.new(0, 20, 0, 20)
	TextLabel8.Position = v450 and UDim2.new(1, -30, 0.5, -10) or UDim2.new(1, -25, 0.5, -10)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = "▼"
	TextLabel8.TextColor3 = t1.value37.TextDark
	TextLabel8.Font = Enum.Font.Gotham
	TextLabel8.TextSize = 12
	TextLabel8.Parent = TextButton3

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, 0, 1, -ItemHeightOld)
	Frame9.Position = UDim2.new(0, 0, 0, ItemHeightOld)
	Frame9.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame9.BackgroundTransparency = 0.45
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame8

	local Frame10 = Instance.new("Frame")

	Frame10.Size = UDim2.new(0, 2, 1, 0)
	Frame10.Position = UDim2.new(1, -2, 0, 0)
	Frame10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame10.BorderSizePixel = 0
	Frame10.ZIndex = 5
	Frame10.Parent = Frame9

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Size = UDim2.new(1, -4, 1, 0)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = t1.value37.Accent
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Parent = Frame9

	local UIListLayout3 = Instance.new("UIListLayout")

	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.Parent = ScrollingFrame

	local u474 = false

	local function v475(p77)
		u454 = p77
		t1.value27[v453] = u454

		if TextLabel7:GetAttribute("OriginalText") then
			local Text = TextLabel7.Text
			local v477 = u454

			TextLabel7.Text = string.split(Text, ": ")[1] .. ": " .. tostring(v477)
		else
			local v478 = u454

			TextLabel7.Text = p74 .. ": " .. tostring(v478)
		end

		pcall(p76, u454)
	end
	local function v479(p78)
		local TextButton4 = Instance.new("TextButton")

		TextButton4.Size = UDim2.new(1, 0, 0, v450 and 30 or 26)
		TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
		TextButton4.BackgroundTransparency = 1
		TextButton4.Text = tostring(p78)
		TextButton4.TextColor3 = u454 == p78 and t1.value37.Text or t1.value37.TextDark
		TextButton4.Font = u454 == p78 and Enum.Font.GothamBold or Enum.Font.Gotham
		TextButton4.TextSize = 11
		TextButton4.TextXAlignment = Enum.TextXAlignment.Center
		TextButton4.Parent = ScrollingFrame

		local Frame11 = Instance.new("Frame")

		Frame11.Size = UDim2.new(1, -20, 0, 1)
		Frame11.Position = UDim2.new(0, 10, 1, -1)
		Frame11.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Frame11.BorderSizePixel = 0
		Frame11.Parent = TextButton4
		TextButton4.MouseEnter:Connect(function()
			if u454 == p78 then
				return
			end

			local value16 = t1.value16
			local v483 = TextButton4
			local tweenInfo = TweenInfo.new(0.2)
			local value37 = t1.value37

			value16.Create(value16, v483, tweenInfo, {
				TextColor3 = value37.Text
			}):Play()
		end)
		TextButton4.MouseLeave:Connect(function()
			if u454 == p78 then
				return
			end

			local value16 = t1.value16
			local v487 = TextButton4
			local tweenInfo = TweenInfo.new(0.2)

			value16.Create(value16, v487, tweenInfo, {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end)
		TextButton4.MouseButton1Click:Connect(function()
			v475(p78)
			u474 = false

			local value16 = t1.value16
			local v490 = Frame8
			local tweenInfoNew = TweenInfo.new
			local Enum_ = Enum

			value16.Create(value16, v490, tweenInfoNew(0.3, Enum_.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, v450 and -2 or 0, 0, ItemHeightOld)
			}):Play()
			TextLabel8.Text = "▼"

			local value162 = t1.value16
			local v494 = TextLabel8
			local tweenInfo = TweenInfo.new(0.3)
			local value37 = t1.value37

			value162.Create(value162, v494, tweenInfo, {
				TextColor3 = value37.TextDark
			}):Play()

			if not _G.NexVoidLog then
				return
			end

			task.spawn(function()
				local v497 = p78

				_G.NexVoidLog("Dropdown", p74, (tostring(v497)))
			end)
		end)
	end

	local MouseButton1Click = TextButton3.MouseButton1Click

	MouseButton1Click.Connect(MouseButton1Click, function()
		u474 = not u474

		if u474 then
			local v499, v500, v501 = ipairs(ScrollingFrame:GetChildren())

			while true do
				local v502

				v501, v502 = v499(v500, v501)

				if not v501 then
					break
				end

				if v502:IsA("TextButton") then
					v502:Destroy()
				end
			end

			local players = t1.value14:GetPlayers()
			local n9 = 0

			for _, player in ipairs(players) do
				if player ~= t1.value23 then
					v479(player.Name)
					n9 = n9 + 1
				end
			end

			local v507 = v450 and 30 or 26
			local v508 = v450 and 180 or 160
			local v509 = ItemHeightOld + n9 * v507
			local v510 = math.min(v509, v508)

			if v510 ~= ItemHeightOld then
				v588 = t1.value16
				v589 = Frame8
				v590 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				v591 = UDim2.new
				v592 = v450
				v588.Create(v588, v589, v590, {
					Size = v591(1, v592 and -2 or 0, 0, v510)
				}):Play()
				TextLabel8.Text = "▲"
				v593 = t1.value16
				v594 = TextLabel8
				v595 = TweenInfo.new(0.3)
				v593.Create(v593, v594, v595, {
					TextColor3 = t1.value37.Accent
				}):Play()

				return
			end

			v510 = ItemHeightOld + v507

			local value16 = t1.value16
			local v512 = Frame8
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local uDim2New = UDim2.new
			local v515 = v450

			value16.Create(value16, v512, tweenInfo, {
				Size = uDim2New(1, v515 and -2 or 0, 0, v510)
			}):Play()
			TextLabel8.Text = "▲"

			local value162 = t1.value16
			local v517 = TextLabel8
			local tweenInfo2 = TweenInfo.new(0.3)

			value162.Create(value162, v517, tweenInfo2, {
				TextColor3 = t1.value37.Accent
			}):Play()
		else
			local value16 = t1.value16
			local v520 = Frame8
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value16.Create(value16, v520, tweenInfoNew(0.3, EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, v450 and -2 or 0, 0, ItemHeightOld)
			}):Play()
			TextLabel8.Text = "▼"
			t1.value16:Create(TextLabel8, TweenInfo.new(0.3), {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end
	end)
	t1.value69.Registry[v453] = {
		Type = "PlayerDropdown",
		Set = v475,
		Default = p75 or "Select Player"
	}
	task.spawn(function()
		pcall(p76, u454)
	end)

	return {
		Set = v475
	}
end
function t1.value69.CreateColorPicker(_, p79, p80, p81, p82)
	local attribute = p79:GetAttribute("OldStyle")
	local v524 = t1.value73(p79)
	local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
	local v526 = p79.Name .. "_" .. p80
	local color3 = t1.value27[v526]

	if color3 then
		if type(color3) == "string" then
			color3 = Color3.fromHex(color3)
		end
	else
		color3 = p81
	end

	t1.value27[v526] = color3:ToHex()

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
	Frame8.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
	Frame8.ClipsDescendants = true
	Frame8.Parent = v524

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
	TextButton3.BackgroundTransparency = 1
	TextButton3.Text = ""
	TextButton3.Parent = Frame8

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p80
	TextLabel7:SetAttribute("OriginalText", p80)
	TextLabel7.Font = t1.value37.Font
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextScaled = true

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel7)

	UITextSizeConstraint.MinTextSize = 7
	TextLabel7.Parent = TextButton3

	if attribute then
		Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
		Frame8.BackgroundTransparency = 0.45
		Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

		local UIStroke5 = Instance.new("UIStroke", Frame8)

		UIStroke5.Color = Color3.fromRGB(40, 40, 40)
		UIStroke5.Thickness = 1
		TextLabel7.Size = UDim2.new(1, -40, 1, 0)
		TextLabel7.Position = UDim2.new(0, 10, 0, 0)
		UITextSizeConstraint.MaxTextSize = 12
		TextLabel7.TextColor3 = t1.value37.Text
	else
		Frame8.BackgroundTransparency = 1
		TextLabel7.Size = UDim2.new(1, -40, 1, 0)
		TextLabel7.Position = UDim2.new(0, 5, 0, 0)
		UITextSizeConstraint.MaxTextSize = 11
		TextLabel7.TextColor3 = t1.value37.TextDark
	end

	if not attribute then
		TextButton3.MouseEnter:Connect(function()
			local value16 = t1.value16
			local v534 = TextLabel7
			local tweenInfo = TweenInfo.new(0.3)
			local value37 = t1.value37

			value16.Create(value16, v534, tweenInfo, {
				TextColor3 = value37.Accent
			}):Play()
		end)

		local function v537()
			t1.value16:Create(TextLabel7, TweenInfo.new(0.3), {
				TextColor3 = t1.value37.TextDark
			}):Play()
		end

		TextButton3.MouseLeave:Connect(v537)
	end

	local Frame9 = Instance.new("Frame")

	Frame9.Size = attribute and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 24, 0, 20)
	Frame9.Position = attribute and UDim2.new(1, -34, 0.5, -12) or UDim2.new(1, -29, 0.5, -10)
	Frame9.BackgroundColor3 = color3
	Frame9.Parent = TextButton3
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 4)

	local Frame10 = Instance.new("Frame")

	Frame10.Size = UDim2.new(1, 0, 0, 110)
	Frame10.Position = UDim2.new(0, 0, 0, ItemHeightOld)
	Frame10.BackgroundTransparency = 1
	Frame10.Parent = Frame8

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Size = attribute and UDim2.new(0, 150, 0, 90) or UDim2.new(0, 140, 0, 90)
	ImageButton.Position = UDim2.new(0, 10, 0, 10)
	ImageButton.AutoButtonColor = false
	ImageButton.Parent = Frame10

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = "rbxassetid://4155801252"
	ImageLabel2.Parent = ImageButton

	local Frame11 = Instance.new("Frame")

	Frame11.Size = UDim2.new(0, 6, 0, 6)
	Frame11.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame11.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame11.Parent = ImageButton
	Instance.new("UICorner", Frame11).CornerRadius = UDim.new(1, 0)

	local ImageButton2 = Instance.new("ImageButton")

	ImageButton2.Size = UDim2.new(0, 20, 0, 90)
	ImageButton2.Position = attribute and UDim2.new(0, 170, 0, 10) or UDim2.new(0, 160, 0, 10)
	ImageButton2.AutoButtonColor = false
	ImageButton2.BackgroundColor3 = Color3.new(1, 1, 1)
	ImageButton2.Parent = Frame10

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	})
	UIGradient.Rotation = 90
	UIGradient.Parent = ImageButton2

	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(1, 0, 0, 2)
	Frame12.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame12.AnchorPoint = Vector2.new(0, 0.5)
	Frame12.Parent = ImageButton2

	local v546, v547, v548 = color3:ToHSV()
	local v638_ = v546
	local v639_ = v547
	local v640_ = v548

	local function v552()
		local color32 = Color3.fromHSV(v638_, v639_, v640_)

		color3 = color32
		Frame9.BackgroundColor3 = color32
		ImageButton.BackgroundColor3 = Color3.fromHSV(v638_, 1, 1)
		t1.value27[v526] = color32:ToHex()
		pcall(p82, color32)
	end

	local u554 = false
	local u555 = false

	local function v556(p83)
		if type(p83) ~= "string" then
			color3 = p83
			Frame9.BackgroundColor3 = p83
			ImageButton.BackgroundColor3 = Color3.fromHSV(p83:ToHSV())
			v638, v639, v640 = p83:ToHSV()
			v638_ = v638
			v639_ = v639
			v640_ = v640
			v641 = Frame12
			v642 = UDim2.new
			v643 = 1 - v638_
			v641.Position = v642(0, 0, math.clamp(v643, 0, 1), 0)
			v644 = Frame11
			v645 = UDim2.new
			v646 = v639_
			v647 = math.clamp(v646, 0, 1)
			v648 = 1 - v640_
			v644.Position = v645(v647, 0, math.clamp(v648, 0, 1), 0)
			v649 = p83.ToHex
			t1.value27[v526] = v649(p83)
			pcall(p82, p83)

			return
		end

		p83 = Color3.fromHex(p83)
		color3 = p83
		Frame9.BackgroundColor3 = p83
		ImageButton.BackgroundColor3 = Color3.fromHSV(p83:ToHSV())

		local v557, v558, v559 = p83:ToHSV()

		v638_ = v557
		v639_ = v558
		v640_ = v559

		local v560 = Frame12
		local uDim2New = UDim2.new
		local v562 = 1 - v638_

		v560.Position = uDim2New(0, 0, math.clamp(v562, 0, 1), 0)

		local v563 = Frame11
		local uDim2New2 = UDim2.new
		local v565 = v639_
		local v566 = math.clamp(v565, 0, 1)
		local v567 = 1 - v640_

		v563.Position = uDim2New2(v566, 0, math.clamp(v567, 0, 1), 0)

		local ToHex = p83.ToHex

		t1.value27[v526] = ToHex(p83)
		pcall(p82, p83)
	end
	local function v569()
		local v570 = Frame12
		local uDim2New = UDim2.new
		local v572 = 1 - v638_

		v570.Position = uDim2New(0, 0, math.clamp(v572, 0, 1), 0)

		local v573 = Frame11
		local uDim2New2 = UDim2.new
		local v575 = v639_
		local v576 = math.clamp(v575, 0, 1)
		local v577 = 1 - v640_

		v573.Position = uDim2New2(v576, 0, math.clamp(v577, 0, 1), 0)
		v552()
	end

	local v578 = nil

	local function v579(p84)
		local v580 = (p84.Position.Y - ImageButton2.AbsolutePosition.Y) / ImageButton2.AbsoluteSize.Y
		local _ = 1 - math.clamp(v580, 0, 1)

		v578()
	end

	v578 = v569
	v578()
	ImageButton.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u554 = true

		local isScrollingFrame = p79

		if isScrollingFrame then
			isScrollingFrame = p79:IsA("ScrollingFrame")
		end

		if isScrollingFrame then
			p79.ScrollingEnabled = false
		end

		local v583 = (input.Position.X - ImageButton.AbsolutePosition.X) / ImageButton.AbsoluteSize.X

		math.clamp(v583, 0, 1)

		local v584 = (input.Position.Y - ImageButton.AbsolutePosition.Y) / ImageButton.AbsoluteSize.Y
		local _ = 1 - math.clamp(v584, 0, 1)

		v578()
	end)
	ImageButton2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u555 = true

		local isScrollingFrame = p79

		if isScrollingFrame then
			isScrollingFrame = p79:IsA("ScrollingFrame")
		end

		if isScrollingFrame then
			p79.ScrollingEnabled = false
		end

		v579(input)
	end)
	t1.value15.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		if (u554 or u555) and _G.NexVoidLog then
			task.spawn(function()
				_G.NexVoidLog("Input", p80, "#" .. color3:ToHex())
			end)
		end

		u554 = false
		u555 = false

		local isScrollingFrame = p79

		if isScrollingFrame then
			isScrollingFrame = p79:IsA("ScrollingFrame")
		end

		if not isScrollingFrame then
			return
		end

		p79.ScrollingEnabled = true
	end)
	t1.value15.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		if u554 then
			local v596 = (input.Position.X - ImageButton.AbsolutePosition.X) / ImageButton.AbsoluteSize.X

			math.clamp(v596, 0, 1)

			local v597 = (input.Position.Y - ImageButton.AbsolutePosition.Y) / ImageButton.AbsoluteSize.Y
			local _ = 1 - math.clamp(v597, 0, 1)

			v578()

			return
		end

		if not u555 then
			return
		end

		v579(input)
	end)

	local u598 = false

	TextButton3.MouseButton1Click:Connect(function()
		u598 = not u598

		if u598 then
			Frame8.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld + 110)
		else
			Frame8.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
		end
	end)
	t1.value69.Registry[v526] = {
		Type = "ColorPicker",
		Set = v556,
		Default = p81
	}
	task.spawn(function()
		pcall(p82, color3)
	end)

	return {
		Set = v556
	}
end

local v599 = createScrollingFrame("89172331085803", "Highlight")

createScrollingFrame("16475825226", "Visual", function(p85)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Visual2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p85,
		Workspace = t1.value22,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		RunService = t1.value17,
		CoreGui = t1.value19,
		Theme = t1.value37,
		UserConfigs = t1.value27,
		SendNotification = t1.value31,
		isMobile = t1.value34
	})
end)
createScrollingFrame("117215481109731", "Progress", function(p86)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Progress2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p86,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		Workspace = t1.value22,
		CoreGui = t1.value19,
		ReplicatedStorage = t1.value21,
		RunService = t1.value17,
		TweenService = t1.value16,
		Theme = t1.value37,
		SendNotification = t1.value31
	})
end)
createScrollingFrame("12623720992", "Textures", function(p87)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Textures2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p87,
		Workspace = t1.value22,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		RunService = t1.value17,
		TweenService = t1.value16,
		UserInputService = t1.value15,
		Theme = t1.value37,
		UserConfigs = t1.value27,
		GetParentTarget = t1.value73,
		isMobile = t1.value34,
		ContentConfig = t1.value36,
		UpdateCursorSizes = v88,
		SetPCCursorActive = t1.value43,
		MobileCrosshair = t1.value41,
		PCSoftwareCursor = t1.value42
	})
end)
createScrollingFrame("12684119225", "Auto Farm", function(p88)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Autofarm2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p88,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		Workspace = t1.value22,
		ReplicatedStorage = t1.value21,
		SendNotification = t1.value31
	})
end)
createScrollingFrame("106546587226077", "Fog", function(p89)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Fog2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p89,
		Lighting = t1.value20,
		RunService = t1.value17,
		SendNotification = t1.value31
	})
end)
createScrollingFrame("13288142767", "Sounds", function(p90)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Sounds2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p90,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		Workspace = t1.value22,
		TweenService = t1.value16,
		Theme = t1.value37,
		UserConfigs = t1.value27,
		GetParentTarget = t1.value73
	})
end, true)
createScrollingFrame("7485051715", "Advanced", function(p91)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Advanced2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p91,
		Workspace = t1.value22,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		RunService = t1.value17,
		UserInputService = t1.value15,
		ReplicatedStorage = t1.value21,
		CoreGui = t1.value19
	})
end)
createScrollingFrame("11656483170", "Visual Skins", function(p92)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/VisualSkins2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p92,
		Workspace = t1.value22,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		RunService = t1.value17,
		TweenService = t1.value16,
		Theme = t1.value37,
		SendNotification = t1.value31,
		ModalOverlay = t1.value60,
		ApplyGradient = v91
	})
end, true)
createScrollingFrame("12689978575", "Teleport", function(p93)
	local ok2, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Teleport2.8")
	end)

	if not (ok2 and result) then
		return
	end

	loadstring(result)()({
		Library = t1.value69,
		Page = p93,
		Workspace = t1.value22,
		Players = t1.value14,
		LocalPlayer = t1.value23,
		ScreenGui = t1.value33,
		SendNotification = t1.value31,
		UserInputService = t1.value15
	})
end)

local v611 = createScrollingFrame("11293977610", "Settings", nil, true)

t1.value75 = {
	Hammer = true,
	["Gemstone Hammer"] = true,
	["Iron Hammer"] = true,
	Mallet = true
}
t1.value76 = t1.value34 and 10 or 14

function t1.value77(p94)
	if not p94 then
		return false
	end

	local Character = p94.Character

	if Character then
		if Character:FindFirstChild("BeastPowers") then
			return true
		end

		for k in pairs(t1.value75) do
			if Character:FindFirstChild(k) then
				return true
			end
		end
	end

	local Backpack = p94:FindFirstChild("Backpack")

	if Backpack then
		for k in pairs(t1.value75) do
			if Backpack:FindFirstChild(k) then
				return true
			end
		end
	end

	local Team = p94.Team

	if not Team then
		return Team and true or false
	end

	Team = p94.Team.Name == "Beast"

	return Team and true or false
end

t1.value78 = nil
t1.value79 = nil
t1.value80 = setmetatable({}, {
	__mode = "k"
})

function t1.value81(p95)
	if p95 then
		return (p95:FindFirstChildOfClass("Tool") or p95:FindFirstChild("Hammer")) and true or false
	else
		return false
	end
end
function t1.value82(p96)
	if p96 == t1.value23 then
		return
	end

	local Highlight = Instance.new("Highlight")

	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 0
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	if not pcall(function()
		Highlight.Parent = t1.value19
	end) then
		local function v618()
			Highlight.Parent = t1.value23:WaitForChild("PlayerGui")
		end

		pcall(v618)
	end

	t1.value80[p96] = Highlight
	p96.CharacterAdded:Connect(function(character)
		Highlight.Adornee = character
	end)

	if not p96.Character then
		return
	end

	Highlight.Adornee = p96.Character
end

t1.value83 = false
t1.value84 = "Torso"
t1.value85 = {}
t1.value86 = nil

function t1.value87(p97)
	return p97 and p97:FindFirstChild("HumanoidRootPart") or (p97:FindFirstChild("Torso") or p97:FindFirstChild("UpperTorso"))
end
function t1.value88(p98)
	if p98 then
		p98 = p98:FindFirstChildOfClass("Humanoid")
	end

	if not p98 then
		return p98
	end

	p98 = p98.Health > 0

	return p98
end
function t1.value89(p99)
	t1.value83 = p99

	if p99 then
		local v619, v620, v621 = ipairs(t1.value14:GetPlayers())

		while true do
			local v622

			v621, v622 = v619(v620, v621)

			if not v621 then
				break
			end

			local v623

			if v622 == t1.value23 then
				v623 = false
			else
				v623 = not t1.value85[v622]
			end

			if v623 then
				local Line = Drawing.new("Line")

				Line.Thickness = t1.value38.TracerThickness
				Line.Transparency = 1
				Line.Visible = false
				t1.value85[v622] = Line
			end
		end

		if t1.value86 then
			return
		end

		t1.value17.RenderStepped:Connect(function()
			if not t1.value83 then
				return
			end

			local ViewportSize = workspace.CurrentCamera.ViewportSize
			local vector2 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
			local Character, v628, v629, v630, v631

			if t1.value84 == "Topo" then
				vector2 = Vector2.new(ViewportSize.X / 2, 0)
			elseif t1.value84 == "Inferior" then
				vector2 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
			else
				if t1.value84 ~= "Torso" then
					for k, v in pairs(t1.value85) do
						Character = k.Character
						v628 = t1.value87(Character)

						if v628 then
							v629 = t1.value88(Character)
						else
							v629 = v628
						end

						if v629 then
							v630, v631 = workspace.CurrentCamera:WorldToViewportPoint(v628.Position)

							if v631 then
								v.From = vector2
								v.To = Vector2.new(v630.X, v630.Y)
								v.Color = t1.value77(k) and t1.value38.Beast or t1.value38.Survivor
								v.Thickness = t1.value38.TracerThickness
								v.Visible = true
							else
								v.Visible = false
							end
						elseif v then
							v.Visible = false
						end
					end

					return
				end

				local Character2 = t1.value23.Character
				local v635 = t1.value87(Character2)
				local v636

				if v635 then
					v636 = t1.value88(Character2)
				else
					v636 = v635
				end

				if not v636 then
					for k, v in pairs(t1.value85) do
						Character = k.Character
						v628 = t1.value87(Character)

						if v628 then
							v629 = t1.value88(Character)
						else
							v629 = v628
						end

						if v629 then
							v630, v631 = workspace.CurrentCamera:WorldToViewportPoint(v628.Position)

							if v631 then
								v.From = vector2
								v.To = Vector2.new(v630.X, v630.Y)
								v.Color = t1.value77(k) and t1.value38.Beast or t1.value38.Survivor
								v.Thickness = t1.value38.TracerThickness
								v.Visible = true
							else
								v.Visible = false
							end
						elseif v then
							v.Visible = false
						end
					end

					return
				end

				local Position = v635.Position
				local v650, v651 = workspace.CurrentCamera:WorldToViewportPoint(Position)

				if not v651 then
					local v652 = Position + workspace.CurrentCamera.CFrame.LookVector * 2

					v650 = workspace.CurrentCamera:WorldToViewportPoint(v652)
				end

				vector2 = Vector2.new(v650.X, v650.Y)
			end

			for k, v in pairs(t1.value85) do
				Character = k.Character
				v628 = t1.value87(Character)

				if v628 then
					v629 = t1.value88(Character)
				else
					v629 = v628
				end

				if v629 then
					v630, v631 = workspace.CurrentCamera:WorldToViewportPoint(v628.Position)

					if v631 then
						v.From = vector2
						v.To = Vector2.new(v630.X, v630.Y)
						v.Color = t1.value77(k) and t1.value38.Beast or t1.value38.Survivor
						v.Thickness = t1.value38.TracerThickness
						v.Visible = true
					else
						v.Visible = false
					end
				elseif v then
					v.Visible = false
				end
			end
		end)

		return
	end

	for _, v in pairs(t1.value85) do
		if v then
			v.Visible = false
		end
	end
end

t1.value14.PlayerAdded:Connect(function(player)
	if player == t1.value23 then
		return
	end

	local Line = Drawing.new("Line")

	Line.Thickness = t1.value38.TracerThickness
	Line.Transparency = 1
	Line.Visible = false
	t1.value85[player] = Line
end)

local PlayerRemoving = t1.value14.PlayerRemoving

PlayerRemoving.Connect(PlayerRemoving, function(p100)
	if not t1.value85[p100] then
		return
	end

	t1.value85[p100]:Remove()
	t1.value85[p100] = nil
end)
t1.value90 = {}
t1.value91 = setmetatable({}, {
	__mode = "v"
})
t1.value92 = false
t1.value93 = false
t1.value94 = false
t1.value95 = false
t1.value96 = {}
t1.value97 = {}
t1.value98 = {
	R6 = {
		{ "Head", "Torso" },
		{ "Torso", "Left Arm" },
		{ "Torso", "Right Arm" },
		{ "Torso", "Left Leg" },
		{ "Torso", "Right Leg" }
	},
	R15 = {
		{ "UpperTorso", "Head" },
		{ "UpperTorso", "LowerTorso" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" }
	}
}

function t1.value99(p101)
	local v653 = t1.value96[p101]

	if not v653 then
		return
	end

	for _, v in ipairs(v653) do
		v.Visible = false
		v:Remove()
	end

	t1.value96[p101] = nil
end
function t1.value100(p102)
	local v654 = t1.value97[p102]

	if not v654 then
		return
	end

	for _, v in ipairs(v654) do
		v.Visible = false
		v:Remove()
	end

	t1.value97[p102] = nil
end
function t1.value101(p103, p104)
	local Head = p104:FindFirstChild("Head")

	if not Head then
		return
	end

	local NameESP = Head:FindFirstChild("NameESP")

	if not NameESP then
		NameESP = Instance.new("BillboardGui")
		NameESP.Name = "NameESP"
		NameESP.Adornee = Head
		NameESP.AlwaysOnTop = true
		NameESP.LightInfluence = 0
		NameESP.MaxDistance = 500
		NameESP.Size = UDim2.new(0, 100, 0, 20)
		NameESP.StudsOffset = Vector3.new(0, 2, 0)
		NameESP.Parent = Head

		local TextLabel7 = Instance.new("TextLabel")

		TextLabel7.Name = "Label"
		TextLabel7.Size = UDim2.new(1, 0, 1, 0)
		TextLabel7.BackgroundTransparency = 1
		TextLabel7.Font = t1.value37.Font
		TextLabel7.TextSize = t1.value76
		TextLabel7.TextStrokeTransparency = 0
		TextLabel7.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel7.Parent = NameESP
	end

	NameESP.Enabled = not t1.value38.HideNames

	local Label = NameESP.Enabled and NameESP:FindFirstChild("Label")

	if not Label then
		return
	end

	Label.Text = p103.Name
	Label.TextColor3 = t1.value77(p103) and t1.value38.Beast or t1.value38.Survivor
end
function t1.value102(p105)
	if not p105 then
		return
	end

	local RoleESP = p105:FindFirstChild("RoleESP")

	if RoleESP then
		RoleESP:Destroy()
	end

	local Head = p105:FindFirstChild("Head")
	local NameESP

	if Head then
		NameESP = Head:FindFirstChild("NameESP")
	else
		NameESP = Head
	end

	if not NameESP then
		return
	end

	Head.NameESP:Destroy()
end
function t1.value103(p106)
	if p106 == t1.value23 then
		return
	end

	local Character = p106.Character

	if not Character then
		return
	end

	if not t1.value92 then
		t1.value102(Character)

		return
	end

	local Beast = t1.value77(p106)
	local OnlyBeast = t1.value38.OnlyBeast

	if OnlyBeast then
		OnlyBeast = not Beast
	end

	if OnlyBeast then
		t1.value102(Character)

		return
	end

	local RoleESP = Character:FindFirstChild("RoleESP")

	if not RoleESP then
		RoleESP = Instance.new("Highlight")
		RoleESP.Name = "RoleESP"
		RoleESP.Adornee = Character
		RoleESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		RoleESP.Parent = Character
	end

	RoleESP.OutlineColor = Beast and t1.value38.OutlineBeast or t1.value38.OutlineSurvivor
	RoleESP.OutlineTransparency = 0
	RoleESP.FillTransparency = 0.5

	local s2 = "FillColor"

	if not Beast then
		RoleESP[s2] = Beast or t1.value38.Survivor
		t1.value101(p106, Character)

		return
	end

	Beast = t1.value38.Beast
	RoleESP[s2] = Beast or t1.value38.Survivor
	t1.value101(p106, Character)
end
function t1.value104(p107)
	if p107 == t1.value23 then
		return
	end

	local v667 = t1.value32:FindFirstChild(p107.Name .. "_CharmsESP")

	if v667 then
		v667:Destroy()
	end

	if not (t1.value93 and p107.Character) then
		return
	end

	local Character = p107.Character
	local Humanoid = t1.value87(Character)

	if Humanoid then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	end

	if not Humanoid then
		return
	end

	local Folder = Instance.new("Folder")

	Folder.Name = p107.Name .. "_CharmsESP"
	Folder.Parent = t1.value32

	local Beast = t1.value77(p107) and t1.value38.Beast or t1.value38.Survivor

	for _, child in pairs(Character:GetChildren()) do
		if child:IsA("BasePart") then
			local BoxHandleAdornment = Instance.new("BoxHandleAdornment")

			BoxHandleAdornment.Name = p107.Name
			BoxHandleAdornment.Parent = Folder
			BoxHandleAdornment.Adornee = child
			BoxHandleAdornment.AlwaysOnTop = true
			BoxHandleAdornment.ZIndex = 10
			BoxHandleAdornment.Size = child.Size
			BoxHandleAdornment.Transparency = 0.3
			BoxHandleAdornment.Color3 = Beast
		end
	end
end

local function v675(player)
	if player == t1.value23 then
		return
	end

	local function v676(character)
		task.wait(0.2)

		local Parent

		if character then
			Parent = character.Parent
		else
			Parent = character
		end

		if not Parent then
			return
		end

		t1.value103(player)

		if t1.value93 then
			t1.value104(player)
		end

		local function v678(child)
			if not (child.Name == "BeastPowers" and true or child.Name == "Hammer") then
				return
			end

			task.wait(0.1)
			t1.value103(player)
		end

		character.ChildAdded:Connect(v678)
		character.ChildRemoved:Connect(function(child)
			if not (child.Name == "BeastPowers" and true or child.Name == "Hammer") then
				return
			end

			task.wait(0.1)
			t1.value103(player)
		end)
	end

	player.CharacterAdded:Connect(v676)

	if not player.Character then
		return
	end

	v676(player.Character)
end
local function v679()
	local ipairs_ = ipairs
	local value14 = t1.value14

	for _, player in ipairs_(value14.GetPlayers(value14)) do
		if player ~= t1.value23 then
			pcall(t1.value103, player)
		end
	end
end

for _, player in ipairs(t1.value14:GetPlayers()) do
	v675(player)
end

t1.value14.PlayerAdded:Connect(v675)
t1.value17.RenderStepped:Connect(function()
	if not (t1.value95 or t1.value94) then
		return
	end

	local ipairs_ = ipairs
	local value14 = t1.value14

	for _, player in ipairs_(value14.GetPlayers(value14)) do
		if player ~= t1.value23 then
			local Character = player.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			local value95 = t1.value95

			if value95 then
				if HumanoidRootPart then
					if Humanoid then
						value95 = Humanoid.Health > 0
					else
						value95 = Humanoid
					end
				else
					value95 = HumanoidRootPart
				end
			end

			if value95 then
				local v694 = t1.value96[player]

				if not v694 then
					v694 = {}

					for i = 1, 12 do
						local Line = Drawing.new("Line")

						Line.Thickness = t1.value38.TracerThickness
						Line.Transparency = 1
						v694[i] = Line
					end

					t1.value96[player] = v694
				end

				local CFrame_ = HumanoidRootPart.CFrame
				local v698 = Vector3.new(4, 6, 4) / 2
				local t2 = {
					CFrame_ * CFrame.new(-v698.X, v698.Y, -v698.Z),
					CFrame_ * CFrame.new(v698.X, v698.Y, -v698.Z),
					CFrame_ * CFrame.new(v698.X, v698.Y, v698.Z),
					CFrame_ * CFrame.new(-v698.X, v698.Y, v698.Z),
					CFrame_ * CFrame.new(-v698.X, -v698.Y, -v698.Z),
					CFrame_ * CFrame.new(v698.X, -v698.Y, -v698.Z),
					CFrame_ * CFrame.new(v698.X, -v698.Y, v698.Z),
					CFrame_ * CFrame.new(-v698.X, -v698.Y, v698.Z)
				}
				local v700, v701, v702 = ipairs(t2)
				local t3 = {}
				local v704 = false

				while true do
					local v705

					v702, v705 = v700(v701, v702)

					if not v702 then
						break
					end

					local v706, v707 = workspace.CurrentCamera:WorldToViewportPoint(v705.Position)

					t3[v702] = Vector2.new(v706.X, v706.Y)
					v704 = v707 and true or v704
				end

				if v704 then
					local Beast = t1.value77(player) and t1.value38.Beast or t1.value38.Survivor

					for i, v in ipairs({
						{ 1, 2 },
						{ 2, 3 },
						{ 3, 4 },
						{ 4, 1 },
						{ 5, 6 },
						{ 6, 7 },
						{ 7, 8 },
						{ 8, 5 },
						{ 1, 5 },
						{ 2, 6 },
						{ 3, 7 },
						{ 4, 8 }
					}) do
						local v711 = v694[i]

						v711.From = t3[v[1]]
						v711.To = t3[v[2]]
						v711.Color = Beast
						v711.Visible = true
					end
				else
					t1.value99(player)
				end
			else
				t1.value99(player)
			end

			local value94 = t1.value94

			if value94 then
				if Humanoid then
					value94 = Humanoid.Health > 0
				else
					value94 = Humanoid
				end
			end

			if value94 then
				local v713 = Humanoid.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
				local v714 = t1.value97[player]

				if not v714 then
					v714 = {}

					for i = 1, #t1.value98[v713] do
						local Line = Drawing.new("Line")

						Line.Thickness = 1.5
						Line.Transparency = 1
						v714[i] = Line
					end

					t1.value97[player] = v714
				end

				local Beast = t1.value77(player) and t1.value38.Beast or t1.value38.Survivor

				for i, v in ipairs(t1.value98[v713]) do
					local v720 = Character:FindFirstChild(v[1])
					local v721 = Character:FindFirstChild(v[2])
					local v722 = v714[i]

					if v720 and v721 then
						local v723, v724 = workspace.CurrentCamera:WorldToViewportPoint(v720.Position)
						local v725, v726 = workspace.CurrentCamera:WorldToViewportPoint(v721.Position)

						if v724 or v726 then
							v722.From = Vector2.new(v723.X, v723.Y)
							v722.To = Vector2.new(v725.X, v725.Y)
							v722.Color = Beast
							v722.Visible = true
						else
							v722.Visible = false
						end
					elseif v722 then
						v722.Visible = false
					end
				end
			else
				t1.value100(player)
			end
		end
	end
end)
t1.value14.PlayerRemoving:Connect(function(player)
	t1.value99(player)
	t1.value100(player)

	local v727 = t1.value32:FindFirstChild(player.Name .. "_CharmsESP")

	if not v727 then
		return
	end

	v727:Destroy()
end)
t1.value69:CreateSection(v599, "ESP Features", "Left")
t1.value69:CreateToggle(v599, "Esp Players", false, function(p108)
	t1.value92 = p108
	v679()
end)
t1.value69:CreateToggle(v599, "Esp outline", false, function(p109)
	if p109 then
		local ipairs_ = ipairs
		local value14 = t1.value14

		for _, player in ipairs_(value14.GetPlayers(value14)) do
			t1.value82(player)
		end

		t1.value79 = t1.value14.PlayerAdded:Connect(function(player)
			t1.value82(player)
		end)
		t1.value78 = task.spawn(function()
			while true do
				local v732 = p109

				if v732 then
					v732 = task.wait(0.3)
				end

				if not v732 then
					return
				end

				for k, v in pairs(t1.value80) do
					v.OutlineColor = t1.value81(k.Character) and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
				end
			end
		end)

		return
	end

	if t1.value79 then
		t1.value79:Disconnect()
	end

	if not t1.value78 then
		for _, v in pairs(t1.value80) do
			if v then
				v:Destroy()
			end
		end

		table.clear(t1.value80)

		return
	end

	task.cancel(t1.value78)

	for _, v in pairs(t1.value80) do
		if v then
			v:Destroy()
		end
	end

	table.clear(t1.value80)
end)
t1.value69:CreateToggle(v599, "Beast Highlight", false, function(p110)
	if not p110 then
		for _, v in ipairs(t1.value90) do
			if v then
				v:Disconnect()
			end
		end

		table.clear(t1.value90)

		local v741, v742, v743 = pairs(t1.value91)

		while true do
			local v744

			v743, v744 = v741(v742, v743)

			if not v743 then
				break
			end

			local Parent

			if v744 then
				Parent = v744.Parent
			else
				Parent = v744
			end

			if Parent then
				v744:Destroy()
			end
		end

		table.clear(t1.value91)

		local pairs_ = pairs
		local value14 = t1.value14

		for _, player in pairs_(value14.GetPlayers(value14)) do
			local Character = player.Character

			if Character then
				Character = player.Character:FindFirstChild("Head")
			end

			if Character then
				local BeastGlow = player.Character.Head:FindFirstChild("BeastGlow")

				if BeastGlow then
					BeastGlow:Destroy()
				end
			end
		end

		return
	end

	local function v752(character)
		if not character then
			return
		end

		local Head = character:WaitForChild("Head", 5)

		if not Head then
			return
		end

		local function v754()
			if not p110 then
				return
			end

			local BeastPowers = character:FindFirstChild("BeastPowers")
			local BeastGlow = Head:FindFirstChild("BeastGlow")

			if BeastPowers then
				if BeastGlow then
					BeastGlow.Brightness = 8
					BeastGlow.Range = 25

					return
				else
					local PointLight = Instance.new("PointLight")

					PointLight.Name = "BeastGlow"
					PointLight.Color = t1.value38.BeastHighlight
					PointLight.Brightness = 8
					PointLight.Range = 25
					PointLight.Parent = Head

					local value91 = t1.value91

					table.insert(value91, PointLight)

					return
				end
			end

			if not BeastGlow then
				return
			end

			BeastGlow:Destroy()
		end

		v754()
		table.insert(t1.value90, character.ChildAdded:Connect(function(child)
			if child.Name ~= "BeastPowers" then
				return
			end

			v754()
		end))
		table.insert(t1.value90, character.ChildRemoved:Connect(function(child)
			if child.Name ~= "BeastPowers" then
				return
			end

			v754()
		end))
	end

	table.insert(t1.value90, t1.value14.PlayerAdded:Connect(function(player)
		local table_ = table
		local value90 = t1.value90
		local CharacterAdded = player.CharacterAdded
		local v762 = v752

		table_.insert(value90, CharacterAdded:Connect(v762))

		if not player.Character then
			return
		end

		v752(player.Character)
	end))

	local pairs_ = pairs
	local value14 = t1.value14

	for _, player in pairs_(value14.GetPlayers(value14)) do
		if player.Character then
			v752(player.Character)
		end

		table.insert(t1.value90, player.CharacterAdded:Connect(v752))
	end
end)
t1.value105 = nil

function t1.value106()
	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		if descendant.Name == "CompESP" then
			descendant:Destroy()
		end
	end
end

local value69 = t1.value69

value69.CreateToggle(value69, v599, "Esp Computers", false, function(p111)
	if p111 then
		local color3 = Color3.fromRGB(0, 170, 255)
		local color32 = Color3.fromRGB(0, 255, 0)
		local color33 = Color3.fromRGB(255, 0, 0)

		local function v775(p112, p113)
			local Color = p112.Color
			local v777

			if Color.R > Color.G then
				v777 = Color.R > Color.B
			else
				v777 = false
			end

			if v777 then
				p113.FillColor = color33
			else
				local v778

				if Color.G > Color.B then
					v778 = Color.G > Color.R
				else
					v778 = false
				end

				if v778 then
					p113.FillColor = color32
				else
					p113.FillColor = color3
				end
			end

			p113.OutlineColor = t1.value38.OutlineComp
		end
		local function v779(p114)
			if p114:FindFirstChild("CompESP") then
				return
			end

			task.spawn(function()
				local Screen = p114:FindFirstChild("Screen") or p114:WaitForChild("Screen", 5)
				local isBasePart

				if Screen then
					isBasePart = Screen:IsA("BasePart")
				else
					isBasePart = Screen
				end

				if not isBasePart then
					return
				end

				if p114:FindFirstChild("CompESP") then
					return
				end

				local Highlight = Instance.new("Highlight")

				Highlight.Name = "CompESP"
				Highlight.Adornee = p114
				Highlight.Parent = p114
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.OutlineColor = t1.value38.OutlineComp
				Highlight.OutlineTransparency = 0
				Highlight.FillTransparency = 0.5
				v775(Screen, Highlight)
				Screen:GetPropertyChangedSignal("Color"):Connect(function()
					if not Highlight.Parent then
						return
					end

					v775(Screen, Highlight)
				end)
			end)
		end
		local function v783(descendant)
			local isModel

			if descendant.Name == "ComputerTable" then
				isModel = descendant:IsA("Model")
			else
				isModel = false
			end

			if isModel then
				v779(descendant)

				return
			end

			local Parent = descendant.Name == "Screen" and descendant.Parent

			if Parent then
				Parent = descendant.Parent.Name == "ComputerTable"
			end

			if not Parent then
				return
			end

			v779(descendant.Parent)
		end

		local pairs_ = pairs
		local workspace_ = workspace

		for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
			v783(descendant)
		end

		t1.value105 = workspace.DescendantAdded:Connect(v783)

		return
	end

	if not t1.value105 then
		t1.value106()

		return
	end

	t1.value105:Disconnect()
	t1.value106()
end)
t1.value107 = nil
t1.value108 = nil
t1.value109 = {}

local value692 = t1.value69

value692.CreateToggle(value692, v599, "Esp Doors", false, function(p115)
	if p115 then
		local color3 = Color3.fromRGB(0, 255, 0)
		local color32 = Color3.fromRGB(255, 0, 0)
		local v793 = nil

		local function v794(p116)
			if p116:FindFirstChild("DoorESP_FTF") then
				return p116.FindFirstChild(p116, "DoorESP_FTF")
			else
				local Highlight = Instance.new("Highlight")

				Highlight.Name = "DoorESP_FTF"
				Highlight.Adornee = p116
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.FillTransparency = 0.5
				Highlight.OutlineTransparency = 0.2
				Highlight.FillColor = v793
				Highlight.OutlineColor = t1.value38.OutlineDoor
				Highlight.Parent = p116

				return Highlight
			end
		end

		v793 = color32

		local function v796(p117, p118)
			if not (p117:IsA("BasePart") and (p117.Name:match("Door") or (p117.Name == "Part" or p117.Name == "Left" or p117.Name == "Right"))) then
				return
			end

			local v797 = p117.Size.Y > 3 and not p117.Name:match("Frame")

			if v797 then
				v797 = not p117.Name:match("Wall")
			end

			if not (v797 and not t1.value109[p117]) then
				return
			end

			t1.value109[p117] = {
				esp = v794(p118),
				model = p118,
				initialCFrame = p117.CFrame
			}
		end

		local ipairs_ = ipairs
		local value22 = t1.value22
		local v800 = v793

		local function v801(descendant)
			local isModel = descendant:IsA("Model")

			if isModel then
				isModel = (descendant.Name == "SingleDoor" or descendant.Name == "DoubleDoor") and true or descendant.Name == "SlidingDoor"
			end

			if not isModel then
				return
			end

			for _, descendant2 in ipairs(descendant.GetDescendants(descendant)) do
				v796(descendant2, descendant)
			end

			descendant.DescendantAdded:Connect(function(descendant2)
				v796(descendant2, descendant)
			end)
		end

		for _, descendant in ipairs_(value22.GetDescendants(value22)) do
			v801(descendant)
		end

		t1.value107 = t1.value22.DescendantAdded:Connect(v801)
		t1.value108 = task.spawn(function()
			while task.wait(0.1) and p115 do
				for k, v in pairs(t1.value109) do
					local Parent

					if k then
						Parent = k.Parent and (v.model and v.model.Parent)

						if Parent then
							Parent = v.esp
						end
					else
						Parent = k
					end

					if Parent then
						local CFrame_ = k.CFrame
						local Magnitude = (CFrame_.Position - v.initialCFrame.Position).Magnitude
						local v812 = CFrame_.LookVector:Dot(v.initialCFrame.LookVector)

						if k.CanCollide == true and (v812 < 0.9 or Magnitude > 0.5) then
							v.initialCFrame = CFrame_
						end

						if (not k.CanCollide or ((v812 < 0.85 or Magnitude > 0.5) and true or k.Transparency > 0.8)) and true or false then
							v.esp.FillColor = color3
						else
							v.esp.FillColor = v800
						end

						v.esp.OutlineColor = t1.value38.OutlineDoor
					else
						local esp = v.esp

						if esp then
							esp = not v.model.Parent
						end

						if esp then
							v.esp:Destroy()
						end

						t1.value109[k] = nil
					end
				end
			end
		end)

		return
	end

	if t1.value107 then
		t1.value107:Disconnect()
	end

	if not t1.value108 then
		for _, v in pairs(t1.value109) do
			if v.esp then
				v.esp:Destroy()
			end
		end

		table.clear(t1.value109)

		return
	end

	task.cancel(t1.value108)

	for _, v in pairs(t1.value109) do
		if v.esp then
			v.esp:Destroy()
		end
	end

	table.clear(t1.value109)
end)
t1.value110 = nil

local function v818()
	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		if descendant.Name == "PodESP" then
			descendant:Destroy()
		end
	end
end

t1.value69:CreateToggle(v599, "Esp Freezepods", false, function(p119)
	if p119 then
		local function v823(descendant)
			local isModel

			if descendant.Name == "FreezePod" then
				isModel = descendant:IsA("Model")
			else
				isModel = false
			end

			if not isModel then
				return
			end

			if descendant:FindFirstChild("PodESP") then
				return
			end

			local Highlight = Instance.new("Highlight")

			Highlight.Name = "PodESP"
			Highlight.Adornee = descendant
			Highlight.Parent = descendant
			Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			Highlight.OutlineColor = t1.value38.OutlinePod
			Highlight.OutlineTransparency = 0
			Highlight.FillTransparency = 0.5
			Highlight.FillColor = t1.value38.Pod
		end

		local pairs_ = pairs
		local workspace_ = workspace

		for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
			v823(descendant)
		end

		t1.value110 = workspace.DescendantAdded:Connect(v823)

		return
	end

	if not t1.value110 then
		v818()

		return
	end

	t1.value110:Disconnect()
	v818()
end)
t1.value69:CreateSection(v599, "Outline Customization", "Left")
t1.value69:CreateColorPicker(v599, "Survivor Outline", Color3.fromRGB(0, 0, 0), function(p120)
	t1.value38.OutlineSurvivor = p120
	v679()
end)
t1.value69:CreateColorPicker(v599, "Beast Outline", Color3.fromRGB(0, 0, 0), function(p121)
	t1.value38.OutlineBeast = p121
	v679()
end)

local value693 = t1.value69
local Color3_ = Color3

value693.CreateColorPicker(value693, v599, "Computer Outline", Color3_.fromRGB(0, 0, 0), function(p122)
	t1.value38.OutlineComp = p122

	local pairs_ = pairs
	local workspace_ = workspace

	for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
		local isHighlight

		if descendant.Name == "CompESP" then
			isHighlight = descendant:IsA("Highlight")
		else
			isHighlight = false
		end

		if isHighlight then
			descendant.OutlineColor = p122
		end
	end
end)

local value694 = t1.value69
local Color3_2 = Color3

value694.CreateColorPicker(value694, v599, "Freezepod Outline", Color3_2.fromRGB(0, 0, 0), function(p123)
	t1.value38.OutlinePod = p123

	local pairs_ = pairs
	local workspace_ = workspace

	for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
		local isHighlight

		if descendant.Name == "PodESP" then
			isHighlight = descendant:IsA("Highlight")
		else
			isHighlight = false
		end

		if isHighlight then
			descendant.OutlineColor = p123
		end
	end
end)
t1.value69:CreateColorPicker(v599, "Door Outline", Color3.fromRGB(0, 0, 0), function(p124)
	t1.value38.OutlineDoor = p124
end)
t1.value69:CreateSection(v599, "Others ESPs", "Right")
t1.value69:CreateToggle(v599, "Charms", false, function(p125)
	t1.value93 = p125

	if p125 then
		for _, player in ipairs(t1.value14:GetPlayers()) do
			t1.value104(player)
		end
	else
		for _, player in ipairs(t1.value14:GetPlayers()) do
			local v848 = t1.value32:FindFirstChild(player.Name .. "_CharmsESP")

			if v848 then
				v848:Destroy()
			end
		end
	end
end)
t1.value69:CreateToggle(v599, "Skeleton", false, function(p126)
	t1.value94 = p126

	if p126 then
		return
	end

	for _, player in ipairs(t1.value14:GetPlayers()) do
		t1.value100(player)
	end
end)
t1.value69:CreateToggle(v599, "Box 3D", false, function(p127)
	t1.value95 = p127

	if p127 then
		return
	end

	for _, player in ipairs(t1.value14:GetPlayers()) do
		t1.value99(player)
	end
end)
t1.value69:CreateToggle(v599, "Esp Tracer Line", false, function(p128)
	t1.value89(p128)
end)
t1.value69:CreateDropdown(v599, "Tracer Origin", { "Inferior", "Topo", "Torso" }, "Torso", function(p129)
	t1.value84 = p129
end)
t1.value69:CreateSlider(v599, "Tracer Thickness", 1, 5, 1, function(p130)
	t1.value38.TracerThickness = p130
end)
t1.value69:CreateSection(v599, "Color Customization", "Right")

local value695 = t1.value69
local Color3_3 = Color3

value695.CreateColorPicker(value695, v599, "Beast highlight Color", Color3_3.fromRGB(0, 255, 255), function(p131)
	t1.value38.BeastHighlight = p131

	local pairs_ = pairs
	local value14 = t1.value14

	for _, player in pairs_(value14.GetPlayers(value14)) do
		local Character = player.Character

		if Character then
			Character = player.Character:FindFirstChild("Head")
		end

		if Character then
			local BeastGlow = player.Character.Head:FindFirstChild("BeastGlow")

			if BeastGlow then
				BeastGlow.Color = p131
			end
		end
	end
end)
t1.value69:CreateColorPicker(v599, "Survivor Fill Color", Color3.fromRGB(0, 255, 0), function(p132)
	t1.value38.Survivor = p132
	v679()
end)
t1.value69:CreateColorPicker(v599, "Beast Fill Color", Color3.fromRGB(255, 0, 0), function(p133)
	t1.value38.Beast = p133
	v679()
end)

local value696 = t1.value69
local Color3_4 = Color3

value696.CreateColorPicker(value696, v599, "Freezepod Fill Color", Color3_4.fromRGB(0, 255, 255), function(p134)
	t1.value38.Pod = p134

	local pairs_ = pairs
	local workspace_ = workspace

	for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
		local isHighlight

		if descendant.Name == "PodESP" then
			isHighlight = descendant:IsA("Highlight")
		else
			isHighlight = false
		end

		if isHighlight then
			descendant.FillColor = p134
		end
	end
end)
t1.value69:CreateSection(v611, "Menu Configuration")

local Frame8 = Instance.new("Frame")

Frame8.Name = "MenuConfigCard"
Frame8.Size = UDim2.new(1, -2, 0, 0)
Frame8.Position = UDim2.new(0, 1, 0, 0)
Frame8.AutomaticSize = Enum.AutomaticSize.Y
Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
Frame8.BackgroundTransparency = 0.45
Frame8.Parent = v611
Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 6)

local UIStroke5 = Instance.new("UIStroke", Frame8)

UIStroke5.Color = Color3.fromRGB(40, 40, 40)
UIStroke5.Thickness = 1

local UIListLayout3 = Instance.new("UIListLayout", Frame8)

UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.Padding = UDim.new(0, 5)

local UIPadding2 = Instance.new("UIPadding", Frame8)

UIPadding2.PaddingTop = UDim.new(0, 8)
UIPadding2.PaddingBottom = UDim.new(0, 8)
UIPadding2.PaddingLeft = UDim.new(0, 8)
UIPadding2.PaddingRight = UDim.new(0, 8)

local Frame9 = Instance.new("Frame")

Frame9.Size = UDim2.new(1, 0, 0, 40)
Frame9.BackgroundTransparency = 1
Frame9.BorderSizePixel = 0
Frame9.Parent = Frame8

local TextLabel7 = Instance.new("TextLabel")

TextLabel7.Text = "Menu Keybind:"
TextLabel7.Font = t1.value37.Font
TextLabel7.TextSize = 12
TextLabel7.TextColor3 = t1.value37.Text
TextLabel7.Size = UDim2.new(0, 100, 1, 0)
TextLabel7.Position = UDim2.new(0, 10, 0, 0)
TextLabel7.BackgroundTransparency = 1
TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
TextLabel7.Parent = Frame9
t1.value111 = Instance.new("TextButton")
t1.value111.Parent = Frame9
t1.value111.Text = t1.value48.Name
t1.value111.Size = UDim2.new(0, 60, 0, 22)
t1.value111.Position = UDim2.new(1, -70, 0.5, -11)
t1.value111.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value111.BackgroundTransparency = 0.45
t1.value111.TextColor3 = t1.value37.Accent
Instance.new("UICorner", t1.value111).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", t1.value111).Color = Color3.fromRGB(40, 40, 40)
t1.value111.MouseButton1Click:Connect(function()
	t1.value111.Text = "..."

	local connection = nil

	connection = t1.value15.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		t1.value48 = input.KeyCode
		t1.value27.ToggleKey = t1.value48.Name
		t1.value111.Text = t1.value48.Name

		if not connection then
			return
		end

		connection:Disconnect()
	end)
end)
t1.value71[v611] = Frame8
t1.value72[v611] = true
t1.value69:CreateDropdown(v611, "UI Font", {
	"Gotham",
	"GothamBold",
	"GothamBlack",
	"Arial",
	"SourceSans",
	"Roboto",
	"Ubuntu"
}, "GothamBold", function(p135)
	t1.value47(p135)
end)

local t4 = {}

for i = 1, 20 do
	local v877 = "Style " .. i

	table.insert(t4, v877)
end

t1.value112 = {
	["Style 1"] = "105845499282486",
	["Style 2"] = "114069451307148",
	["Style 3"] = "108123278079389",
	["Style 4"] = "90248504018396",
	["Style 5"] = "114882550697198",
	["Style 6"] = "118901066962859",
	["Style 7"] = "120737804163326",
	["Style 8"] = "135816072013623",
	["Style 9"] = "101888826843453",
	["Style 10"] = "115811448103037",
	["Style 11"] = "76056831313603",
	["Style 12"] = "130105578161516",
	["Style 13"] = "122718631186610",
	["Style 14"] = "96100996991088",
	["Style 15"] = "101623042672375",
	["Style 16"] = "79344922826816",
	["Style 17"] = "95846716377862",
	["Style 18"] = "122999488593861",
	["Style 19"] = "78655516870667",
	["Style 20"] = "77247981769460"
}

local t5 = {}

for k, v in pairs(t1.value112) do
	t5[v] = k
end

local v881 = t5[v56] or "Style 16"

t1.value69:CreateDropdown(v611, "UI Background", t4, v881, function(p136)
	local v882 = t1.value112[p136]
	local v883

	if v882 then
		v883 = v882 ~= ""
	else
		v883 = v882
	end

	if not v883 then
		return
	end

	t1.value53.Image = "rbxassetid://" .. v882
	t1.value28(v882)
end)
t1.value69:CreateInput(v611, "Custom Background ID", "", function(p137)
	local v884

	if p137 then
		v884 = p137 ~= ""
	else
		v884 = p137
	end

	if not v884 then
		return
	end

	local v885 = string.match(p137, "%d+")

	if v885 then
		t1.value53.Image = "rbxassetid://" .. v885
		t1.value28(v885)

		return
	end

	t1.value53.Image = p137
end)
t1.value71[v611] = nil
t1.value72[v611] = nil
t1.value69:CreateSection(v611, "External Scripts")
t1.value69:CreateButton(v611, "Infinite Yield", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
t1.value69:CreateButton(v611, "YouTube Music", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua", true))()
end)
t1.value69:CreateSection(v611, "Configuration Management")

local TextLabel8 = Instance.new("TextLabel")

TextLabel8.Text = "Config Name:"
TextLabel8.Font = Enum.Font.GothamBold
TextLabel8.TextSize = 12
TextLabel8.TextColor3 = t1.value37.Text
TextLabel8.Size = UDim2.new(1, -10, 0, 20)
TextLabel8.BackgroundTransparency = 1
TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
TextLabel8.Parent = v611

local Frame10 = Instance.new("Frame")

Frame10.Size = UDim2.new(1, -2, 0, 30)
Frame10.Position = UDim2.new(0, 1, 0, 0)
Frame10.BackgroundColor3 = Color3.new(0, 0, 0)
Frame10.BackgroundTransparency = 0.45
Frame10.BorderSizePixel = 0
Frame10.Parent = v611
Instance.new("UICorner", Frame10).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Frame10).Color = Color3.fromRGB(40, 40, 40)
t1.value113 = Instance.new("TextBox")
t1.value113.Size = UDim2.new(1, -20, 1, 0)
t1.value113.Position = UDim2.new(0, 10, 0, 0)
t1.value113.BackgroundTransparency = 1
t1.value113.Text = v102
t1.value113.PlaceholderText = "Type config name..."
t1.value113.TextColor3 = t1.value37.Text
t1.value113.Font = Enum.Font.Gotham
t1.value113.TextSize = 12
t1.value113.TextXAlignment = Enum.TextXAlignment.Left
t1.value113.ClearTextOnFocus = false
t1.value113.Parent = Frame10

local Frame11 = Instance.new("Frame")

Frame11.Size = UDim2.new(1, 0, 0, 60)
Frame11.BackgroundTransparency = 1
Frame11.Parent = v611

local TextButton3 = Instance.new("TextButton")

TextButton3.Size = UDim2.new(0.32, 0, 0, 30)
TextButton3.Position = UDim2.new(0, 0, 0, 0)
TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton3.BackgroundTransparency = 0.45
TextButton3.Text = "Save Config"
TextButton3.Font = Enum.Font.GothamBold
TextButton3.TextSize = 11
TextButton3.TextColor3 = t1.value37.Text
TextButton3.Parent = Frame11
Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton3).Color = Color3.fromRGB(40, 40, 40)

local TextButton4 = Instance.new("TextButton")

TextButton4.Size = UDim2.new(0.32, 0, 0, 30)
TextButton4.Position = UDim2.new(0.34, 0, 0, 0)
TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton4.BackgroundTransparency = 0.45
TextButton4.Text = "Load Config"
TextButton4.Font = Enum.Font.GothamBold
TextButton4.TextSize = 11
TextButton4.TextColor3 = t1.value37.Text
TextButton4.Parent = Frame11
Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton4).Color = Color3.fromRGB(40, 40, 40)

local TextButton5 = Instance.new("TextButton")

TextButton5.Size = UDim2.new(0.32, 0, 0, 30)
TextButton5.Position = UDim2.new(0.68, 0, 0, 0)
TextButton5.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton5.BackgroundTransparency = 0.45
TextButton5.Text = "Set as Default"
TextButton5.Font = Enum.Font.GothamBold
TextButton5.TextSize = 11
TextButton5.TextColor3 = t1.value37.Text
TextButton5.Parent = Frame11
Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton5).Color = Color3.fromRGB(40, 40, 40)

local TextButton6 = Instance.new("TextButton")

TextButton6.Size = UDim2.new(0.48, 0, 0, 25)
TextButton6.Position = UDim2.new(0, 0, 0, 35)
TextButton6.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton6.BackgroundTransparency = 0.45
TextButton6.Text = "Reset to Default"
TextButton6.Font = Enum.Font.GothamBold
TextButton6.TextSize = 11
TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton6.Parent = Frame11
Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton6).Color = Color3.fromRGB(40, 40, 40)

local TextButton7 = Instance.new("TextButton")

TextButton7.Size = UDim2.new(0.48, 0, 0, 25)
TextButton7.Position = UDim2.new(0.52, 0, 0, 35)
TextButton7.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton7.BackgroundTransparency = 0.45
TextButton7.Text = "Delet Config"
TextButton7.Font = Enum.Font.GothamBold
TextButton7.TextSize = 11
TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton7.Parent = Frame11
Instance.new("UICorner", TextButton7).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton7).Color = Color3.fromRGB(40, 40, 40)

local TextLabel9 = Instance.new("TextLabel")

TextLabel9.Text = "Available Configs:"
TextLabel9.Font = Enum.Font.GothamBold
TextLabel9.TextSize = 12
TextLabel9.TextColor3 = t1.value37.Text
TextLabel9.Size = UDim2.new(1, -10, 0, 30)
TextLabel9.BackgroundTransparency = 1
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = v611
t1.value114 = Instance.new("ScrollingFrame")
t1.value114.Size = UDim2.new(1, -2, 0, 100)
t1.value114.Position = UDim2.new(0, 1, 0, 0)
t1.value114.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value114.BackgroundTransparency = 0.45
t1.value114.BorderSizePixel = 0
t1.value114.ScrollBarThickness = 2
t1.value114.ScrollBarImageColor3 = t1.value37.Accent
t1.value114.Parent = v611
Instance.new("UICorner", t1.value114).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", t1.value114).Color = Color3.fromRGB(40, 40, 40)

local UIListLayout4 = Instance.new("UIListLayout")

UIListLayout4.Padding = UDim.new(0, 5)
UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout4.Parent = t1.value114

local UIPadding3 = Instance.new("UIPadding")

UIPadding3.PaddingTop = UDim.new(0, 5)
UIPadding3.PaddingLeft = UDim.new(0, 10)
UIPadding3.PaddingBottom = UDim.new(0, 5)
UIPadding3.Parent = t1.value114

function t1.value115()
	local v897, v898, v899 = ipairs(t1.value114:GetChildren())

	while true do
		local v900

		v899, v900 = v897(v898, v899)

		if not v899 then
			break
		end

		if v900:IsA("TextButton") then
			v900:Destroy()
		end
	end

	local v901 = t1.value46()

	local function v902()
		local listfiles_ = listfiles

		if listfiles_ then
			listfiles_ = isfolder(t1.value24)
		end

		if not listfiles_ then
			return
		end

		local v904 = listfiles(t1.value24)

		for _, v in ipairs(v904) do
			if v:match("%.json$") then
				local match = v:match("([^/\\]+)%.json$")

				if match then
					local TextButton8 = Instance.new("TextButton")

					TextButton8.Size = UDim2.new(1, -10, 0, 20)
					TextButton8.BackgroundTransparency = 1
					TextButton8.Font = Enum.Font.GothamBold
					TextButton8.TextSize = 12
					TextButton8.TextColor3 = Color3.fromRGB(200, 200, 200)
					TextButton8.TextXAlignment = Enum.TextXAlignment.Left

					if match == v901 then
						TextButton8.Text = match .. " (default config)"
					else
						TextButton8.Text = match
					end

					TextButton8.Parent = t1.value114
					TextButton8.MouseButton1Click:Connect(function()
						t1.value113.Text = match
					end)
					TextButton8.MouseEnter:Connect(function()
						TextButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
					end)
					TextButton8.MouseLeave:Connect(function()
						TextButton8.TextColor3 = Color3.fromRGB(200, 200, 200)
					end)
				end
			end
		end
	end

	pcall(v902)

	local n10 = 0

	for _, child in ipairs(t1.value114:GetChildren()) do
		if child:IsA("TextButton") then
			n10 = n10 + 1
		end
	end

	t1.value114.CanvasSize = UDim2.new(0, 0, 0, n10 * 25)
end

t1.value115()
TextButton3.MouseButton1Click:Connect(function()
	local Text = t1.value113.Text
	local savedConfig = Text == "" and "config_1" or Text
	local v914 = t1.value24 .. "/" .. savedConfig .. ".json"
	local u915 = false

	pcall(function()
		local isfile_ = isfile

		if isfile_ then
			isfile_ = isfile(v914)
		end

		if not isfile_ then
			return
		end

		u915 = true
	end)

	if u915 then
		t1.value31("A configuration with this name already exists!", 4)

		return
	end

	t1.value49(savedConfig)
	t1.value115()
	t1.value31("Config \'" .. savedConfig .. "\' Saved!", 3)

	if not _G.NexVoidLog then
		return
	end

	task.spawn(function()
		_G.NexVoidLog("Button", "Saved Config: " .. savedConfig)
	end)
end)
TextButton4.MouseButton1Click:Connect(function()
	local Text = t1.value113.Text
	local loadedConfig = Text == "" and "config_1" or Text

	t1.value74(loadedConfig)
	t1.value115()
	t1.value31("Config \'" .. loadedConfig .. "\' Loaded!", 3)

	if not _G.NexVoidLog then
		return
	end

	task.spawn(function()
		_G.NexVoidLog("Button", "Loaded Config: " .. loadedConfig)
	end)
end)
TextButton5.MouseButton1Click:Connect(function()
	local Text = t1.value113.Text
	local v920 = Text == "" and "config_1" or Text

	t1.value50(v920)
	t1.value115()
	t1.value31("Default config set to \'" .. v920 .. "\'", 3)
end)
TextButton7.MouseButton1Click:Connect(function()
	local Text = t1.value113.Text
	local v922 = Text == "" and "config_1" or Text
	local v923 = t1.value24 .. "/" .. v922 .. ".json"
	local v924 = nil

	local function v925()
		local isfile_ = isfile and isfile(v924)

		if not isfile_ then
			if isfile_ then
				delfile(v924)
				t1.value31("Config \'" .. v922 .. "\' Deleted!", 3)
			else
				t1.value31("Config file not found or not supported!", 3)
			end

			return
		end

		isfile_ = delfile

		if isfile_ then
			delfile(v924)
			t1.value31("Config \'" .. v922 .. "\' Deleted!", 3)
		else
			t1.value31("Config file not found or not supported!", 3)
		end
	end

	v924 = v923
	pcall(v925)
	t1.value115()
end)
TextButton6.MouseButton1Click:Connect(function()
	t1.value51()
	t1.value115()
	t1.value113.Text = "config_1"

	for _, v in pairs(t1.value69.Registry) do
		if v.Default ~= nil then
			pcall(v.Set, v.Default)
		end
	end

	t1.value31("Configs Reset! Please re-execute script for clean state.", 4)

	if not _G.NexVoidLog then
		return
	end

	task.spawn(function()
		_G.NexVoidLog("Button", "Reset All Configs")
	end)
end)

local function v929(p138, p139)
	local Frame12 = Instance.new("Frame")

	Frame12.Size = UDim2.new(1, -15, 0, #p139 * 25 + 40)
	Frame12.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame12.BackgroundTransparency = 0.45
	Frame12.BorderSizePixel = 0
	Instance.new("UICorner", Frame12).CornerRadius = UDim.new(0, 6)

	local UIStroke6 = Instance.new("UIStroke", Frame12)

	UIStroke6.Color = Color3.fromRGB(40, 40, 40)
	UIStroke6.Thickness = 1

	local TextLabel10 = Instance.new("TextLabel", Frame12)

	TextLabel10.Size = UDim2.new(1, -30, 0, 30)
	TextLabel10.Position = UDim2.new(0, 20, 0, 0)
	TextLabel10.BackgroundTransparency = 1
	TextLabel10.Text = p138
	TextLabel10.Font = Enum.Font.GothamBlack
	TextLabel10.TextSize = 12
	TextLabel10.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel10.TextXAlignment = Enum.TextXAlignment.Left

	local Frame13 = Instance.new("Frame", Frame12)

	Frame13.Size = UDim2.new(0, 3, 0, 14)
	Frame13.Position = UDim2.new(0, 10, 0, 8)
	Frame13.BackgroundColor3 = t1.value37.Accent
	Frame13.BorderSizePixel = 0
	Instance.new("UICorner", Frame13).CornerRadius = UDim.new(1, 0)

	local Frame14 = Instance.new("Frame", Frame12)

	Frame14.Size = UDim2.new(1, -20, 0, 1)
	Frame14.Position = UDim2.new(0, 10, 0, 30)
	Frame14.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Frame14.BorderSizePixel = 0

	local t6 = {}

	for i, v in ipairs(p139) do
		local TextLabel11 = Instance.new("TextLabel")

		TextLabel11.Size = UDim2.new(1, -20, 0, 20)
		TextLabel11.Position = UDim2.new(0, 15, 0, 35 + (i - 1) * 25)
		TextLabel11.BackgroundTransparency = 1
		TextLabel11.RichText = true
		TextLabel11.Text = v.Default
		TextLabel11.Font = Enum.Font.Gotham
		TextLabel11.TextSize = 12
		TextLabel11.TextColor3 = t1.value37.Text
		TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel11.Parent = Frame12

		if v.Id then
			t6[v.Id] = TextLabel11
		end
	end

	return Frame12, t6
end

local credits = v929("CREDITS", {
	{
		Default = "<b>NexVoid Creator Discord:</b> <font color=\'rgb(150,150,150)\'> @davidnaoxita.</font>"
	},
	{
		Default = "<b>NexVoid Testers:</b> <font color=\'rgb(150,150,150)\'>kayquenaoxita, Valtzinx e V1kxz</font>"
	},
	{
		Default = "<b>NexVoid Contributor:</b> <font color=\'rgb(150,150,150)\'>kayquenaoxita</font>"
	}
})

credits.Parent = t1.value66

local playerInfo, v942 = v929("PLAYER INFO", {
	{
		Id = "FPS",
		Default = "<b>FPS:</b> <font color=\'rgb(150,150,150)\'>...</font>"
	},
	{
		Id = "Ping",
		Default = "<b>Ping:</b> <font color=\'rgb(150,150,150)\'>... ms</font>"
	},
	{
		Id = "Exec",
		Default = "<b>Executor:</b> <font color=\'rgb(150,150,150)\'>" .. (identifyexecutor and identifyexecutor() or "Unknown") .. "</font>"
	}
})

t1.value116 = v942
playerInfo.Parent = t1.value66

local MaxPlayers = t1.value14.MaxPlayers
local serverInfo, v945 = v929("SERVER INFO", {
	{
		Id = "Region",
		Default = "<b>Region:</b> <font color=\'rgb(150,150,150)\'>Fetching...</font>"
	},
	{
		Id = "Players",
		Default = "<b>Players:</b> <font color=\'rgb(150,150,150)\'>...</font>"
	},
	{
		Id = "Max",
		Default = "<b>Max Players:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(MaxPlayers) .. "</font>"
	}
})

t1.value117 = v945
serverInfo.Parent = t1.value66

local TextLabel10 = Instance.new("TextLabel")

TextLabel10.Size = UDim2.new(1, -15, 0, 20)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Text = "Thank you for using Nexvoid."
TextLabel10.Font = Enum.Font.Gotham
TextLabel10.TextSize = 11
TextLabel10.TextColor3 = Color3.fromRGB(150, 150, 150)
TextLabel10.TextXAlignment = Enum.TextXAlignment.Center
TextLabel10.Parent = t1.value66

local TextLabel11 = Instance.new("TextLabel")

TextLabel11.Size = UDim2.new(1, -15, 0, 20)
TextLabel11.BackgroundTransparency = 1
TextLabel11.Text = "NexVoid is a free script, don\'t pay for it."
TextLabel11.Font = Enum.Font.Gotham
TextLabel11.TextSize = 11
TextLabel11.TextColor3 = Color3.fromRGB(150, 150, 150)
TextLabel11.TextXAlignment = Enum.TextXAlignment.Center
TextLabel11.Parent = t1.value66
t1.value118 = 0
t1.value119 = tick()
task.spawn(function()
	local function v948()
		return t1.value18:JSONDecode(unpack_({ game:HttpGet("http://ip-api.com/json/") }))
	end

	local ok2, result = pcall(v948)
	local s3 = "Unknown"

	if ok2 then
		if result then
			ok2 = result.countryCode
		else
			ok2 = result
		end
	end

	if ok2 then
		s3 = result.countryCode
	end

	if not t1.value117.Region then
		return
	end

	t1.value117.Region.Text = "<b>Region:</b> <font color=\'rgb(150,150,150)\'>" .. s3 .. "</font>"
end)
t1.value17.RenderStepped:Connect(function()
	t1.value118 = t1.value118 + 1

	if not (tick() - t1.value119 >= 1) then
		return
	end

	local value118 = t1.value118

	if t1.value116.FPS then
		t1.value116.FPS.Text = "<b>FPS:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(value118) .. "</font>"
	end

	local n11 = 0

	pcall(function()
		local value = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()

		n11 = math.floor(value)
	end)

	if t1.value116.Ping then
		local v955 = n11

		t1.value116.Ping.Text = "<b>Ping:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(v955) .. " ms</font>"
	end

	if not t1.value117.Players then
		return
	end

	local Players2 = t1.value117.Players
	local v957 = #t1.value14:GetPlayers()

	Players2.Text = "<b>Players:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(v957) .. "</font>"
end)

if t1.value70[1] then
	t1.value70[1].Page.Visible = true
	t1.value70[1].Indicator.BackgroundTransparency = 0
	t1.value70[1].Label.TextTransparency = 0
	t1.value70[1].Icon.ImageTransparency = 0
end

task.spawn(function()
	task.wait(0.5)

	local ipairs_ = ipairs
	local value66 = t1.value66
	local n12 = 0

	for _, child in ipairs_(value66.GetChildren(value66)) do
		if child:IsA("Frame") or child:IsA("TextLabel") then
			n12 = n12 + child.AbsoluteSize.Y + 10
		end
	end

	t1.value66.CanvasSize = UDim2.new(0, 0, 0, n12)
end)
t1.value33.Enabled = true
t1.value52.Visible = true
t1.value55.Visible = false
