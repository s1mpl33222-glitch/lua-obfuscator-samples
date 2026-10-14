
if not game:IsLoaded() then game.Loaded:Wait() end

-- ==========================================
-- SERVICES
-- ==========================================

local Svc = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    VirtualInput = Instance.new("VirtualInputManager"),
    Stats = game:GetService("Stats"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    StarterGui = game:GetService("StarterGui"),
    GuiService = game:GetService("GuiService"),
    Workspace = game:GetService("Workspace"),
    HttpService = game:GetService("HttpService"),
    TextChatService = game:GetService("TextChatService"),
    UserInputService = game:GetService("UserInputService"),
    CollectionService = game:GetService("CollectionService"),
    TeleportService = game:GetService("TeleportService"),
}
local LocalPlayer = Svc.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Svc.Workspace.CurrentCamera

-- ==========================================
-- SYSTEME DE PURGE
-- ==========================================

if _G.SHARKY_Script_Purge then
    pcall(function() _G.SHARKY_Script_Purge() end)
    task.wait(0.2)
end

local ActiveConnections = {}
local thisScriptStopped = false

-- ==========================================
-- PARAMÈTRES
-- ==========================================

_G.AutoResetOnBalloon = _G.AutoResetOnBalloon or true
_G.AutoBlock = _G.AutoBlock or false
_G.LaggerOnFlash = _G.LaggerOnFlash or false
_G.LaggerPower = _G.LaggerPower or 50
_G.BlockDelay = _G.BlockDelay or "fast"
_G.SlotESP = false
_G.AutoSelectBest = _G.AutoSelectBest or false
_G.BrainrotHighlight = false
_G.TpPathVisual = false
_G.AutoGiant = _G.AutoGiant or false
_G.AutoPotion = _G.AutoPotion or false
_G.RagdollBypass = _G.RagdollBypass or false
_G.SelectedCarpet = _G.SelectedCarpet or "carpet"
_G.AutoGrabPosXScale = _G.AutoGrabPosXScale
_G.AutoGrabPosXOffset = _G.AutoGrabPosXOffset
_G.AutoGrabPosYScale = _G.AutoGrabPosYScale
_G.AutoGrabPosYOffset = _G.AutoGrabPosYOffset

local Settings = {
    ragdollBypassEnabled = false,
    autoBalloonEnabled = false,
    antiSwapEnabled = false,
    autoResetOnJail = true,
    autoResetOnTiny = false,
    autoGrabEnabled = false,
    autoFlashTPEnabled = false,
    antiRagdollEnabled = false,
    slotEspEnabled = false,
    autoSelectBest = false,
    brainrotHighlight = false,
    tpPathVisual = false,
    autoGiantEnabled = false,
    autoPotionEnabled = false,
}

local SETTINGS_FILE = "SHARKY_settings.json"

local function loadSettings()
    local ok, data = pcall(function()
        return Svc.HttpService:JSONDecode(readfile(SETTINGS_FILE))
    end)
    if ok and type(data) == "table" then
        for k, v in pairs(data) do
            if _G[k] ~= nil then _G[k] = v end
            if Settings[k] ~= nil then Settings[k] = v end
        end
        if data.AutoGrabPosXScale ~= nil then _G.AutoGrabPosXScale = data.AutoGrabPosXScale end
        if data.AutoGrabPosXOffset ~= nil then _G.AutoGrabPosXOffset = data.AutoGrabPosXOffset end
        if data.AutoGrabPosYScale ~= nil then _G.AutoGrabPosYScale = data.AutoGrabPosYScale end
        if data.AutoGrabPosYOffset ~= nil then _G.AutoGrabPosYOffset = data.AutoGrabPosYOffset end
        return data
    end
    return {}
end

local function saveSettings()
    pcall(function()
        writefile(SETTINGS_FILE, Svc.HttpService:JSONEncode({
            AutoResetOnBalloon = _G.AutoResetOnBalloon,
            AutoBlock = _G.AutoBlock,
            LaggerOnFlash = _G.LaggerOnFlash,
            LaggerPower = _G.LaggerPower,
            BlockDelay = _G.BlockDelay,
            SlotESP = _G.SlotESP,
            AutoSelectBest = _G.AutoSelectBest,
            BrainrotHighlight = _G.BrainrotHighlight,
            TpPathVisual = _G.TpPathVisual,
            AutoGiant = _G.AutoGiant,
            AutoPotion = _G.AutoPotion,
            RagdollBypass = _G.RagdollBypass,
            SelectedCarpet = _G.SelectedCarpet,
            AutoGrabPosXScale = _G.AutoGrabPosXScale,
            AutoGrabPosXOffset = _G.AutoGrabPosXOffset,
            AutoGrabPosYScale = _G.AutoGrabPosYScale,
            AutoGrabPosYOffset = _G.AutoGrabPosYOffset,
            ragdollBypassEnabled = Settings.ragdollBypassEnabled,
            autoBalloonEnabled = Settings.autoBalloonEnabled,
            antiSwapEnabled = Settings.antiSwapEnabled,
            autoResetOnJail = Settings.autoResetOnJail,
            autoResetOnTiny = Settings.autoResetOnTiny,
            autoGrabEnabled = Settings.autoGrabEnabled,
            autoFlashTPEnabled = Settings.autoFlashTPEnabled,
            antiRagdollEnabled = Settings.antiRagdollEnabled,
            slotEspEnabled = Settings.slotEspEnabled,
            autoSelectBest = Settings.autoSelectBest,
            brainrotHighlight = Settings.brainrotHighlight,
            tpPathVisual = Settings.tpPathVisual,
            autoGiantEnabled = Settings.autoGiantEnabled,
            autoPotionEnabled = Settings.autoPotionEnabled,
        }))
    end)
end

loadSettings()

-- ==========================================
-- KEYBINDS
-- ==========================================

local keybinds = {
    flash = { key = Enum.KeyCode.F, inputType = "Keyboard" },
    block = { key = Enum.KeyCode.B, inputType = "Keyboard" },
    reset = { key = Enum.KeyCode.R, inputType = "Keyboard" },
}
local keyNames = { flash = "F", block = "B", reset = "R" }

local KB_FILE = "SHARKY_keybinds.json"

local function saveKeybinds()
    pcall(function()
        writefile(KB_FILE, Svc.HttpService:JSONEncode({
            flash = { keyName = keyNames.flash, inputType = keybinds.flash.inputType },
            block = { keyName = keyNames.block, inputType = keybinds.block.inputType },
            reset = { keyName = keyNames.reset, inputType = keybinds.reset.inputType },
        }))
    end)
end

local function loadKeybinds()
    local ok, data = pcall(function()
        return Svc.HttpService:JSONDecode(readfile(KB_FILE))
    end)
    if ok and type(data) == "table" then
        for _, action in ipairs({"flash", "block", "reset"}) do
            if data[action] and type(data[action]) == "table" then
                if data[action].keyName then
                    keyNames[action] = data[action].keyName
                    if data[action].inputType then keybinds[action].inputType = data[action].inputType end
                    local ok2, kc = pcall(function() return Enum.KeyCode[data[action].keyName] end)
                    if ok2 and kc then keybinds[action].key = kc end
                end
            end
        end
    end
end

loadKeybinds()

-- ==========================================
-- UTILITAIRES
-- ==========================================

local function getDisplayName(friendlyName)
    if keybinds.flash.inputType == "Gamepad" and friendlyName then
        local short = friendlyName:gsub("^Button", ""):gsub("^DPad", "DPad ")
        if short == "LeftThumbstick" then short = "L3" end
        if short == "RightThumbstick" then short = "R3" end
        if short == "LeftShoulder" then short = "LB" end
        if short == "RightShoulder" then short = "RB" end
        if short == "LeftTrigger" then short = "LT" end
        if short == "RightTrigger" then short = "RT" end
        return "🎮 " .. short
    end
    return friendlyName or "?"
end

local function findTool(name)
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(name)) then
            return tool
        end
    end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(name)) then
            return tool
        end
    end
    return nil
end

local function getSelectedCarpetTool()
    local choice = (_G.SelectedCarpet or "carpet"):lower()
    local searchOrder = {}
    if choice == "broom" then searchOrder = {"broom", "witch"}
    elseif choice == "sleigh" then searchOrder = {"sleigh", "santa"}
    elseif choice == "wings" then searchOrder = {"wings", "cupid"}
    elseif choice == "waverider" then searchOrder = {"waverider", "wave rider", "wave"}
    elseif choice == "auto" then searchOrder = {"waverider", "wave rider", "wings", "cupid", "sleigh", "santa", "broom", "witch", "carpet", "magic carpet", "flying carpet", "rainbow"}
    else searchOrder = {"flying carpet", "magic carpet", "rainbow carpet", "carpet"} end

    for _, keyword in ipairs(searchOrder) do
        local tool = findTool(keyword)
        if tool then return tool end
    end
    return nil
end

local function isMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return true end
    end
    return false
end

local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state = prompt:GetAttribute("State")
    local actionText = prompt.ActionText
    if state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab" then return true end
    return false
end

local function getNearestPlayer()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Svc.Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then dist = d; closest = plr end
        end
    end
    return closest
end

-- ==========================================
-- COMMAND SYSTEM POUR RAGDOLL (STYLE HUGO)
-- ==========================================

local function getAdminTextBox()
    local AdminGui = PlayerGui:FindFirstChild("AdminPanel")
    if not AdminGui then return nil end
    local panel = AdminGui:FindFirstChild("AdminPanel")
    if not panel then return nil end
    local commandBox = panel:FindFirstChild("CommandBox")
    if not commandBox then return nil end
    return commandBox:FindFirstChild("TextBox")
end

local function fireCommandViaTextBox(command, targetPlayer)
    if not targetPlayer or not targetPlayer.Parent then return end
    local TextBox = getAdminTextBox()
    if not TextBox then return end

    local fullCmd = ";" .. command .. " " .. targetPlayer.Name
    local originalVisible = TextBox.Visible
    TextBox.Visible = false
    TextBox.Text = fullCmd
    task.wait(0.05)

    local executed = false
    if getconnections then
        pcall(function()
            for _, conn in pairs(getconnections(TextBox.FocusLost)) do conn:Fire(true) end
            executed = true
        end)
    end
    if not executed then
        pcall(function()
            if getconnections then
                for _, conn in pairs(getconnections(TextBox.KeyDown)) do conn:Fire(Enum.KeyCode.Return) end
            end
            executed = true
        end)
    end

    task.wait(0.05)
    TextBox.Text = ""
    TextBox.Visible = originalVisible
end

-- Anti Swap: Admin Panel tiny puis rocket sur un joueur
local function triggerAntiSwapOnTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Parent then return end

    local function fireGuiClick(btn)
        if not btn then return false end
        local ok = false
        pcall(function()
            if getconnections then
                for _, sigName in ipairs({"MouseButton1Click", "Activated", "MouseButton1Down", "MouseButton1Up"}) do
                    local sig = btn[sigName]
                    if sig then
                        for _, conn in pairs(getconnections(sig)) do
                            if conn.Function then task.spawn(conn.Function); ok = true
                            elseif conn.Fire then conn:Fire(); ok = true end
                        end
                    end
                end
            end
        end)
        pcall(function()
            if btn:IsA("GuiButton") then btn:Activate(); ok = true end
        end)
        return ok
    end

    local function findGuiByText(root, texts, classFilter)
        if not root then return nil end
        for _, desc in ipairs(root:GetDescendants()) do
            if classFilter then
                local matchClass = false
                for _, c in ipairs(classFilter) do
                    if desc:IsA(c) then matchClass = true; break end
                end
                if not matchClass then continue end
            end
            local txt = (desc:IsA("TextButton") or desc:IsA("TextLabel") or desc:IsA("TextBox")) and desc.Text or nil
            if txt and txt ~= "" then
                local low = string.lower(txt)
                for _, target in ipairs(texts) do
                    if low == string.lower(target) or string.find(low, string.lower(target), 1, true) then
                        return desc
                    end
                end
            end
            local n = string.lower(desc.Name)
            for _, target in ipairs(texts) do
                if n == string.lower(target) then return desc end
            end
        end
        return nil
    end

    local function clickTargetGui(gui, el)
        if not el then return false end
        local clickTarget = el
        if not el:IsA("GuiButton") then
            local parent = el.Parent
            while parent and parent ~= gui do
                if parent:IsA("GuiButton") then clickTarget = parent; break end
                parent = parent.Parent
            end
        end
        fireGuiClick(clickTarget)
        if clickTarget ~= el then fireGuiClick(el) end
        return true
    end

    local adminGui = PlayerGui:FindFirstChild("AdminPanel")
        or PlayerGui:FindFirstChild("Admin")
        or PlayerGui:FindFirstChild("AdminGui")
        or PlayerGui:FindFirstChild("AdminUI")
    if not adminGui then
        for _, child in ipairs(PlayerGui:GetChildren()) do
            if string.find(string.lower(child.Name), "admin") then adminGui = child; break end
        end
    end

    local usedUi = false
    if adminGui then
        pcall(function()
            if adminGui:IsA("ScreenGui") then adminGui.Enabled = true end
            local main = adminGui:FindFirstChild("AdminPanel") or adminGui:FindFirstChild("Main")
                or adminGui:FindFirstChild("Frame") or adminGui:FindFirstChildWhichIsA("Frame")
            if main and main:IsA("GuiObject") then main.Visible = true end
        end)
        local openBtn = findGuiByText(adminGui, {"open", "admin", "panel", "menu"}, {"TextButton", "ImageButton"})
        if openBtn then fireGuiClick(openBtn) end
        task.wait(0.06)

        local playerBtn = findGuiByText(adminGui, {targetPlayer.Name, targetPlayer.DisplayName}, {"TextButton", "ImageButton", "TextLabel", "Frame"})
        if playerBtn then
            clickTargetGui(adminGui, playerBtn)
            usedUi = true
        end
        task.wait(0.06)

        local tinyBtn = findGuiByText(adminGui, {"tiny", "tinify", "small"}, {"TextButton", "ImageButton"})
        if tinyBtn then
            clickTargetGui(adminGui, tinyBtn)
        else
            fireCommandViaTextBox("tiny", targetPlayer)
        end
        -- Rocket direct apres tiny (pas de delai)
        local rocketBtn = findGuiByText(adminGui, {"rocket", "rockets"}, {"TextButton", "ImageButton"})
        if rocketBtn then
            clickTargetGui(adminGui, rocketBtn)
        else
            fireCommandViaTextBox("rocket", targetPlayer)
        end
    end

    if not usedUi then
        fireCommandViaTextBox("tiny", targetPlayer)
        fireCommandViaTextBox("rocket", targetPlayer)
    end
end

-- ==========================================
-- FONCTION AUTO GIANT POTION + RAGDOLL (STYLE HUGO)
-- ==========================================

local function applyGiantPotionAndRagdoll()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    local giant = nil
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), "giant") then
            giant = tool
            break
        end
    end
    if not giant then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), "giant") then
                giant = tool
                break
            end
        end
    end
    
    if (_G.AutoGiant or _G.AutoPotion or Settings.autoGiantEnabled or Settings.autoPotionEnabled) and giant then
        hum:EquipTool(giant)
        task.wait(0.08)
        pcall(function() giant:Activate() end)
        
        if _G.RagdollBypass or Settings.ragdollBypassEnabled then
            task.spawn(function()
                fireCommandViaTextBox("ragdoll", LocalPlayer)
            end)
        end
        
        task.wait(0.05)
        hum:UnequipTools()
    elseif (_G.RagdollBypass or Settings.ragdollBypassEnabled) then
        task.spawn(function()
            fireCommandViaTextBox("ragdoll", LocalPlayer)
        end)
    end
