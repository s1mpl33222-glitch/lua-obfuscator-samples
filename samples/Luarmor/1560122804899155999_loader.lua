if (getgenv().UC_LOADED) then
	return;
end;
getgenv().UC_LOADED = true;

if (identifyexecutor() == "Wave") then
	getgenv().gethui = function()
		return game:GetService("CoreGui");
	end;	
end;

if (game.GameId == 6035872082) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/b6956594687d0095f5afdd3e2a2056ad.lua"))();
elseif (game.GameId == 1008451066) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/0326476cc171449b7563fb4e5eae0415.lua"))();
elseif (game.PlaceId == 2317712696) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/86943e213581a8598e8a38e5bba4c975.lua"))();
end;
