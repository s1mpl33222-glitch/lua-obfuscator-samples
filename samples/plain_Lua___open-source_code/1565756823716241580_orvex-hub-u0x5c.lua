--[[
    ================================================================================
    ORVEX HUB - MOBILE EDITION (ULTIMATE V74 - FPS CORRIGIDO & ALCANCE ESTENDIDO DE DOCES)
    - Key de Acesso: ORVEX1
    - Link do Discord: https://discord.gg/vVZu4YFG4
    - Opções de FPS / Otimização (Texturas, Sombras e Efeitos) 100% funcionais
    - Alcance Estendido no Auto Farm de Doces (Vai muito mais longe para buscar os ovos)
    - Farm 100% no Chão com Anti-Void (Pausa de 5s se cair no vazio) e Obstáculos Removíveis
    ================================================================================
]]

pcall(function()
    if queue_on_teleport then
        queue_on_teleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/..."))()
        ]])
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

UserInputService.MouseIconEnabled = false

if PlayerGui:FindFirstChild("OrvexHubMain") then
    PlayerGui.OrvexHubMain:Destroy()
end

local CorrectKey = "ORVEX1"
local DiscordLink = "https://discord.gg/vVZu4YFG4"
local CustomImageId = "rbxassetid://140309658254898"

local Config = {
    CandyFarmEnabled = false,
    CandyFarmMode = 1,
    MoveSpeed = 50,
    RealCandiesCollected = 0,
    AntiAFKEnabled = true,
    AutoReconnect = true,
    FpsHudEnabled = false,
    RemoveTexturesEnabled = false,
    RemoveShadowsEnabled = false,
    RemoveEffectsEnabled = false,
    RemoveHalloweenObstaclesEnabled = false,
    AutoRebirthEnabled = false,
    AutoRebirthHalloweenEnabled = false,
    ActiveProfile = 1,
    Profiles = {}
}

for i = 1, 20 do
    Config.Profiles[i] = {Name = "Perfil " .. i, Settings = {}}
end

local SaveFileName = "OrvexHub_Profiles_V74.json"
local function saveSettings()
    pcall(function()
        if writefile then
            local data = HttpService:JSONEncode(Config)
            writefile(SaveFileName, data)
        end
    end)
end

local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(SaveFileName) then
            local content = readfile(SaveFileName)
            local decoded = HttpService:JSONDecode(content)
            if decoded then
                for k, v in pairs(decoded) do
                    if Config[k] ~= nil then Config[k] = v end
                end
            end
        end
    end)
end
loadSettings()

Config.MoveSpeed = 50

local gameName = "Roblox Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local cupEnabled = false
local cupHighlights = {}
local cupOriginal = {}
local cupScanRunning = false

local cupColors = {
    {Name = "Vermelho", Color = Color3.fromRGB(255, 40, 40)},
    {Name = "Verde", Color = Color3.fromRGB(40, 255, 80)},
    {Name = "Amarelo", Color = Color3.fromRGB(255, 230, 30)},
    {Name = "Roxo", Color = Color3.fromRGB(170, 60, 255)},
    {Name = "Rosa", Color = Color3.fromRGB(255, 60, 220)},
    {Name = "Laranja", Color = Color3.fromRGB(255, 145, 30)}
}

local function isCup(obj)
    local name = obj.Name:lower()
    return name:find("copo", 1, true) ~= nil 
        or name:find("cup", 1, true) ~= nil 
        or name:find("vaso", 1, true) ~= nil 
        or name:find("color", 1, true) ~= nil
end

local function removeCupEffects()
    for obj, data in pairs(cupOriginal) do
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    obj.Color = data.Color
                    obj.Material = data.Material
                end
            end)
        end
    end
    for _, h in pairs(cupHighlights) do if h and h.Parent then h:Destroy() end end
    table.clear(cupOriginal)
    table.clear(cupHighlights)
end

local function scanCups(guiParent)
    local index = 0
    for _, container in ipairs({Workspace, PlayerGui}) do
        for _, obj in ipairs(container:GetDescendants()) do
            if not cupEnabled then break end
            if isCup(obj) and not cupHighlights[obj] then
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    index += 1
                    cupOriginal[obj] = {Color = obj.Color, Material = obj.Material}
                    local colorData = cupColors[((index - 1) % #cupColors) + 1]
                    obj.Color = colorData.Color
                    obj.Material = Enum.Material.Neon

                    local highlight = Instance.new("Highlight")
                    highlight.Name = "OrvexCupHighlight"
                    highlight.Adornee = obj
                    highlight.FillColor = colorData.Color
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.45
                    highlight.Parent = guiParent

                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = obj
                    billboard.Size = UDim2.new(0, 140, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = obj

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextSize = 13
                    textLabel.TextColor3 = colorData.Color
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Text = "[" .. obj.Name .. "]\nCor: " .. colorData.Name
                    textLabel.Parent = billboard

                    cupHighlights[obj] = highlight
                end
            end
        end
    end
end

local function getCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        return char, char.HumanoidRootPart, char.Humanoid
    end
    return nil, nil, nil
end

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFKEnabled then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    end
end)

--------------------------------------------------------------------------------
-- TELA DE KEY HALLOWEEN (CUSTOMIZADA)
--------------------------------------------------------------------------------
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "OrvexHubMain"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
KeyGui.DisplayOrder = 2000000000
KeyGui.Parent = PlayerGui

local FullBlackBg = Instance.new("Frame")
FullBlackBg.Size = UDim2.new(3, 0, 3, 0)
FullBlackBg.Position = UDim2.new(-1, 0, -1, 0)
FullBlackBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FullBlackBg.BorderSizePixel = 0
FullBlackBg.ZIndex = 19
FullBlackBg.Parent = KeyGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 400, 0, 360)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 28)
KeyFrame.BackgroundTransparency = 0.05
KeyFrame.BorderSizePixel = 0
KeyFrame.ZIndex = 20
KeyFrame.Parent = KeyGui

Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(255, 140, 0)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)