end

-- ==========================================
-- ANTI RAGDOLL SYSTEM (Nexyra Unpatch)
-- ==========================================

local antiRagdollConn = nil

local function resetCharacter(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        
        Svc.Workspace.CurrentCamera.CameraSubject = hum
        
        local PM = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = PM:FindFirstChild("ControlModule")
            if CM then
                local success, module = pcall(require, CM)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    Settings.antiRagdollEnabled = true
    
    antiRagdollConn = Svc.RunService.Heartbeat:Connect(function()
        if not Settings.antiRagdollEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local state = hum:GetState()
        
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead or
           hum.PlatformStand == true or
           hum.Sit == true then
            
            resetCharacter(char)
        end
    end)
end

local function stopAntiRagdoll()
    Settings.antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Settings.antiRagdollEnabled then
        startAntiRagdoll()
    end
end)

-- ==========================================
-- RESET SYSTEM (avec camera lock)
-- ==========================================

local RS = {
    cooldown = false,
    lockId = 0,
    cameraLocked = false,
    lockedCFrame = nil,
    pendingAutoFlash = false,
    autoFlashRunning = false,
}

local function ResetPlayer()
    if RS.cooldown then return end
    RS.cooldown = true

    local character = LocalPlayer.Character
    if not character then RS.cooldown = false; return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then RS.cooldown = false; return end

    RS.lockId = RS.lockId + 1
    local myLockId = RS.lockId

    local camera = Svc.Workspace.CurrentCamera
    if camera and not RS.cameraLocked then
        RS.lockedCFrame = camera.CFrame
        RS.cameraLocked = true
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = RS.lockedCFrame
    end

    local originalHipHeight = humanoid.HipHeight
    if type(originalHipHeight) ~= "number" or originalHipHeight > 10 or originalHipHeight < 0 then
        originalHipHeight = 2
    end

    task.spawn(function()
        local attempts = 0
        while character and character.Parent and humanoid and humanoid.Health > 0 and myLockId == RS.lockId do
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
                -- Force la mort si Auto Flash TP attend un respawn
                if RS.pendingAutoFlash and attempts >= 8 then
                    humanoid.Health = 0
                end
            end)

            attempts = attempts + 1
            if attempts >= 25 then break end
            task.wait(0.05)
        end

        if character and character.Parent and humanoid then
            pcall(function() humanoid.HipHeight = originalHipHeight end)
        end

        if character and character.Parent and myLockId == RS.lockId then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                humanoid.PlatformStand = false
                humanoid.AutoRotate = true
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        if myLockId == RS.lockId then
            RS.cameraLocked = false
            RS.lockedCFrame = nil
            pcall(function()
                local cam = Svc.Workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    local newChar = LocalPlayer.Character
                    local newHum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                    if newHum then cam.CameraSubject = newHum end
                end
            end)
        end
        RS.cooldown = false
    end)
end

-- ==========================================
-- LAGGER
-- ==========================================

local laggerConn = nil

local function startFlashLagger()
    if not _G.LaggerOnFlash then return end
    local strength = math.clamp((_G.LaggerPower or 50) / 40, 0.3, 3.0)
    pcall(function() settings().Network.IncomingReplicationLag = strength end)
    if laggerConn then pcall(function() task.cancel(laggerConn) end); laggerConn = nil end
    laggerConn = task.delay(2.5, function()
        pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        laggerConn = nil
    end)
end

local function stopFlashLagger()
    if laggerConn then pcall(function() task.cancel(laggerConn) end); laggerConn = nil end
    pcall(function() settings().Network.IncomingReplicationLag = 0 end)
end

-- ==========================================
-- BLOCK SYSTEM
-- ==========================================

local function getBlockDelayValue()
    if _G.BlockDelay == "normal" then return 0.50
    elseif _G.BlockDelay == "slow" then return 1.00
    else return 0 end
end

local function blockPlayer(plr)
    if not plr or plr == LocalPlayer then return end
    pcall(function()
        Svc.StarterGui:SetCore("PromptBlockPlayer", plr)
        local viewportSize = Camera.ViewportSize
        local centerX = viewportSize.X / 2
        local centerY = (viewportSize.Y / 2) + 30
        for _ = 1, 4 do
            Svc.VirtualInput:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
            Svc.VirtualInput:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
            task.wait(0.001)
        end
    end)
end

-- ==========================================
-- SLOTS CONFIG
-- ==========================================

local SlotsConfig = {
    [1] = { Positions = { Vector3.new(-345.4766,-6.0291,1.5014) }, CamOffset = Vector3.new(-354.1492,4.0350,9.3823)-Vector3.new(-345.4766,-6.0291,1.5014), CamAngles = {-0.827500,-0.640100,-0.576243} },
    [2] = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5767) }, CamOffset = Vector3.new(-363.2081,2.9403,3.3074)-Vector3.new(-349.9259,-6.2791,-1.5767), CamAngles = {-1.007271,-0.967909,-0.916433} },
    [3] = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5758) }, CamOffset = Vector3.new(-367.7556,4.3232,3.4983)-Vector3.new(-349.9259,-6.2791,-1.5758), CamAngles = {-1.062718,-1.041500,-0.997864} },
    [4] = { Positions = { Vector3.new(-343.4199,-5.9197,10.5505) }, CamOffset = Vector3.new(-359.0885,4.0544,21.0001)-Vector3.new(-343.4199,-5.9197,10.5505), CamAngles = {-0.681953,-0.861073,-0.551998} },
    [5] = { Positions = { Vector3.new(-343.7608,-6.3272,-9.7994) }, CamOffset = Vector3.new(-363.9226,-0.3924,-9.1459)-Vector3.new(-343.7608,-6.3272,-9.7994), CamAngles = {-1.424811,-1.351549,-1.421283} },
    [6]  = { Positions = { Vector3.new(-340.9,-6.6,38.4) }, CamOffset = Vector3.new(-300.4433,6.4394,48.1955)-Vector3.new(-340.9,-6.6,38.4), CamAngles = {-0.2298,-1.2369,0} },
    [7] = { Positions = { Vector3.new(-344.4383,-6.4281,41.8672) }, CamOffset = Vector3.new(-362.8094,-3.2299,51.1552)-Vector3.new(-344.4383,-6.4281,41.8672), CamAngles = {-0.181885,-1.095968,-0.162135} },
    [8] = { Positions = { Vector3.new(-348.5228,-6.4281,48.1022) }, CamOffset = Vector3.new(-369.4075,-0.1123,63.3763)-Vector3.new(-348.5228,-6.4281,48.1022), CamAngles = {-0.306020,-0.916511,-0.245634} },
    [9] = { Positions = { Vector3.new(-339.6349,-6.4281,60.4164) }, CamOffset = Vector3.new(-349.9293,-1.6218,84.4119)-Vector3.new(-339.6349,-6.4281,60.4164), CamAngles = {-0.137335,-0.401849,-0.054002} },
    [10] = { Positions = { Vector3.new(-355.3322,-6.4281,25.3526) }, CamOffset = Vector3.new(-377.7117,8.9106,25.7208)-Vector3.new(-355.3322,-6.4281,25.3526), CamAngles = {-1.544218,-1.016502,-1.539540} },
    [11] = { Positions = { Vector3.new(-354.9932,-6.4281,-47.3879), Vector3.new(-331.5262,-6.4281,-47.3607) }, CamOffset = Vector3.new(-333.2372,-9.9613,-64.2099)-Vector3.new(-331.5262,-6.4281,-47.3607), CamAngles = {2.851853,-0.097011,3.112724} },
    [12] = { Positions = { Vector3.new(-354.9584,-6.4208,-42.6520), Vector3.new(-338.7290,-6.4281,-43.4713) }, CamOffset = Vector3.new(-346.9807,-9.9578,-60.5865)-Vector3.new(-338.7290,-6.4281,-43.4713), CamAngles = {2.856299,-0.433315,3.019061} },
    [13] = { Positions = { Vector3.new(-354.8862,-6.2793,-37.9787), Vector3.new(-334.5183,-6.4281,-41.6819) }, CamOffset = Vector3.new(-343.9747,-9.9590,-57.3332)-Vector3.new(-334.5183,-6.4281,-41.6819), CamAngles = {2.831168,-0.522070,2.982964} },
    [14] = { Positions = { Vector3.new(-351.8463,-6.5022,-37.0529), Vector3.new(-319.8298,-6.4281,-45.1476) }, CamOffset = Vector3.new(-325.1408,-9.9618,-60.9837)-Vector3.new(-319.8298,-6.4281,-45.1476), CamAngles = {2.834406,-0.309406,3.045298} },
    [15] = { Positions = { Vector3.new(-351.0894,-6.2833,-32.7751), Vector3.new(-317.9170,-6.4281,-41.9999) }, CamOffset = Vector3.new(-327.9996,-9.9581,-57.8876)-Vector3.new(-317.9170,-6.4281,-41.9999), CamAngles = {2.835549,-0.544183,2.979445} },
    [16] = { Positions = { Vector3.new(-338.2857,-6.4281,57.2060) }, CamOffset = Vector3.new(-341.5551,-9.9642,72.3530)-Vector3.new(-338.2857,-6.4281,57.2060), CamAngles = {0.320392,-0.202067,0.066497} },
    [17] = { Positions = { Vector3.new(-337.9285,-6.4281,55.1757) }, CamOffset = Vector3.new(-344.4950,-9.9637,69.4787)-Vector3.new(-337.9285,-6.4281,55.1757), CamAngles = {0.337895,-0.408747,0.138758} },
    [18] = { Positions = { Vector3.new(-332.1088,-6.4281,53.1675) }, CamOffset = Vector3.new(-338.8290,-9.9674,65.6692)-Vector3.new(-332.1088,-6.4281,53.1675), CamAngles = {0.382481,-0.462609,0.177644} },
    [19] = { Positions = { Vector3.new(-347.9923,-6.2933,-34.0232), Vector3.new(-328.5790,-6.4281,-35.0857) }, CamOffset = Vector3.new(-328.6130,-10.0174,-40.4923)-Vector3.new(-328.5790,-6.4281,-35.0857), CamAngles = {2.387391,-0.004579,3.137291} },
    [20] = { Positions = { Vector3.new(-355.0801,-6.4404,-33.2302), Vector3.new(-321.5783,-6.4281,-33.5778) }, CamOffset = Vector3.new(-321.6123,-10.0174,-38.9844)-Vector3.new(-321.5783,-6.4281,-33.5778), CamAngles = {2.387391,-0.004579,3.137291} },
    [21] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-314.088,-7.5033,-32.1806) }, CamOffset = Vector3.new(-314.1147,-10.0174,-36.4214)-Vector3.new(-314.088,-7.5033,-32.1806), CamAngles = {2.387391,-0.004579,3.137291}, NeedJump = true },
    [22] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-306.8919,-7.5033,-33.9124) }, CamOffset = Vector3.new(-306.923,-10.008,-38.86)-Vector3.new(-306.8919,-7.5033,-33.9124), CamAngles = {2.4648,-0.004898,3.137657}, NeedJump = true },
    [23] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-300.2759,-7.5033,-32.7047) }, CamOffset = Vector3.new(-300.4669,-10.016,-37.044)-Vector3.new(-300.2759,-7.5033,-32.7047), CamAngles = {2.399014,-0.032413,3.111857}, NeedJump = true },
    [24] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-330.0484,-7.5033,48.183) }, CamOffset = Vector3.new(-330.1124,-10.0063,53.2779)-Vector3.new(-330.0484,-7.5033,48.183), CamAngles = {0.662308,-0.00991,0.007727}, NeedJump = true },
    [25] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-325.4576,-7.5033,46.8182) }, CamOffset = Vector3.new(-326.0541,-10.0104,51.5397)-Vector3.new(-325.4576,-7.5033,46.8182), CamAngles = {0.700033,-0.09632,0.080833}, NeedJump = true },
    [26] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-324.6721,-7.5033,47.2033) }, CamOffset = Vector3.new(-326.6859,-10.0057,51.9385)-Vector3.new(-324.6721,-7.5033,47.2033), CamAngles = {0.698024,-0.314979,0.254268}, NeedJump = true },
    [27] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-320.4196,-7.5033,44.1) }, CamOffset = Vector3.new(-322.9213,-10.0122,49.5157)-Vector3.new(-320.4196,-7.5033,44.1), CamAngles = {0.876985,-0.422603,0.397417} },
}

-- ==========================================
-- SLOT ESP + TP PATH VISUAL (COULEUR ROUGE)
-- ==========================================

local currentSlotMarker = nil
local currentBrainrotHL = nil
local tpPathMarkers = {}
local tpTargetHighlight = nil
local selectedPrompt = nil
local selectedSlotNumber = nil

local function clearSlotMarker()
    if currentSlotMarker then
        pcall(function() currentSlotMarker:Destroy() end)
        currentSlotMarker = nil
    end
    if currentBrainrotHL then
        pcall(function() currentBrainrotHL:Destroy() end)
        currentBrainrotHL = nil
    end
end

local function clearTpPathVisual()
    for _, m in ipairs(tpPathMarkers) do
        pcall(function() m:Destroy() end)
    end
    tpPathMarkers = {}
    if tpTargetHighlight then
        pcall(function() tpTargetHighlight:Destroy() end)
        tpTargetHighlight = nil
    end
end

local function findBrainrotModel(prompt)
    if not prompt then return nil end
    local playerNames = {}
    for _, p in pairs(Svc.Players:GetPlayers()) do playerNames[p.Name] = true end
    local petName = prompt.ObjectText
    local spawnPoint = prompt:FindFirstAncestor("Spawn")
    if not spawnPoint then return nil end
    local refPos = spawnPoint.Position
    local plotsFolder = Svc.Workspace:FindFirstChild("Plots") or Svc.Workspace
    local bestModel, bestScore = nil, math.huge
    for _, v in ipairs(plotsFolder:GetDescendants()) do
        if v:IsA("Model") and not playerNames[v.Name] and v.Name ~= "Base" and v.Name ~= "Podium" then
            local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
            if rp then
                local d = (rp.Position - refPos).Magnitude
                if d < 15 then
                    local score = d
                    if petName and petName ~= "" and v.Name == petName then score = d - 0.5 end
                    if score < bestScore then bestScore = score; bestModel = v end
                end
            end
        end
    end
    return bestModel
end

local function createSlotMarker(prompt)
    -- ESP desactive
end

local function createArrowMarker(position, index)
    -- ESP desactive
    return nil
end

local function showTpPathVisual(prompt, slotNumber)
    -- ESP desactive
end

-- ==========================================
-- FLASH SAFE ZONE (HUGO PVP STYLE)
-- ==========================================

local FLASH_SAFE = {
    zone = { minX = -337.34, maxX = -294.05, minZ = 91.94, maxZ = 135.06 },
    pos = Vector3.new(-356.39, -6.10, 100.21),
}

local function isInFlashSafeZone(pos)
    if not pos then return false end
    return pos.X >= FLASH_SAFE.zone.minX and pos.X <= FLASH_SAFE.zone.maxX
       and pos.Z >= FLASH_SAFE.zone.minZ and pos.Z <= FLASH_SAFE.zone.maxZ
end

-- ==========================================
-- AUTO GRAB SYSTEM AVEC PANEL STYLE FUN DEFENSE
-- ==========================================

