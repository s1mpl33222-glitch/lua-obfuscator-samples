local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "Tày's Hub (Beta)", LoadingTitle = "loading...", LoadingSubtitle = "by Hmigh", ConfigurationSaving = {Enabled = false}})

local Tabs = {}
for _, name in pairs({"Main", "Game Script", "Simple", "Hubs", "Esp", "Aimbot", "Misc", "Info", "Credits"}) do
    Tabs[name] = Window:CreateTab(name, name == "Game Script" and "gamepad-2" or name == "Main" and "home" or name == "Simple" and "user" or name == "Hubs" and "layers" or name == "Esp" and "eye" or name == "Aimbot" and "crosshair" or name == "Misc" and "settings" or name == "Info" and "info" or "star")
end

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Flying, FlySpeed, FlyConnection, MovingUp, MovingDown, FlyGui = false, 50, nil, false, false, nil
local Noclip, NoclipConnection, SelectedSimpleTarget, SelectedTarget, AimbotEnabled, AimPart, FovEnabled, FovRadius = false, nil, nil, nil, false, "Head", false, 100
local EspMaster, EspChams, EspLines, EspNames, EspDistances, EspHealth = false, false, false, false, false, false
local AntiFling, AntiFlingConnection, FakeLag, FakeLagConnection, ChatBypassEnabled, ChatBypassConnection = false, nil, false, nil, false, nil
local LinesContainer = {}

-- Cấu hình mặc định cho các biến hệ thống của ESP / Teleport bổ sung
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
LocalPlayer.CharacterAdded:Connect(function(char)
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

local Stuff = workspace:FindFirstChild("Stuff") or workspace

getgenv().Settings = {
    EntityESP = false,
    BobESP = false,
    EvilBobESP = false,
    EntityDistance = true,
    EntityName = true,
    EntityWalls = true,
    EntityFill = Color3.fromRGB(255, 0, 0),
    EntityOutline = Color3.fromRGB(255, 255, 255),
    EntityTransparency = 0.5
}

local entityESP  = {}
local bobESP     = {}
local evilBobESP = {}

local function makeDrawingText()
    local t = Drawing.new("Text")
    t.Visible      = false
    t.Size         = 15
    t.Font         = Drawing.Fonts.UI
    t.Outline      = true
    t.OutlineColor = Color3.fromRGB(0, 0, 0)
    t.Center       = true
    return t
end

local function addEntityESP(npc)
    if entityESP[npc] then return end
    if not Settings.EntityESP then return end
    local h = Instance.new("Highlight")
    h.FillColor           = Settings.EntityFill
    h.OutlineColor        = Settings.EntityOutline
    h.FillTransparency    = Settings.EntityTransparency
    h.OutlineTransparency = 0
    h.DepthMode           = Settings.EntityWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    h.Adornee             = npc
    h.Parent              = npc
    local distLabel = makeDrawingText(); distLabel.Color = Color3.fromRGB(255, 80, 80)
    local nameLabel = makeDrawingText(); nameLabel.Color = Color3.fromRGB(255, 255, 255); nameLabel.Text = npc.Name
    entityESP[npc] = { highlight = h, distLabel = distLabel, nameLabel = nameLabel }
end

local function removeEntityESP(npc)
    local d = entityESP[npc]; if not d then return end
    pcall(function() d.highlight:Destroy() end)
    pcall(function() d.distLabel.Visible = false; d.distLabel:Remove() end)
    pcall(function() d.nameLabel.Visible = false; d.nameLabel:Remove() end)
    entityESP[npc] = nil
end

local function removeAllEntityESP() for npc in pairs(entityESP) do removeEntityESP(npc) end end

local function setupEntityESP()
    local npc = Stuff:FindFirstChild("StillLife")
    if npc then addEntityESP(npc) end
end

local function addModelESP(tbl, model, fillColor, outlineColor)
    if tbl[model] then return end
    local h = Instance.new("Highlight")
    h.FillColor           = fillColor
    h.OutlineColor        = outlineColor
    h.FillTransparency    = 0.5
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee             = model
    h.Parent              = model
    local distLabel = makeDrawingText(); distLabel.Color = fillColor
    local nameLabel = makeDrawingText(); nameLabel.Color = Color3.fromRGB(255, 255, 255); nameLabel.Text = model.Name
    tbl[model] = { highlight = h, distLabel = distLabel, nameLabel = nameLabel }
end

local function removeModelESP(tbl, model)
    local d = tbl[model]; if not d then return end
    pcall(function() d.highlight:Destroy() end)
    pcall(function() d.distLabel.Visible = false; d.distLabel:Remove() end)
    pcall(function() d.nameLabel.Visible = false; d.nameLabel:Remove() end)
    tbl[model] = nil
end

local function scanBobESP()
    for _, child in ipairs(Stuff:GetChildren()) do
        if child.Name == "bob"     and Settings.BobESP     then addModelESP(bobESP,     child, Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 255)) end
        if child.Name == "bobEvil" and Settings.EvilBobESP then addModelESP(evilBobESP, child, Color3.fromRGB(180, 0, 255), Color3.fromRGB(255, 0, 0))     end
    end
