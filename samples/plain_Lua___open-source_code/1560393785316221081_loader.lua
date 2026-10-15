repeat task.wait() until game:IsLoaded()

local sdk
for _ = 1, 3 do
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)
    if ok and type(lib) == "table" then
        sdk = lib
        break
    end
    task.wait(1)
end
sdk = sdk or {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local me = Players.LocalPlayer

local function new(class, props, kids)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if kids then
        for _, kid in pairs(kids) do
            kid.Parent = obj
        end
    end
    return obj
end

local function tween(obj, props, dur, ease, dir)
    local info = TweenInfo.new(
        dur or 0.3,
        ease or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local spgame = {
    ["Rivals"] = {id = "f734cbc6d30b72abe044a3fb60543345", keyless = false},
    ["Flick"] = {id = "9a65bec4c321b3f25f47a860831e9b2d", keyless = false},
    ["SailorPiece"] = {id = "66387fa15569b822d2ea55a5faabe87c", keyless = false},
    ["SlimeRNG"] = {id = "7a8b76f35bce8a800da3cd7aad830bcd", keyless = false},
    ["TypeSoul"] = {id = "5f6af3cb21fee478aa17493db9e1853b", keyless = false},
    ["Violence District"] = {id = "b788ceefa4a0c32bd78003c2d3618109", keyless = false},
    ["99 Nights in the Forest"] = {id = "5608e43c201375a9258c222f324abfa1", keyless = false},
    ["Universal"] = {id = "18fa0aa2984290b5582813fe581dd4cf", keyless = false}
}

local function detectGame()
    local pid = game.PlaceId
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(pid)
    end)
    local gameName = ok and type(info) == "table" and tostring(info.Name) or ""

    if gameName:upper():find("RIVALS") then
        return "Rivals"
    end
    if pid == 17625359962 or pid == 18126510175 or pid == 71874690745115 or pid == 117398147513099 or pid == 129604661913557 then
        return "Rivals"
    elseif pid == 136801880565837 or pid == 4902182837 then
        return "Flick"
    elseif pid == 77747658251236 or pid == 123955125827131 or pid == 75159314259063
        or pid == 99684056491472 or pid == 96767841099256 or pid == 138368689293913
        or pid == 130167267952199 or pid == 98826438856089 or pid == 75982168454032 then
        return "SailorPiece"
    elseif pid == 92416421522960 then
        return "SlimeRNG"
    elseif pid == 130996985148664 or pid == 18567652860 or pid == 14069122388
        or pid == 14069678431 or pid == 14069956183 or pid == 14070029709
        or pid == 14067600077 or pid == 14067606919 or pid == 14069866342
        or pid == 16845411199 or pid == 18413381799 or pid == 14071822972
        or pid == 99658992953850 or pid == 14282768170 or pid == 15126191380
        or pid == 15176590855 or pid == 15214773359 or pid == 15336080245
        or pid == 16787374647 or pid == 17078737609 or pid == 16722271122
        or pid == 16883972004 or pid == 16883976493 or pid == 16795663529
        or pid == 17206327946 or pid == 18363155549 or pid == 18301446679
        or pid == 88570549485653 or pid == 18214402201 or pid == 17497925847
        or pid == 85663041002311 or pid == 126276657485357 or pid == 116052447681870
        or pid == 79007765026427 or pid == 121766282797354 or pid == 115509275831248
        or pid == 108123877604820 or pid == 122291183918016 or pid == 138059541435332 or pid == 18637069183 then
        return "TypeSoul"
    elseif pid == 93978595733734 then
        return "Violence District"
    elseif pid == 79546208627805 or pid == 126371807511901 or pid == 126509999114328 then
        return "99 Nights in the Forest"
    end
    return "Default"
end

local gameName = detectGame()
local currentGame = spgame[gameName]
local scriptId = currentGame.id
local isKeyless = currentGame.keyless == true
sdk.script_id = scriptId

local actorRun = rawget(getfenv(0), "run_on_actor")
local actorGet = rawget(getfenv(0), "getactors") or rawget(getfenv(0), "get_actors")
local hasActors = typeof(actorRun) == "function" and typeof(actorGet) == "function"

local function findActor()
    if not hasActors then return nil end
    local ok, list = pcall(actorGet)
    if not ok or type(list) ~= "table" then return nil end
    for _, a in ipairs(list) do
        if typeof(a) == "Instance" and a:IsA("Actor") and a.Parent then
            return a
        end
    end
    return nil
end

local function runOnActor(src, key)
    if not src or src == "" then return false, "empty source" end
    local actor = findActor()
    if not actor then return false, "no actor" end
    local wrapper = [[
        local src, key = ...
        if key and key ~= "" then
            pcall(function() getgenv().script_key = key end)
        end
        pcall(function()
            local chunk = loadstring(src)
            if chunk then chunk() end
        end)
    ]]
    local ok, err = pcall(function()
        actorRun(actor, wrapper, src, key or "")
    end)
    if ok then return true end
    return false, tostring(err)
end

local function fetchSource(hash)
    if not hash or hash == "" then return nil, "empty hash" end
    local url = "https://api.luarmor.net/files/v3/loaders/" .. tostring(hash) .. ".lua"
    local ok, src = pcall(function() return game:HttpGet(url) end)
    if ok and type(src) == "string" and #src > 0 then
        return src
    end
    return nil, tostring(src)
end

local function withKey(src, key)
    if not key or key == "" then return src end
    return string.format("script_key = %q\npcall(function() getgenv().script_key = script_key end)\n", key) .. src
end

local function loadScript(key)
    local hash = scriptId
    local src = fetchSource(hash)
    if src then
        src = withKey(src, key)
        local actorOk = runOnActor(src, key)
        if actorOk then return true end

        if key and key ~= "" then
            pcall(function() getgenv().script_key = key end)
        end
        local directOk = pcall(function()
            local chunk = loadstring(src)
            if chunk then chunk() end
        end)
        if directOk then return true end
    end

    local ok = pcall(function()
        if type(sdk.load_script) == "function" then sdk.load_script() end
    end)
    return ok
end

local statusCache = {}

local function checkKeyStatus(key)
    local cached = statusCache[key]
    if cached then
        while cached.pending do task.wait(0.05) end
        if cached.status and os.clock() - cached.time < 30 then
            return cached.status
        end
    end

    local entry = {pending = true}
    statusCache[key] = entry
    local result
    for _ = 1, 3 do
        local ok, status = pcall(function() return sdk.check_key(key) end)
        if ok and type(status) == "table" and type(status.code) == "string" then
            result = status
            break
        end
        task.wait(1)
    end
    entry.status = result
    entry.time = os.clock()
    entry.pending = false
    return result
end

local kfolder = "KEY"
local kfile = kfolder .. "/key.txt"

local function hasFileApi()
    return typeof(isfile) == "function"
        and typeof(readfile) == "function"
        and typeof(writefile) == "function"
        and typeof(isfolder) == "function"
        and typeof(makefolder) == "function"
end

local function ensureKeyFolder()
    if not hasFileApi() then return end
    pcall(function()
        if not isfolder(kfolder) then makefolder(kfolder) end
    end)
end

local function saveKey(key)
    if not hasFileApi() or not key or key == "" then return end
    pcall(function()
        ensureKeyFolder()
        writefile(kfile, key)
    end)
end

local function loadSavedKey()
    if not hasFileApi() then return nil end
    local ok, content = pcall(function()
        if isfile(kfile) then return readfile(kfile) end
        return nil
    end)
    if ok and content then
        local trimmed = content:gsub("%s+", "")
        if trimmed ~= "" then return trimmed end
    end
    return nil
end

local function deleteSavedKey()
    if not hasFileApi() then return end
    pcall(function()
        if isfile(kfile) and typeof(delfile) == "function" then
            delfile(kfile)
        end
    end)
end

ensureKeyFolder()

local function runKeyless()
    getgenv().script_key = nil
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. scriptId .. ".lua"))()
end

