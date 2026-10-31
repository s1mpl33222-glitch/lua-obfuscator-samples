-- Donuts are nice!
-- Feel free to take it, change it, improve it or something. I did it with AI anyways.
-- Also please dont add a key system. let people play their game freely.
-- If the script breaks please reach out to @yummydonutperson on IG (THIS IS NOT AN AD.)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
local Workspace = game:GetService("Workspace")
    
local COLORS = {
    Pallet = Color3.fromRGB(255, 170, 0),
    Vent = Color3.fromRGB(255, 0, 0),
    Generator = Color3.fromRGB(0, 255, 0),
    Hatch = Color3.fromRGB(255, 255, 255),
    GadgetCrate = Color3.fromRGB(255, 165, 0),
    Crate = Color3.fromRGB(160, 32, 240),
    BearTrap = Color3.fromRGB(255, 0, 0),
    Lever = Color3.fromRGB(255, 255, 255),
    ArtifactTemplate = Color3.fromRGB(255, 255, 255),
    LensRobot = Color3.fromRGB(255, 0, 0),
    PurificationFountain = Color3.fromRGB(0, 255, 0),
}

local window = Rayfield:CreateWindow({
    name = "ESP",
    subtitle = "Murderthon",
    sidebarLayout = true,
})

local tab = window:CreateTab({
    name = "",
    icon = 93364949241311,
})
local RunService = game:GetService("RunService")

local MIN_FOV, MAX_FOV = 40, 120
local fov = 70
local cameraConnection

local function bindCamera(camera)
    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end

    if not camera then return end

    camera.FieldOfView = fov

    cameraConnection =
        camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if math.abs(camera.FieldOfView - fov) > 0.1 then
                camera.FieldOfView = fov
            end
        end)
end

bindCamera(workspace.CurrentCamera)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    bindCamera(workspace.CurrentCamera)
end)

RunService:BindToRenderStep(
    "FOVController",
    Enum.RenderPriority.Camera.Value + 1,
    function()
        local camera = workspace.CurrentCamera

        if camera and math.abs(camera.FieldOfView - fov) > 0.1 then
            camera.FieldOfView = fov
        end
    end
)

tab:CreateSlider({
    name = "Field of View",
    range = {MIN_FOV, MAX_FOV},
    increment = 1,
    value = fov,
    suffix = "°",
    callback = function(value)
        fov = value

        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = fov
        end
    end,
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local MIN_SPEED = 8
local MAX_SPEED = 32
local targetSpeed = 16

local function applyWalkSpeed()
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.WalkSpeed ~= targetSpeed then
        humanoid.WalkSpeed = targetSpeed
    end
end

tab:CreateSlider({
    name = "WalkSpeed",
    range = {MIN_SPEED, MAX_SPEED},
    increment = 1,
    value = targetSpeed,
    suffix = " studs/s",
    callback = function(value)
        targetSpeed = value
        applyWalkSpeed()
    end,
})

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyWalkSpeed()
end)

RunService.Heartbeat:Connect(applyWalkSpeed)

local masterEnabled = true

local function isHighlightable(object)
    return object:IsA("Model") or object:IsA("BasePart")
end

local function removeHighlight(object, name)
    local existing = object:FindFirstChild(name)
    if existing and existing:IsA("Highlight") then
        existing:Destroy()
    end
end

local function addHighlight(object, name, color, fill)
    if not isHighlightable(object) then
        return
    end

    if object:FindFirstChild(name) then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = name
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = fill and 0.5 or 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object
end
local enabled = {}
local connections = {}

for name in pairs(COLORS) do
    enabled[name] = true
end

local function processObject(object)
    if not masterEnabled then
        return
    end

    local name = object.Name

    if name == "Pallet" and enabled.Pallet then
        addHighlight(object, "PalletChams", COLORS.Pallet, true)

    elseif name == "Vent" and enabled.Vent then
        local count = 0

        for _, child in ipairs(object:GetChildren()) do
            if child.Name == "Part" and child:IsA("BasePart") then
                count += 1

                if count <= 4 then
                    addHighlight(child, "VentChams", COLORS.Vent, true)
                end
            end
        end
    elseif COLORS[name] and enabled[name] then
        addHighlight(
            object,
            name .. "Chams",
            COLORS[name],
            false
        )
    end
end

local function refresh()
    for _, object in ipairs(Workspace:GetDescendants()) do
        local name = object.Name

        if not masterEnabled or not enabled[name] then
            removeHighlight(object, name .. "Chams")
        end

        if name == "Vent" then
            for _, child in ipairs(object:GetChildren()) do
                if child.Name == "Part" then
                    removeHighlight(child, "VentChams")
                end
            end
        end

        if masterEnabled then
            processObject(object)
        end
    end
end

local function setEnabled(name, value)
    enabled[name] = value
    refresh()
end

tab:CreateToggle({
    name = "All Highlights",
    value = true,
    callback = function(value)
        masterEnabled = value
        refresh()
    end,
})

for name in pairs(COLORS) do
    local objectName = name

    tab:CreateToggle({
        name = "Highlight " .. objectName,
        value = true,
        callback = function(value)
            setEnabled(objectName, value)
        end,
    })
end

connections[#connections + 1] =
    Workspace.DescendantAdded:Connect(function(object)
        task.defer(function()
            if object:IsDescendantOf(Workspace) then
                processObject(object)

                if object.Name == "Part"
                    and object.Parent
                    and object.Parent.Name == "Vent"
                    and enabled.Vent
                    and masterEnabled then
                    processObject(object.Parent)
                end
            end
        end)
    end)

refresh()