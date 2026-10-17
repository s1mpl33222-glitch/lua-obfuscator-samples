-- drixnvsp FREE  (made for mobile / Delta)
-- Free version: ESP, Silent Aim, Magic Bullet, movement. Paid unlocks the rest.

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ================================================================
-- SERVICES
-- ================================================================
local P   = game:GetService("Players")
local R   = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local WS  = workspace
local L   = P.LocalPlayer
local Cam = WS.CurrentCamera
local pg  = L:WaitForChild("PlayerGui")

WS:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Cam = WS.CurrentCamera or Cam
end)

local TIKTOK_LINK  = "https://www.tiktok.com/@drixnvsp?_r=1&_t=ZP-9A7wASfIJeZ"
local DISCORD_LINK = "https://discord.gg/8At9MJkUt"

-- ================================================================
-- STATE
-- ================================================================
local S = {
    SilentAim  = false,
    HideName    = false,
    PerfMode    = false,  -- lighter updates (ESP every 2nd frame, fewer tracers)
    FPSBoost    = false,  -- lower graphics (local) for weak phones
    AutoLite    = true,   -- low FPS detected on load -> turn on the performance stuff
    Tracers     = false,  -- bullet tracers (only you see them)
    HideBullets = false,  -- don't draw bullets / shells / muzzle flash (no lag when spraying)
    TracerColor = "Red",
    CarLaunch   = false,  -- launch control
    CarLaunchSpeed = 100,
    CarReverse  = 0,      -- reverse speed (0 = stock)
    CarStable   = false,  -- stability / anti-roll

    TargetRed  = true,   -- current target's name + studs turn red
    Friends    = {},     -- team list: [name] = true
    HeadShots  = true,
    AimbotFOV  = 150,
    SkipSafe   = true,   -- silent aim ignores safe zone / spawn protected players
    GunOnly    = false,  -- optional: silent aim only while holding a tool
    FOVCircle  = true,
    MagicBullet = false,
    InfStamina = false,
    ESP        = true,
    ShowName   = true,
    ShowHealth = true,
    ShowGuns   = true,   -- guns they have, under the ESP
    ShowDist   = true,
    ESPRange   = 1500,
    Speed      = false,
    SpeedMult  = 1.5,
    InfJump    = false,
    FullBright = false,
    AntiAFK    = true,
    CamFOVOn   = false,
    CamFOV     = 90,
    ShowFPS    = false,
}

-- ================================================================
-- CONFIG  (auto-loads every time you execute)
-- ================================================================
local Http     = game:GetService("HttpService")
local CFG_DIR  = "drixnvspFree"
local CFG_FILE = CFG_DIR .. "/config.json"

local function saveConfig()
    return pcall(function()
        if makefolder and isfolder and not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
        writefile(CFG_FILE, Http:JSONEncode(S))
    end)
end
local function loadConfig()
    return pcall(function()
        if not isfile or not isfile(CFG_FILE) then error("no file") end
        local data = Http:JSONDecode(readfile(CFG_FILE))
        for k, v in pairs(data) do
            if S[k] ~= nil and type(S[k]) == type(v) then S[k] = v end
        end
    end)
end
local cfgLoaded = loadConfig()

-- ================================================================
-- ESP  (name above head, HP bar + [studs] [hp%] under feet)
-- ================================================================
local C_WHITE = Color3.new(1,1,1)
local C_BLACK = Color3.new(0,0,0)
local C_BARBG = Color3.fromRGB(20,20,20)
local C_HPHI  = Color3.fromRGB(0,255,40)
local C_HPMID = Color3.fromRGB(255,200,40)
local C_HPLO  = Color3.fromRGB(255,50,50)
local C_TEAM  = Color3.fromRGB(60,255,100)   -- team list = green
local C_TGT   = Color3.fromRGB(255,70,70)    -- current target = red
local C_SAFE  = Color3.fromRGB(110,200,255)  -- in a safe zone = light blue
local espTarget = nil                        -- set by the silent aim / magic bullet loop
local fromOffset, mfloor, mmax, mclamp = UDim2.fromOffset, math.floor, math.max, math.clamp

local espSG = Instance.new("ScreenGui")
espSG.Name = "_dxf_esp"
espSG.ResetOnSpawn = false
espSG.IgnoreGuiInset = true
pcall(function() espSG.ScreenInsets = Enum.ScreenInsets.None end)
espSG.DisplayOrder = 99
local guiRoot = pg
pcall(function() if gethui then guiRoot = gethui() end end)
espSG.Parent = guiRoot

local function makeLbl(parent, text, sz)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Font = Enum.Font.GothamBold
    l.TextSize = sz
    l.TextColor3 = C_WHITE
    l.TextStrokeColor3 = C_BLACK
    l.TextStrokeTransparency = 0
    l.Text = text or ""
    l.Parent = parent
    return l
end

