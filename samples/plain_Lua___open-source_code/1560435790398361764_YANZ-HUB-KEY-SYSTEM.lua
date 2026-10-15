local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function FirstFunction(getters)
    for _, getter in ipairs(getters) do
        local ok, fn = pcall(getter)
        if ok and type(fn) == "function" then
            return fn
        end
    end
    return nil
end

local http_request = FirstFunction({
    function() return syn and syn.request end,
    function() return http and http.request end,
    function() return http_request end,
    function() return fluxus and fluxus.request end,
    function() return request end,
})

local set_clipboard = FirstFunction({
    function() return setclipboard end,
    function() return toclipboard end,
    function() return set_clipboard end,
    function() return syn and syn.write_clipboard end,
})

local get_clipboard = FirstFunction({
    function() return getclipboard end,
    function() return fromclipboard end,
})

local GenvOk, Genv = pcall(function()
    return getgenv()
end)
if not GenvOk or type(Genv) ~= "table" then
    Genv = _G
end

local function XorBytes(a, b)
    if bit32 and bit32.bxor then
        return bit32.bxor(a, b)
    end

    local result = 0
    local place = 1
    while a > 0 or b > 0 do
        local aBit = a % 2
        local bBit = b % 2
        if aBit ~= bBit then
            result = result + place
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        place = place * 2
    end
    return result
end

local function GenerateUltraUserToken(userId)
    local randNonce = tostring(math.random(10000000, 99999999))
    local raw = "YANZ_V3_AUTH_PAYLOAD_IDENTITY:" .. tostring(userId) .. ":" .. tostring(os.time()) .. ":" .. randNonce
    local key = "YANZ_ENTERPRISE_SALT_2026_SECURE_32B_CRYPT_SECRET"
    local hexTable = {}
    for i = 1, #raw do
        local byte = string.byte(raw, i)
        local kByte = string.byte(key, ((i - 1) % #key) + 1)
        table.insert(hexTable, string.format("%02X", XorBytes(byte, kByte)))
    end
    return "YANZSECURE_" .. table.concat(hexTable)
end

local userToken = GenerateUltraUserToken(LocalPlayer.UserId)

local Config = {
    Title = "YANZ HUB",
    Subtitle = "SECURITY KEY GATEWAY",
    DiscordText = "YANZ | Community 2026",

    DiscordInvite = "https://discord.gg/mNGeUVcjKB",
    KeyLink = "https://system-key.vercel.app/Checkpoint-1?token=" .. userToken,
    VerifyURL = "https://system-key.vercel.app/api/verify",

    OwnerUserId = 3758341002,
    SaveFileName = "YANZ_HUB_KEY.txt",

    BannerId = "rbxassetid://77224257059758",
    LogoId = "rbxassetid://99679980488997",
    DiscordLogoId = "rbxassetid://89581158158297",

    Accent = Color3.fromRGB(56, 189, 248),
    AccentGlow = Color3.fromRGB(2, 132, 199),
    Background = Color3.fromRGB(11, 15, 25),
    CardBg = Color3.fromRGB(15, 23, 42),
    CardBgDark = Color3.fromRGB(10, 16, 30),
    TextMain = Color3.fromRGB(248, 250, 252),
    TextSub = Color3.fromRGB(148, 163, 184),
    Success = Color3.fromRGB(74, 222, 128),
    Error = Color3.fromRGB(248, 113, 113),

    AccentLight = Color3.fromRGB(186, 230, 253),
    AccentSoft = Color3.fromRGB(125, 211, 252),
    Border = Color3.fromRGB(38, 52, 78),
    Dim = Color3.fromRGB(100, 116, 139),
    Discord = Color3.fromRGB(129, 140, 248),
    GuiName = "YANZ_ULTRA_KEY_SYSTEM",
    Backdrop = true,
}

local function Trim(value)
    return (tostring(value or ""):match("^%s*(.-)%s*$"))
end

local function CleanKey(value)
    local str = tostring(value or ""):gsub("[%s%-_]", "")
    return string.upper(str)
end

local function SaveKeyLocally(key)
    if type(writefile) == "function" then
        pcall(function()
            writefile(Config.SaveFileName, CleanKey(key))
        end)
    end
end

local function LoadSavedKey()
    local saved = ""
    if type(readfile) == "function" and type(isfile) == "function" then
        pcall(function()
            if isfile(Config.SaveFileName) then
                saved = readfile(Config.SaveFileName)
            end
        end)
    end
    return CleanKey(saved)
end

local function CopyToClipboard(text)
    if not set_clipboard then
        return false
    end
    local ok = pcall(set_clipboard, text)
    return ok
end

local function QueryServer(key)
    if not http_request then
        return false, "no_http"
    end

    local requestBody = HttpService:JSONEncode({
        key = CleanKey(key),
        userId = tostring(LocalPlayer.UserId),
    })
    local ok, response = pcall(function()
        return http_request({
            Url = Config.VerifyURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = requestBody,
        })
    end)
    if not ok or type(response) ~= "table" then
        return false, "connection"
    end

    local rawBody = response.Body or response.body or ""
    local decodeOk, data = pcall(function()
        return HttpService:JSONDecode(rawBody)
    end)
    if decodeOk and type(data) == "table" then
        return true, data
    end
    return false, "invalid"
end

Genv.YANZ_KEY_VERIFIED = false
if LocalPlayer.UserId == Config.OwnerUserId then
    print("Owner Whitelist")
    Genv.YANZ_KEY_VERIFIED = true
    return
end

do
    local previous = Genv.YANZ_KEY_CLEANUP
    if type(previous) == "function" then
        pcall(previous)
    end
    Genv.YANZ_KEY_CLEANUP = nil

    local function PurgeExisting(container)
        if not container then
            return
        end
        pcall(function()
            local old = container:FindFirstChild(Config.GuiName)
            while old do
                old:Destroy()
                old = container:FindFirstChild(Config.GuiName)
            end
        end)
    end

    PurgeExisting(CoreGui)
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then
            PurgeExisting(hui)
        end
    end
    PurgeExisting(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
end

local savedKey = LoadSavedKey()
local initialNotice = nil
local silentAccountCheck = false

local serverOk, serverData = QueryServer(savedKey)
if serverOk and serverData.success then
    Genv.YANZ_KEY_VERIFIED = true
    return
elseif savedKey ~= "" and serverOk then
    initialNotice = tostring(serverData.message or "Saved key is invalid or expired")
elseif savedKey == "" then
    silentAccountCheck = true
end

local Alive = true
local Closing = false
local Connections = {}

local function Track(connection)
    table.insert(Connections, connection)
    return connection
end

local function Tween(instance, duration, properties, style, direction)
    local ok, tween = pcall(function()
        return TweenService:Create(
            instance,
            TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
            properties
        )
    end)
    if ok and tween then
        tween:Play()
        return tween
    end
    return nil
end

local function Create(className, props, children)
    local inst = Instance.new(className)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
    end
    if inst:IsA("TextLabel") or inst:IsA("ImageLabel") then
        inst.BackgroundTransparency = 1
    end
    local parent = nil
    if props then
        for property, value in pairs(props) do
            if property == "Parent" then
                parent = value
            else
                inst[property] = value
            end
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

local function Corner(radius)
    return Create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function Stroke(color, thickness, transparency)
    return Create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function Gradient(colorSequence, rotation, transparencySequence)
    local g = Create("UIGradient", {
        Color = colorSequence,
        Rotation = rotation or 0,
    })
    if transparencySequence then
        g.Transparency = transparencySequence
    end
    return g
end

local function TwoColor(c0, c1)
    return ColorSequence.new(c0, c1)
end

local ScreenGui = Create("ScreenGui", {
    Name = Config.GuiName,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999,
})

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)

local function ResolveGuiParent()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then
            return hui
        end
    end
    local okCore = pcall(function()
        return CoreGui:GetChildren()
    end)
    if okCore then
        return CoreGui
    end
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
end

do
    local target = ResolveGuiParent()
    local parented = false
    if target then
        parented = pcall(function()
            ScreenGui.Parent = target
        end) and ScreenGui.Parent == target
    end
    if not parented then
        local fallback = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
        if fallback then
            ScreenGui.Parent = fallback
        else
            ScreenGui.Parent = CoreGui
        end
    end
end

local BASE_W, BASE_H = 600, 360

local Backdrop = Create("Frame", {
    Name = "Backdrop",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 1,
    Visible = Config.Backdrop,
    Parent = ScreenGui,
}, {
    Gradient(
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 47, 73)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 6, 18)),
        }),
        90
    ),
})

