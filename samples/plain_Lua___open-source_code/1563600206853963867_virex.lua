-- ======================================================
-- VIREX INTRO LOADER • EPIC MOBILE EDITION
-- The uploaded Virex Hub Intro source runs first.
-- ======================================================
local VIREX_INTRO_SOURCE = [=[
-- ======================================================
-- VIREX HUB • IMPACT INTRO
-- VIREX enters from the RIGHT and HUB from the LEFT.
-- ======================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local LOGO_ASSET = "rbxassetid://107391174248131"

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GuiParent = (gethui and gethui()) or PlayerGui

local oldIntro = GuiParent:FindFirstChild("VirexHubIntro")
if oldIntro then pcall(function() oldIntro:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VirexHubIntro"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100000
ScreenGui.Parent = GuiParent

local Blur = Instance.new("BlurEffect")
Blur.Name = "VirexHubIntroBlur"
Blur.Size = 0
Blur.Parent = Lighting

local Background = Instance.new("Frame")
Background.Size = UDim2.fromScale(1,1)
Background.BackgroundColor3 = Color3.fromRGB(2,4,8)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(2,4,8)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(8,12,20)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(8,12,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2,4,8))
})
bgGradient.Offset = Vector2.new(1.25,0)
bgGradient.Parent = Background

local glow = Instance.new("Frame")
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.Position = UDim2.fromScale(0.5,0.5)
glow.Size = UDim2.fromScale(0.8,0.5)
glow.BackgroundColor3 = Color3.fromRGB(255,45,60)
glow.BackgroundTransparency = 0.96
glow.BorderSizePixel = 0
glow.Parent = Background

local titleGroup = Instance.new("Frame")
titleGroup.AnchorPoint = Vector2.new(0.5,0.5)
titleGroup.Position = UDim2.fromScale(0.5,0.47)
titleGroup.Size = UDim2.fromScale(0.82,0.20)
titleGroup.BackgroundTransparency = 1
titleGroup.Parent = ScreenGui

local virex = Instance.new("TextLabel")
virex.BackgroundTransparency = 1
virex.AnchorPoint = Vector2.new(1,0.5)
virex.Position = UDim2.new(0.5,-6,0.5,0)
virex.Size = UDim2.new(0.46,0,1,0)
virex.Text = "VIREX"
virex.Font = Enum.Font.Gotham
virex.TextSize = 56
virex.TextColor3 = Color3.fromRGB(255,255,255)
virex.TextXAlignment = Enum.TextXAlignment.Right
virex.Parent = titleGroup

local hub = Instance.new("TextLabel")
hub.BackgroundTransparency = 1
hub.AnchorPoint = Vector2.new(0,0.5)
hub.Position = UDim2.new(0.5,6,0.5,0)
hub.Size = UDim2.new(0.46,0,1,0)
hub.Text = "HUB"
hub.Font = Enum.Font.Gotham
hub.TextSize = 56
hub.TextColor3 = Color3.fromRGB(255,55,70)
hub.TextXAlignment = Enum.TextXAlignment.Left
hub.Parent = titleGroup

local vGrad = Instance.new("UIGradient")
vGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,55,70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,55,70))
})
vGrad.Parent = virex

local hGrad = vGrad:Clone()
hGrad.Parent = hub

local impact = Instance.new("Frame")
impact.AnchorPoint = Vector2.new(0.5,0.5)
impact.Position = UDim2.fromScale(0.5,0.47)
impact.Size = UDim2.fromOffset(4,52)
impact.BackgroundColor3 = Color3.fromRGB(8,8,10)
impact.BackgroundTransparency = 1
impact.Rotation = -8
impact.ZIndex = 10
impact.Parent = ScreenGui

local logo = Instance.new("ImageLabel")
logo.AnchorPoint = Vector2.new(0.5,0.5)
logo.Position = UDim2.fromScale(0.5,0.28)
logo.Size = UDim2.fromOffset(70,70)
logo.BackgroundTransparency = 1
logo.Image = LOGO_ASSET
logo.ImageTransparency = 1
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = ScreenGui

local logoShine = Instance.new("Frame")
logoShine.AnchorPoint = Vector2.new(0.5,0.5)
logoShine.Position = UDim2.fromScale(1.3,0.5)
logoShine.Size = UDim2.new(0.22,0,1.35,0)
logoShine.BackgroundColor3 = Color3.fromRGB(255,255,255)
logoShine.BackgroundTransparency = 0.65
logoShine.BorderSizePixel = 0
logoShine.Rotation = 12
logoShine.Parent = logo

local logoShineGrad = Instance.new("UIGradient")
logoShineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.45,1),
    NumberSequenceKeypoint.new(0.5,0.05),
    NumberSequenceKeypoint.new(0.55,1),
    NumberSequenceKeypoint.new(1,1)
})
logoShineGrad.Parent = logoShine

logo.ClipsDescendants = true

local status = Instance.new("TextLabel")
status.AnchorPoint = Vector2.new(0.5,0)
status.Position = UDim2.fromScale(0.5,0.62)
status.Size = UDim2.new(0.8,0,0,20)
status.BackgroundTransparency = 1
status.Text = "INITIALIZING VIREX HUB"
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextColor3 = Color3.fromRGB(145,150,160)
status.TextTransparency = 1
status.Parent = ScreenGui

local function tw(obj, time, style, dir, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

task.spawn(function()
    while ScreenGui.Parent and Background.Parent do
        bgGradient.Offset = Vector2.new(1.25,0)
        local t = tw(bgGradient, 2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, {Offset=Vector2.new(-1.25,0)})
        t.Completed:Wait()
        task.wait(0.12)
    end
end)

task.spawn(function()
    while ScreenGui.Parent and logo.Parent do
        logoShine.Position = UDim2.fromScale(1.3,0.5)
        local t = tw(logoShine, 1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, {Position=UDim2.fromScale(-0.3,0.5)})
        t.Completed:Wait()
        task.wait(0.35)
    end
end)

local function fadeText(label, transparency, time)
    tw(label, time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {TextTransparency=transparency})
end

-- VIREX starts outside on the right. HUB starts outside on the left.
virex.Position = UDim2.new(1.18,0,0.5,0)
hub.Position = UDim2.new(-0.18,0,0.5,0)
virex.TextTransparency = 0
hub.TextTransparency = 0

tw(Blur, 0.80, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size=16})
fadeText(status,0,0.55)

-- The two words collide, compress slightly, then rebound like two objects meeting.
tw(virex, 1.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Position=UDim2.new(0.5,12,0.5,0)})
tw(hub, 1.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Position=UDim2.new(0.5,-12,0.5,0)})
task.wait(1.05)

-- Impact crack: X and H briefly darken at the exact meeting point.
tw(impact,0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,{BackgroundTransparency=0.05, Size=UDim2.fromOffset(9,66)})
tw(virex,0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,{Position=UDim2.new(0.5,-2,0.5,0)})
tw(hub,0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,{Position=UDim2.new(0.5,2,0.5,0)})
task.wait(0.14)

-- Rebound: they separate a little, then settle together again.
tw(impact,0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In,{BackgroundTransparency=1, Size=UDim2.fromOffset(2,48)})
tw(virex,0.48,Enum.EasingStyle.Back,Enum.EasingDirection.Out,{Position=UDim2.new(0.5,-6,0.5,0)})
tw(hub,0.48,Enum.EasingStyle.Back,Enum.EasingDirection.Out,{Position=UDim2.new(0.5,6,0.5,0)})
status.Text = "VIREX HUB • READY"
task.wait(0.65)

-- Logo arrives after the title has fully settled.
tw(logo,0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out,{ImageTransparency=0, Position=UDim2.fromScale(0.5,0.28)})
task.wait(0.65)

-- Cinematic handoff: title pulls backward while the main UI is revealed.
tw(Blur,0.55,Enum.EasingStyle.Quart,Enum.EasingDirection.Out,{Size=22})
tw(titleGroup,0.65,Enum.EasingStyle.Quart,Enum.EasingDirection.In,{Position=UDim2.fromScale(0.5,0.40), Size=UDim2.fromScale(1.02,0.25)})
tw(logo,0.55,Enum.EasingStyle.Quart,Enum.EasingDirection.In,{ImageTransparency=1, Position=UDim2.fromScale(0.5,0.20)})
tw(status,0.40,Enum.EasingStyle.Quart,Enum.EasingDirection.In,{TextTransparency=1})
task.wait(0.65)

tw(Blur,0.65,Enum.EasingStyle.Quart,Enum.EasingDirection.In,{Size=0})
tw(Background,0.65,Enum.EasingStyle.Quart,Enum.EasingDirection.In,{BackgroundTransparency=1})
task.wait(0.70)

pcall(function() Blur:Destroy() end)
ScreenGui:Destroy()
]=]

