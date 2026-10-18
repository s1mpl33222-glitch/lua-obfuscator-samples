--[[
═══════════════════════════════════════════════════════════════
   FAST FLAGS V1 — PARTE 1/3
   • Config, HWID, validação de key
═══════════════════════════════════════════════════════════════
]]

pcall(function()
    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    for _, name in ipairs({"FlagsPanelUI", "LoadingScreenUI", "KeyScreenUI"}) do
        local old = pg:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService  = game:GetService("TeleportService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local GuiService       = game:GetService("GuiService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local MASTERSTRAP_URL = "https://raw.githubusercontent.com/Masterstrap/Mobilestrap/main/script.lua"
local API_URL  = "https://script.google.com/macros/s/AKfycby_8smGs_VD7Mk1Mi1f01vzJTrJzn9jyGawQ1RQ9vm5I6g3Dmb8slro3kCEUW0wuTKE/exec"
local SITE_URL = "https://systemkey-gesiscriptadm.netlify.app/"
local KEY_FILE = "fastflags_key.txt"
local JSON_PADRAO = '{"FFlagDebugDisplayFPS": "True"}'

local COR = {
    fundo       = Color3.fromRGB(5, 5, 8),
    fundoInput  = Color3.fromRGB(18, 12, 12),
    fundoHeader = Color3.fromRGB(22, 15, 15),
    vermelho    = Color3.fromRGB(220, 30, 30),
    vermelhoClaro = Color3.fromRGB(255, 100, 100),
    vermelhoEscuro = Color3.fromRGB(150, 20, 20),
    textoBranco = Color3.fromRGB(240, 240, 245),
    textoCinza  = Color3.fromRGB(160, 140, 140),
    textoFraco  = Color3.fromRGB(90, 80, 80),
    verde       = Color3.fromRGB(90, 200, 120),
    amarelo     = Color3.fromRGB(255, 200, 100),
}

local function tween(o, t, p)
    TweenService:Create(o, TweenInfo.new(t), p):Play()
end

local function getHWID()
    local data = tostring(LP.UserId) .. "|" .. game.PlaceId .. "|FASTFLAGS"
    local hash = 0
    for i = 1, #data do
        hash = bit32.bxor(bit32.lshift(hash, 5) - hash, data:byte(i))
        hash = bit32.band(hash, 0xFFFFFFFF)
    end
    return "HW-" .. string.upper(string.format("%x", hash))
end

local function validarKey(key)
    local pattern = "^GESI%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]$"
    if not string.match(key, pattern) then
        return false, "Formato inválido"
    end

    local url = API_URL .. "?acao=validar&chave=" .. key .. "&hwid=" .. getHWID()

    local ok, resposta = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or not resposta or resposta == "" then
        return false, "Erro de conexão"
    end

    local okJ, dados = pcall(function()
        return HttpService:JSONDecode(resposta)
    end)

    if not okJ or type(dados) ~= "table" then
        return false, "Resposta inválida"
    end

    if dados.ok == true then
        return true
    end

    return false, dados.msg or "Key inválida"
end

local function salvarKey(key)
    pcall(function() writefile(KEY_FILE, key) end)
end

local function lerKeySalva()
    local ok, key = pcall(function()
        if isfile and isfile(KEY_FILE) then
            return readfile(KEY_FILE)
        end
    end)
    if ok and key and key ~= "" then return key end
    return nil
end

print("[FAST FLAGS V1] Parte 1 carregada")
--[[
═══════════════════════════════════════════════════════════════
   FAST FLAGS V1 — PARTE 2/3
═══════════════════════════════════════════════════════════════
]]

local function mostrarTelaKey(callback)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeyScreenUI"
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KeyGui.DisplayOrder = 20
    KeyGui.Parent = PG

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 300, 0, 250)
    Box.Position = UDim2.new(0.5, -150, 0.5, -125)
    Box.BackgroundColor3 = COR.fundo
    Box.BorderSizePixel = 0
    Box.Active = true
    Box.Draggable = true
    Box.Parent = KeyGui

    local BoxStroke = Instance.new("UIStroke", Box)
    BoxStroke.Color = COR.vermelho
    BoxStroke.Thickness = 1.5
    BoxStroke.Transparency = 0

    local BoxGlow = Instance.new("UIStroke", Box)
    BoxGlow.Color = COR.vermelho
    BoxGlow.Thickness = 4
    BoxGlow.Transparency = 0.85

    task.spawn(function()
        local t = 0
        while Box.Parent do
            t = t + 0.05
            local sin = (math.sin(t) + 1) / 2
            pcall(function()
                BoxGlow.Transparency = 0.85 - (sin * 0.15)
                BoxStroke.Transparency = 0.1 + (sin * 0.2)
            end)
            task.wait(0.05)
        end
    end)

    local Titulo = Instance.new("TextLabel")
    Titulo.Size = UDim2.new(1, -24, 0, 28)
    Titulo.Position = UDim2.new(0, 12, 0, 14)
    Titulo.BackgroundTransparency = 1
    Titulo.Text = "GESISCRIPT"
    Titulo.TextColor3 = COR.vermelho
    Titulo.Font = Enum.Font.GothamBlack
    Titulo.TextSize = 18
    Titulo.Parent = Box

    local Subtitulo = Instance.new("TextLabel")
    Subtitulo.Size = UDim2.new(1, -24, 0, 14)
    Subtitulo.Position = UDim2.new(0, 12, 0, 42)
    Subtitulo.BackgroundTransparency = 1
    Subtitulo.Text = "(fast flags v1)"
    Subtitulo.TextColor3 = COR.textoCinza
    Subtitulo.Font = Enum.Font.GothamMedium
    Subtitulo.TextSize = 10
    Subtitulo.Parent = Box

    local Linha = Instance.new("Frame")
    Linha.Size = UDim2.new(1, -50, 0, 1)
    Linha.Position = UDim2.new(0, 25, 0, 62)
    Linha.BackgroundColor3 = COR.vermelho
    Linha.BackgroundTransparency = 0.6
    Linha.BorderSizePixel = 0
    Linha.Parent = Box

    local Instr = Instance.new("TextLabel")
    Instr.Size = UDim2.new(1, -24, 0, 14)
    Instr.Position = UDim2.new(0, 12, 0, 72)
    Instr.BackgroundTransparency = 1
    Instr.Text = "Insira sua key para continuar"
    Instr.TextColor3 = COR.textoCinza
    Instr.Font = Enum.Font.GothamMedium
    Instr.TextSize = 10
    Instr.Parent = Box

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -24, 0, 38)
    KeyInput.Position = UDim2.new(0, 12, 0, 90)
    KeyInput.BackgroundColor3 = COR.fundoInput
    KeyInput.BorderSizePixel = 0
    KeyInput.PlaceholderText = "GESI-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
    KeyInput.Text = ""
    KeyInput.TextColor3 = COR.textoBranco
    KeyInput.Font = Enum.Font.Code
    KeyInput.TextSize = 12
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Box
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local KeyInputStroke = Instance.new("UIStroke", KeyInput)
    KeyInputStroke.Color = Color3.fromRGB(80, 40, 40)
    KeyInputStroke.Thickness = 1
    KeyInputStroke.Transparency = 0.3

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -24, 0, 38)
    VerifyBtn.Position = UDim2.new(0, 12, 0, 136)
    VerifyBtn.BackgroundColor3 = COR.vermelhoEscuro
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.Text = "VERIFICAR"
    VerifyBtn.TextColor3 = COR.textoBranco
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 12
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.Parent = Box
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

    local VerifyStroke = Instance.new("UIStroke", VerifyBtn)
    VerifyStroke.Color = COR.vermelhoClaro
    VerifyStroke.Thickness = 1
    VerifyStroke.Transparency = 0.3

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(1, -24, 0, 34)
    GetKeyBtn.Position = UDim2.new(0, 12, 0, 182)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Text = "🔑  PEGAR KEY"
    GetKeyBtn.TextColor3 = COR.textoCinza
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 11
    GetKeyBtn.AutoButtonColor = false
    GetKeyBtn.Parent = Box
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

    local GetKeyStroke = Instance.new("UIStroke", GetKeyBtn)
    GetKeyStroke.Color = Color3.fromRGB(80, 40, 40)
    GetKeyStroke.Thickness = 1
    GetKeyStroke.Transparency = 0.4

    local KeyFeedback = Instance.new("TextLabel")
    KeyFeedback.Size = UDim2.new(1, -24, 0, 14)
    KeyFeedback.Position = UDim2.new(0, 12, 0, 222)
    KeyFeedback.BackgroundTransparency = 1
    KeyFeedback.Text = ""
    KeyFeedback.TextColor3 = COR.vermelho
    KeyFeedback.Font = Enum.Font.GothamMedium
    KeyFeedback.TextSize = 10
    KeyFeedback.Parent = Box

    local function setFeedback(txt, cor)
        KeyFeedback.Text = txt
        KeyFeedback.TextColor3 = cor
    end

    KeyInput.Focused:Connect(function()
        tween(KeyInputStroke, 0.15, { Color = COR.vermelho, Transparency = 0 })
    end)
    KeyInput.FocusLost:Connect(function()
        tween(KeyInputStroke, 0.15, { Color = Color3.fromRGB(80, 40, 40), Transparency = 0.3 })
    end)

    VerifyBtn.MouseEnter:Connect(function()
        tween(VerifyBtn, 0.15, { BackgroundColor3 = COR.vermelho })
    end)
    VerifyBtn.MouseLeave:Connect(function()
        tween(VerifyBtn, 0.15, { BackgroundColor3 = COR.vermelhoEscuro })
    end)

    GetKeyBtn.MouseEnter:Connect(function()
        tween(GetKeyBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 18, 18) })
        tween(GetKeyStroke, 0.15, { Color = COR.vermelho, Transparency = 0.2 })
        tween(GetKeyBtn, 0.15, { TextColor3 = COR.textoBranco })
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        tween(GetKeyBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 10, 10) })
        tween(GetKeyStroke, 0.15, { Color = Color3.fromRGB(80, 40, 40), Transparency = 0.4 })
        tween(GetKeyBtn, 0.15, { TextColor3 = COR.textoCinza })
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(SITE_URL) end
        end)
        pcall(function()
            GuiService:OpenBrowserWindow(SITE_URL)
        end)

        GetKeyBtn.Text = "✓  COPIADO!"
        tween(GetKeyBtn, 0.2, {
            BackgroundColor3 = Color3.fromRGB(20, 60, 35),
            TextColor3 = Color3.fromRGB(100, 220, 130)
        })
        tween(GetKeyStroke, 0.2, { Color = COR.verde, Transparency = 0 })

        task.delay(2, function()
            if not GetKeyBtn.Parent then return end
            GetKeyBtn.Text = "🔑  PEGAR KEY"
            tween(GetKeyBtn, 0.2, {
                BackgroundColor3 = Color3.fromRGB(20, 10, 10),
                TextColor3 = COR.textoCinza
            })
            tween(GetKeyStroke, 0.2, { Color = Color3.fromRGB(80, 40, 40), Transparency = 0.4 })
        end)
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        local key = KeyInput.Text:gsub("%s", ""):upper()
        if key == "" then
            return setFeedback("Digite uma key", COR.vermelho)
        end

        setFeedback("Verificando...", COR.textoCinza)
        VerifyBtn.Text = "AGUARDE..."

        task.spawn(function()
            local valido, erro = validarKey(key)
            if valido then
                salvarKey(key)
                setFeedback("✓ Key válida!", COR.verde)
                tween(VerifyStroke, 0.2, { Color = COR.verde, Transparency = 0 })
                task.wait(0.8)
                KeyGui:Destroy()
                callback()
            else
                setFeedback(tostring(erro or "Key inválida"), COR.vermelho)
                VerifyBtn.Text = "VERIFICAR"
                tween(VerifyStroke, 0.2, { Color = COR.vermelho, Transparency = 0 })

                local posOrig = Box.Position
                for i = 1, 4 do
                    Box.Position = posOrig + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)
                    task.wait(0.03)
                end
                Box.Position = posOrig
                tween(VerifyStroke, 0.3, { Color = COR.vermelhoClaro, Transparency = 0.3 })
            end
        end)
    end)
