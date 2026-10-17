if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"6aa463bf1351e5896ac04a44c07f78b983a2efc32738c543ac198b73d94cc946","e69c8b42c8ab5282c445f121f5224a63bdbc883fa359aa251a8ff6784f17417f","903acde665ddc9c558bc804e5cc2d6f6893bad4424c94d91dc3a0ff360ea7fea","6a33bc416d4e7424c6ff685a00d8363a75193e7c5bcec14f89131813e8e79bbb","a334c7256e1a402552f8e7b24d3d24391cd5fb93e57b4c7c3db826e9d662fb9e","1d941d315f5df42799aaddc32975bc49021dd87e9c32c84c7ef37ac29330e0ae","cfda26d328e040be36fe4d7a94035e4c185bd0bea4339112065b20f5062faa35","d1fcebd3066187258baae747ad696f2e8ab4e2119d31eba5cf802b3ce4c3e811","9fba8a2d03f07cd5d926d0c0cf182c6e44d24ffecb369a7c96578460781bf70a","8ed393aa6bdf1178a011ea951aaef30c2f60e4dd2637445098a649d1ec0ed97e","0b33d0ad7f7b2996e867917ba100c67ed5fb46903663cf087809661a9d24328f","cd031793a6221e351f75e2ae96fa275e607ef84c939dbb6cf23806ffb3238e7d","89960ad809d478224aba7a971add143b00fd640057b8311d1e8e60430a9a862c"},{},{[994732206]=1,[2440500124]=2,[3317771874]=3,[4658598196]=4,[5595353122]=5,[5750914919]=6,[6035872082]=7,[8841437826]=8,[9792947201]=9,[10035204815]=10,[10539411000]=11,[10563114921]=12,[10767386157]=13};local i=P[game.PlaceId]or G[game.GameId];if not i then warn("Unsupported game [LDR-NOMAP]");return end;local CFG = {
    Brand = "Lunaris Hub",
    Tagline = "Key System",
    Wordmark = "rbxassetid://120813806081114",
    Service = "Da7mu Service",
    Identifier = "852",
    Provider = "",
    GetKeyLink = "https://jnkie.com/get-key/getlunaris",
    KeyFile = "Jnkie_key.txt",
    GamesUrl = "",

    Shop = {
        Enabled = true,
        Tag = "PREMIUM",
        Title = "Get Premium Keys!",
        Subtitle = "Instant delivery • 24/7 support",
        ButtonText = "Buy",
        Link = "https://getlunaris.mysellauth.com/"
    },

    Names = {
        ["6035872082"] = "Rivals",
        ["8841437826"] = "Capybaras Vs Plants",
        ["3317771874"] = "Pet Simulator 99",
        ["5750914919"] = "Fisch",
        ["9792947201"] = "Slime RNG",
        ["4658598196"] = "AotR",
        ["994732206"] = "Blox Fruits",
        ["10539411000"] = "Clean all the Leaves",
        ["5595353122"] = "Slayers 2",
        ["2440500124"] = "Doors",
        ["10035204815"] = "Ride a Pet",
        ["10563114921"] = "Steal an Egg",
        ["10767386157"] = "Chop A Forest"
    }
}

local G = (typeof(getgenv) == "function") and getgenv() or nil

if G and type(G.__LunarisCleanup) == "function" then
    pcall(G.__LunarisCleanup)
    G.__LunarisCleanup = nil
end

local Theme = {
    Background = Color3.fromRGB(26, 28, 36),
    Tab = Color3.fromRGB(20, 22, 29),
    Outline = Color3.fromRGB(74, 80, 100),
    Inline = Color3.fromRGB(34, 37, 47),
    Text = Color3.fromRGB(255, 255, 255),
    InactiveText = Color3.fromRGB(112, 118, 138),
    Accent = Color3.fromRGB(0, 177, 162),
    Element = Color3.fromRGB(37, 40, 51),
    Gradient = Color3.fromRGB(33, 36, 46),
    Shadow = Color3.fromRGB(0, 0, 0),
    HoveredElement = Color3.fromRGB(47, 51, 64)
}

local Danger = Color3.fromRGB(228, 106, 106)

local Anim = {
    Time = 0.25,
    Style = Enum.EasingStyle.Quart,
    Direction = Enum.EasingDirection.Out
}

local Players = game:GetService("Players")
local TweenSvc = game:GetService("TweenService")
local HttpSvc = game:GetService("HttpService")
local RunSvc = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local clipboard = (typeof(setclipboard) == "function") and setclipboard or nil
local canWrite = (typeof(writefile) == "function") and (typeof(readfile) == "function") and (typeof(isfile) == "function")
local guiParent = (typeof(gethui) == "function") and gethui() or game:GetService("CoreGui")

local Dir = "blossom"
local AssetDir = Dir .. "/Assets"

if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
    pcall(function()
        if not isfolder(Dir) then
            makefolder(Dir)
        end

        if not isfolder(AssetDir) then
            makefolder(AssetDir)
        end
    end)
end

local UIFont do
    local ok, result = pcall(function()
        local path = AssetDir .. "/Figtree-SemiBold.ttf"

        if not isfile(path) then
            writefile(path, game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Figtree-SemiBold.ttf"))
        end

        local descriptor = {
            name = "Blossom",
            faces = {
                {
                    name = "Blossom",
                    weight = 600,
                    style = "normal",
                    assetId = getcustomasset(path)
                }
            }
        }

        local manifest = AssetDir .. "/Blossom.font"

        writefile(manifest, HttpSvc:JSONEncode(descriptor))

        return Font.new(getcustomasset(manifest))
    end)

    UIFont = ok and result or Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold)
end

local Lucide, LucideNames, LucideTried = nil, nil, false

local function runPack(source)
    if type(source) ~= "string" or #source < 4096 then
        return nil
    end

    local ok, chunk = pcall(loadstring, source)

    if not ok or type(chunk) ~= "function" then
        return nil
    end

    local ran, pack = pcall(chunk)

    if ran and type(pack) == "table" and type(pack.GetAsset) == "function" then
        return pack
    end

    return nil
end

local function loadLucide()
    if LucideTried then
        return Lucide
    end

    LucideTried = true

    local path = AssetDir .. "/lucide.luau"
    local pack

    pcall(function()
        if isfile(path) then
            pack = runPack(readfile(path))
        end
    end)

    if not pack then
        local sources = {
            "https://github.com/latte-soft/lucide-roblox/releases/download/0.1.3/lucide-roblox.luau",
            "https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau"
        }

        for _, url in next, sources do
            local body

            pcall(function()
                body = game:HttpGet(url)
            end)

            pack = runPack(body)

            if pack then
                pcall(function()
                    writefile(path, body)
                end)

                break
            end
        end
    end

    if not pack then
        return nil
    end

    Lucide = pack

    local names = {}

    pcall(function()
        for _, entry in next, pack.IconNames or {} do
            names[entry] = true
        end
    end)

    if next(names) then
        LucideNames = names
    end

    return pack
end

local function lucideIcon(name)
    if type(name) ~= "string" or name == "" then
        return nil
    end

    local pack = loadLucide()

    if not pack then
        return nil
    end

    if LucideNames and not LucideNames[name] then
        return nil
    end

    local entry

    pcall(function()
        entry = pack.GetAsset(name, 48)
    end)

    if type(entry) ~= "table" then
        return nil
    end

    local image = entry.Url

    if type(image) ~= "string" and type(entry.Id) == "number" then
        image = "rbxassetid://" .. entry.Id
    end

    if type(image) ~= "string" or image == "" then
        return nil
    end

    return image, entry.ImageRectOffset, entry.ImageRectSize
end

local function resolveIcon(name)
    if type(name) == "table" then
        for _, candidate in next, name do
            local image, offset, size = lucideIcon(candidate)

            if image then
                return image, offset, size
            end
        end

        return nil
    end

    return lucideIcon(name)
end

