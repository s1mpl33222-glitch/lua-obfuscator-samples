pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    local ps = LP:FindFirstChild("PlayerScripts")
    local bs = ps and ps:FindFirstChild("CharacterAndBeamMove")
    if bs then bs.Disabled = true end
end)
pcall(function()
    local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    local bs = sps and sps:FindFirstChild("CharacterAndBeamMove")
    if bs then bs.Disabled = true end
end)
pcall(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GrabParts" then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("Beam") then
                    part.Enabled = false
                elseif part:IsA("BasePart") then
                    part.Transparency = 1
                    for _, s in pairs(part:GetChildren()) do
                        if s:IsA("Sound") then s.Volume = 0 end
                    end
                end
            end
        end
    end
end)
