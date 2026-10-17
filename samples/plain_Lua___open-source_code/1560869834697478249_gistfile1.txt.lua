--[[
	AdvanceTech | v4.0
	+ Hitbox: 3 | Transparency: 3
	+ Fixed toggle bug (independent Auto/Pro)
]]
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local win = lib:Window("AdvanceTech | v4.0", Color3.fromRGB(44, 120, 224), Enum.KeyCode.P)

local sliderRegistry = {}
local function addSlider(tabObj, name, min, max, default, callback)
	local entry = { name = name, min = min, max = max, currentValue = default }
	entry.wrappedCallback = function(v)
		entry.currentValue = v
		callback(v)
	end
	table.insert(sliderRegistry, entry)
	return tabObj:Slider(name, min, max, default, entry.wrappedCallback)
end

local tab = win:Tab("Main")
local discordTab = win:Tab("Discord Link")

-- ===== SERVICES =====
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera

-- ============================================================
-- CONFIG
-- ============================================================
local AP_CONFIG = {
	WalkSpeed = 19, ChaseSpeed = 28, BackstabOffset = 2,
	MirrorSensitivity = 1.4, DodgeSpeed = 38, DodgeInterval = 0.25,
	ToggleKey = Enum.KeyCode.F,
	BombKeywords = {"bomb", "timebomb", "c4", "explosive", "grenade"},
	LoopDelay = 0.02,
	AutoPlayHoldTime = 2,
	AutoPlayStayDistance = 3,
	AutoPlayEscapeSpeed = 70,
	AutoPlayEscapeDistance = 40,
	AutoPlayEscapeTime = 0.4,
	AutoPlayDodgeTime = 2,
	AutoPlayCrouchTime = 2,
	AutoPlayGiveDistance = 1.5,
	PassSpeed = 55,
}

local PRO_CONFIG = {
	PassEvery = 1,
	BehindDistance = 4,
	StickTolerance = 1,
	PassSpeed = 55,
	CloseDistance = 1.5,
	PassDuration = 1.2,
	EscapeSpeed = 70,
	EscapeTime = 0.35,
	EscapeDistance = 35,
	EscapeDodgeTime = 2,
	EscapeCrouchTime = 2,
	TriggerDistance = 4,
}

-- ✅ UI State (مستقل لكل زر)
local UIState = {
	Auto = false,   -- هل زر Auto مفعّل من UI
	Pro = false,    -- هل زر Pro مفعّل من UI
	Lock = false,   -- هل زر Lock مفعّل
}

local AP_State = {
	Enabled = false, LastHadBomb = false,
	CrouchActive = false, CrouchUntil = 0,
	LastEnemyPos = nil, LastDodgeUpdate = 0,
	DodgeOffset = Vector3.new(0, 0, 0),
	LoopRunning = false,
	AutoPlayEscaping = false, AutoPlayEscapeTarget = nil,
	AutoPlayPhase = "idle",
	AutoPlayPhaseStart = 0,
	AutoPlayEscapeSub = "none",
	AutoPlaySubStart = 0,
}

local ProState = {
	Enabled = false,
	WasHoldingBomb = false,
	Phase = "idle",
	PhaseStart = 0,
	LastPassTime = 0,
	TimerRunning = false,
	EscapeSubPhase = "none",
	EscapeSubStart = 0,
	EscapeTarget = nil,
	LastPrintTime = 0,
}

local LockState = { Enabled = false, Speed = 12 }

local function ap_hasBomb(char)
	if not char then return false end
	for _, obj in ipairs(char:GetChildren()) do
		local name = obj.Name:lower()
		for _, kw in ipairs(AP_CONFIG.BombKeywords) do
			if name:find(kw) then return true end
		end
	end
	return false
end

local function ap_getBombHolder()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and ap_hasBomb(plr.Character) then return plr end
	end
	return nil
end

local function ap_getTarget(hrp)
	local bombHolder = ap_getBombHolder()
	if bombHolder and bombHolder ~= LP then
		local oChar = bombHolder.Character
		if oChar then
			local oHrp = oChar:FindFirstChild("HumanoidRootPart")
			local oHum = oChar:FindFirstChildOfClass("Humanoid")
			if oHrp and oHum and oHum.Health > 0 then
				return bombHolder, (hrp.Position - oHrp.Position).Magnitude, oHrp
			end
		end
	end
	local closest, closestDist, closestHrp = nil, math.huge, nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then
			local oChar = plr.Character
			if oChar then
				local oHum = oChar:FindFirstChildOfClass("Humanoid")
				if oHum and oHum.Health > 0 then
					local oHrp = oChar:FindFirstChild("HumanoidRootPart")
					if oHrp then
						local d = (hrp.Position - oHrp.Position).Magnitude
						if d < closestDist then closestDist = d; closest = plr; closestHrp = oHrp end
					end
				end
			end
		end
	end
	return closest, closestDist, closestHrp
end

local function ap_moveTo(targetPos, hrp, hum)
	if not hrp or not hum then return end
	pcall(function() hum:MoveTo(targetPos) end)
end

-- ============================================================
-- FOV
-- ============================================================
local AUTO_FOV = 200
local function applyFOV()
	pcall(function()
		if camera and camera.FieldOfView ~= AUTO_FOV then
			camera.FieldOfView = AUTO_FOV
		end
	end)
