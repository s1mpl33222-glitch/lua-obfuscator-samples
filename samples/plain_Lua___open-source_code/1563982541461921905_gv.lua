-- i coded this script when i was a bit less experienced so forgive the horrible code.... 
getgenv().SecureMode = true
if game.PlaceId == 891852901 then
	



-- Services

-- Services
--[[ Suspension Update

car.Wheels.FL or FR or RL or RR.Spring

The Properties are: MaxLength, MinLength, FreeLength, Damping, 
]]
local playerservice = game:GetService("Players")
local sessionvehicles = workspace.SessionVehicles
local player = playerservice.LocalPlayer
local Char
local humanoid
	if player.Character then
         Char = player.Character 
	     humanoid = Char.Humanoid     
    end


local StealCarToggle
local addedprox = false

local autoloadToggle 

local autoloadMods = {



}


local LaunchRPM = 4000
local LaunchMult = 10

local walkspeedtoggle
local walkspeedvalue
local carmodule = nil

local function getChar()
    if player.Character then
        return player.Character
    end

    return nil
end

local function getplayercar()
    local playercar
    for i,v in sessionvehicles:GetChildren() do
        if v.Name == player.Name.."-Car" then
            
            playercar = v
        end

    end
    return playercar
end

local function getmodule(playercar)
    local module
    if playercar ~= nil then
        
    else
        return "Not Found"
    end
    if playercar:FindFirstChild("A-Chassis Tune") then
        module = playercar:FindFirstChild("A-Chassis Tune")

    else
        module = "Not Found"
    end
    return module

end

local function setconfig(Setting, Value) 
    local playercar = getplayercar()
    local Module = getmodule(playercar)
    if Module ~= "Not Found" then
        require(Module)[Setting] = Value

        else
            --warn("Couldnt Find module")
    end

end

local function setsuspension(Wheel, Setting, Value)
    local playercar = getplayercar()
    if playercar ~= nil then
        playercar.Wheels[Wheel].Spring["MaxLength"] = 6
        playercar.Wheels[Wheel].Spring[Setting] = Value
    end
end


-- Starlight + Icons
local Starlight =
    loadstring(
    game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua")
)()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
Starlight:SetTheme("Hollywood Dark")
-- Main Window
local Window =
    Starlight:CreateWindow(
    {
        Name = "Lidar | tester's Garage",
        Subtitle = "Greenville",
        Icon = NebulaIcons:GetIcon("car", "Lucide"),
        LoadingSettings = {Title = "Lidar", Subtitle = "Initializing | By testerdevv on dc"},
        FileSettings = {ConfigFolder = "Lidar-Greenville"},
        KeySystem = false
    }
)

Window:CreateHomeTab({
    -- Logic is done this way to not immediately rule out unknown executors.
    -- For example, if Delta is confirmed to break with your script, it can go in Unsupported.
    -- If users use Trigon but you don't have it/unsure whether it works, it can be left out and marked as a maybe

    SupportedExecutors = {"Potassium", "Delta", "Velocity", "Bunni", "Volt", "AWP", "Volcano"}, 
    UnsupportedExecutors = {"Xeno", "Solara"},

    DiscordInvite = "hzXFkN2ZQ9", -- The Discord Invite Link. Do Not Include discord.gg/ | Only Include the code.
    Backdrop = nil, -- A Custom Image to use for the backdrop. Set to 0 to use the Game's Thumbnail. Defaults To A Roblox Void. Set to a blank image to not use.  

    IconStyle = 1, -- 1 for solid, 2 for outline

    Changelog = {
        -- Pass Tables For Each Update
        
        {
            Title = "Initial Release",
            Date = "Jan - Feb",
            Description = "Nothing crazy",
        }

    }
})





-- Vehicle Section
local VehicleSection = Window:CreateTabSection("Vehicle")
local VehicleTab =
    VehicleSection:CreateTab(
    {
        Name = "Vehicle",
        Icon = NebulaIcons:GetIcon("directions_car", "Material"),
        Columns = 1
    },
    "VEHICLE"
)


--- Automated Group
local AutomatedGB = VehicleTab:CreateGroupbox({Name = "Automated"}, "AUTOMATED")

