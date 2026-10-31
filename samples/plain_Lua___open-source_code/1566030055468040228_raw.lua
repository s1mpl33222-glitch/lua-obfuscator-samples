-- KEROX OPTIMIZER | Mobile Anti-Lag UI
-- English UI • Draggable • Scale 50%-135% • Lock • Saved session settings
-- Intended for a Roblox Studio LocalScript in an experience you own/control.
-- Does not bypass game rules, unlock FPS, or guarantee stable 60 FPS.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Keep settings and original visual values across script re-runs in the same client session.
_G.KeroxOptimizerState = _G.KeroxOptimizerState or {
    scale = 1,
    locked = false,
    enabled = false,
    position = nil,
    original = nil
}
local state = _G.KeroxOptimizerState

local oldGui = playerGui:FindFirstChild("KeroxOptimizer")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KeroxOptimizer"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Main"
panel.Size = UDim2.fromOffset(310, 370)
panel.Position = state.position or UDim2.new(0.5, -155, 0.5, -185)
panel.BackgroundColor3 = Color3.fromRGB(12, 15, 27)
panel.BorderSizePixel = 0
panel.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Scale = math.clamp(tonumber(state.scale) or 1, 0.5, 1.35)
uiScale.Parent = panel

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 220, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.1
stroke.Parent = panel

local function label(name, text, pos, size, color, font, textSize)
    local obj = Instance.new("TextLabel")
    obj.Name = name
    obj.BackgroundTransparency = 1
    obj.Position = pos
    obj.Size = size
    obj.Text = text
    obj.TextColor3 = color or Color3.fromRGB(235, 245, 255)
    obj.Font = font or Enum.Font.Gotham
    obj.TextSize = textSize or 14
    obj.TextXAlignment = Enum.TextXAlignment.Left
    obj.Parent = panel
    return obj
end

