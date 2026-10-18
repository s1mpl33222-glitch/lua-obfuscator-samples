if game.CoreGui:FindFirstChild("FishyHubReplica") then
    game.CoreGui.FishyHubReplica:Destroy()
end

--========================================================--
-- JUNKIE KEY SYSTEM SETUP
--========================================================--

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Key"
Junkie.identifier = "1161164"
Junkie.provider = "Fishy"

--========================================================--
-- SERVICES
--========================================================--

local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService         = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Connections on global signals. Disconnected when the GUI
-- is destroyed, so nothing is left running behind it.
local Connections = {}

--========================================================--
-- KEY PERSISTENCE
--========================================================--

local function hasFileSystemSupport()
    local hasWritefile = pcall(function()
        return type(writefile) == "function"
    end)

    local hasReadfile = pcall(function()
        return type(readfile) == "function"
    end)

    local hasIsfile = pcall(function()
        return type(isfile) == "function"
    end)

    return hasWritefile and hasReadfile and hasIsfile
end

local fileSystemSupported = hasFileSystemSupport()

local function saveVerifiedKey(key)
    if not fileSystemSupported then
        return false
    end

    local ok = pcall(function()
        writefile("verified_key.txt", key)
    end)

    return ok
end

local function loadVerifiedKey()
    if not fileSystemSupported then
        return nil
    end

    local ok, content = pcall(function()
        return readfile("verified_key.txt")
    end)

    if not ok or not content or content == "" then
        return nil
    end

    return content
end

local function clearSavedKey()
    if not fileSystemSupported then
        return false
    end

    local ok = pcall(function()
        if isfile("verified_key.txt") then
            delfile("verified_key.txt")
        end
    end)

    return ok
end

--========================================================--
-- JUNKIE STARTUP VALIDATION
--========================================================--

local savedKey = loadVerifiedKey()

local keyToCheck = savedKey

if not keyToCheck then
    keyToCheck = getgenv().SCRIPT_KEY
end

local initialResult = nil

if keyToCheck and keyToCheck ~= "" then
    local ok, result = pcall(function()
        return Junkie.check_key(keyToCheck)
    end)

    if ok then
        initialResult = result
    end
end

local StartupKeyValid = false
local StartupKeyless = false

if initialResult and initialResult.valid then

    if initialResult.message == "KEYLESS" then
        getgenv().SCRIPT_KEY = "KEYLESS"
        StartupKeyValid = true
        StartupKeyless = true

    elseif initialResult.message == "KEY_VALID" then

        if not savedKey and keyToCheck then
            saveVerifiedKey(keyToCheck)
        end

        getgenv().SCRIPT_KEY = keyToCheck
        StartupKeyValid = true
    end

elseif savedKey and initialResult and not initialResult.key_valid then
    clearSavedKey()
    getgenv().SCRIPT_KEY = nil
end

--========================================================--
-- CONSTANTS
--========================================================--

local SidebarWidth    = 0.305
local MinSidebarWidth = 0.115
local MaxSidebarWidth = 0.42

-- Breathing room between the sidebar and main content.
local ContentGap = 18

local SidebarOpen = true
local Resizing    = false
local Alive       = true

local Purple       = Color3.fromRGB(157, 91, 255)
local PurpleBright = Color3.fromRGB(205, 145, 255)
local PurpleDark   = Color3.fromRGB(72, 35, 130)

-- Type on glass has to read as light, not as ink printed on
-- the surface. Saturated purple did the latter, and the grey
-- secondaries were too dark to sit on a translucent pane over
-- a moving scene. One hue, four weights, all legible.
local TextPrimary   = Color3.fromRGB(248, 246, 253)
local TextSecondary = Color3.fromRGB(192, 183, 216)
local TextMuted     = Color3.fromRGB(166, 155, 194)
local TextAccent    = Color3.fromRGB(216, 203, 248)

