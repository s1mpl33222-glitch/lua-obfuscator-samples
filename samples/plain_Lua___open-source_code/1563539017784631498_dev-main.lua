local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerData = localPlayer:WaitForChild("PlayerData")
local purchased = playerData:WaitForChild("Purchased")
local purchasedSkins = purchased:WaitForChild("Skins")

local assets = ReplicatedStorage:WaitForChild("Assets")
local skinsFolder = assets:WaitForChild("Skins")

local playerGui = localPlayer:WaitForChild("PlayerGui")
local mainUI = playerGui:WaitForChild("MainUI")
local skinsContainer = mainUI.InventoryScreen.InventoryRoot.SkinsContainer.Contents

local selectedSkinName = nil
local currentVisualRig = nil
local currentSelectedContainer = nil
local currentAnimTracks = {}
local animConnection = nil

--------------------------------------------------------------------------------
-- 1. CRIAÇÃO DOS INT VALUES
--------------------------------------------------------------------------------
for _, item in ipairs(skinsFolder:GetDescendants()) do
	if item:IsA("Folder") and item.Parent ~= skinsFolder then
		if not purchasedSkins:FindFirstChild(item.Name) then
			local intValue = Instance.new("IntValue")
			intValue.Name = item.Name
			intValue.Value = 1
			intValue.Parent = purchasedSkins
		end
	end
end

--------------------------------------------------------------------------------
-- 2. OCULTAR O CORPO ORIGINAL E APAGAR ACESSÓRIOS/ROUPAS
--------------------------------------------------------------------------------

local function clearOriginalAppearance(character)
	if not character then return end

	-- Deleta acessórios, chapéus, roupas e malhas
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Accoutrement") then
			child:Destroy()
		elseif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
			child:Destroy()
		end
	end

	-- Deixa todas as partes do corpo original INVISÍVEIS e apaga o rosto (Decal)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("BasePart") then
			child.Transparency = 1
			for _, subChild in ipairs(child:GetChildren()) do
				if subChild:IsA("Decal") or subChild:IsA("Texture") then
					subChild:Destroy()
				end
			end
		end
	end
end

-- Deleta outros Models no player (preservando o Rig visual ativo)
local function removeModelsFromCharacter(character)
	if not character then return end
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Model") and child ~= currentVisualRig then
			child:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- 3. VALIDAÇÃO DA SKIN E CORRESPONDÊNCIA DO PERSONAGEM
--------------------------------------------------------------------------------

local function findSkinFolder(skinName)
	local cleanName = skinName:gsub("^!", "")
	for _, descendant in ipairs(skinsFolder:GetDescendants()) do
		if descendant:IsA("Folder") and descendant.Name:lower() == cleanName:lower() then
			return descendant
		end
	end
	return nil
end

local function skinMatchesCurrentCharacter(skinFolder, character)
	if not skinFolder or not character then return false end

	local ownerFolder = skinFolder.Parent
	if not ownerFolder or ownerFolder == skinsFolder then return true end

	local ownerName = ownerFolder.Name:lower()
	
	if ownerName == "killers" or ownerName == "survivors" then
		return true
	end

	local charName = character.Name:lower()

	if charName:find(ownerName, 1, true) or ownerName:find(charName, 1, true) then
		return true
	end

	for _, child in ipairs(character:GetChildren()) do
		if (child:IsA("StringValue") or child:IsA("ObjectValue")) and (child.Name == "Character" or child.Name == "Survivor" or child.Name == "Killer") then
			local valName = tostring(child.Value):lower()
			if valName:find(ownerName, 1, true) or ownerName:find(valName, 1, true) then
				return true
			end
		end
	end

	return false
end

