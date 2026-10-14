-- ================================================
--         Custom Blox Spin Farm & Protection
-- ================================================

getgenv().script_mode = "FARM" -- الوضع الحالي (FARM أو PVP)

-- قائمة الأسماك التي تريد سكبها (عدم صيدها)
getgenv().IgnoredFish = {
    ["Mythic"] = true,    -- سكب سمك الميثك
    ["Exotic"] = true,    -- سكب الإكزوتيك
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Settings = {
    UndergroundDepth = -50, -- العمق تحت الأرض
    KickOnDamage = true    -- طرد تلقائي عند تلقي دمج
}

-- 1. نظام الطرد والتأمين عند التعرض لدمج
local function initAntiDamage()
    local function monitor(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then
            hum.HealthChanged:Connect(function(health)
                if Settings.KickOnDamage and health < hum.MaxHealth then
                    LocalPlayer:Kick("[Protection System] تم طردك تلقائياً للحفاظ على مواردك بسبب التعرض لدمج!")
                end
            end)
        end
    end
    if LocalPlayer.Character then monitor(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(monitor)
end

-- 2. تشغيل التثبيت تحت الأرض + الصيد داخل السيارة
if getgenv().script_mode == "FARM" then
    print("[Blox Spin] FARM Mode Activated.")
    initAntiDamage()

    -- المحافظة على موقع السيارة/اللاعب تحت الأرض وتمرير الاصطدام (Noclip)
    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local targetPart = char:FindFirstChild("HumanoidRootPart")

            -- التأكد مما إذا كان يركب سيارة وتثبيت السيارة بالكامل تحت الأرض
            if hum and hum.SeatPart then
                targetPart = hum.SeatPart.Parent:FindFirstChild("PrimaryPart") or hum.SeatPart
            end

            if targetPart and targetPart.Position.Y > Settings.UndergroundDepth then
                targetPart.CFrame = CFrame.new(targetPart.Position.X, Settings.UndergroundDepth, targetPart.Position.Z)
            end

            -- تفعيل Noclip للمركبة واللاعب
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)

    -- سكب الأسماك المحددة (Mythic وغيرها)
    workspace.ChildAdded:Connect(function(child)
        local fishName = child.Name
        local isMythic = child:FindFirstChild("Rarity") and child.Rarity.Value == "Mythic"
        
        if getgenv().IgnoredFish[fishName] or isMythic then
            print("[Fish Filter] Skipped: " .. fishName)
            child:Destroy()
        end
    end)

elseif getgenv().script_mode == "PVP" then
    print("[Blox Spin] PVP Mode Activated.")
end
