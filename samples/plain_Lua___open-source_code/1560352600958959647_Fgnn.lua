--// SKYBOX + MAP TEXTURE

local Lighting = game:GetService("Lighting")

--// SKYBOX
local skyData = {
	SkyboxBk = "rbxassetid://93590148140827",
	SkyboxDn = "rbxassetid://102453743082771",
	SkyboxFt = "rbxassetid://118903490011578",
	SkyboxLf = "rbxassetid://126562643473125",
	SkyboxRt = "rbxassetid://77446329776959",
	SkyboxUp = "rbxassetid://120495452755285"
}

local function applySkybox()
	local sky = Lighting:FindFirstChildOfClass("Sky")

	if not sky then
		sky = Instance.new("Sky")
		sky.Parent = Lighting
	end

	for property, value in pairs(skyData) do
		sky[property] = value
	end
end

applySkybox()

--// KEEP SKYBOX ACTIVE
Lighting.ChildRemoved:Connect(function(child)
	if child:IsA("Sky") then
		task.wait()
		applySkybox()
	end
end)

Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Sky") then
		task.wait()
		applySkybox()
	end
end)

--// MAP TEXTURE REPLACEMENT
--// 7658055825 -> 72282886233156

local OLD_ID = "7658055825"
local NEW_ID = "72282886233156"

local function isOldTexture(textureId)
	if not textureId then
		return false
	end

	return string.find(textureId, OLD_ID, 1, true) ~= nil
end

for _, object in ipairs(workspace:GetDescendants()) do

	--// Textures
	if object:IsA("Texture") then
		if isOldTexture(object.Texture) then
			object.Texture = "rbxassetid://" .. NEW_ID
		end

	--// Decals
	elseif object:IsA("Decal") then
		if isOldTexture(object.Texture) then
			object.Texture = "rbxassetid://" .. NEW_ID
		end

	--// SurfaceAppearance
	elseif object:IsA("SurfaceAppearance") then
		if isOldTexture(object.ColorMap) then
			object.ColorMap = "rbxassetid://" .. NEW_ID
		end
	end
end

print("Texture replacement complete: " .. OLD_ID .. " -> " .. NEW_ID)
print("Custom skybox applied.")
