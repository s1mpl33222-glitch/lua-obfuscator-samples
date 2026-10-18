-- SanX Key UI v1.1.6
-- Upload this file to Jnkie's UI-Source field and the main SanX script to its Script field.
-- Validates the access key, then lets Jnkie continue into the main script.

local BootEnvironment = type(getgenv) == "function" and getgenv() or _G

-- Only remove the legacy keyless authorization. Never erase a validated key.
if BootEnvironment.SCRIPT_KEY == "KEYLESS" then
    BootEnvironment.SCRIPT_KEY = nil
end

local PRIMARY_SERVICE = "Phasee"
local PRIMARY_PROVIDER = "PhaseKey"
local PRIMARY_IDENTIFIER = "1096182"
local PRIMARY_SDK_URL = "https://jnkie.com/sdk/library.lua"
local PRIMARY_KEY_FILE = "SanX/key.txt"

-- Validate an existing wrapper/saved key before constructing any interface.
-- This keeps the preview cards, buttons, tweens, and GUI instances completely
-- out of memory for returning authorized users.
local SanXPrimaryKeyAuthorized = type(BootEnvironment.SCRIPT_KEY) == "string"
    and BootEnvironment.SCRIPT_KEY ~= ""
local SanXPrimarySdk = nil

if not SanXPrimaryKeyAuthorized and type(isfile) == "function" and type(readfile) == "function" then
    local existsOk, exists = pcall(isfile, PRIMARY_KEY_FILE)
    if existsOk and exists then
        local readOk, savedKey = pcall(readfile, PRIMARY_KEY_FILE)
        savedKey = readOk and type(savedKey) == "string" and savedKey:match("^%s*(.-)%s*$") or nil
        if savedKey and savedKey ~= "" then
            local sdkOk, sdk = pcall(function()
                local sdkSource = game:HttpGet(PRIMARY_SDK_URL)
                local sdkChunk, sdkLoadError = loadstring(sdkSource)
                sdkSource = nil
                if not sdkChunk then error(sdkLoadError) end
                return sdkChunk()
            end)
            if sdkOk and type(sdk) == "table" then
                SanXPrimarySdk = sdk
                sdk.service = PRIMARY_SERVICE
                sdk.provider = PRIMARY_PROVIDER
                sdk.identifier = PRIMARY_IDENTIFIER
                local checkOk, result = pcall(sdk.check_key, savedKey)
                if checkOk and type(result) == "table" and (result.valid == true or result.success == true) then
                    BootEnvironment.SCRIPT_KEY = savedKey
                    SanXPrimaryKeyAuthorized = true
                elseif checkOk and type(result) == "table" and type(delfile) == "function" then
                    pcall(delfile, PRIMARY_KEY_FILE)
                end
            end
        end
    end
end

if not SanXPrimaryKeyAuthorized then

local App = {
    version = "v1.1.6",
    service = PRIMARY_SERVICE,
    provider = PRIMARY_PROVIDER,
    identifier = PRIMARY_IDENTIFIER,
    sdkUrl = PRIMARY_SDK_URL,
    keyFolder = "SanX",
    keyFile = "SanX/key.txt",
    maxAttempts = 5,
    connections = {},
    busy = false,
    authorized = false,
    attempts = 0,
    sdk = SanXPrimarySdk,
    aborted = false,
}

App.services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService"),
}

App.colors = {
    background = Color3.fromRGB(15, 12, 31),
    header = Color3.fromRGB(28, 32, 92),
    panel = Color3.fromRGB(17, 15, 35),
    card = Color3.fromRGB(20, 18, 42),
    hover = Color3.fromRGB(30, 21, 55),
    selected = Color3.fromRGB(59, 50, 150),
    input = Color3.fromRGB(20, 18, 42),
    button = Color3.fromRGB(30, 21, 55),
    inactive = Color3.fromRGB(17, 15, 35),
    border = Color3.fromRGB(91, 68, 143),
    accent = Color3.fromRGB(126, 101, 237),
    accentDark = Color3.fromRGB(101, 42, 137),
    edge = Color3.fromRGB(224, 105, 183),
    text = Color3.fromRGB(244, 248, 255),
    textDim = Color3.fromRGB(171, 158, 207),
    success = Color3.fromRGB(68, 196, 128),
    warning = Color3.fromRGB(236, 181, 54),
    danger = Color3.fromRGB(235, 82, 94),
}

function App.new(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

function App.corner(parent, radius)
    return App.new("UICorner", {CornerRadius = UDim.new(0, radius or 7)}, parent)
end

function App.stroke(parent, color, thickness, transparency)
    return App.new("UIStroke", {
        Color = color or App.colors.border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

function App.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(App.connections, connection)
    return connection
end

function App.tween(object, duration, properties, style, direction)
    local tween = App.services.TweenService:Create(object, TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    ), properties)
    tween:Play()
    return tween
end

function App.button(parent, text, position, size, color)
    local button = App.new("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = color or App.colors.button,
        BorderSizePixel = 0,
        Position = position,
        Size = size,
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = App.colors.text,
        TextSize = 12,
    }, parent)
    App.corner(button, 7)
    App.connect(button.MouseEnter, function()
        App.tween(button, 0.16, {BackgroundColor3 = App.colors.hover})
    end)
    App.connect(button.MouseLeave, function()
        App.tween(button, 0.16, {BackgroundColor3 = color or App.colors.button})
    end)
    return button
end

function App.label(parent, text, position, size, textSize, color, alignment)
    return App.new("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = color or App.colors.text,
        TextSize = textSize or 13,
        TextXAlignment = alignment or Enum.TextXAlignment.Left,
        TextWrapped = false,
    }, parent)
