-- This file was generated at discord.gg/syncrypt

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lib = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
lib.service = "hub"
lib.identifier = "1034017"
lib.provider = "any"
local function v5(p1, p2, p3)
    return TweenService:Create(p1, TweenInfo.new(p3 or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p2)
end
local t1 = {
	["bg"] = Color3.fromRGB(10, 10, 10),
	["panel"] = Color3.fromRGB(15, 15, 15),
	["el"] = Color3.fromRGB(20, 20, 20),
	["elHov"] = Color3.fromRGB(28, 28, 28),
	["st"] = Color3.fromRGB(38, 38, 38),
	["acc"] = Color3.fromRGB(220, 80, 140),
	["accD"] = Color3.fromRGB(160, 50, 100),
	["btn"] = Color3.fromRGB(100, 150, 10),
	["btnD"] = Color3.fromRGB(35, 80, 170),
	["btnH"] = Color3.fromRGB(70, 130, 240),
	["tx"] = Color3.fromRGB(255, 255, 255),
	["txd"] = Color3.fromRGB(170, 170, 170),
	["txk"] = Color3.fromRGB(70, 70, 70),
	["ok"] = Color3.fromRGB(90, 195, 120),
	["err"] = Color3.fromRGB(205, 75, 75)
}
if CoreGui:FindFirstChild("LunedHub_Key") then
    CoreGui.LunedHub_Key:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunedHub_Key"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = CoreGui
CoreGui = function(input)
    local UIStroke = Instance.new("UIStroke", input)

    UIStroke.Color = Color3.fromRGB(0, 0, 0)
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    UIStroke.Transparency = 0.5
end
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromOffset(380, 220)
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = t1.bg
Frame.BorderSizePixel = 0
Frame.ZIndex = 10
local Frame2 = Instance.new("Frame", Frame)
Frame2.Size = UDim2.fromOffset(380, 220)
Frame2.Position = UDim2.fromOffset(0, 0)
Frame2.BackgroundColor3 = t1.bg
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 11
Frame2.ClipsDescendants = true
local Frame3 = Instance.new("Frame", Frame2)
Frame3.Size = UDim2.new(1, 0, 0, 30)
Frame3.BackgroundColor3 = t1.panel
Frame3.BorderSizePixel = 0
Frame3.ZIndex = 12
local Frame4 = Instance.new("Frame", Frame2)
Frame4.Size = UDim2.new(1, 0, 0, 1)
Frame4.Position = UDim2.fromOffset(0, 30)
Frame4.BackgroundColor3 = t1.acc
Frame4.BorderSizePixel = 0
Frame4.ZIndex = 12
Frame4 = Instance.new("TextLabel", Frame3)
Frame4.Size = UDim2.new(1, -12, 1, 0)
Frame4.Position = UDim2.fromOffset(12, 0)
Frame4.BackgroundTransparency = 1
Frame4.Font = Enum.Font.GothamBold
Frame4.Text = "LUNED HUB"
Frame4.TextColor3 = t1.tx
Frame4.TextSize = 13
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.ZIndex = 13
CoreGui(Frame4)
Frame4 = Instance.new("TextLabel", Frame3)
Frame4.Size = UDim2.new(1, -12, 1, 0)
Frame4.BackgroundTransparency = 1
Frame4.Font = Enum.Font.GothamBold
Frame4.Text = "Input"
Frame4.TextColor3 = t1.tx
Frame4.TextSize = 12
Frame4.TextXAlignment = Enum.TextXAlignment.Right
Frame4.ZIndex = 13
CoreGui(Frame4)
Frame4 = Instance.new("TextLabel", Frame2)
Frame4.Size = UDim2.new(1, -24, 0, 24)
Frame4.Position = UDim2.fromOffset(12, 40)
Frame4.BackgroundTransparency = 1
Frame4.Font = Enum.Font.GothamBold
Frame4.Text = "Enter your key to continue"
Frame4.TextColor3 = t1.tx
Frame4.TextSize = 13
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.ZIndex = 12
CoreGui(Frame4)
local Frame5 = Instance.new("Frame", Frame2)
Frame5.Size = UDim2.new(1, -24, 0, 32)
Frame5.Position = UDim2.fromOffset(12, 70)
Frame5.BackgroundColor3 = t1.st
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 12
local Frame6 = Instance.new("Frame", Frame5)
Frame6.Size = UDim2.new(1, -2, 1, -2)
Frame6.Position = UDim2.fromOffset(1, 1)
Frame6.BackgroundColor3 = t1.el
Frame6.BorderSizePixel = 0
Frame6.ZIndex = 13
Frame6 = Instance.new("TextBox", Frame6)
Frame6.Size = UDim2.new(1, -16, 1, 0)
Frame6.Position = UDim2.fromOffset(10, 0)
Frame6.BackgroundTransparency = 1
Frame6.Text = ""
Frame6.PlaceholderText = "Paste your key here..."
Frame6.PlaceholderColor3 = t1.txk
Frame6.Font = Enum.Font.Gotham
Frame6.TextColor3 = t1.tx
Frame6.TextSize = 13
Frame6.BorderSizePixel = 0
Frame6.ClearTextOnFocus = false
Frame6.ZIndex = 14
Frame6.Focused:Connect(function()
    v5(Frame5, {
		["BackgroundColor3"] = t1.acc
	}, 0.15):Play()
end)
Frame6.FocusLost:Connect(function()
    v5(Frame5, {
		["BackgroundColor3"] = t1.st
	}, 0.15):Play()
end)
Frame5 = Instance.new("Frame", Frame2)
Frame5.Size = UDim2.new(1, -24, 0, 2)
Frame5.Position = UDim2.fromOffset(12, 104)
Frame5.BackgroundColor3 = t1.el
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 12
Frame5.Visible = false
local Frame7 = Instance.new("Frame", Frame5)
Frame7.Size = UDim2.fromScale(0, 1)
Frame7.BackgroundColor3 = t1.acc
Frame7.BorderSizePixel = 0
Frame7.ZIndex = 13
Instance.new("UIGradient", Frame7).Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.accD), ColorSequenceKeypoint.new(1, t1.acc) })
local TextButton = Instance.new("TextButton", Frame2)
TextButton.Size = UDim2.new(1, -24, 0, 32)
TextButton.Position = UDim2.fromOffset(12, 112)
TextButton.BackgroundColor3 = t1.btn
TextButton.BorderSizePixel = 0
TextButton.Font = Enum.Font.GothamBold
TextButton.Text = "CHECK KEY"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextSize = 13
TextButton.AutoButtonColor = false
TextButton.ZIndex = 12
CoreGui(TextButton)
Instance.new("UIGradient", TextButton).Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.btnD), ColorSequenceKeypoint.new(1, t1.btn) })
TextButton.MouseEnter:Connect(function()
    v5(TextButton, {
		["BackgroundColor3"] = t1.btnH
	}, 0.15):Play()
end)
TextButton.MouseLeave:Connect(function()
    v5(TextButton, {
		["BackgroundColor3"] = t1.btn
	}, 0.15):Play()
end)
local n1 = 175
local function v18(p4, p5)
    local Frame8 = Instance.new("Frame", Frame2)

    Frame8.Size = UDim2.fromOffset(n1, 30)
    Frame8.Position = UDim2.fromOffset(p5, 154)
    Frame8.BackgroundColor3 = t1.el
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 12

    local Frame9 = Instance.new("Frame", Frame8)

    Frame9.Size = UDim2.new(1, 0, 0, 1)
    Frame9.Position = UDim2.fromOffset(0, 0)
    Frame9.BackgroundColor3 = t1.st
    Frame9.BorderSizePixel = 0
    Frame9.ZIndex = 13
    Frame9 = Instance.new("TextButton", Frame8)
    Frame9.Size = UDim2.fromScale(1, 1)
    Frame9.BackgroundTransparency = 1
    Frame9.Font = Enum.Font.GothamBold
    Frame9.Text = p4
    Frame9.TextColor3 = t1.tx
    Frame9.TextSize = 12
    Frame9.AutoButtonColor = false
    Frame9.ZIndex = 13
    CoreGui(Frame9)

    local function v21()
        v5(Frame8, {
			["BackgroundColor3"] = t1.elHov
		}, 0.12):Play()
    end

    Frame9.MouseEnter:Connect(v21)
    Frame9.MouseLeave:Connect(function()
        v5(Frame8, {
			["BackgroundColor3"] = t1.el
		}, 0.12):Play()
    end)

    return Frame8, Frame9
