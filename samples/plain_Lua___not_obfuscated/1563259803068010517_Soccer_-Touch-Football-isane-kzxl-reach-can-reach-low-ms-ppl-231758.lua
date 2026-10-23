-- ====================================================================
-- SISTEMA DE MODERAÇÃO E ANTI-CHEAT PARA LIGA DE FUTEBOL ROBLOX
-- Compatível com Delta Executor / Luau
-- ====================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- --------------------------------------------------------------------
-- BANCO DE DADOS LOCAL DO SISTEMA (Credenciais e Logs Internos)
-- NOTA: As credenciais do sistema NÃO possuem relação com contas Roblox.
-- --------------------------------------------------------------------
local SystemAccounts = {
    ["KKKK"] = { password = "KKKKK", isAdmin = true }
}

local SystemLogs = {
    {
        username = "ExemploUser1",
        displayName = "JogadorExemplo",
        reason = "Speed Hack Detectado (WalkSpeed > 24)",
        datetime = "07/10/2026 14:30",
        status = "Pending"
    },
    {
        username = "ExemploUser2",
        displayName = "AtacantePro",
        reason = "Teleport/Fly suspeito na área do gol",
        datetime = "07/10/2026 15:12",
        status = "Confirmed"
    }
}

local CurrentUser = nil

-- --------------------------------------------------------------------
-- INTERFACE GRÁFICA (UI)
-- --------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LeagueModHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra de Título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "LEAGUE MODERATION HUB"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

-- Contêiner do Form de Auth
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(1, 0, 1, -40)
AuthFrame.Position = UDim2.new(0, 0, 0, 40)
AuthFrame.BackgroundTransparency = 1
AuthFrame.Parent = MainFrame

local UserInput = Instance.new("TextBox")
UserInput.Size = UDim2.new(0, 280, 0, 38)
UserInput.Position = UDim2.new(0.5, -140, 0.2, 0)
UserInput.PlaceholderText = "System Username"
UserInput.Text = ""
UserInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UserInput.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
UserInput.Font = Enum.Font.Gotham
UserInput.TextSize = 13
UserInput.Parent = AuthFrame
Instance.new("UICorner", UserInput).CornerRadius = UDim.new(0, 6)

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(0, 280, 0, 38)
PassInput.Position = UDim2.new(0.5, -140, 0.35, 0)
PassInput.PlaceholderText = "System Password"
PassInput.Text = ""
PassInput.TextScaled = false
PassInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PassInput.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
PassInput.Font = Enum.Font.Gotham
PassInput.TextSize = 13
PassInput.Parent = AuthFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 6)

local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0, 135, 0, 36)
LoginBtn.Position = UDim2.new(0.5, -140, 0.52, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.TextSize = 13
LoginBtn.Parent = AuthFrame
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 6)

local RegisterBtn = Instance.new("TextButton")
RegisterBtn.Size = UDim2.new(0, 135, 0, 36)
RegisterBtn.Position = UDim2.new(0.5, 5, 0.52, 0)
RegisterBtn.Text = "Create Account"
RegisterBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 62)
RegisterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RegisterBtn.Font = Enum.Font.GothamBold
RegisterBtn.TextSize = 13
RegisterBtn.Parent = AuthFrame
Instance.new("UICorner", RegisterBtn).CornerRadius = UDim.new(0, 6)

local StatusMsg = Instance.new("TextLabel")
StatusMsg.Size = UDim2.new(0, 280, 0, 25)
StatusMsg.Position = UDim2.new(0.5, -140, 0.68, 0)
StatusMsg.Text = ""
StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
StatusMsg.BackgroundTransparency = 1
StatusMsg.Font = Enum.Font.Gotham
StatusMsg.TextSize = 12
StatusMsg.Parent = AuthFrame

-- Notice de Esclarecimento sobre Credenciais
local AuthNotice = Instance.new("TextLabel")
AuthNotice.Size = UDim2.new(0, 380, 0, 35)
AuthNotice.Position = UDim2.new(0.5, -190, 0.82, 0)
AuthNotice.Text = "Aviso: Estas credenciais são exclusivas do Hub da Liga.\nNUNCA insira dados da sua conta Roblox aqui."
AuthNotice.TextColor3 = Color3.fromRGB(130, 135, 145)
AuthNotice.BackgroundTransparency = 1
AuthNotice.Font = Enum.Font.Gotham
AuthNotice.TextSize = 10
AuthNotice.Parent = AuthFrame

