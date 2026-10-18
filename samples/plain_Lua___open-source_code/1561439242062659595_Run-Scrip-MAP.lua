
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
local CurrentPlaceId = tostring(game.PlaceId)

local games = {
    ["142823291"] = {
        Name = "Murder Mystery 2",
        ShortName = "ฆาตกรรมลึกลับ 2",
        URL = "https://raw.githubusercontent.com/RUNLUA-HUBS/RUNLUA-HUBS/refs/heads/main/Scrip-MAP/Mysterious%20Murder%202/obf25.txt"
    },
    ["10449761463"] = {
        Name = "The strongest battlefield",
        ShortName = "สนามรบ",
        URL = "https://raw.githubusercontent.com/RUNLUA-HUBS/RUNLUA-HUBS/refs/heads/main/Scrip-MAP/The%20strongest%20battlefield/12.lua"
    },
    ["107778070777162"] = {
        Name = "Steal An Egg",
        ShortName = "ขโมยไข่",
        URL = "https://raw.githubusercontent.com/RUNLUA-HUBS/RUNLUA-HUBS/refs/heads/main/Scrip-MAP/Steal-An-Egg/Stea.lua"
    },
    ["100068273119174"] = {
        Name = "Clean all the Leaves",
        ShortName = "ทำความสะอาดใบไม้ทั้งหมด",
        URL = "https://raw.githubusercontent.com/RUNLUA-HUBS/RUNLUA-HUBS/refs/heads/main/Scrip-MAP/Clean%20all%20the%20Leaves/1.1.lua"
    }
}

local LOGO_URL  = "https://i.postimg.cc/cJKhRc1r/IMG-20260904-201616-447.png"
local LOGO_FILE = "RUNLUA.png"
local DEMON_ICON = ""

-- โหลดไอคอน (Custom Asset)
pcall(function()
    if writefile and isfile and readfile then
        if not isfile(LOGO_FILE) then
            local ImageData = game:HttpGet(LOGO_URL)
            if ImageData and ImageData ~= "" then
                writefile(LOGO_FILE, ImageData)
            end
        end
        if isfile(LOGO_FILE) then
            DEMON_ICON = getcustomasset and getcustomasset(LOGO_FILE) or "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    end
end)

if not DEMON_ICON or DEMON_ICON == "" then
    DEMON_ICON = "rbxassetid://6023426915"
end

-- =========================================================================
-- UI SETUP & CREATION
-- =========================================================================

local ParentGui = (pcall(function() return CoreGui end) and CoreGui) or PlayerGui
local OldGui = ParentGui:FindFirstChild("RUNLUA_HUB_LOADER")
if OldGui then
    OldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUNLUA_HUB_LOADER"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- Background Cover
local FullscreenCover = Instance.new("Frame")
FullscreenCover.Name = "ทับจอทั้งหมด"
FullscreenCover.Size = UDim2.fromScale(1, 1)
FullscreenCover.BackgroundColor3 = Color3.fromRGB(2, 2, 5)
FullscreenCover.BorderSizePixel = 0
FullscreenCover.ZIndex = 1
FullscreenCover.Parent = ScreenGui

local BackgroundGradient = Instance.new("UIGradient")
BackgroundGradient.Rotation = 145
BackgroundGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 1, 3)),
    ColorSequenceKeypoint.new(0.26, Color3.fromRGB(12, 6, 22)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(4, 3, 10)),
    ColorSequenceKeypoint.new(0.78, Color3.fromRGB(16, 6, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 1, 3))
})
BackgroundGradient.Parent = FullscreenCover

-- Glow Effects
local GlowA = Instance.new("Frame")
GlowA.Name = "แสงกลาง"
GlowA.Size = UDim2.fromOffset(700, 700)
GlowA.AnchorPoint = Vector2.new(0.5, 0.5)
GlowA.Position = UDim2.fromScale(0.5, 0.45)
GlowA.BackgroundColor3 = Color3.fromRGB(132, 65, 255)
GlowA.BackgroundTransparency = 0.92
GlowA.BorderSizePixel = 0
GlowA.ZIndex = 2
GlowA.Parent = FullscreenCover

