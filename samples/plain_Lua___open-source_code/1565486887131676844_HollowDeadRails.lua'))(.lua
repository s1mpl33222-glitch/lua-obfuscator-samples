-- 安全載入 UI
local success, UIModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/ValueHat-Script/Valuehat-script/refs/heads/main/ValueHatGui4.lua"))()
end)

if not success or not UIModule then
    warn("[ValueHat] UI 載入失敗")
    return
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local keyEspEnabled = false
local noclipEnabled = false
local espObjects = {}
local noclipConnection = nil

-- ==================== Noclip 邏輯 ====================
local function setNoclip(enabled)
    if enabled then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- ==================== Key ESP 增強版邏輯 ====================
local function removeKeyESP()
    for _, item in pairs(espObjects) do
        if item and item.Parent then
            item:Destroy()
        end
    end
    espObjects = {}
end

local function applyESP(targetObj)
    if not targetObj or targetObj:FindFirstChild("KeyESP_Tag") then return end

    -- 找到要掛載 ESP 的 BasePart
    local adornPart = targetObj:IsA("BasePart") and targetObj or targetObj:FindFirstChildWhichIsA("BasePart", true)
    if not adornPart then return end

    -- 1. Highlight 高亮效果
    local highlight = Instance.new("Highlight")
    highlight.Name = "KeyESP_Tag"
    highlight.Adornee = targetObj
    highlight.FillColor = Color3.fromRGB(255, 215, 0) -- 金色
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = targetObj
    table.insert(espObjects, highlight)

    -- 2. BillboardGui 文字標籤
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KeyESP_Tag"
    billboard.Adornee = adornPart
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "[ KEY ]"
    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard

    billboard.Parent = targetObj
    table.insert(espObjects, billboard)
end

local function scanAndApplyESP()
    removeKeyESP()

    -- 優先找指定路徑
    local objectModels = Workspace:FindFirstChild("ObjectModels")
    if objectModels then
        for _, descendant in ipairs(objectModels:GetDescendants()) do
            if descendant.Name:lower():match("phantom_key") or descendant.Name:lower():match("key") then
                applyESP(descendant)
            end
        end
    else
        -- 備用方案：全圖搜尋
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant.Name == "phantom_key" then
                applyESP(descendant)
            end
        end
    end
end

local function startKeyESP()
    task.spawn(function()
        while keyEspEnabled do
            scanAndApplyESP()
            task.wait(1.5)
        end
        removeKeyESP()
    end)
end

-- ==================== UI 介面設定 ====================
local HubWindow = UIModule.CreateWindow("[Hollow] Dead Rails", "TikTok: ValueHat")

-- Key ESP 開關
HubWindow:CreateToggle("Key ESP", false, function(on)
    keyEspEnabled = on
    if on then
        print("[Key ESP] 已開啟")
        startKeyESP()
    else
        print("[Key ESP] 已關閉")
        removeKeyESP()
    end
end)

-- Noclip 開關
HubWindow:CreateToggle("Noclip", false, function(on)
    noclipEnabled = on
    setNoclip(on)
    if on then
        print("[Noclip] 已開啟")
    else
        print("[Noclip] 已關閉")
    end
end)

print("[ValueHat] Key ESP & Noclip script loaded successfully!")