end

local ScreenGui

local function criarPainelPrincipal()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlagsPanelUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 10
    ScreenGui.Parent = PG

    local LARGURA = 320
    local ALTURA = 340

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, LARGURA, 0, ALTURA)
    MainFrame.Position = UDim2.new(0.5, -LARGURA/2, 0.5, -ALTURA/2)
    MainFrame.BackgroundColor3 = COR.fundo
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = COR.vermelho
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.1

    local UIGlow = Instance.new("UIStroke", MainFrame)
    UIGlow.Color = COR.vermelho
    UIGlow.Thickness = 4
    UIGlow.Transparency = 0.85

    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.05
            local sin = (math.sin(t) + 1) / 2
            pcall(function()
                UIGlow.Transparency = 0.85 - (sin * 0.15)
            end)
            task.wait(0.05)
        end
    end)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = COR.fundoHeader
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderLinha = Instance.new("Frame")
    HeaderLinha.Size = UDim2.new(1, -20, 0, 1)
    HeaderLinha.Position = UDim2.new(0, 10, 1, -1)
    HeaderLinha.BackgroundColor3 = COR.vermelho
    HeaderLinha.BackgroundTransparency = 0.7
    HeaderLinha.BorderSizePixel = 0
    HeaderLinha.Parent = Header

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 22, 0, 22)
    IconFrame.Position = UDim2.new(0, 10, 0.5, -11)
    IconFrame.BackgroundColor3 = COR.vermelho
    IconFrame.BorderSizePixel = 0
    IconFrame.Parent = Header

    local IconText = Instance.new("TextLabel")
    IconText.Size = UDim2.new(1, 0, 1, 0)
    IconText.BackgroundTransparency = 1
    IconText.Text = "⚙️"
    IconText.TextColor3 = Color3.fromRGB(5, 5, 8)
    IconText.TextScaled = true
    IconText.Font = Enum.Font.GothamBold
    IconText.Parent = IconFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 0, 20)
    TitleLabel.Position = UDim2.new(0, 40, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "FAST FLAGS V1"
    TitleLabel.TextColor3 = COR.textoBranco
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -100, 0, 10)
    SubLabel.Position = UDim2.new(0, 40, 0, 24)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "cole o json de flags"
    SubLabel.TextColor3 = COR.textoCinza
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 9
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = COR.vermelho
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header

    local LabelJson = Instance.new("TextLabel")
    LabelJson.Size = UDim2.new(1, -20, 0, 14)
    LabelJson.Position = UDim2.new(0, 10, 0, 52)
    LabelJson.BackgroundTransparency = 1
    LabelJson.Text = "COLA O JSON AQUI"
    LabelJson.TextColor3 = COR.textoCinza
    LabelJson.Font = Enum.Font.GothamBold
    LabelJson.TextSize = 9
    LabelJson.TextXAlignment = Enum.TextXAlignment.Left
    LabelJson.Parent = MainFrame

    local InputJson = Instance.new("TextBox")
    InputJson.Size = UDim2.new(1, -20, 0, 110)
    InputJson.Position = UDim2.new(0, 10, 0, 70)
    InputJson.BackgroundColor3 = COR.fundoInput
    InputJson.BorderSizePixel = 0
    InputJson.Text = JSON_PADRAO
    InputJson.PlaceholderText = '{"FFlagDebugDisplayFPS": "True"}'
    InputJson.PlaceholderColor3 = Color3.fromRGB(90, 70, 70)
    InputJson.TextColor3 = COR.textoBranco
    InputJson.Font = Enum.Font.Code
    InputJson.TextSize = 10
    InputJson.TextWrapped = true
    InputJson.TextXAlignment = Enum.TextXAlignment.Left
    InputJson.TextYAlignment = Enum.TextYAlignment.Top
    InputJson.ClearTextOnFocus = false
    InputJson.MultiLine = true
    InputJson.Parent = MainFrame
    Instance.new("UICorner", InputJson).CornerRadius = UDim.new(0, 6)

    local InputPadding = Instance.new("UIPadding", InputJson)
    InputPadding.PaddingTop = UDim.new(0, 8)
    InputPadding.PaddingLeft = UDim.new(0, 8)
    InputPadding.PaddingRight = UDim.new(0, 8)

    local InputStroke = Instance.new("UIStroke", InputJson)
    InputStroke.Color = Color3.fromRGB(80, 40, 40)
    InputStroke.Thickness = 1
    InputStroke.Transparency = 0.3

    local Feedback = Instance.new("TextLabel")
    Feedback.Size = UDim2.new(1, -20, 0, 30)
    Feedback.Position = UDim2.new(0, 10, 0, 186)
    Feedback.BackgroundTransparency = 1
    Feedback.Text = "Cole as flags e clique em APLICAR"
    Feedback.TextColor3 = COR.textoCinza
    Feedback.Font = Enum.Font.GothamMedium
    Feedback.TextSize = 10
    Feedback.TextWrapped = true
    Feedback.TextXAlignment = Enum.TextXAlignment.Left
    Feedback.TextYAlignment = Enum.TextYAlignment.Top
    Feedback.Parent = MainFrame

    local AplicarBtn = Instance.new("TextButton")
    AplicarBtn.Size = UDim2.new(1, -20, 0, 46)
    AplicarBtn.Position = UDim2.new(0, 10, 0, 220)
    AplicarBtn.BackgroundColor3 = COR.vermelhoEscuro
    AplicarBtn.BorderSizePixel = 0
    AplicarBtn.Text = "APLICAR"
    AplicarBtn.TextColor3 = Color3.fromRGB(255, 230, 230)
    AplicarBtn.Font = Enum.Font.GothamBlack
    AplicarBtn.TextSize = 13
    AplicarBtn.AutoButtonColor = false
    AplicarBtn.Parent = MainFrame
    Instance.new("UICorner", AplicarBtn).CornerRadius = UDim.new(0, 8)

    local AplicarStroke = Instance.new("UIStroke", AplicarBtn)
    AplicarStroke.Color = COR.vermelhoClaro
    AplicarStroke.Thickness = 1.5
    AplicarStroke.Transparency = 0.2

    local RejoinBtn = Instance.new("TextButton")
    RejoinBtn.Size = UDim2.new(1, -20, 0, 38)
    RejoinBtn.Position = UDim2.new(0, 10, 0, 274)
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
    RejoinBtn.BorderSizePixel = 0
    RejoinBtn.Text = "REJOIN"
    RejoinBtn.TextColor3 = COR.textoCinza
    RejoinBtn.Font = Enum.Font.GothamBold
    RejoinBtn.TextSize = 11
    RejoinBtn.AutoButtonColor = false
    RejoinBtn.Parent = MainFrame
    Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 6)

    local RejoinStroke = Instance.new("UIStroke", RejoinBtn)
    RejoinStroke.Color = Color3.fromRGB(120, 50, 50)
    RejoinStroke.Thickness = 1
    RejoinStroke.Transparency = 0.3

    local Credito = Instance.new("TextLabel")
    Credito.Size = UDim2.new(0, 120, 0, 12)
    Credito.Position = UDim2.new(1, -125, 1, -16)
    Credito.BackgroundTransparency = 1
    Credito.Text = "created by GESI"
    Credito.TextColor3 = COR.textoFraco
    Credito.Font = Enum.Font.Gotham
    Credito.TextSize = 9
    Credito.TextXAlignment = Enum.TextXAlignment.Right
    Credito.Parent = MainFrame

    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.05
            local pulse = (math.sin(t * 2) + 1) / 2
            pcall(function()
                Credito.TextTransparency = 0.3 + (pulse * 0.15)
            end)
            task.wait(0.05)
        end
    end)

    AplicarBtn.MouseEnter:Connect(function()
        tween(AplicarBtn, 0.15, { BackgroundColor3 = COR.vermelho })
    end)
    AplicarBtn.MouseLeave:Connect(function()
        tween(AplicarBtn, 0.15, { BackgroundColor3 = COR.vermelhoEscuro })
    end)

    InputJson.Focused:Connect(function()
        tween(InputStroke, 0.15, { Color = COR.vermelho, Transparency = 0 })
    end)
    InputJson.FocusLost:Connect(function()
        tween(InputStroke, 0.15, { Color = Color3.fromRGB(80, 40, 40), Transparency = 0.3 })
    end)

    RejoinBtn.MouseButton1Click:Connect(function()
        RejoinBtn.Text = "REJOINANDO..."
        local ok = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
        if not ok then
            RejoinBtn.Text = "SAIA E ENTRE"
            task.delay(2, function()
                RejoinBtn.Text = "REJOIN"
            end)
        end
    end)

    RejoinBtn.MouseEnter:Connect(function()
        tween(RejoinBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(80, 25, 25) })
    end)
    RejoinBtn.MouseLeave:Connect(function()
        tween(RejoinBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(65, 20, 20) })
    end)

    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(120, 20, 30) })
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(40, 15, 20) })
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
end

