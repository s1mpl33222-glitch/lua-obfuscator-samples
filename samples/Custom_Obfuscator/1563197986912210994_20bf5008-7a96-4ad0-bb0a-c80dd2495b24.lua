local key = ...
if key == nil then key = script_key; script_key = nil end
local function denied()
    pcall(function() game:GetService("Players").LocalPlayer:Kick("KICKED") end)
    error("KICKED", 0)
end
if type(key) ~= "string" or #key ~= 68 or not string.match(key, "^PHI%-%x+$") or key ~= string.upper(key) then denied() end
local send = type(request) == "function" and request or type(http_request) == "function" and http_request or type(syn) == "table" and type(syn.request) == "function" and syn.request or type(http) == "table" and type(http.request) == "function" and http.request
if type(send) ~= "function" then denied() end
if type(loadstring) ~= "function" or type(task) ~= "table" or type(task.spawn) ~= "function" or type(task.wait) ~= "function" then denied() end
local hwidOk, hwid = pcall(function() return gethwid() end)
if not hwidOk or type(hwid) ~= "string" or #hwid < 8 or #hwid > 256 or string.find(hwid, "[^!-~]") then denied() end
local executor = "Unknown"
if type(identifyexecutor) == "function" then
    local identified, name = pcall(identifyexecutor)
    if identified and type(name) == "string" then executor = string.sub(name, 1, 80) end
end
local authorized, authorization = pcall(send, {
    Url = "https://phi-control.phi-console-1wrv.workers.dev/api/loader/authorize",
    Method = "POST", Timeout = 18,
    Headers = { ["Content-Type"] = "application/json" },
    Body = game:GetService("HttpService"):JSONEncode({scriptId = "20bf5008-7a96-4ad0-bb0a-c80dd2495b24", key = key, hwid = hwid})
})
local authStatus = authorized and type(authorization) == "table" and tonumber(authorization.StatusCode or authorization.Status)
if authStatus ~= 200 then
    if authStatus == 400 or authStatus == 401 or authStatus == 403 or authStatus == 409 then denied() end
    error("Connection unavailable; try again", 0)
end
local ticket = authorization.Body
authorization = nil
if type(ticket) ~= "string" or #ticket ~= 64 or not string.match(ticket, "^[0-9a-f]+$") then denied() end
local ok, response = pcall(send, {
    Url = "https://phi-control.phi-console-1wrv.workers.dev/api/loader",
    Method = "POST",
    Timeout = 18,
    Headers = { ["Content-Type"] = "application/json" },
    Body = game:GetService("HttpService"):JSONEncode({scriptId = "20bf5008-7a96-4ad0-bb0a-c80dd2495b24", key = key, hwid = hwid, executor = executor, ticket = ticket})
})
ticket = nil
if not ok or type(response) ~= "table" then denied() end
local status = tonumber(response.StatusCode or response.Status)
if status ~= 200 then denied() end
if type(response.Body) ~= "string" or #response.Body == 0 then error("Empty script response", 0) end
local headers = response.Headers or {}
local version
if type(headers) == "table" then
    for name, value in pairs(headers) do
        if type(name) == "string" and string.lower(name) == "x-phi-device-version" then
            local raw = type(value) == "string" and value or ""
            if string.match(raw, "^%d+$") then
                local parsed = tonumber(raw)
                if parsed and parsed >= 0 and parsed <= 2147483647 and parsed % 1 == 0 then version = parsed end
            end
        end
    end
end
if not version then response = nil; denied() end
local verified, confirmation = pcall(send, {
    Url = "https://phi-control.phi-console-1wrv.workers.dev/api/loader/check",
    Method = "POST", Timeout = 10,
    Headers = { ["Content-Type"] = "application/json" },
    Body = game:GetService("HttpService"):JSONEncode({scriptId = "20bf5008-7a96-4ad0-bb0a-c80dd2495b24", key = key, hwid = hwid, deviceVersion = version})
})
local confirmedStatus = verified and type(confirmation) == "table" and tonumber(confirmation.StatusCode or confirmation.Status)
if confirmedStatus ~= 204 then
    response = nil
    if confirmedStatus == 400 or confirmedStatus == 401 or confirmedStatus == 403 or confirmedStatus == 409 then denied() end
    error("Connection unavailable; try again", 0)
end
confirmation = nil
local compiled, execute = pcall(loadstring, response.Body)
response = nil
headers = nil
if not compiled or type(execute) ~= "function" then error("Script compilation failed", 0) end
task.spawn(function()
    local failures = 0
    while true do
        task.wait(15)
        local checked, reply = pcall(send, {
            Url = "https://phi-control.phi-console-1wrv.workers.dev/api/loader/check",
            Method = "POST", Timeout = 10,
            Headers = { ["Content-Type"] = "application/json" },
            Body = game:GetService("HttpService"):JSONEncode({scriptId = "20bf5008-7a96-4ad0-bb0a-c80dd2495b24", key = key, hwid = hwid, deviceVersion = version})
        })
        local code = checked and type(reply) == "table" and tonumber(reply.StatusCode or reply.Status)
        if code == 204 then failures = 0
        elseif code == 400 or code == 401 or code == 403 or code == 409 then denied()
        else failures = failures + 1; if failures >= 8 then denied() end end
    end
end)
return execute()