local function button(name, text, pos, size)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(26, 34, 52)
    b.TextColor3 = Color3.fromRGB(240, 250, 255)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    b.Parent = panel
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = Color3.fromRGB(21, 28, 46)
header.BorderSizePixel = 0
header.Parent = panel
local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 14)
hc.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(15, 6)
title.Size = UDim2.new(1, -60, 0, 24)
title.Text = "KEROX OPTIMIZER"
title.TextColor3 = Color3.fromRGB(0, 225, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(16, 29)
subtitle.Size = UDim2.new(1, -60, 0, 16)
subtitle.Text = "MOBILE ANTI-LAG  •  SESSION SAVE"
subtitle.TextColor3 = Color3.fromRGB(158, 174, 198)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local close = button("Close", "×", UDim2.new(1, -42, 0, 10), UDim2.fromOffset(30, 30))
close.BackgroundColor3 = Color3.fromRGB(90, 35, 55)
close.TextSize = 20

label("OptimizationLabel", "VISUAL OPTIMIZATION", UDim2.fromOffset(16, 66), UDim2.fromOffset(240, 18),
    Color3.fromRGB(190, 205, 230), Enum.Font.GothamBold, 11)

local status = label("Status", "STATUS: OFF", UDim2.fromOffset(16, 87), UDim2.fromOffset(170, 22),
    Color3.fromRGB(255, 145, 160), Enum.Font.GothamBold, 13)

local toggle = button("ToggleOptimization", "ANTI-LAG: OFF", UDim2.fromOffset(16, 113), UDim2.fromOffset(278, 36))
toggle.BackgroundColor3 = Color3.fromRGB(52, 38, 62)

label("ScaleLabel", "UI SCALE", UDim2.fromOffset(16, 160), UDim2.fromOffset(120, 18),
    Color3.fromRGB(190, 205, 230), Enum.Font.GothamBold, 11)

local scaleValue = label("ScaleValue", "", UDim2.fromOffset(225, 160), UDim2.fromOffset(69, 18),
    Color3.fromRGB(0, 225, 255), Enum.Font.GothamBold, 12)
scaleValue.TextXAlignment = Enum.TextXAlignment.Right

local minus = button("ScaleDown", "−  SMALLER", UDim2.fromOffset(16, 182), UDim2.fromOffset(130, 32))
local plus = button("ScaleUp", "+  LARGER", UDim2.fromOffset(164, 182), UDim2.fromOffset(130, 32))

local lockButton = button("LockPosition", "", UDim2.fromOffset(16, 224), UDim2.fromOffset(278, 30))
lockButton.BackgroundColor3 = Color3.fromRGB(27, 53, 67)

label("AntiLagLabel", "ANTI-LAG MODULES", UDim2.fromOffset(16, 265), UDim2.fromOffset(220, 18),
    Color3.fromRGB(190, 205, 230), Enum.Font.GothamBold, 11)

local moduleInfo = label("ModuleInfo",
    "• Shadows & post effects\n• Particles, trails & beams\n• Fire, smoke & sparkles\n• Terrain decoration",
    UDim2.fromOffset(16, 286), UDim2.fromOffset(278, 60),
    Color3.fromRGB(155, 176, 205), Enum.Font.Gotham, 10)

label("Footer", "Enhanced visual cleanup • No FPS unlock", UDim2.fromOffset(16, 354),
    UDim2.fromOffset(278, 14), Color3.fromRGB(130, 149, 176), Enum.Font.Gotham, 9)

local function updateScale()
    uiScale.Scale = math.clamp(uiScale.Scale, 0.5, 1.35)
    state.scale = uiScale.Scale
    scaleValue.Text = tostring(math.floor(uiScale.Scale * 100 + 0.5)) .. "%"
end

local function updateLock()
    lockButton.Text = state.locked and "POSITION: LOCKED" or "POSITION: UNLOCKED"
    lockButton.BackgroundColor3 = state.locked and Color3.fromRGB(64, 65, 92) or Color3.fromRGB(27, 53, 67)
end

local dragging = false
local dragStart, startPosition
header.InputBegan:Connect(function(input)
    if state.locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                state.position = panel.Position
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging or state.locked then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

minus.Activated:Connect(function()
    uiScale.Scale = math.max(0.5, uiScale.Scale - 0.05)
    updateScale()
end)
plus.Activated:Connect(function()
    uiScale.Scale = math.min(1.35, uiScale.Scale + 0.05)
    updateScale()
end)

lockButton.Activated:Connect(function()
    state.locked = not state.locked
    updateLock()
end)

-- Capture original visual properties once so re-running the script won't overwrite
-- the real originals with already-optimized values.
if not state.original then
    local original = { properties = {} }
    original.properties[Lighting] = {
        GlobalShadows = Lighting.GlobalShadows
    }
    for _, item in ipairs(game:GetDescendants()) do
        if item:IsA("PostEffect") then
            original.properties[item] = { Enabled = item.Enabled }
        elseif item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam")
            or item:IsA("Fire") or item:IsA("Smoke") or item:IsA("Sparkles") then
            original.properties[item] = { Enabled = item.Enabled }
        elseif item:IsA("Terrain") then
            pcall(function()
                original.properties[item] = { Decoration = item.Decoration }
            end)
        elseif item:IsA("BasePart") then
            -- Save local visual properties that can be restored on OFF.
            original.properties[item] = {
                Material = item.Material,
                Reflectance = item.Reflectance
            }
        end
    end
    state.original = original
end

local function setOptimization(on)
    state.enabled = on
    local original = state.original
    if on then
        pcall(function() Lighting.GlobalShadows = false end)
        for _, item in ipairs(game:GetDescendants()) do
            if item:IsA("PostEffect") or item:IsA("ParticleEmitter") or item:IsA("Trail")
                or item:IsA("Beam") or item:IsA("Fire") or item:IsA("Smoke") or item:IsA("Sparkles") then
                pcall(function() item.Enabled = false end)
            elseif item:IsA("Terrain") then
                pcall(function() item.Decoration = false end)
            elseif item:IsA("BasePart") then
                -- Reduce expensive shiny materials without changing part geometry.
                pcall(function()
                    item.Reflectance = 0
                    if item.Material == Enum.Material.Neon or item.Material == Enum.Material.Glass
                        or item.Material == Enum.Material.ForceField then
                        item.Material = Enum.Material.SmoothPlastic
                    end
                end)
            end
        end
        status.Text = "STATUS: ON"
        status.TextColor3 = Color3.fromRGB(100, 255, 190)
        toggle.Text = "ANTI-LAG: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(20, 92, 74)
    else
        for item, props in pairs(original.properties) do
            if item and item.Parent then
                for property, value in pairs(props) do
                    pcall(function() item[property] = value end)
                end
            end
        end
        status.Text = "STATUS: OFF"
        status.TextColor3 = Color3.fromRGB(255, 145, 160)
        toggle.Text = "ANTI-LAG: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(52, 38, 62)
    end
end

toggle.Activated:Connect(function()
    setOptimization(not state.enabled)
end)

close.Activated:Connect(function()
    state.position = panel.Position
    state.scale = uiScale.Scale
    if state.enabled then setOptimization(false) end
    gui:Destroy()
end)

updateScale()
updateLock()
setOptimization(state.enabled == true)
