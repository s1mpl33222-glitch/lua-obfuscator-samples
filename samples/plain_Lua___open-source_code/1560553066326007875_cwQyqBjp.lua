-- =====================================================================
-- SCAR HUB - PAINEL TCS (COM ABA DE BOLAS PRONTAS - UCL APENAS)
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TargetParent = CoreGui
pcall(function()
	if not CoreGui then TargetParent = PlayerGui end
end)

if TargetParent:FindFirstChild("ScarHubTCS") then
	TargetParent.ScarHubTCS:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScarHubTCS"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local CYAN_COLOR = Color3.fromRGB(0, 255, 255)
local DARK_BG = Color3.fromRGB(16, 16, 20)
local PANEL_BG = Color3.fromRGB(22, 22, 28)

-- 1. Botão Flutuante
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 35, 0, 35)
OpenButton.Position = UDim2.new(0.03, 0, 0.4, 0)
OpenButton.BackgroundColor3 = PANEL_BG
OpenButton.Text = "S"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 16
OpenButton.AutoButtonColor = false

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenButton)
OpenStroke.Color = CYAN_COLOR
OpenStroke.Transparency = 0
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

-- 2. Painel Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -130)
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
TopBar.Text = "  SCAR HUB - TCS CUSTOM"
TopBar.TextColor3 = CYAN_COLOR
TopBar.Font = Enum.Font.GothamBold
TopBar.TextSize = 10
TopBar.TextXAlignment = Enum.TextXAlignment.Left
TopBar.AutoButtonColor = false
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- Botão Fechar [X]
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

-- Botões de Abas
local TabCustom = Instance.new("TextButton", MainFrame)
TabCustom.Size = UDim2.new(0.47, 0, 0, 24)
TabCustom.Position = UDim2.new(0.03, 0, 0, 34)
TabCustom.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabCustom.Text = "Custom"
TabCustom.TextColor3 = CYAN_COLOR
TabCustom.Font = Enum.Font.GothamBold
TabCustom.TextSize = 9
TabCustom.AutoButtonColor = false
Instance.new("UICorner", TabCustom).CornerRadius = UDim.new(0, 6)

local TabProntas = Instance.new("TextButton", MainFrame)
TabProntas.Size = UDim2.new(0.47, 0, 0, 24)
TabProntas.Position = UDim2.new(0.5, 0, 0, 34)
TabProntas.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabProntas.Text = "Bolas Prontas"
TabProntas.TextColor3 = Color3.fromRGB(150, 150, 150)
TabProntas.Font = Enum.Font.GothamBold
TabProntas.TextSize = 9
TabProntas.AutoButtonColor = false
Instance.new("UICorner", TabProntas).CornerRadius = UDim.new(0, 6)

-- Container Aba 1
local ContainerCustom = Instance.new("Frame", MainFrame)
ContainerCustom.Size = UDim2.new(1, 0, 0, 135)
ContainerCustom.Position = UDim2.new(0, 0, 0, 62)
ContainerCustom.BackgroundTransparency = 1
ContainerCustom.Visible = true

-- Botão Bola Branca
local WhiteBallButton = Instance.new("TextButton", ContainerCustom)
WhiteBallButton.Size = UDim2.new(0.9, 0, 0, 24)
WhiteBallButton.Position = UDim2.new(0.05, 0, 0, 0)
WhiteBallButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
WhiteBallButton.Text = "Sistema / OFF"
WhiteBallButton.TextColor3 = Color3.fromRGB(180, 180, 180)
WhiteBallButton.Font = Enum.Font.GothamBold
WhiteBallButton.TextSize = 9
WhiteBallButton.AutoButtonColor = false
Instance.new("UICorner", WhiteBallButton).CornerRadius = UDim.new(0, 6)

-- Campo: Texture ID
local TextureInput = Instance.new("TextBox", ContainerCustom)
TextureInput.Size = UDim2.new(0.65, 0, 0, 24)
TextureInput.Position = UDim2.new(0.05, 0, 0, 28)
TextureInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TextureInput.PlaceholderText = "Cole a Texture ID..."
TextureInput.Text = ""
TextureInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TextureInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextureInput.Font = Enum.Font.Gotham
TextureInput.TextSize = 9
Instance.new("UICorner", TextureInput).CornerRadius = UDim.new(0, 6)

