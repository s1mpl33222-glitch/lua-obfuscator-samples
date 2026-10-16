-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("RunService"),
	value3 = game:GetService("UserInputService"),
	value4 = game:GetService("TweenService")
}

t2.value5 = t2.value1.LocalPlayer
local PlayerGui = t2.value5:WaitForChild("PlayerGui")
local Character = t2.value5.Character
if not Character then
    Character = t2.value5.CharacterAdded:Wait()
end
t2.value6 = Character
t2.value6:WaitForChild("Humanoid")
t2.value6:WaitForChild("HumanoidRootPart")
t2.value7 = {
	flyActive = false,
	noclipActive = false,
	flySpeed = 50,
	currentTab = "SkinChanger",
	minimized = false,
	originalDesc = nil,
	flyConnection = nil,
	noclipLoop = nil,
	bodyGyro = nil,
	bodyVelocity = nil,
	selectedPlayer = nil,
	playerEntries = {}
}
function t2.value8(p1, p2, p3, p4, p5)
    local value4 = t2.value4
    local new = TweenInfo.new
    local v86 = p3 or 0.2

    if not p4 then
        p4 = Enum.EasingStyle.Quart
    end

    if not p5 then
        p5 = Enum.EasingDirection.Out
    end

    return value4:Create(p1, new(v86, p4, p5), p2)
end
function t2.value9()
    local Character2 = t2.value5.Character

    if Character2 then
        Character2 = t2.value5.Character:FindFirstChildOfClass("Humanoid")
    end

    local v76 = Character2

    if v76 then
        local ok, result = pcall(function()
            return v76:GetAppliedDescription()
        end)

        if ok and result then
            t2.value7.originalDesc = result
        end
    end
end
pcall(t2.value9)
t2.value10 = {}
function t2.value11()
    local CurrentCamera = workspace.CurrentCamera
    local vector3 = Vector3.new(0, 0, 0)
    local flySpeed = t2.value7.flySpeed

    if t2.value3:IsKeyDown(Enum.KeyCode.W) then
        vector3 += CurrentCamera.CFrame.LookVector
    end

    if t2.value3:IsKeyDown(Enum.KeyCode.S) then
        vector3 -= CurrentCamera.CFrame.LookVector
    end

    if t2.value3:IsKeyDown(Enum.KeyCode.A) then
        vector3 -= CurrentCamera.CFrame.RightVector
    end

    if t2.value3:IsKeyDown(Enum.KeyCode.D) then
        vector3 += CurrentCamera.CFrame.RightVector
    end

    if t2.value3:IsKeyDown(Enum.KeyCode.Space) then
        vector3 += Vector3.new(0, 1, 0)
    end

    local v90 = t2.value3:IsKeyDown(Enum.KeyCode.LeftControl)

    if not v90 then
        v90 = t2.value3:IsKeyDown(Enum.KeyCode.C)
    end

    if v90 then
        vector3 -= Vector3.new(0, 1, 0)
    end

    if vector3.Magnitude > 0 then
        vector3 = vector3.Unit * flySpeed
    end

    return vector3
end
function t2.value10.start()
    local Character3 = t2.value5.Character

    if not Character3 then
        return
    end

    local HumanoidRootPart = Character3:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local Humanoid = Character3:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.PlatformStand = true
    end

    local BodyGyro = Instance.new("BodyGyro")

    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.P = 10000
    BodyGyro.CFrame = HumanoidRootPart.CFrame
    BodyGyro.Parent = HumanoidRootPart
    t2.value7.bodyGyro = BodyGyro

    local BodyVelocity = Instance.new("BodyVelocity")

    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
    BodyVelocity.P = 10000
    BodyVelocity.Parent = HumanoidRootPart
    t2.value7.bodyVelocity = BodyVelocity
    t2.value7.flyConnection = t2.value2.RenderStepped:Connect(function()
        if not t2.value7.flyActive then
            return
        end

        local Character4 = t2.value5.Character

        if Character4 then
            Character4 = t2.value5.Character:FindFirstChild("HumanoidRootPart")
        end

        if not Character4 then
            return
        end

        local v239 = t2.value11()

        BodyVelocity.Velocity = v239

        if v239.Magnitude > 0 then
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame

            return
        end

        BodyGyro.CFrame = Character4.CFrame
    end)
end
function t2.value10.stop()
    local Character5 = t2.value5.Character

    if Character5 then
        local Humanoid = Character5:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end

    if t2.value7.flyConnection then
        t2.value7.flyConnection:Disconnect()
        t2.value7.flyConnection = nil
    end

    if t2.value7.bodyGyro then
        t2.value7.bodyGyro:Destroy()
        t2.value7.bodyGyro = nil
    end

    if t2.value7.bodyVelocity then
        t2.value7.bodyVelocity:Destroy()
        t2.value7.bodyVelocity = nil
    end
end
local function v5()
    if t2.value7.noclipLoop then
        t2.value7.noclipLoop:Disconnect()
        t2.value7.noclipLoop = nil
    end

    local Character6 = t2.value5.Character

    if Character6 then
        for _, descendant in ipairs(Character6:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = true
            end
        end
    end
end
local BananaoHub = PlayerGui:FindFirstChild("BananaoHub")

if BananaoHub then
    BananaoHub:Destroy()
end
t2.value12 = Instance.new("ScreenGui")
t2.value12.Name = "BananaoHub"
t2.value12.ResetOnSpawn = false
t2.value12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value12.DisplayOrder = 999
t2.value12.Parent = PlayerGui
t2.value13 = Instance.new("Frame")
t2.value13.Name = "Window"
t2.value13.Size = UDim2.new(0, 460, 0, 560)
t2.value13.Position = UDim2.new(0.5, -230, 0.5, -280)
t2.value13.BorderSizePixel = 0
t2.value13.ClipsDescendants = true
t2.value13.Parent = t2.value12
local Frame = Instance.new("Frame")

Frame.Name = "ResizeHandle"
Frame.Size = UDim2.new(0, 20, 0, 20)
Frame.Position = UDim2.new(1, -20, 1, -20)
Frame.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
Frame.BorderSizePixel = 0
Frame.Parent = t2.value13
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame
t2.value14 = false
t2.value15 = nil
t2.value16 = nil
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t2.value14 = true
        t2.value15 = input.Position
        t2.value16 = t2.value13.Size
    end
end)
Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t2.value14 = false
    end
