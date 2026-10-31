--[[
    ═══════════════════════════════════════════════════════════════
    SHITSAKEN - v9.9.0
    ═══════════════════════════════════════════════════════════════
    • XÓA HOÀN TOÀN sound-based M1 detection
    • Auto block CHỈ dựa vào attribute (AbilityLastUsed / AbilitiesUsed)
    • Hộp tím bám killer mượt mà mỗi frame (RenderStepped)
    • Hộp xanh bám killer khi block success
    • Chỉ 1 hộp visible tồn tại cùng lúc
    ═══════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("[shitsaken] Loading v9.9.0...")
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS
-- ═══════════════════════════════════════════════════════════════
local Settings = {
    AntiBlindness=false, AntiGlitch=false, AntiSubspaced=false, AntiNoliLaugh=false,
    MinionESP=false, ProjectileESP=false, AzureTrapESP=false,
    AutoBlock=false, AutoBlockButton=false, FourthButtonTarget="default", ABMode="Guest1337", AimPunch=false,
    FOVValue=120, LowGraphics=false, MaxZoom=false, FPSPing=false,
    NoclipCam=false, ForceChat=false, Disable007n7=false, ShowPrivacy=false,
    AutoBlockCustom=false, CustomABMode="Guest1337",
    CustomDiamondLength=8, CustomDiamondWidth=4, CustomDiamondOffset=3,
    CustomCircleRadius=5, ShowDiamond=false, ShowCircle=false, ZoneHeight=0.5,
    AutoBlockRectangle=false, RectangleABMode="Guest1337",
    RectangleDistance=3, RectangleMultiplier=1, RectangleTransparency=0.85, RectangleEdgeTransparency=0.2,
}

local Toggles, Sliders = {}, {}
local Inputs = {}
local PlayerDropdown = nil
local _suppressToggleCallback = false
local zoneStateMemory = { diamond=false, circle=false }

-- ═══════════════════════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════════════════════
local CONFIG_FOLDER = "TestHub"
local CONFIG_NAME = "default"
local function GetConfigPath() return CONFIG_FOLDER.."/"..CONFIG_NAME..".json" end
local function SaveConfig()
    if not (writefile and isfolder and makefolder) then return false end
    pcall(function() if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end end)
    return pcall(function() writefile(GetConfigPath(), HttpService:JSONEncode(Settings)) end)
end
local function ReadConfigFile()
    if not (isfile and readfile and isfile(GetConfigPath())) then return nil end
    local ok, d = pcall(function() return HttpService:JSONDecode(readfile(GetConfigPath())) end)
    if ok and type(d) == "table" then return d end
    return nil
end
local function DeleteConfigFile()
    if not (isfile and delfile) then return false end
    if isfile(GetConfigPath()) then pcall(function() delfile(GetConfigPath()) end); return true end
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- ANTI BLINDNESS
-- ═══════════════════════════════════════════════════════════════
local AntiBlindness = { running=false, conn=nil }
local function StartAntiBlindness()
    if AntiBlindness.running then return end
    AntiBlindness.running = true
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("BlurEffect") then pcall(function() obj:Destroy() end) end
    end
    AntiBlindness.conn = Lighting.ChildAdded:Connect(function(obj)
        if AntiBlindness.running and obj:IsA("BlurEffect") then pcall(function() obj:Destroy() end) end
    end)
end
local function StopAntiBlindness()
    AntiBlindness.running = false
    if AntiBlindness.conn then AntiBlindness.conn:Disconnect(); AntiBlindness.conn = nil end
end

-- ═══════════════════════════════════════════════════════════════
-- ANTI GLITCH
-- ═══════════════════════════════════════════════════════════════
local AntiGlitch = { running=false, connections={} }
local function StartAntiGlitch()
    if AntiGlitch.running then return end
    AntiGlitch.running = true
    local TARGETS = { Glitched=true, Hallucination=true }
    local function isTarget(obj)
        if not obj or not TARGETS[obj.Name] then return false end
        local m = PlayerGui:FindFirstChild("MainUI")
        local tu = PlayerGui:FindFirstChild("TemporaryUI")
        if m then
            local sc = m:FindFirstChild("StatusContainer")
            if sc and obj:IsDescendantOf(sc) then return true end
        end
        if tu and obj:IsDescendantOf(tu) then return true end
        return false
    end
    local function process(obj)
        if not obj or not obj.Parent then return end
        if isTarget(obj) then pcall(function() obj:Destroy() end)
        elseif obj:IsA("Frame") then
            local tu = PlayerGui:FindFirstChild("TemporaryUI")
            if tu then
                local f = tu:FindFirstChild("Frame")
                if f and obj:IsDescendantOf(f) then pcall(function() obj:Destroy() end) end
            end
        end
    end
    local function watch(root)
        if not root then return end
        table.insert(AntiGlitch.connections, root.DescendantAdded:Connect(process))
        for _, o in ipairs(root:GetDescendants()) do process(o) end
    end
    watch(PlayerGui)
end
local function StopAntiGlitch()
    AntiGlitch.running = false
    for _, c in ipairs(AntiGlitch.connections) do pcall(function() c:Disconnect() end) end
    AntiGlitch.connections = {}
end

-- ═══════════════════════════════════════════════════════════════
-- ANTI SUBSPACED
-- ═══════════════════════════════════════════════════════════════
local AntiSubspaced = { running=false, connections={} }
local function StartAntiSubspaced()
    if AntiSubspaced.running then return end
    AntiSubspaced.running = true
    local LT = { SubspaceVFXBlur=true, SubspaceVFXColorCorrection=true, HealthDesaturation=true }
    local UT = { Subspaced=true }
    local function process(obj)
        if not obj or not obj.Parent then return end
        if LT[obj.Name] and obj:IsDescendantOf(Lighting) then pcall(function() obj:Destroy() end) end
        if UT[obj.Name] then
            local m = PlayerGui:FindFirstChild("MainUI")
            local tu = PlayerGui:FindFirstChild("TemporaryUI")
            if m then
                local sc = m:FindFirstChild("StatusContainer")
                if sc and obj:IsDescendantOf(sc) then pcall(function() obj:Destroy() end) return end
            end
            if tu and obj:IsDescendantOf(tu) then pcall(function() obj:Destroy() end) end
        end
    end
    local function watch(root)
        if not root then return end
        table.insert(AntiSubspaced.connections, root.DescendantAdded:Connect(process))
        for _, o in ipairs(root:GetDescendants()) do process(o) end
    end
    watch(Lighting); watch(PlayerGui)
end
local function StopAntiSubspaced()
    AntiSubspaced.running = false
    for _, c in ipairs(AntiSubspaced.connections) do pcall(function() c:Disconnect() end) end
    AntiSubspaced.connections = {}
end

-- ═══════════════════════════════════════════════════════════════
-- ANTI NOLI LAUGH
-- ═══════════════════════════════════════════════════════════════
local AntiNoliLaugh = { running=false, connections={} }
local function StartAntiNoliLaugh()
    if AntiNoliLaugh.running then return end
    AntiNoliLaugh.running = true
    local function process(obj)
        if not obj or not obj.Parent then return end
        if obj.Name == "noliLaugh" then
            local cam = Workspace.CurrentCamera
            if cam and (obj:IsDescendantOf(cam) or obj:IsDescendantOf(Workspace)) then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    local function watch(root)
        if not root then return end
        table.insert(AntiNoliLaugh.connections, root.DescendantAdded:Connect(process))
        for _, o in ipairs(root:GetDescendants()) do process(o) end
    end
    watch(Workspace.CurrentCamera)
    table.insert(AntiNoliLaugh.connections, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() watch(Workspace.CurrentCamera) end))
    local wc = Workspace:FindFirstChild("Camera")
    if wc then watch(wc) end
    table.insert(AntiNoliLaugh.connections, Workspace.ChildAdded:Connect(function(o) if o.Name == "Camera" then watch(o) end end))
end
local function StopAntiNoliLaugh()
    AntiNoliLaugh.running = false
    for _, c in ipairs(AntiNoliLaugh.connections) do pcall(function() c:Disconnect() end) end
    AntiNoliLaugh.connections = {}
end

-- ═══════════════════════════════════════════════════════════════
-- MINION ESP
-- ═══════════════════════════════════════════════════════════════
local MinionESP = { running=false, connections={}, folder=nil }
local playerCharacters = setmetatable({}, {__mode="k"})
local playerCharSet = {}
local function registerPlayer(player)
    if player.Character then
        playerCharacters[player.Character] = player
        playerCharSet[player.Character] = player
    end
    player.CharacterAdded:Connect(function(char)
        playerCharacters[char] = player
        playerCharSet[char] = player
        task.wait(0.1)
        if MinionESP.folder then
            local it = MinionESP.folder:FindFirstChild(char:GetDebugId())
            if it then it:Destroy() end
        end
    end)
end
for _, p in ipairs(Players:GetPlayers()) do registerPlayer(p) end
Players.PlayerAdded:Connect(registerPlayer)
Players.PlayerRemoving:Connect(function(p)
    if p.Character then playerCharacters[p.Character] = nil; playerCharSet[p.Character] = nil end
end)

local MINION_SKINS = {"primordial","betrayed","classic","crew leader","evil green skeleton","soccer legend","green guest","toy","16th night","pride","green envy","darkness","infernum","monochrome","illumina","bluesteel","everfrost","fleskhjerta","voidbound","timeless","toon","xx4ce0fspadesxx","ace","milestone zero","milestone i","milestone ii","milestone iii","milestone iv","milestone","guardian","hacklord","erlking","crazyblox","martyr","eye of the abyss","savior","scarletkidd","guide shedletsky","shedletsky","jack frost","eggs","champion","big 1x1x1x1","big 1x1"}

local function StartMinionESP()
    if MinionESP.running then return end
    MinionESP.running = true
    local folder = Instance.new("Folder"); folder.Name = "MinionESP_Highlights"; folder.Parent = CoreGui
    MinionESP.folder = folder
    local BLOCKLIST = {"killer","kidd","1x1x1x1","c00lkidd","c00lkid","jane","doe","jane_doe","janedoe","lobby","ambient","decor","prop","dummy","statue","mannequin","display","preview","shop","corpse","dead","ragdoll","body","bone","npc","character"}
    local LOBBY_FOLDERS = {"lobby","menu","npc","ambient","decor","characters","preview","display","shop","spawn_area"}
    local MINION_FOLDERS = {"minion","enem","summon","spawned","mob","rotten"}
    local function nameHas(n, kws) local l = string.lower(n); for _, kw in ipairs(kws) do if string.find(l, kw, 1, true) then return true end end; return false end
    local function isSkinName(name) local l = string.lower(name); for _, s in ipairs(MINION_SKINS) do if l == s or string.find(l, s, 1, true) then return true end end; return false end
    local function inSkinAncestor(o) local c,d=o,0; while c and d<5 do if isSkinName(c.Name) then return true end; c,d=c.Parent,d+1 end; return false end
    local function inBlock(o) local c,d=o,0; while c and d<5 do if nameHas(c.Name,BLOCKLIST) then return true end; c,d=c.Parent,d+1 end; return false end
    local function inLobby(o) local c,d=o.Parent,0; while c and d<5 do if nameHas(c.Name,LOBBY_FOLDERS) then return true end; c,d=c.Parent,d+1 end; return false end
    local function inMinionF(o) local c,d=o.Parent,0; while c and d<5 do if nameHas(c.Name,MINION_FOLDERS) then return true end; c,d=c.Parent,d+1 end; return false end
    local function isRealPlayer(o)
        if playerCharacters[o] or playerCharSet[o] then return true end
        local ok, plr = pcall(function() return Players:GetPlayerFromCharacter(o) end)
        if ok and plr then return true end
        for char in pairs(playerCharSet) do
            if char and char.Parent then
                if o == char then return true end
                local ok2, isD = pcall(function() return o:IsDescendantOf(char) end)
                if ok2 and isD then return true end
            else playerCharSet[char] = nil end
        end
        local c, d = o, 0
        while c and d < 10 do if c:IsA("Player") then return true end; c, d = c.Parent, d+1 end
        return false
    end
    local function isMinion(o)
        if not o:IsA("Model") then return false end
        if isRealPlayer(o) then return false end
        local is1x = inSkinAncestor(o)
        if not is1x and inBlock(o) then return false end
        if inLobby(o) then return false end
        local inMinF = inMinionF(o)
        local hum = o:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return false end
        local root = o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Torso") or o:FindFirstChild("UpperTorso") or o:FindFirstChild("Head")
        if not root then return false end
        local a, t = 0, 0
        for _, p in ipairs(o:GetChildren()) do if p:IsA("BasePart") then t = t+1; if p.Anchored then a = a+1 end end end
        if t > 0 and a == t then return false end
        if not inMinF and not is1x and root.Anchored then return false end
        return true
    end
    local function applyHL(model)
        if not model or not model:IsA("Model") or isRealPlayer(model) then return end
        local id = model:GetDebugId()
        if folder:FindFirstChild(id) then return end
        local h = Instance.new("Highlight")
        h.Name = id; h.Adornee = model
        h.FillTransparency = 0.5; h.FillColor = Color3.fromRGB(255,255,0)
        h.OutlineColor = Color3.fromRGB(255,255,0); h.OutlineTransparency = 0
        h.Parent = folder
        model.Destroying:Connect(function() if h then h:Destroy() end end)
        task.delay(0.3, function() if h and h.Parent and isRealPlayer(model) then h:Destroy() end end)
    end
    local function check(o) if MinionESP.running and isMinion(o) then applyHL(o) end end
    for _, o in ipairs(Workspace:GetDescendants()) do check(o) end
    table.insert(MinionESP.connections, Workspace.DescendantAdded:Connect(function(o) task.wait(0.1); check(o) end))
end
local function StopMinionESP()
    MinionESP.running = false
    for _, c in ipairs(MinionESP.connections) do pcall(function() c:Disconnect() end) end
    MinionESP.connections = {}
    if MinionESP.folder then pcall(function() MinionESP.folder:Destroy() end); MinionESP.folder = nil end
end

-- ═══════════════════════════════════════════════════════════════
-- PROJECTILE ESP
-- ═══════════════════════════════════════════════════════════════
local ProjectileESP = { running=false, connections={}, folder=nil }
local function StartProjectileESP()
    if ProjectileESP.running then return end
    ProjectileESP.running = true
    local folder = Instance.new("Folder"); folder.Name = "ProjectileESP_Highlights"; folder.Parent = Workspace
    ProjectileESP.folder = folder
    local COLOR = Color3.fromRGB(255,50,50)
    local ORIGINAL = { HumanoidRootProjectile=true }
    local LOBBY_KWS = {"lobby","spawn","menu","waitingroom","decor","ambient"}
    local tracked, hls = setmetatable({},{__mode="k"}), setmetatable({},{__mode="k"})
    local function isPlayerChar(o)
        for _, p in ipairs(Players:GetPlayers()) do
            local ch = p.Character
            if ch and o:IsDescendantOf(ch) then return true end
        end
        local m = o:FindFirstAncestorOfClass("Model")
        if m and m:FindFirstChildOfClass("Humanoid") then return true end
        return false
    end
    local function isInLobby(o)
        local c = o.Parent
        while c and c ~= Workspace do
            local n = c.Name:lower()
            for _, kw in ipairs(LOBBY_KWS) do if n:find(kw) then return true end end
            c = c.Parent
        end
        return false
    end
    local function applyHL(part)
        if not ProjectileESP.running or not part or not part.Parent or tracked[part] then return end
        local hl = Instance.new("Highlight")
        hl.Name = "ProjESPHL"; hl.Adornee = part
        hl.FillColor = COLOR; hl.FillTransparency = 0.35
        hl.OutlineColor = Color3.fromRGB(255,255,255); hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = folder
        tracked[part] = true; hls[part] = hl
        part.AncestryChanged:Connect(function(_, parent)
            if not parent then tracked[part]=nil; if hl and hl.Parent then hl:Destroy() end; hls[part]=nil end
        end)
    end
    local function eval(o)
        if not ProjectileESP.running or not o or not o.Parent or isPlayerChar(o) or isInLobby(o) then return end
        if ORIGINAL[o.Name] and o:IsA("BasePart") then
            local fn = o:GetFullName()
            if fn:find("Map.Ingame",1,true) then applyHL(o) end
        end
    end
    table.insert(ProjectileESP.connections, Workspace.DescendantAdded:Connect(function(o)
        if not ProjectileESP.running then return end
        if o:IsA("BasePart") or o:IsA("Model") then eval(o) end
    end))
    task.spawn(function()
        local cnt = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if not ProjectileESP.running then break end
            if o:IsA("BasePart") or o:IsA("Model") then eval(o); cnt=cnt+1; if cnt%250==0 then task.wait() end end
        end
    end)
end
local function StopProjectileESP()
    ProjectileESP.running = false
    for _, c in ipairs(ProjectileESP.connections) do pcall(function() c:Disconnect() end) end
    ProjectileESP.connections = {}
    if ProjectileESP.folder then pcall(function() ProjectileESP.folder:Destroy() end); ProjectileESP.folder = nil end
end

-- ═══════════════════════════════════════════════════════════════
-- AZURE TRAP ESP
-- ═══════════════════════════════════════════════════════════════
local AzureTrapESP = { running=false, connections={}, folder=nil }
local function StartAzureTrapESP()
    if AzureTrapESP.running then return end
    AzureTrapESP.running = true
    local folder = Instance.new("Folder"); folder.Name = "AzureTrapESP_Folder"; folder.Parent = Workspace
    AzureTrapESP.folder = folder
    local COLOR = Color3.fromRGB(160,32,240)
    local MAX, RETRY, LOOP = 6, 5, 0.3
    local AZURE = {["Flower_Base"]=true,["Flower_Bottom"]=true,["Flower_Root"]=true,["Flower_Tentacle"]=true,["Flower_Top"]=true,["Nectar"]=true,["Root1"]=true,["Root2"]=true,["Root3"]=true,["Root4"]=true,["Tendril_Middle"]=true,["Tentacle"]=true,["Tentacle42.001"]=true,["Tentacle_Base"]=true,["GroundBulb"]=true,["Vine"]=true}
    local LOBBY = {"lobby","spawn","menu","waitingroom","decor","ambient"}
    local hl, tr, rec = {}, {}, {}
    local cnt, blk, counted = {}, {}, {}
    local function isPlayerChar(o)
        for _, p in ipairs(Players:GetPlayers()) do
            local ch = p.Character
            if ch and o:IsDescendantOf(ch) then return true end
        end
        local m = o:FindFirstAncestorOfClass("Model")
        return m and m:FindFirstChildOfClass("Humanoid")
    end
    local function isInLobby(o)
        local c = o.Parent
        while c and c ~= Workspace do
            local n = c.Name:lower()
            for _, kw in ipairs(LOBBY) do if n:find(kw) then return true end end
            c = c.Parent
        end
        return false
    end
    local function isAzure(p) return AZURE[p.Name] and not blk[p.Name] end
    local function clear(n) for p, h in pairs(hl) do if p.Name == n then if h and h.Parent then h:Destroy() end; hl[p]=nil; tr[p]=nil end end end
    local function inc(p)
        if counted[p] or not AZURE[p.Name] then return end
        counted[p]=true; cnt[p.Name]=(cnt[p.Name] or 0)+1
        if cnt[p.Name] > MAX and not blk[p.Name] then blk[p.Name]=true; clear(p.Name) end
    end
    local function dec(p)
        if not counted[p] then return end
        counted[p]=nil
        local n = p.Name
        if not cnt[n] then return end
        cnt[n]=math.max(0,cnt[n]-1)
        if cnt[n] <= MAX and blk[n] then blk[n]=nil end
    end
    local function cleanup(p) dec(p); tr[p]=nil; rec[p]=nil; if hl[p] then if hl[p].Parent then hl[p]:Destroy() end; hl[p]=nil end end
    local function create(p)
        if tr[p] then return end
        if hl[p] then tr[p]=true; return end
        local h = Instance.new("Highlight")
        h.Name="AzureTrapHL"; h.Adornee=p
        h.FillColor=COLOR; h.FillTransparency=0.75
        h.OutlineColor=COLOR; h.OutlineTransparency=0
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent=folder; hl[p]=h; tr[p]=true
    end
    local function handle(p)
        if not AzureTrapESP.running or not p:IsA("BasePart") then return end
        if tr[p] or isPlayerChar(p) or isInLobby(p) then return end
        if not isAzure(p) then return end
        if not p:GetAttribute("AzureESP_Hooked") then
            p:SetAttribute("AzureESP_Hooked", true)
            p.AncestryChanged:Connect(function(_, parent) if not parent then cleanup(p) end end)
        end
        create(p)
    end
    for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") and AZURE[o.Name] then counted[o]=true; cnt[o.Name]=(cnt[o.Name] or 0)+1 end end
    for n, c in pairs(cnt) do if c > MAX then blk[n]=true end end
    for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then handle(o) end end
    table.insert(AzureTrapESP.connections, Workspace.DescendantAdded:Connect(function(o)
        if not o:IsA("BasePart") then return end
        inc(o); rec[o]=tick(); handle(o)
    end))
    task.spawn(function()
        while AzureTrapESP.running do
            task.wait(LOOP)
            local now = tick()
            for p, t in pairs(rec) do
                if not p.Parent then rec[p]=nil
                elseif now - t > RETRY then rec[p]=nil
                elseif not tr[p] then handle(p) end
            end
        end
    end)
end
local function StopAzureTrapESP()
    AzureTrapESP.running = false
    for _, c in ipairs(AzureTrapESP.connections) do pcall(function() c:Disconnect() end) end
    AzureTrapESP.connections = {}
    if AzureTrapESP.folder then pcall(function() AzureTrapESP.folder:Destroy() end); AzureTrapESP.folder = nil end
end

-- ═══════════════════════════════════════════════════════════════
-- FORCE CHAT / DISABLE 007n7 / SHOW PRIVACY
-- ═══════════════════════════════════════════════════════════════
local ForceChat = { running=false }
local function StartForceChat()
    if ForceChat.running then return end
    ForceChat.running = true
    task.spawn(function()
        while ForceChat.running do
            task.wait(0.5)
            pcall(function()
                local cw = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
                if cw then cw.Enabled = true end
            end)
        end
    end)
end
local function StopForceChat() ForceChat.running = false end

local Disable007n7 = { running=false, moved={} }
local function StartDisable007n7()
    if Disable007n7.running then return end
    Disable007n7.running = true
    Disable007n7.moved = {}
    task.spawn(function()
        while Disable007n7.running do
            task.wait(0.5)
            local ingame = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
            if ingame then
                for _, v in ipairs(ingame:GetChildren()) do
                    if v.Name:lower() == "007n7" and not Players:GetPlayerFromCharacter(v) then
                        local orig = v.Parent
                        if pcall(function() v.Parent = Lighting end) then Disable007n7.moved[v] = orig end
                    end
                end
            end
        end
    end)
end
local function StopDisable007n7()
    Disable007n7.running = false
    for obj, parent in pairs(Disable007n7.moved) do
        if obj and obj.Parent == Lighting and parent and parent.Parent then pcall(function() obj.Parent = parent end) end
    end
    table.clear(Disable007n7.moved)
end

local ShowPrivacy = { running=false }
local function StartShowPrivacy()
    if ShowPrivacy.running then return end
    ShowPrivacy.running = true
    task.spawn(function()
        while ShowPrivacy.running do
            task.wait(0.5)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local data = p:FindFirstChild("PlayerData")
                    local privacy = data and data:FindFirstChild("Privacy", true)
                    if privacy then
                        for _, setting in ipairs(privacy:GetChildren()) do
                            if setting:IsA("BoolValue") then pcall(function() setting.Value = false end) end
                        end
                    end
                end
            end
        end
    end)
end
local function StopShowPrivacy() ShowPrivacy.running = false end

-- ═══════════════════════════════════════════════════════════════
-- AUTO BLOCK CORE
-- ═══════════════════════════════════════════════════════════════
local AB = {
    running=false, connections={},
    attrStates={}, attrDebounce=0,
    punchDebounce=0,
    generation=0,
    RemoteEvent=nil, KillersFolder=nil, LocalRoot=nil,
}
local StartAutoBlock, StopAutoBlock
local StartFourthButton, StopFourthButton
local FourthBlock = {
    instance=nil, applyTint=nil, running=false, connections={},
    cachedPos=nil, cachedSize=nil, sourceName=nil,
}

local abLastToggle = 0
local abPendingState = nil
local abPendingTask = nil
local abDebounce = 0.08

do
    local rs = ReplicatedStorage
    local modules = rs:FindFirstChild("Modules")
    local net = modules and modules:FindFirstChild("Network", true)
    local net2 = net and net:FindFirstChild("Network", true)
    AB.RemoteEvent = net2 and net2:FindFirstChild("RemoteEvent")
    if not AB.RemoteEvent then AB.RemoteEvent = rs:FindFirstChild("RemoteEvent", true) end
end

local function GetPing()
    local ping = 0.05
    pcall(function()
        local ns = Stats:FindFirstChild("Network")
        local ssi = ns and ns:FindFirstChild("ServerStatsItem")
        local dp = ssi and ssi:FindFirstChild("Data Ping")
        if dp then ping = dp:GetValue() / 1000 end
    end)
    return math.clamp(ping, 0.05, 0.35)
end

-- ✅ Sound ID M1 đã bị xóa hoàn toàn — chỉ giữ block success sound để AimPunch
local BlockSounds = {
    ["rbxassetid://132298811847315"]=true,["rbxassetid://81114852524420"]=true,
    ["rbxassetid://123825742002486"]=true,["rbxassetid://116616310968045"]=true,
    ["rbxassetid://102808968188291"]=true,["rbxassetid://117828699507982"]=true,
    ["rbxassetid://125854302746190"]=true,["rbxassetid://18568553101"]=true,
    ["rbxassetid://95135835034592"]=true,["rbxassetid://135209101640984"]=true,
    ["rbxassetid://91165993312513"]=true,["rbxassetid://82772022662025"]=true,
}
local function isBlockSnd(sid)
    if not sid or sid == "" then return false end
    if BlockSounds[sid] then return true end
    local n = sid:match("rbxassetid://(%d+)") or sid:match("^(%d+)$")
    return n and BlockSounds["rbxassetid://"..n] or false
end

local function FireAbility(name)
    if AB.RemoteEvent then pcall(function() AB.RemoteEvent:FireServer("UseActorAbility", {name}) end) end
end
local function FireBlock() FireAbility("Block") end
local function FireClone() FireAbility("Clone") end

local function GetActiveMode()
    if Settings.AutoBlockRectangle then return Settings.RectangleABMode end
    if Settings.AutoBlockCustom then return Settings.CustomABMode end
    return Settings.ABMode
end
local function FireAbilityByMode()
    if GetActiveMode() == "007n7" then FireClone() else FireBlock() end
end

local function GetNearestKiller()
    local folder = AB.KillersFolder
    if not folder or not folder.Parent then
        local p = Workspace:FindFirstChild("Players")
        folder = p and p:FindFirstChild("Killers")
    end
    local localRoot = AB.LocalRoot
    if not localRoot or not localRoot.Parent then
        local char = LocalPlayer.Character
        localRoot = char and char:FindFirstChild("HumanoidRootPart")
    end
    if not folder or not localRoot then return nil, nil end
    local nearest, model, minD = nil, nil, 30
    for _, k in pairs(folder:GetChildren()) do
        local kr = k:FindFirstChild("HumanoidRootPart")
        if kr then
            local d = (localRoot.Position - kr.Position).Magnitude
            if d < minD then minD = d; nearest = kr; model = k end
        end
    end
    return nearest, model
end

local function AimPunch()
    local kr, km = GetNearestKiller()
    if not (kr and AB.LocalRoot and km) then return end
    local kh = km:FindFirstChildOfClass("Humanoid")
    local start = tick(); local lastPos = kr.Position
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not AB.running or tick() - start > 0.6 or not AB.LocalRoot or not kr then conn:Disconnect(); return end
        local cur = AB.LocalRoot.Position
        local tgt = kr.Position
        local vel = (tgt - lastPos) / math.max(dt, 0.001); lastPos = tgt
        local mdir = kh and kh.MoveDirection or Vector3.new()
        local ws = kh and kh.WalkSpeed or 16
        local lead = 0.24 + GetPing()
        local pred = tgt + mdir * ws * lead + Vector3.new(vel.X, 0, vel.Z) * 0.08
        AB.LocalRoot.CFrame = CFrame.lookAt(cur, Vector3.new(pred.X, cur.Y, pred.Z))
    end)
