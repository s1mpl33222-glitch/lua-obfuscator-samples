-- [[ MÓDULO PLAYER COM PERSISTÊNCIA DE ESTADO - MONITE HUB ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local Module = {}
Module.Name = "Player"

-- Variáveis de Estado Globais do Módulo (Permanecem salvas mesmo mudando de aba)
local States = {
	Noclip = false,
	AntiAFK = false,
	Fullbright = false,
	Spin = false
}

-- Conexões ativas para controle de limpeza
local noclipConn = nil
local afkConn = nil
local fullbrightConn = nil
local spinConn = nil
local savedRespawnPos = nil

function Module.BuildTab(parentContainer)
	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Name = "PlayerScroll"
	Scroll.Parent = parentContainer
	Scroll.Size = UDim2.new(1, 0, 1, 0)
	Scroll.BackgroundTransparency = 1
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 1500)
	Scroll.ScrollBarThickness = 4
	Scroll.BorderSizePixel = 0

	local UIList = Instance.new("UIListLayout")
	UIList.Parent = Scroll
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 6)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = Scroll
	UIPadding.PaddingTop = UDim.new(0, 8)
	UIPadding.PaddingBottom = UDim.new(0, 8)

	local function CreateSection(text)
		local lbl = Instance.new("TextLabel")
		lbl.Parent = Scroll
		lbl.Size = UDim2.new(1, -16, 0, 24)
		lbl.BackgroundTransparency = 1
		lbl.Text = "--- " .. text .. " ---"
		lbl.TextColor3 = Color3.fromRGB(0, 170, 255)
		lbl.TextSize = 12
		lbl.Font = Enum.Font.GothamBold
	end

	local function CreateButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Parent = Scroll
		btn.Size = UDim2.new(1, -16, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		btn.BorderSizePixel = 0
		btn.Font = Enum.Font.GothamSemibold
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
		btn.TextSize = 11

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn

		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	-- CreateToggle agora lê diretamente o estado persistente
	local function CreateToggle(keyName, text, callback)
		local toggled = States[keyName]
		local btn = Instance.new("TextButton")
		btn.Parent = Scroll
		btn.Size = UDim2.new(1, -16, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		btn.BorderSizePixel = 0
		btn.Font = Enum.Font.GothamSemibold
		btn.Text = text .. ": " .. (toggled and "LIGADO [ON]" or "DESLIGADO [OFF]")
		btn.TextColor3 = toggled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 80, 80)
		btn.TextSize = 11

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			toggled = not toggled
			States[keyName] = toggled -- Salva o estado globalmente
			btn.Text = text .. ": " .. (toggled and "LIGADO [ON]" or "DESLIGADO [OFF]")
			btn.TextColor3 = toggled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 80, 80)
			callback(toggled)
		end)
		return btn
	end

	local function CreateSlider(labelName, minVal, maxVal, defaultVal, callback)
		local container = Instance.new("Frame")
		container.Parent = Scroll
		container.Size = UDim2.new(1, -16, 0, 44)
		container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		container.BorderSizePixel = 0

		local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = container

		local lbl = Instance.new("TextLabel")
		lbl.Parent = container
		lbl.Size = UDim2.new(1, -10, 0, 18)
		lbl.Position = UDim2.new(0, 6, 0, 2)
		lbl.BackgroundTransparency = 1
		lbl.Text = labelName .. ": " .. defaultVal
		lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
		lbl.TextSize = 11
		lbl.Font = Enum.Font.Gotham

		local sliderBar = Instance.new("TextButton")
		sliderBar.Parent = container
		sliderBar.Size = UDim2.new(1, -16, 0, 8)
		sliderBar.Position = UDim2.new(0, 8, 0, 28)
		sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		sliderBar.Text = ""
		sliderBar.AutoButtonColor = false

		local barCorner = Instance.new("UICorner") barCorner.CornerRadius = UDim.new(1, 0) barCorner.Parent = sliderBar

		local fill = Instance.new("Frame")
		fill.Parent = sliderBar
		fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		fill.BorderSizePixel = 0

		local fillCorner = Instance.new("UICorner") fillCorner.CornerRadius = UDim.new(1, 0) fillCorner.Parent = fill

		local dragging = false
		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(pos, 0, 1, 0)
				local val = math.floor(minVal + ((maxVal - minVal) * pos))
				lbl.Text = labelName .. ": " .. val
				callback(val)
			end
		end)
	end

	-- ==========================================
	-- CONSTRUÇÃO DOS ELEMENTOS DA ABA
	-- ==========================================

	CreateSection("Movimento")
	CreateSlider("WalkSpeed", 16, 250, 16, function(val)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
		end
	end)

	CreateSlider("JumpPower", 50, 300, 50, function(val)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			hum.UseJumpPower = true
			hum.JumpPower = val
		end
	end)

	CreateSection("Utilitários & Física")
	CreateToggle("Noclip", "Noclip (Atravessar)", function(state)
		if state then
			noclipConn = RunService.PreRender:Connect(function()
				if LocalPlayer.Character then
					for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConn then noclipConn:Disconnect() noclipConn = nil end
			if LocalPlayer.Character then
				for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = true
					end
				end
			end
		end
	end)

	CreateToggle("AntiAFK", "Anti-AFK", function(state)
		if state then
			local vu = game:GetService("VirtualUser")
			afkConn = LocalPlayer.Idled:Connect(function()
				vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(0.1)
				vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end)
		else
			if afkConn then afkConn:Disconnect() afkConn = nil end
		end
	end)

	CreateSection("Ações & Servidor")
	CreateButton("Respawn (Renascer)", function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidState.Dead)
		end
	end)

	CreateButton("Rejoin (Entrar Novamente)", function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end)

	CreateButton("Server Hop (Trocar Servidor)", function()
		local servers = {}
		local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
		local data = game:GetService("HttpService"):JSONDecode(req)
		for _, s in ipairs(data.data) do
			if type(s) == "table" and s.playing < s.maxPlayers and s.id ~= game.JobId then
				table.insert(servers, s.id)
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
		end
	end)

	CreateSection("Informações Gerais")
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Parent = Scroll
	infoLabel.Size = UDim2.new(1, -16, 0, 32)
	infoLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	infoLabel.TextSize = 10
	infoLabel.Font = Enum.Font.Code
	infoLabel.Text = "FPS: 0 | Ping: 0ms | Players: 0"
	local ic = Instance.new("UICorner") ic.CornerRadius = UDim.new(0, 6) ic.Parent = infoLabel

	RunService.PreRender:Connect(function(dt)
		if infoLabel and infoLabel.Parent then
			local fps = math.floor(1 / dt)
			local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
			local count = #Players:GetPlayers()
			infoLabel.Text = string.format("FPS: %d | Ping: %dms | Jogadores: %d", fps, ping, count)
		end
	end)

	CreateSection("Ambiente Visual")
	CreateToggle("Fullbright", "Fullbright", function(state)
		if state then
			Lighting.GlobalShadows = false
			Lighting.Brightness = 3
			fullbrightConn = RunService.PreRender:Connect(function()
				Lighting.Brightness = 3
				Lighting.ClockTime = 14
				Lighting.GlobalShadows = false
			end)
		else
			if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.GlobalShadows = true
		end
	end)

	CreateSection("Extras de Personagem")
	local spinSpeed = 10
	CreateSlider("Velocidade do Giro (Spin)", 0, 100, 10, function(val)
		spinSpeed = val
	end)

	CreateToggle("Spin", "Spin Character", function(state)
		if state then
			spinConn = RunService.PreRender:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local root = LocalPlayer.Character.HumanoidRootPart
					root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
				end
			end)
		else
			if spinConn then spinConn:Disconnect() spinConn = nil end
		end
	end)

	CreateButton("Salvar Posição de Respawn", function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			savedRespawnPos = LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function(char)
		if savedRespawnPos then
			task.wait(0.2)
			local root = char:WaitForChild("HumanoidRootPart", 3)
			if root then
				root.CFrame = savedRespawnPos
			end
		end
	end)
end

return Module