end

Stuff.ChildAdded:Connect(function(child)
    task.wait(0.1)
    if child.Name == "StillLife" and Settings.EntityESP  then addEntityESP(child) end
    if child.Name == "bob"       and Settings.BobESP     then addModelESP(bobESP,     child, Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 255)) end
    if child.Name == "bobEvil"   and Settings.EvilBobESP then addModelESP(evilBobESP, child, Color3.fromRGB(180, 0, 255), Color3.fromRGB(255, 0, 0))     end
end)

Stuff.ChildRemoved:Connect(function(child)
    if child.Name == "StillLife" then removeEntityESP(child) end
    if child.Name == "bob"       then removeModelESP(bobESP,     child) end
    if child.Name == "bobEvil"   then removeModelESP(evilBobESP, child) end
end)

local function updateLabel(data, root, labelText, labelColor, yOffset)
    if not root or not root.Parent then return end
    local worldPos = root.Position + Vector3.new(0, yOffset, 0)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if onScreen then
        if data.distLabel then
            data.distLabel.Visible  = true
            data.distLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 14)
            data.distLabel.Text     = labelText
            data.distLabel.Color    = labelColor
        end
        if data.nameLabel then
            data.nameLabel.Visible  = true
            data.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y)
        end
    else
        if data.distLabel then data.distLabel.Visible = false end
        if data.nameLabel then data.nameLabel.Visible = false end
    end
end

RunService.RenderStepped:Connect(function()
    local currentRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not currentRoot then return end

    for npc, data in pairs(entityESP) do
        if not npc or not npc.Parent then removeEntityESP(npc); continue end
        local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head") or npc:FindFirstChildWhichIsA("BasePart")
        if not root then continue end
        local dist = math.floor((currentRoot.Position - root.Position).Magnitude)
        local distColor = dist < 20 and Color3.fromRGB(255, 50, 50) or dist < 50 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 255, 100)
        if data.nameLabel then data.nameLabel.Visible = Settings.EntityName end
        if data.distLabel then data.distLabel.Visible = Settings.EntityDistance end
        updateLabel(data, root, dist .. " studs", distColor, -3)
    end

    for model, data in pairs(bobESP) do
        if not model or not model.Parent then removeModelESP(bobESP, model); continue end
        local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not root then continue end
        local dist = math.floor((currentRoot.Position - root.Position).Magnitude)
        updateLabel(data, root, dist .. " studs", Color3.fromRGB(255, 165, 0), -3)
    end

    for model, data in pairs(evilBobESP) do
        if not model or not model.Parent then removeModelESP(evilBobESP, model); continue end
        local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not root then continue end
        local dist = math.floor((currentRoot.Position - root.Position).Magnitude)
        updateLabel(data, root, dist .. " studs", Color3.fromRGB(180, 0, 255), -3)
    end
end)

local function teleportTo(position)
    local currentRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if currentRoot then
        currentRoot.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    end
end

local function GetPlayerNames() 
    local n = {} for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player then table.insert(n, p.Name) end end return n 
end

