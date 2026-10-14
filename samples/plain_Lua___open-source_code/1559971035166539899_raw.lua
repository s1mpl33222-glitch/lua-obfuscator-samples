local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local MIN_ACCOUNT_AGE = 10
local KICK_MESSAGE = "New Accounts Or Alt Accounts Are Prohibited To Prevent Bots. Please Use Your Main Account To Continue"
local GroupID = 67 
local GroupLink = "https://shorturl.asia/ekjifh"

-- 1. Anti-Bot / Account Age Check (10 Days Minimum)
if LocalPlayer.AccountAge < MIN_ACCOUNT_AGE then
    LocalPlayer:Kick(KICK_MESSAGE)
    return
end

-- 2. Group Membership Check
local isMember = false
pcall(function()
    isMember = LocalPlayer:IsInGroup(GroupID)
end)

-- If the player is already in the group, skip the locked UI
if isMember then
    -- Put your main script / feature initialization code here
    print("User authenticated successfully via group membership.")
    return
end

-- 3. UI Library Initialization (Only runs if user is NOT in the group)
local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    warn("Aurora: Failed to load UI library. Retrying...")
    task.wait(1)
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end

Fluent:Notify({
    Title = "Aurora Authentication",
    Content = "Oops looks like you're not in the group",
    Duration = 2
})

task.wait(1)

local Window = Fluent:CreateWindow({
    Title = "Aurora",
    SubTitle = "Premium Build",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Auth = Window:AddTab({ Title = "Authentication", Icon = "shield-check" }),
    Instructions = Window:AddTab({ Title = "Instructions", Icon = "info" })
}

Tabs.Auth:AddParagraph({
    Title = "Access Locked",
    Content = "This Scripthub requires you to join our group to access the rest of the script"
})

Tabs.Auth:AddButton({
    Title = "Copy Access Link",
    Description = "Copies the group URL to your clipboard",
    Callback = function()
        if setclipboard then
            setclipboard(GroupLink)
            Fluent:Notify({ Title = "Aurora", Content = "Access Link copied!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Aurora", Content = "Clipboard not supported", Duration = 2 })
        end
    end
})

-- Numbered Instructions
Tabs.Instructions:AddParagraph({
    Title = "1. Open Browser",
    Content = "Open your preferred web browser on your device"
})

Tabs.Instructions:AddParagraph({
    Title = "2. Paste Link",
    Content = "Paste the link you copied from the Authentication tab into the URL bar"
})

Tabs.Instructions:AddParagraph({
    Title = "3. Final Step",
    Content = "Join the group to verify membership and re-run the script"
})