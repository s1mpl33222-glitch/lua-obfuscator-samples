local library = loadstring(game:HttpGet("https://github.com/WozzyOnTop/Script-denemesi/raw/refs/heads/main/KryvexGui%20(3).txt", true))()
local displayName = game.Players.LocalPlayer.DisplayName

local window = library:AddWindow("Kryvex Public | Muscle Legends || HI - ".. displayName, {
 title_bar = {
    Color3.fromRGB(255, 0, 0), -- Kıpkırmızı
    Color3.fromRGB(100, 0, 0),
    Color3.fromRGB(25, 0, 0)
},
title_bar_transparency = 0.1,

background = {
    Color3.fromRGB(0, 0, 0),
    Color3.fromRGB(10, 10, 10),
    Color3.fromRGB(20, 20, 20)
},
background_transparency = 0.1,

main_color = Color3.fromRGB(255, 0, 0), -- Kıpkırmızı

min_size = Vector2.new(435, 350),
can_resize = true
})

local AutoFarm = window:AddTab("Farm")
AutoFarm:AddLabel("Tools Farm")

local repsPerTick = 1

AutoFarm:AddTextBox("🚀 Thread Speed", function(value)
    local num = tonumber(value)
    if num and num > 0 then 
        repsPerTick = math.floor(num)
    else
        repsPerTick = 1
    end
end, {placeholder = "Enter Amount (Default: 1)"})

_G.repToggle = false
AutoFarm:AddSwitch("💪 Auto Farm (Equip Any tool)", function(state)
    _G.repToggle = state
    task.spawn(function()
        while _G.repToggle do
            local event = game:GetService("Players").LocalPlayer:FindFirstChild("muscleEvent")
            if event then
                for i = 1, repsPerTick do
                    if not _G.repToggle then break end
                    event:FireServer("rep")
                end
            end
            task.wait(0.01)
        end
    end)
end)

local function manageTool(toolName)
    task.spawn(function()
        while _G[toolName.."On"] do
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local tool = player.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
                
                if tool then
                    if tool.Parent ~= character then
                        tool.Parent = character
                    end
                    
                    local event = player:FindFirstChild("muscleEvent")
                    if event then
                        for i = 1, repsPerTick do
                            if not _G[toolName.."On"] then break end
                            event:FireServer("rep")
                        end
                    else
                        tool:Activate()
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end

AutoFarm:AddSwitch("🏋️ Weight", function(bool)
    _G.WeightOn = bool
    if bool then manageTool("Weight") end
end)

AutoFarm:AddSwitch("💪 Pushups", function(bool)
    _G.PushupsOn = bool
    if bool then manageTool("Pushups") end
end)

AutoFarm:AddSwitch("🤸 Handstands", function(bool)
    _G.HandstandsOn = bool
    if bool then manageTool("Handstands") end
end)

AutoFarm:AddSwitch("🧘 Situps", function(bool)
    _G.SitupsOn = bool
    if bool then manageTool("Situps") end
end)



AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("⚡ OP Tools")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function manageToolCombo(toolName)
    task.spawn(function()
        while _G[toolName.."On"] do
            local character = LocalPlayer.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            
            if character and hum then
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or character:FindFirstChild("Punch")
                local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)

                if punch then
                    if punch.Parent ~= character then
                        hum:EquipTool(punch)
                    end
                    if punch:FindFirstChild("attackTime") then 
                        punch.attackTime.Value = 0 
                    end
                    punch:Activate()
                end

                if tool then
                    if tool.Parent ~= character then
                        hum:EquipTool(tool)
                    end
                    
                    local event = LocalPlayer:FindFirstChild("muscleEvent")
                    if event then 
                        event:FireServer("rep") 
                    end
                    tool:Activate()
                end
            end
            task.wait(0.01)
        end
    end)
end

AutoFarm:AddSwitch("🏋️ Weight + 🥊 Punch", function(bool)
    _G.WeightOn = bool
    if bool then manageToolCombo("Weight") end
end)

AutoFarm:AddSwitch("💪 Pushups + 🥊 Punch", function(bool)
    _G.PushupsOn = bool
    if bool then manageToolCombo("Pushups") end
end)

AutoFarm:AddSwitch("🤸 Handstand + 🥊 Punch", function(bool)
    _G.HandstandOn = bool
    if bool then manageToolCombo("Handstand") end
end)

AutoFarm:AddSwitch("🧘 Situps + 🥊 Punch", function(bool)
    _G.SitupsOn = bool
    if bool then manageToolCombo("Situps") end
end)

AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("💨 Treadmill Farm")

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local Locations = {
    {name = "🏭 Industrial Treadmill +20 xp", pos = Vector3.new(-4989.90, 81.62, 5414.85)},
    {name = "🌿 Jungle Treadmill +8 xp", pos = Vector3.new(-8131.86, 25.77, 2818.17)},
    {name = "🔱 Legends Treadmill +7 xp", pos = Vector3.new(4365.82, 997.14, -3632.9)},
    {name = "✨ Mythical Treadmill +6 xp", pos = Vector3.new(2661.67, 19.41, 932.09)},
    {name = "🏠 Spawn Treadmill +5 xp", pos = Vector3.new(-230.43, 8.16, -102.18)},
    {name = "👟 Tiny Treadmill +1 xp", pos = Vector3.new(55.64, 5.16, 1947.60)}
}

local posLockConnection = nil

local function lockAndSimulate(targetCFrame)
    if posLockConnection then posLockConnection:Disconnect() end
    posLockConnection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = targetCFrame
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        end
    end)
end

local function stopAll()
    if posLockConnection then
        posLockConnection:Disconnect()
        posLockConnection = nil
    end
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
end

for _, loc in ipairs(Locations) do
    AutoFarm:AddSwitch(loc.name, function(bool)
        if bool then
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(loc.pos + Vector3.new(0, 3, 0))
                task.wait(0.3)
                lockAndSimulate(hrp.CFrame)
            end
        else
            stopAll()
        end
    end)
end


AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("💢 Brawl")

local autoBrawl = false
local godModeToggle = false
local autoWinBrawl = false
local parts = {}

local function manageParts(state)
    if state and #parts == 0 then
        local partSize = 2048
        local totalDistance = 50000
        local startPosition = Vector3.new(-2, -9.5, -2)
        local numberOfParts = math.ceil(totalDistance / partSize)
        for x = 0, numberOfParts - 1 do
            for z = 0, numberOfParts - 1 do
                local positions = {
                    startPosition + Vector3.new(x * partSize, 0, z * partSize),
                    startPosition + Vector3.new(-x * partSize, 0, z * partSize),
                    startPosition + Vector3.new(-x * partSize, 0, -z * partSize),
                    startPosition + Vector3.new(x * partSize, 0, -z * partSize)
                }
                for _, pos in ipairs(positions) do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(partSize, 1, partSize)
                    p.Position = pos
                    p.Anchored = true
                    p.Transparency = 1
                    p.CanCollide = true
                    p.Parent = workspace
                    table.insert(parts, p)
                end
            end
        end
    elseif not state then
        for _, p in ipairs(parts) do p.CanCollide = false end
    else
        for _, p in ipairs(parts) do p.CanCollide = true end
    end
end

AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("👊 Auto Brawl")

AutoFarm:AddSwitch("🏆 Auto Join Brawl", function(state)
    autoBrawl = state
    task.spawn(function()
        while autoBrawl do
            game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
            task.wait(5)
        end
    end)
end)

AutoFarm:AddSwitch("🛡️ God Mode", function(state)
    godModeToggle = state
    manageParts(state)
    if state then
        task.spawn(function()
            while godModeToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(0)
            end
        end)
    end
end)

AutoFarm:AddSwitch("⚔️ Auto Win Brawl", function(state)
    autoWinBrawl = state
    if state then
        task.spawn(function()
            while autoWinBrawl do
                local lp = game:GetService("Players").LocalPlayer
                local char = lp.Character
                if char then
                    local punch = lp.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                    if punch then
                        punch.Parent = char
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                        punch:Activate()
                    end
                    
                    local rHand = char:FindFirstChild("RightHand")
                    local lHand = char:FindFirstChild("LeftHand")
                    if rHand and lHand then
                        for _, target in ipairs(game:GetService("Players"):GetPlayers()) do
                            if target ~= lp and target.Character then
                                local root = target.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    pcall(function()
                                        firetouchinterest(rHand, root, 1)
                                        firetouchinterest(lHand, root, 1)
                                        firetouchinterest(rHand, root, 0)
                                        firetouchinterest(lHand, root, 0)
                                    end)
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end)

AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("⚡ OP Tools")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function manageToolCombo(toolName)
    task.spawn(function()
        while _G[toolName.."On"] do
            local character = LocalPlayer.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            
            if character and hum then
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or character:FindFirstChild("Punch")
                local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)

                if punch then
                    if punch.Parent ~= character then
                        hum:EquipTool(punch)
                    end
                    if punch:FindFirstChild("attackTime") then 
                        punch.attackTime.Value = 0 
                    end
                    punch:Activate()
                end

                if tool then
                    if tool.Parent ~= character then
                        hum:EquipTool(tool)
                    end
                    
                    local event = LocalPlayer:FindFirstChild("muscleEvent")
                    if event then 
                        event:FireServer("rep") 
                    end
                    tool:Activate()
                end
            end
            task.wait(0.01)
        end
    end)
end

AutoFarm:AddSwitch("🏋️ Weight + 🥊 Punch", function(bool)
    _G.WeightOn = bool
    if bool then manageToolCombo("Weight") end
end)

AutoFarm:AddSwitch("💪 Pushups + 🥊 Punch", function(bool)
    _G.PushupsOn = bool
    if bool then manageToolCombo("Pushups") end
end)

AutoFarm:AddSwitch("🤸 Handstand + 🥊 Punch", function(bool)
    _G.HandstandOn = bool
    if bool then manageToolCombo("Handstand") end
end)

AutoFarm:AddSwitch("🧘 Situps + 🥊 Punch", function(bool)
    _G.SitupsOn = bool
    if bool then manageToolCombo("Situps") end
end)



AutoFarm:AddLabel("----------------------------")
AutoFarm:AddLabel("🏋️ GYM FARM")

local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function pressEKey()
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function createGymFarm(folder, toggleName, cframeValue, eventName)
    local active = false

    folder:AddSwitch(toggleName, function(bool)
        active = bool

        if bool then
            task.spawn(function()
                while active do
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    if root then
                        if (root.Position - cframeValue.Position).Magnitude > 5 then
                            root.CFrame = cframeValue
                            task.wait(0.3)
                            pressEKey()
                        end

                        local event = LocalPlayer:FindFirstChild("muscleEvent")

                        if event then
                            event:FireServer(eventName)
                        end
                    end

                    task.wait(0.05)
                end
            end)
        end
    end)
end


-- ⚙️ INDUSTRIAL GYM
local IndustrialFolder = AutoFarm:AddFolder("⚙️ Industrial Gym")

createGymFarm(
    IndustrialFolder,
    "⚙️ Auto Industrial Bar Lift",
    CFrame.new(-5492.24, 81.82, 4644.04),
    "rep"
)

createGymFarm(
    IndustrialFolder,
    "🏋️ Auto Industrial Bench",
    CFrame.new(-5014.39, 111.46, 4462.90),
    "rep"
)

createGymFarm(
    IndustrialFolder,
    "🦵 Auto Industrial Squat",
    CFrame.new(-5216.36, 90.17, 5420.08),
    "rep"
)

createGymFarm(
    IndustrialFolder,
    "💢 Auto Industrial Boulder",
    CFrame.new(-5452.94, 84.47, 5232.03),
    "rep"
)


-- 🌴 JUNGLE GYM
local JungleFolder = AutoFarm:AddFolder("🌴 Jungle Gym")

createGymFarm(
    JungleFolder,
    "🏋️ Auto Jungle Lift",
    CFrame.new(-8652.85, 45.22, 2088.99),
    "rep"
)

createGymFarm(
    JungleFolder,
    "💪 Auto Jungle Bench Press",
    CFrame.new(-8173.23, 83.82, 1907.40),
    "rep"
)

createGymFarm(
    JungleFolder,
    "🦵 Auto Jungle Squat",
    CFrame.new(-8377.55, 48.71, 2864.90),
    "rep"
)

createGymFarm(
    JungleFolder,
    "🗿 Auto Jungle Boulder",
    CFrame.new(-8614.81, 51.90, 2677.37),
    "rep"
)


-- 👑 MUSCLE KING
local MuscleKingFolder = AutoFarm:AddFolder("👑 Muscle King")

createGymFarm(
    MuscleKingFolder,
    "🏋️ Auto Muscle King Lift",
    CFrame.new(-8774.03, 52.15, -5664.10),
    "rep"
)

createGymFarm(
    MuscleKingFolder,
    "💪 Auto Muscle King Bench Press",
    CFrame.new(-8589.43, 58.00, -6044.57),
    "rep"
)

createGymFarm(
    MuscleKingFolder,
    "🦵 Auto Muscle King Squat",
    CFrame.new(-8759.62, 46.50, -6041.16),
    "rep"
)

createGymFarm(
    MuscleKingFolder,
    "🗿 Auto Muscle King Boulder",
    CFrame.new(-8942.97, 60.71, -5692.74),
    "rep"
)


-- 🌟 LEGENDS GYM
local LegendsFolder = AutoFarm:AddFolder("🌟 Legends Gym")

createGymFarm(
    LegendsFolder,
    "🏋️ Auto Legends Lift",
    CFrame.new(4532.02, 1025.80, -4002.15),
    "rep"
)

createGymFarm(
    LegendsFolder,
    "💪 Auto Legends Bench Press",
    CFrame.new(4109.20, 1035.67, -3802.88),
    "rep"
)

createGymFarm(
    LegendsFolder,
    "🦵 Auto Legends Squat",
    CFrame.new(4438.74, 1021.38, -4058.46),
    "rep"
)