local Root = Create("Frame", {
    Name = "Root",
    Size = UDim2.fromOffset(BASE_W, BASE_H),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = ScreenGui,
})

local RootScale = Create("UIScale", { Scale = 1, Parent = Root })

local GlowLayers = {}
do
    local specs = {
        { pad = 34, radius = 44, alpha = 0.93 },
        { pad = 20, radius = 36, alpha = 0.89 },
        { pad = 8, radius = 28, alpha = 0.84 },
    }
    for index, spec in ipairs(specs) do
        local layer = Create("Frame", {
            Name = "Glow" .. index,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, spec.pad, 1, spec.pad),
            BackgroundColor3 = Config.AccentGlow,
            BackgroundTransparency = 1,
            ZIndex = 1,
            Parent = Root,
        }, { Corner(spec.radius) })
        table.insert(GlowLayers, { frame = layer, alpha = spec.alpha })
    end
end

local Main = Create("Frame", {
    Name = "MainFrame",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Config.CardBg,
    ZIndex = 2,
    Parent = Root,
}, {
    Corner(22),
    Gradient(
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 30, 54)),
            ColorSequenceKeypoint.new(0.55, Config.CardBg),
            ColorSequenceKeypoint.new(1, Config.Background),
        }),
        62
    ),
})

local MainPop = Create("UIScale", { Scale = 0.6, Parent = Main })

local MainStroke = Create("UIStroke", {
    Color = Color3.new(1, 1, 1),
    Thickness = 1.8,
    Transparency = 0.05,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = Main,
})

local StrokeGradient = Gradient(
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.Accent),
        ColorSequenceKeypoint.new(0.25, Config.AccentLight),
        ColorSequenceKeypoint.new(0.5, Config.AccentGlow),
        ColorSequenceKeypoint.new(0.75, Config.AccentSoft),
        ColorSequenceKeypoint.new(1, Config.Accent),
    }),
    0
)
StrokeGradient.Parent = MainStroke

local function GetViewport()
    local camera = workspace.CurrentCamera
    if camera then
        local size = camera.ViewportSize
        if size.X > 0 and size.Y > 0 then
            return size
        end
    end
    local abs = ScreenGui.AbsoluteSize
    if abs.X > 0 and abs.Y > 0 then
        return abs
    end
    return Vector2.new(1280, 720)
end

local function UpdateAutoScaling()
    if not Alive then
        return
    end
    local viewport = GetViewport()
    local scaleX = viewport.X / (BASE_W + 40)
    local scaleY = viewport.Y / (BASE_H + 48)
    RootScale.Scale = math.clamp(math.min(scaleX, scaleY), 0.5, 1.2)
end

UpdateAutoScaling()
do
    local camera = workspace.CurrentCamera
    if camera then
        Track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateAutoScaling))
    end
    Track(ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateAutoScaling))
end

local LeftPanel = Create("Frame", {
    Name = "ShowcasePanel",
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.new(0, 224, 1, -20),
    BackgroundColor3 = Color3.fromRGB(6, 12, 26),
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = Main,
}, {
    Corner(16),
    Stroke(Config.Accent, 1, 0.7),
})

Create("ImageLabel", {
    Name = "Banner",
    Size = UDim2.fromScale(1, 1),
    Image = Config.BannerId,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 2,
    Parent = LeftPanel,
}, { Corner(16) })

