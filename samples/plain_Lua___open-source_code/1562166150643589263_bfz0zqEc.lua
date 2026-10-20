-- =======================================================
-- MONITE HUB BY ALVESCRIPT
-- (Pastebin 1 - Interface Gráfica e Gerenciador Dinâmico)
-- =======================================================

-- Configuração dos Links Pastebin na ORDEM EXATA de exibição
local TabURLs = {
    { Name = "Combate", URL = "https://pastebin.com/raw/VYx6sDMK" },
    { Name = "ESP",     URL = "https://pastebin.com/raw/z8WuGw4D" },
    { Name = "Player",  URL = "https://pastebin.com/raw/L65wveRA" }, -- Link do Player atualizado
    { Name = "Info",    URL = "https://pastebin.com/raw/FUHDFKTN" },
    { Name = "Misc",    URL = "https://pastebin.com/raw/SEU_PASTEBIN_MISC" }
}

-- Tabela para armazenar os módulos carregados em memória
local LoadedModules = {}

-- Limpeza e inicialização da CoreGui
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("MoniteFloatingButton") then
    CoreGui.MoniteFloatingButton:Destroy()
end

-- Busca nome do jogo
local gameName = "Carregando..."
task.spawn(function()
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)
end)

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoniteFloatingButton"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- --- TELA DE CARREGAMENTO (LOADING) ---
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = ScreenGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.ZIndex = 10

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BgImage"
BgImage.Parent = LoadingFrame
BgImage.BackgroundTransparency = 1
BgImage.Position = UDim2.new(-0.5, 0, -0.5, 0)
BgImage.Size = UDim2.new(2, 0, 2, 0)
BgImage.Image = "rbxassetid://123700156206759"
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 11

local Overlay = Instance.new("Frame")
Overlay.Name = "Overlay"
Overlay.Parent = LoadingFrame
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.4
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.ZIndex = 12

local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "LoadingText"
LoadingText.Parent = LoadingFrame
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0.5, -150, 0.52, 0)
LoadingText.Size = UDim2.new(0, 300, 0, 30)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "Carregando Monite Hub..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 18
LoadingText.ZIndex = 13

local BarBackground = Instance.new("Frame")
BarBackground.Name = "BarBackground"
BarBackground.Parent = LoadingFrame
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BarBackground.BorderSizePixel = 0
BarBackground.Position = UDim2.new(0.5, -150, 0.65, 0)
BarBackground.Size = UDim2.new(0, 300, 0, 8)
BarBackground.ZIndex = 13

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBackground

local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = BarBackground
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.ZIndex = 14

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = ProgressBar

-- --- BOTÃO FLUTUANTE ---
local ImageButton = Instance.new("ImageButton")
ImageButton.Name = "ToggleButton"
ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 45, 0, 45)
ImageButton.Draggable = true
ImageButton.Active = true
ImageButton.Image = "rbxassetid://123700156206759"
ImageButton.ScaleType = Enum.ScaleType.Crop
ImageButton.Visible = false

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = ImageButton

-- --- JANELA PRINCIPAL ---
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -235, 0.4, -150)
MainFrame.Size = UDim2.new(0, 470, 0, 300)
MainFrame.Visible = false
MainFrame.Draggable = false
MainFrame.Active = false
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Thickness = 1.5

local MainBgImage = Instance.new("ImageLabel")
MainBgImage.Name = "MainBgImage"
MainBgImage.Parent = MainFrame
MainBgImage.BackgroundTransparency = 1
MainBgImage.Size = UDim2.new(1, 0, 1, 0)
MainBgImage.Image = "rbxassetid://123700156206759"
MainBgImage.ScaleType = Enum.ScaleType.Crop
MainBgImage.ZIndex = 1

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0, 12)
ImageCorner.Parent = MainBgImage

local MainOverlay = Instance.new("Frame")
MainOverlay.Name = "MainOverlay"
MainOverlay.Parent = MainFrame
MainOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainOverlay.BackgroundTransparency = 0.55
MainOverlay.Size = UDim2.new(1, 0, 1, 0)
MainOverlay.ZIndex = 2