createGymFarm(
    LegendsFolder,
    "🗿 Auto Legends Boulder",
    CFrame.new(4188.75, 1019.85, -3905.19),
    "rep"
)


-- 🔮 MYTHICAL GYM
local MythicalFolder = AutoFarm:AddFolder("🔮 Mythical Gym")

createGymFarm(
    MythicalFolder,
    "🏋️ Auto Mythical Lift",
    CFrame.new(2486.75, 31.91, 847.89),
    "rep"
)

createGymFarm(
    MythicalFolder,
    "💪 Auto Mythical Bench Press",
    CFrame.new(2370.74, 57.09, 1243.37),
    "rep"
)

createGymFarm(
    MythicalFolder,
    "🗿 Auto Mythical Boulder",
    CFrame.new(2667.31, 58.88, 1202.46),
    "rep"
)


-- ❄️ FROST GYM
local FrostFolder = AutoFarm:AddFolder("❄️ Frost Gym")

createGymFarm(
    FrostFolder,
    "🏋️ Auto Frost Lift",
    CFrame.new(-2917.62, 42.60, -211.29),
    "rep"
)

createGymFarm(
    FrostFolder,
    "💪 Auto Frost Bench Press",
    CFrame.new(-3022.97, 41.31, -197.51),
    "rep"
)

createGymFarm(
    FrostFolder,
    "🦵 Auto Frost Squat",
    CFrame.new(-2720.66, 27.85, -590.72),
    "rep"
)


local rebirths = window:AddTab("Rebirths")

rebirths:AddTextBox("🔢 Rebirth Target", function(text)
    local newValue = tonumber(text)
    if newValue and newValue > 0 then
        targetRebirthValue = newValue
        updateStats() 
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Updated Goal",
            Text = "New goal: " .. tostring(targetRebirthValue) .. " rebirths",
            Duration = 0
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Size",
            Text = "Put a size larger than 0",
            Duration = 0
        })
    end
end)

local infiniteSwitch

local targetSwitch = rebirths:AddSwitch("🔄 Auto Rebirth Target", function(bool)
    _G.targetRebirthActive = bool
    
    if bool then
        if _G.infiniteRebirthActive and infiniteSwitch then
            infiniteSwitch:Set(false)
            _G.infiniteRebirthActive = false
        end
        
        spawn(function()
            while _G.targetRebirthActive and wait(0.1) do
                local currentRebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
                
                if currentRebirths >= targetRebirthValue then
                    targetSwitch:Set(false)
                    _G.targetRebirthActive = false
                    
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Goal Reached",
                        Text = "You Have Reached" .. tostring(targetRebirthValue) .. " renacimientos",
                        Duration = 5
                    })
                    
                    break
						end
						
                game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end
        end)
    end
end, "automatic rebirth until reaching the goal")

infiniteSwitch = rebirths:AddSwitch("♾️ Auto Rebirth (Infinitely)", function(bool)
    _G.infiniteRebirthActive = bool
    
    if bool then
        if _G.targetRebirthActive and targetSwitch then
            targetSwitch:Set(false)
            _G.targetRebirthActive = false
        end
        
        spawn(function()
            while _G.infiniteRebirthActive and wait(0.1) do
                game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end
        end)
    end
end, "rebirth infinitely")

local sizeSwitch = rebirths:AddSwitch("Auto Size 1📏", function(bool)
    _G.autoSizeActive = bool
    
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
            end
        end)
    end
end, "Size 1")

local sizeSwitch = rebirths:AddSwitch("Auto Size 2📏", function(bool)
    _G.autoSizeActive = bool
    
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
            end
        end)
    end
end, "Size 2")

local teleportSwitch = rebirths:AddSwitch("👑 Auto Teleport to Muscle King", function(bool)
    _G.teleportActive = bool
    
    if bool then
        spawn(function()
            while _G.teleportActive and wait() do
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-8771, 85, -5830))
                end
            end
        end)
    end
end, "Tp to Mk")

local blockedFrames = {
	"strengthFrame",
	"durabilityFrame",
	"agilityFrame",
	"evilKarmaFrame",
	"goodKarmaFrame",
}

local frameSwitch = rebirths:AddSwitch("👁️‍🗨️ Hide All Frames", function(bool)
	if bool then
		for _, name in ipairs(blockedFrames) do
			local frame = replicatedStorage:FindFirstChild(name)
			if frame and frame:IsA("GuiObject") then
				frame.Visible = false
			end
		end

		if not _G.frameMonitorConnection then
			_G.frameMonitorConnection = replicatedStorage.ChildAdded:Connect(function(child)
				for _, name in ipairs(blockedFrames) do
					if child.Name == name and child:IsA("GuiObject") then
						child.Visible = false
					end
				end
			end)
		end
	else
		for _, name in ipairs(blockedFrames) do
			local frame = replicatedStorage:FindFirstChild(name)
			if frame and frame:IsA("GuiObject") then
				frame.Visible = true
			end
		end

		if _G.frameMonitorConnection then
			_G.frameMonitorConnection:Disconnect()
			_G.frameMonitorConnection = nil
		end
	end
end)
frameSwitch:Set(false)

local selectedUltimate = nil
local autoBuyActive = false
local ultimateRemote = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("ultimatesRemote")

local upgradeDropdown = rebirths:AddDropdown("📦 Select Ultımate", function(choice)
    selectedUltimate = choice
end)

local items = {
    "RepSpeed", "PetSlot", "ItemCapacity", "DailySpin", 
    "ChestRewards", "QuestRewards", "MuscleMind", "JungleSwift", 
    "InfernalHealth", "GalaxyGains", "DemonDamage", "GoldenRebirth"
}

for _, itemName in ipairs(items) do
    upgradeDropdown:Add(itemName)
end

rebirths:AddSwitch("🔄 Auto Buy Selected", function(state)
    autoBuyActive = state
    if autoBuyActive then
        task.spawn(function()
            while autoBuyActive do
                if selectedUltimate then
                    pcall(function()
                        ultimateRemote:InvokeServer("upgradeUltimate", selectedUltimate)
                    end)
                end
                task.wait(0.5)
            end
        end)
    end
end)

local Killer = window:AddTab("Kill")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerWhitelist = {}
local targetPlayerNames = {}
local autoGoodKarma = false
local autoBadKarma = false
local autoKill = false
local killTarget = false
local spying = false
local autoPunchNoAnim = false
local targetDropdownItems = {}
local availableTargets = {}

local titleLabel = Killer:AddLabel("🐲 Select damage or durability pet")
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.Merriweather 
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local dropdown = Killer:AddDropdown("Select Pet", function(text)
    local petsFolder = game.Players.LocalPlayer.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)

    local petName = text
    local petsToEquip = {}

    for _, pet in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    local maxPets = 8
    local equippedCount = math.min(#petsToEquip, maxPets)

    for i = 1, equippedCount do
        game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end)

local Wild_Wizard = dropdown:Add("Wild Wizard")
local Powerful_Monster = dropdown:Add("Mighty Monster")


Killer:AddSwitch("😇 Auto Good Karma", function(bool)
    autoGoodKarma = bool
    task.spawn(function()
        while autoGoodKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

Killer:AddSwitch("😈 Auto Bad Karma", function(bool)
    autoBadKarma = bool
    task.spawn(function()
        while autoBadKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local friendWhitelistActive = false

Killer:AddSwitch("👥 Auto Whitelist Friends", function(state)
    friendWhitelistActive = state

    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                if not table.find(_G.whitelistedPlayers, player.Name) then
                    table.insert(_G.whitelistedPlayers, player.Name)
                    print(player.Name .. " (amigo) aÃ±adido a Whitelist")
                end
            end
        end

        Players.PlayerAdded:Connect(function(player)
            if friendWhitelistActive and player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                if not table.find(_G.whitelistedPlayers, player.Name) then
                    table.insert(_G.whitelistedPlayers, player.Name)
                    print(player.Name .. " (amigo) aÃ±adido a Whitelist")
                end
            end
        end)
    else
        for i = #_G.whitelistedPlayers, 1, -1 do
            local friend = Players:FindFirstChild(_G.whitelistedPlayers[i])
            if friend and LocalPlayer:IsFriendsWith(friend.UserId) then
                print(_G.whitelistedPlayers[i] .. " (amigo) eliminado de Whitelist")
                table.remove(_G.whitelistedPlayers, i)
            end
        end
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.whitelistedPlayers = _G.whitelistedPlayers or {}

local whitelistDropdownItems = {}
local selectedWhitelist = nil

-- Dropdown con DisplayName
local whitelistDropdown = Killer:AddDropdown("🪽 Add to Whitelist", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            if not table.find(_G.whitelistedPlayers, player.Name) then
                table.insert(_G.whitelistedPlayers, player.Name) -- guardamos Name real
            end
            selectedWhitelist = player.Name
            print(player.Name .. " agregado a Whitelist")
            break
        end
    end
end)

-- BotÃ³n para remover jugador seleccionado de whitelist
Killer:AddButton("Remove Selected Whitelist", function()
    if selectedWhitelist then
        for i, v in ipairs(_G.whitelistedPlayers) do
            if v == selectedWhitelist then
                table.remove(_G.whitelistedPlayers, i)
                print(selectedWhitelist .. " eliminado de Whitelist")
                break
            end
        end
        selectedWhitelist = nil
    end
end)

-- Inicializar con jugadores actuales
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        whitelistDropdown:Add(player.DisplayName)
        whitelistDropdownItems[player.Name] = player.DisplayName
    end
end

-- Cuando entra un jugador nuevo
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        whitelistDropdown:Add(player.DisplayName)
        whitelistDropdownItems[player.Name] = player.DisplayName
    end
end)

-- Cuando un jugador se va
Players.PlayerRemoving:Connect(function(player)
    if whitelistDropdownItems[player.Name] then
        whitelistDropdownItems[player.Name] = nil
        whitelistDropdown:Clear()
        for _, displayName in pairs(whitelistDropdownItems) do
            whitelistDropdown:Add(displayName)
        end
    end

    for i = #_G.whitelistedPlayers, 1, -1 do
        if _G.whitelistedPlayers[i] == player.Name then
            table.remove(_G.whitelistedPlayers, i)
        end
    end
end)


Killer:AddSwitch("🔪 Auto Kill", function(bool)
    autoKill = bool

    task.spawn(function()
        while autoKill do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rightHand = character:FindFirstChild("RightHand")
            local leftHand = character:FindFirstChild("LeftHand")

            -- Asegurar que tengas el Punch equipado
            local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
            if punch and not character:FindFirstChild("Punch") then
                punch.Parent = character
            end

            if rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character then
                        -- ðŸ”¹ Checar si estÃ¡ en Whitelist
                        local isWhitelisted = false
                        for _, name in ipairs(_G.whitelistedPlayers) do
                            if name:lower() == target.Name:lower() then
                                isWhitelisted = true
                                break
                            end
                        end

                        -- Solo atacar si NO estÃ¡ en la Whitelist
                        if not isWhitelisted then
                            local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                            local humanoid = target.Character:FindFirstChild("Humanoid")
                            if rootPart and humanoid and humanoid.Health > 0 then
                                pcall(function()
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end)
                            end
                        end
                    end
                end
            end

            task.wait(0.05)
        end
    end)
end)


local targetDropdownItems = {}
local targetPlayerNames = {}
local selectedTarget = nil

local function waitForCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")
    return char
end

local function ensurePunch(char)
    local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
    if not punch then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool.Name == "Punch" then
                punch = tool
                break
            end
        end
    end
    if punch then
        punch.Parent = char
        return punch
    end
    return nil
end

local targetDropdown = Killer:AddDropdown("🎯 Select Target", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            if not table.find(targetPlayerNames, player.Name) then
                table.insert(targetPlayerNames, player.Name)
            end
            selectedTarget = player.Name
            break
        end
    end
end)

Killer:AddButton("👹 Remove Selected Target", function()
    if selectedTarget then
        for i, v in ipairs(targetPlayerNames) do
            if v == selectedTarget then
                table.remove(targetPlayerNames, i)
                break
            end
        end
        selectedTarget = nil
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
        targetDropdownItems[player.Name] = player.DisplayName
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
        targetDropdownItems[player.Name] = player.DisplayName
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if targetDropdownItems[player.Name] then
        targetDropdownItems[player.Name] = nil
        targetDropdown:Clear()
        for _, displayName in pairs(targetDropdownItems) do
            targetDropdown:Add(displayName)
        end
    end
    for i = #targetPlayerNames, 1, -1 do
        if targetPlayerNames[i] == player.Name then
            table.remove(targetPlayerNames, i)
        end
    end
end)

Killer:AddSwitch("🎯 Start Kill Target", function(state)
    killTarget = state
    if state then
        task.spawn(function()
            while killTarget do
                local char = LocalPlayer.Character
                if not char then
                    char = waitForCharacter()
                end

                local punch = ensurePunch(char)
                local rightHand = char:FindFirstChild("RightHand")
                local leftHand = char:FindFirstChild("LeftHand")

                if not (rightHand and leftHand) then
                    task.wait(0.1)
                    continue
                end

                if punch then
                    pcall(function()
                        LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                        LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                    end)
                end

                for _, name in ipairs(targetPlayerNames) do
                    local target = Players:FindFirstChild(name)
                    if target and target ~= LocalPlayer and target.Character then
                        local root = target.Character:FindFirstChild("HumanoidRootPart")
                        local hum = target.Character:FindFirstChild("Humanoid")
                        if root and hum and hum.Health > 0 then
                            pcall(function()
                                firetouchinterest(rightHand, root, 1)
                                firetouchinterest(leftHand, root, 1)
                                firetouchinterest(rightHand, root, 0)
                                firetouchinterest(leftHand, root, 0)
                            end)
                        end
                    end
                end

                task.wait(0.04)
            end
        end)
    end
end)

local spyTargetDropdownItems = {}
local targetPlayerName = nil

local spyTargetDropdown = Killer:AddDropdown("Select View Target", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            targetPlayerName = player.Name
            break
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.DisplayName)
        spyTargetDropdownItems[player.Name] = player.DisplayName
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.DisplayName)
        spyTargetDropdownItems[player.Name] = player.DisplayName
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdownItems[player.Name] = nil
        spyTargetDropdown:Clear()
        for _, displayName in pairs(spyTargetDropdownItems) do
            spyTargetDropdown:Add(displayName)
        end
    end
end)

Killer:AddSwitch("🙋‍♂️ View Player", function(bool)
    spying = bool
    if not spying then
        local cam = workspace.CurrentCamera
        cam.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer
        return
    end
    task.spawn(function()
        while spying do
            local target = Players:FindFirstChild(targetPlayerName)
            if target and target ~= LocalPlayer then
                local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
            task.wait(0.1)
        end
    end)
end)

local button = Killer:AddButton("🚫 Remove Punch Anim", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }

    local function setupAnimationBlocking()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end

        local humanoid = char:FindFirstChild("Humanoid")

        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId
                local animName = track.Name:lower()

                if blockedAnimations[animId] or
                    animName:match("punch") or
                    animName:match("attack") or
                    animName:match("right") then
                    track:Stop()
                end
            end
        end

        if not _G.AnimBlockConnection then
            local connection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or
                        animName:match("punch") or
                        animName:match("attack") or
                        animName:match("right") then
                        track:Stop()
                    end
                end
            end)

            _G.AnimBlockConnection = connection
        end
    end

    setupAnimationBlocking()

    local function overrideToolActivation()
        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    local connection = tool.Activated:Connect(function()
                        task.wait(0.05)

                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or
                                        animName:match("punch") or
                                        animName:match("attack") or
                                        animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)

                    if not _G.ToolConnections then
                        _G.ToolConnections = {}
                    end
                    _G.ToolConnections[tool] = connection
                end
            end
        end

        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            processTool(tool)
        end

        local char = game.Players.LocalPlayer.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    processTool(tool)
                end
            end
        end

        if not _G.BackpackAddedConnection then
            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end

        if not _G.CharacterToolAddedConnection and char then
            _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end
    end

    overrideToolActivation()

    if not _G.AnimMonitorConnection then
        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or
                                animName:match("punch") or
                                animName:match("attack") or
                                animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)
    end

    if not _G.CharacterAddedConnection then
        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)
    end