Create("Frame", {
    Name = "Shade",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    ZIndex = 3,
    Parent = LeftPanel,
}, {
    Corner(16),
    Gradient(
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 47, 73)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7, 20, 42)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 9, 20)),
        }),
        90,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(0.45, 0.28),
            NumberSequenceKeypoint.new(1, 0.04),
        })
    ),
})

local AuroraGradient = Gradient(
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.AccentGlow),
        ColorSequenceKeypoint.new(0.5, Config.AccentSoft),
        ColorSequenceKeypoint.new(1, Config.Accent),
    }),
    35,
    NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 0.86),
        NumberSequenceKeypoint.new(0.6, 0.93),
        NumberSequenceKeypoint.new(1, 1),
    })
)
Create("Frame", {
    Name = "Aurora",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    ZIndex = 4,
    Parent = LeftPanel,
}, { Corner(16), AuroraGradient })

local Particles = {}
do
    local layer = Create("Frame", {
        Name = "Particles",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = LeftPanel,
    })
    local rng = Random.new(os.time() % 100000)
    for i = 1, 16 do
        local size = rng:NextInteger(2, 5)
        local dot = Create("Frame", {
            Name = "P" .. i,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(size, size),
            BackgroundColor3 = (i % 3 == 0) and Config.AccentLight or Config.Accent,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = layer,
        }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        table.insert(Particles, {
            frame = dot,
            x = rng:NextNumber(0.08, 0.92),
            y = rng:NextNumber(0, 1),
            speed = rng:NextNumber(0.025, 0.07),
            sway = rng:NextNumber(0.01, 0.035),
            freq = rng:NextNumber(0.6, 1.6),
            phase = rng:NextNumber(0, 6.28),
        })
    end
end

local LOGO_SIZE = 72
local LOGO_CENTER_Y = 76

local Rings = {}
for i = 1, 2 do
    local ring = Create("Frame", {
        Name = "PulseRing" .. i,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, LOGO_CENTER_Y),
        Size = UDim2.fromOffset(LOGO_SIZE, LOGO_SIZE),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = LeftPanel,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })
    local ringStroke = Stroke(Config.Accent, 2, 1)
    ringStroke.Parent = ring
    table.insert(Rings, { frame = ring, stroke = ringStroke, offset = (i - 1) * 0.5 })
end

Create("Frame", {
    Name = "LogoHalo",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0, LOGO_CENTER_Y),
    Size = UDim2.fromOffset(LOGO_SIZE + 22, LOGO_SIZE + 22),
    BackgroundColor3 = Config.Accent,
    BackgroundTransparency = 0.88,
    ZIndex = 6,
    Parent = LeftPanel,
}, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

local LogoImage = Create("ImageLabel", {
    Name = "LogoImage",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0, LOGO_CENTER_Y),
    Size = UDim2.fromOffset(LOGO_SIZE, LOGO_SIZE),
    Image = Config.LogoId,
    ZIndex = 7,
    Parent = LeftPanel,
}, { Corner(20) })

local LogoStroke = Stroke(Color3.new(1, 1, 1), 2, 0)
LogoStroke.Parent = LogoImage
local LogoStrokeGradient = Gradient(
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Config.Accent),
    }),
    0
)
LogoStrokeGradient.Parent = LogoStroke

local TitleLabel = Create("TextLabel", {
    Name = "Title",
    Position = UDim2.fromOffset(0, 124),
    Size = UDim2.new(1, 0, 0, 28),
    Text = Config.Title,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 24,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LeftPanel,
}, {
    Gradient(
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Config.AccentSoft),
        }),
        90
    ),
})

Create("TextLabel", {
    Name = "Subtitle",
    Position = UDim2.fromOffset(0, 154),
    Size = UDim2.new(1, 0, 0, 14),
    Text = Config.Subtitle,
    TextColor3 = Config.Accent,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LeftPanel,
})

Create("Frame", {
    Name = "Divider",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 182),
    Size = UDim2.new(1, -44, 0, 1),
    BackgroundColor3 = Config.Accent,
    ZIndex = 7,
    Parent = LeftPanel,
}, {
    Gradient(
        TwoColor(Config.Accent, Config.Accent),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.35),
            NumberSequenceKeypoint.new(1, 1),
        })
    ),
})

do
    local features = {
        "Account-bound key",
        "Instant verification",
        "Key saved for next launch",
    }
    for i, text in ipairs(features) do
        local y = 194 + (i - 1) * 22
        Create("Frame", {
            Name = "FeatureDot" .. i,
            Position = UDim2.fromOffset(26, y + 8),
            Size = UDim2.fromOffset(6, 6),
            BackgroundColor3 = Config.Accent,
            ZIndex = 7,
            Parent = LeftPanel,
        }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Create("TextLabel", {
            Name = "Feature" .. i,
            Position = UDim2.fromOffset(40, y),
            Size = UDim2.new(1, -52, 0, 22),
            Text = text,
            TextColor3 = Config.AccentLight,
            TextSize = 11,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
            Parent = LeftPanel,
        })
    end
end

local StatusPill = Create("Frame", {
    Name = "StatusPill",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 270),
    Size = UDim2.new(1, -28, 0, 26),
    BackgroundColor3 = Color3.fromRGB(4, 10, 22),
    BackgroundTransparency = 0.25,
    ZIndex = 7,
    Parent = LeftPanel,
}, {
    Corner(13),
})
local StatusPillStroke = Stroke(Config.Accent, 1, 0.55)
StatusPillStroke.Parent = StatusPill

local StatusDot = Create("Frame", {
    Name = "StatusDot",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 11, 0.5, 0),
    Size = UDim2.fromOffset(8, 8),
    BackgroundColor3 = Config.Success,
    ZIndex = 8,
    Parent = StatusPill,
}, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

local StatusText = Create("TextLabel", {
    Name = "StatusText",
    Position = UDim2.fromOffset(28, 0),
    Size = UDim2.new(1, -36, 1, 0),
    Text = "READY",
    TextColor3 = Config.TextMain,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 8,
    Parent = StatusPill,
})

