-- Hokalaza 4.2 Toggle Wrapper ( vibe code ^^ )
local CoreGuiSvc = game:GetService("CoreGui")
local StarterGuiSvc = game:GetService("StarterGui")
local drRayGui = CoreGuiSvc:FindFirstChild("DrRay")

if drRayGui then
    if _G.IfUiIsHidden == true then
        -- UI was hidden → show it
        drRayGui.Enabled = true
        _G.IfUiIsHidden = false
        StarterGuiSvc:SetCore("SendNotification", {
            Title = "Hokalaza 4.2",
            Text = "UI Shown (or press RightControl)",
            Duration = 3
        })
    else
        -- UI is visible → hide it
        drRayGui.Enabled = false
        _G.IfUiIsHidden = true
        StarterGuiSvc:SetCore("SendNotification", {
            Title = "Hokalaza 4.2",
            Text = "UI Hidden — execute again or press RightControl to show",
            Duration = 3
        })
    end
else
    -- UI doesn't exist yet → first run, load it
    _G.IfUiIsHidden = false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hokalaza/4.2/refs/heads/main/english"))()
end