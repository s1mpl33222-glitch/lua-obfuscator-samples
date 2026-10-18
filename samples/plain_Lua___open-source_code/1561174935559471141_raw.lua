
local print = function() end
local warn  = function() end
_G.TT3InvisAuto = false
_G.TT3AutoKickOnSteal = false
_G.TT3AutoBuy = false
if _G.TT3StealMode == nil then _G.TT3StealMode = "priority" end
if _G.TT3AutoTP == nil then _G.TT3AutoTP = true end
if _G.TT3GoToBrainrotHit == nil then _G.TT3GoToBrainrotHit = true end
if _G.TT3StealContinueWhileCarrying == nil then _G.TT3StealContinueWhileCarrying = true end
if _G.TT3StealDuringRagdoll == nil then _G.TT3StealDuringRagdoll = true end

if not game:IsLoaded() then game.Loaded:Wait() end

-- ORDEM DE PRIORIDADE: _FLOWER_PRIORITY_ORDER e a fonte da lista ativa e do
-- botao RESET. Ao iniciar, substitui listas antigas de priorityList e
-- priorityDefault salvas em SideTP.json, mantendo a mesma referencia da tabela
-- _G.SHARED_PRIORITY_ITEMS (table.clear + refill para preservar upvalues).
--  _G.TT3PriVersion        s incremente a chaque modif -> invalide le cache.
_G.TT3PriVersion = _G.TT3PriVersion or 0
local _FLOWER_PRIORITY_ORDER = {
        "Headless Horseman", "Strawberry Elephant", "Skibidi Toilet",
        "Meowl", "John Pork", "Ginger Gerat",
        "Bunny and Eggy", "Love Love Bear", "Ketupat Bros",
        "Antonio", "Signore Carapace", "Arcadragon",
        "La Supreme Combinasion", "Fishino Clownino", "Tirilikalika Tirilikalako",
        "Grabatron", "Polaroidini", "Rico Dinero",
        "Jolly Jolly Sahur", "Dug dug dug", "Los Dragons",
        "Hydra Bunny", "Kraken", "Venuspino",
        "Dragon Gingerini", "Griffin", "Dragon Aquanini",
        "Dragon Cannelloni", "Hydra Dragon Cannelloni", "Moby Bros",
        "Cooki and Milki", "Pancake and Syrup", "Los Secret Combinasionas",
        "Hydra Serpent", "La Casa Boo", "Los Admins",
        "Duggy Bros", "Gold and Diamond", "Sammyni Cakini",
        "S'more Serat", "Fragrama and Chocrama", "Los Sekolahs",
        "La Craft Machine", "Los Hackers", "Los Chillis",
        "Rubiko and Kubiko", "Rubrikiko", "Quackini Snackini",
        "Examen Bros", "Popcuru and Fizzuru", "Bumbatron",
        "Kalika Bros", "Reinito Sleighito", "Rosey and Teddy",
        "Cerberus", "Foxini Lanternini", "Boppin Bunny",
        "Spooky and Pumpky", "Festive 67", "Capitano Moby",
        "Gym Bros", "Money Money Bros", "Pizza and Ranch",
        "Burguro and Fryuro", "Cash or Card", "Garama and Madundung",
}
_G.TT3PriorityDefault = {}
for i, name in ipairs(_FLOWER_PRIORITY_ORDER) do _G.TT3PriorityDefault[i] = name end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
if #_G.SHARED_PRIORITY_ITEMS == 0 then
    for i, name in ipairs(_FLOWER_PRIORITY_ORDER) do _G.SHARED_PRIORITY_ITEMS[i] = name end
end
-- LISTE PRIORITE MUTATIONS: meme systeme que la priority brainrot mais pour les
-- mutations. index 1 = priorite MAX (en HAUT de la liste = Crystal), derniere =
-- priorite MIN (en BAS = Normal). Sert de 2e critere de tri (apres le nom du
-- brainrot, avant le MPS). _G.TT3MutVersion invalide le cache a chaque modif.
_G.TT3MutVersion = _G.TT3MutVersion or 0
if type(_G.TT3MutationDefault) ~= "table" then
    _G.TT3MutationDefault = {
        "Crystal", "Phantom", "Cyber", "Rainbow", "Divine", "Cursed",
        "Radioactive", "Yinyang", "Galaxy", "Lava", "Candy", "Bloodrot",
        "Diamond", "Gold", "Normal",
    }
end
if type(_G.SHARED_MUTATION_ITEMS) ~= "table" then
    _G.SHARED_MUTATION_ITEMS = {}
    for i = 1, #_G.TT3MutationDefault do _G.SHARED_MUTATION_ITEMS[i] = _G.TT3MutationDefault[i] end
end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

do
    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    local fileData, tpData
    if readfile then
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.TT3Climb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.TT3CFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.walkSpeed) == "number" then _G.TT3WalkSpeed = math.clamp(merged.walkSpeed, 16, 27) end
    if type(merged.carpetTool) == "string" then _G.TT3CarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.05, 0.75) end
    if type(merged.closeSpeed) == "number" then _G.TT3CloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.goToBrainrotHit) == "boolean" then _G.TT3GoToBrainrotHit = merged.goToBrainrotHit end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.TT3NearestKey = merged.nearestKey end
    -- MODE STEAL: toujours PRIORITY au lancement. On ignore volontairement
    -- merged.stealMode ("nearest" restait colle d une session a l autre).
    _G.TT3StealMode = "priority"
    _G._stealUserOff = false
    -- Charger d abord les listes sauvegardees; la liste source demandee sera
    -- appliquee juste apres la lecture de priorityDefault.
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.TT3PriVersion = _G.TT3PriVersion + 1
        end
    end
    -- Charger la valeur sauvegardee; la liste source demandee remplacera ce defaut.
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.TT3PriorityDefault = d end
    end
    -- Aplica a ordem de prioridade solicitada do arquivo de referência às duas listas,
    -- sobrescrevendo listas antigas carregadas de SideTP.json sem trocar a referência ativa.
    _G.TT3PriorityDefault = {}
    local _activePriority = _G.SHARED_PRIORITY_ITEMS
    table.clear(_activePriority)
    for i, name in ipairs(_FLOWER_PRIORITY_ORDER) do
        _G.TT3PriorityDefault[i] = name
        _activePriority[i] = name
    end
    _G.TT3PriVersion = (_G.TT3PriVersion or 0) + 1

    -- LISTE PRIORITE MUTATIONS perso (editee) -> remplace la liste active EN PLACE
    if type(merged.mutationList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.mutationList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_MUTATION_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.TT3MutVersion = _G.TT3MutVersion + 1
        end
    end
    if type(merged.mutationDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.mutationDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.TT3MutationDefault = d end
    end
    if type(merged.invisAuto) == "boolean" then _G.TT3InvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.TT3InvisDepth = math.clamp(merged.invisDepth, 0, 10) end
    if type(merged.invisAngle) == "number" then _G.TT3InvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if type(merged.autoTp) == "boolean" then _G.TT3AutoTP = merged.autoTp end
    if type(merged.continueAutoGrabWhileCarrying) == "boolean" then
        _G.TT3StealContinueWhileCarrying = merged.continueAutoGrabWhileCarrying
    end
    if type(merged.autoBuy) == "boolean" then _G.TT3AutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.TT3AutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    _G.TT3PanelVisibility = _G.TT3PanelVisibility or {}
    if type(merged.panelVisibility) == "table" then
        for id, value in pairs(merged.panelVisibility) do
            if type(value) == "boolean" then _G.TT3PanelVisibility[id] = value end
        end
    end
    if type(merged.autoKickOnSteal) == "boolean" then _G.TT3AutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.TT3ResetKeyName        = merged.resetKey end
    if type(merged.cloneKey)        == "string"  then _G.TT3CloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.TT3CarpetSpeedKeyName  = merged.carpetSpeedKey end

    -- TP au load: force ON + sauvegarde dans SideTP.json
    _G.TT3AutoTP = true
    if writefile then
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            t.autoTp = true
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

-- ===== ANTI-DIE: DEPLACE dans extras.txt (voir bloc "ANTI-DIE" la-bas) =====

-- ===== lines 103-314 from hub a =====
local _BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
local function _TT3IsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

do
local _nf=game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
local _xnNetMod
local function _xnGetNet()
if _xnNetMod then return _xnNetMod end
local ok,mod=pcall(require,_nf)
if ok and type(mod)=="table" then _xnNetMod=mod end
return _xnNetMod
end
local _xnGetUps=debug.getupvalues or getupvalues
local _XNGUID="^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
local _xnSecret
local function _xnFindSecret()
local Net=_xnGetNet()
if not Net or not _xnGetUps then return nil end
local seen,found={},nil
local job=game.JobId
local function walk(t,depth)
if depth>4 or found or seen[t] then return end
seen[t]=true
for _,v in pairs(t) do
if found then return end
local tv=typeof(v)
if tv=="string" and #v==36 and v~=job and v:match(_XNGUID) then
found=v
return
elseif tv=="table" then
walk(v,depth+1)
elseif tv=="function" then
local ok,u=pcall(_xnGetUps,v)
if ok and type(u)=="table" then walk(u,depth+1) end
end
end
end
for _,k in ipairs({"RemoteEvent","RemoteFunction","UnreliableRemoteEvent"}) do
local f=rawget(Net,k)
if type(f)=="function" then
local ok,u=pcall(_xnGetUps,f)
if ok and type(u)=="table" then walk(u,0) end
end
if found then break end
end
return found
end
local function _xnEncode(name)
local job=game.JobId
local out,idx={},1
for i=1,#name do
local ch=name:byte(i)
if ch==0x2F then
out[#out+1]="/"
else
local s=job:byte(((idx-1)%36)+1)%95
out[#out+1]=string.char(((ch-0x20+s)%95)+0x20)
idx=idx+1
end
end
return table.concat(out)
end
local _xnSha256 do
local bit=bit32
local band,bor,bxor,bnot,rrotate,rshift,lshift=bit.band,bit.bor,bit.bxor,bit.bnot,bit.rrotate,bit.rshift,bit.lshift
local K={
0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function m32(x) return band(x,0xFFFFFFFF) end
local function _bin(msg)
local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
local len=#msg
msg=msg.."\128"
while #msg%64~=56 do msg=msg.."\0" end
local bl=len*8
local lb={}
for i=8,1,-1 do lb[i]=string.char(bl%256) bl=math.floor(bl/256) end
msg=msg..table.concat(lb)
for cs=1,#msg,64 do
local w={}
for i=0,15 do
local a,b,c,d=string.byte(msg,cs+i*4,cs+i*4+3)
w[i]=bor(lshift(a,24),lshift(b,16),lshift(c,8),d)
end
for i=16,63 do
local x=w[i-15]
local s0=bxor(rrotate(x,7),rrotate(x,18),rshift(x,3))
local y=w[i-2]
local s1=bxor(rrotate(y,17),rrotate(y,19),rshift(y,10))
w[i]=m32(w[i-16]+s0+w[i-7]+s1)
end
local a,b,c,d,e,f,g,hh=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
for i=0,63 do
local S1=bxor(rrotate(e,6),rrotate(e,11),rrotate(e,25))
local ch=bxor(band(e,f),band(bnot(e),g))
local t1=m32(hh+S1+ch+K[i+1]+w[i])
local S0=bxor(rrotate(a,2),rrotate(a,13),rrotate(a,22))
local maj=bxor(band(a,b),band(a,c),band(b,c))
local t2=m32(S0+maj)
hh=g g=f f=e e=m32(d+t1) d=c c=b b=a a=m32(t1+t2)
end
h[1]=m32(h[1]+a) h[2]=m32(h[2]+b) h[3]=m32(h[3]+c) h[4]=m32(h[4]+d)
h[5]=m32(h[5]+e) h[6]=m32(h[6]+f) h[7]=m32(h[7]+g) h[8]=m32(h[8]+hh)
end
local out={}
for i=1,8 do
local x=h[i]
out[i]=string.char(band(rshift(x,24),255),band(rshift(x,16),255),band(rshift(x,8),255),band(x,255))
end
return table.concat(out)
end
local _memo={}
_xnSha256=function(s)
local c=_memo[s]
if c then return c end
local ok,b=pcall(_bin,s)
if not ok or type(b)~="string" then return nil end
local hex=(b:gsub(".",function(ch) return string.format("%02x",string.byte(ch)) end))
_memo[s]=hex
return hex
end
end
local function _xnHash(name)
if not _xnSecret then return nil end
return _xnSha256(_xnEncode(name).._xnSecret..game.JobId)
end
_xnSecret=_xnFindSecret()
local _xnCache={}
local function _get(name,kind)
kind=(kind=="RemoteFunction" and "RemoteFunction")or(kind=="UnreliableRemoteEvent" and "UnreliableRemoteEvent")or"RemoteEvent"
if type(name)~="string" or name=="" then return nil end
local logical=name:match("^R[EF]/(.+)$")or name:match("^URE/(.+)$")or name
local ck=kind.."|"..logical
local hit=_xnCache[ck]
if hit and hit.Parent then return hit end
_xnCache[ck]=nil
if not _xnSecret then _xnSecret=_xnFindSecret() end
local h=_xnHash(logical)
if not h then return nil end
local p=(kind=="RemoteFunction" and "RF/")or(kind=="UnreliableRemoteEvent" and "URE/")or"RE/"
local inst=_nf:FindFirstChild(p..h)
if inst then
_xnCache[ck]=inst
return inst
end
return nil
end
_G.XenNet={
RemoteEvent=function(_,name)return _get(name,"RemoteEvent")end,
RemoteFunction=function(_,name)return _get(name,"RemoteFunction")end,
UnreliableRemoteEvent=function(_,name)return _get(name,"UnreliableRemoteEvent")end,
}
_G.XenGetRemote=_get
_G.Resolve=_get
_G.HashOf=_xnHash
_G.NetSecret=function()return _xnSecret end
_G.__secureGetRemote=function(method,name) return _get(name,method) end
do
local _xnDummy=Instance.new("RemoteEvent")
local _xnRawFire=clonefunction(_xnDummy.FireServer)
_G.RawFire=function(name,...)
local r=_get(name)
if not r then return false end
_xnRawFire(r,...)
return true
end
end
task.spawn(function()
while true do
task.wait(10)
if not(_xnSecret and _get("UseItem")) then
_xnSecret=_xnFindSecret()
_xnCache={}
end
end
end)
end

-- ===== Synchronizer ( portage 1:1 depuis sync.lua) =====
do
-- Synchronizer channel-registry discovery - heap identity.
-- The probe/deepScan it replaces is dead: Synchronizer.Get has 13 upvalues and
-- none holds channels, and a deep scan of every module function x24 upvalues x4
-- nested slots scores 0 (measured live). No Synchronizer method is called here
-- at all - none of its read, wait or enumerate methods, and no signal connected.
-- Packages.Synchronizer.Channel is required purely for its class table, then
-- every live channel is lifted off the GC heap by metatable identity. Finds
-- channels nothing told it to look for, including the local player's own.
-- Diagnostic in _G.TT3SyncDiag.
local _xchan
local _class
local _lastSweep = 0
local _dirty = true
local SWEEP_GAP = 0.5

local function _classTable()
    if _class then return _class end
    local ok, c = pcall(function()
        return require(game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Synchronizer")
            :WaitForChild("Channel"))
    end)
    if ok and type(c) == "table" then _class = c end
    return _class
end

local function _sweep()
    local cls = _classTable()
    if not cls or type(getgc) ~= "function" then
        _G.TT3SyncDiag = cls and "getgc unavailable" or "Channel class not found"
        return
    end
    _lastSweep = os.clock()
    _dirty = false
    local reg, n = {}, 0
    local gc = getgc(true)
    for i = 1, #gc do
        local v = gc[i]
        if type(v) == "table" and getmetatable(v) == cls then
            local idx = rawget(v, "Index")
            if idx ~= nil then reg[idx] = v; n = n + 1 end
        end
    end
    _xchan = reg
    _G.TT3SyncDiag = string.format("heap identity - %d channels", n)
end

-- cheap: only sweeps when a plot has no channel yet, or a plot just changed
local function _needsSweep()
    if not _xchan then return true end
    if _dirty then return true end
    local pl = workspace:FindFirstChild("Plots")
    if pl then
        for _, p in ipairs(pl:GetChildren()) do
            if _xchan[p.Name] == nil then return true end
        end
    end
    return false
end

do
    local pl = workspace:FindFirstChild("Plots")
    if pl then
        pl.ChildAdded:Connect(function() _dirty = true end)
        pl.ChildRemoved:Connect(function() _dirty = true end)
    end
end

local function _chans()
    if _needsSweep() and (os.clock() - _lastSweep) > SWEEP_GAP then _sweep() end
    return _xchan
end
_G.__secureChans = _chans

_G.TT3SyncAll=function()return _chans()end
_G.TT3SyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
-- Raw channel property read (the BYPASS): never calls channel:Get(key) -- the
-- hookable/patched surface -- it reads CacheTable directly with rawget, falling
-- back to plain indexing only for proxy/__index-backed registries.
_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
if okV then return v2 end
return nil
end
_G._TT3RawCT=function(plotName)
local c=_G.TT3SyncGet(plotName)
if not c then return nil end
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
if _AD then return true end
local ok=pcall(function()
local d=game:GetService("ReplicatedStorage"):WaitForChild("Datas")
_AD=require(d:WaitForChild("Animals"))
_MD=require(d:WaitForChild("Mutations"))
_TD=require(d:WaitForChild("Traits"))
end)
return ok and _AD~=nil
end
_G._TT3Gen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
_G._TT3AnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._TT3Gen(index,mutation,traits)end},{
__index=function(_,k)
local ok,real=pcall(function()return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))end)
if ok and type(real)=="table" then return rawget(real,k) end
return nil
end})
_G.TT3_GetPlotChannel=function(plotName)return _G.TT3SyncGet(plotName)end
_G.TT3_GetAllPlots=function()return _G.TT3SyncAll() or {} end
_G.TT3_GetPlotAnimalList=function(plotName)
local ct=_G._TT3RawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

-- ===== compat: anciens noms TT3* -> nouveaux accesseurs du synchronizer =====
_G.TT3SyncAll  = _G.TT3SyncAll
_G.TT3SyncGet  = _G.TT3SyncGet
_G.TT3RawCT    = _G._TT3RawCT
_G.TT3Gen      = _G._TT3Gen
_G.TT3AnimShim = _G._TT3AnimShim
-- __secureChans = probe/deepScan. Pas de GetAllChannels.
_G.stealthGet    = function(n) return _G.TT3SyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}

-- Prechauffe agressive au boot pour latched les channels pendant le load
task.spawn(function()
    for _ = 1, 150 do
        local t = _G.TT3SyncAll()
        if type(t) == "table" then
            local hit = false
            for _, v in next, t do
                if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                    hit = true
                    break
                end
            end
            if hit then break end
        end
        task.wait(0.03)
    end
end)

_G.TT3GetSyncData = _G.TT3GetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    if not plotName then return nil end
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    if not Sync then return nil end
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.TT3RawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.TT3SyncGet(plotName) end)
    if okC and ch then
        local synth = { __channel = ch }
        -- (ch:Get REMOVED -- snitch. rawget the CacheTable instead.)
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
        return synth
    end
    return nil
end

local Synchronizer, AnimalsData, AnimalsShared, NumberUtils

local function loadModules()
    if Synchronizer then return true end
    local ok = pcall(function()
        local Packages = RS:WaitForChild("Packages", 5)
        local Datas = RS:WaitForChild("Datas", 5)
        local Shared = RS:WaitForChild("Shared", 5)
        local Utils = RS:WaitForChild("Utils", 5)
        Synchronizer = require(Packages:WaitForChild("Synchronizer"))
        AnimalsData = require(Datas:WaitForChild("Animals"))
        AnimalsShared = _G.TT3AnimShim
        NumberUtils = require(Utils:WaitForChild("NumberUtils"))
    end)
    return ok and Synchronizer ~= nil
end

do
    local function _scanResetRemotes()
        _G.TT3ResetRemoteList = _G.TT3ResetRemoteList or {}
        local roots = { RS, workspace, game:GetService("ReplicatedFirst") }
        for _, root in ipairs(roots) do
            pcall(function()
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("RemoteEvent") and d.Name:sub(1, 3) == "RE/" then
                        if not _G.TT3ResetRemote then _G.TT3ResetRemote = d end
                        _G.TT3ResetRemoteList[d] = true
                    end
                end
            end)
        end
    end
    task.spawn(function()
        for _ = 1, 6 do
            _scanResetRemotes()
            task.wait(1)
        end
    end)
    _G.TT3ScanResetRemotes = _scanResetRemotes
end

local NetModule
local function loadNet() return false end


-- ===== lines 315-761 from hub a =====

local function getRemote(method, name)
    -- Le vrai remote hashe est renvoye directement, sans scanner le GC.
    return _G.__secureGetRemote(method, name)
end
_G.TT3GetRemote = getRemote

local GRAPPLE_ARG = 0.8
_G.XenFireGrapple2 = function()
pcall(function()
-- grapple: index Net children directly instead of resolving by name.
-- UseItem sits at index 6 (verified live: same object the tool itself fires).
local _nfx=game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
local _r=_nfx:GetChildren()[tonumber(_G.XenUseItemIndex) or 6]
if _r and _r:IsA("RemoteEvent") then _r:FireServer(0.8) end
end)
end

local function fireGrapple()
    local char = LP.Character
    if not char then return end
    if not char:FindFirstChild("Grapple Hook") then
        local bp = LP:FindFirstChild("Backpack")
        local tool = bp and bp:FindFirstChild("Grapple Hook")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if tool and hum then pcall(function() hum:EquipTool(tool) end) end
    end
    if not char:FindFirstChild("Grapple Hook") then return end
    return _G.XenFireGrapple2()
end
_G.TT3FireGrapple = fireGrapple

local CARPET_SPEED = 280
local INBASE_SPEED = 450
local SKY_CLONE_WAIT = 0.35
local CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
local function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
local GRAPPLE_NAMES = { "Grapple Hook", "Grappling Hook", "Grapple", "Hook", "Web Slinger", "Grapple Gun", "GrappleHook" }
local function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
    return nil
end
local function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end
-- Fast path: si deja equipe, return immédiat + throttle re-equip.
local _lastCarpetEquipTry = 0
local function equipCarpet()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = char:FindFirstChild(n)
        if t and t:IsA("Tool") then return n end
    end
    local now = os.clock()
    if now - _lastCarpetEquipTry < 0.3 then return nil end
    _lastCarpetEquipTry = now
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            return n
        end
    end
    return nil
end
-- Debug / wallhug OFF par défaut — active via _G si besoin
if _G.TT3TPDebug == nil then _G.TT3TPDebug = false end
if _G.TT3WallHug == nil then _G.TT3WallHug = false end
local function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.TT3CarpetTool = name
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.TT3SetCarpetTool = setCarpetTool
if type(_G.TT3CarpetTool) == "string" and _G.TT3CarpetTool ~= "" then
    setCarpetTool(_G.TT3CarpetTool)
end
local _carpetEngaging = false
local function carpetEngage(force)
    if not force then
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                    return n
                end
            end
        end
    end
    if _carpetEngaging then
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < 5 do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end
    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    task.wait(0.01)
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        -- Hub Leaked dispara uma única sequência; a própria rotina repete Activate
        -- internamente apenas até detectar FlightPower.
        _G.XenFireGrapple2()
    end
    task.wait(0.05)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.05)
    local cn
    local _tc = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 1
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
    return cn
end

local PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

local TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

local LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

local DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

local MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

local MUTATED_BEATS_GRIFFIN = {
    ["Fishino Clownino"]=true,["Globa Steppa"]=true,
    ["La Supreme Combinasion"]=true,["Tirilikalika Tirilikalako"]=true,
}

local function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    local n = tostring(m):lower():gsub("[%s%-_]","")
    if n == "bloodrot" then return 2 end
    if n == "yinyang" or n == "galaxy" or n == "candy" or n == "divine"
        or n == "cursed" or n == "lava" or n == "radioactive" or n == "cyber"
        or n == "rainbow" then return 1 end
    return 0
end

local function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
    return total
end

