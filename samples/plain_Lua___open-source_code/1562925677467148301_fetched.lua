local CONFIG = {
    Repository = "TheRealAvrwm/Zephyr-V2",
    Branch = "main",
    Logo = "rbxthumb://type=Asset&id=131963275392887&w=420&h=420",
    Mark = "rbxthumb://type=Asset&id=89616857457936&w=420&h=420",
    StoreURL = "https://www.roblox.com/communities/32971205/Zephyr-MVSD#!/store",
    DiscordURL = "https://discord.gg/zephyrmvsd",
    IntroDuration = 1.25,
    SkipLoader = { [4348829796] = true },
}
local scriptInfo = {
    [4348829796] = "Games/mvsd.lua",
    [7344582593] = "Games/mvsd.lua",
    [7709344486] = "Games/StealABrainrot",
    [5995470825] = "Games/hypershot.lua",
    [6035872082] = "Games/Rivals.lua",
    [9251333102] = "Games/Invade%20the%20World",
    [1176784616] = "Games/TDSLoadup.lua",
    [9822980692] = "Games/zombieisland.lua",
}

local Services = {}
for _, name in ipairs({
    "Players",
    "UserInputService",
    "TweenService",
    "RunService",
    "CoreGui",
    "HttpService",
    "Lighting",
}) do
    Services[name] = game:GetService(name)
end
local Players, UIS = Services.Players, Services.UserInputService
local Lighting, HttpService = Services.Lighting, Services.HttpService
local TweenService, CoreGui = Services.TweenService, Services.CoreGui
local function getSharedEnv()
    if type(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" then
            return env
        end
    end
    return _G
end
local sharedEnv = getSharedEnv()
if type(sharedEnv.__ZEPHYR_LOADER_CLEANUP) == "function" then
    pcall(sharedEnv.__ZEPHYR_LOADER_CLEANUP)
end
local App = {
    alive = true,
    connections = {},
    tweens = {},
    tweenTargets = {},
    refreshers = {},
    dirtyPrefs = {},
    pendingGuis = {},
    settingsOpen = false,
    page = "Startup",
    launched = false,
    launching = false,
    launchError = false,
    saveRevision = 0,
    status = "Preparing Zephyr",
    progress = 0,
    saveStatus = "Settings save automatically",
    detail = "Free keyless release.",
}
local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(App.connections, connection)
    return connection
end
local function new(class, props)
    local instance = Instance.new(class)
    if instance:IsA("GuiObject") then
        instance.BorderSizePixel = 0
    end
    for key, value in pairs(props or {}) do
        if key ~= "Parent" then
            instance[key] = value
        end
    end
    if props and props.Parent then
        instance.Parent = props.Parent
    end
    return instance
end
local function corner(parent, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end
local function stroke(parent, color, transparency)
    return new("UIStroke", { Color = color, Thickness = 1, Transparency = transparency or 0, Parent = parent })
end
local Colors = {
    base = Color3.fromRGB(18, 20, 23),
    panel = Color3.fromRGB(24, 27, 31),
    raised = Color3.fromRGB(33, 37, 42),
    border = Color3.fromRGB(54, 59, 65),
    text = Color3.fromRGB(242, 244, 247),
    muted = Color3.fromRGB(158, 166, 176),
    faint = Color3.fromRGB(115, 125, 138),
    success = Color3.fromRGB(119, 224, 176),
    error = Color3.fromRGB(255, 135, 145),
    logo = Color3.fromRGB(228, 234, 235),
}
local Accents = {
    Mint = Color3.fromRGB(119, 224, 176),
    Ice = Color3.fromRGB(104, 202, 242),
    Rose = Color3.fromRGB(245, 155, 177),
}
local defaults = {
    SkipIntro = false,
    ReducedMotion = false,
    BackgroundBlur = true,
    Scale = "Default",
    Accent = "Mint",
    Environment = "Game",
    ClearFog = false,
    DisableShadows = false,
    ButtonSide = "Right",
    HideSettingsButton = false,
    CustomCursor = true,
    Emblem3D = true,
    StreamerMode = false,
    LoaderEffects = "Auto",
}
local options = {
    Scale = { Default = true, Compact = true, Large = true },
    Accent = { Mint = true, Ice = true, Rose = true },
    Environment = { Game = true, Purple = true, Galaxy = true, Day = true, Night = true },
    ButtonSide = { Left = true, Right = true },
    LoaderEffects = { Auto = true, Full = true, Lite = true },
}
App.prefs = table.clone(defaults)
local function accent()
    return Accents[App.prefs.Accent] or Accents.Mint
end
local function liteEffects()
    if App.prefs.LoaderEffects ~= "Auto" then
        return App.prefs.LoaderEffects == "Lite"
    end
    return App.autoLite == true
end
local function instantEffects()
    return App.prefs.ReducedMotion or liteEffects()
end
local function setProperties(instance, props)
    for key, value in pairs(props) do
        if instance[key] ~= value then
            instance[key] = value
        end
    end
end
local function animate(instance, props, duration, instant)
    local snap = instant or instantEffects()
    local old = App.tweens[instance]
    local target = App.tweenTargets[instance]
    if old and target and not snap then
        local same = true
        for key, value in pairs(props) do
            if target[key] ~= value then
                same = false
                break
            end
        end
        for key in pairs(target) do
            if props[key] == nil then
                same = false
                break
            end
        end
        if same then
            return
        end
    end
    if old then
        App.tweens[instance], App.tweenTargets[instance] = nil, nil
        old:Cancel()
    end
    local changed = false
    for key, value in pairs(props) do
        if instance[key] ~= value then
            changed = true
            break
        end
    end
    if not changed then
        return
    end
    if snap then
        setProperties(instance, props)
        return
    end
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    )
    App.tweens[instance] = tween
    App.tweenTargets[instance] = props
    tween.Completed:Once(function()
        if App.tweens[instance] == tween then
            App.tweens[instance], App.tweenTargets[instance] = nil, nil
        end
    end)
    tween:Play()
end
local function getExecutorName()
    local ok, result = pcall(function()
        if type(identifyexecutor) == "function" then
            return identifyexecutor()
        end
        if type(getexecutorname) == "function" then
            return getexecutorname()
        end
    end)
    return ok and type(result) == "string" and result or "Unknown"
end
local function detectMobile()
    -- Small windows and touch-enabled laptops are still desktops.
    return UIS.TouchEnabled and not UIS.KeyboardEnabled
end
local function getScriptURL()
    local scriptPath = scriptInfo[game.GameId] or "Games/Universal.lua"
    return "https://raw.githubusercontent.com/"
        .. CONFIG.Repository
        .. "/refs/heads/"
        .. CONFIG.Branch
        .. "/"
        .. scriptPath
end
local function bounded(callback, seconds)
    local done, result = false, nil
    local thread = task.spawn(function()
        result = table.pack(pcall(callback))
        done = true
    end)
    local deadline = os.clock() + (seconds or 12)
    while App.alive and not done and os.clock() < deadline do
        task.wait(0.05)
    end
    if not done then
        pcall(task.cancel, thread)
        return false, App.alive and "Request timed out" or "Cancelled"
    end
    return table.unpack(result, 1, result.n)
end

local function refresh()
    if not App.alive or App.refreshPending then
        return
    end
    App.refreshPending = true
    task.defer(function()
        App.refreshPending = false
        if not App.alive then
            return
        end
        for _, callback in ipairs(App.refreshers) do
            callback()
        end
    end)
end
local function readPreferences()
    if type(readfile) ~= "function" then
        App.saveStatus = "Session only: file saving unavailable"
        return
    end
    local ok, raw = pcall(readfile, App.configFile)
    if not ok then
        return
    end
    local decoded, saved = pcall(HttpService.JSONDecode, HttpService, raw)
    if not decoded or type(saved) ~= "table" or saved.version ~= 1 or type(saved.settings) ~= "table" then
        App.saveStatus = "Invalid settings file; defaults restored"
        return
    end
    for key, default in pairs(defaults) do
        local value = saved.settings[key]
        if not App.dirtyPrefs[key] and type(value) == type(default) and (not options[key] or options[key][value]) then
            App.prefs[key] = value
        end
    end
end
local function writePreferences()
    if not App.configFile then
        return
    end
    if App.saveThread then
        pcall(task.cancel, App.saveThread)
        App.saveThread = nil
    end
    if type(writefile) ~= "function" then
        App.saveStatus = "Session only: file saving unavailable"
    else
        local ok = pcall(function()
            local encoded = HttpService:JSONEncode({ version = 1, settings = App.prefs })
            writefile(App.configFile, encoded)
            if type(readfile) == "function" then
                assert(readfile(App.configFile) == encoded, "Settings read-back failed")
            end
        end)
        App.saveStatus = ok and ("Saved for @" .. App.player.Name) or "Could not save settings"
    end
    refresh()
end
local function savePreferences()
    App.saveRevision += 1
    local revision = App.saveRevision
    App.saveStatus = "Saving..."
    if App.saveThread then
        pcall(task.cancel, App.saveThread)
    end
    App.saveThread = task.delay(0.3, function()
        App.saveThread = nil
        if App.alive and revision == App.saveRevision then
            writePreferences()
        end
    end)
end

-- Keep only properties, and restore them when a preset is disabled.
local Environment = { lighting = {}, objects = {}, owned = {}, applying = false, scheduled = false }
local SkyFaces = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }
local Presets = {
    Purple = {
        clock = 18,
        ambient = Color3.fromRGB(112, 84, 141),
        outdoor = Color3.fromRGB(140, 114, 168),
        faces = { 433274085, 433274194, 433274131, 433274370, 433274429, 433274285 },
    },
    Galaxy = {
        clock = 0,
        ambient = Color3.fromRGB(91, 97, 126),
        outdoor = Color3.fromRGB(105, 116, 145),
        faces = { 159454299, 159454296, 159454293, 159454286, 159454300, 159454288 },
    },
    Day = { clock = 14, ambient = Color3.fromRGB(128, 128, 128), outdoor = Color3.fromRGB(155, 155, 155) },
    Night = { clock = 0, ambient = Color3.fromRGB(80, 89, 109), outdoor = Color3.fromRGB(99, 111, 133) },
}
local function trackObject(object, properties)
    if Environment.objects[object] or Environment.owned[object] then
        return
    end
    local record = { values = {}, last = {}, connections = {} }
    Environment.objects[object] = record
    for _, property in ipairs(properties) do
        record.values[property] = object[property]
        table.insert(
            record.connections,
            object:GetPropertyChangedSignal(property):Connect(function()
                if not App.alive or Environment.applying then
                    return
                end
                if object[property] == record.last[property] then
                    return
                end
                record.values[property] = object[property]
                Environment.schedule()
            end)
        )
    end
