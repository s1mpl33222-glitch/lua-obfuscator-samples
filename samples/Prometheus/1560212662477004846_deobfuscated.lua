-- This file was generated at discord.gg/syncrypt

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local t1 = {}
local function v4(p1)
    if t1[p1] then
        return
    end

    if not p1:IsA("UIGradient") then
        return
    end

    local CenzShimmer = p1:GetAttribute("CenzShimmer")

    if not CenzShimmer then
        return
    end

    t1[p1] = true

    local v10 = p1:GetAttribute("CenzRotation") or 0

    if CenzShimmer == "stroke" then
        p1.Rotation = 0

        local tween = TweenService:Create(p1, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
			Rotation = 360
		})

        tween:Play()
        p1.Destroying:Connect(function()
            pcall(function()
                tween:Cancel()
            end)
            t1[p1] = nil
        end)

        return
    end

    if CenzShimmer == "bg" then
        local vector2, vector2_2

        if v10 == 90 or v10 == 270 then
            vector2 = Vector2.new(0, -0.5)
            vector2_2 = Vector2.new(0, 0.5)
        else
            vector2 = Vector2.new(-0.5, 0)
            vector2_2 = Vector2.new(0.5, 0)
        end

        p1.Offset = vector2

        local tween = TweenService:Create(p1, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
			Offset = vector2_2
		})

        tween:Play()
        p1.Destroying:Connect(function()
            pcall(function()
                tween:Cancel()
            end)
            t1[p1] = nil
        end)

        return
    end

    if CenzShimmer == "title" then
        p1.Offset = Vector2.new(0, 0.3)

        local tween = TweenService:Create(p1, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
			Offset = Vector2.new(0, -0.3)
		})

        tween:Play()
        p1.Destroying:Connect(function()
            pcall(function()
                tween:Cancel()
            end)
            t1[p1] = nil
        end)

        return
    end
end
local function v5(p2)
    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("UIGradient") then
            v4(descendant)
        end
    end
end
v5(Workspace)

local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer then
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

    if PlayerGui then
        v5(PlayerGui)
    end

    LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("UIGradient") then
            v4(descendant)
        end
    end)
end
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("UIGradient") then
        if descendant:GetAttribute("CenzShimmer") then
            v4(descendant)

            return
        end
        local connection
        connection = descendant:GetAttributeChangedSignal("CenzShimmer"):Connect(function()
            v4(descendant)

            if connection then
                connection:Disconnect()
            end
        end)
        task.delay(5, function()
            if connection then
                pcall(function()
                    connection:Disconnect()
                end)
            end
        end)
    end
end)
print("CENZ STUDIO DONATE ROBUX CLIENT ACTIVE")