--[[
    VIREX SCRIPT HUB
    Built from Steal_An_Egg_All_Scripts.txt

    Features:
    - Small mobile-friendly GUI
    - Scripts tab with all named entries from the source file
    - Config tab
    - GUI size controls
    - Color/theme controls
    - Touch + mouse dragging
    - Open / close / minimize animations
    - Individual execute buttons
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local VirexSoundFolder = Instance.new("Folder")
VirexSoundFolder.Name = "VirexSounds"
VirexSoundFolder.Parent = SoundService

-- One sound only: every click/option change produces exactly one immediate sound.
local VirexClickSound = Instance.new("Sound")
VirexClickSound.Name = "VirexClick"
VirexClickSound.SoundId = "rbxassetid://6026984224"
VirexClickSound.Volume = 0.30
VirexClickSound.Parent = VirexSoundFolder

local function VirexPlayClick(speed, volume)
    pcall(function()
        VirexClickSound:Stop()
        VirexClickSound.TimePosition = 0
        VirexClickSound.PlaybackSpeed = speed or 1
        VirexClickSound.Volume = volume or 0.30
        VirexClickSound:Play()
    end)
end

local function VirexPlayExecute()
    VirexPlayClick(1.18, 0.34)
end

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("Virex")
if old then
    old:Destroy()
end

local Scripts = {}

local Themes = {
    {Name = "Virex Red", Main = Color3.fromRGB(8, 16, 30), Panel = Color3.fromRGB(13, 27, 46), Accent = Color3.fromRGB(255, 72, 72), ButtonDark = Color3.fromRGB(95, 8, 18)},
    {Name = "Virex Purple", Main = Color3.fromRGB(18, 17, 25), Panel = Color3.fromRGB(27, 24, 36), Accent = Color3.fromRGB(160, 100, 255), ButtonDark = Color3.fromRGB(72, 35, 120)},
    {Name = "Virex Blue", Main = Color3.fromRGB(15, 19, 26), Panel = Color3.fromRGB(23, 29, 40), Accent = Color3.fromRGB(75, 145, 255), ButtonDark = Color3.fromRGB(18, 55, 105)},
    {Name = "Virex Gold", Main = Color3.fromRGB(22, 20, 16), Panel = Color3.fromRGB(31, 28, 21), Accent = Color3.fromRGB(255, 190, 65), ButtonDark = Color3.fromRGB(105, 72, 12)},
    {Name = "Virex Green", Main = Color3.fromRGB(15, 22, 19), Panel = Color3.fromRGB(22, 32, 27), Accent = Color3.fromRGB(75, 220, 135), ButtonDark = Color3.fromRGB(18, 92, 55)},
}

local VIREX_LOGO_ASSET = "rbxassetid://107391174248131"

local ThemeIndex = 1
local SizeIndex = 2
local Sizes = {
    UDim2.fromOffset(320, 250),
    UDim2.fromOffset(360, 285),
    UDim2.fromOffset(410, 325),
}

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function addAnimatedButtonBorder(button, accent)
    local border = Instance.new("UIStroke")
    border.Name = "VirexButtonBorder"
    border.Thickness = 1.25
    border.Color = accent
    border.Transparency = 0.10
    border.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Name = "VirexButtonBorderGradient"
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, accent),
        ColorSequenceKeypoint.new(0.40, accent),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60, accent),
        ColorSequenceKeypoint.new(1.00, accent)
    })
    gradient.Offset = Vector2.new(1.15,0)
    gradient.Parent = border

    task.spawn(function()
        while button.Parent and border.Parent do
            gradient.Offset = Vector2.new(1.15,0)
            local t = tween(gradient,TweenInfo.new(1.55,Enum.EasingStyle.Linear),{Offset=Vector2.new(-1.15,0)})
            t.Completed:Wait()
            task.wait(0.08)
        end
    end)

    return border
end

local gui = Instance.new("ScreenGui")
gui.Name = "Virex"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local scale = Instance.new("UIScale")
scale.Scale = 0.88
scale.Parent = gui

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.52)
shadow.Size = Sizes[SizeIndex]
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.45
shadow.BorderSizePixel = 0
shadow.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.48)
main.Size = Sizes[SizeIndex]
main.BackgroundColor3 = Color3.fromRGB(8, 16, 30)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainBgSweep = Instance.new("UIGradient")
mainBgSweep.Name = "VirexBackgroundSweep"
mainBgSweep.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(8,16,30)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(8,16,30)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(8,16,30)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8,16,30))
})
mainBgSweep.Offset = Vector2.new(1.25,0)
mainBgSweep.Parent = main

task.spawn(function()
    while gui.Parent and main.Parent do
        mainBgSweep.Offset = Vector2.new(1.25,0)
        local t = tween(mainBgSweep,TweenInfo.new(3.0,Enum.EasingStyle.Linear),{Offset=Vector2.new(-1.25,0)})
        t.Completed:Wait()
        task.wait(0.12)
    end
end)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,0,0)
stroke.Transparency = 0.05
stroke.Parent = main

local top = Instance.new("Frame")
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(74, 3)
title.Size = UDim2.new(1, -170, 0, 28)
title.Font = Enum.Font.Gotham
title.Text = "VIREX"
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextColor3 = Color3.new(1,1,1)
title.Parent = top

local titleGradient = Instance.new("UIGradient")
titleGradient.Rotation = 0
titleGradient.Offset = Vector2.new(1.2, 0)
titleGradient.Parent = title

local VirexRed = Color3.fromRGB(255, 72, 72)
local VirexWhite = Color3.fromRGB(255, 255, 255)

-- VIREX: seamless red -> white -> red -> white.
-- Both ends are red so the loop can restart without a visible red snap.
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, VirexRed),
    ColorSequenceKeypoint.new(0.18, VirexRed),
    ColorSequenceKeypoint.new(0.34, VirexWhite),
    ColorSequenceKeypoint.new(0.50, VirexRed),
    ColorSequenceKeypoint.new(0.66, VirexRed),
    ColorSequenceKeypoint.new(0.82, VirexWhite),
    ColorSequenceKeypoint.new(1.00, VirexRed)
})

task.spawn(function()
    while gui.Parent and title.Parent do
        titleGradient.Offset = Vector2.new(1.2, 0)
        local t = tween(titleGradient, TweenInfo.new(1.15, Enum.EasingStyle.Linear), {
            Offset = Vector2.new(-1.2, 0)
        })
        t.Completed:Wait()
        -- Endpoints are both red, so the restart is visually continuous.
    end
end)

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 58, 0, 29)
subtitle.Size = UDim2.new(1, -116, 0, 16)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "SCRIPT HUB"
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.TextColor3 = Color3.fromRGB(145,145,155)
subtitle.Parent = top

local function topButton(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(30, 28)
    b.Position = UDim2.new(1, x, 0, 8)
    b.AnchorPoint = Vector2.new(1, 0)
    b.BackgroundColor3 = Color3.fromRGB(13, 27, 46)
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.AutoButtonColor = false
    b.Parent = top
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    addAnimatedButtonBorder(b, Themes[ThemeIndex].Accent)
    return b
end

local minimize = topButton("—", -88)
local close = topButton("×", -50)

local topLogo = Instance.new("ImageLabel")
topLogo.Name = "VirexTopLogo"
topLogo.AnchorPoint = Vector2.new(1,0)
topLogo.Position = UDim2.new(1,-8,0,6)
topLogo.Size = UDim2.fromOffset(38,38)
topLogo.BackgroundTransparency = 1
topLogo.Image = VIREX_LOGO_ASSET
topLogo.ScaleType = Enum.ScaleType.Fit
topLogo.ClipsDescendants = true
topLogo.ZIndex = 8
topLogo.Parent = top

local topLogoShine = Instance.new("Frame")
topLogoShine.Name = "WhiteShine"
topLogoShine.AnchorPoint = Vector2.new(0.5,0.5)
topLogoShine.Position = UDim2.fromScale(1.3,0.5)
topLogoShine.Size = UDim2.new(0.24,0,1.45,0)
topLogoShine.BackgroundColor3 = Color3.fromRGB(255,255,255)
topLogoShine.BackgroundTransparency = 0.68
topLogoShine.BorderSizePixel = 0
topLogoShine.Rotation = 12
topLogoShine.ZIndex = 9
topLogoShine.Parent = topLogo

local topLogoShineGradient = Instance.new("UIGradient")
topLogoShineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.44,1),
    NumberSequenceKeypoint.new(0.50,0.05),
    NumberSequenceKeypoint.new(0.56,1),
    NumberSequenceKeypoint.new(1,1)
})
topLogoShineGradient.Parent = topLogoShine

task.spawn(function()
    while gui.Parent and topLogo.Parent do
        topLogoShine.Position = UDim2.fromScale(1.3,0.5)
        local t = tween(topLogoShine,TweenInfo.new(1.25,Enum.EasingStyle.Linear),{Position=UDim2.fromScale(-0.3,0.5)})
        t.Completed:Wait()
        task.wait(0.25)
    end
end)

-- Dedicated drag line OUTSIDE the main GUI, slightly below it.
-- It follows the whole window and remains available while the GUI is open.
local dragHandle = Instance.new("TextButton")
dragHandle.Name = "VirexDragHandle"
dragHandle.AnchorPoint = Vector2.new(0.5, 0.5)
dragHandle.Size = UDim2.fromOffset(110, 16)
dragHandle.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
dragHandle.BackgroundTransparency = 1
dragHandle.BorderSizePixel = 0
dragHandle.Text = ""
dragHandle.AutoButtonColor = false
dragHandle.ZIndex = 60
dragHandle.Visible = false
dragHandle.Parent = gui

local dragVisual = Instance.new("Frame")
dragVisual.Name = "Line"
dragVisual.AnchorPoint = Vector2.new(0.5, 0.5)
dragVisual.Position = UDim2.fromScale(0.5, 0.5)
dragVisual.Size = UDim2.fromOffset(76, 3)
dragVisual.BackgroundColor3 = Themes[ThemeIndex].Accent
dragVisual.BackgroundTransparency = 0.10
dragVisual.BorderSizePixel = 0
dragVisual.ZIndex = 61
dragVisual.Parent = dragHandle
local dragVisualCorner = Instance.new("UICorner")
dragVisualCorner.CornerRadius = UDim.new(1, 0)
dragVisualCorner.Parent = dragVisual

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(1, 0)
dragCorner.Parent = dragHandle

-- Bottom-right resize handle. It stays OUTSIDE the GUI and follows it exactly.
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "VirexResizeHandle"
resizeHandle.AnchorPoint = Vector2.new(0.5, 0.5)
resizeHandle.Size = UDim2.fromOffset(30, 30)
resizeHandle.BackgroundTransparency = 1
resizeHandle.BorderSizePixel = 0
resizeHandle.Text = "↘"
resizeHandle.Font = Enum.Font.Gotham
resizeHandle.TextSize = 18
resizeHandle.TextColor3 = Themes[ThemeIndex].Accent
resizeHandle.AutoButtonColor = false
resizeHandle.ZIndex = 70
resizeHandle.Visible = false
resizeHandle.Parent = gui

local resizeDragging = false
local resizeStartInput
local resizeStartSize

-- Animated perimeter: theme color -> white -> theme color.
task.spawn(function()
    while gui.Parent and main.Parent do
        local th = Themes[ThemeIndex]
        stroke.Color = th.Accent
        stroke.Transparency = 0.02
        local toWhite = tween(stroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(255,255,255)})
        toWhite.Completed:Wait()
        local toAccent = tween(stroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Themes[ThemeIndex].Accent})
        toAccent.Completed:Wait()
    end