local Steal = {
    AutoStealEnabled = false,
    StealRadius = 55,
    StealDuration = 0.2,
    Mode = "half",
    HalfFireRange = 10,
    HalfHoldMin = 1.3,
    HalfHoldMax = 2.6,
    HalfEntryDelay = 0.3,
    Data = {},
    SelectedEntry = nil,
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local activeBrainrotCache = {}

local T = {
    Bg          = Color3.fromRGB(25, 25, 25),
    BgDeep      = Color3.fromRGB(7, 8, 11),
    Side        = Color3.fromRGB(15, 20, 40),
    SideHover   = Color3.fromRGB(20, 45, 75),
    SideActive  = Color3.fromRGB(25, 65, 110),
    Card        = Color3.fromRGB(15, 20, 40),
    CardHover   = Color3.fromRGB(20, 45, 75),
    Line        = Color3.fromRGB(255, 255, 255),
    Soft        = Color3.fromRGB(23, 26, 36),
    Text        = Color3.fromRGB(255, 255, 255),
    TextDim     = Color3.fromRGB(210, 225, 255),
    TextMute    = Color3.fromRGB(150, 160, 190),
    Primary     = Color3.fromRGB(50, 150, 255),
    White       = Color3.fromRGB(255, 255, 255),
    Red       = Color3.fromRGB(50, 150, 255),
    Red         = Color3.fromRGB(35, 125, 235),
}

local Theme = {
    c1 = Color3.fromRGB(50, 150, 255),
    c2 = Color3.fromRGB(25, 105, 220),
}

local spFrame = nil
local hasBrainrotDetected = false

local AG = { paused = false, pauseEnd = 0, pauseDur = 20 }

local function pauseAutoGrab()
    if Steal.AutoStealEnabled then
        AG.paused = true
        AG.pauseEnd = tick() + AG.pauseDur
        if spFrame then
            spFrame.Visible = false
        end
        print("⏸️ Auto Grab en pause pour " .. AG.pauseDur .. " secondes")
    end
end

local function resumeAutoGrab()
    AG.paused = false
    if Steal.AutoStealEnabled then
        if spFrame then
            spFrame.Visible = true
        end
        print("▶️ Auto Grab repris")
    end
end

local function scanForBrainrots()
    local plots = Svc.Workspace:FindFirstChild("Plots")
    if not plots then return false end
    
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    if base then
                        local sp = base:FindFirstChild("Spawn")
                        if sp then
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, child in ipairs(att:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

local brainrotScanConn = nil

local function startBrainrotScanner()
    if brainrotScanConn then return end
    brainrotScanConn = Svc.RunService.Heartbeat:Connect(function()
        if thisScriptStopped then
            pcall(function() brainrotScanConn:Disconnect() end)
            brainrotScanConn = nil
            return
        end

        if AG.paused and tick() >= AG.pauseEnd then
            resumeAutoGrab()
        end

        local found = scanForBrainrots()

        if found and not hasBrainrotDetected then
            hasBrainrotDetected = true
            print("✅ Brainrot détecté - barre + Auto Grab")
            if spFrame then spFrame.Visible = true end
            if not Steal.AutoStealEnabled and not AG.paused then
                startAutoGrab()
            end
        elseif not found and hasBrainrotDetected then
            hasBrainrotDetected = false
            print("❌ Plus de brainrot détecté")
            if spFrame and not Steal.AutoStealEnabled then
                spFrame.Visible = false
            end
        end
    end)
    table.insert(ActiveConnections, brainrotScanConn)
    print("🔄 Scanneur de brainrots activé")
end

local function stopBrainrotScanner()
    if brainrotScanConn then
        pcall(function() brainrotScanConn:Disconnect() end)
        brainrotScanConn = nil
    end
end

local function getPromptForPodium(plot, slot)
    if not plot or not slot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local podium = pods:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local base = podium:FindFirstChild("Base")
    if base then
        local spawn = base:FindFirstChild("Spawn")
        if spawn then
            local att = spawn:FindFirstChild("PromptAttachment")
            if att then
                for _, pr in ipairs(att:GetChildren()) do
                    if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                        return pr
                    end
                end
            end
            for _, pr in ipairs(spawn:GetDescendants()) do
                if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                    return pr
                end
            end
        end
        for _, pr in ipairs(base:GetDescendants()) do
            if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                return pr
            end
        end
    end

    for _, pr in ipairs(podium:GetDescendants()) do
        if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
            return pr
        end
    end

    for _, pr in ipairs(plot:GetDescendants()) do
        if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
            local parent = pr.Parent
            while parent and parent ~= plot do
                if parent.Name == tostring(slot) then
                    return pr
                end
                parent = parent.Parent
            end
        end
    end
    return nil
end

local function findTargetPrompt()
    if Steal.SelectedEntry and Steal.SelectedEntry.prompt then
        local prompt = Steal.SelectedEntry.prompt
        if prompt and prompt.Parent and prompt:IsA("ProximityPrompt") then
            local plot = Steal.SelectedEntry.plot
            if plot and plot.Parent and not isMyPlot(plot) then
                if activeBrainrotCache[Steal.SelectedEntry.uid] then
                    return prompt
                else
                    Steal.SelectedEntry = nil
                end
            end
        end
        Steal.SelectedEntry = nil
    end

    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = Svc.Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= Steal.StealRadius and d < dist then
                            local found = getPromptForPodium(plot, tonumber(pod.Name))
                            if found then
                                nearest, dist = found, d
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function _promptDist(prompt)
    local char = LocalPlayer.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    if part and part:IsA("BasePart") then
        return (part.Position - root.Position).Magnitude
    end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then
        return (cf - root.Position).Magnitude
    end
    return math.huge
end

local function executeSteal(prompt)
    if isStealing or AG.paused then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
            end
        end
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = tick()

    if Steal.Mode == "half" then
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            task.wait(Steal.HalfHoldMin)
            local inRange = _promptDist(prompt) <= Steal.HalfFireRange
            while true do
                local el = tick() - stealStartTime
                if el > Steal.HalfHoldMax or not prompt.Parent then break end
                if _promptDist(prompt) <= Steal.HalfFireRange then
                    if not inRange then task.wait(Steal.HalfEntryDelay) end
                    for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                    break
                end
                task.wait()
            end
            task.wait(0.05)
            data.ready = true
            isStealing = false
        end)
    else
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local el = 0
            while el < Steal.StealDuration do
                el = el + task.wait()
            end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            task.wait(0.05)
            data.ready = true
            isStealing = false
        end)
    end
end

local function startAutoGrab()
    if autoConn then return end
    Steal.AutoStealEnabled = true
    AG.paused = false
    autoConn = Svc.RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing or AG.paused then return end
        local p = findTargetPrompt()
        if p then executeSteal(p) end
    end)
    if spFrame then spFrame.Visible = true end
    print("✅ Auto Grab ENABLED")
end

local function stopAutoGrab()
    Steal.AutoStealEnabled = false
    AG.paused = false
    if autoConn then
        pcall(function() autoConn:Disconnect() end)
        autoConn = nil
    end
    isStealing = false
    -- garde la barre visible s'il reste un brainrot
    if spFrame and not hasBrainrotDetected then
        spFrame.Visible = false
    end
    print("❌ Auto Grab DISABLED")
end