local GlowACorner = Instance.new("UICorner")
GlowACorner.CornerRadius = UDim.new(1, 0)
GlowACorner.Parent = GlowA

local GlowB = Instance.new("Frame")
GlowB.Name = "แสงรอง"
GlowB.Size = UDim2.fromOffset(450, 450)
GlowB.AnchorPoint = Vector2.new(0.5, 0.5)
GlowB.Position = UDim2.fromScale(0.5, 0.43)
GlowB.BackgroundColor3 = Color3.fromRGB(220, 80, 255)
GlowB.BackgroundTransparency = 0.95
GlowB.BorderSizePixel = 0
GlowB.ZIndex = 2
GlowB.Parent = FullscreenCover

local GlowBCorner = Instance.new("UICorner")
GlowBCorner.CornerRadius = UDim.new(1, 0)
GlowBCorner.Parent = GlowB

-- Particles
local ParticleFolder = Instance.new("Folder")
ParticleFolder.Name = "อนุภาค"
ParticleFolder.Parent = FullscreenCover

local Particles = {}
local Rand = Random.new()
for Index = 1, 15 do
    local Particle = Instance.new("Frame")
    Particle.Name = "อนุภาค_" .. Index
    local Size = Rand:NextInteger(2, 6)
    Particle.Size = UDim2.fromOffset(Size, Size)
    Particle.Position = UDim2.fromScale(Rand:NextNumber(0.02, 0.98), Rand:NextNumber(0.02, 0.98))
    Particle.BackgroundColor3 = Color3.fromRGB(184, 120, 255)
    Particle.BackgroundTransparency = Rand:NextNumber(0.35, 0.65)
    Particle.BorderSizePixel = 0
    Particle.ZIndex = 3
    Particle.Parent = ParticleFolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Particle

    Particles[Index] = {
        Object = Particle,
        BasePosition = Particle.Position,
        BaseTransparency = Particle.BackgroundTransparency,
        Phase = Rand:NextNumber(0, math.pi * 2),
        Drift = Rand:NextNumber(0.7, 1.5),
        Pulse = Rand:NextNumber(1.8, 3.2)
    }
end

-- Main Card UI
local Card = Instance.new("Frame")
Card.Name = "หน้าหลัก"
Card.Size = UDim2.fromOffset(540, 510)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.fromScale(0.5, 0.5)
Card.BackgroundColor3 = Color3.fromRGB(10, 9, 16)
Card.BackgroundTransparency = 0.04
Card.BorderSizePixel = 0
Card.ZIndex = 10
Card.Parent = FullscreenCover

local CardScale = Instance.new("UIScale")
CardScale.Scale = 1
CardScale.Parent = Card

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 28)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(189, 120, 255)
CardStroke.Transparency = 0.75
CardStroke.Thickness = 1.5
CardStroke.Parent = Card

-- Top Line Accent
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, -60, 0, 2)
TopLine.Position = UDim2.fromOffset(30, 1)
TopLine.BackgroundColor3 = Color3.fromRGB(178, 102, 255)
TopLine.BackgroundTransparency = 0.38
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 12
TopLine.Parent = Card

local TopLineGradient = Instance.new("UIGradient")
TopLineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 55, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 115, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 55, 255))
})
TopLineGradient.Parent = TopLine

-- Icon & Rings
local IconShadow = Instance.new("Frame")
IconShadow.Name = "แสงไอคอน"
IconShadow.Size = UDim2.fromOffset(185, 185)
IconShadow.AnchorPoint = Vector2.new(0.5, 0)
IconShadow.Position = UDim2.fromScale(0.5, 0.035)
IconShadow.BackgroundColor3 = Color3.fromRGB(136, 61, 255)
IconShadow.BackgroundTransparency = 0.95
IconShadow.BorderSizePixel = 0
IconShadow.ZIndex = 11
IconShadow.Parent = Card