local Smooth = TweenInfo.new(
    0.35,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

local Fast = TweenInfo.new(
    0.16,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

--========================================================--
-- RESPONSIVE LAYOUT
--
-- The window is built at a fixed design size for its tier
-- and then scaled to fit the viewport, so it can never
-- clip. Tighter screens drop whole sections - but never
-- the key box, Get Key or Verify.
--========================================================--

local UI_SCALE_MIN  = 0.42
local UI_SCALE_MAX  = 1.35
local VIEWPORT_FILL = 0.94

local TierSizes = {
    full = {
        header = 96, pad = 35, keyBox = 70,
        btn1 = 59, btn2 = 54,
        title = 27, sub = 11,
        sidebar = 340, main = 760, avatar = 108
    },

    compact = {
        header = 86, pad = 28, keyBox = 64,
        btn1 = 55, btn2 = 48,
        title = 24, sub = 11,
        sidebar = 300, main = 660, avatar = 96
    },

    narrow = {
        header = 74, pad = 22, keyBox = 58,
        btn1 = 50, btn2 = 44,
        title = 21, sub = 10,
        sidebar = 220, main = 560, avatar = 76
    },

    mini = {
        header = 62, pad = 16, keyBox = 52,
        btn1 = 46, btn2 = 42,
        title = 18, sub = 9,
        sidebar = 0, main = 430, avatar = 0
    }
}

local function GetViewport()

    local camera = workspace.CurrentCamera

    if camera then
        return camera.ViewportSize
    end

    return Vector2.new(1280, 720)
end

local function IsMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
end

local function PickTier(w, h)

    if w >= 1000 and h >= 660 then
        return "full"
    end

    if w >= 820 and h >= 545 then
        return "compact"
    end

    if w >= 620 and h >= 430 then
        return "narrow"
    end

    return "mini"
end

local function GetLayoutProfile()

    local viewport =
        GetViewport()

    local tier =
        PickTier(
            viewport.X,
            viewport.Y
        )

    local S =
        TierSizes[tier]

    local L = {
        tier = tier,
        viewport = viewport,
        isMobile = IsMobileDevice(),

        headerHeight   = S.header,
        contentPadding = S.pad,
        keyBoxHeight   = S.keyBox,
        buttonHeight   = S.btn1,
        buttonHeight2  = S.btn2,
        titleSize      = S.title,
        subtitleSize   = S.sub,
        avatarSize     = S.avatar,

        -- A sidebar that only has room for an avatar and a
        -- name is worse than no sidebar: it reads as a column
        -- someone forgot to fill. Below compact it goes.
        showSidebar        = tier == "full" or tier == "compact",
        showSidebarDetails = tier == "full" or tier == "compact",
        showStars          = tier == "full" or tier == "compact",
        showServiceHeader  = tier ~= "mini",
        showAccessDesc     = tier ~= "mini",
        showSecondRow      = tier ~= "mini",
        showPremium        = tier == "full" or tier == "compact",
        showPerks          = tier == "full",

        mainTransparency     = 0.38,
        backdropTransparency = 0.44,

        cornerRadius =
            if tier == "mini"
            then 14
            else 18
    }

    -- FISHY wordmark is 2.78:1, so its height follows width.
    L.logoWidth =
        if tier == "narrow"
        then 104
        else 124

    L.logoHeight =
        math.round(L.logoWidth / 2.78)

    L.serviceTextX =
        L.logoWidth + 12

    L.contentGap =
        if L.showSidebar
        then 18
        else 0

    L.sidebarWidthPx =
        if L.showSidebar
        then S.sidebar
        else 0

    L.mainWidthPx =
        S.main

    L.serviceHeaderHeight =
        if L.showServiceHeader
        then 112
        else 0

    L.accessTop =
        if L.showServiceHeader
        then L.serviceHeaderHeight + 22
        else 14

    L.accessDescHeight =
        if L.showAccessDesc
        then 45
        else 22

    L.keyBoxTop =
        L.accessDescHeight + 16

    L.statusTop =
        L.keyBoxTop
        + L.keyBoxHeight
        + 12

    L.buttonRowY =
        L.statusTop
        + 20
        + 12

    L.buttonRow2Y =
        L.buttonRowY
        + L.buttonHeight
        + 10

    L.accessHeight =
        if L.showSecondRow
        then L.buttonRow2Y + L.buttonHeight2
        else L.buttonRowY + L.buttonHeight

    L.premiumHeight =
        if L.showPerks
        then 155
        else 128

    L.bottomStack = 0

    if L.showPremium then

        L.bottomStack =
            L.bottomStack
            + L.premiumHeight
            + 16
    end

    L.mainAreaHeight =
        L.accessTop
        + L.accessHeight
        + 26
        + L.bottomStack
        + S.pad

    L.designWidth =
        L.sidebarWidthPx
        + L.contentGap
        + L.mainWidthPx

    L.designHeight =
        L.headerHeight
        + L.mainAreaHeight

    L.sidebarWidth =
        L.sidebarWidthPx
        / L.designWidth

    L.scale =
        math.clamp(
            math.min(
                (viewport.X * VIEWPORT_FILL)
                / L.designWidth,

                (viewport.Y * VIEWPORT_FILL)
                / L.designHeight
            ),
            UI_SCALE_MIN,
            UI_SCALE_MAX
        )

    return L
end

local Layout = GetLayoutProfile()

SidebarWidth =
    Layout.sidebarWidth

ContentGap =
    Layout.contentGap

--========================================================--
-- HELPERS
--========================================================--

local function New(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Tween(object, info, properties)
    local tween = TweenService:Create(
        object,
        info,
        properties
    )

    tween:Play()

    return tween
end

local function Corner(parent, radius)
    return New(
        "UICorner",
        {
            CornerRadius = UDim.new(0, radius)
        },
        parent
    )
end

local function Label(parent, text, size, color, font)
    return New(
        "TextLabel",
        {
            BackgroundTransparency = 1,
            Text = text,
            TextSize = size or 14,
            TextColor3 = color or Color3.new(1,1,1),
            Font = font or Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        },
        parent
    )
end

--========================================================--
-- BADGE ICONS
--
-- Uploaded Roblox image assets, so they resolve the same
-- under any executor. White line art, tinted at runtime
-- with ImageColor3 so one asset serves every accent.
--========================================================--

local Icons = {
    KEY = "rbxassetid://119819801304557",
    OK  = "rbxassetid://134149646701078",
    SBX = "rbxassetid://71077687547500",
    GAM = "rbxassetid://114005999404164",
    CFG = "rbxassetid://84117777196041",
    VIP = "rbxassetid://136929721495585",
    USR = "rbxassetid://71495885792368",
    EXE = "rbxassetid://82521083726920",
    DEV = "rbxassetid://84958026416125",
    AGE = "rbxassetid://97345034139438",
    PC  = "rbxassetid://112208605077789",
    TMR = "rbxassetid://94939390201202",
    SIG = "rbxassetid://84532892199173"
}

-- Draws a badge's icon, falling back to the old text code
-- if a badge has no artwork mapped yet.
local function BadgeGlyph(parent, code, size, color)

    local asset =
        Icons[code]

    if asset then

        return New(
            "ImageLabel",
            {
                Name = "Glyph",

                AnchorPoint =
                    Vector2.new(0.5, 0.5),

                Position =
                    UDim2.fromScale(0.5, 0.5),

                Size =
                    UDim2.fromOffset(size, size),

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Image = asset,

                ImageColor3 =
                    color
                    or PurpleBright,

                ScaleType =
                    Enum.ScaleType.Fit,

                ZIndex =
                    (parent.ZIndex or 1) + 1
            },
            parent
        )
    end

    local fallback =
        Label(
            parent,
            code,
            9,
            color or PurpleBright,
            Enum.Font.GothamBold
        )

    fallback.Name = "Glyph"

    fallback.Size =
        UDim2.fromScale(1, 1)

    fallback.TextXAlignment =
        Enum.TextXAlignment.Center

    fallback.ZIndex =
        (parent.ZIndex or 1) + 1

    return fallback
end

--========================================================--
-- INTRO ANIMATION REGISTRY
--========================================================--

local IntroElements = {}

local function Register(element, delay)
    table.insert(
        IntroElements,
        {
            element = element,
            delay = delay or 0
        }
    )
end

-- Kept so every existing call site still reads naturally.
-- Direction is no longer meaningful: everything rises.
local function RegisterText(label, _direction, delay)
    Register(label, delay)
end

local function RegisterButton(button, delay)
    Register(button, delay)
end

--========================================================--
-- ENTRANCE
--
-- The old intro typed each label out character by character
-- and blinked the buttons like a terminal booting. That is a
-- different UI's personality. Glass arrives by settling into
-- place: everything lifts a few pixels and resolves out of
-- nothing, staggered just enough to read as one motion.
--========================================================--

local function CollectFades(root)

    local list = {}

    local function add(o)

        if o:IsA("TextLabel")
        or o:IsA("TextButton")
        or o:IsA("TextBox") then
            table.insert(list, { o, "TextTransparency", o.TextTransparency })
        end

        if o:IsA("ImageLabel")
        or o:IsA("ImageButton") then
            table.insert(list, { o, "ImageTransparency", o.ImageTransparency })
        end

        if o:IsA("GuiObject") then
            table.insert(list, { o, "BackgroundTransparency", o.BackgroundTransparency })
        end

        if o:IsA("UIStroke") then
            table.insert(list, { o, "Transparency", o.Transparency })
        end
    end

    add(root)

    for _, d in ipairs(root:GetDescendants()) do
        add(d)
    end

    return list
end

local RISE =
    TweenInfo.new(
        0.55,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

local RESOLVE =
    TweenInfo.new(
        0.44,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

local function AnimateIn(element, delay)

    if not element or not element.Parent then
        return
    end

    local fades = CollectFades(element)
    local home = element.Position

    -- hide immediately so nothing flashes before its turn
    for _, f in ipairs(fades) do
        f[1][f[2]] = 1
    end

    element.Position =
        home + UDim2.fromOffset(0, 14)

    task.spawn(function()

        task.wait(delay or 0)

        if not Alive or not element.Parent then
            return
        end

        Tween(element, RISE, { Position = home })

        for _, f in ipairs(fades) do
            Tween(f[1], RESOLVE, { [f[2]] = f[3] })
        end
    end)
end

local function AnimateOut(element, delay)

    if not element or not element.Parent then
        return
    end

    local fades = CollectFades(element)

    task.spawn(function()

        task.wait(delay or 0)

        for _, f in ipairs(fades) do
            Tween(
                f[1],
                TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { [f[2]] = 1 }
            )
        end
    end)
end

--========================================================--
-- HACKER SCRAMBLE
--========================================================--

local HackerChars = {
    "0","1","A","B","C","D","E","F","G","H","I","J","K","L","M",
    "N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "#","@","$","%","&","*","!","?","<",">","/","\\","|","-","_","=","+"
}

local function RandomHackerChar()
    return HackerChars[
        math.random(
            1,
            #HackerChars
        )
    ]
end

local function HackerScramble(
    textBox,
    originalText,
    duration
)

    if not originalText
    or originalText == "" then
        return
    end

    local len =
        #originalText

    local endTime =
        os.clock()
        + duration

    local revealed = {}
    local chars = {}

    for i = 1, len do

        revealed[i] = false

        chars[i] =
            string.sub(
                originalText,
                i,
                i
            )
    end

    task.spawn(function()

        while os.clock() < endTime do

            if not textBox
            or not textBox.Parent then
                break
            end

            local display = ""

            for i = 1, len do

                if revealed[i] then

                    display =
                        display
                        .. chars[i]

                else

                    local roll =
                        math.random(
                            1,
                            4
                        )

                    if roll == 1 then

                        display =
                            display
                            .. " "

                    elseif roll == 2 then

                        display =
                            display
                            .. chars[i]

                    else

                        display =
                            display
                            .. RandomHackerChar()
                    end
                end
            end

            textBox.Text =
                display

            local timeLeft =
                endTime
                - os.clock()

            if timeLeft <
                duration * 0.35 then

                local idx =
                    math.random(
                        1,
                        len
                    )

                if not revealed[idx] then
                    revealed[idx] = true
                end
            end

            task.wait(0.045)
        end

        if textBox
        and textBox.Parent then

            textBox.Text =
                originalText
        end
    end)
end

--========================================================--
-- GUI ROOT
--========================================================--

local GUI =
    Instance.new(
        "ScreenGui"
    )

GUI.Name =
    "FishyHubReplica"

GUI.ResetOnSpawn =
    false

GUI.IgnoreGuiInset =
    true

GUI.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

GUI.Parent =
    game.CoreGui

--========================================================--
-- BACKDROP BLUR
--
-- Roblox has no blur on GUI objects, so the frost comes from
-- blurring the scene behind instead. The window is
-- translucent, so what shows through it is genuinely
-- defocused rather than faked with a texture - which is the
-- one thing that actually sells glass.
--========================================================--

local Lighting = game:GetService("Lighting")

local BLUR_SIZE = 18

local oldBlur = Lighting:FindFirstChild("FishyHubBlur")
if oldBlur then
    oldBlur:Destroy()
end

local Blur =
    New(
        "BlurEffect",
        {
            Name = "FishyHubBlur",
            Size = 0
        },
        Lighting
    )

local Backdrop =
    New(
        "Frame",
        {
            Size =
                UDim2.fromScale(
                    1,
                    1
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    9,
                    3,
                    18
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0
        },
        GUI
    )

local Main =
    New(
        "Frame",
        {
            Name =
                "MainWindow",

            AnchorPoint =
                Vector2.new(
                    0.5,
                    0.5
                ),

            Position =
                UDim2.fromScale(
                    0.5,
                    0.5
                ),

            Size =
                UDim2.fromOffset(
                    Layout.designWidth,
                    Layout.designHeight
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    13,
                    8,
                    24
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            ClipsDescendants = true
        },
        GUI
    )

--========================================================--
-- GLOBAL UI SCALE
--
-- Driven entirely by the viewport. No slider.
--========================================================--

local UIScale =
    New(
        "UIScale",
        {
            Scale =
                Layout.scale
        },
        Main
    )

local MainCorner =
    Corner(
        Main,
        Layout.cornerRadius
    )

New(
    "UIGradient",
    {
        Rotation = 115,

        Color =
            ColorSequence.new({
                ColorSequenceKeypoint.new(
                    0,
                    Color3.fromRGB(38, 22, 66)
                ),

                ColorSequenceKeypoint.new(
                    0.5,
                    Color3.fromRGB(15, 9, 27)
                ),

                ColorSequenceKeypoint.new(
                    1,
                    Color3.fromRGB(7, 3, 15)
                )
            }),

        Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.16),
                NumberSequenceKeypoint.new(1, 0.30)
            })
    },
    Main
)

--========================================================--
-- BORDER FACTORIES
--========================================================--

local function CreateAnimatedBorder(
    parent,
    thickness
)

    local stroke =
        New(
            "UIStroke",
            {
                ApplyStrokeMode =
                    Enum.ApplyStrokeMode.Border,

                Thickness =
                    thickness,

                Transparency =
                    0.18,

                Color =
                    Purple,

                LineJoinMode =
                    Enum.LineJoinMode.Round
            },
            parent
        )

    local gradient =
        New(
            "UIGradient",
            {
                Rotation = 0,

                Color =
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(
                            0.00,
                            PurpleDark
                        ),

                        ColorSequenceKeypoint.new(
                            0.28,
                            PurpleDark
                        ),

                        ColorSequenceKeypoint.new(
                            0.40,
                            Purple
                        ),

                        ColorSequenceKeypoint.new(
                            0.48,
                            Color3.fromRGB(
                                255,
                                245,
                                255
                            )
                        ),

                        ColorSequenceKeypoint.new(
                            0.56,
                            PurpleBright
                        ),

                        ColorSequenceKeypoint.new(
                            0.70,
                            PurpleDark
                        ),

                        ColorSequenceKeypoint.new(
                            1.00,
                            PurpleDark
                        )
                    }),

                Transparency =
                    NumberSequence.new({
                        NumberSequenceKeypoint.new(
                            0.00,
                            0.55
                        ),

                        NumberSequenceKeypoint.new(
                            0.34,
                            0.55
                        ),

                        NumberSequenceKeypoint.new(
                            0.43,
                            0.04
                        ),

                        NumberSequenceKeypoint.new(
                            0.50,
                            0.04
                        ),

                        NumberSequenceKeypoint.new(
                            0.57,
                            0.55
                        ),

                        NumberSequenceKeypoint.new(
                            1.00,
                            0.55
                        )
                    })
            },
            stroke
        )

    return stroke, gradient
end

-- The key field's original sweep: a white light travelling
-- around a dark edge. Deliberately not the purple one - the
-- contrast is what makes the field the focal point.
local function CreateMonoBorder(parent, thickness)

    local stroke =
        New(
            "UIStroke",
            {
                ApplyStrokeMode =
                    Enum.ApplyStrokeMode.Border,

                Thickness = thickness,

                Transparency = 0,

                Color =
                    Color3.fromRGB(200, 200, 200),

                LineJoinMode =
                    Enum.LineJoinMode.Round
            },
            parent
        )

    local gradient =
        New(
            "UIGradient",
            {
                Rotation = 0,

                Color =
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)),
                        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(120, 120, 120)),
                        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(120, 120, 120)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
                    }),

                Transparency =
                    NumberSequence.new({
                        NumberSequenceKeypoint.new(0.00, 0.80),
                        NumberSequenceKeypoint.new(0.28, 0.30),
                        NumberSequenceKeypoint.new(0.42, 0),
                        NumberSequenceKeypoint.new(0.50, 0),
                        NumberSequenceKeypoint.new(0.58, 0),
                        NumberSequenceKeypoint.new(0.72, 0.30),
                        NumberSequenceKeypoint.new(1.00, 0.80)
                    })
            },
            stroke
        )

    return stroke, gradient
end

local MainBorder, MainSweep =
    CreateAnimatedBorder(
        Main,
        1.4
    )

MainBorder.Transparency = 0.42

--========================================================--
-- MAIN FRAME EDGE
--
-- Real glass is brightest exactly at its edge and falls away
-- inward as the surface curves; a uniform stroke can only do
-- a flat line. This is a 9-sliced rim that is crisp on the
-- boundary and fades over roughly 7px, which is what gives
-- the panel a lensed edge instead of a drawn one.
--========================================================--

local GLASS_EDGE = "rbxassetid://108437916503362"

local MainLens =
    New(
        "ImageLabel",
        {
            Name = "GlassEdge",

            Size = UDim2.fromScale(1, 1),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image = GLASS_EDGE,

            ImageColor3 =
                Color3.fromRGB(226, 210, 255),

            ImageTransparency = 0.48,

            ScaleType = Enum.ScaleType.Slice,

            SliceCenter = Rect.new(50, 50, 78, 78),

            ZIndex = 150
        },
        Main
    )

