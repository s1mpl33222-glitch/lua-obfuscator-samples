-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = getgenv and getgenv()
t1.value2 = 1141424
t1.value3 = v3
if not v3 then
    local value2 = t1.value2

    t1.value3 = _G or shared
    t1.value2 = value2
end
local value3 = t1.value3
while not value3.STK_UI do
    task.wait(0.1)
end
local STK_UI = value3.STK_UI
t1.value3 = "ScreenGui"
t1.value1 = STK_UI.ScreenGui
t1.value3 = "mainFrame"
local _ = STK_UI.mainFrame
t1.value3 = "sidebarHeaderText"
t1.value4 = STK_UI.sidebarHeaderText
t1.value3 = "CreateSidebarButton"
t1.value5 = STK_UI.CreateSidebarButton
t1.value3 = "CreateTab"
t1.value6 = STK_UI.CreateTab
t1.value3 = "ShowTab"
t1.value7 = STK_UI.ShowTab
t1.value3 = "CreateBlock"
t1.value8 = STK_UI.CreateBlock
t1.value3 = "EndBlock"
t1.value9 = STK_UI.EndBlock
t1.value3 = "CreateHeader"
t1.value2 = STK_UI.CreateHeader
t1.value2 = STK_UI.CreateButton
t1.value2 = STK_UI.CreateToggle
t1.value3 = "CreateSlider"
t1.value10 = "EggGame"
local value2 = t1.value2
local CreateSlider = STK_UI.CreateSlider
t1.value3 = "CreateDropdown"
t1.value11 = CreateSlider
local CreateDropdown = STK_UI.CreateDropdown
t1.value3 = "CreateKeybind"
t1.value12 = CreateDropdown
local CreateKeybind = STK_UI.CreateKeybind
t1.value3 = "CreateActiveKeybind"
t1.value13 = CreateKeybind
t1.value14 = STK_UI.CreateActiveKeybind
t1.value3 = "CreateColorPicker"
t1.value15 = STK_UI.CreateColorPicker
t1.value3 = "CreateNotification"
t2.value1 = STK_UI.CreateNotification
t2.value2 = game:GetService("Players").LocalPlayer
t2.value2:WaitForChild("PlayerGui")
t1.value3 = game:GetService("UserInputService")
t2.value3 = t1.value3
game:GetService("TweenService")
t1.value3 = game:GetService("VirtualInputManager")
t2.value4 = t1.value3
t1.value3 = game:GetService("RunService")
t2.value5 = t1.value3
game:GetService("Lighting")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

t1.value2 = "Text"
t1.value17 = ReplicatedStorage
t1.value3 = "Ride A Fish"
t1.value18 = "rbxassetid://101988819289766"
t1.value4.Text = "Ride A Fish"
t1.value5("Main", "rbxassetid://101988819289766")
t1.value3 = "Main"
t1.value18 = "WaitForChild"
t1.value6("Main")
t1.value18 = t1.value17.WaitForChild
t1.value3 = "Main"
t1.value7("Main")
t1.value18 = t1.value18(t1.value17, "EggGame", 15)
t1.value19 = {}
t1.value10 = "EggRequests"
t1.value20 = {}
t1.value21 = { "Common" }
t1.value22 = {}
t1.value16 = nil
t1.value23 = {}
t2.value6 = {
	EggGameFolder = t1.value18,
	EggRequests = t1.value16,
	EggTiersList = {
		"Common",
		"Coral",
		"Reef",
		"Tidal",
		"Deep",
		"Abyss",
		"Trench",
		"Sovereign",
		"Celestial",
		"Eternal",
		"CoralReef",
		"GlacialSpiral",
		"AmethystSpiral",
		"AzureCrown",
		"SolarOrbit",
		"Spikey",
		"Mamba",
		"Inferno"
	},
	DisplayEggTiers = {},
	DisplayToRawTier = t1.value19,
	PromptHoldCache = t1.value20,
	IgnoredTokens = t1.value23,
	IgnoredEggs = t1.value22,
	CurrentTargetEgg = nil,
	TargetEggStartTime = 0,
	AutoFarmEggs = false,
	SelectedEggTiers = t1.value21,
	AutoDeliverEgg = false,
	AutoStoreEgg = false,
	AutoHatch = false,
	AutoEquipBest = false,
	AutoCollectTokens = false,
	AutoCollectBossEgg = false,
	AntiStun = false,
	InstantPrompt = false
}
t2.value6.EggRequests = t2.value6.EggGameFolder and t2.value6.EggGameFolder:WaitForChild("Requests", 15)
t1.value3 = "ipairs"
function t1.value10(p1)
    return p1:gsub("(%l)(%u)", "%1 %2")
end
t1.value2 = ipairs
for _, v14 in t1.value2(t2.value6.EggTiersList) do
    t1.value24 = t1.value10(v14)
    table.insert(t2.value6.DisplayEggTiers, t1.value24)
    t1.value2 = t2.value6.DisplayToRawTier
    t1.value2[t1.value24] = v14
end
function t1.value2()
    local Character = t2.value2.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end
t2.value7 = t1.value2
local function v15()
    local PlayerPot = t2.value2:GetAttribute("PlayerPot")
    local v45 = PlayerPot and workspace:FindFirstChild(PlayerPot)

    if not v45 then
        for _, child in ipairs(workspace:GetChildren()) do
            if child:GetAttribute("OwnerUserId") == t2.value2.UserId and child.Name:find("Player Pot") then
                return child
            end
        end
    end

    return v45