print("[FAST FLAGS V1] Parte 2 carregada")
--[[
═══════════════════════════════════════════════════════════════
   FAST FLAGS V1 — PARTE 3/3
═══════════════════════════════════════════════════════════════
]]

-- Loading GUI
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingScreenUI"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.DisplayOrder = 9999
LoadingGui.IgnoreGuiInset = true
LoadingGui.Enabled = false
LoadingGui.Parent = PG

local LoadingBg = Instance.new("Frame")
LoadingBg.Size = UDim2.new(1, 0, 1, 0)
LoadingBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingBg.BackgroundTransparency = 0
LoadingBg.BorderSizePixel = 0
LoadingBg.Parent = LoadingGui

local LoadingCard = Instance.new("Frame")
LoadingCard.Size = UDim2.new(0, 320, 0, 200)
LoadingCard.Position = UDim2.new(0.5, -160, 0.5, -100)
LoadingCard.BackgroundColor3 = Color3.fromRGB(8, 5, 5)
LoadingCard.BorderSizePixel = 0
LoadingCard.Parent = LoadingGui
Instance.new("UICorner", LoadingCard).CornerRadius = UDim.new(0, 14)

local CardStroke = Instance.new("UIStroke", LoadingCard)
CardStroke.Color = COR.vermelho
CardStroke.Thickness = 1.5
CardStroke.Transparency = 0.1

