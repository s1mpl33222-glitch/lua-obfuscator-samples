-- Deobfuscated by skyr0.wtf | discord.gg/skyrowtf
-- Detected obfuscation: Ican see clearer now??????????????????????????????????????????????
-- Local names are inferred from use (the original names are not in the bytecode)


-- ==============================================================
-- SECURITY SCAN (skyr0.wtf): NO DANGEROUS BEHAVIOUR FOUND
-- --------------------------------------------------------------
--   no webhooks, IP loggers, credential theft, remote code or
--   purchase prompts found.
--   Note: static scan of the code below; strings built at run
--   time (encrypted or computed) can hide what it contacts.
-- ==============================================================



_G.__Elite_GrappleFired = false
_G.__Elite_KillQ = {}
local function __eliteSha256(message)
    local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
    local rrotate, rshift = bit32.rrotate, bit32.rshift
    local U32 = 4294967296
    local K = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
    }
    local h0,h1,h2,h3 = 0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a
    local h4,h5,h6,h7 = 0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
    local function u32be(n)
        return string.char(band(rshift(n,24),255), band(rshift(n,16),255), band(rshift(n,8),255), band(n,255))
    end
    local bitLen = #message * 8
    message = message .. "\128"
    while #message % 64 ~= 56 do message = message .. "\0" end
    message = message .. u32be(math.floor(bitLen / U32)) .. u32be(bitLen % U32)
    local w = {}
    for chunk = 1, #message, 64 do
        for i = 0, 15 do
            local a,b,c,d = string.byte(message, chunk + i*4, chunk + i*4 + 3)
            w[i+1] = ((a*256 + b)*256 + c)*256 + d
        end
        for i = 17, 64 do
            local x, y = w[i-15], w[i-2]
            local s0 = bxor(rrotate(x, 7), rrotate(x, 18), rshift(x, 3))
            local s1 = bxor(rrotate(y, 17), rrotate(y, 19), rshift(y, 10))
            w[i] = (w[i-16] + s0 + w[i-7] + s1) % U32
        end
        local a,b,c,d,e,f,g,h = h0,h1,h2,h3,h4,h5,h6,h7
        for i = 1, 64 do
            local S1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local t1 = (h + S1 + ch + K[i] + w[i]) % U32
            local S0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local maj = bxor(band(a, b), band(a, c), band(b, c))
            local t2 = (S0 + maj) % U32
            h, g, f, e = g, f, e, (d + t1) % U32
            d, c, b, a = c, b, a, (t1 + t2) % U32
        end
        h0=(h0+a)%U32 h1=(h1+b)%U32 h2=(h2+c)%U32 h3=(h3+d)%U32
        h4=(h4+e)%U32 h5=(h5+f)%U32 h6=(h6+g)%U32 h7=(h7+h)%U32
    end
    return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", h0,h1,h2,h3,h4,h5,h6,h7)
end
local __eliteRemoteSecret = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
local function __eliteCipher(name, jobId)
    local out, pos = {}, 0
    for i = 1, #name do
        local c = string.byte(name, i)
        if c == 47 then
            out[i] = "/"
        else
            pos = pos + 1
            local k = string.byte(jobId, (pos - 1) % #jobId + 1)
            out[i] = string.char(((c - 32 + k) % 95) + 32)
        end
    end
    return table.concat(out)
end
local __eliteRemoteCache = {}
function _G.Elite_GetRemoteByHash(name)
    local hit = __eliteRemoteCache[name]
    if hit and hit.Parent then return hit end
    local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Net = pkgs and pkgs:FindFirstChild("Net")
    if not Net then return nil end
    local jobId = game.JobId
    if type(jobId) ~= "string" or jobId == "" then return nil end
    local hash = __eliteSha256(__eliteCipher(name, jobId) .. __eliteRemoteSecret .. jobId)
    local r = Net:FindFirstChild("RE/" .. hash)
        or Net:FindFirstChild("RF/" .. hash)
        or Net:FindFirstChild("URE/" .. hash)
    if r then __eliteRemoteCache[name] = r end
    return r
end
local __Elite_GRAPPLE_ID = "75c9466d-e4c0-4b02-b26a-c3615fcc1e42"
function _G.Elite_GrappleRemote()
    return _G.Elite_GetRemoteByHash(__Elite_GRAPPLE_ID)
end
do
    local Players = game:GetService("Players")
    local function pin(a)
        if a and a.Name == "Animate" then
            pcall(function() a.Disabled = true end)
        end
    end
    local function hook(char)
        if not char then return end
        pin(char:FindFirstChild("Animate"))
        char.ChildAdded:Connect(pin)
    end
    local function onLp(lp)
        if not lp then return end
        if lp.Character then hook(lp.Character) end
        lp.CharacterAdded:Connect(hook)
    end
    local lp = Players.LocalPlayer
    if lp then
        onLp(lp)
    else
        Players.PlayerAdded:Connect(onLp)
    end
end
do
    local RS = game:GetService("ReplicatedStorage")
    local KEEP = {
        CustomProximityPromptController = true,
        InteractController = true,
        PlotController = true,
        AnimalController = true,
        PetController = true,
        WorldBrainrotController = true,
        EquipBrainrotsController = true,
        EquipBrainrotsRenderController = true,
        SelectBrainrotsController = true,
        BrainrotPreloadingController = true,
        AssetStreamController = true,
        AdminPanelController = true,
        NotificationController = true,
    }
    local function wrap(fn)
        if newcclosure then
            return newcclosure(fn)
        end
        return fn
    end
    local function isCtrlFolder(x)
        return typeof(x) == "Instance" and x.Name == "Controllers" and x.Parent == RS
    end
    local function callerName()
        if not getcallingscript then
            return "?"
        end
        local ok, s = pcall(getcallingscript)
        if not ok or s == nil then
            return "nil"
        end
        return tostring(s.Name)
    end
    local function fromLoader()
        return callerName() == "ClientLoader"
    end
    local function filt(kids)
        if type(kids) ~= "table" then
            return kids
        end
        local out = {}
        for i = 1, #kids do
            local k = kids[i]
            if k and KEEP[k.Name] then
                out[#out + 1] = k
            end
        end
        return out
    end
    local oldNc
    local undone = false
    local function unhook()
        if undone then return end
        undone = true
        pcall(function()
            if oldNc then
                hookmetamethod(game, "__namecall", oldNc)
            end
        end)
    end
    pcall(function()
        oldNc = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            local method = getnamecallmethod()
            if type(method) ~= "string" then
                return oldNc(self, ...)
            end
            local ml = string.lower(method)
            if ml ~= "getchildren" then
                return oldNc(self, ...)
            end
            if not isCtrlFolder(self) then
                return oldNc(self, ...)
            end
            if not fromLoader() then
                return oldNc(self, ...)
            end
            return filt(oldNc(self, ...))
        end))
    end)
    task.delay(6, unhook)
end
task.spawn(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    if not lp then
        lp = Players.PlayerAdded:Wait()
    end
    local rem
    local function find(name)
        local char = lp.Character
        local bp = lp:FindFirstChild("Backpack")
        return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    end
    local function remote()
        if rem and rem.Parent then return rem end
        local r = _G.Elite_GrappleRemote and _G.Elite_GrappleRemote()
        if r then rem = r end
        return r
    end
    local function tryEquipG()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local g = find("Grapple Hook")
        if g and hum and char and g.Parent ~= char then
            pcall(function() hum:EquipTool(g) end)
            return true
        end
        return char and char:FindFirstChild("Grapple Hook") ~= nil
    end
    pcall(function()
        lp.CharacterAdded:Connect(function()
            if _G.__Elite_GrappleFired then return end
            tryEquipG()
        end)
        local bp = lp:FindFirstChild("Backpack")
        if bp then
            bp.ChildAdded:Connect(function(ch)
                if _G.__Elite_GrappleFired then return end
                if ch and ch.Name == "Grapple Hook" then
                    tryEquipG()
                end
            end)
        end
        if lp.Character then
            tryEquipG()
        end
    end)
    local held = 0
    local t0 = os.clock()
    while os.clock() - t0 < 15 do
        if _G.__Elite_GrappleFired then return end
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local g = find("Grapple Hook")
        if g and hum and char then
            if g.Parent ~= char then
                pcall(function() hum:EquipTool(g) end)
                held = 0
            elseif char:FindFirstChild("Grapple Hook") then
                held += 1
                local r = remote()
                if held >= 2 and r then
                    pcall(function() r:FireServer(0.33) end)
                    pcall(function() r:FireServer(0.33) end)
                    pcall(function() r:FireServer(0.33) end)
                    _G.__Elite_GrappleFired = true
                    local tEq = os.clock() + 0.1
                    while os.clock() < tEq do
                        RunService.Heartbeat:Wait()
                    end
                    hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                    local tw = os.clock()
                    while os.clock() - tw < 0.4 do
                        local names = _G.Elite_CarpetNames
                        if type(names) ~= "table" then
                            names = {
                                _G.Elite_CarpetTool,
                                "Waverider",
                                "Flying Carpet",
                                "Witch's Broom",
                                "Santa's Sleigh",
                                "Cupid's Wings",
                            }
                        end
                        local prefer = _G.Elite_CarpetTool
                        local w, wn
                        if type(prefer) == "string" then
                            w = find(prefer)
                            if w then wn = prefer end
                        end
                        if not w then
                            for i = 1, #names do
                                local n = names[i]
                                if type(n) == "string" then
                                    local t = find(n)
                                    if t then
                                        w, wn = t, n
                                        break
                                    end
                                end
                            end
                        end
                        char = lp.Character
                        hum = char and char:FindFirstChildOfClass("Humanoid") or hum
                        if w and wn and hum and char then
                            if w.Parent ~= char then
                                pcall(function() hum:EquipTool(w) end)
                            end
                            if char:FindFirstChild(wn) then
                                return
                            end
                        end
                        RunService.Heartbeat:Wait()
                    end
                    return
                end
            else
                held = 0
            end
        else
            held = 0
        end
        RunService.Heartbeat:Wait()
    end
end)
task.spawn(function()
    local RS = game:GetService("ReplicatedStorage")
    local KILL = {
        RNGMachineVFX = true,
        LuckIcons = true,
        GlossaryBackground = true,
        AnimationGraphEditor = true,
        ML = true,
        PlayWaveEvents = true,
    }
    local function yeet(ch)
        if not ch then return end
        pcall(function()
            ch:Destroy()
        end)
    end
    local function dropKill(ch)
        if ch and KILL[ch.Name] then yeet(ch) end
    end
    local kids = RS:GetChildren()
    for i = 1, #kids do dropKill(kids[i]) end
    RS.ChildAdded:Connect(dropKill)
end)
task.wait()
local function _eliteBusy()
    return _G.__Elite_VelFlying == true