end)

local function updateFloatingControls()
    local x = main.Position.X.Scale
    local ox = main.Position.X.Offset
    local y = main.Position.Y.Scale
    local oy = main.Position.Y.Offset
    local halfW = main.AbsoluteSize.X * 0.5
    local halfH = main.AbsoluteSize.Y * 0.5
    dragHandle.Position = UDim2.new(x, ox, y, oy + halfH + 12)
    resizeHandle.Position = UDim2.new(x, ox + halfW + 15, y, oy + halfH + 15)
end

local function updateDragHandlePosition()
    updateFloatingControls()
end

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.fromOffset(8, 61)
sidebar.Size = UDim2.new(0, 98, 1, -69)
sidebar.BackgroundColor3 = Color3.fromRGB(13, 27, 46)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 7)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 9)
sidePad.PaddingBottom = UDim.new(0, 8)
sidePad.Parent = sidebar

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 114, 0, 61)
content.Size = UDim2.new(1, -122, 1, -69)
content.BackgroundTransparency = 1
content.Parent = main

local currentTab = "Scripts"
local pages = {}

local function makePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1,1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Themes[ThemeIndex].Accent
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Visible = (name == "Scripts")
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = page

    pages[name] = page
    return page
end

local scriptsPage = makePage("Scripts")
local configPage = makePage("Config")

local tabButtons = {}

local tabSweepTokens = {}

local function makeTab(text, icon)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 39)
    b.BackgroundColor3 = Themes[ThemeIndex].Panel
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = sidebar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = b
    addAnimatedButtonBorder(b, Themes[ThemeIndex].Accent)

    local sweepBg = Instance.new("Frame")
    sweepBg.Name = "SelectedDarkBlueWhiteSweep"
    sweepBg.Size = UDim2.fromScale(1, 1)
    sweepBg.BackgroundColor3 = Color3.fromRGB(8, 16, 30)
    sweepBg.BorderSizePixel = 0
    sweepBg.Visible = false
    sweepBg.ZIndex = b.ZIndex + 1
    sweepBg.Parent = b
    local sweepCorner = Instance.new("UICorner")
    sweepCorner.CornerRadius = UDim.new(0, 9)
    sweepCorner.Parent = sweepBg
    local sweep = Instance.new("UIGradient")
    sweep.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Themes[ThemeIndex].Accent),
        ColorSequenceKeypoint.new(0.40, Themes[ThemeIndex].Accent),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60, Themes[ThemeIndex].Accent),
        ColorSequenceKeypoint.new(1.00, Themes[ThemeIndex].Accent)
    })
    sweepBg.BackgroundColor3 = Themes[ThemeIndex].Accent
    sweep.Rotation = 0
    sweep.Offset = Vector2.new(1.15, 0)
    sweep.Parent = sweepBg

    local label = Instance.new("TextLabel")
    label.Name = "TabLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Text = icon .. "  " .. text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.fromOffset(10, 0)
    label.ZIndex = b.ZIndex + 2
    label.Parent = b

    tabButtons[text] = b
    return b
end

local scriptsTab = makeTab("Scripts", "🛡")
local configTab = makeTab("Config", "⚙")
-- Pin Scripts at the top and Config at the absolute bottom of the sidebar.
sideLayout:Destroy()
scriptsTab.LayoutOrder = 1
configTab.LayoutOrder = 2
scriptsTab.Position = UDim2.fromOffset(6, 9)
configTab.Position = UDim2.new(0, 6, 1, -52)

local function refreshTabs()
    for name, b in pairs(tabButtons) do
        local selected = (name == "Scripts" and currentTab == "Scripts")
            or (name == "Config" and currentTab == "Config")
        local sweepBg = b:FindFirstChild("SelectedDarkBlueWhiteSweep")
        local sweep = sweepBg and sweepBg:FindFirstChildOfClass("UIGradient")
        local tabLabel = b:FindFirstChild("TabLabel")
        if selected then
            b.BackgroundColor3 = Themes[ThemeIndex].Panel
            if sweepBg then sweepBg.Visible = true end
            if tabLabel then tabLabel.TextColor3 = Color3.fromRGB(255,255,255); tabLabel.TextSize = 12 end
            tween(b, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -8, 0, 44)})
            if sweep then
                tabSweepTokens[name] = (tabSweepTokens[name] or 0) + 1
                local token = tabSweepTokens[name]
                task.spawn(function()
                    while gui.Parent and currentTab == name and tabSweepTokens[name] == token and b.Parent do
                        sweep.Offset = Vector2.new(1.15, 0)
                        local tw = tween(sweep, TweenInfo.new(1.8, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1.15, 0)})
                        tw.Completed:Wait()
                    end
                end)
            end
        else
            tabSweepTokens[name] = (tabSweepTokens[name] or 0) + 1
            if sweepBg then sweepBg.Visible = false end
            b.BackgroundColor3 = Themes[ThemeIndex].Panel
            if tabLabel then tabLabel.TextColor3 = Color3.fromRGB(255,255,255); tabLabel.TextSize = 11 end
            tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -12, 0, 39)})
        end
    end

    for name, page in pairs(pages) do
        page.Visible = (name == currentTab)
        if page.Visible then
            page.CanvasPosition = Vector2.zero
        end
    end
end

local function switchTab(tab)
    currentTab = tab
    refreshTabs()
end

scriptsTab.Activated:Connect(function() VirexPlayClick(); switchTab("Scripts") end)
configTab.Activated:Connect(function() VirexPlayClick(); switchTab("Config") end)

local function execute(code, button)
    VirexPlayExecute()
    local oldText = button.Text
    button.Text = "LOADING..."
    task.spawn(function()
        local ok, fnOrErr = pcall(loadstring, code)
        if ok and type(fnOrErr) == "function" then
            task.spawn(function()
                local ran, err = pcall(fnOrErr)
                if not ran then warn("[Virex] Script error:", err) end
            end)
            button.Text = "EXECUTED ✓"
        else
            warn("[Virex] Load error:", fnOrErr)
            button.Text = "ERROR"
        end
        task.wait(0.8)
        if button and button.Parent then
            button.Text = oldText
        end
    end)
end

local function addScriptCard(parent, name, code)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 58)
    card.BackgroundColor3 = Color3.fromRGB(13, 27, 46)
    card.BorderSizePixel = 0
    card.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = card

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(55,55,65)
    s.Transparency = 0.5
    s.Parent = card

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(10, 7)
    label.Size = UDim2.new(1, -95, 0, 40)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextSize = 11
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextColor3 = Color3.new(1,1,1)
    label.Parent = card

    local run = Instance.new("TextButton")
    run.Name = "RUN"
    run.Size = UDim2.fromOffset(72, 31)
    run.Position = UDim2.new(1, -82, 0.5, 0)
    run.AnchorPoint = Vector2.new(0, 0.5)
    run.BackgroundTransparency = 1
    run.BorderSizePixel = 0
    run.Text = ""
    run.AutoButtonColor = false
    run.Parent = card

    local runBg = Instance.new("Frame")
    runBg.Name = "RunBackground"
    runBg.Size = UDim2.fromScale(1,1)
    runBg.BackgroundColor3 = Color3.fromRGB(95, 8, 18)
    runBg.BorderSizePixel = 0
    runBg.ZIndex = run.ZIndex
    runBg.Parent = run
    local runCorner = Instance.new("UICorner")
    runCorner.CornerRadius = UDim.new(0, 8)
    runCorner.Parent = runBg
    addAnimatedButtonBorder(run, Themes[ThemeIndex].Accent)
    local runGradient = Instance.new("UIGradient")
    runGradient.Name = "RunWhiteDarkRedSweep"
    runGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Themes[ThemeIndex].ButtonDark),
        ColorSequenceKeypoint.new(0.40, Themes[ThemeIndex].ButtonDark),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60, Themes[ThemeIndex].ButtonDark),
        ColorSequenceKeypoint.new(1.00, Themes[ThemeIndex].ButtonDark)
    })
    runGradient.Rotation = 0
    runGradient.Offset = Vector2.new(1.15, 0)
    runGradient.Parent = runBg
    local runLabel = Instance.new("TextLabel")
    runLabel.Name = "RunLabel"
    runLabel.BackgroundTransparency = 1
    runLabel.Size = UDim2.fromScale(1,1)
    runLabel.Text = "RUN"
    runLabel.Font = Enum.Font.Gotham
    runLabel.TextSize = 10
    runLabel.TextColor3 = Color3.new(1,1,1)
    runLabel.ZIndex = run.ZIndex + 1
    runLabel.Parent = run
    task.spawn(function()
        while gui.Parent and run.Parent do
            runGradient.Offset = Vector2.new(1.15, 0)
            local tw = tween(runGradient, TweenInfo.new(2.0, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1.15, 0)})
            tw.Completed:Wait()
            task.wait(0.10)
        end
    end)


    run.Activated:Connect(function()
        execute(code, run)
    end)

    run.MouseEnter:Connect(function()
        tween(run, TweenInfo.new(0.12), {Size = UDim2.fromOffset(75, 33)})
    end)
    run.MouseLeave:Connect(function()
        tween(run, TweenInfo.new(0.12), {Size = UDim2.fromOffset(72, 31)})
    end)
end

-- ============================================================
-- VIREX ANTI-HIT
-- Replaced the old script library with the Anti-Hit feature.
-- Route logic is based on the supplied VIREX Anti-Hit source.
-- ============================================================

local ProximityPromptService = game:GetService("ProximityPromptService")

local AntiHitEnabled = false
local IsAntiHitRunning = false
local ANTI_HIT_SPEED = 0.005

local antiHitCard = Instance.new("TextButton")
antiHitCard.Name = "AntiHit"
antiHitCard.Size = UDim2.new(1, -8, 0, 76)
antiHitCard.BackgroundColor3 = Themes[ThemeIndex].ButtonDark
antiHitCard.BorderSizePixel = 0
antiHitCard.Text = ""
antiHitCard.AutoButtonColor = false
antiHitCard.Parent = scriptsPage