local function createAutoGrabPanel()
    local _oldSPG = PlayerGui:FindFirstChild("StealProgressScreenGui")
    if _oldSPG then _oldSPG:Destroy() end

    local spScreenGui = Instance.new("ScreenGui")
    spScreenGui.Name = "StealProgressScreenGui"
    spScreenGui.ResetOnSpawn = false
    spScreenGui.DisplayOrder = 200
    spScreenGui.IgnoreGuiInset = true
    spScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    spScreenGui.Parent = PlayerGui

    spFrame = Instance.new("Frame", spScreenGui)
    spFrame.Name = "StealProgressGui"
    spFrame.Size = UDim2.new(0, 210, 0, 44)
    if _G.AutoGrabPosXScale ~= nil and _G.AutoGrabPosXOffset ~= nil
        and _G.AutoGrabPosYScale ~= nil and _G.AutoGrabPosYOffset ~= nil then
        spFrame.Position = UDim2.new(
            _G.AutoGrabPosXScale, _G.AutoGrabPosXOffset,
            _G.AutoGrabPosYScale, _G.AutoGrabPosYOffset
        )
    else
        spFrame.Position = UDim2.new(0.5, -105, 0.5, -22)
    end
    spFrame.AnchorPoint = Vector2.new(0.5, 1)
    spFrame.BackgroundColor3 = T.Bg
    spFrame.BackgroundTransparency = 0.05
    spFrame.BorderSizePixel = 0
    spFrame.Active = true
    spFrame.Visible = false
    spFrame.ZIndex = 60
    spFrame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = spFrame

    local border = Instance.new("UIStroke", spFrame)
    border.Color = Theme.c1
    border.Thickness = 1.5
    border.Transparency = 0.2
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local borderGrad = Instance.new("UIGradient", border)
    borderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.c2),
        ColorSequenceKeypoint.new(0.5, Theme.c1),
        ColorSequenceKeypoint.new(1, Theme.c2),
    })
    borderGrad.Rotation = 0

    local Shadow = Instance.new("ImageLabel", spFrame)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Color3.fromRGB(80, 20, 120)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    Shadow.ZIndex = 59
    Shadow.Parent = spFrame

    local dot = Instance.new("Frame", spFrame)
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 12, 0, 11)
    dot.BackgroundColor3 = Theme.c1
    dot.BorderSizePixel = 0
    dot.ZIndex = 61
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 3)
    dotCorner.Parent = dot
    local dotGrad = Instance.new("UIGradient", dot)
    dotGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.c2),
        ColorSequenceKeypoint.new(1, Theme.c1),
    })

    local title = Instance.new("TextLabel")
    title.Text = "AUTO GRAB"
    title.TextSize = 11
    title.TextColor3 = T.Text
    title.Font = Enum.Font.GothamBold
    title.Size = UDim2.new(1, -100, 0, 14)
    title.Position = UDim2.new(0, 24, 0, 7)
    title.BackgroundTransparency = 1
    title.ZIndex = 61
    title.Parent = spFrame

    local pct = Instance.new("TextLabel")
    pct.Text = "0%"
    pct.TextSize = 11
    pct.TextColor3 = T.TextDim
    pct.Font = Enum.Font.GothamBold
    pct.Size = UDim2.new(0, 80, 0, 14)
    pct.Position = UDim2.new(1, -92, 0, 7)
    pct.BackgroundTransparency = 1
    pct.TextXAlignment = Enum.TextXAlignment.Right
    pct.ZIndex = 61
    pct.Parent = spFrame

    local track = Instance.new("Frame", spFrame)
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 1, -16)
    track.BackgroundColor3 = T.Soft
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 61
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 4)
    trackCorner.Parent = track
    local trackBorder = Instance.new("UIStroke", track)
    trackBorder.Color = Theme.c1
    trackBorder.Thickness = 0.8
    trackBorder.Transparency = 0.5
    trackBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(25, 105, 220)
    fill.BorderSizePixel = 0
    fill.ZIndex = 62
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 105, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 105, 220)),
    })

    local dragFrame = Instance.new("Frame", spFrame)
    dragFrame.Size = UDim2.new(1, 0, 1, 0)
    dragFrame.BackgroundTransparency = 1
    dragFrame.ZIndex = 100
    dragFrame.Active = true

    local dragging = false
    local dragStart = nil
    local frameStart = nil
    local dragMoved = false

    dragFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            frameStart = spFrame.Position
            dragMoved = false
        end
    end)

    dragFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            if dragging and dragMoved and spFrame then
                local pos = spFrame.Position
                _G.AutoGrabPosXScale = pos.X.Scale
                _G.AutoGrabPosXOffset = pos.X.Offset
                _G.AutoGrabPosYScale = pos.Y.Scale
                _G.AutoGrabPosYOffset = pos.Y.Offset
                saveSettings()
            end
            dragging = false
        end
    end)

    Svc.UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = inp.Position - dragStart
        if not dragMoved then
            if delta.Magnitude < 3 then return end
            dragMoved = true
        end
        spFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end)

    local shown = 0
    local _barAcc = 0
    local targetName = ""
    local hasTarget = false
    local waitUntil = 0

    Svc.RunService.Heartbeat:Connect(function(dt)
        -- Visible si Auto Grab ON ou si un nouveau brainrot est detecte
        local on = (Steal.AutoStealEnabled and not AG.paused) or hasBrainrotDetected
        if spFrame then spFrame.Visible = on end
        if not on then return end

        local prompt = findTargetPrompt()
        if prompt then
            hasTarget = true
            if Steal.SelectedEntry and Steal.SelectedEntry.name then
                targetName = Steal.SelectedEntry.name
            else
                targetName = (prompt.ObjectText ~= "" and prompt.ObjectText) or "Brainrot"
            end
        else
            hasTarget = false
        end

        local wu = waitUntil or 0
        if wu <= tick() then
            local p = 0
            if isStealing and stealStartTime then
                p = math.clamp((tick() - stealStartTime) / 1.3, 0, 1)
            elseif hasTarget then
                p = 1
            end
            shown = shown + (p - shown) * math.clamp(dt * 14, 0, 1)
        end

        _barAcc = _barAcc + dt
        if _barAcc < (1/30) then return end
        _barAcc = 0

        if wu > tick() then
            local remain = math.max(0, wu - tick())
            shown = 1
            fill.Size = UDim2.new(1, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(25, 105, 220)
            title.Text = targetName ~= "" and targetName or "Waiting..."
            pct.Text = string.format("%.1fs", remain)
            pct.TextColor3 = T.TextMute
            return
        end

        local fillPercent = math.clamp(shown, 0, 1)
        fill.Size = UDim2.new(fillPercent, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(25, 105, 220)

        if hasTarget then
            title.Text = targetName ~= "" and targetName or "Stealing..."
            pct.Text = string.format("%d%%", math.floor(fillPercent * 100))
            pct.TextColor3 = Color3.fromRGB(50, 150, 255)
        else
            title.Text = "AUTO GRAB"
            pct.Text = hasBrainrotDetected and "brainrot..." or "searching..."
            pct.TextColor3 = T.TextMute
        end
    end)
end

createAutoGrabPanel()

_G.AutoSteal = Steal

-- ==========================================
-- FLASH TP SYSTEM (AVEC SAFE ZONE HUGO STYLE)
-- ==========================================

local autoStealEnabled = false
local stealDelay = 1.30
local currentMovement = nil
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local Camera = Svc.Workspace.CurrentCamera

-- Toujours rafraîchir Character / Humanoid / Root après un reset / respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Root = newChar:WaitForChild("HumanoidRootPart")
    Camera = Svc.Workspace.CurrentCamera
    autoStealEnabled = false
    if currentMovement then
        pcall(function() currentMovement:Disconnect() end)
        currentMovement = nil
    end
end)

local function firePromptConnections(prompt, signalName)
    if not getconnections then return end
    local connections = getconnections(prompt[signalName])
    for _, conn in ipairs(connections) do
        if conn.Function then task.spawn(conn.Function) end
    end
end

local function executeStealFlash(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    isStealing = true
    firePromptConnections(prompt, "PromptButtonHoldBegan")
    task.wait(stealDelay)
    if prompt and prompt.Parent and prompt.Enabled and not thisScriptStopped then
        firePromptConnections(prompt, "Triggered")
    end
    isStealing = false
end

local TD = { stop = 5, slow = 20 }

local function startTripToPetSlot(prompt, slotNumber)
    local config = SlotsConfig[slotNumber] or SlotsConfig[1]
    local targetPositions = config.Positions or { config.Position }
    local needJump = config.NeedJump == true
    if slotNumber >= 19 and slotNumber <= 27 then needJump = true end

    -- Anti Swap des que Flash TP s'active: tiny puis rocket direct
    if Settings.antiSwapEnabled then
        local swapTarget = getNearestPlayer()
        if swapTarget then
            task.spawn(function() triggerAntiSwapOnTarget(swapTarget) end)
        end
    end

    -- ==========================================
    -- SAFE ZONE HUGO STYLE
    -- Si le joueur est dans la zone dangereuse, va d'abord à la position sûre
    -- Toujours lire la position du personnage ACTUEL (après reset Root peut être obsolète)
    -- ==========================================
    local liveChar = LocalPlayer.Character
    local liveRoot = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
    local rootNow = liveRoot and liveRoot.Position
    if rootNow and isInFlashSafeZone(rootNow) then
        local positions = { FLASH_SAFE.pos }
        for _, p in ipairs(targetPositions) do
            table.insert(positions, p)
        end
        targetPositions = positions
    end

    pauseAutoGrab()

    if currentMovement then pcall(function() currentMovement:Disconnect() end); currentMovement = nil end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    autoStealEnabled = true
    local Speed = 200
    local grabStartDistance = 60
    local grabStarted = false

    local carpet = getSelectedCarpetTool()
    if carpet then hum:UnequipTools(); task.wait(0.03); hum:EquipTool(carpet) end

    if root:FindFirstChild("LinearVelocity") then root.LinearVelocity:Destroy() end
    if root:FindFirstChild("Attachment") then root.Attachment:Destroy() end

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = root

    local Velocity = Instance.new("LinearVelocity")
    Velocity.Attachment0 = Attachment
    Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce = math.huge
    Velocity.Parent = root

    local currentPosIndex = 1
    local intermediatePauseActive = false
    local giantActivated = false

    currentMovement = Svc.RunService.Heartbeat:Connect(function()
        if thisScriptStopped then
            if currentMovement then pcall(function() currentMovement:Disconnect() end); currentMovement = nil end
            return
        end
        if not root or not hum or not root.Parent or hum.Health <= 0 then
            if currentMovement then pcall(function() currentMovement:Disconnect() end); currentMovement = nil end
            return
        end
        if intermediatePauseActive then Velocity.VectorVelocity = Vector3.zero; return end

        local TargetPosition = targetPositions[currentPosIndex]
        if not TargetPosition then return end

        local rootPos = root.Position
        local dir = Vector3.new(TargetPosition.X - rootPos.X, 0, TargetPosition.Z - rootPos.Z)
        local dist = dir.Magnitude

        if currentPosIndex == 1 and dist <= grabStartDistance and not grabStarted then
            grabStarted = true
            task.spawn(function() executeStealFlash(prompt) end)
        end

        local speedMult = 1
        if dist < TD.slow then speedMult = math.max(0.15, dist / TD.slow) end

        if dist <= TD.stop then
            if currentPosIndex < #targetPositions then
                intermediatePauseActive = true
                Velocity.VectorVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
                task.spawn(function()
                    currentPosIndex = currentPosIndex + 1
                    intermediatePauseActive = false
                end)
                return
            end

            Velocity.VectorVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            Velocity:Destroy()
            Attachment:Destroy()
            root.CFrame = CFrame.new(TargetPosition)
            if currentMovement then pcall(function() currentMovement:Disconnect() end); currentMovement = nil end

            task.wait(0.12)
            Camera.CameraType = Enum.CameraType.Scriptable
            if config.FixedCFrame then
                Camera.CFrame = config.FixedCFrame
            elseif config.CamOffset then
                Camera.CFrame = CFrame.new(root.Position + config.CamOffset) * CFrame.Angles(unpack(config.CamAngles))
            else
                Camera.CFrame = CFrame.new(root.Position + Vector3.new(0, 5, 0)) * CFrame.Angles(unpack(config.CamAngles))
            end
            hum:UnequipTools()
            task.wait(0.06)

            if needJump then
                root.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
                task.wait(0.08)
            end

            -- Ordre: equipe FLASH d'abord, puis POTION, puis Activate flash
            -- Auto Block (apres Activate flash):
            -- FAST   = direct a l'activation
            -- NORMAL = 0.5s apres activation
            -- SLOW   = 1.0s apres activation
            local function doAutoBlock()
                if not _G.AutoBlock then return end
                local target = getNearestPlayer()
                if target then blockPlayer(target) end
            end

            local delayMode = (_G.BlockDelay or "fast"):lower()

            local flash = findTool("flash")
            if flash then
                hum:EquipTool(flash)
            end

            if not giantActivated and (_G.AutoGiant or _G.AutoPotion or Settings.autoGiantEnabled or Settings.autoPotionEnabled) then
                local giant = findTool("giant potion") or findTool("giant")
                if giant then
                    hum:EquipTool(giant)
                    task.wait(0.08)
                    pcall(function() giant:Activate() end)

                    if _G.RagdollBypass or Settings.ragdollBypassEnabled then
                        task.spawn(function()
                            fireCommandViaTextBox("ragdoll", LocalPlayer)
                        end)
                    end

                    task.wait(0.05)
                    giantActivated = true
                    print("[Auto Giant] Potion geante activee !")
                elseif (_G.RagdollBypass or Settings.ragdollBypassEnabled) then
                    task.spawn(function()
                        fireCommandViaTextBox("ragdoll", LocalPlayer)
                    end)
                end
            elseif (_G.RagdollBypass or Settings.ragdollBypassEnabled) and not giantActivated then
                task.spawn(function()
                    fireCommandViaTextBox("ragdoll", LocalPlayer)
                end)
            end

            -- Re-equipe le flash puis Activate + block timings
            flash = findTool("flash")
            if flash then
                hum:EquipTool(flash)
                task.wait(0.08)
                flash:Activate()
                pcall(startFlashLagger)

                if delayMode == "fast" then
                    doAutoBlock()
                elseif delayMode == "normal" then
                    task.spawn(function()
                        task.wait(0.5)
                        doAutoBlock()
                    end)
                elseif delayMode == "slow" then
                    task.spawn(function()
                        task.wait(1.0)
                        doAutoBlock()
                    end)
                end
            else
                -- Pas de flash: block quand meme selon mode
                if delayMode == "fast" then
                    doAutoBlock()
                elseif delayMode == "normal" then
                    task.spawn(function() task.wait(0.5); doAutoBlock() end)
                elseif delayMode == "slow" then
                    task.spawn(function() task.wait(1.0); doAutoBlock() end)
                end
            end

            task.wait(0.1)
            Camera.CameraType = Enum.CameraType.Custom

            task.spawn(function() task.wait(1.0); autoStealEnabled = false end)
            return
        end

        Velocity.VectorVelocity = Vector3.new(dir.Unit.X * Speed * speedMult, 0, dir.Unit.Z * Speed * speedMult)
    end)
    table.insert(ActiveConnections, currentMovement)
end

-- Auto Flash TP apres reset on balloon (robuste)
local function ensureSelectedBrainrot()
    if selectedPrompt and selectedPrompt.Parent and selectedSlotNumber then
        return true
    end
    selectedPrompt = nil
    selectedSlotNumber = nil
    local plotsFolder = Svc.Workspace:FindFirstChild("Plots")
    if not plotsFolder then return false end
    local bestPrompt, bestSlot, bestDist = nil, nil, math.huge
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, podium in ipairs(pods:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local d = 0
                                if root and spawnPoint then
                                    d = (spawnPoint.Position - root.Position).Magnitude
                                end
                                if d < bestDist then
                                    bestDist = d
                                    bestPrompt = child
                                    bestSlot = slotNumber
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if bestPrompt then
        selectedPrompt = bestPrompt
        selectedSlotNumber = bestSlot
        if Settings.slotEspEnabled then pcall(function() createSlotMarker(selectedPrompt) end) end
        return true
    end
    return false
end

local function tryAutoFlashTP(reason)
    if not Settings.autoFlashTPEnabled then
        RS.pendingAutoFlash = false
        return
    end
    if RS.autoFlashRunning then return end
    RS.autoFlashRunning = true
    task.spawn(function()
        print("[Auto Flash TP] Attente nouveau personnage... (" .. tostring(reason) .. ")")
        local deadline = tick() + 10
        local char, hum, root
        while tick() < deadline do
            if thisScriptStopped then return end
            char = LocalPlayer.Character
            hum = char and char:FindFirstChildOfClass("Humanoid")
            root = char and char:FindFirstChild("HumanoidRootPart")
            if char and hum and root and hum.Health > 0 and LocalPlayer:GetAttribute("Balloon") ~= true then
                break
            end
            task.wait(0.1)
        end
        char = LocalPlayer.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        root = char and char:FindFirstChild("HumanoidRootPart")
        if not (char and hum and root and hum.Health > 0) then
            print("[Auto Flash TP] Echec: personnage non pret")
            RS.pendingAutoFlash = false
            RS.autoFlashRunning = false
            return
        end

        -- Liberer les flags qui bloquaient le flash
        isStealing = false
        autoStealEnabled = false
        if currentMovement then
            pcall(function() currentMovement:Disconnect() end)
            currentMovement = nil
        end

        task.wait(0.4)

        if not ensureSelectedBrainrot() then
            print("[Auto Flash TP] Aucun brainrot disponible")
            RS.pendingAutoFlash = false
            RS.autoFlashRunning = false
            return
        end

        RS.pendingAutoFlash = false
        RS.autoFlashRunning = false
        print("[Auto Flash TP] GO -> slot " .. tostring(selectedSlotNumber))
        startTripToPetSlot(selectedPrompt, selectedSlotNumber)
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if not RS.pendingAutoFlash then return end
    if not Settings.autoFlashTPEnabled then
        RS.pendingAutoFlash = false
        return
    end
    tryAutoFlashTP("CharacterAdded")
end)

-- ==========================================
-- AUTO RESET TRIGGERS
-- ==========================================

local function setupResetTriggers()
    local balloonConnection = LocalPlayer:GetAttributeChangedSignal("Balloon"):Connect(function()
        if thisScriptStopped then return end
        if _G.AutoResetOnBalloon and LocalPlayer:GetAttribute("Balloon") == true then
            if Settings.autoFlashTPEnabled then
                RS.pendingAutoFlash = true
                -- Lance aussi un watcher (si CharacterAdded rate)
                tryAutoFlashTP("Balloon")
            end
            ResetPlayer()
        end
    end)
    table.insert(ActiveConnections, balloonConnection)

    for _, obj in ipairs(Svc.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local conn
            conn = obj.OnClientEvent:Connect(function(...)
                if thisScriptStopped then pcall(function() conn:Disconnect() end); return end
                for _, arg in ipairs({...}) do
                    if type(arg) == "string" then
                        local lower = string.lower(arg)
                        if string.find(lower, "jump higher") then
                            if _G.AutoResetOnBalloon then
                                if Settings.autoFlashTPEnabled then
                                    RS.pendingAutoFlash = true
                                    tryAutoFlashTP("JumpHigher")
                                end
                                ResetPlayer()
                            end
                        elseif string.find(lower, "jail") and (string.find(lower, string.lower(LocalPlayer.Name)) or string.find(lower, string.lower(LocalPlayer.DisplayName))) then
                            if Settings.autoResetOnJail then ResetPlayer() end
                        elseif string.find(lower, "tiny") and (string.find(lower, string.lower(LocalPlayer.Name)) or string.find(lower, string.lower(LocalPlayer.DisplayName))) then
                            if Settings.autoResetOnTiny then ResetPlayer() end
                        end
                    end
                end
            end)
            table.insert(ActiveConnections, conn)
        end
    end
end

setupResetTriggers()

-- ==========================================
-- AUTO BALLOON
-- ==========================================

local MultiZones = {
    {Shape='Line',   Center=Vector3.new(-345.35,-6.55,39.19), Size=5,  Rotation=0},
    {Shape='Line',   Center=Vector3.new(-350.53,-6.55,38.67), Size=20, Rotation=0},
    {Shape='Line',   Center=Vector3.new(-364.01,-6.55,38.94), Size=20, Rotation=0},
    {Shape='Line',   Center=Vector3.new(-337.34,-6.55,39.18), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-365.29,-6.95,-10.40), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-354.68,-6.95,6.22),  Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-343.15,-6.53,-13.20), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-344.93,-6.95,25.73), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-343.76,-6.95,-10.27), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-354.42,-6.95,6.51), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-340.48,-5.32,28.10), Size=20, Rotation=0},
    {Shape='Square', Center=Vector3.new(-361.10,-6.95,29.42), Size=20, Rotation=0},
    {Shape='Line',   Center=Vector3.new(-354.83,27.19,31.22), Size=20, Rotation=0},
}

local function isInAnyZone(position)
    for _, zone in ipairs(MultiZones) do
        local half = zone.Size / 2
        local dx = math.abs(position.X - zone.Center.X)
        local dz = math.abs(position.Z - zone.Center.Z)
        if zone.Shape == 'Line' then
            if dx <= half and dz <= 1.5 then return true end
        elseif zone.Shape == 'Square' then
            if dx <= half and dz <= half then return true end
        end
    end
    return false
end

local function getAdminTextBox()
    local AdminGui = PlayerGui:FindFirstChild("AdminPanel")
    if not AdminGui then return nil end
    local panel = AdminGui:FindFirstChild("AdminPanel")
    if not panel then return nil end
    local commandBox = panel:FindFirstChild("CommandBox")
    if not commandBox then return nil end
    return commandBox:FindFirstChild("TextBox")
end

local function triggerBalloonOnTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Parent then return end
    local TextBox = getAdminTextBox()
    if not TextBox then return end

    local fullCmd = ";balloon " .. targetPlayer.Name
    local originalVisible = TextBox.Visible
    TextBox.Visible = false
    TextBox.Text = fullCmd
    task.wait(0.05)

    local executed = false
    if getconnections then
        pcall(function()
            for _, conn in pairs(getconnections(TextBox.FocusLost)) do conn:Fire(true) end
            executed = true
        end)
    end
    if not executed then
        pcall(function()
            if getconnections then
                for _, conn in pairs(getconnections(TextBox.KeyDown)) do conn:Fire(Enum.KeyCode.Return) end
            end
            executed = true
        end)
    end

    task.wait(0.05)
    TextBox.Text = ""
    TextBox.Visible = originalVisible
end

local BL = { active = {}, cooldown = 3 }

