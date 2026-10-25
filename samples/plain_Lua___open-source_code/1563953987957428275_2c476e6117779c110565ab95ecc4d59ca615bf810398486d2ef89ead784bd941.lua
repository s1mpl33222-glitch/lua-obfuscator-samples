--[[ PROJECT V2.6 LOADER — HAUNTZ_PURPLE_THEME_FINAL.lua ]]
local _K__64d9a685 = script_key
  or (getgenv and getgenv().script_key)
  or (getfenv and getfenv(0).script_key)
  or _G.script_key

local function _kc__76ce37ad(m)
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

if type(_K__64d9a685) ~= "string" or #_K__64d9a685 == 0 or _K__64d9a685 == "YOUR_KEY_HERE" then
  _kc__76ce37ad("No key provided") return
end

local function _sn__84f4be9d()
  return false
end

local function _hw__4176453b()
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

local _H__51a98630  = "2c476e6117779c110565ab95ecc4d59ca615bf810398486d2ef89ead784bd941"
local _N__965b8ac7 = "1792946088422.85aea474b2ba4eb783dd14614ec532d4.b1b1378ca82b956af23dd1bd7b273e4d"
local _S__cb9a2c42   = "b1b1378ca82b956a"

local _rq__09e57fe2 = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
if not _rq__09e57fe2 then
  _kc__76ce37ad("Executor does not support HTTP requests") return
end

local __t0 = tick()
local _bd__35bf2178 = nil
do
  local ok, res = pcall(_rq__09e57fe2, {
    Url    = "https://projectv26.space/scripts/hosted/_auth",
    Method = "POST",
    Headers = {
      ["Content-Type"] = "application/json",
      ["User-Agent"]   = "Roblox/WinInet",
      ["X-V26-Nonce"]  = _N__965b8ac7,
      ["X-V26-Sig"]    = _S__cb9a2c42,
    },
    Body = game:GetService("HttpService"):JSONEncode({
      k = _K__64d9a685, h = _hw__4176453b(), s = _H__51a98630,
      n = _N__965b8ac7, g = _S__cb9a2c42,
    }),
  })
  if ok and res and res.Body then _bd__35bf2178 = res.Body end
end

if type(_bd__35bf2178) ~= "string" or #_bd__35bf2178 == 0 then
  _kc__76ce37ad("Wrong key") return
end

if (tick() - __t0) > 60 then
  _kc__76ce37ad("Security violation") return
end

local _ch__ef9d8f74, _er__5e947644 = loadstring(_bd__35bf2178, "=V2.6")
_bd__35bf2178 = nil
if collectgarbage then pcall(collectgarbage, "collect") end

if not _ch__ef9d8f74 then
  _kc__76ce37ad("Wrong key") return
end

if getgenv then getgenv().script_key = _K__64d9a685 end
return _ch__ef9d8f74(_K__64d9a685)
