-- Cookies Hub ([FPS] One Tap)  [KEYLESS]
-- RightShift: show/hide | X button or _G.CookiesHubOneTap.Unload(): unload
-- Console: _G.CookiesHubOneTap.Set("Aimbot", true)
--
-- Read live from [FPS] One Tap (place 90568084448279):
--  * Free-for-all only (workspace attr gamemodeName = "FFA", no Teams): everyone else is an enemy.
--  * Every character (players + bots) is tagged "Character" with CollectionService. Bots are plain models in
--    workspace (no Player). R6 rigs; invisible hit parts in a "Hitbox" (players) / "Hitbox_Bots" (bots) folder:
--    Hitbox_Head, Hitbox_Torso, Hitbox_Left Arm ... Character attrs: deployed, currentWeapon (Primary/Secondary/Knife),
--    primaryWeapon, secondaryWeapon, knifeName, killstreak. ForceField = spawn protection.
--  * PlayerScripts.Start.Game.WeaponClient (require gives the live module):
--      .fire() shoots from your Head along Camera.CFrame.LookVector (yields for the fire-rate wait),
--      the hit is found on the client by WeaponManager.cast (FastCast, 3850 studs/s, no gravity) and sent with
--      useWeapon.send. The cast only ignores your character, so a redirected shot also has to ignore the camera
--      (your viewmodel lives in it). getBullets upvalue 3 = { Primary = n, Secondary = n } (client-side mag).
--      fire upvalue 1 = the real fire closure; its upvalue 1 = time of the last weapon switch (0.3 s lock).
--  * WeaponManager.getWeaponData(name) = { firerate, magazine, reloadTime, isPistol, ... } (nil = game defaults).
--  * No recoil or spread exists in this game, and guns only fire on click (no full auto).
--  * Backend.DeployClient.deploy() = the game's own deploy.
-- Save this file as UTF-8 WITHOUT a BOM or it won't load.

if _G.CookiesHubOneTap and _G.CookiesHubOneTap.Unload then pcall(_G.CookiesHubOneTap.Unload) end

local Players          = game:GetService("Players")
local RS               = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local Workspace        = game:GetService("Workspace")
local lp               = Players.LocalPlayer

-- ---------- guard ----------
if not game:IsLoaded() then game.Loaded:Wait() end
local startFolder = lp:WaitForChild("PlayerScripts"):WaitForChild("Start", 15)
local managers = RS:WaitForChild("Common", 15) and RS.Common:WaitForChild("Managers", 15)
if not (startFolder and managers and managers:FindFirstChild("WeaponManager")) then
    warn("[CookiesHub OneTap] Not [FPS] One Tap (missing PlayerScripts.Start / Common.Managers.WeaponManager). Aborting.")
    return
end
local okWC, WC = pcall(require, startFolder:WaitForChild("Game"):WaitForChild("WeaponClient"))
local okWM, WM = pcall(require, managers.WeaponManager)
local okCM, CM = pcall(require, managers:WaitForChild("CharacterManager"))
local okDC, DC = pcall(require, startFolder:WaitForChild("Backend"):WaitForChild("DeployClient"))
if not (okWC and type(WC) == "table" and type(WC.fire) == "function" and okWM and type(WM) == "table") then
    warn("[CookiesHub OneTap] Couldn't load the game's WeaponClient / WeaponManager. Aborting.")
    return
end
if not (okCM and type(CM) == "table") then CM = nil end
if not (okDC and type(DC) == "table") then DC = nil end
local alive = true   -- cleared on Unload so every loop exits

-- ---------- settings (per account) ----------
local S = {
    -- aim
    Aimbot        = false,
    AimKey        = "Right mouse",   -- Right mouse | Left mouse | Always
    AimPart       = "Head",          -- Head | Torso | Closest (body part nearest the crosshair)
    TargetPriority = "Crosshair",    -- Crosshair | Distance | Health (all inside the FOV circle)
    TargetInfo    = true,            -- line + name/HP readout for the locked target
    AimbotToggleKey = "None",        -- keyboard key that flips Aimbot on/off
    SilentToggleKey = "None",        -- keyboard key that flips Silent aim on/off
    AutoShoot     = false,           -- fire whenever silent aim has a target
    AimMode       = "Camera",        -- Camera (turns the camera) | Mouse (moves your mouse)
    AimFOV        = 150,             -- pixels from the crosshair
    ShowFOV       = true,
    Smoothness    = 0.5,             -- 0 = snap, higher = slower
    Prediction    = true,            -- lead moving targets by bullet travel time
    WallCheck     = true,
    TargetBots    = true,
    TargetPlayers = true,
    IgnoreProtected = true,          -- skip spawn-protected (ForceField) targets
    TriggerBot    = false,
    TriggerDelay  = 0.05,
    SilentAim     = false,           -- shots go to the target, your camera doesn't move
    SilentHitChance = 100,
    -- visuals
    ESP           = false,
    ESPBoxes      = true,
    BoxStyle      = "Corners",       -- Corners | Full
    ESPNames      = true,
    ESPHealth     = true,
    ESPDistance   = true,
    ESPWeapon     = true,
    ESPStreak     = true,            -- killstreak next to the name
    Skeleton      = false,
    Arrows        = true,            -- arrows at the screen edge for enemies you can't see on screen
    VisibleColors = true,            -- enemies in your line of sight turn green
    ESPMaxDistance = 1500,
    ESPTextSize   = 13,
    Tracers       = false,
    TracerFrom    = "Bottom",        -- Bottom | Center | Mouse
    Chams         = false,
    ChamsFill     = 0.5,
    ESPBots       = true,
    SpawnTag      = true,            -- "[SPAWN]" next to spawn-protected names
    Radar         = false,
    RadarRange    = 250,
    RadarSize     = 180,
    BulletTracers = false,           -- draw where your shots went
    FullBright    = false,
    NoFog         = false,
    -- player
    WalkSpeedOn   = false,
    WalkSpeed     = 30,
    JumpOn        = false,
    JumpPower     = 60,
    Noclip        = false,
    AntiAFK       = true,
    AutoDeploy    = false,
    -- hitbox
    Hitbox        = false,
    HitboxPart    = "Head",          -- Head | Torso
    HitboxSize    = 6,
    HitboxVisible = true,
    -- gun
    NoReload      = false,           -- magazine never empties (also skips the reload wait on one-shot guns)
    RapidFire     = false,
    FireRateMult  = 1.5,
    FullAuto      = false,           -- hold left mouse to keep firing
    InstantSwitch = false,           -- no 0.3 s lock after switching weapons
    -- camera
    FOVChanger    = false,
    FOV           = 90,
    KeepADSZoom   = true,
    ToggleKey     = Enum.KeyCode.RightShift,
}
local SETTINGS_FILE = ("CookiesHubOneTap_%d_settings.json"):format(lp.UserId)
pcall(function()
    for k, v in pairs(HttpService:JSONDecode(readfile(SETTINGS_FILE))) do
        if S[k] ~= nil and type(S[k]) == type(v) then S[k] = v end
    end
end)
local function saveSettings()
    local out = {}
    for k, v in pairs(S) do if type(v) ~= "userdata" then out[k] = v end end
    pcall(function() writefile(SETTINGS_FILE, HttpService:JSONEncode(out)) end)
end

local COLORS = {
    enemy = Color3.fromRGB(255, 80, 80), bot = Color3.fromRGB(255, 165, 60),
    fov = Color3.fromRGB(171, 113, 235), white = Color3.new(1, 1, 1), hpBack = Color3.fromRGB(20, 20, 20),
    visible = Color3.fromRGB(90, 255, 120), outline = Color3.new(0, 0, 0), info = Color3.fromRGB(220, 220, 230),
}
local BULLET_SPEED = (WM.Constants and WM.Constants.DEFAULT_SPEED) or 3850

-- ---------- targets ----------
local function camera() return Workspace.CurrentCamera end
local function myChar() return lp.Character end
local function humanoidOf(m)
    local h = m and m:FindFirstChildOfClass("Humanoid")
    if h and h.Health > 0 then return h end
end
local function iAmDead()
    local ok, dead = pcall(WC.isDead)
    return not ok or dead
end
-- where your bullets start: the game fires from your Head
local function shotOrigin()
    local c = myChar()
    local head = c and c:FindFirstChild("Head")
    return head and head.Position or camera().CFrame.Position
end
local function hitboxFolder(m) return m:FindFirstChild("Hitbox") or m:FindFirstChild("Hitbox_Bots") end
local function currentWeaponName(m)
    local cur = m:GetAttribute("currentWeapon") or m:GetAttribute("currentWeaponServer")
    if cur == "Primary" then return m:GetAttribute("primaryWeapon") end
    if cur == "Secondary" then return m:GetAttribute("secondaryWeapon") end
    if cur == "Knife" then return m:GetAttribute("knifeName") end