local OverlayCorner = Instance.new("UICorner")
OverlayCorner.CornerRadius = UDim.new(0, 12)
OverlayCorner.Parent = MainOverlay

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 4)
TitleLabel.Size = UDim2.new(0, 320, 0, 26)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "monite hub by: alvesscript"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3

-- Controles de Janela
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -70, 0, 6)
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 18
MinimizeButton.ZIndex = 3

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -36, 0, 6)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.ZIndex = 3

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Container de Categorias (Painel Escuro)
local CategoryContainer = Instance.new("Frame")
CategoryContainer.Name = "CategoryContainer"
CategoryContainer.Parent = MainFrame
CategoryContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CategoryContainer.BackgroundTransparency = 0.5
CategoryContainer.BorderSizePixel = 0
CategoryContainer.Position = UDim2.new(0, 10, 0, 36)
CategoryContainer.Size = UDim2.new(0, 125, 0, 185)
CategoryContainer.ZIndex = 3
CategoryContainer.ClipsDescendants = true

local CategoryCorner = Instance.new("UICorner")
CategoryCorner.CornerRadius = UDim.new(0, 8)
CategoryCorner.Parent = CategoryContainer

local CategoryList = Instance.new("UIListLayout")
CategoryList.Parent = CategoryContainer
CategoryList.SortOrder = Enum.SortOrder.LayoutOrder
CategoryList.Padding = UDim.new(0, 4)

local CategoryPadding = Instance.new("UIPadding")
CategoryPadding.Parent = CategoryContainer
CategoryPadding.PaddingTop = UDim.new(0, 5)
CategoryPadding.PaddingLeft = UDim.new(0, 5)
CategoryPadding.PaddingRight = UDim.new(0, 5)

-- Painel de Conteúdo / Funções (Lado Direito)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ContentContainer.BackgroundTransparency = 0.5
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 142, 0, 36)
ContentContainer.Size = UDim2.new(1, -152, 1, -46)
ContentContainer.ZIndex = 3

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

-- Card Perfil / Jogo
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "ProfileCard"
ProfileCard.Parent = MainFrame
ProfileCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ProfileCard.BackgroundTransparency = 0.35
ProfileCard.BorderSizePixel = 0
ProfileCard.Position = UDim2.new(0, 10, 1, -68)
ProfileCard.Size = UDim2.new(0, 125, 0, 58)
ProfileCard.ZIndex = 3

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 8)
ProfileCorner.Parent = ProfileCard

local UserAvatar = Instance.new("ImageLabel")
UserAvatar.Name = "UserAvatar"
UserAvatar.Parent = ProfileCard
UserAvatar.BackgroundTransparency = 1
UserAvatar.Position = UDim2.new(0, 6, 0.5, -18)
UserAvatar.Size = UDim2.new(0, 36, 0, 36)
UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
UserAvatar.ZIndex = 4

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = UserAvatar

local UserNameLabel = Instance.new("TextLabel")
UserNameLabel.Name = "UserNameLabel"
UserNameLabel.Parent = ProfileCard
UserNameLabel.BackgroundTransparency = 1
UserNameLabel.Position = UDim2.new(0, 46, 0, 8)
UserNameLabel.Size = UDim2.new(0, 75, 0, 18)
UserNameLabel.Font = Enum.Font.GothamBold
UserNameLabel.Text = LocalPlayer.DisplayName
UserNameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
UserNameLabel.TextSize = 11
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UserNameLabel.ZIndex = 4

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Name = "GameNameLabel"
GameNameLabel.Parent = ProfileCard
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Position = UDim2.new(0, 46, 0, 28)
GameNameLabel.Size = UDim2.new(0, 75, 0, 22)
GameNameLabel.Font = Enum.Font.Gotham
GameNameLabel.Text = "🎮 " .. gameName
GameNameLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
GameNameLabel.TextSize = 9
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
GameNameLabel.ZIndex = 4

