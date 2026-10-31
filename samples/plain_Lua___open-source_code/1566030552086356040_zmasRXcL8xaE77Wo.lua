local _LP_CONFIG = {
  HOST_URL = "https://exec.luaprotect.dev",
  WS_URL = "wss://exec.luaprotect.dev/ws",
  SCRIPT_ID = "zmasRXcL8xaE77Wo",
  SCRIPT_NAME = "Bloxstrike",
  RUNNER_ID = "9fb001c9ee4c1d0303180e5820540794",
  RUNNER_KEY = "9789e674745b2aeb43bbb32de4253029973d1e3a4e5c3645fcf8400c4a13a05f",
  NESTED_IMPORT = "0",
  DISABLE_NOTIFICATIONS = 0,
  THEME_BG = "",
  THEME_ACCENT = "",
  THEME_TEXT = "",
  RUNNER_KEY_PROMPT = "0",
  KEY_FLOW_URL = "",
  CONTINUOUS_SESSION = "0",
  CONTINUOUS_RECONNECT = "0",
  HANDOFF_RUNNER_ID = "",
  HANDOFF_KEY = "",
  HANDOFF_RUN_ID = "",
  HANDOFF_SESSION_ID = ""
};
_LP_CONFIG = _LP_CONFIG;
_LP_RUNNER_CONFIG = _LP_CONFIG;
if typeof(getgenv) == "function" then pcall(function() getgenv()._LP_RUNNER_CONFIG = _LP_CONFIG end) end
if typeof(shared) == "table" then pcall(function() shared._LP_RUNNER_CONFIG = _LP_CONFIG end) end
if typeof(_G) == "table" then pcall(function() _G._LP_RUNNER_CONFIG = _LP_CONFIG end) end
if typeof(getrenv) == "function" then pcall(function() getrenv()._LP_RUNNER_CONFIG = _LP_CONFIG end) end
local _h, _n = "e6f83771c78492d5c364a543", 948793
local _p = "luaprotect/runner_" .. _h .. ".lua"
local _s
pcall(function() if isfile and isfile(_p) then _s = readfile(_p) end end)
if type(_s) ~= "string" or #_s ~= _n then
    _s = game:HttpGet("https://exec.luaprotect.dev/api/runner-body/" .. _h)
    if #_s == _n then
        pcall(function()
            if not isfolder("luaprotect") then makefolder("luaprotect") end
            if listfiles then for _, f in ipairs(listfiles("luaprotect")) do
                if tostring(f):find("runner_", 1, true) then pcall(delfile, f) end
            end end
            writefile(_p, _s)
        end)
    end
end
local _f, _e = loadstring(_s)
if not _f then error("[LuaProtect] runner failed to load: " .. tostring(_e), 0) end
return _f(...)