local IconShadowCorner = Instance.new("UICorner")
IconShadowCorner.CornerRadius = UDim.new(1, 0)
IconShadowCorner.Parent = IconShadow

local RingOuter = Instance.new("Frame")
RingOuter.Name = "วงแหวนรอบนอก"
RingOuter.Size = UDim2.fromOffset(150, 150)
RingOuter.AnchorPoint = Vector2.new(0.5, 0)
RingOuter.Position = UDim2.fromScale(0.5, 0.07)
RingOuter.BackgroundTransparency = 1
RingOuter.BorderSizePixel = 0
RingOuter.ZIndex = 12
RingOuter.Parent = Card

local RingOuterCorner = Instance.new("UICorner")
RingOuterCorner.CornerRadius = UDim.new(1, 0)
RingOuterCorner.Parent = RingOuter

local RingOuterStroke = Instance.new("UIStroke")
RingOuterStroke.Color = Color3.fromRGB(169, 82, 255)
RingOuterStroke.Transparency = 0.65
RingOuterStroke.Thickness = 1.2
RingOuterStroke.Parent = RingOuter

local RingInner = Instance.new("Frame")
RingInner.Name = "วงแหวนรอบใน"
RingInner.Size = UDim2.fromOffset(130, 130)
RingInner.AnchorPoint = Vector2.new(0.5, 0)
RingInner.Position = UDim2.fromScale(0.5, 0.091)
RingInner.BackgroundTransparency = 1
RingInner.BorderSizePixel = 0
RingInner.ZIndex = 12
RingInner.Parent = Card

local RingInnerCorner = Instance.new("UICorner")
RingInnerCorner.CornerRadius = UDim.new(1, 0)
RingInnerCorner.Parent = RingInner

local RingInnerStroke = Instance.new("UIStroke")
RingInnerStroke.Color = Color3.fromRGB(239, 121, 255)
RingInnerStroke.Transparency = 0.80
RingInnerStroke.Thickness = 1.2
RingInnerStroke.Parent = RingInner

local IconHolder = Instance.new("Frame")
IconHolder.Name = "ไอคอนปีศาจ"
IconHolder.Size = UDim2.fromOffset(138, 138)
IconHolder.AnchorPoint = Vector2.new(0.5, 0)
IconHolder.Position = UDim2.fromScale(0.5, 0.078)
IconHolder.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
IconHolder.BackgroundTransparency = 0.08
IconHolder.BorderSizePixel = 0
IconHolder.ZIndex = 13
IconHolder.Parent = Card

local IconHolderCorner = Instance.new("UICorner")
IconHolderCorner.CornerRadius = UDim.new(1, 0)
IconHolderCorner.Parent = IconHolder

local IconHolderStroke = Instance.new("UIStroke")
IconHolderStroke.Color = Color3.fromRGB(177, 91, 255)
IconHolderStroke.Transparency = 0.50
IconHolderStroke.Thickness = 1.5
IconHolderStroke.Parent = IconHolder

local Icon = Instance.new("ImageLabel")
Icon.Name = "ปีศาจ"
Icon.Size = UDim2.fromScale(0.88, 0.88)
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Position = UDim2.fromScale(0.5, 0.5)
Icon.BackgroundTransparency = 1
Icon.Image = DEMON_ICON
Icon.ScaleType = Enum.ScaleType.Fit
Icon.ZIndex = 14
Icon.Parent = IconHolder

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local IconHighlight = Instance.new("Frame")
IconHighlight.Size = UDim2.fromScale(0.82, 0.018)
IconHighlight.AnchorPoint = Vector2.new(0.5, 0.5)
IconHighlight.Position = UDim2.fromScale(0.5, 0.22)
IconHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IconHighlight.BackgroundTransparency = 0.93
IconHighlight.BorderSizePixel = 0
IconHighlight.Rotation = -14
IconHighlight.ZIndex = 15
IconHighlight.Parent = IconHolder

local IconHighlightCorner = Instance.new("UICorner")
IconHighlightCorner.CornerRadius = UDim.new(1, 0)
IconHighlightCorner.Parent = IconHighlight