local Theme = {
    Background = Color3.fromRGB(16, 10, 22),
    Sidebar = Color3.fromRGB(23, 13, 32),
    Border = Color3.fromRGB(52, 32, 72),
    Accent = Color3.fromRGB(232, 106, 23),
    AccentHover = Color3.fromRGB(255, 132, 40),
    AccentGlow = Color3.fromRGB(255, 150, 50),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(205, 185, 220),
    Placeholder = Color3.fromRGB(165, 145, 185),
    Input = Color3.fromRGB(26, 16, 37),
    InputFocus = Color3.fromRGB(36, 22, 52),
    ElementBorder = Color3.fromRGB(72, 40, 98),
    Dialog = Color3.fromRGB(62, 30, 86),
    TitleBarLine = Color3.fromRGB(56, 34, 78),
    Error = Color3.fromRGB(255, 70, 40),
    Web = Color3.fromRGB(215, 205, 235),
    Spider = Color3.fromRGB(30, 18, 40)
}

local isMobile = UserInputService.TouchEnabled
local FONT = Enum.Font.BuilderSansMedium
local FONT_BOLD = Enum.Font.BuilderSansBold
local FONT_TITLE = Enum.Font.Creepster
local MAIN_SIZE = isMobile and UDim2.new(0, 420, 0, 250) or UDim2.new(0, 600, 0, 350)
local SHADOW_SIZE = isMobile and UDim2.new(0, 420, 0, 250) or UDim2.new(0, 600, 0, 350)
local SUCCESS_SIZE = isMobile and UDim2.new(0, 360, 0, 260) or UDim2.new(0, 520, 0, 360)
local SIDEBAR_WIDTH = isMobile and 120 or 170
local pad = isMobile and 16 or 32
local btnHeight = isMobile and 30 or 40
local RADIUS = UDim.new(0, 4)

local yKey = isMobile and 78 or 136
local yLogin = isMobile and 116 or 188
local yRow = isMobile and 154 or 240