end

local OnBlockSuccess

local function MonitorBlockSuccess(char)
    if not char then return end
    local function check(v) if v:IsA("Sound") and isBlockSnd(v.SoundId) then OnBlockSuccess() end end
    for _, v in pairs(char:GetDescendants()) do check(v) end
    table.insert(AB.connections, char.DescendantAdded:Connect(check))
end

-- ═══════════════════════════════════════════════════════════════
-- CUSTOM ZONE
-- ═══════════════════════════════════════════════════════════════
local CustomZone = { running=false, connections={}, folder=nil, killerZones={} }
local PLAYER_RADIUS = 1.5

local function GetKillerGroundCF(kr)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {kr.Parent, LocalPlayer.Character}
    params.IgnoreWater = true
    local ray = Workspace:Raycast(kr.Position, Vector3.new(0, -30, 0), params)
    local groundY = ray and (kr.Position.Y - ray.Distance) or (kr.Position.Y - 3)
    return CFrame.new(kr.Position.X, groundY + (Settings.ZoneHeight or 0.5), kr.Position.Z) * kr.CFrame.Rotation
end

local function BuildZone(killer)
    local model = Instance.new("Model"); model.Name = "ABCustomZone_"..killer.Name; model.Parent = CustomZone.folder
    local edges = {}
    for i = 1, 4 do
        local p = Instance.new("Part")
        p.Name="Edge"..i; p.Anchored=true; p.CanCollide=false; p.CanQuery=false; p.CanTouch=false
        p.CastShadow=false; p.Material=Enum.Material.Neon
        p.Color=Color3.fromRGB(255,0,0); p.Transparency=0.3
        p.Size=Vector3.new(0.35,0.08,1); p.CFrame=CFrame.new(0,-5000,0)
        p.Parent = model; edges[i] = p
    end
    local circle = Instance.new("Part")
    circle.Shape=Enum.PartType.Cylinder; circle.Name="Circle"
    circle.Anchored=true; circle.CanCollide=false; circle.CanQuery=false; circle.CanTouch=false
    circle.CastShadow=false; circle.Material=Enum.Material.Neon
    circle.Color=Color3.fromRGB(255,0,0); circle.Transparency=0.65
    circle.Size=Vector3.new(0.08,10,10); circle.CFrame=CFrame.new(0,-5000,0)
    circle.Parent = model
    return { model=model, edges=edges, circle=circle, killer=killer }
