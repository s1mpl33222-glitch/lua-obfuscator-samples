-- Weekly Korblox Selector GUI (Mesh Asset Attachment)
-- Place this LocalScript under StarterGui or StarterPlayerScripts

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove an old copy of the GUI if the script was re-run
local oldGui = playerGui:FindFirstChild("PriderGui")
if oldGui then
    oldGui:Destroy()
end

-- Helper function to make any Frame/TextButton draggable
local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging = false
    local dragStart = nil
    local startPos = nil

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                guiObject.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
end

-- ─── ScreenGui ───
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PriderGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ─── Main Box Frame ───
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 170)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -85)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 16, 48)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 80, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- ─── Title Label ───
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 34)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(18, 10, 34)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Prider Korblox Selector"
titleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

makeDraggable(mainFrame, titleLabel)

-- ─── Close Button ───
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ─── Korblox Configuration Data Table ───
local KORBLOX_ASSETS = {
    ["Left Leg"] = { 
        id = "rbxassetid://139607673", 
        targetBodyPart = "LeftUpperLeg",
        partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        scale = Vector3.new(1.0, 1.0, 1.0), 
        audio = "rbxassetid://87998522263554",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
        icon = "🦵"
    },
    ["Right Leg"] = { 
        id = "rbxassetid://139607718", 
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1.0, 1.0, 1.0),
        audio = "rbxassetid://135315310485417",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
        icon = "🦵"
    }
}

-- ─── Helper function to weld mesh asset to body part ───
local function attachKorbloxMesh(itemName, config)
    local character = player.Character
    if not character then return false, "No character" end

    local targetPart = character:FindFirstChild(config.targetBodyPart)
    if not targetPart then return false, "Target part missing" end

    -- Remove pre-existing custom attachment if it exists
    local oldAsset = character:FindFirstChild("Korblox_" .. itemName:gsub("%s+", ""))
    if oldAsset then
        oldAsset:Destroy()
    end

    -- Hide character's native limbs so they don't overlap with the mesh
    for _, partName in ipairs(config.partsToHide) do
        local limb = character:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then
            limb.Transparency = 1
        end
    end

    -- Load asset container
    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)

    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Korblox_" .. itemName:gsub("%s+", "")

    -- Identify primary MeshPart or BasePart inside asset
    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    -- Apply scale, position relative to parent limb, and collision settings
    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    -- Weld the mesh directly to the limb joint
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = character

    -- Play optional audio cue
    if config.audio then
        local sound = Instance.new("Sound")
        sound.SoundId = config.audio
        sound.Volume = 0.5
        sound.Parent = mainMesh
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end

    return true
end

-- ─── Build Section Buttons ───
local startY = 42
local buttonHeight = 54
local gap = 8
local index = 0

for itemName, config in pairs(KORBLOX_ASSETS) do
    index = index + 1

    local btn = Instance.new("TextButton")
    btn.Name = itemName:gsub("%s+", "") .. "Btn"
    btn.Size = UDim2.new(1, -16, 0, buttonHeight)
    btn.Position = UDim2.new(0, 8, 0, startY + (index - 1) * (buttonHeight + gap))
    btn.BackgroundColor3 = Color3.fromRGB(48, 30, 80)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = true
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(125, 60, 220)
    btnStroke.Thickness = 1.5
    btnStroke.Parent = btn

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(1, 0, 0, 30)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = config.icon
    iconLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = btn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 14)
    statusLabel.Position = UDim2.new(0, 0, 1, -18)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Click for " .. itemName
    statusLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = btn

    local defaultText = "Click for " .. itemName

    btn.MouseButton1Click:Connect(function()
        statusLabel.Text = "Equipping..."
        statusLabel.TextColor3 = Color3.fromRGB(230, 200, 255)

        local ok, err = attachKorbloxMesh(itemName, config)

        if ok then
            statusLabel.Text = "✅ " .. itemName .. " On!"
            statusLabel.TextColor3 = Color3.fromRGB(220, 160, 255)

            btnStroke.Color = Color3.fromRGB(220, 160, 255)
            task.delay(2, function()
                btnStroke.Color = Color3.fromRGB(125, 60, 220)
                statusLabel.Text = defaultText
                statusLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
            end)
        else
            warn("Korblox equip failed (" .. itemName .. "): " .. tostring(err))
            statusLabel.Text = "❌ " .. tostring(err)
            statusLabel.TextColor3 = Color3.fromRGB(255, 90, 200)
            task.delay(3, function()
                statusLabel.Text = defaultText
                statusLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
            end)
        end
    end)
end

print("Prider Korblox Selector GUI loaded cleanly!")