end
applyFOV()
RunService.RenderStepped:Connect(function() applyFOV() end)

-- ============================================================
-- GRAPHICS REDUCER
-- ============================================================
task.spawn(function()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100
		Lighting.FogStart = 0
		Lighting.Brightness = 1
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.Ambient = Color3.fromRGB(100, 100, 100)
		Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
		Lighting.ClockTime = 12

		for _, effect in ipairs(Lighting:GetChildren()) do
			if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
				effect:Destroy()
			end
		end

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)

		for _, obj in ipairs(Workspace:GetDescendants()) do
			pcall(function()
				if obj:IsA("BasePart") then
					obj.Material = Enum.Material.Plastic
					obj.Reflectance = 0
					obj.CastShadow = false
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") 
					or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("Beam") then
					obj.Enabled = false
				end
			end)
		end
	end)
end)

-- ============================================================
-- ✅ RESET HELPERS
-- ============================================================
local function ap_fullReset()
	AP_State.LastHadBomb = false
	AP_State.AutoPlayEscaping = false
	AP_State.AutoPlayPhase = "idle"
	AP_State.AutoPlayEscapeSub = "none"
	AP_State.AutoPlayEscapeTarget = nil
	AP_State.LastEnemyPos = nil
	AP_State.LastDodgeUpdate = 0
	AP_State.CrouchActive = false
	ap_stopCrouch()
end

local function pro_fullReset()
	ProState.WasHoldingBomb = false
	ProState.Phase = "idle"
	ProState.EscapeSubPhase = "none"
	ProState.EscapeTarget = nil
	ProState.TimerRunning = false
end

-- ✅ Recalculate AP enabled from UI state
local function refreshAP()
	local shouldEnable = UIState.Auto or UIState.Pro
	AP_State.Enabled = shouldEnable
	ProState.Enabled = UIState.Pro

	if shouldEnable then
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = AP_CONFIG.ChaseSpeed
				hum.AutoRotate = true
			end
		end
		ap_mainLoop()
	else
		-- ✅ رجع كل شيء طبيعي
		ap_fullReset()
		pro_fullReset()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = AP_CONFIG.WalkSpeed
				hum.AutoRotate = true
			end
		end
		print("🛑 All Auto/Pro stopped")
	end
end

-- ============================================================
-- LOCK
-- ============================================================
local LockLoopRunning = false
local function lockLoop()
	if LockLoopRunning then return end
	LockLoopRunning = true
	task.spawn(function()
		while LockState.Enabled do
			task.wait(0.02)
			pcall(function()
				local char = LP.Character
				if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end

				local _, _, oHrp = ap_getTarget(hrp)
				if not oHrp then return end

				if hum.AutoRotate then hum.AutoRotate = false end

				local pos = hrp.Position
				local dir = oHrp.Position - pos
				dir = Vector3.new(dir.X, 0, dir.Z)
				if dir.Magnitude < 0.05 then return end
				dir = dir.Unit

				local currentLook = hrp.CFrame.LookVector
				currentLook = Vector3.new(currentLook.X, 0, currentLook.Z)
				if currentLook.Magnitude < 0.05 then currentLook = dir end
				currentLook = currentLook.Unit

				local alpha = math.clamp(LockState.Speed * 0.02, 0, 1)
				local newLook = (currentLook * (1 - alpha) + dir * alpha)
				if newLook.Magnitude < 0.05 then newLook = dir end
				newLook = newLook.Unit

				hrp.CFrame = CFrame.lookAt(pos, pos + newLook)
			end)
		end
		LockLoopRunning = false
	end)
end

-- ============================================================
-- HITBOX
-- ============================================================
local hitboxEnabled = false
local noCollisionEnabled = false
local hitbox_original_properties = {}
local hitboxSize = 3
local hitboxTransparency = 3
local teamCheck = "FFA"
local defaultBodyParts = { "UpperTorso", "Head", "HumanoidRootPart" }

local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local WarningText = Instance.new("TextLabel", ScreenGui)
WarningText.Size = UDim2.new(0, 200, 0, 50)
WarningText.TextSize = 16
WarningText.Position = UDim2.new(0.5, -150, 0, 0)
WarningText.Text = "Warning: Collisions may occur."
WarningText.TextColor3 = Color3.new(1, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Visible = false

local function savedPart(player, part)
	if not hitbox_original_properties[player] then hitbox_original_properties[player] = {} end
	if not hitbox_original_properties[player][part.Name] then
		hitbox_original_properties[player][part.Name] = {
			CanCollide = part.CanCollide, Transparency = part.Transparency, Size = part.Size
		}
	end
end

local function restoredPart(player)
	if hitbox_original_properties[player] then
		for partName, properties in pairs(hitbox_original_properties[player]) do
			local part = player.Character and player.Character:FindFirstChild(partName)
			if part and part:IsA("BasePart") then
				part.CanCollide = properties.CanCollide
				part.Transparency = properties.Transparency
				part.Size = properties.Size
			end
		end
	end
end

local function findClosestPart(player, partName)
	if not player.Character then return nil end
	for _, part in ipairs(player.Character:GetChildren()) do
		if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
			return part
		end
	end
	return nil
end

local function extendHitbox(player)
	for _, partName in ipairs(defaultBodyParts) do
		local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
		if part and part:IsA("BasePart") then
			savedPart(player, part)
			if noCollisionEnabled then part.CanCollide = false end
			part.Transparency = hitboxTransparency / 10
			part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
		end
	end
end

local function isEnemy(player)
	if teamCheck == "FFA" or teamCheck == "Everyone" then return true end
	return player.Team ~= LP.Team
end

local function updateHitboxes()
	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			if isEnemy(v) then extendHitbox(v) else restoredPart(v) end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		if hitboxEnabled then updateHitboxes() end
	end)
	player.CharacterRemoving:Connect(function()
		restoredPart(player)
		hitbox_original_properties[player] = nil
	end)