end

local function IsPlayerInDiamond(myPos, killerCF, killerPos)
    if not Settings.ShowDiamond then return false end
    local fwd = killerCF.LookVector; local right = killerCF.RightVector
    local flatFwd = Vector3.new(fwd.X, 0, fwd.Z); local flatRight = Vector3.new(right.X, 0, right.Z)
    if flatFwd.Magnitude < 0.01 or flatRight.Magnitude < 0.01 then return false end
    flatFwd = flatFwd.Unit; flatRight = flatRight.Unit
    local toPlayer = Vector3.new(myPos.X - killerPos.X, 0, myPos.Z - killerPos.Z)
    local distFwd = toPlayer:Dot(flatFwd); local distRight = toPlayer:Dot(flatRight)
    local centerDist = Settings.CustomDiamondOffset + Settings.CustomDiamondLength / 2
    local dF = distFwd - centerDist
    local halfW = Settings.CustomDiamondWidth / 2 + PLAYER_RADIUS
    local halfL = Settings.CustomDiamondLength / 2 + PLAYER_RADIUS
    return math.abs(distRight) / halfW + math.abs(dF) / halfL <= 1
end

local function IsPlayerInCircle(myPos, killerPos)
    if not Settings.ShowCircle then return false end
    local dx = myPos.X - killerPos.X; local dz = myPos.Z - killerPos.Z
    local effectiveR = Settings.CustomCircleRadius + PLAYER_RADIUS
    return dx*dx + dz*dz <= effectiveR * effectiveR
end

local function IsPlayerInCustomZone(killer)
    if not killer or not killer.Parent then return false end
    local kr = killer:FindFirstChild("HumanoidRootPart")
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not kr or not myRoot then return false end
    return IsPlayerInDiamond(myRoot.Position, kr.CFrame, kr.Position) or IsPlayerInCircle(myRoot.Position, kr.Position)
end

local function UpdateZone(zone, kr, myRoot)
    if not zone or not zone.model or not zone.model.Parent then return end
    if not kr or not kr.Parent then return end
    local baseCF = GetKillerGroundCF(kr)
    local offset = Settings.CustomDiamondOffset
    local L = Settings.CustomDiamondLength; local W = Settings.CustomDiamondWidth
    local wA = baseCF:PointToWorldSpace(Vector3.new(0, 0, -offset))
    local wB = baseCF:PointToWorldSpace(Vector3.new(0, 0, -(offset + L)))
    local wC = baseCF:PointToWorldSpace(Vector3.new(-W/2, 0, -(offset + L/2)))
    local wD = baseCF:PointToWorldSpace(Vector3.new(W/2, 0, -(offset + L/2)))
    local edgeSpecs = { {wA,wC}, {wA,wD}, {wB,wC}, {wB,wD} }
    for i, spec in ipairs(edgeSpecs) do
        local p1, p2 = spec[1], spec[2]
        local mid = (p1 + p2) / 2; local diff = p2 - p1
        local length = diff.Magnitude
        if length > 0.01 then
            local edge = zone.edges[i]
            if edge then
                edge.Size = Vector3.new(0.35, 0.08, length)
                edge.CFrame = CFrame.lookAt(mid, mid + diff.Unit)
                edge.Transparency = Settings.ShowDiamond and 0.3 or 1
            end
        end
    end
    if zone.circle then
        local cCenter = Vector3.new(baseCF.Position.X, baseCF.Position.Y + 0.04, baseCF.Position.Z)
        zone.circle.Size = Vector3.new(0.08, Settings.CustomCircleRadius*2, Settings.CustomCircleRadius*2)
        zone.circle.CFrame = CFrame.new(cCenter) * CFrame.Angles(0, 0, math.rad(90))
        zone.circle.Transparency = Settings.ShowCircle and 0.65 or 1
    end
    local inDiamond = myRoot and IsPlayerInDiamond(myRoot.Position, kr.CFrame, kr.Position) or false
    local inCircle = myRoot and IsPlayerInCircle(myRoot.Position, kr.Position) or false
    local diamondColor = inDiamond and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    local circleColor = inCircle and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    for _, e in ipairs(zone.edges) do if e and e.Parent then e.Color = diamondColor end end
    if zone.circle and zone.circle.Parent then zone.circle.Color = circleColor end
end

local function StartCustomZoneVisuals()
    if CustomZone.running then return end
    CustomZone.running = true
    CustomZone.connections = {}
    CustomZone.killerZones = {}
    CustomZone.folder = Instance.new("Folder"); CustomZone.folder.Name = "ABCustomZoneVisuals"; CustomZone.folder.Parent = Workspace
    table.insert(CustomZone.connections, RunService.RenderStepped:Connect(function()
        if not CustomZone.running then return end
        local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
        if not killersFolder then return end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        for _, killer in ipairs(killersFolder:GetChildren()) do
            if killer:IsA("Model") then
                local kr = killer:FindFirstChild("HumanoidRootPart")
                if kr then
                    local zone = CustomZone.killerZones[killer]
                    if not zone or not zone.model or not zone.model.Parent then
                        if zone and zone.model then pcall(function() zone.model:Destroy() end) end
                        zone = BuildZone(killer)
                        CustomZone.killerZones[killer] = zone
                    end
                    UpdateZone(zone, kr, myRoot)
                end
            end
        end
        for killer, zone in pairs(CustomZone.killerZones) do
            if not killer.Parent or not killer:IsDescendantOf(Workspace) then
                if zone.model then pcall(function() zone.model:Destroy() end) end
                CustomZone.killerZones[killer] = nil
            end
        end
    end))
