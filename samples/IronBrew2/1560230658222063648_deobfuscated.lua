local s1 = "https://discord.com/invite/FvMePtyJrq"
local u2 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v3 = u2:CreateWindow({
    Name = "⚠ Script Outdated",
    LoadingTitle = "Update Required",
    LoadingSubtitle = "Please join Discord for latest version",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = true,
        Invite = "FvMePtyJrq",
        RememberJoins = false,
    },
    KeySystem = false,
}):CreateTab("Notice", 4483362458)
v3:CreateSection("This script is outdated!")
v3:CreateParagraph({
    Title = "Update Required",
    Content = "Please get the latest version from the Discord server.",
})
local function u4(p1)
    u2:Notify({
        Title = "Discord Invite",
        Content = p1,
        Duration = 3,
        Image = 4483362458,
    })
end
local function u5(p2)
    local u9 = false
    pcall(function()
        if setclipboard then
            setclipboard(p2)
            u9 = true
        elseif syn and syn.write_clipboard then
            syn.write_clipboard(p2)
            u9 = true
        elseif toclipboard then
            toclipboard(p2)
            u9 = true
        end
    end)
    return u9
end
v3:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        if u5(s1) then
            u4("Invite copied! Paste it in your browser to join.")
        else
            u4("Clipboard not supported. Copy manually: " .. s1)
            setclipboard(s1)
        end
    end,
})
v3:CreateButton({
    Name = "Close GUI",
    Callback = function()
        u2:Destroy()
    end,
})