-- Painel Administrativo
local AdminFrame = Instance.new("Frame")
AdminFrame.Size = UDim2.new(1, 0, 1, -40)
AdminFrame.Position = UDim2.new(0, 0, 0, 40)
AdminFrame.BackgroundTransparency = 1
AdminFrame.Visible = false
AdminFrame.Parent = MainFrame

-- Barra Superior do ADM (Busca, Filtro e Logout)
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 180, 0, 28)
SearchBox.Position = UDim2.new(0, 15, 0, 10)
SearchBox.PlaceholderText = "Buscar por Username/Display"
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
SearchBox.Parent = AdminFrame
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local FilterBtn = Instance.new("TextButton")
FilterBtn.Size = UDim2.new(0, 100, 0, 28)
FilterBtn.Position = UDim2.new(0, 205, 0, 10)
FilterBtn.Text = "Filtro: TODOS"
FilterBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
FilterBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
FilterBtn.Font = Enum.Font.Gotham
FilterBtn.TextSize = 10
FilterBtn.Parent = AdminFrame
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 4)

local LogoutBtn = Instance.new("TextButton")
LogoutBtn.Size = UDim2.new(0, 80, 0, 28)
LogoutBtn.Position = UDim2.new(1, -95, 0, 10)
LogoutBtn.Text = "Logout"
LogoutBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LogoutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoutBtn.Font = Enum.Font.GothamBold
LogoutBtn.TextSize = 11
LogoutBtn.Parent = AdminFrame
Instance.new("UICorner", LogoutBtn).CornerRadius = UDim.new(0, 4)

-- Container dos Logs
local LogsScroll = Instance.new("ScrollingFrame")
LogsScroll.Size = UDim2.new(1, -30, 1, -55)
LogsScroll.Position = UDim2.new(0, 15, 0, 45)
LogsScroll.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
LogsScroll.BorderSizePixel = 0
LogsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogsScroll.ScrollBarThickness = 4
LogsScroll.Parent = AdminFrame
Instance.new("UICorner", LogsScroll).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = LogsScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- --------------------------------------------------------------------
-- LÓGICA DE ATUALIZAÇÃO E INTERAÇÃO DA UI
-- --------------------------------------------------------------------
local currentFilterIndex = 1
local filterStatuses = {"ALL", "Pending", "Confirmed", "Rejected"}

local function RenderLogs()
    for _, child in pairs(LogsScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local filter = filterStatuses[currentFilterIndex]
    local searchText = SearchBox.Text:lower()
    local totalHeight = 0

    for idx, log in ipairs(SystemLogs) do
        local matchesFilter = (filter == "ALL") or (log.status == filter)
        local matchesSearch = (log.username:lower():find(searchText) ~= nil) or 
                              (log.displayName:lower():find(searchText) ~= nil)

        if matchesFilter and matchesSearch then
            local LogFrame = Instance.new("Frame")
            LogFrame.Size = UDim2.new(1, -8, 0, 52)
            LogFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
            LogFrame.Parent = LogsScroll
            Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 4)

            local InfoLabel = Instance.new("TextLabel")
            InfoLabel.Size = UDim2.new(1, -120, 1, 0)
            InfoLabel.Position = UDim2.new(0, 10, 0, 0)
            InfoLabel.Text = string.format("<b>%s</b> (@%s) - %s\n<font color='#A0A0A0'>%s | Status: <b>%s</b></font>", 
                log.displayName, log.username, log.reason, log.datetime, log.status)
            InfoLabel.RichText = true
            InfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            InfoLabel.Font = Enum.Font.Gotham
            InfoLabel.TextSize = 11
            InfoLabel.BackgroundTransparency = 1
            InfoLabel.Parent = LogFrame

            -- Botão para alternar Status do Log
            local StatusBtn = Instance.new("TextButton")
            StatusBtn.Size = UDim2.new(0, 90, 0, 24)
            StatusBtn.Position = UDim2.new(1, -100, 0.5, -12)
            StatusBtn.Text = log.status
            StatusBtn.Font = Enum.Font.GothamBold
            StatusBtn.TextSize = 10
            
            if log.status == "Pending" then
                StatusBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 20)
            elseif log.status == "Confirmed" then
                StatusBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
            else
                StatusBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
            end
            
            StatusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            StatusBtn.Parent = LogFrame
            Instance.new("UICorner", StatusBtn).CornerRadius = UDim.new(0, 4)

            StatusBtn.MouseButton1Click:Connect(function()
                if log.status == "Pending" then log.status = "Confirmed"
                elseif log.status == "Confirmed" then log.status = "Rejected"
                else log.status = "Pending" end
                RenderLogs()
            end)

            totalHeight = totalHeight + 56
        end
    end

    LogsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Ações de Login e Cadastro
