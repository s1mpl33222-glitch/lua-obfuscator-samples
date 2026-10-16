-- This file was generated at discord.gg/syncrypt

local t1 = {}
local PlaceId = game.PlaceId
local GameId = game.GameId
local v4 = false
if table.find({
	100448435050950,
	74436060734791
}, PlaceId) then
    v4 = true
end
if table.find({ 372226183 }, GameId) then
    v4 = true
end
if not v4 then
    local LocalPlayer = game:GetService("Players").LocalPlayer

    if LocalPlayer then
        LocalPlayer:Kick("Segurança: Você não está em um mapa ou servidor permitido.")
    end

    return
end
function t1.value8()
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1D4vid/FTFNexVoid/refs/heads/main/nexvoid2.2.2"))()
        end)
    end)
end
local value8 = t1.value8
t1.value1 = "NexVoidConfigs"
local v7 = t1.value1 .. "/NexVoidSecurity.txt"
t1.value2 = "2.8"
local v8 = "NexVoid_Verified_V" .. t1.value2
t1.value8 = {}
local value8_2 = t1.value8
function t1.value4(p1, p2)
    local t2 = {}

    for i = 1, #p1 do
        local v131 = (string.byte(p1, i) + string.byte(p2, (i - 1) % #p2 + 1)) % 256

        table.insert(t2, string.format("%02X", v131))
    end

    return table.concat(t2)
end
local value4 = t1.value4
function t1.value4(p3, p4)
    local t3 = {}
    local n1 = 1

    return pcall(function()
        for i = 1, #p3, 2 do
            local num = tonumber(string.sub(p3, i, i + 1), 16)

            if not num then
                error()
            end

            local v204 = (num - string.byte(p4, (n1 - 1) % #p4 + 1) + 256) % 256

            table.insert(t3, (string.char(v204)))
            n1 += 1
        end
    end) and table.concat(t3) or nil
end
t1.value3 = type(isfolder) == "function" and not isfolder("NexVoidConfigs")
if t1.value3 then
    t1.value5 = type(makefolder)

    if t1.value5 == "function" then
        pcall(function()
            makefolder("NexVoidConfigs")
        end)
    end
end
t1.value3 = false
t1.value6 = type(isfile) == "function" and isfile(v7)
if t1.value6 then
    t1.value7 = type(readfile)

    if t1.value7 == "function" then
        t1.value6 = pcall
        t1.value10 = readfile
        t1.value9 = v7
        t1.value11 = { t1.value6(t1.value10, t1.value9) }
        t1.value7 = t1.value11[2]

        if t1.value11[1] then
            t1.value6 = t1.value4(t1.value7, "NexVoid_UltraSecure_Key_V2.8")
            t1.value10 = t1.value6

            if t1.value6 then
                t1.value10 = string.find(t1.value6, v8)
            end

            if t1.value10 then
                t1.value3 = false
            else
                t1.value3 = true
            end
        else
            t1.value3 = true
        end
    end
else
    t1.value11 = type(getgenv)

    if t1.value11 == "function" then
        t1.value12 = getgenv()

        if not t1.value12["NexVoid_Update_2.8"] then
            t1.value3 = true
        end
    else
        t1.value3 = true
    end
end
if not t1.value3 then
    value8()

    return
end
t1.value12 = game:GetService("CoreGui")
t1.value13 = game:GetService("TweenService")
local value13 = t1.value13
t1.value14 = game:GetService("RunService")
local value14 = t1.value14
t1.value15 = game:GetService("Players")
local value15 = t1.value15
t1.value16 = game:GetService("UserInputService")
t1.value17 = game:GetService("Stats")
local value17 = t1.value17
t1.value19 = game:GetService("HttpService")
local value19 = t1.value19
t1.value19 = value15.LocalPlayer
local value19_2 = t1.value19
t1.value22 = value14:IsStudio()
t1.value18 = t1.value22
if t1.value22 then
    t1.value18 = value19_2:WaitForChild("PlayerGui")
end
t1.value19 = t1.value18 or t1.value12
t1.value18 = Color3.fromRGB(255, 255, 255)
local value18 = t1.value18
t1.value20 = Color3.fromRGB(15, 15, 17)
t1.value21 = Color3.fromRGB(140, 140, 145)
t1.value23 = Color3.fromRGB(6, 6, 6)
local color3 = Color3.fromRGB(14, 14, 15)
local color3_2 = Color3.fromRGB(35, 35, 38)
local color3_3 = Color3.fromRGB(255, 255, 255)
local color3_4 = Color3.fromRGB(150, 150, 155)
local color3_5 = Color3.fromRGB(245, 245, 245)
t1.value18 = {
	Bg = t1.value23,
	Surface = color3,
	Stroke = color3_2,
	TextMain = color3_3,
	TextSub = color3_4,
	Accent = color3_5
}
local value18_2 = t1.value18
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexVoidIntro"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 2147483647
ScreenGui.Parent = t1.value19
t1.value23 = Instance.new("Frame")
local value23 = t1.value23
t1.value23 = value23
local uDim2 = UDim2.new(1, 0, 1, 0)
t1.value23.Size = uDim2
t1.value23 = value23
local color3_6 = Color3.fromRGB(6, 6, 6)
t1.value23.BackgroundColor3 = color3_6
t1.value23 = value23
t1.value23.BackgroundTransparency = 1
t1.value23 = value23
t1.value23.ClipsDescendants = true
t1.value23 = value23
t1.value23.Parent = ScreenGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 240)
Frame.Position = UDim2.new(0.5, 0, 0.46, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundTransparency = 1
Frame.Parent = value23
local UIScale = Instance.new("UIScale")
UIScale.Scale = 0
UIScale.Parent = Frame
local u30 = true
local function v31()
    if not Frame.Parent or not u30 then
        return
    end

    local Frame2 = Instance.new("Frame")
    local v138 = math.random(5, 9)

    Frame2.Size = UDim2.new(0, 0, 0, 0)
    Frame2.BackgroundColor3 = value18
    Frame2.BackgroundTransparency = 0.1
    Frame2.Rotation = 45
    Frame2.ZIndex = 4

    local v139 = math.random(0, 360) * 3.141592653589793 / 180
    local v140 = math.random(90, 125)
    local v141 = math.cos(v139)
    local _math = math
    local v143 = v141 * v140
    local v144 = _math.sin(v139) * v140

    Frame2.Position = UDim2.new(0.5, v143, 0.5, v144)
    Frame2.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = value18
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = Frame2

    local v146 = math.random(12, 18) / 10

    value13:Create(Frame2, TweenInfo.new(v146 * 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, v138, 0, v138)
	}):Play()

    local v147 = v143 + math.cos(v139) * math.random(15, 30)
    local v148 = v144 + math.sin(v139) * math.random(15, 30)

    value13:Create(Frame2, TweenInfo.new(v146, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, v147, 0.5, v148),
		Rotation = 135,
		BackgroundTransparency = 1
	}):Play()
    value13:Create(UIStroke, TweenInfo.new(v146, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1
	}):Play()
    task.delay(v146, function()
        Frame2:Destroy()
    end)
end
local function v32()
    if not value23.Parent or not u30 then
        return
    end

    local Frame3 = Instance.new("Frame")

    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = value18
    Frame3.BackgroundTransparency = 0.92

    local v150 = math.random(120, 280)
    local v151 = math.random(10, 90) / 100
    local v152 = math.random(1, 2) ~= 1 and -1 or 1

    Frame3.Size = UDim2.new(0, v150, 0, 1)
    Frame3.Position = UDim2.new(v152 ~= 1 and 1.3 or -0.3, 0, v151, 0)
    Frame3.Parent = value23

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.5, value18),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
    UIGradient.Parent = Frame3

    local v154 = math.random(4, 7)
    local v155 = value13
    local tweenInfo = TweenInfo.new(v154, Enum.EasingStyle.Linear)
    local new = UDim2.new
    local _math = math

    v155:Create(Frame3, tweenInfo, {
		Position = new(v152 ~= 1 and -0.3 or 1.3, 0, v151 + _math.random(-5, 5) / 100, 0)
	}):Play()
    task.delay(v154, function()
        Frame3:Destroy()
    end)
end
local function v33()
    if not value23.Parent or not u30 then
        return
    end

    local Frame4 = Instance.new("Frame")
    local v160 = math.random(2, 4)

    Frame4.Size = UDim2.new(0, v160, 0, v160)
    Frame4.BackgroundColor3 = value18
    Frame4.BackgroundTransparency = math.random(6, 8) / 10

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame4
    Frame4.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.1, 0)
    Frame4.Parent = value23

    local v162 = math.random(5, 9)

    value13:Create(Frame4, TweenInfo.new(v162, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(Frame4.Position.X.Scale + math.random(-15, 15) / 100, 0, -0.1, 0),
		BackgroundTransparency = 1
	}):Play()
    task.delay(v162, function()
        Frame4:Destroy()
    end)