local HeaderImage = Instance.new("ImageLabel")
HeaderImage.Size = UDim2.new(0, 50, 0, 50)
HeaderImage.Position = UDim2.new(0.5, -25, 0, 10)
HeaderImage.BackgroundTransparency = 1
HeaderImage.Image = CustomImageId
HeaderImage.ZIndex = 21
HeaderImage.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 62)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "ORVEX HUB - LOGIN"
KeyTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
KeyTitle.TextSize = 13
KeyTitle.ZIndex = 21
KeyTitle.Parent = KeyFrame

local GameInfoLabel = Instance.new("TextLabel")
GameInfoLabel.Size = UDim2.new(1, 0, 0, 26)
GameInfoLabel.Position = UDim2.new(0, 0, 0, 94)
GameInfoLabel.BackgroundTransparency = 1
GameInfoLabel.Font = Enum.Font.GothamBold
GameInfoLabel.Text = "🎮 Jogo: " .. gameName
GameInfoLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
GameInfoLabel.TextSize = 10
GameInfoLabel.ZIndex = 21
GameInfoLabel.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 340, 0, 40)
KeyBox.Position = UDim2.new(0.5, -170, 0, 125)
KeyBox.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.PlaceholderText = "Insira sua Key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(130, 110, 160)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 12
KeyBox.ZIndex = 21
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0, 340, 0, 38)
LoginBtn.Position = UDim2.new(0.5, -170, 0, 173)
LoginBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.Text = "🔓 ENTRAR NO PAINEL"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.TextSize = 11
LoginBtn.ZIndex = 21
LoginBtn.Parent = KeyFrame
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 340, 0, 38)
DiscordBtn.Position = UDim2.new(0.5, -170, 0, 218)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.Text = "💬 DISCORD: Obter Key (Copiar Link)"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 10
DiscordBtn.ZIndex = 21
DiscordBtn.Parent = KeyFrame
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

local ServerLinkText = Instance.new("TextLabel")
ServerLinkText.Size = UDim2.new(1, 0, 0, 32)
ServerLinkText.Position = UDim2.new(0, 0, 0, 262)
ServerLinkText.BackgroundTransparency = 1
ServerLinkText.Font = Enum.Font.GothamMedium
ServerLinkText.Text = "Servidor: " .. DiscordLink
ServerLinkText.TextColor3 = Color3.fromRGB(160, 150, 190)
ServerLinkText.TextSize = 9
ServerLinkText.ZIndex = 21
ServerLinkText.Parent = KeyFrame

local ErrorMsg = Instance.new("TextLabel")
ErrorMsg.Size = UDim2.new(1, 0, 0, 20)
ErrorMsg.Position = UDim2.new(0, 0, 0, 300)
ErrorMsg.BackgroundTransparency = 1
ErrorMsg.Font = Enum.Font.GothamMedium
ErrorMsg.Text = ""
ErrorMsg.TextColor3 = Color3.fromRGB(255, 60, 60)
ErrorMsg.TextSize = 10
ErrorMsg.ZIndex = 21
ErrorMsg.Parent = KeyFrame

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DiscordLink)
        DiscordBtn.Text = "¡ Link Copiado com Sucesso !"
        task.wait(2)
        DiscordBtn.Text = "💬 DISCORD: Obter Key (Copiar Link)"
    end
end)