end)

function RecoveryPunch()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
    if _G.AnimMonitorConnection then
        _G.AnimMonitorConnection:Disconnect()
        _G.AnimMonitorConnection = nil
    end
    if _G.ToolConnections then
        for _, conn in pairs(_G.ToolConnections) do
            if conn then conn:Disconnect() end
        end
        _G.ToolConnections = nil
    end
    if _G.BackpackAddedConnection then
        _G.BackpackAddedConnection:Disconnect()
        _G.BackpackAddedConnection = nil
    end
    if _G.CharacterToolAddedConnection then
        _G.CharacterToolAddedConnection:Disconnect()
        _G.CharacterToolAddedConnection = nil
    end
    if _G.CharacterAddedConnection then
        _G.CharacterAddedConnection:Disconnect()
        _G.CharacterAddedConnection = nil
    end
end

Killer:AddButton("👾 Recover Punch Anim", function()
    RecoveryPunch()
end)

Killer:AddSwitch("👊 Auto Punch [without animation]", function(state)
	autoPunchNoAnim = state
	if state then
		task.spawn(function()
			while autoPunchNoAnim do
				local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")

				local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")

				if not punch then
					for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
						if tool.Name == "Punch" then
							tool.Parent = char
						end
					end
					task.wait(0.05)
					continue
				end

				if punch.Parent ~= char then
					punch.Parent = char
				end

				pcall(function()
					LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
					LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
				end)

				task.wait(0.03)
			end
		end)
	else
		autoPunchNoAnim = false
	end
end)


Killer:AddSwitch("🥊 Auto Punch", function(state)
	_G.fastHitActive = state
	if state then
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = LocalPlayer.Character
					if punch:FindFirstChild("attackTime") then
						punch.attackTime.Value = 0
					end
				end
				task.wait(0.1)
			end
		end)
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
				if punch then
					punch:Activate()
				end
				task.wait(0.1)
			end
		end)
	else
		local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
		if punch then
			punch.Parent = LocalPlayer.Backpack
		end
	end
end)





local godModeToggle = false
Killer:AddSwitch("God mode", function(State)
    godModeToggle = State
    if State then
        task.spawn(function()
            while godModeToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait()
            end
        end)
    end
end)
Killer:AddButton("📏 Size 30", function()
    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 30)
end)

Killer:AddButton("📏 Size 2", function()
    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
end)

local following = false
local followTarget = nil

local function followPlayer(targetPlayer)
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character

    if not (myChar and targetChar) then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

    if myHRP and targetHRP then
        local followPos = targetHRP.Position - (targetHRP.CFrame.LookVector * 3)
        myHRP.CFrame = CFrame.new(followPos, targetHRP.Position)
    end
end

local followDropdown = Killer:AddDropdown("Teleport player", function(selectedDisplayName)
    if selectedDisplayName and selectedDisplayName ~= "" then
        -- Buscar jugador por DisplayName
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == selectedDisplayName then
                target = plr
                break
            end
        end

        if target then
            followTarget = target.Name -- Guardamos Name real para seguir
            following = true
            print("âœ… Started following:", target.Name)
            followPlayer(target)
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        followDropdown:Add(player.DisplayName)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        followDropdown:Add(player.DisplayName)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    followDropdown:Clear()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            followDropdown:Add(plr.DisplayName)
        end
    end

    if followTarget == player.Name then
        followTarget = nil
        following = false
    end
end)

Killer:AddButton("⚡️ Dejar de Seguir", function()
    following = false
    followTarget = nil
    print("â›” Stopped following")
end)

task.spawn(function()
    while task.wait(0.01) do
        if following and followTarget then
            local target = Players:FindFirstChild(followTarget)
            if target then
                followPlayer(target)
            else
                following = false
                followTarget = nil
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if following and followTarget then
        local target = Players:FindFirstChild(followTarget)
        if target then
            followPlayer(target)
        end
    end
end)

local godDamageActive = false


Killer:AddSwitch("🦵 auto slams", function(state)
    godDamageActive = state
    if state then
        task.spawn(function()
            while godDamageActive do
                local player = LocalPlayer
                local groundSlam = player.Backpack:FindFirstChild("Ground Slam") or (player.Character and player.Character:FindFirstChild("Ground Slam"))

                if groundSlam then
                    if groundSlam.Parent == player.Backpack then
                        groundSlam.Parent = player.Character
                    end
                    if groundSlam:FindFirstChild("attackTime") then
                        groundSlam.attackTime.Value = 0
                    end
                    player.muscleEvent:FireServer("slam")
                    groundSlam:Activate()
                end

                task.wait(0.1)
            end
        end)
    end
end)
Killer:AddLabel("Dead Ring:").TextSize = 22

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ringPart = nil
local ringColor = Color3.fromRGB(50, 163, 255)
local ringTransparency = 0.6
_G.showDeathRing = false
_G.deathRingRange = 20
_G.deathRingEnabled = false

local function updateRingSize()
    if not ringPart then return end
    local d = (_G.deathRingRange or 20) * 2
    ringPart.Size = Vector3.new(0.2, d, d)
end

Killer:AddTextBox("Range 1-150", function(text)
    local r = tonumber(text)
    if r then
        _G.deathRingRange = math.clamp(r, 1, 150)
        updateRingSize()
    end
end)

local function toggleRingVisual()
    if _G.showDeathRing then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = ringColor
        ringPart.Transparency = ringTransparency
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        updateRingSize()
        ringPart.Parent = workspace
    elseif ringPart then
        ringPart:Destroy()
        ringPart = nil
    end
end

local function updateRingPosition()
    if not ringPart then return end
    local c = LocalPlayer.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    ringPart.CFrame = c.HumanoidRootPart.CFrame
        * CFrame.new(0, -2.3, 0)
        * CFrame.Angles(0, 0, math.rad(90))
end

local function isPlayerAlive(plr)
    local c = plr.Character
    if not c then return false end
    local h = c:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function isWhitelisted(plr)
    if not _G.whitelistedPlayers then return false end
    for _, n in ipairs(_G.whitelistedPlayers) do
        if n:lower() == plr.Name:lower() then
            return true
        end
    end
    return false
end

local function equipPunch()
    local char = LocalPlayer.Character
    if not char then return nil end

    local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
    if punch then
        punch.Parent = char
        return punch
    end

    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool.Name == "Punch" then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function unequipPunch()
    local char = LocalPlayer.Character
    if not char then return end
    local punch = char:FindFirstChild("Punch")
    if punch then
        punch.Parent = LocalPlayer.Backpack
    end
end

local function killPlayer(plr)
    local char = LocalPlayer.Character
    if not char then return end

    local punch = equipPunch()
    if not punch then return end

    local right = char:FindFirstChild("RightHand")
    local left = char:FindFirstChild("LeftHand")
    if not right or not left then return end

    local targetRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    pcall(function()
        firetouchinterest(right, targetRoot, 1)
        firetouchinterest(left, targetRoot, 1)
        firetouchinterest(right, targetRoot, 0)
        firetouchinterest(left, targetRoot, 0)
    end)

    pcall(function()
        if LocalPlayer:FindFirstChild("muscleEvent") then
            LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
            LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
        end
    end)
end

Killer:AddSwitch("Death Ring", function(state)
    _G.deathRingEnabled = state

    if state then
        if not _G.deathRingConnection then
            _G.deathRingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateRingPosition()

                local c = LocalPlayer.Character
                local rp = c and c:FindFirstChild("HumanoidRootPart")
                if not rp then return end

                local someoneInRange = false

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and not isWhitelisted(plr) and isPlayerAlive(plr) then
                        local dist = (rp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= (_G.deathRingRange or 20) then
                            someoneInRange = true
                            killPlayer(plr)
                        end
                    end
                end

                if someoneInRange == false then
                    unequipPunch()
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
        unequipPunch()
    end
end)

Killer:AddSwitch("Show Ring", function(state)
    _G.showDeathRing = state
    toggleRingVisual()
end)

local Lighting = game:GetService("Lighting")

-- Tabla para registrar los tiempos disponibles
local timeOptions = {
    "Morning",
    "Noon",
    "Afternoon",
    "Sunset",
    "Night",
    "Midnight",
    "Dawn",
    "Early Morning"
}

local timeDropdown = Killer:AddDropdown("change time", function(selection)
    -- Reset antes de aplicar
    Lighting.Brightness = 2
    Lighting.FogEnd = 100000
    Lighting.Ambient = Color3.fromRGB(127,127,127)

    if selection == "Morning" then
        Lighting.ClockTime = 6
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(200, 200, 255)
    elseif selection == "Noon" then
        Lighting.ClockTime = 12
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    elseif selection == "Afternoon" then
        Lighting.ClockTime = 16
        Lighting.Brightness = 2.5
        Lighting.Ambient = Color3.fromRGB(255, 220, 180)
    elseif selection == "Sunset" then
        Lighting.ClockTime = 18
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 150, 100)
        Lighting.FogEnd = 500
    elseif selection == "Nigth" then
        Lighting.ClockTime = 20
        Lighting.Brightness = 1.5
        Lighting.Ambient = Color3.fromRGB(100, 100, 150)
        Lighting.FogEnd = 800
    elseif selection == "Midnight" then
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(50, 50, 100)
        Lighting.FogEnd = 400
    elseif selection == "Dawn" then
        Lighting.ClockTime = 4
        Lighting.Brightness = 1.8
        Lighting.Ambient = Color3.fromRGB(180, 180, 220)
    elseif selection == "Early Morning" then
        Lighting.ClockTime = 2
        Lighting.Brightness = 1.2
        Lighting.Ambient = Color3.fromRGB(100, 120, 180)
    end
end)

for _, option in ipairs(timeOptions) do
    timeDropdown:Add(option)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local titleLabel = Killer:AddLabel("Add the display name or initials of his clan")
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.Merriweather 
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local fileName = "GenesisBlacklist_"..LocalPlayer.Name..".txt"
local blacklistWords = {}
local active = {}
local attackDelay = 0.06
local characterLoaded = false
local autoPunchActive = false

local function trim(s) 
	return s:match("^%s*(.-)%s*$") 
end

