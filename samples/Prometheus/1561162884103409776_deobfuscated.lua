-- This file was generated at discord.gg/syncrypt

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
        isfile_ = readfile(t1.value6)
        isfile_ = string.match(isfile_, "%d+")

        if isfile_ then
            t1.value7 = tonumber(isfile_) + 1
        end
    end

    if not writefile then
        return
    end

    isfile_ = writefile

    local value6 = t1.value6
    local value7 = t1.value7

    isfile_(value6, "SysCore_" .. tostring(value7))
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
UserInputService = game.Name
t1.value12 = nil
t1.value12 = UserInputService
pcall(function()
    local productInfo = t1.value3:GetProductInfo(game.PlaceId)

    if not productInfo then
        return
    end

    t1.value12 = productInfo.Name
end)
t1.value13 = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. t1.value4.UserId .. "&width=420&height=420&format=png"
UserInputService = function(_, _)
    local syn_ = syn

    if syn_ then
        syn_ = syn.request
    end

    if syn_ then
        if not syn_ then
            return
        end

        return
    end

    syn_ = http

    if syn_ then
        syn_ = http.request
    end

    syn_ = syn_ or (http_request or (fluxus and fluxus.request or request))

    if not syn_ then
        return
    end
end
local function value32()
    local n1 = 0

    local function v12()
        local v13 = t1.value4:GetNetworkPing() * 1000

        n1 = math.floor(v13)
    end

    pcall(v12)
    v12 = workspace:GetRealPhysicsFPS()
    v12 = math.floor(v12)

    local totalMemoryUsageMb = t1.value2:GetTotalMemoryUsageMb()

    totalMemoryUsageMb = math.floor(totalMemoryUsageMb)

    local UserId = t1.value4.UserId

    UserId = tostring(UserId)

    local Name = t1.value4.Name
    local AccountAge = t1.value4.AccountAge

    AccountAge = tostring(AccountAge)

    local value9 = t1.value9
    local v19 = n1

    v19 = tostring(v19)
    v12 = tostring(v12)
    totalMemoryUsageMb = tostring(totalMemoryUsageMb)

    local value8 = t1.value8
    local value7 = t1.value7

    value7 = tostring(value7)

    local value12 = t1.value12
    local PlaceId = game.PlaceId

    return {
		["UserId"] = UserId,
		["Name"] = Name,
		["Age"] = AccountAge,
		["NewUser"] = value9,
		["Ping"] = v19,
		["FPS"] = v12,
		["Ram"] = totalMemoryUsageMb,
		["Device"] = value8,
		["Execs"] = value7,
		["Game"] = value12,
		["PlaceId"] = tostring(PlaceId),
		["Exec"] = t1.value11,
		["HWID"] = t1.value10,
		["AvatarUrl"] = t1.value13
	}
end
task.spawn(function()
    local syn_ = syn

    if syn_ then
        syn_ = syn.request
    end

    if not syn_ then
        syn_ = http

        if syn_ then
            syn_ = http.request
        end

        syn_ = syn_ or (http_request or fluxus and fluxus.request or request)
    end

    if not syn_ then
        while task.wait(15) do
            UserInputService("ping", (value32()))
        end

        return
    end

    syn_ = function()
        local data = syn_({
			["Url"] = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. t1.value4.UserId .. "&size=420x420&format=Png&isCircular=false",
			["Method"] = "GET"
		})

        data = t1.value1:JSONDecode(data.Body)

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

        data = data.data[1].imageUrl
    end
    pcall(syn_)

    while task.wait(15) do
        UserInputService("ping", (value32()))
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if player ~= t1.value4 then
        return
    end

    local v27 = UserInputService
    local UserId = t1.value4.UserId

    v27("disconnect", {
		["UserId"] = tostring(UserId)
	})
end)
function _G.NexVoidLog(p1, p2, p3)
    local action = tostring(p2)

    if p1 == "Toggle" then
        action = string.format("%s %s %s", p3 and "+" or "-", p3 and "Ativou" or "Desativou", action)
    elseif p1 == "Button" then
        action = string.format("+ Clicou %s", action)
    elseif (p1 == "Slider" or p1 == "Input") and true or p1 == "Dropdown" then
        action = string.format("+ Alterou %s \226\158\148 %s", action, (tostring(p3)))
    else
        action = string.format("+ Interagiu %s", action)
    end

    local v30 = value32()

    v30.Action = action
    task.spawn(function()
        UserInputService("log", v30)
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
Players = t1.value22.CurrentCamera
t1.value23 = t1.value14.LocalPlayer
if not t1.value23 then
    Players = t1.value14.LocalPlayer

    repeat
        task.wait()
    until t1.value14.LocalPlayer

    t1.value23 = t1.value14.LocalPlayer
end
t1.value24 = "NexVoidConfigs"
t1.value25 = t1.value24 .. "/default_config.txt"
t1.value26 = t1.value24 .. "/NVBackground.txt"
t1.value27 = {
	["ToggleKey"] = "K"
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
function t1.value28(p4)
    pcall(function()
        if not isfolder(t1.value24) then
            makefolder(t1.value24)
        end

        if not writefile then
            return
        end

        local v32 = p4

        writefile(t1.value26, (tostring(v32)))
    end)
end
Players = (function()
    local u33
    local function v34()
        local isfile_ = isfile and isfile(t1.value26)

        if isfile_ then
            isfile_ = readfile
        end

        if not isfile_ then
            return
        end

        u33 = readfile(t1.value26)
    end
    u33 = nil
    pcall(v34)
    v34 = u33
    if not v34 then
        return v34 and u33 or "79344922826816"
    end
    v34 = u33 ~= ""

    return v34 and u33 or "79344922826816"
end)()
t1.value29 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
t1.value30 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
function t1.value31(_, p5, p6)
    local PlayerGui = t1.value23:WaitForChild("PlayerGui", 5)
    if not PlayerGui then
        return
    end
end
task.spawn(function()
    t1.value31("Welcome, <b><font color=\'rgb(255,255,255)\'>" .. t1.value23.Name .. "</font></b>.", 5, "NexVoid V2.8")
end)
t1.value32 = nil
UserInputService, value32 = pcall(function()
    return gethui()
end)
if UserInputService and value32 then
    t1.value32 = value32
else
    UserInputService, value32 = pcall(function()
        return getgenv().gethui()
    end)

    if UserInputService and value32 then
        t1.value32 = value32
    else
        UserInputService, value32 = pcall(function()
            return game:GetService("CoreGui")
        end)

        if UserInputService and value32 then
            t1.value32 = value32
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
UserInputService = t1.value15.TouchEnabled
if UserInputService then
    UserInputService = not t1.value15.MouseEnabled
end
t1.value34 = UserInputService
t1.value35 = {
	["MainSize"] = t1.value34 and UDim2.new(0, 520, 0, 365) or UDim2.new(0, 600, 0, 420),
	["SidebarWidth"] = t1.value34 and 130 or 150,
	["FooterHeight"] = 18,
	["BtnHeight"] = t1.value34 and 24 or 28,
	["ListPadding"] = UDim.new(0, 2),
	["FontSize"] = t1.value34 and 10 or 12,
	["IconSize"] = t1.value34 and 13 or 16
}
t1.value36 = {
	["ItemHeightNew"] = 30,
	["ItemHeightOld"] = 35,
	["PlayerCardHeight"] = 45,
	["ItemPadding"] = UDim.new(0, 4)
}
t1.value37 = {
	["FrameColor"] = Color3.fromRGB(12, 12, 12),
	["ContentColor"] = Color3.fromRGB(20, 20, 20),
	["ItemColor"] = Color3.fromRGB(30, 30, 30),
	["ItemStroke"] = Color3.fromRGB(60, 60, 60),
	["SwitchOff"] = Color3.fromRGB(40, 40, 40),
	["Accent"] = Color3.fromRGB(240, 240, 240),
	["AccentDark"] = Color3.fromRGB(160, 160, 160),
	["Text"] = Color3.fromRGB(255, 255, 255),
	["TextDark"] = Color3.fromRGB(150, 150, 150),
	["Font"] = Enum.Font.GothamBold,
	["CloseRed"] = Color3.fromRGB(100, 100, 100)
}
t1.value38 = {
	["OnlyBeast"] = false,
	["HideNames"] = false,
	["BeastHighlight"] = Color3.fromRGB(0, 255, 255),
	["Survivor"] = Color3.fromRGB(0, 255, 0),
	["Beast"] = Color3.fromRGB(255, 0, 0),
	["Pod"] = Color3.fromRGB(0, 255, 255),
	["TracerThickness"] = 1.5,
	["OutlineSurvivor"] = Color3.fromRGB(0, 0, 0),
	["OutlineBeast"] = Color3.fromRGB(0, 0, 0),
	["OutlineComp"] = Color3.fromRGB(0, 0, 0),
	["OutlinePod"] = Color3.fromRGB(0, 0, 0),
	["OutlineDoor"] = Color3.fromRGB(0, 0, 0)
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
UserInputService = function(p7)
    t1.value39 = p7
    t1.value41.Size = UDim2.new(0, p7, 0, p7)
    t1.value42.Size = UDim2.new(0, p7, 0, p7)
end
function t1.value43(p8)
    t1.value40 = p8
end
t1.value17.RenderStepped:Connect(function()
    local mouseLocation

    if t1.value40 then
        t1.value15.MouseIconEnabled = false
        mouseLocation = t1.value15:GetMouseLocation()
        t1.value42.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)

        return
    end

    if t1.value15.MouseIconEnabled == false then
        mouseLocation = not t1.value40
    else
        mouseLocation = false
    end

    if not mouseLocation then
        return
    end

    t1.value15.MouseIconEnabled = true
end)
value32 = function(p9, p10, p11, p12)
    local UIGradient = p9:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p10), ColorSequenceKeypoint.new(1, p11) })
    UIGradient.Rotation = p12 or 45
    UIGradient.Parent = p9

    return UIGradient
end
t1.value44 = {}
function t1.value45(p13)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(170, 170, 170)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.65, Color3.fromRGB(170, 170, 170)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))
	})
    UIGradient.Rotation = 20
    UIGradient.Parent = p13

    local value44 = t1.value44

    table.insert(value44, UIGradient)

    return UIGradient
end
t1.value17.RenderStepped:Connect(function()
    local v43 = tick() * 0.6 % 2 - 1

    for i = #t1.value44, 1, -1 do
        local v45 = t1.value44[i]
        local Parent

        if v45 then
            Parent = v45.Parent
        else
            Parent = v45
        end

        if Parent then
            v45.Offset = Vector2.new(v43, 0)
        else
            table.remove(t1.value44, i)
        end
    end
end)
function t1.value46()
    local s1 = "config_1"

    local function v48()
        local isfile_ = isfile

        if isfile_ then
            isfile_ = isfile(t1.value25)
        end

        if not isfile_ then
            return
        end

        s1 = readfile(t1.value25)
    end

    pcall(v48)

    return s1
end
local TextButton = t1.value46()
function t1.value47(p14)
    local v51 = Enum.Font[p14]

    if not v51 then
        return
    end

    t1.value37.Font = v51

    local ipairs_ = ipairs
    local value33 = t1.value33

    for _, descendant in ipairs_(value33:GetDescendants()) do
        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            descendant.Font = v51
        end
    end
end
t1.value48 = Enum.KeyCode[t1.value27.ToggleKey] or Enum.KeyCode.K
function t1.value49(p15)
    t1.value27.ToggleKey = t1.value48.Name

    local function v56()
        if not isfolder(t1.value24) then
            makefolder(t1.value24)
        end

        if not writefile then
            return
        end

        writefile(t1.value24 .. "/" .. p15 .. ".json", t1.value18:JSONEncode(t1.value27))
    end

    pcall(v56)
end
function t1.value50(p16)
    local v57
    local function v58()
        if not isfolder(t1.value24) then
            makefolder(t1.value24)
        end

        if not writefile then
            return
        end

        writefile(t1.value25, v57)
    end
    v57 = p16
    pcall(v58)
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
		["ToggleKey"] = "K"
	}
    t1.value48 = Enum.KeyCode.K