end

function App.makeDraggable(handle, target)
    local dragging = false
    local dragStart
    local startPosition
    App.connect(handle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = target.Position
        end
    end)
    App.connect(App.services.UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    App.connect(App.services.UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

function App.getGuiParent()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    local ok, result = pcall(function() return App.services.CoreGui end)
    if ok and result then return result end
    return App.services.Players.LocalPlayer:WaitForChild("PlayerGui")
end

function App.readSavedKey()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
    local ok, exists = pcall(isfile, App.keyFile)
    if not ok or not exists then return nil end
    local readOk, value = pcall(readfile, App.keyFile)
    if readOk and type(value) == "string" and value:match("%S") then
        return value:match("^%s*(.-)%s*$")
    end
    return nil
end

function App.saveKey(key)
    if type(writefile) ~= "function" then return end
    if type(makefolder) == "function" then
        pcall(makefolder, App.keyFolder)
    end
    pcall(writefile, App.keyFile, key)
end

function App.clearSavedKey()
    if type(isfile) == "function" and type(delfile) == "function" then
        local ok, exists = pcall(isfile, App.keyFile)
        if ok and exists then pcall(delfile, App.keyFile) end
    end
end

function App.cleanKey(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

function App.destroy()
    for _, connection in ipairs(App.connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(App.connections)
    if App.screen then App.screen:Destroy() end
end

function App.abortAccess()
    App.aborted = true
    BootEnvironment.SCRIPT_KEY = nil
    App.destroy()
end

function App.setStatus(message, kind)
    if not App.statusLabel then return end
    local colors = {
        success = App.colors.success,
        warning = App.colors.warning,
        danger = App.colors.danger,
        info = App.colors.accent,
    }
    App.statusLabel.Text = message
    App.statusLabel.TextColor3 = colors[kind] or App.colors.textDim
    if App.statusDot then
        App.tween(App.statusDot, 0.18, {BackgroundColor3 = colors[kind] or App.colors.textDim})
    end
end

function App.errorMessage(code)
    local messages = {
        KEY_INVALID = "That key was not found.",
        KEY_EXPIRED = "That key has expired. Please get a new one.",
        HWID_BANNED = "This device is not permitted to use SanX.",
        KEY_INVALIDATED = "That key was disabled.",
        ALREADY_USED = "That one-time key has already been used.",
        HWID_MISMATCH = "That key has reached its device limit.",
        SERVICE_NOT_FOUND = "The SanX service configuration could not be found.",
        SERVICE_MISMATCH = "That key belongs to a different service.",
        PREMIUM_REQUIRED = "This key does not meet the service requirements.",
        ERROR = "Jnkie could not be reached. Please try again.",
        RATE_LIMITTED = "Jnkie is rate limiting key links. Please wait about five minutes.",
    }
    code = tostring(code or "ERROR")
    if code:match("^http 429") then return "Jnkie is rate limiting requests. Please wait and retry." end
    if code:match("^http %d+") then return "Jnkie returned " .. code .. ". Please retry shortly." end
    return messages[code] or ("Validation failed: " .. code)
end

function App.loadSdk()
    if App.sdk then return true end
    App.setStatus("Connecting to Jnkie...", "info")
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(App.sdkUrl))()
    end)
    if not ok or type(result) ~= "table" then
        App.setStatus("Jnkie is unavailable. Check your connection and retry.", "danger")
        return false
    end
    result.service = App.service
    result.provider = App.provider
    result.identifier = App.identifier
    App.sdk = result
    App.setStatus("Ready for access key.", "success")
    return true
end

function App.launchMain(key)
    local environment = type(getgenv) == "function" and getgenv() or _G
    environment.SCRIPT_KEY = key
    App.authorized = true
    App.setStatus("Access granted. Loading SanX...", "success")
    App.tween(App.login, 0.22, {BackgroundTransparency = 1})
    task.wait(0.24)
    App.destroy()
end

function App.validateKey(key, automatic)
    if App.busy then return end
    key = App.cleanKey(key)
    if key == "" then
        App.setStatus("Enter a key before checking it.", "warning")
        return
    end
    if not App.sdk and not App.loadSdk() then return end
    App.busy = true
    if App.checkButton then
        App.checkButton.Text = "CHECKING..."
        App.tween(App.checkButton, 0.16, {BackgroundColor3 = App.colors.accentDark})
    end
    if not automatic then App.attempts += 1 end
    local ok, result = pcall(function() return App.sdk.check_key(key) end)
    local valid = ok and type(result) == "table" and (result.valid == true or result.success == true)
    if valid then
        App.saveKey(key)
        App.busy = false
        App.launchMain(key)
        return
    end
    local code = ok and type(result) == "table" and (result.error or result.message) or "ERROR"
    if automatic or code == "KEY_EXPIRED" or code == "KEY_INVALIDATED" or code == "HWID_MISMATCH" then
        App.clearSavedKey()
    end
    if App.checkButton then
        App.checkButton.Text = "CHECK KEY"
        App.tween(App.checkButton, 0.16, {BackgroundColor3 = App.colors.accent})
    end
    App.setStatus(App.errorMessage(code), "danger")
    App.busy = false
    if App.attempts >= App.maxAttempts then
        App.checkButton.Active = false
        App.checkButton.Text = "TRY AGAIN LATER"
        App.setStatus("Too many failed attempts. Restart the loader to retry.", "danger")
    end
end

function App.getKeyLink()
    if App.busy then return end
    if not App.sdk and not App.loadSdk() then return end
    App.busy = true
    App.getButton.Text = "CREATING..."
    local ok, link, err = pcall(function()
        local generated, failure = App.sdk.get_key_link()
        return generated, failure
    end)
    App.getButton.Text = "GET KEY"
    App.busy = false
    if ok and type(link) == "string" and link ~= "" then
        if type(setclipboard) == "function" then
            pcall(setclipboard, link)
            App.setStatus("Key link copied to your clipboard.", "success")
        else
            App.keyBox.Text = link
            App.setStatus("Clipboard access is unavailable; the link is in the field.", "warning")
        end
    else
        App.setStatus(App.errorMessage(err), "danger")
    end
end

App.previewData = {
    {
        name = "COMBAT",
        features = {
            {name = "Aimbot", kind = "toggle", settings = {
                {"Target Type", "dropdown", {"Players", "NPCs", "Both"}},
                {"Aim Mode", "dropdown", {"Camera", "Mouse"}},
                {"Show FOV", "check"}, {"FOV Radius", "slider", 40, 500, 180},
                {"Smoothness", "slider", 1, 20, 8},
            }},
            {name = "Expander HitBox", kind = "toggle", settings = {
                {"Target Type", "dropdown", {"Players", "Wanted", "Arrested"}},
                {"Size", "slider", 2, 30, 10}, {"Transparency", "slider", 0, 100, 45},
                {"Show Wanted", "check"}, {"Show Arrested", "check"},
                {"Kill All", "action"}, {"Debug", "action"},
            }},
            {name = "Gun Mods", kind = "toggle", settings = {
                {"No recoil/spread", "check"}, {"Rapid fire", "check"},
                {"Infinite ammo", "check"}, {"Always automatic", "check"},
                {"Gun RPM", "slider", 100, 5000, 1500},
            }},
        },
    },
    {
        name = "VISUAL",
        features = {
            {name = "One Person ESP", kind = "search", settings = {{"Player", "search", {"PlayerOne", "PlayerTwo", "PlayerThree"}}}},
            {name = "View Player", kind = "search", settings = {{"Player", "search", {"PlayerOne", "PlayerTwo", "PlayerThree"}}}},
            {name = "Advanced ESP", kind = "toggle", settings = {
                {"Target Type", "dropdown", {"Players", "Team", "All"}}, {"Performance Mode", "check"},
                {"Max Distance", "slider", 100, 5000, 1000}, {"Highlight ESP", "check"},
                {"Skeleton", "check"}, {"Show Name", "check"}, {"Show Health", "check"},
                {"Show Distance", "check"}, {"Show Wanted", "check"}, {"Show Arrested", "check"},
                {"Filter", "dropdown", {"Everyone", "Enemies", "Wanted"}},
            }},
            {name = "Inf Zoom-Out", kind = "toggle"},
        },
    },
    {
        name = "PLAYER",
        features = {
            {name = "Click TP", kind = "toggle"},
            {name = "XYZ TP", kind = "action", actionText = "TP", settings = {
                {"X", "input", "X"}, {"Y", "input", "Y"}, {"Z", "input", "Z"},
            }},
            {name = "Fly", kind = "toggle", settings = {{"Fly Speed", "slider", 10, 300, 75}}},
            {name = "Safe Rob", kind = "toggle"}, {name = "Infinite Hunger", kind = "toggle"},
            {name = "Infinite Stamina", kind = "toggle"}, {name = "Keep Inventory", kind = "toggle"},
            {name = "Avoid death", kind = "toggle"}, {name = "Last Death TP", kind = "action"},
            {name = "Anti-Arrest", kind = "toggle"}, {name = "House Anti-Kick", kind = "toggle"},
            {name = "Expand Handcuff Range", kind = "toggle"}, {name = "Anim Zombie FE", kind = "action"},
            {name = "Invisibility", kind = "toggle", settings = {
                {"Depth", "dropdown", {"Shallow", "Normal", "Deep"}}, {"Voice", "check"},
            }},
        },
    },
    {
        name = "FARM",
        features = {
            {name = "Auto Pick Up Money", kind = "toggle"}, {name = "Golf Autofarm", kind = "toggle"},
            {name = "Auto Minigame (Instant)", kind = "toggle"}, {name = "Legit Auto ATM", kind = "toggle"},
        },
    },
    {
        name = "STORE",
        features = {
            {name = "Black Market", kind = "list", settings = {{"Items", "search", {"Lockpick", "Mask", "Drill", "Armor"}}}},
            {name = "Gun Dealer", kind = "list", settings = {{"Items", "search", {"Pistol", "SMG", "Shotgun", "Ammo"}}}},
        },
    },
    {
        name = "OTHER",
        features = {
            {name = "No Props", kind = "toggle"}, {name = "Remove REDLight/Speed", kind = "toggle"},
            {name = "Bypass All Restrictions", kind = "toggle", info = "Combines infinite ammo, traffic, building, and related restriction bypasses."},
            {name = "Instant Interact", kind = "toggle"},
            {name = "Change outfit while wanted", kind = "double", actions = {"CLOTHING STORE", "TELEPORT BACK"}},
            {name = "No Fall Damage", kind = "toggle"}, {name = "No Ragdoll", kind = "toggle"},
            {name = "UGC Emotes", kind = "action", actionText = "OPEN", tag = "Opens new script"},
            {name = "Violent mod menu", kind = "action", actionText = "OPEN", tag = "Opens new script"},
        },
    },
    {
        name = "TELEPORT",
        features = (function()
            local result = {}
            local names = {
                "Teleport to waypoint", "Hospital bed", "Hospital", "Spawn", "Clothing store City",
                "Car shop", "Police station", "Autoshop", "National bank", "Parking building", "Cinema",
                "Arcade", "Golf", "Gradview homes", "Grandview town", "Yacht", "Leisville",
                "Maldini's pizza", "Clothing store Leisville", "Gun store", "Yorktown", "Yorktown bank",
                "Westdale hill", "Prison", "Milton homes", "Gas station",
            }
            for _, name in ipairs(names) do table.insert(result, {name = name, kind = "action", actionText = "TP"}) end
            return result
        end)(),
    },
    {name = "HOMES", features = {{name = "Enter Home", kind = "list", settings = {{"Homes", "search", {"Grandview 12", "Milton 04", "Yorktown 19"}}}}}},
    {
        name = "VEHICLE MODS",
        features = {
            {name = "Car Scanner", kind = "list", settings = {{"Nearby Cars", "search", {"Sedan", "SUV", "Coupe"}}}},
            {name = "Vehicle Mods", kind = "toggle", settings = {
                {"Vehicle Speed", "slider", 1, 10, 2}, {"Vehicle Acceleration", "slider", 1, 10, 2},
                {"Infinite Fuel", "check"}, {"Vehicle God Mode", "check"},
            }},
            {name = "Trunk Manager", kind = "triple", actions = {"OPEN", "DEPOSIT ALL", "WITHDRAW ALL"}},
        },
    },
    {
        name = "AVATARS",
        features = {
            {name = "Avatar Saves", kind = "list", subtitle = "Save an avatar in any game and import it into San Aurie.", settings = {
                {"Avatar Name", "input", "Save name"}, {"Saved Avatars", "search", {"Video Alt", "Police", "Civilian"}},
            }},
        },
    },
}

App.preview = {}

function App.preview.makeToggle(parent, initial, callback)
    local active = initial == true
    local track = App.new("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = active and App.colors.accent or App.colors.inactive,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(62, 28),
        Text = "",
    }, parent)
    App.corner(track, 7)
    local knob = App.new("Frame", {
        BackgroundColor3 = App.colors.text,
        BorderSizePixel = 0,
        Position = active and UDim2.new(1, -26, 0.5, -10) or UDim2.new(0, 6, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
    }, track)
    App.corner(knob, 10)
    local state = App.label(track, active and "ON" or "OFF", active and UDim2.fromOffset(7, 0) or UDim2.fromOffset(31, 0), UDim2.fromOffset(25, 28), 9, active and App.colors.text or App.colors.textDim, Enum.TextXAlignment.Center)
    state.Font = Enum.Font.GothamBold
    App.connect(track.MouseButton1Click, function()
        active = not active
        state.Text = active and "ON" or "OFF"
        App.tween(track, 0.18, {BackgroundColor3 = active and App.colors.accent or App.colors.inactive})
        App.tween(knob, 0.18, {Position = active and UDim2.new(1, -26, 0.5, -10) or UDim2.new(0, 6, 0.5, -10)})
        App.tween(state, 0.18, {
            Position = active and UDim2.fromOffset(7, 0) or UDim2.fromOffset(31, 0),
            TextColor3 = active and App.colors.text or App.colors.textDim,
        })
        if callback then callback(active) end
    end)
    return track
end

function App.preview.makeCheckbox(parent)
    local active = false
    local box = App.new("TextButton", {
        AutoButtonColor = false, BackgroundColor3 = App.colors.input, BorderSizePixel = 0,
        Size = UDim2.fromOffset(24, 24), Text = "", Font = Enum.Font.GothamBold,
        TextColor3 = App.colors.text, TextSize = 14,
    }, parent)
    App.corner(box, 5)
    App.stroke(box)
    App.connect(box.MouseButton1Click, function()
        active = not active
        box.Text = active and "OK" or ""
        App.tween(box, 0.16, {BackgroundColor3 = active and App.colors.accent or App.colors.input})
    end)
    return box
end

function App.preview.makeAction(parent, text)
    local button = App.button(parent, text or "RUN", UDim2.new(), UDim2.fromOffset(112, 30), App.colors.button)
    App.connect(button.MouseButton1Click, function()
        local original = button.Text
        button.Text = "PREVIEWED"
        App.tween(button, 0.14, {BackgroundColor3 = App.colors.accentDark})
        task.delay(0.7, function()
            if button.Parent then
                button.Text = original
                App.tween(button, 0.18, {BackgroundColor3 = App.colors.button})
            end
        end)
    end)
    return button
end

function App.preview.makeInput(parent, placeholder, width)
    local box = App.new("TextBox", {
        BackgroundColor3 = App.colors.input, BorderSizePixel = 0, ClearTextOnFocus = false,
        Size = UDim2.fromOffset(width or 130, 30), Font = Enum.Font.Gotham,
        PlaceholderText = placeholder or "Type...", PlaceholderColor3 = App.colors.textDim,
        Text = "", TextColor3 = App.colors.text, TextSize = 11,
    }, parent)
    App.corner(box, 6)
    App.stroke(box)
    return box
end

function App.preview.makeDropdown(parent, values)
    local index = 1
    local button = App.button(parent, values[index], UDim2.new(), UDim2.fromOffset(140, 30), App.colors.input)
    button.TextColor3 = App.colors.accent
    App.connect(button.MouseButton1Click, function()
        index = index % #values + 1
        button.Text = values[index]
        App.tween(button, 0.14, {BackgroundColor3 = App.colors.selected})
        task.delay(0.16, function()
            if button.Parent then App.tween(button, 0.16, {BackgroundColor3 = App.colors.input}) end
        end)
    end)
    return button
end

function App.preview.makeSlider(parent, minimum, maximum, initial)
    local value = math.clamp(initial or minimum, minimum, maximum)
    local box = App.preview.makeInput(parent, "", 58)
    box.Text = tostring(value)
    box.Position = UDim2.new(1, -58, 0, 0)
    local track = App.new("TextButton", {
        AutoButtonColor = false, BackgroundColor3 = App.colors.inactive, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, -3), Size = UDim2.new(1, -70, 0, 6), Text = "",
    }, parent)
    App.corner(track, 3)
    local fill = App.new("Frame", {
        BackgroundColor3 = App.colors.accent, BorderSizePixel = 0,
        Size = UDim2.new((value - minimum) / (maximum - minimum), 0, 1, 0),
    }, track)
    App.corner(fill, 3)
    local function setFromRatio(ratio)
        ratio = math.clamp(ratio, 0, 1)
        value = math.floor(minimum + (maximum - minimum) * ratio + 0.5)
        box.Text = tostring(value)
        App.tween(fill, 0.12, {Size = UDim2.new(ratio, 0, 1, 0)})
    end
    App.connect(track.MouseButton1Down, function(x)
        setFromRatio((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
    end)
    App.connect(box.FocusLost, function()
        local parsed = tonumber(box.Text) or value
        value = math.clamp(parsed, minimum, maximum)
        box.Text = tostring(value)
        App.tween(fill, 0.12, {Size = UDim2.new((value - minimum) / (maximum - minimum), 0, 1, 0)})
    end)
    return track
end

function App.preview.addSetting(parent, definition)
    local name, kind = definition[1], definition[2]
    local row = App.new("Frame", {
        BackgroundColor3 = App.colors.panel, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, kind == "search" and 114 or 40),
    }, parent)
    App.corner(row, 6)
    App.label(row, name, UDim2.fromOffset(12, 0), UDim2.new(0.48, -12, 0, 40), 11, App.colors.textDim)
    if kind == "check" then
        local control = App.preview.makeCheckbox(row)
        control.AnchorPoint = Vector2.new(1, 0.5)
        control.Position = UDim2.new(1, -10, 0, 20)
    elseif kind == "slider" then
        local holder = App.new("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0.48, 0, 0, 5), Size = UDim2.new(0.52, -10, 0, 30)}, row)
        App.preview.makeSlider(holder, definition[3], definition[4], definition[5])
    elseif kind == "dropdown" then
        local control = App.preview.makeDropdown(row, definition[3])
        control.AnchorPoint = Vector2.new(1, 0.5)
        control.Position = UDim2.new(1, -10, 0, 20)
    elseif kind == "action" then
        local control = App.preview.makeAction(row, string.upper(name))
        control.AnchorPoint = Vector2.new(1, 0.5)
        control.Position = UDim2.new(1, -10, 0, 20)
    elseif kind == "input" then
        local control = App.preview.makeInput(row, definition[3], 140)
        control.AnchorPoint = Vector2.new(1, 0.5)
        control.Position = UDim2.new(1, -10, 0, 20)
    elseif kind == "search" then
        local search = App.preview.makeInput(row, "Search...", 0)
        search.Position = UDim2.fromOffset(10, 38)
        search.Size = UDim2.new(1, -20, 0, 28)
        local result = App.label(row, table.concat(definition[3], "   |   "), UDim2.fromOffset(12, 72), UDim2.new(1, -24, 0, 30), 10, App.colors.accent)
        result.TextTruncate = Enum.TextTruncate.AtEnd
        App.connect(search:GetPropertyChangedSignal("Text"), function()
            local matches = {}
            local query = string.lower(search.Text)
            for _, item in ipairs(definition[3]) do
                if query == "" or string.find(string.lower(item), query, 1, true) then table.insert(matches, item) end
            end
            result.Text = #matches > 0 and table.concat(matches, "   |   ") or "No preview results"
        end)
    end
    return row
end

function App.preview.addFeature(parent, feature)
    local expanded = false
    local baseHeight = feature.subtitle and 78 or (feature.kind == "double" and 92 or feature.kind == "triple" and 96 or 62)
    local settingsHeight = 0
    for _, setting in ipairs(feature.settings or {}) do settingsHeight += setting[2] == "search" and 122 or 48 end
    local card = App.new("Frame", {
        BackgroundColor3 = App.colors.card, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, baseHeight), ClipsDescendants = true,
    }, parent)
    App.corner(card, 7)
    App.stroke(card, App.colors.border, 1, 0.35)
    local titleWidth = feature.settings and -170 or -92
    App.label(card, feature.name, UDim2.fromOffset(18, 0), UDim2.new(1, titleWidth, 0, feature.subtitle and 40 or 62), 13, App.colors.text)
    if feature.subtitle then
        local subtitle = App.label(card, feature.subtitle, UDim2.fromOffset(18, 34), UDim2.new(1, -190, 0, 30), 9, App.colors.textDim)
        subtitle.TextWrapped = true
    end
    if feature.info then
        local info = App.label(card, "i", UDim2.new(0, math.min(260, 18 + #feature.name * 7), 0, 19), UDim2.fromOffset(20, 22), 11, App.colors.textDim, Enum.TextXAlignment.Center)
        info.BackgroundTransparency = 0
        info.BackgroundColor3 = App.colors.input
        App.corner(info, 10)
        local tip = App.label(App.preview.window, feature.info, UDim2.fromOffset(0, 0), UDim2.fromOffset(310, 48), 10, App.colors.textDim)
        tip.BackgroundTransparency = 0
        tip.BackgroundColor3 = App.colors.input
        tip.TextWrapped = true
        tip.Visible = false
        tip.ZIndex = 50
        App.corner(tip, 6)
        App.stroke(tip, App.colors.border)
        App.connect(info.MouseEnter, function()
            local relativeX = info.AbsolutePosition.X - App.preview.window.AbsolutePosition.X
            local relativeY = info.AbsolutePosition.Y - App.preview.window.AbsolutePosition.Y
            tip.Position = UDim2.fromOffset(math.clamp(relativeX - 8, 12, App.preview.window.AbsoluteSize.X - 322), math.max(62, relativeY - 54))
            tip.Visible = true
        end)
        App.connect(info.MouseLeave, function() tip.Visible = false end)
        App.connect(card.Destroying, function()
            if tip.Parent then tip:Destroy() end
        end)
    end
    if feature.kind == "toggle" then
        local toggle = App.preview.makeToggle(card, false)
        toggle.AnchorPoint = Vector2.new(1, 0.5)
        toggle.Position = UDim2.new(1, -16, 0, baseHeight / 2)
    elseif feature.kind == "double" or feature.kind == "triple" then
        local actions = feature.actions
        local gap = 8
        local count = #actions
        for index, text in ipairs(actions) do
            local action = App.preview.makeAction(card, text)
            action.Position = UDim2.new((index - 1) / count, 18 + (index - 1) * gap / count, 0, 48)
            action.Size = UDim2.new(1 / count, -(36 + gap * (count - 1)) / count, 0, 32)
        end
    else
        local action = App.preview.makeAction(card, feature.actionText or (feature.kind == "search" and "SELECT" or feature.kind == "list" and "OPEN" or "RUN"))
        action.AnchorPoint = Vector2.new(1, 0.5)
        action.Position = UDim2.new(1, -16, 0, baseHeight / 2)
    end
    if feature.tag then
        local tag = App.label(card, feature.tag, UDim2.new(1, -246, 0, 0), UDim2.fromOffset(112, baseHeight), 9, App.colors.textDim, Enum.TextXAlignment.Right)
        tag.Font = Enum.Font.GothamItalic
    end
    local settings
    if feature.settings then
        local expand = App.button(card, "+", UDim2.new(1, -164, 0.5, -15), UDim2.fromOffset(30, 30), App.colors.input)
        expand.TextSize = 15
        settings = App.new("Frame", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(12, baseHeight), Size = UDim2.new(1, -24, 0, settingsHeight),
        }, card)
        local layout = App.new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, settings)
        for _, definition in ipairs(feature.settings) do App.preview.addSetting(settings, definition) end
        App.connect(expand.MouseButton1Click, function()
            expanded = not expanded
            expand.Text = expanded and "-" or "+"
            App.tween(card, 0.22, {Size = UDim2.new(1, 0, 0, expanded and baseHeight + settingsHeight + 10 or baseHeight)}, Enum.EasingStyle.Sine)
        end)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            settings.Size = UDim2.new(1, -24, 0, layout.AbsoluteContentSize.Y)
        end)
    end
    return card
end

function App.preview.openOverlay(title, lines)
    if App.preview.overlay then App.preview.overlay:Destroy() end
    local overlay = App.new("Frame", {
        BackgroundColor3 = App.colors.header, BorderSizePixel = 0,
        Position = UDim2.new(1, 20, 0, 58), Size = UDim2.new(0, 340, 1, -58), ZIndex = 20,
    }, App.preview.window)
    App.preview.overlay = overlay
    App.stroke(overlay, App.colors.border)
    App.label(overlay, title, UDim2.fromOffset(20, 8), UDim2.new(1, -70, 0, 48), 15, App.colors.text).Font = Enum.Font.GothamSemibold
    local close = App.button(overlay, "X", UDim2.new(1, -48, 0, 12), UDim2.fromOffset(32, 32), App.colors.button)
    local body = App.new("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(16, 62),
        Size = UDim2.new(1, -32, 1, -78), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3, ScrollBarImageColor3 = App.colors.accent,
    }, overlay)
    local layout = App.new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, body)
    for _, line in ipairs(lines) do
        local row = App.new("Frame", {BackgroundColor3 = App.colors.card, BorderSizePixel = 0, Size = UDim2.new(1, -4, 0, 52)}, body)
        App.corner(row, 6)
        App.label(row, line, UDim2.fromOffset(14, 0), UDim2.new(1, -112, 1, 0), 11, App.colors.textDim)
        local action = App.preview.makeAction(row, "PREVIEW")
        action.AnchorPoint = Vector2.new(1, 0.5)
        action.Position = UDim2.new(1, -10, 0.5, 0)
        action.Size = UDim2.fromOffset(86, 30)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        body.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)
    App.connect(close.MouseButton1Click, function()
        App.tween(overlay, 0.2, {Position = UDim2.new(1, 20, 0, 58)})
        task.delay(0.21, function() if overlay.Parent then overlay:Destroy() end end)
    end)
    App.tween(overlay, 0.22, {Position = UDim2.new(1, -340, 0, 58)}, Enum.EasingStyle.Sine)
