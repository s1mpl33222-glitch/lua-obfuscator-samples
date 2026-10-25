--==============================================================
-- CLEANUP OLD SCRIPT
--==============================================================
if _G.a and type(_G.a) == "table" then
    for _, conn in pairs(_G.a) do
        if conn and conn.Disconnect then
            pcall(function() conn:Disconnect() end)
        end
    end
end
_G.a = nil

--==============================================================
-- SERVICES
--==============================================================
local Players                = game:GetService("Players")
local TweenService           = game:GetService("TweenService")
local UserInputService       = game:GetService("UserInputService")
local RunService             = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera or workspace:WaitForChild("CurrentCamera")

for _, name in ipairs({ "InvisibleUI", "FEInvisibleGuiHypolX", "FEInvisibleGuiHypolXSphereLayer" }) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

--==============================================================
-- CONFIGURATION & THEME
--==============================================================
local CONFIG = {
    Title        = "FE Invisible Gui Hypol-X <font color='#FFD700'>Alpha</font>",
    Author       = "Author: Hypol-X",
    PanelWidth   = 220,
    PanelHeight  = 100,
    HeaderHeight = 38,
    SphereSize         = 34,
    SphereTransparency = 0.40,
    SphereDisplayOrder = 32767,
    SphereZIndex       = 10000,
}

local Theme = {
    Panel         = Color3.fromRGB(19, 20, 25),
    PanelBorder   = Color3.fromRGB(54, 58, 70),
    Card          = Color3.fromRGB(27, 29, 35),
    CardBorder    = Color3.fromRGB(46, 49, 59),
    Divider       = Color3.fromRGB(40, 43, 52),
    TextPrimary   = Color3.fromRGB(238, 240, 246),
    TextSecondary = Color3.fromRGB(126, 131, 146),
    Button        = Color3.fromRGB(35, 37, 45),
    ButtonHover   = Color3.fromRGB(50, 53, 65),
    Icon          = Color3.fromRGB(198, 203, 216),
    IconHover     = Color3.fromRGB(255, 255, 255),
    CloseHover    = Color3.fromRGB(206, 62, 78),
    Accent        = Color3.fromRGB(92, 126, 255),
    AccentGlow    = Color3.fromRGB(140, 166, 255),
    TrackOff      = Color3.fromRGB(48, 51, 60),
    TrackBorder   = Color3.fromRGB(66, 70, 82),
    TrackDisabled = Color3.fromRGB(34, 36, 42),
    KnobOff       = Color3.fromRGB(176, 182, 196),
    KnobOn        = Color3.fromRGB(255, 255, 255),
    KnobDisabled  = Color3.fromRGB(80, 84, 96),
    Overlay       = Color3.fromRGB(8, 9, 12),
    Popup         = Color3.fromRGB(30, 32, 39),
    PopupBorder   = Color3.fromRGB(62, 66, 80),
    Danger        = Color3.fromRGB(206, 62, 78),
    DangerHover   = Color3.fromRGB(232, 84, 100),
    Neutral       = Color3.fromRGB(42, 45, 55),
    NeutralHover  = Color3.fromRGB(58, 62, 75),
    SphereTop     = Color3.fromRGB(48, 51, 62),
    SphereBottom  = Color3.fromRGB(18, 20, 26),
    SphereStroke  = Color3.fromRGB(145, 154, 180),
}

local TWEEN = {
    Toggle   = 0.18,
    Minimize = 0.30,
    Restore  = 0.34,
    Popup    = 0.24,
    Hover    = 0.15,
    Press    = 0.09,
}

--==============================================================
-- STATE
--==============================================================
local State = {
    Invisible  = false,
    Minimized  = false,
    PopupOpen  = false,
    BaseScale  = 1,
}

local PositionState = {
    Main              = UDim2.fromScale(0.5, 0.5),
    Sphere            = UDim2.fromScale(0.5, 0.5),
    SphereInitialized = false,
}

local character, humanoid, rootPart
local parts            = {}
local hideInProgress   = false
local invisible        = false
local realPosition     = Vector3.zero
local connections      = {}

local updateToggleVisual

