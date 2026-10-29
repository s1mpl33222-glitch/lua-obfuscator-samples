local AUTH_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/zexc-8fd9c3/auth"
local PAYLOAD_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/zexc-8fd9c3/payload"
local FFA = true
local HEAD = "[ VANTARMOR ]\n"
local MSG = {
  KEY_REQUIRED = HEAD .. "A valid key is required.",
  KEY_INVALID = HEAD .. "The key is not valid.",
  KEY_EXPIRED = HEAD .. "Your key has expired.",
  NOT_AUTHORIZED = HEAD .. "You are not authorized to run this script.",
  HWID_MISMATCH = HEAD .. "This key is linked to another device.",
  VERIFY_FAILED = HEAD .. "Verification failed. Please rejoin.",
  CONNECTION_FAILED = HEAD .. "Connection failed. Please try again.",
  TAMPERING = HEAD .. "Tampering detected.",
  SCRIPT_NOT_FOUND = HEAD .. "Script not found.",
  REAUTH = HEAD .. "Please re-authenticate.",
  BLACKLISTED = HEAD .. "Access denied.",
  MAINTENANCE = HEAD .. "This script is under maintenance.\nPlease try again in a few minutes.",
  MAINTENANCE_ALL = HEAD .. "Vantarmor is under maintenance.\nPlease try again in a few minutes.",
  SERVER_UNREACHABLE = HEAD .. "Server unreachable. Please try later.",
  PAYLOAD_LOAD_FAILED = HEAD .. "The script could not be loaded by your executor.\nPlease contact the script owner.",
}
local Players = game:GetService("Players")
local function kick(code)
  local msg = MSG[code] or MSG.VERIFY_FAILED
  local lp = Players.LocalPlayer
  if lp then lp:Kick(msg) end
  error(msg, 0)
end
-- Si loadstring fue reemplazado por una función de Lua (un volcador que intercepta el código), se corta
local function nativeFn(f)
  if type(f) ~= "function" then return false end
  local okI, info = pcall(function() return debug.getinfo(f, "S") end)
  return not (okI and type(info) == "table" and info.what ~= "C")
end
local function loaderTampered()
  -- loadstring es la vía del payload; load también puede usarse para volcar, así que se revisan los dos
  if not nativeFn(loadstring) then return true end
  if type(load) == "function" and not nativeFn(load) then return true end
  return false
end
local key = ""
if type(script_key) == "string" then key = (script_key:gsub("^%s+", ""):gsub("%s+$", "")) end
if key == "" and not FFA then kick("KEY_REQUIRED") end
local function enc(s) return (s:gsub("[^%w%-_%.~]", function(c) return string.format("%%%02X", string.byte(c)) end)) end
local hwid = ""
local okh, h = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
if okh and h then hwid = h end
local rbxid = ""
local okr, rid = pcall(function() return tostring(Players.LocalPlayer.UserId) end)
if okr and rid then rbxid = rid end
-- Detector de dump por tiempo y frames: si el reloj o el Heartbeat están congelados, se reporta como volcado
local detections = 0
local function runDetectors()
  local ok = pcall(function()
    local a = tonumber(os.date("%S"))
    task.wait(1.1)
    local b = tonumber(os.date("%S"))
    if not a or not b or a == b then detections += 1 end
    local hits = 0
    local conn = game:GetService("RunService").Heartbeat:Connect(function() hits += 1 end)
    local t0 = os.clock()
    repeat task.wait() until hits >= 2 or os.clock() - t0 > 2
    conn:Disconnect()
    if hits < 2 then detections += 1 end
  end)
  -- Si el propio detector falla no se castiga al jugador (evita falsos positivos en ejecutores raros)
  return ok
end
runDetectors()
if detections > 0 then
  pcall(function() game:HttpGet(AUTH_URL .. "?key=" .. enc(key) .. "&hwid=" .. enc(hwid) .. "&rbxid=" .. enc(rbxid) .. "&tamper=1") end)
  script_key = nil
  kick("TAMPERING")