end

function App.preview.renderCategory(index)
    for _, child in ipairs(App.preview.left:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, child in ipairs(App.preview.right:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for buttonIndex, button in ipairs(App.preview.categoryButtons) do
        App.tween(button, 0.18, {BackgroundColor3 = buttonIndex == index and App.colors.selected or App.colors.panel})
        local line = button:FindFirstChild("Selection")
        if line then App.tween(line, 0.18, {BackgroundTransparency = buttonIndex == index and 0 or 1}) end
    end
    local category = App.previewData[index]
    for featureIndex, feature in ipairs(category.features) do
        App.preview.addFeature(featureIndex % 2 == 1 and App.preview.left or App.preview.right, feature)
    end
end

function App.preview.close()
    if not App.preview.window then return end
    local window = App.preview.window
    App.tween(window, 0.2, {Position = UDim2.new(0.5, 0, 0.5, 18)}, Enum.EasingStyle.Sine)
    task.delay(0.21, function()
        if window.Parent then window:Destroy() end
        App.preview.window = nil
        App.login.Visible = true
        App.login.Position = UDim2.new(0.5, 0, 0.5, 12)
        App.tween(App.login, 0.22, {Position = UDim2.new(0.5, 0, 0.5, 0)}, Enum.EasingStyle.Sine)
    end)
end

function App.preview.open()
    if App.preview.window then return end
    App.login.Visible = false
    local window = App.new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = App.colors.background, BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 18), Size = UDim2.fromOffset(800, 520), ClipsDescendants = true,
    }, App.screen)
    App.preview.window = window
    App.corner(window, 8)
    App.stroke(window, App.colors.border)
    local sizeConstraint = App.new("UISizeConstraint", {MinSize = Vector2.new(700, 450), MaxSize = Vector2.new(900, 620)}, window)
    local header = App.new("Frame", {BackgroundColor3 = App.colors.header, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 58)}, window)
    App.label(header, "San", UDim2.fromOffset(22, 0), UDim2.fromOffset(38, 58), 21, App.colors.text).Font = Enum.Font.GothamSemibold
    App.label(header, "X", UDim2.fromOffset(60, 0), UDim2.fromOffset(20, 58), 21, App.colors.accent).Font = Enum.Font.GothamBold
    App.label(header, "PREVIEW MODE", UDim2.fromOffset(94, 0), UDim2.fromOffset(100, 58), 9, App.colors.textDim).Font = Enum.Font.GothamBold
    local utilities = {
        {"P", "Presets", {"Default", "Recording", "Visuals", "Vehicle"}},
        {"K", "Keybinds", {"Home - Menu", "Insert - Console", "H - Hitbox Debug", "Unassigned"}},
        {"WP", "Waypoints", {"City", "Bank", "Prison", "Custom waypoint"}},
        {"LOG", "Server Log", {"Current server", "Previous server", "Join history"}},
        {"HOME", "Home", {"SanX preview", "Feature controls are visual only", "No gameplay callbacks are connected"}},
    }
    local rightOffset = 48
    for utilityIndex = #utilities, 1, -1 do
        local utility = utilities[utilityIndex]
        local width = utility[1] == "HOME" and 72 or utility[1] == "LOG" and 48 or 40
        rightOffset += width + 7
        local button = App.button(header, utility[1], UDim2.new(1, -rightOffset, 0, 12), UDim2.fromOffset(width, 34), App.colors.button)
        App.connect(button.MouseButton1Click, function() App.preview.openOverlay(utility[2], utility[3]) end)
    end
    local close = App.button(header, "X", UDim2.new(1, -43, 0, 12), UDim2.fromOffset(32, 34), Color3.fromRGB(67, 29, 34))
    App.connect(close.MouseButton1Click, App.preview.close)
    local categoryPanel = App.new("Frame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 66), Size = UDim2.new(1, -24, 0, 102),
    }, window)
    App.preview.categoryButtons = {}
    for index, category in ipairs(App.previewData) do
        local column = (index - 1) % 5
        local row = math.floor((index - 1) / 5)
        local button = App.button(categoryPanel, category.name, UDim2.new(column / 5, 4, 0, row * 50), UDim2.new(0.2, -8, 0, 44), App.colors.panel)
        button.TextColor3 = App.colors.textDim
        local selection = App.new("Frame", {
            Name = "Selection", BackgroundColor3 = App.colors.accent, BackgroundTransparency = 1,
            BorderSizePixel = 0, Position = UDim2.new(0, 12, 1, -3), Size = UDim2.new(1, -24, 0, 3),
        }, button)
        App.corner(selection, 2)
        table.insert(App.preview.categoryButtons, button)
        App.connect(button.MouseButton1Click, function() App.preview.renderCategory(index) end)
    end
    local content = App.new("Frame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 174), Size = UDim2.new(1, -24, 1, -200),
    }, window)
    local function makeColumn(position)
        local scroll = App.new("ScrollingFrame", {
            BackgroundTransparency = 1, BorderSizePixel = 0, Position = position, Size = UDim2.new(0.5, -6, 1, 0),
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
            ScrollBarImageColor3 = App.colors.accent, ScrollingDirection = Enum.ScrollingDirection.Y,
        }, content)
        App.new("UIPadding", {PaddingRight = UDim.new(0, 7)}, scroll)
        local layout = App.new("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, scroll)
        App.connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
        end)
        return scroll
    end
    App.preview.left = makeColumn(UDim2.fromOffset(0, 0))
    App.preview.right = makeColumn(UDim2.new(0.5, 6, 0, 0))
    App.label(window, "PREVIEW ONLY  |  Controls do not execute gameplay code  |  " .. App.version,
        UDim2.new(0, 18, 1, -24), UDim2.new(1, -36, 0, 20), 9, App.colors.textDim, Enum.TextXAlignment.Right)
    App.makeDraggable(header, window)
    App.preview.renderCategory(1)
    App.tween(window, 0.22, {Position = UDim2.new(0.5, 0, 0.5, 0)}, Enum.EasingStyle.Sine)
