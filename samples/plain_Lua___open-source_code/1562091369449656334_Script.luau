-- The Re-Born Fully OpenSource
-- the original version is lost
-- so is rebulid from obf backup ver
-- is old ver (very old)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

if _G.MENCOFINGANITRUN then
    return
end
_G.MENCOFINGANITRUN = true

local CONFIG = {
    RayfieldUrl = "https://raw.githubusercontent.com/men-cofing-roblox/AddonsReBorn/main/rayfield.luau", -- own RayField to Fix Rivals Detect
    DatabaseUrl = "https://raw.githubusercontent.com/men-cofing-roblox/AddonsReBorn/refs/heads/main/database.json",
    WindowName = "Men Cofing | Addons | ReBorn",
    DefaultFlySpeed = 25,
    DefaultStretchX = 100,
    DefaultStretchY = 100,
}

local state = {
    cameraStretch = false,
    stretchX = CONFIG.DefaultStretchX,
    stretchY = CONFIG.DefaultStretchY,
    fly = false,
    flySpeed = CONFIG.DefaultFlySpeed,
}

local flyGyro, flyVelocity
local flyConnection

RunService.RenderStepped:Connect(function()
    if state.cameraStretch then
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(
            0, 0, 0,
           state.stretchX/100, 0, 0,
            0, state.stretchY/100, 0,
            0, 0, 1
        )
    end
end)

local function stopFly()
    state.fly = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end

    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local function startFly()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local camera = workspace.CurrentCamera
    if not root or not humanoid or not camera then
        return false
    end

    stopFly()
    state.fly = true
    humanoid.PlatformStand = true

    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "MenCofingFlyGyro"
    flyGyro.P = 90000
    flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.CFrame = camera.CFrame
    flyGyro.Parent = root

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Name = "MenCofingFlyVelocity"
    flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not state.fly or not root.Parent or not camera.Parent then
            stopFly()
            return
        end

        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction -= Vector3.yAxis end

        flyGyro.CFrame = camera.CFrame
        flyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * state.flySpeed or Vector3.zero
    end)
    return true
end

local function setFly(enabled)
    if enabled then
        if not startFly() then
            state.fly = false
            return false
        end
        return true
    end
    stopFly()
    return true
end

local rayfieldSource
local downloaded, result = pcall(function()
    return game:HttpGet(CONFIG.RayfieldUrl)
end)
if downloaded then rayfieldSource = result end

if type(loadstring) ~= "function" or not rayfieldSource then
    warn("Men Cofing: Rayfield could not be loaded in this environment.")
    _G.MENCOFINGANITRUN = nil
    return
end

local rayfieldChunk
local compileOk, compileResult = pcall(loadstring, rayfieldSource)
if compileOk then rayfieldChunk = compileResult end
if not rayfieldChunk then
    warn("Men Cofing: failed to compile Rayfield.")
    _G.MENCOFINGANITRUN = nil
    return
end

local rayfieldOk, Rayfield = pcall(rayfieldChunk)
if not rayfieldOk or type(Rayfield) ~= "table" then
    warn("Men Cofing: Rayfield did not initialize.")
    _G.MENCOFINGANITRUN = nil
    return
end

local namegame = MarketplaceService:GetProductInfo(game.PlaceId).Name

local window = Rayfield:CreateWindow({
    Name = CONFIG.WindowName,
    Icon = 0,
    LoadingTitle = "Men Cofing",
    LoadingSubtitle = "by Men Cofing",
    ShowText = "Men Cofing",
    Theme = "Default",
    ToggleUIKeybind = "P",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "mencofing",
        FileName = "AddonstoGame",
    },
})

local function notify(lib, title, content, duration)
    if lib and lib.Notify then
        pcall(function()
            lib:Notify({
                Title = title or "Men Cofing",
                Content = content or "",
                Duration = duration or 5,
            })
        end)
    else
        print((title or "Men Cofing") .. ": " .. (content or ""))
    end
end

local SupportedExecutors = {"velocity", "xeno"}

local executor = string.lower(getexecutorname())

if not table.find(SupportedExecutors, executor) then
    notify(
        Rayfield,
        "Can't work: Unsupported executor",
        "Supported: Velocity, Xeno",
        5
    )
end

local tab = window:CreateTab("EveryGame", 0)

local luaoutdoor = window:CreateTab(namegame, 0)

tab:CreateToggle({
    Name = "Camera Stretch",
    CurrentValue = false,
    Flag = "EveryGame/CameraStretch",
    Callback = function(value)
        state.cameraStretch = value
    end,
})

tab:CreateSlider({
    Name = "Stretch X",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = CONFIG.DefaultStretchX,
    Flag = "EveryGame/StretchX",
    Callback = function(value)
        state.stretchX = value
    end,
})

tab:CreateSlider({
    Name = "Stretch Y",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = CONFIG.DefaultStretchY,
    Flag = "EveryGame/StretchY",
    Callback = function(value)
        state.stretchY = value
    end,
})

tab:CreateToggle({
    Name = "Fly (Beta)",
    CurrentValue = false,
    Flag = "EveryGame/Fly",
    Callback = function(value)
        if not setFly(value) and value then
            notify(Rayfield, "Fly", "Your character is not ready yet.", 5)
        end
    end,
})

tab:CreateSlider({
    Name = "Fly Speed",
    Range = {5, 250},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = CONFIG.DefaultFlySpeed,
    Flag = "EveryGame/FlySpeed",
    Callback = function(value)
        state.flySpeed = value
    end,
})

tab:CreateButton({
    Name = "ReJoin",
    Callback = function(value)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end,
})

local function fetchGameDatabase()
    local ok, response = pcall(function()
        return game:HttpGet(CONFIG.DatabaseUrl)
    end)
    if not ok then
        return nil, "Could not download the game database."
    end

    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if not decodeOk or type(decoded) ~= "table" then
        return nil, "The game database was not valid JSON."
    end
    return decoded
end

local function findGameScript(database, placeId)
    if type(database) ~= "table" then
        return nil
    end

    for _, entry in pairs(database) do
        if type(entry) == "table" then
            local id = entry.placeid

            if tonumber(id) == tonumber(placeId) then
                return entry.scripturl
            end
        end
    end

    return nil
end

local DataLuas = fetchGameDatabase()

local luaurl = findGameScript(DataLuas,game.PlaceId)

task.spawn(function()
    if not luaurl then luaoutdoor:CreateSection("no one has made a script for this game yet") return end
    local TableofData,_sizeofwindow = loadstring(game:HttpGet(luaurl) or "")()
    if not TableofData then luaoutdoor:CreateSection("the lua dont return some value") return end
    if not TableofData.Load then luaoutdoor:CreateSection("the lua dont have load yet") return end
    pcall(TableofData.Load,luaoutdoor)
end)

task.wait(1) -- waiting the outdoor load fully 

Rayfield:LoadConfiguration()
