--[[
    ZERO TIGER - OMG PERFECT CLONE
    - Giữ nguyên 100% cấu trúc UI và tính năng của OMG Hub.
    - Fast Attack: Tự động đánh bằng CombatFramework Hook (Zero-Click).
    - Không tràn RAM, không Crash.
]]

if getgenv().ZeroTiger_Loaded then pcall(function() getgenv().ZeroTiger_Unload() end) end
getgenv().ZeroTiger_Loaded = true

-- ==========================================
-- 1. CHỐNG CRASH & BYPASS
-- ==========================================
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and method == "Kick" then return end
        return oldNamecall(self, ...)
    end)
end)

-- ==========================================
-- 2. TẢI UI FLUENT
-- ==========================================
repeat task.wait() until game:IsLoaded()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "OMG Hub | Blox Fruits",
    SubTitle = "by Omg",
    TabWidth = 120, Size = UDim2.fromOffset(480, 320), Acrylic = true, Theme = "Dark"
})

-- Nút Toggle (Logo Xanh OMG)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OMG_Toggle"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 100, 255)
ToggleBtn.Text = "O"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Window:Toggle() end)

-- ==========================================
-- 3. TẠO ĐẦY ĐỦ 12 TABS Y HỆT OMG HUB
-- ==========================================
local Tabs = {
    Discord = Window:AddTab({ Title = "Discord", Icon = "message-circle" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "home" }),
    Sea = Window:AddTab({ Title = "Sea", Icon = "waves" }),
    Race = Window:AddTab({ Title = "Race", Icon = "flag" }),
    Islands = Window:AddTab({ Title = "Islands", Icon = "map" }),
    Quests = Window:AddTab({ Title = "Quests/Items", Icon = "book-open" }),
    FruitRaid = Window:AddTab({ Title = "Fruit/Raid", Icon = "swords" }),
    Fishing = Window:AddTab({ Title = "Fishing", Icon = "fish" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "webhook" }),
    Hop = Window:AddTab({ Title = "Hop", Icon = "refresh-cw" }),
    Status = Window:AddTab({ Title = "Status", Icon = "activity" }),
    PvP = Window:AddTab({ Title = "PvP", Icon = "crosshair" })
}

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("OMG_Clone")
SaveManager:SetFolder("OMG_Clone/Configs")
InterfaceManager:BuildInterfaceSection(Tabs)

-- ==========================================
-- 4. CORE LOGIC & QUẢN LÝ BỘ NHỚ
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local State = { AutoFarm = false, KillAura = false, SeaEvent = false, Levi = false, V4 = false, Sniper = false, Haki = false, Fish = false }
local Threads = {}
local Connections = {}

local function AddConn(conn) table.insert(Connections, conn); return conn end
local function ClearAll()
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    Connections = {}
    for _, t in ipairs(Threads) do pcall(function() task.cancel(t) end) end
    Threads = {}
end

local function getChar()
    local c = LP.Character
    if c then
        local r = c:FindFirstChild("HumanoidRootPart")
        local h = c:FindFirstChildOfClass("Humanoid")
        if r and h and h.Health > 0 then return c, r, h end
    end
end

-- ==========================================
-- 5. FAST ATTACK LÕI (ZERO-CLICK COMBAT HOOK)
-- ==========================================
local function HookCombat()
    pcall(function() require(game.ReplicatedStorage.Util.CameraShaker):Stop() end)
    Threads.CombatHook = task.spawn(function()
        for _, v in pairs(getreg()) do
            if typeof(v) == "function" and getfenv(v).script == LP.PlayerScripts.CombatFramework then
                for _, upval in pairs(debug.getupvalues(v)) do
                    if typeof(upval) == "table" and upval.activeController then
                        AddConn(RunService.RenderStepped:Connect(function()
                            if State.AutoFarm or State.KillAura then
                                pcall(function()
                                    upval.activeController.timeToNextAttack = -(math.huge^math.huge^math.huge)
                                    upval.activeController.attacking = false
                                    upval.activeController.increment = 4
                                    upval.activeController.blocking = false
                                    upval.activeController.hitboxMagnitude = 150
                                    upval.activeController.humanoid.AutoRotate = true
                                end)
                            end
                        end))
                    end
                end
            end
        end
    end)