AutomatedGB:CreateToggle({
    Name = "Autoload mods",
    Icon = NebulaIcons:GetIcon('repeat', 'Lucide'),  -- Example icon
    CurrentValue = false,
    Callback = function(state)
        autoloadToggle = state
    end,
}, "AutoLoadTog")

AutomatedGB:CreateButton({
    Name = "Check Mods",
    Icon = NebulaIcons:GetIcon("bell", "Lucide"),
    Callback = function()
        
        local parts = {}
        local i1 = 0
        for i,v in autoloadMods do
            i1 += 1
            parts[i1] = tostring(i) .. " = " .. tostring(v)
         
        end
        local result = table.concat(parts, "\n")
        local Notifications = Starlight:Notification({
            Title = "Mods",
            Icon = NebulaIcons:GetIcon('circle-alert', 'Lucide'),
            Content = result,
        }, "CHECKMODS_NOTIF")

    end,
}, "CHECKMODS_BTN")


AutomatedGB:CreateButton({
    Name = "Clear Mods",
    Icon = NebulaIcons:GetIcon("trash", "Lucide"),
    Callback = function() 
        
       autoloadMods = {}
        

            local Notifications = Starlight:Notification({
            Title = "Mods",
            Icon = NebulaIcons:GetIcon('circle-alert', 'Lucide'),
            Content = "Successfully cleared table",
             }, "CLEARED_NOTIF")


    end,
}, "CLEARMODS_BTN")



AutomatedGB:CreateButton({
    Name = "Refuel Vehicle",
    Icon = NebulaIcons:GetIcon("fuel", "Lucide"),
    Callback = function() 
        
        local Event = game:GetService("ReplicatedStorage").Remote.Refuel
        Event:FireServer(
            1,
            1769581193
        )

    end,
}, "REFUEL_BTN")

AutomatedGB:CreateButton({
    Name = "Wash Vehicle",
    Icon = NebulaIcons:GetIcon("bubbles", "Lucide"),
    Callback = function() 
        local CarwashEvent = game:GetService("ReplicatedStorage").Remote.CarWash
        CarwashEvent:FireServer(
            workspace.SessionVehicles[player.Name.."-Car"]
        )
    end,
}, "WASH_BTN")



-- Engine Group
local EngineGB = VehicleTab:CreateGroupbox({Name = "Engine"}, "ENGINE")
local HorsePowerSlider = EngineGB:CreateSlider({
    Name = "Horsepower",
    Icon = NebulaIcons:GetIcon('chart-no-axes-column-increasing', 'Lucide'),
    Range = {1,3000},
    Increment = 10,
    CurrentValue = 450,
    Callback = function(Value)
        autoloadMods.Horsepower = Value
        setconfig("Horsepower", Value)
    end,
}, "HorsePowerSL")

EngineGB:CreateSlider({
    Name = "Curve Multiplier",
    Icon = NebulaIcons:GetIcon('sliders-horizontal', 'Lucide'),  -- Example icon
    Range = {0.05, 1},
    Increment = 0.005,  -- Optional, based on precision you want
    CurrentValue = 0.125,
    Callback = function(Value)
        autoloadMods.CurveMult = Value
         setconfig("CurveMult", Value)
    end,
}, "CurveMultSL")

EngineGB:CreateSlider({
    Name = "Redline",
    Icon = NebulaIcons:GetIcon('gauge', 'Lucide'),  -- Example icon
    Range = {3000, 25000},
    Increment = 100,
    CurrentValue = 8500,
    Callback = function(Value)
        autoloadMods.Redline = Value
        setconfig("Redline", Value)
    end,
}, "RedlineSL")

EngineGB:CreateSlider({
    Name = "Idle RPM",
    Icon = NebulaIcons:GetIcon('activity', 'Lucide'),  -- Example icon
    Range = {300, 2000},
    Increment = 50,
    CurrentValue = 700,
    Callback = function(Value)
        autoloadMods.IdleRPM = Value
       setconfig("IdleRPM", Value)
    end,
}, "IdleRPMSL")


-- Forced Induction Group
local FI_GB = VehicleTab:CreateGroupbox({Name = "Forced Induction"}, "FORCED_IND")
FI_GB:CreateSlider({
    Name = "Turbochargers",
    Icon = NebulaIcons:GetIcon('cpu', 'Lucide'),  -- Example icon
    Range = {0, 4},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        autoloadMods.Turbochargers = Value
        setconfig("Turbochargers", Value)
    end,
}, "TurbochargersSL")