local function typeText(label, fullText, baseDelay)
    local delay = baseDelay or 0.035
    for i = 1, #fullText do
        if not label or not label.Parent then return end
        label.Text = string.sub(fullText, 1, i)
        local c = string.sub(fullText, i, i)
        if c == " " then
            task.wait(delay * 0.5)
        elseif c == "," or c == "." then
            task.wait(delay * 2.5)
        else
            task.wait(delay + (math.random() * 0.012))
        end
    end
end

local function notify(title, msg, time)
    local screen = CoreGui:FindFirstChild("PhantomLoader")
    if not screen then return end

    local container = screen:FindFirstChild("NotifContainer")
    if not container then
        container = new("Frame", {
            Name = "NotifContainer",
            Parent = screen,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 300, 1, 0),
            AnchorPoint = Vector2.new(1, 1)
        }, {
            new("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 8)
            })
        })
    end

    local duration = time or 3

    local card = new("Frame", {
        Parent = container,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundTransparency = 0.3
    }, {
        new("UICorner", {CornerRadius = UDim.new(0, 4)}),
        new("UIStroke", {Color = Theme.Border, Thickness = 1, Transparency = 0.5}),
        new("Frame", {
            Name = "TimerBar",
            BackgroundColor3 = Theme.AccentGlow,
            BackgroundTransparency = 0.75,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            BorderSizePixel = 0
        }),
        new("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 10),
            Size = UDim2.new(1, -26, 0, 20),
            Font = FONT_BOLD,
            Text = title or "Notification",
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1
        }),
        new("TextLabel", {
            Name = "Desc",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 28),
            Size = UDim2.new(1, -26, 0, 20),
            Font = FONT,
            Text = msg or "",
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1
        })
    })

    tween(card, {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Exponential)

    local titleLabel = card:FindFirstChild("Title")
    local descLabel = card:FindFirstChild("Desc")
    local accentBar = card:FindFirstChild("AccentBar")
    local timerBar = card:FindFirstChild("TimerBar")
    local stroke = card:FindFirstChild("UIStroke")

    task.delay(0.15, function()
        if titleLabel and titleLabel.Parent then
            tween(titleLabel, {TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
        end
    end)
    task.delay(0.22, function()
        if descLabel and descLabel.Parent then
            tween(descLabel, {TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
        end
    end)
    task.delay(0.1, function()
        if accentBar and accentBar.Parent then
            tween(accentBar, {Size = UDim2.new(0, 3, 1, 0)}, 0.6, Enum.EasingStyle.Exponential)
        end
    end)
    if stroke then
        tween(stroke, {Transparency = 0}, 0.4, Enum.EasingStyle.Exponential)
    end

    task.delay(0.4, function()
        if timerBar and timerBar.Parent then
            local info = TweenInfo.new(duration - 0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            TweenService:Create(timerBar, info, {Size = UDim2.new(0, 0, 0, 2)}):Play()
        end
    end)

    task.delay(duration, function()
        if card and card.Parent then
            if titleLabel and titleLabel.Parent then
                tween(titleLabel, {TextTransparency = 1}, 0.2)
            end
            if descLabel and descLabel.Parent then
                tween(descLabel, {TextTransparency = 1}, 0.2)
            end
            if accentBar and accentBar.Parent then
                tween(accentBar, {Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1}, 0.25)
            end

            task.wait(0.12)

            if card and card.Parent then
                tween(card, {BackgroundTransparency = 1}, 0.2)
                if stroke and stroke.Parent then
                    tween(stroke, {Transparency = 1}, 0.2)
                end

                task.wait(0.1)

                if card and card.Parent then
                    tween(card, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Exponential)
                    task.wait(0.35)
                    if card and card.Parent then
                        card:Destroy()
                    end
                end
            end
        end
    end)
end

if CoreGui:FindFirstChild("PhantomLoader") then
    CoreGui.PhantomLoader:Destroy()
end

local screenGui = new("ScreenGui", {
    Name = "PhantomLoader",
    Parent = CoreGui
})

local shadow = new("Frame", {
    Name = "Shadow",
    Parent = screenGui,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 0.5, 6),
    Size = MAIN_SIZE,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BorderSizePixel = 0,
    ZIndex = 0
}, {
    new("UICorner", {CornerRadius = UDim.new(0, 8)})
})

local mainFrame = new("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    BackgroundColor3 = Theme.Background,
    Position = UDim2.new(0.5, 0, 0.5, 20),
    Size = UDim2.new(0, 0, 0, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    ZIndex = 1
}, {
    new("UICorner", {CornerRadius = UDim.new(0, 6)}),
    new("UIStroke", {Color = Theme.Border, Thickness = 1, Transparency = 1}),
    new("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 165, 190))
    })
})

local sidebar = new("Frame", {
    Name = "Sidebar",
    Parent = mainFrame,
    BackgroundColor3 = Theme.Sidebar,
    Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
    BorderSizePixel = 0,
    BackgroundTransparency = 1
}, {
    new("UICorner", {CornerRadius = UDim.new(0, 6)}),
    new("Frame", {
        Name = "Filler",
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(1, -6, 0, 0),
        Size = UDim2.new(0, 6, 1, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }),
    new("Frame", {
        Name = "Divider",
        BackgroundColor3 = Theme.TitleBarLine,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 2
    })
})

local avatarContainer = new("Frame", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, isMobile and 12 or 26),
    Size = UDim2.new(1, 0, 0, isMobile and 36 or 56)
}, {
    new("ImageLabel", {
        Name = "Avatar",
        BackgroundTransparency = 1,
        Position = isMobile and UDim2.new(0.5, -18, 0, 0) or UDim2.new(0.5, -28, 0, 0),
        Size = isMobile and UDim2.new(0, 36, 0, 36) or UDim2.new(0, 56, 0, 56),
        Image = "rbxassetid://0",
        ImageTransparency = 1
    }, {
        new("UICorner", {CornerRadius = UDim.new(1, 0)}),
        new("UIStroke", {Color = Theme.Accent, Thickness = 2, Transparency = 1})
    })
})

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(
            me.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size420x420
        )
    end)
    if ok then avatarContainer.Avatar.Image = thumb end
end)

local content = new("Frame", {
    Parent = mainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0),
    Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0)
})