local SupportedGames = {
    [189707] = function()
        Tabs["Game Script"]:CreateButton({Name = "NullFire", Callback = function() task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader"))() end) end})
        Tabs["Game Script"]:CreateButton({Name = "NDS Hub", Callback = function() task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/NaturalDisasterSurvival/refs/heads/main/main.lua"))() end) end})
    end,
    [14240051614] = function()
        Tabs["Game Script"]:CreateButton({Name = "OverHub", Callback = function() task.spawn(function() loadstring(game:HttpGet("https://overhub.dev/loader.lua"))() end) end})
        Tabs["Game Script"]:CreateButton({Name = "Dinas Project", Callback = function() task.spawn(function() loadstring(game:HttpGet("https://rawscripts.net/raw/FPS-Flick-DINAS-PROJECT-AIMBOT-ESP-70584"))() end) end})
    end,
    -- Game Support: Unseen Liminality với Quick Tools, Teleport, Hubs và Auto-Player Update
    [82797688803922] = function()
        Tabs["Game Script"]:CreateSection("Quick Tools")
        Tabs["Game Script"]:CreateToggle({
            Name = "StillLife ESP", CurrentValue = false, Flag = "EntityESP",
            Callback = function(v)
                Settings.EntityESP = v
                if v then setupEntityESP() else removeAllEntityESP() end
            end,
        })
        Tabs["Game Script"]:CreateToggle({
            Name = "Bob ESP", CurrentValue = false, Flag = "BobESP",
            Callback = function(v)
                Settings.BobESP = v
                if v then scanBobESP()
                else for m in pairs(bobESP) do removeModelESP(bobESP, m) end end
            end,
        })
        Tabs["Game Script"]:CreateToggle({
            Name = "Evil Bob ESP", CurrentValue = false, Flag = "EvilBobESP",
            Callback = function(v)
                Settings.EvilBobESP = v
                if v then scanBobESP()
                else for m in pairs(evilBobESP) do removeModelESP(evilBobESP, m) end end
            end,
        })
        Tabs["Game Script"]:CreateToggle({
            Name = "Show Distance", CurrentValue = true, Flag = "EntityDistance",
            Callback = function(v) Settings.EntityDistance = v end,
        })
        Tabs["Game Script"]:CreateToggle({
            Name = "Show Name", CurrentValue = true, Flag = "EntityName",
            Callback = function(v) Settings.EntityName = v end,
        })
        Tabs["Game Script"]:CreateToggle({
            Name = "Show Through Walls", CurrentValue = true, Flag = "EntityWalls",
            Callback = function(v)
                Settings.EntityWalls = v
                for _, d in pairs(entityESP) do
                    if d.highlight then d.highlight.DepthMode = v and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded end
                end
            end,
        })

        Tabs["Game Script"]:CreateSection("Unseen Liminality Teleport")
        Tabs["Game Script"]:CreateButton({
            Name = "Dreamcore",
            Callback = function()
                teleportTo(Vector3.new(269.3863220214844, 97.53511810302734, 106.36038970947266))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Empty Lounge",
            Callback = function()
                teleportTo(Vector3.new(-242.96495056152344, 0.6068888306617737, 69.91342163085938))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Hotel",
            Callback = function()
                teleportTo(Vector3.new(1281.4266357421875, 90.2974853515625, 202.59185791015625))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Liminal Home",
            Callback = function()
                teleportTo(Vector3.new(517.5628051757812, 0.5999994277954102, 717.6593017578125))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Lobby",
            Callback = function()
                teleportTo(Vector3.new(142.567626953125, 2.7536182403564453, 567.0317993164062))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Pipedream",
            Callback = function()
                teleportTo(Vector3.new(408.49603271484375, 5.47128963470459, 874.2557983398438))
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Poolrooms",
            Callback = function()
                teleportTo(Vector3.new(445.04656982421875, 63.2449836730957, 181.1199493408203))
            end,
        })

        Tabs["Game Script"]:CreateSection("Hub")
        Tabs["Game Script"]:CreateButton({
            Name = "r4lr hub (Key)",
            Callback = function()
                task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/unrexl/Scripts/refs/heads/main/Unseen"))() end)
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Raynisis Hub (Keyless)",
            Callback = function()
                task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Raynisis1612/ULU/refs/heads/main/UnseenLiminalityUtilities.lua"))() end)
            end,
        })
        Tabs["Game Script"]:CreateButton({
            Name = "Unseen Liminality Hub (Key)",
            Callback = function()
                task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/rackyxd/scripts/refs/heads/main/UnseenLiminality"))() end)
            end,
        })

        Tabs["Game Script"]:CreateSection("Players")
        local selectedPlayer = nil
        local function getPlayerNamesLocal()
            local names = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then table.insert(names, plr.Name) end
            end
            if #names == 0 then table.insert(names, "No players in server") end
            return names
        end
        local playerDropdown = Tabs["Game Script"]:CreateDropdown({
            Name          = "Select Player",
            Options       = getPlayerNamesLocal(),
            CurrentOption = { getPlayerNamesLocal()[1] },
            Flag          = "PlayerTpTarget",
            Callback = function(selected)
                selectedPlayer = type(selected) == "table" and selected[1] or selected
            end,
        })
        
        -- Hệ thống tự động Refresh danh sách khi người chơi Join/Leave game riêng cho phần này
        Players.PlayerAdded:Connect(function()
            task.wait(0.5)
            pcall(function() playerDropdown:Refresh(getPlayerNamesLocal(), true) end)
        end)
        Players.PlayerRemoving:Connect(function(plr)
            task.wait(0.1)
            pcall(function()
                playerDropdown:Refresh(getPlayerNamesLocal(), true)
                if selectedPlayer and selectedPlayer == plr.Name then selectedPlayer = nil end
            end)
        end)

        Tabs["Game Script"]:CreateButton({
            Name = "Teleport to Player",
            Callback = function()
                if not selectedPlayer or selectedPlayer == "No players in server" then return end
                local target = Players:FindFirstChild(selectedPlayer)
                if not target or not target.Character then return end
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if not targetRoot then return end
                teleportTo(targetRoot.Position)
            end,
        })
    end,
    [12177325772] = function()
        local originalSize = Vector3.new(4, 10, 30)
        pcall(function() originalSize = workspace.Stadium.Teams.Away.Goal.Hitbox.Size end)
        Tabs["Game Script"]:CreateToggle({Name = "Goal Hitbox", CurrentValue = false, Callback = function(V)
            pcall(function()
                local sz = V and Vector3.new(100, 100, 100) or originalSize
                workspace.Stadium.Teams.Away.Goal.Hitbox.Size = sz
                workspace.Stadium.Teams.Home.Goal.Hitbox.Size = sz
            end)
        end})
        Tabs["Game Script"]:CreateToggle({Name = "Infinite Stamina", CurrentValue = false, Callback = function(Value)
            getgenv().InfiniteStamina = Value
            if getgenv().OriginalConsume == nil then pcall(function() getgenv().OriginalConsume = require(Player.PlayerScripts.Client.Controllers.Stamina).Consume end) end
            if getgenv().StaminaLoopActive == nil and getgenv().InfiniteStamina then
                getgenv().StaminaLoopActive = true
                task.spawn(function()
                    while true do task.wait(0.1)
                        local s, mod = pcall(function() return require(Player.PlayerScripts.Client.Controllers.Stamina) end)
                        if s and mod then
                            if getgenv().InfiniteStamina then
                                mod.Consume = function() return true end if mod.Amount then mod.Amount:set(100) end
                                for k, v in pairs(mod) do if type(v) == "number" and v <= 100 then mod[k] = 100 end end
                            else if getgenv().OriginalConsume then mod.Consume = getgenv().OriginalConsume end end
                        end
                    end
                end)
                local SpdCon; SpdCon = RunService.Heartbeat:Connect(function()
                    if not getgenv().InfiniteStamina then SpdCon:Disconnect() return end
                    if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = 27 end
                end)
            end
        end})
    end
}

local TotalSupported = 0 for _ in pairs(SupportedGames) do TotalSupported = TotalSupported + 1 end

Tabs["Main"]:CreateSection("Dashboard")
local TimeParagraph = Tabs["Main"]:CreateParagraph({Title = "Checking time...", Content = "--:--:--"})
Tabs["Main"]:CreateParagraph({Title = "Tày's Hub", Content = "Universal Script\n" .. tostring(TotalSupported) .. " Game Support"})

task.spawn(function()
    while task.wait(1) do pcall(function()
        local dt = os.date("*t")
        local greet = (dt.hour >= 5 and dt.hour < 12) and "Good Morning" or (dt.hour >= 12 and dt.hour < 18) and "Good Afternoon" or "Good Evening"
        TimeParagraph:Set({Title = greet, Content = string.format("%02d:%02d:%02d", dt.hour, dt.min, dt.sec)})
    end) end
end)

Tabs["Main"]:CreateSection("Quick Tools")
local function AddBtn(tab, name, fn) tab:CreateButton({Name = name, Callback = function() task.spawn(fn) end}) end
AddBtn(Tabs["Main"], "Dex++", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Dex-Explorer-Source-Code-227743"))() end)
AddBtn(Tabs["Main"], "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddBtn(Tabs["Main"], "Copy ID/Sever ID", function() if setclipboard then setclipboard(game.PlaceId .. " | " .. game.JobId) end end)
AddBtn(Tabs["Main"], "Get IP", function() local s, ip = pcall(function() return game:HttpGet("https://api.ipify.org") end) if s and ip and setclipboard then setclipboard(ip) end end)
AddBtn(Tabs["Main"], "Console", function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F9, false, game) end)
AddBtn(Tabs["Main"], "Rejoin", function() local TS = game:GetService("TeleportService") if #game.Players:GetPlayers() <= 1 then TS:Teleport(game.PlaceId, Player) else TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end end)
AddBtn(Tabs["Main"], "Server Hop", function() local s, res = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end) if s and res and res.data then for _, v in pairs(res.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, Player) return end end end end)
AddBtn(Tabs["Main"], "UNC", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/unified-naming-convention/capability-test/main/raw.lua"))() end)

Tabs["Game Script"]:CreateSection("Game Status")
local GameStatusPara = Tabs["Game Script"]:CreateParagraph({Title = "Checking Game...", Content = "Vui lòng chờ..."})
Tabs["Game Script"]:CreateParagraph({Title = "Current Support Games", Content = "Tổng số game hỗ trợ: " .. tostring(TotalSupported)})

if SupportedGames[game.PlaceId] then
    GameStatusPara:Set({Title = "Game Status: Supported", Content = "Script riêng cho game đã được hiển thị phía dưới!"}) SupportedGames[game.PlaceId]()
else
    GameStatusPara:Set({Title = "Game Status: Unsupported", Content = "Hãy sử dụng các tính năng chung ở các Tab bên cạnh."})
end

Tabs["Simple"]:CreateSection("Movement")
Tabs["Simple"]:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = V end end})
Tabs["Simple"]:CreateSlider({Name = "JumpPower", Range = {50, 250}, Increment = 1, CurrentValue = 50, Callback = function(V) if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.UseJumpPower, Player.Character.Humanoid.JumpPower = true, V end end})
Tabs["Simple"]:CreateToggle({Name = "Toggle Fly", CurrentValue = false, Callback = function(Value)
    Flying = Value if FlyConnection then FlyConnection:Disconnect() end
    if Flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
        local Cam, Root, Hum = workspace.CurrentCamera, Player.Character.HumanoidRootPart, Player.Character.Humanoid
        if FlyGui then FlyGui:Destroy() end FlyGui = Instance.new("ScreenGui", game.CoreGui)
        local function makeBtn(txt, pos) local btn = Instance.new("TextButton", FlyGui) btn.Size, btn.Position, btn.Text, btn.TextSize = UDim2.new(0, 60, 0, 60), pos, txt, 25 Instance.new("UICorner", btn) return btn end
        local U, D = makeBtn("▲", UDim2.new(0.85, 0, 0.45, 0)), makeBtn("▼", UDim2.new(0.85, 0, 0.57, 0))
        U.MouseButton1Down:Connect(function() MovingUp = true end) U.MouseButton1Up:Connect(function() MovingUp = false end)
        D.MouseButton1Down:Connect(function() MovingDown = true end) D.MouseButton1Up:Connect(function() MovingDown = false end)
        local BV = Instance.new("BodyVelocity", Root) BV.Name, BV.MaxForce = "FlyBV", Vector3.new(9e9, 9e9, 9e9) Hum:ChangeState(Enum.HumanoidStateType.Physics)
        FlyConnection = RunService.Heartbeat:Connect(function(dt)
            if Flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
                Root.CFrame = CFrame.new(Root.Position, Root.Position + Cam.CFrame.LookVector)
                local mv = Hum.MoveDirection.Magnitude > 0 and Cam.CFrame:VectorToWorldSpace(Cam.CFrame:VectorToObjectSpace(Hum.MoveDirection)) or Vector3.new(0, 0, 0)
                mv = mv + Vector3.new(0, MovingUp and 1 or (MovingDown and -1 or 0), 0) if mv.Magnitude > 0 then Root.CFrame = Root.CFrame + (mv.Unit * FlySpeed * dt) end Root.Velocity = Vector3.new(0, 0, 0)
            else if BV then BV:Destroy() end Hum:ChangeState(Enum.HumanoidStateType.GettingUp) if FlyGui then FlyGui:Destroy() FlyGui = nil end if FlyConnection then FlyConnection:Disconnect() end end
        end)
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart:FindFirstChild("FlyBV") then Player.Character.HumanoidRootPart.FlyBV:Destroy() end
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end if FlyGui then FlyGui:Destroy() FlyGui = nil end
    end
end})
Tabs["Simple"]:CreateSlider({Name = "Fly Speed", Range = {10, 200}, Increment = 1, CurrentValue = 50, Callback = function(V) FlySpeed = V end})
Tabs["Simple"]:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(Value)
    Noclip = Value if NoclipConnection then NoclipConnection:Disconnect() end
    if Noclip then NoclipConnection = RunService.Stepped:Connect(function() if Player.Character then for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end end) end
end})

Tabs["Simple"]:CreateSection("Player Interaction")
local SimpleTargetDropdown = Tabs["Simple"]:CreateDropdown({Name = "Chọn Player Mục Tiêu", Options = GetPlayerNames(), CurrentOption = "", MultipleOptions = false, Callback = function(O) SelectedSimpleTarget = game.Players:FindFirstChild(O[1]) end})
Tabs["Simple"]:CreateButton({Name = "Teleport", Callback = function() if SelectedSimpleTarget and SelectedSimpleTarget.Character and SelectedSimpleTarget.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.CFrame = SelectedSimpleTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end})
Tabs["Simple"]:CreateButton({Name = "Fling Player", Callback = function()
    if SelectedSimpleTarget and SelectedSimpleTarget.Character and SelectedSimpleTarget.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local bam = Instance.new("BodyAngularVelocity", Player.Character.HumanoidRootPart) bam.MaxTorque, bam.AngularVelocity = Vector3.new(9e9, 9e9, 9e9), Vector3.new(0, 9e9, 0)
        local oldCF, targetRoot = Player.Character.HumanoidRootPart.CFrame, SelectedSimpleTarget.Character.HumanoidRootPart
        for i = 1, 50 do if not targetRoot then break end Player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1)) task.wait() end
        bam:Destroy() Player.Character.HumanoidRootPart.CFrame = oldCF
    end
end})
Tabs["Simple"]:CreateButton({Name = "FE Bang", Callback = function()
    task.spawn(function() loadstring(game:HttpGet("https://luascript-on.vercel.app/raw/d997c49d-b187-4cb4-ad29-aab0495251c3"))() end)
end})