end
local function StopCustomZoneVisuals()
    if not CustomZone.running then return end
    CustomZone.running = false
    for _, c in ipairs(CustomZone.connections) do pcall(function() c:Disconnect() end) end
    CustomZone.connections = {}
    for killer, zone in pairs(CustomZone.killerZones) do
        if zone.model then pcall(function() zone.model:Destroy() end) end
    end
    CustomZone.killerZones = {}
    if CustomZone.folder then pcall(function() CustomZone.folder:Destroy() end); CustomZone.folder = nil end
end
local function UpdateCustomZoneVisibility()
    local shouldShow = Settings.ShowDiamond or Settings.ShowCircle
    if shouldShow and not CustomZone.running then StartCustomZoneVisuals()
    elseif not shouldShow and CustomZone.running then StopCustomZoneVisuals() end
end

-- ═══════════════════════════════════════════════════════════════
-- RECTANGLE — v9.9.0: Bám killer mượt (RenderStepped)
-- ═══════════════════════════════════════════════════════════════
local Rectangle = {
    folder = nil,
    invisibleTrackers = {},
    visibleFlashes = {},
    invisibleLoop = nil,
    flashLoop = nil,
}

local RECT_EDGE_COLOR     = Color3.fromRGB(175, 150, 220)
local RECT_EDGE_COLOR_HIT = Color3.fromRGB(120, 255, 120)

local RECT_EDGE_THICK = 0.1
local RECT_INVIS_DURATION = 0.5
local RECT_FLASH_HIT_DURATION = 0.4

local function EnsureRectangleFolder()
    if not Rectangle.folder or not Rectangle.folder.Parent then
        local f = Instance.new("Folder"); f.Name = "RectangleBoxVisuals"; f.Parent = Workspace; Rectangle.folder = f
    end
end

local function CalcRectCenterCF(kr)
    local pos = kr.Position
    local look = kr.CFrame.LookVector
    local flat = Vector3.new(look.X, 0, look.Z)
    if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
    flat = flat.Unit
    local dist = Settings.RectangleDistance or 3
    return CFrame.lookAt(pos + flat * dist, pos + flat * dist + flat)
end

local function GetRectSize()
    local baseW, baseH, baseL = 4, 4, 6
    local m = Settings.RectangleMultiplier or 1
    return Vector3.new(baseW * m, baseH * m, baseL * m)
end

local function IsPlayerInRect(myPos, centerCF, size)
    local halfW = size.X / 2 + PLAYER_RADIUS
    local halfL = size.Z / 2 + PLAYER_RADIUS
    local halfH = size.Y / 2 + PLAYER_RADIUS
    local lp = centerCF:PointToObjectSpace(myPos)
    return math.abs(lp.X) <= halfW and math.abs(lp.Z) <= halfL and math.abs(lp.Y) <= halfH
end

-- Build edges từ centerCF + size truyền vào
local function BuildFlashEdges(flash, centerCF, size)
    if not flash or not flash.model or not flash.model.Parent then return end
    if not centerCF or not size then return end

    local L, W, H = size.Z, size.X, size.Y
    local corners = {
        Vector3.new(-W/2,-H/2,-L/2), Vector3.new(W/2,-H/2,-L/2),
        Vector3.new(W/2,-H/2,L/2), Vector3.new(-W/2,-H/2,L/2),
        Vector3.new(-W/2,H/2,-L/2), Vector3.new(W/2,H/2,-L/2),
        Vector3.new(W/2,H/2,L/2), Vector3.new(-W/2,H/2,L/2),
    }
    local edgePairs = {
        {1,2},{2,3},{3,4},{4,1},
        {5,6},{6,7},{7,8},{8,5},
        {1,5},{2,6},{3,7},{4,8},
    }
    for i, pair in ipairs(edgePairs) do
        local edge = flash.edges[i]
        if edge and edge.Parent then
            local p1 = centerCF:PointToWorldSpace(corners[pair[1]])
            local p2 = centerCF:PointToWorldSpace(corners[pair[2]])
            local mid = (p1 + p2) / 2
            local diff = p2 - p1
            local len = diff.Magnitude
            if len > 0.01 then
                local dir = diff.Unit
                local up = Vector3.new(0, 1, 0)
                if math.abs(dir.Y) > 0.95 then up = Vector3.new(0, 0, 1) end
                local right = dir:Cross(up)
                if right.Magnitude < 0.01 then right = Vector3.new(1, 0, 0) end
                right = right.Unit
                local upFinal = right:Cross(dir).Unit
                edge.Size = Vector3.new(RECT_EDGE_THICK, RECT_EDGE_THICK, len)
                edge.CFrame = CFrame.fromMatrix(mid, right, upFinal, dir)
            end
        end
    end
end

-- ✅ Loop visible: RenderStepped + bám killer mượt
local function EnsureFlashLoop()
    if Rectangle.flashLoop then return end
    Rectangle.flashLoop = RunService.RenderStepped:Connect(function()
        if #Rectangle.visibleFlashes == 0 then return end
        local now = tick()
        for i = #Rectangle.visibleFlashes, 1, -1 do
            local flash = Rectangle.visibleFlashes[i]
            if not flash then
                table.remove(Rectangle.visibleFlashes, i)
            elseif now - flash.startTime > flash.duration then
                if flash.model and flash.model.Parent then pcall(function() flash.model:Destroy() end) end
                table.remove(Rectangle.visibleFlashes, i)
            elseif not flash.killer or not flash.killer.Parent then
                if flash.model and flash.model.Parent then pcall(function() flash.model:Destroy() end) end
                table.remove(Rectangle.visibleFlashes, i)
            else
                -- ✅ Bám killer mỗi frame
                local kr = flash.killer:FindFirstChild("HumanoidRootPart")
                if kr then
                    local centerCF = CalcRectCenterCF(kr)
                    local size = GetRectSize()
                    BuildFlashEdges(flash, centerCF, size)
                end
            end
        end
    end)
end

-- Loop invisible: check player vào vùng (bám killer tự nhiên qua tính center mỗi frame)
local function EnsureInvisibleLoop()
    if Rectangle.invisibleLoop then return end
    Rectangle.invisibleLoop = RunService.Heartbeat:Connect(function()
        if #Rectangle.invisibleTrackers == 0 then return end
        local now = tick()
        for i = #Rectangle.invisibleTrackers, 1, -1 do
            local tracker = Rectangle.invisibleTrackers[i]
            if not tracker then
                table.remove(Rectangle.invisibleTrackers, i)
            elseif now - tracker.startTime > tracker.duration then
                table.remove(Rectangle.invisibleTrackers, i)
            elseif tracker.blocked then
                table.remove(Rectangle.invisibleTrackers, i)
            elseif not tracker.killer or not tracker.killer.Parent then
                table.remove(Rectangle.invisibleTrackers, i)
            else
                local kr = tracker.killer:FindFirstChild("HumanoidRootPart")
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if kr and myRoot then
                    local centerCF = CalcRectCenterCF(kr)
                    local size = GetRectSize()
                    if IsPlayerInRect(myRoot.Position, centerCF, size) then
                        tracker.blocked = true
                        FireAbilityByMode()
                    end
                end
            end
        end
    end)
end

-- Spawn visible flash — giờ chỉ lưu killer, edges sẽ update mỗi frame
local function SpawnVisibleFlash(killer, isSuccess)
    if not killer or not killer.Parent then return end
    local kr = killer:FindFirstChild("HumanoidRootPart")
    if not kr then return end
    EnsureRectangleFolder()

    -- Xóa hộp visible cũ NGAY
    for _, oldFlash in ipairs(Rectangle.visibleFlashes) do
        if oldFlash.model and oldFlash.model.Parent then
            pcall(function() oldFlash.model:Destroy() end)
        end
    end
    Rectangle.visibleFlashes = {}

    local color = isSuccess and RECT_EDGE_COLOR_HIT or RECT_EDGE_COLOR
    local duration = isSuccess and RECT_FLASH_HIT_DURATION or RECT_INVIS_DURATION
    local trans = Settings.RectangleEdgeTransparency or 0.2

    local model = Instance.new("Model")
    model.Name = isSuccess and "RectHitFlash" or "RectM1Flash"
    model.Parent = Rectangle.folder

    local edges = {}
    for i = 1, 12 do
        local e = Instance.new("Part")
        e.Name = "Edge"..i
        e.Anchored = true
        e.CanCollide = false
        e.CanQuery = false
        e.CanTouch = false
        e.CastShadow = false
        e.Material = Enum.Material.Neon
        e.Color = color
        e.Transparency = trans
        e.Size = Vector3.new(RECT_EDGE_THICK, RECT_EDGE_THICK, 1)
        e.CFrame = CFrame.new(0, -5000, 0)
        e.Parent = model
        edges[i] = e
    end

    local flash = {
        model = model,
        edges = edges,
        killer = killer,
        startTime = tick(),
        duration = duration,
    }
    -- Build lần đầu để có vị trí ngay
    BuildFlashEdges(flash, CalcRectCenterCF(kr), GetRectSize())
    table.insert(Rectangle.visibleFlashes, flash)
    EnsureFlashLoop()
end

local function TriggerRectangle(killer)
    if not Settings.AutoBlockRectangle then return end
    if not killer or not killer.Parent then return end
    local kr = killer:FindFirstChild("HumanoidRootPart")
    if not kr then return end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local centerCF = CalcRectCenterCF(kr)
    local size = GetRectSize()
    local inBox = IsPlayerInRect(myRoot.Position, centerCF, size)

    SpawnVisibleFlash(killer, false)

    if inBox then
        FireAbilityByMode()
    else
        table.insert(Rectangle.invisibleTrackers, {
            killer = killer,
            startTime = tick(),
            duration = RECT_INVIS_DURATION,
            blocked = false,
        })
        EnsureInvisibleLoop()
    end
end

OnBlockSuccess = function()
    if not AB.running then return end
    if Settings.AutoBlockRectangle then
        local _, km = GetNearestKiller()
        if km then SpawnVisibleFlash(km, true) end
    end
    if not Settings.AimPunch then return end
    if GetActiveMode() == "007n7" then return end
    local now = tick()
    if now - AB.punchDebounce < 0.2 then return end
    AB.punchDebounce = now
    task.spawn(function() AimPunch(); FireAbility("Punch") end)
end

-- ═══════════════════════════════════════════════════════════════
-- NORMALIZE
-- ═══════════════════════════════════════════════════════════════
local function NormalizeZoneForMode()
    local activeCount = (Settings.AutoBlock and 1 or 0) + (Settings.AutoBlockCustom and 1 or 0) + (Settings.AutoBlockRectangle and 1 or 0)
    if activeCount > 1 then
        if Settings.AutoBlock then
            Settings.AutoBlockCustom=false; Settings.AutoBlockRectangle=false
        elseif Settings.AutoBlockCustom then
            Settings.AutoBlockRectangle=false
        end
        for _, t in ipairs({Toggles.AutoBlockCustom, Toggles.AutoBlockRectangle}) do
            if t then _suppressToggleCallback=true; pcall(function() t:Set(false) end); _suppressToggleCallback=false end
        end
    end
    if Settings.AutoBlock or Settings.AutoBlockRectangle then
        if Settings.ShowDiamond then zoneStateMemory.diamond = true; Settings.ShowDiamond = false end
        if Settings.ShowCircle then zoneStateMemory.circle = true; Settings.ShowCircle = false end
        if Toggles.ShowDiamond then _suppressToggleCallback=true; pcall(function() Toggles.ShowDiamond:Set(false) end); _suppressToggleCallback=false end
        if Toggles.ShowCircle then _suppressToggleCallback=true; pcall(function() Toggles.ShowCircle:Set(false) end); _suppressToggleCallback=false end
    end
    UpdateCustomZoneVisibility()
end

