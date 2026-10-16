-- =====================================================================
-- SCAR HUB - AMBIENTE (GRAMA & CÉU FIX TCS)
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TargetParent = CoreGui
pcall(function()
	if not CoreGui then TargetParent = PlayerGui end
end)

if TargetParent:FindFirstChild("ScarHubEnv") then
	TargetParent.ScarHubEnv:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScarHubEnv"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local CYAN_COLOR = Color3.fromRGB(0, 255, 255)
local PANEL_BG = Color3.fromRGB(22, 22, 28)
local DARK_BG = Color3.fromRGB(16, 16, 20)

-- Animação de Clique (Pulse)
local function AnimateClick(button)
	local originalSize = button.Size
	local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local shrink = TweenService:Create(button, tweenInfo, {Size = originalSize - UDim2.new(0, 4, 0, 4)})
	local grow = TweenService:Create(button, tweenInfo, {Size = originalSize})
	
	shrink:Play()
	shrink.Completed:Connect(function()
		grow:Play()
	end)
end

-- Botão Flutuante
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 35, 0, 35)
OpenButton.Position = UDim2.new(0.03, 0, 0.45, 0)
OpenButton.BackgroundColor3 = PANEL_BG
OpenButton.Text = "G"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 16
OpenButton.AutoButtonColor = false

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenButton)
OpenStroke.Color = CYAN_COLOR
OpenStroke.Thickness = 1.0

-- Mover Botão Flutuante
local dragToggle, dragStart, startPos
OpenButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = true
		dragStart = input.Position
		startPos = OpenButton.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		OpenButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

OpenButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = false
	end
end)

-- Painel Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -80)
MainFrame.BackgroundColor3 = PANEL_BG
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = CYAN_COLOR
FrameStroke.Transparency = 0.3
FrameStroke.Thickness = 1.5