--------------------------------------------------------------------------------
-- INTERFACE PRINCIPAL VIP + BOTÃO DE FECHAR VISÍVEL & IMAGEM CUSTOMIZADA
--------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = KeyGui

Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 60)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local StatusHud = Instance.new("Frame")
StatusHud.Name = "StatusHud"
StatusHud.Size = UDim2.new(0, 180, 0, 65)
StatusHud.Position = UDim2.new(0, 15, 0.35, 0)
StatusHud.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
StatusHud.BackgroundTransparency = 0.2
StatusHud.BorderSizePixel = 0
StatusHud.Visible = false
StatusHud.ZIndex = 30
StatusHud.Parent = KeyGui
Instance.new("UICorner", StatusHud).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", StatusHud).Color = Color3.fromRGB(150, 40, 255)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 5, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamBold
StatusText.Text = "🟣 ORVEX VIP STATUS\n🍬 Doces Coletados: 0"
StatusText.TextColor3 = Color3.fromRGB(230, 200, 255)
StatusText.TextSize = 10
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 31
StatusText.Parent = StatusHud

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 140, 0, 35)
OpenButton.Position = UDim2.new(0.5, -70, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
OpenButton.BackgroundTransparency = 0.15
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "Orvex Hub"
OpenButton.TextColor3 = Color3.fromRGB(210, 140, 255)
OpenButton.TextSize = 12
OpenButton.Visible = false
OpenButton.ZIndex = 50
OpenButton.Parent = KeyGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", OpenButton).Color = Color3.fromRGB(170, 40, 255)

local FpsHud = Instance.new("Frame")
FpsHud.Name = "FpsHud"
FpsHud.Size = UDim2.new(0, 110, 0, 32)
FpsHud.Position = UDim2.new(1, -130, 0, 15)
FpsHud.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
FpsHud.BackgroundTransparency = 0.2
FpsHud.BorderSizePixel = 0
FpsHud.Visible = false
FpsHud.ZIndex = 40
FpsHud.Parent = KeyGui
Instance.new("UICorner", FpsHud).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", FpsHud).Color = Color3.fromRGB(150, 40, 255)

local FpsHudText = Instance.new("TextLabel")
FpsHudText.Size = UDim2.new(1, 0, 1, 0)
FpsHudText.BackgroundTransparency = 1
FpsHudText.Font = Enum.Font.GothamBold
FpsHudText.Text = "⚡ FPS: 60"
FpsHudText.TextColor3 = Color3.fromRGB(100, 255, 150)
FpsHudText.TextSize = 12
FpsHudText.ZIndex = 41
FpsHudText.Parent = FpsHud

task.spawn(function()
    local lastTick = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        local currentTick = tick()
        if currentTick - lastTick >= 1 then
            local fps = math.floor(frameCount / (currentTick - lastTick))
            if Config.FpsHudEnabled then FpsHudText.Text = "⚡ FPS: " .. fps end
            frameCount = 0
            lastTick = currentTick
        end
    end)
end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 15
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TopBarIcon = Instance.new("ImageLabel")
TopBarIcon.Size = UDim2.new(0, 24, 0, 24)
TopBarIcon.Position = UDim2.new(0, 8, 0.5, -12)
TopBarIcon.BackgroundTransparency = 1
TopBarIcon.Image = CustomImageId
TopBarIcon.ZIndex = 16
TopBarIcon.Parent = TopBar

local BigCloseBtn = Instance.new("TextButton")
BigCloseBtn.Size = UDim2.new(0, 110, 0, 26)
BigCloseBtn.Position = UDim2.new(1, -118, 0.5, -13)
BigCloseBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 60)
BigCloseBtn.Font = Enum.Font.GothamBold
BigCloseBtn.Text = "✖ FECHAR"
BigCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BigCloseBtn.TextSize = 11
BigCloseBtn.ZIndex = 16
BigCloseBtn.Parent = TopBar
Instance.new("UICorner", BigCloseBtn).CornerRadius = UDim.new(0, 6)

BigCloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 520, 0, 360)
    MainFrame.BackgroundTransparency = 0.05
    OpenButton.Visible = true
    StatusHud.Visible = true
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 38, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Orvex Hub"
Title.TextColor3 = Color3.fromRGB(200, 200, 210)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 16
Title.Parent = TopBar

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    StatusHud.Visible = false
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 520, 0, 360), BackgroundTransparency = 0.05}):Play()
end)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -36)
TabContainer.Position = UDim2.new(0, 0, 0, 36)
TabContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
TabContainer.BorderSizePixel = 0
TabContainer.ZIndex = 12
TabContainer.Parent = MainFrame
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

local PanelsHolder = Instance.new("Frame")
PanelsHolder.Size = UDim2.new(1, -140, 1, -36)
PanelsHolder.Position = UDim2.new(0, 140, 0, 36)
PanelsHolder.BackgroundTransparency = 1
PanelsHolder.ZIndex = 12
PanelsHolder.Parent = MainFrame

local UserFooter = Instance.new("Frame")
UserFooter.Size = UDim2.new(0, 140, 0, 45)
UserFooter.Position = UDim2.new(0, 0, 1, -45)
UserFooter.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
UserFooter.BorderSizePixel = 0
UserFooter.ZIndex = 14
UserFooter.Parent = MainFrame

local UserAvatar = Instance.new("ImageLabel")
UserAvatar.Size = UDim2.new(0, 32, 0, 32)
UserAvatar.Position = UDim2.new(0, 8, 0.5, -16)
UserAvatar.BackgroundTransparency = 1
UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
UserAvatar.ZIndex = 15
UserAvatar.Parent = UserFooter
Instance.new("UICorner", UserAvatar).CornerRadius = UDim.new(1, 0)

local UserNameText = Instance.new("TextLabel")
UserNameText.Size = UDim2.new(1, -48, 0, 18)
UserNameText.Position = UDim2.new(0, 46, 0, 6)
UserNameText.BackgroundTransparency = 1
UserNameText.Font = Enum.Font.GothamBold
UserNameText.Text = LocalPlayer.Name
UserNameText.TextColor3 = Color3.fromRGB(230, 230, 240)
UserNameText.TextSize = 11
UserNameText.TextXAlignment = Enum.TextXAlignment.Left
UserNameText.ZIndex = 15
UserNameText.Parent = UserFooter

local UserIdText = Instance.new("TextLabel")
UserIdText.Size = UDim2.new(1, -48, 0, 16)
UserIdText.Position = UDim2.new(0, 46, 0, 22)
UserIdText.BackgroundTransparency = 1
UserIdText.Font = Enum.Font.GothamMedium
UserIdText.Text = "ID: " .. LocalPlayer.UserId
UserIdText.TextColor3 = Color3.fromRGB(140, 140, 160)
UserIdText.TextSize = 9
UserIdText.TextXAlignment = Enum.TextXAlignment.Left
UserIdText.ZIndex = 15
UserIdText.Parent = UserFooter

