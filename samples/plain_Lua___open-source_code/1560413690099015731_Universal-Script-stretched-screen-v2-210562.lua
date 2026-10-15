-- =====================================================
--  Stretched Screen by 1AN - Rayfield
--  Created by ian Emmanuel (ydHldYudti)
-- =====================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Stretched Screen by 1AN",
    LoadingTitle = "Stretched Screen by 1AN",
    LoadingSubtitle = "by ydHldYudti",
})

local Tab = Window:CreateTab("🎮 Main", 4483362458)

Tab:CreateSection("Stretch Settings")

Tab:CreateToggle({
    Name = "Enable Stretched Screen",
    CurrentValue = true,
    Callback = function(Value)
        getgenv().StretchEnabled = Value
        if Value then ApplyStretch() else
            if getgenv().StretchConn then getgenv().StretchConn:Disconnect() end
        end
    end,
})

Tab:CreateSlider({
    Name = "Stretch Intensity",
    Range = {0.5, 1.2},
    Increment = 0.01,
    CurrentValue = 0.75,
    Callback = function(Value)
        getgenv().StretchIntensity = Value
        if getgenv().StretchEnabled then ApplyStretch() end
    end,
})

Tab:CreateSection("Performance Options")

Tab:CreateToggle({
    Name = "Disable Particles",
    Callback = function(Value)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = not Value
            end
        end
    end,
})

Tab:CreateToggle({
    Name = "Disable Shadows",
    Callback = function(Value)
        game:GetService("Lighting").GlobalShadows = not Value
    end,
})

Tab:CreateToggle({
    Name = "Low Texture Quality",
    Callback = function(Value)
        settings().Rendering.QualityLevel = Value and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    end,
})

-- REMOVE TEXTURES - SOLO PLASTIC (Sin cambiar color)
Tab:CreateToggle({
    Name = "Remove Textures (Plastic Only)",
    Callback = function(Value)
        pcall(function()
            -- Workspace
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                    obj.Transparency = Value and 1 or 0
                    obj.Visible = not Value
                elseif obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Part") then
                    if Value then
                        obj.Material = Enum.Material.Plastic
                    end
                end
            end

            -- Todos los Jugadores
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character then
                    for _, obj in pairs(plr.Character:GetDescendants()) do
                        if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                            obj.Transparency = Value and 1 or 0
                            obj.Visible = not Value
                        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
                            if Value then
                                obj.Material = Enum.Material.Plastic
                            end
                        end
                    end
                end
            end
        end)
    end,
})

-- Stretch Function
local stretchConnection = nil
function ApplyStretch()
    if stretchConnection then stretchConnection:Disconnect() end
    stretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().StretchEnabled and workspace.CurrentCamera then
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().StretchIntensity or 0.75, 0, 0, 0, 1)
        end
    end)
end

getgenv().StretchEnabled = true
getgenv().StretchIntensity = 0.75
ApplyStretch()

Rayfield:Notify({
    Title = "Stretched Screen by 1AN",
    Content = "Remove Textures updated (Plastic Only)",
    Duration = 6,
})

print("✅ Stretched Screen by 1AN Loaded")