end
local value = select(2, v18("GET KEY", 12))
v18 = select(2, v18("DISCORD", 12 + n1 + 6))
local Frame8 = Instance.new("Frame", Frame2)
Frame8.Size = UDim2.fromOffset(1, 30)
Frame8.Position = UDim2.fromOffset(12 + n1, 154)
Frame8.BackgroundColor3 = t1.st
Frame8.BorderSizePixel = 0
Frame8.ZIndex = 13
n1 = Instance.new("Frame", Frame2)
n1.Size = UDim2.new(1, 0, 0, 1)
n1.Position = UDim2.fromOffset(0, 185)
n1.BackgroundColor3 = t1.st
n1.BorderSizePixel = 0
n1.ZIndex = 12
Frame2 = Instance.new("TextLabel", Frame2)
Frame2.Size = UDim2.new(1, 0, 0, 34)
Frame2.Position = UDim2.fromOffset(0, 186)
Frame2.BackgroundTransparency = 1
Frame2.Font = Enum.Font.GothamBold
Frame2.Text = "discord.gg/lunedhub  |  by shutka1"
Frame2.TextColor3 = t1.tx
Frame2.TextSize = 11
Frame2.TextXAlignment = Enum.TextXAlignment.Center
Frame2.ZIndex = 12
CoreGui(Frame2)
local u24 = false
local Position
local Position2
Frame3.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    u24 = true
    Position = input.Position
    Position2 = Frame.Position