end

function App.buildLogin()
    local old = App.getGuiParent():FindFirstChild("SanXKeySystem")
    if old then old:Destroy() end
    App.screen = App.new("ScreenGui", {
        Name = "SanXKeySystem", ResetOnSpawn = false, IgnoreGuiInset = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, App.getGuiParent())
    local login = App.new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = App.colors.background, BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 16), Size = UDim2.fromOffset(620, 390), ClipsDescendants = true,
    }, App.screen)
    App.login = login
    App.corner(login, 8)
    App.stroke(login, App.colors.border)
    local header = App.new("Frame", {BackgroundColor3 = App.colors.header, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 64)}, login)
    App.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 30, 91)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 32, 92)),
        }),
    }, header)
    App.new("Frame", {
        BackgroundColor3 = App.colors.edge, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2), ZIndex = 3,
    }, header)
    App.label(header, "San", UDim2.fromOffset(24, 0), UDim2.fromOffset(42, 64), 23, App.colors.text).Font = Enum.Font.ArialBold
    App.label(header, "X", UDim2.fromOffset(66, 0), UDim2.fromOffset(22, 64), 23, App.colors.edge).Font = Enum.Font.ArialBold
    App.label(header, "Secure Access", UDim2.fromOffset(102, 0), UDim2.fromOffset(130, 64), 11, App.colors.textDim)
    local close = App.button(header, "X", UDim2.new(1, -48, 0, 15), UDim2.fromOffset(34, 34), App.colors.header)
    close.BackgroundTransparency = 1
    close.TextSize = 18
    App.connect(close.MouseButton1Click, App.destroy)
    App.makeDraggable(header, login)
    App.label(login, "ACCESS KEY", UDim2.fromOffset(30, 84), UDim2.fromOffset(180, 22), 10, App.colors.textDim).Font = Enum.Font.GothamBold
    local keyBox = App.new("TextBox", {
        BackgroundColor3 = App.colors.input, BorderSizePixel = 0, ClearTextOnFocus = false,
        Position = UDim2.fromOffset(30, 111), Size = UDim2.new(1, -60, 0, 48), Font = Enum.Font.Arial,
        PlaceholderText = "Paste your SanX key", PlaceholderColor3 = App.colors.textDim,
        Text = "", TextColor3 = App.colors.text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    }, login)
    App.new("UIPadding", {PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}, keyBox)
    App.corner(keyBox, 7)
    App.stroke(keyBox)
    App.keyBox = keyBox
    local getButton = App.button(login, "GET KEY", UDim2.fromOffset(30, 174), UDim2.new(0.31, -7, 0, 42), App.colors.button)
    local checkButton = App.button(login, "CHECK KEY", UDim2.new(0.31, 30, 0, 174), UDim2.new(0.38, -14, 0, 42), App.colors.accent)
    local previewButton = App.button(login, "PREVIEW SCRIPT", UDim2.new(0.69, 23, 0, 174), UDim2.new(0.31, -53, 0, 42), App.colors.button)
    App.getButton = getButton
    App.checkButton = checkButton
    App.connect(getButton.MouseButton1Click, App.getKeyLink)
    App.connect(checkButton.MouseButton1Click, function() App.validateKey(keyBox.Text, false) end)
    App.connect(previewButton.MouseButton1Click, App.preview.open)
    App.connect(keyBox.FocusLost, function(enterPressed)
        if enterPressed then App.validateKey(keyBox.Text, false) end
    end)
    local previewPanel = App.new("Frame", {
        BackgroundColor3 = App.colors.panel, BorderSizePixel = 0, Position = UDim2.fromOffset(30, 232), Size = UDim2.new(1, -60, 0, 82),
    }, login)
    App.corner(previewPanel, 7)
    App.stroke(previewPanel, App.colors.border, 1, 0.35)
    App.label(previewPanel, "Explore SanX before unlocking", UDim2.fromOffset(16, 9), UDim2.new(1, -32, 0, 28), 13, App.colors.text).Font = Enum.Font.GothamSemibold
    local description = App.label(previewPanel, "The preview mirrors the menu and its controls, but cannot alter the game.", UDim2.fromOffset(16, 36), UDim2.new(1, -32, 0, 32), 10, App.colors.textDim)
    description.TextWrapped = true
    local statusDot = App.new("Frame", {BackgroundColor3 = App.colors.textDim, BorderSizePixel = 0, Position = UDim2.fromOffset(31, 335), Size = UDim2.fromOffset(8, 8)}, login)
    App.corner(statusDot, 4)
    App.statusDot = statusDot
    App.statusLabel = App.label(login, "Preparing secure access...", UDim2.fromOffset(48, 324), UDim2.new(1, -150, 0, 30), 10, App.colors.textDim)
    App.label(login, App.version, UDim2.new(1, -98, 0, 324), UDim2.fromOffset(68, 30), 9, App.colors.textDim, Enum.TextXAlignment.Right)
    App.tween(login, 0.24, {Position = UDim2.new(0.5, 0, 0.5, 0)}, Enum.EasingStyle.Sine)
end

BootEnvironment.SCRIPT_KEY = nil
App.buildLogin()

task.spawn(function()
    App.loadSdk()
end)

-- Jnkie UI-Source remains alive while the primary key gate is open.
while App.screen and App.screen.Parent and not App.authorized do
    task.wait(0.1)
end

if not App.authorized then return end
App.sdk = nil
App.previewData = nil
App.destroy()
App = nil

end

-- Intentionally end without return or another public loadstring. Jnkie's
-- active wrapper reads SCRIPT_KEY and continues into Original Code from here.

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/9e4cc35dac336cec1b07abfc42daa58a021bf0fd50780d1eea5af3beb736bc32?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end