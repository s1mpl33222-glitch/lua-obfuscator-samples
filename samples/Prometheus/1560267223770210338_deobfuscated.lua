-- This file was generated at discord.gg/syncrypt

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local function v5(p1, p2)
    p1.Font = p2
    p1:GetPropertyChangedSignal("Font"):Connect(function()
        if p1.Font ~= p2 then
            p1.Font = p2
        end
    end)
end
local t1 = {
	RideAFish_vgqpgbz = true
}
local u7
local function v8()
    local _readfile = readfile

    if _readfile then
        _readfile = isfile

        if _readfile then
            _readfile = isfile("SavedKeys.json")
        end
    end

    if _readfile then
        local ok, result = pcall(readfile, "SavedKeys.json")

        if ok then
            local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)

            if ok2 then
                ok2 = type(result2) == "table"
            end

            if ok2 then
                return result2
            end
        end
    end

    return {}
end
function u7(p3)
    local _tostring = tostring

    if not p3 then
        p3 = ""
    end

    return _tostring(p3):gsub("^%s+", ""):gsub("%s+$", "")
end
local function v9(p4)
    return t1[u7(p4)] == true
end
local function v10(p5)
    if not writefile then
        return
    end

    local v63 = u7(p5)

    if v63 == "" then
        return
    end

    local v64 = v8()

    if not table.find(v64, v63) then
        table.insert(v64, 1, v63)
        pcall(writefile, "SavedKeys.json", HttpService:JSONEncode(v64))
    end
end
local function v11()
    local _getgenv = getgenv

    if _getgenv then
        _getgenv = getgenv()
    end

    if not _getgenv then
        _getgenv = _G

        if not _getgenv then
            _getgenv = shared
        end
    end

    if _getgenv and _getgenv._ActivateSTKHub then
        _getgenv._ActivateSTKHub()
        _getgenv._ActivateSTKHub = nil
    end
end
for _, v in ipairs((v8())) do
    if v9(v) then
        v11()

        return
    end
end
local function v14(p6)
    if setclipboard then
        setclipboard(p6)

        return true
    end

    if toclipboard then
        toclipboard(p6)

        return true
    end

    return false
end
local KeyGUI = PlayerGui:FindFirstChild("KeyGUI")
if KeyGUI then
    KeyGUI:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = PlayerGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 310)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(24, 20, 31)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = Frame
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 200)
UIStroke.Thickness = 1.5
UIStroke.Parent = Frame
local TextButton = Instance.new("TextButton")
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.Modal = true
TextButton.Size = UDim2.fromScale(1, 1)
TextButton.ZIndex = 0
TextButton.Parent = Frame
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(1, 0, 0, 50)
Frame2.BackgroundColor3 = Color3.fromRGB(34, 28, 44)
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 14)
UICorner2.Parent = Frame2
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Sosiskomras HUB"
TextLabel.TextColor3 = Color3.fromRGB(150, 255, 235)
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.Parent = Frame2
v5(TextLabel, Enum.Font.GothamBold)
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, -40, 0, 240)
Frame3.Position = UDim2.new(0, 20, 0, 65)
Frame3.BackgroundTransparency = 1
Frame3.Parent = Frame
local Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, 0, 0, 20)
Frame4.Position = UDim2.new(0, 0, 0, 0)
Frame4.BackgroundTransparency = 1
Frame4.Parent = Frame3
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Enter your key below to access the hub"
TextLabel2.TextColor3 = Color3.fromRGB(170, 160, 185)
TextLabel2.TextSize = 14
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame4
v5(TextLabel2, Enum.Font.SourceSansBold)
local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(1, 0, 0, 36)
Frame5.Position = UDim2.new(0, 0, 0, 25)
Frame5.BackgroundColor3 = Color3.fromRGB(18, 15, 23)
Frame5.Parent = Frame3
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = Frame5
local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(60, 50, 75)
UIStroke2.Thickness = 1.5
UIStroke2.Parent = Frame5
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 1, 0)
TextBox.Position = UDim2.new(0, 10, 0, 0)
TextBox.BackgroundTransparency = 1
TextBox.PlaceholderText = "Waiting for key entry..."
TextBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 115)
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(240, 230, 255)
TextBox.TextSize = 13
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame5
v5(TextBox, Enum.Font.GothamMedium)
local function v31()
    local v66 = u7(TextBox.Text)

    if not v9(v66) or v66 == "" then
        TextBox.Text = ""
        TextBox.PlaceholderText = "INVALID KEY"
        UIStroke2.Color = Color3.fromRGB(255, 100, 100)
        task.wait(1.2)
        UIStroke2.Color = Color3.fromRGB(60, 50, 75)
        TextBox.PlaceholderText = "Waiting for key entry..."

        return
    end

    v10(v66)
    ScreenGui:Destroy()
    v11()