-- Barra Superior
local TopBar = Instance.new("TextButton", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = DARK_BG
TopBar.Text = "  SCAR HUB - AMBIENTE"
TopBar.TextColor3 = CYAN_COLOR
TopBar.Font = Enum.Font.GothamBold
TopBar.TextSize = 10
TopBar.TextXAlignment = Enum.TextXAlignment.Left
TopBar.AutoButtonColor = false
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -27, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.AutoButtonColor = false
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

-- Botões das Abas
local TabGrama = Instance.new("TextButton", MainFrame)
TabGrama.Size = UDim2.new(0.44, 0, 0, 22)
TabGrama.Position = UDim2.new(0.05, 0, 0, 34)
TabGrama.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabGrama.Text = "Grama"
TabGrama.TextColor3 = CYAN_COLOR
TabGrama.Font = Enum.Font.GothamBold
TabGrama.TextSize = 9
TabGrama.AutoButtonColor = false
Instance.new("UICorner", TabGrama).CornerRadius = UDim.new(0, 6)

local TabCeu = Instance.new("TextButton", MainFrame)
TabCeu.Size = UDim2.new(0.44, 0, 0, 22)
TabCeu.Position = UDim2.new(0.51, 0, 0, 34)
TabCeu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabCeu.Text = "Céu"
TabCeu.TextColor3 = Color3.fromRGB(150, 150, 150)
TabCeu.Font = Enum.Font.GothamBold
TabCeu.TextSize = 9
TabCeu.AutoButtonColor = false
Instance.new("UICorner", TabCeu).CornerRadius = UDim.new(0, 6)

-- Containers com ScrollingFrame (Para Rolagem)
local ContainerGrama = Instance.new("ScrollingFrame", MainFrame)
ContainerGrama.Size = UDim2.new(1, 0, 0, 100)
ContainerGrama.Position = UDim2.new(0, 0, 0, 60)
ContainerGrama.BackgroundTransparency = 1
ContainerGrama.CanvasSize = UDim2.new(0, 0, 0, 170)
ContainerGrama.ScrollBarThickness = 3
ContainerGrama.ScrollBarImageColor3 = CYAN_COLOR
ContainerGrama.Visible = true

local ContainerCeu = Instance.new("ScrollingFrame", MainFrame)
ContainerCeu.Size = UDim2.new(1, 0, 0, 100)
ContainerCeu.Position = UDim2.new(0, 0, 0, 60)
ContainerCeu.BackgroundTransparency = 1
ContainerCeu.CanvasSize = UDim2.new(0, 0, 0, 120)
ContainerCeu.ScrollBarThickness = 3
ContainerCeu.ScrollBarImageColor3 = CYAN_COLOR
ContainerCeu.Visible = false

-- Alternar Abas
TabGrama.MouseButton1Click:Connect(function()
	ContainerGrama.Visible = true
	ContainerCeu.Visible = false
	TabGrama.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	TabGrama.TextColor3 = CYAN_COLOR
	TabCeu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabCeu.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

TabCeu.MouseButton1Click:Connect(function()
	ContainerGrama.Visible = false
	ContainerCeu.Visible = true
	TabCeu.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	TabCeu.TextColor3 = CYAN_COLOR
	TabGrama.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabGrama.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- =====================================================================
-- ABA 1: ELEMENTOS DA GRAMA
-- =====================================================================
local originalColors = {}

local function CriarBotaoGrama(nome, cor, posY)
	local btn = Instance.new("TextButton", ContainerGrama)
	btn.Size = UDim2.new(0.88, 0, 0, 22)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Text = nome
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 8
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		AnimateClick(btn)
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				local name = string.lower(obj.Name)
				if (obj.Material == Enum.Material.Grass or string.find(name, "grass") or string.find(name, "pitch") or string.find(name, "field") or string.find(name, "grama")) and not string.find(name, "line") and not string.find(name, "linha") then
					if not originalColors[obj] then originalColors[obj] = obj.Color end
					obj.Color = cor
				end
			end
		end
	end)
	return btn
end

CriarBotaoGrama("Grama Cinza", Color3.fromRGB(60, 60, 60), 2)
CriarBotaoGrama("Grama Roxa Escura", Color3.fromRGB(50, 0, 80), 28)
CriarBotaoGrama("Grama Rosa", Color3.fromRGB(255, 105, 180), 54)
CriarBotaoGrama("Grama Vermelho Escuro", Color3.fromRGB(130, 0, 0), 80)
CriarBotaoGrama("Grama Azul Escuro", Color3.fromRGB(0, 10, 90), 106)

-- Botão Restaurar
local ResetGrassBtn = Instance.new("TextButton", ContainerGrama)
ResetGrassBtn.Size = UDim2.new(0.88, 0, 0, 22)
ResetGrassBtn.Position = UDim2.new(0.05, 0, 0, 132)
ResetGrassBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ResetGrassBtn.Text = "Restaurar Grama Original"
ResetGrassBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ResetGrassBtn.Font = Enum.Font.GothamBold
ResetGrassBtn.TextSize = 8
ResetGrassBtn.AutoButtonColor = false
Instance.new("UICorner", ResetGrassBtn).CornerRadius = UDim.new(0, 6)

ResetGrassBtn.MouseButton1Click:Connect(function()
	AnimateClick(ResetGrassBtn)
	for part, color in pairs(originalColors) do
		if part and part.Parent then
			part.Color = color
		end
	end
end)

-- =====================================================================
-- ABA 2: ELEMENTOS DO CÉU (BYPASS DE DOMO & MESHES DO TCS)
-- =====================================================================
local function ForceSkyTCS(assetId)
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local n = string.lower(obj.Name)
			if string.find(n, "sky") or string.find(n, "dome") or string.find(n, "ceu") or string.find(n, "atmosphere") then
				if not string.find(n, "scarhub") then
					pcall(function() obj:Destroy() end)
				end
			end
		end
	end

	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Clouds") or child:IsA("PostEffect") or child:IsA("ColorCorrectionEffect") then
			child:Destroy()
		end
	end

	local loaded = false
	pcall(function()
		local objects = game:GetObjects("rbxassetid://" .. tostring(assetId))
		for _, v in pairs(objects) do
			if v:IsA("Sky") then
				v.Name = "ScarHubSky"
				v.Parent = Lighting
				loaded = true
			end
		end
	end)

	if not loaded then
		local newSky = Instance.new("Sky")
		newSky.Name = "ScarHubSky"
		local url = "rbxassetid://" .. tostring(assetId)
		newSky.SkyboxBk = url
		newSky.SkyboxDn = url
		newSky.SkyboxFt = url
		newSky.SkyboxLf = url
		newSky.SkyboxRt = url
		newSky.SkyboxUp = url
		newSky.Parent = Lighting
	end
end

local function CriarBotaoCeu(nome, skyId, posY)
	local btn = Instance.new("TextButton", ContainerCeu)
	btn.Size = UDim2.new(0.88, 0, 0, 22)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Text = nome
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 8
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		AnimateClick(btn)
		ForceSkyTCS(skyId)
	end)
	return btn
end

CriarBotaoCeu("Green Sky", "113859918879279", 2)
CriarBotaoCeu("Pink Sky", "96902346573845", 28)
CriarBotaoCeu("Minecraft Sky", "96736589365838", 54)

local ResetSkyBtn = Instance.new("TextButton", ContainerCeu)
ResetSkyBtn.Size = UDim2.new(0.88, 0, 0, 22)
ResetSkyBtn.Position = UDim2.new(0.05, 0, 0, 80)
ResetSkyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ResetSkyBtn.Text = "Restaurar Céu Original"
ResetSkyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ResetSkyBtn.Font = Enum.Font.GothamBold
ResetSkyBtn.TextSize = 8
ResetSkyBtn.AutoButtonColor = false
Instance.new("UICorner", ResetSkyBtn).CornerRadius = UDim.new(0, 6)

ResetSkyBtn.MouseButton1Click:Connect(function()
	AnimateClick(ResetSkyBtn)
	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("Sky") then
			child:Destroy()
		end
	end
end)

-- Toggle Painel
local painelAberto = false
local function TogglePanel(state)
	if state ~= nil then painelAberto = state else painelAberto = not painelAberto end
	if painelAberto then
		MainFrame.Visible = true
		MainFrame:TweenSize(UDim2.new(0, 200, 0, 170), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.25, true)
	else
		MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true, function()
			MainFrame.Visible = false
		end)
	end
end

OpenButton.MouseButton1Click:Connect(function()
	AnimateClick(OpenButton)
	TogglePanel()
end)

CloseButton.MouseButton1Click:Connect(function()
	AnimateClick(CloseButton)
	TogglePanel(false)
end)

-- Mover Painel
local dragging, dragStartPanel, startPosPanel
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPanel = input.Position
		startPosPanel = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPanel
		MainFrame.Position = UDim2.new(startPosPanel.X.Scale, startPosPanel.X.Offset + delta.X, startPosPanel.Y.Scale, startPosPanel.Y.Offset + delta.Y)
	end
end)