local function SetStatus(text, color)
    StatusText.Text = string.upper(text)
    StatusDot.BackgroundColor3 = color or Config.Success
    Tween(StatusPillStroke, 0.25, { Color = color or Config.Accent })
end

Create("TextLabel", {
    Name = "Community",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 16),
    Text = Config.DiscordText,
    TextColor3 = Config.TextSub,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    ZIndex = 7,
    Parent = LeftPanel,
})

local LeftDrag = Create("Frame", {
    Name = "LeftDragHandle",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 20,
    Parent = LeftPanel,
})

local RightPanel = Create("Frame", {
    Name = "FormPanel",
    Position = UDim2.fromOffset(244, 0),
    Size = UDim2.new(1, -244, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = Main,
})

local RightDrag = Create("Frame", {
    Name = "RightDragHandle",
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 2,
    Parent = RightPanel,
})

local FORM_X = 20
local FORM_W = 316

Create("TextLabel", {
    Name = "Eyebrow",
    Position = UDim2.fromOffset(FORM_X, 18),
    Size = UDim2.fromOffset(200, 12),
    Text = "SECURE ACCESS",
    TextColor3 = Config.Accent,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = RightPanel,
})

Create("TextLabel", {
    Name = "Heading",
    Position = UDim2.fromOffset(FORM_X, 32),
    Size = UDim2.fromOffset(250, 28),
    Text = "Verify Your Key",
    TextColor3 = Config.TextMain,
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = RightPanel,
})

Create("TextLabel", {
    Name = "Description",
    Position = UDim2.fromOffset(FORM_X, 62),
    Size = UDim2.fromOffset(FORM_W, 30),
    Text = "Paste the key from the checkpoint to unlock the hub. A valid key is saved for your next launch.",
    TextColor3 = Config.TextSub,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    ZIndex = 4,
    Parent = RightPanel,
})

local CloseBtn = Create("TextButton", {
    Name = "CloseButton",
    Position = UDim2.fromOffset(FORM_X + FORM_W - 26, 14),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 0.9,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 10,
    Parent = RightPanel,
}, {
    Corner(8),
})

local CloseBars = {}
for i = 1, 2 do
    local bar = Create("Frame", {
        Name = "Bar" .. i,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(12, 2),
        Rotation = (i == 1) and 45 or -45,
        BackgroundColor3 = Config.TextMain,
        ZIndex = 11,
        Parent = CloseBtn,
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    table.insert(CloseBars, bar)
end

Track(CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, 0.15, { BackgroundTransparency = 0.7, BackgroundColor3 = Config.Error })
end))
Track(CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, 0.15, { BackgroundTransparency = 0.9, BackgroundColor3 = Color3.new(1, 1, 1) })
end))

local StepsRow = Create("Frame", {
    Name = "Steps",
    Position = UDim2.fromOffset(FORM_X, 100),
    Size = UDim2.fromOffset(FORM_W, 24),
    BackgroundTransparency = 1,
    ZIndex = 4,
    Parent = RightPanel,
})

