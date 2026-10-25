local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local StarterGui  = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- 1) SPOOF GAMEPASS OWNERSHIP
-- Makes the client-side check return true so the game
-- treats you like you own the stamina gamepass
-- ============================================================
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() then
        if method == "UserOwnsGamePassAsync"
        or method == "PlayerOwnsAsset"
        or method == "UserOwnsAsset"
        or method == "PlayerOwnsAssetAsync"
        or method == "UserOwnsGamePass" then
            return true
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Spoof the subscription function too
task.spawn(function()
    local RS = game:GetService("ReplicatedStorage")
    local subFn = RS:FindFirstChild("GetSubscriptionStatus")
    if subFn then
        local mt2 = getrawmetatable(game)
        setreadonly(mt2, false)
        local old = mt2.__namecall
        mt2.__namecall = newcclosure(function(self, ...)
            if self == subFn and getnamecallmethod() == "InvokeServer" then
                return true
            end
            return old(self, ...)
        end)
        setreadonly(mt2, true)
    end
end)

-- Fake the gamepass UI in the Points GUI so it shows as owned
task.spawn(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not pg then return end
    local startGui = pg:FindFirstChild("Start")
    local pointsGui = startGui and startGui:FindFirstChild("Points")
    if pointsGui then
        local instantStamina = pointsGui:FindFirstChild("InstantStamina")
        if instantStamina and instantStamina:FindFirstChild("TextS") then
            instantStamina.TextS.Text = "Unlimited Stamina!"
        end
    end
end)

-- ============================================================
-- 2) INFINITE STAMINA (larps.lat method)
-- Hooks Sprint remote so the server never sees you sprinting,
-- which means stamina never drains
-- ============================================================
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        if getnamecallmethod() == "FireServer" and tostring(self) == "Sprint" then
            args[1] = "Ended"
            return oldNamecall(self, unpack(args))
        end
        return oldNamecall(self, ...)
    end)
end)

-- Bump walkspeed and manage the R / click resets
local function setSpeed(spd)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = spd end
end

setSpeed(22)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        setSpeed(16)
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        setSpeed(22)
    end
end)

-- Keep speed at 22 continuously
RunService.Heartbeat:Connect(function()
    setSpeed(22)
end)

-- Restore on character respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setSpeed(22)
end)

-- ============================================================
-- NOTIFICATION
-- ============================================================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Stamina Gamepass Spoofed + Infinite Stamina",
        Text = "Loaded",
        Duration = 3,
    })
end)