end
task.spawn(function()
    while u30 do
        v32()
        task.wait(0.6)
    end
end)
task.spawn(function()
    while u30 do
        v33()
        task.wait(0.35)
    end
end)
task.spawn(function()
    while u30 do
        v31()
        task.wait(0.24)
    end
end)
local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(0.9, 0, 0.9, 0)
Frame5.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
Frame5.BackgroundTransparency = 1
Frame5.Parent = Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame5
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 12
UIStroke.Transparency = 0.5
UIStroke.Parent = Frame5
local Frame6 = Instance.new("Frame")
Frame6.Size = UDim2.new(0.85, 0, 0.85, 0)
Frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
Frame6.BackgroundTransparency = 1
Frame6.Parent = Frame
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = Frame6
local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = value18
UIStroke2.Thickness = 4.5
UIStroke2.Parent = Frame6
local UIGradient = Instance.new("UIGradient")
UIGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.24, 0),
	NumberSequenceKeypoint.new(0.25, 1),
	NumberSequenceKeypoint.new(0.29, 1),
	NumberSequenceKeypoint.new(0.3, 0),
	NumberSequenceKeypoint.new(0.57, 0),
	NumberSequenceKeypoint.new(0.58, 1),
	NumberSequenceKeypoint.new(0.62, 1),
	NumberSequenceKeypoint.new(0.63, 0),
	NumberSequenceKeypoint.new(0.88, 0),
	NumberSequenceKeypoint.new(0.89, 1),
	NumberSequenceKeypoint.new(0.93, 1),
	NumberSequenceKeypoint.new(0.94, 0),
	NumberSequenceKeypoint.new(1, 0)
})
UIGradient.Rotation = 35
UIGradient.Parent = UIStroke2
local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(0.76, 0, 0.76, 0)
Frame7.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
Frame7.BackgroundTransparency = 1
Frame7.Parent = Frame
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = Frame7
local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Color = value18
UIStroke3.Thickness = 2.2
UIStroke3.Parent = Frame7
local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.45, 0.1),
	NumberSequenceKeypoint.new(0.6, 1),
	NumberSequenceKeypoint.new(1, 1)
})
UIGradient2.Rotation = -45
UIGradient2.Parent = UIStroke3
local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(0.65, 0, 0.65, 0)
Frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
Frame8.BackgroundTransparency = 1
Frame8.ZIndex = 1
Frame8.Parent = Frame
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = Frame8
local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Color = value18
UIStroke4.Thickness = 8
UIStroke4.Transparency = 0.82
UIStroke4.Parent = Frame8
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0.85, 0, 0.85, 0)
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "NV"
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextColor3 = value18
TextLabel.TextSize = 115
TextLabel.Rotation = -5
TextLabel.ZIndex = 3
TextLabel.Parent = Frame
local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Color = t1.value20
UIStroke5.Thickness = 3
UIStroke5.Transparency = 0.1
UIStroke5.Parent = TextLabel
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(1, 0, 0, 25)
TextLabel2.Position = UDim2.new(0.5, 0, 0.5, 145)
TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = ""
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.TextColor3 = t1.value21
TextLabel2.TextSize = 10.5
TextLabel2.TextTransparency = 1
TextLabel2.Parent = value23
local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Color = Color3.fromRGB(0, 0, 0)
UIStroke6.Thickness = 1.5
UIStroke6.Transparency = 0.4
UIStroke6.Parent = TextLabel2
local connection
connection = value14.RenderStepped:Connect(function(dt)
    local UIGradientParent = UIGradient.Parent

    if UIGradientParent then
        UIGradientParent = UIGradient2.Parent
    end

    if UIGradientParent then
        UIGradient.Rotation = (UIGradient.Rotation + 45 * dt) % 360
        UIGradient2.Rotation = (UIGradient2.Rotation - 120 * dt) % 360

        return
    end

    connection:Disconnect()
end)
local ScreenGui2 = Instance.new("ScreenGui")
ScreenGui2.Name = "NexVoidDashboard"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.DisplayOrder = 2147483646
ScreenGui2.Enabled = false
ScreenGui2.Parent = t1.value19
local Frame9 = Instance.new("Frame")
Frame9.Size = UDim2.new(1, 0, 1, 0)
Frame9.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame9.BackgroundTransparency = 1
Frame9.Parent = ScreenGui2
local Frame10 = Instance.new("Frame")
Frame10.Size = UDim2.new(0, 840, 0, 420)
Frame10.Position = UDim2.new(0.5, 0, 0.5, 50)
Frame10.AnchorPoint = Vector2.new(0.5, 0.5)
Frame10.BackgroundTransparency = 1
Frame10.Parent = Frame9
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Frame10
local UIScale2 = Instance.new("UIScale")
UIScale2.Scale = 0.5
UIScale2.Parent = Frame10
local CurrentCamera = workspace.CurrentCamera
if not CurrentCamera then
    CurrentCamera = workspace:FindFirstChildOfClass("Camera")