Tabs["Hubs"]:CreateSection("Danh Sách Hub Khác")
AddBtn(Tabs["Hubs"], "Tiger Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/balintTheDevX/Tiger-X-V3/main/Tiger%20X%20V3.5%20Fixed"))() end)
AddBtn(Tabs["Hubs"], "Owl Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))() end)
AddBtn(Tabs["Hubs"], "Fly Gui v7", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Droverprover/F4/64e66c6a35acab85c4449a08abaa782205177aa6/Fly.V7.Lua"))() end)

for _, n in pairs({"Bật ESP", "Chams", "Lines", "Name", "Distance", "Health"}) do
    Tabs["Esp"]:CreateToggle({Name = n, CurrentValue = false, Callback = function(V) if n == "Bật ESP" then EspMaster = V elseif n == "Chams" then EspChams = V elseif n == "Lines" then EspLines = V elseif n == "Name" then EspNames = V elseif n == "Distance" then EspDistances = V else EspHealth = V end end})
end

RunService.Heartbeat:Connect(function()
   local cam = workspace.CurrentCamera local startPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
   for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player then
      local char = p.Character local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
      local hum = char and char:FindFirstChildOfClass("Humanoid") local myRoot = Player.Character and (Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("UpperTorso"))
      if EspMaster and char and root and hum then
         local hl = game.CoreGui:FindFirstChild("ChamsReal_" .. p.Name)
         if EspChams then if not hl then hl = Instance.new("Highlight", game.CoreGui) hl.Name, hl.FillColor, hl.OutlineColor, hl.FillTransparency, hl.OutlineTransparency, hl.DepthMode = "ChamsReal_" .. p.Name, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255), 0.4, 0.1, Enum.HighlightDepthMode.AlwaysOnTop end hl.Adornee = char else if hl then hl:Destroy() end end
         local bbg = root:FindFirstChild("ESPTagHead")
         if EspNames or EspDistances or EspHealth then
            if not bbg then bbg = Instance.new("BillboardGui", root) bbg.Name, bbg.Size, bbg.AlwaysOnTop, bbg.ExtentsOffset = "ESPTagHead", UDim2.new(0, 200, 0, 60), true, Vector3.new(0, 3.5, 0) local tl = Instance.new("TextLabel", bbg) tl.Name, tl.Size, tl.BackgroundTransparency, tl.TextColor3, tl.Font, tl.TextSize = "Label", UDim2.new(1, 0, 1, 0), 1, Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13 end
            local str = (EspNames and p.Name .. "\n" or "") .. (EspDistances and myRoot and "[" .. math.floor((myRoot.Position - root.Position).Magnitude) .. "m] " or "")
            if EspHealth then bbg.Label.TextColor3 = Color3.fromHSV(math.clamp(hum.Health / hum.MaxHealth, 0, 1) * 0.33, 1, 1) str = str .. "(" .. math.floor(hum.Health) .. " HP)" else bbg.Label.TextColor3 = Color3.fromRGB(255, 255, 255) end bbg.Label.Text = str
         else if bbg then bbg:Destroy() end end
         if EspLines and Drawing then
            local line = LinesContainer[p] or Drawing.new("Line") line.Thickness, line.Color, line.Transparency = 1.5, Color3.fromRGB(255, 255, 0), 1 LinesContainer[p] = line
            local scrPos, onScr = cam:WorldToViewportPoint(root.Position) if onScr then line.From, line.To, line.Visible = startPos, Vector2.new(scrPos.X, scrPos.Y), true else line.Visible = false end
         else if LinesContainer[p] then LinesContainer[p].Visible = false end end
      else local h = game.CoreGui:FindFirstChild("ChamsReal_" .. p.Name) if h then h:Destroy() end if root and root:FindFirstChild("ESPTagHead") then root.ESPTagHead:Destroy() end if LinesContainer[p] then LinesContainer[p].Visible = false end end
   end end
end)
game.Players.PlayerRemoving:Connect(function(p) local h = game.CoreGui:FindFirstChild("ChamsReal_" .. p.Name) if h then h:Destroy() end if LinesContainer[p] then LinesContainer[p]:Remove() LinesContainer[p] = nil end end)

local PlayerDropdown = Tabs["Aimbot"]:CreateDropdown({Name = "Chọn Player Mục Tiêu", Options = GetPlayerNames(), CurrentOption = "", MultipleOptions = false, Callback = function(O) SelectedTarget = game.Players:FindFirstChild(O[1]) end})
Tabs["Aimbot"]:CreateToggle({Name = "Bật Aimbot", CurrentValue = false, Callback = function(V) AimbotEnabled = V end})
Tabs["Aimbot"]:CreateToggle({Name = "FOV Circle", CurrentValue = false, Callback = function(V) FovEnabled = V end})
Tabs["Aimbot"]:CreateSlider({Name = "FOV Size", Range = {30, 500}, Increment = 5, CurrentValue = 100, Callback = function(V) FovRadius = V end})
Tabs["Aimbot"]:CreateDropdown({Name = "Aim Part", Options = {"Head", "HumanoidRootPart"}, CurrentOption = "Head", MultipleOptions = false, Callback = function(O) AimPart = O[1] end})
AddBtn(Tabs["Aimbot"], "Teleport", function() if SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.CFrame = SelectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5) end end)

