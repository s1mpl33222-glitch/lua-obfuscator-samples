if RUN_AFTER then
	local finished = false
	task.spawn(function()
		pcall(RUN_AFTER)
		finished = true
	end)
	local started = os.clock()
	repeat task.wait() until finished or os.clock() - started >= 7
end

if game.PlaceId == 126884695634066 then
     loadstring(game:HttpGet("https://cdn.project-reverse.org/gag.luau"))()
elseif game.GameId == 10200395747 then
     loadstring(game:HttpGet("https://cdn.project-reverse.org/gag2.luau"))()
elseif game.PlaceId == 142823291 then
    loadstring(game:HttpGet("https://cdn.project-reverse.org/mm2.luau"))()
elseif game.PlaceId == 920587237 then
    loadstring(game:HttpGet("https://cdn.project-reverse.org/ame.luau"))()
elseif game.PlaceId == 96342491571673 or game.PlaceId == 109983668079237 then
    loadstring(game:HttpGet("https://cdn.project-reverse.org/sab.luau"))()
elseif game.PlaceId == 13772394625 then
    loadstring(game:HttpGet("https://cdn.project-reverse.org/BladeBall.luau"))()
end