end
-- everyone deployed and alive (players + bots)
local function getTargets()
    local list, seen = {}, {}
    local me = myChar()
    local function add(m)
        if seen[m] or m == me or not m:IsA("Model") or not m:IsDescendantOf(Workspace) then return end
        seen[m] = true
        if m:GetAttribute("deployed") == false then return end
        local h, root = humanoidOf(m), m:FindFirstChild("HumanoidRootPart")
        if not (h and root) then return end
        local plr = Players:GetPlayerFromCharacter(m)
        local hb = hitboxFolder(m)
        list[#list + 1] = {
            model = m, hum = h, root = root, bot = plr == nil,
            name = plr and plr.DisplayName or (m.Name .. " [BOT]"),
            headHB = hb and hb:FindFirstChild("Hitbox_Head"), hb = hb,
        }
    end
    for _, m in ipairs(CollectionService:GetTagged("Character")) do add(m) end
    for _, p in ipairs(Players:GetPlayers()) do if p ~= lp and p.Character then add(p.Character) end end
    return list
end
local function isProtected(t) return t.model:FindFirstChildOfClass("ForceField") ~= nil end
local function aimPartOf(t, which)
    local m = t.model
    if which == "Torso" then return m:FindFirstChild("Torso") or m:FindFirstChild("UpperTorso") or t.root end
    if which == "Closest" then   -- the body part nearest the crosshair
        local cam = camera()
        local mouse = UserInputService:GetMouseLocation()
        local best, bd
        for _, n in ipairs({ "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "UpperTorso" }) do
            local p = m:FindFirstChild(n)
            if p then
                local sp, on = cam:WorldToViewportPoint(p.Position)
                local d = on and sp.Z > 0 and (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                if d and (not bd or d < bd) then best, bd = p, d end
            end
        end
        if best then return best end
    end
    if t.headHB and t.headHB.Parent then return t.headHB end   -- the game's head hit part
    return m:FindFirstChild("Head") or t.root
end

-- ---------- wall check ----------
-- Same rules as the game's bullets (WeaponManager.cast): a ray from your Head that ignores only you and the
-- Effects folder, so anything else it meets first - including invisible "Barrier" walls - stops the shot.
local function rayIgnore()
    local list = { myChar(), camera() }
    local fx = Workspace:FindFirstChild("Effects")
    if fx then list[#list + 1] = fx end
    return list
end
local function characterOf(inst)
    local m = inst:FindFirstAncestorWhichIsA("Model")
    while m and not m:FindFirstChildOfClass("Humanoid") do m = m.Parent and m.Parent:FindFirstAncestorWhichIsA("Model") end
    return m
end
-- what a bullet along origin -> origin + dir hits first: returns (RaycastResult, characterModel or nil)
local function castShot(origin, dir)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = rayIgnore()
    local hit = Workspace:Raycast(origin, dir, params)
    if not hit then return nil end
    return hit, characterOf(hit.Instance)
end
-- visible = a shot from your head at the part reaches that character first. Cached for a moment: the aimbot,
-- silent aim, trigger bot and ESP all ask about the same parts every frame.
local visCache = setmetatable({}, { __mode = "k" })
local function visible(part, target)
    local now = os.clock()
    local c = visCache[part]
    if c and now - c.t < 0.03 then return c.v end
    local origin = shotOrigin()
    local dir = part.Position - origin
    local hit, char = castShot(origin, dir * 1.02)
    local v = hit == nil or char == target.model
    visCache[part] = { t = now, v = v }
    return v
end

-- ---------- gun (WeaponClient) ----------
local origFire = WC.fire
local function fireClosure()   -- the game's real fire function (rebuilt by the game each round)
    local ok, f = pcall(debug.getupvalue, origFire, 1)
    if ok and type(f) == "function" then return f end
end
local function bulletsTable()
    local ok, t = pcall(debug.getupvalue, WC.getBullets, 3)
    if ok and type(t) == "table" then return t end
end
local function weaponData(name)
    if not name then return end
    local ok, d = pcall(WM.getWeaponData, name)
    if ok and type(d) == "table" then return d end
end
local function holdingSlot()
    local c = myChar()
    return c and c:GetAttribute("currentWeapon")
end
local function defaultFireRate(d)
    local K = WM.Constants or {}
    return d.isPistol and (K.DEFAULT_PISTOL_FIRERATE or 4) or (K.DEFAULT_FIRERATE or 2)
end
local patchedData = {}   -- [weapon data table] = { firerate = original (may be nil) }
local function patchRate(d)
    if not d then return end
    local o = patchedData[d]
    if not o then o = { firerate = d.firerate } patchedData[d] = o end
    local base = o.firerate or defaultFireRate(d)
    d.firerate = S.RapidFire and base * S.FireRateMult or o.firerate
end
local function restoreGuns()
    for d, o in pairs(patchedData) do d.firerate = o.firerate end
    patchedData = {}
end
local gunConn = RunService.Heartbeat:Connect(function()
    if not (S.NoReload or S.RapidFire or S.InstantSwitch or next(patchedData)) then return end
    pcall(function()
        local c = myChar()
        if not c or iAmDead() then return end
        if S.RapidFire or next(patchedData) then
            patchRate(weaponData(c:GetAttribute("primaryWeapon")))
            patchRate(weaponData(c:GetAttribute("secondaryWeapon")))
            if not S.RapidFire then restoreGuns() end
        end
        if S.NoReload then
            -- keep both magazines full so the game never starts a reload
            local b = bulletsTable()
            if b then
                for slot, attr in pairs({ Primary = "primaryWeapon", Secondary = "secondaryWeapon" }) do
                    local okM, max = pcall(WC.getBulletsForWeapon, c:GetAttribute(attr))
                    if okM and type(max) == "number" and (b[slot] or 0) < max then b[slot] = max end
                end
            end
            if WC.getState() == "reloading" then pcall(WC.cancelReload) end
        end
        if S.InstantSwitch then
            local f = fireClosure()
            local okT, last = pcall(debug.getupvalue, f, 1)
            if okT and type(last) == "number" and last > 0 then debug.setupvalue(f, 1, 0) end
        end
    end)
end)
local function canShoot()
    return not iAmDead() and WC.getState() == "free" and UserInputService:GetFocusedTextBox() == nil
end
-- With No reload a one-bullet gun is "free" again the instant it fires, so automatic fire (trigger bot, auto shoot,
-- full auto) is paced by the gun's own fire rate (x the Rapid fire multiplier) instead of once per frame.
local lastAutoShot = 0
local function autoInterval()
    local c = myChar()
    local d = c and weaponData(currentWeaponName(c)) or {}
    if holdingSlot() == "Knife" then return 0.5 end
    local base = (patchedData[d] and patchedData[d].firerate) or d.firerate or defaultFireRate(d)
    return 1 / (base * (S.RapidFire and S.FireRateMult or 1))
end
local function shoot()   -- fire once through the game's own code (goes through silent aim too)
    if not canShoot() or os.clock() - lastAutoShot < autoInterval() then return end
    lastAutoShot = os.clock()
    task.spawn(WC.fire)
end

-- ---------- hitbox ----------
local HITBOX_PARTS = { Head = { "Hitbox_Head" }, Torso = { "Hitbox_Torso" } }
local resized = {}   -- [part] = { size, transparency }
local function restorePart(p)
    local o = resized[p]
    if o and p.Parent then p.Size, p.Transparency = o.size, o.transparency end
    resized[p] = nil
end
local function updateHitboxes(targets)
    local keep = {}
    if S.Hitbox then
        local n = S.HitboxSize
        for _, t in ipairs(targets) do
            if t.hb and (t.bot and S.TargetBots or not t.bot and S.TargetPlayers) then
                for _, name in ipairs(HITBOX_PARTS[S.HitboxPart] or HITBOX_PARTS.Head) do
                    local p = t.hb:FindFirstChild(name)
                    if p and p:IsA("BasePart") then
                        if not resized[p] then resized[p] = { size = p.Size, transparency = p.Transparency } end
                        keep[p] = true
                        p.Size = Vector3.new(n, n, n)
                        p.Transparency = S.HitboxVisible and 0.7 or resized[p].transparency
                    end
                end
            end
        end
    end
    for p in pairs(resized) do if not keep[p] then restorePart(p) end end
end

-- ---------- ESP (Drawing) + chams (Highlight) ----------
local hasDrawing = typeof(Drawing) == "table" and Drawing.new ~= nil
local chamFolder = Instance.new("Folder")
chamFolder.Name = "CookiesHubOneTapChams"
pcall(function() chamFolder.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not chamFolder.Parent then chamFolder.Parent = lp:WaitForChild("PlayerGui") end

local function newDraw(kind, props)
    local d = Drawing.new(kind)
    for k, v in pairs(props) do d[k] = v end
    return d
end
-- skeleton lines as world-point pairs (R6, with an R15 fallback)
local R15_BONES = {
    { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}
local MAX_BONES = #R15_BONES
local function bonePairs(m)
    local out = {}
    local torso = m:FindFirstChild("Torso")
    if torso then
        local T = torso.CFrame
        local neck, pelvis = (T * CFrame.new(0, 1, 0)).Position, (T * CFrame.new(0, -1, 0)).Position
        local head = m:FindFirstChild("Head")
        if head then out[#out + 1] = { head.Position, neck } end
        out[#out + 1] = { neck, pelvis }
        for _, side in ipairs({ { "Left Arm", -1 }, { "Right Arm", 1 } }) do
            local arm = m:FindFirstChild(side[1])
            if arm then
                local shoulder = (T * CFrame.new(side[2] * 1, 0.9, 0)).Position
                out[#out + 1] = { neck, shoulder }
                out[#out + 1] = { shoulder, (arm.CFrame * CFrame.new(0, -1, 0)).Position }
            end
        end
        for _, side in ipairs({ { "Left Leg", -0.5 }, { "Right Leg", 0.5 } }) do
            local leg = m:FindFirstChild(side[1])
            if leg then
                local hip = (T * CFrame.new(side[2], -1, 0)).Position
                out[#out + 1] = { pelvis, hip }
                out[#out + 1] = { hip, (leg.CFrame * CFrame.new(0, -1, 0)).Position }
            end
        end
        return out
    end
    for _, b in ipairs(R15_BONES) do
        local a, c = m:FindFirstChild(b[1]), m:FindFirstChild(b[2])
        if a and c then out[#out + 1] = { a.Position, c.Position } end
    end
    return out
end
local esp = {}   -- [model] = { d = {all drawings}, box/boxOut, corners/cornersOut, name, info, hpOut, hp, hpText, tracer/tracerOut, bones, arrow, cham, vis, visAt }
local function dropEsp(m)
    local e = esp[m]
    if not e then return end
    for _, d in ipairs(e.d) do pcall(function() d:Remove() end) end
    if e.cham then e.cham:Destroy() end
    esp[m] = nil
end
local function getEsp(m)
    local e = esp[m]
    if e then return e end
    e = { d = {}, corners = {}, cornersOut = {}, bones = {} }
    if hasDrawing then
        local function add(kind, props)
            props.Visible = false
            local d = newDraw(kind, props)
            e.d[#e.d + 1] = d
            return d
        end
        -- outlines first so they draw underneath
        e.tracerOut = add("Line", { Thickness = 3, Color = COLORS.outline, Transparency = 0.6 })
        e.tracer = add("Line", { Thickness = 1.2 })
        e.boxOut = add("Square", { Thickness = 3.5, Filled = false, Color = COLORS.outline })
        e.box = add("Square", { Thickness = 1.5, Filled = false })
        for i = 1, 8 do e.cornersOut[i] = add("Line", { Thickness = 3.5, Color = COLORS.outline }) end
        for i = 1, 8 do e.corners[i] = add("Line", { Thickness = 1.5 }) end
        for i = 1, MAX_BONES do e.bones[i] = add("Line", { Thickness = 1.3 }) end
        e.hpOut = add("Square", { Filled = true, Color = COLORS.hpBack })
        e.hp = add("Square", { Filled = true })
        e.hpText = add("Text", { Center = false, Outline = true, Font = 2, Color = COLORS.white })
        e.name = add("Text", { Center = true, Outline = true, Font = 2 })
        e.info = add("Text", { Center = true, Outline = true, Font = 2, Color = COLORS.info })
        e.arrow = add("Triangle", { Filled = true, Thickness = 1 })
    end
    esp[m] = e
    return e
end
local function hideEsp(e)
    for _, d in ipairs(e.d) do d.Visible = false end
    if e.cham then e.cham.Enabled = false end
end
local function setLine(l, a, b, color)
    l.From = a l.To = b l.Visible = true
    if color then l.Color = color end
end
local fovCircle = hasDrawing and newDraw("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Color = COLORS.fov, Visible = false }) or nil
local targetLine = hasDrawing and newDraw("Line", { Thickness = 1.5, Color = COLORS.fov, Visible = false }) or nil
local targetText = hasDrawing and newDraw("Text", { Size = 16, Center = true, Outline = true, Font = 2, Color = COLORS.white, Visible = false }) or nil

local function drawEsp(e, t, color, dist, cam, vp, mouse)
    local d = e.d
    for i = 1, #d do d[i].Visible = false end
    if not S.ESP and not S.Tracers then return end
    local head = t.model:FindFirstChild("Head")
    -- box from head top to feet, width from the character's real width as seen from the camera
    local topW = (head and head.Position or t.root.Position + Vector3.new(0, 1.5, 0)) + Vector3.new(0, 0.75, 0)
    local footY = t.root.Position.Y - 3
    local ll, rl = t.model:FindFirstChild("Left Leg"), t.model:FindFirstChild("Right Leg")
    if ll and rl then footY = math.min(ll.Position.Y - ll.Size.Y / 2, rl.Position.Y - rl.Size.Y / 2) - 0.1 end
    local botW = Vector3.new(t.root.Position.X, footY, t.root.Position.Z)
    local top, onT = cam:WorldToViewportPoint(topW)
    local bot, onB = cam:WorldToViewportPoint(botW)
    local onScreen = top.Z > 0 and bot.Z > 0 and (onT or onB)

    if not onScreen then
        -- arrow at the screen edge pointing at them
        if S.ESP and S.Arrows then
            local p = cam:WorldToViewportPoint(t.root.Position)
            local centre = vp / 2
            local dir = Vector2.new(p.X, p.Y) - centre
            if p.Z < 0 then dir = -dir end
            if dir.Magnitude > 1 then
                dir = dir.Unit
                local perp = Vector2.new(-dir.Y, dir.X)
                local tip = centre + dir * (math.min(vp.X, vp.Y) * 0.42)
                e.arrow.PointA = tip
                e.arrow.PointB = tip - dir * 16 + perp * 9
                e.arrow.PointC = tip - dir * 16 - perp * 9
                e.arrow.Color = color e.arrow.Visible = true
            end
        end
        return
    end

    local side = cam:WorldToViewportPoint(t.root.Position + cam.CFrame.RightVector * 1.7)
    local mid = cam:WorldToViewportPoint(t.root.Position)
    local h = math.max(bot.Y - top.Y, 6)
    local w = math.max(math.abs(side.X - mid.X) * 2, h * 0.35)
    local x, y = mid.X - w / 2, top.Y
    local size = S.ESPTextSize

    if S.ESP and S.ESPBoxes then
        if S.BoxStyle == "Full" then
            e.boxOut.Position = Vector2.new(x, y) e.boxOut.Size = Vector2.new(w, h) e.boxOut.Visible = true
            e.box.Position = Vector2.new(x, y) e.box.Size = Vector2.new(w, h) e.box.Color = color e.box.Visible = true
        else
            local cw, ch = w / 4, h / 5
            local pts = {
                { Vector2.new(x, y), Vector2.new(x + cw, y) }, { Vector2.new(x, y), Vector2.new(x, y + ch) },
                { Vector2.new(x + w, y), Vector2.new(x + w - cw, y) }, { Vector2.new(x + w, y), Vector2.new(x + w, y + ch) },
                { Vector2.new(x, y + h), Vector2.new(x + cw, y + h) }, { Vector2.new(x, y + h), Vector2.new(x, y + h - ch) },
                { Vector2.new(x + w, y + h), Vector2.new(x + w - cw, y + h) }, { Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - ch) },
            }
            for i, p in ipairs(pts) do
                setLine(e.cornersOut[i], p[1], p[2])
                setLine(e.corners[i], p[1], p[2], color)
            end
        end
    end
    if S.ESP and S.Skeleton then
        for i, b in ipairs(bonePairs(t.model)) do
            if i > MAX_BONES then break end
            local pa, oa = cam:WorldToViewportPoint(b[1])
            local pc, oc = cam:WorldToViewportPoint(b[2])
            if oa and oc then setLine(e.bones[i], Vector2.new(pa.X, pa.Y), Vector2.new(pc.X, pc.Y), color) end
        end
    end
    if S.ESP and S.ESPHealth then
        local frac = math.clamp(t.hum.Health / math.max(t.hum.MaxHealth, 1), 0, 1)
        local hpColor = Color3.fromHSV(frac * 0.33, 0.85, 1)
        e.hpOut.Position = Vector2.new(x - 7, y - 1) e.hpOut.Size = Vector2.new(4, h + 2) e.hpOut.Visible = true
        e.hp.Position = Vector2.new(x - 6, y + h * (1 - frac)) e.hp.Size = Vector2.new(2, h * frac) e.hp.Color = hpColor e.hp.Visible = true
        if frac < 0.99 then
            e.hpText.Text = tostring(math.floor(t.hum.Health + 0.5)) e.hpText.Size = size - 1
            e.hpText.Position = Vector2.new(x - 9 - e.hpText.TextBounds.X, y + h * (1 - frac) - (size - 1) / 2)
            e.hpText.Visible = true
        end
    end
    if S.ESP and S.ESPNames then
        local streak = S.ESPStreak and tonumber(t.model:GetAttribute("killstreak"))
        e.name.Text = t.name .. (streak and streak >= 2 and ("  x" .. streak) or "") .. (S.SpawnTag and isProtected(t) and "  [SPAWN]" or "")
        e.name.Size = size e.name.Color = color
        e.name.Position = Vector2.new(mid.X, y - size - 3) e.name.Visible = true
    end
    if S.ESP and (S.ESPDistance or S.ESPWeapon) then
        local parts = {}
        if S.ESPDistance then parts[#parts + 1] = dist .. "m" end
        local weapon = S.ESPWeapon and currentWeaponName(t.model)
        if weapon then parts[#parts + 1] = weapon end
        if #parts > 0 then
            e.info.Text = table.concat(parts, "  ") e.info.Size = size - 1
            e.info.Position = Vector2.new(mid.X, y + h + 2) e.info.Visible = true
        end
    end
    if S.Tracers then
        local from = S.TracerFrom == "Center" and vp / 2 or S.TracerFrom == "Mouse" and mouse or Vector2.new(vp.X / 2, vp.Y)
        local to = Vector2.new(mid.X, y + h)
        setLine(e.tracerOut, from, to)
        setLine(e.tracer, from, to, color)
    end
end

local function updateEsp(targets)
    local cam = camera()
    local vp = cam.ViewportSize
    local mouse = UserInputService:GetMouseLocation()
    local me = myChar() and myChar():FindFirstChild("HumanoidRootPart")
    local myPos = me and me.Position or cam.CFrame.Position
    local now = os.clock()
    local seen = {}
    for _, t in ipairs(targets) do
        local dist = math.floor((t.root.Position - myPos).Magnitude)
        local show = (S.ESP or S.Chams or S.Tracers) and (S.ESPBots or not t.bot) and dist <= S.ESPMaxDistance
        if show then
            seen[t.model] = true
            local e = getEsp(t.model)
            -- line of sight, re-checked 10x a second per target
            if S.VisibleColors and now - (e.visAt or 0) > 0.1 then
                e.visAt = now
                e.vis = visible(aimPartOf(t, "Head"), t) or visible(t.root, t)
            end
            local color = (S.VisibleColors and e.vis and COLORS.visible) or (t.bot and COLORS.bot or COLORS.enemy)
            if S.Chams then
                if not e.cham then
                    local hl = Instance.new("Highlight")
                    hl.OutlineTransparency = 0 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = t.model hl.Parent = chamFolder
                    e.cham = hl
                end
                e.cham.FillTransparency = S.ChamsFill
                e.cham.Enabled = true e.cham.FillColor = color e.cham.OutlineColor = color
            elseif e.cham then
                e.cham.Enabled = false
            end
            if hasDrawing then drawEsp(e, t, color, dist, cam, vp, mouse) end
        end
    end
    for m, e in pairs(esp) do
        if not seen[m] then
            if not m.Parent then dropEsp(m) else hideEsp(e) end
        end
    end
end

-- ---------- aimbot + trigger bot + FOV changer ----------
local function aimHeld()
    if S.AimKey == "Always" then return true end
    local btn = S.AimKey == "Left mouse" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2
    return UserInputService:IsMouseButtonPressed(btn)
end
local function canTarget(t)
    return (t.bot and S.TargetBots or not t.bot and S.TargetPlayers) and not (S.IgnoreProtected and isProtected(t))
end
-- the part to aim at: the chosen aim part, or with wall check on, the first other body part that's in the open
-- (head behind cover but legs showing -> legs)
local FALLBACK_PARTS = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function visiblePart(t)
    local first = aimPartOf(t, S.AimPart)
    if not S.WallCheck or visible(first, t) then return first end
    for _, n in ipairs(FALLBACK_PARTS) do
        local p = t.model:FindFirstChild(n)
        if p and p ~= first and visible(p, t) then return p end
    end
end
-- inside the FOV circle, the best enemy by the chosen priority (crosshair distance breaks ties)
local function bestTarget(targets)
    local cam = camera()
    local mouse = UserInputService:GetMouseLocation()
    local camPos = cam.CFrame.Position
    local best, bestPart, bestScore, bestD
    for _, t in ipairs(targets) do
        if canTarget(t) and t.model.Parent and t.hum.Health > 0 then
            -- FOV test on the root first (cheap), wall checks only for enemies near the crosshair
            local rp, ron = cam:WorldToViewportPoint(t.root.Position)
            if ron and rp.Z > 0 and (Vector2.new(rp.X, rp.Y) - mouse).Magnitude <= S.AimFOV + 80 then
                local part = visiblePart(t)
                local pos, on
                if part then pos, on = cam:WorldToViewportPoint(part.Position) end
                if part and on and pos.Z > 0 then
                    local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if d <= S.AimFOV then
                        local score = S.TargetPriority == "Distance" and (part.Position - camPos).Magnitude
                            or S.TargetPriority == "Health" and t.hum.Health or d
                        if not bestScore or score < bestScore or (score == bestScore and d < bestD) then
                            best, bestPart, bestScore, bestD = t, part, score, d
                        end
                    end
                end
            end
        end
    end
    return best, bestPart
end
-- where to aim: lead by bullet travel time (bullets have no drop in this game)
local function aimPoint(t, part)
    local pos = part.Position
    if S.Prediction then
        local travel = (pos - shotOrigin()).Magnitude / BULLET_SPEED
        pos = pos + t.root.AssemblyLinearVelocity * travel
    end
    return pos
end

local targetsNow = {}
local savedFOV

-- Mouse aiming works in angles: we measure how far the view really turned per pixel we sent last frame
-- (separately for yaw and pitch) and send just enough to close the gap, so sensitivity / scope don't matter.
local aim = { gainX = 0.02, gainY = 0.02, lastCmd = nil, lastYaw = nil, lastPitch = nil, locked = nil }
local function yawPitch(look) return math.atan2(-look.X, -look.Z), math.asin(math.clamp(look.Y, -1, 1)) end
local function wrapAngle(a) return (a + math.pi) % (2 * math.pi) - math.pi end
local function learnGain(old, observed, sent)
    if math.abs(sent) < 3 or math.abs(observed) < 1e-4 then return old end
    local sample = math.clamp(math.abs(observed / sent), 2e-4, 0.05)
    return old * 0.7 + sample * 0.3
end
local function aimWithMouse(cam, pos, f)
    local yaw, pitch = yawPitch(cam.CFrame.LookVector)
    if aim.lastCmd and aim.lastYaw then
        aim.gainX = learnGain(aim.gainX, wrapAngle(yaw - aim.lastYaw), aim.lastCmd.X)
        aim.gainY = learnGain(aim.gainY, pitch - aim.lastPitch, aim.lastCmd.Y)
    end
    local wantYaw, wantPitch = yawPitch((pos - cam.CFrame.Position).Unit)
    local errYaw, errPitch = wrapAngle(wantYaw - yaw), wantPitch - pitch
    -- mouse right = yaw goes down (turn right), mouse down = pitch goes down
    local dx = math.clamp(-errYaw / aim.gainX * f, -250, 250)
    local dy = math.clamp(-errPitch / aim.gainY * f, -250, 250)
    aim.lastYaw, aim.lastPitch = yaw, pitch
    if math.abs(dx) < 0.5 and math.abs(dy) < 0.5 then aim.lastCmd = nil return end
    mousemoverel(dx, dy)
    aim.lastCmd = Vector2.new(dx, dy)
end
-- stay on the same enemy while it's still valid instead of hopping between two nearby ones
local function stickyTarget()
    local t = aim.locked
    if t and t.model.Parent and humanoidOf(t.model) and canTarget(t) then
        local part = visiblePart(t)   -- nil = fully behind a wall: let go
        if part then
            local sp, on = camera():WorldToViewportPoint(part.Position)
            if on and sp.Z > 0 and (Vector2.new(sp.X, sp.Y) - UserInputService:GetMouseLocation()).Magnitude <= S.AimFOV * 1.5 then
                return t, part
            end
        end
    end
    local nt, np = bestTarget(targetsNow)
    aim.locked = nt
    return nt, np
end

-- ---------- silent aim + bullet tracers ----------
-- WeaponClient.fire reads Camera.CFrame.LookVector, casts the bullet (WeaponManager.cast) and reports that same
-- direction, then yields for the fire-rate wait. So for one shot we point the camera at the target, run the
-- game's fire up to its first yield, and put the camera straight back - before anything is drawn. While that
-- runs, cast also ignores the camera, or the redirected bullet would hit your own viewmodel.
local silentPos      -- aim point picked every frame
local inShot = false
local tracerFolder = Instance.new("Folder")
tracerFolder.Name = "CookiesHubOneTapTracers"
tracerFolder.Parent = Workspace
local function drawShotTracer(origin, dir)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = rayIgnore()
    ignore[#ignore + 1] = tracerFolder
    params.FilterDescendantsInstances = ignore
    local hit = Workspace:Raycast(origin, dir.Unit * 1500, params)
    local finish = hit and hit.Position or origin + dir.Unit * 1500
    local len = (finish - origin).Magnitude
    local p = Instance.new("Part")
    p.Anchored = true p.CanCollide = false p.CanQuery = false p.CanTouch = false p.CastShadow = false
    p.Material = Enum.Material.Neon p.Color = COLORS.fov p.Transparency = 0.2
    p.Size = Vector3.new(0.08, 0.08, len)
    p.CFrame = CFrame.lookAt(origin, finish) * CFrame.new(0, 0, -len / 2)
    p.Parent = tracerFolder
    task.spawn(function()
        for i = 1, 10 do
            task.wait(0.06)
            if not p.Parent then return end
            p.Transparency = 0.2 + i * 0.08
        end
        p:Destroy()
    end)
end
local origCast = WM.cast
WM.cast = function(origin, dir, speed, maxDist, ignore, callbacks, ...)
    if alive and inShot then
        if type(ignore) == "table" then ignore[#ignore + 1] = camera() end
        -- the main cast has hit callbacks; the second one is only the cosmetic bullet from the gun barrel
        if S.BulletTracers and type(callbacks) == "table" and callbacks.onHitWall
           and typeof(origin) == "Vector3" and typeof(dir) == "Vector3" then
            pcall(drawShotTracer, origin, dir)
        end
    end
    return origCast(origin, dir, speed, maxDist, ignore, callbacks, ...)
end
WC.fire = function(...)
    if not alive then return origFire(...) end
    local pos = S.SilentAim and silentPos and math.random(1, 100) <= S.SilentHitChance and silentPos
    local cam = camera()
    local saved = cam.CFrame
    inShot = true
    if pos then cam.CFrame = CFrame.lookAt(saved.Position, pos) end
    local ok, err = pcall(task.spawn, origFire, ...)   -- runs until the game's fire-rate wait, then comes back
    if pos then cam.CFrame = saved end
    inShot = false
    if not ok then warn("[CookiesHub OneTap] fire: " .. tostring(err)) end
end

-- ---------- trigger bot / auto shoot / full auto ----------
local triggerSince = nil
local function stepTrigger(lookup)
    local autoShoot = S.AutoShoot and S.SilentAim and silentPos ~= nil
    if not (S.TriggerBot or autoShoot) or not (isrbxactive == nil or isrbxactive()) then triggerSince = nil return end
    local onTarget = autoShoot
    if not onTarget then
        -- what a bullet fired right now would hit first (from your head along the crosshair)
        local hit, char = castShot(shotOrigin(), camera().CFrame.LookVector * 1500)
        local t = hit and char and lookup[char]
        onTarget = t ~= nil and canTarget(t)
    end
    if not onTarget then triggerSince = nil return end
    triggerSince = triggerSince or os.clock()
    if os.clock() - triggerSince < S.TriggerDelay then return end
    shoot()
end

RunService:BindToRenderStep("CookiesHubOneTap", Enum.RenderPriority.Camera.Value + 1, function()
    if not alive then return end
    local cam = camera()
    -- FOV changer (leaves the scope zoom alone while aiming down sights)
    if S.FOVChanger then
        savedFOV = savedFOV or cam.FieldOfView
        if not (S.KeepADSZoom and WC.isScoping()) then cam.FieldOfView = S.FOV end
    elseif savedFOV then
        cam.FieldOfView = savedFOV savedFOV = nil
    end
    -- FOV circle
    if fovCircle then
        fovCircle.Visible = (S.Aimbot or S.SilentAim) and S.ShowFOV
        fovCircle.Position = UserInputService:GetMouseLocation() fovCircle.Radius = S.AimFOV
    end
    -- aimbot: runs right after the game's camera, so the turn sticks (the game's own aim assist does the same)
    local meAlive = myChar() and humanoidOf(myChar()) and not iAmDead()
    if S.Aimbot and aimHeld() and meAlive then
        local f = 1 - math.clamp(S.Smoothness, 0, 0.95)
        local t, part = stickyTarget()
        if t then
            if S.AimMode == "Mouse" and mousemoverel then
                aimWithMouse(cam, aimPoint(t, part), f)
            else
                cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, aimPoint(t, part)), f)
            end
        else
            aim.lastCmd = nil
        end
    else
        aim.locked, aim.lastCmd = nil, nil
    end
    -- silent aim target
    silentPos = nil
    local silentT
    if S.SilentAim and meAlive then
        local t, part = bestTarget(targetsNow)
        if t then silentPos, silentT = aimPoint(t, part), t end
    end
    -- locked-target readout: a line to them and their name / HP / distance at the top of the screen
    if targetLine then
        local t = (S.Aimbot and aimHeld() and aim.locked) or silentT
        local show = S.TargetInfo and t and t.model.Parent and humanoidOf(t.model)
        targetLine.Visible, targetText.Visible = false, false
        if show then
            local sp, on = cam:WorldToViewportPoint(aimPartOf(t, S.AimPart).Position)
            if on and sp.Z > 0 then
                targetLine.From = cam.ViewportSize / 2 targetLine.To = Vector2.new(sp.X, sp.Y) targetLine.Visible = true
            end
            local me = myChar() and myChar():FindFirstChild("HumanoidRootPart")
            targetText.Text = ("TARGET  %s   %d HP   %dm"):format(t.name, math.floor(t.hum.Health + 0.5),
                me and math.floor((t.root.Position - me.Position).Magnitude) or 0)
            targetText.Position = Vector2.new(cam.ViewportSize.X / 2, 70) targetText.Visible = true
        end
    end
    if not meAlive then triggerSince = nil return end
    -- full auto: keep firing while left mouse is held (the game itself only fires on the click)
    if S.FullAuto and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then shoot() end
    -- trigger bot / auto shoot
    local lookup = {}
    for _, t in ipairs(targetsNow) do lookup[t.model] = t end
    pcall(stepTrigger, lookup)
end)

-- ---------- radar ----------
-- top-right minimap, rotated so up = where you're looking; enemies at the edge are beyond the range
local radar = {}
if hasDrawing then
    radar.bg = newDraw("Square", { Filled = true, Color = Color3.fromRGB(20, 16, 30), Transparency = 0.65, Visible = false })
    radar.border = newDraw("Square", { Filled = false, Thickness = 1.5, Color = COLORS.fov, Visible = false })
    radar.crossH = newDraw("Line", { Thickness = 1, Color = Color3.fromRGB(90, 80, 110), Visible = false })
    radar.crossV = newDraw("Line", { Thickness = 1, Color = Color3.fromRGB(90, 80, 110), Visible = false })
    radar.me = newDraw("Triangle", { Filled = true, Color = COLORS.white, Visible = false })
    radar.dots = {}
end
local function hideRadar()
    for k, d in pairs(radar) do if k ~= "dots" then d.Visible = false end end
    for _, d in ipairs(radar.dots or {}) do d.Visible = false end
end
local function updateRadar(targets)
    if not hasDrawing then return end
    if not S.Radar then hideRadar() return end
    local cam = camera()
    local size = S.RadarSize
    local half = size / 2
    local pos = Vector2.new(cam.ViewportSize.X - size - 20, 60)
    local centre = pos + Vector2.new(half, half)
    radar.bg.Position = pos radar.bg.Size = Vector2.new(size, size) radar.bg.Visible = true
    radar.border.Position = pos radar.border.Size = Vector2.new(size, size) radar.border.Visible = true
    radar.crossH.From = Vector2.new(pos.X, centre.Y) radar.crossH.To = Vector2.new(pos.X + size, centre.Y) radar.crossH.Visible = true
    radar.crossV.From = Vector2.new(centre.X, pos.Y) radar.crossV.To = Vector2.new(centre.X, pos.Y + size) radar.crossV.Visible = true
    radar.me.PointA = centre + Vector2.new(0, -7) radar.me.PointB = centre + Vector2.new(-5, 5) radar.me.PointC = centre + Vector2.new(5, 5)
    radar.me.Visible = true
    local look = cam.CFrame.LookVector
    local fwd = Vector3.new(look.X, 0, look.Z)
    fwd = fwd.Magnitude > 0 and fwd.Unit or Vector3.new(0, 0, -1)
    local right = Vector3.new(-fwd.Z, 0, fwd.X)
    local me = myChar() and myChar():FindFirstChild("HumanoidRootPart")
    local origin = me and me.Position or cam.CFrame.Position
    local n = 0
    for _, t in ipairs(targets) do
        if S.ESPBots or not t.bot then
            n = n + 1
            local dot = radar.dots[n]
            if not dot then
                dot = newDraw("Circle", { Filled = true, Radius = 3.5, NumSides = 12, Visible = false })
                radar.dots[n] = dot
            end
            local rel = t.root.Position - origin
            local v = Vector2.new(rel:Dot(right), -rel:Dot(fwd)) / S.RadarRange * (half - 6)
            if v.Magnitude > half - 6 then v = v.Unit * (half - 6) end
            dot.Position = centre + v
            dot.Color = t.bot and COLORS.bot or COLORS.enemy
            dot.Visible = true
        end
    end
    for i = n + 1, #radar.dots do radar.dots[i].Visible = false end
end

-- ---------- full bright / no fog ----------
local Lighting = game:GetService("Lighting")
local LIGHT_PROPS = { "Brightness", "ClockTime", "GlobalShadows", "Ambient", "OutdoorAmbient", "FogEnd", "FogStart" }
local savedLight, savedAtmo
local function applyLighting()
    local want = S.FullBright or S.NoFog
    if want and not savedLight then
        savedLight = {}
        for _, p in ipairs(LIGHT_PROPS) do savedLight[p] = Lighting[p] end
        local a = Lighting:FindFirstChildOfClass("Atmosphere")
        savedAtmo = a and { inst = a, density = a.Density, haze = a.Haze }
    end
    if S.FullBright then
        Lighting.Brightness = 2.5 Lighting.ClockTime = 14 Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(170, 170, 170) Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
    elseif savedLight then
        for _, p in ipairs({ "Brightness", "ClockTime", "GlobalShadows", "Ambient", "OutdoorAmbient" }) do Lighting[p] = savedLight[p] end
    end
    local a = Lighting:FindFirstChildOfClass("Atmosphere")
    if S.NoFog then
        Lighting.FogStart = 1e5 Lighting.FogEnd = 1e5
        if a then a.Density = 0 a.Haze = 0 end
    elseif savedLight then
        Lighting.FogStart, Lighting.FogEnd = savedLight.FogStart, savedLight.FogEnd
        if savedAtmo and savedAtmo.inst.Parent then savedAtmo.inst.Density = savedAtmo.density savedAtmo.inst.Haze = savedAtmo.haze end
    end
    if not want then savedLight, savedAtmo = nil, nil end
end

-- ---------- player: walk speed, jump, noclip, anti-AFK, auto deploy ----------
local savedMove        -- the game's own WalkSpeed / jump values from before we changed them
local noclipParts = {} -- [part] = true for parts we turned CanCollide off on
local function setJump(h, power)
    if h.UseJumpPower then h.JumpPower = power else h.JumpHeight = power * power / (2 * Workspace.Gravity) end
end
local moveConn = RunService.Heartbeat:Connect(function()
    local c = myChar()
    local h = c and humanoidOf(c)
    if not h then return end
    if (S.WalkSpeedOn or S.JumpOn) and not savedMove then
        savedMove = { walk = h.WalkSpeed, jumpPower = h.JumpPower, jumpHeight = h.JumpHeight, hum = h }
    end
    -- the game resets WalkSpeed whenever you switch weapons (22 / 24 / 26), so this is re-applied every frame
    if S.WalkSpeedOn then h.WalkSpeed = S.WalkSpeed end
    if S.JumpOn then setJump(h, S.JumpPower) end
    if savedMove and savedMove.hum == h then
        if not S.WalkSpeedOn and savedMove.walk then h.WalkSpeed = savedMove.walk savedMove.walk = nil end
        if not S.JumpOn and savedMove.jumpPower then h.JumpPower = savedMove.jumpPower h.JumpHeight = savedMove.jumpHeight savedMove.jumpPower = nil end
        if not S.WalkSpeedOn and not S.JumpOn then savedMove = nil end
    elseif savedMove then
        savedMove = nil   -- respawned: the new humanoid starts with the game's values
    end
end)
local function restoreNoclip()
    for p in pairs(noclipParts) do if p.Parent then p.CanCollide = true end end
    noclipParts = {}
end
local noclipConn = RunService.Stepped:Connect(function()
    if not S.Noclip then
        if next(noclipParts) then restoreNoclip() end
        return
    end
    local c = myChar()
    for _, p in ipairs(c and c:GetDescendants() or {}) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false noclipParts[p] = true end
    end
end)
local VirtualUser = game:GetService("VirtualUser")
local idleConn = lp.Idled:Connect(function()
    if S.AntiAFK then pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end) end
end)
-- Players.RespawnTime is huge here: after dying you stay on the death screen until you ask to respawn (the game
-- does it when you press jump). So: dead -> the death screen's own respawn request; in the lobby -> DeployClient.deploy.
local okDS, DS = pcall(require, startFolder.Game:WaitForChild("Interface"):WaitForChild("DeathScreenInterface"))
if not (okDS and type(DS) == "table" and type(DS._requestRespawn) == "function") then DS = nil end
task.spawn(function()
    local diedAt
    while alive do
        task.wait(0.5)
        if S.AutoDeploy then
            pcall(function()
                local c = myChar()
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not (c and h) or Workspace:GetAttribute("gameState") ~= "game" then diedAt = nil return end
                if h.Health <= 0 then
                    diedAt = diedAt or os.clock()
                    if DS and os.clock() - diedAt > 1.5 then
                        DS._requestRespawn(c:GetAttribute("deployed") == true)
                        diedAt = os.clock() + 3   -- give the server a moment before asking again
                    end
                else
                    diedAt = nil
                    if not c:GetAttribute("deployed") and DC and type(DC.deploy) == "function" then DC.deploy() end
                end
            end)
        end
    end
end)

-- targets / hitboxes refresh
task.spawn(function()
    while alive do
        local ok, list = pcall(getTargets)
        if ok then targetsNow = list end
        pcall(updateHitboxes, targetsNow)
        task.wait(0.1)
    end
end)
task.spawn(function()
    while alive do
        if S.FullBright or S.NoFog or savedLight then pcall(applyLighting) end
        task.wait(1)   -- the game can re-apply its map lighting, so keep it set
    end
end)
local espConn = RunService.RenderStepped:Connect(function()
    if alive then
        pcall(updateEsp, targetsNow)
        pcall(updateRadar, targetsNow)
    end
end)

-- ======================================================================
-- UI  (purple Cookies Hub theme, tabs like the other hubs)
-- ======================================================================
local C = {
    bg=Color3.fromRGB(20,16,30), panel=Color3.fromRGB(30,24,44), row=Color3.fromRGB(42,34,60),
    accent=Color3.fromRGB(171,113,235), accent2=Color3.fromRGB(139,92,214), danger=Color3.fromRGB(226,90,90),
    good=Color3.fromRGB(80,220,120), text=Color3.fromRGB(236,232,245), text2=Color3.fromRGB(165,158,185),
}
local W, H = 470, 480
local function corner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 8) c.Parent = p return c end

local gui = Instance.new("ScreenGui")
gui.Name = "CookiesHubOneTap" gui.ResetOnSpawn = false gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true gui.DisplayOrder = 9999
pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(W, H) main.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
main.BackgroundColor3 = C.bg main.BorderSizePixel = 0 main.Active = true main.Parent = gui corner(main, 12)
local bar = Instance.new("Frame") bar.Size = UDim2.new(1, 0, 0, 40) bar.BackgroundColor3 = C.panel
bar.BorderSizePixel = 0 bar.Parent = main corner(bar, 12)
do
    local title = Instance.new("TextLabel") title.BackgroundTransparency = 1 title.Position = UDim2.fromOffset(14, 0)
    title.Size = UDim2.new(1, -90, 1, 0) title.Font = Enum.Font.GothamBold title.TextSize = 15 title.TextColor3 = C.text
    title.TextXAlignment = Enum.TextXAlignment.Left title.Text = "Cookies Hub  -  [FPS] One Tap" title.Parent = bar
end
local function topBtn(t, x, col)
    local b = Instance.new("TextButton") b.Size = UDim2.fromOffset(24, 24) b.Position = UDim2.new(1, x, 0.5, -12)
    b.BackgroundColor3 = col b.Text = t b.Font = Enum.Font.GothamBold b.TextSize = 14 b.TextColor3 = C.text
    b.BorderSizePixel = 0 b.Parent = bar corner(b, 6) return b
end
local minBtn = topBtn("-", -62, C.row)
local closeBtn = topBtn("X", -32, C.danger)

local tabRow = Instance.new("Frame") tabRow.Size = UDim2.new(1, -20, 0, 28) tabRow.Position = UDim2.fromOffset(10, 48)
tabRow.BackgroundTransparency = 1 tabRow.Parent = main
do
    local tl = Instance.new("UIListLayout") tl.FillDirection = Enum.FillDirection.Horizontal tl.Padding = UDim.new(0, 5) tl.Parent = tabRow
end
local body = Instance.new("Frame") body.Size = UDim2.new(1, -20, 1, -92) body.Position = UDim2.fromOffset(10, 84)
body.BackgroundTransparency = 1 body.Parent = main

local ui = { tabs = {}, tabBtns = {}, renders = {}, conns = {} }   -- conns: UserInputService hooks, cut on Unload
local TAB_NAMES = { "Aim", "Visuals", "Hitbox", "Gun", "Player", "Camera", "Info" }
function ui.select(n)
    for k, p in pairs(ui.tabs) do p.Visible = k == n end
    for k, b in pairs(ui.tabBtns) do b.BackgroundColor3 = k == n and C.accent or C.row b.TextColor3 = k == n and C.bg or C.text2 end
end
function ui.tab(n)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1 / #TAB_NAMES, -5, 1, 0) b.BackgroundColor3 = C.row b.Text = n
    b.Font = Enum.Font.GothamMedium b.TextSize = 12 b.TextColor3 = C.text2 b.BorderSizePixel = 0 b.Parent = tabRow corner(b, 6)
    local p = Instance.new("ScrollingFrame") p.Size = UDim2.fromScale(1, 1) p.BackgroundTransparency = 1 p.BorderSizePixel = 0
    p.ScrollBarThickness = 3 p.CanvasSize = UDim2.new() p.AutomaticCanvasSize = Enum.AutomaticSize.Y p.Visible = false p.Parent = body
    local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, 7) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p
    ui.tabs[n] = p ui.tabBtns[n] = b b.MouseButton1Click:Connect(function() ui.select(n) end)
    return p
end
function ui.sec(parent, t)
    local l = Instance.new("TextLabel") l.Size = UDim2.new(1, 0, 0, 18) l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold l.TextSize = 12 l.TextColor3 = C.accent l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = string.upper(t) l.Parent = parent return l
end
function ui.note(parent, t)
    local l = Instance.new("TextLabel") l.Size = UDim2.new(1, 0, 0, 16) l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1 l.Font = Enum.Font.Gotham l.TextSize = 12 l.TextColor3 = C.text2 l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left l.Text = t l.Parent = parent return l
end
function ui.toggle(parent, label, key, onChange)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 34) row.BackgroundColor3 = C.row row.BorderSizePixel = 0 row.Parent = parent corner(row, 6)
    local t = Instance.new("TextLabel") t.BackgroundTransparency = 1 t.Position = UDim2.fromOffset(12, 0) t.Size = UDim2.new(1, -70, 1, 0)
    t.Font = Enum.Font.GothamMedium t.TextSize = 13 t.TextColor3 = C.text t.TextXAlignment = Enum.TextXAlignment.Left t.Text = label t.Parent = row
    local knob = Instance.new("TextButton") knob.Size = UDim2.fromOffset(44, 22) knob.Position = UDim2.new(1, -56, 0.5, -11)
    knob.Text = "" knob.BorderSizePixel = 0 knob.Parent = row corner(knob, 11)
    local dot = Instance.new("Frame") dot.Size = UDim2.fromOffset(18, 18) dot.BackgroundColor3 = C.text dot.BorderSizePixel = 0 dot.Parent = knob corner(dot, 9)
    local function render()
        knob.BackgroundColor3 = S[key] and C.accent or C.bg
        dot.Position = S[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    end
    render()
    knob.MouseButton1Click:Connect(function()
        S[key] = not S[key] render() saveSettings()
        if onChange then task.spawn(pcall, onChange, S[key]) end
    end)
    ui.renders[key] = render
end
function ui.button(parent, label, col, fn)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = col or C.accent2 b.Text = label b.Font = Enum.Font.GothamMedium b.TextSize = 13 b.TextColor3 = C.text
    b.BorderSizePixel = 0 b.Parent = parent corner(b, 6)
    b.MouseButton1Click:Connect(function() task.spawn(pcall, fn) end)
    return b
end
-- a row of choice buttons bound to a string setting
function ui.choice(parent, key, options)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 28) row.BackgroundTransparency = 1 row.Parent = parent
    local l = Instance.new("UIListLayout") l.FillDirection = Enum.FillDirection.Horizontal l.Padding = UDim.new(0, 5) l.Parent = row
    local btns = {}
    local function render()
        for v, b in pairs(btns) do b.BackgroundColor3 = S[key] == v and C.accent or C.row b.TextColor3 = S[key] == v and C.bg or C.text2 end
    end
    for _, v in ipairs(options) do
        local b = Instance.new("TextButton") b.Size = UDim2.new(1 / #options, -4, 1, 0) b.Text = v
        b.Font = Enum.Font.GothamMedium b.TextSize = 12 b.BorderSizePixel = 0 b.Parent = row corner(b, 6)
        btns[v] = b
        b.MouseButton1Click:Connect(function() S[key] = v saveSettings() render() end)
    end
    render()
    ui.renders[key] = render
end
-- a draggable slider bound to a number setting
function ui.slider(parent, label, key, min, max, step, fmt)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 46) row.BackgroundColor3 = C.row row.BorderSizePixel = 0 row.Parent = parent corner(row, 6)
    local t = Instance.new("TextLabel") t.BackgroundTransparency = 1 t.Position = UDim2.fromOffset(12, 4) t.Size = UDim2.new(1, -24, 0, 18)
    t.Font = Enum.Font.GothamMedium t.TextSize = 13 t.TextColor3 = C.text t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = row
    local track = Instance.new("TextButton") track.Text = "" track.AutoButtonColor = false track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.fromOffset(12, 30) track.BackgroundColor3 = C.bg track.BorderSizePixel = 0 track.Parent = row corner(track, 4)
    local fill = Instance.new("Frame") fill.BackgroundColor3 = C.accent fill.BorderSizePixel = 0 fill.Parent = track corner(fill, 4)
    local function render()
        local v = S[key]
        fill.Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0)
        t.Text = label .. ":  " .. (fmt or "%s"):format(v)
    end
    local dragging = false
    local function setFrom(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local v = min + (max - min) * a
        v = math.floor(v / step + 0.5) * step
        S[key] = math.clamp(v, min, max) render()
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true setFrom(i.Position.X)
        end
    end)
    ui.conns[#ui.conns + 1] = UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then setFrom(i.Position.X) end
    end)
    ui.conns[#ui.conns + 1] = UserInputService.InputEnded:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            dragging = false saveSettings()
        end
    end)
    render()
    ui.renders[key] = render
end
-- a key picker bound to a KeyCode-name setting: click, then press a key (Backspace/Escape = none)
ui.capturing = false
function ui.keybind(parent, label, key)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 34) row.BackgroundColor3 = C.row row.BorderSizePixel = 0 row.Parent = parent corner(row, 6)
    local t = Instance.new("TextLabel") t.BackgroundTransparency = 1 t.Position = UDim2.fromOffset(12, 0) t.Size = UDim2.new(1, -130, 1, 0)
    t.Font = Enum.Font.GothamMedium t.TextSize = 13 t.TextColor3 = C.text t.TextXAlignment = Enum.TextXAlignment.Left t.Text = label t.Parent = row
    local b = Instance.new("TextButton") b.Size = UDim2.fromOffset(100, 24) b.Position = UDim2.new(1, -112, 0.5, -12)
    b.BackgroundColor3 = C.bg b.Font = Enum.Font.GothamMedium b.TextSize = 12 b.TextColor3 = C.text b.BorderSizePixel = 0 b.Parent = row corner(b, 6)
    local function render() b.Text = S[key] end
    b.MouseButton1Click:Connect(function()
        if ui.capturing then return end
        ui.capturing = true b.Text = "press a key..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            local name = i.KeyCode.Name
            S[key] = (name == "Backspace" or name == "Escape") and "None" or name
            saveSettings() render()
            task.defer(function() ui.capturing = false end)   -- don't let this same key press flip the feature
        end)
    end)
    render()
    ui.renders[key] = render
end

for _, n in ipairs(TAB_NAMES) do ui.tab(n) end

do -- Aim
    local p = ui.tabs.Aim
    ui.sec(p, "Aimbot")
    ui.toggle(p, "Aimbot", "Aimbot")
    ui.note(p, "Aim key:")
    ui.choice(p, "AimKey", { "Right mouse", "Left mouse", "Always" })
    ui.note(p, "Aim at:")
    ui.choice(p, "AimPart", { "Head", "Torso", "Closest" })
    ui.note(p, "Pick the target by (inside the FOV circle):")
    ui.choice(p, "TargetPriority", { "Crosshair", "Distance", "Health" })
    ui.note(p, "Method (Camera = turns the camera, best; Mouse = moves your mouse):")
    ui.choice(p, "AimMode", { "Camera", "Mouse" })
    ui.slider(p, "Aim FOV (pixels)", "AimFOV", 20, 600, 5, "%d")
    ui.toggle(p, "Show FOV circle", "ShowFOV")
    ui.slider(p, "Smoothness", "Smoothness", 0, 0.95, 0.05, "%.2f")
    ui.toggle(p, "Prediction (lead moving targets)", "Prediction")
    ui.toggle(p, "Wall check (only targets your shot can reach)", "WallCheck")
    ui.toggle(p, "Target info (line + name / HP on screen)", "TargetInfo")
    ui.keybind(p, "Aimbot on/off key", "AimbotToggleKey")
    ui.sec(p, "Silent aim")
    ui.toggle(p, "Silent aim (shots go to the target, no aim snap)", "SilentAim")
    ui.slider(p, "Hit chance (%)", "SilentHitChance", 1, 100, 1, "%d")
    ui.toggle(p, "Auto shoot (fires whenever silent aim has a target)", "AutoShoot")
    ui.keybind(p, "Silent aim on/off key", "SilentToggleKey")
    ui.note(p, "Picks the enemy inside the FOV circle using the aim part, priority, prediction and wall check above. Just click anywhere near them.")
    ui.sec(p, "Targets")
    ui.toggle(p, "Target players", "TargetPlayers")
    ui.toggle(p, "Target bots", "TargetBots")
    ui.toggle(p, "Ignore spawn-protected targets", "IgnoreProtected")
    ui.note(p, "The game is free-for-all, so everyone is an enemy (no team check needed).")
    ui.sec(p, "Trigger bot")
    ui.toggle(p, "Trigger bot (shoots when your crosshair is on an enemy)", "TriggerBot")
    ui.slider(p, "Trigger delay (s)", "TriggerDelay", 0, 0.5, 0.01, "%.2f")
    ui.note(p, "Fires through the game's own shoot code as soon as your gun is ready. Uses the bot / spawn-protection settings above.")
end
do -- Visuals
    local p = ui.tabs.Visuals
    ui.sec(p, "ESP")
    ui.toggle(p, "Player / bot ESP", "ESP")
    ui.toggle(p, "Boxes", "ESPBoxes")
    ui.choice(p, "BoxStyle", { "Corners", "Full" })
    ui.toggle(p, "Skeleton", "Skeleton")
    ui.toggle(p, "Names", "ESPNames")
    ui.toggle(p, "Killstreak next to names (x5)", "ESPStreak")
    ui.toggle(p, "Health bars (+ HP number when hurt)", "ESPHealth")
    ui.toggle(p, "Distance", "ESPDistance")
    ui.toggle(p, "Weapon they're holding", "ESPWeapon")
    ui.toggle(p, "Off-screen arrows", "Arrows")
    ui.toggle(p, "Green when your shot can reach them", "VisibleColors")
    ui.slider(p, "Max distance (studs)", "ESPMaxDistance", 100, 3000, 50, "%d")
    ui.slider(p, "Text size", "ESPTextSize", 10, 20, 1, "%d")
    ui.sec(p, "Filters")
    ui.toggle(p, "Show bots", "ESPBots")
    ui.toggle(p, "[SPAWN] tag on spawn-protected enemies", "SpawnTag")
    ui.sec(p, "Radar")
    ui.toggle(p, "Radar (top right, up = where you look)", "Radar")
    ui.slider(p, "Radar range (studs)", "RadarRange", 50, 1000, 25, "%d")
    ui.slider(p, "Radar size (pixels)", "RadarSize", 120, 320, 10, "%d")
    ui.sec(p, "Tracers")
    ui.toggle(p, "Tracers", "Tracers")
    ui.choice(p, "TracerFrom", { "Bottom", "Center", "Mouse" })
    ui.toggle(p, "Bullet tracers (where your shots went)", "BulletTracers")
    ui.sec(p, "World")
    ui.toggle(p, "Full bright", "FullBright")
    ui.toggle(p, "No fog", "NoFog")
    ui.sec(p, "Chams")
    ui.toggle(p, "Chams (see bodies through walls)", "Chams")
    ui.slider(p, "Chams fill (0 = solid, 1 = outline only)", "ChamsFill", 0, 1, 0.05, "%.2f")
    ui.note(p, "Red = player, orange = bot, green = one your shot can reach right now.")
    if not hasDrawing then ui.note(p, "Your executor has no Drawing library: boxes, names and tracers are unavailable, chams still work.") end
end
do -- Hitbox
    local p = ui.tabs.Hitbox
    ui.sec(p, "Hitbox changer")
    ui.toggle(p, "Bigger enemy hitboxes", "Hitbox")
    ui.choice(p, "HitboxPart", { "Head", "Torso" })
    ui.slider(p, "Size (studs)", "HitboxSize", 2, 20, 0.5, "%.1f")
    ui.toggle(p, "Show hitboxes (see-through)", "HitboxVisible")
    ui.note(p, "Grows the game's own invisible hit parts (Hitbox_Head / Hitbox_Torso) on players and bots, following the Aim tab's target switches. Everything is put back when you turn it off.")
end
do -- Gun
    local p = ui.tabs.Gun
    ui.sec(p, "Gun mods")
    ui.toggle(p, "No reload (magazine never empties)", "NoReload")
    ui.toggle(p, "Rapid fire", "RapidFire")
    ui.slider(p, "Fire rate multiplier", "FireRateMult", 1, 4, 0.1, "%.1fx")
    ui.toggle(p, "Full auto (hold left mouse to keep firing)", "FullAuto")
    ui.toggle(p, "Instant weapon switch (no 0.3 s lock)", "InstantSwitch")
    ui.note(p, "This game has no recoil or spread to remove. Most guns hold one bullet, so No reload is also the biggest speed-up: you skip the reload after every shot. Turning a mod off restores the gun's own values. The server may ignore shots fired much faster than normal.")
    ui.gun = ui.note(p, "Gun: -")
end
do -- Player
    local p = ui.tabs.Player
    ui.sec(p, "Movement")
    ui.toggle(p, "Walk speed", "WalkSpeedOn")
    ui.slider(p, "Speed", "WalkSpeed", 16, 60, 1, "%d")
    ui.toggle(p, "Jump power", "JumpOn")
    ui.slider(p, "Jump", "JumpPower", 50, 150, 5, "%d")
    ui.toggle(p, "Noclip (walk through walls)", "Noclip")
    ui.note(p, "All off by default. The game's normal speed is 22-26. Server checks can catch big speed / jump values or noclip and kick you; small boosts are the least obvious.")
    ui.sec(p, "Misc")
    ui.toggle(p, "Anti-AFK", "AntiAFK")
    ui.toggle(p, "Auto deploy + respawn (skips the death screen)", "AutoDeploy")
end
do -- Camera
    local p = ui.tabs.Camera
    ui.sec(p, "Field of view")
    ui.toggle(p, "FOV changer", "FOVChanger")
    ui.slider(p, "FOV", "FOV", 50, 120, 1, "%d")
    ui.toggle(p, "Keep scope zoom while aiming", "KeepADSZoom")
end
do -- Info
    local p = ui.tabs.Info
    ui.sec(p, "Cookies Hub Discord")
    local DISCORD = "https://discord.com/invite/ymJusGPxkE"
    local btn
    btn = ui.button(p, "Copy Discord invite (Cookies Hub)", C.accent, function()
        local copy = setclipboard or toclipboard or (syn and syn.write_clipboard)
        if copy then copy(DISCORD) btn.Text = "Copied! Paste it in your browser" else btn.Text = DISCORD end
        task.delay(3, function() if btn.Parent then btn.Text = "Copy Discord invite (Cookies Hub)" end end)
    end)
    ui.sec(p, "How it works")
    ui.note(p, "Free-for-all: every other player and bot is a target. The aimbot locks on to the enemy nearest your crosshair inside the FOV circle while the aim key is held. Silent aim, trigger bot, auto shoot and full auto all fire through the game's own shoot code, so hits register like normal shots.")
    ui.sec(p, "Keys")
    ui.note(p, "RightShift shows/hides the hub. X unloads it and puts hitboxes, guns and FOV back.")
    ui.sec(p, "Unload")
    -- Unload is defined further down, so go through the global
    ui.button(p, "Unload Cookies Hub (turns everything off)", C.danger, function()
        if _G.CookiesHubOneTap then _G.CookiesHubOneTap.Unload() end
    end)
end
ui.select("Aim")

-- live gun readout
task.spawn(function()
    while alive do
        task.wait(1)
        pcall(function()
            local c = myChar()
            local slot = holdingSlot()
            if c and slot and not iAmDead() then
                local name = currentWeaponName(c) or slot
                if slot == "Knife" then
                    ui.gun.Text = ("Gun: %s (knife)"):format(name)
                else
                    local d = weaponData(name) or {}
                    local max = WC.getMaxBulletsForCurrentWeapon()
                    local rate = d.firerate or defaultFireRate(d)
                    ui.gun.Text = ("Gun: %s   mag %s/%s   %.1f shots/s   %s"):format(name, tostring(WC.getBullets()), tostring(max), rate, WC.getState())
                end
            else
                ui.gun.Text = "Gun: not deployed"
            end
        end)
    end
end)

-- drag
do
    local dragging, startPos, startM
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true startPos = main.Position startM = i.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    ui.conns[#ui.conns + 1] = UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startM
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized tabRow.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(W, 40) or UDim2.fromOffset(W, H)
end)

local inputConn
local function Unload()
    alive = false
    pcall(function() RunService:UnbindFromRenderStep("CookiesHubOneTap") end)
    if inputConn then inputConn:Disconnect() end
    for _, c in ipairs(ui.conns) do c:Disconnect() end
    gunConn:Disconnect()
    espConn:Disconnect()
    moveConn:Disconnect()
    noclipConn:Disconnect()
    idleConn:Disconnect()
    pcall(restoreNoclip)
    pcall(function()
        local h = savedMove and savedMove.hum
        if h and h.Parent then
            if savedMove.walk then h.WalkSpeed = savedMove.walk end
            if savedMove.jumpPower then h.JumpPower = savedMove.jumpPower h.JumpHeight = savedMove.jumpHeight end
        end
    end)
    S.FullBright, S.NoFog = false, false   -- in memory only, so the saved settings keep your choice
    pcall(applyLighting)
    pcall(hideRadar)
    for k, d in pairs(radar) do
        if k == "dots" then for _, dot in ipairs(d) do pcall(function() dot:Remove() end) end
        else pcall(function() d:Remove() end) end
    end
    if targetLine then pcall(function() targetLine:Remove() targetText:Remove() end) end
    pcall(function() tracerFolder:Destroy() end)
    WC.fire = origFire
    WM.cast = origCast
    pcall(restoreGuns)
    for p in pairs(resized) do pcall(restorePart, p) end
    if savedFOV then pcall(function() camera().FieldOfView = savedFOV end) end
    for m in pairs(esp) do pcall(dropEsp, m) end
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    pcall(function() chamFolder:Destroy() end)
    pcall(function() gui:Destroy() end)
    _G.CookiesHubOneTap = nil
end
closeBtn.MouseButton1Click:Connect(Unload)
inputConn = UserInputService.InputBegan:Connect(function(i, gpe)
    if gpe or ui.capturing then return end
    if i.KeyCode == S.ToggleKey then main.Visible = not main.Visible end
    local name = i.KeyCode.Name
    if name == S.AimbotToggleKey then
        S.Aimbot = not S.Aimbot saveSettings() if ui.renders.Aimbot then ui.renders.Aimbot() end
    end
    if name == S.SilentToggleKey then
        S.SilentAim = not S.SilentAim saveSettings() if ui.renders.SilentAim then ui.renders.SilentAim() end
    end
end)

_G.CookiesHubOneTap = {
    Unload = Unload, State = S,
    Set = function(k, v)
        if S[k] == nil then return end
        S[k] = v saveSettings()
        if ui.renders[k] then pcall(ui.renders[k]) end   -- repainting can fail from a thread without UI access
    end,
    Get = function(k) return S[k] end,
    Targets = function() return targetsNow end,
    Status = function()   -- quick health check for bug reports
        return { alive = not iAmDead(), gun = WC.getState(), bullets = WC.getBullets(), targets = #targetsNow,
            silentTarget = silentPos ~= nil, locked = aim.locked and aim.locked.name or nil }
    end,
}
print("[CookiesHub] [FPS] One Tap loaded.")
