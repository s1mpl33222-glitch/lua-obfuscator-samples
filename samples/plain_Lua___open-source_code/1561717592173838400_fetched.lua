local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local DISCORD_LINK = "discord.gg/aJUP9ET4jK"

local oldGui = CoreGui:FindFirstChild("Traced")
if oldGui then oldGui:Destroy() end
local oldGui2 = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("Traced")
if oldGui2 then oldGui2:Destroy() end

local THEME = {
    bg     = Color3.fromRGB(8, 6, 11),
    panel  = Color3.fromRGB(19, 14, 23),
    panel2 = Color3.fromRGB(31, 23, 37),
    line   = Color3.fromRGB(48, 36, 54),
    acc    = Color3.fromRGB(214, 104, 36),
    acc2   = Color3.fromRGB(166, 72, 20),
    accHi  = Color3.fromRGB(236, 150, 84),
    txt    = Color3.fromRGB(234, 226, 214),
    sub    = Color3.fromRGB(150, 138, 152),
    input  = Color3.fromRGB(11, 8, 14),
}

local FONT_MED   = Enum.Font.GothamMedium
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_BLACK = Enum.Font.GothamBlack

local I18N = {
    en = {
        title = "Maintenance",
        message = "The script is currently under maintenance. Join our Discord for updates and to know when it will be available again.",
        btn = "JOIN DISCORD",
        copied = "LINK COPIED!",
    },
    es = {
        title = "Mantenimiento",
        message = "El script se encuentra en mantenimiento. Únete a nuestro Discord para recibir actualizaciones y saber cuándo volverá a estar disponible.",
        btn = "UNIRSE AL DISCORD",
        copied = "¡ENLACE COPIADO!",
    }
}

local currentLang = "es"

local function create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(inst, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, inst)
end

local function stroke(inst, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or THEME.line,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, inst)
end

local function tween(inst, time, goal, easing)
    TweenService:Create(inst, TweenInfo.new(time, easing or Enum.EasingStyle.Quad), goal):Play()
end

local function gradient(inst, c1, c2, rotation)
    return create("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rotation or 90,
    }, inst)
end

local function label(text, size, color, font, xAlign, parent)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        Font = font or FONT_MED,
        TextSize = size or 12,
        TextColor3 = color or THEME.txt,
        TextXAlignment = xAlign or Enum.TextXAlignment.Left,
    }, parent)
end

local function createButton(text, parent, isAccent)
    local btn = create("TextButton", {
        BackgroundColor3 = isAccent and THEME.acc or THEME.panel2,
        Text = text,
        Font = isAccent and FONT_BLACK or FONT_BOLD,
        TextSize = isAccent and 13 or 12,
        TextColor3 = isAccent and Color3.fromRGB(30, 12, 4) or THEME.txt,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(btn, 8)
    if isAccent then gradient(btn, THEME.acc, THEME.acc2, 90) end
    local st = stroke(btn, isAccent and THEME.accHi or THEME.line, 1, 0.2)

    btn.MouseEnter:Connect(function()
        if isAccent then
            tween(btn, 0.12, { BackgroundColor3 = THEME.accHi })
        else
            tween(btn, 0.12, { BackgroundColor3 = THEME.panel })
            tween(st,  0.12, { Color = THEME.acc, Transparency = 0 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if isAccent then
            tween(btn, 0.12, { BackgroundColor3 = THEME.acc })
        else
            tween(btn, 0.12, { BackgroundColor3 = THEME.panel2 })
            tween(st,  0.12, { Color = THEME.line, Transparency = 0.2 })
        end
    end)
    return btn
end

local sg = create("ScreenGui", {
    Name = "MaintenanceUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 9999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

local bg = create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(5, 5, 8),
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
}, sg)

local main = create("Frame", {
    Size = UDim2.fromOffset(316, 280),
    BackgroundColor3 = THEME.bg,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true,
}, bg)
corner(main, 14)
gradient(main, Color3.fromRGB(20, 12, 30), Color3.fromRGB(8, 6, 11), 90)
stroke(main, THEME.acc, 1.5, 0.45)
main.Position = UDim2.new(0.5, -158, 0.5, -140)

local bar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, main)
corner(bar, 14)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, bar)

local icon = create("ImageLabel", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(0, 12, 0.5, -12),
    BackgroundColor3 = THEME.panel2,
    BorderSizePixel = 0,
    Image = "rbxthumb://type=Asset&id=76632383635324&w=150&h=150",
}, bar)
corner(icon, 12)
stroke(icon, THEME.acc, 1.5, 0.2)

local titleLabel = label("Kai sniper", 15, THEME.txt, FONT_BLACK, Enum.TextXAlignment.Left, bar)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.fromOffset(44, 0)

-- ============================================================
-- languages button
-- ============================================================
local langContainer = create("Frame", {
    Size = UDim2.fromOffset(80, 26),
    Position = UDim2.new(1, -90, 0.5, -13),
    BackgroundTransparency = 1,
}, bar)

-- Botón EN
local btnEN = create("TextButton", {
    Size = UDim2.fromOffset(36, 26),
    Position = UDim2.fromOffset(0, 0),
    BackgroundColor3 = THEME.panel2,
    Text = "EN",
    Font = FONT_BOLD,
    TextSize = 10,
    TextColor3 = THEME.txt,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    TextXAlignment = Enum.TextXAlignment.Center, 
    TextYAlignment = Enum.TextYAlignment.Center,
    ClipsDescendants = true,
}, langContainer)
corner(btnEN, 6)
local strokeEN = stroke(btnEN, THEME.line, 1, 0.3)


local gradEN = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.acc),
        ColorSequenceKeypoint.new(0.5, THEME.accHi),
        ColorSequenceKeypoint.new(1, THEME.acc)
    }),
    Rotation = 0,
    Enabled = false,
}, btnEN)