end
function t2.value8()
    return t2.value2:GetAttribute("InSaveZone") == true
end
function t1.value2()
    local ActiveTokens = workspace:FindFirstChild("ActiveTokens")

    if not ActiveTokens then
        return {}
    end

    local elapsed = os.clock()
    local t3 = {}
    local GetChildren = ActiveTokens.GetChildren

    for _, v in ipairs(GetChildren(ActiveTokens)) do
        if v:IsA("Model") and not v:GetAttribute("Consumed") and (not t2.value6.IgnoredTokens[v] or elapsed > t2.value6.IgnoredTokens[v]) then
            local v56 = v:FindFirstChild("TOKEN", true) or v:FindFirstChildWhichIsA("BasePart", true)

            if v56 then
                table.insert(t3, {
					model = v,
					part = v56
				})
            end
        end
    end

    return t3
end
t2.value9 = t1.value2
local function v16()
    local v57 = t2.value9()

    if #v57 == 0 then
        return
    end

    local v58 = t2.value7()
    local Character = t2.value2.Character

    if not v58 or not Character then
        return
    end

    local CFrame2 = v58.CFrame

    for _, v in ipairs(v57) do
        if not t2.value6.AutoCollectTokens then
            break
        end

        if v.model.Parent and not v.model:GetAttribute("Consumed") then
            v58.AssemblyLinearVelocity = Vector3.zero
            Character:PivotTo(v.part.CFrame)
            task.wait(1)

            if v.model.Parent and not v.model:GetAttribute("Consumed") then
                t2.value6.IgnoredTokens[v.model] = os.clock() + 30
            end
        end
    end

    local v63 = v58

    if v58 then
        v63 = Character and v58.Parent
    end

    if v63 then
        v58.AssemblyLinearVelocity = Vector3.zero
        Character:PivotTo(CFrame2)
        task.wait(0.5)
    end
end
function t1.value2(p2)
    if not t2.value6.EggRequests then
        return
    end

    pcall(function()
        t2.value6.EggRequests:FireServer("StoreEgg")
    end)

    if not p2 then
        return
    end

    local elapsed = os.clock()

    while true do
        local v66 = false

        if t2.value2:GetAttribute("HasSeaEgg") == true then
            v66 = os.clock() - elapsed < 2
        end

        if not v66 then
            break
        end

        task.wait(0.2)
    end

    if t2.value2:GetAttribute("HasSeaEgg") == true then
        local CarriedEggId = t2.value2:GetAttribute("CarriedEggId")

        if type(CarriedEggId) == "string" then
            pcall(function()
                t2.value6.EggRequests:FireServer("DropCarriedEgg", CarriedEggId)
            end)
            task.wait(0.3)
        end
    end
end
t2.value10 = t1.value2
local function v17(p3)
    if #p3 == 0 then
        return nil
    end
    local EggRuntime = workspace:FindFirstChild("EggRuntime")
    local v70 = EggRuntime and EggRuntime:FindFirstChild("WildEggs")
    if not v70 then
        return nil
    end
    local v71 = t2.value7()
    if not v71 then
        return nil
    end
    local Position = v71.Position
    local v73
    local n1 = 1e999
    local clock = os.clock
    local GetChildren = v70.GetChildren
    local v77 = clock()
    for _, v in ipairs(GetChildren(v70)) do
        if not t2.value6.IgnoredEggs[v] or v77 > t2.value6.IgnoredEggs[v] then
            local EggTier = v:GetAttribute("EggTier")

            if EggTier and table.find(p3, EggTier) then
                local Magnitude = (v:GetPivot().Position - Position).Magnitude

                if Magnitude < n1 then
                    v73 = v
                    n1 = Magnitude
                end
            end
        end
    end

    return v73
end
local function v18(p4)
    if not p4:IsA("ProximityPrompt") then
        return
    end

    if t2.value6.InstantPrompt then
        if t2.value6.PromptHoldCache[p4] == nil then
            t2.value6.PromptHoldCache[p4] = p4.HoldDuration
        end

        p4.HoldDuration = 0

        return
    end

    if t2.value6.PromptHoldCache[p4] ~= nil then
        p4.HoldDuration = t2.value6.PromptHoldCache[p4]
        t2.value6.PromptHoldCache[p4] = nil
    end
end
t1.value2 = workspace.DescendantAdded
t1.value2:Connect(function(p5)
    if p5:IsA("ProximityPrompt") then
        task.defer(v18, p5)
    end
end)

local function v19()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            v18(descendant)
        end
    end
