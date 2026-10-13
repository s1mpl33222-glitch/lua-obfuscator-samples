local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

pcall(function()
	if debug and debug.info then
		local oldDebugInfo = debug.info
		debug.info = newcclosure(function(f, ...)
			local ok, result = pcall(oldDebugInfo, f, ...)
			if ok then
				if type(result) == "string" and result:find("C") then return "Lua" end
				return result
			end
			return "Lua"
		end)
	end
	if getgc then
		local oldGetGC = getgc
		getgc = newcclosure(function(...)
			local ok, result = pcall(oldGetGC, ...)
			if ok and type(result) == "table" then
				local filtered = {}
				for _, v in ipairs(result) do
					if type(v) ~= "function" then table.insert(filtered, v) end
				end
				return filtered
			end
			return result or {}
		end)
	end
	if checkcaller then
		local oldCheckCaller = checkcaller
		checkcaller = newcclosure(function(...)
			local ok, result = pcall(oldCheckCaller, ...)
			if ok then return result end
			return false
		end)
	end
end)

print("[Kenji] Detection bypassed")

local Settings = {
	Enabled = true,
	InfiniteAmmo = true,
	NoReload = true,
	AutoAim = true,
	SuperLock = false,
	SuperLockFOV = 9999,
	RateOfFire = 1,
	FireDelay = 0.05,
	FOVRadius = 9999,
	IgnoreTeam = true,
	Prediction = true,
	PredictionAmount = 0.15,
	BigHead = false,
	BigHeadSize = 4,
	BigHeadTransparency = 0.3,
	BigHeadColor = Color3.fromRGB(255, 255, 255),
	SilentAim = false,
	SilentAimHitChance = 100,
	SilentAimWallbang = true,
	SilentAimFOVRadius = 9999,
	SilentAimFOVVisible = true,
	SilentAimTargetPart = "Head",
	SilentAimPrediction = 0.15,
	NoRecoil = true,
	SpreadBullets = false,
	SpreadBulletAmount = 5,
	SpreadBulletCount = 5,
	AimAssist = false,
	AimAssistStrength = 0.35,
	AimAssistFOVRadius = 200,
	AimAssistVisible = true,
	MagicBullet = false,
	OneTapKill = false,
	Fly = false,
	FlySpeed = 100,
	ESP = false,
	ESPTracers = true,
	ESPTracerColor = Color3.fromRGB(255, 255, 255),
	ESPName = true,
	ESPNameColor = Color3.fromRGB(255, 255, 0),
	ESPHealth = true,
	ESPHealthColor = Color3.fromRGB(0, 255, 0),
	ESPDistance = true,
	ESPDistanceColor = Color3.fromRGB(200, 200, 200)
}

local lastFire = 0
local lockedTarget = nil
local silentAimTarget = nil
local aimAssistTarget = nil
local bigheadConns = {}
local activeTab = "Main"
local tabs = {}
local pages = {}
local flyActive = false
local flyBV, flyBG
local mobileFlyGui
local moveDirection = Vector3.zero
local character, humanoid, rootPart
local espData = {}
local tracerLines = {}
local oneTapKill = false

local Blaster = ReplicatedStorage:WaitForChild("Blaster", 10)
if not Blaster then warn("[Kenji] Walang Blaster.") return end
local Remotes = Blaster:WaitForChild("Remotes", 10)
if not Remotes then warn("[Kenji] Walang Remotes.") return end
local Shoot = Remotes:WaitForChild("Shoot", 10)
if not Shoot then warn("[Kenji] Walang Shoot.") return end

local function getTool()
	local char = player.Character
	if not char then return nil end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool and tool.Name == "SP" then return tool end
	return tool
end

local function isTeammate(plr)
	if not Settings.IgnoreTeam then return false end
	if not plr.Team or not player.Team then return false end
	return plr.Team == player.Team
end

-- AMMO / RELOAD / RECOIL
local function setInfiniteAmmoAndBullets()
	local tool = getTool()
	if not tool then return end
	for _, obj in ipairs(tool:GetDescendants()) do
		if obj:IsA("IntValue") or obj:IsA("NumberValue") then
			local name = obj.Name:lower()
			if name:find("ammo") or name:find("bullet") or name:find("mag") or name:find("clip") or name:find("currentammo") or name:find("reserve") or name:find("count") or name:find("loaded") or name:find("stock") then
				obj.Value = math.huge
			end
		end
		for attrName, _ in pairs(obj:GetAttributes()) do
			local lname = attrName:lower()
			if lname:find("ammo") or lname:find("bullet") or lname:find("mag") or lname:find("clip") or lname:find("count") or lname:find("loaded") then
				pcall(function() obj:SetAttribute(attrName, math.huge) end)
			end
		end
	end
	for attrName, _ in pairs(tool:GetAttributes()) do
		local lname = attrName:lower()
		if lname:find("ammo") or lname:find("bullet") or lname:find("mag") or lname:find("clip") or lname:find("count") or lname:find("loaded") then
			pcall(function() tool:SetAttribute(attrName, math.huge) end)
		end
	end
	if tool:GetAttribute("rateOfFire") ~= nil then
		tool:SetAttribute("rateOfFire", Settings.RateOfFire)
	end
end

local function applyNoRecoil()
	local tool = getTool()
	if not tool then return end
	for _, obj in ipairs(tool:GetDescendants()) do
		if obj:IsA("IntValue") or obj:IsA("NumberValue") then
			local name = obj.Name:lower()
			if Settings.NoRecoil and (name:find("recoil") or name:find("kick")) then
				obj.Value = 0
			end
		end
	end
end

local function disableReload()
	local tool = getTool()
	if not tool then return end
	for _, obj in ipairs(tool:GetDescendants()) do
		local name = obj.Name:lower()
		if name == "reload" or name == "reloadtime" then
			if obj:IsA("BoolValue") then obj.Value = false
			elseif obj:IsA("NumberValue") or obj:IsA("IntValue") then obj.Value = 0 end
		end
	end
end