end
local function parent(p17, p18)
    local u61
    local u62
    local Position
    local Position2
    p17.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u61 = true
        Position = input.Position
        Position2 = p18.Position
    end)
    p17.InputChanged:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u62 = input
    end)
    t1.value15.InputChanged:Connect(function(input)
        if input == u62 then
            v84 = u61
        else
            v84 = false
        end

        if not v84 then
            return
        end

        local v65 = input.Position - Position

        p18.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v65.X, Position2.Y.Scale, Position2.Y.Offset + v65.Y)
    end)
    p17.InputEnded:Connect(function(input)
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
local TextButton2 = Instance.new("TextButton")
TextButton2.Name = "FirstPersonFix"
TextButton2.Size = UDim2.new(1, 0, 1, 0)
TextButton2.BackgroundTransparency = 1
TextButton2.ZIndex = -99
TextButton2.Text = ""
TextButton2.Modal = true
TextButton2.Parent = t1.value52
TextButton2 = Instance.new("UIStroke")
TextButton2.Parent = t1.value52
TextButton2.Thickness = 1.5
TextButton2.Transparency = 0.2
value32(TextButton2, t1.value37.Accent, Color3.fromRGB(20, 20, 20), -45)
t1.value53 = Instance.new("ImageLabel")
t1.value53.Name = "AnimeBackground"
t1.value53.Size = UDim2.new(1, 0, 1, 0)
t1.value53.Image = "rbxassetid://" .. Players
t1.value53.ScaleType = Enum.ScaleType.Crop
t1.value53.BackgroundTransparency = 1
t1.value53.ZIndex = 1
t1.value53.Parent = t1.value52
TextButton2 = Instance.new("Frame")
TextButton2.Name = "DarkOverlay"
TextButton2.Size = UDim2.new(1, 0, 1, 0)
TextButton2.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton2.BackgroundTransparency = 0.65
TextButton2.ZIndex = 2
TextButton2.Parent = t1.value52
t1.value54 = Instance.new("Frame")
t1.value54.Size = UDim2.new(1, 0, 0, 40)
t1.value54.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value54.BackgroundTransparency = 0.5
t1.value54.BorderSizePixel = 0
t1.value54.ZIndex = 3
t1.value54.Parent = t1.value52
parent(t1.value54, t1.value52)
TextButton2 = Instance.new("Frame")
TextButton2.Size = UDim2.new(1, 0, 0, 1)
TextButton2.Position = UDim2.new(0, 0, 1, 0)
TextButton2.BorderSizePixel = 0
TextButton2.Parent = t1.value54
value32(TextButton2, Color3.new(0, 0, 0), t1.value37.Accent, 0)
TextButton2 = Instance.new("TextLabel")
TextButton2.Name = "TitleLabel"
TextButton2.Text = "Nex<font color=\'rgb(150,150,150)\'>Void V2.8</font>"
TextButton2.RichText = true
TextButton2.Size = UDim2.new(0, 180, 1, 0)
TextButton2.BackgroundTransparency = 1
TextButton2.Font = t1.value37.Font
TextButton2.TextSize = t1.value34 and 14 or 16
TextButton2.TextColor3 = t1.value37.Text
TextButton2.TextXAlignment = Enum.TextXAlignment.Left
TextButton2.Position = UDim2.new(0, 45, 0, 0)
TextButton2.ZIndex = 4
TextButton2.Parent = t1.value54
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
TextButton2 = Instance.new("UIStroke")
TextButton2.Color = t1.value37.Accent
TextButton2.Thickness = 1.5
TextButton2.Parent = t1.value55
value32(TextButton2, t1.value37.Accent, Color3.fromRGB(50, 50, 50), 45)
parent(t1.value55, t1.value55)
parent = function(p19, p20, p21, p22)
    local ImageButton

    if p22 then
        ImageButton = Instance.new("ImageButton")
        ImageButton.Image = "rbxassetid://" .. p20
        ImageButton.ScaleType = Enum.ScaleType.Fit
        ImageButton.ImageTransparency = 1

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Size = UDim2.new(0, 14, 0, 14)
        ImageLabel.Position = UDim2.new(0.5, -7, 0.5, -7)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://" .. p20
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
        ImageButton.Text = p20
        ImageButton.Font = Enum.Font.GothamBlack
        ImageButton.TextSize = 14
        ImageButton.TextColor3 = t1.value37.TextDark

        if p20 == "-" then
            ImageButton.Text = ""
            ImageButton = Instance.new("Frame")
            ImageButton.Size = UDim2.new(0, 10, 0, 2)
            ImageButton.Position = UDim2.new(0.5, -5, 0.5, 0)
            ImageButton.BackgroundColor3 = t1.value37.TextDark
            ImageButton.BorderSizePixel = 0
            ImageButton.ZIndex = 4
            ImageButton.Parent = ImageButton
            ImageButton.MouseEnter:Connect(function()
                ImageButton.BackgroundColor3 = t1.value37.Accent
            end)
            ImageButton.MouseLeave:Connect(function()
                ImageButton.BackgroundColor3 = t1.value37.TextDark
            end)
        elseif p19 == "Language" then
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

    ImageButton.Name = p19
    ImageButton.Parent = t1.value54
    ImageButton.BackgroundTransparency = 1
    ImageButton.ZIndex = 4
    ImageButton.Position = UDim2.new(1, -(35 * p21), 0, 0)
    ImageButton.Size = UDim2.new(0, 35, 1, 0)

    return ImageButton
end
TextButton2 = parent("Close", "X", 1, false)
local Minimize = parent("Minimize", "-", 2, false)
local Info = parent("Info", "5832745500", 3, true)
t1.value56 = parent("Language", "EN", 4, false)
parent = Instance.new("Frame")
parent.Name = "SearchContainer"
parent.Size = UDim2.new(0, t1.value34 and 90 or 110, 0, 24)
local n2 = -140
parent.Position = UDim2.new(1, t1.value34 and n2 and n2 or -155, 0.5, 0)
parent.AnchorPoint = Vector2.new(1, 0.5)
parent.BackgroundColor3 = Color3.new(0, 0, 0)
parent.BackgroundTransparency = 0.45
parent.BorderSizePixel = 0
parent.ClipsDescendants = true
parent.ZIndex = 4
parent.Parent = t1.value54
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", parent).Color = Color3.fromRGB(40, 40, 40)
n2 = Instance.new("ImageLabel")
n2.Size = UDim2.new(0, 12, 0, 12)
n2.Position = UDim2.new(0, 8, 0.5, -6)
n2.BackgroundTransparency = 1
n2.Image = "rbxassetid://104986431790017"
n2.ImageColor3 = t1.value37.TextDark
n2.ZIndex = 5
n2.Parent = parent
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
t1.value57.Parent = parent
parent = Instance.new("Frame")
parent.Name = "CenterContainer"
parent.Size = UDim2.new(1, 0, 1, -(40 + t1.value35.FooterHeight))
parent.Position = UDim2.new(0, 0, 0, 40)
parent.BackgroundTransparency = 1
parent.ZIndex = 3
parent.Parent = t1.value52
t1.value58 = Instance.new("Frame")
t1.value58.Name = "Sidebar"
t1.value58.Size = UDim2.new(0, t1.value35.SidebarWidth, 1, 0)
t1.value58.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value58.BackgroundTransparency = 0.6
t1.value58.BorderSizePixel = 0
t1.value58.ZIndex = 3
t1.value58.Parent = parent
n2 = Instance.new("UIListLayout")
n2.Padding = t1.value35.ListPadding
n2.SortOrder = Enum.SortOrder.LayoutOrder
n2.Parent = t1.value58
n2 = Instance.new("UIPadding")
n2.PaddingTop = UDim.new(0, 5)
n2.PaddingBottom = UDim.new(0, 5)
n2.Parent = t1.value58
t1.value59 = Instance.new("Frame")
t1.value59.Name = "ContentArea"
t1.value59.Size = UDim2.new(1, -t1.value35.SidebarWidth, 1, 0)
t1.value59.Position = UDim2.new(0, t1.value35.SidebarWidth, 0, 0)
t1.value59.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value59.BackgroundTransparency = 0.7
t1.value59.BorderSizePixel = 0
t1.value59.ZIndex = 3
t1.value59.Parent = parent
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, 0, 0, t1.value35.FooterHeight)
parent.Position = UDim2.new(0, 0, 1, -t1.value35.FooterHeight)
parent.BackgroundColor3 = Color3.new(0, 0, 0)
parent.BackgroundTransparency = 0.5
parent.BorderSizePixel = 0
parent.ZIndex = 5
parent.Parent = t1.value52
n2 = Instance.new("TextLabel")
n2.RichText = true
n2.Text = "Discord: <font color=\'rgb(200,200,200)\'>.gg/uxPjBvxPY6</font>"
n2.Size = UDim2.new(1, -10, 1, 0)
n2.Position = UDim2.new(0, 10, 0, 0)
n2.BackgroundTransparency = 1
n2.TextColor3 = t1.value37.Text
n2.Font = t1.value37.Font
n2.TextSize = 10
n2.TextXAlignment = Enum.TextXAlignment.Left
n2.ZIndex = 6
n2.Parent = parent
n2 = Instance.new("TextLabel")
n2.RichText = true
n2.Text = "NexVoid V2.8 <font color=\'rgb(200,200,200)\'>" .. (t1.value34 and "Mobile" or "PC") .. "</font> | Thank you for using NexVoid."
n2.Size = UDim2.new(1, -10, 1, 0)
n2.Position = UDim2.new(0, 0, 0, 0)
n2.BackgroundTransparency = 1
n2.TextColor3 = t1.value37.Text
n2.Font = t1.value37.Font
n2.TextSize = 10
n2.TextXAlignment = Enum.TextXAlignment.Right
n2.ZIndex = 6
n2.Parent = parent
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
parent = Instance.new("UIStroke")
parent.Color = Color3.fromRGB(40, 40, 40)
parent.Thickness = 1.5
parent.Parent = t1.value61
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, 0, 0, 4)
parent.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
parent.BorderSizePixel = 0
parent.ZIndex = 12
parent.Parent = t1.value61
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 10)
n2 = Instance.new("Frame")
n2.Size = UDim2.new(1, 0, 0, 2)
n2.Position = UDim2.new(0, 0, 1, -2)
n2.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
n2.BorderSizePixel = 0
n2.ZIndex = 12
n2.Parent = parent
value32(parent, Color3.fromRGB(255, 80, 80), Color3.fromRGB(150, 20, 20), 0)
parent = Instance.new("TextLabel")
parent.Size = UDim2.new(1, 0, 0, 40)
parent.Position = UDim2.new(0, 0, 0, 15)
parent.BackgroundTransparency = 1
parent.Text = "Exit NexVoidHub"
parent:SetAttribute("OriginalText", "Exit NexVoidHub")
parent.Font = Enum.Font.GothamBlack
parent.TextSize = 18
parent.TextColor3 = Color3.fromRGB(255, 255, 255)
parent.ZIndex = 12
parent.Parent = t1.value61
parent = Instance.new("TextLabel")
parent.Size = UDim2.new(1, -40, 0, 40)
parent.Position = UDim2.new(0, 20, 0, 50)
parent.BackgroundTransparency = 1
parent.Text = "Are you sure you want to close the script? You will need to re-execute to open it again."
parent:SetAttribute("OriginalText", "Are you sure you want to close the script? You will need to re-execute to open it again.")
parent.Font = Enum.Font.Gotham
parent.TextSize = 12
parent.TextColor3 = Color3.fromRGB(180, 180, 180)
parent.TextWrapped = true
parent.ZIndex = 12
parent.Parent = t1.value61
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
parent = Instance.new("UIStroke")
parent.Color = Color3.fromRGB(100, 20, 20)
parent.Thickness = 1
parent.Parent = t1.value64
value32(t1.value64, Color3.fromRGB(255, 60, 60), Color3.fromRGB(180, 20, 20), 90)
t1.value62.MouseEnter:Connect(function()
    local value16 = t1.value16
    local value62 = t1.value62
    local tweenInfo = TweenInfo.new(0.2)
    local Color3_ = Color3

    value16.Create(value16, value62, tweenInfo, {
		["BackgroundColor3"] = Color3_.fromRGB(40, 40, 40)
	}):Play()
    value16 = t1.value16
    value62 = t1.value63
    tweenInfo = TweenInfo.new(0.2)
    Color3_ = Color3.fromRGB
    value16.Create(value16, value62, tweenInfo, {
		["Color"] = Color3_(100, 100, 100)
	}):Play()
end)
t1.value62.MouseLeave:Connect(function()
    local value16 = t1.value16
    local value62 = t1.value62
    local tweenInfo = TweenInfo.new(0.2)
    local Color3_ = Color3

    value16.Create(value16, value62, tweenInfo, {
		["BackgroundColor3"] = Color3_.new(0, 0, 0)
	}):Play()
    value16 = t1.value16
    value62 = t1.value63
    tweenInfo = TweenInfo.new(0.2)
    Color3_ = Color3
    value16.Create(value16, value62, tweenInfo, {
		["Color"] = Color3_.fromRGB(40, 40, 40)
	}):Play()
end)
t1.value64.MouseEnter:Connect(function()
    local value16 = t1.value16
    local value64 = t1.value64
    local tweenInfo = TweenInfo.new(0.2)
    local color3 = Color3.fromRGB

    value16.Create(value16, value64, tweenInfo, {
		["BackgroundColor3"] = color3(255, 60, 60)
	}):Play()
end)
t1.value64.MouseLeave:Connect(function()
    t1.value16:Create(t1.value64, TweenInfo.new(0.2), {
		["BackgroundColor3"] = Color3.fromRGB(220, 40, 40)
	}):Play()
end)
t1.value62.MouseButton1Click:Connect(function()
    local value16 = t1.value16
    local value61 = t1.value61
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local uDim2New = UDim2.new

    value16.Create(value16, value61, tweenInfo, {
		["Size"] = uDim2New(0, 0, 0, 0)
	}):Play()
    task.delay(0.2, function()
        t1.value60.Visible = false
        t1.value61.Visible = false
    end)
end)
t1.value64.MouseButton1Click:Connect(function()
    t1.value33:Destroy()
end)
t1.value65 = (function(p23)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 300, 0, p23)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 11
    Frame.Visible = false
    Frame.Parent = t1.value60

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Parent = Frame
    UIStroke = Instance.new("Frame")
    UIStroke.Size = UDim2.new(1, 0, 0, 2)
    UIStroke.BackgroundColor3 = t1.value37.Accent
    UIStroke.BorderSizePixel = 0
    UIStroke.ZIndex = 12
    UIStroke.Parent = Frame
    value32(UIStroke, t1.value37.Accent, t1.value37.AccentDark, 0)

    return Frame
end)(350)
parent = Instance.new("TextLabel")
parent.Parent = t1.value65
parent.Text = "SCRIPT INFO"
parent:SetAttribute("OriginalText", "SCRIPT INFO")
parent.Size = UDim2.new(1, 0, 0, 35)
parent.TextColor3 = t1.value37.Accent
parent.BackgroundTransparency = 1
parent.Font = t1.value37.Font
parent.TextSize = 14
parent = Instance.new("TextButton")
parent.Parent = t1.value65
parent.Text = "Close"
parent:SetAttribute("OriginalText", "Close")
parent.Size = UDim2.new(0, 260, 0, 30)
parent.Position = UDim2.new(0, 20, 1, -40)
parent.BackgroundColor3 = Color3.new(0, 0, 0)
parent.BackgroundTransparency = 0.45
parent.TextColor3 = t1.value37.TextDark
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", parent).Color = Color3.fromRGB(40, 40, 40)
t1.value66 = Instance.new("ScrollingFrame", t1.value65)
t1.value66.Size = UDim2.new(1, 0, 1, -85)
t1.value66.Position = UDim2.new(0, 0, 0, 35)
t1.value66.BackgroundTransparency = 1
t1.value66.BorderSizePixel = 0
t1.value66.ScrollBarThickness = 2
t1.value66.ScrollBarImageColor3 = t1.value37.Accent
n2 = Instance.new("UIListLayout", t1.value66)
n2.Padding = UDim.new(0, 10)
n2.HorizontalAlignment = Enum.HorizontalAlignment.Center
TextButton2.MouseButton1Click:Connect(function()
    t1.value60.Visible = true
    t1.value61.Size = UDim2.new(0, 0, 0, 0)
    t1.value61.Visible = true

    local value16 = t1.value16
    local value61 = t1.value61
    local tweenInfoNew = TweenInfo.new
    local Enum_ = Enum

    value16.Create(value16, value61, tweenInfoNew(0.4, Enum_.EasingStyle.Back, Enum.EasingDirection.Out), {
		["Size"] = UDim2.new(0, 310, 0, 165)
	}):Play()
    t1.value65.Visible = false
end)
Info.MouseButton1Click:Connect(function()
    t1.value60.Visible = true
    t1.value65.Visible = true
    t1.value61.Visible = false
end)
parent.MouseButton1Click:Connect(function()
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

    local v95 = t1.value68[t1.value67]

    t1.value56.Text = v95
    task.spawn(function()
        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Translation2.8"))()
        end)

        if not (ok and result) then
            return
        end

        if type(result) == "table" then
            ok = result.Translate
        else
            ok = false
        end

        if ok then
            result.Translate(t1.value33, v95)

            return
        end

        if type(result) ~= "function" then
            return
        end

        result(t1.value33, v95)
    end)