end
t1.value2 = task.spawn
function t1.value22()
    while true do
        local v86 = t2.value7()
        local Character = t2.value2.Character
        local v88 = t2.value2:GetAttribute("HasSeaEgg") == true
        local v89 = t2.value2:GetAttribute("EggSecured") == true
        local v90 = v86
        if v86 then
            v90 = Character and v88 and t2.value6.AutoFarmEggs or t2.value6.AutoCollectBossEgg
        end
        if v90 then
            t2.value6.CurrentTargetEgg = nil
            t2.value6.TargetEggStartTime = 0

            if not v89 then
                local v91 = v15()
                local v92 = v91 and v91:FindFirstChild("BillboardStats")

                if v92 then
                    v86.AssemblyLinearVelocity = Vector3.zero
                    Character:PivotTo(CFrame.new(v92.Position + Vector3.new(0, 6, 0)))
                end

                task.wait(1)
            else
                t2.value10(true)
            end
        else
            local v93 = v86

            if v86 then
                v93 = Character and not v88
            end

            if v93 then
                if t2.value6.AutoCollectTokens and #t2.value9() > 0 then
                    t2.value6.CurrentTargetEgg = nil
                    t2.value6.TargetEggStartTime = 0
                    v16()
                else
                    local AutoCollectBossEgg = t2.value6.AutoCollectBossEgg

                    if AutoCollectBossEgg then
                        local KrakenBossRuntime = workspace:FindFirstChild("KrakenBossRuntime")

                        AutoCollectBossEgg = (KrakenBossRuntime and KrakenBossRuntime:FindFirstChild("EGG KRAKEN GLORY")) ~= nil
                    end

                    if AutoCollectBossEgg then
                        t2.value6.CurrentTargetEgg = nil
                        t2.value6.TargetEggStartTime = 0

                        local KrakenBossRuntime = workspace:FindFirstChild("KrakenBossRuntime")
                        local v97 = KrakenBossRuntime and KrakenBossRuntime:FindFirstChild("EGG KRAKEN GLORY")

                        if v97 and v97.Parent then
                            v86.AssemblyLinearVelocity = Vector3.zero
                            Character:PivotTo(v97:GetPivot() + Vector3.new(0, 3, 0))
                            task.wait(0.2)

                            local ProximityPrompt = v97:FindFirstChildWhichIsA("ProximityPrompt", true)

                            if ProximityPrompt and ProximityPrompt.Enabled then
                                local HoldDuration = ProximityPrompt.HoldDuration

                                ProximityPrompt.HoldDuration = 0

                                local E = Enum.KeyCode.E
                                local _game = game

                                t2.value4:SendKeyEvent(true, E, false, _game)
                                task.wait(0.05)
                                t2.value4:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                task.wait(0.1)

                                if ProximityPrompt and ProximityPrompt.Parent then
                                    ProximityPrompt.HoldDuration = HoldDuration
                                end
                            end

                            task.wait(0.4)
                        end
                    elseif t2.value6.AutoFarmEggs and #t2.value6.SelectedEggTiers > 0 then
                        local v102 = v17(t2.value6.SelectedEggTiers)

                        if v102 and v102.Parent then
                            if v102 ~= t2.value6.CurrentTargetEgg then
                                t2.value6.CurrentTargetEgg = v102
                                t2.value6.TargetEggStartTime = os.clock()
                            end

                            if os.clock() - t2.value6.TargetEggStartTime >= 4 then
                                t2.value6.IgnoredEggs[v102] = os.clock() + 30
                                t2.value6.CurrentTargetEgg = nil
                                t2.value6.TargetEggStartTime = 0
                                task.wait(0.1)
                            else
                                v86.AssemblyLinearVelocity = Vector3.zero
                                Character:PivotTo(v102:GetPivot() + Vector3.new(0, 3, 0))
                                task.wait(0.2)

                                local ProximityPrompt = v102:FindFirstChildWhichIsA("ProximityPrompt", true)

                                if ProximityPrompt and ProximityPrompt.Enabled then
                                    local HoldDuration = ProximityPrompt.HoldDuration

                                    ProximityPrompt.HoldDuration = 0

                                    local E = Enum.KeyCode.E
                                    local _game = game

                                    t2.value4:SendKeyEvent(true, E, false, _game)
                                    task.wait(0.05)

                                    local E2 = Enum.KeyCode.E
                                    local _game2 = game

                                    t2.value4:SendKeyEvent(false, E2, false, _game2)
                                    task.wait(0.1)

                                    if ProximityPrompt and ProximityPrompt.Parent then
                                        ProximityPrompt.HoldDuration = HoldDuration
                                    end
                                end

                                task.wait(0.4)
                            end
                        else
                            t2.value6.CurrentTargetEgg = nil
                            t2.value6.TargetEggStartTime = 0
                            task.wait(1)
                        end
                    else
                        t2.value6.CurrentTargetEgg = nil
                        t2.value6.TargetEggStartTime = 0
                        task.wait(1)
                    end
                end
            else
                t2.value6.CurrentTargetEgg = nil
                t2.value6.TargetEggStartTime = 0
                task.wait(1)
            end
        end
        task.wait(0.2)
    end