-- BIG HEAD
local function applyBigHead(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local size = Settings.BigHeadSize
	local headShape = head:FindFirstChild("HeadShape")
	if headShape then headShape:Destroy() end
	head.Size = Vector3.new(size, size, size)
	head.Color = Settings.BigHeadColor
	head.Material = Enum.Material.Neon
	head.Transparency = Settings.BigHeadTransparency
	head.CanCollide = false
	head.Massless = true
	local newShape = Instance.new("SpecialMesh")
	newShape.Name = "HeadShape"
	newShape.MeshType = Enum.MeshType.Head
	newShape.Scale = Vector3.new(size / 2, size / 2, size / 2)
	newShape.Parent = head
end

local function resetBigHead(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local headShape = head:FindFirstChild("HeadShape")
	if headShape then headShape:Destroy() end
	head.Size = Vector3.new(2, 1, 1)
	head.Transparency = 1
	head.CanCollide = true
	head.Material = Enum.Material.Plastic
end

local function enableBigHead()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			applyBigHead(plr)
			local c = plr.CharacterAdded:Connect(function()
				task.wait(0.5)
				if Settings.BigHead then applyBigHead(plr) end
			end)
			table.insert(bigheadConns, c)
		end
	end
end

local function disableBigHead()
	for _, c in ipairs(bigheadConns) do
		if c.Disconnect then c:Disconnect() end
	end
	bigheadConns = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		resetBigHead(plr)
	end
end

-- ESP
local function createESP(plr)
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not head or not hum then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "KenjiESP"
	billboard.Size = UDim2.new(0, 200, 0, 70)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Name = "NameLbl"
	nameLbl.Size = UDim2.new(1, 0, 0, 16)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = plr.Name
	nameLbl.Font = Enum.Font.Arcade
	nameLbl.TextSize = 14
	nameLbl.TextColor3 = Settings.ESPNameColor
	nameLbl.TextStrokeTransparency = 0
	nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLbl.Parent = billboard

	local healthBg = Instance.new("Frame")
	healthBg.Name = "HealthBg"
	healthBg.Size = UDim2.new(1, -40, 0, 6)
	healthBg.Position = UDim2.new(0, 20, 0, 18)
	healthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	healthBg.BorderSizePixel = 0
	healthBg.Parent = billboard
	local hbCorner = Instance.new("UICorner")
	hbCorner.CornerRadius = UDim.new(1, 0)
	hbCorner.Parent = healthBg

	local healthFill = Instance.new("Frame")
	healthFill.Name = "HealthFill"
	healthFill.Size = UDim2.new(1, 0, 1, 0)
	healthFill.BackgroundColor3 = Settings.ESPHealthColor
	healthFill.BorderSizePixel = 0
	healthFill.Parent = healthBg
	local hfCorner = Instance.new("UICorner")
	hfCorner.CornerRadius = UDim.new(1, 0)
	hfCorner.Parent = healthFill

	local distLbl = Instance.new("TextLabel")
	distLbl.Name = "DistLbl"
	distLbl.Size = UDim2.new(1, 0, 0, 14)
	distLbl.Position = UDim2.new(0, 0, 0, 26)
	distLbl.BackgroundTransparency = 1
	distLbl.Text = "0m"
	distLbl.Font = Enum.Font.Arcade
	distLbl.TextSize = 12
	distLbl.TextColor3 = Settings.ESPDistanceColor
	distLbl.TextStrokeTransparency = 0
	distLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	distLbl.Parent = billboard

	espData[plr] = {billboard = billboard, nameLbl = nameLbl, healthBg = healthBg, healthFill = healthFill, distLbl = distLbl, hum = hum}
end

local function removeESP(plr)
	if espData[plr] then
		if espData[plr].billboard then espData[plr].billboard:Destroy() end
		espData[plr] = nil
	end
	if tracerLines[plr] then
		tracerLines[plr]:Remove()
		tracerLines[plr] = nil
	end
end

Players.PlayerRemoving:Connect(removeESP)

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= player then
		plr.CharacterAdded:Connect(function()
			task.wait(1)
			if Settings.ESP then createESP(plr) end
		end)
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if Settings.ESP then createESP(plr) end
	end)
end)

-- TARGETING
local function predictPos(part)
	if not part or not part.Parent then return part and part.Position or nil end
	local predTime = tonumber(Settings.SilentAimPrediction) or 0
	if predTime <= 0 then return part.Position end
	local ok, vel = pcall(function() return part.Velocity end)
	if not ok or not vel then vel = Vector3.new(0, 0, 0) end
	return part.Position + (vel * math.clamp(predTime, 0, 0.5))
end

local function getClosestTarget(fov)
	local closest = nil
	local shortest = fov or Settings.FOVRadius
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		if isTeammate(plr) then continue end
		local char = plr.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 then continue end
		local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
		if not onScreen then continue end
		local dist = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
		if dist < shortest then shortest = dist; closest = head end
	end
	return closest
end

local function getSilentAimTarget()
	local closest = nil
	local shortest = math.huge
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		if isTeammate(plr) then continue end
		local char = plr.Character
		if not char then continue end
		local part = char:FindFirstChild(Settings.SilentAimTargetPart) or char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not part or not hum or hum.Health <= 0 then continue end

		if not Settings.SilentAimWallbang then
			local myChar = player.Character
			if myChar then
				local castPoints = {part.Position, myChar, char}
				local ignore = {myChar, char}
				if #Camera:GetPartsObscuringTarget(castPoints, ignore) > 0 then
					continue
				end
			end
		end

		local predicted = predictPos(part)
		local screenPos, onScreen = Camera:WorldToViewportPoint(predicted)
		if not onScreen then continue end
		local dist = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
		if dist < shortest then shortest = dist; closest = part end
	end
	return closest
end

local function getAimAssistTarget()
	local closest = nil
	local shortest = Settings.AimAssistFOVRadius
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		if isTeammate(plr) then continue end
		local char = plr.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 then continue end
		local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
		if not onScreen then continue end
		local dist = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
		if dist < shortest then shortest = dist; closest = head end
	end
	return closest
end

-- FIRE
local function fire()
	if not Settings.Enabled then return end
	local now = tick()
	if now - lastFire < Settings.FireDelay then return end
	lastFire = now
	local tool = getTool()
	if not tool or tool.Parent ~= player.Character then return end
	local origin = Camera.CFrame.Position
	local aimPos
	if Settings.SilentAim then
		local target = silentAimTarget or getSilentAimTarget()
		if target then
			aimPos = target.Position
			if Settings.Prediction and target.Velocity then aimPos = aimPos + (target.Velocity * Settings.PredictionAmount) end
		else aimPos = Camera.CFrame.LookVector * 1000 + origin end
	elseif Settings.AutoAim or Settings.SuperLock then
		local target = getClosestTarget(Settings.SuperLock and Settings.SuperLockFOV or Settings.FOVRadius)
		if target then
			aimPos = target.Position
			if Settings.Prediction and target.Velocity then aimPos = aimPos + (target.Velocity * Settings.PredictionAmount) end
		else aimPos = Camera.CFrame.LookVector * 1000 + origin end
	else aimPos = Camera.CFrame.LookVector * 1000 + origin end
	local dir = (aimPos - origin).Unit
	local cf = CFrame.new(origin, origin + dir)
	pcall(function()
		Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
	end)
	pcall(function() tool:Activate() end)