end)

-- ============================================================
-- HELPERS
-- ============================================================
local function ap_doCrouch(duration)
	pcall(function()
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.CameraOffset = Vector3.new(0, -1.5, 0)
			AP_State.CrouchActive = true
			AP_State.CrouchUntil = tick() + duration
		end
	end)
end

function ap_stopCrouch()
	pcall(function()
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
		AP_State.CrouchActive = false
	end)
end

local function ap_backstabMove(targetHrp, hrp, hum)
	local targetFacing = targetHrp.CFrame.LookVector
	targetFacing = Vector3.new(targetFacing.X, 0, targetFacing.Z)
	if targetFacing.Magnitude > 0.1 then targetFacing = targetFacing.Unit end
	local behindPos = targetHrp.Position - targetFacing * AP_CONFIG.BackstabOffset
	ap_moveTo(behindPos, hrp, hum)
end

local function apForceLookAt(hrp, hum, targetPos)
	pcall(function()
		if hum.AutoRotate then hum.AutoRotate = false end
		local pos = hrp.Position
		local dir = Vector3.new(targetPos.X - pos.X, 0, targetPos.Z - pos.Z)
		if dir.Magnitude < 0.05 then return end
		dir = dir.Unit
		hrp.CFrame = CFrame.lookAt(pos, pos + dir)
	end)
end

local function apFaceDirection(hrp, hum, dir)
	pcall(function()
		if hum.AutoRotate then hum.AutoRotate = false end
		local pos = hrp.Position
		dir = Vector3.new(dir.X, 0, dir.Z)
		if dir.Magnitude < 0.05 then return end
		dir = dir.Unit
		hrp.CFrame = CFrame.lookAt(pos, pos + dir)
	end)
end

local function apRestoreAutoRotate(hum)
	pcall(function()
		if not hum.AutoRotate then hum.AutoRotate = true end
	end)
end

local function ap_mirrorDodge(targetHrp, hrp, hum, now)
	local enemyPos = targetHrp.Position
	local myPos = hrp.Position
	local enemyMove = Vector3.new(0, 0, 0)
	if AP_State.LastEnemyPos then
		enemyMove = enemyPos - AP_State.LastEnemyPos
		enemyMove = Vector3.new(enemyMove.X, 0, enemyMove.Z)
	end
	AP_State.LastEnemyPos = enemyPos
	if now - AP_State.LastDodgeUpdate > AP_CONFIG.DodgeInterval then
		AP_State.LastDodgeUpdate = now
		if enemyMove.Magnitude > 0.3 then
			local enemyDir = enemyMove.Unit
			local perpendicular = Vector3.new(-enemyDir.Z, 0, enemyDir.X)
			local testRight = myPos + perpendicular * 20
			local testLeft = myPos - perpendicular * 20
			if (testRight - enemyPos).Magnitude > (testLeft - enemyPos).Magnitude then
				AP_State.DodgeOffset = perpendicular * AP_CONFIG.MirrorSensitivity
			else
				AP_State.DodgeOffset = -perpendicular * AP_CONFIG.MirrorSensitivity
			end
		end
	end
	local awayDir = myPos - enemyPos
	awayDir = Vector3.new(awayDir.X, 0, awayDir.Z)
	if awayDir.Magnitude > 0.1 then awayDir = awayDir.Unit end
	local moveDir = (awayDir * 0.7 + AP_State.DodgeOffset * 0.3)
	if moveDir.Magnitude > 0.1 then moveDir = moveDir.Unit end
	ap_moveTo(myPos + moveDir * 30, hrp, hum)
end