local function parseList(text)
	blacklistWords = {}
	if not text or text == "" then return end
	for w in string.gmatch(text, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(blacklistWords, t) end
	end
end

if isfile(fileName) then
	parseList(readfile(fileName))
else
	writefile(fileName, "")
end

local function saveList()
	writefile(fileName, table.concat(blacklistWords, ","))
end

local function nameMatchesAny(player)
	if not player then return false end
	local dn = (player.DisplayName or ""):lower()
	for _, w in ipairs(blacklistWords) do
		if w ~= "" and string.find(dn, w, 1, true) then
			return true
		end
	end
	return false
end

local function refreshActive()
	for k in pairs(active) do active[k] = nil end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and nameMatchesAny(plr) then
			active[plr] = true
		end
	end
end

function isAnyActive()
	for _ in pairs(active) do
		return true
	end
	return false
end

local function getHands(char)
	repeat task.wait() until char and char:FindFirstChild("RightHand")
	local right = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
	local left = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	return right, left
end

local function ensurePunchEquipped()
	if not isAnyActive() then return nil end  -- 🔥 NO EQUIPAR si no hay targets

	local char = LocalPlayer.Character
	if not char then return nil end

	local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")

	if punch and punch.Parent ~= char then
		punch.Parent = char
	end

	if not punch then
		task.defer(function()
			for i = 1, 40 do
				if not isAnyActive() then return end -- 🔥 Detener si ya no hay targets
				local p = LocalPlayer.Backpack:FindFirstChild("Punch")
				if p then
					p.Parent = LocalPlayer.Character
					break
				end
				task.wait(0.1)
			end
		end)
	end

	return char:FindFirstChild("Punch")
end

local function waitForCharacter()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	characterLoaded = true

	task.spawn(function()
		repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")

		if isAnyActive() then  -- 🔥 SOLO EQUIPAR si hay alguien de la blacklist
			for i = 1, 60 do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = char
					break
				end
				task.wait(0.1)
			end
		end
	end)

	return char
end

blacklistLabel = Killer:AddLabel("")
blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

local blacklistBox = Killer:AddTextBox("Add to Blacklist", function(txt)
	parseList((table.concat(blacklistWords, ",")..","..txt))
	saveList()
	blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

	refreshActive()
	if not isAnyActive() then autoPunchActive = false end
end, {["placeholder"] = "Ej: MVX, Sigma, Juan"})

local removeBox = Killer:AddTextBox("Remove from Blacklist", function(txt)
	local toRemove = {}
	for w in string.gmatch(txt, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(toRemove, t) end
	end

	for _, word in ipairs(toRemove) do
		for i = #blacklistWords, 1, -1 do
			if blacklistWords[i] == word then
				table.remove(blacklistWords, i)
			end
		end
	end

	saveList()
	blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

	refreshActive()

	if not isAnyActive() then autoPunchActive = false end
end)

RunService.Heartbeat:Connect(function()
	refreshActive()
end)

task.spawn(function()
	while true do
		task.wait(attackDelay)

		if not isAnyActive() then
			continue
		end

		if not LocalPlayer.Character then continue end
		if not characterLoaded then continue end

		local punch = ensurePunchEquipped()
		if not punch then continue end

		local char = LocalPlayer.Character
		local rightHand, leftHand = getHands(char)

		for plr in pairs(active) do
			if plr and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local hum = plr.Character:FindFirstChild("Humanoid")

				if hrp and hum and hum.Health > 0 then
					pcall(function()
						LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
						LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
					end)

					pcall(function()
						firetouchinterest(rightHand, hrp, 1)
						firetouchinterest(leftHand, hrp, 1)
						firetouchinterest(rightHand, hrp, 0)
						firetouchinterest(leftHand, hrp, 0)
					end)
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
		refreshActive()
	end)
end)

LocalPlayer.CharacterAdded:Connect(function()
	characterLoaded = false
	task.wait(0.2)

	waitForCharacter()
	refreshActive()

	if isAnyActive() then
		task.defer(function()
			for i = 1, 50 do
				if not isAnyActive() then break end
				ensurePunchEquipped()
				task.wait(0.15)
			end
		end)
	end
end)

waitForCharacter()
refreshActive()

local Rock = window:AddTab("Rock")

function gettool()
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

Rock:AddSwitch("💎 Tiny Rock 0", function(Value)
    selectrock = "Tiny Island Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 0 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 0 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🔥 Starter Rock 100", function(Value)
    selectrock = "Starter Island Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 100 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 100 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🏝️ Legend Beach Rock 5K", function(Value)
    selectrock = "Legend Beach Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 5000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 5000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("❄️ Frozen Rock 150K", function(Value)
    selectrock = "Frost Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 150000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 150000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("✨ Mythical Rock 400K", function(Value)
    selectrock = "Mythical Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 400000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 400000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🔥 Eternal Rock 750K", function(Value)
    selectrock = "Eternal Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 750000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 750000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🏆 Legend Rock 1M", function(Value)
    selectrock = "Legend Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 1000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 1000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("👑 Muscle King Rock 5M", function(Value)
    selectrock = "Muscle King Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 5000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 5000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🌴 Jungle Rock 10M", function(Value)
    selectrock = "Ancient Jungle Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 10000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 10000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("⚙️ Industrial Jungle Rock 25M", function(Value)
    selectrock = "Industrial Jungle Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 25000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 25000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddLabel("👊 Auto Rock V2 (Teleport)")

local FaceDirections = {
    North = Vector3.new(0, 0, -1),
    South = Vector3.new(0, 0, 1),
    East = Vector3.new(1, 0, 0),
    West = Vector3.new(-1, 0, 0),
}

local function LockPosition(CFramePosition)
    _G.lockRunning = true
    _G.LockedCFrame = CFramePosition
    
    if _G.lockConnection then
        _G.lockConnection:Disconnect()
    end
    
    _G.lockConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local Character = game.Players.LocalPlayer.Character
        if Character and _G.lockRunning then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            if HumanoidRootPart and Humanoid then
                HumanoidRootPart.CFrame = _G.LockedCFrame
                HumanoidRootPart.Velocity = Vector3.zero
                HumanoidRootPart.RotVelocity = Vector3.zero
                Humanoid.PlatformStand = true
            end
        end
    end)
end

local function UnlockPosition()
    _G.lockRunning = false
    if _G.lockConnection then
        _G.lockConnection:Disconnect()
    end
    
    local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if Humanoid then
        Humanoid.PlatformStand = false
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(Character)
    task.defer(function()
        if _G.lockRunning and _G.LockedCFrame then
            Character:WaitForChild("HumanoidRootPart").CFrame = _G.LockedCFrame
            LockPosition(_G.LockedCFrame)
        end
    end)
end)

local RockConfigurations = {
    {name = "Jungle Rock", key = "Glitch_Jungle", dur = 10000000, pos = Vector3.new(-7706.23, 4.51, 2918.94), face = "East"},
    {name = "Muscle King Rock", key = "Glitch_MuscleKing", dur = 5000000, pos = Vector3.new(-9040.84, 6.9, -6057.31), face = "East"},
    {name = "Legend Rock", key = "Glitch_Legend", dur = 1000000, pos = Vector3.new(4141.13, 989.23, -4029.81), face = "North"},
    {name = "Eternal Rock", key = "Glitch_Eternal", dur = 750000, pos = Vector3.new(-7223.26, 5.07, -1259.91), face = "West"},
    {name = "Mythical Rock", key = "Glitch_Mythical", dur = 400000, pos = Vector3.new(2224.73, 5.03, 1251.95), face = "West"},
    {name = "Frost Rock", key = "Glitch_Frost", dur = 150000, pos = Vector3.new(-2590.58, 5.03, -241.71), face = "East"},
    {name = "Golden Rock", key = "Glitch_Golden", dur = 5000, pos = Vector3.new(342.33, 5.12, -590.91), face = "West"},
    {name = "Starter Island", key = "Glitch_Starter", dur = 100, pos = Vector3.new(182.07, 5.03, -151.99), face = "West"},
    {name = "Tiny Rock", key = "Glitch_Tiny", dur = 0, pos = Vector3.new(18.27, 5.23, 2093.81), face = "South"}
}

local selectedRockV2 = nil
local rockV2StartActive = false

local rockV2Dropdown = Rock:AddDropdown("🗿 Select Rock V2", function(selected)
    selectedRockV2 = selected
    print("Selected rock V2: " .. selected)
end)

for _, RockConfig in ipairs(RockConfigurations) do
    rockV2Dropdown:Add(RockConfig.name)
end

Rock:AddSwitch("👊 Start Rock V2 Farm", function(Value)
    rockV2StartActive = Value
    
    if Value then
        if selectedRockV2 == nil then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Please select a rock first!",
                Duration = 3
            })
            return
        end
        
        for _, RockConfig in ipairs(RockConfigurations) do
            if RockConfig.name == selectedRockV2 then
                _G[RockConfig.key] = true
                task.spawn(function()
                    while _G[RockConfig.key] and rockV2StartActive do
                        local LocalPlayer = game.Players.LocalPlayer
                        if LocalPlayer:FindFirstChild("Durability") and LocalPlayer.Durability.Value >= RockConfig.dur then
                            local Direction = FaceDirections[RockConfig.face] or Vector3.new(0, 0, -1)
                            local TargetCFrame = CFrame.new(RockConfig.pos, RockConfig.pos + Direction)
                            local Character = LocalPlayer.Character
                            
                            if Character and Character:FindFirstChild("HumanoidRootPart") then
                                Character.HumanoidRootPart.CFrame = TargetCFrame
                                LockPosition(TargetCFrame)
                            end
                            
                            local PunchTool = LocalPlayer.Backpack:FindFirstChild("Punch") or 
                                             (Character and Character:FindFirstChild("Punch"))
                            
                            if PunchTool and Character and Character:FindFirstChild("Humanoid") then
                                if PunchTool.Parent ~= Character then
                                    Character.Humanoid:EquipTool(PunchTool)
                                end
                                
                                if PunchTool:FindFirstChild("attackTime") then
                                    PunchTool.attackTime.Value = 0.1
                                end
                                
                                LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                                LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                                PunchTool:Activate()
                            end
                        end
                        task.wait()
                    end
                    UnlockPosition()
                    _G[RockConfig.key] = false
                end)
            else
                _G[RockConfig.key] = false
            end
        end
    else
        for _, RockConfig in ipairs(RockConfigurations) do
            _G[RockConfig.key] = false
        end
        UnlockPosition()
        print("Rock V2 farm stopped")
    end
end)

local tabFarming = window:AddTab("Pack Farm")

local player = game.Players.LocalPlayer
local muscleEvent = player:WaitForChild("muscleEvent")
local rEvents = game:GetService("ReplicatedStorage"):WaitForChild("rEvents")
local isRunning = false
local strengthOnly = false
local autoEatEnabled = false
local startTime = tick()
local initialRebirthsCount = player.leaderstats.Rebirths.Value

local function unequipAllPets()
    if player:FindFirstChild("petsFolder") then
        for _, folder in pairs(player.petsFolder:GetChildren()) do
            for _, pet in pairs(folder:GetChildren()) do
                rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
end

local function equipUniquePet(name)
    if player:FindFirstChild("petsFolder") and player.petsFolder:FindFirstChild("Unique") then
        for _, pet in pairs(player.petsFolder.Unique:GetChildren()) do
            if pet.Name == name then
                rEvents.equipPetEvent:FireServer("equipPet", pet)
                task.wait(0.01) 
            end
        end
    end
end

local function findMachine(machineName)
    local machine = workspace:FindFirstChild("machinesFolder") and workspace.machinesFolder:FindFirstChild(machineName)
    if not machine then
        for _, f in pairs(workspace:GetChildren()) do
            if f:IsA("Folder") and f.Name:find("machines") then
                machine = f:FindFirstChild(machineName)
                if machine then break end
            end
        end
    end
    return machine
end

local function pressE()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "E", false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, "E", false, game)
end

tabFarming:AddLabel("Session Stats").TextSize = 23
local footerTimeLabel = tabFarming:AddLabel("Time: 0d 0h 0m 0s")
local footerRebirthsLabel = tabFarming:AddLabel("Total Rebirths: " .. initialRebirthsCount)
local footerRebirthsGainedLabel = tabFarming:AddLabel("Rebirths Gained: 0")

task.spawn(function()
    while true do
        local elapsed = tick() - startTime
        local days = math.floor(elapsed / 86400)
        local hours = math.floor((elapsed % 86400) / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        footerTimeLabel.Text = string.format("Time: %dd %dh %dm %ds", days, hours, minutes, seconds)
        local current = player.leaderstats.Rebirths.Value
        footerRebirthsLabel.Text = "Total Rebirths: " .. current
        footerRebirthsGainedLabel.Text = "Rebirths Gained: " .. (current - initialRebirthsCount)
        task.wait(1)
    end
end)

tabFarming:AddLabel("👀 Pack Farm Rebirth").TextSize = 21

tabFarming:AddSwitch("🔄 Auto Rebirth Farm", function(bool)
    isRunning = bool
    if not bool then return end
    task.spawn(function()
        while isRunning do
            local currentReb = player.leaderstats.Rebirths.Value
            local rebirthCost = 10000 + (5000 * currentReb)
            if player.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local gReb = player.ultimatesFolder["Golden Rebirth"].Value
                rebirthCost = math.floor(rebirthCost * (1 - (gReb * 0.1)))
            end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Swift Samurai")
            while isRunning and player.leaderstats.Strength.Value < rebirthCost do
                for i = 1, 12 do 
                    muscleEvent:FireServer("rep")
                end
                task.wait(0.01)
            end
            if not isRunning then break end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Tribal Overlord")
            local machine = findMachine("Jungle Bar Lift")
            if machine and machine:FindFirstChild("interactSeat") then
                player.Character.HumanoidRootPart.CFrame = machine.interactSeat.CFrame * CFrame.new(0, 3, 0)
                local retryCount = 0
                repeat
                    task.wait(0.2)
                    pressE()
                    retryCount = retryCount + 1
                until (player.Character and player.Character.Humanoid.Sit) or retryCount > 20 or not isRunning
            end
            local initialRebirths = player.leaderstats.Rebirths.Value
            repeat
                rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.5)
            until player.leaderstats.Rebirths.Value > initialRebirths or not isRunning
        end
    end)
end)

tabFarming:AddLabel("💪 Fast Strength").TextSize = 21

tabFarming:AddSwitch("💢 Auto Strength Farm", function(bool)
    strengthOnly = bool
    if not bool then return end
    task.spawn(function()
        unequipAllPets()
        task.wait(0.1)
        equipUniquePet("Swift Samurai")
        while strengthOnly do
            for i = 1, 23 do 
                muscleEvent:FireServer("rep")
            end
            task.wait(0.01)
        end
    end)
end)

tabFarming:AddButton("⚙️ Industrial Bar Lift", function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(-5492.24, 81.82, 4644.04)
        task.wait(0.5)
        local machine = findMachine("Industrial Bar Lift")
        if machine and machine:FindFirstChild("interactSeat") then
            local retryCount = 0
            repeat
                task.wait(0.2)
                pressE()
                retryCount = retryCount + 1
            until (player.Character and player.Character.Humanoid.Sit) or retryCount > 10
        end
    end
end)