local CardGlow = Instance.new("UIStroke", LoadingCard)
CardGlow.Color = COR.vermelho
CardGlow.Thickness = 5
CardGlow.Transparency = 0.8

local LoadIcon = Instance.new("TextLabel")
LoadIcon.Size = UDim2.new(0, 60, 0, 60)
LoadIcon.Position = UDim2.new(0.5, -30, 0, 20)
LoadIcon.BackgroundTransparency = 1
LoadIcon.Text = "⚙️"
LoadIcon.TextColor3 = COR.vermelho
LoadIcon.TextSize = 50
LoadIcon.Font = Enum.Font.GothamBold
LoadIcon.Parent = LoadingCard

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, -20, 0, 24)
LoadTitle.Position = UDim2.new(0, 10, 0, 90)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "CARREGANDO FLAG 📃"
LoadTitle.TextColor3 = COR.textoBranco
LoadTitle.Font = Enum.Font.GothamBlack
LoadTitle.TextSize = 16
LoadTitle.Parent = LoadingCard

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, -20, 0, 16)
LoadStatus.Position = UDim2.new(0, 10, 0, 118)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Preparando..."
LoadStatus.TextColor3 = COR.textoCinza
LoadStatus.Font = Enum.Font.GothamMedium
LoadStatus.TextSize = 11
LoadStatus.Parent = LoadingCard