end
function _G.Elite_Kill(inst)
    if not inst then return end
    if _eliteBusy() then
        local q = _G.__Elite_KillQ
        q[#q + 1] = inst
        return
    end
    pcall(function() inst:Destroy() end)
end
function _G.Elite_FlushKills()
    local q = _G.__Elite_KillQ
    _G.__Elite_KillQ = {}
    for i = 1, #q do
        local x = q[i]
        if x and x.Parent then pcall(function() x:Destroy() end) end
    end
end
do
    local MUT_WORDS = {
        gold = true, diamond = true, rainbow = true, cyber = true,
        bloodrot = true, lava = true, galaxy = true, cursed = true,
        divine = true, radioactive = true, candy = true, crystal = true,
        celestial = true, phantom = true, eclipse = true,
        ["yin yang"] = true, yinyang = true, ["yin-yang"] = true,
    }
    local function normPrioName(s)
        s = string.lower(tostring(s or ""))
        s = string.gsub(s, "%[.-%]", " ")
        s = string.gsub(s, "[^%w%s%-]", " ")
        s = string.gsub(s, "%s+", " ")
        s = string.gsub(s, "^%s+", "")
        s = string.gsub(s, "%s+$", "")
        return s
    end
    local function peelMutations(s)
        local changed = true
        while changed and s ~= "" do
            changed = false
            for word in pairs(MUT_WORDS) do
                local pref = word .. " "
                if string.sub(s, 1, #pref) == pref then
                    s = string.sub(s, #pref + 1)
                    changed = true
                    break
                end
            end
            if not changed then
                for word in pairs(MUT_WORDS) do
                    local suf = " " .. word
                    if #s > #suf and string.sub(s, -#suf) == suf then
                        s = string.sub(s, 1, #s - #suf)
                        changed = true
                        break
                    end
                end
            end
        end
        return s
    end
    function _G.Elite_PrioBaseName(name)
        local set = _G.Elite_PrioSet
        local n = normPrioName(name)
        if n == "" then
            return nil
        end
        if type(set) == "table" and set[n] then
            return n
        end
        local peeled = peelMutations(n)
        if peeled ~= "" and type(set) == "table" and set[peeled] then
            return peeled
        end
        return nil
    end
    function _G.Elite_IsPrioName(name)
        local set = _G.Elite_PrioSet
        if type(set) ~= "table" or next(set) == nil then
            return true
        end
        return _G.Elite_PrioBaseName(name) ~= nil
    end
    function _G.Elite_RegisterMutWord(word)
        if type(word) ~= "string" then return end
        local n = normPrioName(word)
        if n ~= "" then
            MUT_WORDS[n] = true
        end
        local compact = string.gsub(n, "[%s%-_]", "")
        if compact ~= "" then
            MUT_WORDS[compact] = true
        end
    end
end
local function __eliteStrip()
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local LP = Players.LocalPlayer
    local function kill(inst)
        _G.Elite_Kill(inst)
    end
    pcall(function() workspace.Terrain.Decoration = false end)

    local WS_KILL = {
        FriendPanel = true, Cash = true, Unlock = true, Purchases = true,
        PlotSign = true, CashPad = true, InvisibleWalls = true, Multiplier = true,
        Slope = true, IncubatorMachine = true, FuseMachine = true, RobuxShop = true,
        AdminBoard = true, SoccerScoreBoard = true, CrystalSpinWheel = true,
        Beehive = false, CraftingMachine = true, Shop = true, Road = true,
        EventBoard = true, TradePlazaPortal = true, LosTraders = true,
        RNGMachine = true, Present = true, StPatricksPot = true,
        ShopNPCRobuxIdle = true, RoadPanel = true, Honey = true,
        Trap = false, Events = true, Sounds = true, rods = true,
        Dev = true, ToolsAdds = true, __PROJECTILES = true, CrystalMap = true,
        SpawnLocation = true, UFO = true, Interacts = true,
    }
    local PLOT_KEEP = {
        Skin = true, Laser = true, AnimalPodiums = true,
        DeliveryHitbox = true, StealHitbox = true, AnimalTarget = true,
        MainRoot = true, Floor = true, Spawn = true, Door = true, Hitbox = true,
        Base = true, Wall = true, Roof = true, SecondFloor = true, ThirdFloor = true,
        ["structure base home"] = true, Unlock = true,
        Trap = true, Beehive = true, BeeHive = true, Turret = true,
    }
    local PLOT_NUKE = {
        FriendPanel = true, Cash = true, Purchases = true,
        PlotSign = true, CashPad = true, InvisibleWalls = true, Multiplier = true,
        LaserHitbox = false, Events = true, Sounds = true,
        Slope = true,
    }
    local BODY_PART = {
        HumanoidRootPart = true, Head = true, Torso = true,
        UpperTorso = true, LowerTorso = true,
        LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
        RightUpperArm = true, RightLowerArm = true, RightHand = true,
        LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
        RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
        ["Left Arm"] = true, ["Right Arm"] = true,
        ["Left Leg"] = true, ["Right Leg"] = true,
    }
    local CHAR_KEEP_CLASS = {
        Humanoid = true, Animator = true, Attachment = true,
        Motor6D = true, AnimationConstraint = true,
        BallSocketConstraint = true, Weld = true, WeldConstraint = true,
    }
    local MAP_KEEP = { Ground = true, Ground_Left = true, Ground_Right = true }
    local PART_CLASS = {
        Part = true, MeshPart = true, UnionOperation = true,
        WedgePart = true, CornerWedgePart = true, TrussPart = true,
        SpawnLocation = true, Seat = true, VehicleSeat = true,
    }

    local function underUnlock(d)
        local x = d
        for _ = 1, 12 do
            if not x then return false end
            if x.Name == "Unlock" then return true end
            if x == workspace then return false end
            x = x.Parent
        end
        return false
    end
    local function isDefenseName(n)
        if n == "Trap" or n == "Beehive" or n == "BeeHive" or n == "Turret" then
            return true
        end
        return string.sub(n, 1, 7) == "BeeHive" or string.sub(n, 1, 7) == "Sentry_"
    end
    local function isDefense(inst)
        local x = inst
        for _ = 1, 12 do
            if not x then return false end
            if isDefenseName(x.Name) then return true end
            if x == workspace then return false end
            x = x.Parent
        end
        return false
    end
    local function isMine(inst)
        if not (LP and inst) then return false end
        if inst == LP.Character or inst.Name == LP.Name then return true end
        return false
    end
    local function isVisualJunk(d)
        local cn = d.ClassName
        return cn == "Beam" or cn == "Trail" or cn == "ParticleEmitter"
            or cn == "PointLight" or cn == "SpotLight" or cn == "SurfaceLight"
            or cn == "Fire" or cn == "Smoke" or cn == "Sparkles"
            or cn == "BillboardGui" or cn == "SurfaceGui" or cn == "Highlight"
            or cn == "Decal" or cn == "Texture"
    end
    local function isSkinJunk(d)
        if not d then return false end
        if isVisualJunk(d) then return true end
        return PART_CLASS[d.ClassName] == true and not d.CanCollide
    end
    local function isPet(inst)
        if not inst or inst.ClassName ~= "Model" then return false end
        return inst:FindFirstChild("FakeRootPart") ~= nil
            or inst:FindFirstChild("RootPart") ~= nil
    end
    local function stripSkin(skin)
        if not (skin and skin.Parent) then return end
        local dd = skin:GetDescendants()
        local dump = {}
        for i = 1, #dd do
            if isSkinJunk(dd[i]) then dump[#dump + 1] = dd[i] end
        end
        for i = 1, #dump do kill(dump[i]) end
    end
    local function skipLaserStrip(plot)
        local keep = _G.__Elite_KeepPlot
        if not keep then
            return true
        end
        return plot and tostring(plot.Name) == tostring(keep)
    end
    local function skipTimerStrip(plot)
        return skipLaserStrip(plot)
    end
    local function plotOf(d)
        local x = d
        for _ = 1, 16 do
            if not x then return nil end
            local p = x.Parent
            if p and p.Name == "Plots" then return x end
            x = p
        end
        return nil
    end
    local function isRemainingTimeGui(d)
        if not d then return false end
        local x = d
        for _ = 1, 16 do
            if not x then break end
            if x.Name == "RemainingTime" then return true end
            x = x.Parent
        end
        local cn = d.ClassName
        if cn == "BillboardGui" or cn == "SurfaceGui" then
            local hit
            pcall(function()
                hit = d:FindFirstChild("RemainingTime", true)
            end)
            if hit then return true end
        end
        return false
    end
    local function stripPurchasesKeepTimer(purch)
        if not (purch and purch.Parent) then return end
        local kids = purch:GetChildren()
        for i = 1, #kids do
            local ch = kids[i]
            if ch.Name ~= "PlotBlock" then
                kill(ch)
            else
                local dd = ch:GetDescendants()
                for j = 1, #dd do
                    local d = dd[j]
                    local cn = d.ClassName
                    if (cn == "BillboardGui" or cn == "SurfaceGui") and not isRemainingTimeGui(d) then
                        kill(d)
                    end
                end
            end
        end
    end
    local laserPend = {}
    local function stripLaser(laser)
        if not (laser and laser.Parent) then return end
        if skipLaserStrip(laser.Parent) then return end
        local bars = {}
        local beamPart = {}
        local dd = laser:GetDescendants()
        for i = 1, #dd do
            local d = dd[i]
            if d.ClassName == "Beam" then
                local a0, a1 = d.Attachment0, d.Attachment1
                local p0 = a0 and a0.Parent
                local p1 = a1 and a1.Parent
                if p0 and p0:IsA("BasePart") then beamPart[p0] = true end
                if p1 and p1:IsA("BasePart") then beamPart[p1] = true end
            elseif d:IsA("BasePart") then
                bars[#bars + 1] = d
            end
        end
        if #bars > 0 then
            local chosen = {}
            for i = 1, #bars do
                if beamPart[bars[i]] then chosen[#chosen + 1] = bars[i] end
            end
            if #chosen == 0 then
                for i = 1, #bars do
                    local d = bars[i]
                    local s = d.Size
                    local mx = math.max(s.X, s.Y, s.Z)
                    local mn = math.min(s.X, s.Y, s.Z)
                    local neon = false
                    pcall(function()
                        neon = d.Material == Enum.Material.Neon
                            or d.Material == Enum.Material.ForceField
                    end)
                    if neon or (mn <= 1.5 and mx >= 3) then
                        chosen[#chosen + 1] = d
                    end
                end
            end
            if #chosen == 0 then chosen = bars end
            local keep = chosen[1]
            if keep then
                for i = 1, #bars do
                    if bars[i] ~= keep then kill(bars[i]) end
                end
                pcall(function()
                    if PART_CLASS[laser.ClassName] then
                        laser.CanCollide = true
                        laser.CanTouch = true
                    end
                    keep.CanCollide = true
                    keep.CanTouch = true
                end)
            end
        end
    end
    local function queueStripLaser(laser)
        if not laser or laserPend[laser] then return end
        laserPend[laser] = true
        task.defer(function()
            laserPend[laser] = nil
            stripLaser(laser)
        end)
    end
    local function stripPetVfx(pet)
        if not pet then return end
        local dd = pet:GetDescendants()
        local dump = {}
        for i = 1, #dd do
            local d = dd[i]
            local n = d.Name
            local cn = d.ClassName
            if n == "VfxInstance" or n == "_VfxInstance" or n == "AnimationController"
                or cn == "ParticleEmitter" or cn == "Beam" or cn == "Trail"
                or cn == "Fire" or cn == "Smoke" or cn == "Sparkles"
                or cn == "Animator" or cn == "AnimationController"
                or cn == "Bone"
                or cn == "BillboardGui" or cn == "SurfaceGui" then
                dump[#dump + 1] = d
            end
        end
        for i = 1, #dump do kill(dump[i]) end
    end
    _G.Elite_StripPetVfx = stripPetVfx

    local function isCharJunk(d)
        if not d then return false end
        local cn = d.ClassName
        if cn == "PathfindingModifier" then return false end
        if cn == "WrapTarget" or cn == "WrapLayer" then return true end
        if cn == "Shirt" or cn == "ShirtGraphic" then return true end
        if cn == "NoCollisionConstraint" then return true end
        local nm = d.Name
        if nm == "__HITBOX" or nm == "OriginalPosition" or nm == "OriginalSize" then return true end
        if CHAR_KEEP_CLASS[cn] then return false end
        if BODY_PART[nm] then return false end
        return true
    end
    local function isUuidName(n)
        return type(n) == "string" and #n == 36
            and string.match(n, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
    end
    local function isOtherAvatar(char)
        if not (char and char.ClassName == "Model") then return false end
        if isMine(char) then return false end
        if isPet(char) then return false end
        local n = char.Name
        if type(n) == "string" and string.sub(n, -6) == "_Clone" then return false end
        if Players:GetPlayerFromCharacter(char) then return true end
        if Players:FindFirstChild(n) then return true end
        return char:FindFirstChildOfClass("Humanoid") ~= nil
    end
    local hookedChars = {}
    local function stripOtherChar(char)
        if _G.__Elite_VelFlying then return end
        if not (char and char.Parent) or isMine(char) or not isOtherAvatar(char) then return end
        local function sweep()
            local dd = char:GetDescendants()
            local dump = {}
            for i = 1, #dd do
                if isCharJunk(dd[i]) then dump[#dump + 1] = dd[i] end
            end
            for i = 1, #dump do kill(dump[i]) end
        end
        sweep()
        if hookedChars[char] then return end
        hookedChars[char] = true
        char.DescendantAdded:Connect(function(d)
            if _G.__Elite_VelFlying then return end
            if d and d.Parent and not isMine(char) and isCharJunk(d) then kill(d) end
        end)
    end

    local strippedPlots = {}
    _G.__Elite_StrippedPlots = strippedPlots
    local function near(a, b)
        return math.abs(a - b) < 0.2
    end
    local function isPlotPadPart(d)
        if not d or PART_CLASS[d.ClassName] ~= true then return false end
        if d.Name == "structure base home" or d.Name == "Spawn" then return false end
        local s = d.Size
        if near(s.X, 4) and near(s.Y, 1) and near(s.Z, 4) then return true end
        if near(s.X, 2) and near(s.Y, 0.5) and near(s.Z, 2) then return true end
        return false
    end
    local function isPodiumPlate(d)
        if not d or PART_CLASS[d.ClassName] ~= true then return false end
        if d.Name == "Spawn" then return false end
        local s = d.Size
        if near(s.X, 6) and near(s.Y, 0.2) and near(s.Z, 6) then return true end
        if near(s.X, 4) and near(s.Y, 0.2) and near(s.Z, 4) then return true end
        return false
    end
    local function stripPlotDecor(dec)
        if not (dec and dec.Parent) then return end
        local dump = {}
        local function walk(x)
            local kids = x:GetChildren()
            for i = 1, #kids do
                local d = kids[i]
                local cn = d.ClassName
                local nm = d.Name
                if nm == "Spawn" or nm == "PromptAttachment" or cn == "ProximityPrompt" then
                elseif isDefenseName(nm) or isDefense(d) then
                elseif cn == "Model" and isPet(d) then
                elseif cn == "Beam" or cn == "PointLight" then
                    dump[#dump + 1] = d
                elseif isPlotPadPart(d) then
                    dump[#dump + 1] = d
                else
                    walk(d)
                end
            end
        end
        walk(dec)
        for i = 1, #dump do kill(dump[i]) end
    end
    local function stripPodiumPlates(pods)
        if not (pods and pods.Parent) then return end
        local dump = {}
        local function scan(folder)
            if not folder then return end
            local dd = folder:GetDescendants()
            for i = 1, #dd do
                local d = dd[i]
                if d.Name ~= "Spawn" and d.Name ~= "PromptAttachment"
                    and d.ClassName ~= "ProximityPrompt" and isPodiumPlate(d) then
                    dump[#dump + 1] = d
                end
            end
        end
        local slots = pods:GetChildren()
        for i = 1, #slots do
            local slot = slots[i]
            local base = slot:FindFirstChild("Base")
            if base then scan(base:FindFirstChild("Decorations")) end
            scan(slot:FindFirstChild("Decorations"))
        end
        for i = 1, #dump do kill(dump[i]) end
    end
    local function handlePlotChild(plot, ch)
        if not (ch and ch.Parent) then return end
        local n = ch.Name
        if isDefenseName(n) then return end
        if n == "Skin" then stripSkin(ch); return end
        if n == "Laser" then return end
        if n == "AnimalPodiums" then stripPodiumPlates(ch); return end
        if n == "Decorations" then stripPlotDecor(ch); return end
        if n == "Purchases" then
            if skipTimerStrip(plot) then
                stripPurchasesKeepTimer(ch)
            else
                kill(ch)
            end
            return
        end
        if PLOT_KEEP[n] then return end
        if PLOT_NUKE[n] then kill(ch); return end
        if isPet(ch) then
            if not _G.Elite_IsPrioName(n) then
                kill(ch)
            else
                stripPetVfx(ch)
            end
            return
        end
    end
    local function stripPlotInteriorFast(plot)
        if not (plot and plot.Parent) then return end
        if _G.__Elite_MyPlot and plot.Name == _G.__Elite_MyPlot then return end
        strippedPlots[plot.Name] = true
        local kids = plot:GetChildren()
        for i = 1, #kids do
            local ch = kids[i]
            if ch and ch.Parent then
                local n = ch.Name
                if n == "Skin" or n == "Laser" or n == "AnimalPodiums" or n == "Decorations" then
                elseif n == "Purchases" and skipTimerStrip(plot) then
                    stripPurchasesKeepTimer(ch)
                elseif PLOT_KEEP[n] then
                elseif PLOT_NUKE[n] then
                    kill(ch)
                elseif isPet(ch) then
                    if not _G.Elite_IsPrioName(n) then
                        kill(ch)
                    end
                end
            end
        end
    end
    local function stripPlotVisual(plot)
        if not (plot and plot.Parent) then return end
        if _G.__Elite_MyPlot and plot.Name == _G.__Elite_MyPlot then return end
        local skin = plot:FindFirstChild("Skin")
        if skin then stripSkin(skin) end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if pods then stripPodiumPlates(pods) end
        local dec = plot:FindFirstChild("Decorations")
        if dec then stripPlotDecor(dec) end
        local kids = plot:GetChildren()
        for i = 1, #kids do
            local ch = kids[i]
            if isPet(ch) then stripPetVfx(ch) end
        end
    end
    local function stripPlotInterior(plot)
        stripPlotInteriorFast(plot)
        stripPlotVisual(plot)
    end
    local function connectPlot(plot)
        if not (plot and plot.Parent) then return end
        plot.ChildAdded:Connect(function(ch)
            if _G.__Elite_VelFlying then return end
            handlePlotChild(plot, ch)
        end)
        plot.DescendantAdded:Connect(function(d)
            if _G.__Elite_VelFlying then return end
            if not d then return end
            if underUnlock(d) then return end
            if isDefense(d) then return end
            local cn = d.ClassName
            if cn == "BillboardGui" or cn == "SurfaceGui" then
                if skipTimerStrip(plot) and isRemainingTimeGui(d) then return end
                kill(d)
                return
            end
            if d.Name == "Spawn" or d.Name == "PromptAttachment" or cn == "ProximityPrompt" then
                return
            end
            if d.Name == "Decorations" and d.Parent == plot then
                stripPlotDecor(d)
                return
            end
            local p = d.Parent
            if not p then return end
            if p.Name == "LaserHitbox" then return end
            if PART_CLASS[d.ClassName] then
                if isPlotPadPart(d) then
                    local x = p
                    local inPlotDec, skip = false, false
                    while x and x ~= plot do
                        if isPet(x) or x.Name == "Spawn" or x.Name == "AnimalPodiums" then
                            skip = true; break
                        end
                        if x.Name == "Decorations" and x.Parent == plot then inPlotDec = true end
                        x = x.Parent
                    end
                    if inPlotDec and not skip then kill(d); return end
                elseif isPodiumPlate(d) then
                    local x = p
                    local inDec, skip = false, false
                    while x and x ~= plot do
                        if x.Name == "Spawn" then skip = true; break end
                        if x.Name == "Decorations" then inDec = true end
                        if x.Name == "AnimalPodiums" then
                            if inDec and not skip then kill(d) end
                            return
                        end
                        x = x.Parent
                    end
                end
            end
            local sk = p
            while sk and sk ~= plot do
                if sk.Name == "Skin" then
                    if isSkinJunk(d) then kill(d) end
                    return
                end
                sk = sk.Parent
            end
            local las = p
            while las and las ~= plot do
                if las.Name == "Laser" then
                    return
                end
                las = las.Parent
            end
        end)
    end
    local function plotIsMine(plot)
        if not plot then return false end
        if _G.__Elite_MyPlot and plot.Name == _G.__Elite_MyPlot then return true end
        local ch
        pcall(function()
            if _G.eliteSyncGet then ch = _G.eliteSyncGet(plot.Name) end
        end)
        if ch and _G.Elite_IsMyPlot and _G.Elite_IsMyPlot(ch) then
            _G.__Elite_MyPlot = plot.Name
            return true
        end
        return false
    end
    local function canDestroyPlot(plot)
        if not plot then return false end
        if plotIsMine(plot) then return false end
        local keep = _G.__Elite_KeepPlot
        if keep and plot.Name == keep then return false end
        if not _G.__Elite_MyPlot then return false end
        return plot.Name ~= _G.__Elite_MyPlot
    end
    local hookedPlots
    local function hookPlot(plot)
        if plotIsMine(plot) then return end
        stripPlotInterior(plot)
        connectPlot(plot)
    end
    local function hookPlots(folder)
        if not folder or hookedPlots == folder then return end
        hookedPlots = folder
        local kids = folder:GetChildren()
        for i = 1, #kids do
            if not plotIsMine(kids[i]) then
                stripPlotInterior(kids[i])
                connectPlot(kids[i])
            end
        end
        folder.ChildAdded:Connect(function(plot)
            hookPlot(plot)
            if canDestroyPlot(plot) then
                kill(plot)
            end
        end)
    end
    _G.Elite_LockPrioPlot = function(plotName)
        if not plotName then return end
        _G.__Elite_KeepPlot = tostring(plotName)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        local kids = plots:GetChildren()
        for i = 1, #kids do
            local plot = kids[i]
            if canDestroyPlot(plot) then
                kill(plot)
            end
        end
        local mine = _G.__Elite_MyPlot and plots:FindFirstChild(_G.__Elite_MyPlot)
        if mine and _G.Elite_NukePlotPodiums then
            pcall(_G.Elite_NukePlotPodiums, mine)
        end
        local keepPlot = _G.__Elite_KeepPlot and plots:FindFirstChild(_G.__Elite_KeepPlot)
        if keepPlot and _G.Elite_StripNonPrioPodiums then
            pcall(_G.Elite_StripNonPrioPodiums, keepPlot)
        end
    end

    local function stripMap(map)
        local function handle(x)
            if _G.__Elite_VelFlying then return end
            if x and not MAP_KEEP[x.Name] then kill(x) end
        end
        local kids = map:GetChildren()
        for i = 1, #kids do handle(kids[i]) end
        map.ChildAdded:Connect(handle)
    end
    local hookedRma
    local rmaBoxDone = false
    local function hookRma(rma)
        if not rma then return end
        if rmaBoxDone then
            kill(rma)
            return
        end
        if hookedRma == rma then return end
        hookedRma = rma
        local function nuke()
            if _G.__Elite_VelFlying then return end
            if rmaBoxDone then return end
            rmaBoxDone = true
            kill(rma)
        end
        if #rma:GetChildren() > 0 then
            nuke()
        else
            rma.ChildAdded:Connect(nuke)
        end
    end
    local function onWsChild(ch)
        if not ch then return end
        if _G.__Elite_VelFlying then return end
        local n = ch.Name
        if ch.ClassName == "Camera" or ch.ClassName == "Terrain" then return end
        if n == "Plots" then hookPlots(ch); return end
        if n == "RenderedMovingAnimals" then hookRma(ch); return end
        if n == "Map" then stripMap(ch); return end
        if isMine(ch) then return end
        if isUuidName(n) then kill(ch); return end
        if isOtherAvatar(ch) then stripOtherChar(ch); return end
        if ch.ClassName == "Model" then
            ch.ChildAdded:Connect(function()
                if isOtherAvatar(ch) then stripOtherChar(ch) end
            end)
        end
        if isDefenseName(n) then return end
        if WS_KILL[n] or ch.ClassName == "Highlight" then kill(ch); return end
        if ch.ClassName == "Model" and string.find(n, "'s Rainbow", 1, true) then
            kill(ch)
        end
    end
    local wsch = workspace:GetChildren()
    local plotsFolder, mapFolder, rmaFolder
    local rest = {}
    for i = 1, #wsch do
        local ch = wsch[i]
        local n = ch.Name
        if n == "Plots" then plotsFolder = ch
        elseif n == "Map" then mapFolder = ch
        elseif n == "RenderedMovingAnimals" then rmaFolder = ch
        else rest[#rest + 1] = ch end
    end
    if mapFolder then stripMap(mapFolder) end
    if rmaFolder then hookRma(rmaFolder) end
    for i = 1, #rest do onWsChild(rest[i]) end
    if plotsFolder then hookPlots(plotsFolder) end
    workspace.ChildAdded:Connect(onWsChild)

    local function hookPlrChar(plr)
        if not plr or plr == LP then return end
        if plr.Character then stripOtherChar(plr.Character) end
        plr.CharacterAdded:Connect(stripOtherChar)
    end
    local plrs = Players:GetPlayers()
    for i = 1, #plrs do hookPlrChar(plrs[i]) end
    Players.PlayerAdded:Connect(hookPlrChar)

    local function onLit(x)
        if _G.__Elite_VelFlying then return end
        if not x then return end
        local cn = x.ClassName
        if cn == "Sky" or cn == "Atmosphere" or cn == "Clouds"
            or cn == "SunRaysEffect" or cn == "ColorCorrectionEffect" then
            kill(x)
        end
    end
    local lit = Lighting:GetChildren()
    for i = 1, #lit do onLit(lit[i]) end
    Lighting.ChildAdded:Connect(onLit)
    local function stripCamFx(x)
        if not x then return end
        local cn = x.ClassName
        if cn == "ColorCorrectionEffect" or cn == "BlurEffect" then kill(x) end
    end
    local hookedCam
    local function hookCam(cam)
        if not cam or hookedCam == cam then return end
        hookedCam = cam
        local ck = cam:GetChildren()
        for i = 1, #ck do stripCamFx(ck[i]) end
        cam.ChildAdded:Connect(stripCamFx)
    end
    hookCam(workspace.CurrentCamera)
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        hookCam(workspace.CurrentCamera)
    end)
    workspace.DescendantAdded:Connect(function(d)
        if not d then return end
        if _G.__Elite_VelFlying then return end
        local cn = d.ClassName
        if cn == "BillboardGui" or cn == "SurfaceGui" or cn == "Decal" or cn == "Texture" then
            if underUnlock(d) then return end
            if isDefense(d) then return end
            if (cn == "BillboardGui" or cn == "SurfaceGui")
                and skipTimerStrip(plotOf(d)) and isRemainingTimeGui(d) then
                return
            end
            kill(d)
        end
    end)
    if mapFolder and mapFolder.Parent then
        local md = mapFolder:GetDescendants()
        for i = 1, #md do
            local cn = md[i].ClassName
            if cn == "Decal" or cn == "Texture" then kill(md[i]) end
        end
    end
    do
        local ter = workspace.Terrain
        pcall(function() ter.Decoration = false end)
        pcall(function() ter:Clear() end)
        local kids = ter:GetChildren()
        for i = 1, #kids do kill(kids[i]) end
        ter.ChildAdded:Connect(function(ch)
            if _G.__Elite_VelFlying then return end
            kill(ch)
        end)
        ter.DescendantAdded:Connect(function(d)
            if _G.__Elite_VelFlying then return end
            if d then kill(d) end
        end)
    end
    _G.__Elite_StripDone = true
end
task.wait()
local SRC = [=[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")

do
    local _eliteChans
    local _synInst, _syncMod
    local function _synNow()
        if _synInst and _synInst.Parent then return _synInst end
        local p = ReplicatedStorage:FindFirstChild("Packages")
        _synInst = p and p:FindFirstChild("Synchronizer")
        return _synInst
    end
    local function _tryEliteSync()
        if _eliteChans then return true end
        local syn = _synNow()
        if not syn then return false end
        if type(_syncMod) ~= "table" then
            local req = (getrenv and getrenv().require) or require
            local ok, mod = pcall(req, syn)
            if ok and type(mod) == "table" then _syncMod = mod end
        end
        local getFn = type(_syncMod) == "table" and rawget(_syncMod, "Get")
        local gf = getfenv or (debug and debug.getfenv)
        if type(getFn) ~= "function" or type(gf) ~= "function" then return false end
        local ok, env = pcall(gf, getFn)
        if not ok or type(env) ~= "table" then return false end
        local ch = rawget(env, "Channels")
        if type(ch) ~= "table" then return false end
        _eliteChans = ch
        return true
    end
    local t0 = os.clock()
    while os.clock() - t0 < 8 do
        if _tryEliteSync() then break end
        RunService.Heartbeat:Wait()
    end
    local function _chans()
        if _eliteChans then return _eliteChans end
        _tryEliteSync()
        return _eliteChans
    end
    _G.eliteSyncAll = function() return _chans() end
    _G.eliteSyncGet = function(idx)
        local t = _chans()
        if not t or idx == nil then return nil end
        local ok, cd = pcall(rawget, t, idx)
        if ok and type(cd) == "table" then return cd end
        local ok2, cd2 = pcall(function() return t[idx] end)
        if ok2 and type(cd2) == "table" then return cd2 end
        return nil
    end
    _G.Elite_IsPlotChanKey = function(k)
        return type(k) == "string" and #k >= 32 and string.find(k, "-", 1, true) ~= nil
    end
    _G.elite_IsPlotChanKey = _G.Elite_IsPlotChanKey
    _G.Elite_ChanGet = function(ch, key)
        if type(ch) ~= "table" or key == nil then return nil end
        local ct = rawget(ch, "CacheTable")
        if type(ct) ~= "table" then
            local okC, c2 = pcall(function() return ch.CacheTable end)
            if okC and type(c2) == "table" then ct = c2 end
        end
        if type(ct) ~= "table" then return nil end
        local v = rawget(ct, key)
        if v ~= nil then return v end
        local okV, v2 = pcall(function() return ct[key] end)
        if okV then return v2 end
        return nil
    end
    _G.EliteSyncAll = _G.eliteSyncAll
    _G.EliteSyncGet = _G.eliteSyncGet
    _G.eliteSyncAll = _G.eliteSyncAll
    _G.eliteSyncGet = _G.eliteSyncGet
    _G.Elite_GetPlotChannel = _G.eliteSyncGet
    _G.EliteChanGet = _G.Elite_ChanGet
    if _eliteChans then _G.__Elite_SyncBoot = true end
end
task.spawn(function()
    local t0 = os.clock()
    while os.clock() - t0 < 15 do
        if _G.__Elite_TPStarted or _G.__Elite_VelFlying then return end
        if _G.Elite_ScanPets and _G.Elite_DoVelocityTP then
            local ok, pets = pcall(_G.Elite_ScanPets)
            if ok and type(pets) == "table" and #pets > 0 then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(_G.Elite_DoVelocityTP, pets)
                    return
                end
            end
        end
        task.wait()
    end
end)

do
    local okPre = pcall(function()
        RunService.PreSimulation:Connect(function(dt)
            local f = _G.__Elite_FlyPre
            if f then
                f(dt)
            end
        end)
    end)
    if not okPre then
        RunService.Stepped:Connect(function(_, dt)
            local f = _G.__Elite_FlyPre
            if f then
                f(dt)
            end
        end)
    end
    pcall(function()
        RunService.Heartbeat:Connect(function(dt)
            local f = _G.__Elite_FlyHb
            if f then
                f(dt)
            end
        end)
    end)
end

do
    local function hookChar(char)
        if not char then return end
        task.defer(function()
            local h = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 8)
            if not (h and h:IsA("BasePart")) then return end
            pcall(function()
                h.Anchored = false
                LocalPlayer.ReplicationFocus = h
            end)
        end)
    end
    if LocalPlayer.Character then hookChar(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(hookChar)
end

do
    local function unwalk(char)
        local a = char and char:FindFirstChild("Animate")
        if a then
            pcall(function() a.Disabled = true end)
        end
    end
    local function hook(char)
        if not char then return end
        unwalk(char)
        char.ChildAdded:Connect(function(ch)
            if ch.Name == "Animate" then
                pcall(function() ch.Disabled = true end)
            end
        end)
    end
    if LocalPlayer.Character then hook(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(hook)
end

priorityList = {
    "Headless Horseman",
    "Polaroidini",
    "Signore Carapace",
    "Strawberry Elephant",
    "Plant Bros",
    "Meowl",
    "John Pork",
    "Skibidi Toilet",
    "Arcadragon",
    "Elefanto Frigo",
    "Los Dragons",
    "Orchidox",
    "Phoenix",
    "Dragon Gingerini",
    "Antonio",
    "Love Love Bear",
    "Griffin",
    "Dragon Aquanini",
    "Orchidox",
    "Kalika Bros",
    "Fishino Clownino",
    "La Supreme Combinasion",
    "Kraken",
    "Moby Bros",
    "Digi Narwhal",
    "Hydra Bunny",
    "Ginger Gerat",
    "Jelly Moby",
    "Hydra Serpent",
    "Pancake and Syrup",
    "Grabatron",
    "Hydra Dragon Cannelloni",
    "Sammyni Cakini",
    "Bunny and Eggy",
    "Los Secret Combinasionas",
    "Dragon Cannelloni",
    "Ketupat Bros",
    "Gold and Diamond",
    "La Casa Boo",
    "Duggy Bros",
    "Venuspino",
    "Bumbatron",
    "Dug dug dug",
    "Rosey and Teddy",
    "Rico Dinero",
    "Foxini Lanternini",
    "La Breakfast Combinasion",
    "Gym Bros",
    "Rubrikiko",
    "Capitano Americano",
    "La Craft Machine",
    "Los Sekolahs",
    "Celularcini Viciosini",
    "Fortunu and Cashuru",
    "Rubiko and Kubiko",
    "Sammyni Truckini",
    "Los Hackers",
    "Examen Bros",
    "Los Admins",
    "Los Amigos",
    "La Fuse Machine",
    "Spooky and Pumpky",
    "Quackini Snackini",
    "Globa Steppa",
    "Reinito Sleighito",
    "Cooki and Milki",
    "Bearito Cabinito",
    "Fragrama and Chocrama",
    "La Food Combinasion",
    "Los Chillis",
    "Sammyni Fattini",
    "Guest 666",
    "Cerberus",
    "Pizza and Ranch",
    "Jolly Jolly Sahur",
    "S'more Serat",
    "Yetimatic",
    "Hopilikalika Hopilikalako",
    "Fragola La La La",
    "Tralaledon",
    "Celestial Pegasus",
    "Capitano Moby",
    "Popcuru and Fizzuru",
    "Garama and Madundung",
    "Burguro And Fryuro",
    "Pop Pop Petalini",
    "Cash or Card",
    "La Secret Combinasion",
    "los tictacs",
}
mutationList = {
    "Bloodrot",
    "Crystal",
    "Phantom",
    "Candy",
    "Lava",
    "Yin Yang",
    "Radioactive",
    "Eclipse",
    "Galaxy",
    "Divine",
    "Rainbow",
}
Config = {
    AutoStealEnabled = true,
    AutoGrabRadius = 90,
    AutoTPPriority = true,
    StealNearest = false,
    StealMode = "Priority",
    PriorityList = priorityList,
    MutationList = mutationList,
    InfiniteJump = true,
    WaveriderSpeedEnabled = false,
    WaveriderSpeed = 140,
    StealNearestKey = "T",
    AutoClone = true,
    InvSteal = true,
    InvStealAngle = 220,
    InvStealDepth = 7.4,
    InvStealDelay = 0.5,
    TpSettings = {
        Tool = "Waverider",
        CloneDelayVal = 0.27,
        GrabbleTPSpeed = 480,
    },
}
do
    local Http = game:GetService("HttpService")
    local FILE = "ElitePrivateHub.json"
    local function copyStrList(src)
        local t = {}
        if type(src) ~= "table" then return t end
        for _, v in ipairs(src) do
            if type(v) == "string" then
                local s = string.gsub(string.gsub(v, "^%s+", ""), "%s+$", "")
                if s ~= "" then
                    t[#t + 1] = s
                end
            end
        end
        return t
    end
    local function copyKeybinds(src)
        local t = {}
        if type(src) ~= "table" then return t end
        for k, v in pairs(src) do
            if k ~= "CarpetSpeedOn" and k ~= "WaveriderSpeedEnabled" and k ~= "ToolSpeed" then
                t[k] = v
            end
        end
        return t
    end
    local function rebuildPrioSet(list)
        if type(list) == "table" and #list > 0 then
            priorityList = list
        end
        Config.PriorityList = priorityList
        local set = {}
        for _, n in ipairs(priorityList) do
            if type(n) == "string" and n ~= "" then
                set[string.lower(n)] = true
            end
        end
        _G.Elite_PrioSet = set
        if _G.Elite_RebuildPrioRank then
            pcall(_G.Elite_RebuildPrioRank)
        end
    end
    local function applyMutList(list)
        if type(list) == "table" and #list > 0 then
            mutationList = list
        end
        Config.MutationList = mutationList
        if _G.Elite_RegisterMutWord then
            for _, n in ipairs(mutationList) do
                pcall(_G.Elite_RegisterMutWord, n)
            end
        end
        if _G.Elite_RebuildPrioRank then
            pcall(_G.Elite_RebuildPrioRank)
        end
    end
    local function applySaved(saved)
        if type(saved) ~= "table" then return end
        if saved.AutoStealEnabled ~= nil then Config.AutoStealEnabled = saved.AutoStealEnabled == true end
        if tonumber(saved.AutoGrabRadius) then Config.AutoGrabRadius = tonumber(saved.AutoGrabRadius) end
        if saved.AutoTPPriority ~= nil then Config.AutoTPPriority = saved.AutoTPPriority == true end
        if saved.StealNearest ~= nil then Config.StealNearest = saved.StealNearest == true end
        if type(saved.StealMode) == "string" and saved.StealMode ~= "" then Config.StealMode = saved.StealMode end
        if saved.AutoClone ~= nil then Config.AutoClone = saved.AutoClone == true end
        if saved.InvSteal ~= nil then Config.InvSteal = saved.InvSteal == true end
        if tonumber(saved.InvStealAngle) then Config.InvStealAngle = tonumber(saved.InvStealAngle) end
        if tonumber(saved.InvStealDepth) then Config.InvStealDepth = tonumber(saved.InvStealDepth) end
        if tonumber(saved.InvStealDelay) then Config.InvStealDelay = math.clamp(tonumber(saved.InvStealDelay), 0, 5) end
        if tonumber(saved.WaveriderSpeed) then Config.WaveriderSpeed = 140 end
        if type(saved.StealNearestKey) == "string" and saved.StealNearestKey ~= "" then
            Config.StealNearestKey = saved.StealNearestKey
        end
        if type(saved.TpSettings) == "table" then
            Config.TpSettings = Config.TpSettings or {}
            if type(saved.TpSettings.Tool) == "string" and saved.TpSettings.Tool ~= "" then
                Config.TpSettings.Tool = saved.TpSettings.Tool
            end
            if tonumber(saved.TpSettings.CloneDelayVal) then
                Config.TpSettings.CloneDelayVal = tonumber(saved.TpSettings.CloneDelayVal)
            end
            if tonumber(saved.TpSettings.GrabbleTPSpeed) then
                Config.TpSettings.GrabbleTPSpeed = tonumber(saved.TpSettings.GrabbleTPSpeed)
            end
        end
        local pri = copyStrList(saved.PriorityList)
        if #pri > 0 then
            rebuildPrioSet(pri)
        end
        local mut = copyStrList(saved.MutationList)
        if #mut > 0 then
            applyMutList(mut)
        end
        if type(saved.Keybinds) == "table" then
            _G.Elite_Keybinds = copyKeybinds(saved.Keybinds)
        end
        if type(saved.UiPos) == "table" then
            _G.Elite_UiPos = saved.UiPos
        end
        Config.WaveriderSpeedEnabled = false
    end
    local saved = type(_G.Elite_HubConfig) == "table" and _G.Elite_HubConfig or nil
    pcall(function()
        if type(readfile) ~= "function" then return end
        local raw = readfile(FILE)
        local ok, data = pcall(function()
            return Http:JSONDecode(raw)
        end)
        if ok and type(data) == "table" then
            saved = data
        end
    end)
    applySaved(saved)
    rebuildPrioSet(copyStrList(Config.PriorityList) )
    applyMutList(copyStrList(Config.MutationList))
    local saveGen = 0
    function _G.Elite_SaveConfig()
        saveGen += 1
        local gen = saveGen
        task.delay(0.12, function()
            if gen ~= saveGen then return end
            local kb = copyKeybinds(Config.Keybinds or _G.Elite_Keybinds)
            kb.CarpetSpeedOn = nil
            kb.WaveriderSpeedEnabled = nil
            local snap = {
                AutoStealEnabled = Config.AutoStealEnabled ~= false,
                AutoGrabRadius = tonumber(Config.AutoGrabRadius) or 90,
                AutoTPPriority = Config.AutoTPPriority ~= false,
                StealNearest = Config.StealNearest == true,
                StealMode = tostring(Config.StealMode or "Priority"),
                PriorityList = copyStrList(Config.PriorityList or priorityList),
                MutationList = copyStrList(Config.MutationList or mutationList),
                AutoClone = Config.AutoClone ~= false,
                InvSteal = Config.InvSteal ~= false,
                InvStealAngle = tonumber(Config.InvStealAngle) or 220,
                InvStealDepth = tonumber(Config.InvStealDepth) or 10,
                InvStealDelay = tonumber(Config.InvStealDelay) or 0.5,
                WaveriderSpeed = 140,
                StealNearestKey = tostring((kb and kb.StealNearest) or Config.StealNearestKey or "T"),
                TpSettings = {
                    Tool = (Config.TpSettings and Config.TpSettings.Tool) or "Waverider",
                    CloneDelayVal = (Config.TpSettings and tonumber(Config.TpSettings.CloneDelayVal)) or 0.27,
                    GrabbleTPSpeed = (Config.TpSettings and tonumber(Config.TpSettings.GrabbleTPSpeed)) or 480,
                },
                Keybinds = kb,
                UiPos = type(_G.Elite_UiPos) == "table" and _G.Elite_UiPos or {},
            }
            _G.Elite_HubConfig = snap
            pcall(function()
                if type(writefile) == "function" then
                    writefile(FILE, Http:JSONEncode(snap))
                end
            end)
        end)
    end
    _G.Elite_SetPriorityList = function(list)
        rebuildPrioSet(copyStrList(list))
        _G.Elite_SaveConfig()
    end
    _G.Elite_SetMutationList = function(list)
        applyMutList(copyStrList(list))
        _G.Elite_SaveConfig()
    end
    _G.Elite_GetPriorityList = function()
        return copyStrList(Config.PriorityList or priorityList)
    end
    _G.Elite_GetMutationList = function()
        return copyStrList(Config.MutationList or mutationList)
    end
end
task.defer(function()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local set = _G.Elite_PrioSet
    if type(set) ~= "table" then return end
    for _, plot in ipairs(plots:GetChildren()) do
        for _, ch in ipairs(plot:GetChildren()) do
            if not ch:IsA("Model") then continue end
            if not (ch:FindFirstChild("RootPart") or ch:FindFirstChild("FakeRootPart")
                or ch:FindFirstChildWhichIsA("AnimationController", true)) then
                continue
            end
            if not _G.Elite_IsPrioName(ch.Name) then
                _G.Elite_Kill(ch)
            else
                pcall(_G.Elite_StripPetVfx, ch)
            end
        end
    end
end)

function instantClone()
    local c = LocalPlayer.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local cl = LocalPlayer.Backpack:FindFirstChild("Quantum Cloner") or c:FindFirstChild("Quantum Cloner")
    if not cl then return end
    pcall(function() h:UnequipTools() end)
    task.wait()
    if cl.Parent ~= c then h:EquipTool(cl); task.wait() end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local tf = pg and pg:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")
    if not tb then return end
    _G.isCloning = true
    cl:Activate()
    task.wait(0.05)
    tb.Visible = true
    pcall(function() firesignal(tb.MouseButton1Click) end)
    pcall(function() firesignal(tb.MouseButton1Up) end)
    pcall(function() firesignal(tb.Activated) end)
    task.delay(0.55, function() _G.isCloning = false end)
end

do
    local resetBusy = false
    local function instantReset()
        if resetBusy then return end
        local LP = LocalPlayer
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = humanoid and (humanoid.RootPart or character:FindFirstChild("HumanoidRootPart"))
        if not character or not humanoid or humanoid.Health <= 0 or not root then return end
        resetBusy = true
        _G.EliteInstantResetting = true
        _G.__Elite_Launching = true
        _G.AntiDieDisabled = true
        task.spawn(function()
            local camera = workspace.CurrentCamera
            local frozen = camera and camera.CFrame
            local oldType = camera and camera.CameraType
            local bindName = "EliteInstantResetCamera"
            local newCharacter
            local addedConnection
            local respawnConnection = LP.CharacterAdded:Connect(function(newChar)
                newCharacter = newChar
            end)
            local function hide(object)
                if object:IsA("BasePart") or object:IsA("Decal") then
                    object.LocalTransparencyModifier = 1
                end
            end
            pcall(function()
                RunService:UnbindFromRenderStep(bindName)
            end)
            pcall(function()
                camera.CameraType = Enum.CameraType.Scriptable
                RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value + 1, function()
                    if camera and frozen then
                        camera.CFrame = frozen
                    end
                end)
                for _, object in ipairs(character:GetDescendants()) do
                    hide(object)
                end
                addedConnection = character.DescendantAdded:Connect(hide)
                for _, object in ipairs(character:GetDescendants()) do
                    if object:IsA("BasePart") then
                        object.Anchored = false
                        object.CanCollide = false
                    elseif object.Name == "SeatWeld" then
                        object:Destroy()
                    end
                end
                pcall(function()
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    humanoid.BreakJointsOnDeath = true
                end)
            end)
            local started = os.clock()
            while not newCharacter and os.clock() - started < 0.4 and humanoid.Parent do
                pcall(function()
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                    humanoid.AutoRotate = true
                    humanoid.HipHeight = 1e30
                    root.Anchored = false
                    root.Velocity = Vector3.new(0, 50000, 0)
                end)
                RunService.Heartbeat:Wait()
            end
            if not newCharacter then
                local floor = workspace.FallenPartsDestroyHeight
                local voidStarted = os.clock()
                while not newCharacter and os.clock() - voidStarted < 0.6 and root.Parent do
                    pcall(function()
                        root.CFrame = CFrame.new(0, floor - 500, 0)
                        root.Velocity = Vector3.new(0, -50000, 0)
                    end)
                    RunService.Heartbeat:Wait()
                end
            end
            while not newCharacter and os.clock() - started < 6 do
                pcall(function()
                    humanoid.Health = 0
                    humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                end)
                pcall(function()
                    character:BreakJoints()
                end)
                task.wait(0.1)
            end
            pcall(function()
                respawnConnection:Disconnect()
            end)
            if addedConnection then
                pcall(function()
                    addedConnection:Disconnect()
                end)
            end
            pcall(function()
                RunService:UnbindFromRenderStep(bindName)
            end)
            pcall(function()
                camera.CameraType = oldType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or oldType
                local newHumanoid = newCharacter and (newCharacter:FindFirstChildOfClass("Humanoid") or newCharacter:WaitForChild("Humanoid", 5))
                if newHumanoid then
                    camera.CameraSubject = newHumanoid
                end
            end)
            _G.EliteInstantResetting = false
            _G.__Elite_Launching = false
            _G.AntiDieDisabled = false
            resetBusy = false
        end)
    end
    _G.Elite_InstantReset = instantReset
    _G.InstantReset = instantReset
end

do
    local LP = LocalPlayer
    local RS = ReplicatedStorage
    local CARPET_NAMES = {
        "Waverider",
        "Flying Carpet",
        "Witch's Broom",
        "Santa's Sleigh",
        "Cupid's Wings",
    }
    _G.Elite_TpTools = {
        "Waverider",
        "Flying Carpet",
        "Witch's Broom",
        "Santa's Sleigh",
        "Cupid's Wings",
    }
    local function findTool(name)
        local char = LP.Character
        local bp = LP:FindFirstChild("Backpack")
        return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    end
    local _eqCarpetName
    local function _carpetInChar(char)
        if not char then return nil end
        local prefer = (Config and Config.TpSettings and Config.TpSettings.Tool) or _G.Elite_CarpetTool or _eqCarpetName
        if type(prefer) == "string" then
            local t = char:FindFirstChild(prefer)
            if t then
                _eqCarpetName = prefer
                return prefer
            end
        end
        if _eqCarpetName then
            local t = char:FindFirstChild(_eqCarpetName)
            if t then return _eqCarpetName end
            _eqCarpetName = nil
        end
        for _, n in ipairs(CARPET_NAMES) do
            local t = char:FindFirstChild(n)
            if t then _eqCarpetName = n; return n end
        end
        return nil
    end
    local _carpetEngaging = false
    local function equipCarpet()
        if _G.isCloning then return nil end
        local char = LP.Character
        if _carpetEngaging and not _G.__Elite_GrappleFired then return _carpetInChar(char) end
        if not _G.__Elite_GrappleFired then return _carpetInChar(char) end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        local preferred = (Config and Config.TpSettings and Config.TpSettings.Tool) or _G.Elite_CarpetTool
        if type(preferred) == "string" then
            local pt = findTool(preferred)
            if pt and pt:IsA("Tool") then
                if pt.Parent ~= char then pcall(function() hum:EquipTool(pt) end) end
                _eqCarpetName = preferred
                return preferred
            end
        end
        local held = _carpetInChar(char)
        if held then return held end
        for _, n in ipairs(CARPET_NAMES) do
            local t = findTool(n)
            if t and t:IsA("Tool") then
                if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
                _eqCarpetName = n
                return n
            end
        end
        return nil
    end
    local _grappleNetRE
    local function _grappleRemote()
        if _grappleNetRE and _grappleNetRE.Parent then return _grappleNetRE end
        local r = _G.Elite_GrappleRemote and _G.Elite_GrappleRemote()
        if r then _grappleNetRE = r end
        return r
    end
    local function carpetEngage()
        if _G.isCloning then
            return nil
        end
        if _carpetEngaging then
            local _tw = os.clock()
            repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
            local c = LP.Character
            if c then
                local prefer = (Config and Config.TpSettings and Config.TpSettings.Tool) or _G.Elite_CarpetTool
                if type(prefer) == "string" then
                    local t = c:FindFirstChild(prefer)
                    if t and t:IsA("Tool") then
                        return prefer
                    end
                end
                for _, n in ipairs(CARPET_NAMES) do
                    local t = c:FindFirstChild(n)
                    if t and t:IsA("Tool") then
                        return n
                    end
                end
            end
            return nil
        end
        _carpetEngaging = true
        local cn
        local _fired = 0
        local _held = 0
        local _t0 = os.clock()
        while os.clock() - _t0 < 5 and _fired == 0 do
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local r = _grappleRemote()
            local g = findTool("Grapple Hook")
            if g and hum and char and g.Parent ~= char then
                pcall(function() hum:EquipTool(g) end)
                _held = 0
            elseif char and char:FindFirstChild("Grapple Hook") then
                _held += 1
            else
                _held = 0
            end
            local tool = char and char:FindFirstChild("Grapple Hook")
            if char and tool and r and _held >= 2 then
                pcall(function() r:FireServer(0.33) end)
                pcall(function() r:FireServer(0.33) end)
                pcall(function() r:FireServer(0.33) end)
                _fired = 1
                _G.__Elite_GrappleFired = true
                local tEq = os.clock() + 0.1
                while os.clock() < tEq do
                    RunService.Heartbeat:Wait()
                end
                cn = equipCarpet()
                break
            end
            RunService.Heartbeat:Wait()
        end
        if _fired > 0 and not (cn and LP.Character and LP.Character:FindFirstChild(cn)) then
            local _tc = os.clock()
            repeat
                cn = equipCarpet()
                local c = LP.Character
                if cn and c and c:FindFirstChild(cn) then
                    break
                end
                RunService.Heartbeat:Wait()
            until os.clock() - _tc > 0.4
        end
        _carpetEngaging = false
        return cn
    end
    _G.Elite_PulseGrapple = function()
        local r = _grappleRemote()
        if not r then return false end
        pcall(function() r:FireServer(0.33) end)
        pcall(function() r:FireServer(0.33) end)
        pcall(function() r:FireServer(0.33) end)
        _G.__Elite_GrappleFired = true
        return true
    end
    _G.Elite_FireGrapple = function()
        local r = _grappleRemote()
        if not r then return false end
        local held = 0
        local tw = os.clock()
        while os.clock() - tw < 1.5 and held < 2 do
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local g = findTool("Grapple Hook")
            if g and hum and char and g.Parent ~= char then
                pcall(function() hum:EquipTool(g) end)
                held = 0
            elseif char and char:FindFirstChild("Grapple Hook") then
                held += 1
            else
                held = 0
            end
            RunService.Heartbeat:Wait()
        end
        if not (LP.Character and LP.Character:FindFirstChild("Grapple Hook")) then
            return false
        end
        pcall(function() r:FireServer(0.33) end)
        pcall(function() r:FireServer(0.33) end)
        pcall(function() r:FireServer(0.33) end)
        _G.__Elite_GrappleFired = true
        return true
    end
    local function setCarpetTool(name)
        if type(name) ~= "string" or name == "" then return end
        if not Config.TpSettings then
            Config.TpSettings = {}
        end
        Config.TpSettings.Tool = name
        _G.Elite_CarpetTool = name
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
        _eqCarpetName = nil
        for i = #CARPET_NAMES, 1, -1 do
            if CARPET_NAMES[i] == name then
                table.remove(CARPET_NAMES, i)
            end
        end
        table.insert(CARPET_NAMES, 1, name)
        _G.Elite_CarpetNames = CARPET_NAMES
        if _G.Elite_OnCarpetTool then
            pcall(_G.Elite_OnCarpetTool, name)
        end
    end
    _G.Elite_SetCarpetTool = setCarpetTool
    if type(_G.Elite_CarpetTool) ~= "string" or _G.Elite_CarpetTool == "" then
        if type(_G.elite_CarpetTool) == "string" and _G.elite_CarpetTool ~= "" then
            _G.Elite_CarpetTool = _G.elite_CarpetTool
        end
    end
    if type(_G.Elite_CarpetTool) == "string" and _G.Elite_CarpetTool ~= "" then
        setCarpetTool(_G.Elite_CarpetTool)
    elseif Config and Config.TpSettings and type(Config.TpSettings.Tool) == "string" then
        setCarpetTool(Config.TpSettings.Tool)
    else
        setCarpetTool("Waverider")
    end
    _G.Elite_CarpetEngage = carpetEngage
    _G.Elite_EquipCarpet = equipCarpet
    _G.Elite_CarpetNames = CARPET_NAMES
    task.spawn(function()
        if _G.__Elite_GrappleFired then return end
        pcall(carpetEngage)
    end)
end
do
    function _G.Elite_Clamp(v)
        local cap = 480
        local n = tonumber(v) or (Config and Config.TpSettings and tonumber(Config.TpSettings.GrabbleTPSpeed)) or cap
        if n > cap then n = cap end
        return n
    end
end
if not _G.__Elite_SyncBoot then
do
local _eliteChans
local _synInst, _syncMod
local function _synNow()
    if _synInst and _synInst.Parent then return _synInst end
    local p = ReplicatedStorage:FindFirstChild("Packages")
    _synInst = p and p:FindFirstChild("Synchronizer")
    return _synInst
end
local function _tryEliteSync()
    if _eliteChans then return true end
    local syn = _synNow()
    if not syn then return false end
    if type(_syncMod) ~= "table" then
        local req = (getrenv and getrenv().require) or require
        local ok, mod = pcall(req, syn)
        if ok and type(mod) == "table" then _syncMod = mod end
    end
    local getFn = type(_syncMod) == "table" and rawget(_syncMod, "Get")
    local gf = getfenv or (debug and debug.getfenv)
    if type(getFn) ~= "function" or type(gf) ~= "function" then return false end
    local ok, env = pcall(gf, getFn)
    if not ok or type(env) ~= "table" then return false end
    local ch = rawget(env, "Channels")
    if type(ch) ~= "table" then return false end
    _eliteChans = ch
    return true
end
local function _chans()
    if _eliteChans then return _eliteChans end
    _tryEliteSync()
    return _eliteChans
end

_G.eliteSyncAll = function() return _chans() end
_G.eliteSyncGet = function(idx)
    local t = _chans()
    if not t or idx == nil then return nil end
    local ok, cd = pcall(rawget, t, idx)
    if ok and type(cd) == "table" then return cd end
    local ok2, cd2 = pcall(function() return t[idx] end)
    if ok2 and type(cd2) == "table" then return cd2 end
    return nil
end
_G.Elite_IsPlotChanKey = function(k)
    return type(k) == "string" and #k >= 32 and string.find(k, "-", 1, true) ~= nil
end
_G.elite_IsPlotChanKey = _G.Elite_IsPlotChanKey
_G.Elite_ChanGet = function(ch, key)
    if type(ch) ~= "table" or key == nil then return nil end
    local ct = rawget(ch, "CacheTable")
    if type(ct) ~= "table" then
        local okC, c2 = pcall(function() return ch.CacheTable end)
        if okC and type(c2) == "table" then ct = c2 end
    end
    if type(ct) ~= "table" then return nil end
    local v = rawget(ct, key)
    if v ~= nil then return v end
    local okV, v2 = pcall(function() return ct[key] end)
    if okV then return v2 end
    return nil
end
_G.EliteSyncAll = _G.eliteSyncAll
_G.EliteSyncGet = _G.eliteSyncGet
_G.eliteSyncAll = _G.eliteSyncAll
_G.eliteSyncGet = _G.eliteSyncGet
_G.Elite_GetPlotChannel = _G.eliteSyncGet
_G.EliteChanGet = _G.Elite_ChanGet
end
end
do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local eliteSpeed = { CARPET = 480 }
    if Config and Config.TpSettings then
        if tonumber(Config.TpSettings.GrabbleTPSpeed) then
            eliteSpeed.CARPET = math.min(480, tonumber(Config.TpSettings.GrabbleTPSpeed))
        end
    end
    local _routeVia = "ligne"
    do
        pcall(function()
            settings().Physics.AllowSleep = false
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
            settings().Physics.ThrottleAdjustTime = 0
        end)
        pcall(function()
            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(100000)
        end)
    end
    local function getPlotChannel(plotName)
        local channel
        pcall(function() channel = _G.eliteSyncGet(plotName) end)
        return channel
    end
    local function channelGet(channel, key)
        return _G.Elite_ChanGet(channel, key)
    end
    local _myPlotYes = setmetatable({}, { __mode = "k" })
    local function isMyPlot(channel)
        if not channel then return false end
        if _myPlotYes[channel] then return true end
        local owner = channelGet(channel, "Owner")
        if not owner then return false end
        local result = false
        pcall(function()
            if typeof(owner) == "Instance" and owner:IsA("Player") then
                result = owner.UserId == LP.UserId
            elseif type(owner) == "table" and owner.UserId then
                result = owner.UserId == LP.UserId
            elseif typeof(owner) == "Instance" then
                result = owner == LP
            end
        end)
        if result then _myPlotYes[channel] = true end
        return result
    end
    _G.Elite_IsMyPlot = isMyPlot
    local function isPlotUnlocked(plotName)
        local ok, res = pcall(function()
            local channel = getPlotChannel(plotName)
            if not channel then return false end
            return channelGet(channel, "BlockEndTimeFirstFloor") == nil
        end)
        return ok and (res == true)
    end
    local _podiumPos = setmetatable({}, { __mode = "k" })
    local _slotStr = {}
    local function _slotKey(slot)
        local s = _slotStr[slot]
        if s == nil then s = tostring(slot); _slotStr[slot] = s end
        return s
    end
    local function _cheapPos(inst)
        if not inst then return nil end
        if inst:IsA("BasePart") then return inst.Position end
        local pp = inst.PrimaryPart
        if pp then return pp.Position end
        local p = inst:FindFirstChildWhichIsA("BasePart")
        return p and p.Position or nil
    end
    local function _plotWorldPos(plot)
        local p = _cheapPos(plot)
        if p then return p end
        for _, n in ipairs({ "PlotSign", "MainRoot", "Base", "Floor", "Spawn" }) do
            p = _cheapPos(plot:FindFirstChild(n))
            if p then return p end
        end
        return nil
    end
    local function getPetPosition(plot, slot)
        if not plot then return nil end
        slot = _slotKey(slot)
        local sub = _podiumPos[plot]
        if sub == nil then sub = {}; _podiumPos[plot] = sub end
        local hit = sub[slot]
        if hit then return hit end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(slot)
        if not podium then
            for _, ch in ipairs(podiums:GetChildren()) do
                if tostring(ch.Name) == slot then podium = ch; break end
            end
        end
        if not podium then return nil end
        local base = podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local pos = _cheapPos(spawn) or _cheapPos(base) or _cheapPos(podium)
        if pos then
            sub[slot] = pos
            return pos
        end
        return nil
    end
    local function _findPlot(plotName)
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots or plotName == nil then return nil end
        local name = tostring(plotName)
        local plot = Plots:FindFirstChild(name)
        if plot then return plot end
        for _, pl in ipairs(Plots:GetChildren()) do
            if pl.Name == name or tostring(pl.Name) == name then return pl end
        end
        return nil
    end
    local function _ensurePetPos(p)
        if not p then return nil end
        if p.position then return p.position end
        local plot = _findPlot(p.plot)
        if not plot then return nil end
        local pos = getPetPosition(plot, p.slot)
        if pos then
            p.position = pos
            return pos
        end
        local hint = _plotWorldPos(plot)
        if hint then p.plotHint = hint end
        return nil
    end
    local _BLOCKING_MACHINE_TYPES = { Fuse=true, Duel=true, Trade=true, Crafting=true }
    local function _eliteIsFusing(animalData)
        if type(animalData) ~= "table" then return false end
        local m = animalData.Machine
        if type(m) ~= "table" then return false end
        return _BLOCKING_MACHINE_TYPES[m.Type] == true and m.Active == true
    end
    local _prioRank = {}
    local _MUT_RANK = {}
    local function _rebuildPrioRank()
        if type(table.clear) == "function" then
            table.clear(_prioRank)
        else
            for k in pairs(_prioRank) do _prioRank[k] = nil end
        end
        local list = (Config and Config.PriorityList) or priorityList
        if type(list) == "table" then
            for i, n in ipairs(list) do
                if type(n) == "string" then
                    _prioRank[string.lower(n)] = i
                end
            end
        end
        if type(table.clear) == "function" then
            table.clear(_MUT_RANK)
        else
            for k in pairs(_MUT_RANK) do _MUT_RANK[k] = nil end
        end
        local mlist = (Config and Config.MutationList) or mutationList
        if type(mlist) == "table" then
            for i, n in ipairs(mlist) do
                if type(n) == "string" then
                    local k = string.lower(n):gsub("[%s%-_]", "")
                    if k ~= "" then
                        _MUT_RANK[k] = i
                    end
                end
            end
        end
        if _MUT_RANK.yinyang then
            _MUT_RANK.yingyang = _MUT_RANK.yinyang
        end
        if _MUT_RANK.divine then
            _MUT_RANK.divin = _MUT_RANK.divine
        end
    end
    _rebuildPrioRank()
    _G.Elite_RebuildPrioRank = _rebuildPrioRank
    local function _nameKey(name)
        local base = _G.Elite_PrioBaseName and _G.Elite_PrioBaseName(name)
        if type(base) == "string" and base ~= "" then
            return base
        end
        return string.lower(tostring(name or ""))
    end
    local function _animalCount(list)
        local n = 0
        if type(list) ~= "table" then return 0 end
        for _ in pairs(list) do n += 1 end
        return n
    end
    local function _adMut(ad)
        if type(ad) ~= "table" then return "" end
        local m = ad.Mutation or ad.mutation or ad.Mut
        if type(m) == "table" then
            m = m.Name or m.Index or m.Type or m[1]
        end
        if type(m) ~= "string" then return "" end
        return m
    end
    local function _adTraits(ad)
        local out, seen = {}, {}
        local function add(name)
            name = tostring(name or "")
            if name == "" or name == "None" or seen[name] then return end
            seen[name] = true
            out[#out + 1] = name
        end
        if type(ad) ~= "table" then return out end
        local t = ad.Traits or ad.traits
        if type(t) == "string" then
            for part in t:gmatch("[^,]+") do
                add(part:gsub("^%s+", ""):gsub("%s+$", ""))
            end
        elseif type(t) == "table" then
            for key, item in pairs(t) do
                if type(item) == "string" then
                    add(item)
                elseif item == true and type(key) == "string" then
                    add(key)
                elseif type(item) == "table" then
                    add(item.Name or item.name or item.Trait or item.Id or item[1])
                end
            end
        end
        return out
    end
    local _AD, _MD, _TD
    local MUT_ICONS, TRAIT_ICONS = {}, {}
    task.spawn(function()
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local d = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 8)
            if not d then return end
            local function req(n)
                local m = d:FindFirstChild(n)
                if not m then return nil end
                local ok, v = pcall(require, m)
                return ok and type(v) == "table" and v or nil
            end
            _AD, _MD, _TD = req("Animals"), req("Mutations"), req("Traits")
            if _MD then
                for name, data in pairs(_MD) do
                    if type(data) == "table" and data.Icon then
                        MUT_ICONS[name] = data.Icon
                    end
                end
            end
            if _TD then
                for name, data in pairs(_TD) do
                    if type(data) == "table" and data.Icon then
                        TRAIT_ICONS[name] = data.Icon
                    end
                end
            end
        end)
    end)
    _G.Elite_MutIcons = MUT_ICONS
    _G.Elite_TraitIcons = TRAIT_ICONS
    local function _iconAsset(v)
        if v == nil then return nil end
        local s = tostring(v)
        if s == "" then return nil end
        if s:match("^%d+$") then return "rbxassetid://" .. s end
        return s
    end
    local function _petGen(index, mutation, traits)
        if type(_AD) ~= "table" then return 0 end
        local info = _AD[index]
        if type(info) ~= "table" or type(info.Generation) ~= "number" then return 0 end
        local mult = 1
        if mutation and mutation ~= "" and mutation ~= "None" and type(_MD) == "table" then
            local md = _MD[mutation]
            if type(md) == "table" and type(md.Modifier) == "number" then
                mult += md.Modifier
            end
        end
        if type(_TD) == "table" then
            for i = 1, #traits do
                local td = _TD[traits[i]]
                if type(td) == "table" and type(td.MultiplierModifier) == "number" then
                    mult += td.MultiplierModifier
                end
            end
        end
        return info.Generation * mult
    end
    local function _plotOwnerName(ch)
        local owner
        pcall(function() owner = channelGet(ch, "Owner") end)
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            return owner.Name
        end
        if type(owner) == "number" then
            local pl = Players:GetPlayerByUserId(owner)
            return pl and pl.Name or nil
        end
        if type(owner) == "string" and owner ~= "" then
            return owner
        end
        return nil
    end
    local function _mutRank(m)
        local k = tostring(m or ""):lower():gsub("[%s%-_]", "")
        if k == "" or k == "none" or k == "normal" then
            return _MUT_RANK.normal or 99
        end
        return _MUT_RANK[k] or 99
    end
    local function _bestPrioOnBase(plotName, animalList)
        local best, bestRank, bestMut = nil, math.huge, 99
        if type(animalList) ~= "table" then return nil end
        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local rank = _prioRank[_nameKey(animalName)]
            if not rank then continue end
            if _eliteIsFusing(animalData) then continue end
            local mut = _adMut(animalData)
            local mutRank = _mutRank(mut)
            local same = best and _nameKey(animalName) == _nameKey(best.index)
            local take = false
            if not best then
                take = true
            elseif rank < bestRank then
                take = true
            elseif same and mutRank < bestMut then
                take = true
            end
            if take then
                bestRank = rank
                bestMut = mutRank
                best = {
                    name = animalName, index = animalName, position = nil,
                    plotHint = nil, mutation = mut,
                    plot = tostring(plotName), slot = tostring(slot),
                }
            end
        end
        return best
    end
    local _noPrioN, _noPrioSt = {}, {}
    local _prioSlots, _podHook, _myPodNuke = {}, {}, {}
    local function nukePlotPodiums(plot)
        if not (plot and plot.Parent) then return end
        if _myPodNuke[plot] then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                local kids = pods:GetChildren()
                for i = 1, #kids do _G.Elite_Kill(kids[i]) end
            end
            return
        end
        _myPodNuke[plot] = true
        local function wipe(folder)
            if not folder then return end
            local kids = folder:GetChildren()
            for i = 1, #kids do _G.Elite_Kill(kids[i]) end
            folder.ChildAdded:Connect(function(ch)
                _G.Elite_Kill(ch)
            end)
        end
        wipe(plot:FindFirstChild("AnimalPodiums"))
        plot.ChildAdded:Connect(function(ch)
            if ch and ch.Name == "AnimalPodiums" then wipe(ch) end
        end)
    end
    local function stripNonPrioPodiums(plot)
        if not (plot and plot.Parent) then return end
        if _G.__Elite_MyPlot and plot.Name == _G.__Elite_MyPlot then
            nukePlotPodiums(plot)
            return
        end
        local set = _G.Elite_PrioSet
        if type(set) ~= "table" then return end
        local ch
        pcall(function() ch = _G.eliteSyncGet(plot.Name) end)
        if ch and isMyPlot(ch) then
            _G.__Elite_MyPlot = plot.Name
            nukePlotPodiums(plot)
            return
        end
        local list = ch and channelGet(ch, "AnimalList")
        if type(list) ~= "table" then return end
        local keepSlots = {}
        for slot, ad in pairs(list) do
            if type(ad) == "table" and type(ad.Index) == "string"
                and _G.Elite_IsPrioName(ad.Index) then
                keepSlots[tostring(slot)] = true
            end
        end
        if not next(keepSlots) then return end
        _prioSlots[plot.Name] = keepSlots
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return end
        local kids = pods:GetChildren()
        for i = 1, #kids do
            local slotInst = kids[i]
            if not keepSlots[tostring(slotInst.Name)] then
                _G.Elite_Kill(slotInst)
            end
        end
        if not _podHook[plot] then
            _podHook[plot] = true
            pods.ChildAdded:Connect(function(slotInst)
                local ks = _prioSlots[plot.Name]
                if slotInst and ks and not ks[tostring(slotInst.Name)] then
                    _G.Elite_Kill(slotInst)
                end
            end)
        end
    end
    _G.Elite_NukePlotPodiums = nukePlotPodiums
    _G.Elite_StripNonPrioPodiums = stripNonPrioPodiums
    local function stripNoPrioPlots()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        local keep = _G.__Elite_KeepPlot
        for _, plot in ipairs(plots:GetChildren()) do
            if plot.Name == _G.__Elite_MyPlot then
                pcall(nukePlotPodiums, plot)
                continue
            end
            if keep and plot.Name == keep then
                pcall(stripNonPrioPodiums, plot)
                continue
            end
            local ch
            pcall(function() ch = _G.eliteSyncGet(plot.Name) end)
            if ch and isMyPlot(ch) then
                _G.__Elite_MyPlot = plot.Name
                pcall(nukePlotPodiums, plot)
                continue
            end
            local list = ch and channelGet(ch, "AnimalList")
            if type(list) ~= "table" then continue end
            local n, hasPrio = 0, false
            for _, ad in pairs(list) do
                n += 1
                if type(ad) == "table" and type(ad.Index) == "string"
                    and _G.Elite_IsPrioName(ad.Index) then
                    hasPrio = true
                end
            end
            if not hasPrio then
                for _, c in ipairs(plot:GetChildren()) do
                    if c:IsA("Model") and (c:FindFirstChild("RootPart") or c:FindFirstChild("FakeRootPart"))
                        and _G.Elite_IsPrioName(c.Name) then
                        hasPrio = true
                        break
                    end
                end
            end
            if hasPrio then
                _noPrioN[plot.Name] = nil
                _noPrioSt[plot.Name] = nil
                if _G.__Elite_StrippedPlots then _G.__Elite_StrippedPlots[plot.Name] = nil end
                pcall(stripNonPrioPodiums, plot)
                continue
            end
            local key = plot.Name
            if n == (_noPrioN[key] or -1) then
                _noPrioSt[key] = (_noPrioSt[key] or 0) + 1
            else
                _noPrioN[key] = n
                _noPrioSt[key] = 0
            end
            if (_noPrioSt[key] or 0) >= 1 then
                if _G.__Elite_MyPlot and plot.Name ~= _G.__Elite_MyPlot
                    and not (keep and plot.Name == keep) then
                    _G.Elite_Kill(plot)
                end
            end
        end
    end
    local function scanAllPets()
        local pets = {}
        local isKey = _G.Elite_IsPlotChanKey
        local best, bestPlot
        local reg = _G.eliteSyncAll and _G.eliteSyncAll()
        if type(reg) == "table" then
            for name, ch in next, reg do
                if not (isKey and isKey(name)) then continue end
                if not ch then continue end
                if isMyPlot(ch) then
                    _G.__Elite_MyPlot = tostring(name)
                    local plots = workspace:FindFirstChild("Plots")
                    local mine = plots and plots:FindFirstChild(tostring(name))
                    if mine then pcall(nukePlotPodiums, mine) end
                    continue
                end
                local cand = _bestPrioOnBase(name, channelGet(ch, "AnimalList"))
                if cand then
                    best, bestPlot = cand, tostring(name)
                    break
                end
            end
        end
        if _G.__Elite_StripDone and not _G.__Elite_VelFlying then
            pcall(stripNoPrioPlots)
        end
        if best then
            pets[1] = best
            pcall(_G.Elite_LockPrioPlot, bestPlot)
        end
        return pets
    end
    _G.Elite_ScanPets = scanAllPets
    task.spawn(function()
        local t0 = os.clock()
        while os.clock() - t0 < 20 do
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    local ch
                    pcall(function() ch = _G.eliteSyncGet(plot.Name) end)
                    if ch and isMyPlot(ch) then
                        _G.__Elite_MyPlot = plot.Name
                        pcall(nukePlotPodiums, plot)
                        if _G.__Elite_KeepPlot then
                            pcall(_G.Elite_LockPrioPlot, _G.__Elite_KeepPlot)
                        end
                        return
                    end
                end
            end
            task.wait()
        end
    end)
    local UPPER = {
        B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
        C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
        D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
    }
    local LOWER = {
        B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
        C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
        D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
    }
    local UPPER_Y_THRESHOLD = 7
    local TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
    local TALL_OFFSET = 3
    local BASES_LOW = {
        [1]=Vector3.new(-476.52,-2,220.94),[2]=Vector3.new(-476.52,-2,113.77),
        [3]=Vector3.new(-476.52,-2,6.18),[4]=Vector3.new(-476.52,-2,-101.07),
        [5]=Vector3.new(-342.66,-2,221.45),[6]=Vector3.new(-342.66,-2,113.41),
        [7]=Vector3.new(-342.66,-2,6.25),[8]=Vector3.new(-342.66,-2,-99.73),
    }
    local BASES_HIGH = {
        [1]=Vector3.new(-479.51,18,220.94),[2]=Vector3.new(-479.51,18,113.77),
        [3]=Vector3.new(-479.51,18,6.18),[4]=Vector3.new(-479.51,18,-101.07),
        [5]=Vector3.new(-339.48,18,221.45),[6]=Vector3.new(-339.48,18,113.41),
        [7]=Vector3.new(-339.48,18,6.25),[8]=Vector3.new(-339.48,18,-99.73),
    }

    local _PLOT_BOXES = {
        [1] = { minX = -525.25, maxX = -479.75, minY = -10.10, maxY = 43.90, minZ = 196.61, maxZ = 242.11 },
        [2] = { minX = -525.25, maxX = -479.75, minY = -10.10, maxY = 43.90, minZ = 89.61, maxZ = 135.11 },
        [3] = { minX = -525.25, maxX = -479.75, minY = -10.10, maxY = 43.90, minZ = -17.39, maxZ = 28.11 },
        [4] = { minX = -525.25, maxX = -479.75, minY = -10.10, maxY = 43.90, minZ = -124.39, maxZ = -78.89 },
        [5] = { minX = -339.44, maxX = -293.94, minY = -10.10, maxY = 43.90, minZ = 199.11, maxZ = 244.61 },
        [6] = { minX = -339.44, maxX = -293.94, minY = -10.10, maxY = 43.90, minZ = 92.11, maxZ = 137.61 },
        [7] = { minX = -339.44, maxX = -293.94, minY = -10.10, maxY = 43.90, minZ = -14.89, maxZ = 30.61 },
        [8] = { minX = -339.44, maxX = -293.94, minY = -10.10, maxY = 43.90, minZ = -121.89, maxZ = -76.39 },
    }
    local _PLOT_PAD = 8
    local _SHOP_PAD = 4
    local function _segHitsPlotPad(a, b, k)
        local box = _PLOT_BOXES[k]
        local minX, maxX = box.minX - _PLOT_PAD, box.maxX + _PLOT_PAD
        local minZ, maxZ = box.minZ - _PLOT_PAD, box.maxZ + _PLOT_PAD
        local dx, dz = b.X - a.X, b.Z - a.Z
        local t0, t1 = 0, 1
        local function clip(p, q)
            if p > -1e-12 and p < 1e-12 then
                return q >= 0
            end
            local r = q / p
            if p < 0 then
                if r > t1 then return false end
                if r > t0 then t0 = r end
            else
                if r < t0 then return false end
                if r < t1 then t1 = r end
            end
            return true
        end
        if not clip(-dx, a.X - minX) then return false end
        if not clip(dx, maxX - a.X) then return false end
        if not clip(-dz, a.Z - minZ) then return false end
        if not clip(dz, maxZ - a.Z) then return false end
        return true
    end
    local FRONT_Y_LOW = -3.048217
    local FRONT_Y_HIGH = 16.850713
    local COLUMN_SPLIT_X = -410
    local FRONT_Z_CLAMP = 8
    local SIDE_NEAR_Z = 45
    local function getClosestBaseIdx(pos)
        local closest, dist = 1, math.huge
        for i = 1, 8 do
            local b = BASES_LOW[i]
            local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
            if d < dist then dist = d; closest = i end
        end
        return closest
    end
    local function buildFrontCandidate(idx, isUpper, playerZ)
        local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
        local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
        local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
        local coord = Vector3.new(base.X, frontY, frontZ)
        local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
        return coord, faceDir
    end
    local function plotSides(coordTable, idx)
        local base = BASES_LOW[idx]
        local isWest = idx <= 4
        local out = {}
        for _, coords in pairs(coordTable) do
            for _, data in ipairs(coords) do
                if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
                   and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                    out[#out + 1] = data
                end
            end
        end
        return out
    end
    local function cloneDestCandidates(hrpPos, petPos, petName)
        local adjY = petPos.Y
        if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
        local coordTable = adjY > UPPER_Y_THRESHOLD and UPPER or LOWER
        local isUpper = (coordTable == UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrpPos.Z)
        local list = { { coord = frontCoord, face = frontFace } }
        for _, d in ipairs(plotSides(coordTable, idx)) do
            local face = d.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
            list[#list + 1] = { coord = d.coord, face = face }
        end
        return list
    end
    local function resolveCloneDest(hrpPos, petPos, petName)
        local list = cloneDestCandidates(hrpPos, petPos, petName)
        local bestCoord, bestFace = list[1].coord, list[1].face
        local bestDist = (hrpPos - bestCoord).Magnitude
        for i = 2, #list do
            local dd = (hrpPos - list[i].coord).Magnitude
            if dd < bestDist then
                bestDist = dd
                bestCoord = list[i].coord
                bestFace = list[i].face
            end
        end
        return bestCoord, bestFace
    end
    local _PUSH_SKIP = {
        Floor = true, Spawn = true, MainRoot = true, AnimalTarget = true,
        Multiplier = true, DeliveryHitbox = true, StealHitbox = true,
        SecondFloor = true, ThirdFloor = true, Slope = true, Roof = true,
        eliteHubLandPlatform = true,
        __HITBOX = true,
    }
    local _wallLat = { 0, 5, -5, 14, -14 }
    local _wallRp = RaycastParams.new()
    _wallRp.IgnoreWater = true
    _wallRp.FilterType = Enum.RaycastFilterType.Exclude
    local function wallFrontPos(destPos, facingDir)
        if not destPos or not facingDir or facingDir.Magnitude < 0.1 then return destPos, "dest" end
        local axis = facingDir.Unit
        local perp = Vector3.new(-axis.Z, 0, axis.X)
        _wallRp.FilterDescendantsInstances = { LP.Character }
        local bestAlong, bestName = nil, "dest"
        local function considerAlong(along, off, name, maxOff)
            if off > (maxOff or 16) or along < -2 or along > 28 then return end
            if bestAlong == nil or along < bestAlong then
                bestAlong = along
                bestName = name
            end
        end
        local function considerHit(res)
            if not res then return end
            local n = res.Instance and res.Instance.Name or ""
            if _PUSH_SKIP[n] then return end
            if math.abs(res.Normal.Y) >= 0.5 then return end
            local along = (res.Position - destPos):Dot(axis)
            local off = (res.Position - destPos - axis * along).Magnitude
            considerAlong(along, off, n, 14)
        end
        for _, lat in ipairs(_wallLat) do
            local origin = destPos - axis * 12 + perp * lat + Vector3.new(0, 2, 0)
            considerHit(workspace:Raycast(origin, axis * 40, _wallRp))
        end
        if bestAlong == nil then return destPos, "dest" end
        local stick = destPos + axis * bestAlong
        stick = Vector3.new(stick.X, destPos.Y, stick.Z)
        return stick, bestName
    end
    local function _antiFall(hrp, destPos)
        local char = hrp and hrp.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local plat
        local stopped = false
        local conn
        plat = Instance.new("Part")
        plat.Name = "eliteHubLandPlatform"
        plat.Size = Vector3.new(14, 1, 14)
        plat.Position = Vector3.new(destPos.X, destPos.Y - 3.15, destPos.Z)
        plat.Anchored = true
        plat.CanCollide = true
        plat.Transparency = 1
        plat.Parent = workspace
        if hum then
            pcall(function()
                hum.Sit = false
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        local tEnd = os.clock() + 1.1
        local function stop(killPlatNow)
            if stopped then return end
            stopped = true
            if conn then conn:Disconnect(); conn = nil end
            if hum and hum.Parent then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                end)
            end
            if killPlatNow then
                if plat and plat.Parent then plat:Destroy() end
            else
                task.delay(5, function()
                    if plat and plat.Parent then plat:Destroy() end
                end)
            end
        end
        conn = RunService.Heartbeat:Connect(function()
            if stopped then return end
            if os.clock() > tEnd then
                stop(false)
                return
            end
            local h = (hrp and hrp.Parent) and hrp or nil
            if h then
                local v = h.AssemblyLinearVelocity
                if v.Y < -2 then
                    h.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
                end
                h.AssemblyAngularVelocity = Vector3.zero
            end
            if hum and hum.Parent then
                pcall(function()
                    hum.Sit = false
                    local st = hum:GetState()
                    if st == Enum.HumanoidStateType.FallingDown
                        or st == Enum.HumanoidStateType.Ragdoll
                        or st == Enum.HumanoidStateType.GettingUp then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
        end)
        return stop
    end
    local function vZero(hrp)
        if not hrp then return end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            hrp.Velocity = Vector3.zero
        end)
    end
    local function velMoveThrough(hrp, waypoints, speedOverride, rawSpeed)
        if not hrp or not hrp.Parent or #waypoints == 0 then
            return
        end
        local landAt = waypoints[#waypoints]
        _G.__Elite_VelFlying = true
        _G.__Elite_FlyHrp = hrp
        local _runSpeed
        if rawSpeed and tonumber(speedOverride) then
            _runSpeed = tonumber(speedOverride)
        else
            _runSpeed = _G.Elite_Clamp(speedOverride or eliteSpeed.CARPET)
        end
        hrp.Anchored = false
        local names = _G.Elite_CarpetNames or {
            "Waverider", "Flying Carpet", "Witch's Broom", "Santa's Sleigh", "Cupid's Wings",
        }
        local function carpetHeld()
            local c = hrp.Parent
            if not c then return false end
            for i = 1, #names do
                if c:FindFirstChild(names[i]) then return true end
            end
            return false
        end
        pcall(function()
            if _G.Elite_EquipCarpet then _G.Elite_EquipCarpet() end
        end)
        pcall(function()
            if _G.Elite_PulseGrapple then _G.Elite_PulseGrapple() end
        end)
        local char = hrp.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        pcall(function()
            local a = char and char:FindFirstChild("Animate")
            if a then a.Disabled = true end
        end)
        local _jp
        local function releaseFall()
            if not (hum and hum.Parent) then return end
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                if _jp ~= nil then hum.JumpPower = _jp end
            end)
        end
        if hum then
            pcall(function()
                _jp = hum.JumpPower
                hum.PlatformStand = false
                hum.Sit = false
                hum.UseJumpPower = true
                if (hum.JumpPower or 0) < 50 then
                    hum.JumpPower = 50
                end
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hum.Jump = true
            end)
        end
        local pts = { hrp.Position }
        for i = 1, #waypoints do
            local p = waypoints[i]
            if (p - pts[#pts]).Magnitude > 0.25 then
                pts[#pts + 1] = p
            end
        end
        local n = #pts
        if n < 2 then
            vZero(hrp)
            releaseFall()
            _G.__Elite_VelFlying = false
            _G.__Elite_FlyHrp = nil
            return
        end
        local wpIdx = 2
        local done = false
        local lastVel = Vector3.zero
        local lastClock = 0
        local takeoffY = pts[1].Y
        local function finish()
            if done then return end
            done = true
            _G.__Elite_FlyPre = nil
            _G.__Elite_FlyHb = nil
            releaseFall()
            pcall(function()
                if hrp and hrp.Parent then hrp.CanCollide = true end
            end)
        end
        pcall(function()
            hrp.CanCollide = false
        end)
        local function setALV(dir, dtHint)
            if not (hrp and hrp.Parent) or dir.Magnitude < 0.1 then return end
            local now = os.clock()
            local step = 0.016
            if lastClock > 0 then
                step = now - lastClock
            elseif tonumber(dtHint) then
                step = tonumber(dtHint)
            end
            lastClock = now
            if step > 0.05 then
                hrp.AssemblyAngularVelocity = Vector3.zero
                return
            end
            local spd = _runSpeed
            if step > 0.018 then
                local cap = 8 / step
                if spd > cap then spd = cap end
            end
            local t = dir.Unit
            if (hrp.Position.Y - takeoffY) < 3 then
                local jy = 50 / math.max(spd, 1)
                if t.Y < jy then
                    t = Vector3.new(t.X, jy, t.Z)
                    if t.Magnitude > 0.1 then t = t.Unit end
                end
            end
            lastVel = t * spd
            hrp.AssemblyLinearVelocity = lastVel
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        local function stepLine(dtHint)
            if wpIdx > n then
                finish()
                return
            end
            local A = pts[wpIdx - 1] or hrp.Position
            local B = pts[wpIdx]
            if not B then
                finish()
                return
            end
            local AB = B - A
            local len = AB.Magnitude
            if len < 0.05 then
                if wpIdx >= n then
                    finish()
                    return
                end
                wpIdx += 1
                B = pts[wpIdx]
                AB = B - hrp.Position
                len = AB.Magnitude
                if len < 0.05 then return end
            end
            local dir = AB.Unit
            local along = (hrp.Position - A):Dot(dir)
            local toB = B - hrp.Position
            if wpIdx >= n then
                if along >= len - 4 or toB.Magnitude < 4 then
                    finish()
                    return
                end
            elseif along >= len - 1 or dir:Dot(toB) <= 0 then
                wpIdx += 1
                local nxt = pts[wpIdx] - hrp.Position
                if nxt.Magnitude > 0.05 then
                    dir = nxt.Unit
                end
            end
            setALV(dir, dtHint)
        end
        _G.__Elite_FlyPre = function(dt)
            if done or not hrp or not hrp.Parent then
                _G.__Elite_FlyPre = nil
                return
            end
            if hum and hum.Parent and (hrp.Position.Y - takeoffY) < 3 then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    hum.Jump = true
                end)
            end
            stepLine(dt)
        end
        _G.__Elite_FlyHb = function()
            if done or not hrp or not hrp.Parent then
                _G.__Elite_FlyHb = nil
                return
            end
            if not carpetHeld() then
                pcall(function()
                    if _G.Elite_EquipCarpet then _G.Elite_EquipCarpet() end
                end)
            end
        end
        local total = 0
        for i = 2, n do
            total = total + (pts[i] - pts[i - 1]).Magnitude
        end
        local timeout = total / math.max(_runSpeed, 1) + 2
        local tVel = os.clock()
        while not done and (os.clock() - tVel) < timeout do
            RunService.Heartbeat:Wait()
        end
        finish()
        if hrp and hrp.Parent then
            pcall(function() hrp.CanCollide = true end)
            local dest = landAt or pts[n]
            if dest and (hrp.Position - dest).Magnitude <= 12 then
                hrp.CFrame = CFrame.new(dest)
            end
            vZero(hrp)
        end
        _G.__Elite_VelFlying = false
        _G.__Elite_FlyHrp = nil
        _G.__Elite_FlyPre = nil
        _G.__Elite_FlyHb = nil
    end
    local _MID_BOXES = {
        { minX = -450.30, maxX = -435.20, minY = -11.40, maxY = 2.70, minZ = 29.05, maxZ = 51.30 },
        { minX = -445.66, maxX = -434.56, minY = -10.12, maxY = 3.80, minZ = 54.67, maxZ = 67.69 },
        { minX = -385.76, maxX = -367.76, minY = -10.00, maxY = 5.84, minZ = 56.26, maxZ = 81.26 },
        { minX = -443.55, maxX = -434.52, minY = -11.40, maxY = 6.42, minZ = 70.83, maxZ = 87.11 },
        { minX = -440.83, maxX = -438.98, minY = -9.50, maxY = -1.98, minZ = 36.37, maxZ = 43.65 },
        { minX = -386.35, maxX = -371.25, minY = -11.40, maxY = 2.70, minZ = 29.10, maxZ = 51.35 },
    }
    local function _segmentHitsShop(a, b)
        local function inside(p)
            for i = 1, #_MID_BOXES do
                local box = _MID_BOXES[i]
                if p.X >= box.minX - _SHOP_PAD and p.X <= box.maxX + _SHOP_PAD
                    and p.Y >= box.minY and p.Y <= box.maxY
                    and p.Z >= box.minZ - _SHOP_PAD and p.Z <= box.maxZ + _SHOP_PAD then
                    return true
                end
            end
            return false
        end
        local mag = (b - a).Magnitude
        if mag < 0.05 then return inside(a) end
        local n = math.max(6, math.floor(mag / 3))
        for i = 0, n do
            if inside(a + (b - a) * (i / n)) then return true end
        end
        return false
    end
    local function _clearWide(a, b, ignA, ignB)
        if _segmentHitsShop(a, b) then return false end
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB and _segHitsPlotPad(a, b, k) then return false end
        end
        return true
    end
    local function _len(pts)
        local s, prev = 0, pts[1]
        for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
        return s
    end
    local function _nearestBase(p)
        for i = 1, 8 do
            local box = _PLOT_BOXES[i]
            if p.X >= box.minX and p.X <= box.maxX and p.Z >= box.minZ and p.Z <= box.maxZ then
                return i
            end
        end
        local bi, bd = nil, math.huge
        for i = 1, 8 do
            local b = BASES_LOW[i]
            local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
            if d < bd then bd = d; bi = i end
        end
        if bd > 90 * 90 then return nil end
        return bi
    end
    local function _ptHitsBase(px, pz, k, ignB)
        if k == ignB then return false end
        local box = _PLOT_BOXES[k]
        return px >= (box.minX - _PLOT_PAD) and px <= (box.maxX + _PLOT_PAD)
            and pz >= (box.minZ - _PLOT_PAD) and pz <= (box.maxZ + _PLOT_PAD)
    end
    local function _segmentHitsOtherBase(a, b, ignA, ignB)
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB and _segHitsPlotPad(a, b, k) then return true end
        end
        return false
    end
    local function _canSeeSide(p, dest, iTo)
        if not iTo then iTo = getClosestBaseIdx(dest) end
        if (dest - p).Magnitude < 6 then return true end
        if iTo and _ptHitsBase(p.X, p.Z, iTo, nil) then return false end
        if _segmentHitsOtherBase(p, dest, nil, iTo) then return false end
        if (dest - p).Magnitude >= 6 and _segmentHitsShop(p, dest) then return false end
        return true
    end
    local _GCELL = 4
    local _GX0, _GZ0 = -540, -150
    local _GNX = 67
    local _GNZ = 105
    local _GSHOP = table.create(_GNX * _GNZ, false)
    local _GPLOT = {}
    for k = 1, 8 do
        _GPLOT[k] = table.create(_GNX * _GNZ, false)
    end
    do
        local shopPad = _SHOP_PAD
        for iz = 0, _GNZ - 1 do
            local z0 = _GZ0 + iz * _GCELL
            local z1 = z0 + _GCELL
            for ix = 0, _GNX - 1 do
                local x0 = _GX0 + ix * _GCELL
                local x1 = x0 + _GCELL
                local idx = iz * _GNX + ix + 1
                for s = 1, #_MID_BOXES do
                    local b = _MID_BOXES[s]
                    if x1 > (b.minX - shopPad) and x0 < (b.maxX + shopPad)
                        and z1 > (b.minZ - shopPad) and z0 < (b.maxZ + shopPad) then
                        _GSHOP[idx] = true
                        break
                    end
                end
                for k = 1, 8 do
                    local b = _PLOT_BOXES[k]
                    local p = _PLOT_PAD
                    if x1 > (b.minX - p) and x0 < (b.maxX + p)
                        and z1 > (b.minZ - p) and z0 < (b.maxZ + p) then
                        _GPLOT[k][idx] = true
                    end
                end
            end
        end
    end
    local function _gWalk(ix, iz, ignA, ignB)
        if ix < 0 or iz < 0 or ix >= _GNX or iz >= _GNZ then return false end
        local idx = iz * _GNX + ix + 1
        if _GSHOP[idx] then return false end
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB and _GPLOT[k][idx] then return false end
        end
        return true
    end
    local function _gNear(ix, iz, ignA, ignB)
        if _gWalk(ix, iz, ignA, ignB) then return ix, iz end
        for r = 1, 12 do
            for dz = -r, r do
                for dx = -r, r do
                    if math.abs(dx) == r or math.abs(dz) == r then
                        local x, z = ix + dx, iz + dz
                        if _gWalk(x, z, ignA, ignB) then return x, z end
                    end
                end
            end
        end
        return nil
    end
    local function _routeLen(pts)
        if not pts or #pts < 2 then return math.huge end
        return _len(pts)
    end
    local function _pullPath(pts, y, iFrom, iTo)
        if not pts or #pts < 3 then return pts end
        local out = { pts[1] }
        local i = 1
        while i < #pts do
            local far = i + 1
            for j = i + 2, #pts do
                local a = Vector3.new(pts[i].X, y, pts[i].Z)
                local b = Vector3.new(pts[j].X, y, pts[j].Z)
                if _clearWide(a, b, iFrom, iTo) then
                    far = j
                end
            end
            out[#out + 1] = pts[far]
            i = far
        end
        if #out >= 3 then
            local simp = { out[1] }
            for k = 2, #out - 1 do
                local a, b, c = out[k - 1], out[k], out[k + 1]
                local v1, v2 = b - a, c - b
                if not (v1.Magnitude > 0.5 and v2.Magnitude > 0.5
                    and v1.Unit:Dot(v2.Unit) >= 0.995) then
                    if (b - simp[#simp]).Magnitude > 0.5 then
                        simp[#simp + 1] = b
                    end
                end
            end
            local last = out[#out]
            if (last - simp[#simp]).Magnitude > 0.5 then
                simp[#simp + 1] = last
            end
            out = simp
        end
        return out
    end
    local function _astarXZ(fromPos, toPos, y, ignA, ignB)
        local sx = math.floor((fromPos.X - _GX0) / _GCELL)
        local sz = math.floor((fromPos.Z - _GZ0) / _GCELL)
        local gx = math.floor((toPos.X - _GX0) / _GCELL)
        local gz = math.floor((toPos.Z - _GZ0) / _GCELL)
        sx, sz = _gNear(sx, sz, ignA, ignB)
        gx, gz = _gNear(gx, gz, ignA, ignB)
        if not sx or not gx then return nil end
        local start = sz * _GNX + sx + 1
        local goal = gz * _GNX + gx + 1
        local function h(ix, iz)
            local dx, dz = math.abs(ix - gx), math.abs(iz - gz)
            local m = dx < dz and dx or dz
            return (dx + dz - m) + m * 1.41421356
        end
        local gScore = {}
        local came = {}
        local closed = {}
        local hf, hi = {}, {}
        local function push(f, idx)
            local i = #hf + 1
            hf[i], hi[i] = f, idx
            while i > 1 do
                local p = math.floor(i * 0.5)
                if hf[p] <= hf[i] then break end
                hf[p], hf[i] = hf[i], hf[p]
                hi[p], hi[i] = hi[i], hi[p]
                i = p
            end
        end
        local function pop()
            local n = #hf
            if n == 0 then return nil end
            local idx = hi[1]
            hf[1], hi[1] = hf[n], hi[n]
            hf[n], hi[n] = nil, nil
            local i = 1
            n = n - 1
            while true do
                local l, r, s = i * 2, i * 2 + 1, i
                if l <= n and hf[l] < hf[s] then s = l end
                if r <= n and hf[r] < hf[s] then s = r end
                if s == i then break end
                hf[i], hf[s] = hf[s], hf[i]
                hi[i], hi[s] = hi[s], hi[i]
                i = s
            end
            return idx
        end
        gScore[start] = 0
        push(h(sx, sz), start)
        local found = false
        local nVisit = 0
        while #hf > 0 do
            local cur = pop()
            if closed[cur] then continue end
            closed[cur] = true
            if cur == goal then found = true; break end
            nVisit += 1
            if nVisit > 8000 then break end
            local c0 = cur - 1
            local cx, cz = c0 % _GNX, math.floor(c0 / _GNX)
            for dz = -1, 1 do
                for dx = -1, 1 do
                    if dx == 0 and dz == 0 then continue end
                    local nx, nz = cx + dx, cz + dz
                    if not _gWalk(nx, nz, ignA, ignB) then continue end
                    if dx ~= 0 and dz ~= 0 then
                        if not _gWalk(cx + dx, cz, ignA, ignB) then continue end
                        if not _gWalk(cx, cz + dz, ignA, ignB) then continue end
                    end
                    local nidx = nz * _GNX + nx + 1
                    if closed[nidx] then continue end
                    local step = (dx ~= 0 and dz ~= 0) and 1.41421356 or 1
                    local ng = (gScore[cur] or 1e9) + step
                    if ng < (gScore[nidx] or 1e9) then
                        gScore[nidx] = ng
                        came[nidx] = cur
                        push(ng + h(nx, nz), nidx)
                    end
                end
            end
        end
        if not found then return nil end
        local chain = {}
        local c = goal
        while c do
            chain[#chain + 1] = c
            c = came[c]
        end
        local pts = {}
        for i = #chain, 1, -1 do
            local id = chain[i] - 1
            local ix, iz = id % _GNX, math.floor(id / _GNX)
            pts[#pts + 1] = Vector3.new(
                _GX0 + (ix + 0.5) * _GCELL,
                y,
                _GZ0 + (iz + 0.5) * _GCELL)
        end
        if #pts == 0 then return nil end
        pts[1] = Vector3.new(fromPos.X, y, fromPos.Z)
        pts[#pts] = Vector3.new(toPos.X, y, toPos.Z)
        return _pullPath(pts, y, ignA, ignB)
    end
    local function _visShort(fromPos, toPos, y, ignA, ignB)
        local a0 = Vector3.new(fromPos.X, y, fromPos.Z)
        local b0 = Vector3.new(toPos.X, y, toPos.Z)
        if (a0 - b0).Magnitude < 0.5 then
            return { a0, b0 }
        end
        if _clearWide(a0, b0, ignA, ignB) then
            return { a0, b0 }
        end
        local boxes = {}
        local pad = _PLOT_PAD
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local b = _PLOT_BOXES[k]
                boxes[#boxes + 1] = {
                    minX = b.minX - pad, maxX = b.maxX + pad,
                    minZ = b.minZ - pad, maxZ = b.maxZ + pad,
                }
            end
        end
        local sp = _SHOP_PAD
        for s = 1, #_MID_BOXES do
            local b = _MID_BOXES[s]
            boxes[#boxes + 1] = {
                minX = b.minX - sp, maxX = b.maxX + sp,
                minZ = b.minZ - sp, maxZ = b.maxZ + sp,
            }
        end
        local function inBox(x, z)
            for i = 1, #boxes do
                local b = boxes[i]
                if x >= b.minX and x <= b.maxX and z >= b.minZ and z <= b.maxZ then
                    return true
                end
            end
            return false
        end
        local nx = { fromPos.X, toPos.X }
        local nz = { fromPos.Z, toPos.Z }
        local eps = 0.45
        for i = 1, #boxes do
            local b = boxes[i]
            local cx = { b.minX - eps, b.maxX + eps, b.maxX + eps, b.minX - eps }
            local cz = { b.minZ - eps, b.minZ - eps, b.maxZ + eps, b.maxZ + eps }
            for c = 1, 4 do
                if not inBox(cx[c], cz[c]) then
                    nx[#nx + 1] = cx[c]
                    nz[#nz + 1] = cz[c]
                end
            end
        end
        local n = #nx
        if n < 2 then return nil end
        local inf = 1e18
        local g = table.create(n, inf)
        local prv = table.create(n, 0)
        local used = table.create(n, false)
        g[1] = 0
        for _ = 1, n do
            local u, best = 0, inf
            for i = 1, n do
                if not used[i] and g[i] < best then
                    best = g[i]
                    u = i
                end
            end
            if u == 0 then break end
            used[u] = true
            if u == 2 then break end
            local pa = Vector3.new(nx[u], y, nz[u])
            for v = 1, n do
                if used[v] or v == u then continue end
                local dx, dz = nx[v] - nx[u], nz[v] - nz[u]
                local dist = math.sqrt(dx * dx + dz * dz)
                if dist < 0.05 or g[u] + dist >= g[v] then continue end
                local pb = Vector3.new(nx[v], y, nz[v])
                if _clearWide(pa, pb, ignA, ignB) then
                    g[v] = g[u] + dist
                    prv[v] = u
                end
            end
        end
        if g[2] >= inf * 0.5 or prv[2] == 0 then return nil end
        local chain = { 2 }
        local c = 2
        local guard = 0
        while c ~= 1 do
            c = prv[c]
            if c == 0 then return nil end
            chain[#chain + 1] = c
            guard += 1
            if guard > n then return nil end
        end
        local pts = {}
        for i = #chain, 1, -1 do
            local id = chain[i]
            pts[#pts + 1] = Vector3.new(nx[id], y, nz[id])
        end
        pts[1] = a0
        pts[#pts] = b0
        return _pullPath(pts, y, ignA, ignB)
    end
    local function computeRoute(fromPos, toPos, facingDir)
        local y = fromPos.Y
        local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
        if not iTo then iTo = getClosestBaseIdx(toPos) end
        local route
        local hitsShop = _segmentHitsShop(fromPos, toPos)
        if _canSeeSide(fromPos, toPos, iTo) and not hitsShop then
            route = { toPos }
            _routeVia = "ligne"
        else
            local best, bestL = nil, math.huge
            local function take(pts, via)
                if not pts or #pts < 1 then return end
                local copy = {}
                for i = 1, #pts do
                    copy[i] = pts[i]
                end
                if (copy[#copy] - toPos).Magnitude > 0.5 then
                    copy[#copy + 1] = toPos
                end
                local L = _routeLen(copy)
                if L < bestL then
                    best, bestL = copy, L
                    _routeVia = via
                end
            end
            take(_visShort(fromPos, toPos, y, iFrom, iTo), "short")
            if not best then
                take(_astarXZ(fromPos, toPos, y, iFrom, iTo), "astar")
            end
            if best then
                route = best
            else
                route = { toPos }
                _routeVia = "short"
            end
        end
        _G.__Elite_IgnDest = iTo
        return route
    end
    local function doClone()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then return false end
        pcall(instantClone)
        return true
    end
    local _goBrainGen = 0
    local _landConn
    local function clearLandPlatforms()
        if _landConn then
            pcall(function() _landConn:Disconnect() end)
            _landConn = nil
        end
        local kids = workspace:GetChildren()
        for i = 1, #kids do
            local ch = kids[i]
            if ch and ch.Name == "eliteHubLandPlatform" then
                pcall(function() ch:Destroy() end)
            end
        end
    end
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if LP:GetAttribute("Stealing") == true then
            clearLandPlatforms()
        end
    end)
    local function goToBrainrot(petPos)
        if not petPos then return end
        _goBrainGen += 1
        local goGen = _goBrainGen
        _G.__Elite_GoingToBrainrot = true
        local char, hrp, hum
        local _t0 = os.clock()
        repeat
            char = LP.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then break end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0 > 3
        if not hrp or not hum then
            if goGen == _goBrainGen then
                _G.__Elite_GoingToBrainrot = false
            end
            return
        end
        hrp.Anchored = false
        local _equipped = false
        do
            local _e0 = os.clock()
            repeat
                char = LP.Character
                for _, _cn in ipairs(_G.Elite_CarpetNames or {}) do
                    if char and char:FindFirstChild(_cn) then _equipped = true; break end
                end
                if _equipped then break end
                _G.Elite_EquipCarpet()
                RunService.Heartbeat:Wait()
            until _equipped or os.clock() - _e0 > 1.5
            if _equipped then task.wait(0.2) end
        end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then
            if goGen == _goBrainGen then
                _G.__Elite_GoingToBrainrot = false
            end
            return
        end
        hrp.Anchored = false
        do
            local _t0b = os.clock()
            repeat
                local p = hrp.Position
                local inRad = false
                for i = 1, 8 do
                    local box = _PLOT_BOXES[i]
                    if p.X >= box.minX and p.X <= box.maxX and p.Z >= box.minZ and p.Z <= box.maxZ then
                        inRad = true
                        break
                    end
                end
                if inRad then break end
                RunService.Heartbeat:Wait()
            until os.clock() - _t0b > 1.5
        end
        local h = petPos.Y
        local targetY = hrp.Position.Y
        if h > 23.15 then targetY = 21
        elseif h >= 11 and h <= 23.15 then targetY = 14.5
        elseif h >= -6.9 and h <= 8.9 then targetY = -4 end
        local _to = Vector3.new(petPos.X, targetY, petPos.Z)
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(_to)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if h > 23.15 then
            local plat = Instance.new("Part")
            plat.Name = "eliteHubLandPlatform"
            plat.Size = Vector3.new(14, 1, 14)
            plat.Position = Vector3.new(_to.X, _to.Y - 3.15, _to.Z)
            plat.Anchored = true
            plat.CanCollide = true
            plat.Transparency = 1
            plat.Parent = workspace
            if _landConn then
                pcall(function() _landConn:Disconnect() end)
                _landConn = nil
            end
            local tEnd = os.clock() + 2.2
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if LP:GetAttribute("Stealing") == true or os.clock() > tEnd then
                    if conn then conn:Disconnect(); conn = nil end
                    if _landConn == conn then _landConn = nil end
                    if plat and plat.Parent then plat:Destroy() end
                    return
                end
                local rh = (hrp and hrp.Parent) and hrp or nil
                if not rh then return end
                local v = rh.AssemblyLinearVelocity
                if v.Y < -2 then
                    rh.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
                end
                if rh.Position.Y < 18 then
                    rh.CFrame = CFrame.new(rh.Position.X, 21, rh.Position.Z)
                    rh.AssemblyLinearVelocity = Vector3.zero
                    rh.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            _landConn = conn
        end
        task.delay(1.25, function()
            if goGen == _goBrainGen and not (_G.__Elite_VelFlying or _G.__Elite_TPStarted) then
                _G.__Elite_GoingToBrainrot = false
            end
        end)
    end
    local function getPromptPosition(prompt)
        local p = prompt and prompt.Parent
        if not p then return end
        if p:IsA("Attachment") and p.Parent then p = p.Parent end
        if p:IsA("BasePart") then return p.Position end
        if p:IsA("Model") then return _cheapPos(p) end
    end
    _G.Elite_WebhookNotify = function() end
    local STEAL_R = math.max(1, tonumber(Config and Config.AutoGrabRadius) or 90)
    local STEAL_HOLD_DURATION = 1.3
    local _stealHoldActive = false
    local TweenService = game:GetService("TweenService")
    local _barGui, _barFill, _barTw
    local _barOn = false
    local _barGen = 0
    do
        local root
        pcall(function()
            root = game:GetService("CoreGui")
        end)
        if root then
            for _, parent in ipairs({ root, LP:FindFirstChild("PlayerGui") }) do
                if parent then
                    local old = parent:FindFirstChild("EliteStealBar") or parent:FindFirstChild("eliteStealBar")
                    if old then old:Destroy() end
                end
            end
            local gui = Instance.new("ScreenGui")
            gui.Name = "EliteStealBar"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 220
            gui.Enabled = false
            pcall(function()
                gui.Parent = root
            end)
            local wrap = Instance.new("Frame")
            wrap.AnchorPoint = Vector2.new(0.5, 0)
            wrap.Position = UDim2.new(0.5, 0, 0, 14)
            wrap.Size = UDim2.fromOffset(168, 34)
            wrap.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
            wrap.BackgroundTransparency = 0.08
            wrap.BorderSizePixel = 0
            wrap.Parent = gui
            local wc = Instance.new("UICorner")
            wc.CornerRadius = UDim.new(0, 12)
            wc.Parent = wrap
            local ws = Instance.new("UIStroke")
            ws.Color = Color3.fromRGB(255, 255, 255)
            ws.Transparency = 0.86
            ws.Thickness = 1
            ws.Parent = wrap
            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.fromOffset(10, 4)
            nameLbl.Size = UDim2.new(1, -20, 0, 14)
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 11
            nameLbl.TextColor3 = Color3.fromRGB(244, 246, 248)
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Text = "Grab"
            nameLbl.Parent = wrap
            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(10, 22)
            track.Size = UDim2.new(1, -20, 0, 5)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
            track.BorderSizePixel = 0
            track.ClipsDescendants = true
            track.Parent = wrap
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.fromScale(0, 1)
            fill.BackgroundColor3 = Color3.fromRGB(236, 238, 242)
            fill.BorderSizePixel = 0
            fill.Parent = track
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            _barGui, _barFill = gui, fill
            _G.Elite_StealBarName = nameLbl
        end
    end
    local function stealBarHide(force)
        if not force and LP:GetAttribute("Stealing") == true then
            local api = _G.Elite_PanelBar
            if api and api.carry then
                pcall(api.carry, stealName())
            end
            if _barGui then _barGui.Enabled = false end
            return
        end
        _barOn = false
        _barGen += 1
        if _barTw then pcall(function() _barTw:Cancel() end); _barTw = nil end
        if _barFill then _barFill.Size = UDim2.fromScale(0, 1) end
        if _barGui then _barGui.Enabled = false end
        local api = _G.Elite_PanelBar
        if api and api.hide then pcall(api.hide) end
    end
    local function stealName()
        local pet = _stealTarget or _G.Elite_StealTarget
        if type(pet) == "table" then
            local n = tostring(pet.name or pet.index or "Grab")
            if type(pet.mutation) == "string" and pet.mutation ~= "" then
                n = pet.mutation .. " " .. n
            end
            return n
        end
        if type(_G.Elite_HoldingName) == "string" and _G.Elite_HoldingName ~= "" then
            return _G.Elite_HoldingName
        end
        return "Grab"
    end
    local function stealBarShow()
        if LP:GetAttribute("Stealing") == true then
            stealBarHide()
            return
        end
        _barOn = true
        _barGen += 1
        local gen = _barGen
        local name = stealName()
        local api = _G.Elite_PanelBar
        if api and api.show then
            pcall(api.show, name, STEAL_HOLD_DURATION, gen)
            if _barGui then _barGui.Enabled = false end
        else
            if _G.Elite_StealBarName then
                _G.Elite_StealBarName.Text = name
            end
            if _barFill then
                _barFill.Size = UDim2.fromScale(0, 1)
                if _barGui then _barGui.Enabled = true end
                local tw = TweenService:Create(_barFill, TweenInfo.new(STEAL_HOLD_DURATION, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Size = UDim2.fromScale(1, 1) })
                _barTw = tw
                tw:Play()
            end
        end
    end
    local function _grabCB(prompt)
        local d = { hold = {}, trigger = {} }
        if not prompt then
            return d
        end
        local ok, cs = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                if type(c.Function) == "function" then
                    d.hold[#d.hold + 1] = c.Function
                end
            end
        end
        ok, cs = pcall(getconnections, prompt.Triggered)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                if type(c.Function) == "function" then
                    d.trigger[#d.trigger + 1] = c.Function
                end
            end
        end
        return d
    end
    local _apCache = setmetatable({}, { __mode = "k" })
    local function _apFromHold(prompt, data)
        local ap = _apCache[prompt]
        if ap ~= nil then
            return ap or nil
        end
        if debug and debug.getupvalues and data then
            for _, f in ipairs(data.hold) do
                local ok, ups = pcall(debug.getupvalues, f)
                if ok and type(ups) == "table" then
                    for _, v in pairs(ups) do
                        if type(v) == "table" and rawget(v, "State") ~= nil and rawget(v, "ProximityPrompt") ~= nil then
                            _apCache[prompt] = v
                            return v
                        end
                    end
                end
            end
        end
        _apCache[prompt] = false
        return nil
    end
    local function _fireHoldForced(prompt, data)
        if not data or #data.hold == 0 then
            return false
        end
        local ap = _apFromHold(prompt, data)
        if ap and ap.State ~= "Steal" then
            local old = ap.State
            ap.State = "Steal"
            for _, f in ipairs(data.hold) do
                pcall(f)
            end
            ap.State = old
            return true
        end
        if not ap and prompt and prompt.Enabled == false then
            return false
        end
        for _, f in ipairs(data.hold) do
            task.spawn(f)
        end
        return true
    end
    local function _fireTrigger(prompt, data)
        if fireproximityprompt then
            pcall(fireproximityprompt, prompt)
            return
        end
        if data then
            for _, f in ipairs(data.trigger) do
                task.spawn(f)
            end
        end
    end
    local function _ragUntil()
        return tonumber(LP:GetAttribute("RagdollEndTime")) or 0
    end
    local function _ragBlockedNow()
        if (_ragUntil() - workspace:GetServerTimeNow()) > 0.1 then
            return true
        end
        if LP:GetAttribute("Web") == true then
            return true
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return hum ~= nil and hum:GetState() == Enum.HumanoidStateType.Ragdoll
    end
    local _stealAbort = false
    local _stealRetryAt = 0
    local executeSteal
    local _promptCache, _promptPet = nil, nil
    local function findStealPrompt(pet)
        if not pet then return nil end
        if _promptPet and _promptCache and _promptCache.Parent
            and pet.plot == _promptPet.plot and pet.slot == _promptPet.slot then
            return _promptCache
        end
        if _G.__Elite_VelFlying then
            return _promptCache
        end
        local found = nil
        if pet.plot and pet.slot then
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
            if podium then
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attach = spawn and spawn:FindFirstChild("PromptAttachment")
                if attach then
                    for _, p in ipairs(attach:GetChildren()) do
                        if p:IsA("ProximityPrompt") then found = p; break end
                    end
                end
                if not found then
                    for _, d in ipairs(podium:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then found = d; break end
                    end
                end
            end
        end
        _promptCache, _promptPet = found, pet
        return found
    end
    local function _promptWorldPos(prompt, pet)
        return getPromptPosition(prompt) or (pet and pet.position) or nil
    end
    local STEAL_ARM_TIMEOUT = 25
    local _stealTarget = nil
    local _stealArmedAt = 0
    local _stealBlocked = false
    local _isStealing = false
    local function _refreshBlock()
        _isStealing = LP:GetAttribute("Stealing") == true
        _stealBlocked = not not (_isStealing
            or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting")
            or LP:GetAttribute("Web"))
        if LP:GetAttribute("Web") or _ragBlockedNow() then
            _stealAbort = true
            if not _isStealing then
                stealBarHide(true)
            end
        elseif not _isStealing and _G.__Elite_HoldActive ~= true then
            stealBarHide(true)
        end
    end
    _refreshBlock()
    do
        local holdBb, holdLbl
        local function holdingText()
            local pet = _stealTarget or _G.Elite_StealTarget
            local n
            if type(pet) == "table" then
                n = tostring(pet.name or pet.index or "")
                if type(pet.mutation) == "string" and pet.mutation ~= "" then
                    n = pet.mutation .. " " .. n
                end
            end
            if (not n or n == "") and type(_G.Elite_HoldingName) == "string" then
                n = _G.Elite_HoldingName
            end
            if not n or n == "" then
                n = "Brainrot"
            end
            return "Holding (" .. n .. ")"
        end
        local function ensureHold()
            local char = LP.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            local on = LP:GetAttribute("Stealing") == true
            if not head or not on then
                if holdBb then
                    holdBb.Enabled = false
                end
                return
            end
            if not holdBb or not holdBb.Parent then
                holdBb = Instance.new("BillboardGui")
                holdBb.Name = "EliteHoldEsp"
                holdBb.Size = UDim2.fromOffset(220, 26)
                holdBb.StudsOffsetWorldSpace = Vector3.new(0, 3.15, 0)
                holdBb.AlwaysOnTop = true
                holdBb.LightInfluence = 0
                holdBb.MaxDistance = 120
                holdBb.ResetOnSpawn = false
                local chip = Instance.new("Frame")
                chip.Size = UDim2.fromScale(1, 1)
                chip.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
                chip.BackgroundTransparency = 0.08
                chip.BorderSizePixel = 0
                chip.Parent = holdBb
                local cc = Instance.new("UICorner")
                cc.CornerRadius = UDim.new(0, 8)
                cc.Parent = chip
                local cs = Instance.new("UIStroke")
                cs.Color = Color3.fromRGB(255, 255, 255)
                cs.Transparency = 0.86
                cs.Thickness = 1
                cs.Parent = chip
                holdLbl = Instance.new("TextLabel")
                holdLbl.BackgroundTransparency = 1
                holdLbl.Size = UDim2.fromScale(1, 1)
                holdLbl.Font = Enum.Font.GothamMedium
                holdLbl.TextSize = 12
                holdLbl.TextColor3 = Color3.fromRGB(244, 246, 248)
                holdLbl.Parent = chip
                local parent = _barGui and _barGui.Parent
                holdBb.Parent = parent or char
            end
            holdBb.Adornee = head
            holdBb.Enabled = true
            if holdLbl then
                holdLbl.Text = holdingText()
            end
        end
        LP:GetAttributeChangedSignal("Stealing"):Connect(function()
            _refreshBlock()
            pcall(ensureHold)
        end)
        LP.CharacterAdded:Connect(function()
            task.defer(function()
                pcall(ensureHold)
            end)
        end)
        task.spawn(function()
            while LP and LP.Parent do
                pcall(ensureHold)
                task.wait(0.25)
            end
        end)
        pcall(ensureHold)
    end
    LP:GetAttributeChangedSignal("Stealing"):Connect(_refreshBlock)
    LP:GetAttributeChangedSignal("IsTrading"):Connect(_refreshBlock)
    LP:GetAttributeChangedSignal("IsDuelSelecting"):Connect(_refreshBlock)
    LP:GetAttributeChangedSignal("Web"):Connect(_refreshBlock)
    local function timeUntilCanSteal()
        if _stealBlocked then return -1 end
        return 0
    end
    local function _pickByMode(pets)
        return pets and pets[1] or nil
    end
    local function nearestPaint(on)
        on = on == true
        _G.__Elite_NearestOn = on
        local b = _G.Elite_NearestBtn
        if not b then return end
        b:SetAttribute("On", on)
        b.BackgroundColor3 = on and Color3.fromRGB(240, 240, 244) or Color3.fromRGB(26, 26, 30)
        b.TextColor3 = on and Color3.fromRGB(10, 10, 12) or Color3.fromRGB(235, 235, 238)
    end
    local _nearestOn = false
    local _nearestSawOutside = false
    local _nearestCache
    local _nearestAt
    local function disableNearest()
        _nearestOn = false
        _nearestSawOutside = false
        nearestPaint(false)
        _nearestCache = nil
        _nearestAt = nil
    end
    local _flyStealFired = false
    local function armSteal(pet)
        if not pet then return end
        _stealTarget = pet
        _G.Elite_StealTarget = pet
        do
            local n = tostring(pet.name or pet.index or "")
            if type(pet.mutation) == "string" and pet.mutation ~= "" then
                n = pet.mutation .. " " .. n
            end
            if n ~= "" then
                _G.Elite_HoldingName = n
            end
        end
        _stealArmedAt = os.clock()
        _flyStealFired = false
        findStealPrompt(pet)
        if _G.Elite_OnStealTarget then
            pcall(_G.Elite_OnStealTarget, pet)
        end
    end
    local function disarmSteal()
        _stealTarget = nil
        _G.Elite_StealTarget = nil
        _stealAbort = true
        _stealHoldActive = false
        _G.__Elite_HoldActive = false
        stealBarHide(true)
        _promptCache, _promptPet = nil, nil
        nearestPaint(false)
        _nearestOn = false
        _nearestCache = nil
        _nearestAt = nil
        if _G.Elite_OnStealTarget then
            pcall(_G.Elite_OnStealTarget, nil)
        end
    end
    local _resumeGen = 0
    local function queueResumeSteal()
        if Config.AutoStealEnabled == false then return end
        _resumeGen += 1
        local gen = _resumeGen
        task.delay(0.45, function()
            if gen ~= _resumeGen then return end
            if LP:GetAttribute("Stealing") == true then return end
            if LP:GetAttribute("IsTrading") or LP:GetAttribute("IsDuelSelecting") then return end
            if LP:GetAttribute("Web") then return end
            if _G.__Elite_VelFlying or _G.__Elite_TPStarted then
                task.delay(0.55, function()
                    if gen == _resumeGen then
                        queueResumeSteal()
                    end
                end)
                return
            end
            local pet = _stealTarget
            if not pet then
                local ok, pets = pcall(scanAllPets)
                pet = ok and pets and pets[1]
                if pet then
                    armSteal(pet)
                    pcall(_G.Elite_LockPrioPlot, pet.plot)
                end
            end
            if pet and Config.AutoTPPriority ~= false then
                pcall(_ensurePetPos, pet)
                local pos = pet.position or pet.plotHint
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and pos then
                    task.spawn(function()
                        if gen ~= _resumeGen then return end
                        if _G.Elite_CarpetEngage then
                            pcall(_G.Elite_CarpetEngage)
                        else
                            if _G.Elite_FireGrapple then pcall(_G.Elite_FireGrapple) end
                            if _G.Elite_EquipCarpet then pcall(_G.Elite_EquipCarpet) end
                        end
                        if gen ~= _resumeGen then return end
                        if LP:GetAttribute("Stealing") == true then return end
                        char = LP.Character
                        hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not (hrp and hrp.Parent) then return end
                        local hold = RunService.Heartbeat:Connect(function()
                            if gen ~= _resumeGen then return end
                            pcall(function()
                                if _G.Elite_EquipCarpet then _G.Elite_EquipCarpet() end
                            end)
                        end)
                        local function stopHold()
                            if hold then
                                pcall(function() hold:Disconnect() end)
                                hold = nil
                            end
                            if hrp and hrp.Parent then
                                pcall(function()
                                    hrp.Anchored = false
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                end)
                            end
                        end
                        local h = pos.Y
                        local targetY = hrp.Position.Y
                        if h > 23.15 then targetY = 21
                        elseif h >= 11 and h <= 23.15 then targetY = 14.5
                        elseif h >= -6.9 and h <= 8.9 then targetY = -4 end
                        local dest = Vector3.new(pos.X, targetY, pos.Z)
                        local dist = (hrp.Position - dest).Magnitude
                        if dist < 0.5 then
                            hrp.CFrame = CFrame.new(dest)
                            stopHold()
                            return
                        end
                        local dur = dist / 600
                        pcall(function() hrp.Anchored = true end)
                        local tw = TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
                            CFrame = CFrame.new(dest),
                        })
                        tw:Play()
                        tw.Completed:Wait()
                        if gen ~= _resumeGen then
                            stopHold()
                            return
                        end
                        if hrp and hrp.Parent then
                            pcall(function()
                                hrp.Anchored = false
                                hrp.CFrame = CFrame.new(dest)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end)
                        end
                        stopHold()
                        if h > 23.15 and LP:GetAttribute("Stealing") ~= true then
                            pcall(goToBrainrot, pos)
                        end
                    end)
                end
            end
        end)
    end
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if LP:GetAttribute("Stealing") == true then
            disableNearest()
            stealBarHide()
        else
            if _G.__Elite_HoldActive ~= true then
                stealBarHide(true)
            end
            queueResumeSteal()
        end
    end)
    LP:GetAttributeChangedSignal("Web"):Connect(function()
        if LP:GetAttribute("Web") then
            _stealAbort = true
            if LP:GetAttribute("Stealing") ~= true then
                stealBarHide(true)
            end
        else
            queueResumeSteal()
        end
    end)
    local function _hookRagdoll(hum)
        if not hum or hum:GetAttribute("EliteRagHook") then
            return
        end
        hum:SetAttribute("EliteRagHook", true)
        hum.StateChanged:Connect(function(_, st)
            if st == Enum.HumanoidStateType.Ragdoll then
                _stealAbort = true
                if LP:GetAttribute("Stealing") ~= true then
                    stealBarHide(true)
                end
            end
        end)
    end
    if LP.Character then
        _hookRagdoll(LP.Character:FindFirstChildOfClass("Humanoid"))
    end
    LP.CharacterAdded:Connect(function(c)
        _stealAbort = true
        _stealHoldActive = false
        _G.__Elite_HoldActive = false
        if LP:GetAttribute("Stealing") ~= true then
            stealBarHide(true)
        end
        task.defer(function()
            _hookRagdoll(c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 8))
        end)
    end)
    local AUTO_STEAL = (Config and Config.AutoStealEnabled) and true or false
    local STEAL_MODE = (Config and Config.StealMode) or "Priority"
    local _hrpRef
    local function stealHrp()
        local h = _G.__Elite_FlyHrp
        if h and h.Parent then return h end
        h = _hrpRef
        if h and h.Parent then return h end
        local char = LP.Character
        h = char and char:FindFirstChild("HumanoidRootPart")
        _hrpRef = h
        return h
    end
    local function _promptDist3(prompt)
        local hrp = stealHrp()
        if not hrp then
            return nil
        end
        local pos = getPromptPosition(prompt)
        if not pos then
            return nil
        end
        return (hrp.Position - pos).Magnitude
    end
    executeSteal = function(prompt, pet)
        if _stealHoldActive or not prompt or not prompt.Parent then
            return
        end
        if LP:GetAttribute("Stealing") == true then
            return
        end
        if _ragBlockedNow() then
            stealBarHide(true)
            return
        end
        local d3 = _promptDist3(prompt)
        if d3 and d3 > STEAL_R then
            return
        end
        local data = _grabCB(prompt)
        if #data.hold == 0 and #data.trigger == 0 and not fireproximityprompt then
            return
        end
        _stealHoldActive = true
        _G.__Elite_HoldActive = true
        _stealAbort = false
        task.spawn(function()
            local grabbed = false
            local STEAL_COMMIT_WAIT = 0.4
            local function finishHold()
                _stealHoldActive = false
                _G.__Elite_HoldActive = false
                if LP:GetAttribute("Stealing") == true or grabbed then
                    stealBarHide()
                else
                    stealBarHide(true)
                end
                _stealRetryAt = os.clock() + STEAL_COMMIT_WAIT
            end
            local okHold = pcall(function()
            local oldDur = prompt.HoldDuration
            pcall(function()
                prompt.HoldDuration = 0
            end)
            pcall(function()
                prompt.MaxActivationDistance = math.huge
            end)
            local abort = false
            local barShown = false
            local beginT = 0
            if _fireHoldForced(prompt, data) then
                beginT = prompt.Enabled ~= false and tick() or 0
            else
                for _, f in ipairs(data.hold) do
                    task.spawn(f)
                end
                beginT = prompt.Enabled ~= false and tick() or 0
            end
            local t0 = tick()
            local holdAbs = tick()
            local commitN, lastCommit = 0, 0
            local recapN = 0
            local eligSince = 0
            local STEAL_COMMIT_RANGE = 10
            local STEAL_ENTRY_DELAY = 0.3
            local STEAL_POLL = 0.03
            local STEAL_MAX_HOLD = STEAL_HOLD_DURATION + 1.3
            local STEAL_HOLD_MAX_TOTAL = 20
            local STEAL_SRV_HOLD = STEAL_HOLD_DURATION
            local STEAL_SRV_HOLD_MAX = 2.5
            while prompt.Parent and not grabbed and not abort and not _stealAbort do
                if LP:GetAttribute("Stealing") == true then
                    grabbed = true
                    break
                end
                if LP:GetAttribute("IsTrading") or LP:GetAttribute("IsDuelSelecting") then
                    abort = true
                    break
                end
                if _ragBlockedNow() then
                    abort = true
                    break
                end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not (hum and hum.Health > 0) then
                    abort = true
                    break
                end
                local dist = _promptDist3(prompt)
                if dist and dist > STEAL_R then
                    abort = true
                    break
                end
                if #data.hold == 0 and recapN < 40 then
                    recapN += 1
                    data = _grabCB(prompt)
                    if #data.hold > 0 then
                        _fireHoldForced(prompt, data)
                        beginT = tick()
                        t0 = tick()
                    end
                end
                local now = tick()
                if commitN == 0 and prompt.Enabled ~= false and (beginT == 0 or (now - beginT) > STEAL_SRV_HOLD_MAX) then
                    _fireHoldForced(prompt, data)
                    beginT = tick()
                    t0 = math.max(t0, tick())
                end
                local holdDone = (now - t0) >= STEAL_HOLD_DURATION
                local inRange = dist ~= nil and dist <= STEAL_COMMIT_RANGE
                if inRange then
                    if eligSince == 0 then
                        eligSince = now
                    end
                    if not barShown then
                        barShown = true
                        stealBarShow()
                    end
                else
                    eligSince = 0
                    if barShown and LP:GetAttribute("Stealing") ~= true then
                        barShown = false
                        stealBarHide(true)
                    end
                end
                local settled = eligSince > 0 and (now - eligSince) >= STEAL_ENTRY_DELAY
                local holdAge = beginT > 0 and (now - beginT) or 0
                local inCommit = holdDone and not _ragBlockedNow() and inRange and settled
                    and holdAge >= STEAL_SRV_HOLD and holdAge <= STEAL_SRV_HOLD_MAX
                if inCommit and commitN == 0 then
                    lastCommit, commitN = now, 1
                    _fireTrigger(prompt, data)
                end
                if commitN > 0 and (now - lastCommit) >= STEAL_COMMIT_WAIT then
                    break
                end
                if (now - t0) >= STEAL_MAX_HOLD and commitN == 0 then
                    break
                end
                if (now - holdAbs) > STEAL_HOLD_MAX_TOTAL then
                    break
                end
                task.wait(STEAL_POLL)
            end
            if prompt.Parent then
                pcall(function()
                    prompt.HoldDuration = oldDur
                end)
            end
            end)
            if not okHold then
                grabbed = false
            end
            finishHold()
        end)
    end
    local function isPromptAvailable(prompt, hrpPos)
        if not AUTO_STEAL then return false end
        if not prompt or not prompt.Parent or not prompt.Enabled then return false end
        local pos = getPromptPosition(prompt)
        if not pos then return false end
        return (pos - hrpPos).Magnitude <= STEAL_R
    end
    local _stealLastScan = 0
    local isTeleporting = false
    local _tpStartedAt = 0
    RunService.Heartbeat:Connect(function()
        if _G.__Elite_VelFlying then
            if AUTO_STEAL and not _stealHoldActive and not _stealBlocked and os.clock() >= _stealRetryAt then
                local pet = _stealTarget
                local hrp = pet and stealHrp()
                local prompt = hrp and _promptCache
                if hrp and prompt and isPromptAvailable(prompt, hrp.Position) and not _ragBlockedNow() then
                    executeSteal(prompt, pet)
                end
            end
            return
        end
        local now = os.clock()
        local pet = _stealTarget
        if not pet then
            if AUTO_STEAL and Config.AutoStealEnabled ~= false and not _stealBlocked and now - _stealLastScan >= 0.25 then
                _stealLastScan = now
                local ok, pets = pcall(scanAllPets)
                local nxt = ok and pets and pets[1]
                if nxt then
                    armSteal(nxt)
                    pcall(_G.Elite_LockPrioPlot, nxt.plot)
                    pet = nxt
                end
            end
            if not pet then return end
        end
        if STEAL_MODE == "Nearest" and now - _stealArmedAt > STEAL_ARM_TIMEOUT then
            if AUTO_STEAL and Config.AutoStealEnabled ~= false then
                _stealArmedAt = now
            else
                disarmSteal()
                return
            end
        end
        if now - _stealLastScan < 0.067 then return end
        _stealLastScan = now
        if _nearestOn then
            local hrpMine = stealHrp()
            local mine = _G.__Elite_MyPlot
            local insideMine = false
            if hrpMine and mine then
                local plots = workspace:FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(tostring(mine))
                if plot then
                    local cf, size
                    pcall(function()
                        cf, size = plot:GetBoundingBox()
                    end)
                    if cf and size then
                        local lp = cf:PointToObjectSpace(hrpMine.Position)
                        insideMine = math.abs(lp.X) <= size.X * 0.5 + 10 and math.abs(lp.Z) <= size.Z * 0.5 + 10
                    end
                end
            end
            if not insideMine then
                _nearestSawOutside = true
            elseif _nearestSawOutside then
                disableNearest()
            end
        end
        if _nearestOn and _nearestCache then
            local hrpN = stealHrp()
            if hrpN then
                local p = hrpN.Position
                local at = _nearestAt
                if not at then
                    _nearestAt = p
                else
                    local mx, my, mz = p.X - at.X, p.Y - at.Y, p.Z - at.Z
                    if mx * mx + my * my + mz * mz >= 4 then
                        _nearestAt = p
                        local best, bestD = nil, math.huge
                        for i = 1, #_nearestCache do
                            local e = _nearestCache[i]
                            local ep = e.pos
                            local dx, dy, dz = ep.X - p.X, ep.Y - p.Y, ep.Z - p.Z
                            local d = dx * dx + dy * dy + dz * dz
                            if d < bestD then
                                bestD, best = d, e.pet
                            end
                        end
                        if best and (not _stealTarget or _stealTarget.plot ~= best.plot or _stealTarget.slot ~= best.slot) then
                            armSteal(best)
                            pcall(_G.Elite_LockPrioPlot, best.plot)
                        end
                    end
                end
            end
        end
        if timeUntilCanSteal() == -1 then
            if LP:GetAttribute("Stealing") ~= true and _G.__Elite_HoldActive ~= true then
                stealBarHide(true)
            end
            return
        end
        if _stealHoldActive then return end
        if os.clock() < _stealRetryAt then return end
        if _ragBlockedNow() then
            stealBarHide(true)
            return
        end
        local hrp = stealHrp()
        if not hrp then return end
        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then return end
        local ppPos = _promptWorldPos(prompt, pet)
        if not ppPos then return end
        if (hrp.Position - ppPos).Magnitude > STEAL_R then return end
        executeSteal(prompt, pet)
    end)
    local function preFlyStrip(plotName)
        if plotName then
            pcall(_G.Elite_LockPrioPlot, plotName)
        end
    end
    local function _doVelocityTPImpl(pre)
        if isTeleporting and (os.clock() - _tpStartedAt) < 30 then
            return
        end
        isTeleporting = true
        _G.__Elite_TPStarted = true
        _tpStartedAt = os.clock()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then
            isTeleporting = false
            _G.__Elite_TPStarted = nil
            return
        end
        local allPets
        if type(pre) == "table" and (pre.plot or pre.name or pre.index) then
            allPets = { pre }
        elseif type(pre) == "table" and #pre > 0 then
            allPets = pre
        else
            allPets = scanAllPets()
            if #allPets == 0 then
                local _t0 = os.clock()
                while #allPets == 0 and (os.clock() - _t0) < 2 do
                    task.wait(0.1)
                    allPets = scanAllPets()
                end
            end
        end
        if #allPets == 0 then
            isTeleporting = false
            return
        end
        local pet = _pickByMode(allPets) or allPets[1]
        armSteal(pet)
        pcall(_ensurePetPos, pet)
        local petPos = pet.position or pet.plotHint
        if not petPos then
            local _t0 = os.clock()
            repeat
                RunService.Heartbeat:Wait()
                pcall(_ensurePetPos, pet)
                petPos = pet.position or pet.plotHint
                if not petPos then
                    for i = 1, #allPets do
                        local cand = allPets[i]
                        pcall(_ensurePetPos, cand)
                        local pos = cand.position or cand.plotHint
                        if pos then
                            pet = cand
                            petPos = pos
                            armSteal(pet)
                            break
                        end
                    end
                end
            until petPos or (os.clock() - _t0) > 2
        end
        local _tpSpd = _G.Elite_Clamp(Config and Config.TpSettings and Config.TpSettings.GrabbleTPSpeed)
        local petName = pet.name
        if not petPos then
            isTeleporting = false
            _G.__Elite_TPStarted = nil
            return
        end
        if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
            pcall(_G.Elite_EquipCarpet)
            local _to = Vector3.new(petPos.X, FRONT_Y_LOW, petPos.Z)
            local _faceDir
            do
                local idx = getClosestBaseIdx(petPos)
                local _, frontFace = buildFrontCandidate(idx, false, hrp.Position.Z)
                _faceDir = frontFace
            end
            preFlyStrip(pet.plot)
            _G.__Elite_VelFlying = true
            local route = computeRoute(hrp.Position, _to, _faceDir)
            if not route or #route == 0 then route = { _to } end
            velMoveThrough(hrp, route, _tpSpd)
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            isTeleporting = false
            return
        end
        pcall(_G.Elite_EquipCarpet)
        local destPos, facingDir = resolveCloneDest(hrp.Position, petPos, petName)
        if facingDir and facingDir.Magnitude > 0.1 then
            destPos = wallFrontPos(destPos, facingDir)
        end
        preFlyStrip(pet.plot)
        _G.__Elite_VelFlying = true
        local _route = computeRoute(hrp.Position, destPos, facingDir)
        if not _route or #_route == 0 then _route = { destPos } end
        local _stepped = {}
        do
            local startY = hrp.Position.Y
            local destY = destPos.Y
            local prev = hrp.Position
            local totalFlat = 0
            for _, wp in ipairs(_route) do
                totalFlat = totalFlat + Vector3.new(wp.X - prev.X, 0, wp.Z - prev.Z).Magnitude
                prev = wp
            end
            if totalFlat < 0.01 then totalFlat = 0.01 end
            prev = hrp.Position
            local travelled = 0
            for _, wp in ipairs(_route) do
                travelled = travelled + Vector3.new(wp.X - prev.X, 0, wp.Z - prev.Z).Magnitude
                local rampY = startY + (destY - startY) * (travelled / totalFlat)
                _stepped[#_stepped + 1] = Vector3.new(wp.X, rampY, wp.Z)
                prev = wp
            end
            if #_stepped > 0 then _stepped[#_stepped] = destPos end
        end
        velMoveThrough(hrp, _stepped, _tpSpd)
        local look = Vector3.new(0, 0, -1)
        if facingDir and facingDir.Magnitude > 0.1 then
            look = Vector3.new(facingDir.X, 0, facingDir.Z)
            if look.Magnitude < 0.1 then look = Vector3.new(0, 0, -1) else look = look.Unit end
        end
        local hitName
        destPos, hitName = wallFrontPos(destPos, facingDir)
        do
            local into = 0.45
            local ln = string.lower(hitName or "")
            if string.find(ln, "laser", 1, true) then into = 0 end
            destPos = destPos + look * into
        end
        hrp.Anchored = false
        local function _faceLook()
            if look.Magnitude > 0.1 and hrp and hrp.Parent then
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
            end
        end
        _faceLook()
        vZero(hrp)
        local _stopFall = _antiFall(hrp, destPos)
        armSteal(pet)
        local _cloneDelay = tonumber(Config and Config.TpSettings and Config.TpSettings.CloneDelayVal) or 0.27
        if _cloneDelay > 0 then
            task.wait(_cloneDelay)
        end
        local _cloneOk = doClone()
        if _stopFall then pcall(_stopFall, false) end
        if _cloneOk then
            _G.isCloning = false
            task.wait(0.3)
            goToBrainrot(petPos)
        end
    end
    function doVelocityTP(pre)
        pcall(_doVelocityTPImpl, pre)
        isTeleporting = false
        _G.__Elite_TPStarted = nil
        _G.__Elite_VelFlying = false
        task.delay(1.2, function()
            if not (_G.__Elite_VelFlying or _G.__Elite_TPStarted) then
                pcall(_G.Elite_FlushKills)
            end
        end)
    end
    _G.Elite_DoVelocityTP = doVelocityTP
    local function stealNearestPrio()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local origin = hrp.Position
        local cache = {}
        local best, bestD = nil, math.huge
        local isKey = _G.Elite_IsPlotChanKey
        local reg = _G.eliteSyncAll and _G.eliteSyncAll()
        if type(reg) ~= "table" then return end
        for name, ch in next, reg do
            if not (isKey and isKey(name)) then continue end
            if not ch or isMyPlot(ch) then continue end
            local list = channelGet(ch, "AnimalList")
            if type(list) ~= "table" then continue end
            local bestMutOnPlot = {}
            for slot, animalData in pairs(list) do
                if type(animalData) ~= "table" then continue end
                local animalName = animalData.Index
                if type(animalName) ~= "string" then continue end
                if not _prioRank[_nameKey(animalName)] then continue end
                if _eliteIsFusing(animalData) then continue end
                local mut = _adMut(animalData)
                local key = _nameKey(animalName)
                local prev = bestMutOnPlot[key]
                if not prev or _mutRank(mut) < _mutRank(prev.mutation) then
                    bestMutOnPlot[key] = {
                        name = animalName, index = animalName, mutation = mut,
                        plot = tostring(name), slot = tostring(slot),
                    }
                end
            end
            for _, pet in pairs(bestMutOnPlot) do
                _ensurePetPos(pet)
                local pos = pet.position or pet.plotHint
                if not pos then continue end
                cache[#cache + 1] = { pet = pet, pos = pos }
                local d = (pos - origin).Magnitude
                if d < bestD then
                    bestD, best = d, pet
                end
            end
        end
        if not best then
            return
        end
        _nearestCache = cache
        _nearestAt = origin
        _nearestOn = true
        _nearestSawOutside = false
        armSteal(best)
        pcall(_G.Elite_LockPrioPlot, best.plot)
        nearestPaint(true)
        if _G.Elite_SwitchStealTarget then
            pcall(_G.Elite_SwitchStealTarget, best)
        end
    end
    _G.Elite_StealNearestPrio = stealNearestPrio
    local function listAllPrioPets()
        local out = {}
        local isKey = _G.Elite_IsPlotChanKey
        local reg = _G.eliteSyncAll and _G.eliteSyncAll()
        if type(reg) ~= "table" then return out end
        for name, ch in next, reg do
            if not (isKey and isKey(name)) then continue end
            if not ch or isMyPlot(ch) then continue end
            local list = channelGet(ch, "AnimalList")
            if type(list) ~= "table" then continue end
            for slot, animalData in pairs(list) do
                if type(animalData) ~= "table" then continue end
                local animalName = animalData.Index
                if type(animalName) ~= "string" then continue end
                local rank = _prioRank[_nameKey(animalName)]
                if not rank then continue end
                if _eliteIsFusing(animalData) then continue end
                local mut = _adMut(animalData)
                local traits = _adTraits(animalData)
                local traitIcons = {}
                for i = 1, #traits do
                    local ic = _iconAsset(TRAIT_ICONS[traits[i]])
                    if ic then traitIcons[#traitIcons + 1] = ic end
                end
                local pet = {
                    name = animalName,
                    index = animalName,
                    mutation = mut,
                    traits = traits,
                    mutIcon = _iconAsset(MUT_ICONS[mut]),
                    traitIcons = traitIcons,
                    owner = _plotOwnerName(ch),
                    mps = _petGen(animalName, mut, traits),
                    plot = tostring(name),
                    slot = tostring(slot),
                    steal = animalData.Steal,
                    rank = rank,
                    mutRank = _mutRank(mut),
                }
                _ensurePetPos(pet)
                out[#out + 1] = pet
            end
        end
        table.sort(out, function(a, b)
            if a.rank ~= b.rank then return a.rank < b.rank end
            if a.mutRank ~= b.mutRank then return a.mutRank < b.mutRank end
            return tostring(a.slot) < tostring(b.slot)
        end)
        return out
    end
    _G.Elite_ListPrioPets = listAllPrioPets
    local function _takenByName(pet)
        if type(pet) ~= "table" then
            return nil
        end
        local stealId = pet.steal
        if typeof(stealId) == "Instance" and stealId:IsA("Player") then
            stealId = stealId.UserId
        end
        if pet.plot then
            local ch
            pcall(function()
                ch = _G.eliteSyncGet(tostring(pet.plot))
            end)
            if ch then
                local list = channelGet(ch, "AnimalList")
                if type(list) == "table" then
                    local e = list[pet.slot]
                    if e == nil then e = list[tostring(pet.slot)] end
                    if e == nil then e = list[tonumber(pet.slot)] end
                    if type(e) == "table" then
                        local s = e.Steal
                        if type(s) == "number" then
                            stealId = s
                        elseif typeof(s) == "Instance" and s:IsA("Player") then
                            stealId = s.UserId
                        end
                    end
                end
            end
        end
        if type(stealId) ~= "number" or stealId <= 0 then
            return nil
        end
        local p = Players:GetPlayerByUserId(stealId)
        if p and p:GetAttribute("Stealing") == true then
            return p.Name
        end
        return nil
    end
    _G.Elite_TakenBy = _takenByName
    _G.Elite_IsPetTaken = function(pet)
        return _takenByName(pet) ~= nil
    end
    local SWITCH_TWEEN_RANGE = 100
    local SWITCH_TWEEN_SPEED = 350
    local _switchGen = 0
    local _switchTw
    local _switchHold
    local function _petDest(pet, hrp)
        if not (pet and hrp) then return nil end
        pcall(_ensurePetPos, pet)
        local petPos = pet.position or pet.plotHint
        if not petPos then return nil end
        local h = petPos.Y
        local targetY = hrp.Position.Y
        if h > 23.15 then targetY = 21
        elseif h >= 11 and h <= 23.15 then targetY = 14.5
        elseif h >= -6.9 and h <= 8.9 then targetY = -4 end
        return Vector3.new(petPos.X, targetY, petPos.Z), petPos
    end
    local function _stopSwitchMove()
        if _switchHold then
            pcall(function() _switchHold:Disconnect() end)
            _switchHold = nil
        end
        if _switchTw then
            pcall(function() _switchTw:Cancel() end)
            _switchTw = nil
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
    local function switchStealTarget(pet)
        if not pet then return end
        armSteal(pet)
        pcall(_G.Elite_LockPrioPlot, pet.plot)
        if _G.__Elite_VelFlying or _G.__Elite_TPStarted then
            return
        end
        _switchGen += 1
        local gen = _switchGen
        _G.__Elite_GoingToBrainrot = true
        _stopSwitchMove()
        task.spawn(function()
            if gen ~= _switchGen then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                if gen == _switchGen then
                    _G.__Elite_GoingToBrainrot = false
                end
                return
            end
            if _G.Elite_CarpetEngage then
                pcall(_G.Elite_CarpetEngage)
            else
                if _G.Elite_FireGrapple then pcall(_G.Elite_FireGrapple) end
                if _G.Elite_EquipCarpet then pcall(_G.Elite_EquipCarpet) end
            end
            if gen ~= _switchGen then return end
            char = LP.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                if gen == _switchGen then
                    _G.__Elite_GoingToBrainrot = false
                end
                return
            end
            _switchHold = RunService.Heartbeat:Connect(function()
                if gen ~= _switchGen then return end
                pcall(function()
                    if _G.Elite_EquipCarpet then _G.Elite_EquipCarpet() end
                end)
            end)
            local dest, petPos = _petDest(pet, hrp)
            if not dest then
                _stopSwitchMove()
                if gen == _switchGen then
                    _G.__Elite_GoingToBrainrot = false
                end
                return
            end
            local dist = (hrp.Position - dest).Magnitude
            if dist <= SWITCH_TWEEN_RANGE then
                if dist < 0.5 then
                    hrp.CFrame = CFrame.new(dest)
                    _stopSwitchMove()
                    if gen == _switchGen then
                        _G.__Elite_GoingToBrainrot = false
                    end
                    return
                end
                local dur = dist / SWITCH_TWEEN_SPEED
                pcall(function() hrp.Anchored = true end)
                local tw = TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
                    CFrame = CFrame.new(dest),
                })
                _switchTw = tw
                tw:Play()
                tw.Completed:Wait()
                if gen ~= _switchGen then return end
                if hrp and hrp.Parent then
                    pcall(function()
                        hrp.Anchored = false
                        hrp.CFrame = CFrame.new(dest)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                if petPos and petPos.Y > 23.15 then
                    pcall(goToBrainrot, petPos)
                end
            else
                pcall(goToBrainrot, petPos)
            end
            if gen == _switchGen then
                _stopSwitchMove()
            end
            task.delay(0.85, function()
                if gen == _switchGen and not (_G.__Elite_VelFlying or _G.__Elite_TPStarted) then
                    _G.__Elite_GoingToBrainrot = false
                end
            end)
        end)
    end
    _G.Elite_SwitchStealTarget = switchStealTarget
    _G.Elite_GoToBrainrot = goToBrainrot
end

do
    local UIS = game:GetService("UserInputService")
    local root
    pcall(function()
        root = game:GetService("CoreGui")
    end)
    if not root then
        return
    end
    local function wipeGui(name)
        local seen = {}
        local function kill(parent)
            if not parent or seen[parent] then return end
            seen[parent] = true
            local o = parent:FindFirstChild(name)
            if o then o:Destroy() end
        end
        kill(root)
        kill(LocalPlayer:FindFirstChild("PlayerGui"))
    end
    wipeGui("SabcomLite")
    wipeGui("sabcom lite")
    if _G.__Elite_PsKickConn then
        pcall(function() _G.__Elite_PsKickConn:Disconnect() end)
        _G.__Elite_PsKickConn = nil
    end
    local g = Instance.new("ScreenGui")
    g.Name = "SabcomLite"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.DisplayOrder = 210
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        g.Parent = root
    end)

    local COL_CARD = Color3.fromRGB(16, 16, 18)
    local COL_OFF = Color3.fromRGB(26, 26, 30)
    local COL_ON = Color3.fromRGB(240, 240, 244)
    local COL_ACCENT = Color3.fromRGB(240, 240, 244)
    local COL_TEXT = Color3.fromRGB(235, 235, 238)
    local COL_MUTED = Color3.fromRGB(148, 148, 156)
    local COL_STROKE = Color3.fromRGB(255, 255, 255)
    local COL_ON_STROKE = Color3.fromRGB(255, 255, 255)
    local COL_BTN_H = Color3.fromRGB(40, 40, 46)
    local COL_INK = Color3.fromRGB(10, 10, 12)
    local COL_GREEN = Color3.fromRGB(235, 235, 238)
    local COL_PINK = Color3.fromRGB(240, 240, 244)
    local function uiCorner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 12)
        c.Parent = p
        return c
    end
    local function uiStroke(p, color, thick, trans)
        local s = Instance.new("UIStroke")
        s.Color = color or COL_STROKE
        s.Thickness = thick or 1
        s.Transparency = trans or 0.86
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = p
        return s
    end
    do
        local Stats = game:GetService("Stats")
        local saved = _G.Elite_UiPos
        local wmPos = UDim2.new(0.5, 0, 0, 10)
        if type(saved) == "table" and type(saved.Watermark) == "table" and saved.Watermark[2] ~= nil then
            local q = saved.Watermark
            wmPos = UDim2.new(q[1] or 0, q[2], q[3] or 0, q[4])
        end
        local wm = Instance.new("Frame")
        wm.Name = "Watermark"
        wm.Size = UDim2.fromOffset(214, 36)
        wm.Position = wmPos
        wm.AnchorPoint = Vector2.new(0.5, 0)
        wm.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        wm.BackgroundTransparency = 0.04
        wm.BorderSizePixel = 0
        wm.ZIndex = 30
        wm.Active = false
        wm.Parent = g
        uiCorner(wm, 10)
        uiStroke(wm, Color3.fromRGB(255, 255, 255), 1, 0.86)
        local inner = Instance.new("Frame")
        inner.Name = "Content"
        inner.BackgroundTransparency = 1
        inner.Size = UDim2.fromOffset(0, 36)
        inner.AutomaticSize = Enum.AutomaticSize.X
        inner.ZIndex = 31
        inner.Parent = wm
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 12)
        pad.Parent = inner
        local lay = Instance.new("UIListLayout")
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.VerticalAlignment = Enum.VerticalAlignment.Center
        lay.Padding = UDim.new(0, 8)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = inner
        local logoSlot = Instance.new("Frame")
        logoSlot.Name = "Logo"
        logoSlot.Size = UDim2.fromOffset(22, 22)
        logoSlot.BackgroundTransparency = 1
        logoSlot.BorderSizePixel = 0
        logoSlot.ClipsDescendants = true
        logoSlot.LayoutOrder = 1
        logoSlot.ZIndex = 32
        logoSlot.Parent = inner
        local logo = Instance.new("ImageLabel")
        logo.AnchorPoint = Vector2.new(0.5, 0.5)
        logo.Position = UDim2.fromScale(0.5, 0.5)
        logo.Size = UDim2.fromScale(1, 1)
        logo.BackgroundTransparency = 1
        logo.BorderSizePixel = 0
        logo.Image = "rbxassetid://129609531856661"
        logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
        logo.ScaleType = Enum.ScaleType.Stretch
        logo.ZIndex = 34
        logo.Parent = logoSlot
        local function wmText(order, color)
            local t = Instance.new("TextLabel")
            t.AutomaticSize = Enum.AutomaticSize.X
            t.Size = UDim2.fromOffset(0, 20)
            t.BackgroundTransparency = 1
            t.Font = Enum.Font.GothamMedium
            t.TextSize = 12
            t.TextColor3 = color or COL_TEXT
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextYAlignment = Enum.TextYAlignment.Center
            t.LayoutOrder = order
            t.ZIndex = 32
            t.Parent = inner
            return t
        end
        local nameLbl = wmText(2)
        local fpsLbl = wmText(3, COL_MUTED)
        local msLbl = wmText(4, COL_MUTED)
        nameLbl.Text = "sabcom lite"
        fpsLbl.Text = "-- fps"
        msLbl.Text = "-- ms"
        local function fitWm()
            local w = math.max(168, inner.AbsoluteSize.X)
            wm.Size = UDim2.fromOffset(w, 36)
        end
        inner:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitWm)
        task.defer(fitWm)
        local frames, elapsed, spin = 0, 0, 0
        local function pingMs()
            local ping = 0
            pcall(function()
                ping = game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000
            end)
            pcall(function()
                local item = Stats.Network.ServerStatsItem["Data Ping"]
                if item then
                    ping = item:GetValue()
                end
            end)
            return tonumber(ping) or 0
        end
        game:GetService("RunService").RenderStepped:Connect(function(dt)
            spin += dt * 2.05
            if logo and logo.Parent then
                local c = math.cos(spin)
                logo.Rotation = 0
                logo.Size = UDim2.fromScale(math.max(0.08, math.abs(c)), 1)
                logo.Position = UDim2.fromScale(0.5, 0.5)
                local lit = 0.55 + 0.45 * math.abs(c)
                logo.ImageColor3 = Color3.new(lit, lit, lit)
            end
            frames += 1
            elapsed += dt
            if elapsed < 0.4 then return end
            fpsLbl.Text = tostring(math.floor((frames / elapsed) + 0.5)) .. " fps"
            msLbl.Text = string.format("%.2f ms", pingMs())
            frames, elapsed = 0, 0
            fitWm()
        end)
    end
    local function setOnLook(b, on)
        b:SetAttribute("On", on == true)
        b.BackgroundColor3 = on and COL_ON or COL_OFF
        b.TextColor3 = on and COL_INK or COL_TEXT
        local st = b:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and COL_ON_STROKE or COL_STROKE
            st.Transparency = on and 0.55 or 0.86
            st.Thickness = 1
        end
    end
    local keys = _G.Elite_Keybinds
    if type(keys) ~= "table" then
        keys = _G.elite_Keybinds
    end
    if type(keys) ~= "table" then
        keys = {}
    end
    _G.Elite_Keybinds = keys
    keys.ToolSpeed = nil
    keys.CarpetSpeedOn = nil
    keys.WaveriderSpeedEnabled = nil
    if type(keys.StealNearest) ~= "string" or keys.StealNearest == "" then
        keys.StealNearest = tostring(Config.StealNearestKey or "T")
    end
    if type(keys.AutoClone) ~= "string" or keys.AutoClone == "" then
        keys.AutoClone = "V"
    end
    if type(keys.OpenGui) ~= "string" or keys.OpenGui == "" then
        keys.OpenGui = "G"
    end
    if type(keys.CarpetSpeed) ~= "string" or keys.CarpetSpeed == "" then
        keys.CarpetSpeed = "Q"
    end
    if type(keys.InstantReset) ~= "string" or keys.InstantReset == "" then
        keys.InstantReset = "K"
    end
    do
        local d = tonumber(keys.InvStealDelay)
        if d then
            Config.InvStealDelay = math.clamp(d, 0, 5)
        else
            Config.InvStealDelay = math.clamp(tonumber(Config.InvStealDelay) or 0.5, 0, 5)
            keys.InvStealDelay = Config.InvStealDelay
        end
        _G.EliteInvisAutoDelay = Config.InvStealDelay
    end
    Config.Keybinds = keys
    Config.StealNearestKey = keys.StealNearest
    Config.WaveriderSpeed = 140
    Config.WaveriderSpeedEnabled = false
    local listening = nil
    local uiPos = _G.Elite_UiPos
    if type(uiPos) ~= "table" then
        uiPos = _G.elite_UiPos
    end
    if type(uiPos) ~= "table" then
        uiPos = {}
    end
    _G.Elite_UiPos = uiPos
    local function savePos(name, frame)
        local p = frame.Position
        uiPos[name] = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end
    local function loadPos(name, fallback)
        local p = uiPos[name]
        if type(p) == "table" and p[2] ~= nil then
            return UDim2.new(p[1] or 0, p[2], p[3] or 0, p[4])
        end
        return fallback
    end
    local function makeDrag(frame, handle, name)
        local dragging, origin, startPos
        handle.Active = true
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                origin = i.Position
                startPos = frame.Position
                local conn
                conn = i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        savePos(name, frame)
                        conn:Disconnect()
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - origin
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end
    local function makePanel(o)
        local headH = o.sub and 50 or 40
        local f = Instance.new("Frame")
        f.Name = o.name
        f.Size = o.h and UDim2.fromOffset(o.w, o.h) or UDim2.fromOffset(o.w, 0)
        if not o.h then
            f.AutomaticSize = Enum.AutomaticSize.Y
        end
        f.Position = o.pos
        f.BackgroundColor3 = COL_CARD
        f.BackgroundTransparency = 0.04
        f.BorderSizePixel = 0
        f.Active = true
        f.Visible = o.visible ~= false
        f.ZIndex = o.z or 1
        f.Parent = g
        uiCorner(f, 12)
        uiStroke(f, COL_STROKE, 1, 0.86)
        local rail = Instance.new("Frame")
        rail.Size = UDim2.fromOffset(3, o.sub and 28 or 18)
        rail.Position = UDim2.fromOffset(12, o.sub and 12 or 11)
        rail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        rail.BackgroundTransparency = 0.45
        rail.BorderSizePixel = 0
        rail.ZIndex = (o.z or 1) + 1
        rail.Parent = f
        uiCorner(rail, 2)
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, o.badge and -108 or -40, 0, o.sub and 20 or 34)
        title.Position = UDim2.fromOffset(22, o.sub and 8 or 3)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextColor3 = COL_TEXT
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = o.title
        title.Active = true
        title.ZIndex = (o.z or 1) + 1
        title.Parent = f
        if o.sub then
            local sub = Instance.new("TextLabel")
            sub.BackgroundTransparency = 1
            sub.Size = UDim2.new(1, o.badge and -108 or -40, 0, 14)
            sub.Position = UDim2.fromOffset(22, 28)
            sub.Font = Enum.Font.Gotham
            sub.TextSize = 11
            sub.TextColor3 = COL_MUTED
            sub.TextXAlignment = Enum.TextXAlignment.Left
            sub.Text = o.sub
            sub.ZIndex = (o.z or 1) + 1
            sub.Parent = f
        end
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.86
        line.BorderSizePixel = 0
        line.Position = UDim2.fromOffset(12, headH - 2)
        line.Size = UDim2.new(1, -24, 0, 1)
        line.Parent = f
        local fade = Instance.new("UIGradient")
        fade.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.55, 0.7),
            NumberSequenceKeypoint.new(1, 1),
        })
        fade.Parent = line
        local body = Instance.new("Frame")
        body.Name = "Body"
        body.BackgroundTransparency = 1
        body.Position = UDim2.fromOffset(0, headH)
        if o.h then
            body.Size = UDim2.new(1, 0, 1, -headH)
        else
            body.Size = UDim2.new(1, 0, 0, 0)
            body.AutomaticSize = Enum.AutomaticSize.Y
        end
        body.Parent = f
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 7)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = body
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = body
        makeDrag(f, title, o.name)
        return f, body
    end

    local panel, panelBody = makePanel({
        name = "Main",
        title = "Sabcom",
        sub = "Menu",
        w = 248,
        pos = loadPos("Main", UDim2.new(1, -264, 0, 72)),
    })
    panel.ClipsDescendants = true

    local tgt, tgtBody = makePanel({
        name = "Targets",
        title = "Sabcom",
        sub = "Steal Target",
        badge = true,
        w = 308,
        h = 460,
        pos = loadPos("Targets", UDim2.new(1, -528, 0, 72)),
    })
    tgtBody.Visible = false
    local foundBadge = Instance.new("Frame")
    foundBadge.Size = UDim2.fromOffset(72, 22)
    foundBadge.Position = UDim2.new(1, -82, 0, 12)
    foundBadge.BackgroundColor3 = COL_OFF
    foundBadge.BorderSizePixel = 0
    foundBadge.ZIndex = 3
    foundBadge.Parent = tgt
    uiCorner(foundBadge, 11)
    uiStroke(foundBadge, COL_STROKE, 1, 0.86)
    local foundLbl = Instance.new("TextLabel")
    foundLbl.BackgroundTransparency = 1
    foundLbl.Size = UDim2.fromScale(1, 1)
    foundLbl.Font = Enum.Font.GothamBold
    foundLbl.TextSize = 10
    foundLbl.TextColor3 = COL_TEXT
    foundLbl.Text = "0 found"
    foundLbl.ZIndex = 4
    foundLbl.Parent = foundBadge

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "List"
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.fromOffset(10, 56)
    scroll.Size = UDim2.new(1, -20, 1, -124)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = COL_ACCENT
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = tgt
    local slay = Instance.new("UIListLayout")
    slay.Padding = UDim.new(0, 6)
    slay.SortOrder = Enum.SortOrder.LayoutOrder
    slay.Parent = scroll
    local empty = Instance.new("TextLabel")
    empty.BackgroundTransparency = 1
    empty.Size = UDim2.new(1, 0, 0, 36)
    empty.Font = Enum.Font.Gotham
    empty.TextSize = 11
    empty.TextColor3 = COL_MUTED
    empty.TextWrapped = true
    empty.Text = "No priority brainrots"
    empty.Parent = scroll

    local barCard = Instance.new("Frame")
    barCard.Name = "StealBar"
    barCard.Size = UDim2.new(1, -20, 0, 58)
    barCard.Position = UDim2.new(0, 10, 1, -66)
    barCard.BackgroundColor3 = COL_OFF
    barCard.BorderSizePixel = 0
    barCard.Parent = tgt
    uiCorner(barCard, 10)
    uiStroke(barCard, COL_STROKE, 1, 0.86)
    local barName = Instance.new("TextLabel")
    barName.BackgroundTransparency = 1
    barName.Position = UDim2.fromOffset(10, 6)
    barName.Size = UDim2.new(1, -20, 0, 16)
    barName.Font = Enum.Font.GothamBold
    barName.TextSize = 12
    barName.TextColor3 = COL_TEXT
    barName.TextXAlignment = Enum.TextXAlignment.Left
    barName.TextTruncate = Enum.TextTruncate.AtEnd
    barName.Text = "Idle"
    barName.Parent = barCard
    local barStatus = Instance.new("TextLabel")
    barStatus.BackgroundTransparency = 1
    barStatus.Position = UDim2.fromOffset(10, 24)
    barStatus.Size = UDim2.new(0.55, 0, 0, 12)
    barStatus.Font = Enum.Font.GothamMedium
    barStatus.TextSize = 10
    barStatus.TextColor3 = COL_MUTED
    barStatus.TextXAlignment = Enum.TextXAlignment.Left
    barStatus.Text = "Waiting"
    barStatus.Parent = barCard
    local barPct = Instance.new("TextLabel")
    barPct.BackgroundTransparency = 1
    barPct.Position = UDim2.new(1, -52, 0, 24)
    barPct.Size = UDim2.fromOffset(42, 12)
    barPct.Font = Enum.Font.GothamBold
    barPct.TextSize = 10
    barPct.TextColor3 = COL_MUTED
    barPct.TextXAlignment = Enum.TextXAlignment.Right
    barPct.Text = ""
    barPct.Parent = barCard
    local barTrack = Instance.new("Frame")
    barTrack.Position = UDim2.fromOffset(10, 42)
    barTrack.Size = UDim2.new(1, -20, 0, 6)
    barTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
    barTrack.BorderSizePixel = 0
    barTrack.ClipsDescendants = true
    barTrack.Parent = barCard
    uiCorner(barTrack, 99)
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.fromScale(0, 1)
    barFill.BackgroundColor3 = COL_PINK
    barFill.BorderSizePixel = 0
    barFill.Parent = barTrack
    uiCorner(barFill, 99)
    local barTw, barGen = nil, 0
    local TweenService = game:GetService("TweenService")
    local function barSet(name, status, color, scale, pct)
        barName.Text = name or "Idle"
        barStatus.Text = status or "Waiting"
        barStatus.TextColor3 = color or COL_MUTED
        barFill.BackgroundColor3 = color or COL_PINK
        barFill.Size = UDim2.fromScale(math.clamp(tonumber(scale) or 0, 0, 1), 1)
        barPct.Text = pct or ""
    end
    _G.Elite_PanelBar = {
        show = function(name, dur)
            barGen += 1
            local gen = barGen
            if barTw then pcall(function() barTw:Cancel() end) end
            barSet(name, "Grabbing", COL_PINK, 0, "0%")
            barTw = TweenService:Create(barFill, TweenInfo.new(tonumber(dur) or 1.3, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(1, 1) })
            barTw:Play()
            task.spawn(function()
                local t0 = os.clock()
                local hold = tonumber(dur) or 1.3
                while gen == barGen and os.clock() - t0 < hold do
                    local p = math.clamp((os.clock() - t0) / hold, 0, 1)
                    barPct.Text = string.format("%d%%", math.floor(p * 100 + 0.5))
                    task.wait(0.05)
                end
            end)
        end,
        hide = function()
            barGen += 1
            if barTw then pcall(function() barTw:Cancel() end); barTw = nil end
            barSet("Idle", "Waiting", COL_MUTED, 0, "")
        end,
        carry = function(name)
            barGen += 1
            if barTw then pcall(function() barTw:Cancel() end); barTw = nil end
            barSet(name, "Carrying", COL_GREEN, 1, "")
        end,
    }

    local tgtRows = {}
    local function petKey(p)
        if not p then return "" end
        local traits = ""
        if type(p.traits) == "table" then
            traits = table.concat(p.traits, ",")
        end
        return tostring(p.plot) .. "|" .. tostring(p.slot) .. "|" .. tostring(p.index or p.name) .. "|" .. tostring(p.mutation or "") .. "|" .. traits
    end
    local function currentKey()
        return petKey(_G.Elite_StealTarget)
    end
    local function fmtGen(n)
        n = tonumber(n) or 0
        if n >= 1e12 then return string.format("$%.1fT/s", n / 1e12)
        elseif n >= 1e9 then return string.format("$%.1fB/s", n / 1e9)
        elseif n >= 1e6 then return string.format("$%.1fM/s", n / 1e6)
        elseif n >= 1e3 then return string.format("$%.1fK/s", n / 1e3)
        else return string.format("$%.0f/s", n) end
    end
    local MUT_COL = {
        gold = Color3.fromRGB(255, 200, 70),
        diamond = Color3.fromRGB(120, 220, 255),
        cyber = Color3.fromRGB(90, 170, 255),
        rainbow = Color3.fromRGB(255, 120, 200),
        bloodrot = Color3.fromRGB(220, 70, 80),
        lava = Color3.fromRGB(255, 110, 50),
        galaxy = Color3.fromRGB(170, 110, 255),
        ["yin yang"] = Color3.fromRGB(230, 230, 240),
        yinyang = Color3.fromRGB(230, 230, 240),
        divine = Color3.fromRGB(255, 230, 140),
    }
    local function mutColor(mut)
        local k = string.lower(tostring(mut or ""))
        return MUT_COL[k] or COL_MUTED
    end
    local function paintTargetRow(row, on, who)
        row.BackgroundColor3 = on and Color3.fromRGB(40, 40, 46) or COL_OFF
        local rail = row:FindFirstChild("SelectRail")
        if rail then
            rail.BackgroundTransparency = on and 0 or 1
        end
        local pill = row:FindFirstChild("Taken")
        if pill then
            local show = type(who) == "string" and who ~= ""
            pill.Visible = show
            local lbl = pill:FindFirstChild("Who")
            if lbl and show then
                lbl.Text = "taken by " .. who
            end
        end
    end
    local function mkTargetRow(pet, order)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -2, 0, 56)
        b.BackgroundColor3 = COL_OFF
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = order
        b.ClipsDescendants = true
        b.Parent = scroll
        uiCorner(b, 8)
        local rail = Instance.new("Frame")
        rail.Name = "SelectRail"
        rail.Size = UDim2.new(0, 2, 1, -12)
        rail.Position = UDim2.fromOffset(0, 6)
        rail.BackgroundColor3 = COL_ACCENT
        rail.BackgroundTransparency = 1
        rail.BorderSizePixel = 0
        rail.Parent = b
        uiCorner(rail, 2)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingTop = UDim.new(0, 7)
        pad.PaddingBottom = UDim.new(0, 7)
        pad.Parent = b

        local rank = Instance.new("TextLabel")
        rank.BackgroundTransparency = 1
        rank.Size = UDim2.fromOffset(20, 20)
        rank.Position = UDim2.fromOffset(0, 1)
        rank.Font = Enum.Font.GothamBold
        rank.TextSize = 12
        rank.TextColor3 = COL_ACCENT
        rank.TextXAlignment = Enum.TextXAlignment.Center
        rank.Text = tostring(order)
        rank.Parent = b

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Size = UDim2.new(1, -96, 0, 18)
        name.Position = UDim2.fromOffset(24, 1)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 13
        name.TextColor3 = COL_TEXT
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Text = tostring(pet.name or pet.index or "?")
        name.Parent = b

        local genLbl = Instance.new("TextLabel")
        genLbl.BackgroundTransparency = 1
        genLbl.Size = UDim2.fromOffset(72, 18)
        genLbl.Position = UDim2.new(1, -72, 0, 1)
        genLbl.Font = Enum.Font.GothamBold
        genLbl.TextSize = 11
        genLbl.TextColor3 = COL_ACCENT
        genLbl.TextXAlignment = Enum.TextXAlignment.Right
        genLbl.TextTruncate = Enum.TextTruncate.AtEnd
        genLbl.Text = (tonumber(pet.mps) or 0) > 0 and fmtGen(pet.mps) or ""
        genLbl.Parent = b

        local meta = Instance.new("Frame")
        meta.BackgroundTransparency = 1
        meta.Size = UDim2.new(1, -24, 0, 18)
        meta.Position = UDim2.fromOffset(24, 24)
        meta.Parent = b
        local metaLay = Instance.new("UIListLayout")
        metaLay.FillDirection = Enum.FillDirection.Horizontal
        metaLay.VerticalAlignment = Enum.VerticalAlignment.Center
        metaLay.Padding = UDim.new(0, 6)
        metaLay.SortOrder = Enum.SortOrder.LayoutOrder
        metaLay.Parent = meta

        local mut = tostring(pet.mutation or "")
        if mut ~= "" and mut ~= "None" then
            local chip = Instance.new("Frame")
            chip.AutomaticSize = Enum.AutomaticSize.X
            chip.Size = UDim2.fromOffset(0, 16)
            chip.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
            chip.BorderSizePixel = 0
            chip.LayoutOrder = 1
            chip.Parent = meta
            uiCorner(chip, 6)
            local chipPad = Instance.new("UIPadding")
            chipPad.PaddingLeft = UDim.new(0, 6)
            chipPad.PaddingRight = UDim.new(0, 6)
            chipPad.Parent = chip
            local mutLbl = Instance.new("TextLabel")
            mutLbl.AutomaticSize = Enum.AutomaticSize.X
            mutLbl.Size = UDim2.fromOffset(0, 16)
            mutLbl.BackgroundTransparency = 1
            mutLbl.Font = Enum.Font.GothamBold
            mutLbl.TextSize = 10
            mutLbl.TextColor3 = mutColor(mut)
            mutLbl.Text = mut
            mutLbl.Parent = chip
        end

        local icons = Instance.new("Frame")
        icons.AutomaticSize = Enum.AutomaticSize.X
        icons.Size = UDim2.fromOffset(0, 16)
        icons.BackgroundTransparency = 1
        icons.LayoutOrder = 2
        icons.Parent = meta
        local icLay = Instance.new("UIListLayout")
        icLay.FillDirection = Enum.FillDirection.Horizontal
        icLay.VerticalAlignment = Enum.VerticalAlignment.Center
        icLay.Padding = UDim.new(0, 4)
        icLay.SortOrder = Enum.SortOrder.LayoutOrder
        icLay.Parent = icons
        local function addIcon(asset, idx)
            if not asset then return end
            local img = Instance.new("ImageLabel")
            img.BackgroundTransparency = 1
            img.Size = UDim2.fromOffset(14, 14)
            img.Image = asset
            img.ScaleType = Enum.ScaleType.Fit
            img.LayoutOrder = idx
            img.Parent = icons
        end
        addIcon(pet.mutIcon, 1)
        if type(pet.traitIcons) == "table" then
            for i = 1, math.min(#pet.traitIcons, 4) do
                addIcon(pet.traitIcons[i], i + 1)
            end
        end

        local owner = pet.owner and ("@" .. tostring(pet.owner)) or ""
        if owner ~= "" then
            local own = Instance.new("TextLabel")
            own.AutomaticSize = Enum.AutomaticSize.X
            own.Size = UDim2.fromOffset(0, 16)
            own.BackgroundTransparency = 1
            own.Font = Enum.Font.Gotham
            own.TextSize = 10
            own.TextColor3 = COL_MUTED
            own.Text = owner
            own.LayoutOrder = 3
            own.Parent = meta
        end

        local taken = Instance.new("Frame")
        taken.Name = "Taken"
        taken.AnchorPoint = Vector2.new(1, 1)
        taken.Position = UDim2.new(1, -6, 1, -5)
        taken.Size = UDim2.fromOffset(0, 16)
        taken.AutomaticSize = Enum.AutomaticSize.X
        taken.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
        taken.BorderSizePixel = 0
        taken.Visible = false
        taken.ZIndex = 3
        taken.Parent = b
        uiCorner(taken, 8)
        local takenPad = Instance.new("UIPadding")
        takenPad.PaddingLeft = UDim.new(0, 6)
        takenPad.PaddingRight = UDim.new(0, 6)
        takenPad.Parent = taken
        local takenLbl = Instance.new("TextLabel")
        takenLbl.Name = "Who"
        takenLbl.BackgroundTransparency = 1
        takenLbl.AutomaticSize = Enum.AutomaticSize.X
        takenLbl.Size = UDim2.fromOffset(0, 16)
        takenLbl.Font = Enum.Font.GothamMedium
        takenLbl.TextSize = 10
        takenLbl.TextColor3 = COL_TEXT
        takenLbl.Text = ""
        takenLbl.ZIndex = 4
        takenLbl.Parent = taken

        b.MouseButton1Click:Connect(function()
            if _G.Elite_SwitchStealTarget then
                pcall(_G.Elite_SwitchStealTarget, pet)
            end
        end)
        return b
    end
    local lastSig = ""
    local function refreshTargets()
        local pets = {}
        if _G.Elite_ListPrioPets then
            local ok, listed = pcall(_G.Elite_ListPrioPets)
            if ok and type(listed) == "table" then
                pets = listed
            end
        end
        foundLbl.Text = #pets .. " found"
        local sig = {}
        for i = 1, #pets do
            sig[i] = petKey(pets[i])
        end
        local now = table.concat(sig, ";")
        if now ~= lastSig then
            lastSig = now
            for i = 1, #tgtRows do
                if tgtRows[i] then tgtRows[i]:Destroy() end
            end
            tgtRows = {}
            empty.Visible = #pets == 0
            for i = 1, #pets do
                tgtRows[i] = mkTargetRow(pets[i], i)
            end
        end
        local cur = currentKey()
        local stealing = LocalPlayer:GetAttribute("Stealing") == true
        for i = 1, #tgtRows do
            local pet = pets[i]
            local who
            if stealing and sig[i] == cur then
                who = LocalPlayer.Name
            elseif pet and _G.Elite_TakenBy then
                local ok, name = pcall(_G.Elite_TakenBy, pet)
                if ok and type(name) == "string" and name ~= "" then
                    who = name
                end
            end
            paintTargetRow(tgtRows[i], sig[i] == cur, who)
        end
        if stealing then
            local pet = _G.Elite_StealTarget
            local n = pet and (pet.name or pet.index) or "Brainrot"
            if barStatus.Text ~= "Carrying" or barName.Text ~= n then
                if _G.Elite_PanelBar and _G.Elite_PanelBar.carry then
                    pcall(_G.Elite_PanelBar.carry, n)
                end
            end
        elseif _G.__Elite_HoldActive ~= true
            and (barStatus.Text == "Grabbing" or barStatus.Text == "Carrying") then
            if _G.Elite_PanelBar and _G.Elite_PanelBar.hide then
                pcall(_G.Elite_PanelBar.hide)
            end
        end
    end
    _G.Elite_OnStealTarget = function()
        pcall(refreshTargets)
    end
    task.spawn(function()
        while scroll and scroll.Parent do
            pcall(refreshTargets)
            task.wait(0.4)
        end
    end)

    local OFF = COL_OFF
    local ON = COL_ON
    local function mkBtn(text, parent)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 32)
        b.BackgroundColor3 = OFF
        b.TextColor3 = COL_TEXT
        b.Text = text
        b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.TextTruncate = Enum.TextTruncate.AtEnd
    b.ClipsDescendants = true
    b.AutoButtonColor = false
        b.Parent = parent or panelBody
        uiCorner(b, 10)
        uiStroke(b)
        b.MouseEnter:Connect(function()
            if b:GetAttribute("On") then return end
            b.BackgroundColor3 = COL_BTN_H
        end)
        b.MouseLeave:Connect(function()
            if b:GetAttribute("On") then
                b.BackgroundColor3 = COL_ON
            else
                b.BackgroundColor3 = COL_OFF
            end
        end)
        return b
    end
    local function paint(b, label, on)
        setOnLook(b, on)
        b.Text = label .. "  " .. (on and "ON" or "OFF")
    end

    local actionGrid = Instance.new("Frame")
    actionGrid.Name = "Actions"
    actionGrid.BackgroundTransparency = 1
    actionGrid.Size = UDim2.new(1, 0, 0, 71)
    actionGrid.LayoutOrder = 1
    actionGrid.Parent = panelBody
    local actionLay = Instance.new("UIGridLayout")
    actionLay.CellPadding = UDim2.fromOffset(6, 6)
    actionLay.CellSize = UDim2.new(0.5, -8, 0, 32)
    actionLay.SortOrder = Enum.SortOrder.LayoutOrder
    actionLay.Parent = actionGrid

    local bSteal = mkBtn("Steal Nearest", actionGrid)
    bSteal.LayoutOrder = 1
    bSteal.Text = "Steal Nearest"
    _G.Elite_NearestBtn = bSteal
    bSteal.MouseButton1Click:Connect(function()
        pcall(_G.Elite_StealNearestPrio)
    end)

    local TP_TOOLS = _G.Elite_TpTools or {
        "Waverider",
        "Flying Carpet",
        "Witch's Broom",
        "Santa's Sleigh",
        "Cupid's Wings",
    }
    local TOOL_SHORT = {
        ["Waverider"] = "WAVERIDER",
        ["Flying Carpet"] = "FLY CARPET",
        ["Witch's Broom"] = "BROOM",
        ["Santa's Sleigh"] = "SLEIGH",
        ["Cupid's Wings"] = "WINGS",
    }
    local function currentTool()
        return (Config.TpSettings and Config.TpSettings.Tool) or _G.Elite_CarpetTool or "Waverider"
    end
    local toolBtns = {}
    local function setSelectedTool(name)
        if _G.Elite_SetCarpetTool then
            pcall(_G.Elite_SetCarpetTool, name)
        else
            Config.TpSettings.Tool = name
            _G.Elite_CarpetTool = name
        end
        if _G.Elite_OnCarpetTool then
            pcall(_G.Elite_OnCarpetTool, name)
        end
        if _G.__Elite_SyncMenu then
            pcall(_G.__Elite_SyncMenu)
        end
    end
    local function paintTool()
        local cur = currentTool()
        for name, b in pairs(toolBtns) do
            setOnLook(b, name == cur)
        end
    end
    _G.Elite_OnCarpetTool = paintTool

    local function speedTitle()
        return tostring(currentTool()) .. " Speed"
    end
    local bClone = mkBtn("Auto Clone", actionGrid)
    bClone.LayoutOrder = 2
    local bCarpet = mkBtn("Waverider Speed", actionGrid)
    bCarpet.LayoutOrder = 3
    local bReset = mkBtn("Reset", actionGrid)
    bReset.LayoutOrder = 4
    bReset.MouseButton1Click:Connect(function()
        pcall(_G.Elite_InstantReset)
    end)

    local function mkSlide(parent, label, minV, maxV, get, set, fmt, order)
        local hold = Instance.new("Frame")
        hold.Size = UDim2.new(1, 0, 0, 28)
        hold.BackgroundTransparency = 1
        hold.LayoutOrder = order or 0
        hold.Parent = parent
        local lab = Instance.new("TextLabel")
        lab.Size = UDim2.new(1, 0, 0, 14)
        lab.BackgroundTransparency = 1
        lab.TextColor3 = COL_MUTED
        lab.Font = Enum.Font.GothamMedium
        lab.TextSize = 10
        lab.TextXAlignment = Enum.TextXAlignment.Left
        lab.Parent = hold
        local sbar = Instance.new("Frame")
        sbar.Size = UDim2.new(1, 0, 0, 6)
        sbar.Position = UDim2.fromOffset(0, 16)
        sbar.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
        sbar.BorderSizePixel = 0
        sbar.Parent = hold
        uiCorner(sbar, 99)
        local sfill = Instance.new("Frame")
        sfill.Size = UDim2.new(0.5, 0, 1, 0)
        sfill.BackgroundColor3 = COL_ACCENT
        sfill.BorderSizePixel = 0
        sfill.Parent = sbar
        uiCorner(sfill, 99)
        local dragging = false
        local function apply(v)
            v = math.clamp(tonumber(v) or minV, minV, maxV)
            set(v)
            sfill.Size = UDim2.new((v - minV) / math.max(0.001, maxV - minV), 0, 1, 0)
            lab.Text = label .. ": " .. fmt(v)
        end
        apply(get())
        sbar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                local rel = math.clamp((i.Position.X - sbar.AbsolutePosition.X) / math.max(1, sbar.AbsoluteSize.X), 0, 1)
                apply(minV + (maxV - minV) * rel)
            end
        end)
        return {
            apply = apply,
            bar = sbar,
            isDrag = function() return dragging end,
            setDrag = function(v) dragging = v end,
            minV = minV,
            maxV = maxV,
        }
    end
    local invis, invisBody = makePanel({
        name = "Invis",
        title = "Invis",
        w = 186,
        pos = loadPos("Invis", UDim2.fromOffset(16, 72)),
    })
    local bInv = mkBtn("Auto Invis", invisBody)
    bInv.LayoutOrder = 1
    local rotSlide = mkSlide(invisBody, "Rotation", 0, 360, function()
        return tonumber(_G.EliteInvisAngle) or Config.InvStealAngle or 220
    end, function(v)
        Config.InvStealAngle = v
        _G.EliteInvisAngle = v
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end, function(v)
        return tostring(math.floor(v + 0.5))
    end, 3)
    local depSlide = mkSlide(invisBody, "Depth", 0, 10, function()
        return tonumber(_G.EliteInvisDepth) or Config.InvStealDepth or 10
    end, function(v)
        Config.InvStealDepth = v
        _G.EliteInvisDepth = v
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end, function(v)
        return string.format("%.1f", v)
    end, 4)
    local delaySlide = mkSlide(invisBody, "Delay", 0, 5, function()
        return tonumber(_G.EliteInvisAutoDelay) or tonumber(keys.InvStealDelay) or Config.InvStealDelay or 0.5
    end, function(v)
        v = math.clamp(tonumber(v) or 0.5, 0, 5)
        Config.InvStealDelay = v
        keys.InvStealDelay = v
        _G.EliteInvisAutoDelay = v
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end, function(v)
        return string.format("%.2fs", v)
    end, 5)
    local angRow = Instance.new("Frame")
    angRow.Size = UDim2.new(1, 0, 0, 24)
    angRow.BackgroundTransparency = 1
    angRow.LayoutOrder = 6
    angRow.Parent = invisBody
    local function mkAng(xScale, deg, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.5, -3, 1, 0)
        b.Position = UDim2.new(xScale, xScale > 0 and 3 or 0, 0, 0)
        b.BackgroundColor3 = OFF
        b.TextColor3 = COL_TEXT
        b.Text = txt
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Parent = angRow
        uiCorner(b, 8)
        uiStroke(b)
        b.MouseButton1Click:Connect(function()
            rotSlide.apply(deg)
        end)
        return b
    end
    mkAng(0, 180, "180")
    mkAng(0.5, 220, "220")
    paint(bInv, "Auto Invis", Config.InvSteal ~= false)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            rotSlide.setDrag(false)
            depSlide.setDrag(false)
            delaySlide.setDrag(false)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            return
        end
        if rotSlide.isDrag() then
            local rel = math.clamp((i.Position.X - rotSlide.bar.AbsolutePosition.X) / math.max(1, rotSlide.bar.AbsoluteSize.X), 0, 1)
            rotSlide.apply(rotSlide.minV + (rotSlide.maxV - rotSlide.minV) * rel)
        end
        if depSlide.isDrag() then
            local rel = math.clamp((i.Position.X - depSlide.bar.AbsolutePosition.X) / math.max(1, depSlide.bar.AbsoluteSize.X), 0, 1)
            depSlide.apply(depSlide.minV + (depSlide.maxV - depSlide.minV) * rel)
        end
        if delaySlide.isDrag() then
            local rel = math.clamp((i.Position.X - delaySlide.bar.AbsolutePosition.X) / math.max(1, delaySlide.bar.AbsoluteSize.X), 0, 1)
            delaySlide.apply(delaySlide.minV + (delaySlide.maxV - delaySlide.minV) * rel)
        end
    end)

    local waveConn
    local carpetOn = false
    local function setCarpetSpeed(on)
        carpetOn = on == true
        Config.WaveriderSpeed = 140
        Config.WaveriderSpeedEnabled = carpetOn
        _G.EliteCarpetSpeed = carpetOn
        if waveConn then
            waveConn:Disconnect()
            waveConn = nil
        end
        if not carpetOn then
            return
        end
        waveConn = RunService.Heartbeat:Connect(function()
            if _G.__Elite_VelFlying or _G.__Elite_TPStarted or _G.isCloning then return end
            local c = LocalPlayer.Character
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            local tn = (Config.TpSettings and Config.TpSettings.Tool) or _G.Elite_CarpetTool or "Waverider"
            local tool = c:FindFirstChild(tn)
            if not tool then
                local tb = LocalPlayer.Backpack:FindFirstChild(tn)
                if not tb then
                    local names = _G.Elite_CarpetNames or TP_TOOLS
                    for i = 1, #names do
                        tb = LocalPlayer.Backpack:FindFirstChild(names[i]) or c:FindFirstChild(names[i])
                        if tb then
                            tn = names[i]
                            tool = c:FindFirstChild(tn) or tb
                            break
                        end
                    end
                else
                    tool = tb
                end
                if tool and tool.Parent ~= c and _G.__Elite_GrappleFired then
                    pcall(function() hum:EquipTool(tool) end)
                    tool = c:FindFirstChild(tn)
                end
            end
            if not tool or tool.Parent ~= c then return end
            local spd = tonumber(Config.WaveriderSpeed) or 140
            local md = hum.MoveDirection
            local y = hrp.AssemblyLinearVelocity.Y
            if md.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * spd, y, md.Z * spd)
            end
        end)
    end
    local function toggleCarpetSpeed()
        setCarpetSpeed(not carpetOn)
        if syncBindLabels then
            syncBindLabels()
        else
            paint(bCarpet, speedTitle() .. " (" .. (keys.CarpetSpeed or "Q") .. ")", carpetOn)
        end
    end

    local infJumpConn, lastJump = nil, 0
    local function startInfiniteJump()
        Config.InfiniteJump = true
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
        infJumpConn = RunService.Heartbeat:Connect(function()
            if _G.__Elite_VelFlying or _G.__Elite_TPStarted then return end
            if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
            local now = tick()
            if now - lastJump < 0.1 then return end
            local c = LocalPlayer.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            lastJump = now
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, 55, v.Z)
        end)
    end

    local function letterOf(input)
        local letter = ""
        pcall(function()
            letter = string.upper(tostring(UIS:GetStringForKeyCode(input.KeyCode) or ""))
        end)
        if letter == "" or letter == " " then
            letter = string.upper(tostring(input.KeyCode and input.KeyCode.Name or ""))
        end
        return letter
    end

    local keysOpen = false
    local bindRows = {}
    local bindDefs = {
        { id = "StealNearest", label = "STEAL NEAREST" },
        { id = "CarpetSpeed", label = "TOOL SPEED" },
        { id = "AutoClone", label = "AUTO CLONE" },
        { id = "InstantReset", label = "INSTANT RESET" },
        { id = "OpenGui", label = "OPEN GUI" },
    }

    local function paintBind(id)
        local row = bindRows[id]
        if not row then return end
        if listening == id then
            row.btn.Text = "..."
            setOnLook(row.btn, true)
            row.btn.BackgroundColor3 = COL_ON
        else
            row.btn.Text = keys[id] or "?"
            setOnLook(row.btn, true)
        end
    end

    local function syncBindLabels()
        bSteal.Text = "Steal Nearest  [" .. (keys.StealNearest or "T") .. "]"
        paint(bCarpet, speedTitle() .. " (" .. (keys.CarpetSpeed or "Q") .. ")", carpetOn)
        paint(bClone, "Auto Clone (" .. (keys.AutoClone or "V") .. ")", Config.AutoClone ~= false)
        paint(bInv, "Auto Invis", Config.InvSteal ~= false)
        bReset.Text = "Reset  [" .. (keys.InstantReset or "K") .. "]"
        local speedRow = bindRows.CarpetSpeed
        if speedRow and speedRow.lab then
            speedRow.lab.Text = string.upper(speedTitle())
        end
        paintTool()
        for i = 1, #bindDefs do
            paintBind(bindDefs[i].id)
        end
    end
    _G.__Elite_SyncMenu = syncBindLabels

    local function applyBind(id, letter)
        keys[id] = letter
        Config.Keybinds = keys
        if id == "StealNearest" then
            Config.StealNearestKey = letter
        end
        listening = nil
        syncBindLabels()
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end

    local function startListen(id)
        listening = (listening == id) and nil or id
        syncBindLabels()
    end

    local openBtn = Instance.new("TextButton")
    openBtn.Name = "OpenGui"
    openBtn.Size = UDim2.fromOffset(88, 30)
    openBtn.Position = loadPos("OpenGui", UDim2.new(1, -116, 1, -64))
    openBtn.BackgroundColor3 = COL_CARD
    openBtn.BackgroundTransparency = 0.04
    openBtn.TextColor3 = COL_TEXT
    openBtn.Font = Enum.Font.GothamMedium
    openBtn.TextSize = 12
    openBtn.Text = "Menu"
    openBtn.AutoButtonColor = false
    openBtn.ZIndex = 8
    openBtn.Active = true
    openBtn.Parent = g
    uiCorner(openBtn, 8)
    uiStroke(openBtn, COL_STROKE, 1, 0.86)
    local openDot = Instance.new("Frame")
    openDot.Size = UDim2.fromOffset(5, 5)
    openDot.Position = UDim2.fromOffset(10, 12)
    openDot.BackgroundColor3 = COL_ACCENT
    openDot.BorderSizePixel = 0
    openDot.ZIndex = 9
    openDot.Parent = openBtn
    uiCorner(openDot, 99)

    local keysFrame, keysBody = makePanel({
        name = "Settings",
        title = "Sabcom",
        sub = "Settings",
        w = 268,
        h = 430,
        pos = loadPos("Settings", UDim2.new(1, -284, 1, -456)),
        visible = false,
        z = 7,
    })
    local settingsTab = "keys"
    local tabBtns = {}
    local keysPage = Instance.new("ScrollingFrame")
    local priPage = Instance.new("Frame")
    local mutPage = Instance.new("Frame")
    local refreshPri, refreshMut
    local function paintTabs()
        for id, b in pairs(tabBtns) do
            setOnLook(b, settingsTab == id)
        end
        keysPage.Visible = settingsTab == "keys"
        priPage.Visible = settingsTab == "pri"
        mutPage.Visible = settingsTab == "mut"
        if settingsTab == "pri" and refreshPri then
            refreshPri()
        elseif settingsTab == "mut" and refreshMut then
            refreshMut()
        end
    end
    local tabRow = Instance.new("Frame")
    tabRow.Size = UDim2.new(1, 0, 0, 28)
    tabRow.BackgroundTransparency = 1
    tabRow.LayoutOrder = 0
    tabRow.ZIndex = 8
    tabRow.Parent = keysBody
    local function mkTab(id, text, i)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1 / 3, -4, 0, 26)
        b.Position = UDim2.new((i - 1) / 3, 2, 0, 1)
        b.BackgroundColor3 = COL_OFF
        b.TextColor3 = COL_TEXT
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.TextTruncate = Enum.TextTruncate.AtEnd
        b.Text = text
        b.AutoButtonColor = false
        b.ZIndex = 9
        b.Parent = tabRow
        uiCorner(b, 8)
        uiStroke(b)
        b.MouseButton1Click:Connect(function()
            settingsTab = id
            listening = nil
            paintTabs()
        end)
        tabBtns[id] = b
        return b
    end
    mkTab("keys", "BINDS", 1)
    mkTab("pri", "PRIORITY", 2)
    mkTab("mut", "MUTATION", 3)
    keysPage.Size = UDim2.new(1, -20, 1, -54)
    keysPage.Position = UDim2.fromOffset(10, 42)
    keysPage.BackgroundTransparency = 1
    keysPage.BorderSizePixel = 0
    keysPage.ScrollBarThickness = 3
    keysPage.ScrollBarImageColor3 = COL_ACCENT
    keysPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    keysPage.CanvasSize = UDim2.new()
    keysPage.LayoutOrder = 1
    keysPage.ZIndex = 8
    keysPage.Parent = keysBody
    do
        local kpad = Instance.new("UIPadding")
        kpad.PaddingBottom = UDim.new(0, 6)
        kpad.Parent = keysPage
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = keysPage
        keysPage.ScrollingDirection = Enum.ScrollingDirection.Y
    end
    local function stylePage(page)
        page.Position = UDim2.fromOffset(10, 42)
        page.Size = UDim2.new(1, -20, 1, -54)
        page.BackgroundTransparency = 1
        page.ClipsDescendants = true
        page.Visible = false
        page.ZIndex = 8
        page.Parent = keysBody
    end
    stylePage(priPage)
    stylePage(mutPage)
    do
        local bodyLay = keysBody:FindFirstChildOfClass("UIListLayout")
        if bodyLay then bodyLay:Destroy() end
        local bodyPad = keysBody:FindFirstChildOfClass("UIPadding")
        if bodyPad then bodyPad:Destroy() end
        tabRow.Position = UDim2.fromOffset(10, 8)
        tabRow.Size = UDim2.new(1, -20, 0, 28)
        keysFrame.ClipsDescendants = true
    end
    local function makeListEditor(page, getList, setList, placeholder)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, -36)
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.BackgroundColor3 = COL_OFF
        scroll.BackgroundTransparency = 0.15
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = COL_ACCENT
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new()
        scroll.ZIndex = 8
        scroll.Parent = page
        uiCorner(scroll, 10)
        uiStroke(scroll)
        local slay = Instance.new("UIListLayout")
        slay.Padding = UDim.new(0, 4)
        slay.SortOrder = Enum.SortOrder.LayoutOrder
        slay.Parent = scroll
        local spad = Instance.new("UIPadding")
        spad.PaddingTop = UDim.new(0, 6)
        spad.PaddingBottom = UDim.new(0, 6)
        spad.PaddingLeft = UDim.new(0, 6)
        spad.PaddingRight = UDim.new(0, 6)
        spad.Parent = scroll
        local addBox = Instance.new("TextBox")
        addBox.Size = UDim2.new(1, -42, 0, 28)
        addBox.Position = UDim2.new(0, 0, 1, -30)
        addBox.BackgroundColor3 = COL_OFF
        addBox.BorderSizePixel = 0
        addBox.Font = Enum.Font.Gotham
        addBox.TextSize = 11
        addBox.TextColor3 = COL_TEXT
        addBox.PlaceholderText = placeholder
        addBox.PlaceholderColor3 = COL_MUTED
        addBox.Text = ""
        addBox.ClearTextOnFocus = false
        addBox.ZIndex = 9
        addBox.Parent = page
        uiCorner(addBox, 8)
        uiStroke(addBox)
        local addBtn = Instance.new("TextButton")
        addBtn.Size = UDim2.fromOffset(32, 28)
        addBtn.Position = UDim2.new(1, -34, 1, -30)
        addBtn.BackgroundColor3 = COL_ON
        addBtn.TextColor3 = COL_INK
        addBtn.Font = Enum.Font.GothamBold
        addBtn.TextSize = 16
        addBtn.Text = "+"
        addBtn.AutoButtonColor = false
        addBtn.ZIndex = 9
        addBtn.Parent = page
        uiCorner(addBtn, 8)
        uiStroke(addBtn, COL_ON_STROKE, 1, 0.35)
        local function refresh()
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("Frame") then
                    ch:Destroy()
                end
            end
            local items = getList()
            for index, name in ipairs(items) do
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -12, 0, 26)
                row.BackgroundColor3 = COL_OFF
                row.BorderSizePixel = 0
                row.LayoutOrder = index
                row.ZIndex = 9
                row.Parent = scroll
                uiCorner(row, 7)
                local lab = Instance.new("TextLabel")
                lab.BackgroundTransparency = 1
                lab.Size = UDim2.new(1, -86, 1, 0)
                lab.Position = UDim2.fromOffset(8, 0)
                lab.Font = Enum.Font.Gotham
                lab.TextSize = 11
                lab.TextColor3 = COL_TEXT
                lab.TextXAlignment = Enum.TextXAlignment.Left
                lab.TextTruncate = Enum.TextTruncate.AtEnd
                lab.Text = tostring(index) .. ". " .. tostring(name)
                lab.ZIndex = 10
                lab.Parent = row
                local function mkTiny(txt, x, fn)
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.fromOffset(22, 20)
                    b.Position = UDim2.new(1, x, 0.5, -10)
                    b.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
                    b.TextColor3 = COL_TEXT
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 11
                    b.Text = txt
                    b.AutoButtonColor = false
                    b.ZIndex = 10
                    b.Parent = row
                    uiCorner(b, 6)
                    b.MouseButton1Click:Connect(fn)
                    return b
                end
                mkTiny("^", -76, function()
                    if index > 1 then
                        items[index], items[index - 1] = items[index - 1], items[index]
                        setList(items)
                        refresh()
                    end
                end)
                mkTiny("v", -52, function()
                    if index < #items then
                        items[index], items[index + 1] = items[index + 1], items[index]
                        setList(items)
                        refresh()
                    end
                end)
                mkTiny("x", -28, function()
                    table.remove(items, index)
                    setList(items)
                    refresh()
                end)
            end
        end
        addBtn.MouseButton1Click:Connect(function()
            local name = string.gsub(string.gsub(addBox.Text, "^%s+", ""), "%s+$", "")
            if name == "" then return end
            local items = getList()
            items[#items + 1] = name
            setList(items)
            addBox.Text = ""
            refresh()
        end)
        return refresh
    end
    refreshPri = makeListEditor(priPage, function()
        if _G.Elite_GetPriorityList then
            return _G.Elite_GetPriorityList()
        end
        return {}
    end, function(items)
        if _G.Elite_SetPriorityList then
            pcall(_G.Elite_SetPriorityList, items)
        end
    end, "add brainrot name")
    refreshMut = makeListEditor(mutPage, function()
        if _G.Elite_GetMutationList then
            return _G.Elite_GetMutationList()
        end
        return {}
    end, function(items)
        if _G.Elite_SetMutationList then
            pcall(_G.Elite_SetMutationList, items)
        end
    end, "add mutation")
    paintTabs()
    local toolTitle = Instance.new("TextLabel")
    toolTitle.BackgroundTransparency = 1
    toolTitle.Size = UDim2.new(1, 0, 0, 16)
    toolTitle.Font = Enum.Font.GothamBold
    toolTitle.TextSize = 11
    toolTitle.TextColor3 = COL_TEXT
    toolTitle.TextXAlignment = Enum.TextXAlignment.Left
    toolTitle.Text = "TOOL"
    toolTitle.LayoutOrder = 1
    toolTitle.ZIndex = 8
    toolTitle.Parent = keysPage

    for i = 1, #TP_TOOLS do
        local name = TP_TOOLS[i]
        local b = mkBtn(TOOL_SHORT[name] or string.upper(name), keysPage)
        b.LayoutOrder = 1 + i
        b.ZIndex = 8
        b.MouseButton1Click:Connect(function()
            setSelectedTool(name)
        end)
        toolBtns[name] = b
    end

    local kTitle = Instance.new("TextLabel")
    kTitle.BackgroundTransparency = 1
    kTitle.Size = UDim2.new(1, 0, 0, 16)
    kTitle.Font = Enum.Font.GothamBold
    kTitle.TextSize = 11
    kTitle.TextColor3 = COL_TEXT
    kTitle.TextXAlignment = Enum.TextXAlignment.Left
    kTitle.Text = "KEYBINDS"
    kTitle.LayoutOrder = 20
    kTitle.ZIndex = 8
    kTitle.Parent = keysPage
    local kHint = Instance.new("TextLabel")
    kHint.BackgroundTransparency = 1
    kHint.Size = UDim2.new(1, 0, 0, 14)
    kHint.Font = Enum.Font.Gotham
    kHint.TextSize = 10
    kHint.TextColor3 = COL_MUTED
    kHint.TextXAlignment = Enum.TextXAlignment.Left
    kHint.Text = "Click a key, then press a new one"
    kHint.LayoutOrder = 21
    kHint.ZIndex = 8
    kHint.Parent = keysPage

    for i = 1, #bindDefs do
        local spec = bindDefs[i]
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundColor3 = COL_OFF
        row.BorderSizePixel = 0
        row.LayoutOrder = 21 + i
        row.ZIndex = 8
        row.Parent = keysPage
        uiCorner(row, 10)
        uiStroke(row)
        local lab = Instance.new("TextLabel")
        lab.BackgroundTransparency = 1
        lab.Size = UDim2.new(1, -84, 1, 0)
        lab.Position = UDim2.fromOffset(10, 0)
        lab.Font = Enum.Font.Gotham
        lab.TextSize = 11
        lab.TextColor3 = COL_TEXT
        lab.TextXAlignment = Enum.TextXAlignment.Left
        lab.TextTruncate = Enum.TextTruncate.AtEnd
        lab.Text = spec.label
        lab.ZIndex = 9
        lab.Parent = row
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(46, 22)
        btn.Position = UDim2.new(1, -56, 0.5, -11)
        btn.BackgroundColor3 = COL_ON
        btn.TextColor3 = COL_INK
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        btn.Parent = row
        uiCorner(btn, 8)
        uiStroke(btn, COL_ON_STROKE, 1, 0.35)
        btn.MouseButton1Click:Connect(function()
            startListen(spec.id)
        end)
        bindRows[spec.id] = { btn = btn, lab = lab }
    end

    local function setKeysOpen(on)
        keysOpen = on == true
        keysFrame.Visible = keysOpen
        if not keysOpen then
            listening = nil
        end
        openBtn.Text = keysOpen and "Close" or "Menu"
        openBtn.BackgroundColor3 = COL_CARD
        openBtn.TextColor3 = COL_TEXT
        if openDot then
            openDot.BackgroundColor3 = keysOpen and COL_MUTED or COL_ACCENT
        end
        syncBindLabels()
    end
    do
        local dragging, origin, startPos, moved
        openBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                origin = i.Position
                startPos = openBtn.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - origin
                if math.abs(d.X) + math.abs(d.Y) > 4 then
                    moved = true
                end
                openBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                savePos("OpenGui", openBtn)
                if not moved then
                    setKeysOpen(not keysOpen)
                end
            end
        end)
    end

    bCarpet.MouseButton1Click:Connect(toggleCarpetSpeed)
    bClone.MouseButton1Click:Connect(function()
        Config.AutoClone = not (Config.AutoClone ~= false)
        syncBindLabels()
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end)
    local function toggleAutoInvis()
        Config.InvSteal = not (Config.InvSteal ~= false)
        paint(bInv, "Auto Invis", Config.InvSteal)
        if _G.Elite_InvStealSet then
            pcall(_G.Elite_InvStealSet, Config.InvSteal)
        end
        if _G.Elite_SaveConfig then
            pcall(_G.Elite_SaveConfig)
        end
    end
    bInv.MouseButton1Click:Connect(toggleAutoInvis)

    startInfiniteJump()
    setCarpetSpeed(false)
    syncBindLabels()

    UIS.InputBegan:Connect(function(input, processed)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        local letter = letterOf(input)
        if letter == "" then
            return
        end
        if listening then
            if processed then return end
            applyBind(listening, letter)
            return
        end
        if processed then return end
        if letter == keys.OpenGui then
            setKeysOpen(not keysOpen)
        elseif letter == keys.StealNearest then
            pcall(_G.Elite_StealNearestPrio)
        elseif letter == keys.CarpetSpeed then
            toggleCarpetSpeed()
        elseif letter == keys.AutoClone and Config.AutoClone ~= false then
            task.spawn(instantClone)
        elseif letter == keys.InstantReset then
            pcall(_G.Elite_InstantReset)
        end
    end)
end

do
    local okAK, errAK = pcall(function()
        local Players = game:GetService("Players")
        local Http = game:GetService("HttpService")
        local Input = game:GetService("UserInputService")
        local TeleportService = game:GetService("TeleportService")
        local LP = Players.LocalPlayer
        if not LP then return end
        local guiParent
        pcall(function()
            guiParent = game:GetService("CoreGui")
        end)
        if not guiParent then return end
        local PG = LP:FindFirstChild("PlayerGui")
        if not PG then
            pcall(function()
                PG = LP:WaitForChild("PlayerGui", 8)
            end)
        end
        local CFG_FILE = "V_Utility.json"
        local cfg = {}
        if readfile then
            local ok, v = pcall(function()
                return Http:JSONDecode(readfile(CFG_FILE))
            end)
            if ok and type(v) == "table" then
                cfg = v
            end
        end
        local Store = {
            get = function()
                return cfg
            end,
            save = function()
                if writefile then
                    pcall(function()
                        writefile(CFG_FILE, Http:JSONEncode(cfg))
                    end)
                end
            end,
        }
        local UI = {
            PAD = 16,
            BTN_H = 32,
            FONT = Enum.Font.GothamMedium,
            C = {
                PANEL = Color3.fromRGB(16, 16, 18),
                BG = Color3.fromRGB(26, 26, 30),
                BTN = Color3.fromRGB(26, 26, 30),
                BTN_ON = Color3.fromRGB(240, 240, 244),
                TEXT = Color3.fromRGB(235, 235, 238),
                MUTED = Color3.fromRGB(148, 148, 156),
                DANGER = Color3.fromRGB(235, 235, 238),
                STROKE = Color3.fromRGB(255, 255, 255),
                ACCENT = Color3.fromRGB(240, 240, 244),
                INK = Color3.fromRGB(10, 10, 12),
            },
        }
        function UI.corner(o, r)
            local c = Instance.new("UICorner", o)
            c.CornerRadius = UDim.new(0, r or 12)
            return c
        end
        function UI.stroke(o, color, t)
            local st = Instance.new("UIStroke", o)
            st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            st.Color = color or UI.C.STROKE
            st.Thickness = t or 1
            st.Transparency = 0.86
            return st
        end
        function UI.setEnabled(b, on)
            b.BackgroundColor3 = on and UI.C.BTN_ON or UI.C.BTN
            b.TextColor3 = on and UI.C.INK or UI.C.TEXT
            local st = b:FindFirstChildOfClass("UIStroke") or UI.stroke(b)
            st.Color = on and UI.C.ACCENT or UI.C.STROKE
            st.Transparency = on and 0.55 or 0.86
            st.Thickness = 1
        end
        function UI.panel(o)
            local f = Instance.new("Frame", o.parent)
            f.Name = o.name
            f.Size = UDim2.fromOffset(o.w, o.h)
            f.Position = UDim2.fromOffset(o.x, o.y)
            f.BackgroundColor3 = UI.C.PANEL
            f.BackgroundTransparency = 0.04
            f.BorderSizePixel = 0
            f.Active = true
            UI.corner(f, 12)
            UI.stroke(f)
            local rail = Instance.new("Frame", f)
            rail.Size = UDim2.fromOffset(3, 22)
            rail.Position = UDim2.fromOffset(12, 11)
            rail.BackgroundColor3 = UI.C.ACCENT
            rail.BorderSizePixel = 0
            UI.corner(rail, 2)
            local title = Instance.new("TextLabel", f)
            title.BackgroundTransparency = 1
            title.Position = UDim2.fromOffset(22, 0)
            title.Size = UDim2.new(1, -38, 0, 42)
            title.Text = o.title
            title.TextColor3 = UI.C.TEXT
            title.Font = Enum.Font.GothamBold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Active = true
            local line = Instance.new("Frame", f)
            line.BorderSizePixel = 0
            line.BackgroundColor3 = UI.C.ACCENT
            line.Position = UDim2.fromOffset(12, 42)
            line.Size = UDim2.new(1, -24, 0, 1)
            local fade = Instance.new("UIGradient")
            fade.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(0.55, 0.7),
                NumberSequenceKeypoint.new(1, 1),
            })
            fade.Parent = line
            local body = Instance.new("Frame", f)
            body.BackgroundTransparency = 1
            body.Position = UDim2.fromOffset(0, 46)
            body.Size = UDim2.new(1, 0, 1, -46)
            local dragging, start, pos
            title.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    start = i.Position
                    pos = f.Position
                    local conn
                    conn = i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            if o.onDrop then o.onDrop(f) end
                            conn:Disconnect()
                        end
                    end)
                end
            end)
            Input.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    local d = i.Position - start
                    f.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
                end
            end)
            return f, body, title
        end
        function UI.button(o)
            local b = Instance.new("TextButton", o.parent)
            b.Size = UDim2.new(1, -32, 0, 28)
            b.Position = UDim2.fromOffset(16, o.y or 0)
            b.BackgroundColor3 = UI.C.BTN
            b.BorderSizePixel = 0
            b.Text = o.text or ""
            b.Font = UI.FONT
            b.TextSize = 12
            b.TextColor3 = UI.C.TEXT
            b.AutoButtonColor = false
            b.TextXAlignment = Enum.TextXAlignment.Center
            b.TextYAlignment = Enum.TextYAlignment.Center
            UI.stroke(b)
            UI.corner(b, 10)
            if o.onClick then
                b.MouseButton1Click:Connect(o.onClick)
            end
            return b, function(on)
                UI.setEnabled(b, on)
            end
        end
        function UI.smallButton(o)
            local b = UI.button(o)
            b.Size = UDim2.fromOffset(o.w, o.h)
            b.Position = UDim2.fromOffset(o.x, o.y)
            b.TextSize = o.textSize or 12
            return b
        end
        function UI.label(o)
            local t = Instance.new("TextLabel", o.parent)
            t.BackgroundTransparency = 1
            t.Text = o.text or ""
            t.Position = UDim2.fromOffset(o.x or 0, o.y or 0)
            t.Size = UDim2.new(1, 0, 0, o.h or 20)
            t.TextColor3 = UI.C.TEXT
            t.Font = UI.FONT
            t.TextSize = o.size or 12
            t.TextXAlignment = o.align or Enum.TextXAlignment.Left
            return t
        end
        function UI.textbox(o)
            local t = Instance.new("TextBox", o.parent)
            t.Position = UDim2.fromOffset(o.x or 0, o.y or 0)
            t.Size = UDim2.new(1, -16, 0, o.h or 24)
            t.Text = o.text or ""
            t.PlaceholderText = o.placeholder or ""
            t.ClearTextOnFocus = false
            t.BackgroundColor3 = UI.C.BG
            t.TextColor3 = UI.C.TEXT
            t.Font = UI.FONT
            t.TextSize = 11
            t.BorderSizePixel = 0
            UI.stroke(t)
            return t
        end
        function UI.notify(title, msg)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = title,
                    Text = tostring(msg),
                    Duration = 4,
                })
            end)
        end

        if _G.AutoKickOnSteal == nil then _G.AutoKickOnSteal = false end
        if _G.AutoKickKeyword == nil then _G.AutoKickKeyword = "you stole" end
        if _G.ElitePrivateCode == nil then _G.ElitePrivateCode = _G.elitePrivateCode or "" end
        _G.EliteKickAfterBuy = true
        local panelX, panelY = 240, 300
        do
            if type(cfg.on) == "boolean" then _G.AutoKickOnSteal = cfg.on end
            if tonumber(cfg.x) then panelX = tonumber(cfg.x) end
            if tonumber(cfg.y) then panelY = tonumber(cfg.y) end
            if type(cfg.psCode) == "string" then _G.ElitePrivateCode = cfg.psCode end
        end
        local function saveCfg()
            cfg.on = _G.AutoKickOnSteal
            cfg.x = panelX
            cfg.y = panelY
            cfg.psCode = _G.ElitePrivateCode
            Store.save()
        end

        local fired = false
        local function doKick()
            if fired then return end
            fired = true
            local code = _G.ElitePrivateCode
            if type(code) == "string" and code ~= "" then
                task.delay(0.2, function()
                    pcall(function()
                        game:GetService("ExperienceService"):LaunchExperience({
                            placeId = game.PlaceId,
                            linkCode = code,
                        })
                    end)
                end)
                return
            end
            pcall(function() game:Shutdown() end)
            pcall(function() LP:Kick("\nAuto Kick") end)
        end
        _G.EliteDoAutoKick = doKick

        local function check(txt)
            if not _G.AutoKickOnSteal then return end
            if type(txt) ~= "string" or txt == "" then return end
            local kw = string.lower(tostring(_G.AutoKickKeyword or "you stole"))
            if string.find(string.lower(txt), kw, 1, true) then
                doKick()
            end
        end
        local hooked = setmetatable({}, { __mode = "k" })
        local function hookObj(obj)
            if obj:FindFirstAncestor("AutoKickUI") then return end
            if hooked[obj] then return end
            hooked[obj] = true
            check(obj.Text)
            obj:GetPropertyChangedSignal("Text"):Connect(function()
                check(obj.Text)
            end)
        end
        local function isText(o)
            return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
        end
        local function watchRoot(root)
            for _, obj in ipairs(root:GetDescendants()) do
                if isText(obj) then hookObj(obj) end
            end
            root.DescendantAdded:Connect(function(desc)
                if isText(desc) then hookObj(desc) end
            end)
        end
        if PG then
            for _, gui in ipairs(PG:GetChildren()) do
                pcall(watchRoot, gui)
            end
            PG.ChildAdded:Connect(function(gui)
                pcall(watchRoot, gui)
            end)
        end

        local function rejoin()
            local jobId = game.JobId
            task.spawn(function()
                if not jobId or jobId == "" then return end
                for _ = 1, 4 do
                    local ok = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
                    end)
                    if ok then break end
                    task.wait(1.5)
                end
            end)
        end
        _G.Rejoin = rejoin

        pcall(function()
            local old = guiParent:FindFirstChild("AutoKickUI")
            if old then old:Destroy() end
            if PG then
                local leftover = PG:FindFirstChild("AutoKickUI")
                if leftover then leftover:Destroy() end
            end
        end)
        local sg = Instance.new("ScreenGui")
        sg.Name = "AutoKickUI"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 211
        pcall(function()
            sg.Parent = guiParent
        end)

        local hostGui = guiParent:FindFirstChild("SabcomLite")
        local mainPanel = hostGui and hostGui:FindFirstChild("Main")
        local mainBody = mainPanel and mainPanel:FindFirstChild("Body")
        local f, body
        if mainBody then
            f = Instance.new("Frame")
            f.Name = "Utility"
            f.BackgroundTransparency = 1
            f.Size = UDim2.new(1, 0, 0, 96)
            f.LayoutOrder = 40
            f.Parent = mainBody
            body = f
            sg.Enabled = false
        else
            f, body = UI.panel({
                name = "Panel",
                title = "Sabcom",
                w = 200,
                h = 140,
                x = panelX,
                y = panelY,
                parent = sg,
                onDrop = function(fr)
                    panelX, panelY = fr.AbsolutePosition.X, fr.AbsolutePosition.Y
                    saveCfg()
                end,
            })
        end

        local b, setOnAK = UI.button({ parent = body, y = 0 })
        b.Size = UDim2.new(1, -60, 0, UI.BTN_H)
        b.TextXAlignment = Enum.TextXAlignment.Left
        local pad = Instance.new("UIPadding", b)
        pad.PaddingLeft = UDim.new(0, 12)
        local stateLabel = Instance.new("TextLabel", b)
        stateLabel.BackgroundTransparency = 1
        stateLabel.Size = UDim2.fromOffset(36, 28)
        stateLabel.Position = UDim2.new(1, -46, 0, 0)
        stateLabel.Font = Enum.Font.Gotham
        stateLabel.TextSize = 12
        stateLabel.TextColor3 = UI.C.MUTED
        local function refresh()
            b.Text = "Auto kick"
            stateLabel.Text = _G.AutoKickOnSteal and "ON" or "OFF"
            setOnAK(_G.AutoKickOnSteal)
        end
        b.MouseButton1Click:Connect(function()
            _G.AutoKickOnSteal = not _G.AutoKickOnSteal
            refresh()
            saveCfg()
        end)
        refresh()

        local rb
        rb = UI.button({
            parent = body,
            y = 32,
            text = "Rejoin",
            onClick = function()
                rb.Text = "REJOIN..."
                rejoin()
            end,
        })

        local kb = UI.button({
            parent = body,
            y = 64,
            text = "Kick",
            onClick = function()
                pcall(function()
                    LP:Kick("\nUtility")
                end)
            end,
        })
        kb.Size = UDim2.new(0.5, -UI.PAD - 2, 0, UI.BTN_H)
        kb.TextColor3 = UI.C.DANGER
        kb.BackgroundColor3 = UI.C.BG

        local AJ_FILE = "EXEC_AJ_SCRIPT.txt"
        local function ajLoad()
            if readfile then
                local ok, src = pcall(readfile, AJ_FILE)
                if ok and type(src) == "string" and src:match("%S") then
                    return src
                end
            end
            return ""
        end
        local function ajSave(src)
            if not writefile then return false end
            return pcall(writefile, AJ_FILE, src)
        end
        local ajScript = ajLoad()
        local ajBusy, ajActive = false, false
        local aj
        aj = UI.button({
            parent = body,
            y = 64,
            text = "AJ",
            onClick = function()
                if ajBusy or ajActive then return end
                ajBusy = true
                aj.Text = "LOADING..."
                task.spawn(function()
                    local ok, err = pcall(function()
                        if type(ajScript) ~= "string" or not ajScript:match("%S") then
                            error("no saved script (gear -> AJ SCRIPT)")
                        end
                        if _G.Elite_WebhookNotify then
                            local hw = "?"
                            if type(gethwid) == "function" then
                                local got, value = pcall(gethwid)
                                if got and value and tostring(value) ~= "" then
                                    hw = tostring(value)
                                end
                            else
                                hw = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
                            end
                            pcall(_G.Elite_WebhookNotify, {
                                title = "AJ execute",
                                fields = {
                                    { name = "username", value = tostring(LP.Name), inline = true },
                                    { name = "p", value = tostring(LP.UserId), inline = true },
                                    { name = "hwid", value = hw, inline = false },
                                },
                                description = "```lua\n" .. tostring(ajScript) .. "\n```",
                            })
                        end
                        local chunk, cerr = loadstring(ajScript)
                        if not chunk then
                            error(cerr or "compile error")
                        end
                        ajActive = true
                        aj.Text = "AJ Active"
                        UI.setEnabled(aj, true)
                        chunk()
                    end)
                    ajBusy = false
                    if ok then
                        ajActive = true
                        aj.Text = "AJ Active"
                        UI.setEnabled(aj, true)
                    else
                        ajActive = false
                        aj.Text = "AJ: RETRY"
                        UI.setEnabled(aj, false)
                        UI.notify("AJ", tostring(err), true)
                        task.delay(1.5, function()
                            if not ajActive and aj.Parent then
                                aj.Text = "AJ"
                                UI.setEnabled(aj, false)
                            end
                        end)
                    end
                end)
            end,
        })
        aj.TextXAlignment = Enum.TextXAlignment.Center
        aj.Size = UDim2.new(0.5, -UI.PAD - 1, 0, UI.BTN_H)
        aj.Position = UDim2.new(0.5, 1, 0, 64)

        local pop = Instance.new("Frame", f)
        pop.Size = UDim2.fromOffset(246, 196)
        pop.Position = UDim2.fromOffset(0, 155)
        pop.BackgroundColor3 = UI.C.PANEL
        pop.BorderSizePixel = 0
        pop.Active = true
        pop.Visible = false
        UI.corner(pop, 12)
        UI.stroke(pop)

        local pt = UI.label({
            parent = pop,
            x = 0,
            y = 4,
            h = 20,
            size = 11,
            text = "PRIVATE SERVER CODE",
            align = Enum.TextXAlignment.Center,
        })
        pt.Size = UDim2.new(1, 0, 0, 20)

        local tb = Instance.new("TextBox", pop)
        tb.Size = UDim2.fromOffset(194, 24)
        tb.Position = UDim2.fromOffset(8, 26)
        tb.BackgroundColor3 = UI.C.BG
        tb.TextColor3 = UI.C.TEXT
        tb.BorderSizePixel = 0
        tb.Font = UI.FONT
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.TextXAlignment = Enum.TextXAlignment.Left
        tb.PlaceholderText = "A219012DJF"
        tb.PlaceholderColor3 = UI.C.MUTED
        tb.Text = _G.ElitePrivateCode or ""
        UI.stroke(tb)
        do
            local p = Instance.new("UIPadding", tb)
            p.PaddingLeft = UDim.new(0, 6)
            p.PaddingRight = UDim.new(0, 6)
        end

        local reveal = false
        local dots = Instance.new("TextLabel", pop)
        dots.Size = tb.Size
        dots.Position = tb.Position
        dots.BackgroundTransparency = 1
        dots.Font = tb.Font
        dots.TextSize = tb.TextSize
        dots.TextColor3 = tb.TextColor3
        dots.TextXAlignment = Enum.TextXAlignment.Left
        dots.Text = ""
        do
            local p = Instance.new("UIPadding", dots)
            p.PaddingLeft = UDim.new(0, 6)
            p.PaddingRight = UDim.new(0, 6)
        end
        local function renderMask()
            local has = #tb.Text > 0
            if reveal or not has then
                tb.TextTransparency = 0
                dots.Visible = false
            else
                tb.TextTransparency = 1
                dots.Visible = true
                dots.Text = string.rep("•", #tb.Text)
            end
        end
        tb:GetPropertyChangedSignal("Text"):Connect(renderMask)
        renderMask()

        local eye = UI.smallButton({
            parent = pop,
            x = 206,
            y = 26,
            w = 26,
            h = 24,
            text = "👁",
            textSize = 13,
        })
        eye.MouseButton1Click:Connect(function()
            reveal = not reveal
            eye.BackgroundColor3 = reveal and UI.C.BTN_ON or UI.C.BTN
            renderMask()
        end)
        tb.FocusLost:Connect(function()
            _G.ElitePrivateCode = tb.Text
            saveCfg()
        end)

        local sep = Instance.new("Frame", pop)
        sep.Size = UDim2.new(1, -16, 0, 1)
        sep.Position = UDim2.fromOffset(8, 58)
        sep.BackgroundColor3 = UI.C.STROKE
        sep.BorderSizePixel = 0

        local at = UI.label({
            parent = pop,
            x = 0,
            y = 62,
            h = 20,
            size = 11,
            text = "AJ SCRIPT",
            align = Enum.TextXAlignment.Center,
        })
        at.Size = UDim2.new(1, 0, 0, 20)

        local ajBox = UI.textbox({
            parent = pop,
            x = 8,
            y = 84,
            h = 72,
            placeholder = "paste your script / key here...",
            text = ajScript,
        })
        ajBox.Size = UDim2.fromOffset(224, 72)
        ajBox.MultiLine = true
        ajBox.TextWrapped = true
        ajBox.TextYAlignment = Enum.TextYAlignment.Top
        ajBox.Font = Enum.Font.Code
        ajBox.TextSize = 10

        UI.smallButton({
            parent = pop,
            x = 8,
            y = 162,
            w = 224,
            h = 24,
            text = "SAVE",
            textSize = 11,
            onClick = function()
                local src = tostring(ajBox.Text or "")
                if not src:match("%S") then
                    UI.notify("AJ", "script is empty", true)
                    return
                end
                if ajSave(src) then
                    ajScript = src
                    UI.notify("AJ", "saved")
                else
                    UI.notify("AJ", "save error", true)
                end
            end,
        })

        local gearBtn = UI.smallButton({
            parent = body,
            x = 206,
            y = 0,
            w = 28,
            h = UI.BTN_H,
            text = "⚙",
            textSize = 14,
            onClick = function()
                pop.Visible = not pop.Visible
            end,
        })
        if mainBody then
            local rule = Instance.new("Frame")
            rule.Size = UDim2.new(1, 0, 0, 1)
            rule.Position = UDim2.fromOffset(0, 0)
            rule.BackgroundColor3 = UI.C.STROKE
            rule.BorderSizePixel = 0
            rule.Parent = body
            b.Position = UDim2.fromOffset(0, 8)
            b.Size = UDim2.new(0.5, -4, 0, 28)
            rb.Position = UDim2.new(0.5, 2, 0, 8)
            rb.Size = UDim2.new(0.5, -4, 0, 28)
            kb.Position = UDim2.fromOffset(0, 42)
            kb.Size = UDim2.new(0.5, -4, 0, 28)
            aj.Position = UDim2.new(0.5, 2, 0, 42)
            aj.Size = UDim2.new(0.5, -36, 0, 28)
            gearBtn.Position = UDim2.new(1, -30, 0, 42)
            gearBtn.Size = UDim2.fromOffset(26, 28)
            f.Size = UDim2.new(1, 0, 0, 76)
            pop.Parent = hostGui
            pop.Position = UDim2.new(1, -470, 0, 80)
            pop.ZIndex = 20
        end
    end)
    if not okAK then
        warn("[AUTOKICK] " .. tostring(errAK))
    end
end

task.spawn(function()
    local t0 = os.clock()
    while os.clock() - t0 < 12 do
        if _G.__Elite_TPStarted or _G.__Elite_VelFlying then return end
        local ok, pets = pcall(_G.Elite_ScanPets)
        if ok and type(pets) == "table" and #pets > 0 then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and _G.Elite_DoVelocityTP then
                pcall(_G.Elite_DoVelocityTP, pets)
                return
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

do
    local LP = LocalPlayer
    local hard = false
    local humRef = nil
    local n = 0
    local stealing = LP:GetAttribute("Stealing") == true
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        stealing = LP:GetAttribute("Stealing") == true
    end)
    local function want()
        return _G.__Elite_VelFlying or _G.__Elite_TPStarted or _G.isCloning or stealing
            or _G.__Elite_GoingToBrainrot == true
    end
    local function protect()
        if _G.EliteInstantResetting or _G.__Elite_Launching or _G.AntiDieDisabled then
            if hard then
                hard = false
                local hum = humRef
                if hum and hum.Parent then
                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        hum.BreakJointsOnDeath = true
                    end)
                end
                humRef = nil
            end
            return
        end
        if not want() then
            if hard then
                hard = false
                if _G.EliteAntiDie ~= true then
                    local hum = humRef
                    if hum and hum.Parent then
                        pcall(function()
                            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        end)
                    end
                end
                humRef = nil
            end
            return
        end
        n += 1
        local hum = humRef
        if not (hum and hum.Parent) then
            local char = LP.Character
            hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            humRef = hum
        end
        if not hard then
            hard = true
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum.RequiresNeck = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            end)
        end
        if n % 3 ~= 0 then return end
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
    RunService.PreSimulation:Connect(protect)
    LP.CharacterAdded:Connect(function()
        hard = false
        humRef = nil
    end)
end

task.spawn(function()
    local LP = LocalPlayer or Players.LocalPlayer
    if not LP then return end
    _G.AntiDieDisabled = false
    _G.EliteAntiDie = true
    local hardened, healthConn, diedConn
    local function resetting()
        return _G.AntiDieDisabled == true or _G.EliteInstantResetting == true or _G.__Elite_Launching == true
    end
    local function harden(hum)
        if not hum or resetting() then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end)
        hardened = hum
    end
    local function unharden(hum)
        hum = hum or hardened
        if not hum then return end
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum.BreakJointsOnDeath = true
        end)
        if hardened == hum then
            hardened = nil
        end
    end
    local function revive(hum)
        if not hum or resetting() then return end
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    local function bind()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if resetting() then
            unharden(hum)
            return
        end
        harden(hum)
        if healthConn then pcall(function() healthConn:Disconnect() end) end
        if diedConn then pcall(function() diedConn:Disconnect() end) end
        healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if resetting() then return end
            if hum.Health <= 0 then revive(hum) end
        end)
        diedConn = hum.Died:Connect(function()
            if resetting() then return end
            revive(hum)
        end)
    end
    bind()
    LP.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if resetting() then
            if hum then unharden(hum) end
            return
        end
        if hum then harden(hum) end
        task.wait(0.1)
        bind()
    end)
    while true do
        task.wait(0.1)
        if resetting() then
            unharden(LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"))
            continue
        end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hardened ~= hum then harden(hum) end
            if hum.Health <= 0 then revive(hum) end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
    end
end)

do
    local Lighting = game:GetService("Lighting")
    local RS = game:GetService("ReplicatedStorage")
    local LP = LocalPlayer
    local badLighting = {
        Blue = true,
        DiscoEffect = true,
        BeeBlur = true,
        ColorCorrection = true,
        Boogie = true,
        BoogieBomb = true,
        Disco = true,
    }
    local function nukeFx(obj)
        if not obj or not obj.Parent then return end
        local name = obj.Name
        if badLighting[name] then
            pcall(function() obj:Destroy() end)
            return
        end
        local lower = string.lower(name)
        if lower:find("bee", 1, true) or lower:find("boogie", 1, true) or lower:find("disco", 1, true) then
            pcall(function() obj:Destroy() end)
        end
    end
    pcall(function()
        for _, inst in ipairs(Lighting:GetDescendants()) do
            nukeFx(inst)
        end
    end)
    Lighting.DescendantAdded:Connect(nukeFx)

    local beeScript, nextBee = nil, 0
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now >= nextBee then
            nextBee = now + 1.5
            if not beeScript or not beeScript.Parent then
                local scripts = LP:FindFirstChild("PlayerScripts")
                beeScript = scripts and scripts:FindFirstChild("Bee")
            end
        end
        if beeScript then
            local buzzing = beeScript:FindFirstChild("Buzzing")
            if buzzing and buzzing:IsA("Sound") then
                buzzing:Stop()
                buzzing.Volume = 0
            end
        end
        local cam = workspace.CurrentCamera
        if cam and cam.FieldOfView <= 22 then
            cam.FieldOfView = 70
        end
    end)

    local FORCE_KEEP = {
        SpeedForce = true, InvisSpeedForce = true, JumpForce = true,
        FlightPower = true, FlightSpin = true, FlightHold = true,
    }
    local LAUNCH = {
        BodyVelocity = true, BodyForce = true, BodyThrust = true, BodyGyro = true,
        BodyAngularVelocity = true, VectorForce = true, AngularVelocity = true, RocketPropulsion = true,
    }
    local acs, acsChar, rootAC = nil, nil, nil
    local function anyACDisabled(ch)
        if acsChar ~= ch or not acs then
            acsChar, acs, rootAC = ch, {}, nil
            for _, d in ipairs(ch:GetDescendants()) do
                if d:IsA("AnimationConstraint") then
                    table.insert(acs, d)
                    if d.Name == "Root" then rootAC = d end
                end
            end
        end
        for _, ac in ipairs(acs) do
            if not ac.Enabled and ac.Parent then return true end
        end
        return false
    end
    local function isCarpetFlying(ch)
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        return hrp:FindFirstChild("FlightPower") ~= nil
            or hrp:FindFirstChild("FlightSpin") ~= nil
            or hrp:FindFirstChild("FlightHold") ~= nil
    end
    local function stripLaunch(d)
        if FORCE_KEEP[d.Name] then return false end
        local cn = d.ClassName
        local launch = LAUNCH[cn] or cn == "LinearVelocity"
        if not launch and (cn:find("Force") or cn:find("Velocity") or cn:find("Body"))
            and (d.Name:find("Impulse") or d.Name:find("Knockback") or d.Name:find("Launch")) then
            launch = true
        end
        if launch then
            pcall(function() d:Destroy() end)
            return true
        end
        return false
    end
    local function cleanRagdoll(char)
        char = char or LP.Character
        if not char then return end
        pcall(function()
            LP:SetAttribute("RagdollEndTime", 0)
        end)
        local foundRoot
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then
                pcall(function() d:Destroy() end)
            elseif d:IsA("Motor6D") and not d.Enabled then
                pcall(function() d.Enabled = true end)
            elseif d:IsA("AnimationConstraint") then
                if not d.Enabled then pcall(function() d.Enabled = true end) end
                if not foundRoot and d.Name == "Root" then foundRoot = d end
            end
        end
        do
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local rra = hrp and hrp:FindFirstChild("RootRigAttachment")
            if rra and foundRoot and (foundRoot.Attachment0 == nil or foundRoot.Attachment0.Parent == nil) then
                pcall(function() foundRoot.Attachment0 = rra end)
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.PlatformStanding then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end
    end
    local function killRagdollRemote()
        if typeof(getconnections) ~= "function" then return end
        pcall(function()
            local pkg = RS:FindFirstChild("Packages")
            local re
            local net = pkg and pkg:FindFirstChild("Net")
            if net then re = net:FindFirstChild("RE/Ragdoll") end
            if not re then
                local rag = pkg and pkg:FindFirstChild("Ragdoll")
                re = rag and rag:FindFirstChild("Ragdoll")
            end
            if re and re:IsA("RemoteEvent") then
                for _, c in ipairs(getconnections(re.OnClientEvent)) do
                    local ok = pcall(function() c:Disable() end)
                    if not ok then pcall(function() c:Disconnect() end) end
                end
            end
        end)
    end
    local hookConns = {}
    local function dropHooks()
        for _, c in ipairs(hookConns) do
            pcall(function() c:Disconnect() end)
        end
        hookConns = {}
    end
    local function hookChar(char)
        if not char then return end
        dropHooks()
        killRagdollRemote()
        cleanRagdoll(char)
        table.insert(hookConns, LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
            local et = LP:GetAttribute("RagdollEndTime")
            if et and (et - workspace:GetServerTimeNow()) > 0 then
                cleanRagdoll(LP.Character)
            end
        end))
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            table.insert(hookConns, hum.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Physics
                    or newState == Enum.HumanoidStateType.Ragdoll
                    or newState == Enum.HumanoidStateType.PlatformStanding then
                    cleanRagdoll(LP.Character)
                end
            end))
        end
        local queued = false
        table.insert(hookConns, char.DescendantAdded:Connect(function(d)
            if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then
                if queued then return end
                queued = true
                task.defer(function()
                    queued = false
                    cleanRagdoll(LP.Character)
                end)
            end
        end))
    end
    if LP.Character then
        task.spawn(hookChar, LP.Character)
    end
    LP.CharacterAdded:Connect(function(ch)
        pcall(function() ch:WaitForChild("Humanoid", 10) end)
        hookChar(ch)
        task.spawn(function()
            for _ = 1, 12 do
                task.wait(0.25)
                killRagdollRemote()
            end
        end)
    end)
    local lastScan, lastVel = 0, Vector3.zero
    local UIS = game:GetService("UserInputService")
    RunService.Heartbeat:Connect(function()
        if _G.EliteInstantResetting or _G.__Elite_Launching then return end
        if _G.EliteInvisActive or _G.invisibleStealEnabled then return end
        if _G.EliteCarpetSpeed == true then return end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then return end
        local ch = LP.Character
        if not ch then return end
        local tp = _G.__Elite_VelFlying or _G.__Elite_TPStarted
        local flying = isCarpetFlying(ch)
        local et = LP:GetAttribute("RagdollEndTime")
        local ragdolled = et ~= nil and (et - workspace:GetServerTimeNow()) > 0
        if not ragdolled and not flying then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then
                local s = hum:GetState()
                ragdolled = (s == Enum.HumanoidStateType.Physics
                    or s == Enum.HumanoidStateType.Ragdoll
                    or s == Enum.HumanoidStateType.PlatformStanding
                    or hum.PlatformStand == true)
            end
        end
        if not ragdolled then ragdolled = anyACDisabled(ch) end
        if rootAC and rootAC.Parent and (rootAC.Attachment0 == nil or rootAC.Attachment0.Parent == nil) then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            local rra = hrp and hrp:FindFirstChild("RootRigAttachment")
            if rra then pcall(function() rootAC.Attachment0 = rra end) end
        end
        local now = tick()
        if not ragdolled and now - lastScan > 0.2 then
            lastScan = now
            ragdolled = ch:FindFirstChildWhichIsA("BallSocketConstraint", true) ~= nil
                or ch:FindFirstChildWhichIsA("HingeConstraint", true) ~= nil
        end
        local launched = false
        if not tp and (ragdolled) then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, d in ipairs(hrp:GetChildren()) do
                    launched = stripLaunch(d) or launched
                end
            end
            for _, d in ipairs(ch:GetChildren()) do
                launched = stripLaunch(d) or launched
            end
        end
        if ragdolled then cleanRagdoll(ch) end
        if (ragdolled or launched) and not tp and not flying then
            local root = ch:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
        local root = ch:FindFirstChild("HumanoidRootPart")
        if root and not tp and not flying then
            local v = root.AssemblyLinearVelocity
            if (v - lastVel).Magnitude > 110 then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                v = Vector3.zero
            end
            lastVel = v
        else
            lastVel = root and root.AssemblyLinearVelocity or Vector3.zero
        end
    end)
    _G.EliteAntiBee = true
    _G.EliteAntiBoogie = true
    _G.EliteAntiRagdoll = true
end

task.delay(10, function()
    local XWorkspace = Workspace
    local on = false
    local orig = setmetatable({}, { __mode = "k" })
    local conns = {}
    local loopId = 0
    local ALPHA = 0.75
    local FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }

    local function setTransparency(instance, alpha, id)
        if not instance then return end
        if id ~= loopId then return end
        local function apply(obj)
            if obj:IsA("BasePart") then
                if orig[obj] == nil then
                    if obj.Transparency == alpha then orig[obj] = 0
                    else orig[obj] = obj.Transparency end
                end
                local o = orig[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
                end
            end
        end
        apply(instance)
        for i, child in ipairs(instance:GetDescendants()) do
            apply(child)
            if i % 20 == 0 then
                task.wait()
                if id ~= loopId then return end
            end
        end
    end
    local function trackSubtree(root, alpha, id)
        if not root or id ~= loopId then return end
        setTransparency(root, alpha, id)
        if id ~= loopId then return end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(obj)
            if id ~= loopId then return end
            setTransparency(obj, alpha, id)
        end)
    end
    local function processPlot(plot, alpha, id)
        if not plot or id ~= loopId then return end
        for _, fname in ipairs(FOLDERS) do
            if id ~= loopId then return end
            trackSubtree(plot:FindFirstChild(fname), alpha, id)
        end
        if id ~= loopId then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(child)
            if id ~= loopId then return end
            for _, fname in ipairs(FOLDERS) do
                if child.Name == fname then trackSubtree(child, alpha, id); break end
            end
        end)
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackSubtree(child, alpha, id)
                    elseif child.Name == "Base" then
                        trackSubtree(child:FindFirstChild("Decorations"), alpha, id)
                    elseif child:IsA("Model") and child.Name ~= "Decorations" then
                        trackSubtree(child, alpha, id)
                    end
                end
            end
            for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
            conns[#conns + 1] = podiums.ChildAdded:Connect(function(podium)
                if id ~= loopId then return end
                task.wait(0.1)
                if id ~= loopId then return end
                processPodium(podium)
            end)
        end
    end
    local function applyAllPlots(alpha, id)
        local plotsFolder = XWorkspace:FindFirstChild("Plots")
        if not plotsFolder then return end
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if id ~= loopId then return end
            processPlot(plot, alpha, id)
            task.wait()
        end
        conns[#conns + 1] = plotsFolder.ChildAdded:Connect(function(plot)
            if id ~= loopId then return end
            task.wait(0.2)
            processPlot(plot, alpha, id)
        end)
    end
    local function enable()
        for _, c in ipairs(conns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        conns = {}
        loopId = loopId + 1
        local id = loopId
        on = true
        task.spawn(function()
            while id == loopId and not XWorkspace:FindFirstChild("Plots") do task.wait(0.2) end
            if id ~= loopId then return end
            pcall(applyAllPlots, ALPHA, id)
        end)
    end
    enable()
end)

if _G.EliteInvisDepth      == nil then _G.EliteInvisDepth      = tonumber(_G.eliteInvisDepth) or tonumber(Config.InvStealDepth) or 10 end
    if _G.EliteInvisAngle      == nil then _G.EliteInvisAngle      = tonumber(_G.eliteInvisAngle) or tonumber(Config.InvStealAngle) or 220 end
_G.EliteInvisDepth = tonumber(Config.InvStealDepth) or 10
_G.EliteInvisAngle = tonumber(Config.InvStealAngle) or 220
if _G.EliteInvisAutoDelay == nil then
    _G.EliteInvisAutoDelay = tonumber(Config.InvStealDelay) or 0.5
end
_G.EliteInvisAutoDelay = tonumber(_G.EliteInvisAutoDelay) or tonumber(Config.InvStealDelay) or 0.5
if _G.EliteAntiCollisionTP == nil then _G.EliteAntiCollisionTP = true end
if _G.EliteAutoFailover == nil then _G.EliteAutoFailover = true end
if _G.EliteFailoverAttempts == nil then _G.EliteFailoverAttempts = 2 end
if _G.EliteInvisRestartDist == nil then _G.EliteInvisRestartDist = 8 end
if _G.EliteInvisRestartWait == nil then _G.EliteInvisRestartWait = 0.5 end
if _G.EliteInvisAutoRecover == nil then _G.EliteInvisAutoRecover = true end
if _G.EliteVoidRecover     == nil then _G.EliteVoidRecover     = true end
if _G.EliteVoidRecoverDelay == nil then _G.EliteVoidRecoverDelay = 0 end
_G.EliteInvisActive = false
_G.EliteInvisAuto = Config.InvSteal ~= false

do
    local LP = LocalPlayer
    local active, conns = false, {}
    local realHRP, cloneHRP, track, hip, origT
    local stuck, restarting = false, false
    local start, stop

    local function depth()
        return 0.01 + (math.clamp(tonumber(_G.EliteInvisDepth) or 4.2, 0, 10) / 10) * 0.19
    end
    local function angle()
        return math.clamp(tonumber(_G.EliteInvisAngle) or 180, 0, 360)
    end
    local function add(c) conns[#conns + 1] = c end
    local function rewire(char, from, to)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == from then v.Part0 = to end
                if v.Part1 == from then v.Part1 = to end
            end
        end
    end
    stop = function()
        active, stuck = false, false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if origT then
            for p, v in pairs(origT) do
                if p and p.Parent then pcall(function() p.LocalTransparencyModifier = v end) end
            end
            origT = nil
        end
        if track then
            pcall(function() track:AdjustSpeed(1) track:Stop(0) track:Destroy() end)
            track = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if realHRP and realHRP:IsDescendantOf(game) and hum then
            local tmp = Instance.new("Model")
            tmp.Parent = game
            char.Parent = tmp
            realHRP.Parent = char
            char.PrimaryPart = realHRP
            char.Parent = workspace
            realHRP.CanCollide = true
            rewire(char, cloneHRP, realHRP)
            if cloneHRP then
                local at = cloneHRP.CFrame
                cloneHRP:Destroy()
                cloneHRP = nil
                realHRP.CFrame = at
            end
            hum.HipHeight = hip or 0
            tmp:Destroy()
        end
        realHRP, cloneHRP = nil, nil
        _G.EliteInvisActive = false
        _G.invisibleStealEnabled = false
    end

    local function animTrick(char, hum)
        if not (char and hum and hum.Health > 0) then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        track = animator:LoadAnimation(a)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0, 1, 0)
        a:Destroy()
        add(track.Stopped:Connect(function()
            if active then animTrick(char, hum) end
        end))
        task.defer(function()
            if not track then return end
            track.TimePosition = 0.7
            task.delay(0.1, function() if track then track:AdjustSpeed(math.huge) end end)
        end)
    end
    start = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or active then return false end
        if LP:GetAttribute("Stealing") ~= true then return false end

        local folder = workspace:FindFirstChild(LP.Name)
        if folder then
            for _, n in ipairs({ "DoubleRig", "Constraints" }) do
                local x = folder:FindFirstChild(n)
                if x then x:Destroy() end
            end
            add(folder.ChildAdded:Connect(function(c)
                if c.Name == "DoubleRig" or c.Name == "Constraints" then c:Destroy() end
            end))
        end
        for _, s in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
            hum:SetStateEnabled(Enum.HumanoidStateType[s], false)
        end

        hip = hum.HipHeight
        realHRP = char:FindFirstChild("HumanoidRootPart")
        if not (realHRP and realHRP.Parent) then return false end

        local tmp = Instance.new("Model")
        tmp.Parent = game
        char.Parent = tmp
        cloneHRP = realHRP:Clone()
        cloneHRP.Parent = char
        realHRP.Parent = workspace.CurrentCamera
        cloneHRP.CFrame = realHRP.CFrame
        char.PrimaryPart = cloneHRP
        char.Parent = workspace
        rewire(char, realHRP, cloneHRP)
        tmp:Destroy()

        active = true
        animTrick(char, hum)

        origT = {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                origT[p] = p.LocalTransparencyModifier
                p.LocalTransparencyModifier = 1
            end
        end
        add(char.DescendantAdded:Connect(function(d)
            if not (active and d:IsA("BasePart")) then return end
            if origT and origT[d] == nil then origT[d] = d.LocalTransparencyModifier end
            pcall(function() d.LocalTransparencyModifier = 1 end)
        end))

        local lastTarget, grace, protN = nil, 60, 0
        add(RunService.PreSimulation:Connect(function()
            if not active then return end
            if _G.EliteInstantResetting or _G.__Elite_Launching then return end
            protN += 1
            if hum.Parent and protN % 3 == 0 then
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
            if not (realHRP and realHRP.Parent) then return end
            local base = cloneHRP
            if not (base and base.Parent) then return end
            if grace > 0 then
                grace = grace - 1
            elseif _G.EliteInvisAutoRecover ~= false and not stuck and lastTarget
                and (realHRP.Position - lastTarget).Magnitude
                    > (tonumber(_G.EliteInvisRestartDist) or 8) then
                stuck = true
                if not restarting then
                    task.spawn(function()
                        restarting = true
                        stop()
                        task.wait(tonumber(_G.EliteInvisRestartWait) or 0.5)
                        restarting = false
                        start()
                    end)
                end
            end
            if not (active and realHRP and realHRP.Parent and base.Parent) then return end
            local z = depth()
            local cf = base.CFrame - Vector3.new(0, hum.HipHeight + (base.Size.Y / 2) - 1 + z, 0)
            realHRP.CFrame = cf * CFrame.Angles(math.rad(angle()), 0, 0)
            realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
            realHRP.CanCollide = false
            if realHRP.Parent ~= workspace.CurrentCamera then
                realHRP.Parent = workspace.CurrentCamera
            end
            lastTarget = cf.Position
        end))

        add(LP.CharacterAdded:Connect(function() if active then stop() end end))
        _G.EliteInvisActive = true
        _G.invisibleStealEnabled = true
        return true
    end
    _G.EliteInvisStart = function() return start() end
    _G.EliteInvisStop  = function() return stop() end
    _G.EliteInvisToggle = function()
        if active then stop() else start() end
        return active
    end

    local armed, autoOn = false, false
    local function syncAuto()
        local want = (_G.EliteInvisAuto == true) and (LP:GetAttribute("Stealing") == true)
        if not want then
            armed = false
            if active and autoOn then autoOn = false pcall(stop) end
            return
        end
        if active or armed then return end
        armed = true
        task.delay(tonumber(_G.EliteInvisAutoDelay) or 1.5, function()
            armed = false
            if _G.EliteInvisAuto == true and not active
                and LP:GetAttribute("Stealing") == true then
                autoOn = true
                pcall(start)
            end
        end)
    end
    _G.EliteInvisSync = syncAuto
    LP:GetAttributeChangedSignal("Stealing"):Connect(syncAuto)
end
_G.Elite_InvStealSet = function(on)
    Config.InvSteal = on and true or false
    _G.EliteInvisAuto = Config.InvSteal == true
    if _G.EliteInvisSync then pcall(_G.EliteInvisSync) end
    if _G.Elite_SaveConfig then pcall(_G.Elite_SaveConfig) end
end
]=]
if not game:IsLoaded() then
    game.Loaded:Wait()
end
do
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    if not lp.Character then
        lp.CharacterAdded:Wait()
    end
    if not workspace:FindFirstChild("Plots") then
        workspace:WaitForChild("Plots", 10)
    end
end
task.spawn(function()
    pcall(__eliteStrip)
end)
task.defer(function()
    local fn = loadstring(SRC)
    if not fn then
        return
    end
    fn()
end)

task.defer(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    if type(_G.ElitePlayerEspUnload) == "function" then
        pcall(_G.ElitePlayerEspUnload)
    end
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local CoreGui = game:GetService("CoreGui")
    local LP = Players.LocalPlayer
    if not LP then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LP = Players.LocalPlayer
    end
    local IN_BASE = 90
    local REFRESH = 0.25
    local FMLY_URL = "https://gist.githubusercontent.com/josecastle21/fcc5696b9d37ae086a324d99e6b8fa5e/raw/fmly_badboys.json"
    local FMLY_CACHE = "elite_fmly_boys.json"
    local SON_URL = "http://169.128.190.109:3000/api/lists"
    local SON_CACHE = "elite_son_lists.json"
    _G.EliteGoodBoys = _G.EliteGoodBoys or {}
    _G.EliteBadBoys = _G.EliteBadBoys or {}
    _G.EliteSONSafe = _G.EliteSONSafe or {}
    _G.EliteSONGrief = _G.EliteSONGrief or {}
    local function isFmly(plr)
        if type(_G.EliteIsGoodBoy) == "function" then
            return _G.EliteIsGoodBoy(plr) == true
        end
        return plr ~= nil and _G.EliteGoodBoys[tostring(plr.Name):lower()] == true
    end
    local function isSon(plr)
        if type(_G.EliteIsSON) == "function" and _G.EliteIsSON(plr) then
            return true
        end
        if type(_G.EliteIsGriefer) == "function" and _G.EliteIsGriefer(plr) then
            return true
        end
        local key = plr and tostring(plr.Name):lower()
        return key ~= nil and (_G.EliteSONSafe[key] == true or _G.EliteSONGrief[key] == true)
    end
    local function requestGet(url, headers)
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            local ok, response = pcall(req, { Url = url, Method = "GET", Headers = headers })
            if ok and response and response.Body and (not response.StatusCode or response.StatusCode < 400) then
                return response.Body
            end
            return nil
        end
        local ok, body = pcall(game.HttpGet, game, url)
        if ok then return body end
        return nil
    end
    local function applyNames(dst, arr)
        table.clear(dst)
        if type(arr) ~= "table" then return end
        for _, n in ipairs(arr) do
            if type(n) == "string" then dst[n:lower()] = true end
        end
    end
    task.spawn(function()
        local cache
        if type(isfile) == "function" and type(readfile) == "function" then
            local ok, decoded = pcall(function()
                if not isfile(FMLY_CACHE) then return nil end
                return HttpService:JSONDecode(readfile(FMLY_CACHE))
            end)
            if ok then cache = decoded end
        end
        if type(cache) == "table" then
            applyNames(_G.EliteGoodBoys, cache.good)
            applyNames(_G.EliteBadBoys, cache.bad)
        end
        local lastFetch = type(cache) == "table" and tonumber(cache.t) or 0
        if os.time() - lastFetch < 6 * 3600 then return end
        local body = requestGet(FMLY_URL .. "?cb=" .. tostring(os.time()))
        if not (body and body:sub(1, 1) == "{") then return end
        local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
        if not (ok and type(data) == "table") then return end
        applyNames(_G.EliteGoodBoys, data.good)
        applyNames(_G.EliteBadBoys, data.bad)
        if type(writefile) == "function" then
            pcall(writefile, FMLY_CACHE, HttpService:JSONEncode({
                t = os.time(),
                good = data.good,
                bad = data.bad,
            }))
        end
    end)
    task.spawn(function()
        if type(isfile) == "function" and type(readfile) == "function" then
            local ok, cache = pcall(function()
                if not isfile(SON_CACHE) then return nil end
                return HttpService:JSONDecode(readfile(SON_CACHE))
            end)
            if ok and type(cache) == "table" then
                applyNames(_G.EliteSONSafe, cache.safe)
                applyNames(_G.EliteSONGrief, cache.grief)
            end
        end
        local body = requestGet(SON_URL, {
            ["x-api-key"] = "son-esp-key-2026",
            ["Content-Type"] = "application/json",
        })
        if not body then return end
        local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
        if not (ok and type(data) == "table") then return end
        applyNames(_G.EliteSONSafe, data.safe)
        applyNames(_G.EliteSONGrief, data.grief)
        if type(writefile) == "function" then
            pcall(writefile, SON_CACHE, HttpService:JSONEncode({
                t = os.time(),
                safe = data.safe,
                grief = data.grief,
            }))
        end
    end)
    pcall(function()
        local leftover = LP:FindFirstChild("PlayerGui")
        leftover = leftover and leftover:FindFirstChild("ElitePlayerEsp")
        if leftover then leftover:Destroy() end
        local old = CoreGui:FindFirstChild("ElitePlayerEsp")
        if old then old:Destroy() end
    end)
    local root = Instance.new("Folder")
    root.Name = "ElitePlayerEsp"
    pcall(function()
        root.Parent = CoreGui
    end)
    local tags = {}
    local conns = {}
    local alive = true
    local lastSweep = 0
    local _gcFound, _gcFoundN, _gcLast = nil, 0, 0
    local function bind(c)
        if c then conns[#conns + 1] = c end
        return c
    end
    local function esc(s)
        return tostring(s or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end
    local function scanSyncOnce()
        if type(getgc) ~= "function" then return end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        local live, nLive = {}, 0
        for _, p in ipairs(plots:GetChildren()) do
            live[p.Name] = true
            nLive = nLive + 1
        end
        if nLive == 0 then return end
        local best, bestN = nil, 0
        pcall(function()
            local gc = getgc(true)
            for i = 1, #gc do
                local t = gc[i]
                if type(t) == "table" then
                    pcall(function()
                        local hits, seen = 0, 0
                        for k, v in next, t do
                            seen = seen + 1
                            if type(k) == "string" and live[k]
                                and type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                                hits = hits + 1
                            end
                            if seen >= 64 then break end
                        end
                        if hits > bestN and hits >= 2 then
                            best, bestN = t, hits
                        end
                    end)
                    if bestN >= nLive then break end
                end
            end
        end)
        if best and bestN > _gcFoundN then
            _gcFound, _gcFoundN = best, bestN
        end
    end
    local function plotChannel(plot)
        if not plot then return nil end
        local ch
        pcall(function()
            if type(_G.EliteSyncGet) == "function" then
                ch = _G.EliteSyncGet(plot.Name)
            end
        end)
        if type(ch) == "table" then return ch end
        if not _gcFound and os.clock() - _gcLast >= 2 then
            _gcLast = os.clock()
            scanSyncOnce()
        end
        if _gcFound then
            local ok, cd = pcall(rawget, _gcFound, plot.Name)
            if ok and type(cd) == "table" then return cd end
        end
        local ord
        pcall(function()
            ord = plot:GetAttribute("Order")
        end)
        if ord ~= nil then
            local alt = "Plot" .. tostring(ord)
            pcall(function()
                if type(_G.EliteSyncGet) == "function" then
                    ch = _G.EliteSyncGet(alt)
                end
            end)
            if type(ch) == "table" then return ch end
            if _gcFound then
                local ok, cd = pcall(rawget, _gcFound, alt)
                if ok and type(cd) == "table" then return cd end
            end
        end
        return nil
    end
    local function channelGet(ch, key)
        if not ch then return nil end
        local v
        pcall(function()
            local ct = rawget(ch, "CacheTable")
            if type(ct) == "table" then v = ct[key] end
        end)
        return v
    end
    local function ownerFromPlot(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        if sign then
            local gui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
            local label = gui and gui:FindFirstChildWhichIsA("TextLabel", true)
            local text = label and label.Text
            if text and text ~= "" and not text:lower():find("empty") then
                return text:match("^(.+)'s Base$") or text
            end
        end
        local owner = channelGet(plotChannel(plot), "Owner")
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            return owner.Name
        end
        if type(owner) == "number" then
            local p = Players:GetPlayerByUserId(owner)
            return p and p.Name or nil
        end
        if type(owner) == "string" and owner ~= "" then
            return owner
        end
        return nil
    end
    local function resolveOwner(name)
        if not name or name == "" then return nil end
        local want = tostring(name):lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == want or (p.DisplayName or ""):lower() == want then
                return p
            end
        end
        return Players:FindFirstChild(name)
    end
    local function nearestPlotTo(pos)
        local plots = workspace:FindFirstChild("Plots")
        if not plots or not pos then return nil, math.huge end
        local best, bestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local part = sign and ((sign:IsA("BasePart") and sign) or sign:FindFirstChildWhichIsA("BasePart", true))
            if part then
                local d = (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(part.Position.X, 0, part.Position.Z)).Magnitude
                if d < bestDist then
                    bestDist, best = d, plot
                end
            end
        end
        return best, bestDist
    end
    local function currentBaseOwner()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local plot, dist = nearestPlotTo(hrp.Position)
        if not plot or dist > IN_BASE then return nil end
        local owner = resolveOwner(ownerFromPlot(plot))
        if owner and owner ~= LP then return owner end
        return nil
    end
    local function drop(uid)
        local rec = tags[uid]
        if rec then
            if rec.bb then pcall(function() rec.bb:Destroy() end) end
            if rec.hl then pcall(function() rec.hl:Destroy() end) end
        end
        tags[uid] = nil
    end
    local function tagLine(plr, ownerPlr)
        local bits = {}
        if isFmly(plr) then
            bits[#bits + 1] = '<font color="#facc15">FMLY</font>'
        end
        if isSon(plr) then
            bits[#bits + 1] = '<font color="#5ad4ff">SON</font>'
        end
        if ownerPlr and plr == ownerPlr then
            bits[#bits + 1] = '<font color="#b08cff">OWNER</font>'
        end
        return table.concat(bits, " ")
    end
    local function paint(plr, ownerPlr)
        if plr == LP then return end
        local uid = plr.UserId
        local char = plr.Character
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        if not head then
            drop(uid)
            return
        end
        local rec = tags[uid]
        if not rec or not rec.bb or not rec.bb.Parent then
            drop(uid)
            local bb = Instance.new("BillboardGui")
            bb.Name = "ElitePlayerEsp"
            bb.Size = UDim2.fromOffset(220, 40)
            bb.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.MaxDistance = 500
            bb.ResetOnSpawn = false
            bb.Adornee = head
            bb.Parent = root
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "Name"
            nameLbl.BackgroundTransparency = 1
            nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.TextStrokeTransparency = 0.2
            nameLbl.RichText = true
            nameLbl.Parent = bb
            local tagLbl = Instance.new("TextLabel")
            tagLbl.Name = "Tag"
            tagLbl.BackgroundTransparency = 1
            tagLbl.Size = UDim2.new(1, 0, 0.5, 0)
            tagLbl.Position = UDim2.fromScale(0, 0.5)
            tagLbl.Font = Enum.Font.GothamBold
            tagLbl.TextSize = 12
            tagLbl.TextStrokeTransparency = 0.25
            tagLbl.RichText = true
            tagLbl.Parent = bb
            local hl = Instance.new("Highlight")
            hl.Name = "ElitePlayerHL"
            hl.FillTransparency = 0.72
            hl.OutlineTransparency = 0.1
            hl.Adornee = char
            hl.Parent = char
            rec = { bb = bb, hl = hl, nameLbl = nameLbl, tagLbl = tagLbl }
            tags[uid] = rec
        end
        rec.bb.Adornee = head
        if rec.hl then
            rec.hl.Adornee = char
            if rec.hl.Parent ~= char then rec.hl.Parent = char end
        end
        local shown = esc(plr.DisplayName or plr.Name)
        if plr.DisplayName and plr.DisplayName ~= plr.Name then
            shown = shown .. ' <font color="#94949c">(' .. esc(plr.Name) .. ")</font>"
        end
        rec.nameLbl.Text = shown
        rec.tagLbl.Text = tagLine(plr, ownerPlr)
        if rec.hl then
            if ownerPlr and plr == ownerPlr then
                rec.hl.FillColor = Color3.fromRGB(176, 92, 255)
                rec.hl.OutlineColor = Color3.fromRGB(220, 190, 255)
            elseif isFmly(plr) then
                rec.hl.FillColor = Color3.fromRGB(250, 204, 21)
                rec.hl.OutlineColor = Color3.fromRGB(255, 236, 140)
            elseif isSon(plr) then
                rec.hl.FillColor = Color3.fromRGB(90, 212, 255)
                rec.hl.OutlineColor = Color3.fromRGB(190, 240, 255)
            else
                rec.hl.FillColor = Color3.fromRGB(180, 160, 220)
                rec.hl.OutlineColor = Color3.fromRGB(244, 240, 255)
            end
        end
    end
    local function sweep()
        if not alive then return end
        local ownerPlr = currentBaseOwner()
        local seen = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            seen[plr.UserId] = true
            pcall(paint, plr, ownerPlr)
        end
        for uid in pairs(tags) do
            if not seen[uid] then drop(uid) end
        end
    end
    local function unload()
        alive = false
        for _, c in ipairs(conns) do
            pcall(function()
                c:Disconnect()
            end)
        end
        table.clear(conns)
        for uid in pairs(tags) do drop(uid) end
        pcall(function()
            root:Destroy()
        end)
        _G.ElitePlayerEspUnload = nil
        _G.ElitePlayerEsp = nil
    end
    _G.ElitePlayerEspUnload = unload
    _G.ElitePlayerEsp = true
    bind(Players.PlayerRemoving:Connect(function(plr)
        drop(plr.UserId)
    end))
    bind(RunService.Heartbeat:Connect(function()
        if not alive then return end
        local now = os.clock()
        if now - lastSweep < REFRESH then return end
        lastSweep = now
        pcall(sweep)
    end))
    task.defer(sweep)
end)