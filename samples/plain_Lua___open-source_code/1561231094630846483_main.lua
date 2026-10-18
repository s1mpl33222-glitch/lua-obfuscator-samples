print("@l.u.a.u on discord.")

if game.PlaceId == 335132309 or game.PlaceId == 335132309 or game.PlaceId == 142823291 then
    print("Loading: Murder Mystery 2.")
    loadstring(game:HttpGet("https://luware.filho.wtf/games/mm2.lua"))()
else
    local r = "Unsupported Game."

    task.spawn(function()
        while task.wait() do
            pcall(function()
                local g = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt
                g.TitleFrame.ErrorTitle.Text = "LuWare"
                g.MessageArea.ErrorFrame.ErrorMessage.Text = r
            end)
        end
    end)

    game:GetService("Players").LocalPlayer:Kick("Xynnn said:\n" .. r)
end