-- ============================================================
-- AUTO PLAY
-- ============================================================
local function autoPlayLogic(hrp, hum, char, now)
	local iHaveBomb = ap_hasBomb(char)

	if not iHaveBomb then
		if AP_State.AutoPlayEscaping then
			AP_State.AutoPlayEscaping = false
			AP_State.AutoPlayEscapeSub = "none"
			apRestoreAutoRotate(hum)
		end
		local wasHolding = AP_State.LastHadBomb
		AP_State.LastHadBomb = false
		AP_State.AutoPlayPhase = "idle"

		if wasHolding then
			AP_State.AutoPlayEscaping = true
			AP_State.AutoPlayPhase = "escape"
			AP_State.AutoPlayEscapeSub = "backdash"
			AP_State.AutoPlaySubStart = now

			local facing = hrp.CFrame.LookVector
			facing = Vector3.new(facing.X, 0, facing.Z)
			if facing.Magnitude > 0.1 then facing = facing.Unit else facing = Vector3.new(0, 0, 1) end

			AP_State.AutoPlayEscapeTarget = hrp.Position - facing * AP_CONFIG.AutoPlayEscapeDistance
			hum.WalkSpeed = AP_CONFIG.AutoPlayEscapeSpeed
			apRestoreAutoRotate(hum)
			ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
			print("🏃 [Auto] BOMB GIVEN → ESCAPE")
			return
		end

		local _, _, oHrp = ap_getTarget(hrp)
		if oHrp then
			hum.WalkSpeed = AP_CONFIG.ChaseSpeed
			ap_backstabMove(oHrp, hrp, hum)
		end
		return
	end

	if not AP_State.LastHadBomb then
		AP_State.LastHadBomb = true
		AP_State.AutoPlayPhase = "hold"
		AP_State.AutoPlayPhaseStart = now
		print("💣 [Auto] BOMB RECEIVED")
	end

	if AP_State.AutoPlayEscaping then
		local sub = AP_State.AutoPlayEscapeSub
		local subElapsed = now - AP_State.AutoPlaySubStart

		if sub == "backdash" then
			if subElapsed < AP_CONFIG.AutoPlayEscapeTime then
				hum.WalkSpeed = AP_CONFIG.AutoPlayEscapeSpeed
				if AP_State.AutoPlayEscapeTarget then
					ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
				end
				return
			else
				AP_State.AutoPlayEscapeSub = "dodge"
				AP_State.AutoPlaySubStart = now
				AP_State.LastEnemyPos = nil
				hum.WalkSpeed = AP_CONFIG.DodgeSpeed
				return
			end
		end

		if sub == "dodge" then
			if subElapsed >= AP_CONFIG.AutoPlayDodgeTime then
				AP_State.AutoPlayEscapeSub = "crouch"
				AP_State.AutoPlaySubStart = now
				ap_doCrouch(AP_CONFIG.AutoPlayCrouchTime)
				return
			else
				local _, _, oHrp = ap_getTarget(hrp)
				if oHrp then
					hum.WalkSpeed = AP_CONFIG.DodgeSpeed
					ap_mirrorDodge(oHrp, hrp, hum, now)
				elseif AP_State.AutoPlayEscapeTarget then
					ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
				end
				return
			end
		end

		if sub == "crouch" then
			hum.WalkSpeed = 0
			pcall(function() hum:MoveTo(hrp.Position) end)
			if subElapsed >= AP_CONFIG.AutoPlayCrouchTime then
				AP_State.AutoPlayEscaping = false
				AP_State.AutoPlayEscapeSub = "none"
				hum.WalkSpeed = AP_CONFIG.ChaseSpeed
				apRestoreAutoRotate(hum)
				print("✅ [Auto] Escape done")
			end
			return
		end
	end

	local _, _, oHrp = ap_getTarget(hrp)
	if not oHrp then
		hum.WalkSpeed = AP_CONFIG.WalkSpeed
		return
	end
	local myPos = hrp.Position
	local targetPos = oHrp.Position

	if AP_State.AutoPlayPhase == "hold" then
		local holdElapsed = now - AP_State.AutoPlayPhaseStart
		if holdElapsed < AP_CONFIG.AutoPlayHoldTime then
			local dir = targetPos - myPos
			dir = Vector3.new(dir.X, 0, dir.Z)
			if dir.Magnitude > AP_CONFIG.AutoPlayStayDistance + 0.5 then
				hum.WalkSpeed = AP_CONFIG.WalkSpeed
				local stayPos = targetPos - dir.Unit * AP_CONFIG.AutoPlayStayDistance
				ap_moveTo(stayPos, hrp, hum)
			else
				hum.WalkSpeed = 0
				pcall(function() hum:MoveTo(myPos) end)
			end
			return
		else
			AP_State.AutoPlayPhase = "give"
			AP_State.AutoPlayPhaseStart = now
		end
	end

	AP_State.AutoPlayPhase = "give"
	hum.WalkSpeed = AP_CONFIG.PassSpeed

	local dir = targetPos - myPos
	dir = Vector3.new(dir.X, 0, dir.Z)
	if dir.Magnitude > 0.05 then
		local dirUnit = dir.Unit
		pcall(function() hum:Move(dirUnit, false) end)
		pcall(function() hum:MoveTo(targetPos) end)
		pcall(function()
			hrp.Velocity = Vector3.new(dirUnit.X * hum.WalkSpeed, hrp.Velocity.Y, dirUnit.Z * hum.WalkSpeed)
		end)
	end
end

