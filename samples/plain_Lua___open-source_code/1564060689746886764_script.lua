-- ============================================================
-- Broxy Hub — CombatCore v3.3 (Parry-Only, Clean UI)
-- ============================================================
if getgenv().CombatCore then pcall(function() getgenv().CombatCore:Unload() end) end

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local LocalPlayer        = Players.LocalPlayer

local Remotes               = ReplicatedStorage:WaitForChild("Remotes")
local PlayerCharacter       = Remotes:WaitForChild("PlayerCharacter")
local ResolveImpact         = PlayerCharacter:WaitForChild("Request"):WaitForChild("ResolveImpact")

local Core = {
    Alive         = true,
    AutoParry     = true,
    ParryChance   = 85,
    RequireFacing = true,
    BlockInAir    = false,
    Connections   = {},
    LastParry     = 0,
    ParryCooldown = 0.35,
    StatusText    = "Idle",
    StatusColor   = Color3.fromRGB(90, 220, 140),
}
getgenv().CombatCore = Core

local GameManager, CharacterController, LocalHandler

local function refreshControllers()
    if not GameManager then
        local ok, manager = pcall(require, ReplicatedStorage:WaitForChild("GameManager", 10))
        if ok then GameManager = manager end
    end
    if GameManager then
        pcall(function()
            CharacterController = CharacterController or GameManager:GetController("CharacterController")
            if CharacterController then
                LocalHandler = LocalHandler or CharacterController:GetLocalCharacterHandler()
            end
        end)
    end
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function readFlag(h, name)
    if not h then return nil end
    local direct = h[name]
    if direct ~= nil then return direct end
    local ch = h.CharacterHandler
    if type(ch) == "table" and ch[name] ~= nil then return ch[name] end
    local st = h.State
    if type(st) == "table" and st[name] ~= nil then return st[name] end
    return nil
end

local function isCurrentlyStunned()
    local h = LocalHandler
    if not h then return false end
    local flags = {
        "IsStunned","IsPostureBroken","IsGuardBroken","IsShieldBroken",
        "IsBroken","IsStaggered","IsRecovering","IsParryStunned",
        "IsPostureBreak","IsShieldBreak",
    }
    for _, f in ipairs(flags) do
        if readFlag(h, f) == true then return true end
    end
    for _, f in ipairs({"StunEnd","RecoverEnd","PostureBreakEnd","ShieldBreakEnd"}) do
        local v = readFlag(h, f)
        if type(v) == "number" and os.clock() < v then return true end
    end
    local posture    = readFlag(h, "Posture")
    local postureMax = readFlag(h, "PostureMax") or readFlag(h, "MaxPosture")
    if type(posture) == "number" and type(postureMax) == "number" and postureMax > 0 then
        if posture / postureMax <= 0.02 then return true end
    end
    return false
end

local function canParryNow()
    if not Core.Alive then return false end
    local hum = getHumanoid()
    if not hum or hum.Health <= 0 then return false end
    if isCurrentlyStunned() then return false end
    local h = LocalHandler
    if h then
        if readFlag(h, "IsDodging")       == true then return false end
        if readFlag(h, "IsAttacking")     == true then return false end
        if readFlag(h, "IsActionLocked")  == true then return false end
        if readFlag(h, "IsCasting")       == true then return false end
        if readFlag(h, "IsUsingUltimate") == true then return false end
    end
    if not Core.BlockInAir then
        local root = getRoot()
        if root and math.abs(root.AssemblyLinearVelocity.Y) > 15 then
            return false
        end
    end
    if os.clock() - Core.LastParry < Core.ParryCooldown then return false end
    return true
end

local function impactIsIncoming(impactData, attackerPart)
    local root = getRoot()
    if not root or not attackerPart then return true end
    local toMe = root.Position - attackerPart.Position
    if toMe.Magnitude < 0.05 then return true end
    if not Core.RequireFacing then return true end
    return root.CFrame.LookVector:Dot(toMe.Unit) > 0.15
