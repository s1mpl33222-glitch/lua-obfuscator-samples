-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local _getgenv = getgenv
t1.value1 = 15769605
t1.value2 = _getgenv
if _getgenv then
    t1.value2 = getgenv()
end
local value2 = t1.value2
local value1 = t1.value1
t1.value3 = value2
t1.value4 = value1
if not t1.value2 then
    local __G = _G

    t1.value1 = t1.value4
    t1.value2 = __G

    if not __G then
        t1.value2 = shared
    end

    local value1_2 = t1.value1
    local value2_2 = t1.value2

    t1.value4 = value1_2
    t1.value3 = value2_2
end
t1.value2 = t1.value3
while not t1.value2.STK_UI do
    task.wait(0.1)
end
local STK_UI = t1.value2.STK_UI
t1.value3 = "ScreenGui"
t1.value1 = STK_UI
local _ = t1.value1.ScreenGui
t1.value3 = "mainFrame"
t1.value2 = t1.value1.mainFrame
t1.value3 = "sidebarHeaderText"
t1.value5 = t1.value1.sidebarHeaderText
t1.value3 = "CreateSidebarButton"
t1.value6 = t1.value1.CreateSidebarButton
t1.value3 = "CreateTab"
t1.value7 = t1.value1.CreateTab
t1.value3 = "ShowTab"
t1.value8 = t1.value1.ShowTab
t1.value3 = "CreateBlock"
t1.value9 = t1.value1.CreateBlock
t1.value3 = "EndBlock"
t1.value10 = t1.value1.EndBlock
t1.value3 = "CreateHeader"
t1.value4 = t1.value1.CreateHeader
t1.value4 = t1.value1.CreateButton
local CreateToggle = t1.value1.CreateToggle
t1.value3 = "CreateSlider"
t1.value11 = CreateToggle
t1.value12 = t1.value1.CreateSlider
t1.value3 = "CreateDropdown"
t1.value13 = 15
local CreateDropdown = t1.value1.CreateDropdown
t1.value3 = "CreateColorPicker"
t1.value14 = CreateDropdown
t1.value15 = "rbxassetid://101988819289766"
local CreateColorPicker = t1.value1.CreateColorPicker
t1.value3 = "game"
t1.value16 = CreateColorPicker
t1.value4 = game
t2.value1 = t1.value4:GetService("Players").LocalPlayer
t2.value1:WaitForChild("PlayerGui")
t1.value3 = game:GetService("UserInputService")
t2.value2 = t1.value3
game:GetService("TweenService")
t1.value3 = game:GetService("VirtualInputManager")
t2.value3 = t1.value3
t1.value3 = game:GetService("RunService")
t2.value4 = t1.value3
t1.value4 = game
t1.value3 = "GetService"
t1.value4:GetService("Lighting")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

t1.value4 = "Text"
t1.value5.Text = "Ride A Fish"
t1.value6("Main", "rbxassetid://101988819289766")
t1.value7("Main")
t1.value3 = "Main"
t1.value15 = "WaitForChild"
t1.value8("Main")
t1.value15 = ReplicatedStorage.WaitForChild
t1.value3 = "EggGameFolder"
t1.value15 = t1.value15(ReplicatedStorage, "EggGame", t1.value13)
t1.value13 = nil
t1.value17 = { "Common" }
t2.value5 = {
	EggGameFolder = t1.value15,
	EggRequests = t1.value13,
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
	DisplayToRawTier = {},
	PromptHoldCache = {},
	IgnoredTokens = {},
	IgnoredEggs = {},
	CurrentTargetEgg = nil,
	TargetEggStartTime = 0,
	AutoFarmEggs = false,
	SelectedEggTiers = t1.value17,
	AutoDeliverEgg = false,
	AutoStoreEgg = false,
	AutoHatch = false,
	AutoEquipBest = false,
	AutoCollectTokens = false,
	AutoCollectBossEgg = false,
	AntiStun = false,
	InstantPrompt = false
}
t2.value5.EggRequests = t2.value5.EggGameFolder and t2.value5.EggGameFolder:WaitForChild("Requests", 15)
t1.value3 = "ipairs"
t1.value4 = ipairs
for _, v16 in t1.value4(t2.value5.EggTiersList) do
    t1.value18 = (function(p1)
        return p1:gsub("(%l)(%u)", "%1 %2")
    end)(v16)
    table.insert(t2.value5.DisplayEggTiers, t1.value18)
    t1.value4 = t2.value5.DisplayToRawTier
    t1.value4[t1.value18] = v16
