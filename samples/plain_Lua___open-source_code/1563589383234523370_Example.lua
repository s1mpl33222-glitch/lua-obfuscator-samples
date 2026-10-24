--[[
    OasisUI showcase: a mock script hub plus every element with every option.

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mold53/OasisUI/main/examples/Example.lua"))()

    All features are dummies. Nothing touches the game; callbacks only write to the event log on the Overview tab.
]]

local SOURCE = "https://raw.githubusercontent.com/Mold53/OasisUI/main/dist/OasisUI.lua"
local OasisUI = getgenv().OasisUI_Dev or loadstring(game:HttpGet(SOURCE))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local Window = OasisUI:CreateWindow({
    Title = "OasisUI",
    Subtitle = "Showcase · v" .. OasisUI.Version,
    Icon = "sparkles",
    Folder = "OasisUI-Showcase",
    Tags = { "v" .. OasisUI.Version },
    Theme = "Sapphire",
    ToggleKey = Enum.KeyCode.RightShift,
    CloseAction = "Confirm",
    User = { Subtitle = "Showcase user" },
})

-- every callback reports to the event log on the Overview tab
local log
local function format(value)
    if typeof(value) == "Color3" then return "#" .. value:ToHex():upper() end
    if type(value) == "table" then return "{ " .. table.concat(value, ", ") .. " }" end
    if type(value) == "boolean" then return value and "on" or "off" end
    return tostring(value)
end
local function event(name, ...)
    if not log then return end
    local parts = {}
    for index = 1, select("#", ...) do table.insert(parts, format((select(index, ...)))) end
    log:Add(string.format('<font color="#8C96B4">%s</font>  %s', name, table.concat(parts, ", ")))
end
local function report(name)
    return function(...) event(name, ...) end
end
local function notify(title, content, kind)
    OasisUI:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = 4 })
end
local function playerNames()
    local names = {}
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then table.insert(names, player.Name) end
    end
    if #names == 0 then names = { "Nobody else here" } end
    return names
end

