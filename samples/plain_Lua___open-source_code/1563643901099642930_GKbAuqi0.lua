local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- SETTINGS & STATE
local STATE = {
    CurrentPage = 1,
    MaxPages = 4,
    Draggable = false,
    Active = true,
    SaveFileName = "PC_Keyboard_Config.txt"
}

local SpawnedButtons = {}

-- UI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "Elite_PC_V26_Full"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.IgnoreGuiInset = true 
gui.Parent = player:WaitForChild("PlayerGui")

-- THE MAIN TRIGGER LOGO
local trigger = Instance.new("TextButton", gui)
trigger.Size = UDim2.fromOffset(55, 55); trigger.Position = UDim2.new(0.02, 0, 0.5, -27)
trigger.Text = "PC"; trigger.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
trigger.TextColor3 = Color3.new(0,0,0); trigger.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", trigger).CornerRadius = UDim.new(1, 0)
local triggerStroke = Instance.new("UIStroke", trigger); triggerStroke.Thickness = 2; triggerStroke.Color = Color3.new(0,0,0)

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 240); main.Position = UDim2.new(0.5, -130, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BackgroundTransparency = 0.15; main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main); mainStroke.Color = Color3.fromRGB(0, 255, 255)

local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 30); title.Text = "PAGE 1"; title.TextColor3 = Color3.fromRGB(0, 255, 255); title.Font = Enum.Font.Code; title.BackgroundTransparency = 1

-- HELPERS
local function styleBtn(btn, color) btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", btn) end
local function styleBox(box) box.BackgroundColor3 = Color3.new(1, 1, 1); box.TextColor3 = Color3.new(0, 0, 0); box.Font = Enum.Font.SourceSans; Instance.new("UICorner", box) end

local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input) 
        if (obj == main or obj == trigger or STATE.Draggable) then
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
                dragging = true; dragStart = input.Position; startPos = obj.Position 
            end 
        end
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

local function clearAllButtons()
    for key, btn in pairs(SpawnedButtons) do if btn and btn.Parent then btn:Destroy() end end
    table.clear(SpawnedButtons)
end

local hardwareMap = {
    ["W"] = 0x57, ["A"] = 0x41, ["S"] = 0x53, ["D"] = 0x44,
    ["1"] = 0x31, ["2"] = 0x32, ["3"] = 0x33, ["4"] = 0x34, ["5"] = 0x35,
    ["6"] = 0x36, ["7"] = 0x37, ["8"] = 0x38, ["9"] = 0x39, ["0"] = 0x30,
    ["SPACE"] = 0x20, ["LSHIFT"] = 0x10, ["RSHIFT"] = 0x10
}

-- SPAWNERS
local function spawnKey(key, pos)
    key = key:upper()
    if SpawnedButtons[key] then SpawnedButtons[key]:Destroy() end
    local b = Instance.new("TextButton", gui); b.Size = UDim2.fromOffset(45, 45); b.Position = pos or UDim2.new(0.5,0,0.5,0); b.Text = key; styleBtn(b, Color3.fromRGB(40,40,40))
    b.BackgroundTransparency = 0.3; b.TextSize = 14
    
    local hwCode = hardwareMap[key] or (key:len() == 1 and string.byte(key))

    b.MouseButton1Down:Connect(function()
        if STATE.Draggable or not hwCode then return end
        if keypress then keypress(hwCode) end
        if key == "SPACE" and player.Character and player.Character:FindFirstChild("Humanoid") then 
            player.Character.Humanoid.Jump = true 
        end
    end)
    
    local function endPress()
        if hwCode and keyrelease then keyrelease(hwCode) end
    end
    
    b.MouseButton1Up:Connect(endPress)
    b.MouseLeave:Connect(endPress)
    
    makeDraggable(b); SpawnedButtons[key] = b
end

local function spawnM(t, name, pos)
    if SpawnedButtons[name] then SpawnedButtons[name]:Destroy() end
    local b = Instance.new("TextButton", gui); b.Size = UDim2.fromOffset(60, 60); b.Position = pos or UDim2.new(0.7, 0, 0.7, 0); b.Text = name; styleBtn(b, Color3.fromRGB(0, 100, 200))
    b.BackgroundTransparency = 0.3

    b.MouseButton1Down:Connect(function()
        if STATE.Draggable then return end
        -- Note: Without CursorPos logic, this will click at (0,0) or center unless modified
        VIM:SendMouseButtonEvent(0, 0, t, true, game, 0)
    end)
    
    local function endPress()
        VIM:SendMouseButtonEvent(0, 0, t, false, game, 0)
    end
    
    b.MouseButton1Up:Connect(endPress)
    b.MouseLeave:Connect(endPress)

    makeDraggable(b); SpawnedButtons[name] = b
end