end
local function v32(p7, p8, p9, p10)
    local Frame6 = Instance.new("Frame")

    Frame6.Size = p8
    Frame6.Position = p9
    Frame6.BackgroundColor3 = Color3.fromRGB(44, 36, 56)
    Frame6.BorderSizePixel = 0
    Frame6.Parent = Frame3

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0, 8)
    UICorner4.Parent = Frame6

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.fromScale(1, 1)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p7
    TextLabel3.TextColor3 = Color3.fromRGB(220, 210, 235)
    TextLabel3.TextSize = 13
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel3.Parent = Frame6
    v5(TextLabel3, Enum.Font.GothamBold)

    local UIStroke3 = Instance.new("UIStroke")

    UIStroke3.Color = Color3.fromRGB(75, 60, 95)
    UIStroke3.Thickness = 1
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke3.Parent = Frame6
    Frame6.MouseEnter:Connect(function()
        TweenService:Create(Frame6, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(58, 48, 74)
		}):Play()
        TweenService:Create(UIStroke3, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(0, 255, 200)
		}):Play()
    end)
    Frame6.MouseLeave:Connect(function()
        TweenService:Create(Frame6, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(44, 36, 56)
		}):Play()
        TweenService:Create(UIStroke3, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(75, 60, 95)
		}):Play()
    end)
    Frame6.InputBegan:Connect(function(input)
        local v86 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v86 then
            v86 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v86 then
            p10()
        end
    end)

    return Frame6
end
local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(1, 0, 0, 36)
Frame7.Position = UDim2.new(0, 0, 0, 70)
Frame7.BackgroundColor3 = Color3.fromRGB(0, 160, 125)
Frame7.BorderSizePixel = 0
Frame7.Parent = Frame3
local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 8)
UICorner5.Parent = Frame7
local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Size = UDim2.fromScale(1, 1)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "CHECK KEY"
TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel4.TextSize = 11
TextLabel4.TextXAlignment = Enum.TextXAlignment.Center
TextLabel4.TextYAlignment = Enum.TextYAlignment.Center
TextLabel4.Parent = Frame7
v5(TextLabel4, Enum.Font.GothamBold)
local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Color = Color3.fromRGB(0, 255, 200)
UIStroke4.Thickness = 1
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = Frame7
Frame7.MouseEnter:Connect(function()
    TweenService:Create(Frame7, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(0, 190, 150)
	}):Play()
end)
Frame7.MouseLeave:Connect(function()
    TweenService:Create(Frame7, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(0, 160, 125)
	}):Play()