local FovCircle = Drawing.new("Circle") FovCircle.Thickness, FovCircle.Color, FovCircle.Filled, FovCircle.Transparency, FovCircle.Visible = 1.5, Color3.fromRGB(0, 255, 255), false, 1, false
RunService.RenderStepped:Connect(function()
   local cam = workspace.CurrentCamera local centerScreen = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2) FovCircle.Position, FovCircle.Radius, FovCircle.Visible = centerScreen, FovRadius, FovEnabled
   if AimbotEnabled and SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild(AimPart) then
      local screenPos, onScreen = cam:WorldToViewportPoint(SelectedTarget.Character[AimPart].Position)
      if onScreen and (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude <= FovRadius then cam.CFrame = CFrame.new(cam.CFrame.Position, SelectedTarget.Character[AimPart].Position) end
   end
end)

Tabs["Misc"]:CreateSection("Tools")
Tabs["Misc"]:CreateToggle({Name = "Anti-Fling", CurrentValue = false, Callback = function(V)
   AntiFling = V if AntiFling then AntiFlingConnection = RunService.Stepped:Connect(function() for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and p.Character then for _, part in pairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide, part.Velocity, part.RotVelocity = false, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0) end end end end end) elseif AntiFlingConnection then AntiFlingConnection:Disconnect() end
end})
Tabs["Misc"]:CreateToggle({Name = "Fake Lag", CurrentValue = false, Callback = function(V)
   FakeLag = V if FakeLag then FakeLagConnection = RunService.Heartbeat:Connect(function() if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.Anchored = true task.wait(0.05) Player.Character.HumanoidRootPart.Anchored = false end end) else if FakeLagConnection then FakeLagConnection:Disconnect() end if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.Anchored = false end end
end})
Tabs["Misc"]:CreateToggle({Name = "Chat Bypass", CurrentValue = false, Callback = function(Value)
    ChatBypassEnabled = Value
    if ChatBypassEnabled then
        local function BypassText(t)
            local u, l, r = {A="𝖠",B="𝖡",C="𝖢",D="𝖣",E="𝖤",F="𝖥",G="𝖦",H="𝖧",I="𝖨",J="𝖩",K="𝖪",L="𝖫",M="𝖬",N="𝖭",O="𝖮",P="𝖯",Q="𝖰",R="𝖱",S="𝖲",T="𝖳",U="𝖴",V="𝖵",W="𝖶",X="𝖳",Y="𝖸",Z="𝖹"}, {a="𝖺",b="𝖻",c="𝖼",d="𝖣",e="𝖾",f="𝖿",g="𝖧",h="𝖨",i="𝗂",j="𝗃",k="𝗄",l="𝗅",m="𝗆",n="𝗇",o="𝗈",p="𝗉",q="𝗊",r="𝗋",s="𝗌",t="𝗍",u="𝗎",v="𝗏",w="𝗐",x="𝗑",y="𝗒",z="𝖓"}, ""
            for i = 1, #t do local c = t:sub(i, i) r = r .. (u[c] or l[c] or c) end return r
        end
        local TCS = game:GetService("TextChatService") if TCS.ChatVersion == Enum.ChatVersion.TextChatService then ChatBypassConnection = TCS.SendingMessage:Connect(function(m) m.Text = BypassText(m.Text) end) end
    else if ChatBypassConnection then ChatBypassConnection:Disconnect() ChatBypassConnection = nil end end
end})
AddBtn(Tabs["Misc"], "Force Reset", function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.Health = 0 end end)
AddBtn(Tabs["Misc"], "Tày's Aimbot", function() loadstring(game:HttpGet("https://pastebin.com/raw/XKJrA4iG"))() end)