local StepNames = { "GET KEY", "ENTER KEY", "VERIFY" }
local StepUi = {}
for i, name in ipairs(StepNames) do
    local holder = Create("Frame", {
        Name = "Step" .. i,
        Position = UDim2.new((i - 1) / 3, 0, 0, 0),
        Size = UDim2.new(1 / 3, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = StepsRow,
    })
    local circle = Create("Frame", {
        Name = "Circle",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(22, 22),
        BackgroundColor3 = Config.CardBgDark,
        ZIndex = 5,
        Parent = holder,
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    local circleStroke = Stroke(Config.Border, 1.5, 0)
    circleStroke.Parent = circle
    local number = Create("TextLabel", {
        Name = "Number",
        Size = UDim2.fromScale(1, 1),
        Text = tostring(i),
        TextColor3 = Config.TextSub,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
        Parent = circle,
    })
    local label = Create("TextLabel", {
        Name = "Label",
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Text = name,
        TextColor3 = Config.Dim,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = holder,
    })
    StepUi[i] = { circle = circle, stroke = circleStroke, number = number, label = label }
end

local ProgressTrack = Create("Frame", {
    Name = "ProgressTrack",
    Position = UDim2.fromOffset(FORM_X, 130),
    Size = UDim2.fromOffset(FORM_W, 3),
    BackgroundColor3 = Config.CardBgDark,
    ZIndex = 4,
    Parent = RightPanel,
}, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

local ProgressFill = Create("Frame", {
    Name = "Fill",
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    ZIndex = 5,
    Parent = ProgressTrack,
}, {
    Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    Gradient(TwoColor(Config.AccentGlow, Config.AccentSoft), 0),
})

local StepState = {
    GotLink = (savedKey ~= ""),
    KeyEntered = (savedKey ~= ""),
    Verified = false,
}

local lastStepSignature = ""

local function RefreshSteps()
    local done = { StepState.GotLink, StepState.KeyEntered, StepState.Verified }
    local signature = tostring(done[1]) .. tostring(done[2]) .. tostring(done[3])
    if signature == lastStepSignature then
        return
    end
    lastStepSignature = signature
    local active = 0
    local count = 0
    for i = 1, 3 do
        if done[i] then
            count = count + 1
        elseif active == 0 then
            active = i
        end
    end
    for i = 1, 3 do
        local ui = StepUi[i]
        if done[i] then
            ui.number.Text = "✓"
            Tween(ui.circle, 0.25, { BackgroundColor3 = Config.Accent })
            Tween(ui.stroke, 0.25, { Color = Config.Accent })
            Tween(ui.number, 0.25, { TextColor3 = Config.Background })
            Tween(ui.label, 0.25, { TextColor3 = Config.TextMain })
        elseif i == active then
            ui.number.Text = tostring(i)
            Tween(ui.circle, 0.25, { BackgroundColor3 = Config.CardBgDark })
            Tween(ui.stroke, 0.25, { Color = Config.Accent })
            Tween(ui.number, 0.25, { TextColor3 = Config.Accent })
            Tween(ui.label, 0.25, { TextColor3 = Config.TextMain })
        else
            ui.number.Text = tostring(i)
            Tween(ui.circle, 0.25, { BackgroundColor3 = Config.CardBgDark })
            Tween(ui.stroke, 0.25, { Color = Config.Border })
            Tween(ui.number, 0.25, { TextColor3 = Config.TextSub })
            Tween(ui.label, 0.25, { TextColor3 = Config.Dim })
        end
    end
    Tween(ProgressFill, 0.4, { Size = UDim2.fromScale(count / 3, 1) }, Enum.EasingStyle.Quint)
end

local KeyHolder = Create("Frame", {
    Name = "KeyHolder",
    Position = UDim2.fromOffset(FORM_X, 146),
    Size = UDim2.fromOffset(FORM_W, 48),
    BackgroundTransparency = 1,
    ZIndex = 4,
    Parent = RightPanel,
})

local KeyInputBox = Create("Frame", {
    Name = "KeyInputBox",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Config.CardBgDark,
    ZIndex = 4,
    Parent = KeyHolder,
}, {
    Corner(14),
})
local KeyInputStroke = Stroke(Config.Border, 1.5, 0)
KeyInputStroke.Parent = KeyInputBox

local KeyIconBox = Create("Frame", {
    Name = "KeyIconBox",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 8, 0.5, 0),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Config.Accent,
    BackgroundTransparency = 0.86,
    ZIndex = 5,
    Parent = KeyInputBox,
}, { Corner(10) })

Create("TextLabel", {
    Name = "KeyIcon",
    Size = UDim2.fromScale(1, 1),
    Text = "🔑",
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextColor3 = Config.TextMain,
    ZIndex = 6,
    Parent = KeyIconBox,
})

local KeyBox = Create("TextBox", {
    Name = "KeyBox",
    Position = UDim2.fromOffset(48, 0),
    Size = UDim2.new(1, -118, 1, 0),
    PlaceholderText = "Paste your Key here...",
    PlaceholderColor3 = Config.Dim,
    Text = savedKey,
    TextColor3 = Config.TextMain,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ClipsDescendants = true,
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = KeyInputBox,
})

local ClipBtn = Create("TextButton", {
    Name = "ClipButton",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.fromOffset(56, 28),
    BackgroundColor3 = Config.Accent,
    BackgroundTransparency = 0.86,
    Text = "CLEAR",
    TextColor3 = Config.Accent,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 7,
    Parent = KeyInputBox,
}, { Corner(9) })

local function RefreshClipButton()
    local hasText = CleanKey(KeyBox.Text) ~= ""
    if hasText then
        ClipBtn.Text = "CLEAR"
        ClipBtn.Visible = true
    elseif get_clipboard then
        ClipBtn.Text = "PASTE"
        ClipBtn.Visible = true
    else
        ClipBtn.Visible = false
    end
end

local inputFocused = false

Track(KeyBox.Focused:Connect(function()
    inputFocused = true
    Tween(KeyInputStroke, 0.2, { Color = Config.Accent })
    Tween(KeyIconBox, 0.2, { BackgroundTransparency = 0.7 })
end))
Track(KeyBox.FocusLost:Connect(function()
    inputFocused = false
    Tween(KeyInputStroke, 0.2, { Color = Config.Border })
    Tween(KeyIconBox, 0.2, { BackgroundTransparency = 0.86 })
end))

local ToastHost = Create("Frame", {
    Name = "ToastHost",
    Position = UDim2.fromOffset(FORM_X, 308),
    Size = UDim2.fromOffset(FORM_W, 46),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 50,
    Parent = RightPanel,
})

local Toast = Create("Frame", {
    Name = "ToastNotification",
    Position = UDim2.new(0, 2, 0, 52),
    Size = UDim2.new(1, -4, 0, 40),
    BackgroundColor3 = Color3.fromRGB(20, 30, 48),
    ZIndex = 51,
    Parent = ToastHost,
}, { Corner(12) })
local ToastStroke = Stroke(Config.Accent, 1, 0)
ToastStroke.Parent = Toast

local ToastBar = Create("Frame", {
    Name = "Bar",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 8, 0.5, 0),
    Size = UDim2.fromOffset(4, 22),
    BackgroundColor3 = Config.Accent,
    ZIndex = 52,
    Parent = Toast,
}, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

local ToastText = Create("TextLabel", {
    Name = "Text",
    Position = UDim2.fromOffset(24, 0),
    Size = UDim2.new(1, -34, 1, 0),
    Text = "Notification Message",
    TextColor3 = Config.TextMain,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 52,
    Parent = Toast,
})

local toastToken = 0
local toastVisible = false
local TOAST_HIDDEN = UDim2.new(0, 2, 0, 52)
local TOAST_SHOWN = UDim2.new(0, 2, 0, 3)

local function ShowToast(text, color, duration)
    if not Alive then
        return
    end
    local tint = color or Config.Accent
    toastToken = toastToken + 1
    local token = toastToken

    ToastText.Text = tostring(text)
    ToastStroke.Color = tint
    ToastBar.BackgroundColor3 = tint

    if not toastVisible then
        toastVisible = true
        Toast.Position = TOAST_HIDDEN
        Tween(Toast, 0.35, { Position = TOAST_SHOWN }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    task.delay(duration or 2.8, function()
        if not Alive or token ~= toastToken then
            return
        end
        toastVisible = false
        Tween(Toast, 0.3, { Position = TOAST_SHOWN and TOAST_HIDDEN }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    end)
end

local function MakeButton(parent, cfg)
    local holder = Create("Frame", {
        Name = cfg.Name .. "Holder",
        Position = cfg.Position or UDim2.new(),
        Size = cfg.Size,
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = parent,
    })

    local visual = Create("Frame", {
        Name = "Visual",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = cfg.Fill,
        ZIndex = 4,
        Parent = holder,
    }, { Corner(cfg.Radius or 12) })

    local visualScale = Create("UIScale", { Scale = 1, Parent = visual })
    local visualStroke = Stroke(cfg.StrokeColor or Config.Border, cfg.StrokeThickness or 1, cfg.StrokeTransparency or 0)
    visualStroke.Parent = visual

    local button = Create("TextButton", {
        Name = cfg.Name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = cfg.Text,
        TextColor3 = cfg.TextColor,
        TextSize = cfg.TextSize or 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 8,
        Parent = visual,
    })

    if cfg.TextPadLeft then
        Create("UIPadding", { PaddingLeft = UDim.new(0, cfg.TextPadLeft), Parent = button })
    end

    local api = {
        Holder = holder,
        Visual = visual,
        Button = button,
        Stroke = visualStroke,
        Scale = visualScale,
        HoverFill = cfg.HoverFill,
        BaseFill = cfg.Fill,
        BaseStroke = cfg.StrokeColor or Config.Border,
        HoverStroke = cfg.HoverStroke or Config.Accent,
        BaseStrokeTransparency = cfg.StrokeTransparency or 0,
        HoverStrokeTransparency = cfg.HoverStrokeTransparency or 0,
        Enabled = true,
    }

    Track(button.MouseEnter:Connect(function()
        if not api.Enabled then
            return
        end
        Tween(visualScale, 0.15, { Scale = 1.02 })
        Tween(visualStroke, 0.15, { Color = api.HoverStroke, Transparency = api.HoverStrokeTransparency })
        if api.HoverFill then
            Tween(visual, 0.15, { BackgroundColor3 = api.HoverFill })
        end
    end))
    Track(button.MouseLeave:Connect(function()
        Tween(visualScale, 0.15, { Scale = 1 })
        Tween(visualStroke, 0.15, { Color = api.BaseStroke, Transparency = api.BaseStrokeTransparency })
        if api.HoverFill then
            Tween(visual, 0.15, { BackgroundColor3 = api.BaseFill })
        end
    end))
    Track(button.MouseButton1Down:Connect(function()
        if api.Enabled then
            Tween(visualScale, 0.08, { Scale = 0.965 })
        end
    end))
    Track(button.MouseButton1Up:Connect(function()
        Tween(visualScale, 0.12, { Scale = 1.02 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end))

    return api
end

local VERIFY_IDLE = TwoColor(Config.AccentGlow, Config.Accent)
local VERIFY_BUSY = TwoColor(Color3.fromRGB(3, 105, 161), Color3.fromRGB(14, 116, 144))
local VERIFY_OK = TwoColor(Color3.fromRGB(22, 163, 74), Config.Success)

local VerifyBtn = MakeButton(RightPanel, {
    Name = "VerifyButton",
    Position = UDim2.fromOffset(FORM_X, 206),
    Size = UDim2.fromOffset(FORM_W, 46),
    Text = "VERIFY KEY",
    TextColor = Color3.new(1, 1, 1),
    TextSize = 14,
    Fill = Color3.new(1, 1, 1),
    Radius = 14,
    StrokeColor = Config.AccentLight,
    StrokeThickness = 1.5,
    StrokeTransparency = 0.6,
    HoverStroke = Config.AccentLight,
    HoverStrokeTransparency = 0.1,
})

local VerifyGradient = Gradient(VERIFY_IDLE, 0)
VerifyGradient.Parent = VerifyBtn.Visual

local VerifyGlow = Create("Frame", {
    Name = "VerifyGlow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(1, 14, 1, 14),
    BackgroundColor3 = Config.Accent,
    BackgroundTransparency = 0.9,
    ZIndex = 3,
    Parent = VerifyBtn.Holder,
}, { Corner(18) })

local ShimmerGradient = Gradient(
    TwoColor(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
    18,
    NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.72),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1),
    })
)
ShimmerGradient.Offset = Vector2.new(-1, 0)
Create("Frame", {
    Name = "Shimmer",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    ZIndex = 6,
    Parent = VerifyBtn.Visual,
}, { Corner(14), ShimmerGradient })

local GetKeyBtn = MakeButton(RightPanel, {
    Name = "GetKeyButton",
    Position = UDim2.fromOffset(FORM_X, 264),
    Size = UDim2.fromOffset(152, 38),
    Text = "GET KEY",
    TextColor = Config.Accent,
    TextSize = 12,
    TextPadLeft = 20,
    Fill = Config.CardBgDark,
    HoverFill = Color3.fromRGB(14, 28, 52),
    Radius = 12,
    StrokeColor = Config.Border,
    HoverStroke = Config.Accent,
})

Create("TextLabel", {
    Name = "Icon",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 14, 0.5, 0),
    Size = UDim2.fromOffset(20, 20),
    Text = "🔗",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextColor3 = Config.TextMain,
    ZIndex = 9,
    Parent = GetKeyBtn.Visual,
})

local DiscordBtn = MakeButton(RightPanel, {
    Name = "DiscordButton",
    Position = UDim2.fromOffset(FORM_X + 164, 264),
    Size = UDim2.fromOffset(152, 38),
    Text = "DISCORD",
    TextColor = Config.Discord,
    TextSize = 12,
    TextPadLeft = 20,
    Fill = Config.CardBgDark,
    HoverFill = Color3.fromRGB(20, 24, 56),
    Radius = 12,
    StrokeColor = Config.Border,
    HoverStroke = Config.Discord,
})

Create("ImageLabel", {
    Name = "DiscordIcon",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 14, 0.5, 0),
    Size = UDim2.fromOffset(20, 20),
    Image = Config.DiscordLogoId,
    ZIndex = 9,
    Parent = DiscordBtn.Visual,
})

local FooterChip = Create("Frame", {
    Name = "PlayerChip",
    Position = UDim2.fromOffset(FORM_X, 316),
    Size = UDim2.fromOffset(FORM_W, 30),
    BackgroundTransparency = 1,
    ZIndex = 4,
    Parent = RightPanel,
})

Create("Frame", {
    Name = "Line",
    Position = UDim2.fromOffset(0, -6),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Config.Border,
    BackgroundTransparency = 0.4,
    ZIndex = 4,
    Parent = FooterChip,
})

local Avatar = Create("ImageLabel", {
    Name = "Avatar",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.fromOffset(24, 24),
    BackgroundColor3 = Config.CardBgDark,
    BackgroundTransparency = 0,
    ZIndex = 5,
    Parent = FooterChip,
}, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
local AvatarStroke = Stroke(Config.Accent, 1.2, 0.3)
AvatarStroke.Parent = Avatar

local displayName = tostring(LocalPlayer.DisplayName)
local accountName = tostring(LocalPlayer.Name)
local chipName = displayName
if displayName ~= accountName then
    chipName = displayName .. "  @" .. accountName
end

Create("TextLabel", {
    Name = "PlayerName",
    Position = UDim2.fromOffset(32, 0),
    Size = UDim2.new(1, -130, 1, 0),
    Text = chipName,
    TextColor3 = Config.TextSub,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 5,
    Parent = FooterChip,
})

Create("TextLabel", {
    Name = "SessionId",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.fromOffset(96, 30),
    Text = "SID " .. string.sub(userToken, -6),
    TextColor3 = Config.Dim,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 5,
    Parent = FooterChip,
})

task.spawn(function()
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)
    if ok and content and Alive then
        Avatar.Image = content
    end
end)

local isVerifying = false
local verifyDots = false
local lastDotText = ""
local granted = false

local function SetVerifyMode(mode)
    if mode == "idle" then
        VerifyGradient.Color = VERIFY_IDLE
        VerifyBtn.Button.Text = "VERIFY KEY"
        VerifyBtn.Enabled = true
        verifyDots = false
    elseif mode == "busy" then
        VerifyGradient.Color = VERIFY_BUSY
        VerifyBtn.Button.Text = "VERIFYING"
        VerifyBtn.Enabled = false
        verifyDots = true
    elseif mode == "success" then
        VerifyGradient.Color = VERIFY_OK
        VerifyBtn.Button.Text = "ACCESS GRANTED ✓"
        VerifyBtn.Enabled = false
        verifyDots = false
    end
end

local function ShakeInput(color)
    task.spawn(function()
        Tween(KeyInputStroke, 0.1, { Color = color or Config.Error })
        local offsets = { -7, 7, -5, 5, -2, 2, 0 }
        for _, offset in ipairs(offsets) do
            if not Alive then
                return
            end
            KeyInputBox.Position = UDim2.fromOffset(offset, 0)
            task.wait(0.035)
        end
        KeyInputBox.Position = UDim2.fromOffset(0, 0)
        task.wait(0.9)
        if Alive and not inputFocused then
            Tween(KeyInputStroke, 0.3, { Color = Config.Border })
        elseif Alive then
            Tween(KeyInputStroke, 0.3, { Color = Config.Accent })
        end
    end)
end

local CleanupHandle = nil

local function Shutdown(animated)
    if Closing then
        return
    end
    Closing = true

    if animated and ScreenGui.Parent then
        Tween(MainPop, 0.38, { Scale = 0.05 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Backdrop, 0.38, { BackgroundTransparency = 1 })
        for _, glow in ipairs(GlowLayers) do
            Tween(glow.frame, 0.3, { BackgroundTransparency = 1 })
        end
        task.wait(0.4)
    end

    Alive = false
    for _, connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    Connections = {}

    pcall(function()
        ScreenGui:Destroy()
    end)

    if Genv.YANZ_KEY_CLEANUP == CleanupHandle then
        Genv.YANZ_KEY_CLEANUP = nil
    end
end

CleanupHandle = function()
    Shutdown(false)
end
Genv.YANZ_KEY_CLEANUP = CleanupHandle

local function GrantAccess(key, message)
    if granted then
        return
    end
    granted = true

    if key then
        SaveKeyLocally(key)
    end

    StepState.GotLink = true
    StepState.KeyEntered = true
    StepState.Verified = true
    RefreshSteps()

    SetStatus("Access granted", Config.Success)
    SetVerifyMode("success")
    ShowToast(message or "Access Granted!", Config.Success)
    Tween(VerifyBtn.Stroke, 0.3, { Color = Config.Success, Transparency = 0.2 })
    Tween(VerifyGlow, 0.3, { BackgroundColor3 = Config.Success })

    task.wait(0.8)
    Shutdown(true)
    Genv.YANZ_KEY_VERIFIED = true
end

local function ProcessVerify()
    if isVerifying or granted or Closing then
        return
    end
    local key = CleanKey(KeyBox.Text)

    if key == "" then
        ShowToast("Please enter your key!", Config.Error)
        ShakeInput(Config.Error)
        return
    end

    isVerifying = true
    ShowToast("Connecting to verification server...", Config.Accent)
    SetStatus("Verifying", Config.Accent)
    SetVerifyMode("busy")

    task.spawn(function()
        local flowOk, flowErr = pcall(function()
            local ok, data = QueryServer(key)

            if not Alive then
                return
            end

            if ok then
                if data.success then
                    GrantAccess(key, data.message)
                    return
                end
                ShowToast(tostring(data.message or "Invalid Key!"), Config.Error)
                SetStatus("Invalid key", Config.Error)
                ShakeInput(Config.Error)
            elseif data == "invalid" then
                ShowToast("Server Error: Invalid Response", Config.Error)
                SetStatus("Server error", Config.Error)
            elseif data == "no_http" then
                ShowToast("Your executor has no HTTP request support!", Config.Error)
                SetStatus("No HTTP support", Config.Error)
            else
                ShowToast("Server connection failed!", Config.Error)
                SetStatus("Connection failed", Config.Error)
            end

            SetVerifyMode("idle")
            isVerifying = false
        end)

        if not flowOk then
            warn("[YANZ HUB] Verify flow error: " .. tostring(flowErr))
            if Alive and not granted then
                ShowToast("Unexpected error, please try again", Config.Error)
                SetStatus("Error", Config.Error)
                SetVerifyMode("idle")
            end
            isVerifying = false
        end
    end)
end

Track(VerifyBtn.Button.MouseButton1Click:Connect(ProcessVerify))

Track(KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ProcessVerify()
    end
end))

Track(KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
    StepState.KeyEntered = CleanKey(KeyBox.Text) ~= ""
    RefreshClipButton()
    if not granted then
        RefreshSteps()
        if not isVerifying then
            SetStatus("Ready", Config.Success)
        end
    end
end))

Track(ClipBtn.MouseButton1Click:Connect(function()
    if CleanKey(KeyBox.Text) ~= "" then
        KeyBox.Text = ""
        KeyBox:CaptureFocus()
    elseif get_clipboard then
        local ok, content = pcall(get_clipboard)
        if ok and type(content) == "string" and CleanKey(content) ~= "" then
            KeyBox.Text = CleanKey(content)
            ShowToast("Key pasted from clipboard", Config.Accent)
        else
            ShowToast("Clipboard is empty", Config.Error)
        end
    end
end))

Track(GetKeyBtn.Button.MouseButton1Click:Connect(function()
    if CopyToClipboard(Config.KeyLink) then
        ShowToast("Key Link copied to clipboard!", Config.Accent)
    else
        print("[YANZ HUB] Key link: " .. Config.KeyLink)
        ShowToast("Clipboard unsupported - link printed to console", Config.Error, 3.4)
    end
    StepState.GotLink = true
    if not granted then
        RefreshSteps()
    end
end))

Track(DiscordBtn.Button.MouseButton1Click:Connect(function()
    if CopyToClipboard(Config.DiscordInvite) then
        ShowToast("Discord invite copied to clipboard!", Config.Discord)
    else
        print("[YANZ HUB] Discord invite: " .. Config.DiscordInvite)
        ShowToast("Clipboard unsupported - invite printed to console", Config.Error, 3.4)
    end
end))

Track(CloseBtn.MouseButton1Click:Connect(function()
    if granted then
        return
    end
    task.spawn(function()
        Shutdown(true)
    end)
end))

local dragging = false
local dragStart = Vector3.new()
local startPos = UDim2.new()

local function BeginDrag(input)
    if Closing then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Root.Position

        local changed
        changed = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if changed then
                    changed:Disconnect()
                end
            end
        end)
    end