local function paintIcon(object, name)
    local image, offset, size = resolveIcon(name)

    object.Image = image or ""

    if typeof(offset) == "Vector2" and typeof(size) == "Vector2" and size.X > 0 then
        object.ImageRectOffset = offset
        object.ImageRectSize = size
    else
        object.ImageRectOffset = Vector2.new(0, 0)
        object.ImageRectSize = Vector2.new(0, 0)
    end
end

local ICON = {
    Key = { "key", "key-round" },
    Check = { "circle-check", "check-circle", "check" },
    Alert = { "circle-alert", "alert-circle", "triangle-alert" },
    Spinner = { "loader-circle", "loader-2", "loader", "refresh-cw" },
    Link = { "external-link", "link", "arrow-up-right" },
    Copied = { "clipboard-check", "clipboard", "copy" },
    Game = { "gamepad-2", "gamepad", "joystick" },
    Cpu = { "cpu", "monitor", "terminal" },
    Lock = { "lock", "lock-keyhole", "shield" },
    Crown = { "crown", "gem", "star" },
    Cart = { "shopping-cart", "shopping-bag", "credit-card" },
    Store = { "store", "globe", "link" },
    Unlock = { "lock-open", "unlock", "key-round" },
    Search = { "search", "scan-search" },
    Close = { "x", "circle-x" },
    Library = { "library", "layout-grid", "list" },
    Pin = { "map-pin", "navigation", "locate" },
    Tick = { "check", "circle-check" }
}

local function shade(color, scale)
    return Color3.new(
        math.clamp(color.R * scale, 0, 1),
        math.clamp(color.G * scale, 0, 1),
        math.clamp(color.B * scale, 0, 1)
    )
end

local function lift(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

local function seq(base)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, base),
        ColorSequenceKeypoint.new(1, shade(base, 0.79))
    })
end

local function sweep(tone)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, shade(tone, 0.22)),
        ColorSequenceKeypoint.new(0.25, lift(tone, 0.10)),
        ColorSequenceKeypoint.new(0.50, shade(tone, 0.22)),
        ColorSequenceKeypoint.new(0.75, lift(tone, 0.10)),
        ColorSequenceKeypoint.new(1.00, shade(tone, 0.22))
    })
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent

    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Outline
    s.Thickness = thickness or 0.4
    s.Transparency = transparency or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent

    return s
end

local function gradient(parent, sequence, rotation)
    local g = Instance.new("UIGradient")
    g.Rotation = rotation or 90
    g.Color = sequence
    g.Parent = parent

    return g
end

local function frame(props)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = props.Color or Color3.fromRGB(255, 255, 255)
    f.BackgroundTransparency = props.Transparency or 0
    f.BorderSizePixel = 0
    f.Position = props.Pos or UDim2.fromOffset(0, 0)
    f.Size = props.Size or UDim2.fromOffset(0, 0)
    f.AnchorPoint = props.Anchor or Vector2.new(0, 0)
    f.ClipsDescendants = props.Clip or false
    f.ZIndex = props.Z or 1
    f.Parent = props.Parent

    if props.Round then
        corner(f, props.Round)
    end

    if props.Stroke then
        stroke(f)
    end

    return f
end

local function text(props)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.BorderSizePixel = 0
    t.FontFace = UIFont
    t.Text = props.Text or ""
    t.TextColor3 = props.Color or Theme.Text
    t.TextSize = props.Size or 14
    t.TextXAlignment = props.Align or Enum.TextXAlignment.Left
    t.TextYAlignment = props.VAlign or Enum.TextYAlignment.Center
    t.TextWrapped = props.Wrap or false
    t.TextTruncate = props.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
    t.Position = props.Pos or UDim2.fromOffset(0, 0)
    t.Size = props.Box or UDim2.fromOffset(0, 0)
    t.ZIndex = props.Z or 1
    t.Parent = props.Parent

    return t
end

local function icon(props)
    local i = Instance.new("ImageLabel")
    i.BackgroundTransparency = 1
    i.BorderSizePixel = 0
    i.ImageColor3 = props.Color or Theme.Text
    i.ImageTransparency = props.Transparency or 0
    i.ScaleType = Enum.ScaleType.Fit
    i.Position = props.Pos or UDim2.fromOffset(0, 0)
    i.Size = props.Size or UDim2.fromOffset(16, 16)
    i.AnchorPoint = props.Anchor or Vector2.new(0, 0)
    i.ZIndex = props.Z or 1
    i.Parent = props.Parent

    if props.Image then
        i.Image = props.Image
    elseif props.Icon then
        paintIcon(i, props.Icon)
    end

    return i
end

local function tween(object, props, time, style)
    return TweenSvc:Create(object, TweenInfo.new(time or Anim.Time, style or Anim.Style, Anim.Direction), props)
end

local FadeProps = {
    Frame = { "BackgroundTransparency" },
    ScrollingFrame = { "BackgroundTransparency", "ScrollBarImageTransparency" },
    TextLabel = { "BackgroundTransparency", "TextTransparency" },
    TextButton = { "BackgroundTransparency", "TextTransparency" },
    TextBox = { "BackgroundTransparency", "TextTransparency" },
    ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
    ImageButton = { "BackgroundTransparency", "ImageTransparency" },
    UIStroke = { "Transparency" },
    UIShadow = { "Transparency" }
}

local function fadeTree(root, visible, time)
    local items = { root }
    local index = 1

    while index <= #items do
        for _, child in ipairs(items[index]:GetChildren()) do
            if not (child:IsA("GuiObject") and not child.Visible) then
                table.insert(items, child)
            end
        end

        index = index + 1
    end

    for _, object in ipairs(items) do
        local props = FadeProps[object.ClassName]

        if props then
            local goal = {}
            local moving = false

            for _, prop in ipairs(props) do
                local rest = object[prop]

                if rest < 1 then
                    moving = true

                    if visible then
                        object[prop] = 1
                        goal[prop] = rest
                    else
                        goal[prop] = 1
                    end
                end
            end

            if moving then
                tween(object, goal, time, Enum.EasingStyle.Quad):Play()
            end
        end
    end
end

local function fadeInput(params)
    local width, height = params.Width, params.Height
    local edge, fade = params.Edge or 8, params.Fade or 26
    local L, R = edge / width, fade / width

    local View = frame({
        Parent = params.Parent,
        Pos = UDim2.fromOffset(params.X, 0),
        Size = UDim2.fromOffset(width, height),
        Transparency = 1,
        Clip = true
    })

    local Input = Instance.new("TextBox")
    Input.BackgroundTransparency = 1
    Input.BorderSizePixel = 0
    Input.FontFace = UIFont
    Input.PlaceholderText = params.Placeholder or ""
    Input.PlaceholderColor3 = Theme.InactiveText
    Input.Text = ""
    Input.TextSize = 14
    Input.TextColor3 = Theme.Text
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.ClearTextOnFocus = false
    Input.Size = UDim2.fromOffset(width, height)
    Input.Parent = View

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, edge)
    Padding.PaddingRight = UDim.new(0, fade)
    Padding.Parent = Input

    local Fade = Instance.new("UIGradient")
    Fade.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(L * 0.45, 0.6),
        NumberSequenceKeypoint.new(L, 0),
        NumberSequenceKeypoint.new(1 - R, 0),
        NumberSequenceKeypoint.new(1 - R * 0.45, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })
    Fade.Parent = Input

    return Input
end

local function fitScale(width, height)
    local camera = workspace.CurrentCamera
    local view = camera and camera.ViewportSize or Vector2.new(1920, 1080)

    return math.min(1, (view.X - 32) / width, (view.Y - 32) / height)
end