local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(1, -40, 0, 8)
ProgressBg.Position = UDim2.new(0, 20, 0, 148)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = LoadingCard
Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = COR.vermelho
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local ProgressGrad = Instance.new("UIGradient", ProgressFill)
ProgressGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COR.vermelhoEscuro),
    ColorSequenceKeypoint.new(0.5, COR.vermelho),
    ColorSequenceKeypoint.new(1, COR.vermelhoClaro),
})

local ProgressText = Instance.new("TextLabel")
ProgressText.Size = UDim2.new(1, -40, 0, 16)
ProgressText.Position = UDim2.new(0, 20, 0, 162)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "0%"
ProgressText.TextColor3 = COR.vermelho
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextSize = 11
ProgressText.Parent = LoadingCard

local LoadAnimConn = nil

local function animarLoading()
    if LoadAnimConn then LoadAnimConn:Disconnect() end
    local t = 0
    LoadAnimConn = RunService.RenderStepped:Connect(function(dt)
        t = t + dt
        pcall(function()
            LoadIcon.Rotation = (t * 200) % 360
        end)
        local pulse = (math.sin(t * 4) + 1) / 2
        pcall(function()
            CardGlow.Transparency = 0.8 - (pulse * 0.3)
            CardStroke.Transparency = 0.1 + (pulse * 0.3)
        end)
        local textPulse = (math.sin(t * 6) + 1) / 2
        pcall(function()
            LoadTitle.TextTransparency = 0.1 + (textPulse * 0.15)
        end)
    end)
