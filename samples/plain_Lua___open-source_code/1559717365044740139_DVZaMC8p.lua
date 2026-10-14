-- Teletransporte com noclip durante o voo
-- LocalScript em StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local jogador = Players.LocalPlayer
local playerGui = jogador:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local VELOCIDADE_VOO = 75
local ALTURA_MINIMA_DO_CHAO = 6
local DISTANCIA_CAMERA = 14
local ALTURA_CAMERA = 5

local destinos = {
	{
		nome = "Prefeitura",
		posicao = Vector3.new(3415.0, 4.4, 2818.0)
	},
	{
		nome = "Garagem da Praça",
		posicao = Vector3.new(3395.8, 3.9, 2633.5)
	},
	{
		nome = "Hospital",
		posicao = Vector3.new(4174.1, 4.7, 2089.7)
	},
	{
		nome = "Lojinha",
		posicao = Vector3.new(4005.0, 4.3, 2238.8)
	},
	{
		nome = "Garagem Vermelha",
		posicao = Vector3.new(775, 4, 2468)
	},
	{
		nome = "Casas",
		posicao = Vector3.new(390, 10, 1227)
	},
	{
		nome = "Praça",
		posicao = Vector3.new(3572, 9, 2902)
	}
}

local voando = false
local tweenAtual = nil
local conexaoCamera = nil
local conexaoNoclip = nil
local botoesDestino = {}
local estadosColisao = {}

local humanoideAtual = nil
local autoRotateOriginal = true
local platformStandOriginal = false

local function criarCanto(objeto, raio)
	local canto = Instance.new("UICorner")
	canto.CornerRadius = UDim.new(0, raio)
	canto.Parent = objeto
end

local function obterPersonagem()
	local personagem = jogador.Character

	if not personagem then
		return nil, nil
	end

	local raiz = personagem:FindFirstChild("HumanoidRootPart")

	if not raiz then
		return nil, nil
	end

	return personagem, raiz
end

local function forcarNoclip(personagem)
	for _, objeto in ipairs(personagem:GetDescendants()) do
		if objeto:IsA("BasePart") then
			objeto.CanCollide = false
			objeto.CanTouch = false
		end
	end
end

local function iniciarModoVoo(personagem)
	estadosColisao = {}
	humanoideAtual = personagem:FindFirstChildOfClass("Humanoid")

	for _, objeto in ipairs(personagem:GetDescendants()) do
		if objeto:IsA("BasePart") then
			estadosColisao[objeto] = {
				CanCollide = objeto.CanCollide,
				CanTouch = objeto.CanTouch
			}

			objeto.CanCollide = false
			objeto.CanTouch = false
		end
	end

	if humanoideAtual then
		autoRotateOriginal = humanoideAtual.AutoRotate
		platformStandOriginal = humanoideAtual.PlatformStand

		humanoideAtual.AutoRotate = false
		humanoideAtual.PlatformStand = true
		humanoideAtual:ChangeState(Enum.HumanoidStateType.Physics)
	end

	-- Reaplica o noclip e impede o personagem de atravessar o chão.
	conexaoNoclip = RunService.Stepped:Connect(function()
		if voando and personagem and personagem.Parent then
			forcarNoclip(personagem)

			local raiz = personagem:FindFirstChild("HumanoidRootPart")

			if raiz then
				raiz.AssemblyAngularVelocity = Vector3.zero

				local parametrosRaio = RaycastParams.new()
				parametrosRaio.FilterType = Enum.RaycastFilterType.Exclude
				parametrosRaio.FilterDescendantsInstances = { personagem }

				local origemRaio = raiz.Position + Vector3.new(0, 100, 0)
				local direcaoRaio = Vector3.new(0, -200, 0)

				local resultado = workspace:Raycast(
					origemRaio,
					direcaoRaio,
					parametrosRaio
				)

				if resultado then
					local alturaSegura =
						resultado.Position.Y + ALTURA_MINIMA_DO_CHAO

					if raiz.Position.Y < alturaSegura then
						local rotacao = raiz.CFrame - raiz.Position

						raiz.CFrame = CFrame.new(
							raiz.Position.X,
							alturaSegura,
							raiz.Position.Z
						) * rotacao
					end
				end
			end
		end
	end)
end

local function finalizarModoVoo()
	if conexaoNoclip then
		conexaoNoclip:Disconnect()
		conexaoNoclip = nil
	end

	for objeto, estadoOriginal in pairs(estadosColisao) do
		if objeto and objeto.Parent then
			objeto.CanCollide = estadoOriginal.CanCollide
			objeto.CanTouch = estadoOriginal.CanTouch
		end
	end

	estadosColisao = {}

	if humanoideAtual and humanoideAtual.Parent then
		humanoideAtual.PlatformStand = platformStandOriginal
		humanoideAtual.AutoRotate = autoRotateOriginal
		humanoideAtual:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	humanoideAtual = nil
end