-- Titles & Subtitles
local Title = Instance.new("TextLabel")
Title.Name = "ชื่อ"
Title.Size = UDim2.new(1, -50, 0, 46)
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Position = UDim2.fromScale(0.5, 0.380)
Title.BackgroundTransparency = 1
Title.Text = "RUNLUA HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 38
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 14
Title.Parent = Card

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(234, 202, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(198, 146, 255))
})
TitleGradient.Parent = Title

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "คำอธิบาย"
Subtitle.Size = UDim2.new(1, -50, 0, 28)
Subtitle.AnchorPoint = Vector2.new(0.5, 0)
Subtitle.Position = UDim2.fromScale(0.5, 0.470)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "ศูนย์รวมสคริปต์สำหรับโรบล็อกซ์"
Subtitle.TextColor3 = Color3.fromRGB(185, 177, 202)
Subtitle.TextSize = 17
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.ZIndex = 14
Subtitle.Parent = Card

-- Status Bar
local StatusPill = Instance.new("Frame")
StatusPill.Name = "แถบสถานะ"
StatusPill.Size = UDim2.fromOffset(460, 46)
StatusPill.AnchorPoint = Vector2.new(0.5, 0)
StatusPill.Position = UDim2.fromScale(0.5, 0.535)
StatusPill.BackgroundColor3 = Color3.fromRGB(20, 16, 29)
StatusPill.BackgroundTransparency = 0.12
StatusPill.BorderSizePixel = 0
StatusPill.ZIndex = 13
StatusPill.Parent = Card

local StatusPillCorner = Instance.new("UICorner")
StatusPillCorner.CornerRadius = UDim.new(0, 14)
StatusPillCorner.Parent = StatusPill

local StatusPillStroke = Instance.new("UIStroke")
StatusPillStroke.Color = Color3.fromRGB(141, 85, 225)
StatusPillStroke.Transparency = 0.80
StatusPillStroke.Thickness = 1.2
StatusPillStroke.Parent = StatusPill

local StatusDot = Instance.new("Frame")
StatusDot.Name = "จุดสถานะ"
StatusDot.Size = UDim2.fromOffset(10, 10)
StatusDot.AnchorPoint = Vector2.new(0.5, 0.5)
StatusDot.Position = UDim2.new(0, 22, 0.5, 0)
StatusDot.BackgroundColor3 = Color3.fromRGB(183, 97, 255)
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 15
StatusDot.Parent = StatusPill

local Status = Instance.new("TextLabel")
Status.Name = "สถานะข้อความ"
Status.Size = UDim2.new(1, -44, 1, 0)
Status.Position = UDim2.fromOffset(38, 0)
Status.BackgroundTransparency = 1
Status.Text = "กำลังเริ่มต้นระบบ..."
Status.TextColor3 = Color3.fromRGB(240, 236, 248)
Status.TextSize = 16
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.ZIndex = 15
Status.Parent = StatusPill

-- Game Name Display
local GameName = Instance.new("TextLabel")
GameName.Name = "ชื่อเกม"
GameName.Size = UDim2.new(1, -50, 0, 26)
GameName.AnchorPoint = Vector2.new(0.5, 0)
GameName.Position = UDim2.fromScale(0.5, 0.635)
GameName.BackgroundTransparency = 1
GameName.Text = "กำลังตรวจสอบเกม..."
GameName.TextColor3 = Color3.fromRGB(160, 152, 178)
GameName.TextSize = 15
GameName.Font = Enum.Font.GothamMedium
GameName.TextXAlignment = Enum.TextXAlignment.Center
GameName.ZIndex = 14
GameName.Parent = Card

-- Progress Bar
local ProgressOuter = Instance.new("Frame")
ProgressOuter.Name = "กรอบความคืบหน้า"
ProgressOuter.Size = UDim2.new(1, -88, 0, 14)
ProgressOuter.AnchorPoint = Vector2.new(0.5, 0)
ProgressOuter.Position = UDim2.fromScale(0.5, 0.705)
ProgressOuter.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
ProgressOuter.BackgroundTransparency = 0.13
ProgressOuter.BorderSizePixel = 0
ProgressOuter.ClipsDescendants = true
ProgressOuter.ZIndex = 13
ProgressOuter.Parent = Card