end)
t1.value57:GetPropertyChangedSignal("Text"):Connect(function()
    local v98 = t1.value57.Text:lower()
    local pairs_ = pairs
    local value59 = t1.value59

    for _, child in pairs_(value59:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            if child:GetAttribute("OldStyle") then
                local GetChildren = child.GetChildren

                for _, v in pairs(GetChildren(child)) do
                    if v:IsA("Frame") or v:IsA("TextButton") then
                        local TextLabel = v:FindFirstChildWhichIsA("TextLabel") or (v:IsA("TextButton") and v and v or nil)

                        if (TextLabel and TextLabel.Text or ""):lower():find(v98) then
                            v.Visible = true
                        elseif v98 ~= "" then
                            v.Visible = false
                        end
                    end
                end
            else
                for _, child2 in pairs(child:GetChildren()) do
                    if child2:IsA("Frame") and child2.Name == "LeftCol" and true or child2.Name == "RightCol" then
                        for _, child3 in pairs(child2:GetChildren()) do
                            local isFrame = child3:IsA("Frame")

                            if isFrame then
                                isFrame = child3.Name:match("^CategoryBox_")
                            end

                            if isFrame then
                                isFrame = child3.GetChildren

                                local v112 = false

                                for _, v in pairs(isFrame(child3)) do
                                    if v:IsA("Frame") or v:IsA("TextButton") then
                                        if v.Name ~= "HeaderContainer" then
                                            local TextLabel = v:FindFirstChildWhichIsA("TextLabel") or (v:IsA("TextButton") and v and v or nil)

                                            if (TextLabel and TextLabel.Text or ""):lower():find(v98) then
                                                v.Visible = true
                                                v112 = true
                                            elseif v98 ~= "" then
                                                v.Visible = false
                                            end
                                        end
                                    end
                                end

                                if v98 == "" then
                                    isFrame = false
                                else
                                    isFrame = not v112
                                end

                                if isFrame then
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
    local v116 = not gameProcessed

    if v116 then
        v116 = input.KeyCode == t1.value48
    end

    if not v116 then
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
function t1.value73(p24)
    if p24:GetAttribute("OldStyle") then
        return t1.value71[p24] or p24
    else
        if t1.value69.CurrentSections[p24] then
            return t1.value69.CurrentSections[p24]
        else
            return p24:FindFirstChild("LeftCol") or p24
        end

        return
    end
end
function t1.value74(p25)
    local v117 = t1.value24 .. "/" .. p25 .. ".json"

    v117 = function()
        local isfile_ = isfile and isfile(v117)

        if isfile_ then
            isfile_ = readfile
        end

        isfile_ = isfile_ and readfile(v117)

        if not isfile_ then
            return
        end

        isfile_ = t1.value18:JSONDecode(isfile_)

        if type(isfile_) ~= "table" then
            return
        end

        for k, v in pairs(isfile_) do
            if k ~= "SettingsPage_UI Background" and k ~= "SettingsPage_Custom Background ID" then
                t1.value27[k] = v

                if t1.value69.Registry[k] then
                    pcall(t1.value69.Registry[k].Set, v)
                end
            end
        end
    end
    pcall(v117)
end
t1.value74(TextButton)
parent = function(p26, p27, p28, p29)
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = p27 .. "Page"
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
    ScrollingFrame:SetAttribute("OldStyle", p29 == true)

    if p29 then
        v155 = Instance.new("UIListLayout")
        v155.Padding = t1.value36.ItemPadding
        v155.SortOrder = Enum.SortOrder.LayoutOrder
        v155.Parent = ScrollingFrame
        v155 = Instance.new("UIPadding")
        v155.PaddingBottom = UDim.new(0, 10)
        v155.Parent = ScrollingFrame
    else
        v155 = Instance.new("UIListLayout")
        v155.FillDirection = Enum.FillDirection.Horizontal
        v155.Padding = UDim.new(0, 12)
        v155.SortOrder = Enum.SortOrder.LayoutOrder
        v155.Parent = ScrollingFrame
        v155 = Instance.new("UIPadding")
        v155.PaddingBottom = UDim.new(0, 10)
        v155.Parent = ScrollingFrame
        v155 = Instance.new("Frame")
        v155.Name = "LeftCol"
        v155.Size = UDim2.new(0.5, -6, 0, 0)
        v155.AutomaticSize = Enum.AutomaticSize.Y
        v155.BackgroundTransparency = 1
        v155.Parent = ScrollingFrame
        v_u_156 = Instance.new("UIListLayout")
        v_u_156.Padding = UDim.new(0, 10)
        v_u_156.SortOrder = Enum.SortOrder.LayoutOrder
        v_u_156.Parent = v155
        v155 = Instance.new("Frame")
        v155.Name = "RightCol"
        v155.Size = UDim2.new(0.5, -6, 0, 0)
        v155.AutomaticSize = Enum.AutomaticSize.Y
        v155.BackgroundTransparency = 1
        v155.Parent = ScrollingFrame
        v_u_156 = Instance.new("UIListLayout")
        v_u_156.Padding = UDim.new(0, 10)
        v_u_156.SortOrder = Enum.SortOrder.LayoutOrder
        v_u_156.Parent = v155
        v155 = Instance.new("IntValue")
        v155.Name = "SectionCount"
        v155.Value = 0
        v155.Parent = ScrollingFrame
    end

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(1, 0, 0, t1.value35.BtnHeight)
    TextButton3.BackgroundTransparency = 1
    TextButton3.Text = ""
    TextButton3.Parent = t1.value58

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 3, 0.7, 0)
    Frame.Position = UDim2.new(0, 0, 0.15, 0)
    Frame.BackgroundColor3 = t1.value37.Accent
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = TextButton3
    value32(Frame, t1.value37.Accent, t1.value37.AccentDark, 90)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Image = "rbxassetid://" .. p26
    ImageLabel.Size = UDim2.new(0, t1.value35.IconSize, 0, t1.value35.IconSize)
    ImageLabel.Position = UDim2.new(0, 12, 0.5, -(t1.value35.IconSize / 2))
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.ImageTransparency = 0.2
    ImageLabel.Parent = TextButton3

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Text = p27
    TextLabel:SetAttribute("OriginalText", p27)
    TextLabel.Size = UDim2.new(0, 100, 1, 0)
    TextLabel.Position = UDim2.new(0, 34, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = t1.value37.Font
    TextLabel.TextSize = t1.value35.FontSize
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextTransparency = 0.2
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = TextButton3
    t1.value45(TextLabel)

    local function v126()
        for _, v in pairs(t1.value70) do
            v.Page.Visible = false
            v.Indicator.BackgroundTransparency = 1
            v.Label.TextTransparency = 0.2
            v.Icon.ImageTransparency = 0.2
        end

        ScrollingFrame.Visible = true
        Frame.BackgroundTransparency = 0
        TextLabel.TextTransparency = 0
        ImageLabel.ImageTransparency = 0
    end

    TextButton3.MouseButton1Click:Connect(v126)
    TextButton3 = t1.value70
    table.insert(TextButton3, {
		["Page"] = ScrollingFrame,
		["Indicator"] = Frame,
		["Label"] = TextLabel,
		["Icon"] = ImageLabel
	})

    if not p28 then
        return ScrollingFrame
    end

    task.spawn(function()
        pcall(function()
            p28(ScrollingFrame)
        end)
    end)

    return ScrollingFrame
end
function t1.value69.CreateSection(_, p30, p31, p32)
    if not p30:GetAttribute("OldStyle") then
        if p32 == "Left" then
            v166 = p30.LeftCol
        elseif p32 == "Right" then
            v166 = p30.RightCol
        else
            p30.SectionCount.Value = p30.SectionCount.Value + 1
            v166 = p30.SectionCount.Value % 2 == 1 and p30.LeftCol or p30.RightCol
        end

        local Frame = Instance.new("Frame")

        Frame.Name = "CategoryBox_" .. p31
        Frame.Size = UDim2.new(1, -2, 0, 0)
        Frame.Position = UDim2.new(0, 1, 0, 0)
        Frame.AutomaticSize = Enum.AutomaticSize.Y
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.45
        Frame.BorderSizePixel = 0
        Frame.Parent = v166
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(40, 40, 40)
        UIStroke.Thickness = 1
        UIStroke.Parent = Frame
        UIStroke = Instance.new("UIListLayout")
        UIStroke.SortOrder = Enum.SortOrder.LayoutOrder
        UIStroke.Padding = t1.value36.ItemPadding
        UIStroke.Parent = Frame
        UIStroke = Instance.new("UIPadding")
        UIStroke.PaddingTop = UDim.new(0, 8)
        UIStroke.PaddingBottom = UDim.new(0, 8)
        UIStroke.PaddingLeft = UDim.new(0, 10)
        UIStroke.PaddingRight = UDim.new(0, 10)
        UIStroke.Parent = Frame
        UIStroke = Instance.new("Frame")
        UIStroke.Name = "HeaderContainer"
        UIStroke.Size = UDim2.new(1, 0, 0, 20)
        UIStroke.BackgroundTransparency = 1
        UIStroke.Parent = Frame

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p31
        TextLabel:SetAttribute("OriginalText", p31)
        TextLabel.Font = t1.value37.Font
        TextLabel.TextSize = 12
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Parent = UIStroke
        t1.value69.CurrentSections[p30] = Frame

        return
    end
end
function t1.value69.CreateButton(_, p33, p34, p35)
    local attribute = p33:GetAttribute("OldStyle")
    local TextLabel = t1.value73(p33)

    if attribute then
        v173 = t1.value36.ItemHeightOld
    else
        v173 = attribute
    end

    local v173_ = v173 or t1.value36.ItemHeightNew
    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, v173_)
    TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    TextButton3.Text = ""
    TextButton3.Parent = TextLabel
    TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -10, 1, 0)
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p34
    TextLabel:SetAttribute("OriginalText", p34)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    v173_ = Instance.new("UITextSizeConstraint", TextLabel)
    v173_.MinTextSize = 7
    TextLabel.Parent = TextButton3

    if attribute then
        TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
        TextButton3.BackgroundTransparency = 0.45
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(40, 40, 40)
        UIStroke.Thickness = 1
        UIStroke.Parent = TextButton3
        TextLabel.Position = UDim2.new(0, 10, 0, 0)
        v173_.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        TextButton3.BackgroundTransparency = 1
        v173_.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end

    TextButton3.MouseButton1Click:Connect(function()
        if not _G.NexVoidLog then
            pcall(p35)

            return
        end

        task.spawn(function()
            _G.NexVoidLog("Button", p34)
        end)
        pcall(p35)
    end)

    if attribute then
        return
    end

    TextButton3.MouseEnter:Connect(function()
        t1.value16:Create(TextLabel, TweenInfo.new(0.2), {
			["TextColor3"] = t1.value37.Accent
		}):Play()
    end)
    attribute = function()
        local value16 = t1.value16
        local v138 = TextLabel
        local tweenInfo = TweenInfo.new(0.2)
        local value37 = t1.value37

        value16.Create(value16, v138, tweenInfo, {
			["TextColor3"] = value37.TextDark
		}):Play()
    end
    TextButton3.MouseLeave:Connect(attribute)
end
function t1.value69.CreateToggle(_, p36, p37, p38, p39)
    local attribute = p36:GetAttribute("OldStyle")
    local TextLabel = t1.value73(p36)
    local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
    local v144 = p36.Name .. "_" .. p37
    local u145 = t1.value27[v144]

    if u145 == nil then
        u145 = p38 or false
    end

    t1.value27[v144] = u145

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
    TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    TextButton3.Text = ""
    TextButton3.Parent = TextLabel
    TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -40, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p37
    TextLabel:SetAttribute("OriginalText", p37)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    ItemHeightOld = Instance.new("UITextSizeConstraint", TextLabel)
    ItemHeightOld.MinTextSize = 7
    TextLabel.Parent = TextButton3

    if attribute then
        TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
        TextButton3.BackgroundTransparency = 0.45
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
        v_u_192 = Instance.new("UIStroke")
        v_u_192.Color = Color3.fromRGB(40, 40, 40)
        v_u_192.Thickness = 1
        v_u_192.Parent = TextButton3
        TextLabel.Position = UDim2.new(0, 12, 0, 0)
        ItemHeightOld.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        TextButton3.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        ItemHeightOld.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end

    local n3

    if attribute then
        ItemHeightOld = 34
        v_u_192 = 18
        n3 = 14
    else
        ItemHeightOld = 30
        v_u_192 = 14
        n3 = 12
    end

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, ItemHeightOld, 0, v_u_192)
    Frame.Position = attribute and UDim2.new(1, -46, 0.5, -9) or UDim2.new(1, -30, 0.5, -7)
    Frame.BackgroundColor3 = t1.value37.SwitchOff
    Frame.Parent = TextButton3
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
    ItemHeightOld = value32(Frame, t1.value37.SwitchOff, t1.value37.SwitchOff, 90)

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(0, n3, 0, n3)
    Frame2.Position = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)
    Frame2.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Frame2.Parent = Frame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)
    attribute = function(p40)
        local uDim2 = attribute and UDim2.new(1, -16, 0.5, -7) or UDim2.new(1, -13, 0.5, -6)
        local uDim22 = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)
        local tweenInfo, value37

        if u145 then
            t1.value16:Create(Frame, TweenInfo.new(0.2), {
				["BackgroundColor3"] = t1.value37.Accent
			}):Play()
            ItemHeightOld.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.Accent), ColorSequenceKeypoint.new(1, t1.value37.AccentDark) })
            t1.value16:Create(Frame2, TweenInfo.new(0.2), {
				["Position"] = uDim2,
				["BackgroundColor3"] = Color3.new(0, 0, 0)
			}):Play()

            if not attribute then
                uDim2 = t1.value16
                uDim22 = TextLabel
                tweenInfo = TweenInfo.new(0.2)
                value37 = t1.value37
                uDim2.Create(uDim2, uDim22, tweenInfo, {
					["TextColor3"] = value37.Text
				}):Play()
            end
        else
            t1.value16:Create(Frame, TweenInfo.new(0.2), {
				["BackgroundColor3"] = t1.value37.SwitchOff
			}):Play()
            ItemHeightOld.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.SwitchOff), ColorSequenceKeypoint.new(1, t1.value37.SwitchOff) })
            uDim2 = t1.value16
            tweenInfo = Frame2
            value37 = TweenInfo
            uDim2.Create(uDim2, tweenInfo, value37.new(0.2), {
				["Position"] = uDim22,
				["BackgroundColor3"] = Color3.fromRGB(150, 150, 150)
			}):Play()

            if not attribute then
                uDim2 = t1.value16
                uDim22 = TextLabel
                tweenInfo = TweenInfo.new(0.2)
                uDim2.Create(uDim2, uDim22, tweenInfo, {
					["TextColor3"] = t1.value37.TextDark
				}):Play()
            end
        end

        if not p40 then
            return
        end

        pcall(p39, u145)
    end
    TextLabel = function(p41)
        u145 = p41
        t1.value27[v144] = u145
        attribute(true)
    end
    TextButton3.MouseButton1Click:Connect(function()
        u145 = not u145
        TextLabel(u145)

        if not _G.NexVoidLog then
            return
        end

        task.spawn(function()
            _G.NexVoidLog("Toggle", p37, u145)
        end)
    end)
    t1.value69.Registry[v144] = {
		["Type"] = "Toggle",
		["Set"] = TextLabel,
		["Default"] = p38 or false
	}

    if not u145 then
        attribute(false)

        return {
			["Set"] = TextLabel
		}
    end

    task.spawn(function()
        pcall(p39, u145)
    end)
    attribute(false)

    return {
		["Set"] = TextLabel
	}
end
function t1.value69.CreateToggleKeybind(_, p42, p43, p44, p45, p46)
    local attribute = p42:GetAttribute("OldStyle")
    local TextLabel = t1.value73(p42)
    local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
    local v157 = p42.Name .. "_" .. p43 .. "_State"
    local v158 = p42.Name .. "_" .. p43 .. "_Key"
    local u159 = t1.value27[v157]
    if u159 == nil then
        u159 = p44 or false
    end
    t1.value27[v157] = u159
    local v160 = t1.value27[v158]
    v160 = v160 == nil and (p45 or "None") or v160
    t1.value27[v158] = v160
    local TextButton3 = Instance.new("TextButton")
    TextButton3.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
    TextButton3.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    TextButton3.Text = ""
    TextButton3.Parent = TextLabel
    TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -110, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p43
    TextLabel:SetAttribute("OriginalText", p43)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    ItemHeightOld = Instance.new("UITextSizeConstraint", TextLabel)
    ItemHeightOld.MinTextSize = 7
    TextLabel.Parent = TextButton3
    if attribute then
        TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
        TextButton3.BackgroundTransparency = 0.45
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
        v_u_214 = Instance.new("UIStroke")
        v_u_214.Color = Color3.fromRGB(40, 40, 40)
        v_u_214.Thickness = 1
        v_u_214.Parent = TextButton3
        TextLabel.Position = UDim2.new(0, 12, 0, 0)
        ItemHeightOld.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        TextButton3.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        ItemHeightOld.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end
    ItemHeightOld = Instance.new("TextButton")
    ItemHeightOld.Size = attribute and UDim2.new(0, 45, 0, 20) or UDim2.new(0, 32, 0, 16)
    ItemHeightOld.Position = attribute and UDim2.new(1, -100, 0.5, -10) or UDim2.new(1, -66, 0.5, -8)
    ItemHeightOld.BackgroundColor3 = Color3.new(0, 0, 0)
    ItemHeightOld.BackgroundTransparency = 0.45
    ItemHeightOld.Text = v160 == "None" and attribute and "Set Key" or "Key" or v160
    ItemHeightOld.TextColor3 = t1.value37.TextDark
    ItemHeightOld.Font = Enum.Font.Gotham
    ItemHeightOld.TextSize = 10
    ItemHeightOld.Parent = TextButton3
    Instance.new("UICorner", ItemHeightOld).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", ItemHeightOld).Color = Color3.fromRGB(40, 40, 40)
    v160 = Instance.new("TextButton")
    v160.Size = attribute and UDim2.new(0, 40, 0, 20) or UDim2.new(0, 26, 0, 16)
    v160.Position = attribute and UDim2.new(1, -148, 0.5, -10) or UDim2.new(1, -96, 0.5, -8)
    v160.BackgroundColor3 = Color3.new(0, 0, 0)
    v160.BackgroundTransparency = 0.45
    v160.Text = attribute and "Reset" or "Del"
    v160.TextColor3 = t1.value37.CloseRed
    v160.Font = Enum.Font.Gotham
    v160.TextSize = 10
    v160.Parent = TextButton3
    Instance.new("UICorner", v160).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", v160).Color = Color3.fromRGB(40, 40, 40)
    local n4
    if attribute then
        v_u_214 = 34
        v_u_215 = 18
        n4 = 14
    else
        v_u_214 = 30
        v_u_215 = 14
        n4 = 12
    end
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, v_u_214, 0, v_u_215)
    Frame.Position = attribute and UDim2.new(1, -46, 0.5, -9) or UDim2.new(1, -30, 0.5, -7)
    Frame.BackgroundColor3 = t1.value37.SwitchOff
    Frame.Parent = TextButton3
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
    local v164 = value32(Frame, t1.value37.SwitchOff, t1.value37.SwitchOff, 90)
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, n4, 0, n4)
    Frame2.Position = attribute and UDim2.new(0, 2, 0.5, -7) or UDim2.new(0, 1, 0.5, -6)
    Frame2.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Frame2.Parent = Frame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)
    TextLabel = function(p47)
        local uDim2 = attribute

        if uDim2 then
            uDim2 = UDim2.new(1, -16, 0.5, -7)
        end

        uDim2 = uDim2 or UDim2.new(1, -13, 0.5, -6)

        local uDim22 = attribute

        if uDim22 then
            uDim22 = UDim2.new(0, 2, 0.5, -7)
        end

        uDim22 = uDim22 or UDim2.new(0, 1, 0.5, -6)

        local TweenInfo_, tweenInfo

        if u159 then
            uDim22 = t1.value16
            TweenInfo_ = Frame
            tweenInfo = TweenInfo.new(0.2)

            local value37 = t1.value37

            uDim22.Create(uDim22, TweenInfo_, tweenInfo, {
				["BackgroundColor3"] = value37.Accent
			}):Play()
            v164.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.Accent), ColorSequenceKeypoint.new(1, t1.value37.AccentDark) })
            uDim22 = t1.value16
            TweenInfo_ = Frame2
            tweenInfo = TweenInfo.new(0.2)
            value37 = Color3.new
            uDim22.Create(uDim22, TweenInfo_, tweenInfo, {
				["Position"] = uDim2,
				["BackgroundColor3"] = value37(0, 0, 0)
			}):Play()

            if not attribute then
                uDim2 = t1.value16
                uDim22 = TextLabel
                TweenInfo_ = TweenInfo
                uDim2.Create(uDim2, uDim22, TweenInfo_.new(0.2), {
					["TextColor3"] = t1.value37.Text
				}):Play()
            end
        else
            uDim2 = t1.value16
            TweenInfo_ = Frame
            tweenInfo = TweenInfo.new(0.2)
            uDim2.Create(uDim2, TweenInfo_, tweenInfo, {
				["BackgroundColor3"] = t1.value37.SwitchOff
			}):Play()
            v164.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value37.SwitchOff), ColorSequenceKeypoint.new(1, t1.value37.SwitchOff) })
            uDim2 = t1.value16
            TweenInfo_ = Frame2
            tweenInfo = TweenInfo.new(0.2)
            uDim2.Create(uDim2, TweenInfo_, tweenInfo, {
				["Position"] = uDim22,
				["BackgroundColor3"] = Color3.fromRGB(150, 150, 150)
			}):Play()

            if not attribute then
                uDim2 = t1.value16
                uDim22 = TextLabel
                TweenInfo_ = TweenInfo.new(0.2)
                tweenInfo = t1.value37
                uDim2.Create(uDim2, uDim22, TweenInfo_, {
					["TextColor3"] = tweenInfo.TextDark
				}):Play()
            end
        end

        if not p47 then
            return
        end

        pcall(p46, u159)
    end
    local v171
    v164 = function(p48)
        u159 = p48
        t1.value27[v157] = u159
        v171(true)
    end
    v171 = TextLabel
    TextLabel = function(p49)
        t1.value27[v158] = p49
        ItemHeightOld.Text = p49 == "None" and attribute and "Set Key" or "Key" or p49
    end
    TextButton3.MouseButton1Click:Connect(function()
        u159 = not u159
        t1.value27[v157] = u159
        v171(true)
        if not _G.NexVoidLog then
            return
        end
        task.spawn(function()
            _G.NexVoidLog("Toggle", p43, u159)
        end)
    end)
    v160.MouseButton1Click:Connect(function()
        t1.value27[v158] = "None"
        ItemHeightOld.Text = attribute and "Set Key" or "Key" or "None"
    end)
    ItemHeightOld.MouseButton1Click:Connect(function()
        ItemHeightOld.Text = "..."
        local connection
        connection = t1.value15.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            if input.KeyCode == Enum.KeyCode.Escape and true or input.KeyCode == Enum.KeyCode.Backspace then
                t1.value27[v158] = "None"
                ItemHeightOld.Text = attribute and "Set Key" or "Key" or "None"
            else
                local Name = input.KeyCode.Name

                t1.value27[v158] = Name
                ItemHeightOld.Text = Name == "None" and attribute and "Set Key" or "Key" or Name
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
        local v174 = t1.value27[v158]
        if v174 then
            if v174 == "None" then
                v174 = false
            else
                v174 = input.KeyCode.Name == v174
            end
        end
        if not v174 then
            return
        end
        u159 = not u159
        t1.value27[v157] = u159
        v171(true)
        if not _G.NexVoidLog then
            return
        end
        task.spawn(function()
            _G.NexVoidLog("Toggle", p43 .. " (Keybind)", u159)
        end)
    end)
    t1.value69.Registry[v157] = {
		["Type"] = "ToggleKeybindState",
		["Set"] = v164,
		["Default"] = p44 or false
	}
    t1.value69.Registry[v158] = {
		["Type"] = "ToggleKeybindKey",
		["Set"] = TextLabel,
		["Default"] = p45 or "None"
	}
    if not u159 then
        v171(false)

        return {
			["Set"] = v164
		}
    end
    task.spawn(function()
        pcall(p46, u159)
    end)
    v171(false)

    return {
		["Set"] = v164
	}