end)
Frame3.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    u24 = false
end)
CoreGui = function(p6)
    local v27 = u24

    if v27 then
        v27 = p6.UserInputType == Enum.UserInputType.MouseMovement
    end

    if not v27 then
        return
    end

    v27 = p6.Position - Position
    Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v27.X, Position2.Y.Scale, Position2.Y.Offset + v27.Y)
end
UserInputService.InputChanged:Connect(CoreGui)
CoreGui = function(p7, p8)
    Frame4.Text = p7
    Frame4.TextColor3 = p8 or t1.tx
end
CoreGui = function(p9)
    if p9 == "" then
        return
    end

    TextButton.Text = "CHECKING..."
    CoreGui("Checking key, please wait...", t1.txd)
    Frame5.Visible = true
    Frame7.Size = UDim2.fromScale(0, 1)

    local valid = TweenService
    local v29 = Frame7
    local tweenInfo = TweenInfo.new(1.6, Enum.EasingStyle.Linear)
    local UDim2_ = UDim2

    valid.Create(valid, v29, tweenInfo, {
		["Size"] = UDim2_.fromScale(1, 1)
	}):Play()
    task.wait(1.8)
    Frame5.Visible = false
    valid = lib.check_key(p9)

    if not valid then
        if valid then
            writefile("LunedHub_Key.txt", p9)
            CoreGui("Key valid! Loading...", t1.ok)
            TextButton.Text = "VALID"
            v5(TextButton, {
				["BackgroundColor3"] = Color3.fromRGB(40, 150, 80)
			}, 0.2):Play()
            task.wait(1)
            getgenv().SCRIPT_KEY = p9
            loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/fda9ed2378dfa7846ce80589fb34b44cf332c8d66cb38ec9d659aeb6449c6e25/download"))()
            ScreenGui:Destroy()

            return
        else
            CoreGui("Invalid or expired key!", t1.err)
            TextButton.Text = "CHECK KEY"
            v5(TextButton, {
				["BackgroundColor3"] = t1.err
			}, 0.1):Play()
            task.wait(0.35)
            v5(TextButton, {
				["BackgroundColor3"] = t1.btn
			}, 0.2):Play()

            return
        end

        return
    end

    valid = valid.valid

    if valid then
        writefile("LunedHub_Key.txt", p9)
        CoreGui("Key valid! Loading...", t1.ok)
        TextButton.Text = "VALID"
        v5(TextButton, {
			["BackgroundColor3"] = Color3.fromRGB(40, 150, 80)
		}, 0.2):Play()
        task.wait(1)
        getgenv().SCRIPT_KEY = p9
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/fda9ed2378dfa7846ce80589fb34b44cf332c8d66cb38ec9d659aeb6449c6e25/download"))()
        ScreenGui:Destroy()

        return
    else
        CoreGui("Invalid or expired key!", t1.err)
        TextButton.Text = "CHECK KEY"
        v5(TextButton, {
			["BackgroundColor3"] = t1.err
		}, 0.1):Play()
        task.wait(0.35)
        v5(TextButton, {
			["BackgroundColor3"] = t1.btn
		}, 0.2):Play()

        return
    end
end
TextButton.MouseButton1Click:Connect(function()
    CoreGui(Frame6.Text)
end)
Frame6.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        return
    end

    CoreGui(Frame6.Text)
end)
value.MouseButton1Click:Connect(function()
    setclipboard("https://jnkie.com/overview/shutka")
    value.Text = "COPIED"
    task.wait(1.5)
    value.Text = "GET KEY"
end)
v18.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/lunedhub")
    v18.Text = "COPIED"
    task.wait(1.5)
    v18.Text = "DISCORD"
end)
if not isfile("LunedHub_Key.txt") then
    return
end
TweenService = readfile("LunedHub_Key.txt")
if TweenService == "" then
    return
end
Frame6.Text = TweenService
task.spawn(CoreGui, TweenService)