-- ============================================================
-- PRO MODE
-- ============================================================
local function proModeLogic(hrp, hum, char, now)
	local iHaveBomb = ap_hasBomb(char)

	if not iHaveBomb then
		ProState.WasHoldingBomb = false
		ProState.Phase = "idle"
		ProState.EscapeSubPhase = "none"
		ProState.TimerRunning = false
		apRestoreAutoRotate(hum)
		local _, _, oHrp = ap_getTarget(hrp)
		if oHrp then
			hum.WalkSpeed = AP_CONFIG.ChaseSpeed
			ap_backstabMove(oHrp, hrp, hum)
		end
		return
	end

	if not ProState.WasHoldingBomb then
		ProState.WasHoldingBomb = true
		ProState.Phase = "behind"
		ProState.PhaseStart = now
		ProState.LastPassTime = now
		ProState.TimerRunning = false
		ProState.EscapeSubPhase = "none"
		ProState.LastPrintTime = 0
		print("💣 [Pro] BOMB - Pass when close (<=" .. PRO_CONFIG.TriggerDistance .. ")")
	end

	if ProState.Phase == "escape" then
		local sub = ProState.EscapeSubPhase
		local subElapsed = now - ProState.EscapeSubStart

		if sub == "backdash" then
			if subElapsed < PRO_CONFIG.EscapeTime then
				hum.WalkSpeed = PRO_CONFIG.EscapeSpeed
				if ProState.EscapeTarget then ap_moveTo(ProState.EscapeTarget, hrp, hum) end
				return
			else
				ProState.EscapeSubPhase = "dodge"
				ProState.EscapeSubStart = now
				AP_State.LastEnemyPos = nil
				hum.WalkSpeed = AP_CONFIG.DodgeSpeed
				return
			end
		end

		if sub == "dodge" then
			if subElapsed >= PRO_CONFIG.EscapeDodgeTime then
				ProState.EscapeSubPhase = "crouch"
				ProState.EscapeSubStart = now
				ap_doCrouch(PRO_CONFIG.EscapeCrouchTime)
				return
			else
				local _, _, oHrp = ap_getTarget(hrp)
				if oHrp then
					hum.WalkSpeed = AP_CONFIG.DodgeSpeed
					ap_mirrorDodge(oHrp, hrp, hum, now)
				elseif ProState.EscapeTarget then
					ap_moveTo(ProState.EscapeTarget, hrp, hum)
				end
				return
			end
		end

		if sub == "crouch" then
			hum.WalkSpeed = 0
			if subElapsed >= PRO_CONFIG.EscapeCrouchTime then
				ProState.Phase = "behind"
				ProState.PhaseStart = now
				ProState.LastPassTime = now
				ProState.TimerRunning = false
				ProState.EscapeSubPhase = "none"
				hum.WalkSpeed = AP_CONFIG.ChaseSpeed
				apRestoreAutoRotate(hum)
				print("✅ [Pro] Escape done → Behind")
			end
			return
		end
	end

	local _, _, oHrp = ap_getTarget(hrp)
	if not oHrp then return end
	local myPos = hrp.Position
	local targetPos = oHrp.Position
	local distToTarget = (myPos - targetPos).Magnitude

	if ProState.Phase == "pass" then
		local passElapsed = now - ProState.PhaseStart
		if passElapsed > PRO_CONFIG.PassDuration then
			ProState.Phase = "behind"
			ProState.PhaseStart = now
			ProState.LastPassTime = now
			ProState.TimerRunning = false
			return
		end

		hum.WalkSpeed = PRO_CONFIG.PassSpeed
		if not LockState.Enabled then apForceLookAt(hrp, hum, targetPos) end

		local dir = targetPos - myPos
		dir = Vector3.new(dir.X, 0, dir.Z)
		if dir.Magnitude > 0.05 then
			local dirUnit = dir.Unit
			pcall(function() hum:Move(dirUnit, false) end)
			pcall(function() hum:MoveTo(targetPos) end)
			pcall(function()
				hrp.Velocity = Vector3.new(dirUnit.X * PRO_CONFIG.PassSpeed, hrp.Velocity.Y, dirUnit.Z * PRO_CONFIG.PassSpeed)
			end)
			if distToTarget <= PRO_CONFIG.CloseDistance then
				pcall(function()
					hrp.CFrame = CFrame.lookAt(myPos + dirUnit * 0.5, myPos + dirUnit * 0.5 + dirUnit)
				end)
			end
		end

		if not LockState.Enabled then apForceLookAt(hrp, hum, targetPos) end

		if not ap_hasBomb(char) then
			ProState.Phase = "escape"
			ProState.EscapeSubPhase = "backdash"
			ProState.EscapeSubStart = now
			ProState.WasHoldingBomb = false
			ProState.TimerRunning = false
			local escapeDir = myPos - targetPos
			escapeDir = Vector3.new(escapeDir.X, 0, escapeDir.Z)
			if escapeDir.Magnitude < 0.1 then escapeDir = Vector3.new(1, 0, 0) end
			ProState.EscapeTarget = myPos + escapeDir.Unit * PRO_CONFIG.EscapeDistance
			hum.WalkSpeed = PRO_CONFIG.EscapeSpeed
			apRestoreAutoRotate(hum)
			print("🏃 [Pro] BOMB GIVEN → ESCAPE")
		end
		return
	end

	ProState.Phase = "behind"

	local targetFacing = oHrp.CFrame.LookVector
	targetFacing = Vector3.new(targetFacing.X, 0, targetFacing.Z)
	if targetFacing.Magnitude > 0.1 then
		targetFacing = targetFacing.Unit
	else
		targetFacing = Vector3.new(0, 0, 1)
	end

	local behindPos = targetPos - targetFacing * PRO_CONFIG.BehindDistance
	local toBehind = behindPos - myPos
	toBehind = Vector3.new(toBehind.X, 0, toBehind.Z)
	local distToBehind = toBehind.Magnitude

	if distToBehind > PRO_CONFIG.StickTolerance then
		hum.WalkSpeed = AP_CONFIG.ChaseSpeed
		ap_moveTo(behindPos, hrp, hum)
	else
		hum.WalkSpeed = 0
		pcall(function() hum:MoveTo(myPos) end)
	end

	if not LockState.Enabled then
		apFaceDirection(hrp, hum, targetFacing)
	end

	if distToTarget <= PRO_CONFIG.TriggerDistance then
		if not ProState.TimerRunning then
			ProState.TimerRunning = true
			ProState.LastPassTime = now
			print(string.format("🎯 [Pro] TIMER START! Dist: %.1f", distToTarget))
		end

		local timeSincePass = now - ProState.LastPassTime

		if timeSincePass >= PRO_CONFIG.PassEvery then
			ProState.Phase = "pass"
			ProState.PhaseStart = now
			print(string.format("⚡ [Pro] PASS! (%.1fs)", timeSincePass))
			return
		end
	else
		if ProState.TimerRunning then
			ProState.TimerRunning = false
			print(string.format("⏸️ [Pro] TIMER PAUSED (Dist: %.1f)", distToTarget))
		end
	end