local titleLabel = new("TextLabel", {
    Name = "TitleLabel",
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, pad, 0, isMobile and 14 or 40),
    Size = UDim2.new(1, -pad * 2, 0, isMobile and 22 or 30),
    Font = FONT_TITLE,
    Text = "",
    TextColor3 = Theme.Text,
    TextSize = isMobile and 22 or 32,
    TextXAlignment = Enum.TextXAlignment.Left
})

local welcomeLabel = new("TextLabel", {
    Name = "WelcomeLabel",
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, pad, 0, isMobile and 37 or 72),
    Size = UDim2.new(1, -pad * 2, 0, 18),
    Font = FONT,
    Text = "",
    TextColor3 = Theme.Muted,
    TextSize = isMobile and 12 or 15,
    TextXAlignment = Enum.TextXAlignment.Left
})

local function smallText(text, y, size)
    return new("TextLabel", {
        Parent = content,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, pad, 0, y),
        Size = UDim2.new(1, -pad * 2, 0, 14),
        Font = FONT_BOLD,
        Text = text,
        TextColor3 = Theme.Placeholder,
        TextSize = size,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })
end

local keyCaption = smallText("LICENSE KEY", yKey - (isMobile and 15 or 19), isMobile and 10 or 12)
local footerLabel = smallText("Your key is saved after the first check", isMobile and 226 or 318, isMobile and 10 or 12)
footerLabel.Font = FONT

local function buildInput(placeholder, yPos, isPassword)
    local container = new("Frame", {
        Parent = content,
        BackgroundColor3 = Theme.Input,
        Position = UDim2.new(0, pad, 0, yPos),
        Size = UDim2.new(1, -pad * 2, 0, btnHeight),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }, {
        new("UICorner", {CornerRadius = RADIUS}),
        new("UIStroke", {Color = Theme.ElementBorder, Thickness = 1, Transparency = 1})
    })

    local input = new("TextBox", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, isPassword and -54 or -24, 1, 0),
        Font = FONT,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.Placeholder,
        TextColor3 = Theme.Text,
        TextSize = isMobile and 11 or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })

    local mask
    if isPassword then
        mask = new("TextLabel", {
            Parent = container,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -54, 1, 0),
            Font = FONT_BOLD,
            Text = "",
            TextColor3 = Theme.Text,
            TextSize = isMobile and 12 or 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })
        input.TextTransparency = 1
        input:GetPropertyChangedSignal("Text"):Connect(function()
            mask.Text = string.rep("\226\128\162", #input.Text)
        end)
    end

    input.Focused:Connect(function()
        tween(container, {BackgroundColor3 = Theme.InputFocus}, 0.25, Enum.EasingStyle.Exponential)
    end)
    input.FocusLost:Connect(function()
        tween(container, {BackgroundColor3 = Theme.Input}, 0.35, Enum.EasingStyle.Exponential)
    end)

    return input, container, mask
end

local keyInput, keyInputContainer, keyMask = buildInput("Enter your key", yKey, true)

local function showKey(visible)
    keyInput.TextTransparency = visible and 0 or 1
    if keyMask then keyMask.TextTransparency = visible and 1 or 0 end
end

local EYE_CLOSED = "rbxassetid://83952363468155"
local EYE_OPEN = "rbxassetid://111787823887334"

local eyeBtn = new("ImageButton", {
    Parent = keyInputContainer,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -36, 0.5, 0),
    Size = UDim2.new(0, 20, 0, 20),
    AnchorPoint = Vector2.new(0, 0.5),
    Image = EYE_CLOSED,
    ImageColor3 = Theme.Accent,
    ImageTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    AutoButtonColor = false,
    ZIndex = 3
})

