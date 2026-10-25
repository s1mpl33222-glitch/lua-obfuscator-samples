-- Glass Bridge ESP with Toggle UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui for the toggle button
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BridgeESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 140, 0, 50)
toggleButton.Position = UDim2.new(0, 50, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "ESP: OFF"
toggleButton.Parent = screenGui

-- Make the button draggable or just clickable
local espEnabled = false

local function removeESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local highlight = obj:FindFirstChild("BridgeESP")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

local function createESP(part, color)
    if not part:FindFirstChild("BridgeESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "BridgeESP"
        highlight.Adornee = part
        highlight.FillColor = color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.Parent = part
    end
end

local function scanBridge()
    if not espEnabled then return end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("glass") or name:find("step") or name:find("platform") or name:find("tile") then
                if obj.Transparency > 0.5 or obj.CanCollide == false then
                    createESP(obj, Color3.fromRGB(255, 0, 0)) -- Red for fake
                else
                    createESP(obj, Color3.fromRGB(0, 255, 0)) -- Green for safe
                end
            end
        end
    end
end

-- Button click event to toggle ESP on/off
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.Text = "ESP: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        toggleButton.Text = "ESP: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        removeESP()
    end
end)

-- Background loop running the scanner
task.spawn(function()
    while true do
        if espEnabled then
            pcall(scanBridge)
        end
        task.wait(0.5)
    end
end)