end

local function spreadBulletsFire()
	if not Settings.Enabled then return end
	local now = tick()
	if now - lastFire < Settings.FireDelay then return end
	lastFire = now
	local tool = getTool()
	if not tool or tool.Parent ~= player.Character then return end
	local origin = Camera.CFrame.Position
	local target = silentAimTarget or getSilentAimTarget()

	if Settings.SilentAimWallbang and target then
		local aimPos = target.Position
		if Settings.Prediction and target.Velocity then
			aimPos = aimPos + (target.Velocity * Settings.PredictionAmount)
		end
		local dir = (aimPos - origin).Unit
		local cf = CFrame.new(origin, origin + dir)
		pcall(function()
			Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
		end)
	else
		local baseDir = Camera.CFrame.LookVector
		for i = 1, Settings.SpreadBulletCount do
			local spreadRad = math.rad(Settings.SpreadBulletAmount)
			local randX = (math.random() - 0.5) * 2 * spreadRad
			local randY = (math.random() - 0.5) * 2 * spreadRad
			local rotated = CFrame.new(Vector3.zero, baseDir) * CFrame.Angles(randX, randY, 0)
			local dir = rotated.LookVector
			local cf = CFrame.new(origin, origin + dir)
			pcall(function()
				Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
			end)
		end
	end
	pcall(function() tool:Activate() end)
end

local function magicBulletFire()
	if not Settings.Enabled then return end
	local now = tick()
	if now - lastFire < Settings.FireDelay then return end
	lastFire = now
	local tool = getTool()
	if not tool or tool.Parent ~= player.Character then return end
	local origin = Camera.CFrame.Position
	local targets = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		if isTeammate(plr) then continue end
		local char = plr.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 then continue end
		table.insert(targets, head)
	end
	if #targets == 0 then
		local aimPos = Camera.CFrame.LookVector * 1000 + origin
		local dir = (aimPos - origin).Unit
		local cf = CFrame.new(origin, origin + dir)
		pcall(function()
			Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
		end)
	else
		for _, target in ipairs(targets) do
			local aimPos = target.Position
			if Settings.Prediction and target.Velocity then aimPos = aimPos + (target.Velocity * Settings.PredictionAmount) end
			local dir = (aimPos - origin).Unit
			local cf = CFrame.new(origin, origin + dir)
			pcall(function()
				Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
			end)
		end
	end
	pcall(function() tool:Activate() end)
end

local function oneTapKillFire()
	if not oneTapKill then return end
	local now = tick()
	if now - lastFire < Settings.FireDelay then return end
	lastFire = now
	local tool = getTool()
	if not tool or tool.Parent ~= player.Character then return end
	local origin = Camera.CFrame.Position
	local targets = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		if isTeammate(plr) then continue end
		local char = plr.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 then continue end
		table.insert(targets, head)
	end
	if #targets == 0 then return end
	for _, target in ipairs(targets) do
		local aimPos = target.Position
		if Settings.Prediction and target.Velocity then aimPos = aimPos + (target.Velocity * Settings.PredictionAmount) end
		local dir = (aimPos - origin).Unit
		local cf = CFrame.new(origin, origin + dir)
		pcall(function()
			Shoot:FireServer(table.unpack({[1] = tick(), [2] = tool, [3] = cf, [4] = {}}))
		end)
	end
	pcall(function() tool:Activate() end)
end

-- FLY
local function enableFly()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = hrp
	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	flyBG.P = 1000
	flyBG.D = 50
	flyBG.CFrame = hrp.CFrame
	flyBG.Parent = hrp
end

local function disableFly()
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	moveDirection = Vector3.zero
end

local function createMobileFlyGui()
	if mobileFlyGui then mobileFlyGui:Destroy() end
	mobileFlyGui = Instance.new("ScreenGui")
	mobileFlyGui.Name = "KenjiMobileFly"
	mobileFlyGui.ResetOnSpawn = false
	mobileFlyGui.DisplayOrder = 999999
	mobileFlyGui.IgnoreGuiInset = true
	mobileFlyGui.Parent = player:WaitForChild("PlayerGui")

	local function makeBtn(text, x, y, size)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, size, 0, size)
		btn.Position = UDim2.new(0, x, 0, y)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundTransparency = 0.3
		btn.Text = text
		btn.Font = Enum.Font.Arcade
		btn.TextSize = 20
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = false
		btn.Active = true
		btn.Selectable = true
		btn.Parent = mobileFlyGui
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = btn
		local bs = Instance.new("UIStroke")
		bs.Thickness = 2
		bs.Color = Color3.fromRGB(255, 255, 255)
		bs.Parent = btn
		return btn
	end

	local upBtn = makeBtn("↑", 60, 200, 50)
	local downBtn = makeBtn("↓", 60, 320, 50)
	local leftBtn = makeBtn("←", 0, 260, 50)
	local rightBtn = makeBtn("→", 120, 260, 50)
	local forwardBtn = makeBtn("W", 200, 260, 50)
	local backBtn = makeBtn("S", 200, 320, 50)

	local function bindBtn(btn, dir)
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				moveDirection = moveDirection + dir
			end
		end)
		btn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				moveDirection = moveDirection - dir
			end
		end)
	end

	bindBtn(upBtn, Vector3.new(0, 1, 0))
	bindBtn(downBtn, Vector3.new(0, -1, 0))
	bindBtn(leftBtn, Vector3.new(-1, 0, 0))
	bindBtn(rightBtn, Vector3.new(1, 0, 0))
	bindBtn(forwardBtn, Vector3.new(0, 0, -1))
	bindBtn(backBtn, Vector3.new(0, 0, 1))

	mobileFlyGui.Enabled = true
end

-- LOOPS
RunService.Heartbeat:Connect(function()
	if Settings.InfiniteAmmo then setInfiniteAmmoAndBullets() end
	if Settings.NoReload then disableReload() end
	if Settings.NoRecoil then applyNoRecoil() end
	local tool = getTool()
	if tool and tool:GetAttribute("rateOfFire") ~= nil and tool:GetAttribute("rateOfFire") ~= Settings.RateOfFire then
		tool:SetAttribute("rateOfFire", Settings.RateOfFire)
	end
end)