local ProgressOuterCorner = Instance.new("UICorner")
ProgressOuterCorner.CornerRadius = UDim.new(1, 0)
ProgressOuterCorner.Parent = ProgressOuter

local ProgressOuterStroke = Instance.new("UIStroke")
ProgressOuterStroke.Color = Color3.fromRGB(139, 86, 210)
ProgressOuterStroke.Transparency = 0.85
ProgressOuterStroke.Thickness = 1.2
ProgressOuterStroke.Parent = ProgressOuter

local Progress = Instance.new("Frame")
Progress.Name = "ความคืบหน้า"
Progress.Size = UDim2.fromScale(0, 1)
Progress.BackgroundColor3 = Color3.fromRGB(156, 84, 255)
Progress.BorderSizePixel = 0
Progress.ZIndex = 14
Progress.Parent = ProgressOuter

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(1, 0)
ProgressCorner.Parent = Progress

local ProgressGradient = Instance.new("UIGradient")
ProgressGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 49, 220)),
    ColorSequenceKeypoint.new(0.46, Color3.fromRGB(224, 113, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 84, 255))
})
ProgressGradient.Parent = Progress

local ProgressShine = Instance.new("Frame")
ProgressShine.Name = "แสงวิ่ง"
ProgressShine.Size = UDim2.fromScale(0.12, 1)
ProgressShine.Position = UDim2.fromScale(-0.18, 0)
ProgressShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressShine.BackgroundTransparency = 0.78
ProgressShine.BorderSizePixel = 0
ProgressShine.ZIndex = 15
ProgressShine.Parent = Progress

local ProgressShineCorner = Instance.new("UICorner")
ProgressShineCorner.CornerRadius = UDim.new(1, 0)
ProgressShineCorner.Parent = ProgressShine

-- Percentage Text
local Percent = Instance.new("TextLabel")
Percent.Name = "เปอร์เซ็นต์"
Percent.Size = UDim2.new(1, -50, 0, 24)
Percent.AnchorPoint = Vector2.new(0.5, 0)
Percent.Position = UDim2.fromScale(0.5, 0.750)
Percent.BackgroundTransparency = 1
Percent.Text = "0%"
Percent.TextColor3 = Color3.fromRGB(160, 151, 178)
Percent.TextSize = 15
Percent.Font = Enum.Font.GothamMedium
Percent.TextXAlignment = Enum.TextXAlignment.Center
Percent.ZIndex = 14
Percent.Parent = Card

-- Close Button
local RemoveButton = Instance.new("TextButton")
RemoveButton.Name = "ปุ่มปิด"
RemoveButton.Size = UDim2.fromOffset(210, 46)
RemoveButton.AnchorPoint = Vector2.new(0.5, 0)
RemoveButton.Position = UDim2.fromScale(0.5, 0.815)
RemoveButton.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
RemoveButton.BorderSizePixel = 0
RemoveButton.Text = "ปิดหน้าต่าง"
RemoveButton.TextColor3 = Color3.fromRGB(240, 235, 248)
RemoveButton.TextSize = 16
RemoveButton.Font = Enum.Font.GothamMedium
RemoveButton.AutoButtonColor = false
RemoveButton.Visible = false
RemoveButton.ZIndex = 14
RemoveButton.Parent = Card

local RemoveCorner = Instance.new("UICorner")
RemoveCorner.CornerRadius = UDim.new(0, 14)
RemoveCorner.Parent = RemoveButton

local RemoveStroke = Instance.new("UIStroke")
RemoveStroke.Color = Color3.fromRGB(175, 102, 255)
RemoveStroke.Transparency = 0.75
RemoveStroke.Thickness = 1.2
RemoveStroke.Parent = RemoveButton