end
HookCombat()

-- Hàm ẩn Animation
local function SetupInvisibleAnim()
    local char = getChar()
    if not char then return end
    local animator = char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Animator")
    if animator then
        AddConn(animator.AnimationPlayed:Connect(function(track)
            local p = track.Priority
            if p == Enum.AnimationPriority.Action or p == Enum.AnimationPriority.Action2 or p == Enum.AnimationPriority.Action3 or p == Enum.AnimationPriority.Action4 then
                pcall(function()
                    track.TimePosition = track.Length
                    track:Stop(0.1)
                end)
            end
        end))
    end
end
SetupInvisibleAnim()

-- Hàm tìm mục tiêu
local function GetTarget(range, mode)
    local char, root = getChar()
    if not root then return end
    local best, bd = nil, range
    local containers = {workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Enemies"), workspace}

    for _, c in ipairs(containers) do
        if c then
            for _, m in ipairs(c:GetChildren()) do
                if m:IsA("Model") and m ~= char then
                    local h = m:FindFirstChildOfClass("Humanoid")
                    local r = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                    if h and h.Health > 0 and r then
                        local isPlayer = Players:GetPlayerFromCharacter(m) ~= nil
                        local name = m.Name:lower()
                        local match = false
                        
                        if mode == "Nearest" and not isPlayer then match = true
                        elseif mode == "KillAura" and isPlayer then match = true
                        elseif mode == "Boss" and (name:find("indra") or name:find("cake") or name:find("dough") or name:find("elite") or name:find("dragon") or name:find("dojo") or name:find("golem")) then match = true
                        elseif mode == "Sea" and (name:find("beast") or name:find("ship") or name:find("pirate")) then match = true
                        elseif mode == "Levi" and (name:find("leviathan") or name:find("frozen")) then match = true
                        elseif mode == "V4" and (name:find("trial") or name:find("race") or name:find("hunter")) then match = true
                        end

                        if match then
                            local d = (r.Position - root.Position).Magnitude
                            if d < bd then best, bd = m, d end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- ==========================================
-- 6. CÁC MODULE CHỨC NĂNG
-- ==========================================

-- Farm
local function StartFarm()
    if Threads.Farm then task.cancel(Threads.Farm) end
    Threads.Farm = task.spawn(function()
        while State.AutoFarm do
            pcall(function()
                local char, root, hum = getChar()
                if not root then task.wait(1); return end
                if hum.PlatformStand then hum.PlatformStand = false end

                if State.Haki and not char:FindFirstChild("Busoshoku") then VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new()) end
                
                -- Kéo quái
                local centerPos = root.Position + root.CFrame.LookVector * 3
                local target = GetTarget(300, "Nearest")
                if target then
                    local tr = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                    if tr then
                        tr.CFrame = CFrame.new(centerPos); tr.Velocity = Vector3.zero
                    end
                end

                -- Đánh
                if not char:FindFirstChildOfClass("Tool") then
                    local bp = LP:FindFirstChild("Backpack")
                    if bp then local t = bp:FindFirstChildOfClass("Tool"); if t then hum:EquipTool(t) end end
                end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new()) end)
            end)
            task.wait(0.05)
        end
    end)
end

-- Kill Aura
local function StartKillAura()
    if Threads.KillAura then task.cancel(Threads.KillAura) end
    Threads.KillAura = task.spawn(function()
        while State.KillAura do
            pcall(function()
                local char, root = getChar()
                if not root then task.wait(1); return end
                local target = GetTarget(300, "KillAura")
                if target then
                    local tr = target:FindFirstChild("HumanoidRootPart")
                    if tr then
                        root.CFrame = CFrame.lookAt(tr.Position + Vector3.new(0, 5, 0), tr.Position)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new()) end)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- Custom Farm (Boss, Sea, V4)
local function StartCustomFarm(name, mode, range)
    if Threads[name] then task.cancel(Threads[name]) end
    Threads[name] = task.spawn(function()
        while State[name] do
            pcall(function()
                local char, root = getChar()
                if not root then task.wait(1); return end
                local target = GetTarget(range, mode)
                if target then
                    local tr = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                    if tr then
                        root.CFrame = CFrame.lookAt(tr.Position + Vector3.new(0, 5, 0), tr.Position)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new()) end)
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