New(
    "UIGradient",
    {
        Rotation = 104,

        Color =
            ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(232, 224, 255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(192, 166, 248))
            }),

        Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0),
                NumberSequenceKeypoint.new(0.50, 0.30),
                NumberSequenceKeypoint.new(1.00, 0.08)
            })
    },
    MainLens
)

-- Light arrives from above, so the top half of the pane
-- carries a wide, very faint sheen.
local MainSheen =
    New(
        "Frame",
        {
            Name = "Sheen",

            Size = UDim2.new(1, 0, 0.55, 0),

            BackgroundColor3 =
                Color3.fromRGB(255, 255, 255),

            BackgroundTransparency = 0,

            BorderSizePixel = 0,

            ZIndex = 3
        },
        Main
    )

-- Main clips to a rectangle, so a square sheen leaves a hard
-- nick inside each rounded corner. Round it to match.
local MainSheenCorner =
    Corner(MainSheen, 18)

New(
    "UIGradient",
    {
        Rotation = 90,

        Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.90),
                NumberSequenceKeypoint.new(0.55, 0.965),
                NumberSequenceKeypoint.new(1, 1)
            })
    },
    MainSheen
)

--========================================================--
-- STARS
--========================================================--

local Stars =
    New(
        "Frame",
        {
            Name = "Stars",


            BackgroundTransparency = 1,

            Size =
                UDim2.fromScale(
                    1,
                    1
                ),

            ClipsDescendants = true,

            -- Ambience sits behind everything. At ZIndex 50 it
            -- was drawing over the text like confetti.
            ZIndex = 1
        },
        Main
    )

local ICON_DOT = "rbxassetid://86707188750389"

-- Was a grid of "*" and "+" characters, which is the single
-- cheapest thing you can put on a screen. Same positions,
-- but each one is a soft radial light now.
local StarData = {
    { x=0.08, y=0.12, s=26, d=0.2 },
    { x=0.18, y=0.78, s=19, d=1.0 },
    { x=0.31, y=0.17, s=23, d=1.8 },
    { x=0.43, y=0.88, s=16, d=0.6 },
    { x=0.57, y=0.12, s=20, d=2.2 },
    { x=0.69, y=0.78, s=26, d=1.3 },
    { x=0.79, y=0.19, s=16, d=0.4 },
    { x=0.89, y=0.68, s=23, d=2.0 },
    { x=0.95, y=0.31, s=16, d=1.1 },
    { x=0.13, y=0.48, s=13, d=2.6 },
    { x=0.51, y=0.53, s=13, d=1.7 },
    { x=0.74, y=0.46, s=13, d=0.8 }
}

for _, data in ipairs(StarData) do

    local Spark =
        New(
            "ImageLabel",
            {
                Name = "Spark",

                AnchorPoint = Vector2.new(0.5, 0.5),

                Position =
                    UDim2.fromScale(data.x, data.y),

                Size =
                    UDim2.fromOffset(data.s, data.s),

                BackgroundTransparency = 1,

                Image = ICON_DOT,

                ImageColor3 = PurpleBright,

                ImageTransparency = 0.72,

                ZIndex = 1
            },
            Stars
        )

    task.spawn(function()

        task.wait(data.d)

        while Alive and GUI.Parent do

            Tween(
                Spark,
                TweenInfo.new(
                    1.6,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    ImageTransparency = 0.34,
                    Size = UDim2.fromOffset(
                        data.s * 1.22,
                        data.s * 1.22
                    )
                }
            )

            task.wait(1.6)

            Tween(
                Spark,
                TweenInfo.new(
                    2.1,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    ImageTransparency = 0.80,
                    Size = UDim2.fromOffset(data.s, data.s)
                }
            )

            task.wait(2.1 + math.random() * 1.8)
        end
    end)
end

--========================================================--
-- HEADER
--========================================================--

local Header =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    Layout.headerHeight
                ),

            ZIndex = 60
        },
        Main
    )

local Title =
    Label(
        Header,
        "Welcome to Fishy Studios",
        Layout.titleSize,
        TextPrimary,
        Enum.Font.GothamBold
    )

Title.AnchorPoint =
    Vector2.new(
        0.5,
        0
    )

Title.Position =
    UDim2.new(
        0.5,
        0,
        0,
        Layout.headerHeight * 0.18
    )

Title.Size =
    UDim2.new(
        0.38,
        0,
        0,
        35
    )

Title.TextXAlignment =
    Enum.TextXAlignment.Center

RegisterText(
    Title,
    "top",
    0.42
)

local Subtitle =
    Label(
        Header,
        "Updated v2.1 2026",
        Layout.subtitleSize,
        TextSecondary,
        Enum.Font.GothamBold
    )

Subtitle.AnchorPoint =
    Vector2.new(
        0.5,
        0
    )

Subtitle.Position =
    UDim2.new(
        0.5,
        0,
        0,
        Layout.headerHeight * 0.52
    )

Subtitle.Size =
    UDim2.new(
        0.4,
        0,
        0,
        20
    )

Subtitle.TextXAlignment =
    Enum.TextXAlignment.Center

RegisterText(
    Subtitle,
    "bottom",
    0.52
)

--========================================================--
-- HEADER BUTTONS
--========================================================--

-- Window controls are the glyph and nothing else. The pill
-- only exists on hover, which is what stops them reading as
-- two purple stickers taped to the corner.
local ICON_MINUS = "rbxassetid://121519828362903"
local ICON_CLOSE = "rbxassetid://134971182356531"

local function WindowControl(icon, xOffset, hoverTint, size)

    local Btn =
        New(
            "TextButton",
            {
                Text = "",

                BackgroundTransparency = 1,
                BorderSizePixel = 0,

                Position =
                    UDim2.new(
                        1,
                        xOffset,
                        0,
                        Layout.headerHeight * 0.5 - 19
                    ),

                Size =
                    UDim2.fromOffset(38, 38),

                AutoButtonColor = false,

                ZIndex = 65
            },
            Header
        )

    local Glyph =
        New(
            "ImageLabel",
            {
                Name = "Glyph",

                AnchorPoint = Vector2.new(0.5, 0.5),

                Position = UDim2.fromScale(0.5, 0.5),

                Size = UDim2.fromOffset(size, size),

                BackgroundTransparency = 1,

                Image = icon,

                ImageColor3 =
                    Color3.fromRGB(178, 160, 205),

                ImageTransparency = 0.1,

                ScaleType = Enum.ScaleType.Fit,

                ZIndex = 66
            },
            Btn
        )

    -- No plate on hover either. The glyph itself is the
    -- affordance: it just comes up to full white.
    Btn.MouseEnter:Connect(
        function()

            Tween(Glyph, Fast, {
                ImageColor3 = hoverTint,
                ImageTransparency = 0
            })
        end
    )

    Btn.MouseLeave:Connect(
        function()

            Tween(Glyph, Fast, {
                ImageColor3 = Color3.fromRGB(178, 160, 205),
                ImageTransparency = 0.1
            })
        end
    )

    return Btn
end

local Minimize =
    WindowControl(
        ICON_MINUS,
        -100,
        Color3.fromRGB(255, 252, 255),
        13
    )

RegisterButton(
    Minimize,
    0.70
)

local Close =
    WindowControl(
        ICON_CLOSE,
        -56,
        Color3.fromRGB(255, 176, 198),
        12
    )

RegisterButton(
    Close,
    0.76
)

--========================================================--
-- CONTENT
--========================================================--

local Content =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    Layout.headerHeight
                ),

            Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    -Layout.headerHeight
                ),

            ClipsDescendants = true,
            ZIndex = 5
        },
        Main
    )

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar =
    New(
        "Frame",
        {
            Name = "Sidebar",

            -- Painted by SidebarFill below, not by the frame
            -- itself. See the note there.
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Size =
                UDim2.new(
                    SidebarWidth,
                    0,
                    1,
                    0
                ),

            ClipsDescendants = true,
            ZIndex = 10
        },
        Content
    )

--========================================================--
-- SIDEBAR BACKGROUND
--
-- Main has a UICorner, but ClipsDescendants still clips to
-- a rectangle, so anything painting the sidebar squares off
-- the window's bottom-left corner. Fix: give the fill its
-- own UICorner and oversize it past the top and right edges
-- of a clipping parent, so only the bottom-left rounding
-- survives. Overlapping translucent patches would composite
-- twice and leave a visible seam - this never overlaps.
--========================================================--

local function RoundedBottomLeft(
    parent,
    name,
    position,
    size,
    color,
    transparency,
    zIndex,
    radius
)

    local clip =
        New(
            "Frame",
            {
                Name = name .. "Clip",

                Position = position,
                Size = size,

                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,

                ZIndex = zIndex
            },
            parent
        )

    local fill =
        New(
            "Frame",
            {
                Name = name,

                Position =
                    UDim2.new(0, 0, 0, -radius),

                Size =
                    UDim2.new(1, radius, 1, radius),

                BackgroundColor3 = color,

                BackgroundTransparency = transparency,

                BorderSizePixel = 0,

                ZIndex = zIndex
            },
            clip
        )

    local corner =
        Corner(fill, radius)

    -- With the divider gone the sidebar has to end by fading,
    -- not by stopping. This carries its tint out to nothing
    -- across the last fifth so the two halves read as one pane.
    New(
        "UIGradient",
        {
            Rotation = 0,

            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 0),
                    NumberSequenceKeypoint.new(0.62, 0.10),
                    NumberSequenceKeypoint.new(0.88, 0.55),
                    NumberSequenceKeypoint.new(1.00, 0.92)
                })
        },
        fill
    )

    return clip, fill, corner
end

-- It used to be its own purple slab, which is most of why it
-- read as a separate panel bolted to the side. Same dark as
-- the window now, at a whisper - just enough to seat the
-- cards, and it fades out before the content anyway.
local SidebarPanel =
    Color3.fromRGB(16, 10, 30)

local SidebarFillClip, SidebarFill, SidebarFillCorner =
    RoundedBottomLeft(
        Sidebar,
        "SidebarFill",
        UDim2.fromScale(0, 0),
        UDim2.fromScale(1, 1),
        SidebarPanel,
        0.86,
        9,
        Layout.cornerRadius
    )

--========================================================--
-- PROFILE
--========================================================--

local ProfileToggle =
    New(
        "TextButton",
        {
            BackgroundTransparency = 1,
            Text = "",

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    210
                ),

            AutoButtonColor = false,
            ZIndex = 30
        },
        Sidebar
    )

local Avatar =
    New(
        "Frame",
        {
            AnchorPoint =
                Vector2.new(
                    0.5,
                    0
                ),

            Position =
                UDim2.new(
                    0.5,
                    0,
                    0,
                    30
                ),

            Size =
                UDim2.fromOffset(
                    108,
                    108
                ),

            BackgroundColor3 =
                Color3.fromRGB(150, 108, 240),

            BackgroundTransparency =
                0.62,

            BorderSizePixel = 0,
            ZIndex = 15
        },
        Sidebar
    )

Corner(
    Avatar,
    100
)

New(
    "UIStroke",
    {
        Color =
            Color3.fromRGB(228, 210, 255),

        Thickness = 1.4,

        Transparency = 0.34
    },
    Avatar
)