RunService.RenderStepped:Connect(function()
	if Settings.SilentAim then silentAimTarget = getSilentAimTarget() end

	if Settings.Fly and flyActive then
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local finalDir = moveDirection
		if finalDir.Magnitude > 0 then finalDir = finalDir.Unit * Settings.FlySpeed end
		if flyBV then flyBV.Velocity = finalDir end
		if flyBG then flyBG.CFrame = Camera.CFrame end
	end

	if Settings.SuperLock then
		local target = getClosestTarget(Settings.SuperLockFOV)
		if target then lockedTarget = target end
		if lockedTarget then
			local hum = lockedTarget.Parent and lockedTarget.Parent:FindFirstChildOfClass("Humanoid")
			if not hum or hum.Health <= 0 then
				lockedTarget = nil
			else
				local aimPos = lockedTarget.Position
				if Settings.Prediction and lockedTarget.Velocity then aimPos = aimPos + (lockedTarget.Velocity * Settings.PredictionAmount) end
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
			end
		end
	else lockedTarget = nil end

	if Settings.AimAssist and not Settings.SuperLock and not Settings.SilentAim then
		local target = getAimAssistTarget()
		if target then
			aimAssistTarget = target
			local aimPos = target.Position
			if Settings.Prediction and target.Velocity then aimPos = aimPos + (target.Velocity * Settings.PredictionAmount) end
			local desired = CFrame.new(Camera.CFrame.Position, aimPos)
			Camera.CFrame = Camera.CFrame:Lerp(desired, Settings.AimAssistStrength)
		else aimAssistTarget = nil end
	else aimAssistTarget = nil end

	if Settings.ESP then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr == player then continue end
			local char = plr.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local head = char and char:FindFirstChild("Head")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if char and hum and hum.Health > 0 and head and hrp then
				if not espData[plr] then createESP(plr) end
				local data = espData[plr]
				if data then
					local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					local dist = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
					if data.nameLbl then
						data.nameLbl.Text = plr.Name
						data.nameLbl.TextColor3 = Settings.ESPNameColor
						data.nameLbl.Visible = Settings.ESPName
					end
					if data.healthFill then
						data.healthFill.Size = UDim2.new(math.clamp(hum.Health / hum.MaxHealth, 0, 1), 0, 1, 0)
						data.healthFill.BackgroundColor3 = Settings.ESPHealthColor
						if data.healthBg then data.healthBg.Visible = Settings.ESPHealth end
					end
					if data.distLbl then
						data.distLbl.Text = tostring(dist) .. "m"
						data.distLbl.TextColor3 = Settings.ESPDistanceColor
						data.distLbl.Visible = Settings.ESPDistance
					end
					if Settings.ESPTracers and myHrp then
						if not tracerLines[plr] then
							tracerLines[plr] = Drawing.new("Line")
							tracerLines[plr].Thickness = 1.5
							tracerLines[plr].Visible = false
						end
						local line = tracerLines[plr]
						local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
						if onScreen then
							line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
							line.To = Vector2.new(headPos.X, headPos.Y)
							line.Color = Settings.ESPTracerColor
							line.Visible = true
						else line.Visible = false end
					elseif tracerLines[plr] then tracerLines[plr].Visible = false end
				end
			else
				if espData[plr] then removeESP(plr) end
			end
		end
	else
		for _, plr in ipairs(Players:GetPlayers()) do
			if espData[plr] then removeESP(plr) end
		end
		for _, line in pairs(tracerLines) do line.Visible = false end
	end
end)

player.CharacterAdded:Connect(function()
	flyActive = false
	if Settings.Fly then
		task.wait(0.5)
		enableFly()
		flyActive = true
	end
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		task.spawn(function()
			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and Settings.Enabled do
				if oneTapKill then
					oneTapKillFire()
				elseif Settings.SpreadBullets then
					spreadBulletsFire()
				elseif Settings.MagicBullet then
					magicBulletFire()
				else
					fire()
				end
				task.wait(0.005)
			end
		end)
	end
end)

-- FOV CIRCLES
local superCircle = Drawing.new("Circle")
superCircle.Thickness = 2
superCircle.NumSides = 120
superCircle.Radius = Settings.SuperLockFOV
superCircle.Filled = false
superCircle.Visible = false
superCircle.ZIndex = 999
superCircle.Transparency = 0.8
superCircle.Color = Color3.fromRGB(255, 255, 255)

local silentCircle = Drawing.new("Circle")
silentCircle.Thickness = 2
silentCircle.NumSides = 120
silentCircle.Radius = Settings.SilentAimFOVRadius
silentCircle.Filled = false
silentCircle.Visible = false
silentCircle.ZIndex = 998
silentCircle.Transparency = 0.8
silentCircle.Color = Color3.fromRGB(200, 200, 200)

local aimAssistCircle = Drawing.new("Circle")
aimAssistCircle.Thickness = 2
aimAssistCircle.NumSides = 120
aimAssistCircle.Radius = Settings.AimAssistFOVRadius
aimAssistCircle.Filled = false
aimAssistCircle.Visible = false
aimAssistCircle.ZIndex = 997
aimAssistCircle.Transparency = 0.8
aimAssistCircle.Color = Color3.fromRGB(150, 220, 255)

RunService.RenderStepped:Connect(function()
	superCircle.Visible = Settings.SuperLock
	superCircle.Radius = Settings.SuperLockFOV
	superCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	silentCircle.Visible = Settings.SilentAim and Settings.SilentAimFOVVisible
	silentCircle.Radius = Settings.SilentAimFOVRadius
	silentCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	aimAssistCircle.Visible = Settings.AimAssist and Settings.AimAssistVisible
	aimAssistCircle.Radius = Settings.AimAssistFOVRadius
	aimAssistCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- ANIMATED LOADING MENU
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "KenjiLoading"
loadingGui.ResetOnSpawn = false
loadingGui.DisplayOrder = 9999999
loadingGui.IgnoreGuiInset = true
loadingGui.Parent = player:WaitForChild("PlayerGui")

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 350, 0, 200)
loadingFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadingGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 20)
loadingCorner.Parent = loadingFrame

local loadingStroke = Instance.new("UIStroke")
loadingStroke.Thickness = 3
loadingStroke.Color = Color3.fromRGB(255, 255, 255)
loadingStroke.Parent = loadingFrame