end

local function pararAnimacaoLoading()
    if LoadAnimConn then
        LoadAnimConn:Disconnect()
        LoadAnimConn = nil
    end
end

local function animarProgresso(de, para, duracao)
    local inicio = tick()
    task.spawn(function()
        while tick() - inicio < duracao do
            local progresso = (tick() - inicio) / duracao
            local atual = de + (para - de) * progresso
            pcall(function()
                ProgressFill.Size = UDim2.new(atual, 0, 1, 0)
                ProgressText.Text = math.floor(atual * 100) .. "%"
            end)
            task.wait(0.02)
        end
        pcall(function()
            ProgressFill.Size = UDim2.new(para, 0, 1, 0)
            ProgressText.Text = math.floor(para * 100) .. "%"
        end)
    end)
end

local function mostrarLoading()
    LoadingGui.Enabled = true
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressText.Text = "0%"
    LoadStatus.Text = "Preparando..."
    animarLoading()

    LoadingBg.BackgroundTransparency = 1
    LoadingCard.BackgroundTransparency = 1
    tween(LoadingBg, 0.3, { BackgroundTransparency = 0 })
    tween(LoadingCard, 0.3, { BackgroundTransparency = 0 })
end

local function esconderLoading()
    pararAnimacaoLoading()
    tween(LoadingBg, 0.3, { BackgroundTransparency = 1 })
    tween(LoadingCard, 0.3, { BackgroundTransparency = 1 })
    task.delay(0.35, function()
        LoadingGui.Enabled = false
    end)