end
function t1.value4()
    local Character = t2.value1.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end
t2.value6 = t1.value4
function t1.value4()
    local PlayerPot = t2.value1:GetAttribute("PlayerPot")
    local v41 = PlayerPot and workspace:FindFirstChild(PlayerPot)

    if not v41 then
        for _, child in ipairs(workspace:GetChildren()) do
            if child:GetAttribute("OwnerUserId") == t2.value1.UserId and child.Name:find("Player Pot") then
                return child
            end
        end
    end

    return v41
end
t2.value7 = t1.value4
function t1.value4()
    local v44 = t2.value7()

    return v44 and v44:FindFirstChild("BillboardStats")
end
t2.value8 = t1.value4
function t2.value9()
    return t2.value1:GetAttribute("InSaveZone") == true
end
function t1.value4()
    local KrakenBossRuntime = workspace:FindFirstChild("KrakenBossRuntime")

    return KrakenBossRuntime and KrakenBossRuntime:FindFirstChild("EGG KRAKEN GLORY")
end
t2.value10 = t1.value4
local function v17()
    local ActiveTokens = workspace:FindFirstChild("ActiveTokens")

    if not ActiveTokens then
        return {}
    end

    local elapsed = os.clock()
    local GetChildren = ActiveTokens.GetChildren
    local t3 = {}

    for _, v in ipairs(GetChildren(ActiveTokens)) do
        if v:IsA("Model") and not v:GetAttribute("Consumed") and (not t2.value5.IgnoredTokens[v] or elapsed > t2.value5.IgnoredTokens[v]) then
            local v57 = v:FindFirstChild("TOKEN", true) or v:FindFirstChildWhichIsA("BasePart", true)

            if v57 then
                table.insert(t3, {
					model = v,
					part = v57
				})
            end
        end
    end

    return t3
end
local function v18()
    local v58 = v17()

    if #v58 == 0 then
        return
    end

    local v59 = t2.value6()
    local Character = t2.value1.Character

    if not v59 or not Character then
        return
    end

    local CFrame2 = v59.CFrame

    for _, v in ipairs(v58) do
        if not t2.value5.AutoCollectTokens then
            break
        end

        if v.model.Parent and not v.model:GetAttribute("Consumed") then
            v59.AssemblyLinearVelocity = Vector3.zero
            Character:PivotTo(v.part.CFrame)
            task.wait(1)

            if v.model.Parent and not v.model:GetAttribute("Consumed") then
                t2.value5.IgnoredTokens[v.model] = os.clock() + 30
            end
        end
    end

    local v64 = v59

    if v59 then
        v64 = Character

        if Character then
            v64 = v59.Parent
        end
    end

    if v64 then
        v59.AssemblyLinearVelocity = Vector3.zero
        Character:PivotTo(CFrame2)
        task.wait(0.5)
    end
end
local function v19(p2)
    if not t2.value5.EggRequests then
        return
    end

    pcall(function()
        t2.value5.EggRequests:FireServer("StoreEgg")
    end)

    if not p2 then
        return
    end

    local elapsed = os.clock()

    while true do
        local v67 = false

        if t2.value1:GetAttribute("HasSeaEgg") == true then
            v67 = os.clock() - elapsed < 2
        end

        if not v67 then
            break
        end

        task.wait(0.2)
    end

    if t2.value1:GetAttribute("HasSeaEgg") == true then
        local CarriedEggId = t2.value1:GetAttribute("CarriedEggId")

        if type(CarriedEggId) == "string" then
            pcall(function()
                t2.value5.EggRequests:FireServer("DropCarriedEgg", CarriedEggId)
            end)
            task.wait(0.3)
        end
    end
end
local function v20(p3)
    if #p3 == 0 then
        return nil
    end
    local EggRuntime = workspace:FindFirstChild("EggRuntime")
    local v71 = EggRuntime and EggRuntime:FindFirstChild("WildEggs")
    if not v71 then
        return nil
    end
    local v72 = t2.value6()
    if not v72 then
        return nil
    end
    local Position = v72.Position
    local v74
    local n1 = 1e999
    local elapsed = os.clock()
    for _, child in ipairs(v71:GetChildren()) do
        if not t2.value5.IgnoredEggs[child] or elapsed > t2.value5.IgnoredEggs[child] then
            local EggTier = child:GetAttribute("EggTier")

            if EggTier and table.find(p3, EggTier) then
                local Magnitude = (child:GetPivot().Position - Position).Magnitude

                if Magnitude < n1 then
                    n1 = Magnitude
                    v74 = child
                end
            end
        end
    end

    return v74