end
local function setTracked(object, property, value)
    local record = Environment.objects[object]
    if record then
        record.last[property] = value
    end
    if object[property] ~= value then
        object[property] = value
    end
end
local function restoreObject(object, record)
    for _, connection in ipairs(record.connections) do
        connection:Disconnect()
    end
    pcall(function()
        for property, value in pairs(record.values) do
            if object[property] == record.last[property] then
                object[property] = value
            end
        end
    end)
    Environment.objects[object] = nil
end
function Environment.apply()
    if not App.alive then
        return
    end
    Environment.applying = true
    local preset = Presets[App.prefs.Environment]
    local desired = {}
    if preset then
        desired.ClockTime = preset.clock
        desired.Ambient = preset.ambient
        desired.OutdoorAmbient = preset.outdoor
        desired.Brightness = 2
    end
    if App.prefs.ClearFog then
        desired.FogStart = 100000
        desired.FogEnd = 1000000
    end
    if App.prefs.DisableShadows then
        desired.GlobalShadows = false
    end
    for property, record in pairs(Environment.lighting) do
        if desired[property] == nil then
            record.connection:Disconnect()
            if Lighting[property] == record.last then
                Lighting[property] = record.value
            end
            Environment.lighting[property] = nil
        end
    end
    for property, value in pairs(desired) do
        if not Environment.lighting[property] then
            local record = { value = Lighting[property] }
            Environment.lighting[property] = record
            record.connection = Lighting:GetPropertyChangedSignal(property):Connect(function()
                if not App.alive or Environment.applying then
                    return
                end
                if Lighting[property] == record.last then
                    return
                end
                record.value = Lighting[property]
                Environment.schedule()
            end)
        end
        Environment.lighting[property].last = value
        if Lighting[property] ~= value then
            Lighting[property] = value
        end
    end
    local useSky = preset and preset.faces ~= nil
    local hasSky = false
    for _, object in ipairs(Lighting:GetChildren()) do
        if object:IsA("Sky") and useSky then
            hasSky = true
            trackObject(object, SkyFaces)
            for index, face in ipairs(SkyFaces) do
                setTracked(object, face, "rbxassetid://" .. preset.faces[index])
            end
        elseif object:IsA("Atmosphere") and App.prefs.ClearFog then
            trackObject(object, { "Density", "Haze", "Glare" })
            for _, property in ipairs({ "Density", "Haze", "Glare" }) do
                setTracked(object, property, 0)
            end
        end
    end
    for object, record in pairs(Environment.objects) do
        if
            object.Parent ~= Lighting
            or (object:IsA("Sky") and not useSky)
            or (object:IsA("Atmosphere") and not App.prefs.ClearFog)
        then
            restoreObject(object, record)
        end
    end
    for object in pairs(Environment.owned) do
        if not useSky or object.Parent ~= Lighting then
            object:Destroy()
            Environment.owned[object] = nil
        end
    end
    if useSky and not hasSky then
        local sky = new("Sky", { Name = "ZephyrEnvironmentSky", CelestialBodiesShown = false })
        Environment.owned[sky] = true
        for index, face in ipairs(SkyFaces) do
            sky[face] = "rbxassetid://" .. preset.faces[index]
        end
        sky.Parent = Lighting
    end
    Environment.applying = false
end
function Environment.schedule()
    if Environment.scheduled or Environment.applying or not App.alive then
        return
    end
    Environment.scheduled = true
    task.delay(0.2, function()
        Environment.scheduled = false
        if App.alive then
            Environment.apply()
        end
    end)
end
local function restoreEnvironment()
    Environment.applying = true
    for property, record in pairs(Environment.lighting) do
        record.connection:Disconnect()
        if Lighting[property] == record.last then
            Lighting[property] = record.value
        end
    end
    table.clear(Environment.lighting)
    for object, record in pairs(Environment.objects) do
        restoreObject(object, record)
    end
    for object in pairs(Environment.owned) do
        object:Destroy()
    end
    table.clear(Environment.owned)
    Environment.applying = false
end

