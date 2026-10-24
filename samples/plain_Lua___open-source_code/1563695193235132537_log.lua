local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

if CoreGui:FindFirstChild("GantengHubAlert") then
    CoreGui.GantengHubAlert:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GantengHubAlert"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Debris:AddItem(ScreenGui, 120)

-- ===== OVERLAY =====
local Overlay = Instance.new("Frame", ScreenGui)
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.ZIndex = 1

-- ===== MAIN CARD (GLASS) =====
local AlertCard = Instance.new("Frame", Overlay)
AlertCard.Size = UDim2.fromOffset(400, 400)
AlertCard.Position = UDim2.new(0.5, 0, 0.5, 40)
AlertCard.AnchorPoint = Vector2.new(0.5, 0.5)
AlertCard.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
AlertCard.BackgroundTransparency = 0.12   -- semi-transparan (glass)
AlertCard.BorderSizePixel = 0
AlertCard.ClipsDescendants = false
AlertCard.ZIndex = 10

-- Responsive scale
local CardScale = Instance.new("UIScale", AlertCard)

local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    if vp.X < 1 or vp.Y < 1 then return end
    -- Design 440x440, scale biar fit 88% viewport
    local scaleX = (vp.X * 0.88) / 440
    local scaleY = (vp.Y * 0.88) / 440
    local scale = math.min(scaleX, scaleY, 1.15)
    scale = math.clamp(scale, 0.55, 1.15)
    CardScale.Scale = scale
end

updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Glass gradient (depth)
local CardGrad = Instance.new("UIGradient", AlertCard)
CardGrad.Rotation = 90
CardGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 38, 58)),   -- lighter top
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 18, 28)), -- middle
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 14)),     -- darker bottom
})

local CardCorner = Instance.new("UICorner", AlertCard)
CardCorner.CornerRadius = UDim.new(0, 12)

-- Shiny gradient border (glass rim)
local CardStroke = Instance.new("UIStroke", AlertCard)
CardStroke.Color = Color3.fromRGB(120, 170, 255)
CardStroke.Thickness = 1.5
CardStroke.Transparency = 0.15
CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local StrokeGrad = Instance.new("UIGradient", CardStroke)
StrokeGrad.Rotation = 90
StrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 210, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 50, 200)),
})
StrokeGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 0.35),
})

-- Top glossy shine
local TopShine = Instance.new("Frame", AlertCard)
TopShine.Size = UDim2.new(1, -12, 0, 3)
TopShine.Position = UDim2.new(0, 6, 0, 6)
TopShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopShine.BackgroundTransparency = 0.05
TopShine.BorderSizePixel = 0
TopShine.ZIndex = 2
local ShineCorner = Instance.new("UICorner", TopShine)
ShineCorner.CornerRadius = UDim.new(1, 0)
local ShineGrad = Instance.new("UIGradient", TopShine)
ShineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.2, 0.35),
    NumberSequenceKeypoint.new(0.8, 0.35),
    NumberSequenceKeypoint.new(1, 1),
})

-- Left accent bar
local LeftAccent = Instance.new("Frame", AlertCard)
LeftAccent.Size = UDim2.new(0, 4, 1, -18)
LeftAccent.Position = UDim2.new(0, 8, 0.5, 0)
LeftAccent.AnchorPoint = Vector2.new(0, 0.5)
LeftAccent.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
LeftAccent.BackgroundTransparency = 1
LeftAccent.BorderSizePixel = 0
LeftAccent.ZIndex = 3
local AccentCorner = Instance.new("UICorner", LeftAccent)
AccentCorner.CornerRadius = UDim.new(1, 0)

-- Soft glow behind card (ambient)
local CardGlow = Instance.new("Frame", AlertCard)
CardGlow.Size = UDim2.new(1, 24, 1, 24)
CardGlow.Position = UDim2.new(0, -12, 0, -12)
CardGlow.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
CardGlow.BackgroundTransparency = 1
CardGlow.BorderSizePixel = 0
CardGlow.ZIndex = 0
local CardGlowCorner = Instance.new("UICorner", CardGlow)
CardGlowCorner.CornerRadius = UDim.new(0, 18)

