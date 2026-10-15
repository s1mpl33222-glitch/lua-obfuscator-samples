-- This file was generated at discord.gg/syncrypt

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Parent = Lighting
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2000000
ScreenGui.Parent = PlayerGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromScale(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(0, 320, 0, 180)
Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame2.Position = UDim2.fromScale(0.5, 0.5)
Frame2.BackgroundTransparency = 1
Frame2.Parent = Frame
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(0, 64, 0, 64)
Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
Frame3.Position = UDim2.fromScale(0.5, 0.3)
Frame3.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame2
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame3
local Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(0, 28, 0, 28)
Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
Frame4.Position = UDim2.fromScale(0.5, 0.5)
Frame4.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
Frame4.Rotation = 45
Frame4.BorderSizePixel = 0
Frame4.Parent = Frame3
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = Frame4
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0.52, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 20
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.Text = "Loading"
TextLabel.Parent = Frame2
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(1, 0, 0, 20)
TextLabel2.Position = UDim2.new(0, 0, 0.68, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.TextColor3 = Color3.fromRGB(140, 150, 170)
TextLabel2.TextSize = 13
TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
TextLabel2.Parent = Frame2
local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(0, 220, 0, 6)
Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
Frame5.Position = UDim2.fromScale(0.5, 0.88)
Frame5.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
Frame5.BorderSizePixel = 0
Frame5.Parent = Frame2
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = Frame5
local Frame6 = Instance.new("Frame")
Frame6.Size = UDim2.new(0, 0, 1, 0)
Frame6.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
Frame6.BorderSizePixel = 0
Frame6.Parent = Frame5
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = Frame6
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 200)
UIStroke.Transparency = 0.5
UIStroke.Parent = Frame6
local connection = RunService.RenderStepped:Connect(function(dt)
    Frame3.Rotation = Frame3.Rotation + dt * 45
end)
local thread = task.spawn(function()
    local n1 = 0

    while true do
        n1 = (n1 + 1) % 4
        TextLabel.Text = "Loading" .. string.rep(".", n1)
        task.wait(0.5)
    end
end)
local function v22()
    if connection then
        connection:Disconnect()
    end

    ScreenGui:Destroy()
    BlurEffect:Destroy()
end
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TextLabel2.Text = "Preparing..."
TweenService:Create(Frame6, tweenInfo, {
	Size = UDim2.new(0.5, 0, 1, 0)
}):Play()
task.wait(1.3)
TextLabel2.Text = "Checking Game..."
TweenService:Create(Frame6, tweenInfo, {
	Size = UDim2.new(1, 0, 1, 0)
}):Play()
task.wait(1.4)
task.cancel(thread)
if game.GameId ~= 10766691148 then
    TextLabel.Text = "Error!"
    TextLabel2.Text = "Invalid Game"
    TextLabel2.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(2.5)
    v22()

    return false
end
TextLabel.Text = "Success!"
TextLabel2.Text = "Game confirmed"
TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 200)
task.wait(1.5)
local v24 = getgenv and getgenv()
if not v24 then
    v24 = _G or shared
end
local str = tostring(game.GameId)
local v26 = "_PASS_" .. tostring(game.PlaceId)
local u27 = "STK_" .. str .. v26
function v24.__STK_VERIFY__()
    return u27
end
v22()
return true