local function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end
-- CACHE lookup priorite: nom normalise -> rang. Reconstruit UNIQUEMENT quand
-- _G.TT3PriVersion change (add / remove / reorder / reset). Avant, scanAllPets
-- rebuildait cette table a CHAQUE scan -> zero rebuild inutile maintenant.
local _priCacheVer, _priCache = -1, {}
local function _priLookup()
    local ver = _G.TT3PriVersion or 0
    if _priCacheVer ~= ver then
        table.clear(_priCache)
        local plist = _G.SHARED_PRIORITY_ITEMS
        if type(plist) == "table" then
            -- i decroissant => en cas de doublon, le plus petit rang gagne
            for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
        end
        _priCacheVer = ver
    end
    return _priCache
end
_G.TT3PriLookup = _priLookup
local function _priIndexOf(name)
    if not name then return nil end
    return _priLookup()[_normName(name)]
end

-- CACHE lookup priorite MUTATION: nom normalise -> rang (index 1 = Crystal = max).
-- Reconstruit uniquement quand _G.TT3MutVersion change.
local _mutCacheVer, _mutCache = -1, {}
local function _mutLookup()
    local ver = _G.TT3MutVersion or 0
    if _mutCacheVer ~= ver then
        table.clear(_mutCache)
        local mlist = _G.SHARED_MUTATION_ITEMS
        if type(mlist) == "table" then
            for i = #mlist, 1, -1 do _mutCache[_normName(mlist[i])] = i end
        end
        _mutCacheVer = ver
    end
    return _mutCache
end
_G.TT3MutLookup = _mutLookup
-- rang d une mutation (nil/""/"None" -> rang de "Normal"; inconnue -> Normal aussi)
local function _mutRank(mut)
    local lk = _mutLookup()
    local normalRank = lk[_normName("Normal")] or math.huge
    if not mut or mut == "" or mut == "None" then return normalRank end
    return lk[_normName(mut)] or normalRank
end
_G.TT3MutRank = _mutRank

local function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then return iA < iB end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    return (aMPS or 0) > (bMPS or 0)
end

local function getPlotChannel(plotName)
    local channel
    pcall(function() channel = _G.TT3SyncGet(plotName) end)
    return channel
end

local function channelGet(channel, key)
    if not channel then return nil end
    local v
    pcall(function() local ct = rawget(channel, "CacheTable"); if type(ct) == "table" then v = ct[key] end end)
    return v
end

-- Resolve a channel Owner value (Player instance / UserId number / username
-- string / table) to a Player. The game update switched Owner to a USERNAME
-- STRING, which neither isMyPlot nor ownerInGame handled -- ownerInGame then
-- returned false for every plot, so the scanner skipped them all and found
-- zero pets. Handles every known shape so a future change cannot break it.
local function resolveOwner(owner)
    if owner == nil then return nil end
    local plr
    pcall(function()
        if typeof(owner) == "Instance" then
            plr = owner:IsA("Player") and owner or Players:FindFirstChild(owner.Name)
        elseif type(owner) == "number" then
            plr = Players:GetPlayerByUserId(owner)
        elseif type(owner) == "string" then
            if tonumber(owner) then plr = Players:GetPlayerByUserId(tonumber(owner)) end
            if not plr then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == owner:lower() or p.DisplayName:lower() == owner:lower() then
                        plr = p; break
                    end
                end
            end
        elseif type(owner) == "table" then
            if owner.UserId then plr = Players:GetPlayerByUserId(owner.UserId) end
            if not plr and owner.Name then plr = Players:FindFirstChild(tostring(owner.Name)) end
        end
    end)
    return plr
end

local function isMyPlot(channel)
    if not channel then return false end
    local owner = channelGet(channel, "Owner")
    if not owner then return false end
    local plr = resolveOwner(owner)
    if plr then return plr.UserId == LP.UserId end
    if type(owner) == "string" then
        local o = owner:lower()
        return o == LP.Name:lower() or o == LP.DisplayName:lower()
    end
    return false
end

local function ownerInGame(channel)
    if not channel then return false end
    local owner = channelGet(channel, "Owner")
    if not owner then return false end
    if resolveOwner(owner) then return true end
    -- FAIL OPEN: if the Owner is a shape we cannot resolve, do NOT skip the plot.
    -- Skipping on an unknown format is what made the whole scan return nothing;
    -- including it at worst adds a plot whose owner already left.
    if typeof(owner) == "Instance" or type(owner) == "number"
       or (type(owner) == "table" and (owner.UserId or owner.Name)) then
        return false
    end
    return true
end

local function getPetPosition(plot, slot)
    -- position cache: podium pets do not move, so this skips the heavy
    -- GetDescendants + GetBoundingBox on every scan
    _G.__PetPosCache = _G.__PetPosCache or {}
    local _cache = _G.__PetPosCache
    local _key = plot.Name .. "|" .. tostring(slot)
    local _hit = _cache[_key]
    local _now = os.clock()
    if _hit and _now < _hit.exp then return _hit.pos end
    local function compute()
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(tostring(slot))
        if not podium then return nil end
        for _, desc in ipairs(podium:GetDescendants()) do
            if desc:IsA("Model") and desc.Name ~= "Claim" and desc.Name ~= "Base" and desc.Name ~= "Decorations" then
                local hasMesh = false
                for _, c in ipairs(desc:GetDescendants()) do
                    if c:IsA("MeshPart") then hasMesh = true; break end
                end
                if hasMesh then
                    local ok, cf = pcall(function() return desc:GetBoundingBox() end)
                    if ok then return cf.Position end
                end
            end
        end
        local ok, cf = pcall(function() return podium:GetPivot() end)
        if ok then return cf.Position end
        return podium.Position
    end
    local _pos = compute()
    if _pos then _cache[_key] = { pos = _pos, exp = _now + 12 + math.random() * 8 } end
    return _pos
end

local function scanAllPets()
    local pets = {}
    if not loadModules() then return pets end

    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return pets end

    for _, plot in ipairs(Plots:GetChildren()) do
        local channel = getPlotChannel(plot.Name)
        if not channel then continue end
        if isMyPlot(channel) then continue end
        if not ownerInGame(channel) then continue end

        local animalList = channelGet(channel, "AnimalList")
        if not animalList then continue end

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if not animalInfo then continue end
            if _TT3IsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"
            local genValue = 0
            pcall(function()
                genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
            end)

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot)

            if pos then
                table.insert(pets, {
                    name = displayName,
                    index = animalName,
                    mps = genValue,
                    mutation = mutation,
                    position = pos,
                    plot = plot.Name,
                    slot = tostring(slot),
                })
            end
        end
    end

    local _priLk = _priLookup()
    local anyPri = false
    for _, p in ipairs(pets) do
        p._pri = _priLk[_normName(p.name)] or (p.index and _priLk[_normName(p.index)]) or nil
        p._mut = _mutRank(p.mutation)   -- rang mutation (Crystal=1 ... Normal=dernier)
        if p._pri ~= nil then anyPri = true end
    end

    local mode = _G.TT3StealMode
    -- highest OU aucun brainrot de la PRIORITY LIST present sur le terrain ->
    -- tri MPS pur (le plus gros gagne, la mutation n entre PAS en jeu).
    -- = "si ya pas de brainrot priority -> highest peu importe la mutation".
    if mode == "highest" or not anyPri then
        table.sort(pets, function(a, b) return (a.mps or 0) > (b.mps or 0) end)
        return pets
    end

    -- TRI: 1) priorite BRAINROT (nom)  2) priorite MUTATION  3) MPS
    -- (choix utilisateur: le nom prime; la mutation departage a nom egal / non liste)
    table.sort(pets, function(a, b)
        local ia, ib = a._pri, b._pri
        -- 1) nom: en liste bat hors liste, sinon plus petit index gagne
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        if ia and ib and ia ~= ib then return ia < ib end
        -- 2) mutation: plus petit rang gagne (Crystal en haut)
        local ma, mb = a._mut or math.huge, b._mut or math.huge
        if ma ~= mb then return ma < mb end
        -- 3) MPS
        return (a.mps or 0) > (b.mps or 0)
    end)

    return pets
end

local function scanForTP()
    local pets
    if _G.TT3ScanTiered then
        local ok, result = pcall(_G.TT3ScanTiered)
        if ok and type(result) == "table" then pets = result end
    end
    if type(pets) ~= "table" then pets = scanAllPets() end

    -- Sem nenhum Brainrot da Priority List no servidor, o alvo passa a ser
    -- automaticamente o maior MPS disponível, inclusive com scanner externo.
    local hasPriority = false
    local lookup = _priLookup()
    for _, pet in ipairs(pets) do
        local keyName = pet.name or pet.index
        if keyName and lookup[_normName(keyName)] ~= nil then
            hasPriority = true
            break
        end
    end
    if not hasPriority then
        table.sort(pets, function(a, b)
            return (tonumber(a.mps) or 0) > (tonumber(b.mps) or 0)
        end)
    end
    return pets
end

-- Deux logiques separees:
-- 1) TP sync  -> apres un TP, auto-steal reste colle a CETTE pet
-- 2) A pied   -> priority / nearest, ZERO sync
local function _petUid(p)
    if not p then return nil end
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
local function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    local best
    if _G.TT3StealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    else
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
local function _findTPSyncedPet(pets)
    local uid = _G.TT3StealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
    return nil
end
local function _clearTPSync()
    _G.TT3TPSyncActive = false
    _G.TT3StealTargetUID = nil
    _G.TT3StealTarget = nil
end
local function _armTPSync(pet)
    if not pet then return end
    _G.TT3StealTargetUID = _petUid(pet)
    _G.TT3StealTarget = pet
    _G.TT3TPSyncActive = true
    local gen = (_G._TT3TPSyncGen or 0) + 1
    _G._TT3TPSyncGen = gen
    task.delay(12, function()
        if _G._TT3TPSyncGen == gen then _clearTPSync() end
    end)
end
_G.TT3ClearTPSync = _clearTPSync
-- compat anciens appels
local function _findStealTarget(pets)
    if not _G.TT3TPSyncActive then return nil end
    return _findTPSyncedPet(pets)
end
local function _publishStealTarget(pet)
    if not pet then return end
    _G.TT3StealTargetUID = _petUid(pet)
    _G.TT3StealTarget = pet
end

-- ===== lines 773-2506 from hub a =====
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
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
local BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
local FRONT_Y_LOW   = -3.048217
local FRONT_Y_HIGH  = 16.850713
local COLUMN_SPLIT_X = -410
local FRONT_Z_CLAMP  = 18
local SIDE_NEAR_Z    = 45

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

local function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        if not plot then return end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
    return solid
end

local function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if not channel then return false end
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

local function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

local _vizGen, clearViz, vizPath
do
local _vizParts = {}
_vizGen = 0
local _vizFolder, _vizAnchor
local function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    _vizFolder.Name = "TT3PathViz"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    if _vizFolder then pcall(function() _vizFolder:Destroy() end) end
    _vizFolder, _vizAnchor = nil, nil
    table.clear(_vizParts)
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
local function _neon(cf, size, color, ball)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
end
-- TP TRAIL: 1 seul objet par segment. La version d origine en creait 3
-- (1 Part neon + 2 BoxHandleAdornment), soit ~300 objets pour une route
-- de 50 waypoints -- c est ce qui faisait ramer. Les BoxHandleAdornment
-- sont les plus chers: ils se dessinent par-dessus toute la geometrie.
local function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.35, 0.35, d.Magnitude), color, false)
end
local function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true)
end
vizPath = function(fromPos, waypoints)
    -- Visualizacao de rota removida: o teleporte continua funcionando.
end
end

local SPEED = 125
local ARRIVE = 3
local _STRIP_OK = (type(getconnections) == "function")
local function _climbCap()
    local v = math.clamp(tonumber(_G.TT3Climb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
    return v
end

local function vZero(hrp)
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end
end

-- Movimento físico contínuo adaptado da rotina ativa do Neegy:
-- aplica velocidade no torso/root e acompanha os waypoints sem teleporte por CFrame.
local function _setFlightVel(hrp, vel)
    local char = hrp and hrp.Parent
    if not char then return end
    local part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
    if part and part.Parent then part.AssemblyLinearVelocity = vel end
end

local function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or (_G.TPVelocity and math.clamp(_G.TPVelocity, 200, 750)) or CARPET_SPEED
    vizPath(hrp.Position, waypoints)
    local wpIdx, done, conn = 1, false, nil
    local function finish()
        if done then return end
        done = true
        if hrp and hrp.Parent then
            _setFlightVel(hrp, Vector3.zero)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0
    local lastJump = 0
    local routeLen, prev = 0, hrp.Position
    for _, wp in ipairs(waypoints) do
        routeLen = routeLen + (wp - prev).Magnitude
        prev = wp
    end
    local mayJump = routeLen >= (tonumber(_G.TT3JumpMinDist) or 100)
    local _ = quickStart

    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or done then
            if conn then conn:Disconnect() end
            return
        end
        if _G.TT3TPStop then finish(); return end
        equipCarpet()
        if mayJump and _G.TT3JumpEachStep ~= false then
            local now = os.clock()
            if now - lastJump >= (tonumber(_G.TT3JumpGap) or 0.2) then
                lastJump = now
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() hum.Jump = true end)
                end
            end
        end

        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local speed = _runSpeed
        if wpIdx < #waypoints and mag < 26 then
            local nextWp = waypoints[wpIdx + 1]
            local turn = nextWp - target
            if mag > 0.1 and turn.Magnitude > 0.1 and diff.Unit:Dot(turn.Unit) < 0.9 then
                speed = math.min(speed, 240)
            end
        end
        local arrive = math.max(ARRIVE, speed / 60 * 1.25)
        if mag < arrive then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish(); return end
            lastDist, stall = math.huge, 0
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
            if mayJump and _G.TT3JumpEachStep ~= false then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    lastJump = os.clock()
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() hum.Jump = true end)
                end
            end
        end

        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= (tonumber(_G.TT3StallFrames) or 18) then
            if _G.TT3TPDebug then
                warn(string.format("[TT3TP] STALL snap -> wp %d/%d, %.0f studs left", wpIdx, #waypoints, mag))
            end
            finish(); return
        end
        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local state = hum:GetState()
                    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local climbSpeed = speed
            local maxClimb = _climbCap()
            if dir.Y > 0 and dir.Y * climbSpeed > maxClimb then
                climbSpeed = maxClimb / dir.Y
            end
            _setFlightVel(hrp, Vector3.new(dir.X * climbSpeed, dir.Y * climbSpeed, dir.Z * climbSpeed))
        end
    end))

    local timeout = routeLen / math.max(1, math.min(SPEED, _runSpeed)) + (tonumber(_G.TT3FlightGrace) or 2)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
        if not (hrp and hrp.Parent) then break end
    end
    if not done and _G.TT3TPDebug then
        local remaining = (hrp and hrp.Parent) and (waypoints[#waypoints] - hrp.Position).Magnitude or -1
        warn(string.format("[TT3TP] TIMEOUT snap after %.1fs, %.0f studs left", elapsed, remaining))
    end
    finish()
    vZero(hrp)
end

local _OTHER_CLONES = {}
do
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(n)
        return type(n) == "string" and n ~= _MY_CLONE and n:match("^%d+_Clone$") ~= nil
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst.Name) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

do
    local _pSeen = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15); _declawChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)
    -- Rescan rare: DescendantAdded couvre deja le live. Poll 1s = hitch inutile.
    task.spawn(function()
        while true do
            task.wait(5)
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character then
                    for _, d in ipairs(pl.Character:GetDescendants()) do _declaw(d) end
                end
            end
        end
    end)
end