local antiHitCorner = Instance.new("UICorner")
antiHitCorner.CornerRadius = UDim.new(0, 11)
antiHitCorner.Parent = antiHitCard

local antiHitStroke = Instance.new("UIStroke")
antiHitStroke.Name = "AnimatedBorder"
antiHitStroke.Thickness = 1.6
antiHitStroke.Color = Themes[ThemeIndex].Accent
antiHitStroke.Transparency = 0.10
antiHitStroke.Parent = antiHitCard

local antiHitSweep = Instance.new("UIGradient")
antiHitSweep.Name = "AntiHitSweep"
antiHitSweep.Rotation = 0
antiHitSweep.Offset = Vector2.new(1.15, 0)
antiHitSweep.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 8, 18)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(105, 8, 18)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(105, 8, 18)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(105, 8, 18))
})
antiHitSweep.Parent = antiHitCard

local antiHitTitle = Instance.new("TextLabel")
antiHitTitle.BackgroundTransparency = 1
antiHitTitle.Position = UDim2.fromOffset(15, 7)
antiHitTitle.Size = UDim2.new(1, -30, 0, 32)
antiHitTitle.Text = "🛡  ANTI HIT"
antiHitTitle.Font = Enum.Font.Gotham
antiHitTitle.TextSize = 20
antiHitTitle.TextColor3 = Color3.new(1,1,1)
antiHitTitle.TextXAlignment = Enum.TextXAlignment.Left
antiHitTitle.ZIndex = antiHitCard.ZIndex + 2
antiHitTitle.Parent = antiHitCard

local antiHitStatus = Instance.new("TextLabel")
antiHitStatus.BackgroundTransparency = 1
antiHitStatus.Position = UDim2.fromOffset(16, 43)
antiHitStatus.Size = UDim2.new(1, -32, 0, 20)
antiHitStatus.Text = "OFF"
antiHitStatus.Font = Enum.Font.Gotham
antiHitStatus.TextSize = 11
antiHitStatus.TextColor3 = Color3.fromRGB(255, 170, 175)
antiHitStatus.TextXAlignment = Enum.TextXAlignment.Left
antiHitStatus.ZIndex = antiHitCard.ZIndex + 2
antiHitStatus.Parent = antiHitCard

local AntiHitPositiveSound = Instance.new("Sound")
AntiHitPositiveSound.Name = "AntiHitEnabledSound"
AntiHitPositiveSound.SoundId = "rbxassetid://6026984224"
AntiHitPositiveSound.Volume = 0.42
AntiHitPositiveSound.PlaybackSpeed = 1.25
AntiHitPositiveSound.Parent = VirexSoundFolder

local antiHitSweepToken = 0
local function startAntiHitVisual(enabled)
    antiHitSweepToken += 1
    local token = antiHitSweepToken
    antiHitSweep.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, enabled and Color3.fromRGB(35, 170, 75) or Color3.fromRGB(105, 8, 18)),
        ColorSequenceKeypoint.new(0.40, enabled and Color3.fromRGB(35, 170, 75) or Color3.fromRGB(105, 8, 18)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60, enabled and Color3.fromRGB(35, 170, 75) or Color3.fromRGB(105, 8, 18)),
        ColorSequenceKeypoint.new(1.00, enabled and Color3.fromRGB(35, 170, 75) or Color3.fromRGB(105, 8, 18))
    })
    task.spawn(function()
        while gui.Parent and antiHitCard.Parent and antiHitSweepToken == token do
            antiHitSweep.Offset = Vector2.new(1.15, 0)
            local tw = tween(antiHitSweep, TweenInfo.new(1.45, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1.15, 0)})
            tw.Completed:Wait()
        end
    end)
end

local function setAntiHitVisual(enabled)
    if enabled then
        antiHitStatus.Text = "ON"
        antiHitStatus.TextColor3 = Color3.fromRGB(110,255,145)
        antiHitCard.BackgroundColor3 = Color3.fromRGB(35,170,75)
        -- The click sound already fires immediately when the button is pressed.
        -- Do not add a second delayed sound here.
    else
        antiHitStatus.Text = "OFF"
        antiHitStatus.TextColor3 = Color3.fromRGB(255,170,175)
        antiHitCard.BackgroundColor3 = Color3.fromRGB(105,8,18)
    end
    startAntiHitVisual(enabled)
end

local TeleportPoints = {
    Vector3.new(500.62, 241.28, -366.64),
    Vector3.new(504.45, 155.80, -366.35),
    Vector3.new(508.30, 70.28, -366.03),
    Vector3.new(513.86, 70.28, -366.25),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(524.32, 70.28, -366.59),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(538.01, 70.28, -365.55),
    Vector3.new(546.80, 70.28, -364.40)
}

local function TeleportRoute(character)
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    IsAntiHitRunning = true
    for _, position in ipairs(TeleportPoints) do
        if not AntiHitEnabled or not root.Parent then
            IsAntiHitRunning = false
            return
        end
        root.CFrame = CFrame.new(position)
        task.wait(ANTI_HIT_SPEED)
    end
    IsAntiHitRunning = false
end

antiHitCard.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Sound and visual state begin on the exact press, not on release.
        VirexPlayClick(1.0, 0.30)
        AntiHitEnabled = not AntiHitEnabled
        setAntiHitVisual(AntiHitEnabled)
    end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if player ~= Player then return end
    if not AntiHitEnabled or IsAntiHitRunning then return end
    local character = Player.Character
    if not character then return end
    task.spawn(function()
        TeleportRoute(character)
    end)
end)

setAntiHitVisual(false)

-- ======================================================
-- AUTO FARM BUTTON
-- The supplied V1 source contains Anti-Hit logic only.
-- This is the requested animated Auto Farm UI control;
-- no farming routine is invented or falsely executed here.
-- ======================================================
local AutoFarmEnabled = false
local autoFarmCard = Instance.new("TextButton")
autoFarmCard.Name = "AutoFarm"
autoFarmCard.Size = UDim2.new(1,-8,0,76)
autoFarmCard.BackgroundColor3 = Themes[ThemeIndex].ButtonDark
autoFarmCard.BorderSizePixel = 0
autoFarmCard.Text = ""
autoFarmCard.AutoButtonColor = false
autoFarmCard.Parent = scriptsPage

local autoFarmCorner = Instance.new("UICorner")
autoFarmCorner.CornerRadius = UDim.new(0,11)
autoFarmCorner.Parent = autoFarmCard

local autoFarmStroke = Instance.new("UIStroke")
autoFarmStroke.Name = "AnimatedBorder"
autoFarmStroke.Thickness = 1.6
autoFarmStroke.Color = Themes[ThemeIndex].Accent
autoFarmStroke.Transparency = 0.10
autoFarmStroke.Parent = autoFarmCard

local autoFarmSweep = Instance.new("UIGradient")
autoFarmSweep.Name = "AutoFarmSweep"
autoFarmSweep.Rotation = 0
autoFarmSweep.Offset = Vector2.new(1.15,0)
autoFarmSweep.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00,Themes[ThemeIndex].ButtonDark),
    ColorSequenceKeypoint.new(0.40,Themes[ThemeIndex].ButtonDark),
    ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.60,Themes[ThemeIndex].ButtonDark),
    ColorSequenceKeypoint.new(1.00,Themes[ThemeIndex].ButtonDark)
})
autoFarmSweep.Parent = autoFarmCard

local autoFarmTitle = Instance.new("TextLabel")
autoFarmTitle.BackgroundTransparency = 1
autoFarmTitle.Position = UDim2.fromOffset(15,7)
autoFarmTitle.Size = UDim2.new(1,-30,0,32)
autoFarmTitle.Text = "⚡  AUTO FARM"
autoFarmTitle.Font = Enum.Font.Gotham
autoFarmTitle.TextSize = 20
autoFarmTitle.TextColor3 = Color3.new(1,1,1)
autoFarmTitle.TextXAlignment = Enum.TextXAlignment.Left
autoFarmTitle.ZIndex = autoFarmCard.ZIndex + 2
autoFarmTitle.Parent = autoFarmCard

local autoFarmStatus = Instance.new("TextLabel")
autoFarmStatus.BackgroundTransparency = 1
autoFarmStatus.Position = UDim2.fromOffset(16,43)
autoFarmStatus.Size = UDim2.new(1,-32,0,20)
autoFarmStatus.Text = "OFF • UI READY"
autoFarmStatus.Font = Enum.Font.Gotham
autoFarmStatus.TextSize = 11
autoFarmStatus.TextColor3 = Color3.fromRGB(255,170,175)
autoFarmStatus.TextXAlignment = Enum.TextXAlignment.Left
autoFarmStatus.ZIndex = autoFarmCard.ZIndex + 2
autoFarmStatus.Parent = autoFarmCard

local autoFarmSweepToken = 0
local function setAutoFarmVisual(enabled)
    AutoFarmEnabled = enabled
    autoFarmSweepToken += 1
    local token = autoFarmSweepToken
    local base = enabled and Color3.fromRGB(35,170,75) or Themes[ThemeIndex].ButtonDark
    autoFarmCard.BackgroundColor3 = base
    autoFarmStatus.Text = enabled and "ON • UI READY" or "OFF • UI READY"
    autoFarmStatus.TextColor3 = enabled and Color3.fromRGB(110,255,145) or Color3.fromRGB(255,170,175)
    autoFarmSweep.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00,base),
        ColorSequenceKeypoint.new(0.40,base),
        ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60,base),
        ColorSequenceKeypoint.new(1.00,base)
    })
    task.spawn(function()
        while gui.Parent and autoFarmCard.Parent and autoFarmSweepToken == token do
            autoFarmSweep.Offset = Vector2.new(1.15,0)
            local t = tween(autoFarmSweep,TweenInfo.new(1.45,Enum.EasingStyle.Linear),{Offset=Vector2.new(-1.15,0)})
            t.Completed:Wait()
        end
    end)
end

autoFarmCard.Activated:Connect(function()
    VirexPlayClick()
    setAutoFarmVisual(not AutoFarmEnabled)
end)
setAutoFarmVisual(false)

