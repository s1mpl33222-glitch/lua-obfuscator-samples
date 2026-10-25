local reason = [=[Invalid loader execution environment. Only Roblox executors are permitted.]=]
while task.wait() do
    pcall(function()
        game:GetService("Players").LocalPlayer:Kick("ThZ Shield: "..reason)
        local CoreGui = (cloneref or (function(a)return a end))(game:GetService("CoreGui"))
        CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = "ThZ Shield"
        CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = reason
    end)
end