local Privacy = { connections = {}, records = {}, generation = 0 }
local function privateText(text)
    if not App.prefs.StreamerMode or not App.player or type(text) ~= "string" then
        return text
    end
    local username, displayName = App.player.Name, App.player.DisplayName
    if Privacy.username ~= username or Privacy.displayName ~= displayName then
        Privacy.username, Privacy.displayName = username, displayName
        Privacy.patterns = {}
        local names = username == displayName and { username } or { username, displayName }
        table.sort(names, function(a, b)
            return #a > #b
        end)
        for _, name in ipairs(names) do
            if name ~= "" then
                local pattern = name:gsub("[^%w]", "%%%0"):gsub("%a", function(c)
                    return "[" .. c:lower() .. c:upper() .. "]"
                end)
                table.insert(Privacy.patterns, { plain = name:lower(), pattern = pattern })
            end
        end
    end
    for _, name in ipairs(Privacy.patterns) do
        if text:lower():find(name.plain, 1, true) then
            text = text:gsub(name.pattern, "Streamer")
        end
    end
    return text
end
function Privacy.stop()
    Privacy.generation += 1
    for _, connection in ipairs(Privacy.connections) do
        connection:Disconnect()
    end
    table.clear(Privacy.connections)
    for object, record in pairs(Privacy.records) do
        record.connection:Disconnect()
        record.destroying:Disconnect()
        pcall(function()
            if record.last ~= nil and object[record.property] == record.last then
                object[record.property] = record.original
            end
        end)
    end
    table.clear(Privacy.records)