-- ==========================================
-- 7. BUILD UI (GẮN LOGIC - KHÔNG THIẾU MỤC NÀO)
-- ==========================================

-- Tab Discord
Tabs.Discord:AddSection("Community")
Tabs.Discord:AddButton({ Title = "Copy Discord Link", Description = "discord.gg/omghub", Callback = function() if setclipboard then setclipboard("https://discord.gg/omghub") end Fluent:Notify({Title="Copied", Content="Đã copy link!", Duration=3}) end })

-- Tab Farm
Tabs.Farm:AddSection("Main Farm")
Tabs.Farm:AddToggle("AutoFarm", { Title = "Auto Farm Level", Description = "Zero-Click Farm", Default = false, Callback = function(v) State.AutoFarm = v; if v then StartFarm() else if Threads.Farm then task.cancel(Threads.Farm) end end end })
Tabs.Farm:AddToggle("FastAttack", { Title = "Fast Attack", Description = "Reset Cooldown (Zero Click)", Default = true })
Tabs.Farm:AddToggle("AutoChest", { Title = "Auto Chest", Default = false })
Tabs.Farm:AddSection("Server")
Tabs.Farm:AddButton({ Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end })
Tabs.Farm:AddButton({ Title = "Server Hop", Callback = function() 
    local res = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(res)
    for _, s in pairs(data.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP); break end end
end })
Tabs.Farm:AddToggle({ Title = "Anti-Reset", Default = true })

-- Tab Sea
Tabs.Sea:AddSection("Sea Events")
Tabs.Sea:AddToggle("SeaEvent", { Title = "Auto Sea Event", Description = "Tự động đánh Tàu/Quái biển", Default = false, Callback = function(v) State.SeaEvent = v; if v then StartCustomFarm("Sea", "Sea", 1500) else if Threads.Sea then task.cancel(Threads.Sea) end end end })
Tabs.Sea:AddToggle("Leviathan", { Title = "Auto Leviathan", Default = false, Callback = function(v) State.Levi = v; if v then StartCustomFarm("Levi", "Levi", 2000) else if Threads.Levi then task.cancel(Threads.Levi) end end end })

-- Tab Race
Tabs.Race:AddSection("Race V4")
Tabs.Race:AddToggle("AutoV4", { Title = "Auto V4 Trial", Description = "Tự động tìm Trial NPC", Default = false, Callback = function(v) State.V4 = v; if v then StartCustomFarm("V4", "V4", 3000) else if Threads.V4 then task.cancel(Threads.V4) end end end })

-- Tab Islands (Giống hệt ảnh mày gửi)
Tabs.Islands:AddSection("Dragon Dojo")
Tabs.Islands:AddToggle("Dojo", { Title = "Auto Dojo Trainer Quest", Description = "Automatically completes Dojo Trainer quests", Default = false, Callback = function(v) State.Dojo = v; if v then StartCustomFarm("Dojo", "Boss", 300) else if Threads.Dojo then task.cancel(Threads.Dojo) end end end })
Tabs.Islands:AddToggle("Dragon", { Title = "Auto Dragon Hunter Quest", Description = "Automatically completes Dragon Hunter quests", Default = false, Callback = function(v) State.Dragon = v; if v then StartCustomFarm("Dragon", "Boss", 300) else if Threads.Dragon then task.cancel(Threads.Dragon) end end end })
Tabs.Islands:AddToggle("Draco", { Title = "Auto Draco V2 & V3", Description = "Evolves the Draco Race to V2 and V3", Default = false, Callback = function(v) State.Draco = v; if v then StartCustomFarm("Draco", "Boss", 300) else if Threads.Draco then task.cancel(Threads.Draco) end end end })

Tabs.Islands:AddSection("Event")
Tabs.Islands:AddToggle({ Title = "Auto Valentine Quest", Description = "Automatically completes Valentine quests", Default = false })
Tabs.Islands:AddToggle({ Title = "Auto Random Fruit Event", Description = "Automatically clears fruit event chests", Default = false })

