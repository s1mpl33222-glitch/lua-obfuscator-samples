local Utils = {}

function Utils.GetPlayerCharacter()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        return char
    end
end

function Utils.GetCharacter()
    return game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
end

function Utils.PLCF()
    local c = Utils.GetCharacter()
    return c and c:FindFirstChild("HumanoidRootPart") and c.HumanoidRootPart.CFrame
end

function Utils.HRP(character)
    local char = character or game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

function Utils.getLocalHum()
    local char = game.Players.LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils.Charrrrrr()
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

function Utils.lookAt(origin, player)
    local forward = (player - origin).Unit
    local right = forward:Cross(Vector3.new(0, 1, 0)).Unit
    local up = right:Cross(forward)
    return CFrame.fromMatrix(origin, right, up)
end

function Utils.CNWOSHIPOPl(pler)
    if typeof(pler) == "Instance" and pler:IsA("Player") and pler.Character then
        local head = pler.Character:FindFirstChild("Head")
        local ownerValue = head and head:FindFirstChild("PartOwner")
        if ownerValue and ownerValue.Value == game.Players.LocalPlayer.Name then
            return ownerValue
        end
    end
    return false
end

function Utils.GetLocalCharAndHum()
    local c = game.Players.LocalPlayer.Character
    if not c then return nil, nil end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return nil, nil end -- Fixed = to <=
    return c, h
end

function Utils.ROS(part, ignoreDistance)
    if not part or not part:IsA("BasePart") then return end

    local character = Utils.GetCharacter()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local root = character.HumanoidRootPart
    local distance = (root.Position - part.Position).Magnitude

    if ignoreDistance or distance <= 30 then -- Fixed = to <=
        pcall(function()
            game.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(
                part,
                Utils.lookAt(root.Position, part.Position)
            )
        end)
    end
end

return Utils