end
function Privacy.apply()
    Privacy.stop()
    if not App.prefs.StreamerMode or not App.player then
        return
    end
    local generation = Privacy.generation
    local function watch(object)
        if Privacy.records[object] then
            return
        end
        local property, replacement
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            property = "Text"
        elseif object:IsA("Humanoid") and object.Parent == App.player.Character then
            property, replacement = "DisplayDistanceType", Enum.HumanoidDisplayDistanceType.None
        else
            return
        end
        local record = { property = property, original = object[property], writing = false }
        Privacy.records[object] = record
        local function update()
            if record.writing or not App.alive or generation ~= Privacy.generation then
                return
            end
            local current = object[property]
            if record.last ~= nil and current == record.last then
                return
            end
            record.original = current
            local masked = replacement or privateText(current)
            record.last = masked
            if current ~= masked then
                record.writing = true
                object[property] = masked
                record.writing = false
            end
        end
        record.connection = object:GetPropertyChangedSignal(property):Connect(update)
        record.destroying = object.Destroying:Connect(function()
            record.connection:Disconnect()
            record.destroying:Disconnect()
            Privacy.records[object] = nil
        end)
        update()
    end
    local roots, seen = {}, {}
    local function addRoot(root)
        if root and not seen[root] then
            seen[root] = true
            table.insert(roots, root)
        end
    end
    addRoot(CoreGui)
    addRoot(App.player:FindFirstChild("PlayerGui"))
    local function watchCharacter(character)
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            watch(humanoid)
        end
    end
    if App.player.Character then
        watchCharacter(App.player.Character)
    end
    table.insert(
        Privacy.connections,
        App.player.CharacterAdded:Connect(function(character)
            watchCharacter(character)
        end)
    )
    if type(gethui) == "function" then
        local ok, root = pcall(gethui)
        if ok and typeof(root) == "Instance" then
            addRoot(root)
        end
    end
    addRoot(workspace)
    for _, root in ipairs(roots) do
        table.insert(Privacy.connections, root.DescendantAdded:Connect(watch))
    end
    -- Walk incrementally; never allocate the entire map's descendants in one frame.
    task.spawn(function()
        local count, started = 0, os.clock()
        for _, root in ipairs(roots) do
            local stack = { { children = root:GetChildren(), index = 1 } }
            while #stack > 0 do
                if not App.alive or generation ~= Privacy.generation then
                    return
                end
                local frame = stack[#stack]
                local object = frame.children[frame.index]
                if not object then
                    table.remove(stack)
                else
                    frame.index += 1
                    if object.Parent then
                        watch(object)
                        local children = object:GetChildren()
                        if #children > 0 then
                            stack[#stack + 1] = { children = children, index = 1 }
                        end
                    end
                end
                count += 1
                if count >= 80 or os.clock() - started >= 0.002 then
                    task.wait()
                    count, started = 0, os.clock()
                end
            end
        end
    end)
end

local function changeSetting(key, value)
    if App.prefs[key] == value then
        return
    end
    App.prefs[key] = value
    App.dirtyPrefs[key] = true
    savePreferences()
    if key == "StreamerMode" then
        Privacy.apply()
    end
    if key == "Environment" or key == "ClearFog" or key == "DisableShadows" then
        Environment.apply()
    end
    if App.onPreferenceChanged then
        App.onPreferenceChanged(key, value)
    end
    refresh()
end
local function label(parent, text, size, color, props)
    local values = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = size or 13,
        TextColor3 = color or Colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = parent,
    }
    for key, value in pairs(props or {}) do
        values[key] = value
    end
    return new("TextLabel", values)
end
local buttonStyles = setmetatable({}, { __mode = "k" })
local hoverBackground = Color3.fromRGB(46, 52, 58)
local function button(parent, text, props)
    local values = {
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Colors.text,
        BackgroundColor3 = Colors.raised,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = parent,
    }
    for key, value in pairs(props or {}) do
        values[key] = value
    end
    local control = new("TextButton", values)
    corner(control, 6)
    local style = { base = values.BackgroundColor3, hovered = false }
    buttonStyles[control] = style
    connect(control.MouseEnter, function()
        if control.BackgroundTransparency == 1 or instantEffects() then
            return
        end
        style.hovered = true
        animate(control, { BackgroundColor3 = hoverBackground }, 0.12)
    end)
    connect(control.MouseLeave, function()
        if style.hovered then
            style.hovered = false
            animate(control, { BackgroundColor3 = style.base }, 0.12)
        end
    end)
    return control
end
local function buttonColor(control, color)
    local style = buttonStyles[control]
    style.base = color
    animate(
        control,
        { BackgroundColor3 = style.hovered and not instantEffects() and hoverBackground or color },
        nil,
        true
    )
end
local function imageLogo(parent, asset, size, position)
    local holder = new("Frame", {
        Size = UDim2.fromOffset(size, size),
        Position = position or UDim2.new(),
        BackgroundColor3 = Colors.logo,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(holder, 8)
    new("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.fromOffset(3, 3),
        BackgroundTransparency = 1,
        Image = asset,
        ScaleType = Enum.ScaleType.Fit,
        Parent = holder,
    })
    return holder
end
local function makeGui(name, order)
    local gui = new("ScreenGui", {
        Name = name,
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = order,
    })
    pcall(function()
        gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
    end)
    local ok = pcall(function()
        gui.Parent = type(gethui) == "function" and gethui() or CoreGui
    end)
    if not ok or not gui.Parent then
        local player = Players.LocalPlayer
        gui.Parent = player and player:FindFirstChild("PlayerGui")
        if not gui.Parent then
            table.insert(App.pendingGuis, gui)
        end
    end
    return gui
end

local function buildShell()
    App.settingsGui = makeGui("ZephyrSettings", 2147483001)
    App.settingsGui.Enabled = false
    local root = new("Frame", {
        Name = "Root",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = App.settingsGui,
    })
    local shade = new("TextButton", {
        Name = "Dismiss",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = 1,
        Visible = false,
        Modal = false,
        Active = false,
        AutoButtonColor = false,
        Text = "",
        Parent = root,
    })
    local panel = new("Frame", {
        Name = "SettingsPanel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(760, 560),
        BackgroundColor3 = Colors.panel,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Parent = root,
    })
    corner(panel, 8)
    local panelStroke = stroke(panel, Colors.border)
    local panelScale = new("UIScale", { Scale = 1, Parent = panel })
    local flatLogo = imageLogo(panel, CONFIG.Logo, 42, UDim2.fromOffset(20, 17))
    local emblem, emblemCamera, emblemFailed
    local function ensureEmblem()
        if emblem or emblemFailed or not App.settingsOpen or not App.prefs.Emblem3D or liteEffects() then
            return
        end
        local emblemOK = pcall(function()
            emblem = new("ViewportFrame", {
                Name = "Emblem3D",
                Position = UDim2.fromOffset(8, 3),
                Size = UDim2.fromOffset(68, 68),
                BackgroundTransparency = 1,
                Ambient = Color3.fromRGB(160, 175, 187),
                LightColor = Color3.fromRGB(255, 246, 229),
                LightDirection = Vector3.new(-1, -2, -3),
                Parent = panel,
            })
            emblemCamera = new("Camera", { FieldOfView = 35, Parent = emblem })
            emblem.CurrentCamera = emblemCamera
            emblemCamera.CFrame = CFrame.lookAt(Vector3.new(0.6, 0.35, 5), Vector3.new())
            for index, size in ipairs({ Vector3.new(2.15, 2.15, 0.22), Vector3.new(1.93, 1.93, 0.27) }) do
                new("Part", {
                    Name = "BadgeLayer" .. index,
                    Size = size,
                    Anchored = true,
                    CanCollide = false,
                    Color = index == 1 and accent() or Colors.logo,
                    Material = Enum.Material.Metal,
                    CFrame = CFrame.new(0, 0, (index - 1) * 0.2),
                    Parent = emblem,
                })
            end
            local face = emblem:FindFirstChild("BadgeLayer2")
            new("Decal", { Texture = CONFIG.Mark, Face = Enum.NormalId.Back, Parent = face })
        end)
        if not emblemOK then
            if emblem then
                emblem:Destroy()
            end
            emblem, emblemCamera, emblemFailed = nil, nil, true
        end
    end
    label(panel, "ZEPHYR", 23, Colors.text, {
        Position = UDim2.fromOffset(76, 15),
        Size = UDim2.new(1, -140, 0, 28),
        Font = Enum.Font.GothamBold,
    })
    label(panel, "SETTINGS", 10, Colors.muted, {
        Position = UDim2.fromOffset(77, 44),
        Size = UDim2.fromOffset(140, 16),
    })
    local close = button(panel, "×", {
        Name = "CloseSettings",
        Position = UDim2.new(1, -58, 0, 17),
        Size = UDim2.fromOffset(40, 40),
        TextSize = 24,
    })
    new("Frame", {
        Position = UDim2.fromOffset(0, 76),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = Colors.border,
        Parent = panel,
    })
    local navigation = new("Frame", { BackgroundTransparency = 1, Parent = panel })
    local content = new("Frame", { BackgroundTransparency = 1, ClipsDescendants = true, Parent = panel })
    local footer = label(panel, App.saveStatus, 11, Colors.muted, {
        Position = UDim2.new(0, 20, 1, -33),
        Size = UDim2.new(1, -128, 0, 26),
    })
    local reset = button(panel, "Reset", {
        Name = "ResetSettings",
        Position = UDim2.new(1, -94, 1, -35),
        Size = UDim2.fromOffset(74, 28),
        BackgroundTransparency = 1,
        TextColor3 = Colors.muted,
        TextSize = 11,
    })
    local pages, nav = {}, {}
    for index, name in ipairs({ "Startup", "Environment", "Account" }) do
        local tab = button(navigation, name, { Name = name .. "Tab" })
        nav[name] = tab
        local page = new("ScrollingFrame", {
            Name = name .. "Page",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.faint,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = name == App.page,
            Parent = content,
        })
        new("UIPadding", {
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            Parent = page,
        })
        new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0), Parent = page })
        pages[name] = page
        connect(tab.Activated, function()
            App.page = name
            refresh()
        end)
    end
    local order = 0
    local function refreshPage(page, callback)
        table.insert(App.refreshers, function()
            if App.settingsOpen and page.Name == App.page .. "Page" then
                callback()
            end
        end)
    end
    local function section(page, title)
        order += 1
        local heading = label(page, title, 11, Colors.muted, {
            Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamSemibold,
            LayoutOrder = order,
        })
        return heading
    end
    local function row(page, title, detail, height)
        order += 1
        local frame = new("Frame", {
            Name = title,
            Size = UDim2.new(1, 0, 0, height or 64),
            BackgroundTransparency = 1,
            LayoutOrder = order,
            Parent = page,
        })
        label(frame, title, 13, Colors.text, {
            Position = UDim2.fromOffset(0, 10),
            Size = UDim2.new(1, -68, 0, 22),
            Font = Enum.Font.GothamMedium,
        })
        if detail then
            label(frame, detail, 11, Colors.muted, {
                Position = UDim2.fromOffset(0, 33),
                Size = UDim2.new(1, -68, 0, 22),
            })
        end
        new("Frame", {
            Position = UDim2.new(0, 0, 1, -1),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Colors.border,
            BackgroundTransparency = 0.65,
            BorderSizePixel = 0,
            Parent = frame,
        })
        return frame
    end
    local function toggle(page, title, detail, key)
        local frame = row(page, title, detail)
        local track = new("Frame", {
            Name = "Track",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -1, 0.5, 0),
            Size = UDim2.fromOffset(44, 24),
            BackgroundColor3 = Colors.raised,
            BorderSizePixel = 0,
            Parent = frame,
        })
        corner(track, 12)
        local knob = new("Frame", {
            Name = "Knob",
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.fromOffset(18, 18),
            BackgroundColor3 = Colors.text,
            BorderSizePixel = 0,
            Parent = track,
        })
        corner(knob, 9)
        local hit = button(frame, "", {
            Name = key,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
        })
        connect(hit.Activated, function()
            changeSetting(key, not App.prefs[key])
        end)
        local initialized = false
        refreshPage(page, function()
            animate(track, { BackgroundColor3 = App.prefs[key] and accent() or Colors.border }, nil, not initialized)
            animate(knob, {
                Position = UDim2.fromOffset(App.prefs[key] and 23 or 3, 3),
                BackgroundColor3 = App.prefs[key] and Colors.base or Colors.text,
            }, nil, not initialized)
            initialized = true
        end)
        return frame
    end
    local function choices(page, title, key, values, colorOptions)
        order += 1
        local frame = new("Frame", {
            Name = title,
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1,
            LayoutOrder = order,
            Parent = page,
        })
        label(frame, title, 13, Colors.text, { Size = UDim2.new(1, 0, 0, 24), Font = Enum.Font.GothamMedium })
        local controls = new("Frame", {
            Position = UDim2.fromOffset(0, 30),
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundTransparency = 1,
            Parent = frame,
        })
        for index, value in ipairs(values) do
            local control = button(controls, colorOptions and "" or value, {
                Name = key .. value,
                Position = UDim2.new((index - 1) / #values, 0, 0, 0),
                Size = UDim2.new(1 / #values, -6, 1, 0),
                TextSize = 12,
            })
            local outline = stroke(control, Colors.border)
            if colorOptions then
                local swatch = new("Frame", {
                    BackgroundColor3 = Accents[value],
                    Size = UDim2.fromOffset(20, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    BorderSizePixel = 0,
                    Parent = control,
                })
                corner(swatch, 10)
                local tooltip = label(control, value, 10, Colors.text, {
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Visible = false,
                })
                connect(control.MouseEnter, function()
                    tooltip.Visible = true
                    swatch.Visible = false
                end)
                connect(control.MouseLeave, function()
                    tooltip.Visible = false
                    swatch.Visible = true
                end)
                local check = label(control, "✓", 12, Colors.text, {
                    Position = UDim2.new(1, -22, 0, 0),
                    Size = UDim2.fromOffset(20, 38),
                    TextXAlignment = Enum.TextXAlignment.Center,
                })
                refreshPage(page, function()
                    setProperties(check, { Visible = App.prefs[key] == value })
                end)
            end
            connect(control.Activated, function()
                changeSetting(key, value)
            end)
            refreshPage(page, function()
                local selected = App.prefs[key] == value
                buttonColor(control, selected and Colors.raised or Colors.panel)
                setProperties(control, { TextColor3 = selected and Colors.text or Colors.muted })
                setProperties(outline, { Color = selected and accent() or Colors.border })
            end)
        end
    end

    section(pages.Startup, "LAUNCH")
    toggle(pages.Startup, "Skip intro", "Go straight to your script.", "SkipIntro")
    toggle(pages.Startup, "Streamer mode", nil, "StreamerMode")
    section(pages.Startup, "INTERFACE")
    choices(pages.Startup, "Loader effects", "LoaderEffects", { "Auto", "Full", "Lite" })
    toggle(pages.Startup, "Reduced motion", "Instant panel transitions.", "ReducedMotion")
    toggle(pages.Startup, "Background blur", "Blur behind the settings panel.", "BackgroundBlur")
    toggle(pages.Startup, "3D emblem", nil, "Emblem3D")
    local cursorRow = toggle(pages.Startup, "Settings cursor", nil, "CustomCursor")
    choices(pages.Startup, "Panel size", "Scale", { "Compact", "Default", "Large" })
    choices(pages.Startup, "Accent", "Accent", { "Mint", "Ice", "Rose" }, true)
    choices(pages.Startup, "Settings button", "ButtonSide", { "Left", "Right" })
    toggle(pages.Startup, "Hide Zephyr settings on startup", "Unhide with /e unhide", "HideSettingsButton")
    order += 1
    local hideSession = button(pages.Startup, "Hide settings button this session", {
        Name = "HideSettingsSession",
        Size = UDim2.new(1, 0, 0, 42),
        LayoutOrder = order,
    })
    connect(hideSession.Activated, function()
        App.sessionHideSettingsButton = true
        App.openSettings(false)
        refresh()
    end)

    section(pages.Environment, "SKY & LIGHTING")
    local skyColors = {
        Game = Color3.fromRGB(131, 151, 157),
        Purple = Color3.fromRGB(162, 108, 218),
        Galaxy = Color3.fromRGB(119, 137, 200),
        Day = Color3.fromRGB(104, 199, 232),
        Night = Color3.fromRGB(97, 111, 147),
    }
    local skyDetails = {
        Game = "Original game environment",
        Purple = "Purple sky & soft lighting",
        Galaxy = "Starfield sky",
        Day = "Clear afternoon",
        Night = "Moonlit evening",
    }
    for _, name in ipairs({ "Game", "Purple", "Galaxy", "Day", "Night" }) do
        order += 1
        local control = button(pages.Environment, "", {
            Name = "Environment" .. name,
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, 58),
            BackgroundTransparency = 1,
        })
        local swatch = new("Frame", {
            Position = UDim2.fromOffset(0, 13),
            Size = UDim2.fromOffset(32, 32),
            BackgroundColor3 = skyColors[name],
            BorderSizePixel = 0,
            Parent = control,
        })
        corner(swatch, 6)
        label(control, name, 13, Colors.text, {
            Position = UDim2.fromOffset(44, 7),
            Size = UDim2.new(1, -80, 0, 24),
            Font = Enum.Font.GothamMedium,
        })
        label(control, skyDetails[name], 11, Colors.muted, {
            Position = UDim2.fromOffset(44, 30),
            Size = UDim2.new(1, -80, 0, 19),
        })
        local mark = label(control, "✓", 17, accent(), {
            Position = UDim2.new(1, -28, 0, 0),
            Size = UDim2.fromOffset(28, 58),
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        connect(control.Activated, function()
            changeSetting("Environment", name)
        end)
        refreshPage(pages.Environment, function()
            setProperties(mark, { Visible = App.prefs.Environment == name, TextColor3 = accent() })
        end)
    end
    section(pages.Environment, "VISIBILITY")
    toggle(pages.Environment, "Clear fog", "Remove distance fog and haze.", "ClearFog")
    toggle(pages.Environment, "Disable shadows", "Lighter rendering on this device.", "DisableShadows")

    section(pages.Account, "YOUR ACCOUNT")
    local account = row(pages.Account, "Loading account...", "Waiting for your player.", 74)
    local accountTitle, accountDetail = account:FindFirstChildWhichIsA("TextLabel"), nil
    for _, child in ipairs(account:GetChildren()) do
        if child:IsA("TextLabel") and child ~= accountTitle then
            accountDetail = child
        end
    end
    section(pages.Account, "FINAL RELEASE")
    order += 1
    label(pages.Account, "Free and keyless", 20, accent(), {
        Size = UDim2.new(1, 0, 0, 38),
        LayoutOrder = order,
        Font = Enum.Font.GothamSemibold,
    })
    order += 1
    label(pages.Account, "Zephyr is discontinued. This final release is available to everyone.", 12, Colors.muted, {
        Size = UDim2.new(1, 0, 0, 56),
        LayoutOrder = order,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.None,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    order += 1
    local actions = new(
        "Frame",
        { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, LayoutOrder = order, Parent = pages.Account }
    )
    local discord = button(actions, "Discord", { Name = "DiscordLink", Size = UDim2.new(0.5, -4, 0, 38) })
    local storeButton = button(actions, "Group store", {
        Name = "GroupStore",
        Position = UDim2.new(0.5, 4, 0, 0),
        Size = UDim2.new(0.5, -4, 0, 38),
    })
    local function copyLink(control, url, title)
        local ok = type(setclipboard) == "function" and pcall(setclipboard, url)
        control.Text = ok and "Link copied" or title
        task.delay(2, function()
            if App.alive then
                control.Text = title
            end
        end)
    end
    connect(discord.Activated, function()
        copyLink(discord, CONFIG.DiscordURL, "Discord")
    end)
    connect(storeButton.Activated, function()
        copyLink(storeButton, CONFIG.StoreURL, "Group store")
    end)

    App.launcherGui = makeGui("ZephyrSettingsButton", 2147483002)
    local launcher = button(App.launcherGui, "", {
        Name = "OpenSettings",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.fromOffset(48, 48),
        BackgroundColor3 = Colors.panel,
    })
    stroke(launcher, Colors.border)
    imageLogo(launcher, CONFIG.Mark, 32, UDim2.fromOffset(8, 8))
    local tooltip = label(launcher, "Zephyr settings", 11, Colors.text, {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 0, -8),
        Size = UDim2.fromOffset(126, 28),
        BackgroundTransparency = 0,
        BackgroundColor3 = Colors.panel,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
    })
    corner(tooltip, 6)
    connect(launcher.MouseEnter, function()
        tooltip.Visible = true
    end)
    connect(launcher.MouseLeave, function()
        tooltip.Visible = false
    end)
    App.blur = new("BlurEffect", { Name = "ZephyrSettingsBlur", Size = 0, Enabled = false, Parent = Lighting })
    local cursorIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
    local touchInput = detectMobile()
    local oldMouseIcon, transition, lastEmblemUpdate = nil, 0, -math.huge
    local nativeMouse, oldCursorIcon, pointerConnection
    local function positionPointer()
        if
            emblemCamera
            and App.settingsOpen
            and App.prefs.Emblem3D
            and not instantEffects()
            and os.clock() - lastEmblemUpdate >= 1 / 15
        then
            lastEmblemUpdate = os.clock()
            local mouse = UIS:GetMouseLocation()
            local center = panel.AbsolutePosition + panel.AbsoluteSize / 2
            local x = math.clamp((mouse.X - center.X) / math.max(panel.AbsoluteSize.X, 1), -1, 1)
            local y = math.clamp((mouse.Y - center.Y) / math.max(panel.AbsoluteSize.Y, 1), -1, 1)
            -- No  cancelled camera tweens on high-pollin mice.
            setProperties(emblemCamera, { CFrame = CFrame.lookAt(Vector3.new(x * 0.6, -y * 0.4, 5), Vector3.new()) })
        end
    end
    local function updatePointer()
        local trackEmblem = App.settingsOpen and emblemCamera and App.prefs.Emblem3D and not instantEffects()
        if trackEmblem and not pointerConnection then
            pointerConnection = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    positionPointer()
                end
            end)
        elseif not trackEmblem and pointerConnection then
            pointerConnection:Disconnect()
            pointerConnection = nil
        end
        local wanted = App.settingsOpen
            and App.prefs.CustomCursor
            and not touchInput
            and UIS.MouseEnabled
            and not UIS:GetFocusedTextBox()
        if not nativeMouse and Players.LocalPlayer then
            nativeMouse = Players.LocalPlayer:GetMouse()
        end
        wanted = wanted and nativeMouse ~= nil
        if wanted then
            if oldMouseIcon == nil then
                oldMouseIcon, oldCursorIcon = UIS.MouseIconEnabled, nativeMouse.Icon
            end
            -- safe-area/UI insets
            if nativeMouse.Icon ~= cursorIcon then
                nativeMouse.Icon = cursorIcon
            end
            if not UIS.MouseIconEnabled then
                UIS.MouseIconEnabled = true
            end
        elseif oldMouseIcon ~= nil then
            if nativeMouse.Icon == cursorIcon then
                nativeMouse.Icon = oldCursorIcon
            end
            UIS.MouseIconEnabled = oldMouseIcon
            oldMouseIcon, oldCursorIcon = nil, nil
        end
    end
    App.restoreCursor = function()
        if pointerConnection then
            pointerConnection:Disconnect()
            pointerConnection = nil
        end
        if oldMouseIcon ~= nil then
            if nativeMouse.Icon == cursorIcon then
                nativeMouse.Icon = oldCursorIcon
            end
            UIS.MouseIconEnabled = oldMouseIcon
            oldMouseIcon, oldCursorIcon = nil, nil
        end
    end
    connect(UIS.LastInputTypeChanged, function(inputType)
        if inputType == Enum.UserInputType.Touch then
            touchInput = true
        elseif
            inputType == Enum.UserInputType.MouseMovement
            or inputType == Enum.UserInputType.Keyboard
            or inputType == Enum.UserInputType.MouseButton1
        then
            touchInput = false
        end
        updatePointer()
    end)
    connect(UIS.TextBoxFocused, updatePointer)
    connect(UIS.TextBoxFocusReleased, updatePointer)
    local blurTarget = 0
    local function updateBlur()
        local target = App.settingsOpen
                and App.prefs.BackgroundBlur
                and not liteEffects()
                and (detectMobile() and 20 or 28)
            or 0
        if target == blurTarget then
            return
        end
        blurTarget = target
        App.blur.Enabled = true
        animate(App.blur, { Size = target }, 0.25)
        if target == 0 then
            task.delay(instantEffects() and 0 or 0.25, function()
                if App.alive and blurTarget == 0 then
                    App.blur.Enabled = false
                end
            end)
        end
    end
    local function openSettings(value)
        if App.settingsOpen == value then
            return
        end
        transition += 1
        local revision = transition
        App.settingsOpen = value
        shade.Modal = value
        shade.Active = value
        if value then
            App.settingsGui.Enabled = true
            if not panel.Visible then
                panelScale.Scale = instantEffects() and 1 or 0.96
                panel.Position = UDim2.new(0.5, 0, 0.5, 12)
            end
            panel.Visible, shade.Visible = true, true
        end
        animate(panelScale, { Scale = value and 1 or 0.97 }, 0.22)
        animate(panel, { Position = UDim2.new(0.5, 0, 0.5, value and 0 or 10) }, 0.22)
        animate(shade, { BackgroundTransparency = value and 0.48 or 1 }, 0.22)
        if not value then
            local function finishClose()
                if App.alive and transition == revision then
                    panel.Visible, shade.Visible = false, false
                    App.settingsGui.Enabled = false
                end
            end
            if instantEffects() then
                finishClose()
            else
                task.delay(0.22, finishClose)
            end
        end
        tooltip.Visible = false
        refresh()
    end
    App.openSettings = openSettings
    connect(close.Activated, function()
        openSettings(false)
    end)
    connect(launcher.Activated, function()
        openSettings(not App.settingsOpen)
    end)
    connect(UIS.InputBegan, function(input, processed)
        if processed or UIS:GetFocusedTextBox() then
            return
        end
        if input.KeyCode == Enum.KeyCode.RightShift then
            openSettings(not App.settingsOpen)
        end
        if input.KeyCode == Enum.KeyCode.Escape and App.settingsOpen then
            openSettings(false)
        end
    end)
    local confirmReset = false
    connect(reset.Activated, function()
        if not confirmReset then
            confirmReset = true
            reset.Text = "Confirm?"
            task.delay(3, function()
                if App.alive then
                    confirmReset = false
                    reset.Text = "Reset"
                end
            end)
            return
        end
        confirmReset = false
        reset.Text = "Reset"
        for key, value in pairs(defaults) do
            changeSetting(key, value)
        end
        refresh()
    end)
    local lastViewport, lastScale, lastSide
    local function layout()
        local viewport = root.AbsoluteSize
        if viewport.X < 1 or viewport.Y < 1 then
            return
        end
        if viewport == lastViewport and lastScale == App.prefs.Scale and lastSide == App.prefs.ButtonSide then
            return
        end
        lastViewport, lastScale, lastSide = viewport, App.prefs.Scale, App.prefs.ButtonSide
        local size = App.prefs.Scale == "Compact" and Vector2.new(680, 512)
            or App.prefs.Scale == "Large" and Vector2.new(840, 620)
            or Vector2.new(760, 560)
        local width = math.min(size.X, math.max(240, viewport.X - 24))
        local height = math.min(size.Y, math.max(220, viewport.Y - 24))
        panel.Size = UDim2.fromOffset(width, height)
        local narrow = width < 580
        navigation.Position = UDim2.fromOffset(narrow and 16 or 16, narrow and 88 or 94)
        navigation.Size = narrow and UDim2.new(1, -32, 0, 40) or UDim2.fromOffset(142, height - 142)
        content.Position = UDim2.fromOffset(narrow and 16 or 182, narrow and 139 or 88)
        content.Size = UDim2.new(1, narrow and -32 or -198, 1, narrow and -183 or -132)
        for index, name in ipairs({ "Startup", "Environment", "Account" }) do
            nav[name].Position = narrow and UDim2.new((index - 1) / 3, 0, 0, 0) or UDim2.fromOffset(0, (index - 1) * 46)
            nav[name].Size = narrow and UDim2.new(1 / 3, -4, 1, 0) or UDim2.new(1, 0, 0, 40)
        end
        launcher.AnchorPoint = Vector2.new(App.prefs.ButtonSide == "Left" and 0 or 1, 1)
        launcher.Position = App.prefs.ButtonSide == "Left" and UDim2.new(0, 18, 1, -18) or UDim2.new(1, -18, 1, -18)
        tooltip.AnchorPoint = Vector2.new(App.prefs.ButtonSide == "Left" and 0 or 1, 1)
        tooltip.Position = UDim2.new(App.prefs.ButtonSide == "Left" and 0 or 1, 0, 0, -8)
    end
    connect(root:GetPropertyChangedSignal("AbsoluteSize"), layout)
    table.insert(App.refreshers, function()
        layout()
        local hidden = App.sessionHideSettingsButton
        if hidden == nil then
            hidden = App.prefs.HideSettingsButton
        end
        setProperties(launcher, { Visible = not hidden })
        ensureEmblem()
        updateBlur()
        updatePointer()
        if not App.settingsOpen then
            return
        end
        setProperties(footer, { Text = privateText(App.saveStatus) })
        for name, tab in pairs(nav) do
            local selected = App.page == name
            buttonColor(tab, selected and Colors.raised or Colors.panel)
            setProperties(tab, { TextColor3 = selected and accent() or Colors.muted })
            setProperties(pages[name], { Visible = selected })
        end
        setProperties(cursorRow, { Visible = not detectMobile() })
        local showEmblem = emblem ~= nil and App.prefs.Emblem3D and not liteEffects()
        if emblem then
            setProperties(emblem, { Visible = showEmblem })
            setProperties(emblem.BadgeLayer1, { Color = accent() })
        end
        setProperties(flatLogo, { Visible = not showEmblem })
        setProperties(panelStroke, { Color = Colors.border:Lerp(accent(), 0.22) })
    end)
    refreshPage(pages.Account, function()
        if App.player then
            setProperties(accountTitle, { Text = privateText(App.player.DisplayName) })
            setProperties(accountDetail, { Text = privateText("@" .. App.player.Name) .. "  /  Keyless" })
        end
    end)
    layout()
end

local function buildLaunchUI()
    App.launchGui = makeGui("ZephyrLauncher", 2147483000)
    local root = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = App.launchGui,
    })
    local backdrop = new("TextButton", {
        Name = "LaunchBackdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Modal = true,
        Parent = root,
    })
    local panel = new("Frame", {
        Name = "LaunchPanel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(440, 470),
        BackgroundColor3 = Colors.base,
        BorderSizePixel = 0,
        Parent = root,
    })
    corner(panel, 8)
    stroke(panel, Colors.border)
    local introScale = new("UIScale", { Scale = 1, Parent = panel })
    local wasVisible = false
    local scroller = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.fromOffset(0, 470),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.faint,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = panel,
    })
    local body = new("Frame", {
        Size = UDim2.new(1, 0, 0, 470),
        BackgroundTransparency = 1,
        Parent = scroller,
    })
    imageLogo(body, CONFIG.Logo, 56, UDim2.fromOffset(24, 24))
    label(body, "ZEPHYR", 26, Colors.text, {
        Position = UDim2.fromOffset(96, 27),
        Size = UDim2.new(1, -120, 0, 32),
        Font = Enum.Font.GothamBold,
    })
    local identity = label(body, "Your next session.", 12, Colors.muted, {
        Position = UDim2.fromOffset(97, 61),
        Size = UDim2.new(1, -120, 0, 19),
    })
    new("Frame", {
        Position = UDim2.fromOffset(24, 102),
        Size = UDim2.new(1, -48, 0, 1),
        BackgroundColor3 = Colors.border,
        BorderSizePixel = 0,
        Parent = body,
    })
    local status = label(body, "Preparing Zephyr", 17, Colors.text, {
        Position = UDim2.fromOffset(24, 122),
        Size = UDim2.new(1, -48, 0, 28),
        Font = Enum.Font.GothamSemibold,
    })
    local detail = label(body, "Preparing your script...", 12, Colors.muted, {
        Position = UDim2.fromOffset(24, 151),
        Size = UDim2.new(1, -48, 0, 34),
        TextWrapped = true,
    })
    local rail = new("Frame", {
        Position = UDim2.fromOffset(24, 199),
        Size = UDim2.new(1, -48, 0, 3),
        BackgroundColor3 = Colors.raised,
        BorderSizePixel = 0,
        Parent = body,
    })
    corner(rail, 2)
    local fill = new(
        "Frame",
        { Size = UDim2.fromScale(0.05, 1), BackgroundColor3 = accent(), BorderSizePixel = 0, Parent = rail }
    )
    corner(fill, 2)
    local skip = button(body, "Skip intro", {
        Name = "SkipIntroNow",
        Position = UDim2.fromOffset(24, 222),
        Size = UDim2.new(1, -48, 0, 38),
        Visible = false,
        BackgroundTransparency = 1,
        TextColor3 = Colors.muted,
    })
    connect(skip.Activated, function()
        changeSetting("SkipIntro", true)
    end)
    local retry = button(body, "Retry download", {
        Name = "RetryDownload",
        Position = UDim2.fromOffset(24, 222),
        Size = UDim2.new(1, -48, 0, 38),
        Visible = false,
    })
    connect(retry.Activated, function()
        if App.retryLaunch then
            App.retryLaunch()
        end
    end)
    local function update()
        local enabled = App.alive and not App.launched and (App.launchError or not App.prefs.SkipIntro)
        setProperties(App.launchGui, { Enabled = enabled })
        setProperties(backdrop, { Visible = enabled, Modal = enabled, Active = enabled })
        if not enabled then
            wasVisible = false
            return
        end
        local height = 286
        local viewport = root.AbsoluteSize
        setProperties(panel, {
            Size = UDim2.fromOffset(
                math.min(440, math.max(240, viewport.X - 24)),
                math.min(height, math.max(180, viewport.Y - 24))
            ),
        })
        setProperties(body, { Size = UDim2.new(1, 0, 0, height) })
        setProperties(scroller, { CanvasSize = UDim2.fromOffset(0, height) })
        if not wasVisible and not App.prefs.SkipIntro then
            introScale.Scale = instantEffects() and 1 or 0.96
            animate(introScale, { Scale = 1 }, 0.3)
        end
        wasVisible = true
        setProperties(skip, { Visible = not App.launchError })
        setProperties(retry, { Visible = App.launchError == true and App.retryLaunch ~= nil })
        setProperties(identity, { Text = App.player and privateText("@" .. App.player.Name) or "Your next session." })
        setProperties(status, { Text = privateText(App.status) })
        setProperties(detail, {
            Text = privateText(App.detail or "Free keyless release."),
            TextColor3 = App.launchError and Colors.error or Colors.muted,
        })
        setProperties(fill, { BackgroundColor3 = accent() })
        animate(fill, { Size = UDim2.fromScale(math.clamp(App.progress, 0.05, 1), 1) })
    end
    connect(root:GetPropertyChangedSignal("AbsoluteSize"), update)
    table.insert(App.refreshers, update)
    update()