FI_GB:CreateSlider({
    Name = "Boost",
    Icon = NebulaIcons:GetIcon('gauge', 'Lucide'),  -- Example icon
    Range = {0, 50},
    Increment = 1,
    CurrentValue = 15,
    Callback = function(Value)
        autoloadMods.T_Boost = Value
       setconfig("T_Boost", Value)
    end,
}, "T_BoostSL")

FI_GB:CreateSlider({
    Name = "Efficiency",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),  -- Example icon
    Range = {1, 20},
    Increment = 0.1,
    CurrentValue = 8.5,
    Callback = function(Value)
        autoloadMods.T_Efficiency = Value
        setconfig("T_Efficiency", Value)
    end,
}, "T_EfficiencySL")

-- Launch Control
local LaunchGB = VehicleTab:CreateGroupbox({Name = "Launch Control"}, "LAUNCH")
LaunchGB:CreateToggle({
    Name = "Launch",
    Icon = NebulaIcons:GetIcon('rocket', 'Lucide'),  -- Example icon
    CurrentValue = false,
    Callback = function(state)
        autoloadMods.LaunchRPM = LaunchRPM
        autoloadMods.LaunchMult = LaunchMult
        autoloadMods.Launch = state
        setconfig("LaunchRPM", LaunchRPM)
        setconfig("LaunchMult", LaunchMult)
        setconfig("Launch", state)
    end,
}, "LaunchTog")

LaunchGB:CreateSlider({
    Name = "Launch RPM",
    Icon = NebulaIcons:GetIcon('tachometer', 'Lucide'),  -- Example icon
    Range = {2000, 8000},
    Increment = 100,
    CurrentValue = 4500,
    Callback = function(Value)
        autoloadMods.LaunchRPM = Value
        LaunchRPM = Value
       setconfig("LaunchRPM", Value)
    end,
}, "LaunchRPM_SL")

LaunchGB:CreateSlider({
    Name = "Launch HP Multiplier",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),  -- Example icon
    Range = {1, 30},
    Increment = 0.1,
    CurrentValue = 9.5,
    Callback = function(Value)
        autoloadMods.LaunchMult = Value
        LaunchMult = Value
        setconfig("LaunchMult", Value)
    end,
}, "LaunchMult_SL")


-- Drivetrain / Differential
local DrivetrainGB = VehicleTab:CreateGroupbox({Name = "Drivetrain / Differential"}, "DRIVE")

-- Create a label first
local DrivetrainLabel = DrivetrainGB:CreateLabel({
    Name = "Drivetrain"
}, "DrivetrainLabel")

DrivetrainGB:CreateSlider({
    Name = "Final Drive",
    Icon = NebulaIcons:GetIcon('activity', 'Lucide'),  -- Example icon
    Range = {0.1, 5},
    Increment = 0.05,
    CurrentValue = 3.5,
    Callback = function(Value)
        autoloadMods.FinalDrive = Value
       setconfig("FinalDrive", Value)
    end,
}, "IdleRPMSL")

-- Add the dropdown to the label
local DrivetrainDropdown = DrivetrainLabel:AddDropdown({
    Options = {"AWD", "RWD", "FWD"},
    CurrentOptions = {"AWD"},
    Placeholder = "Select Drivetrain",
    Callback = function(opt)
        autoloadMods.Config = opt[1]
       setconfig("Config", opt[1])
    end,
}, "DrivetrainConfig")


-- Traction / ABS

    --[[ Deprecated wont use




    ]]

-- Braking
local BrakingGB = VehicleTab:CreateGroupbox({Name = "Braking"}, "BRAKE")
-- BrakeForce Slider
BrakingGB:CreateSlider({
    Name = "Brake Force",
    Icon = NebulaIcons:GetIcon('gauge', 'Lucide'),  -- Example icon
    Range = {5000, 50000},
    Increment = 500,
    CurrentValue = 26600,
    Callback = function(Value)
        autoloadMods.BrakeForce = Value
        setconfig("BrakeForce", Value)
    end,
}, "BrakeForce_SL")