local AvatarImage =
    New(
        "ImageLabel",
        {
            AnchorPoint =
                Vector2.new(
                    0.5,
                    0.5
                ),

            Position =
                UDim2.fromScale(
                    0.5,
                    0.5
                ),

            Size =
                UDim2.fromOffset(
                    100,
                    100
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    24,
                    14,
                    38
                ),

            BackgroundTransparency =
                0.15,

            BorderSizePixel = 0,

            ZIndex = 16,

            Image = ""
        },
        Avatar
    )

Corner(
    AvatarImage,
    100
)

local AvatarFallback =
    Label(
        AvatarImage,
        "AV",
        28,
        PurpleBright,
        Enum.Font.GothamBlack
    )

AvatarFallback.Size =
    UDim2.fromScale(
        1,
        1
    )

AvatarFallback.TextXAlignment =
    Enum.TextXAlignment.Center

AvatarFallback.ZIndex = 17

task.spawn(function()

    local content, isReady =
        Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )

    if isReady then

        AvatarImage.Image =
            content

        AvatarFallback.Visible =
            false
    end
end)

local Online =
    New(
        "Frame",
        {
            AnchorPoint =
                Vector2.new(
                    1,
                    1
                ),

            Position =
                UDim2.new(
                    1,
                    -1,
                    1,
                    -1
                ),

            Size =
                UDim2.fromOffset(
                    18,
                    18
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    55,
                    225,
                    174
                ),

            BorderSizePixel = 0,
            ZIndex = 20
        },
        Avatar
    )

Corner(
    Online,
    100
)

New(
    "UIStroke",
    {
        Color =
            Color3.fromRGB(16, 10, 30),

        Thickness = 2.5
    },
    Online
)

local Username =
    Label(
        Sidebar,
        LocalPlayer.DisplayName,
        18,
        TextPrimary,
        Enum.Font.GothamBold
    )

Username.AnchorPoint =
    Vector2.new(
        0.5,
        0
    )

Username.Position =
    UDim2.new(
        0.5,
        0,
        0,
        150
    )

Username.Size =
    UDim2.new(
        1,
        -20,
        0,
        27
    )

Username.TextXAlignment =
    Enum.TextXAlignment.Center

Username.TextScaled =
    true

RegisterText(
    Username,
    "left",
    0.60
)

local Handle =
    Label(
        Sidebar,
        "@" .. LocalPlayer.Name,
        12,
        TextSecondary,
        Enum.Font.GothamBold
    )

Handle.AnchorPoint =
    Vector2.new(
        0.5,
        0
    )

Handle.Position =
    UDim2.new(
        0.5,
        0,
        0,
        178
    )

Handle.Size =
    UDim2.new(
        1,
        -20,
        0,
        20
    )

Handle.TextXAlignment =
    Enum.TextXAlignment.Center

Handle.TextTruncate =
    Enum.TextTruncate.AtEnd

RegisterText(
    Handle,
    "right",
    0.65
)

--========================================================--
-- SIDEBAR RESIZE HANDLE
--========================================================--

-- The grab target stays generous; the thing you actually see
-- is a single soft grip that grows and brightens as you take
-- hold of it. No plate, no typed pipe characters.
local ResizeHandle =
    New(
        "TextButton",
        {
            Name =
                "SidebarResizeHandle",

            AnchorPoint =
                Vector2.new(0.5, 0.5),

            Position =
                UDim2.new(1, 0, 0.5, 0),

            Size =
                UDim2.fromOffset(18, 104),

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Text = "",

            AutoButtonColor = false,

            ZIndex = 100
        },
        Sidebar
    )

local ResizeLine =
    New(
        "Frame",
        {
            Name = "Grip",

            AnchorPoint =
                Vector2.new(0.5, 0.5),

            Position =
                UDim2.fromScale(0.5, 0.5),

            Size =
                UDim2.fromOffset(3, 40),

            BackgroundColor3 =
                PurpleBright,

            BackgroundTransparency = 0.55,

            BorderSizePixel = 0,

            ZIndex = 101
        },
        ResizeHandle
    )

Corner(
    ResizeLine,
    2
)

--========================================================--
-- MAIN AREA
--========================================================--

local MainArea =
    New(
        "Frame",
        {
            Name = "MainArea",

            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    SidebarWidth,
                    ContentGap,
                    0,
                    0
                ),

            Size =
                UDim2.new(
                    1 - SidebarWidth,
                    -ContentGap,
                    1,
                    0
                ),

            ZIndex = 2
        },
        Content
    )

--========================================================--
-- SIDEBAR DETAILS
--========================================================--

local Details =
    New(
        "Frame",
        {
            Name = "SidebarDetails",

            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    220
                ),

            Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    -220
                ),

            ClipsDescendants = true
        },
        Sidebar
    )

--========================================================--
-- SIDEBAR CARDS
--
-- The sidebar was a flat wall of text rows while every other
-- surface had become glass, which is what made it read as a
-- different UI bolted on. These are the same material at its
-- quietest weight - present enough to group a row, far too
-- faint to compete with the buttons.
--========================================================--

local function GlassCard(parent, pos, size, zIndex)

    local Card =
        New(
            "Frame",
            {
                Name = "Card",

                Position = pos,
                Size = size,

                BackgroundColor3 =
                    Color3.fromRGB(120, 96, 186),

                BackgroundTransparency = 0.82,

                BorderSizePixel = 0,

                ZIndex = zIndex or 1
            },
            parent
        )

    Corner(Card, 12)

    New(
        "UIGradient",
        {
            Rotation = 90,

            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.28),
                    NumberSequenceKeypoint.new(1, 0.62)
                })
        },
        Card
    )

    New(
        "UIStroke",
        {
            ApplyStrokeMode =
                Enum.ApplyStrokeMode.Border,

            Thickness = 1,

            Color =
                Color3.fromRGB(178, 156, 224),

            Transparency = 0.80
        },
        Card
    )

    New(
        "ImageLabel",
        {
            Name = "GlassEdge",

            Size = UDim2.fromScale(1, 1),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image = GLASS_EDGE,

            ImageColor3 =
                Color3.fromRGB(206, 190, 246),

            ImageTransparency = 0.82,

            ScaleType = Enum.ScaleType.Slice,

            SliceCenter = Rect.new(50, 50, 78, 78),

            SliceScale = 12 / 18,

            ZIndex = (zIndex or 1) + 1
        },
        Card
    )

    return Card
end

local function InfoRow(
    y,
    badgeText,
    title,
    value,
    color
)

    local Row =
        GlassCard(
            Details,
            UDim2.new(0, 20, 0, y),
            UDim2.new(1, -40, 0, 48),
            1
        )

    local Badge =
        New(
            "Frame",
            {
                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Position =
                    UDim2.new(
                        0,
                        10,
                        0,
                        4
                    ),

                Size =
                    UDim2.fromOffset(
                        34,
                        28
                    ),

                ZIndex = 3
            },
            Row
        )



    local BText =
        BadgeGlyph(
            Badge,
            badgeText,
            16
        )

    local T =
        Label(
            Row,
            title,
            10,
            TextMuted
        )

    T.Position =
        UDim2.new(0, 52, 0, 5)

    T.Size =
        UDim2.new(1, -62, 0, 16)

    T.ZIndex = 3

    local VText =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Text = value,

                TextSize = 12,

                TextColor3 =
                    color
                    or TextPrimary,

                Font =
                    Enum.Font.GothamBold,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                Position =
                    UDim2.new(0, 52, 0, 21),

                Size =
                    UDim2.new(1, -62, 0, 22),

                ZIndex = 3,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            },
            Row
        )

    return VText
end

--========================================================--
-- HWID
--========================================================--

local function GetHWID()

    if gethwid then

        local ok, r =
            pcall(
                gethwid
            )

        if ok and r then
            return tostring(r)
        end
    end

    if get_hwid then

        local ok, r =
            pcall(
                get_hwid
            )

        if ok and r then
            return tostring(r)
        end
    end

    return "FHW-"
        .. tostring(
            LocalPlayer.UserId
        )
        .. "-"
        .. string.sub(
            tostring(game.PlaceId),
            1,
            6
        )
end

local hwidString =
    GetHWID()

-- The row is 200px wide and a HWID is 36 characters, so the
-- full string could only ever be a truncated stub. Show a
-- digest instead; the click still copies the whole value.
local function ShortHWID(value)

    if #value <= 22 then
        return value
    end

    return string.sub(value, 1, 10)
        .. "..."
        .. string.sub(value, -6)
end

local HWIDRow =
    GlassCard(
        Details,
        UDim2.new(0, 20, 0, 162),
        UDim2.new(1, -40, 0, 48),
        1
    )

local HWIDBadge =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    4
                ),

            Size =
                UDim2.fromOffset(
                    34,
                    28
                ),

            ZIndex = 3
        },
        HWIDRow
    )



local HWIDBadgeText =
    BadgeGlyph(
        HWIDBadge,
        "PC",
        16
    )

local HWIDTitle =
    Label(
        HWIDRow,
        "HWID",
        10,
        TextMuted
    )

HWIDTitle.Position =
    UDim2.new(0, 52, 0, 5)

HWIDTitle.Size =
    UDim2.new(1, -62, 0, 16)

HWIDTitle.ZIndex = 3

local HWIDValue =
    New(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Text = ShortHWID(hwidString),

            TextSize = 12,

            TextColor3 =
                TextPrimary,

            Font =
                Enum.Font.GothamBold,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            Position =
                UDim2.new(0, 52, 0, 21),

            Size =
                UDim2.new(1, -62, 0, 22),

            ZIndex = 3,

            TextTruncate =
                Enum.TextTruncate.AtEnd
        },
        HWIDRow
    )

local HWIDButton =
    New(
        "TextButton",
        {
            BackgroundTransparency = 1,
            Text = "",

            Size =
                UDim2.fromScale(1, 1),

            Position =
                UDim2.fromScale(0, 0),

            AutoButtonColor = false,
            ZIndex = 10
        },
        HWIDRow
    )

HWIDButton.MouseEnter:Connect(
    function()
        Tween(HWIDRow, Fast, { BackgroundTransparency = 0.68 })
    end
)

HWIDButton.MouseLeave:Connect(
    function()
        Tween(HWIDRow, Fast, { BackgroundTransparency = 0.82 })
    end
)

local function CopyHWID()

    pcall(function()

        if setclipboard then

            setclipboard(
                hwidString
            )
        end
    end)

    Tween(
        HWIDValue,
        Fast,
        {
            TextTransparency = 1
        }
    )

    task.wait(
        0.18
    )

    HWIDValue.Text =
        "Copied!"

    Tween(
        HWIDValue,
        Fast,
        {
            TextTransparency = 0
        }
    )

    task.wait(
        1.2
    )

    Tween(
        HWIDValue,
        Fast,
        {
            TextTransparency = 1
        }
    )

    task.wait(
        0.18
    )

    HWIDValue.Text =
        ShortHWID(hwidString)

    Tween(
        HWIDValue,
        Fast,
        {
            TextTransparency = 0
        }
    )
end

HWIDButton.MouseButton1Click:Connect(
    function()
        task.spawn(
            CopyHWID
        )
    end
)

HWIDButton.MouseEnter:Connect(
    function()

        Tween(
            HWIDValue,
            Fast,
            {
                TextColor3 =
                    TextAccent
            }
        )
    end
)

HWIDButton.MouseLeave:Connect(
    function()

        Tween(
            HWIDValue,
            Fast,
            {
                TextColor3 =
                    TextPrimary
            }
        )
    end
)

--========================================================--
-- OTHER INFO ROWS
--========================================================--

local ExecutorName =
    "Unknown"

