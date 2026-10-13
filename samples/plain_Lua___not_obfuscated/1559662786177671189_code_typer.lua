-- This file was protected using Luraph Obfuscator v15

local Skibidi = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/blookzz/skibidi/refs/heads/main/UILib.lua"
))()

local UI = Skibidi.CreatePanel({
    Title = "von redeemer",
    SubTitle = ".gg/vonhub",
    Width = 320,
    Height = 180,
    Search = false,
    Discord = true,
    ConfirmClose = false,
})

Skibidi.CreateParagraph(UI.Content, {
    Title = "free version discontinued!!!",
    Content = "free version has been discontinued cuz of luraph deobfuscators. pls join the discord server for more information and updates and free scripts.",
})

Skibidi.CreateButton(UI.Content, {
    Text = "copy discord",
    OnClick = function()
        if setclipboard then
            setclipboard("discord.gg/vonhub")
        end
    end,
})

Skibidi.CreateButton(UI.Content, {
    Text = "$2 purchase premium",
    OnClick = function()
        if setclipboard then
            setclipboard("discord.gg/vonhub")
        end
    end,
})