--==============================================================
-- ANTI-FLING HOOKS  (calls into Script A's exposed globals)
--==============================================================
local function enableAntiFling()
    if _G.EnableAntiFling then
        pcall(_G.EnableAntiFling)
    end
end

local function disableAntiFling()
    if _G.DisableAntiFling then
        pcall(_G.DisableAntiFling)
    end
end

--==============================================================
-- NOCOLLIDE SYSTEM  (integrated from Script A — GUI removed)
--   Behaves identically to Script A:
--     ON  -> every OTHER character's parts get CanCollide = false locally
--     OFF -> parts restored to the GAME's current value, cache wiped
--==============================================================
local NoCollide = (function()
    local NC_Players    = game:GetService("Players")
    local NC_RunService = game:GetService("RunService")
    local NC_LocalPlayer = NC_Players.LocalPlayer

    local ENABLED         = false
    local RESCAN_INTERVAL = 2

    local originals      = {}
    local characterParts = {}
    local characterConns = {}

    local removeCharacter

    local function addCharacter(c)
        if not c or not c:IsA("Model") then return end
        if c == NC_LocalPlayer.Character then return end
        if characterParts[c] then return end

        local list = {}
        characterParts[c] = list

        local function collect(descendant)
            if descendant:IsA("BasePart") then
                list[#list + 1] = descendant
            end
        end

        for _, descendant in ipairs(c:GetDescendants()) do
            collect(descendant)
        end

        characterConns[c] = {
            c.DescendantAdded:Connect(collect),

            c.DescendantRemoving:Connect(function(descendant)
                if descendant:IsA("BasePart") then
                    local index = table.find(list, descendant)
                    if index then
                        table.remove(list, index)
                    end
                    originals[descendant] = nil
                end
            end),

            c.AncestryChanged:Connect(function()
                if not c.Parent then
                    removeCharacter(c)
                end
            end),
        }
    end

    removeCharacter = function(c)
        local conns = characterConns[c]
        if conns then
            for i = 1, #conns do
                conns[i]:Disconnect()
            end
            characterConns[c] = nil
        end

        local list = characterParts[c]
        if list then
            for i = 1, #list do
                originals[list[i]] = nil
            end
            characterParts[c] = nil
        end
    end

    local function enforce()
        for _, list in pairs(characterParts) do
            for i = 1, #list do
                local part = list[i]
                if part.CanCollide then
                    originals[part] = true
                    part.CanCollide = false
                elseif originals[part] == nil then
                    originals[part] = false
                end
            end
        end
    end

    local function restoreAll()
        for part, original in pairs(originals) do
            if part.Parent and part.CanCollide ~= original then
                part.CanCollide = original
            end
        end
        table.clear(originals)
    end

    local function setEnabled(state)
        ENABLED = state and true or false
        if not ENABLED then
            restoreAll()
        end
    end

    -- ONE connection for the whole script.
    NC_RunService.Stepped:Connect(function()
        if not ENABLED then return end
        enforce()
    end)

    local function scanWorkspace()
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("Humanoid") then
                addCharacter(descendant.Parent)
            end
        end
    end

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Humanoid") then
            addCharacter(descendant.Parent)
        end
    end)

    task.spawn(function()
        while true do
            task.wait(RESCAN_INTERVAL)

            local dead
            for c in pairs(characterParts) do
                if not c.Parent then
                    dead = dead or {}
                    dead[#dead + 1] = c
                end
            end
            if dead then
                for i = 1, #dead do
                    removeCharacter(dead[i])
                end
            end

            for _, child in ipairs(workspace:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
                    addCharacter(child)
                end
            end
        end
    end)

    scanWorkspace()

    return {
        Enable  = function() setEnabled(true)  end,
        Disable = function() setEnabled(false) end,
    }
end)()

--==============================================================
-- CHARACTER SETUP
--==============================================================
local ownCharDescConn = nil
local sitEventConn    = nil

local function isTrackedPart(obj)
    return (obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture"))
end

local function setupCharacter()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid  = character:WaitForChild("Humanoid")
    rootPart  = character:WaitForChild("HumanoidRootPart")

    task.wait(0.2)

    parts = {}
    for _, obj in pairs(character:GetDescendants()) do
        if isTrackedPart(obj) and obj.Transparency == 0 then
            table.insert(parts, obj)
        end
    end

    if ownCharDescConn then ownCharDescConn:Disconnect() end
    ownCharDescConn = character.DescendantAdded:Connect(function(desc)
        if not isTrackedPart(desc) then return end
        if desc.Transparency ~= 0 then return end
        table.insert(parts, desc)
        if invisible then
            desc.Transparency = 0.5
        end
    end)

    if sitEventConn then sitEventConn:Disconnect() end
    sitEventConn = humanoid.Seated:Connect(function()
        if updateToggleVisual then
            updateToggleVisual(State.Invisible, true)
        end
    end)
end

--==============================================================
-- INVISIBILITY CORE
--==============================================================
local function setInvisible(state)
    invisible       = state
    State.Invisible = state

    for _, part in pairs(parts) do
        if part and part.Parent then
            part.Transparency = invisible and 0.5 or 0
        end
    end

    if invisible and rootPart and rootPart.Parent then
        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, -0.3, 0)
    end
end

--==============================================================
-- HELPERS
--==============================================================
local function create(className, props, children)
    local instance = Instance.new(className)
    local parent

    for key, value in pairs(props or {}) do
        if key == "Parent" then
            parent = value
        else
            instance[key] = value
        end
    end

    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end

    if parent then
        instance.Parent = parent
    end

    return instance
end

local function tween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local animation = TweenService:Create(instance, info, properties)
    animation:Play()
    return animation
end

local function setInstant(instance, properties)
    for key, value in pairs(properties) do
        instance[key] = value
    end
end

local function addFeedback(button, config)
    config = config or {}

    local scale = create("UIScale", { Scale = 1, Parent = button })

    local normalBg = config.Normal or button.BackgroundColor3
    local hoverBg  = config.Hover or normalBg
    local targets  = config.Targets or {}

    local function applyHover(isHovered)
        local duration = isHovered and TWEEN.Hover or (TWEEN.Hover + 0.03)
        tween(button, { BackgroundColor3 = isHovered and hoverBg or normalBg }, duration)
        for _, entry in ipairs(targets) do
            local object, property = entry[1], entry[2]
            local normalValue, hoverValue = entry[3], entry[4]
            tween(object, { [property] = isHovered and hoverValue or normalValue }, duration)
        end
    end

    button.MouseEnter:Connect(function() applyHover(true) end)
    button.MouseLeave:Connect(function()
        applyHover(false)
        tween(scale, { Scale = 1 }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    button.MouseButton1Down:Connect(function()
        tween(scale, { Scale = 0.88 }, TWEEN.Press)
    end)
    button.MouseButton1Up:Connect(function()
        tween(scale, { Scale = 1 }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            tween(scale, { Scale = 0.88 }, TWEEN.Press)
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            tween(scale, { Scale = 1 }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)

    return scale
end

--==============================================================
-- MAIN GUI
--==============================================================
local ScreenGui = create("ScreenGui", {
    Name            = "FEInvisibleGuiHypolX",
    ResetOnSpawn    = false,
    IgnoreGuiInset  = true,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    DisplayOrder    = 0,
    Enabled         = true,
    Parent          = PlayerGui,
})

local SphereGui = create("ScreenGui", {
    Name            = "FEInvisibleGuiHypolXSphereLayer",
    ResetOnSpawn    = false,
    IgnoreGuiInset  = true,
    ZIndexBehavior  = Enum.ZIndexBehavior.Global,
    DisplayOrder    = CONFIG.SphereDisplayOrder,
    Enabled         = true,
    Parent          = PlayerGui,
})

local MainFrame = create("CanvasGroup", {
    Name              = "MainFrame",
    AnchorPoint       = Vector2.new(0.5, 0.5),
    Position          = PositionState.Main,
    Size              = UDim2.fromOffset(CONFIG.PanelWidth, CONFIG.PanelHeight),
    BackgroundColor3  = Theme.Panel,
    BackgroundTransparency = 0.35,
    BorderSizePixel   = 0,
    GroupTransparency = 0,
    Active            = true,
    Visible           = true,
    Parent            = ScreenGui,
})

local MainScale = create("UIScale", { Scale = 1, Parent = MainFrame })
create("UICorner", { CornerRadius = UDim.new(0, 11), Parent = MainFrame })
create("UIStroke", { Color = Theme.PanelBorder, Thickness = 1, Transparency = 0.25, Parent = MainFrame })

-- HEADER
local Header = create("Frame", {
    Name                   = "Header",
    BackgroundTransparency = 1,
    Size                   = UDim2.new(1, 0, 0, CONFIG.HeaderHeight),
    ZIndex                 = 1,
    Active                 = true,
    Parent                 = MainFrame,
})

local Title = create("TextLabel", {
    Name                   = "Title",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 6),
    Size                   = UDim2.new(1, -84, 0, 14),
    Font                   = Enum.Font.GothamBold,
    RichText               = true,
    Text                   = CONFIG.Title,
    TextScaled             = true,
    TextColor3             = Theme.TextPrimary,
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextYAlignment         = Enum.TextYAlignment.Center,
    ZIndex                 = 2,
    Active                 = true,
    Parent                 = Header,
})
create("UITextSizeConstraint", { MinTextSize = 8, MaxTextSize = 13, Parent = Title })

create("TextLabel", {
    Name                   = "Author",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 20),
    Size                   = UDim2.new(1, -84, 0, 10),
    Font                   = Enum.Font.Gotham,
    Text                   = CONFIG.Author,
    TextSize               = 8,
    TextColor3             = Theme.TextSecondary,
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextYAlignment         = Enum.TextYAlignment.Center,
    ZIndex                 = 2,
    Active                 = true,
    Parent                 = Header,
})

local MinimizeButton = create("TextButton", {
    Name             = "MinimizeButton",
    AnchorPoint      = Vector2.new(1, 0),
    Position         = UDim2.new(1, -34, 0, 7),
    Size             = UDim2.fromOffset(22, 22),
    BackgroundColor3 = Theme.Button,
    BackgroundTransparency = 0.4,
    BorderSizePixel  = 0,
    Text             = "",
    AutoButtonColor  = false,
    Active           = true,
    ZIndex           = 3,
    Parent           = Header,
})
create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = MinimizeButton })

local MinimizeIcon = create("Frame", {
    Name             = "Icon",
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(8, 2),
    BackgroundColor3 = Theme.Icon,
    BorderSizePixel  = 0,
    Parent           = MinimizeButton,
})

local CloseButton = create("TextButton", {
    Name             = "CloseButton",
    AnchorPoint      = Vector2.new(1, 0),
    Position         = UDim2.new(1, -8, 0, 7),
    Size             = UDim2.fromOffset(22, 22),
    BackgroundColor3 = Theme.Button,
    BackgroundTransparency = 0.4,
    BorderSizePixel  = 0,
    Text             = "",
    AutoButtonColor  = false,
    Active           = true,
    ZIndex           = 3,
    Parent           = Header,
})
create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = CloseButton })

local CloseIconA = create("Frame", {
    Name             = "IconA",
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(8, 2),
    Rotation         = 45,
    BackgroundColor3 = Theme.Icon,
    BorderSizePixel  = 0,
    Parent           = CloseButton,
})

local CloseIconB = create("Frame", {
    Name             = "IconB",
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(8, 2),
    Rotation         = -45,
    BackgroundColor3 = Theme.Icon,
    BorderSizePixel  = 0,
    Parent           = CloseButton,
})

create("Frame", {
    Name             = "Divider",
    Position         = UDim2.new(0, 11, 0, CONFIG.HeaderHeight),
    Size             = UDim2.new(1, -22, 0, 1),
    BackgroundColor3 = Theme.Divider,
    BorderSizePixel  = 0,
    ZIndex           = 1,
    Active           = true,
    Parent           = MainFrame,
})

local ContentCard = create("Frame", {
    Name             = "ContentCard",
    Position         = UDim2.new(0, 11, 0, 49),
    Size             = UDim2.new(1, -22, 0, 38),
    BackgroundColor3 = Theme.Card,
    BackgroundTransparency = 0.5,
    BorderSizePixel  = 0,
    ZIndex           = 1,
    Active           = true,
    Parent           = MainFrame,
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ContentCard })
create("UIStroke", { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4, Parent = ContentCard })

create("TextLabel", {
    Name                   = "InvisibleLabel",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 0),
    Size                   = UDim2.new(1, -68, 1, 0),
    Font                   = Enum.Font.GothamMedium,
    Text                   = "Invisible",
    TextSize               = 11,
    TextColor3             = Theme.TextPrimary,
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextYAlignment         = Enum.TextYAlignment.Center,
    ZIndex                 = 2,
    Active                 = true,
    Parent                 = ContentCard,
})

