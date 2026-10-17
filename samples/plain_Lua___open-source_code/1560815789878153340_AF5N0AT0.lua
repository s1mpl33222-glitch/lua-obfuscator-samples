-- language: Luau, file: axon.lua, target: Roblox (PC executor)
-- AXON v16 — PATCHED: LiquidGlass theme, UI auto-centers on load
-- Original by ANON | Patches: LiquidGlass theme entry, iridescent intro bunny,
--   liquid-glass card overlay, panel AnchorPoint 0.5,0.5 + centered spawn tween

local Players             = game:GetService("Players")
local UserInputService    = game:GetService("UserInputService")
local RunService          = game:GetService("RunService")
local TweenService        = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting            = game:GetService("Lighting")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local HttpService         = game:GetService("HttpService")
local StarterGui          = game:GetService("StarterGui")
local LocalPlayer         = Players.LocalPlayer
local Camera              = workspace.CurrentCamera

local AXON = {}
_G.AXON = AXON
print("[AXON] loader start v16-patched")

local guiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
if not guiParent then warn("[AXON] no PlayerGui"); return end

-- ============================================================
-- SHARED BUNNY LOGO BUILDER
-- ============================================================
local function buildBunnyLogo(parent, scale)
    scale = scale or 1
    local bunny = Instance.new("Frame", parent)
    bunny.Size = UDim2.fromScale(1, 1)
    bunny.BackgroundTransparency = 1

    local function part(px, py, w, h, rot)
        local p = Instance.new("Frame", bunny)
        p.AnchorPoint = Vector2.new(0.5, 0.5)
        p.Position = UDim2.new(px, 0, py, 0)
        p.Size = UDim2.fromOffset(w * scale, h * scale)
        p.BackgroundColor3 = Color3.fromRGB(240, 235, 255)
        p.BorderSizePixel = 0
        p.Rotation = rot or 0
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        return p
    end

    part(0.36, 0.16, 9, 26, -14)
    part(0.64, 0.16, 9, 26, 14)

    local head = Instance.new("Frame", bunny)
    head.AnchorPoint = Vector2.new(0.5, 0.5)
    head.Position = UDim2.new(0.5, 0, 0.62, 0)
    head.Size = UDim2.fromOffset(34 * scale, 30 * scale)
    head.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
    head.BorderSizePixel = 0
    Instance.new("UICorner", head).CornerRadius = UDim.new(0.5, 0)

    local eyeL = Instance.new("Frame", head)
    eyeL.AnchorPoint = Vector2.new(0.5, 0.5)
    eyeL.Position = UDim2.new(0.30, 0, 0.42, 0)
    eyeL.Size = UDim2.fromOffset(5 * scale, 6 * scale)
    eyeL.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    eyeL.BorderSizePixel = 0
    Instance.new("UICorner", eyeL).CornerRadius = UDim.new(1, 0)

    local eyeR = Instance.new("Frame", head)
    eyeR.AnchorPoint = Vector2.new(0.5, 0.5)
    eyeR.Position = UDim2.new(0.70, 0, 0.42, 0)
    eyeR.Size = UDim2.fromOffset(5 * scale, 6 * scale)
    eyeR.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    eyeR.BorderSizePixel = 0
    Instance.new("UICorner", eyeR).CornerRadius = UDim.new(1, 0)

    local nose = Instance.new("Frame", head)
    nose.AnchorPoint = Vector2.new(0.5, 0.5)
    nose.Position = UDim2.new(0.5, 0, 0.64, 0)
    nose.Size = UDim2.fromOffset(5 * scale, 4 * scale)
    nose.BackgroundColor3 = Color3.fromRGB(220, 150, 180)
    nose.BorderSizePixel = 0
    Instance.new("UICorner", nose).CornerRadius = UDim.new(1, 0)

    local cheekL = Instance.new("Frame", head)
    cheekL.AnchorPoint = Vector2.new(0.5, 0.5)
    cheekL.Position = UDim2.new(0.16, 0, 0.60, 0)
    cheekL.Size = UDim2.fromOffset(4 * scale, 3 * scale)
    cheekL.BackgroundColor3 = Color3.fromRGB(255, 200, 210)
    cheekL.BorderSizePixel = 0
    Instance.new("UICorner", cheekL).CornerRadius = UDim.new(1, 0)

    local cheekR = Instance.new("Frame", head)
    cheekR.AnchorPoint = Vector2.new(0.5, 0.5)
    cheekR.Position = UDim2.new(0.84, 0, 0.60, 0)
    cheekR.Size = UDim2.fromOffset(4 * scale, 3 * scale)
    cheekR.BackgroundColor3 = Color3.fromRGB(255, 200, 210)
    cheekR.BorderSizePixel = 0
    Instance.new("UICorner", cheekR).CornerRadius = UDim.new(1, 0)

    return bunny
end

-- ============================================================
-- CONFIG
-- ============================================================
local CONFIG_FILE = "AXON_config.json"
local KEY_FILE = "AXON_key.json"
local FFLAG_FILE = "AXON_fflags.json"
local SP_BTN_POS_FILE = "AXON_sp_btn.json"
local AXON_KEY = "axon"

AXON.Config = {
    aimEnabled      = false,
    aimMode         = "360",
    aimFovRadius    = 200,
    aimFovOrigin    = "Screen",
    aimTargetKind   = "Player",
    aimPart         = "HumanoidRootPart",
    aimRange        = 3000,
    aimSmooth       = 0.35,
    aimTargetPolicy = "Nearest",
    aimTargetUserId = 0,
    silentAim       = true,
    hookUnitRay     = true,
    hookMouseModule = true,
    rotateHRP       = true,
    showTracer      = true,
    tracerColor     = Color3.fromRGB(255, 70, 85),
    tracerThick     = 2.5,
    stickyAim       = true,
    stickyTicks     = 4,
    blacklistAimbot = true,
    predict         = true,
    predictAmount   = 0.12,
    teamCheck       = true,
    safeZoneCheck   = true,
    pvpCheck        = true,
    ignoreLowLevel  = false,
    ignoreLowLevelThreshold = 2000,
    prioritizeLowHealth = false,
    aimNpc          = false,

    blEnabled       = true,
    blMelee         = false, blMeleeZ = false, blMeleeX = false, blMeleeC = false,
    blFruit         = false, blFruitM1 = false, blFruitZ = false, blFruitX = false,
                     blFruitC = false, blFruitV = false, blFruitF = false,
    blSword         = false, blSwordZ = false, blSwordX = false,
    blGun           = false, blGunZ = false, blGunX = false, blGunM1 = false,

    walkSpeed       = false,
    walkSpeedValue  = 216,
    dashSpeed       = false,
    dashSpeedValue  = 500,
    superJump       = false,
    superJumpPower  = 500,

    fastAttack      = false,
    fastAttackDelay = 0.05,
    fastAttackRange = 60,
    gunAura         = false,
    gunAuraRange    = 400,
    gunAuraDelay    = 0.12,
    tweenToPlayer   = false,
    tweenSpeed      = 320,
    tweenHeight     = 6,
    tweenBackOffset = 4,

    safePlatform        = false,
    safePlatformDist    = 8,
    safePlatformBtn     = false,

    skillSoru       = false,
    soruSkill       = "Z",
    soruWeapon      = "Fruit",
    soruDelay       = 0.30,
    soruTarget      = "Tracer",
    soruTriggerR    = true,
    flashstepToggle = true,
    soruOnAnim      = true,
    autoAimSoru     = false,

    macroEnabled    = false,
    macroLoop       = false,
    macroTriggerKey = Enum.KeyCode.T,
    macroActiveSlot = 1,
    macroStepDelay  = 0.30,
    macroV3Key      = Enum.KeyCode.Y,
    macroSteps      = {
        { weapon = "Melee", skill = "Z", delay = 0.30, enabled = true },
        { weapon = "Melee", skill = "X", delay = 0.30, enabled = true },
        { weapon = "Melee", skill = "C", delay = 0.30, enabled = true },
        { weapon = "Sword", skill = "Z", delay = 0.30, enabled = false },
        { weapon = "Fruit", skill = "Z", delay = 0.30, enabled = false },
        { weapon = "Fruit", skill = "X", delay = 0.30, enabled = false },
        { weapon = "Gun",   skill = "Z", delay = 0.30, enabled = false },
        { weapon = "Melee", skill = "TAP", delay = 0.20, enabled = false },
        { weapon = "None",  skill = "V3", delay = 0.30, enabled = false },
    },

    espEnabled      = false,
    espShowPvP      = true,
    espShowBounty   = true,
    espShowHealth   = true,
    espShowName     = true,
    espShowDistance = true,
    espColor        = Color3.fromRGB(168, 85, 247),

    theme           = "LiquidGlass",
    uiScale         = 1.0,
    ultraPotato     = false,
}

AXON.State = {
    unlocked      = false,
    panelBuilt    = false,
    stickyTarget  = nil,
    stickyCount   = 0,
    lastSuperJump = 0,
    lastDash      = 0,
    dashing       = false,
    currentSkillKey = nil,
    currentTheme  = "LiquidGlass",
    menuOpen      = true,
    cleanupFns    = {},
    homeRefresh   = nil,
    lastGoodTracer = { from = nil, to = nil, t = 0 },
    safePlatformPart = nil,
    safePlatformBtnGui = nil,
    espObjects    = {},
    macroRunning  = false,
    macroToken    = 0,
    keybinds      = {
        aimToggle    = Enum.KeyCode.LeftAlt,
        silentToggle = Enum.KeyCode.RightAlt,
        autoSoru     = Enum.KeyCode.R,
        dash         = Enum.KeyCode.Q,
        menuToggle   = Enum.KeyCode.RightShift,
        destroy      = Enum.KeyCode.Delete,
        macro        = Enum.KeyCode.T,
        macroV3      = Enum.KeyCode.Y,
        superJump    = Enum.KeyCode.Space,
        safePlatform = Enum.KeyCode.H,
    },
    listeningBind = nil,
}

function AXON.SaveConfig()
    pcall(function()
        if writefile then
            local save = {}
            for k, v in pairs(AXON.Config) do
                if type(v) ~= "Color3" and type(v) ~= "EnumItem" then save[k] = v end
            end
            writefile(CONFIG_FILE, HttpService:JSONEncode(save))
        end
    end)
end

function AXON.LoadConfig()
    pcall(function()
        if isfile and isfile(CONFIG_FILE) and readfile then
            local raw = readfile(CONFIG_FILE)
            if raw and #raw > 4 then
                local data = HttpService:JSONDecode(raw)
                if type(data) == "table" then
                    for k, v in pairs(data) do
                        if AXON.Config[k] ~= nil and type(v) == type(AXON.Config[k]) then
                            AXON.Config[k] = v
                        end
                    end
                end
            end
        end
    end)
end
AXON.LoadConfig()

function AXON.SaveKey()
    pcall(function()
        if writefile then writefile(KEY_FILE, HttpService:JSONEncode({ valid = true })) end
    end)
end

function AXON.IsKeySaved()
    local saved = false
    pcall(function()
        if isfile and isfile(KEY_FILE) and readfile then
            local raw = readfile(KEY_FILE)
            if raw and #raw > 4 then
                local data = HttpService:JSONDecode(raw)
                if type(data) == "table" and data.valid == true then saved = true end
            end
        end
    end)
    return saved
end

function AXON.SaveFFlags(jsonText)
    pcall(function()
        if writefile then writefile(FFLAG_FILE, jsonText) end
    end)
end

function AXON.LoadFFlags()
    pcall(function()
        if isfile and isfile(FFLAG_FILE) and readfile then
            local raw = readfile(FFLAG_FILE)
            if raw and #raw > 2 then
                AXON.ApplyJSONFlags(raw)
            end
        end
    end)
end

-- ============================================================
-- THEMES
-- ============================================================
AXON.Themes = {
    -- ── PATCH: LiquidGlass theme ─────────────────────────────────────────────
    -- Ice-blue / violet iridescent frosted glass palette.
    -- bg/glass/card/row are near-black so the gradient overlays read clearly.
    -- accent is a cold sky-blue; accent2 is a lighter ice variant.
    -- stroke is a vivid cyan-blue for the per-card glass rim.
    LiquidGlass = {
        accent  = Color3.fromRGB(130, 210, 255),
        accent2 = Color3.fromRGB(100, 180, 255),
        bright  = Color3.fromRGB(220, 245, 255),
        bg      = Color3.fromRGB(6,   8,   12),
        glass   = Color3.fromRGB(14,  18,  28),
        card    = Color3.fromRGB(18,  24,  36),
        row     = Color3.fromRGB(26,  34,  50),
        stroke  = Color3.fromRGB(90,  170, 230),
    },
    Purple = { accent = Color3.fromRGB(168, 85, 247), accent2 = Color3.fromRGB(139, 92, 246),
               bright = Color3.fromRGB(216, 180, 254), bg = Color3.fromRGB(10, 9, 18),
               glass = Color3.fromRGB(18, 16, 32), card = Color3.fromRGB(24, 21, 42),
               row = Color3.fromRGB(34, 30, 56), stroke = Color3.fromRGB(80, 60, 130) },
    Cyan   = { accent = Color3.fromRGB(34, 211, 238), accent2 = Color3.fromRGB(6, 182, 212),
               bright = Color3.fromRGB(165, 243, 252), bg = Color3.fromRGB(8, 14, 20),
               glass = Color3.fromRGB(14, 24, 32), card = Color3.fromRGB(20, 34, 44),
               row = Color3.fromRGB(28, 46, 60), stroke = Color3.fromRGB(56, 120, 150) },
    Green  = { accent = Color3.fromRGB(52, 211, 153), accent2 = Color3.fromRGB(16, 185, 129),
               bright = Color3.fromRGB(167, 243, 208), bg = Color3.fromRGB(8, 18, 14),
               glass = Color3.fromRGB(14, 28, 22), card = Color3.fromRGB(20, 38, 30),
               row = Color3.fromRGB(28, 52, 42), stroke = Color3.fromRGB(56, 130, 100) },
    Pink   = { accent = Color3.fromRGB(244, 114, 182), accent2 = Color3.fromRGB(236, 72, 153),
               bright = Color3.fromRGB(251, 207, 232), bg = Color3.fromRGB(20, 10, 16),
               glass = Color3.fromRGB(30, 16, 24), card = Color3.fromRGB(42, 22, 34),
               row = Color3.fromRGB(56, 32, 46), stroke = Color3.fromRGB(150, 60, 110) },
    Gold   = { accent = Color3.fromRGB(251, 191, 36), accent2 = Color3.fromRGB(245, 158, 11),
               bright = Color3.fromRGB(254, 240, 138), bg = Color3.fromRGB(18, 14, 8),
               glass = Color3.fromRGB(28, 22, 14), card = Color3.fromRGB(40, 32, 18),
               row = Color3.fromRGB(54, 42, 26), stroke = Color3.fromRGB(140, 100, 40) },
    Mono   = { accent = Color3.fromRGB(203, 213, 225), accent2 = Color3.fromRGB(148, 163, 184),
               bright = Color3.fromRGB(241, 245, 249), bg = Color3.fromRGB(12, 12, 14),
               glass = Color3.fromRGB(20, 20, 24), card = Color3.fromRGB(28, 28, 34),
               row = Color3.fromRGB(38, 38, 46), stroke = Color3.fromRGB(90, 90, 100) },
}
-- PATCH: LiquidGlass is now the first / default theme
AXON.ThemeOrder = { "LiquidGlass", "Purple", "Cyan", "Green", "Pink", "Gold", "Mono" }

function AXON.GetTheme()
    return AXON.Themes[AXON.State.currentTheme] or AXON.Themes.LiquidGlass
end

-- ============================================================
-- FILTERS
-- ============================================================
function AXON.IsBlacklistedPlayer(p)
    if not p then return true end
    local bl = AXON.Config.blacklist or {}
    return bl[p] or bl[p.UserId] or bl[tostring(p.UserId)] or bl[p.Name] or bl[string.lower(p.Name)] or false
end