eyeBtn.MouseEnter:Connect(function()
    tween(eyeBtn, {ImageColor3 = Theme.AccentGlow}, 0.2, Enum.EasingStyle.Exponential)
end)
eyeBtn.MouseLeave:Connect(function()
    tween(eyeBtn, {ImageColor3 = Theme.Accent}, 0.2, Enum.EasingStyle.Exponential)
end)

local keyVisible = false
eyeBtn.MouseButton1Click:Connect(function()
    keyVisible = not keyVisible
    showKey(keyVisible)
    eyeBtn.Image = keyVisible and EYE_OPEN or EYE_CLOSED
end)

local function buildButton(text, yPos, isPrimary, side)
    local pos = UDim2.new(0, pad, 0, yPos)
    local size = UDim2.new(1, -pad * 2, 0, btnHeight)
    if side == "left" then
        size = UDim2.new(0.5, -pad - 5, 0, btnHeight)
    elseif side == "right" then
        pos = UDim2.new(0.5, 5, 0, yPos)
        size = UDim2.new(0.5, -pad - 5, 0, btnHeight)
    end
    local btn = new("TextButton", {
        Parent = content,
        BackgroundColor3 = isPrimary and Theme.Accent or Theme.Input,
        Position = pos,
        Size = size,
        AutoButtonColor = false,
        Text = text,
        Font = FONT_BOLD,
        TextColor3 = Theme.Text,
        TextSize = isMobile and 12 or 15,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        ClipsDescendants = true
    }, {
        new("UICorner", {CornerRadius = RADIUS}),
        not isPrimary and new("UIStroke", {Color = Theme.ElementBorder, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) or nil
    })

    btn.MouseEnter:Connect(function()
        if isPrimary then
            tween(btn, {BackgroundTransparency = 0.15}, 0.2, Enum.EasingStyle.Exponential)
        else
            tween(btn, {BackgroundColor3 = Theme.InputFocus}, 0.2, Enum.EasingStyle.Exponential)
        end
    end)

    btn.MouseLeave:Connect(function()
        if isPrimary then
            tween(btn, {BackgroundTransparency = 0}, 0.25, Enum.EasingStyle.Exponential)
        else
            tween(btn, {BackgroundColor3 = Theme.Input}, 0.25, Enum.EasingStyle.Exponential)
        end
    end)

    return btn
end

local loginBtn = buildButton("Check Key", yLogin, true)
local getKeyBtn = buildButton("Get Free Key (Click me) ", yRow, false, "left")
local buyBtn = buildButton("Buy Premium (Click me)", yRow, false, "right")

local scanBar = new("Frame", {
    Name = "ScanBar",
    Parent = loginBtn,
    BackgroundColor3 = Theme.AccentGlow,
    BackgroundTransparency = 1,
    Position = UDim2.new(-0.3, 0, 0, 0),
    Size = UDim2.new(0.3, 0, 1, 0),
    BorderSizePixel = 0,
    ZIndex = 2
}, {
    new("UICorner", {CornerRadius = RADIUS})
})

local discordBtn = new("TextButton", {
    Parent = sidebar,
    BackgroundColor3 = Theme.Dialog,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, isMobile and 8 or 12, 1, isMobile and -34 or -44),
    Size = UDim2.new(1, isMobile and -16 or -24, 0, isMobile and 26 or 32),
    Text = "Join Our Discord",
    Font = FONT_BOLD,
    TextColor3 = Theme.Text,
    TextSize = isMobile and 11 or 14,
    AutoButtonColor = false,
    TextTransparency = 1
}, {
    new("UICorner", {CornerRadius = RADIUS})
})

local function getExecutor()
    if typeof(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and name then
            local clean = tostring(name):gsub("%s*[vV]?%d[%w%.%-]*$", "")
            if clean ~= "" then return clean end
        end
    end
    return "Unknown"
end

local sideInfo = new("CanvasGroup", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    GroupTransparency = 1
})