end

function ap_mainLoop()
	if AP_State.LoopRunning then return end
	AP_State.LoopRunning = true
	task.spawn(function()
		while AP_State.Enabled do
			task.wait(AP_CONFIG.LoopDelay)
			local now = tick()
			pcall(function()
				local char = LP.Character
				if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				if ProState.Enabled then
					proModeLogic(hrp, hum, char, now)
					return
				end
				autoPlayLogic(hrp, hum, char, now)
			end)
		end
		AP_State.LoopRunning = false
		-- ✅ بعد الخروج، نظّف
		pcall(function()
			local char = LP.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.WalkSpeed = AP_CONFIG.WalkSpeed
					hum.AutoRotate = true
				end
			end
		end)
	end)
end

-- ============================================================
-- UI
-- ============================================================
tab:Toggle("Hitbox", false, function(enabled)
	hitboxEnabled = enabled
	if not enabled then
		for _, player in ipairs(Players:GetPlayers()) do restoredPart(player) end
		hitbox_original_properties = {}
	else
		updateHitboxes()
		task.spawn(function()
			while hitboxEnabled do
				updateHitboxes()
				task.wait(0.1)
			end
		end)
	end
end)

tab:Toggle("Auto", false, function(enabled)
	UIState.Auto = enabled
	refreshAP()
end)

tab:Toggle("Pro", false, function(enabled)
	UIState.Pro = enabled
	refreshAP()
end)

tab:Toggle("Lock", false, function(enabled)
	UIState.Lock = enabled
	LockState.Enabled = enabled
	if enabled then
		lockLoop()
		print("🔒 Lock ON")
	else
		LockLoopRunning = false
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.AutoRotate = true end
		end
		print("🔓 Lock OFF")
	end
end)

tab:Toggle("No Collision", false, function(enabled)
	noCollisionEnabled = enabled
	WarningText.Visible = enabled
	task.spawn(function()
		while noCollisionEnabled do
			if hitboxEnabled then updateHitboxes() end
			task.wait(0.05)
		end
	end)
end)

addSlider(tab, "Hitbox Size", 1, 50, 3, function(value)
	hitboxSize = value
	if hitboxEnabled then updateHitboxes() end
end)

addSlider(tab, "Hitbox Transp", 1, 10, 3, function(value)
	hitboxTransparency = value
	if hitboxEnabled then updateHitboxes() end
end)

tab:Dropdown("Team", {"FFA", "Team-Based", "Everyone"}, function(value)
	teamCheck = value
	if hitboxEnabled then updateHitboxes() end
end)

addSlider(tab, "Lock Speed", 1, 30, 12, function(value)
	LockState.Speed = value
end)

addSlider(tab, "Auto Hold", 2, 10, 2, function(value)
	AP_CONFIG.AutoPlayHoldTime = value
end)

addSlider(tab, "Auto Stay Dist", 1, 15, 3, function(value)
	AP_CONFIG.AutoPlayStayDistance = value
end)

addSlider(tab, "Auto Dodge Time", 2, 5, 2, function(value)
	AP_CONFIG.AutoPlayDodgeTime = value
end)

addSlider(tab, "Auto Crouch Time", 2, 5, 2, function(value)
	AP_CONFIG.AutoPlayCrouchTime = value
end)

addSlider(tab, "Auto Escape Speed", 30, 120, 70, function(value)
	AP_CONFIG.AutoPlayEscapeSpeed = value
end)

addSlider(tab, "Pro Pass Every", 1, 10, 1, function(value)
	PRO_CONFIG.PassEvery = value
end)

addSlider(tab, "Pro Trigger Dist", 1, 10, 4, function(value)
	PRO_CONFIG.TriggerDistance = value
end)

addSlider(tab, "Pro Behind Dist", 1, 20, 4, function(value)
	PRO_CONFIG.BehindDistance = value
end)

addSlider(tab, "Pro Pass Speed", 20, 100, 55, function(value)
	PRO_CONFIG.PassSpeed = value
end)

addSlider(tab, "Pro Close Dist", 0.5, 5, 1.5, function(value)
	PRO_CONFIG.CloseDistance = value
end)

addSlider(tab, "Pro Pass Time", 0.5, 5, 1.2, function(value)
	PRO_CONFIG.PassDuration = value
end)

addSlider(tab, "Pro Dodge Time", 2, 5, 2, function(value)
	PRO_CONFIG.EscapeDodgeTime = value
end)

addSlider(tab, "Pro Crouch Time", 2, 5, 2, function(value)
	PRO_CONFIG.EscapeCrouchTime = value
end)

-- DISCORD
discordTab:Label("> Discord Link")
discordTab:Label("owner Syrian")
discordTab:Label("Syrianhub - TikTok")