Tabs["Info"]:CreateSection("User & Game Status")
Tabs["Info"]:CreateParagraph({Title = "User:", Content = Player.Name})
Tabs["Info"]:CreateParagraph({Title = "ID:", Content = tostring(Player.UserId)})
Tabs["Info"]:CreateParagraph({Title = "Age:", Content = tostring(Player.AccountAge) .. " days"})
Tabs["Info"]:CreateParagraph({Title = "Exec:", Content = (identifyexecutor or getexecutorname or function() return "Unknown" end)()})

local TargetGameName = "Loading..." pcall(function() TargetGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
Tabs["Info"]:CreateParagraph({Title = "Game:", Content = TargetGameName})
Tabs["Info"]:CreateParagraph({Title = "Game ID:", Content = tostring(game.PlaceId)})
local ServerCountParam = Tabs["Info"]:CreateParagraph({Title = "Players:", Content = tostring(#game.Players:GetPlayers())})

local function Upd() ServerCountParam:Set({Title = "Players:", Content = tostring(#game.Players:GetPlayers())}) end
game.Players.PlayerAdded:Connect(Upd) game.Players.PlayerRemoving:Connect(Upd)

local function UpdateAllDropdowns()
    pcall(function()
        local currentList = GetPlayerNames()
        if PlayerDropdown and PlayerDropdown.Refresh then PlayerDropdown:Refresh(currentList) end
        if SimpleTargetDropdown and SimpleTargetDropdown.Refresh then SimpleTargetDropdown:Refresh(currentList) end
    end)
end
game.Players.PlayerAdded:Connect(UpdateAllDropdowns) game.Players.PlayerRemoving:Connect(UpdateAllDropdowns)

Tabs["Credits"]:CreateLabel("Script by: Hmigh")
Tabs["Credits"]:CreateLabel("More update soon...")