-- BrakeBias Slider
BrakingGB:CreateSlider({
    Name = "Brake Bias",
    Icon = NebulaIcons:GetIcon('sliders-horizontal', 'Lucide'),  -- Example icon
    Range = {0, 1},
    Increment = 0.01,
    CurrentValue = 0.5,
    Callback = function(Value)
        autoloadMods.BrakeBias = Value
       setconfig("BrakeBias", Value)
    end,
}, "BrakeBias_SL")

-- PBrakeForce Slider
BrakingGB:CreateSlider({
    Name = "Park Brake Force",
    Icon = NebulaIcons:GetIcon('gauge', 'Lucide'),  -- Example icon
    Range = {0, 50000},
    Increment = 500,
    CurrentValue = 30500,
    Callback = function(Value)
        autoloadMods.PBrakeForce = Value
     setconfig("PBrakeForce", Value)
    end,
}, "PBrakeForce_SL")


-- Steering Section
local SteeringGB = VehicleTab:CreateGroupbox({Name = "Steering"}, "STEER")

SteeringGB:CreateSlider({
    Name = "Steer Decay",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {100, 1500},
    Increment = 10,
    CurrentValue = 300,
    Callback = function(Value)
        autoloadMods.SteerDecay = Value
        setconfig("SteerDecay", Value)
    end,
}, "SteerDecay_SL")

SteeringGB:CreateSlider({
    Name = "Steer Ratio",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {5, 30},
    Increment = 0.1,
    CurrentValue = 17.4,
    Callback = function(Value)
        autoloadMods.SteerRatio = Value
        setconfig("SteerRatio", Value)
    end,
}, "SteerRatio_SL")

SteeringGB:CreateSlider({
    Name = "Lock To Lock",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {1, 5},
    Increment = 0.1,
    CurrentValue = 3.4,
    Callback = function(Value)
        autoloadMods.LockToLock = Value
        setconfig("LockToLock", Value)
    end,
}, "LockToLock_SL")

SteeringGB:CreateSlider({
    Name = "Ackerman",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 2},
    Increment = 0.01,
    CurrentValue = 1.2,
    Callback = function(Value)
        autoloadMods.Ackerman = Value
        setconfig("Ackerman", Value)
    end,
}, "Ackerman_SL")



local SuspensionGB = VehicleTab:CreateGroupbox({Name = "Suspension Height"}, "SUSPENSION")


SuspensionGB:CreateSlider({
    Name = "All Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("FL", "FreeLength", Value)
        setsuspension("FR", "FreeLength", Value)
        setsuspension("RL", "FreeLength", Value)
        setsuspension("RR", "FreeLength", Value)
    end,
}, "SusHeight")

SuspensionGB:CreateSlider({
    Name = "Rear Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("RL", "FreeLength", Value)
        setsuspension("RR", "FreeLength", Value)
    end,
}, "SusHeight")

SuspensionGB:CreateSlider({
    Name = "Front Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("FL", "FreeLength", Value)
        setsuspension("FR", "FreeLength", Value)
    end,
}, "SusHeight")

SuspensionGB:CreateSlider({
    Name = "Front Left Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("FL", "FreeLength", Value)
    end,
}, "SusHeight")


SuspensionGB:CreateSlider({
    Name = "Front Right Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("FR", "FreeLength", Value)
    end,
}, "SusHeight")


SuspensionGB:CreateSlider({
    Name = "Rear Left Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("RL", "FreeLength", Value)
    end,
}, "SusHeight")


SuspensionGB:CreateSlider({
    Name = "Rear Right Suspension Height",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {0, 6},
    Increment = 0.01,
    CurrentValue = 1.8,
    Callback = function(Value)
        setsuspension("RR", "FreeLength", Value)
    end,
}, "SusHeight")


local SuspensionSettingGB = VehicleTab:CreateGroupbox({Name = "Suspension Settings"}, "SUSPENSIONSETTING")

SuspensionSettingGB:CreateSlider({
    Name = "Suspension Damping",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {150, 2000},
    Increment = 50,
    CurrentValue = 350,
    Callback = function(Value)
        setsuspension("FL", "Damping", Value)
        setsuspension("FR", "Damping", Value)
        setsuspension("RL", "Damping", Value)
        setsuspension("RR", "Damping", Value)
    end,
}, "SusHeight")

