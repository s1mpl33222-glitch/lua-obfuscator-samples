local AUTH_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/flash-and-block-vs-175-60c484/auth"
local PAYLOAD_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/flash-and-block-vs-175-60c484/payload"
local FFA = false
local MSG = {
  KEY_REQUIRED = "🔑 Key is required",
  KEY_INVALID = "❌ Invalid key",
  KEY_EXPIRED = "⏱️ Session expired, rejoin",
  NOT_AUTHORIZED = "🚫 Not authorized",
  HWID_MISMATCH = "📝 Hwid is mismatch",
  VERIFY_FAILED = "🔒 Verification failed",
  CONNECTION_FAILED = "🌐 Connection failed, try again",
  TAMPERING = "⚠️ Tampering detected",
  SCRIPT_NOT_FOUND = "📋 Script ID not found",
  REAUTH = "🔄 Please re-authenticate",
  BLACKLISTED = "🛡️ Blacklisted",
  SERVER_UNREACHABLE = "📡 Server unreachable",
}
local Players = game:GetService("Players")
local function kick(code)
  local msg = MSG[code] or MSG.VERIFY_FAILED
  local lp = Players.LocalPlayer
  if lp then lp:Kick(msg) end
  error(msg, 0)
end
local key = ""
if type(script_key) == "string" then key = (script_key:gsub("^%s+", ""):gsub("%s+$", "")) end
if key == "" and not FFA then kick("KEY_REQUIRED") end
local function enc(s) return (s:gsub("[^%w%-_%.~]", function(c) return string.format("%%%02X", string.byte(c)) end)) end
local hwid = ""
local okh, h = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
if okh and h then hwid = h end
local ok, body = pcall(function() return game:HttpGet(AUTH_URL .. "?key=" .. enc(key) .. "&hwid=" .. enc(hwid)) end)
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
local fn = loadstring(payload)
if not fn then kick("VERIFY_FAILED") end
fn()
