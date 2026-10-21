--[[ PROJECT V2.6 LOADER — message.txt ]]
local _K__ddb590bc = script_key
  or (getgenv and getgenv().script_key)
  or (getfenv and getfenv(0).script_key)
  or _G.script_key

local function _kc__f737463d(m)
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

if type(_K__ddb590bc) ~= "string" or #_K__ddb590bc == 0 or _K__ddb590bc == "YOUR_KEY_HERE" then
  _kc__f737463d("No key provided") return
end

-- ─── Anti-hook sentinels (SAFE HARNESS) ─────────────────────────────
local function _sn__75283665()
  return false
end

-- ─── HWID (multi-vector so static spoofs are obvious) ───────────────
local function _hw__783f1de4()
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
local _H__6c105ef1  = "d9394d606f0645b6f27d285fa82e3c0f2a4a53cc61b04784e4e1985dd0341373"
local _N__4245866b = "1792604168739.1c51434ffb5d4af3975debc864f498d8.d45ef37019e435168fea0b39cc27675e"
local _S__2847fa7e   = "d45ef37019e43516"

local _rq__13fb1c09 = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
if not _rq__13fb1c09 then
  _kc__f737463d("Executor does not support HTTP requests") return
end

local __t0 = tick()
local _bd__547defea = nil
do
  local ok, res = pcall(_rq__13fb1c09, {
    Url    = "https://projectv26.space/scripts/hosted/_auth",
    Method = "POST",
    Headers = {
      ["Content-Type"] = "application/json",
      ["User-Agent"]   = "Roblox/WinInet",
      ["X-V26-Nonce"]  = _N__4245866b,
      ["X-V26-Sig"]    = _S__2847fa7e,
    },
    Body = game:GetService("HttpService"):JSONEncode({
      k = _K__ddb590bc, h = _hw__783f1de4(), s = _H__6c105ef1,
      n = _N__4245866b, g = _S__2847fa7e,
    }),
  })
  if ok and res and res.Body then _bd__547defea = res.Body end
end

if type(_bd__547defea) ~= "string" or #_bd__547defea == 0 then
  _kc__f737463d("Wrong key") return
end

-- Network timeout check (60 seconds)
if (tick() - __t0) > 60 then
  _kc__f737463d("Security violation") return
end

local _ch__62ba9fdc, _er__d39ccec6 = loadstring(_bd__547defea, "=V2.6")
-- Wipe plaintext payload from locals right after compile
_bd__547defea = nil
if collectgarbage then pcall(collectgarbage, "collect") end

if not _ch__62ba9fdc then
  _kc__f737463d("Wrong key") return
end

if getgenv then getgenv().script_key = _K__ddb590bc end
return _ch__62ba9fdc(_K__ddb590bc)