end
local v59 = CurrentCamera
local u60 = (function()
    if not v59 then
        return 1
    end

    local ViewportSize = v59.ViewportSize
    local v166 = math.min(ViewportSize.X / 950, ViewportSize.Y / 500)

    return math.clamp(v166, 0.4, 1)
end)()
UIScale2.Scale = u60
if v59 then
    v59:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if ScreenGui2.Parent then
            local n2

            if not v59 then
                n2 = 1
            else
                local ViewportSize = v59.ViewportSize
                local v169 = math.min(ViewportSize.X / 950, ViewportSize.Y / 500)

                n2 = math.clamp(v169, 0.4, 1)
            end

            u60 = n2
            value13:Create(UIScale2, TweenInfo.new(0.2), {
				Scale = u60
			}):Play()
        end
    end)
end
local function v61(p5, p6)
    local Frame11 = Instance.new("Frame")

    Frame11.Size = UDim2.new(1, 0, 0, 1)
    Frame11.Position = UDim2.new(0, 0, 0, p6)
    Frame11.BackgroundColor3 = value18_2.Stroke
    Frame11.BorderSizePixel = 0
    Frame11.Parent = p5
end
local function v62(p7)
    local UIGradient3 = Instance.new("UIGradient")
    UIGradient3.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
	})
    UIGradient3.Parent = p7
    local n3 = 0
    local connection2
    connection2 = value14.RenderStepped:Connect(function(dt)
        local v206 = p7

        if v206 then
            v206 = p7.Parent
        end

        if v206 then
            n3 = (n3 + 30 * dt) % 360
            UIGradient3.Rotation = n3

            return
        end

        connection2:Disconnect()
    end)
    local v177 = connection2
    table.insert(value8_2, v177)
end
local function v63(p8, p9, p10)
    local Frame12 = Instance.new("Frame")

    Frame12.Name = p8
    Frame12.Size = UDim2.new(0, p9, 1, 0)
    Frame12.BackgroundColor3 = value18_2.Bg
    Frame12.LayoutOrder = p10
    Frame12.Parent = Frame10

    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0, 6)
    UICorner5.Parent = Frame12

    local UIStroke7 = Instance.new("UIStroke")

    UIStroke7.Color = Color3.fromRGB(255, 255, 255)
    UIStroke7.Thickness = 1.2
    UIStroke7.Parent = Frame12
    v62(UIStroke7)

    return Frame12