local firstTab = true
local function CreateTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 130, 0, 36)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.BackgroundTransparency = 1
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 170)
    Btn.TextSize = 11
    Btn.ZIndex = 13
    Btn.Parent = TabContainer
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    local Panel = Instance.new("ScrollingFrame")
    Panel.Size = UDim2.new(1, 0, 1, 0)
    Panel.BackgroundTransparency = 1
    Panel.BorderSizePixel = 0
    Panel.CanvasSize = UDim2.new(0, 0, 0, 500)
    Panel.Visible = false
    Panel.ZIndex = 13
    Panel.Parent = PanelsHolder
    Instance.new("UIListLayout", Panel).Padding = UDim.new(0, 8)

    if firstTab then
        Panel.Visible = true
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        firstTab = false
    end

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PanelsHolder:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(150, 150, 170) end
        end
        Panel.Visible = true
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return Panel
end

local TabCups = CreateTab("🥤 Copos")
local TabHalloween = CreateTab("🎃 Event Halloween")
local TabFpsOpt = CreateTab("⚡ Configurações")
local TabProfiles = CreateTab("💾 Perfis")
local TabOptions = CreateTab("⚙️ Outros")

-- 1. Aba Copos
do
    local fCup = Instance.new("Frame")
    fCup.Size = UDim2.new(0, 350, 0, 44)
    fCup.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    fCup.BorderSizePixel = 0
    fCup.ZIndex = 14
    fCup.Parent = TabCups
    Instance.new("UICorner", fCup).CornerRadius = UDim.new(0, 8)
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -16, 0, 32)
    toggle.Position = UDim2.fromOffset(8, 6)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    toggle.Text = "COPOS (COM NOME): DESLIGADO"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 11
    toggle.ZIndex = 15
    toggle.Parent = fCup
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

    toggle.Activated:Connect(function()
        cupEnabled = not cupEnabled
        if cupEnabled then
            toggle.Text = "COPOS (COM NOME): LIGADO"
            toggle.BackgroundColor3 = Color3.fromRGB(130, 0, 220)
            if not cupScanRunning then
                cupScanRunning = true
                task.spawn(function()
                    while cupEnabled do
                        scanCups(KeyGui)
                        task.wait(2)
                    end
                    cupScanRunning = false
                end)
            end
        else
            toggle.Text = "COPOS (COM NOME): DESLIGADO"
            toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            removeCupEffects()
        end
    end)
end