if identifyexecutor then

    pcall(function()

        ExecutorName =
            identifyexecutor()
    end)
end

local DeviceType =
    "PC"

if UserInputService.TouchEnabled
and not UserInputService.KeyboardEnabled then

    DeviceType =
        "Mobile"

elseif UserInputService.GamepadEnabled
and not UserInputService.KeyboardEnabled then

    DeviceType =
        "Console"
end

InfoRow(
    0,
    "EXE",
    "Executor",
    ExecutorName
)

InfoRow(
    54,
    "DEV",
    "Device",
    DeviceType
)

InfoRow(
    108,
    "AGE",
    "Account Age",
    tostring(
        LocalPlayer.AccountAge
    )
    .. " Days"
)

local GameRowText =
    InfoRow(
        216,
        "GAM",
        "Game",
        game.Name,
        Color3.fromRGB(
            60,
            215,
            175
        )
    )

task.spawn(function()

    pcall(function()

        if game.PlaceId > 0 then

            local info =
                MarketplaceService:GetProductInfo(
                    game.PlaceId
                )

            GameRowText.Text =
                info.Name
        end
    end)
end)

--========================================================--
-- SESSION + PING
--========================================================--

local Stats =
    GlassCard(
        Details,
        UDim2.new(0, 20, 1, -70),
        UDim2.new(1, -40, 0, 58),
        1
    )

local TimerBadge =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Position =
                UDim2.new(0, 10, 0.5, -14),

            Size =
                UDim2.fromOffset(34, 28),

            ZIndex = 3
        },
        Stats
    )



local TBT =
    BadgeGlyph(
        TimerBadge,
        "TMR",
        16
    )

local Session =
    Label(
        Stats,
        "Session\n00:00",
        11,
        TextSecondary
    )

Session.Position =
    UDim2.new(0, 52, 0, 0)

Session.Size =
    UDim2.new(0.5, -52, 1, 0)

Session.ZIndex = 3

local PingBadge =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Position =
                UDim2.new(0.52, 0, 0.5, -14),

            Size =
                UDim2.fromOffset(34, 28),

            ZIndex = 3
        },
        Stats
    )



local PBT =
    BadgeGlyph(
        PingBadge,
        "SIG",
        16
    )

local Ping =
    Label(
        Stats,
        "Ping\n0 ms",
        11,
        TextSecondary
    )

Ping.Position =
    UDim2.new(0.52, 42, 0, 0)

Ping.Size =
    UDim2.new(0.48, -52, 1, 0)

Ping.ZIndex = 3

local StartTime =
    os.clock()

task.spawn(function()

    while Alive
    and GUI.Parent do

        local elapsed =
            os.clock()
            - StartTime

        Session.Text =
            string.format(
                "Session\n%02d:%02d",
                math.floor(
                    elapsed / 60
                ),
                math.floor(
                    elapsed % 60
                )
            )

        local currentPing =
            0

        pcall(function()

            currentPing =
                math.round(
                    LocalPlayer:GetNetworkPing()
                    * 1000
                )
        end)

        Ping.Text =
            string.format(
                "Ping\n%d ms",
                currentPing
            )

        task.wait(
            1
        )
    end
end)

--========================================================--
-- SERVICE HEADER
--========================================================--

local ServiceImage =
    New(
        "ImageLabel",
        {
            Name = "FishyLogo",

            Position =
                UDim2.new(
                    0,
                    Layout.contentPadding,
                    0,
                    52
                ),

            Size =
                UDim2.fromOffset(
                    Layout.logoWidth,
                    Layout.logoHeight
                ),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image =
                "rbxassetid://136903081591226",

            ScaleType =
                Enum.ScaleType.Fit,

            ZIndex = 5
        },
        MainArea
    )

local Active =
    Label(
        MainArea,
        "ACTIVE SERVICE",
        10,
        TextAccent,
        Enum.Font.GothamBold
    )

Active.Position =
    UDim2.new(
        0,
        Layout.contentPadding + Layout.serviceTextX,
        0,
        34
    )

Active.Size =
    UDim2.new(
        0.4,
        0,
        0,
        18
    )

RegisterText(
    Active,
    "top",
    0.40
)

local ServiceName =
    Label(
        MainArea,
        "Fishy Hub",
        19,
        TextPrimary,
        Enum.Font.GothamBold
    )

ServiceName.Position =
    UDim2.new(
        0,
        Layout.contentPadding + Layout.serviceTextX,
        0,
        55
    )

ServiceName.Size =
    UDim2.new(
        0.5,
        0,
        0,
        27
    )

RegisterText(
    ServiceName,
    "left",
    0.45
)

local Delivery =
    Label(
        MainArea,
        "Verified: Satisfaction Guaranteed",
        12,
        TextSecondary,
        Enum.Font.GothamBold
    )

Delivery.Position =
    UDim2.new(
        0,
        Layout.contentPadding + Layout.serviceTextX,
        0,
        83
    )

Delivery.Size =
    UDim2.new(
        0.5,
        0,
        0,
        22
    )

RegisterText(
    Delivery,
    "bottom",
    0.50
)

--========================================================--
-- ACCESS PANEL
--========================================================--

local Access =
    New(
        "Frame",
        {
            Name = "Access",

            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    Layout.contentPadding,
                    0,
                    145
                ),

            Size =
                UDim2.new(
                    1,
                    -Layout.contentPadding * 2,
                    1,
                    -310
                )
        },
        MainArea
    )

local AccessTitle =
    Label(
        Access,
        "SECURE ACCESS",
        11,
        TextAccent,
        Enum.Font.GothamBold
    )

AccessTitle.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )

AccessTitle.Size =
    UDim2.new(
        1,
        0,
        0,
        20
    )

RegisterText(
    AccessTitle,
    "left",
    0.55
)

local AccessDesc =
    Label(
        Access,
        "One Key. All Features. All Supported Games.",
        12,
        TextSecondary,
        Enum.Font.GothamBold
    )

AccessDesc.Position =
    UDim2.new(
        0,
        0,
        0,
        23
    )

AccessDesc.Size =
    UDim2.new(
        1,
        0,
        0,
        22
    )

RegisterText(
    AccessDesc,
    "right",
    0.58
)

--========================================================--
-- KEY BOX
--========================================================--

local KeyBox =
    New(
        "Frame",
        {
            Name = "KeyBox",

            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    61
                ),

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    Layout.keyBoxHeight
                ),

            BackgroundColor3 =
                Color3.fromRGB(26, 17, 46),

            BackgroundTransparency =
                0.30,

            BorderSizePixel = 0
        },
        Access
    )

Corner(
    KeyBox,
    15
)

New(
    "UIGradient",
    {
        Rotation = 90,

        Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.10),
                NumberSequenceKeypoint.new(1, 0.34)
            })
    },
    KeyBox
)

local KeyLens =
    New(
        "ImageLabel",
        {
            Name = "GlassEdge",

            Size = UDim2.fromScale(1, 1),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image = GLASS_EDGE,

            ImageColor3 =
                Color3.fromRGB(224, 214, 248),

            ImageTransparency = 0.66,

            ScaleType = Enum.ScaleType.Slice,

            SliceCenter = Rect.new(50, 50, 78, 78),

            SliceScale = 15 / 18,

            ZIndex = 4
        },
        KeyBox
    )

local KeyBorder, KeySweep =
    CreateMonoBorder(
        KeyBox,
        1.6
    )

KeyBorder.Transparency = 0.30

local KeyFocused = false

local KeyBadge =
    New(
        "Frame",
        {
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Position =
                UDim2.new(
                    0,
                    16,
                    0.5,
                    -16
                ),

            Size =
                UDim2.fromOffset(
                    42,
                    32
                ),

            ZIndex = 6
        },
        KeyBox
    )



local KeyBadgeText =
    BadgeGlyph(
        KeyBadge,
        "KEY",
        19
    )

KeyBadgeText.ZIndex =
    7

local KeyText =
    New(
        "TextBox",
        {
            Name = "KeyInput",

            BackgroundTransparency = 1,

            Text = "",

            PlaceholderText =
                "Enter your key here...",

            PlaceholderColor3 =
                TextMuted,

            TextSize =
                if Layout.isMobile
                then 12
                else 13,

            TextColor3 =
                TextPrimary,

            Font =
                Enum.Font.GothamBold,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            ClearTextOnFocus = false,

            MultiLine = false,

            Position =
                UDim2.new(
                    0,
                    68,
                    0,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -80,
                    1,
                    0
                ),

            ClipsDescendants = true,

            ZIndex = 5
        },
        KeyBox
    )

--========================================================--
-- PREFILL CURRENT KEY
--========================================================--

local prefilledKey =
    savedKey
    or getgenv().SCRIPT_KEY
    or ""

if prefilledKey ~= ""
and prefilledKey ~= "KEYLESS" then

    KeyText.Text =
        prefilledKey
end

KeyText.Focused:Connect(
    function()

        KeyFocused = true

        Tween(KeyBorder, Fast, {
            Transparency = 0,
            Thickness = 2.6
        })

        Tween(KeyLens, Fast, {
            ImageTransparency = 0.44
        })

        Tween(KeyBox, Fast, {
            BackgroundTransparency = 0.18
        })
    end
)

KeyText.FocusLost:Connect(
    function()

        KeyFocused = false

        Tween(KeyBorder, Fast, {
            Transparency = 0.30,
            Thickness = 1.6
        })

        Tween(KeyLens, Fast, {
            ImageTransparency = 0.66
        })

        Tween(KeyBox, Fast, {
            BackgroundTransparency = 0.30
        })
    end
)

--========================================================--
-- KEY STATUS
--========================================================--

local initialStatusText
local initialStatusColor

if StartupKeyless then

    initialStatusText =
        "Keyless access granted."

    initialStatusColor =
        Color3.fromRGB(
            100,
            255,
            100
        )

elseif StartupKeyValid then

    initialStatusText =
        "Key loaded — verified."

    initialStatusColor =
        Color3.fromRGB(
            100,
            255,
            100
        )

elseif savedKey then

    initialStatusText =
        "Saved key is invalid — please verify again."

    initialStatusColor =
        Color3.fromRGB(
            255,
            100,
            100
        )

else

    initialStatusText =
        "Awaiting key verification..."

    initialStatusColor =
        TextSecondary
end

local StatusLabel =
    New(
        "TextLabel",
        {
            Name = "StatusLabel",

            BackgroundTransparency = 1,

            Text =
                initialStatusText,

            TextSize = 11,

            TextColor3 =
                initialStatusColor,

            Font =
                Enum.Font.GothamBold,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    Layout.keyBoxHeight + 62
                ),

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    20
                )
        },
        Access
    )

RegisterText(
    StatusLabel,
    "bottom",
    0.68
)

local function SetStatus(
    text,
    color
)

    StatusLabel.Text =
        text

    StatusLabel.TextColor3 =
        color
        or TextSecondary
end

--========================================================--
-- GLASS
--
-- One material for every button in the UI. Restrained,
-- iOS-style: the pane is mostly clear and most of the glass
-- is edge work - a hairline rim lit along the top, dim
-- through the middle, lifting again underneath, plus a fine
-- specular on the top edge. No coloured halo, no travelling
-- shine. Weight sets presence, never a different material,
-- so a screen of these still reads as one system.
--========================================================--

local GLASS_GLOW =
    "rbxassetid://99623734860368"

