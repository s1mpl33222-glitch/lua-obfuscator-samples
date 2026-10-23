getgenv().Key = "expired-never"
local GAS_URL = "https://script.google.com/macros/s/AKfycbwHe7TPIx5x5Obw7hDzxCD-GrQ7TJF-QL-VrY2NlnZ5HUnwSC5tWB1nCjjp30xZLPFvoA/exec"

local USER_KEY = getgenv().Key or ""

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

if type(GAS_URL) ~= "string"
    or not GAS_URL:match("^https://script%.google%.com/macros/s/[A-Za-z0-9-_]+/exec$") then
    LocalPlayer:Kick("Bad auth URL")
    return
end

local function HWID()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and type(id) == "string" and #id > 0 then
        return id
    end
    return "UNKNOWN"
end

local function fetch(url)
    local ok1, r1 = pcall(httpget, url)
    if ok1 and type(r1) == "string" and #r1 > 0 then
        return r1
    end
    local ok2, r2 = pcall(function()
        return request({ Url = url, Method = "GET" })
    end)
    if ok2 and type(r2) == "table" and type(r2.Body) == "string" and #r2.Body > 0 then
        return r2.Body
    end
    local ok3, r3 = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok3 and type(r3) == "string" and #r3 > 0 then
        return r3
    end
    return nil
end

local function PublicIP()
    local urls = { "https://api.ipify.org", "https://icanhazip.com" }
    for _, u in ipairs(urls) do
        local body = fetch(u)
        if type(body) == "string" then
            local ip = body:gsub("%s+", "")
            if ip:match("^%d+%.%d+%.%d+%.%d+$") or ip:match("^[%x:]+$") then
                return ip
            end
        end
    end
    return "UNKNOWN"
end

local hwid = HWID()
local ip = PublicIP()
local raw = fetch(GAS_URL .. "?hwid=" .. HttpService:UrlEncode(hwid)
    .. "&ip=" .. HttpService:UrlEncode(ip)
    .. "&key=" .. HttpService:UrlEncode(USER_KEY)
    .. "&user=" .. HttpService:UrlEncode(LocalPlayer.Name)
    .. "&userid=" .. tostring(LocalPlayer.UserId)
    .. "&place=" .. tostring(game.PlaceId)
    .. "&t=" .. tick())

if not raw then
    LocalPlayer:Kick("Auth server unreachable")
    return
end

local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
raw = nil
if not ok or type(res) ~= "table" then
    LocalPlayer:Kick("Bad auth response")
    return
end

if res.ok ~= true or type(res.src) ~= "string" or #res.src == 0 then
    local reason = tostring(res.reason or "Auth failed")
    pcall(setclipboard, hwid)
    LocalPlayer:Kick(reason)
    return
end

local chunk = loadstring(res.src)
res = nil
if chunk then
    pcall(function()
        local g = getgenv and getgenv() or _G
        g.GAS = GAS_URL
        g.H = hwid
        g.K = USER_KEY
        g.U = LocalPlayer.Name
        g.P = tostring(game.PlaceId)
        g.IP = ip
    end)
    chunk()
end
