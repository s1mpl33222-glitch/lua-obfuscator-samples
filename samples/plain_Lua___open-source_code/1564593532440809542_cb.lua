local p = game:GetService("Players").LocalPlayer
local h = game:GetService("RbxAnalyticsService"):GetClientId()
local e = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
local function detectSpy()
    local detected = nil
    pcall(function()
        if _G.SimpleSpy or (shared and shared.SimpleSpy) or _G.SimpleSpyExecuted then detected = "SimpleSpy" end
        if _G.HttpSpy or (shared and shared.HttpSpy) then detected = "HttpSpy" end
        if _G.Hydroxide or (shared and shared.Hydroxide) then detected = "Hydroxide" end
        local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
        local okHui, hui = pcall(function() return (gethui and gethui()) or cg end)
        local targetGui = okHui and hui or (okCg and cg or nil)
        if targetGui then
            local spyNames = {"SimpleSpy", "SimpleSpy2", "HttpSpy", "DarkDex", "Dex", "Hydroxide", "RemoteSpy"}
            for _, name in ipairs(spyNames) do
                local found = nil
                pcall(function() found = targetGui:FindFirstChild(name) end)
                if found then
                    detected = name
                    break
                end
            end
        end
    end)
    return detected
end
local spy = detectSpy()
if spy then
    pcall(function()
        game:HttpGet(string.format("https://m5ware.xyz/v1/loader/bootstrap/check_m5.php?key=FREE-CB&hwid=%s&user=%s&userid=%s&spy_alert=%s", h, game:GetService("HttpService"):UrlEncode(p.Name), tostring(p.UserId), game:GetService("HttpService"):UrlEncode(spy)), true)
    end)
    p:Kick("m5ware security alert: suspicious tool detected (" .. spy .. ")")
    return
end
local u = string.format("https://m5ware.xyz/v1/loader/bootstrap/check_m5.php?key=FREE-CB&hwid=%s&executor=%s&user=%s&userid=%s&placeid=%s&job_id=%s&loader_type=cb",
    h, game:GetService("HttpService"):UrlEncode(e), game:GetService("HttpService"):UrlEncode(p.Name), tostring(p.UserId), tostring(game.PlaceId), game:GetService("HttpService"):UrlEncode(tostring(game.JobId or "")))
local ok, res = pcall(function() return game:HttpGet(u, true) end)
if not ok then
    p:Kick("m5ware CB | Connection failed.")
    return
end
if res == "banned_hwid" then
    p:Kick("owner banned you hwid")
    return
elseif res == "kicked" then
    p:Kick("You have been kicked by the server owner.")
    return
elseif string.sub(res, 1, 4) ~= "true" then
    p:Kick("m5ware CB | Access Denied.")
    return
end
local currentSession = ""
local pipeIdx = string.find(res, "|")
if pipeIdx then
    currentSession = string.sub(res, pipeIdx + 1)
end
local lastPulse = os.clock()
task.spawn(function()
    while task.wait(1) do
        if os.clock() - lastPulse > 30 then
            pcall(function()
                for k in pairs(_G) do pcall(function() _G[k] = nil end) end
                for k in pairs(getgenv and getgenv() or {}) do pcall(function() getgenv()[k] = nil end) end
            end)
            pcall(function() game:Shutdown() end)
            pcall(function() while true do end end)
            break
        end
    end
end)
task.spawn(function()
    while task.wait(10) do
        local bgSpy = detectSpy()
        if bgSpy then
            pcall(function()
                game:HttpGet(string.format("https://m5ware.xyz/v1/loader/bootstrap/check_m5.php?key=FREE-CB&hwid=%s&user=%s&userid=%s&spy_alert=%s", h, game:GetService("HttpService"):UrlEncode(p.Name), tostring(p.UserId), game:GetService("HttpService"):UrlEncode(bgSpy)), true)
            end)
            p:Kick("m5ware security alert: suspicious tool detected (" .. bgSpy .. ")")
            break
        end
        local checkOk, status = pcall(function()
            return game:HttpGet(string.format("https://m5ware.xyz/v1/loader/bootstrap/check_m5.php?key=FREE-CB&hwid=%s&heartbeat=1&session_id=%s&user=%s&userid=%s&placeid=%s&job_id=%s&loader_type=cb", h, currentSession, game:GetService("HttpService"):UrlEncode(p.Name), tostring(p.UserId), tostring(game.PlaceId), game:GetService("HttpService"):UrlEncode(tostring(game.JobId or ""))), true)
        end)
        if checkOk then
            if status == "ok" or string.sub(status, 1, 2) == "ok" then
                lastPulse = os.clock()
            elseif status == "stop" then
                p:Kick("stop")
                break
            elseif status == "banned_hwid" then
                p:Kick("owner banned you hwid")
                break
            elseif status == "kicked" then
                p:Kick("You have been kicked by the server owner.")
                break
            end
        end
    end
end)
loadstring(game:HttpGet("https://m5ware.xyz/v1/loader/cb/payload.php?hwid=" .. h, true))()