local AUTH_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/codee-reemer-9b4d39/auth"
local PAYLOAD_URL = "https://vantarmorweb-production.up.railway.app/scripts/hosted/codee-reemer-9b4d39/payload"
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
  SERVER_UNREACHABLE = HEAD .. "Server unreachable. Please try later.",
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
local rbxid = ""
local okr, rid = pcall(function() return tostring(Players.LocalPlayer.UserId) end)
if okr and rid then rbxid = rid end
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
local fn = loadstring(payload)
if not fn then kick("VERIFY_FAILED") end
fn()