-- Footer / Credits
local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, -80, 0, 1)
FooterLine.AnchorPoint = Vector2.new(0.5, 0)
FooterLine.Position = UDim2.fromScale(0.5, 0.915)
FooterLine.BackgroundColor3 = Color3.fromRGB(99, 67, 128)
FooterLine.BackgroundTransparency = 0.84
FooterLine.BorderSizePixel = 0
FooterLine.ZIndex = 13
FooterLine.Parent = Card

local Footer = Instance.new("TextLabel")
Footer.Name = "เครดิต"
Footer.Size = UDim2.new(1, -40, 0, 22)
Footer.AnchorPoint = Vector2.new(0.5, 1)
Footer.Position = UDim2.fromScale(0.5, 0.975)
Footer.BackgroundTransparency = 1
Footer.Text = "RUNLUA HUB • กำลังเตรียมระบบให้พร้อมใช้งาน"
Footer.TextColor3 = Color3.fromRGB(135, 124, 148)
Footer.TextSize = 13
Footer.Font = Enum.Font.GothamMedium
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.ZIndex = 14
Footer.Parent = Card

-- =========================================================================
-- FUNCTIONS & ANIMATIONS
-- =========================================================================

local Alive = true
local Closing = false

local function Tween(Object, Time, Properties, Style, Direction)
    if not Object or not Object.Parent then
        return nil
    end
    local TweenInfoObject = TweenInfo.new(
        Time,
        Style or Enum.EasingStyle.Quad,
        Direction or Enum.EasingDirection.Out
    )
    local TweenObject = TweenService:Create(Object, TweenInfoObject, Properties)
    TweenObject:Play()
    return TweenObject
end

local function UpdateScale()
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    local Viewport = Camera.ViewportSize
    local ScaleX = Viewport.X / 620
    local ScaleY = Viewport.Y / 570
    local TargetScale = math.clamp(math.min(ScaleX, ScaleY), 0.63, 1)
    Tween(CardScale, 0.18, { Scale = TargetScale }, Enum.EasingStyle.Quad)
end

UpdateScale()

local ViewportConnection
ViewportConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local Camera = workspace.CurrentCamera
    if Camera then
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
        UpdateScale()
    end
end)

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

local function SetProgress(Value)
    Value = math.clamp(Value, 0, 100)
    Tween(Progress, 0.42, { Size = UDim2.fromScale(Value / 100, 1) }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    Percent.Text = tostring(math.floor(Value)) .. "%"
end

local function SetStatus(Text, Name, ProgressValue)
    if not Alive then return end
    Status.Text = Text
    GameName.Text = Name or ""
    if ProgressValue ~= nil then
        SetProgress(ProgressValue)
    end
end

local function ShowButton()
    if RemoveButton.Visible then return end
    RemoveButton.Visible = true
    RemoveButton.BackgroundTransparency = 1
    RemoveButton.TextTransparency = 1
    RemoveStroke.Transparency = 1
    Tween(RemoveButton, 0.35, { BackgroundTransparency = 0, TextTransparency = 0 }, Enum.EasingStyle.Quart)
    Tween(RemoveStroke, 0.35, { Transparency = 0.75 }, Enum.EasingStyle.Quart)
end

local function SetError(Text)
    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 76, 100)
    SetStatus(Text, GameName.Text, 0)
    ShowButton()
end

