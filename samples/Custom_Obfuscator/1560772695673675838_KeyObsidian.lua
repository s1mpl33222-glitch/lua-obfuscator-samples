local HttpService = cloneref(game:GetService("HttpService"))
local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiking123/Module/refs/heads/main/BlackhubGames"))()

if not isfolder("Blackhub") then
    makefolder("Blackhub")
end
if not isfolder("Blackhub/Key") then
    makefolder("Blackhub/Key")
end
if not isfile("Blackhub/Key/SavedKey.json") then
    writefile("Blackhub/Key/SavedKey.json", HttpService:JSONEncode({ Key = "" }))
end


local currentScriptId = getgenv().Games[game.PlaceId]
if currentScriptId then
    api.script_id = currentScriptId
end

local function Validate(key)
    return api.check_key(key)
end

local savedKey
local success, data = pcall(function()
    return HttpService:JSONDecode(readfile("Blackhub/Key/SavedKey.json"))
end)
if success and data and data.Key and data.Key ~= "" then
    savedKey = data.Key
    if Validate(savedKey).code == "KEY_VALID" then
        script_key = savedKey
        return api.load_script()
    end
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()


local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true 


local Window = Library:CreateWindow({
	Title = "Blackhub",
    Icon = 72943447238713,
	NotifySide = "Right",
	ShowCustomCursor = false,
})

local Tabs = {
	Main = Window:AddTab("Main"),
}

local Info = Tabs.Main:AddLeftGroupbox("Information")

Info:AddLabel("Key System:")
Info:AddLabel("You can choose any of the links below to get the key\nAlternatively, you can join my discord server to buy a permanent key \ndiscord.gg/blackhub", true)

Info:AddButton({
	Text = "Copy Discord Invite \ndiscord.gg/blackhub",
	Func = function()
        setclipboard("https://discord.gg/blackhub")
	end,
	DoubleClick = false,
	Tooltip = "Please join",
	Disabled = false,
	Visible = true,
	Risky = false,
})

Info:AddButton({
	Text = "Copy Key Link (Work Ink 30h)  \nRecommended",
	Func = function()
        setclipboard("https://ads.luarmor.net/get_key?for=Work_Ink-KdpjlrzBxVRU")
	end,
	DoubleClick = false,
	Tooltip = "Copy Key Link",
	Disabled = false,
	Visible = true,
	Risky = false,
})

Info:AddButton({
	Text = "Copy Key Link (Lootlabs 24h)  \nRecommended",
	Func = function()
        setclipboard("https://ads.luarmor.net/get_key?for=Blackhub-BXnxVNzSsIpq")
	end,
	DoubleClick = false,
	Tooltip = "Copy Key Link",
	Disabled = false,
	Visible = true,
	Risky = false,
})

Info:AddButton({
	Text = "Copy Key Link (Linkvertise 12h)",
	Func = function()
        setclipboard("https://ads.luarmor.net/get_key?for=Linkvertise_-vgxOIRsxKrjP")
	end,
	DoubleClick = false,
	Tooltip = "Copy Key Link",
	Disabled = false,
	Visible = true,
	Risky = false,
})

Info:AddDivider()

Info:AddButton({
	Text = "Buy a Permanent Key (Copy Link)",
	Func = function()
        setclipboard("https://blackhubnex.mysellauth.com/product/blackhub-key")
	end,
	DoubleClick = false,
	Tooltip = "Copy Perm Key Link",
	Disabled = false,
	Visible = true,
	Risky = false,
})

Info:AddInput("KeyInput", {
	Default = nil,
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Input your key",
	Tooltip = "Input your key here",
	Placeholder = "nil",

	Callback = function(UserKey)
        if UserKey == "" then
            Library:Notify("Invalid Input", 4)
            return
        end

        if Validate(UserKey).code == "KEY_VALID" then
            Library:Notify("Valid Key", 4)
            script_key = UserKey
            writefile("Blackhub/Key/SavedKey.json", HttpService:JSONEncode({ Key = UserKey }))
            Library:Unload()
            api.load_script()
        else
            Library:Notify("Invalid Key", 4)
        end
	end,
})