local plist = {}
local function refreshPlist()
    local t = {}
    for _, p in ipairs(P:GetPlayers()) do if p ~= L then t[#t+1] = p end end
    plist = t
end
refreshPlist()

local esp = {}

local function removeESP(p)
    local e = esp[p]
    if e then e.top:Destroy(); e.bot:Destroy() end
    esp[p] = nil
end

local function buildESP(p)
    removeESP(p)
    local top = Instance.new("Frame")
    top.BackgroundTransparency = 1
    top.AnchorPoint = Vector2.new(0.5, 1)
    top.Size = fromOffset(300, 20)
    top.Visible = false
    top.Parent = espSG
    local nameLbl = makeLbl(top, p.Name, 16)
    nameLbl.Size = UDim2.fromScale(1, 1)

    local bot = Instance.new("Frame")
    bot.BackgroundTransparency = 1
    bot.AnchorPoint = Vector2.new(0.5, 0)
    bot.Size = fromOffset(300, 70)
    bot.Visible = false
    bot.Parent = espSG

    local barBg = Instance.new("Frame")
    barBg.BackgroundColor3 = C_BARBG
    barBg.BackgroundTransparency = 0.15
    barBg.BorderSizePixel = 0
    barBg.Size = fromOffset(100, 12)
    barBg.Position = UDim2.new(0.5, -50, 0, 1)
    barBg.Parent = bot
    local st = Instance.new("UIStroke"); st.Color = C_BLACK; st.Thickness = 1.5; st.Parent = barBg

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = C_HPHI
    hpFill.BorderSizePixel = 0
    hpFill.Size = UDim2.fromScale(1, 1)
    hpFill.ZIndex = 2
    hpFill.Parent = barBg

    local hpTxt = makeLbl(barBg, "100/100", 11)
    hpTxt.Size = UDim2.fromScale(1, 1)
    hpTxt.ZIndex = 3

    local infoLbl = makeLbl(bot, "", 14)
    infoLbl.Size = UDim2.new(1, 0, 0, 17)
    infoLbl.Position = fromOffset(0, 16)

    local gunLbl = makeLbl(bot, "", 13)
    gunLbl.Size = UDim2.new(1, 0, 0, 34)
    gunLbl.Position = fromOffset(0, 33)
    gunLbl.TextWrapped = true
    gunLbl.TextYAlignment = Enum.TextYAlignment.Top

    nameLbl.Visible = S.ShowName
    barBg.Visible   = S.ShowHealth
    infoLbl.Visible = S.ShowDist
    gunLbl.Visible  = S.ShowGuns
    esp[p] = {
        nameLbl = nameLbl, barBg = barBg, gunLbl = gunLbl, nextGuns = 0, cGuns = nil,
        top = top, bot = bot, hpFill = hpFill, hpTxt = hpTxt, infoLbl = infoLbl,
        char = nil, hum = nil, root = nil, head = nil, feetDrop = 3, headUp = 1,
        nextSlow = 0, alive = false, shown = false, cHp = nil, cPct = nil, cInfo = nil, cFill = nil,
    }
end

local function refreshChar(e, ch)
    e.char = ch
    e.hum  = ch and ch:FindFirstChildOfClass("Humanoid")
    e.head = ch and ch:FindFirstChild("Head")
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if root then
        e.root = root
        e.feetDrop = (e.hum and e.hum.RigType == Enum.HumanoidRigType.R6) and 3.2
                     or ((e.hum and e.hum.HipHeight or 2) + root.Size.Y * 0.5 + 0.2)
    else
        e.root = ch and (ch.PrimaryPart or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
                 or e.head or ch:FindFirstChildWhichIsA("BasePart"))
        e.feetDrop = 3
    end
    e.headUp = e.head and (e.head.Size.Y * 0.5 + 0.35) or 2.5
end

local function applyEspParts()
    for _, e in pairs(esp) do
        e.nameLbl.Visible = S.ShowName
        e.barBg.Visible   = S.ShowHealth
        e.infoLbl.Visible = S.ShowDist
        e.gunLbl.Visible  = S.ShowGuns
    end
end

local function setShown(e, v)
    if e.shown ~= v then e.shown = v; e.top.Visible = v; e.bot.Visible = v end
end

for _, p in ipairs(plist) do buildESP(p) end

local myRoot = nil
local function onMyChar(ch)
    myRoot = ch:WaitForChild("HumanoidRootPart", 5)
end
if L.Character then task.spawn(onMyChar, L.Character) end
L.CharacterAdded:Connect(function(ch) task.spawn(onMyChar, ch) end)

local espTick = 0
R.RenderStepped:Connect(function()
    if not S.ESP then return end
    espTick = espTick + 1
    if (S.PerfMode or S.FPSBoost) and espTick % 2 == 1 then return end
    local vp = Cam.ViewportSize
    local vx, vy = vp.X, vp.Y
    local now = os.clock()
    local myPos = (myRoot and myRoot.Parent) and myRoot.Position or Cam.CFrame.Position

    for i = 1, #plist do
        local p = plist[i]
        local e = esp[p]
        if not e then buildESP(p); e = esp[p] end

        local ch = p.Character
        if ch ~= e.char or (e.root and not e.root.Parent) then refreshChar(e, ch) end
        local root, hum = e.root, e.hum
        if not ch or not root or not hum then
            if ch and now >= e.nextSlow then e.nextSlow = now + 0.5; refreshChar(e, ch) end
            setShown(e, false); continue
        end

        local rootPos = root.Position
        local dist = mfloor((myPos - rootPos).Magnitude)
        if dist > S.ESPRange then setShown(e, false); continue end

        if now >= e.nextSlow then
            e.nextSlow = now + 0.12 + (i % 5) * 0.004
            local hp = hum.Health
            e.alive = hp > 0
            e.safe = p:GetAttribute("InSafeZone") == true or p:GetAttribute("SpawnProtected") == true
            if e.alive then
                local mhp = mmax(hum.MaxHealth, 1)
                local pct = mclamp(hp / mhp, 0, 1)
                local hpStr = mfloor(hp + 0.5) .. "/" .. mfloor(mhp + 0.5)
                if e.cHp ~= hpStr then e.cHp = hpStr; e.hpTxt.Text = hpStr end
                local pr = mfloor(pct * 100) / 100
                if e.cPct ~= pr then e.cPct = pr; e.hpFill.Size = UDim2.fromScale(pr, 1) end
                local fc = pct > 0.6 and C_HPHI or (pct > 0.3 and C_HPMID or C_HPLO)
                if e.cFill ~= fc then e.cFill = fc; e.hpFill.BackgroundColor3 = fc end
                local info = "[" .. dist .. "M] [" .. mfloor(pct * 100 + 0.5) .. "%]"
                if e.cInfo ~= info then e.cInfo = info; e.infoLbl.Text = info end
            end
        end
        if not e.alive then setShown(e, false); continue end
        if S.ShowGuns and now >= e.nextGuns then
            e.nextGuns = now + 0.5 + (i % 5) * 0.01
            local names, seen = {}, {}
            for _, v in ipairs(ch:GetChildren()) do
                if v:IsA("Tool") and not seen[v.Name] then seen[v.Name] = true; names[#names+1] = "[" .. v.Name .. "]" end
            end
            local bp = p:FindFirstChildOfClass("Backpack")
            if bp then
                for _, v in ipairs(bp:GetChildren()) do
                    if v:IsA("Tool") and not seen[v.Name] then seen[v.Name] = true; names[#names+1] = "[" .. v.Name .. "]" end
                end
            end
            local txt = table.concat(names, " ")
            if e.cGuns ~= txt then e.cGuns = txt; e.gunLbl.Text = txt end
        end

        local feet = Cam:WorldToViewportPoint(rootPos - Vector3.new(0, e.feetDrop, 0))
        if feet.Z <= 0 or feet.X < -150 or feet.X > vx + 150 or feet.Y < -150 or feet.Y > vy + 300 then
            setShown(e, false); continue
        end
        local headW = (e.head and e.head.Parent) and e.head.Position or rootPos
        local head = Cam:WorldToViewportPoint(headW + Vector3.new(0, e.headUp, 0))
        local hx, hy, fx, fy = mfloor(head.X + 0.5), mfloor(head.Y + 0.5), mfloor(feet.X + 0.5), mfloor(feet.Y + 0.5)
        if e.pHX ~= hx or e.pHY ~= hy or e.pVX ~= vx or e.pVY ~= vy then
            e.pHX, e.pHY = hx, hy
            e.top.Position = UDim2.new(hx / vx, 0, hy / vy, -2)
        end
        if e.pFX ~= fx or e.pFY ~= fy or e.pVX ~= vx or e.pVY ~= vy then
            e.pFX, e.pFY = fx, fy
            e.bot.Position = UDim2.new(fx / vx, 0, fy / vy, 3)
        end
        e.pVX, e.pVY = vx, vy
        -- colors (name + studs only): team green | safe zone light blue | target red | white
        local col = (S.Friends[p.Name] == true) and C_TEAM or (e.safe and C_SAFE)
                    or ((S.TargetRed and p == espTarget) and C_TGT or C_WHITE)
        if e.cCol ~= col then e.cCol = col; e.nameLbl.TextColor3 = col; e.infoLbl.TextColor3 = col end
        setShown(e, true)
    end
end)

P.PlayerAdded:Connect(function(p) refreshPlist(); buildESP(p) end)
P.PlayerRemoving:Connect(function(p) removeESP(p); task.defer(refreshPlist) end)

-- ================================================================
-- MOVEMENT
-- ================================================================
R.Stepped:Connect(function()
    if not S.Speed then return end
    local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        local ws = 16 * S.SpeedMult
        if hum.WalkSpeed ~= ws then hum.WalkSpeed = ws end
    end
end)

-- infinite jump: only when YOU press jump in the air, one press = one jump
local jumpPressAt, jumpPressUsed = 0, true
local function airJump()
    local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end
local function touchOnJumpButton(input)
    local ok, objs = pcall(pg.GetGuiObjectsAtPosition, pg, input.Position.X, input.Position.Y)
    if not ok or not objs then return false end
    for _, o in ipairs(objs) do
        if o.Visible then
            if string.find(string.lower(o.Name), "jump", 1, true) then return true end
            local par = o.Parent
            if par and string.find(string.lower(par.Name), "jump", 1, true) then return true end
        end
    end
    return false
end
UIS.InputBegan:Connect(function(input)
    if not S.InfJump then return end
    local t = input.UserInputType
    if (t == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space)
    or (t == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) then
        jumpPressUsed = true; airJump()
    elseif t == Enum.UserInputType.Touch then
        if touchOnJumpButton(input) then jumpPressUsed = true; airJump()
        else jumpPressAt, jumpPressUsed = os.clock(), false end
    end
end)
UIS.JumpRequest:Connect(function()
    if not S.InfJump or jumpPressUsed or os.clock() - jumpPressAt > 0.15 then return end
    jumpPressUsed = true; airJump()
end)

-- ================================================================
-- COMBAT CORE  —  Silent Aim + Magic Bullet   (v5-style hook: the one that worked)
-- While you have a target, EVERY raycast / FindPartOnRay the game's gun makes is
-- re-cast straight into the target with ONLY the target included -> walls are ignored.
--   Silent Aim   = target must be inside your FOV circle
--   Magic Bullet = target is the closest player to your crosshair anywhere on screen
-- Also covers Mouse.Hit / Mouse.Target (tap-to-shoot guns) and crosshair screen rays.
-- ================================================================
local currentTarget = nil   -- Player
local tgtChar       = nil
local tgtPart       = nil
local armed         = false -- true while silent aim / magic bullet has a target
local camPosF       = Vector3.zero
local camLookF      = Vector3.new(0, 0, -1)
local myPosF        = Vector3.zero
local coreFrame     = 0
local redirectsLeft, MAX_REDIRECTS = 0, 0   -- (kept for compatibility, unused)

local CAM_METHODS = { ViewportPointToRay = true, ScreenPointToRay = true }
local reentrant = false
local wsRaycast = WS.Raycast
local wsFPORWL  = WS.FindPartOnRayWithWhitelist
local Mouse     = L:GetMouse()

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include
local rayParamsChar = nil

local oldNC = nil
local function hookBody(self, ...)
    if reentrant or not armed then return oldNC(self, ...) end
    local method = getnamecallmethod()

    if rawequal(self, WS) then
        local isRaycast = (method == "Raycast")
        local isFPOR = (not isRaycast) and (method == "FindPartOnRay" or method == "findPartOnRay"
            or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist")
        if not isRaycast and not isFPOR then return oldNC(self, ...) end

        local part, ch = tgtPart, tgtChar
        if not part or not ch or not part.Parent then return oldNC(self, ...) end
        local a1 = ...

        if isRaycast then
            if typeof(a1) ~= "Vector3" then return oldNC(self, ...) end
            local dir = part.Position - a1
            if rayParamsChar ~= ch then
                rayParamsChar = ch
                rayParams.FilterDescendantsInstances = { ch }
            end
            reentrant = true
            local ok, res = pcall(wsRaycast, WS, a1, dir.Unit * (dir.Magnitude + 2), rayParams)
            reentrant = false
            if ok and res then return res end
            return oldNC(self, ...)
        else
            if typeof(a1) ~= "Ray" then return oldNC(self, ...) end
            local o = a1.Origin
            local dir = part.Position - o
            reentrant = true
            local ok, h, p2, n2, m2 = pcall(wsFPORWL, WS,
                Ray.new(o, dir.Unit * (dir.Magnitude + 2)), { ch })
            reentrant = false
            if ok and h then return h, p2, n2, m2 end
            return oldNC(self, ...)
        end
    end

    if CAM_METHODS[method] and rawequal(self, Cam) then
        local part = tgtPart
        local r = oldNC(self, ...)
        if part and part.Parent and typeof(r) == "Ray" then
            return Ray.new(r.Origin, (part.Position - r.Origin).Unit)
        end
        return r
    end
    return oldNC(self, ...)
end

local oldIdx = nil
local function indexBody(self, k)
    if armed and not reentrant and rawequal(self, Mouse) then
        local part = tgtPart
        if part and part.Parent then
            if k == "Hit" then return CFrame.new(part.Position) end
            if k == "Target" then return part end
            if k == "UnitRay" then return Ray.new(camPosF, (part.Position - camPosF).Unit) end
        end
    end
    return oldIdx(self, k)
end

local hookActive, hooked = false, false
local function setHook(on)
    if not on or hooked then return end
    hooked = true
    if hookmetamethod then
        local ok1, o1 = pcall(hookmetamethod, game, "__namecall", hookBody)
        if ok1 and o1 then oldNC = o1 end
        local ok2, o2 = pcall(hookmetamethod, game, "__index", indexBody)
        if ok2 and o2 then oldIdx = o2 end
    end
    if not oldNC or not oldIdx then   -- executors without hookmetamethod
        pcall(function()
            local mt = getrawmetatable(game)
            if setreadonly then setreadonly(mt, false) elseif make_writeable then make_writeable(mt) end
            if not oldNC then oldNC = mt.__namecall; mt.__namecall = hookBody end
            if not oldIdx then oldIdx = mt.__index; mt.__index = indexBody end
            if setreadonly then setreadonly(mt, true) elseif make_readonly then make_readonly(mt) end
        end)
    end
    hookActive = oldNC ~= nil
    if not hookActive then
        warn("[drixnvsp] your executor doesn't support hooks (Silent Aim / Magic Bullet)")
    end
end

-- ================================================================
-- SILENT AIM TARGET + FOV CIRCLE
-- ================================================================
local function findTarget(cx, cy, fov)
    local best, bestPart, bd = nil, nil, fov * fov
    for i = 1, #plist do
        local p = plist[i]
        local e = esp[p]
        if e and not S.Friends[p.Name] and not (S.SkipSafe and (p:GetAttribute("InSafeZone") == true or p:GetAttribute("SpawnProtected") == true)) then
            local ch = p.Character
            if ch ~= e.char or (e.root and not e.root.Parent) then refreshChar(e, ch) end
            if ch and not e.root then   -- streamed-out parts: re-check twice a second
                local t = os.clock()
                if t >= (e.nextRef or 0) then e.nextRef = t + 0.5; refreshChar(e, ch) end
            end
            local hum = e.hum
            if ch and hum and hum.Health > 0 then
                local part
                if S.HeadShots then part = e.head or e.root else part = e.root or e.head end
                if part and part.Parent then
                    local sp, on = Cam:WorldToViewportPoint(part.Position)
                    if on then
                        local d = (sp.X - cx)^2 + (sp.Y - cy)^2
                        if d < bd then bd = d; best = p; bestPart = part end
                    end
                end
            end
        end
    end
    return best, bestPart
end

local fovFrame = Instance.new("Frame")
fovFrame.BackgroundTransparency = 1
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.fromScale(0.5, 0.5)
fovFrame.Visible = false
fovFrame.Parent = espSG
do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = fovFrame
    local st = Instance.new("UIStroke"); st.Color = C_WHITE; st.Thickness = 1.5; st.Transparency = 0.2; st.Parent = fovFrame
end
local lastFov = -1

local combatFrame = 0
R.RenderStepped:Connect(function()
    -- FOV circle
    if S.FOVCircle and S.SilentAim then
        if lastFov ~= S.AimbotFOV then lastFov = S.AimbotFOV; fovFrame.Size = fromOffset(S.AimbotFOV * 2, S.AimbotFOV * 2) end
        if not fovFrame.Visible then fovFrame.Visible = true end
    elseif fovFrame.Visible then
        fovFrame.Visible = false
    end

    local wantSA, wantMB = S.SilentAim, S.MagicBullet
    if S.GunOnly and not (L.Character and L.Character:FindFirstChildOfClass("Tool")) then wantSA, wantMB = false, false end
    if not wantSA and not wantMB then
        armed, tgtPart, tgtChar, currentTarget, espTarget = false, nil, nil, nil, nil
        return
    end
    if not hookActive then setHook(true) end
    combatFrame = combatFrame + 1
    local cf = Cam.CFrame
    camPosF, camLookF, coreFrame = cf.Position, cf.LookVector, combatFrame
    myPosF = (myRoot and myRoot.Parent) and myRoot.Position or camPosF

    -- Silent Aim: closest player inside the FOV circle
    -- Magic Bullet: closest player to your crosshair anywhere on screen (through walls)
    local vp = Cam.ViewportSize
    local tgt, tp = nil, nil
    if wantSA then tgt, tp = findTarget(vp.X * 0.5, vp.Y * 0.5, S.AimbotFOV) end
    if not tgt and wantMB then tgt, tp = findTarget(vp.X * 0.5, vp.Y * 0.5, 100000) end
    currentTarget, tgtPart, espTarget = tgt, tp, tgt
    tgtChar = tgt and tgt.Character or nil
    armed = hookActive and tgtPart ~= nil
end)

-- ================================================================
-- INFINITE STAMINA  (universal, best effort)
-- Games store stamina in different ways, so this covers the common ones:
--   1) Attributes named like "Stamina" on you / your character / humanoid
--   2) NumberValue / IntValue objects named like "Stamina" in your player or character
--   3) Script tables with a "Stamina" field (scanned once when you turn it on / respawn)
-- Each one is kept at its max. It's event-based, so it costs ~nothing per frame.
-- (If a game keeps stamina only on the SERVER, no client script can change it.)
-- ================================================================
local STAM_KEYS = { stamina = true, currentstamina = true, stam = true, sprintstamina = true, sprint = false }
local function isStamName(n)
    n = string.lower(n)
    return STAM_KEYS[n] == true
end
local function maxNameFor(n)  -- "Stamina" -> candidates for its max
    return { "Max" .. n, "max" .. n, "Max" .. n:sub(1,1):upper() .. n:sub(2), "MaxStamina", "maxStamina", "StaminaMax", "max_stamina" }
end

local stam = { conns = {}, values = {}, tables = setmetatable({}, { __mode = "k" }), seenMax = {} }

local function stamClear()
    for _, c in ipairs(stam.conns) do pcall(function() c:Disconnect() end) end
    stam.conns, stam.values = {}, {}
end

-- max for a ValueBase: sibling "MaxStamina" value/attribute, else highest value we've seen
local function valueMax(v)
    local par = v.Parent
    if par then
        for _, mn in ipairs(maxNameFor(v.Name)) do
            local m = par:FindFirstChild(mn)
            if m and m:IsA("ValueBase") and type(m.Value) == "number" then return m.Value end
            local a = par:GetAttribute(mn)
            if type(a) == "number" then return a end
        end
    end
    local seen = stam.seenMax[v] or 0
    if v.Value > seen then seen = v.Value; stam.seenMax[v] = seen end
    return seen
end

local function watchValue(v)
    if stam.values[v] then return end
    if not (v:IsA("NumberValue") or v:IsA("IntValue")) or not isStamName(v.Name) then return end
    stam.values[v] = true
    local function fill()
        if not S.InfStamina then return end
        local m = valueMax(v)
        if m > 0 and v.Value < m then v.Value = m end
    end
    stam.conns[#stam.conns+1] = v.Changed:Connect(fill)
    fill()
end

local function watchAttrs(inst)
    if not inst then return end
    for name, val in pairs(inst:GetAttributes()) do
        if type(val) == "number" and isStamName(name) then
            local mx = 0
            for _, mn in ipairs(maxNameFor(name)) do
                local a = inst:GetAttribute(mn)
                if type(a) == "number" then mx = a; break end
            end
            local key = inst:GetFullName() .. "@" .. name
            local function fill()
                if not S.InfStamina then return end
                local cur = inst:GetAttribute(name)
                if type(cur) ~= "number" then return end
                local m = mx
                if m <= 0 then
                    m = math.max(stam.seenMax[key] or 0, cur)
                    stam.seenMax[key] = m
                end
                if cur < m then inst:SetAttribute(name, m) end
            end
            stam.conns[#stam.conns+1] = inst:GetAttributeChangedSignal(name):Connect(fill)
            fill()
        end
    end
end

-- script tables (getgc): one scan, then refilled on Heartbeat (only the few tables found)
local function scanTables()
    if not getgc then return end
    local ok, gc = pcall(getgc, true)
    if not ok or type(gc) ~= "table" then return end
    for _, t in ipairs(gc) do
        if type(t) == "table" then
            for _, k in ipairs({ "Stamina", "stamina", "CurrentStamina", "currentStamina" }) do
                local v = rawget(t, k)
                if type(v) == "number" then
                    local m = rawget(t, "MaxStamina") or rawget(t, "maxStamina") or rawget(t, "StaminaMax")
                    stam.tables[t] = { key = k, max = (type(m) == "number" and m) or nil, seen = v }
                end
            end
        end
    end
end

local function stamSetup()
    stamClear()
    if not S.InfStamina then return end
    local ch = L.Character
    -- attributes
    watchAttrs(L)
    if ch then
        watchAttrs(ch)
        local hum = ch:FindFirstChildOfClass("Humanoid")
        watchAttrs(hum)
        -- values inside the character
        for _, d in ipairs(ch:GetDescendants()) do watchValue(d) end
        stam.conns[#stam.conns+1] = ch.DescendantAdded:Connect(watchValue)
    end
    -- values inside the player (skip the big UI folders)
    for _, c in ipairs(L:GetChildren()) do
        if not c:IsA("PlayerGui") and not c:IsA("PlayerScripts") and not c:IsA("Backpack") then
            watchValue(c)
            for _, d in ipairs(c:GetDescendants()) do watchValue(d) end
        end
    end
    stam.conns[#stam.conns+1] = L.ChildAdded:Connect(function(c)
        watchValue(c)
        task.defer(function() for _, d in ipairs(c:GetDescendants()) do watchValue(d) end end)
    end)
    task.spawn(scanTables)
end

R.Heartbeat:Connect(function()
    if not S.InfStamina then return end
    for t, info in pairs(stam.tables) do
        local v = rawget(t, info.key)
        if type(v) == "number" then
            local m = info.max or rawget(t, "MaxStamina") or rawget(t, "maxStamina")
            if type(m) ~= "number" then
                if v > info.seen then info.seen = v end
                m = info.seen
            end
            if v < m then rawset(t, info.key, m) end
        end
    end
end)

L.CharacterAdded:Connect(function()
    if S.InfStamina then task.delay(1, stamSetup) end
end)

-- ================================================================
-- EXTRAS: FullBright · Anti-AFK · Camera FOV · FPS counter
-- ================================================================
local Lighting = game:GetService("Lighting")
local litSaved = nil
local function applyFullBright(on)
    if on then
        if not litSaved then
            litSaved = { Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd,
                         Lighting.GlobalShadows, Lighting.OutdoorAmbient }
        end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    elseif litSaved then
        Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd,
        Lighting.GlobalShadows, Lighting.OutdoorAmbient = unpack(litSaved)
        litSaved = nil
    end
end
task.spawn(function()   -- some games reset lighting: re-apply once a second (cheap)
    while true do
        task.wait(1)
        if S.FullBright then pcall(applyFullBright, true) end
    end
end)

L.Idled:Connect(function()
    if not S.AntiAFK then return end
    pcall(function()
        local VU = game:GetService("VirtualUser")
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

local fpsLbl = makeLbl(espSG, "", 14)
fpsLbl.AnchorPoint = Vector2.new(0, 0)
fpsLbl.Position = fromOffset(8, 40)
fpsLbl.Size = fromOffset(120, 18)
fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
fpsLbl.Visible = S.ShowFPS
local frames, fpsT = 0, os.clock()
R.RenderStepped:Connect(function()
    if S.CamFOVOn and Cam.FieldOfView ~= S.CamFOV then Cam.FieldOfView = S.CamFOV end
    if S.ShowFPS then
        frames = frames + 1
        local now = os.clock()
        if now - fpsT >= 0.5 then
            fpsLbl.Text = "FPS: " .. mfloor(frames / (now - fpsT) + 0.5)
            frames, fpsT = 0, now
        end
    end
end)

-- ================================================================
-- UI  (classic WindUI look)
-- ================================================================
local Window = WindUI:CreateWindow({
    Title  = "drixnvsp",
    Icon   = "crosshair",
    Author = "drixnvsp  •  FREE",
    Folder = "drixnvspFree",
    Size   = UDim2.fromOffset(580, 360),   -- fits phone screens
    MinSize = Vector2.new(440, 260),
    MaxSize = Vector2.new(860, 580),
    Transparent  = true,
    Theme        = "Dark",
    Resizable    = true,
    SideBarWidth = 190,
    BackgroundImageTransparency = 0.5,
    HideSearchBar    = true,
    ScrollBarEnabled = false,
    User = { Enabled = false },
})
pcall(function()
    Window:EditOpenButton({
        Title = "drixnvsp", Icon = "",
        CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(200,200,200)),
        OnlyMobile = false, Enabled = true, Draggable = true,
    })
end)

local function notify(t, c, img)
    pcall(function() WindUI:Notify({ Title = t, Content = c, Duration = 4, Image = img or "info" }) end)
end
-- one part breaking must never take the rest of the menu (tabs) down with it
local function safeLoad(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        warn("[drixnvsp] " .. name .. " failed: " .. tostring(err))
        notify("drixnvsp", name .. " failed to load: " .. (string.gsub(tostring(err), "^.-:(%d+): ", "line %1: ")), "x")
    end
end
local function copyLink(link, what)
    local clip = setclipboard or toclipboard or set_clipboard
    if clip and pcall(clip, link) then notify("Copied!", what .. " link copied", "copy")
    else notify(what, link, "link") end
end

-- one broken element can never stop the rest of the menu from loading
local function add(tab, kind, cfg)
    local ok, el = pcall(function() return tab[kind](tab, cfg) end)
    if not ok then warn("[drixnvsp] UI element failed: " .. tostring(cfg.Title) .. " -> " .. tostring(el)) end
    return ok and el or nil
end
local function toggle(tab, title, desc, key, onChange)
    return add(tab, "Toggle", {
        Title = title, Desc = desc, Value = S[key],
        Callback = function(v)
            S[key] = v
            if onChange then pcall(onChange, v) end
        end,
    })
end
local function slider(tab, title, desc, key, min, max, step)
    return add(tab, "Slider", {
        Title = title, Desc = desc, Step = step,
        Value = { Min = min, Max = max, Default = S[key] },
        Callback = function(v) S[key] = tonumber(v) or S[key] end,
    })
end
local function button(tab, title, desc, icon, fn)
    return add(tab, "Button", { Title = title, Desc = desc, Icon = icon, Callback = function() pcall(fn) end })
end

-- ================================================================
-- BULLET TRACERS + CAR MODS (launch / reverse / stability)
--   Tracers: glowing line from your barrel to where each shot goes (only you see it)
--   Car  : only on the car YOU are driving
-- ================================================================
do
    local RunS = game:GetService("RunService")
    local TwS  = game:GetService("TweenService")
    local UISv = game:GetService("UserInputService")
    local conns = {}
    local function on(sig, fn) local c = sig:Connect(fn); conns[#conns+1] = c; return c end
    local function alive() return true end

    local AMMO = { CurrentAmmo = true, Ammo = true, Clip = true, Mag = true, Magazine = true, Bullets = true, AmmoInClip = true, AmmoInMag = true }
    local gunCache = setmetatable({}, { __mode = "k" })
    local function isGun(tool)
        local g = gunCache[tool]
        if g ~= nil then return g end
        g = tool:FindFirstChildWhichIsA("Configuration") ~= nil
        if not g then
            for n in pairs(AMMO) do if type(tool:GetAttribute(n)) == "number" then g = true; break end end
        end
        if not g then
            for _, d in ipairs(tool:GetDescendants()) do
                if (d:IsA("IntValue") or d:IsA("NumberValue")) and AMMO[d.Name] then g = true; break end
            end
        end
        gunCache[tool] = g
        return g
    end
    local function heldGun()
        local ch = L.Character
        local t = ch and ch:FindFirstChildOfClass("Tool")
        if t and isGun(t) then return t end
        return nil
    end

    -- ── tracers ─────────────────────────────────────────────────
    local COLORS = {
        Red = Color3.fromRGB(255, 40, 40), Green = Color3.fromRGB(40, 255, 90), Blue = Color3.fromRGB(40, 140, 255),
        Purple = Color3.fromRGB(170, 70, 255), Gold = Color3.fromRGB(255, 200, 40), White = Color3.fromRGB(255, 255, 255),
        Pink = Color3.fromRGB(255, 90, 200), Cyan = Color3.fromRGB(40, 240, 255),
    }
    local MUZZLES = { "TipAttachment", "MuzzleAttachment", "Muzzle", "FirePoint", "ShootPoint", "BulletSpawn", "Tip", "Barrel" }
    local muzzleCache = setmetatable({}, { __mode = "k" })
    local watched = setmetatable({}, { __mode = "k" })
    local folder = Instance.new("Folder"); folder.Name = "DrixTracers"; folder.Parent = WS
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    local live, lastShot = 0, 0

    local function muzzlePos(tool)
        local m = muzzleCache[tool]
        if m == nil then
            m = false
            for _, n in ipairs(MUZZLES) do
                local f = tool:FindFirstChild(n, true)
                if f and (f:IsA("Attachment") or f:IsA("BasePart")) then m = f; break end
            end
            muzzleCache[tool] = m
        end
        if m and m.Parent then return m:IsA("Attachment") and m.WorldPosition or m.Position end
        local h = tool:FindFirstChild("Handle")
        if h and h:IsA("BasePart") then return (h.CFrame * CFrame.new(0, 0, -h.Size.Z * 0.5)).Position end
        local hd = L.Character and L.Character:FindFirstChild("Head")
        return hd and hd.Position
    end

    local function aimPoint()
        local tp = (armed and tgtPart) or nil
        if tp and tp.Parent then return tp.Position end
        local cam = WS.CurrentCamera
        local ray
        if UISv.TouchEnabled and not UISv.MouseEnabled then
            local vp = cam.ViewportSize
            ray = cam:ViewportPointToRay(vp.X * 0.5, vp.Y * 0.5)
        else
            local mp = UISv:GetMouseLocation()
            ray = cam:ViewportPointToRay(mp.X, mp.Y)
        end
        rp.FilterDescendantsInstances = { L.Character, folder }
        local res = WS:Raycast(ray.Origin, ray.Direction * 1500, rp)
        return res and res.Position or (ray.Origin + ray.Direction * 1500)
    end

    local function tracer()
        if live >= ((S.PerfMode or S.FPSBoost) and 15 or 40) or not alive() or S.HideBullets then return end
        local tool = heldGun(); if not tool then return end
        local a = muzzlePos(tool); if not a then return end
        local ok, b = pcall(aimPoint); if not ok or not b then return end
        local len = (b - a).Magnitude
        if len < 1 then return end
        local col = (S.TracerColor == "Rainbow") and Color3.fromHSV((os.clock() * 0.6) % 1, 1, 1) or (COLORS[S.TracerColor] or COLORS.Red)
        local p = Instance.new("Part")
        p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Material = Enum.Material.Neon; p.Color = col; p.Transparency = 0.05
        p.Size = Vector3.new(0.14, 0.14, len)
        p.CFrame = CFrame.lookAt((a + b) * 0.5, b)
        p.Parent = folder
        live = live + 1
        TwS:Create(p, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Transparency = 1, Size = Vector3.new(0.02, 0.02, len) }):Play()
        task.delay(0.5, function() p:Destroy(); live = live - 1 end)
    end

    local function shot()
        lastShot = os.clock()
        if S.Tracers then tracer() end
    end

    local function watchTool(tool)
        if watched[tool] or not tool.Parent then return end
        watched[tool] = true
        local found = false
        for _, d in ipairs(tool:GetDescendants()) do
            if (d:IsA("IntValue") or d:IsA("NumberValue")) and AMMO[d.Name] then
                found = true
                local last = d.Value
                d.Changed:Connect(function(v)
                    if type(v) ~= "number" then return end
                    if v < last and tool.Parent == L.Character then shot() end
                    last = v
                end)
            end
        end
        for name in pairs(AMMO) do
            local v0 = tool:GetAttribute(name)
            if type(v0) == "number" then
                found = true
                local last = v0
                tool:GetAttributeChangedSignal(name):Connect(function()
                    local v = tool:GetAttribute(name)
                    if type(v) ~= "number" then return end
                    if v < last and tool.Parent == L.Character then shot() end
                    last = v
                end)
            end
        end
        if not found and isGun(tool) then   -- no ammo value: one tracer per click
            tool.Activated:Connect(function()
                local t = os.clock()
                task.delay(0.1, function() if lastShot < t and S.Tracers then tracer() end end)
            end)
        end
    end

    local function watchChar(ch)
        on(ch.ChildAdded, function(c)
            if c:IsA("Tool") then task.delay(0.25, watchTool, c) end
        end)
        for _, c in ipairs(ch:GetChildren()) do if c:IsA("Tool") then task.defer(watchTool, c) end end
    end
    if L.Character then watchChar(L.Character) end
    on(L.CharacterAdded, watchChar)

    -- ── car mods ─────────────────────────────────────────────────
    local carModel, carRoots, launched, lastFwd = nil, {}, false, 0
    local function carOf(seat)
        local m = seat.Parent
        while m and m.Parent and m.Parent ~= WS and m.Parent:IsA("Model") do m = m.Parent end
        return (m and m:IsA("Model")) and m or nil
    end
    local function addVel(dv)
        for _, r in ipairs(carRoots) do
            if r.Parent then pcall(function() r.AssemblyLinearVelocity = r.AssemblyLinearVelocity + dv end) end
        end
    end
    local function shutdown()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        pcall(function() folder:Destroy() end)
    end
    on(RunS.Heartbeat, function(dt)
        if not alive() then shutdown(); return end
        if not (S.CarLaunch or S.CarReverse > 0 or S.CarStable) then carModel = nil; return end
        if false then lastFwd = 0; return end
        local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        local model = seat and carOf(seat)
        if not model or not (seat:IsA("VehicleSeat") or model.Name == L.Name .. "sCar") then carModel = nil; lastFwd = 0; return end
        if model ~= carModel then
            carModel, carRoots, launched, lastFwd = model, {}, false, 0
            local seen = {}
            for _, d in ipairs(model:GetDescendants()) do
                if d:IsA("BasePart") then
                    local r = d.AssemblyRootPart
                    if r and not seen[r] then seen[r] = true; carRoots[#carRoots+1] = r end
                end
            end
        end
        local b = seat.AssemblyRootPart or seat
        local cf = seat.CFrame
        local look, right, up = cf.LookVector, cf.RightVector, cf.UpVector
        local v = b.AssemblyLinearVelocity
        local fwdSpd = v:Dot(look)

        local th = 0
        if seat:IsA("VehicleSeat") then th = seat.ThrottleFloat end
        if th == 0 and not UISv:GetFocusedTextBox() then
            if UISv:IsKeyDown(Enum.KeyCode.W) or UISv:IsKeyDown(Enum.KeyCode.Up) then th = 1
            elseif UISv:IsKeyDown(Enum.KeyCode.S) or UISv:IsKeyDown(Enum.KeyCode.Down) then th = -1 end
        end

        -- LAUNCH CONTROL
        if S.CarLaunch and up.Y > 0.7 then
            local fromStop = math.abs(lastFwd) < 3
            if not launched and fromStop and (th > 0.5 or (th == 0 and lastFwd < 1 and fwdSpd > 1.5 and fwdSpd - lastFwd > 0.3)) then
                launched = true
                if fwdSpd < S.CarLaunchSpeed then addVel(look * (S.CarLaunchSpeed - fwdSpd)) end
            elseif th <= 0.05 and math.abs(fwdSpd) < 3 then
                launched = false
            end
        end

        -- REVERSE SPEED (0 = stock)
        if S.CarReverse > 0 and up.Y > 0.5 then
            if th < -0.05 and fwdSpd < 2 then
                local target = S.CarReverse * math.abs(th)
                if -fwdSpd < target then addVel(-look * math.min(target + fwdSpd, 90 * dt)) end
            elseif th == 0 and fwdSpd < -2 and fwdSpd < lastFwd - 0.05 and -fwdSpd < S.CarReverse then
                addVel(-look * math.min((lastFwd - fwdSpd) * 1.5, S.CarReverse + fwdSpd))
            end
        end

        -- STABILITY / ANTI-ROLL
        if S.CarStable and up.Y > 0.2 then
            local av = b.AssemblyAngularVelocity
            local k = math.clamp(dt * 10, 0, 1)
            local roll, pitch = av:Dot(look), av:Dot(right)
            local rollFix = up:Cross(Vector3.yAxis):Dot(look) * 5
            local nav = av - look * (roll - rollFix) * k - right * pitch * k * 0.5
            pcall(function() b.AssemblyAngularVelocity = nav end)
        end
        lastFwd = b.AssemblyLinearVelocity:Dot(look)
    end)
end

-- ================================================================
-- FPS BOOST  (local only: lowers YOUR graphics so weak phones run smoother)
--   shadows off · post effects off · water waves off · graphics level 1
--   particles / smoke / fire / trails off · everything goes back when you turn it off
-- ================================================================
do
    local Lighting = game:GetService("Lighting")
    local FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
    local saved, fx, addConn, gen = nil, setmetatable({}, { __mode = "k" }), nil, 0
    local function killFx(d)
        if d.Parent and FX[d.ClassName] and fx[d] == nil then
            local ok, en = pcall(function() return d.Enabled end)
            if ok then fx[d] = en; pcall(function() d.Enabled = false end) end
        end
    end
    local function boostOn()
        gen = gen + 1
        local my = gen
        saved = { post = {} }
        pcall(function() saved.shadows = Lighting.GlobalShadows; Lighting.GlobalShadows = false end)
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") then
                pcall(function()
                    if e:IsA("Atmosphere") then saved.post[e] = e.Density; e.Density = 0
                    elseif e.Enabled then saved.post[e] = true; e.Enabled = false end
                end)
            end
        end
        local T = workspace:FindFirstChildOfClass("Terrain")
        if T then
            pcall(function() saved.ww, saved.ws, saved.wr = T.WaterWaveSize, T.WaterWaveSpeed, T.WaterReflectance end)
            pcall(function() T.WaterWaveSize = 0; T.WaterWaveSpeed = 0; T.WaterReflectance = 0 end)
            pcall(function() saved.deco = T.Decoration; T.Decoration = false end)
        end
        pcall(function()
            local ugs = UserSettings():GetService("UserGameSettings")
            saved.q = ugs.SavedQualityLevel
            ugs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        end)
        pcall(function() saved.rq = settings().Rendering.QualityLevel; settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        addConn = workspace.DescendantAdded:Connect(function(d) if FX[d.ClassName] then task.defer(killFx, d) end end)
        task.spawn(function()   -- chunked so it never freezes
            local n = 0
            for _, d in ipairs(workspace:GetDescendants()) do
                if gen ~= my then return end
                n = n + 1
                if n % 1500 == 0 then task.wait() end
                if FX[d.ClassName] then killFx(d) end
            end
        end)
    end
    local function boostOff()
        gen = gen + 1
        if addConn then addConn:Disconnect(); addConn = nil end
        if saved then
            pcall(function() Lighting.GlobalShadows = saved.shadows end)
            for e, v in pairs(saved.post) do
                pcall(function() if e:IsA("Atmosphere") then e.Density = v else e.Enabled = true end end)
            end
            local T = workspace:FindFirstChildOfClass("Terrain")
            if T then
                pcall(function() T.WaterWaveSize, T.WaterWaveSpeed, T.WaterReflectance = saved.ww, saved.ws, saved.wr end)
                pcall(function() if saved.deco ~= nil then T.Decoration = saved.deco end end)
            end
            pcall(function() if saved.q then UserSettings():GetService("UserGameSettings").SavedQualityLevel = saved.q end end)
            pcall(function() if saved.rq then settings().Rendering.QualityLevel = saved.rq end end)
        end
        saved = nil
        local list = fx
        fx = setmetatable({}, { __mode = "k" })
        task.spawn(function()
            local n = 0
            for d, en in pairs(list) do
                n = n + 1
                if n % 500 == 0 then task.wait() end
                if d.Parent then pcall(function() d.Enabled = en end) end
            end
        end)
    end
    task.spawn(function()
        local cur = false
        while true do
            local want = S.FPSBoost == true
            if want ~= cur then cur = want; pcall(want and boostOn or boostOff) end
            task.wait(0.5)
        end
    end)
end

-- ================================================================
-- HIDE BULLETS  (local only)
--   Spraying fast makes the game spawn tons of bullets, shells, impacts and muzzle
--   flashes - that's what drops FPS. This stops them from being DRAWN on your screen
--   (they still exist, so shooting works exactly the same). Our tracers stop too.
-- ================================================================
do
    local WS0  = workspace
    local UISb = game:GetService("UserInputService")
    local WORDS = { "bullet", "projectile", "tracer", "shell", "casing", "hitmark", "hiteffect", "impact",
                    "muzzle", "flash", "spark", "laser", "ricochet", "splat", "blood", "hole" }
    local FXC = { Beam = true, Trail = true, ParticleEmitter = true, PointLight = true, SpotLight = true, SurfaceLight = true,
                  Fire = true, Smoke = true, Sparkles = true }
    local hidden = setmetatable({}, { __mode = "k" })   -- inst -> what it was before
    local conn, toolConns, firingHeld, fireUntil = nil, {}, false, 0

    local function badName(inst)
        local a = inst
        for _ = 1, 3 do
            if not a or a == WS0 then return false end
            local n = string.lower(a.Name)
            for i = 1, #WORDS do if string.find(n, WORDS[i], 1, true) then return true end end
            a = a.Parent
        end
        return false
    end
    local function inCharacter(inst)
        local m = inst:FindFirstAncestorOfClass("Model")
        while m do
            if m:FindFirstChildOfClass("Humanoid") then return not inst:FindFirstAncestorOfClass("Tool") end
            m = m:FindFirstAncestorOfClass("Model")
        end
        return false
    end
    local function hide(d)
        if hidden[d] ~= nil then return end
        if d:IsA("BasePart") then
            hidden[d] = { d.LocalTransparencyModifier, d.Transparency }
            d.LocalTransparencyModifier = 1
            d.Transparency = 1
            for _, c in ipairs(d:GetChildren()) do
                if FXC[c.ClassName] and hidden[c] == nil then hidden[c] = c.Enabled; c.Enabled = false end
            end
        elseif FXC[d.ClassName] then
            hidden[d] = d.Enabled
            d.Enabled = false
        elseif d:IsA("Decal") then
            hidden[d] = d.Transparency
            d.Transparency = 1
        end
    end
    local function firing() return firingHeld or os.clock() < fireUntil end
    local function onAdded(d)
        local isPart = d:IsA("BasePart")
        if not (isPart or FXC[d.ClassName] or d:IsA("Decal")) then return end
        -- never hide the gun itself (equipping moves all its parts into workspace); only its effects
        if not FXC[d.ClassName] and d:FindFirstAncestorOfClass("Tool") then return end
        if badName(d) then
            if not inCharacter(d) then pcall(hide, d) end
        elseif firing() and not inCharacter(d) then
            -- unnamed bullet parts / beams spawned while you're spraying
            if isPart then
                local sz = d.Size
                if not d.CanCollide and math.max(sz.X, sz.Y, sz.Z) < 2.5 then pcall(hide, d) end
            elseif not d:IsA("Decal") then
                pcall(hide, d)
            end
        end
    end
    -- muzzle flash / lights inside YOUR gun: keep them off
    local function quietTool(t)
        for _, d in ipairs(t:GetDescendants()) do
            if FXC[d.ClassName] then
                if hidden[d] == nil then hidden[d] = d.Enabled end
                d.Enabled = false
                toolConns[#toolConns+1] = d:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if S.HideBullets and d.Enabled then d.Enabled = false end
                end)
            end
        end
        toolConns[#toolConns+1] = t.Activated:Connect(function() firingHeld = true; fireUntil = os.clock() + 0.6 end)
        toolConns[#toolConns+1] = t.Deactivated:Connect(function() firingHeld = false; fireUntil = os.clock() + 0.6 end)
    end
    local function clearTools()
        for _, c in ipairs(toolConns) do pcall(function() c:Disconnect() end) end
        toolConns = {}
    end
    local charConn, lastChar = nil, nil
    local function watchChar(ch)
        clearTools()
        if charConn then charConn:Disconnect(); charConn = nil end
        lastChar = ch
        if not ch then return end
        for _, c in ipairs(ch:GetChildren()) do if c:IsA("Tool") then pcall(quietTool, c) end end
        charConn = ch.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.delay(0.1, function() pcall(quietTool, c) end) end end)
    end
    -- mobile fire button / mouse held also counts as spraying
    local inConn1 = UISb.InputBegan:Connect(function(i)
        if not S.HideBullets then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local ch = L.Character
            if ch and ch:FindFirstChildOfClass("Tool") then fireUntil = os.clock() + 0.8 end
        end
    end)

    local function turnOn()
        if conn then return end
        conn = WS0.DescendantAdded:Connect(onAdded)
        watchChar(L.Character)
    end
    local function turnOff()
        if conn then conn:Disconnect(); conn = nil end
        if charConn then charConn:Disconnect(); charConn = nil end
        clearTools()
        lastChar = nil
        local list = hidden
        hidden = setmetatable({}, { __mode = "k" })
        task.spawn(function()
            local n = 0
            for d, v in pairs(list) do
                n = n + 1
                if n % 400 == 0 then task.wait() end
                if d.Parent then
                    pcall(function()
                        if d:IsA("BasePart") then d.LocalTransparencyModifier = v[1]; d.Transparency = v[2]
                        elseif d:IsA("Decal") then d.Transparency = v
                        else d.Enabled = v end
                    end)
                end
            end
        end)
    end
    task.spawn(function()
        local cur = false
        while true do
            local want = S.HideBullets == true
            if want ~= cur then cur = want; pcall(want and turnOn or turnOff) end
            if cur and L.Character ~= lastChar then pcall(watchChar, L.Character) end
            if cur and L:GetAttribute("MobileFireHeld") == true then fireUntil = os.clock() + 0.6 end
            task.wait(0.25)
        end
        pcall(turnOff)
        pcall(function() inConn1:Disconnect() end)
    end)
end

-- ── COMBAT ──────────────────────────────────────────────────────
local LiteUI = {}
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
toggle(CombatTab, "Silent Aim", "Bullets go to the closest enemy in your FOV (team list is ignored)", "SilentAim", function(v)
    if v then setHook(true); if not hookActive then notify("Silent Aim", "Your executor doesn't support this", "x") end end
end)
add(CombatTab, "Dropdown", {
    Title = "Aim Part", Desc = "Where the bullets land",
    Values = { "Head", "Body" }, Value = S.HeadShots and "Head" or "Body",
    Callback = function(v)
        if typeof(v) == "table" then v = v.Title or v[1] end
        S.HeadShots = (v == "Head")
    end,
})
toggle(CombatTab, "Target Highlight", "Current target's name + studs turn red", "TargetRed")
toggle(CombatTab, "FOV Circle", "Shows your silent aim range", "FOVCircle")
slider(CombatTab, "FOV Size", "Aimbot FOV radius in pixels", "AimbotFOV", 10, 1000, 5)
toggle(CombatTab, "Only While Holding Gun", "Optional: silent aim only while a tool is out. Leave OFF if it stops working", "GunOnly")
toggle(CombatTab, "Skip Safe Zone Players", "Aimbot ignores players in a safe zone / spawn protection (they can't take damage)", "SkipSafe")
LiteUI.MagicBullet = toggle(CombatTab, "Magic Bullet", "Bullets go through walls to the closest player on your screen", "MagicBullet", function(v)
    if v then setHook(true); if not hookActive then notify("Magic Bullet", "Your executor doesn't support this", "x") end end
end)
add(CombatTab, "Section", { Title = "Tracers", TextSize = 14 })
toggle(CombatTab, "Bullet Tracers", "Glowing line from your gun to where every shot goes (only you see it)", "Tracers")
add(CombatTab, "Dropdown", {
    Title = "Tracer Color", Values = { "Red", "Green", "Blue", "Purple", "Gold", "White", "Pink", "Cyan", "Rainbow" }, Value = S.TracerColor,
    Callback = function(v)
        if typeof(v) == "table" then v = v.Title or v[1] end
        if type(v) == "string" then S.TracerColor = v end
    end,
})

-- ── VISUALS ─────────────────────────────────────────────────────
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
toggle(VisualsTab, "Player ESP", "Name · HP bar · studs · guns", "ESP", function(v)
    if not v then for _, e in pairs(esp) do setShown(e, false) end end
end)
toggle(VisualsTab, "Show Name", nil, "ShowName", applyEspParts)
toggle(VisualsTab, "Show Health Bar", nil, "ShowHealth", applyEspParts)
toggle(VisualsTab, "Show Distance", nil, "ShowDist", applyEspParts)
toggle(VisualsTab, "Show Guns", "Every gun they have (held + backpack)", "ShowGuns", applyEspParts)
slider(VisualsTab, "ESP Range", "Studs (free max 1500)", "ESPRange", 100, 1500, 50)
toggle(VisualsTab, "FullBright", "Removes darkness and fog", "FullBright", function(v) applyFullBright(v) end)
toggle(VisualsTab, "Custom Camera FOV", "Zoom out to see more", "CamFOVOn", function(v)
    if not v then Cam.FieldOfView = 70 end
end)
slider(VisualsTab, "Camera FOV", nil, "CamFOV", 70, 120, 1)

-- ── MOVEMENT ────────────────────────────────────────────────────
local MoveTab = Window:Tab({ Title = "Movement", Icon = "zap" })
LiteUI.Speed = toggle(MoveTab, "Speed Hack", "Multiply your WalkSpeed", "Speed", function(v)
    if not v then
        local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)
slider(MoveTab, "Speed Multiplier", "WalkSpeed = 16 × value (free max 3×)", "SpeedMult", 1, 3, 0.5)
LiteUI.InfJump = toggle(MoveTab, "Infinite Jump", "Press jump in the air to jump again", "InfJump")
toggle(MoveTab, "Infinite Stamina", "Keeps stamina full (works in most games)", "InfStamina", function(v)
    if v then stamSetup() else stamClear() end
end)

-- ── GET PAID ────────────────────────────────────────────────────
add(MoveTab, "Section", { Title = "Car", TextSize = 14 })
LiteUI.CarLaunch = toggle(MoveTab, "Launch Control", "From a stop, hitting the gas launches you straight to Launch Speed", "CarLaunch")
slider(MoveTab, "Launch Speed", nil, "CarLaunchSpeed", 30, 300, 5)
LiteUI.CarReverse = slider(MoveTab, "Reverse Speed", "How fast you back up (0 = stock)", "CarReverse", 0, 200, 5)
toggle(MoveTab, "Stability / Anti-Roll", "Car won't tip over on sharp turns or ramps and levels itself out", "CarStable")

local PaidTab = Window:Tab({ Title = "Get Paid", Icon = "star" })
add(PaidTab, "Paragraph", {
    Title = "Paid version includes",
    Desc = "Colored gun ESP (gold / red guns) · Chams · Anti-Kill · Noclip · "
        .. "Unlimited ESP Range + ESP Size · Big FOV · Speed up to 10× · Custom RPM · Multi Shot · Infinite Ammo · "
        .. "Shop (every crate) · Travel (car drives through walls, walks real paths, stops right beside the place) · Car Hub · Pawn Shop seller · Custom gun/car looks · Performance Mode · FPS stats",
})
button(PaidTab, "Buy in the Discord", "Copies the Discord invite link", "message-circle", function()
    copyLink(DISCORD_LINK, "Discord")
end)

-- ── TEAM ────────────────────────────────────────────────────────
local TeamTab = Window:Tab({ Title = "Team", Icon = "users" })
add(TeamTab, "Paragraph", {
    Title = "Team List",
    Desc = "Tap a player to add them. Team = GREEN name + studs, and Silent Aim / Magic Bullet will never target them. Press Save Config to keep your team.",
})
button(TeamTab, "Clear Team List", nil, "trash-2", function()
    S.Friends = {}
    notify("Team", "Team list cleared", "check")
    task.defer(function() _G.__dxf_rebuildTeam() end)
end)
add(TeamTab, "Section", { Title = "Players In Server", TextSize = 14 })

local teamBtns, rebuilding = {}, false
local function buildTeamBtns()
    if rebuilding then return end
    rebuilding = true
    for _, b in ipairs(teamBtns) do pcall(function() b:Destroy() end) end
    teamBtns = {}
    local list = P:GetPlayers()
    table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
    for _, p in ipairs(list) do
        if p ~= L then
            local cp = p
            local on = S.Friends[cp.Name] == true
            local btn = add(TeamTab, "Button", {
                Title = (on and "🟢 " or "⚪ ") .. cp.Name,
                Desc  = on and "On team — green ESP, never targeted" or "Tap to add to team",
                Icon  = on and "user-check" or "user-plus",
                Callback = function()
                    local now = not (S.Friends[cp.Name] == true)
                    S.Friends[cp.Name] = now or nil
                    notify(cp.Name, now and "Added to team" or "Removed from team", now and "user-check" or "user-x")
                    task.defer(buildTeamBtns)
                end,
            })
            if btn then teamBtns[#teamBtns+1] = btn end
        end
    end
    rebuilding = false
end
_G.__dxf_rebuildTeam = buildTeamBtns
buildTeamBtns()

local teamQueued = false
local function queueTeamRebuild()   -- at most once every 2s (busy servers)
    if teamQueued then return end
    teamQueued = true
    task.delay(2, function() teamQueued = false; buildTeamBtns() end)
end
P.PlayerAdded:Connect(queueTeamRebuild)
P.PlayerRemoving:Connect(queueTeamRebuild)

-- ================================================================
-- HIDE NAME: your username / display name shows as "......" on YOUR screen only
-- (overhead name, leaderboard, chat, kill feed, game GUIs...). Other players
-- still see your real name - nothing is sent to the server.
-- ================================================================
local HideName = {}
safeLoad("Hide Name", function()
    local MASK = "●●●●●●"
    local CG = game:GetService("CoreGui")
    local pats = {}
    -- case-insensitive pattern for a name ("Bob_1" -> "[bB][oO][bB]_1")
    local function ciPattern(s)
        return (string.gsub(s, ".", function(c)
            if string.match(c, "%a") then return "[" .. string.lower(c) .. string.upper(c) .. "]" end
            if string.match(c, "[%^%$%(%)%%%.%[%]%*%+%-%?]") then return "%" .. c end
            return c
        end))
    end
    local function buildPats()
        pats = {}
        local list = { L.Name }
        if L.DisplayName and L.DisplayName ~= L.Name and #L.DisplayName >= 3 then list[#list+1] = L.DisplayName end
        table.sort(list, function(a, b) return #a > #b end)
        for _, n in ipairs(list) do pats[#pats+1] = ciPattern(n) end
    end
    buildPats()

    local orig   = setmetatable({}, { __mode = "k" })   -- label -> real text
    local masked = setmetatable({}, { __mode = "k" })   -- label -> text we put there
    local function mask(t)
        local out, total = t, 0
        for _, p in ipairs(pats) do
            local n
            out, n = string.gsub(out, p, MASK)
            total = total + n
        end
        return out, total
    end
    local function apply(lbl)
        if not S.HideName then return end
        local t = lbl.Text
        if masked[lbl] == t then return end
        local out, n = mask(t)
        if n > 0 then
            orig[lbl], masked[lbl] = t, out
            lbl.Text = out
        else
            orig[lbl], masked[lbl] = nil, nil
        end
    end
    local all = setmetatable({}, { __mode = "k" })     -- every text object we watch
    local function hook(d)
        if (d:IsA("TextLabel") or d:IsA("TextButton")) and not all[d] then
            all[d] = true
            pcall(apply, d)
            d:GetPropertyChangedSignal("Text"):Connect(function() pcall(apply, d) end)
        end
    end

    -- overhead name: Humanoid.DisplayName + the game's own name tag
    -- (HumanoidRootPart.CharacterBillboardGui.PlayerName) -> "......" (local only)
    local realDisplay = {}
    local tagOrig = setmetatable({}, { __mode = "k" })
    local NAME_LABELS = { playername = true, username = true, displayname = true, nametag = true, name = true, nametext = true, playernametext = true }
    -- every BillboardGui / SurfaceGui anywhere (workspace, PlayerGui, CoreGui) - the game
    -- can keep your name tag outside your character and just point it at your head
    local boards = setmetatable({}, { __mode = "k" })
    local function addBoard(d)
        if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then boards[d] = true end
    end
    local function isMine(g, char)
        if g:IsDescendantOf(char) then return true end
        local a = g.Adornee
        if a and a:IsDescendantOf(char) then return true end
        local par = g.Parent
        if par and par:IsA("BasePart") and par:IsDescendantOf(char) then return true end
        -- tag models named after you (e.g. workspace.NameTags.YourName)
        local n = g.Parent and g.Parent.Name
        if n == L.Name or n == L.Name .. "Tag" or n == L.Name .. "_Tag" then return true end
        return false
    end
    local function maskLabel(lbl, on)
        if lbl.Name == "DrixHide" then return end
        if on then
            local t = lbl.Text
            if t == MASK or t == "" then return end
            local out, hits = mask(t)
            local low = string.lower(t)
            local byName = NAME_LABELS[string.lower(lbl.Name)] ~= nil
            local exact = low == string.lower(L.DisplayName) or low == "@" .. string.lower(L.Name) or low == string.lower(L.Name)
            if hits > 0 or exact or (byName and not string.find(low, "lv", 1, true) and not string.find(low, "level", 1, true)) then
                if tagOrig[lbl] == nil then tagOrig[lbl] = t end
                -- keep the level: "[Lv 12] Name" -> "[Lv 12] ......"
                local put = (hits > 0 and not exact) and out or MASK
                masked[lbl] = put
                lbl.Text = put
            end
        elseif tagOrig[lbl] then
            if lbl.Text == masked[lbl] or lbl.Text == MASK then lbl.Text = tagOrig[lbl] end
            tagOrig[lbl] = nil
            masked[lbl] = nil
        end
    end
    -- this game's tag: HumanoidRootPart.CharacterBillboardGui.PlayerName
    -- The game keeps re-writing that label, so instead of fighting over its text we
    -- make the real text invisible and put our own big dots on top of it (a child
    -- label the game doesn't know about). Checked every frame, so it never comes back.
    -- LevelText / LevelImage / icons are left alone so your level still shows.
    local RunS = game:GetService("RunService")
    local tag = { nextFind = 0 }
    local function findTagLabel(char)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cbg = hrp and hrp:FindFirstChild("CharacterBillboardGui")
        if not cbg then
            for _, g in ipairs(char:GetChildren()) do
                local x = g:FindFirstChild("CharacterBillboardGui")
                if x then cbg = x; break end
            end
        end
        local lbl = cbg and cbg:FindFirstChild("PlayerName", true)
        if lbl and (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return lbl end
        return nil
    end
    local function unTag()
        local t = tag
        tag = { nextFind = 0 }
        if t.over then pcall(function() t.over:Destroy() end) end
        if t.lbl and t.lbl.Parent then
            pcall(function() t.lbl.TextTransparency = t.tt or 0; t.lbl.TextStrokeTransparency = t.st or 1 end)
        end
    end
    local function makeOver(lbl)
        local o = Instance.new("TextLabel")
        o.Name = "DrixHide"
        o.BackgroundTransparency = 1
        o.AnchorPoint = Vector2.new(0.5, 0.5)
        o.Position = UDim2.fromScale(0.5, 0.5)
        o.Size = UDim2.fromScale(1, 1.6)            -- taller box = bigger dots
        o.Text = MASK
        o.TextScaled = true
        o.Font = Enum.Font.GothamBlack
        o.TextColor3 = lbl.TextColor3
        o.TextStrokeColor3 = lbl.TextStrokeColor3
        o.TextStrokeTransparency = math.min(tag.st or 1, 0.4)
        o.ZIndex = lbl.ZIndex + 1
        o.Parent = lbl
        return o
    end
    local function tagStep()
        if not S.HideName then
            if tag.lbl or tag.over then unTag() end
            return
        end
        local char = L.Character
        if not char then return end
        local lbl = tag.lbl
        if not (lbl and lbl.Parent and lbl:IsDescendantOf(char)) then
            if os.clock() < tag.nextFind then return end
            tag.nextFind = os.clock() + 0.2
            if tag.over then pcall(function() tag.over:Destroy() end) end
            tag.over = nil
            lbl = findTagLabel(char)
            tag.lbl = lbl
            if not lbl then return end
            tag.tt, tag.st = lbl.TextTransparency, lbl.TextStrokeTransparency
            if tag.tt >= 1 then tag.tt = 0 end
        end
        if lbl.TextTransparency ~= 1 then lbl.TextTransparency = 1 end
        if lbl.TextStrokeTransparency ~= 1 then lbl.TextStrokeTransparency = 1 end
        local o = tag.over
        if not (o and o.Parent == lbl) then
            if o then pcall(function() o:Destroy() end) end
            tag.over = makeOver(lbl)
            o = tag.over
        end
        if o.Text ~= MASK then o.Text = MASK end
        if o.TextColor3 ~= lbl.TextColor3 then o.TextColor3 = lbl.TextColor3 end
    end
    local tagConn = nil
    local function doGameTag(_, on)
        if on then
            if not tagConn then local tn = 0; tagConn = RunS.Heartbeat:Connect(function() if S.PerfMode or S.FPSBoost then tn = tn + 1; if tn % 2 == 1 then return end end pcall(tagStep) end) end
            pcall(tagStep)
        else
            if tagConn then tagConn:Disconnect(); tagConn = nil end
            unTag()
        end
    end
    local function doOverhead(on)
        local char = L.Character
        if not char then return end
        pcall(doGameTag, char, on)
        local seen = {}
        local function doGui(g)
            if seen[g] then return end
            seen[g] = true
            for _, lbl in ipairs(g:GetDescendants()) do
                if lbl:IsA("TextLabel") or lbl:IsA("TextButton") or lbl:IsA("TextBox") then pcall(maskLabel, lbl, on) end
            end
        end
        for _, g in ipairs(char:GetDescendants()) do
            if g:IsA("BillboardGui") or g:IsA("SurfaceGui") then doGui(g) end
        end
        for g in pairs(boards) do
            if g.Parent and isMine(g, char) then doGui(g) end
        end
        if not on then
            for lbl in pairs(tagOrig) do pcall(maskLabel, lbl, false) end
        end
    end
    local function doHumanoid(on)
        pcall(doOverhead, on)
        local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if on then
            if hum.DisplayName ~= MASK then
                realDisplay[hum] = hum.DisplayName
                hum.DisplayName = MASK
            end
        elseif realDisplay[hum] then
            hum.DisplayName = realDisplay[hum]
            realDisplay[hum] = nil
        end
    end

    local started = false
    local function start()
        if started then return end
        started = true
        local roots = { L:WaitForChild("PlayerGui") }
        pcall(function() roots[#roots+1] = CG end)
        pcall(function() if gethui then local h = gethui(); if h ~= CG then roots[#roots+1] = h end end end)
        for _, root in ipairs(roots) do
            pcall(function()
                root.DescendantAdded:Connect(hook)
                task.spawn(function()
                    local n = 0
                    for _, d in ipairs(root:GetDescendants()) do
                        n = n + 1
                        if n % 800 == 0 then task.wait() end
                        hook(d)
                    end
                end)
            end)
        end
        -- name tags / billboards in the world (only GUI text, cheap class check)
        workspace.DescendantAdded:Connect(function(d)
            if d:IsA("TextLabel") or d:IsA("TextButton") then task.defer(hook, d)
            elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then addBoard(d); if S.HideName then task.delay(0.2, function() pcall(doOverhead, true) end) end end
        end)
        task.spawn(function()
            local n = 0
            for _, d in ipairs(workspace:GetDescendants()) do
                n = n + 1
                if n % 1500 == 0 then task.wait() end
                if d:IsA("TextLabel") or d:IsA("TextButton") then hook(d) else addBoard(d) end
            end
        end)
        for _, root in ipairs(roots) do
            pcall(function()
                root.DescendantAdded:Connect(function(d)
                    if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then addBoard(d); if S.HideName then task.delay(0.2, function() pcall(doOverhead, true) end) end end
                end)
                task.spawn(function()
                    local n = 0
                    for _, d in ipairs(root:GetDescendants()) do
                        n = n + 1
                        if n % 1000 == 0 then task.wait() end
                        addBoard(d)
                    end
                end)
            end)
        end
        L.CharacterAdded:Connect(function()
            task.wait(0.5)
            if S.HideName then doHumanoid(true) end
        end)
        L:GetPropertyChangedSignal("DisplayName"):Connect(buildPats)
        -- keep the name above your head hidden (tags get rebuilt on respawn / level up)
        task.spawn(function()
            while true do
                task.wait(0.5)
                if S.HideName then pcall(doHumanoid, true) end
            end
        end)
    end

    function HideName.set(on)
        S.HideName = on
        if on then
            start()
            doHumanoid(true)
            -- re-mask everything we already watch
            task.spawn(function()
                local n = 0
                for lbl in pairs(all) do
                    n = n + 1
                    if n % 800 == 0 then task.wait() end
                    pcall(apply, lbl)
                end
            end)
        else
            doHumanoid(false)
            for lbl, real in pairs(orig) do
                pcall(function() if lbl.Text == masked[lbl] then lbl.Text = real end end)
            end
            orig   = setmetatable({}, { __mode = "k" })
            masked = setmetatable({}, { __mode = "k" })
        end
    end

    if S.HideName then task.defer(HideName.set, true) end
end)

-- ── SOCIALS ─────────────────────────────────────────────────────
-- ── LARP (visual cars - only YOU see them) ─────────────────────────
-- Add any car to your inventory screen, spawn visual cars and drive them.
-- Nothing is bought or sent to the game: other players only see YOU moving.
safeLoad("LARP", function()
    local RSx   = game:GetService("ReplicatedStorage")
    local RunX  = game:GetService("RunService")
    local UISx  = game:GetService("UserInputService")
    local carsF = RSx:FindFirstChild("DrivableCars")
    local Larp  = { cars = {}, inv = {}, pick = nil, maxSpeed = 60 }

    local function carList()
        local t = {}
        if carsF then for _, c in ipairs(carsF:GetChildren()) do if c:IsA("Model") then t[#t+1] = c.Name end end end
        table.sort(t)
        if #t == 0 then t = { "(no cars found)" } end
        return t
    end
    Larp.pick = carList()[1]

    local function myChar()
        local ch = L.Character
        return ch, ch and ch:FindFirstChildOfClass("Humanoid"), ch and ch:FindFirstChild("HumanoidRootPart")
    end
    local function seatOf(m)
        local s = m:FindFirstChild("DriverSeat", true) or m:FindFirstChild("DriveSeat", true)
        if s and s:IsA("BasePart") then return s end
        for _, d in ipairs(m:GetDescendants()) do if d:IsA("VehicleSeat") or d:IsA("Seat") then return d end end
        return m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)
    end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local function refreshFilter()
        local ex = {}
        local ch = L.Character
        if ch then ex[#ex+1] = ch end
        for _, c in ipairs(Larp.cars) do if c.model.Parent then ex[#ex+1] = c.model end end
        rp.FilterDescendantsInstances = ex
    end
    local function groundY(pos)
        local hit = workspace:Raycast(pos + Vector3.new(0, 8, 0), Vector3.new(0, -60, 0), rp)
        return hit and hit.Position.Y or nil
    end

    -- ── driving ──────────────────────────────────────────────────
    local driving, driveConn, jumpConn = nil, nil, nil
    local controls
    pcall(function()
        local pm = L:WaitForChild("PlayerScripts", 5):WaitForChild("PlayerModule", 5)
        controls = require(pm):GetControls()
    end)
    local function moveInput()
        local v
        if controls then pcall(function() v = controls:GetMoveVector() end) end
        if not v or v.Magnitude < 0.05 then
            local f = (UISx:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UISx:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
            local r = (UISx:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UISx:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
            v = Vector3.new(r, 0, -f)
        end
        return -v.Z, v.X      -- throttle, steer
    end
    local function exitCar()
        local c = driving
        driving = nil
        if driveConn then driveConn:Disconnect(); driveConn = nil end
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
        local _, hum, hrp = myChar()
        if hum then hum.Sit = false end
        if c and c.model.Parent and hrp then
            local s = seatOf(c.model)
            if s then hrp.CFrame = s.CFrame * CFrame.new(-7, 1, 0) end
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
    Larp.exit = exitCar
    local function enterCar(c)
        if driving then exitCar() end
        local _, hum, hrp = myChar()
        local seat = c and c.model.Parent and seatOf(c.model)
        if not (hum and hrp and seat) then return end
        refreshFilter()
        local look = seat.CFrame.LookVector
        local yaw = math.atan2(-look.X, -look.Z)
        local base = CFrame.new(seat.Position) * CFrame.Angles(0, yaw, 0)
        local rel = base:ToObjectSpace(c.model:GetPivot())
        local g0 = groundY(seat.Position) or (seat.Position.Y - 3)
        local seatH = seat.Position.Y - g0
        local seatOff = CFrame.new(0, seat.Size.Y / 2 + 1.6, 0)
        local pos, speed, y = seat.Position, 0, seat.Position.Y
        driving = c
        hum.Sit = true
        jumpConn = UISx.JumpRequest:Connect(function() if driving == c then exitCar() end end)
        driveConn = RunX.Heartbeat:Connect(function(dt)
            if driving ~= c or not c.model.Parent or not hrp.Parent or hum.Health <= 0 then return exitCar() end
            local th, st = moveInput()
            local top = Larp.maxSpeed
            if th > 0.05 then speed = math.min(top, speed + 45 * dt * th)
            elseif th < -0.05 then speed = math.max(-top * 0.4, speed + 70 * dt * th)
            else speed = speed - math.sign(speed) * math.min(math.abs(speed), 25 * dt) end
            yaw = yaw - st * 1.9 * dt * math.clamp(speed / 14, -1, 1)
            local dir = Vector3.new(-math.sin(yaw), 0, -math.cos(yaw))
            pos = pos + dir * speed * dt
            local g = groundY(pos)
            if g then
                local want = g + seatH
                y = (want > y) and math.min(want, y + 60 * dt + 0.5) or math.max(want, y - 60 * dt)
            end
            local cf = CFrame.new(pos.X, y, pos.Z) * CFrame.Angles(0, yaw, 0)
            c.model:PivotTo(cf * rel)
            if not hum.Sit then hum.Sit = true end
            hrp.CFrame = seat.CFrame * seatOff
            hrp.AssemblyLinearVelocity = dir * speed
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    -- ── spawn a visual car ───────────────────────────────────────
    function Larp.spawn(name)
        local tpl = carsF and carsF:FindFirstChild(name or "")
        if not tpl then notify("LARP", "Car not found: " .. tostring(name), "x"); return end
        local _, _, hrp = myChar()
        if not hrp then return end
        local m = tpl:Clone()
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("LuaSourceContainer") or d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("ProximityPrompt")
                or d:IsA("BillboardGui") or d:IsA("Sound") then
                pcall(function() d:Destroy() end)
            end
        end
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Anchored = true; d.CanCollide = false; d.CanTouch = false
                pcall(function() d.CanQuery = false end)
            end
        end
        m.Name = "DrixVisualCar_" .. name
        local bcf, bsize = m:GetBoundingBox()
        local pivot = m:GetPivot()
        local up = pivot.Position.Y - (bcf.Position.Y - bsize.Y / 2)
        local spot = (hrp.CFrame * CFrame.new(0, 0, -(bsize.Z / 2 + 8))).Position
        refreshFilter()
        local g = groundY(spot) or (hrp.Position.Y - 3)
        local look = hrp.CFrame.LookVector
        m:PivotTo(CFrame.new(spot.X, g + up + 0.2, spot.Z) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0) * pivot.Rotation)
        m.Parent = workspace
        local c = { model = m, name = name }
        Larp.cars[#Larp.cars+1] = c
        refreshFilter()
        -- "Drive" prompt on the seat (only you see it)
        local seat = seatOf(m)
        if seat then
            local pr = Instance.new("ProximityPrompt")
            pr.ActionText, pr.ObjectText = "Drive", name .. " (visual)"
            pr.HoldDuration, pr.MaxActivationDistance, pr.RequiresLineOfSight = 0, 14, false
            pr.Parent = seat
            pr.Triggered:Connect(function() enterCar(c) end)
        end
        notify("LARP", name .. " spawned — press Drive next to it (jump = get out)", "car")
        return c
    end
    function Larp.driveNearest()
        local _, _, hrp = myChar()
        if not hrp then return end
        local best, bd = nil, math.huge
        for _, c in ipairs(Larp.cars) do
            if c.model.Parent then
                local d = (c.model:GetPivot().Position - hrp.Position).Magnitude
                if d < bd then best, bd = c, d end
            end
        end
        if best then enterCar(best) else notify("LARP", "Spawn a visual car first", "x") end
    end
    function Larp.clear()
        if driving then exitCar() end
        for _, c in ipairs(Larp.cars) do pcall(function() c.model:Destroy() end) end
        Larp.cars = {}
    end

    -- ── fake cars in your inventory screen ───────────────────────
    local function slots()
        local pgx = L:FindFirstChildOfClass("PlayerGui")
        local inv = pgx and pgx:FindFirstChild("InventoryGui")
        local box = inv and inv:FindFirstChild("SlotsContainer", true)
        return box
    end
    local function templateCard(box)
        for _, c in ipairs(box:GetChildren()) do
            if string.match(c.Name, "^CarCard_") and not c:GetAttribute("DrixVisual") then return c end
        end
        for _, c in ipairs(box:GetChildren()) do
            if string.match(c.Name, "^WeaponCard_") then return c end
        end
        return nil
    end
    -- car picture from the game's own crate list (light - no 3D model on the card)
    local carImages = {}
    pcall(function()
        local m = RSx:FindFirstChild("CrateConfig")
        local ok, cfg = pcall(require, m)
        if ok and type(cfg) == "table" and type(cfg.CarImages) == "table" then carImages = cfg.CarImages end
    end)
    local function putPreview(card, name)
        local id = carImages[name]
        if not id then
            for k, v in pairs(carImages) do
                if string.find(string.lower(name), string.lower(k), 1, true) then id = v; break end
            end
        end
        if not id then return end
        local best, area = nil, 0
        for _, d in ipairs(card:GetDescendants()) do
            if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and not d:FindFirstAncestor("NameBand") then
                local sz = d.Size
                local a = (sz.X.Scale * 200 + sz.X.Offset) * (sz.Y.Scale * 200 + sz.Y.Offset) + 1
                if a > area then best, area = d, a end
            end
        end
        if best then best.Image = "rbxassetid://" .. tostring(id); best.ImageTransparency = 0 end
    end
    local function makeCard(box, name)
        local src = templateCard(box)
        if not src then return nil end
        local card = src:Clone()
        card.Name = "CarCard_" .. name
        card:SetAttribute("DrixVisual", true)
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("LuaSourceContainer") then d:Destroy()
            elseif d:IsA("TextLabel") or d:IsA("TextButton") then
                if d.Name == "NameLabel" then d.Text = name
                elseif d.Name == "SpawnedBadge" or d.Name == "SlotBadge" or d.Name == "PermanentBadge" then d.Visible = false end
            end
        end
        local click = card:IsA("GuiButton") and card or nil
        if not click then
            click = Instance.new("TextButton")
            click.Name = "DrixClick"
            click.BackgroundTransparency, click.Text = 1, ""
            click.Size = UDim2.fromScale(1, 1)
            click.ZIndex = 50
            click.Parent = card
        end
        click.Activated:Connect(function() Larp.spawn(name) end)
        card.Parent = box
        task.defer(function() pcall(putPreview, card, name) end)
        return card
    end
    function Larp.addInv(name)
        if not (carsF and carsF:FindFirstChild(name or "")) then return false end
        Larp.inv[name] = true
        local box = slots()
        if not box then notify("LARP", "Open your inventory once, then press it again", "x"); return false end
        if not box:FindFirstChild("CarCard_" .. name) then
            if not makeCard(box, name) then notify("LARP", "Your inventory has no card to copy yet", "x"); return false end
        end
        return true
    end
    function Larp.clearInv()
        Larp.inv = {}
        local box = slots()
        if box then for _, c in ipairs(box:GetChildren()) do if c:GetAttribute("DrixVisual") then c:Destroy() end end end
    end
    -- the game rebuilds the inventory sometimes -> put the visual cards back
    task.spawn(function()
        while task.wait(2) do
            if next(Larp.inv) then
                local box = slots()
                if box then
                    for n in pairs(Larp.inv) do
                        if not box:FindFirstChild("CarCard_" .. n) then pcall(makeCard, box, n) end
                    end
                end
            end
        end
    end)

    -- ── random outfit (REAL clothes - everyone sees them) ─────────
    -- uses the game's own clothing shop call: ClothingShopEvent("EQUIP", category, name)
    local Outfit = {}
    do
        local ev = RSx:FindFirstChild("ClothingShopEvent") or RSx:WaitForChild("ClothingShopEvent", 10)
        local items, equipped, lastOk = nil, {}, {}
        local rng = Random.new()
        if ev then
            ev.OnClientEvent:Connect(function(kind, a, b)
                if kind == "INIT_DATA" then
                    if type(a) == "table" then equipped = a end
                    if type(b) == "table" then items = b end
                elseif kind == "EQUIP_SUCCESS" then
                    equipped[a] = b; lastOk[tostring(a) .. "|" .. tostring(b)] = os.clock()
                elseif kind == "UNEQUIP_SUCCESS" then
                    if equipped[a] == b then equipped[a] = nil end
                    lastOk["-" .. tostring(a) .. "|" .. tostring(b)] = os.clock()
                end
            end)
        end
        local function waitOk(key, t)
            local t0 = os.clock()
            while os.clock() - t0 < (t or 2.5) do
                if lastOk[key] and lastOk[key] >= t0 - 0.05 then return true end
                task.wait(0.1)
            end
            return false
        end
        local function pickOther(list, cur)
            if #list == 0 then return nil end
            if #list == 1 then return list[1] end
            local v
            repeat v = list[rng:NextInteger(1, #list)] until v ~= cur
            return v
        end
        -- what is actually on the character (the shop data can miss a jacket / hoodie)
        local function wornOf(names)
            local set, out = {}, {}
            for _, n in ipairs(names) do set[n] = true end
            local ch = L.Character
            if ch then
                for _, a in ipairs(ch:GetChildren()) do
                    local g = a:IsA("Accessory") and (a:GetAttribute("ClothingGroup") or a.Name)
                    if g and set[g] and not table.find(out, g) then out[#out+1] = g end
                end
            end
            return out
        end
        function Outfit.random()
            if not ev then return false, "no clothing shop in this game" end
            items = nil
            ev:FireServer("REQUEST_DATA")
            local t0 = os.clock()
            while not items and os.clock() - t0 < 5 do task.wait(0.1) end
            if not items then return false, "the clothing shop didn't answer" end
            local by = {}
            for _, it in ipairs(items) do
                if type(it) == "table" and it.name and it.category then
                    by[it.category] = by[it.category] or {}
                    table.insert(by[it.category], it.name)
                end
            end
            local shirts, jackets, hoodies = by.TShirt or {}, by.Jacket or {}, by.Sweatshirt or {}
            if #shirts == 0 then return false, "no shirts found" end
            -- hoodies cover the shirt -> take them off
            for _, h in ipairs(wornOf(hoodies)) do ev:FireServer("UNEQUIP", "Sweatshirt", h); task.wait(0.35) end
            if equipped.Sweatshirt then ev:FireServer("UNEQUIP", "Sweatshirt", equipped.Sweatshirt); task.wait(0.35) end
            local shirt = pickOther(shirts, equipped.TShirt)
            ev:FireServer("EQUIP", "TShirt", shirt)
            if not waitOk("TShirt|" .. shirt) then return false, "the game didn't accept the shirt (open the clothing shop once)" end
            task.wait(0.35)
            local jacket = nil
            if #jackets > 0 and rng:NextNumber() < 0.5 then
                jacket = pickOther(jackets, equipped.Jacket)
                ev:FireServer("EQUIP", "Jacket", jacket)
                waitOk("Jacket|" .. jacket)
            else
                local worn = wornOf(jackets)
                if equipped.Jacket and not table.find(worn, equipped.Jacket) then worn[#worn+1] = equipped.Jacket end
                for _, j in ipairs(worn) do ev:FireServer("UNEQUIP", "Jacket", j); task.wait(0.35) end
            end
            return true, shirt, jacket
        end
        function Outfit.announce()
            local ok, a, b = Outfit.random()
            if ok then notify("Outfit", "Fit: " .. a .. (b and (" + " .. b) or " (no jacket)"), "shirt")
            else notify("Outfit", "Couldn't change clothes: " .. tostring(a), "x") end
        end
        -- new random fit every time the script runs
        task.spawn(function()
            local t0 = os.clock()
            while not (L.Character and L:GetAttribute("DataLoadReady") ~= false) and os.clock() - t0 < 25 do task.wait(0.5) end
            task.wait(3)
            pcall(Outfit.announce)
        end)
    end

    -- ── tab ──────────────────────────────────────────────────────
    local LarpTab = Window:Tab({ Title = "LARP", Icon = "car-front" })
    LarpTab:Paragraph({ Title = "Visual Cars", Desc = "Only YOU see these cars. Nothing is bought. Other players just see you moving." })
    LarpTab:Dropdown({
        Title = "Car", Values = carList(), Value = Larp.pick,
        Callback = function(v)
            if typeof(v) == "table" then v = v.Title or v[1] end
            Larp.pick = tostring(v)
        end,
    })
    LarpTab:Button({
        Title = "Add To Inventory", Desc = "Puts this car in your inventory screen (tap the card to spawn it)", Icon = "plus",
        Callback = function() if Larp.addInv(Larp.pick) then notify("LARP", Larp.pick .. " added to your inventory", "check") end end,
    })
    LarpTab:Button({
        Title = "Add ALL Cars To Inventory", Desc = "Every car in the game shows up in your inventory", Icon = "layers",
        Callback = function()
            local n = 0
            for _, name in ipairs(carList()) do if Larp.addInv(name) then n = n + 1 end end
            if n > 0 then notify("LARP", n .. " cars added to your inventory", "check") end
        end,
    })
    LarpTab:Button({
        Title = "Remove From Inventory", Desc = "Removes the visual cars from your inventory screen", Icon = "trash-2",
        Callback = function() Larp.clearInv(); notify("LARP", "Visual cars removed from your inventory", "check") end,
    })
    LarpTab:Space()
    LarpTab:Section({ Title = "Spawn + Drive", TextSize = 14 })
    LarpTab:Button({
        Title = "Spawn Visual Car", Desc = "Spawns it in front of you · press it again for more cars", Icon = "car",
        Callback = function() Larp.spawn(Larp.pick) end,
    })
    LarpTab:Button({
        Title = "Drive Nearest Visual Car", Desc = "Gets you in · jump (or the button below) to get out", Icon = "navigation",
        Callback = function() Larp.driveNearest() end,
    })
    LarpTab:Button({
        Title = "Get Out", Icon = "log-out",
        Callback = function() Larp.exit() end,
    })
    LarpTab:Slider({
        Title = "Visual Car Speed", Desc = "Top speed (very high speeds can get you flagged by the game)",
        Step = 5, Value = { Min = 20, Max = 120, Default = Larp.maxSpeed },
        Callback = function(v) Larp.maxSpeed = tonumber(v) or 60 end,
    })
    LarpTab:Button({
        Title = "Delete Visual Cars", Desc = "Removes every visual car you spawned", Icon = "trash",
        Callback = function() Larp.clear(); notify("LARP", "Visual cars deleted", "check") end,
    })
    LarpTab:Space()
    LarpTab:Section({ Title = "Outfit", TextSize = 14 })
    LarpTab:Paragraph({ Title = "Random Outfit", Desc = "Every time the script runs you get a random shirt + 50/50 jacket. Real clothes: everyone sees them." })
    LarpTab:Button({
        Title = "Random Outfit Now", Desc = "Random shirt + 50/50 jacket", Icon = "shirt",
        Callback = function() task.spawn(Outfit.announce) end,
    })
end)

-- ── PERFORMANCE ─────────────────────────────────────────────────
local PerfTab = Window:Tab({ Title = "Performance", Icon = "activity" })
add(PerfTab, "Section", { Title = "Auto", TextSize = 14 })
LiteUI.AutoLite = toggle(PerfTab, "Auto Performance (Android / low FPS)", "On: checks your FPS and turns on Performance Mode + FPS Boost + Hide Bullets if it's under 40. Off: puts them back", "AutoLite")
add(PerfTab, "Section", { Title = "Boosts", TextSize = 14 })
LiteUI.PerfMode = toggle(PerfTab, "Performance Mode", "Lighter updates: ESP every 2nd frame, fewer tracers, lighter Hide Name — use on weaker phones", "PerfMode")
LiteUI.FPSBoost = toggle(PerfTab, "FPS Boost (low FPS? turn this on)", "Lowers YOUR graphics: no shadows, effects, particles, water waves. Off = back to normal", "FPSBoost")
LiteUI.HideBullets = toggle(PerfTab, "Hide Bullets (no lag when spraying)", "Bullets, shells, impacts + muzzle flash aren't drawn on your screen. Shooting works the same", "HideBullets")
add(PerfTab, "Section", { Title = "Info", TextSize = 14 })
toggle(PerfTab, "Show FPS", nil, "ShowFPS", function(v) fpsLbl.Visible = v end)

local SocialsTab = Window:Tab({ Title = "Socials", Icon = "share-2" })
button(SocialsTab, "Copy this owners TikTok link", "@drixnvsp", "music", function() copyLink(TIKTOK_LINK, "TikTok") end)
button(SocialsTab, "Join Discord", "Copies the Discord invite link", "message-circle", function() copyLink(DISCORD_LINK, "Discord") end)

-- ── MISC ────────────────────────────────────────────────────────
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
toggle(MiscTab, "Hide Name", "Your name shows as ●●●●●● on YOUR screen, even above your head (others still see it)", "HideName", function(v) HideName.set(v) end)
toggle(MiscTab, "Anti-AFK", "Stops you getting kicked for being idle", "AntiAFK")
button(MiscTab, "Rejoin Server", nil, "refresh-cw", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, L)
end)
button(MiscTab, "Reset Character", nil, "user-x", function()
    local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

-- ── CONFIG ──────────────────────────────────────────────────────
local CfgTab = Window:Tab({ Title = "Config", Icon = "save" })
button(CfgTab, "Save Config", "Saves all your settings — they load automatically next time", "save", function()
    if saveConfig() then notify("Config", "Saved! It will auto-load every time you execute", "check")
    else notify("Config", "Your executor can't save files", "x") end
end)
button(CfgTab, "Reset Config", "Deletes your saved settings (defaults next time you execute)", "trash-2", function()
    if delfile and isfile and isfile(CFG_FILE) then delfile(CFG_FILE) end
    notify("Config", "Saved config deleted", "trash-2")
end)

-- apply loaded settings that need a kick-start
if S.FullBright then pcall(applyFullBright, true) end
if S.InfStamina then task.delay(1.5, function() pcall(stamSetup) end) end
if S.SilentAim or S.MagicBullet then setHook(true) end

pcall(function() Window:SelectTab(1) end)

notify("drixnvsp FREE", cfgLoaded and "Loaded + your config auto-loaded!" or "Loaded! Get the paid version in the Discord", "check")
print("drixnvsp FREE loaded")


-- ================================================================
-- AUTO PERFORMANCE  (Android / weak phones)  - Performance tab
--   ON : checks your FPS. Under 40 FPS it turns on Performance Mode + FPS Boost +
--        Hide Bullets for you (re-checks every 10 s).
--   OFF: puts back anything it turned on.
--   If you turn one of those off yourself, it won't turn it back on.
-- ================================================================
safeLoad("Auto Performance", function()
    local KEYS = { "PerfMode", "FPSBoost", "HideBullets" }
    local applied, declined = {}, {}
    local function setKey(k, v)
        S[k] = v
        local el = LiteUI[k]
        if el then pcall(function() el:Set(v) end) end
        S[k] = v
    end
    local function measure(secs)
        local frames, t0 = 0, os.clock()
        local c = game:GetService("RunService").RenderStepped:Connect(function() frames = frames + 1 end)
        task.wait(secs)
        pcall(function() c:Disconnect() end)
        return frames / math.max(os.clock() - t0, 0.01)
    end
    task.spawn(function()
        task.wait(6)
        local was = false
        while true do
            if S.AutoLite then
                if not was then was = true; declined = {} end
                for k in pairs(applied) do   -- you turned it off yourself -> leave it off
                    if S[k] ~= true then applied[k] = nil; declined[k] = true end
                end
                local need = false
                for _, k in ipairs(KEYS) do if S[k] ~= true and not declined[k] then need = true end end
                if need then
                    local fps = measure(4)
                    if S.AutoLite and fps < 40 then
                        local any = false
                        for _, k in ipairs(KEYS) do
                            if S[k] ~= true and not declined[k] then setKey(k, true); applied[k] = true; any = true end
                        end
                        if any then
                            notify("Low FPS (" .. math.floor(fps + 0.5) .. ")", "Auto Performance turned on Performance Mode + FPS Boost + Hide Bullets", "zap")
                        end
                    end
                end
                for _ = 1, 20 do if not S.AutoLite then break end task.wait(0.5) end
            else
                if was then
                    was = false
                    local any = false
                    for k in pairs(applied) do if S[k] == true then setKey(k, false); any = true end end
                    applied = {}
                    if any then notify("Auto Performance", "Off - put your settings back to how they were", "zap") end
                end
                task.wait(0.5)
            end
        end
    end)
end)