-- ── Overview ────────────────────────────────────────────────────────────────
local Overview = Window:Tab({ Title = "Overview", Icon = "house" })
local live = {}
do
    local welcome = Overview:Section({ Title = "Welcome", Icon = "sparkles", Side = "Left" })
    welcome:Paragraph({
        Title = "OasisUI " .. OasisUI.Version,
        Content = "A mock script hub. The <b>Hub</b> tabs look like a real script, the <b>Elements</b> tabs show "
            .. "every element with all of its options. Nothing here changes the game.",
        Icon = "info",
    })
    welcome:Paragraph({
        Title = "Things to try",
        Content = "• Click a module header to switch it on, its settings fold out.\n"
            .. "• Click the key pill or middle-click a header to bind a key; right-click the pill for Hold.\n"
            .. "• Right-click a header for the module menu.\n"
            .. "• Drag a card by its grip to rearrange it, also between the columns.\n"
            .. "• Star a module to pin it to Favorites.\n"
            .. "• Ctrl+F searches every tab.\n"
            .. "• Settings (bottom left): theme editor, configs, keybind list, watermark.",
    })
    log = welcome:Log({ Title = "Event log", Height = 150, MaxLines = 100, Timestamps = true })
    welcome:Button({ Title = "Clear log", Icon = "trash-2", Style = "Ghost", Callback = function() log:Clear() end })

    local stats = Overview:Section({ Title = "Live", Icon = "activity", Side = "Right" })
    live.Fps = stats:Label({ Text = "Frame rate", Value = "—" })
    live.Ping = stats:Label({ Text = "Ping", Value = "—" })
    live.Memory = stats:Label({ Text = "Memory", Value = "—" })
    live.Session = stats:Label({ Text = "Session", Value = "0s" })
    live.Load = stats:ProgressBar({ Title = "Frame budget", Value = 0, Suffix = "%" })

    local quick = Overview:Section({ Title = "Quick actions", Icon = "zap", Side = "Right" })
    quick:Dropdown({
        Title = "Theme preset",
        Values = OasisUI.Theme.Presets.Order,
        Default = OasisUI.Theme.Palette,
        Callback = function(name)
            OasisUI:SetTheme(name)
            event("Theme", name)
        end,
        Action = { Icon = "shuffle", Tooltip = "Random preset", Callback = function()
            local order = OasisUI.Theme.Presets.Order
            OasisUI:SetTheme(order[math.random(#order)])
        end },
    })
    quick:Buttons({
        { Title = "Random accent", Icon = "palette", Callback = function()
            local color = Color3.fromHSV(math.random(), 0.65, 1)
            OasisUI:SetAccent(color)
            event("Accent", color)
        end },
        { Title = "Settings", Icon = "settings", Callback = function() Window:SelectTab(Window.SettingsTab) end },
    })
    quick:Input({ Title = "Watermark text", Placeholder = "Shown after the title", Callback = function(text)
        Window:SetWatermark(text)
        event("Watermark", text)
    end })
    quick:Code({
        Title = "Load this showcase",
        Code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Mold53/OasisUI/main/examples/Example.lua"))()',
    })
end

-- ── Hub ─────────────────────────────────────────────────────────────────────
Window:TabSection("Hub")

local Combat = Window:Tab({ Title = "Combat", Icon = "crosshair" })
do
    local aim = Combat:SubTab({ Title = "Aimbot", Icon = "target" })
    local aimbot = aim:Module({
        Title = "Aimbot",
        Description = "Locks onto the closest target while you hold the key.",
        Flag = "Aimbot",
        Keybind = { Key = "MouseButton2", Mode = "Hold" },
        Side = "Left",
        Callback = report("Aimbot"),
    })
    aimbot:Segmented({ Title = "Method", Values = { "Camera", "Mouse" }, Flag = "AimMethod", Callback = report("Aim method") })
    aimbot:Dropdown({
        Title = "Target part",
        Values = {
            { Title = "Head", Description = "Highest damage", Icon = "crosshair" },
            { Title = "Torso", Description = "Easiest to hit", Icon = "shield" },
            { Title = "Closest part", Description = "Whatever is nearest to the crosshair", Icon = "target" },
            { Title = "Random", Description = "A new part every lock", Icon = "sparkles" },
        },
        Flag = "AimPart",
        Callback = report("Target part"),
    })
    aimbot:Slider({ Title = "FOV", Min = 10, Max = 500, Default = 120, Suffix = " px", Flag = "AimFov", Callback = report("FOV") })
    aimbot:Slider({ Title = "Smoothness", Min = 0, Max = 1, Step = 0.01, Default = 0.25, Flag = "AimSmooth", Callback = report("Smoothness") })
    aimbot:Range({ Title = "Distance", Min = 0, Max = 2000, Default = { 0, 800 }, Suffix = " st", Flag = "AimDistance", Callback = report("Distance") })
    local checks = aimbot:Group({ Title = "Checks", Icon = "shield-check" })
    checks:Checkbox({ Title = "Team check", Default = true, Flag = "AimTeam", Callback = report("Team check") })
    checks:Checkbox({ Title = "Wall check", Default = true, Flag = "AimWall", Callback = report("Wall check") })
    checks:Checkbox({ Title = "Alive only", Default = true, Flag = "AimAlive", Callback = report("Alive only") })
    checks:Checkbox({ Title = "Ignore friends", Flag = "AimFriends", Callback = report("Ignore friends") })
    local prediction = aimbot:Toggle({ Title = "Prediction", Flag = "AimPrediction", Callback = report("Prediction") })
    aimbot:Slider({ Title = "Prediction strength", Min = 0, Max = 2, Step = 0.05, Default = 1, Flag = "AimPredictionStrength", Callback = report("Prediction strength") })
        :DependsOn(prediction, nil, "Hide")

    local silent = aim:Module({
        Title = "Silent aim",
        Description = "Redirects shots without moving the camera.",
        Risky = true,
        Flag = "SilentAim",
        Side = "Right",
        Callback = report("Silent aim"),
    })
    silent:Slider({ Title = "Hit chance", Min = 0, Max = 100, Default = 85, Suffix = "%", Buttons = true, Flag = "SilentChance", Callback = report("Hit chance") })
    silent:Dropdown({ Title = "Hit part", Values = { "Head", "Torso", "Random" }, Flag = "SilentPart", Callback = report("Hit part") })
    silent:Toggle({ Title = "Highlight target", Default = true, Flag = "SilentHighlight", Callback = report("Highlight target") })

    local trigger = aim:Module({ Title = "Triggerbot", Description = "Fires when the crosshair is on a target.", Flag = "Triggerbot", Side = "Right", Callback = report("Triggerbot") })
    trigger:Range({ Title = "Delay", Min = 0, Max = 500, Default = { 30, 90 }, Suffix = " ms", ShowRange = true, Flag = "TriggerDelay", Callback = report("Trigger delay") })
    trigger:Toggle({ Title = "Only while aiming", Flag = "TriggerAiming", Callback = report("Only while aiming") })

    local priority = aim:Section({ Title = "Targeting", Icon = "list-filter", Side = "Left" })
    priority:Dropdown({ Title = "Priority", Values = { "Closest to crosshair", "Closest distance", "Lowest health", "Highest threat" }, Flag = "AimPriority", Callback = report("Priority") })
    priority:Dropdown({ Title = "Ignore", Multi = true, Values = { "Friends", "Teammates", "Whitelisted", "Invisible" }, Default = { "Friends" }, Flag = "AimIgnore", Callback = report("Ignore") })

    local fov = Combat:SubTab({ Title = "FOV circle", Icon = "circle" })
    local circle = fov:Module({ Title = "FOV circle", Description = "Draws the aimbot field of view.", Default = true, Flag = "FovCircle", Side = "Left", Callback = report("FOV circle") })
    circle:ColorPicker({ Title = "Colour", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.3, Flag = "FovColor", Callback = report("FOV colour") })
    circle:Slider({ Title = "Thickness", Min = 1, Max = 6, Default = 1, Suffix = " px", Flag = "FovThickness", Callback = report("FOV thickness") })
    circle:Slider({ Title = "Sides", Min = 3, Max = 64, Default = 48, Flag = "FovSides", Callback = report("FOV sides") })
    circle:Toggle({ Title = "Filled", Flag = "FovFilled", Callback = report("FOV filled") })
    circle:Toggle({ Title = "Follow the mouse", Default = true, Flag = "FovFollow", Callback = report("FOV follow") })
    fov:Section({ Title = "About", Icon = "info", Side = "Right" }):Paragraph({ Content = "Sub-tabs keep big categories tidy. Each sub-tab has its own layout, favorites and search entries." })

    local hitbox = Combat:SubTab({ Title = "Hitbox", Icon = "box" })
    local expander = hitbox:Module({ Title = "Hitbox expander", Description = "Makes hitboxes bigger.", Risky = true, Flag = "Hitbox", Side = "Left", Callback = report("Hitbox expander") })
    expander:Slider({ Title = "Size", Min = 1, Max = 25, Step = 0.5, Default = 6, Suffix = " st", Flag = "HitboxSize", Callback = report("Hitbox size") })
    expander:Dropdown({ Title = "Part", Values = { "Head", "HumanoidRootPart", "Torso" }, Default = "HumanoidRootPart", Flag = "HitboxPart", Callback = report("Hitbox part") })
    expander:ColorPicker({ Title = "Colour", Default = Color3.fromRGB(255, 80, 80), Transparency = 0.6, Flag = "HitboxColor", Callback = report("Hitbox colour") })
end

local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })
do
    local espTab = Visuals:SubTab({ Title = "ESP", Icon = "scan" })
    local esp = espTab:Module({ Title = "ESP", Description = "Boxes, names and health above players.", Default = true, Flag = "Esp", Keybind = { Key = Enum.KeyCode.V }, Side = "Left", Callback = report("ESP") })
    local boxes = esp:Group({ Title = "Boxes", Icon = "square", Opened = true })
    boxes:Toggle({ Title = "Boxes", Default = true, Flag = "EspBoxes", Callback = report("Boxes") })
    boxes:Segmented({ Title = "Style", Values = { "2D", "Corners", "3D" }, Default = "Corners", Flag = "EspBoxStyle", Callback = report("Box style") })
    boxes:ColorPicker({ Title = "Colour", Default = Color3.fromRGB(78, 132, 255), Flag = "EspBoxColor", Callback = report("Box colour") })
    local text = esp:Group({ Title = "Text", Icon = "type" })
    text:Checkbox({ Title = "Names", Default = true, Flag = "EspNames", Callback = report("Names") })
    text:Checkbox({ Title = "Distance", Default = true, Flag = "EspDistance", Callback = report("Distance") })
    text:Checkbox({ Title = "Health", Flag = "EspHealthText", Callback = report("Health text") })
    text:Checkbox({ Title = "Tool", Flag = "EspTool", Callback = report("Tool") })
    esp:Toggle({ Title = "Health bar", Default = true, Flag = "EspHealthBar", Callback = report("Health bar") })
    local tracers = esp:Toggle({ Title = "Tracers", Flag = "EspTracers", Callback = report("Tracers") })
    esp:Dropdown({ Title = "Tracer origin", Values = { "Bottom", "Center", "Mouse" }, Flag = "EspTracerOrigin", Callback = report("Tracer origin") })
        :DependsOn(tracers)
    esp:Slider({ Title = "Max distance", Min = 50, Max = 5000, Step = 50, Default = 1500, Suffix = " st", Flag = "EspDistanceMax", Callback = report("Max distance") })
    esp:Toggle({ Title = "Team colours", Flag = "EspTeamColors", Callback = report("Team colours") })

    local chams = espTab:Module({ Title = "Chams", Description = "Highlights players through walls.", Flag = "Chams", Side = "Right", Callback = report("Chams") })
    chams:ColorPicker({ Title = "Fill", Default = Color3.fromRGB(146, 112, 255), Transparency = 0.5, Flag = "ChamsFill", Callback = report("Chams fill") })
    chams:ColorPicker({ Title = "Outline", Default = Color3.fromRGB(255, 255, 255), Flag = "ChamsOutline", Callback = report("Chams outline") })
    chams:Toggle({ Title = "Visible only", Flag = "ChamsVisible", Callback = report("Chams visible only") })

    local world = Visuals:SubTab({ Title = "World", Icon = "globe" })
    world:Module({ Title = "Fullbright", Description = "Removes darkness.", Flag = "Fullbright", Side = "Left", Callback = report("Fullbright") })
    world:Module({ Title = "No fog", Flag = "NoFog", Side = "Left", Callback = report("No fog") })
    local clock = world:Module({ Title = "Time changer", Description = "Sets the local time of day.", Flag = "TimeChanger", Side = "Right", Callback = report("Time changer") })
    clock:Slider({
        Title = "Time",
        Min = 0, Max = 24, Step = 0.25, Default = 14,
        Format = function(hours) return string.format("%02d:%02d", math.floor(hours) % 24, math.floor((hours % 1) * 60 + 0.5)) end,
        Icons = { From = "moon", To = "sun" },
        Flag = "TimeOfDay",
        Callback = report("Time"),
    })
    local ambience = world:Section({ Title = "Ambience", Icon = "sun", Side = "Right" })
    ambience:ColorPicker({ Title = "Ambient", Default = Color3.fromRGB(140, 140, 160), Flag = "Ambient", Callback = report("Ambient") })
    ambience:Slider({ Title = "Brightness", Min = 0, Max = 5, Step = 0.25, Default = 2, Icons = { From = "sun-dim", To = "sun" }, Flag = "Brightness", Callback = report("Brightness") })

    local crosshair = Visuals:SubTab({ Title = "Crosshair", Icon = "plus" })
    local custom = crosshair:Module({ Title = "Custom crosshair", Flag = "Crosshair", Side = "Left", Callback = report("Crosshair") })
    custom:Slider({ Title = "Size", Min = 2, Max = 40, Default = 10, Suffix = " px", Flag = "CrosshairSize", Callback = report("Crosshair size") })
    custom:Slider({ Title = "Gap", Min = 0, Max = 20, Default = 4, Suffix = " px", Flag = "CrosshairGap", Callback = report("Crosshair gap") })
    custom:Slider({ Title = "Thickness", Min = 1, Max = 6, Default = 2, Suffix = " px", Flag = "CrosshairThickness", Callback = report("Crosshair thickness") })
    custom:ColorPicker({ Title = "Colour", Default = Color3.fromRGB(80, 255, 140), Flag = "CrosshairColor", Callback = report("Crosshair colour") })
    custom:Toggle({ Title = "Centre dot", Flag = "CrosshairDot", Callback = report("Centre dot") })
    local spin = custom:Toggle({ Title = "Spin", Flag = "CrosshairSpin", Callback = report("Spin") })
    custom:Slider({ Title = "Spin speed", Min = 10, Max = 720, Step = 10, Default = 180, Suffix = "°/s", Flag = "CrosshairSpinSpeed", Callback = report("Spin speed") })
        :DependsOn(spin, nil, "Hide")
end

local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
do
    local walk = PlayerTab:Module({ Title = "Walk speed", Flag = "WalkSpeed", Side = "Left", Callback = report("Walk speed") })
    walk:Slider({ Title = "Speed", Min = 16, Max = 200, Default = 32, Buttons = true, Flag = "WalkSpeedValue", Callback = report("Speed") })
    local jump = PlayerTab:Module({ Title = "Jump power", Flag = "JumpPower", Side = "Left", Callback = report("Jump power") })
    jump:Slider({ Title = "Power", Min = 50, Max = 300, Default = 80, Flag = "JumpPowerValue", Callback = report("Power") })
    local fly = PlayerTab:Module({ Title = "Fly", Description = "WASD to move, space and shift for height.", Flag = "Fly", Keybind = { Key = Enum.KeyCode.F }, Notify = true, Side = "Right", Callback = report("Fly") })
    fly:Slider({ Title = "Speed", Min = 10, Max = 300, Default = 60, Flag = "FlySpeed", Callback = report("Fly speed") })
    fly:Segmented({ Title = "Mode", Values = { "Velocity", "CFrame" }, Flag = "FlyMode", Callback = report("Fly mode") })
    PlayerTab:Module({ Title = "Noclip", Flag = "Noclip", Keybind = { Key = Enum.KeyCode.N }, Side = "Right", Callback = report("Noclip") })
    PlayerTab:Module({ Title = "Infinite jump", Flag = "InfiniteJump", Side = "Right", Callback = report("Infinite jump") })

    local utility = PlayerTab:Section({ Title = "Utilities", Icon = "wrench", Side = "Left" })
    utility:Toggle({ Title = "Anti AFK", Default = true, Flag = "AntiAfk", Callback = report("Anti AFK") })
    utility:Toggle({ Title = "Auto rejoin on kick", Flag = "AutoRejoin", Callback = report("Auto rejoin") })
    local target = utility:Dropdown({ Title = "Player", Values = playerNames(), Search = true, Flag = "TargetPlayer", Callback = report("Player") })
    utility:Buttons({
        { Title = "Refresh", Icon = "refresh-cw", Callback = function() target:Refresh(playerNames()) end },
        { Title = "Spectate", Icon = "eye", Callback = function() event("Spectate", target:Get()) end },
        { Title = "Teleport", Icon = "navigation", Callback = function() event("Teleport", target:Get()) end },
    })
end

local Misc = Window:Tab({ Title = "Misc", Icon = "package" })
do
    local server = Misc:Section({ Title = "Server", Icon = "server", Side = "Left" })
    server:Label({ Text = "Players", Value = #Players:GetPlayers() .. " / " .. Players.MaxPlayers })
    server:Label({ Text = "Job id", Value = (game.JobId ~= "" and game.JobId:sub(1, 8) or "studio") .. "…" })
    server:Buttons({
        { Title = "Rejoin", Icon = "refresh-cw", Callback = function() event("Rejoin", "requested") end },
        { Title = "Server hop", Icon = "shuffle", Confirm = "Sure?", Callback = function() event("Server hop", "requested") end },
    })
    server:Button({ Title = "Copy job id", Icon = "copy", Style = "Ghost", Callback = function()
        if setclipboard then setclipboard(game.JobId) end
        notify("Copied", "The job id is on your clipboard.", "Success")
    end })

    local spam = Misc:Module({ Title = "Chat spam", Description = "Repeats a message.", Risky = true, Flag = "ChatSpam", Side = "Right", Callback = report("Chat spam") })
    spam:Input({ Title = "Message", Placeholder = "gg", Default = "gg", MaxLength = 120, Flag = "ChatSpamMessage", Callback = report("Message") })
    spam:Slider({ Title = "Interval", Min = 1, Max = 30, Default = 5, Suffix = " s", Flag = "ChatSpamInterval", Callback = report("Interval") })

    local farm = Misc:Module({ Title = "Auto farm", Description = "Collects drops in the chosen area.", Flag = "AutoFarm", Side = "Right", Callback = report("Auto farm") })
    farm:Dropdown({ Title = "Area", Values = { "Spawn", "Forest", "Desert", "Volcano" }, Flag = "FarmArea", Callback = report("Area") })
    farm:Dropdown({ Title = "Collect", Multi = true, Values = { "Coins", "Gems", "Chests", "Eggs" }, Default = { "Coins", "Gems" }, Flag = "FarmCollect", Callback = report("Collect") })
end

-- ── Elements ────────────────────────────────────────────────────────────────
Window:TabSection("Elements")

local Controls = Window:Tab({ Title = "Controls", Icon = "toggle-right" })
do
    local toggles = Controls:Section({ Title = "Toggle", Icon = "toggle-right", Side = "Left" })
    toggles:Toggle({ Title = "Switch", Callback = report("Switch") })
    toggles:Toggle({ Title = "On by default", Description = "Default = true", Default = true, Callback = report("On by default") })
    toggles:Checkbox({ Title = "Checkbox", Callback = report("Checkbox") })
    toggles:Toggle({ Title = "With a key", Description = "Keybind = true, Toggle or Hold", Keybind = true, Callback = report("With a key") })
    toggles:Toggle({ Title = "Risky", Description = "Risky = true marks dangerous options", Risky = true, Callback = report("Risky") })
    toggles:Toggle({ Title = "With a tooltip", Tooltip = "Hover the i for help text.", Callback = report("With a tooltip") })
    toggles:Toggle({
        Title = "With a value",
        Description = "Field = { … }: set it before switching on",
        Field = { Default = 250, Numeric = true, Min = 0, Max = 1e6, Width = 80, Tooltip = "1.5k and 2m work.", Callback = report("Value") },
        Callback = report("With a value"),
    })
    toggles:Toggle({
        Title = "With a colour",
        Description = "Color = { … }: a swatch in the row",
        Color = { Default = Color3.fromRGB(120, 220, 140), Callback = report("Row colour") },
        Callback = report("With a colour"),
    })

    local buttons = Controls:Section({ Title = "Button", Icon = "mouse-pointer-click", Side = "Right" })
    buttons:Button({ Title = "Default", Icon = "rocket", Callback = function() event("Button", "Default") end })
    buttons:Button({ Title = "Primary", Icon = "check", Style = "Primary", Callback = function() event("Button", "Primary") end })
    buttons:Button({ Title = "Ghost", Icon = "layers", Style = "Ghost", Callback = function() event("Button", "Ghost") end })
    buttons:Button({ Title = "Danger with confirm", Icon = "trash-2", Style = "Danger", Confirm = true, Callback = function() event("Button", "Danger confirmed") end })
    buttons:Button({ Title = "Bound to a key", Icon = "keyboard", Keybind = true, Tooltip = "Click the pill to bind; the key presses the button.", Callback = function() event("Button", "Key press") end })
    buttons:Divider("Rows")
    buttons:Buttons({
        { Title = "One", Icon = "hash", Callback = function() event("Row", "One") end },
        { Title = "Two", Style = "Primary", Callback = function() event("Row", "Two") end },
        { Title = "Three", Style = "Danger", Confirm = "Sure?", Callback = function() event("Row", "Three") end },
    })

    local card = Controls:Module({
        Title = "Module card",
        Description = "A module: switch, key pill, star and grip. Its settings fold out below.",
        Icon = "layers",
        Keybind = { Key = Enum.KeyCode.G },
        Side = "Left",
        Callback = report("Module card"),
    })
    card:Label({ Text = "Settings live here. Turn \"Expand modules when enabled\" off in Settings to open them with the chevron instead." })
    card:Toggle({ Title = "Nested option", Callback = report("Nested option") })
    Controls:Module({ Title = "No key pill", Description = "Keybind = false", Keybind = false, Side = "Right", Callback = report("No key pill") })
    Controls:Section({ Title = "Section", Description = "Toggle = false: a card without a switch, open by default.", Side = "Right" })
        :Label({ Text = "Sections hold elements like modules do." })
end

local Sliders = Window:Tab({ Title = "Sliders", Icon = "sliders-horizontal" })
do
    local single = Sliders:Section({ Title = "Slider", Icon = "sliders-horizontal", Side = "Left" })
    single:Slider({ Title = "Basic", Min = 0, Max = 100, Default = 40, Callback = report("Basic") })
    single:Slider({ Title = "Decimals", Description = "Step = 0.05", Min = 0, Max = 1, Step = 0.05, Default = 0.35, Callback = report("Decimals") })
    single:Slider({ Title = "Prefix and suffix", Min = 0, Max = 500, Default = 120, Prefix = "~", Suffix = " studs", Callback = report("Prefix and suffix") })
    single:Slider({ Title = "Steppers", Description = "Buttons = true", Min = 0, Max = 20, Default = 10, Buttons = true, Callback = report("Steppers") })
    single:Slider({ Title = "End icons", Min = 0, Max = 100, Default = 70, Icons = { From = "volume-2", To = "music" }, Callback = report("End icons") })
    single:Slider({ Title = "Range labels", Min = -50, Max = 50, Default = 0, ShowRange = true, Callback = report("Range labels") })
    single:Slider({ Title = "Custom format", Min = 1, Max = 4, Step = 0.25, Default = 1, Format = function(value) return value .. "×" end, Callback = report("Custom format") })
    single:Slider({ Title = "Read-only value", Description = "Input = false", Min = 0, Max = 100, Default = 25, Input = false, Callback = report("Read-only value") })
    single:Slider({ Title = "On release", Description = "Live = false: callback after you let go", Min = 0, Max = 100, Default = 50, Live = false, Callback = report("On release") })

    local range = Sliders:Section({ Title = "Range slider", Icon = "arrow-up-down", Side = "Right" })
    range:Range({ Title = "Basic", Min = 0, Max = 100, Default = { 20, 80 }, Callback = report("Range basic") })
    range:Range({ Title = "Minimum gap", Description = "MinGap = 20", Min = 0, Max = 100, Default = { 30, 60 }, MinGap = 20, Callback = report("Minimum gap") })
    range:Range({ Title = "Milliseconds", Min = 0, Max = 500, Default = { 40, 120 }, Suffix = " ms", ShowRange = true, Callback = report("Milliseconds") })
    range:Range({ Title = "Shift both", Description = "Buttons move the whole range", Min = 0, Max = 10, Step = 0.5, Default = { 2, 5 }, Buttons = true, Callback = report("Shift both") })
end

local Selection = Window:Tab({ Title = "Selection", Icon = "list" })
do
    local single = Selection:Section({ Title = "Dropdown", Icon = "list", Side = "Left" })
    single:Dropdown({ Title = "Single", Values = { "Low", "Medium", "High" }, Default = "Medium", Callback = report("Single") })
    single:Dropdown({
        Title = "Icons and descriptions",
        Values = {
            { Title = "Sword", Description = "Close range", Icon = "sword" },
            { Title = "Shield", Description = "Blocks a hit", Icon = "shield" },
            { Title = "Crown", Description = "Rare", Icon = "crown" },
            { Title = "Gem", Description = "Very rare", Icon = "gem" },
        },
        Callback = report("Icons and descriptions"),
    })
    single:Dropdown({ Title = "Allow none", Description = "Click the selected entry to clear it", Values = { "Red", "Green", "Blue" }, AllowNone = true, Placeholder = "No colour", Callback = report("Allow none") })

    local many = {}
    for index = 1, 60 do table.insert(many, string.format("Item %02d", index)) end
    local multi = Selection:Section({ Title = "Multi select", Icon = "check-check", Side = "Right" })
    multi:Dropdown({ Title = "Multi", Multi = true, Values = { "Apples", "Pears", "Plums", "Cherries" }, Default = { "Pears" }, Callback = report("Multi") })
    multi:Dropdown({ Title = "Search", Description = "Search turns on by itself above 8 entries", Multi = true, Values = many, Callback = report("Search") })

    local dynamic = Selection:Section({ Title = "Dynamic values", Icon = "refresh-cw", Side = "Left" })
    local list = dynamic:Dropdown({ Title = "Entries", Multi = true, Values = {}, Placeholder = "Add some", Callback = report("Entries") })
    local count = 0
    dynamic:Buttons({
        { Title = "Add", Icon = "plus", Callback = function()
            count += 1
            list:Add("Entry " .. count)
        end },
        { Title = "Players", Icon = "users", Callback = function() list:Refresh(playerNames()) end },
        { Title = "Clear", Icon = "x", Callback = function() list:Refresh({}) end },
    })

    local segments = Selection:Section({ Title = "Segmented", Icon = "columns-2", Side = "Right" })
    segments:Segmented({ Title = "Two", Values = { "On", "Off" }, Callback = report("Two") })
    segments:Segmented({ Title = "Four", Values = { "Low", "Medium", "High", "Ultra" }, Default = "High", Callback = report("Four") })
end

local Inputs = Window:Tab({ Title = "Input", Icon = "type" })
do
    local text = Inputs:Section({ Title = "Text", Icon = "type", Side = "Left" })
    text:Input({ Title = "Basic", Placeholder = "Type and press Enter", Callback = report("Basic input") })
    text:Input({ Title = "Icon and limit", Placeholder = "Max 12 characters", Icon = "user", MaxLength = 12, Callback = report("Icon and limit") })
    text:Input({
        Title = "Validated",
        Description = "Letters only",
        Placeholder = "abc",
        Validate = function(value)
            if value:match("^%a*$") then return true end
            return false, "Only letters are allowed."
        end,
        Callback = report("Validated"),
    })
    local mirror = text:Label({ Text = "Typed", Value = "" })
    text:Input({ Title = "Live", Description = "Finished = false: fires on every keystroke", Finished = false, Callback = function(value) mirror:SetValue(value) end })
    text:Input({ Title = "Multiline", Multiline = true, Height = 64, Placeholder = "Notes…", Callback = report("Multiline") })

    local numbers = Inputs:Section({ Title = "Numbers", Icon = "hash", Side = "Left" })
    numbers:Input({ Title = "Range 0 to 100", Numeric = true, Min = 0, Max = 100, Default = 50, Callback = report("Range 0 to 100") })
    numbers:Input({ Title = "Shorthand", Description = "1.5k, 2m and 3b work", Numeric = true, Default = 1500, Callback = report("Shorthand") })

    local keys = Inputs:Section({ Title = "Keybind", Icon = "keyboard", Side = "Right" })
    keys:Keybind({ Title = "Toggle", Default = Enum.KeyCode.T, Mode = "Toggle", Callback = report("Toggle key") })
    keys:Keybind({ Title = "Hold", Default = Enum.KeyCode.H, Mode = "Hold", Callback = report("Hold key") })
    keys:Keybind({ Title = "Always", Description = "Fires on every press", Default = Enum.KeyCode.J, Mode = "Always", Callback = function() event("Always key", "pressed") end })
    keys:Keybind({ Title = "Hold only", Description = "Modes = { \"Hold\" }", Mode = "Hold", Modes = { "Hold" }, Callback = report("Hold only") })
    keys:Keybind({ Title = "No mouse, no WASD", Description = "AllowMouse = false, Blacklist = { W, A, S, D }", AllowMouse = false, Blacklist = { "W", "A", "S", "D" }, Callback = report("Restricted key") })
    keys:Keybind({ Title = "Clears on click outside", Description = "ClickOutside = \"Clear\"", ClickOutside = "Clear", Default = Enum.KeyCode.K, Callback = report("Clearable key") })
    keys:Keybind({ Title = "Always bound", Description = "CanUnbind = false", CanUnbind = false, Default = Enum.KeyCode.L, Callback = report("Always bound") })
    keys:Keybind({ Title = "Unbound", ChangedCallback = function(key) notify("Key changed", "Unbound → " .. tostring(key)) end })
    keys:Keybind({ Title = "Combo", Description = "Hold LCtrl, then a key", ComboKeys = 3, Default = "LeftControl+K", Callback = report("Combo key") })

    local colors = Inputs:Section({ Title = "Colour picker", Icon = "palette", Side = "Right" })
    colors:ColorPicker({ Title = "Colour", Default = Color3.fromRGB(78, 132, 255), Callback = report("Colour") })
    colors:ColorPicker({ Title = "With transparency", Default = Color3.fromRGB(240, 110, 170), Transparency = 0.3, Callback = report("With transparency") })
    colors:ColorPicker({ Title = "Rainbow", Default = Color3.fromRGB(255, 0, 0), Rainbow = true, Tooltip = "The sparkle button in the picker toggles rainbow." })
end

local Display = Window:Tab({ Title = "Display", Icon = "layout-dashboard" })
do
    local text = Display:Section({ Title = "Text", Icon = "type", Side = "Left" })
    text:Label({ Text = "A plain label wraps when the text gets longer than the card is wide." })
    text:Label({ Text = "Label with a value", Value = "42" })
    text:Label({ Text = 'Rich text: <b>bold</b>, <i>italic</i>, <font color="#4E84FF">coloured</font>' })
    text:Paragraph({ Title = "Paragraph", Content = "A title and a body on a soft background.", Icon = "info" })
    text:Paragraph({ Content = "A paragraph without a title." })

    local layout = Display:Section({ Title = "Layout", Icon = "layers", Side = "Left" })
    layout:Label({ Text = "Above a divider" })
    layout:Divider()
    layout:Label({ Text = "Between dividers" })
    layout:Divider("Caption")
    layout:Spacer({ Height = 12 })
    local group = layout:Group({ Title = "Group", Icon = "folder-open", Opened = true })
    group:Toggle({ Title = "Inside a group", Callback = report("Inside a group") })
    group:Group({ Title = "Nested group" }):Slider({ Title = "Deep slider", Min = 0, Max = 10, Default = 3, Callback = report("Deep slider") })

    local media = Display:Section({ Title = "Media", Icon = "image", Side = "Right" })
    media:Image({ Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420", Height = 140, ScaleType = Enum.ScaleType.Fit })
    media:Image({ Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=512&h=512", AspectRatio = "16:9" })
    media:Code({ Title = "Code", Code = 'local Tab = Window:Tab({ Title = "Combat", Icon = "swords" })\nlocal Module = Tab:Module({ Title = "Aimbot", Flag = "Aimbot" })\nModule:Slider({ Title = "FOV", Min = 10, Max = 500 })' })
    local notes = { "-- Editable = true: a click opens an editor", "local settings = {" }
    for index = 1, 12 do table.insert(notes, string.format("    option%02d = %s,", index, tostring(index % 2 == 0))) end
    table.insert(notes, "}")
    media:Code({
        Title = "Editable",
        Code = table.concat(notes, "\n"),
        Lines = 4,
        Editable = true,
        OnSave = function(text)
            if not text:find("settings") then return false, "Keep the settings table." end
            event("Code saved", #text .. " characters")
            return true
        end,
    })

    local progress = Display:Section({ Title = "Progress and logs", Icon = "gauge", Side = "Right" })
    live.Download = progress:ProgressBar({ Title = "Percent", Value = 0 })
    progress:ProgressBar({ Title = "Custom colour and suffix", Value = 70, Max = 100, Suffix = " hp", Color = "Success" })
    live.Steps = progress:ProgressBar({ Title = "Custom format", Value = 3, Max = 8, Format = function(value, max) return string.format("%d of %d", value, max) end })
    live.Console = progress:Log({ Title = "Console", Height = 90, Monospace = true, MaxLines = 40 })
end

local Feedback = Window:Tab({ Title = "Feedback", Icon = "bell" })
do
    local toasts = Feedback:Section({ Title = "Notifications", Icon = "bell", Side = "Left" })
    toasts:Buttons({
        { Title = "Info", Callback = function() notify("Info", "Something happened.") end },
        { Title = "Success", Callback = function() notify("Saved", "Everything went fine.", "Success") end },
    })
    toasts:Buttons({
        { Title = "Warning", Callback = function() notify("Careful", "Something looks off.", "Warning") end },
        { Title = "Error", Callback = function() notify("Failed", "Something went wrong.", "Error") end },
    })
    toasts:Button({ Title = "With buttons", Icon = "message-square", Callback = function()
        OasisUI:Notify({
            Title = "Update available",
            Content = "Hover a notification to pause its timer.",
            Duration = 10,
            Buttons = {
                { Title = "Install", Callback = function() event("Notification", "Install") end },
                { Title = "Later", Callback = function() event("Notification", "Later") end },
                { Title = "Never", Style = "Danger", Callback = function() event("Notification", "Never") end },
            },
        })
    end })
    local count = 0
    toasts:Button({ Title = "Same Id", Icon = "refresh-cw", Callback = function()
        count += 1
        -- a toast with this Id still on screen is updated and its timer starts over
        OasisUI:Notify({ Id = "counter", Title = "Counter", Content = "Pressed " .. count .. " times.", Type = count % 2 == 0 and "Success" or "Info", Duration = 3 })
    end })
    toasts:Label({ Text = "Position, duration and the bell's on / off messages: Settings → Menu → Notifications." })

    local dialogs = Feedback:Section({ Title = "Dialogs", Icon = "message-square", Side = "Left" })
    dialogs:Button({ Title = "Confirm", Callback = function()
        Window:Dialog({
            Title = "Reset everything?",
            Icon = "triangle-alert",
            Content = "Dialogs block the menu until you choose.",
            Buttons = {
                { Title = "Cancel", Style = "Secondary" },
                { Title = "Reset", Style = "Danger", Callback = function() event("Dialog", "Reset") end },
            },
        })
    end })
    dialogs:Button({ Title = "Text prompt", Callback = function()
        Window:Dialog({
            Title = "Rename",
            Icon = "pencil",
            Content = "Enter submits. Returning false from the callback keeps the dialog open.",
            Input = { Default = LocalPlayer.DisplayName, Placeholder = "Name" },
            Buttons = {
                { Title = "Cancel", Style = "Secondary" },
                { Title = "Apply", Style = "Primary", Callback = function(value, dialog)
                    if #value < 3 then
                        dialog:SetError("Use at least 3 characters.")
                        return false
                    end
                    event("Dialog", value)
                    return true
                end },
            },
        })
    end })

    local states = Feedback:Section({ Title = "States", Icon = "lock", Side = "Right" })
    states:Toggle({ Title = "Locked", Locked = true, LockedReason = "Locked elements explain why on hover." })
    local master = states:Toggle({ Title = "Enable advanced", Description = "Unlocks the slider below", Callback = report("Enable advanced") })
    states:Slider({ Title = "Advanced value", Min = 0, Max = 100, Default = 50, Callback = report("Advanced value") }):DependsOn(master)
    local reveal = states:Toggle({ Title = "Show hidden option", Callback = report("Show hidden option") })
    states:Input({ Title = "Hidden until enabled", Placeholder = "Hello" }):DependsOn(reveal, nil, "Hide")
    local renamed = 0
    local rename
    rename = states:Button({ Title = "Rename me", Icon = "pencil", Callback = function()
        renamed += 1
        rename:SetTitle("Renamed " .. renamed .. "×")
    end })

    Feedback:Module({ Title = "Locked module", Description = "Right-click the header and choose Unlock.", Locked = true, Side = "Right" })
        :Toggle({ Title = "Option behind the lock" })
end

local Layouts = Window:Tab({ Title = "Layouts", Icon = "columns-2", Columns = 1 })
do
    local about = Layouts:Section({ Title = "One column", Icon = "layout-list" })
    about:Paragraph({ Content = "This tab uses Columns = 1: a single scrolling column. Combat and Visuals use sub-tabs; every other tab uses two columns." })

    local windows = Layouts:Section({ Title = "Panels and menus", Icon = "layers" })
    local panel
    windows:Button({ Title = "Open a floating panel", Icon = "layers", Style = "Primary", Callback = function()
        if panel then
            panel:ToggleVisible()
            return
        end
        panel = Window:Panel({ Title = "Quick panel", Icon = "zap", Id = "showcase-panel", Size = Vector2.new(250, 260), Resizable = true })
        panel:Label({ Text = "Panels hold any element, can be dragged, collapsed, resized and closed. Hud = true keeps one visible while the menu is hidden." })
        panel:Toggle({ Title = "Panel toggle", Callback = report("Panel toggle") })
        panel:Slider({ Title = "Panel slider", Min = 0, Max = 10, Default = 5, Callback = report("Panel slider") })
        panel:Button({ Title = "Close", Style = "Ghost", Callback = function() panel:Hide() end })
    end })
    local hud
    windows:Button({ Title = "Open a HUD panel", Icon = "activity", Callback = function()
        if hud then
            hud:ToggleVisible()
            return
        end
        -- Hud panels stay while the menu is hidden and size themselves to their rows
        hud = Window:Panel({ Title = "Live HUD", Icon = "activity", Id = "showcase-hud", Size = Vector2.new(200, 100), Hud = true, Collapsible = false,
            OnClose = function() event("HUD", "closed") end })
        live.HudFps = hud:Label({ Text = "Frame rate", Value = "—", ValueColor = "Success" })
        live.HudPing = hud:Label({ Text = "Ping", Value = "—" })
    end })
    windows:Slider({ Title = "HUD scale", Min = 50, Max = 200, Step = 5, Default = 100, Suffix = "%", Callback = function(value)
        if hud then hud:SetScale(value / 100) end
    end })
    windows:Button({ Title = "Open a context menu", Icon = "ellipsis", Callback = function()
        Window:Menu({
            { Title = "Copy", Icon = "copy", Hint = "Ctrl C", Callback = function() event("Menu", "Copy") end },
            { Title = "Pin", Icon = "pin", Checked = true, Callback = function() event("Menu", "Pin") end },
            "-",
            { Title = "Delete", Icon = "trash-2", Danger = true, Callback = function() event("Menu", "Delete") end },
        }, { Title = "Actions" })
    end })
    windows:Buttons({
        { Title = "Center window", Icon = "move", Callback = function() Window:Center() end },
        { Title = "Minimize", Icon = "minus", Callback = function() Window:SetMinimized(true) end },
    })
end

-- ── live values ─────────────────────────────────────────────────────────────
local started = os.clock()
local frames, elapsed, download, ticks = 0, 0, 0, 0
local connection = RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed < 0.5 then return end
    live.Fps:SetValue(math.floor(frames / elapsed + 0.5) .. " fps")
    if live.HudFps then
        live.HudFps:SetValue(math.floor(frames / elapsed + 0.5) .. " fps")
        live.HudPing:SetValue(math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) .. " ms")
    end
    live.Ping:SetValue(math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) .. " ms")
    live.Memory:SetValue(math.floor(Stats:GetTotalMemoryUsageMb()) .. " MB")
    live.Session:SetValue(math.floor(os.clock() - started) .. "s")
    live.Load:Set(math.clamp(math.floor((elapsed / frames) / (1 / 60) * 100), 0, 100))
    download = (download + 7) % 107
    live.Download:Set(math.min(download, 100))
    live.Steps:Set((live.Steps:Get() % 8) + 1)
    ticks += 1
    if ticks % 4 == 0 then live.Console:Add(string.format("[%05.1f] heartbeat ok", os.clock() - started)) end
    frames, elapsed = 0, 0
end)
OasisUI:OnUnload(function() connection:Disconnect() end)

event("Showcase", "loaded")
task.delay(1, function()
    notify("OasisUI " .. OasisUI.Version, "RightShift hides the menu. Settings are at the bottom left.", "Success")
end)