function AXON.getToolCategoryName(tool)
    if not tool then return "Melee" end
    local tip = tool.ToolTip or tool:GetAttribute("Type") or tool:GetAttribute("WeaponType")
    if tip then
        local t = string.lower(tostring(tip))
        if t:find("sword") then return "Sword" end
        if t:find("gun") then return "Gun" end
        if t:find("fruit") then return "Fruit" end
        if t:find("melee") then return "Melee" end
    end
    local n = string.lower(tool.Name)
    if n:find("sword") or n:find("katana") or n:find("blade") or n:find("saber") or n:find("scythe") or n:find("trident") or n:find("dagger") or n:find("yoru") or n:find("tushita") or n:find("yama") then return "Sword" end
    if n:find("gun") or n:find("rifle") or n:find("bow") or n:find("guitar") or n:find("cannon") or n:find("bazooka") then return "Gun" end
    if n:find("fruit") or n:find("-") then return "Fruit" end
    return "Melee"
end

function AXON.IsSkillBlocked(skillKey)
    if not AXON.Config.blEnabled then return false end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local cat = AXON.getToolCategoryName(tool)
    local key = skillKey
    if key == "TAP" then key = "M1" end
    if key == nil then return false end
    local c = AXON.Config
    if cat == "Melee" then
        if c.blMelee then return true end
        if key == "Z" and c.blMeleeZ then return true end
        if key == "X" and c.blMeleeX then return true end
        if key == "C" and c.blMeleeC then return true end
    elseif cat == "Fruit" then
        if c.blFruit then return true end
        if key == "M1" and c.blFruitM1 then return true end
        if key == "Z" and c.blFruitZ then return true end
        if key == "X" and c.blFruitX then return true end
        if key == "C" and c.blFruitC then return true end
        if key == "V" and c.blFruitV then return true end
        if key == "F" and c.blFruitF then return true end
    elseif cat == "Sword" then
        if c.blSword then return true end
        if key == "Z" and c.blSwordZ then return true end
        if key == "X" and c.blSwordX then return true end
    elseif cat == "Gun" then
        if c.blGun then return true end
        if key == "Z" and c.blGunZ then return true end
        if key == "X" and c.blGunX then return true end
        if key == "M1" and c.blGunM1 then return true end
    end
    return false
end

function AXON.IsAlly(p)
    if not p or p == LocalPlayer then return true end
    local myT, theirT = LocalPlayer.Team, p.Team
    if myT and theirT and myT.Name == "Marines" and theirT.Name == "Marines" then return true end
    local myC = LocalPlayer:GetAttribute("Crew")
    local theirC = p:GetAttribute("Crew")
    if myC and theirC and myC ~= "" and myC == theirC then return true end
    return false
end

function AXON.InSafeZone(p)
    if not p or not p.Character then return false end
    local char = p.Character
    if char:FindFirstChildOfClass("ForceField") then return true end
    if char:GetAttribute("SafeZone") == true then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local zones = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("SafeZones")
    if not zones then return false end
    for _, zone in ipairs(zones:GetChildren()) do
        if zone:IsA("BasePart") then
            local l = zone.CFrame:PointToObjectSpace(hrp.Position)
            local h = zone.Size / 2
            if math.abs(l.X) <= h.X and math.abs(l.Y) <= h.Y + 25 and math.abs(l.Z) <= h.Z then return true end
        end
    end
    return false
end

function AXON.PvpAllowed(p)
    if not p then return false end
    if p:GetAttribute("PvpDisabled") == true then return false end
    local char = p.Character
    if char and char:GetAttribute("PvpDisabled") == true then return false end
    return true
end

function AXON.GetPlayerLevel(p)
    if not p then return 0 end
    local lvl = 0
    local d = p:FindFirstChild("Data")
    if d and d:FindFirstChild("Level") then lvl = tonumber(d.Level.Value) or 0 end
    if lvl <= 0 then
        local ls = p:FindFirstChild("leaderstats")
        if ls then
            local l = ls:FindFirstChild("Level") or ls:FindFirstChild("Lvl")
            if l then lvl = tonumber(l.Value) or 0 end
        end
    end
    return lvl
end

function AXON.GetBounty(p)
    if not p then return 0 end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        local b = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
        if b then return tonumber(b.Value) or 0 end
    end
    return 0
end

-- ============================================================
-- TARGET SELECTION
-- ============================================================
local function getTargetPart(char)
    if not char then return nil end
    return char:FindFirstChild(AXON.Config.aimPart) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
end

local function predict(hrp)
    if not hrp then return nil end
    local raw = hrp.Position
    if raw.X ~= raw.X or raw.Y ~= raw.Y or raw.Z ~= raw.Z then return nil end
    if not AXON.Config.predict then return raw end
    local vel = hrp.AssemblyLinearVelocity
    if not vel then return raw end
    local speed = vel.Magnitude
    if speed < 8 or speed > 120 then return raw end
    local out = raw + vel * AXON.Config.predictAmount
    if out.X ~= out.X or out.Y ~= out.Y or out.Z ~= out.Z then return raw end
    return out
end

local function aimScore(part, distance, health)
    local cam = Camera or workspace.CurrentCamera
    local mode = AXON.Config.aimMode or "360"
    local healthBonus = 0
    if AXON.Config.prioritizeLowHealth and health then
        healthBonus = health * 0.5
    end
    if mode == "360" then return distance + healthBonus end
    if not cam or not part then return nil end
    local delta = part.Position - cam.CFrame.Position
    if mode == "180" then
        if delta:Dot(cam.CFrame.LookVector) < 0 then return nil end
        return distance + healthBonus
    end
    local point, visible = cam:WorldToViewportPoint(part.Position)
    if not visible or point.Z <= 0 then return nil end
    local radius = math.clamp(tonumber(AXON.Config.aimFovRadius) or 200, 20, 3000)
    local center
    if AXON.Config.aimFovOrigin == "Mouse" and not UserInputService.TouchEnabled then
        center = UserInputService:GetMouseLocation()
    else
        center = cam.ViewportSize / 2
    end
    local pixels = (Vector2.new(point.X, point.Y) - center).Magnitude
    if pixels > radius then return nil end
    return pixels + healthBonus
end

local function validatePlayer(p, maxDist)
    maxDist = maxDist or AXON.Config.aimRange
    if not p or p == LocalPlayer then return false end
    if AXON.IsBlacklistedPlayer(p) then return false end
    if AXON.Config.teamCheck and AXON.IsAlly(p) then return false end
    if AXON.Config.pvpCheck and not AXON.PvpAllowed(p) then return false end
    if AXON.Config.safeZoneCheck and AXON.InSafeZone(p) then return false end
    if AXON.Config.ignoreLowLevel then
        local lvl = AXON.GetPlayerLevel(p)
        if lvl > 0 and lvl < AXON.Config.ignoreLowLevelThreshold then return false end
    end
    local char = p.Character
    if not char or not char:IsDescendantOf(workspace) then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return false end
    if hrp.Position.Y <= -500 then return false end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return false end
    return (hrp.Position - myHrp.Position).Magnitude <= maxDist
end

local function validateNPC(npc, maxDist)
    if not npc or not npc.Parent then return false end
    maxDist = maxDist or AXON.Config.aimRange
    local hum = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head") or npc.PrimaryPart
    if not hum or hum.Health <= 0 or not hrp then return false end
    local n = string.lower(npc.Name)
    if n:find("quest") or n:find("dealer") or n:find("shop") or n:find("citizen") or n:find("trainer") or n:find("scientist") or n:find("agent") then return false end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return false end
    return (hrp.Position - myHrp.Position).Magnitude <= maxDist
end

local function getClosestTorsoToCursor()
    if not AXON.Config.aimEnabled then return nil end
    local myChar = LocalPlayer.Character
    local myTorso = myChar and (myChar:FindFirstChild("HumanoidRootPart")
        or myChar:FindFirstChild("Torso")
        or myChar:FindFirstChild("UpperTorso"))
    if not myTorso then return nil end

    local mousePos = UserInputService:GetMouseLocation()
    local radius = math.clamp(tonumber(AXON.Config.aimFovRadius) or 150, 20, 3000)
    local closestTorso, shortest = nil, radius

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and validatePlayer(p, AXON.Config.aimRange) then
            local char = p.Character
            local torso = char and (char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChild("Torso")
                or char:FindFirstChild("UpperTorso"))
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if torso and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                if onScreen and screenPos.Z > 0 then
                    local cursorDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if cursorDist < shortest then
                        shortest = cursorDist
                        closestTorso = torso
                    end
                end
            end
        end
    end
    return closestTorso
end
AXON._getClosestTorsoToCursor = getClosestTorsoToCursor

local function scanAimTarget()
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil, nil end
    local myPos = myHrp.Position
    local bestModel, bestPos, bestScore = nil, nil, math.huge
    local range = AXON.Config.aimRange
    local kind = AXON.Config.aimTargetKind or "Player"

    if AXON.Config.aimMode == "FOV" and AXON.Config.aimFovOrigin == "Mouse"
        and not UserInputService.TouchEnabled then
        local torso = getClosestTorsoToCursor()
        if torso then
            local model = torso.Parent
            local hum = model and model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return model, predict(torso)
            end
        end
    end

    if kind == "Player" or AXON.Config.aimNpc then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local ok, valid = pcall(validatePlayer, p, range)
                if ok and valid and AXON.Config.aimTargetPolicy == "Selected" then
                    if tostring(p.UserId) ~= tostring(AXON.Config.aimTargetUserId) then valid = false end
                end
                if ok and valid then
                    local part = getTargetPart(p.Character)
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if part and hum then
                        local d = (part.Position - myPos).Magnitude
                        local healthPct = hum.Health / math.max(hum.MaxHealth, 1)
                        local score = aimScore(part, d, 1 - healthPct)
                        if score and score < bestScore then bestModel, bestPos, bestScore = p.Character, predict(part), score end
                    end
                end
            end
        end
    end

    if kind == "NPC" then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do
                if npc:IsA("Model") and validateNPC(npc, range) then
                    local part = getTargetPart(npc)
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    if part and hum then
                        local d = (part.Position - myPos).Magnitude
                        local healthPct = hum.Health / math.max(hum.MaxHealth, 1)
                        local score = aimScore(part, d, 1 - healthPct)
                        if score and score < bestScore then bestModel, bestPos, bestScore = npc, predict(part), score end
                    end
                end
            end
        end
    end
    return bestModel, bestPos
end

local function modelStillValid(model)
    if not model or not model.Parent then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local p = Players:GetPlayerFromCharacter(model)
    if p then
        if AXON.IsBlacklistedPlayer(p) then return false end
        if AXON.Config.teamCheck and AXON.IsAlly(p) then return false end
        if AXON.Config.pvpCheck and not AXON.PvpAllowed(p) then return false end
        if AXON.Config.safeZoneCheck and AXON.InSafeZone(p) then return false end
        if AXON.Config.ignoreLowLevel then
            local lvl = AXON.GetPlayerLevel(p)
            if lvl > 0 and lvl < AXON.Config.ignoreLowLevelThreshold then return false end
        end
        if AXON.Config.aimTargetPolicy == "Selected" and tostring(p.UserId) ~= tostring(AXON.Config.aimTargetUserId) then return false end
    end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local tHrp = model:FindFirstChild("HumanoidRootPart")
    if not myHrp or not tHrp then return false end
    return (tHrp.Position - myHrp.Position).Magnitude <= AXON.Config.aimRange
end

local function resolveAimTarget()
    if AXON.Config.stickyAim and AXON.State.stickyTarget and AXON.State.stickyCount < AXON.Config.stickyTicks then
        if modelStillValid(AXON.State.stickyTarget) then
            AXON.State.stickyCount = AXON.State.stickyCount + 1
            local part = getTargetPart(AXON.State.stickyTarget)
            if part then return AXON.State.stickyTarget, predict(part) end
        end
        AXON.State.stickyTarget = nil
        AXON.State.stickyCount = 0
    end
    local model, pos = scanAimTarget()
    AXON.State.stickyTarget = model
    AXON.State.stickyCount = 0
    return model, pos
end
AXON._resolveAimTarget = resolveAimTarget

local currentAimModel, currentAimPos = nil, nil
local function setCurrentAim(model, pos)
    currentAimModel, currentAimPos = model, pos
end
AXON._setCurrentAim = setCurrentAim

-- ============================================================
-- SILENT AIM HOOKS
-- ============================================================
local function installSilentHooks()
    local rawMouse = LocalPlayer:GetMouse()
    local env = (getgenv and getgenv()) or _G
    local wrap = (type(newcclosure) == "function") and newcclosure or function(f) return f end

    local function readMouseProp(key)
        if key ~= "Hit" and key ~= "Target" and key ~= "UnitRay" then return false end
        if not AXON.Config.aimEnabled or not AXON.Config.silentAim then return false end
        if not currentAimPos then return false end
        if AXON.Config.blacklistAimbot and AXON.State.currentSkillKey and AXON.IsSkillBlocked(AXON.State.currentSkillKey) then return false end
        if key == "Hit" then
            local cf = CFrame.new(currentAimPos)
            if cf.X == cf.X and cf.Y == cf.Y and cf.Z == cf.Z then return true, cf end
            return false
        end
        if key == "Target" then
            if not currentAimModel then return false end
            local part = getTargetPart(currentAimModel)
            if not part then return false end
            return true, part
        end
        if key == "UnitRay" then
            if not AXON.Config.hookUnitRay then return false end
            local cam = Camera or workspace.CurrentCamera
            if not cam then return false end
            local origin = cam.CFrame.Position
            local dir = currentAimPos - origin
            if dir.Magnitude < 0.001 then return false end
            return true, Ray.new(origin, dir.Unit)
        end
        return false
    end

    if not env._axonOldIndex then
        local function dispatcher(obj, key)
            if obj == rawMouse then
                local changed, val = readMouseProp(key)
                if changed then return val end
            end
            local native = env._axonOldIndex
            if type(native) == "function" then return native(obj, key) end
            if type(native) == "table" then return native[key] end
            return nil
        end
        local hooked = false
        if type(hookmetamethod) == "function" then
            local ok, res = pcall(hookmetamethod, rawMouse, "__index", wrap(dispatcher))
            if ok and res ~= nil then env._axonOldIndex = res; hooked = true end
        end
        if not hooked and type(getrawmetatable) == "function" then
            local ok, mt = pcall(getrawmetatable, rawMouse)
            if ok and mt then
                env._axonOldIndex = mt.__index
                pcall(function() if setreadonly then setreadonly(mt, false) end end)
                mt.__index = wrap(dispatcher)
                pcall(function() if setreadonly then setreadonly(mt, true) end end)
                hooked = true
            end
        end
    end

    if AXON.Config.hookMouseModule then
        task.spawn(function()
            pcall(function()
                if env._axonMouseModuleRestore then return end
                local inst = ReplicatedStorage:WaitForChild("Mouse", 8)
                if not inst then return end
                local obj = require(inst)
                if type(obj) ~= "table" then return end
                local mt = type(getrawmetatable) == "function" and getrawmetatable(obj) or getmetatable(obj)
                if not mt then mt = {}; setmetatable(obj, mt) end
                local oldIndex = mt.__index
                local oldNewIndex = mt.__newindex
                local values = { Hit = rawget(obj, "Hit"), Target = rawget(obj, "Target") }
                local stored = { Hit = values.Hit ~= nil, Target = values.Target ~= nil }
                local wasReadOnly = (type(isreadonly) == "function") and isreadonly(mt) or false
                if type(setreadonly) == "function" then setreadonly(mt, false) end
                local function originalIndex(self, key)
                    if stored[key] then return values[key] end
                    if type(oldIndex) == "function" then return oldIndex(self, key) end
                    if type(oldIndex) == "table" then return oldIndex[key] end
                    return nil
                end
                local ownIndex = function(self, key)
                    if (key == "Hit" or key == "Target") and AXON.Config.aimEnabled and AXON.Config.silentAim then
                        if AXON.Config.blacklistAimbot and AXON.State.currentSkillKey and AXON.IsSkillBlocked(AXON.State.currentSkillKey) then
                            return originalIndex(self, key)
                        end
                        if key == "Hit" and currentAimPos then
                            local cf = CFrame.new(currentAimPos)
                            if cf.X == cf.X and cf.Y == cf.Y and cf.Z == cf.Z then return cf end
                        end
                        if key == "Target" and currentAimModel then
                            local part = getTargetPart(currentAimModel)
                            if part then return part end
                        end
                    end
                    return originalIndex(self, key)
                end
                local ownNewIndex = function(self, key, value)
                    if key == "Hit" or key == "Target" then values[key], stored[key] = value, true
                    elseif type(oldNewIndex) == "function" then oldNewIndex(self, key, value)
                    elseif type(oldNewIndex) == "table" then oldNewIndex[key] = value
                    else rawset(self, key, value) end
                end
                mt.__index, mt.__newindex = ownIndex, ownNewIndex
                rawset(obj, "Hit", nil); rawset(obj, "Target", nil)
                if type(setreadonly) == "function" then setreadonly(mt, wasReadOnly) end
                env._axonMouseModuleRestore = function()
                    if mt.__index ~= ownIndex then return end
                    if type(setreadonly) == "function" then setreadonly(mt, false) end
                    mt.__index = oldIndex
                    if mt.__newindex == ownNewIndex then mt.__newindex = oldNewIndex end
                    rawset(obj, "Hit", values.Hit); rawset(obj, "Target", values.Target)
                    if type(setreadonly) == "function" then setreadonly(mt, wasReadOnly) end
                end
            end)
        end)
    end