end
function t1.value69.CreateSlider(_, p50, p51, p52, p53, p54, p55)
    local attribute = p50:GetAttribute("OldStyle")
    local TextLabel = t1.value73(p50)

    if attribute then
        v239 = t1.value36.ItemHeightOld
    else
        v239 = attribute
    end

    local v239_ = v239 or t1.value36.ItemHeightNew + 5
    local v178 = p50.Name .. "_" .. p51
    local u179 = t1.value27[v178]

    if u179 == nil then
        u179 = p54
    end

    u179 = math.clamp(u179, p52, p53)
    t1.value27[v178] = u179

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, attribute and -2 or 0, 0, v239_)
    Frame.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    Frame.Parent = TextLabel
    TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p51
    TextLabel:SetAttribute("OriginalText", p51)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextSize = 11
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    v239_ = Instance.new("UITextSizeConstraint", TextLabel)
    v239_.MinTextSize = 7
    TextLabel.Parent = Frame

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(0, 40, 0, 20)
    TextLabel2.AnchorPoint = Vector2.new(1, 0)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = tostring(u179)
    TextLabel2.Font = t1.value37.Font
    TextLabel2.TextSize = 11
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel2.Parent = Frame

    if attribute then
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.45
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local UIStroke = Instance.new("UIStroke", Frame)

        UIStroke.Color = Color3.fromRGB(40, 40, 40)
        UIStroke.Thickness = 1
        TextLabel.Size = UDim2.new(1, -45, 0, 20)
        TextLabel.Position = UDim2.new(0, 10, 0, 2)
        v239_.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
        TextLabel2.Position = UDim2.new(1, -10, 0, 2)
        TextLabel2.TextColor3 = t1.value37.TextDark
    else
        Frame.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -45, 0, 20)
        TextLabel.Position = UDim2.new(0, 5, 0, 2)
        v239_.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
        TextLabel2.Position = UDim2.new(1, -5, 0, 2)
        TextLabel2.TextColor3 = t1.value37.Text
    end

    TextLabel = Instance.new("Frame")
    TextLabel.Size = attribute and UDim2.new(1, -20, 0, 8) or UDim2.new(1, -10, 0, 8)
    TextLabel.Position = attribute and UDim2.new(0, 10, 0, 25) or UDim2.new(0, 5, 0, 25)
    TextLabel.BackgroundColor3 = t1.value37.SwitchOff
    TextLabel.BorderSizePixel = 0
    TextLabel.Parent = Frame
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(1, 0)
    attribute = Instance.new("Frame")
    attribute.Size = UDim2.new((u179 - p52) / (p53 - p52), 0, 1, 0)
    attribute.BackgroundColor3 = t1.value37.Accent
    attribute.BorderSizePixel = 0
    attribute.Parent = TextLabel
    Instance.new("UICorner", attribute).CornerRadius = UDim.new(1, 0)
    value32(attribute, t1.value37.Accent, t1.value37.AccentDark, 0)
    v239_ = Instance.new("TextButton")
    v239_.Size = UDim2.new(1, 0, 1, 0)
    v239_.BackgroundTransparency = 1
    v239_.Text = ""
    v239_.Parent = TextLabel

    local u183 = false

    attribute = function(p56)
        u179 = math.clamp(p56, p52, p53)
        local v184 = (u179 - p52) / (p53 - p52)
        t1.value16:Create(attribute, TweenInfo.new(0.2), {
			["Size"] = UDim2.new(v184, 0, 1, 0)
		}):Play()
        TextLabel2.Text = tostring(u179)
        t1.value27[v178] = u179
        pcall(p55, u179)
    end
    TextLabel = function(p57)
        local v186 = p52
        local v187 = p53 - p52
        local uDim2New = UDim2.new
        local v189 = (p57.Position.X - TextLabel.AbsolutePosition.X) / TextLabel.AbsoluteSize.X

        v186 = v186 + v187 * uDim2New(math.clamp(v189, 0, 1), 0, 1, 0).X.Scale
        attribute((math.floor(v186)))
    end
    Frame = function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u183 = true
        TextLabel(input)
    end
    v239_.InputBegan:Connect(Frame)
    t1.value15.InputEnded:Connect(function(input)
        if not ((input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) and u183) then
            return
        end

        u183 = false

        if not _G.NexVoidLog then
            return
        end

        task.spawn(function()
            _G.NexVoidLog("Slider", p51, u179)
        end)
    end)
    t1.value15.InputChanged:Connect(function(input)
        if not (u183 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        TextLabel(input)
    end)
    t1.value69.Registry[v178] = {
		["Type"] = "Slider",
		["Set"] = attribute,
		["Default"] = p54
	}
    task.spawn(function()
        pcall(p55, u179)
    end)

    return {
		["Set"] = attribute
	}
end
function t1.value69.CreateInput(_, p58, p59, p60, p61)
    local attribute = p58:GetAttribute("OldStyle")
    local TextLabel = t1.value73(p58)

    if attribute then
        v263 = t1.value36.ItemHeightOld
    else
        v263 = attribute
    end

    local v263_ = v263 or t1.value36.ItemHeightNew
    local v193 = p58.Name .. "_" .. p59
    local u194 = t1.value27[v193]

    if u194 == nil then
        u194 = p60
    end

    t1.value27[v193] = u194

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, attribute and -2 or 0, 0, v263_)
    Frame.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    Frame.Parent = TextLabel
    TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p59
    TextLabel:SetAttribute("OriginalText", p59)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    v263_ = Instance.new("UITextSizeConstraint", TextLabel)
    v263_.MinTextSize = 7
    TextLabel.Parent = Frame

    local TextBox = Instance.new("TextBox")

    TextBox.BackgroundColor3 = t1.value37.SwitchOff
    TextBox.Text = tostring(u194)
    TextBox.TextColor3 = t1.value37.Text
    TextBox.Font = t1.value37.Font
    TextBox.TextSize = 12
    TextBox.TextScaled = false
    TextBox.ClipsDescendants = true
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

    local v197 = t1.value72[p58]

    if attribute then
        if v197 then
            Frame.BackgroundTransparency = 1
            TextBox.BackgroundColor3 = Color3.new(0, 0, 0)
            TextBox.BackgroundTransparency = 0.45
            attribute = Instance.new("UIStroke", TextBox)
            attribute.Color = Color3.fromRGB(40, 40, 40)
            attribute.Thickness = 1
        else
            Frame.BackgroundColor3 = Color3.new(0, 0, 0)
            Frame.BackgroundTransparency = 0.45
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            attribute = Instance.new("UIStroke", Frame)
            attribute.Color = Color3.fromRGB(40, 40, 40)
            attribute.Thickness = 1
        end

        TextLabel.Size = UDim2.new(1, -90, 1, 0)
        TextLabel.Position = UDim2.new(0, 10, 0, 0)
        v263_.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
        TextBox.Size = UDim2.new(0, 70, 0, 26)
        TextBox.Position = UDim2.new(1, -80, 0.5, -13)
    else
        Frame.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -75, 1, 0)
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        v263_.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
        TextBox.Size = UDim2.new(0, 60, 0, 24)
        TextBox.Position = UDim2.new(1, -65, 0.5, -12)
    end

    attribute = function(p62)
        u194 = p62
        TextBox.Text = tostring(p62)
        t1.value27[v193] = p62
        pcall(p61, p62)
    end
    TextBox.FocusLost:Connect(function()
        local Text = TextBox.Text

        Text = tonumber(Text) or (TextBox.Text ~= "" and TextBox.Text or u194)
        u194 = Text
        TextBox.Text = tostring(Text)
        t1.value27[v193] = Text
        pcall(p61, Text)

        if not _G.NexVoidLog then
            return
        end

        task.spawn(function()
            local v199 = Text

            _G.NexVoidLog("Input", p59, (tostring(v199)))
        end)
    end)
    t1.value69.Registry[v193] = {
		["Type"] = "Input",
		["Set"] = attribute,
		["Default"] = p60
	}
    task.spawn(function()
        pcall(p61, u194)
    end)

    return {
		["Set"] = attribute
	}