local function DestroyUI()
    if not Alive or Closing then return end
    Closing = true
    Alive = false
    
    if ViewportConnection then
        ViewportConnection:Disconnect()
    end
    
    Tween(Card, 0.42, { Position = UDim2.fromScale(0.5, 0.55), BackgroundTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    Tween(FullscreenCover, 0.42, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    
    for _, Object in ipairs(ScreenGui:GetDescendants()) do
        if Object:IsA("TextLabel") or Object:IsA("TextButton") then
            Tween(Object, 0.30, { TextTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        elseif Object:IsA("ImageLabel") then
            Tween(Object, 0.30, { ImageTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        elseif Object:IsA("Frame") then
            if Object ~= Card and Object ~= FullscreenCover then
                Tween(Object, 0.30, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            end
        elseif Object:IsA("UIStroke") then
            Tween(Object, 0.30, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        end
    end
    
    task.wait(0.46)
    if ScreenGui then
        ScreenGui:Destroy()
    end
end

-- Button Events
RemoveButton.Activated:Connect(DestroyUI)
RemoveButton.MouseEnter:Connect(function()
    if not Alive then return end
    Tween(RemoveButton, 0.18, { BackgroundColor3 = Color3.fromRGB(45, 29, 61) }, Enum.EasingStyle.Quart)
    Tween(RemoveStroke, 0.18, { Transparency = 0.45 }, Enum.EasingStyle.Quart)
end)
RemoveButton.MouseLeave:Connect(function()
    if not Alive then return end
    Tween(RemoveButton, 0.18, { BackgroundColor3 = Color3.fromRGB(24, 20, 32) }, Enum.EasingStyle.Quart)
    Tween(RemoveStroke, 0.18, { Transparency = 0.75 }, Enum.EasingStyle.Quart)
end)

-- Loop Animations (Icon, Glow, Particles, etc.)
task.spawn(function()
    local Time = 0
    while Alive and ScreenGui.Parent do
        local Delta = RunService.Heartbeat:Wait()
        Time += Delta
        local BobY = math.sin(Time * 1.65) * 3
        local Tilt = math.sin(Time * 0.92) * 2.2
        local Pulse = 1 + (math.sin(Time * 2.15) * 0.028)
        
        IconHolder.Position = UDim2.new(0.5, 0, 0.078, BobY)
        IconHolder.Rotation = Tilt
        Icon.Size = UDim2.fromScale(0.88 * Pulse, 0.88 * Pulse)
        IconHighlight.Position = UDim2.new(0.5, 0, 0.22 + (math.sin(Time * 1.3) * 0.035), 0)
        IconShadow.Size = UDim2.fromOffset(185 + (math.sin(Time * 1.4) * 12), 185 + (math.sin(Time * 1.4) * 12))
        IconShadow.BackgroundTransparency = 0.957 + ((math.sin(Time * 1.4) + 1) * 0.008)
        RingOuter.Rotation = (Time * 12) % 360
        RingInner.Rotation = (-Time * 16) % 360
    end
end)

task.spawn(function()
    while Alive and ScreenGui.Parent do
        Tween(GlowA, 2.8, { Size = UDim2.fromOffset(760, 760), BackgroundTransparency = 0.94 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(GlowB, 2.8, { Size = UDim2.fromOffset(480, 480), BackgroundTransparency = 0.97 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.8)
        if not Alive then break end
        Tween(GlowA, 2.8, { Size = UDim2.fromOffset(700, 700), BackgroundTransparency = 0.92 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(GlowB, 2.8, { Size = UDim2.fromOffset(450, 450), BackgroundTransparency = 0.95 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.8)
    end
end)

task.spawn(function()
    while Alive and ScreenGui.Parent do
        local ShineTween = Tween(ProgressShine, 1.4, { Position = UDim2.fromScale(1.15, 0) }, Enum.EasingStyle.Linear)
        if ShineTween then
            ShineTween.Completed:Wait()
        else
            break
        end
        if not Alive then break end
        ProgressShine.Position = UDim2.fromScale(-0.18, 0)
        task.wait(0.45)
    end
end)

task.spawn(function()
    while Alive and ScreenGui.Parent do
        Tween(StatusDot, 0.75, { Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 0.52 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.75)
        if not Alive then break end
        Tween(StatusDot, 0.75, { Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.75)
    end
end)

task.spawn(function()
    local Time = 0
    while Alive and ScreenGui.Parent do
        local Delta = RunService.Heartbeat:Wait()
        Time += Delta
        for _, Data in ipairs(Particles) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Phase = Data.Phase + Time * 0.45 * Data.Drift
                local OffsetX = math.cos(Phase) * 0.012
                local OffsetY = math.sin(Phase * 0.78) * 0.020
                local Pulse = (math.sin(Time * Data.Pulse + Data.Phase) + 1) * 0.08
                
                Object.Position = UDim2.new(
                    Data.BasePosition.X.Scale + OffsetX,
                    0,
                    Data.BasePosition.Y.Scale + OffsetY,
                    0
                )
                Object.BackgroundTransparency = math.clamp(Data.BaseTransparency + Pulse, 0.25, 0.88)
            end
        end
    end
end)

task.spawn(function()
    while Alive and ScreenGui.Parent do
        Tween(BackgroundGradient, 4.5, { Offset = Vector2.new(0.08, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(TitleGradient, 2.4, { Offset = Vector2.new(0.12, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.4)
        if not Alive then break end
        Tween(BackgroundGradient, 4.5, { Offset = Vector2.new(-0.08, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(TitleGradient, 2.4, { Offset = Vector2.new(-0.12, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.4)
    end
end)

-- =========================================================================
-- SCRIPT LOADER LOGIC
-- =========================================================================

local function LoadServerScript(Data)
    if not Data or not Alive then return false end
    
    SetStatus("ตรวจพบเกมที่รองรับ", Data.Name, 24)
    task.wait(0.35)
    if not Alive then return false end
    
    SetStatus("กำลังเชื่อมต่อสคริปต์", Data.Name, 40)
    task.wait(0.22)
    if not Alive then return false end
    
    local Source
    local DownloadSuccess, DownloadError = pcall(function()
        Source = game:HttpGet(Data.URL)
    end)
    
    if not DownloadSuccess then
        warn("[RUNLUA HUB] ไม่สามารถดาวน์โหลดสคริปต์:", DownloadError)
        SetError("ดาวน์โหลดสคริปต์ไม่สำเร็จ")
        return false
    end
    
    if not Source or Source == "" then
        SetError("สคริปต์ที่ดาวน์โหลดว่างเปล่า")
        return false
    end
    
    SetStatus("ดาวน์โหลดสคริปต์สำเร็จ", Data.Name, 64)
    task.wait(0.28)
    if not Alive then return false end
    
    SetStatus("กำลังตรวจสอบสคริปต์", Data.Name, 78)
    local Function
    local CompileSuccess, CompileError = pcall(function()
        Function = loadstring(Source)
    end)
    
    if not CompileSuccess then
        warn("[RUNLUA HUB] ตรวจสอบสคริปต์ไม่สำเร็จ:", CompileError)
        SetError("สคริปต์มีข้อผิดพลาด")
        return false
    end
    
    if not Function then
        SetError("ไม่สามารถเตรียมสคริปต์ได้")
        return false
    end
    
    SetStatus("กำลังเริ่มต้นสคริปต์", Data.Name, 90)
    task.wait(0.28)
    if not Alive then return false end
    
    local RunSuccess, RunError = pcall(function()
        task.spawn(Function)
    end)
    
    if not RunSuccess then
        warn("[RUNLUA HUB] สคริปต์ทำงานผิดพลาด:", RunError)
        SetError("สคริปต์ทำงานผิดพลาด")
        return false
    end
    
    SetStatus("สคริปต์เริ่มทำงานแล้ว", Data.Name, 100)
    StatusDot.BackgroundColor3 = Color3.fromRGB(85, 255, 150)
    task.wait(0.55)
    DestroyUI()
    return true
end

-- Initialize Game Check
task.spawn(function()
    task.wait(0.30)
    if not Alive then return end
    
    SetStatus("กำลังตรวจสอบเกม", "รหัสเกม: " .. CurrentPlaceId, 10)
    task.wait(0.40)
    if not Alive then return end
    
    local ScriptData = games[CurrentPlaceId]
    if not ScriptData then
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 180, 72)
        SetStatus("ไม่พบเกมที่รองรับ", "เกมนี้ยังไม่มีสคริปต์ใน RUNLUA HUB", 0)
        ShowButton()
        return
    end
    
    LoadServerScript(ScriptData)
end)