local loadingBg = Instance.new("ImageLabel")
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.Position = UDim2.new(0, 0, 0, 0)
loadingBg.BackgroundTransparency = 1
loadingBg.Image = "rbxassetid://140085847824583"
loadingBg.ScaleType = Enum.ScaleType.Crop
loadingBg.ImageTransparency = 0.3
loadingBg.ZIndex = 0
loadingBg.Parent = loadingFrame
local loadingBgCorner = Instance.new("UICorner")
loadingBgCorner.CornerRadius = UDim.new(0, 20)
loadingBgCorner.Parent = loadingBg

local loadingOverlay = Instance.new("Frame")
loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
loadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingOverlay.BackgroundTransparency = 0.5
loadingOverlay.BorderSizePixel = 0
loadingOverlay.ZIndex = 1
loadingOverlay.Parent = loadingFrame
local loadingOverlayCorner = Instance.new("UICorner")
loadingOverlayCorner.CornerRadius = UDim.new(0, 20)
loadingOverlayCorner.Parent = loadingOverlay

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, -20, 0, 50)
loadingTitle.Position = UDim2.new(0, 10, 0, 20)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "KENJI HUB"
loadingTitle.Font = Enum.Font.Arcade
loadingTitle.TextSize = 36
loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.TextStrokeTransparency = 0
loadingTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
loadingTitle.ZIndex = 2
loadingTitle.Parent = loadingFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
}
titleGradient.Parent = loadingTitle

local titleTween = TweenService:Create(titleGradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
	Rotation = 180
})
titleTween:Play()

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0.8, 0, 0, 25)
loadingBar.Position = UDim2.new(0.1, 0, 0, 100)
loadingBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingBar.BackgroundTransparency = 0.3
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 2
loadingBar.Parent = loadingFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 12)
loadingBarCorner.Parent = loadingBar

local loadingFill = Instance.new("Frame")
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
loadingFill.BorderSizePixel = 0
loadingFill.ZIndex = 3
loadingFill.Parent = loadingBar

local loadingFillCorner = Instance.new("UICorner")
loadingFillCorner.CornerRadius = UDim.new(0, 12)
loadingFillCorner.Parent = loadingFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
}
fillGradient.Parent = loadingFill

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -20, 0, 25)
loadingText.Position = UDim2.new(0, 10, 0, 140)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading... 0%"
loadingText.Font = Enum.Font.Arcade
loadingText.TextSize = 16
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextStrokeTransparency = 0
loadingText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
loadingText.ZIndex = 2
loadingText.Parent = loadingFrame

local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 20, 0, 20)
spinner.Position = UDim2.new(1, -35, 0, 15)
spinner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
spinner.BorderSizePixel = 0
spinner.ZIndex = 2
spinner.Parent = loadingFrame
local spinnerCorner = Instance.new("UICorner")
spinnerCorner.CornerRadius = UDim.new(1, 0)
spinnerCorner.Parent = spinner

local spinnerStroke = Instance.new("UIStroke")
spinnerStroke.Thickness = 2
spinnerStroke.Color = Color3.fromRGB(255, 50, 50)
spinnerStroke.Transparency = 0.3
spinnerStroke.Parent = spinner

local loadingTween = TweenService:Create(loadingFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, 0, 1, 0)
})
loadingTween:Play()

task.spawn(function()
	for i = 0, 100 do
		loadingText.Text = "Loading... " .. i .. "%"
		task.wait(0.025)
	end
end)

local spinnerRotation = 0
local spinnerAnim = RunService.RenderStepped:Connect(function()
	spinnerRotation = spinnerRotation + 5
	spinner.Rotation = spinnerRotation
	loadingStroke.Transparency = 0.3 + math.sin(tick() * 3) * 0.3
end)

task.delay(2.7, function()
	spinnerAnim:Disconnect()
	local fadeOut = TweenService:Create(loadingFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	fadeOut:Play()
	fadeOut.Completed:Connect(function()
		loadingGui:Destroy()
	end)
end)

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KenjiAledion"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 560, 0, 460)
frame.Position = UDim2.new(0.5, -280, 0.5, -230)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.ZIndex = 100
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 18)
frameCorner.Parent = frame

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://140085847824583"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.15
bgImage.ZIndex = 0
bgImage.Parent = frame

local bgImageCorner = Instance.new("UICorner")
bgImageCorner.CornerRadius = UDim.new(0, 18)
bgImageCorner.Parent = bgImage

local bgOverlay = Instance.new("Frame")
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgOverlay.BackgroundTransparency = 0.4
bgOverlay.BorderSizePixel = 0
bgOverlay.ZIndex = 1
bgOverlay.Parent = frame

local bgOverlayCorner = Instance.new("UICorner")
bgOverlayCorner.CornerRadius = UDim.new(0, 18)
bgOverlayCorner.Parent = bgOverlay

local frameStroke3D = Instance.new("UIStroke")
frameStroke3D.Thickness = 3
frameStroke3D.Color = Color3.fromRGB(255, 255, 255)
frameStroke3D.Transparency = 0.3
frameStroke3D.ZIndex = 102
frameStroke3D.Parent = frame

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadow.BackgroundTransparency = 0.85
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = frame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 24)
shadowCorner.Parent = shadow

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.BackgroundTransparency = 0.4
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.ZIndex = 101
titleBar.Parent = frame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 18)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 20)
titleBarFix.Position = UDim2.new(0, 0, 1, -20)
titleBarFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBarFix.BackgroundTransparency = 0.4
titleBarFix.BorderSizePixel = 0
titleBarFix.ZIndex = 101
titleBarFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -200, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KENJI HUB"
title.Font = Enum.Font.Arcade
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 102
title.Parent = titleBar

local dot1 = Instance.new("Frame")
dot1.Size = UDim2.new(0, 12, 0, 12)
dot1.Position = UDim2.new(0, 16, 0.5, -6)
dot1.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
dot1.BorderSizePixel = 0
dot1.ZIndex = 102
dot1.Parent = titleBar
local d1c = Instance.new("UICorner")
d1c.CornerRadius = UDim.new(1, 0)
d1c.Parent = dot1

local dot2 = Instance.new("Frame")
dot2.Size = UDim2.new(0, 12, 0, 12)
dot2.Position = UDim2.new(0, 32, 0.5, -6)
dot2.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
dot2.BorderSizePixel = 0
dot2.ZIndex = 102
dot2.Parent = titleBar
local d2c = Instance.new("UICorner")
d2c.CornerRadius = UDim.new(1, 0)
d2c.Parent = dot2

