local hash = "d0fc06b7125c12bcfb5fbdfd2c118715"
local api = "https://luavify-protector.itskevin.workers.dev"
local payloadUrl = api .. "/api/get-payload?hash=d0fc06b7125c12bcfb5fbdfd2c118715"
local runtimeKey = ""
pcall(function()
    if getgenv then runtimeKey = tostring(getgenv().script_key or "") end
end)
if runtimeKey ~= "" then
    local encoded = runtimeKey
    pcall(function() encoded = game:GetService("HttpService"):UrlEncode(runtimeKey) end)
    payloadUrl = payloadUrl .. "&key=" .. encoded
end

local function warnMsg(m) pcall(function() warn("[Luavify] " .. tostring(m)) end) end
local function fail(m)
    warnMsg(m)
    pcall(function() game:GetService("Players").LocalPlayer:Kick(m) end)
end
local function sleep(t)
    local ok = pcall(function() task.wait(t) end)
    if not ok then pcall(function() wait(t) end) end
end

local function httpGet(u)
    local ok, res = pcall(function() return game:HttpGet(u) end)
    if ok and type(res) == "string" and res ~= "" then return res end
    ok, res = pcall(function() return game:HttpGetAsync(u) end)
    if ok and type(res) == "string" and res ~= "" then return res end
    local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if req then
        ok, res = pcall(function() return req({ Url = u, Method = "GET" }) end)
        if ok and type(res) == "table" and type(res.Body) == "string" and res.Body ~= ""
            and (res.StatusCode == nil or res.StatusCode == 200) then
            return res.Body
        end
    end
    return nil
end

local function httpGetRetry(u, tries)
    for i = 1, tries do
        local r = httpGet(u)
        if r then return r end
        sleep(0.35)
    end
    return nil
end

local payload = httpGetRetry(payloadUrl, 3)
if not payload or payload == "" then fail("Luavify: Download failed.") return end
if payload:sub(1, 1) == "<" then fail("Luavify: Invalid response (HTML).") return end

local sid = ""
pcall(function() sid = game:GetService("HttpService"):GenerateGUID(false) end)
if sid == "" then sid = tostring(math.random(100000000, 999999999)) .. tostring(os.time()) end

pcall(function()
    local spawnFn = (task and task.spawn) or spawn
    spawnFn(function()
        pcall(function() httpGet(api .. "/log-execution?hash=" .. hash .. "&sid=" .. sid) end)
        while true do
            sleep(60)
            pcall(function() httpGet(api .. "/api/heartbeat?hash=" .. hash .. "&sid=" .. sid) end)
        end
    end)
end)

local compile = loadstring or load
if not compile then fail("Luavify: Your executor does not support loadstring.") return end
local fn, cerr = compile(payload)
if not fn then fail("Luavify: Compile error: " .. tostring(cerr)) return end
local okRun, rerr = pcall(fn)
if not okRun then warnMsg("Runtime error: " .. tostring(rerr)) end