local function autoBalloonHeartbeat()
    local now = tick()

    if Settings.autoBalloonEnabled then
    for _, p in pairs(Svc.Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local uid = p.UserId
        local isStealing = p:GetAttribute("StealingPlayer") == true
        if not isStealing then BL.active[uid] = nil; continue end

        local character = p.Character
        if not character then continue end
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if not rootPart then continue end

        if not isInAnyZone(rootPart.Position) then
            BL.active[uid] = nil
            continue
        end

        if BL.active[uid] then continue end
        if now - (BL.active[uid] or 0) < BL.cooldown then continue end

        BL.active[uid] = now
        task.spawn(function() triggerBalloonOnTarget(p) end)
    end
    end

end

local autoBalloonHeartbeatConn = Svc.RunService.Heartbeat:Connect(autoBalloonHeartbeat)
table.insert(ActiveConnections, autoBalloonHeartbeatConn)

-- ==========================================
-- UPDATE PET LIST
-- ==========================================

local scrollListRef = nil
local lastPetsSignature = ""

local function updatePetList()
    if isStealing or autoStealEnabled or thisScriptStopped then return end
    if not scrollListRef then return end

    local plotsFolder = Svc.Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end

    local tempPets = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local petName = child.ObjectText or "Pet"
                                table.insert(tempPets, { prompt = child, slot = slotNumber, name = petName })
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(tempPets, function(a, b) return a.slot < b.slot end)

    if Settings.autoSelectBest and #tempPets > 0 and not selectedPrompt then
        selectedPrompt = tempPets[1].prompt
        selectedSlotNumber = tempPets[1].slot
        if Settings.slotEspEnabled then createSlotMarker(selectedPrompt) end
        if Settings.tpPathVisual then showTpPathVisual(selectedPrompt, selectedSlotNumber) end
    end

    for _, child in ipairs(scrollListRef:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for _, petData in ipairs(tempPets) do
        if thisScriptStopped then break end
        local isSelected = (selectedPrompt == petData.prompt)

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 40)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(20, 55, 95) or Color3.fromRGB(12, 25, 42)
        row.BorderSizePixel = 0
        row.Parent = scrollListRef
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local rowStroke = Instance.new("UIStroke")
        rowStroke.Color = isSelected and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(0, 0, 0)
        rowStroke.Thickness = isSelected and 1.6 or 1.2
        rowStroke.Parent = row
        if isSelected then
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 3, 1, -8)
            bar.Position = UDim2.new(0, 0, 0, 4)
            bar.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            bar.BorderSizePixel = 0
            bar.Parent = row
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
        end

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = petData.name
        nameLabel.Size = UDim2.new(1, -10, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, -4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row

        local slotLabel = Instance.new("TextLabel")
        slotLabel.Text = "slot " .. petData.slot
        slotLabel.Size = UDim2.new(1, -12, 1, 0)
        slotLabel.Position = UDim2.new(0, 0, 0, 6)
        slotLabel.BackgroundTransparency = 1
        slotLabel.TextColor3 = isSelected and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(145, 190, 235)
        slotLabel.Font = Enum.Font.GothamMedium
        slotLabel.TextSize = 11
        slotLabel.TextXAlignment = Enum.TextXAlignment.Right
        slotLabel.Parent = row

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.BorderSizePixel = 0
        clickBtn.Parent = row

        clickBtn.MouseButton1Click:Connect(function()
            if not isStealing and not autoStealEnabled then
                selectedPrompt = petData.prompt
                selectedSlotNumber = petData.slot
                if Settings.slotEspEnabled then createSlotMarker(petData.prompt) end
                if Settings.tpPathVisual then showTpPathVisual(petData.prompt, petData.slot) end
                updatePetList()
            end
        end)
    end
end


-- ==========================================
-- QUICK PANEL (SHARKYpvp Quick Panel)
-- ==========================================
_G.SHARKYQuickPanel = (function()
    local M = { enabled = false, gui = nil }

    local function build()
        if M.gui and M.gui.Parent then return end
        pcall(function()
            local old = PlayerGui:FindFirstChild("SHARKYQuickPanel")
            if old then old:Destroy() end
        end)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SHARKYQuickPanel"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Enabled = false
        screenGui.Parent = PlayerGui
        M.gui = screenGui

        local function makeDraggable(dragArea, frameToMove)
            local dragging, dragInput, dragStart, startPos
            dragArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = frameToMove.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            dragArea.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            Svc.UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    frameToMove.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 390, 0, 75)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.Position = UDim2.new(0.5, 0, 0.35, 0)
        mainFrame.BackgroundColor3 = Color3.fromRGB(6, 14, 25)
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = false
        mainFrame.Parent = screenGui
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
        local mfStroke = Instance.new("UIStroke")
        mfStroke.Color = Color3.fromRGB(0, 0, 0)
        mfStroke.Thickness = 2
        mfStroke.Parent = mainFrame

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 38)
        header.BackgroundColor3 = Color3.fromRGB(10, 22, 38)
        header.BorderSizePixel = 0
        header.ZIndex = 2
        header.Parent = mainFrame
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)
        local headerStroke = Instance.new("UIStroke")
        headerStroke.Color = Color3.fromRGB(0, 0, 0)
        headerStroke.Thickness = 1.2
        headerStroke.Parent = header
        local headerAccent = Instance.new("Frame")
        headerAccent.Size = UDim2.new(1, 0, 0, 2)
        headerAccent.Position = UDim2.new(0, 0, 1, -2)
        headerAccent.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        headerAccent.BorderSizePixel = 0
        headerAccent.ZIndex = 3
        headerAccent.Parent = header

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 0, 18)
        titleLabel.Position = UDim2.new(0, 12, 0, 4)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "SHARKYpvp Quick Panel"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 12
        titleLabel.TextColor3 = Color3.fromRGB(50, 150, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 3
        titleLabel.Parent = header

        local subTitleLabel = Instance.new("TextLabel")
        subTitleLabel.Size = UDim2.new(1, -16, 0, 12)
        subTitleLabel.Position = UDim2.new(0, 12, 0, 20)
        subTitleLabel.BackgroundTransparency = 1
        subTitleLabel.Text = "admin commands"
        subTitleLabel.Font = Enum.Font.GothamMedium
        subTitleLabel.TextSize = 9
        subTitleLabel.TextColor3 = Color3.fromRGB(145, 190, 235)
        subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subTitleLabel.ZIndex = 3
        subTitleLabel.Parent = header

        makeDraggable(header, mainFrame)

        local playerContainer = Instance.new("Frame")
        playerContainer.Size = UDim2.new(1, -16, 1, -50)
        playerContainer.Position = UDim2.new(0, 8, 0, 44)
        playerContainer.BackgroundTransparency = 1
        playerContainer.BorderSizePixel = 0
        playerContainer.Parent = mainFrame

        local playerLayout = Instance.new("UIListLayout")
        playerLayout.Padding = UDim.new(0, 4)
        playerLayout.SortOrder = Enum.SortOrder.Name
        playerLayout.Parent = playerContainer

        local COMMANDS = {
            {name = "tiny",    emoji = "🤏"},
            {name = "jail",    emoji = "🔒"},
            {name = "rocket",  emoji = "🚀"},
            {name = "ragdoll", emoji = "🤸"},
            {name = "balloon", emoji = "🎈"},
        }

        local function findAdminPanel()
            return PlayerGui:FindFirstChild("AdminPanel")
        end

        local function findPlayerButton(targetPlayer)
            local adminPanel = findAdminPanel()
            if not adminPanel then return nil end
            local tName = targetPlayer.Name
            local tDisplay = targetPlayer.DisplayName
            for _, desc in pairs(adminPanel:GetDescendants()) do
                if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                    local t = ""
                    if desc:IsA("TextButton") then
                        t = desc.Text
                    else
                        local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
                        if lbl then t = lbl.Text end
                    end
                    if t == tDisplay or t:find(tDisplay) or t == tName or t:find(tName) then
                        return desc
                    end
                end
            end
            return nil
        end

        local function getCommandButtons()
            local btns = {}
            local adminPanel = findAdminPanel()
            if not adminPanel then return btns end
            for _, desc in pairs(adminPanel:GetDescendants()) do
                if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                    local t = ""
                    if desc:IsA("TextButton") then
                        t = desc.Text
                    else
                        local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
                        if lbl then t = lbl.Text end
                    end
                    if t and t ~= "" and (t:match("^:") or t:match("^;")) then
                        table.insert(btns, {button = desc, name = t})
                    end
                end
            end
            return btns
        end

        local function clickButton(button)
            pcall(function()
                if getconnections then
                    for _, cx in pairs(getconnections(button.MouseButton1Click)) do cx:Fire() end
                    for _, cx in pairs(getconnections(button.Activated)) do cx:Fire() end
                end
            end)
        end

        local function isExactCommand(buttonName, expectedCmdName)
            local bName = string.lower(string.match(buttonName, "^%s*(.-)%s*$") or buttonName)
            local cmdName = string.lower(expectedCmdName)
            if bName == cmdName or bName == ":"..cmdName or bName == ";"..cmdName then return true end
            if string.match(bName, "^[:;]?"..cmdName.."$") or string.match(bName, "^[:;]?"..cmdName.."%s") then return true end
            return false
        end

        local function executeCommand(targetPlayer, cmdName)
            task.spawn(function()
                if findAdminPanel() then
                    local cmdFound = false
                    for _, cBtn in ipairs(getCommandButtons()) do
                        if isExactCommand(cBtn.name, cmdName) then
                            clickButton(cBtn.button)
                            cmdFound = true
                            break
                        end
                    end
                    task.wait(0.05)
                    if cmdFound then
                        local pBtn = findPlayerButton(targetPlayer)
                        if pBtn then clickButton(pBtn) end
                    end
                end
            end)
        end

        local function updatePlayerList()
            if not M.enabled or not playerContainer.Parent then return end
            for _, child in pairs(playerContainer:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end

            for _, p in pairs(Svc.Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local row = Instance.new("Frame")
                    row.Name = p.Name
                    row.Size = UDim2.new(1, 0, 0, 32)
                    row.BackgroundColor3 = Color3.fromRGB(12, 27, 45)
                    row.BorderSizePixel = 0
                    row.Parent = playerContainer
                    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
                    local rowS = Instance.new("UIStroke")
                    rowS.Color = Color3.fromRGB(0, 0, 0)
                    rowS.Thickness = 1
                    rowS.Parent = row

                    local avatarImage = Instance.new("ImageLabel")
                    avatarImage.Size = UDim2.new(0, 24, 0, 24)
                    avatarImage.Position = UDim2.new(0, 6, 0.5, -12)
                    avatarImage.BackgroundTransparency = 1
                    avatarImage.BorderSizePixel = 0
                    avatarImage.Parent = row
                    Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

                    task.spawn(function()
                        local ok, content = pcall(function()
                            local img = Svc.Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                            return img
                        end)
                        if ok and type(content) == "string" and content ~= "" and avatarImage and avatarImage.Parent then
                            avatarImage.Image = content
                        end
                    end)

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(0, 175, 1, 0)
                    nameLabel.Position = UDim2.new(0, 36, 0, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextSize = 10
                    nameLabel.TextColor3 = Color3.fromRGB(245, 240, 240)
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    nameLabel.Parent = row

                    local actionsGrid = Instance.new("Frame")
                    actionsGrid.Size = UDim2.new(0, 170, 1, 0)
                    actionsGrid.Position = UDim2.new(1, -172, 0, 0)
                    actionsGrid.BackgroundTransparency = 1
                    actionsGrid.Parent = row

                    local gridLayout = Instance.new("UIListLayout")
                    gridLayout.FillDirection = Enum.FillDirection.Horizontal
                    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    gridLayout.Padding = UDim.new(0, 3)
                    gridLayout.Parent = actionsGrid

                    for _, cmd in ipairs(COMMANDS) do
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(0, 28, 0, 26)
                        btn.BackgroundColor3 = Color3.fromRGB(15, 35, 60)
                        btn.BorderSizePixel = 0
                        btn.Text = cmd.emoji
                        btn.Font = Enum.Font.Gotham
                        btn.TextSize = 12
                        btn.Parent = actionsGrid
                        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

                        btn.MouseButton1Click:Connect(function()
                            executeCommand(p, cmd.name)
                        end)
                        btn.MouseEnter:Connect(function()
                            btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                        end)
                        btn.MouseLeave:Connect(function()
                            btn.BackgroundColor3 = Color3.fromRGB(15, 35, 60)
                        end)
                    end
                end
            end

            task.wait(0.02)
            local totalContentHeight = playerLayout.AbsoluteContentSize.Y
            mainFrame.Size = UDim2.new(0, 390, 0, math.max(75, totalContentHeight + 52))
        end

        M._update = updatePlayerList
        M._conns = {}
        table.insert(M._conns, Svc.Players.PlayerAdded:Connect(function()
            if M.enabled then updatePlayerList() end
        end))
        table.insert(M._conns, Svc.Players.PlayerRemoving:Connect(function()
            if M.enabled then updatePlayerList() end
        end))
    end

    function M.set(on)
        on = on and true or false
        M.enabled = on
        if on then
            build()
            if M.gui then M.gui.Enabled = true end
            if M._update then task.defer(M._update) end
        else
            if M.gui then M.gui.Enabled = false end
        end
        pcall(function()
            if Config and Config.set then
                -- no Config table with set in this script style
            end
        end)
        pcall(saveSettings)
    end

    function M.isEnabled()
        return M.enabled
    end

    table.insert(ActiveConnections, {
        Disconnect = function()
            pcall(function()
                if M.gui then M.gui:Destroy() end
                M.gui = nil
                M.enabled = false
            end)
        end
    })

    return M
end)()


-- ==========================================
-- GUI - SHARKYPVP
-- ==========================================

local old = PlayerGui:FindFirstChild("SHARKYPVP")
if old then old:Destroy() end

local C = {
    accent = Color3.fromRGB(50, 150, 255),
    accentHi = Color3.fromRGB(50, 150, 255),
    deepBlue = Color3.fromRGB(8, 18, 32),
    body = Color3.fromRGB(10, 20, 34),
    panel = Color3.fromRGB(13, 28, 48),
    tabBar = Color3.fromRGB(10, 22, 38),
    card = Color3.fromRGB(12, 25, 42),
    iconBg = Color3.fromRGB(18, 38, 65),
    stroke = Color3.fromRGB(0, 0, 0),
    textBright = Color3.fromRGB(245, 240, 240),
    textBlue = Color3.fromRGB(50, 150, 255),
    textMute = Color3.fromRGB(145, 190, 235),
    textDim = Color3.fromRGB(100, 150, 200),
    knobOn = Color3.fromRGB(255, 240, 240),
    knobOff = Color3.fromRGB(35, 60, 85),
    trackOff = Color3.fromRGB(20, 38, 58),
}

local borderGradientSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 105, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255)),
})

local function getDevice()
    local screen = Camera.ViewportSize
    local w, h = screen.X, screen.Y
    local isMobile = Svc.UserInputService.TouchEnabled and not Svc.UserInputService.KeyboardEnabled
    if isMobile then
        if w >= 900 or h >= 900 then return "ipad" end
        return "mobile"
    end
    return "pc"
end

local DEVICE = getDevice()

local LAYOUT = {
    pc = { winW = 310, winH = 420, posX = UDim2.new(0.5, 0, 0.5, 0), btnSize = 94, btnH = 40, tabH = 32, headerH = 47, actionXs = {8, 108, 208}, textSize = { header = 11, btn = 12, tab = 12 } },
    ipad = { winW = 280, winH = 390, posX = UDim2.new(0.5, 0, 0.5, 0), btnSize = 83, btnH = 38, tabH = 30, headerH = 45, actionXs = {7, 96, 185}, textSize = { header = 11, btn = 11, tab = 11 } },
    mobile = { winW = 240, winH = 330, posX = UDim2.new(0.5, 0, 0.5, 0), btnSize = 70, btnH = 36, tabH = 28, headerH = 42, actionXs = {6, 82, 158}, textSize = { header = 10, btn = 10, tab = 10 } },
}

local L = LAYOUT[DEVICE]

local SHARKYPVP_GUI = Instance.new("ScreenGui")
SHARKYPVP_GUI.Name = "SHARKYPVP"
SHARKYPVP_GUI.ResetOnSpawn = false
SHARKYPVP_GUI.DisplayOrder = 999
SHARKYPVP_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SHARKYPVP_GUI.Parent = PlayerGui