-- ORIGINAL JOYSTICK (Movement)
local function spawnJoystick(pos)
    local name = "JOYSTICK"
    if SpawnedButtons[name] then SpawnedButtons[name]:Destroy() end
    local base = Instance.new("Frame", gui); base.Size = UDim2.fromOffset(130, 130); base.Position = pos or UDim2.new(0.1, 0, 0.6, 0); base.BackgroundColor3 = Color3.new(0,0,0); base.BackgroundTransparency = 0.6; base.Active = true
    Instance.new("UICorner", base).CornerRadius = UDim.new(1,0)
    local stick = Instance.new("Frame", base); stick.Size = UDim2.fromOffset(50, 50); stick.Position = UDim2.new(0.5, -25, 0.5, -25); stick.BackgroundColor3 = Color3.fromRGB(0, 255, 255); stick.BackgroundTransparency = 0.2; stick.ZIndex = 5; Instance.new("UICorner", stick).CornerRadius = UDim.new(1,0)
    
    local keysDown = {W=false, A=false, S=false, D=false}
    local activeTouch = nil
    local function updateMovement(inputPos)
        local center = base.AbsolutePosition + (base.AbsoluteSize / 2)
        local delta = Vector2.new(inputPos.X - center.X, inputPos.Y - center.Y)
        local distance = delta.Magnitude
        local clamped = (distance > base.AbsoluteSize.X/2) and delta.Unit * (base.AbsoluteSize.X/2) or delta
        stick.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
        local function toggle(k, s) if keysDown[k] ~= s then keysDown[k] = s if s then keypress(hardwareMap[k]) else keyrelease(hardwareMap[k]) end end end
        if distance > 15 then local n = delta.Unit toggle("W", n.Y < -0.4) toggle("S", n.Y > 0.4) toggle("A", n.X < -0.4) toggle("D", n.X > 0.4) else for k,_ in pairs(keysDown) do toggle(k, false) end end
    end
    base.InputBegan:Connect(function(input) if not STATE.Draggable and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then activeTouch = input updateMovement(input.Position) end end)
    UserInputService.InputChanged:Connect(function(input) if activeTouch and input == activeTouch then updateMovement(input.Position) end end)
    UserInputService.InputEnded:Connect(function(input) if input == activeTouch then activeTouch = nil stick.Position = UDim2.new(0.5, -25, 0.5, -25) for k,_ in pairs(keysDown) do if keysDown[k] then keysDown[k]=false keyrelease(hardwareMap[k]) end end end end)
    makeDraggable(base); SpawnedButtons[name] = base
end

-- PAGES SETUP
local pages = {}
for i = 1, STATE.MaxPages do
    local p = Instance.new("Frame", main); p.Size = UDim2.new(1, -20, 1, -100); p.Position = UDim2.new(0, 10, 0, 35); p.BackgroundTransparency = 1; p.Visible = (i == 1); pages[i] = p
end
local function updateNav() for i, p in pairs(pages) do p.Visible = (i == STATE.CurrentPage) end title.Text = "PAGE " .. STATE.CurrentPage end

-- NAV BUTTONS
local backBtn = Instance.new("TextButton", main); backBtn.Size = UDim2.new(0.5, 0, 0, 30); backBtn.Position = UDim2.new(0,0,1,-30); backBtn.Text = "< PREV"; styleBtn(backBtn, Color3.fromRGB(30,30,30))
local nextBtn = Instance.new("TextButton", main); nextBtn.Size = UDim2.new(0.5, 0, 0, 30); nextBtn.Position = UDim2.new(0.5,0,1,-30); nextBtn.Text = "NEXT >"; styleBtn(nextBtn, Color3.fromRGB(30,30,30))
nextBtn.MouseButton1Click:Connect(function() STATE.CurrentPage = (STATE.CurrentPage % STATE.MaxPages) + 1 updateNav() end)
backBtn.MouseButton1Click:Connect(function() STATE.CurrentPage = (STATE.CurrentPage == 1) and STATE.MaxPages or STATE.CurrentPage - 1 updateNav() end)

-- PAGE 1: CUSTOM SPAWN
local kInp = Instance.new("TextBox", pages[1]); kInp.Size = UDim2.new(1, 0, 0, 25); kInp.PlaceholderText = "Key (E, 1, etc)"; styleBox(kInp)
local sBtn = Instance.new("TextButton", pages[1]); sBtn.Size = UDim2.new(0.48, 0, 0, 25); sBtn.Position = UDim2.new(0, 0, 0, 30); sBtn.Text = "SPAWN"; styleBtn(sBtn, Color3.fromRGB(0, 120, 80))
local svB = Instance.new("TextButton", pages[1]); svB.Size = UDim2.new(0.48, 0, 0, 25); svB.Position = UDim2.new(0.52, 0, 0, 30); svB.Text = "SAVE"; styleBtn(svB, Color3.fromRGB(80, 0, 180))
local delSvB = Instance.new("TextButton", pages[1]); delSvB.Size = UDim2.new(1, 0, 0, 25); delSvB.Position = UDim2.new(0, 0, 0, 60); delSvB.Text = "DELETE SAVE FILE"; styleBtn(delSvB, Color3.fromRGB(150, 0, 0))

