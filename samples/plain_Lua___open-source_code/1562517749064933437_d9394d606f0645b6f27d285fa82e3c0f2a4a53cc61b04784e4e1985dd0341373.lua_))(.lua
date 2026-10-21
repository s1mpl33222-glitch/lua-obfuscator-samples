--[[ PROJECT V2.6 LOADER — message.txt ]]
local _K__2d6f0ed1 = script_key
  or (getgenv and getgenv().script_key)
  or (getfenv and getfenv(0).script_key)
  or _G.script_key

local function _kc__c9a8fff8(m)
  task.spawn(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    if not lp then
      local t = tick()
      repeat task.wait() until Players.LocalPlayer or (tick() - t > 3)
      lp = Players.LocalPlayer
    end
    if lp then lp:Kick(m) end
  end)
end

if type(_K__2d6f0ed1) ~= "string" or #_K__2d6f0ed1 == 0 or _K__2d6f0ed1 == "YOUR_KEY_HERE" then
  _kc__c9a8fff8("No key provided") return
end

-- ─── Anti-hook sentinels (SAFE HARNESS) ─────────────────────────────
local function _sn__1d6a282f()
  return false
end

-- ─── HWID (multi-vector so static spoofs are obvious) ───────────────
local function _hw__50368ad6()
  local parts = {}
  local ok1, a = pcall(function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
  end)
  if ok1 and type(a) == "string" then parts[#parts+1] = a end
  if gethwid then
    local ok2, b = pcall(gethwid)
    if ok2 and type(b) == "string" then parts[#parts+1] = b end
  end
  if identifyexecutor then
    local ok3, c = pcall(identifyexecutor)
    if ok3 and type(c) == "string" then parts[#parts+1] = c end
  end
  if #parts == 0 then return "GEN-" .. tostring(game:GetService("Players").LocalPlayer.UserId) end
  table.sort(parts)
  return table.concat(parts, ";")
end

-- ─── Handshake & payload fetch ─────────────────────────────────────
local _H__abd2d30c  = "d9394d606f0645b6f27d285fa82e3c0f2a4a53cc61b04784e4e1985dd0341373"
local _N__99782377 = "1792603662612.33482294786a4da0a3af5ea0bdcf27af.0d124667a0279020f2980c49ff3c8b17"
local _S__715c128f   = "0d124667a0279020"

local _rq__b28d5471 = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
if not _rq__b28d5471 then
  _kc__c9a8fff8("Executor does not support HTTP requests") return
end

local __t0 = tick()
local _bd__35cc2170 = nil
do
  local ok, res = pcall(_rq__b28d5471, {
    Url    = "https://projectv26.space/scripts/hosted/_auth",
    Method = "POST",
    Headers = {
      ["Content-Type"] = "application/json",
      ["User-Agent"]   = "Roblox/WinInet",
      ["X-V26-Nonce"]  = _N__99782377,
      ["X-V26-Sig"]    = _S__715c128f,
    },
    Body = game:GetService("HttpService"):JSONEncode({
      k = _K__2d6f0ed1, h = _hw__50368ad6(), s = _H__abd2d30c,
      n = _N__99782377, g = _S__715c128f,
    }),
  })
  if ok and res and res.Body then _bd__35cc2170 = res.Body end
end

if type(_bd__35cc2170) ~= "string" or #_bd__35cc2170 == 0 then
  _kc__c9a8fff8("Wrong key") return
end

-- Network timeout check (60 seconds)
if (tick() - __t0) > 60 then
  _kc__c9a8fff8("Security violation") return
end

local _ch__fb10c2a1, _er__ea72917f = loadstring(_bd__35cc2170, "=V2.6")
-- Wipe plaintext payload from locals right after compile
_bd__35cc2170 = nil
if collectgarbage then pcall(collectgarbage, "collect") end

if not _ch__fb10c2a1 then
  _kc__c9a8fff8("Wrong key") return
end

if getgenv then getgenv().script_key = _K__2d6f0ed1 end
return _ch__fb10c2a1(_K__2d6f0ed1)