end
-- Detector de entorno (hooks, metatables, integridad del runtime). Devuelve 109 si todo está limpio.
local function envProbeRun()
  local _ef = 0
  pcall(function()
    local _t, _p, _rg, _rs, _re = type, pcall, rawget, rawset, rawequal
    if _t(game) ~= "userdata" or _t(Enum) ~= "userdata" then return end
    if _VERSION ~= "Luau" then return end
    local _n = 0 / 0
    if _n == _n then return end
    if _t(math) ~= "table" or _t(string) ~= "table" then return end
    if _t(bit32) == "table" and bit32.bxor and bit32.bxor(0xA5A5, 0xA5A5) ~= 0 then return end
    if math.floor(1.9) ~= 1 then return end
    if string.byte("Z") ~= 90 then return end
    local _slot = {}
    local _mk = function() end
    if not _p(_rs, _slot, 0x2BAD, _mk) then return end
    if not _re(_rg(_slot, 0x2BAD), _mk) then return end
    _rs(_slot, 0x2BAD, nil)
    if _rg(_slot, 0x2BAD) ~= nil then return end
    local function _dec(_tb, _k)
      local _r = {}
      for _i = 1, #_tb do
        local _ki = (_k * ((_i % 11) + 1) + _i * 7 + (_k % 31)) % 256
        _r[_i] = string.char((_tb[_i] - _ki + 512) % 256)
      end
      return table.concat(_r)
    end
    -- Sonda de Tween con tiempo máximo (no se queda esperando si el Tween nunca termina)
    pcall(function()
      local _tw = _dec({
        (797217 - 796977), (-651497 + 651720), (192857 + (-192704)), (269712 - 269611),
        (226643 - 226585), (379280 - 379045), (435962 + (-435761)), (882599 + (-882437)),
        (287161 + (-287047)), (-770111 + 770160), (-774263 + 774391), (-845570 + 845648)
      }, 197)
      local _fr = Instance.new("Frame")
      local _c = 0
      _fr:GetPropertyChangedSignal("Position"):Connect(function() _c = _c + 1 end)
      local _ts = game:GetService(_tw)
      local _tn = _ts:Create(_fr, TweenInfo.new(0.01), { Position = UDim2.new(1, 0, 1, 0) })
      local _done = false
      _tn.Completed:Connect(function() _done = true end)
      _tn:Play()
      local _t0 = os.clock()
      repeat task.wait() until _done or os.clock() - _t0 > 2
      _fr:Destroy()
    end)
    -- Sonda de FPS
    pcall(function()
      local _ws = _dec({
        (896050 - 895799), (793030 + (-792931)), (234421 - 234239), (-742994 + 743249),
        (-132469 + 132556), (320775 - 320611), (497771 + (-497542)), (947677 + (-947622)),
        (-380387 + 380524)
      }, 73)
      game:GetService(_ws):GetRealPhysicsFPS()
    end)
    -- Funciones de hook del ejecutor: si aparecen, no se cuenta como limpio
    local _okE, _f = _p(function()
      return getfenv and getfenv(0) or getgenv and getgenv() or {}
    end)
    if _okE and _t(_f) == "table" then
      for _, _nm in ipairs({ "hookfunction", "hookmetamethod", "hookm", "replaceclosure", "getgc" }) do
        if _rg(_f, _nm) ~= nil then return end
      end
    end
    -- Integridad de la metatable de game (suave)
    pcall(function()
      if not getrawmetatable then return end
      local _s, _mt = _p(getrawmetatable, game)
      if _s and _t(_mt) == "table" then
        if _rg(_mt, "__index") == nil and _rg(_mt, "__namecall") == nil then return end
      end
    end)
    _ef = 109
  end)
  return _ef
end
local envScore = envProbeRun()
if envScore ~= 109 then
  pcall(function() game:HttpGet(AUTH_URL .. "?key=" .. enc(key) .. "&hwid=" .. enc(hwid) .. "&rbxid=" .. enc(rbxid) .. "&tamper=1") end)
  script_key = nil
  kick("TAMPERING")
end
-- Si loadstring fue interceptado: se avisa al servidor (dueño) y se corta antes de validar la key
if loaderTampered() then
  pcall(function() game:HttpGet(AUTH_URL .. "?key=" .. enc(key) .. "&hwid=" .. enc(hwid) .. "&rbxid=" .. enc(rbxid) .. "&tamper=1") end)
  script_key = nil
  kick("TAMPERING")
end
local ok, body = pcall(function() return game:HttpGet(AUTH_URL .. "?key=" .. enc(key) .. "&hwid=" .. enc(hwid) .. "&rbxid=" .. enc(rbxid)) end)
script_key = nil
if not ok or type(body) ~= "string" then kick("SERVER_UNREACHABLE") end
local code = body:match("^!VANTARMOR:(%u[%u_]*)$")
if code then kick(code) end
local tok = body:match("^!VANTARMOR:OK:(%x+)$")
if not tok then kick("VERIFY_FAILED") end
local ok2, payload = pcall(function() return game:HttpGet(PAYLOAD_URL .. "?token=" .. tok) end)
if not ok2 or type(payload) ~= "string" then kick("CONNECTION_FAILED") end
local pcode = payload:match("^!VANTARMOR:(%u[%u_]*)$")
if pcode then kick(pcode) end
if loaderTampered() then kick("TAMPERING") end
local fn = loadstring(payload)
if not fn then kick("PAYLOAD_LOAD_FAILED") end
fn()