tabFarming:AddButton("🦵 Industrial Squat", function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(-5216.36, 90.17, 5420.08)
        task.wait(0.5)
        local machine = findMachine("Industrial Squat")
        if machine and machine:FindFirstChild("interactSeat") then
            local retryCount = 0
            repeat
                task.wait(0.2)
                pressE()
                retryCount = retryCount + 1
            until (player.Character and player.Character.Humanoid.Sit) or retryCount > 10
        end
    end
end)

tabFarming:AddLabel("Useful Features").TextSize = 23

tabFarming:AddSwitch("📌 Lock Position", function(state)
    if state then
        local currentPos = player.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            if player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

tabFarming:AddLabel("👾 Performance").TextSize = 21

tabFarming:AddButton("🏴 Full FPS Boost", function()
    local lighting = game:GetService("Lighting")
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
            obj:Destroy()
        end
    end
    lighting.Brightness = 0
    lighting.OutdoorAmbient = Color3.new(0, 0, 0)
    for _, v in pairs(lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
end)

tabFarming:AddSwitch("👁️‍🗨️ Hide All Frames", function(state)
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if obj.Name:match("Frame$") then obj.Visible = not state end
    end
end)

tabFarming:AddLabel("❤️ This Tab Made ByRuLing").TextSize = 15


local pets = window:AddTab("Pets")
pets:AddLabel("💰 Auto Buy")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rEvents = ReplicatedStorage:WaitForChild("rEvents")

local selectedPet = "Orange Hedgehog"
local autoHatchPet = false

local petDropdown = pets:AddDropdown("🐢 Select Pet", function(text)
    selectedPet = text:match("^(.-)%s*%(.-%)$") or text
end)

local petList = {
    "Orange Hedgehog (Basic)",
    "Silver Dog (Basic)",
    "Red Kitty (Basic)",
    "Blue Birdie (Basic)",
    "Blue Bunny (Basic)",
    "Core Pup (Basic)",
    "Green Butterfly (Rare)",
    "Yellow Butterfly (Rare)",
    "Magic Butterfly (Rare)",
    "Volt Talon (Rare)",
    "Red Dragon (Epic)",
    "Purple Dragon (Epic)",
    "Blue Firecaster (Epic)",
    "Red Firecaster (Epic)",
    "Green Firecaster (Epic)",
    "Reactor Bea (Epic)",
    "Golden Viking (Legendary)",
    "Gold Warrior (Legendary)",
    "Infernal Dragon (Legendary)",
    "Dark Golem (Legendary)",
    "Muscle Sensei (Legendary)",
    "Plasma Ravager (Legendary)",
    "Orange Pegasus (Unique)",
    "White Pegasus (Unique)",
    "Blue Pheonix (Unique)",
    "Golden Pheonix (Unique)",
    "White Pheonix (Unique)",
    "Crimson Falcon (Unique)",
    "Purple Falcon (Unique)",
    "Ultra Birdie (Unique)",
    "Dark Vampy (Unique)",
    "Frostwave Legends Penguin (Unique)",
    "Dark Legends Manticore (Unique)",
    "Darkstar Hunter (Unique)",
    "Lightning Strike Phantom (Unique)",
    "Cybernetic Showdown Dragon (Unique)",
    "Phantom Genesis Dragon (Unique)",
    "Eternal Strike Leviathan (Unique)",
    "Ultimate Supernova Pegasus (Unique)",
    "Titan Reactor (Unique)",
    "Neon Guardian (Unique)",
    "Apex Overlord (Unique)"
}

for _, petName in ipairs(petList) do
    petDropdown:Add(petName)
end

pets:AddSwitch("Auto Open Pet", function(bool)
    autoHatchPet = bool
    if bool then
        spawn(function()
            while autoHatchPet and selectedPet ~= "" do
                local petShopRemote = rEvents:FindFirstChild("cPetShopRemote") or ReplicatedStorage:FindFirstChild("cPetShopRemote")
                
                local runtimeFolder = ReplicatedStorage:FindFirstChild("shared") 
                    and ReplicatedStorage.shared:FindFirstChild("runtime") 
                    and ReplicatedStorage.shared.runtime:FindFirstChild("cPetShopFolder")
                
                local petToOpen = runtimeFolder and runtimeFolder:FindFirstChild(selectedPet)
                
                if petToOpen and petShopRemote then
                    pcall(function()
                        petShopRemote:InvokeServer(petToOpen)
                    end)
                end
                task.wait(0.1)
            end
        end)
    end
end)

pets:AddLabel("💫 Auto Buy Aura")

local selectedAura = "Blue Aura"
local autoHatchAura = false

local auraDropdown = pets:AddDropdown("💫 Select Aura", function(text)
    selectedAura = text:match("^(.-)%s*%(.-%)$") or text
end)

local auraList = {
    "Blue Aura (Basic)",
    "Green Aura (Basic)",
    "Yellow Aura (Basic)",
    "Purple Aura (Basic)",
    "Red Aura (Basic)",
    "Electro (Rare)",
    "Lightning (Rare)",
    "Dark Electro (Rare)",
    "Dark Lightning (Rare)",
    "Azure Tundra (Epic)",
    "Dark Storm (Epic)",
    "Inferno (Epic)",
    "Muscle King (Epic)",
    "Power Lightning (Epic)",
    "Purple Nova (Epic)",
    "Supernova (Legendary)",
    "Ultra Inferno (Legendary)",
    "Enchanted Mirage (Unique)",
    "Astral Electro (Unique)",
    "Eternal Megastrike (Unique)",
    "Grand Supernova (Unique)",
    "Entropic Blast (Unique)",
    "Ultra Mirage (Unique)",
    "Unstable Mirage (Unique)"
}

for _, auraName in ipairs(auraList) do
    auraDropdown:Add(auraName)
end

pets:AddSwitch("Auto Open Aura", function(bool)
    autoHatchAura = bool
    if bool then
        spawn(function()
            while autoHatchAura and selectedAura ~= "" do
                local petShopRemote = rEvents:FindFirstChild("cPetShopRemote") or ReplicatedStorage:FindFirstChild("cPetShopRemote")
                
                local runtimeFolder = ReplicatedStorage:FindFirstChild("shared") 
                    and ReplicatedStorage.shared:FindFirstChild("runtime") 
                    and ReplicatedStorage.shared.runtime:FindFirstChild("cPetShopFolder")
                
                local auraToOpen = runtimeFolder and runtimeFolder:FindFirstChild(selectedAura)
                
                if auraToOpen and petShopRemote then
                    pcall(function()
                        petShopRemote:InvokeServer(auraToOpen)
                    end)
                end
                task.wait(0.1)
            end
        end)
    end
end)

pets:AddLabel("----------------------------")
pets:AddLabel("✨ Auto Evolve Pet")

local pets = pets
local selectedEvolvePet = ""
local autoEvolvePet = false

local evolvePetDropdown = pets:AddDropdown("🐾 Select Pet to Evolve", function(text)
    selectedEvolvePet = text:match("^(.-)%s*%(.-%)$") or text
end)

local evolveList = {
    -- Basic
    "Orange Hedgehog (Basic)",
    "Silver Dog (Basic)",
    "Red Kitty (Basic)",
    "Blue Birdie (Basic)",
    "Blue Bunny (Basic)",
    "Core Pup (Basic)",
    "Blue Aura (Basic)",
    "Green Aura (Basic)",
    "Purple Aura (Basic)",
    "Red Aura (Basic)",
    "Yellow Aura (Basic)",

    -- Advanced
    "Dark Vampy (Advanced)",
    "Dark Golem (Advanced)",
    "Green Butterfly (Advanced)",
    "Yellow Butterfly (Advanced)",

    -- Rare
    "Crimson Falcon (Rare)",
    "Purple Dragon (Rare)",
    "Orange Pegasus (Rare)",
    "Purple Falcon (Rare)",
    "Red Dragon (Rare)",
    "White Pegasus (Rare)",
    "Frostwave Legends Penguin (Rare)",
    "Phantom Genesis Dragon (Rare)",
    "Eternal Strike Leviathan (Rare)",
    "Volt Talon (Rare)",
    "Magic Butterfly (Rare)",
    "Blue Firecaster (Rare)",
    "Red Firecaster (Rare)",
    "Green Firecaster (Rare)",
    "Ultra Inferno (Rare)",

    -- Epic
    "Blue Pheonix (Epic)",
    "Golden Pheonix (Epic)",
    "White Pheonix (Epic)",
    "Dark Legends Manticore (Epic)",
    "Ultimate Supernova Pegasus (Epic)",
    "Lightning Strike Phantom (Epic)",
    "Golden Viking (Epic)",
    "Reactor Bea (Epic)",
    "Gold Warrior (Epic)",
    "Azure Tundra (Epic)",
    "Grand Supernova (Epic)",

    -- Unique
    "Infernal Dragon (Unique)",
    "Ultra Birdie (Unique)",
    "Aether Spirit Bunny (Unique)",
    "Cybernetic Showdown Dragon (Unique)",
    "Darkstar Hunter (Unique)",
    "Muscle Sensei (Unique)",
    "Neon Guardian (Unique)",
    "Apex Overlord (Unique)",
    "Plasma Ravager (Unique)",
    "Titan Reactor (Unique)",
    "Muscle King (Unique)",
    "Entropic Blast (Unique)",
    "Eternal Megastrike (Unique)"
}

for _, item in ipairs(evolveList) do
    evolvePetDropdown:Add(item)
end

pets:AddSwitch("🎯 Auto Evolve Selected Pet", function(state)
    autoEvolvePet = state
    if state then
        if selectedEvolvePet == "" then
            return
        end
        local petName = selectedEvolvePet:match("^(.-)%s*%(")
        if not petName then
            petName = selectedEvolvePet
        end
        task.spawn(function()
            local maxAttempts = 1000
            while autoEvolvePet do
                pcall(function()
                    game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
                        "evolvePet",
                        petName
                    )
                end)
                task.wait(0.5)
                if maxAttempts <= 0 then
                    autoEvolvePet = false
                    break
                end
                maxAttempts = maxAttempts - 1
            end
        end)
    end
end)

pets:AddButton("⚡ Quick Evolve (1x)", function()
    if selectedEvolvePet == "" then
        return
    end
    local petName = selectedEvolvePet:match("^(.-)%s*%(")
    if not petName then
        petName = selectedEvolvePet
    end
    pcall(function()
        game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
            "evolvePet",
            petName
        )
    end)
end)

pets:AddButton("💥 Quick Evolve (10x)", function()
    if selectedEvolvePet == "" then
        return
    end
    local petName = selectedEvolvePet:match("^(.-)%s*%(")
    if not petName then
        petName = selectedEvolvePet
    end
    for i = 1, 10 do
        pcall(function()
            game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
                "evolvePet",
                petName
            )
        end)
        task.wait(0.1)
    end
end)

pets:AddLabel("----------------------------")
pets:AddLabel("💎 Trade System")

local running = false
local selectedTarget = nil
local selectedPet = nil

local playerDropdown = pets:AddDropdown("👤 Choose Player", function(name)
    local username = name:match(" | (.+)") or name
    selectedTarget = game:GetService("Players"):FindFirstChild(username)
end)

local function updatePlayerList(p)
    if p ~= game:GetService("Players").LocalPlayer then
        playerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    updatePlayerList(player)
end

game:GetService("Players").PlayerAdded:Connect(updatePlayerList)

local petDropdown = pets:AddDropdown("🐈 Choose Pet", function(text) 
    selectedPet = text:match("^(.-)%s*%(.-%)$") or text 
end)

local petList = {
    -- Basic
    "Orange Hedgehog (Basic)",
    "Silver Dog (Basic)",
    "Red Kitty (Basic)",
    "Blue Birdie (Basic)",
    "Blue Bunny (Basic)",
    "Core Pup (Basic)",
    "Blue Aura (Basic)",
    "Green Aura (Basic)",
    "Purple Aura (Basic)",
    "Red Aura (Basic)",
    "Yellow Aura (Basic)",

    -- Advanced
    "Dark Vampy (Advanced)",
    "Dark Golem (Advanced)",
    "Green Butterfly (Advanced)",
    "Yellow Butterfly (Advanced)",

    -- Rare
    "Crimson Falcon (Rare)",
    "Purple Dragon (Rare)",
    "Orange Pegasus (Rare)",
    "Purple Falcon (Rare)",
    "Red Dragon (Rare)",
    "White Pegasus (Rare)",
    "Frostwave Legends Penguin (Rare)",
    "Phantom Genesis Dragon (Rare)",
    "Eternal Strike Leviathan (Rare)",
    "Volt Talon (Rare)",
    "Magic Butterfly (Rare)",
    "Blue Firecaster (Rare)",
    "Red Firecaster (Rare)",
    "Green Firecaster (Rare)",
    "Ultra Inferno (Rare)",

    -- Epic
    "Blue Pheonix (Epic)",
    "Golden Pheonix (Epic)",
    "White Pheonix (Epic)",
    "Dark Legends Manticore (Epic)",
    "Ultimate Supernova Pegasus (Epic)",
    "Lightning Strike Phantom (Epic)",
    "Golden Viking (Epic)",
    "Reactor Bea (Epic)",
    "Gold Warrior (Epic)",
    "Azure Tundra (Epic)",
    "Grand Supernova (Epic)",

    -- Unique
    "Infernal Dragon (Unique)",
    "Ultra Birdie (Unique)",
    "Aether Spirit Bunny (Unique)",
    "Cybernetic Showdown Dragon (Unique)",
    "Darkstar Hunter (Unique)",
    "Muscle Sensei (Unique)",
    "Neon Guardian (Unique)",
    "Apex Overlord (Unique)",
    "Plasma Ravager (Unique)",
    "Titan Reactor (Unique)",
    "Muscle King (Unique)",
    "Entropic Blast (Unique)",
    "Eternal Megastrike (Unique)"
}