end)
t2.value3.InputChanged:Connect(function(input)
    local value14 = t2.value14

    if value14 then
        value14 = input.UserInputType == Enum.UserInputType.MouseMovement
    end

    if value14 then
        local v105 = input.Position - t2.value15
        local v106 = math.clamp(t2.value16.X.Offset + v105.X, 350, 1000)
        local v107 = math.clamp(t2.value16.Y.Offset + v105.Y, 250, 800)

        t2.value13.Size = UDim2.new(0, v106, 0, v107)
    end
end)

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = t2.value13
local ImageLabel = Instance.new("ImageLabel")

ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(1, 40, 1, 40)
ImageLabel.ZIndex = t2.value13.ZIndex - 1
ImageLabel.Image = "rbxassetid://5554236805"
ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.ImageTransparency = 0.55
ImageLabel.ScaleType = Enum.ScaleType.Slice
ImageLabel.SliceCenter = Rect.new(23, 23, 277, 277)
ImageLabel.Parent = t2.value13
local UIGradient = Instance.new("UIGradient")

UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 42)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 26))
})
UIGradient.Rotation = 135
UIGradient.Parent = t2.value13
local Frame2 = Instance.new("Frame")

Frame2.Name = "TitleBar"
Frame2.Size = UDim2.new(1, 0, 0, 42)
Frame2.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
Frame2.BorderSizePixel = 0
Frame2.Parent = t2.value13
local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 12)
UICorner3.Parent = Frame2
local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, 0, 0, 12)
Frame3.Position = UDim2.new(0, 0, 1, -12)
Frame3.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame2
local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Bananao Hub"
TextLabel.TextColor3 = Color3.fromRGB(242, 242, 247)
TextLabel.TextSize = 14
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.Parent = Frame2
local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "by 7xkng"
TextLabel2.TextColor3 = Color3.fromRGB(130, 130, 140)
TextLabel2.TextSize = 11
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
TextLabel2.Position = UDim2.new(0, 0, 0, 14)
TextLabel2.Parent = Frame2
t2.value17 = Instance.new("Frame")
t2.value17.Size = UDim2.new(0, 68, 0, 20)
t2.value17.Position = UDim2.new(0, 12, 0.5, -10)
t2.value17.BackgroundTransparency = 1
t2.value17.Parent = Frame2
local UIListLayout = Instance.new("UIListLayout")

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = t2.value17
local function v18(p6)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 14, 0, 14)
    TextButton.BackgroundColor3 = p6
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(1, 0)
    UICorner4.Parent = TextButton
    TextButton.Parent = t2.value17

    return TextButton
end
local v19 = v18(Color3.fromRGB(255, 96, 92))
local v20 = v18(Color3.fromRGB(255, 189, 46))
local v21 = v18(Color3.fromRGB(40, 200, 64))

v19.MouseButton1Click:Connect(function()
    local value8 = t2.value8
    local value13 = t2.value13
    local uDim2 = UDim2.new(0, 0, 0, 0)
    local uDim2_2 = UDim2.new(0.5, 0, 0.5, 0)

    value8(value13, {
		Size = uDim2,
		Position = uDim2_2
	}, 0.25):Play()
    task.wait(0.28)
    t2.value12:Destroy()
end)
v20.MouseButton1Click:Connect(function()
    t2.value7.minimized = not t2.value7.minimized

    local v115 = not t2.value7.minimized and 560 or 42

    t2.value8(t2.value13, {
		Size = UDim2.new(0, 460, 0, v115)
	}, 0.3):Play()
end)

for _, v in ipairs({
	{
		v19,
		Color3.fromRGB(255, 96, 92),
		Color3.fromRGB(200, 60, 58)
	},
	{
		v20,
		Color3.fromRGB(255, 189, 46),
		Color3.fromRGB(200, 140, 30)
	},
	{
		v21,
		Color3.fromRGB(40, 200, 64),
		Color3.fromRGB(28, 155, 48)
	}
}) do
    local v24 = v[1]
    local v25 = v[2]
    local v26 = v[3]
    local MouseEnter = v24.MouseEnter

    function t1.value1()
        t2.value8(v24, {
			BackgroundColor3 = v26
		}, 0.1):Play()
    end

    MouseEnter:Connect(t1.value1)

    local MouseLeave = v24.MouseLeave

    function t1.value1()
        t2.value8(v24, {
			BackgroundColor3 = v25
		}, 0.1):Play()
    end

    MouseLeave:Connect(t1.value1)
end
t2.value18 = false
t2.value19 = nil
t2.value20 = nil
Frame2.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t2.value18 = true
        t2.value19 = input.Position
        t2.value20 = t2.value13.Position
    end
end)
Frame2.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t2.value18 = false
    end
end)
t2.value3.InputChanged:Connect(function(input)
    local value18 = t2.value18

    if value18 then
        value18 = input.UserInputType == Enum.UserInputType.MouseMovement
    end

    if value18 then
        local v120 = input.Position - t2.value19

        t2.value13.Position = UDim2.new(t2.value20.X.Scale, t2.value20.X.Offset + v120.X, t2.value20.Y.Scale, t2.value20.Y.Offset + v120.Y)
    end
end)
t2.value21 = Instance.new("Frame")
t2.value21.Name = "TabBar"
t2.value21.Size = UDim2.new(1, 0, 0, 38)
t2.value21.Position = UDim2.new(0, 0, 0, 43)
t2.value21.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
t2.value21.BorderSizePixel = 0
t2.value21.Parent = t2.value13
local UIListLayout2 = Instance.new("UIListLayout")

UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout2.Padding = UDim.new(0, 4)
UIListLayout2.Parent = t2.value21
local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingLeft = UDim.new(0, 12)
UIPadding.PaddingRight = UDim.new(0, 12)
UIPadding.Parent = t2.value21
local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(1, 0, 0, 1)
Frame4.Position = UDim2.new(0, 0, 0, 81)
Frame4.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
Frame4.BorderSizePixel = 0
Frame4.Parent = t2.value13
t2.value22 = Instance.new("Frame")
t2.value22.Size = UDim2.new(1, 0, 1, -83)
t2.value22.Position = UDim2.new(0, 0, 0, 82)
t2.value22.BackgroundTransparency = 1
t2.value22.ClipsDescendants = true
t2.value22.Parent = t2.value13
t2.value23 = {}
t2.value24 = {}
t2.value24.FlyHack = (function(p7, p8)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p7
    TextButton.Size = UDim2.new(0, 130, 0, 28)
    TextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
    TextButton.BorderSizePixel = 0
    TextButton.Text = p8
    TextButton.TextColor3 = Color3.fromRGB(160, 160, 170)
    TextButton.TextSize = 13
    TextButton.Font = Enum.Font.GothamSemibold
    TextButton.AutoButtonColor = false

    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0, 8)
    UICorner5.Parent = TextButton
    TextButton.Parent = t2.value21

    return TextButton
end)("FlyHack", "Fly Hack")
t2.value23.FlyHack = (function(p9)
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = p9
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Visible = false
    ScrollingFrame.Parent = t2.value22

    local UIPadding2 = Instance.new("UIPadding")

    UIPadding2.PaddingLeft = UDim.new(0, 18)
    UIPadding2.PaddingRight = UDim.new(0, 18)
    UIPadding2.PaddingTop = UDim.new(0, 14)
    UIPadding2.PaddingBottom = UDim.new(0, 14)
    UIPadding2.Parent = ScrollingFrame

    local UIListLayout3 = Instance.new("UIListLayout")

    UIListLayout3.FillDirection = Enum.FillDirection.Vertical
    UIListLayout3.Padding = UDim.new(0, 10)
    UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout3.Parent = ScrollingFrame

    return ScrollingFrame
end)("FlyHack")

local function v32(p10)
    t2.value7.currentTab = p10
    for v132, v133 in pairs(t2.value23) do

        v133.Visible = v132 == p10
    end
    for k, v in pairs(t2.value24) do
        if k == p10 then
            v.BackgroundColor3 = Color3.fromRGB(10, 132, 255)
            v.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            v.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
            v.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
    end
end
local function v33(p11)
    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.new(1, 0, 0, 20)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = ""
    TextLabel3.TextColor3 = Color3.fromRGB(130, 130, 140)
    TextLabel3.TextSize = 12
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel3.Parent = p11

    return TextLabel3
