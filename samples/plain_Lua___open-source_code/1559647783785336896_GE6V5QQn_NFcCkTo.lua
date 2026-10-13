local __gh_cc9da7c277a13dd3=function(t,k)local o={} for i=1,#t do o[i]=string.char(bit32.bxor(t[i],k)) end return table.concat(o) end;
local Players = game:GetService(__gh_cc9da7c277a13dd3({114,78,67,91,71,80,81},34))
local TweenService = game:GetService(__gh_cc9da7c277a13dd3({118,85,71,71,76,113,71,80,84,75,65,71},34))
local RunService = game:GetService(__gh_cc9da7c277a13dd3({112,87,76,113,71,80,84,75,65,71},34))

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild(__gh_cc9da7c277a13dd3({106,87,79,67,76,77,75,70,112,77,77,86,114,67,80,86},34))
local PlayerGui = player:WaitForChild(__gh_cc9da7c277a13dd3({114,78,67,91,71,80,101,87,75},34))


local screenGui = Instance.new(__gh_cc9da7c277a13dd3({113,65,80,71,71,76,101,87,75},34))
screenGui.Name = __gh_cc9da7c277a13dd3({110,77,67,70,75,76,69,113,65,80,71,71,76},34)
screenGui.Parent = PlayerGui

local frame = Instance.new(__gh_cc9da7c277a13dd3({100,80,67,79,71},34))
frame.Size = UDim2.new(1,0,1,0)
frame.Position = UDim2.new(0,0,0,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local loadingText = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,110,67,64,71,78},34))
loadingText.Size = UDim2.new(0,400,0,50)
loadingText.Position = UDim2.new(0.5,-200,0.35,0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 36
loadingText.Text = __gh_cc9da7c277a13dd3({122,111,77,70,70,71,70,2,114,80,71,79,75,87,79,2,112,101,96},34)
loadingText.TextColor3 = Color3.fromRGB(255,0,0)
loadingText.Parent = frame

local progressBar = Instance.new(__gh_cc9da7c277a13dd3({100,80,67,79,71},34))
progressBar.Size = UDim2.new(0,0,0,20)
progressBar.Position = UDim2.new(0.5,-150,0.5,0)
progressBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
progressBar.BorderSizePixel = 0
progressBar.Parent = frame

local timeText = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,110,67,64,71,78},34))
timeText.Size = UDim2.new(0,300,0,50)
timeText.Position = UDim2.new(0.5,-150,0.45,30)
timeText.BackgroundTransparency = 1
timeText.TextColor3 = Color3.fromRGB(255,255,255)
timeText.Font = Enum.Font.SourceSansBold
timeText.TextScaled = true
timeText.Text = __gh_cc9da7c277a13dd3({23,24,18,18},34)
timeText.Parent = frame

local skipButton = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,96,87,86,86,77,76},34))
skipButton.Size = UDim2.new(0,120,0,50)
skipButton.Position = UDim2.new(0.5,-60,0.55,60)
skipButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
skipButton.TextColor3 = Color3.fromRGB(255,255,255)
skipButton.Text = __gh_cc9da7c277a13dd3({113,105,107,114},34)
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
timeText.Text = string.format(__gh_cc9da7c277a13dd3({7,70,24,7,18,16,70},34), minutes, seconds)
end

frame:Destroy()


local savedPosition = nil
local uiVisible = true

local ScreenGui = Instance.new(__gh_cc9da7c277a13dd3({113,65,80,71,71,76,101,87,75},34))
ScreenGui.Name = __gh_cc9da7c277a13dd3({118,71,78,71,101,87,75,67,70,77},34)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new(__gh_cc9da7c277a13dd3({100,80,67,79,71},34))
Frame.Size = UDim2.new(0, 280, 0, 160)
Frame.Position = UDim2.new(0.5, -140, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new(__gh_cc9da7c277a13dd3({119,107,97,77,80,76,71,80},34), Frame).CornerRadius = UDim.new(0, 12)


local Title = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,110,67,64,71,78},34))
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = __gh_cc9da7c277a13dd3({118,103,110,103,101,119,107,99,102,109,2,96,123,12,101,99,96},34)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold


local CloseButton = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,96,87,86,86,77,76},34))
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.Text = __gh_cc9da7c277a13dd3({192,190,180},34)
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame
Instance.new(__gh_cc9da7c277a13dd3({119,107,97,77,80,76,71,80},34), CloseButton).CornerRadius = UDim.new(0, 10)


local SaveButton = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,96,87,86,86,77,76},34))
SaveButton.Parent = Frame
SaveButton.Size = UDim2.new(0.8, 0, 0, 40)
SaveButton.Position = UDim2.new(0.1, 0, 0.45, 0)
SaveButton.Text = __gh_cc9da7c277a13dd3({113,99,110,116,99,112,2,114,109,113,107,225,165,225,161,109},34)
SaveButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.TextScaled = true
SaveButton.Font = Enum.Font.GothamBold
Instance.new(__gh_cc9da7c277a13dd3({119,107,97,77,80,76,71,80},34), SaveButton).CornerRadius = UDim.new(0, 8)

local TeleportButton = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,96,87,86,86,77,76},34))
TeleportButton.Parent = Frame
TeleportButton.Size = UDim2.new(0.8, 0, 0, 40)
TeleportButton.Position = UDim2.new(0.1, 0, 0.75, 0)
TeleportButton.Text = __gh_cc9da7c277a13dd3({118,103,110,103,114,109,112,118},34)
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextScaled = true
TeleportButton.Font = Enum.Font.GothamBold
Instance.new(__gh_cc9da7c277a13dd3({119,107,97,77,80,76,71,80},34), TeleportButton).CornerRadius = UDim.new(0, 8)

local MiniButton = Instance.new(__gh_cc9da7c277a13dd3({118,71,90,86,96,87,86,86,77,76},34))
MiniButton.Size = UDim2.new(0, 60, 0, 40)
MiniButton.Position = UDim2.new(0, 20, 1, -60)
MiniButton.Text = __gh_cc9da7c277a13dd3({192,186,146},34)
MiniButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextScaled = true
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Visible = false
MiniButton.Parent = ScreenGui
Instance.new(__gh_cc9da7c277a13dd3({119,107,97,77,80,76,71,80},34), MiniButton).CornerRadius = UDim.new(0, 10)


SaveButton.MouseButton1Click:Connect(function()
character = player.Character or player.CharacterAdded:Wait()
humanoidRoot = character:WaitForChild(__gh_cc9da7c277a13dd3({106,87,79,67,76,77,75,70,112,77,77,86,114,67,80,86},34))
savedPosition = humanoidRoot.Position
SaveButton.Text = __gh_cc9da7c277a13dd3({114,109,113,107,225,165,225,161,109,2,113,99,110,116,99,2,192,190,167},34)
task.wait(1)
SaveButton.Text = __gh_cc9da7c277a13dd3({113,99,110,116,99,112,2,114,109,113,107,225,165,225,161,109},34)
end)

TeleportButton.MouseButton1Click:Connect(function()
if not savedPosition then
TeleportButton.Text = __gh_cc9da7c277a13dd3({108,103,108,106,119,111,99,2,114,109,113,107,225,165,225,161,109},34)
task.wait(1)
TeleportButton.Text = __gh_cc9da7c277a13dd3({118,103,110,103,114,109,112,118},34)
return
end
character = player.Character or player.CharacterAdded:Wait()
humanoidRoot = character:WaitForChild(__gh_cc9da7c277a13dd3({106,87,79,67,76,77,75,70,112,77,77,86,114,67,80,86},34))
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