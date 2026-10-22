local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local chr = LP.Character or LP.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
LP.CharacterAdded:Connect(function(char)
    chr = char
    hum = chr:WaitForChild("Humanoid")
    hrp = chr:WaitForChild("HumanoidRootPart")
end)

local TweenService = game:GetService("TweenService")
local Time = workspace:WaitForChild("RoundTimerPart", 15):GetAttribute("Time")
local cointext
getgenv().auto = false
local map
local speed = 20
-- workspace.MilBase.CoinContainer:GetChildren()[2]

workspace.DescendantAdded:Connect(function(m)
    if m:IsA("Model") and m.Name == "CoinContainer" then
        map = m
    end
end)

local function GetMap()
    for _, coinmap in pairs(workspace:GetDescendants()) do
        if coinmap:IsA("Model") and coinmap.Name == "CoinContainer" then
            return coinmap
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if not map then
            map = GetMap()
        end
    end
end)
local tween = nil
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FunnyBefange/Library/refs/heads/main/library.lua", true))()

local Window = Library:CreateWindow("Murder Mystery 2")

Window:AddToggle({
text = "Auto Farm",
flag = "toggle",
callback = function(state)
getgenv().auto = state
if not state then
    local bv = hrp:FindFirstChild("FarmVelocity")
    local bg = hrp:FindFirstChild("FarmGyro")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if tween then
        tween:Cancel()
    end
    return
end
task.spawn(function()
local bv = hrp:FindFirstChild("FarmVelocity") or Instance.new("BodyVelocity")
bv.Name = "FarmVelocity"
bv.Velocity = Vector3.new(0, 0, 0)
bv.MaxForce = Vector3.new(0, math.huge, 0)
bv.Parent = hrp


while getgenv().auto do
    if not map then
        task.wait(1)
        continue
    end
    if LP:GetAttribute("Alive") == true and Time > 0 then
    for _, coin in pairs(map:GetChildren()) do
        if coin:IsA("Part") and coin.Name == "Coin_Server" and coin:FindFirstChild("TouchInterest") and coin:FindFirstChild("CoinVisual") then
            local rass = (hrp.Position - coin.Position).Magnitude
            if rass >= 50 and rass <= 75 then
            local distance = (hrp.Position - coin.Position).Magnitude / speed
            tween = TweenService:Create(hrp, TweenInfo.new(distance, Enum.EasingStyle.Linear), {CFrame = coin.CFrame} )
            tween:Play()
            tween.Completed:Wait()
            end
        end
        end
    end
task.wait()
end
end)
end
})

Window:AddSlider({
text = "Farm Speed",
min = 1,
max = 25,
dual = true,
type = "slider",
callback = function(SPEED)
speed = tonumber(SPEED)
end
})

Window:AddLabel({ text = "Made by Funny games" })
Library:Init()