LoginBtn.MouseButton1Click:Connect(function()
    local user = UserInput.Text
    local pass = PassInput.Text

    if SystemAccounts[user] and SystemAccounts[user].password == pass then
        CurrentUser = user
        StatusMsg.Text = ""
        if SystemAccounts[user].isAdmin then
            AuthFrame.Visible = false
            AdminFrame.Visible = true
            RenderLogs()
        else
            StatusMsg.TextColor3 = Color3.fromRGB(85, 255, 85)
            StatusMsg.Text = "Login efetuado (Acesso padrão)."
        end
    else
        StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
        StatusMsg.Text = "Credenciais inválidas do hub."
    end
end)

RegisterBtn.MouseButton1Click:Connect(function()
    local user = UserInput.Text
    local pass = PassInput.Text

    if user == "" or pass == "" then
        StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
        StatusMsg.Text = "Preencha usuário e senha."
        return
    end

    if SystemAccounts[user] then
        StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
        StatusMsg.Text = "Usuário já existente."
    else
        SystemAccounts[user] = { password = pass, isAdmin = false }
        StatusMsg.TextColor3 = Color3.fromRGB(85, 255, 85)
        StatusMsg.Text = "Conta criada com sucesso!"
    end
end)

LogoutBtn.MouseButton1Click:Connect(function()
    CurrentUser = nil
    AdminFrame.Visible = false
    AuthFrame.Visible = true
    UserInput.Text = ""
    PassInput.Text = ""
    StatusMsg.Text = ""
end)

FilterBtn.MouseButton1Click:Connect(function()
    currentFilterIndex = (currentFilterIndex % #filterStatuses) + 1
    FilterBtn.Text = "Filtro: " .. filterStatuses[currentFilterIndex]
    RenderLogs()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    RenderLogs()
end)

-- --------------------------------------------------------------------
-- SISTEMA DE DETECÇÃO ANTI-CHEAT & AVISO
-- --------------------------------------------------------------------
local function ShowFlaggedWarning(reasonText)
    -- Gera log automático para o painel de moderação
    table.insert(SystemLogs, 1, {
        username = LocalPlayer.Name,
        displayName = LocalPlayer.DisplayName,
        reason = reasonText,
        datetime = os.date("%d/%m/%Y %H:%M"),
        status = "Pending"
    })

    -- Tela de Alerta Vermelha (Screen Warning em Inglês)
    local WarnGui = Instance.new("ScreenGui")
    WarnGui.Name = "CheatWarningGui"
    WarnGui.ResetOnSpawn = false
    WarnGui.Parent = PlayerGui

    local AlertFrame = Instance.new("Frame")
    AlertFrame.Size = UDim2.new(1, 0, 1, 0)
    AlertFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    AlertFrame.BackgroundTransparency = 0.1
    AlertFrame.Parent = WarnGui

    local WarnTitle = Instance.new("TextLabel")
    WarnTitle.Size = UDim2.new(1, 0, 0, 60)
    WarnTitle.Position = UDim2.new(0, 0, 0.4, -30)
    WarnTitle.Text = "YOU HAVE BEEN CAUGHT CHEATING"
    WarnTitle.TextColor3 = Color3.fromRGB(255, 30, 30)
    WarnTitle.Font = Enum.Font.GothamBold
    WarnTitle.TextSize = 28
    WarnTitle.BackgroundTransparency = 1
    WarnTitle.Parent = AlertFrame

    local WarnSub = Instance.new("TextLabel")
    WarnSub.Size = UDim2.new(1, 0, 0, 40)
    WarnSub.Position = UDim2.new(0, 0, 0.4, 30)
    WarnSub.Text = "Your activity has been flagged for league moderation."
    WarnSub.TextColor3 = Color3.fromRGB(200, 200, 200)
    WarnSub.Font = Enum.Font.Gotham
    WarnSub.TextSize = 16
    WarnSub.BackgroundTransparency = 1
    WarnSub.Parent = AlertFrame

    task.delay(6, function()
        WarnGui:Destroy()
    end)
end

-- Detecção básica de WalkSpeed (Apenas Exemplo Funcional)
task.spawn(function()
    while task.wait(2) do
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed > 28 then
                ShowFlaggedWarning("Alteração anormal de WalkSpeed (>28)")
                break
            end
        end
    end
end)