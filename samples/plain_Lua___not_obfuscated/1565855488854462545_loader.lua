repeat
    task.wait()
until game:IsLoaded()

if getgenv().omgthisshitisloadedlmao then return warn("skidware already loaded") end
getgenv().omgthisshitisloadedlmao = true

local bindable = Instance.new("BindableFunction")
function bindable.OnInvoke(choice)
    if choice == "Yes" then
        (setclipboard or toclipboard)("https://discord.gg/rZjm4267nJ")
    end
end
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "skidware.lua",
    Text = "wanna join our discord ? click yes to copy discord url",
    Duration = 8,
    Button1 = "Yes",
    Button2 = "No Thanks",
    Callback = bindable
})
local exec = identifyexecutor or getexecutorname
local name = exec and string.lower(exec()) or "unknown"
for _, bad in ipairs({"solara", "xeno"}) do
    if string.find(name, bad, 1, true) then
        game:GetService("Players").LocalPlayer:Kick("Executor not supported")
        return
    end
end
local baseurl = "https://doitenroi.win/skidware/games/"
local gamesp = {["6765805766"] = "blockspin.lua", ["universal"] = "universal.lua", ["73885730"] = "prisonlife.lua", ["4914269443"] = "unamedshooter.lua"}
local ahsdkabhdkjbhaw = gamesp[tostring(game.GameId)] or gamesp["universal"]
loadstring(game:HttpGet(baseurl .. ahsdkabhdkjbhaw))()