--[================================================================================
    ██████╗ ██╗   ██╗██████╗  ██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██║   ██║██╔══██╗██╔═══██╗    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝██║   ██║██████╔╝██║   ██║    ███████║██║   ██║██████╔╝
    ██╔══██╗██║   ██║██╔══██╗██║   ██║    ██╔══██║██║   ██║██╔══██╗
    ██║  ██║╚██████╔╝██████╔╝╚██████╔╝    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
        RUBO HUB v2.0 PROFESSIONAL — Delta | Universal | Brookhaven Ready
        RGB · Target · Orbit · Figure · Structure · Recolor · World · Player
        Powered by RUBO — the #1 Roblox scripting platform
================================================================================]]

print("═══════════════════════════════════════════════════════════════")
print("   ★ RUBO HUB v2.0 PROFESSIONAL ★")
print("   Delta  ·  Universal  ·  Brookhaven Ready")
print("   RGB + Target + Orbit + Figure + Structure + Recolor + World")
print("═══════════════════════════════════════════════════════════════")
print("[Rubo Hub] Loaded v2.0 — Delta | Brookhaven ready | Pro enabled")

-- Unload previous instance safely
if getgenv().RuboUnload then pcall(getgenv().RuboUnload) end

--[[ ============================ 1. SERVICES ============================ ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--[[ ============================ 2. CONFIG ============================ ]]
local Config = {
    Theme = "Dark",
    Transparency = 0.05,
    MuteSFX = false,
    Compact = false,
    Keybind = Enum.KeyCode.RightShift,
    LastTab = "Home",
    MaxParts = 400,
    TargetName = "LocalPlayer",
    FollowTarget = false,
    ShowConsole = false,
    PropFilter = true,
    ShowTooltips = true,
    SoundVolume = 0.3,
    ShowFPS = true,
    PromoCount = 0,
    WinPos = UDim2.new(0.5, -400, 0.5, -280),
    WinSize = UDim2.new(0, 820, 0, 580),
}

--[[ ============================ 3. THEMES ============================ ]]
local Themes = {
    Dark = {
        bg=Color3.fromRGB(14,14,18), panel=Color3.fromRGB(22,22,29),
        panel2=Color3.fromRGB(28,28,38), border=Color3.fromRGB(42,42,54),
        accent=Color3.fromRGB(124,92,255), accent2=Color3.fromRGB(160,130,255),
        mint=Color3.fromRGB(0,224,184), text=Color3.fromRGB(230,230,240),
        subtext=Color3.fromRGB(150,150,165), danger=Color3.fromRGB(255,80,80),
        warn=Color3.fromRGB(255,180,60), ok=Color3.fromRGB(80,220,120),
        shadow=Color3.fromRGB(0,0,0),
    },
    ["Midnight Blue"] = {
        bg=Color3.fromRGB(10,14,28), panel=Color3.fromRGB(16,22,42),
        panel2=Color3.fromRGB(22,30,54), border=Color3.fromRGB(30,40,70),
        accent=Color3.fromRGB(90,120,255), accent2=Color3.fromRGB(130,160,255),
        mint=Color3.fromRGB(0,200,220), text=Color3.fromRGB(220,225,245),
        subtext=Color3.fromRGB(140,150,190), danger=Color3.fromRGB(255,80,80),
        warn=Color3.fromRGB(255,180,60), ok=Color3.fromRGB(80,220,120),
        shadow=Color3.fromRGB(0,0,10),
    },
    Mono = {
        bg=Color3.fromRGB(15,15,15), panel=Color3.fromRGB(28,28,28),
        panel2=Color3.fromRGB(36,36,36), border=Color3.fromRGB(50,50,50),
        accent=Color3.fromRGB(200,200,200), accent2=Color3.fromRGB(230,230,230),
        mint=Color3.fromRGB(180,180,180), text=Color3.fromRGB(240,240,240),
        subtext=Color3.fromRGB(150,150,150), danger=Color3.fromRGB(255,80,80),
        warn=Color3.fromRGB(255,180,60), ok=Color3.fromRGB(80,220,120),
        shadow=Color3.fromRGB(0,0,0),
    },
    Neon = {
        bg=Color3.fromRGB(8,4,20), panel=Color3.fromRGB(20,10,40),
        panel2=Color3.fromRGB(30,16,55), border=Color3.fromRGB(60,20,100),
        accent=Color3.fromRGB(255,0,200), accent2=Color3.fromRGB(255,80,220),
        mint=Color3.fromRGB(0,255,200), text=Color3.fromRGB(255,240,255),
        subtext=Color3.fromRGB(200,150,220), danger=Color3.fromRGB(255,80,80),
        warn=Color3.fromRGB(255,180,60), ok=Color3.fromRGB(80,220,120),
        shadow=Color3.fromRGB(0,0,10),
    },
    Ruby = {
        bg=Color3.fromRGB(18,6,10), panel=Color3.fromRGB(30,10,18),
        panel2=Color3.fromRGB(42,16,26), border=Color3.fromRGB(80,20,40),
        accent=Color3.fromRGB(255,40,90), accent2=Color3.fromRGB(255,100,140),
        mint=Color3.fromRGB(255,200,80), text=Color3.fromRGB(255,230,235),
        subtext=Color3.fromRGB(200,150,170), danger=Color3.fromRGB(255,80,80),
        warn=Color3.fromRGB(255,180,60), ok=Color3.fromRGB(80,220,120),
        shadow=Color3.fromRGB(0,0,0),
    },
}
local Theme = {}
for k,v in pairs(Themes.Dark) do Theme[k]=v end

--[[ ============================ 4. STATE ============================ ]]
local State = {
    Target = LP,
    FollowTarget = false,
    LastPos = Vector3.zero,
    LastSpawned = nil,
    CurrentTab = "Home",
    Initialized = false,
    Unloaded = false,
}
local Session = {Parts=0, Actions=0, Start=tick(), Undos=0, Redos=0}
local Connections = {}
local RuboParts = {}
local Actions = {}
local UndoStack, RedoStack = {}, {}
local LogLines = {}
local LogConsole, LogPanel
local RuntimeOrbit = {Active=false, Parts={}, Center=Vector3.zero, Cfg={}, Folder=nil, StartT=0}
local RuntimeFigure = {Instance=nil, Root=nil, OrbitActive=false, OrigCFrame=nil}
local StructFolder
local ToastContainer
local TooltipFrame
local LastDt = 1/60
local FpsSamples = {}

--[[ ============================ 5. LOGGER ============================ ]]
local Logger = {Lines = {}}
function Logger.Add(level, msg)
    local line = string.format("[%s] [%s] %s", os.date("%H:%M:%S"), string.upper(level), tostring(msg))
    table.insert(Logger.Lines, 1, line)
    if #Logger.Lines > 500 then table.remove(Logger.Lines) end
    if LogConsole and LogConsole.Parent then
        LogConsole.Text = table.concat(Logger.Lines, "\n")
    end
end
function Logger.Clear()
    table.clear(Logger.Lines)
    if LogConsole then LogConsole.Text = "" end
end
function Logger.Export()
    return table.concat(Logger.Lines, "\n")
end

--[[ ============================ 6. UTILITIES ============================ ]]
local function create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() i[k] = v end)
        end
    end
    if props and props.Parent then i.Parent = props.Parent end
    return i
end

local function tween(obj, info, goals)
    local t = TweenService:Create(obj, info, goals)
    t:Play()
    return t
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 6), Parent = parent })
end

local function stroke(parent, color, thickness)
    return create("UIStroke", { Color = color or Theme.border, Thickness = thickness or 1, Parent = parent })
end

local function padding(parent, t, b, l, r)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = parent,
    })
end