-- ===== TOP BRAND =====
local TopBrand = Instance.new("TextLabel", AlertCard)
TopBrand.Size = UDim2.new(1, -80, 0, 14)
TopBrand.Position = UDim2.new(0, 20, 0, 12)
TopBrand.BackgroundTransparency = 1
TopBrand.Font = Enum.Font.GothamBold
TopBrand.Text = "GANTENG HUB"
TopBrand.TextColor3 = Color3.fromRGB(120, 170, 255)
TopBrand.TextSize = 9
TopBrand.TextXAlignment = Enum.TextXAlignment.Left
TopBrand.TextTransparency = 1
TopBrand.ZIndex = 5

-- ===== LANGUAGE TOGGLE =====
local LangBtn = Instance.new("TextButton", AlertCard)
LangBtn.Size = UDim2.new(0, 40, 0, 20)
LangBtn.Position = UDim2.new(1, -46, 0, 10)
LangBtn.AnchorPoint = Vector2.new(1, 0)
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 65)
LangBtn.BackgroundTransparency = 0.35
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = "ID"
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 10
LangBtn.AutoButtonColor = false
LangBtn.TextTransparency = 0
LangBtn.ZIndex = 5

local LangCorner = Instance.new("UICorner", LangBtn)
LangCorner.CornerRadius = UDim.new(0, 5)
local LangStroke = Instance.new("UIStroke", LangBtn)
LangStroke.Color = Color3.fromRGB(80, 150, 255)
LangStroke.Thickness = 1
LangStroke.Transparency = 0.3

-- ===== MAIN TITLE =====
local MainTitle = Instance.new("TextLabel", AlertCard)
MainTitle.Size = UDim2.new(1, -40, 0, 24)
MainTitle.Position = UDim2.new(0, 20, 0, 32)
MainTitle.BackgroundTransparency = 1
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.Text = "UPDATE TERSEDIA"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 18
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.TextTransparency = 1
MainTitle.ZIndex = 5

-- ===== DESCRIPTION =====
local Description = Instance.new("TextLabel", AlertCard)
Description.Size = UDim2.new(1, -40, 0, 22)
Description.Position = UDim2.new(0, 20, 0, 60)
Description.BackgroundTransparency = 1
Description.Font = Enum.Font.GothamMedium
Description.Text = "Versi terbaru dari script ini telah rilis.\nSalin link di bawah untuk mengambil script terbaru."
Description.TextColor3 = Color3.fromRGB(180, 195, 220)
Description.TextSize = 10
Description.TextWrapped = true
Description.TextXAlignment = Enum.TextXAlignment.Left
Description.TextYAlignment = Enum.TextYAlignment.Top
Description.TextTransparency = 1
Description.ZIndex = 5

-- ===== CHANGE LOG FRAME =====
local ChangeLogFrame = Instance.new("Frame", AlertCard)
ChangeLogFrame.Size = UDim2.new(1, -40, 0, 210)
ChangeLogFrame.Position = UDim2.new(0, 20, 0, 88)
ChangeLogFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 24)
ChangeLogFrame.BackgroundTransparency = 0.25   -- glass inner box
ChangeLogFrame.BorderSizePixel = 0
ChangeLogFrame.ClipsDescendants = true
ChangeLogFrame.ZIndex = 4

local ChangeLogCorner = Instance.new("UICorner", ChangeLogFrame)
ChangeLogCorner.CornerRadius = UDim.new(0, 8)

local ChangeLogStroke = Instance.new("UIStroke", ChangeLogFrame)
ChangeLogStroke.Color = Color3.fromRGB(60, 90, 150)
ChangeLogStroke.Thickness = 1
ChangeLogStroke.Transparency = 0.5
ChangeLogStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ScrollingFrame
local ChangeLogScroll = Instance.new("ScrollingFrame", ChangeLogFrame)
ChangeLogScroll.Size = UDim2.new(1, -8, 1, -16)
ChangeLogScroll.Position = UDim2.new(0, 4, 0, 8)
ChangeLogScroll.BackgroundTransparency = 1
ChangeLogScroll.BorderSizePixel = 0
ChangeLogScroll.CanvasSize = UDim2.new(0, 0, 0, 500)  -- fallback
ChangeLogScroll.ScrollBarThickness = 4
ChangeLogScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 150, 255)
ChangeLogScroll.ScrollBarImageTransparency = 0.3
ChangeLogScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ChangeLogScroll.ScrollingEnabled = true
ChangeLogScroll.Active = true
ChangeLogScroll.ElasticBehavior = Enum.ElasticBehavior.Never
ChangeLogScroll.ZIndex = 5