local function iniciarCameraSeguindo(personagem, alvo)
	if conexaoCamera then
		conexaoCamera:Disconnect()
		conexaoCamera = nil
	end

	-- Terceira pessoa estável, sem Lerp e sem acompanhar a cabeça.
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = 70

	conexaoCamera = RunService.RenderStepped:Connect(function()
		if not voando or not personagem or not personagem.Parent then
			return
		end

		local raiz = personagem:FindFirstChild("HumanoidRootPart")

		if not raiz then
			return
		end

		local direcao = alvo - raiz.Position

		if direcao.Magnitude < 0.001 then
			direcao = raiz.CFrame.LookVector
		else
			direcao = direcao.Unit
		end

		local pontoDeFoco = raiz.Position + Vector3.new(0, 2, 0)

		local posicaoDesejada = raiz.Position
			- direcao * DISTANCIA_CAMERA
			+ Vector3.new(0, ALTURA_CAMERA, 0)

		-- Evita que a câmera atravesse o chão, paredes ou objetos.
		local parametrosRaio = RaycastParams.new()
		parametrosRaio.FilterType = Enum.RaycastFilterType.Exclude
		parametrosRaio.FilterDescendantsInstances = { personagem }

		local deslocamentoCamera = posicaoDesejada - pontoDeFoco

		local obstaculo = workspace:Raycast(
			pontoDeFoco,
			deslocamentoCamera,
			parametrosRaio
		)

		local posicaoCamera = posicaoDesejada

		if obstaculo then
			posicaoCamera = obstaculo.Position + obstaculo.Normal * 0.5
		end

		-- Atualização direta, sem interpolação, para evitar tremores.
		camera.CFrame = CFrame.lookAt(posicaoCamera, alvo)
	end)
end

local function restaurarCamera()
	if conexaoCamera then
		conexaoCamera:Disconnect()
		conexaoCamera = nil
	end

	camera.CameraType = Enum.CameraType.Custom

	local personagem = jogador.Character

	if personagem then
		local humanoide = personagem:FindFirstChildOfClass("Humanoid")

		if humanoide then
			camera.CameraSubject = humanoide
		end
	end
end

local function atualizarBotoes(ocupado)
	for _, botao in ipairs(botoesDestino) do
		botao.Active = not ocupado
		botao.AutoButtonColor = not ocupado

		if ocupado then
			botao.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
		else
			botao.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
		end
	end
end

local function restaurarNomesDosBotoes()
	for indice, dadosDestino in ipairs(destinos) do
		if botoesDestino[indice] then
			botoesDestino[indice].Text = dadosDestino.nome
		end
	end
end

local function pararTeletransporte()
	local tweenParaCancelar = tweenAtual
	tweenAtual = nil

	if tweenParaCancelar then
		tweenParaCancelar:Cancel()
	end

	voando = false
	finalizarModoVoo()
	restaurarCamera()
	atualizarBotoes(false)
	restaurarNomesDosBotoes()
end

local function iniciarTeletransporte(dadosDestino, botao)
	if voando then
		return
	end

	local personagem, raiz = obterPersonagem()

	if not personagem or not raiz then
		return
	end

	-- Mantém o destino acima do chão.
	local posicaoFinal = dadosDestino.posicao
		+ Vector3.new(0, ALTURA_MINIMA_DO_CHAO, 0)

	local distancia = (posicaoFinal - raiz.Position).Magnitude

	if distancia <= 0.1 then
		return
	end

	local duracao = distancia / VELOCIDADE_VOO

	voando = true
	atualizarBotoes(true)
	botao.Text = "Voando..."

	iniciarModoVoo(personagem)
	iniciarCameraSeguindo(personagem, posicaoFinal)

	local cframeFinal = CFrame.new(posicaoFinal)

	local informacaoTween = TweenInfo.new(
		duracao,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut
	)

	local novoTween = TweenService:Create(
		raiz,
		informacaoTween,
		{
			CFrame = cframeFinal
		}
	)

	tweenAtual = novoTween

	novoTween.Completed:Connect(function(status)
		if tweenAtual ~= novoTween then
			return
		end

		tweenAtual = nil

		if status == Enum.PlaybackState.Completed then
			if raiz and raiz.Parent then
				raiz.CFrame = cframeFinal
				raiz.AssemblyLinearVelocity = Vector3.zero
				raiz.AssemblyAngularVelocity = Vector3.zero
			end
		end

		voando = false
		finalizarModoVoo()
		restaurarCamera()
		atualizarBotoes(false)
		botao.Text = dadosDestino.nome
	end)

	novoTween:Play()
end

-- Interface
local gui = Instance.new("ScreenGui")
gui.Name = "MenuTeletransporte"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local janela = Instance.new("Frame")
janela.Name = "Janela"
janela.Size = UDim2.fromOffset(220, 235)
janela.Position = UDim2.new(0, 15, 0.5, -117)
janela.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
janela.BorderSizePixel = 0
janela.Parent = gui