end
function t1.value69.CreateDropdown(_, p63, p64, p65, p66, p67)
    local v200 = p63:GetAttribute("OldStyle")
    local TextButton3 = t1.value73(p63)
    local ItemHeightOld = v200 and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
    local v203 = p63.Name .. "_" .. p64
    local u204 = t1.value27[v203] or (p66 or p65[1])

    t1.value27[v203] = u204

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, v200 and -2 or 0, 0, ItemHeightOld)
    Frame.Position = UDim2.new(0, v200 and 1 or 0, 0, 0)
    Frame.ClipsDescendants = true
    Frame.Parent = TextButton3
    TextButton3 = Instance.new("TextButton")
    TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
    TextButton3.BackgroundTransparency = 1
    TextButton3.Text = ""
    TextButton3.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p64 .. ": " .. tostring(u204)
    TextLabel:SetAttribute("OriginalText", p64)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    UITextSizeConstraint.MinTextSize = 7
    TextLabel.Parent = TextButton3

    local UIStroke = t1.value72[p63]

    if v200 then
        if UIStroke then
            Frame.BackgroundTransparency = 1
        else
            Frame.BackgroundColor3 = Color3.new(0, 0, 0)
            Frame.BackgroundTransparency = 0.45
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            UIStroke = Instance.new("UIStroke", Frame)
            UIStroke.Color = Color3.fromRGB(40, 40, 40)
            UIStroke.Thickness = 1
        end

        TextLabel.Size = UDim2.new(1, -40, 1, 0)
        TextLabel.Position = UDim2.new(0, 15, 0, 0)
        UITextSizeConstraint.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        Frame.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -25, 1, 0)
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        UITextSizeConstraint.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end

    if not v200 then
        TextButton3.MouseEnter:Connect(function()
            local value16 = t1.value16
            local v210 = TextLabel
            local TweenInfo_ = TweenInfo

            value16.Create(value16, v210, TweenInfo_.new(0.2), {
				["TextColor3"] = t1.value37.Accent
			}):Play()
        end)
        TextButton3.MouseLeave:Connect(function()
            local value16 = t1.value16
            local v213 = TextLabel
            local tweenInfo = TweenInfo.new(0.2)

            value16.Create(value16, v213, tweenInfo, {
				["TextColor3"] = t1.value37.TextDark
			}):Play()
        end)
    end

    UITextSizeConstraint = Instance.new("TextLabel")
    UITextSizeConstraint.Size = UDim2.new(0, 20, 0, 20)
    UITextSizeConstraint.Position = v200 and UDim2.new(1, -30, 0.5, -10) or UDim2.new(1, -20, 0.5, -10)
    UITextSizeConstraint.BackgroundTransparency = 1
    UITextSizeConstraint.Text = "\226\150\188"
    UITextSizeConstraint.TextColor3 = t1.value37.TextDark
    UITextSizeConstraint.Font = Enum.Font.Gotham
    UITextSizeConstraint.TextSize = 12
    UITextSizeConstraint.Parent = TextButton3
    UIStroke = Instance.new("Frame")
    UIStroke.Size = UDim2.new(1, 0, 1, -ItemHeightOld)
    UIStroke.Position = UDim2.new(0, 0, 0, ItemHeightOld)
    UIStroke.BackgroundColor3 = Color3.new(0, 0, 0)
    UIStroke.BackgroundTransparency = 0.45
    UIStroke.BorderSizePixel = 0
    UIStroke.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(0, 2, 1, 0)
    Frame2.Position = UDim2.new(1, -2, 0, 0)
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 5
    Frame2.Parent = UIStroke
    Frame2 = Instance.new("ScrollingFrame")
    Frame2.Size = UDim2.new(1, -4, 1, 0)
    Frame2.Position = UDim2.new(0, 0, 0, 0)
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.ScrollBarThickness = 2
    Frame2.ScrollBarImageColor3 = t1.value37.Accent
    Frame2.CanvasSize = UDim2.new(0, 0, 0, 0)
    Frame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Frame2.Parent = UIStroke
    UIStroke = Instance.new("UIListLayout")
    UIStroke.SortOrder = Enum.SortOrder.LayoutOrder
    UIStroke.Parent = Frame2

    local u216 = false

    TextLabel = function(p68)
        u204 = p68
        t1.value27[v203] = u204

        if TextLabel:GetAttribute("OriginalText") then
            v296 = TextLabel.Text
            TextLabel.Text = string.split(v296, ": ")[1] .. ": " .. tostring(u204)
        else
            v296 = u204
            TextLabel.Text = p64 .. ": " .. tostring(v296)
        end

        local v218 = Frame2

        for _, child in pairs(v218:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text == tostring(p68) then
                    child.TextColor3 = t1.value37.Text
                    child.Font = Enum.Font.GothamBold
                else
                    child.TextColor3 = t1.value37.TextDark
                    child.Font = Enum.Font.Gotham
                end
            end
        end

        pcall(p67, u204)
    end
    TextButton3.MouseButton1Click:Connect(function()
        u216 = not u216

        local v221, v222, value16, value37

        if u216 then
            v221 = v200 and 30 or 26
            v222 = v200 and 180 or 160
            value16 = t1.value16
            value37 = Frame

            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Create = value16.Create
            local uDim2New = UDim2.new
            local v228 = v200 and -2 or 0

            v221 = ItemHeightOld + #p65 * v221
            Create(value16, value37, tweenInfo, {
				["Size"] = uDim2New(1, v228, 0, (math.min(v221, v222)))
			}):Play()
            UITextSizeConstraint.Text = "\226\150\178"
            v221 = t1.value16
            v222 = UITextSizeConstraint
            value16 = TweenInfo.new(0.3)
            value37 = t1.value37
            v221.Create(v221, v222, value16, {
				["TextColor3"] = value37.Accent
			}):Play()

            return
        else
            v221 = t1.value16
            v222 = Frame
            value16 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            value37 = UDim2
            v221.Create(v221, v222, value16, {
				["Size"] = value37.new(1, v200 and -2 or 0, 0, ItemHeightOld)
			}):Play()
            UITextSizeConstraint.Text = "\226\150\188"
            v221 = t1.value16
            v222 = UITextSizeConstraint
            value16 = TweenInfo
            v221.Create(v221, v222, value16.new(0.3), {
				["TextColor3"] = t1.value37.TextDark
			}):Play()

            return
        end
    end)
    v200 = function(p69)
        local TextButton4 = Instance.new("TextButton")

        TextButton4.Size = UDim2.new(1, 0, 0, v200 and 30 or 26)
        TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
        TextButton4.BackgroundTransparency = 1
        TextButton4.Text = tostring(p69)
        TextButton4.TextColor3 = u204 == p69 and t1.value37.Text or t1.value37.TextDark
        TextButton4.Font = u204 == p69 and Enum.Font.GothamBold or Enum.Font.Gotham
        TextButton4.TextSize = 11
        TextButton4.TextXAlignment = Enum.TextXAlignment.Center
        TextButton4.Parent = Frame2

        local Frame3 = Instance.new("Frame")

        Frame3.Size = UDim2.new(1, -20, 0, 1)
        Frame3.Position = UDim2.new(0, 10, 1, -1)
        Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame3.BorderSizePixel = 0
        Frame3.Parent = TextButton4
        TextButton4.MouseEnter:Connect(function()
            if u204 == p69 then
                return
            end

            local value16 = t1.value16
            local v232 = TextButton4
            local tweenInfo = TweenInfo.new(0.2)

            value16.Create(value16, v232, tweenInfo, {
				["TextColor3"] = t1.value37.Text
			}):Play()
        end)
        TextButton4.MouseLeave:Connect(function()
            if u204 == p69 then
                return
            end

            t1.value16:Create(TextButton4, TweenInfo.new(0.2), {
				["TextColor3"] = t1.value37.TextDark
			}):Play()
        end)
        TextButton4.MouseButton1Click:Connect(function()
            TextLabel(p69)

            local value16 = t1.value16
            local v235 = Frame
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local uDim2New = UDim2.new
            local v238 = v200

            value16.Create(value16, v235, tweenInfo, {
				["Size"] = uDim2New(1, v238 and -2 or 0, 0, ItemHeightOld)
			}):Play()
            UITextSizeConstraint.Text = "\226\150\188"
            value16 = t1.value16
            v235 = UITextSizeConstraint
            tweenInfo = TweenInfo.new(0.3)
            uDim2New = t1.value37
            value16.Create(value16, v235, tweenInfo, {
				["TextColor3"] = uDim2New.TextDark
			}):Play()

            if not _G.NexVoidLog then
                return
            end

            task.spawn(function()
                local v240 = p69

                _G.NexVoidLog("Dropdown", p64, (tostring(v240)))
            end)
        end)
    end

    for _, v in ipairs(p65) do
        v200(v)
    end

    t1.value69.Registry[v203] = {
		["Type"] = "Dropdown",
		["Set"] = TextLabel,
		["Default"] = p66 or p65[1]
	}
    task.spawn(function()
        pcall(p67, u204)
    end)

    return {
		["Set"] = TextLabel
	}
end
function t1.value69.CreatePlayerDropdown(_, p70, p71, p72, p73)
    local v242 = p70:GetAttribute("OldStyle")
    local TextButton3 = t1.value73(p70)
    local ItemHeightOld = v242 and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
    local v245 = p70.Name .. "_" .. p71
    local u246 = t1.value27[v245] or (p72 or "Select Player")

    t1.value27[v245] = u246

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, v242 and -2 or 0, 0, ItemHeightOld)
    Frame.Position = UDim2.new(0, v242 and 1 or 0, 0, 0)
    Frame.ClipsDescendants = true
    Frame.Parent = TextButton3
    TextButton3 = Instance.new("TextButton")
    TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
    TextButton3.BackgroundTransparency = 1
    TextButton3.Text = ""
    TextButton3.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p71 .. ": " .. tostring(u246)
    TextLabel:SetAttribute("OriginalText", p71)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    UITextSizeConstraint.MinTextSize = 7
    TextLabel.Parent = TextButton3

    if v242 then
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.45
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
        v_u_340 = Instance.new("UIStroke", Frame)
        v_u_340.Color = Color3.fromRGB(40, 40, 40)
        v_u_340.Thickness = 1
        TextLabel.Size = UDim2.new(1, -40, 1, 0)
        TextLabel.Position = UDim2.new(0, 15, 0, 0)
        UITextSizeConstraint.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        Frame.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -40, 1, 0)
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        UITextSizeConstraint.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end

    if not v242 then
        UITextSizeConstraint = function()
            local value16 = t1.value16
            local v251 = TextLabel
            local TweenInfo_ = TweenInfo

            value16.Create(value16, v251, TweenInfo_.new(0.3), {
				["TextColor3"] = t1.value37.Accent
			}):Play()
        end
        TextButton3.MouseEnter:Connect(UITextSizeConstraint)
        UITextSizeConstraint = function()
            local value16 = t1.value16
            local v254 = TextLabel
            local tweenInfo = TweenInfo.new(0.3)
            local value37 = t1.value37

            value16.Create(value16, v254, tweenInfo, {
				["TextColor3"] = value37.TextDark
			}):Play()
        end
        TextButton3.MouseLeave:Connect(UITextSizeConstraint)
    end

    UITextSizeConstraint = Instance.new("TextLabel")
    UITextSizeConstraint.Size = UDim2.new(0, 20, 0, 20)
    UITextSizeConstraint.Position = v242 and UDim2.new(1, -30, 0.5, -10) or UDim2.new(1, -25, 0.5, -10)
    UITextSizeConstraint.BackgroundTransparency = 1
    UITextSizeConstraint.Text = "\226\150\188"
    UITextSizeConstraint.TextColor3 = t1.value37.TextDark
    UITextSizeConstraint.Font = Enum.Font.Gotham
    UITextSizeConstraint.TextSize = 12
    UITextSizeConstraint.Parent = TextButton3

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, 0, 1, -ItemHeightOld)
    Frame2.Position = UDim2.new(0, 0, 0, ItemHeightOld)
    Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame2.BackgroundTransparency = 0.45
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Size = UDim2.new(0, 2, 1, 0)
    Frame3.Position = UDim2.new(1, -2, 0, 0)
    Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 5
    Frame3.Parent = Frame2
    Frame3 = Instance.new("ScrollingFrame")
    Frame3.Size = UDim2.new(1, -4, 1, 0)
    Frame3.Position = UDim2.new(0, 0, 0, 0)
    Frame3.BackgroundTransparency = 1
    Frame3.BorderSizePixel = 0
    Frame3.ScrollBarThickness = 2
    Frame3.ScrollBarImageColor3 = t1.value37.Accent
    Frame3.CanvasSize = UDim2.new(0, 0, 0, 0)
    Frame3.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Frame3.Parent = Frame2
    Frame2 = Instance.new("UIListLayout")
    Frame2.SortOrder = Enum.SortOrder.LayoutOrder
    Frame2.Parent = Frame3

    local u259 = false

    TextLabel = function(p74)
        u246 = p74
        t1.value27[v245] = u246

        local Text

        if TextLabel:GetAttribute("OriginalText") then
            Text = TextLabel.Text
            TextLabel.Text = string.split(Text, ": ")[1] .. ": " .. tostring(u246)
        else
            Text = u246
            TextLabel.Text = p71 .. ": " .. tostring(Text)
        end

        pcall(p73, u246)
    end
    Frame2 = function(p75)
        local TextButton4 = Instance.new("TextButton")

        TextButton4.Size = UDim2.new(1, 0, 0, v242 and 30 or 26)
        TextButton4.BackgroundColor3 = Color3.new(0, 0, 0)
        TextButton4.BackgroundTransparency = 1
        TextButton4.Text = tostring(p75)
        TextButton4.TextColor3 = u246 == p75 and t1.value37.Text or t1.value37.TextDark
        TextButton4.Font = u246 == p75 and Enum.Font.GothamBold or Enum.Font.Gotham
        TextButton4.TextSize = 11
        TextButton4.TextXAlignment = Enum.TextXAlignment.Center
        TextButton4.Parent = Frame3

        local Frame4 = Instance.new("Frame")

        Frame4.Size = UDim2.new(1, -20, 0, 1)
        Frame4.Position = UDim2.new(0, 10, 1, -1)
        Frame4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame4.BorderSizePixel = 0
        Frame4.Parent = TextButton4
        TextButton4.MouseEnter:Connect(function()
            if u246 == p75 then
                return
            end

            local value16 = t1.value16
            local v265 = TextButton4
            local tweenInfo = TweenInfo.new(0.2)
            local value37 = t1.value37

            value16.Create(value16, v265, tweenInfo, {
				["TextColor3"] = value37.Text
			}):Play()
        end)
        TextButton4.MouseLeave:Connect(function()
            if u246 == p75 then
                return
            end

            local value16 = t1.value16
            local v269 = TextButton4
            local tweenInfo = TweenInfo.new(0.2)

            value16.Create(value16, v269, tweenInfo, {
				["TextColor3"] = t1.value37.TextDark
			}):Play()
        end)
        TextButton4.MouseButton1Click:Connect(function()
            TextLabel(p75)
            u259 = false

            local value16 = t1.value16
            local v272 = Frame
            local tweenInfoNew = TweenInfo.new
            local Enum_ = Enum

            value16.Create(value16, v272, tweenInfoNew(0.3, Enum_.EasingStyle.Quart, Enum.EasingDirection.Out), {
				["Size"] = UDim2.new(1, v242 and -2 or 0, 0, ItemHeightOld)
			}):Play()
            UITextSizeConstraint.Text = "\226\150\188"
            value16 = t1.value16
            v272 = UITextSizeConstraint
            tweenInfoNew = TweenInfo.new(0.3)
            Enum_ = t1.value37
            value16.Create(value16, v272, tweenInfoNew, {
				["TextColor3"] = Enum_.TextDark
			}):Play()

            if not _G.NexVoidLog then
                return
            end

            task.spawn(function()
                local v275 = p75

                _G.NexVoidLog("Dropdown", p71, (tostring(v275)))
            end)
        end)
    end
    TextButton3 = TextButton3.MouseButton1Click
    TextButton3:Connect(function()
        u259 = not u259

        local players, v277, v278, tweenInfo

        if u259 then
            players, v277, v278 = ipairs(Frame3:GetChildren())

            while true do
                v278, tweenInfo = players(v277, v278)

                if not v278 then
                    break
                end

                if tweenInfo:IsA("TextButton") then
                    tweenInfo:Destroy()
                end
            end

            players = t1.value14:GetPlayers()
            v278 = 0

            for _, player in ipairs(players) do
                if player ~= t1.value23 then
                    Frame2(player.Name)
                    v278 = v278 + 1
                end
            end

            players = v242 and 30 or 26
            v277 = v242 and 180 or 160
            v278 = ItemHeightOld + v278 * players
            v277 = math.min(v278, v277)

            if v277 ~= ItemHeightOld then
                players = t1.value16
                v278 = Frame
                tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                v367 = UDim2.new
                v368 = v242
                players.Create(players, v278, tweenInfo, {
					["Size"] = v367(1, v368 and -2 or 0, 0, v277)
				}):Play()
                UITextSizeConstraint.Text = "\226\150\178"
                players = t1.value16
                v277 = UITextSizeConstraint
                v278 = TweenInfo.new(0.3)
                players.Create(players, v277, v278, {
					["TextColor3"] = t1.value37.Accent
				}):Play()

                return
            end

            v277 = ItemHeightOld + players
            players = t1.value16
            v278 = Frame
            tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            local uDim2New = UDim2.new
            local v283 = v242

            players.Create(players, v278, tweenInfo, {
				["Size"] = uDim2New(1, v283 and -2 or 0, 0, v277)
			}):Play()
            UITextSizeConstraint.Text = "\226\150\178"
            players = t1.value16
            v277 = UITextSizeConstraint
            v278 = TweenInfo.new(0.3)
            players.Create(players, v277, v278, {
				["TextColor3"] = t1.value37.Accent
			}):Play()

            return
        else
            players = t1.value16
            v277 = Frame
            v278 = TweenInfo.new
            tweenInfo = Enum.EasingStyle
            players.Create(players, v277, v278(0.3, tweenInfo.Quart, Enum.EasingDirection.Out), {
				["Size"] = UDim2.new(1, v242 and -2 or 0, 0, ItemHeightOld)
			}):Play()
            UITextSizeConstraint.Text = "\226\150\188"
            t1.value16:Create(UITextSizeConstraint, TweenInfo.new(0.3), {
				["TextColor3"] = t1.value37.TextDark
			}):Play()

            return
        end
    end)
    t1.value69.Registry[v245] = {
		["Type"] = "PlayerDropdown",
		["Set"] = TextLabel,
		["Default"] = p72 or "Select Player"
	}
    task.spawn(function()
        pcall(p73, u246)
    end)

    return {
		["Set"] = TextLabel
	}