end
local function v21(p4)
    if not p4:IsA("ProximityPrompt") then
        return
    end

    if t2.value5.InstantPrompt then
        if t2.value5.PromptHoldCache[p4] == nil then
            t2.value5.PromptHoldCache[p4] = p4.HoldDuration
        end

        p4.HoldDuration = 0

        return
    end

    if t2.value5.PromptHoldCache[p4] ~= nil then
        p4.HoldDuration = t2.value5.PromptHoldCache[p4]
        t2.value5.PromptHoldCache[p4] = nil
    end
end
t1.value4 = workspace.DescendantAdded
t1.value4:Connect(function(p5)
    if p5:IsA("ProximityPrompt") then
        task.defer(v21, p5)
    end
end)

local function v22()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            v21(descendant)
        end
    end
end
t1.value4 = task.spawn
t1.value4(function()
    while true do
        local v85 = t2.value6()
        local Character = t2.value1.Character
        local HasSeaEgg = t2.value1:GetAttribute("HasSeaEgg")
        local value1_3 = t2.value1
        local GetAttribute = value1_3.GetAttribute
        local v90 = HasSeaEgg == true
        local v91 = GetAttribute(value1_3, "EggSecured") == true
        local v92 = v85
        if v85 then
            v92 = Character and v90 and t2.value5.AutoFarmEggs or t2.value5.AutoCollectBossEgg
        end
        if v92 then
            t2.value5.CurrentTargetEgg = nil
            t2.value5.TargetEggStartTime = 0

            if not v91 then
                local v93 = t2.value8()

                if v93 then
                    v85.AssemblyLinearVelocity = Vector3.zero
                    Character:PivotTo(CFrame.new(v93.Position + Vector3.new(0, 6, 0)))
                end

                task.wait(1)
            else
                v19(true)
            end
        else
            local v94 = v85

            if v85 then
                v94 = Character

                if Character then
                    v94 = not v90
                end
            end

            if v94 then
                if t2.value5.AutoCollectTokens and #v17() > 0 then
                    t2.value5.CurrentTargetEgg = nil
                    t2.value5.TargetEggStartTime = 0
                    v18()
                elseif t2.value5.AutoCollectBossEgg and t2.value10() ~= nil then
                    t2.value5.CurrentTargetEgg = nil
                    t2.value5.TargetEggStartTime = 0

                    local v95 = t2.value10()

                    if v95 and v95.Parent then
                        local zero = Vector3.zero
                        local GetPivot = v95.GetPivot

                        v85.AssemblyLinearVelocity = zero
                        Character:PivotTo(GetPivot(v95) + Vector3.new(0, 3, 0))
                        task.wait(0.2)

                        local ProximityPrompt = v95:FindFirstChildWhichIsA("ProximityPrompt", true)

                        if ProximityPrompt and ProximityPrompt.Enabled then
                            local HoldDuration = ProximityPrompt.HoldDuration

                            ProximityPrompt.HoldDuration = 0

                            local E = Enum.KeyCode.E
                            local _game = game

                            t2.value3:SendKeyEvent(true, E, false, _game)
                            task.wait(0.05)

                            local E2 = Enum.KeyCode.E
                            local _game2 = game

                            t2.value3:SendKeyEvent(false, E2, false, _game2)
                            task.wait(0.1)

                            if ProximityPrompt and ProximityPrompt.Parent then
                                ProximityPrompt.HoldDuration = HoldDuration
                            end
                        end

                        task.wait(0.4)
                    end
                elseif t2.value5.AutoFarmEggs and #t2.value5.SelectedEggTiers > 0 then
                    local v104 = v20(t2.value5.SelectedEggTiers)

                    if v104 and v104.Parent then
                        if v104 ~= t2.value5.CurrentTargetEgg then
                            t2.value5.CurrentTargetEgg = v104
                            t2.value5.TargetEggStartTime = os.clock()
                        end

                        if os.clock() - t2.value5.TargetEggStartTime >= 4 then
                            t2.value5.IgnoredEggs[v104] = os.clock() + 30
                            t2.value5.CurrentTargetEgg = nil
                            t2.value5.TargetEggStartTime = 0
                            task.wait(0.1)
                        else
                            v85.AssemblyLinearVelocity = Vector3.zero
                            Character:PivotTo(v104:GetPivot() + Vector3.new(0, 3, 0))
                            task.wait(0.2)

                            local ProximityPrompt = v104:FindFirstChildWhichIsA("ProximityPrompt", true)

                            if ProximityPrompt and ProximityPrompt.Enabled then
                                local HoldDuration = ProximityPrompt.HoldDuration

                                ProximityPrompt.HoldDuration = 0

                                local KeyCode = Enum.KeyCode

                                t2.value3:SendKeyEvent(true, KeyCode.E, false, game)
                                task.wait(0.05)
                                t2.value3:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                task.wait(0.1)

                                if ProximityPrompt and ProximityPrompt.Parent then
                                    ProximityPrompt.HoldDuration = HoldDuration
                                end
                            end

                            task.wait(0.4)
                        end
                    else
                        t2.value5.CurrentTargetEgg = nil
                        t2.value5.TargetEggStartTime = 0
                        task.wait(1)
                    end
                else
                    t2.value5.CurrentTargetEgg = nil
                    t2.value5.TargetEggStartTime = 0
                    task.wait(1)
                end
            else
                t2.value5.CurrentTargetEgg = nil
                t2.value5.TargetEggStartTime = 0
                task.wait(1)
            end
        end
        task.wait(0.2)
    end
end)
task.spawn(function()
    while true do
        local AutoDeliverEgg = t2.value5.AutoDeliverEgg

        if AutoDeliverEgg then
            AutoDeliverEgg = not t2.value5.AutoFarmEggs and not t2.value5.AutoCollectBossEgg
        end

        if AutoDeliverEgg then
            local HasSeaEgg = t2.value1:GetAttribute("HasSeaEgg")
            local value1_4 = t2.value1
            local GetAttribute = value1_4.GetAttribute
            local v112 = HasSeaEgg == true
            local v113 = GetAttribute(value1_4, "EggSecured") == true

            if v112 then
                v112 = not v113
            end

            if v112 then
                local v114 = t2.value6()
                local Character = t2.value1.Character
                local v116 = t2.value8()
                local v117 = v114

                if v114 then
                    v117 = Character and v116
                end

                if v117 then
                    v114.AssemblyLinearVelocity = Vector3.zero
                    Character:PivotTo(CFrame.new(v116.Position + Vector3.new(0, 6, 0)))
                end
            end
        end

        task.wait(0.15)
    end
end)
task.spawn(function()
    while true do
        local AutoStoreEgg = t2.value5.AutoStoreEgg

        if AutoStoreEgg then
            AutoStoreEgg = not t2.value5.AutoFarmEggs and not t2.value5.AutoCollectBossEgg
        end

        if AutoStoreEgg and (t2.value1:GetAttribute("HasSeaEgg") == true and t2.value1:GetAttribute("EggSecured") == true) and t2.value5.EggRequests then
            pcall(function()
                t2.value5.EggRequests:FireServer("StoreEgg")
            end)
        end

        task.wait(0.5)
    end
end)
task.spawn(function()
    while true do
        local AutoHatch = t2.value5.AutoHatch

        if AutoHatch then
            AutoHatch = t2.value5.EggRequests and t2.value9()
        end

        if AutoHatch then
            local v120 = t2.value7()

            if v120 then
                for _, descendant in ipairs(v120:GetDescendants()) do
                    local v123 = descendant
                    local v124 = v123:IsA("BasePart")

                    if v124 then
                        v124 = v123:GetAttribute("HatchSlot") and v123:GetAttribute("Status") == "Ready"
                    end

                    if v124 then
                        pcall(function()
                            t2.value5.EggRequests:FireServer("HatchFromUI", v123:GetAttribute("HatchSlot"))
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
        if t2.value5.AutoEquipBest and t2.value5.EggRequests then
            pcall(function()
                t2.value5.EggRequests:FireServer("EquipBest")
            end)
            task.wait(60)
        else
            task.wait(1)
        end
    end
end)
task.spawn(function()
    while true do
        if t2.value5.AntiStun then
            if t2.value1:GetAttribute("BombStunUntil") then
                t2.value1:SetAttribute("BombStunUntil", 0)
            end

            if t2.value1:GetAttribute("BombSlowUntil") then
                t2.value1:SetAttribute("BombSlowUntil", 0)
            end

            if t2.value1:GetAttribute("BombSlowMultiplier") then
                t2.value1:SetAttribute("BombSlowMultiplier", 1)
            end
        end

        task.wait(0.1)
    end
end)
t1.value9("Auto Farm")
t1.value11("Enable", function(p6)
    t2.value5.AutoFarmEggs = p6
    t2.value5.CurrentTargetEgg = nil
    t2.value5.TargetEggStartTime = 0
end)

local DisplayEggTiers = t2.value5.DisplayEggTiers
t1.value21 = { "Common" }
t1.value14({
	Text = "Select Egg",
	List = DisplayEggTiers,
	Default = t1.value21,
	Multi = true,
	Callback = function(p7)
    local t4 = {}
    local _ipairs = ipairs

    if not p7 then
        p7 = {}
    end

    for _, v50 in _ipairs(p7) do
        table.insert(t4, t2.value5.DisplayToRawTier[v50] or v50)
    end

    t2.value5.SelectedEggTiers = t4
end
})
t1.value10()
t1.value9("Auto Play")
t1.value11("Auto Deliver Egg", function(p8)
    t2.value5.AutoDeliverEgg = p8
end)
t1.value11("Auto Store Egg", function(p9)
    t2.value5.AutoStoreEgg = p9
end)
t1.value11("Auto Hatch Egg", function(p10)
    t2.value5.AutoHatch = p10
end)
t1.value11("Auto Equip Best Fish", function(p11)
    t2.value5.AutoEquipBest = p11

    if p11 then
        p11 = t2.value5.EggRequests
    end

    if p11 then
        pcall(function()
            t2.value5.EggRequests:FireServer("EquipBest")
        end)
    end
end)
t1.value11("Auto Collect Tokens", function(p12)
    t2.value5.AutoCollectTokens = p12
end)
t1.value11("Auto Collect Boss Egg", function(p13)
    t2.value5.AutoCollectBossEgg = p13
end)
t1.value10()
t1.value19 = "SpeedRootPart"
t1.value9("Misc")
t1.value11("Anti Stun", function(p14)
    t2.value5.AntiStun = p14
end)
t1.value11("Instant Interact", function(p15)
    t2.value5.InstantPrompt = p15
    v22()
end)
t1.value10()
t1.value6("Movement", "rbxassetid://104433470689984")
t1.value7("Movement")
t1.value8("Movement")
t1.value9("Speed")
t2.value11 = {
	SpeedHumanoid = nil,
	SpeedRootPart = nil,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil
}
local function v24()
    local connection = t2.value4.Heartbeat:Connect(function()
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
local value1_5 = t2.value1
function t1.value19(p16)
    t2.value11.SpeedHumanoid = p16:WaitForChild("Humanoid")
    t2.value11.SpeedRootPart = p16:WaitForChild("HumanoidRootPart")

    if t2.value11.SpeedIsEnabled then
        if t2.value11.SpeedStopCallback then
            t2.value11.SpeedStopCallback()
        end

        t2.value11.SpeedStopCallback = v24()
    end
end
if value1_5.Character then
    task.spawn(t1.value19, t2.value1.Character)
end
t1.value4 = t2.value1.CharacterAdded
local Connect = t1.value4.Connect
t1.value20 = "Speed"
Connect(t1.value4, t1.value19)
t1.value11("Enable", function(p17)
    if p17 == t2.value11.SpeedIsEnabled then
        return
    end

    t2.value11.SpeedIsEnabled = p17

    if t2.value11.SpeedStopCallback then
        t2.value11.SpeedStopCallback()
        t2.value11.SpeedStopCallback = nil
    end

    if t2.value11.SpeedIsEnabled then
        t2.value11.SpeedStopCallback = v24()
    end
end)

local SpeedValue = t2.value11.SpeedValue
t1.value12({
	Text = "Speed",
	Min = 16,
	Max = 300,
	Default = SpeedValue,
	Callback = function(p18)
    t2.value11.SpeedValue = p18
end
})
t1.value10()
t1.value9("Fly")
t1.value20 = "FlyRootPart"
t2.value12 = {
	FlyCharacter = nil,
	FlyRootPart = nil,
	FlyHumanoid = nil,
	FlyIsEnabled = false,
	FlySpeed = 16,
	FlyStopCallback = nil
}
function t1.value4()
    local BodyVelocity = Instance.new("BodyVelocity")

    BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.P = 1250
    BodyVelocity.Parent = t2.value12.FlyRootPart

    local connection = t2.value4.Heartbeat:Connect(function()
        local v202 = not t2.value12.FlyRootPart

        if not v202 then
            v202 = not t2.value12.FlyRootPart.Parent or not t2.value12.FlyHumanoid
        end

        if v202 then
            BodyVelocity.Velocity = Vector3.zero

            return
        end

        if t2.value12.FlyIsEnabled then
            local MoveDirection = t2.value12.FlyHumanoid.MoveDirection

            if MoveDirection.Magnitude > 0 then
                local LookVector = workspace.CurrentCamera.CFrame.LookVector
                local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)
                if vector3.Magnitude > 0 then
                    vector3 = vector3.Unit
                end
                local v206 = vector3:Dot(MoveDirection)
                local FlySpeed = t2.value12.FlySpeed
                BodyVelocity.Velocity = MoveDirection * FlySpeed + Vector3.new(0, LookVector.Y * v206 * t2.value12.FlySpeed, 0)

                return
            end

            BodyVelocity.Velocity = Vector3.zero

            return
        end

        BodyVelocity.Velocity = Vector3.zero
    end)

    return function()
        connection:Disconnect()
        BodyVelocity:Destroy()
    end
end
t2.value13 = t1.value4
function t1.value20(p19)
    t2.value12.FlyCharacter = p19
    t2.value12.FlyRootPart = p19:WaitForChild("HumanoidRootPart")
    t2.value12.FlyHumanoid = p19:WaitForChild("Humanoid")

    if t2.value12.FlyIsEnabled then
        if t2.value12.FlyStopCallback then
            t2.value12.FlyStopCallback()
        end

        t2.value12.FlyStopCallback = t2.value13()
    end
end
if t2.value1.Character then
    task.spawn(t1.value20, t2.value1.Character)
end
t2.value1.CharacterAdded:Connect(t1.value20)
t1.value11("Enable", function(p20)
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
    end
end)

local FlySpeed = t2.value12.FlySpeed
t1.value12({
	Text = "Fly Speed",
	Min = 16,
	Max = 300,
	Default = FlySpeed,
	Decimals = 1,
	Callback = function(p21)
    t2.value12.FlySpeed = p21
end
})
t1.value22 = "InfJumpHumanoid"
t1.value21 = "InfJumpCharacter"
t1.value10()
t1.value9()
t2.value14 = {
	InfJumpCharacter = nil,
	InfJumpHumanoid = nil,
	InfJumpIsEnabled = false,
	InfJumpStopCallback = nil
}
function t1.value22(p22)
    t2.value14.InfJumpCharacter = p22

    local WaitForChild = p22.WaitForChild

    t2.value14.InfJumpHumanoid = WaitForChild(p22, "Humanoid")

    if t2.value14.InfJumpIsEnabled then
        if t2.value14.InfJumpStopCallback then
            t2.value14.InfJumpStopCallback()
        end

        local value14 = t2.value14
        local connection = t2.value2.JumpRequest:Connect(function()
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
if t2.value1.Character then
    task.spawn(t1.value22, t2.value1.Character)
end
t2.value1.CharacterAdded:Connect(t1.value22)
t1.value17 = "Infinite Jump"
t1.value11("Infinite Jump", function(p23)
    if p23 == t2.value14.InfJumpIsEnabled then
        return
    end

    t2.value14.InfJumpIsEnabled = p23

    if t2.value14.InfJumpStopCallback then
        t2.value14.InfJumpStopCallback()
        t2.value14.InfJumpStopCallback = nil
    end

    if t2.value14.InfJumpIsEnabled then
        local value14 = t2.value14
        local connection = t2.value2.JumpRequest:Connect(function()
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
end)
t1.value23 = {}
t1.value10()
t1.value17 = "NoclipCharacter"
t1.value9()
t2.value15 = {
	NoclipCharacter = nil,
	NoclipIsEnabled = false,
	NoclipStopCallback = nil,
	NoclipParts = t1.value23,
	NoclipOriginalCanCollide = {},
	NoclipDescendantConnection = nil
}
function t1.value4()
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
t2.value16 = t1.value4
local function v29()
    local connection = t2.value4.Stepped:Connect(function()
        if not t2.value15.NoclipCharacter or not t2.value15.NoclipCharacter.Parent then
            return
        end

        if t2.value15.NoclipIsEnabled then
            for _, v in ipairs(t2.value15.NoclipParts) do
                v.CanCollide = false
            end
        end
    end)

    return function()
        connection:Disconnect()

        if t2.value15.NoclipCharacter and t2.value15.NoclipCharacter.Parent then
            for _, v in ipairs(t2.value15.NoclipParts) do
                if v and v.Parent then
                    local v213 = t2.value15.NoclipOriginalCanCollide[v]

                    if v213 ~= nil then
                        v.CanCollide = v213
                    end
                end
            end
        end
    end
end
function t1.value4(p24)
    t2.value15.NoclipCharacter = p24
    t2.value16()

    if t2.value15.NoclipDescendantConnection then
        t2.value15.NoclipDescendantConnection:Disconnect()
    end

    if t2.value15.NoclipRemovingConnection then
        t2.value15.NoclipRemovingConnection:Disconnect()
    end

    t2.value15.NoclipDescendantConnection = p24.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            table.insert(t2.value15.NoclipParts, descendant)
            t2.value15.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
        end
    end)
    t2.value15.NoclipRemovingConnection = p24.DescendantRemoving:Connect(function(descendant)
        if not descendant:IsA("BasePart") then
            return
        end

        local v216 = table.find(t2.value15.NoclipParts, descendant)

        if v216 then
            table.remove(t2.value15.NoclipParts, v216)
        end

        t2.value15.NoclipOriginalCanCollide[descendant] = nil
    end)

    if t2.value15.NoclipIsEnabled then
        if t2.value15.NoclipStopCallback then
            t2.value15.NoclipStopCallback()
        end

        t2.value15.NoclipStopCallback = v29()
    end
end
local value1_6 = t2.value1
local value4 = t1.value4
if value1_6.Character then
    task.spawn(value4, t2.value1.Character)
end
t2.value1.CharacterAdded:Connect(value4)
t1.value11("Noclip", function(p25)
    if p25 == t2.value15.NoclipIsEnabled then
        return
    end

    t2.value15.NoclipIsEnabled = p25

    if t2.value15.NoclipStopCallback then
        t2.value15.NoclipStopCallback()
        t2.value15.NoclipStopCallback = nil
    end

    if t2.value15.NoclipIsEnabled then
        t2.value15.NoclipStopCallback = v29()
    end
end)
t1.value10()
t1.value6("Esp", "rbxassetid://92867222908387")
t1.value7("Esp")
t1.value24 = "IsDistanceEnabled"
t1.value8("Esp")
t1.value23 = false
t1.value9("Egg ESP")

local color3 = Color3.fromRGB(0, 255, 200)

t2.value17 = {
	IsEnabled = false,
	IsChamsEnabled = t1.value23,
	IsNameEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 500,
	ESPColor = color3
}
function t1.value4()
    local t5 = {}
    local EggRuntime = workspace:FindFirstChild("EggRuntime")

    if EggRuntime then
        local t6 = {
			EggRuntime:FindFirstChild("WildEggs"),
			EggRuntime:FindFirstChild("DroppedEggs")
		}

        for _, v in ipairs(t6) do
            if v then
                local GetChildren = v.GetChildren

                for _, v2 in ipairs(GetChildren(v)) do
                    if v2:IsA("Model") and v2:GetAttribute("EggId") then
                        table.insert(t5, v2)
                    end
                end
            end
        end
    end

    local KrakenBossRuntime = workspace:FindFirstChild("KrakenBossRuntime")

    if KrakenBossRuntime then
        local v165 = KrakenBossRuntime:FindFirstChild("EGG KRAKEN GLORY")

        if v165 and v165:IsA("Model") then
            table.insert(t5, v165)
        end
    end

    return t5
end
t2.value18 = t1.value4
local function v33()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant.Name == "EggESP_Highlight" or descendant.Name == "EggESP_Billboard" then
            descendant:Destroy()
        end
    end
end
function t1.value4(p26)
    local EggESP_Highlight = p26:FindFirstChild("EggESP_Highlight")
    local EggESP_Billboard = p26:FindFirstChild("EggESP_Billboard")

    if EggESP_Highlight then
        EggESP_Highlight:Destroy()
    end

    if EggESP_Billboard then
        EggESP_Billboard:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "EggESP_Highlight"
    Highlight.FillColor = t2.value17.ESPColor
    Highlight.FillTransparency = not t2.value17.IsChamsEnabled and 1 or 0.5
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineTransparency = not t2.value17.IsEnabled and 1 or 0
    Highlight.Enabled = false
    Highlight.Parent = p26

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "EggESP_Billboard"
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.MaxDistance = t2.value17.MaxDistance
    BillboardGui.Enabled = false

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.Parent = BillboardGui

    local EggTier = p26:GetAttribute("EggTier")

    if not EggTier then
        EggTier = if p26.Name ~= "EGG KRAKEN GLORY" then p26.Name:gsub(" Egg", "") else "Kraken Glory"
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "NameLabel"
    TextLabel.Size = UDim2.new(1, 0, 0, 16)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = EggTier
    TextLabel.TextColor3 = t2.value17.ESPColor
    TextLabel.TextStrokeTransparency = 0.2
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 14
    TextLabel.Visible = t2.value17.IsNameEnabled
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
    TextLabel2.Visible = t2.value17.IsDistanceEnabled
    TextLabel2.LayoutOrder = 2
    TextLabel2.Parent = BillboardGui
    BillboardGui.Parent = p26
    task.spawn(function()
        while true do
            local v217 = BillboardGui

            if v217 then
                v217 = BillboardGui.Parent

                if v217 then
                    v217 = p26 and p26.Parent
                end
            end

            if not v217 then
                break
            end

            local v218 = t2.value1.Character and t2.value1.Character:FindFirstChild("HumanoidRootPart")

            if v218 then
                v218 = (v218.Position - p26:GetPivot().Position).Magnitude
            end

            if not v218 then
                v218 = 1e999
            end

            if v218 <= t2.value17.MaxDistance and t2.value17.IsEnabled then
                Highlight.Enabled = true
                Highlight.FillTransparency = not t2.value17.IsChamsEnabled and 1 or 0.5
                Highlight.OutlineTransparency = 0
                BillboardGui.Enabled = t2.value17.IsNameEnabled or t2.value17.IsDistanceEnabled
                TextLabel.Visible = t2.value17.IsNameEnabled
                TextLabel2.Visible = t2.value17.IsDistanceEnabled

                if t2.value17.IsDistanceEnabled then
                    TextLabel2.Text = math.floor(v218) .. "m"
                end
            else
                Highlight.Enabled = false
                BillboardGui.Enabled = false
            end

            task.wait(0.3)
        end
    end)
end
t2.value19 = t1.value4
local function v34()
    v33()

    if t2.value17.IsEnabled then
        for _, v in ipairs(t2.value18()) do
            t2.value19(v)
        end
    end
end
local function v35(p27)
    if not p27 then
        return
    end

    p27.ChildAdded:Connect(function(child)
        task.wait(0.1)

        local IsEnabled = t2.value17.IsEnabled

        if IsEnabled then
            IsEnabled = child:IsA("Model")

            if IsEnabled then
                IsEnabled = child:GetAttribute("EggId") or child.Name == "EGG KRAKEN GLORY"
            end
        end

        if IsEnabled and (child.Parent and not child:FindFirstChild("EggESP_Highlight")) then
            t2.value19(child)
        end
    end)
end
t1.value24 = workspace:WaitForChild("EggRuntime", 15)

if t1.value24 then
    v35(t1.value24:WaitForChild("WildEggs", 15))
    v35(t1.value24:WaitForChild("DroppedEggs", 15))
end
local KrakenBossRuntime = workspace:WaitForChild("KrakenBossRuntime", 15)

if KrakenBossRuntime then
    v35(KrakenBossRuntime)
end
t1.value11("ESP Enable", function(p28)
    t2.value17.IsEnabled = p28
    v34()
end)
t1.value11("Show Chams", function(p29)
    t2.value17.IsChamsEnabled = p29

    if t2.value17.IsEnabled then
        for _, v in ipairs(t2.value18()) do
            local EggESP_Highlight = v:FindFirstChild("EggESP_Highlight")

            if EggESP_Highlight then
                EggESP_Highlight.FillTransparency = not p29 and 1 or 0.5
            end
        end
    end
end)
t1.value11("Show Name", function(p30)
    t2.value17.IsNameEnabled = p30

    if t2.value17.IsEnabled then
        for _, v in ipairs(t2.value18()) do
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v189 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("NameLabel")

            if v189 then
                v189.Visible = p30
            end
        end
    end
end)
t1.value11("Show Distance", function(p31)
    t2.value17.IsDistanceEnabled = p31

    if t2.value17.IsEnabled then
        for _, v in ipairs(t2.value18()) do
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v194 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("DistanceLabel")

            if v194 then
                v194.Visible = p31
            end
        end
    end
end)

local ESPColor = t2.value17.ESPColor
t1.value16({
	Text = "ESP Color",
	Default = ESPColor,
	Callback = function(p32)
    t2.value17.ESPColor = p32

    if t2.value17.IsEnabled then
        for _, v in ipairs(t2.value18()) do
            local EggESP_Highlight = v:FindFirstChild("EggESP_Highlight")
            local EggESP_Billboard = v:FindFirstChild("EggESP_Billboard")
            local v200 = EggESP_Billboard and EggESP_Billboard:FindFirstChild("NameLabel")

            if EggESP_Highlight then
                EggESP_Highlight.FillColor = p32
            end

            if v200 then
                v200.TextColor3 = p32
            end
        end
    end
end
})
t1.value10()
t1.value8("Main")
