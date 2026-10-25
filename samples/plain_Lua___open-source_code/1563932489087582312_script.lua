-- ==========================================
-- SERVICES & LOCAL PLAYER
-- ==========================================
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local RS              = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")

local LocalPlayer     = Players.LocalPlayer

-- Clean up any existing hub instances
if getgenv().JenicakesHub and type(getgenv().JenicakesHub.Unload) == "function" then
    pcall(function() getgenv().JenicakesHub:Unload() end)
end

-- ==========================================
-- REMOTE REFERENCES
-- ==========================================
local Svc = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")

local requestRF  = nil
local vaultRF    = nil
local collectRF  = nil
local purchaseRF = nil

pcall(function() requestRF  = Svc.EggSpawnerService.RF.RequestHitEgg       end)
pcall(function() vaultRF    = Svc.EggVaultService.RF.RequestHitVaultEgg     end)
pcall(function() collectRF  = Svc.BaseService.RF.RequestPlatformCollect      end)
pcall(function() purchaseRF = Svc.PetEggStockService.RF.PurchasePetEgg       end)

local eggFolder = workspace:WaitForChild("EggRenderModels", 10)

-- ==========================================
-- CONFIG & DATA STRUCTURE
-- ==========================================
local RANGE = 35

local Cfg = {
    antiAfk    = true,
    autoRejoin = false,
}

local BuyEggList = {
    { id = "i1", active = false, name = "Basic Rare (50c)"    },
    { id = "i2", active = false, name = "Quality Epic (100c)" },
    { id = "i3", active = false, name = "Elite Legend (150c)" },
    { id = "i4", active = false, name = "Super Mythic (250c)" },
}

local FARM = {
    farmActive    = false,
    walkActive    = false,
    vaultActive   = false,
    bypassActive  = false,
    collectActive = false,
    buyActive     = false,
    hitCount      = 0,
}

local farmConn    = nil
local walkConn    = nil
local vaultConn   = nil
local bypassConn  = nil
local antiAfkCon  = nil
local collectTask = nil
local buyTask     = nil

local Hub = {
    Version     = "1.0.0",
    Running     = true,
    Window      = nil,
    WindUI      = nil,
    Connections = {},
    Settings    = Cfg
}
getgenv().JenicakesHub = Hub

-- ==========================================
-- LOGIC HELPER FUNCTIONS
-- ==========================================
local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getNearestEgg()
    local hrp = getHRP()
    if not hrp or not eggFolder then return nil end
    local best, bestDist = nil, math.huge
    for _, obj in ipairs(eggFolder:GetChildren()) do
        local hb = obj:FindFirstChild("Hitbox")
        if obj:IsA("Model") and hb then
            local d = (hrp.Position - hb.Position).Magnitude
            if d < bestDist then bestDist = d; best = hb.Position end
        end
    end
    return best
end

local function setAntiAfk(enabled)
    if getconnections then
        for _, c in ipairs(getconnections(LocalPlayer.Idled)) do
            pcall(function() c:Disable() end)
            pcall(function() c:Disconnect() end)
        end
    end

    if antiAfkCon then
        antiAfkCon:Disconnect()
        antiAfkCon = nil
    end

    if enabled then
        antiAfkCon = LocalPlayer.Idled:Connect(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.zero)
        end)
    end
end

setAntiAfk(Cfg.antiAfk)

-- Helper to safely set WindUI visual toggles
local function updateVisualToggle(toggleObj, state)
    if not toggleObj then return end
    pcall(function()
        if type(toggleObj.Set) == "function" then
            toggleObj:Set(state)
        elseif type(toggleObj.SetValue) == "function" then
            toggleObj:SetValue(state)
        elseif type(toggleObj.Update) == "function" then
            toggleObj:Update(state)
        end
    end)
end

