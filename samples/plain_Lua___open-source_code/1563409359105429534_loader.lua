local BASE = "https://rblx.rip"
local KEY  = _G.RBLX_KEY or (getgenv and getgenv().RBLX_KEY)

local http_get = (syn and syn.request) and function(u)
    return syn.request({ Url = u, Method = "GET" }).Body
end or function(u)
    return game:HttpGet(u)
end

local function executor()
    local ok, name = pcall(function()
        return (identifyexecutor or getexecutorname or function() return "unknown" end)()
    end)
    return ok and name or "unknown"
end

local Http = game:GetService("HttpService")
local function enc(s)
    local ok, out = pcall(Http.UrlEncode, Http, tostring(s))
    return ok and out or tostring(s):gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

local function resolve()
    local pid = tostring(game.PlaceId)
    local url = BASE .. "/raw/auto?place=" .. pid .. "&exec=" .. enc(executor())
    if KEY then url = url .. "&key=" .. enc(KEY) end
    return url
end

local ok, body = pcall(http_get, resolve())
if not ok or not body or #body == 0 then
    warn("[rblx.rip] failed to fetch script - service down or key invalid")
    return
end
if body:sub(1, 8) == "ERROR   " then
    warn("[rblx.rip] " .. body:sub(9))
    return
end

local fn, err = loadstring(body)
if not fn then
    warn("[rblx.rip] compile error: " .. tostring(err))
    return
end
return fn()
