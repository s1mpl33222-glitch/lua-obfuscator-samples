-- Xin's Hub loader, by Wal (@aeusyi). Free and keyless.
-- This is the ONE link people run (it goes to the public xin-hub repo as
-- main.lua, the link everyone already has). It works out which game they are
-- in and loads that game's script from xin-hub.
--
-- To add a game: one entry in GAMES. `file` is the game's script in xin-hub;
-- `gameIds` are the numbers that identify it (game.GameId, the same in every
-- server and sub-place of the game); `detect` is an optional extra check by
-- the game's own contents, for games whose id we do not have.
--
-- Any game not in the list loads Storage Hunters' script, which shows the
-- Xin's Hub "This game is not supported" screen (Home only) outside its game.

local BASE = "https://raw.githubusercontent.com/TwoKeeys/xin-hub/main/"

local GAMES = {
	{
		name = "Storage Hunters: Open World",
		file = "storage-hunters.lua",
		gameIds = {},
		detect = function()
			local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
			if not events then
				return false
			end
			for _, name in ipairs({ "NPCShopper", "Auction", "Plot", "Vehicles" }) do
				if events:FindFirstChild(name) then
					return true
				end
			end
			return false
		end,
	},
}

-- What the "not supported" screen comes from (see the top of this file).
local FALLBACK = "storage-hunters.lua"

local function match()
	for _, entry in ipairs(GAMES) do
		if table.find(entry.gameIds, game.GameId) then
			return entry
		end
	end
	for _, entry in ipairs(GAMES) do
		if entry.detect then
			local ok, yes = pcall(entry.detect)
			if ok and yes then
				return entry
			end
		end
	end
	return nil
end

local entry = match()
if not entry then
	-- Not recognised yet: a fresh server can still be sending the game over.
	local deadline = os.clock() + 60
	while not game:IsLoaded() and os.clock() < deadline do
		task.wait(0.25)
	end
	deadline = os.clock() + 8
	repeat
		task.wait(0.5)
		entry = match()
	until entry or os.clock() > deadline
end

local file = entry and entry.file or FALLBACK
local ok, err = pcall(function()
	loadstring(game:HttpGet(BASE .. file))()
end)
if not ok then
	warn("[Xin's Hub] could not load " .. file .. ": " .. tostring(err))
end