local dot3 = Instance.new("Frame")
dot3.Size = UDim2.new(0, 12, 0, 12)
dot3.Position = UDim2.new(0, 48, 0.5, -6)
dot3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
dot3.BorderSizePixel = 0
dot3.ZIndex = 102
dot3.Parent = titleBar
local d3c = Instance.new("UICorner")
d3c.CornerRadius = UDim.new(1, 0)
d3c.Parent = dot3

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 22)
minBtn.Position = UDim2.new(1, -72, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 0.7
minBtn.Text = "—"
minBtn.Font = Enum.Font.Arcade
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Active = true
minBtn.Selectable = true
minBtn.ZIndex = 103
minBtn.Parent = titleBar
local minC = Instance.new("UICorner")
minC.CornerRadius = UDim.new(0, 6)
minC.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -38, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.Arcade
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Active = true
closeBtn.Selectable = true
closeBtn.ZIndex = 103
closeBtn.Parent = titleBar
local closeC = Instance.new("UICorner")
closeC.CornerRadius = UDim.new(0, 6)
closeC.Parent = closeBtn

local dragging = false
local dragStart, startPos

local function startDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end

local function endDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(endDrag)
titleBar.InputBegan:Connect(startDrag)
titleBar.InputEnded:Connect(endDrag)

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -20, 0, 32)
tabBar.Position = UDim2.new(0, 10, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabBar.BackgroundTransparency = 0.4
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 101
tabBar.Parent = frame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 10)
tabBarCorner.Parent = tabBar

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 4)
tabList.VerticalAlignment = Enum.VerticalAlignment.Center
tabList.Parent = tabBar

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingLeft = UDim.new(0, 6)
tabPadding.Parent = tabBar

local function makeTab(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 118, 0, 24)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BackgroundTransparency = 0.5
	btn.Text = name
	btn.Font = Enum.Font.Arcade
	btn.TextSize = 11
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextStrokeTransparency = 0
	btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.ZIndex = 102
	btn.Parent = tabBar
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 6)
	bc.Parent = btn
	local bs = Instance.new("UIStroke")
	bs.Thickness = 2
	bs.Color = Color3.fromRGB(255, 255, 255)
	bs.Transparency = 1
	bs.Parent = btn

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = name .. "Page"
	scroll.Size = UDim2.new(1, -20, 1, -120)
	scroll.Position = UDim2.new(0, 10, 0, 90)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	scroll.ScrollBarImageTransparency = 0.3
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.ClipsDescendants = true
	scroll.ZIndex = 101
	scroll.Visible = false
	scroll.Parent = frame

	local scrollPadding = Instance.new("UIPadding")
	scrollPadding.PaddingTop = UDim.new(0, 10)
	scrollPadding.PaddingBottom = UDim.new(0, 10)
	scrollPadding.PaddingRight = UDim.new(0, 10)
	scrollPadding.Parent = scroll

	local leftCol = Instance.new("Frame")
	leftCol.Size = UDim2.new(0.5, -6, 0, 0)
	leftCol.Position = UDim2.new(0, 0, 0, 0)
	leftCol.BackgroundTransparency = 1
	leftCol.ZIndex = 102
	leftCol.Parent = scroll
	local leftLayout = Instance.new("UIListLayout")
	leftLayout.Padding = UDim.new(0, 8)
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Parent = leftCol

	local rightCol = Instance.new("Frame")
	rightCol.Size = UDim2.new(0.5, -6, 0, 0)
	rightCol.Position = UDim2.new(0.5, 6, 0, 0)
	rightCol.BackgroundTransparency = 1
	rightCol.ZIndex = 102
	rightCol.Parent = scroll
	local rightLayout = Instance.new("UIListLayout")
	rightLayout.Padding = UDim.new(0, 8)
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Parent = rightCol

	leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		leftCol.Size = UDim2.new(0.5, -6, 0, leftLayout.AbsoluteContentSize.Y)
	end)
	rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		rightCol.Size = UDim2.new(0.5, -6, 0, rightLayout.AbsoluteContentSize.Y)
	end)

	tabs[name] = {btn = btn, page = scroll, stroke = bs}
	pages[name] = {left = leftCol, right = rightCol}

	btn.MouseButton1Click:Connect(function()
		activeTab = name
		for n, p in pairs(tabs) do
			p.page.Visible = (n == name)
			TweenService:Create(p.btn, TweenInfo.new(0.25), {
				BackgroundColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30),
				TextColor3 = (n == name) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			}):Play()
			TweenService:Create(p.stroke, TweenInfo.new(0.25), {
				Transparency = (n == name) and 0 or 1
			}):Play()
		end
	end)
	return leftCol, leftLayout, rightCol, rightLayout
end

local function makeToggleBtn(parent, text, default, layoutOrder, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 32)
	holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	holder.BackgroundTransparency = 0.4
	holder.BorderSizePixel = 0
	holder.LayoutOrder = layoutOrder
	holder.Active = true
	holder.ZIndex = 102
	holder.Parent = parent
	local hc = Instance.new("UICorner")
	hc.CornerRadius = UDim.new(0, 10)
	hc.Parent = holder
	local hs = Instance.new("UIStroke")
	hs.Thickness = 2
	hs.Color = Color3.fromRGB(255, 255, 255)
	hs.Transparency = 0.7
	hs.Parent = holder

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -60, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.Font = Enum.Font.Arcade
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 103
	lbl.Parent = holder

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 40, 0, 20)
	indicator.Position = UDim2.new(1, -50, 0.5, -10)
	indicator.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
	indicator.BorderSizePixel = 0
	indicator.ZIndex = 103
	indicator.Parent = holder
	local ic = Instance.new("UICorner")
	ic.CornerRadius = UDim.new(1, 0)
	ic.Parent = indicator

	local stateLbl = Instance.new("TextLabel")
	stateLbl.Size = UDim2.new(1, 0, 1, 0)
	stateLbl.BackgroundTransparency = 1
	stateLbl.Text = default and "ON" or "OFF"
	stateLbl.Font = Enum.Font.Arcade
	stateLbl.TextSize = 10
	stateLbl.TextColor3 = default and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)
	stateLbl.ZIndex = 104
	stateLbl.Parent = indicator

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Active = true
	btn.Selectable = true
	btn.ZIndex = 105
	btn.Parent = holder

	btn.MouseButton1Click:Connect(function()
		local v = not default
		default = v
		TweenService:Create(indicator, TweenInfo.new(0.25), {
			BackgroundColor3 = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
		}):Play()
		stateLbl.Text = v and "ON" or "OFF"
		stateLbl.TextColor3 = v and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)
		if callback then callback(v) end
	end)
	holder.InputBegan:Connect(startDrag)
	holder.InputEnded:Connect(endDrag)
	return holder