local function sideText(text, y, height, font, size, color)
    return new("TextLabel", {
        Parent = sideInfo,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, y),
        Size = UDim2.new(1, -16, 0, height),
        Font = font,
        Text = text,
        TextColor3 = color,
        TextSize = size,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
end

sideText(me.DisplayName, isMobile and 52 or 90, isMobile and 15 or 20, FONT_BOLD, isMobile and 13 or 17, Theme.Text)
sideText("@" .. me.Name, isMobile and 67 or 110, isMobile and 12 or 16, FONT, isMobile and 10 or 13, Theme.Placeholder)

local rowHeight = isMobile and 20 or 28
local infoCard = new("Frame", {
    Parent = sideInfo,
    BackgroundColor3 = Theme.Input,
    Position = UDim2.new(0, isMobile and 8 or 12, 0, isMobile and 88 or 140),
    Size = UDim2.new(1, isMobile and -16 or -24, 0, rowHeight * 3),
    BorderSizePixel = 0
}, {
    new("UICorner", {CornerRadius = RADIUS}),
    new("UIStroke", {Color = Theme.ElementBorder, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
})

local function infoRow(index, name, value)
    local row = new("Frame", {
        Parent = infoCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, (index - 1) * rowHeight),
        Size = UDim2.new(1, 0, 0, rowHeight)
    })
    new("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(0.5, -8, 1, 0),
        Font = FONT_TITLE,
        Text = name,
        TextColor3 = Theme.Muted,
        TextSize = isMobile and 12 or 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return new("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.4, 0, 0, 0),
        Size = UDim2.new(0.6, -8, 1, 0),
        Font = FONT_BOLD,
        Text = value,
        TextColor3 = Theme.AccentGlow,
        TextSize = isMobile and 10 or 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
end

infoRow(1, "Executor", getExecutor())
local keyTimeLabel = infoRow(2, "Time Left", "--")
infoRow(3, "Game", gameName == "Default" and "Universal" or tostring(gameName))
local function setTimeLeft(value)
    keyTimeLabel.Text = value
end

local function formatLeft(sec)
    if sec <= 0 then return "Expired" end
    local d = math.floor(sec / 86400)
    local h = math.floor(sec % 86400 / 3600)
    local m = math.floor(sec % 3600 / 60)
    if d > 0 then return d .. "d " .. h .. "h" end
    if h > 0 then return h .. "h " .. m .. "m" end
    return math.max(1, m) .. "m"
end

local function setKeyTime(status)
    local data = type(status) == "table" and status.data
    local expire = type(data) == "table" and tonumber(data.auth_expire)
    if not expire then
        setTimeLeft("--")
    elseif expire <= 0 then
        setTimeLeft("Lifetime")
    else
        setTimeLeft(formatLeft(expire - os.time()))
    end
end

local StatusMessages = {
    KEY_VALID = "Key Validated! Loading...",
    KEY_EXPIRED = "Your Key is expired, get a new one",
    KEY_BANNED = "Your banned\u{1F973}",
    KEY_HWID_LOCKED = "HWID Locked! Reset in Discord",
    KEY_INCORRECT = "Incorect Key version, make sure you copied it right",
    KEY_INVALID = "Invalid Key",
    INVALID_EXECUTOR = "Wtf is that Executor, We dont support it",
    SECURITY_ERROR = "111 Error, Report in Discord",
    TIME_ERROR = "234 Error, Report in Discord",
    UNKNOWN_ERROR = "228 Error, Report in Discord"
}

local halloweenDecor = new("Frame", {
    Name = "HalloweenDecor",
    Parent = mainFrame,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Visible = false
})

local function decorLine(ax, ay, x1, y1, x2, y2, transparency)
    local dx, dy = x2 - x1, y2 - y1
    return new("Frame", {
        Parent = halloweenDecor,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(ax, (x1 + x2) / 2, ay, (y1 + y2) / 2),
        Size = UDim2.new(0, math.sqrt(dx * dx + dy * dy), 0, 1),
        Rotation = math.deg(math.atan2(dy, dx)),
        BackgroundColor3 = Theme.Web,
        BackgroundTransparency = transparency or 0.72,
        BorderSizePixel = 0
    })
end

local function cobweb(ax, ay, sx, sy, radius)
    local spokes = {}
    for i = 0, 4 do
        local a = math.rad(6 + i * 19.5)
        local ux, uy = math.cos(a) * sx, math.sin(a) * sy
        decorLine(ax, ay, 0, 0, ux * radius, uy * radius)
        spokes[i] = {ux, uy}
    end
    for _, f in ipairs({0.35, 0.6, 0.85}) do
        local r = radius * f
        for i = 0, 3 do
            local p, q = spokes[i], spokes[i + 1]
            decorLine(ax, ay, p[1] * r, p[2] * r, q[1] * r, q[2] * r, 0.78)
        end
    end
end

cobweb(1, 0, -1, 1, isMobile and 45 or 70)

local function swing(pivot, angle, period)
    pivot.Rotation = -angle
    TweenService:Create(pivot, TweenInfo.new(period, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = angle}):Play()
end

do
    local len = isMobile and 30 or 46
    local pivot = new("Frame", {
        Parent = halloweenDecor,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, isMobile and -26 or -40, 0, isMobile and 14 or 22),
        Size = UDim2.new(0, 30, 0, len * 2)
    })
    new("Frame", {
        Parent = pivot,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 1, 0, len),
        BackgroundColor3 = Theme.Web,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0
    })
    local body = new("Frame", {
        Parent = pivot,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, len + 4),
        Size = UDim2.new(0, 12, 0, 14),
        BackgroundColor3 = Theme.Spider,
        BorderSizePixel = 0
    }, {
        new("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    new("Frame", {
        Parent = pivot,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, len - 3),
        Size = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Theme.Spider,
        BorderSizePixel = 0
    }, {
        new("UICorner", {CornerRadius = UDim.new(1, 0)}),
        new("Frame", {Position = UDim2.new(0.5, -3, 0, 4), Size = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Theme.AccentGlow, BorderSizePixel = 0}),
        new("Frame", {Position = UDim2.new(0.5, 1, 0, 4), Size = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Theme.AccentGlow, BorderSizePixel = 0})
    })
    for _, side in ipairs({-1, 1}) do
        for i = 1, 3 do
            new("Frame", {
                Parent = body,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, side * 8, 0, 2 + i * 3),
                Size = UDim2.new(0, 10, 0, 1),
                Rotation = side * (i - 2) * 28,
                BackgroundColor3 = Theme.Spider,
                BorderSizePixel = 0
            })
        end
    end
    swing(pivot, 9, 2.2)