local function RefreshFourthButton()
    if Settings.AutoBlockButton and not FourthBlock.running then
        StartFourthButton()
    elseif not Settings.AutoBlockButton and FourthBlock.running then
        StopFourthButton()
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ATTRIBUTE-BASED DETECTION (không sound)
-- ═══════════════════════════════════════════════════════════════
local function AttrHeartbeat()
    if not AB.running then return end
    if not (Settings.AutoBlock or Settings.AutoBlockCustom or Settings.AutoBlockRectangle) then return end
    if not AB.KillersFolder or not AB.LocalRoot or not AB.LocalRoot.Parent then return end
    for _, k in ipairs(AB.KillersFolder:GetChildren()) do
        if k:IsA("Model") then
            local kr = k:FindFirstChild("HumanoidRootPart")
            if kr then
                local alu = k:GetAttribute("AbilityLastUsed") or 0
                local au = k:GetAttribute("AbilitiesUsed") or 0
                local st = AB.attrStates[k]
                if st then
                    local inc = alu > st.lastAbility
                    if au > st.lastUsed then st.isBait = true end
                    if inc then
                        if st.isBait then st.isBait = false
                        else
                            if Settings.AutoBlockRectangle then
                                local now = tick()
                                if now - AB.attrDebounce >= 0.15 then AB.attrDebounce = now; TriggerRectangle(k) end
                            else
                                local shouldBlock = false
                                if Settings.AutoBlockCustom then
                                    if IsPlayerInCustomZone(k) then shouldBlock = true end
                                else
                                    local dir = AB.LocalRoot.Position - kr.Position
                                    local mag = dir.Magnitude
                                    if mag <= 15 and mag > 0 and kr.CFrame.LookVector:Dot(dir.Unit) >= 0.3 then shouldBlock = true end
                                end
                                if shouldBlock then
                                    local now = tick()
                                    if now - AB.attrDebounce >= 0.15 then
                                        AB.attrDebounce = now
                                        FireAbilityByMode()
                                    end
                                end
                            end
                        end
                    end
                    st.lastAbility = alu; st.lastUsed = au
                else
                    AB.attrStates[k] = {lastAbility=alu, lastUsed=au, isBait=false}
                end
            end
        end
    end
end

local function ab_applyState(state)
    if not state then return end
    local function forceShow()
        if Settings.ShowDiamond then zoneStateMemory.diamond = true; Settings.ShowDiamond = false
            if Toggles.ShowDiamond then _suppressToggleCallback=true; pcall(function() Toggles.ShowDiamond:Set(false) end); _suppressToggleCallback=false end
        end
        if Settings.ShowCircle then zoneStateMemory.circle = true; Settings.ShowCircle = false
            if Toggles.ShowCircle then _suppressToggleCallback=true; pcall(function() Toggles.ShowCircle:Set(false) end); _suppressToggleCallback=false end
        end
    end
    local function restoreShow()
        if zoneStateMemory.diamond then Settings.ShowDiamond = true
            if Toggles.ShowDiamond then _suppressToggleCallback=true; pcall(function() Toggles.ShowDiamond:Set(true) end); _suppressToggleCallback=false end
        end
        if zoneStateMemory.circle then Settings.ShowCircle = true
            if Toggles.ShowCircle then _suppressToggleCallback=true; pcall(function() Toggles.ShowCircle:Set(true) end); _suppressToggleCallback=false end
        end
        zoneStateMemory.diamond = false; zoneStateMemory.circle = false
    end

    if state.mode == "default" then
        Settings.AutoBlock = state.value
        if state.value then
            Settings.AutoBlockCustom=false; Settings.AutoBlockRectangle=false
            forceShow()
        end
    elseif state.mode == "custom" then
        Settings.AutoBlockCustom = state.value
        if state.value then
            Settings.AutoBlock=false; Settings.AutoBlockRectangle=false
            restoreShow()
        end
    elseif state.mode == "rectangle" then
        Settings.AutoBlockRectangle = state.value
        if state.value then
            Settings.AutoBlock=false; Settings.AutoBlockCustom=false
            forceShow()
        end
    end

    for key, t in pairs({AutoBlock=Toggles.AutoBlock, AutoBlockCustom=Toggles.AutoBlockCustom, AutoBlockRectangle=Toggles.AutoBlockRectangle}) do
        if t then _suppressToggleCallback=true; pcall(function() t:Set(Settings[key]) end); _suppressToggleCallback=false end
    end

    if Settings.AutoBlock or Settings.AutoBlockCustom or Settings.AutoBlockRectangle then
        if not AB.running then pcall(StartAutoBlock) end
    else
        if AB.running then pcall(StopAutoBlock) end
    end
    if FourthBlock.applyTint then pcall(FourthBlock.applyTint) end
    UpdateCustomZoneVisibility()
end

local function ab_scheduleApply()
    if abPendingTask then pcall(task.cancel, abPendingTask); abPendingTask = nil end
    abPendingTask = task.delay(abDebounce, function()
        abPendingTask = nil
        local t = abPendingState
        abPendingState = nil
        if t ~= nil then abLastToggle = tick(); ab_applyState(t) end
    end)
end
local function ab_requestState(value, mode)
    if value == nil then return end
    if not mode then
        if Settings.AutoBlockRectangle then mode = "rectangle"
        elseif Settings.AutoBlockCustom then mode = "custom"
        else mode = "default" end
    end
    abPendingState = { value=value, mode=mode }
    local now = tick()
    if abLastToggle > 0 and now - abLastToggle < abDebounce then ab_scheduleApply(); return end
    if abPendingTask then pcall(task.cancel, abPendingTask); abPendingTask = nil end
    abLastToggle = now
    local t = abPendingState; abPendingState = nil
    ab_applyState(t)
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO BLOCK BUTTON
-- ═══════════════════════════════════════════════════════════════
function StartFourthButton()
    if FourthBlock.running then return end
    FourthBlock.running = true
    FourthBlock.connections = {}
    do
        local m = PlayerGui:FindFirstChild("MainUI")
        if m then
            local c = m:FindFirstChild("AbilityContainer", true)
            if c then
                local old = c:FindFirstChild("FourthBlockAbility")
                if old then pcall(function() old:Destroy() end) end
            end
        end
    end
    if not FourthBlock.applyTint then
        FourthBlock.applyTint = function()
            local b = FourthBlock.instance
            if not b or not b.Parent then return end
            local col = (Settings.AutoBlock or Settings.AutoBlockCustom or Settings.AutoBlockRectangle) and Color3.fromRGB(0,255,60) or Color3.fromRGB(255,0,0)
            if b:IsA("ImageButton") or b:IsA("ImageLabel") then b.ImageColor3 = col end
            for _, d in ipairs(b:GetDescendants()) do
                if d:IsA("ImageLabel") or d:IsA("ImageButton") then d.ImageColor3 = col
                elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then d.BackgroundColor3 = col end
            end
        end
    end
    local toggleLastTick = 0
    local TOGGLE_COOLDOWN = 0.15
    local function Toggle()
        local now = tick()
        if now - toggleLastTick < TOGGLE_COOLDOWN then return end
        toggleLastTick = now
        local target = Settings.FourthButtonTarget or "default"
        local current = false
        if target == "default" then current = Settings.AutoBlock
        elseif target == "custom" then current = Settings.AutoBlockCustom
        elseif target == "rectangle" then current = Settings.AutoBlockRectangle end
        ab_requestState(not current, target)
    end
    table.insert(FourthBlock.connections, RunService.RenderStepped:Connect(function()
        if not FourthBlock.running then return end
        local b = FourthBlock.instance
        if b and b.Parent then
            local ok, p = pcall(function() return b.AbsolutePosition end)
            local ok2, s = pcall(function() return b.AbsoluteSize end)
            if ok and ok2 then FourthBlock.cachedPos = p; FourthBlock.cachedSize = s end
        else
            FourthBlock.cachedPos = nil; FourthBlock.cachedSize = nil
        end
    end))
    local function IsActuallyOnButton(pos)
        local btn = FourthBlock.instance
        if not btn or not btn.Parent then return false end
        local ok, objs = pcall(function() return UserInputService:GetGuiObjectsAtPosition(pos.X, pos.Y) end)
        if ok and objs and #objs > 0 then
            local top = objs[1]
            return top == btn or top:IsDescendantOf(btn)
        end
        if not FourthBlock.cachedPos or not FourthBlock.cachedSize then return false end
        local p, s = FourthBlock.cachedPos, FourthBlock.cachedSize
        return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
    end
    local downPos, downTime = nil, 0
    table.insert(FourthBlock.connections, UserInputService.InputBegan:Connect(function(input)
        if not FourthBlock.running then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not IsActuallyOnButton(input.Position) then return end
        downPos = input.Position; downTime = tick()
    end))
    table.insert(FourthBlock.connections, UserInputService.InputEnded:Connect(function(input)
        if not FourthBlock.running then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not downPos then return end
        local held = tick() - downTime
        downPos = nil
        if held > 0.5 then return end
        if not IsActuallyOnButton(input.Position) then return end
        Toggle()
    end))
    local function BindAll(root)
        if not root then return end
        local function tb(obj)
            if not obj then return end
            if obj:IsA("GuiButton") then
                pcall(function() obj.Active=true; obj.Selectable=true end)
                pcall(function() obj.MouseButton1Click:Connect(Toggle) end)
                pcall(function() obj.Activated:Connect(Toggle) end)
            end
        end
        tb(root)
        for _, d in ipairs(root:GetDescendants()) do if d:IsA("GuiObject") then tb(d) end end
    end
    task.spawn(function()
        while FourthBlock.running do
            task.wait(0.5)
            if not FourthBlock.running then break end
            local m = PlayerGui:FindFirstChild("MainUI")
            if m then
                local c = m:FindFirstChild("AbilityContainer", true)
                if c then
                    local blockBtn = c:FindFirstChild("Block")
                    local cloneBtn = c:FindFirstChild("Clone")
                    local target = Settings.FourthButtonTarget or "default"
                    local activeMode = Settings.ABMode
                    if target == "custom" then activeMode = Settings.CustomABMode
                    elseif target == "rectangle" then activeMode = Settings.RectangleABMode end
                    
                    local orig = nil
                    if blockBtn and cloneBtn then orig = (activeMode == "007n7") and cloneBtn or blockBtn
                    else orig = blockBtn or cloneBtn end
                    local e = c:FindFirstChild("FourthBlockAbility")
                    local needsRecreate = false
                    if not e then needsRecreate = (orig ~= nil)
                    elseif not orig then needsRecreate = false
                    elseif FourthBlock.sourceName ~= orig.Name then needsRecreate = true
                    elseif FourthBlock.instance ~= e then
                        FourthBlock.instance = e; BindAll(e)
                        if FourthBlock.applyTint then FourthBlock.applyTint() end
                    end
                    if needsRecreate and orig then
                        if e then pcall(function() e:Destroy() end) end
                        local clone = orig:Clone()
                        clone.Name = "FourthBlockAbility"; clone.LayoutOrder = 4
                        if clone:IsA("GuiObject") then clone.ZIndex = 50 end
                        for _, d in ipairs(clone:GetDescendants()) do
                            if d:IsA("TextLabel") or d:IsA("TextButton") then
                                local t = d.Text:lower()
                                if t:find("block") or t:find("clone") then d.Text=""; d.Visible=false end
                            end
                            if d:IsA("GuiObject") then d.ZIndex = math.max(d.ZIndex, 50); d.Active = true end
                        end
                        clone.Parent = c
                        FourthBlock.instance = clone; FourthBlock.sourceName = orig.Name
                        BindAll(clone)
                        if FourthBlock.applyTint then FourthBlock.applyTint() end
                    end
                end
            end
        end
    end)
