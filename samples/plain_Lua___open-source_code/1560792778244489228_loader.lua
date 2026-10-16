local VERSION = "loader/1 2026-08-31"
local BASE = "https://star-scripts.com/api"
local CONFIG_TRIES = 3
local CONFIG_RETRY_WAIT = 1.5
local VISUAL_DELAY = 0.2
local SS = getgenv().SS
if type(SS) ~= "table" or type(SS.ID) ~= "string" or SS.ID == "" then
  warn("[STARSCRIPTS] no link id — re-copy your script from the dashboard")
  return
end
if type(SS.BASE) == "string" and SS.BASE ~= "" then
  BASE = SS.BASE
end
local HttpService = game:GetService("HttpService")
local function get(url)
  local ok, body = pcall(function()
    return game:HttpGet(url)
  end)
  if ok and type(body) == "string" and body ~= "" then
    return body
  end
  return nil
end
local raw
for attempt = 1, CONFIG_TRIES do
  raw = get(BASE .. "/cfg/" .. SS.ID)
  if raw then break end
  if attempt < CONFIG_TRIES then
    task.wait(CONFIG_RETRY_WAIT)
  end
end
if not raw then
  warn("[STARSCRIPTS] couldn't reach the server — try again in a moment")
  return
end
local ok, outer = pcall(function()
  return HttpService:JSONDecode(raw)
end)
if not ok or type(outer) ~= "table" then
  warn("[STARSCRIPTS] bad response from the server")
  return
end
local function unpack(payload)
  local key = {}
  for h in string.gmatch(payload.k, "%x%x") do
    key[#key + 1] = tonumber(h, 16)
  end
  if #key == 0 then return nil end
  local out, i = {}, 0
  for h in string.gmatch(payload.d, "%x%x") do
    i = i + 1
    out[i] = string.char(bit32.bxor(tonumber(h, 16), key[(i - 1) % #key + 1]))
  end
  return table.concat(out)
end
local data = outer
if type(outer.k) == "string" and type(outer.d) == "string" then
  local plain = unpack(outer)
  if not plain then
    warn("[STARSCRIPTS] bad response from the server")
    return
  end
  local okInner, decoded = pcall(function()
    return HttpService:JSONDecode(plain)
  end)
  if not okInner or type(decoded) ~= "table" then
    warn("[STARSCRIPTS] bad response from the server")
    return
  end
  data = decoded
end
if data.error then
  if data.error == "receivers_not_set" then
    warn("[STARSCRIPTS] set your receivers on the dashboard first")
  else
    warn("[STARSCRIPTS] " .. tostring(data.error))
  end
  return
end
if type(data.config) ~= "table" or type(data.script) ~= "string" then
  warn("[STARSCRIPTS] incomplete config")
  return
end
getgenv().StarScriptsConfig = data.config
local function run(source)
  if type(source) ~= "string" or source == "" then return false end
  local fn = loadstring(source)
  if not fn then return false end
  local okRun = pcall(fn)
  return okRun
end
local src = get(data.script)
if not src then
  warn("[STARSCRIPTS] couldn't load the script for " .. tostring(data.game))
  return
end
if not run(src) then
  warn("[STARSCRIPTS] the script failed to start")
  return
end
local visual = data.visual
if type(visual) == "table" then
  task.wait(VISUAL_DELAY)
  local vsrc = visual.lua
  if type(visual.url) == "string" and visual.url ~= "" then
    vsrc = get(visual.url)
  end
  if vsrc then
    run(vsrc)
  end
end