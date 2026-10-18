local url = "https://raw.githubusercontent.com/hm5650/HBSS/refs/heads/main/HBSS.lua"

local req = request or http_request or (syn and syn.request)
local data
if req then
	local res = req({
		Url = url,
		Method = "GET"
	})
	if res and res.Body then
		data = res.Body
	end
else
	pcall(function()
		data = game:HttpGet(url)
	end)
end
if data then
	loadstring(data)()
else
	warn("gravel.cc phailed to load :(")
end