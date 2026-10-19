if not game:IsLoaded() then
	game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/realnexthub-source/next-hub/main/"

local places = {
	[124216119978534] = {file = "NEXTHUBxRIDEAPET.lua", version = 1},
	[135187059974536] = {file = "NEXTHUBxWARZ.lua", version = 1},
	[118805555015549] = {file = "NEXTHUBxLOOTTOFORGE.lua", version = 1},
}

local entry = places[game.PlaceId]
if type(entry) ~= "table" or type(entry.file) ~= "string" then
	return
end

local ok, source = pcall(function()
	return game:HttpGet(BASE .. entry.file .. "?v=" .. tostring(entry.version or 1))
end)
if not ok or type(source) ~= "string" or source == "" then
	return
end

local chunk = loadstring(source)
if type(chunk) ~= "function" then
	return
end

pcall(chunk)
