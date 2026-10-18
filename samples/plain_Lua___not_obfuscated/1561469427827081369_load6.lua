-- =============================================================================
-- COMPACT 3-MINUTE PREMIUM EXECUTION HUD (98% STUCK - BOLD TEXT & EXTRA LABELS)
-- PLACE THIS INSIDE A LOCALSCRIPT IN "ReplicatedFirst"
-- =============================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui", 10)

if not game:IsLoaded() then
	pcall(function()
		ReplicatedFirst:RemoveDefaultLoadingScreen()
	end)
end

-- ==========================================
-- 1. BASE SYSTEM & BACKGROUND DESIGN
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProfileLoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999 -- Forced top priority layer
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundTransparency = 1 -- Transparent full-screen background; keep only the loading panel visible
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- No full-screen gradient or camera blur, so the game world stays visible.
local blur = nil

local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

local function spawnParticle()
	local p = Instance.new("Frame")
	local size = math.random(2, 4)
	p.Size = UDim2.new(0, size, 0, size)
	p.Position = UDim2.new(math.random(), 0, 1.1, 0)
	p.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	p.BackgroundTransparency = math.random(4, 7) / 10
	p.BorderSizePixel = 0
	p.Parent = particleContainer
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = p

	TweenService:Create(p, TweenInfo.new(math.random(4, 6), Enum.EasingStyle.Linear), {
		Position = UDim2.new(p.Position.X.Scale, math.random(-40, 40), -0.1, 0),
		BackgroundTransparency = 1
	}):Play()
	
	task.delay(6, function() p:Destroy() end)
end

-- ==========================================
-- 2. COMPACT MAIN CENTER PANEL
-- ==========================================
local centerPanel = Instance.new("Frame")
centerPanel.Size = UDim2.new(0, 360, 0, 250)
centerPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
centerPanel.AnchorPoint = Vector2.new(0.5, 0.5)
centerPanel.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
centerPanel.BackgroundTransparency = 0.15 -- Background only inside the loading panel
centerPanel.BorderSizePixel = 0
centerPanel.Parent = mainFrame

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = centerPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(0, 170, 255)
panelStroke.Thickness = 1.5
panelStroke.Transparency = 0.3
panelStroke.Parent = centerPanel

-- Subtle gradient background INSIDE the panel only.
local panelGradient = Instance.new("UIGradient")
panelGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 34, 54)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(13, 20, 34)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 28, 46))
})
panelGradient.Rotation = 35
panelGradient.Parent = centerPanel

-- Hide / restore intro screen control.
-- The small restore button stays visible when the loading panel is hidden.
local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreLoadingScreenButton"
restoreButton.Size = UDim2.new(0, 42, 0, 36)
restoreButton.Position = UDim2.new(1, -18, 1, -18)
restoreButton.AnchorPoint = Vector2.new(1, 1)
restoreButton.BackgroundColor3 = Color3.fromRGB(16, 28, 46)
restoreButton.BackgroundTransparency = 0.05
restoreButton.BorderSizePixel = 0
restoreButton.Text = "+"
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 24
restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreButton.Visible = false
restoreButton.ZIndex = 20
restoreButton.Parent = mainFrame

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 8)
restoreCorner.Parent = restoreButton

local restoreStroke = Instance.new("UIStroke")
restoreStroke.Color = Color3.fromRGB(0, 170, 255)
restoreStroke.Thickness = 1.5
restoreStroke.Parent = restoreButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "HideLoadingScreenButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 24)
minimizeButton.Position = UDim2.new(1, -8, 0, 6)
minimizeButton.AnchorPoint = Vector2.new(1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
minimizeButton.BackgroundTransparency = 0.1
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.AutoButtonColor = true
minimizeButton.ZIndex = 10
minimizeButton.Parent = centerPanel

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

minimizeButton.Activated:Connect(function()
    centerPanel.Visible = false
    restoreButton.Visible = true
end)

restoreButton.Activated:Connect(function()
    centerPanel.Visible = true
    restoreButton.Visible = false
end)

-- WATERMARK TEXT (MADE BY MÀRK L.)
local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(0.5, 0, 0, 20)
watermarkLabel.Position = UDim2.new(0, 12, 0, 8)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "Star Hub"
watermarkLabel.Font = Enum.Font.GothamMedium
watermarkLabel.TextSize = 10
watermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.TextTransparency = 0.65
watermarkLabel.Parent = centerPanel

-- ==========================================
-- 3. THE AVATAR PROFILE CIRCLE SYSTEM
-- ==========================================
local profileCircle = Instance.new("Frame")
profileCircle.Size = UDim2.new(0, 75, 0, 75)
profileCircle.Position = UDim2.new(0.5, 0, 0.28, 0)
profileCircle.AnchorPoint = Vector2.new(0.5, 0.5)
profileCircle.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
profileCircle.BorderSizePixel = 0
profileCircle.Parent = centerPanel

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = profileCircle

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(0, 255, 170)
circleStroke.Thickness = 2
circleStroke.Parent = profileCircle

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0.92, 0, 0.92, 0)
avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
avatarImage.BackgroundTransparency = 1
avatarImage.Parent = profileCircle

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