end
local t4 = {}
t1.value25 = {
	UserInfo = "User Info",
	Exec = "Executor",
	Dev = "Device",
	Reg = "Timezone",
	MidTitle = "Community & Feedback",
	DTitle = "Official Discord Server",
	DFeat = "• Full Executors Support\n• Key Bypasses & Updates\n• Open Source Scripts & More",
	Copy = "Copy Link",
	Join = "Join Server",
	Copied = "Copied!",
	FeedTitle = "Do you like NexVoid?",
	FeedSub = "Help us improve by submitting your feedback.",
	Yes = "Yes",
	No = "No",
	Sent = "Feedback Sent!",
	ChangeTitle = "Changelog",
	L1 = "• Added translation for notifications\n• Interface image IDs changed\n• Some Reworked Scripts\n• New functions added\n• Improved UI performance\n\nAny bugs that occur will be fixed soon.\nThank you very much for using NexVoid.",
	L2 = "• UI Reworked\n• Added More functions\n• Fixed and reworked ALL scripts in the \"Progress\" category\n• Still undetected and Working\n• Improved UI performance",
	L3 = "• Added Auto Farm features\n• Highlights logic reworked\n• New visual configurations\n• Minor bugs fixed\n• UI performance improvements"
}
local t5 = {
	UserInfo = "Info do Usuário",
	Exec = "Executor",
	Dev = "Dispositivo",
	Reg = "Fuso Horário",
	MidTitle = "Comunidade e Avaliação",
	DTitle = "Servidor Oficial do Discord",
	DFeat = "• Suporte a Todos Executores\n• Bypass de Keys e Updates\n• Scripts Open Source e Mais",
	Copy = "Copiar Link",
	Join = "Entrar no Servidor",
	Copied = "Copiado!",
	FeedTitle = "Você gosta do NexVoid?",
	FeedSub = "Ajude-nos a melhorar enviando sua avaliação.",
	Yes = "Sim",
	No = "Não",
	Sent = "Avaliação Enviada!",
	ChangeTitle = "Histórico de Atualizações",
	L1 = [[• Adicionado tradução para notificações
• IDs de imagem da interface alterados
• Alguns scripts refeitos
• Novas funções adicionadas
• Desempenho da UI aprimorado

Qualquer bug que ocorra será corrigido em breve.
Muito obrigado por usar o NexVoid.]],
	L2 = "• Interface Gráfica Refeita\n• Mais funções adicionadas\n• TODOS os scripts da categoria \"Progress\" corrigidos e refeitos\n• Continua indetectável e Funcionando\n• Desempenho da UI melhorado",
	L3 = "• Adicionado Auto Farm\n• Lógica de Highlights refeita\n• Novas configurações visuais\n• Pequenos bugs corrigidos\n• Desempenho da UI melhorado"
}
local t6 = {
	UserInfo = "Info del Usuario",
	Exec = "Ejecutor",
	Dev = "Dispositivo",
	Reg = "Zona Horaria",
	MidTitle = "Comunidad y Opinión",
	DTitle = "Servidor Oficial de Discord",
	DFeat = "• Soporte para Todos los Ejecutores\n• Bypass de Keys y Updates\n• Scripts Open Source y Más",
	Copy = "Copiar Enlace",
	Join = "Unirse al Servidor",
	Copied = "¡Copiado!",
	FeedTitle = "¿Te gusta NexVoid?",
	FeedSub = "Ayúdanos a mejorar enviando tu opinión.",
	Yes = "Sí",
	No = "No",
	Sent = "¡Opinión Enviada!",
	ChangeTitle = "Registro de Cambios",
	L1 = [[• Añadido traducción para notificaciones
• IDs de imagen de interfaz cambiados
• Algunos scripts rehechos
• Nuevas funciones añadidas
• Rendimiento de UI mejorado

Cualquier error que ocurra se corregirá pronto.
Muchas gracias por usar NexVoid.]],
	L2 = "• Interfaz Gráfica Rehecha\n• Más funciones añadidas\n• TODOS los scripts de la categoría \"Progress\" corrigidos y rehechos\n• Sigue indetectable y Funcionando\n• Mejoras de rendimiento en la UI",
	L3 = "• Funciones de Auto Farm añadidas\n• Lógica de Highlights rehecha\n• Nuevas configuraciones visuales\n• Pequeños errores corregidos\n• Mejoras de rendimiento"
}
local t7 = {
	EN = t1.value25,
	PT = t5,
	ES = t6
}
local v68 = v63("LeftPanel", 220, 1)
local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Size = UDim2.new(1, -30, 0, 45)
TextLabel3.Position = UDim2.new(0, 15, 0, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = t7.EN.UserInfo
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextColor3 = value18_2.TextMain
TextLabel3.TextSize = 13
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = v68
t4.UserInfo = TextLabel3
v61(v68, 45)
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(0, 65, 0, 65)
ImageLabel.Position = UDim2.new(0.5, 0, 0, 65)
ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Parent = v68
local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0, 6)
UICorner6.Parent = ImageLabel
local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Color = value18_2.Stroke
UIStroke8.Parent = ImageLabel
task.spawn(function()
    pcall(function()
        ImageLabel.Image = value15:GetUserThumbnailAsync(value19_2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
end)
local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Size = UDim2.new(1, -20, 0, 15)
TextLabel4.Position = UDim2.new(0, 10, 0, 140)
TextLabel4.BackgroundTransparency = 1
t1.value24 = value19_2.Name
TextLabel4.Text = t1.value24
t1.value24 = Enum.Font.GothamBold
TextLabel4.Font = t1.value24
t1.value24 = value18_2.TextMain
TextLabel4.TextColor3 = t1.value24
TextLabel4.TextSize = 12
TextLabel4.Parent = v68
v61(v68, 170)
local function v74(p11, p12)
    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Size = UDim2.new(0, 70, 0, 15)
    TextLabel5.Position = UDim2.new(0, 15, 0, p12)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = t7.EN[p11] or p11
    TextLabel5.Font = Enum.Font.Gotham
    TextLabel5.TextColor3 = value18_2.TextSub
    TextLabel5.TextSize = 10
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.Parent = v68

    if p11 ~= "FPS" and p11 ~= "Ping" then
        t4[p11] = TextLabel5
    end

    local TextLabel6 = Instance.new("TextLabel")

    TextLabel6.Size = UDim2.new(1, -100, 0, 15)
    TextLabel6.Position = UDim2.new(0, 85, 0, p12)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = "..."
    TextLabel6.Font = Enum.Font.GothamBold
    TextLabel6.TextColor3 = value18_2.TextMain
    TextLabel6.TextSize = 11
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel6.Parent = v68

    return TextLabel6
end
t1.value24 = v74("Exec", 185)
local v75 = v74("Dev", 205)
local v76 = v74("FPS", 225)
local v77 = v74("Ping", 245)
local v78 = v74("Reg", 265)
local v79 = identifyexecutor and identifyexecutor() or "Unknown"
t1.value24.Text = v79
v75.Text = (not t1.value16.TouchEnabled or t1.value16.KeyboardEnabled) and "PC" or "Mobile"
v78.Text = os.date("%Z") or "Local"
local n4 = 0
t1.value26 = value14.RenderStepped:Connect(function()
    n4 += 1
end);
(function(p13)
    table.insert(value8_2, p13)

    return p13
end)(t1.value26)
task.spawn(function()
    while task.wait(1) and v68.Parent do
        v76.Text = tostring(n4) .. " fps"
        n4 = 0
        pcall(function()
            v77.Text = tostring((math.floor((value17.Network.ServerStatsItem["Data Ping"]:GetValue())))) .. " ms"
        end)
    end
end)
v61(v68, 295)
local TextLabel7 = Instance.new("TextLabel")
TextLabel7.Size = UDim2.new(1, 0, 0, 20)
TextLabel7.Position = UDim2.new(0, 0, 0, 320)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Font = Enum.Font.GothamBlack
TextLabel7.TextColor3 = value18_2.TextMain
TextLabel7.TextSize = 16
TextLabel7.Parent = v68
local TextLabel8 = Instance.new("TextLabel")
TextLabel8.Size = UDim2.new(1, 0, 0, 15)
TextLabel8.Position = UDim2.new(0, 0, 0, 345)
TextLabel8.BackgroundTransparency = 1
TextLabel8.Font = Enum.Font.Gotham
TextLabel8.TextColor3 = value18_2.TextSub
TextLabel8.TextSize = 11
TextLabel8.Parent = v68
task.spawn(function()
    while task.wait(1) and v68.Parent do
        TextLabel7.Text = os.date("%I:%M:%S %p")
        TextLabel8.Text = os.date("%B %d, %Y")
    end
end)
local v83 = v63("CenterPanel", 350, 2)
local TextLabel9 = Instance.new("TextLabel")
TextLabel9.Size = UDim2.new(0, 180, 0, 45)
TextLabel9.Position = UDim2.new(0, 15, 0, 0)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Text = t7.EN.MidTitle
TextLabel9.Font = Enum.Font.GothamBold
TextLabel9.TextColor3 = value18_2.TextMain
TextLabel9.TextSize = 13
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = v83
t4.MidTitle = TextLabel9
local Frame13 = Instance.new("Frame")
Frame13.Size = UDim2.new(0, 95, 0, 45)
Frame13.Position = UDim2.new(1, -165, 0, 0)
Frame13.BackgroundTransparency = 1
Frame13.Parent = v83
local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout2.Padding = UDim.new(0, 8)
UIListLayout2.Parent = Frame13
for _, v in ipairs({
	"EN",
	"PT",
	"ES"
}) do
    local v89 = v
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 20, 0, 20)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = v89
    TextButton.Font = Enum.Font.GothamBold

    local v91 = v89 == "EN"

    if v91 then
        v91 = value18_2.TextMain
    end

    if not v91 then
        v91 = value18_2.TextSub
    end

    TextButton.TextColor3 = v91
    TextButton.TextSize = 11
    TextButton.Parent = Frame13;
    ({})[v89] = TextButton
    TextButton.MouseButton1Click:Connect(function()
        setLang(v89)
    end)
end
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 40, 0, 45)
TextButton.Position = UDim2.new(1, -40, 0, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = "X"
TextButton.Font = Enum.Font.GothamBlack
TextButton.TextColor3 = value18_2.TextSub
TextButton.TextSize = 18
TextButton.Parent = v83
TextButton.MouseEnter:Connect(function()
    value13:Create(TextButton, TweenInfo.new(0.2), {
		TextColor3 = Color3.fromRGB(255, 80, 80)
	}):Play()
end)
TextButton.MouseLeave:Connect(function()
    value13:Create(TextButton, TweenInfo.new(0.2), {
		TextColor3 = value18_2.TextSub
	}):Play()
end)
TextButton.MouseButton1Click:Connect(function()
    for _, v in ipairs(value8_2) do
        if v.Connected then
            v:Disconnect()
        end
    end

    table.clear(value8_2)
    value13:Create(UIScale2, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Scale = u60 * 0.8
	}):Play()
    value13:Create(Frame9, TweenInfo.new(0.3), {
		BackgroundTransparency = 1
	}):Play()
    task.wait(0.3)
    ScreenGui2:Destroy()
    value8()
end)
v61(v83, 45)
local Frame14 = Instance.new("Frame")
Frame14.Size = UDim2.new(1, -30, 0, 185)
Frame14.Position = UDim2.new(0, 15, 0, 60)
Frame14.BackgroundTransparency = 1
Frame14.Parent = v83
local UICorner7 = Instance.new("UICorner")
UICorner7.CornerRadius = UDim.new(0, 6)
UICorner7.Parent = Frame14
local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Color = value18_2.Stroke
UIStroke9.Parent = Frame14
local ImageLabel2 = Instance.new("ImageLabel")
ImageLabel2.Size = UDim2.new(0, 32, 0, 32)
ImageLabel2.Position = UDim2.new(0, 15, 0, 15)
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Image = "rbxassetid://129831248340415"
ImageLabel2.Parent = Frame14
local TextLabel10 = Instance.new("TextLabel")
TextLabel10.Size = UDim2.new(1, -65, 0, 15)
TextLabel10.Position = UDim2.new(0, 60, 0, 15)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Text = t7.EN.DTitle
TextLabel10.Font = Enum.Font.GothamBold
TextLabel10.TextColor3 = value18_2.TextMain
TextLabel10.TextSize = 12
TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
TextLabel10.Parent = Frame14
t4.DTitle = TextLabel10
local TextLabel11 = Instance.new("TextLabel")
TextLabel11.Size = UDim2.new(1, -65, 0, 45)
TextLabel11.Position = UDim2.new(0, 60, 0, 35)
TextLabel11.BackgroundTransparency = 1
TextLabel11.Text = t7.EN.DFeat
TextLabel11.Font = Enum.Font.GothamMedium
TextLabel11.TextColor3 = value18_2.TextSub
TextLabel11.TextSize = 10
TextLabel11.LineHeight = 1.3
TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
TextLabel11.TextYAlignment = Enum.TextYAlignment.Top
TextLabel11.Parent = Frame14
t4.DFeat = TextLabel11
local Frame15 = Instance.new("Frame")
Frame15.Size = UDim2.new(1, -30, 0, 35)
Frame15.Position = UDim2.new(0, 15, 0, 90)
Frame15.BackgroundTransparency = 1
Frame15.Parent = Frame14
local UICorner8 = Instance.new("UICorner")
UICorner8.CornerRadius = UDim.new(0, 4)
UICorner8.Parent = Frame15
local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Color = value18_2.Stroke
UIStroke10.Parent = Frame15
local TextLabel12 = Instance.new("TextLabel")
TextLabel12.Size = UDim2.new(1, -20, 1, 0)
TextLabel12.Position = UDim2.new(0, 10, 0, 0)
TextLabel12.BackgroundTransparency = 1
TextLabel12.Text = "discord.gg/ATXbsv8aM7"
TextLabel12.Font = Enum.Font.GothamMedium
TextLabel12.TextColor3 = value18_2.TextSub
TextLabel12.TextSize = 11
TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
TextLabel12.Parent = Frame15
local TextButton2 = Instance.new("TextButton")
TextButton2.Size = UDim2.new(0.47, 0, 0, 36)
TextButton2.Position = UDim2.new(0, 15, 1, -50)
TextButton2.BackgroundTransparency = 1
TextButton2.Text = t7.EN.Copy
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextColor3 = value18_2.TextMain
TextButton2.TextSize = 11
TextButton2.Parent = Frame14
local UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(0, 4)
UICorner9.Parent = TextButton2
local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Color = value18_2.Stroke
UIStroke11.Parent = TextButton2
t4.Copy = TextButton2
local TextButton3 = Instance.new("TextButton")
TextButton3.Size = UDim2.new(0.47, 0, 0, 36)
TextButton3.Position = UDim2.new(1, -15, 1, -50)
TextButton3.AnchorPoint = Vector2.new(1, 0)
TextButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton3.Text = t7.EN.Join
TextButton3.Font = Enum.Font.GothamBold
TextButton3.TextColor3 = Color3.fromRGB(15, 15, 15)
TextButton3.TextSize = 11
TextButton3.Parent = Frame14
local UICorner10 = Instance.new("UICorner")
UICorner10.CornerRadius = UDim.new(0, 4)
UICorner10.Parent = TextButton3
t4.Join = TextButton3
local UIGradient4 = Instance.new("UIGradient")
UIGradient4.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210))
})
UIGradient4.Rotation = 90
UIGradient4.Parent = TextButton3
TextButton2.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/ATXbsv8aM7")
        TextButton2.Text = t7.EN.Copied
        task.wait(1.5)
        TextButton2.Text = t7.EN.Copy
    end