end

Track(LeftDrag.InputBegan:Connect(BeginDrag))
Track(RightDrag.InputBegan:Connect(BeginDrag))

Track(UserInputService.InputChanged:Connect(function(input)
    if not dragging or not Alive then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        local viewport = GetViewport()
        local maxX = viewport.X / 2 - 60
        local maxY = viewport.Y / 2 - 40
        local newX = math.clamp(startPos.X.Offset + delta.X, -maxX, maxX)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, -maxY, maxY)
        Root.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end))

local clock = 0
local lastDotCount = -1
local IntroDone = false

Track(RunService.RenderStepped:Connect(function(dt)
    if not Alive or not dt or dt <= 0 then
        return
    end
    clock = clock + dt

    StrokeGradient.Rotation = (clock * 55) % 360
    LogoStrokeGradient.Rotation = (clock * -80) % 360

    AuroraGradient.Offset = Vector2.new(math.sin(clock * 0.45) * 0.45, math.cos(clock * 0.3) * 0.3)
    AuroraGradient.Rotation = 35 + math.sin(clock * 0.25) * 25

    local breathe = math.sin(clock * 1.6) * 0.03
    for _, glow in ipairs(GlowLayers) do
        if IntroDone and not Closing then
            glow.frame.BackgroundTransparency = math.clamp(glow.alpha + breathe, 0, 1)
        end
    end
    VerifyGlow.BackgroundTransparency = 0.88 + math.sin(clock * 2.2) * 0.05

    for _, ring in ipairs(Rings) do
        local phase = (clock * 0.5 + ring.offset) % 1
        local size = LOGO_SIZE + 4 + phase * 40
        ring.frame.Size = UDim2.fromOffset(size, size)
        ring.stroke.Transparency = 0.25 + phase * 0.75
    end

    StatusDot.BackgroundTransparency = 0.35 + (math.sin(clock * 4) * 0.5 + 0.5) * 0.45

    for _, p in ipairs(Particles) do
        p.y = p.y - p.speed * dt
        if p.y < -0.04 then
            p.y = 1.04
        end
        local fade = math.sin(math.clamp(p.y, 0, 1) * math.pi)
        p.frame.Position = UDim2.fromScale(p.x + math.sin(clock * p.freq + p.phase) * p.sway, p.y)
        p.frame.BackgroundTransparency = 1 - 0.75 * fade
    end

    local cycle = verifyDots and 1.1 or 2.6
    local progress = (clock % cycle) / cycle
    ShimmerGradient.Offset = Vector2.new(-1 + progress * 2, 0)

    if verifyDots then
        local count = math.floor(clock * 3) % 4
        if count ~= lastDotCount then
            lastDotCount = count
            VerifyBtn.Button.Text = "VERIFYING" .. string.rep(".", count)
        end
    else
        lastDotCount = -1
    end
end))

RefreshClipButton()
RefreshSteps()
SetStatus("Ready", Config.Success)

if Config.Backdrop then
    Tween(Backdrop, 0.45, { BackgroundTransparency = 0.38 })
end
Tween(MainPop, 0.6, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
for _, glow in ipairs(GlowLayers) do
    Tween(glow.frame, 0.6, { BackgroundTransparency = glow.alpha })
end

task.delay(0.7, function()
    IntroDone = true
end)

if initialNotice then
    task.delay(0.7, function()
        if Alive and not granted then
            ShowToast(initialNotice, Config.Error, 3.4)
            SetStatus("Saved key rejected", Config.Error)
        end
    end)
end

if silentAccountCheck then
    task.spawn(function()
        local ok, data = pcall(function()
            local reqOk, reqData = QueryServer("")
            return { ok = reqOk, data = reqData }
        end)
        if ok and Alive and not granted and not isVerifying then
            if data.ok and type(data.data) == "table" and data.data.success then
                isVerifying = true
                GrantAccess(nil, data.data.message)
            end
        end
    end)
end