end

local function startLaunch()
    local LP = App.player

    local function setLaunchState(status, detail, progress)
        App.status, App.detail, App.progress = status, detail, progress
        refresh()
    end
    local function launch()
        if not App.alive or App.launching or App.launched then
            return
        end
        App.launching, App.launchError, App.retryLaunch = true, false, nil
        task.spawn(function()
            local started = os.clock()
            setLaunchState("Getting your session ready", "Waiting for Roblox...", 0.3)
            local deadline = os.clock() + 60
            while App.alive and not game:IsLoaded() and os.clock() < deadline do
                task.wait(0.05)
            end
            if not App.alive then
                return
            end
            if not game:IsLoaded() then
                App.launching, App.launchError, App.retryLaunch = false, true, launch
                setLaunchState("Roblox is still loading", "Try again once the game has connected.", 0.3)
                return
            end
            local url = getScriptURL()
            local source, downloadError
            for attempt = 1, 3 do
                setLaunchState(
                    "Loading your script",
                    attempt > 1 and "Retrying the download..." or "Connecting to GitHub...",
                    0.55
                )
                local ok, value = bounded(function()
                    return game:HttpGet(url, true)
                end, 15)
                if not App.alive then
                    return
                end
                if ok and type(value) == "string" and #value > 0 then
                    source = value
                    break
                end
                downloadError = tostring(value)
                if attempt < 3 then
                    task.wait(attempt * 0.6)
                end
            end
            if not source then
                App.launching, App.launchError, App.retryLaunch = false, true, launch
                setLaunchState("Download unavailable", "The host did not respond. Try the download again.", 0.55)
                warn("[Zephyr] Download failed: " .. tostring(downloadError))
                return
            end
            local compileOK, chunk, compileError = pcall(loadstring, source)
            if not compileOK or type(chunk) ~= "function" then
                App.launching, App.launchError, App.retryLaunch = false, true, launch
                setLaunchState("Script could not load", "Invalid script response. Try downloading again.", 0.65)
                warn("[Zephyr] Compile failed: " .. tostring(compileError or chunk))
                return
            end
            setLaunchState("Ready when you are", "Welcome back, " .. LP.DisplayName .. ".", 0.9)
            while
                App.alive
                and not App.prefs.SkipIntro
                and not CONFIG.SkipLoader[game.GameId]
                and os.clock() - started < CONFIG.IntroDuration
            do
                task.wait(0.03)
            end
            if not App.alive then
                return
            end
            App.launched, App.launching = true, false
            setLaunchState("Zephyr is ready", "Your session is running.", 1)
            App.executionThread = coroutine.running()
            local ok, err = pcall(chunk)
            App.executionThread = nil
            if not App.alive then
                return
            end
            if not ok then
                App.launched, App.launchError = false, true
                setLaunchState(
                    "Script stopped",
                    "The game script reported an error. Check the console before re-executing.",
                    1
                )
                warn("[Zephyr] Failed to load script: " .. tostring(err))
            end
        end)
    end
    App.onPreferenceChanged = function(key)
        if key == "HideSettingsButton" then
            App.sessionHideSettingsButton = nil
        end
    end
    launch()