-- 2. Aba Event Halloween
do
    local f1 = Instance.new("Frame")
    f1.Size = UDim2.new(0, 350, 0, 44)
    f1.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    f1.BorderSizePixel = 0
    f1.ZIndex = 14
    f1.Parent = TabHalloween
    Instance.new("UICorner", f1).CornerRadius = UDim.new(0, 8)
    
    local l1 = Instance.new("TextLabel")
    l1.Size = UDim2.new(1, -60, 1, 0); l1.Position = UDim2.new(0, 12, 0, 0)
    l1.BackgroundTransparency = 1; l1.Font = Enum.Font.GothamMedium
    l1.Text = "🍬 Roubar Ovos (Prioridade 3 > 2 > 1 no Chão)"
    l1.TextColor3 = Color3.fromRGB(220, 200, 255); l1.TextSize = 10
    l1.TextXAlignment = Enum.TextXAlignment.Left
    l1.ZIndex = 14
    l1.Parent = f1

    local btn1 = Instance.new("TextButton")
    btn1.Size = UDim2.new(0, 42, 0, 22); btn1.Position = UDim2.new(1, -50, 0.5, -11)
    btn1.BackgroundColor3 = Config.CandyFarmEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
    btn1.Text = ""
    btn1.ZIndex = 15
    btn1.Parent = f1
    Instance.new("UICorner", btn1).CornerRadius = UDim.new(1, 0)

    btn1.MouseButton1Click:Connect(function()
        Config.CandyFarmEnabled = not Config.CandyFarmEnabled
        btn1.BackgroundColor3 = Config.CandyFarmEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        saveSettings()
    end)

    local fObs = Instance.new("Frame")
    fObs.Size = UDim2.new(0, 350, 0, 44)
    fObs.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    fObs.BorderSizePixel = 0
    fObs.ZIndex = 14
    fObs.Parent = TabHalloween
    Instance.new("UICorner", fObs).CornerRadius = UDim.new(0, 8)

    local lObs = Instance.new("TextLabel")
    lObs.Size = UDim2.new(1, -60, 1, 0); lObs.Position = UDim2.new(0, 12, 0, 0)
    lObs.BackgroundTransparency = 1; lObs.Font = Enum.Font.GothamMedium
    lObs.Text = "🧹 Remover Obstáculos (Puck, Cercas, Árvores...)"
    lObs.TextColor3 = Color3.fromRGB(255, 140, 255); lObs.TextSize = 9
    lObs.TextXAlignment = Enum.TextXAlignment.Left
    lObs.ZIndex = 14
    lObs.Parent = fObs

    local btnObs = Instance.new("TextButton")
    btnObs.Size = UDim2.new(0, 42, 0, 22); btnObs.Position = UDim2.new(1, -50, 0.5, -11)
    btnObs.BackgroundColor3 = Config.RemoveHalloweenObstaclesEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
    btnObs.Text = ""
    btnObs.ZIndex = 15
    btnObs.Parent = fObs
    Instance.new("UICorner", btnObs).CornerRadius = UDim.new(1, 0)

    btnObs.MouseButton1Click:Connect(function()
        Config.RemoveHalloweenObstaclesEnabled = not Config.RemoveHalloweenObstaclesEnabled
        btnObs.BackgroundColor3 = Config.RemoveHalloweenObstaclesEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        saveSettings()
    end)

    local fRebirthHallow = Instance.new("Frame")
    fRebirthHallow.Size = UDim2.new(0, 350, 0, 44)
    fRebirthHallow.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    fRebirthHallow.BorderSizePixel = 0
    fRebirthHallow.ZIndex = 14
    fRebirthHallow.Parent = TabHalloween
    Instance.new("UICorner", fRebirthHallow).CornerRadius = UDim.new(0, 8)

    local lRebirthHallow = Instance.new("TextLabel")
    lRebirthHallow.Size = UDim2.new(1, -60, 1, 0); lRebirthHallow.Position = UDim2.new(0, 12, 0, 0)
    lRebirthHallow.BackgroundTransparency = 1; lRebirthHallow.Font = Enum.Font.GothamMedium
    lRebirthHallow.Text = "🎃 Auto Renascimento Halloween"
    lRebirthHallow.TextColor3 = Color3.fromRGB(255, 165, 0); lRebirthHallow.TextSize = 10
    lRebirthHallow.TextXAlignment = Enum.TextXAlignment.Left
    lRebirthHallow.ZIndex = 14
    lRebirthHallow.Parent = fRebirthHallow

    local btnRebirthHallow = Instance.new("TextButton")
    btnRebirthHallow.Size = UDim2.new(0, 42, 0, 22); btnRebirthHallow.Position = UDim2.new(1, -50, 0.5, -11)
    btnRebirthHallow.BackgroundColor3 = Config.AutoRebirthHalloweenEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
    btnRebirthHallow.Text = ""
    btnRebirthHallow.ZIndex = 15
    btnRebirthHallow.Parent = fRebirthHallow
    Instance.new("UICorner", btnRebirthHallow).CornerRadius = UDim.new(1, 0)

    btnRebirthHallow.MouseButton1Click:Connect(function()
        Config.AutoRebirthHalloweenEnabled = not Config.AutoRebirthHalloweenEnabled
        btnRebirthHallow.BackgroundColor3 = Config.AutoRebirthHalloweenEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        saveSettings()
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if Config.RemoveHalloweenObstaclesEnabled then
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj and obj.Parent then
                        local name = obj.Name:lower()
                        if name:find("puck") or name:find("vallahalloween") or name:find("aroblquemado") or name:find("tree3") or name:find("estiaos") or name:find("essentils") then
                            if obj:IsA("BasePart") or obj:IsA("Model") then
                                obj:Destroy()
                            end
                        elseif name == "rock" or name:find("rock") then
                            if not name:find("magma") then
                                if obj:IsA("BasePart") or obj:IsA("Model") then
                                    obj:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(15)
        if Config.AutoRebirthHalloweenEnabled then
            pcall(function()
                local _, root, _ = getCharacter()
                if root then
                    local portalPart = nil
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower() == "touchpart" or obj.Name:lower() == "portal") and obj.Parent and (obj.Parent.Name:lower():find("halloweenportal") or obj.Parent.Name:lower():find("portal")) then
                            portalPart = obj
                            break
                        end
                    end
                    if portalPart then
                        root.CFrame = portalPart.CFrame + Vector3.new(0, 2, 0)
                        if firetouchinterest then
                            firetouchinterest(root, portalPart, 0)
                            task.wait(0.1)
                            firetouchinterest(root, portalPart, 1)
                        end
                        task.wait(1)
                    end

                    for _, guiObj in ipairs(PlayerGui:GetDescendants()) do
                        if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
                            local btnText = (guiObj:IsA("TextButton") and guiObj.Text or guiObj.Name):lower()
                            if btnText:find("renascomento") or btnText:find("rebirth") or btnText:find("renascer") or btnText:find("halloween") then
                                for _, conn in ipairs(getconnections(guiObj.Activated or guiObj.MouseButton1Click)) do
                                    conn:Fire()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. Aba Configurações (FPS e Otimizações 100% Funcionais)
do
    local fFps = Instance.new("Frame")
    fFps.Size = UDim2.new(0, 350, 0, 44)
    fFps.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    fFps.BorderSizePixel = 0
    fFps.ZIndex = 14
    fFps.Parent = TabFpsOpt
    Instance.new("UICorner", fFps).CornerRadius = UDim.new(0, 8)
    
    local lFps = Instance.new("TextLabel")
    lFps.Size = UDim2.new(1, -60, 1, 0); lFps.Position = UDim2.new(0, 12, 0, 0)
    lFps.BackgroundTransparency = 1; lFps.Font = Enum.Font.GothamMedium
    lFps.Text = "⚡ Contador de FPS Ao Vivo"
    lFps.TextColor3 = Color3.fromRGB(220, 200, 255); lFps.TextSize = 11
    lFps.TextXAlignment = Enum.TextXAlignment.Left
    lFps.ZIndex = 14
    lFps.Parent = fFps

    local btnFps = Instance.new("TextButton")
    btnFps.Size = UDim2.new(0, 42, 0, 22); btnFps.Position = UDim2.new(1, -50, 0.5, -11)
    btnFps.BackgroundColor3 = Config.FpsHudEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
    btnFps.Text = ""
    btnFps.ZIndex = 15
    btnFps.Parent = fFps
    Instance.new("UICorner", btnFps).CornerRadius = UDim.new(1, 0)

    btnFps.MouseButton1Click:Connect(function()
        Config.FpsHudEnabled = not Config.FpsHudEnabled
        btnFps.BackgroundColor3 = Config.FpsHudEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        FpsHud.Visible = Config.FpsHudEnabled
        saveSettings()
    end)
    FpsHud.Visible = Config.FpsHudEnabled

    -- Remover Texturas
    local fTex = Instance.new("Frame")
    fTex.Size = UDim2.new(0, 350, 0, 44); fTex.BackgroundColor3 = Color3.fromRGB(28, 28, 35); fTex.BorderSizePixel = 0; fTex.ZIndex = 14; fTex.Parent = TabFpsOpt
    Instance.new("UICorner", fTex).CornerRadius = UDim.new(0, 8)
    local lTex = Instance.new("TextLabel")
    lTex.Size = UDim2.new(1, -60, 1, 0); lTex.Position = UDim2.new(0, 12, 0, 0); lTex.BackgroundTransparency = 1; lTex.Font = Enum.Font.GothamMedium; lTex.Text = "🎨 Remover Texturas"; lTex.TextColor3 = Color3.fromRGB(220, 200, 255); lTex.TextSize = 11; lTex.TextXAlignment = Enum.TextXAlignment.Left; lTex.ZIndex = 14; lTex.Parent = fTex

    local btnTex = Instance.new("TextButton")
    btnTex.Size = UDim2.new(0, 42, 0, 22); btnTex.Position = UDim2.new(1, -50, 0.5, -11); btnTex.BackgroundColor3 = Config.RemoveTexturesEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65); btnTex.Text = ""; btnTex.ZIndex = 15; btnTex.Parent = fTex
    Instance.new("UICorner", btnTex).CornerRadius = UDim.new(1, 0)

    btnTex.MouseButton1Click:Connect(function()
        Config.RemoveTexturesEnabled = not Config.RemoveTexturesEnabled
        btnTex.BackgroundColor3 = Config.RemoveTexturesEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") then
                    v.Transparency = Config.RemoveTexturesEnabled and 1 or 0
                elseif v:IsA("BasePart") and Config.RemoveTexturesEnabled then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
        saveSettings()
    end)

    -- Remover Sombras
    local fShd = Instance.new("Frame")
    fShd.Size = UDim2.new(0, 350, 0, 44); fShd.BackgroundColor3 = Color3.fromRGB(28, 28, 35); fShd.BorderSizePixel = 0; fShd.ZIndex = 14; fShd.Parent = TabFpsOpt
    Instance.new("UICorner", fShd).CornerRadius = UDim.new(0, 8)
    local lShd = Instance.new("TextLabel")
    lShd.Size = UDim2.new(1, -60, 1, 0); lShd.Position = UDim2.new(0, 12, 0, 0); lShd.BackgroundTransparency = 1; lShd.Font = Enum.Font.GothamMedium; lShd.Text = "🌑 Remover Sombras"; lShd.TextColor3 = Color3.fromRGB(220, 200, 255); lShd.TextSize = 11; lShd.TextXAlignment = Enum.TextXAlignment.Left; lShd.ZIndex = 14; lShd.Parent = fShd

    local btnShd = Instance.new("TextButton")
    btnShd.Size = UDim2.new(0, 42, 0, 22); btnShd.Position = UDim2.new(1, -50, 0.5, -11); btnShd.BackgroundColor3 = Config.RemoveShadowsEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65); btnShd.Text = ""; btnShd.ZIndex = 15; btnShd.Parent = fShd
    Instance.new("UICorner", btnShd).CornerRadius = UDim.new(1, 0)

    btnShd.MouseButton1Click:Connect(function()
        Config.RemoveShadowsEnabled = not Config.RemoveShadowsEnabled
        btnShd.BackgroundColor3 = Config.RemoveShadowsEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        pcall(function()
            Lighting.GlobalShadows = not Config.RemoveShadowsEnabled
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = not Config.RemoveShadowsEnabled
                end
            end
        end)
        saveSettings()
    end)

    -- Remover Efeitos
    local fEff = Instance.new("Frame")
    fEff.Size = UDim2.new(0, 350, 0, 44); fEff.BackgroundColor3 = Color3.fromRGB(28, 28, 35); fEff.BorderSizePixel = 0; fEff.ZIndex = 14; fEff.Parent = TabFpsOpt
    Instance.new("UICorner", fEff).CornerRadius = UDim.new(0, 8)
    local lEff = Instance.new("TextLabel")
    lEff.Size = UDim2.new(1, -60, 1, 0); lEff.Position = UDim2.new(0, 12, 0, 0); lEff.BackgroundTransparency = 1; lEff.Font = Enum.Font.GothamMedium; lEff.Text = "✨ Remover Efeitos"; lEff.TextColor3 = Color3.fromRGB(220, 200, 255); lEff.TextSize = 11; lEff.TextXAlignment = Enum.TextXAlignment.Left; lEff.ZIndex = 14; lEff.Parent = fEff

    local btnEff = Instance.new("TextButton")
    btnEff.Size = UDim2.new(0, 42, 0, 22); btnEff.Position = UDim2.new(1, -50, 0.5, -11); btnEff.BackgroundColor3 = Config.RemoveEffectsEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65); btnEff.Text = ""; btnEff.ZIndex = 15; btnEff.Parent = fEff
    Instance.new("UICorner", btnEff).CornerRadius = UDim.new(1, 0)

    btnEff.MouseButton1Click:Connect(function()
        Config.RemoveEffectsEnabled = not Config.RemoveEffectsEnabled
        btnEff.BackgroundColor3 = Config.RemoveEffectsEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        pcall(function()
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = not Config.RemoveEffectsEnabled
                end
            end
        end)
        saveSettings()
    end)