end

discordBtn.MouseEnter:Connect(function()
    tween(discordBtn, {BackgroundTransparency = 0.2}, 0.25, Enum.EasingStyle.Exponential)
end)
discordBtn.MouseLeave:Connect(function()
    tween(discordBtn, {BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Exponential)
end)

local function openDiscord()
    if setclipboard then
        setclipboard("https://discord.gg/6S7gHAPg3A")
    end
    notify("Discord", "Invite link copied to clipboard", 5)
    pcall(function()
        local inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()
        inviter.Join("https://discord.gg/6S7gHAPg3A")
    end)
end

discordBtn.MouseButton1Click:Connect(openDiscord)

local function openUrl(url)
    if setclipboard then
        setclipboard(url)
    end

    local opened = false

    if type(openBrowser) == "function" then
        pcall(function() openBrowser(url); opened = true end)
    elseif type(open_browser) == "function" then
        pcall(function() open_browser(url); opened = true end)
    end

    if not opened then
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(url)
            opened = true
        end)
    end

    if not opened and type(os) == "table" and type(os.execute) == "function" then
        pcall(function()
            os.execute('start "" "' .. url .. '"')
            opened = true
        end)
    end
end

buyBtn.MouseButton1Click:Connect(function()
    openUrl("https://phantomarket.org")
    notify("Premium Shop", "Shop link copied. Paste it in your browser", 5)
end)

getKeyBtn.MouseButton1Click:Connect(function()
    openUrl("https://ads.luarmor.net/get_key?for=Checkpoints_Linkvertise-HSVJWPYAuoAP")
    notify("Key System", "Key link copied. Paste it in your browser", 5)
end)

local authInProgress = false

local function finishAndLoad(run)
    if scanBar and scanBar.Parent then
        tween(scanBar, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.7}, 0.3, Enum.EasingStyle.Exponential)
        task.wait(0.2)
        tween(scanBar, {BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Exponential)
    end

    local stroke = mainFrame:FindFirstChild("UIStroke")

    task.wait(0.4)

    for _, child in pairs(mainFrame:GetDescendants()) do
        pcall(function()
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                tween(child, {TextTransparency = 1}, 0.35, Enum.EasingStyle.Exponential)
            end
            if child:IsA("ImageLabel") then
                tween(child, {ImageTransparency = 1}, 0.35, Enum.EasingStyle.Exponential)
            end
            if child:IsA("Frame") or child:IsA("TextButton") then
                tween(child, {BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Exponential)
            end
            if child:IsA("UIStroke") then
                tween(child, {Transparency = 1}, 0.35, Enum.EasingStyle.Exponential)
            end
        end)
    end

    task.wait(0.2)

    tween(mainFrame, {
        Size = SUCCESS_SIZE,
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Exponential)
    tween(shadow, {BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Exponential)
    if stroke then
        tween(stroke, {Transparency = 1}, 0.4, Enum.EasingStyle.Exponential)
    end

    task.wait(0.55)
    screenGui:Destroy()
    run()
end

local function checkKey(key, isAuto)
    if authInProgress then return end
    if not key or key == "" then
        notify("Warning", "Key is required", 2)
        return
    end
    authInProgress = true

    loginBtn.Text = "Authenticating..."

    local scanActive = true
    task.spawn(function()
        scanBar.BackgroundTransparency = 0.82
        while scanActive do
            if scanBar and scanBar.Parent then
                scanBar.Position = UDim2.new(-0.3, 0, 0, 0)
                local info = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                local sweep = TweenService:Create(scanBar, info, {Position = UDim2.new(1, 0, 0, 0)})
                sweep:Play()
                sweep.Completed:Wait()
                task.wait(0.15)
            else
                break
            end
        end
        if scanBar and scanBar.Parent then
            scanBar.BackgroundTransparency = 1
        end
    end)

    task.spawn(function()
        local status = checkKeyStatus(key)
        scanActive = false

        if not status then
            loginBtn.Text = "Check Key"
            if scanBar and scanBar.Parent then
                scanBar.BackgroundTransparency = 1
            end
            tween(loginBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent}, 0.2)
            notify("Connection Error", "Could not reach the key server. Try again.", 4)
            authInProgress = false
            return
        end

        if status.code == "KEY_VALID" then
            getgenv().script_key = key
            saveKey(key)
            setKeyTime(status)
            notify("Success", StatusMessages.KEY_VALID, 3)
            finishAndLoad(function() loadScript(key) end)
        else
            loginBtn.Text = "Check Key"
            if scanBar and scanBar.Parent then
                scanBar.BackgroundTransparency = 1
            end
            tween(loginBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent}, 0.2)

            local code = status.code
            local expired = code == "KEY_EXPIRED"
            if expired then
                setTimeLeft("Expired")
            end
            if isAuto or expired then
                deleteSavedKey()
            end
            notify(isAuto and "Saved Key" or "Auth Error", StatusMessages[code] or StatusMessages.UNKNOWN_ERROR, 4)
            authInProgress = false
        end
    end)
end

loginBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text:gsub("%s+", "")
    checkKey(key, false)
end)

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local x = startPos.X.Offset + delta.X
            local y = startPos.Y.Offset + delta.Y
            tween(frame, {
                Position = UDim2.new(startPos.X.Scale, x, startPos.Y.Scale, y)
            }, 0.06, Enum.EasingStyle.Sine)
            tween(shadow, {
                Position = UDim2.new(startPos.X.Scale, x, startPos.Y.Scale, y + 6)
            }, 0.08, Enum.EasingStyle.Sine)
        end
    end)