local function cardPressAnimation(card)
    local original = card.Size
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tween(card,TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(original.X.Scale,original.X.Offset-4,original.Y.Scale,original.Y.Offset-3)})
        end
    end)
    card.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tween(card,TweenInfo.new(0.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=original})
        end
    end)
end
cardPressAnimation(antiHitCard)
cardPressAnimation(autoFarmCard)

local function configLabel(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 25)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextColor3 = Color3.fromRGB(190,190,200)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = configPage
    return l
end

local function configButton(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(13, 27, 46)
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.TextColor3 = Color3.new(1,1,1)
    b.AutoButtonColor = false
    b.Parent = configPage
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = b
    addAnimatedButtonBorder(b, Themes[ThemeIndex].Accent)
    return b
end

configLabel("GUI SIZE • 1 — 20")

local sizeSlider = Instance.new("Frame")
sizeSlider.Name = "UISizeSlider"
sizeSlider.Size = UDim2.new(1, -8, 0, 58)
sizeSlider.BackgroundColor3 = Color3.fromRGB(13,27,46)
sizeSlider.BorderSizePixel = 0
sizeSlider.Parent = configPage
local sizeSliderCorner = Instance.new("UICorner")
sizeSliderCorner.CornerRadius = UDim.new(0, 10)
sizeSliderCorner.Parent = sizeSlider
local sizeSliderStroke = addAnimatedButtonBorder(sizeSlider, Themes[ThemeIndex].Accent)

local sizeTrack = Instance.new("Frame")
sizeTrack.AnchorPoint = Vector2.new(0,0.5)
sizeTrack.Position = UDim2.new(0,14,0.5,8)
sizeTrack.Size = UDim2.new(1,-28,0,5)
sizeTrack.BackgroundColor3 = Color3.fromRGB(45,50,62)
sizeTrack.BorderSizePixel = 0
sizeTrack.Parent = sizeSlider
local sizeTrackCorner = Instance.new("UICorner")
sizeTrackCorner.CornerRadius = UDim.new(1,0)
sizeTrackCorner.Parent = sizeTrack

local sizeFill = Instance.new("Frame")
sizeFill.Size = UDim2.new(0.47,0,1,0)
sizeFill.BackgroundColor3 = Themes[ThemeIndex].Accent
sizeFill.BorderSizePixel = 0
sizeFill.Parent = sizeTrack
local sizeFillCorner = Instance.new("UICorner")
sizeFillCorner.CornerRadius = UDim.new(1,0)
sizeFillCorner.Parent = sizeFill

local sizeKnob = Instance.new("TextButton")
sizeKnob.AnchorPoint = Vector2.new(0.5,0.5)
sizeKnob.Position = UDim2.new(0.47,0,0.5,8)
sizeKnob.Size = UDim2.fromOffset(18,18)
sizeKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
sizeKnob.BorderSizePixel = 0
sizeKnob.Text = ""
sizeKnob.AutoButtonColor = false
sizeKnob.Parent = sizeSlider
local sizeKnobCorner = Instance.new("UICorner")
sizeKnobCorner.CornerRadius = UDim.new(1,0)
sizeKnobCorner.Parent = sizeKnob

local sizeValue = Instance.new("TextLabel")
sizeValue.BackgroundTransparency = 1
sizeValue.Position = UDim2.fromOffset(14,5)
sizeValue.Size = UDim2.new(1,-28,0,20)
sizeValue.Text = "SIZE 10 / 20"
sizeValue.Font = Enum.Font.Gotham
sizeValue.TextSize = 11
sizeValue.TextColor3 = Color3.new(1,1,1)
sizeValue.TextXAlignment = Enum.TextXAlignment.Left
sizeValue.Parent = sizeSlider

local sizeLevel = 10
local sizeDragging = false
local function applySizeLevel(level, playSound)
    sizeLevel = math.clamp(math.floor(level + 0.5), 1, 20)
    sizeValue.Text = "SIZE " .. tostring(sizeLevel) .. " / 20"
    local alpha = (sizeLevel - 1) / 19
    sizeFill.Size = UDim2.new(alpha,0,1,0)
    sizeKnob.Position = UDim2.new(alpha,0,0.5,8)
    local width = math.floor(300 + alpha * 180)
    local height = math.floor(235 + alpha * 120)
    local target = UDim2.fromOffset(width,height)
    tween(main,TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=target})
    tween(shadow,TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=target})
    task.defer(updateDragHandlePosition)
    if playSound then VirexPlayClick(1.05,0.24) end
end

local function setSliderFromInput(input)
    local x = input.Position.X
    local left = sizeTrack.AbsolutePosition.X
    local width = math.max(1,sizeTrack.AbsoluteSize.X)
    local alpha = math.clamp((x-left)/width,0,1)
    applySizeLevel(1 + alpha*19, true)
end
sizeKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sizeDragging = true
    end
end)
sizeSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        setSliderFromInput(input)
        sizeDragging = true
    end
end)
UIS.InputChanged:Connect(function(input)
    if sizeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        setSliderFromInput(input)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sizeDragging = false
    end
end)
applySizeLevel(10, false)

configLabel("COLOR")

local colorButton = configButton("Choose Color • Virex Red")

local colorPopup = Instance.new("Frame")
colorPopup.Name = "ColorPicker"
colorPopup.Size = UDim2.new(1, -8, 0, 0)
colorPopup.BackgroundTransparency = 1
colorPopup.ClipsDescendants = true
colorPopup.Parent = configPage

local colorGrid = Instance.new("UIGridLayout")
colorGrid.CellSize = UDim2.new(0.48, -4, 0, 34)
colorGrid.CellPadding = UDim2.new(0.02, 0, 0, 6)
colorGrid.SortOrder = Enum.SortOrder.LayoutOrder
colorGrid.Parent = colorPopup

local function applyTheme(index)
    ThemeIndex = index
    local th = Themes[ThemeIndex]
    colorButton.Text = "Choose Color • " .. th.Name
    -- Keep the VIREX title's own animated red/lilac sweep; theme changes do not reset it.
    tween(main, TweenInfo.new(0.2), {BackgroundColor3 = th.Main})
    tween(stroke, TweenInfo.new(0.2), {Color = th.Accent})
    mainBgSweep.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, th.Main),
        ColorSequenceKeypoint.new(0.40, th.Main),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.60, th.Main),
        ColorSequenceKeypoint.new(1.00, th.Main)
    })
    dragVisual.BackgroundColor3 = th.Accent
    resizeHandle.TextColor3 = th.Accent
    openStroke.Color = th.Accent
    topLogo.ImageColor3 = Color3.fromRGB(255,255,255)
    antiHitStroke.Color = th.Accent
    autoFarmStroke.Color = th.Accent
    sizeSlider.BackgroundColor3 = th.Panel
    sizeSliderStroke.Color = th.Accent
    sizeFill.BackgroundColor3 = th.Accent
    notificationBar.BackgroundColor3 = th.Accent
    notificationStroke.Color = th.Accent
    openStroke.Color = Color3.fromRGB(255,255,255)
    openButton.ImageColor3 = Color3.fromRGB(255,255,255)
    sidebar.BackgroundColor3 = th.Main
    for _, b in pairs(tabButtons) do
        if b then
            b.BackgroundColor3 = th.Panel
            local sweepBg = b:FindFirstChild("SelectedDarkBlueWhiteSweep")
            if sweepBg then
                sweepBg.BackgroundColor3 = th.Accent
                local sweep = sweepBg:FindFirstChildOfClass("UIGradient")
                if sweep then
                    sweep.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, th.Accent),
                        ColorSequenceKeypoint.new(0.40, th.Accent),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                        ColorSequenceKeypoint.new(0.60, th.Accent),
                        ColorSequenceKeypoint.new(1.00, th.Accent)
                    })
                end
            end
        end
    end
    if antiHitCard and antiHitCard.Parent then
        local antiStroke = antiHitCard:FindFirstChild("AnimatedBorder")
        if antiStroke then antiStroke.Color = th.Accent end
    end
    if autoFarmCard and autoFarmCard.Parent then
        local farmStroke = autoFarmCard:FindFirstChild("AnimatedBorder")
        if farmStroke then farmStroke.Color = th.Accent end
        if not AutoFarmEnabled then
            autoFarmCard.BackgroundColor3 = th.ButtonDark
            autoFarmSweep.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, th.ButtonDark),
                ColorSequenceKeypoint.new(0.40, th.ButtonDark),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(0.60, th.ButtonDark),
                ColorSequenceKeypoint.new(1.00, th.ButtonDark)
            })
        end
    end
    for _, page in pairs(pages) do
        page.ScrollBarImageColor3 = th.Accent
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundColor3 = th.Panel
                local run = child:FindFirstChild("RUN")
                if run then
                    local runBg = run:FindFirstChild("RunBackground")
                    if runBg then
                        runBg.BackgroundColor3 = th.ButtonDark
                        local rg = runBg:FindFirstChild("RunWhiteDarkRedSweep")
                        if rg then
                            rg.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, th.ButtonDark),
                                ColorSequenceKeypoint.new(0.40, th.ButtonDark),
                                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                                ColorSequenceKeypoint.new(0.60, th.ButtonDark),
                                ColorSequenceKeypoint.new(1.00, th.ButtonDark)
                            })
                        end
                    end
                end
            elseif child:IsA("TextButton") and child.Name ~= "RUN" then
                -- Config/action buttons follow the selected theme too.
                child.BackgroundColor3 = th.Panel
                child.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end
    for _, d in ipairs(gui:GetDescendants()) do
        if d:IsA("UIStroke") and d.Name == "VirexButtonBorder" then
            d.Color = th.Accent
            local g = d:FindFirstChild("VirexButtonBorderGradient")
            if g then
                g.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, th.Accent),
                    ColorSequenceKeypoint.new(0.40, th.Accent),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.60, th.Accent),
                    ColorSequenceKeypoint.new(1.00, th.Accent)
                })
            end
        end
    end
    refreshTabs()
end