end

-- 4. Aba Perfis
do
    local titleInfo = Instance.new("TextLabel")
    titleInfo.Size = UDim2.new(0, 350, 0, 30); titleInfo.BackgroundTransparency = 1; titleInfo.Font = Enum.Font.GothamBold; titleInfo.Text = "💾 GERENCIAR PERFIS (1 a 20):"; titleInfo.TextColor3 = Color3.fromRGB(210, 150, 255); titleInfo.TextSize = 11; titleInfo.TextXAlignment = Enum.TextXAlignment.Left; titleInfo.ZIndex = 14; titleInfo.Parent = TabProfiles

    for i = 1, 20 do
        local pFrame = Instance.new("Frame")
        pFrame.Size = UDim2.new(0, 350, 0, 38)
        pFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
        pFrame.BorderSizePixel = 0
        pFrame.ZIndex = 14
        pFrame.Parent = TabProfiles
        Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 8)

        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(1, -130, 1, 0)
        pLabel.Position = UDim2.new(0, 10, 0, 0)
        pLabel.BackgroundTransparency = 1
        pLabel.Font = Enum.Font.GothamMedium
        pLabel.Text = "Perfil " .. i
        pLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
        pLabel.TextSize = 11
        pLabel.TextXAlignment = Enum.TextXAlignment.Left
        pLabel.ZIndex = 14
        pLabel.Parent = pFrame

        local saveBtn = Instance.new("TextButton")
        saveBtn.Size = UDim2.new(0, 55, 0, 24)
        saveBtn.Position = UDim2.new(1, -125, 0.5, -12)
        saveBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.Text = "Salvar"
        saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveBtn.TextSize = 10
        saveBtn.ZIndex = 15
        saveBtn.Parent = pFrame
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 55, 0, 24)
        loadBtn.Position = UDim2.new(1, -65, 0.5, -12)
        loadBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.Text = "Carregar"
        loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadBtn.TextSize = 10
        loadBtn.ZIndex = 15
        loadBtn.Parent = pFrame
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

        saveBtn.MouseButton1Click:Connect(function()
            Config.Profiles[i].Settings = {
                CandyFarm = Config.CandyFarmEnabled,
                AutoRebirth = Config.AutoRebirthEnabled,
                AutoRebirthHalloween = Config.AutoRebirthHalloweenEnabled,
                RemoveHalloweenObstacles = Config.RemoveHalloweenObstaclesEnabled
            }
            saveSettings()
            saveBtn.Text = "Salvo!"
            task.wait(1.5)
            saveBtn.Text = "Salvar"
        end)

        loadBtn.MouseButton1Click:Connect(function()
            Config.ActiveProfile = i
            local prof = Config.Profiles[i].Settings
            if prof.CandyFarm ~= nil then Config.CandyFarmEnabled = prof.CandyFarm end
            if prof.AutoRebirth ~= nil then Config.AutoRebirthEnabled = prof.AutoRebirth end
            if prof.AutoRebirthHalloween ~= nil then Config.AutoRebirthHalloweenEnabled = prof.AutoRebirthHalloween end
            if prof.RemoveHalloweenObstacles ~= nil then Config.RemoveHalloweenObstaclesEnabled = prof.RemoveHalloweenObstacles end
            Config.MoveSpeed = 50
            saveSettings()
            loadBtn.Text = "Ativo!"
            task.wait(1.5)
            loadBtn.Text = "Carregar"
        end)
    end