end)
TextButton3.MouseButton1Click:Connect(function()
    local _request = request

    if not _request then
        _request = http_request

        if not _request then
            _request = syn.request
        end
    end

    local v191 = _request

    if v191 then
        pcall(function()
            local v207 = v191
            local t8 = {
				["Content-Type"] = "application/json",
				Origin = "https://discord.com"
			}
            local v209 = value19
            local JSONEncode = v209.JSONEncode
            local t9 = {
				code = "ATXbsv8aM7"
			}
            local guid = value19:GenerateGUID(false)
            local v213 = JSONEncode(v209, {
				cmd = "INVITE_BROWSER",
				args = t9,
				nonce = guid
			})

            v207({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = t8,
				Body = v213
			})
        end)
    end
end)
v61(v83, 260)
local Frame16 = Instance.new("Frame")
Frame16.Size = UDim2.new(1, -30, 0, 130)
Frame16.Position = UDim2.new(0, 15, 0, 275)
Frame16.BackgroundTransparency = 1
Frame16.Parent = v83
local UICorner11 = Instance.new("UICorner")
UICorner11.CornerRadius = UDim.new(0, 6)
UICorner11.Parent = Frame16
local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Color = value18_2.Stroke
UIStroke12.Parent = Frame16
local ImageLabel3 = Instance.new("ImageLabel")
ImageLabel3.Size = UDim2.new(0, 32, 0, 32)
ImageLabel3.Position = UDim2.new(0, 15, 0, 15)
ImageLabel3.BackgroundTransparency = 1
ImageLabel3.Image = "rbxassetid://138188957887846"
ImageLabel3.Parent = Frame16
local TextLabel13 = Instance.new("TextLabel")
TextLabel13.Size = UDim2.new(1, -65, 0, 15)
TextLabel13.Position = UDim2.new(0, 60, 0, 15)
TextLabel13.BackgroundTransparency = 1
TextLabel13.Text = t7.EN.FeedTitle
TextLabel13.Font = Enum.Font.GothamBold
TextLabel13.TextColor3 = value18_2.TextMain
TextLabel13.TextSize = 13
TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
TextLabel13.Parent = Frame16
t4.FeedTitle = TextLabel13
local TextLabel14 = Instance.new("TextLabel")
TextLabel14.Size = UDim2.new(1, -65, 0, 30)
TextLabel14.Position = UDim2.new(0, 60, 0, 35)
TextLabel14.BackgroundTransparency = 1
TextLabel14.Text = t7.EN.FeedSub
TextLabel14.Font = Enum.Font.Gotham
TextLabel14.TextColor3 = value18_2.TextSub
TextLabel14.TextSize = 11
TextLabel14.TextWrapped = true
TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
TextLabel14.TextYAlignment = Enum.TextYAlignment.Top
TextLabel14.Parent = Frame16
t4.FeedSub = TextLabel14
local TextButton4 = Instance.new("TextButton")
TextButton4.Size = UDim2.new(0.47, 0, 0, 36)
TextButton4.Position = UDim2.new(0, 15, 1, -50)
TextButton4.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
TextButton4.Text = t7.EN.Yes
TextButton4.Font = Enum.Font.GothamBold
TextButton4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton4.TextSize = 12
TextButton4.Parent = Frame16
local UICorner12 = Instance.new("UICorner")
UICorner12.CornerRadius = UDim.new(0, 4)
UICorner12.Parent = TextButton4
t4.Yes = TextButton4
local UIGradient5 = Instance.new("UIGradient")
UIGradient5.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210))
})
UIGradient5.Rotation = 90
UIGradient5.Parent = TextButton4
local TextButton5 = Instance.new("TextButton")
TextButton5.Size = UDim2.new(0.47, 0, 0, 36)
TextButton5.Position = UDim2.new(1, -15, 1, -50)
TextButton5.AnchorPoint = Vector2.new(1, 0)
TextButton5.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
TextButton5.Text = t7.EN.No
TextButton5.Font = Enum.Font.GothamBold
TextButton5.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton5.TextSize = 12
TextButton5.Parent = Frame16
local UICorner13 = Instance.new("UICorner")
UICorner13.CornerRadius = UDim.new(0, 4)
UICorner13.Parent = TextButton5
t4.No = TextButton5
UIGradient5:Clone().Parent = TextButton5
TextButton4.MouseEnter:Connect(function()
    value13:Create(TextButton4, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(86, 244, 153)
	}):Play()
