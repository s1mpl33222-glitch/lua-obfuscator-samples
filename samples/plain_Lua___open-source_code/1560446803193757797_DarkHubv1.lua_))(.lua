-- ============================================================
-- DARK HUB - Aviso de Atualização
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- CONFIGURAÇÕES
-- ============================================================
local DISCORD_LINK = "https://discord.gg/HGnARQJZhx"
local DARK_HUB_LOGO = "rbxassetid://76208826954157"

-- ============================================================
-- PALETA
-- ============================================================
local C = {
    bg          = Color3.fromRGB(0, 0, 0),
    panel       = Color3.fromRGB(15, 17, 28),
    panelLight  = Color3.fromRGB(22, 25, 40),
    accent      = Color3.fromRGB(100, 130, 255),
    accentGlow  = Color3.fromRGB(130, 160, 255),
    text        = Color3.fromRGB(240, 242, 250),
    textDim     = Color3.fromRGB(140, 145, 165),
    borderGlow  = Color3.fromRGB(80, 100, 200),
    success     = Color3.fromRGB(90, 230, 140),
    warning     = Color3.fromRGB(255, 200, 110),
    discord     = Color3.fromRGB(88, 101, 242),
    discordGlow = Color3.fromRGB(114, 137, 218)
}

-- ============================================================
-- HELPERS
-- ============================================================
local function criar(className, props, parent)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function corner(parent, radius)
    if not parent then return nil end
    return criar("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    if not parent then return nil end
    return criar("UIStroke", {
        Color = color or C.borderGlow,
        Thickness = thickness or 1.5,
        Transparency = transparency or 0
    }, parent)
end

local function tween(obj, time, props)
    if not obj then return end
    local ok, t = pcall(function()
        return TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    end)
    if ok and t then t:Play(); return t end
end

-- ============================================================
-- ROOT (cobre tudo)
-- ============================================================
local Root = criar("ScreenGui", {
    Name = "DarkHubUpdateOverlay",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999,
    IgnoreGuiInset = true
}, PlayerGui)

-- Bloqueio total de input atrás do overlay
local Blocker = criar("TextButton", {
    Name = "InputBlocker",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Modal = true,
    Active = true,
    ZIndex = 1
}, Root)

-- Overlay preto cobrindo tudo
local BlackScreen = criar("Frame", {
    Name = "BlackScreen",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    ZIndex = 2
}, Root)

-- ============================================================
-- CARD CENTRAL
-- ============================================================
local Card = criar("Frame", {
    Name = "UpdateCard",
    Size = UDim2.new(0, 420, 0, 360),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ZIndex = 3
}, Root)
corner(Card, 20)
stroke(Card, C.borderGlow, 2, 0.2)

-- Logo Dark Hub
local LogoFrame = criar("Frame", {
    Size = UDim2.new(0, 90, 0, 90),
    Position = UDim2.new(0.5, -45, 0, 25),
    BackgroundColor3 = C.panelLight,
    BorderSizePixel = 0,
    ZIndex = 4
}, Card)
corner(LogoFrame, 45)
stroke(LogoFrame, C.accent, 2, 0.2)

local LogoImg = criar("ImageLabel", {
    Size = UDim2.new(1, -6, 1, -6),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    Image = DARK_HUB_LOGO,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 5
}, LogoFrame)
corner(LogoImg, 42)

-- Título "DARK HUB"
criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 26),
    Position = UDim2.new(0, 0, 0, 128),
    BackgroundTransparency = 1,
    Text = "DARK HUB",
    TextColor3 = C.accent,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    ZIndex = 4
}, Card)

-- Ícone de aviso
criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 158),
    BackgroundTransparency = 1,
    Text = "⚠ SCRIPT DESATUALIZADO ⚠",
    TextColor3 = C.warning,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    ZIndex = 4
}, Card)

-- Mensagem principal
criar("TextLabel", {
    Size = UDim2.new(1, -40, 0, 60),
    Position = UDim2.new(0, 20, 0, 190),
    BackgroundTransparency = 1,
    Text = "Script atualizado,\npegue a nova versão no Discord",
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextWrapped = true,
    ZIndex = 4
}, Card)

-- Texto Discord
criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 262),
    BackgroundTransparency = 1,
    Text = "discord.gg/HGnARQJZhx",
    TextColor3 = C.discordGlow,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    ZIndex = 4
}, Card)

-- ============================================================
-- BOTÃO COPIAR DISCORD
-- ============================================================
local CopyBtn = criar("TextButton", {
    Size = UDim2.new(1, -60, 0, 48),
    Position = UDim2.new(0, 30, 0, 290),
    BackgroundColor3 = C.discord,
    BorderSizePixel = 0,
    Text = "Copiar link do Discord",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    AutoButtonColor = false,
    ZIndex = 4
}, Card)
corner(CopyBtn, 12)
stroke(CopyBtn, C.discordGlow, 1.5, 0.2)

CopyBtn.MouseEnter:Connect(function()
    tween(CopyBtn, 0.15, { BackgroundColor3 = C.discordGlow })
end)
CopyBtn.MouseLeave:Connect(function()
    tween(CopyBtn, 0.15, { BackgroundColor3 = C.discord })
end)

-- Feedback de cópia
local Toast = criar("TextLabel", {
    Size = UDim2.new(1, -60, 0, 20),
    Position = UDim2.new(0, 30, 1, -32),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.success,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 4
}, Card)

CopyBtn.MouseButton1Click:Connect(function()
    -- Tenta copiar com todos os métodos disponíveis
    local copiou = false

    if setclipboard then
        copiou = pcall(function() setclipboard(DISCORD_LINK) end)
    end

    if not copiou and type(clipboard) == "table" and clipboard.set then
        copiou = pcall(function() clipboard.set(DISCORD_LINK) end)
    end

    if not copiou and syn and syn.setclipboard then
        copiou = pcall(function() syn.setclipboard(DISCORD_LINK) end)
    end

    if copiou then
        Toast.Text = "✓ Link copiado com sucesso!"
        Toast.TextColor3 = C.success
        CopyBtn.Text = "Link copiado!"
        CopyBtn.BackgroundColor3 = C.success
        task.wait(1.5)
        CopyBtn.Text = "Copiar link do Discord"
        CopyBtn.BackgroundColor3 = C.discord
        Toast.Text = ""
    else
        Toast.Text = "Não foi possível copiar — copie manualmente:"
        Toast.TextColor3 = C.warning
        Toast.TextSize = 10
        task.wait(2.5)
        Toast.TextSize = 12
        Toast.Text = ""
    end
end)

-- ============================================================
-- ANIMAÇÃO DE ENTRADA
-- ============================================================
Card.Size = UDim2.new(0, 0, 0, 0)
Card.BackgroundTransparency = 1
tween(Card, 0.4, { Size = UDim2.new(0, 420, 0, 360), BackgroundTransparency = 0 })