end

local function bindSettingsChat(player)
    local function handle(text)
        if not App.alive or type(text) ~= "string" then
            return
        end
        local command = text:lower():match("^%s*/e%s+(%a+)%s*$") or text:lower():match("^%s*/emote%s+(%a+)%s*$")
        if command == "hide" then
            App.sessionHideSettingsButton = true
            App.openSettings(false)
            refresh()
        elseif command == "unhide" then
            App.sessionHideSettingsButton = false
            refresh()
        end
    end
    connect(player.Chatted, handle)
    pcall(function()
        local chat = game:GetService("TextChatService")
        connect(chat.SendingMessage, function(message)
            handle(message.Text)
        end)
        local watched = {}
        local function watch(instance)
            if not instance:IsA("TextChatCommand") or watched[instance] then
                return
            end
            watched[instance] = true
            connect(instance.Triggered, function(source, text)
                if source and source.UserId == player.UserId then
                    handle(text)
                end
            end)
        end
        for _, instance in ipairs(chat:GetDescendants()) do
            watch(instance)
        end
        connect(chat.DescendantAdded, watch)
    end)
end

local function cleanup()
    if not App.alive then
        return
    end
    if App.saveStatus == "Saving..." then
        writePreferences()
    end
    App.alive = false
    Privacy.stop()
    if App.executionThread and App.executionThread ~= coroutine.running() then
        pcall(task.cancel, App.executionThread)
    end
    for _, connection in ipairs(App.connections) do
        connection:Disconnect()
    end
    for _, tween in pairs(App.tweens) do
        tween:Cancel()
    end
    table.clear(App.tweens)
    table.clear(App.tweenTargets)
    if App.restoreCursor then
        App.restoreCursor()
    end
    restoreEnvironment()
    for _, name in ipairs({ "settingsGui", "launcherGui", "launchGui", "blur" }) do
        local instance = App[name]
        if instance then
            instance:Destroy()
        end
    end
