-- LWZ HUB
-- ANTI DROP VOID
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
-- // WHITE THEME (أبيض ناصع + رمادي أنيق)
local C_BORDER = Color3.fromRGB(200, 200, 200)
local C_PANEL = Color3.fromRGB(245, 245, 245)
local C_TEXT_TITLE = Color3.fromRGB(20, 20, 20)
local C_TEXT_SUB = Color3.fromRGB(100, 100, 100)
local C_INACTIVE = Color3.fromRGB(160, 160, 160)
local C_ACTIVE = Color3.fromRGB(0, 0, 0)
local C_TOGGLE_ON = Color3.fromRGB(0, 0, 0)
local C_TOGGLE_OFF = Color3.fromRGB(220, 220, 220)
local GUI_WIDTH = 220
local GUI_EXPANDED_HEIGHT = 300
local GUI_SCALE = 1
local GUI_COLLAPSED_HEIGHT = 35
-- // CONFIGURACIÓN
local ConfigFile = "LWZHub_Config.json"
local Config = {
Position = { X_Scale = 0.5, X_Offset = -100, Y_Scale = 0.5, Y_Offset = -100 },
AntiDrop = false,
AntiDie = false,
AntiBat = false,
HoldJump = false,
IsCollapsed = false,
GuiVisible = true,
GuiScale = 1
}
local function SaveConfig()
if writefile then
pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end)
end
end
local function LoadConfig()
if isfile and isfile(ConfigFile) then
local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
if success and data then
for k, v in pairs(data) do Config[k] = v end
end
end
end
LoadConfig()
Config.IsCollapsed = false
Config.GuiVisible = true
GUI_SCALE = math.clamp(tonumber(Config.GuiScale) or 1, 0.70, 1.50)
-- // KEYBINDS
local Keys = {
antiDie = Enum.KeyCode.X,
guiHide = Enum.KeyCode.RightControl
}
-- =====================================================
--  CARTEL FLOTANTE (LWZ HUB)
-- =====================================================
local billboardGui = nil
local billboardFrame = nil
local billboardUpdater = nil
local billboardCharAddedConn = nil
local function createBillboard(char)
if not char then return end
local head = char:FindFirstChild("Head")
if not head then return end
if billboardGui then billboardGui:Destroy() end
if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end
billboardGui = Instance.new("ScreenGui")
billboardGui.Name = "LWZ_Hub_Billboard"
billboardGui.ResetOnSpawn = false
billboardGui.IgnoreGuiInset = true
billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
billboardGui.Parent = game:GetService("CoreGui")
billboardFrame = Instance.new("Frame", billboardGui)
billboardFrame.Size = UDim2.new(0, 180, 0, 50)
billboardFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
billboardFrame.BackgroundTransparency = 0.1
billboardFrame.BorderSizePixel = 0
Instance.new("UICorner", billboardFrame).CornerRadius = UDim.new(0, 8)
billboardFrame.Position = UDim2.new(0.5, -90, 0.5, -25)
local stroke = Instance.new("UIStroke", billboardFrame)
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.Thickness = 1
local txt1 = Instance.new("TextLabel", billboardFrame)
txt1.Size = UDim2.new(1, 0, 0.5, 0)
txt1.Position = UDim2.new(0, 0, 0, 0)
txt1.BackgroundTransparency = 1
txt1.Text = "LWZ HUB"
txt1.TextColor3 = Color3.fromRGB(0, 0, 0)
txt1.Font = Enum.Font.GothamBlack
txt1.TextSize = 18
txt1.TextXAlignment = Enum.TextXAlignment.Center
txt1.TextYAlignment = Enum.TextYAlignment.Bottom
local txt2 = Instance.new("TextLabel", billboardFrame)
txt2.Size = UDim2.new(1, 0, 0.5, 0)
txt2.Position = UDim2.new(0, 0, 0.5, 0)
txt2.BackgroundTransparency = 1
txt2.Text = "ANTI DROP"
txt2.TextColor3 = Color3.fromRGB(100, 100, 100)
txt2.Font = Enum.Font.GothamBold
txt2.TextSize = 12
txt2.TextXAlignment = Enum.TextXAlignment.Center
txt2.TextYAlignment = Enum.TextYAlignment.Top
local camera = Workspace.CurrentCamera
billboardUpdater = RunService.Heartbeat:Connect(function()
if not billboardGui or not billboardGui.Parent then
if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end
return
end
if not head or not head.Parent then
billboardFrame.Visible = false
return
end
local pos, onScreen = camera:WorldToScreenPoint(head.Position)
if onScreen then
billboardFrame.Position = UDim2.new(0, pos.X - 90, 0, pos.Y - 30)
billboardFrame.Visible = true
else
billboardFrame.Visible = false
end
end)
end
local function destroyBillboard()
if billboardUpdater then
billboardUpdater:Disconnect()
billboardUpdater = nil
end
if billboardGui then
billboardGui:Destroy()
billboardGui = nil
end
billboardFrame = nil
if billboardCharAddedConn then
billboardCharAddedConn:Disconnect()
billboardCharAddedConn = nil
end
end
-- // Eliminar GUI antigua
for _, name in pairs({"LWZHubUI", "404UI", "AntiDieUI", "VioletteTPBat"}) do
local old = game:GetService("CoreGui"):FindFirstChild(name)
if old then old:Destroy() end
end
local gui = Instance.new("ScreenGui")
gui.Name = "LWZHubUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
gui.Parent = LP:WaitForChild("PlayerGui")
end
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_EXPANDED_HEIGHT)
main.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset,
Config.Position.Y_Scale, Config.Position.Y_Offset)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)
local bgOverlay = Instance.new("Frame", main)
bgOverlay.Size = UDim2.new(1,0,1,0)
bgOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bgOverlay.BackgroundTransparency = 0
bgOverlay.BorderSizePixel = 0
bgOverlay.ZIndex = 1
Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C_BORDER
mainStroke.Thickness = 1.6
mainStroke.Transparency = 0
local mainScale = Instance.new("UIScale", main)
mainScale.Scale = GUI_SCALE
-- Arrastre
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
dragging = true; dragStart = inp.Position; mainStart = main.Position
inp.Changed:Connect(function()
if inp.UserInputState == Enum.UserInputState.End then
dragging = false
Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset, Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
SaveConfig()
end
end)
end
end)
main.InputChanged:Connect(function(inp)
if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
if inp == dragInput and dragging then
local dx = inp.Position.X - dragStart.X
local dy = inp.Position.Y - dragStart.Y
main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
end
end)
-- CABECERA
local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 8, 0, 8)
titleDot.Position = UDim2.new(0, 12, 0, 10)
titleDot.BackgroundColor3 = C_ACTIVE
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 6
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)
local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 140, 0, 16)
titleLbl.Position = UDim2.new(0, 26, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "LWZ HUB"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 6
local subLbl = Instance.new("TextLabel", main)
subLbl.Size = UDim2.new(0, 140, 0, 12)
subLbl.Position = UDim2.new(0, 26, 0, 22)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Anti Drop System"
subLbl.TextColor3 = C_TEXT_SUB
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 9
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 6
-- Botón minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -28, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
minBtn.BackgroundTransparency = 0
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 14
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = C_BORDER
minStroke.Thickness = 1
minBtn.MouseButton1Click:Connect(function()
Config.IsCollapsed = not Config.IsCollapsed
local targetHeight = Config.IsCollapsed and GUI_COLLAPSED_HEIGHT or GUI_EXPANDED_HEIGHT
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
}):Play()
SaveConfig()
end)
-- =====================================================
--  FUNCIÓN PARA CREAR PANELES
-- =====================================================
local function CreatePanel(yPos, height)
local p = Instance.new("Frame", main)
p.Size = UDim2.new(1, -16, 0, height)
p.Position = UDim2.new(0, 8, 0, yPos)
p.BackgroundColor3 = C_PANEL
p.BackgroundTransparency = 0
p.ZIndex = 4
local ps = Instance.new("UIStroke", p)
ps.Color = C_BORDER
ps.Transparency = 0
ps.Thickness = 1
Instance.new("UICorner", p).CornerRadius = UDim.new(0, 10)
return p
end
-- =====================================================
--  PANEL DE ESTADO
-- =====================================================
local statusPanel = CreatePanel(36, 22)
local statusDot = Instance.new("Frame", statusPanel)
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 10, 0.5, -3)
statusDot.BackgroundColor3 = C_INACTIVE
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
local statusTxt = Instance.new("TextLabel", statusPanel)
statusTxt.Size = UDim2.new(0, 50, 1, 0)
statusTxt.Position = UDim2.new(0, 22, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = "Status"
statusTxt.TextColor3 = C_TEXT_TITLE
statusTxt.Font = Enum.Font.GothamBold
statusTxt.TextSize = 11
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.ZIndex = 6
local statusVal = Instance.new("TextLabel", statusPanel)
statusVal.Size = UDim2.new(0, 120, 1, 0)
statusVal.Position = UDim2.new(1, -130, 0, 0)
statusVal.BackgroundTransparency = 1
statusVal.Text = "OFF"
statusVal.TextColor3 = C_INACTIVE
statusVal.Font = Enum.Font.GothamBlack
statusVal.TextSize = 11
statusVal.TextXAlignment = Enum.TextXAlignment.Right
statusVal.ZIndex = 6
local function updateStatusPanel()
local activeList = {}
if Config.AntiDrop then table.insert(activeList, "1") end
if Config.AntiDie then table.insert(activeList, "2") end
if Config.AntiBat then table.insert(activeList, "3") end
if Config.HoldJump then table.insert(activeList, "4") end
local activeCount = #activeList
if activeCount > 0 then
statusVal.Text = table.concat(activeList, " | ")
statusVal.TextColor3 = C_ACTIVE
statusDot.BackgroundColor3 = C_ACTIVE
else
statusVal.Text = "OFF"
statusVal.TextColor3 = C_INACTIVE
statusDot.BackgroundColor3 = C_INACTIVE
end
end
-- =====================================================
--  TOGGLE PANEL
-- =====================================================
local function CreateTogglePanel(yPos, labelText, subText, keybindText)
local panel = CreatePanel(yPos, 38)
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(0, 120, 0, 16)
title.Position = UDim2.new(0, 10, 0, 4)
title.BackgroundTransparency = 1
title.Text = labelText
title.TextColor3 = C_TEXT_TITLE
title.Font = Enum.Font.GothamBlack
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
local sub = Instance.new("TextLabel", panel)
sub.Size = UDim2.new(0, 140, 0, 12)
sub.Position = UDim2.new(0, 10, 0, 22)
sub.BackgroundTransparency = 1
sub.Text = subText
sub.TextColor3 = C_TEXT_SUB
sub.Font = Enum.Font.Gotham
sub.TextSize = 9
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 6
local keyLbl = nil
if keybindText then
keyLbl = Instance.new("TextLabel", panel)
keyLbl.Size = UDim2.new(0, 25, 0, 16)
keyLbl.Position = UDim2.new(1, -80, 0.5, -8)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = keybindText
keyLbl.TextColor3 = C_TEXT_SUB
keyLbl.Font = Enum.Font.GothamBlack
keyLbl.TextSize = 10
keyLbl.ZIndex = 6
end
local toggleBg = Instance.new("Frame", panel)
toggleBg.Size = UDim2.new(0, 36, 0, 18)
toggleBg.Position = UDim2.new(1, -48, 0.5, -9)
toggleBg.BackgroundColor3 = C_TOGGLE_OFF
toggleBg.BorderSizePixel = 0
toggleBg.ZIndex = 6
Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
local toggleDot = Instance.new("Frame", toggleBg)
toggleDot.Size = UDim2.new(0, 12, 0, 12)
toggleDot.Position = UDim2.new(0, 3, 0.5, -6)
toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleDot.BorderSizePixel = 0
toggleDot.ZIndex = 7
Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)
local btn = Instance.new("TextButton", panel)
btn.Size = UDim2.new(1, 0, 1, 0)
btn.BackgroundTransparency = 1
btn.Text = ""
btn.ZIndex = 10
local function updateVisuals(state)
TweenService:Create(toggleBg, TweenInfo.new(0.2), {
BackgroundColor3 = state and C_TOGGLE_ON or C_TOGGLE_OFF
}):Play()
TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
}):Play()
updateStatusPanel()
end
return panel, btn, updateVisuals, toggleDot, keyLbl
end
-- =====================================================
--  LÓGICA: ANTI DROP
-- =====================================================
local mt = getrawmetatable(game)
local oldIdx, oldNewIdx
local spoofedVelocity = Vector3.zero
local antiDropActive = false
local function startAntiDrop()
if antiDropActive then return end
if not mt then return end
oldIdx = mt.__index
oldNewIdx = mt.__newindex
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
self:IsDescendantOf(LP.Character) then
return spoofedVelocity
end
return oldIdx(self, key)
end)
mt.__newindex = newcclosure(function(self, key, value)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
self:IsDescendantOf(LP.Character) then
spoofedVelocity = value
return
end
return oldNewIdx(self, key, value)
end)
setreadonly(mt, true)
antiDropActive = true
local char = LP.Character
if char then
createBillboard(char)
end
if billboardCharAddedConn then billboardCharAddedConn:Disconnect() end
billboardCharAddedConn = LP.CharacterAdded:Connect(function(c)
if Config.AntiDrop then
task.wait(0.1)
createBillboard(c)
end
end)
end
local function stopAntiDrop()
if not antiDropActive then return end
if mt and oldIdx then
setreadonly(mt, false)
mt.__index = oldIdx
mt.__newindex = oldNewIdx
setreadonly(mt, true)
oldIdx = nil
oldNewIdx = nil
end
antiDropActive = false
destroyBillboard()
end
-- =====================================================
--  LÓGICA: ANTI DIE
-- =====================================================
local heartConn, deathConns, charAddedConn = nil, {}, nil
local function protectChar(character)
if not character then return end
local hum = character:WaitForChild("Humanoid", 5)
if not hum then return end
hum.MaxHealth = math.huge
hum.Health = math.huge
local sc = hum.StateChanged:Connect(function(_, new)
if not Config.AntiDie then return end
if new == Enum.HumanoidStateType.Dead then
hum.Health = math.huge
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end
end)
table.insert(deathConns, sc)
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
if not Config.AntiDie then return end
if hum.Health < hum.MaxHealth then
hum.Health = math.huge
end
end)
table.insert(deathConns, hc)
if heartConn then heartConn:Disconnect() end
heartConn = RunService.Heartbeat:Connect(function()
if not Config.AntiDie then return end
if hum and hum.Parent and hum.Health < hum.MaxHealth then
hum.Health = math.huge
end
end)
end
local function startAntiDie()
for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
deathConns = {}
if heartConn then heartConn:Disconnect(); heartConn = nil end
if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
protectChar(LP.Character)
charAddedConn = LP.CharacterAdded:Connect(function(c)
if not Config.AntiDie then return end
task.wait(0.1)
for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
deathConns = {}
protectChar(c)
end)
end
local function stopAntiDie()
for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
deathConns = {}
if heartConn then heartConn:Disconnect(); heartConn = nil end
if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
local char = LP.Character
if char then
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
hum.MaxHealth = 100
hum.Health = 100
end
end
end
-- =====================================================
--  LÓGICA: ANTI BAT
-- =====================================================
local antiBatConnection = nil
local AntiBatForceX = 1000
local AntiBatForceZ = 1000
local function startAntiBat()
if antiBatConnection then return end
antiBatConnection = RunService.Heartbeat:Connect(function()
if not Config.AntiBat then return end
local char = LP.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
root.Velocity = Vector3.new(AntiBatForceX, root.Velocity.Y, AntiBatForceZ)
RunService.RenderStepped:Wait()
root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
end)
end
local function stopAntiBat()
if antiBatConnection then
antiBatConnection:Disconnect()
antiBatConnection = nil
end
end
-- =====================================================
--  LÓGICA: HOLD JUMP
-- =====================================================
RunService.Heartbeat:Connect(function()
if not Config.HoldJump then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if root and hum and hum.Jump then
root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
end
end)
-- =====================================================
--  CONSTRUCCIÓN DE TOGGLES
-- =====================================================
local yPos = 62
-- 1. ANTI DROP
local panel1, btn1, update1, dot1, key1 = CreateTogglePanel(yPos, "ANTI DROP", "Previene la caída", nil)
update1(Config.AntiDrop)
btn1.MouseButton1Click:Connect(function()
Config.AntiDrop = not Config.AntiDrop
update1(Config.AntiDrop)
if Config.AntiDrop then startAntiDrop() else stopAntiDrop() end
SaveConfig()
end)
-- 2. ANTI DIE
local panel2, btn2, update2, dot2, key2 = CreateTogglePanel(yPos + 42, "ANTI DIE", "Previene la muerte", Keys.antiDie.Name)
update2(Config.AntiDie)
btn2.MouseButton1Click:Connect(function()
Config.AntiDie = not Config.AntiDie
update2(Config.AntiDie)
if Config.AntiDie then startAntiDie() else stopAntiDie() end
SaveConfig()
end)
-- 3. ANTI BAT
local panel3, btn3, update3, dot3, key3 = CreateTogglePanel(yPos + 84, "ANTI BAT", "Previene Aimbots", nil)
update3(Config.AntiBat)
btn3.MouseButton1Click:Connect(function()
Config.AntiBat = not Config.AntiBat
update3(Config.AntiBat)
if Config.AntiBat then startAntiBat() else stopAntiBat() end
SaveConfig()
end)
-- 4. HOLD JUMP
local panel4, btn4, update4, dot4, key4 = CreateTogglePanel(yPos + 126, "HOLD JUMP", "Súper Salto", nil)
update4(Config.HoldJump)
btn4.MouseButton1Click:Connect(function()
Config.HoldJump = not Config.HoldJump
update4(Config.HoldJump)
SaveConfig()
end)
GUI_EXPANDED_HEIGHT = 240
-- =====================================================
--  INICIALIZAR ESTADOS GUARDADOS
-- =====================================================
if Config.AntiDrop then startAntiDrop() end
if Config.AntiDie then startAntiDie() end
if Config.AntiBat then startAntiBat() end
updateStatusPanel()
if Config.IsCollapsed then
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_COLLAPSED_HEIGHT)
end
if not Config.GuiVisible then
main.Visible = false
end
-- =====================================================
--  ATAJOS DE TECLADO
-- =====================================================
UIS.InputBegan:Connect(function(inp, gp)
if gp then return end
if inp.UserInputType == Enum.UserInputType.Keyboard then
if inp.KeyCode == Keys.antiDie then
Config.AntiDie = not Config.AntiDie
update2(Config.AntiDie)
if Config.AntiDie then startAntiDie() else stopAntiDie() end
SaveConfig()
elseif inp.KeyCode == Keys.guiHide then
Config.GuiVisible = not Config.GuiVisible
main.Visible = Config.GuiVisible
SaveConfig()
end
end
end)
-- =====================================================
--  CAMBIO DE KEYBIND
-- =====================================================
local kListening = false
local kConn = nil
local invisibleKeyBtn = Instance.new("TextButton", panel2)
invisibleKeyBtn.Size = UDim2.new(0, 35, 1, 0)
invisibleKeyBtn.Position = UDim2.new(1, -90, 0, 0)
invisibleKeyBtn.BackgroundTransparency = 1
invisibleKeyBtn.Text = ""
invisibleKeyBtn.ZIndex = 10
invisibleKeyBtn.MouseButton1Click:Connect(function()
if kListening then return end
kListening = true
if key2 then key2.Text = "..." end
kConn = UIS.InputBegan:Connect(function(inp)
if inp.UserInputType == Enum.UserInputType.Keyboard then
Keys.antiDie = inp.KeyCode
if key2 then key2.Text = inp.KeyCode.Name end
kListening = false
kConn:Disconnect()
end
end)
end)
print("LWZ HUB - Loaded Successfully")