end

makeDraggable(mainFrame)

if not isKeyless then
    task.delay(0.7, function()
        local saved = loadSavedKey()
        if not saved then
            setTimeLeft("None")
            return
        end
        local status = checkKeyStatus(saved)
        if not status then return end
        if status.code == "KEY_VALID" then
            setKeyTime(status)
        elseif status.code == "KEY_EXPIRED" then
            setTimeLeft("Expired")
        else
            setTimeLeft("None")
        end
    end)
end

if isKeyless then
    authInProgress = true
    setTimeLeft("Keyless")
    task.spawn(function()
        task.wait(0.8)
        notify("Keyless", gameName .. " is Keyless for a Week", 3)
        loginBtn.Text = "Loading..."
        task.wait(1.2)
        finishAndLoad(runKeyless)
    end)
end

task.spawn(function()
    tween(shadow, {BackgroundTransparency = 0.5, Position = UDim2.new(0.5, 0, 0.5, 6), Size = SHADOW_SIZE}, 0.6, Enum.EasingStyle.Exponential)

    tween(mainFrame, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Exponential)
    local mainStroke = mainFrame:FindFirstChild("UIStroke")
    if mainStroke then
        tween(mainStroke, {Transparency = 0}, 0.5, Enum.EasingStyle.Exponential)
    end
    tween(mainFrame, {Size = MAIN_SIZE}, 0.8, Enum.EasingStyle.Back)

    task.wait(0.25)

    tween(sidebar, {BackgroundTransparency = 0}, 0.45, Enum.EasingStyle.Exponential)
    local divider = sidebar:FindFirstChild("Divider")
    if divider then
        tween(divider, {BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Exponential)
    end
    local filler = sidebar:FindFirstChild("Filler")
    if filler then
        tween(filler, {BackgroundTransparency = 0}, 0.45, Enum.EasingStyle.Exponential)
    end

    task.wait(0.12)

    local avatar = avatarContainer:FindFirstChild("Avatar")
    if avatar then
        tween(avatar, {ImageTransparency = 0}, 0.45, Enum.EasingStyle.Exponential)
        local avatarStroke = avatar:FindFirstChild("UIStroke")
        if avatarStroke then
            tween(avatarStroke, {Transparency = 0}, 0.45, Enum.EasingStyle.Exponential)
        end
    end

    task.wait(0.06)

    tween(discordBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4, Enum.EasingStyle.Exponential)
    tween(sideInfo, {GroupTransparency = 0}, 0.45, Enum.EasingStyle.Exponential)
    halloweenDecor.Visible = true

    task.wait(0.18)

    typeText(titleLabel, "Phantom Softworks", 0.045)

    task.wait(0.08)

    typeText(welcomeLabel, "Enter your key to continue", 0.022)

    task.wait(0.12)

    tween(keyCaption, {TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)

    tween(keyInputContainer, {BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
    local keyStroke = keyInputContainer:FindFirstChild("UIStroke")
    if keyStroke then tween(keyStroke, {Transparency = 0}, 0.35, Enum.EasingStyle.Exponential) end
    tween(eyeBtn, {ImageTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)

    task.wait(0.12)

    tween(loginBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)

    task.spawn(function()
        task.wait(0.2)

        if isKeyless then return end

        local saved = loadSavedKey()
        if saved and saved ~= "" then
            keyInput.Text = saved
            notify("Auto Login", "Checking saved key...", 2)
            checkKey(saved, true)
        end
    end)

    task.wait(0.1)

    tween(getKeyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
    local getKeyStroke = getKeyBtn:FindFirstChild("UIStroke")
    if getKeyStroke then tween(getKeyStroke, {Transparency = 0}, 0.35, Enum.EasingStyle.Exponential) end

    task.wait(0.1)

    tween(buyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
    local buyStroke = buyBtn:FindFirstChild("UIStroke")
    if buyStroke then tween(buyStroke, {Transparency = 0}, 0.35, Enum.EasingStyle.Exponential) end

    task.wait(0.1)
    tween(footerLabel, {TextTransparency = 0}, 0.35, Enum.EasingStyle.Exponential)
end)
