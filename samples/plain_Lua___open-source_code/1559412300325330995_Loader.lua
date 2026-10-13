--[[
               
  ____ ________
_/ __ \\___   /
\  ___/ /    / 
 \___  >_____ \
     \/      \/

]]

if (getgenv().EZ_LOADED) then
	warn("[ Elite Zone ] Elite Zone is already loaded.")
	return;
end;

if (getgenv().SCRIPT_KEY) then
	pcall(function()
		makefolder("Elite Zone");
		makefolder("Elite Zone/cache");
		writefile("Elite Zone/cache/key.dat", getgenv().SCRIPT_KEY);
	end);
elseif (readfile and isfile and isfile("Elite Zone/cache/key.dat")) then
	local success, key = pcall(readfile, "Elite Zone/cache/key.dat");

	if (success and key and key ~= "") then
		getgenv().SCRIPT_KEY = key;
	end;
end;

if (not getgenv().SCRIPT_KEY) then
	getgenv().SCRIPT_KEY = "KEYLESS";
end;

local Lighting = game:GetService("Lighting");

while (Lighting:FindFirstChild("LoadingScreen")) do
	task.wait(0.1);
end;

loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/fc6c41033fff55a0515fd72167127e8be413724c62cdcc464a6a9e9b3a84bb5b/download"))()
