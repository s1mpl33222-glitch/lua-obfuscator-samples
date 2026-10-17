-- NAVAHUB - CLICKER SIMULATOR CUSTOM SCRIPT (Delta Executor Compatible)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Clean up previous UI if exists
if CoreGui:FindFirstChild("NavahubClickerSimUI") then
    CoreGui.NavahubClickerSimUI:Destroy()
end

-- Toggles & Settings State
local State = {
    AutoClick = false,
    AutoRebirth = false,
    AutoHatch = false,
    WalkSpeed = 16,
    JumpPower = 50
}

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NavahubClickerSimUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame Design
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Title Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CLICKER SIM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Close Button ❌
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "❌"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize/Hide Button —
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Floating Open Toggle (When Hidden)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 80, 0, 30)
OpenBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "OPEN UI"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.FredokaOne
OpenBtn.TextSize = 12
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 6)
OpenCorner.Parent = OpenBtn

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    OpenBtn.Visible = isMinimized
end)

OpenBtn.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Container for Options
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -90)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- Helper Function for Custom Toggles
local function CreateToggle(name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 18
    Label.Font = Enum.Font.FredokaOne
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 28, 0, 28)
    Button.Position = UDim2.new(1, -30, 0.5, -14)
    Button.BackgroundColor3 = default and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(30, 30, 30)
    Button.Text = default and "✓" or ""
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button

    local toggled = default
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        Button.BackgroundColor3 = toggled and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(30, 30, 30)
        Button.Text = toggled and "✓" or ""
        callback(toggled)
    end)
end

-- Helper Function for Sliders
local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 18
    Label.Font = Enum.Font.FredokaOne
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 70, 0, 28)
    Box.Position = UDim2.new(1, -70, 0.5, -14)
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Box.Text = tostring(default)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 16
    Box.Font = Enum.Font.FredokaOne
    Box.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    Box.FocusLost:Connect(function()
        local val = tonumber(Box.Text)
        if val then
            val = math.clamp(val, min, max)
            Box.Text = tostring(val)
            callback(val)
        else
            Box.Text = tostring(default)
        end
    end)
end

-- Adding Features
CreateToggle("Auto Clicker", false, function(v) State.AutoClick = v end)
CreateToggle("Auto Rebirth", false, function(v) State.AutoRebirth = v end)
CreateToggle("Auto Hatch Eggs", false, function(v) State.AutoHatch = v end)

CreateSlider("Walk Speed", 16, 200, 16, function(v) 
    State.WalkSpeed = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

CreateSlider("Jump Power", 50, 300, 50, function(v) 
    State.JumpPower = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

-- Footer Watermark
local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, 0, 0, 35)
FooterLabel.Position = UDim2.new(0, 0, 1, -35)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "YouTube: Navahub"
FooterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterLabel.TextSize = 20
FooterLabel.Font = Enum.Font.FredokaOne
FooterLabel.Parent = MainFrame

-- WalkSpeed & JumpPower Loop
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.WalkSpeed
        if State.JumpPower > 50 then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = State.JumpPower
        end
    end
end)

-- 1. Auto Clicker Loop
task.spawn(function()
    while task.wait(0.05) do
        if State.AutoClick then
            pcall(function()
                local clickEvent = ReplicatedStorage:FindFirstChild("Click", true) 
                    or ReplicatedStorage:FindFirstChild("Tap", true) 
                    or ReplicatedStorage:FindFirstChild("Clicker", true)
                
                if clickEvent and clickEvent:IsA("RemoteEvent") then
                    clickEvent:FireServer()
                elseif clickEvent and clickEvent:IsA("RemoteFunction") then
                    clickEvent:InvokeServer()
                end
            end)
        end
    end
end)

-- 2. Auto Rebirth Loop
task.spawn(function()
    while task.wait(0.3) do
        if State.AutoRebirth then
            pcall(function()
                local rebirthEvent = ReplicatedStorage:FindFirstChild("Rebirth", true) 
                    or ReplicatedStorage:FindFirstChild("BuyRebirth", true)
                
                if rebirthEvent and rebirthEvent:IsA("RemoteEvent") then
                    rebirthEvent:FireServer(1)
                elseif rebirthEvent and rebirthEvent:IsA("RemoteFunction") then
                    rebirthEvent:InvokeServer(1)
                end
            end)
        end
    end
end)

-- 3. Auto Hatch Eggs Loop
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoHatch then
            pcall(function()
                local hatchEvent = ReplicatedStorage:FindFirstChild("Hatch", true) 
                    or ReplicatedStorage:FindFirstChild("BuyEgg", true) 
                    or ReplicatedStorage:FindFirstChild("OpenEgg", true)
                
                if hatchEvent and hatchEvent:IsA("RemoteEvent") then
                    hatchEvent:FireServer("Starter", 1)
                elseif hatchEvent and hatchEvent:IsA("RemoteFunction") then
                    hatchEvent:InvokeServer("Starter", 1)
                end
            end)
        end
    end
end)