end
installSilentHooks()

-- ============================================================
-- M1 HIT HOOK
-- ============================================================
local function installM1HitHook()
    local rawMouse = LocalPlayer:GetMouse()
    local env = (getgenv and getgenv()) or _G
    local wrap = (type(newcclosure) == "function") and newcclosure or function(f) return f end

    if env._axonOldIndexM1 then return end

    local function dispatcher(obj, key)
        if obj == rawMouse and (key == "Hit" or key == "hit") then
            if AXON.Config.aimEnabled then
                local liveKey = AXON.State.currentSkillKey
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                local cat = tool and AXON.getToolCategoryName(tool)
                if liveKey == "M1" and (cat == "Gun" or cat == "Fruit")
                    and not AXON.IsSkillBlocked("M1") then
                    local torso = getClosestTorsoToCursor()
                    if torso then return torso.CFrame end
                end
                if AXON.Config.autoAimSoru and liveKey and liveKey ~= "M1" then
                    local torso = getClosestTorsoToCursor()
                    if torso then return torso.CFrame end
                end
            end
        end
        local native = env._axonOldIndexM1
        if type(native) == "function" then return native(obj, key) end
        if type(native) == "table" then return native[key] end
        return nil
    end

    local hooked = false
    if type(hookmetamethod) == "function" then
        local ok, res = pcall(hookmetamethod, rawMouse, "__index", wrap(dispatcher))
        if ok and res ~= nil then env._axonOldIndexM1 = res; hooked = true end
    end
    if not hooked and type(getrawmetatable) == "function" then
        local ok, mt = pcall(getrawmetatable, rawMouse)
        if ok and mt then
            env._axonOldIndexM1 = mt.__index
            pcall(function() if setreadonly then setreadonly(mt, false) end end)
            mt.__index = wrap(dispatcher)
            pcall(function() if setreadonly then setreadonly(mt, true) end end)
            hooked = true
        end
    end
end
installM1HitHook()

-- ============================================================
-- HRP FACING
-- ============================================================
local function faceTarget(pos)
    if not pos then return end
    local liveKey = AXON.State.currentSkillKey
    if not liveKey then return end
    if liveKey == "M1" or liveKey == "TAP" then return end
    if liveKey == "Q" or liveKey == "SPACE" then return end
    if AXON.State.dashing then return end
    if AXON.Config.blacklistAimbot and AXON.IsSkillBlocked(liveKey) then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if typeof(pos) ~= "Vector3" then return end
    local cur = hrp.Position
    local lv = Vector3.new(pos.X - cur.X, 0, pos.Z - cur.Z)
    if lv.Magnitude < 0.1 then return end
    pcall(function() hrp.CFrame = CFrame.lookAt(cur, cur + lv.Unit, Vector3.new(0, 1, 0)) end)
end
AXON.faceTarget = faceTarget

-- ============================================================
-- TRACER
-- ============================================================
local tracerGui = Instance.new("ScreenGui")
tracerGui.Name = "AXON_Tracers"
tracerGui.ResetOnSpawn = false
tracerGui.IgnoreGuiInset = true
tracerGui.Parent = guiParent

local tracerGlow = Instance.new("Frame", tracerGui)
tracerGlow.Name = "AXON_TracerGlow"
tracerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
tracerGlow.BorderSizePixel = 0
tracerGlow.BackgroundTransparency = 0.75
tracerGlow.Visible = false
Instance.new("UICorner", tracerGlow).CornerRadius = UDim.new(1, 0)

local tracerLine = Instance.new("Frame", tracerGui)
tracerLine.Name = "AXON_TracerLine"
tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
tracerLine.BorderSizePixel = 0
tracerLine.BackgroundTransparency = 0.05
tracerLine.Visible = false
Instance.new("UICorner", tracerLine).CornerRadius = UDim.new(1, 0)

local tracerGrad = Instance.new("UIGradient", tracerLine)
tracerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 85)),
})
tracerGrad.Rotation = 0

local function projectTracer(targetPos)
    if not targetPos then return nil end
    local cam = Camera or workspace.CurrentCamera
    if not cam then return nil end
    local myChar = LocalPlayer.Character
    local myTorso = myChar and (myChar:FindFirstChild("UpperTorso") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("HumanoidRootPart"))
    if not myTorso then return nil end
    local from = myTorso.Position + Vector3.new(0, 0.4, 0)
    local to   = targetPos + Vector3.new(0, 0.4, 0)
    local pFrom, onA = cam:WorldToViewportPoint(from)
    local pTo, onB = cam:WorldToViewportPoint(to)
    if not (onA or onB) or pFrom.Z <= 0 or pTo.Z <= 0 then return nil end
    local a = Vector2.new(pFrom.X, pFrom.Y)
    local b = Vector2.new(pTo.X, pTo.Y)
    local delta = b - a
    if delta.Magnitude < 1 then return nil end
    local mid = (a + b) / 2
    return mid, delta
end

local function drawTracer(targetPos)
    if not AXON.Config.showTracer or not targetPos then
        if tracerLine.Visible then tracerLine.Visible = false end
        if tracerGlow.Visible then tracerGlow.Visible = false end
        return
    end
    local mid, delta = projectTracer(targetPos)
    if not mid or not delta then
        if tick() - AXON.State.lastGoodTracer.t > 0.1 then
            if tracerLine.Visible then tracerLine.Visible = false end
            if tracerGlow.Visible then tracerGlow.Visible = false end
        end
        return
    end
    AXON.State.lastGoodTracer.from = mid
    AXON.State.lastGoodTracer.to = delta
    AXON.State.lastGoodTracer.t = tick()
    local ang = math.deg(math.atan2(delta.Y, delta.X))
    tracerLine.Position = UDim2.fromOffset(mid.X, mid.Y)
    tracerLine.Size = UDim2.fromOffset(delta.Magnitude, AXON.Config.tracerThick)
    tracerLine.Rotation = ang
    tracerLine.BackgroundColor3 = AXON.Config.tracerColor
    tracerLine.Visible = true
    tracerGlow.Position = UDim2.fromOffset(mid.X, mid.Y)
    tracerGlow.Size = UDim2.fromOffset(delta.Magnitude + 6, AXON.Config.tracerThick + 5)
    tracerGlow.Rotation = ang
    tracerGlow.BackgroundColor3 = AXON.Config.tracerColor
    tracerGlow.Visible = true
end

local fovCircle = Instance.new("Frame", tracerGui)
fovCircle.Name = "AXON_FOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Thickness = 1.5
fovStroke.Color = Color3.fromRGB(168, 85, 247)
fovStroke.Transparency = 0.2

RunService.RenderStepped:Connect(function()
    if AXON.Config.aimEnabled and AXON.Config.aimMode == "FOV" then
        fovCircle.Visible = true
        local cam = Camera or workspace.CurrentCamera
        if cam then
            local center = cam.ViewportSize / 2
            if AXON.Config.aimFovOrigin == "Mouse" and not UserInputService.TouchEnabled then
                center = UserInputService:GetMouseLocation()
            end
            local r = math.clamp(AXON.Config.aimFovRadius or 200, 20, 3000)
            fovCircle.Position = UDim2.fromOffset(center.X, center.Y)
            fovCircle.Size = UDim2.fromOffset(r * 2, r * 2)
            fovStroke.Color = AXON.GetTheme().accent
        end
    else
        if fovCircle.Visible then fovCircle.Visible = false end
    end
end)

-- ============================================================
-- ESP
-- ============================================================
function AXON.cleanupESP()
    for p, obj in pairs(AXON.State.espObjects) do
        pcall(function()
            if obj.billboard then obj.billboard:Destroy() end
            if obj.highlight then obj.highlight:Destroy() end
        end)
    end
    AXON.State.espObjects = {}
end

function AXON.createESP(p)
    if p == LocalPlayer then return end
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local old = AXON.State.espObjects[p]
    if old then
        pcall(function() old.billboard:Destroy() end)
        pcall(function() old.highlight:Destroy() end)
    end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "AXON_ESP"
    bb.Size = UDim2.fromOffset(220, 60)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = AXON.Config.espColor
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.RichText = true
    local hl = Instance.new("Highlight", char)
    hl.Name = "AXON_ESP_HL"
    hl.FillColor = AXON.Config.espColor
    hl.OutlineColor = AXON.Config.espColor
    hl.FillTransparency = 0.75
    hl.OutlineTransparency = 0.2
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    AXON.State.espObjects[p] = { billboard = bb, label = lbl, highlight = hl, char = char }
end