SuspensionSettingGB:CreateSlider({
    Name = "Suspension Stiffness",
    Icon = NebulaIcons:GetIcon('settings', 'Lucide'),
    Range = {600, 50000},
    Increment = 200,
    CurrentValue = 10000,
    Callback = function(Value)
        setsuspension("FL", "Stiffness", Value)
        setsuspension("FR", "Stiffness", Value)
        setsuspension("RL", "Stiffness", Value)
        setsuspension("RR", "Stiffness", Value)
    end,
}, "SusHeight")



-- QoL Section
local QoLGB = VehicleTab:CreateGroupbox({Name = "QoL"}, "QOL")

QoLGB:CreateButton({
    Name = "Flip Vehicle",
    Icon = NebulaIcons:GetIcon("arrow_upward", "Material"),
    Callback = function()
    end,
}, "FlipVehicle_BTN")

QoLGB:CreateToggle({
    Name = "Steal Vehicles Prompt",
    Icon = NebulaIcons:GetIcon("lock_open", "Material"),
    CurrentValue = false,
    Callback = function(State)
        StealCarToggle = State
        if addedprox == false and State == true then
            addedprox = true
            for i,v in sessionvehicles:GetChildren() do
        
                        if v.Name == player.Name.."-Car" then
                        --print("Found player car denied")
                        else
                        if v:FindFirstChild("DriveSeat") then
                            local newprox = Instance.new("ProximityPrompt", v.DriveSeat)
                            newprox.RequiresLineOfSight = false
                            newprox.MaxActivationDistance = 25
                            newprox.HoldDuration = 0.5
                            newprox.ActionText = "Steal Car"
                            newprox.KeyboardKeyCode = Enum.KeyCode.G
                            newprox.Triggered:Connect(function()
                                v.DriveSeat:Sit(humanoid)
                            end)
                            if v.DriveSeat.Occupant ~= nil then newprox.Enabled = false end
                             v.DriveSeat:GetPropertyChangedSignal("Occupant"):Connect(function ()
                                if v.DriveSeat.Occupant == nil then

                                    newprox.Enabled = true
                                    else
                                    newprox.Enabled = false
                                end
                            end)
                        end
                        
                    end

            end
        end
    end,
}, "VehicleNoClip_Tog")





-- Settings Section
local SettingsSection = Window:CreateTabSection("Settings")
local SettingsTab = SettingsSection:CreateTab({
    Name = "Settings",
    Icon = NebulaIcons:GetIcon("settings", "Material"),
    Columns = 1
}, "SETTINGS")

SettingsTab:BuildConfigGroupbox(1)

local SettingsGB = SettingsTab:CreateGroupbox({Name = "Main"}, "MAIN")


-- Load Config


Starlight:LoadAutoloadConfig()
--autoloadMods = {}

sessionvehicles.ChildAdded:Connect(function (v)
    if autoloadToggle == true then
        if v.Name == player.Name.."-Car" then
            local module = v:WaitForChild("A-Chassis Tune", 3)
            local reqModule = require(module)
            for iValue, vValue in autoloadMods do
                reqModule[iValue] = vValue

            end

        end
    end

    if StealCarToggle == true then
        if v.Name == player.Name.."-Car" then
            --print("Found player car denied")
            else
            if v:FindFirstChild("DriveSeat") then
                local newprox = Instance.new("ProximityPrompt", v.DriveSeat)
                newprox.RequiresLineOfSight = false
                newprox.MaxActivationDistance = 20
                newprox.HoldDuration = 0.5
                newprox.ActionText = "Hijack"
                newprox.KeyboardKeyCode = Enum.KeyCode.G
                if v.DriveSeat.Occupant ~= nil then newprox.Enabled = false end

                newprox.Triggered:Connect(function()
                    v.DriveSeat:Sit(humanoid)
                end)
                v.DriveSeat:GetPropertyChangedSignal("Occupant"):Connect(function ()
                    if v.DriveSeat.Occupant == nil then

                        newprox.Enabled = true
                        else
                        newprox.Enabled = false
                    end
                end)
            end
            
        end
    end
end)


if getChar() == nil then
    local Notifications = Starlight:Notification({
    Title = "Alert",
    Icon = NebulaIcons:GetIcon('circle-alert', 'Lucide'),
    Content = "Character not found, upon spawning in please refresh player values.",
}, "NOTFOUNDALERT")
end

player.CharacterAdded:Connect(function()
    Char = player.Character
    humanoid = Char:WaitForChild("Humanoid")
    --print("Assigned Character")
end)


end


