local __gh_35215b9ef2a962bd=function(t,k)local o={} for i=1,#t do o[i]=string.char(bit32.bxor(t[i],k)) end return table.concat(o) end;
local Players = game:GetService(__gh_35215b9ef2a962bd({121,69,72,80,76,91,90},41))
local TweenService = game:GetService(__gh_35215b9ef2a962bd({125,94,76,76,71,122,76,91,95,64,74,76},41))
local RunService = game:GetService(__gh_35215b9ef2a962bd({123,92,71,122,76,91,95,64,74,76},41))

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild(__gh_35215b9ef2a962bd({97,92,68,72,71,70,64,77,123,70,70,93,121,72,91,93},41))
local PlayerGui = player:WaitForChild(__gh_35215b9ef2a962bd({121,69,72,80,76,91,110,92,64},41))


local screenGui = Instance.new(__gh_35215b9ef2a962bd({122,74,91,76,76,71,110,92,64},41))
screenGui.Name = __gh_35215b9ef2a962bd({101,70,72,77,64,71,78,122,74,91,76,76,71},41)
screenGui.Parent = PlayerGui

local frame = Instance.new(__gh_35215b9ef2a962bd({111,91,72,68,76},41))
frame.Size = UDim2.new(1,0,1,0)
frame.Position = UDim2.new(0,0,0,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local loadingText = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,101,72,75,76,69},41))
loadingText.Size = UDim2.new(0,400,0,50)
loadingText.Position = UDim2.new(0.5,-200,0.35,0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 36
loadingText.Text = __gh_35215b9ef2a962bd({113,100,70,77,77,76,77,9,121,91,76,68,64,92,68,9,123,110,107},41)
loadingText.TextColor3 = Color3.fromRGB(255,0,0)
loadingText.Parent = frame

local progressBar = Instance.new(__gh_35215b9ef2a962bd({111,91,72,68,76},41))
progressBar.Size = UDim2.new(0,0,0,20)
progressBar.Position = UDim2.new(0.5,-150,0.5,0)
progressBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
progressBar.BorderSizePixel = 0
progressBar.Parent = frame

local timeText = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,101,72,75,76,69},41))
timeText.Size = UDim2.new(0,300,0,50)
timeText.Position = UDim2.new(0.5,-150,0.45,30)
timeText.BackgroundTransparency = 1
timeText.TextColor3 = Color3.fromRGB(255,255,255)
timeText.Font = Enum.Font.SourceSansBold
timeText.TextScaled = true
timeText.Text = __gh_35215b9ef2a962bd({28,19,25,25},41)
timeText.Parent = frame

local skipButton = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,107,92,93,93,70,71},41))
skipButton.Size = UDim2.new(0,120,0,50)
skipButton.Position = UDim2.new(0.5,-60,0.55,60)
skipButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
skipButton.TextColor3 = Color3.fromRGB(255,255,255)
skipButton.Text = __gh_35215b9ef2a962bd({122,98,96,121},41)
skipButton.Font = Enum.Font.SourceSansBold
skipButton.TextScaled = true
skipButton.Parent = frame

local skip = false
skipButton.MouseButton1Click:Connect(function()
skip = true
end)


spawn(function()
local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255)}
local index = 1
while frame.Parent do
loadingText.TextColor3 = colors[index]
progressBar.BackgroundColor3 = colors[index]
index = index + 1
if index > #colors then index = 1 end
wait(0.3)
end
end)


local totalTime = 300
for i = 0,totalTime do
if skip then break end
wait(1)
local percent = i/totalTime
progressBar.Size = UDim2.new(percent,0,0,20)
local remaining = totalTime - i
local minutes = math.floor(remaining/60)
local seconds = remaining % 60
timeText.Text = string.format(__gh_35215b9ef2a962bd({12,77,19,12,25,27,77},41), minutes, seconds)
end

frame:Destroy()


local savedPosition = nil
local uiVisible = true

local ScreenGui = Instance.new(__gh_35215b9ef2a962bd({122,74,91,76,76,71,110,92,64},41))
ScreenGui.Name = __gh_35215b9ef2a962bd({125,76,69,76,110,92,64,72,77,70},41)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new(__gh_35215b9ef2a962bd({111,91,72,68,76},41))
Frame.Size = UDim2.new(0, 280, 0, 160)
Frame.Position = UDim2.new(0.5, -140, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new(__gh_35215b9ef2a962bd({124,96,106,70,91,71,76,91},41), Frame).CornerRadius = UDim.new(0, 12)


local Title = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,101,72,75,76,69},41))
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = __gh_35215b9ef2a962bd({125,108,101,108,110,124,96,104,109,102,9,107,112,7,110,104,107},41)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold


local CloseButton = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,107,92,93,93,70,71},41))
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.Text = __gh_35215b9ef2a962bd({203,181,191},41)
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame
Instance.new(__gh_35215b9ef2a962bd({124,96,106,70,91,71,76,91},41), CloseButton).CornerRadius = UDim.new(0, 10)


local SaveButton = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,107,92,93,93,70,71},41))
SaveButton.Parent = Frame
SaveButton.Size = UDim2.new(0.8, 0, 0, 40)
SaveButton.Position = UDim2.new(0.1, 0, 0.45, 0)
SaveButton.Text = __gh_35215b9ef2a962bd({122,104,101,127,104,123,9,121,102,122,96,234,174,234,170,102},41)
SaveButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.TextScaled = true
SaveButton.Font = Enum.Font.GothamBold
Instance.new(__gh_35215b9ef2a962bd({124,96,106,70,91,71,76,91},41), SaveButton).CornerRadius = UDim.new(0, 8)

local TeleportButton = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,107,92,93,93,70,71},41))
TeleportButton.Parent = Frame
TeleportButton.Size = UDim2.new(0.8, 0, 0, 40)
TeleportButton.Position = UDim2.new(0.1, 0, 0.75, 0)
TeleportButton.Text = __gh_35215b9ef2a962bd({125,108,101,108,121,102,123,125},41)
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextScaled = true
TeleportButton.Font = Enum.Font.GothamBold
Instance.new(__gh_35215b9ef2a962bd({124,96,106,70,91,71,76,91},41), TeleportButton).CornerRadius = UDim.new(0, 8)

local MiniButton = Instance.new(__gh_35215b9ef2a962bd({125,76,81,93,107,92,93,93,70,71},41))
MiniButton.Size = UDim2.new(0, 60, 0, 40)
MiniButton.Position = UDim2.new(0, 20, 1, -60)
MiniButton.Text = __gh_35215b9ef2a962bd({203,177,153},41)
MiniButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextScaled = true
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Visible = false
MiniButton.Parent = ScreenGui
Instance.new(__gh_35215b9ef2a962bd({124,96,106,70,91,71,76,91},41), MiniButton).CornerRadius = UDim.new(0, 10)


SaveButton.MouseButton1Click:Connect(function()
character = player.Character or player.CharacterAdded:Wait()
humanoidRoot = character:WaitForChild(__gh_35215b9ef2a962bd({97,92,68,72,71,70,64,77,123,70,70,93,121,72,91,93},41))
savedPosition = humanoidRoot.Position
SaveButton.Text = __gh_35215b9ef2a962bd({121,102,122,96,234,174,234,170,102,9,122,104,101,127,104,9,203,181,172},41)
task.wait(1)
SaveButton.Text = __gh_35215b9ef2a962bd({122,104,101,127,104,123,9,121,102,122,96,234,174,234,170,102},41)
end)

TeleportButton.MouseButton1Click:Connect(function()
if not savedPosition then
TeleportButton.Text = __gh_35215b9ef2a962bd({103,108,103,97,124,100,104,9,121,102,122,96,234,174,234,170,102},41)
task.wait(1)
TeleportButton.Text = __gh_35215b9ef2a962bd({125,108,101,108,121,102,123,125},41)
return
end
character = player.Character or player.CharacterAdded:Wait()
humanoidRoot = character:WaitForChild(__gh_35215b9ef2a962bd({97,92,68,72,71,70,64,77,123,70,70,93,121,72,91,93},41))
local tween = TweenService:Create(
humanoidRoot,
TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
{CFrame = CFrame.new(savedPosition + Vector3.new(0, 5, 0))}
)
tween:Play()
end)


task.spawn(function()
while task.wait(0.05) do
local t = tick() * 2
local r = math.sin(t) * 0.5 + 0.5
local g = math.sin(t + 2) * 0.5 + 0.5
local b = math.sin(t + 4) * 0.5 + 0.5
Title.TextColor3 = Color3.new(r, g, b)
end
end)


CloseButton.MouseButton1Click:Connect(function()
uiVisible = false
Frame.Visible = false
MiniButton.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
uiVisible = true
MiniButton.Visible = false
Frame.Visible = true
end)