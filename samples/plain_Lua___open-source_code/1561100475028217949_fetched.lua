-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]
local print = print
if not _G.SXEFreeVerboso then
    local frases = {
        "[HERESY] warming up the spaghetti reactor...",
        "[HERESY] asking the server politely for permission",
        "[HERESY] counting all the pixels, please hold",
        "[HERESY] reticulating splines (37% done)",
        "[HERESY] the hamster is tired, deploying second hamster",
        "[HERESY] downloading more RAM",
        "[HERESY] teaching the brainrots to sit",
        "[HERESY] bribing the physics engine",
        "[HERESY] this log is intentionally useless",
        "[HERESY] converting vibes into frames per second",
        "[HERESY] sharpening the pointy brackets",
        "[HERESY] the cake is a lie, the pets are not",
        "[HERESY] rerouting power from life support to cosmetics",
        "[HERESY] negotiating with the lag",
        "[HERESY] pretending to compute something important",
        "[HERESY] if you are reading this, you are early",
        "[HERESY] feeding the loop, do not disturb",
        "[HERESY] all systems nominal, probably",
        "[HERESY] tightening one (1) loose bolt",
        "[HERESY] the answer is 42, the question is pending",
    }
    local convites = {
        ">> HERESY FREE  --  join discord.gg/heresy for updates",
        ">> get the full version at discord.gg/heresy",
        ">> stuck? support lives at discord.gg/heresy",
        ">> discord.gg/heresy  --  giveaways, updates, help",
        ">> HERESY HUB FREE  --  discord.gg/heresy",
        ">> tell your friends: discord.gg/heresy",
    }
    local n = 0
    local function troll()
        n = n + 1
        if n % 4 == 0 then
            return convites[math.random(1, #convites)]
        end
        return frases[math.random(1, #frases)]
    end
    local real = print
    print = function() real(troll()) end
    task.spawn(function()
        while true do
            task.wait(45)
            real(convites[math.random(1, #convites)])
        end
    end)
    real(">> HERESY HUB  FREE EDITION  --  discord.gg/heresy")
end
_G.SXEBuscaGui = function(nome)
    local alvo = (gethui and gethui()) or game:GetService("CoreGui")
    local r
    pcall(function() r = alvo and alvo:FindFirstChild(nome) end)
    if r then return r end
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer
            :FindFirstChildOfClass("PlayerGui")
        r = pg and pg:FindFirstChild(nome)
    end)
    return r
end
do
    task.spawn(function()
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local pkgs = RS:WaitForChild("Packages", 120)
            require(pkgs:WaitForChild("Synchronizer", 120))
            local datas = RS:WaitForChild("Datas", 60)
            require(datas:WaitForChild("Animals", 60))
            require(datas:WaitForChild("Mutations", 30))
            require(datas:WaitForChild("Traits", 30))
            local utils = RS:WaitForChild("Utils", 30)
            require(utils:WaitForChild("NumberUtils", 30))
            pkgs:WaitForChild("Net", 30)
        end)
    end)
    task.spawn(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        for _ = 1, 20 do
            pcall(function()
                local c = lp and lp.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h and h.Anchored then h.Anchored = false end
            end)
            task.wait(0.25)
        end
    end)
end
if not game:IsLoaded() then game.Loaded:Wait() end
_G.__LT = os.clock()
_G.__LMARK = function(name) print(("[LOAD] %-22s %6.2fs"):format(name, os.clock() - _G.__LT)) end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
UIS = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Stats = game:GetService("Stats")
TweenService = game:GetService("TweenService")
HttpService = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
TeleportService = game:GetService("TeleportService")
CoreGui = game:GetService("CoreGui")
VirtualInputManager = game:GetService("VirtualInputManager")
do
local _xchan
local _lastTry, _attempts = 0, 0
local _deepScans, _lastDeep = 0, 0
local _mod
local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
local MAX_DEEP, DEEP_GAP = 3, 1.5
local function _retryGap()
    if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
    return RETRY_GAP
end
local function _channelCount(t)
    if type(t) ~= "table" then return 0 end
    local ok, hits = pcall(function()
        local h, n = 0, 0
        for _, v in next, t do
            n = n + 1
            if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                h = h + 1
            end
            if n >= 200 then break end
        end
        return h
    end)
    return (ok and hits) or 0
end
local function _module()
    if _mod then return _mod end
    local ok, m = pcall(function()
        return require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
    end)
    if ok and type(m) == "table" then _mod = m; return _mod end
    local ok2, m2 = pcall(function()
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local sync = pkgs and pkgs:FindFirstChild("Synchronizer")
        if not sync then return nil end
        return require(sync)
    end)
    if ok2 and type(m2) == "table" then _mod = m2 end
    return _mod
end
local function _probe(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local ok, up = pcall(gu, mod.Get, 9)
    if ok and type(up) == "table" then
        consider(rawget(up, 3), "Get/9/3")
        if bestN > 0 then return best, bestN, where end
        consider(up, "Get/9")
        if bestN > 0 then return best, bestN, where end
    end
    return nil, 0, nil
end
local function _deepScan(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    for fname, fn in next, mod do
        if type(fn) == "function" then
            for i = 1, 24 do
                local o, u = pcall(gu, fn, i)
                if not o then break end
                if type(u) == "table" then
                    consider(u, tostring(fname) .. "/" .. i)
                    for j = 1, 4 do
                        consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                    end
                end
            end
        end
    end
    return best, bestN, where
end
local function _chans()
    if _xchan then return _xchan end
    if (os.clock() - _lastTry) <= _retryGap() then return nil end
    _lastTry = os.clock()
    local mod = _module()
    if not mod or _attempts >= MAX_ATTEMPTS then return nil end
    _attempts = _attempts + 1
    local found, n, where = _probe(mod)
    if not found and _deepScans < MAX_DEEP and (os.clock() - _lastDeep) > DEEP_GAP then
        _lastDeep = os.clock()
        _deepScans = _deepScans + 1
        found, n, where = _deepScan(mod)
    end
    if found then
        _xchan = found
        _G.XenSyncDiag = string.format("bypassed via %s - %d channels (attempt %d)",
            tostring(where), n, _attempts)
    elseif _attempts >= MAX_ATTEMPTS then
        _G.XenSyncDiag = "channels NOT found after " .. MAX_ATTEMPTS
            .. " attempts - plot scanning is disabled"
    end
    return _xchan
end
_G.XenSyncAll=function()return _chans()end
_G.XenSyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
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
_G._xenRawCT=function(plotName)
local c=_G.XenSyncGet(plotName)
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
_G._xenGen=function(index,mutation,traits)
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
_G._xenAnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._xenGen(index,mutation,traits)end},{
__index=function(_,k)
local ok,real=pcall(function()return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))end)
if ok and type(real)=="table" then return rawget(real,k) end
return nil
end})
_G.SXE_GetPlotChannel=function(plotName)return _G.XenSyncGet(plotName)end
_G.SXE_GetAllPlots=function()return _G.XenSyncAll() or {} end
_G.SXE_GetPlotAnimalList=function(plotName)
local ct=_G._xenRawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end
task.spawn(function()
    local WS = game:GetService("Workspace")
    local plots
    local t0 = os.clock()
    repeat
        plots = WS:FindFirstChild("Plots")
        if not plots then task.wait(0.05) end
    until plots or (os.clock() - t0) > 25
    if not plots then return end
    local done, warmT0 = {}, os.clock()
    while (os.clock() - warmT0) < 15 do
        local kids = plots:GetChildren()
        local pending = false
        for _, plot in ipairs(kids) do
            if not done[plot.Name] then
                local ch
                if _G.XenSyncGet then
                    local ord; pcall(function() ord = plot:GetAttribute("Order") end)
                    if ord ~= nil then ch = _G.XenSyncGet("Plot" .. tostring(ord)) end
                    if not ch then ch = _G.XenSyncGet(plot.Name) end
                end
                if ch then
                    pcall(function() if ch.Get then ch:Get("AnimalList"); ch:Get("Owner") end end)
                    local al = _G.sProp and _G.sProp(ch, "AnimalList")
                    if al ~= nil then done[plot.Name] = true else pending = true end
                else
                    pending = true
                end
            end
        end
        if not pending and #kids > 0 then break end
        task.wait(0.05)
    end
    if _G.__LMARK then _G.__LMARK("plot data force-loaded") end
end)
task.spawn(function()
    local Players = game:GetService("Players")
    local WS = game:GetService("Workspace")
    local lp = Players.LocalPlayer
    if not WS.StreamingEnabled then
        if _G.__LMARK then _G.__LMARK("stream-in skipped (no StreamingEnabled)") end
        return
    end
    local plots
    local t0 = os.clock()
    repeat plots = WS:FindFirstChild("Plots"); if not plots then task.wait(0.1) end
    until plots or (os.clock() - t0) > 25
    if not plots then return end
    local function plotPos(plot)
        local okp, pv = pcall(function() return plot:GetPivot().Position end)
        if okp and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    local pending = 0
    for _, plot in ipairs(plots:GetChildren()) do
        local pos = plotPos(plot)
        if pos then
            pending = pending + 1
            task.spawn(function()
                pcall(function() lp:RequestStreamAroundAsync(pos) end)
                pending = pending - 1
            end)
        end
    end
    local sw = os.clock()
    while pending > 0 and os.clock() - sw < 10 do task.wait(0.05) end
    if _G.__LMARK then _G.__LMARK("plots stream-in requested") end
end)
do
  if not _G.__SXENetBuilt then
    _G.__SXENetBuilt = true
    local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    local getupvalues = debug.getupvalues or getupvalues
    local getinfo = debug.getinfo or getinfo
    local F1, F2, secret
    local function isGuid(s)
        return type(s) == "string" and #s == 36
            and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
    end
    local _bufFromString = buffer.fromstring or function(s)
        local b = buffer.create(#s)
        buffer.writestring(b, 0, s)
        return b
    end
    local _lastBuild, _buildFails = 0, 0
    local function build()
        if F1 and secret then return true end
        if _buildFails >= 4 then return false end
        if (os.clock() - _lastBuild) < 15 then return false end
        _lastBuild = os.clock()
        _buildFails = _buildFails + 1
        local jobId = game.JobId
        local a, b
        local cands, seen = {}, {}
        local _srcMatches = 0
        local _srcSamples = {}
        local _cloneFn = clonefunction or function(f) return f end
        if not getgc then
            print("[SXE Net] build() FAILED - getgc not available")
            return false
        end
        for _, v in getgc(true) do
            if typeof(v) == "function" then
                local ok, info = pcall(getinfo, v)
                if ok and info and info.source then
                    local src = info.source
                    local matched = (src == "=ReplicatedStorage.Packages.Net.Net")
                        or (src:find("ReplicatedStorage", 1, true) and src:find("Net", 1, true))
                    if matched then
                        _srcMatches = _srcMatches + 1
                        if #_srcSamples < 5 then _srcSamples[#_srcSamples + 1] = src end
                        local ok2, ups = pcall(getupvalues, v)
                        if ok2 and ups then
                            for _, up in pairs(ups) do
                                if type(up) == "table" then
                                    local x, y, z = rawget(up, 1), rawget(up, 2), rawget(up, 3)
                                    if not a and type(x) == "function" and type(y) == "function" and type(z) == "string" then
                                        a, b = _cloneFn(x), _cloneFn(y)
                                    end
                                    for _, e in pairs(up) do
                                        if isGuid(e) and e ~= jobId and not seen[e] then seen[e] = true; cands[#cands + 1] = e end
                                    end
                                elseif isGuid(up) and up ~= jobId and not seen[up] then
                                    seen[up] = true; cands[#cands + 1] = up
                                end
                            end
                        end
                    end
                end
            end
        end
        if not a then
            print("[SXE Net] build() FAILED - no hashing functions found.")
            print("[SXE Net] Source matches:", _srcMatches, "Samples:", table.concat(_srcSamples, ", "))
            pcall(function()
                local children = netFolder:GetChildren()
                print("[SXE Net] Net folder has", #children, "children. First few:")
                for i = 1, math.min(5, #children) do
                    print("[SXE Net]   ", children[i].Name)
                end
            end)
            return false
        end
        F1, F2 = a, b
        local cipher = F2("UseItem", jobId)
        if #cands == 1 then secret = cands[1]; print("[SXE Net] build() OK (single candidate)"); return true end
        for _, sec in ipairs(cands) do
            local ok, h = pcall(function() return F1(_bufFromString(cipher), _bufFromString(sec .. jobId)) end)
            if ok and type(h) == "string" and netFolder:FindFirstChild("RE/" .. h) then secret = sec; print("[SXE Net] build() OK (multi candidate, resolved)"); return true end
        end
        print("[SXE Net] build() FAILED - found", #cands, "GUID candidates but none resolved a valid remote.")
        pcall(function()
            local children = netFolder:GetChildren()
            print("[SXE Net] Net folder has", #children, "children. First few:")
            for i = 1, math.min(5, #children) do
                print("[SXE Net]   ", children[i].Name)
            end
        end)
        return false
    end
    local _resolveWarned = {}
    local function resolve(prefix, name)
        local direct = netFolder:FindFirstChild(prefix .. "/" .. name)
        if direct then return direct end
        if not (F1 and secret) and not build() then
            if not _resolveWarned[name] then
                _resolveWarned[name] = true
                print("[SXE Net] resolve('" .. name .. "') FAILED - build() failed and no unhashed '" .. prefix .. "/" .. name .. "' found.")
            end
            return nil
        end
        local jobId = game.JobId
        local ok, h = pcall(function()
            local c = F2(name, jobId)
            return F1(_bufFromString(c), _bufFromString(secret .. jobId))
        end)
        if not ok or type(h) ~= "string" then
            if not _resolveWarned[name] then
                _resolveWarned[name] = true
                print("[SXE Net] resolve('" .. name .. "') FAILED - hash error:", tostring(h))
            end
            return nil
        end
        local remote = netFolder:FindFirstChild(prefix .. "/" .. h)
        if not remote then
            if not _resolveWarned[name] then
                _resolveWarned[name] = true
                print("[SXE Net] resolve('" .. name .. "') FAILED - remote '" .. prefix .. "/" .. h .. "' not found in Net folder.")
            end
            return nil
        end
        return remote
    end
    local function getRemoteAny(name)
        for _, pfx in ipairs({"RE", "RF", "URE"}) do
            local r = resolve(pfx, name)
            if r then return r end
        end
        return nil
    end
_G.Net = {
        RemoteEvent           = function(_, name) return resolve("RE", name) end,
        RemoteFunction        = function(_, name) return resolve("RF", name) end,
        UnreliableRemoteEvent = function(_, name) return resolve("URE", name) end,
        GetRemote             = function(_, name) return getRemoteAny(name) end,
    }
    _G.Net.FireServer = function(_, name, ...)
        local r = getRemoteAny(name)
        if not r then return false end
        local args = {...}
        if r:IsA("RemoteFunction") then
            return pcall(function() return r:InvokeServer(table.unpack(args)) end)
        else
            return pcall(function() r:FireServer(table.unpack(args)) end)
        end
    end
  end
end
do
    local _netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    local function _resolveAny(prefix, name)
        local direct = _netFolder:FindFirstChild(prefix .. "/" .. name)
        if direct then return direct end
        return nil
    end
    local function _getRemoteAny(name)
        for _, pfx in ipairs({"RE", "RF", "URE"}) do
            local r = _resolveAny(pfx, name)
            if r then return r end
        end
        if _G.Net and _G.Net.RemoteEvent then
            for _, pfx in ipairs({"RE", "RF", "URE"}) do
                local r = _G.Net[pfx == "RE" and "RemoteEvent" or (pfx == "RF" and "RemoteFunction" or "UnreliableRemoteEvent")]
                if r then
                    local ok, remote = pcall(r, _G.Net, name)
                    if ok and remote then return remote end
                end
            end
        end
        return nil
    end
    if _G.Net then
        _G.Net.GetRemote = function(_, name) return _getRemoteAny(name) end
        _G.Net.FireServer = function(_, name, ...)
            local r = _getRemoteAny(name)
            if not r then return false end
            local args = {...}
            if r:IsA("RemoteFunction") then
                return pcall(function() return r:InvokeServer(table.unpack(args)) end)
            else
                return pcall(function() r:FireServer(table.unpack(args)) end)
            end
        end
        local _origRE = _G.Net.RemoteEvent
        _G.Net.RemoteEvent = function(_, name)
            local r = _origRE and _origRE(_, name)
            if r then return r end
            return _getRemoteAny(name)
        end
    end
end
_G.SXE_FPS_CAP = _G.SXE_FPS_CAP or 999
do
    local function applyCap()
        if not setfpscap then return end
        pcall(setfpscap, tonumber(_G.SXE_FPS_CAP) or 999)
    end
    applyCap()
    task.spawn(function()
        while true do
            applyCap()
            task.wait(2)
        end
    end)
end
local function _newGUID()
    local hex = "0123456789abcdef"
    local t = {}
    for i = 1, 32 do t[#t+1] = hex:sub(math.random(1,16), math.random(1,16)) end
    return table.concat(t, "", 1, 8) .. "-" .. table.concat(t, "", 9, 12)
        .. "-" .. table.concat(t, "", 13, 16) .. "-" .. table.concat(t, "", 17, 20)
        .. "-" .. table.concat(t, "", 21, 32)
end
local function makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = game:GetService("RunService").Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                if currentY > plat.Position.Y + 0.1 then
                    plat.CanCollide = true
                else
                    plat.CanCollide = false
                end
            end
            lastY = currentY
        end
    end)
end
GUID = GUID or _G.SXE_RESET_GUID or _newGUID()
resetRemote = nil
instaResetCooldown = false
if _G.SXE_RESET_REMOTE ~= nil then
    if typeof(_G.SXE_RESET_REMOTE) == "Instance" then
        resetRemote = _G.SXE_RESET_REMOTE
    elseif type(_G.SXE_RESET_REMOTE) == "string" and _G.Net then
        pcall(function()
            resetRemote = (_G.Net.GetRemote and _G.Net:GetRemote(_G.SXE_RESET_REMOTE))
                or _G.Net:RemoteEvent(_G.SXE_RESET_REMOTE)
        end)
    end
end
_G.SXEGrappleValue = _G.SXEGrappleValue or 0.33
_G.__SXEUseItemPayload = _G.__SXEUseItemPayload or nil
do
    local RS = game:GetService("ReplicatedStorage")
    local netFolder = RS:WaitForChild("Packages"):WaitForChild("Net")
    local PAYLOAD_FILE = "sxe_grapple_payload.txt"
    local function isHashName(nm)
        return type(nm) == "string"
            and (nm:match("^RE/%x%x%x%x%x%x%x%x") or nm:match("^RF/%x%x%x%x%x%x%x%x")) ~= nil
    end
    local function isHashRemote(ch, className)
        return ch and ch:IsA(className) and isHashName(ch.Name)
    end
    local _dualCache
    local function findUseItemByDualHash()
        if _dualCache and _dualCache.Parent then return _dualCache end
        local reH, rfH = {}, {}
        for _, ch in ipairs(netFolder:GetChildren()) do
            local nm = ch.Name
            if type(nm) == "string" then
                local pfx, rest = nm:match("^(R[EF])/(.+)$")
                if pfx and rest and #rest >= 32 and rest:match("^%x%x%x%x%x%x%x%x") then
                    if pfx == "RE" then reH[rest] = ch else rfH[rest] = ch end
                end
            end
        end
        local found, count = nil, 0
        for h, ch in pairs(reH) do
            if rfH[h] then count = count + 1; found = ch end
        end
        if count == 1 then _dualCache = found; return found end
        return nil
    end
    _G.SXEFindUseItem = findUseItemByDualHash
    local function resolveHashed(name, className)
        className = className or "RemoteEvent"
        if name == "UseItem" then
            local d = findUseItemByDualHash()
            if d then return d end
        end
        local prefix = (className == "RemoteFunction") and "RF/" or "RE/"
        local children = netFolder:GetChildren()
        local aliasIdx
        for i, ch in ipairs(children) do
            if ch.Name == prefix .. name and ch:IsA(className) then aliasIdx = i; break end
        end
        if aliasIdx then
            if isHashRemote(children[aliasIdx - 1], className) then return children[aliasIdx - 1] end
            if isHashRemote(children[aliasIdx + 1], className) then return children[aliasIdx + 1] end
        end
        if _G.Net then
            local ok, r = pcall(function()
                return (_G.Net.GetRemote and _G.Net:GetRemote(name)) or _G.Net:RemoteEvent(name)
            end)
            if ok and typeof(r) == "Instance" and isHashName(r.Name) then return r end
        end
        return nil
    end
    _G.SXEResolveHashed = resolveHashed
    local function loadPersistedPayload()
        if _G.SXE_GRAPPLE_PAYLOAD then return _G.SXE_GRAPPLE_PAYLOAD end
        if not (readfile and isfile) then return nil end
        local ok, res = pcall(function()
            if not isfile(PAYLOAD_FILE) then return nil end
            local raw = readfile(PAYLOAD_FILE)
            local lines = {}
            for line in raw:gmatch("[^\n]+") do lines[#lines + 1] = line end
            local n = tonumber(lines[1]); if not n then return nil end
            local p = { n = n }
            for i = 1, n do
                local ln = lines[i + 1] or ""
                local tag, rest = ln:sub(1, 2), ln:sub(3)
                if tag == "s:" then p[i] = rest
                elseif tag == "n:" then p[i] = tonumber(rest)
                elseif tag == "b:" then p[i] = (rest == "true")
                else p[i] = nil end
            end
            return p
        end)
        return ok and res or nil
    end
    _G.__SXEUseItemPayload = loadPersistedPayload()
    task.spawn(function()
        local t0 = os.clock()
        while os.clock() - t0 < 60 do
            if findUseItemByDualHash() then
                print("[SXE] UseItem resolved: " .. _G.SXEFindUseItem().Name)
                return
            end
            task.wait(0.25)
        end
    end)
    _G.__SXEGrappleDisparar = function(tool, pos, alvo, char, RSv)
        local refs = _G.__SXEPMRefs
        if not refs then
            refs = {}
            local vistos = {}
            local function juntar(t)
                if type(t) == "table" and not vistos[t] then
                    vistos[t] = true; refs[#refs + 1] = t
                end
            end
            pcall(function() juntar(require(RSv.Packages.PlayerMouse)) end)
            pcall(function()
                for _, v in ipairs(getgc(true)) do
                    if type(v) == "table" and typeof(rawget(v, "Hit")) == "CFrame" then
                        local n = 0
                        for _ in pairs(v) do n = n + 1 end
                        if n <= 3 then juntar(v) end
                    end
                end
            end)
            _G.__SXEPMRefs = refs
        end
        local cam = workspace.CurrentCamera
        local camAntes = cam and cam.CFrame
        local camNova
        if cam then
            pcall(function()
                local m = game:GetService("UserInputService"):GetMouseLocation()
                local raio = cam:ViewportPointToRay(m.X, m.Y)
                local L = cam.CFrame:VectorToObjectSpace(raio.Direction).Unit
                local d = pos - cam.CFrame.Position
                if d.Magnitude > 0.01 then
                    d = d.Unit
                    camNova = CFrame.new(cam.CFrame.Position)
                            * (CFrame.lookAt(Vector3.zero, d)
                             * CFrame.lookAt(Vector3.zero, L):Inverse())
                end
            end)
        end
        local mira = CFrame.new(pos)
        local antes = {}
        for i, t in ipairs(refs) do
            antes[i] = { rawget(t, "Hit"), rawget(t, "Target") }
            pcall(function() t.Hit = mira; t.Target = alvo end)
        end
        if camNova then cam.CFrame = camNova end
        local ok = pcall(function() tool:Activate() end)
        if not ok then ok = pcall(function() firesignal(tool.Activated) end) end
        task.spawn(function()
            local RSvc = game:GetService("RunService")
            for _ = 1, 4 do
                if camNova and cam then cam.CFrame = camNova end
                for _, t in ipairs(refs) do
                    pcall(function() t.Hit = mira; t.Target = alvo end)
                end
                RSvc.Heartbeat:Wait()
            end
            if camNova and cam and camAntes then cam.CFrame = camAntes end
            for i, t in ipairs(refs) do
                local a = antes[i]
                pcall(function() t.Hit = a[1]; t.Target = a[2] end)
            end
        end)
        return ok
    end
    _G.SXEFireGrapple2 = function(value, exato)
        local r = resolveHashed("UseItem", "RemoteEvent")
        if not r then
            local t0 = os.clock()
            repeat
                task.wait(0.05)
                r = resolveHashed("UseItem", "RemoteEvent")
            until r or (os.clock() - t0) > 1.5
        end
        if not r then
            if not _G.__SXEGrappleWarned then
                _G.__SXEGrappleWarned = true
                print("[SXE] Grapple remote unresolved (Net folder still streaming?)")
            end
            return false
        end
        local RSv = game:GetService("ReplicatedStorage")
        local Plrs = game:GetService("Players")
        local eu = Plrs.LocalPlayer
        local char = eu and eu.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if eu:GetAttribute("Stealing") then return false end
        local tool = char:FindFirstChild("Grapple Hook")
        if not tool then
            local bp = eu:FindFirstChildOfClass("Backpack")
            local t2 = bp and bp:FindFirstChild("Grapple Hook")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not t2 or not hum then return false end
            pcall(function() hum:EquipTool(t2) end)
            local t0 = os.clock()
            repeat
                game:GetService("RunService").Heartbeat:Wait()
                char = eu.Character
                tool = char and char:FindFirstChild("Grapple Hook")
            until tool or os.clock() - t0 > 0.5
            if not tool then return false end
            hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
        end
        local par0 = RaycastParams.new()
        par0.FilterType = Enum.RaycastFilterType.Exclude
        par0.FilterDescendantsInstances = { char }
        if exato and typeof(value) == "Vector3" then
            local pos = value
            local m = (pos - hrp.Position).Magnitude
            if m < 10 or m > 50 then return false end
            local alvo
            local hit = workspace:Raycast(hrp.Position, pos - hrp.Position, par0)
            if hit then alvo = hit.Instance end
            if not alvo then
                for _, p in ipairs(workspace:GetPartBoundsInRadius(pos, 6)) do
                    if p:IsA("BasePart") and not p:IsDescendantOf(char) then alvo = p; break end
                end
            end
            if not alvo then return false end
            return _G.__SXEGrappleDisparar(tool, pos, alvo, char, RSv)
        end
        local destino
        if typeof(value) == "Vector3" then destino = value
        elseif typeof(value) == "Instance" and value:IsA("BasePart") then destino = value.Position end
        local dir
        if destino then
            dir = destino - hrp.Position
            dir = Vector3.new(dir.X, 0, dir.Z)
        end
        if not dir or dir.Magnitude < 1 then
            local lv = hrp.CFrame.LookVector
            dir = Vector3.new(lv.X, 0, lv.Z)
        end
        if dir.Magnitude < 0.01 then return false end
        dir = dir.Unit
        local par = RaycastParams.new()
        par.FilterType = Enum.RaycastFilterType.Exclude
        par.FilterDescendantsInstances = { char }
        local pos, alvo, melhorM
        for _, d in ipairs({ 9, 10, 11, 12, 13, 14, 16, 18, 21, 24, 28, 32, 36, 40, 45 }) do
            local origem = hrp.Position + dir * d + Vector3.new(0, 3, 0)
            local hit = workspace:Raycast(origem, Vector3.new(0, -60, 0), par)
            if hit then
                local m = (hit.Position - hrp.Position).Magnitude
                if m >= 10 and m <= 50 and (not melhorM or m < melhorM) then
                    pos, alvo, melhorM = hit.Position, hit.Instance, m
                end
            end
        end
        if not pos then
            for _, d in ipairs({ 11, 14, 18, 24, 32, 42, 48 }) do
                local hit = workspace:Raycast(hrp.Position, dir * d, par)
                if hit then
                    local m = (hit.Position - hrp.Position).Magnitude
                    if m >= 10 and m <= 50 and (not melhorM or m < melhorM) then
                        pos, alvo, melhorM = hit.Position, hit.Instance, m
                    end
                end
            end
        end
        if not pos or not alvo then return false end
        return _G.__SXEGrappleDisparar(tool, pos, alvo, char, RSv)
    end
    _G.SXEGrappleReady = function() return resolveHashed("UseItem", "RemoteEvent") ~= nil end
    _G.SXECicloTP = function(esperaMax)
        if _G.__SXECicloRodando then return false end
        _G.__SXECicloRodando = true
        local RSvc = game:GetService("RunService")
        local eu = game:GetService("Players").LocalPlayer
        local function temAlvo()
            local c = _G.SharedState and _G.SharedState.AllAnimalsCache
                   or (SharedState and SharedState.AllAnimalsCache)
            if not c then return false end
            local meu, meuD = eu.Name, eu.DisplayName
            for _, a in ipairs(c) do
                if a.plot and a.slot and a.owner ~= meu and a.owner ~= meuD then
                    return true
                end
            end
            return false
        end
        local teto = tonumber(esperaMax) or 4
        local t0 = os.clock()
        while not temAlvo() and os.clock() - t0 < teto do
            RSvc.Heartbeat:Wait()
        end
        if not temAlvo() then
            _G.__SXECicloRodando = false
            print(("[SXE] ciclo TP: nenhum alvo no cache apos %.1fs -- "
               .. "o scanner ainda nao populou. Nao subi pra nao gastar o hook.")
               :format(os.clock() - t0))
            return false
        end
        local destino
        do
            local plots = workspace:FindFirstChild("Plots")
            local cache = (SharedState and SharedState.AllAnimalsCache) or {}
            if plots then
                for _, a in ipairs(cache) do
                    if a.plot and a.owner ~= eu.Name and a.owner ~= eu.DisplayName then
                        local pl = plots:FindFirstChild(a.plot)
                        if pl then
                            local okp, pv = pcall(function() return pl:GetPivot().Position end)
                            if okp and pv then destino = pv; break end
                        end
                    end
                end
            end
        end
        if workspace.StreamingEnabled and destino then
            local ts = os.clock()
            pcall(function() eu:RequestStreamAroundAsync(destino) end)
            if _G.__LMARK then
                _G.__LMARK(("stream do destino em %.2fs"):format(os.clock() - ts))
            end
        end
        local ok = false
        if destino and _G.SXEFireGrapple2 then
            pcall(function() ok = _G.SXEFireGrapple2(destino) and true or false end)
        end
        if _G.__LMARK then _G.__LMARK("hook na direcao da base: " .. tostring(ok)) end
        local ESPERA_HOOK_TP = 0.12
        task.wait(ESPERA_HOOK_TP)
        if _G.SXEStartSideTP then
            task.spawn(_G.SXEStartSideTP)
        elseif _G.SXE_ExecuteManualTP then
            task.spawn(_G.SXE_ExecuteManualTP)
        end
        _G.__SXECicloRodando = false
        return ok
    end
end
if not LPH_NO_VIRTUALIZE then LPH_NO_VIRTUALIZE = function(fn) return fn end end
_G.__SXELazyQ = _G.__SXELazyQ or {}
local function LazyInit(name, fn)
    table.insert(_G.__SXELazyQ, { name = name, fn = LPH_NO_VIRTUALIZE(fn) })
end
task.defer(LPH_NO_VIRTUALIZE(function()
    while true do
        if #_G.__SXELazyQ > 0 then
            local item = table.remove(_G.__SXELazyQ, 1)
            local ok, err = pcall(item.fn)
            if not ok then print("[SXE Lazy]", item.name, err) end
            task.wait(0.08)
        else
            task.wait(0.5)
        end
    end
end))
_G._SXEPanelVis = _G._SXEPanelVis or {}
_G.lazyUIs = {}
_G.addLazyUI = function(element, targetVis, isScreenGui, panelName)
    if element then
        if isScreenGui then
            element.Enabled = false
        else
            element.Visible = false
        end
        table.insert(_G.lazyUIs, {element = element, targetVis = targetVis, isScreenGui = isScreenGui, cancelled = false, panelName = panelName})
    end
end
_G.cancelLazyUI = function(element)
    for _, item in ipairs(_G.lazyUIs) do
        if item.element == element then
            item.cancelled = true
            break
        end
    end
end
task.delay(4.0, function()
    for _, item in ipairs(_G.lazyUIs) do
        if item.element and not item.cancelled then
            local vis
            if item.panelName then
                local fromG = _G._SXEPanelVis[item.panelName]
                if fromG ~= nil then
                    vis = fromG
                elseif Config and Config.Visibilities then
                    local saved = Config.Visibilities[item.panelName]
                    if saved ~= nil then vis = saved else vis = true end
                else
                    vis = item.targetVis
                end
            else
                vis = item.targetVis
            end
            if item.isScreenGui then
                pcall(function() item.element.Enabled = vis end)
            elseif item.element.Parent then
                pcall(function() item.element.Visible = vis end)
            end
        end
    end
    if _G.initRemoteSellLazy then
        pcall(_G.initRemoteSellLazy)
    end
end)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
pcall(function() Players.RespawnTime = 0 end)
local GlobalUIScaleVal = 1
local scaledGuis = {}
local function getGlobalScale()
    return GlobalUIScaleVal
end
local function updateAllGuisScale(newScale)
    GlobalUIScaleVal = newScale
    for sg, master in pairs(scaledGuis) do
        pcall(function()
            if sg and sg.Parent and master and master.Parent then
                local scaleObj = master:FindFirstChild("SXE_GlobalScale")
                if scaleObj then
                    scaleObj.Scale = newScale
                end
                master.Size = UDim2.new(1 / newScale, 0, 1 / newScale, 0)
            end
        end)
    end
end
local function registerScreenGui(sg)
    local master = sg:FindFirstChild("SXE_MasterFrame")
    if not master then
        master = Instance.new("Frame")
        master.Name = "SXE_MasterFrame"
        master.BackgroundTransparency = 1
        master.BorderSizePixel = 0
        master.Parent = sg
        local scaleObj = Instance.new("UIScale")
        scaleObj.Name = "SXE_GlobalScale"
        scaleObj.Parent = master
    end
    scaledGuis[sg] = master
    pcall(function()
        local scaleObj = master:FindFirstChild("SXE_GlobalScale")
        if scaleObj then
            scaleObj.Scale = GlobalUIScaleVal
        end
        master.Size = UDim2.new(1 / GlobalUIScaleVal, 0, 1 / GlobalUIScaleVal, 0)
    end)
    return master
end
local function recalculateScale()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local size = cam.ViewportSize
    local h = size.Y
    local isMobile = UIS.TouchEnabled
    local newScale = 1
    if isMobile then
        newScale = math.clamp(h / 1000, 0.40, 0.58)
    else
        newScale = math.clamp(h / 800, 0.65, 1.0)
    end
    updateAllGuisScale(newScale)
end
local cameraConn
local function setupCameraListener()
    if cameraConn then pcall(function() cameraConn:Disconnect() end) end
    local cam = Workspace.CurrentCamera
    if cam then
        local _sd = false
        cameraConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if _sd then return end
            _sd = true
            task.delay(0.2, function()
                _sd = false
                recalculateScale()
            end)
        end)
        recalculateScale()
    end
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(setupCameraListener)
task.spawn(setupCameraListener)
local old = _G.SXEBuscaGui("SXEHub_V3"); if old then old:Destroy() end
local gui_sg = Instance.new("ScreenGui"); gui_sg.Name = "SXEHub_V3"; gui_sg.ResetOnSpawn = false; gui_sg.IgnoreGuiInset = true; gui_sg.DisplayOrder = 9999999; gui_sg.Parent = ((gethui and gethui()) or game:GetService("CoreGui"))
local gui = registerScreenGui(gui_sg)
do
    local jpSg = Instance.new("ScreenGui")
    jpSg.Name = "SXEHub_TopBar"
    jpSg.ResetOnSpawn = false
    jpSg.IgnoreGuiInset = true
    jpSg.DisplayOrder = 9999998
    jpSg.Parent = ((gethui and gethui()) or game:GetService("CoreGui"))
    local barra = Instance.new("Frame")
    barra.Name = "HeresyTopBar"
    barra.Size = UDim2.new(0, 240, 0, 46)
    barra.Position = UDim2.new(0.5, -120, 0, 8)
    barra.BackgroundColor3 = Color3.fromRGB(19, 18, 24)
    barra.BackgroundTransparency = 0.08
    barra.BorderSizePixel = 0
    barra.ClipsDescendants = true
    barra.Parent = jpSg
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 9); c.Parent = barra
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(58, 55, 73); s.Thickness = 1; s.Transparency = 0.2; s.Parent = barra
    local faixa = Instance.new("Frame")
    faixa.Size = UDim2.new(1, 0, 0, 2)
    faixa.BackgroundColor3 = Color3.fromRGB( 24, 110, 225)
    faixa.BorderSizePixel = 0
    faixa.ZIndex = 3
    faixa.Parent = barra
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB( 24, 110, 225)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 195, 255)),
    })
    g.Parent = faixa
    local function _tituloGrad(label, cores, seg)
        if not label then return end
        label.TextColor3 = Color3.new(1, 1, 1)
        local g = Instance.new("UIGradient")
        g.Name = "HeresyTitleGrad"
        g.Color = ColorSequence.new(cores)
        g.Parent = label
        pcall(function()
            g.Offset = Vector2.new(-1, 0)
            local tw = TweenService:Create(g,
                TweenInfo.new(seg, Enum.EasingStyle.Sine,
                              Enum.EasingDirection.InOut, -1, true),
                { Offset = Vector2.new(1, 0) })
            if _G.SXENoHubEffects then g.Offset = Vector2.new(0, 0) else tw:Play() end
        end)
        return g
    end
    local nome = Instance.new("Frame")
    nome.Size = UDim2.new(1, -10, 0, 16)
    nome.Position = UDim2.new(0, 5, 0, 5)
    nome.BackgroundTransparency = 1
    nome.Parent = barra
    local nl = Instance.new("UIListLayout")
    nl.FillDirection = Enum.FillDirection.Horizontal
    nl.Padding = UDim.new(0, 5)
    nl.VerticalAlignment = Enum.VerticalAlignment.Center
    nl.SortOrder = Enum.SortOrder.LayoutOrder
    nl.Parent = nome
    local nHub = Instance.new("TextLabel")
    nHub.AutomaticSize = Enum.AutomaticSize.X
    nHub.Size = UDim2.new(0, 0, 0, 16)
    nHub.LayoutOrder = 1
    nHub.BackgroundTransparency = 1
    nHub.Text = "HERESY HUB"
    nHub.Font = Enum.Font.GothamBlack
    nHub.TextSize = 13
    nHub.Parent = nome
    _tituloGrad(nHub, {
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB( 18,  68, 150)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB( 42, 130, 240)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB( 42, 130, 240)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB( 18,  68, 150)),
    }, 3.2)
    local nFree = Instance.new("TextLabel")
    nFree.AutomaticSize = Enum.AutomaticSize.X
    nFree.Size = UDim2.new(0, 0, 0, 14)
    nFree.LayoutOrder = 2
    nFree.BackgroundTransparency = 1
    nFree.Text = "FREE"
    nFree.Font = Enum.Font.GothamBlack
    nFree.TextSize = 11
    nFree.Parent = nome
    _tituloGrad(nFree, {
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(150, 205, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB( 30, 125, 245)),
        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(150, 205, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
    }, 4.0)
    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(0.55, 0, 0, 12)
    stats.Position = UDim2.new(0, 5, 0, 22)
    stats.BackgroundTransparency = 1
    stats.Text = "FPS: -- | PING: --"
    stats.TextColor3 = Color3.fromRGB( 46,  74, 116)
    stats.Font = Enum.Font.GothamMedium
    stats.TextSize = 10
    stats.TextXAlignment = Enum.TextXAlignment.Center
    stats.Parent = barra
    local disc = Instance.new("TextLabel")
    disc.Size = UDim2.new(0.45, -5, 0, 12)
    disc.Position = UDim2.new(0.55, 0, 0, 22)
    disc.BackgroundTransparency = 1
    disc.Text = "discord.gg/heresy"
    disc.TextColor3 = Color3.fromRGB(134, 131, 152)
    disc.Font = Enum.Font.GothamMedium
    disc.TextSize = 10
    disc.TextXAlignment = Enum.TextXAlignment.Center
    disc.Parent = barra
    local aviso = Instance.new("TextLabel")
    aviso.Size = UDim2.new(1, -10, 0, 12)
    aviso.Position = UDim2.new(0, 5, 0, 34)
    aviso.BackgroundTransparency = 1
    aviso.Text = ""
    aviso.TextColor3 = Color3.fromRGB(242, 92, 114)
    aviso.Font = Enum.Font.GothamMedium
    aviso.TextSize = 9
    aviso.Parent = barra
    local clique = Instance.new("TextButton")
    clique.Size = UDim2.new(1, 0, 1, 0)
    clique.BackgroundTransparency = 1
    clique.Text = ""
    clique.AutoButtonColor = false
    clique.ZIndex = 5
    clique.Parent = barra
    clique.MouseEnter:Connect(function() barra.BackgroundColor3 = Color3.fromRGB(46, 43, 57) end)
    clique.MouseLeave:Connect(function() barra.BackgroundColor3 = Color3.fromRGB(19, 18, 24) end)
    clique.MouseButton1Click:Connect(function()
        if PrivateServerCode and PrivateServerCode ~= "" then
            aviso.Text = "entrando no servidor privado..."
            aviso.TextColor3 = Color3.fromRGB( 96, 175, 255)
            task.spawn(function()
                local ok = pcall(function()
                    TeleportService:TeleportToPrivateServer(game.PlaceId, PrivateServerCode, {LocalPlayer})
                end)
                if not ok then
                    pcall(function()
                        game:GetService("ExperienceService"):LaunchExperience({placeId=game.PlaceId, linkCode=PrivateServerCode})
                    end)
                end
                task.wait(3)
                aviso.Text = ""
            end)
        else
            aviso.Text = "sem Private Server Code"
            aviso.TextColor3 = Color3.fromRGB(242, 92, 114)
            task.delay(2, function() aviso.Text = "" end)
        end
    end)
    _G.__HeresyStats = stats
end
local ToggleState = {}
local function regToggle(name, default)
    if not ToggleState[name] then ToggleState[name] = {value = default or false, listeners = {}} end
end
local function getToggle(name) return ToggleState[name] and ToggleState[name].value or false end
local function setToggle(name, val, skipNotify)
    regToggle(name)
    ToggleState[name].value = val
    if not skipNotify then
        for _, fn in ipairs(ToggleState[name].listeners) do pcall(fn, val) end
    end
end
local function onToggleChanged(name, fn)
    regToggle(name); table.insert(ToggleState[name].listeners, fn)
end
local Config
local saveConfig
local loadConfig
Themes = {
    Light = {
        Background=Color3.fromRGB(249,251,254), MainBackground=Color3.fromRGB(241,245,251),
        Panel=Color3.fromRGB(233,239,248), Row=Color3.fromRGB(224,233,245), RowHover=Color3.fromRGB(210,223,241),
        Accent=Color3.fromRGB(24,110,225), AccentLight=Color3.fromRGB(64,150,250),
        Green=Color3.fromRGB(22,163,94), Red=Color3.fromRGB(220,54,84), Red2=Color3.fromRGB(178,34,64),
        Text=Color3.fromRGB(18,22,30), Dim=Color3.fromRGB(104,116,136), Stroke=Color3.fromRGB(196,210,230),
        SoftButton=Color3.fromRGB(228,236,248), SoftButtonHover=Color3.fromRGB(214,226,244),
        SoftAccent=Color3.fromRGB(228,236,248), SoftAccentHover=Color3.fromRGB(214,226,244),
        ToggleOff=Color3.fromRGB(206,218,236), ToggleOff2=Color3.fromRGB(206,218,236),
        InputBg=Color3.fromRGB(255,255,255), SliderBg=Color3.fromRGB(196,210,230),
        BlacklistHover=Color3.fromRGB(240,206,214), BlacklistLeave=Color3.fromRGB(224,233,245),
    },
    Dark = {
        Background=Color3.fromRGB(19,21,26), MainBackground=Color3.fromRGB(13,15,19),
        Panel=Color3.fromRGB(27,30,36), Row=Color3.fromRGB(33,37,45), RowHover=Color3.fromRGB(45,51,62),
        Accent=Color3.fromRGB(24,110,225), AccentLight=Color3.fromRGB(96,175,255),
        Green=Color3.fromRGB(74,222,138), Red=Color3.fromRGB(242,92,114), Red2=Color3.fromRGB(198,48,82),
        Text=Color3.fromRGB(238,243,250), Dim=Color3.fromRGB(132,142,158), Stroke=Color3.fromRGB(52,60,72),
        SoftButton=Color3.fromRGB(35,39,47), SoftButtonHover=Color3.fromRGB(48,54,65),
        SoftAccent=Color3.fromRGB(35,39,47), SoftAccentHover=Color3.fromRGB(48,54,65),
        ToggleOff=Color3.fromRGB(42,47,57), ToggleOff2=Color3.fromRGB(42,47,57),
        InputBg=Color3.fromRGB(24,27,33), SliderBg=Color3.fromRGB(52,60,72),
        BlacklistHover=Color3.fromRGB(96,44,54), BlacklistLeave=Color3.fromRGB(48,54,65),
    }
}
HERESY = { NOME="HERESY", GRAD_A=Color3.fromRGB(24,110,225), GRAD_B=Color3.fromRGB(120,195,255) }
Theme = {}
for k, v in pairs(Themes.Dark) do
    Theme[k] = v
end
function applyTheme(themeName)
    local fromTheme = {}
    for k, v in pairs(Theme) do
        fromTheme[k] = v
    end
    local toTheme = Themes[themeName] or Themes.Light
    for k, v in pairs(toTheme) do
        Theme[k] = v
    end
    local function updatePanelTheme(f, isMain)
        if not f then return end
        f.BackgroundColor3 = isMain and toTheme.MainBackground or toTheme.Background
        for _, child in ipairs(f:GetChildren()) do
            if child:IsA("UIStroke") then
                child.Color = toTheme.AccentLight
            elseif child:IsA("Frame") then
                if child.Size == UDim2.new(1,-24,0,1) then
                    child.BackgroundColor3 = toTheme.AccentLight
                elseif child.BackgroundTransparency == 1 and child.Size == UDim2.new(1,0,0,42) then
                    for _, sub in ipairs(child:GetChildren()) do
                        if sub:IsA("TextLabel") then
                            if sub.TextSize == 16 or sub.TextSize == 12 then
                                sub.TextColor3 = toTheme.Text
                            elseif sub.TextSize == 10 then
                                sub.TextColor3 = toTheme.Dim
                            end
                        end
                    end
                end
            end
        end
    end
    local function updateBottomBarTheme()
        if not bottomBar then return end
        bottomBar.BackgroundColor3 = toTheme.Background
        for _, child in ipairs(bottomBar:GetChildren()) do
            if child:IsA("UIStroke") then
                child.Color = toTheme.AccentLight
            elseif child:IsA("TextLabel") then
                if child.Text == "|" or child.Text == "discord.gg/sxehub" then
                    child.TextColor3 = toTheme.AccentLight
                elseif child.Text == "By:@SE67 and @SXLVATORE" then
                    child.TextColor3 = toTheme.Dim
                end
            elseif child:IsA("Frame") then
                if child.Size == UDim2.new(0,1,0,36) then
                    child.BackgroundColor3 = toTheme.Accent
                end
            end
        end
    end
    local function updateAdminPanelTheme()
        if not apBG then return end
        apBG.BackgroundColor3 = toTheme.Background
        local idx = 0
        for uid, row in pairs(apRows) do
            if row and row.Parent then
                idx = idx + 1
                local isAlt = (idx % 2 == 0)
                local rowCol = isAlt and toTheme.Row or toTheme.Panel
                row.BackgroundColor3 = rowCol
                local plr = Players:GetPlayerByUserId(uid)
                local isBlacklisted = isPlayerBlacklisted and isPlayerBlacklisted(plr)
                for _, child in ipairs(row:GetChildren()) do
                    if child:IsA("Frame") then
                        if child.Size == UDim2.fromOffset(34,34) then
                            child.BackgroundColor3 = toTheme.InputBg
                            local stroke = child:FindFirstChildOfClass("UIStroke")
                            if stroke then stroke.Color = toTheme.Accent end
                        elseif child.ZIndex == 12 then
                            for _, btn in ipairs(child:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    if btn.Name == "BlacklistBtn" then
                                        btn.BackgroundColor3 = isBlacklisted and Color3.fromRGB(255, 60, 60) or toTheme.BlacklistLeave
                                    else
                                        btn.BackgroundColor3 = toTheme.SoftButton
                                    end
                                end
                            end
                        end
                    elseif child:IsA("TextLabel") then
                        if child.TextSize == 14 then
                            child.TextColor3 = toTheme.Text
                        elseif child.TextSize == 10 then
                            child.TextColor3 = toTheme.Dim
                        elseif child.TextSize == 11 then
                            child.TextColor3 = toTheme.AccentLight
                        end
                    end
                end
            end
        end
    end
    pcall(function()
        updatePanelTheme(main, true)
        updateBottomBarTheme()
        updateAdminPanelTheme()
        for _, name in ipairs({"Invisible Steal Panel", "Admin Command Panel", "Command Cooldowns", "Actions", "Steal Panel", "Steal Target"}) do
            updatePanelTheme(panels[name], false)
        end
        updatePanelTheme(actionSettingsPanel, false)
        updatePanelTheme(tpSpeedSettingsPanel, false)
    end)
    local function updateInstanceColors(inst)
        local shouldStyle = true
        if inst:IsA("GuiObject") or inst:IsA("UIStroke") then
            if mainBody and inst:IsDescendantOf(mainBody) then return end
            if inst == main or inst == bottomBar or inst == apBG then
                shouldStyle = false
            end
            for _, p in ipairs({"Invisible Steal Panel", "Admin Command Panel", "Command Cooldowns", "Actions", "Steal Panel", "Steal Target"}) do
                if inst == panels[p] then
                    shouldStyle = false
                end
            end
            if inst == actionSettingsPanel or inst == tpSpeedSettingsPanel then
                shouldStyle = false
            end
            if shouldStyle then
                local bgKeys = {
                    Background=true, MainBackground=true, Panel=true, Row=true, RowHover=true,
                    SoftButton=true, SoftButtonHover=true, SoftAccent=true, SoftAccentHover=true,
                    ToggleOff=true, ToggleOff2=true, InputBg=true, SliderBg=true,
                    BlacklistHover=true, BlacklistLeave=true
                }
                local textKeys = {
                    Text=true, Dim=true, Accent=true, AccentLight=true,
                    Green=true, Red=true, Red2=true, Stroke=true
                }
                local properties = {
                    BackgroundColor3 = bgKeys,
                    TextColor3 = textKeys,
                    PlaceholderColor3 = textKeys,
                    Color = textKeys
                }
                for prop, allowedKeys in pairs(properties) do
                    pcall(function()
                        local current = inst[prop]
                        if typeof(current) == "Color3" then
                            if prop == "TextColor3" and inst.Name == "WhiteTextBtn" then
                                return
                            end
                            if prop == "BackgroundColor3" and inst.Name == "WhiteSliderKnob" then
                                return
                            end
                            for k, val in pairs(fromTheme) do
                                if allowedKeys[k] then
                                    if (current.R - val.R)^2 + (current.G - val.G)^2 + (current.B - val.B)^2 < 0.0001 then
                                        inst[prop] = toTheme[k]
                                        break
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
        for _, child in ipairs(inst:GetChildren()) do
            updateInstanceColors(child)
        end
    end
    pcall(function()
        local sg = _G.SXEBuscaGui("SXEHub_V3")
        if sg then updateInstanceColors(sg) end
        if _G.updateLogoImage then
            _G.updateLogoImage(themeName == "Dark")
        end
    end)
    pcall(function()
        local ExploitGui = (gethui and gethui()) or game:GetService("CoreGui")
        local sg = ExploitGui:FindFirstChild("XiPriorityAlertTest")
        if sg then updateInstanceColors(sg) end
    end)
    for _, name in ipairs({"SXE_RemoteSell", "SXE_StealProgressBar", "XiAdminPanel"}) do
        pcall(function()
            local otherSg = playerGui:FindFirstChild(name)
            if otherSg then updateInstanceColors(otherSg) end
        end)
    end
    local function forceWhiteText(inst)
        if inst:IsA("TextButton") then
            local txt = inst.Text
            if txt == "ON" or txt == "OFF" or txt == "ADD" or txt == "X" or txt == "▲" or txt == "▼" then
                inst.TextColor3 = Color3.new(1, 1, 1)
            elseif inst.Size == UDim2.new(0, 50, 0, 20) then
                inst.TextColor3 = Color3.new(1, 1, 1)
            end
        elseif inst:IsA("Frame") and inst.Name == "WhiteSliderKnob" then
            inst.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
        for _, child in ipairs(inst:GetChildren()) do
            forceWhiteText(child)
        end
    end
    pcall(function()
        local sg = _G.SXEBuscaGui("SXEHub_V3")
        if sg then forceWhiteText(sg) end
    end)
    if Config then
        Config.DarkMode = (themeName == "Dark")
        if saveConfig then saveConfig() end
    end
    pcall(function() if rebuildActions then rebuildActions() end end)
    pcall(function() if rebuildActionSettings then rebuildActionSettings() end end)
    pcall(function() if rebuildTpSpeedSettings then rebuildTpSpeedSettings() end end)
    pcall(function() if loadTab then loadTab(UI.CurrentTab) end end)
end
_G.applyTheme = applyTheme
local UI = {Locked=false, OpenMenuKey=Enum.KeyCode.LeftControl, CurrentTab="Auto TP"}
Keybinds = {
    Kick="Y",["Rejoin Job ID"]="J",Clone="F",["Manual TP"]="T",["Invisible Steal"]="U",
    ["Job ID"]="K",Proximity="P",["Carpet Boost"]="Q",["Open Menu"]="LeftControl",
    ["Ragdoll Self"]="R",["Drop Brainrot"]="G",Float="Z",Reset="X",["Auto Buy"]="K",
    ["Click to AP"]="NONE",
    ["Steal Nearest"]="NONE",
    ["Face Nearest"]="NONE"
}
priorityList = {
    "Strawberry Elephant",
    "Meowl",
    "Skibidi Toilet",
    "Headless Horseman",
    "Dragon Gingerini",
    "Dragon Cannelloni",
    "Ketupat Bros",
    "Hydra Dragon Cannelloni",
    "La Supreme Combinasion",
    "Love Love Bear",
    "Ginger Gerat",
    "Cerberus",
    "Capitano Moby",
    "La Casa Boo",
    "Burguro and Fryuro",
    "Spooky and Pumpky",
    "Cooki and Milki",
    "Rosey and Teddy",
    "Popcuru and Fizzuru",
    "Reinito Sleighito",
    "Fragrama and Chocrama",
    "Garama and Madundung",
    "Ketchuru and Musturu",
    "La Secret Combinasion",
    "Tralaledon",
    "Tictac Sahur",
    "Ketupat Kepat",
    "Tang Tang Keletang",
    "Orcaledon",
    "La Ginger Sekolah",
    "Los Spaghettis",
    "Lavadorito Spinito",
    "Swaggy Bros",
    "La Taco Combinasion",
    "Los Primos",
    "Los Chillis",
    "Chillin Chili",
    "Tuff Toucan",
    "W or L",
    "Chipso and Queso",
    "Signore Carapace",
    "Arcadragon",
    "John Pork",
    "Elefanto Frigo",
    "Antonio",
    "Pancake and Syrup",
    "Griffin",
    "Kalika Bros",
    "Globa Steppa",
    "Fishino Clownino",
    "Rico Dinero",
    "Tirilikalika Tirilikalako",
    "Digi Narwhal",
    "Hydra Bunny",
    "Dug dug dug",
    "Bunny and Eggy",
    "Los Hackers",
    "Duggy Bros",
    "Guest 666",
    "Money Money Reindeer",
    "Foxini Lanternini",
    "Fragola La La La",
    "Quackini Snackini",
    "Los Sekolahs",
    "Los Tacoritas",
    "Los Amigos",
    "Fortunu and Cashuru",
    "Jolly Jolly Sahur",
    "Boppin Bunny",
    "Gym Bros",
    "Los Cupids",
    "Festive 67",
    "Celularcini Viciosini",
    "Cloverat Clapat",
    "La Food Combinasion",
    "Hopilikalika Hopilikalako",
    "Celestial Pegasus",
    "Sammyni Fattini",
    "Money Money Bros",
    "La Spooky Grande",
    "Cash or Card",
    "Swag Soda",
    "Los Planitos",
    "Lovin Rose",
    "Tacorita Bicicleta",
    "Los Jolly Combinasionas",
    "La Romantic Grande",
    "La Easter Grande",
    "Los Hotspotsitos",
    "Rosetti Tualetti",
    "Los Bros",
    "Gobblino Uniciclino",
    "Chicleteira Cupideira",
    "La Extinct Grande",
    "Las Sis",
    "Nacho Spyder",
    "Gold Gold Gold",
    "Los Mariachis",
    "Snailo Clovero",
    "La Jolly Grande",
    "Los Candies",
    "Churrito Bunnito",
    "Bananito",
    "Eviledon",
    "Los 67",
    "Los Sweethearts",
    "Noo my Heart",
    "La Lucky Grande",
    "Ventoliero Pavonero",
    "Baskito",
    "Chimnino",
    "Los Puggies",
    "Camera Ramena",
    "Los 25",
    "Spinny Hammy",
    "Money Money Puggy",
    "Cigno Fulgoro",
    "Los Spooky Combinasionas",
    "Chicleteira Noelteira",
    "Mariachi Corazoni",
    "Tacorillo Crocodillo",
    "Noo my Gold",
    "Los Mobilis",
    "Mieteteira Bicicleteira",
    "DJ Panda",
    "Los Combinasionas",
    "Nuclearo Dinossauro",
    "Bacuru and Egguru",
    "Spaghetti Tualetti",
    "La Grande Combinasion",
    "Esok Sekolah"
}
actionConfig = {
    ["Ragdoll Self (R)"]=true,["Rejoin PS"]=true,["Rejoin Job ID (J)"]=true,
    ["Kick (Y)"]=true,["Kick To Private"]=true,["JP"]=true,["Reset (X)"]=true,
    ["Anti Ragdoll"]=false,["Infinite Jump"]=false,["Float"]=false,["Carpet Speed"]=false,
}
local CONFIG_FILE = "sxe_hub_v3_config.json"
local PS_CODE_FILE = "sxe_hub_pscode.txt"
PrivateServerCode = ""
local function loadPSCode()
    pcall(function() if typeof(readfile)=="function" and typeof(isfile)=="function" and isfile(PS_CODE_FILE) then PrivateServerCode = readfile(PS_CODE_FILE) end end)
end
local function savePSCode()
    pcall(function() if typeof(writefile)=="function" then writefile(PS_CODE_FILE, PrivateServerCode or "") end end)
end
loadPSCode()
Config = {
    positions={},keybinds={},actions={},locked=false,
    DarkMode=true,
    AntiRagdoll=false,InfiniteJump=false,Float=false,
    AutoResetBalloon=false,AutoKickOnSteal=false,KickToPrivateServer=false,CleanErrorGUIs=false,
    LineToBase=false,LineToBrainrot=false,InvisStealAngle=225,SinkSliderValue=7,
    AutoRecoverLagback=true,
    WalkSpeedEnabled=false, WalkSpeedValue=16,
    AutoTPPriority=true, AutoTPHighestGen=false, AutoTPHighestValue=false, AutoTPFloor2FromFloor1=false, FPSBoost=false, FPSBoostUltra=false, XRay=false, FOV=70,
    BrainrotESP=true, TimerESP=false, SubspaceMineESP=false, PlayerESP=true, BaseOwnerESP=false,
    AutoBuyEnabled=false, AutoBuyRange=17, AutoGrabSpeed=17, AutoBuyKey="K",
    AutoDestroyTurrets=false, AutoUnlockOnSteal=false,
    AutoInvisDuringSteal=false,
    ClickToAP=false, ClickToAPSingleCommand=false,
    ClickToAPRadius=8,
    SpamBaseOwnerCommands={balloon=true, inverse=true, jail=true, jumpscare=true, morph=true, nightvision=true, ragdoll=true, rocket=true, tiny=true},
    SpamBaseOwnerOrder={"balloon", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket", "tiny"},
    SpamBaseOwnerSingleCommand=false,
    ProximityAP=false, ShowJobJoiner=true, AntiBeeDisco=false,
    RemoteSellEnabled=false, AdminPanelUI=true,
    StealHighest=false, StealPriority=true, StealNearest=false,
    AutoStealEnabled=true,
    Unwalk=false,
    Visibilities = {
        ["Invisible Steal Panel"] = true,
        ["Admin Command Panel"] = true,
        ["Command Cooldowns"] = true,
        ["Actions"] = true,
        ["Steal Panel"] = true,
        ["Steal Target"] = true,
    },
    TpSettings = {
        Tool="Flying Carpet", TpKey="T", CloneKey="V", CarpetSpeedKey="Q",
        InfiniteJump=false, DelayVal=0.4, CloneDelayVal=0.1,
        RagdollTP=false, FPSWait=false, FlyTP=false, FlyTPSpeed=160, FlyTPCloseSpeed=75,
        GrabbleTP=false, GrabbleTPSpeed=230,
        TpOnLoad=false, MinGenForTp="", MinGenForGrab="",
        BrainrotCarpet=false,
    },
    PriorityList=priorityList,
    RemovedFromPriority={},
}
local suffixes = {
    k = 1e3,
    m = 1e6,
    b = 1e9,
    t = 1e12,
    q = 1e15,
    qi = 1e18,
    qd = 1e18,
    qn = 1e18,
    sx = 1e21,
    sp = 1e24,
    oc = 1e27,
    no = 1e30,
    dc = 1e33,
    ud = 1e36,
    dd = 1e39,
    td = 1e42,
    qad = 1e45,
    qid = 1e48,
    sxd = 1e51,
    spd = 1e54,
    ocd = 1e57,
    nod = 1e60,
    vg = 1e63,
}
local function parseMinGen(str)
    if not str or type(str) ~= "string" then return 0 end
    str = str:gsub("%s", ""):lower():gsub("/s$", "")
    if str == "" then return 0 end
    local numStr, suffix = str:match("^([%d%.]+)(%a*)$")
    if not numStr then return 0 end
    local num = tonumber(numStr)
    if not num or num < 0 then return 0 end
    if suffix ~= "" then
        local mult = suffixes[suffix]
        if mult then
            return num * mult
        end
    end
    return num
end
local function canUseFiles() return typeof(readfile)=="function" and typeof(writefile)=="function" and typeof(isfile)=="function" end
loadConfig = function()
    if not canUseFiles() then return end
    local ok,data=pcall(function() if isfile(CONFIG_FILE) then return HttpService:JSONDecode(readfile(CONFIG_FILE)) end end)
    if ok and type(data)=="table" then
        for k,v in pairs(data) do
            if k == "PriorityList" or k == "RemovedFromPriority" then
                Config[k] = v
            elseif type(v) == "table" and type(Config[k]) == "table" then
                for subk, subv in pairs(v) do
                    Config[k][subk] = subv
                end
            else
                Config[k] = v
            end
        end
        if type(Config.positions)~="table" then Config.positions={} end
        if type(Config.keybinds)~="table" then Config.keybinds={} end
        if type(Config.actions)~="table" then Config.actions={} end
        if type(Config.RemovedFromPriority)~="table" then Config.RemovedFromPriority={} end
        local removedSet = {}
        for _, rn in ipairs(Config.RemovedFromPriority) do removedSet[rn] = true end
        if type(Config.PriorityList)=="table" then
            if #Config.PriorityList == 0 then
                Config.PriorityList = priorityList
            else
                local present = {}
                for _, name in ipairs(Config.PriorityList) do
                    present[name] = true
                end
                for _, name in ipairs(priorityList) do
                    if not present[name] and not removedSet[name] then
                        table.insert(Config.PriorityList, name)
                    end
                end
                priorityList = Config.PriorityList
            end
        else
            Config.PriorityList = priorityList
        end
        if type(Config.PriorityList) == "table" then
            local seen = {}
            local cleanList = {}
            for _, name in ipairs(Config.PriorityList) do
                if not seen[name] then
                    seen[name] = true
                    table.insert(cleanList, name)
                end
            end
            Config.PriorityList = cleanList
            priorityList = cleanList
        end
    end
end
saveConfig = function()
    if not canUseFiles() then return end
    task.spawn(function() pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(Config)) end) end)
end
do
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local function base64Encode(data)
        local len = #data
        local t = {}
        for i = 1, len, 3 do
            local a = data:byte(i)
            local b = data:byte(i + 1) or 0
            local c = data:byte(i + 2) or 0
            local n = a * 65536 + b * 256 + c
            t[#t + 1] = b64chars:sub(math.floor(n / 262144) + 1, math.floor(n / 262144) + 1)
            t[#t + 1] = b64chars:sub(math.floor(n / 4096) % 64 + 1, math.floor(n / 4096) % 64 + 1)
            t[#t + 1] = (i + 1 <= len) and b64chars:sub(math.floor(n / 64) % 64 + 1, math.floor(n / 64) % 64 + 1) or "="
            t[#t + 1] = (i + 2 <= len) and b64chars:sub(n % 64 + 1, n % 64 + 1) or "="
        end
        return table.concat(t)
    end
    local function base64Decode(data)
        data = data:gsub('[^' .. b64chars .. '=]', '')
        local len = #data
        local t = {}
        local lookup = {}
        for i = 1, 64 do lookup[b64chars:sub(i, i)] = i - 1 end
        local i = 1
        while i <= len do
            local c1 = lookup[data:sub(i, i)]
            local c2 = lookup[data:sub(i + 1, i + 1)]
            local s3 = data:sub(i + 2, i + 2)
            local s4 = data:sub(i + 3, i + 3)
            local c3 = lookup[s3]
            local c4 = lookup[s4]
            if not c1 or not c2 then break end
            local n = c1 * 262144 + c2 * 4096 + (c3 or 0) * 64 + (c4 or 0)
            t[#t + 1] = string.char(math.floor(n / 65536))
            if s3 ~= "=" then
                t[#t + 1] = string.char(math.floor(n / 256) % 256)
            end
            if s4 ~= "=" then
                t[#t + 1] = string.char(n % 256)
            end
            i = i + 4
        end
        return table.concat(t)
    end
    _G.importConfig = function(str)
        if not str or str == "" then
            ShowNotification("IMPORT ERROR", "Config string is empty")
            return false
        end
        local success, parsed = pcall(function()
            return HttpService:JSONDecode(str)
        end)
        if not success or type(parsed) ~= "table" then
            local decoded
            pcall(function() decoded = base64Decode(str:gsub("%s", "")) end)
            if decoded then
                success, parsed = pcall(function() return HttpService:JSONDecode(decoded) end)
            end
        end
        if not success or type(parsed) ~= "table" then
            ShowNotification("IMPORT ERROR", "Invalid config data")
            return false
        end
        for k, v in pairs(parsed) do
            Config[k] = v
        end
        if type(Config.PriorityList) == "table" then priorityList = Config.PriorityList end
        saveConfig()
        for k, v in pairs(Config.keybinds or {}) do
            if Keybinds[k] ~= nil and type(v) == "string" then
                Keybinds[k] = v
                if k == "Open Menu" and Enum.KeyCode[v] then
                    UI.OpenMenuKey = Enum.KeyCode[v]
                end
            end
        end
        for k, v in pairs(Config.actions or {}) do
            if actionConfig[k] ~= nil then
                actionConfig[k] = v and true or false
            end
        end
        if type(Config.locked) == "boolean" then
            UI.Locked = Config.locked
        end
        initToggles()
        if setFPSBoost then pcall(setFPSBoost, Config.FPSBoost) end
        if setFPSBoostUltra then pcall(setFPSBoostUltra, Config.FPSBoostUltra) end
        if setXRay then pcall(setXRay, Config.XRay) end
        if setInfiniteJump then pcall(setInfiniteJump, Config.InfiniteJump) end
        if setFloat then pcall(setFloat, Config.Float) end
        if setCarpetSpeed then pcall(setCarpetSpeed, Config.CarpetSpeed or false) end
    Config.ProximityAP = false
        if toggleAutoBuy then pcall(toggleAutoBuy, Config.AutoBuyEnabled) end
        if setStealMode then
            if Config.StealHighest then pcall(setStealMode, "Highest")
            elseif Config.StealPriority then pcall(setStealMode, "Priority")
            elseif Config.StealNearest then pcall(setStealMode, "Nearest")
            end
        end
        if updateMovementPanelLabels then pcall(updateMovementPanelLabels) end
        rebuildActions()
        rebuildActionSettings()
        loadTab(UI.CurrentTab)
        ShowNotification("CONFIG SYSTEM", "Config imported successfully!")
        return true
    end
    _G.exportConfig = function()
        local ok, str = pcall(function()
            return HttpService:JSONEncode(Config)
        end)
        if not ok or not str then
            ShowNotification("EXPORT ERROR", "Failed to encode config")
            return nil
        end
        local cbSuccess = false
        if typeof(setclipboard) == "function" then
            pcall(function() setclipboard(str); cbSuccess = true end)
        elseif typeof(toclipboard) == "function" then
            pcall(function() toclipboard(str); cbSuccess = true end)
        end
        if cbSuccess then
            ShowNotification("CONFIG SYSTEM", "Config copied to clipboard!")
        else
            ShowNotification("CONFIG SYSTEM", "Config generated! Copy from share box.")
        end
        return str
    end
end
local function serializePos(pos) return {xs=pos.X.Scale,xo=pos.X.Offset,ys=pos.Y.Scale,yo=pos.Y.Offset} end
local function rememberPosition(name, frame) if not name or not frame then return end; Config.positions[name]=serializePos(frame.Position); saveConfig() end
local function applySavedPosition(name, frame)
    if not name or not frame then return end; local d=Config.positions and Config.positions[name]
    if d then frame.Position=UDim2.new(d.xs or 0,d.xo or 0,d.ys or 0,d.yo or 0) end
end
local function initToggles()
    setToggle("Anti Ragdoll", Config.AntiRagdoll, true)
    setToggle("Auto Reset Balloon", Config.AutoResetBalloon, true)
    setToggle("Infinite Jump", Config.InfiniteJump, true)
    setToggle("Auto Kick", Config.AutoKickOnSteal, true)
        setToggle("Auto Buy", Config.AutoBuyEnabled, true)
    setToggle("Auto Steal", Config.AutoStealEnabled, true)
    setToggle("Steal Highest", Config.StealHighest, true)
    setToggle("Steal Priority", Config.StealPriority, true)
    setToggle("Steal Nearest", Config.StealNearest, true)
    Config.ClickToAP = true
    setToggle("Click to AP", true, true)
    setToggle("ClickToAP", true, true)
    setToggle("Click AP Single Cmd", Config.ClickToAPSingleCommand, true)
    setToggle("ClickToAPSingle", Config.ClickToAPSingleCommand, true)
    setToggle("FPS Boost (normal)", Config.FPSBoost, true)
    setToggle("FPS Boost (normal)", Config.FPSBoost, true)
    setToggle("FPS Boost Ultra", Config.FPSBoostUltra, true)
    setToggle("FPSBoostUltra", Config.FPSBoostUltra, true)
    setToggle("XRay", Config.XRay, true)
    setToggle("X-Ray", Config.XRay, true)
    setToggle("Xray", Config.XRay, true)
    setToggle("Proximity", Config.ProximityAP, true)
    setToggle("Player ESP", Config.PlayerESP, true)
    setToggle("Brainrot ESP", Config.BrainrotESP, true)
    setToggle("Timer ESP", Config.TimerESP, true)
    setToggle("Subspace Mine ESP", Config.SubspaceMineESP, true)
    setToggle("Base Owner ESP", Config.BaseOwnerESP, true)
    setToggle("Float", Config.Float, true)
    setToggle("Anti-Bee & Anti-Disco", Config.AntiBeeDisco, true)
    setToggle("AntiBeeDisco", Config.AntiBeeDisco, true)
    setToggle("Admin Panel UI", Config.AdminPanelUI, true)
    setToggle("Auto Invis During Steal", Config.AutoInvisDuringSteal, true)
    setToggle("Auto TP Priority Mode", Config.AutoTPPriority, true)
    setToggle("Auto TP Highest Gen", Config.AutoTPHighestGen, true)
    setToggle("Auto TP Highest Value", Config.AutoTPHighestValue, true)
    setToggle("Unwalk", Config.Unwalk, true)
    setToggle("Stealing ESP", Config.StealingESP, true)
    setToggle("WalkSpeed", Config.WalkSpeedEnabled, true)
    setToggle("Dark Mode", Config.DarkMode, true)
    setToggle("DarkMode", Config.DarkMode, true)
    setToggle("Grabble TP", Config.TpSettings.GrabbleTP or false, true)
    setToggle("Fly TP", Config.TpSettings.FlyTP or false, true)
end
loadConfig()
do
    Config.AdminPanelUI            = false
    Config.ClickToAP               = false
    Config.ClickToAPSingleCommand  = false
    Config.SpamBaseOwnerSingleCommand = false
    Config.ProximityAP             = false
    for _, k in ipairs({"AdminPanelButtons","ClickToAPCommands","SpamBaseOwnerCommands"}) do
        if type(Config[k]) == "table" then
            for c in pairs(Config[k]) do Config[k][c] = false end
        end
    end
    if type(Config.Visibilities) == "table" then
        Config.Visibilities["Admin Command Panel"] = false
    end
end
Config.DarkMode = true
for k, v in pairs(Themes.Dark) do
    Theme[k] = v
end
for k,v in pairs(Config.keybinds or {}) do if Keybinds[k]~=nil and type(v)=="string" then Keybinds[k]=v; if k=="Open Menu" and Enum.KeyCode[v] then UI.OpenMenuKey=Enum.KeyCode[v] end end end
for k,v in pairs(Config.actions or {}) do if actionConfig[k]~=nil then actionConfig[k]=v and true or false end end
if type(Config.locked)=="boolean" then UI.Locked=Config.locked end
initToggles()
do
_G.stealthGet=function(n) return _G.XenSyncGet(n) end
_G.SyncInt={_cache={},_data=nil}
end
local Decrypted=setmetatable({},{__index=function(S,ez)
    local ok,Netty=pcall(function() return ReplicatedStorage.Packages.Net end); if not ok or not Netty then return nil end
    if ez:sub(1,3)~="RE/" and ez:sub(1,3)~="RF/" then return nil end
    local Remote; for i,v in ipairs(Netty:GetChildren()) do if v.Name==ez then local children=Netty:GetChildren(); Remote=children[i+1]; break end end
    if Remote and not rawget(Decrypted,ez) then rawset(Decrypted,ez,Remote) end; return rawget(Decrypted,ez)
end})
ACTION_COOLDOWNS = {ragdoll=30,jail=60,rocket=120,balloon=30,inverse=30,jumpscare=30,tiny=30,morph=30,nightvision=30}
local lastActionUse = {}
local function _readRealAdminTimer(_cmd)
    return nil
end
local function apIsOnCooldown(cmd)
    local realTime = _readRealAdminTimer(cmd)
    if realTime ~= nil then return realTime > 0 end
    local l=lastActionUse[cmd]; local cd=ACTION_COOLDOWNS[cmd] or 0; return l and cd>0 and (tick()-l)<cd
end
local function apGetRemaining(cmd)
    local realTime = _readRealAdminTimer(cmd)
    if realTime ~= nil then return realTime end
    local l=lastActionUse[cmd]; local cd=ACTION_COOLDOWNS[cmd] or 0; if not l then return 0 end; return math.max(0,cd-(tick()-l))
end
local function apStartCooldown(cmd) lastActionUse[cmd]=tick() end
AP_ALL_COMMANDS={"balloon","inverse","jail","jumpscare","morph","nightvision","ragdoll","rocket","tiny"}
AP_COMMAND_EMOJIS={balloon="🎈",inverse="🔄",jail="🔒",jumpscare="👻",morph="🎭",nightvision="🌙",ragdoll="🌀",rocket="🚀",tiny="🐜"}
if not Config.ClickToAPCommands then
    Config.ClickToAPCommands = {}
    for _, cmd in ipairs(AP_ALL_COMMANDS) do Config.ClickToAPCommands[cmd] = true end
end
if not Config.AdminPanelButtons then
    Config.AdminPanelButtons = {ragdoll=true, jail=true, rocket=true, balloon=true}
end
if not Config.ClickToAPRadius then
    Config.ClickToAPRadius = 8
end
if not Config.SpamBaseOwnerCommands then
    Config.SpamBaseOwnerCommands = {}
    for _, cmd in ipairs(AP_ALL_COMMANDS) do Config.SpamBaseOwnerCommands[cmd] = true end
end
if not Config.SpamBaseOwnerOrder then
    Config.SpamBaseOwnerOrder = {}
    for i, cmd in ipairs(AP_ALL_COMMANDS) do Config.SpamBaseOwnerOrder[i] = cmd end
end
if Config.SpamBaseOwnerSingleCommand == nil then
    Config.SpamBaseOwnerSingleCommand = false
end
setToggle("SpamBaseOwnerSingleCommand", Config.SpamBaseOwnerSingleCommand or false)
_G.apBlacklist = Config.apBlacklist or {}
_G.SXEGoodBoys = _G.SXEGoodBoys or {}
_G.SXEBadBoys  = _G.SXEBadBoys or {}
do
    local URL = "https://gist.githubusercontent.com/josecastle21/fcc5696b9d37ae086a324d99e6b8fa5e/raw/fmly_badboys.json"
    local HttpService = game:GetService("HttpService")
    local function httpGet(u)
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            local ok, res = pcall(req, { Url = u, Method = "GET" })
            if ok and res and res.Body then return res.Body end
        end
        local ok, body = pcall(function() return game:HttpGet(u) end)
        if ok then return body end
        return nil
    end
    local CACHE_FILE = "sxe_fmly_boys.json"
    local SIX_HOURS = 6 * 3600
    local lastFetch = 0
    local function applyArrays(goodArr, badArr)
        local good, bad = {}, {}
        if type(goodArr) == "table" then for _, n in ipairs(goodArr) do if type(n) == "string" then good[n:lower()] = true end end end
        if type(badArr) == "table" then for _, n in ipairs(badArr) do if type(n) == "string" then bad[n:lower()] = true end end end
        _G.SXEGoodBoys, _G.SXEBadBoys = good, bad
        if _G.refreshAdminPanelRows then pcall(_G.refreshAdminPanelRows) end
    end
    local function loadCache()
        local ok, raw = pcall(function()
            if isfile and isfile(CACHE_FILE) then return readfile(CACHE_FILE) end
        end)
        if ok and type(raw) == "string" then
            local ok2, c = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok2 and type(c) == "table" then return c end
        end
        return nil
    end
    local function fetchAndSave()
        local body = httpGet(URL .. "?cb=" .. tostring(os.time()))
        if not body then return false end
        local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
        if not ok or type(data) ~= "table" then return false end
        local goodArr = type(data.good) == "table" and data.good or {}
        local badArr  = type(data.bad)  == "table" and data.bad  or {}
        applyArrays(goodArr, badArr)
        lastFetch = os.time()
        pcall(function()
            if writefile then
                writefile(CACHE_FILE, HttpService:JSONEncode({ t = lastFetch, good = goodArr, bad = badArr }))
            end
        end)
        return true
    end
    task.spawn(function()
        local cache = loadCache()
        if cache then
            applyArrays(cache.good, cache.bad)
            if type(cache.t) == "number" then lastFetch = cache.t end
        end
        if (os.time() - lastFetch) >= SIX_HOURS then
            pcall(fetchAndSave)
        end
        while true do
            task.wait(1800)
            if (os.time() - lastFetch) >= SIX_HOURS then pcall(fetchAndSave) end
        end
    end)
end
_G.SXEIsGoodBoy = function(plr) return plr ~= nil and _G.SXEGoodBoys[tostring(plr.Name):lower()] == true end
_G.SXEIsBadBoy  = function(plr) return plr ~= nil and _G.SXEBadBoys[tostring(plr.Name):lower()] == true end
local function isPlayerBlacklisted(plr)
    if not plr then return false end
    if _G.SXEGoodBoys[tostring(plr.Name):lower()] then return true end
    local uid = plr.UserId
    return _G.apBlacklist[uid] == true or _G.apBlacklist[tostring(uid)] == true
end
do
    local cached
    function _G.__getSync()
        if cached then return cached end
        local ok, mod = pcall(function()
            local pkgs = ReplicatedStorage:FindFirstChild("Packages")
            return pkgs and require(pkgs:WaitForChild("Synchronizer", 5))
        end)
        if ok then cached = mod end
        return cached
    end
end
local function getPlotOwner(plot)
    if not plot then return nil end
    local Synchronizer = _G.__getSync()
    if Synchronizer then
        local ch = _G.SXE_GetPlotChannel(plot.Name)
        if ch then
            local owner = _G.sProp(ch, "Owner")
            if owner then
                if typeof(owner) == "Instance" and owner:IsA("Player") then
                    return owner
                elseif type(owner) == "table" and owner.Name then
                    return Players:FindFirstChild(owner.Name)
                elseif type(owner) == "number" then
                    return Players:GetPlayerByUserId(owner)
                end
            end
        end
    end
    local sign = plot:FindFirstChild("PlotSign")
    local textLabel = sign
        and sign:FindFirstChild("SurfaceGui")
        and sign.SurfaceGui:FindFirstChild("Frame")
        and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
    if textLabel then
        local baseText = textLabel.Text
        local nickname = (baseText and baseText:match("^(.-)'")) or baseText
        if nickname then
            for _, p in ipairs(Players:GetPlayers()) do
                if (p.DisplayName == nickname) or (p.Name == nickname) then
                    return p
                end
            end
        end
    end
    return nil
end
local function getPlotAtPosition(pos)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local closestPlot = nil
    local minDistance = math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local plotPos
        if plot:IsA("Model") then
            plotPos = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
        else
            plotPos = plot.Position
        end
        if plotPos then
            local distH = math.sqrt((pos.X - plotPos.X)^2 + (pos.Z - plotPos.Z)^2)
            if distH < minDistance then
                minDistance = distH
                closestPlot = plot
            end
        end
    end
    if closestPlot and minDistance < 72 then
        return closestPlot
    end
    return nil
end
local function getPlayerBaseInfo(plr)
    if not plr or not plr.Character then return nil, nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    local plot = getPlotAtPosition(hrp.Position)
    if plot then
        return plot, getPlotOwner(plot)
    end
    return nil, nil
end
do
    local cachedId, lastT = nil, 0
    function _G.__getCurrentBaseOwnerId()
        local now = os.clock()
        if (now - lastT) < 0.4 then return cachedId end
        lastT = now
        cachedId = nil
        local _, owner = getPlayerBaseInfo(LocalPlayer)
        if owner then cachedId = owner.UserId end
        return cachedId
    end
end
local function getStealingInfo(plr)
    if not plr or not plr.Character then return nil, nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    local isPlayingAnim = false
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local id = track.Animation and track.Animation.AnimationId
                if id and (id:find("18537363391") or id:find("steal") or id:find("grab")) then
                    isPlayingAnim = true
                    break
                end
            end
        end)
    end
    local plots = Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = getPlotOwner(plot)
            if owner == plr then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, pod in ipairs(podiums:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local dist = (hrp.Position - spawn.Position).Magnitude
                        if (isPlayingAnim and dist < 12) or (dist < 4.5) then
                            local animalName = "Brainrot"
                            pcall(function()
                                local Synchronizer = _G.__getSync()
                                if Synchronizer then
                                    local ch = _G.SXE_GetPlotChannel(plot.Name)
                                    if ch then
                                        local al = _G.sProp(ch, "AnimalList")
                                        local ad = al and (al[pod.Name] or al[tonumber(pod.Name)])
                                        if ad and type(ad) == "table" then
                                            local ok2, Datas = pcall(function() return ReplicatedStorage:FindFirstChild("Datas") end)
                                            local okA, AnimalsData = pcall(function() return require(Datas:FindFirstChild("Animals")) end)
                                            if okA and AnimalsData and AnimalsData[ad.Index] then
                                                animalName = AnimalsData[ad.Index].DisplayName or ad.Index
                                            else
                                                animalName = ad.Index
                                            end
                                        end
                                    end
                                end
                            end)
                            return owner, animalName
                        end
                    end
                end
            end
        end
    end
    local attrStealing = plr:GetAttribute("Stealing")
    if attrStealing then
        return nil, plr:GetAttribute("StealingIndex") or "Brainrot"
    end
    return nil, nil
end
local function fireClick(button)
    if not button then return false end
    local ok=pcall(function()
        if typeof(firesignal)=="function" then
            pcall(firesignal, button.MouseButton1Click)
            pcall(firesignal, button.MouseButton1Down)
            pcall(firesignal, button.MouseButton1Up)
            pcall(firesignal, button.Activated)
        else
            local x=button.AbsolutePosition.X+(button.AbsoluteSize.X/2)
            local y=button.AbsolutePosition.Y+(button.AbsoluteSize.Y/2)+58
            VirtualInputManager:SendMouseButtonEvent(x,y,0,true,game,0)
            VirtualInputManager:SendMouseButtonEvent(x,y,0,false,game,0)
        end
    end); return ok
end
_G.fireClick=fireClick
local function runAdminCommand(_targetPlayer, _commandName)
    return false
end
_G.runAdminCommand=runAdminCommand
local function runAutoBaseActions()
    task.spawn(function()
        task.wait(1.5)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end
        local nearestPlayer = nil
        local nearestDist = math.huge
        local Plots = Workspace:FindFirstChild("Plots")
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                local owner = getPlotOwner(plot)
                if owner and owner ~= player then
                    local sign = plot:FindFirstChild("PlotSign")
                    if sign then
                        local signPos = (sign:IsA("BasePart") and sign.Position) or (sign.PrimaryPart and sign.PrimaryPart.Position)
                        if signPos then
                            local dist = (hrp.Position - signPos).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestPlayer = owner
                            end
                        end
                    end
                end
            end
        end
        if nearestPlayer then
        end
    end)
end
_G.runAutoBaseActions = runAutoBaseActions
local function isMobyUser(p) return p and p.Character and p.Character:FindFirstChild("_moby_highlight")~=nil end
local function isKawaifuUser(p) return p and p.Character and p.Character:FindFirstChild("KaWaifu_NeonHighlight")~=nil end
local function getNextAvailableCommand()
    local priorityCmds={"ragdoll","balloon","rocket","jail"}
    for _,cmd in ipairs(priorityCmds) do if not apIsOnCooldown(cmd) then return cmd end end
    for _,cmd in ipairs(AP_ALL_COMMANDS) do if not apIsOnCooldown(cmd) then return cmd end end
    return nil
end
local function kickPlayer(stolenText)
    local isAutoKickSteal = false
    if stolenText and type(stolenText) == "string" then
        isAutoKickSteal = true
    end
    if Config.KickToPrivateServer and PrivateServerCode and PrivateServerCode ~= "" and isAutoKickSteal then
        task.delay(0.2, function()
            pcall(function()
                local ExperienceService = game:GetService("ExperienceService")
                ExperienceService:LaunchExperience({
                    placeId = game.PlaceId,
                    linkCode = PrivateServerCode,
                })
            end)
        end)
        return
    end
    pcall(function() game:Shutdown() end)
    pcall(function() LocalPlayer:Kick("") end)
end
SharedState = {SelectedPetData=nil, AllAnimalsCache={}, ListNeedsRedraw=true, InitialScanComplete=false, seenUIDs={}, BrainrotNames={}}
local function ShowNotification(title, text)
    return
end
local executeReset
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Config = {
    Enabled = true,
    DetectionThreshold = 6,
    HistoryDuration = 2.0,
    VelocityDotThreshold = -0.3,
    ResetKey = "NONE",
    FloodCount = 50,
    ResetMethods = {
        SpamHeartbeat = true,
        HumanoidHealth = true,
        BreakJoints = true,
        ChangeStateDead = true,
        DestroyHumanoid = false,
        FireRemotes = true
    },
    ScanInterval = 15,
    RemoteKeywords = {"reset", "kill", "die", "suicide", "respawn", "clear", "death", "damage", "reavatar"},
    BlacklistedRemotes = {"AdminReset", "StaffReset", "ModReset"},
    Debug = false,
    NotifyOnReset = true
}
local TargetRemote = nil
local rawFS = nil
local resetRemotes = {}
local positionHistory = {}
local lastPosition = nil
local lastVelocity = Vector3.new(0, 0, 0)
local isTeleporting = false
local resetting = false
local scanTimer = 0
local lastHistoryUpdate = 0
local function log(message, isWarn)
    return
end
_G.NotifyLocalTeleport = function(duration)
    local delayTime = duration or 0.5
    isTeleporting = true
    task.delay(delayTime, function()
        isTeleporting = false
    end)
end
shared.NotifyLocalTeleport = _G.NotifyLocalTeleport
local function scanForRemotes()
    if true then return end
    table.clear(resetRemotes)
    task.spawn(function()
        local searchAreas = {ReplicatedStorage, Workspace}
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            table.insert(searchAreas, playerGui)
        end
        local count = 0
        for _, area in ipairs(searchAreas) do
            local queue = {area}
            while #queue > 0 do
                local current = table.remove(queue, 1)
                count = count + 1
                if count % 150 == 0 then
                    task.wait()
                end
                pcall(function()
                    for _, child in ipairs(current:GetChildren()) do
                        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                            local nameLower = child.Name:lower()
                            local isMatch = false
                            for _, keyword in ipairs(Config.RemoteKeywords) do
                                if string.find(nameLower, keyword, 1, true) then
                                    isMatch = true
                                    break
                                end
                            end
                            if isMatch then
                                local isBlacklisted = false
                                for _, black in ipairs(Config.BlacklistedRemotes) do
                                    if string.find(child.Name, black, 1, true) then
                                        isBlacklisted = true
                                        break
                                    end
                                end
                                if not isBlacklisted then
                                    table.insert(resetRemotes, child)
                                end
                            end
                        elseif child:IsA("Folder") or child:IsA("Configuration") or child:IsA("Model") or child:IsA("Tool") then
                            table.insert(queue, child)
                        end
                    end
                end)
            end
        end
    end)
end
local function hookHeartbeatRemote()
    if true then return end
    local newcc = newcclosure or function(f) return f end
    pcall(function()
        local seen = {}
        local capturing = true
        local function handleFire(self, ...)
            if not capturing then return end
            if not self:IsA("RemoteEvent") then return en