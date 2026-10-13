(getgenv and getgenv() or _G).__W={"twd_online","1791924027.1791923997.0.a2664cfc44422c54ead62b27065eee827dcbe5b961c4fd229780fa7f93625bfc"}
-- So you wanna know what this loader does?
-- The same thing any script host does. It reads who you are, tells us you ran it,
-- gives you the script you asked for, and runs it.
-- Read more about this at https://wolfscript.cc/terms

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local env = (getgenv and getgenv()) or _G
local pack = rawget(env, "__W")
if type(pack) ~= "table" then
	return
end

local SCRIPT_NAME = pack[1]
local CHALLENGE = pack[2]
if type(SCRIPT_NAME) ~= "string" or type(CHALLENGE) ~= "string" then
	return
end

pcall(function()
	rawset(env, "__W", nil)
end)

local ENDPOINT = "https://v1.wolfscript.cc/v1/unlock"

local lp = Players.LocalPlayer
if not lp then
	lp = Players.PlayerAdded:Wait()
end

local executor = "Unknown"
pcall(function()
	executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
end)

local clientId = ""
pcall(function()
	clientId = game:GetService("RbxAnalyticsService"):GetClientId() or ""
end)

local key = ""
pcall(function()
	local packed = rawget(env, "__K")
	if type(packed) == "string" then
		key = packed
	end
end)

local fields = {
	script = SCRIPT_NAME,
	challenge = CHALLENGE,
	placeId = game.PlaceId,
	gameId = game.GameId,
	jobId = game.JobId,
	userId = lp.UserId,
	username = lp.Name,
	displayName = lp.DisplayName,
	executor = executor,
	clientId = clientId,
	key = key,
}

local req = request or http_request or (syn and syn.request) or (http and http.request)
local source = nil

if req then
	local ok, res = pcall(function()
		return req({
			Url = ENDPOINT,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(fields),
		})
	end)
	if ok and res and (res.StatusCode == 200 or res.Status == 200) then
		source = res.Body
	end
else
	local query = ENDPOINT
		.. "?script=" .. HttpService:UrlEncode(SCRIPT_NAME)
		.. "&challenge=" .. HttpService:UrlEncode(CHALLENGE)
		.. "&placeId=" .. tostring(game.PlaceId)
		.. "&gameId=" .. tostring(game.GameId)
		.. "&jobId=" .. HttpService:UrlEncode(game.JobId)
		.. "&userId=" .. tostring(lp.UserId)
		.. "&username=" .. HttpService:UrlEncode(lp.Name)
		.. "&displayName=" .. HttpService:UrlEncode(lp.DisplayName)
		.. "&executor=" .. HttpService:UrlEncode(executor)
		.. "&clientId=" .. HttpService:UrlEncode(clientId)
	if key ~= "" then
		query = query .. "&key=" .. HttpService:UrlEncode(key)
	end
	local ok, res = pcall(function()
		return game:HttpGet(query)
	end)
	if ok then
		source = res
	end
end

if type(source) ~= "string" or #source < 32 or string.sub(source, 1, 18) == "-- request refused" then
	warn("This copy didn't go through. Grab it again from discord.gg/gHHXRHaKj3")
	return
end

local chunk, compileError = loadstring(source)
if not chunk then
	warn("Couldn't run it: " .. tostring(compileError))
	return
end

if setfenv then
	pcall(setfenv, chunk, env)
end
task.spawn(chunk)

-- Are you satisfied now?