end)
TextButton4.MouseLeave:Connect(function()
    value13:Create(TextButton4, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	}):Play()
end)
TextButton5.MouseEnter:Connect(function()
    value13:Create(TextButton5, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(255, 96, 99)
	}):Play()
end)
TextButton5.MouseLeave:Connect(function()
    value13:Create(TextButton5, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(237, 66, 69)
	}):Play()
end)
local function v120(p14)
    TextButton4.Visible = false
    TextButton5.Visible = false
    TextLabel14.Visible = false
    TextLabel13.Position = UDim2.new(0, 60, 0.5, 0)
    TextLabel13.AnchorPoint = Vector2.new(0, 0.5)
    TextLabel13.Text = t7.EN.Sent
    t4.FeedTitle = nil
    task.spawn(function()
        local v214 = ("https://discord.com/api/webhooks/1494114029856096519/xEs1H50YPUFAqPgR8uqt4y5Xkqra90aOlRELa_4CXtYXRXb08VV5jw0uxdrkVLpYqB1F"):gsub("discord.com", "webhook.lewisakura.moe"):gsub("discordapp.com", "webhook.lewisakura.moe")
        local v215 = identifyexecutor and identifyexecutor() or "Unknown"
        local v216 = p14 ~= "Yes" and 15158332 or 3066993
        local t10 = {
			name = "Gostou do NexVoid?",
			value = p14,
			inline = false
		}
        local value19_2Name = value19_2.Name
        local t11 = {
			name = "👤 User",
			value = value19_2Name,
			inline = true
		}
        local t12 = {
			name = "⚙\239\184\143 Executor",
			value = v215,
			inline = true
		}
        local t13 = {
			embeds = {{
				title = "⭐ NexVoid - Feedback",
				color = v216,
				fields = {
					t10,
					t11,
					t12
				}
			}}
		}
        local _request = request

        if not _request then
            _request = http_request

            if not _request then
                _request = syn.request
            end
        end

        local v223 = _request

        if v223 then
            pcall(function()
                local v224 = v223
                local v225 = v214
                local t14 = {
					["Content-Type"] = "application/json"
				}
                local json = value19:JSONEncode(t13)

                v224({
					Url = v225,
					Method = "POST",
					Headers = t14,
					Body = json
				})
            end)
        end
    end)
