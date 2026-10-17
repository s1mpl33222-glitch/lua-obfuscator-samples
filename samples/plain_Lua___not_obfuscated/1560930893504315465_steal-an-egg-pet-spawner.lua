-- ScriptVerse / steal-an-egg-pet-spawner
-- Update scripts on the server - this URL never needs to change.
pcall(function()
  local g = getgenv and getgenv() or _G
  g.SV_SLUG = "steal-an-egg-pet-spawner"
end)
local function __sv_httpget(url)
  local ok, body = pcall(function()
    return game:HttpGet(url)
  end)
  if ok and type(body) == "string" and #body > 10 then
    return body
  end
  local req = (syn and syn.request) or (http and http.request) or http_request or request
  if req then
    local r = req({ Url = url, Method = "GET" })
    local b = r and (r.Body or r.body)
    if type(b) == "string" and #b > 10 then
      return b
    end
  end
  error("ScriptVerse: failed to download " .. tostring(url))
end
local __sv_src = __sv_httpget("https://scriptversekey.xyz/loader.lua")
local __sv_fn, __sv_err = loadstring(__sv_src)
if not __sv_fn then
  error("ScriptVerse: loader compile failed: " .. tostring(__sv_err))
end
__sv_fn()