local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.Size = UDim2.new(0, L.winW+4, 0, L.winH+4)
BorderFrame.Position = L.posX
BorderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BorderFrame.BackgroundColor3 = C.accent
BorderFrame.BorderSizePixel = 0
BorderFrame.Parent = SHARKYPVP_GUI
local BorderCorner = Instance.new("UICorner")
BorderCorner.CornerRadius = UDim.new(0, 13)
BorderCorner.Parent = BorderFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = borderGradientSeq
UIGradient.Rotation = 308.077
UIGradient.Parent = BorderFrame

local Win = Instance.new("Frame")
Win.Name = "Win"
Win.Size = UDim2.new(0, L.winW, 0, L.winH)
Win.Position = L.posX
Win.AnchorPoint = Vector2.new(0.5, 0.5)
Win.BackgroundTransparency = 1
Win.BorderSizePixel = 0
Win.ZIndex = 2
Win.Parent = SHARKYPVP_GUI

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = C.body
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = Win
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 13)

local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(1, 0, 1, -94)
Frame2.Position = UDim2.new(0, 0, 0, 90)
Frame2.BackgroundColor3 = C.panel
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 13)

local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, 0, 0, L.headerH)
Frame3.Position = UDim2.new(0, 0, 0, -8)
Frame3.BackgroundTransparency = 1
Frame3.BorderSizePixel = 0
Frame3.ZIndex = 3
Frame3.Parent = Frame

local Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, 0, 0, 1)
Frame4.Position = UDim2.new(0, 0, 1, -1)
Frame4.BackgroundColor3 = C.accent
Frame4.BorderSizePixel = 0
Frame4.ZIndex = 4
Frame4.Parent = Frame3

local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(0, 6, 0, 6)
Frame5.Position = UDim2.new(0, 10, 0.5, -3)
Frame5.BackgroundColor3 = C.accent
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 5
Frame5.Parent = Frame3
Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 4)

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 120, 1, 0)
TextLabel.Position = UDim2.new(0, 24, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.ZIndex = 5
TextLabel.Text = "SHARKYPVP"
TextLabel.TextColor3 = C.textBright
TextLabel.TextSize = 11
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame3


local HB = DEVICE == "mobile" and 20 or 22
local function headerButton(name, txt, xOff)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(0, HB, 0, HB)
    b.Position = UDim2.new(1, xOff, 0.5, -HB/2)
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.ZIndex = 6
    b.Text = txt
    b.TextColor3 = C.textMute
    b.TextSize = L.textSize.header
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = Frame3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0); s.Parent = b
    return b
end

local hbOff = DEVICE == "mobile" and {-64, -42, -20} or {-70, -46, -22}
local LockBtn = headerButton("Lock", "🔓 ", hbOff[1])
local MinBtn = headerButton("Min", "–", hbOff[2])
local CloseBtn = headerButton("Close", "X", hbOff[3])

local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(1, 0, 0, 69)
Frame7.Position = UDim2.new(0, 0, 0, 34)
Frame7.BackgroundTransparency = 1
Frame7.BorderSizePixel = 0
Frame7.ZIndex = 4
Frame7.Parent = Frame

local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(1, 0, 0, 1)
Frame8.Position = UDim2.new(0, 0, 0, 55)
Frame8.BackgroundColor3 = C.accent
Frame8.BorderSizePixel = 0
Frame8.ZIndex = 4
Frame8.Parent = Frame7

local function actionButton(name, label, xPos, bW)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, bW, 0, L.btnH)
    btn.Position = UDim2.new(0, xPos, 0, 8)
    btn.BackgroundColor3 = C.card
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Frame7
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0); s.Parent = btn
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, -10, 0, 2)
    top.Position = UDim2.new(0, 5, 0, 0)
    top.BackgroundColor3 = C.accent
    top.BorderSizePixel = 0
    top.ZIndex = 6
    top.Parent = btn
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 1)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 7
    lbl.Text = label
    lbl.TextColor3 = C.textBright
    lbl.TextSize = L.textSize.btn
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = btn
    return btn, top
end

local FLASHTP, flashAccent = actionButton("FLASH TP", "FLASH [" .. getDisplayName(keyNames.flash) .. "]", L.actionXs[1], L.btnSize)
local BLOCK, blockAccent = actionButton("BLOCK", "BLOCK [" .. getDisplayName(keyNames.block) .. "]", L.actionXs[2], L.btnSize)
local RESET, resetAccent = actionButton("RESET", "RESET [" .. getDisplayName(keyNames.reset) .. "]", L.actionXs[3], L.btnSize)

local Frame12 = Instance.new("Frame")
Frame12.Size = UDim2.new(1, 0, 0, L.tabH)
Frame12.Position = UDim2.new(0, 0, 0, 90)
Frame12.BackgroundColor3 = C.tabBar
Frame12.BorderSizePixel = 0
Frame12.ZIndex = 5
Frame12.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = Frame12

local TextButton4 = Instance.new("TextButton")
TextButton4.Size = UDim2.new(0.5, 0, 1, 0)
TextButton4.BackgroundColor3 = C.tabBar
TextButton4.BorderSizePixel = 0
TextButton4.ZIndex = 5
TextButton4.LayoutOrder = 1
TextButton4.Text = ""
TextButton4.AutoButtonColor = false
TextButton4.Parent = Frame12

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.Size = UDim2.new(1, 0, 1, 0)
TextLabel7.BackgroundTransparency = 1
TextLabel7.ZIndex = 6
TextLabel7.Text = "Brainrots"
TextLabel7.TextColor3 = C.textBlue
TextLabel7.TextSize = L.textSize.tab
TextLabel7.Font = Enum.Font.GothamMedium
TextLabel7.Parent = TextButton4

local Frame13 = Instance.new("Frame")
Frame13.Size = UDim2.new(1, -16, 0, 2)
Frame13.Position = UDim2.new(0, 8, 1, -2)
Frame13.BackgroundColor3 = C.accent
Frame13.BorderSizePixel = 0
Frame13.ZIndex = 7
Frame13.Parent = TextButton4
Instance.new("UICorner", Frame13).CornerRadius = UDim.new(0, 1)

local TextButton5 = Instance.new("TextButton")
TextButton5.Size = UDim2.new(0.5, 0, 1, 0)
TextButton5.BackgroundColor3 = C.tabBar
TextButton5.BorderSizePixel = 0
TextButton5.ZIndex = 5
TextButton5.LayoutOrder = 2
TextButton5.Text = ""
TextButton5.AutoButtonColor = false
TextButton5.Parent = Frame12

local TextLabel8 = Instance.new("TextLabel")
TextLabel8.Size = UDim2.new(1, 0, 1, 0)
TextLabel8.BackgroundTransparency = 1
TextLabel8.ZIndex = 6
TextLabel8.Text = "Settings"
TextLabel8.TextColor3 = C.textDim
TextLabel8.TextSize = L.textSize.tab
TextLabel8.Font = Enum.Font.GothamMedium
TextLabel8.Parent = TextButton5

local Frame14 = Instance.new("Frame")
Frame14.Size = UDim2.new(1, -16, 0, 2)
Frame14.Position = UDim2.new(0, 8, 1, -2)
Frame14.BackgroundColor3 = C.accent
Frame14.BackgroundTransparency = 1
Frame14.BorderSizePixel = 0
Frame14.ZIndex = 7
Frame14.Parent = TextButton5
Instance.new("UICorner", Frame14).CornerRadius = UDim.new(0, 1)

local Frame15 = Instance.new("Frame")
Frame15.Size = UDim2.new(1, 0, 0, 1)
Frame15.Position = UDim2.new(0, 0, 0, 121)
Frame15.BackgroundColor3 = C.accent
Frame15.BorderSizePixel = 0
Frame15.ZIndex = 6
Frame15.Parent = Frame

local Frame16 = Instance.new("Frame")
Frame16.Size = UDim2.new(1, 0, 1, -126)
Frame16.Position = UDim2.new(0, 0, 0, 122)
Frame16.BackgroundTransparency = 1
Frame16.BorderSizePixel = 0
Frame16.ZIndex = 2
Frame16.ClipsDescendants = true
Frame16.Parent = Frame

local Frame17 = Instance.new("Frame")
Frame17.Name = "Frame"
Frame17.Size = UDim2.new(1, 0, 1, 0)
Frame17.BackgroundTransparency = 1
Frame17.BorderSizePixel = 0
Frame17.ZIndex = 3
Frame17.Parent = Frame16

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Active = false
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = Frame17

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout2.Padding = UDim.new(0, 4)
UIListLayout2.Parent = ScrollingFrame

local UIPaddingList = Instance.new("UIPadding")
UIPaddingList.PaddingTop = UDim.new(0, 6)
UIPaddingList.PaddingBottom = UDim.new(0, 6)
UIPaddingList.PaddingLeft = UDim.new(0, 4)
UIPaddingList.PaddingRight = UDim.new(0, 4)
UIPaddingList.Parent = ScrollingFrame

scrollListRef = ScrollingFrame

local Frame21 = Instance.new("Frame")
Frame21.Name = "Frame"
Frame21.Size = UDim2.new(1, 0, 1, 0)
Frame21.Position = UDim2.new(1, 0, 0, 0)
Frame21.BackgroundTransparency = 1
Frame21.Visible = false
Frame21.ZIndex = 3
Frame21.Parent = Frame16

local ScrollingFrame2 = Instance.new("ScrollingFrame")
ScrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame2.BackgroundTransparency = 1
ScrollingFrame2.BorderSizePixel = 0
ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame2.ScrollBarThickness = 3
ScrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame2.Parent = Frame21

local UIListLayout3 = Instance.new("UIListLayout")
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout3.Padding = UDim.new(0, 4)
UIListLayout3.Parent = ScrollingFrame2

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.Parent = ScrollingFrame2

-- ==========================================
-- SETTINGS TOGGLES
-- ==========================================

local sectionOrder = 0

local function sectionHeader(text)
    sectionOrder = sectionOrder + 1
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 24)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.ZIndex = 4
    wrap.LayoutOrder = sectionOrder
    wrap.Parent = ScrollingFrame2

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = C.accent
    line.BorderSizePixel = 0
    line.ZIndex = 5
    line.Parent = wrap

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 0, 1, 0)
    pill.Position = UDim2.new(0.5, 0, 0, 0)
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.BackgroundColor3 = C.panel
    pill.BorderSizePixel = 0
    pill.ZIndex = 6
    pill.AutomaticSize = Enum.AutomaticSize.X
    pill.Parent = wrap

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 7
    lbl.Text = text
    lbl.TextColor3 = C.textMute
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = pill
end

local function toggleRow(title, desc, defaultOn, onToggle)
    sectionOrder = sectionOrder + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    row.ZIndex = 4
    row.LayoutOrder = sectionOrder
    row.Parent = ScrollingFrame2
    Instance.new("UICorner", row)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0); s.Parent = row

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -10)
    accentBar.Position = UDim2.new(0, 0, 0, 5)
    accentBar.BackgroundColor3 = C.accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 5
    accentBar.Parent = row
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -52, 0, 24)
    t1.Position = UDim2.new(0, 12, 0, 0)
    t1.BackgroundTransparency = 1
    t1.ZIndex = 5
    t1.Text = title
    t1.TextColor3 = C.textBright
    t1.TextSize = 13
    t1.Font = Enum.Font.GothamMedium
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = row

    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -52, 0, 20)
    t2.Position = UDim2.new(0, 12, 0, 22)
    t2.BackgroundTransparency = 1
    t2.ZIndex = 5
    t2.Text = desc
    t2.TextColor3 = C.textMute
    t2.TextSize = 11
    t2.Font = Enum.Font.Gotham
    t2.TextWrapped = true
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 20)
    track.Position = UDim2.new(1, -42, 0.5, -10)
    track.BackgroundColor3 = C.accent
    track.BorderSizePixel = 0
    track.ZIndex = 6
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 10)
    local ts = Instance.new("UIStroke"); ts.Color = Color3.fromRGB(0, 0, 0); ts.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 19, 0.5, -7)
    knob.BackgroundColor3 = C.knobOn
    knob.BorderSizePixel = 0
    knob.ZIndex = 7
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.ZIndex = 8
    hit.Text = ""
    hit.Parent = row

    local ref = { on = defaultOn ~= false }

    local function render(animate)
        local info = TweenInfo.new(animate and 0.16 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if ref.on then
            Svc.TweenService:Create(track, info, { BackgroundColor3 = C.accent }):Play()
            Svc.TweenService:Create(knob, info, { Position = UDim2.new(0, 19, 0.5, -7), BackgroundColor3 = C.knobOn }):Play()
        else
            Svc.TweenService:Create(track, info, { BackgroundColor3 = C.trackOff }):Play()
            Svc.TweenService:Create(knob, info, { Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = C.knobOff }):Play()
        end
    end

    render(false)
    if onToggle then task.defer(function() pcall(onToggle, ref.on) end) end

    hit.MouseButton1Click:Connect(function()
        ref.on = not ref.on
        render(true)
        if onToggle then pcall(onToggle, ref.on) end
        saveSettings()
    end)
end

sectionHeader(" AUTO RESET ")
toggleRow("Reset On Balloon", "Reset when you're ballooned", _G.AutoResetOnBalloon, function(v) _G.AutoResetOnBalloon = v end)
toggleRow("Reset On Jail", "Reset when you're jailed", Settings.autoResetOnJail, function(v) Settings.autoResetOnJail = v end)
toggleRow("Reset On Tiny", "Reset when you're tiny", Settings.autoResetOnTiny, function(v) Settings.autoResetOnTiny = v end)

sectionHeader(" FLASH TP ")

toggleRow("Auto Giant Potion", "Active la potion géante + ragdoll automatiquement (style Hugo)", _G.AutoGiant, function(v)
    _G.AutoGiant = v
    Settings.autoGiantEnabled = v
    saveSettings()
end)

toggleRow("Ragdoll Bypass", "Active le ragdoll automatique pendant le Flash TP (commande ;ragdoll)", _G.RagdollBypass, function(v)
    _G.RagdollBypass = v
    Settings.ragdollBypassEnabled = v
    saveSettings()
end)

toggleRow("Auto Flash TP", "Apres reset on balloon: Flash TP auto des que le perso se recree", Settings.autoFlashTPEnabled, function(v) Settings.autoFlashTPEnabled = v end)
toggleRow("Auto Block", "Auto block nearest player", _G.AutoBlock, function(v) _G.AutoBlock = v end)
toggleRow("Anti Swap", "Tiny + rocket le joueur le plus proche (Admin Panel)", Settings.antiSwapEnabled, function(v) Settings.antiSwapEnabled = v end)

sectionHeader(" MISC ")

toggleRow("Auto Balloon", "Auto balloon whoever steals you", Settings.autoBalloonEnabled, function(v)
    Settings.autoBalloonEnabled = v
    _G.AutoBalloon = v
    if not v then for uid in pairs(BL.active) do BL.active[uid] = nil end end
    saveSettings()
end)

toggleRow("Auto Grab", "Auto grab brainrots (s'active automatiquement si des brainrots sont détectés)", Settings.autoGrabEnabled, function(v)
    Settings.autoGrabEnabled = v
    if v then
        startBrainrotScanner()
        if scanForBrainrots() then
            hasBrainrotDetected = true
            startAutoGrab()
            if spFrame then spFrame.Visible = true end
        end
    else
        stopBrainrotScanner()
        stopAutoGrab()
        hasBrainrotDetected = false
        if spFrame then spFrame.Visible = false end
    end
    saveSettings()
end)

toggleRow("Anti Ragdoll", "Nexyra Unpatch - Empeche automatiquement le ragdoll", Settings.antiRagdollEnabled, function(v)
    Settings.antiRagdollEnabled = v
    if v then
        startAntiRagdoll()
        print("✅ Anti-Ragdoll ENABLED")
    else
        stopAntiRagdoll()
        print("❌ Anti-Ragdoll DISABLED")
    end
    saveSettings()
end)

toggleRow("Quick Panel", "SHARKYpvp Quick Panel (avatars + commandes)", false, function(v)
    if _G.SHARKYQuickPanel and _G.SHARKYQuickPanel.set then
        _G.SHARKYQuickPanel.set(v and true or false)
    end
end)

sectionHeader(" LAGGER ")

sectionOrder = sectionOrder + 1
local laggerToggleRow = Instance.new("Frame")
laggerToggleRow.Size = UDim2.new(1, 0, 0, 52)
laggerToggleRow.BackgroundColor3 = C.card
laggerToggleRow.BorderSizePixel = 0
laggerToggleRow.ZIndex = 4
laggerToggleRow.LayoutOrder = sectionOrder
laggerToggleRow.Parent = ScrollingFrame2
Instance.new("UICorner", laggerToggleRow)
local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0); s.Parent = laggerToggleRow