end

-- 5. Aba Outros (Auto Renascimento Normal a cada 1 min)
do
    local fRebirth = Instance.new("Frame")
    fRebirth.Size = UDim2.new(0, 350, 0, 44)
    fRebirth.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    fRebirth.BorderSizePixel = 0
    fRebirth.ZIndex = 14
    fRebirth.Parent = TabOptions
    Instance.new("UICorner", fRebirth).CornerRadius = UDim.new(0, 8)

    local lRebirth = Instance.new("TextLabel")
    lRebirth.Size = UDim2.new(1, -60, 1, 0); lRebirth.Position = UDim2.new(0, 12, 0, 0)
    lRebirth.BackgroundTransparency = 1; lRebirth.Font = Enum.Font.GothamMedium
    lRebirth.Text = "🔄 Auto Renascimento Normal (A cada 1 min)"
    lRebirth.TextColor3 = Color3.fromRGB(100, 255, 150); lRebirth.TextSize = 10
    lRebirth.TextXAlignment = Enum.TextXAlignment.Left
    lRebirth.ZIndex = 14
    lRebirth.Parent = fRebirth

    local btnRebirth = Instance.new("TextButton")
    btnRebirth.Size = UDim2.new(0, 42, 0, 22); btnRebirth.Position = UDim2.new(1, -50, 0.5, -11)
    btnRebirth.BackgroundColor3 = Config.AutoRebirthEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
    btnRebirth.Text = ""
    btnRebirth.ZIndex = 15
    btnRebirth.Parent = fRebirth
    Instance.new("UICorner", btnRebirth).CornerRadius = UDim.new(1, 0)

    btnRebirth.MouseButton1Click:Connect(function()
        Config.AutoRebirthEnabled = not Config.AutoRebirthEnabled
        btnRebirth.BackgroundColor3 = Config.AutoRebirthEnabled and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(50, 50, 65)
        saveSettings()
    end)

    task.spawn(function()
        while true do
            task.wait(60)
            if Config.AutoRebirthEnabled then
                pcall(function()
                    for _, guiObj in ipairs(PlayerGui:GetDescendants()) do
                        if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
                            local btnText = (guiObj:IsA("TextButton") and guiObj.Text or guiObj.Name):lower()
                            if btnText:find("renascer") or btnText:find("rebirth") or btnText:find("renascomento") then
                                for _, conn in ipairs(getconnections(guiObj.Activated or guiObj.MouseButton1Click)) do
                                    conn:Fire()
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0, 350, 0, 44)
    ExitBtn.Position = UDim2.new(0, 0, 0, 230)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 60)
    ExitBtn.BorderSizePixel = 0
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.Text = "🗑️ Fechar Hub e Restaurar Mouse"
    ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitBtn.TextSize = 11
    ExitBtn.ZIndex = 14
    ExitBtn.Parent = TabOptions
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 8)

    ExitBtn.MouseButton1Click:Connect(function()
        UserInputService.MouseIconEnabled = true
        removeCupEffects()
        KeyGui:Destroy()
    end)