end

local function makeSliderBtn(parent, text, default, minV, maxV, step, layoutOrder, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 48)
	holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	holder.BackgroundTransparency = 0.4
	holder.BorderSizePixel = 0
	holder.LayoutOrder = layoutOrder
	holder.ZIndex = 102
	holder.Parent = parent
	local hc = Instance.new("UICorner")
	hc.CornerRadius = UDim.new(0, 10)
	hc.Parent = holder
	local hs = Instance.new("UIStroke")
	hs.Thickness = 2
	hs.Color = Color3.fromRGB(255, 255, 255)
	hs.Transparency = 0.7
	hs.Parent = holder

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -20, 0, 16)
	lbl.Position = UDim2.new(0, 14, 0, 4)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.Font = Enum.Font.Arcade
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 103
	lbl.Parent = holder

	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.new(0, 70, 0, 16)
	valLbl.Position = UDim2.new(1, -84, 0, 4)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = string.format("%.0f", default)
	valLbl.Font = Enum.Font.Arcade
	valLbl.TextSize = 11
	valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	valLbl.TextStrokeTransparency = 0
	valLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.ZIndex = 103
	valLbl.Parent = holder

	local minusBtn = Instance.new("TextButton")
	minusBtn.Size = UDim2.new(0, 60, 0, 20)
	minusBtn.Position = UDim2.new(0, 14, 0, 24)
	minusBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	minusBtn.BackgroundTransparency = 0.7
	minusBtn.Text = "−"
	minusBtn.Font = Enum.Font.Arcade
	minusBtn.TextSize = 16
	minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	minusBtn.BorderSizePixel = 0
	minusBtn.AutoButtonColor = false
	minusBtn.Active = true
	minusBtn.Selectable = true
	minusBtn.ZIndex = 103
	minusBtn.Parent = holder
	local mc = Instance.new("UICorner")
	mc.CornerRadius = UDim.new(0, 6)
	mc.Parent = minusBtn

	local plusBtn = Instance.new("TextButton")
	plusBtn.Size = UDim2.new(0, 60, 0, 20)
	plusBtn.Position = UDim2.new(0, 78, 0, 24)
	plusBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	plusBtn.BackgroundTransparency = 0.7
	plusBtn.Text = "+"
	plusBtn.Font = Enum.Font.Arcade
	plusBtn.TextSize = 16
	plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	plusBtn.BorderSizePixel = 0
	plusBtn.AutoButtonColor = false
	plusBtn.Active = true
	plusBtn.Selectable = true
	plusBtn.ZIndex = 103
	plusBtn.Parent = holder
	local pc = Instance.new("UICorner")
	pc.CornerRadius = UDim.new(0, 6)
	pc.Parent = plusBtn

	local value = default
	minusBtn.MouseButton1Click:Connect(function()
		value = math.max(minV, value - step)
		valLbl.Text = string.format("%.0f", value)
		if callback then callback(value) end
	end)
	plusBtn.MouseButton1Click:Connect(function()
		value = math.min(maxV, value + step)
		valLbl.Text = string.format("%.0f", value)
		if callback then callback(value) end
	end)
	holder.InputBegan:Connect(startDrag)
	holder.InputEnded:Connect(endDrag)
	return holder
end

local mainL, mainLL, mainR, mainRL = makeTab("Main", 1)
local silentL, silentLL, silentR, silentRL = makeTab("Silent Aim", 2)
local visualsL, visualsLL, visualsR, visualsRL = makeTab("Visuals", 3)
local settingsL, settingsLL, settingsR, settingsRL = makeTab("Settings", 4)

-- MAIN
makeToggleBtn(mainL, "Rapid Fire", Settings.Enabled, 1, function(v) Settings.Enabled = v end)
makeToggleBtn(mainL, "Inf Ammo + Bullets", Settings.InfiniteAmmo, 2, function(v) Settings.InfiniteAmmo = v end)
makeToggleBtn(mainL, "No Reload", Settings.NoReload, 3, function(v) Settings.NoReload = v end)
makeToggleBtn(mainL, "Auto Aim", Settings.AutoAim, 4, function(v) Settings.AutoAim = v end)
makeToggleBtn(mainL, "Super Lock", Settings.SuperLock, 5, function(v) Settings.SuperLock = v end)
makeToggleBtn(mainL, "No Recoil", Settings.NoRecoil, 6, function(v) Settings.NoRecoil = v end)
makeToggleBtn(mainL, "Spread Bullets", Settings.SpreadBullets, 7, function(v) Settings.SpreadBullets = v end)
makeToggleBtn(mainL, "Fly (Mobile)", Settings.Fly, 8, function(v)
	Settings.Fly = v
	if v then
		flyActive = true
		enableFly()
		createMobileFlyGui()
	else
		flyActive = false
		disableFly()
		if mobileFlyGui then mobileFlyGui:Destroy() mobileFlyGui = nil end
	end
end)
makeToggleBtn(mainL, "One Tap Kill", Settings.OneTapKill, 9, function(v)
	Settings.OneTapKill = v
	oneTapKill = v
end)

makeSliderBtn(mainR, "Rate of Fire", Settings.RateOfFire, 1, 10000, 50, 1, function(v) Settings.RateOfFire = v end)
makeSliderBtn(mainR, "Fire Delay", Settings.FireDelay, 0.01, 1, 0.01, 2, function(v) Settings.FireDelay = v end)
makeSliderBtn(mainR, "Super Lock FOV", Settings.SuperLockFOV, 50, 9999, 50, 3, function(v) Settings.SuperLockFOV = v end)
makeSliderBtn(mainR, "Fly Speed", Settings.FlySpeed, 10, 5000, 10, 4, function(v) Settings.FlySpeed = v end)
makeSliderBtn(mainR, "Spread Amount", Settings.SpreadBulletAmount, 1, 45, 1, 5, function(v) Settings.SpreadBulletAmount = v end)
makeSliderBtn(mainR, "Spread Count", Settings.SpreadBulletCount, 2, 20, 1, 6, function(v) Settings.SpreadBulletCount = v end)