end
TextButton4.MouseButton1Click:Connect(function()
    v120("Yes")
end)
TextButton5.MouseButton1Click:Connect(function()
    v120("No")
end)
local v121 = v63("RightPanel", 230, 3)
local TextLabel15 = Instance.new("TextLabel")
TextLabel15.Size = UDim2.new(1, -30, 0, 45)
TextLabel15.Position = UDim2.new(0, 15, 0, 0)
TextLabel15.BackgroundTransparency = 1
TextLabel15.Text = t7.EN.ChangeTitle
TextLabel15.Font = Enum.Font.GothamBold
TextLabel15.TextColor3 = value18_2.TextMain
TextLabel15.TextSize = 13
TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
TextLabel15.Parent = v121
t4.ChangeTitle = TextLabel15
v61(v121, 45)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = value18_2.Stroke
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = v121
local UIListLayout3 = Instance.new("UIListLayout")
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.Padding = UDim.new(0, 12)
UIListLayout3.Parent = ScrollingFrame
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingRight = UDim.new(0, 15)
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.Parent = ScrollingFrame
local function v126(p15, p16, p17)
    local Frame17 = Instance.new("Frame")

    Frame17.Size = UDim2.new(1, 0, 0, 0)
    Frame17.BackgroundTransparency = 1
    Frame17.AutomaticSize = Enum.AutomaticSize.Y
    Frame17.Parent = ScrollingFrame

    local TextLabel16 = Instance.new("TextLabel")

    TextLabel16.Size = UDim2.new(1, 0, 0, 15)
    TextLabel16.BackgroundTransparency = 1
    TextLabel16.Text = "v" .. p15 .. " • " .. p16
    TextLabel16.Font = Enum.Font.GothamBold
    TextLabel16.TextColor3 = value18_2.TextMain
    TextLabel16.TextSize = 11
    TextLabel16.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel16.Parent = Frame17

    local TextLabel17 = Instance.new("TextLabel")

    TextLabel17.Size = UDim2.new(1, 0, 0, 0)
    TextLabel17.Position = UDim2.new(0, 0, 0, 22)
    TextLabel17.BackgroundTransparency = 1
    TextLabel17.Text = t7.EN[p17]
    TextLabel17.Font = Enum.Font.GothamMedium
    TextLabel17.TextColor3 = value18_2.TextSub
    TextLabel17.TextSize = 11
    TextLabel17.LineHeight = 1.3
    TextLabel17.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel17.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel17.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel17.Parent = Frame17
    t4[p17] = TextLabel17

    local Frame18 = Instance.new("Frame")

    Frame18.Size = UDim2.new(1, 0, 0, 1)
    Frame18.Position = UDim2.new(0, 0, 1, 10)
    Frame18.AnchorPoint = Vector2.new(0, 1)
    Frame18.BackgroundColor3 = value18_2.Stroke
    Frame18.BorderSizePixel = 0
    Frame18.Parent = Frame17
