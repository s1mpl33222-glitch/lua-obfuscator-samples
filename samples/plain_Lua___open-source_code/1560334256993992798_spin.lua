local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Limpa execução anterior
if _G.SpinCleanup then pcall(_G.SpinCleanup) end

local Speed = 20 -- velocidade inicial
local ativo = true
local conexoes = {}
local giro

local function aplicar()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root then return end
	if not giro or giro.Parent ~= root then
		if giro then giro:Destroy() end
		giro = Instance.new("BodyAngularVelocity")
		giro.Name = "SpinForce"
		giro.MaxTorque = Vector3.new(0, math.huge, 0)
		giro.P = 1250
		giro.Parent = root
	end
	giro.AngularVelocity = Vector3.new(0, ativo and Speed or 0, 0)
	if hum then hum.AutoRotate = not ativo end
end

-- Painel (não some ao morrer)
local gui = Instance.new("ScreenGui")
gui.Name = "SpinPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 110)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.BackgroundTransparency = 1
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16

local function botao(texto, x, y, w)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0, w, 0, 32)
	b.Position = UDim2.new(0, x, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.Text = texto
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local menos = botao("-", 10, 35, 50)
local mais = botao("+", 120, 35, 50)
local toggle = botao("", 10, 72, 160)

local valor = Instance.new("TextLabel", frame)
valor.Size = UDim2.new(0, 50, 0, 32)
valor.Position = UDim2.new(0, 65, 0, 35)
valor.BackgroundTransparency = 1
valor.TextColor3 = Color3.new(1, 1, 1)
valor.Font = Enum.Font.Gotham
valor.TextSize = 18

local function atualizar()
	titulo.Text = "Spin"
	valor.Text = tostring(Speed)
	toggle.Text = ativo and "Parar (G)" or "Iniciar (G)"
	toggle.BackgroundColor3 = ativo and Color3.fromRGB(190, 60, 60) or Color3.fromRGB(60, 160, 80)
	aplicar()
end

mais.MouseButton1Click:Connect(function() Speed = math.min(Speed + 5, 200); atualizar() end)
menos.MouseButton1Click:Connect(function() Speed = math.max(Speed - 5, 0); atualizar() end)
toggle.MouseButton1Click:Connect(function() ativo = not ativo; atualizar() end)

table.insert(conexoes, UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		ativo = not ativo; atualizar()
	end
end))

-- Volta a girar sozinho depois de renascer
table.insert(conexoes, player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	giro = nil
	task.wait(0.2)
	aplicar()
end))

_G.SpinCleanup = function()
	for _, c in ipairs(conexoes) do c:Disconnect() end
	if giro then giro:Destroy() end
	gui:Destroy()
end

atualizar()