end
sharedEnv.__ZEPHYR_LOADER_CLEANUP = cleanup
App.executor = getExecutorName()
--  remains available on every device.
App.autoLite = detectMobile() or App.executor:lower():find("solara", 1, true) ~= nil

-- the button and settings before waiting for game.Loaded or network access.
local earlyPlayer = Players.LocalPlayer
if earlyPlayer then
    App.player = earlyPlayer
    App.configFile = "ZephyrSettings_" .. tostring(earlyPlayer.UserId) .. ".json"
    readPreferences()
end
for _, parent in ipairs({ CoreGui, earlyPlayer and earlyPlayer:FindFirstChild("PlayerGui") }) do
    for _, name in ipairs({
        "ZephyrKeySystem",
        "ZephyrLoader",
        "ZephyrV2Loader",
        "ZephyrSettings",
        "ZephyrSettingsButton",
        "ZephyrLauncher",
    }) do
        local old = parent:FindFirstChild(name)
        if old then
            old:Destroy()
        end
    end
end
local oldBlur = Lighting:FindFirstChild("ZephyrKeyBlur")
if oldBlur then
    oldBlur:Destroy()
end
buildShell()
buildLaunchUI()
refresh()
connect(Lighting.ChildAdded, function(child)
    if child:IsA("Sky") or child:IsA("Atmosphere") then
        Environment.schedule()
    end
end)
connect(Lighting.ChildRemoved, function(child)
    if child:IsA("Sky") or child:IsA("Atmosphere") then
        Environment.schedule()
    end
end)
task.spawn(function()
    local deadline = os.clock() + 30
    while App.alive and not Players.LocalPlayer and os.clock() < deadline do
        task.wait(0.05)
    end
    if not App.alive then
        return
    end
    local player = Players.LocalPlayer
    if not player then
        App.status, App.detail = "Waiting for your player", "Re-execute Zephyr once Roblox has connected."
        App.launchError = true
        refresh()
        return
    end
    App.player = player
    bindSettingsChat(player)
    if not App.configFile then
        App.configFile = "ZephyrSettings_" .. tostring(player.UserId) .. ".json"
        readPreferences()
    end
    if #App.pendingGuis > 0 then
        local playerGui = player:WaitForChild("PlayerGui", 10)
        if not App.alive then
            return
        end
        if not playerGui then
            warn("[Zephyr] PlayerGui is not ready. Re-execute after Roblox connects.")
            return
        end
        for _, gui in ipairs(App.pendingGuis) do
            gui.Parent = playerGui
        end
        table.clear(App.pendingGuis)
    end
    if next(App.dirtyPrefs) then
        savePreferences()
    end
    Privacy.apply()
    if App.executor:lower():find("xeno", 1, true) then
        App.status, App.detail, App.launchError =
            "Executor not supported", "Please use an executor compatible with Zephyr.", true
        refresh()
        pcall(function()
            player:Kick(
                "3RR0R: We do not support Xeno. It is one of the least compatible executors for Zephyr, so please switch to another executor."
            )
        end)
        return
    end
    Environment.apply()
    startLaunch()
end)