end
v126("2.8", "Ago 01, 2026", "L1")
v126("2.7", "Jun 08, 2026", "L2")
v126("2.6", "May 04, 2026", "L3")
task.spawn(function()
    value13:Create(value23, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.4
	}):Play()
    task.wait(0.1)
    value13:Create(UIScale, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()
    value13:Create(TextLabel2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()
    TextLabel2.Text = "loading script.."
    task.wait(1.5)
    TextLabel2.Text = "Downloading the new version.."
    task.wait(1.8)
    TextLabel2.Text = "optimizing script.."
    task.wait(1.5)
    TextLabel2.Text = "ENJOY"
    TextLabel2.TextColor3 = value18
    task.wait(1.2)

    if type(writefile) == "function" then
        local v200 = v8 .. " | User: " .. value19_2.Name .. " | Time: " .. os.date("%c")
        local v201 = value4(v200, "NexVoid_UltraSecure_Key_V2.8")

        pcall(writefile, v7, v201)
    elseif type(getgenv) == "function" then
        getgenv()["NexVoid_Update_2.8"] = true
    end

    value13:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Scale = 0
	}):Play()
    value13:Create(TextLabel2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		TextTransparency = 1
	}):Play()
    value13:Create(value23, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1
	}):Play()
    task.wait(0.6)

    if connection then
        connection:Disconnect()
    end

    ScreenGui:Destroy()
    ScreenGui2.Enabled = true
    value13:Create(Frame9, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.5
	}):Play()
    value13:Create(Frame10, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()
end)