end
t1.value2(t1.value22)
task.spawn(function()
    while true do
        local AutoDeliverEgg = t2.value6.AutoDeliverEgg

        if AutoDeliverEgg then
            AutoDeliverEgg = not t2.value6.AutoFarmEggs and not t2.value6.AutoCollectBossEgg
        end

        if AutoDeliverEgg and (t2.value2:GetAttribute("HasSeaEgg") == true and t2.value2:GetAttribute("EggSecured") ~= true) then
            local v110 = t2.value7()
            local Character = t2.value2.Character
            local v112 = v15()
            local v113 = v112 and v112:FindFirstChild("BillboardStats")

            if v110 and (Character and v113) then
                v110.AssemblyLinearVelocity = Vector3.zero
                Character:PivotTo(CFrame.new(v113.Position + Vector3.new(0, 6, 0)))
            end
        end

        task.wait(0.15)
    end
end)
task.spawn(function()
    while true do
        local AutoStoreEgg = t2.value6.AutoStoreEgg

        if AutoStoreEgg then
            AutoStoreEgg = not t2.value6.AutoFarmEggs and not t2.value6.AutoCollectBossEgg
        end

        if AutoStoreEgg and (t2.value2:GetAttribute("HasSeaEgg") == true and t2.value2:GetAttribute("EggSecured") == true) then
            t2.value10(false)
        end

        task.wait(0.5)
    end
end)
task.spawn(function()
    while true do
        local AutoHatch = t2.value6.AutoHatch

        if AutoHatch then
            AutoHatch = t2.value6.EggRequests and t2.value8()
        end

        if AutoHatch then
            local v116 = v15()

            if v116 then
                for _, descendant in ipairs(v116:GetDescendants()) do
                    local v119 = descendant
                    local v120 = v119:IsA("BasePart")

                    if v120 then
                        v120 = v119:GetAttribute("HatchSlot") and v119:GetAttribute("Status") == "Ready"
                    end

                    if v120 then
                        pcall(function()
                            t2.value6.EggRequests:FireServer("HatchFromUI", v119:GetAttribute("HatchSlot"))
                        end)
                    end
                end
            end
        end

        task.wait(0.5)
    end
end)
task.spawn(function()
    while true do
        if t2.value6.AutoEquipBest and t2.value6.EggRequests then
            pcall(function()
                t2.value6.EggRequests:FireServer("EquipBest")
            end)
            task.wait(60)
        else
            task.wait(1)
        end
    end
end)
task.spawn(function()
    while true do
        if t2.value6.AntiStun then
            if t2.value2:GetAttribute("BombStunUntil") then
                t2.value2:SetAttribute("BombStunUntil", 0)
            end

            if t2.value2:GetAttribute("BombSlowUntil") then
                t2.value2:SetAttribute("BombSlowUntil", 0)
            end

            if t2.value2:GetAttribute("BombSlowMultiplier") then
                t2.value2:SetAttribute("BombSlowMultiplier", 1)
            end
        end

        task.wait(0.1)
    end
end)
t1.value25 = "Select Egg"
t1.value8("Auto Farm")
value2("Enable", function(p6)
    t2.value6.AutoFarmEggs = p6
    t2.value6.CurrentTargetEgg = nil
    t2.value6.TargetEggStartTime = 0
end)

local DisplayEggTiers = t2.value6.DisplayEggTiers
t1.value22 = "Text"
t1.value27 = { "Common" }
t1.value12({
	Text = "Select Egg",
	List = DisplayEggTiers,
	Default = t1.value27,
	Multi = true,
	Callback = function(p7)
    local t4 = {}
    local _ipairs = ipairs

    if not p7 then
        p7 = {}
    end

    for _, v43 in _ipairs(p7) do
        table.insert(t4, t2.value6.DisplayToRawTier[v43] or v43)
    end

    t2.value6.SelectedEggTiers = t4
end
})
function t1.value22(p8)
    t2.value6.AutoDeliverEgg = p8
end
t1.value9()
t1.value8("Auto Play")
value2("Auto Deliver Egg", t1.value22)
value2("Auto Store Egg", function(p9)
    t2.value6.AutoStoreEgg = p9
end)
value2("Auto Hatch Egg", function(p10)
    t2.value6.AutoHatch = p10
end)
value2("Auto Equip Best Fish", function(p11)
    t2.value6.AutoEquipBest = p11

    if p11 then
        p11 = t2.value6.EggRequests
    end

    if p11 then
        pcall(function()
            t2.value6.EggRequests:FireServer("EquipBest")
        end)
    end
end)
value2("Auto Collect Tokens", function(p12)
    t2.value6.AutoCollectTokens = p12
end)
value2("Auto Collect Boss Egg", function(p13)
    t2.value6.AutoCollectBossEgg = p13
end)
t1.value9()
t1.value8("Misc")
value2("Anti Stun", function(p14)
    t2.value6.AntiStun = p14
end)
value2("Instant Interact", function(p15)
    t2.value6.InstantPrompt = p15
    v19()
end)
t1.value9()
t1.value22 = "rbxassetid://104433470689984"
t1.value5("Movement", "rbxassetid://104433470689984")
t1.value6("Movement")
t1.value7("Movement")
t1.value22 = nil
t1.value8("Speed")
t2.value11 = {
	SpeedHumanoid = t1.value22,
	SpeedRootPart = nil,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil
}
local function v21()
    local connection = t2.value5.Heartbeat:Connect(function()
        if not t2.value11.SpeedRootPart or not t2.value11.SpeedRootPart.Parent then
            return
        end

        if t2.value11.SpeedIsEnabled then
            if not t2.value11.SpeedHumanoid then
                return
            end

            local MoveDirection = t2.value11.SpeedHumanoid.MoveDirection

            if MoveDirection.Magnitude > 0 then
                t2.value11.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * t2.value11.SpeedValue, t2.value11.SpeedRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * t2.value11.SpeedValue)

                return
            end

            t2.value11.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, t2.value11.SpeedRootPart.AssemblyLinearVelocity.Y, 0)
        end
    end)

    return function()
        connection:Disconnect()
    end