function AXON.updateESP()
    if not AXON.Config.espEnabled then
        AXON.cleanupESP()
        return
    end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or Vector3.zero
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local data = AXON.State.espObjects[p]
                if not data or data.char ~= p.Character or not data.billboard.Parent then
                    AXON.createESP(p)
                    data = AXON.State.espObjects[p]
                end
                if data and data.label then
                    local dist = math.floor((hrp.Position - myPos).Magnitude)
                    local bounty = AXON.GetBounty(p)
                    local bountyStr
                    if bounty >= 1e9 then bountyStr = string.format("%.1fB", bounty / 1e9)
                    elseif bounty >= 1e6 then bountyStr = string.format("%.1fM", bounty / 1e6)
                    elseif bounty >= 1e3 then bountyStr = string.format("%.1fK", bounty / 1e3)
                    else bountyStr = tostring(bounty) end
                    local pvpOn = AXON.PvpAllowed(p)
                    local inSafe = AXON.InSafeZone(p)
                    local parts = {}
                    if AXON.Config.espShowName then parts[#parts+1] = p.DisplayName or p.Name end
                    if AXON.Config.espShowHealth then parts[#parts+1] = " " .. math.floor(hum.Health) .. "HP" end
                    if AXON.Config.espShowBounty then parts[#parts+1] = " | " .. bountyStr .. "B" end
                    if AXON.Config.espShowDistance then parts[#parts+1] = " | " .. dist .. "m" end
                    if AXON.Config.espShowPvP then
                        local pvpTag = pvpOn and "<font color='rgb(255,80,80)'>PVP ON</font>" or "<font color='rgb(80,255,120)'>PVP OFF</font>"
                        if inSafe then pvpTag = "<font color='rgb(255,220,80)'>SAFE</font>" end
                        parts[#parts+1] = "\n" .. pvpTag
                    end
                    data.label.Text = table.concat(parts)
                    if data.highlight then
                        data.highlight.FillColor = pvpOn and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 255, 120)
                        data.highlight.OutlineColor = data.highlight.FillColor
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(AXON.updateESP)
    end
end)

-- ============================================================
-- SAFE PLATFORM TELEPORT
-- ============================================================
local function ensureSafePlatform()
    if AXON.State.safePlatformPart and AXON.State.safePlatformPart.Parent then
        return AXON.State.safePlatformPart
    end
    local part = Instance.new("Part")
    part.Name = "AXON_SafePlatform"
    part.Size = Vector3.new(20, 1, 20)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 1
    part.Parent = workspace
    AXON.State.safePlatformPart = part
    return part
end

local function saveSPButtonPos(pos)
    pcall(function()
        if writefile then
            writefile(SP_BTN_POS_FILE, HttpService:JSONEncode({
                xs = pos.X.Scale, xo = pos.X.Offset,
                ys = pos.Y.Scale, yo = pos.Y.Offset
            }))
        end
    end)
end

local function loadSPButtonPos()
    local pos = UDim2.new(0.5, -50, 0.8, 0)
    pcall(function()
        if isfile and isfile(SP_BTN_POS_FILE) and readfile then
            local raw = readfile(SP_BTN_POS_FILE)
            if raw then
                local d = HttpService:JSONDecode(raw)
                if d and d.xs and d.xo and d.ys and d.yo then
                    pos = UDim2.new(d.xs, d.xo, d.ys, d.yo)
                end
            end
        end
    end)
    return pos
end

local function createSafePlatformButton()
    if AXON.State.safePlatformBtnGui then
        AXON.State.safePlatformBtnGui:Destroy()
        AXON.State.safePlatformBtnGui = nil
    end
    if not AXON.Config.safePlatformBtn then return end

    local btnGui = Instance.new("ScreenGui")
    btnGui.Name = "AXON_SafePlatformBtn"
    btnGui.ResetOnSpawn = false
    btnGui.Parent = guiParent

    local btn = Instance.new("TextButton")
    btn.Name = "SafePlatformToggle"
    btn.Size = UDim2.fromOffset(100, 30)
    btn.Position = loadSPButtonPos()
    btn.BackgroundColor3 = AXON.Config.safePlatform and Color3.fromRGB(40, 60, 100) or Color3.fromRGB(20, 20, 30)
    btn.Text = "Safe Platform: " .. (AXON.Config.safePlatform and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(80, 60, 130)
    stroke.Thickness = 1
    btn.Parent = btnGui

    btn.MouseButton1Click:Connect(function()
        AXON.Config.safePlatform = not AXON.Config.safePlatform
        btn.Text = "Safe Platform: " .. (AXON.Config.safePlatform and "ON" or "OFF")
        btn.BackgroundColor3 = AXON.Config.safePlatform and Color3.fromRGB(40, 60, 100) or Color3.fromRGB(20, 20, 30)
        if AXON.UIRefs.safePlatformToggle then
            local toggleData = AXON.UIRefs.safePlatformToggle
            if toggleData.refresh then toggleData.refresh() end
        end
        AXON.SaveConfig()
    end)

    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and hasMoved then
                saveSPButtonPos(btn.Position)
            end
            dragging = false
        end
    end)

    AXON.State.safePlatformBtnGui = btnGui
end

RunService.Heartbeat:Connect(function()
    if not AXON.Config.safePlatform then
        if AXON.State.safePlatformPart and AXON.State.safePlatformPart.Parent then
            AXON.State.safePlatformPart:Destroy()
            AXON.State.safePlatformPart = nil
        end
        return
    end
    local target = currentAimModel
    if not target or not target.Parent then return end
    local tHrp = target:FindFirstChild("HumanoidRootPart")
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not tHrp or not hrp then return end
    local part = ensureSafePlatform()
    local dist = math.clamp(tonumber(AXON.Config.safePlatformDist) or 8, 2, 10000)
    local cf = tHrp.CFrame * CFrame.new(0, 0, dist)
    part.CFrame = CFrame.new(cf.Position.X, cf.Position.Y - 3, cf.Position.Z)
    local dest = part.CFrame + Vector3.new(0, 4, 0)
    if (hrp.Position - dest.Position).Magnitude > 1 then
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(dest.Position), 0.25)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end)

-- ============================================================
-- SKILL KEY TRACKING
-- ============================================================
local SKILL_KEYS = { "Z", "X", "C", "V", "F" }
AXON.State.heldSkills = {}

local function TeleportToAimTarget()
    if not AXON.Config.autoAimSoru then return end
    local model, pos = AXON._resolveAimTarget()
    if not pos then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
    hrp.AssemblyLinearVelocity = Vector3.zero
end
AXON.TeleportToAimTarget = TeleportToAimTarget

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local name = input.KeyCode.Name
        for _, k in ipairs(SKILL_KEYS) do
            if name == k then
                AXON.State.heldSkills[k] = true
                AXON.State.currentSkillKey = k
                if AXON.Config.rotateHRP and currentAimPos then faceTarget(currentAimPos) end
                if AXON.Config.autoAimSoru and currentAimPos then
                    TeleportToAimTarget()
                end
            end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        AXON.State.currentSkillKey = "M1"
        if AXON.Config.autoAimSoru and currentAimPos then
            TeleportToAimTarget()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local name = input.KeyCode.Name
        for _, k in ipairs(SKILL_KEYS) do
            if name == k then
                AXON.State.heldSkills[k] = nil
                task.delay(0.2, function()
                    local any = false
                    for _, v in pairs(AXON.State.heldSkills) do if v then any = true break end end
                    if not any and AXON.State.currentSkillKey == k then AXON.State.currentSkillKey = nil end
                end)
            end
        end
    end
end)

-- ============================================================
-- SORU ANIMATION HOOK
-- ============================================================
local FLASH_IDS = {
    ["17555632156"] = true, ["18461649274"] = true, ["616006778"] = true,
    ["616010882"] = true, ["5403485593"] = true, ["5403491911"] = true,
    ["313762630"] = true, ["313762631"] = true, ["1846164274"] = true,
    ["1846163351"] = true,
}
local FLASH_NAMES = { "flashstep", "soru", "flashstepregular", "flashstepdraco" }

local function setupAnimListener(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.AnimationPlayed:Connect(function(track)
        local anim = track.Animation
        local id = anim and tostring(anim.AnimationId):match("%d+")
        local name = string.lower(anim and anim.Name or "")
        local isFlash = FLASH_IDS[id] or false
        if not isFlash then
            for _, n in ipairs(FLASH_NAMES) do
                if string.find(name, n) then isFlash = true break end
            end
        end

        if AXON.Config.skillSoru and AXON.Config.soruOnAnim and isFlash then
            TeleportToAimTarget()
            task.wait(AXON.Config.soruDelay or 0.30)
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then
                local slots = { Melee = 1, Fruit = 2, Sword = 3, Gun = 4 }
                local slotNum = slots[AXON.Config.soruWeapon or "Fruit"] or 2
                local slotKeys = { Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four }
                if slotKeys[slotNum] then
                    VirtualInputManager:SendKeyEvent(true, slotKeys[slotNum], false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, slotKeys[slotNum], false, game)
                end
                task.wait(0.12)
                local kc = Enum.KeyCode[AXON.Config.soruSkill or "Z"]
                if kc then
                    VirtualInputManager:SendKeyEvent(true, kc, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, kc, false, game)
                end
            end
        end
    end)
end

if LocalPlayer.Character then setupAnimListener(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupAnimListener)

-- ============================================================
-- FAST ATTACK / GUN AURA
-- ============================================================
local function resolveAttackRemotes()
    local net = ReplicatedStorage:FindFirstChild("Modules")
        and ReplicatedStorage.Modules:FindFirstChild("Net")
    if not net then return nil, nil end
    return net:FindFirstChild("RE/RegisterAttack"), net:FindFirstChild("RE/RegisterHit")
end

local function gatherAttackTargets(range)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    local myPos = hrp.Position
    local list = {}
    local kind = AXON.Config.aimTargetKind or "Player"

    if kind == "NPC" then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local nHrp = npc:FindFirstChild("HumanoidRootPart")
                local head = npc:FindFirstChild("Head") or nHrp
                if hum and hum.Health > 0 and nHrp and head and (nHrp.Position - myPos).Magnitude <= range then
                    table.insert(list, { npc, head })
                end
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and validatePlayer(p, range) and p.Character then
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if head then table.insert(list, { p.Character, head }) end
            end
        end
    end
    table.sort(list, function(a, b) return (a[2].Position - myPos).Magnitude < (b[2].Position - myPos).Magnitude end)
    return list
end

local function fireM1(tool)
    if not tool then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lcr = tool:FindFirstChild("LeftClickRemote")
    if lcr and lcr:IsA("RemoteEvent") then
        local dir = hrp.CFrame.LookVector
        pcall(function() lcr:FireServer(dir, 1) end)
        return
    end
    local regAttack, regHit = resolveAttackRemotes()
    if regAttack and regHit then
        local targets = gatherAttackTargets(AXON.Config.fastAttackRange)
        if #targets > 0 then
            local primary = targets[1][2]
            pcall(function()
                regAttack:FireServer(0)
                regHit:FireServer(primary, targets)
            end)
        end
    end
end

local function fastAttackLoop()
    if not AXON.Config.fastAttack then return end
    local liveKey = AXON.State.currentSkillKey or "M1"
    if AXON.IsSkillBlocked(liveKey) then return end
    local now = os.clock()
    if now < (AXON.State.faBudget or 0) then return end
    AXON.State.faBudget = now + math.clamp(AXON.Config.fastAttackDelay, 0.03, 2)
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    if AXON.getToolCategoryName(tool) == "Gun" then return end
    if char:GetAttribute("UsingSkill") or char:GetAttribute("isUsingSkill") or char:GetAttribute("Busy") then return end
    fireM1(tool)
end

local function gunAuraLoop()
    if not AXON.Config.gunAura then return end
    local liveKey = AXON.State.currentSkillKey or "M1"
    if AXON.IsSkillBlocked(liveKey) then return end
    local now = os.clock()
    if now < (AXON.State.gaBudget or 0) then return end
    AXON.State.gaBudget = now + math.clamp(AXON.Config.gunAuraDelay, 0.05, 1)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local isGun = tool.ToolTip == "Gun" or tool:GetAttribute("Type") == "Gun"
        or tool:FindFirstChild("ShootGunEvent") ~= nil
    if not isGun then
        local n = string.lower(tool.Name)
        isGun = n:find("gun") or n:find("rifle") or n:find("guitar")
            or n:find("bow") or n:find("cannon") or n:find("bazooka")
            or n:find("flintlock") or n:find("kabucha")
    end
    if not isGun then return end
    fireM1(tool)
end

RunService.RenderStepped:Connect(function()
    pcall(fastAttackLoop)
    pcall(gunAuraLoop)
end)

-- ============================================================
-- MOVEMENT
-- ============================================================
RunService.Stepped:Connect(function()
    if not AXON.Config.walkSpeed then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end
    local target = math.clamp(AXON.Config.walkSpeedValue, 16, 1500)
    hum.WalkSpeed = target
    if target > 20 and hum.MoveDirection.Magnitude > 0.05 then
        local moveDir = hum.MoveDirection.Unit
        local curVel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * target, curVel.Y, moveDir.Z * target)
    end
end)

local function triggerDash()
    if not AXON.Config.dashSpeed then return end
    local now = os.clock()
    if now - AXON.State.lastDash < 0.22 then return end
    AXON.State.lastDash = now
    local char = LocalPlayer.Character
    if not char then return end
    if char:GetAttribute("isUsingSkill") or char:GetAttribute("UsingSkill")
        or char:GetAttribute("Busy") or AXON.State.currentSkillKey then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local targetDist = math.clamp(tonumber(AXON.Config.dashSpeedValue) or 500, 50, 2500)
    pcall(function()
        char:SetAttribute("DashLength", targetDist)
        char:SetAttribute("DashLengthAir", targetDist)
    end)

    local dir = hum.MoveDirection
    if dir.Magnitude < 0.1 then dir = hrp.CFrame.LookVector else dir = dir.Unit end
    local vel = math.clamp(targetDist * 0.9, 120, 2200)
    local y = math.clamp(hrp.AssemblyLinearVelocity.Y, -5, 30)
    hrp.AssemblyLinearVelocity = Vector3.new(dir.X * vel, y, dir.Z * vel)

    AXON.State.dashing = true
    task.delay(0.25, function() AXON.State.dashing = false end)

    task.delay(0.18, function()
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if h then
            local v = h.AssemblyLinearVelocity
            h.AssemblyLinearVelocity = Vector3.new(v.X * 0.15, v.Y, v.Z * 0.15)
        end
    end)
end

local function doSuperJump()
    if not AXON.Config.superJump then return end
    local now = os.clock()
    if now - AXON.State.lastSuperJump < 0.22 then return end
    AXON.State.lastSuperJump = now
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local power = math.clamp(AXON.Config.superJumpPower, 50, 8000)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, power, hrp.AssemblyLinearVelocity.Z)
end
AXON.doSuperJump = doSuperJump
AXON.triggerDash = triggerDash

-- ============================================================
-- TWEEN TO PLAYER
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not AXON.Config.tweenToPlayer then return end
    local target = currentAimModel
    if not target or not target.Parent then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local tHrp = target:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    local dest = tHrp.CFrame * CFrame.new(0, AXON.Config.tweenHeight, AXON.Config.tweenBackOffset)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    local dist = (tHrp.Position - hrp.Position).Magnitude
    local step = math.max(AXON.Config.tweenSpeed, 50) * (1 / 60)
    if dist <= step or dist < 3 then hrp.CFrame = dest else hrp.CFrame = hrp.CFrame:Lerp(dest, step / dist) end
    hrp.AssemblyLinearVelocity = Vector3.zero
end)

-- ============================================================
-- MACRO SYSTEM
-- ============================================================
local function pressKey(kc, hold)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, kc, false, game)
        task.wait(hold or 0.05)
        VirtualInputManager:SendKeyEvent(false, kc, false, game)
    end)
end

local function pressV3()
    local rem = ReplicatedStorage:FindFirstChild("Remotes")
    local commE = rem and rem:FindFirstChild("CommE")
    if commE then
        pcall(function() commE:FireServer("ActivateAbility") end)
    end
end

local function equipWeaponType(want)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local slots = { Melee = 1, Fruit = 2, Sword = 3, Gun = 4 }
    local slotNum = slots[want]
    if not slotNum then return false end
    local cur = char:FindFirstChildOfClass("Tool")
    if cur then
        local curCat = AXON.getToolCategoryName(cur)
        if curCat == want then return true end
    end
    local slotKeys = { Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four }
    pressKey(slotKeys[slotNum], 0.03)
    task.wait(0.1)
    return true
end

function AXON.RunMacro()
    if AXON.State.macroRunning then return end
    AXON.State.macroRunning = true
    AXON.State.macroToken = AXON.State.macroToken + 1
    local myToken = AXON.State.macroToken
    task.spawn(function()
        repeat
            for _, step in ipairs(AXON.Config.macroSteps) do
                if myToken ~= AXON.State.macroToken then break end
                if step.enabled then
                    if step.skill == "V3" then
                        pressV3()
                        task.wait(math.max(step.delay or AXON.Config.macroStepDelay, 0.15))
                    else
                        equipWeaponType(step.weapon)
                        task.wait(0.15)
                        local sk = string.upper(step.skill or "Z")
                        if sk == "TAP" or sk == "M1" then
                            pcall(function()
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                task.wait(0.05)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            end)
                        else
                            local kc = Enum.KeyCode[sk]
                            if kc then
                                if AXON.Config.rotateHRP and currentAimPos then faceTarget(currentAimPos) end
                                pressKey(kc, 0.05)
                            end
                        end
                        task.wait(math.max(step.delay or AXON.Config.macroStepDelay, 0.15))
                    end
                end
            end
        until not AXON.Config.macroLoop
            or myToken ~= AXON.State.macroToken
            or not AXON.State.macroRunning
        AXON.State.macroRunning = false
    end)
end
AXON.StopMacro = function()
    AXON.State.macroToken = AXON.State.macroToken + 1
    AXON.State.macroRunning = false
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == AXON.Config.macroTriggerKey then
        if not AXON.Config.macroEnabled then return end
        if AXON.State.macroRunning then return end
        AXON.RunMacro()
    end
end)

-- ============================================================
-- KEYBIND HANDLER
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if AXON.State.listeningBind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local id = AXON.State.listeningBind
            if input.KeyCode == Enum.KeyCode.Escape then
                AXON.State.keybinds[id] = nil
            else
                AXON.State.keybinds[id] = input.KeyCode
            end
            AXON.State.listeningBind = nil
            if AXON.RefreshBindLabels then AXON.RefreshBindLabels() end
        end
        return
    end
    if UserInputService:GetFocusedTextBox() then return end
    local kb = AXON.State.keybinds
    if input.KeyCode == kb.aimToggle then
        AXON.Config.aimEnabled = not AXON.Config.aimEnabled
        if AXON.RefreshAllToggles then AXON.RefreshAllToggles() end
        AXON.SaveConfig()
    elseif input.KeyCode == kb.silentToggle then
        AXON.Config.silentAim = not AXON.Config.silentAim
        if AXON.RefreshAllToggles then AXON.RefreshAllToggles() end
        AXON.SaveConfig()
    elseif input.KeyCode == kb.menuToggle then
        AXON.State.menuOpen = not AXON.State.menuOpen
        if AXON.UIRefs.main then AXON.UIRefs.main.Visible = AXON.State.menuOpen end
    elseif input.KeyCode == kb.autoSoru then
        if AXON.Config.autoAimSoru or AXON.Config.skillSoru then
            TeleportToAimTarget()
        end
    elseif input.KeyCode == kb.dash then
        triggerDash()
    elseif input.KeyCode == kb.superJump then
        doSuperJump()
    elseif input.KeyCode == kb.macro then
        if AXON.Config.macroEnabled and not AXON.State.macroRunning then AXON.RunMacro() end
    elseif input.KeyCode == kb.macroV3 then
        pressV3()
    elseif input.KeyCode == kb.safePlatform then
        AXON.Config.safePlatform = not AXON.Config.safePlatform
        if AXON.RefreshAllToggles then AXON.RefreshAllToggles() end
        if AXON.State.safePlatformBtnGui then
            local btn = AXON.State.safePlatformBtnGui:FindFirstChild("SafePlatformToggle", true)
            if btn then
                btn.Text = "Safe Platform: " .. (AXON.Config.safePlatform and "ON" or "OFF")
                btn.BackgroundColor3 = AXON.Config.safePlatform and Color3.fromRGB(40, 60, 100) or Color3.fromRGB(20, 20, 30)
            end
        end
        AXON.SaveConfig()
    elseif input.KeyCode == kb.destroy then
        local env = (getgenv and getgenv()) or _G
        if env._axonMouseModuleRestore then pcall(env._axonMouseModuleRestore); env._axonMouseModuleRestore = nil end
        pcall(function() if AXON.UIRefs.main then AXON.UIRefs.main:Destroy() end end)
        pcall(function() tracerGui:Destroy() end)
        if fovCircle and fovCircle.Parent then fovCircle:Destroy() end
        local fb = AXON.UIRefs.floatingButton
        if fb and fb.Parent then pcall(function() fb.Parent:Destroy() end) end
        AXON.cleanupESP()
        if AXON.State.safePlatformPart and AXON.State.safePlatformPart.Parent then
            AXON.State.safePlatformPart:Destroy()
        end
        if AXON.State.safePlatformBtnGui then
            AXON.State.safePlatformBtnGui:Destroy()
        end
        for _, fn in ipairs(AXON.State.cleanupFns) do pcall(fn) end
        AXON.SaveConfig()
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
        pcall(function()
            StarterGui:SetCore("SendNotification", { Title = "AXON", Text = "Clean destroy complete", Duration = 4 })
        end)
    end
end)

-- ============================================================
-- FFLAGS
-- ============================================================
local function setFF(name, value)
    local setter = setfflag or set_fflag
    if type(setter) ~= "function" then return false end
    local ok, res = pcall(setter, name, tostring(value))
    return ok and res ~= false
end

