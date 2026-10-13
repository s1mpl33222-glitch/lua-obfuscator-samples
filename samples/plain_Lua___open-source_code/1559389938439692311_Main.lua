--[[
  ____               _              _     ____   _                _    
 |  _ \  _ __  ___  (_)  ___   ___ | |_  / ___| | |_  __ _  _ __ | | __
 | |_) || '__|/ _ \ | | / _ \ / __|| __| \___ \ | __|/ _` || '__|| |/ /
 |  __/ | |  | (_) || ||  __/| (__ | |_   ___) || |_| (_| || |   |   <
 |_|    |_|   \___/_/ | \___| \___| \__| |____/  \__|\__,_||_|   |_|\_\
                  |__/                                                                               ]]
local bases = { "https://urbanstorm.uk", "https://api.hyxx.win" }
local source
for _, base in ipairs(bases) do
	local ok, res = pcall(function()
		return game:HttpGet(base .. "/api/loader", true)
	end)
	if not ok or type(res) ~= "string" or #res == 0 then
		ok, res = pcall(function()
			return game:HttpGet(base .. "/api/loader")
		end)
	end
	if ok and type(res) == "string" and #res > 0 then
		source = res
		break
	end
end
if not source then
	error("Project Stark: could not reach the loader. Check your connection and rejoin.")
end
return loadstring(source)()