end

LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        FullBlackBg.Visible = false
        KeyFrame.Visible = false
        MainFrame.Visible = true
        StatusHud.Visible = true
    else
        ErrorMsg.Text = "Key incorreta!"
        task.wait(2)
        ErrorMsg.Text = ""
    end
end)

--------------------------------------------------------------------------------
-- LOOP DO AUTO FARM DE DOCES (ALCANCE ESTENDIDO, 100% NO CHÃO E ANTI-VOID)
--------------------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.08)
        local candiesFolder = Workspace:FindFirstChild("HalloweenCandiesLocal", true)

        if candiesFolder and Config.CandyFarmEnabled then
            local allCandies = candiesFolder:GetChildren()
            StatusText.Text = "🟣 ORVEX VIP STATUS\n🍬 Doces: " .. Config.RealCandiesCollected

            local char, root, hum = getCharacter()
            if root and hum then
                if root.Position.Y < -50 then
                    StatusText.Text = "🟣 ORVEX VIP STATUS\n⚠️ Cuidado! No Void. Pausando 5s..."
                    task.wait(5)
                end

                local priority3, priority2, priority1 = {}, {}, {}

                for _, candy in ipairs(allCandies) do
                    local name = candy.Name:lower()
                    if not name:find("portal", 1, true) and not name:find("safe", 1, true) and not name:find("spawn", 1, true) then
                        if name:find("candy3", 1, true) or name:find("3") then
                            table.insert(priority3, candy)
                        elseif name:find("candy2", 1, true) or name:find("2") then
                            table.insert(priority2, candy)
                        else
                            table.insert(priority1, candy)
                        end
                    end
                end

                local sortedCandies = {}
                for _, c in ipairs(priority3) do table.insert(sortedCandies, c) end
                for _, c in ipairs(priority2) do table.insert(sortedCandies, c) end
                for _, c in ipairs(priority1) do table.insert(sortedCandies, c) end

                for _, candy in ipairs(sortedCandies) do
                    if not Config.CandyFarmEnabled then break end
                    local part = candy:IsA("Model") and (candy.PrimaryPart or candy:FindFirstChildWhichIsA("BasePart", true)) or candy
                    if part and part:IsA("BasePart") then
                        
                        pcall(function()
                            local currentPersona = LocalPlayer.Character
                            if currentPersona then
                                for _, partObj in ipairs(currentPersona:GetDescendants()) do
                                    if partObj:IsA("BasePart") then
                                        partObj.CanCollide = true
                                    end
                                end
                            end
                        end)

                        local targetPos = Vector3.new(part.Position.X, root.Position.Y, part.Position.Z)
                        local startTime = tick()
                        
                        -- Aumentei o tempo limite para 5 segundos para garantir que ele chegue em doces muito distantes
                        while Config.CandyFarmEnabled and part.Parent and (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude > 1.5 and tick() - startTime < 5 do
                            local _, curRoot, _ = getCharacter()
                            if not curRoot then break end
                            
                            if curRoot.Position.Y < -50 then
                                StatusText.Text = "🟣 ORVEX VIP STATUS\n⚠️ No Void! Pausando 5s..."
                                task.wait(5)
                                break
                            end

                            local dt = RunService.Heartbeat:Wait()
                            local speedFactor = math.clamp(dt * 60, 0.5, 2.5)
                            local step = 1.6 * speedFactor

                            local dir = (targetPos - curRoot.Position).Unit
                            local actualStep = math.min(step, (targetPos - curRoot.Position).Magnitude)
                            local groundMovePos = Vector3.new(curRoot.Position.X + (dir.X * actualStep), curRoot.Position.Y, curRoot.Position.Z + (dir.Z * actualStep))
                            curRoot.CFrame = CFrame.new(groundMovePos, targetPos)
                        end

                        Config.RealCandiesCollected = Config.RealCandiesCollected + 1
                        task.wait(0.02)
                    end
                end
            end
        else
            task.wait(1)
        end
    end
end)

print("Orvex Hub Mobile V74 Carregado com Sucesso!")