local function loadRemoteGames()
    if type(CFG.GamesUrl) ~= "string" or CFG.GamesUrl == "" then
        return
    end

    local ok, body = pcall(function()
        return game:HttpGet(CFG.GamesUrl)
    end)

    if not ok or type(body) ~= "string" then
        return
    end

    local decoded, data = pcall(function()
        return HttpSvc:JSONDecode(body)
    end)

    if not decoded or type(data) ~= "table" then
        return
    end

    for id, name in pairs(data) do
        if type(name) == "string" and name ~= "" then
            CFG.Names[tostring(id)] = name
        end
    end
end

loadRemoteGames()

local Games = {}

for id, name in pairs(CFG.Names) do
    Games[#Games + 1] = {
        Id = tostring(id),
        Name = name
    }
end

table.sort(Games, function(a, b)
    return a.Name:lower() < b.Name:lower()
end)

local CurrentId = tostring(game.GameId)
local detected = CFG.Names[CurrentId]

local executorName = "Unknown"

pcall(function()
    if typeof(identifyexecutor) == "function" then
        executorName = tostring(identifyexecutor())
    end
end)

local function rememberKey(k)
    if canWrite then
        pcall(writefile, CFG.KeyFile, k)
    end
end

local function recallKey()
    if not canWrite then
        return nil
    end

    local ok, val = pcall(function()
        if isfile(CFG.KeyFile) then
            return readfile(CFG.KeyFile)
        end

        return nil
    end)

    if not ok or type(val) ~= "string" then
        return nil
    end

    return (val:gsub("%s+", ""))
end

local function forgetKey()
    if canWrite and typeof(delfile) == "function" then
        pcall(delfile, CFG.KeyFile)
    end
end

local Junkie = nil

local function sdk()
    if Junkie then
        return Junkie
    end

    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
    end)

    if not ok or type(result) ~= "table" or type(result.check_key) ~= "function" then
        return nil
    end

    result.service = CFG.Service
    result.identifier = CFG.Identifier
    result.provider = CFG.Provider

    Junkie = result

    return Junkie
end

local Rejections = {
    KEY_INVALID = { "invalid", "Invalid key. Check it and try again." },
    KEY_EXPIRED = { "expired", "That key has expired. Press Get Key for a new one." },
    KEY_INVALIDATED = { "revoked", "That key was revoked. Press Get Key for a new one." },
    ALREADY_USED = { "used", "That one-time key was already used." },
    HWID_MISMATCH = { "hwid", "This key is locked to another device. Reset its HWID or get a new key." },
    HWID_BANNED = { "banned", "This device is banned from Lunaris." },
    SERVICE_NOT_FOUND = { "config", "The key service could not be found. Contact support." },
    SERVICE_MISMATCH = { "config", "That key belongs to a different service." },
    PREMIUM_REQUIRED = { "premium", "This script needs a premium key. Grab one from the store." },
    ERROR = { "network", "Could not reach Jnkie. Check your connection and retry." }
}

local function classify(result)
    local code = type(result) == "table" and tostring(result.error or "") or ""
    local entry = Rejections[code]

    if entry then
        return entry[1], entry[2]
    end

    if code:find("429") then
        return "network", "Too many attempts. Wait a minute and try again."
    end

    local message = type(result) == "table" and result.message

    if message then
        return "unknown", tostring(message)
    end

    if code ~= "" then
        return "unknown", code
    end

    return "unknown", "Key rejected."
end

local function keyIsDead(kind)
    return kind == "invalid"
        or kind == "expired"
        or kind == "revoked"
        or kind == "used"
        or kind == "hwid"
        or kind == "banned"
end

local function authorise(key)
    local lib = sdk()

    if not lib then
        return false, "network", "Could not load the Jnkie SDK. Check your connection and retry."
    end

    local ok, result = pcall(lib.check_key, key)

    if not ok then
        return false, "network", "Could not reach Jnkie. Check your connection and retry."
    end

    if result == true or (type(result) == "table" and result.valid == true) then
        return true
    end

    local kind, message = classify(result)

    return false, kind, message
end

local function keylessActive()
    local lib = sdk()

    if not lib then
        return false
    end

    local ok, result = pcall(lib.check_key, "KEYLESS")

    return ok and type(result) == "table" and result.valid == true
end

local Finished = false

local function publish(key)
    if G then
        G.SCRIPT_KEY = key
        G.script_key = key
        G.LunarisKey = key
    end

    Finished = true
end

local function giveUp()
    if G then
        G.UI_CLOSED = true
    end

    Finished = true
end

local W, H = 760, 452
local HEAD = 64
local LEFT = 206
local SHOP = CFG.Shop.Enabled and 220 or 0
local BASE = W - SHOP
local PAD = 20

local ToastGui, ToastHolder

local function ensureToastHolder()
    if ToastGui and ToastGui.Parent then
        return ToastHolder
    end

    ToastGui = Instance.new("ScreenGui")
    ToastGui.Name = "\0"
    ToastGui.ResetOnSpawn = false
    ToastGui.IgnoreGuiInset = true
    ToastGui.DisplayOrder = 10000
    ToastGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ToastGui.Parent = guiParent

    if typeof(protectgui) == "function" then
        pcall(protectgui, ToastGui)
    end

    ToastHolder = frame({
        Parent = ToastGui,
        Pos = UDim2.new(1, -14, 0, 14),
        Size = UDim2.fromOffset(0, 0),
        Anchor = Vector2.new(1, 0),
        Transparency = 1
    })

    ToastHolder.AutomaticSize = Enum.AutomaticSize.XY

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = ToastHolder

    return ToastHolder
end

local function notify(params)
    local holder = ensureToastHolder()

    local TW, TH = 300, 68
    local BAR = 5
    local BARW = TW - 24
    local duration = params.Duration or 5

    local Slot = frame({
        Parent = holder,
        Size = UDim2.fromOffset(TW, TH),
        Transparency = 1
    })

    local Card = frame({
        Parent = Slot,
        Pos = UDim2.fromOffset(TW + 40, 0),
        Size = UDim2.fromOffset(TW, TH),
        Round = 7,
        Stroke = true,
        Clip = true
    })

    gradient(Card, ColorSequence.new({
        ColorSequenceKeypoint.new(0, lift(Theme.HoveredElement, 0.075)),
        ColorSequenceKeypoint.new(1, lift(Theme.HoveredElement, 0.025))
    }))

    local IconBox = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(13, 15),
        Size = UDim2.fromOffset(34, 34),
        Round = 9,
        Stroke = true
    })

    gradient(IconBox, seq(Theme.Element))

    local IconImage = icon({
        Parent = IconBox,
        Pos = UDim2.fromScale(0.5, 0.5),
        Anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(18, 18),
        Icon = params.Icon or ICON.Key,
        Color = params.Tone == "bad" and Danger or Theme.Accent
    })

    local Title = text({
        Parent = Card,
        Pos = UDim2.fromOffset(58, 12),
        Box = UDim2.fromOffset(TW - 58 - 48, 18),
        Text = params.Title or "Lunaris",
        Size = 14,
        Truncate = true
    })

    local Countdown = text({
        Parent = Card,
        Pos = UDim2.fromOffset(TW - 44, 12),
        Box = UDim2.fromOffset(32, 18),
        Text = string.format("%.1fs", duration),
        Size = 12,
        Color = Theme.InactiveText,
        Align = Enum.TextXAlignment.Right
    })

    local Body = text({
        Parent = Card,
        Pos = UDim2.fromOffset(58, 31),
        Box = UDim2.fromOffset(TW - 70, 16),
        Text = params.Body or "",
        Size = 12.5,
        Color = Theme.InactiveText,
        Truncate = true
    })

    local Track = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(12, TH - 13),
        Size = UDim2.fromOffset(BARW, BAR),
        Color = Theme.Background,
        Transparency = 0.25,
        Round = 4,
        Clip = true
    })

    local Timer = frame({
        Parent = Track,
        Size = UDim2.fromOffset(BARW, BAR),
        Round = 4
    })

    gradient(Timer, ColorSequence.new({
        ColorSequenceKeypoint.new(0, lift(Theme.Accent, 0.08)),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    }), 0)

    tween(Card, { Position = UDim2.fromOffset(0, 0) }, 0.35):Play()
    TweenSvc:Create(Timer, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.fromOffset(0, BAR) }):Play()

    local closed = false
    local deadline = os.clock() + duration

    local function close()
        if closed then
            return
        end

        closed = true

        tween(Card, { Position = UDim2.fromOffset(TW + 40, 0) }, 0.3, Enum.EasingStyle.Quart):Play()

        task.delay(0.32, function()
            pcall(function()
                Slot:Destroy()
            end)

            if ToastHolder and #ToastHolder:GetChildren() <= 1 and ToastGui then
                pcall(function()
                    ToastGui:Destroy()
                end)

                ToastGui, ToastHolder = nil, nil
            end
        end)
    end

    task.spawn(function()
        while not closed and Card.Parent do
            local left = math.max(0, deadline - os.clock())

            Countdown.Text = string.format("%.1fs", left)

            if left <= 0 then
                break
            end

            RunSvc.RenderStepped:Wait()
        end

        if not closed then
            close()
        end
    end)

    return {
        set = function(title, body, extend, iconName)
            if closed then
                return
            end

            if title then
                Title.Text = title
            end

            if body then
                Body.Text = body
            end

            if iconName then
                paintIcon(IconImage, iconName)
            end

            if extend then
                deadline = os.clock() + extend
                Timer.Size = UDim2.fromOffset(BARW, BAR)
                TweenSvc:Create(Timer, TweenInfo.new(extend, Enum.EasingStyle.Linear), { Size = UDim2.fromOffset(0, BAR) }):Play()
            end
        end,
        close = close
    }