for _, name in ipairs(petList) do 
    petDropdown:Add(name) 
end

pets:AddSwitch("📫 Auto Trade", function(state)
    running = state
    if not state then return end

    task.spawn(function()
        while running do
            if selectedTarget and selectedPet then
                local tradingEvent = game:GetService("ReplicatedStorage").rEvents.tradingEvent
                local localPlayer = game:GetService("Players").LocalPlayer
                local pf = localPlayer:FindFirstChild("petsFolder")

                if pf then
                    local folders = {
                        pf:FindFirstChild("Basic"),
                        pf:FindFirstChild("Advanced"),
                        pf:FindFirstChild("Rare"),
                        pf:FindFirstChild("Epic"),
                        pf:FindFirstChild("Unique")
                    }

                    tradingEvent:FireServer("sendTradeRequest", selectedTarget)
                    task.wait(1.5) 

                    local offered = 0
                    
                    for _, folder in ipairs(folders) do
                        if folder and running and offered < 6 then
                            local petsToOffer = folder:GetChildren()
                            for i = 1, #petsToOffer do
                                local pet = petsToOffer[i]
                                if not running or offered >= 6 then break end

                                if pet.Name == selectedPet then
                                    tradingEvent:FireServer("offerItem", pet)
                                    offered = offered + 1
                                    task.wait(0.1) 
                                end
                            end
                        end
                    end

                    if running then
                        tradingEvent:FireServer("acceptTrade")
                    end
                end
            end
            task.wait(1) 
        end
    end)
end)

--// =========================
--// BOSS TAB - FIXED
--// =========================

local Boss = window:AddTab("Boss")

Boss:AddLabel("👹 Boss Farming:")
Boss.StatusLabel = Boss:AddLabel("Status: Waiting for Boss")
Boss.BossLabel = Boss:AddLabel("Boss: None")
Boss.HealthLabel = Boss:AddLabel("Health: 0 / 0")
Boss.NextBossLabel = Boss:AddLabel("Next Boss: N/A")

--// Runtime
Boss.runtime = {
    events = nil,
    bossFolder = nil,
    currentHealth = 0,
    health = 0,
    maxHealth = 0,
    generation = 0
}

Boss.Data = {
    Running = false,
    Generation = 0,
    ContinueTraining = true,
    Phase = "Waiting",
    TrainingSnapshot = nil,
    PunchInterval = 0.3,
    LastPunch = 0,
    AttackSequence = nil,
    EvadeUntil = 0,
    EvadeDistance = 230,
    PunchBehindDistance = 45,
    StompHealthThreshold = 0.35,
    DodgeStomps = false
}

--// =========================
--// FIND BOSS
--// =========================

Boss.findActiveBoss = function()
    local model
    local stats
    local health
    local maxHealth
    local hitbox

    pcall(function()

        if services.CollectionService then
            for _, candidate in ipairs(
                services.CollectionService:GetTagged("BossEventBoss")
            ) do

                if candidate:IsA("Model")
                    and candidate:IsDescendantOf(services.Workspace)
                then
                    model = candidate
                    break
                end

            end
        end

        if not model then

            Boss.runtime.events =
                services.Workspace:FindFirstChild("Events")

            Boss.runtime.bossFolder =
                Boss.runtime.events
                and (
                    Boss.runtime.events:FindFirstChild("BossEvent")
                    or Boss.runtime.events:FindFirstChild("BossArena")
                )

            if Boss.runtime.bossFolder then

                for _, candidate in ipairs(
                    Boss.runtime.bossFolder:GetDescendants()
                ) do

                    if candidate:IsA("Model") then

                        local hasHitbox =
                            candidate:FindFirstChild(
                                "BossDamageHitbox",
                                true
                            )

                        local hasTag = false

                        if services.CollectionService then
                            hasTag =
                                services.CollectionService:HasTag(
                                    candidate,
                                    "BossEventBoss"
                                )
                        end

                        if hasHitbox or hasTag then
                            model = candidate
                            break
                        end

                    end

                end

            end

        end

        if not model then
            return
        end

        stats = model:FindFirstChild("stats")

        health =
            stats
            and stats:FindFirstChild("Health")

        maxHealth =
            stats
            and stats:FindFirstChild("MaxHealth")

        hitbox =
            model:FindFirstChild(
                "BossDamageHitbox",
                true
            )

        if not hitbox
            or not hitbox:IsA("BasePart")
        then
            model = nil
            return
        end

        Boss.runtime.currentHealth =
            health
            and health.Value
            or services.Workspace:GetAttribute(
                "BossHealth"
            )
            or 0

        if typeof(Boss.runtime.currentHealth) == "number"
            and Boss.runtime.currentHealth <= 0
        then
            model = nil
            return
        end

    end)

    if not model then
        return nil
    end

    return model, health, maxHealth, hitbox
end

--// =========================
--// HEALTH
--// =========================

Boss.getBossHealth = function(health)

    if health then
        return health.Value
    end

    return services.Workspace:GetAttribute(
        "BossHealth"
    ) or 0
end

Boss.getBossMaxHealth = function(maxHealth)

    if maxHealth then
        return maxHealth.Value
    end

    return services.Workspace:GetAttribute(
        "BossMaxHealth"
    ) or 0
end

Boss.formatCountdown = function(seconds)

    seconds =
        math.max(
            0,
            math.floor(seconds or 0)
        )

    local hours =
        math.floor(seconds / 3600)

    local minutes =
        math.floor(
            (seconds % 3600) / 60
        )

    seconds =
        seconds % 60

    return string.format(
        "%dh %dmin %ds",
        hours,
        minutes,
        seconds
    )
end

--// =========================
--// LEAVE MACHINE
--// =========================

Boss.leaveExerciseMachine = function()

    pcall(function()

        local player =
            utils.playerData.Player

        local character =
            player
            and player.Character

        local humanoid =
            character
            and character:FindFirstChildOfClass(
                "Humanoid"
            )

        local root =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not humanoid
            or humanoid.Health <= 0
        then
            return
        end

        services.VirtualInputManager:SendKeyEvent(
            true,
            Enum.KeyCode.Space,
            false,
            game
        )

        humanoid.Sit = false
        humanoid.Jump = true

        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

        if root then
            root.AssemblyLinearVelocity =
                Vector3.new(
                    0,
                    math.max(
                        root.AssemblyLinearVelocity.Y,
                        50
                    ),
                    0
                )
        end

        task.wait(0.2)

        services.VirtualInputManager:SendKeyEvent(
            false,
            Enum.KeyCode.Space,
            false,
            game
        )

    end)

end

--// =========================
--// PAUSE FARMING
--// =========================

Boss.pauseTraining = function()

    if Boss.Data.TrainingSnapshot then
        return
    end

    local farming =
        tabs
        and tabs.farming

    if not farming then
        warn(
            "[Kryvex Boss] Farming tab bulunamadı."
        )
        return
    end

    Boss.Data.TrainingSnapshot = {
        Rebirth =
            farming.RebirthData
            and farming.RebirthData.IsAutoRebirthing
            or false,

        Size =
            farming.SizeData
            and farming.SizeData.Active
            or false,

        King =
            farming.KingData
            and farming.KingData.TeleportActive
            or false,

        Tool =
            farming.ExerciseData
            and farming.ExerciseData.AutoFarm
            or false,

        Squat =
            farming.MachineExerciseData
            and farming.MachineExerciseData.Squat
            and farming.MachineExerciseData.Squat.Running
            or false,

        Lift =
            farming.MachineExerciseData
            and farming.MachineExerciseData.Lift
            and farming.MachineExerciseData.Lift.Running
            or false,

        AutoRep =
            farming.AutoRepRunning
            or false,

        Rock =
            getgenv().RockFarmRunning == true,

        Configs = {}
    }

    for _, config in ipairs(
        farming.Configs or {}
    ) do

        if config
            and config.name
        then

            Boss.Data.TrainingSnapshot.Configs[
                config.name
            ] =
                farming.ActiveConfigs
                and farming.ActiveConfigs[
                    config.name
                ] == true

            if farming.ActiveConfigs
                and farming.ActiveConfigs[
                    config.name
                ]
                and config.Switch
            then

                pcall(function()
                    config.Switch:Set(false)
                end)

            end

        end

    end

    local snapshot =
        Boss.Data.TrainingSnapshot

    if snapshot.Rebirth
        and farming.RebirthData
        and farming.RebirthData.Switch
    then

        pcall(function()
            farming.RebirthData.Switch:Set(false)
        end)

    end

    if snapshot.Size
        and farming.SizeSwitch
    then

        pcall(function()
            farming.SizeSwitch:Set(false)
        end)

    end

    if snapshot.King
        and farming.KingSwitch
    then

        pcall(function()
            farming.KingSwitch:Set(false)
        end)

    end

    if snapshot.Tool
        and farming.ToolExerciseSwitch
    then

        pcall(function()
            farming.ToolExerciseSwitch:Set(false)
        end)

    end

    if snapshot.Squat
        and farming.SquatExerciseSwitch
    then

        pcall(function()
            farming.SquatExerciseSwitch:Set(false)
        end)

    end

    if snapshot.Lift
        and farming.LiftExerciseSwitch
    then

        pcall(function()
            farming.LiftExerciseSwitch:Set(false)
        end)

    end

    if snapshot.Squat
        or snapshot.Lift
    then
        Boss.leaveExerciseMachine()
    end

    if snapshot.AutoRep
        and farming.AutoRepSwitch
    then

        pcall(function()
            farming.AutoRepSwitch:Set(false)
        end)

    end

    if snapshot.Rock
        and farming.RockSwitch
    then

        pcall(function()
            farming.RockSwitch:Set(false)
        end)

    end

end

--// =========================
--// RESUME FARMING
--// =========================

Boss.resumeTraining = function()

    local snapshot =
        Boss.Data.TrainingSnapshot

    if not snapshot then
        return
    end

    local farming =
        tabs
        and tabs.farming

    Boss.Data.TrainingSnapshot = nil

    if not farming then
        return
    end

    if snapshot.Rebirth
        and farming.RebirthData
        and farming.RebirthData.Switch
    then

        pcall(function()
            farming.RebirthData.Switch:Set(true)
        end)

    end

    if snapshot.Size
        and farming.SizeSwitch
    then

        pcall(function()
            farming.SizeSwitch:Set(true)
        end)

    end

    if snapshot.King
        and farming.KingSwitch
    then

        pcall(function()
            farming.KingSwitch:Set(true)
        end)

    end

    if snapshot.Tool
        and farming.ToolExerciseSwitch
    then

        pcall(function()
            farming.ToolExerciseSwitch:Set(true)
        end)

    end

    if snapshot.Squat
        and farming.SquatExerciseSwitch
    then

        pcall(function()
            farming.SquatExerciseSwitch:Set(true)
        end)

    end

    if snapshot.Lift
        and farming.LiftExerciseSwitch
    then

        pcall(function()
            farming.LiftExerciseSwitch:Set(true)
        end)

    end

    if snapshot.AutoRep
        and farming.AutoRepSwitch
    then

        pcall(function()
            farming.AutoRepSwitch:Set(true)
        end)

    end

    if snapshot.Rock
        and farming.RockSwitch
    then

        pcall(function()
            farming.RockSwitch:Set(true)
        end)

    end

    for _, config in ipairs(
        farming.Configs or {}
    ) do

        if config
            and config.name
            and snapshot.Configs
            and snapshot.Configs[
                config.name
            ]
            and config.Switch
        then

            pcall(function()
                config.Switch:Set(true)
            end)

        end

    end

end

--// =========================
--// BOSS HEAD
--// =========================

Boss.getBossHeadPosition = function(
    model,
    hitbox
)

    local head =
        model:FindFirstChild(
            "Head",
            true
        )
        or model:FindFirstChild(
            "head",
            true
        )

    if head
        and head:IsA("BasePart")
    then
        return head.Position
    end

    if head
        and head:IsA("Bone")
    then
        return head.WorldPosition
    end

    return
        hitbox.Position
        + Vector3.new(
            0,
            hitbox.Size.Y * 0.35,
            0
        )
end

--// =========================
--// ALIVE CHARACTER
--// =========================

Boss.getAliveCharacter = function(
    generation,
    timeout
)

    local startedAt =
        os.clock()

    repeat

        local character =
            utils.playerData.Player.Character

        local root =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )

        local humanoid =
            character
            and character:FindFirstChildOfClass(
                "Humanoid"
            )

        if root
            and humanoid
            and humanoid.Health > 0
        then

            utils.playerData.Character =
                character

            utils.playerData.Humanoid =
                humanoid

            return
                character,
                root,
                humanoid
        end

        Boss.StatusLabel.Text =
            "Status: Waiting for Respawn"

        task.wait(0.1)

    until
        not Boss.Data.Running
        or Boss.Data.Generation ~= generation
        or (
            timeout
            and os.clock() - startedAt >= timeout
        )

end

--// =========================
--// EVADE
--// =========================