function AXON.ApplyJSONFlags(jsonText)
    local ok, data = pcall(HttpService.JSONDecode, HttpService, jsonText)
    if not ok or type(data) ~= "table" then return false, "invalid JSON" end
    local applied, failed = 0, 0
    for name, value in pairs(data) do
        if type(name) == "string" then
            if setFF(name, value) then applied += 1 else failed += 1 end
        end
    end
    if applied > 0 then
        AXON.SaveFFlags(jsonText)
    end
    return true, applied, failed
end

-- ============================================================
-- NOTIFICATION
-- ============================================================
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "AXON",
            Text = text or "",
            Duration = duration or 4,
        })
    end)
end
AXON.notify = notify

-- ============================================================
-- INTRO  (PATCHED: iridescent liquid glass bunny holder)
-- ============================================================
local function playIntro(callback)
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "AXON_Intro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 55000
    introGui.Parent = guiParent

    local blur = Instance.new("BlurEffect", Lighting)
    blur.Size = 32

    local shade = Instance.new("Frame", introGui)
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    shade.BackgroundTransparency = 0
    shade.BorderSizePixel = 0

    local center = Instance.new("Frame", introGui)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.fromScale(0.5, 0.5)
    center.Size = UDim2.fromOffset(500, 200)
    center.BackgroundTransparency = 1

    -- PATCH: iridescent liquid-glass bunny holder
    local bunnyHolder = Instance.new("Frame", center)
    bunnyHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    bunnyHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    bunnyHolder.Size = UDim2.fromOffset(80, 80)
    bunnyHolder.BackgroundColor3 = Color3.fromRGB(14, 16, 26)
    bunnyHolder.BackgroundTransparency = 0.40
    bunnyHolder.BorderSizePixel = 0
    bunnyHolder.ClipsDescendants = true
    Instance.new("UICorner", bunnyHolder).CornerRadius = UDim.new(1, 0)

    -- multi-stop iridescent gradient: blue → violet → teal
    local bhGrad = Instance.new("UIGradient", bunnyHolder)
    bhGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(80,  160, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(180, 100, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(80,  220, 200)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(20,  18,  34)),
    })
    bhGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.45),
        NumberSequenceKeypoint.new(0.5, 0.20),
        NumberSequenceKeypoint.new(1,   0.55),
    })
    bhGrad.Rotation = 135

    -- top-left specular sheen (the "glass" highlight)
    local bhSheen = Instance.new("Frame", bunnyHolder)
    bhSheen.AnchorPoint = Vector2.new(0, 0)
    bhSheen.Position = UDim2.new(0, 0, 0, 0)
    bhSheen.Size = UDim2.fromScale(0.62, 0.48)
    bhSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bhSheen.BackgroundTransparency = 0.80
    bhSheen.BorderSizePixel = 0
    bhSheen.ZIndex = 3
    Instance.new("UICorner", bhSheen).CornerRadius = UDim.new(1, 0)
    local sheenGrad = Instance.new("UIGradient", bhSheen)
    sheenGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- ice-blue iridescent stroke (replaces original purple)
    local bhStk = Instance.new("UIStroke", bunnyHolder)
    bhStk.Color = Color3.fromRGB(150, 215, 255)
    bhStk.Thickness = 1.8
    bhStk.Transparency = 0.22

    local bunnyInner = buildBunnyLogo(bunnyHolder, 1)

    local wordRow = Instance.new("Frame", center)
    wordRow.AnchorPoint = Vector2.new(0.5, 0.5)
    wordRow.Position = UDim2.new(0.5, 0, 0.5, 0)
    wordRow.Size = UDim2.fromOffset(500, 100)
    wordRow.BackgroundTransparency = 1

    local SPACING = 90
    local positions = { A = -(SPACING), X = 0, O = SPACING, N = SPACING * 2 }

    local A = Instance.new("TextLabel", wordRow)
    A.AnchorPoint = Vector2.new(0.5, 0.5)
    A.Position = UDim2.new(0.5, positions.A, 0.5, 0)
    A.Size = UDim2.fromOffset(70, 100)
    A.BackgroundTransparency = 1
    A.Font = Enum.Font.GothamBold
    A.Text = "A"
    A.TextSize = 76
    A.TextColor3 = Color3.fromRGB(220, 245, 255)
    A.TextTransparency = 1

    local X = Instance.new("TextLabel", wordRow)
    X.AnchorPoint = Vector2.new(0.5, 0.5)
    X.Position = UDim2.new(0.5, positions.X, 0.5, 0)
    X.Size = UDim2.fromOffset(70, 100)
    X.BackgroundTransparency = 1
    X.Font = Enum.Font.GothamBold
    X.Text = "X"
    X.TextSize = 76
    X.TextColor3 = Color3.fromRGB(220, 245, 255)
    X.TextTransparency = 1

    local N = Instance.new("TextLabel", wordRow)
    N.AnchorPoint = Vector2.new(0.5, 0.5)
    N.Position = UDim2.new(0.5, positions.N, 0.5, 0)
    N.Size = UDim2.fromOffset(70, 100)
    N.BackgroundTransparency = 1
    N.Font = Enum.Font.GothamBold
    N.Text = "N"
    N.TextSize = 76
    N.TextColor3 = Color3.fromRGB(220, 245, 255)
    N.TextTransparency = 1

    local subtitle = Instance.new("TextLabel", introGui)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.fromScale(0.5, 0.66)
    subtitle.Size = UDim2.fromOffset(600, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.Text = "T H E   S C R I P T   T H A T S   W O R T H   Y O U R   T I M E"
    subtitle.TextSize = 10
    subtitle.TextColor3 = Color3.fromRGB(160, 200, 230)
    subtitle.TextTransparency = 1

    TweenService:Create(bunnyHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.40 }):Play()
    TweenService:Create(bhStk, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.22, Thickness = 2 }):Play()
    if bunnyInner then
        for _, c in ipairs(bunnyInner:GetDescendants()) do
            if c:IsA("Frame") then
                c.BackgroundTransparency = 1
                TweenService:Create(c, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            end
        end
    end
    task.wait(0.6)

    TweenService:Create(bunnyHolder, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, positions.O, 0.5, 0),
    }):Play()
    task.wait(0.2)
    A.TextTransparency = 0
    A.Position = UDim2.new(0.5, positions.A - 40, 0.5, 0)
    TweenService:Create(A, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0, Position = UDim2.new(0.5, positions.A, 0.5, 0), TextSize = 72,
    }):Play()
    task.wait(0.5)

    X.TextTransparency = 0
    X.Position = UDim2.new(0.5, positions.X - 40, 0.5, 0)
    TweenService:Create(X, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0, Position = UDim2.new(0.5, positions.X, 0.5, 0), TextSize = 72,
    }):Play()
    task.wait(0.5)

    N.TextTransparency = 0
    N.Position = UDim2.new(0.5, positions.N + 40, 0.5, 0)
    TweenService:Create(N, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0, Position = UDim2.new(0.5, positions.N, 0.5, 0), TextSize = 72,
    }):Play()
    task.wait(0.5)

    TweenService:Create(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()

    -- PATCH: iridescent pulse on the glass stroke (blue ↔ violet ↔ teal cycle)
    task.spawn(function()
        local colors = {
            Color3.fromRGB(150, 215, 255),
            Color3.fromRGB(200, 130, 255),
            Color3.fromRGB(80,  230, 210),
        }
        local ci = 1
        for i = 1, 6 do
            ci = (ci % #colors) + 1
            TweenService:Create(bhStk, TweenInfo.new(0.22), { Thickness = 3, Transparency = 0.10, Color = colors[ci] }):Play()
            task.wait(0.22)
            TweenService:Create(bhStk, TweenInfo.new(0.22), { Thickness = 1.8, Transparency = 0.30 }):Play()
            task.wait(0.22)
        end
    end)
    task.wait(1.2)

    TweenService:Create(A, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1, TextSize = 30 }):Play()
    TweenService:Create(X, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1, TextSize = 30 }):Play()
    TweenService:Create(N, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1, TextSize = 30 }):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
    TweenService:Create(bunnyHolder, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
    TweenService:Create(bhStk, TweenInfo.new(0.6), { Transparency = 1, Thickness = 0 }):Play()
    if bunnyInner then
        for _, c in ipairs(bunnyInner:GetDescendants()) do
            if c:IsA("Frame") then
                TweenService:Create(c, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
            end
        end
    end
    TweenService:Create(shade, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(blur, TweenInfo.new(0.6), { Size = 0 }):Play()
    task.wait(0.7)
    introGui:Destroy()
    if blur.Parent then blur:Destroy() end
    callback()
end

-- ============================================================
-- KEY SYSTEM MODAL
-- ============================================================
local function showKeyModal(callback)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "AXON_KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.IgnoreGuiInset = true
    keyGui.DisplayOrder = 60000
    keyGui.Parent = guiParent

    local blur = Instance.new("BlurEffect", Lighting)
    blur.Size = 24

    local shade = Instance.new("Frame", keyGui)
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    shade.BackgroundTransparency = 0.2
    shade.BorderSizePixel = 0

    local card = Instance.new("Frame", keyGui)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(420, 300)
    card.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 20)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(130, 210, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3

    local grad = Instance.new("UIGradient", card)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(40,  80, 120)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(30,  20,  60)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(14,  12,  22)),
    })
    grad.Rotation = 130

    local title = Instance.new("TextLabel", card)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.new(0.5, 0, 0, 50)
    title.Size = UDim2.fromOffset(340, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "AXON"
    title.TextSize = 26
    title.TextColor3 = Color3.fromRGB(220, 245, 255)

    local sub = Instance.new("TextLabel", card)
    sub.AnchorPoint = Vector2.new(0.5, 0.5)
    sub.Position = UDim2.new(0.5, 0, 0, 80)
    sub.Size = UDim2.fromOffset(340, 20)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamMedium
    sub.Text = "enter your key to continue"
    sub.TextSize = 11.5
    sub.TextColor3 = Color3.fromRGB(140, 190, 230)

    local inputRow = Instance.new("Frame", card)
    inputRow.AnchorPoint = Vector2.new(0.5, 0.5)
    inputRow.Position = UDim2.new(0.5, 0, 0, 140)
    inputRow.Size = UDim2.fromOffset(320, 44)
    inputRow.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    inputRow.BorderSizePixel = 0
    Instance.new("UICorner", inputRow).CornerRadius = UDim.new(0, 12)
    local inputStroke = Instance.new("UIStroke", inputRow)
    inputStroke.Color = Color3.fromRGB(70, 120, 160)
    inputStroke.Thickness = 1.2

    local keyInput = Instance.new("TextBox", inputRow)
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.fromOffset(10, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.PlaceholderText = "key..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(100, 140, 170)
    keyInput.Text = ""
    keyInput.TextSize = 14
    keyInput.TextColor3 = Color3.fromRGB(210, 240, 255)
    keyInput.ClearTextOnFocus = false

    local statusLbl = Instance.new("TextLabel", card)
    statusLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    statusLbl.Position = UDim2.new(0.5, 0, 0, 175)
    statusLbl.Size = UDim2.fromOffset(320, 18)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.Text = ""
    statusLbl.TextSize = 11
    statusLbl.TextColor3 = Color3.fromRGB(230, 130, 130)

    local enterBtn = Instance.new("TextButton", card)
    enterBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    enterBtn.Position = UDim2.new(0.5, 0, 0, 220)
    enterBtn.Size = UDim2.fromOffset(320, 44)
    enterBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 100)
    enterBtn.BorderSizePixel = 0
    enterBtn.Font = Enum.Font.GothamBold
    enterBtn.Text = "Verify Key"
    enterBtn.TextSize = 13
    enterBtn.TextColor3 = Color3.fromRGB(210, 240, 255)
    Instance.new("UICorner", enterBtn).CornerRadius = UDim.new(0, 12)
    local eStk = Instance.new("UIStroke", enterBtn)
    eStk.Color = Color3.fromRGB(130, 210, 255)
    eStk.Thickness = 1.4

    local unlocked = false

    local function dismiss()
        TweenService:Create(blur, TweenInfo.new(0.5), { Size = 0 }):Play()
        TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.fromScale(0.5, 0.6), BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(shade, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
        task.delay(0.55, function()
            pcall(function() blur:Destroy() end)
            pcall(function() keyGui:Destroy() end)
            callback()
        end)
    end

    local function tryUnlock()
        if unlocked then return end
        local entered = string.lower(string.gsub(keyInput.Text or "", "%s+", ""))
        if entered == AXON_KEY then
            unlocked = true
            statusLbl.Text = "key valid"
            statusLbl.TextColor3 = Color3.fromRGB(140, 240, 170)
            AXON.SaveKey()
            task.delay(0.6, dismiss)
        else
            statusLbl.Text = "invalid key"
            statusLbl.TextColor3 = Color3.fromRGB(230, 130, 130)
            TweenService:Create(card, TweenInfo.new(0.06), { Position = UDim2.new(0.5, 8, 0.5, 0) }):Play()
            task.wait(0.06)
            TweenService:Create(card, TweenInfo.new(0.06), { Position = UDim2.new(0.5, -8, 0.5, 0) }):Play()
            task.wait(0.06)
            TweenService:Create(card, TweenInfo.new(0.1), { Position = UDim2.fromScale(0.5, 0.5) }):Play()
        end
    end

    keyInput.FocusLost:Connect(function(enterPressed) if enterPressed then tryUnlock() end end)
    enterBtn.MouseButton1Click:Connect(tryUnlock)
end

-- ============================================================
-- UI SCALE
-- ============================================================
AXON.UIRefs = { panelRoot = nil, scaleObj = nil, floatingButton = nil, bunnyStroke = nil, safePlatformToggle = nil, fflagsBox = nil }

local function applyUIScale()
    local s = AXON.UIRefs.scaleObj
    if s then
        local v = math.clamp(AXON.Config.uiScale or 1, 0.6, 1.6)
        s.Scale = v
    end
end
AXON.ApplyUIScale = applyUIScale

-- ============================================================
-- CONFIG IO MODAL
-- ============================================================
local function openConfigIO(parent, mode)
    if not parent then return end
    local existing = parent:FindFirstChild("AXON_ConfigIO")
    if existing then existing:Destroy() end

    local th = AXON.GetTheme()
    local modal = Instance.new("Frame", parent)
    modal.Name = "AXON_ConfigIO"
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.Position = UDim2.fromScale(0.5, 0.5)
    modal.Size = UDim2.fromOffset(500, 320)
    modal.BackgroundColor3 = th.bg
    modal.BorderSizePixel = 0
    modal.ZIndex = 200
    modal.ClipsDescendants = true
    Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 16)
    local mStk = Instance.new("UIStroke", modal)
    mStk.Color = th.accent
    mStk.Thickness = 1.4

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1, -60, 0, 32)
    title.Position = UDim2.fromOffset(20, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = (mode == "export") and "EXPORT CONFIG" or "IMPORT CONFIG"
    title.TextSize = 14
    title.TextColor3 = th.bright
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", modal)
    close.Size = UDim2.fromOffset(28, 28)
    close.Position = UDim2.new(1, -40, 0, 12)
    close.BackgroundColor3 = Color3.fromRGB(36, 24, 32)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 130, 130)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.MouseButton1Click:Connect(function() modal:Destroy() end)

    local box = Instance.new("TextBox", modal)
    box.Size = UDim2.new(1, -40, 0, 180)
    box.Position = UDim2.fromOffset(20, 50)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Code
    box.TextSize = 10
    box.TextColor3 = Color3.fromRGB(220, 220, 240)
    box.TextWrapped = true
    box.MultiLine = true
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bStk = Instance.new("UIStroke", box)
    bStk.Color = th.stroke

    if mode == "export" then box.Text = HttpService:JSONEncode(AXON.Config) else box.Text = "" end

    local function pill(label, xPos, w, onClick, color)
        local b = Instance.new("TextButton", modal)
        b.Size = UDim2.fromOffset(w, 32)
        b.Position = UDim2.fromOffset(xPos, 250)
        b.BackgroundColor3 = color or th.row
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.Text = label
        b.TextSize = 11
        b.TextColor3 = Color3.fromRGB(240, 240, 255)
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
        local s = Instance.new("UIStroke", b)
        s.Color = th.stroke
        b.MouseButton1Click:Connect(onClick)
        return b
    end

    if mode == "export" then
        pill("Copy to Clipboard", 20, 150, function() pcall(function() if setclipboard then setclipboard(box.Text) end end) end, Color3.fromRGB(28, 52, 80))
        pill("Close", 180, 90, function() modal:Destroy() end, Color3.fromRGB(24, 24, 32))
    else
        pill("Paste Clipboard", 20, 140, function() pcall(function() local clip = getclipboard and getclipboard() or ""; if clip and #clip > 0 then box.Text = clip end end) end, Color3.fromRGB(22, 44, 64))
        pill("Apply", 170, 100, function()
            pcall(function()
                local data = HttpService:JSONDecode(box.Text)
                if type(data) == "table" then
                    for k, v in pairs(data) do
                        if AXON.Config[k] ~= nil and type(v) == type(AXON.Config[k]) then AXON.Config[k] = v end
                    end
                    AXON.SaveConfig()
                    if AXON.State.currentTheme ~= AXON.Config.theme then AXON.State.currentTheme = AXON.Config.theme; if AXON.RefreshTheme then AXON.RefreshTheme() end end
                    if AXON.RefreshAllToggles then AXON.RefreshAllToggles() end
                    if AXON.ApplyUIScale then AXON.ApplyUIScale() end
                end
            end)
            modal:Destroy()
        end, Color3.fromRGB(30, 60, 42))
        pill("Close", 280, 90, function() modal:Destroy() end, Color3.fromRGB(24, 24, 32))
    end
end
AXON.OpenConfigIO = openConfigIO

-- ============================================================
-- FLOATING MENU BUTTON
-- ============================================================
local function createFloatingMenuButton(panelGui, mainFrame)
    local fbGui = Instance.new("ScreenGui", guiParent)
    fbGui.Name = "AXON_MenuButton"
    fbGui.ResetOnSpawn = false
    fbGui.IgnoreGuiInset = true
    fbGui.DisplayOrder = 998

    local holder = Instance.new("Frame", fbGui)
    holder.Name = "Holder"
    holder.Size = UDim2.fromOffset(58, 58)
    holder.Position = UDim2.new(0, 24, 0, 100)
    holder.BackgroundTransparency = 1
    holder.Active = true

    local glass = Instance.new("Frame", holder)
    glass.Size = UDim2.fromScale(1, 1)
    glass.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
    glass.BackgroundTransparency = 0.30
    glass.BorderSizePixel = 0
    Instance.new("UICorner", glass).CornerRadius = UDim.new(1, 0)

    -- PATCH: iridescent gradient on the floating button glass
    local fbGlassGrad = Instance.new("UIGradient", glass)
    fbGlassGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(80,  160, 255)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(160, 100, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(60,  200, 200)),
    })
    fbGlassGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.70),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(1,   0.72),
    })
    fbGlassGrad.Rotation = 135

    local glassStroke = Instance.new("UIStroke", glass)
    glassStroke.Color = Color3.fromRGB(140, 210, 255)
    glassStroke.Thickness = 1.4
    glassStroke.Transparency = 0.3

    local sheen = Instance.new("Frame", glass)
    sheen.AnchorPoint = Vector2.new(0.5, 0.5)
    sheen.Position = UDim2.new(0.34, 0, 0.30, 0)
    sheen.Size = UDim2.fromScale(0.58, 0.58)
    sheen.BackgroundColor3 = Color3.fromRGB(220, 240, 255)
    sheen.BackgroundTransparency = 0.80
    sheen.BorderSizePixel = 0
    Instance.new("UICorner", sheen).CornerRadius = UDim.new(1, 0)

    local bunny = buildBunnyLogo(glass, 0.7)

    local clickBtn = Instance.new("TextButton", glass)
    clickBtn.Size = UDim2.fromScale(1, 1)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""

    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    clickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos, hasMoved = true, input.Position, holder.Position, false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if d.Magnitude > 5 then hasMoved = true end
            holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and not hasMoved then
                if mainFrame then
                    AXON.State.menuOpen = not AXON.State.menuOpen
                    mainFrame.Visible = AXON.State.menuOpen
                end
            end
            dragging = false
        end
    end)

    -- PATCH: iridescent pulse (blue → violet → teal)
    task.spawn(function()
        local iriColors = {
            Color3.fromRGB(140, 210, 255),
            Color3.fromRGB(200, 130, 255),
            Color3.fromRGB(80,  230, 210),
        }
        local ci = 1
        while holder.Parent do
            ci = (ci % #iriColors) + 1
            TweenService:Create(glassStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.05, Thickness = 2.2, Color = iriColors[ci]
            }):Play()
            task.wait(1.4)
            if not holder.Parent then break end
            TweenService:Create(glassStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.35, Thickness = 1.4
            }):Play()
            task.wait(1.4)
        end
    end)

    AXON.UIRefs.floatingButton = holder
    AXON.UIRefs.bunnyStroke = glassStroke
    return holder