-- Botón ES
local btnES = create("TextButton", {
    Size = UDim2.fromOffset(36, 26),
    Position = UDim2.fromOffset(40, 0),
    BackgroundColor3 = THEME.acc,
    Text = "ES",
    Font = FONT_BOLD,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(30, 12, 4),
    AutoButtonColor = false,
    BorderSizePixel = 0,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
    ClipsDescendants = true, -- Importante para el plasma
}, langContainer)
corner(btnES, 6)
local strokeES = stroke(btnES, THEME.accHi, 1, 0.2)


local gradES = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.acc),
        ColorSequenceKeypoint.new(0.5, THEME.accHi),
        ColorSequenceKeypoint.new(1, THEME.acc)
    }),
    Rotation = 0,
    Enabled = true,
}, btnES)


task.spawn(function()
    while main.Parent do
        local t = tick()
        
        gradEN.Rotation = (t * 50) % 360
        gradES.Rotation = (t * 50) % 360
        task.wait(0.03)
    end
end)


local content = create("Frame", {
    Size = UDim2.new(1, -40, 1, -60),
    Position = UDim2.fromOffset(20, 50),
    BackgroundTransparency = 1,
}, main)

local errorTitle = label("", 20, THEME.acc, FONT_BLACK, Enum.TextXAlignment.Center, content)
errorTitle.Size = UDim2.new(1, 0, 0, 30)

local msg = label("", 12, THEME.sub, FONT_MED, Enum.TextXAlignment.Center, content)
msg.Size = UDim2.new(1, 0, 0, 70)
msg.Position = UDim2.fromOffset(0, 30)
msg.TextWrapped = true

local discordBtn = createButton("", content, true)
discordBtn.Size = UDim2.new(1, 0, 0, 36)
discordBtn.Position = UDim2.new(0, 0, 1, -56)

local linkLbl = label(DISCORD_LINK, 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Center, content)
linkLbl.Size = UDim2.new(1, 0, 0, 20)
linkLbl.Position = UDim2.new(0, 0, 1, -20)

-- ============================================================
-- language logic
-- ============================================================
local function updateLanguage(lang)
    currentLang = lang
    local t = I18N[lang]
    
    errorTitle.Text = t.title
    msg.Text = t.message
    discordBtn.Text = t.btn
    
    if lang == "en" then
        
        gradEN.Enabled = true
        strokeEN.Color = THEME.accHi
        strokeEN.Transparency = 0
        btnEN.TextColor3 = Color3.fromRGB(30, 12, 4)
        
        
        gradES.Enabled = false
        btnES.BackgroundColor3 = THEME.panel2
        strokeES.Color = THEME.line
        strokeES.Transparency = 0.3
        btnES.TextColor3 = THEME.txt
    else
        
        gradES.Enabled = true
        strokeES.Color = THEME.accHi
        strokeES.Transparency = 0
        btnES.TextColor3 = Color3.fromRGB(30, 12, 4)
        
        
        gradEN.Enabled = false
        btnEN.BackgroundColor3 = THEME.panel2
        strokeEN.Color = THEME.line
        strokeEN.Transparency = 0.3
        btnEN.TextColor3 = THEME.txt
    end
end

btnEN.MouseButton1Click:Connect(function() updateLanguage("en") end)
btnES.MouseButton1Click:Connect(function() updateLanguage("es") end)

updateLanguage("es")

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        pcall(setclipboard, DISCORD_LINK)
        discordBtn.Text = I18N[currentLang].copied
        task.wait(2)
        discordBtn.Text = I18N[currentLang].btn
    end
end)

main.Size = UDim2.fromOffset(0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
bg.BackgroundTransparency = 1

task.wait(0.1)
tween(main, 0.4, {
    Size = UDim2.fromOffset(316, 280),
    Position = UDim2.new(0.5, -158, 0.5, -140)
}, Enum.EasingStyle.Back)
tween(bg, 0.3, { BackgroundTransparency = 0.1 })