end
local value2_2 = t2.value2
function t1.value25(p16)
    t2.value11.SpeedHumanoid = p16:WaitForChild("Humanoid")
    t2.value11.SpeedRootPart = p16:WaitForChild("HumanoidRootPart")

    if t2.value11.SpeedIsEnabled then
        if t2.value11.SpeedStopCallback then
            t2.value11.SpeedStopCallback()
        end

        t2.value11.SpeedStopCallback = v21()
    end
end
if value2_2.Character then
    task.spawn(t1.value25, t2.value2.Character)
end
t1.value26 = "Enable"
t1.value2 = t2.value2.CharacterAdded
t1.value2.Connect(t1.value2, t1.value25)
t1.value14({
	Text = "Enable",
	Callback = function(p17)
    if p17 == t2.value11.SpeedIsEnabled then
        return
    end

    t2.value11.SpeedIsEnabled = p17

    if t2.value11.SpeedStopCallback then
        t2.value11.SpeedStopCallback()
        t2.value11.SpeedStopCallback = nil
    end

    if t2.value11.SpeedIsEnabled then
        t2.value11.SpeedStopCallback = v21()
        t2.value1("Module Toggled", "Speed has been", 1, "Enabled")

        return
    end

    t2.value1("Module Toggled", "Speed has been", 1, "Disabled")
end
})
local SpeedValue = t2.value11.SpeedValue
t1.value11({
	Text = "Speed",
	Min = 16,
	Max = 300,
	Default = SpeedValue,
	Callback = function(p18)
    t2.value11.SpeedValue = p18
end
})
t1.value9()
t1.value8("Fly")
t1.value26 = "FlyRootPart"
local Space = Enum.KeyCode.Space
local LeftShift = Enum.KeyCode.LeftShift
t2.value12 = {
	FlyCharacter = nil,
	FlyRootPart = nil,
	FlyIsEnabled = false,
	FlySpeed = 16,
	FlyVerticalSpeed = 25,
	FlyStopCallback = nil,
	FlyUpKey = Space,
	FlyDownKey = LeftShift
}
function t1.value2()
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.P = 1250
    BodyVelocity.Parent = t2.value12.FlyRootPart
    local connection = t2.value5.Heartbeat:Connect(function()
        if not t2.value12.FlyRootPart or not t2.value12.FlyRootPart.Parent then
            BodyVelocity.Velocity = Vector3.zero

            return
        end

        if t2.value12.FlyIsEnabled then
            local vector3 = Vector3.new()

            if t2.value3:IsKeyDown(t2.value12.FlyUpKey) then
                vector3 += Vector3.new(0, t2.value12.FlyVerticalSpeed, 0)
            end

            if t2.value3:IsKeyDown(t2.value12.FlyDownKey) then
                vector3 -= Vector3.new(0, t2.value12.FlyVerticalSpeed, 0)
            end

            local CurrentCamera = workspace.CurrentCamera
            local LookVector = CurrentCamera.CFrame.LookVector
            local RightVector = CurrentCamera.CFrame.RightVector
            local vector3_2 = Vector3.new(LookVector.X, 0, LookVector.Z)
            local vector3_3 = Vector3.new(RightVector.X, 0, RightVector.Z)
            local v215 = vector3_2.Magnitude > 0 and vector3_2.Unit

            if not v215 then
                v215 = Vector3.zero
            end

            local v216 = vector3_3.Magnitude > 0 and vector3_3.Unit

            if not v216 then
                v216 = Vector3.zero
            end

            if t2.value3:IsKeyDown(Enum.KeyCode.W) then
                vector3 += v215 * t2.value12.FlySpeed
            end

            if t2.value3:IsKeyDown(Enum.KeyCode.S) then
                vector3 -= v215 * t2.value12.FlySpeed
            end

            if t2.value3:IsKeyDown(Enum.KeyCode.A) then
                vector3 -= v216 * t2.value12.FlySpeed
            end

            if t2.value3:IsKeyDown(Enum.KeyCode.D) then
                vector3 += v216 * t2.value12.FlySpeed
            end

            BodyVelocity.Velocity = vector3

            return
        end

        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end)

    return function()
        connection:Disconnect()
        BodyVelocity:Destroy()
    end
end
t2.value13 = t1.value2
function t1.value26(p19)
    t2.value12.FlyCharacter = p19

    local WaitForChild = p19.WaitForChild

    t2.value12.FlyRootPart = WaitForChild(p19, "HumanoidRootPart")

    if t2.value12.FlyIsEnabled then
        if t2.value12.FlyStopCallback then
            t2.value12.FlyStopCallback()
        end

        t2.value12.FlyStopCallback = t2.value13()
    end
end
if t2.value2.Character then
    task.spawn(t1.value26, t2.value2.Character)