end
function StopFourthButton()
    if not FourthBlock.running then return end
    FourthBlock.running = false
    for _, c in ipairs(FourthBlock.connections) do pcall(function() c:Disconnect() end) end
    FourthBlock.connections = {}
    if FourthBlock.instance and FourthBlock.instance.Parent then pcall(function() FourthBlock.instance:Destroy() end) end
    FourthBlock.instance = nil
    FourthBlock.cachedPos = nil; FourthBlock.cachedSize = nil; FourthBlock.sourceName = nil
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO BLOCK: START / STOP — chỉ dùng Attribute
-- ═══════════════════════════════════════════════════════════════
function StartAutoBlock()
    if AB.running then return end
    AB.running = true
    AB.generation = AB.generation + 1
    local myGen = AB.generation
    AB.attrStates = {}
    local char = LocalPlayer.Character
    if char then
        AB.LocalRoot = char:FindFirstChild("HumanoidRootPart")
        MonitorBlockSuccess(char)
    end
    table.insert(AB.connections, LocalPlayer.CharacterAdded:Connect(function(c)
        AB.LocalRoot = c:WaitForChild("HumanoidRootPart", 5)
        MonitorBlockSuccess(c)
    end))
    local function attachFolder(folder)
        if not folder then return false end
        AB.KillersFolder = folder
        return true
    end
    local p = Workspace:FindFirstChild("Players")
    local k = p and p:FindFirstChild("Killers")
    if not attachFolder(k) then
        task.spawn(function()
            local t = 0
            while AB.running and AB.generation == myGen and t < 60 do
                t = t + 1; task.wait(1)
                local pp = Workspace:FindFirstChild("Players")
                local kk = pp and pp:FindFirstChild("Killers")
                if kk and attachFolder(kk) then break end
            end
        end)
    end
    table.insert(AB.connections, RunService.Heartbeat:Connect(function()
        if not AB.running or AB.generation ~= myGen then return end
        AttrHeartbeat()
    end))
    if FourthBlock.applyTint then FourthBlock.applyTint() end
end

function StopAutoBlock()
    AB.running = false
    AB.generation = AB.generation + 1
    AB.attrStates = {}
    for _, c in ipairs(AB.connections) do pcall(function() c:Disconnect() end) end
    AB.connections = {}
    if Rectangle.invisibleLoop then pcall(function() Rectangle.invisibleLoop:Disconnect() end); Rectangle.invisibleLoop = nil end
    if Rectangle.flashLoop then pcall(function() Rectangle.flashLoop:Disconnect() end); Rectangle.flashLoop = nil end
    Rectangle.invisibleTrackers = {}
    for _, flash in ipairs(Rectangle.visibleFlashes) do
        if flash.model and flash.model.Parent then pcall(function() flash.model:Destroy() end) end
    end
    Rectangle.visibleFlashes = {}
    if Rectangle.folder and Rectangle.folder.Parent then pcall(function() Rectangle.folder:Destroy() end); Rectangle.folder = nil end
end

-- ═══════════════════════════════════════════════════════════════
-- FOV / LG / Zoom / FPS / NC
-- ═══════════════════════════════════════════════════════════════
local MIN_FOV, MAX_FOV = 30, 120
local fovDebounce = 0
local fovBindName = "TestHub_FOVForce"
local function ApplyFOV()
    local cam = Workspace.CurrentCamera
    if cam and cam.FieldOfView ~= Settings.FOVValue then pcall(function() cam.FieldOfView = Settings.FOVValue end) end
end
pcall(function() RunService:UnbindFromRenderStep(fovBindName) end)
pcall(function()
    RunService:BindToRenderStep(fovBindName, Enum.RenderPriority.Last.Value + 1, function()
        local cam = Workspace.CurrentCamera
        if cam and cam.FieldOfView ~= Settings.FOVValue then pcall(function() cam.FieldOfView = Settings.FOVValue end) end
    end)
end)
local fovWatchConn = nil
local function WatchCameraFOV(cam)
    if fovWatchConn then pcall(function() fovWatchConn:Disconnect() end); fovWatchConn = nil end
    if not cam then return end
    fovWatchConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        if cam.FieldOfView ~= Settings.FOVValue then pcall(function() cam.FieldOfView = Settings.FOVValue end) end
    end)
end
WatchCameraFOV(Workspace.CurrentCamera)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() WatchCameraFOV(Workspace.CurrentCamera) end)
RunService.Stepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if cam and cam.FieldOfView ~= Settings.FOVValue then pcall(function() cam.FieldOfView = Settings.FOVValue end) end
end)
RunService.Heartbeat:Connect(function()
    local cam = Workspace.CurrentCamera
    if cam and cam.FieldOfView ~= Settings.FOVValue then pcall(function() cam.FieldOfView = Settings.FOVValue end) end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1); ApplyFOV(); task.wait(0.4); ApplyFOV(); task.wait(0.6); ApplyFOV()
end)
local function QueueFOV() fovDebounce = tick(); task.delay(0.1, function() if tick() - fovDebounce >= 0.05 then ApplyFOV() end end) end

local LG = { enabled=false, saved={}, destroyed={}, lightSaved={}, terrainSaved={}, conn=nil }
local function lgSaveProp(o, p)
    if not LG.saved[o] then LG.saved[o] = {} end
    if LG.saved[o][p] == nil then local ok, v = pcall(function() return o[p] end); if ok then LG.saved[o][p] = v end end
end
local function lgSaveDestroy(o)
    if LG.destroyed[o] then return end
    local parent = o.Parent; if not parent then return end
    local ok, c = pcall(function() return o:Clone() end)
    if ok and c then LG.destroyed[o] = {Clone=c, Parent=parent} end
end
local function lgOpt(v)
    if not LG.enabled then return end
    if v:IsA("BasePart") then
        for _, p in ipairs({"CastShadow","Material","Reflectance","BackSurface","BottomSurface","FrontSurface","LeftSurface","RightSurface","TopSurface"}) do lgSaveProp(v, p) end
        v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        v.BackSurface=Enum.SurfaceType.SmoothNoOutlines; v.BottomSurface=Enum.SurfaceType.SmoothNoOutlines
        v.FrontSurface=Enum.SurfaceType.SmoothNoOutlines; v.LeftSurface=Enum.SurfaceType.SmoothNoOutlines
        v.RightSurface=Enum.SurfaceType.SmoothNoOutlines; v.TopSurface=Enum.SurfaceType.SmoothNoOutlines
    elseif v:IsA("Decal") then
        lgSaveProp(v, "Transparency"); lgSaveProp(v, "Texture"); v.Transparency=1; v.Texture=""
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        lgSaveProp(v, "Lifetime"); v.Lifetime=NumberRange.new(0)
    elseif v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
        lgSaveDestroy(v); v:Destroy()
    end
end
local function EnableLG()
    if LG.enabled then return end
    LG.enabled = true
    local T = Workspace:FindFirstChildWhichIsA("Terrain")
    if T then
        LG.terrainSaved = {WaterWaveSize=T.WaterWaveSize, WaterWaveSpeed=T.WaterWaveSpeed, WaterReflectance=T.WaterReflectance, WaterTransparency=T.WaterTransparency}
        T.WaterWaveSize=0; T.WaterWaveSpeed=0; T.WaterReflectance=0; T.WaterTransparency=1
    end
    LG.lightSaved = {GlobalShadows=Lighting.GlobalShadows, FogEnd=Lighting.FogEnd, FogStart=Lighting.FogStart}
    Lighting.GlobalShadows=false; Lighting.FogEnd=9e9; Lighting.FogStart=9e9
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    for _, v in pairs(Workspace:GetDescendants()) do pcall(lgOpt, v) end
    for _, v in pairs(Lighting:GetDescendants()) do if v:IsA("PostEffect") then lgSaveProp(v,"Enabled"); v.Enabled=false end end
    LG.conn = Workspace.DescendantAdded:Connect(function(v) if not LG.enabled then return end; task.defer(function() pcall(lgOpt, v) end) end)
end
local function DisableLG()
    if not LG.enabled then return end
    LG.enabled = false
    if LG.conn then LG.conn:Disconnect(); LG.conn = nil end
    for o, props in pairs(LG.saved) do if o and o.Parent then for p, v in pairs(props) do pcall(function() o[p] = v end) end end end
    for _, d in pairs(LG.destroyed) do if d.Clone and d.Parent and d.Parent.Parent then pcall(function() d.Clone.Parent = d.Parent end) end end
    local T = Workspace:FindFirstChildWhichIsA("Terrain")
    if T then for k, v in pairs(LG.terrainSaved) do pcall(function() T[k] = v end) end end
    for k, v in pairs(LG.lightSaved) do pcall(function() Lighting[k] = v end) end
    table.clear(LG.saved); table.clear(LG.destroyed); table.clear(LG.terrainSaved); table.clear(LG.lightSaved)
end
local function EnableMaxZoom() LocalPlayer.CameraMaxZoomDistance = 10000 end
local function DisableMaxZoom() LocalPlayer.CameraMaxZoomDistance = 5 end
LocalPlayer.CameraMinZoomDistance = 0.5
LocalPlayer.CameraMaxZoomDistance = 5

local FPS = { enabled=false, gui=nil, label=nil, conn=nil, frames=0, elapsed=0 }
local function EnableFPS()
    if FPS.enabled then return end
    FPS.enabled = true
    if not FPS.gui then
        local g = Instance.new("ScreenGui"); g.Name="FPSPingMonitor"; g.ResetOnSpawn=false; g.IgnoreGuiInset=true; g.DisplayOrder=999998; g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; g.Parent=CoreGui; FPS.gui=g
        local f = Instance.new("Frame"); f.AnchorPoint=Vector2.new(1,0); f.Position=UDim2.new(1,-2,0,-1); f.Size=UDim2.new(0,112,0,22); f.BackgroundColor3=Color3.fromRGB(15,30,20); f.BackgroundTransparency=0.15; f.BorderSizePixel=0; f.Parent=g
        local c = Instance.new("UICorner"); c.CornerRadius=UDim.new(0,4); c.Parent=f
        local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-4,1,0); lbl.Position=UDim2.new(0,2,0,0); lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=11; lbl.TextColor3=Color3.fromRGB(80,255,130); lbl.Text="FPS: -- | PING: -- ms"; lbl.Parent=f; FPS.label=lbl
    end
    FPS.gui.Enabled=true; FPS.frames=0; FPS.elapsed=0
    FPS.conn = RunService.RenderStepped:Connect(function(dt)
        if not FPS.enabled then return end
        FPS.frames = FPS.frames + 1; FPS.elapsed = FPS.elapsed + dt
        if FPS.elapsed >= 1 then
            local fps = math.floor(FPS.frames / FPS.elapsed + 0.5)
            FPS.frames, FPS.elapsed = 0, 0
            local ping = "--"
            pcall(function()
                local ns = Stats.Network
                local dp = ns and ns.ServerStatsItem and ns.ServerStatsItem["Data Ping"]
                if dp then ping = math.floor(dp:GetValue() + 0.5) end
            end)
            if FPS.label then FPS.label.Text = "FPS: "..fps.." | PING: "..ping.." ms" end
        end
    end)
end
local function DisableFPS()
    FPS.enabled = false
    if FPS.conn then FPS.conn:Disconnect(); FPS.conn = nil end
    if FPS.gui then FPS.gui.Enabled = false end
end

local NC = { enabled=false, applied=false, orig=nil, mod=nil }
local function GetPopper()
    local ps = LocalPlayer:FindFirstChild("PlayerScripts"); if not ps then return nil end
    local pm = ps:FindFirstChild("PlayerModule"); if not pm then return nil end
    local cm = pm:FindFirstChild("CameraModule"); if not cm then return nil end
    local zc = cm:FindFirstChild("ZoomController"); if not zc then return nil end
    return zc:FindFirstChild("Popper")
end
local function ApplyNC()
    if NC.applied then return true end
    NC.mod = GetPopper(); if not NC.mod then return false end
    local setC, getC = debug and debug.setconstant, debug and debug.getconstants
    if not (setC and getC and getgc) then return false end
    NC.orig = {}
    for _, fn in pairs(getgc()) do
        if type(fn) == "function" then
            local ok, env = pcall(function() return getfenv(fn) end)
            if ok and env and env.script == NC.mod then
                local ok2, consts = pcall(getC, fn)
                if ok2 and consts then
                    for i, c in pairs(consts) do
                        if tonumber(c) == 0.25 then NC.orig[fn]=NC.orig[fn] or {}; NC.orig[fn][i]=c; pcall(setC, fn, i, 0)
                        elseif tonumber(c) == 0 then NC.orig[fn]=NC.orig[fn] or {}; NC.orig[fn][i]=c; pcall(setC, fn, i, 0.25) end
                    end
                end
            end
        end
    end
    NC.applied = true; return true