criarCanto(janela, 8)

local titulo = Instance.new("TextLabel")
titulo.Name = "Titulo"
titulo.Size = UDim2.new(1, -70, 0, 32)
titulo.Position = UDim2.fromOffset(10, 4)
titulo.BackgroundTransparency = 1
titulo.Text = "Teletransporte"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 16
titulo.Font = Enum.Font.GothamBold
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Active = true
titulo.Parent = janela

local botaoMinimizar = Instance.new("TextButton")
botaoMinimizar.Size = UDim2.fromOffset(27, 24)
botaoMinimizar.Position = UDim2.new(1, -60, 0, 8)
botaoMinimizar.Text = "-"
botaoMinimizar.TextSize = 18
botaoMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoMinimizar.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
botaoMinimizar.Parent = janela

criarCanto(botaoMinimizar, 5)

local botaoFechar = Instance.new("TextButton")
botaoFechar.Size = UDim2.fromOffset(27, 24)
botaoFechar.Position = UDim2.new(1, -30, 0, 8)
botaoFechar.Text = "X"
botaoFechar.TextSize = 13
botaoFechar.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoFechar.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
botaoFechar.Parent = janela

criarCanto(botaoFechar, 5)

local textoVelocidade = Instance.new("TextLabel")
textoVelocidade.Size = UDim2.new(1, -20, 0, 22)
textoVelocidade.Position = UDim2.fromOffset(10, 38)
textoVelocidade.BackgroundTransparency = 1
textoVelocidade.Text = "Velocidade: 75 studs/s"
textoVelocidade.TextColor3 = Color3.fromRGB(200, 200, 200)
textoVelocidade.TextSize = 12
textoVelocidade.Font = Enum.Font.Gotham
textoVelocidade.TextXAlignment = Enum.TextXAlignment.Left
textoVelocidade.Parent = janela

local botaoParar = Instance.new("TextButton")
botaoParar.Size = UDim2.new(1, -20, 0, 29)
botaoParar.Position = UDim2.fromOffset(10, 63)
botaoParar.Text = "Parar teletransporte"
botaoParar.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoParar.TextSize = 13
botaoParar.Font = Enum.Font.GothamBold
botaoParar.BackgroundColor3 = Color3.fromRGB(180, 60, 50)
botaoParar.Parent = janela

criarCanto(botaoParar, 5)

local areaDestinos = Instance.new("ScrollingFrame")
areaDestinos.Name = "AreaDestinos"
areaDestinos.Size = UDim2.new(1, -20, 0, 125)
areaDestinos.Position = UDim2.fromOffset(10, 100)
areaDestinos.BackgroundTransparency = 1
areaDestinos.BorderSizePixel = 0
areaDestinos.ScrollBarThickness = 5
areaDestinos.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
areaDestinos.CanvasSize = UDim2.new(0, 0, 0, 0)
areaDestinos.AutomaticCanvasSize = Enum.AutomaticSize.Y
areaDestinos.Parent = janela

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = areaDestinos

for indice, dadosDestino in ipairs(destinos) do
	local botao = Instance.new("TextButton")
	botao.Name = "Destino" .. indice
	botao.Size = UDim2.new(1, -5, 0, 27)
	botao.LayoutOrder = indice
	botao.Text = dadosDestino.nome
	botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	botao.TextSize = 12
	botao.Font = Enum.Font.Gotham
	botao.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
	botao.Parent = areaDestinos

	criarCanto(botao, 5)

	botoesDestino[indice] = botao

	botao.MouseButton1Click:Connect(function()
		iniciarTeletransporte(dadosDestino, botao)
	end)
end

-- Arrastar a janela pelo título
local arrastando = false
local inicioMouse
local inicioPosicao

titulo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		arrastando = true
		inicioMouse = input.Position
		inicioPosicao = janela.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				arrastando = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not arrastando then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local deslocamento = input.Position - inicioMouse

	janela.Position = UDim2.new(
		inicioPosicao.X.Scale,
		inicioPosicao.X.Offset + deslocamento.X,
		inicioPosicao.Y.Scale,
		inicioPosicao.Y.Offset + deslocamento.Y
	)
end)

botaoParar.MouseButton1Click:Connect(function()
	pararTeletransporte()
end)

local minimizado = false

botaoMinimizar.MouseButton1Click:Connect(function()
	minimizado = not minimizado

	textoVelocidade.Visible = not minimizado
	botaoParar.Visible = not minimizado
	areaDestinos.Visible = not minimizado

	if minimizado then
		janela.Size = UDim2.fromOffset(220, 42)
	else
		janela.Size = UDim2.fromOffset(220, 235)
	end
end)

botaoFechar.MouseButton1Click:Connect(function()
	pararTeletransporte()
	gui:Destroy()
end)

jogador.CharacterAdded:Connect(function()
	pararTeletransporte()
end)