local accentBarL = Instance.new("Frame")
accentBarL.Size = UDim2.new(0, 3, 1, -10)
accentBarL.Position = UDim2.new(0, 0, 0, 5)
accentBarL.BackgroundColor3 = C.accent
accentBarL.BorderSizePixel = 0
accentBarL.ZIndex = 5
accentBarL.Parent = laggerToggleRow
Instance.new("UICorner", accentBarL).CornerRadius = UDim.new(0, 2)

local t1L = Instance.new("TextLabel")
t1L.Size = UDim2.new(1, -52, 0, 24)
t1L.Position = UDim2.new(0, 12, 0, 0)
t1L.BackgroundTransparency = 1
t1L.ZIndex = 5
t1L.Text = "Lagger On Flash TP"
t1L.TextColor3 = C.textBright
t1L.TextSize = 13
t1L.Font = Enum.Font.GothamMedium
t1L.TextXAlignment = Enum.TextXAlignment.Left
t1L.Parent = laggerToggleRow

local t2L = Instance.new("TextLabel")
t2L.Size = UDim2.new(1, -52, 0, 20)
t2L.Position = UDim2.new(0, 12, 0, 22)
t2L.BackgroundTransparency = 1
t2L.ZIndex = 5
t2L.Text = "Active le lag quand tu utilises Flash TP"
t2L.TextColor3 = C.textMute
t2L.TextSize = 11
t2L.Font = Enum.Font.Gotham
t2L.TextWrapped = true
t2L.TextXAlignment = Enum.TextXAlignment.Left
t2L.Parent = laggerToggleRow

local trackL = Instance.new("Frame")
trackL.Size = UDim2.new(0, 36, 0, 20)
trackL.Position = UDim2.new(1, -42, 0.5, -10)
trackL.BackgroundColor3 = C.accent
trackL.BorderSizePixel = 0
trackL.ZIndex = 6
trackL.Parent = laggerToggleRow
Instance.new("UICorner", trackL).CornerRadius = UDim.new(0, 10)
local tsL = Instance.new("UIStroke"); tsL.Color = Color3.fromRGB(0, 0, 0); tsL.Parent = trackL

local knobL = Instance.new("Frame")
knobL.Size = UDim2.new(0, 14, 0, 14)
knobL.Position = UDim2.new(0, 19, 0.5, -7)
knobL.BackgroundColor3 = C.knobOn
knobL.BorderSizePixel = 0
knobL.ZIndex = 7
knobL.Parent = trackL
Instance.new("UICorner", knobL).CornerRadius = UDim.new(0, 7)

local hitL = Instance.new("TextButton")
hitL.Size = UDim2.new(1, 0, 1, 0)
hitL.BackgroundTransparency = 1
hitL.ZIndex = 8
hitL.Text = ""
hitL.Parent = laggerToggleRow

local laggerRef = { on = _G.LaggerOnFlash }

local function renderLaggerToggle(animate)
    local info = TweenInfo.new(animate and 0.16 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if laggerRef.on then
        Svc.TweenService:Create(trackL, info, { BackgroundColor3 = C.accent }):Play()
        Svc.TweenService:Create(knobL, info, { Position = UDim2.new(0, 19, 0.5, -7), BackgroundColor3 = C.knobOn }):Play()
    else
        Svc.TweenService:Create(trackL, info, { BackgroundColor3 = C.trackOff }):Play()
        Svc.TweenService:Create(knobL, info, { Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = C.knobOff }):Play()
    end
end

renderLaggerToggle(false)

hitL.MouseButton1Click:Connect(function()
    laggerRef.on = not laggerRef.on
    _G.LaggerOnFlash = laggerRef.on
    renderLaggerToggle(true)
    if not laggerRef.on then stopFlashLagger() end
    saveSettings()
end)

sectionOrder = sectionOrder + 1
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, 0, 0, 70)
inputContainer.BackgroundColor3 = C.card
inputContainer.BorderSizePixel = 0
inputContainer.ZIndex = 4
inputContainer.LayoutOrder = sectionOrder
inputContainer.Parent = ScrollingFrame2
Instance.new("UICorner", inputContainer)
local sInput = Instance.new("UIStroke"); sInput.Color = Color3.fromRGB(0, 0, 0); sInput.Parent = inputContainer

local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, -60, 0, 20)
inputLabel.Position = UDim2.new(0, 12, 0, 6)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Lagger Power"
inputLabel.TextColor3 = C.textBright
inputLabel.TextSize = 13
inputLabel.Font = Enum.Font.GothamMedium
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.ZIndex = 5
inputLabel.Parent = inputContainer

local powerValueLbl = Instance.new("TextLabel")
powerValueLbl.Size = UDim2.new(0, 48, 0, 20)
powerValueLbl.Position = UDim2.new(1, -56, 0, 6)
powerValueLbl.BackgroundTransparency = 1
powerValueLbl.Text = tostring(math.clamp(tonumber(_G.LaggerPower) or 50, 0, 100)) .. "%"
powerValueLbl.TextColor3 = C.accentHi
powerValueLbl.TextSize = 13
powerValueLbl.Font = Enum.Font.GothamBold
powerValueLbl.TextXAlignment = Enum.TextXAlignment.Right
powerValueLbl.ZIndex = 5
powerValueLbl.Parent = inputContainer

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -24, 0, 10)
sliderTrack.Position = UDim2.new(0, 12, 0, 40)
sliderTrack.BackgroundColor3 = C.trackOff
sliderTrack.BorderSizePixel = 0
sliderTrack.ZIndex = 5
sliderTrack.Parent = inputContainer
Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(0, 5)
local sliderTrackStroke = Instance.new("UIStroke"); sliderTrackStroke.Color = Color3.fromRGB(0, 0, 0); sliderTrackStroke.Transparency = 0.4; sliderTrackStroke.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(math.clamp((tonumber(_G.LaggerPower) or 50) / 100, 0, 1), 0, 1, 0)
sliderFill.BackgroundColor3 = C.accent
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 6
sliderFill.Parent = sliderTrack
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 5)
local sliderFillGrad = Instance.new("UIGradient", sliderFill)
sliderFillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 105, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255)),
})

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(math.clamp((tonumber(_G.LaggerPower) or 50) / 100, 0, 1), 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 7
sliderKnob.Parent = sliderTrack
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
local knobStroke = Instance.new("UIStroke"); knobStroke.Color = Color3.fromRGB(0, 0, 0); knobStroke.Thickness = 1.5; knobStroke.Parent = sliderKnob

local sliderHit = Instance.new("TextButton")
sliderHit.Size = UDim2.new(1, 0, 0, 28)
sliderHit.Position = UDim2.new(0, 0, 0, 32)
sliderHit.BackgroundTransparency = 1
sliderHit.Text = ""
sliderHit.ZIndex = 8
sliderHit.Parent = inputContainer

local function setLaggerPowerFromAlpha(alpha)
    alpha = math.clamp(alpha, 0, 1)
    local num = math.floor(alpha * 100 + 0.5)
    _G.LaggerPower = num
    sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
    sliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
    powerValueLbl.Text = tostring(num) .. "%"
end

local function alphaFromInput(inp)
    local absPos = sliderTrack.AbsolutePosition
    local absSize = sliderTrack.AbsoluteSize
    if absSize.X <= 0 then return (tonumber(_G.LaggerPower) or 50) / 100 end
    return (inp.X - absPos.X) / absSize.X
end

local sliderDragging = false

sliderHit.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        setLaggerPowerFromAlpha(alphaFromInput(inp.Position))
    end
end)

sliderHit.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if sliderDragging then
            sliderDragging = false
            saveSettings()
        end
    end
end)

local sliderMoveConn = Svc.UserInputService.InputChanged:Connect(function(inp)
    if not sliderDragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    setLaggerPowerFromAlpha(alphaFromInput(inp.Position))
end)
table.insert(ActiveConnections, sliderMoveConn)

Svc.UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if sliderDragging then
            sliderDragging = false
            saveSettings()
        end
    end
end)

do
    sectionOrder = sectionOrder + 1
    local bdContainer = Instance.new("Frame")
    bdContainer.Size = UDim2.new(1, 0, 0, 70)
    bdContainer.BackgroundColor3 = C.card
    bdContainer.BorderSizePixel = 0
    bdContainer.ZIndex = 4
    bdContainer.LayoutOrder = sectionOrder
    bdContainer.Parent = ScrollingFrame2
    Instance.new("UICorner", bdContainer).CornerRadius = UDim.new(0, 12)
    local bdStroke = Instance.new("UIStroke"); bdStroke.Color = Color3.fromRGB(0, 0, 0); bdStroke.Parent = bdContainer

    local bdLabel = Instance.new("TextLabel")
    bdLabel.Size = UDim2.new(1, -50, 0, 20)
    bdLabel.Position = UDim2.new(0, 12, 0, 8)
    bdLabel.BackgroundTransparency = 1
    bdLabel.Text = "Block Delay"
    bdLabel.TextColor3 = C.textBright
    bdLabel.TextSize = 13
    bdLabel.Font = Enum.Font.GothamMedium
    bdLabel.TextXAlignment = Enum.TextXAlignment.Left
    bdLabel.Parent = bdContainer

    local bdSubLabel = Instance.new("TextLabel")
    bdSubLabel.Size = UDim2.new(1, -50, 0, 16)
    bdSubLabel.Position = UDim2.new(0, 12, 0, 28)
    bdSubLabel.BackgroundTransparency = 1
    bdSubLabel.Text = "Fast=activate | Normal=+0.5s | Slow=+1s apres flash"
    bdSubLabel.TextColor3 = C.textMute
    bdSubLabel.TextSize = 10
    bdSubLabel.Font = Enum.Font.Gotham
    bdSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    bdSubLabel.Parent = bdContainer

    local function makeDelayBtn(text, key, x)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 20)
        btn.Position = UDim2.new(1, x, 0, 10)
        btn.BackgroundColor3 = _G.BlockDelay == key and C.accent or C.card
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = _G.BlockDelay == key and Color3.fromRGB(240, 240, 240) or C.textMute
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.Parent = bdContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            _G.BlockDelay = key
            for _, child in ipairs(bdContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    local isActive = (child.Text == "FAST" and key == "fast") or (child.Text == "NORMAL" and key == "normal") or (child.Text == "SLOW" and key == "slow")
                    child.BackgroundColor3 = isActive and C.accent or C.card
                    child.TextColor3 = isActive and Color3.fromRGB(240, 240, 240) or C.textMute
                end
            end
            saveSettings()
        end)
        return btn
    end
    makeDelayBtn("FAST", "fast", -158)
    makeDelayBtn("NORMAL", "normal", -104)
    makeDelayBtn("SLOW", "slow", -50)
end

-- Carpet / Flying Gear selector (from Hugo PVP)
do
    sectionOrder = sectionOrder + 1
    local carpetContainer = Instance.new("Frame")
    carpetContainer.Size = UDim2.new(1, 0, 0, 95)
    carpetContainer.BackgroundColor3 = C.card
    carpetContainer.BorderSizePixel = 0
    carpetContainer.ZIndex = 4
    carpetContainer.LayoutOrder = sectionOrder
    carpetContainer.Parent = ScrollingFrame2
    Instance.new("UICorner", carpetContainer).CornerRadius = UDim.new(0, 12)
    local carpetStroke = Instance.new("UIStroke")
    carpetStroke.Color = Color3.fromRGB(0, 0, 0)
    carpetStroke.Parent = carpetContainer

    local carpetLeftBar = Instance.new("Frame")
    carpetLeftBar.Size = UDim2.new(0, 3, 1, -10)
    carpetLeftBar.Position = UDim2.new(0, 0, 0, 5)
    carpetLeftBar.BackgroundColor3 = C.accent
    carpetLeftBar.BorderSizePixel = 0
    carpetLeftBar.Parent = carpetContainer
    Instance.new("UICorner", carpetLeftBar).CornerRadius = UDim.new(0, 2)

    local carpetLabel = Instance.new("TextLabel")
    carpetLabel.Size = UDim2.new(1, -20, 0, 20)
    carpetLabel.Position = UDim2.new(0, 12, 0, 6)
    carpetLabel.BackgroundTransparency = 1
    carpetLabel.Text = "Flying Gear"
    carpetLabel.TextColor3 = C.textBright
    carpetLabel.TextSize = 13
    carpetLabel.Font = Enum.Font.GothamMedium
    carpetLabel.TextXAlignment = Enum.TextXAlignment.Left
    carpetLabel.Parent = carpetContainer

    local carpetSubLabel = Instance.new("TextLabel")
    carpetSubLabel.Size = UDim2.new(1, -20, 0, 16)
    carpetSubLabel.Position = UDim2.new(0, 12, 0, 24)
    carpetSubLabel.BackgroundTransparency = 1
    carpetSubLabel.Text = "Gear used during Flash TP"
    carpetSubLabel.TextColor3 = C.textMute
    carpetSubLabel.TextSize = 10
    carpetSubLabel.Font = Enum.Font.Gotham
    carpetSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    carpetSubLabel.Parent = carpetContainer

    local carpetOptions = {
        {id = "carpet", label = "CARPET"},
        {id = "broom", label = "BROOM"},
        {id = "sleigh", label = "SLEIGH"},
        {id = "wings", label = "WINGS"},
        {id = "waverider", label = "WAVE"},
    }

    local carpetBtns = {}
    for i, opt in ipairs(carpetOptions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 42, 0, 22)
        btn.Position = UDim2.new(0, 8 + (i - 1) * 44, 0, 48)
        btn.BackgroundColor3 = (_G.SelectedCarpet or "carpet") == opt.id and C.accent or C.card
        btn.BorderSizePixel = 0
        btn.Text = opt.label
        btn.TextColor3 = (_G.SelectedCarpet or "carpet") == opt.id and Color3.fromRGB(240, 240, 240) or C.textMute
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.Parent = carpetContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = (_G.SelectedCarpet or "carpet") == opt.id and C.accent or Color3.fromRGB(0, 0, 0)
        btnStroke.Parent = btn
        carpetBtns[opt.id] = {btn = btn, stroke = btnStroke}

        btn.MouseButton1Click:Connect(function()
            _G.SelectedCarpet = opt.id
            for id, data in pairs(carpetBtns) do
                local selected = id == opt.id
                data.btn.BackgroundColor3 = selected and C.accent or C.card
                data.btn.TextColor3 = selected and Color3.fromRGB(240, 240, 240) or C.textMute
                data.stroke.Color = selected and C.accent or Color3.fromRGB(0, 0, 0)
            end
            saveSettings()
        end)
    end