end

-- ============================================================
-- PANEL  (PATCHED: AnchorPoint 0.5,0.5 + auto-center spawn)
-- ============================================================
local function buildPanel()
    if AXON.State.panelBuilt then return end
    AXON.State.panelBuilt = true
    local theme = AXON.GetTheme()

    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = "AXON_Panel"
    panelGui.ResetOnSpawn = false
    panelGui.IgnoreGuiInset = true
    panelGui.DisplayOrder = 999
    panelGui.Parent = guiParent

    local scaleObj = Instance.new("UIScale")
    scaleObj.Scale = math.clamp(AXON.Config.uiScale or 1, 0.6, 1.6)
    AXON.UIRefs.scaleObj = scaleObj

    -- PATCH: AnchorPoint 0.5,0.5 so Position fromScale(0.5,0.5) = true center.
    -- Panel spawns centered and tweens to its resting centered position.
    local main = Instance.new("Frame", panelGui)
    main.Size = UDim2.fromOffset(680, 520)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.BackgroundColor3 = theme.bg
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.Active = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = theme.stroke
    mainStroke.Thickness = 1.5

    local mainGrad = Instance.new("UIGradient", main)
    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.glass),
        ColorSequenceKeypoint.new(1, theme.bg),
    })
    mainGrad.Rotation = 135

    -- PATCH: LiquidGlass main window also gets a frosted glass overlay gradient
    if AXON.State.currentTheme == "LiquidGlass" then
        local lgOverlay = Instance.new("UIGradient", main)
        lgOverlay.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(60,  140, 240)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(140, 80,  240)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(40,  190, 190)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(8,   10,  18)),
        })
        lgOverlay.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.92),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1,   0.95),
        })
        lgOverlay.Rotation = 130
    end

    scaleObj.Parent = main
    AXON.UIRefs.panelRoot = main
    AXON.UIRefs.main = main

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 52)
    header.BackgroundColor3 = theme.card
    header.BackgroundTransparency = 0
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 22)

    local headerGrad = Instance.new("UIGradient", header)
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.accent),
        ColorSequenceKeypoint.new(0.5, theme.accent2),
        ColorSequenceKeypoint.new(1, theme.accent),
    })
    headerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 0.85),
    })
    headerGrad.Rotation = 90

    local logoHolder = Instance.new("Frame", header)
    logoHolder.Size = UDim2.fromOffset(34, 34)
    logoHolder.Position = UDim2.fromOffset(16, 9)
    logoHolder.BackgroundTransparency = 1

    local logoBunny = buildBunnyLogo(logoHolder, 0.42)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.fromOffset(140, 52)
    title.Position = UDim2.fromOffset(58, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "AXON"
    title.TextSize = 20
    title.TextColor3 = theme.bright
    title.TextXAlignment = Enum.TextXAlignment.Left

    local tagline = Instance.new("TextLabel", header)
    tagline.Size = UDim2.fromOffset(200, 52)
    tagline.Position = UDim2.fromOffset(140, 0)
    tagline.BackgroundTransparency = 1
    tagline.Font = Enum.Font.GothamMedium
    tagline.Text = "worth your time"
    tagline.TextSize = 10
    tagline.TextColor3 = Color3.fromRGB(140, 190, 220)
    tagline.TextXAlignment = Enum.TextXAlignment.Left

    local statsLbl = Instance.new("TextLabel", header)
    statsLbl.Size = UDim2.new(0, 260, 1, 0)
    statsLbl.Position = UDim2.new(1, -300, 0, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Font = Enum.Font.Code
    statsLbl.Text = "FPS: --  ·  PING: -- ms"
    statsLbl.TextSize = 11
    statsLbl.TextColor3 = theme.bright
    statsLbl.TextXAlignment = Enum.TextXAlignment.Right

    local collapseBtn = Instance.new("TextButton", header)
    collapseBtn.Size = UDim2.fromOffset(28, 28)
    collapseBtn.Position = UDim2.new(1, -38, 0, 12)
    collapseBtn.BackgroundTransparency = 1
    collapseBtn.Font = Enum.Font.GothamBold
    collapseBtn.Text = "—"
    collapseBtn.TextSize = 16
    collapseBtn.TextColor3 = theme.bright

    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos = true, input.Position, main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                -- Keep using offset-relative drag since AnchorPoint is 0.5,0.5
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    do
        local frames, lastUpdate = 0, tick()
        RunService.RenderStepped:Connect(function()
            frames += 1
            local now = tick()
            if now - lastUpdate >= 0.5 then
                local fps = math.floor(frames / (now - lastUpdate))
                frames, lastUpdate = 0, now
                local ping = 0
                pcall(function()
                    local stats = game:GetService("Stats")
                    local net = stats:FindFirstChild("Network")
                    local item = net and net:FindFirstChild("ServerStatsItem") and net.ServerStatsItem:FindFirstChild("Data Ping")
                    if item then local n = tonumber(item:GetValueString():match("[%d%.]+")); if n then ping = math.floor(n) end end
                end)
                statsLbl.Text = string.format("FPS: %d  ·  PING: %d ms", fps, ping)
            end
        end)
    end

    local tabs = {
        { id = "home",      label = "Home" },
        { id = "combat",    label = "Combat" },
        { id = "movement",  label = "Movement" },
        { id = "soru",      label = "Auto Soru" },
        { id = "macro",     label = "Macro" },
        { id = "blacklist", label = "Blacklist" },
        { id = "visuals",   label = "Visuals" },
        { id = "esp",       label = "ESP" },
        { id = "fflags",    label = "FFlags" },
        { id = "configs",   label = "Configs" },
        { id = "themes",    label = "Themes" },
        { id = "binds",     label = "Keybinds" },
    }

    local TAB_H = 36
    local sidebarHeight = #tabs * (TAB_H + 4) + 20
    local mainHeight = math.max(400, sidebarHeight + 64)
    main.Size = UDim2.fromOffset(680, mainHeight)

    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -60)
    sidebar.Position = UDim2.fromOffset(0, 60)
    sidebar.BackgroundColor3 = theme.card
    sidebar.BackgroundTransparency = 0
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 4
    sidebar.ScrollBarImageColor3 = theme.accent
    sidebar.CanvasSize = UDim2.new(0, 0, 0, #tabs * (TAB_H + 4) + 20)
    sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 0)

    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local sidePad = Instance.new("UIPadding", sidebar)
    sidePad.PaddingTop = UDim.new(0, 12)
    sidePad.PaddingLeft = UDim.new(0, 10)
    sidePad.PaddingRight = UDim.new(0, 10)
    sidePad.PaddingBottom = UDim.new(0, 12)

    local pagesFrame = Instance.new("Frame", main)
    pagesFrame.Size = UDim2.new(1, -180, 1, -60)
    pagesFrame.Position = UDim2.fromOffset(180, 60)
    pagesFrame.BackgroundTransparency = 1

    local pages = {}
    local function createPage(id)
        local sf = Instance.new("ScrollingFrame", pagesFrame)
        sf.Name = "page_" .. id
        sf.Size = UDim2.new(1, 0, 1, 0)
        sf.Position = UDim2.fromOffset(0, 0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 6
        sf.ScrollBarImageColor3 = theme.accent
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.Visible = false
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.ScrollingDirection = Enum.ScrollingDirection.Y
        local lay = Instance.new("UIListLayout", sf)
        lay.Padding = UDim.new(0, 10)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local pad = Instance.new("UIPadding", sf)
        pad.PaddingTop = UDim.new(0, 14)
        pad.PaddingBottom = UDim.new(0, 14)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pages[id] = sf
        return sf
    end
    for _, t in ipairs(tabs) do createPage(t.id) end

    local currentTab = "home"
    local tabButtons = {}
    local function showTab(id)
        currentTab = id
        for tid, page in pairs(pages) do page.Visible = (tid == id) end
        local th = AXON.GetTheme()
        for tid, btn in pairs(tabButtons) do
            local on = (tid == id)
            btn.BackgroundColor3 = on and th.row or th.card
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Color = on and th.accent or th.stroke end
            local lbl = btn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = on and th.bright or Color3.fromRGB(170, 170, 185) end
            local ind = btn:FindFirstChild("Indicator")
            if ind then ind.Visible = on end
        end
    end

    for i, t in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, 0, 0, TAB_H)
        btn.BackgroundColor3 = (i == 1) and theme.row or theme.card
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.LayoutOrder = i
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", btn)
        st.Color = (i == 1) and theme.accent or theme.stroke
        st.Thickness = 1

        local ind = Instance.new("Frame", btn)
        ind.Name = "Indicator"
        ind.Size = UDim2.new(0, 3, 0, 16)
        ind.Position = UDim2.new(0, 6, 0.5, -8)
        ind.BackgroundColor3 = theme.accent
        ind.BorderSizePixel = 0
        ind.Visible = (i == 1)
        Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "TabLabel"
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.fromOffset(18, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = t.label
        lbl.TextSize = 12
        lbl.TextColor3 = (i == 1) and theme.bright or Color3.fromRGB(170, 170, 185)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseButton1Click:Connect(function() showTab(t.id) end)
        tabButtons[t.id] = btn
    end
    showTab("home")

    local collapsed = false
    collapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        sidebar.Visible = not collapsed
        pagesFrame.Visible = not collapsed
        main.Size = collapsed and UDim2.fromOffset(680, 60) or UDim2.fromOffset(680, mainHeight)
        collapseBtn.Text = collapsed and "+" or "—"
    end)

    local function sectionLabel(parent, text)
        local lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = text
        lbl.TextSize = 11
        lbl.TextColor3 = theme.accent
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return lbl
    end

    -- ── PATCHED card() — LiquidGlass gets frosted gradient + specular sheen ──
    local function card(parent, title)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1, 0, 0, 0)
        f.AutomaticSize = Enum.AutomaticSize.Y
        f.BackgroundColor3 = theme.row
        f.BackgroundTransparency = 0
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)
        local st = Instance.new("UIStroke", f)
        st.Color = theme.stroke
        st.Thickness = 1

        -- LiquidGlass frosted glass overlay on every card
        if AXON.State.currentTheme == "LiquidGlass" then
            local glassGrad = Instance.new("UIGradient", f)
            glassGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromRGB(80,  160, 255)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(160, 100, 255)),
                ColorSequenceKeypoint.new(0.70, Color3.fromRGB(60,  210, 200)),
                ColorSequenceKeypoint.new(1,    Color3.fromRGB(20,  24,  38)),
            })
            glassGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,   0.88),
                NumberSequenceKeypoint.new(0.5, 0.78),
                NumberSequenceKeypoint.new(1,   0.92),
            })
            glassGrad.Rotation = 130
            -- top-left specular sheen
            local cardSheen = Instance.new("Frame", f)
            cardSheen.AnchorPoint = Vector2.new(0, 0)
            cardSheen.Position = UDim2.new(0, 0, 0, 0)
            cardSheen.Size = UDim2.fromScale(0.55, 0.35)
            cardSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            cardSheen.BackgroundTransparency = 0.86
            cardSheen.BorderSizePixel = 0
            cardSheen.ZIndex = f.ZIndex + 1
            Instance.new("UICorner", cardSheen).CornerRadius = UDim.new(1, 0)
            local csGrad = Instance.new("UIGradient", cardSheen)
            csGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.30),
                NumberSequenceKeypoint.new(1, 1),
            })
            st.Color = Color3.fromRGB(100, 180, 230)
            st.Thickness = 1.2
        end

        local pad = Instance.new("UIPadding", f)
        pad.PaddingTop = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        local lay = Instance.new("UIListLayout", f)
        lay.Padding = UDim.new(0, 7)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        if title then
            local h = Instance.new("TextLabel", f)
            h.Size = UDim2.new(1, 0, 0, 18)
            h.BackgroundTransparency = 1
            h.Font = Enum.Font.GothamBold
            h.Text = title
            h.TextSize = 11
            h.TextColor3 = theme.bright
            h.TextXAlignment = Enum.TextXAlignment.Left
        end
        return f
    end

    local toggleRefs = {}
    local function toggle(parent, configKey, label, onChange)
        local row = Instance.new("TextButton", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = theme.card
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        row.AutoButtonColor = false
        row.Text = ""
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local stk = Instance.new("UIStroke", row)
        stk.Color = theme.stroke
        stk.Thickness = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.fromOffset(14, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = label
        lbl.TextSize = 11.5
        lbl.TextColor3 = Color3.fromRGB(225, 225, 240)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.fromOffset(40, 20)
        pill.Position = UDim2.new(1, -52, 0.5, -10)
        pill.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local pStk = Instance.new("UIStroke", pill)
        pStk.Color = theme.stroke
        pStk.Thickness = 1

        local knob = Instance.new("Frame", pill)
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(120, 160, 180)
        knob.BorderSizePixel = 0
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function refresh()
            local on = AXON.Config[configKey] == true
            local th = AXON.GetTheme()
            TweenService:Create(pill, TweenInfo.new(0.18), { BackgroundColor3 = on and th.accent or Color3.fromRGB(20, 26, 38) }):Play()
            TweenService:Create(pStk, TweenInfo.new(0.18), { Color = on and th.bright or th.stroke }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 160, 180),
            }):Play()
        end
        refresh()
        toggleRefs[configKey] = refresh

        row.MouseButton1Click:Connect(function()
            AXON.Config[configKey] = not AXON.Config[configKey]
            refresh()
            AXON.SaveConfig()
            if onChange then pcall(onChange, AXON.Config[configKey]) end
        end)
        return row
    end

    local function action(parent, label, fn)
        local row = Instance.new("TextButton", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = theme.card
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        row.AutoButtonColor = false
        row.Font = Enum.Font.GothamMedium
        row.Text = label
        row.TextSize = 11.5
        row.TextColor3 = Color3.fromRGB(225, 225, 240)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local stk = Instance.new("UIStroke", row)
        stk.Color = theme.stroke
        stk.Thickness = 1
        row.MouseButton1Click:Connect(function() pcall(fn) end)
        return row
    end

    local function numInput(parent, configKey, label, minV, maxV, step)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = theme.card
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local stk = Instance.new("UIStroke", row)
        stk.Color = theme.stroke
        stk.Thickness = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.55, -10, 1, 0)
        lbl.Position = UDim2.fromOffset(14, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = label
        lbl.TextSize = 11
        lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local box = Instance.new("TextBox", row)
        box.Size = UDim2.new(0.40, -14, 1, -8)
        box.Position = UDim2.new(0.58, 0, 0, 4)
        box.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
        box.BorderSizePixel = 0
        box.Font = Enum.Font.GothamMedium
        box.Text = tostring(AXON.Config[configKey])
        box.TextSize = 11.5
        box.TextColor3 = Color3.fromRGB(210, 240, 255)
        box.ClearTextOnFocus = false
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local bStk = Instance.new("UIStroke", box)
        bStk.Color = theme.stroke

        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then
                n = math.clamp(n, minV, maxV)
                if step then n = math.floor(n / step + 0.5) * step end
                AXON.Config[configKey] = n
                box.Text = tostring(n)
                AXON.SaveConfig()
                if AXON.ApplyUIScale and configKey == "uiScale" then AXON.ApplyUIScale() end
            else
                box.Text = tostring(AXON.Config[configKey])
            end
        end)
        return row
    end

    local function cycle(parent, label, choices, configKey, extraSet)
        local row = Instance.new("TextButton", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = theme.card
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        row.AutoButtonColor = false
        row.Text = ""
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local stk = Instance.new("UIStroke", row)
        stk.Color = theme.stroke
        stk.Thickness = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -14, 1, 0)
        lbl.Position = UDim2.fromOffset(14, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 11.5
        lbl.TextColor3 = Color3.fromRGB(225, 225, 240)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local idx = table.find(choices, AXON.Config[configKey]) or 1
        local function refresh() lbl.Text = label .. ":  " .. tostring(choices[idx]) end
        refresh()
        row.MouseButton1Click:Connect(function()
            idx = (idx % #choices) + 1
            AXON.Config[configKey] = choices[idx]
            refresh()
            AXON.SaveConfig()
            if extraSet then pcall(extraSet, choices[idx]) end
        end)
        return row
    end

    -- HOME
    do
        local p = pages.home
        local homeCard = card(p, "PLAYER PROFILE")
        local avatarRow = Instance.new("Frame", homeCard)
        avatarRow.Size = UDim2.new(1, 0, 0, 100)
        avatarRow.BackgroundTransparency = 1

        local avatarFrame = Instance.new("Frame", avatarRow)
        avatarFrame.Size = UDim2.fromOffset(88, 88)
        avatarFrame.Position = UDim2.fromOffset(0, 6)
        avatarFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
        avatarFrame.BorderSizePixel = 0
        avatarFrame.ClipsDescendants = true
        Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(0, 16)
        local avStroke = Instance.new("UIStroke", avatarFrame)
        avStroke.Color = theme.accent
        avStroke.Thickness = 1.8

        local avatar = Instance.new("ImageLabel", avatarFrame)
        avatar.Size = UDim2.fromScale(1, 1)
        avatar.BackgroundTransparency = 1
        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
        avatar.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 16)
        task.spawn(function()
            pcall(function()
                local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                if thumb and thumb ~= "" then avatar.Image = thumb end
            end)
        end)

        local nameLbl = Instance.new("TextLabel", avatarRow)
        nameLbl.Size = UDim2.new(1, -110, 0, 26)
        nameLbl.Position = UDim2.fromOffset(104, 8)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = LocalPlayer.DisplayName or LocalPlayer.Name
        nameLbl.TextSize = 18
        nameLbl.TextColor3 = Color3.fromRGB(220, 245, 255)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local tagLbl = Instance.new("TextLabel", avatarRow)
        tagLbl.Size = UDim2.new(1, -110, 0, 18)
        tagLbl.Position = UDim2.fromOffset(104, 34)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Font = Enum.Font.GothamMedium
        tagLbl.Text = "@" .. LocalPlayer.Name
        tagLbl.TextSize = 11.5
        tagLbl.TextColor3 = Color3.fromRGB(120, 170, 210)
        tagLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel", avatarRow)
        descLbl.Size = UDim2.new(1, -110, 0, 40)
        descLbl.Position = UDim2.fromOffset(104, 54)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = Enum.Font.GothamMedium
        descLbl.Text = "A proud member of the Blox Fruits seas.\nReady to dominate with Axon."
        descLbl.TextSize = 10.5
        descLbl.TextColor3 = Color3.fromRGB(160, 200, 225)
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextWrapped = true

        local statsCard = card(p, "STATISTICS")
        local statRow = Instance.new("Frame", statsCard)
        statRow.Size = UDim2.new(1, 0, 0, 90)
        statRow.BackgroundTransparency = 1

        local function statBox(xPos, w, caption, value)
            local bx = Instance.new("Frame", statRow)
            bx.Size = UDim2.fromOffset(w, 80)
            bx.Position = UDim2.fromOffset(xPos, 4)
            bx.BackgroundColor3 = theme.card
            bx.BorderSizePixel = 0
            Instance.new("UICorner", bx).CornerRadius = UDim.new(0, 12)
            local st = Instance.new("UIStroke", bx)
            st.Color = theme.stroke
            local cap = Instance.new("TextLabel", bx)
            cap.Size = UDim2.new(1, -16, 0, 16)
            cap.Position = UDim2.fromOffset(12, 10)
            cap.BackgroundTransparency = 1
            cap.Font = Enum.Font.GothamBold
            cap.Text = caption
            cap.TextSize = 9.5
            cap.TextColor3 = Color3.fromRGB(110, 160, 190)
            cap.TextXAlignment = Enum.TextXAlignment.Left
            local val = Instance.new("TextLabel", bx)
            val.Size = UDim2.new(1, -16, 0, 34)
            val.Position = UDim2.fromOffset(12, 30)
            val.BackgroundTransparency = 1
            val.Font = Enum.Font.GothamBold
            val.Text = value
            val.TextSize = 24
            val.TextColor3 = theme.bright
            val.TextXAlignment = Enum.TextXAlignment.Left
            val.TextTruncate = Enum.TextTruncate.AtEnd
            return val
        end

        local levelVal = statBox(0, 160, "LEVEL", "—")
        local bountyVal = statBox(170, 270, "BOUNTY / HONOR", "—")

        local factionLbl = Instance.new("TextLabel", statsCard)
        factionLbl.Size = UDim2.new(1, 0, 0, 20)
        factionLbl.BackgroundTransparency = 1
        factionLbl.Font = Enum.Font.GothamMedium
        factionLbl.Text = "Faction:  —"
        factionLbl.TextSize = 11.5
        factionLbl.TextColor3 = Color3.fromRGB(170, 210, 230)
        factionLbl.TextXAlignment = Enum.TextXAlignment.Left

        local function refreshHome()
            pcall(function()
                local lvl = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
                levelVal.Text = lvl and tostring(lvl.Value) or "—"
                local ls = LocalPlayer:FindFirstChild("leaderstats")
                if ls then
                    local b = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
                    if b then
                        local n = tonumber(b.Value) or 0
                        if n >= 1e9 then bountyVal.Text = string.format("%.2fB", n/1e9)
                        elseif n >= 1e6 then bountyVal.Text = string.format("%.2fM", n/1e6)
                        elseif n >= 1e3 then bountyVal.Text = string.format("%.1fK", n/1e3)
                        else bountyVal.Text = tostring(n) end
                    end
                end
                factionLbl.Text = "Faction:  " .. (LocalPlayer.Team and LocalPlayer.Team.Name or "None")
            end)
        end
        refreshHome()
        AXON.State.homeRefresh = refreshHome
        task.spawn(function()
            while main.Parent do
                task.wait(1.5)
                if AXON.State.homeRefresh then AXON.State.homeRefresh() end
            end
        end)
    end

    -- COMBAT
    do
        local p = pages.combat
        sectionLabel(p, "AIMBOT")
        local aimCard = card(p)
        toggle(aimCard, "aimEnabled", "Enable Aimbot", function(v)
            if not v then AXON.State.stickyTarget = nil; AXON.State.stickyCount = 0 end
        end)
        toggle(aimCard, "silentAim", "Silent Aim")
        toggle(aimCard, "hookUnitRay", "Hook UnitRay")
        toggle(aimCard, "hookMouseModule", "Hook Mouse Module")
        toggle(aimCard, "rotateHRP", "Face Target on Skill")
        toggle(aimCard, "stickyAim", "Sticky Aim")
        toggle(aimCard, "teamCheck", "Team Check")
        toggle(aimCard, "pvpCheck", "PvP Check")
        toggle(aimCard, "safeZoneCheck", "SafeZone Check")
        toggle(aimCard, "ignoreLowLevel", "Ignore Low Level")
        toggle(aimCard, "predict", "Prediction")
        toggle(aimCard, "prioritizeLowHealth", "Prioritize Low Health")
        toggle(aimCard, "blacklistAimbot", "Respect Blacklist")

        sectionLabel(p, "TARGET")
        local tgtCard = card(p)
        cycle(tgtCard, "Target kind", { "Player", "NPC" }, "aimTargetKind")
        cycle(tgtCard, "Aim mode", { "360", "180", "FOV" }, "aimMode")
        cycle(tgtCard, "FOV origin", { "Screen", "Mouse" }, "aimFovOrigin")
        cycle(tgtCard, "Target policy", { "Nearest", "Selected" }, "aimTargetPolicy")
        numInput(tgtCard, "aimFovRadius", "FOV radius (px)", 40, 3000, 10)
        numInput(tgtCard, "aimRange", "Aim range (studs)", 100, 3000, 50)
        numInput(tgtCard, "predictAmount", "Lead amount", 0, 0.5, 0.01)
        numInput(tgtCard, "aimSmooth", "Smoothness", 0.05, 1.0, 0.05)

        sectionLabel(p, "FAST ATTACK")
        local faCard = card(p)
        toggle(faCard, "fastAttack", "Fast Attack")
        numInput(faCard, "fastAttackDelay", "Delay (s)", 0.03, 1, 0.01)
        numInput(faCard, "fastAttackRange", "Range (studs)", 20, 500, 5)

        sectionLabel(p, "GUN AURA")
        local gaCard = card(p)
        toggle(gaCard, "gunAura", "Gun Aura")
        numInput(gaCard, "gunAuraDelay", "Delay (s)", 0.05, 1, 0.01)
        numInput(gaCard, "gunAuraRange", "Range (studs)", 50, 2000, 25)

        sectionLabel(p, "SAFE PLATFORM")
        local spCard = card(p)
        local spToggle = toggle(spCard, "safePlatform", "Auto Teleport to Safe Platform")
        AXON.UIRefs.safePlatformToggle = { refresh = toggleRefs["safePlatform"] }
        numInput(spCard, "safePlatformDist", "Distance (studs)", 2, 10000, 10)
        toggle(spCard, "safePlatformBtn", "Show On-Screen Button", function(v)
            if AXON.State.safePlatformBtnGui then AXON.State.safePlatformBtnGui:Destroy(); AXON.State.safePlatformBtnGui = nil end
            if v then createSafePlatformButton() end
        end)

        sectionLabel(p, "TRACER")
        local trCard = card(p)
        toggle(trCard, "showTracer", "Show Tracer")
        numInput(trCard, "tracerThick", "Thickness (px)", 0.5, 6, 0.5)

        sectionLabel(p, "TWEEN TO PLAYER")
        local twCard = card(p)
        toggle(twCard, "tweenToPlayer", "Tween to aim target")
        numInput(twCard, "tweenSpeed", "Speed", 50, 1000, 25)
    end

    -- MOVEMENT
    do
        local p = pages.movement
        sectionLabel(p, "WALKSPEED")
        local wc = card(p)
        toggle(wc, "walkSpeed", "Enable WalkSpeed")
        numInput(wc, "walkSpeedValue", "Walk value", 16, 1500, 8)

        sectionLabel(p, "DASH SPEED")
        local dc = card(p)
        toggle(dc, "dashSpeed", "Enable Dash Speed")
        numInput(dc, "dashSpeedValue", "Dash value", 50, 2500, 50)
        action(dc, "Trigger Dash Now (Q)", function() AXON.triggerDash() end)

        sectionLabel(p, "SUPER JUMP")
        local sc = card(p)
        toggle(sc, "superJump", "Enable Super Jump")
        numInput(sc, "superJumpPower", "Jump power", 50, 8000, 50)
        action(sc, "Jump Now", function() AXON.doSuperJump() end)
    end

    -- SORU
    do
        local p = pages.soru
        sectionLabel(p, "AUTO SORU")
        local sc = card(p)
        toggle(sc, "skillSoru", "Enable Auto Soru")
        toggle(sc, "autoAimSoru", "Auto Aim Soru (Teleport)")
        toggle(sc, "soruTriggerR", "Trigger on R")
        toggle(sc, "flashstepToggle", "Enable Flashstep")
        toggle(sc, "soruOnAnim", "Trigger on Flashstep Animation")
        cycle(sc, "Target", { "Tracer", "Nearest" }, "soruTarget")
        cycle(sc, "Weapon", { "Melee", "Fruit", "Sword", "Gun" }, "soruWeapon")
        cycle(sc, "Skill", { "Z", "X", "C", "V", "F" }, "soruSkill")
        numInput(sc, "soruDelay", "Delay (s)", 0.05, 1.0, 0.01)
    end

    -- MACRO
    do
        local p = pages.macro
        sectionLabel(p, "MACRO")
        local mc = card(p)
        toggle(mc, "macroEnabled", "Enable Macro")
        toggle(mc, "macroLoop", "Loop Combo")
        action(mc, "Run Combo (T)", function() AXON.RunMacro() end)
        action(mc, "Stop Combo", function() AXON.StopMacro() end)

        sectionLabel(p, "MACRO STEPS")
        local stepsCard = card(p)
        for i, step in ipairs(AXON.Config.macroSteps) do
            local row = Instance.new("Frame", stepsCard)
            row.Size = UDim2.new(1, 0, 0, 32)
            row.BackgroundColor3 = theme.card
            row.BorderSizePixel = 0
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", row)
            st.Color = theme.stroke
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0.35, -10, 1, 0)
            lbl.Position = UDim2.fromOffset(12, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = "#" .. i
            lbl.TextSize = 11
            lbl.TextColor3 = theme.bright
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local weaponBtn = Instance.new("TextButton", row)
            weaponBtn.Size = UDim2.new(0, 70, 0, 24)
            weaponBtn.Position = UDim2.new(0.30, 0, 0.5, -12)
            weaponBtn.BackgroundColor3 = theme.row
            weaponBtn.Font = Enum.Font.GothamBold
            weaponBtn.Text = step.weapon or "Melee"
            weaponBtn.TextSize = 10
            weaponBtn.TextColor3 = theme.bright
            Instance.new("UICorner", weaponBtn).CornerRadius = UDim.new(0, 6)
            local weaponChoices = { "Melee", "Sword", "Fruit", "Gun", "None" }
            weaponBtn.MouseButton1Click:Connect(function()
                local wIdx = table.find(weaponChoices, step.weapon) or 1
                wIdx = (wIdx % #weaponChoices) + 1
                step.weapon = weaponChoices[wIdx]
                weaponBtn.Text = step.weapon
                AXON.SaveConfig()
            end)
            local skillBtn = Instance.new("TextButton", row)
            skillBtn.Size = UDim2.new(0, 60, 0, 24)
            skillBtn.Position = UDim2.new(0.55, 0, 0.5, -12)
            skillBtn.BackgroundColor3 = theme.row
            skillBtn.Font = Enum.Font.GothamBold
            skillBtn.Text = step.skill or "Z"
            skillBtn.TextSize = 10
            skillBtn.TextColor3 = theme.bright
            Instance.new("UICorner", skillBtn).CornerRadius = UDim.new(0, 6)
            local skillChoices = { "Z", "X", "C", "V", "F", "TAP", "V3" }
            skillBtn.MouseButton1Click:Connect(function()
                local sIdx = table.find(skillChoices, step.skill) or 1
                sIdx = (sIdx % #skillChoices) + 1
                step.skill = skillChoices[sIdx]
                skillBtn.Text = step.skill
                AXON.SaveConfig()
            end)
            local toggleBtn = Instance.new("TextButton", row)
            toggleBtn.Size = UDim2.new(0, 50, 0, 24)
            toggleBtn.Position = UDim2.new(1, -62, 0.5, -12)
            toggleBtn.BackgroundColor3 = step.enabled and theme.accent or theme.row
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Text = step.enabled and "ON" or "OFF"
            toggleBtn.TextSize = 10
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
            toggleBtn.MouseButton1Click:Connect(function()
                step.enabled = not step.enabled
                toggleBtn.Text = step.enabled and "ON" or "OFF"
                toggleBtn.BackgroundColor3 = step.enabled and theme.accent or theme.row
                AXON.SaveConfig()
            end)
        end
    end

    -- BLACKLIST
    do
        local p = pages.blacklist
        sectionLabel(p, "BLACKLIST FILTER")
        local bc = card(p)
        toggle(bc, "blEnabled", "Enable Blacklist Filter")

        sectionLabel(p, "CATEGORY WIDE")
        local cat = card(p)
        toggle(cat, "blMelee", "All Melee")
        toggle(cat, "blFruit", "All Fruit")
        toggle(cat, "blSword", "All Sword")
        toggle(cat, "blGun", "All Gun")

        sectionLabel(p, "MELEE")
        local ml = card(p)
        toggle(ml, "blMeleeZ", "Melee Z")
        toggle(ml, "blMeleeX", "Melee X")
        toggle(ml, "blMeleeC", "Melee C")

        sectionLabel(p, "FRUIT")
        local fr = card(p)
        toggle(fr, "blFruitM1", "Fruit M1")
        toggle(fr, "blFruitZ", "Fruit Z")
        toggle(fr, "blFruitX", "Fruit X")
        toggle(fr, "blFruitC", "Fruit C")
        toggle(fr, "blFruitV", "Fruit V")
        toggle(fr, "blFruitF", "Fruit F")

        sectionLabel(p, "SWORD")
        local sw = card(p)
        toggle(sw, "blSwordZ", "Sword Z")
        toggle(sw, "blSwordX", "Sword X")

        sectionLabel(p, "GUN")
        local gn = card(p)
        toggle(gn, "blGunZ", "Gun Z")
        toggle(gn, "blGunX", "Gun X")
        toggle(gn, "blGunM1", "Gun M1")
    end

    -- VISUALS
    do
        local p = pages.visuals
        sectionLabel(p, "TRACER")
        local vc = card(p)
        toggle(vc, "showTracer", "Show Tracer")
        numInput(vc, "tracerThick", "Tracer thickness", 0.5, 6, 0.5)
    end

    -- ESP
    do
        local p = pages.esp
        sectionLabel(p, "ESP")
        local ec = card(p)
        toggle(ec, "espEnabled", "Enable ESP")
        toggle(ec, "espShowName", "Show Name")
        toggle(ec, "espShowHealth", "Show Health")
        toggle(ec, "espShowPvP", "Show PvP Status")
        toggle(ec, "espShowBounty", "Show Bounty")
        toggle(ec, "espShowDistance", "Show Distance")
    end

    -- FFLAGS
    do
        local p = pages.fflags
        sectionLabel(p, "FFLAGS / FPS BOOST")
        local fc = card(p)
        local jsonBox = Instance.new("TextBox", fc)
        jsonBox.Name = "SpookyFFlagsBox"
        jsonBox.Size = UDim2.new(1, -20, 0, 100)
        jsonBox.Position = UDim2.new(0, 10, 0, 26)
        jsonBox.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
        jsonBox.Text = ""
        jsonBox.PlaceholderText = '{"DFIntTaskSchedulerTargetFps": "240", "FFlagDisablePostFx": "True"}'
        jsonBox.PlaceholderColor3 = Color3.fromRGB(100, 140, 170)
        jsonBox.TextColor3 = Color3.fromRGB(210, 240, 255)
        jsonBox.Font = Enum.Font.Code
        jsonBox.TextSize = 10
        jsonBox.MultiLine = true
        jsonBox.TextWrapped = true
        jsonBox.ClearTextOnFocus = false
        Instance.new("UICorner", jsonBox).CornerRadius = UDim.new(0, 8)
        local jbStk = Instance.new("UIStroke", jsonBox)
        jbStk.Color = theme.stroke
        AXON.UIRefs.fflagsBox = jsonBox

        action(fc, "Apply JSON Flags", function()
            local ok, res, failed = AXON.ApplyJSONFlags(jsonBox.Text)
            if ok then
                notify("FFlags", "Applied: " .. tostring(res) .. " | Failed: " .. tostring(failed))
            else
                notify("FFlags", "Error: " .. tostring(res))
            end
        end)

        action(fc, "Apply Default Best FPS Flags", function()
            local defaultFlags = {
                ["DFIntTaskSchedulerTargetFps"] = "240",
                ["FFlagDisablePostFx"] = "True",
                ["FIntFRMMaxGrassDistance"] = "0",
                ["FIntFRMMinGrassDistance"] = "0",
                ["DebugFRMQualityLevelOverride"] = "1",
                ["TextureQualityOverride"] = "0"
            }
            local json = HttpService:JSONEncode(defaultFlags)
            jsonBox.Text = json
            local ok, res, failed = AXON.ApplyJSONFlags(json)
            if ok then
                notify("FFlags", "Applied default FPS flags. Failed: " .. tostring(failed))
            end
        end)
    end

    -- CONFIGS
    do
        local p = pages.configs
        sectionLabel(p, "CONFIG MANAGEMENT")
        local cc = card(p)
        action(cc, "Save config to disk", function() AXON.SaveConfig(); notify("AXON", "Config saved") end)
        action(cc, "Load config from disk", function()
            AXON.LoadConfig()
            if AXON.RefreshAllToggles then AXON.RefreshAllToggles() end
            if AXON.ApplyUIScale then AXON.ApplyUIScale() end
            notify("AXON", "Config loaded")
        end)
        action(cc, "Export config", function() openConfigIO(main, "export") end)
        action(cc, "Import config", function() openConfigIO(main, "import") end)
    end

    -- THEMES
    do
        local p = pages.themes
        sectionLabel(p, "THEME")
        local tc = card(p)
        for _, name in ipairs(AXON.ThemeOrder) do
            action(tc, "Apply " .. name, function()
                AXON.State.currentTheme = name
                AXON.Config.theme = name
                AXON.SaveConfig()
                if AXON.RefreshTheme then AXON.RefreshTheme() end
            end)
        end
        sectionLabel(p, "UI SCALE")
        local sc = card(p)
        numInput(sc, "uiScale", "Scale (0.6 – 1.6)", 0.6, 1.6, 0.05)
    end

    -- KEYBINDS
    do
        local p = pages.binds
        sectionLabel(p, "KEYBINDS — Click to Rebind")
        local kc = card(p)
        local bindRows = {}
        local bindDefs = {
            { id = "aimToggle", label = "Toggle Aimbot" },
            { id = "silentToggle", label = "Toggle Silent Aim" },
            { id = "menuToggle", label = "Toggle Menu" },
            { id = "autoSoru", label = "Auto Soru" },
            { id = "dash", label = "Trigger Dash" },
            { id = "superJump", label = "Super Jump" },
            { id = "macro", label = "Run Macro" },
            { id = "macroV3", label = "Macro V3 Ability" },
            { id = "safePlatform", label = "Toggle Safe Platform" },
            { id = "destroy", label = "Destroy UI" },
        }
        local function info(id, label)
            local row = Instance.new("Frame", kc)
            row.Size = UDim2.new(1, 0, 0, 32)
            row.BackgroundColor3 = theme.card
            row.BorderSizePixel = 0
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", row)
            st.Color = theme.stroke
            local l = Instance.new("TextLabel", row)
            l.Size = UDim2.new(0.6, -10, 1, 0)
            l.Position = UDim2.fromOffset(14, 0)
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.GothamMedium
            l.Text = label
            l.TextSize = 11
            l.TextColor3 = Color3.fromRGB(190, 220, 240)
            l.TextXAlignment = Enum.TextXAlignment.Left
            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(0.36, -8, 1, -6)
            btn.Position = UDim2.new(0.62, 0, 0, 3)
            btn.BackgroundColor3 = theme.row
            btn.Font = Enum.Font.GothamBold
            btn.Text = AXON.State.keybinds[id] and AXON.State.keybinds[id].Name or "None"
            btn.TextSize = 11
            btn.TextColor3 = theme.bright
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local stk = Instance.new("UIStroke", btn)
            stk.Color = theme.stroke
            btn.MouseButton1Click:Connect(function()
                AXON.State.listeningBind = id
                btn.Text = "..."
                btn.TextColor3 = Color3.fromRGB(255, 200, 80)
            end)
            bindRows[id] = btn
        end
        for _, def in ipairs(bindDefs) do info(def.id, def.label) end
        AXON.RefreshBindLabels = function()
            for id, btn in pairs(bindRows) do
                if btn and btn.Parent then
                    btn.Text = AXON.State.keybinds[id] and AXON.State.keybinds[id].Name or "None"
                    btn.TextColor3 = theme.bright
                end
            end
        end
    end

    AXON.RefreshTheme = function()
        local th = AXON.GetTheme()
        main.BackgroundColor3 = th.bg
        mainStroke.Color = th.stroke
        mainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, th.glass),
            ColorSequenceKeypoint.new(1, th.bg),
        })
        header.BackgroundColor3 = th.card
        headerGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, th.accent),
            ColorSequenceKeypoint.new(0.5, th.accent2),
            ColorSequenceKeypoint.new(1, th.accent),
        })
        sidebar.BackgroundColor3 = th.card
        title.TextColor3 = th.bright
        statsLbl.TextColor3 = th.bright
        for tid, btn in pairs(tabButtons) do
            local on = (tid == currentTab)
            btn.BackgroundColor3 = on and th.row or th.card
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Color = on and th.accent or th.stroke end
            local lbl = btn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = on and th.bright or Color3.fromRGB(170, 170, 185) end
            local ind = btn:FindFirstChild("Indicator")
            if ind then ind.BackgroundColor3 = th.accent end
        end
        if AXON.UIRefs.bunnyStroke then AXON.UIRefs.bunnyStroke.Color = th.bright end
    end

    AXON.RefreshAllToggles = function()
        for k, fn in pairs(toggleRefs) do pcall(fn) end
    end

    createFloatingMenuButton(panelGui, main)
    createSafePlatformButton()

    main.Visible = AXON.State.menuOpen

    -- PATCH: panel starts at screen center (AnchorPoint 0.5,0.5 + fromScale 0.5,0.5)
    -- Tween keeps it centered but uses Back easing for a satisfying bounce-in.
    -- Scale punch: starts slightly small, tweens up to 1 for the pop.
    scaleObj.Scale = 0.85
    TweenService:Create(scaleObj, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = math.clamp(AXON.Config.uiScale or 1, 0.6, 1.6) }):Play()
    TweenService:Create(main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5),
    }):Play()