end)
Frame7.InputBegan:Connect(function(input)
    local v76 = input.UserInputType == Enum.UserInputType.MouseButton1

    if not v76 then
        v76 = input.UserInputType == Enum.UserInputType.Touch
    end

    if v76 then
        v31()
    end
end)
local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(1, 0, 0, 20)
Frame8.Position = UDim2.new(0, 0, 0, 114)
Frame8.BackgroundTransparency = 1
Frame8.Parent = Frame3
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Frame8
local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Size = UDim2.new(0, 0, 1, 0)
TextLabel5.AutomaticSize = Enum.AutomaticSize.X
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "Need support?"
TextLabel5.TextColor3 = Color3.fromRGB(140, 130, 155)
TextLabel5.TextSize = 14
TextLabel5.LayoutOrder = 1
TextLabel5.Parent = Frame8
v5(TextLabel5, Enum.Font.SourceSansBold)
local TextLabel6 = Instance.new("TextLabel")
TextLabel6.Size = UDim2.new(0, 0, 1, 0)
TextLabel6.AutomaticSize = Enum.AutomaticSize.X
TextLabel6.BackgroundTransparency = 1
TextLabel6.Text = "Get Discord Link"
TextLabel6.TextColor3 = Color3.fromRGB(0, 255, 200)
TextLabel6.TextSize = 13
TextLabel6.LayoutOrder = 2
TextLabel6.Parent = Frame8
v5(TextLabel6, Enum.Font.GothamBold)
TextLabel6.InputBegan:Connect(function(input)
    local v78 = input.UserInputType == Enum.UserInputType.MouseButton1

    if not v78 then
        v78 = input.UserInputType == Enum.UserInputType.Touch
    end

    if v78 then
        v14("https://discord.gg/behjGQhNFX")
        TextBox.Text = ""
        TextBox.PlaceholderText = "Discord link copied"
        UIStroke2.Color = Color3.fromRGB(255, 255, 255)
        task.wait(1.2)
        UIStroke2.Color = Color3.fromRGB(60, 50, 75)
        TextBox.PlaceholderText = "Waiting for key entry..."
    end
end)
local Frame9 = Instance.new("Frame")
Frame9.Size = UDim2.new(1, 0, 0, 1)
Frame9.Position = UDim2.new(0, 0, 0, 142)
Frame9.BackgroundColor3 = Color3.fromRGB(44, 36, 56)
Frame9.BorderSizePixel = 0
Frame9.Parent = Frame3
v32("SocialWolvez", UDim2.new(0.5, -5, 0, 34), UDim2.new(0, 0, 0, 151), function()
    v14("https://scwz.me/vj7fj1")
    TextBox.Text = ""
    TextBox.PlaceholderText = "SocialWolvez link copied"
    UIStroke2.Color = Color3.fromRGB(255, 255, 255)
    task.wait(1.2)
    UIStroke2.Color = Color3.fromRGB(60, 50, 75)
    TextBox.PlaceholderText = "Waiting for key entry..."
end)
v32("WorkInk", UDim2.new(0.5, -5, 0, 34), UDim2.new(0.5, 5, 0, 151), function()
    v14("https://work.ink/2Byk/ride-a-fish")
    TextBox.Text = ""
    TextBox.PlaceholderText = "WorkInk link copied"
    UIStroke2.Color = Color3.fromRGB(255, 255, 255)
    task.wait(2)
    UIStroke2.Color = Color3.fromRGB(60, 50, 75)
    TextBox.PlaceholderText = "Waiting for key entry..."
end)
v32("Sub 2 Unlock", UDim2.new(1, 0, 0, 34), UDim2.new(0, 0, 0, 191), function()
    v14("https://sub2unlock.com/Pnd67")
    TextBox.Text = ""
    TextBox.PlaceholderText = "Sub 2 Unlock link copied"
    UIStroke2.Color = Color3.fromRGB(255, 255, 255)
    task.wait(1.2)
    UIStroke2.Color = Color3.fromRGB(60, 50, 75)
    TextBox.PlaceholderText = "Waiting for key entry..."
end)
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        v31()
    end
end);
(function(p11, p12)
    local u51 = false
    local inputPosition
    local p12Position
    p11.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            u51 = true
            inputPosition = input.Position
            p12Position = p12.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v82 = u51

        if v82 then
            v82 = input.UserInputType == Enum.UserInputType.MouseMovement
        end

        if v82 then
            local v83 = input.Position - inputPosition

            p12.Position = UDim2.new(p12Position.X.Scale, p12Position.X.Offset + v83.X, p12Position.Y.Scale, p12Position.Y.Offset + v83.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        end
    end)
end)(Frame2, Frame)
