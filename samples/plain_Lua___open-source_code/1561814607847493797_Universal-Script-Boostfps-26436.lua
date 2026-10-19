local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v:Destroy()
    end
end
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
local function handleInstance(instance)
    if instance:IsA("BasePart") then
        local player = Players.LocalPlayer
        if player and player.Character and instance:IsDescendantOf(player.Character) then
            return
        end
        instance.Material = Enum.Material.SmoothPlastic
        instance.Reflectance = 0
    end
    if instance:IsA("Texture") or instance:IsA("Decal") then 
        local player = Players.LocalPlayer
        if player and player.Character and instance:IsDescendantOf(player.Character) then
            return
        end
        instance.Transparency = 1
    end
end
for _, instance in ipairs(workspace:GetDescendants()) do
    handleInstance(instance)
end
local terrain = workspace:FindFirstChild("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
end
settings().Physics.AllowSleep = true
settings().Rendering.QualityLevel = 1
settings().Rendering.EagerBulkExecution = false
settings().Rendering.TextureQuality = Enum.TextureQuality.Low