end
local function v34(p12, p13, p14)
    local Frame5 = Instance.new("Frame")

    Frame5.Size = UDim2.new(1, 0, 0, 32)
    Frame5.BackgroundTransparency = 1
    Frame5.Parent = p12

    local TextLabel4 = Instance.new("TextLabel")

    TextLabel4.Size = UDim2.new(1, -56, 1, 0)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = p13
    TextLabel4.TextColor3 = Color3.fromRGB(220, 220, 228)
    TextLabel4.TextSize = 13
    TextLabel4.Font = Enum.Font.Gotham
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.Parent = Frame5

    local Frame6 = Instance.new("Frame")

    Frame6.Size = UDim2.new(0, 48, 0, 26)
    Frame6.Position = UDim2.new(1, -48, 0.5, -13)
    Frame6.BackgroundColor3 = Color3.fromRGB(60, 60, 67)
    Frame6.BorderSizePixel = 0
    Frame6.Parent = Frame5

    local UICorner6 = Instance.new("UICorner")

    UICorner6.CornerRadius = UDim.new(1, 0)
    UICorner6.Parent = Frame6

    local Frame7 = Instance.new("Frame")

    Frame7.Size = UDim2.new(0, 20, 0, 20)
    Frame7.Position = UDim2.new(0, 3, 0.5, -10)
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame7.BorderSizePixel = 0
    Frame7.Parent = Frame6

    local UICorner7 = Instance.new("UICorner")

    UICorner7.CornerRadius = UDim.new(1, 0)
    UICorner7.Parent = Frame7

    local u147 = false

    local function v148(p15)
        u147 = p15

        if u147 then
            t2.value8(Frame6, {
				BackgroundColor3 = Color3.fromRGB(52, 199, 89)
			}, 0.2):Play()
            t2.value8(Frame7, {
				Position = UDim2.new(0, 25, 0.5, -10)
			}, 0.2):Play()
        else
            t2.value8(Frame6, {
				BackgroundColor3 = Color3.fromRGB(60, 60, 67)
			}, 0.2):Play()
            t2.value8(Frame7, {
				Position = UDim2.new(0, 3, 0.5, -10)
			}, 0.2):Play()
        end

        if p14 then
            p14(u147)
        end
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(1, 0, 1, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.Parent = Frame6
    TextButton.MouseButton1Click:Connect(function()
        v148(not u147)
    end)

    return Frame5, v148
end
t2.value24.FlyHack.MouseButton1Click:Connect(function()
    v32("FlyHack")
end)

function t1.value1(p16, p17)
    local Frame8 = Instance.new("Frame")

    Frame8.Size = UDim2.new(1, 0, 0, p17 or 80)
    Frame8.BackgroundColor3 = Color3.fromRGB(44, 44, 48)
    Frame8.BorderSizePixel = 0
    Frame8.Parent = p16

    local UICorner8 = Instance.new("UICorner")

    UICorner8.CornerRadius = UDim.new(0, 10)
    UICorner8.Parent = Frame8

    return Frame8
end
local function v35(p18, p19)
    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Size = UDim2.new(1, 0, 0, 18)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = p19
    TextLabel5.TextColor3 = Color3.fromRGB(130, 130, 140)
    TextLabel5.TextSize = 11
    TextLabel5.Font = Enum.Font.GothamBold
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.Parent = p18
end
function t2.value25(p20, p21, p22)
    p20.Text = p21
    p20.TextTransparency = 0

    if p22 then
        p22 = Color3.fromRGB(255, 69, 58)
    end

    if not p22 then
        p22 = Color3.fromRGB(52, 199, 89)
    end

    p20.TextColor3 = p22
    task.delay(3, function()
        t2.value8(p20, {
			TextTransparency = 1
		}, 0.5):Play()
        task.wait(0.5)
        p20.Text = ""
        p20.TextTransparency = 0
    end)
end
local SkinChanger2 = t2.value23.SkinChanger
v35(SkinChanger2, "JOGADORES NO SERVIDOR")

local v37 = t1.value1(SkinChanger2, 42)
local TextLabel6 = Instance.new("TextLabel")

TextLabel6.Size = UDim2.new(1, -20, 1, 0)
TextLabel6.Position = UDim2.new(0, 10, 0, 0)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Text = "Clique em um jogador para copiar a skin completa dele"
TextLabel6.TextColor3 = Color3.fromRGB(160, 160, 170)
TextLabel6.TextSize = 12
TextLabel6.Font = Enum.Font.Gotham
TextLabel6.TextWrapped = true
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = v37
local v39 = t1.value1(SkinChanger2, 44)
local Frame9 = Instance.new("Frame")

Frame9.Size = UDim2.new(1, -16, 1, -16)
Frame9.Position = UDim2.new(0, 8, 0, 8)
Frame9.BackgroundTransparency = 1
Frame9.Parent = v39
local UIListLayout4 = Instance.new("UIListLayout")

UIListLayout4.FillDirection = Enum.FillDirection.Horizontal
UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout4.Padding = UDim.new(0, 8)
UIListLayout4.Parent = Frame9
local Frame10 = Instance.new("Frame")

Frame10.Size = UDim2.new(1, -86, 1, 0)
Frame10.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
Frame10.BorderSizePixel = 0
Frame10.Parent = Frame9
local UICorner9 = Instance.new("UICorner")

UICorner9.CornerRadius = UDim.new(0, 8)
UICorner9.Parent = Frame10
t2.value26 = Instance.new("UIStroke")
t2.value26.Color = Color3.fromRGB(70, 70, 78)
t2.value26.Thickness = 1
t2.value26.Parent = Frame10
t2.value27 = Instance.new("TextBox")
t2.value27.Size = UDim2.new(1, -12, 1, 0)
t2.value27.Position = UDim2.new(0, 8, 0, 0)
t2.value27.BackgroundTransparency = 1
t2.value27.PlaceholderText = "Buscar jogador..."
t2.value27.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
t2.value27.Text = ""
t2.value27.TextColor3 = Color3.fromRGB(230, 230, 235)
t2.value27.TextSize = 13
t2.value27.Font = Enum.Font.Gotham
t2.value27.TextXAlignment = Enum.TextXAlignment.Left
t2.value27.ClearTextOnFocus = false
t2.value27.Parent = Frame10
t2.value27.Focused:Connect(function()
    t2.value8(t2.value26, {
		Color = Color3.fromRGB(10, 132, 255)
	}, 0.15):Play()
end)
t2.value27.FocusLost:Connect(function()
    t2.value8(t2.value26, {
		Color = Color3.fromRGB(70, 70, 78)
	}, 0.15):Play()
end)
t2.value28 = Instance.new("TextButton")
t2.value28.Size = UDim2.new(0, 78, 1, 0)
t2.value28.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
t2.value28.BorderSizePixel = 0
t2.value28.Text = "Atualizar"
t2.value28.TextColor3 = Color3.fromRGB(200, 200, 210)
t2.value28.TextSize = 12
t2.value28.Font = Enum.Font.GothamSemibold
t2.value28.AutoButtonColor = false
t2.value28.Parent = Frame9
local UICorner10 = Instance.new("UICorner")

UICorner10.CornerRadius = UDim.new(0, 8)
UICorner10.Parent = t2.value28
t2.value28.MouseEnter:Connect(function()
    t2.value8(t2.value28, {
		BackgroundColor3 = Color3.fromRGB(65, 65, 72)
	}, 0.1):Play()
end)
t2.value28.MouseLeave:Connect(function()
    t2.value8(t2.value28, {
		BackgroundColor3 = Color3.fromRGB(50, 50, 56)
	}, 0.1):Play()
end)

local Frame11 = Instance.new("Frame")

Frame11.Name = "ListContainer"
Frame11.Size = UDim2.new(1, 0, 0, 300)
Frame11.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
Frame11.BorderSizePixel = 0
Frame11.ClipsDescendants = true
Frame11.Parent = SkinChanger2
local UICorner11 = Instance.new("UICorner")

UICorner11.CornerRadius = UDim.new(0, 10)
UICorner11.Parent = Frame11
t2.value29 = Instance.new("ScrollingFrame")
t2.value29.Name = "PlayerList"
t2.value29.Size = UDim2.new(1, 0, 1, 0)
t2.value29.BackgroundTransparency = 1
t2.value29.BorderSizePixel = 0
t2.value29.ScrollBarThickness = 3
t2.value29.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
t2.value29.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value29.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value29.Parent = Frame11
local UIListLayout5 = Instance.new("UIListLayout")

UIListLayout5.FillDirection = Enum.FillDirection.Vertical
UIListLayout5.Padding = UDim.new(0, 2)
UIListLayout5.Parent = t2.value29
local UIPadding3 = Instance.new("UIPadding")

UIPadding3.PaddingLeft = UDim.new(0, 6)
UIPadding3.PaddingRight = UDim.new(0, 6)
UIPadding3.PaddingTop = UDim.new(0, 6)
UIPadding3.PaddingBottom = UDim.new(0, 6)
UIPadding3.Parent = t2.value29
t2.value30 = v33(SkinChanger2)
v35(SkinChanger2, "RESET")

local v49 = t1.value1(SkinChanger2, 50)
local Frame12 = Instance.new("Frame")

Frame12.Size = UDim2.new(1, -20, 1, -16)
Frame12.Position = UDim2.new(0, 10, 0, 8)
Frame12.BackgroundTransparency = 1
Frame12.Parent = v49
local v51 = (function(p23, p24, p25)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(1, 0, 0, 36)

    local v185 = p25

    if not p25 then
        v185 = Color3.fromRGB(10, 132, 255)
    end

    TextButton.BackgroundColor3 = v185
    TextButton.BorderSizePixel = 0
    TextButton.Text = p24
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 13
    TextButton.Font = Enum.Font.GothamSemibold
    TextButton.AutoButtonColor = false
    TextButton.Parent = p23

    local UICorner12 = Instance.new("UICorner")

    UICorner12.CornerRadius = UDim.new(0, 8)
    UICorner12.Parent = TextButton

    if not p25 then
        p25 = Color3.fromRGB(10, 132, 255)
    end

    local v187 = p25

    TextButton.MouseEnter:Connect(function()
        t2.value8(TextButton, {
			BackgroundColor3 = v187:Lerp(Color3.new(1, 1, 1), 0.12)
		}, 0.12):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        t2.value8(TextButton, {
			BackgroundColor3 = v187
		}, 0.12):Play()
    end)
    TextButton.MouseButton1Down:Connect(function()
        t2.value8(TextButton, {
			BackgroundColor3 = v187:Lerp(Color3.new(0, 0, 0), 0.15)
		}, 0.08):Play()
    end)
    TextButton.MouseButton1Up:Connect(function()
        t2.value8(TextButton, {
			BackgroundColor3 = v187
		}, 0.1):Play()
    end)

    return TextButton
end)(Frame12, "Restaurar Minha Skin Original", Color3.fromRGB(255, 69, 58))

v51.Size = UDim2.new(1, 0, 0, 34)
t2.value31 = v33(SkinChanger2)
v51.MouseButton1Click:Connect(function()
    local v188, v189 = SkinChanger.resetSkin()
    local value25 = t2.value25
    local v191 = v188
    local value31 = t2.value31

    if v188 then
        v191 = "Skin restaurada!"
    end

    if not v191 then
        v191 = v189 or "Erro ao restaurar"
    end

    value25(value31, v191, not v188)
end)

function t2.value32(p26)
    local _Instance = Instance
    local v195 = p26 == t2.value5
    local v196 = _Instance.new("TextButton")

    v196.Name = p26.Name
    v196.Size = UDim2.new(1, 0, 0, 52)

    local v197 = v195

    if v195 then
        v197 = Color3.fromRGB(36, 36, 42)
    end

    if not v197 then
        v197 = Color3.fromRGB(40, 40, 46)
    end

    v196.BackgroundColor3 = v197
    v196.BorderSizePixel = 0
    v196.Text = ""
    v196.AutoButtonColor = false
    v196.Parent = t2.value29

    local UICorner13 = Instance.new("UICorner")

    UICorner13.CornerRadius = UDim.new(0, 8)
    UICorner13.Parent = v196

    local Frame13 = Instance.new("Frame")

    Frame13.Size = UDim2.new(0, 38, 0, 38)
    Frame13.Position = UDim2.new(0, 8, 0.5, -19)
    Frame13.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
    Frame13.BorderSizePixel = 0
    Frame13.Parent = v196

    local UICorner14 = Instance.new("UICorner")

    UICorner14.CornerRadius = UDim.new(1, 0)
    UICorner14.Parent = Frame13

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.ScaleType = Enum.ScaleType.Crop
    ImageLabel2.Parent = Frame13
    task.spawn(function()
        local ok, result = pcall(function()
            return t2.value1:GetUserThumbnailAsync(p26.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)

        if ok and result then
            ImageLabel2.Image = result
        end
    end)

    local TextLabel7 = Instance.new("TextLabel")

    TextLabel7.Size = UDim2.new(1, -120, 0, 20)
    TextLabel7.Position = UDim2.new(0, 54, 0.5, -18)
    TextLabel7.BackgroundTransparency = 1
    TextLabel7.Text = p26.DisplayName

    local v203 = v195

    if v195 then
        v203 = Color3.fromRGB(130, 130, 140)
    end

    if not v203 then
        v203 = Color3.fromRGB(230, 230, 238)
    end

    TextLabel7.TextColor3 = v203
    TextLabel7.TextSize = 13
    TextLabel7.Font = Enum.Font.GothamSemibold
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel7.Parent = v196

    local TextLabel8 = Instance.new("TextLabel")

    TextLabel8.Size = UDim2.new(1, -120, 0, 16)
    TextLabel8.Position = UDim2.new(0, 54, 0.5, 2)
    TextLabel8.BackgroundTransparency = 1
    TextLabel8.Text = "@" .. p26.Name .. (not v195 and "" or "  (você)")
    TextLabel8.TextColor3 = Color3.fromRGB(100, 100, 110)
    TextLabel8.TextSize = 11
    TextLabel8.Font = Enum.Font.Gotham
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel8.Parent = v196

    if not v195 then
        local TextButton = Instance.new("TextButton")

        TextButton.Size = UDim2.new(0, 72, 0, 28)
        TextButton.Position = UDim2.new(1, -82, 0.5, -14)
        TextButton.BackgroundColor3 = Color3.fromRGB(10, 132, 255)
        TextButton.BorderSizePixel = 0
        TextButton.Text = "Copiar"
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.TextSize = 12
        TextButton.Font = Enum.Font.GothamSemibold
        TextButton.AutoButtonColor = false
        TextButton.Parent = v196

        local UICorner15 = Instance.new("UICorner")

        UICorner15.CornerRadius = UDim.new(0, 7)
        UICorner15.Parent = TextButton
        TextButton.MouseEnter:Connect(function()
            t2.value8(TextButton, {
				BackgroundColor3 = Color3.fromRGB(30, 152, 255)
			}, 0.1):Play()
        end)
        TextButton.MouseLeave:Connect(function()
            t2.value8(TextButton, {
				BackgroundColor3 = Color3.fromRGB(10, 132, 255)
			}, 0.1):Play()
        end)
        v196.MouseEnter:Connect(function()
            if t2.value7.selectedPlayer ~= p26 then
                t2.value8(v196, {
					BackgroundColor3 = Color3.fromRGB(48, 48, 54)
				}, 0.1):Play()
            end
        end)
        v196.MouseLeave:Connect(function()
            if t2.value7.selectedPlayer ~= p26 then
                t2.value8(v196, {
					BackgroundColor3 = Color3.fromRGB(40, 40, 46)
				}, 0.1):Play()
            end
        end)

        local function v207()
            TextButton.Text = "..."
            TextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 56)

            if t2.value7.selectedPlayer then
                for _, child in ipairs(t2.value29:GetChildren()) do
                    local v257 = child:IsA("TextButton")

                    if v257 then
                        v257 = child.Name == t2.value7.selectedPlayer.Name
                    end

                    if v257 then
                        t2.value8(child, {
							BackgroundColor3 = Color3.fromRGB(40, 40, 46)
						}, 0.12):Play()
                    end
                end
            end

            t2.value7.selectedPlayer = p26
            t2.value8(v196, {
				BackgroundColor3 = Color3.fromRGB(20, 50, 90)
			}, 0.15):Play()
            task.spawn(function()
                local t3, v264 = SkinChanger.copyFromPlayer(p26)
                if t3 then
                    TextButton.Text = "Copiado!"
                    TextButton.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
                    t2.value25(t2.value30, "Skin de " .. p26.DisplayName .. " copiada!")
                else
                    TextButton.Text = "Erro"
                    TextButton.BackgroundColor3 = Color3.fromRGB(255, 69, 58)

                    local value25 = t2.value25
                    local value30 = t2.value30

                    if not v264 then
                        v264 = "Falha ao copiar skin"
                    end

                    value25(value30, v264, true)
                end
                task.wait(2)
                TextButton.Text = "Copiar"
                t2.value8(TextButton, {
					BackgroundColor3 = Color3.fromRGB(10, 132, 255)
				}, 0.2):Play()
            end)
        end

        TextButton.MouseButton1Click:Connect(v207)
        v196.MouseButton1Click:Connect(v207)
    end

    return v196
end
function t2.value33(p27)
    if not p27 then
        p27 = ""
    end
    local v209 = p27:lower()
    for _, child in ipairs(t2.value29:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    t2.value7.playerEntries = {}
    t2.value7.selectedPlayer = nil
    local players = t2.value1:GetPlayers()
    table.sort(players, function(p28, p29)
        if p28 == t2.value5 then
            return true
        end

        if p29 == t2.value5 then
            return false
        end

        return p28.DisplayName:lower() < p29.DisplayName:lower()
    end)
    local n1 = 0
    for v216, v217 in ipairs(players) do

        local v218 = v217.Name:lower()
        local v219 = v217.DisplayName:lower()
        local v220 = v209 == ""

        if not v220 then
            v220 = v218:find(v209, 1, true)

            if not v220 then
                v220 = v219:find(v209, 1, true)
            end
        end

        if v220 then
            t2.value32(v217)
            n1 += 1
        end
    end
    if n1 == 0 then
        local TextLabel9 = Instance.new("TextLabel")

        TextLabel9.Size = UDim2.new(1, 0, 0, 40)
        TextLabel9.BackgroundTransparency = 1
        TextLabel9.Text = "Nenhum jogador encontrado"
        TextLabel9.TextColor3 = Color3.fromRGB(90, 90, 100)
        TextLabel9.TextSize = 13
        TextLabel9.Font = Enum.Font.Gotham
        TextLabel9.Parent = t2.value29
    end
end
t2.value33()
t2.value28.MouseButton1Click:Connect(function()
    t2.value28.Text = "..."
    task.spawn(function()
        t2.value33(t2.value27.Text)
        t2.value28.Text = "Atualizar"
    end)
end)
t2.value27:GetPropertyChangedSignal("Text"):Connect(function()
    t2.value33(t2.value27.Text)
end)
t2.value1.PlayerAdded:Connect(function()
    task.wait(0.5)
    t2.value33(t2.value27.Text)
end)
t2.value1.PlayerRemoving:Connect(function()
    task.wait(0.1)
    t2.value33(t2.value27.Text)
end)

local FlyHack = t2.value23.FlyHack
local v53 = t1.value1(FlyHack, 100)
local Frame14 = Instance.new("Frame")

Frame14.Size = UDim2.new(1, -20, 1, -16)
Frame14.Position = UDim2.new(0, 10, 0, 8)
Frame14.BackgroundTransparency = 1
Frame14.Parent = v53
local Frame15 = Instance.new("Frame")

Frame15.Size = UDim2.new(1, 0, 0, 22)
Frame15.BackgroundTransparency = 1
Frame15.Parent = Frame14
t2.value34 = Instance.new("Frame")
t2.value34.Size = UDim2.new(0, 10, 0, 10)
t2.value34.Position = UDim2.new(0, 0, 0.5, -5)
t2.value34.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
t2.value34.BorderSizePixel = 0
t2.value34.Parent = Frame15
local UICorner16 = Instance.new("UICorner")

UICorner16.CornerRadius = UDim.new(1, 0)
UICorner16.Parent = t2.value34
t2.value35 = Instance.new("TextLabel")
t2.value35.Size = UDim2.new(1, -20, 1, 0)
t2.value35.Position = UDim2.new(0, 18, 0, 0)
t2.value35.BackgroundTransparency = 1
t2.value35.Text = "Fly is DISABLED"
t2.value35.TextColor3 = Color3.fromRGB(160, 160, 170)
t2.value35.TextSize = 13
t2.value35.Font = Enum.Font.Gotham
t2.value35.TextXAlignment = Enum.TextXAlignment.Left
t2.value35.Parent = Frame15
local v57, v58 = v34(Frame14, "Enable Fly Hack", function(p30)
    t2.value7.flyActive = p30

    if p30 then
        t2.value10.start()
        t2.value34.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
        t2.value35.Text = "Fly is ENABLED"
        t2.value35.TextColor3 = Color3.fromRGB(52, 199, 89)

        return
    end

    t2.value10.stop()
    t2.value34.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
    t2.value35.Text = "Fly is DISABLED"
    t2.value35.TextColor3 = Color3.fromRGB(160, 160, 170)
end)

t1.value2 = v57
t1.value3 = v58
t2.value36 = t1.value3
t1.value2.Position = UDim2.new(0, 0, 0, 30)
t1.value2.Parent = Frame14
local TextLabel10 = Instance.new("TextLabel")

TextLabel10.Size = UDim2.new(1, 0, 0, 16)
TextLabel10.Position = UDim2.new(0, 0, 0, 66)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Text = "W/A/S/D = Move   Space = Up   C/Ctrl = Down"
TextLabel10.TextColor3 = Color3.fromRGB(90, 90, 100)
TextLabel10.TextSize = 11
TextLabel10.Font = Enum.Font.Gotham
TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
TextLabel10.Parent = Frame14
local v60 = t1.value1(FlyHack, 72)
local Frame16 = Instance.new("Frame")

Frame16.Size = UDim2.new(1, -20, 1, -16)
Frame16.Position = UDim2.new(0, 10, 0, 8)
Frame16.BackgroundTransparency = 1
Frame16.Parent = v60;
(function(p31, p32, p33, p34, p35, p36)
    local Frame17 = Instance.new("Frame")

    Frame17.Size = UDim2.new(1, 0, 0, 52)
    Frame17.BackgroundTransparency = 1
    Frame17.Parent = p31

    local Frame18 = Instance.new("Frame")

    Frame18.Size = UDim2.new(1, 0, 0, 20)
    Frame18.BackgroundTransparency = 1
    Frame18.Parent = Frame17

    local TextLabel11 = Instance.new("TextLabel")

    TextLabel11.Size = UDim2.new(0.7, 0, 1, 0)
    TextLabel11.BackgroundTransparency = 1
    TextLabel11.Text = p32
    TextLabel11.TextColor3 = Color3.fromRGB(220, 220, 228)
    TextLabel11.TextSize = 13
    TextLabel11.Font = Enum.Font.Gotham
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel11.Parent = Frame18

    local TextLabel12 = Instance.new("TextLabel")

    TextLabel12.Size = UDim2.new(0.3, 0, 1, 0)
    TextLabel12.Position = UDim2.new(0.7, 0, 0, 0)
    TextLabel12.BackgroundTransparency = 1
    TextLabel12.Text = tostring(p35)
    TextLabel12.TextColor3 = Color3.fromRGB(10, 132, 255)
    TextLabel12.TextSize = 13
    TextLabel12.Font = Enum.Font.GothamBold
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel12.Parent = Frame18

    local Frame19 = Instance.new("Frame")

    Frame19.Size = UDim2.new(1, 0, 0, 6)
    Frame19.Position = UDim2.new(0, 0, 0, 30)
    Frame19.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
    Frame19.BorderSizePixel = 0
    Frame19.Parent = Frame17

    local UICorner17 = Instance.new("UICorner")

    UICorner17.CornerRadius = UDim.new(1, 0)
    UICorner17.Parent = Frame19

    local _Instance = Instance
    local v163 = (p35 - p33) / (p34 - p33)
    local v164 = _Instance.new("Frame")

    v164.Size = UDim2.new(v163, 0, 1, 0)
    v164.BackgroundColor3 = Color3.fromRGB(10, 132, 255)
    v164.BorderSizePixel = 0
    v164.Parent = Frame19

    local UICorner18 = Instance.new("UICorner")

    UICorner18.CornerRadius = UDim.new(1, 0)
    UICorner18.Parent = v164

    local Frame20 = Instance.new("Frame")

    Frame20.Size = UDim2.new(0, 18, 0, 18)
    Frame20.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame20.Position = UDim2.new(v163, 0, 0.5, 0)
    Frame20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame20.BorderSizePixel = 0
    Frame20.Parent = Frame19

    local UICorner19 = Instance.new("UICorner")

    UICorner19.CornerRadius = UDim.new(1, 0)
    UICorner19.Parent = Frame20

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(0, 0, 0)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.7
    UIStroke.Parent = Frame20

    local u169 = false

    local function v170(p37)
        local AbsolutePosition = Frame19.AbsolutePosition
        local AbsoluteSize = Frame19.AbsoluteSize
        local v247 = math.clamp((p37 - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)
        local v248 = math.floor(p33 + (p34 - p33) * v247)

        v164.Size = UDim2.new(v247, 0, 1, 0)
        Frame20.Position = UDim2.new(v247, 0, 0.5, 0)
        TextLabel12.Text = tostring(v248)

        if p36 then
            p36(v248)
        end
    end

    Frame19.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            u169 = true
            v170(input.Position.X)
        end
    end)
    t2.value3.InputChanged:Connect(function(input)
        local v251 = u169

        if v251 then
            v251 = input.UserInputType == Enum.UserInputType.MouseMovement
        end

        if v251 then
            v170(input.Position.X)
        end
    end)
    t2.value3.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        end
    end)

    return Frame17
end)(Frame16, "Fly Speed", 10, 300, 50, function(p38)
    t2.value7.flySpeed = p38
end)

local v62 = t1.value1(FlyHack, 58)

t2.value37 = Instance.new("Frame")
t2.value37.Size = UDim2.new(1, -20, 1, -16)
t2.value37.Position = UDim2.new(0, 10, 0, 8)
t2.value37.BackgroundTransparency = 1
t2.value37.Parent = v62
local UIListLayout6 = Instance.new("UIListLayout")

UIListLayout6.FillDirection = Enum.FillDirection.Horizontal
UIListLayout6.Padding = UDim.new(0, 8)
UIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout6.Parent = t2.value37
local function v64(p39, p40)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0.48, 0, 0, 36)
    TextButton.BackgroundColor3 = p40
    TextButton.BorderSizePixel = 0
    TextButton.Text = p39
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12
    TextButton.Font = Enum.Font.GothamSemibold
    TextButton.AutoButtonColor = false
    TextButton.Parent = t2.value37

    local UICorner20 = Instance.new("UICorner")

    UICorner20.CornerRadius = UDim.new(0, 8)
    UICorner20.Parent = TextButton

    return TextButton
