
local reason = [=[Invalid key.]=]
while task.wait() do
    pcall(function()
        game:GetService("Players").LocalPlayer:Kick("LuaProt: "..reason)
        local CoreGui = (cloneref or (function(a)return a end))(game:GetService("CoreGui"))
        CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = "LuaProt"
        CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = reason
    end)
end
