local scripts = {
  ["5166944221"] = "c12d7a4a94f0d10c27f21ff462e781d5",
  ["7028566528"] = "9dd3ccd48c3e87b1a223d0a175fc6876",
  ["6739698191"] = "b64eaf788b0c15c54c17ee96a133bc7a",
  ["10007567876"] = "6aff1732647e82be5eeb8ebb108710a1",
  ["964540701"] = "e8eb78843c7babd4c1cf673c832ed54a",
  ["7738524573"] = "3c8cbc7e049bf4f49bac804b6d20b337",
  ["4783811486"] = "2c7eb16a08c32a940d6df4fedceae130"
}

local id = scripts[tostring(game.GameId)]
if not id then
  return
end

local env = (type(getgenv) == "function" and getgenv()) or _G
local key = env.script_key or script_key
if type(key) ~= "string" or #key ~= 32 then
  return
end

local sdkLoaded, api = pcall(function()
  return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
end)
if not sdkLoaded or type(api) ~= "table" then
  return
end

api.script_id = id
local keyChecked, status = pcall(function()
  return api.check_key(key)
end)
if not keyChecked or type(status) ~= "table" or status.code ~= "KEY_VALID" then
  return
end

env.script_key = key
_G.script_key = key
script_key = key

pcall(function()
  api.load_script()
end)