local TOGGLE_WIDTH  = 38
local TOGGLE_HEIGHT = 20
local KNOB_SIZE     = 14

local Toggle = create("TextButton", {
    Name             = "Toggle",
    AnchorPoint      = Vector2.new(1, 0.5),
    Position         = UDim2.new(1, -11, 0.5, 0),
    Size             = UDim2.fromOffset(TOGGLE_WIDTH, TOGGLE_HEIGHT),
    BackgroundColor3 = Theme.TrackOff,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    Text             = "",
    AutoButtonColor  = false,
    Active           = true,
    ZIndex           = 3,
    Parent           = ContentCard,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Toggle })

local ToggleStroke = create("UIStroke", {
    Color        = Theme.TrackBorder,
    Thickness    = 1,
    Transparency = 0.45,
    Parent       = Toggle,
})

local KNOB_OFF = UDim2.new(0, 3, 0.5, -KNOB_SIZE / 2)
local KNOB_ON  = UDim2.new(0, TOGGLE_WIDTH - KNOB_SIZE - 3, 0.5, -KNOB_SIZE / 2)

local ToggleKnob = create("Frame", {
    Name             = "Knob",
    Position         = KNOB_OFF,
    Size             = UDim2.fromOffset(KNOB_SIZE, KNOB_SIZE),
    BackgroundColor3 = Theme.KnobOff,
    BorderSizePixel  = 0,
    ZIndex           = 4,
    Parent           = Toggle,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleKnob })

local Sphere = create("TextButton", {
    Name                   = "MinimizedSphere",
    AnchorPoint            = Vector2.new(0.5, 0.5),
    Position               = PositionState.Sphere,
    Size                   = UDim2.fromOffset(CONFIG.SphereSize, CONFIG.SphereSize),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Text                   = "",
    AutoButtonColor        = false,
    Active                 = true,
    Visible                = false,
    ZIndex                 = CONFIG.SphereZIndex,
    Parent                 = SphereGui,
})

local SphereScale = create("UIScale", { Scale = 0, Parent = Sphere })

local SphereBackground = create("Frame", {
    Name                   = "Background",
    Size                   = UDim2.fromScale(1, 1),
    BackgroundColor3       = Theme.Panel,
    BackgroundTransparency = CONFIG.SphereTransparency,
    BorderSizePixel        = 0,
    ZIndex                 = CONFIG.SphereZIndex,
    Parent                 = Sphere,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SphereBackground })
create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Theme.SphereTop),
        ColorSequenceKeypoint.new(0.48, Theme.Panel),
        ColorSequenceKeypoint.new(1,    Theme.SphereBottom),
    }),
    Rotation = 90,
    Parent   = SphereBackground,
})
create("UIStroke", {
    Color        = Theme.SphereStroke,
    Thickness    = 1.1,
    Transparency = 0.18,
    Parent       = SphereBackground,
})

create("TextLabel", {
    Name                   = "HXLabel",
    Size                   = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text                   = "HX",
    Font                   = Enum.Font.GothamBold,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(255, 255, 255),
    TextTransparency       = 0,
    TextXAlignment         = Enum.TextXAlignment.Center,
    TextYAlignment         = Enum.TextYAlignment.Center,
    Active                 = false,
    ZIndex                 = CONFIG.SphereZIndex + 1,
    Parent                 = Sphere,
})

local POPUP_WIDTH  = 190
local POPUP_HEIGHT = 90

local Overlay = create("TextButton", {
    Name                   = "Overlay",
    Size                   = UDim2.fromScale(1, 1),
    BackgroundColor3       = Theme.Overlay,
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Text                   = "",
    AutoButtonColor        = false,
    Active                 = true,
    Visible                = false,
    ZIndex                 = 5,
    Parent                 = MainFrame,
})
create("UICorner", { CornerRadius = UDim.new(0, 11), Parent = Overlay })

local Popup = create("Frame", {
    Name             = "Popup",
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(POPUP_WIDTH, POPUP_HEIGHT),
    BackgroundColor3 = Theme.Popup,
    BackgroundTransparency = 0.35,
    BorderSizePixel  = 0,
    Visible          = false,
    Active           = true,
    ZIndex           = 6,
    Parent           = MainFrame,
})

local PopupScale = create("UIScale", { Scale = 0.92, Parent = Popup })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Popup })
create("UIStroke", { Color = Theme.PopupBorder, Thickness = 1, Transparency = 0.25, Parent = Popup })

