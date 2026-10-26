-- Roblox Crosshair Script & Pink Damage Indicator (NX S)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui

-- 安全に PlayerGui を取得する（ロード時のクラッシュ防止）
pcall(function()
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
end)
if not PlayerGui then
    PlayerGui = CoreGui
end

-- 既存のクロスヘアGUIがあれば完全に削除
if PlayerGui:FindFirstChild("NX_CrosshairGui") then
    PlayerGui.NX_CrosshairGui:Destroy()
end

-- ScreenGuiの作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NX_CrosshairGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- 回転・アニメーション用の親フレーム（中央）
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 80, 0, 80)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- クロスヘア回転用フレーム
local crosshairFrame = Instance.new("Frame")
crosshairFrame.Name = "CrosshairFrame"
crosshairFrame.Size = UDim2.new(0, 80, 0, 80)
crosshairFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshairFrame.AnchorPoint = Vector2.new(0.5, 0.5)
crosshairFrame.BackgroundTransparency = 1
crosshairFrame.Parent = mainContainer

-- 設定値
local LINE_LENGTH = 12
local LINE_THICKNESS = 1.5
local BASE_OFFSET = 7
local PINK_DAMAGE_COLOR = Color3.fromRGB(255, 105, 180) -- しっかりとしたピンク色に変更

-- 4本の線を作成
local lines = {}
local strokes = {}
local angles = {0, 90, 180, 270}

for i, angle in ipairs(angles) do
    local line = Instance.new("Frame")
    line.Name = "Line_" .. i
    line.BorderSizePixel = 0
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    table.insert(lines, {instance = line, angle = angle})
    
    -- 縁（UIStroke）
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Parent = line
    table.insert(strokes, stroke)

    line.Parent = crosshairFrame
end

-- NX S テキストラベル
local textLabel = Instance.new("TextLabel")
textLabel.Name = "NXText"
textLabel.Text = "NX S"
pcall(function()
    textLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
if not textLabel.FontFace then
    textLabel.Font = Enum.Font.FredokaOne
end

textLabel.TextSize = 13
textLabel.TextStrokeTransparency = 0
textLabel.BackgroundTransparency = 1
textLabel.Size = UDim2.new(0, 80, 0, 16)
textLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
textLabel.AnchorPoint = Vector2.new(0.5, 0)
textLabel.Parent = mainContainer

-- 変数のローカルキャッシュ
local math_rad = math.rad
local math_sin = math.sin
local math_cos = math.cos
local math_pi = math.pi
local math_random = math.random
local tick = tick

local currentRotation = 0
local rotationDirection = 1
local rotSpeed = 80

local pulseInterval = 2.0
local reverseCheckInterval = 5.0
local lastPulseTime = tick()
local lastReverseCheck = tick()

-- 線の位置とパラメータ更新
local function updateCrosshair(offset)
    for i = 1, #lines do
        local item = lines[i]
        local rad = math_rad(item.angle)
        local posX = math_sin(rad) * (offset + LINE_LENGTH / 2)
        local posY = -math_cos(rad) * (offset + LINE_LENGTH / 2)
        
        local inst = item.instance
        inst.Position = UDim2.new(0.5, posX, 0.5, posY)
        inst.Size = UDim2.new(0, LINE_THICKNESS, 0, LINE_LENGTH)
        inst.Rotation = item.angle
    end
end

-- ダメージ表示を確実にピンク色に変更するフック
local function hookDamageIndicators()
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            for _, child in ipairs(descendant:GetDescendants()) do
                if child:IsA("TextLabel") then
                    if tonumber(child.Text) or string.find(child.Name:lower(), "damage") or string.find(child.Name:lower(), "hit") then
                        child.TextColor3 = PINK_DAMAGE_COLOR
                        child.TextStrokeColor3 = Color3.fromRGB(50, 0, 50)
                        child.TextStrokeTransparency = 0.2
                        pcall(function()
                            child.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                        end)
                    end
                end
            end
        end
    end)
end

task.spawn(hookDamageIndicators)

-- RenderSteppedによる超軽量アニメーションループ
local connection
connection = RunService.RenderStepped:Connect(function(deltaTime)
    if not screenGui.Parent then
        if connection then connection:Disconnect() end
        return
    end

    local currentTime = tick()

    -- 完全同色のレインボーカラー計算
    local currentHue = (currentTime * 0.4) % 1
    local synchronizedColor = Color3.fromHSV(currentHue, 1, 1)

    -- 全パーツに同じ色を同期
    for i = 1, #lines do
        lines[i].instance.BackgroundColor3 = synchronizedColor
        strokes[i].Color = synchronizedColor
    end

    textLabel.TextColor3 = synchronizedColor
    textLabel.TextStrokeColor3 = synchronizedColor

    -- 1. 回転処理
    currentRotation = currentRotation + (rotSpeed * rotationDirection * deltaTime)
    crosshairFrame.Rotation = currentRotation

    -- 2. 逆回り判定
    if currentTime - lastReverseCheck >= reverseCheckInterval then
        lastReverseCheck = currentTime
        if math_random() < 0.5 then
            rotationDirection = -rotationDirection
        end
    end

    -- 3. 2秒に1回のパルス処理
    local timeSincePulse = currentTime - lastPulseTime
    if timeSincePulse >= pulseInterval then
        lastPulseTime = currentTime
        timeSincePulse = 0
    end

    local currentOffset = BASE_OFFSET
    local pulseDuration = 0.25
    if timeSincePulse < pulseDuration then
        local progress = timeSincePulse / pulseDuration
        currentOffset = BASE_OFFSET + (math_sin(progress * math_pi) * 3)
    end

    updateCrosshair(currentOffset)
end)