end
local function RestoreNC()
    if not NC.orig or not NC.mod then NC.applied = false; return end
    local setC = debug and debug.setconstant
    if setC then for fn, t in pairs(NC.orig) do for i, v in pairs(t) do pcall(setC, fn, i, v) end end end
    NC.orig = nil; NC.applied = false
end
local function EnableNC() NC.enabled = true; task.spawn(function() local t=0; while not NC.applied and t<20 do t=t+1; if ApplyNC() then break end; task.wait(0.5) end end) end
local function DisableNC() NC.enabled = false; RestoreNC() end

-- ═══════════════════════════════════════════════════════════════
-- UI BUILD
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title="shitsaken", Icon="monitor", Author="saken", Folder="TestHub",
    Size=UDim2.fromOffset(600, 500), Transparent=true, Theme="Dark",
    User={ Enabled=true, Anonymous=true },
})
Window:EditOpenButton({
    Title="shitsaken", Icon="monitor", CornerRadius=UDim.new(0,16), StrokeThickness=2,
    Color=ColorSequence.new(Color3.fromRGB(255,60,60), Color3.fromRGB(255,150,150)),
    OnlyMobile=false, Enabled=true, Draggable=true,
})

local function RestoreInputs()
    local map = {
        {Inputs.CustomDiamondLength, Settings.CustomDiamondLength},
        {Inputs.CustomDiamondWidth, Settings.CustomDiamondWidth},
        {Inputs.CustomDiamondOffset, Settings.CustomDiamondOffset},
        {Inputs.CustomCircleRadius, Settings.CustomCircleRadius},
        {Inputs.ZoneHeight, Settings.ZoneHeight},
        {Inputs.RectangleDistance, Settings.RectangleDistance},
        {Inputs.RectangleMultiplier, Settings.RectangleMultiplier},
        {Inputs.RectangleEdgeTransparency, Settings.RectangleEdgeTransparency},
    }
    for _, pair in ipairs(map) do
        if pair[1] then pcall(function() pair[1]:Set(tostring(pair[2])) end) end
    end
end

-- Main tab
local TabMain = Window:Tab({ Title="Main", Icon="house" })
TabMain:Section({ Title="Credits" })
TabMain:Paragraph({ Title="Made by", Desc="You + DeepSeek + ChatGPT + Gemini + Google" })

-- ESP
local TabESP = Window:Tab({ Title="ESP", Icon="eye" })
TabESP:Section({ Title="ESP" })
Toggles.MinionESP = TabESP:Toggle({ Title="Minion ESP", Value=Settings.MinionESP,
    Callback=function(v) Settings.MinionESP=v; if v then StartMinionESP() else StopMinionESP() end end })
Toggles.ProjectileESP = TabESP:Toggle({ Title="Projectile ESP", Value=Settings.ProjectileESP,
    Callback=function(v) Settings.ProjectileESP=v; if v then StartProjectileESP() else StopProjectileESP() end end })
Toggles.AzureTrapESP = TabESP:Toggle({ Title="Azure Trap ESP", Value=Settings.AzureTrapESP,
    Callback=function(v) Settings.AzureTrapESP=v; if v then StartAzureTrapESP() else StopAzureTrapESP() end end })

-- Auto Block tab
local TabAB = Window:Tab({ Title="Auto Block", Icon="shield" })

-- ===== AUTO BLOCK BUTTON =====
TabAB:Section({ Title="Auto Block Button" })
Toggles.AutoBlockButton = TabAB:Toggle({ Title="Auto Block Button", Value=Settings.AutoBlockButton,
    Callback=function(v) Settings.AutoBlockButton=v; RefreshFourthButton() end })
Toggles.FourthButtonTargetDropdown = TabAB:Dropdown({
    Title = "4th Button Target",
    Values = { "Default", "Custom", "Rectangle" },
    Value = (Settings.FourthButtonTarget == "custom") and "Custom" or (Settings.FourthButtonTarget == "rectangle") and "Rectangle" or "Default",
    Callback = function(v) 
        Settings.FourthButtonTarget = string.lower(v)
    end,
})

-- ===== DEFAULT =====
TabAB:Section({ Title="Auto Block (Default)" })
Toggles.AutoBlock = TabAB:Toggle({ Title="Auto Block", Value=Settings.AutoBlock,
    Callback=function(v) if _suppressToggleCallback then return end; ab_requestState(v, "default") end })
Toggles.ABModeDropdown = TabAB:Dropdown({ Title="Auto Block Mode",
    Values={"Guest 1337","007n7"}, Value=(Settings.ABMode=="007n7") and "007n7" or "Guest 1337",
    Callback=function(v) Settings.ABMode=(v=="007n7") and "007n7" or "Guest1337" end })
Toggles.AimPunch = TabAB:Toggle({ Title="Auto Aim + Punch", Value=Settings.AimPunch,
    Callback=function(v) Settings.AimPunch=v end })

-- ===== CUSTOM =====
TabAB:Section({ Title="Auto Block Custom" })
Toggles.AutoBlockCustom = TabAB:Toggle({ Title="Auto Block Custom", Value=Settings.AutoBlockCustom,
    Callback=function(v) if _suppressToggleCallback then return end; ab_requestState(v, "custom") end })
Toggles.CustomABModeDropdown = TabAB:Dropdown({ Title="Custom Auto Block Mode",
    Values={"Guest 1337","007n7"}, Value=(Settings.CustomABMode=="007n7") and "007n7" or "Guest 1337",
    Callback=function(v) Settings.CustomABMode=(v=="007n7") and "007n7" or "Guest1337" end })
Toggles.ShowDiamond = TabAB:Toggle({ Title="Show Diamond Zone", Value=Settings.ShowDiamond,
    Callback=function(v)
        if _suppressToggleCallback then Settings.ShowDiamond=v; UpdateCustomZoneVisibility(); return end
        if Settings.AutoBlock or Settings.AutoBlockRectangle then
            _suppressToggleCallback=true; pcall(function() Toggles.ShowDiamond:Set(false) end); _suppressToggleCallback=false
            Settings.ShowDiamond=false; UpdateCustomZoneVisibility(); return
        end
        Settings.ShowDiamond=v; UpdateCustomZoneVisibility()
    end })
Inputs.CustomDiamondLength = TabAB:Input({ Title="Diamond Length", Value=tostring(Settings.CustomDiamondLength), Placeholder="8",
    Callback=function(v) Settings.CustomDiamondLength=math.max(1, tonumber(v) or 8) end })
Inputs.CustomDiamondWidth = TabAB:Input({ Title="Diamond Width", Value=tostring(Settings.CustomDiamondWidth), Placeholder="4",
    Callback=function(v) Settings.CustomDiamondWidth=math.max(1, tonumber(v) or 4) end })
Inputs.CustomDiamondOffset = TabAB:Input({ Title="Diamond Face Offset", Value=tostring(Settings.CustomDiamondOffset), Placeholder="3",
    Callback=function(v) Settings.CustomDiamondOffset=math.max(0, tonumber(v) or 3) end })
Toggles.ShowCircle = TabAB:Toggle({ Title="Show Circle Zone", Value=Settings.ShowCircle,
    Callback=function(v)
        if _suppressToggleCallback then Settings.ShowCircle=v; UpdateCustomZoneVisibility(); return end
        if Settings.AutoBlock or Settings.AutoBlockRectangle then
            _suppressToggleCallback=true; pcall(function() Toggles.ShowCircle:Set(false) end); _suppressToggleCallback=false
            Settings.ShowCircle=false; UpdateCustomZoneVisibility(); return
        end
        Settings.ShowCircle=v; UpdateCustomZoneVisibility()
    end })
Inputs.CustomCircleRadius = TabAB:Input({ Title="Circle Radius", Value=tostring(Settings.CustomCircleRadius), Placeholder="5",
    Callback=function(v) Settings.CustomCircleRadius=math.max(1, tonumber(v) or 5) end })
Inputs.ZoneHeight = TabAB:Input({ Title="Zone Height", Value=tostring(Settings.ZoneHeight), Placeholder="0.5",
    Callback=function(v) Settings.ZoneHeight=tonumber(v) or 0.5 end })

-- ===== RECTANGLE =====
TabAB:Section({ Title="Auto Block Rectangle" })
Toggles.AutoBlockRectangle = TabAB:Toggle({ Title="Auto Block Rectangle", Value=Settings.AutoBlockRectangle,
    Callback=function(v) if _suppressToggleCallback then return end; ab_requestState(v, "rectangle") end })
Toggles.RectangleModeDropdown = TabAB:Dropdown({ Title="Rectangle Block Mode",
    Values={"Guest 1337","007n7"}, Value=(Settings.RectangleABMode=="007n7") and "007n7" or "Guest 1337",
    Callback=function(v) Settings.RectangleABMode=(v=="007n7") and "007n7" or "Guest1337" end })
Inputs.RectangleDistance = TabAB:Input({ Title="Hitbox Distance", Value=tostring(Settings.RectangleDistance), Placeholder="3",
    Callback=function(v) Settings.RectangleDistance=math.max(0, tonumber(v) or 3) end })
Inputs.RectangleMultiplier = TabAB:Input({ Title="Hitbox Multiplier", Value=tostring(Settings.RectangleMultiplier), Placeholder="1",
    Callback=function(v) Settings.RectangleMultiplier=math.max(0.1, tonumber(v) or 1) end })
Inputs.RectangleEdgeTransparency = TabAB:Input({ Title="Edge Transparency", Value=tostring(Settings.RectangleEdgeTransparency), Placeholder="0.2",
    Callback=function(v) Settings.RectangleEdgeTransparency=math.clamp(tonumber(v) or 0.2, 0, 1) end })

-- FOV tab
local TabFOV = Window:Tab({ Title="FOV", Icon="camera" })
TabFOV:Section({ Title="Field of View" })
Sliders.FOV = TabFOV:Slider({ Title="FOV", Value={ Min=MIN_FOV, Max=MAX_FOV, Default=Settings.FOVValue },
    Callback=function(v)
        local val = math.clamp(math.floor(v), MIN_FOV, MAX_FOV)
        if val == Settings.FOVValue then return end
        Settings.FOVValue = val; QueueFOV()
    end })
TabFOV:Button({ Title="Reapply FOV", Callback=function() ApplyFOV() end })

-- Get ID tab
local TabGetID = Window:Tab({ Title="Get ID", Icon="user" })
TabGetID:Section({ Title="Player Info" })
PlayerDropdown = TabGetID:Dropdown({ Title="Select player",
    Values=(function() local t={}; for _, p in ipairs(Players:GetPlayers()) do table.insert(t, p.Name) end; return t end)(),
    Callback=function(v) end })
TabGetID:Button({ Title="Copy Profile Link", Callback=function()
    if not PlayerDropdown then return end
    local sel = PlayerDropdown.Value; if not sel then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == sel and setclipboard then setclipboard("https://www.roblox.com/users/"..p.UserId.."/profile") end
    end
end })
TabGetID:Button({ Title="Refresh List", Callback=function()
    if not PlayerDropdown then return end
    local names = {}; for _, p in ipairs(Players:GetPlayers()) do table.insert(names, p.Name) end
    pcall(function() PlayerDropdown:Refresh(names) end)
end })

-- Misc tab
local TabMisc = Window:Tab({ Title="Misc", Icon="settings" })
TabMisc:Section({ Title="Effects" })
Toggles.AntiBlindness = TabMisc:Toggle({ Title="Anti Blindness", Value=Settings.AntiBlindness,
    Callback=function(v) Settings.AntiBlindness=v; if v then StartAntiBlindness() else StopAntiBlindness() end end })
Toggles.AntiGlitch = TabMisc:Toggle({ Title="Anti Glitch", Value=Settings.AntiGlitch,
    Callback=function(v) Settings.AntiGlitch=v; if v then StartAntiGlitch() else StopAntiGlitch() end end })
Toggles.AntiSubspaced = TabMisc:Toggle({ Title="Anti Subspaced", Value=Settings.AntiSubspaced,
    Callback=function(v) Settings.AntiSubspaced=v; if v then StartAntiSubspaced() else StopAntiSubspaced() end end })