end

-- ============================================================
-- MAIN AIM LOOP
-- ============================================================
RunService.RenderStepped:Connect(function(dt)
    if not AXON.Config.aimEnabled then
        setCurrentAim(nil, nil)
        AXON.State.stickyTarget = nil
        AXON.State.stickyCount = 0
        if tracerLine.Visible then tracerLine.Visible = false end
        if tracerGlow.Visible then tracerGlow.Visible = false end
        return
    end
    local model, pos = resolveAimTarget()
    setCurrentAim(model, pos)
    if model and pos then
        if not AXON.Config.silentAim then
            local cam = Camera or workspace.CurrentCamera
            if cam then
                local smooth = math.clamp(tonumber(AXON.Config.aimSmooth) or 0.35, 0.05, 1.0)
                local alpha = 1 - math.pow(1 - smooth, math.clamp(dt * 60, 0.001, 3))
                local targetCF = CFrame.lookAt(cam.CFrame.Position, pos)
                cam.CFrame = cam.CFrame:Lerp(targetCF, alpha)
            end
        end
        if AXON.Config.rotateHRP
            and AXON.State.currentSkillKey
            and AXON.State.currentSkillKey ~= "M1"
            and AXON.State.currentSkillKey ~= "TAP"
            and not AXON.State.dashing then
            faceTarget(pos)
        end
        drawTracer(pos)
    else
        if tracerLine.Visible then tracerLine.Visible = false end
        if tracerGlow.Visible then tracerGlow.Visible = false end
    end
end)

-- ============================================================
-- FLOW
-- ============================================================
playIntro(function()
    if AXON.IsKeySaved() then
        notify("AXON", "Key is valid — Enjoy the script", 4)
        buildPanel()
    else
        showKeyModal(function()
            notify("AXON", "Key is valid — Enjoy the script", 4)
            buildPanel()
        end)
    end
end)

task.spawn(function()
    task.wait(1.5)
    AXON.LoadFFlags()
end)

print("[AXON] flow started (intro → key → panel) v16-patched")
return AXON