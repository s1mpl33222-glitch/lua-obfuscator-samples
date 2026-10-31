--[[
    Menú pequeño arrastrable - Android / iOS
    Solo diseño + gate de comunidad
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============== CONFIG ==============
local COMMUNITY_LINK = "https://roblox.mq/communities/2469556759/"
local VALID_KEYS = { "XERO-2026", "COMUNIDAD" }
-- ====================================

local old = playerGui:FindFirstChild("XeroMiniMenu")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "XeroMiniMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MiniMenu"
frame.Size = UDim2.fromOffset(210, 148)
frame.Position = UDim2.new(0.5, -105, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 70)
stroke.Thickness = 1
stroke.Transparency = 0.3
stroke.Parent = frame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
header.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "XERO"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local line = Instance.new("Frame")
line.Size = UDim2.new(1, -24, 0, 1)
line.Position = UDim2.fromOffset(12, 36)
line.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
line.BackgroundTransparency = 0.45
line.BorderSizePixel = 0
line.Parent = frame

local btnCommunity = Instance.new("TextButton")
btnCommunity.Size = UDim2.new(1, -24, 0, 38)
btnCommunity.Position = UDim2.fromOffset(12, 48)
btnCommunity.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
btnCommunity.Text = "Únete a la comunidad"
btnCommunity.TextColor3 = Color3.new(1, 1, 1)
btnCommunity.Font = Enum.Font.GothamMedium
btnCommunity.TextSize = 13
btnCommunity.AutoButtonColor = false
btnCommunity.Parent = frame

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 10)
c1.Parent = btnCommunity

local btnUnlock = Instance.new("TextButton")
btnUnlock.Size = UDim2.new(1, -24, 0, 38)
btnUnlock.Position = UDim2.fromOffset(12, 94)
btnUnlock.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
btnUnlock.Text = "Desbloquear script"
btnUnlock.TextColor3 = Color3.fromRGB(20, 20, 20)
btnUnlock.Font = Enum.Font.GothamMedium
btnUnlock.TextSize = 13
btnUnlock.AutoButtonColor = false
btnUnlock.Parent = frame

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 10)
c2.Parent = btnUnlock

-- ========== ARRASTRAR ==========
local dragging = false
local dragStart, startPos

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = frame.Position

    local conn
    conn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
            if conn then conn:Disconnect() end
        end
    end)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        local relativeY = input.Position.Y - frame.AbsolutePosition.Y
        if relativeY <= 40 then
            startDrag(input)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ========== ACCIONES ==========
btnCommunity.MouseButton1Click:Connect(function()
    -- Intenta abrir el navegador
    local opened = pcall(function()
        GuiService:OpenBrowserWindow(COMMUNITY_LINK)
    end)

    -- Siempre copia el link por si el navegador no se abre
    if setclipboard then
        setclipboard(COMMUNITY_LINK)
    end

    if opened then
        btnCommunity.Text = "Abriendo navegador..."
    else
        btnCommunity.Text = "¡Link copiado!"
    end

    task.delay(1.8, function()
        if btnCommunity and btnCommunity.Parent then
            btnCommunity.Text = "Únete a la comunidad"
        end
    end)
end)

btnUnlock.MouseButton1Click:Connect(function()
    local keyGui = Instance.new("Frame")
    keyGui.Size = UDim2.fromOffset(210, 110)
    keyGui.Position = UDim2.new(0.5, -105, 0.5, -55)
    keyGui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    keyGui.BorderSizePixel = 0
    keyGui.Parent = gui

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(0, 14)
    kc.Parent = keyGui

    local ks = Instance.new("UIStroke")
    ks.Color = Color3.fromRGB(70, 70, 70)
    ks.Thickness = 1
    ks.Transparency = 0.3
    ks.Parent = keyGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 24)
    label.Position = UDim2.fromOffset(10, 10)
    label.BackgroundTransparency = 1
    label.Text = "Pega tu key"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = keyGui

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 32)
    box.Position = UDim2.fromOffset(10, 36)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = ""
    box.PlaceholderText = "Key..."
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.TextColor3 = Color3.fromRGB(230, 230, 230)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = keyGui

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = box

    local confirm = Instance.new("TextButton")
    confirm.Size = UDim2.new(1, -20, 0, 28)
    confirm.Position = UDim2.fromOffset(10, 74)
    confirm.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    confirm.Text = "Confirmar"
    confirm.TextColor3 = Color3.fromRGB(20, 20, 20)
    confirm.Font = Enum.Font.GothamMedium
    confirm.TextSize = 13
    confirm.Parent = keyGui

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = confirm

    confirm.MouseButton1Click:Connect(function()
        local key = string.upper((box.Text or ""):gsub("%s+", ""))
        local ok = false
        for _, k in ipairs(VALID_KEYS) do
            if key == string.upper(k) then
                ok = true
                break
            end
        end

        if ok then
            keyGui:Destroy()
            frame:Destroy()
            print("[Xero] Script desbloqueado correctamente")
            -- Aquí pones tu script real
        else
            confirm.Text = "Key incorrecta"
            confirm.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
            confirm.TextColor3 = Color3.new(1, 1, 1)
            task.delay(1.3, function()
                if confirm and confirm.Parent then
                    confirm.Text = "Confirmar"
                    confirm.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    confirm.TextColor3 = Color3.fromRGB(20, 20, 20)
                end
            end)
        end
    end)
end)

print("[XeroMini] Menú listo.")