end

local function buildNotice(params)
    local NW, NH = 420, 176
    local tone = params.Tone == "bad" and Danger or Theme.Accent
    local fit = fitScale(NW, NH)

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "\0"
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    Screen.DisplayOrder = 9999
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Screen.Parent = guiParent

    if typeof(protectgui) == "function" then
        pcall(protectgui, Screen)
    end

    local Shade = frame({
        Parent = Screen,
        Size = UDim2.fromScale(1, 1),
        Color = Theme.Shadow,
        Transparency = 1
    })

    local Card = frame({
        Parent = Shade,
        Size = UDim2.fromOffset(NW, NH),
        Pos = UDim2.fromScale(0.5, 0.5),
        Anchor = Vector2.new(0.5, 0.5),
        Color = Theme.Background,
        Round = 10,
        Clip = true
    })

    local CardScale = Instance.new("UIScale")
    CardScale.Scale = fit * 0.95
    CardScale.Parent = Card

    pcall(function()
        local shadow = Instance.new("UIShadow")
        shadow.BlurRadius = UDim.new(0, 22)
        shadow.Transparency = 0.25
        shadow.ZIndex = -2
        shadow.Parent = Card
    end)

    local BorderStroke = stroke(Card, tone, 1.6, 0.15)
    local BorderGradient = gradient(BorderStroke, sweep(tone), 0)

    local alive = true

    task.spawn(function()
        while alive and BorderGradient.Parent do
            BorderGradient.Rotation = (BorderGradient.Rotation + 1.4) % 360
            RunSvc.RenderStepped:Wait()
        end
    end)

    local IconBox = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(24, 24),
        Size = UDim2.fromOffset(40, 40),
        Round = 10,
        Stroke = true
    })

    gradient(IconBox, seq(Theme.Element))

    icon({
        Parent = IconBox,
        Pos = UDim2.fromScale(0.5, 0.5),
        Anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(22, 22),
        Icon = params.Icon or ICON.Alert,
        Color = tone
    })

    text({
        Parent = Card,
        Pos = UDim2.fromOffset(78, 26),
        Box = UDim2.fromOffset(NW - 102, 20),
        Text = params.Title,
        Size = 16,
        Color = tone,
        Truncate = true
    })

    text({
        Parent = Card,
        Pos = UDim2.fromOffset(78, 48),
        Box = UDim2.fromOffset(NW - 102, 40),
        Text = params.Body,
        Size = 12.5,
        Color = Theme.InactiveText,
        Wrap = true,
        VAlign = Enum.TextYAlignment.Top
    })

    frame({
        Parent = Card,
        Pos = UDim2.fromOffset(24, 108),
        Size = UDim2.fromOffset(NW - 48, 1),
        Color = Theme.Outline,
        Transparency = 0.6
    })

    text({
        Parent = Card,
        Pos = UDim2.fromOffset(24, 126),
        Box = UDim2.fromOffset(200, 30),
        Text = params.Footnote or "",
        Size = 11.5,
        Color = Theme.InactiveText
    })

    local Close = Instance.new("TextButton")
    Close.BackgroundColor3 = Theme.Element
    Close.BorderSizePixel = 0
    Close.AutoButtonColor = false
    Close.Text = ""
    Close.Position = UDim2.fromOffset(NW - 24 - 104, 122)
    Close.Size = UDim2.fromOffset(104, 38)
    Close.Parent = Card

    corner(Close, 8)
    stroke(Close)

    text({
        Parent = Close,
        Box = UDim2.fromOffset(104, 38),
        Text = "Close",
        Size = 14,
        Align = Enum.TextXAlignment.Center
    })

    local hovering, holding = false, false

    local function restyle(instant)
        local target = holding and shade(Theme.Element, 0.72) or (hovering and Theme.HoveredElement or Theme.Element)

        tween(Close, { BackgroundColor3 = target }, instant and 0.06 or 0.15, Enum.EasingStyle.Quad):Play()
    end

    Close.MouseEnter:Connect(function()
        hovering = true
        restyle()
    end)

    Close.MouseLeave:Connect(function()
        hovering, holding = false, false
        restyle()
    end)

    Close.MouseButton1Down:Connect(function()
        holding = true
        restyle(true)
    end)

    Close.MouseButton1Up:Connect(function()
        holding = false
        restyle()
    end)

    local Notice = {}

    function Notice.destroy()
        if not alive then
            return
        end

        alive = false

        pcall(function()
            Screen:Destroy()
        end)

        if G and G.__LunarisCleanup == Notice.destroy then
            G.__LunarisCleanup = nil
        end
    end

    Close.MouseButton1Click:Connect(function()
        if not alive then
            return
        end

        alive = false

        if G and G.__LunarisCleanup == Notice.destroy then
            G.__LunarisCleanup = nil
        end

        tween(Shade, { BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Quad):Play()
        fadeTree(Card, false, 0.25)
        task.wait(0.27)

        pcall(function()
            Screen:Destroy()
        end)
    end)

    if G then
        G.__LunarisCleanup = Notice.destroy
    end

    fadeTree(Card, true, 0.3)
    tween(Shade, { BackgroundTransparency = 0.55 }, 0.3):Play()
    tween(CardScale, { Scale = fit }, 0.34):Play()

    return Notice
end

local function buildUI()
    local UI = {}
    local fit = fitScale(W, H)

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "\0"
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    Screen.DisplayOrder = 9999
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Screen.Parent = guiParent

    if typeof(protectgui) == "function" then
        pcall(protectgui, Screen)
    end

    local Shade = frame({
        Parent = Screen,
        Size = UDim2.fromScale(1, 1),
        Color = Theme.Shadow,
        Transparency = 1
    })

    local Card = frame({
        Parent = Shade,
        Size = UDim2.fromOffset(W, H),
        Pos = UDim2.fromScale(0.5, 0.5),
        Anchor = Vector2.new(0.5, 0.5),
        Color = Theme.Background,
        Round = 10,
        Clip = true
    })

    local CardScale = Instance.new("UIScale")
    CardScale.Scale = fit * 0.95
    CardScale.Parent = Card

    pcall(function()
        local shadow = Instance.new("UIShadow")
        shadow.BlurRadius = UDim.new(0, 22)
        shadow.Transparency = 0.25
        shadow.ZIndex = -2
        shadow.Parent = Card
    end)

    local BorderStroke = stroke(Card, Theme.Accent, 1.6, 0.15)
    local BorderGradient = gradient(BorderStroke, sweep(Theme.Accent), 0)
    local ShopGradient = nil

    local alive = true

    task.spawn(function()
        while alive and BorderGradient.Parent do
            BorderGradient.Rotation = (BorderGradient.Rotation + 1.4) % 360

            if ShopGradient then
                ShopGradient.Rotation = (ShopGradient.Rotation - 2) % 360
            end

            RunSvc.RenderStepped:Wait()
        end
    end)

    local function makeButton(params)
        local base = params.Accent and Theme.Accent or Theme.Element
        local hover = params.Accent and lift(Theme.Accent, 0.07) or Theme.HoveredElement
        local pressed = params.Accent and shade(Theme.Accent, 0.74) or shade(Theme.Element, 0.72)

        local b = Instance.new("TextButton")
        b.BackgroundColor3 = base
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = ""
        b.Position = params.Pos
        b.Size = params.Size
        b.Parent = params.Parent or Card

        corner(b, 8)
        stroke(b)

        local ic = icon({
            Parent = b,
            Pos = UDim2.fromOffset(params.IconX, math.floor((params.Size.Y.Offset - 17) / 2)),
            Size = UDim2.fromOffset(17, 17),
            Icon = params.Icon,
            Color = Theme.Text
        })

        local lb = text({
            Parent = b,
            Pos = UDim2.fromOffset(params.IconX + 25, 0),
            Box = UDim2.fromOffset(params.Size.X.Offset - params.IconX - 29, params.Size.Y.Offset),
            Text = params.Text,
            Size = 14,
            Color = Theme.Text
        })

        local hovering, holding = false, false

        local function restyle(instant)
            local target = holding and pressed or (hovering and hover or base)

            tween(b, { BackgroundColor3 = target }, instant and 0.06 or 0.15, Enum.EasingStyle.Quad):Play()
        end

        b.MouseEnter:Connect(function()
            hovering = true
            restyle()
        end)

        b.MouseLeave:Connect(function()
            hovering, holding = false, false
            restyle()
        end)

        b.MouseButton1Down:Connect(function()
            holding = true
            restyle(true)
        end)

        b.MouseButton1Up:Connect(function()
            holding = false
            restyle()
        end)

        return b, lb, ic
    end

    local Header = frame({
        Parent = Card,
        Size = UDim2.fromOffset(W, HEAD),
        Color = Theme.Tab,
        Round = 10
    })

    frame({
        Parent = Header,
        Pos = UDim2.fromOffset(0, HEAD - 10),
        Size = UDim2.fromOffset(W, 10),
        Color = Theme.Tab
    })

    frame({
        Parent = Header,
        Pos = UDim2.fromOffset(0, HEAD - 1),
        Size = UDim2.fromOffset(W, 1),
        Color = Theme.Outline,
        Transparency = 0.55
    })

    icon({
        Parent = Header,
        Pos = UDim2.fromOffset(PAD, 12),
        Size = UDim2.fromOffset(138, 26),
        Image = CFG.Wordmark,
        Color = Color3.fromRGB(255, 255, 255)
    })

    text({
        Parent = Header,
        Pos = UDim2.fromOffset(PAD + 1, 40),
        Box = UDim2.fromOffset(150, 14),
        Text = CFG.Tagline,
        Size = 11.5,
        Color = Theme.InactiveText
    })

    local SX0, SY0 = 196, 12
    local SW, SH = W - SX0 - PAD - 46, 40

    local Search = frame({
        Parent = Header,
        Pos = UDim2.fromOffset(SX0, SY0),
        Size = UDim2.fromOffset(SW, SH),
        Round = 8
    })

    gradient(Search, seq(Theme.Gradient))

    local SearchStroke = stroke(Search)

    local SearchIcon = icon({
        Parent = Search,
        Pos = UDim2.fromOffset(14, 12),
        Size = UDim2.fromOffset(16, 16),
        Icon = ICON.Search,
        Color = Theme.InactiveText
    })

    local Query = fadeInput({
        Parent = Search,
        X = 34,
        Width = SW - 74,
        Height = SH,
        Edge = 6,
        Placeholder = "Search supported games"
    })

    local Badge = frame({
        Parent = Search,
        Pos = UDim2.fromOffset(SW - 88, 8),
        Size = UDim2.fromOffset(78, 24),
        Color = Theme.Element,
        Round = 12
    })

    stroke(Badge, Theme.Accent, 1, 0.55)

    icon({
        Parent = Badge,
        Pos = UDim2.fromOffset(9, 5),
        Size = UDim2.fromOffset(14, 14),
        Icon = ICON.Library,
        Color = Theme.Accent
    })

    text({
        Parent = Badge,
        Pos = UDim2.fromOffset(28, 0),
        Box = UDim2.fromOffset(46, 24),
        Text = #Games .. " games",
        Size = 11.5,
        Color = Theme.Accent
    })

    local Clear = Instance.new("TextButton")
    Clear.BackgroundTransparency = 1
    Clear.Text = ""
    Clear.Position = UDim2.fromOffset(SW - 34, 8)
    Clear.Size = UDim2.fromOffset(24, 24)
    Clear.Visible = false
    Clear.Parent = Search

    icon({
        Parent = Clear,
        Pos = UDim2.fromOffset(4, 4),
        Size = UDim2.fromOffset(16, 16),
        Icon = ICON.Close,
        Color = Theme.InactiveText
    })

    local CloseButton = Instance.new("TextButton")
    CloseButton.BackgroundColor3 = Theme.Element
    CloseButton.BorderSizePixel = 0
    CloseButton.AutoButtonColor = false
    CloseButton.Text = ""
    CloseButton.Position = UDim2.fromOffset(W - PAD - 36, 14)
    CloseButton.Size = UDim2.fromOffset(36, 36)
    CloseButton.Parent = Header

    corner(CloseButton, 8)
    stroke(CloseButton)

    local CloseIcon = icon({
        Parent = CloseButton,
        Pos = UDim2.fromOffset(10, 10),
        Size = UDim2.fromOffset(16, 16),
        Icon = ICON.Close,
        Color = Theme.InactiveText
    })

    CloseButton.MouseEnter:Connect(function()
        tween(CloseButton, { BackgroundColor3 = Theme.HoveredElement }, 0.15):Play()
        tween(CloseIcon, { ImageColor3 = Danger }, 0.15):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        tween(CloseButton, { BackgroundColor3 = Theme.Element }, 0.15):Play()
        tween(CloseIcon, { ImageColor3 = Theme.InactiveText }, 0.15):Play()
    end)

    local ROW, MAXROWS, TOP = 34, 7, 30

    local Results = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(SX0, SY0 + SH + 6),
        Size = UDim2.fromOffset(SW, 0),
        Color = Theme.Inline,
        Round = 8,
        Clip = true,
        Z = 40
    })

    Results.Visible = false

    stroke(Results, Theme.Outline, 1, 0.35)

    local Caption = text({
        Parent = Results,
        Pos = UDim2.fromOffset(14, 6),
        Box = UDim2.fromOffset(SW - 28, 18),
        Text = "",
        Size = 11.5,
        Color = Theme.InactiveText,
        Z = 41
    })

    local List = Instance.new("ScrollingFrame")
    List.BackgroundTransparency = 1
    List.BorderSizePixel = 0
    List.Position = UDim2.fromOffset(0, TOP)
    List.Size = UDim2.fromOffset(SW, 0)
    List.CanvasSize = UDim2.fromOffset(0, 0)
    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
    List.ScrollBarThickness = 3
    List.ScrollBarImageColor3 = Theme.Outline
    List.ScrollingDirection = Enum.ScrollingDirection.Y
    List.ZIndex = 41
    List.Parent = Results

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = List

    local ListPad = Instance.new("UIPadding")
    ListPad.PaddingLeft = UDim.new(0, 6)
    ListPad.PaddingRight = UDim.new(0, 8)
    ListPad.PaddingBottom = UDim.new(0, 6)
    ListPad.Parent = List

    local RowW = SW - 14

    local function addRow(order, name, tag, current)
        local Row = Instance.new("TextButton")
        Row.BackgroundColor3 = Theme.Inline
        Row.BackgroundTransparency = current and 0 or 1
        Row.BorderSizePixel = 0
        Row.AutoButtonColor = false
        Row.Text = ""
        Row.Size = UDim2.fromOffset(RowW, ROW)
        Row.LayoutOrder = order
        Row.ZIndex = 42
        Row.Parent = List

        if current then
            Row.BackgroundColor3 = Theme.Element
        end

        corner(Row, 6)

        icon({
            Parent = Row,
            Pos = UDim2.fromOffset(10, 9),
            Size = UDim2.fromOffset(16, 16),
            Icon = tag == "none" and ICON.Alert or ICON.Game,
            Color = tag == "none" and Danger or (current and Theme.Accent or Theme.InactiveText),
            Z = 43
        })

        text({
            Parent = Row,
            Pos = UDim2.fromOffset(36, 0),
            Box = UDim2.fromOffset(RowW - 36 - 118, ROW),
            Text = name,
            Size = 13.5,
            Color = tag == "none" and Theme.InactiveText or Theme.Text,
            Truncate = true,
            Z = 43
        })

        if tag ~= "none" then
            icon({
                Parent = Row,
                Pos = UDim2.fromOffset(RowW - 108, 10),
                Size = UDim2.fromOffset(14, 14),
                Icon = current and ICON.Pin or ICON.Tick,
                Color = Theme.Accent,
                Z = 43
            })

            text({
                Parent = Row,
                Pos = UDim2.fromOffset(RowW - 88, 0),
                Box = UDim2.fromOffset(84, ROW),
                Text = current and "You're here" or "Supported",
                Size = 11.5,
                Color = current and Theme.Accent or Theme.InactiveText,
                Z = 43
            })

            Row.MouseEnter:Connect(function()
                tween(Row, { BackgroundTransparency = 0, BackgroundColor3 = Theme.HoveredElement }, 0.12):Play()
            end)

            Row.MouseLeave:Connect(function()
                local keep = current and 0 or 1

                tween(Row, { BackgroundTransparency = keep, BackgroundColor3 = current and Theme.Element or Theme.Inline }, 0.12):Play()
            end)
        end
    end

    local function render(raw)
        for _, child in ipairs(List:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local query = string.lower((raw or ""):gsub("^%s+", ""):gsub("%s+$", ""))
        local shown = 0

        for _, entry in ipairs(Games) do
            if query == "" or entry.Name:lower():find(query, 1, true) or entry.Id:find(query, 1, true) then
                shown = shown + 1
                addRow(shown, entry.Name, "game", entry.Id == CurrentId)
            end
        end

        if shown == 0 then
            Caption.Text = "No results"
            addRow(1, "No supported game matches \"" .. raw .. "\"", "none", false)
        elseif query == "" then
            Caption.Text = "Supported games  •  " .. shown
        else
            Caption.Text = shown .. (shown == 1 and " match" or " matches")
        end

        local rows = math.max(shown, 1)
        local visible = math.min(rows, MAXROWS)
        local height = TOP + visible * (ROW + 2) + 6

        List.Size = UDim2.fromOffset(SW, height - TOP)
        List.CanvasPosition = Vector2.new(0, 0)

        Results.Visible = true
        tween(Results, { Size = UDim2.fromOffset(SW, height) }, 0.18):Play()
    end

    local function hideResults()
        local close = tween(Results, { Size = UDim2.fromOffset(SW, 0) }, 0.15)

        close:Play()
        close.Completed:Connect(function()
            if not Query:IsFocused() and Query.Text == "" then
                Results.Visible = false
            end
        end)
    end

    Query.Focused:Connect(function()
        tween(SearchStroke, { Color = Theme.Accent, Transparency = 0.1, Thickness = 1 }, 0.18):Play()
        tween(SearchIcon, { ImageColor3 = Theme.Accent }, 0.18):Play()
        render(Query.Text)
    end)

    Query.FocusLost:Connect(function()
        tween(SearchStroke, { Color = Theme.Outline, Transparency = 0.4, Thickness = 0.4 }, 0.18):Play()
        tween(SearchIcon, { ImageColor3 = Theme.InactiveText }, 0.18):Play()

        task.delay(0.18, function()
            if alive and not Query:IsFocused() and Query.Text == "" then
                hideResults()
            end
        end)
    end)

    Query:GetPropertyChangedSignal("Text"):Connect(function()
        local typed = Query.Text ~= ""

        Clear.Visible = typed
        Badge.Visible = not typed

        if typed or Query:IsFocused() then
            render(Query.Text)
        else
            hideResults()
        end
    end)

    Clear.MouseButton1Click:Connect(function()
        Query.Text = ""
        hideResults()
    end)

    local Left = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(0, HEAD),
        Size = UDim2.fromOffset(LEFT, H - HEAD),
        Color = Theme.Tab,
        Round = 10
    })

    frame({
        Parent = Left,
        Size = UDim2.fromOffset(LEFT, 10),
        Color = Theme.Tab
    })

    frame({
        Parent = Left,
        Pos = UDim2.fromOffset(LEFT - 10, 0),
        Size = UDim2.fromOffset(10, H - HEAD),
        Color = Theme.Tab
    })

    frame({
        Parent = Left,
        Pos = UDim2.fromOffset(LEFT - 1, 0),
        Size = UDim2.fromOffset(1, H - HEAD),
        Color = Theme.Outline,
        Transparency = 0.55
    })

    local Avatar = frame({
        Parent = Left,
        Pos = UDim2.fromOffset(PAD, 20),
        Size = UDim2.fromOffset(44, 44),
        Color = Theme.Element,
        Round = 22,
        Clip = true,
        Stroke = true
    })

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.Size = UDim2.fromScale(1, 1)
    AvatarImage.Image = ""
    AvatarImage.ImageTransparency = 1
    AvatarImage.Parent = Avatar

    corner(AvatarImage, 22)

    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)

        if ok and url and alive then
            AvatarImage.Image = url
            tween(AvatarImage, { ImageTransparency = 0 }, 0.3):Play()
        end
    end)

    text({
        Parent = Left,
        Pos = UDim2.fromOffset(PAD + 56, 24),
        Box = UDim2.fromOffset(LEFT - PAD * 2 - 56, 18),
        Text = LocalPlayer.DisplayName,
        Size = 14,
        Truncate = true
    })

    text({
        Parent = Left,
        Pos = UDim2.fromOffset(PAD + 56, 43),
        Box = UDim2.fromOffset(LEFT - PAD * 2 - 56, 16),
        Text = "@" .. LocalPlayer.Name,
        Size = 12,
        Color = Theme.InactiveText,
        Truncate = true
    })

    frame({
        Parent = Left,
        Pos = UDim2.fromOffset(PAD, 82),
        Size = UDim2.fromOffset(LEFT - PAD * 2, 1),
        Color = Theme.Outline,
        Transparency = 0.6
    })

    local function infoRow(y, iconName, label, value)
        icon({
            Parent = Left,
            Pos = UDim2.fromOffset(PAD + 1, y + 8),
            Size = UDim2.fromOffset(15, 15),
            Icon = iconName,
            Color = Theme.InactiveText
        })

        text({
            Parent = Left,
            Pos = UDim2.fromOffset(PAD + 26, y),
            Box = UDim2.fromOffset(LEFT - PAD * 2 - 26, 14),
            Text = label,
            Size = 11,
            Color = Theme.InactiveText
        })

        return text({
            Parent = Left,
            Pos = UDim2.fromOffset(PAD + 26, y + 15),
            Box = UDim2.fromOffset(LEFT - PAD * 2 - 26, 17),
            Text = value,
            Size = 13,
            Truncate = true
        })
    end

    infoRow(100, ICON.Game, "GAME", detected)
    infoRow(146, ICON.Cpu, "EXECUTOR", executorName)

    local AccessValue = infoRow(192, ICON.Lock, "ACCESS", "Locked")

    AccessValue.TextColor3 = Theme.InactiveText

    local SupportValue = infoRow(238, ICON.Library, "SUPPORTED", #Games .. " games")

    SupportValue.TextColor3 = Theme.Accent

    text({
        Parent = Left,
        Pos = UDim2.fromOffset(PAD, H - HEAD - 34),
        Box = UDim2.fromOffset(LEFT - PAD * 2, 16),
        Text = "Protected by Jnkie",
        Size = 11,
        Color = Theme.InactiveText
    })

    local RX = LEFT + 24
    local RW = BASE - RX - 24

    text({
        Parent = Card,
        Pos = UDim2.fromOffset(RX, HEAD + 22),
        Box = UDim2.fromOffset(RW, 24),
        Text = "Redeem your key",
        Size = 18
    })

    text({
        Parent = Card,
        Pos = UDim2.fromOffset(RX, HEAD + 48),
        Box = UDim2.fromOffset(RW, 34),
        Text = "Paste the key from the key page. Keys bind to this device.",
        Size = 12.5,
        Color = Theme.InactiveText,
        Wrap = true,
        VAlign = Enum.TextYAlignment.Top
    })

    local Field = frame({
        Parent = Card,
        Pos = UDim2.fromOffset(RX, HEAD + 92),
        Size = UDim2.fromOffset(RW, 48),
        Round = 8
    })

    gradient(Field, seq(Theme.Gradient))

    local FieldStroke = stroke(Field)

    local FieldIcon = icon({
        Parent = Field,
        Pos = UDim2.fromOffset(15, 16),
        Size = UDim2.fromOffset(17, 17),
        Icon = ICON.Key,
        Color = Theme.InactiveText
    })

    local Box = fadeInput({
        Parent = Field,
        X = 36,
        Width = RW - 50,
        Height = 48,
        Placeholder = "Paste your key here"
    })

    Box.Focused:Connect(function()
        tween(FieldStroke, { Color = Theme.Accent, Transparency = 0.1, Thickness = 1 }, 0.18):Play()
        tween(FieldIcon, { ImageColor3 = Theme.Accent }, 0.18):Play()
    end)

    Box.FocusLost:Connect(function()
        tween(FieldStroke, { Color = Theme.Outline, Transparency = 0.4, Thickness = 0.4 }, 0.18):Play()
        tween(FieldIcon, { ImageColor3 = Theme.InactiveText }, 0.18):Play()
    end)

    local Redeem, RedeemLabel = makeButton({
        Pos = UDim2.fromOffset(RX, HEAD + 152),
        Size = UDim2.fromOffset(RW, 46),
        Text = "Redeem Key",
        Icon = ICON.Check,
        IconX = math.floor(RW / 2) - 52,
        Accent = true
    })

    local GetKey = makeButton({
        Pos = UDim2.fromOffset(RX, HEAD + 206),
        Size = UDim2.fromOffset(RW, 42),
        Text = "Get Key",
        Icon = ICON.Link,
        IconX = math.floor(RW / 2) - 38
    })

    local StatusIcon = icon({
        Parent = Card,
        Pos = UDim2.fromOffset(RX + 8, HEAD + 272),
        Anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Color = Theme.InactiveText
    })

    StatusIcon.Visible = false

    local Status = text({
        Parent = Card,
        Pos = UDim2.fromOffset(RX, HEAD + 264),
        Box = UDim2.fromOffset(RW, 80),
        Text = "",
        Size = 12.5,
        Color = Theme.InactiveText,
        Wrap = true,
        VAlign = Enum.TextYAlignment.Top
    })

    local spinning = false

    local function stopSpin()
        spinning = false
        StatusIcon.Rotation = 0
    end

    local function startSpin()
        if spinning then
            return
        end

        spinning = true

        task.spawn(function()
            while spinning and alive and StatusIcon.Parent do
                StatusIcon.Rotation = (StatusIcon.Rotation + 6) % 360
                RunSvc.RenderStepped:Wait()
            end
        end)
    end

    function UI.say(msg, tone, iconName, spin)
        Status.Text = msg

        local color = Theme.InactiveText

        if tone == "bad" then
            color = Danger
        elseif tone == "good" then
            color = Theme.Accent
        end

        Status.TextColor3 = color

        if iconName then
            StatusIcon.Visible = true
            StatusIcon.ImageColor3 = color
            paintIcon(StatusIcon, iconName)
            Status.Position = UDim2.fromOffset(RX + 24, HEAD + 264)
            Status.Size = UDim2.fromOffset(RW - 24, 80)
        else
            StatusIcon.Visible = false
            Status.Position = UDim2.fromOffset(RX, HEAD + 264)
            Status.Size = UDim2.fromOffset(RW, 80)
        end

        if spin then
            startSpin()
        else
            stopSpin()
        end
    end

    function UI.setAccess(state, tone)
        AccessValue.Text = state

        if tone == "good" then
            AccessValue.TextColor3 = Theme.Accent
        elseif tone == "bad" then
            AccessValue.TextColor3 = Danger
        else
            AccessValue.TextColor3 = Theme.InactiveText
        end
    end

    function UI.setKey(value)
        Box.Text = value or ""
    end

    local ShopStroke = nil

    function UI.pulseShop()
        if not ShopStroke then
            return
        end

        task.spawn(function()
            for _ = 1, 3 do
                if not alive then
                    return
                end

                tween(ShopStroke, { Thickness = 3, Transparency = 0 }, 0.18):Play()
                task.wait(0.22)
                tween(ShopStroke, { Thickness = 1.4, Transparency = 0.2 }, 0.22):Play()
                task.wait(0.26)
            end
        end)
    end

    if CFG.Shop.Enabled then
        local PH = H - HEAD
        local HeroW = SHOP - PAD * 2
        local Link = tostring(CFG.Shop.Link)
        local Domain = Link:gsub("^https?://", ""):gsub("/+$", "")

        local Shop = frame({
            Parent = Card,
            Pos = UDim2.fromOffset(BASE, HEAD),
            Size = UDim2.fromOffset(SHOP, PH),
            Color = Theme.Tab,
            Round = 10
        })

        frame({
            Parent = Shop,
            Size = UDim2.fromOffset(SHOP, 10),
            Color = Theme.Tab
        })

        frame({
            Parent = Shop,
            Size = UDim2.fromOffset(10, PH),
            Color = Theme.Tab
        })

        frame({
            Parent = Shop,
            Size = UDim2.fromOffset(1, PH),
            Color = Theme.Outline,
            Transparency = 0.55
        })

        local Hero = frame({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD, 20),
            Size = UDim2.fromOffset(HeroW, 172),
            Round = 10,
            Clip = true
        })

        gradient(Hero, ColorSequence.new({
            ColorSequenceKeypoint.new(0, lift(Theme.Element, 0.03)),
            ColorSequenceKeypoint.new(1, shade(Theme.Element, 0.72))
        }))

        ShopStroke = stroke(Hero, Theme.Accent, 1.4, 0.2)
        ShopGradient = gradient(ShopStroke, sweep(Theme.Accent), 0)

        local Glow = frame({
            Parent = Hero,
            Pos = UDim2.new(0.5, 0, 0, 46),
            Anchor = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(54, 54),
            Color = Theme.Accent,
            Transparency = 0.82,
            Round = 27
        })

        stroke(Glow, Theme.Accent, 1, 0.45)

        icon({
            Parent = Glow,
            Pos = UDim2.fromScale(0.5, 0.5),
            Anchor = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(27, 27),
            Icon = ICON.Crown,
            Color = Theme.Accent
        })

        text({
            Parent = Hero,
            Pos = UDim2.fromOffset(0, 84),
            Box = UDim2.fromOffset(HeroW, 16),
            Text = CFG.Shop.Tag,
            Size = 12,
            Color = Theme.Accent,
            Align = Enum.TextXAlignment.Center
        })

        text({
            Parent = Hero,
            Pos = UDim2.fromOffset(10, 106),
            Box = UDim2.fromOffset(HeroW - 20, 50),
            Text = CFG.Shop.Title,
            Size = 17,
            Align = Enum.TextXAlignment.Center,
            Wrap = true,
            VAlign = Enum.TextYAlignment.Top
        })

        text({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD, 206),
            Box = UDim2.fromOffset(HeroW, 36),
            Text = CFG.Shop.Subtitle,
            Size = 12.5,
            Color = Theme.InactiveText,
            Align = Enum.TextXAlignment.Center,
            Wrap = true,
            VAlign = Enum.TextYAlignment.Top
        })

        frame({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD, 250),
            Size = UDim2.fromOffset(HeroW, 1),
            Color = Theme.Outline,
            Transparency = 0.6
        })

        icon({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD, 266),
            Size = UDim2.fromOffset(14, 14),
            Icon = ICON.Store,
            Color = Theme.InactiveText
        })

        text({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD + 22, 264),
            Box = UDim2.fromOffset(HeroW - 22, 18),
            Text = Domain,
            Size = 11.5,
            Color = Theme.InactiveText,
            Truncate = true
        })

        local Buy = makeButton({
            Parent = Shop,
            Pos = UDim2.fromOffset(PAD, PH - PAD - 48),
            Size = UDim2.fromOffset(HeroW, 48),
            Text = CFG.Shop.ButtonText,
            Icon = ICON.Cart,
            IconX = math.floor(HeroW / 2) - 24,
            Accent = true
        })

        Buy.MouseButton1Click:Connect(function()
            if clipboard then
                clipboard(Link)
                UI.say("Store link copied. Open it in your browser to buy a premium key.", "good", ICON.Copied)
            else
                UI.say("Open this in your browser:\n" .. Link, nil, ICON.Link)
            end
        end)
    end

    local cleanupHook

    local function unhook()
        if G and G.__LunarisCleanup == cleanupHook then
            G.__LunarisCleanup = nil
        end
    end

    function UI.destroy()
        if not alive then
            return
        end

        alive = false
        stopSpin()
        unhook()

        pcall(function()
            Screen:Destroy()
        end)
    end

    function UI.dismiss()
        if not alive then
            return
        end

        alive = false
        stopSpin()
        unhook()

        tween(Shade, { BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Quad):Play()
        fadeTree(Card, false, 0.25)
        task.wait(0.27)

        pcall(function()
            Screen:Destroy()
        end)
    end

    cleanupHook = function()
        UI.destroy()
        giveUp()
    end

    if G then
        G.__LunarisCleanup = cleanupHook
    end

    CloseButton.MouseButton1Click:Connect(function()
        UI.dismiss()
        giveUp()

        notify({
            Title = "Key system closed",
            Body = "Run the loader again whenever you are ready.",
            Icon = ICON.Close,
            Duration = 4
        })
    end)

    local busy = false

    local function attempt(key)
        if busy then
            return
        end

        key = (key or ""):gsub("%s+", "")

        if #key == 0 then
            UI.say("Enter a key first, or press Get Key.", "bad", ICON.Alert)

            return
        end

        busy = true
        RedeemLabel.Text = "Checking..."
        UI.setAccess("Checking", nil)
        UI.say("Validating with Jnkie...", nil, ICON.Spinner, true)

        task.spawn(function()
            local ok, kind, msg = authorise(key)

            if not alive then
                return
            end

            busy = false
            RedeemLabel.Text = "Redeem Key"

            if ok then
                rememberKey(key)
                UI.setAccess("Verified", "good")
                UI.say("Authorised. Loading " .. (detected or "script") .. "...", "good", ICON.Check)
                task.wait(0.45)
                UI.dismiss()
                publish(key)

                return
            end

            UI.setAccess("Locked", "bad")

            if keyIsDead(kind) then
                forgetKey()
            end

            if kind == "premium" then
                UI.pulseShop()
            end

            UI.say(msg or "Key rejected.", "bad", ICON.Alert)
        end)
    end

    Redeem.MouseButton1Click:Connect(function()
        attempt(Box.Text)
    end)

    Box.FocusLost:Connect(function(enter)
        if enter then
            attempt(Box.Text)
        end
    end)

    GetKey.MouseButton1Click:Connect(function()
        if clipboard then
            clipboard(CFG.GetKeyLink)
            UI.say("Key link copied. Open it in your browser, finish the steps, then paste the key here.", "good", ICON.Copied)
        else
            UI.say("Open this in your browser:\n" .. CFG.GetKeyLink, nil, ICON.Link)
        end
    end)

    fadeTree(Card, true, 0.3)
    tween(Shade, { BackgroundTransparency = 0.55 }, 0.3):Play()
    tween(CardScale, { Scale = fit }, 0.34):Play()

    return UI
end

local function main()
    local previous = G and G.SCRIPT_KEY

    if G then
        G.SCRIPT_KEY = nil
        G.UI_CLOSED = nil
    end

    if not detected then
        buildNotice({
            Title = "Game not supported",
            Body = "Lunaris Hub has no script for this game yet. Join a supported game and run the loader again.",
            Footnote = "GameId " .. CurrentId,
            Icon = ICON.Alert,
            Tone = "bad"
        })

        giveUp()

        return
    end

    local toast = notify({
        Title = CFG.Brand,
        Body = "Connecting to Jnkie...",
        Icon = ICON.Spinner,
        Duration = 12
    })

    if not sdk() then
        toast.close()

        local UI = buildUI()

        UI.setAccess("Offline", "bad")
        UI.say("Could not load the Jnkie SDK. Check your connection and run the loader again.", "bad", ICON.Alert)

        return
    end

    if keylessActive() then
        toast.set("Keyless Access", "No key needed right now, starting " .. detected .. "...", 4, ICON.Unlock)
        publish("KEYLESS")

        return
    end

    local saved = nil

    if type(previous) == "string" and previous ~= "" and previous ~= "KEYLESS" then
        saved = previous
    else
        saved = recallKey()
    end

    if saved and #saved > 0 then
        toast.set("Saved key found", "Verifying with Jnkie...", 12, ICON.Key)

        local ok, kind, msg = authorise(saved)

        if ok then
            rememberKey(saved)
            toast.set("Saved Key Loaded", "Starting " .. detected .. "...", 4, ICON.Check)
            publish(saved)

            return
        end

        toast.close()

        if keyIsDead(kind) then
            forgetKey()
        end

        local UI = buildUI()

        UI.setKey(saved)
        UI.setAccess("Locked", "bad")

        if kind == "premium" then
            UI.pulseShop()
        end

        if kind == "network" or kind == "config" or kind == "premium" then
            UI.say(msg, "bad", ICON.Alert)
        else
            UI.say("Saved key is no longer valid. Enter a new one, or press Get Key.", "bad", ICON.Alert)
        end

        return
    end

    toast.close()
    buildUI()
end

local ok, err = xpcall(main, function(e)
    local trace = ""

    pcall(function()
        trace = "\n" .. debug.traceback()
    end)

    return tostring(e) .. trace
end)

if not ok then
    warn("[Lunaris] loader failed: " .. tostring(err))

    pcall(buildNotice, {
        Title = "Loader error",
        Body = "Something went wrong starting the key system. Check your executor console for the full error and send it over.",
        Footnote = "GameId " .. CurrentId,
        Icon = ICON.Alert,
        Tone = "bad"
    })

    giveUp()
end

while not Finished do
    task.wait(0.1)
end
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end