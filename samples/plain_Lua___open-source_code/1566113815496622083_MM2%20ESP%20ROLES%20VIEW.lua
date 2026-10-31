local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local roles = {}
local Murder = ""
local Sheriff = ""
local Hero = ""
local ESP_Enabled = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local DragDetector = Instance.new("Frame")

ScreenGui.Name = "MM2_ViewESP"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = false

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.BackgroundTransparency = 0.3
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "MM2 View ESP ROLES"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Position = UDim2.new(0.5, -50, 0.5, -15)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Enable"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)

DragDetector.Name = "DragDetector"
DragDetector.Parent = MainFrame
DragDetector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DragDetector.BackgroundTransparency = 1
DragDetector.Size = UDim2.new(1, 0, 0, 25)
DragDetector.Position = UDim2.new(0, 0, 0, 0)
DragDetector.Active = true

local dragging = false
local dragStart = nil
local startPos = nil

DragDetector.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

DragDetector.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        MainFrame.Position = newPos
    end
end)

function CreateHighlight()
    if not ESP_Enabled then return end
    for i, v in pairs(Players:GetChildren()) do
        if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight", v.Character)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 1
        end
    end
end

function UpdateHighlights()
    if not ESP_Enabled then return end
    for _, v in pairs(Players:GetChildren()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
            local Highlight = v.Character:FindFirstChild("Highlight")
            local isAlive = IsAlive(v.Name)
            
            if v.Name == Sheriff and isAlive then
                Highlight.FillColor = Color3.fromRGB(0, 0, 225)
            elseif v.Name == Murder and isAlive then
                Highlight.FillColor = Color3.fromRGB(225, 0, 0)
            elseif v.Name == Hero and isAlive and not IsAlive(Sheriff) then
                Highlight.FillColor = Color3.fromRGB(255, 250, 0)
            elseif isAlive then
                Highlight.FillColor = Color3.fromRGB(0, 225, 0)
            else
                Highlight.FillColor = Color3.fromRGB(100, 100, 100)
            end
            
            if not isAlive then
                Highlight.FillTransparency = 0.7
            else
                Highlight.FillTransparency = 0.5
            end
        end
    end
end

function IsAlive(playerName)
    for name, data in pairs(roles) do
        if name == playerName then
            if not data.Killed and not data.Dead then
                return true
            else
                return false
            end
        end
    end
    return false
end

function ClearAllHighlights()
    for _, v in pairs(Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("Highlight") then
            v.Character:FindFirstChild("Highlight"):Destroy()
        end
    end
end

local function ToggleESP()
    ESP_Enabled = not ESP_Enabled
    
    if ESP_Enabled then
        ToggleButton.Text = "Disable"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        if not _G.ESP_Loop_Running then
            _G.ESP_Loop_Running = true
            coroutine.wrap(function()
                while ESP_Enabled do
                    local success, err = pcall(function()
                        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
                        for i, v in pairs(roles) do
                            if v.Role == "Murderer" then
                                Murder = i
                            elseif v.Role == 'Sheriff' then
                                Sheriff = i
                            elseif v.Role == 'Hero' then
                                Hero = i
                            end
                        end
                        CreateHighlight()
                        UpdateHighlights()
                    end)
                    if not success then
                    end
                    RunService.RenderStepped:Wait()
                end
                _G.ESP_Loop_Running = false
                ClearAllHighlights()
            end)()
        end
    else
        ToggleButton.Text = "Enable"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ClearAllHighlights()
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleESP)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        ToggleESP()
    end
end)

ClearAllHighlights()

Players.PlayerAdded:Connect(function()
    if ESP_Enabled then
    end
end)

 print("MM2 VIEW ROLES SCRIPT FREE KEYLESS!!!")