Boss.evadeAttack = function(
    model,
    hitbox,
    root,
    humanoid
)

    local sequence =
        model:GetAttribute(
            "BossAttackSequence"
        )

    local attackKind =
        model:GetAttribute(
            "BossAttackKind"
        )

    local attackCFrame =
        model:GetAttribute(
            "BossAttackCFrame"
        )

    local impactTime =
        model:GetAttribute(
            "BossAttackImpactTime"
        )

    if typeof(sequence) == "number"
        and sequence ~= Boss.Data.AttackSequence
    then

        Boss.Data.AttackSequence =
            sequence

        if typeof(attackKind) == "string"
            and typeof(attackCFrame) == "CFrame"
            and typeof(impactTime) == "number"
        then

            Boss.Data.EvadeUntil =
                impactTime + 0.6

        end

    end

    if typeof(attackCFrame) ~= "CFrame"
        or services.Workspace:GetServerTimeNow()
            > Boss.Data.EvadeUntil
    then
        return
    end

    attackKind =
        string.lower(
            tostring(
                attackKind or ""
            )
        )

    if string.find(
        attackKind,
        "punch",
        1,
        true
    ) then

        local center =
            Boss.getBossHeadPosition(
                model,
                hitbox
            )

        local direction =
            Vector3.new(
                attackCFrame.LookVector.X,
                0,
                attackCFrame.LookVector.Z
            )

        if direction.Magnitude < 1 then
            direction =
                Vector3.new(
                    hitbox.CFrame.LookVector.X,
                    0,
                    hitbox.CFrame.LookVector.Z
                )
        end

        if direction.Magnitude < 1 then
            direction =
                Vector3.new(
                    0,
                    0,
                    1
                )
        end

        local safePosition =
            center
            - direction.Unit
            * Boss.Data.PunchBehindDistance

        root.CFrame =
            CFrame.lookAt(
                safePosition,
                center
            )

        root.AssemblyLinearVelocity =
            Vector3.zero

        root.AssemblyAngularVelocity =
            Vector3.zero

        Boss.StatusLabel.Text =
            "Status: Dodging Punch"

        return "Punch"
    end

    if not string.find(
        attackKind,
        "stomp",
        1,
        true
    ) then
        return
    end

    if humanoid.Health
        / math.max(
            humanoid.MaxHealth,
            1
        )
        <= Boss.Data.StompHealthThreshold
    then
        Boss.Data.DodgeStomps = true
    end

    if not Boss.Data.DodgeStomps then
        return
    end

    local direction =
        Vector3.new(
            root.Position.X
                - attackCFrame.Position.X,
            0,
            root.Position.Z
                - attackCFrame.Position.Z
        )

    if direction.Magnitude < 1 then

        direction =
            Vector3.new(
                -attackCFrame.LookVector.X,
                0,
                -attackCFrame.LookVector.Z
            )

    end

    if direction.Magnitude < 1 then

        direction =
            Vector3.new(
                1,
                0,
                0
            )

    end

    direction =
        direction.Unit

    local safePosition =
        attackCFrame.Position
        + direction
            * Boss.Data.EvadeDistance
        + Vector3.new(
            0,
            18,
            0
        )

    root.CFrame =
        CFrame.lookAt(
            safePosition,
            attackCFrame.Position
        )

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    Boss.StatusLabel.Text =
        "Status: Dodging Stomp"

    return "Stomp"

end

--// =========================
--// ATTACK
--// =========================

Boss.attack = function(
    model,
    health,
    maxHealth,
    hitbox
)

    local character =
        utils.playerData.Player.Character

    local root =
        character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

    local humanoid =
        character
        and character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not root
        or not humanoid
        or humanoid.Health <= 0
    then
        return
    end

    local evadeMode =
        Boss.evadeAttack(
            model,
            hitbox,
            root,
            humanoid
        )

    if evadeMode == "Stomp" then
        return
    end

    local backpack =
        utils.playerData.Backpack

    local punch =
        character:FindFirstChild("Punch")

    if not punch
        and backpack
    then
        punch =
            backpack:FindFirstChild(
                "Punch"
            )
    end

    if punch
        and punch.Parent ~= character
    then

        pcall(function()
            humanoid:EquipTool(
                punch
            )
        end)

    end

    local leftHand =
        character:FindFirstChild(
            "LeftHand"
        )

    local rightHand =
        character:FindFirstChild(
            "RightHand"
        )

    local center =
        Boss.getBossHeadPosition(
            model,
            hitbox
        )

    if evadeMode ~= "Punch" then

        root.CFrame =
            CFrame.lookAt(
                center,
                center
                + hitbox.CFrame.LookVector
            )

    end

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    pcall(function()

        if leftHand then

            firetouchinterest(
                hitbox,
                leftHand,
                0
            )

            firetouchinterest(
                hitbox,
                leftHand,
                1
            )

        end

        if rightHand then

            firetouchinterest(
                hitbox,
                rightHand,
                0
            )

            firetouchinterest(
                hitbox,
                rightHand,
                1
            )

        end

    end)

    if os.clock()
        - Boss.Data.LastPunch
        >= Boss.Data.PunchInterval
    then

        Boss.Data.LastPunch =
            os.clock()

        pcall(function()

            utils.remotes.MuscleEvent:FireServer(
                "punch",
                "leftHand"
            )

            utils.remotes.MuscleEvent:FireServer(
                "punch",
                "rightHand"
            )

            if punch then
                punch:Activate()
            end

        end)

    end

    Boss.BossLabel.Text =
        "Boss: "
        .. (
            services.Workspace:GetAttribute(
                "BossDisplayName"
            )
            or model.Name
        )

    Boss.runtime.health =
        Boss.getBossHealth(
            health
        )

    Boss.runtime.maxHealth =
        Boss.getBossMaxHealth(
            maxHealth
        )

    Boss.HealthLabel.Text =
        "Health: "
        .. utils.formatNumber(
            Boss.runtime.health
        )
        .. " / "
        .. utils.formatNumber(
            Boss.runtime.maxHealth
        )

end

--// =========================
--// CHEST
--// =========================

Boss.findChest = function()

    local chest

    if services.CollectionService then

        for _, candidate in ipairs(
            services.CollectionService:GetTagged(
                "BossEventChest"
            )
        ) do

            if candidate:IsDescendantOf(
                services.Workspace
            ) then

                chest =
                    candidate

                break

            end

        end

    end

    if not chest then

        chest =
            services.Workspace:FindFirstChild(
                "BossChest",
                true
            )

    end

    if not chest then

        for _, candidate in ipairs(
            services.Workspace:GetDescendants()
        ) do

            if candidate:IsA(
                "ProximityPrompt"
            )
                and candidate.Name
                    == "bossChestPrompt"
            then

                chest =
                    candidate.Parent

                break

            end

        end

    end

    if not chest then
        return
    end

    local prompt =
        chest:FindFirstChild(
            "bossChestPrompt",
            true
        )

    local part =
        prompt
        and prompt.Parent

        or (
            chest:IsA("Model")
            and (
                chest.PrimaryPart
                or chest:FindFirstChildWhichIsA(
                    "BasePart",
                    true
                )
            )
        )

        or chest

    if part
        and part:IsA("BasePart")
    then

        return
            chest,
            prompt,
            part

    end

end

Boss.collectChest = function(
    generation
)

    Boss.StatusLabel.Text =
        "Status: Waiting for Chest"

    local startedAt =
        os.clock()

    local chest
    local prompt
    local part

    repeat

        chest,
        prompt,
        part =
            Boss.findChest()

        if chest
            and chest:GetAttribute(
                "BossChestEmerging"
            ) ~= true
        then
            break
        end

        task.wait(0.1)

    until
        not Boss.Data.Running
        or Boss.Data.Generation
            ~= generation
        or os.clock()
            - startedAt >= 12

    if not chest
        or not part
    then
        return
    end

    Boss.StatusLabel.Text =
        "Status: Collecting Chest"

    startedAt =
        os.clock()

    repeat

        local character,
            root =
            Boss.getAliveCharacter(
                generation,
                2
            )

        if character
            and root
            and chest.Parent
            and part.Parent
        then

            pcall(function()

                root.CFrame =
                    CFrame.lookAt(
                        part.Position
                            + Vector3.new(
                                0,
                                3,
                                4
                            ),
                        part.Position
                    )

                root.AssemblyLinearVelocity =
                    Vector3.zero

            end)

            task.wait(0.15)

            if prompt
                and prompt.Parent
                and fireproximityprompt
            then

                pcall(function()
                    fireproximityprompt(
                        prompt
                    )
                end)

            end

        end

        task.wait(0.25)

    until
        not Boss.Data.Running
        or Boss.Data.Generation
            ~= generation
        or utils.playerData.Player:GetAttribute(
            "BossChestPending"
        ) == false
        or not chest.Parent
        or os.clock()
            - startedAt >= 12

end

--// =========================
--// CONTINUE SWITCH
--// =========================

Boss.ContinueSwitch =
    Boss:AddSwitch(
        "Continue Farming after Boss Kill",
        function(state)

            Boss.Data.ContinueTraining =
                state

            if state
                and Boss.Data.Phase
                    == "Waiting"
            then

                pcall(function()
                    Boss.resumeTraining()
                end)

            end

        end
    )

-- ÖNEMLİ:
-- Set(true) direkt çalıştırılmıyor.
task.defer(function()

    pcall(function()

        if Boss.ContinueSwitch then
            Boss.ContinueSwitch:Set(true)
        end

    end)

end)

--// =========================
--// BOSS INFO LOOP
--// =========================

task.spawn(function()

    while true do

        local success =
            pcall(function()

                if not utils.isCurrent() then
                    return
                end

                local model,
                    health,
                    maxHealth,
                    hitbox =
                    Boss.findActiveBoss()

                if model then

                    local currentHealth =
                        Boss.getBossHealth(
                            health
                        )

                    local currentMaxHealth =
                        Boss.getBossMaxHealth(
                            maxHealth
                        )

                    Boss.BossLabel.Text =
                        "Boss: "
                        .. (
                            services.Workspace:GetAttribute(
                                "BossDisplayName"
                            )
                            or model.Name
                        )

                    Boss.HealthLabel.Text =
                        "Health: "
                        .. utils.formatNumber(
                            currentHealth
                        )
                        .. " / "
                        .. utils.formatNumber(
                            currentMaxHealth
                        )

                    Boss.NextBossLabel.Text =
                        "Next Boss: Current boss active"

                else

                    Boss.BossLabel.Text =
                        "Boss: None"

                    Boss.HealthLabel.Text =
                        "Health: 0 / 0"

                    local nextTime =
                        services.Workspace:GetAttribute(
                            "BossSpawnNextTime"
                        )

                    if typeof(nextTime)
                        == "number"
                    then

                        Boss.NextBossLabel.Text =
                            "Next Boss: "
                            .. Boss.formatCountdown(
                                nextTime
                                - services.Workspace:GetServerTimeNow()
                            )

                    else

                        Boss.NextBossLabel.Text =
                            "Next Boss: N/A"

                    end

                end

            end)

        task.wait(
            success
            and 0.25
            or 1
        )

    end

end)

--// =========================
--// AUTO BOSS FARM
--// =========================

Boss.AutoFarmSwitch =
    Boss:AddSwitch(
        "Auto Farm Boss",
        function(state)

            Boss.Data.Running =
                state

            Boss.Data.Generation += 1

            Boss.runtime.generation =
                Boss.Data.Generation

            if not state then

                Boss.Data.Phase =
                    "Waiting"

                Boss.StatusLabel.Text =
                    "Status: Disabled"

                pcall(function()
                    Boss.resumeTraining()
                end)

                return
            end

            local generation =
                Boss.Data.Generation

            task.spawn(function()

                local wasFighting =
                    false

                while
                    utils.isCurrent()
                    and Boss.Data.Running
                    and Boss.Data.Generation
                        == generation
                do

                    local success =
                        pcall(function()

                            local model,
                                health,
                                maxHealth,
                                hitbox =
                                Boss.findActiveBoss()

                            if model then

                                if not wasFighting then

                                    wasFighting =
                                        true

                                    Boss.Data.Phase =
                                        "Fighting"

                                    Boss.Data.AttackSequence =
                                        nil

                                    Boss.Data.EvadeUntil =
                                        0

                                    Boss.Data.DodgeStomps =
                                        false

                                    pcall(function()
                                        Boss.pauseTraining()
                                    end)

                                end

                                local character =
                                    utils.playerData.Player.Character

                                local humanoid =
                                    character
                                    and character:FindFirstChildOfClass(
                                        "Humanoid"
                                    )

                                if humanoid
                                    and humanoid.Health > 0
                                then

                                    Boss.StatusLabel.Text =
                                        "Status: Fighting"

                                    Boss.attack(
                                        model,
                                        health,
                                        maxHealth,
                                        hitbox
                                    )

                                else

                                    Boss.StatusLabel.Text =
                                        "Status: Waiting for Respawn"

                                end

                            elseif wasFighting then

                                wasFighting =
                                    false

                                Boss.Data.Phase =
                                    "Collecting"

                                pcall(function()
                                    Boss.collectChest(
                                        generation
                                    )
                                end)

                                Boss.BossLabel.Text =
                                    "Boss: None"

                                Boss.HealthLabel.Text =
                                    "Health: 0 / 0"

                                if Boss.Data.ContinueTraining then

                                    pcall(function()
                                        Boss.resumeTraining()
                                    end)

                                end

                                Boss.Data.Phase =
                                    "Waiting"

                                Boss.StatusLabel.Text =
                                    "Status: Waiting for Boss"

                            else

                                Boss.StatusLabel.Text =
                                    "Status: Waiting for Boss"

                            end

                        end)

                    if not success then
                        task.wait(0.5)
                    else
                        task.wait(
                            wasFighting
                            and 0.03
                            or 0.25
                        )
                    end

                end

            end)

        end
    )

Boss:AddLabel(
    "❤️ this tab made ByHenne"
)


local estadisticas = window:AddTab("Stats")

local SelectPlayerName = ""

local PlayerDrop = estadisticas:AddDropdown("Select Player", function(Value)
    SelectPlayerName = Value:match("| (.+)")
    previousValues = {}
end)

local Playerslist = {}
for _, Plr in pairs(game:GetService("Players"):GetPlayers()) do
    local displayName = Plr.DisplayName .. " | " .. Plr.Name
    table.insert(Playerslist, displayName)
end
for _, AddPlr in ipairs(Playerslist) do
    PlayerDrop:Add(AddPlr)
end

local function FormatNumberWithCommas(number)
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