end

local function passRoll()
    return math.random(1, 100) <= Core.ParryChance
end

-- Impact hook
local resolutionHookTarget, resolutionHookOriginal, resolutionHookInstalled

local function installImpactHook()
    if resolutionHookInstalled or not Core.AutoParry then return end
    if type(hookfunction) ~= "function" or type(newcclosure) ~= "function" then return end
    if not LocalHandler then return end
    local manager = LocalHandler.ActionManager
    if not manager or type(manager._computeImpactResolution) ~= "function" then return end
    resolutionHookTarget = manager._computeImpactResolution
    local okHook, original = pcall(hookfunction, resolutionHookTarget, newcclosure(function(self, impactData)
        if not Core.Alive or not Core.AutoParry then
            return resolutionHookOriginal(self, impactData)
        end
        if isCurrentlyStunned() then
            return resolutionHookOriginal(self, impactData)
        end
        if not canParryNow() then
            return resolutionHookOriginal(self, impactData)
        end
        if not passRoll() then
            return resolutionHookOriginal(self, impactData)
        end
        local attackerPart =
            (impactData and (impactData.AttackerRoot or impactData.HitPart or impactData.SourcePart))
        if not impactIsIncoming(impactData, attackerPart) then
            return resolutionHookOriginal(self, impactData)
        end
        Core.LastParry = os.clock()
        local ch = self.CharacterHandler
        if not ch then
            return resolutionHookOriginal(self, impactData)
        end
        local pParry, pBlock = ch.IsParrying, ch.IsBlocking
        ch.IsParrying, ch.IsBlocking = true, true
        local results = table.pack(resolutionHookOriginal(self, impactData))
        ch.IsParrying, ch.IsBlocking = pParry, pBlock
        return table.unpack(results, 1, results.n)
    end))
    if okHook then
        resolutionHookOriginal  = original
        resolutionHookInstalled = true
    end
end

-- Namecall hook (parry only — Hitbox Reach removed)
local NamecallHook
if type(hookmetamethod) == "function"
   and type(getnamecallmethod) == "function"
   and type(newcclosure) == "function" then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Core.Alive and Core.AutoParry and self == ResolveImpact and method == "FireServer" then
            local args = { ... }
            if (args[2] == "Hit" or args[2] == "Block" or args[2] == "Dodge")
               and not isCurrentlyStunned()
               and canParryNow()
               and passRoll() then
                args[2] = "Parry"
                Core.LastParry = os.clock()
                return oldNamecall(self, table.unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end))
    NamecallHook = oldNamecall
end

table.insert(Core.Connections, RunService.Heartbeat:Connect(function()
    if not Core.Alive then return end
    refreshControllers()
    installImpactHook()
end))

function Core:Unload()
    self.Alive = false
    for _, conn in ipairs(self.Connections) do pcall(function() conn:Disconnect() end) end
    if NamecallHook and type(hookmetamethod) == "function" then
        pcall(hookmetamethod, game, "__namecall", NamecallHook)
    end
    if getgenv().BroxyHub then
        pcall(function() getgenv().BroxyHub:Destroy() end)
        getgenv().BroxyHub = nil
    end
    getgenv().CombatCore = nil