-- Botão: Remover Texture
local RemoveTextureBtn = Instance.new("TextButton", ContainerCustom)
RemoveTextureBtn.Size = UDim2.new(0.22, 0, 0, 24)
RemoveTextureBtn.Position = UDim2.new(0.73, 0, 0, 28)
RemoveTextureBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
RemoveTextureBtn.Text = "Remover"
RemoveTextureBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoveTextureBtn.Font = Enum.Font.GothamBold
RemoveTextureBtn.TextSize = 9
RemoveTextureBtn.AutoButtonColor = false
Instance.new("UICorner", RemoveTextureBtn).CornerRadius = UDim.new(0, 6)

-- Campo: Mesh ID
local MeshInput = Instance.new("TextBox", ContainerCustom)
MeshInput.Size = UDim2.new(0.65, 0, 0, 24)
MeshInput.Position = UDim2.new(0.05, 0, 0, 56)
MeshInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
MeshInput.PlaceholderText = "Cole a Mesh ID..."
MeshInput.Text = ""
MeshInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MeshInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
MeshInput.Font = Enum.Font.Gotham
MeshInput.TextSize = 9
Instance.new("UICorner", MeshInput).CornerRadius = UDim.new(0, 6)

-- Botão: Remover Mesh
local RemoveMeshBtn = Instance.new("TextButton", ContainerCustom)
RemoveMeshBtn.Size = UDim2.new(0.22, 0, 0, 24)
RemoveMeshBtn.Position = UDim2.new(0.73, 0, 0, 56)
RemoveMeshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
RemoveMeshBtn.Text = "Remover"
RemoveMeshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoveMeshBtn.Font = Enum.Font.GothamBold
RemoveMeshBtn.TextSize = 9
RemoveMeshBtn.AutoButtonColor = false
Instance.new("UICorner", RemoveMeshBtn).CornerRadius = UDim.new(0, 6)

-- Animações de Clique
local function AddClickAnimation(btn, originalPos)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.20, 0, 0, 22),
			Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 2, originalPos.Y.Scale, originalPos.Y.Offset + 1)
		}):Play()
	end)
	
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.22, 0, 0, 24),
			Position = originalPos
		}):Play()
	end)
end

AddClickAnimation(RemoveTextureBtn, UDim2.new(0.73, 0, 0, 28))
AddClickAnimation(RemoveMeshBtn, UDim2.new(0.73, 0, 0, 56))

-- Container Aba 2
local ContainerProntas = Instance.new("Frame", MainFrame)
ContainerProntas.Size = UDim2.new(1, 0, 0, 135)
ContainerProntas.Position = UDim2.new(0, 0, 0, 62)
ContainerProntas.BackgroundTransparency = 1
ContainerProntas.Visible = false

-- 1. Bola da Champions Laranja
local ChampionsOrangeBtn = Instance.new("TextButton", ContainerProntas)
ChampionsOrangeBtn.Size = UDim2.new(0.9, 0, 0, 26)
ChampionsOrangeBtn.Position = UDim2.new(0.05, 0, 0, 0)
ChampionsOrangeBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
ChampionsOrangeBtn.Text = "Bola da Champions Laranja"
ChampionsOrangeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChampionsOrangeBtn.Font = Enum.Font.GothamBold
ChampionsOrangeBtn.TextSize = 9
ChampionsOrangeBtn.AutoButtonColor = false
Instance.new("UICorner", ChampionsOrangeBtn).CornerRadius = UDim.new(0, 6)

-- 2. Bola da Champions Azul
local ChampionsBlueBtn = Instance.new("TextButton", ContainerProntas)
ChampionsBlueBtn.Size = UDim2.new(0.9, 0, 0, 26)
ChampionsBlueBtn.Position = UDim2.new(0.05, 0, 0, 32)
ChampionsBlueBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
ChampionsBlueBtn.Text = "Bola da Champions Azul"
ChampionsBlueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChampionsBlueBtn.Font = Enum.Font.GothamBold
ChampionsBlueBtn.TextSize = 9
ChampionsBlueBtn.AutoButtonColor = false
Instance.new("UICorner", ChampionsBlueBtn).CornerRadius = UDim.new(0, 6)