local function FormatAbbreviated(number)
    local abbreviations = {"", "K", "M", "B", "T", "Qa", "Qi"}
    local abbreviationIndex = 1
    while number >= 1000 do
        number = number / 1000
        abbreviationIndex = abbreviationIndex + 1
    end
    return string.format("%.2f", number) .. abbreviations[abbreviationIndex]
end

local function FormatDisplay(value)
    local normal = FormatNumberWithCommas(value)
    local abbreviated = FormatAbbreviated(value)
    return "[ " .. normal .. " | " .. abbreviated .. " ]"
end

local previousValues = {}

local Update = estadisticas:AddLabel("")
local Update1 = estadisticas:AddLabel("")
local Update2 = estadisticas:AddLabel("")
local Update3 = estadisticas:AddLabel("")
local Update4 = estadisticas:AddLabel("")
local Update5 = estadisticas:AddLabel("")
local Update6 = estadisticas:AddLabel("")
local Update9 = estadisticas:AddLabel("")
local Update10 = estadisticas:AddLabel("")
local Update11 = estadisticas:AddLabel("")
local Update12 = estadisticas:AddLabel("")
local Update13 = estadisticas:AddLabel("")

task.spawn(function()
    while task.wait(0) do
        if SelectPlayerName ~= "" then
            local player = game.Players:FindFirstChild(SelectPlayerName)
            if player then
                if player:FindFirstChild("Gems") then
                    Update1.Text = "💎 Gems: " .. FormatDisplay(player.Gems.Value)
                end
                if player:FindFirstChild("Agility") then
                    Update3.Text = "⚡️ Agility: " .. FormatDisplay(player.Agility.Value)
                end
                if player:FindFirstChild("Durability") then
                    Update4.Text = "👊 Durability: " .. FormatDisplay(player.Durability.Value)
                end
                if player:FindFirstChild("muscleKingTime") then
                    Update6.Text = "🕣 Muscle King Time: " .. FormatDisplay(player.muscleKingTime.Value)
                end
                if player:FindFirstChild("customSize") then
                    Update10.Text = "📏 Custom Size: " .. FormatDisplay(player.customSize.Value)
                end
                if player:FindFirstChild("customSpeed") then
                    Update11.Text = "⚡️ Custom Speed: " .. FormatDisplay(player.customSpeed.Value)
                end
                if player:FindFirstChild("evilKarma") then
                    Update12.Text = "😈 Evil Karma: " .. FormatDisplay(player.evilKarma.Value)
                end
                if player:FindFirstChild("goodKarma") then
                    Update13.Text = "😇 Good Karma: " .. FormatDisplay(player.goodKarma.Value)
                end

                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats then
                    if leaderstats:FindFirstChild("Strength") then
                        Update.Text = "💪 Strength: " .. FormatDisplay(leaderstats.Strength.Value)
                    end
                    if leaderstats:FindFirstChild("Rebirths") then
                        Update2.Text = "🪽 Rebirth: " .. FormatDisplay(leaderstats.Rebirths.Value)
                    end
                    if leaderstats:FindFirstChild("Kills") then
                        Update5.Text = "🔪 Kills: " .. FormatDisplay(leaderstats.Kills.Value)
                    end
                end

                if player:FindFirstChild("currentMap") then
                    Update9.Text = "📍 Current Map: " .. tostring(player.currentMap.Value)
                else
                    Update9.Text = "Current Map: Aucune donnÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â©e"
                end
            end
        end
    end
end)

local teleport = window:AddTab("Teleport")

teleport:AddButton("🏠 Spawn", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(2, 8, 115)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Spawn bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🔮 Secret Area", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(1947, 2, 6191)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Secret Area bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🏝️ Tiny Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-34, 7, 1903)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Tiny Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("❄️ Frozen Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-2600.00244, 3.67686558, -403.884369, 0.0873617008, 1.0482899e-09, 0.99617666, 3.07204253e-08, 1, -3.7464023e-09, -0.99617666, 3.09302628e-08, 0.0873617008)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Frozen Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("⚡ Mythical Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(2255, 7, 1071)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Mythical Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🔥 Hell Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-6768, 7, -1287)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Hell Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🛡️ Legend Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(4604, 991, -3887)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Legend Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("👑 Muscle King", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-8646, 17, -5738)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Muscle King bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🌴 Jungle Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-8659, 6, 2384)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Jungle Island bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("⚙️ Industrial Gym", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-5350, 57, 4929)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Industrial Gym bölgesine ışınlanıldı",
        Duration = 2
    })
end)

-- Brawl
teleport:AddButton("⚔️ Brawl Regular", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-1849, 20, -6335)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Brawl Regular bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🏜️ Brawl Desert", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(960, 17, -7398)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Brawl Desert bölgesine ışınlanıldı",
        Duration = 2
    })
end)

teleport:AddButton("🌋 Brawl Lava", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(4471, 119, -8836)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kryvex Hub",
        Text = "Brawl Lava bölgesine ışınlanıldı",
        Duration = 2
    })
end)

local Misc = window:AddTab("Misc")

-- SET SPEED
Misc:AddTextBox("⚡️ Set Speed", function(Value)
    local Speed = tonumber(Value)

    if Speed then
        _G.SetSpeedValue = Speed
    end
end)

Misc:AddSwitch("⚡️ Set Speed", function(Value)
    _G.SetSpeedEnabled = Value

    local Character = game.Players.LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        if Value then
            Humanoid.WalkSpeed = _G.SetSpeedValue or 16
        else
            Humanoid.WalkSpeed = 16
        end
    end
end)


-- SET SIZE
Misc:AddTextBox("📏 Set Size", function(Value)
    local Size = tonumber(Value)

    if Size then
        _G.SetSizeValue = Size
    end
end)

Misc:AddSwitch("📏 Set Size", function(Value)
    _G.SetSizeEnabled = Value

    local Character = game.Players.LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        if Value then
            _G.OriginalSize = HumanoidRootPart.Size

            local Size = _G.SetSizeValue or 2
            HumanoidRootPart.Size = Vector3.new(Size, Size, Size)
        else
            HumanoidRootPart.Size = _G.OriginalSize or Vector3.new(2, 2, 1)
        end
    end
end)



Misc:AddButton("🚀 FPS Booster", function()
    local lighting = game:GetService("Lighting")
    local terrain = game:GetService("Workspace"):FindFirstChildOfClass('Terrain')

    lighting.Brightness = 0.5
    lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
    lighting.Ambient = Color3.fromRGB(120, 120, 120)
    lighting.ClockTime = 14

    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
    end
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kryvex Hub",
        Text = "FPS Boosted & Lighting Balanced!",
        Duration = 3
    })
end)

Misc:AddSwitch("🎰 Auto Fortune Wheel", function(Value)
    _G.autoFortuneWheelActive = Value
    if Value then
        task.spawn(function()
            while _G.autoFortuneWheelActive do
                pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local wheelRemote = ReplicatedStorage.rEvents:FindFirstChild("openFortuneWheelRemote")
                    
                    local wheelChance = ReplicatedStorage:FindFirstChild("shared") 
                        and ReplicatedStorage.shared:FindFirstChild("catalogs") 
                        and ReplicatedStorage.shared.catalogs:FindFirstChild("fortuneWheelChances")
                        and ReplicatedStorage.shared.catalogs.fortuneWheelChances:FindFirstChild("Fortune Wheel")
                    
                    if wheelRemote and wheelChance then
                        wheelRemote:InvokeServer("openFortuneWheel", wheelChance)
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

Misc:AddButton("🔄 Rejoin Game", function()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local YesButton = Instance.new("TextButton")
    local NoButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "RejoinConfirm"

    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    Frame.Size = UDim2.new(0, 250, 0, 150)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 10, 0, 20)
    TextLabel.Size = UDim2.new(0, 230, 0, 50)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "Are you sure you want to rejoin?"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 16
    TextLabel.TextWrapped = true

    YesButton.Name = "YesButton"
    YesButton.Parent = Frame
    YesButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    YesButton.Position = UDim2.new(0, 25, 0, 90)
    YesButton.Size = UDim2.new(0, 85, 0, 35)
    YesButton.Font = Enum.Font.GothamBold
    YesButton.Text = "YES"
    YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesButton.TextSize = 14
    Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 6)

    NoButton.Name = "NoButton"
    NoButton.Parent = Frame
    NoButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    NoButton.Position = UDim2.new(0, 140, 0, 90)
    NoButton.Size = UDim2.new(0, 85, 0, 35)
    NoButton.Font = Enum.Font.GothamBold
    NoButton.Text = "NO"
    NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoButton.TextSize = 14
    Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 6)

    YesButton.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)

    NoButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- HIDE EFFECTS
_G.HideEffectsEnabled = false
_G.HiddenEffects = {}

Misc:AddButton("👻 Hide Effects", function(Value)
    _G.HideEffectsEnabled = Value

    if Value then
        table.clear(_G.HiddenEffects)

        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter")
                or v:IsA("Trail")
                or v:IsA("Beam")
                or v:IsA("Smoke")
                or v:IsA("Fire")
                or v:IsA("Sparkles") then

                _G.HiddenEffects[v] = v.Enabled
                v.Enabled = false
            end
        end
    else
        for v, oldState in pairs(_G.HiddenEffects) do
            if v and v.Parent then
                v.Enabled = oldState
            end
        end

        table.clear(_G.HiddenEffects)
    end
end)

-- WALK ON WATER
_G.WalkOnWater = false
_G.WaterWalkPart = nil

Misc:AddSwitch("🌊 Walk On Water", function(Value)
    _G.WalkOnWater = Value

    if Value then
        task.spawn(function()
            while _G.WalkOnWater do
                local Player = game:GetService("Players").LocalPlayer
                local Character = Player.Character
                local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                if Root then
                    local RayParams = RaycastParams.new()
                    RayParams.FilterType = Enum.RaycastFilterType.Exclude
                    RayParams.FilterDescendantsInstances = {Character}

                    local Result = workspace:Raycast(
                        Root.Position,
                        Vector3.new(0, -15, 0),
                        RayParams
                    )

                    if Result and Result.Instance then
                        local Material = Result.Material

                        if Material == Enum.Material.Water then
                            if not _G.WaterWalkPart then
                                local Part = Instance.new("Part")
                                Part.Name = "KryvexWaterWalk"
                                Part.Size = Vector3.new(8, 1, 8)
                                Part.Transparency = 1
                                Part.Anchored = true
                                Part.CanCollide = true
                                Part.Parent = workspace

                                _G.WaterWalkPart = Part
                            end

                            _G.WaterWalkPart.CFrame =
                                CFrame.new(Result.Position.X, Result.Position.Y, Result.Position.Z)
                        end
                    end
                end

                task.wait()
            end
        end)
    else
        if _G.WaterWalkPart then
            _G.WaterWalkPart:Destroy()
            _G.WaterWalkPart = nil
        end
    end
end)

-- LOCK POSITION
_G.LockPosition = false
_G.LockPositionConnection = nil

Misc:AddSwitch("🔒 Lock Position", function(Value)
    _G.LockPosition = Value

    if _G.LockPositionConnection then
        _G.LockPositionConnection:Disconnect()
        _G.LockPositionConnection = nil
    end

    if Value then
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")

        if Root then
            local LockedCFrame = Root.CFrame

            _G.LockPositionConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.LockPosition and Root and Root.Parent then
                    Root.CFrame = LockedCFrame
                    Root.AssemblyLinearVelocity = Vector3.zero
                    Root.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end
    end
end)


-- TRADE
_G.TradeEnabled = true

Misc:AddButton("🔒 Disable Trade", function()
    _G.TradeEnabled = false

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kryvex Hub",
        Text = "Trade Disabled",
        Duration = 2
    })
end)

Misc:AddButton("🔓 Enable Trade", function()
    _G.TradeEnabled = true

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kryvex Hub",
        Text = "Trade Enabled",
        Duration = 2
    })
end)

-- NO CLIP
_G.NoClip = false
_G.NoClipConnection = nil

Misc:AddSwitch("👻 No Clip", function(Value)
    _G.NoClip = Value

    if _G.NoClipConnection then
        _G.NoClipConnection:Disconnect()
        _G.NoClipConnection = nil
    end

    if Value then
        _G.NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
            local Player = game:GetService("Players").LocalPlayer
            local Character = Player.Character

            if Character then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end
        end)
    else
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character

        if Character then
            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = true
                end
            end
        end
    end
end)

-- INFINITE JUMP
_G.InfiniteJumpEnabled = false

Misc:AddSwitch("🦘 Infinite Jump", function(Value)
    _G.InfiniteJumpEnabled = Value
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled then
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)


local credits = window:AddTab("Credits")

local title = credits:AddLabel("✨ Kryvex Hub V2")
title.TextColor3 = Color3.fromRGB(255, 215, 0)

local dev = credits:AddLabel("👤 Developer: WozzyLaco🏴")
dev.TextColor3 = Color3.fromRGB(255, 50, 50)

credits:AddLabel("--------------------------")

local thanks = credits:AddLabel("🤝 Special Thanks to: Halis & henne & RuLing")
thanks.TextColor3 = Color3.fromRGB(0, 255, 255)

local support = credits:AddLabel("❤️ Thanks for the support!")
support.TextColor3 = Color3.fromRGB(255, 105, 180)

credits:AddLabel("--------------------------")

local useMsg = credits:AddLabel("🙏 Thank you for using Kryvex Hub!")
useMsg.TextColor3 = Color3.fromRGB(255, 255, 255)

credits:AddLabel("👇 My Discord Server Link Here")

credits:AddButton("Discord Link", function()
    setclipboard("https://discord.gg/DbAU5Z6HPd")
end)

credits:AddLabel(" ")
credits:AddLabel("==================================")

local bigTitle = credits:AddLabel("🚀 KRYVEX PUBLIC V3 🚀")

pcall(function()
    bigTitle.TextSize = 25
    bigTitle.Font = Enum.Font.GothamBold
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.005 do
            bigTitle.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait()
        end
    end
end)

credits:AddLabel("==================================")