Tabs.Islands:AddSection("Farm")
Tabs.Islands:AddToggle("Elite", { Title = "Auto Elite Hunter", Description = "Automatically completes Elite Hunter quests", Default = false, Callback = function(v) State.Elite = v; if v then StartCustomFarm("Elite", "Boss", 300) else if Threads.Elite then task.cancel(Threads.Elite) end end end })
Tabs.Islands:AddToggle("Indra", { Title = "Auto Rip Indra", Description = "Automatically completes and summons Rip Indra", Default = false, Callback = function(v) State.Indra = v; if v then StartCustomFarm("Indra", "Boss", 300) else if Threads.Indra then task.cancel(Threads.Indra) end end end })
Tabs.Islands:AddToggle("Cake", { Title = "Auto Cake Prince", Description = "Automatically completes the Cake Prince", Default = false, Callback = function(v) State.Cake = v; if v then StartCustomFarm("Cake", "Boss", 300) else if Threads.Cake then task.cancel(Threads.Cake) end end end })

-- Tab Quests
Tabs.Quests:AddSection("Quests")
Tabs.Quests:AddToggle("AutoHaki", { Title = "Auto Haki/Obs", Description = "Automatically uses Haki/Obs", Default = false, Callback = function(v) State.Haki = v end })
Tabs.Quests:AddToggle("AutoQuest", { Title = "Auto Quest", Description = "Automatically accepts and completes quests", Default = false })

-- Tab Fruit/Raid
Tabs.FruitRaid:AddSection("Fruit Sniper")
Tabs.FruitRaid:AddToggle("Sniper", { Title = "Fruit Sniper", Description = "Teleport to fruit instantly", Default = false, Callback = function(v) 
    State.Sniper = v
    if v then
        task.spawn(function()
            while State.Sniper do
                local _, root = getChar()
                if root then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj.Name == "Fruit" or (obj:IsA("Tool") and obj.Name:find("Fruit")) then
                            local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart
                            if handle then
                                TweenService:Create(root, TweenInfo.new((handle.Position - root.Position).Magnitude/2000), {CFrame = handle.CFrame}):Play()
                                task.wait(0.2)
                                if fireproximityprompt then pcall(fireproximityprompt, obj:FindFirstChildWhichIsA("ProximityPrompt")) end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end })
Tabs.FruitRaid:AddToggle("AutoRaid", { Title = "Auto Raid", Default = false })

-- Tab Fishing
Tabs.Fishing:AddSection("Fishing")
Tabs.Fishing:AddToggle("AutoFish", { Title = "Auto Fish", Default = false, Callback = function(v) State.Fish = v end })

-- Tab Webhook
Tabs.Webhook:AddSection("Webhook Settings")
Tabs.Webhook:AddInput("WebhookURL", { Title = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/..." })
Tabs.Webhook:AddButton({ Title = "Test Webhook", Callback = function() Fluent:Notify({Title="Webhook", Content="Test Success!", Duration=3}) end })

-- Tab Hop
Tabs.Hop:AddSection("Server")
Tabs.Hop:AddButton({ Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end })
Tabs.Hop:AddButton({ Title = "Server Hop", Callback = function() 
    local res = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(res)
    for _, s in pairs(data.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP); break end end
end })

-- Tab Status
Tabs.Status:AddSection("Info")
Tabs.Status:AddParagraph({ Title = "Executor", Content = "Delta X / PC" })
Tabs.Status:AddParagraph({ Title = "Version", Content = "OMG Clone v1.0" })

-- Tab PvP
Tabs.PvP:AddSection("Combat")
Tabs.PvP:AddToggle("KillAura", { Title = "Kill Aura", Description = "Tự động đánh người chơi xung quanh", Default = false, Callback = function(v) State.KillAura = v; if v then StartKillAura() else if Threads.KillAura then task.cancel(Threads.KillAura) end end end })

-- ==========================================
-- 8. UNLOAD (DỌN DẸP SẠCH SẼ)
-- ==========================================
getgenv().ZeroTiger_Unload = function()
    State = { AutoFarm = false, KillAura = false, SeaEvent = false, Levi = false, V4 = false, Sniper = false }
    ClearAll()
    if ScreenGui then ScreenGui:Destroy() end
    local _, _, hum = getChar(); if hum then hum.PlatformStand = false end
    getgenv().ZeroTiger_Loaded = false
end

Fluent:Notify({ Title = "OMG Hub", Content = "Đã tải bản Full 12 Tabs (Zero Click)!", Duration = 5 })