end
function t1.value69.CreateColorPicker(_, p76, p77, p78, p79)
    local attribute = p76:GetAttribute("OldStyle")
    local TextButton3 = t1.value73(p76)
    local ItemHeightOld = attribute and t1.value36.ItemHeightOld or t1.value36.ItemHeightNew
    local v287 = p76.Name .. "_" .. p77
    local color3 = t1.value27[v287]
    if color3 then
        if type(color3) == "string" then
            color3 = Color3.fromHex(color3)
        end
    else
        color3 = p78
    end
    t1.value27[v287] = color3:ToHex()
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)
    Frame.Position = UDim2.new(0, attribute and 1 or 0, 0, 0)
    Frame.ClipsDescendants = true
    Frame.Parent = TextButton3
    TextButton3 = Instance.new("TextButton")
    TextButton3.Size = UDim2.new(1, 0, 0, ItemHeightOld)
    TextButton3.BackgroundTransparency = 1
    TextButton3.Text = ""
    TextButton3.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p77
    TextLabel:SetAttribute("OriginalText", p77)
    TextLabel.Font = t1.value37.Font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
    UITextSizeConstraint.MinTextSize = 7
    TextLabel.Parent = TextButton3
    if attribute then
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.45
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
        v_u_385 = Instance.new("UIStroke", Frame)
        v_u_385.Color = Color3.fromRGB(40, 40, 40)
        v_u_385.Thickness = 1
        TextLabel.Size = UDim2.new(1, -40, 1, 0)
        TextLabel.Position = UDim2.new(0, 10, 0, 0)
        UITextSizeConstraint.MaxTextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
    else
        Frame.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -40, 1, 0)
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        UITextSizeConstraint.MaxTextSize = 11
        TextLabel.TextColor3 = t1.value37.TextDark
    end
    if not attribute then
        TextButton3.MouseEnter:Connect(function()
            local value16 = t1.value16
            local v293 = TextLabel
            local tweenInfo = TweenInfo.new(0.3)
            local value37 = t1.value37

            value16.Create(value16, v293, tweenInfo, {
				["TextColor3"] = value37.Accent
			}):Play()
        end)
        TextLabel = function()
            t1.value16:Create(TextLabel, TweenInfo.new(0.3), {
				["TextColor3"] = t1.value37.TextDark
			}):Play()
        end
        TextButton3.MouseLeave:Connect(TextLabel)
    end
    TextLabel = Instance.new("Frame")
    TextLabel.Size = attribute and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 24, 0, 20)
    TextLabel.Position = attribute and UDim2.new(1, -34, 0.5, -12) or UDim2.new(1, -29, 0.5, -10)
    TextLabel.BackgroundColor3 = color3
    TextLabel.Parent = TextButton3
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 4)
    UITextSizeConstraint = Instance.new("Frame")
    UITextSizeConstraint.Size = UDim2.new(1, 0, 0, 110)
    UITextSizeConstraint.Position = UDim2.new(0, 0, 0, ItemHeightOld)
    UITextSizeConstraint.BackgroundTransparency = 1
    UITextSizeConstraint.Parent = Frame
    local ImageButton = Instance.new("ImageButton")
    ImageButton.Size = attribute and UDim2.new(0, 150, 0, 90) or UDim2.new(0, 140, 0, 90)
    ImageButton.Position = UDim2.new(0, 10, 0, 10)
    ImageButton.AutoButtonColor = false
    ImageButton.Parent = UITextSizeConstraint
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://4155801252"
    ImageLabel.Parent = ImageButton
    ImageLabel = Instance.new("Frame")
    ImageLabel.Size = UDim2.new(0, 6, 0, 6)
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Parent = ImageButton
    Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
    local ImageButton2 = Instance.new("ImageButton")
    ImageButton2.Size = UDim2.new(0, 20, 0, 90)
    ImageButton2.Position = attribute and UDim2.new(0, 170, 0, 10) or UDim2.new(0, 160, 0, 10)
    ImageButton2.AutoButtonColor = false
    ImageButton2.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageButton2.Parent = UITextSizeConstraint
    UITextSizeConstraint = Instance.new("UIGradient")
    UITextSizeConstraint.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	})
    UITextSizeConstraint.Rotation = 90
    UITextSizeConstraint.Parent = ImageButton2
    UITextSizeConstraint = Instance.new("Frame")
    UITextSizeConstraint.Size = UDim2.new(1, 0, 0, 2)
    UITextSizeConstraint.BackgroundColor3 = Color3.new(1, 1, 1)
    UITextSizeConstraint.AnchorPoint = Vector2.new(0, 0.5)
    UITextSizeConstraint.Parent = ImageButton2
    local v299, v300, v301 = color3:ToHSV()
    local v398_ = v299
    local v399_ = v300
    local v400_ = v301
    v299 = function()
        local color32 = Color3.fromHSV(v398_, v399_, v400_)

        color3 = color32
        TextLabel.BackgroundColor3 = color32
        ImageButton.BackgroundColor3 = Color3.fromHSV(v398_, 1, 1)
        t1.value27[v287] = color32:ToHex()
        pcall(p79, color32)
    end
    local u306 = false
    local u307 = false
    TextLabel = function(p80)
        if type(p80) ~= "string" then
            color3 = p80
            TextLabel.BackgroundColor3 = p80
            ImageButton.BackgroundColor3 = Color3.fromHSV(p80:ToHSV())
            v398, v399, v400 = p80:ToHSV()
            v398_ = v398
            v399_ = v399
            v400_ = v400
            v398 = UITextSizeConstraint
            v399 = UDim2.new
            v400 = 1 - v398_
            v398.Position = v399(0, 0, math.clamp(v400, 0, 1), 0)
            v398 = ImageLabel
            v399 = UDim2.new
            v400 = v399_
            v400 = math.clamp(v400, 0, 1)
            v401 = 1 - v400_
            v398.Position = v399(v400, 0, math.clamp(v401, 0, 1), 0)
            v398 = p80.ToHex
            t1.value27[v287] = v398(p80)
            pcall(p79, p80)

            return
        end

        p80 = Color3.fromHex(p80)
        color3 = p80
        TextLabel.BackgroundColor3 = p80
        ImageButton.BackgroundColor3 = Color3.fromHSV(p80:ToHSV())

        local ToHex, uDim2New, v310 = p80:ToHSV()

        v398_ = ToHex
        v399_ = uDim2New
        v400_ = v310
        ToHex = UITextSizeConstraint
        uDim2New = UDim2.new
        v310 = 1 - v398_
        ToHex.Position = uDim2New(0, 0, math.clamp(v310, 0, 1), 0)
        ToHex = ImageLabel
        uDim2New = UDim2.new
        v310 = v399_
        v310 = math.clamp(v310, 0, 1)

        local v311 = 1 - v400_

        ToHex.Position = uDim2New(v310, 0, math.clamp(v311, 0, 1), 0)
        ToHex = p80.ToHex
        t1.value27[v287] = ToHex(p80)
        pcall(p79, p80)
    end
    UITextSizeConstraint = function()
        local v312 = UITextSizeConstraint
        local uDim2New = UDim2.new
        local v314 = 1 - v398_

        v312.Position = uDim2New(0, 0, math.clamp(v314, 0, 1), 0)
        v312 = ImageLabel
        uDim2New = UDim2.new
        v314 = v399_
        v314 = math.clamp(v314, 0, 1)

        local v315 = 1 - v400_

        v312.Position = uDim2New(v314, 0, math.clamp(v315, 0, 1), 0)
        v299()
    end
    local v316
    ImageLabel = function(p81)
        local v317 = (p81.Position.Y - ImageButton2.AbsolutePosition.Y) / ImageButton2.AbsoluteSize.Y

        v317 = 1 - math.clamp(v317, 0, 1)
        v316()
    end
    v316 = UITextSizeConstraint
    v316()
    ImageButton.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u306 = true

        local isScrollingFrame = p76

        if isScrollingFrame then
            isScrollingFrame = p76:IsA("ScrollingFrame")
        end

        if isScrollingFrame then
            p76.ScrollingEnabled = false
        end

        isScrollingFrame = (input.Position.X - ImageButton.AbsolutePosition.X) / ImageButton.AbsoluteSize.X
        math.clamp(isScrollingFrame, 0, 1)
        isScrollingFrame = (input.Position.Y - ImageButton.AbsolutePosition.Y) / ImageButton.AbsoluteSize.Y
        isScrollingFrame = 1 - math.clamp(isScrollingFrame, 0, 1)
        v316()
    end)
    ImageButton2.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u307 = true

        local isScrollingFrame = p76

        if isScrollingFrame then
            isScrollingFrame = p76:IsA("ScrollingFrame")
        end

        if isScrollingFrame then
            p76.ScrollingEnabled = false
        end

        ImageLabel(input)
    end)
    t1.value15.InputEnded:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        if (u306 or u307) and _G.NexVoidLog then
            task.spawn(function()
                _G.NexVoidLog("Input", p77, "#" .. color3:ToHex())
            end)
        end

        u306 = false
        u307 = false

        local isScrollingFrame = p76

        if isScrollingFrame then
            isScrollingFrame = p76:IsA("ScrollingFrame")
        end

        if not isScrollingFrame then
            return
        end

        p76.ScrollingEnabled = true
    end)
    t1.value15.InputChanged:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        if u306 then
            local v321 = (input.Position.X - ImageButton.AbsolutePosition.X) / ImageButton.AbsoluteSize.X

            math.clamp(v321, 0, 1)
            v321 = (input.Position.Y - ImageButton.AbsolutePosition.Y) / ImageButton.AbsoluteSize.Y
            v321 = 1 - math.clamp(v321, 0, 1)
            v316()

            return
        end

        if not u307 then
            return
        end

        ImageLabel(input)
    end)
    local u322 = false
    TextButton3.MouseButton1Click:Connect(function()
        u322 = not u322

        if u322 then
            Frame.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld + 110)

            return
        else
            Frame.Size = UDim2.new(1, attribute and -2 or 0, 0, ItemHeightOld)

            return
        end
    end)
    t1.value69.Registry[v287] = {
		["Type"] = "ColorPicker",
		["Set"] = TextLabel,
		["Default"] = p78
	}
    task.spawn(function()
        pcall(p79, color3)
    end)

    return {
		["Set"] = TextLabel
	}
end
TextButton2 = parent("89172331085803", "Highlight")
parent("16475825226", "Visual", function(p82)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Visual2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p82,
		["Workspace"] = t1.value22,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["RunService"] = t1.value17,
		["CoreGui"] = t1.value19,
		["Theme"] = t1.value37,
		["UserConfigs"] = t1.value27,
		["SendNotification"] = t1.value31,
		["isMobile"] = t1.value34
	})
end)
parent("117215481109731", "Progress", function(p83)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Progress2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p83,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["Workspace"] = t1.value22,
		["CoreGui"] = t1.value19,
		["ReplicatedStorage"] = t1.value21,
		["RunService"] = t1.value17,
		["TweenService"] = t1.value16,
		["Theme"] = t1.value37,
		["SendNotification"] = t1.value31
	})
end)
parent("12623720992", "Textures", function(p84)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Textures2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p84,
		["Workspace"] = t1.value22,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["RunService"] = t1.value17,
		["TweenService"] = t1.value16,
		["UserInputService"] = t1.value15,
		["Theme"] = t1.value37,
		["UserConfigs"] = t1.value27,
		["GetParentTarget"] = t1.value73,
		["isMobile"] = t1.value34,
		["ContentConfig"] = t1.value36,
		["UpdateCursorSizes"] = UserInputService,
		["SetPCCursorActive"] = t1.value43,
		["MobileCrosshair"] = t1.value41,
		["PCSoftwareCursor"] = t1.value42
	})
end)
parent("12684119225", "Auto Farm", function(p85)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Autofarm2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p85,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["Workspace"] = t1.value22,
		["ReplicatedStorage"] = t1.value21,
		["SendNotification"] = t1.value31
	})
end)
parent("106546587226077", "Fog", function(p86)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Fog2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p86,
		["Lighting"] = t1.value20,
		["RunService"] = t1.value17,
		["SendNotification"] = t1.value31
	})
end)
parent("13288142767", "Sounds", function(p87)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Sounds2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p87,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["Workspace"] = t1.value22,
		["TweenService"] = t1.value16,
		["Theme"] = t1.value37,
		["UserConfigs"] = t1.value27,
		["GetParentTarget"] = t1.value73
	})
end, true)
parent("7485051715", "Advanced", function(p88)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Advanced2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p88,
		["Workspace"] = t1.value22,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["RunService"] = t1.value17,
		["UserInputService"] = t1.value15,
		["ReplicatedStorage"] = t1.value21,
		["CoreGui"] = t1.value19
	})
end)
parent("11656483170", "Visual Skins", function(p89)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/VisualSkins2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p89,
		["Workspace"] = t1.value22,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["RunService"] = t1.value17,
		["TweenService"] = t1.value16,
		["Theme"] = t1.value37,
		["SendNotification"] = t1.value31,
		["ModalOverlay"] = t1.value60,
		["ApplyGradient"] = value32
	})
end, true)
parent("12689978575", "Teleport", function(p90)
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/1D4vid/Nex2.8/refs/heads/main/Teleport2.8")
    end)

    if not (ok and result) then
        return
    end

    loadstring(result)()({
		["Library"] = t1.value69,
		["Page"] = p90,
		["Workspace"] = t1.value22,
		["Players"] = t1.value14,
		["LocalPlayer"] = t1.value23,
		["ScreenGui"] = t1.value33,
		["SendNotification"] = t1.value31,
		["UserInputService"] = t1.value15
	})
end)
UserInputService = parent("11293977610", "Settings", nil, true)
t1.value75 = {
	["Hammer"] = true,
	["Gemstone Hammer"] = true,
	["Iron Hammer"] = true,
	["Mallet"] = true
}
t1.value76 = t1.value34 and 10 or 14
function t1.value77(p91)
    if not p91 then
        return false
    end

    local Character = p91.Character

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

    Character = p91:FindFirstChild("Backpack")

    if Character then
        for k in pairs(t1.value75) do
            if Character:FindFirstChild(k) then
                return true
            end
        end
    end

    Character = p91.Team

    if not Character then
        return Character and true or false
    end

    Character = p91.Team.Name == "Beast"

    return Character and true or false
end
t1.value78 = nil
t1.value79 = nil
t1.value80 = setmetatable({}, {
	["__mode"] = "k"
})
function t1.value81(p92)
    if p92 then
        return (p92:FindFirstChildOfClass("Tool") or p92:FindFirstChild("Hammer")) and true or false
    else
        return false
    end
end
function t1.value82(p93)
    if p93 == t1.value23 then
        return
    end

    local Highlight = Instance.new("Highlight")

    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    if not pcall(function()
        Highlight.Parent = t1.value19
    end) then
        local function v345()
            Highlight.Parent = t1.value23:WaitForChild("PlayerGui")
        end

        pcall(v345)
    end

    t1.value80[p93] = Highlight
    p93.CharacterAdded:Connect(function(character)
        Highlight.Adornee = character
    end)

    if not p93.Character then
        return
    end

    Highlight.Adornee = p93.Character
end
t1.value83 = false
t1.value84 = "Torso"
t1.value85 = {}
t1.value86 = nil
function t1.value87(p94)
    return p94 and p94:FindFirstChild("HumanoidRootPart") or (p94:FindFirstChild("Torso") or p94:FindFirstChild("UpperTorso"))
end
function t1.value88(p95)
    if p95 then
        p95 = p95:FindFirstChildOfClass("Humanoid")
    end

    if not p95 then
        return p95
    end

    p95 = p95.Health > 0

    return p95