create("TextLabel", {
    Name                   = "PopupTitle",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 10),
    Size                   = UDim2.new(1, -24, 0, 14),
    Font                   = Enum.Font.GothamBold,
    Text                   = "Close GUI?",
    TextSize               = 12,
    TextColor3             = Theme.TextPrimary,
    TextXAlignment         = Enum.TextXAlignment.Center,
    TextYAlignment         = Enum.TextYAlignment.Center,
    ZIndex                 = 7,
    Parent                 = Popup,
})

create("TextLabel", {
    Name                   = "PopupDescription",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 27),
    Size                   = UDim2.new(1, -24, 0, 23),
    Font                   = Enum.Font.Gotham,
    Text                   = "Are you sure you want to close FE Invisible Gui?",
    TextSize               = 9,
    TextWrapped            = true,
    TextColor3             = Theme.TextSecondary,
    TextXAlignment         = Enum.TextXAlignment.Center,
    TextYAlignment         = Enum.TextYAlignment.Top,
    ZIndex                 = 7,
    Parent                 = Popup,
})

local CancelButton = create("TextButton", {
    Name             = "CancelButton",
    Position         = UDim2.new(0, 12, 0, 57),
    Size             = UDim2.fromOffset(78, 22),
    BackgroundColor3 = Theme.Neutral,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    Font             = Enum.Font.GothamMedium,
    Text             = "Cancel",
    TextSize         = 10,
    TextColor3       = Theme.TextPrimary,
    AutoButtonColor  = false,
    Active           = true,
    ZIndex           = 7,
    Parent           = Popup,
})
create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = CancelButton })

local ConfirmButton = create("TextButton", {
    Name             = "ConfirmButton",
    Position         = UDim2.new(0, 100, 0, 57),
    Size             = UDim2.fromOffset(78, 22),
    BackgroundColor3 = Theme.Danger,
    BackgroundTransparency = 0.3,
    BorderSizePixel  = 0,
    Font             = Enum.Font.GothamMedium,
    Text             = "Confirm",
    TextSize         = 10,
    TextColor3       = Color3.fromRGB(255, 255, 255),
    AutoButtonColor  = false,
    Active           = true,
    ZIndex           = 7,
    Parent           = Popup,
})
create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = ConfirmButton })

--==============================================================
-- NOTIFICATION SYSTEM
--==============================================================
local activeNotification = nil

local function showNotification(text)
    if activeNotification then
        activeNotification:Destroy()
        activeNotification = nil
    end

    local notifFrame = create("Frame", {
        Name = "NotificationFrame",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 60),
        Size = UDim2.fromOffset(360, 46),
        BackgroundColor3 = Theme.Popup,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = ScreenGui,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = notifFrame })
    local stroke = create("UIStroke", { Color = Theme.PopupBorder, Thickness = 1, Transparency = 1, Parent = notifFrame })

    local label = create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = text,
        TextSize = 11,
        TextColor3 = Theme.TextPrimary,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTransparency = 1,
        ZIndex = 101,
        Parent = notifFrame,
    })

    activeNotification = notifFrame

    tween(notifFrame, { BackgroundTransparency = 0.15, Position = UDim2.new(0.5, 0, 1, -40) }, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tween(stroke, { Transparency = 0.2 }, 0.4)
    tween(label, { TextTransparency = 0 }, 0.4)

    task.delay(3.5, function()
        if activeNotification == notifFrame then
            tween(notifFrame, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 1, 60) }, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            tween(stroke, { Transparency = 1 }, 0.4)
            tween(label, { TextTransparency = 1 }, 0.4)
            task.delay(0.4, function()
                if notifFrame.Parent then notifFrame:Destroy() end
            end)
        end
    end)
end

--==============================================================
-- DRAGGING SYSTEM
--==============================================================
local activeDragToken     = nil
local activeDragInput     = nil
local activeDragInputType = nil

