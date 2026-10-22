--[[
 ███╗   ██╗███████╗ ██████╗     ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗
 ████╗  ██║██╔════╝██╔═══██╗    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗
 ██╔██╗ ██║█████╗  ██║   ██║    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝
 ██║╚██╗██║██╔══╝  ██║   ██║    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗
 ██║ ╚████║███████╗╚██████╔╝    ██║  ██║   ██║   ██║     ███████╗██║  ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝
                N E O   •   H Y P E R   •   E V A D E
                       Developed by M4X
]]

local StarterGui = game:GetService("StarterGui")
local DiscordLink = "https://discord.gg/YbDMqpAr3a"

-- 1. First Notification: Loading Script
StarterGui:SetCore("SendNotification", {
    Title = "NEO HYPER EVADE",
    Text = "Script is loading, please wait 30 seconds...",
    Icon = "rbxassetid://6023426926",
    Duration = 5
})

-- Bindable function to handle Discord button click
local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function(buttonText)
    if buttonText == "Copy Discord" then
        if setclipboard then
            setclipboard(DiscordLink)
            
            -- Confirmation Notification
            StarterGui:SetCore("SendNotification", {
                Title = "NEO HYPER",
                Text = "Discord invite link copied to clipboard! 🚀",
                Duration = 3
            })
        end
    end
end

-- 2. Second Notification: Join Discord (shows shortly after)
task.delay(2, function()
    StarterGui:SetCore("SendNotification", {
        Title = "Join Our Community!",
        Text = "Join our Discord server for updates and support.",
        Icon = "rbxassetid://6023426926",
        Duration = 10,
        Button1 = "Copy Discord",
        Button2 = "Dismiss",
        Callback = Bindable
    })
end)

-- Main Script Execution
loadstring(game:HttpGet("https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/refs/heads/main/EVADE/NEO_EVADE.lua"))()