-- 3. Bola da Champions Branca
local ChampionsWhiteBtn = Instance.new("TextButton", ContainerProntas)
ChampionsWhiteBtn.Size = UDim2.new(0.9, 0, 0, 26)
ChampionsWhiteBtn.Position = UDim2.new(0.05, 0, 0, 64)
ChampionsWhiteBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
ChampionsWhiteBtn.Text = "Bola da Champions Branca"
ChampionsWhiteBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ChampionsWhiteBtn.Font = Enum.Font.GothamBold
ChampionsWhiteBtn.TextSize = 9
ChampionsWhiteBtn.AutoButtonColor = false
Instance.new("UICorner", ChampionsWhiteBtn).CornerRadius = UDim.new(0, 6)

-- Troca de Abas
TabCustom.MouseButton1Click:Connect(function()
	ContainerCustom.Visible = true
	ContainerProntas.Visible = false
	TabCustom.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	TabCustom.TextColor3 = CYAN_COLOR
	TabProntas.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabProntas.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

TabProntas.MouseButton1Click:Connect(function()
	ContainerCustom.Visible = false
	ContainerProntas.Visible = true
	TabProntas.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	TabProntas.TextColor3 = CYAN_COLOR
	TabCustom.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabCustom.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Toggle Painel
local painelAberto = false
local function TogglePanel(state)
	if state ~= nil then
		painelAberto = state
	else
		painelAberto = not painelAberto
	end

	if painelAberto then
		MainFrame.Visible = true
		MainFrame:TweenSize(UDim2.new(0, 230, 0, 160), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.25, true)
	else
		MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true, function()
			MainFrame.Visible = false
		end)
	end
end

OpenButton.MouseButton1Click:Connect(function() TogglePanel() end)
CloseButton.MouseButton1Click:Connect(function() TogglePanel(false) end)

-- BUSCA DE BOLAS NO MAPA
local function GetBalls()
	local balls = {}
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local name = string.lower(obj.Name)
			if name == "football" or name == "ball" or name == "soccerball" or name == "tps" or name == "hitbox" or name == "bola" or string.find(name, "tcs") then
				table.insert(balls, obj)
			end
		end
	end
	return balls
end

local bolaBrancaAtiva = false
local dadosOriginais = {}

local function FormatID(id)
	if not id or id == "" then return "" end
	local cleanId = string.match(id, "%d+")
	return cleanId and ("rbxassetid://" .. cleanId) or id
end

-- AÇÕES DOS BOTÕES DE BOLAS PRONTAS
ChampionsOrangeBtn.MouseButton1Click:Connect(function()
	TextureInput.Text = "http://www.roblox.com/asset/?id=6631296730"
	MeshInput.Text = "rbxassetid://4545270159"
end)

ChampionsBlueBtn.MouseButton1Click:Connect(function()
	TextureInput.Text = "rbxassetid://8108082224"
	MeshInput.Text = "rbxassetid://4454597214"
end)

ChampionsWhiteBtn.MouseButton1Click:Connect(function()
	TextureInput.Text = "http://www.roblox.com/asset/?id=7897839361"
	MeshInput.Text = "rbxassetid://4761031195"
end)

-- RESTAURAR TEXTURA ORIGINAL
RemoveTextureBtn.MouseButton1Click:Connect(function()
	TextureInput.Text = ""
	for _, b in pairs(GetBalls()) do
		pcall(function()
			if dadosOriginais[b] then
				if b:IsA("MeshPart") then
					b.TextureID = dadosOriginais[b].TextureID
				end
				local meshObj = b:FindFirstChildOfClass("SpecialMesh")
				if meshObj then
					meshObj.TextureId = dadosOriginais[b].SpecialMeshTexture
				end
				for _, c in pairs(b:GetChildren()) do
					if c:IsA("Decal") or c:IsA("Texture") then
						c.Texture = dadosOriginais[b].Decals[c] or c.Texture
						c.Transparency = 0
					end
				end
			end
		end)
	end
end)

-- RESTAURAR MESH ORIGINAL
RemoveMeshBtn.MouseButton1Click:Connect(function()
	MeshInput.Text = ""
	for _, b in pairs(GetBalls()) do
		pcall(function()
			if dadosOriginais[b] then
				if b:IsA("MeshPart") and dadosOriginais[b].MeshId ~= "" then
					b.MeshId = dadosOriginais[b].MeshId
				end
				local meshObj = b:FindFirstChildOfClass("SpecialMesh")
				if meshObj and dadosOriginais[b].SpecialMeshId ~= "" then
					meshObj.MeshId = dadosOriginais[b].SpecialMeshId
				end
			end
		end)
	end
end)

-- LOOP PRINCIPAL (HEARTBEAT)
RunService.Heartbeat:Connect(function()
	local listaBolas = GetBalls()
	if #listaBolas == 0 then return end

	local currentTexture = FormatID(TextureInput.Text)
	local currentMesh = FormatID(MeshInput.Text)

	for _, b in pairs(listaBolas) do
		pcall(function()
			-- Salvar estado original do mapa
			if not dadosOriginais[b] then
				local decalMap = {}
				for _, c in pairs(b:GetChildren()) do
					if c:IsA("Decal") or c:IsA("Texture") then
						decalMap[c] = c.Texture
					end
				end

				dadosOriginais[b] = {
					Color = b.Color,
					Material = b.Material,
					TextureID = b:IsA("MeshPart") and b.TextureID or "",
					MeshId = b:IsA("MeshPart") and b.MeshId or "",
					SpecialMeshId = b:FindFirstChildOfClass("SpecialMesh") and b:FindFirstChildOfClass("SpecialMesh").MeshId or "",
					SpecialMeshTexture = b:FindFirstChildOfClass("SpecialMesh") and b:FindFirstChildOfClass("SpecialMesh").TextureId or "",
					Decals = decalMap
				}
			end

			local meshObj = b:FindFirstChildOfClass("SpecialMesh")

			-- 1. MESH ID
			if currentMesh ~= "" then
				if b:IsA("MeshPart") then
					if b.MeshId ~= currentMesh then b.MeshId = currentMesh end
				else
					if not meshObj then meshObj = Instance.new("SpecialMesh", b) end
					if meshObj.MeshId ~= currentMesh then
						meshObj.MeshType = Enum.MeshType.FileMesh
						meshObj.MeshId = currentMesh
					end
				end
			end

			-- 2. TEXTURE ID
			if currentTexture ~= "" then
				if b:IsA("MeshPart") then
					if b.TextureID ~= currentTexture then b.TextureID = currentTexture end
				end
				if meshObj then
					if meshObj.TextureId ~= currentTexture then meshObj.TextureId = currentTexture end
				end
				for _, c in pairs(b:GetChildren()) do
					if c:IsA("Decal") or c:IsA("Texture") then
						if c.Texture ~= currentTexture then c.Texture = currentTexture end
					end
				end
			end

			-- 3. BOLA BRANCA ON / OFF
			if bolaBrancaAtiva then
				b.Color = Color3.fromRGB(255, 255, 255)
				b.Material = Enum.Material.SmoothPlastic
				
				for _, child in pairs(b:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child.Enabled = false
					end
				end

				if currentTexture == "" then
					if b:IsA("MeshPart") then b.TextureID = "" end
					if meshObj then meshObj.TextureId = "" end
					for _, c in pairs(b:GetChildren()) do
						if c:IsA("Decal") or c:IsA("Texture") then
							c.Transparency = 1
						end
					end
				end
			else
				-- Restaura para o padrão original quando o botão está OFF
				if b.Color ~= dadosOriginais[b].Color then
					b.Color = dadosOriginais[b].Color
				end
				if b.Material ~= dadosOriginais[b].Material then
					b.Material = dadosOriginais[b].Material
				end

				for _, child in pairs(b:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child.Enabled = true
					elseif child:IsA("Decal") or child:IsA("Texture") then
						child.Transparency = 0
						if currentTexture == "" then
							child.Texture = dadosOriginais[b].Decals[child] or child.Texture
						end
					end
				end

				if currentTexture == "" then
					if b:IsA("MeshPart") then
						b.TextureID = dadosOriginais[b].TextureID
					end
					if meshObj then
						meshObj.TextureId = dadosOriginais[b].SpecialMeshTexture
					end
				end
			end
		end)
	end
end)

-- BOTÃO BOLA BRANCA ON/OFF
WhiteBallButton.MouseButton1Click:Connect(function()
	bolaBrancaAtiva = not bolaBrancaAtiva
	if bolaBrancaAtiva then
		WhiteBallButton.Text = "Sistema / ON"
		WhiteBallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		WhiteBallButton.Text = "Sistema / OFF"
		WhiteBallButton.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
end)

-- MOVER PAINEL
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
