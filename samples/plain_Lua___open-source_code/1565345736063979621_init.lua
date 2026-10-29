local url = "https://api.redstoneguard.xyz/api/loader/a13b7ec7-95e9-4323-bf24-c5d2a0ecc99b/init" .. "?fresh=" .. tostring(math.random(1, 1000000000)) .. tostring(math.random(1, 1000000000))
local source = game:HttpGet(url, true)
local fn, err = loadstring(source)
if not fn then error("RG: Init compile failed: " .. tostring(err), 0) end
return fn()