end
t1.value2 = t2.value2.CharacterAdded
t1.value30 = "Enable"
t1.value27 = "Connect"
t1.value2:Connect(t1.value26)
t1.value27 = {
	Text = "Enable",
	Callback = function(p20)
    if p20 == t2.value12.FlyIsEnabled then
        return
    end

    t2.value12.FlyIsEnabled = p20

    if t2.value12.FlyStopCallback then
        t2.value12.FlyStopCallback()
        t2.value12.FlyStopCallback = nil
    end

    if t2.value12.FlyIsEnabled then
        t2.value12.FlyStopCallback = t2.value13()
        t2.value1("Module Toggled", "Fly has been", 1, "Enabled")

        return
    end

    t2.value1("Module Toggled", "Fly has been", 1, "Disabled")
end
}
t1.value30 = "Vertical Fly Keybind"
t1.value14(t1.value27)
t1.value30 = "Fly Speed"
t1.value12({
	Text = "Vertical Fly Keybind",
	List = {
		"Space/Shift",
		"Space/LeftControl",
		"Q/E"
	},
	Default = "Space/Shift",
	Callback = function(p21)
    if p21 == "Space/Shift" then
        local Space2 = Enum.KeyCode.Space

        t2.value12.FlyUpKey = Space2
        t2.value12.FlyDownKey = Enum.KeyCode.LeftShift

        return
    end

    if p21 == "Space/LeftControl" then
        local Space3 = Enum.KeyCode.Space

        t2.value12.FlyUpKey = Space3
        t2.value12.FlyDownKey = Enum.KeyCode.LeftControl

        return
    end

    if p21 == "Q/E" then
        local Q = Enum.KeyCode.Q

        t2.value12.FlyUpKey = Q
        t2.value12.FlyDownKey = Enum.KeyCode.E
    end
end
})
t1.value27 = {
	Text = "Fly Speed",
	Min = 16,
	Max = 300,
	Default = t2.value12.FlySpeed,
	Decimals = 1,
	Callback = function(p22)
    t2.value12.FlySpeed = p22
end
}
t1.value11(t1.value27)