Toggles.AntiNoliLaugh = TabMisc:Toggle({ Title="Anti Noli Laugh", Value=Settings.AntiNoliLaugh,
    Callback=function(v) Settings.AntiNoliLaugh=v; if v then StartAntiNoliLaugh() else StopAntiNoliLaugh() end end })
TabMisc:Section({ Title="Graphics" })
Toggles.LowGraphics = TabMisc:Toggle({ Title="Low Graphics", Value=Settings.LowGraphics,
    Callback=function(v) Settings.LowGraphics=v; if v then EnableLG() else DisableLG() end end })
Toggles.FPSPing = TabMisc:Toggle({ Title="FPS + Ping", Value=Settings.FPSPing,
    Callback=function(v) Settings.FPSPing=v; if v then EnableFPS() else DisableFPS() end end })
TabMisc:Section({ Title="Camera" })
Toggles.MaxZoom = TabMisc:Toggle({ Title="Inf Zoom", Value=Settings.MaxZoom,
    Callback=function(v) Settings.MaxZoom=v; if v then EnableMaxZoom() else DisableMaxZoom() end end })
Toggles.NoclipCam = TabMisc:Toggle({ Title="Noclip Cam", Value=Settings.NoclipCam,
    Callback=function(v) Settings.NoclipCam=v; if v then EnableNC() else DisableNC() end end })
TabMisc:Section({ Title="Privacy / Chat" })
Toggles.ForceChat = TabMisc:Toggle({ Title="Force Chat", Value=Settings.ForceChat,
    Callback=function(v) Settings.ForceChat=v; if v then StartForceChat() else StopForceChat() end end })
Toggles.Disable007n7 = TabMisc:Toggle({ Title="Disable 007n7 Clone", Value=Settings.Disable007n7,
    Callback=function(v) Settings.Disable007n7=v; if v then StartDisable007n7() else StopDisable007n7() end end })
Toggles.ShowPrivacy = TabMisc:Toggle({ Title="Show Privacy", Value=Settings.ShowPrivacy,
    Callback=function(v) Settings.ShowPrivacy=v; if v then StartShowPrivacy() else StopShowPrivacy() end end })

TabMisc:Section({ Title="Emergency" })
TabMisc:Button({ Title="🛑 Disable All", Callback=function()
    StopAntiBlindness(); StopAntiGlitch(); StopAntiSubspaced(); StopAntiNoliLaugh()
    StopMinionESP(); StopProjectileESP(); StopAzureTrapESP()
    StopAutoBlock(); StopFourthButton(); StopCustomZoneVisuals()
    DisableLG(); DisableFPS(); DisableMaxZoom(); DisableNC()
    StopForceChat(); StopDisable007n7(); StopShowPrivacy()
    for k, v in pairs(Settings) do
        if type(v) == "boolean" and k ~= "AimPunch" then Settings[k] = false end
    end
    Settings.ABMode="Guest1337"; Settings.CustomABMode="Guest1337"; Settings.RectangleABMode="Guest1337"
    Settings.FourthButtonTarget="default"
    for key, t in pairs(Toggles) do
        if t and Settings[key] ~= nil then
            _suppressToggleCallback=true; pcall(function() t:Set(Settings[key]) end); _suppressToggleCallback=false
        end
    end
    if Toggles.ABModeDropdown then pcall(function() Toggles.ABModeDropdown:Set("Guest 1337") end) end
    if Toggles.CustomABModeDropdown then pcall(function() Toggles.CustomABModeDropdown:Set("Guest 1337") end) end
    if Toggles.RectangleModeDropdown then pcall(function() Toggles.RectangleModeDropdown:Set("Guest 1337") end) end
    if Toggles.FourthButtonTargetDropdown then pcall(function() Toggles.FourthButtonTargetDropdown:Set("Default") end) end
    Settings.CustomDiamondLength=8; Settings.CustomDiamondWidth=4; Settings.CustomDiamondOffset=3
    Settings.CustomCircleRadius=5; Settings.ZoneHeight=0.5
    Settings.RectangleDistance=3; Settings.RectangleMultiplier=1; Settings.RectangleEdgeTransparency=0.2
    zoneStateMemory.diamond=false; zoneStateMemory.circle=false
    if Rectangle.invisibleLoop then pcall(function() Rectangle.invisibleLoop:Disconnect() end); Rectangle.invisibleLoop=nil end
    if Rectangle.flashLoop then pcall(function() Rectangle.flashLoop:Disconnect() end); Rectangle.flashLoop=nil end
    Rectangle.invisibleTrackers = {}
    for _, flash in ipairs(Rectangle.visibleFlashes) do
        if flash.model and flash.model.Parent then pcall(function() flash.model:Destroy() end) end
    end
    Rectangle.visibleFlashes = {}
    if Rectangle.folder and Rectangle.folder.Parent then pcall(function() Rectangle.folder:Destroy() end); Rectangle.folder=nil end
    RestoreInputs()
    Settings.FOVValue=80
    if Sliders.FOV then pcall(function() Sliders.FOV:Set(80) end) end
    local cam = Workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView=80 end) end
    print("[shitsaken] ⛔ All disabled.")
end })

-- Config tab
local TabConfig = Window:Tab({ Title="Config", Icon="save" })
TabConfig:Section({ Title="Save / Load / Delete" })
TabConfig:Button({ Title="💾 Save Config", Callback=function()
    local ok = SaveConfig()
    print("[shitsaken] Save:", ok, "| Modes:", Settings.AutoBlock, Settings.AutoBlockCustom, Settings.AutoBlockRectangle, "| Target:", Settings.FourthButtonTarget)
end })
TabConfig:Button({ Title="📂 Load Config", Callback=function()
    local data = ReadConfigFile()
    if not data then print("[shitsaken] No config"); return end
    for k, v in pairs(data) do if Settings[k] ~= nil then Settings[k] = v end end
    for key, t in pairs(Toggles) do
        if t and Settings[key] ~= nil then
            _suppressToggleCallback=true; pcall(function() t:Set(Settings[key]) end); _suppressToggleCallback=false
        end
    end
    if Toggles.ABModeDropdown then pcall(function() Toggles.ABModeDropdown:Set(Settings.ABMode=="007n7" and "007n7" or "Guest 1337") end) end
    if Toggles.CustomABModeDropdown then pcall(function() Toggles.CustomABModeDropdown:Set(Settings.CustomABMode=="007n7" and "007n7" or "Guest 1337") end) end
    if Toggles.RectangleModeDropdown then pcall(function() Toggles.RectangleModeDropdown:Set(Settings.RectangleABMode=="007n7" and "007n7" or "Guest 1337") end) end
    if Toggles.FourthButtonTargetDropdown then 
        local lbl = "Default"
        if Settings.FourthButtonTarget == "custom" then lbl = "Custom"
        elseif Settings.FourthButtonTarget == "rectangle" then lbl = "Rectangle" end
        pcall(function() Toggles.FourthButtonTargetDropdown:Set(lbl) end)
    end
    if Sliders.FOV then pcall(function() Sliders.FOV:Set(Settings.FOVValue) end) end
    RestoreInputs()
    if Settings.AntiBlindness then StartAntiBlindness() else StopAntiBlindness() end
    if Settings.AntiGlitch then StartAntiGlitch() else StopAntiGlitch() end
    if Settings.AntiSubspaced then StartAntiSubspaced() else StopAntiSubspaced() end
    if Settings.AntiNoliLaugh then StartAntiNoliLaugh() else StopAntiNoliLaugh() end
    if Settings.MinionESP then StartMinionESP() else StopMinionESP() end
    if Settings.ProjectileESP then StartProjectileESP() else StopProjectileESP() end
    if Settings.AzureTrapESP then StartAzureTrapESP() else StopAzureTrapESP() end
    if Settings.AutoBlock or Settings.AutoBlockCustom or Settings.AutoBlockRectangle then StartAutoBlock() else StopAutoBlock() end
    NormalizeZoneForMode()
    RefreshFourthButton()
    if Settings.LowGraphics then EnableLG() else DisableLG() end
    if Settings.FPSPing then EnableFPS() else DisableFPS() end
    if Settings.MaxZoom then EnableMaxZoom() else DisableMaxZoom() end
    if Settings.NoclipCam then EnableNC() else DisableNC() end
    if Settings.ForceChat then StartForceChat() else StopForceChat() end
    if Settings.Disable007n7 then StartDisable007n7() else StopDisable007n7() end
    if Settings.ShowPrivacy then StartShowPrivacy() else StopShowPrivacy() end
    ApplyFOV()
    if FourthBlock.applyTint then FourthBlock.applyTint() end
end })
TabConfig:Button({ Title="🗑 Delete Config", Callback=function() local ok = DeleteConfigFile(); print("[shitsaken] Delete:", ok) end })

-- ═══════════════════════════════════════════════════════════════
-- BOOT
-- ═══════════════════════════════════════════════════════════════
if Settings.AntiBlindness then StartAntiBlindness() end

task.spawn(function()
    task.wait(1.0)
    local data = ReadConfigFile()
    if data then
        for k, v in pairs(data) do if Settings[k] ~= nil then Settings[k] = v end end
        if Settings.AntiBlindness then StartAntiBlindness() else StopAntiBlindness() end
        if Settings.AntiGlitch then StartAntiGlitch() end
        if Settings.AntiSubspaced then StartAntiSubspaced() end
        if Settings.AntiNoliLaugh then StartAntiNoliLaugh() end
        if Settings.MinionESP then StartMinionESP() end
        if Settings.ProjectileESP then StartProjectileESP() end
        if Settings.AzureTrapESP then StartAzureTrapESP() end
        if Settings.AutoBlock or Settings.AutoBlockCustom or Settings.AutoBlockRectangle then StartAutoBlock() end
        NormalizeZoneForMode()
        RefreshFourthButton()
        if Settings.LowGraphics then EnableLG() end
        if Settings.FPSPing then EnableFPS() end
        if Settings.MaxZoom then EnableMaxZoom() end
        if Settings.NoclipCam then EnableNC() end
        if Settings.ForceChat then StartForceChat() end
        if Settings.Disable007n7 then StartDisable007n7() end
        if Settings.ShowPrivacy then StartShowPrivacy() end
        ApplyFOV()
        for key, t in pairs(Toggles) do
            if t and Settings[key] ~= nil then
                _suppressToggleCallback=true; pcall(function() t:Set(Settings[key]) end); _suppressToggleCallback=false
            end
        end
        if Toggles.ABModeDropdown then pcall(function() Toggles.ABModeDropdown:Set(Settings.ABMode=="007n7" and "007n7" or "Guest 1337") end) end
        if Toggles.CustomABModeDropdown then pcall(function() Toggles.CustomABModeDropdown:Set(Settings.CustomABMode=="007n7" and "007n7" or "Guest 1337") end) end
        if Toggles.RectangleModeDropdown then pcall(function() Toggles.RectangleModeDropdown:Set(Settings.RectangleABMode=="007n7" and "007n7" or "Guest 1337") end) end
        if Toggles.FourthButtonTargetDropdown then 
            local lbl = "Default"
            if Settings.FourthButtonTarget == "custom" then lbl = "Custom"
            elseif Settings.FourthButtonTarget == "rectangle" then lbl = "Rectangle" end
            pcall(function() Toggles.FourthButtonTargetDropdown:Set(lbl) end)
        end
        if Sliders.FOV then pcall(function() Sliders.FOV:Set(Settings.FOVValue) end) end
        RestoreInputs()
        if FourthBlock.applyTint then FourthBlock.applyTint() end
    end
end)

RefreshFourthButton()
UpdateCustomZoneVisibility()

Players.PlayerAdded:Connect(function()
    task.defer(function()
        if PlayerDropdown then
            local names = {}; for _, p in ipairs(Players:GetPlayers()) do table.insert(names, p.Name) end
            pcall(function() PlayerDropdown:Refresh(names) end)
        end
    end)
end)
Players.PlayerRemoving:Connect(function()
    task.defer(function()
        if PlayerDropdown then
            local names = {}; for _, p in ipairs(Players:GetPlayers()) do table.insert(names, p.Name) end
            pcall(function() PlayerDropdown:Refresh(names) end)
        end
    end)
end)

print("[shitsaken] v9.9.0 Loaded")