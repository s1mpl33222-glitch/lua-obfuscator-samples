local StarterGui = game:GetService("StarterGui")

local function notify(text)
    task.spawn(function()
        task.wait(0.5)

        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Wrong Game",
                Text = text,
                Duration = 5
            })
        end)
    end)
end

if game.PlaceId == 134208374070897 then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/Hanzo2TX/ScriptBloxScripts/refs/heads/main/Monochrome"
    ))()
else
    notify("Script not supported in this game.")
end
