-- =============================================================================
-- TELA DE CARREGAMENTO PREMIUM COMPACTA
-- COLOQUE ISTO DENTRO DE UM LOCALSCRIPT EM "ReplicatedFirst"
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
-- 1. SISTEMA BASE E DESIGN DE FUNDO
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProfileLoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 4, 8)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 18, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 8))
})
bgGradient.Rotation = 45
bgGradient.Parent = mainFrame

local blur = Instance.new("BlurEffect")
blur.Size = 16
blur.Parent = game.Workspace.CurrentCamera

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
-- 2. PAINEL CENTRAL COMPACTO
-- ==========================================
local centerPanel = Instance.new("Frame")
centerPanel.Size = UDim2.new(0, 360, 0, 250)
centerPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
centerPanel.AnchorPoint = Vector2.new(0.5, 0.5)
centerPanel.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
centerPanel.BackgroundTransparency = 0.2
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

-- TEXTO DE MARCA D'ÁGUA
local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(0.5, 0, 0, 20)
watermarkLabel.Position = UDim2.new(0, 12, 0, 8)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "by @Chocola Scripts"
watermarkLabel.Font = Enum.Font.GothamMedium
watermarkLabel.TextSize = 10
watermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.TextTransparency = 0.65
watermarkLabel.Parent = centerPanel

-- ==========================================
-- 3. CÍRCULO DO PERFIL COM AVATAR
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
-- 4. TIPOGRAFIA E RÓTULOS DA INTERFACE
-- ==========================================
-- Texto de Aviso
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.88, 0, 0, 35)
infoLabel.Position = UDim2.new(0.5, 0, 0.54, 0)
infoLabel.AnchorPoint = Vector2.new(0.5, 0.5)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "WAIT UNTIL THE LOADING IS COMPLETE BEFORE RUNNING THE SCRIPT"
infoLabel.Font = Enum.Font.GothamBlack
infoLabel.TextSize = 11
infoLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
infoLabel.TextWrapped = true
infoLabel.Parent = centerPanel

local infoStroke = Instance.new("UIStroke")
infoStroke.Color = Color3.fromRGB(0, 0, 0)
infoStroke.Thickness = 1.5
infoStroke.Parent = infoLabel

-- Rótulo de Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.63, 0) 
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Inicializando pipeline do ambiente..."
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 9.5
statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
statusLabel.Parent = centerPanel

-- Texto "CARREGANDO..."
local miniLoadingLabel = Instance.new("TextLabel")
miniLoadingLabel.Size = UDim2.new(1, 0, 0, 15)
miniLoadingLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
miniLoadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
miniLoadingLabel.BackgroundTransparency = 1
miniLoadingLabel.Text = "Carregando..."
miniLoadingLabel.Font = Enum.Font.GothamBold
miniLoadingLabel.TextSize = 9 
miniLoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
miniLoadingLabel.Parent = centerPanel

-- Exibição de Porcentagem
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
-- 5. SISTEMA DE BARRA DE PROGRESSO
-- ==========================================
local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0.85, 0, 0, 4)
barTrack.Position = UDim2.new(0.075, 0, 0.70, 0)
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

-- CHAMADA DO DISCORD
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, 0, 0, 15)
discordLabel.Position = UDim2.new(0.5, 0, 0.94, 0)
discordLabel.AnchorPoint = Vector2.new(0.5, 0.5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "Join for more scripts https://discord.gg/9WxvBKkaVF"
discordLabel.Font = Enum.Font.Code
discordLabel.TextSize = 10.5
discordLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
discordLabel.Parent = centerPanel

-- ==========================================
-- 6. LÓGICA DE CARREGAMENTO (20 SEGUNDOS)
-- ==========================================
local loopConnection = RunService.Heartbeat:Connect(function()
	if math.random() < 0.04 then spawnParticle() end
	local pulse = (math.sin(tick() * 4) + 1) / 2
	circleStroke.Transparency = 0.1 + (pulse * 0.4)
	panelStroke.Transparency = 0.2 + (pulse * 0.3)
end)

-- Animação Pop-In de Introdução
centerPanel.Size = UDim2.new(0, 300, 0, 210)
TweenService:Create(centerPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 360, 0, 250)
}):Play()

local customPhrases = {
	"Protecting the pipeline from the environment...",
	"Decrypting key structural assets...",
	"Bypassing network security verification...",
	"Injecting operating system logic...",
	"Finalizing the execution environment..."
}

local TARGET_TIME = 99
local startTime = os.time()

while true do
	local elapsed = os.time() - startTime
	local progress = math.clamp(elapsed / TARGET_TIME, 0, 1)
	local percent = math.floor(progress * 100)
	
	-- Quando chega a 95%, vai para 100% rapidamente
	if percent >= 95 then
		-- Tween rápido para 100%
		TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(1, 0, 1, 0)
		}):Play()
		
		-- Atualizar porcentagem para 100%
		percentLabel.Text = "100%"
		statusLabel.Text = "Loading complete!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
		miniLoadingLabel.Text = "Concluído"
		miniLoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
		
		task.wait(0.8) -- Esperar a animação terminar
		break
	end
	
	TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
		Size = UDim2.new(progress, 0, 1, 0)
	}):Play()
	percentLabel.Text = percent .. "%"
	
	if percent < 20 then statusLabel.Text = customPhrases[1]
	elseif percent >= 20 and percent < 45 then statusLabel.Text = customPhrases[2]
	elseif percent >= 45 and percent < 65 then statusLabel.Text = customPhrases[3]
	elseif percent >= 65 and percent < 85 then statusLabel.Text = customPhrases[4]
	elseif percent >= 85 then statusLabel.Text = customPhrases[5]
	end
	
	task.wait(0.5)