for i, th in ipairs(Themes) do
    local b = Instance.new("TextButton")
    b.Name = th.Name
    b.Text = th.Name
    b.Font = Enum.Font.Gotham
    b.TextSize = 10
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = th.Accent
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = colorPopup
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = b
    addAnimatedButtonBorder(b, th.Accent)
    b.Activated:Connect(function()
        VirexPlayClick()
        applyTheme(i)
        tween(colorPopup, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -8, 0, 0)})
    end)
end

local colorsOpen = false
colorButton.Activated:Connect(function()
    VirexPlayClick()
    colorsOpen = not colorsOpen
    local h = colorsOpen and 5 * 34 + 4 * 6 or 0
    tween(colorPopup, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -8, 0, h)})
end)

configLabel("WINDOW")

local closeInfo = configButton("Close / Reopen: X or the Virex button")
closeInfo.TextColor3 = Color3.fromRGB(145,145,155)

local dragging = false
local dragStart
local startPos
local dragSource

local function beginDrag(input, source)
    dragging = true
    dragSource = source
    dragStart = input.Position
    startPos = main.Position
    if source == dragHandle then
        tween(dragHandle, TweenInfo.new(0.10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(136, 22),
            BackgroundTransparency = 1
        })
        tween(dragVisual, TweenInfo.new(0.10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(108, 6),
            BackgroundTransparency = 0
        })
    end
end

local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local halfW = main.AbsoluteSize.X * 0.5
    local halfH = main.AbsoluteSize.Y * 0.5
    local minX = -viewport.X * 0.5 + halfW + 4
    local maxX = viewport.X * 0.5 - halfW - 4
    local minY = -viewport.Y * 0.5 + halfH + 4
    local maxY = viewport.Y * 0.5 - halfH - 4
    local ox = math.clamp(startPos.X.Offset + delta.X, minX, maxX)
    local oy = math.clamp(startPos.Y.Offset + delta.Y, minY, maxY)
    local newPos = UDim2.new(0.5, ox, 0.5, oy)
    main.Position = newPos
    shadow.Position = newPos
    updateDragHandlePosition()
    if notification and notification.Visible then
        updateNotificationPosition()
    end
end

local function endDrag(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging = false
    if dragSource == dragHandle then
        tween(dragHandle, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(110, 16),
            BackgroundTransparency = 1
        })
        tween(dragVisual, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(76, 3),
            BackgroundTransparency = 0.10
        })
    end
    dragSource = nil
end

-- The bottom line is the dedicated drag area.
dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input, dragHandle)
    end
end)

-- Mobile drag follows the finger 1:1; no snapping or automatic repositioning while dragging.
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateDrag(input)
    end
end)

-- Drag the outside ↘ handle to resize the GUI with a finger/mouse.
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        resizeDragging = true
        VirexPlayClick()
        resizeStartInput = input.Position
        resizeStartSize = main.Size
    end
end)

local function updateResize(input)
    if not resizeDragging then return end
    local delta = input.Position - resizeStartInput
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920,1080)
    local centerX = main.AbsolutePosition.X + main.AbsoluteSize.X * 0.5
    local centerY = main.AbsolutePosition.Y + main.AbsoluteSize.Y * 0.5
    local maxW = math.max(300, math.min(540, 2 * math.min(centerX - 8, viewport.X - centerX - 8)))
    local maxH = math.max(230, math.min(430, 2 * math.min(centerY - 8, viewport.Y - centerY - 8)))
    local w = math.clamp(resizeStartSize.X.Offset + delta.X * 2, 300, maxW)
    local h = math.clamp(resizeStartSize.Y.Offset + delta.Y * 2, 230, maxH)
    -- LOCKED: resizing changes only size. The GUI never moves while this handle is held.
    main.Size = UDim2.fromOffset(w, h)
    shadow.Size = UDim2.fromOffset(w, h)
    updateFloatingControls()
end

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
        updateResize(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    endDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizeDragging = false
    end
end)

-- Floating VIREX logo shown after minimizing/closing.
local openButton = Instance.new("ImageButton")
openButton.Name = "OpenVirex"
openButton.AnchorPoint = Vector2.new(1,0.5)
openButton.Position = UDim2.new(1,-18,0.5,0)
openButton.Size = UDim2.fromOffset(64,64)
openButton.BackgroundColor3 = Color3.fromRGB(6,10,18)
openButton.BorderSizePixel = 0
openButton.Image = VIREX_LOGO_ASSET
openButton.ScaleType = Enum.ScaleType.Fit
openButton.AutoButtonColor = false
openButton.Visible = false
openButton.ZIndex = 85
openButton.ClipsDescendants = true
openButton.Parent = gui

local oc = Instance.new("UICorner")
oc.CornerRadius = UDim.new(0,14)
oc.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Thickness = 2
openStroke.Color = Color3.fromRGB(255,72,72)
openStroke.Transparency = 0.08
openStroke.Parent = openButton

local openInnerStroke = Instance.new("UIStroke")
openInnerStroke.Thickness = 1
openInnerStroke.Color = Color3.fromRGB(255,255,255)
openInnerStroke.Transparency = 0.72
openInnerStroke.Parent = openButton

local openShine = Instance.new("Frame")
openShine.Name = "WhiteShine"
openShine.AnchorPoint = Vector2.new(0.5,0.5)
openShine.Position = UDim2.fromScale(1.3,0.5)
openShine.Size = UDim2.new(0.20,0,1.5,0)
openShine.BackgroundColor3 = Color3.fromRGB(255,255,255)
openShine.BackgroundTransparency = 0.62
openShine.BorderSizePixel = 0
openShine.Rotation = 12
openShine.ZIndex = 86
openShine.Parent = openButton

local openShineGradient = Instance.new("UIGradient")
openShineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.44,1),
    NumberSequenceKeypoint.new(0.50,0.04),
    NumberSequenceKeypoint.new(0.56,1),
    NumberSequenceKeypoint.new(1,1)
})
openShineGradient.Parent = openShine

task.spawn(function()
    while gui.Parent and openButton.Parent do
        openShine.Position = UDim2.fromScale(1.3,0.5)
        local t = tween(openShine,TweenInfo.new(1.25,Enum.EasingStyle.Linear),{Position=UDim2.fromScale(-0.3,0.5)})
        t.Completed:Wait()
        task.wait(0.28)
    end
end)

local mainScale = Instance.new("UIScale")
mainScale.Scale = 1
mainScale.Parent = main

local shadowScale = Instance.new("UIScale")
shadowScale.Scale = 1
shadowScale.Parent = shadow

local function closeGui()
    if not main.Visible then return end
    local outInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local savedClosePosition = main.Position
    local leftExitPosition = UDim2.new(
        savedClosePosition.X.Scale, savedClosePosition.X.Offset - 42,
        savedClosePosition.Y.Scale, savedClosePosition.Y.Offset
    )
    local closeW = math.max(320, main.Size.X.Offset)
    local closeH = math.max(245, main.Size.Y.Offset)
    tween(mainScale, outInfo, {Scale = 0.94})
    tween(shadowScale, outInfo, {Scale = 0.94})
    tween(main, outInfo, {BackgroundTransparency = 1, Position = leftExitPosition, Size = UDim2.fromOffset(closeW, closeH)})
    tween(shadow, outInfo, {BackgroundTransparency = 1, Position = leftExitPosition, Size = UDim2.fromOffset(closeW, closeH)})
    task.wait(0.33)
    main.Visible = false
    shadow.Visible = false
    dragHandle.Visible = false
    resizeHandle.Visible = false
    if notification then notification.Visible = false end
    -- Ensure no transparent black layer remains after closing.
    main.BackgroundTransparency = 1
    shadow.BackgroundTransparency = 1
    main.Size = Sizes[SizeIndex]
    shadow.Size = Sizes[SizeIndex]
    main.Position = savedClosePosition
    shadow.Position = savedClosePosition
    mainScale.Scale = 1
    shadowScale.Scale = 1
    updateFloatingControls()
    openButton.Visible = true
    updateDragHandlePosition()
    tween(openButton, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(64,64)
    })
end