end
local v65 = v64("Up +50", Color3.fromRGB(48, 209, 88))
local v66 = v64("Down -50", Color3.fromRGB(255, 149, 0))

v65.MouseButton1Click:Connect(function()
    local Character7 = t2.value5.Character

    if Character7 then
        local HumanoidRootPart = Character7:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
        end
    end
end)
v66.MouseButton1Click:Connect(function()
    local Character8 = t2.value5.Character

    if Character8 then
        local HumanoidRootPart = Character8:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - Vector3.new(0, 50, 0)
        end
    end
end)

local v67 = t1.value1(FlyHack, 50)
local Frame21 = Instance.new("Frame")

Frame21.Size = UDim2.new(1, -20, 1, -16)
Frame21.Position = UDim2.new(0, 10, 0, 8)
Frame21.BackgroundTransparency = 1
Frame21.Parent = v67
v34(Frame21, "Enable NoClip (walk through walls)", function(p41)
    t2.value7.noclipActive = p41

    if p41 then
        t2.value7.noclipLoop = t2.value2.Stepped:Connect(function()
            local Character9 = t2.value5.Character

            if not Character9 then
                return
            end

            for _, descendant in ipairs(Character9:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                end
            end
        end)

        return
    end

    v5()
end)

local v69 = t1.value1(FlyHack, 56)
local TextLabel13 = Instance.new("TextLabel")

TextLabel13.Size = UDim2.new(1, -20, 1, -12)
TextLabel13.Position = UDim2.new(0, 10, 0, 6)
TextLabel13.BackgroundTransparency = 1
TextLabel13.Text = "Use responsibly. Abuse may result in account suspension."
TextLabel13.TextColor3 = Color3.fromRGB(255, 149, 0)
TextLabel13.TextSize = 11
TextLabel13.Font = Enum.Font.Gotham
TextLabel13.TextWrapped = true
TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
TextLabel13.Parent = v69
v32("FlyHack")
t2.value5.CharacterAdded:Connect(function(character)
    t2.value6 = character
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    pcall(t2.value9)

    if t2.value7.flyActive then
        t2.value7.flyActive = false
        t2.value10.stop()
        t2.value36(false)
        t2.value34.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
        t2.value35.Text = "Fly is DISABLED"
        t2.value35.TextColor3 = Color3.fromRGB(160, 160, 170)
    end
end)
t2.value13.Size = UDim2.new(0, 0, 0, 0)
t2.value13.Position = UDim2.new(0.5, 0, 0.5, 0)

local value8 = t2.value8
local value13 = t2.value13
local uDim2 = UDim2.new(0, 460, 0, 560)
local uDim2_3 = UDim2.new(0.5, -230, 0.5, -280)

value8(value13, {
	Size = uDim2,
	Position = uDim2_3
}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
print("[Bananao Hub v2.0] Carregado. Jogadores no servidor: " .. #t2.value1:GetPlayers())
t2.value38 = true
t2.value3.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    local v236 = input.KeyCode == Enum.KeyCode.LeftAlt

    if not v236 then
        v236 = input.KeyCode == Enum.KeyCode.RightAlt
    end

    if v236 then
        t2.value38 = not t2.value38

        if t2.value38 then
            t2.value12.Enabled = true
            t2.value13.Size = UDim2.new(0, 0, 0, 0)
            t2.value8(t2.value13, {
				Size = UDim2.new(0, 460, 0, 560)
			}, 0.25):Play()

            return
        end

        local v237 = t2.value8(t2.value13, {
			Size = UDim2.new(0, 0, 0, 0)
		}, 0.25)

        v237:Play()
        v237.Completed:Wait()
        t2.value12.Enabled = false
    end
end)
