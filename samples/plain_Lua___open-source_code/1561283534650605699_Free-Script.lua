local CoreGui = game:GetService("CoreGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "StevCommunityBanner"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

pcall(function()
    Gui.Parent = CoreGui
end)

if not Gui.Parent then
    Gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(1, 0, 0, 30)
Discord.Position = UDim2.new(0, 0, 0, 5)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/stevcommunity"
Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
Discord.Font = Enum.Font.SourceSans
Discord.TextSize = 22
Discord.TextXAlignment = Enum.TextXAlignment.Center
Discord.Parent = Gui

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 25)
Info.Position = UDim2.new(0, 0, 0, 35)
Info.BackgroundTransparency = 1
Info.Text = "This script is free, if you paid for it, you were scammed."
Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.SourceSans
Info.TextSize = 17
Info.TextXAlignment = Enum.TextXAlignment.Center
Info.Parent = Gui

-- Loader original
local Source = game:HttpGet(
    "https://pastefy.app/kYJpa027/raw?t=" .. tostring(tick())
)

local Execute = loadstring or load
assert(Execute, "loadstring/load no está disponible en este executor")

Execute(Source)()