local function findRigModel(skinName)
	local cleanName = skinName:gsub("^!", "")
	for _, descendant in ipairs(assets:GetDescendants()) do
		if descendant:IsA("Model") then
			if descendant.Name:lower() == cleanName:lower() or (descendant.Name == "Rig" and descendant.Parent.Name:lower() == cleanName:lower()) then
				return descendant
			end
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- 4. ANIMAÇÕES DO CONFIG
--------------------------------------------------------------------------------
local function getAnimationsFromConfig(skinFolder)
	if not skinFolder then return nil end
	local configModule = skinFolder:FindFirstChild("Config")
	if not configModule then return nil end

	local anims = {}

	if configModule:IsA("ModuleScript") then
		local success, configData = pcall(require, configModule)
		if success and type(configData) == "table" then
			local sourceTable = configData.Animations or configData.Anims or configData.Animes or configData
			for key, val in pairs(sourceTable) do
				local keyLower = tostring(key):lower()
				if keyLower:find("idle") then anims.Idle = val
				elseif keyLower:find("walk") or keyLower:find("andar") then anims.Walk = val
				elseif keyLower:find("run") or keyLower:find("correr") or keyLower:find("sprint") then anims.Run = val
				end
			end
		end
	elseif configModule:IsA("Configuration") or configModule:IsA("Folder") then
		for _, child in ipairs(configModule:GetChildren()) do
			local nameLower = child.Name:lower()
			local val = (child:IsA("Animation") and child.AnimationId) or ((child:IsA("StringValue") or child:IsA("IntValue")) and child.Value) or nil
			if val then
				if nameLower:find("idle") then anims.Idle = val
				elseif nameLower:find("walk") then anims.Walk = val
				elseif nameLower:find("run") then anims.Run = val
				end
			end
		end
	end

	return anims
end

--------------------------------------------------------------------------------
-- 5. CONTROLE DE ANIMAÇÕES EM TEMPO REAL
--------------------------------------------------------------------------------
local function stopCurrentAnimations()
	if animConnection then
		animConnection:Disconnect()
		animConnection = nil
	end
	for _, track in pairs(currentAnimTracks) do
		if track then track:Stop() end
	end
	currentAnimTracks = {}
end

local function setupRigAnimations(rig, animsData, charHumanoid)
	if not animsData or not charHumanoid then return end

	local rigHumanoid = rig:FindFirstChildOfClass("Humanoid")
	local animator = nil

	if rigHumanoid then
		animator = rigHumanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", rigHumanoid)
	else
		local animController = rig:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController", rig)
		animator = animController:FindFirstChildOfClass("Animator") or Instance.new("Animator", animController)
	end

	local function loadAnim(idOrObj)
		if not idOrObj then return nil end
		local animObj
		if typeof(idOrObj) == "Instance" and idOrObj:IsA("Animation") then
			animObj = idOrObj
		else
			animObj = Instance.new("Animation")
			local animIdStr = tostring(idOrObj)
			if not animIdStr:find("rbxassetid://") and tonumber(animIdStr) then
				animIdStr = "rbxassetid://" .. animIdStr
			end
			animObj.AnimationId = animIdStr
		end
		
		local ok, track = pcall(function()
			return animator:LoadAnimation(animObj)
		end)
		return ok and track or nil
	end

	currentAnimTracks = {
		Idle = loadAnim(animsData.Idle),
		Walk = loadAnim(animsData.Walk),
		Run = loadAnim(animsData.Run)
	}

	local currentPlayingState = ""

	local function playState(state)
		if currentPlayingState == state then return end
		currentPlayingState = state

		for name, track in pairs(currentAnimTracks) do
			if name == state then
				if not track.IsPlaying then track:Play(0.2) end
			else
				if track.IsPlaying then track:Stop(0.2) end
			end
		end
	end

	animConnection = RunService.RenderStepped:Connect(function()
		if not rig or not rig.Parent or not charHumanoid or not charHumanoid.Parent then
			stopCurrentAnimations()
			return
		end

		local speed = charHumanoid.RootPart and charHumanoid.RootPart.AssemblyLinearVelocity.Magnitude or 0
		if speed < 0.5 then
			if currentAnimTracks.Idle then playState("Idle") end
		elseif speed > 16 then
			if currentAnimTracks.Run then playState("Run") else playState("Walk") end
		else
			if currentAnimTracks.Walk then playState("Walk") end
		end
	end)
end

