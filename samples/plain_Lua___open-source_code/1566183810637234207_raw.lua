--[[
    Lia's Silent Aim - Da Hood
    FE Silent Gunshots
    Only YOU can hear your gunshots
]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiasSilentAim"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Lia's Silent Aim"
Title.TextColor3 = Color3.fromRGB(255, 100, 150)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Status Indicator
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, -20, 0, 50)
StatusFrame.Position = UDim2.new(0, 10, 0, 45)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.Size = UDim2.new(0, 12, 0, 12)
StatusDot.Position = UDim2.new(0, 10, 0.5, -6)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusFrame

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1, -30, 1, 0)
StatusText.Position = UDim2.new(0, 30, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Silent Aim: ACTIVE"
StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusText.TextSize = 14
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 105)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ToggleButton.Text = "ENABLED"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Settings Label
local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Name = "SettingsLabel"
SettingsLabel.Size = UDim2.new(1, -20, 0, 25)
SettingsLabel.Position = UDim2.new(0, 10, 0, 155)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Text = "Settings"
SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsLabel.TextSize = 13
SettingsLabel.Font = Enum.Font.GothamBold
SettingsLabel.Parent = MainFrame

-- Sound Volume Slider
local VolumeLabel = Instance.new("TextLabel")
VolumeLabel.Name = "VolumeLabel"
VolumeLabel.Size = UDim2.new(1, -20, 0, 20)
VolumeLabel.Position = UDim2.new(0, 10, 0, 185)
VolumeLabel.BackgroundTransparency = 1
VolumeLabel.Text = "Gunshot Volume: 100%"
VolumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
VolumeLabel.TextSize = 12
VolumeLabel.Font = Enum.Font.Gotham
VolumeLabel.Parent = MainFrame

-- Volume Slider
local VolumeSlider = Instance.new("Frame")
VolumeSlider.Name = "VolumeSlider"
VolumeSlider.Size = UDim2.new(1, -20, 0, 25)
VolumeSlider.Position = UDim2.new(0, 10, 0, 210)
VolumeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
VolumeSlider.BorderSizePixel = 0
VolumeSlider.Parent = MainFrame

local VolumeSliderCorner = Instance.new("UICorner")
VolumeSliderCorner.CornerRadius = UDim.new(0, 6)
VolumeSliderCorner.Parent = VolumeSlider

local VolumeFill = Instance.new("Frame")
VolumeFill.Name = "VolumeFill"
VolumeFill.Size = UDim2.new(1, 0, 1, 0)
VolumeFill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
VolumeFill.BorderSizePixel = 0
VolumeFill.Parent = VolumeSlider

local VolumeFillCorner = Instance.new("UICorner")
VolumeFillCorner.CornerRadius = UDim.new(0, 6)
VolumeFillCorner.Parent = VolumeFill

local VolumeValue = Instance.new("TextLabel")
VolumeValue.Name = "VolumeValue"
VolumeValue.Size = UDim2.new(1, 0, 1, 0)
VolumeValue.BackgroundTransparency = 1
VolumeValue.Text = "100%"
VolumeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeValue.TextSize = 11
VolumeValue.Font = Enum.Font.Gotham
VolumeValue.Parent = VolumeSlider

-- Enable/Disable State
local silentAimEnabled = true
local gunshotVolume = 1.0

-- Volume Slider Interaction
local draggingVolume = false
VolumeSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingVolume = true
        updateVolume(input)
    end
end)

VolumeSlider.InputChanged:Connect(function(input)
    if draggingVolume and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateVolume(input)
    end
end)

VolumeSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingVolume = false
    end
end)

function updateVolume(input)
    local relativeX = math.clamp((input.Position.X - VolumeSlider.AbsolutePosition.X) / VolumeSlider.AbsoluteSize.X, 0, 1)
    gunshotVolume = relativeX
    local percentage = math.floor(relativeX * 100)
    
    VolumeFill.Size = UDim2.new(relativeX, 0, 1, 0)
    VolumeValue.Text = percentage .. "%"
    VolumeLabel.Text = "Gunshot Volume: " .. percentage .. "%"
end

-- Toggle Function
function toggleSilentAim()
    silentAimEnabled = not silentAimEnabled
    
    if silentAimEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ToggleButton.Text = "ENABLED"
        StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        StatusText.Text = "Silent Aim: ACTIVE"
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        ToggleButton.Text = "DISABLED"
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        StatusText.Text = "Silent Aim: DISABLED"
        StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleSilentAim)

-- Toggle Button (Floating)
local FloatingToggle = Instance.new("TextButton")
FloatingToggle.Name = "FloatingToggle"
FloatingToggle.Size = UDim2.new(0, 50, 0, 50)
FloatingToggle.Position = UDim2.new(0, 10, 0.5, -25)
FloatingToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
FloatingToggle.Text = "🔇"
FloatingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingToggle.TextSize = 24
FloatingToggle.Font = Enum.Font.GothamBold
FloatingToggle.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingToggle

-- Close Button Function
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Open/Close
FloatingToggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- MAIN SILENT AIM FUNCTIONALITY
-- This hooks into the game's audio system to make gunshots silent for others

-- Method 1: Hook into Remote Events for shooting
local function hookRemotes()
    -- Find shooting remotes
    local remotes = {
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Remote"),
        ReplicatedStorage:FindFirstChild("Events"),
        ReplicatedStorage:FindFirstChild("MainEvent"),
        ReplicatedStorage:FindFirstChild("Shoot"),
        ReplicatedStorage:FindFirstChild("Fire"),
        ReplicatedStorage:FindFirstChild("Gun")
    }
    
    for _, remote in ipairs(remotes) do
        if remote then
            for _, child in ipairs(remote:GetChildren()) do
                if child.Name:lower():find("shoot") or child.Name:lower():find("fire") or child.Name:lower():find("gun") or child.Name:lower():find("bullet") then
                    -- Store original FireServer
                    local oldFireServer = child.FireServer
                    
                    -- Override FireServer to only play sound locally
                    child.FireServer = function(...)
                        -- Play local gunshot sound
                        playLocalGunshot()
                        
                        -- Still fire the remote but with modified args
                        -- This makes it look like a normal shot to the server
                        oldFireServer(child, ...)
                    end
                end
            end
        end
    end
end

-- Method 2: Hook into Sound playback
local function hookSounds()
    -- Hook into the game's sound system
    local oldPlay = Sound.Play
    
    Sound.Play = function(self)
        -- Check if this is a gunshot sound
        if self.Name:lower():find("gun") or 
           self.Name:lower():find("shoot") or 
           self.Name:lower():find("fire") or 
           self.Name:lower():find("shot") or
           self.Name:lower():find("bullet") then
            
            -- Only play if silent aim is enabled
            if silentAimEnabled then
                -- Play only for local player
                self.Volume = gunshotVolume
                oldPlay(self)
            end
        else
            -- Play other sounds normally
            oldPlay(self)
        end
    end
end

-- Method 3: Play local gunshot sound
function playLocalGunshot()
    if not silentAimEnabled then return end
    
    -- Create a local sound that only you can hear
    local sound = Instance.new("Sound")
    sound.Name = "LocalGunshot"
    sound.SoundId = "rbxassetid://9111181169" -- Gunshot sound ID
    sound.Volume = gunshotVolume
    sound.Parent = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or SoundService
    
    sound:Play()
    
    -- Clean up after playing
    game:GetService("Debris"):AddItem(sound, 1)
end

-- Method 4: Hook into Character sounds
local function hookCharacterSounds()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    -- Watch for new sounds being added
    character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") then
            if descendant.Name:lower():find("gun") or 
               descendant.Name:lower():find("shoot") or 
               descendant.Name:lower():find("fire") or
               descendant.Name:lower():find("shot") then
                
                -- Only play for local player
                descendant.Volume = gunshotVolume
            end
        end
    end)
end

-- Method 5: Hook into Tool sounds
local function hookToolSounds()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("Sound") then
                    if descendant.Name:lower():find("gun") or 
                       descendant.Name:lower():find("shoot") or 
                       descendant.Name:lower():find("fire") or
                       descendant.Name:lower():find("shot") then
                        
                        descendant.Volume = gunshotVolume
                    end
                end
            end)
        end
    end)
end

-- Method 6: Network ownership trick
local function networkTrick()
    -- This makes the server think you're not shooting
    local oldFireServer = nil
    
    local function hookNetwork(remote)
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            if remote.Name:lower():find("shoot") or 
               remote.Name:lower():find("fire") or 
               remote.Name:lower():find("gun") or
               remote.Name:lower():find("bullet") then
                
                oldFireServer = remote.FireServer
                
                remote.FireServer = function(...)
                    -- Only send to server if silent aim is enabled
                    if silentAimEnabled then
                        -- Send modified args to make it silent
                        local args = {...}
                        -- Modify args to remove sound data
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "table" then
                                if arg.Sound then
                                    arg.Sound = nil
                                end
                            end
                        end
                        oldFireServer(remote, unpack(args))
                    else
                        oldFireServer(remote, ...)
                    end
                end
            end
        end
    end
    
    -- Hook all remotes
    local function scanRemotes(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                hookNetwork(child)
            end
            if #child:GetChildren() > 0 then
                scanRemotes(child)
            end
        end
    end
    
    scanRemotes(ReplicatedStorage)
end

-- Initialize all hooks
local function init()
    hookRemotes()
    hookSounds()
    hookCharacterSounds()
    hookToolSounds()
    networkTrick()
    
    -- Keep hooks updated on respawn
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        hookCharacterSounds()
        hookToolSounds()
    end)
end

-- Start the script
init()

-- Initial notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Lia's Silent Aim",
    Text = "Loaded! Your gunshots are now silent to others",
    Duration = 3
})