end

local function setStatusLoading(txt)
    pcall(function()
        LoadStatus.Text = txt
    end)
end

local GUIS_PERMITIDOS = {
    ["KeyScreenUI"] = true,
    ["FlagsPanelUI"] = true,
    ["LoadingScreenUI"] = true,
}

local pausarAnti = false

local function matarGui(gui)
    if not gui then return end
    if not (gui:IsA("ScreenGui") or gui:IsA("LayerCollector")) then return end
    if GUIS_PERMITIDOS[gui.Name] then return end
    pcall(function() gui.Enabled = false end)
end

local function matarPlayerGui()
    for _, gui in ipairs(PG:GetChildren()) do
        matarGui(gui)
    end
end

local function matarCoreGui()
    pcall(function()
        local core = game:GetService("CoreGui")
        for _, gui in ipairs(core:GetChildren()) do
            matarGui(gui)
        end
    end)
end

local function matarHiddenGui()
    pcall(function()
        if gethui then
            for _, gui in ipairs(gethui():GetChildren()) do
                matarGui(gui)
            end
        end
    end)
end

local function matarTudoForca()
    pausarAnti = false
    for _ = 1, 3 do
        matarPlayerGui()
        matarCoreGui()
        matarHiddenGui()
        task.wait(0.15)
    end
end

PG.ChildAdded:Connect(function(child)
    matarGui(child)
end)

pcall(function()
    game:GetService("CoreGui").ChildAdded:Connect(function(child)
        matarGui(child)
    end)
end)

task.spawn(function()
    while true do
        if not pausarAnti then
            matarPlayerGui()
            matarCoreGui()
            matarHiddenGui()
        end
        task.wait(0.016)
    end
end)

local function pegarTodosGuis()
    local guis = {}
    for _, g in ipairs(PG:GetChildren()) do
        if g:IsA("ScreenGui") and not GUIS_PERMITIDOS[g.Name] then
            table.insert(guis, g)
        end
    end
    pcall(function()
        local core = game:GetService("CoreGui")
        for _, g in ipairs(core:GetChildren()) do
            if g:IsA("ScreenGui") and not GUIS_PERMITIDOS[g.Name] then
                table.insert(guis, g)
            end
        end
    end)
    pcall(function()
        if gethui then
            for _, g in ipairs(gethui():GetChildren()) do
                if g:IsA("ScreenGui") and not GUIS_PERMITIDOS[g.Name] then
                    table.insert(guis, g)
                end
            end
        end
    end)
    return guis
end

