--[[
	FE Brimstone
	The last Forsaken...
	
	https://discord.gg/bjTxKxjJVc
	Join 24-HOURS for more scripts [Star Glitcher V2 up next]
]]--

local urls = {
	"https://raw.githubusercontent.com/BloxinStud10/24-Hours/refs/heads/main/Obfuscations/Brimstone.luau",
	"https://cdn.jsdelivr.net/gh/BloxinStud10/24-Hours@main/heads/main/Obfuscations/Brimstone.luau"
}
local a=(syn and syn.request)or request;local b=nil;for c,c in next,urls do if a then local a,c=pcall(a,{Method="GET",Url=c})if a and c then b=c.Body;break end else local a,c=pcall(game.HttpGetAsync,game,c)if a and c then b=c;break end end end;if b then loadstring(b)()else warn("Http buggin")end