local GlassWeights = {

    -- the call to action
    primary = {
        tint        = Color3.fromRGB(176, 138, 255),
        rim         = Color3.fromRGB(236, 220, 255),
        body        = 0.50,
        bodyHover   = 0.35,
        rimRest     = 0.40,
        rimHover    = 0.18,
        shadowRest  = 0.66,
        shadowHover = 0.55,
        text        = Color3.fromRGB(255, 253, 255)
    },

    -- the commit action: same family, deeper glass
    secondary = {
        tint        = Color3.fromRGB(122, 76, 220),
        rim         = Color3.fromRGB(214, 188, 255),
        body        = 0.44,
        bodyHover   = 0.29,
        rimRest     = 0.44,
        rimHover    = 0.20,
        shadowRest  = 0.68,
        shadowHover = 0.57,
        text        = Color3.fromRGB(252, 248, 255)
    },

    -- everything else: present, never competing
    tertiary = {
        tint        = Color3.fromRGB(102, 72, 172),
        rim         = Color3.fromRGB(190, 166, 236),
        body        = 0.74,
        bodyHover   = 0.59,
        rimRest     = 0.60,
        rimHover    = 0.36,
        shadowRest  = 0.80,
        shadowHover = 0.70,
        text        = Color3.fromRGB(238, 232, 250)
    }
}

local function GlassButton(
    parent,
    badgeCode,
    text,
    pos,
    size,
    weight
)

    local W =
        GlassWeights[weight]
        or GlassWeights.tertiary

    local tint      = W.tint
    local rimColor  = W.rim
    local restBody  = W.body
    local hoverBody = W.bodyHover
    local restRim   = W.rimRest
    local hoverRim  = W.rimHover

    local Button =
        New(
            "TextButton",
            {
                Name =
                    (text:gsub("%s+", ""))
                    .. "Btn",

                Text = "",

                BackgroundTransparency = 1,
                BorderSizePixel = 0,

                Position = pos,
                Size = size,

                AutoButtonColor = false,

                ZIndex = 3
            },
            parent
        )

    -- Just enough shadow to lift the pane off the panel.
    local Shadow =
        New(
            "ImageLabel",
            {
                Name = "Shadow",

                AnchorPoint =
                    Vector2.new(0.5, 0.5),

                Position =
                    UDim2.new(0.5, 0, 0.5, 6),

                -- Large, faint and diffuse rather than tight and
                -- dark. SliceScale grows the falloff itself, and
                -- the size keeps the texture's shape edge locked
                -- to the button's edge (28px inset x 1.25 x 2).
                Size =
                    UDim2.new(1, 70, 1, 70),

                SliceScale = 1.25,

                BackgroundTransparency = 1,

                Image = GLASS_GLOW,

                ImageColor3 =
                    Color3.fromRGB(3, 1, 8),

                ImageTransparency = W.shadowRest,

                ScaleType =
                    Enum.ScaleType.Slice,

                SliceCenter =
                    Rect.new(50, 50, 78, 78),

                ZIndex = 3
            },
            Button
        )

    local Body =
        New(
            "Frame",
            {
                Name = "Body",

                Size =
                    UDim2.fromScale(1, 1),

                BackgroundColor3 = tint,

                BackgroundTransparency = restBody,

                BorderSizePixel = 0,

                ZIndex = 5
            },
            Button
        )

    Corner(Body, 15)

    -- Light catches the top edge and then lets go. A long
    -- white ramp down the face is what makes a pane read as
    -- glossy plastic instead of glass, so it dies out fast.
    New(
        "UIGradient",
        {
            Rotation = 96,

            Color =
                ColorSequence.new({
                    ColorSequenceKeypoint.new(
                        0,
                        Color3.fromRGB(255, 255, 255)
                    ),

                    ColorSequenceKeypoint.new(0.20, tint),

                    ColorSequenceKeypoint.new(1, tint)
                }),

            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.30),
                    NumberSequenceKeypoint.new(0.22, 0.46),
                    NumberSequenceKeypoint.new(0.70, 0.50),
                    NumberSequenceKeypoint.new(1, 0.40)
                })
        },
        Body
    )

    local Rim =
        New(
            "UIStroke",
            {
                ApplyStrokeMode =
                    Enum.ApplyStrokeMode.Border,

                Thickness = 1,

                Color = rimColor,

                Transparency = restRim
            },
            Body
        )

    -- Bright along the top edge, faint through the middle,
    -- lifting again underneath - how a glass edge catches light.
    -- Tilted off vertical so the highlight isn't perfectly
    -- symmetrical, which is the tell of a drawn gradient.
    New(
        "UIGradient",
        {
            Rotation = 102,

            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.06),
                    NumberSequenceKeypoint.new(0.50, 0.78),
                    NumberSequenceKeypoint.new(1, 0.34)
                })
        },
        Rim
    )

    -- Same lensed edge as the window, scaled to this radius.
    local Lens =
        New(
            "ImageLabel",
            {
                Name = "GlassEdge",

                Size = UDim2.fromScale(1, 1),

                BackgroundTransparency = 1,
                BorderSizePixel = 0,

                Image = GLASS_EDGE,

                ImageColor3 = rimColor,

                ImageTransparency = 0.62,

                ScaleType = Enum.ScaleType.Slice,

                SliceCenter = Rect.new(50, 50, 78, 78),

                SliceScale = 15 / 18,

                ZIndex = 6
            },
            Body
        )

    -- Real glass splits light slightly as it passes through the
    -- edge, so the rim is never one flat colour: cool where it
    -- catches, violet where it falls away.
    New(
        "UIGradient",
        {
            Rotation = 102,

            Color =
                ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(228, 219, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(196, 172, 250))
                }),

            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 0),
                    NumberSequenceKeypoint.new(0.52, 0.34),
                    NumberSequenceKeypoint.new(1.00, 0.10)
                })
        },
        Lens
    )

    local Specular =
        New(
            "Frame",
            {
                Name = "Specular",

                AnchorPoint =
                    Vector2.new(0.5, 0),

                Position =
                    UDim2.new(0.5, 0, 0, 1),

                Size =
                    UDim2.new(1, -34, 0, 1),

                BackgroundColor3 =
                    Color3.fromRGB(255, 255, 255),

                BackgroundTransparency = 0.55,

                BorderSizePixel = 0,

                ZIndex = 7
            },
            Body
        )

    New(
        "UIGradient",
        {
            Transparency =
                NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
        },
        Specular
    )

    local IconHolder =
        New(
            "Frame",
            {
                Name = "Badge",

                BackgroundTransparency = 1,

                Position =
                    UDim2.new(0, 14, 0.5, -13),

                Size =
                    UDim2.fromOffset(30, 26),

                ZIndex = 8
            },
            Button
        )

    BadgeGlyph(
        IconHolder,
        badgeCode,
        17,
        W.text
    )

    local ButtonText =
        Label(
            Button,
            text,
            14,
            W.text,
            Enum.Font.GothamBold
        )

    ButtonText.Position =
        UDim2.new(0, 50, 0, 0)

    ButtonText.Size =
        UDim2.new(1, -58, 1, 0)

    ButtonText.ZIndex = 8

    Button.MouseEnter:Connect(
        function()

            Tween(Body, Fast, {
                BackgroundTransparency = hoverBody
            })

            Tween(Rim, Fast, {
                Transparency = hoverRim
            })

            Tween(Shadow, Fast, {
                ImageTransparency = W.shadowHover
            })

            Tween(Lens, Fast, {
                ImageTransparency = 0.40
            })
        end
    )

    Button.MouseLeave:Connect(
        function()

            Tween(Body, Fast, {
                BackgroundTransparency = restBody
            })

            Tween(Rim, Fast, {
                Transparency = restRim
            })

            Tween(Shadow, Fast, {
                ImageTransparency = W.shadowRest
            })

            Tween(Lens, Fast, {
                ImageTransparency = 0.62
            })
        end
    )

    Button.MouseButton1Down:Connect(
        function()

            Tween(
                Body,
                TweenInfo.new(0.09, Enum.EasingStyle.Quad),
                {
                    Size = UDim2.new(1, -4, 1, -4),
                    Position = UDim2.fromOffset(2, 2)
                }
            )
        end
    )

    Button.MouseButton1Up:Connect(
        function()

            Tween(
                Body,
                TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromOffset(0, 0)
                }
            )
        end
    )

    return Button
end

local buttonRowY =
    Layout.keyBoxHeight
    + 83

local buttonRow2Y =
    buttonRowY
    + 67

local GetKeyBtn =
    GlassButton(
        Access,
        "KEY",
        "Get Key",

        UDim2.new(
            0,
            0,
            0,
            buttonRowY
        ),

        UDim2.new(
            0.49,
            -6,
            0,
            59
        ),

        "primary"
    )

local VerifyBtn =
    GlassButton(
        Access,
        "OK",
        "Verify",

        UDim2.new(
            0.51,
            6,
            0,
            buttonRowY
        ),

        UDim2.new(
            0.49,
            -6,
            0,
            59
        ),

        "secondary"
    )

local GamesBtn =
    GlassButton(
        Access,
        "GAM",
        "Supported Games",

        UDim2.new(
            0,
            0,
            0,
            buttonRow2Y
        ),

        UDim2.new(
            0.49,
            -6,
            0,
            54
        ),

        "tertiary"
    )

local SettingsBtn =
    GlassButton(
        Access,
        "CFG",
        "Settings",

        UDim2.new(
            0.51,
            6,
            0,
            buttonRow2Y
        ),

        UDim2.new(
            0.49,
            -6,
            0,
            54
        ),

        "tertiary"
    )

RegisterButton(
    GetKeyBtn,
    0.72
)

RegisterButton(
    VerifyBtn,
    0.76
)

RegisterButton(
    GamesBtn,
    0.80
)

RegisterButton(
    SettingsBtn,
    0.86
)

--========================================================--
-- SETTINGS
--
-- No card, no overlay. There is nothing in there yet, so it
-- just says so on the status line and gets out of the way.
--========================================================--

SettingsBtn.MouseButton1Click:Connect(
    function()

        SetStatus(
            "Settings - coming soon.",
            Color3.fromRGB(170, 150, 205)
        )
    end
)

--========================================================--
-- CLOSE
--
-- The reverse of the entrance: content lets go first, then
-- the pane contracts and the scene pulls back into focus.
-- Both the X and a successful key land here so they cannot
-- drift apart.
--========================================================--