end

-- ==========================================
-- 7. DESAPARECER A UI COMPLETAMENTE
-- ==========================================
task.wait(0.5)

loopConnection:Disconnect()

-- Remover o blur
blur.Size = 0

-- Remover o screenGui completamente
screenGui:Destroy()

print("Carregamento concluído! Interface removida.")

-- ==========================================
-- 8. EXECUTAR SCRIPT PRINCIPAL
-- ==========================================

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

local camera = workspace.CurrentCamera
local Animals = require(ReplicatedStorage.Datas.Animals)
local Notif = require(ReplicatedStorage.Controllers.NotificationController)
local ZOOM_DISTANCE = 40
local cameraLockConnection

local function startCameraLock(hrp, distance)
	if not hrp then
		return
	end

	camera.CameraType = Enum.CameraType.Scriptable

	if cameraLockConnection then
		cameraLockConnection:Disconnect()
	end

	cameraLockConnection = RunService.RenderStepped:Connect(function()
		if not hrp or not hrp.Parent then
			return
		end

		local offset = -hrp.CFrame.LookVector * distance + Vector3.new(0, 5, 0)
		local pos = hrp.Position + offset

		camera.CFrame = CFrame.new(pos, hrp.Position)
	end)
end

local function stopCameraLock()
	if cameraLockConnection then
		cameraLockConnection:Disconnect()
		cameraLockConnection = nil
	end
end

local function getMyBasePosition()
	local plots = workspace:FindFirstChild('Plots')

	if not plots then
		return nil
	end

	for _, plot in ipairs(plots:GetChildren())do
		if plot:IsA('Model') then
			local label = plot:FindFirstChild('PlotSign') and plot.PlotSign:FindFirstChild('SurfaceGui') and plot.PlotSign.SurfaceGui:FindFirstChild('Frame') and plot.PlotSign.SurfaceGui.Frame:FindFirstChild('TextLabel')

			if label then
				local owner = label.Text:match("(.+)'s Base")

				if owner == player.Name or owner == player.DisplayName then
					local spawn = plot:FindFirstChild('Spawn')

					return spawn and spawn.Position or plot:GetPivot().Position
				end
			end
		end
	end
	return nil
end

local function getChar()
	local char = player.Character

	if not char then
		return
	end

	return char, char:FindFirstChildOfClass('Humanoid'), char:FindFirstChild('HumanoidRootPart')
end

local function getFormattedItem(itemName, rarity)
	if rarity == 'Secret' then
		return string.format('<zebra>%s</zebra>', itemName)
	elseif rarity == 'Rare' then
		return string.format('<font color="#0083ab">%s</font>', itemName)
	elseif rarity == 'Common' then
		return string.format('<font color="#00ab28">%s</font>', itemName)
	elseif rarity == 'Epic' then
		return string.format('<font color="#8600ab">%s</font>', itemName)
	elseif rarity == 'Legendary' then
		return string.format('<font color="#fbff00">%s</font>', itemName)
	elseif rarity == 'Mythic' then
		return string.format('<font color="#ff2a2a">%s</font>', itemName)
	elseif rarity == 'Brainrot God' then
		return string.format('<rainbow>%s</rainbow>', itemName)
	elseif rarity == 'OG' then
		return string.format('<og>%s</og>', itemName)
	end

	return itemName
end

local debounce = false

local function runSequence()
	if debounce then
		return
	end

	debounce = true

	task.spawn(function()
		local stolenItem = player:GetAttribute('StealingIndex')
		local rarity = 'Unknown'

		if stolenItem and Animals[stolenItem] then
			rarity = Animals[stolenItem].Rarity or 'Unknown'
		end

		task.wait(0.1)

		local base = getMyBasePosition()
		local char, _, hrp = getChar()

		if hrp then
			startCameraLock(hrp, ZOOM_DISTANCE)
		end

		task.wait(0.1)

		if hrp and base and char then
			local oldParent = hrp.Parent

			hrp.CFrame = CFrame.new(base + Vector3.new(0, 3, 0))
			hrp.Parent = nil

			task.wait(0.05)

			hrp.Parent = oldParent
		end

		task.wait(0.25)

		if stolenItem then
			local formattedName = getFormattedItem(stolenItem, rarity)

			Notif:Notify('You stole ' .. formattedName, 5, 'Sounds.Sfx.Success')
		end

		task.wait(0.1)

		if hrp then
			hrp.CFrame = CFrame.new(0, -500, 0)
			hrp.Parent = nil
		end

		task.wait()
		stopCameraLock()

		if stolenItem then
			player:Kick('You stole a ' .. rarity .. ' ' .. stolenItem .. ' STOLEN (from discord.gg/9WxvBKkaVF.')
		end

		debounce = false
	end)
end

player:GetAttributeChangedSignal('Stealing'):Connect(function()
	if player:GetAttribute('Stealing') == true then
		runSequence()
	end
end)

print(">:)")