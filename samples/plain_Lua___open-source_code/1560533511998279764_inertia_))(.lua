local function getRequest()
  return (syn and syn.request) or (http and http.request) or http_request or request
end

local function fetch(url)
  local req = getRequest()
  if type(req) == "function" then
    local ok, res = pcall(function() return req({ Url = tostring(url), Method = "GET" }) end)
    if ok and res and (res.Body or res.body) then return tostring(res.Body or res.body) end
  end
  local ok, body = pcall(function() return game:HttpGet(tostring(url), true) end)
  if ok then return body end
  return nil
end

getgenv().INERTIA_API_URL = "https://ezkeys.wtf"
local url = (getgenv and getgenv().INERTIA_KEY_SYSTEM_URL) or "https://raw.githubusercontent.com/JustKondzio0010/InertiaKEYSYS/refs/heads/main/obfuscated.lua"
local src = fetch(url)
if type(src) ~= "string" or src == "" then return end
local fn = loadstring(src)
if type(fn) ~= "function" then return end
return fn()