-- ==========================================
-- FARMING CONTROLLERS
-- ==========================================
local function startFarm()
    if farmConn then farmConn:Disconnect() end
    farmConn = RunService.Heartbeat:Connect(function()
        if not FARM.farmActive or not requestRF or not eggFolder then return end
        local hrp = getHRP(); if not hrp then return end
        local batch = {}
        for _, obj in ipairs(eggFolder:GetChildren()) do
            local hb = obj:FindFirstChild("Hitbox")
            if obj:IsA("Model") and hb then
                if (hrp.Position - hb.Position).Magnitude <= RANGE then
                    batch[#batch + 1] = obj.Name
                end
            end
        end
        if #batch > 0 then
            FARM.hitCount = FARM.hitCount + #batch
            pcall(function() requestRF:InvokeServer(batch) end)
        end
    end)
end

local function stopFarm()
    if farmConn then farmConn:Disconnect(); farmConn = nil end
end

local function startWalk()
    if walkConn then walkConn:Disconnect() end
    walkConn = RunService.Heartbeat:Connect(function()
        if not FARM.walkActive then return end
        local hrp = getHRP(); local hum = getHum()
        if not hrp or not hum or not eggFolder then return end
        local target = getNearestEgg()
        if not target then return end
        if (hrp.Position - target).Magnitude > RANGE * 0.6 then
            hum:MoveTo(target)
        else
            local farthest, farthestDist = nil, 0
            for _, obj in ipairs(eggFolder:GetChildren()) do
                local hb = obj:FindFirstChild("Hitbox")
                if obj:IsA("Model") and hb then
                    local d = (hrp.Position - hb.Position).Magnitude
                    if d > farthestDist and d <= RANGE * 2 then
                        farthestDist = d; farthest = hb.Position
                    end
                end
            end
            if farthest then hum:MoveTo(farthest) end
        end
    end)
end

local function stopWalk()
    if walkConn then walkConn:Disconnect(); walkConn = nil end
    local hrp = getHRP(); local hum = getHum()
    if hum and hrp then hum:MoveTo(hrp.Position) end
end

local function startVault()
    if vaultConn then vaultConn:Disconnect() end
    vaultConn = RunService.Heartbeat:Connect(function()
        if not FARM.vaultActive or not vaultRF then return end
        local hrp = getHRP(); if not hrp then return end
        for _, contName in ipairs({ "Eggs", "EggRenderModels" }) do
            local cont = workspace:FindFirstChild(contName)
            if cont then
                for _, obj in ipairs(cont:GetDescendants()) do
                    if (obj:IsA("Model") or obj:IsA("BasePart"))
                        and obj.Name:find("-") and #obj.Name == 36 then
                        local part = (obj:IsA("BasePart") and obj)
                            or obj.PrimaryPart
                            or obj:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= 150 then
                            task.spawn(function()
                                pcall(function() vaultRF:InvokeServer(obj.Name) end)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

local function stopVault()
    if vaultConn then vaultConn:Disconnect(); vaultConn = nil end
end

local function startBypass()
    pcall(function()
        local world = workspace:FindFirstChild("World")
        if world then
            for _, n in ipairs({ "PurchaseWall_Zone3", "PurchaseWall_Zone2" }) do
                local w = world:FindFirstChild(n); if w then w:Destroy() end
            end
        end
    end)
    if bypassConn then bypassConn:Disconnect() end
    bypassConn = RunService.Heartbeat:Connect(function()
        if not FARM.bypassActive then return end
        local char = LocalPlayer.Character; if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)
end

local function stopBypass()
    if bypassConn then bypassConn:Disconnect(); bypassConn = nil end
end

local function startCollect()
    if collectTask then task.cancel(collectTask) end
    collectTask = task.spawn(function()
        while FARM.collectActive do
            pcall(function()
                if not collectRF then return end
                for i = 1, 60 do
                    task.spawn(function()
                        pcall(function() collectRF:InvokeServer(i) end)
                    end)
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function stopCollect()
    FARM.collectActive = false
    if collectTask then task.cancel(collectTask); collectTask = nil end
end

local function startBuy()
    if buyTask then task.cancel(buyTask) end
    buyTask = task.spawn(function()
        while FARM.buyActive do
            pcall(function()
                if not purchaseRF then return end
                for _, egg in ipairs(BuyEggList) do
                    if egg.active then
                        purchaseRF:InvokeServer(egg.id, 1)
                        task.wait(0.1)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function stopBuy()
    FARM.buyActive = false
    if buyTask then task.cancel(buyTask); buyTask = nil end
end

-- Reset on character death/respawn
LocalPlayer.CharacterAdded:Connect(function()
    stopFarm(); stopWalk(); stopVault(); stopBypass(); stopCollect(); stopBuy()
    task.wait(1)
    if FARM.farmActive then startFarm() end
    if FARM.walkActive then startWalk() end
    if FARM.vaultActive then startVault() end
    if FARM.bypassActive then startBypass() end
    if FARM.collectActive then startCollect() end
    if FARM.buyActive then startBuy() end
end)

-- Auto Rejoin Event
LocalPlayer.OnTeleport:Connect(function()
    if Cfg.autoRejoin then
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

-- ==========================================
-- WINDUI INTERFACE SETUP
-- ==========================================
local windUI = loadstring(game:HttpGet("https://github.com/mallu837/JenicakesUI/releases/latest/download/main.lua"))()
Hub.WindUI = windUI

local jenicakesWindow = windUI:CreateWindow({
    Title = "Jenicakes Hub",
    Icon = "sparkles",
    Author = "Break a Brainrot Egg",
    Folder = "JenicakesHub_Config",
    Size = UDim2.fromOffset(620, 500),
    Transparent = true,
    Theme = "Dark",
    Acrylic = false,
    Resizable = true,
})
Hub.Window = jenicakesWindow
pcall(function() jenicakesWindow:SetToTheCenter() end)

---------------------------------------------------------
-- TAB 1: MAIN TAB
---------------------------------------------------------
local mainTab = jenicakesWindow:Tab({ Title = "Main", Icon = "home" })

mainTab:Section({ Title = "Farming Automation" })

local toggleFarm = mainTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically hits nearby eggs within range",
    Value = FARM.farmActive,
    Callback = function(val)
        FARM.farmActive = val
        if val then startFarm() else stopFarm() end
    end
})

local toggleWalk = mainTab:Toggle({
    Title = "Auto Walk",
    Desc = "Moves character around eggs to stay within farming range",
    Value = FARM.walkActive,
    Callback = function(val)
        FARM.walkActive = val
        if val then startWalk() else stopWalk() end
    end
})

local toggleVault = mainTab:Toggle({
    Title = "Hit Egg Vault",
    Desc = "Interacts with vault eggs in range automatically",
    Value = FARM.vaultActive,
    Callback = function(val)
        FARM.vaultActive = val
        if val then startVault() else stopVault() end
    end
})

local toggleCollect = mainTab:Toggle({
    Title = "Collect Money",
    Desc = "Fires platform collection requests",
    Value = FARM.collectActive,
    Callback = function(val)
        FARM.collectActive = val
        if val then startCollect() else stopCollect() end
    end
})

---------------------------------------------------------
-- TAB 2: SHOP TAB
---------------------------------------------------------
local shopTab = jenicakesWindow:Tab({ Title = "Shop", Icon = "shopping-cart" })

shopTab:Section({ Title = "Egg Selection" })

local eggToggles = {}
for _, egg in ipairs(BuyEggList) do
    eggToggles[egg.id] = shopTab:Toggle({
        Title = egg.name,
        Desc = "Enable purchasing for this egg type",
        Value = egg.active,
        Callback = function(val)
            egg.active = val
        end
    })
end

shopTab:Section({ Title = "Automation" })

local toggleBuy = shopTab:Toggle({
    Title = "Auto Buy Eggs",
    Desc = "Automatically purchases selected eggs",
    Value = FARM.buyActive,
    Callback = function(val)
        FARM.buyActive = val
        if val then startBuy() else stopBuy() end
    end
})

---------------------------------------------------------
-- TAB 3: CONFIG TAB
---------------------------------------------------------
local configTab = jenicakesWindow:Tab({ Title = "Configs", Icon = "file-text" })

local configFolder = "JenicakesHub_Configs"
if makefolder and not isfolder(configFolder) then
    pcall(makefolder, configFolder)
end

local configInputName = "My config"
local selectedConfig = "---"
local jsonText = ""

local function getSaveData()
    local eggStates = {}
    for _, egg in ipairs(BuyEggList) do
        eggStates[egg.id] = egg.active
    end
    return {
        Farm = FARM,
        Cfg = Cfg,
        Eggs = eggStates
    }
end

local function applySaveData(data)
    if not data or type(data) ~= "table" then return end
    
    if data.Cfg then
        Cfg.antiAfk = data.Cfg.antiAfk or false
        Cfg.autoRejoin = data.Cfg.autoRejoin or false
        setAntiAfk(Cfg.antiAfk)
    end
    
    if data.Eggs then
        for _, egg in ipairs(BuyEggList) do
            if data.Eggs[egg.id] ~= nil then
                egg.active = data.Eggs[egg.id]
                updateVisualToggle(eggToggles[egg.id], egg.active)
            end
        end
    end

    if data.Farm then
        -- Auto Farm
        if data.Farm.farmActive ~= nil then
            FARM.farmActive = data.Farm.farmActive
            updateVisualToggle(toggleFarm, FARM.farmActive)
            if FARM.farmActive then startFarm() else stopFarm() end
        end
        -- Auto Walk
        if data.Farm.walkActive ~= nil then
            FARM.walkActive = data.Farm.walkActive
            updateVisualToggle(toggleWalk, FARM.walkActive)
            if FARM.walkActive then startWalk() else stopWalk() end
        end
        -- Hit Egg Vault
        if data.Farm.vaultActive ~= nil then
            FARM.vaultActive = data.Farm.vaultActive
            updateVisualToggle(toggleVault, FARM.vaultActive)
            if FARM.vaultActive then startVault() else stopVault() end
        end
        -- Collect Money
        if data.Farm.collectActive ~= nil then
            FARM.collectActive = data.Farm.collectActive
            updateVisualToggle(toggleCollect, FARM.collectActive)
            if FARM.collectActive then startCollect() else stopCollect() end
        end
        -- Auto Buy
        if data.Farm.buyActive ~= nil then
            FARM.buyActive = data.Farm.buyActive
            updateVisualToggle(toggleBuy, FARM.buyActive)
            if FARM.buyActive then startBuy() else stopBuy() end
        end
        -- Bypass
        if data.Farm.bypassActive ~= nil then
            FARM.bypassActive = data.Farm.bypassActive
            if FARM.bypassActive then startBypass() else stopBypass() end
        end
    end
end

local function listConfigFiles()
    local files = { "---" }
    if listfiles and isfolder(configFolder) then
        for _, file in ipairs(listfiles(configFolder)) do
            if file:sub(-5) == ".json" and not file:find("autoload_setting.txt") then
                local filename = file:gsub("\\", "/"):match("([^/]+)%.json$")
                if filename then
                    table.insert(files, filename)
                end
            end
        end
    end
    return files
end

configTab:Input({
    Title = "Name",
    Value = "My config",
    Callback = function(val)
        configInputName = val ~= "" and val or "My config"
    end
})

local dropdown = configTab:Dropdown({
    Title = "Configs",
    Values = listConfigFiles(),
    Value = "---",
    Callback = function(val)
        selectedConfig = val
    end
})

configTab:Button({
    Title = "+ Create Config",
    Callback = function()
        if writefile then
            local name = configInputName ~= "" and configInputName or "My config"
            local path = configFolder .. "/" .. name .. ".json"
            writefile(path, HttpService:JSONEncode(getSaveData()))
            dropdown:SetValues(listConfigFiles())
        end
    end
})

configTab:Button({
    Title = "📂 Load Config",
    Callback = function()
        if selectedConfig ~= "---" and isfile then
            local path = configFolder .. "/" .. selectedConfig .. ".json"
            if isfile(path) then
                local raw = readfile(path)
                local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and decoded then applySaveData(decoded) end
            end
        end
    end
})

configTab:Button({
    Title = "💾 Overwrite Config",
    Callback = function()
        if selectedConfig ~= "---" and writefile then
            local path = configFolder .. "/" .. selectedConfig .. ".json"
            writefile(path, HttpService:JSONEncode(getSaveData()))
        end
    end
})

configTab:Button({
    Title = "🗑️ Delete Config",
    Callback = function()
        if selectedConfig ~= "---" and delfile then
            local path = configFolder .. "/" .. selectedConfig .. ".json"
            if isfile(path) then
                delfile(path)
                dropdown:SetValues(listConfigFiles())
                dropdown:SetValue("---")
            end
        end
    end
})

configTab:Button({
    Title = "🔄 Refresh Configs",
    Callback = function()
        dropdown:SetValues(listConfigFiles())
    end
})

local autoloadLabel = configTab:Paragraph({
    Title = "⭐ Autoload: None",
    Desc = ""
})

local function updateAutoloadLabel(name)
    autoloadLabel:SetTitle("⭐ Autoload: " .. name)
end

configTab:Button({
    Title = "⭐ Set Autoload",
    Callback = function()
        if selectedConfig ~= "---" and writefile then
            writefile(configFolder .. "/autoload_setting.txt", selectedConfig)
            updateAutoloadLabel(selectedConfig)
        end
    end
})

configTab:Button({
    Title = "🗑️ Clear Autoload",
    Callback = function()
        if writefile then
            writefile(configFolder .. "/autoload_setting.txt", "None")
            updateAutoloadLabel("None")
        end
    end
})

local jsonInput = configTab:Input({
    Title = "Config JSON",
    Value = "Exported JSON appears here",
    Callback = function(val)
        jsonText = val
    end
})

configTab:Button({
    Title = "📥 Import JSON",
    Callback = function()
        if jsonText ~= "" and jsonText ~= "Exported JSON appears here" then
            local ok, decoded = pcall(function() return HttpService:JSONDecode(jsonText) end)
            if ok and decoded then applySaveData(decoded) end
        end
    end
})

configTab:Button({
    Title = "📤 Export JSON",
    Callback = function()
        local str = HttpService:JSONEncode(getSaveData())
        jsonInput:SetValue(str)
        jsonText = str
    end
})

configTab:Button({
    Title = "📋 Copy JSON",
    Callback = function()
        local str = HttpService:JSONEncode(getSaveData())
        if setclipboard then
            setclipboard(str)
        elseif toclipboard then
            toclipboard(str)
        end
    end
})

-- Boot Autoload Trigger
task.spawn(function()
    task.wait(1.5)
    local autoPath = configFolder .. "/autoload_setting.txt"
    if isfile and isfile(autoPath) then
        local name = readfile(autoPath)
        if name and name ~= "None" and name ~= "" then
            updateAutoloadLabel(name)
            local cfgPath = configFolder .. "/" .. name .. ".json"
            if isfile(cfgPath) then
                local raw = readfile(cfgPath)
                local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and decoded then
                    applySaveData(decoded)
                end
            end
        end
    end
end)

---------------------------------------------------------
-- TAB 4: MISC TAB
---------------------------------------------------------
local miscTab = jenicakesWindow:Tab({ Title = "Misc", Icon = "settings" })

miscTab:Section({ Title = "Bypass & Exploits" })

miscTab:Toggle({
    Title = "Bypass Zones",
    Desc = "Removes wall barriers and disables body collision",
    Value = FARM.bypassActive,
    Callback = function(val)
        FARM.bypassActive = val
        if val then startBypass() else stopBypass() end
    end
})

miscTab:Section({ Title = "Performance & Automation" })

miscTab:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents client from being kicked for idling",
    Value = Cfg.antiAfk,
    Callback = function(val)
        Cfg.antiAfk = val
        setAntiAfk(val)
    end
})

miscTab:Toggle({
    Title = "Auto Rejoin",
    Desc = "Automatically rejoins the server upon disconnection",
    Value = Cfg.autoRejoin,
    Callback = function(val)
        Cfg.autoRejoin = val
    end
})

miscTab:Section({ Title = "Community & Support" })

miscTab:Paragraph({
    Title = "Discord Community",
    Desc = "Join our Discord server for updates and script feedback!"
})

miscTab:Button({
    Title = "Copy Discord Invite",
    Callback = function()
        local link = "https://discord.gg/GFZYsspybS"
        if setclipboard then
            setclipboard(link)
        elseif toclipboard then
            toclipboard(link)
        end
    end
})

---------------------------------------------------------
-- UNLOAD FUNCTION
---------------------------------------------------------
function Hub:Unload()
    self.Running = false
    FARM.farmActive = false; FARM.walkActive = false
    FARM.vaultActive = false; FARM.bypassActive = false
    FARM.collectActive = false; FARM.buyActive = false
    
    stopFarm(); stopWalk(); stopVault(); stopBypass(); stopCollect(); stopBuy()

    if antiAfkCon then
        antiAfkCon:Disconnect()
        antiAfkCon = nil
    end

    for _, conn in ipairs(self.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(self.Connections)

    if self.Window and type(self.Window.Destroy) == "function" then
        pcall(function() self.Window:Destroy() end)
    end
    getgenv().JenicakesHub = nil
end