local function CloseWindow()

    if not Alive then
        return
    end

    Alive = false

    getgenv().UI_CLOSED = true

    for i, entry in ipairs(IntroElements) do
        AnimateOut(entry.element, (i % 6) * 0.012)
    end

    local out =
        TweenInfo.new(
            0.36,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        )

    task.wait(0.10)

    Tween(UIScale, out, { Scale = UIScale.Scale * 0.95 })
    Tween(Main, out, { BackgroundTransparency = 1 })
    Tween(MainLens, out, { ImageTransparency = 1 })
    Tween(MainBorder, out, { Transparency = 1 })
    Tween(MainSheen, out, { BackgroundTransparency = 1 })

    Tween(
        Backdrop,
        TweenInfo.new(0.44, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { BackgroundTransparency = 1 }
    )

    if Blur and Blur.Parent then
        Tween(
            Blur,
            TweenInfo.new(0.40, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = 0 }
        )
    end

    task.wait(0.46)

    if GUI then
        GUI:Destroy()
    end
end

--========================================================--
-- KEY BUTTON LOGIC
--========================================================--

GamesBtn.MouseButton1Click:Connect(
    function()

        pcall(function()

            if setclipboard then

                setclipboard(
                    "https://discord.gg/fishyhub"
                )
            end
        end)

        SetStatus(
            "Discord link copied - the game list lives there.",
TextAccent
        )
    end
)

GetKeyBtn.MouseButton1Click:Connect(
    function()

        pcall(function()

            if setclipboard then

                setclipboard(
                    "https://discord.gg/fishyhub"
                )
            end
        end)

        SetStatus(
            "Discord link copied! Join to get your key.",
TextAccent
        )
    end
)

VerifyBtn.MouseButton1Click:Connect(
    function()

        local key =
            KeyText.Text:gsub(
                "%s+",
                ""
            )

        if key == "" then

            SetStatus(
                "Please enter a key.",
                Color3.fromRGB(
                    255,
                    100,
                    100
                )
            )

            return
        end

        SetStatus(
            "Verifying...",
            TextPrimary
        )

        task.spawn(function()

            local ok, res =
                pcall(function()

                    return Junkie.check_key(
                        key
                    )
                end)

            if not ok then

                SetStatus(
                    "Verification failed. Check your key.",
                    Color3.fromRGB(
                        255,
                        100,
                        100
                    )
                )

                return
            end

            if res
            and res.valid then

                if res.message ==
                    "KEYLESS" then

                    getgenv().SCRIPT_KEY =
                        "KEYLESS"

                    clearSavedKey()

                    SetStatus(
                        "Keyless access granted!",
                        Color3.fromRGB(
                            100,
                            255,
                            100
                        )
                    )

                elseif res.message ==
                    "KEY_VALID" then

                    saveVerifiedKey(
                        key
                    )

                    getgenv().SCRIPT_KEY =
                        key

                    SetStatus(
                        "Key approved! Loading...",
                        Color3.fromRGB(
                            100,
                            255,
                            100
                        )
                    )

                else

                    clearSavedKey()

                    getgenv().SCRIPT_KEY =
                        nil

                    SetStatus(
                        "Key invalid. Please try again.",
                        Color3.fromRGB(
                            255,
                            100,
                            100
                        )
                    )

                    return
                end

                task.wait(
                    1.5
                )

                CloseWindow()

            else

                SetStatus(
                    "Incorrect key. Please try again.",
                    Color3.fromRGB(
                        255,
                        100,
                        100
                    )
                )
            end
        end)
    end
)

--========================================================--
-- PREMIUM
--========================================================--

local Premium =
    New(
        "Frame",
        {
            Name = "Premium",

            BackgroundTransparency = 1,

            AnchorPoint =
                Vector2.new(
                    0,
                    1
                ),

            Position =
                UDim2.new(
                    0,
                    Layout.contentPadding,
                    1,
                    -Layout.contentPadding
                ),

            Size =
                UDim2.new(
                    1,
                    -Layout.contentPadding * 2,
                    0,
                    155
                )
        },
        MainArea
    )

local PremiumTitle =
    Label(
        Premium,
        "Premium+ Access",
        18,
        TextPrimary,
        Enum.Font.GothamBold
    )

PremiumTitle.Position =
    UDim2.new(
        0,
        0,
        0,
        47
    )

PremiumTitle.Size =
    UDim2.new(
        0.6,
        0,
        0,
        27
    )

RegisterText(
    PremiumTitle,
    "left",
    0.95
)

local PremiumDesc =
    Label(
        Premium,
        "unlock even more of Fishy Hub",
        12,
        TextSecondary,
        Enum.Font.GothamBold
    )

PremiumDesc.Position =
    UDim2.new(
        0,
        0,
        0,
        75
    )

PremiumDesc.Size =
    UDim2.new(
        0.7,
        0,
        0,
        22
    )

RegisterText(
    PremiumDesc,
    "bottom",
    0.98
)

local Pricing =
    Label(
        Premium,
        "discord.gg/fishyhub",
        12,
        TextAccent,
        Enum.Font.GothamBold
    )

Pricing.Position =
    UDim2.new(
        0,
        0,
        0,
        102
    )

Pricing.Size =
    UDim2.new(
        0.6,
        0,
        0,
        20
    )

RegisterText(
    Pricing,
    "right",
    1.01
)

local Perks =
    Label(
        Premium,
        "priority support  |  early access  |  customs  |  giveaways  |  special access",
        11,
        TextSecondary,
        Enum.Font.GothamBold
    )

Perks.Position =
    UDim2.new(
        0,
        0,
        0,
        126
    )

Perks.Size =
    UDim2.new(
        0.7,
        0,
        0,
        20
    )

RegisterText(
    Perks,
    "bottom",
    1.04
)

local PremiumViewBtn =
    GlassButton(
        Premium,
        "VIP",
        "View Options",

        UDim2.new(
            1,
            -170,
            0,
            53
        ),

        UDim2.fromOffset(
            165,
            56
        ),

        "tertiary"
    )

RegisterButton(
    PremiumViewBtn,
    1.06
)

PremiumViewBtn.MouseButton1Click:Connect(
    function()

        pcall(function()

            if setclipboard then

                setclipboard(
                    "https://discord.gg/fishyhub"
                )
            end
        end)

        SetStatus(
            "Discord link copied - Premium+ details are in there.",
            TextAccent
        )
    end
)

--========================================================--
-- RESPONSIVE RESIZE
--
-- Recomputes the design size, rescales it to the viewport
-- and drops whatever sections no longer earn their space.
-- The key box, Get Key and Verify are pinned visible at
-- every tier, and re-checked against the viewport at the
-- end of every pass.
--========================================================--

local function ApplyResponsiveLayout()

    Layout =
        GetLayoutProfile()

    ContentGap =
        Layout.contentGap

    Main.Size =
        UDim2.fromOffset(
            Layout.designWidth,
            Layout.designHeight
        )

    UIScale.Scale =
        Layout.scale

    Backdrop.BackgroundTransparency =
        Layout.backdropTransparency

    Main.BackgroundTransparency =
        Layout.mainTransparency

    --== Header ==--

    Header.Size =
        UDim2.new(1, 0, 0, Layout.headerHeight)

    Title.TextSize =
        Layout.titleSize

    Title.Position =
        UDim2.new(0.5, 0, 0, Layout.headerHeight * 0.18)

    Title.Size =
        UDim2.new(
            if Layout.tier == "mini" then 0.82 else 0.38,
            0,
            0,
            35
        )

    Subtitle.TextSize =
        Layout.subtitleSize

    Subtitle.Position =
        UDim2.new(0.5, 0, 0, Layout.headerHeight * 0.52)

    Subtitle.Size =
        UDim2.new(
            if Layout.tier == "mini" then 0.86 else 0.4,
            0,
            0,
            20
        )

    Minimize.Position =
        UDim2.new(1, -100, 0, Layout.headerHeight * 0.5 - 19)

    Close.Position =
        UDim2.new(1, -56, 0, Layout.headerHeight * 0.5 - 19)

    Minimize.Visible = Layout.showSidebar

    Content.Position =
        UDim2.new(0, 0, 0, Layout.headerHeight)

    Content.Size =
        UDim2.new(1, 0, 1, -Layout.headerHeight)

    Stars.Visible =
        Layout.showStars

    MainCorner.CornerRadius =
        UDim.new(0, Layout.cornerRadius)

    MainLens.SliceScale =
        Layout.cornerRadius / 18

    MainSheenCorner.CornerRadius =
        UDim.new(0, Layout.cornerRadius)

    SidebarFillCorner.CornerRadius =
        UDim.new(0, Layout.cornerRadius)

    SidebarFill.Position =
        UDim2.new(0, 0, 0, -Layout.cornerRadius)

    SidebarFill.Size =
        UDim2.new(1, Layout.cornerRadius, 1, Layout.cornerRadius)

    --== Sidebar ==--

    Sidebar.Visible      = Layout.showSidebar
    ResizeHandle.Visible = Layout.showSidebar and SidebarOpen
    Details.Visible      = Layout.showSidebarDetails

    if Layout.showSidebar then

        Avatar.Size =
            UDim2.fromOffset(
                Layout.avatarSize,
                Layout.avatarSize
            )

        AvatarImage.Size =
            UDim2.fromOffset(
                Layout.avatarSize - 8,
                Layout.avatarSize - 8
            )

        Username.Position =
            UDim2.new(0.5, 0, 0, Layout.avatarSize + 42)

        Handle.Position =
            UDim2.new(0.5, 0, 0, Layout.avatarSize + 70)

        ProfileToggle.Size =
            UDim2.new(1, 0, 0, Layout.avatarSize + 102)

        Details.Position =
            UDim2.new(0, 0, 0, Layout.avatarSize + 112)

        Details.Size =
            UDim2.new(1, 0, 1, -(Layout.avatarSize + 112))

        SidebarWidth =
            if SidebarOpen
            then Layout.sidebarWidth
            else 0

    else

        SidebarWidth = 0
    end

    -- No sidebar means no gutter either, or the content sits
    -- floating away from the left edge for no reason.
    local gap =
        if SidebarWidth > 0
        then ContentGap
        else 0

    Sidebar.Size =
        UDim2.new(SidebarWidth, 0, 1, 0)

    MainArea.Position =
        UDim2.new(SidebarWidth, gap, 0, 0)

    MainArea.Size =
        UDim2.new(1 - SidebarWidth, -gap, 1, 0)

    --== Service header ==--

    ServiceImage.Visible = Layout.showServiceHeader
    Active.Visible       = Layout.showServiceHeader
    ServiceName.Visible  = Layout.showServiceHeader
    Delivery.Visible     = Layout.showServiceHeader

    -- Text block runs 34..105, so centre the mark on 69.
    ServiceImage.Size =
        UDim2.fromOffset(Layout.logoWidth, Layout.logoHeight)

    ServiceImage.Position =
        UDim2.new(
            0,
            Layout.contentPadding,
            0,
            70 - math.round(Layout.logoHeight / 2)
        )

    Active.Position =
        UDim2.new(0, Layout.contentPadding + Layout.serviceTextX, 0, 34)

    ServiceName.Position =
        UDim2.new(0, Layout.contentPadding + Layout.serviceTextX, 0, 55)

    Delivery.Position =
        UDim2.new(0, Layout.contentPadding + Layout.serviceTextX, 0, 83)

    --== Access panel ==--

    Access.Position =
        UDim2.new(0, Layout.contentPadding, 0, Layout.accessTop)

    Access.Size =
        UDim2.new(
            1,
            -Layout.contentPadding * 2,
            0,
            Layout.accessHeight
        )

    AccessDesc.Visible =
        Layout.showAccessDesc

    KeyBox.Position =
        UDim2.new(0, 0, 0, Layout.keyBoxTop)

    KeyBox.Size =
        UDim2.new(1, 0, 0, Layout.keyBoxHeight)

    KeyText.TextSize =
        if Layout.tier == "mini"
        then 12
        else 13

    StatusLabel.Position =
        UDim2.new(0, 0, 0, Layout.statusTop)

    GetKeyBtn.Position =
        UDim2.new(0, 0, 0, Layout.buttonRowY)

    GetKeyBtn.Size =
        UDim2.new(0.49, -6, 0, Layout.buttonHeight)

    VerifyBtn.Position =
        UDim2.new(0.51, 6, 0, Layout.buttonRowY)

    VerifyBtn.Size =
        UDim2.new(0.49, -6, 0, Layout.buttonHeight)

    GamesBtn.Position =
        UDim2.new(0, 0, 0, Layout.buttonRow2Y)

    GamesBtn.Size =
        UDim2.new(0.49, -6, 0, Layout.buttonHeight2)

    SettingsBtn.Position =
        UDim2.new(0.51, 6, 0, Layout.buttonRow2Y)

    SettingsBtn.Size =
        UDim2.new(0.49, -6, 0, Layout.buttonHeight2)

    GamesBtn.Visible    = Layout.showSecondRow
    SettingsBtn.Visible = Layout.showSecondRow

    --== Ready + Premium ==--

    Premium.Visible        = Layout.showPremium
    Perks.Visible          = Layout.showPerks
    PremiumViewBtn.Visible = Layout.showPremium

    Premium.Position =
        UDim2.new(0, Layout.contentPadding, 1, -Layout.contentPadding)

    Premium.Size =
        UDim2.new(
            1,
            -Layout.contentPadding * 2,
            0,
            Layout.premiumHeight
        )


    --== Non-negotiable ==--

    KeyBox.Visible      = true
    KeyText.Visible     = true
    StatusLabel.Visible = true
    GetKeyBtn.Visible   = true
    VerifyBtn.Visible   = true
end

--========================================================--
-- FIT GUARD
--
-- Last line of defence: if the key box or either action
-- button ends up even partly off-screen, shrink the scale
-- until it isn't. Cheap, and it means a weird viewport can
-- never hide the thing the whole UI exists for.
--========================================================--

local function EnforceCriticalVisible()

    local viewport =
        GetViewport()

    for _ = 1, 6 do

        local worst = 1

        for _, element in ipairs({ KeyBox, GetKeyBtn, VerifyBtn }) do

            local pos =
                element.AbsolutePosition

            local size =
                element.AbsoluteSize

            if pos.X < 0
            or pos.Y < 0
            or pos.X + size.X > viewport.X
            or pos.Y + size.Y > viewport.Y then

                worst = 0.94
            end
        end

        if worst == 1 then
            return
        end

        UIScale.Scale =
            math.max(
                UI_SCALE_MIN,
                UIScale.Scale * worst
            )

        if UIScale.Scale <= UI_SCALE_MIN then
            return
        end
    end
end

ApplyResponsiveLayout()
EnforceCriticalVisible()

local camera =
    workspace.CurrentCamera

if camera then

    table.insert(Connections, camera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(
        function()

            if Alive
            and GUI.Parent then

                ApplyResponsiveLayout()
                EnforceCriticalVisible()
            end
        end
    ))
end

--========================================================--
-- SIDEBAR OPEN / CLOSE
--========================================================--

local function SetSidebar(open)

    SidebarOpen =
        open

    if open then

        ResizeHandle.Visible = Layout.showSidebar

        Tween(
            Sidebar,
            Smooth,
            {
                Size =
                    UDim2.new(
                        SidebarWidth,
                        0,
                        1,
                        0
                    )
            }
        )

        Tween(
            MainArea,
            Smooth,
            {
                Position =
                    UDim2.new(
                        SidebarWidth,
                        ContentGap,
                        0,
                        0
                    ),

                Size =
                    UDim2.new(
                        1 - SidebarWidth,
                        -ContentGap,
                        1,
                        0
                    )
            }
        )

        Tween(
            Username,
            Smooth,
            {
                TextTransparency = 0
            }
        )

        Tween(
            Handle,
            Smooth,
            {
                TextTransparency = 0
            }
        )

    else

        -- Closed means closed. A leftover stub of sidebar is
        -- the thing that looked unfinished.
        ResizeHandle.Visible = false

        Tween(
            Sidebar,
            Smooth,
            {
                Size =
                    UDim2.new(0, 0, 1, 0)
            }
        )

        Tween(
            MainArea,
            Smooth,
            {
                Position =
                    UDim2.new(0, 0, 0, 0),

                Size =
                    UDim2.new(1, 0, 1, 0)
            }
        )

        Tween(
            Username,
            Smooth,
            {
                TextTransparency = 1
            }
        )

        Tween(
            Handle,
            Smooth,
            {
                TextTransparency = 1
            }
        )
    end
end

ProfileToggle.MouseButton1Click:Connect(
    function()

        SetSidebar(
            not SidebarOpen
        )
    end
)

Minimize.MouseButton1Click:Connect(
    function()

        SetSidebar(
            not SidebarOpen
        )
    end
)

--========================================================--
-- RESIZE SIDEBAR
--========================================================--

local function UpdateSidebarWidth(
    mouseX
)

    if not Resizing
    or not SidebarOpen then
        return
    end

    local contentLeft =
        Content.AbsolutePosition.X

    local contentWidth =
        Content.AbsoluteSize.X

    SidebarWidth =
        math.clamp(
            (
                mouseX
                - contentLeft
            )
            /
            contentWidth,

            MinSidebarWidth,
            MaxSidebarWidth
        )

    Sidebar.Size =
        UDim2.new(
            SidebarWidth,
            0,
            1,
            0
        )

    MainArea.Position =
        UDim2.new(
            SidebarWidth,
            ContentGap,
            0,
            0
        )

    MainArea.Size =
        UDim2.new(
            1 - SidebarWidth,
            -ContentGap,
            1,
            0
        )
end

ResizeHandle.InputBegan:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

        or input.UserInputType ==
            Enum.UserInputType.Touch then

            Resizing =
                true

            Tween(
                ResizeLine,
                Fast,
                {
                    Size = UDim2.fromOffset(4, 66),
                    BackgroundTransparency = 0.02
                }
            )
        end
    end
)