-- SILENT AIM
makeToggleBtn(silentL, "Silent Aim", Settings.SilentAim, 1, function(v) Settings.SilentAim = v end)
makeToggleBtn(silentL, "Aim Assist", Settings.AimAssist, 2, function(v) Settings.AimAssist = v end)
makeToggleBtn(silentL, "Magic Bullet", Settings.MagicBullet, 3, function(v) Settings.MagicBullet = v end)
makeToggleBtn(silentL, "Wallbang", Settings.SilentAimWallbang, 4, function(v) Settings.SilentAimWallbang = v end)
makeToggleBtn(silentL, "FOV Visible", Settings.SilentAimFOVVisible, 5, function(v) Settings.SilentAimFOVVisible = v end)
makeToggleBtn(silentL, "Ignore Team", Settings.IgnoreTeam, 6, function(v) Settings.IgnoreTeam = v end)

makeSliderBtn(silentR, "Silent Aim FOV", Settings.SilentAimFOVRadius, 50, 9999, 50, 1, function(v) Settings.SilentAimFOVRadius = v end)
makeSliderBtn(silentR, "Aim Assist FOV", Settings.AimAssistFOVRadius, 50, 500, 10, 2, function(v) Settings.AimAssistFOVRadius = v end)
makeSliderBtn(silentR, "Aim Assist Strength", Settings.AimAssistStrength, 0.05, 1, 0.05, 3, function(v) Settings.AimAssistStrength = v end)
makeSliderBtn(silentR, "Hit Chance", Settings.SilentAimHitChance, 0, 100, 5, 4, function(v) Settings.SilentAimHitChance = v end)
makeSliderBtn(silentR, "Prediction", Settings.SilentAimPrediction, 0, 0.5, 0.01, 5, function(v) Settings.SilentAimPrediction = v end)

-- VISUALS
makeToggleBtn(visualsL, "ESP", Settings.ESP, 1, function(v) Settings.ESP = v end)
makeToggleBtn(visualsL, "ESP Tracers", Settings.ESPTracers, 2, function(v) Settings.ESPTracers = v end)
makeToggleBtn(visualsL, "ESP Name", Settings.ESPName, 3, function(v) Settings.ESPName = v end)
makeToggleBtn(visualsL, "ESP Health", Settings.ESPHealth, 4, function(v) Settings.ESPHealth = v end)
makeToggleBtn(visualsL, "ESP Distance", Settings.ESPDistance, 5, function(v) Settings.ESPDistance = v end)
makeToggleBtn(visualsL, "Big Head", Settings.BigHead, 6, function(v)
	Settings.BigHead = v
	if v then enableBigHead() else disableBigHead() end
end)
makeToggleBtn(visualsL, "Prediction", Settings.Prediction, 7, function(v) Settings.Prediction = v end)

makeSliderBtn(visualsR, "Big Head Size", Settings.BigHeadSize, 2, 100, 1, 1, function(v)
	Settings.BigHeadSize = v
	if Settings.BigHead then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then applyBigHead(plr) end
		end
	end
end)
makeSliderBtn(visualsR, "Head Transparency", Settings.BigHeadTransparency * 100, 0, 100, 5, 2, function(v)
	Settings.BigHeadTransparency = v / 100
	if Settings.BigHead then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then applyBigHead(plr) end
		end
	end
end)
makeSliderBtn(visualsR, "Prediction Amount", Settings.PredictionAmount, 0, 1, 0.01, 3, function(v) Settings.PredictionAmount = v end)

-- SETTINGS
makeSliderBtn(settingsR, "FOV Radius (Main)", Settings.FOVRadius, 50, 9999, 50, 1, function(v) Settings.FOVRadius = v end)

tabs["Main"].page.Visible = true
tabs["Main"].btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabs["Main"].btn.TextColor3 = Color3.fromRGB(0, 0, 0)
tabs["Main"].stroke.Transparency = 0

local debugLabel = Instance.new("TextLabel")
debugLabel.Size = UDim2.new(1, -24, 0, 20)
debugLabel.Position = UDim2.new(0, 12, 1, -24)
debugLabel.BackgroundTransparency = 1
debugLabel.Text = "◆ Status: IDLE"
debugLabel.Font = Enum.Font.Arcade
debugLabel.TextSize = 11
debugLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
debugLabel.TextStrokeTransparency = 0
debugLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
debugLabel.TextXAlignment = Enum.TextXAlignment.Left
debugLabel.ZIndex = 103
debugLabel.Parent = frame

RunService.RenderStepped:Connect(function()
	if Settings.SuperLock and lockedTarget then
		debugLabel.Text = "◆ Super Lock: " .. lockedTarget.Parent.Name
		debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	elseif Settings.SilentAim and silentAimTarget then
		debugLabel.Text = "◆ Silent Aim: " .. silentAimTarget.Parent.Name
		debugLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	elseif Settings.OneTapKill then
		debugLabel.Text = "◆ One Tap Kill: ACTIVE"
		debugLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	elseif Settings.SpreadBullets then
		debugLabel.Text = "◆ Spread Bullets: ACTIVE"
		debugLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
	else
		debugLabel.Text = "◆ Status: IDLE"
		debugLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	end
end)

local glowTween = TweenService:Create(frameStroke3D, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Transparency = 0.7
})
glowTween:Play()

local minimized = false
local restoreSize = UDim2.new(0, 560, 0, 460)
local minimizedSize = UDim2.new(0, 560, 0, 40)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = minimizedSize}):Play()
		for _, p in pairs(tabs) do p.page.Visible = false end
		tabBar.Visible = false
		debugLabel.Visible = false
	else
		tabBar.Visible = true
		debugLabel.Visible = true
		for n, p in pairs(tabs) do p.page.Visible = (n == activeTab) end
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = restoreSize}):Play()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	local closeTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	closeTween:Play()
	closeTween.Completed:Connect(function()
		disableBigHead()
		disableFly()
		for _, line in pairs(tracerLines) do line:Remove() end
		for _, data in pairs(espData) do
			if data.billboard then data.billboard:Destroy() end
		end
		if mobileFlyGui then mobileFlyGui:Destroy() end
		gui:Destroy()
	end)
end)

frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = restoreSize}):Play()
TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -280, 0.5, -230)}):Play()

print("[Kenji] Full menu loaded — walang GodMode")