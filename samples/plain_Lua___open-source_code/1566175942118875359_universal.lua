-- Astris Hub universal loader: only recognized Roblox experiences are executed.
local HUB_NAME = "Astris Hub"
local HUB_SLUG = "astris-hub"
local SCRIPTS = {
	{ name = "+1 Speed Monkey Escape", slug = "1-speed-monkey-escape", placeId = 114697347887839, universeId = 10144280947 },
	{ name = "+1 Stone Skipping", slug = "1-stone-skipping", placeId = 111543903102439, universeId = 10765298801 },
	{ name = "+1 Strength for Eggs", slug = "1-strength-for-eggs", placeId = 98610101874791, universeId = 10766138478 },
	{ name = "+1 Tongue Escape", slug = "1-tongue-escape", placeId = 122245938604556, universeId = 10681914462 },
	{ name = "Anime Astral Simulator", slug = "anime-astral-simulator", placeId = 102072869879193, universeId = 10502841145 },
	{ name = "Anime Dice", slug = "anime-dice", placeId = 113290951185459, universeId = 10708913337 },
	{ name = "Blue Lock Farm", slug = "blue-lock-farm", placeId = 132767904294856, universeId = 10700618962 },
	{ name = "Break and Steal an Egg", slug = "break-and-steal-an-egg", placeId = 114326934417838, universeId = 10765288803 },
	{ name = "BUCKSHOT", slug = "buckshot", placeId = 16154918775, universeId = 5580972377 },
	{ name = "Build An Ant Empire", slug = "build-an-ant-empire", placeId = 78490532994307, universeId = 10436530264 },
	{ name = "Dead Rails", slug = "dead-rails", placeId = 116495829188952, universeId = 7018190066 },
	{ name = "Deep Fishing", slug = "deep-fishing", placeId = 132239307080610, universeId = 10526853622 },
	{ name = "Don't Steal the Bobo", slug = "don-t-steal-the-bobo", placeId = 120135584963579, universeId = 8791358380 },
	{ name = "Fling Things and People", slug = "fling-things-and-people", placeId = 6961824067, universeId = 2668101271 },
	{ name = "Heavyweight Fishing", slug = "heavyweight-fishing", placeId = 98502499119821, universeId = 8342498724 },
	{ name = "Huss Valley", slug = "huss-valley", placeId = 107535308163741, universeId = 10764627709 },
	{ name = "Murder Mystery 2", slug = "murder-mystery-2", placeId = 142823291, universeId = 66654135 },
	{ name = "My Anime Mine", slug = "my-anime-mine", placeId = 79389059854988, universeId = 10740316645 },
	{ name = "Pets Universe!", slug = "pets-universe", placeId = 74629631798007, universeId = 10759638075 },
	{ name = "Prison Life", slug = "prison-life", placeId = 155615604, universeId = 73885730 },
	{ name = "Ride A Pet", slug = "ride-a-pet", placeId = 124216119978534, universeId = 10035204815 },
	{ name = "Rivals", slug = "rivals", placeId = 17625359962, universeId = 6035872082 },
	{ name = "RUNAWAYS", slug = "runaways", placeId = 118418618261207, universeId = 7585140258 },
	{ name = "Sailor Piece", slug = "sailor-piece", placeId = 77747658251236, universeId = 9186719164 },
	{ name = "Steal A Verity!", slug = "steal-a-verity", placeId = 107164765081465, universeId = 10550257968 },
	{ name = "Steal an Egg for Squishy Dumplings!", slug = "steal-an-egg-for-squishy-dumplings", placeId = 134679507313109, universeId = 10758397570 },
	{ name = "Surf And Rescue", slug = "surf-and-rescue", placeId = 120252007682677, universeId = 10761375767 },
	{ name = "Swing For Eggs", slug = "swing-for-eggs", placeId = 109203247742910, universeId = 10763764817 },
	{ name = "Twenty One", slug = "twenty-one", placeId = 16446180574, universeId = 5665954430 },
	{ name = "Violence District", slug = "violence-district", placeId = 93978595733734, universeId = 6739698191 },
}
local BASE = "https://oblivion.menu/void/l/" .. HUB_SLUG .. "/"
local function launch(entry)
	local ok, err = pcall(function()
		local source = game:HttpGet(BASE .. entry.slug)
		local fn, compileError = loadstring(source)
		if not fn then error(compileError or "Could not compile loader") end
		task.spawn(fn)
	end)
	if not ok then warn("[Void] Could not start " .. entry.name .. ": " .. tostring(err)) end
end
local placeId = tonumber(game.PlaceId)
local universeId = tonumber(game.GameId)
for _, entry in ipairs(SCRIPTS) do
	if placeId == entry.placeId or universeId == entry.universeId then
		launch(entry)
		return
	end
end
-- Not in this hub's supported-game list: intentionally do nothing.
return