local success, content = pcall(function()
	return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if success then avatarImage.Image = content end

-- ==========================================
-- 4. TYPOGRAPHY & INTERFACE LABELS
-- ==========================================
-- Warning Text (GINAWANG MATABA / ULTRA BOLD)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.88, 0, 0, 35)
infoLabel.Position = UDim2.new(0.5, 0, 0.54, 0)
infoLabel.AnchorPoint = Vector2.new(0.5, 0.5)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "PLEASE WAIT UNTIL LOADING COMPLETES TO RUN THE SCRIPT"
infoLabel.Font = Enum.Font.GothamBlack -- Pinakamataba at makapal na font sa Roblox
infoLabel.TextSize = 11 -- Pinalaki nang kaunti para mas solid tingnan
infoLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Premium Gold/Yellow
infoLabel.TextWrapped = true
infoLabel.Parent = centerPanel

local infoStroke = Instance.new("UIStroke")
infoStroke.Color = Color3.fromRGB(0, 0, 0)
infoStroke.Thickness = 1.5 -- Mas kinapalan ang stroke para lumabas ang katabaan
infoStroke.Parent = infoLabel

-- Status Logs (ITINAAS KUNTI - Mula 0.67 ginawang 0.63)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.63, 0) 
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Initializing environmental pipeline..."
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 9.5
statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
statusLabel.Parent = centerPanel

-- MALIIT NA "LOADING..." TEXT SA TAAS NG % (WALANG PAGBABAGO SAKTONG POSISYON)
local miniLoadingLabel = Instance.new("TextLabel")
miniLoadingLabel.Size = UDim2.new(1, 0, 0, 15)
miniLoadingLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
miniLoadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
miniLoadingLabel.BackgroundTransparency = 1
miniLoadingLabel.Text = "Loading..."
miniLoadingLabel.Font = Enum.Font.GothamBold
miniLoadingLabel.TextSize = 9 
miniLoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
miniLoadingLabel.Parent = centerPanel

-- Percentage Display (ITINAAS KUNTI - Mula 0.81 ginawang 0.79)
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 0, 20)
percentLabel.Position = UDim2.new(0, 0, 0.79, 0) 
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.Font = Enum.Font.Code
percentLabel.TextSize = 13
percentLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
percentLabel.Parent = centerPanel

-- ==========================================
-- 5. PROGRESS BAR SYSTEM
-- ==========================================
local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0.85, 0, 0, 4)
barTrack.Position = UDim2.new(0.075, 0, 0.70, 0) -- Hindi ginalaw para walang pagbago sa loading bar
barTrack.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
barTrack.BorderSizePixel = 0
barTrack.Parent = centerPanel

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barTrack

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
barFill.BorderSizePixel = 0
barFill.Parent = barTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 170))
})
fillGradient.Parent = barFill

-- DISCORD CALLOUT (PINAKABABA SA GITNA)
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, 0, 0, 15)
discordLabel.Position = UDim2.new(0.5, 0, 0.94, 0)
discordLabel.AnchorPoint = Vector2.new(0.5, 0.5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "Join https://discord.gg/TSEyf9gt4V"
discordLabel.Font = Enum.Font.Code
discordLabel.TextSize = 10.5
discordLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
discordLabel.Parent = centerPanel

-- ==========================================
-- 6. LOADING PROGRESS (NO PERMANENT 98% FREEZE)
-- ==========================================
local loopConnection = RunService.Heartbeat:Connect(function()
	if math.random() < 0.04 then spawnParticle() end
	local pulse = (math.sin(tick() * 4) + 1) / 2
	circleStroke.Transparency = 0.1 + (pulse * 0.4)
	panelStroke.Transparency = 0.2 + (pulse * 0.3)
end)

-- Pop-In Intro Animation
centerPanel.Size = UDim2.new(0, 300, 0, 210)
TweenService:Create(centerPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 360, 0, 250)
}):Play()

local customPhrases = {
	"Preparing game assets...",
	"Loading environment...",
	"Setting up player profile...",
	"Finishing interface...",
	"Almost ready..."
}

local TARGET_TIME = 180 -- Exactly 3 minutes (180 seconds)
local startTime = os.clock()

-- Animate for exactly 3 minutes, then complete at 100%.
while true do
	local elapsed = os.clock() - startTime
	local progress = math.clamp(elapsed / TARGET_TIME, 0, 1)
	local percent = math.floor(progress * 100)

	TweenService:Create(barFill, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
		Size = UDim2.new(progress, 0, 1, 0)
	}):Play()
	percentLabel.Text = percent .. "%"

	if percent < 20 then
		statusLabel.Text = customPhrases[1]
	elseif percent < 45 then
		statusLabel.Text = customPhrases[2]
	elseif percent < 65 then
		statusLabel.Text = customPhrases[3]
	elseif percent < 85 then
		statusLabel.Text = customPhrases[4]
	else
		statusLabel.Text = customPhrases[5]
	end

	if progress >= 1 then
		break
	end
	task.wait(0.1)
end

-- Complete and remove the loading screen so it cannot leave the player stuck.
percentLabel.Text = "100%"
barFill.Size = UDim2.new(1, 0, 1, 0)
statusLabel.Text = "Ready!"
miniLoadingLabel.Text = "COMPLETE"
task.wait(0.4)

if loopConnection then
	loopConnection:Disconnect()
end
if blur then
	blur:Destroy()
end
screenGui:Destroy()