task.spawn(function()
    repeat task.wait(0.2) until gameName ~= "Carregando..."
    GameNameLabel.Text = "🎮 " .. gameName
end)

-- --- GERENCIADOR DE ABAS DINÂMICO ---
local activeTabButton = nil

local function clearContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function registerTab(tabName, buildCallback, order)
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "TabBtn"
    btn.Parent = CategoryContainer
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 11
    btn.LayoutOrder = order -- Posição fixa de acordo com a ordem da tabela TabURLs
    btn.ZIndex = 4

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if activeTabButton then
            activeTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        activeTabButton = btn

        clearContent()
        if type(buildCallback) == "function" then
            buildCallback(ContentContainer)
        end
    end)

    return btn
end

-- Carregamento sequencial respeitando a ordem de TabURLs
local function loadAllModules()
    local firstTabBtn = nil

    for order, tabData in ipairs(TabURLs) do
        local tabName = tabData.Name
        local url = tabData.URL

        if url and url ~= "" and not string.find(url, "SEU_PASTEBIN") then
            local success, result = pcall(function()
                return loadstring(game:HttpGet(url))()
            end)

            if success and type(result) == "table" and type(result.BuildTab) == "function" then
                LoadedModules[tabName] = result
                
                local displayName = result.Name or tabName
                local btn = registerTab(displayName, result.BuildTab, order)

                if not firstTabBtn then
                    firstTabBtn = {Button = btn, Callback = result.BuildTab}
                end
            else
                warn("Erro ao carregar o módulo '" .. tabName .. "':", result)
            end
        end
    end

    -- Abre a primeira aba carregada automaticamente
    if firstTabBtn then
        firstTabBtn.Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        activeTabButton = firstTabBtn.Button
        clearContent()
        firstTabBtn.Callback(ContentContainer)
    end
end

-- Tela de Confirmação de Saída
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Name = "ConfirmFrame"
ConfirmFrame.Parent = MainFrame
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Position = UDim2.new(0, 15, 0, 45)
ConfirmFrame.Size = UDim2.new(1, -30, 1, -60)
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 20

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 8)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Name = "ConfirmText"
ConfirmText.Parent = ConfirmFrame
ConfirmText.BackgroundTransparency = 1
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.Size = UDim2.new(1, 0, 0, 40)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.Text = "Tem certeza que deseja fechar o script?"
ConfirmText.TextColor3 = Color3.fromRGB(240, 240, 240)
ConfirmText.TextSize = 15
ConfirmText.ZIndex = 21

local YesButton = Instance.new("TextButton")
YesButton.Name = "YesButton"
YesButton.Parent = ConfirmFrame
YesButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
YesButton.BorderSizePixel = 0
YesButton.Position = UDim2.new(0.15, 0, 0.6, 0)
YesButton.Size = UDim2.new(0, 110, 0, 35)
YesButton.Font = Enum.Font.GothamBold
YesButton.Text = "Sim"
YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YesButton.TextSize = 14
YesButton.ZIndex = 21

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesButton

local NoButton = Instance.new("TextButton")
NoButton.Name = "NoButton"
NoButton.Parent = ConfirmFrame
NoButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NoButton.BorderSizePixel = 0
NoButton.Position = UDim2.new(0.55, 0, 0.6, 0)
NoButton.Size = UDim2.new(0, 110, 0, 35)
NoButton.Font = Enum.Font.GothamBold
NoButton.Text = "Não"
NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoButton.TextSize = 14
NoButton.ZIndex = 21

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoButton

-- --- ANIMAÇÃO E EVENTOS DE INICIALIZAÇÃO ---
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local tween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

task.delay(5, function()
    local fadeTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fadeTween:Play()
    
    BgImage.Visible = false
    Overlay.Visible = false
    LoadingText.Visible = false
    BarBackground.Visible = false
    
    task.wait(0.5)
    LoadingFrame:Destroy()
    ImageButton.Visible = true
    
    -- Baixa os módulos na ordem correta
    loadAllModules()
end)

ImageButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ConfirmFrame.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)

YesButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

NoButton.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)
