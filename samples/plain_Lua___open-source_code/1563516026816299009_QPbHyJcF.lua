-- SantinoKlaseV1 (God Mode + Infinite Stamina)
-- Compatible with Xeno Executor | Upper-Left Placement

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local oldGui = PlayerGui:FindFirstChild("SantinoKlaseV1")
if oldGui then
    oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SantinoKlaseV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local GodModeBtn = Instance.new("TextButton")
local StaminaBtn = Instance.new("TextButton")

-- GUI Settings
ScreenGui.Name = "SantinoKlaseV1"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 10) -- Upper Left Corner
MainFrame.Size = UDim2.new(0, 210, 0, 130)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "SantinoKlaseV1"
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold Text
Title.TextSize = 15.000

-- Godmode Button
GodModeBtn.Name = "GodModeBtn"
GodModeBtn.Parent = MainFrame
GodModeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GodModeBtn.BorderSizePixel = 0
GodModeBtn.Position = UDim2.new(0.07, 0, 0.28, 0)
GodModeBtn.Size = UDim2.new(0.86, 0, 0.3, 0)
GodModeBtn.Font = Enum.Font.SourceSansBold
GodModeBtn.Text = "GODMODE: OFF"
GodModeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
GodModeBtn.TextSize = 14.000

-- Infinite Stamina Button
StaminaBtn.Name = "StaminaBtn"
StaminaBtn.Parent = MainFrame
StaminaBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StaminaBtn.BorderSizePixel = 0
StaminaBtn.Position = UDim2.new(0.07, 0, 0.63, 0)
StaminaBtn.Size = UDim2.new(0.86, 0, 0.3, 0)
StaminaBtn.Font = Enum.Font.SourceSansBold
StaminaBtn.Text = "INF STAMINA: OFF"
StaminaBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
StaminaBtn.TextSize = 14.000

-- Logic Variables
local godModeActive = false
local staminaActive = false
local LocalPlayer = game.Players.LocalPlayer

-- GodMode Functionality
local function enableGodMode()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if godModeActive and humanoid then
                humanoid.Health = math.huge
            end
        end)
    end
end

GodModeBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    
    if godModeActive then
        GodModeBtn.Text = "GODMODE: ON"
        GodModeBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
        enableGodMode()
    else
        GodModeBtn.Text = "GODMODE: OFF"
        GodModeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").MaxHealth = 100
            char:FindFirstChildOfClass("Humanoid").Health = 100
        end
    end
end)

-- Infinite Stamina Functionality (Universal Hooking)
local function applyStamina()
    task.spawn(function()
        while staminaActive do
            task.wait(0.1)
            -- Hanapin ang stamina attributes o values sa character/player
            local char = LocalPlayer.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        if string.find(string.lower(obj.Name), "stamina") or string.find(string.lower(obj.Name), "energy") then
                            obj.Value = 100
                        end
                    end
                end
            end
            
            for _, obj in ipairs(LocalPlayer:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    if string.find(string.lower(obj.Name), "stamina") or string.find(string.lower(obj.Name), "energy") then
                        obj.Value = 100
                    end
                end
            end
        end
    end)
end

StaminaBtn.MouseButton1Click:Connect(function()
    staminaActive = not staminaActive
    
    if staminaActive then
        StaminaBtn.Text = "INF STAMINA: ON"
        StaminaBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
        applyStamina()
    else
        StaminaBtn.Text = "INF STAMINA: OFF"
        StaminaBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Auto Re-apply kapag nag-respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if godModeActive then
        enableGodMode()
    end
    if staminaActive then
        applyStamina()
    end
end)