-- Text
local ChangeLogText = Instance.new("TextLabel", ChangeLogScroll)
ChangeLogText.Size = UDim2.new(1, -10, 0, 0)
ChangeLogText.Position = UDim2.new(0, 0, 0, 0)
ChangeLogText.AutomaticSize = Enum.AutomaticSize.Y
ChangeLogText.BackgroundTransparency = 1
ChangeLogText.Font = Enum.Font.GothamMedium
ChangeLogText.Text = ""
ChangeLogText.TextColor3 = Color3.fromRGB(215, 220, 235)
ChangeLogText.TextSize = 10
ChangeLogText.TextWrapped = true
ChangeLogText.TextXAlignment = Enum.TextXAlignment.Left
ChangeLogText.TextYAlignment = Enum.TextYAlignment.Top
ChangeLogText.TextTransparency = 1
ChangeLogText.ZIndex = 5

-- Canvas updater (pakai TextBounds yang reliable)
local function updateChangeLogCanvas()
    local h = ChangeLogText.TextBounds.Y
    if h < 50 then
        h = ChangeLogText.AbsoluteSize.Y
    end
    if h and h > 50 then
        ChangeLogScroll.CanvasSize = UDim2.new(0, 0, 0, h + 16)
    end
end

ChangeLogText:GetPropertyChangedSignal("TextBounds"):Connect(updateChangeLogCanvas)
ChangeLogText:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateChangeLogCanvas)

-- Scroll hint (overlay di bawah)
local ScrollHint = Instance.new("TextLabel", ChangeLogFrame)
ScrollHint.Size = UDim2.new(1, 0, 0, 14)
ScrollHint.Position = UDim2.new(0, 0, 1, -14)
ScrollHint.BackgroundColor3 = Color3.fromRGB(10, 14, 24)
ScrollHint.BackgroundTransparency = 0.2
ScrollHint.BorderSizePixel = 0
ScrollHint.Font = Enum.Font.GothamBold
ScrollHint.Text = "▼ scroll untuk lihat semua"
ScrollHint.TextColor3 = Color3.fromRGB(100, 170, 255)
ScrollHint.TextSize = 9
ScrollHint.TextTransparency = 0.05
ScrollHint.ZIndex = 6

-- ===== HINT =====
local HintLabel = Instance.new("TextLabel", AlertCard)
HintLabel.Size = UDim2.new(1, -40, 0, 14)
HintLabel.Position = UDim2.new(0, 20, 0, 304)
HintLabel.BackgroundTransparency = 1
HintLabel.Font = Enum.Font.GothamMedium
HintLabel.Text = "Klik tombol di bawah untuk copy link dan paste ke browser"
HintLabel.TextColor3 = Color3.fromRGB(140, 150, 175)
HintLabel.TextSize = 9
HintLabel.TextWrapped = true
HintLabel.TextXAlignment = Enum.TextXAlignment.Left
HintLabel.TextTransparency = 1
HintLabel.ZIndex = 5

-- ===== COPY BUTTON =====
local CopyBtn = Instance.new("TextButton", AlertCard)
CopyBtn.Size = UDim2.new(0, 165, 0, 34)
CopyBtn.Position = UDim2.new(0, 20, 1, -46)
CopyBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
CopyBtn.BackgroundTransparency = 1
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Text = "SALIN LINK"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 11
CopyBtn.AutoButtonColor = false
CopyBtn.TextTransparency = 1
CopyBtn.ZIndex = 5

local CopyCorner = Instance.new("UICorner", CopyBtn)
CopyCorner.CornerRadius = UDim.new(0, 7)

local BtnGradient = Instance.new("UIGradient", CopyBtn)
BtnGradient.Rotation = 90
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(60, 150, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 80, 200))
})

local CopyStroke = Instance.new("UIStroke", CopyBtn)
CopyStroke.Color = Color3.fromRGB(140, 190, 255)
CopyStroke.Thickness = 1
CopyStroke.Transparency = 0.4

-- ===== CLOSE BUTTON =====
local CloseBtn = Instance.new("TextButton", AlertCard)
CloseBtn.Size = UDim2.new(0, 100, 0, 34)
CloseBtn.Position = UDim2.new(0, 195, 1, -46)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "TUTUP"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.AutoButtonColor = false
CloseBtn.TextTransparency = 1
CloseBtn.ZIndex = 5

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 7)