end


sectionHeader(" SERVER ")

do
    sectionOrder = sectionOrder + 1
    local rejoinRow = Instance.new("Frame")
    rejoinRow.Size = UDim2.new(1, 0, 0, 52)
    rejoinRow.BackgroundColor3 = C.card
    rejoinRow.BorderSizePixel = 0
    rejoinRow.ZIndex = 4
    rejoinRow.LayoutOrder = sectionOrder
    rejoinRow.Parent = ScrollingFrame2
    Instance.new("UICorner", rejoinRow).CornerRadius = UDim.new(0, 12)
    local rs = Instance.new("UIStroke")
    rs.Color = Color3.fromRGB(0, 0, 0)
    rs.Parent = rejoinRow

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -10)
    accentBar.Position = UDim2.new(0, 0, 0, 5)
    accentBar.BackgroundColor3 = C.accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 5
    accentBar.Parent = rejoinRow
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -120, 0, 24)
    t1.Position = UDim2.new(0, 12, 0, 4)
    t1.BackgroundTransparency = 1
    t1.ZIndex = 5
    t1.Text = "Rejoin"
    t1.TextColor3 = C.textBright
    t1.TextSize = 13
    t1.Font = Enum.Font.GothamMedium
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = rejoinRow

    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -120, 0, 18)
    t2.Position = UDim2.new(0, 12, 0, 26)
    t2.BackgroundTransparency = 1
    t2.ZIndex = 5
    t2.Text = "Rejoindre le serveur (meme place)"
    t2.TextColor3 = C.textMute
    t2.TextSize = 11
    t2.Font = Enum.Font.Gotham
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.Parent = rejoinRow

    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Size = UDim2.new(0, 88, 0, 28)
    rejoinBtn.Position = UDim2.new(1, -98, 0.5, -14)
    rejoinBtn.BackgroundColor3 = C.accent
    rejoinBtn.BorderSizePixel = 0
    rejoinBtn.ZIndex = 6
    rejoinBtn.Text = "REJOIN"
    rejoinBtn.TextColor3 = Color3.fromRGB(10, 25, 45)
    rejoinBtn.TextSize = 12
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.AutoButtonColor = false
    rejoinBtn.Parent = rejoinRow
    Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)
    local rbs = Instance.new("UIStroke")
    rbs.Color = Color3.fromRGB(0, 0, 0)
    rbs.Parent = rejoinBtn

    local function rejoinServer()
        task.spawn(function()
            pcall(function()
                local ts = (Svc and Svc.TeleportService) or game:GetService("TeleportService")
                ts:Teleport(game.PlaceId, LocalPlayer)
            end)
        end)
        pcall(function()
            LocalPlayer:Kick("rejoining")
        end)
    end

    rejoinBtn.MouseButton1Click:Connect(rejoinServer)
    rejoinBtn.MouseEnter:Connect(function()
        Svc.TweenService:Create(rejoinBtn, TweenInfo.new(0.12), { BackgroundColor3 = C.accentHi }):Play()
    end)
    rejoinBtn.MouseLeave:Connect(function()
        Svc.TweenService:Create(rejoinBtn, TweenInfo.new(0.12), { BackgroundColor3 = C.accent }):Play()
    end)
end

sectionHeader(" KEYBINDS ")

local function updateActionLabels()
    if FLASHTP and FLASHTP:FindFirstChildWhichIsA("TextLabel") then
        FLASHTP:FindFirstChildWhichIsA("TextLabel").Text = "FLASH [" .. getDisplayName(keyNames.flash) .. "]"
    end
    if BLOCK and BLOCK:FindFirstChildWhichIsA("TextLabel") then
        BLOCK:FindFirstChildWhichIsA("TextLabel").Text = "BLOCK [" .. getDisplayName(keyNames.block) .. "]"
    end
    if RESET and RESET:FindFirstChildWhichIsA("TextLabel") then
        RESET:FindFirstChildWhichIsA("TextLabel").Text = "RESET [" .. getDisplayName(keyNames.reset) .. "]"
    end
end

local function makeKeybindRow(actionName, displayName)
    sectionOrder = sectionOrder + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    row.ZIndex = 4
    row.LayoutOrder = sectionOrder
    row.Parent = ScrollingFrame2
    Instance.new("UICorner", row)
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0); s.Parent = row

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -80, 0, 24)
    nameLbl.Position = UDim2.new(0, 12, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.ZIndex = 5
    nameLbl.Text = displayName
    nameLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    local typeHint = Instance.new("TextLabel")
    typeHint.Size = UDim2.new(1, -80, 0, 18)
    typeHint.Position = UDim2.new(0, 12, 0, 24)
    typeHint.BackgroundTransparency = 1
    typeHint.ZIndex = 5
    typeHint.Text = "Clavier/" .. keybinds[actionName].inputType
    typeHint.TextColor3 = Color3.fromRGB(160, 160, 160)
    typeHint.TextSize = 10
    typeHint.Font = Enum.Font.Gotham
    typeHint.TextXAlignment = Enum.TextXAlignment.Left
    typeHint.Parent = row

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 55, 0, 24)
    keyBtn.Position = UDim2.new(1, -63, 0.5, -12)
    keyBtn.BackgroundColor3 = C.iconBg
    keyBtn.BorderSizePixel = 0
    keyBtn.ZIndex = 6
    keyBtn.Text = getDisplayName(keyNames[actionName])
    keyBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    keyBtn.TextSize = 11
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = row
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
    local ks = Instance.new("UIStroke"); ks.Color = Color3.fromRGB(0, 0, 0); ks.Parent = keyBtn

    local listening = false
    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = C.accent
        
        local conn
        conn = Svc.UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                conn:Disconnect(); listening = false
                keybinds[actionName].key = inp.KeyCode
                keybinds[actionName].inputType = "Keyboard"
                keyNames[actionName] = inp.KeyCode.Name
                keyBtn.Text = getDisplayName(inp.KeyCode.Name)
                keyBtn.TextColor3 = Color3.fromRGB(240,240,240)
                typeHint.Text = "Clavier/Keyboard"
                saveKeybinds()
                updateActionLabels()
                return
            end
            if inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2 or inp.UserInputType == Enum.UserInputType.Gamepad3 or inp.UserInputType == Enum.UserInputType.Gamepad4 then
                conn:Disconnect(); listening = false
                keybinds[actionName].key = inp.KeyCode
                keybinds[actionName].inputType = "Gamepad"
                keyNames[actionName] = inp.KeyCode.Name
                keyBtn.Text = getDisplayName(inp.KeyCode.Name)
                keyBtn.TextColor3 = Color3.fromRGB(240,240,240)
                typeHint.Text = "Clavier/Gamepad"
                saveKeybinds()
                updateActionLabels()
                return
            end
        end)
        task.delay(5, function()
            if listening then
                conn:Disconnect(); listening = false
                keyBtn.Text = getDisplayName(keyNames[actionName])
                keyBtn.TextColor3 = Color3.fromRGB(240,240,240)
            end
        end)
    end)
end

makeKeybindRow("flash", "Flash TP")
makeKeybindRow("block", "Block")
makeKeybindRow("reset", "Reset")
updateActionLabels()

local kbConn = Svc.UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == keybinds.flash.key and keybinds.flash.inputType == "Keyboard" then
            if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        elseif inp.KeyCode == keybinds.block.key and keybinds.block.inputType == "Keyboard" then
            local target = getNearestPlayer()
            if target then blockPlayer(target) end
        elseif inp.KeyCode == keybinds.reset.key and keybinds.reset.inputType == "Keyboard" then
            ResetPlayer()
        end
    end
    if inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2 or inp.UserInputType == Enum.UserInputType.Gamepad3 or inp.UserInputType == Enum.UserInputType.Gamepad4 then
        if inp.KeyCode == keybinds.flash.key and keybinds.flash.inputType == "Gamepad" then
            if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        elseif inp.KeyCode == keybinds.block.key and keybinds.block.inputType == "Gamepad" then
            local target = getNearestPlayer()
            if target then blockPlayer(target) end
        elseif inp.KeyCode == keybinds.reset.key and keybinds.reset.inputType == "Gamepad" then
            ResetPlayer()
        end
    end
end)
table.insert(ActiveConnections, kbConn)

local function flashBar(bar)
    bar.BackgroundColor3 = C.accentHi
    Svc.TweenService:Create(bar, TweenInfo.new(0.4), { BackgroundColor3 = C.accent }):Play()
end

FLASHTP.MouseButton1Click:Connect(function()
    if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
        flashBar(flashAccent)
        startTripToPetSlot(selectedPrompt, selectedSlotNumber)
    end
end)

BLOCK.MouseButton1Click:Connect(function()
    flashBar(blockAccent)
    local target = getNearestPlayer()
    if target then blockPlayer(target) end
end)

RESET.MouseButton1Click:Connect(function()
    flashBar(resetAccent)
    ResetPlayer()
end)

local function syncBorder() BorderFrame.Position = Win.Position end

local locked = false
local dragging = false
local dragStart, startPos

LockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    LockBtn.Text = locked and "🔒" or "🔓"
    LockBtn.TextColor3 = locked and C.accentHi or C.textMute
    Svc.TweenService:Create(LockBtn, TweenInfo.new(0.2), { BackgroundColor3 = locked and C.accent or C.card }):Play()
end)

Frame3.InputBegan:Connect(function(input)
    if locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Win.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Svc.UserInputService.InputChanged:Connect(function(input)
    if dragging and not locked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        syncBorder()
    end
end)

local activeTab = "brainrots"

local function setTab(tab)
    if tab == activeTab then return end
    activeTab = tab
    local info = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if tab == "settings" then
        Frame21.Visible = true
        Frame21.Position = UDim2.new(1, 0, 0, 0)
        Svc.TweenService:Create(Frame17, info, { Position = UDim2.new(-1, 0, 0, 0) }):Play()
        Svc.TweenService:Create(Frame21, info, { Position = UDim2.new(0, 0, 0, 0) }):Play()
        TextLabel7.TextColor3 = C.textDim
        TextLabel8.TextColor3 = C.textBlue
        Svc.TweenService:Create(Frame13, info, { BackgroundTransparency = 1 }):Play()
        Svc.TweenService:Create(Frame14, info, { BackgroundTransparency = 0 }):Play()
    else
        Frame17.Visible = true
        Frame17.Position = UDim2.new(-1, 0, 0, 0)
        Svc.TweenService:Create(Frame17, info, { Position = UDim2.new(0, 0, 0, 0) }):Play()
        Svc.TweenService:Create(Frame21, info, { Position = UDim2.new(1, 0, 0, 0) }):Play()
        TextLabel7.TextColor3 = C.textBlue
        TextLabel8.TextColor3 = C.textDim
        Svc.TweenService:Create(Frame13, info, { BackgroundTransparency = 0 }):Play()
        Svc.TweenService:Create(Frame14, info, { BackgroundTransparency = 1 }):Play()
        task.delay(0.22, function() if activeTab == "brainrots" then Frame21.Visible = false end end)
    end
end

Frame17.Position = UDim2.new(0, 0, 0, 0)
TextButton4.MouseButton1Click:Connect(function() setTab("brainrots") end)
TextButton5.MouseButton1Click:Connect(function() setTab("settings") end)

local minimised = false
local fullSize = Win.Size
local fullBorder = BorderFrame.Size
local MIN_WIN_H = L.headerH + 41
local MIN_BORDER_H = MIN_WIN_H + 4

MinBtn.MouseButton1Click:Connect(function()
    if dragging then return end
    minimised = not minimised
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local currentWinPos = Win.Position
    local heightDiff = fullSize.Y.Offset - MIN_WIN_H
    local offset = heightDiff / 2

    if minimised then
        local targetWinPos = UDim2.new(currentWinPos.X.Scale, currentWinPos.X.Offset, currentWinPos.Y.Scale, currentWinPos.Y.Offset - offset)
        Svc.TweenService:Create(Frame2, info, { Size = UDim2.new(1, 0, 0, 0) }):Play()
        Svc.TweenService:Create(Win, info, { Size = UDim2.new(0, L.winW, 0, MIN_WIN_H), Position = targetWinPos }):Play()
        Svc.TweenService:Create(BorderFrame, info, { Size = UDim2.new(0, L.winW+4, 0, MIN_BORDER_H), Position = targetWinPos }):Play()
    else
        local targetWinPos = UDim2.new(currentWinPos.X.Scale, currentWinPos.X.Offset, currentWinPos.Y.Scale, currentWinPos.Y.Offset + offset)
        Svc.TweenService:Create(Frame2, info, { Size = UDim2.new(1, 0, 1, -94) }):Play()
        Svc.TweenService:Create(Win, info, { Size = fullSize, Position = targetWinPos }):Play()
        Svc.TweenService:Create(BorderFrame, info, { Size = fullBorder, Position = targetWinPos }):Play()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    clearSlotMarker()
    clearTpPathVisual()
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local t1 = Svc.TweenService:Create(Win, info, { Size = UDim2.new(0,0,0,0) })
    local t2 = Svc.TweenService:Create(BorderFrame, info, { Size = UDim2.new(0,0,0,0) })
    t1:Play(); t2:Play()
    t1.Completed:Connect(function() SHARKYPVP_GUI:Destroy() end)
end)

task.spawn(function()
    local base1 = UIGradient.Rotation
    while UIGradient.Parent do
        local t = os.clock()
        UIGradient.Rotation = (base1 + t * 60) % 360
        Svc.RunService.RenderStepped:Wait()
    end
end)

task.spawn(function()
    local target = L.posX
    Win.Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset - 40)
    BorderFrame.Position = Win.Position
    Win.Visible = true
    Svc.TweenService:Create(Win, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = target }):Play()
    local bt = Svc.TweenService:Create(BorderFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = target })
    bt:Play()
    bt.Completed:Wait()
    Svc.RunService.RenderStepped:Connect(syncBorder)
end)

task.spawn(function()
    while task.wait(1.5) do
        if thisScriptStopped then break end
        updatePetList()
    end
end)
updatePetList()

_G.SHARKY_Script_Purge = function()
    thisScriptStopped = true
    stopFlashLagger()
    stopAntiRagdoll()
    stopAutoGrab()
    stopBrainrotScanner()
    clearSlotMarker()
    clearTpPathVisual()
    pcall(function()
        if _G.SHARKYQuickPanel and _G.SHARKYQuickPanel.set then _G.SHARKYQuickPanel.set(false) end
        local qp = PlayerGui:FindFirstChild("SHARKYQuickPanel")
        if qp then qp:Destroy() end
    end)
    for _, conn in ipairs(ActiveConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    _G.SHARKY_Script_Purge = nil
end

if Settings.autoGrabEnabled then
    startBrainrotScanner()
    if scanForBrainrots() then
        hasBrainrotDetected = true
        startAutoGrab()
        if spFrame then spFrame.Visible = true end
    end
end

if Settings.antiRagdollEnabled then
    startAntiRagdoll()
    print("✅ Anti-Ragdoll System Loaded & ENABLED")
end

print("[SHARKY v5 - Full Red + Safe Zone Hugo + Flying Gear] Script chargé avec succès ✅")