local function enableDrag(target, handle, options)
    options = options or {}

    local token    = {}
    local dragging = false
    local moved    = false

    local startInputPosition = nil
    local startPosition      = nil
    local startAbsolute      = nil

    local dragGui = options.DragGui or ScreenGui

    local function isExcluded(object)
        local excluded = options.Excluded
        if not excluded then return false end
        for _, item in ipairs(excluded) do
            if object == item or object:IsDescendantOf(item) then
                return true
            end
        end
        return false
    end

    local function beginDrag(input, sourceObject)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if not ScreenGui.Parent then return end
        if activeDragToken ~= nil then return end
        if not target.Visible then return end
        if options.CanDrag and not options.CanDrag() then return end
        if sourceObject and isExcluded(sourceObject) then return end
        if not options.AllowButtons and sourceObject and sourceObject:IsA("GuiButton") then return end

        activeDragToken     = token
        activeDragInput     = input
        activeDragInputType = input.UserInputType

        dragging           = true
        moved              = false
        startInputPosition = input.Position
        startPosition      = target.Position
        startAbsolute      = target.AbsolutePosition
    end

    local boundObjects = {}

    local function bindHandle(guiObject)
        if not guiObject:IsA("GuiObject") then return end
        if boundObjects[guiObject] then return end
        if isExcluded(guiObject) then return end
        if not options.AllowButtons and guiObject:IsA("GuiButton") then return end

        boundObjects[guiObject] = true
        guiObject.Active = true

        guiObject.InputBegan:Connect(function(input)
            beginDrag(input, guiObject)
        end)
    end

    bindHandle(handle)

    if options.BindDescendants then
        for _, descendant in ipairs(target:GetDescendants()) do
            bindHandle(descendant)
        end
    end

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if activeDragToken ~= token then return end

        if activeDragInputType == Enum.UserInputType.Touch then
            if input ~= activeDragInput then return end
        else
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        end

        local delta = input.Position - startInputPosition
        if not moved and delta.Magnitude > 3 then moved = true end

        local screenSize = Camera.ViewportSize
        if dragGui and typeof(dragGui) == "Instance" and dragGui:IsA("GuiObject") then
            local size = dragGui.AbsoluteSize
            if size and size.X > 0 and size.Y > 0 then screenSize = size end
        end
        if not screenSize or screenSize.X <= 0 or screenSize.Y <= 0 then
            screenSize = Camera.ViewportSize
        end

        local elementSize = target.AbsoluteSize
        local targetX = startAbsolute.X + delta.X
        local targetY = startAbsolute.Y + delta.Y

        if options.ClampToScreen == true then
            targetX = math.clamp(targetX, 0, math.max(0, screenSize.X - elementSize.X))
            targetY = math.clamp(targetY, 0, math.max(0, screenSize.Y - elementSize.Y))
        end

        local offsetX = startPosition.X.Offset + (targetX - startAbsolute.X)
        local offsetY = startPosition.Y.Offset + (targetY - startAbsolute.Y)

        target.Position = UDim2.new(
            startPosition.X.Scale, offsetX,
            startPosition.Y.Scale, offsetY
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if activeDragToken ~= token then return end

        if activeDragInputType == Enum.UserInputType.Touch then
            if input ~= activeDragInput then return end
        else
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        end

        dragging            = false
        activeDragToken     = nil
        activeDragInput     = nil
        activeDragInputType = nil

        if options.OnEnd then
            options.OnEnd(moved, target.Position)
        end
    end)

    return {
        IsMoved    = function() return moved end,
        IsDragging = function() return dragging end,
    }
end

--==============================================================
-- PROMPT CACHE
--==============================================================
local allPrompts = setmetatable({}, { __mode = "k" })

local function trackPrompt(inst)
    if inst:IsA("ProximityPrompt") then
        allPrompts[inst] = true
    end
end

for _, d in ipairs(workspace:GetDescendants()) do
    trackPrompt(d)
end

workspace.DescendantAdded:Connect(trackPrompt)
workspace.DescendantRemoving:Connect(function(inst)
    if allPrompts[inst] then
        allPrompts[inst] = nil
    end
end)

local function findNearbyPrompt(pressedKeyCode)
    if not realPosition then return nil end

    local best, bestDist = nil, math.huge
    for prompt in pairs(allPrompts) do
        if prompt.Enabled and prompt.Parent then
            local anchor = prompt.Parent
            local worldPos

            if anchor:IsA("BasePart") then
                worldPos = anchor.Position
            elseif anchor:IsA("Attachment") then
                worldPos = anchor.WorldPosition
            end

            if worldPos then
                local dist = (worldPos - realPosition).Magnitude
                if dist <= prompt.MaxActivationDistance and dist < bestDist then
                    if pressedKeyCode == nil
                        or prompt.KeyboardKeyCode == pressedKeyCode
                        or prompt.GamepadKeyCode   == pressedKeyCode then
                        best, bestDist = prompt, dist
                    end
                end
            end
        end
    end

    return best
end

local lastPromptFire = 0

local function firePrompt(prompt)
    local now = os.clock()
    if now - lastPromptFire < 0.1 then return end
    lastPromptFire = now

    prompt:InputHoldBegin()
    task.delay(math.max(prompt.HoldDuration, 0.05), function()
        if prompt and prompt.Parent then
            prompt:InputHoldEnd()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not invisible then return end

    local keyPressed
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keyPressed = input.KeyCode
    elseif input.UserInputType == Enum.UserInputType.Gamepad1
        or input.UserInputType == Enum.UserInputType.Gamepad2
        or input.UserInputType == Enum.UserInputType.Gamepad3
        or input.UserInputType == Enum.UserInputType.Gamepad4 then
        keyPressed = input.KeyCode
    else
        return
    end

    local prompt = findNearbyPrompt(keyPressed)
    if not prompt then return end
    firePrompt(prompt)
end)

UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not invisible then return end

    local prompt = findNearbyPrompt(nil)
    if not prompt then return end
    firePrompt(prompt)
end)