-- Pathfinding helpers wrapped in a do-block so their ~30 locals free after,
-- leaving only computeRoute + _len live in the main chunk (register budget).
local computeRoute, _len
do
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end
local function _blocksWide(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
    return false
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
    return nil
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    if not res then return maxD end
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
    return s
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
    return st
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
    return true
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
    return m
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
    return pts
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
    return list
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.TT3StrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local res
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if not res then return false end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
    return true
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    if not _canSphere then return nil end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    if fwd then return true end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
    return rev
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
            if res then
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
        do
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
            if resUp then
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
            else
                out[#out + 1] = p
            end
        else
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
    return out
end

local voxelRoute
do
local _vxFloor, _vxSqrt = math.floor, math.sqrt
local _vxMin, _vxMax = math.min, math.max
local function _vxAbs(n) return n < 0 and -n or n end

local _vxOverlap = OverlapParams.new()
_vxOverlap.FilterType = Enum.RaycastFilterType.Exclude
_vxOverlap.RespectCanCollide = true

local _vxCast = RaycastParams.new()
_vxCast.FilterType = Enum.RaycastFilterType.Exclude
_vxCast.RespectCanCollide = true
_vxCast.IgnoreWater = true

local _vxOrigin
local _vxDimX, _vxDimY, _vxDimZ = 0, 0, 0
local _vxSz, _vxInflate = 4, 2.5
local _vxSolid = {}
local _vxHeight = 5

local function _vxWorld(sz, x, y, z)
    local h = sz * 0.5
    return Vector3.new(_vxOrigin.X + x * sz + h, _vxOrigin.Y + y * sz + h, _vxOrigin.Z + z * sz + h)
end
local function _vxKey(x, y, z) return x + y * 1024 + z * 1048576 end

local function _vxIsSolid(x, y, z)
    if x < 0 or y < 0 or z < 0 or x >= _vxDimX or y >= _vxDimY or z >= _vxDimZ then return true end
    local k = _vxKey(x, y, z)
    local c = _vxSolid[k]
    if c ~= nil then return c end
    local h = _vxSz * 0.5
    local cx = _vxOrigin.X + x * _vxSz + h
    local cy = _vxOrigin.Y + y * _vxSz + h
    local cz = _vxOrigin.Z + z * _vxSz + h
    local sxz = _vxSz + _vxInflate
    local vy = _vxHeight > _vxSz and _vxHeight or _vxSz
    local vcy = cy - h + vy * 0.5
    local parts = workspace:GetPartBoundsInBox(CFrame.new(cx, vcy, cz), Vector3.new(sxz, vy, sxz), _vxOverlap)
    local solid = #parts > 0
    _vxSolid[k] = solid
    return solid
end

local function _vxSegClear(from, to, radius, height, sample)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.05 then return true end
    if workspace:Raycast(from, dir, _vxCast) then return false end
    local r = radius > 1 and radius or 1
    if workspace:Blockcast(CFrame.new(from), Vector3.new(r * 2, height, r * 2), dir, _vxCast) ~= nil then return false end
    local n = _vxFloor(mag)
    if sample ~= false and n >= 2 then
        local step = dir / n
        local torso = Vector3.new(r * 2, 3, r * 2)
        for i = 1, n - 1 do
            local pt = from + step * i
            if #workspace:GetPartBoundsInBox(CFrame.new(pt), torso, _vxOverlap) > 0 then return false end
        end
    end
    return true
end

local _vxNeigh = {}
do
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                    local nz = (dx ~= 0 and 1 or 0) + (dy ~= 0 and 1 or 0) + (dz ~= 0 and 1 or 0)
                    local kd = dx + dy * 1024 + dz * 1048576
                    _vxNeigh[#_vxNeigh + 1] = { dx, dy, dz, _vxSqrt(dx * dx + dy * dy + dz * dz), nz, kd }
                end
            end
        end
    end
end

local function _vxNoCorner(cx, cy, cz, off)
    if off[5] < 2 then return true end
    if off[1] ~= 0 and _vxIsSolid(cx + off[1], cy, cz) then return false end
    if off[2] ~= 0 and _vxIsSolid(cx, cy + off[2], cz) then return false end
    if off[3] ~= 0 and _vxIsSolid(cx, cy, cz + off[3]) then return false end
    return true
end

local function _vxSnapGoal(goalPos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and (_vxWorld(_vxSz, nx, ny, nz) - goalPos).Magnitude <= 8 then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end
local function _vxSnapStart(pos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and not workspace:Raycast(pos, _vxWorld(_vxSz, nx, ny, nz) - pos, _vxCast) then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end

local function _vxPush(h, f, key)
    local i = #h + 1
    h[i] = { f, key }
    while i > 1 do
        local p = _vxFloor(i * 0.5)
        if h[p][1] <= h[i][1] then break end
        h[p], h[i] = h[i], h[p]
        i = p
    end
end
local function _vxPop(h)
    local n = #h
    if n == 0 then return nil end
    local top = h[1]
    h[1] = h[n]
    h[n] = nil
    n -= 1
    local i = 1
    while true do
        local l, r, s = i + i, i + i + 1, i
        if l <= n and h[l][1] < h[s][1] then s = l end
        if r <= n and h[r][1] < h[s][1] then s = r end
        if s == i then break end
        h[i], h[s] = h[s], h[i]
        i = s
    end
    return top[2]
end

local _vxHeurW = 2
local function _vxAStar(sz, startCell, goalCell, startPos, goalPos)
    local sx, sy, sz2 = _vxSnapStart(startPos, startCell.x, startCell.y, startCell.z)
    local gx, gy, gz = _vxSnapGoal(goalPos, goalCell.x, goalCell.y, goalCell.z)
    local goalKey = _vxKey(gx, gy, gz)
    local startKey = _vxKey(sx, sy, sz2)

    local nodes = { [startKey] = { x = sx, y = sy, z = sz2, g = 0, parent = nil } }
    local closed = {}
    local heap = {}
    _vxPush(heap, 0, startKey)

    local function Heur(x, y, z)
        local ax, ay, az = x - gx, y - gy, z - gz
        return _vxSqrt(ax * ax + ay * ay + az * az)
    end

    local pops = 0
    while #heap > 0 do
        local curKey = _vxPop(heap)
        if closed[curKey] then continue end
        closed[curKey] = true
        pops += 1
        if pops > 300000 then break end

        local cur = nodes[curKey]
        if curKey == goalKey then
            local path = {}
            local n = cur
            while n do
                path[#path + 1] = _vxWorld(sz, n.x, n.y, n.z)
                n = n.parent and nodes[n.parent]
            end
            local rev = {}
            for i = #path, 1, -1 do rev[#rev + 1] = path[i] end
            return rev
        end

        local cx, cy, cz = cur.x, cur.y, cur.z
        local cg = cur.g
        for _, off in _vxNeigh do
            local nk = curKey + off[6]
            if closed[nk] then continue end
            local nx, ny, nz = cx + off[1], cy + off[2], cz + off[3]
            if _vxIsSolid(nx, ny, nz) then continue end
            if not _vxNoCorner(cx, cy, cz, off) then continue end
            local tg = cg + off[4]
            local ex = nodes[nk]
            if not ex or tg < ex.g then
                if ex then
                    ex.g, ex.parent, ex.x, ex.y, ex.z = tg, curKey, nx, ny, nz
                else
                    nodes[nk] = { x = nx, y = ny, z = nz, g = tg, parent = curKey }
                end
                _vxPush(heap, tg + _vxHeurW * Heur(nx, ny, nz), nk)
            end
        end
    end
    return nil
end

local function _vxSimplify(path, radius, height)
    if not path or #path < 3 then return path end
    local out = { path[1] }
    local anchor = 1
    local i = 2
    while i <= #path do
        if not _vxSegClear(path[anchor], path[i + 1] or path[i], radius, height, false) then
            out[#out + 1] = path[i]
            anchor = i
        end
        i += 1
    end
    out[#out + 1] = path[#path]
    return out
end

voxelRoute = function(fromPos, toPos)
    local char = LP.Character
    local _flt = char and { char } or {}
    for _, cl in ipairs(_OTHER_CLONES) do _flt[#_flt + 1] = cl end
    _vxOverlap.FilterDescendantsInstances = _flt
    _vxCast.FilterDescendantsInstances = _flt

    local sz      = tonumber(_G.TT3PathCell)   or 4
    local inflate = tonumber(_G.TT3PathRadius) or 2.5
    local height  = tonumber(_G.TT3PathHeight) or 5
    local pad     = tonumber(_G.TT3PathPad)    or 40

    _vxSz, _vxInflate, _vxHeight = sz, inflate, height
    table.clear(_vxSolid)

    local mn = Vector3.new(_vxMin(fromPos.X, toPos.X), _vxMin(fromPos.Y, toPos.Y), _vxMin(fromPos.Z, toPos.Z)) - Vector3.new(pad, pad, pad)
    local mx = Vector3.new(_vxMax(fromPos.X, toPos.X), _vxMax(fromPos.Y, toPos.Y), _vxMax(fromPos.Z, toPos.Z)) + Vector3.new(pad, pad, pad)
    _vxOrigin = mn
    local size = mx - mn
    _vxDimX = _vxFloor(size.X / sz) + 1
    _vxDimY = _vxFloor(size.Y / sz) + 1
    _vxDimZ = _vxFloor(size.Z / sz) + 1
    if _vxDimX * _vxDimY * _vxDimZ > 200000 then return nil end

    local startCell = {
        x = _vxFloor((fromPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((fromPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((fromPos.Z - _vxOrigin.Z) / sz),
    }
    local goalCell = {
        x = _vxFloor((toPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((toPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((toPos.Z - _vxOrigin.Z) / sz),
    }

    local path = _vxAStar(sz, startCell, goalCell, fromPos, toPos)
    if not path then return nil end
    path = _vxSimplify(path, inflate, height)
    if not path or #path == 0 then return nil end

    local route = {}
    for idx = 2, #path do route[#route + 1] = path[idx] end
    if #route == 0 or (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return route
end

end

_G.TT3VoxelRoute = voxelRoute

-- =====================================================================
-- CONTOURNEMENT DE LA ZONE CENTRALE (portage de TT3)
-- TT3, ligne 6394: "A base straight across the map means the flight line
-- crosses the center road. Flying straight over it makes the server rewind
-- us to mid-path, so detour around the center first."
-- Traverser la bande centrale en diagonale fait rembobiner le serveur en
-- plein vol. On detecte le cas et on contourne par une des 4 allees.
-- =====================================================================
local _MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
local _BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
local _BYPASS_X_WEST,  _BYPASS_X_EAST  = -525, -295

local function _inCenterZone(x, z)
    return x >= _MAP_CENTER.minX and x <= _MAP_CENTER.maxX
       and z >= _MAP_CENTER.minZ and z <= _MAP_CENTER.maxZ
end

-- echantillonne le segment en 10 points: une diagonale peut traverser le
-- centre sans que ni le depart ni l arrivee n y soient
local function _segmentCrossesCenter(a, b)
    if _inCenterZone(a.X, a.Z) or _inCenterZone(b.X, b.Z) then return true end
    for i = 1, 10 do
        local t = i / 11
        if _inCenterZone(a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t) then return true end
    end
    return false
end

-- teste les 4 contournements (nord / sud / ouest / est), ne garde que ceux
-- dont les 3 troncons sont degages, et renvoie le PLUS COURT
local function _findBestCenterDetour(fromPos, toPos, y)
    local candidates = {
        { Vector3.new(fromPos.X, y, _BYPASS_Z_NORTH), Vector3.new(toPos.X, y, _BYPASS_Z_NORTH) },
        { Vector3.new(fromPos.X, y, _BYPASS_Z_SOUTH), Vector3.new(toPos.X, y, _BYPASS_Z_SOUTH) },
        { Vector3.new(_BYPASS_X_WEST, y, fromPos.Z), Vector3.new(_BYPASS_X_WEST, y, toPos.Z) },
        { Vector3.new(_BYPASS_X_EAST, y, fromPos.Z), Vector3.new(_BYPASS_X_EAST, y, toPos.Z) },
    }
    local best, bestLen = nil, math.huge
    for _, pair in ipairs(candidates) do
        local w1, w2 = pair[1], pair[2]
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.TT3SegmentCrossesCenter = _segmentCrossesCenter
_G.TT3FindCenterDetour     = _findBestCenterDetour

-- =====================================================================
-- CONTOURNEMENT DES BASES DE LA MEME RANGEE
-- Aller 2 ou 3 bases plus loin sur la meme rangee = la ligne droite rase
-- les facades intermediaires. Meme structure que le contournement du
-- centre: on sort dans une allee parallele a la rangee, on la longe, on
-- rentre. Chaque troncon est valide par _clearWide, sinon on abandonne.
-- Reglable: _G.TT3RowBoxX / _G.TT3RowBoxZ (emprise consideree comme
-- "dans la base") et _G.TT3RowLane (ecart de l allee).
-- =====================================================================
local function _rowBoxX() return tonumber(_G.TT3RowBoxX) or 26 end
local function _rowBoxZ() return tonumber(_G.TT3RowBoxZ) or 30 end
local function _rowLane() return tonumber(_G.TT3RowLane) or 30 end

-- base la plus proche d un point (index dans BASES_LOW), si a portee
local function _nearestBase(p)
    local bi, bd = nil, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
        if d < bd then bd = d; bi = i end
    end
    if bd > 70 * 70 then return nil end
    return bi
end

-- le segment traverse-t-il une base AUTRE que celle de depart et d arrivee ?
local function _segmentHitsOtherBase(a, b, ignA, ignB)
    local hx, hz = _rowBoxX(), _rowBoxZ()
    for i = 0, 24 do
        local t = i / 24
        local px = a.X + (b.X - a.X) * t
        local pz = a.Z + (b.Z - a.Z) * t
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local bs = BASES_LOW[k]
                if math.abs(px - bs.X) <= hx and math.abs(pz - bs.Z) <= hz then
                    return true
                end
            end
        end
    end
    return false
end

local function _findRowDetour(fromPos, toPos, y)
    local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
    if not _segmentHitsOtherBase(fromPos, toPos, iFrom, iTo) then return nil end

    -- colonne de la base visee: l allee se place a gauche ou a droite d elle
    local colX = BASES_LOW[iTo or 1].X
    local off  = _rowLane()
    local lanes = {}
    -- cote exterieur d abord (hors zone centrale, c est la ou le jeu place
    -- deja ses points d entree lateraux)
    local outer = (colX < COLUMN_SPLIT_X) and (colX - off) or (colX + off)
    lanes[#lanes + 1] = outer
    -- cote interieur seulement s il ne tombe pas dans la zone centrale,
    -- sinon on declencherait le rewind serveur qu on vient d eviter
    local inner = (colX < COLUMN_SPLIT_X) and (colX + off) or (colX - off)
    if not _inCenterZone(inner, (fromPos.Z + toPos.Z) * 0.5) then
        lanes[#lanes + 1] = inner
    end

    local best, bestLen = nil, math.huge
    for _, laneX in ipairs(lanes) do
        local w1 = Vector3.new(laneX, y, fromPos.Z)
        local w2 = Vector3.new(laneX, y, toPos.Z)
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos)
           and not _segmentHitsOtherBase(w1, w2, iFrom, iTo) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.TT3FindRowDetour = _findRowDetour

-- Span centre + hop leger: UNIQUEMENT si trajet passe au milieu
local function _centerSpanT(a, b)
    local t0, t1 = nil, nil
    for i = 0, 40 do
        local t = i / 40
        local x = a.X + (b.X - a.X) * t
        local z = a.Z + (b.Z - a.Z) * t
        if _inCenterZone(x, z) then
            if not t0 then t0 = t end
            t1 = t
        end
    end
    return t0, t1
end

local function _hitSpanT(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    rp.FilterDescendantsInstances = skip
    local t0, t1 = nil, nil
    local n, edge = 28, 0.1
    for i = 0, n - 1 do
        local tA, tB = i / n, (i + 1) / n
        if tB > edge and tA < (1 - edge) then
            local pA, pB = a:Lerp(b, tA), a:Lerp(b, tB)
            local d = pB - pA
            if d.Magnitude > 0.05 then
                local hit = workspace:Raycast(pA, d, rp)
                if hit and _blocksWide(hit.Instance) then
                    if not t0 then t0 = math.max(tA, edge) end
                    t1 = math.min(tB, 1 - edge)
                end
            end
        end
    end
    return t0, t1
end

local function _localHopOver(fromPos, toPos, tBlock0, tBlock1)
    local lift = tonumber(_G.TT3CenterFly) or 10
    local pad = tonumber(_G.TT3HopPad) or 0.12
    local t0 = math.clamp(tBlock0 or 0.35, 0.08, 0.85)
    local t1 = math.clamp(tBlock1 or 0.65, t0 + 0.04, 0.92)
    local tRise0 = math.max(0.04, t0 - pad)
    local tRise1, tFall0, tFall1 = t0, t1, math.min(0.94, t1 + pad)
    local function at(t, yAdd)
        local p = fromPos:Lerp(toPos, t)
        local gy = fromPos.Y + (toPos.Y - fromPos.Y) * t
        return Vector3.new(p.X, gy + (yAdd or 0), p.Z)
    end
    local route = { fromPos }
    local function push(p)
        if (route[#route] - p).Magnitude > 0.6 then route[#route + 1] = p end
    end
    push(at(tRise0, 0))
    push(at((tRise0 + tRise1) * 0.5, lift * 0.5))
    push(at(tRise1, lift))
    push(at((tRise1 + tFall0) * 0.5, lift))
    push(at(tFall0, lift))
    push(at((tFall0 + tFall1) * 0.5, lift * 0.5))
    push(at(tFall1, 0))
    push(toPos)
    return route
end

function computeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
    local _ = maxLift

    -- PRIORITE: si la ligne droite est vraiment degagee -> DROITE, zero detour.
    -- (_findRowDetour se basait sur des boites abstraites de bases et pouvait
    -- zigzaguer vers le middle meme quand le sol etait libre.)
    if _clearWide(fromPos, toPos) then return { toPos } end

    -- === Si JE PASSE AU MILIEU et qu'un obstacle DU MILIEU bloque: leger hop. ===
    if _segmentCrossesCenter(fromPos, toPos) then
        local c0, c1 = _centerSpanT(fromPos, toPos)
        local h0, h1 = _hitSpanT(fromPos, toPos)
        if c0 and h0 and h1 and h1 >= c0 and h0 <= (c1 or 1) then
            local t0 = math.max(h0, c0)
            local t1 = math.min(h1, c1 or h1)
            if (t1 - t0) > 0.02 then
                return _localHopOver(fromPos, toPos, t0, t1)
            end
        end
    end

    -- === pathfinding d'origine (seulement si droite bloquee) ===
    local centerPatch = nil
    local rowPatch = _findRowDetour(fromPos, toPos, fromPos.Y)
    if rowPatch and #rowPatch > 0 then
        fromPos = rowPatch[#rowPatch]
    end

    local function _withPatch(route)
        if (not centerPatch or #centerPatch == 0)
           and (not rowPatch or #rowPatch == 0) then return route end
        local merged = {}
        if centerPatch then for _, p in ipairs(centerPatch) do merged[#merged + 1] = p end end
        if rowPatch    then for _, p in ipairs(rowPatch)    do merged[#merged + 1] = p end end
        for _, p in ipairs(route) do merged[#merged + 1] = p end
        return merged
    end

    if _clearWide(fromPos, toPos) then return _withPatch({ toPos }) end

    if preferCrest then
        local cruiseY = math.max(fromPos.Y, toPos.Y, 26) + 12
        local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
        local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
        local crest = { fromPos, up, over, toPos }
        local ok = true
        for i = 1, #crest - 1 do
            local a, b = crest[i], crest[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == #crest - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then ok = false; break end
            end
        end
        if ok then return _withPatch(crest) end
    end

    do
        local vr = voxelRoute(fromPos, toPos)
        if vr and #vr > 0 then return _withPatch(vr) end
    end

    local entry = facingDir and (toPos - facingDir * 14) or toPos

    local best, bestLen = nil, math.huge
    local function consider(pts)
        if not pts or #pts < 2 then return end
        local n = #pts
        for i = 1, n - 1 do
            local a, b = pts[i], pts[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == n - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then return end
            end
        end
        local pulled = _pullWide(pts)
        local L = _len(pulled)
        if L < bestLen then best, bestLen = pulled, L end
    end

    do
        local dirF = Vector3.new(entry.X - fromPos.X, 0, entry.Z - fromPos.Z)
        if dirF.Magnitude > 0.1 then
            dirF = dirF.Unit
            local perp = Vector3.new(-dirF.Z, 0, dirF.X)
            local midBase = (fromPos + entry) * 0.5
            for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
                consider({ fromPos, midBase + perp * off, entry })
                consider({ fromPos, fromPos + perp * off, entry + perp * off, entry })
            end
        end
    end

    local navRaw
    if not best then
        local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
        local path = PathfindingService:CreatePath({
            AgentRadius = 16, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
        })
        local FLOAT = 5
        local nav = { fromPos }
        local ok = pcall(function()
            path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local last = fromPos
            for _, wp in ipairs(path:GetWaypoints()) do
                if (wp.Position - last).Magnitude >= 8 then
                    nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                    last = wp.Position
                end
            end
        end
        nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
        nav = _pushOffWalls(nav)
        navRaw = nav
        consider(nav)
    end

    local route = best
    if not route and _clear(fromPos, toPos) then route = { toPos } end
    if not route and navRaw then route = _pullWide(navRaw) end
    if not route then route = { toPos } end
    if (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return _withPatch(route)
end
end

local function equipTool(name)
    local char = LP.Character
    if not char or char:FindFirstChild(name) then return char ~= nil end
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return false end
    local tool = bp:FindFirstChild(name)
    if tool and tool:IsA("Tool") then tool.Parent = char; return true end
    return false
end

local function unequipAll()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
end

local function doClone()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end

    local cloner = (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Quantum Cloner"))
                or char:FindFirstChild("Quantum Cloner")
    if not cloner then return false end

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    pcall(function() hum:UnequipTools() end)
    task.wait()
    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    local pg = LP:FindFirstChild("PlayerGui")
    local tf = pg and pg:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")

    _G.isCloning = true
    pcall(function() cloner:Activate() end)
    task.wait(0.05)

    local fired = false
    if tb and type(firesignal) == "function" then
        pcall(function() tb.Visible = true end)
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        fired = true
    else
        -- fallback: remotes directs (ancienne methode invisible)
        local useItem = getRemote("RemoteEvent", "UseItem")
        local onTel   = getRemote("RemoteEvent", "QuantumCloner/OnTeleport")
        if useItem and onTel then
            pcall(function() useItem:FireServer() end)
            task.wait(0.05)
            pcall(function() onTel:FireServer() end)
            fired = true
        end
    end

    task.delay(0.55, function() _G.isCloning = false end)
    return fired
end

local _TweenTS = game:GetService("TweenService")
local function TT3Tween(rootPart, hum, targetPos, lookDir)
    if not rootPart or not rootPart.Parent then return end
    local STEP = 20
    local speed = (_G.TPTravelSpeed or 100)
    local hasLook = lookDir ~= nil and lookDir.Magnitude > 0.001
    local prevAnchored = rootPart.Anchored
    rootPart.AssemblyLinearVelocity = Vector3.zero
    rootPart.AssemblyAngularVelocity = Vector3.zero
    pcall(function() rootPart.Anchored = true end)
    local deadline = os.clock() + 12
    while rootPart and rootPart.Parent and os.clock() < deadline do
        local pos = rootPart.Position
        local toTarget = targetPos - pos
        local d = toTarget.Magnitude
        if d < 0.5 then break end
        local stepDist = math.min(STEP, d)
        local stepGoal = pos + toTarget.Unit * stepDist
        local stepCF
        if hasLook then
            stepCF = CFrame.lookAt(stepGoal, stepGoal + lookDir)
        else
            stepCF = (rootPart.CFrame - rootPart.CFrame.Position) + stepGoal
        end
        local dur = math.clamp(stepDist / speed, 0.02, 1)
        local tw = _TweenTS:Create(rootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = stepCF })
        tw:Play()
        tw.Completed:Wait()
    end
    pcall(function() rootPart.Anchored = prevAnchored end)
    if rootPart and rootPart.Parent then rootPart.AssemblyLinearVelocity = Vector3.zero end
end

-- Plaque ONE-WAY (portee de la reference): collision UNE direction -> solide seulement
-- quand tu es AU-DESSUS et que tu ne montes pas; traversable sinon. Evite le conflit
-- avec le sol du plot (une plaque CanCollide=true classique provoquait un lagback floor 1).
local function _makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = RunService.Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                plat.CanCollide = (currentY > plat.Position.Y + 0.1)
            end
            lastY = currentY
        end
    end)
end

-- Floor-2-depuis-floor-1 ON par defaut : goToBrainrot snap DIRECT sous le brainrot +
-- plaque one-way invisible (pas de phase de montee). Passe a false (console) pour le
-- snap sec a 14.5 sans plaque.
if _G.TT3ApproachF2From1 == nil then _G.TT3ApproachF2From1 = true end

-- CLONE -> BRAINROT: TOUS les etages (F1 inclus) = snap CFrame (tp cframe, PAS
-- de velocity -> pas de lagback), suivi d un settle qui verrouille sur le pet.
-- Le slot (deja passe par l appelant) decide l etage: 1-10 = F1, 11-18 = F2,
-- 19+ = F3 -- pas seulement le Y du mesh (sinon un brainrot F1 "haut" restait en CFrame).
local function goToBrainrot(petPos, slot, allowWhileCarrying)
    if not petPos then return end
    local function _shouldStop()
        return _G.TT3TPStop or (LP:GetAttribute("Stealing") and allowWhileCarrying ~= true)
    end
    local char, hrp
    local _t0 = os.clock()
    repeat
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 2
    if not hrp then return end
    pcall(function() hrp.Anchored = false end)
    equipCarpet()

    local h = petPos.Y
    local _slot = tonumber(slot)
    local targetY = hrp.Position.Y
    local _isFloor1 = false
    if _slot and _slot >= 1 and _slot < 11 then
        targetY = -4
        _isFloor1 = true
    elseif _slot and _slot >= 19 then
        targetY = 21
    elseif _slot and _slot >= 11 then
        targetY = 14.5
    elseif h > 23.15 then
        targetY = 21
    elseif h >= 11 and h <= 23.15 then
        targetY = 14.5
    elseif h >= -6.9 and h <= 8.9 then
        targetY = -4
        _isFloor1 = true
    end
    -- F2-DEPUIS-F1 (ON par defaut): snap sous le pet a petY-8 + plaque one-way
    local _f2FromF1 = (not _isFloor1) and _G.TT3ApproachF2From1
        and ((_slot and _slot >= 11 and _slot < 19) or (h > 10 and h <= 23.15))
    if _f2FromF1 then targetY = h - 8 end
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)
    -- Plaques: floor 3 = solide 3x3 ; F2-depuis-F1 = one-way 6x6
    if (not _isFloor1) and ((_slot and _slot >= 19) or (not _slot and h > 23.15)) then
        local _plat = Instance.new("Part")
        _plat.Name = "TT3HubTempPlatform"
        _plat.Size = Vector3.new(3, 1, 3)
        _plat.Position = _to - Vector3.new(0, 5, 0)
        _plat.Anchored = true
        _plat.CanCollide = true
        _plat.Transparency = 1
        _plat.Material = Enum.Material.SmoothPlastic
        _plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < 20 do
                if _shouldStop() then break end
                task.wait(0.1)
            end
            if _plat and _plat.Parent then _plat:Destroy() end
        end)
    elseif _f2FromF1 then
        local plat = Instance.new("Part")
        plat.Name = "XiTempPlatform"
        plat.Size = Vector3.new(6, 1.5, 6)
        plat.Position = _to - Vector3.new(0, 3, 0)
        plat.Color = Color3.fromRGB(240, 240, 240)
        plat.Material = Enum.Material.Neon
        plat.Anchored = true
        plat.CanCollide = false; pcall(_makeOneWay, plat)
        plat.Transparency = 1
        plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < 20 do
                if _shouldStop() then break end
                task.wait(0.1)
            end
            if plat and plat.Parent then plat:Destroy() end
        end)
    end
    if not _shouldStop() then
        -- tous etages (F1 inclus): snap CFrame -- PAS de velocity -> pas de lagback
        for _i = 1, 6 do
            if _shouldStop() then break end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if _i == 1 or (hrp.Position - _to).Magnitude > 2 then
                hrp.CFrame = CFrame.new(_to)
            end
            task.wait(0.05)
        end
    end
    -- Settle post-GTB (invisible 3): lock sur le pet apres le snap, sans retoucher le delay clone.
    do
        local goal = _to
        local stable, t0 = 0, os.clock()
        while os.clock() - t0 < 2.5 do
            if not hrp or not hrp.Parent then break end
            if _shouldStop() then break end
            equipCarpet()
            local diff = goal - hrp.Position
            local flat = Vector3.new(diff.X, 0, diff.Z).Magnitude
            local dy   = math.abs(diff.Y)
            if flat <= 2.5 and dy <= 3 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                stable = stable + 1
                if stable >= 5 then break end
            else
                stable = 0
                if diff.Y > 8 then
                    local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    if _hum then
                        local st = _hum:GetState()
                        if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                            pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                            pcall(function() _hum.Jump = true end)
                        end
                    end
                end
                local spd = math.clamp(diff.Magnitude * 5, 40, 250)
                hrp.Velocity = diff.Unit * spd
            end
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local _Stats = game:GetService("Stats")
local function _pingMs()
    local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
    if ok and type(p) == "number" and p > 0 then return p end
    local ok2, p2 = pcall(function()
        return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(p2) == "number" and p2 > 0 then return p2 end
    return 0
end
_G.TT3PingMs = _pingMs
local function _pingAdjustSpeed(spd)
    local thresh = tonumber(_G.TT3PingThresh) or 170
    local capped = tonumber(_G.TT3HighPingSpeed) or 400
    if _pingMs() >= thresh and spd > capped then return capped end
    return spd
end

local function _inVoid(hrp)
    if not hrp or not hrp.Parent then return true end
    local voidY = tonumber(_G.TT3VoidY) or -50
    return hrp.Position.Y < voidY
end
local function _waitOutOfVoid(timeout)
    local t0 = os.clock()
    local good = 0
    while os.clock() - t0 < (timeout or 12) do
        if _G.TT3TPStop then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent and not _inVoid(hrp) and math.abs(hrp.AssemblyLinearVelocity.Y) < 12 then
            good += 1
            if good >= 4 then return true end
        else
            good = 0
        end
        RunService.Heartbeat:Wait()
    end
    return false
end

do
    local lastSafe = nil
    local recovering = false
    local _lastVoidCheck = 0
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if _G.TT3VoidRecover == false then return end
        local now = os.clock()
        if now - _lastVoidCheck < 0.1 then return end
        _lastVoidCheck = now
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local voidY = tonumber(_G.TT3VoidY) or -50
        if hrp.Position.Y >= voidY then
            if math.abs(hrp.AssemblyLinearVelocity.Y) < 40 then
                lastSafe = hrp.Position
            end
            return
        end
        if recovering or not lastSafe then return end
        recovering = true
        task.spawn(function()
            local delay = tonumber(_G.TT3VoidRecoverDelay) or 1
            task.wait(delay)
            local vy = tonumber(_G.TT3VoidY) or -50
            local tries = 0
            while tries < 80 do
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if not h or not h.Parent then break end
                if h.Position.Y >= vy and math.abs(h.AssemblyLinearVelocity.Y) < 18 then
                    break
                end
                if lastSafe then
                    pcall(function()
                        h.AssemblyLinearVelocity = Vector3.zero
                        h.AssemblyAngularVelocity = Vector3.zero
                        h.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
                    end)
                end
                tries = tries + 1
                RunService.Heartbeat:Wait()
            end
            recovering = false
        end)
    end))
end

local isTeleporting = false

local function cframeStepThrough(hrp, waypoints, stepSize)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    stepSize = stepSize or 24
    local lockY = hrp.Position.Y
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local deadline = os.clock() + 10
    local _lastFire = 0
    while hrp and hrp.Parent and os.clock() < deadline do
        if _G.TT3TPStop then break end
        do
            local char = hrp.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and char and not char:FindFirstChild("Grapple Hook") then
                local g = findGrapple()
                if g then pcall(function() hum:EquipTool(g) end) end
            end
            if os.clock() - _lastFire > 0.3 then
                _lastFire = os.clock()
                if char and char:FindFirstChild("Grapple Hook") then
                    _G.XenFireGrapple2()
                end
            end
        end
        local target = waypoints[wpIdx]
        local flat = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
        local mag = flat.Magnitude
        if mag < 2 then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then break end
            RunService.Heartbeat:Wait()
        else
            local hop = math.min(stepSize, mag)
            local nextPos = hrp.Position + flat.Unit * hop
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, lockY, nextPos.Z)) * CFrame.Angles(0, y, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(hop / math.clamp(tonumber(_G.TT3CFrameSpeed) or 450, 60, 900))
        end
    end
    do
        local hum = hrp and hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
        task.wait(0.05)
        equipCarpet()
    end
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

-- Hide temporary map machines/shops from the local TP route and collision solver.
-- Original properties are restored by the wrapper even when the TP exits early/errors.
local _tpObstaclePassActive = false
local _tpObstacleSnapshots = {}
local _tpObstacleAddedConnection
local _tpObstacleWords = {"machine", "shop", "store", "market", "boutique", "loja", "vendor"}
local function _tpObstacleNameMatches(name)
    local flat = tostring(name or ""):lower():gsub("[^%w]", "")
    for _, word in ipairs(_tpObstacleWords) do
        if flat:find(word, 1, true) then return true end
    end
    return false
end
local function _tpIsObstaclePart(part)
    if not part or not part:IsA("BasePart") then return false end
    local character = LP.Character
    if character and (part == character or part:IsDescendantOf(character)) then return false end
    local node = part
    while node and node ~= workspace do
        -- Do not hide brainrots/models inside the podium contents.
        if node.Name == "AnimalPodiums" then return false end
        node = node.Parent
    end
    node = part
    while node and node ~= workspace do
        if _tpObstacleNameMatches(node.Name) then return true end
        node = node.Parent
    end
    return false
end
local function _tpHideObstaclePart(part)
    if not _tpObstaclePassActive or not _tpIsObstaclePart(part) then return end
    if not _tpObstacleSnapshots[part] then
        local snapshot = {}
        pcall(function() snapshot.localTransparency = part.LocalTransparencyModifier end)
        pcall(function() snapshot.canCollide = part.CanCollide end)
        pcall(function() snapshot.canQuery = part.CanQuery end)
        pcall(function() snapshot.canTouch = part.CanTouch end)
        _tpObstacleSnapshots[part] = snapshot
    end
    pcall(function() part.LocalTransparencyModifier = 1 end)
    pcall(function() part.CanCollide = false end)
    pcall(function() part.CanQuery = false end)
    pcall(function() part.CanTouch = false end)
end
local function _tpBeginObstaclePassage()
    if _tpObstaclePassActive then return end
    _tpObstaclePassActive = true
    _G.TT3TPIgnoringMachinesStores = true
    local ok, descendants = pcall(function() return workspace:GetDescendants() end)
    if ok and type(descendants) == "table" then
        for _, inst in ipairs(descendants) do
            if inst:IsA("BasePart") then _tpHideObstaclePart(inst) end
        end
    end
    _tpObstacleAddedConnection = workspace.DescendantAdded:Connect(function(inst)
        task.defer(function()
            if _tpObstaclePassActive and inst:IsA("BasePart") then _tpHideObstaclePart(inst) end
        end)
    end)
end
local function _tpEndObstaclePassage()
    _tpObstaclePassActive = false
    _G.TT3TPIgnoringMachinesStores = false
    if _tpObstacleAddedConnection then
        pcall(function() _tpObstacleAddedConnection:Disconnect() end)
        _tpObstacleAddedConnection = nil
    end
    for part, snapshot in pairs(_tpObstacleSnapshots) do
        if part and part.Parent then
            if snapshot.localTransparency ~= nil then pcall(function() part.LocalTransparencyModifier = snapshot.localTransparency end) end
            if snapshot.canCollide ~= nil then pcall(function() part.CanCollide = snapshot.canCollide end) end
            if snapshot.canQuery ~= nil then pcall(function() part.CanQuery = snapshot.canQuery end) end
            if snapshot.canTouch ~= nil then pcall(function() part.CanTouch = snapshot.canTouch end) end
        end
        _tpObstacleSnapshots[part] = nil
    end
end

local function _rememberLastBrainrot(pet, root)
    if not pet or typeof(pet.position) ~= "Vector3" then return end
    local anchor = root and root.Parent and root.Position or pet.position
    _G.TT3LastBrainrotTP = {
        name = pet.name,
        index = pet.index,
        position = pet.position,
        slot = pet.slot,
        plot = pet.plot,
        uid = _petUid(pet),
        anchor = anchor,
        savedAt = os.clock(),
    }
end

local function _doVelocityTPCore(forceGrapple)
    if isTeleporting then return end
    isTeleporting = true
    _G.TT3TPStop = false
    clearViz()
    if not NetModule then pcall(loadNet) end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then isTeleporting = false; return end

    if _inVoid(hrp) or hrp.AssemblyLinearVelocity.Y < -40 then
        _waitOutOfVoid(12)
        if _G.TT3TPStop then isTeleporting = false; return end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then isTeleporting = false; return end
    end

    local allPets = scanForTP()
    if #allPets == 0 then
        local _t0 = os.clock()
        while #allPets == 0 and os.clock() - _t0 < 4 do
            task.wait(0.05)
            allPets = scanForTP()
        end
    end
    if #allPets == 0 then isTeleporting = false; return end

    local pet
    if type(_G.TT3StealTargetUID) == "string" and _G.TT3StealTargetUID ~= "" then
        pet = _findStealTarget(allPets)
        if not pet then isTeleporting = false; return end
    else
        -- PRIORITY d abord (plus petit rang _pri), SINON le plus gros MPS (highest).
        -- Independant du mode de steal / de l ordre du scan.
        local prio, best
        for _, p in ipairs(allPets) do
            if not p.conveyor then
                if p._pri and (not prio or p._pri < prio._pri) then prio = p end
                if not best or (p.mps or 0) > (best.mps or 0) then best = p end
            end
        end
        pet = prio or best or allPets[1]
    end
    local petPos = pet.position
    local petName = pet.name

    _G.TT3StealHold = true
    task.delay(15, function() _G.TT3StealHold = false end)

    local adjY = petPos.Y
    if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
    local coordTable = adjY > 23.15 and UPPER or LOWER

    -- Neegy: classify whether the route is straight before selecting its speed.
    local function _isStraightRoute(fromPos, route)
        if not route or #route <= 1 then return true end
        local turns, lastDir, prev = 0, nil, fromPos
        for _, wp in ipairs(route) do
            local seg = wp - prev
            if seg.Magnitude > 1 then
                local dir = seg.Unit
                if lastDir and dir:Dot(lastDir) < 0.94 then turns = turns + 1 end
                lastDir = dir
            end
            prev = wp
        end
        return turns <= (tonumber(_G.TT3StraightMaxTurns) or 1)
    end

    if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
        carpetEngage(forceGrapple)
        vZero(hrp)
        local _to = Vector3.new(petPos.X, -4, petPos.Z)
        local route = computeRoute(hrp.Position, _to, nil)
        if not route or #route == 0 then route = { _to } end
        local _straight = _isStraightRoute(hrp.Position, route)
        local _obSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
        if _straight then
            _obSpeed = math.clamp(tonumber(_G.TT3StraightSpeed) or 300, 100, 500)
        end
        do
            local _len, _prev = 0, hrp.Position
            for _, wp in ipairs(route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
            if _len < 100 then
                _obSpeed = math.clamp(tonumber(_G.TT3CloseSpeed) or 80, 20, 400)
            end
        end
        _obSpeed = _pingAdjustSpeed(_obSpeed)
        -- 1er etage: velocity (pas CFrame)
        velMoveThrough(hrp, route, _obSpeed, true, true)
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        _G.TT3StealHold = false
        isTeleporting = false
        if _G.TT3TPStop then return end
        _rememberLastBrainrot(pet, hrp)
        return
    end

    local closestData, skyKey = findClosest(petPos, coordTable)
    if not closestData or not skyKey then _G.TT3StealHold = false; isTeleporting = false; return end

    local destPos = closestData.coord

    local _carpet = carpetEngage(forceGrapple)
    vZero(hrp)

    -- FRONT/SIDE routing copied from Neegy's active doVelocityTP logic:
    -- compare the FRONT candidate with valid side slots, while avoiding a
    -- front approach that would cross a blocked row from too far away.
    local facingDir = closestData.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
    local _frontApproach = false
    do
        local isUpper = (coordTable == UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrp.Position.Z)
        local bestCoord, bestFace = frontCoord, frontFace
        local bestDist = (hrp.Position - frontCoord).Magnitude
        local pickedFront = true

        local base = BASES_LOW[idx]
        local isWest = idx <= 4
        local rowBlocked = false
        local dx, dz = hrp.Position.X - base.X, hrp.Position.Z - base.Z
        local distToBase = math.sqrt(dx * dx + dz * dz)
        local sideRange = tonumber(_G.TT3SideTPRange) or 100
        if _G.TT3PreferFrontOnRow ~= false and distToBase > sideRange then
            for i = 1, 8 do
                if i ~= idx and (i <= 4) == isWest then
                    local bz = BASES_LOW[i].Z
                    if (bz - hrp.Position.Z) * (bz - base.Z) < 0 then
                        rowBlocked = true
                        break
                    end
                end
            end
        end

        if not rowBlocked then
            for _, candidate in ipairs(plotSides(coordTable, idx)) do
                local d = (hrp.Position - candidate.coord).Magnitude
                if d < bestDist then
                    bestDist = d
                    bestCoord = candidate.coord
                    bestFace = candidate.facing == "NORTH"
                        and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                    pickedFront = false
                end
            end
        end
        destPos = bestCoord
        facingDir = bestFace
        _frontApproach = pickedFront
        if _G.TT3TPDebug then
            warn(string.format("[TT3TP] Neegy route=%s base=%d rowBlocked=%s target=(%.1f, %.1f, %.1f)",
                _frontApproach and "FRONT" or "SIDE", idx, tostring(rowBlocked),
                destPos.X, destPos.Y, destPos.Z))
        end
    end

    if facingDir and facingDir.Magnitude > 0.1 then
        local axis = facingDir.Unit
        local toPlayer = hrp.Position - destPos
        local sign = (axis:Dot(toPlayer) >= 0) and 1 or -1
        destPos = destPos + axis * sign * (tonumber(_G.TT3CloneBackoff) or 0.5)
    end

    -- Neegy's route goes directly to the chosen FRONT/SIDE destination; the
    -- former Flower-only approach waypoint and two-segment route are removed.
    local _route = computeRoute(hrp.Position, destPos, facingDir, nil,
        _G.TT3CrestRoute == true or _G.MeerkoCrestRoute == true)
    if not _route or #_route == 0 then _route = { destPos } end

    local ASCEND_STEP = 10
    local _stepped = {}
    do
        local prev = hrp.Position
        for _, wp in ipairs(_route) do
            local dy = wp.Y - prev.Y
            if dy > ASCEND_STEP * 1.5 then
                local n = math.ceil(dy / ASCEND_STEP)
                for step = 1, n - 1 do
                    local t = step / n
                    _stepped[#_stepped + 1] = Vector3.new(
                        prev.X + (wp.X - prev.X) * t,
                        prev.Y + dy * t,
                        prev.Z + (wp.Z - prev.Z) * t
                    )
                end
            end
            _stepped[#_stepped + 1] = wp
            prev = wp
        end
    end

    local _mainSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
    local targetIdx = getClosestBaseIdx(petPos)
    local targetWest = targetIdx <= 4
    local playerWest = hrp.Position.X < COLUMN_SPLIT_X
    local crossSide = targetWest ~= playerWest
    local isLower = coordTable == LOWER
    local toTarget = petPos - hrp.Position
    local isBehind = toTarget.Magnitude > 0.001 and toTarget.Unit:Dot(hrp.CFrame.LookVector) < -0.3
    local problemTP = crossSide and _frontApproach and isLower and isBehind
    do
        local routeLength, prev = 0, hrp.Position
        for _, wp in ipairs(_route) do
            routeLength = routeLength + (wp - prev).Magnitude
            prev = wp
        end
        if routeLength < 100 then
            _mainSpeed = math.clamp(tonumber(_G.TT3CloseSpeed) or 80, 20, 400)
        end
        if problemTP and _G.TT3SlowCrossRow == true then
            _mainSpeed = math.clamp(tonumber(_G.TT3ProblemBaseSpeed) or 60, 20, 400)
        end
    end
    _mainSpeed = _pingAdjustSpeed(_mainSpeed)
    velMoveThrough(hrp, _stepped, _mainSpeed, true, true)
    if _G.TT3TPStop then
        if hrp and hrp.Parent then vZero(hrp) end
        _G.TT3StealHold = false
        isTeleporting = false
        return
    end

    -- Neegy's above-target correction and controlled run-in.
    do
        local above = destPos + Vector3.new(0, 16, 0)
        local t0, lastJump = os.clock(), 0
        while os.clock() - t0 < 1.5 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.TT3TPStop then break end
            equipCarpet()
            local d = above - hrp.Position
            local flat = Vector3.new(d.X, 0, d.Z).Magnitude
            if flat <= 3 and hrp.Position.Y >= destPos.Y then break end
            if d.Y > 3 and os.clock() - lastJump > 0.5 then
                local rootHum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if rootHum then
                    local state = rootHum:GetState()
                    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() rootHum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() rootHum.Jump = true end)
                        lastJump = os.clock()
                    end
                end
            end
            if d.Magnitude > 0.001 then
                _setFlightVel(hrp, d.Unit * math.min(math.max(d.Magnitude * 8, 55), 320))
            end
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

    do
        local runCap = _frontApproach and (tonumber(_G.TT3FrontRunIn) or 130) or 400
        local t0, bestMag, bestT, lastJump = os.clock(), math.huge, os.clock(), 0
        while os.clock() - t0 < 4 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.TT3TPStop then break end
            equipCarpet()
            local diff = destPos - hrp.Position
            local mag = diff.Magnitude
            if mag <= 3 then break end
            if mag < bestMag - 0.5 then
                bestMag, bestT = mag, os.clock()
            elseif os.clock() - bestT > 0.6 then
                break
            end
            if diff.Y > 3 and mag > 15 and os.clock() - lastJump > 0.5 then
                local rootHum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if rootHum then
                    local state = rootHum:GetState()
                    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() rootHum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() rootHum.Jump = true end)
                        lastJump = os.clock()
                    end
                end
            end
            _setFlightVel(hrp, diff.Unit * math.min(math.max(mag * 8, 55), runCap))
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

    -- Neegy's recovery reuses the planned path rather than the former Flower
    -- over-the-top three-stage fallback route.
    if hrp and hrp.Parent and not _G.TT3TPStop then
        local flatOff = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z).Magnitude
        if flatOff > 10 then
            if _G.TT3TPDebug then
                warn(string.format("[TT3TP] Neegy recovery: %.0f studs from target", flatOff))
            end
            local recoveryRoute = (#_stepped > 0) and _stepped or { destPos }
            velMoveThrough(hrp, recoveryRoute, _mainSpeed, true, true)
            if hrp and hrp.Parent then vZero(hrp) end
        end
    end

    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + facingDir)
    end
    vZero(hrp)

    local syncFrames = 3
    local syncConn
    syncConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent then syncConn:Disconnect(); return end
        syncFrames = syncFrames - 1
        hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        vZero(hrp)
        if syncFrames <= 0 then syncConn:Disconnect() end
    end))

    local landTries = tonumber(_G.TT3MaxLandTries) or 3
    local landGap = tonumber(_G.TT3LandCheckGap) or 0.03
    for _ = 1, landTries do
        task.wait(landGap)
        if hum.FloorMaterial ~= Enum.Material.Air then break end
    end

    do
        local stable, t0 = 0, os.clock()
        local stableCap = tonumber(_G.TT3StableWait) or 0.3
        while os.clock() - t0 < stableCap do
            if _G.TT3TPStop then break end
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not root.Parent then break end
            local flat = (Vector3.new(root.Position.X, 0, root.Position.Z)
                - Vector3.new(destPos.X, 0, destPos.Z)).Magnitude
            if flat <= 3.5 and math.abs(root.Position.Y - destPos.Y) <= 4 then
                stable = stable + 1
                if stable >= 2 then break end
            else
                stable = 0
                pcall(function() root.CFrame = CFrame.new(destPos, destPos + facingDir) end)
                vZero(root)
            end
            RunService.Heartbeat:Wait()
        end
    end

    local _ahrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local _clonePos = (_ahrp and _ahrp.Parent and _ahrp.Position) or destPos

    local _clonePlat = Instance.new("Part")
    _clonePlat.Name = "TT3HubClonePlatform"
    _clonePlat.Size = Vector3.new(12, 1, 12)
    _clonePlat.Position = Vector3.new(_clonePos.X, _clonePos.Y - 3, _clonePos.Z)
    _clonePlat.Anchored = true
    _clonePlat.CanCollide = true
    _clonePlat.Transparency = 1
    _clonePlat.Material = Enum.Material.SmoothPlastic
    _clonePlat.Parent = workspace

    if _ahrp and _ahrp.Parent then
        _ahrp.AssemblyLinearVelocity = Vector3.zero
        _ahrp.AssemblyAngularVelocity = Vector3.zero
    end

    local _preClonePos, _preCloneChar
    do
        _preCloneChar = LP.Character
        local _h = _preCloneChar and _preCloneChar:FindFirstChild("HumanoidRootPart")
        _preClonePos = _h and _h.Position or destPos
    end
    local _charAdded = false
    local _caConn = LP.CharacterAdded:Connect(function() _charAdded = true end)

    _G.TT3StealHold = false

    task.wait(tonumber(_G.TPCloneDelay) or tonumber(_G.LandingDelay) or 0.1)

    if facingDir and facingDir.Magnitude > 0.1 then
        local _pinHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _pinHum then pcall(function() _pinHum.AutoRotate = false end) end
        for _ = 1, 4 do
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not _h or not _h.Parent then break end
            pcall(function()
                _h.CFrame = CFrame.new(_h.Position, _h.Position + facingDir)
                _h.AssemblyLinearVelocity = Vector3.zero
                _h.AssemblyAngularVelocity = Vector3.zero
            end)
            RunService.Heartbeat:Wait()
        end
    end

    local _cloneOk = doClone()
    if _clonePlat then pcall(function() _clonePlat:Destroy() end); _clonePlat = nil end
    do
        local _t0 = os.clock()
        repeat
            if _charAdded then break end
            if LP.Character ~= _preCloneChar then break end
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if _h then
                local _dx = _h.Position.X - _preClonePos.X
                local _dz = _h.Position.Z - _preClonePos.Z
                if (_dx * _dx + _dz * _dz) > 4 then break end
            end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0 > 3
    end
    if _caConn then _caConn:Disconnect() end

    pcall(function()
        local _rh = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _rh then _rh.AutoRotate = true end
    end)

    goToBrainrot(petPos, pet and pet.slot)
    -- FIX "manual tp pas": remettre isTeleporting a false APRES le clone/goToBrainrot.
    -- Le reset promis par la NOTE plus haut ("jusqu APRES le clone, plus bas") MANQUAIT
    -- -> apres UN TP via le clone, isTeleporting restait TRUE et le Manual TP suivant
    -- sortait direct au "if isTeleporting then return". Ici = bien apres le clone.
    isTeleporting = false
    if _G.TT3TPStop then return end
    _rememberLastBrainrot(pet, LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if _G.TT3ArmSteal then pcall(_G.TT3ArmSteal, pet) end
end

local function doVelocityTP(forceGrapple)
    if isTeleporting then return end
    pcall(_tpBeginObstaclePassage)
    local ok, err = pcall(_doVelocityTPCore, forceGrapple)
    pcall(_tpEndObstaclePassage)
    if not ok then
        _G.TT3StealHold = false
        isTeleporting = false
        warn("[Flower Hub TP] Falha no TP: " .. tostring(err))
    end
end

local _manualTPBusy = false
local function manualFullTP()
    if _manualTPBusy or isTeleporting then return end
    _manualTPBusy = true
    local okAll = pcall(function()
        local function _allChannelsReady()
            local Plots = workspace:FindFirstChild("Plots")
            if not Plots then return false end
            local kids = Plots:GetChildren()
            if #kids == 0 then return false end
            for _, plot in ipairs(kids) do
                if not getPlotChannel(plot.Name) then return false end
            end
            return true
        end
        local _t0 = os.clock()
        local _lastN, _lastTop = -1, nil
        repeat
            if _allChannelsReady() then
                local ok, pets = pcall(scanForTP)
                if ok and pets and #pets > 0 then
                    local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
                    if #pets == _lastN and top == _lastTop then break end
                    _lastN, _lastTop = #pets, top
                    task.wait(0.15)
                else
                    task.wait(0.05)
                end
            else
                task.wait(0.05)
            end
        until os.clock() - _t0 > 12
        doVelocityTP()
    end)
    _manualTPBusy = false
    return okAll
end
_G.TT3StartSideTP = manualFullTP

do
    local returnBusy, lastReturnAt = false, 0
    local RAGDOLL_RETURN_STATES = {
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    local function _isFarFromLastTarget(record, root)
        if not record or not root then return false end
        local ref = record.anchor or record.position
        if typeof(ref) ~= "Vector3" then return false end
        return (root.Position - ref).Magnitude >= (tonumber(_G.TT3GoToBrainrotHitDistance) or 12)
    end
    local function _returnToLastBrainrotAfterHit()
        if _G.TT3GoToBrainrotHit ~= true or returnBusy then return end
        local record = _G.TT3LastBrainrotTP
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        -- Agenda primeiro e mede o afastamento depois do ragdoll; o impacto pode
        -- disparar o evento antes de o personagem ser arremessado para longe.
        if not record or not record.position or not root then return end
        if os.clock() - lastReturnAt < 1.5 then return end
        returnBusy = true
        lastReturnAt = os.clock()
        task.spawn(function()
            local started = os.clock()
            local ragdollCleared = false
            -- Espera o fim real do ragdoll do servidor antes de reposicionar.
            while os.clock() - started < 12 do
                if _G.TT3GoToBrainrotHit ~= true or _G.TT3TPStop then returnBusy = false; return end
                local ragEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
                local ragLeft = ragEnd - workspace:GetServerTimeNow()
                local currentHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                local state = currentHum and currentHum:GetState()
                local stillRagdolled = RAGDOLL_RETURN_STATES[state] == true
                if ragLeft <= 0 and not stillRagdolled then ragdollCleared = true; break end
                task.wait(0.05)
            end
            if not ragdollCleared then returnBusy = false; return end
            local waitTP = os.clock()
            while isTeleporting and os.clock() - waitTP < 8 do
                if _G.TT3GoToBrainrotHit ~= true or _G.TT3TPStop then returnBusy = false; return end
                task.wait(0.05)
            end
            if isTeleporting or _G.TT3TPStop or _G.TT3GoToBrainrotHit ~= true then
                returnBusy = false
                return
            end
            local currentChar = LP.Character
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if not currentRoot or not _isFarFromLastTarget(record, currentRoot) then
                returnBusy = false
                return
            end
            -- Reutiliza o mesmo ponto/andar do ultimo TP; não escolhe outro brainrot.
            pcall(goToBrainrot, record.position, record.slot, true)
            currentChar = LP.Character
            currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if currentRoot and currentRoot.Parent then record.anchor = currentRoot.Position end
            returnBusy = false
        end)
    end
    LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
        local ragEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        if ragEnd > workspace:GetServerTimeNow() then _returnToLastBrainrotAfterHit() end
    end)
    local function _bindHitStates(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum.StateChanged:Connect(function(_, newState)
            if RAGDOLL_RETURN_STATES[newState] then _returnToLastBrainrotAfterHit() end
        end)
    end
    if LP.Character then _bindHitStates(LP.Character) end
    LP.CharacterAdded:Connect(function(char) task.defer(_bindHitStates, char) end)
end

-- ============================================================
-- ETIQUETAS SOBRE OS JOGADORES: STEALING vermelho; BASE OWNER azul.
-- ============================================================
do
    local playerGui = LP:WaitForChild("PlayerGui")
    for _, child in ipairs(playerGui:GetChildren()) do
        if child:IsA("BillboardGui") and child.Name == "FlowerHubHeadStatus" then
            pcall(function() child:Destroy() end)
        end
    end
    local tags, ownerByPlot = {}, {}
    local plotBoundsCache = {}
    local oldSelfStatus = playerGui:FindFirstChild("FlowerHubSelfStatus")
    if oldSelfStatus then oldSelfStatus:Destroy() end
    local lastOwnerRefresh = 0
    local function getPlotFootprint(plot)
        if not plot then return nil, nil end
        local cached = plotBoundsCache[plot]
        if cached then return cached.cf, cached.size end
        local cf, size
        if plot:IsA("BasePart") then
            cf, size = plot.CFrame, plot.Size
        elseif plot:IsA("Model") then
            local ok, resultCF, resultSize = pcall(function() return plot:GetBoundingBox() end)
            if ok then cf, size = resultCF, resultSize end
        end
        if not cf or not size then
            local minX, minY, minZ = math.huge, math.huge, math.huge
            local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
            for _, part in ipairs(plot:GetDescendants()) do
                if part:IsA("BasePart") then
                    local half = part.Size * 0.5
                    for _, sx in ipairs({-1, 1}) do
                        for _, sy in ipairs({-1, 1}) do
                            for _, sz in ipairs({-1, 1}) do
                                local corner = part.CFrame:PointToWorldSpace(Vector3.new(half.X * sx, half.Y * sy, half.Z * sz))
                                minX, minY, minZ = math.min(minX, corner.X), math.min(minY, corner.Y), math.min(minZ, corner.Z)
                                maxX, maxY, maxZ = math.max(maxX, corner.X), math.max(maxY, corner.Y), math.max(maxZ, corner.Z)
                            end
                        end
                    end
                end
            end
            if minX ~= math.huge then
                cf = CFrame.new((minX + maxX) * 0.5, (minY + maxY) * 0.5, (minZ + maxZ) * 0.5)
                size = Vector3.new(maxX - minX, maxY - minY, maxZ - minZ)
            end
        end
        if cf and size then plotBoundsCache[plot] = {cf = cf, size = size} end
        return cf, size
    end
    local function refreshBaseOwners()
        local newOwners = {}
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local okChannel, channel = pcall(getPlotChannel, plot.Name)
                if okChannel and channel then
                    local okOwner, ownerValue = pcall(channelGet, channel, "Owner")
                    if okOwner and ownerValue then
                        local okPlayer, ownerPlayer = pcall(resolveOwner, ownerValue)
                        if okPlayer and ownerPlayer and ownerPlayer.UserId then
                            newOwners[plot.Name] = ownerPlayer.UserId
                        end
                    end
                end
            end
        end
        ownerByPlot = newOwners
        plotBoundsCache = {}
        lastOwnerRefresh = os.clock()
    end
    local function localBaseOwnerId()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local plots = workspace:FindFirstChild("Plots")
        if not root or not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local cf, size = getPlotFootprint(plot)
            if cf and size and size.X > 0 and size.Z > 0 then
                local pos = cf:PointToObjectSpace(root.Position)
                if math.abs(pos.X) <= size.X * 0.5 + 1.5
                    and math.abs(pos.Z) <= size.Z * 0.5 + 1.5 then
                    return ownerByPlot[plot.Name]
                end
            end
        end
        return nil
    end
    local function makeTag(player, head)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "FlowerHubHeadStatus"
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(132, 28)
        billboard.StudsOffset = Vector3.new(0, 2.8, 0)
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0
        billboard.MaxDistance = 180
        billboard.Parent = playerGui

        local pill = Instance.new("Frame", billboard)
        pill.Size = UDim2.fromScale(1, 1)
        pill.BackgroundColor3 = Color3.fromRGB(70, 15, 20)
        pill.BackgroundTransparency = 0.08
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = Color3.fromRGB(255, 65, 75)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.05

        local label = Instance.new("TextLabel", pill)
        label.Size = UDim2.new(1, -8, 1, 0)
        label.Position = UDim2.fromOffset(4, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Text = "STEALING"
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 2
        tags[player] = { gui = billboard, pill = pill, stroke = stroke, label = label }
        return tags[player]
    end
    local function updateTag(player, activeBaseOwnerId)
        local char = player.Character
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        local held = player:GetAttribute("StealingIndex")
        local localStealActive = player == LP and _G.TT3LocalAutoStealActive == true
        local stealing = player:GetAttribute("Stealing") == true
            or (held ~= nil and tostring(held) ~= "")
            or localStealActive
        local status = stealing and "STEALING" or (player.UserId == activeBaseOwnerId and "BASE OWNER" or nil)
        local tag = tags[player]
        if not status or not head then
            if tag and tag.gui then pcall(function() tag.gui:Destroy() end) end
            tags[player] = nil
            return
        end
        if not tag or not tag.gui or not tag.gui.Parent then tag = makeTag(player, head) end
        tag.gui.Adornee = head
        tag.gui.Enabled = true
        tag.label.Text = status
        if status == "STEALING" then
            tag.pill.BackgroundColor3 = Color3.fromRGB(78, 14, 21)
            tag.stroke.Color = Color3.fromRGB(255, 64, 76)
            tag.label.TextColor3 = Color3.fromRGB(255, 240, 240)
        else
            tag.pill.BackgroundColor3 = Color3.fromRGB(13, 34, 82)
            tag.stroke.Color = Color3.fromRGB(80, 155, 255)
            tag.label.TextColor3 = Color3.fromRGB(235, 245, 255)
        end
    end
    Players.PlayerRemoving:Connect(function(player)
        local tag = tags[player]
        if tag and tag.gui then pcall(function() tag.gui:Destroy() end) end
        tags[player] = nil
        for plotName, ownerId in pairs(ownerByPlot) do
            if ownerId == player.UserId then ownerByPlot[plotName] = nil end
        end
    end)
    task.spawn(function()
        while true do
            if os.clock() - lastOwnerRefresh >= 2 then pcall(refreshBaseOwners) end
            local activeOwnerId = localBaseOwnerId()
            for _, player in ipairs(Players:GetPlayers()) do pcall(updateTag, player, activeOwnerId) end
            task.wait(0.35)
        end
    end)
end

-- ============================================================
-- KEYBINDS CLAVIER/SOURIS (porte de undtp stock) -- supporte les boutons
-- LATERAUX MB4/MB5. UIS ne les recoit pas -> on les POLL (IsMouseButtonPressed,
-- Enum.KeyCode.MouseButton4/5, ou VK Windows 0x05/0x06 via iskeydown/getkeystate).
-- Format des binds: "Key:T" / "Mouse:MouseButton4". Legacy "T" -> "Key:T".
-- Helpers exposes en _G._stp* pour etre utilisables par le GUI (nearest key).
-- ============================================================
do
    local VK_XBUTTON1, VK_XBUTTON2 = 0x05, 0x06
    local function _norm(s)
        if type(s) ~= "string" or s == "" then return nil end
        if string.find(s, ":", 1, true) then return s end
        return "Key:" .. s
    end
    _G._stpNormBind = _norm
    _G._stpBindPretty = function(s)
        local n = _norm(s); if not n then return "NONE" end
        local kind, name = string.match(n, "^([^:]+):(.+)$")
        if kind == "Mouse" then
            local map = { MouseButton1="MB1", MouseButton2="MB2", MouseButton3="MB3",
                          MouseButton4="MB4", XButton1="MB4", MouseButton5="MB5", XButton2="MB5" }
            return map[name] or name
        end
        return name or n
    end
    local function _isMouseBtn(input)
        local nm = input.UserInputType and input.UserInputType.Name
        return nm == "MouseButton1" or nm == "MouseButton2" or nm == "MouseButton3"
            or nm == "MouseButton4" or nm == "MouseButton5"
    end
    _G._stpIsMouseBtn = _isMouseBtn
    _G._stpInputMatches = function(input, bind)
        bind = _norm(bind); if not bind then return false end
        local kind, name = string.match(bind, "^([^:]+):(.+)$")
        if kind == "Key" then
            return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == name
        elseif kind == "Mouse" then
            return input.UserInputType.Name == name
        end
        return false
    end
    local function _vkDown(vk)
        for _, fn in ipairs({ iskeydown, iskeypressed }) do
            if typeof(fn) == "function" then local ok, r = pcall(fn, vk); if ok and r then return true end end
        end
        if typeof(getkeystate) == "function" then
            local ok, r = pcall(getkeystate, vk)
            if ok then
                if r == true then return true end
                if type(r) == "number" and (r < 0 or (bit32 and bit32.band(r, 0x8000) ~= 0)) then return true end
            end
        end
        return false
    end
    local function _sideDown(side)
        local name = "MouseButton" .. tostring(side)
        local ok, uit = pcall(function() return Enum.UserInputType[name] end)
        if ok and uit then local ok2, p = pcall(function() return UIS:IsMouseButtonPressed(uit) end); if ok2 and p then return true end end
        local okk, kc = pcall(function() return Enum.KeyCode[name] end)
        if okk and kc then
            local ok2, p = pcall(function() return UIS:IsKeyDown(kc) end); if ok2 and p then return true end
            if typeof(iskeydown) == "function" then local ok3, p3 = pcall(iskeydown, kc); if ok3 and p3 then return true end end
        end
        return _vkDown(side == 5 and VK_XBUTTON2 or VK_XBUTTON1)
    end
    _G._stpSideDown = _sideDown
    _G._stpBindIsSide = function(bind, side)
        bind = _norm(bind); if not bind then return false end
        local want = "Mouse:MouseButton" .. tostring(side)
        if bind == want then return true end
        if side == 4 and (bind == "Mouse:XButton1" or bind == "Mouse:MB4") then return true end
        if side == 5 and (bind == "Mouse:XButton2" or bind == "Mouse:MB5") then return true end
        return false
    end

    -- POLL des boutons lateraux (rising edge) -> declenche TP ou nearest
    local prev4, prev5 = false, false
    local function _onSide(side)
        if _G._stp_listening then return end
        if _G._stpBindIsSide(_norm(_G._stp_tpKeyName) or "Key:T", side) then
            task.spawn(function() pcall(manualFullTP) end)
        end
        if _G.TT3NearestKey and _G._stpBindIsSide(_G.TT3NearestKey, side) and _G._stpFireNearKey then
            pcall(_G._stpFireNearKey)
        end
    end
    RunService.Heartbeat:Connect(function()
        -- cout ~0 si aucune touche n est bind sur un lateral (cas courant): on ne
        -- fait le poll couteux (_sideDown) QUE si un bind lateral existe.
        local tp = _norm(_G._stp_tpKeyName) or "Key:T"
        local nk = _G.TT3NearestKey
        local n4 = _G._stpBindIsSide(tp, 4) or (nk ~= nil and _G._stpBindIsSide(nk, 4))
        local n5 = _G._stpBindIsSide(tp, 5) or (nk ~= nil and _G._stpBindIsSide(nk, 5))
        if not (n4 or n5) then prev4, prev5 = false, false; return end
        local d4 = n4 and _sideDown(4) or false
        local d5 = n5 and _sideDown(5) or false
        if d4 and not prev4 then _onSide(4) end
        if d5 and not prev5 then _onSide(5) end
        prev4, prev5 = d4, d5
    end)

    -- CAPTURE de rebind (clavier OU souris, lateraux inclus). Reutilisable.
    -- setBind(b) recoit le bind capture ("Key:X"/"Mouse:MouseButtonN"), onDone(b) apres.
    _G._stpListenBind = function(setBind, onDone)
        if _G._stp_listening then return end
        _G._stp_listening = true
        task.spawn(function()
            while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
                or _sideDown(4) or _sideDown(5) do task.wait() end
            local done = false
            local function finish(b)
                if done then return end
                done = true; _G._stp_listening = false
                if b then setBind(b) end
                if onDone then pcall(onDone, b) end
            end
            local conn
            conn = UIS.InputBegan:Connect(function(input, gp)
                if done then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if gp then return end
                    local nm = input.KeyCode.Name
                    if conn then conn:Disconnect() end
                    if nm == "Escape" then finish(nil) else finish("Key:" .. nm) end
                elseif _isMouseBtn(input) then
                    if conn then conn:Disconnect() end
                    finish("Mouse:" .. input.UserInputType.Name)
                end
            end)
            local p4, p5 = _sideDown(4), _sideDown(5)
            while not done and _G._stp_listening do
                local d4, d5 = _sideDown(4), _sideDown(5)
                if d4 and not p4 then if conn then conn:Disconnect() end; finish("Mouse:MouseButton4"); break end
                if d5 and not p5 then if conn then conn:Disconnect() end; finish("Mouse:MouseButton5"); break end
                p4, p5 = d4, d5
                task.wait()
            end
            if conn then pcall(function() conn:Disconnect() end) end
        end)
    end

    -- KEYBIND MANUAL TP (clavier OU souris normale; lateraux via le poll ci-dessus)
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if _G._stp_listening then return end
        local want = _norm(_G._stp_tpKeyName) or "Key:T"
        if _G._stpBindIsSide(want, 4) or _G._stpBindIsSide(want, 5) then return end
        if _G._stpInputMatches(input, want) then
            task.spawn(function() pcall(manualFullTP) end)
        end
    end)
end

-- ===== lines 4507-4573 from hub a =====
task.spawn(function() pcall(loadModules) pcall(loadNet) end)

_G.TT3ChannelsReady = false
task.spawn(function()
    local _t0 = os.clock()
    repeat
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
        if Plots then
            local kids = Plots:GetChildren()
            if #kids > 0 then
                local all = true
                for _, p in ipairs(kids) do
                    if not getPlotChannel(p.Name) then all = false break end
                end
                if all then _G.TT3ChannelsReady = true return end
            end
        end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 25
end)

task.spawn(function()
    local char = LP.Character or LP.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    char:WaitForChild("Humanoid", 10)
    pcall(loadModules); pcall(loadNet)
    if _G.TT3AutoTP ~= false then
        task.spawn(function()
            local _tw = os.clock()
            while os.clock() - _tw < 12 do
                for _, n in ipairs(CARPET_NAMES) do
                    if findTool(n) then pcall(carpetEngage) return end
                end
                task.wait(0.05)
            end
        end)
    end
    local function _allChannelsReady()
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots then return false end
        local kids = Plots:GetChildren()
        if #kids == 0 then return false end
        for _, plot in ipairs(kids) do
            if not getPlotChannel(plot.Name) then return false end
        end
        return true
    end
    local _t0 = os.clock()
    local _lastN, _lastTop = -1, nil
    repeat
        if _allChannelsReady() then
            local ok, pets = pcall(scanAllPets)
            if ok and pets and #pets > 0 then
                local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
                if #pets == _lastN and top == _lastTop then break end
                _lastN, _lastTop = #pets, top
                task.wait(tonumber(_G.TT3ScanSettle) or 0.06)
            else
                RunService.Heartbeat:Wait()
            end
        else
            RunService.Heartbeat:Wait()
        end
    until os.clock() - _t0 > 12
    do
        local _d = tonumber(_G._stp_tpDelay) or tonumber(_G.TPDelay) or 0
        if _d > 0 then task.wait(_d) end
    end
    if _G.TT3AutoTP == false then return end
    do
        local _tw = os.clock()
        local function _carpetEquipped()
            local c = LP.Character
            if not c then return false end
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return true end
            end
            return false
        end
        while not _carpetEquipped() and os.clock() - _tw < 12 do
            task.wait(0.05)
        end
    end
    pcall(doVelocityTP)
end)

-- ===== AUTO STEAL MINIMAL + UI TEST =====
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local PG = LP:WaitForChild("PlayerGui")

    local function notify(t, m)
        local old = PG:FindFirstChild("TPTestNotif"); if old then old:Destroy() end
        local sg = Instance.new("ScreenGui"); sg.Name="TPTestNotif"; sg.ResetOnSpawn=false; sg.Parent=PG
        local f = Instance.new("Frame", sg); f.Size=UDim2.new(0,300,0,54); f.Position=UDim2.new(0.5,-150,0,70)
        f.BackgroundColor3=Color3.fromRGB(0, 0, 0); Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local a=Instance.new("TextLabel",f); a.Size=UDim2.new(1,-16,0,18); a.Position=UDim2.new(0,8,0,6)
        a.BackgroundTransparency=1; a.Text=tostring(t); a.Font=Enum.Font.GothamBold; a.TextSize=12; a.TextColor3=Color3.new(1,1,1); a.TextXAlignment=Enum.TextXAlignment.Left
        local b=Instance.new("TextLabel",f); b.Size=UDim2.new(1,-16,0,18); b.Position=UDim2.new(0,8,0,28)
        b.BackgroundTransparency=1; b.Text=tostring(m); b.Font=Enum.Font.Gotham; b.TextSize=11; b.TextColor3=Color3.fromRGB(180,180,180); b.TextXAlignment=Enum.TextXAlignment.Left
        task.delay(3, function() if sg.Parent then sg:Destroy() end end)
    end

    local function _normCarriedName(value)
        return tostring(value or ""):lower():gsub("%s+", "")
    end
    local function _isPetBeingCarried(pet)
        if not pet then return false end
        local keys = {}
        if pet.index then keys[_normCarriedName(pet.index)] = true end
        if pet.name then keys[_normCarriedName(pet.name)] = true end
        if next(keys) == nil then return false end
        for _, player in ipairs(Players:GetPlayers()) do
            local held = player:GetAttribute("StealingIndex")
            if held ~= nil and tostring(held) ~= "" and keys[_normCarriedName(held)] then return true end
        end
        return false
    end

    local function findStealPrompt(pet)
        if not pet then return nil end
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
                        if p:IsA("ProximityPrompt") and p.Enabled
                            and tostring(p.ActionText or ""):lower():find("steal") then return p end
                    end
                end
                for _, d in ipairs(podium:GetDescendants()) do
                    if d:IsA("ProximityPrompt") and d.Enabled
                        and tostring(d.ActionText or ""):lower():find("steal") then return d end
                end
            end
        end
        return nil
    end

    -- AUTO STEAL = copie TT3 (getconnections hold/trigger)
    local InternalStealCache = {}
    local STEAL_HOLD_DURATION = 1.3
    local STEAL_PROXIMITY = 57
    local _stealHoldStart, _stealHoldActive = 0, false
    local _stealHoldGen = 0
    local _holdPrompt, _holdTargetUid = nil, nil
    local _stealTarget, _stealArmedAt = nil, 0
    local _stealLastScan, _autoLastScan = 0, 0
    -- Throttle selection: nearest re-scan rapide (suivre le pet sous les pieds),
    -- priority plus lent (liste stable).
    local _lastTargetPick, _lastPickUid = 0, nil

    local function _promptWorldPos(prompt)
        if not prompt then return nil end
        local pp = prompt.Parent
        if pp and pp:IsA("BasePart") then return pp.Position end
        if pp and pp.Parent and pp.Parent:IsA("BasePart") then return pp.Parent.Position end
        return nil
    end

    -- Distance horizontale (XZ): ce qui compte pour "je suis dessus", pas la hauteur du mesh.
    local function _nearestDist(pet, myPos)
        if not pet or not myPos then return math.huge end
        local pos = pet.position
        if not pos then
            pos = _promptWorldPos(findStealPrompt(pet))
        end
        if not pos then return math.huge end
        local dx, dz = pos.X - myPos.X, pos.Z - myPos.Z
        return math.sqrt(dx * dx + dz * dz)
    end

    local function abortStealHold()
        if not _stealHoldActive and not _holdPrompt then return end
        _stealHoldGen += 1
        _stealHoldActive = false
        _G.TT3LocalAutoStealActive = false
        local prompt = _holdPrompt
        _holdPrompt, _holdTargetUid = nil, nil
        if prompt and InternalStealCache[prompt] then
            local data = InternalStealCache[prompt]
            for _, fn in ipairs(data.holdEndCallbacks or {}) do
                task.spawn(fn)
            end
            data.ready = true
        end
    end

    -- Barre % en bas de l'ecran. PUREMENT VISUEL: elle ne fait que refleter le
    -- hold, elle ne le raccourcit pas et ne touche a aucun attribut. Le timing
    -- du grab reste exactement celui d'origine.
    local stealBarSg, stealBarWrap, stealBarFill, stealBarTitle, stealBarPct
    -- Nom du brainrot actuellement cible: la barre l affiche EN PERMANENCE (au repos
    -- comme pendant le hold), pour rester synchro avec le nearest / la cible verrouillee.
    local _currentTargetName = nil
    local function ensureStealBar()
        if stealBarSg and stealBarSg.Parent then return end
        local old = PG:FindFirstChild("LeanStealBar")
        if old then old:Destroy() end
        stealBarSg = Instance.new("ScreenGui")
        stealBarSg.Name = "LeanStealBar"
        stealBarSg.ResetOnSpawn = false
        stealBarSg.IgnoreGuiInset = true
        stealBarSg.DisplayOrder = 120
        stealBarSg.Parent = PG
        local wrap = Instance.new("Frame", stealBarSg)
        stealBarWrap = wrap
        wrap.Name = "Wrap"
        wrap.AnchorPoint = Vector2.new(0.5, 1)
        -- remontee au-dessus de la hotbar (equipements) pour ne plus la cacher
        wrap.Position = UDim2.new(0.5, 0, 1, -150)
        wrap.Size = UDim2.new(0, 340, 0, 46)
        wrap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        wrap.BorderSizePixel = 0
        Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
        stealBarTitle = Instance.new("TextLabel", wrap)
        stealBarTitle.BackgroundTransparency = 1
        stealBarTitle.Position = UDim2.new(0, 10, 0, 4)
        stealBarTitle.Size = UDim2.new(1, -70, 0, 16)
        stealBarTitle.Font = Enum.Font.GothamBold
        stealBarTitle.TextSize = 12
        stealBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        stealBarTitle.TextXAlignment = Enum.TextXAlignment.Left
        stealBarTitle.Text = "STEAL"
        stealBarPct = Instance.new("TextLabel", wrap)
        stealBarPct.BackgroundTransparency = 1
        stealBarPct.Position = UDim2.new(1, -60, 0, 4)
        stealBarPct.Size = UDim2.new(0, 50, 0, 16)
        stealBarPct.Font = Enum.Font.GothamBold
        stealBarPct.TextSize = 12
        stealBarPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        stealBarPct.TextXAlignment = Enum.TextXAlignment.Right
        stealBarPct.Text = "0%"
        local track = Instance.new("Frame", wrap)
        track.Position = UDim2.new(0, 10, 0, 26)
        track.Size = UDim2.new(1, -20, 0, 10)
        track.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
        track.BorderSizePixel = 0
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        stealBarFill = Instance.new("Frame", track)
        stealBarFill.Size = UDim2.new(0, 0, 1, 0)
        stealBarFill.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
        stealBarFill.BorderSizePixel = 0
        Instance.new("UICorner", stealBarFill).CornerRadius = UDim.new(1, 0)
        stealBarSg.Enabled = true   -- barre permanente
    end
    local function showStealBar(name, pct)
        pcall(function()
            ensureStealBar()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarSg.Enabled = true
            stealBarTitle.Text = "STEAL  " .. tostring(name or "")
            stealBarPct.Text = tostring(math.floor(pct * 100 + 0.5)) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    local function setStealBarPct(pct)
        if not stealBarSg or not stealBarSg.Enabled then return end
        pcall(function()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarPct.Text = tostring(math.floor(pct * 100 + 0.5)) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    -- La barre reste TOUJOURS affichee: au lieu de la masquer on la remet
    -- simplement au repos (0%, sans nom de pet).
    local function hideStealBar()
        pcall(function()
            ensureStealBar()
            stealBarSg.Enabled = true
            stealBarTitle.Text = _currentTargetName and ("STEAL  " .. _currentTargetName) or "STEAL"
            stealBarPct.Text = "0%"
            stealBarFill.Size = UDim2.new(0, 0, 1, 0)
        end)
    end
    -- affichage immediat au chargement
    task.defer(hideStealBar)

    -- ============================================================
    -- RAGDOLL DANS LA BARRE DE STEAL (portage de TT3 checkRagdollBar)
    -- Quand tu es ragdoll, la barre passe en ROUGE "RAGDOLL - X.Xs" avec le
    -- temps restant (RagdollEndTime serveur - GetServerTimeNow), la jauge se
    -- vide jusqu a 0, puis la barre revient au steal a la fin. Comme la source
    -- est RagdollEndTime (serveur), le decompte continue meme quand l anti-
    -- ragdoll te remet debout -> tu vois quand le ragdoll finit VRAIMENT.
    -- ============================================================
    do
        local RAGBAR_STATES = {
            [Enum.HumanoidStateType.Physics]     = true,
            [Enum.HumanoidStateType.Ragdoll]     = true,
            [Enum.HumanoidStateType.FallingDown] = true,
            [Enum.HumanoidStateType.GettingUp]   = true,
        }
        local RAG_RED     = Color3.fromRGB(255, 60, 60)
        local RAG_ORANGE  = Color3.fromRGB(255, 160, 60)
        local STEAL_GREEN = Color3.fromRGB(86, 86, 86)
        local PCT_GREEN   = Color3.fromRGB(255, 255, 255)
        local ragBarOn, ragLastEnd, ragTotal = false, nil, nil
        RunService.RenderStepped:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            local endTime = hum and LP:GetAttribute("RagdollEndTime")
            local left = endTime and (endTime - workspace:GetServerTimeNow()) or nil
            local isRag = hum and (RAGBAR_STATES[hum:GetState()] or (left and left > 0))
            if isRag then
                ensureStealBar()
                ragBarOn = true
                stealBarSg.Enabled = true
                stealBarFill.BackgroundColor3 = RAG_RED
                stealBarPct.TextColor3 = RAG_ORANGE
                if left and left > 0 then
                    -- fige la duree totale au debut -> la jauge part pleine
                    if endTime ~= ragLastEnd then ragLastEnd = endTime; ragTotal = left end
                    local p = math.clamp(left / math.max(ragTotal or left, 0.1), 0, 1)
                    stealBarTitle.Text = string.format("RAGDOLL - %.1fs", left)
                    stealBarPct.Text   = string.format("%.1fs", left)
                    stealBarFill.Size  = UDim2.new(p, 0, 1, 0)
                else
                    stealBarTitle.Text = "RAGDOLL"
                    stealBarPct.Text   = "..."
                    stealBarFill.Size  = UDim2.new(1, 0, 1, 0)
                end
            elseif ragBarOn then
                -- le ragdoll vient de finir: on rend la barre au steal
                ragBarOn, ragLastEnd, ragTotal = false, nil, nil
                stealBarFill.BackgroundColor3 = STEAL_GREEN
                stealBarPct.TextColor3 = PCT_GREEN
                if not _stealHoldActive then hideStealBar() end
            end
        end)
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        if not prompt or not prompt.Parent then return end
        local data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local function grab(sig, into)
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then table.insert(into, c.Function) end
                end
            end
        end
        grab(prompt.PromptButtonHoldBegan, data.holdCallbacks)
        grab(prompt.Triggered, data.triggerCallbacks)
        grab(prompt.PromptButtonHoldEnded, data.holdEndCallbacks)
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 or #data.holdEndCallbacks > 0 then
            InternalStealCache[prompt] = data
        end
    end

    -- RoseHub hold method: force the prompt's existing state upvalue to "Steal",
    -- call the genuine hold callbacks, and trigger the prompt after the hold window.
    local _stealPromptStateCache = setmetatable({}, {__mode = "k"})
    local function fireHoldForced(prompt, data)
        if not data or #data.holdCallbacks == 0 then return false end
        local state = _stealPromptStateCache[prompt]
        if state == nil and debug and debug.getupvalues then
            for _, callback in ipairs(data.holdCallbacks) do
                local ok, upvalues = pcall(debug.getupvalues, callback)
                if ok and type(upvalues) == "table" then
                    for _, value in pairs(upvalues) do
                        if type(value) == "table" and rawget(value, "State") ~= nil
                            and rawget(value, "ProximityPrompt") ~= nil then
                            state = value
                            _stealPromptStateCache[prompt] = state
                            break
                        end
                    end
                end
                if state then break end
            end
            if state == nil then _stealPromptStateCache[prompt] = false end
        elseif state == false then
            state = nil
        end
        if state and state.State ~= "Steal" then
            local previous = state.State
            local ok = pcall(function()
                state.State = "Steal"
                for _, callback in ipairs(data.holdCallbacks) do pcall(callback) end
            end)
            pcall(function() state.State = previous end)
            return ok
        end
        for _, callback in ipairs(data.holdCallbacks) do pcall(callback) end
        return true
    end
    local function fireStealTrigger(prompt, data)
        if not (prompt and prompt.Parent) then return false end
        if fireproximityprompt and _G.TT3StealUseFPP ~= false then
            local ok = pcall(fireproximityprompt, prompt)
            if ok then return true end
        end
        for _, callback in ipairs((data and data.triggerCallbacks) or {}) do pcall(callback) end
        if (not data or #data.triggerCallbacks == 0) and fireproximityprompt then
            return pcall(fireproximityprompt, prompt)
        end
        return true
    end

    -- petName: cosmetique uniquement (titre de la barre), n'influe sur rien
    -- targetUid: si la cible nearest change mid-hold, on abort cette gen et on
    -- relance un hold frais sur la nouvelle cible.
    local function executeStealAsync(prompt, petName, targetUid)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        _stealHoldStart = tick()
        _stealHoldActive = true
        _G.TT3LocalAutoStealActive = true
        _holdPrompt = prompt
        _holdTargetUid = targetUid
        local gen = _stealHoldGen
        showStealBar(petName, 0)
        task.spawn(function()
            fireHoldForced(prompt, data)
            local hold = STEAL_HOLD_DURATION
            pcall(function()
                local hd = prompt.HoldDuration
                if type(hd) == "number" and hd > 0 then
                    hold = math.min(STEAL_HOLD_DURATION, hd + 0.03)
                end
            end)
            -- Drive the bar from the SAME clock, start and duration as the hold gate
            -- (_stealHoldStart / hold) so the % is the true fraction of the hold at
            -- every frame and reaches 100% exactly when the hold completes.
            while true do
                if gen ~= _stealHoldGen then
                    -- cible changee: hold annule, pas de trigger sur l ancienne
                    data.ready = true
                    return
                end
                local el = tick() - _stealHoldStart
                -- Le hold court PENDANT le ragdoll, mais le steal (les
                -- triggerCallbacks juste apres) ne part qu une fois le ragdoll
                -- FINI -> le brainrot se prend PILE a la fin du ragdoll, sans
                -- re-attendre un hold. Cap de securite pour ne jamais rester
                -- coince si RagdollEndTime ne se clear pas.
                local ragLeft = 0
                if _G.TT3StealDuringRagdoll ~= false then
                    local rt = LP:GetAttribute("RagdollEndTime")
                    if rt then ragLeft = rt - workspace:GetServerTimeNow() end
                end
                if el >= hold and (ragLeft <= 0 or el > hold + 40) then break end
                setStealBarPct(math.min(el / hold, 1))
                RunService.Heartbeat:Wait()
            end
            if gen ~= _stealHoldGen then
                data.ready = true
                return
            end
            setStealBarPct(1)
            if prompt and prompt.Parent then fireStealTrigger(prompt, data) end
            for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end
            if gen == _stealHoldGen then
                _stealHoldActive = false
                _G.TT3LocalAutoStealActive = false
                _holdPrompt, _holdTargetUid = nil, nil
            end
            task.wait(0.05)
            data.ready = true
            task.wait(0.2)
            if gen == _stealHoldGen then hideStealBar() end
        end)
        -- filet: si le cycle se perd en route, la barre ne reste pas collee
        task.delay(STEAL_HOLD_DURATION + 0.6, function()
            if gen == _stealHoldGen then hideStealBar() end
        end)
        return true
    end

    local function timeUntilCanSteal()
        -- "Web" RETIRE des bloqueurs: un item web/gummy pose l attribut Web pendant
        -- le CC et le clear client (anti-gummy) peut ne pas suffire (serveur re-set)
        -- -> le steal restait bloque (-1). But = steal PENDANT le ragdoll/web, donc
        -- on ne bloque plus sur Web (le ragdoll est gere via RagdollEndTime en dessous).
        if (LP:GetAttribute("Stealing") and _G.TT3StealContinueWhileCarrying == false)
            or LP:GetAttribute("IsTrading") or LP:GetAttribute("IsDuelSelecting") then
            return -1
        end
        local ragdoll = LP:GetAttribute("RagdollEndTime")
        if ragdoll then
            local r = ragdoll - workspace:GetServerTimeNow()
            if r > 0 then return r end
        end
        return 0
    end

    local stealOn = (_G.TT3StealMode ~= nil)
    RunService.Heartbeat:Connect(function()
        if not stealOn then return end
        local now = os.clock()
        -- SELECTION DE CIBLE throttlee: on ne re-choisit le nearest QUE toutes les
        -- 1.5s (avant: chaque 0.08s -> cible + nom de la barre changeaient sans arret).
        -- Re-choix immediat si on n a aucune cible, ou si tu viens de cliquer une cible
        -- dans le panneau Steal Target (UID verrouille different du dernier choisi).
        if _stealTarget and _isPetBeingCarried(_stealTarget) then
            if _stealHoldActive then abortStealHold() end
            _stealTarget = nil
        end
        local _lockUid = _G.TT3StealTargetUID
        local _lockChanged = (type(_lockUid) == "string" and _lockUid ~= "" and _lockUid ~= _lastPickUid)
        -- nearest: refresh rapide pour detecter le pet sous tes pieds.
        -- priority: 1.5s (cible #1 stable). nearest continue a picker MEME pendant
        -- un hold: si la cible change -> abort + nouveau hold (plus bas).
        local _pickInterval = (_G.TT3StealMode == "nearest") and 0.08 or 1.5
        local _needPick = (not _stealTarget) or _lockChanged or (now - _lastTargetPick) >= _pickInterval
        -- priority: pas de re-pick mid-hold (liste stable). nearest: oui.
        if _stealHoldActive and _G.TT3StealMode ~= "nearest" and not _lockChanged then
            _needPick = false
        end
        if (_G.TT3StealContinueWhileCarrying ~= false or not LP:GetAttribute("Stealing"))
            and _needPick and (now - _autoLastScan) >= 0.05 then
            _autoLastScan = now
            _lastTargetPick = now
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local ok, pets = pcall(scanAllPets)
                if ok and pets and #pets > 0 then
                    local best
                    local availablePets = {}
                    for _, candidate in ipairs(pets) do
                        if not candidate.conveyor and not _isPetBeingCarried(candidate) then
                            availablePets[#availablePets + 1] = candidate
                        end
                    end
                    -- If a target is in somebody's hand, skip only that item and keep
                    -- AutoSteal alive for the next available brainrot.
                    if type(_lockUid) == "string" and _lockUid ~= "" then
                        for _, p in ipairs(availablePets) do
                            if _petUid(p) == _lockUid then best = p; break end
                        end
                    end
                    if not best and _G.TT3StealMode == "nearest" then
                        local myPos = hrp.Position
                        local bestD = math.huge
                        for _, p in ipairs(availablePets) do
                            local d = _nearestDist(p, myPos)
                            if d < bestD then bestD = d; best = p end
                        end
                    elseif not best then
                        best = availablePets[1]
                    end
                    if best then
                        local newUid = _petUid(best)
                        local oldUid = _stealTarget and _petUid(_stealTarget)
                        local targetChanged = (type(newUid) == "string" and newUid ~= "" and newUid ~= oldUid)
                            or (type(newUid) == "string" and newUid ~= "" and _holdTargetUid and newUid ~= _holdTargetUid)
                        -- Nearest / lock: si on focus un autre brainrot, abort le hold
                        -- en cours et laisse le heartbeat relancer un hold 0% frais.
                        if targetChanged and _stealHoldActive then
                            abortStealHold()
                        end
                        _stealTarget = best
                        _stealArmedAt = now
                        _lastPickUid = _lockUid
                        -- BARRE toujours synchro avec la cible: nom affiche en permanence
                        -- (au repos), pas seulement pendant le hold.
                        -- ne JAMAIS vider le nom: on ne remplace que par un nom valide
                        if type(best.name) == "string" and best.name ~= "" then _currentTargetName = best.name end
                        if not _stealHoldActive then hideStealBar() end
                    else
                        _stealTarget = nil
                    end
                end
            end
        end
        local pet = _stealTarget
        if not pet then return end
        if _G.TT3StealHold then return end
        -- Hold en cours sur LA MEME cible: on attend. Si abort a eu lieu (nouvelle
        -- cible), _stealHoldActive est false -> on enchaine un nouveau hold.
        if _stealHoldActive then return end
        if now - _stealLastScan < 0.067 then return end
        _stealLastScan = now
        local t = timeUntilCanSteal()
        if t == -1 then return end
        -- HOLD PENDANT LE RAGDOLL, STEAL A LA FIN: au lieu d attendre la fin du
        -- ragdoll pour COMMENCER le hold, on demarre le cycle de steal des qu on
        -- est ragdoll (tant qu on est encore a portee). Le hold court PENDANT le
        -- ragdoll, et le steal (les triggerCallbacks) ne part qu a la FIN du
        -- ragdoll (voir la boucle de hold plus bas) -> plus de re-wait apres.
        -- Une seule passe grace a la garde data.ready -> pas de spam, un seul
        -- paquet emis pendant le ragdoll.
        -- _G.TT3StealDuringRagdoll = false -> ancien comportement (attendre).
        if _G.TT3StealDuringRagdoll == false then
            if t > 0 and t > STEAL_HOLD_DURATION then return end
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then return end
        local ppPos = _promptWorldPos(prompt)
        if ppPos and (hrp.Position - ppPos).Magnitude > STEAL_PROXIMITY then return end
        local oldMax
        pcall(function() oldMax = prompt.MaxActivationDistance end)
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then
            executeStealAsync(prompt, pet.name, _petUid(pet))
        elseif fireproximityprompt then
            showStealBar(pet.name, 1)
            pcall(function() fireproximityprompt(prompt) end)
            task.delay(0.4, hideStealBar)
        end
        pcall(function() if oldMax ~= nil then prompt.MaxActivationDistance = oldMax end end)
    end)

    -- unwalk constant (comme ton hub)
    do
        local hookedAnimators = setmetatable({}, { __mode = "k" })
        local function stopTrack(track)
            pcall(function() track:AdjustWeight(0, 0) end)
            pcall(function() track:Stop(0) end)
        end
        local function applyUnwalkAlways(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
            if animator then
                if not hookedAnimators[animator] then
                    hookedAnimators[animator] = true
                    animator.AnimationPlayed:Connect(function(track)
                        stopTrack(track)
                    end)
                end
                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                if ok and tracks then
                    for _, track in ipairs(tracks) do stopTrack(track) end
                end
            end
        end
        local function hook(char)
            task.spawn(function()
                char:WaitForChild("Humanoid", 10); task.wait(0.05)
                for i = 1, 8 do
                    if LP.Character ~= char then break end
                    applyUnwalkAlways(char); task.wait(0.25)
                end
            end)
        end
        if LP.Character then hook(LP.Character) end
        LP.CharacterAdded:Connect(hook)
        local _unwalkLast = 0
        RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - _unwalkLast < 1.5 then return end
            _unwalkLast = now
            if LP.Character then applyUnwalkAlways(LP.Character) end
        end)
    end

    local HS = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local CFG_FILE = "SideTP.json"
    local IS_MOBILE = UIS.TouchEnabled
    local MOBILE_SCALE = IS_MOBILE and 0.78 or 1

    local function fitMobilePanel(panel, scaleValue)
        if not IS_MOBILE or not panel then return end
        local scale = Instance.new("UIScale")
        scale.Name = "TT3MobileScale"
        scale.Scale = scaleValue or MOBILE_SCALE
        scale.Parent = panel
    end

    local function clampPanelToViewport(panel)
        if not panel or not panel.Parent then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local view, size = cam.ViewportSize, panel.AbsoluteSize
        local x = math.clamp(panel.AbsolutePosition.X, 6, math.max(6, view.X - size.X - 6))
        local y = math.clamp(panel.AbsolutePosition.Y, 6, math.max(6, view.Y - size.Y - 6))
        panel.Position = UDim2.fromOffset(x, y)
    end

    local function loadCfgTable()
        local t = {}
        if readfile then
            pcall(function()
                local raw = readfile(CFG_FILE)
                if type(raw) == "string" and #raw > 0 then
                    local ok, d = pcall(HS.JSONDecode, HS, raw)
                    if ok and type(d) == "table" then t = d end
                end
            end)
        end
        return t
    end

    local function saveTpSettings()
        if not writefile then return end
        local t = loadCfgTable()
        t.tpVelocity = tonumber(_G.TPVelocity) or 400
        t.climbSpeed = tonumber(_G.TT3Climb) or 160
        t.cframeSpeed = tonumber(_G.TT3CFrameSpeed) or 450
        t.walkSpeed = tonumber(_G.TT3WalkSpeed) or 20
        t.landingDelay = tonumber(_G.LandingDelay) or 0.35
        t.closeSpeed = tonumber(_G.TT3CloseSpeed) or 80
        t.autoTp = _G.TT3AutoTP ~= false
        t.goToBrainrotHit = _G.TT3GoToBrainrotHit ~= false
        t.continueAutoGrabWhileCarrying = _G.TT3StealContinueWhileCarrying ~= false
        t.autoSteal = stealOn
        t.stealMode = _G.TT3StealMode
        t.nearestKey = _G.TT3NearestKey
        t.tpKey = _G._stp_tpKeyName
        t.priorityList = _G.SHARED_PRIORITY_ITEMS
        t.priorityDefault = _G.TT3PriorityDefault
        t.mutationList = _G.SHARED_MUTATION_ITEMS
        t.mutationDefault = _G.TT3MutationDefault
        t.carpetTool = _G.TT3CarpetTool

        t.panelX = tonumber(_G._stp_panelX)
        t.panelY = tonumber(_G._stp_panelY)
        t.panelPos = _G._stp_pos   -- positions des panneaux secondaires
        t.panelVisibility = _G.TT3PanelVisibility
        pcall(function() writefile(CFG_FILE, HS:JSONEncode(t)) end)
    end

    if _G.TPVelocity == nil then _G.TPVelocity = 400 end
    if _G.TT3Climb == nil then _G.TT3Climb = 160 end
    if _G.TT3CFrameSpeed == nil then _G.TT3CFrameSpeed = 450 end
    if _G.TT3WalkSpeed == nil then _G.TT3WalkSpeed = 20 end
    if _G.LandingDelay == nil then _G.LandingDelay = 0.1 end
    if _G.TT3CloseSpeed == nil then _G.TT3CloseSpeed = 80 end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    _G.TT3PanelVisibility = _G.TT3PanelVisibility or {}
    _G.TT3PanelRegistry = _G.TT3PanelRegistry or {}
    if not _G.TT3RegisterPanel then
        _G.TT3RegisterPanel = function(id, gui)
            _G.TT3PanelRegistry[id] = gui
            if _G.TT3PanelVisibility[id] == nil then _G.TT3PanelVisibility[id] = true end
            pcall(function() gui.Enabled = _G.TT3PanelVisibility[id] ~= false end)
        end
    end
    if not _G.TT3SetPanelVisible then
        _G.TT3SetPanelVisible = function(id, visible)
            _G.TT3PanelVisibility[id] = visible and true or false
            local gui = _G.TT3PanelRegistry[id]
            if gui then pcall(function() gui.Enabled = visible and true or false end) end
            pcall(saveTpSettings)
            if _G.TT3RefreshPanelButtons then pcall(_G.TT3RefreshPanelButtons) end
        end
    end
    pcall(function()
        local old = guiParent:FindFirstChild("TPStealTestUI")
        if old then old:Destroy() end
        local old2 = PG:FindFirstChild("TPStealTestUI")
        if old2 then old2:Destroy() end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name = "TPStealTestUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end
    if _G.TT3RegisterPanel then _G.TT3RegisterPanel("teleport", sg) end

    -- savePos: true  -> panneau principal (cles historiques panelX/panelY)
    --          "nom" -> panneau secondaire, sauve dans _G._stp_pos[nom]
    _G._stp_pos = _G._stp_pos or {}
    local function _storePos(savePos, target)
        -- on sauve l OFFSET (meme repere que le drag), pas AbsolutePosition,
        -- pour rester coherent et ne pas reintroduire le saut d inset.
        if savePos == true then
            _G._stp_panelX = target.Position.X.Offset
            _G._stp_panelY = target.Position.Y.Offset
        elseif type(savePos) == "string" then
            _G._stp_pos[savePos] = {
                x = target.Position.X.Offset,
                y = target.Position.Y.Offset,
            }
        else
            return
        end
        saveTpSettings()
    end
    -- applique une position sauvegardee (si elle existe)
    local function _restorePos(key, target, dx, dy)
        local p = _G._stp_pos[key]
        if type(p) == "table" and tonumber(p.x) and tonumber(p.y) then
            target.Position = UDim2.fromOffset(p.x, p.y)
            return true
        end
        if dx and dy then target.Position = UDim2.fromOffset(dx, dy) end
        return false
    end

    local function makeDraggable(handle, target, savePos)
        handle.Active = true
        local dragging, dragStart, startX, startY
        handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            dragStart = input.Position
            -- on ancre sur l OFFSET ACTUEL du panneau (pas AbsolutePosition, qui
            -- est decalee par l inset de la topbar -> c est ce qui faisait "sauter"
            -- le panneau en l air des qu on appuyait). Aucun snap au clic.
            startX = target.Position.X.Offset
            startY = target.Position.Y.Offset
        end)
        handle.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not dragging then return end
            dragging = false
            _storePos(savePos, target)
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = input.Position - dragStart
            target.Position = UDim2.fromOffset(startX + d.X, startY + d.Y)
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    _storePos(savePos, target)
                end
            end
        end)
    end

    local f = Instance.new("Frame", sg)
    f.Name = "Main"
    f.Active = true
    f.Size = UDim2.fromOffset(210, 178)
    fitMobilePanel(f, 0.80)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    do local outline = Instance.new("UIStroke", f); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
    do
        local px = tonumber(_G._stp_panelX) or 20
        local py = tonumber(_G._stp_panelY) or 200
        f.Position = UDim2.fromOffset(px, py)
    end

    -- TITRE style "Keybind & Actions": texte transparent, PAS de barre de fond
    local title = Instance.new("TextButton", f)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 0
    title.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)
    title.Text = "otex private"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.AutoButtonColor = false
    title.Active = true
    makeDraggable(title, f, true)
    -- drag depuis N IMPORTE OU sur le panneau (le fond), pas juste le titre.
    -- Les boutons captent l input en premier (topmost), donc cliquer un bouton
    -- ne declenche pas le drag: seul le fond vide bouge le panneau.
    if not IS_MOBILE then makeDraggable(f, f, true) end
    task.defer(function() clampPanelToViewport(f) end)

    local function btn(txt, y, parent, fn)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -20, 0, 28)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.Active = true
        b.AutoButtonColor = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(fn)
        return b
    end

    local manualBtn = btn("MANUAL TP", 38, f, function()
        task.spawn(function()
            if _G.TT3StartSideTP then pcall(_G.TT3StartSideTP)
            else pcall(doVelocityTP, true) end
        end)
    end)
    -- KEYBIND MANUAL TP (rebindable) a droite du bouton, comme NEAREST. Le backend
    -- existe deja: _G._stp_tpKeyName -> poll lateraux (MB4/MB5) + InputBegan clavier.
    do
        if type(_G._stp_tpKeyName) ~= "string" or _G._stp_tpKeyName == "" then _G._stp_tpKeyName = "Key:T" end
        manualBtn.Size = UDim2.new(1, -60, 0, 28)
        local keyBtn = Instance.new("TextButton", f)
        keyBtn.Size = UDim2.new(0, 34, 0, 28)
        keyBtn.Position = UDim2.new(1, -44, 0, 38)
        keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        keyBtn.TextColor3 = Color3.new(1, 1, 1)
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 10
        keyBtn.Text = (_G._stpBindPretty and _G._stpBindPretty(_G._stp_tpKeyName)) or _G._stp_tpKeyName
        keyBtn.AutoButtonColor = true
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
        keyBtn.MouseButton1Click:Connect(function()
            if not _G._stpListenBind then return end
            keyBtn.Text = "..."; keyBtn.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
            _G._stpListenBind(
                function(b) _G._stp_tpKeyName = b end,
                function()
                    keyBtn.Text = _G._stpBindPretty(_G._stp_tpKeyName)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    pcall(saveTpSettings)
                end)
        end)
    end
    local priBtn, nearBtn, openPriorityEditor
    local function _refreshStealBtns()
        local m = stealOn and _G.TT3StealMode or nil
        if priBtn then
            priBtn.Text = "PRIORITY: " .. (m == "priority" and "ON" or "OFF")
            priBtn.BackgroundColor3 = (m == "priority") and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
        end
        if nearBtn then
            nearBtn.Text = "NEAREST: " .. (m == "nearest" and "ON" or "OFF")
            nearBtn.BackgroundColor3 = (m == "nearest") and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
        end
    end
    local function _setStealMode(mode)
        if mode == "nearest" then
            -- OFF nearest -> revient AUTOMATIQUEMENT sur priority (steal reste ON),
            -- au lieu de tout eteindre.
            if stealOn and _G.TT3StealMode == "nearest" then
                stealOn = true
                _G.TT3StealMode = "priority"
            else
                stealOn = true
                _G.TT3StealMode = "nearest"
            end
        else
            -- priority: toggle classique ON/OFF
            if stealOn and _G.TT3StealMode == mode then
                stealOn = false
                _G.TT3StealMode = nil
            else
                stealOn = true
                _G.TT3StealMode = mode
            end
        end
        _refreshStealBtns()
        saveTpSettings()
        notify("AUTO STEAL", stealOn and string.upper(_G.TT3StealMode) or "OFF")
    end
    _G.TT3IsAutoStealEnabled = function() return stealOn end
    _G.TT3SetAutoSteal = function(enabled)
        if enabled == nil then enabled = not stealOn end
        enabled = enabled == true
        if enabled == stealOn then return stealOn end
        if enabled then
            local mode = (_G.TT3StealMode == "nearest") and "nearest" or "priority"
            stealOn = true
            _G.TT3StealMode = mode
        else
            stealOn = false
            _G.TT3StealMode = nil
            abortStealHold()
        end
        _refreshStealBtns()
        saveTpSettings()
        notify("AUTO STEAL", stealOn and string.upper(_G.TT3StealMode) or "OFF")
        return stealOn
    end
    _G.TT3ToggleAutoSteal = function() return _G.TT3SetAutoSteal() end
    priBtn = btn("PRIORITY: OFF", 72, f, function() _setStealMode("priority") end)
    -- ENGRENAGE a droite de PRIORITY -> ouvre/ferme l editeur de liste priorite
    do
        priBtn.Size = UDim2.new(1, -60, 0, 28)   -- retreci pour loger l engrenage
        local gear = Instance.new("TextButton", f)
        gear.Size = UDim2.fromOffset(34, 28)
        gear.Position = UDim2.new(1, -44, 0, 72)
        gear.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        gear.Text = "\u{2699}"
        gear.TextColor3 = Color3.new(1, 1, 1)
        gear.Font = Enum.Font.GothamBold
        gear.TextSize = 16
        gear.AutoButtonColor = true
        gear.Active = true
        gear.ZIndex = 20
        Instance.new("UICorner", gear).CornerRadius = UDim.new(0, 6)
        gear.Activated:Connect(function()
            if openPriorityEditor then openPriorityEditor() end
        end)
    end
    nearBtn = btn("NEAREST: OFF", 106, f, function() _setStealMode("nearest") end)
    -- KEYBIND NEAREST (rebindable) juste a droite du bouton NEAREST. Appuyer sur
    -- la touche bascule le mode nearest (comme cliquer le bouton).
    do
        _G._stpFireNearKey = function() _setStealMode("nearest") end
        if type(_G.TT3NearestKey) ~= "string" or _G.TT3NearestKey == "" then _G.TT3NearestKey = "Key:N" end
        nearBtn.Size = UDim2.new(1, -60, 0, 28)   -- retreci pour loger la touche
        local keyBtn = Instance.new("TextButton", f)
        keyBtn.Size = UDim2.new(0, 34, 0, 28)
        keyBtn.Position = UDim2.new(1, -44, 0, 106)
        keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        keyBtn.TextColor3 = Color3.new(1, 1, 1)
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 10
        keyBtn.Text = (_G._stpBindPretty and _G._stpBindPretty(_G.TT3NearestKey)) or _G.TT3NearestKey
        keyBtn.AutoButtonColor = true
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
        -- clic = rebind: clavier OU souris (boutons LATERAUX MB4/MB5 inclus)
        keyBtn.MouseButton1Click:Connect(function()
            if not _G._stpListenBind then return end
            keyBtn.Text = "..."; keyBtn.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
            _G._stpListenBind(
                function(b) _G.TT3NearestKey = b end,
                function()
                    keyBtn.Text = _G._stpBindPretty(_G.TT3NearestKey)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    pcall(saveTpSettings)
                end)
        end)
        -- trigger clavier/souris normale (les lateraux sont geres par le poll global)
        UIS.InputBegan:Connect(function(input, gp)
            if gp or _G._stp_listening then return end
            local nk = _G.TT3NearestKey
            if not nk or _G._stpBindIsSide(nk, 4) or _G._stpBindIsSide(nk, 5) then return end
            if _G._stpInputMatches(input, nk) then _setStealMode("nearest") end
        end)
    end
    _refreshStealBtns()

    -- NO ANIM (espelha o toggle de _G.TT3ToggleBrainrotAnim definido em
    -- Extras-1.txt: para a animacao dos brainrots/bonecos, 100% client-side)
    local noAnimBtn
    local function _refreshNoAnimBtn()
        if not noAnimBtn then return end
        noAnimBtn.Text = "NO ANIM: " .. (_G.TT3NoBrainrotAnim and "ON" or "OFF")
        noAnimBtn.BackgroundColor3 = _G.TT3NoBrainrotAnim and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
    end
    noAnimBtn = btn("NO ANIM: OFF", 140, f, function()
        if _G.TT3ToggleBrainrotAnim then
            pcall(_G.TT3ToggleBrainrotAnim)
        else
            -- Extras-1.txt ainda nao rodou/carregou: so avisa, nao quebra.
            notify("NO ANIM", "Extras nao carregado")
        end
        _refreshNoAnimBtn()
    end)
    -- mantem o botao em sincronia se o toggle for mudado pelo paineluzinho do Extras
    local _prevNoAnimRefresh = _G.TT3RefreshBrainrotAnimBtn
    _G.TT3RefreshBrainrotAnimBtn = function()
        if _prevNoAnimRefresh then pcall(_prevNoAnimRefresh) end
        _refreshNoAnimBtn()
    end
    _refreshNoAnimBtn()

    local settingsPanel

    local function makeSettingRow(parent, label, y, min, max, getV, setV, step)
        step = step or 1
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -16, 0, 44)
        row.Position = UDim2.new(0, 8, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        row.Active = true
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -90, 0, 18)
        lbl.Position = UDim2.new(0, 8, 0, 2)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(1, -16, 0, 16)
        hit.Position = UDim2.new(0, 8, 0, 22)
        hit.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.Active = true
        Instance.new("UICorner", hit).CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame", hit)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local function fmt(v)
            if step < 1 then return string.format("%.2f", v) end
            return tostring(math.floor(v + 0.5))
        end

        local function refresh()
            local v = math.clamp(tonumber(getV()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = label .. ": " .. fmt(v)
        end

        local function applyAt(x)
            local rel = math.clamp((x - hit.AbsolutePosition.X) / math.max(hit.AbsoluteSize.X, 1), 0, 1)
            local v = min + (max - min) * rel
            v = math.floor(v / step + 0.5) * step
            v = math.clamp(v, min, max)
            setV(v)
            refresh()
        end

        local sliding = false
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                applyAt(input.Position.X)
            end
        end)
        hit.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if sliding then sliding = false; saveTpSettings(); notify(label, fmt(getV())) end
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not sliding then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                applyAt(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if sliding then sliding = false; saveTpSettings() end
            end
        end)

        local minus = Instance.new("TextButton", row)
        minus.Size = UDim2.fromOffset(28, 18)
        minus.Position = UDim2.new(1, -68, 0, 2)
        minus.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        minus.Text = "-"
        minus.TextColor3 = Color3.new(1, 1, 1)
        minus.Font = Enum.Font.GothamBold
        minus.TextSize = 14
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 4)
        minus.MouseButton1Click:Connect(function()
            local v = math.clamp((tonumber(getV()) or min) - step, min, max)
            setV(v); refresh(); saveTpSettings(); notify(label, fmt(v))
        end)

        local plus = Instance.new("TextButton", row)
        plus.Size = UDim2.fromOffset(28, 18)
        plus.Position = UDim2.new(1, -34, 0, 2)
        plus.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        plus.Text = "+"
        plus.TextColor3 = Color3.new(1, 1, 1)
        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 14
        Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 4)
        plus.MouseButton1Click:Connect(function()
            local v = math.clamp((tonumber(getV()) or min) + step, min, max)
            setV(v); refresh(); saveTpSettings(); notify(label, fmt(v))
        end)

        refresh()
    end

    local function openSettings()
        if settingsPanel and settingsPanel.Parent then
            settingsPanel.Visible = not settingsPanel.Visible
            -- on ne repositionne QUE si l utilisateur ne l a jamais deplace,
            -- sinon on ecraserait la position qu il a choisie
            if settingsPanel.Visible and not _G._stp_pos["settings"] then
                settingsPanel.Position = UDim2.fromOffset(f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
            end
            return
        end
        settingsPanel = Instance.new("Frame", sg)
        settingsPanel.Name = "TPSettings"
        settingsPanel.Active = true
        settingsPanel.Size = UDim2.fromOffset(225, 590)
        fitMobilePanel(settingsPanel, 0.72)
        settingsPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        settingsPanel.BorderSizePixel = 0
        Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 10)
        do local outline = Instance.new("UIStroke", settingsPanel); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
        _restorePos("settings", settingsPanel,
            f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
        task.defer(function() clampPanelToViewport(settingsPanel) end)

        -- TITRE style "Teleport": texte transparent, PAS de barre de fond
        local st = Instance.new("TextButton", settingsPanel)
        st.Size = UDim2.new(1, 0, 0, 30)
        st.BackgroundTransparency = 1
        st.Text = "TP SETTINGS"
        st.Font = Enum.Font.GothamBlack
        st.TextSize = 13
        st.TextColor3 = Color3.new(1, 1, 1)
        st.AutoButtonColor = false
        st.Active = true
        makeDraggable(st, settingsPanel, "settings")

        makeSettingRow(settingsPanel, "TP Velocity", 38, 200, 750,
            function() return _G.TPVelocity end, function(v) _G.TPVelocity = v end, 5)
        makeSettingRow(settingsPanel, "Climb Speed", 86, 100, 250,
            function() return _G.TT3Climb end, function(v) _G.TT3Climb = v end, 5)
        makeSettingRow(settingsPanel, "CFrame Speed", 134, 100, 900,
            function() return _G.TT3CFrameSpeed end, function(v) _G.TT3CFrameSpeed = v end, 10)
        makeSettingRow(settingsPanel, "Clone Delay", 182, 0.05, 0.75,
            function() return _G.LandingDelay end, function(v) _G.LandingDelay = v end, 0.05)
        -- vitesse utilisee quand la base visee est a moins de 100 studs
        makeSettingRow(settingsPanel, "100 Studs Base Speed", 230, 20, 400,
            function() return _G.TT3CloseSpeed end, function(v) _G.TT3CloseSpeed = v end, 5)

        local hitReturnBtn
        local function refreshHitReturnButton()
            local active = _G.TT3GoToBrainrotHit == true
            hitReturnBtn.Text = "GO TO BRAINROT HIT: " .. (active and "ON" or "OFF")
            hitReturnBtn.BackgroundColor3 = active and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
        end
        hitReturnBtn = btn("GO TO BRAINROT HIT: ON", 278, settingsPanel, function()
            _G.TT3GoToBrainrotHit = not (_G.TT3GoToBrainrotHit == true)
            refreshHitReturnButton()
            saveTpSettings()
        end)
        refreshHitReturnButton()

        local autoBtn
        autoBtn = btn("AUTO TP: " .. ((_G.TT3AutoTP ~= false) and "ON" or "OFF"), 314, settingsPanel, function()
            _G.TT3AutoTP = not (_G.TT3AutoTP ~= false)
            autoBtn.Text = "AUTO TP: " .. ((_G.TT3AutoTP ~= false) and "ON" or "OFF")
            saveTpSettings()
            notify("AUTO TP", (_G.TT3AutoTP ~= false) and "ON" or "OFF")
        end)

        -- SELECTEUR d OUTIL DE TP: choisit l outil de vol PREFERE. setCarpetTool
        -- le place en tete de CARPET_NAMES; equipCarpet equipe le 1er outil TROUVE
        -- dans le sac -> si tu ne possedes pas celui choisi, il retombe sur le
        -- suivant dispo. Clic = cycle a l outil suivant.
        local TP_TOOLS = { "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Witch's Broom", "Waverider" }
        local function _curTPTool()
            local c = _G.TT3CarpetTool
            if type(c) == "string" and c ~= "" then return c end
            return TP_TOOLS[1]
        end
        local toolBtn
        toolBtn = btn("TP TOOL: " .. _curTPTool(), 350, settingsPanel, function()
            local cur, idx = _curTPTool(), 1
            for i, n in ipairs(TP_TOOLS) do if n == cur then idx = i; break end end
            local nextTool = TP_TOOLS[(idx % #TP_TOOLS) + 1]
            if _G.TT3SetCarpetTool then pcall(_G.TT3SetCarpetTool, nextTool)
            else _G.TT3CarpetTool = nextTool end
            toolBtn.Text = "TP TOOL: " .. nextTool
            saveTpSettings()
            notify("TP TOOL", nextTool)
        end)

        local panelHeader = Instance.new("TextLabel", settingsPanel)
        panelHeader.Size = UDim2.new(1, -20, 0, 18); panelHeader.Position = UDim2.new(0, 10, 0, 386)
        panelHeader.BackgroundTransparency = 1; panelHeader.Font = Enum.Font.GothamBold
        panelHeader.TextSize = 10; panelHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        panelHeader.TextXAlignment = Enum.TextXAlignment.Left; panelHeader.Text = "PAINEIS"
        local pbuttons = {}
        local defs = {{"utilis", "Painel UTILIS"}, {"invis", "Painel INVIS"}, {"faceaway", "Painel FACE AWAY"}, {"noanim", "Painel NO ANIM"}, {"stealtarget", "Painel STEAL TARGET"}}
        local function refreshPanelButtons()
            for id, pb in pairs(pbuttons) do
                local on = _G.TT3PanelVisibility[id] ~= false
                pb.Text = pb:GetAttribute("Label") .. (on and ": ON" or ": OFF")
                pb.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
            end
        end
        for i, def in ipairs(defs) do
            local panelId, panelLabel = def[1], def[2]
            local pb = btn(panelLabel, 404 + (i - 1) * 27, settingsPanel, function()
                _G.TT3SetPanelVisible(panelId, _G.TT3PanelVisibility[panelId] == false)
            end)
            pb.Size = UDim2.new(1, -20, 0, 23); pb:SetAttribute("Label", panelLabel); pbuttons[panelId] = pb
        end
        local previousRefresh = _G.TT3RefreshPanelButtons
        _G.TT3RefreshPanelButtons = function()
            if previousRefresh then pcall(previousRefresh) end
            refreshPanelButtons()
        end
        refreshPanelButtons()
    end

    -- ============================================================
    -- STEAL TARGET (GUI SEPARE: sa PROPRE ScreenGui, toujours visible au lancement,
    -- independant du hub Teleport). Liste live des brainrots stealables. Clic sur
    -- une ligne = selectionne cette cible pour le Manual TP/la touche TP; le clic
    -- ne deplace pas le personnage. Re-clic = deverrouille. Refresh 0.4s.
    -- ============================================================
    do
        pcall(function()
            local _old = guiParent:FindFirstChild("TT3StealTargetUI")
            if _old then _old:Destroy() end
        end)
        local stg = Instance.new("ScreenGui")
        stg.Name = "TT3StealTargetUI"
        stg.ResetOnSpawn = false
        stg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() stg.Parent = guiParent end)
        if not stg.Parent then stg.Parent = PG end
        if _G.TT3RegisterPanel then _G.TT3RegisterPanel("stealtarget", stg) end

        local stealTargetPanel = Instance.new("Frame", stg)
        stealTargetPanel.Name = "StealTarget"
        stealTargetPanel.Active = true
        stealTargetPanel.Size = UDim2.fromOffset(210, 290)
        fitMobilePanel(stealTargetPanel, 0.78)
        stealTargetPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        stealTargetPanel.BorderSizePixel = 0
        Instance.new("UICorner", stealTargetPanel).CornerRadius = UDim.new(0, 10)
        do local outline = Instance.new("UIStroke", stealTargetPanel); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
        _restorePos("stealtarget", stealTargetPanel, 300, 200)
        task.defer(function() clampPanelToViewport(stealTargetPanel) end)

        local pt = Instance.new("TextButton", stealTargetPanel)
        pt.Size = UDim2.new(1, 0, 0, 30)
        pt.BackgroundTransparency = 1
        pt.Text = "STEAL TARGET"
        pt.Font = Enum.Font.GothamBlack
        pt.TextSize = 13
        pt.TextColor3 = Color3.new(1, 1, 1)
        pt.AutoButtonColor = false
        pt.Active = true
        makeDraggable(pt, stealTargetPanel, "stealtarget")
        if not IS_MOBILE then makeDraggable(stealTargetPanel, stealTargetPanel, "stealtarget") end

        -- A barra de porcentagem agora pertence ao painel de alvos.
        ensureStealBar()
        if stealBarWrap then
            stealBarWrap.Parent = stealTargetPanel
            stealBarWrap.AnchorPoint = Vector2.new(0, 0)
            stealBarWrap.Position = UDim2.new(0, 6, 1, -48)
            stealBarWrap.Size = UDim2.new(1, -12, 0, 42)
            stealBarWrap.ZIndex = 8
        end

        local scroll = Instance.new("ScrollingFrame", stealTargetPanel)
        scroll.Size = UDim2.new(1, -12, 1, -92)
        scroll.Position = UDim2.new(0, 6, 0, 36)
        scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = Color3.fromRGB(115, 115, 115)
        scroll.CanvasSize = UDim2.new()
        Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 3)
        local spad = Instance.new("UIPadding", scroll)
        spad.PaddingTop = UDim.new(0, 4); spad.PaddingBottom = UDim.new(0, 4)
        spad.PaddingLeft = UDim.new(0, 4); spad.PaddingRight = UDim.new(0, 4)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        local function stopPhysicalWalk()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local removed = false
            if root then
                for _, child in ipairs(root:GetChildren()) do
                    if child.Name == "TT3PhysicalTargetMover" then
                        pcall(function() child:Destroy() end)
                        removed = true
                    end
                end
                if removed then vZero(root) end
            end
            _G.TT3WalkToTargetActive = false
        end
        _G.TT3StopPhysicalTargetWalk = stopPhysicalWalk
        _G.TT3CanTPToTarget = nil

        local function fmtVal(v)
            v = tonumber(v) or 0
            if v >= 1e9 then return string.format("%.1fB", v / 1e9) end
            if v >= 1e6 then return string.format("%.1fM", v / 1e6) end
            if v >= 1e3 then return string.format("%.1fK", v / 1e3) end
            return tostring(math.floor(v))
        end

        -- rebuild UNIQUEMENT quand l ensemble des brainrots change (signature).
        -- Avant, la liste se reconstruisait toutes les 0.4s -> les boutons etaient
        -- detruits sous le curseur -> clic perdu (fallait cliquer plusieurs fois).
        -- Maintenant le clic ne fait que recolorer (applyHighlight), zero rebuild.
        local rowByUid, lastSig = {}, nil

        local function applyHighlight()
            local locked = _G.TT3StealTargetUID
            for uid, row in pairs(rowByUid) do
                if row.Parent then
                    row.BackgroundColor3 = (uid == locked) and Color3.fromRGB(96, 96, 96) or Color3.fromRGB(43, 43, 43)
                end
            end
        end

        local function rebuild(pets)
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            rowByUid = {}
            for i, p in ipairs(pets) do
                local uid = _petUid(p)
                local row = Instance.new("Frame", scroll)
                row.Size = UDim2.new(1, -4, 0, 32)
                row.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
                rowByUid[uid] = row


                local nm = Instance.new("TextLabel", row)
                nm.Size = UDim2.new(1, -16, 0, 16)
                nm.Position = UDim2.fromOffset(8, 3)
                nm.BackgroundTransparency = 1
                nm.Font = Enum.Font.GothamBold
                nm.TextSize = 12
                nm.TextColor3 = Color3.new(1, 1, 1)
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Text = p.name or "?"

                local sub = Instance.new("TextLabel", row)
                sub.Size = UDim2.new(1, -16, 0, 12)
                sub.Position = UDim2.fromOffset(8, 18)
                sub.BackgroundTransparency = 1
                sub.Font = Enum.Font.Gotham
                sub.TextSize = 11
                sub.TextColor3 = Color3.fromRGB(255, 255, 255)
                sub.TextXAlignment = Enum.TextXAlignment.Left
                sub.Text = fmtVal(p.mps) .. "/s"

                local click = Instance.new("TextButton", row)
                click.Size = UDim2.new(1, 0, 1, 0)
                click.BackgroundTransparency = 1
                click.Text = ""
                click.Activated:Connect(function()
                    if _G.TT3StealTargetUID == uid then
                        _clearTPSync()
                        stopPhysicalWalk()
                        notify("TARGET", "cleared")
                    else
                        -- O clique somente seleciona/destaca; não inicia movimento nem TP.
                        _G.TT3StealTargetUID = uid
                        _G.TT3StealTarget = p
                        _G.TT3TPSyncActive = true
                        applyHighlight()
                        notify("TARGET", p.name or "?")
                    end
                    applyHighlight()
                end)
            end
        end

        local function refresh()
            if not (stealTargetPanel and stealTargetPanel.Visible) then return end
            local ok, pets = pcall(scanAllPets)
            if not ok or type(pets) ~= "table" then return end
            local locked, stillThere, sig = _G.TT3StealTargetUID, false, ""
            for _, p in ipairs(pets) do
                local u = _petUid(p)
                sig = sig .. u .. "|"
                if u == locked then stillThere = true end
            end
            -- cible verrouillee disparue (volee/despawn) -> on libere le lock
            if locked and locked ~= "" and not stillThere then _clearTPSync() end
            if sig ~= lastSig then lastSig = sig; rebuild(pets) end
            applyHighlight()
        end

        task.spawn(function()
            while stealTargetPanel and stealTargetPanel.Parent do
                pcall(refresh)
                task.wait(0.4)
            end
        end)
    end

    -- ============================================================
    -- EDITEUR DE LISTE PRIORITE (panneau secondaire, ouvert par l engrenage)
    -- Perf: la liste UI n est reconstruite QUE sur modif (add/remove/reorder),
    -- jamais par frame. Le steal utilise le cache _priLookup() invalide par
    -- _G.TT3PriVersion, donc l edition est prise en compte instantanement.
    -- ============================================================
    local priorityPanel
    openPriorityEditor = function()
        if priorityPanel and priorityPanel.Parent then
            priorityPanel.Visible = not priorityPanel.Visible
            if priorityPanel.Visible then
                if not _G._stp_pos["priority"] then
                    priorityPanel.Position = UDim2.fromOffset(f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
                end
                priorityPanel.ZIndex = 30
                task.defer(function() clampPanelToViewport(priorityPanel) end)
            end
            return
        end

        local function _pnorm(s) return tostring(s):lower():gsub("[%s%-_'%.]", "") end

        -- DEUX categories editables: "brainrot" (liste de noms) et "mutation"
        -- (liste de mutations). currentTab dit laquelle on affiche/edite.
        local currentTab = "brainrot"
        local function activeShared()
            if currentTab == "mutation" then
                if type(_G.SHARED_MUTATION_ITEMS) ~= "table" then _G.SHARED_MUTATION_ITEMS = {} end
                return _G.SHARED_MUTATION_ITEMS
            end
            if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
            return _G.SHARED_PRIORITY_ITEMS
        end
        local function activeDefault()
            if currentTab == "mutation" then return _G.TT3MutationDefault or {} end
            return _G.TT3PriorityDefault or {}
        end

        -- liste ACTIVE toujours garantie non-nil; si vide -> recopie le defaut
        local function getList()
            local L = activeShared()
            if #L == 0 then
                local d = activeDefault()
                for i = 1, #d do L[i] = d[i] end
            end
            return L
        end
        local function commit()
            if currentTab == "mutation" then
                _G.TT3MutVersion = (_G.TT3MutVersion or 0) + 1  -- invalide le cache mutation
            else
                _G.TT3PriVersion = (_G.TT3PriVersion or 0) + 1  -- invalide le cache steal
            end
            saveTpSettings()
        end
        -- remplace la liste EN PLACE (garde la reference). alsoDefault => devient
        -- aussi la liste par defaut (RESET), persistee dans le json.
        local function setList(newList, alsoDefault)
            local L = getList()
            table.clear(L)
            local seen = {}
            for _, v in ipairs(newList) do
                if type(v) == "string" then
                    local s = v:gsub("^%s+", ""):gsub("%s+$", ""):lower()
                    local k = _pnorm(s)
                    if s ~= "" and not seen[k] then seen[k] = true; L[#L + 1] = s end
                end
            end
            if alsoDefault then
                local d = {}
                for i = 1, #L do d[i] = L[i] end
                if currentTab == "mutation" then _G.TT3MutationDefault = d
                else _G.TT3PriorityDefault = d end
            end
            commit()
        end
        -- parse un JSON (["a","b"]) OU un collage libre ("a","b", / lignes)
        local function parseList(text)
            if type(text) ~= "string" or text == "" then return nil end
            local out = {}
            local ok, dec = pcall(function() return HS:JSONDecode(text) end)
            if ok and type(dec) == "table" then
                for _, v in ipairs(dec) do
                    if type(v) == "string" and v ~= "" then out[#out + 1] = v end
                end
                if #out > 0 then return out end
            end
            for s in text:gmatch('"([^"]*)"') do
                if s ~= "" then out[#out + 1] = s end
            end
            if #out > 0 then return out end
            for s in text:gmatch("[^,\r\n]+") do
                s = s:gsub("^%s+", ""):gsub("%s+$", "")
                if s ~= "" then out[#out + 1] = s end
            end
            return (#out > 0) and out or nil
        end
        local function getClip()
            for _, fn in ipairs({ getclipboard, get_clipboard, getrbxclipboard }) do
                if type(fn) == "function" then
                    local ok, r = pcall(fn)
                    if ok and type(r) == "string" and r ~= "" then return r end
                end
            end
            return nil
        end
        -- SOURCE des predictions: data du jeu (tous les brainrots) + liste defaut.
        -- Construite UNE seule fois puis mise en cache -> zero cout par frappe.
        local _suggCache = {}
        local function suggestions()
            if _suggCache[currentTab] then return _suggCache[currentTab] end
            local set, out = {}, {}
            local function add(n)
                if type(n) == "string" and n ~= "" then
                    local k = n:lower()
                    if not set[k] then set[k] = true; out[#out + 1] = k end
                end
            end
            if currentTab == "mutation" then
                -- predictions mutation = la liste par defaut des mutations
                for _, n in ipairs(_G.TT3MutationDefault or {}) do add(n) end
            else
                for _, n in ipairs(_G.TT3PriorityDefault or {}) do add(n) end
                pcall(function()
                    local Datas = RS:FindFirstChild("Datas")
                    local A = Datas and Datas:FindFirstChild("Animals")
                    if not A then return end
                    local data = require(A)
                    if type(data) ~= "table" then return end
                    for key, info in pairs(data) do
                        if type(info) == "table" then add(info.DisplayName or key)
                        elseif type(key) == "string" then add(key) end
                    end
                end)
            end
            table.sort(out)
            _suggCache[currentTab] = out
            return out
        end

        -- forward decls (les handlers de prediction appellent addItem/rebuild)
        local rebuild, addItem, refreshSuggestions, hideSuggestions
        local switchTab, refreshTabs
        local tabBrainrot, tabMutation

        priorityPanel = Instance.new("Frame", sg)
        priorityPanel.Name = "PriorityList"
        priorityPanel.Active = true
        priorityPanel.Size = UDim2.fromOffset(210, 290)
        fitMobilePanel(priorityPanel, 0.76)
        priorityPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        priorityPanel.BorderSizePixel = 0
        Instance.new("UICorner", priorityPanel).CornerRadius = UDim.new(0, 10)
        do local outline = Instance.new("UIStroke", priorityPanel); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
        _restorePos("priority", priorityPanel,
            f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
        priorityPanel.ZIndex = 30
        task.defer(function() clampPanelToViewport(priorityPanel) end)

        -- TITRE style "Keybind & Actions": texte transparent, PAS de barre de fond
        local pt = Instance.new("TextButton", priorityPanel)
        pt.Size = UDim2.new(1, 0, 0, 30)
        pt.BackgroundTransparency = 1
        pt.Text = "PRIORITY LIST"
        pt.Font = Enum.Font.GothamBlack
        pt.TextSize = 13
        pt.TextColor3 = Color3.new(1, 1, 1)
        pt.AutoButtonColor = false
        pt.Active = true
        makeDraggable(pt, priorityPanel, "priority")
        -- drag depuis n importe ou sur le fond du panneau (pas juste le titre).
        -- Les boutons/rows captent le clic en premier, donc seul le fond vide bouge.
        if not IS_MOBILE then makeDraggable(priorityPanel, priorityPanel, "priority") end

        -- ONGLETS: BRAINROT | MUTATIONS (choisit la liste editee/affichee)
        tabBrainrot = Instance.new("TextButton", priorityPanel)
        tabBrainrot.Size = UDim2.new(0.5, -10, 0, 22)
        tabBrainrot.Position = UDim2.fromOffset(8, 32)
        tabBrainrot.Font = Enum.Font.GothamBold; tabBrainrot.TextSize = 11
        tabBrainrot.TextColor3 = Color3.new(1, 1, 1); tabBrainrot.BorderSizePixel = 0
        tabBrainrot.Text = "BRAINROT"
        Instance.new("UICorner", tabBrainrot).CornerRadius = UDim.new(0, 5)
        tabMutation = Instance.new("TextButton", priorityPanel)
        tabMutation.Size = UDim2.new(0.5, -10, 0, 22)
        tabMutation.Position = UDim2.new(0.5, 2, 0, 32)
        tabMutation.Font = Enum.Font.GothamBold; tabMutation.TextSize = 11
        tabMutation.TextColor3 = Color3.new(1, 1, 1); tabMutation.BorderSizePixel = 0
        tabMutation.Text = "MUTATIONS"
        Instance.new("UICorner", tabMutation).CornerRadius = UDim.new(0, 5)
        refreshTabs = function()
            tabBrainrot.BackgroundColor3 = (currentTab == "brainrot") and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
            tabMutation.BackgroundColor3 = (currentTab == "mutation") and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
        end

        -- ligne d ajout: TextBox + bouton ADD
        local box = Instance.new("TextBox", priorityPanel)
        box.Visible = false
        box.Size = UDim2.new(1, -74, 0, 26)
        box.Position = UDim2.new(0, 8, 0, 62)
        box.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderText = "add a brainrot..."
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        box.Text = ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 12
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.ClipsDescendants = true
        box.ZIndex = 3
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local bpad = Instance.new("UIPadding", box)
        bpad.PaddingLeft = UDim.new(0, 6); bpad.PaddingRight = UDim.new(0, 6)

        local addBtn = Instance.new("TextButton", priorityPanel)
        addBtn.Visible = false
        addBtn.Size = UDim2.fromOffset(56, 26)
        addBtn.Position = UDim2.new(1, -64, 0, 62)
        addBtn.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        addBtn.Text = "ADD"
        addBtn.TextColor3 = Color3.new(1, 1, 1)
        addBtn.Font = Enum.Font.GothamBold
        addBtn.TextSize = 12
        addBtn.ZIndex = 3
        Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)

        -- DROPDOWN de predictions (flotte au-dessus de la liste)
        local sugFrame = Instance.new("Frame", priorityPanel)
        sugFrame.Position = UDim2.new(0, 8, 0, 90)
        sugFrame.Size = UDim2.new(1, -74, 0, 0)
        sugFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sugFrame.BorderSizePixel = 0
        sugFrame.Visible = false
        sugFrame.ZIndex = 5
        sugFrame.ClipsDescendants = true
        Instance.new("UICorner", sugFrame).CornerRadius = UDim.new(0, 6)
        local sugLayout = Instance.new("UIListLayout", sugFrame)
        sugLayout.SortOrder = Enum.SortOrder.LayoutOrder

        hideSuggestions = function()
            sugFrame.Visible = false
            for _, c in ipairs(sugFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
        end
        refreshSuggestions = function()
            for _, c in ipairs(sugFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            local q = _pnorm(box.Text)
            if q == "" then sugFrame.Visible = false; return end
            local src = suggestions()
            local n, MAX = 0, 6
            for _, name in ipairs(src) do
                if _pnorm(name):find(q, 1, true) then
                    n = n + 1
                    local b = Instance.new("TextButton", sugFrame)
                    b.Size = UDim2.new(1, 0, 0, 22)
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    b.AutoButtonColor = true
                    b.Text = "  " .. name
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 12
                    b.ZIndex = 6
                    b.LayoutOrder = n
                    b.MouseButton1Click:Connect(function()
                        box.Text = name
                        hideSuggestions()
                        addItem()
                    end)
                    if n >= MAX then break end
                end
            end
            if n == 0 then sugFrame.Visible = false
            else sugFrame.Visible = true; sugFrame.Size = UDim2.new(1, -74, 0, n * 22) end
        end

        -- barre du bas: compteur + IMPORT + RESET
        local countLbl = Instance.new("TextLabel", priorityPanel)
        countLbl.Size = UDim2.new(0, 60, 0, 24)
        countLbl.Position = UDim2.new(0, 10, 1, -30)
        countLbl.BackgroundTransparency = 1
        countLbl.Font = Enum.Font.Gotham
        countLbl.TextSize = 11
        countLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        countLbl.TextXAlignment = Enum.TextXAlignment.Left

        local importBtn = Instance.new("TextButton", priorityPanel)
        importBtn.Size = UDim2.fromOffset(78, 24)
        importBtn.Position = UDim2.new(1, -162, 1, -30)
        importBtn.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
        importBtn.Text = "IMPORT"
        importBtn.TextColor3 = Color3.new(1, 1, 1)
        importBtn.Font = Enum.Font.GothamBold
        importBtn.TextSize = 11
        Instance.new("UICorner", importBtn).CornerRadius = UDim.new(0, 6)

        local resetBtn = Instance.new("TextButton", priorityPanel)
        resetBtn.Size = UDim2.fromOffset(72, 24)
        resetBtn.Position = UDim2.new(1, -80, 1, -30)
        resetBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
        resetBtn.Text = "RESET"
        resetBtn.TextColor3 = Color3.new(1, 1, 1)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 11
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

        local scroll = Instance.new("ScrollingFrame", priorityPanel)
        scroll.Size = UDim2.new(1, -12, 1, -100)
        scroll.Position = UDim2.new(0, 6, 0, 62)
        scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = Color3.fromRGB(115, 115, 115)
        scroll.CanvasSize = UDim2.new()
        Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 3)
        local spad = Instance.new("UIPadding", scroll)
        spad.PaddingTop = UDim.new(0, 4); spad.PaddingBottom = UDim.new(0, 4)
        spad.PaddingLeft = UDim.new(0, 4); spad.PaddingRight = UDim.new(0, 4)
        -- canvas manuel (compatible partout, pas de AutomaticCanvasSize)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        rebuild = function()
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            local list = getList()
            countLbl.Text = #list .. " items"
            for i, name in ipairs(list) do
                local row = Instance.new("Frame", scroll)
                row.Size = UDim2.new(1, -4, 0, 26)
                row.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)


                local nm = Instance.new("TextLabel", row)
                nm.Size = UDim2.new(1, -86, 1, 0)
                nm.Position = UDim2.fromOffset(8, 0)
                nm.BackgroundTransparency = 1
                nm.Font = Enum.Font.Gotham
                nm.TextSize = 11
                nm.TextColor3 = Color3.new(1, 1, 1)
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Text = name

                local function miniBtn(txt, xoff, col)
                    local b = Instance.new("TextButton", row)
                    b.Size = UDim2.fromOffset(24, 20)
                    b.Position = UDim2.new(1, xoff, 0.5, -10)
                    b.BackgroundColor3 = col
                    b.Text = txt
                    b.TextColor3 = Color3.new(1, 1, 1)
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 13
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    return b
                end
                local up = miniBtn("\u{25B2}", -82, Color3.fromRGB(58, 58, 58))  -- monter
                local dn = miniBtn("\u{25BC}", -56, Color3.fromRGB(58, 58, 58))  -- descendre
                local rm = miniBtn("\u{00D7}", -28, Color3.fromRGB(95, 40, 40))  -- supprimer (x)
                rm.TextSize = 18

                up.MouseButton1Click:Connect(function()
                    if i > 1 then
                        list[i], list[i - 1] = list[i - 1], list[i]
                        commit(); rebuild()
                    end
                end)
                dn.MouseButton1Click:Connect(function()
                    if i < #list then
                        list[i], list[i + 1] = list[i + 1], list[i]
                        commit(); rebuild()
                    end
                end)
                rm.MouseButton1Click:Connect(function()
                    table.remove(list, i)
                    commit(); rebuild()
                end)
            end
        end

        addItem = function()
            local v = box.Text
            if type(v) ~= "string" then return end
            v = v:gsub("^%s+", ""):gsub("%s+$", "")
            if v == "" then return end
            local list = getList()
            local key = _pnorm(v)
            for _, e in ipairs(list) do
                if _pnorm(e) == key then
                    notify("PRIORITY", "already in list"); box.Text = ""; hideSuggestions(); return
                end
            end
            list[#list + 1] = v:lower()
            box.Text = ""
            hideSuggestions()
            commit(); rebuild()
            notify("PRIORITY", "+ " .. v)
        end
        addBtn.MouseButton1Click:Connect(addItem)
        box:GetPropertyChangedSignal("Text"):Connect(refreshSuggestions)
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then addItem() end
            -- petit delai: laisse le clic sur une prediction s enregistrer avant de cacher
            task.delay(0.15, function() if hideSuggestions then hideSuggestions() end end)
        end)

        resetBtn.MouseButton1Click:Connect(function()
            local list = getList()
            table.clear(list)
            for i = 1, #(_G.TT3PriorityDefault or {}) do list[i] = _G.TT3PriorityDefault[i] end
            commit(); rebuild()
            notify("PRIORITY", "default list")
        end)

        -- IMPORT: overlay avec TextBox multiligne (prerempli avec le presse-papier
        -- si dispo). Colle un JSON ["a","b"] ou une liste "a","b", -> ca importe
        -- ET ca devient la liste par defaut.
        importBtn.MouseButton1Click:Connect(function()
            local ov = Instance.new("Frame", priorityPanel)
            ov.Size = UDim2.new(1, -12, 1, -76)
            ov.Position = UDim2.new(0, 6, 0, 70)
            ov.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            ov.BorderSizePixel = 0
            ov.ZIndex = 10
            Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 6)

            local ib = Instance.new("TextBox", ov)
            ib.Size = UDim2.new(1, -12, 1, -44)
            ib.Position = UDim2.new(0, 6, 0, 6)
            ib.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            ib.TextColor3 = Color3.new(1, 1, 1)
            ib.PlaceholderText = 'paste JSON: ["headless horseman", ...]'
            ib.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            ib.MultiLine = true
            ib.ClearTextOnFocus = false
            ib.TextXAlignment = Enum.TextXAlignment.Left
            ib.TextYAlignment = Enum.TextYAlignment.Top
            ib.TextWrapped = true
            ib.Font = Enum.Font.Code
            ib.TextSize = 11
            ib.ZIndex = 11
            ib.Text = getClip() or ""
            Instance.new("UICorner", ib).CornerRadius = UDim.new(0, 6)
            local ibp = Instance.new("UIPadding", ib)
            ibp.PaddingLeft = UDim.new(0, 6); ibp.PaddingRight = UDim.new(0, 6)
            ibp.PaddingTop = UDim.new(0, 4)

            local function mkBtn(txt, xoff, col)
                local b = Instance.new("TextButton", ov)
                b.Size = UDim2.fromOffset(112, 30)
                b.Position = UDim2.new(0, xoff, 1, -36)
                b.BackgroundColor3 = col
                b.Text = txt
                b.TextColor3 = Color3.new(1, 1, 1)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.ZIndex = 11
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                return b
            end
            local loadB = mkBtn("IMPORT", 6, Color3.fromRGB(95, 95, 95))
            local cancelB = mkBtn("CANCEL", 122, Color3.fromRGB(66, 66, 66))

            loadB.MouseButton1Click:Connect(function()
                local parsed = parseList(ib.Text)
                if not parsed or #parsed == 0 then
                    notify("IMPORT", "no valid names"); return
                end
                setList(parsed, true)   -- devient aussi la liste par defaut
                rebuild()
                ov:Destroy()
                notify("IMPORT", #getList() .. " items loaded")
            end)
            cancelB.MouseButton1Click:Connect(function() ov:Destroy() end)
        end)

        switchTab = function(tab)
            if tab == currentTab then return end
            currentTab = tab
            box.Text = ""
            box.PlaceholderText = (tab == "mutation") and "add a mutation..." or "add a brainrot..."
            if hideSuggestions then hideSuggestions() end
            refreshTabs()
            rebuild()
        end
        tabBrainrot.Activated:Connect(function() switchTab("brainrot") end)
        tabMutation.Activated:Connect(function() switchTab("mutation") end)
        refreshTabs()

        rebuild()
    end

    btn("TP SETTINGS", 140, f, function()
        openSettings()
        notify("SETTINGS", "ouvre le panneau a droite")
    end)

    task.delay(1.5, function()
        notify("GUI", "drag le titre | TP SETTINGS pour les sliders")
    end)
end

-- ============================================================
-- FPS OPTIMIZER / FPS-PING HUB LEAKED
-- Sem Config, sem UI de configurações e sem keybinds extras.
-- ============================================================
do
    local _FPS_RS = game:GetService("RunService")
    local _FPS_STATS = game:GetService("Stats")
    local _FPS_LIGHTING = game:GetService("Lighting")
    local _FPS_MATERIAL = game:GetService("MaterialService")
    local _FPS_PLAYERS = game:GetService("Players")
    local _FPS_LP = _FPS_PLAYERS.LocalPlayer
    local _FPS_PG = _FPS_LP:WaitForChild("PlayerGui")

    -- FPS Optimizer do Hub Leaked.
    _G.ApplyFPSBoost = _G.ApplyFPSBoost or function()
        if _G.FPSBoostApplied then return end
        _G.FPSBoostApplied = true
        task.spawn(function()
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
                settings().Physics.AllowSleep = true
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
            end)
            pcall(function()
                if sethiddenproperty then sethiddenproperty(_FPS_LIGHTING, "Technology", Enum.Technology.Compatibility) end
            end)
            pcall(setfpscap, 999)
            local function strip(inst)
                pcall(function()
                    if inst:IsA("Decal") or inst:IsA("Texture") then
                        if inst.Name ~= "face" then inst:Destroy() end
                    elseif inst:IsA("SpecialMesh") then
                        inst.TextureId = ""
                    elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail")
                        or inst:IsA("PointLight") or inst:IsA("SpotLight")
                        or inst:IsA("SurfaceLight") or inst:IsA("Fire")
                        or inst:IsA("Smoke") or inst:IsA("Sparkles")
                        or inst:IsA("Explosion") then
                        inst:Destroy()
                    elseif inst:IsA("BasePart") then
                        inst.CastShadow = false
                        inst.Material = Enum.Material.SmoothPlastic
                        inst.MaterialVariant = ""
                        inst.Reflectance = 0
                    end
                end)
            end
            pcall(function()
                _FPS_LIGHTING.GlobalShadows = false
                _FPS_LIGHTING.FogEnd = 9e9
                _FPS_LIGHTING.FogStart = 9e9
                _FPS_LIGHTING.EnvironmentDiffuseScale = 0
                _FPS_LIGHTING.EnvironmentSpecularScale = 0
                for _, obj in ipairs(_FPS_LIGHTING:GetChildren()) do
                    if obj:IsA("PostEffect") then obj.Enabled = false
                    elseif obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("Sky") then obj:Destroy() end
                end
            end)
            pcall(function()
                local terrain = workspace.Terrain
                terrain.Decoration = false
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end)
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants, 5000 do
                for j = i, math.min(i + 4999, #descendants) do
                    if descendants[j] and descendants[j].Parent then strip(descendants[j]) end
                end
                task.wait()
            end
            workspace.DescendantAdded:Connect(function(inst) strip(inst) end)
            _FPS_LIGHTING.DescendantAdded:Connect(function(inst)
                pcall(function()
                    if inst:IsA("PostEffect") then inst.Enabled = false
                    elseif inst:IsA("Atmosphere") or inst:IsA("Clouds") then inst:Destroy() end
                end)
            end)
            _FPS_MATERIAL.DescendantAdded:Connect(function(inst) pcall(function() inst:Destroy() end) end)
            for _, player in ipairs(_FPS_PLAYERS:GetPlayers()) do
                if player.Character then
                    for _, inst in ipairs(player.Character:GetDescendants()) do strip(inst) end
                end
                player.CharacterAdded:Connect(function(char)
                    task.wait(0.3)
                    for _, inst in ipairs(char:GetDescendants()) do strip(inst) end
                end)
            end
        end)
    end
    pcall(_G.ApplyFPSBoost)
end


-- ============================================================
-- GRAPPLE HOOK / GRABBLE TP - lógica original do Hub Leaked
-- Substitui o disparo remoto simples pelo hook visual/physics-safe.
-- ============================================================
do
    local _GH_RS = game:GetService("RunService")
    local _GH_RSVC = game:GetService("ReplicatedStorage")
    local _GH_LP = game:GetService("Players").LocalPlayer
    local function _GH_fireGrapple()
        local character = _GH_LP.Character
        if not character then return false end
        local root = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChildOfClass("Humanoid")
        local backpack = _GH_LP:FindFirstChild("Backpack")
        local tool = (backpack and backpack:FindFirstChild("Grapple Hook")) or character:FindFirstChild("Grapple Hook")
        if not tool or not hum or not root then return false end
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.1)
        pcall(function()
            local beam = tool:FindFirstChild("Beam", true)
            if beam and beam:IsA("Beam") then
                beam.Width0 = 0; beam.Width1 = 0
                local c
                c = beam:GetPropertyChangedSignal("Width0"):Connect(function()
                    beam.Width0 = 0; beam.Width1 = 0
                end)
                task.delay(1, function() if c then c:Disconnect() end end)
            end
            for _, obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("Sound") then obj.Volume = 0 end
            end
        end)
        local flightSeen = false
        local flightConn = root.ChildAdded:Connect(function(obj)
            if obj:IsA("BodyVelocity") and obj.Name == "FlightPower" then
                flightSeen = true
                pcall(function() obj.MaxForce = Vector3.zero end)
            end
        end)
        local playerMouse
        pcall(function()
            local pm = _GH_RSVC:WaitForChild("Packages", 2):WaitForChild("PlayerMouse", 2)
            playerMouse = require(pm)
        end)
        local fakeTarget = Instance.new("Part")
        fakeTarget.Size = Vector3.new(2,2,2)
        fakeTarget.Anchored = true; fakeTarget.CanCollide = false; fakeTarget.Transparency = 1
        fakeTarget.CFrame = root.CFrame * CFrame.new(0, 0, -11)
        fakeTarget.Parent = workspace
        local oldHit, oldTarget
        if playerMouse then
            oldHit, oldTarget = playerMouse.Hit, playerMouse.Target
            playerMouse.Hit = fakeTarget.CFrame
            playerMouse.Target = fakeTarget
        end
        local started = os.clock()
        while not flightSeen and os.clock() - started < 4 do
            pcall(function() tool:Activate() end)
            task.wait(0.05)
            local slice = os.clock()
            while not flightSeen and os.clock() - slice < 0.1 do _GH_RS.Heartbeat:Wait() end
        end
        if playerMouse then playerMouse.Hit = oldHit; playerMouse.Target = oldTarget end
        if flightConn then flightConn:Disconnect() end
        if fakeTarget then fakeTarget:Destroy() end
        return flightSeen
    end
    _G.TT3FireGrapple = _GH_fireGrapple
    _G.XenFireGrapple2 = _GH_fireGrapple
    _G.CLTHUBFireGrapple = _GH_fireGrapple
end