local FlyVerticalSpeed = t2.value12.FlyVerticalSpeed
t1.value11({
	Text = "Vertical Fly Speed",
	Min = 25,
	Max = 500,
	Default = FlyVerticalSpeed,
	Decimals = 1,
	Callback = function(p23)
    t2.value12.FlyVerticalSpeed = p23
end
})
t1.value9()
t1.value30 = "InfJumpHumanoid"
t1.value8()
t2.value14 = {
	InfJumpCharacter = nil,
	InfJumpHumanoid = nil,
	InfJumpIsEnabled = false,
	InfJumpStopCallback = nil
}
t1.value21 = t2.value2
function t1.value30(p24)
    t2.value14.InfJumpCharacter = p24

    local WaitForChild = p24.WaitForChild

    t2.value14.InfJumpHumanoid = WaitForChild(p24, "Humanoid")

    if t2.value14.InfJumpIsEnabled then
        if t2.value14.InfJumpStopCallback then
            t2.value14.InfJumpStopCallback()
        end

        local value14 = t2.value14
        local connection = t2.value3.JumpRequest:Connect(function()
            if not t2.value14.InfJumpCharacter or not t2.value14.InfJumpCharacter.Parent then
                return
            end

            if t2.value14.InfJumpIsEnabled and t2.value14.InfJumpHumanoid then
                t2.value14.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        function value14.InfJumpStopCallback()
            connection:Disconnect()
        end
    end
end
if t1.value21.Character then
    task.spawn(t1.value30, t2.value2.Character)
end
t2.value2.CharacterAdded:Connect(t1.value30)
t1.value14({
	Text = "Infinite Jump",
	Callback = function(p25)
    if p25 == t2.value14.InfJumpIsEnabled then
        return
    end

    t2.value14.InfJumpIsEnabled = p25

    if t2.value14.InfJumpStopCallback then
        t2.value14.InfJumpStopCallback()
        t2.value14.InfJumpStopCallback = nil
    end

    if t2.value14.InfJumpIsEnabled then
        local value14 = t2.value14
        local connection = t2.value3.JumpRequest:Connect(function()
            if not t2.value14.InfJumpCharacter or not t2.value14.InfJumpCharacter.Parent then
                return
            end

            if t2.value14.InfJumpIsEnabled and t2.value14.InfJumpHumanoid then
                t2.value14.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        function value14.InfJumpStopCallback()
            connection:Disconnect()
        end

        t2.value1("Module Toggled", "Infinite Jump has been", 1, "Enabled")

        return
    end

    t2.value1("Module Toggled", "Infinite Jump has been", 1, "Disabled")
end
})
t1.value21 = "NoclipCharacter"
t1.value28 = false
t1.value9()
t1.value8()
t2.value15 = {
	NoclipCharacter = nil,
	NoclipIsEnabled = t1.value28,
	NoclipStopCallback = nil,
	NoclipParts = {},
	NoclipOriginalCanCollide = {},
	NoclipDescendantConnection = nil
}
local function v27()
    table.clear(t2.value15.NoclipParts)

    if not t2.value15.NoclipCharacter then
        return
    end

    table.clear(t2.value15.NoclipOriginalCanCollide)

    for _, descendant in ipairs(t2.value15.NoclipCharacter:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(t2.value15.NoclipParts, descendant)
            t2.value15.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
        end
    end
end
local value2_3 = t2.value2
function t1.value28(p26)
    t2.value15.NoclipCharacter = p26
    v27()

    if t2.value15.NoclipDescendantConnection then
        t2.value15.NoclipDescendantConnection:Disconnect()
    end

    if t2.value15.NoclipRemovingConnection then
        t2.value15.NoclipRemovingConnection:Disconnect()
    end

    t2.value15.NoclipDescendantConnection = p26.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            table.insert(t2.value15.NoclipParts, descendant)
            t2.value15.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
        end
    end)
    t2.value15.NoclipRemovingConnection = p26.DescendantRemoving:Connect(function(descendant)
        if not descendant:IsA("BasePart") then
            return
        end

        local v224 = table.find(t2.value15.NoclipParts, descendant)

        if v224 then
            table.remove(t2.value15.NoclipParts, v224)
        end

        t2.value15.NoclipOriginalCanCollide[descendant] = nil
    end)

    if t2.value15.NoclipIsEnabled then
        if t2.value15.NoclipStopCallback then
            t2.value15.NoclipStopCallback()
        end
        local value15 = t2.value15
        local connection = t2.value5.Stepped:Connect(function()
            if not t2.value15.NoclipCharacter or not t2.value15.NoclipCharacter.Parent then
                return
            end

            if t2.value15.NoclipIsEnabled then
                for _, v in ipairs(t2.value15.NoclipParts) do
                    v.CanCollide = false
                end
            end
        end)
        function value15.NoclipStopCallback()
            connection:Disconnect()

            if t2.value15.NoclipCharacter and t2.value15.NoclipCharacter.Parent then
                for _, v in ipairs(t2.value15.NoclipParts) do
                    if v and v.Parent then
                        local v229 = t2.value15.NoclipOriginalCanCollide[v]

                        if v229 ~= nil then
                            v.CanCollide = v229
                        end
                    end
                end
            end
        end
    end
end
if value2_3.Character then
    task.spawn(t1.value28, t2.value2.Character)
end
t1.value29 = "IsDistanceEnabled"
t1.value2 = t2.value2.CharacterAdded
t1.value2:Connect(t1.value28)
t1.value14({
	Text = "Noclip",
	Callback = function(p27)
    if p27 == t2.value15.NoclipIsEnabled then
        return
    end

    t2.value15.NoclipIsEnabled = p27

    if t2.value15.NoclipStopCallback then
        t2.value15.NoclipStopCallback()
        t2.value15.NoclipStopCallback = nil
    end

    if t2.value15.NoclipIsEnabled then
        local value15 = t2.value15
        local connection = t2.value5.Stepped:Connect(function()
            if not t2.value15.NoclipCharacter or not t2.value15.NoclipCharacter.Parent then
                return
            end

            if t2.value15.NoclipIsEnabled then
                for _, v in ipairs(t2.value15.NoclipParts) do
                    v.CanCollide = false
                end
            end
        end)
        function value15.NoclipStopCallback()
            connection:Disconnect()

            if t2.value15.NoclipCharacter and t2.value15.NoclipCharacter.Parent then
                for _, v in ipairs(t2.value15.NoclipParts) do
                    if v and v.Parent then
                        local v234 = t2.value15.NoclipOriginalCanCollide[v]

                        if v234 ~= nil then
                            v.CanCollide = v234
                        end
                    end
                end
            end
        end
        t2.value1("Module Toggled", "Noclip has been", 1, "Enabled")

        return
    end

    t2.value1("Module Toggled", "Noclip has been", 1, "Disabled")
end
})
t1.value9()
local t5 = {
	Text = "Mouse TP",
	Callback = function()
    local Mouse = t2.value2:GetMouse()
    local v163 = t2.value2.Character or t2.value2.CharacterAdded:Wait()

    if not v163 then
        return
    end

    v163:PivotTo(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
end
}
t1.value8()
t1.value13(t5)
t1.value9()
t1.value5("Esp", "rbxassetid://92867222908387")
t1.value6("Esp")
t1.value7("Esp")
t1.value8("Egg ESP")

local color3 = Color3.fromRGB(0, 255, 200)

t2.value16 = {
	IsEnabled = false,
	IsChamsEnabled = false,
	IsNameEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 500,
	ESPColor = color3
}
local function v31()
    local t6 = {}
    local EggRuntime = workspace:FindFirstChild("EggRuntime")

    if EggRuntime then
        local t7 = {
			EggRuntime:FindFirstChild("WildEggs"),
			EggRuntime:FindFirstChild("DroppedEggs")
		}

        for _, v in ipairs(t7) do
            if v then
                for _, child in ipairs(v:GetChildren()) do
                    if child:IsA("Model") and child:GetAttribute("EggId") then
                        table.insert(t6, child)
                    end
                end
            end
        end
    end

    local KrakenBossRuntime = workspace:FindFirstChild("KrakenBossRuntime")

    if KrakenBossRuntime then
        local v172 = KrakenBossRuntime:FindFirstChild("EGG KRAKEN GLORY")

        if v172 and v172:IsA("Model") then
            table.insert(t6, v172)
        end
    end

    return t6
end
local function v32()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant.Name == "EggESP_Highlight" or descendant.Name == "EggESP_Billboard" then
            descendant:Destroy()
        end
    end
end
function t1.value2(p28)
    local EggESP_Highlight = p28:FindFirstChild("EggESP_Highlight")
    local EggESP_Billboard = p28:FindFirstChild("EggESP_Billboard")

    if EggESP_Highlight then
        EggESP_Highlight:Destroy()
    end

    if EggESP_Billboard then
        EggESP_Billboard:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "EggESP_Highlight"
    Highlight.FillColor = t2.value16.ESPColor
    Highlight.FillTransparency = not t2.value16.IsChamsEnabled and 1 or 0.5
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineTransparency = not t2.value16.IsEnabled and 1 or 0
    Highlight.Enabled = false
    Highlight.Parent = p28

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "EggESP_Billboard"
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.MaxDistance = t2.value16.MaxDistance
    BillboardGui.Enabled = false

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.Parent = BillboardGui

    local EggTier = p28:GetAttribute("EggTier")

    if not EggTier then
        EggTier = if p28.Name ~= "EGG KRAKEN GLORY" then p28.Name:gsub(" Egg", "") else "Kraken Glory"
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "NameLabel"
    TextLabel.Size = UDim2.new(1, 0, 0, 16)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = EggTier
    TextLabel.TextColor3 = t2.value16.ESPColor
    TextLabel.TextStrokeTransparency = 0.2
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 14
    TextLabel.Visible = t2.value16.IsNameEnabled
    TextLabel.LayoutOrder = 1
    TextLabel.Parent = BillboardGui

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "DistanceLabel"
    TextLabel2.Size = UDim2.new(1, 0, 0, 16)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = ""
    TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel2.TextStrokeTransparency = 0.2
    TextLabel2.Font = Enum.Font.SourceSansBold
    TextLabel2.TextSize = 14
    TextLabel2.Visible = t2.value16.IsDistanceEnabled
    TextLabel2.LayoutOrder = 2
    TextLabel2.Parent = BillboardGui
    BillboardGui.Parent = p28
    task.spawn(function()
        while true do
            local v235 = BillboardGui

            if v235 then
                v235 = BillboardGui.Parent

                if v235 then
                    v235 = p28 and p28.Parent
                end
            end

            if not v235 then
                break
            end

            local v236 = t2.value2.Character and t2.value2.Character:FindFirstChild("HumanoidRootPart")
            local v237 = v236 and (v236.Position - p28:GetPivot().Position).Magnitude or 1e999

            if v237 <= t2.value16.MaxDistance and t2.value16.IsEnabled then
                Highlight.Enabled = true
                Highlight.FillTransparency = not t2.value16.IsChamsEnabled and 1 or 0.5
                Highlight.OutlineTransparency = 0
                BillboardGui.Enabled = t2.value16.IsNameEnabled or t2.value16.IsDistanceEnabled
                TextLabel.Visible = t2.value16.IsNameEnabled
                TextLabel2.Visible = t2.value16.IsDistanceEnabled

                if t2.value16.IsDistanceEnabled then
                    TextLabel2.Text = math.floor(v237) .. "m"
                end
            else
                Highlight.Enabled = false
                BillboardGui.Enabled = false
            end

            task.wait(0.3)
        end
    end)
end
t2.value17 = t1.value2
local function v33()
    v32()

    if t2.value16.IsEnabled then
        for _, v in ipairs((v31())) do
            t2.value17(v)
        end
    end
end
local function v34(p29)
    if not p29 then
        return
    end

    p29.ChildAdded:Connect(function(child)
        task.wait(0.1)

        local IsEnabled = t2.value16.IsEnabled

        if IsEnabled then
            IsEnabled = child:IsA("Model")

            if IsEnabled then
                IsEnabled = child:GetAttribute("EggId") or child.Name == "EGG KRAKEN GLORY"
            end
        end

        if IsEnabled and (child.Parent and not child:FindFirstChild("EggESP_Highlight")) then
            t2.value17(child)
        end
    end)
end
t1.value29 = workspace:WaitForChild("EggRuntime", 15)

if t1.value29 then
    v34(t1.value29:WaitForChild("WildEggs", 15))
    v34(t1.value29:WaitForChild("DroppedEggs", 15))
end
local KrakenBossRuntime = workspace:WaitForChild("KrakenBossRuntime", 15)

if KrakenBossRuntime then
    v34(KrakenBossRuntime)
end
value2("ESP Enable", function(p30)
    t2.value16.IsEnabled = p30
    v33()
end)
value2("Show Chams", function(p31)
    t2.value16.IsChamsEnabled = p31

    if t2.value16.IsEnabled then
        for _, v in ipairs((v31())) do
            local EggESP_Highlight = v:FindFirstChild("EggESP_Highlight")

            if EggESP_Highlight then
                EggESP_Highlight.FillTransparency = not p31 and 1 or 0.5
            end
        end
    end
end)
value2("Show Name", function(p32)
    t2.value16.IsNameEnabled = p32

    if t2.value16.IsEnabled then
        for _, v in ipairs((v31())) do
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v196 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("NameLabel")

            if v196 then
                v196.Visible = p32
            end
        end
    end
end)
value2("Show Distance", function(p33)
    t2.value16.IsDistanceEnabled = p33

    if t2.value16.IsEnabled then
        for _, v in ipairs((v31())) do
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v201 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("DistanceLabel")

            if v201 then
                v201.Visible = p33
            end
        end
    end
end)

local ESPColor = t2.value16.ESPColor
t1.value15({
	Text = "ESP Color",
	Default = ESPColor,
	Callback = function(p34)
    t2.value16.ESPColor = p34

    if t2.value16.IsEnabled then
        for _, v in ipairs((v31())) do
            local EggESP_Highlight = v:FindFirstChild("EggESP_Highlight")
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v207 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("NameLabel")

            if EggESP_Highlight then
                EggESP_Highlight.FillColor = p34
            end

            if v207 then
                v207.TextColor3 = p34
            end
        end
    end
end
})
t1.value9()
t1.value7("Main")