local function acharTextboxJSON()
    for _, gui in ipairs(pegarTodosGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextBox") then
                local ph = (desc.PlaceholderText or ""):lower()
                if ph:find("paste") and ph:find("json") then
                    return desc
                end
            end
        end
    end
    return nil
end

local function acharBotaoApply()
    for _, gui in ipairs(pegarTodosGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextButton") then
                local txt = (desc.Text or ""):lower()
                if txt:find("apply custom") then
                    return desc
                end
            end
        end
    end
    return nil
end

local function acharAbaIntegrations()
    for _, gui in ipairs(pegarTodosGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextButton") then
                local txt = (desc.Text or ""):lower()
                if txt:find("integrations") then
                    return desc
                end
            end
        end
    end
    return nil
end

local function forcarClique(btn)
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function() btn.Activated:Fire() end)
    pcall(function()
        if getconnections then
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                pcall(function() conn:Fire() end)
            end
        end
    end)
end

local function carregarMasterstrap()
    local ok = pcall(function()
        loadstring(game:HttpGet(MASTERSTRAP_URL))()
    end)
    return ok
end

local processando = false

local function conectarPainel()
    task.wait(0.5)

    local painelGui = PG:FindFirstChild("FlagsPanelUI")
    if not painelGui then
        task.wait(1)
        painelGui = PG:FindFirstChild("FlagsPanelUI")
    end
    if not painelGui then return end

    local mainFrame = painelGui:FindFirstChildOfClass("Frame")
    if not mainFrame then return end

    local aplicarBtn = nil
    local inputJson = nil
    local feedback = nil

    for _, desc in ipairs(mainFrame:GetDescendants()) do
        if desc:IsA("TextButton") and desc.Text == "APLICAR" then
            aplicarBtn = desc
        elseif desc:IsA("TextBox") and desc.MultiLine then
            inputJson = desc
        elseif desc:IsA("TextLabel") and desc.Text:find("Cole as flags") then
            feedback = desc
        end
    end

    if not aplicarBtn then return end

    local function setFeedback(txt, cor)
        if feedback then
            feedback.Text = txt
            feedback.TextColor3 = cor
        end
    end

    aplicarBtn.MouseButton1Click:Connect(function()
        if processando then return end
        processando = true

        pausarAnti = true

        local jsonUsuario = inputJson and inputJson.Text or ""
        if jsonUsuario:gsub("%s", "") == "" then
            aplicarBtn.Text = "APLICAR"
            setFeedback("⚠️ Cole um JSON primeiro", COR.vermelho)
            processando = false
            pausarAnti = false
            return
        end

        mostrarLoading()
        aplicarBtn.Text = "APLICANDO..."

        task.spawn(function()
            animarProgresso(0, 0.15, 1.5)
            task.wait(1.5)
            animarProgresso(0.15, 0.35, 1.5)
            task.wait(1.5)
            animarProgresso(0.35, 0.50, 1.0)
        end)

        setStatusLoading("Carregando módulos...")
        task.wait(0.8)

        local ok = carregarMasterstrap()
        if not ok then
            esconderLoading()
            aplicarBtn.Text = "APLICAR"
            setFeedback("❌ Falha ao carregar", COR.vermelho)
            processando = false
            pausarAnti = false
            return
        end

        setStatusLoading("Inicializando (aguarde)...")
        task.wait(5)

        setStatusLoading("Abrindo Integrations...")
        animarProgresso(0.5, 0.65, 0.8)
        local aba = acharAbaIntegrations()
        if aba then
            forcarClique(aba)
            task.wait(2)
        end

        setStatusLoading("Aplicando flag...")
        animarProgresso(0.65, 0.80, 0.8)
        local textbox = acharTextboxJSON()
        if not textbox then
            esconderLoading()
            aplicarBtn.Text = "APLICAR"
            setFeedback("❌ Campo JSON não encontrado", COR.vermelho)
            processando = false
            pausarAnti = false
            return
        end

        textbox.Text = jsonUsuario
        task.wait(0.5)
        textbox.Text = jsonUsuario
        task.wait(0.8)

        setStatusLoading("Finalizando...")
        animarProgresso(0.80, 0.95, 0.8)
        local applyBtn = acharBotaoApply()
        if applyBtn then
            forcarClique(applyBtn)
            task.wait(3)
        end

        animarProgresso(0.95, 1.0, 0.5)
        setStatusLoading("✓ Aplicado!")
        task.wait(1.5)

        pausarAnti = false
        setStatusLoading("Limpando...")
        matarTudoForca()
        task.wait(0.5)

        esconderLoading()

        setFeedback("✓ Aplicado! Clique em REJOIN.", COR.verde)
        aplicarBtn.Text = "✓ APLICADO"

        task.delay(3, function()
            aplicarBtn.Text = "APLICAR"
            processando = false
        end)
    end)
end

task.spawn(function()
    local keySalva = lerKeySalva()

    if keySalva then
        local valido = validarKey(keySalva)
        if valido then
            criarPainelPrincipal()
            task.spawn(conectarPainel)
            return
        else
            pcall(function() delfile(KEY_FILE) end)
        end
    end

    mostrarTelaKey(function()
        criarPainelPrincipal()
        task.spawn(conectarPainel)
    end)
end)

print("[FAST FLAGS V1] Parte 3 carregada • Pronto")