local CloseStroke = Instance.new("UIStroke", CloseBtn)
CloseStroke.Color = Color3.fromRGB(80, 90, 120)
CloseStroke.Thickness = 1
CloseStroke.Transparency = 1

-- ===== CHANGELOG TEXT =====
local CHANGELOG_FULL = [[[ADD]
+ Secret Quests Panel (Sea 1)
+ Auto All 39 Quests
+ Run Quest Individual
+ Live Quest Status
+ Bring Mob Realtime
+ Anti Mob Stacking
+ Anti Mob Stuck
+ Auto Enter Far Island
+ Auto Attack via Remote
+ Attack Delay Cap

[IMPROVE]
~ Attack to Mob
~ Bring Enemy
~ Far Teleport
~ Chest Farm
~ Auto Un-sit from Boat
~ Memory Cleaner
+ Bring Mob Limit
+ Bring Mob Range
~ Underwater Farm (Sea 3)
~ Secret Quests UI Position
~ UI Design
~ UI Buttons

[FIXED]
* Farm stuck
* Far teleport failed
* Bring Mob not moving
* Farm collision
* Sudden lag
* Underwater Farm (Sea 3)
* Chest farm slow
* Chest farm stuck
* Secret Quests UI cut off
* Attack often missing
* Attack rejected by server
* Attack not firing]]

-- ===== i18n =====
local texts = {
    en = {
        title = "UPDATE AVAILABLE",
        desc = "A new version of the script is available.\nCopy the link below to get the latest script.",
        changelog = CHANGELOG_FULL,
        hint = "Click the button below to copy the link and paste it into your browser",
        copy = "COPY LINK",
        close = "DISMISS",
        copied = "COPIED!",
        lang = "ID"
    },
    id = {
        title = "UPDATE TERSEDIA",
        desc = "Versi terbaru dari script ini telah rilis.\nSalin link di bawah untuk mengambil script terbaru.",
        changelog = CHANGELOG_FULL,
        hint = "Klik tombol di bawah untuk copy link dan paste ke browser",
        copy = "SALIN LINK",
        close = "TUTUP",
        copied = "SALIN BERHASIL!",
        lang = "EN"
    }
}

local currentLang = "id"

local function setLanguage(lang)
    currentLang = lang
    local t = texts[lang]
    MainTitle.Text = t.title
    Description.Text = t.desc
    ChangeLogText.Text = t.changelog
    HintLabel.Text = t.hint
    CopyBtn.Text = t.copy
    CloseBtn.Text = t.close
    LangBtn.Text = t.lang

    ChangeLogScroll.CanvasPosition = Vector2.new(0, 0)
    ScrollHint.TextTransparency = 0.05
    ScrollHint.BackgroundTransparency = 0.2

    -- Update canvas setelah text di-set
    task.defer(updateChangeLogCanvas)
    task.delay(0.03, updateChangeLogCanvas)
    task.delay(0.1, updateChangeLogCanvas)
    task.delay(0.2, updateChangeLogCanvas)
    task.delay(0.4, updateChangeLogCanvas)
end

setLanguage("id")
task.defer(updateChangeLogCanvas)
task.delay(0.05, updateChangeLogCanvas)
task.delay(0.15, updateChangeLogCanvas)
task.delay(0.3, updateChangeLogCanvas)
task.delay(0.6, updateChangeLogCanvas)

-- Fade scroll hint saat user scroll
ChangeLogScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    local isScrolled = ChangeLogScroll.CanvasPosition.Y > 20
    TweenService:Create(ScrollHint, TweenInfo.new(0.2), {
        TextTransparency = isScrolled and 1 or 0.05,
        BackgroundTransparency = isScrolled and 1 or 0.2
    }):Play()
end)

-- Lang toggle
LangBtn.MouseButton1Click:Connect(function()
    local newLang = (currentLang == "en") and "id" or "en"
    setLanguage(newLang)
    TweenService:Create(LangBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 70, 100)}):Play()
    task.wait(0.1)
    TweenService:Create(LangBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 40, 65)}):Play()
end)

LangBtn.MouseEnter:Connect(function()
    TweenService:Create(LangBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 60, 90)}):Play()