local function openGui()
    openButton.Visible = false
    main.Visible = true
    shadow.Visible = true
    mainScale.Scale = 0.72
    shadowScale.Scale = 0.72
    main.BackgroundTransparency = 0
    shadow.BackgroundTransparency = 0.45
    dragHandle.Visible = true
    resizeHandle.Visible = true
    updateFloatingControls()
    tween(mainScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
    tween(shadowScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
end

local minimized = false
local savedSize = main.Size

close.Activated:Connect(function() VirexPlayClick(); closeGui() end)
local vxDragging = false
local vxDragStart
local vxStartPos
openButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        vxDragging = true
        vxDragStart = input.Position
        vxStartPos = openButton.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if vxDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - vxDragStart
        openButton.Position = UDim2.new(vxStartPos.X.Scale, vxStartPos.X.Offset + d.X, vxStartPos.Y.Scale, vxStartPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        vxDragging = false
    end
end)

openButton.Activated:Connect(function()
    VirexPlayClick()
    if minimized then
        minimized = false
        openButton.Visible = false
        main.Visible = true
        shadow.Visible = true
        sidebar.Visible = true
        content.Visible = true
        resizeHandle.Visible = true
        dragHandle.Visible = true
            main.Size = UDim2.fromOffset(190,45)
        shadow.Size = UDim2.fromOffset(190,45)
        mainScale.Scale = 0.72
        shadowScale.Scale = 0.72
        main.BackgroundTransparency = 0
        shadow.BackgroundTransparency = 0.45
        tween(main, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = savedSize})
        tween(shadow, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = savedSize})
        tween(mainScale, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        tween(shadowScale, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        task.delay(0.31, updateDragHandlePosition)
    else
        openGui()
    end
end)

RunService.RenderStepped:Connect(function()
    if gui.Parent and (main.Visible or dragHandle.Visible or resizeHandle.Visible) then
        updateFloatingControls()
    end
end)

minimize.Activated:Connect(function()
    VirexPlayClick()
    if minimized then
        minimized = false
        openButton.Visible = false
        main.Visible = true
        shadow.Visible = true
        sidebar.Visible = true
        content.Visible = true
        resizeHandle.Visible = true
        dragHandle.Visible = true
            main.Size = UDim2.fromOffset(190,45)
        shadow.Size = UDim2.fromOffset(190,45)
        mainScale.Scale = 0.72
        shadowScale.Scale = 0.72
        main.BackgroundTransparency = 0
        shadow.BackgroundTransparency = 0.45
        tween(main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = savedSize})
        tween(shadow, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = savedSize})
        tween(mainScale, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        tween(shadowScale, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        task.delay(0.31, updateDragHandlePosition)
    else
        minimized = true
        savedSize = main.Size
        sidebar.Visible = false
        content.Visible = false
        resizeHandle.Visible = false
        dragHandle.Visible = false
            local miniInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(mainScale, miniInfo, {Scale = 0.78})
        tween(shadowScale, miniInfo, {Scale = 0.78})
        tween(main, miniInfo, {BackgroundTransparency = 1, Size = UDim2.fromOffset(1,1)})
        tween(shadow, miniInfo, {BackgroundTransparency = 1, Size = UDim2.fromOffset(1,1)})
        task.wait(0.25)
        main.Visible = false
        shadow.Visible = false
        main.Size = savedSize
        shadow.Size = savedSize
        mainScale.Scale = 1
        shadowScale.Scale = 1
        openButton.Visible = true
        openButton.Size = UDim2.fromOffset(8,8)
        tween(openButton, TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(64,64)})
    end
end)

-- Sound is intentionally NOT globally bound. Each real button/option below fires one sound once.
refreshTabs()

-- ======================================================
-- MOBILE-STYLE SUPPORT NOTIFICATION
-- Appears above VIREX after the intro and slides away smoothly.
-- ======================================================
local notification = Instance.new("Frame")
notification.Name = "SupportNotification"
notification.AnchorPoint = Vector2.new(0.5, 0.5)
notification.Size = UDim2.fromOffset(270, 48)
notification.BackgroundColor3 = Color3.fromRGB(18,18,23)
notification.BackgroundTransparency = 1
notification.BorderSizePixel = 0
notification.ZIndex = 90
notification.Visible = false
notification.Parent = gui
local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 14)
notificationCorner.Parent = notification
local notificationStroke = Instance.new("UIStroke")
notificationStroke.Thickness = 1
notificationStroke.Transparency = 1
notificationStroke.Color = Themes[ThemeIndex].Accent
notificationStroke.Parent = notification
local notificationBar = Instance.new("Frame")
notificationBar.Size = UDim2.new(0, 3, 0.58, 0)
notificationBar.Position = UDim2.new(0, 8, 0.21, 0)
notificationBar.BackgroundColor3 = Themes[ThemeIndex].Accent
notificationBar.BorderSizePixel = 0
notificationBar.ZIndex = 91
notificationBar.Parent = notification
local notificationBarCorner = Instance.new("UICorner")
notificationBarCorner.CornerRadius = UDim.new(1,0)
notificationBarCorner.Parent = notificationBar
local notificationText = Instance.new("TextLabel")
notificationText.BackgroundTransparency = 1
notificationText.Position = UDim2.fromOffset(20, 0)
notificationText.Size = UDim2.new(1, -30, 1, 0)
notificationText.Font = Enum.Font.Gotham
notificationText.Text = "Thanks for all support guys :)"
notificationText.TextSize = 12
notificationText.TextColor3 = Color3.new(1,1,1)
notificationText.TextTransparency = 1
notificationText.TextXAlignment = Enum.TextXAlignment.Left
notificationText.ZIndex = 91
notificationText.Parent = notification

-- Support message: green -> white -> green -> white, continuously.
local notificationGradient = Instance.new("UIGradient")
notificationGradient.Rotation = 0
notificationGradient.Offset = Vector2.new(1.1, 0)
notificationGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 255, 120)),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(70, 255, 120)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(70, 255, 120)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 255, 120))
})
notificationGradient.Parent = notificationText

task.spawn(function()
    while gui.Parent and notificationText.Parent do
        notificationGradient.Offset = Vector2.new(1.1, 0)
        local t = tween(notificationGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
            Offset = Vector2.new(-1.1, 0)
        })
        t.Completed:Wait()
    end
end)

function updateNotificationPosition()
    if not notification then return end
    local y = math.floor(-(main.Size.Y.Offset * 0.5) - 38)
    notification.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset + y)
end

function showSupportNotification()
    updateNotificationPosition()
    notification.Visible = true
    -- One sound exactly when the notification becomes visible.
    pcall(function() VirexPlaySound("click", 1.0, 0.30) end)
    notification.BackgroundTransparency = 1
    notificationText.TextTransparency = 1
    notificationStroke.Transparency = 1
    local startY = notification.Position.Y.Offset - 18
    local endY = notification.Position.Y.Offset
    notification.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, startY)
    tween(notification, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, endY),
        BackgroundTransparency = 0.08
    })
    tween(notificationText, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0})
    tween(notificationStroke, TweenInfo.new(0.20), {Transparency = 0.45})
    task.delay(2.6, function()
        if not notification or not notification.Parent or not notification.Visible then return end
        local outY = notification.Position.Y.Offset - 14
        tween(notification, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, outY),
            BackgroundTransparency = 1
        })
        tween(notificationText, TweenInfo.new(0.18), {TextTransparency = 1})
        tween(notificationStroke, TweenInfo.new(0.18), {Transparency = 1})
        task.wait(0.27)
        if notification then notification.Visible = false end
    end)
end

-- ======================================================
-- ONE-SCREEN INTRO -> MAIN GUI HANDOFF
-- The intro and VIREX hub use the SAME ScreenGui, so the
-- ======================================================
-- ======================================================
-- VIREX HUB • CINEMATIC 5 SECOND INTRO
-- Three separate words enter from different directions and
-- converge into the final WELCOME TO VIREX composition.
-- ======================================================
main.Visible = false
shadow.Visible = false
dragHandle.Visible = false
resizeHandle.Visible = false
notification.Visible = false

local Lighting = game:GetService("Lighting")
local introBlur = Instance.new("BlurEffect")
introBlur.Name = "VirexIntroBlur"
introBlur.Size = 0
introBlur.Parent = Lighting

tween(introBlur, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 18})

local intro = Instance.new("Frame")
intro.Name = "VirexIntro"
intro.Size = UDim2.fromScale(1,1)
intro.BackgroundColor3 = Color3.fromRGB(3,5,9)
intro.BackgroundTransparency = 0.38
intro.BorderSizePixel = 0
intro.ZIndex = 100
intro.Parent = gui

local introShade = Instance.new("Frame")
introShade.Size = UDim2.fromScale(1,1)
introShade.BackgroundColor3 = Color3.fromRGB(0,0,0)
introShade.BackgroundTransparency = 0.34
introShade.BorderSizePixel = 0
introShade.ZIndex = 101
introShade.Parent = intro

local introCard = Instance.new("Frame")
introCard.Name = "CinematicIntro"
introCard.AnchorPoint = Vector2.new(0.5,0.5)
introCard.Position = UDim2.fromScale(0.5,0.5)
introCard.Size = UDim2.fromOffset(390,190)
introCard.BackgroundTransparency = 1
introCard.BorderSizePixel = 0
introCard.ZIndex = 102
introCard.Parent = intro

local function introText(name, text, size)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.AnchorPoint = Vector2.new(0.5,0.5)
    label.Size = UDim2.fromOffset(360,size + 12)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = size
    label.TextColor3 = Color3.fromRGB(245,245,248)
    label.TextStrokeTransparency = 1
    label.ZIndex = 103
    label.Parent = introCard
    return label
end

local welcome = introText("Welcome", "WELCOME", 38)
local toWord = introText("To", "TO", 22)
local virex = introText("Virex", "VIREX", 44)

-- Start positions: WELCOME from right, TO from below, VIREX from above.
welcome.Position = UDim2.new(0.5, 420, 0.50, 0)
toWord.Position = UDim2.new(0.5, 0, 0.50, 210)
virex.Position = UDim2.new(0.5, 0, 0.50, -210)
welcome.TextTransparency = 1
toWord.TextTransparency = 1
virex.TextTransparency = 1

local finalWelcome = UDim2.new(0.5,0,0.39,0)
local finalTo = UDim2.new(0.5,0,0.52,0)
local finalVirex = UDim2.new(0.5,0,0.67,0)

-- Red VIREX, neutral WELCOME/TO, with no text stroke.
virex.TextColor3 = Color3.fromRGB(235,35,50)
welcome.TextColor3 = Color3.fromRGB(245,245,248)
toWord.TextColor3 = Color3.fromRGB(170,175,188)

local introLogo = Instance.new("ImageLabel")
introLogo.Name = "LoadingLogo"
introLogo.AnchorPoint = Vector2.new(0.5,0.5)
introLogo.Position = UDim2.new(0.5,0,0.22,0)
introLogo.Size = UDim2.fromOffset(38,38)
introLogo.BackgroundTransparency = 1
introLogo.Image = VIREX_LOGO_ASSET
introLogo.ScaleType = Enum.ScaleType.Fit
introLogo.ImageTransparency = 1
introLogo.ZIndex = 103
introLogo.Parent = introCard

-- Thin cinematic divider under the finished title.
local divider = Instance.new("Frame")
divider.AnchorPoint = Vector2.new(0.5,0.5)
divider.Position = UDim2.new(0.5,0,0.79,0)
divider.Size = UDim2.fromOffset(0,1)
divider.BackgroundColor3 = Color3.fromRGB(235,35,50)
divider.BorderSizePixel = 0
divider.ZIndex = 103
divider.Parent = introCard

local progressText = Instance.new("TextLabel")
progressText.AnchorPoint = Vector2.new(0.5,0.5)
progressText.Position = UDim2.new(0.5,0,0.88,0)
progressText.Size = UDim2.fromOffset(260,18)
progressText.BackgroundTransparency = 1
progressText.Text = "VIREX HUB"
progressText.Font = Enum.Font.Gotham
progressText.TextSize = 10
progressText.TextColor3 = Color3.fromRGB(130,136,150)
progressText.TextTransparency = 1
progressText.ZIndex = 103
progressText.Parent = introCard

local introFinished = false