end
function t1.value89(p96)
    t1.value83 = p96

    if p96 then

        for v348, v349 in ipairs(t1.value14:GetPlayers()) do

            local v350

            if v349 == t1.value23 then
                v350 = false
            else
                v350 = not t1.value85[v349]
            end

            if v350 then
                v350 = Drawing.new("Line")
                v350.Thickness = t1.value38.TracerThickness
                v350.Transparency = 1
                v350.Visible = false
                t1.value85[v349] = v350
            end
        end
        if t1.value86 then
            return
        end

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
value32 = t1.value14.PlayerRemoving
value32:Connect(function(p97)
    if not t1.value85[p97] then
        return
    end

    t1.value85[p97]:Remove()
    t1.value85[p97] = nil
end)
t1.value90 = {}
t1.value91 = setmetatable({}, {
	["__mode"] = "v"
})
t1.value92 = false
t1.value93 = false
t1.value94 = false
t1.value95 = false
t1.value96 = {}
t1.value97 = {}
t1.value98 = {
	["R6"] = {
		{ "Head", "Torso" },
		{ "Torso", "Left Arm" },
		{ "Torso", "Right Arm" },
		{ "Torso", "Left Leg" },
		{ "Torso", "Right Leg" }
	},
	["R15"] = {
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
function t1.value99(p98)
    local v354 = t1.value96[p98]

    if not v354 then
        return
    end

    for _, v in ipairs(v354) do
        v.Visible = false
        v:Remove()
    end

    t1.value96[p98] = nil
end
function t1.value100(p99)
    local v357 = t1.value97[p99]

    if not v357 then
        return
    end

    for _, v in ipairs(v357) do
        v.Visible = false
        v:Remove()
    end

    t1.value97[p99] = nil
end
function t1.value101(p100, p101)
    local Head = p101:FindFirstChild("Head")

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
        Head = Instance.new("TextLabel")
        Head.Name = "Label"
        Head.Size = UDim2.new(1, 0, 1, 0)
        Head.BackgroundTransparency = 1
        Head.Font = t1.value37.Font
        Head.TextSize = t1.value76
        Head.TextStrokeTransparency = 0
        Head.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        Head.Parent = NameESP
    end

    NameESP.Enabled = not t1.value38.HideNames
    Head = NameESP.Enabled and NameESP:FindFirstChild("Label")

    if not Head then
        return
    end

    Head.Text = p100.Name
    Head.TextColor3 = t1.value77(p100) and t1.value38.Beast or t1.value38.Survivor
end
function t1.value102(p102)
    if not p102 then
        return
    end

    local RoleESP = p102:FindFirstChild("RoleESP")

    if RoleESP then
        RoleESP:Destroy()
    end

    RoleESP = p102:FindFirstChild("Head")

    local NameESP

    if RoleESP then
        NameESP = RoleESP:FindFirstChild("NameESP")
    else
        NameESP = RoleESP
    end

    if not NameESP then
        return
    end

    RoleESP.NameESP:Destroy()
end
function t1.value103(p103)
    if p103 == t1.value23 then
        return
    end

    local Character = p103.Character

    if not Character then
        return
    end

    if not t1.value92 then
        t1.value102(Character)

        return
    end

    local Beast = t1.value77(p103)
    local OnlyBeast = t1.value38.OnlyBeast

    if OnlyBeast then
        OnlyBeast = not Beast
    end

    if OnlyBeast then
        t1.value102(Character)

        return
    end

    OnlyBeast = Character:FindFirstChild("RoleESP")

    if not OnlyBeast then
        OnlyBeast = Instance.new("Highlight")
        OnlyBeast.Name = "RoleESP"
        OnlyBeast.Adornee = Character
        OnlyBeast.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        OnlyBeast.Parent = Character
    end

    OnlyBeast.OutlineColor = Beast and t1.value38.OutlineBeast or t1.value38.OutlineSurvivor
    OnlyBeast.OutlineTransparency = 0
    OnlyBeast.FillTransparency = 0.5

    local s2 = "FillColor"

    if not Beast then
        OnlyBeast[s2] = Beast or t1.value38.Survivor
        t1.value101(p103, Character)

        return
    end

    Beast = t1.value38.Beast
    OnlyBeast[s2] = Beast or t1.value38.Survivor
    t1.value101(p103, Character)
end
function t1.value104(p104)
    if p104 == t1.value23 then
        return
    end

    local Character = t1.value32:FindFirstChild(p104.Name .. "_CharmsESP")

    if Character then
        Character:Destroy()
    end

    if not (t1.value93 and p104.Character) then
        return
    end

    Character = p104.Character

    local Humanoid = t1.value87(Character)

    if Humanoid then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
    end

    if not Humanoid then
        return
    end

    Humanoid = Instance.new("Folder")
    Humanoid.Name = p104.Name .. "_CharmsESP"
    Humanoid.Parent = t1.value32

    local Beast = t1.value77(p104) and t1.value38.Beast or t1.value38.Survivor

    for _, child in pairs(Character:GetChildren()) do
        if child:IsA("BasePart") then
            local BoxHandleAdornment = Instance.new("BoxHandleAdornment")

            BoxHandleAdornment.Name = p104.Name
            BoxHandleAdornment.Parent = Humanoid
            BoxHandleAdornment.Adornee = child
            BoxHandleAdornment.AlwaysOnTop = true
            BoxHandleAdornment.ZIndex = 10
            BoxHandleAdornment.Size = child.Size
            BoxHandleAdornment.Transparency = 0.3
            BoxHandleAdornment.Color3 = Beast
        end
    end
end
Minimize = function(player)
    if player == t1.value23 then
        return
    end

    local function v374(character)
        task.wait(0.2)

        if character then
            v497 = character.Parent
        else
            v497 = character
        end

        if not v497 then
            return
        end

        t1.value103(player)

        if t1.value93 then
            t1.value104(player)
        end

        local function v375(child)
            if not (child.Name == "BeastPowers" and true or child.Name == "Hammer") then
                return
            end

            task.wait(0.1)
            t1.value103(player)
        end

        character.ChildAdded:Connect(v375)
        character.ChildRemoved:Connect(function(child)
            if not (child.Name == "BeastPowers" and true or child.Name == "Hammer") then
                return
            end

            task.wait(0.1)
            t1.value103(player)
        end)
    end

    player.CharacterAdded:Connect(v374)

    if not player.Character then
        return
    end

    v374(player.Character)
end
Info = function()
    local ipairs_ = ipairs
    local value14 = t1.value14

    for _, player in ipairs_(value14:GetPlayers()) do
        if player ~= t1.value23 then
            pcall(t1.value103, player)
        end
    end
end
for _, player in ipairs(t1.value14:GetPlayers()) do
    Minimize(player)
end
t1.value14.PlayerAdded:Connect(Minimize)
t1.value17.RenderStepped:Connect(function()
    if not (t1.value95 or t1.value94) then
        return
    end
end)
t1.value14.PlayerRemoving:Connect(function(player)
    t1.value99(player)
    t1.value100(player)

    local v382 = t1.value32:FindFirstChild(player.Name .. "_CharmsESP")

    if not v382 then
        return
    end

    v382:Destroy()
end)
t1.value69:CreateSection(TextButton2, "ESP Features", "Left")
t1.value69:CreateToggle(TextButton2, "Esp Players", false, function(p105)
    t1.value92 = p105
    Info()
end)
t1.value69:CreateToggle(TextButton2, "Esp outline", false, function(p106)
    if p106 then
        local ipairs_ = ipairs
        local value14 = t1.value14

        for _, player in ipairs_(value14:GetPlayers()) do
            t1.value82(player)
        end

        t1.value79 = t1.value14.PlayerAdded:Connect(function(player)
            t1.value82(player)
        end)
        t1.value78 = task.spawn(function()
            while true do
                local v387 = p106

                if v387 then
                    v387 = task.wait(0.3)
                end

                if not v387 then
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
t1.value69:CreateToggle(TextButton2, "Beast Highlight", false, function(p107)
    if not p107 then
        for _, v in ipairs(t1.value90) do
            if v then
                v:Disconnect()
            end
        end

        table.clear(t1.value90)

        local pairs_, value14, v402 = pairs(t1.value91)
        local Character

        while true do
            v402, Character = pairs_(value14, v402)

            if not v402 then
                break
            end

            local Parent

            if Character then
                Parent = Character.Parent
            else
                Parent = Character
            end

            if Parent then
                Character:Destroy()
            end
        end

        table.clear(t1.value91)
        pairs_ = pairs
        value14 = t1.value14

        for _, player in pairs_(value14:GetPlayers()) do
            Character = player.Character

            if Character then
                Character = player.Character:FindFirstChild("Head")
            end

            if Character then
                player = player.Character.Head:FindFirstChild("BeastGlow")

                if player then
                    player:Destroy()
                end
            end
        end

        return
    end
end)
t1.value105 = nil
function t1.value106()
    local ipairs_ = ipairs
    local workspace_ = workspace

    for _, descendant in ipairs_(workspace_:GetDescendants()) do
        if descendant.Name == "CompESP" then
            descendant:Destroy()
        end
    end
end
value32 = t1.value69
value32:CreateToggle(TextButton2, "Esp Computers", false, function(p108)
    if p108 then
        local color3 = Color3.fromRGB(0, 170, 255)
        local color32 = Color3.fromRGB(0, 255, 0)
        local color33 = Color3.fromRGB(255, 0, 0)

        color3 = function(descendant, p109)
            local Color = descendant.Color
            local v411

            if Color.R > Color.G then
                v411 = Color.R > Color.B
            else
                v411 = false
            end

            if v411 then
                p109.FillColor = color33
            else
                if Color.G > Color.B then
                    Color = Color.G > Color.R
                else
                    Color = false
                end

                if Color then
                    p109.FillColor = color32
                else
                    p109.FillColor = color3
                end
            end

            p109.OutlineColor = t1.value38.OutlineComp
        end
        color3 = function(p110)
            if p110:FindFirstChild("CompESP") then
                return
            end
        end
        color3 = function(p111)
            if p111.Name == "ComputerTable" then
                v546 = p111:IsA("Model")
            else
                v546 = false
            end

            if v546 then
                color3(p111)

                return
            end

            local Parent = p111.Name == "Screen" and p111.Parent

            if Parent then
                Parent = p111.Parent.Name == "ComputerTable"
            end

            if not Parent then
                return
            end

            color3(p111.Parent)
        end
        color32 = pairs
        color33 = workspace

        for _, descendant in color32(color33:GetDescendants()) do
            color3(descendant)
        end

        t1.value105 = workspace.DescendantAdded:Connect(color3)

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
value32 = t1.value69
value32:CreateToggle(TextButton2, "Esp Doors", false, function(p112)
    if p112 then
        local color3 = Color3.fromRGB(0, 255, 0)
        local color32 = Color3.fromRGB(255, 0, 0)
        local v417
        local function v418(p113)
            if p113:FindFirstChild("DoorESP_FTF") then
                return p113:FindFirstChild("DoorESP_FTF")
            else
                local Highlight = Instance.new("Highlight")

                Highlight.Name = "DoorESP_FTF"
                Highlight.Adornee = p113
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0.2
                Highlight.FillColor = v417
                Highlight.OutlineColor = t1.value38.OutlineDoor
                Highlight.Parent = p113

                return Highlight
            end
        end
        v417 = color32
        color32 = function(descendant, p114)
            if not (descendant:IsA("BasePart") and (descendant.Name:match("Door") or (descendant.Name == "Part" or descendant.Name == "Left" or descendant.Name == "Right"))) then
                return
            end

            local v420 = descendant.Size.Y > 3 and not descendant.Name:match("Frame")

            if v420 then
                v420 = not descendant.Name:match("Wall")
            end

            if not (v420 and not t1.value109[descendant]) then
                return
            end

            t1.value109[descendant] = {
				["esp"] = v418(p114),
				["model"] = p114,
				["initialCFrame"] = descendant.CFrame
			}
        end
        v418 = ipairs
        local value22 = t1.value22
        local v422 = v417
        color32 = function(p115)
            local isModel = p115:IsA("Model")

            if isModel then
                isModel = (p115.Name == "SingleDoor" or p115.Name == "DoubleDoor") and true or p115.Name == "SlidingDoor"
            end

            if not isModel then
                return
            end

            for _, descendant in ipairs(p115:GetDescendants()) do
                color32(descendant, p115)
            end

            p115.DescendantAdded:Connect(function(descendant)
                color32(descendant, p115)
            end)
        end
        for _, descendant in v418(value22:GetDescendants()) do
            color32(descendant)
        end
        t1.value107 = t1.value22.DescendantAdded:Connect(color32)
        t1.value108 = task.spawn(function()
            while task.wait(0.1) and p112 do
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
                        Parent = k.CFrame

                        local Magnitude = (Parent.Position - v.initialCFrame.Position).Magnitude
                        local v432 = Parent.LookVector:Dot(v.initialCFrame.LookVector)

                        if k.CanCollide == true and (v432 < 0.9 or Magnitude > 0.5) then
                            v.initialCFrame = Parent
                        end

                        if (not k.CanCollide or ((v432 < 0.85 or Magnitude > 0.5) and true or k.Transparency > 0.8)) and true or false then
                            v.esp.FillColor = color3
                        else
                            v.esp.FillColor = v422
                        end

                        v.esp.OutlineColor = t1.value38.OutlineDoor
                    else
                        Parent = v.esp

                        if Parent then
                            Parent = not v.model.Parent
                        end

                        if Parent then
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
value32 = function()
    local ipairs_ = ipairs
    local workspace_ = workspace

    for _, descendant in ipairs_(workspace_:GetDescendants()) do
        if descendant.Name == "PodESP" then
            descendant:Destroy()
        end
    end
end
t1.value69:CreateToggle(TextButton2, "Esp Freezepods", false, function(p116)
    if p116 then
        local function v441(descendant)
            if descendant.Name == "FreezePod" then
                v583 = descendant:IsA("Model")
            else
                v583 = false
            end

            if not v583 then
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

        for _, descendant in pairs_(workspace_:GetDescendants()) do
            v441(descendant)
        end

        t1.value110 = workspace.DescendantAdded:Connect(v441)

        return
    end

    if not t1.value110 then
        value32()

        return
    end

    t1.value110:Disconnect()
    value32()
end)
t1.value69:CreateSection(TextButton2, "Outline Customization", "Left")
t1.value69:CreateColorPicker(TextButton2, "Survivor Outline", Color3.fromRGB(0, 0, 0), function(p117)
    t1.value38.OutlineSurvivor = p117
    Info()
end)
t1.value69:CreateColorPicker(TextButton2, "Beast Outline", Color3.fromRGB(0, 0, 0), function(p118)
    t1.value38.OutlineBeast = p118
    Info()
end)
value32 = t1.value69
parent = Color3
value32:CreateColorPicker(TextButton2, "Computer Outline", parent.fromRGB(0, 0, 0), function(p119)
    t1.value38.OutlineComp = p119

    local pairs_ = pairs
    local workspace_ = workspace

    for _, descendant in pairs_(workspace_:GetDescendants()) do
        local isHighlight

        if descendant.Name == "CompESP" then
            isHighlight = descendant:IsA("Highlight")
        else
            isHighlight = false
        end

        if isHighlight then
            descendant.OutlineColor = p119
        end
    end
end)
value32 = t1.value69
parent = Color3
value32:CreateColorPicker(TextButton2, "Freezepod Outline", parent.fromRGB(0, 0, 0), function(p120)
    t1.value38.OutlinePod = p120

    local pairs_ = pairs
    local workspace_ = workspace

    for _, descendant in pairs_(workspace_:GetDescendants()) do
        local isHighlight

        if descendant.Name == "PodESP" then
            isHighlight = descendant:IsA("Highlight")
        else
            isHighlight = false
        end

        if isHighlight then
            descendant.OutlineColor = p120
        end
    end
end)
t1.value69:CreateColorPicker(TextButton2, "Door Outline", Color3.fromRGB(0, 0, 0), function(p121)
    t1.value38.OutlineDoor = p121
end)
t1.value69:CreateSection(TextButton2, "Others ESPs", "Right")
t1.value69:CreateToggle(TextButton2, "Charms", false, function(p122)
    t1.value93 = p122

    if p122 then
        for _, player in ipairs(t1.value14:GetPlayers()) do
            t1.value104(player)
        end

        return
    else
        for _, player in ipairs(t1.value14:GetPlayers()) do
            local v461 = t1.value32:FindFirstChild(player.Name .. "_CharmsESP")

            if v461 then
                v461:Destroy()
            end
        end

        return
    end
end)
t1.value69:CreateToggle(TextButton2, "Skeleton", false, function(p123)
    t1.value94 = p123

    if p123 then
        return
    end

    for _, player in ipairs(t1.value14:GetPlayers()) do
        t1.value100(player)
    end
end)
t1.value69:CreateToggle(TextButton2, "Box 3D", false, function(p124)
    t1.value95 = p124

    if p124 then
        return
    end

    for _, player in ipairs(t1.value14:GetPlayers()) do
        t1.value99(player)
    end
end)
t1.value69:CreateToggle(TextButton2, "Esp Tracer Line", false, function(p125)
    t1.value89(p125)
end)
t1.value69:CreateDropdown(TextButton2, "Tracer Origin", { "Inferior", "Topo", "Torso" }, "Torso", function(p126)
    t1.value84 = p126
end)
t1.value69:CreateSlider(TextButton2, "Tracer Thickness", 1, 5, 1, function(p127)
    t1.value38.TracerThickness = p127
end)
t1.value69:CreateSection(TextButton2, "Color Customization", "Right")
value32 = t1.value69
parent = Color3
value32:CreateColorPicker(TextButton2, "Beast highlight Color", parent.fromRGB(0, 255, 255), function(p128)
    t1.value38.BeastHighlight = p128

    local pairs_ = pairs
    local value14 = t1.value14

    for _, player in pairs_(value14:GetPlayers()) do
        local Character = player.Character

        if Character then
            Character = player.Character:FindFirstChild("Head")
        end

        if Character then
            local BeastGlow = player.Character.Head:FindFirstChild("BeastGlow")

            if BeastGlow then
                BeastGlow.Color = p128
            end
        end
    end
end)
t1.value69:CreateColorPicker(TextButton2, "Survivor Fill Color", Color3.fromRGB(0, 255, 0), function(p129)
    t1.value38.Survivor = p129
    Info()
end)
t1.value69:CreateColorPicker(TextButton2, "Beast Fill Color", Color3.fromRGB(255, 0, 0), function(p130)
    t1.value38.Beast = p130
    Info()
end)
value32 = t1.value69
parent = Color3
value32:CreateColorPicker(TextButton2, "Freezepod Fill Color", parent.fromRGB(0, 255, 255), function(p131)
    t1.value38.Pod = p131

    local pairs_ = pairs
    local workspace_ = workspace

    for _, descendant in pairs_(workspace_:GetDescendants()) do
        local isHighlight

        if descendant.Name == "PodESP" then
            isHighlight = descendant:IsA("Highlight")
        else
            isHighlight = false
        end

        if isHighlight then
            descendant.FillColor = p131
        end
    end
end)
t1.value69:CreateSection(UserInputService, "Menu Configuration")
value32 = Instance.new("Frame")
value32.Name = "MenuConfigCard"
value32.Size = UDim2.new(1, -2, 0, 0)
value32.Position = UDim2.new(0, 1, 0, 0)
value32.AutomaticSize = Enum.AutomaticSize.Y
value32.BackgroundColor3 = Color3.new(0, 0, 0)
value32.BackgroundTransparency = 0.45
value32.Parent = UserInputService
Instance.new("UICorner", value32).CornerRadius = UDim.new(0, 6)
parent = Instance.new("UIStroke", value32)
parent.Color = Color3.fromRGB(40, 40, 40)
parent.Thickness = 1
parent = Instance.new("UIListLayout", value32)
parent.SortOrder = Enum.SortOrder.LayoutOrder
parent.Padding = UDim.new(0, 5)
parent = Instance.new("UIPadding", value32)
parent.PaddingTop = UDim.new(0, 8)
parent.PaddingBottom = UDim.new(0, 8)
parent.PaddingLeft = UDim.new(0, 8)
parent.PaddingRight = UDim.new(0, 8)
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, 0, 0, 40)
parent.BackgroundTransparency = 1
parent.BorderSizePixel = 0
parent.Parent = value32
TextButton2 = Instance.new("TextLabel")
TextButton2.Text = "Menu Keybind:"
TextButton2.Font = t1.value37.Font
TextButton2.TextSize = 12
TextButton2.TextColor3 = t1.value37.Text
TextButton2.Size = UDim2.new(0, 100, 1, 0)
TextButton2.Position = UDim2.new(0, 10, 0, 0)
TextButton2.BackgroundTransparency = 1
TextButton2.TextXAlignment = Enum.TextXAlignment.Left
TextButton2.Parent = parent
t1.value111 = Instance.new("TextButton")
t1.value111.Parent = parent
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
    local connection
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
t1.value71[UserInputService] = value32
t1.value72[UserInputService] = true
t1.value69:CreateDropdown(UserInputService, "UI Font", {
	"Gotham",
	"GothamBold",
	"GothamBlack",
	"Arial",
	"SourceSans",
	"Roboto",
	"Ubuntu"
}, "GothamBold", function(p132)
    t1.value47(p132)
end)
Minimize = {}
for i = 1, 20 do
    Info = "Style " .. i
    table.insert(Minimize, Info)
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
TextButton2 = {}
for k, v in pairs(t1.value112) do
    TextButton2[v] = k
end
Players = TextButton2[Players] or "Style 16"
t1.value69:CreateDropdown(UserInputService, "UI Background", Minimize, Players, function(p133)
    local v481 = t1.value112[p133]
    local v482

    if v481 then
        v482 = v481 ~= ""
    else
        v482 = v481
    end

    if not v482 then
        return
    end

    t1.value53.Image = "rbxassetid://" .. v481
    t1.value28(v481)
end)
t1.value69:CreateInput(UserInputService, "Custom Background ID", "", function(p134)
    if p134 then
        v644 = p134 ~= ""
    else
        v644 = p134
    end

    if not v644 then
        return
    end

    local v483 = string.match(p134, "%d+")

    if v483 then
        t1.value53.Image = "rbxassetid://" .. v483
        t1.value28(v483)

        return
    end

    t1.value53.Image = p134
end)
t1.value71[UserInputService] = nil
t1.value72[UserInputService] = nil
t1.value69:CreateSection(UserInputService, "External Scripts")
t1.value69:CreateButton(UserInputService, "Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
t1.value69:CreateButton(UserInputService, "YouTube Music", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua", true))()
end)
t1.value69:CreateSection(UserInputService, "Configuration Management")
Players = Instance.new("TextLabel")
Players.Text = "Config Name:"
Players.Font = Enum.Font.GothamBold
Players.TextSize = 12
Players.TextColor3 = t1.value37.Text
Players.Size = UDim2.new(1, -10, 0, 20)
Players.BackgroundTransparency = 1
Players.TextXAlignment = Enum.TextXAlignment.Left
Players.Parent = UserInputService
Players = Instance.new("Frame")
Players.Size = UDim2.new(1, -2, 0, 30)
Players.Position = UDim2.new(0, 1, 0, 0)
Players.BackgroundColor3 = Color3.new(0, 0, 0)
Players.BackgroundTransparency = 0.45
Players.BorderSizePixel = 0
Players.Parent = UserInputService
Instance.new("UICorner", Players).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Players).Color = Color3.fromRGB(40, 40, 40)
t1.value113 = Instance.new("TextBox")
t1.value113.Size = UDim2.new(1, -20, 1, 0)
t1.value113.Position = UDim2.new(0, 10, 0, 0)
t1.value113.BackgroundTransparency = 1
t1.value113.Text = TextButton
t1.value113.PlaceholderText = "Type config name..."
t1.value113.TextColor3 = t1.value37.Text
t1.value113.Font = Enum.Font.Gotham
t1.value113.TextSize = 12
t1.value113.TextXAlignment = Enum.TextXAlignment.Left
t1.value113.ClearTextOnFocus = false
t1.value113.Parent = Players
Players = Instance.new("Frame")
Players.Size = UDim2.new(1, 0, 0, 60)
Players.BackgroundTransparency = 1
Players.Parent = UserInputService
value32 = Instance.new("TextButton")
value32.Size = UDim2.new(0.32, 0, 0, 30)
value32.Position = UDim2.new(0, 0, 0, 0)
value32.BackgroundColor3 = Color3.new(0, 0, 0)
value32.BackgroundTransparency = 0.45
value32.Text = "Save Config"
value32.Font = Enum.Font.GothamBold
value32.TextSize = 11
value32.TextColor3 = t1.value37.Text
value32.Parent = Players
Instance.new("UICorner", value32).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", value32).Color = Color3.fromRGB(40, 40, 40)
TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0.32, 0, 0, 30)
TextButton.Position = UDim2.new(0.34, 0, 0, 0)
TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton.BackgroundTransparency = 0.45
TextButton.Text = "Load Config"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 11
TextButton.TextColor3 = t1.value37.Text
TextButton.Parent = Players
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton).Color = Color3.fromRGB(40, 40, 40)
parent = Instance.new("TextButton")
parent.Size = UDim2.new(0.32, 0, 0, 30)
parent.Position = UDim2.new(0.68, 0, 0, 0)
parent.BackgroundColor3 = Color3.new(0, 0, 0)
parent.BackgroundTransparency = 0.45
parent.Text = "Set as Default"
parent.Font = Enum.Font.GothamBold
parent.TextSize = 11
parent.TextColor3 = t1.value37.Text
parent.Parent = Players
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", parent).Color = Color3.fromRGB(40, 40, 40)
TextButton2 = Instance.new("TextButton")
TextButton2.Size = UDim2.new(0.48, 0, 0, 25)
TextButton2.Position = UDim2.new(0, 0, 0, 35)
TextButton2.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton2.BackgroundTransparency = 0.45
TextButton2.Text = "Reset to Default"
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 11
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Parent = Players
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TextButton2).Color = Color3.fromRGB(40, 40, 40)
Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0.48, 0, 0, 25)
Minimize.Position = UDim2.new(0.52, 0, 0, 35)
Minimize.BackgroundColor3 = Color3.new(0, 0, 0)
Minimize.BackgroundTransparency = 0.45
Minimize.Text = "Delet Config"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 11
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Parent = Players
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Minimize).Color = Color3.fromRGB(40, 40, 40)
Players = Instance.new("TextLabel")
Players.Text = "Available Configs:"
Players.Font = Enum.Font.GothamBold
Players.TextSize = 12
Players.TextColor3 = t1.value37.Text
Players.Size = UDim2.new(1, -10, 0, 30)
Players.BackgroundTransparency = 1
Players.TextXAlignment = Enum.TextXAlignment.Left
Players.Parent = UserInputService
t1.value114 = Instance.new("ScrollingFrame")
t1.value114.Size = UDim2.new(1, -2, 0, 100)
t1.value114.Position = UDim2.new(0, 1, 0, 0)
t1.value114.BackgroundColor3 = Color3.new(0, 0, 0)
t1.value114.BackgroundTransparency = 0.45
t1.value114.BorderSizePixel = 0
t1.value114.ScrollBarThickness = 2
t1.value114.ScrollBarImageColor3 = t1.value37.Accent
t1.value114.Parent = UserInputService
Instance.new("UICorner", t1.value114).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", t1.value114).Color = Color3.fromRGB(40, 40, 40)
Players = Instance.new("UIListLayout")
Players.Padding = UDim.new(0, 5)
Players.SortOrder = Enum.SortOrder.LayoutOrder
Players.Parent = t1.value114
Players = Instance.new("UIPadding")
Players.PaddingTop = UDim.new(0, 5)
Players.PaddingLeft = UDim.new(0, 10)
Players.PaddingBottom = UDim.new(0, 5)
Players.Parent = t1.value114
function t1.value115()

    for v486, v487 in ipairs(t1.value114:GetChildren()) do

        if v487:IsA("TextButton") then
            v487:Destroy()
        end
    end
    v484 = t1.value46()
    v484 = function()
        local listfiles_ = listfiles

        if listfiles_ then
            listfiles_ = isfolder(t1.value24)
        end

        if not listfiles_ then
            return
        end

        listfiles_ = listfiles(t1.value24)

        for _, v in ipairs(listfiles_) do
            if v:match("%.json$") then
                local match = v:match("([^/\\]+)%.json$")

                if match then
                    local TextButton3 = Instance.new("TextButton")

                    TextButton3.Size = UDim2.new(1, -10, 0, 20)
                    TextButton3.BackgroundTransparency = 1
                    TextButton3.Font = Enum.Font.GothamBold
                    TextButton3.TextSize = 12
                    TextButton3.TextColor3 = Color3.fromRGB(200, 200, 200)
                    TextButton3.TextXAlignment = Enum.TextXAlignment.Left

                    if match == v484 then
                        TextButton3.Text = match .. " (default config)"
                    else
                        TextButton3.Text = match
                    end

                    TextButton3.Parent = t1.value114
                    TextButton3.MouseButton1Click:Connect(function()
                        t1.value113.Text = match
                    end)
                    TextButton3.MouseEnter:Connect(function()
                        TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end)
                    TextButton3.MouseLeave:Connect(function()
                        TextButton3.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end)
                end
            end
        end
    end
    pcall(v484)
    v486 = 0
    for _, child in ipairs(t1.value114:GetChildren()) do
        if child:IsA("TextButton") then
            v486 = v486 + 1
        end
    end
    t1.value114.CanvasSize = UDim2.new(0, 0, 0, v486 * 25)
end
t1.value115()
value32.MouseButton1Click:Connect(function()
    local Text = t1.value113.Text

    Text = Text == "" and "config_1" or Text

    local v496 = t1.value24 .. "/" .. Text .. ".json"
    local u497 = false

    pcall(function()
        local isfile_ = isfile

        if isfile_ then
            isfile_ = isfile(v496)
        end

        if not isfile_ then
            return
        end

        u497 = true
    end)

    if u497 then
        t1.value31("A configuration with this name already exists!", 4)

        return
    end

    t1.value49(Text)
    t1.value115()
    t1.value31("Config \'" .. Text .. "\' Saved!", 3)

    if not _G.NexVoidLog then
        return
    end

    task.spawn(function()
        _G.NexVoidLog("Button", "Saved Config: " .. Text)
    end)
end)
TextButton.MouseButton1Click:Connect(function()
    local Text = t1.value113.Text

    Text = Text == "" and "config_1" or Text
    t1.value74(Text)
    t1.value115()
    t1.value31("Config \'" .. Text .. "\' Loaded!", 3)

    if not _G.NexVoidLog then
        return
    end

    task.spawn(function()
        _G.NexVoidLog("Button", "Loaded Config: " .. Text)
    end)
end)
parent.MouseButton1Click:Connect(function()
    local Text = t1.value113.Text

    Text = Text == "" and "config_1" or Text
    t1.value50(Text)
    t1.value115()
    t1.value31("Default config set to \'" .. Text .. "\'", 3)
end)
Minimize.MouseButton1Click:Connect(function()
    local Text = t1.value113.Text
    local v502 = Text == "" and "config_1" or Text
    Text = t1.value24 .. "/" .. v502 .. ".json"
    local v503
    local function v504()
        local isfile_ = isfile and isfile(v503)

        if not isfile_ then
            if isfile_ then
                delfile(v503)
                t1.value31("Config \'" .. v502 .. "\' Deleted!", 3)

                return
            else
                t1.value31("Config file not found or not supported!", 3)

                return
            end

            return
        end

        isfile_ = delfile

        if isfile_ then
            delfile(v503)
            t1.value31("Config \'" .. v502 .. "\' Deleted!", 3)

            return
        else
            t1.value31("Config file not found or not supported!", 3)

            return
        end
    end
    v503 = Text
    pcall(v504)
    t1.value115()
end)
TextButton2.MouseButton1Click:Connect(function()
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
Players = function(p135, p136)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, -15, 0, #p136 * 25 + 40)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.45
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local UIStroke = Instance.new("UIStroke", Frame)

    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Thickness = 1
    UIStroke = Instance.new("TextLabel", Frame)
    UIStroke.Size = UDim2.new(1, -30, 0, 30)
    UIStroke.Position = UDim2.new(0, 20, 0, 0)
    UIStroke.BackgroundTransparency = 1
    UIStroke.Text = p135
    UIStroke.Font = Enum.Font.GothamBlack
    UIStroke.TextSize = 12
    UIStroke.TextColor3 = Color3.fromRGB(255, 255, 255)
    UIStroke.TextXAlignment = Enum.TextXAlignment.Left
    UIStroke = Instance.new("Frame", Frame)
    UIStroke.Size = UDim2.new(0, 3, 0, 14)
    UIStroke.Position = UDim2.new(0, 10, 0, 8)
    UIStroke.BackgroundColor3 = t1.value37.Accent
    UIStroke.BorderSizePixel = 0
    Instance.new("UICorner", UIStroke).CornerRadius = UDim.new(1, 0)
    UIStroke = Instance.new("Frame", Frame)
    UIStroke.Size = UDim2.new(1, -20, 0, 1)
    UIStroke.Position = UDim2.new(0, 10, 0, 30)
    UIStroke.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UIStroke.BorderSizePixel = 0

    local t2 = {}

    for i, v in ipairs(p136) do
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, -20, 0, 20)
        TextLabel.Position = UDim2.new(0, 15, 0, 35 + (i - 1) * 25)
        TextLabel.BackgroundTransparency = 1
        TextLabel.RichText = true
        TextLabel.Text = v.Default
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextSize = 12
        TextLabel.TextColor3 = t1.value37.Text
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Parent = Frame

        if v.Id then
            t2[v.Id] = TextLabel
        end
    end

    return Frame, t2
end
UserInputService, value32 = Players("CREDITS", {
	{
		["Default"] = "<b>NexVoid Creator Discord:</b> <font color=\'rgb(150,150,150)\'> @davidnaoxita.</font>"
	},
	{
		["Default"] = "<b>NexVoid Testers:</b> <font color=\'rgb(150,150,150)\'>kayquenaoxita, Valtzinx e V1kxz</font>"
	},
	{
		["Default"] = "<b>NexVoid Contributor:</b> <font color=\'rgb(150,150,150)\'>kayquenaoxita</font>"
	}
})
UserInputService.Parent = t1.value66
UserInputService, value32 = Players("PLAYER INFO", {
	{
		["Id"] = "FPS",
		["Default"] = "<b>FPS:</b> <font color=\'rgb(150,150,150)\'>...</font>"
	},
	{
		["Id"] = "Ping",
		["Default"] = "<b>Ping:</b> <font color=\'rgb(150,150,150)\'>... ms</font>"
	},
	{
		["Id"] = "Exec",
		["Default"] = "<b>Executor:</b> <font color=\'rgb(150,150,150)\'>" .. (identifyexecutor and identifyexecutor() or "Unknown") .. "</font>"
	}
})
t1.value116 = value32
UserInputService.Parent = t1.value66
UserInputService = t1.value14.MaxPlayers
Players, UserInputService = Players("SERVER INFO", {
	{
		["Id"] = "Region",
		["Default"] = "<b>Region:</b> <font color=\'rgb(150,150,150)\'>Fetching...</font>"
	},
	{
		["Id"] = "Players",
		["Default"] = "<b>Players:</b> <font color=\'rgb(150,150,150)\'>...</font>"
	},
	{
		["Id"] = "Max",
		["Default"] = "<b>Max Players:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(UserInputService) .. "</font>"
	}
})
t1.value117 = UserInputService
Players.Parent = t1.value66
Players = Instance.new("TextLabel")
Players.Size = UDim2.new(1, -15, 0, 20)
Players.BackgroundTransparency = 1
Players.Text = "Thank you for using Nexvoid."
Players.Font = Enum.Font.Gotham
Players.TextSize = 11
Players.TextColor3 = Color3.fromRGB(150, 150, 150)
Players.TextXAlignment = Enum.TextXAlignment.Center
Players.Parent = t1.value66
Players = Instance.new("TextLabel")
Players.Size = UDim2.new(1, -15, 0, 20)
Players.BackgroundTransparency = 1
Players.Text = "NexVoid is a free script, don\'t pay for it."
Players.Font = Enum.Font.Gotham
Players.TextSize = 11
Players.TextColor3 = Color3.fromRGB(150, 150, 150)
Players.TextXAlignment = Enum.TextXAlignment.Center
Players.Parent = t1.value66
t1.value118 = 0
t1.value119 = tick()
task.spawn(function()
    local function v514()
        return t1.value18:JSONDecode(game:HttpGet("http://ip-api.com/json/"))
    end

    local result

    v514, result = pcall(v514)

    local s3 = "Unknown"

    if v514 then
        if result then
            v514 = result.countryCode
        else
            v514 = result
        end
    end

    if v514 then
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

    local n5 = 0

    pcall(function()
        local value = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()

        n5 = math.floor(value)
    end)

    if t1.value116.Ping then
        value118 = n5
        t1.value116.Ping.Text = "<b>Ping:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(value118) .. " ms</font>"
    end

    if not t1.value117.Players then
        return
    end

    value118 = t1.value117.Players

    local v520 = #t1.value14:GetPlayers()

    value118.Text = "<b>Players:</b> <font color=\'rgb(150,150,150)\'>" .. tostring(v520) .. "</font>"
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
    local n6 = 0

    for _, child in ipairs_(value66:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            n6 = n6 + child.AbsoluteSize.Y + 10
        end
    end

    t1.value66.CanvasSize = UDim2.new(0, 0, 0, n6)
end)
t1.value33.Enabled = true
t1.value52.Visible = true
t1.value55.Visible = false
