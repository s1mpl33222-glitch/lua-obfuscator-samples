local StarterGui = game:GetService("StarterGui")

local MY_DISCORD = "https://discord.gg/8YwhJDDAqD"


local function tryCopyDiscord()
    if typeof(setclipboard) == "function" then
        setclipboard(MY_DISCORD)
        return true
    elseif typeof(toclipboard) == "function" then
        toclipboard(MY_DISCORD)
        return true
    end
    return false
end

local bind = Instance.new("BindableFunction")
bind.OnInvoke = function(choice)
    if choice == "Copy" then
        local copied = tryCopyDiscord()
        StarterGui:SetCore("SendNotification", {
            Title = copied and "Copied!" or "Can't Copy",
            Text = copied and ("Done: " .. MY_DISCORD) or "Executor doesn't support clipboard",
            Icon = "rbxassetid://7733674079",
            Duration = 5
        })
    end
end