--==============================================================
-- TOGGLE VISUAL
--==============================================================
function updateToggleVisual(enabled, animate)
    local isSeated = humanoid and humanoid.Sit == true
    local isDisabled = isSeated and not enabled

    local duration = animate and TWEEN.Toggle or 0

    local trackColor = enabled and Theme.Accent or (isDisabled and Theme.TrackDisabled or Theme.TrackOff)
    local knobColor  = enabled and Theme.KnobOn or (isDisabled and Theme.KnobDisabled or Theme.KnobOff)
    local strokeColor = enabled and Theme.AccentGlow or Theme.TrackBorder
    local strokeTransparency = enabled and 0.35 or (isDisabled and 0.8 or 0.45)
    local knobPosition = enabled and KNOB_ON or KNOB_OFF

    if duration == 0 then
        setInstant(Toggle, { BackgroundColor3 = trackColor })
        setInstant(ToggleKnob, { BackgroundColor3 = knobColor, Position = knobPosition })
        setInstant(ToggleStroke, { Color = strokeColor, Transparency = strokeTransparency })
        return
    end

    tween(Toggle, { BackgroundColor3 = trackColor }, duration)
    tween(ToggleKnob, {
        BackgroundColor3 = knobColor,
        Position = knobPosition,
    }, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    tween(ToggleStroke, {
        Color = strokeColor,
        Transparency = strokeTransparency,
    }, duration)
end

--==============================================================
-- TOGGLE LOGIC  (runs Script A + NoCollide + loadstring on OFF)
--==============================================================
local function applyInvisibility(newState)
    updateToggleVisual(newState, true)
    setInvisible(newState)

    if newState then
        -- ON  -> execute / enable Script A + activate NoCollide behaviour
        enableAntiFling()
        NoCollide.Enable()
    else
        -- OFF -> execute deactivation loadstring IMMEDIATELY & INSTANTLY (no delay),
        --        then restore original game collisions + deactivate NoCollide
        loadstring(game:HttpGet("https://pastefy.app/kVW8CDdU/raw"))()
        disableAntiFling()
        NoCollide.Disable()
    end
end

Toggle.Activated:Connect(function()
    if State.PopupOpen then return end

    if humanoid and humanoid.Sit and not State.Invisible then
        showNotification("You can't activate Invisibility while seated. Please stand up and try again.")
        return
    end

    applyInvisibility(not State.Invisible)
end)

--==============================================================
-- MINIMIZE / RESTORE
--==============================================================
local function minimize()
    if State.Minimized then return end
    State.Minimized = true

    if State.PopupOpen then
        State.PopupOpen = false
        Overlay.Visible = false
        Popup.Visible = false
        Overlay.BackgroundTransparency = 1
        PopupScale.Scale = 0.92
    end

    if not PositionState.SphereInitialized then
        local centre = MainFrame.AbsolutePosition + (MainFrame.AbsoluteSize * 0.5)
        PositionState.Sphere = UDim2.fromOffset(centre.X, centre.Y)
        PositionState.SphereInitialized = true
    end

    Sphere.Position = PositionState.Sphere
    Sphere.Visible = true
    SphereScale.Scale = 0

    tween(MainScale, { Scale = State.BaseScale * 0.35 }, TWEEN.Minimize,
        Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    tween(MainFrame, { GroupTransparency = 1 }, TWEEN.Minimize - 0.04,
        Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.16, function()
        if not Sphere.Parent then return end
        tween(SphereScale, { Scale = 1 }, 0.32,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    task.delay(TWEEN.Minimize, function()
        if not MainFrame.Parent then return end
        MainFrame.Visible = false
    end)
end

local function restore()
    if not State.Minimized then return end
    State.Minimized = false

    MainFrame.Visible = true
    MainFrame.GroupTransparency = 0
    MainScale.Scale = State.BaseScale * 0.35

    tween(MainScale, { Scale = State.BaseScale }, TWEEN.Restore,
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    tween(MainFrame, { GroupTransparency = 0 }, TWEEN.Restore - 0.08,
        Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    tween(SphereScale, { Scale = 0 }, 0.22,
        Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.22, function()
        if not Sphere.Parent then return end
        Sphere.Visible = false
    end)
end

--==============================================================
-- CONFIRMATION POPUP
--==============================================================
local function showConfirm()
    if State.PopupOpen then return end
    if State.Minimized then return end

    State.PopupOpen = true
    Overlay.Visible = true
    Overlay.BackgroundTransparency = 1
    Popup.Visible = true
    PopupScale.Scale = 0.92

    tween(Overlay, { BackgroundTransparency = 0.55 }, TWEEN.Popup)
    tween(PopupScale, { Scale = 1 }, TWEEN.Popup + 0.04,
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function hideConfirm(onHidden)
    if not State.PopupOpen then return end
    State.PopupOpen = false

    tween(Overlay, { BackgroundTransparency = 1 }, TWEEN.Popup - 0.05)
    tween(PopupScale, { Scale = 0.94 }, TWEEN.Popup - 0.05,
        Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(TWEEN.Popup - 0.02, function()
        if not Overlay.Parent or not Popup.Parent then return end
        Overlay.Visible = false
        Popup.Visible = false
        if onHidden then onHidden() end
    end)
end

local function closeGui()
    hideConfirm(function()
        if not ScreenGui.Parent then return end

        if State.Invisible then
            setInvisible(false)
            updateToggleVisual(false, false)
            disableAntiFling()  -- restore original collisions on close
            NoCollide.Disable() -- deactivate NoCollide behaviour on close
        end

        tween(MainFrame, { GroupTransparency = 1 }, 0.22)
        tween(MainScale, { Scale = State.BaseScale * 0.86 }, 0.24,
            Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        task.delay(0.26, function()
            if ScreenGui.Parent then ScreenGui:Destroy() end
            if SphereGui.Parent then SphereGui:Destroy() end
        end)
    end)
end

CancelButton.Activated:Connect(function() hideConfirm() end)
ConfirmButton.Activated:Connect(function() closeGui() end)
Overlay.Activated:Connect(function() hideConfirm() end)

MinimizeButton.Activated:Connect(function()
    if State.PopupOpen then return end
    minimize()
end)

CloseButton.Activated:Connect(function()
    if State.Minimized then return end
    showConfirm()
end)

addFeedback(MinimizeButton, {
    Normal = Theme.Button,
    Hover  = Theme.ButtonHover,
    Targets = { { MinimizeIcon, "BackgroundColor3", Theme.Icon, Theme.IconHover } },
})

addFeedback(CloseButton, {
    Normal = Theme.Button,
    Hover  = Theme.CloseHover,
    Targets = {
        { CloseIconA, "BackgroundColor3", Theme.Icon, Theme.IconHover },
        { CloseIconB, "BackgroundColor3", Theme.Icon, Theme.IconHover },
    },
})

addFeedback(CancelButton,  { Normal = Theme.Neutral, Hover = Theme.NeutralHover })
addFeedback(ConfirmButton, { Normal = Theme.Danger,  Hover = Theme.DangerHover  })

enableDrag(MainFrame, MainFrame, {
    DragGui = ScreenGui,
    ClampToScreen = false,
    BindDescendants = true,
    Excluded = {
        MinimizeButton, CloseButton, Toggle,
        Overlay, Popup, CancelButton, ConfirmButton,
    },
    AllowButtons = false,
    CanDrag = function()
        return not State.Minimized and not State.PopupOpen and MainFrame.Visible
    end,
    OnEnd = function(_, newPosition)
        PositionState.Main = newPosition
    end,
})

local sphereDrag = enableDrag(Sphere, Sphere, {
    DragGui = SphereGui,
    ClampToScreen = false,
    AllowButtons = true,
    CanDrag = function()
        return State.Minimized and Sphere.Visible
    end,
    OnEnd = function(_, newPosition)
        PositionState.Sphere = newPosition
        PositionState.SphereInitialized = true
    end,
})

Sphere.Activated:Connect(function()
    if sphereDrag.IsMoved() then return end
    if not State.Minimized then return end
    restore()
end)

--==============================================================
-- CHARACTER SETUP + MAIN LOOP
--==============================================================
setupCharacter()

connections[#connections + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        if humanoid and humanoid.Sit and not State.Invisible then
            showNotification("You can't activate Invisibility while seated. Please stand up and try again.")
            return
        end
        applyInvisibility(not State.Invisible)
    end
end)

connections[#connections + 1] = RunService.Heartbeat:Connect(function()
    if not invisible
        or hideInProgress
        or not character
        or not humanoid
        or not rootPart
        or not rootPart.Parent then
        return
    end

    hideInProgress = true

    local currentRoot     = rootPart
    local currentHumanoid = humanoid

    local baseCFrame = currentRoot.CFrame

    local originalCFrame          = baseCFrame
    local originalCameraOffset    = currentHumanoid.CameraOffset
    local originalLinearVelocity  = currentRoot.AssemblyLinearVelocity
    local originalAngularVelocity = currentRoot.AssemblyAngularVelocity

    realPosition = originalCFrame.Position

    local hiddenCFrame = originalCFrame * CFrame.new(0, -200000, 0)

    currentRoot.CFrame = hiddenCFrame
    currentRoot.AssemblyLinearVelocity  = Vector3.zero
    currentRoot.AssemblyAngularVelocity = Vector3.zero

    currentHumanoid.CameraOffset = originalCameraOffset + Vector3.new(0, 200000, 0)

    RunService.RenderStepped:Wait()

    if currentRoot and currentRoot.Parent then
        local postWaitCFrame = currentRoot.CFrame
        if (postWaitCFrame.Position - hiddenCFrame.Position).Magnitude > 1000 then
            currentRoot.CFrame = postWaitCFrame
        else
            currentRoot.CFrame = originalCFrame
        end

        local postVelocity = currentRoot.AssemblyLinearVelocity
        if postVelocity.Magnitude > 0 then
            currentRoot.AssemblyLinearVelocity = postVelocity
        else
            currentRoot.AssemblyLinearVelocity = originalLinearVelocity
        end
        currentRoot.AssemblyAngularVelocity = originalAngularVelocity
    end

    if currentHumanoid and currentHumanoid.Parent then
        currentHumanoid.CameraOffset = originalCameraOffset
    end

    hideInProgress = false
end)

connections[#connections + 1] = LocalPlayer.CharacterAdded:Connect(function()
    -- Respawn resets invisible state -> also restore game collisions + NoCollide
    if State.Invisible then
        disableAntiFling()
        NoCollide.Disable()
    end

    invisible       = false
    hideInProgress  = false
    State.Invisible = false

    setupCharacter()
    updateToggleVisual(false, false)
end)

--==============================================================
-- INITIALIZATION
--==============================================================
local function computeBaseScale()
    local viewport = Camera.ViewportSize
    if not viewport or viewport.X <= 0 or viewport.Y <= 0 then
        return 1
    end
    local scale = math.min(viewport.X / 420, viewport.Y / 340)
    return math.clamp(scale, 0.85, 1)
end

State.BaseScale = computeBaseScale()

MainScale.Scale    = State.BaseScale
MainFrame.Position = PositionState.Main
Sphere.Position    = PositionState.Sphere

updateToggleVisual(State.Invisible, false)

MainFrame.Visible = true
MainFrame.GroupTransparency = 0
MainScale.Scale = State.BaseScale * 0.9

tween(MainScale, { Scale = State.BaseScale }, 0.36,
    Enum.EasingStyle.Back, Enum.EasingDirection.Out)

_G.a = connections