end)
LangBtn.MouseLeave:Connect(function()
    TweenService:Create(LangBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 40, 65)}):Play()
end)

-- Open browser
local function openBrowser(url)
    local success = pcall(function()
        GuiService:OpenBrowserWindow(url)
    end)
    if not success then
        pcall(function()
            syn.open_browser(url)
        end)
    end
end

-- ===== ENTRANCE ANIMATION =====
local animIn = TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(Overlay, fadeIn, {BackgroundTransparency = 0.3}):Play()
task.wait(0.1)

TweenService:Create(AlertCard, animIn, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
TweenService:Create(CardGlow, fadeIn, {BackgroundTransparency = 0.92}):Play()
TweenService:Create(CardStroke, fadeIn, {Transparency = 0.15}):Play()
task.wait(0.1)

TweenService:Create(LeftAccent, fadeIn, {BackgroundTransparency = 0}):Play()
TweenService:Create(TopBrand, fadeIn, {TextTransparency = 0.2}):Play()
TweenService:Create(LangBtn, fadeIn, {BackgroundTransparency = 0.35, TextTransparency = 0}):Play()
TweenService:Create(LangStroke, fadeIn, {Transparency = 0.3}):Play()
task.wait(0.05)

TweenService:Create(MainTitle, fadeIn, {TextTransparency = 0}):Play()
task.wait(0.05)
TweenService:Create(Description, fadeIn, {TextTransparency = 0}):Play()
task.wait(0.05)
TweenService:Create(ChangeLogText, fadeIn, {TextTransparency = 0}):Play()
task.wait(0.05)
TweenService:Create(HintLabel, fadeIn, {TextTransparency = 0}):Play()
task.wait(0.1)

TweenService:Create(CopyBtn, fadeIn, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
TweenService:Create(CloseBtn, fadeIn, {BackgroundTransparency = 0.3, TextTransparency = 0}):Play()
TweenService:Create(CloseStroke, fadeIn, {Transparency = 0.3}):Play()

-- ===== COPY BUTTON =====
CopyBtn.MouseEnter:Connect(function()
    TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 160, 255)}):Play()
end)

CopyBtn.MouseLeave:Connect(function()
    TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 120, 255)}):Play()
end)

CopyBtn.Activated:Connect(function()
    local link = "https://isnahamzah.tech/gantenghub"

    if setclipboard then
        setclipboard(link)
    elseif toclipboard then
        toclipboard(link)
    end

    openBrowser(link)

    local copiedText = (currentLang == "en") and "COPIED!" or "SALIN BERHASIL!"
    CopyBtn.Text = copiedText
    TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 80)}):Play()

    task.wait(2)
    local t = texts[currentLang]
    CopyBtn.Text = t.copy
    TweenService:Create(CopyBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 120, 255)}):Play()
end)

-- ===== CLOSE BUTTON =====
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 50, 75), TextColor3 = Color3.fromRGB(80, 150, 255)}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 150, 255)}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 30, 45), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 90, 120)}):Play()
end)

CloseBtn.Activated:Connect(function()
    local animOut = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local fadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    TweenService:Create(CopyBtn, fadeOut, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(CloseBtn, fadeOut, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(CloseStroke, fadeOut, {Transparency = 1}):Play()
    TweenService:Create(LangBtn, fadeOut, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(LangStroke, fadeOut, {Transparency = 1}):Play()
    task.wait(0.05)

    TweenService:Create(HintLabel, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(ScrollHint, fadeOut, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    task.wait(0.05)
    TweenService:Create(ChangeLogText, fadeOut, {TextTransparency = 1}):Play()
    task.wait(0.05)
    TweenService:Create(Description, fadeOut, {TextTransparency = 1}):Play()
    task.wait(0.05)
    TweenService:Create(MainTitle, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(TopBrand, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(LeftAccent, fadeOut, {BackgroundTransparency = 1}):Play()
    task.wait(0.1)

    TweenService:Create(CardStroke, fadeOut, {Transparency = 1}):Play()
    TweenService:Create(CardGlow, fadeOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(AlertCard, animOut, {Position = UDim2.new(0.5, 0, 0.5, -40), BackgroundTransparency = 1}):Play()
    TweenService:Create(Overlay, animOut, {BackgroundTransparency = 1}):Play()

    task.wait(0.5)
    ScreenGui:Destroy()
end)