discordTab:Button("Copy", function()
	pcall(function()
		setclipboard("https://discord.gg/8bvhjG7Sp\nSyrianhub - TikTok\nowner Syrian")
	end)
end)

-- ============================================================
-- KEYBINDS
-- ============================================================
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == AP_CONFIG.ToggleKey then
		-- ✅ F يبدل Auto فقط (ما يلمس Pro)
		UIState.Auto = not UIState.Auto
		refreshAP()
		print(UIState.Auto and "✅ Auto ON" or "❌ Auto OFF")
	end

	if input.KeyCode == Enum.KeyCode.L then
		UIState.Lock = not UIState.Lock
		LockState.Enabled = UIState.Lock
		if LockState.Enabled then
			lockLoop()
		else
			LockLoopRunning = false
			local char = LP.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.AutoRotate = true end
			end
		end
	end
end)

-- ============================================================
-- UI ENHANCEMENTS
-- ============================================================
task.spawn(function()
	local PlayerGui = LP:WaitForChild("PlayerGui")
	local ACCENT = Color3.fromRGB(44, 120, 224)
	local ACCENT_LIGHT = Color3.fromRGB(88, 160, 255)
	local BG_DARK = Color3.fromRGB(16, 16, 22)
	local BG_PANEL = Color3.fromRGB(26, 26, 34)
	local TEXT_WHITE = Color3.fromRGB(240, 240, 250)

	local vapeGui, mainFrame
	local tries = 0
	while (not vapeGui or not mainFrame) and tries < 40 do
		task.wait(0.25)
		tries = tries + 1
		for _, container in ipairs({CoreGui, PlayerGui}) do
			for _, gui in ipairs(container:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Name ~= "AT_MinimizedCircle" and gui.Name ~= "AT_WarningGui" then
					for _, d in ipairs(gui:GetDescendants()) do
						if d:IsA("TextLabel") and typeof(d.Text) == "string" and d.Text:find("AdvanceTech") then
							vapeGui = gui
							local p = d
							while p and p.Parent ~= gui do p = p.Parent end
							if p and p:IsA("Frame") then mainFrame = p end
							break
						end
					end
				end
				if vapeGui and mainFrame then break end
			end
			if vapeGui and mainFrame then break end
		end
	end
	if not vapeGui or not mainFrame then return end

	mainFrame.BackgroundColor3 = BG_DARK
	mainFrame.BorderSizePixel = 0

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 16)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = ACCENT
	mainStroke.Thickness = 1.5
	mainStroke.Transparency = 0.2
	mainStroke.Parent = mainFrame

	local bgGradient = Instance.new("UIGradient")
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, BG_DARK),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 34)),
	})
	bgGradient.Rotation = 90
	bgGradient.Parent = mainFrame

	local shadow = Instance.new("ImageLabel")
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
	shadow.Size = UDim2.new(1, 50, 1, 50)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://5028857084"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.45
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(24, 24, 276, 276)
	shadow.ZIndex = mainFrame.ZIndex - 1
	shadow.Parent = mainFrame

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 38)
	titleBar.BackgroundColor3 = BG_PANEL
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 5
	titleBar.Parent = mainFrame

	local tbCorner = Instance.new("UICorner")
	tbCorner.CornerRadius = UDim.new(0, 16)
	tbCorner.Parent = titleBar

	local tbFix = Instance.new("Frame")
	tbFix.Size = UDim2.new(1, 0, 0, 16)
	tbFix.Position = UDim2.new(0, 0, 1, -16)
	tbFix.BackgroundColor3 = BG_PANEL
	tbFix.BorderSizePixel = 0
	tbFix.ZIndex = 5
	tbFix.Parent = titleBar

	local tbAccent = Instance.new("Frame")
	tbAccent.Size = UDim2.new(1, -28, 0, 2)
	tbAccent.Position = UDim2.new(0, 14, 1, -1)
	tbAccent.BackgroundColor3 = ACCENT
	tbAccent.BorderSizePixel = 0
	tbAccent.ZIndex = 6
	tbAccent.Parent = titleBar

	local ANIM_TEXT = "Syrianhub • AdvanceTech v4.0"
	local animLabel = Instance.new("TextLabel")
	animLabel.BackgroundTransparency = 1
	animLabel.Position = UDim2.new(0, 34, 0, 0)
	animLabel.Size = UDim2.new(1, -120, 1, 0)
	animLabel.Font = Enum.Font.GothamBold
	animLabel.TextSize = 14
	animLabel.TextColor3 = TEXT_WHITE
	animLabel.TextXAlignment = Enum.TextXAlignment.Left
	animLabel.TextYAlignment = Enum.TextYAlignment.Center
	animLabel.Text = ""
	animLabel.ZIndex = 8
	animLabel.Parent = titleBar

	task.spawn(function()
		local totalChars = #ANIM_TEXT
		while animLabel.Parent do
			for i = 1, totalChars do
				if not animLabel.Parent then return end
				animLabel.Text = string.sub(ANIM_TEXT, 1, i)
				task.wait(0.04)
			end
			task.wait(1.5)
			for i = totalChars - 1, 0, -1 do
				if not animLabel.Parent then return end
				animLabel.Text = string.sub(ANIM_TEXT, 1, i)
				task.wait(0.04)
			end
			task.wait(0.8)
		end
	end)

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
	minimizeBtn.Position = UDim2.new(1, -36, 0.5, -13)
	minimizeBtn.Text = "—"
	minimizeBtn.TextSize = 18
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.BackgroundColor3 = ACCENT
	minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
	minimizeBtn.BorderSizePixel = 0
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.ZIndex = 10
	minimizeBtn.Parent = titleBar

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(1, 0)
	minCorner.Parent = minimizeBtn

	local circleGui = Instance.new("ScreenGui")
	circleGui.Name = "AT_MinimizedCircle"
	circleGui.ResetOnSpawn = false
	circleGui.IgnoreGuiInset = true
	circleGui.Parent = CoreGui

	local circleContainer = Instance.new("Frame")
	circleContainer.Size = UDim2.new(0, 72, 0, 72)
	circleContainer.Position = UDim2.new(0.5, -36, 0.5, -36)
	circleContainer.BackgroundTransparency = 1
	circleContainer.Visible = false
	circleContainer.Parent = circleGui

	local circleBtn = Instance.new("TextButton")
	circleBtn.Size = UDim2.new(0, 66, 0, 66)
	circleBtn.Position = UDim2.new(0.5, -33, 0.5, -33)
	circleBtn.Text = "963"
	circleBtn.TextSize = 22
	circleBtn.Font = Enum.Font.GothamBold
	circleBtn.BackgroundColor3 = ACCENT
	circleBtn.TextColor3 = Color3.new(1, 1, 1)
	circleBtn.BorderSizePixel = 0
	circleBtn.AutoButtonColor = false
	circleBtn.Parent = circleContainer

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(1, 0)
	cCorner.Parent = circleBtn

	local dragging = false
	local moved = false
	local dragStart, startPos

	minimizeBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
		circleContainer.Visible = true
		circleContainer.Size = UDim2.new(0, 0, 0, 0)
		circleContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
		TweenService:Create(circleContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 72, 0, 72),
			Position = UDim2.new(0.5, -36, 0.5, -36)
		}):Play()
	end)

	circleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = circleContainer.Position
		end
	end)

	circleBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging and not moved then
				mainFrame.Visible = true
				circleContainer.Visible = false
			end
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then moved = true end
			circleContainer.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	local function setupSliderInput(sliderInfo)
		local nameLabel
		for _, d in ipairs(vapeGui:GetDescendants()) do
			if d:IsA("TextLabel") and d.Text == sliderInfo.name and not d:GetAttribute("AT_Processed") then
				nameLabel = d
				break
			end
		end
		if not nameLabel then return end
		nameLabel:SetAttribute("AT_Processed", true)
		pcall(function()
			nameLabel.TextColor3 = TEXT_WHITE
		end)

		local valueLabel
		local candidates = {}
		for _, sib in ipairs(nameLabel.Parent:GetChildren()) do table.insert(candidates, sib) end
		if nameLabel.Parent.Parent then
			for _, sib in ipairs(nameLabel.Parent.Parent:GetChildren()) do table.insert(candidates, sib) end
		end
		for _, cand in ipairs(candidates) do
			if cand:IsA("TextLabel") and cand ~= nameLabel and not cand:GetAttribute("AT_ValueUsed") then
				if tonumber(cand.Text) then valueLabel = cand; break end
			end
		end
		if not valueLabel then return end
		valueLabel:SetAttribute("AT_ValueUsed", true)
		pcall(function()
			valueLabel.TextColor3 = ACCENT_LIGHT
		end)

		valueLabel:GetPropertyChangedSignal("Text"):Connect(function()
			local n = tonumber(valueLabel.Text)
			if n then sliderInfo.currentValue = n end
		end)

		local tb = Instance.new("TextBox")
		tb.Size = valueLabel.Size
		tb.Position = valueLabel.Position
		tb.AnchorPoint = valueLabel.AnchorPoint
		tb.BackgroundTransparency = 1
		tb.BorderSizePixel = 0
		tb.TextColor3 = ACCENT_LIGHT
		tb.TextSize = valueLabel.TextSize
		tb.Font = Enum.Font.GothamBold
		tb.Text = tostring(sliderInfo.currentValue)
		tb.TextXAlignment = valueLabel.TextXAlignment
		tb.TextYAlignment = valueLabel.TextYAlignment
		tb.TextTransparency = 1
		tb.ClearTextOnFocus = false
		tb.ZIndex = valueLabel.ZIndex + 10
		tb.Parent = valueLabel.Parent

		tb.Focused:Connect(function()
			tb.TextTransparency = 0
			tb.Text = tostring(sliderInfo.currentValue)
		end)

		tb.FocusLost:Connect(function()
			tb.TextTransparency = 1
			local v = tonumber(tb.Text)
			if v then
				v = math.floor(v)
				v = math.clamp(v, sliderInfo.min, sliderInfo.max)
				sliderInfo.wrappedCallback(v)
				valueLabel.Text = tostring(v)
			end
			tb.Text = tostring(sliderInfo.currentValue)
		end)
	end

	for _, sliderInfo in ipairs(sliderRegistry) do setupSliderInput(sliderInfo) end

	print("[AdvanceTech] UI ready!")
end)

print("═══════════════════════════════════════")
print("✅ AdvanceTech v4.0 Loaded")
print("🔴 Hitbox: Size 3 | Transp 3")
print("✅ Fixed toggle bug")
print("⌨️ P = UI | F = Auto | L = Lock")
print("═══════════════════════════════════════")