end
-- ============================================================
-- Broxy Hub — UI (compact, parry-only)
-- ============================================================
local function buildBroxyHub()
    local pgui = LocalPlayer:WaitForChild("PlayerGui")
    local old = getgenv().BroxyHub
    if old and old.Parent then old:Destroy() end

    local C = {
        bg      = Color3.fromRGB(13, 13, 19),
        panel   = Color3.fromRGB(22, 22, 32),
        panel2  = Color3.fromRGB(30, 30, 44),
        stroke  = Color3.fromRGB(120, 80, 220),
        accent  = Color3.fromRGB(160, 90, 255),
        accent2 = Color3.fromRGB(90, 200, 255),
        text    = Color3.fromRGB(235, 235, 245),
        textDim = Color3.fromRGB(140, 140, 160),
        on      = Color3.fromRGB(150, 90, 240),
        off     = Color3.fromRGB(48, 48, 60),
        danger  = Color3.fromRGB(230, 90, 110),
        ok      = Color3.fromRGB(90, 220, 140),
        warn    = Color3.fromRGB(255, 190, 80),
    }

    local screen = Instance.new("ScreenGui")
    screen.Name = "BroxyHub"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.IgnoreGuiInset = true
    screen.Parent = pgui
    getgenv().BroxyHub = screen

    -- Compact window — no more hiding behind top HUD
    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = UDim2.new(0, 270, 0, 250)
    win.Position = UDim2.new(0, 60, 0, 160)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.Active = true
    win.Draggable = true
    win.ClipsDescendants = true
    win.Parent = screen
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

    local winStroke = Instance.new("UIStroke", win)
    winStroke.Color = C.stroke
    winStroke.Thickness = 1.4
    winStroke.Transparency = 0.15

    -- TITLE
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 42)
    title.BackgroundColor3 = C.panel
    title.BorderSizePixel = 0
    title.Parent = win
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 14)
    local titleGrad = Instance.new("UIGradient", title)
    titleGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(42, 22, 74)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(22, 32, 60)),
    }
    titleGrad.Rotation = 20

    local logo = Instance.new("Frame")
    logo.Size = UDim2.new(0, 10, 0, 10)
    logo.Position = UDim2.new(0, 14, 0.5, -5)
    logo.BackgroundColor3 = C.accent
    logo.BorderSizePixel = 0
    logo.Parent = title
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
    local logoStroke = Instance.new("UIStroke", logo)
    logoStroke.Color = C.accent2
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.3

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -110, 0, 18)
    ttl.Position = UDim2.new(0, 30, 0, 4)
    ttl.BackgroundTransparency = 1
    ttl.Text = "BROXY HUB"
    ttl.TextColor3 = C.text
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 14
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = title

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -110, 0, 14)
    sub.Position = UDim2.new(0, 30, 0, 21)
    sub.BackgroundTransparency = 1
    sub.Text = "parry  •  v3.3"
    sub.TextColor3 = C.textDim
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = title

    local function makeIconBtn(xOffset, glyph, hoverColor)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 24)
        b.Position = UDim2.new(1, xOffset, 0.5, -12)
        b.BackgroundColor3 = C.panel2
        b.Text = glyph
        b.TextColor3 = C.text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 15
        b.AutoButtonColor = false
        b.Parent = title
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        local st = Instance.new("UIStroke", b)
        st.Color = C.stroke
        st.Thickness = 1
        st.Transparency = 0.5
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = hoverColor}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.panel2}):Play()
        end)
        return b
    end

    local btnClose = makeIconBtn(-32, "×", C.danger)
    local btnMin   = makeIconBtn(-60, "–", C.accent)

    -- CONTENT
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -54)
    content.Position = UDim2.new(0, 10, 0, 48)
    content.BackgroundTransparency = 1
    content.Parent = win

    local function section(y, text)
        local s = Instance.new("TextLabel")
        s.Size = UDim2.new(1, 0, 0, 14)
        s.Position = UDim2.new(0, 4, 0, y)
        s.BackgroundTransparency = 1
        s.Text = string.upper(text)
        s.TextColor3 = C.textDim
        s.Font = Enum.Font.GothamBold
        s.TextSize = 9
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.Parent = content
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 18, 0, 2)
        line.Position = UDim2.new(0, 4, 0, y + 12)
        line.BackgroundColor3 = C.accent
        line.BorderSizePixel = 0
        line.Parent = content
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    end

    local function makeToggle(y, label, getter, setter)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 34)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundColor3 = C.panel
        row.BorderSizePixel = 0
        row.Parent = content
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local rst = Instance.new("UIStroke", row)
        rst.Color = C.stroke
        rst.Thickness = 1
        rst.Transparency = 0.65

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -80, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local pill = Instance.new("TextButton")
        pill.Size = UDim2.new(0, 46, 0, 20)
        pill.Position = UDim2.new(1, -56, 0.5, -10)
        pill.BackgroundColor3 = getter() and C.on or C.off
        pill.Text = ""
        pill.AutoButtonColor = false
        pill.Parent = row
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 15, 0, 15)
        knob.Position = getter()
            and UDim2.new(1, -18, 0.5, -7.5)
            or  UDim2.new(0, 3, 0.5, -7.5)
        knob.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
        knob.BorderSizePixel = 0
        knob.Parent = pill
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function paint()
            local on = getter()
            TweenService:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                BackgroundColor3 = on and C.on or C.off
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                Position = on
                    and UDim2.new(1, -18, 0.5, -7.5)
                    or  UDim2.new(0, 3, 0.5, -7.5)
            }):Play()
        end

        pill.MouseButton1Click:Connect(function()
            setter(not getter())
            paint()
        end)
        return row
    end

    section(0, "Combat")
    makeToggle(18, "Auto Parry",   function() return Core.AutoParry   end, function(v) Core.AutoParry   = v end)
    makeToggle(58, "Block In Air", function() return Core.BlockInAir  end, function(v) Core.BlockInAir  = v end)

    section(102, "Parry Chance")

    local sliderWrap = Instance.new("Frame")
    sliderWrap.Size = UDim2.new(1, 0, 0, 44)
    sliderWrap.Position = UDim2.new(0, 0, 0, 120)
    sliderWrap.BackgroundColor3 = C.panel
    sliderWrap.BorderSizePixel = 0
    sliderWrap.Parent = content
    Instance.new("UICorner", sliderWrap).CornerRadius = UDim.new(0, 10)
    local sst = Instance.new("UIStroke", sliderWrap)
    sst.Color = C.stroke
    sst.Thickness = 1
    sst.Transparency = 0.65

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(1, -24, 0, 14)
    valLbl.Position = UDim2.new(0, 12, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = "Chance: " .. Core.ParryChance .. "%"
    valLbl.TextColor3 = C.text
    valLbl.Font = Enum.Font.GothamMedium
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.Parent = sliderWrap

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 10)
    barBg.Position = UDim2.new(0, 12, 0, 24)
    barBg.BackgroundColor3 = C.panel2
    barBg.BorderSizePixel = 0
    barBg.Parent = sliderWrap
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(Core.ParryChance / 100, 0, 1, 0)
    barFill.BackgroundColor3 = C.accent
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", barFill)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.accent),
        ColorSequenceKeypoint.new(1, C.accent2),
    }

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(Core.ParryChance / 100, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.Parent = barBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local kst = Instance.new("UIStroke", knob)
    kst.Color = C.accent
    kst.Thickness = 1.5

    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(rel * 100 + 0.5)
        Core.ParryChance = val
        barFill.Size   = UDim2.new(val / 100, 0, 1, 0)
        knob.Position  = UDim2.new(val / 100, -7, 0.5, -7)
        valLbl.Text    = "Chance: " .. val .. "%"
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                         or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- STATUS CHIP
    local status = Instance.new("Frame")
    status.Size = UDim2.new(1, 0, 0, 24)
    status.Position = UDim2.new(0, 0, 1, -28)
    status.BackgroundColor3 = C.panel
    status.BorderSizePixel = 0
    status.Parent = content
    Instance.new("UICorner", status).CornerRadius = UDim.new(0, 8)
    local stSt = Instance.new("UIStroke", status)
    stSt.Color = C.stroke
    stSt.Thickness = 1
    stSt.Transparency = 0.7

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 10, 0.5, -4)
    dot.BackgroundColor3 = C.ok
    dot.BorderSizePixel = 0
    dot.Parent = status
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local stTxt = Instance.new("TextLabel")
    stTxt.Size = UDim2.new(1, -30, 1, 0)
    stTxt.Position = UDim2.new(0, 24, 0, 0)
    stTxt.BackgroundTransparency = 1
    stTxt.Text = "Idle"
    stTxt.TextColor3 = C.text
    stTxt.Font = Enum.Font.GothamMedium
    stTxt.TextSize = 10
    stTxt.TextXAlignment = Enum.TextXAlignment.Left
    stTxt.Parent = status

    -- MINIMIZED ICON
    local icon = Instance.new("TextButton")
    icon.Name = "MinimizedIcon"
    icon.Size = UDim2.new(0, 46, 0, 46)
    icon.Position = UDim2.new(0, 60, 0, 160)
    icon.BackgroundColor3 = C.bg
    icon.Text = ""
    icon.AutoButtonColor = false
    icon.Visible = false
    icon.Active = true
    icon.Draggable = true
    icon.Parent = screen
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
    local ist = Instance.new("UIStroke", icon)
    ist.Color = C.accent
    ist.Thickness = 1.6

    local ih1 = Instance.new("Frame")
    ih1.Size = UDim2.new(0, 22, 0, 22)
    ih1.Position = UDim2.new(0.5, -11, 0.5, -11)
    ih1.BackgroundColor3 = C.accent2
    ih1.BackgroundTransparency = 0.8
    ih1.BorderSizePixel = 0
    ih1.Parent = icon
    Instance.new("UICorner", ih1).CornerRadius = UDim.new(1, 0)

    local ih2 = Instance.new("Frame")
    ih2.Size = UDim2.new(0, 12, 0, 12)
    ih2.Position = UDim2.new(0.5, -6, 0.5, -6)
    ih2.BackgroundColor3 = C.accent
    ih2.BorderSizePixel = 0
    ih2.Parent = icon
    Instance.new("UICorner", ih2).CornerRadius = UDim.new(1, 0)

    local iconDot = Instance.new("Frame")
    iconDot.Size = UDim2.new(0, 8, 0, 8)
    iconDot.Position = UDim2.new(1, -10, 1, -10)
    iconDot.BackgroundColor3 = C.ok
    iconDot.BorderSizePixel = 0
    iconDot.Parent = icon
    Instance.new("UICorner", iconDot).CornerRadius = UDim.new(1, 0)
    local iconDotStroke = Instance.new("UIStroke", iconDot)
    iconDotStroke.Color = C.bg
    iconDotStroke.Thickness = 2

    task.spawn(function()
        while Core.Alive and screen.Parent do
            local txt, col
            if isCurrentlyStunned() then
                txt, col = "Stunned", C.danger
            elseif os.clock() - Core.LastParry < Core.ParryCooldown then
                txt, col = "Cooldown", C.warn
            elseif Core.AutoParry then
                txt, col = "Armed", C.accent2
            else
                txt, col = "Parry Off", C.textDim
            end
            stTxt.Text = txt
            dot.BackgroundColor3 = col
            iconDot.BackgroundColor3 = col
            Core.StatusText = txt
            Core.StatusColor = col
            task.wait(0.15)
        end
    end)

    local function minimize()
        icon.Position = win.Position
        win.Visible = false
        icon.Visible = true
    end
    local function restore()
        win.Position = icon.Position
        icon.Visible = false
        win.Visible = true
    end

    btnMin.MouseButton1Click:Connect(minimize)
    icon.MouseButton1Click:Connect(restore)

    btnClose.MouseButton1Click:Connect(function()
        Core:Unload()
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            if icon.Visible then
                restore()
            else
                win.Visible = not win.Visible
            end
        end
    end)
end

buildBroxyHub()
print("[Broxy Hub v3.3] loaded — compact parry-only UI")