--------------------------------------------------------------------------------
-- 6. ATUALIZAÇÃO E APLICAÇÃO DO RIG
--------------------------------------------------------------------------------
local function removeCurrentRig()
	stopCurrentAnimations()
	if currentVisualRig then
		currentVisualRig:Destroy()
		currentVisualRig = nil
	end
end

local function highlightContainer(container)
	if currentSelectedContainer and currentSelectedContainer:FindFirstChild("GreenSelectionBorder") then
		currentSelectedContainer.GreenSelectionBorder:Destroy()
	end

	currentSelectedContainer = container

	if container then
		local stroke = Instance.new("UIStroke")
		stroke.Name = "GreenSelectionBorder"
		stroke.Color = Color3.fromRGB(0, 255, 0)
		stroke.Thickness = 3
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = container
	end
end

local function updateRigState()
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") or not selectedSkinName then
		removeCurrentRig()
		return
	end

	local skinFolder = findSkinFolder(selectedSkinName)
	
	if not skinFolder or not skinMatchesCurrentCharacter(skinFolder, character) then
		removeCurrentRig()
		return
	end

	local charHumanoid = character:FindFirstChildOfClass("Humanoid")
	local rigTemplate = findRigModel(selectedSkinName)
	if not rigTemplate then return end

	-- 1. Destrói rigs antigos, limpa e TORNA O CORPO ORIGINAL INVISÍVEL
	removeCurrentRig()
	removeModelsFromCharacter(character)
	clearOriginalAppearance(character)

	-- 2. Clona e insere a skin visual
	local rig = rigTemplate:Clone()
	rig.Name = "VisualRig_" .. selectedSkinName

	local rigHumanoid = rig:FindFirstChildOfClass("Humanoid")
	if rigHumanoid then
		pcall(function() rigHumanoid.EvaluateStateMachine = false end)
		rigHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	for _, part in ipairs(rig:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.Massless = true
		end
	end

	local charHRP = character:FindFirstChild("HumanoidRootPart")
	if rig.PrimaryPart then
		rig:SetPrimaryPartCFrame(charHRP.CFrame)
	else
		rig:PivotTo(charHRP.CFrame)
	end

	for _, rigPart in ipairs(rig:GetDescendants()) do
		if rigPart:IsA("BasePart") then
			local charPart = character:FindFirstChild(rigPart.Name)
			if charPart and charPart:IsA("BasePart") then
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = charPart
				weld.Part1 = rigPart
				weld.Parent = rigPart
			end
		end
	end

	rig.Parent = character
	currentVisualRig = rig

	local animsData = getAnimationsFromConfig(skinFolder)
	if animsData then
		setupRigAnimations(rig, animsData, charHumanoid)
	end
end

--------------------------------------------------------------------------------
-- 7. EVENTOS DE INTERFACE E MONITORAMENTO
--------------------------------------------------------------------------------
local function connectFrame(skinFrame)
	local container = skinFrame:FindFirstChild("Container")
	if not container then return end

	local interactBtn = container:FindFirstChild("Interact")
	if interactBtn and interactBtn:IsA("GuiButton") then
		interactBtn.MouseButton1Click:Connect(function()
			local cleanName = skinFrame.Name:gsub("^!", "")
			local skinIntValue = purchasedSkins:FindFirstChild(cleanName) or purchasedSkins:FindFirstChild(skinFrame.Name)

			if skinIntValue then
				highlightContainer(container)
				selectedSkinName = skinFrame.Name
				updateRigState()
			end
		end)
	end
end

for _, child in ipairs(skinsContainer:GetChildren()) do
	if child:IsA("GuiObject") then
		connectFrame(child)
	end
end

skinsContainer.ChildAdded:Connect(function(child)
	if child:IsA("GuiObject") then
		task.wait(0.1)
		connectFrame(child)
	end
end)

localPlayer.CharacterAdded:Connect(function(newCharacter)
	task.wait(0.5)
	updateRigState()

	newCharacter:GetPropertyChangedSignal("Name"):Connect(function()
		task.wait(0.2)
		updateRigState()
	end)
end)

if localPlayer.Character then
	localPlayer.Character:GetPropertyChangedSignal("Name"):Connect(function()
		task.wait(0.2)
		updateRigState()
	end)
end