table.insert(Connections, UserInputService.InputChanged:Connect(
    function(input)

        if Resizing
        and (
            input.UserInputType ==
                Enum.UserInputType.MouseMovement

            or input.UserInputType ==
                Enum.UserInputType.Touch
        ) then

            UpdateSidebarWidth(
                input.Position.X
            )
        end
    end
))

table.insert(Connections, UserInputService.InputEnded:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

        or input.UserInputType ==
            Enum.UserInputType.Touch then

            Resizing =
                false

            Tween(
                ResizeLine,
                Fast,
                {
                    Size = UDim2.fromOffset(3, 40),
                    BackgroundTransparency = 0.55
                }
            )
        end
    end
))

ResizeHandle.MouseEnter:Connect(
    function()

        if not Resizing then

            Tween(
                ResizeLine,
                Fast,
                {
                    Size = UDim2.fromOffset(4, 58),
                    BackgroundTransparency = 0.16
                }
            )
        end
    end
)

ResizeHandle.MouseLeave:Connect(
    function()

        if not Resizing then

            Tween(
                ResizeLine,
                Fast,
                {
                    Size = UDim2.fromOffset(3, 40),
                    BackgroundTransparency = 0.55
                }
            )
        end
    end
)

--========================================================--
-- HEADER HOVER + CLOSE
--========================================================--

Close.MouseButton1Click:Connect(CloseWindow)

--========================================================--
-- OPEN
--
-- The pane comes together rather than appearing: the scene
-- defocuses, the glass settles up from slightly under size,
-- and the edge catches the light first and then calms to its
-- resting brightness.
--========================================================--

local OpenScale = UIScale.Scale

UIScale.Scale = OpenScale * 0.94

Tween(
    UIScale,
    TweenInfo.new(
        0.62,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    {
        Scale = OpenScale
    }
)

Tween(
    Blur,
    TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    ),
    {
        Size = BLUR_SIZE
    }
)

Tween(
    Backdrop,
    Smooth,
    {
        BackgroundTransparency =
            Layout.backdropTransparency
    }
)

Tween(
    Main,
    Smooth,
    {
        BackgroundTransparency =
            Layout.mainTransparency
    }
)

MainLens.ImageTransparency = 0.06
MainBorder.Transparency = 0.04

Tween(
    MainLens,
    TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { ImageTransparency = 0.48 }
)

Tween(
    MainBorder,
    TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Transparency = 0.42 }
)

--========================================================--
-- INTRO
--========================================================--

for _, entry in ipairs(IntroElements) do

    AnimateIn(
        entry.element,
        0.14 + entry.delay * 0.5
    )
end

--========================================================--
-- KEY FIELD HEARTBEAT
--
-- Two beats and a rest, not a sine wave. The first beat is
-- the strong one; the second is smaller and lands close
-- behind it, which is what makes it read as a pulse rather
-- than a blink. The white sweep keeps travelling underneath.
-- Goes still the moment the field takes focus - nothing
-- should be moving while someone is typing a key in.
--========================================================--

local function KeyBeat(thickness, transparency, time, style)

    if KeyFocused then
        return
    end

    Tween(
        KeyBorder,
        TweenInfo.new(
            time,
            style or Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Thickness = thickness,
            Transparency = transparency
        }
    )
end

task.spawn(function()

    while Alive and GUI.Parent do

        KeyBeat(3.4, 0, 0.14)
        task.wait(0.14)

        KeyBeat(1.9, 0.26, 0.19)
        task.wait(0.19)

        KeyBeat(2.7, 0.08, 0.12)
        task.wait(0.12)

        KeyBeat(1.6, 0.30, 0.58, Enum.EasingStyle.Sine)
        task.wait(1.60)
    end
end)

--========================================================--
-- WINDOW BORDER SWEEP
--========================================================--

task.spawn(function()

    local rotation =
        0

    while Alive
    and GUI.Parent do

        rotation =
            (
                rotation
                + 2.2
            )
            % 360

        MainSweep.Rotation =
            rotation

        KeySweep.Rotation =
            rotation

        task.wait()
    end
end)

--========================================================--
-- HACKER SCRAMBLE ONLY FOR PREFILLED SAVED KEY
--========================================================--

task.spawn(function()

    task.wait(
        1.65
    )

    local key =
        KeyText.Text

    if key
    and key ~= ""
    and key ~= KeyText.PlaceholderText then

        Tween(
            KeyBorder,
            TweenInfo.new(
                0.12,
                Enum.EasingStyle.Linear
            ),
            {
                Transparency = 0,
                Thickness = 4.2
            }
        )

        Tween(
            KeyBox,
            TweenInfo.new(
                0.12,
                Enum.EasingStyle.Linear
            ),
            {
                BackgroundTransparency = 0.16
            }
        )

        task.wait(
            0.12
        )

        HackerScramble(
            KeyText,
            key,
            1.5
        )

        task.wait(
            1.5
        )

        Tween(
            KeyBox,
            TweenInfo.new(
                0.4,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundTransparency = 0.30
            }
        )

        Tween(
            KeyBorder,
            TweenInfo.new(
                0.4,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            {
                Transparency = 0.30,
                Thickness = 1.6
            }
        )
    end
end)

--========================================================--
-- CLEANUP
--========================================================--

GUI.AncestryChanged:Connect(function(_, parent)

    if parent then
        return
    end

    Alive = false

    if Blur and Blur.Parent then

        Tween(
            Blur,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart),
            { Size = 0 }
        )

        task.delay(0.35, function()
            if Blur then
                Blur:Destroy()
            end
        end)
    end

    for _, conn in ipairs(Connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
end)

while not getgenv().UI_CLOSED do
    task.wait(
        0.7
    )
end

local result =
    getgenv().SCRIPT_KEY

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/e39aaedf5837def85e2a2d7460cb9589b1b2b6d0e0851d57ae338d98f8371dca?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and string.sub(x.Body,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and string.sub(l,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end