sBtn.MouseButton1Click:Connect(function() spawnKey(kInp.Text) end)
svB.MouseButton1Click:Connect(function()
    local data = {}
    for key, btn in pairs(SpawnedButtons) do data[key] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset, XS = btn.Position.X.Scale, YS = btn.Position.Y.Scale} end
    if writefile then writefile(STATE.SaveFileName, HttpService:JSONEncode(data)) end
end)
delSvB.MouseButton1Click:Connect(function()
    if isfile and isfile(STATE.SaveFileName) then
        if delfile then delfile(STATE.SaveFileName) end
    end
end)

-- PAGE 2: PRESETS 
local scroll = Instance.new("ScrollingFrame", pages[2]); scroll.Size = UDim2.new(1,0,1,0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,0,300); scroll.ScrollBarThickness = 4
local function addPresetRow(name, spawnFunc, yPos)
    local row = Instance.new("Frame", scroll); row.Size = UDim2.new(1, -5, 0, 35); row.Position = UDim2.new(0,0,0,yPos); row.BackgroundTransparency = 1
    local s = Instance.new("TextButton", row); s.Size = UDim2.new(0.65, 0, 1, -5); s.Text = "ADD "..name; styleBtn(s, Color3.fromRGB(40,40,40))
    local d = Instance.new("TextButton", row); d.Size = UDim2.new(0.3, 0, 1, -5); d.Position = UDim2.new(0.7,0,0,0); d.Text = "DEL"; styleBtn(d, Color3.fromRGB(120, 30, 30))
    s.MouseButton1Click:Connect(spawnFunc)
    d.MouseButton1Click:Connect(function() if SpawnedButtons[name] then SpawnedButtons[name]:Destroy(); SpawnedButtons[name] = nil end end)
end
addPresetRow("JOYSTICK", spawnJoystick, 0)
addPresetRow("LMB", function() spawnM(0, "LMB") end, 40)
addPresetRow("RMB", function() spawnM(1, "RMB") end, 80)
addPresetRow("SPACE", function() spawnKey("SPACE") end, 120)
addPresetRow("L-SHIFT", function() spawnKey("LSHIFT") end, 160)
addPresetRow("NUM 0-9", function() for i=0,9 do spawnKey(tostring(i), UDim2.new(0.1 + (i*0.08), 0, 0.2, 0)) end end, 200)

-- PAGE 3: SYSTEM
local function sysB(txt, pos, cb)
    local b = Instance.new("TextButton", pages[3]); b.Size = UDim2.new(1,0,0,25); b.Position = pos; b.Text = txt; styleBtn(b, Color3.fromRGB(30,30,30)); b.MouseButton1Click:Connect(function() cb(b) end)
end
sysB("EDIT MODE: OFF", UDim2.new(0,0,0,0), function(b) STATE.Draggable = not STATE.Draggable b.Text = "EDIT MODE: "..(STATE.Draggable and "ON" or "OFF") end)
sysB("CLEAR ALL KEYS", UDim2.new(0,0,0,30), clearAllButtons)
sysB("CLOSE GUI", UDim2.new(0,0,0,60), function() gui:Destroy() end)

-- PAGE 4: TARGET DELETE
local dInp = Instance.new("TextBox", pages[4]); dInp.Size = UDim2.new(1, 0, 0, 25); dInp.PlaceholderText = "Key Name to Delete..."; styleBox(dInp)
local dBtn = Instance.new("TextButton", pages[4]); dBtn.Size = UDim2.new(1, 0, 0, 30); dBtn.Position = UDim2.new(0, 0, 0, 35); dBtn.Text = "DELETE KEY"; styleBtn(dBtn, Color3.fromRGB(150, 40, 40))
dBtn.MouseButton1Click:Connect(function() 
    local target = dInp.Text:upper() 
    if SpawnedButtons[target] then SpawnedButtons[target]:Destroy(); SpawnedButtons[target] = nil end 
end)

-- RUN
trigger.MouseButton1Click:Connect(function() if not STATE.Draggable then main.Visible = not main.Visible end end)
makeDraggable(main); makeDraggable(trigger)

-- LOAD SAVED
if isfile and isfile(STATE.SaveFileName) then
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(STATE.SaveFileName)) end)
    if success then
        for k, info in pairs(data) do 
            local p = UDim2.new(info.XS, info.X, info.YS, info.Y)
            if k == "JOYSTICK" then spawnJoystick(p) elseif k == "LMB" then spawnM(0, "LMB", p) elseif k == "RMB" then spawnM(1, "RMB", p) else spawnKey(k, p) end
        end
    end
end