-- 5-second choreography: each word gets its own entrance, then settles.
task.spawn(function()
    local info1 = TweenInfo.new(0.85, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local info2 = TweenInfo.new(0.85, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local info3 = TweenInfo.new(0.85, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    task.wait(0.15)
    tween(virex, info1, {Position = UDim2.new(0.5,0,0.50,0), TextTransparency = 0})
    task.wait(0.75)
    tween(welcome, info2, {Position = UDim2.new(0.5,0,0.50,0), TextTransparency = 0})
    task.wait(0.55)
    tween(toWord, info3, {Position = UDim2.new(0.5,0,0.50,0), TextTransparency = 0})
    task.wait(0.70)

    -- The three words now move into their final readable composition.
    tween(virex, TweenInfo.new(0.70,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Position = finalVirex})
    tween(welcome, TweenInfo.new(0.70,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Position = finalWelcome})
    tween(toWord, TweenInfo.new(0.70,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Position = finalTo})
    tween(introLogo, TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {ImageTransparency = 0})
    tween(divider, TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {Size = UDim2.fromOffset(190,1)})
    tween(progressText, TweenInfo.new(0.35), {TextTransparency = 0})

    -- Hold long enough for the complete composition to be clearly visible.
    task.wait(1.10)
    introFinished = true

    -- Soft focus release and cinematic exit.
    tween(introBlur, TweenInfo.new(0.55,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {Size = 0})
    tween(introShade, TweenInfo.new(0.55,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    tween(welcome, TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.In), {TextTransparency = 1})
    tween(toWord, TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.In), {TextTransparency = 1})
    tween(virex, TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.In), {TextTransparency = 1})
    tween(introLogo, TweenInfo.new(0.35), {ImageTransparency = 1})
    tween(divider, TweenInfo.new(0.35), {BackgroundTransparency = 1})
    tween(progressText, TweenInfo.new(0.30), {TextTransparency = 1})
    task.wait(0.50)

    if intro.Parent then intro:Destroy() end
    if introBlur.Parent then introBlur:Destroy() end

    main.Visible = true
    shadow.Visible = true
    mainScale.Scale = 0.86
    shadowScale.Scale = 0.86
    main.BackgroundTransparency = 0
    shadow.BackgroundTransparency = 0.45
    tween(mainScale,TweenInfo.new(0.60,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1})
    tween(shadowScale,TweenInfo.new(0.60,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1})
    task.wait(0.42)
    updateDragHandlePosition()
    dragHandle.Visible = true
    resizeHandle.Visible = true
    task.wait(0.08)
    showSupportNotification()
end)

-- ======================================================
-- AUTO FARM MOVEMENT
-- Speed 100 + slight lift while enabled. Restores the
-- player's original speed when disabled.
-- ======================================================
local AutoFarmOriginalSpeed = nil
local AutoFarmMoveToken = 0
local function startAutoFarmMovement()
    AutoFarmMoveToken += 1
    local token = AutoFarmMoveToken
    task.spawn(function()
        while AutoFarmEnabled and token == AutoFarmMoveToken do
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid and root then
                if AutoFarmOriginalSpeed == nil then
                    AutoFarmOriginalSpeed = humanoid.WalkSpeed
                end
                humanoid.WalkSpeed = 100
                local v = root.AssemblyLinearVelocity
                if v.Y < 2.5 then
                    root.AssemblyLinearVelocity = Vector3.new(v.X,2.5,v.Z)
                end
            end
            task.wait(0.08)
        end
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and AutoFarmOriginalSpeed then
            humanoid.WalkSpeed = AutoFarmOriginalSpeed
        end
        AutoFarmOriginalSpeed = nil
    end)
end

local previousSetAutoFarmVisual = setAutoFarmVisual
setAutoFarmVisual = function(enabled)
    previousSetAutoFarmVisual(enabled)
    if enabled then
        startAutoFarmMovement()
    else
        AutoFarmMoveToken += 1
    end
end

-- ======================================================
-- ANTI-HIT • EGG ACTIVATION SCREEN
-- Triggered when the player is carrying an egg after using
-- the Steal Egg prompt. The protection screen lasts 3 sec.
-- ======================================================
local antiHitActivationBusy = false
local pendingStealPrompt = false

local function isEggTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name or "")
    return string.find(n,"egg",1,true) ~= nil
        or string.find(n,"huevo",1,true) ~= nil
end

local function getEquippedEgg(character)
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if isEggTool(child) then
            return child
        end
    end
    return nil
end

local function showAntiHitEggActivation()
    if antiHitActivationBusy or not AntiHitEnabled then return end
    antiHitActivationBusy = true

    local overlay = Instance.new("ScreenGui")
    overlay.Name = "VirexAntiHitActivation"
    overlay.IgnoreGuiInset = true
    overlay.ResetOnSpawn = false
    overlay.DisplayOrder = 999
    overlay.Parent = PlayerGui

    local black = Instance.new("Frame")
    black.Size = UDim2.fromScale(1,1)
    black.BackgroundColor3 = Color3.fromRGB(0,0,0)
    black.BorderSizePixel = 0
    black.Parent = overlay

    local logo = Instance.new("ImageLabel")
    logo.AnchorPoint = Vector2.new(0.5,0.5)
    logo.Position = UDim2.fromScale(0.5,0.32)
    logo.Size = UDim2.fromOffset(58,58)
    logo.BackgroundTransparency = 1
    logo.Image = VIREX_LOGO_ASSET
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ImageTransparency = 1
    logo.Parent = black

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5,0.5)
    title.Position = UDim2.fromScale(0.5,0.47)
    title.Size = UDim2.fromOffset(280,40)
    title.BackgroundTransparency = 1
    title.Text = "VIREX"
    title.Font = Enum.Font.Gotham
    title.TextSize = 32
    title.TextColor3 = Color3.fromRGB(235,35,50)
    title.TextStrokeTransparency = 1
    title.Parent = black

    local titleShine = Instance.new("UIGradient")
    titleShine.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(235,35,50)),
        ColorSequenceKeypoint.new(0.43,Color3.fromRGB(235,35,50)),
        ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.57,Color3.fromRGB(235,35,50)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(235,35,50))
    })
    titleShine.Offset = Vector2.new(1.15,0)
    titleShine.Parent = title

    local status = Instance.new("TextLabel")
    status.AnchorPoint = Vector2.new(0.5,0.5)
    status.Position = UDim2.fromScale(0.5,0.57)
    status.Size = UDim2.fromOffset(360,20)
    status.BackgroundTransparency = 1
    status.Text = "PROTECTING YOUR EGG"
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextColor3 = Color3.fromRGB(165,165,175)
    status.TextTransparency = 1
    status.Parent = black

    local track = Instance.new("Frame")
    track.AnchorPoint = Vector2.new(0.5,0.5)
    track.Position = UDim2.fromScale(0.5,0.65)
    track.Size = UDim2.fromOffset(280,5)
    track.BackgroundColor3 = Color3.fromRGB(35,8,12)
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.Parent = black
    Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(235,35,50)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

    local shine = Instance.new("Frame")
    shine.AnchorPoint = Vector2.new(0.5,0.5)
    shine.Position = UDim2.new(1.18,0,0.5,0)
    shine.Size = UDim2.new(0,56,1.8,0)
    shine.BackgroundColor3 = Color3.fromRGB(255,255,255)
    shine.BackgroundTransparency = 0.30
    shine.BorderSizePixel = 0
    shine.Rotation = 8
    shine.Parent = track
    local sg = Instance.new("UIGradient")
    sg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.35,1),NumberSequenceKeypoint.new(0.50,0.02),NumberSequenceKeypoint.new(0.65,1),NumberSequenceKeypoint.new(1,1)})
    sg.Parent = shine

    tween(logo,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{ImageTransparency=0})
    tween(status,TweenInfo.new(0.25),{TextTransparency=0})

    task.spawn(function()
        local started = os.clock()
        while overlay.Parent and os.clock() - started < 3 do
            local p = math.clamp((os.clock()-started)/3,0,1)
            fill.Size = UDim2.new(p,0,1,0)
            titleShine.Offset = Vector2.new(1.15,0)
            local titleTween = tween(titleShine,TweenInfo.new(0.30,Enum.EasingStyle.Linear),{Offset=Vector2.new(-1.15,0)})
            local shineTween = tween(shine,TweenInfo.new(0.30,Enum.EasingStyle.Linear),{Position=UDim2.new(-0.18,0,0.5,0)})
            titleTween.Completed:Wait()
            if not overlay.Parent then break end
        end
        if not overlay.Parent then return end
        fill.Size = UDim2.new(1,0,1,0)
        status.Text = "MONSTER CANNOT HIT YOU • EGG PROTECTED"
        task.wait(0.35)
        tween(black,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1})
        tween(title,TweenInfo.new(0.25),{TextTransparency=1})
        tween(status,TweenInfo.new(0.25),{TextTransparency=1})
        tween(logo,TweenInfo.new(0.25),{ImageTransparency=1})
        task.wait(0.38)
        if overlay.Parent then overlay:Destroy() end
        antiHitActivationBusy = false
    end)
end

local function waitForEggAndActivate()
    if not AntiHitEnabled or antiHitActivationBusy then return end
    local deadline = os.clock() + 1.5
    repeat
        local character = Player.Character
        if getEquippedEgg(character) then
            showAntiHitEggActivation()
            return
        end
        task.wait(0.05)
    until os.clock() >= deadline
end

local function watchEggTool(character)
    if not character then return end
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and isEggTool(child) then
            task.wait(0.05)
            if pendingStealPrompt then
                pendingStealPrompt = false
                showAntiHitEggActivation()
            end
        end
    end)
end

if Player.Character then watchEggTool(Player.Character) end
Player.CharacterAdded:Connect(watchEggTool)

-- Steal Egg prompt: remember the steal action, then wait for the egg
-- to actually appear in the player's hand before showing protection.
local previousPromptConnection = ProximityPromptService.PromptTriggered
ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if player ~= Player or not AntiHitEnabled then return end
    pendingStealPrompt = true
    task.spawn(waitForEggAndActivate)
end)

-- Final state: intro completes automatically after its 5-second choreography.
-- Final state: loader waits for the user to press CONTINUE after 100%.