local function listLayout(parent, padY, padX)
    return create("UIListLayout", {
        Parent = parent,
        Padding = UDim.new(0, padY or 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
end

local function bind(sig, fn)
    local c = sig:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function safeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then Logger.Add("error", tostring(err)) end
    return ok
end

local function debounce(fn, delay)
    local last = 0
    return function(...)
        local now = tick()
        if now - last < (delay or 0.1) then return end
        last = now
        return fn(...)
    end
end

local function formatNumber(n)
    if n >= 1e6 then return string.format("%.1fM", n/1e6) end
    if n >= 1e3 then return string.format("%.1fk", n/1e3) end
    return tostring(math.floor(n))
end

local function clamp(v, lo, hi) return math.clamp(v, lo, hi) end

--[[ ============================ 7. SOUND ============================ ]]
local SOUNDS = {
    CLICK = "rbxassetid://12221967",
    HOVER = "rbxassetid://12221963",
    SUCCESS = "rbxassetid://12221957",
    ERROR = "rbxassetid://12221945",
    TAB = "rbxassetid://12221967",
    TOGGLE = "rbxassetid://12221960",
}
local function playSFX(id)
    if Config.MuteSFX then return end
    safeCall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = Config.SoundVolume
        s.Parent = SoundService
        s:Play()
        task.delay(2, function() if s then s:Destroy() end end)
    end)
end

--[[ ============================ 8. NOTIFICATIONS ============================ ]]
local ToastContainer
local function notify(kind, msg, dur)
    Logger.Add(kind, msg)
    if not ToastContainer then return end
    local col = Theme.mint
    if kind == "error" then col = Theme.danger
    elseif kind == "warn" then col = Theme.warn
    elseif kind == "info" then col = Theme.accent
    elseif kind == "success" then col = Theme.ok end
    local f = create("Frame", {
        Parent = ToastContainer,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.05,
    })
    corner(f, 8)
    create("UIStroke", { Color = col, Thickness = 1, Parent = f })
    create("Frame", {
        Parent = f,
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = col,
        BorderSizePixel = 0,
    })
    local lbl = create("TextLabel", {
        Parent = f,
        BackgroundTransparency = 1,
        Text = tostring(msg),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.text,
        Size = UDim2.new(1, -20, 1, -8),
        Position = UDim2.new(0, 12, 0, 4),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    f.BackgroundTransparency = 1
    lbl.TextTransparency = 1
    tween(f, TweenInfo.new(0.18), { BackgroundTransparency = 0.05 })
    tween(lbl, TweenInfo.new(0.18), { TextTransparency = 0 })
    task.delay(dur or 3, function()
        if f and f.Parent then tween(f, TweenInfo.new(0.25), { BackgroundTransparency = 1 }) end
        if lbl and lbl.Parent then tween(lbl, TweenInfo.new(0.25), { TextTransparency = 1 }) end
        task.wait(0.3)
        if f then f:Destroy() end
    end)
end

--[[ ============================ 9. TOOLTIPS ============================ ]]
local TooltipFrame
local function showTooltip(text, x, y)
    if not Config.ShowTooltips then return end
    if TooltipFrame then TooltipFrame:Destroy() end
    TooltipFrame = create("TextLabel", {
        Parent = Gui,
        Text = tostring(text),
        Font = Enum.Font.Code,
        TextSize = 11,
        TextColor3 = Theme.text,
        BackgroundColor3 = Theme.panel2,
        BorderSizePixel = 0,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.XY,
        Position = UDim2.new(0, x + 10, 0, y + 15),
        ZIndex = 200,
        Visible = true,
    })
    corner(TooltipFrame, 4)
    stroke(TooltipFrame, Theme.accent, 1)
    padding(TooltipFrame, 6, 6, 8, 8)
end
local function hideTooltip()
    if TooltipFrame then
        TooltipFrame:Destroy()
        TooltipFrame = nil
    end
end
local function attachTooltip(btn, text)
    btn.MouseEnter:Connect(function()
        local p = UserInputService:GetMouseLocation()
        showTooltip(text, p.X, p.Y)
    end)
    btn.MouseLeave:Connect(hideTooltip)
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            local p = i.Position
            showTooltip(text, p.X, p.Y)
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            hideTooltip()
        end
    end)
end

--[[ ============================ 10. PART TRACKER ============================ ]]
local PartTracker = {List = {}, NextId = 1}
function PartTracker.Track(inst, kind, color, meta)
    local id = PartTracker.NextId
    PartTracker.NextId += 1
    table.insert(PartTracker.List, {
        Id = id,
        Instance = inst,
        Kind = kind or "part",
        Color = color or (inst and inst.Color) or Color3.new(1,1,1),
        Meta = meta or {},
        Created = tick(),
    })
    Session.Parts += 1
    return id
end
function PartTracker.Count(filter)
    local n = 0
    for _, v in ipairs(PartTracker.List) do
        if v.Instance and v.Instance.Parent then
            if not filter or v.Kind == filter then
                n += 1
            end
        end
    end
    return n
end
function PartTracker.Clear(kindFilter)
    local removed = {}
    for i = #PartTracker.List, 1, -1 do
        local v = PartTracker.List[i]
        if not v.Instance or not v.Instance.Parent then
            table.remove(PartTracker.List, i)
        elseif not kindFilter or v.Kind == kindFilter then
            safeCall(function() v.Instance:Destroy() end)
            table.insert(removed, v)
            table.remove(PartTracker.List, i)
        end
    end
    return removed
end
function PartTracker.Recolor(kindFilter, color)
    for _, v in ipairs(PartTracker.List) do
        if v.Instance and v.Instance.Parent then
            if not kindFilter or v.Kind == kindFilter then
                safeCall(function() v.Instance.Color = color end)
                v.Color = color
            end
        end
    end
end
function PartTracker.ReleaseAll()
    local n = 0
    for _, v in ipairs(PartTracker.List) do
        if v.Instance and v.Instance.Parent then
            safeCall(function() v.Instance.Anchored = false end)
            n += 1
        end
    end
    return n
end
function PartTracker.CanSpawn(n)
    if PartTracker.Count() + n > Config.MaxParts then
        notify("error", "Part limit reached (" .. Config.MaxParts .. "). Reduce count or clear first.")
        return false
    end
    return true
end

--[[ ============================ 11. UNDO ENGINE ============================ ]]
local function pushUndo(name, undoFn, redoFn)
    table.insert(UndoStack, { name = name, undo = undoFn, redo = redoFn, time = tick() })
    if #UndoStack > 15 then table.remove(UndoStack, 1) end
    table.clear(RedoStack)
end
local function doUndo()
    local e = table.remove(UndoStack)
    if not e then notify("warn", "Nothing to undo") return end
    safeCall(e.undo)
    table.insert(RedoStack, e)
    Session.Undos += 1
    notify("info", "Undo: " .. e.name)
end
local function doRedo()
    local e = table.remove(RedoStack)
    if not e then notify("warn", "Nothing to redo") return end
    safeCall(e.redo)
    table.insert(UndoStack, e)
    Session.Redos += 1
    notify("info", "Redo: " .. e.name)
end

--[[ ============================ 12. ACTIONS ============================ ]]
local function addAction(text)
    table.insert(Actions, 1, { t = os.date("%H:%M:%S"), text = text })
    if #Actions > 5 then table.remove(Actions) end
    Session.Actions += 1
end

--[[ ============================ 13. BROOKHAVEN CATALOG ============================ ]]
local BrookhavenCatalog = {
    -- Big City
    "Desk Fan", "Radiator Heater", "Coat Rack", "Shoe Rack", "Newspaper Stand", "Doormat",
    -- Fall / Thanksgiving
    "Leaf Pile", "Corn Stalk", "Autumn Wreath", "Cornucopia", "Fall Pumpkin", "Hay Bale",
    "Wheelbarrow", "Standing Shelf", "Wall Shelf", "Hanging Fall Leaves",
    -- Artistic
    "Spraypaint Box", "Painting Supplies", "Paint Roller Tray", "Brick Wall", "Paint Bucket",
    "Paint Splatter", "Canvas", "Sketchbook", "Graffiti", "Painting",
    -- Movie Studio
    "Sci-Fi Incubator", "Gold Pile", "Director Chair", "Mannequin", "Conveyor",
    "Workstation", "Sorting Station",
    -- Daycare
    "Skateboard", "Scooter", "Segway", "Wheelchair", "Bike", "Bike Rack", "Robot", "Throne",
    "Garbage Can",
    -- 90s
    "Video Game Console", "CRT TV", "Lounge Chair",
    -- Common furniture
    "Cloud Sofa", "Dance Mat", "Soft Mat", "Player Chair", "Kitchen Item", "Bathroom Item",
    "Couch", "Sofa", "Chair", "Table", "Desk", "Bed", "Lamp", "Rug", "Plant", "TV",
    "Monitor", "Computer", "Fridge", "Stove", "Sink", "Toilet", "Shower", "Bathtub",
    "Mirror", "Shelf", "Cabinet", "Bookshelf", "Toy", "Ball", "Car", "Piano", "Guitar",
    "Drum", "Microphone", "Speaker", "Camera", "Tripod",
}
local function isKnownProp(name)
    local lower = string.lower(name)
    for _, k in ipairs(BrookhavenCatalog) do
        if string.find(lower, string.lower(k), 1, true) then
            return true
        end
    end
    return false
end

--[[ ============================ 14. COMMAND REGISTRY ============================ ]]
local CommandRegistry = {}
function CommandRegistry.Register(name, category, fn, description)
    table.insert(CommandRegistry, {
        name = name,
        category = category or "General",
        fn = fn,
        description = description or "",
    })
end
function CommandRegistry.Search(filter)
    if not filter or filter == "" then return CommandRegistry end
    filter = string.lower(filter)
    local results = {}
    for _, cmd in ipairs(CommandRegistry) do
        if string.find(string.lower(cmd.name), filter, 1, true) then
            table.insert(results, cmd)
        end
    end
    return results
end

--[[ ============================ 15. GUI SHELL ============================ ]]
local Gui = create("ScreenGui", {
    Name = "RuboHubPro",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function() Gui.Parent = CoreGui end)
if not Gui.Parent then Gui.Parent = LP:WaitForChild("PlayerGui") end

local Window = create("Frame", {
    Parent = Gui,
    Name = "Window",
    Size = UDim2.new(0, 820, 0, 580),
    Position = UDim2.new(0.5, -410, 0.5, -290),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})
corner(Window, 12)
stroke(Window, Theme.border, 1)

-- Title bar
local TitleBar = create("Frame", {
    Parent = Window,
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
})
corner(TitleBar, 12)
create("Frame", {
    Parent = TitleBar,
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 1, -22),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
})
create("TextLabel", {
    Parent = TitleBar,
    Position = UDim2.new(0, 16, 0, 0),
    Size = UDim2.new(0, 200, 1, 0),
    BackgroundTransparency = 1,
    Text = "◆ RUBO",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Theme.accent,
    TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", {
    Parent = TitleBar,
    Position = UDim2.new(0, 78, 0, 0),
    Size = UDim2.new(0, 200, 1, 0),
    BackgroundTransparency = 1,
    Text = "PRO v2.0",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = Theme.subtext,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local MinBtn = create("TextButton", {
    Parent = TitleBar,
    Position = UDim2.new(1, -84, 0, 7),
    Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Theme.border,
    BorderSizePixel = 0,
    Text = "–",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(MinBtn, 6)
attachTooltip(MinBtn, "Minimize to floating icon")

local MaxBtn = create("TextButton", {
    Parent = TitleBar,
    Position = UDim2.new(1, -56, 0, 7),
    Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Theme.border,
    BorderSizePixel = 0,
    Text = "□",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(MaxBtn, 6)
attachTooltip(MaxBtn, "Maximize / restore")

local CloseBtn = create("TextButton", {
    Parent = TitleBar,
    Position = UDim2.new(1, -28, 0, 7),
    Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Theme.danger,
    BorderSizePixel = 0,
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    AutoButtonColor = false,
})
corner(CloseBtn, 6)
attachTooltip(CloseBtn, "Close & unload hub")

-- Top bar
local TopBar = create("Frame", {
    Parent = Window,
    Position = UDim2.new(0, 0, 0, 38),
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
})
local SearchBox = create("TextBox", {
    Parent = TopBar,
    Position = UDim2.new(0, 12, 0, 8),
    Size = UDim2.new(0, 240, 0, 24),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    PlaceholderText = "🔍 Search commands or tabs...",
    Font = Enum.Font.Code,
    TextSize = 12,
    TextColor3 = Theme.text,
    PlaceholderColor3 = Theme.subtext,
    ClearTextOnFocus = false,
})
corner(SearchBox, 6)
stroke(SearchBox, Theme.border, 1)
attachTooltip(SearchBox, "Filter tabs by name — Ctrl+K for command palette")

local TargetBtn = create("TextButton", {
    Parent = TopBar,
    Position = UDim2.new(1, -280, 0, 8),
    Size = UDim2.new(0, 200, 0, 24),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "🎯 LocalPlayer",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(TargetBtn, 6)
stroke(TargetBtn, Theme.border, 1)
attachTooltip(TargetBtn, "Select target player for all features")

local FollowBtn = create("TextButton", {
    Parent = TopBar,
    Position = UDim2.new(1, -74, 0, 8),
    Size = UDim2.new(0, 64, 0, 24),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "Follow",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = Theme.subtext,
    AutoButtonColor = false,
})
corner(FollowBtn, 6)
stroke(FollowBtn, Theme.border, 1)
attachTooltip(FollowBtn, "Toggle: re-anchor objects when target moves")

-- Sidebar
local Sidebar = create("Frame", {
    Parent = Window,
    Position = UDim2.new(0, 0, 0, 78),
    Size = UDim2.new(0, 160, 1, -114),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
})
padding(Sidebar, 8, 8, 6, 6)
listLayout(Sidebar, 4)

-- Content area
local ContentArea = create("Frame", {
    Parent = Window,
    Position = UDim2.new(0, 160, 0, 78),
    Size = UDim2.new(1, -160, 1, -114),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})

-- Status bar
local StatusBar = create("Frame", {
    Parent = Window,
    Position = UDim2.new(0, 0, 1, -36),
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
})
local StatusText = create("TextLabel", {
    Parent = StatusBar,
    Name = "StatusText",
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(1, -320, 1, 0),
    BackgroundTransparency = 1,
    Text = "READY",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = Theme.subtext,
    TextXAlignment = Enum.TextXAlignment.Left,
})
local UndoBtn = create("TextButton", {
    Parent = StatusBar,
    Position = UDim2.new(1, -200, 0, 6),
    Size = UDim2.new(0, 60, 0, 24),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "↶ Undo",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(UndoBtn, 6)
stroke(UndoBtn, Theme.border, 1)
attachTooltip(UndoBtn, "Undo last action (Ctrl+Z)")
local RedoBtn = create("TextButton", {
    Parent = StatusBar,
    Position = UDim2.new(1, -136, 0, 6),
    Size = UDim2.new(0, 60, 0, 24),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "↷ Redo",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(RedoBtn, 6)
stroke(RedoBtn, Theme.border, 1)
attachTooltip(RedoBtn, "Redo last undo (Ctrl+Y)")

-- Watermark
create("TextLabel", {
    Parent = Window,
    Position = UDim2.new(1, -130, 0, 48),
    Size = UDim2.new(0, 120, 0, 16),
    BackgroundTransparency = 1,
    Text = "RUBO v2.0 ✦",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = Theme.accent,
    TextTransparency = 0.4,
    TextXAlignment = Enum.TextXAlignment.Right,
})

-- Toast container
ToastContainer = create("Frame", {
    Parent = Gui,
    Position = UDim2.new(1, -320, 1, -20),
    Size = UDim2.new(0, 300, 0, 10),
    AnchorPoint = Vector2.new(0, 1),
    BackgroundTransparency = 1,
})
create("UIListLayout", {
    Parent = ToastContainer,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
})

-- Floating icon
local FloatingIcon = create("TextButton", {
    Parent = Gui,
    Visible = false,
    Position = UDim2.new(0, 20, 0, 120),
    Size = UDim2.new(0, 56, 0, 56),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
    Text = "◆",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextColor3 = Theme.accent,
    AutoButtonColor = false,
})
corner(FloatingIcon, 28)
stroke(FloatingIcon, Theme.accent, 2)

--[[ ============================ 16. UI PRIMITIVES ============================ ]]
local UI = {}

function UI.Divider(parent)
    local d = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.border,
        BorderSizePixel = 0,
    })
    return d
end

function UI.Header(parent, text)
    return create("TextLabel", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

function UI.Label(parent, text, color, size)
    return create("TextLabel", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = tostring(text),
        Font = Enum.Font.Code,
        TextSize = size or 11,
        TextColor3 = color or Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

function UI.Button(parent, text, onClick, opts)
    opts = opts or {}
    local height = opts.height or (isMobile and 44 or 34)
    local b = create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = opts.color or Theme.panel,
        BorderSizePixel = 0,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 13 or 12,
        TextColor3 = Theme.text,
        AutoButtonColor = false,
    })
    corner(b, 6)
    stroke(b, opts.strokeColor or Theme.border, 1)
    local deb = false
    b.MouseButton1Click:Connect(function()
        if deb then return end
        deb = true
        playSFX(SOUNDS.CLICK)
        safeCall(onClick)
        task.delay(0.2, function() deb = false end)
    end)
    b.MouseEnter:Connect(function()
        tween(b, TweenInfo.new(0.12), { BackgroundColor3 = Theme.border })
    end)
    b.MouseLeave:Connect(function()
        tween(b, TweenInfo.new(0.12), { BackgroundColor3 = opts.color or Theme.panel })
    end)
    if opts.tooltip then attachTooltip(b, opts.tooltip) end
    return b
end

function UI.Slider(parent, label, min, max, default, onChange, opts)
    opts = opts or {}
    local holder = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, isMobile and 44 or 36),
        BackgroundTransparency = 1,
    })
    create("TextLabel", {
        Parent = holder,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, -70, 0, 16),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local val = create("TextLabel", {
        Parent = holder,
        Position = UDim2.new(1, -68, 0, 0),
        Size = UDim2.new(0, 68, 0, 16),
        BackgroundTransparency = 1,
        Text = tostring(default),
        Font = Enum.Font.Code,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    local bar = create("Frame", {
        Parent = holder,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Theme.border,
        BorderSizePixel = 0,
    })
    corner(bar, 4)
    local rel = clamp((default - min) / (max - min), 0, 1)
    local fill = create("Frame", {
        Parent = bar,
        Size = UDim2.new(rel, 0, 1, 0),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    })
    corner(fill, 4)
    local current = default
    local dragging = false
    local function upd(x)
        local r = clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = min + (max - min) * r
        v = math.floor(v * 100 + 0.5) / 100
        fill.Size = UDim2.new(r, 0, 1, 0)
        val.Text = tostring(v)
        current = v
        if onChange then safeCall(onChange, v) end
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            upd(i.Position.X)
        end
    end)
    bind(UserInputService.InputChanged, function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end)
    bind(UserInputService.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    if opts.tooltip then attachTooltip(holder, opts.tooltip) end
    return {
        Get = function() return current end,
        Set = function(v)
            v = clamp(v, min, max)
            fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
            val.Text = tostring(v)
            current = v
            if onChange then safeCall(onChange, v) end
        end,
    }
end

function UI.Toggle(parent, label, default, onChange, opts)
    opts = opts or {}
    local holder = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, isMobile and 36 or 30),
        BackgroundTransparency = 1,
    })
    create("TextLabel", {
        Parent = holder,
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 13 or 12,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local state = default and true or false
    local btn = create("TextButton", {
        Parent = holder,
        Position = UDim2.new(1, -44, 0.5, -11),
        Size = UDim2.new(0, 44, 0, 22),
        BackgroundColor3 = state and Theme.mint or Theme.border,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    })
    corner(btn, 11)
    local dot = create("Frame", {
        Parent = btn,
        Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    })
    corner(dot, 9)
    btn.MouseButton1Click:Connect(function()
        state = not state
        playSFX(SOUNDS.TOGGLE)
        tween(btn, TweenInfo.new(0.15), { BackgroundColor3 = state and Theme.mint or Theme.border })
        tween(dot, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2),
        })
        if onChange then safeCall(onChange, state) end
    end)
    if opts.tooltip then attachTooltip(holder, opts.tooltip) end
    return {
        Get = function() return state end,
        Set = function(v)
            if v ~= state then
                state = v
                btn.BackgroundColor3 = state and Theme.mint or Theme.border
                dot.Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
                if onChange then safeCall(onChange, state) end
            end
        end,
    }
end

function UI.Dropdown(parent, label, options, default, onChange, opts)
    opts = opts or {}
    local holder = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, isMobile and 36 or 30),
        BackgroundTransparency = 1,
    })
    create("TextLabel", {
        Parent = holder,
        Size = UDim2.new(0.4, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local btn = create("TextButton", {
        Parent = holder,
        Position = UDim2.new(0.4, 0, 0, 2),
        Size = UDim2.new(0.6, -4, 1, -4),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Text = tostring(default or options[1]),
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.text,
        AutoButtonColor = false,
    })
    corner(btn, 6)
    stroke(btn, Theme.border, 1)
    local listOpen = false
    local list
    btn.MouseButton1Click:Connect(function()
        if listOpen and list then
            list:Destroy()
            list = nil
            listOpen = false
            return
        end
        list = create("Frame", {
            Parent = Gui,
            Size = UDim2.new(0, 200, 0, math.min(240, #options * 26 + 8)),
            Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 2),
            BackgroundColor3 = Theme.panel,
            BorderSizePixel = 0,
            ZIndex = 50,
        })
        corner(list, 6)
        stroke(list, Theme.border, 1)
        listLayout(list, 2)
        padding(list, 4, 4, 4, 4)
        local scroll = create("ScrollingFrame", {
            Parent = list,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        })
        listLayout(scroll, 2)
        for _, opt in ipairs(options) do
            local o = create("TextButton", {
                Parent = scroll,
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = Theme.bg,
                BorderSizePixel = 0,
                Text = tostring(opt),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = Theme.text,
                AutoButtonColor = false,
            })
            corner(o, 4)
            o.MouseButton1Click:Connect(function()
                btn.Text = tostring(opt)
                list:Destroy()
                list = nil
                listOpen = false
                if onChange then safeCall(onChange, opt) end
            end)
        end
        listOpen = true
        task.delay(8, function()
            if list and list.Parent then
                list:Destroy()
                list = nil
                listOpen = false
            end
        end)
    end)
    if opts.tooltip then attachTooltip(holder, opts.tooltip) end
    return {
        Get = function() return btn.Text end,
        Set = function(v) btn.Text = tostring(v) end,
    }
end

function UI.TextBox(parent, label, default, onChange, opts)
    opts = opts or {}
    local holder = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, isMobile and 36 or 30),
        BackgroundTransparency = 1,
    })
    create("TextLabel", {
        Parent = holder,
        Size = UDim2.new(0.4, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local box = create("TextBox", {
        Parent = holder,
        Position = UDim2.new(0.4, 0, 0, 2),
        Size = UDim2.new(0.6, -4, 1, -4),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Text = tostring(default or ""),
        Font = Enum.Font.Code,
        TextSize = isMobile and 12 or 11,
        TextColor3 = Theme.text,
        ClearTextOnFocus = false,
    })
    corner(box, 6)
    stroke(box, Theme.border, 1)
    box.FocusLost:Connect(function()
        if onChange then safeCall(onChange, box.Text) end
    end)
    if opts.tooltip then attachTooltip(holder, opts.tooltip) end
    return {
        Get = function() return box.Text end,
        Set = function(v) box.Text = tostring(v) end,
    }
end

--[[ ============================ 17. COLOR PICKER ============================ ]]
local function createColorPicker(parent, onChanged, opts)
    opts = opts or {}
    local state = { R = 255, G = 255, B = 255, Sync = false }
    local container = create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 380),
        BackgroundTransparency = 1,
    })
    local preview = create("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    })
    corner(preview, 8)
    local y = 48
    local sliders = {}
    local hexInput
    local function refresh()
        if onChanged then safeCall(onChanged, Color3.fromRGB(state.R, state.G, state.B), state) end
    end
    local function setc(r, g, b)
        state.R = clamp(r, 0, 255)
        state.G = clamp(g, 0, 255)
        state.B = clamp(b, 0, 255)
        for k, v in pairs(sliders) do
            v.Fill.Size = UDim2.new(state[k] / 255, 0, 1, 0)
            v.Input.Text = tostring(math.floor(state[k]))
        end
        preview.BackgroundColor3 = Color3.fromRGB(state.R, state.G, state.B)
        if hexInput then
            hexInput.Text = string.format("#%02X%02X%02X", math.floor(state.R), math.floor(state.G), math.floor(state.B))
        end
        refresh()
    end
    for _, key in ipairs({ "R", "G", "B" }) do
        local row = create("Frame", {
            Parent = container,
            Position = UDim2.new(0, 0, 0, y),
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
        })
        create("TextLabel", {
            Parent = row,
            Size = UDim2.new(0, 24, 1, 0),
            BackgroundTransparency = 1,
            Text = key,
            Font = Enum.Font.Code,
            TextSize = 14,
            TextColor3 = Theme.text,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local bar = create("Frame", {
            Parent = row,
            Position = UDim2.new(0, 28, 0, 6),
            Size = UDim2.new(1, -100, 0, 16),
            BackgroundColor3 = Theme.border,
            BorderSizePixel = 0,
        })
        corner(bar, 5)
        local fc = key == "R" and Color3.fromRGB(255, 80, 80)
            or key == "G" and Color3.fromRGB(80, 220, 120)
            or Color3.fromRGB(80, 140, 255)
        local fill = create("Frame", {
            Parent = bar,
            Size = UDim2.new(state[key] / 255, 0, 1, 0),
            BackgroundColor3 = fc,
            BorderSizePixel = 0,
        })
        corner(fill, 5)
        local input = create("TextBox", {
            Parent = row,
            Position = UDim2.new(1, -66, 0, 0),
            Size = UDim2.new(0, 66, 1, 0),
            BackgroundColor3 = Theme.panel,
            BorderSizePixel = 0,
            Text = tostring(state[key]),
            Font = Enum.Font.Code,
            TextSize = 13,
            TextColor3 = Theme.text,
            ClearTextOnFocus = false,
        })
        corner(input, 5)
        stroke(input, Theme.border, 1)
        bar.InputBegan:Connect(function(ii)
            if ii.UserInputType == Enum.UserInputType.MouseButton1 or ii.UserInputType == Enum.UserInputType.Touch then
                local function move(mv)
                    if mv.UserInputType == Enum.UserInputType.MouseMovement or mv.UserInputType == Enum.UserInputType.Touch then
                        local r = clamp((mv.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(r * 255)
                        state[key] = v
                        fill.Size = UDim2.new(r, 0, 1, 0)
                        input.Text = tostring(v)
                        preview.BackgroundColor3 = Color3.fromRGB(state.R, state.G, state.B)
                        if hexInput then
                            hexInput.Text = string.format("#%02X%02X%02X", state.R, state.G, state.B)
                        end
                        refresh()
                    end
                end
                local conn
                conn = UserInputService.InputChanged:Connect(move)
                local endConn
                endConn = UserInputService.InputEnded:Connect(function(mv)
                    if mv.UserInputType == Enum.UserInputType.MouseButton1 or mv.UserInputType == Enum.UserInputType.Touch then
                        conn:Disconnect()
                        endConn:Disconnect()
                    end
                end)
            end
        end)
        input.FocusLost:Connect(function()
            local n = clamp(math.floor(tonumber(input.Text) or 0), 0, 255)
            state[key] = n
            input.Text = tostring(n)
            fill.Size = UDim2.new(n / 255, 0, 1, 0)
            preview.BackgroundColor3 = Color3.fromRGB(state.R, state.G, state.B)
            if hexInput then
                hexInput.Text = string.format("#%02X%02X%02X", state.R, state.G, state.B)
            end
            refresh()
        end)
        sliders[key] = { Fill = fill, Input = input, Bar = bar }
        y += 32
    end
    y += 8
    local hexRow = create("Frame", {
        Parent = container,
        Position = UDim2.new(0, 0, 0, y),
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
    })
    y += 34
    create("TextLabel", {
        Parent = hexRow,
        Size = UDim2.new(0, 40, 1, 0),
        BackgroundTransparency = 1,
        Text = "HEX",
        Font = Enum.Font.Code,
        TextSize = 13,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    hexInput = create("TextBox", {
        Parent = hexRow,
        Position = UDim2.new(0, 44, 0, 0),
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Text = "#FFFFFF",
        Font = Enum.Font.Code,
        TextSize = 13,
        TextColor3 = Theme.text,
        ClearTextOnFocus = false,
    })
    corner(hexInput, 5)
    stroke(hexInput, Theme.border, 1)
    hexInput.FocusLost:Connect(function()
        local s = hexInput.Text:gsub("#", "")
        if #s == 6 and tonumber(s, 16) then
            setc(tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16))
        else
            hexInput.Text = string.format("#%02X%02X%02X", state.R, state.G, state.B)
        end
    end)
    local btnRow = create("Frame", {
        Parent = container,
        Position = UDim2.new(0, 0, 0, y),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
    })
    y += 36
    local function miniBtn(text, x, w, fn)
        local b = create("TextButton", {
            Parent = btnRow,
            Position = UDim2.new(0, x, 0, 0),
            Size = UDim2.new(0, w, 1, 0),
            BackgroundColor3 = Theme.panel,
            BorderSizePixel = 0,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Theme.text,
            AutoButtonColor = false,
        })
        corner(b, 4)
        stroke(b, Theme.border, 1)
        b.MouseButton1Click:Connect(function()
            playSFX(SOUNDS.CLICK)
            safeCall(fn)
        end)
    end
    miniBtn("Random", 0, 70, function() setc(math.random(0, 255), math.random(0, 255), math.random(0, 255)) end)
    miniBtn("Copy Hex", 76, 80, function()
        local hex = string.format("#%02X%02X%02X", math.floor(state.R), math.floor(state.G), math.floor(state.B))
        pcall(function() setclipboard(hex) end)
        notify("info", "Copied " .. hex)
    end)
    miniBtn("Apply", 162, 70, function()
        if State.LastSpawned and State.LastSpawned.Parent then
            pcall(function() State.LastSpawned.Color = Color3.fromRGB(state.R, state.G, state.B) end)
            notify("info", "Applied to last spawned")
        else
            notify("warn", "No object to apply to")
        end
    end)
    local palette = {
        Color3.fromRGB(255, 80, 80), Color3.fromRGB(80, 220, 120), Color3.fromRGB(80, 140, 255),
        Color3.fromRGB(0, 224, 224), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 240, 80),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 140, 40),
        Color3.fromRGB(150, 80, 255), Color3.fromRGB(0, 224, 184), Color3.fromRGB(255, 200, 0),
        Color3.fromRGB(255, 100, 150), Color3.fromRGB(100, 255, 200), Color3.fromRGB(200, 100, 255),
        Color3.fromRGB(255, 180, 100), Color3.fromRGB(100, 180, 255), Color3.fromRGB(180, 180, 255),
    }
    local sw = 42
    local cols = 6
    for i, c in ipairs(palette) do
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        local b = create("TextButton", {
            Parent = container,
            Position = UDim2.new(0, col * (sw + 4), 0, y + row * (sw + 4)),
            Size = UDim2.new(0, sw, 0, sw),
            BackgroundColor3 = c,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        })
        corner(b, 6)
        stroke(b, Theme.border, 1)
        b.MouseButton1Click:Connect(function()
            setc(math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
        end)
    end
    y += math.ceil(#palette / cols) * (sw + 4)
    container.Size = UDim2.new(1, 0, 0, y + 8)
    if opts.syncTarget then
        UI.Toggle(container, "Sync RGB to Target", false, function(v)
            state.Sync = v
        end)
    end
    return { Get = function() return Color3.fromRGB(state.R, state.G, state.B) end, Set = setc, _state = state }
end

--[[ ============================ 18. TAB SYSTEM ============================ ]]
local Tabs = {}
local function makeTab(name, icon, order)
    local btn = create("TextButton", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 0, isMobile and 44 or 38),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Text = "  " .. icon .. "   " .. name,
        Font = Enum.Font.Gotham,
        TextSize = isMobile and 13 or 12,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = order,
    })
    corner(btn, 6)
    attachTooltip(btn, "Open " .. name .. " tab")
    local frame = create("ScrollingFrame", {
        Parent = ContentArea,
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        BorderSizePixel = 0,
    })
    padding(frame, 12, 12, 14, 14)
    listLayout(frame, 8)
    table.insert(Tabs, { Name = name, Button = btn, Frame = frame, Icon = icon })
    return frame
end

local function selectTab(name)
    State.CurrentTab = name
    Config.LastTab = name
    for _, t in ipairs(Tabs) do
        if t.Name == name then
            t.Frame.Visible = true
            t.Frame.Position = UDim2.new(0, 20, 0, 0)
            tween(t.Frame, TweenInfo.new(0.2), { Position = UDim2.new(0, 0, 0, 0) })
            t.Button.BackgroundColor3 = Theme.border
            t.Button.TextColor3 = Theme.text
        else
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = Theme.panel
            t.Button.TextColor3 = Theme.subtext
        end
    end
end

--[[ ============================ 19. TARGET SYSTEM ============================ ]]
local TargetHighlight
local function clearHighlight()
    if TargetHighlight then
        pcall(function() TargetHighlight:Destroy() end)
        TargetHighlight = nil
    end
end
local function applyHighlight(char)
    clearHighlight()
    if not char then return end
    safeCall(function()
        local h = Instance.new("Highlight")
        h.FillColor = Theme.accent
        h.OutlineColor = Theme.mint
        h.FillTransparency = 0.65
        h.OutlineTransparency = 0
        h.Parent = char
        TargetHighlight = h
    end)
end
local function getTargetChar()
    if State.Target == LP then return LP.Character end
    return State.Target and State.Target.Character
end
local function getTargetHRP()
    local c = getTargetChar()
    if c then return c:FindFirstChild("HumanoidRootPart") end
    return nil
end
local function getTargetPos()
    local hrp = getTargetHRP()
    if hrp then return hrp.Position end
    local c = LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then return c.HumanoidRootPart.Position end
    return Vector3.new(0, 5, 0)
end
local function setTarget(player)
    State.Target = player
    applyHighlight(player.Character)
    TargetBtn.Text = "🎯 " .. (player == LP and "LocalPlayer" or player.DisplayName)
    addAction("Target → " .. (player == LP and "LocalPlayer" or player.Name))
    if player ~= LP then
        bind(player.CharacterAdded, function(c) applyHighlight(c) end)
    end
    if RuntimeOrbit.Active and RuntimeOrbit.Cfg then
        RuntimeOrbit.Center = getTargetPos() + Vector3.new(0, RuntimeOrbit.Cfg.Height or 4, 0)
    end
end
local function refreshTargetList()
    local list = { LP }
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p) end
    end
    if State.Target ~= LP and (not State.Target or not State.Target.Parent) then
        setTarget(LP)
        notify("warn", "Target lost — reverted to LocalPlayer")
    end
    return list
end
bind(Players.PlayerAdded, function() refreshTargetList() end)
bind(Players.PlayerRemoving, function(p)
    if State.Target == p then
        setTarget(LP)
        notify("warn", "Target lost — reverted to LocalPlayer")
    end
end)
bind(LP.CharacterAdded, function(c) applyHighlight(c) end)
if LP.Character then applyHighlight(LP.Character) end

TargetBtn.MouseButton1Click:Connect(function()
    local list = refreshTargetList()
    local menu = create("Frame", {
        Parent = Gui,
        Size = UDim2.new(0, 260, 0, math.min(320, #list * 32 + 12)),
        Position = UDim2.new(0, TargetBtn.AbsolutePosition.X, 0, TargetBtn.AbsolutePosition.Y + TargetBtn.AbsoluteSize.Y + 2),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        ZIndex = 60,
    })
    corner(menu, 8)
    stroke(menu, Theme.border, 1)
    listLayout(menu, 2)
    padding(menu, 6, 6, 6, 6)
    for _, p in ipairs(list) do
        local label = p == LP and "LocalPlayer" or (p.DisplayName .. " (@" .. p.Name .. ")")
        local dist = ""
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            dist = string.format(" · %.0fs", (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude)
        end
        local b = create("TextButton", {
            Parent = menu,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.bg,
            BorderSizePixel = 0,
            Text = label .. dist,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Theme.text,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
        })
        corner(b, 4)
        padding(b, 0, 0, 8, 0)
        b.MouseButton1Click:Connect(function()
            setTarget(p)
            menu:Destroy()
        end)
    end
    task.delay(10, function() if menu and menu.Parent then menu:Destroy() end end)
end)

FollowBtn.MouseButton1Click:Connect(function()
    State.FollowTarget = not State.FollowTarget
    Config.FollowTarget = State.FollowTarget
    FollowBtn.TextColor3 = State.FollowTarget and Theme.mint or Theme.subtext
    notify("info", "Follow Target: " .. (State.FollowTarget and "ON" or "OFF"))
end)

--[[ ============================ 20. PERFORMANCE MONITOR ============================ ]]
local function getSmoothedFPS()
    table.insert(FpsSamples, 1 / (LastDt or 1/60))
    if #FpsSamples > 60 then table.remove(FpsSamples, 1) end
    local s = 0
    for _, v in ipairs(FpsSamples) do s += v end
    return math.floor(s / #FpsSamples + 0.5)
end
local function getPing()
    local ok, item = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"] end)
    if ok and item then return math.floor(item:GetValue()) end
    return 0
end
local function getMemory()
    local ok, val = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
    if ok then return math.floor(val) end
    return 0
end

--[[ ============================ 21. FOLLOW LOOP ============================ ]]
local FollowAcc = 0
bind(RunService.Heartbeat, function(dt)
    LastDt = dt
    if not State.FollowTarget then return end
    FollowAcc += dt
    if FollowAcc < 0.2 then return end
    FollowAcc = 0
    local hrp = getTargetHRP()
    if hrp then
        local newPos = hrp.Position
        if (newPos - State.LastPos).Magnitude > 8 then
            State.LastPos = newPos
            RuntimeOrbit.Center = newPos + Vector3.new(0, RuntimeOrbit.Cfg.Height or 4, 0)
            if RuntimeFigure.Root and RuntimeFigure.Root.Parent then
                safeCall(function() RuntimeFigure.Root.CFrame = CFrame.new(newPos) end)
            end
        end
    end
end)

--[[ ============================ 22. ORBIT LOOP ============================ ]]
local OrbitAcc = 0
bind(RunService.Heartbeat, function(dt)
    if not RuntimeOrbit.Active then return end
    OrbitAcc += dt * (RuntimeOrbit.Cfg.Speed or 1.5) * (RuntimeOrbit.Cfg.Direction or 1)
    local n = #RuntimeOrbit.Parts
    if n == 0 then return end
    local c = RuntimeOrbit.Center
    local r = RuntimeOrbit.Cfg.Radius or 8
    local tiltRad = math.rad(RuntimeOrbit.Cfg.Tilt or 0)
    for i, p in ipairs(RuntimeOrbit.Parts) do
        if p.Parent then
            local ang = (i / n) * math.pi * 2 + OrbitAcc
            local x = math.cos(ang) * r
            local z = math.sin(ang) * r
            local y = z * math.sin(tiltRad)
            p.CFrame = CFrame.new(c + Vector3.new(x, y, z)) * CFrame.Angles(ang, ang * 0.5, 0)
        end
    end
end)

--[[ ============================ 23. FIGURE ORBIT LOOP ============================ ]]
local FigOrbitAcc = 0
bind(RunService.Heartbeat, function(dt)
    if not RuntimeFigure.Root or not RuntimeFigure.Root.Parent then return end
    if not RuntimeFigure.OrbitActive then return end
    FigOrbitAcc += dt
    if FigOrbitAcc > 0.05 then
        FigOrbitAcc = 0
        safeCall(function()
            local c = RuntimeFigure.Root.CFrame
            local rot = CFrame.Angles(0, dt * 1.5, 0)
            RuntimeFigure.Root.CFrame = c * rot
        end)
    end
end)

--[[ ============================ 24. STATUS BAR LOOP ============================ ]]
local LastPerfUpdate = 0
bind(RunService.Heartbeat, function()
    if tick() - LastPerfUpdate < 0.5 then return end
    LastPerfUpdate = tick()
    local fps = getSmoothedFPS()
    local ping = getPing()
    local rubo = PartTracker.Count()
    local color = Theme.ok
    if fps < 30 then color = Theme.danger
    elseif fps < 50 then color = Theme.warn end
    local status = string.format(
        "FPS %d · %dms · Rubo %d/%d · Target %s · Follow %s · RUBO",
        fps, ping, rubo, Config.MaxParts,
        State.Target == LP and "Self" or State.Target.Name,
        State.FollowTarget and "ON" or "OFF"
    )
    if StatusText then
        StatusText.Text = status
        StatusText.TextColor3 = color
    end
end)

--[[ ============================ 25. HOME TAB ============================ ]]
local HomeFrame = makeTab("Home", "🏠", 1)
do
    create("TextLabel", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = "RUBO",
        Font = Enum.Font.GothamBold,
        TextSize = 48,
        TextColor3 = Theme.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    create("TextLabel", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "v2.0 PRO · Desktop-style hub for Brookhaven RP",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Theme.subtext,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local PromoBanner = create("Frame", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    })
    corner(PromoBanner, 8)
    create("TextLabel", {
        Parent = PromoBanner,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -28, 1, 0),
        BackgroundTransparency = 1,
        Text = "★ You're using RUBO HUB PRO — the #1 Brookhaven toolbox ★\nShare it with friends · More features coming soon",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    local HomeStatus = create("Frame", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    })
    corner(HomeStatus, 8)
    stroke(HomeStatus, Theme.border, 1)
    create("TextLabel", {
        Parent = HomeStatus,
        Name = "HStatus",
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -24, 1, -16),
        BackgroundTransparency = 1,
        Text = "Loading...",
        Font = Enum.Font.Code,
        TextSize = 12,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
    })
    create("TextLabel", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "Recent Actions",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local RecentFrame = create("Frame", {
        Parent = HomeFrame,
        Size = UDim2.new(1, 0, 0, 130),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    })
    corner(RecentFrame, 8)
    stroke(RecentFrame, Theme.border, 1)
    local RecentList = create("Frame", {
        Parent = RecentFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
    })
    padding(RecentList, 8, 8, 10, 10)
    listLayout(RecentList, 4)
    local function refreshRecent()
        for _, c in ipairs(RecentList:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        for _, a in ipairs(Actions) do
            create("TextLabel", {
                Parent = RecentList,
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = a.t .. "  " .. a.text,
                Font = Enum.Font.Code,
                TextSize = 11,
                TextColor3 = Theme.subtext,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        end
        if #Actions == 0 then
            create("TextLabel", {
                Parent = RecentList,
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = "— no actions yet —",
                Font = Enum.Font.Code,
                TextSize = 11,
                TextColor3 = Theme.subtext,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        end
    end
    task.spawn(function()
        while Gui and Gui.Parent do
            task.wait(1)
            if State.CurrentTab == "Home" then
                refreshRecent()
                local fps = getSmoothedFPS()
                local ping = getPing()
                local h = HomeStatus:FindFirstChild("HStatus")
                if h then
                    h.Text = string.format(
                        "FPS: %d   |   Ping: %dms   |   Players: %d   |   Memory: %d MB\nRubo Parts: %d / %d   |   Session: %d created   |   ★ Powered by RUBO HUB ★",
                        fps, ping, #Players:GetPlayers(), getMemory(),
                        PartTracker.Count(), Config.MaxParts, Session.Parts
                    )
                end
            end
        end
    end)
end

--[[ ============================ 26. PROPS TAB ============================ ]]
local PropsFrame = makeTab("Props", "📦", 2)
local propColorPicker
do
    propColorPicker = createColorPicker(PropsFrame, function(c, st)
        if propColorPicker and propColorPicker._state and propColorPicker._state.Sync then
            PartTracker.Recolor(nil, c)
        end
    end, { syncTarget = true })

    local function spawnProp(shape)
        if not PartTracker.CanSpawn(1) then return end
        local pos = getTargetPos() + Vector3.new(0, 3, 0)
        local cf = Camera.CFrame
        pos = pos + cf.LookVector * 5 + cf.RightVector * (math.random() - 0.5) * 4
        local p
        if shape == "Wedge" then
            p = create("WedgePart", {
                Parent = Workspace,
                Size = Vector3.new(2, 2, 2),
                Position = pos,
                Anchored = true,
                CanCollide = false,
                Material = Enum.Material.SmoothPlastic,
                Color = propColorPicker:Get(),
            })
        else
            p = create("Part", {
                Parent = Workspace,
                Size = Vector3.new(2, 2, 2),
                Position = pos,
                Anchored = true,
                CanCollide = false,
                Material = Enum.Material.SmoothPlastic,
                Color = propColorPicker:Get(),
                TopSurface = Enum.SurfaceType.Smooth,
                BottomSurface = Enum.SurfaceType.Smooth,
            })
            if shape == "Ball" then p.Shape = Enum.PartType.Ball
            elseif shape == "Cylinder" then p.Shape = Enum.PartType.Cylinder end
        end
        PartTracker.Track(p, "prop", p.Color)
        State.LastSpawned = p
        addAction("Spawned " .. shape)
        pushUndo("Spawn " .. shape, function()
            if p and p.Parent then p:Destroy() end
        end, function() end)
        notify("info", "Spawned " .. shape .. " · RUBO")
    end

    for _, s in ipairs({ "Block", "Ball", "Cylinder", "Wedge" }) do
        UI.Button(PropsFrame, "Spawn " .. s, function() spawnProp(s) end, { tooltip = "Spawn a " .. s .. " at target" })
    end
    UI.Slider(PropsFrame, "Size (prop scale)", 1, 10, 2, function(v)
        if State.LastSpawned and State.LastSpawned.Parent then
            safeCall(function() State.LastSpawned.Size = Vector3.new(v, v, v) end)
        end
    end, { tooltip = "Change size of last spawned prop" })
    UI.Toggle(PropsFrame, "Anchored", true, function(v)
        if State.LastSpawned and State.LastSpawned.Parent then State.LastSpawned.Anchored = v end
    end, { tooltip = "Anchor last spawned prop" })
    UI.Toggle(PropsFrame, "CanCollide", false, function(v)
        if State.LastSpawned and State.LastSpawned.Parent then State.LastSpawned.CanCollide = v end
    end, { tooltip = "Enable collisions on last spawned prop" })
    UI.Divider(PropsFrame)
    UI.Header(PropsFrame, "Attraction Tools")
    local attractRadius = UI.Slider(PropsFrame, "Attract Radius", 5, 80, 25, function() end, { tooltip = "Radius in studs to grab props" })
    UI.Toggle(PropsFrame, "Filter: Known Brookhaven Props Only", true, function(v) Config.PropFilter = v end, { tooltip = "Only grab known player-placed props" })
    UI.Button(PropsFrame, "Attract Nearby Props", function()
        local center = getTargetPos()
        local r = attractRadius.Get()
        local grabbed = 0
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v ~= (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")) then
                local dist = (v.Position - center).Magnitude
                if dist <= r then
                    local allowed = true
                    if Config.PropFilter then allowed = isKnownProp(v.Name) end
                    if allowed then
                        v.Anchored = true
                        PartTracker.Track(v, "attracted", v.Color)
                        grabbed += 1
                        if grabbed >= 200 then break end
                    end
                end
            end
        end
        notify("info", "Attracted " .. grabbed .. " props" .. (Config.PropFilter and " (filtered)" or ""))
        addAction("Attracted " .. grabbed .. " props")
    end, { tooltip = "Anchor and grab props within radius" })
    UI.Button(PropsFrame, "Release All", function()
        local n = PartTracker.ReleaseAll()
        notify("info", "Released " .. n .. " props")
    end, { tooltip = "Un-anchor all tracked props" })
    UI.Button(PropsFrame, "Delete All Spawned", function()
        local removed = PartTracker.Clear("prop")
        notify("info", "Deleted " .. (#removed) .. " props")
    end, { tooltip = "Delete all props spawned by RUBO", color = Theme.danger })
    UI.Button(PropsFrame, "Recolor Nearby (R=25)", function()
        local c = propColorPicker:Get()
        local center = getTargetPos()
        local saved = {}
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Position - center).Magnitude <= 25 then
                table.insert(saved, { p = v, c = v.Color })
                pcall(function() v.Color = c end)
            end
            if #saved >= 300 then break end
        end
        notify("info", "Recolored " .. #saved .. " parts · UNDO 5s")
        pushUndo("Recolor nearby", function()
            for _, s in ipairs(saved) do pcall(function() s.p.Color = s.c end) end
        end, function() end)
    end, { tooltip = "Recolor all parts within 25 studs of target" })
end

--[[ ============================ 27. ORBIT TAB ============================ ]]
local OrbitFrame = makeTab("Orbit", "⭕", 3)
local orbitCfg = {
    Radius = 8, Height = 4, Count = 12, Speed = 1.5, Tilt = 0,
    Shape = "Block", Direction = 1, Color = Color3.fromRGB(0, 224, 184),
}
do
    createColorPicker(OrbitFrame, function(c) orbitCfg.Color = c; PartTracker.Recolor("orbit", c) end)
    UI.Slider(OrbitFrame, "Radius", 2, 40, 8, function(v) orbitCfg.Radius = v; if RuntimeOrbit.Active then RuntimeOrbit.Cfg.Radius = v end end)
    UI.Slider(OrbitFrame, "Height Offset", -10, 20, 4, function(v) orbitCfg.Height = v; if RuntimeOrbit.Active then RuntimeOrbit.Cfg.Height = v end end)
    UI.Slider(OrbitFrame, "Count", 2, 60, 12, function(v) orbitCfg.Count = math.floor(v) end)
    UI.Slider(OrbitFrame, "Speed", 0, 10, 1.5, function(v) orbitCfg.Speed = v end)
    UI.Slider(OrbitFrame, "Tilt", -45, 45, 0, function(v) orbitCfg.Tilt = v end)
    UI.Dropdown(OrbitFrame, "Shape", { "Block", "Ball", "Cylinder", "Wedge" }, "Block", function(v) orbitCfg.Shape = v end)
    local function stopOrbit()
        if RuntimeOrbit.Active then
            RuntimeOrbit.Active = false
            for _, p in ipairs(RuntimeOrbit.Parts) do pcall(function() p:Destroy() end) end
            RuntimeOrbit.Parts = {}
            if RuntimeOrbit.Folder then pcall(function() RuntimeOrbit.Folder:Destroy() end) end
            RuntimeOrbit.Folder = nil
            notify("info", "Orbit stopped")
        end
    end
    local function startOrbit()
        if RuntimeOrbit.Active then notify("warn", "Already active") return end
        local folder = create("Folder", { Parent = Workspace, Name = "RuboOrbit" })
        RuntimeOrbit.Folder = folder
        RuntimeOrbit.Cfg = { Radius = orbitCfg.Radius, Height = orbitCfg.Height, Speed = orbitCfg.Speed, Direction = orbitCfg.Direction, Tilt = orbitCfg.Tilt }
        RuntimeOrbit.Center = getTargetPos() + Vector3.new(0, orbitCfg.Height, 0)
        RuntimeOrbit.Parts = {}
        local count = math.min(orbitCfg.Count, Config.MaxParts - PartTracker.Count())
        if count <= 0 then notify("error", "Part limit reached"); return end
        for i = 1, count do
            local p = create("Part", {
                Parent = folder,
                Size = Vector3.new(1.2, 1.2, 1.2),
                Anchored = true,
                CanCollide = false,
                Massless = true,
                CastShadow = false,
                Color = orbitCfg.Color,
                Material = Enum.Material.Neon,
                TopSurface = Enum.SurfaceType.Smooth,
                BottomSurface = Enum.SurfaceType.Smooth,
            })
            if orbitCfg.Shape == "Ball" then p.Shape = Enum.PartType.Ball
            elseif orbitCfg.Shape == "Cylinder" then p.Shape = Enum.PartType.Cylinder end
            PartTracker.Track(p, "orbit", orbitCfg.Color)
            table.insert(RuntimeOrbit.Parts, p)
        end
        RuntimeOrbit.Active = true
        notify("info", "Orbit started: " .. count .. " parts")
        addAction("Orbit started (" .. count .. ")")
    end
    UI.Button(OrbitFrame, "Start Orbit", startOrbit, { tooltip = "Spawn orbiting props around target" })
    UI.Button(OrbitFrame, "Stop Orbit", stopOrbit, { tooltip = "Stop and clear orbit", color = Theme.danger })
    UI.Button(OrbitFrame, "Reverse Direction", function()
        orbitCfg.Direction = -orbitCfg.Direction
        if RuntimeOrbit.Active then RuntimeOrbit.Cfg.Direction = orbitCfg.Direction end
        notify("info", "Direction flipped")
    end, { tooltip = "Reverse spin direction" })
    _G.RuboStartOrbit = startOrbit
    _G.RuboStopOrbit = stopOrbit
end

--[[ ============================ 28. FIGURE TAB ============================ ]]
local FigureFrame = makeTab("Figure", "🧍", 4)
local figCfg = {
    Scale = 1, Material = Enum.Material.SmoothPlastic, Outline = true,
    Pose = "Idle", Orbit = false, AtCursor = false,
    Color = Color3.fromRGB(200, 200, 220),
}
do
    createColorPicker(FigureFrame, function(c) figCfg.Color = c end)
    UI.Slider(FigureFrame, "Scale", 0.5, 3, 1, function(v) figCfg.Scale = v end)
    UI.Dropdown(FigureFrame, "Material", { "SmoothPlastic", "Neon", "Metal", "Wood", "Glass", "ForceField" }, "SmoothPlastic", function(v) figCfg.Material = Enum.Material[v] end)
    UI.Dropdown(FigureFrame, "Pose", { "Idle", "T-Pose", "Sitting", "Waving" }, "Idle", function(v) figCfg.Pose = v end)
    UI.Toggle(FigureFrame, "Neon Outline", true, function(v) figCfg.Outline = v end)
    UI.Toggle(FigureFrame, "Place at Cursor", false, function(v) figCfg.AtCursor = v end)
    UI.Toggle(FigureFrame, "Orbit Figure", false, function(v)
        figCfg.Orbit = v
        RuntimeFigure.OrbitActive = v
    end)
    local function clearFigure()
        if RuntimeFigure.Instance then
            pcall(function() RuntimeFigure.Instance:Destroy() end)
            RuntimeFigure.Instance = nil
            RuntimeFigure.Root = nil
            notify("info", "Figure cleared")
        end
    end
    local function buildFigure()
        local pos = getTargetPos()
        if figCfg.AtCursor then
            local ok, ray = pcall(function()
                local m = UserInputService:GetMouseLocation()
                return Camera:ViewportPointToRay(m.X, m.Y)
            end)
            if ok and ray then
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = { LP.Character }
                local res = Workspace:Raycast(ray.Origin, ray.Direction * 500, params)
                if res then pos = res.Position end
            end
        end
        if RuntimeFigure.Instance and RuntimeFigure.Instance.Parent then
            pcall(function() RuntimeFigure.Instance:Destroy() end)
        end
        local folder = create("Folder", { Parent = Workspace, Name = "RuboFigure" })
        local scale = figCfg.Scale
        local function mk(name, sz, offset)
            local p = create("Part", {
                Parent = folder,
                Name = name,
                Size = sz * scale,
                Anchored = true,
                CanCollide = false,
                Material = figCfg.Material,
                Color = figCfg.Color,
                TopSurface = Enum.SurfaceType.Smooth,
                BottomSurface = Enum.SurfaceType.Smooth,
            })
            p.Position = pos + Vector3.new(0, offset * scale, 0)
            PartTracker.Track(p, "figure", figCfg.Color)
            if figCfg.Outline then
                local hl = Instance.new("Highlight")
                hl.FillTransparency = 1
                hl.OutlineColor = figCfg.Color
                hl.OutlineTransparency = 0.3
                hl.Parent = p
            end
            return p
        end
        local torso = mk("Torso", Vector3.new(2, 2, 1), 3)
        local head = mk("Head", Vector3.new(1.4, 1.4, 1.4), 4.8)
        local armL = mk("ArmL", Vector3.new(0.8, 2, 0.8), 3)
        local armR = mk("ArmR", Vector3.new(0.8, 2, 0.8), 3)
        local legL = mk("LegL", Vector3.new(0.9, 2, 0.9), 1)
        local legR = mk("LegR", Vector3.new(0.9, 2, 0.9), 1)
        if figCfg.Pose == "T-Pose" then
            armL.CFrame = CFrame.new(torso.Position + Vector3.new(-1.4 * scale, 0, 0)) * CFrame.Angles(0, 0, math.rad(90))
            armR.CFrame = CFrame.new(torso.Position + Vector3.new(1.4 * scale, 0, 0)) * CFrame.Angles(0, 0, math.rad(90))
        elseif figCfg.Pose == "Sitting" then
            legL.CFrame = CFrame.new(torso.Position + Vector3.new(-0.5 * scale, -1 * scale, 0.5 * scale)) * CFrame.Angles(math.rad(90), 0, 0)
            legR.CFrame = CFrame.new(torso.Position + Vector3.new(0.5 * scale, -1 * scale, 0.5 * scale)) * CFrame.Angles(math.rad(90), 0, 0)
        elseif figCfg.Pose == "Waving" then
            armR.CFrame = CFrame.new(torso.Position + Vector3.new(1.4 * scale, 0.8 * scale, 0)) * CFrame.Angles(0, 0, math.rad(-160))
        end
        local root = torso
        for _, p in ipairs({ head, armL, armR, legL, legR }) do
            local w = Instance.new("WeldConstraint")
            w.Part0 = root
            w.Part1 = p
            w.Parent = root
        end
        RuntimeFigure.Instance = folder
        RuntimeFigure.Root = root
        RuntimeFigure.OrbitActive = figCfg.Orbit
        notify("info", "Figure built (" .. figCfg.Pose .. ") · RUBO")
        addAction("Figure (" .. figCfg.Pose .. ")")
        pushUndo("Build figure", function()
            if folder and folder.Parent then folder:Destroy() end
        end, function() end)
    end
    UI.Button(FigureFrame, "Build Figure", buildFigure, { tooltip = "Build a humanoid figure at target" })
    UI.Button(FigureFrame, "Clear Figure", clearFigure, { tooltip = "Remove current figure", color = Theme.danger })
    _G.RuboBuildFigure = buildFigure
    _G.RuboClearFigure = clearFigure
end

--[[ ============================ 29. STRUCTURE TAB ============================ ]]
local StructFrame = makeTab("Structure", "🏗️", 5)
local structCfg = {
    Type = "Ring of Pillars", Count = 8, Size = 2, Spacing = 6, Height = 8,
    Material = Enum.Material.SmoothPlastic, Color = Color3.fromRGB(124, 92, 255),
}
do
    createColorPicker(StructFrame, function(c) structCfg.Color = c; PartTracker.Recolor("structure", c) end)
    UI.Dropdown(StructFrame, "Type", { "Ring of Pillars", "Dome", "Spiral Staircase", "Arch", "Wall Row", "Bridge", "Tower", "Pyramid" }, "Ring of Pillars", function(v) structCfg.Type = v end)
    UI.Slider(StructFrame, "Count", 3, 40, 8, function(v) structCfg.Count = math.floor(v) end)
    UI.Slider(StructFrame, "Size", 1, 10, 2, function(v) structCfg.Size = v end)
    UI.Slider(StructFrame, "Spacing", 2, 20, 6, function(v) structCfg.Spacing = v end)
    UI.Slider(StructFrame, "Height", 2, 30, 8, function(v) structCfg.Height = v end)
    UI.Dropdown(StructFrame, "Material", { "SmoothPlastic", "Neon", "Metal", "Wood", "Concrete", "Glass" }, "SmoothPlastic", function(v) structCfg.Material = Enum.Material[v] end)
    local function clearStructure()
        if StructFolder then
            pcall(function() StructFolder:Destroy() end)
            StructFolder = nil
            notify("info", "Structure cleared")
        end
    end
    local function buildStructure()
        if StructFolder then pcall(function() StructFolder:Destroy() end) end
        StructFolder = create("Folder", { Parent = Workspace, Name = "RuboStructure" })
        local origin = getTargetPos()
        local count = math.min(structCfg.Count, Config.MaxParts - PartTracker.Count())
        if count < 1 then notify("error", "Part limit reached"); return end
        local function place(pos, sz, rot)
            local p = create("Part", {
                Parent = StructFolder,
                Size = sz,
                Position = pos,
                Anchored = true,
                CanCollide = true,
                Material = structCfg.Material,
                Color = structCfg.Color,
                TopSurface = Enum.SurfaceType.Smooth,
                BottomSurface = Enum.SurfaceType.Smooth,
            })
            if rot then p.CFrame = CFrame.new(pos) * rot end
            PartTracker.Track(p, "structure", structCfg.Color)
        end
        if structCfg.Type == "Ring of Pillars" then
            for i = 1, count do
                local ang = (i / count) * math.pi * 2
                local pos = origin + Vector3.new(math.cos(ang), 0, math.sin(ang)) * structCfg.Spacing
                place(pos + Vector3.new(0, structCfg.Height / 2, 0), Vector3.new(structCfg.Size, structCfg.Height, structCfg.Size))
            end
        elseif structCfg.Type == "Dome" then
            local r = structCfg.Spacing
            for i = 1, count do
                for j = 1, math.ceil(count / 2) do
                    local theta = (j / math.ceil(count / 2)) * math.pi / 2
                    local ang = (i / count) * math.pi * 2
                    local x = math.cos(ang) * math.cos(theta) * r
                    local y = math.sin(theta) * r
                    local z = math.sin(ang) * math.cos(theta) * r
                    place(origin + Vector3.new(x, y, z), Vector3.new(structCfg.Size, structCfg.Size, structCfg.Size))
                end
            end
        elseif structCfg.Type == "Spiral Staircase" then
            for i = 1, count * 2 do
                local ang = i * 0.6
                local y = i * structCfg.Size
                local pos = origin + Vector3.new(math.cos(ang) * structCfg.Spacing, y, math.sin(ang) * structCfg.Spacing)
                place(pos, Vector3.new(structCfg.Size * 2, structCfg.Size / 2, structCfg.Size * 1.5))
            end
        elseif structCfg.Type == "Arch" then
            for i = 1, count do
                local t = (i / count) * math.pi
                local x = math.cos(t) * structCfg.Spacing
                local y = math.sin(t) * structCfg.Spacing
                place(origin + Vector3.new(x, y, 0), Vector3.new(structCfg.Size, structCfg.Size, structCfg.Size))
            end
        elseif structCfg.Type == "Wall Row" then
            for i = 1, count do
                place(origin + Vector3.new((i - count / 2) * structCfg.Size * 2, structCfg.Height / 2, 0), Vector3.new(structCfg.Size * 2, structCfg.Height, structCfg.Size))
            end
        elseif structCfg.Type == "Bridge" then
            local length = structCfg.Count
            for i = 1, length do
                place(origin + Vector3.new((i - length / 2) * structCfg.Size * 2, 0, 0), Vector3.new(structCfg.Size * 2, structCfg.Size / 2, structCfg.Size * 3))
            end
            for i = 1, 2 do
                local x = (i == 1 and -1 or 1) * length / 2 * structCfg.Size * 2
                place(origin + Vector3.new(x, -structCfg.Height / 2, 0), Vector3.new(structCfg.Size, structCfg.Height, structCfg.Size * 3))
            end
        elseif structCfg.Type == "Tower" then
            for i = 1, count do
                local y = i * structCfg.Size
                place(origin + Vector3.new(0, y, 0), Vector3.new(structCfg.Size * 2, structCfg.Size, structCfg.Size * 2))
            end
        elseif structCfg.Type == "Pyramid" then
            local lvl = 1
            local y = 0
            while lvl <= count do
                local half = math.floor(count / 2) - lvl
                if half < 0 then break end
                for i = -half, half do
                    for j = -half, half do
                        place(origin + Vector3.new(i * structCfg.Size * 2, y, j * structCfg.Size * 2), Vector3.new(structCfg.Size, structCfg.Size, structCfg.Size))
                    end
                end
                y += structCfg.Size
                lvl += 1
            end
        end
        notify("info", "Structure built: " .. structCfg.Type .. " · RUBO")
        addAction("Structure: " .. structCfg.Type)
    end
    UI.Button(StructFrame, "Build Structure", buildStructure, { tooltip = "Build a procedural structure at target" })
    UI.Button(StructFrame, "Clear Structure", clearStructure, { tooltip = "Remove all structures", color = Theme.danger })
    _G.RuboBuildStructure = buildStructure
    _G.RuboClearStructure = clearStructure
end

--[[ ============================ 30. WORLD TAB ============================ ]]
local WorldFrame = makeTab("World", "🌍", 6)
do
    UI.Header(WorldFrame, "Time & Atmosphere")
    local originalClock, originalFogEnd, originalFogStart, originalBrightness
    pcall(function()
        originalClock = Lighting.ClockTime
        originalFogEnd = Lighting.FogEnd
        originalFogStart = Lighting.FogStart
        originalBrightness = Lighting.Brightness
    end)
    UI.Slider(WorldFrame, "Time of Day", 0, 24, 14, function(v)
        pcall(function() Lighting.ClockTime = v end)
    end, { tooltip = "Set sun position (client only)" })
    UI.Slider(WorldFrame, "Fog End", 100, 5000, 1000, function(v)
        pcall(function() Lighting.FogEnd = v end)
    end, { tooltip = "Set fog distance" })
    UI.Slider(WorldFrame, "Brightness", 0, 5, 2, function(v)
        pcall(function() Lighting.Brightness = v end)
    end, { tooltip = "Set lighting brightness" })
    UI.Button(WorldFrame, "Reset Atmosphere", function()
        pcall(function()
            Lighting.ClockTime = originalClock or 14
            Lighting.FogEnd = originalFogEnd or 1000
            Lighting.FogStart = originalFogStart or 0
            Lighting.Brightness = originalBrightness or 2
        end)
        notify("info", "Atmosphere reset")
    end, { tooltip = "Restore original lighting" })
    UI.Button(WorldFrame, "Night Mode", function()
        pcall(function() Lighting.ClockTime = 0 end)
        notify("info", "Set to midnight")
    end, { tooltip = "Set to midnight" })
    UI.Button(WorldFrame, "Day Mode", function()
        pcall(function() Lighting.ClockTime = 12 end)
        notify("info", "Set to noon")
    end, { tooltip = "Set to noon" })
end

--[[ ============================ 31. PLAYER TAB ============================ ]]
local PlayerFrame = makeTab("Player", "👤", 7)
do
    UI.Header(PlayerFrame, "Movement (client-side only)")
    UI.Label(PlayerFrame, "These affect only YOUR character locally.", Theme.subtext)
    local function getHumanoid()
        local c = LP.Character
        if c then return c:FindFirstChildOfClass("Humanoid") end
        return nil
    end
    UI.Slider(PlayerFrame, "Walk Speed", 16, 200, 16, function(v)
        local h = getHumanoid()
        if h then h.WalkSpeed = v end
    end, { tooltip = "Set your walk speed" })
    UI.Slider(PlayerFrame, "Jump Power", 50, 300, 50, function(v)
        local h = getHumanoid()
        if h then h.JumpPower = v end
    end, { tooltip = "Set your jump power" })
    local flyEnabled = false
    local flyBV, flyBG
    local flyConn
    UI.Toggle(PlayerFrame, "Fly (client)", false, function(v)
        flyEnabled = v
        local h = getHumanoid()
        if not h then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if v then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = root
            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 5000
            bg.Parent = root
            flyBV = bv
            flyBG = bg
            flyConn = RunService.RenderStepped:Connect(function()
                local h2 = getHumanoid()
                if not h2 or not root.Parent then return end
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
                bv.Velocity = dir * 60
                bg.CFrame = Camera.CFrame
            end)
            notify("info", "Fly enabled")
        else
            if flyBV then flyBV:Destroy(); flyBV = nil end
            if flyBG then flyBG:Destroy(); flyBG = nil end
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            notify("info", "Fly disabled")
        end
    end, { tooltip = "Enable client-side fly (WASD + Space)" })
    UI.Header(PlayerFrame, "Teleport")
    UI.Button(PlayerFrame, "Teleport to Target", function()
        local hrp = getTargetHRP()
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and myRoot then
            myRoot.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
            notify("info", "Teleported to target")
        else
            notify("warn", "Target not available")
        end
    end, { tooltip = "Teleport to current target (client only)" })
    UI.Button(PlayerFrame, "Teleport to Origin", function()
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.CFrame = CFrame.new(0, 10, 0)
            notify("info", "Teleported to origin")
        end
    end, { tooltip = "Teleport to (0, 10, 0)" })
    UI.Header(PlayerFrame, "Health")
    UI.Button(PlayerFrame, "Show Target Health", function()
        local c = getTargetChar()
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then
                notify("info", string.format("Target: %s HP / %s Max", math.floor(h.Health), math.floor(h.MaxHealth)))
                return
            end
        end
        notify("warn", "No humanoid found")
    end, { tooltip = "Show current target's health" })
end

--[[ ============================ 32. SETTINGS TAB ============================ ]]
local SettingsFrame = makeTab("Settings", "⚙️", 8)
do
    UI.Header(SettingsFrame, "Appearance")
    UI.Dropdown(SettingsFrame, "Theme", { "Dark", "Midnight Blue", "Mono", "Neon", "Ruby" }, Config.Theme, function(v)
        Config.Theme = v
        for k, val in pairs(Themes[v]) do Theme[k] = val end
        Window.BackgroundColor3 = Theme.bg
        TitleBar.BackgroundColor3 = Theme.panel
        Sidebar.BackgroundColor3 = Theme.panel
        TopBar.BackgroundColor3 = Theme.panel
        StatusBar.BackgroundColor3 = Theme.panel
        notify("info", "Theme: " .. v)
    end, { tooltip = "Change visual theme" })
    UI.Slider(SettingsFrame, "Transparency", 0, 1, Config.Transparency, function(v)
        Config.Transparency = v
        if Window then Window.BackgroundTransparency = v end
    end, { tooltip = "Window background transparency" })
    UI.Toggle(SettingsFrame, "Mute SFX", Config.MuteSFX, function(v) Config.MuteSFX = v end, { tooltip = "Toggle all UI sounds" })
    UI.Slider(SettingsFrame, "Sound Volume", 0, 1, Config.SoundVolume, function(v) Config.SoundVolume = v end, { tooltip = "UI sound volume" })
    UI.Toggle(SettingsFrame, "Compact Mode", Config.Compact, function(v) Config.Compact = v end, { tooltip = "Compact layout" })
    UI.Toggle(SettingsFrame, "Show Console", Config.ShowConsole, function(v)
        Config.ShowConsole = v
        if LogPanel then LogPanel.Visible = v end
    end, { tooltip = "Show log console panel" })
    UI.Toggle(SettingsFrame, "Show Tooltips", Config.ShowTooltips, function(v) Config.ShowTooltips = v end, { tooltip = "Toggle tooltips on hover" })
    UI.Divider(SettingsFrame)
    UI.Header(SettingsFrame, "Keybind")
    local KeybindLabel = create("TextLabel", {
        Parent = SettingsFrame,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "Toggle GUI: " .. Config.Keybind.Name .. " (click to rebind)",
        Font = Enum.Font.Code,
        TextSize = 12,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local awaitingKeybind = false
    UI.Button(SettingsFrame, "Rebind GUI Toggle", function()
        awaitingKeybind = true
        KeybindLabel.Text = "Press any key..."
    end, { tooltip = "Click then press a key to rebind" })
    _G.RuboAwaitingKeybind = function() return awaitingKeybind end
    _G.RuboSetKeybind = function(v) awaitingKeybind = v end
    _G.RuboKeybindLabel = KeybindLabel
    UI.Divider(SettingsFrame)
    UI.Header(SettingsFrame, "Window")
    UI.Button(SettingsFrame, "Reset GUI Position", function()
        Window.Position = UDim2.new(0.5, -Window.Size.X.Offset / 2, 0.5, -Window.Size.Y.Offset / 2)
        notify("info", "Position reset")
    end, { tooltip = "Recenter window on screen" })
    UI.Button(SettingsFrame, "Save Config", function()
        pcall(function()
            local data = {
                theme = Config.Theme, transp = Config.Transparency,
                mute = Config.MuteSFX, compact = Config.Compact,
                kb = Config.Keybind.Name, tab = Config.LastTab,
                maxp = Config.MaxParts, follow = Config.FollowTarget,
                vol = Config.SoundVolume,
            }
            local s = HttpService:JSONEncode(data)
            if writefile then writefile("RuboConfig.json", s) else getgenv().RuboConfig = s end
        end)
        notify("info", "Config saved")
    end, { tooltip = "Save current settings to file" })
    UI.Button(SettingsFrame, "Load Config", function()
        local ok, s = pcall(function()
            if readfile then return readfile("RuboConfig.json")
            elseif getgenv().RuboConfig then return getgenv().RuboConfig
            else return nil end
        end)
        if ok and s then
            pcall(function()
                local data = HttpService:JSONDecode(s)
                if data.theme and Themes[data.theme] then
                    Config.Theme = data.theme
                    for k, val in pairs(Themes[data.theme]) do Theme[k] = val end
                end
                if data.transp then Config.Transparency = data.transp end
                if data.mute then Config.MuteSFX = data.mute end
                if data.compact then Config.Compact = data.compact end
                if data.tab then pcall(selectTab, data.tab) end
                if data.maxp then Config.MaxParts = data.maxp end
                if data.follow then Config.FollowTarget = data.follow end
                if data.vol then Config.SoundVolume = data.vol end
            end)
            notify("info", "Config loaded")
        else
            notify("warn", "No saved config")
        end
    end, { tooltip = "Load saved settings from file" })
    UI.Button(SettingsFrame, "Reset Config", function()
        Config = {
            Theme = "Dark", Transparency = 0.05, MuteSFX = false, Compact = false,
            Keybind = Enum.KeyCode.RightShift, LastTab = "Home", MaxParts = 400,
            FollowTarget = false, ShowConsole = false, PropFilter = true,
            ShowTooltips = true, SoundVolume = 0.3, ShowFPS = true, PromoCount = 0,
            WinPos = UDim2.new(0.5, -400, 0.5, -280), WinSize = UDim2.new(0, 820, 0, 580),
        }
        notify("info", "Config reset")
    end, { tooltip = "Reset all settings to defaults" })
    UI.Divider(SettingsFrame)
    UI.Header(SettingsFrame, "Advanced")
    UI.Button(SettingsFrame, "Show Keybind Cheatsheet", function()
        RuboShowCheatsheet()
    end, { tooltip = "Show all keybinds" })
    UI.Button(SettingsFrame, "Unload Hub", function()
        if getgenv().RuboUnload then getgenv().RuboUnload() end
    end, { tooltip = "Unload hub and clean up", color = Theme.danger })
end

--[[ ============================ 33. LOG PANEL ============================ ]]
LogPanel = create("Frame", {
    Parent = Gui,
    Visible = false,
    Position = UDim2.new(0, 20, 1, -400),
    Size = UDim2.new(0, 440, 0, 300),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
    ZIndex = 80,
})
corner(LogPanel, 8)
stroke(LogPanel, Theme.border, 1)
create("TextLabel", {
    Parent = LogPanel,
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    Text = "Log Console · RUBO PRO",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Theme.accent,
})
local LogScroll = create("ScrollingFrame", {
    Parent = LogPanel,
    Position = UDim2.new(0, 6, 0, 30),
    Size = UDim2.new(1, -12, 1, -78),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
})
corner(LogScroll, 4)
stroke(LogScroll, Theme.border, 1)
LogConsole = create("TextLabel", {
    Parent = LogScroll,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = Theme.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
})
padding(LogScroll, 4, 4, 6, 6)
local CopyLogsBtn = create("TextButton", {
    Parent = LogPanel,
    Position = UDim2.new(0, 6, 1, -40),
    Size = UDim2.new(0, 100, 0, 26),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "Copy Logs",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(CopyLogsBtn, 6)
stroke(CopyLogsBtn, Theme.border, 1)
CopyLogsBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(Logger.Export()) end)
    notify("info", "Logs copied")
end)
local ClearLogsBtn = create("TextButton", {
    Parent = LogPanel,
    Position = UDim2.new(0, 112, 1, -40),
    Size = UDim2.new(0, 70, 0, 26),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Text = "Clear",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = Theme.text,
    AutoButtonColor = false,
})
corner(ClearLogsBtn, 6)
stroke(ClearLogsBtn, Theme.border, 1)
ClearLogsBtn.MouseButton1Click:Connect(function()
    Logger.Clear()
    notify("info", "Logs cleared")
end)

--[[ ============================ 34. COMMAND PALETTE ============================ ]]
local CommandPalette, CommandSearch, CommandList
CommandPalette = create("Frame", {
    Parent = Gui,
    Visible = false,
    Position = UDim2.new(0.5, -220, 0.2, 0),
    Size = UDim2.new(0, 440, 0, 380),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
    ZIndex = 90,
})
corner(CommandPalette, 10)
stroke(CommandPalette, Theme.accent, 1)
CommandSearch = create("TextBox", {
    Parent = CommandPalette,
    Position = UDim2.new(0, 8, 0, 8),
    Size = UDim2.new(1, -16, 0, 32),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    PlaceholderText = "Type a command... (Esc to close)",
    Font = Enum.Font.Code,
    TextSize = 13,
    TextColor3 = Theme.text,
    ClearTextOnFocus = false,
})
corner(CommandSearch, 6)
stroke(CommandSearch, Theme.border, 1)
CommandList = create("ScrollingFrame", {
    Parent = CommandPalette,
    Position = UDim2.new(0, 8, 0, 48),
    Size = UDim2.new(1, -16, 1, -56),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
})
corner(CommandList, 6)
stroke(CommandList, Theme.border, 1)
padding(CommandList, 4, 4, 4, 4)
listLayout(CommandList, 3)
local function refreshCommands(filter)
    for _, c in ipairs(CommandList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    filter = (filter or ""):lower()
    local shown = 0
    for _, item in ipairs(CommandRegistry) do
        if filter == "" or item.name:lower():find(filter, 1, true) then
            local b = create("TextButton", {
                Parent = CommandList,
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Theme.panel2,
                BorderSizePixel = 0,
                Text = "  " .. item.name,
                Font = Enum.Font.Code,
                TextSize = 12,
                TextColor3 = Theme.text,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
            })
            corner(b, 4)
            b.MouseButton1Click:Connect(function()
                safeCall(item.fn)
                CommandPalette.Visible = false
            end)
            shown += 1
            if shown >= 30 then break end
        end
    end
    if shown == 0 then
        create("TextLabel", {
            Parent = CommandList,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = "  No commands found",
            Font = Enum.Font.Code,
            TextSize = 12,
            TextColor3 = Theme.subtext,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
    end
end
local function toggleCommandPalette()
    CommandPalette.Visible = not CommandPalette.Visible
    if CommandPalette.Visible then
        CommandSearch.Text = ""
        refreshCommands("")
        CommandSearch:CaptureFocus()
    end
end
CommandSearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshCommands(CommandSearch.Text)
end)

--[[ ============================ 35. CHEATSHEET ============================ ]]
function RuboShowCheatsheet()
    local sheet = create("Frame", {
        Parent = Gui,
        Position = UDim2.new(0.5, -200, 0.5, -140),
        Size = UDim2.new(0, 400, 0, 280),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        ZIndex = 100,
    })
    corner(sheet, 10)
    stroke(sheet, Theme.accent, 1)
    create("TextLabel", {
        Parent = sheet,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "Keybind Cheatsheet · RUBO PRO",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.accent,
    })
    create("TextLabel", {
        Parent = sheet,
        Position = UDim2.new(0, 12, 0, 40),
        Size = UDim2.new(1, -24, 1, -50),
        BackgroundTransparency = 1,
        Text = [[RightShift — Toggle GUI
Ctrl+K — Command Palette
Ctrl+Z — Undo
Ctrl+Y — Redo
Esc — Close palette

Click title bar — Drag window
Bottom-right corner — Resize window
Minimize button — Collapse to floating icon
Close button — Unload hub

Mobile:
Long-press Rubo logo — Command Palette
Tap floating icon — Reopen window
Touch-drag title bar — Move window]],
        Font = Enum.Font.Code,
        TextSize = 12,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    local closeBtn = create("TextButton", {
        Parent = sheet,
        Position = UDim2.new(1, -34, 0, 6),
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundColor3 = Theme.danger,
        BorderSizePixel = 0,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        AutoButtonColor = false,
    })
    corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function() sheet:Destroy() end)
end

--[[ ============================ 36. KEYBOARD INPUT ============================ ]]
bind(UserInputService.InputBegan, function(input, gp)
    if gp then return end
    if _G.RuboAwaitingKeybind and _G.RuboAwaitingKeybind() then
        Config.Keybind = input.KeyCode
        if _G.RuboKeybindLabel then _G.RuboKeybindLabel.Text = "Toggle GUI: " .. input.KeyCode.Name end
        _G.RuboSetKeybind(false)
        return
    end
    if input.KeyCode == Config.Keybind then
        Window.Visible = not Window.Visible
        if isMobile then FloatingIcon.Visible = not Window.Visible end
    end
    if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleCommandPalette()
    end
    if input.KeyCode == Enum.KeyCode.Z and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then doUndo() end
    if input.KeyCode == Enum.KeyCode.Y and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then doRedo() end
    if input.KeyCode == Enum.KeyCode.Escape then
        if CommandPalette and CommandPalette.Visible then CommandPalette.Visible = false end
    end
end)

--[[ ============================ 37. WINDOW DRAG / RESIZE ============================ ]]
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = Window.Position
    end
end)
bind(UserInputService.InputChanged, function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
bind(UserInputService.InputEnded, function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            Config.WinPos = Window.Position
        end
        dragging = false
    end
end)
local ResizeHandle = create("TextButton", {
    Parent = Window,
    Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.new(0, 18, 0, 18),
    BackgroundColor3 = Theme.border,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
})
corner(ResizeHandle, 4)
local resizing = false
local resizeStart, resizeStartSize
ResizeHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = i.Position
        resizeStartSize = Window.Size
    end
end)
bind(UserInputService.InputChanged, function(i)
    if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - resizeStart
        Window.Size = UDim2.new(
            0, clamp(resizeStartSize.X.Offset + d.X, 400, 1000),
            0, clamp(resizeStartSize.Y.Offset + d.Y, 320, 750)
        )
    end
end)
bind(UserInputService.InputEnded, function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if resizing then
            Config.WinSize = Window.Size
        end
        resizing = false
    end
end)

-- Title buttons
MinBtn.MouseButton1Click:Connect(function()
    Window.Visible = false
    if isMobile then FloatingIcon.Visible = true end
    playSFX(SOUNDS.CLICK)
end)
local maximized = false
local preMaxSize, preMaxPos
MaxBtn.MouseButton1Click:Connect(function()
    maximized = not maximized
    if maximized then
        preMaxSize = Window.Size
        preMaxPos = Window.Position
        Window.Size = UDim2.new(1, -40, 1, -40)
        Window.Position = UDim2.new(0, 20, 0, 20)
    else
        Window.Size = preMaxSize
        Window.Position = preMaxPos
    end
    playSFX(SOUNDS.CLICK)
end)
CloseBtn.MouseButton1Click:Connect(function()
    playSFX(SOUNDS.CLICK)
    if getgenv().RuboUnload then getgenv().RuboUnload() end
end)

-- Floating icon drag
local iconDragging = false
local iconStart, iconStartPos
FloatingIcon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconStart = i.Position
        iconStartPos = FloatingIcon.Position
    end
end)
bind(UserInputService.InputChanged, function(i)
    if iconDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - iconStart
        local vp = Camera.ViewportSize
        FloatingIcon.Position = UDim2.new(
            0, clamp(iconStartPos.X.Offset + d.X, 0, vp.X - 56),
            0, clamp(iconStartPos.Y.Offset + d.Y, 0, vp.Y - 56)
        )
    end
end)
bind(UserInputService.InputEnded, function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        iconDragging = false
    end
end)
FloatingIcon.MouseButton1Click:Connect(function()
    Window.Visible = true
    FloatingIcon.Visible = false
    playSFX(SOUNDS.CLICK)
end)

--[[ ============================ 38. RESPONSIVE LAYOUT ============================ ]]
local function reflow()
    local vp = Camera.ViewportSize
    local w = clamp(vp.X * 0.75, 400, 900)
    local h = clamp(vp.Y * 0.75, 320, 620)
    if not maximized then
        Window.Size = UDim2.new(0, w, 0, h)
    end
    if isMobile then
        Sidebar.Size = UDim2.new(0, 120, 1, -114)
        ContentArea.Position = UDim2.new(0, 120, 0, 78)
        ContentArea.Size = UDim2.new(1, -120, 1, -114)
    end
end
reflow()
bind(Camera:GetPropertyChangedSignal("ViewportSize"), function() reflow() end)
bind(UserInputService:GetPropertyChangedSignal("TouchEnabled"), function() reflow() end)

--[[ ============================ 39. SEARCH FILTER ============================ ]]
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = SearchBox.Text:lower()
    for _, t in ipairs(Tabs) do
        local matches = t.Name:lower():find(filter, 1, true) ~= nil
        if filter == "" then
            t.Button.Visible = true
        else
            t.Button.Visible = matches
        end
    end
end)

--[[ ============================ 40. COMMAND REGISTRY ============================ ]]
CommandRegistry.Register("Toggle GUI", "UI", function()
    Window.Visible = not Window.Visible
end)
CommandRegistry.Register("Open Command Palette", "UI", function()
    toggleCommandPalette()
end)
CommandRegistry.Register("Show Cheatsheet", "UI", function()
    RuboShowCheatsheet()
end)
CommandRegistry.Register("Start Orbit", "Orbit", function()
    if _G.RuboStartOrbit then _G.RuboStartOrbit() end
end)
CommandRegistry.Register("Stop Orbit", "Orbit", function()
    if _G.RuboStopOrbit then _G.RuboStopOrbit() end
end)
CommandRegistry.Register("Build Figure", "Figure", function()
    if _G.RuboBuildFigure then _G.RuboBuildFigure() end
end)
CommandRegistry.Register("Clear Figure", "Figure", function()
    if _G.RuboClearFigure then _G.RuboClearFigure() end
end)
CommandRegistry.Register("Build Structure", "Structure", function()
    if _G.RuboBuildStructure then _G.RuboBuildStructure() end
end)
CommandRegistry.Register("Clear Structure", "Structure", function()
    if _G.RuboClearStructure then _G.RuboClearStructure() end
end)
CommandRegistry.Register("Delete All Spawned", "Props", function()
    local removed = PartTracker.Clear("prop")
    notify("info", "Deleted " .. #removed .. " props")
end)
CommandRegistry.Register("Release All Props", "Props", function()
    local n = PartTracker.ReleaseAll()
    notify("info", "Released " .. n .. " props")
end)
CommandRegistry.Register("Recolor Nearby", "Recolor", function()
    local c = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    local center = getTargetPos()
    local saved = {}
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Position - center).Magnitude <= 25 then
            table.insert(saved, { p = v, c = v.Color })
            pcall(function() v.Color = c end)
        end
        if #saved >= 300 then break end
    end
    notify("info", "Recolored " .. #saved .. " parts")
    task.delay(5, function()
        for _, s in ipairs(saved) do pcall(function() s.p.Color = s.c end) end
        notify("info", "Recolor reverted")
    end)
end)
CommandRegistry.Register("Target: Next Player", "Target", function()
    local list = refreshTargetList()
    local idx = 1
    for i, p in ipairs(list) do
        if p == State.Target then idx = i; break end
    end
    idx = idx % #list + 1
    setTarget(list[idx])
end)
CommandRegistry.Register("Toggle Follow Target", "Target", function()
    State.FollowTarget = not State.FollowTarget
    FollowBtn.TextColor3 = State.FollowTarget and Theme.mint or Theme.subtext
end)
CommandRegistry.Register("Toggle Night Mode", "World", function()
    pcall(function() Lighting.ClockTime = 0 end)
end)
CommandRegistry.Register("Toggle Day Mode", "World", function()
    pcall(function() Lighting.ClockTime = 12 end)
end)
CommandRegistry.Register("Share RUBO HUB", "General", function()
    notify("info", "Tell your friends about RUBO HUB v2.0 PRO — the #1 Brookhaven toolbox!")
end)
CommandRegistry.Register("Unload Hub", "General", function()
    if getgenv().RuboUnload then getgenv().RuboUnload() end
end)

--[[ ============================ 41. CONFIG AUTO-SAVE ============================ ]]
local SaveDebounce = 0
local function scheduleSave() SaveDebounce = tick() + 2 end
task.spawn(function()
    while Gui and Gui.Parent do
        task.wait(0.5)
        if SaveDebounce > 0 and tick() > SaveDebounce then
            SaveDebounce = 0
            pcall(function()
                local data = {
                    theme = Config.Theme, transp = Config.Transparency,
                    mute = Config.MuteSFX, compact = Config.Compact,
                    kb = Config.Keybind.Name, tab = Config.LastTab,
                    maxp = Config.MaxParts, follow = Config.FollowTarget,
                    vol = Config.SoundVolume,
                }
                local s = HttpService:JSONEncode(data)
                if writefile then writefile("RuboConfig.json", s) else getgenv().RuboConfig = s end
            end)
        end
    end
end)

-- Load existing config
pcall(function()
    local s = nil
    if readfile then s = readfile("RuboConfig.json")
    elseif getgenv().RuboConfig then s = getgenv().RuboConfig end
    if s then
        local data = HttpService:JSONDecode(s)
        if data.theme and Themes[data.theme] then
            Config.Theme = data.theme
            for k, v in pairs(Themes[data.theme]) do Theme[k] = v end
        end
        if data.transp then Config.Transparency = data.transp end
        if data.mute then Config.MuteSFX = data.mute end
        if data.tab then Config.LastTab = data.tab end
        if data.maxp then Config.MaxParts = data.maxp end
        if data.vol then Config.SoundVolume = data.vol end
    end
end)

--[[ ============================ 42. UNDO/REDO BUTTONS ============================ ]]
UndoBtn.MouseButton1Click:Connect(function() doUndo() end)
RedoBtn.MouseButton1Click:Connect(function() doRedo() end)

--[[ ============================ 43. PROMO ============================ ]]
task.spawn(function()
    while Gui and Gui.Parent do
        task.wait(300)
        Config.PromoCount += 1
        notify("info", "★ Enjoying RUBO HUB v2.0 PRO? Share it with friends! ★")
    end
end)
task.delay(2, function()
    notify("info", "★ Welcome to RUBO HUB v2.0 PRO — Powered by RUBO ★", 5)
end)

--[[ ============================ 44. BOOT ============================ ]]
if isMobile then FloatingIcon.Visible = false end
selectTab(Config.LastTab or "Home")
addAction("Hub loaded")
notify("info", "RUBO HUB v2.0 PRO ready · ★ Welcome ★")
scheduleSave()
State.Initialized = true
Logger.Add("info", "RUBO HUB v2.0 PRO initialized successfully")
print("[Rubo Hub] Initialized — ready for use ★ RUBO ★")

--[[ ============================ 45. UNLOAD ============================ ]]
getgenv().RuboUnload = function()
    if State.Unloaded then return end
    State.Unloaded = true
    local mins = math.floor((tick() - Session.Start) / 60)
    notify("info", string.format("★ Session Summary: %d parts · %d actions · %d undos · %d redos · %d min ★",
        Session.Parts, Session.Actions, Session.Undos, Session.Redos, mins))
    task.wait(1)
    PartTracker.Clear(nil)
    if RuntimeOrbit.Folder then pcall(function() RuntimeOrbit.Folder:Destroy() end) end
    if RuntimeFigure.Instance then pcall(function() RuntimeFigure.Instance:Destroy() end) end
    if StructFolder then pcall(function() StructFolder:Destroy() end) end
    clearHighlight()
    for _, c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(Connections)
    if Gui then pcall(function() Gui:Destroy() end) end
    getgenv().RuboUnload = nil
    print("[Rubo Hub] Unloaded — thanks for using RUBO HUB PRO!")
end

--[[ ============================ END ============================ ]]