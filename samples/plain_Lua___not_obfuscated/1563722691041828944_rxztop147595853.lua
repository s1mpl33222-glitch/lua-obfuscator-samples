local function _w(t) t = t or 0.03 if task and type(task.wait) == "function" then task.wait(t) elseif type(wait) == "function" then wait(t) end end do local n = 0 while n < 200 do local ok, loaded = pcall(function() return game:IsLoaded() end) if ok and loaded then break end n = n + 1; _w(0.05) end end
_w(0.1); print("[Candy Hub Remake] Starting..."); local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local TS = game:GetService("TweenService"); local Lighting = game:GetService("Lighting"); local HS = game:GetService("HttpService"); local LP = Players.LocalPlayer if not LP then local ok, plr = pcall(function() return Players:WaitForChild("LocalPlayer", 15) end) if ok then LP = plr end end if not LP then warn("[prime.vs] LocalPlayer not found - abort") return end local _genv = _G pcall(function()
if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then _genv = g end end end) local function destroyOldGuis() local names = {"PrimeVSHub", "CursedHub", "VersincMobileButtons", "VersicnIntro"}; local parents = {} pcall(function() table.insert(parents, game:GetService("CoreGui")) end) pcall(function() if LP then table.insert(parents, LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2)) end end) pcall(function() if type(gethui) == "function" then table.insert(parents, gethui()) end end) for _, parent in ipairs(parents) do if parent then
for _, name in ipairs(names) do pcall(function() local o = parent:FindFirstChild(name) while o do o:Destroy(); o = parent:FindFirstChild(name) end end) end end end _G.VersincMobileButtonRefs = {} end if _genv.__PrimeVSHubLoaded then pcall(destroyOldGuis); _genv.__PrimeVSHubLoaded = false warn("[Candy Hub Remake] Old instance cleaned - reloading...") end pcall(destroyOldGuis);
_G.__AntiTPBatEnabled = false
-- ANTI TP BAT / ANTI BAT removidos a pedido do usuario (stubs inertes)
local AntiTPBat = { runtime = nil }
function AntiTPBat.set(_) _G.__AntiTPBatEnabled = false; _G.__AntiBatFusionOn = false; return false end
function AntiTPBat.isOn() return false end
function AntiTPBat.toggle() return false end
function AntiTPBat.fusionStop() end
_G.InstaResetLoaded = false
_G._YoutInstaResetState = nil
 local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons) or nil; local _IS_MOBILE = false pcall(function() _IS_MOBILE = UIS.TouchEnabled == true and UIS.KeyboardEnabled ~= true end) pcall(function() if UIS.TouchEnabled and not UIS.MouseEnabled then _IS_MOBILE = true end end) local function _perfEveryN(nMobile, nDesktop) local n = _IS_MOBILE and nMobile or nDesktop if n <= 1 then return true end local bucket = math.floor(os.clock() * 60)
return (bucket % n) == 0 end local function _perfDue(key, mobileSec, desktopSec) return _perfEveryN(math.max(1, math.floor((mobileSec or 0.1) * 60)), math.max(1, math.floor((desktopSec or 0.05) * 60))) end local S = { NS = 60, CS = 30, LAGGER_SPEED = 15, LAGGER_CARRY_SPEED = 24.5, speedMode = false, antiRagdollEnabled = false, antiRagdollMode = 1, aimbotMode = 1, antiBatBypassEnabled = false, laggerToggled = false, laggerPhase = 0, autoCarrySpeedEnabled = false, setAutoCarrySpeedVisual = nil, _autoCarryFromSteal = false, _autoCarryWaitingPickup = false,
_autoCarryGraceUntil = 0, _autoCarryPickupUntil = 0, _autoCarryReturnMode = nil, _stealAttrWasActive = false, medusaCounterEnabled = false, medusaResetEnabled = false, batCounterEnabled = false, unwalkEnabled = false, medusaDebounce = false, medusaLastUsed = 0, dropActive = false, autoLeftEnabled = false, autoRightEnabled = false, autoLeftSetVisual = nil, autoRightSetVisual = nil, speedLabel = nil, autoBatEnabled = false, autoSwingEnabled = true, autoBatSetVisual = nil, autoBatEquippedThisRun = false, _autoBatTarget = nil, _autoBatLastScan = 0, resetAutoBatMotion = nil,
AUTO_BAT_SPEED = 85, AUTO_BAT_VERT_SPEED = 52, AUTO_BAT_DIST = -2.8, AUTO_BAT_HEIGHT = 4.75, AUTO_BAT_V_OFF = 1, AUTO_BAT_TURN_SPEED = 285, AUTO_BAT_MAX_TURN_RATE = 28, setBatCounterVisual = nil, startBatCounter = nil, stopBatCounter = nil, enableAutoBat = nil, disableAutoBat = nil, antiLagEnabled = false, removeAccessoriesEnabled = false, antiDieEnabled = false, antiFlingShieldEnabled = false, antiLagDescConn = nil, stretchRezEnabled = false, stretchRezConn = nil, setStretchRezVisual = nil, unwalkSavedAnimate = nil,
_anyKeyListening = false, autoTPEnabled = false, autoTPHeight = 20, autoTPConn = nil, setAutoTPVisual = nil, autoSaveEnabled = true, savedBatSkin = nil, savedMedusaSkin = nil, savedBleedPack = "Off", savedVX7Outfit = 0, rainbowToolsEnabled = false, _lastSaveOk = false, _lastSaveAt = 0, cursedResetRemote = nil, CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42", AntiRagdollConns = {}, noPlayerCollisionEnabled = false, safeModeEnabled = false, autoResetOnMedEnabled = false, showTracerEnabled = false, ragdollCountdownEnabled = false, guiLocked = false, hideMobileButtons = false, lockMobileButtons = false, allLockButtons = false, moveButtons = false, progressBarScale = 100, infJumpMode = "hold",
mirrorTPDownEnabled = false, _bodyLockPausedByCombat = false, _bodyLockWanted = false, _bodyLockPausedByBrainrot = false, mobileButtonScale = 0.80, keyboardOverlayEnabled = false, } local VS, UI, F = {}, {}, {} local NS, CS = S.NS, S.CS; local CONFIG_FILE, CONFIG_FILE_LEGACY = "PrimeVSHubConfig.json", "cursedPC.json" local _isfile = isfile or (syn and syn.isfile) or function() return false end local _readfile = readfile or (syn and syn.readfile) or function() return nil end
local _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or nil; local antiRagdollConn = nil; local antiRagdollModeActive = nil; local ragdollConnections = {}; local cachedCharData = {}; local isBoosting = false; local BOOST_SPEED = 400 local AR_DEFAULT_SPEED = 16 local function arGetNormalSpeed() return AR_DEFAULT_SPEED end local function arV2ResetCharacter(char) local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart") if not hum or not root or hum.Health <= 0 then return end pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero; root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero hum.PlatformStand = false; hum.Sit = false; hum.AutoRotate = true hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50 hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or AR_DEFAULT_SPEED for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") then obj.Enabled = true
elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then obj.Enabled = true elseif obj:IsA("BasePart") then obj.CanCollide = true; obj.AssemblyLinearVelocity = Vector3.zero; obj.AssemblyAngularVelocity = Vector3.zero end end if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule"); local controlModule = playerModule and playerModule:FindFirstChild("ControlModule") if controlModule then
local loaded, module = pcall(require, controlModule) if loaded and module and module.Enable then pcall(function() module:Enable() end) end end end) end local function arCacheCharacterData() local char = LP.Character if not char then return false end local hum = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart") if not hum or not root then return false end cachedCharData = { character = char, humanoid = hum, root = root }; S._ragdollCache = cachedCharData return true end local function arDisconnectAll()
for _, conn in ipairs(ragdollConnections) do pcall(function() conn:Disconnect() end) end ragdollConnections = {} end local AR_STATES = { [Enum.HumanoidStateType.Physics] = true, [Enum.HumanoidStateType.Ragdoll] = true, [Enum.HumanoidStateType.FallingDown] = true } local function arIsRagdolled() if not cachedCharData.humanoid then return false end if AR_STATES[cachedCharData.humanoid:GetState()] then return true end local endTime = LP:GetAttribute("RagdollEndTime") return (endTime and (endTime - workspace:GetServerTimeNow()) > 0) or false end local function arForceExitRagdoll()
if not cachedCharData.humanoid or not cachedCharData.root then return end pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end) for _, d in ipairs(cachedCharData.character:GetDescendants()) do if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then pcall(function() d:Destroy() end) end end if not isBoosting then isBoosting = true pcall(function() cachedCharData.humanoid.WalkSpeed = BOOST_SPEED end) end pcall(function()
if cachedCharData.humanoid.Health > 0 then cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running) end cachedCharData.root.Anchored = false end) end local function arHeartbeatLoop() while antiRagdollModeActive == "v1" do task.wait() local currentlyRagdolled = arIsRagdolled() if currentlyRagdolled then arForceExitRagdoll() elseif isBoosting and not currentlyRagdolled then isBoosting = false if cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end end end end function F.startAntiRagdoll()
local requestedMode = (S.antiRagdollMode == 2) and "v2" or "v1" if antiRagdollModeActive == requestedMode and (#S.AntiRagdollConns > 0 or antiRagdollConn) then return end F.stopAntiRagdoll() if not arCacheCharacterData() then return end antiRagdollModeActive = requestedMode if requestedMode == "v2" then antiRagdollConn = RunService.Heartbeat:Connect(function() if antiRagdollModeActive ~= "v2" or not S.antiRagdollEnabled then return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid") if not hum then return end local state = hum:GetState()
if AR_STATES[state] or state == Enum.HumanoidStateType.Dead or hum.PlatformStand == true or hum.Sit == true then arV2ResetCharacter(char) end end) table.insert(S.AntiRagdollConns, antiRagdollConn) return end local camConn = RunService.RenderStepped:Connect(function() local cam = workspace.CurrentCamera if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end end) table.insert(ragdollConnections, camConn); table.insert(S.AntiRagdollConns, camConn) local respawnConn = LP.CharacterAdded:Connect(function()
isBoosting = false; task.wait(0.5); arCacheCharacterData() end) table.insert(ragdollConnections, respawnConn); table.insert(S.AntiRagdollConns, respawnConn); task.spawn(arHeartbeatLoop) end function F.stopAntiRagdoll() antiRagdollModeActive = nil if antiRagdollConn then pcall(function() antiRagdollConn:Disconnect() end); antiRagdollConn = nil end if isBoosting and cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end isBoosting = false; arDisconnectAll() for _, conn in pairs(S.AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
S.AntiRagdollConns = {}; cachedCharData = {}; S._ragdollCache = {} end local _adDeathConns = {}; local _adHeartConn = nil; local _adCharConn = nil; local _afsLoop = nil local _antiDie = { loop = nil, healthConn = nil, diedConn = nil, humanoid = nil, lastHealTime = 0, invincibleUntil = 0, config = { healthThreshold = 50, invincibilityFrames = 0.75, ragdollProtection = true, autoRevive = true }, } local function _adDisconnectHumanoid() if _antiDie.healthConn then pcall(function() _antiDie.healthConn:Disconnect() end); _antiDie.healthConn = nil end
if _antiDie.diedConn then pcall(function() _antiDie.diedConn:Disconnect() end); _antiDie.diedConn = nil end _antiDie.humanoid = nil end local function _adDisconnectAll() for _, c in ipairs(_adDeathConns) do pcall(function() c:Disconnect() end) end _adDeathConns = {} if _adHeartConn then pcall(function() _adHeartConn:Disconnect() end); _adHeartConn = nil end _adDisconnectHumanoid() end local function _adSuperHeal(hum) if not hum or not hum.Parent then return end local maxHealth = hum.MaxHealth or 100 if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end pcall(function()
hum.Health = maxHealth if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end end) _antiDie.invincibleUntil = tick() + (_antiDie.config.invincibilityFrames or 0.75) _antiDie.lastHealTime = tick() pcall(function() local char = hum.Parent if not char then return end for _, child in ipairs(char:GetChildren()) do if child:IsA("NumberValue") then local name = child.Name:lower() if name:find("health") or name:find("hp") or name:find("life") then child.Value = maxHealth end end if child:IsA("BoolValue") and child.Name:lower():find("dead") then child.Value = false end end end) end
local function _adPreventDamage(root, hum) if not hum then return end if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end if tick() < (_antiDie.invincibleUntil or 0) then if hum.Health < (hum.MaxHealth or 100) then pcall(function() hum.Health = hum.MaxHealth or 100 end) end end if _antiDie.config.ragdollProtection then local state = hum:GetState() if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp) hum:ChangeState(Enum.HumanoidStateType.Running) end) _adSuperHeal(hum) if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero root.AssemblyLinearVelocity = Vector3.new( root.AssemblyLinearVelocity.X, math.max(root.AssemblyLinearVelocity.Y, -10), root.AssemblyLinearVelocity.Z ) end) end end end if hum.Health <= 0 then _adSuperHeal(hum) pcall(function() hum.PlatformStand = false hum.Sit = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end end function F.applyAntiReset()
pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", false) end) end function F.restoreReset() pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", true) end) end local function protectCharClean(char) if not S.antiDieEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum then local ok, waited = pcall(function() return char:WaitForChild("Humanoid", 3) end) if ok and waited and waited:IsA("Humanoid") then hum = waited end end
if not hum or not S.antiDieEnabled then return end _adDisconnectHumanoid() _antiDie.humanoid = hum pcall(function() hum.BreakJointsOnDeath = false hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) _adSuperHeal(hum) _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function() if not S.antiDieEnabled or not hum.Parent then return end if hum.Health <= 0 or hum.Health < (_antiDie.config.healthThreshold or 50) then _adSuperHeal(hum) end end) table.insert(_adDeathConns, _antiDie.healthConn) _antiDie.diedConn = hum.Died:Connect(function()
if not S.antiDieEnabled or not char.Parent then return end task.wait() if not S.antiDieEnabled or not char.Parent then return end pcall(function() local newHum = Instance.new("Humanoid") newHum.Name = "ReplacedHumanoid" newHum.BreakJointsOnDeath = false newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) local maxH = (hum.MaxHealth and hum.MaxHealth > 0 and hum.MaxHealth ~= math.huge) and hum.MaxHealth or 100 newHum.MaxHealth = maxH newHum.Health = maxH newHum.Parent = char if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = newHum end
if hum.Parent then hum:Destroy() end end) if S.antiDieEnabled then protectCharClean(char) end end) table.insert(_adDeathConns, _antiDie.diedConn) end function F.startAntiDie() S.antiDieEnabled = true _adDisconnectAll() if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end _antiDie.loop = RunService.Heartbeat:Connect(function() if not S.antiDieEnabled then return end local char = LP.Character if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid") local root = char:FindFirstChild("HumanoidRootPart") if not hum then return end _adPreventDamage(root, hum) end) _adHeartConn = _antiDie.loop _adCharConn = LP.CharacterAdded:Connect(function(c) if not S.antiDieEnabled then return end task.defer(function() protectCharClean(c) end) task.spawn(function() for _ = 1, 12 do if not S.antiDieEnabled then return end F.applyAntiReset() task.wait(0.25) end end) end) task.defer(function() protectCharClean(LP.Character) end) F.applyAntiReset() task.spawn(function() for _ = 1, 12 do
if not S.antiDieEnabled then return end F.applyAntiReset() task.wait(0.25) end end) end function F.stopAntiDie() S.antiDieEnabled = false if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end local hum = _antiDie.humanoid _adDisconnectAll() if hum and hum.Parent then pcall(function() hum.BreakJointsOnDeath = true hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end) end local char = LP.Character; local chum = char and char:FindFirstChildOfClass("Humanoid")
if chum then pcall(function() chum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) if chum.MaxHealth == math.huge then chum.MaxHealth = 100 end chum.Health = math.min(chum.Health, chum.MaxHealth) if chum.Health <= 0 then chum.Health = chum.MaxHealth end end) end F.restoreReset() end local ANTI_FLING_MAX_LIN = 160 local ANTI_FLING_MAX_ANG = 45 local ANTI_FLING_AIMBOT_LIN = 220 local ANTI_FLING_AIMBOT_ANG = 60 local function _antiFlingApply(root, char, maxLin, maxAng) if not root or not root.Parent then return end pcall(function() local v = root.AssemblyLinearVelocity
local horiz = Vector3.new(v.X, 0, v.Z) local hMag = horiz.Magnitude if hMag > maxLin then local scale = maxLin / hMag root.AssemblyLinearVelocity = Vector3.new(v.X * scale, v.Y, v.Z * scale) elseif v.Magnitude > maxLin * 1.35 then root.AssemblyLinearVelocity = v.Unit * maxLin end local av = root.AssemblyAngularVelocity if av.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end if char then for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") and p ~= root then local pv = p.AssemblyLinearVelocity local ph = Vector3.new(pv.X, 0, pv.Z)
if ph.Magnitude > maxLin * 1.2 then local scale = (maxLin * 1.05) / ph.Magnitude p.AssemblyLinearVelocity = Vector3.new(pv.X * scale, pv.Y, pv.Z * scale) end if p.AssemblyAngularVelocity.Magnitude > maxAng then p.AssemblyAngularVelocity = Vector3.zero end end end end end) end function F.startAntiFlingShield() S.antiFlingShieldEnabled = true if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end _afsLoop = RunService.Heartbeat:Connect(function() if not S.antiFlingShieldEnabled then return end local char = LP.Character if not char then return end
local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local aimOn = (S.autoBatEnabled == true) or (tpBatEnabled == true) or (S.antiBatBypassEnabled == true) local maxLin = aimOn and ANTI_FLING_AIMBOT_LIN or ANTI_FLING_MAX_LIN local maxAng = aimOn and ANTI_FLING_AIMBOT_ANG or ANTI_FLING_MAX_ANG _antiFlingApply(root, char, maxLin, maxAng) end) end function F.stopAntiFlingShield() S.antiFlingShieldEnabled = false if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end end
local removeAccConn = nil; local removeAccChildConn = nil; local removeAccActive = false local function isProtectedSkinAccessory(accessory) if not accessory then return false end if accessory:GetAttribute("VX7LocalOnly") or accessory:GetAttribute("ZurichSkinAssetId") or accessory:GetAttribute("PVSVisualSkin") then return true end local name = tostring(accessory.Name) return name:find("VX7_LocalOutfit_", 1, true) == 1 or name == "AuFfitAccessory" end local function isHatOrHairAccessory(accessory) if not accessory or not accessory:IsA("Accessory") or isProtectedSkinAccessory(accessory) then return false end local accessoryType = nil pcall(function() accessoryType = accessory.AccessoryType end) if accessoryType == Enum.AccessoryType.Hat or accessoryType == Enum.AccessoryType.Hair then return true end for _, item in ipairs(accessory:GetDescendants()) do if item:IsA("Attachment") and (item.Name == "HatAttachment" or item.Name == "HairAttachment") then return true end end
local lowerName = tostring(accessory.Name):lower() return lowerName:find("hair", 1, true) ~= nil or lowerName:find("hat", 1, true) ~= nil end local function removeCharAccessories(char) if not char then return end for _, child in ipairs(char:GetChildren()) do pcall(function() if child:IsA("Accessory") and isHatOrHairAccessory(child) then child:Destroy() end end) end end function F.startRemoveAccessories() removeAccActive = true; S.removeAccessoriesEnabled = true local function bindCharacter(char) if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end
removeCharAccessories(char) if char then removeAccChildConn = char.ChildAdded:Connect(function(child) if not removeAccActive or not child:IsA("Accessory") then return end task.defer(function() if child.Parent == char then removeCharAccessories(char) end end) end) end end bindCharacter(LP.Character) if removeAccConn then removeAccConn:Disconnect() end removeAccConn = LP.CharacterAdded:Connect(function(char) task.wait(0.15) bindCharacter(char) end) end function F.stopRemoveAccessories() removeAccActive = false; S.removeAccessoriesEnabled = false
if removeAccConn then removeAccConn:Disconnect(); removeAccConn = nil end if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end end local moveProxy = nil function F.ensureProxy() local c = LP.Character if not c then return nil end local root = c:FindFirstChild("HumanoidRootPart") if not root then return nil end if moveProxy and moveProxy.Parent == c then return moveProxy end if moveProxy then moveProxy:Destroy() end
moveProxy = Instance.new("Part"); moveProxy.Name = "CursedHub_MoveProxy"; moveProxy.Size = Vector3.new(1, 1, 1); moveProxy.Transparency = 1; moveProxy.CanCollide = false; moveProxy.Massless = true; moveProxy.Parent = c; local weld = Instance.new("WeldConstraint"); weld.Part0 = root; weld.Part1 = moveProxy; weld.Parent = moveProxy return moveProxy end function F.destroyProxy() if moveProxy then moveProxy:Destroy(); moveProxy = nil end end local infJumpEnabled = false; local holdInfJumpConn = nil; local infJumpInputConns = {}; local INF_JUMP_POWER = 55 local function applyJumpVel(root, y)
if not root or not root.Parent then return end pcall(function() local cv = root.AssemblyLinearVelocity root.AssemblyLinearVelocity = Vector3.new(cv.X, y, cv.Z) end) end local function manualJumpBoost(boost) if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "manual" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if root then applyJumpVel(root, boost or INF_JUMP_POWER) end end local function startHoldInfJump() if holdInfJumpConn then return end holdInfJumpConn = RunService.Heartbeat:Connect(function()
if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "hold" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local isJumpHeld = false pcall(function() isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.ButtonA) or (hum.Jump == true) end) local cv = root.AssemblyLinearVelocity if isJumpHeld and cv.Y < 35 then applyJumpVel(root, INF_JUMP_POWER) end cv = root.AssemblyLinearVelocity
if cv.Y < -120 then applyJumpVel(root, -120) end end) end local function stopHoldInfJump() if holdInfJumpConn then pcall(function() holdInfJumpConn:Disconnect() end) holdInfJumpConn = nil end end function F.startInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {}; stopHoldInfJump() table.insert(infJumpInputConns, UIS.JumpRequest:Connect(function() if not infJumpEnabled then return end if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end))
table.insert(infJumpInputConns, UIS.InputBegan:Connect(function(input, gp) if gp or UIS:GetFocusedTextBox() then return end if not infJumpEnabled then return end if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end end)) if (S.infJumpMode or "hold") == "hold" then startHoldInfJump() end end function F.stopInfJump() stopHoldInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {} end function F.setInfJumpMode(mode)
mode = (mode == "manual") and "manual" or "hold"; S.infJumpMode = mode if infJumpEnabled then F.startInfJump() else stopHoldInfJump() end end local mirrorTPPreviousY = {}; local mirrorTPLastTeleport = 0; local mirrorTPConn = nil local function mirrorTPAimbotActive() return (aimbotEnabled == true) or (tpBatEnabled == true) or (S.autoBatEnabled == true) or (_G.MirrorNormalAimbotOn == true) or (_G.MirrorAntiBypassAimbotOn == true) or (_G.MirrorAntiDesyncAimbotOn == true) or (F.isAimbotBatV2On and F.isAimbotBatV2On() == true) end local MIRROR_TP_DROP_THRESHOLD = 3; local MIRROR_TP_DOWN_Y = -7.00 local function mirrorTPTeleportDown()
local character = LP.Character; local root = character and character:FindFirstChild("HumanoidRootPart"); local humanoid = character and character:FindFirstChildOfClass("Humanoid") if not root or not humanoid or humanoid.Health <= 0 then return end local now = tick() if now - (mirrorTPLastTeleport or 0) < 0.08 then return end mirrorTPLastTeleport = now; local _, yaw = root.CFrame:ToEulerAnglesYXZ(); root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0); root.Velocity = Vector3.zero
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end) end function F.startMirrorTPDown() if mirrorTPConn then return end S.mirrorTPDownEnabled = true _G.MirrorSetTPDown = function(enabled) S.mirrorTPDownEnabled = enabled == true if not S.mirrorTPDownEnabled then mirrorTPPreviousY = {} end end mirrorTPConn = RunService.Heartbeat:Connect(function() if not S.mirrorTPDownEnabled then return end if not mirrorTPAimbotActive() then if next(mirrorTPPreviousY) then mirrorTPPreviousY = {} end return end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then local currentY = tr.Position.Y; local previousY = mirrorTPPreviousY[plr.UserId] if previousY and (previousY - currentY) >= MIRROR_TP_DROP_THRESHOLD then pcall(mirrorTPTeleportDown); mirrorTPPreviousY = {} return end mirrorTPPreviousY[plr.UserId] = currentY end end end end) end function F.stopMirrorTPDown() S.mirrorTPDownEnabled = false if mirrorTPConn then pcall(function() mirrorTPConn:Disconnect() end) mirrorTPConn = nil end mirrorTPPreviousY = {} end function F.startFloat() end function F.stopFloat() end
function F.setFloat(on) end function F.toggleFloat() end function F.getFloatSpeed() return 0 end function F.setFloatModeSpeed(v) end function F.cycleFloatMode() return "normal" end function F.setMirrorTPDown(on) if on then F.startMirrorTPDown() else F.stopMirrorTPDown() end if VS.setMirrorTPVisual then VS.setMirrorTPVisual(on == true) end end local aimbotEnabled = false; local tpBatEnabled = false; local tpBatMode = 1; local TP_BAT_KEY = Enum.KeyCode.V; local TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY; local setTPBatVisual, tpBatUIState, tpBatModeLbl = nil, nil, nil
local setAimbotState, setTPBatState, getTPBatMode, findBatTool, getClosestAliveRoot local TP_BAT_MODES local startAimbot, stopAimbot, startTPBat, stopTPBat local function __initAimbotTPBat() 
-- ===== BAT V2 (portado da primeira source / Macho Hub) =====
local BV2 = {
    on = false,
    conn = nil,
    pingConn = nil,
    cd = false,
    speed = 90,
    lastSwing = 0,
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
    realPingMs = 0,
}

local BV2CFG = {
    FOLLOW_SPEED = 92,
    ACTIVATE_DISTANCE = 16,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.28,
    PREDICT_AHEAD = 4.5,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 1 / 60,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
}

local function batV2FindTool()
    local char = LP.Character
    if not char then return nil end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local n = equipped.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then return equipped end
    end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

local function bv2Average(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total += v end
    return total / #history
end

local function bv2Push(history, value, maximum)
    table.insert(history, value)
    if #history > maximum then table.remove(history, 1) end
end

local function bv2ResetTarget()
    BV2.targetPlayer = nil
    BV2.lastTargetPos = nil
    BV2.targetVelocity = Vector3.zero
    BV2.smoothedVelocity = Vector3.zero
    BV2.velocityHistory = {}
    BV2.accelerationHistory = {}
    BV2.aerialVelocityHistory = {}
    BV2.previousDirection = nil
    BV2.airborneTime = 0
end

local function batV2ClosestRoot()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = targetRoot
                end
            end
        end
    end
    return closest, closestDistance
end

local function bv2ClosestPlayer(root)
    local closestDistance, closestPlayer = math.huge, nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum = player.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local d = (root.Position - tRoot.Position).Magnitude
                if d < closestDistance then
                    closestDistance = d
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function bv2ApplyAngularAim(root, direction)
    if direction.Magnitude < 0.01 then return end
    local crossVector = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80 or Vector3.zero
end

local function bv2UpdatePing()
    local ok, value = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then BV2.realPingMs = math.floor(value) end
    BV2.currentPing = math.clamp(BV2.realPingMs / 1000, BV2CFG.MIN_PING_COMPENSATION, BV2CFG.MAX_PING_COMPENSATION)
end

local function batV2Swing()
    local now = tick()
    if now - (BV2.lastSwing or 0) < 0.05 then return end
    if S.autoSwingEnabled == false then return end
    BV2.lastSwing = now
    pcall(function()
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local tool = batV2FindTool()
        if not tool then return end
        if tool.Parent ~= char and humanoid then
            pcall(function() humanoid:EquipTool(tool) end)
        end
        pcall(function() tool:Activate() end)
    end)
end

local function batV2Stop()
    BV2.on = false
    if BV2.conn then
        pcall(function() BV2.conn:Disconnect() end)
        BV2.conn = nil
    end
    BV2.pingConn = nil

    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then pcall(function() humanoid.AutoRotate = true end) end
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
    bv2ResetTarget()
    BV2.lastActivationTime = 0
    BV2.cd = false
end

local function batV2Start()
    if BV2.conn then
        pcall(function() BV2.conn:Disconnect() end)
        BV2.conn = nil
    end

    pcall(function() if tpBatEnabled and stopTPBat then stopTPBat() end end)
    pcall(function() if F.stopAimbotV2 then F.stopAimbotV2() end end)
    pcall(function() if S.aimbotV2SetVisual then S.aimbotV2SetVisual(false) end end)
    pcall(function() if aimbotEnabled and stopAimbot then stopAimbot() end end)
    pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end end)

    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    bv2ResetTarget()
    BV2.on = true
    humanoid.AutoRotate = false

    local tool = batV2FindTool()
    if tool and tool.Parent ~= char then
        pcall(function() humanoid:EquipTool(tool) end)
    end

    if not BV2.pingConn then
        BV2.pingConn = true
        task.spawn(function()
            while BV2.pingConn do pcall(bv2UpdatePing); task.wait(0.5) end
        end)
    end

    BV2.conn = RunService.RenderStepped:Connect(function(deltaTime)
        if not BV2.on then batV2Stop(); return end

        BV2CFG.FOLLOW_SPEED = math.clamp(tonumber(BV2.speed) or 90, 1, 200)

        local cChar = LP.Character
        local cRoot = cChar and cChar:FindFirstChild("HumanoidRootPart")
        local cHum = cChar and cChar:FindFirstChildOfClass("Humanoid")
        if not cRoot or not cHum or cHum.Health <= 0 then return end
        cHum.AutoRotate = false
        root, humanoid = cRoot, cHum

        tool = cChar:FindFirstChildOfClass("Tool") or batV2FindTool()
        if tool and tool.Parent ~= cChar then
            pcall(function() cHum:EquipTool(tool) end)
        end

        BV2.targetPlayer = bv2ClosestPlayer(root)
        local tChar = BV2.targetPlayer and BV2.targetPlayer.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        if not tRoot or not tHum or tHum.Health <= 0 then bv2ResetTarget(); return end

        local targetPos = tRoot.Position
        local safeDt = math.max(deltaTime, 1 / 240)

        if BV2.lastTargetPos then
            local rawVelocity = (targetPos - BV2.lastTargetPos) / safeDt
            local velocityDelta = rawVelocity - BV2.targetVelocity
            if velocityDelta.Magnitude > BV2CFG.MAX_VELOCITY_CHANGE then
                rawVelocity = BV2.targetVelocity + velocityDelta.Unit * BV2CFG.MAX_VELOCITY_CHANGE
            end
            local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
            if horizontal.Magnitude > BV2CFG.MAX_HORIZONTAL_VELOCITY then
                horizontal = horizontal.Unit * BV2CFG.MAX_HORIZONTAL_VELOCITY
                rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
            end
            bv2Push(BV2.accelerationHistory, (rawVelocity - BV2.targetVelocity) / safeDt, 4)
            bv2Push(BV2.velocityHistory, rawVelocity, 8)
            BV2.targetVelocity = rawVelocity
            BV2.smoothedVelocity = BV2.smoothedVelocity:Lerp(rawVelocity, BV2CFG.VELOCITY_SMOOTHING)
        end
        BV2.lastTargetPos = targetPos

        local airborne = tHum.FloorMaterial == Enum.Material.Air
        BV2.airborneTime = airborne and (BV2.airborneTime + safeDt) or 0
        if airborne and BV2.airborneTime >= BV2CFG.MIN_AIRBORNE_TIME then
            bv2Push(BV2.aerialVelocityHistory, BV2.targetVelocity, 6)
        elseif not airborne then
            BV2.aerialVelocityHistory = {}
        end

        local predictionVelocity = BV2.smoothedVelocity
        if airborne and #BV2.aerialVelocityHistory > 0 then
            local aerial = bv2Average(BV2.aerialVelocityHistory)
            predictionVelocity = Vector3.new(aerial.X, BV2.targetVelocity.Y, aerial.Z) * BV2CFG.AIR_CONTROL_FACTOR
        end

        local quickTurn = false
        local horizontalVelocity = Vector3.new(BV2.targetVelocity.X, 0, BV2.targetVelocity.Z)
        if horizontalVelocity.Magnitude > 5 then
            local direction = horizontalVelocity.Unit
            if BV2.previousDirection and BV2.previousDirection:Dot(direction) < 0.5 then
                quickTurn = tick() - BV2.lastDirectionChangeTime < BV2CFG.DIRECTION_CHANGE_DETECTION_TIME
                BV2.lastDirectionChangeTime = tick()
            end
            BV2.previousDirection = direction
        end

        local serverDelay = BV2.currentPing + BV2CFG.SERVER_TICKRATE
        if quickTurn then serverDelay *= BV2CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end

        local predicted = targetPos + predictionVelocity * serverDelay
            + bv2Average(BV2.accelerationHistory) * BV2CFG.ACCELERATION_PREDICTION_WEIGHT * serverDelay * serverDelay * 0.5

        local leadTime = BV2CFG.PREDICTION_TIME * 1.1
        if airborne then
            predicted += predictionVelocity * leadTime + Vector3.new(0, -0.5 * BV2CFG.GRAVITY * leadTime * leadTime, 0)
        else
            predicted += predictionVelocity * leadTime
        end

        local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
        if flatPrediction.Magnitude > 1 then
            predicted += flatPrediction.Unit * BV2CFG.PREDICT_AHEAD
        end

        local toTarget = predicted - root.Position
        bv2ApplyAngularAim(root, toTarget)

        if (targetPos - root.Position).Magnitude <= BV2CFG.ACTIVATE_DISTANCE
            and tick() - BV2.lastActivationTime >= 0.3 then
            if tool then pcall(function() tool:Activate() end) end
            BV2.lastActivationTime = tick()
        end

        if toTarget.Magnitude > BV2CFG.MIN_FOLLOW_DISTANCE then
            root.AssemblyLinearVelocity = toTarget.Unit * BV2CFG.FOLLOW_SPEED
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
end


-- ===== AIMBOT V2 (portado da segunda source / Eclipse Hub - Zurich predictive) =====
local AV2 = {
    on = false, conn = nil, pingConn = nil,
    targetPlayer = nil, lastTargetPos = nil,
    targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero,
    velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {},
    previousDirection = nil, lastDirectionChangeTime = 0,
    airborneTime = 0, lastYVelocity = 0, lastActivationTime = 0,
    currentPing = 0.1, realPingMs = 0,
}
local AV2CFG = {
    FOLLOW_SPEED = 92, ACTIVATE_DISTANCE = 16, MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.28, PREDICT_AHEAD = 4.5, MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80, SERVER_TICKRATE = 1 / 60,
    MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
}
local function av2Average(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total += v end
    return total / #history
end
local function av2Push(history, value, maximum)
    table.insert(history, value)
    if #history > maximum then table.remove(history, 1) end
end
local function av2ResetTarget()
    AV2.targetPlayer = nil; AV2.lastTargetPos = nil
    AV2.targetVelocity = Vector3.zero; AV2.smoothedVelocity = Vector3.zero
    AV2.velocityHistory = {}; AV2.accelerationHistory = {}
    AV2.aerialVelocityHistory = {}; AV2.verticalVelocityHistory = {}
    AV2.previousDirection = nil; AV2.airborneTime = 0; AV2.lastYVelocity = 0
end
local function av2Nearest(root)
    local nearest, nearestDistance = nil, math.huge
    for _, candidate in ipairs(Players:GetPlayers()) do
        if candidate ~= LP and candidate.Character then
            local tRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
            local tHum = candidate.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local d = (root.Position - tRoot.Position).Magnitude
                if d < nearestDistance then nearest, nearestDistance = candidate, d end
            end
        end
    end
    return nearest
end
local function av2Rotate(root, direction)
    if direction.Magnitude < 0.01 then return end
    local axis = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
end
local function av2SamplePing()
    local ok, value = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then AV2.realPingMs = math.floor(value) end
    AV2.currentPing = math.clamp(AV2.realPingMs / 1000, AV2CFG.MIN_PING_COMPENSATION, AV2CFG.MAX_PING_COMPENSATION)
end
local function av2Stop()
    AV2.on = false
    if AV2.conn then pcall(function() AV2.conn:Disconnect() end); AV2.conn = nil end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum then pcall(function() hum.AutoRotate = true end) end
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
    av2ResetTarget()
    AV2.lastActivationTime = 0
end
local function av2Start()
    if AV2.on then return end
    pcall(function() if F.stopAimbotBatV2 then F.stopAimbotBatV2() end end)
    pcall(function() if stopAimbot then stopAimbot() end end)
    pcall(function() if tpBatEnabled and setTPBatState then setTPBatState(false) end end)
    pcall(function() if VS and VS.setTPBatVisual then VS.setTPBatVisual(false) end end)
    pcall(function() if VS and VS.setAimbotVisual then VS.setAimbotVisual(false) end end)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    av2Stop()
    AV2.on = true
    hum.AutoRotate = false
    local bat = batV2FindTool and batV2FindTool() or nil
    if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
    if not AV2.pingConn then
        AV2.pingConn = true
        task.spawn(function()
            while AV2.pingConn do pcall(av2SamplePing); task.wait(0.5) end
        end)
    end
    AV2.conn = RunService.RenderStepped:Connect(function(dt)
        if not AV2.on then av2Stop(); return end
        local cChar = LP.Character
        local cRoot = cChar and cChar:FindFirstChild("HumanoidRootPart")
        local cHum = cChar and cChar:FindFirstChildOfClass("Humanoid")
        if not cRoot or not cHum or cHum.Health <= 0 then return end
        cHum.AutoRotate = false
        root, hum = cRoot, cHum
        bat = cChar:FindFirstChildOfClass("Tool") or (batV2FindTool and batV2FindTool() or nil)
        if bat and bat.Parent ~= cChar then pcall(function() cHum:EquipTool(bat) end) end

        AV2.targetPlayer = av2Nearest(root)
        local tChar = AV2.targetPlayer and AV2.targetPlayer.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        if not tRoot or not tHum or tHum.Health <= 0 then av2ResetTarget(); return end
        local targetPos = tRoot.Position
        local safeDt = math.max(dt, 1 / 240)
        if AV2.lastTargetPos then
            local rawVelocity = (targetPos - AV2.lastTargetPos) / safeDt
            local velocityDelta = rawVelocity - AV2.targetVelocity
            if velocityDelta.Magnitude > AV2CFG.MAX_VELOCITY_CHANGE then
                rawVelocity = AV2.targetVelocity + velocityDelta.Unit * AV2CFG.MAX_VELOCITY_CHANGE
            end
            local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
            if horizontal.Magnitude > AV2CFG.MAX_HORIZONTAL_VELOCITY then
                horizontal = horizontal.Unit * AV2CFG.MAX_HORIZONTAL_VELOCITY
                rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
            end
            av2Push(AV2.accelerationHistory, (rawVelocity - AV2.targetVelocity) / safeDt, 4)
            av2Push(AV2.velocityHistory, rawVelocity, 8)
            av2Push(AV2.verticalVelocityHistory, rawVelocity.Y, 5)
            AV2.targetVelocity = rawVelocity
            AV2.smoothedVelocity = AV2.smoothedVelocity:Lerp(rawVelocity, AV2CFG.VELOCITY_SMOOTHING)
        end
        AV2.lastTargetPos = targetPos

        local airborne = tHum.FloorMaterial == Enum.Material.Air
        AV2.airborneTime = airborne and (AV2.airborneTime + safeDt) or 0
        if airborne and AV2.airborneTime >= AV2CFG.MIN_AIRBORNE_TIME then
            av2Push(AV2.aerialVelocityHistory, AV2.targetVelocity, 6)
        elseif not airborne then
            AV2.aerialVelocityHistory = {}
        end
        local predictionVelocity = AV2.smoothedVelocity
        if airborne and #AV2.aerialVelocityHistory > 0 then
            local aerial = av2Average(AV2.aerialVelocityHistory)
            predictionVelocity = Vector3.new(aerial.X, AV2.targetVelocity.Y, aerial.Z) * AV2CFG.AIR_CONTROL_FACTOR
        end
        local quickTurn = false
        local horizontalVelocity = Vector3.new(AV2.targetVelocity.X, 0, AV2.targetVelocity.Z)
        if horizontalVelocity.Magnitude > 5 then
            local direction = horizontalVelocity.Unit
            if AV2.previousDirection and AV2.previousDirection:Dot(direction) < 0.5 then
                quickTurn = tick() - AV2.lastDirectionChangeTime < AV2CFG.DIRECTION_CHANGE_DETECTION_TIME
                AV2.lastDirectionChangeTime = tick()
            end
            AV2.previousDirection = direction
        end
        local serverDelay = AV2.currentPing + AV2CFG.SERVER_TICKRATE
        if quickTurn then serverDelay *= AV2CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
        local predicted = targetPos + predictionVelocity * serverDelay
        local acceleration = av2Average(AV2.accelerationHistory)
        predicted += acceleration * AV2CFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
        local predictionTime = AV2CFG.PREDICTION_TIME * 1.1
        if airborne then
            predicted += predictionVelocity * predictionTime
            predicted += Vector3.new(0, -0.5 * AV2CFG.GRAVITY * predictionTime * predictionTime, 0)
        else
            predicted += predictionVelocity * predictionTime
        end
        local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
        if flatPrediction.Magnitude > 1 then predicted += flatPrediction.Unit * AV2CFG.PREDICT_AHEAD end
        local toTarget = predicted - root.Position
        av2Rotate(root, toTarget)
        if (targetPos - root.Position).Magnitude <= AV2CFG.ACTIVATE_DISTANCE and tick() - AV2.lastActivationTime >= 0.3 then
            if bat then pcall(function() bat:Activate() end) end
            AV2.lastActivationTime = tick()
        end
        if toTarget.Magnitude > AV2CFG.MIN_FOLLOW_DISTANCE then
            local speed = math.clamp(AV2CFG.FOLLOW_SPEED, 1, 160)
            root.AssemblyLinearVelocity = toTarget.Unit * speed
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
end
F.startAimbotV2 = av2Start
F.stopAimbotV2 = function() AV2.pingConn = nil; av2Stop() end
F.isAimbotV2On = function() return AV2.on == true end
F.setAimbotV2State = function(on)
    if on then
        S.aimbotMode = 2
        av2Start()
    else
        F.stopAimbotV2()
    end
    if S.aimbotV2SetVisual then pcall(function() S.aimbotV2SetVisual(AV2.on == true) end) end
    if VS.setAimbotVisual then pcall(function() VS.setAimbotVisual(AV2.on == true or aimbotEnabled == true) end) end
    if S.refreshAimbotMode then S.refreshAimbotMode() end
    if _G._VersincRefreshMobileStates then pcall(_G._VersincRefreshMobileStates) end
    if F.saveConfig then pcall(function() F.saveConfig() end) end
end
F.toggleAimbotV2 = function() F.setAimbotV2State(not AV2.on) end

F.startAimbotBatV2 = batV2Start
F.stopAimbotBatV2 = batV2Stop
F.isAimbotBatV2On = function() return BV2.on == true end
F.toggleAimbotBatV2 = function()
    if BV2.on then batV2Stop() else batV2Start() end
    if S.batV2SetVisual then pcall(function() S.batV2SetVisual(BV2.on == true) end) end
    if _G._VersincRefreshMobileStates then pcall(_G._VersincRefreshMobileStates) end
    if F.saveConfig then pcall(function() F.saveConfig() end) end
end
aimbotEnabled = false; local aimbotConn = nil; tpBatEnabled = false; local aimbotSwingCooldown = false; local AIMBOT_SPEED = 95; local AIMBOT_VERT_SPEED = 52; local AIMBOT_DISTANCE = -2.8; local AIMBOT_HEIGHT = 4.75; local AIMBOT_V_OFFSET = 1; local AIMBOT_MAX_TURN_RATE = 28; local AIMBOT_SWING_DIST = 5; local AIMBOT_SWING_CD = 0.3; local _aimbotLastSwing = 0 findBatTool = function()
local char = LP.Character if not char then return nil end for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end end return nil end local function swingBatTool() if aimbotSwingCooldown then return end aimbotSwingCooldown = true pcall(function() local bat = findBatTool()
local char = LP.Character if not bat or not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end local remote = bat:FindFirstChildOfClass("RemoteEvent") if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end end) task.delay(0.09, function() aimbotSwingCooldown = false end) end local _closestCache, _closestCacheAt = nil, 0 getClosestAliveRoot = function() local now = os.clock(); local ttl = _IS_MOBILE and 0.07 or 0.025
if _closestCache and (now - _closestCacheAt) < ttl then if _closestCache.Parent then return _closestCache end end local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local d = (tRoot.Position - root.Position).Magnitude if d < minDist then
minDist = d; closest = tRoot end end end end _closestCache, _closestCacheAt = closest, now return closest end

-- ===== AIMBOT V1 (substituido pela logica da segunda source / adapt bat aimbot) =====
local BAT_AIMBOT_SPEED = 88
local _aimbotPrevAutoRotate = nil
startAimbot = function()
    if aimbotConn then return end
    if tpBatEnabled then return end
    pcall(function()
        if K7 and K7.bodyLockEnabled then
            S._bodyLockPausedByCombat = true
            if K7.stopBodyLock then K7.stopBodyLock() end
            if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(false) end
        end
    end)

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _aimbotPrevAutoRotate == nil then _aimbotPrevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    aimbotEnabled = true

    aimbotConn = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        if tpBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if hum.AutoRotate then hum.AutoRotate = false end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatTool and findBatTool() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = getClosestAliveRoot and getClosestAliveRoot() or nil
        if not target then return end

        local targetVelocity = target.AssemblyLinearVelocity
        local position = root.Position
        local targetPos = target.Position

        local lead = targetPos + targetVelocity * 0.14 + target.CFrame.LookVector * 0.3 - position
        local flat = Vector3.new(lead.X, 0, lead.Z)
        local unit = flat.Magnitude > 0 and flat.Unit or Vector3.zero

        local vertical = (targetPos.Y + 3.7 - position.Y) * 19.5 + targetVelocity.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            vertical = math.max(vertical, 13)
        end

        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(
            Vector3.new(unit.X * BAT_AIMBOT_SPEED, math.clamp(vertical, -70, 110), unit.Z * BAT_AIMBOT_SPEED),
            0.2
        )

        local aimAt = targetPos + targetVelocity * math.clamp(targetVelocity.Magnitude / 150, 0.05, 0.2)
        if (aimAt - position).Magnitude > 0.1 then
            local goal = CFrame.lookAt(position, aimAt)
            local rx, ry, rz = (root.CFrame:Inverse() * goal):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -2.5, 2.5) * 42,
                math.clamp(ry, -2.5, 2.5) * 42,
                math.clamp(rz, -2.5, 2.5) * 42
            ))
        end

        if (root.Position - targetPos).Magnitude <= 8 then
            if swingBatTool then pcall(swingBatTool) end
        end
    end)
end
stopAimbot = function()
    aimbotEnabled = false
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    if not tpBatEnabled then
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if hum2 then
            hum2.AutoRotate = (_aimbotPrevAutoRotate == nil) and true or _aimbotPrevAutoRotate
            hum2.PlatformStand = false
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    _aimbotPrevAutoRotate = nil
    aimbotSwingCooldown = false
    pcall(function()
        if S._bodyLockPausedByCombat and not tpBatEnabled and K7 and K7.startBodyLock then
            S._bodyLockPausedByCombat = false
            K7.startBodyLock()
            if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end
        end
    end)
end
setAimbotState = function(on)
 if on then
  pcall(function() if F.stopAimbotBatV2 then F.stopAimbotBatV2() end end)
  pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end)
  if (S.aimbotMode or 1) == 2 then
   pcall(function() if stopAimbot then stopAimbot() end end)
   av2Start()
  else
   if AV2.on then F.stopAimbotV2() end
   startAimbot()
  end
 else
  if AV2.on then F.stopAimbotV2() end
  pcall(function() if stopAimbot then stopAimbot() end end)
 end
 if VS.setAimbotVisual then VS.setAimbotVisual(aimbotEnabled or AV2.on) end
 if S.aimbotV2SetVisual then S.aimbotV2SetVisual(AV2.on) end
 if _G._VersincRefreshMobileStates then pcall(_G._VersincRefreshMobileStates) end
 if F.saveConfig then pcall(function() F.saveConfig(true) end) end
end
F.setAimbotMode = function(mode)
 mode = mode == 2 and 2 or 1
 if S.aimbotMode == mode then return end
 local wasOn = aimbotEnabled or AV2.on
 if wasOn then setAimbotState(false) end
 S.aimbotMode = mode
 if wasOn then setAimbotState(true) end
 if S.refreshAimbotMode then S.refreshAimbotMode() end
 if F.saveConfig then pcall(function() F.saveConfig() end) end
end
local function isAimbotAnyOn() return aimbotEnabled == true or AV2.on == true or (F.isAimbotBatV2On and F.isAimbotBatV2On() == true) end local tpBatConn, tpBatSwingCd, tpBatWasAimbot = nil, false, false TP_BAT_MODES = { [1] = { name = "V1", speed = 110, height = 1.1, hitDist = 15, doTP = true, sureHit = true }, }
tpBatMode = 1
 getTPBatMode = function() return TP_BAT_MODES[tpBatMode] or TP_BAT_MODES[1] end local function tpBatSwing() if tpBatSwingCd then return end if S.autoSwingEnabled == false then return end tpBatSwingCd = true task.delay(0.02, function() tpBatSwingCd = false end) pcall(function() local char = LP.Character if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid"); local bat = findBatTool and findBatTool() or nil if not bat then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("bat") or n:find("slap") or n:find("glove") then bat = t; break end end end end if not bat then local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("bat") or n:find("slap") or n:find("glove") then bat = t; break end end end end end
if not bat or not hum then return end if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end for _ = 1, 3 do pcall(function() bat:Activate() end) local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildWhichIsA("RemoteEvent") if remote then pcall(function() remote:FireServer() end) end end local rf0 = bat:FindFirstChildWhichIsA("RemoteFunction") if rf0 then pcall(function() rf0:InvokeServer() end) end end) end local function tpBatAntiDie(char, hum) pcall(function() hum.MaxHealth = math.max(hum.MaxHealth, 100) hum.Health = hum.MaxHealth; hum.BreakJointsOnDeath = false; hum.RequiresNeck = false; hum.PlatformStand = false; hum.Sit = false pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false); hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end) local st = hum:GetState() if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.Running) end if not char:FindFirstChild("K7TPBatFF") then
local ff = Instance.new("ForceField"); ff.Name = "K7TPBatFF"; ff.Visible = false; ff.Parent = char end end) end local function tpBatAntiFling(char, root) pcall(function() local maxLin, maxAng = 85, 15 local v = root.AssemblyLinearVelocity if v.Magnitude > maxLin then root.AssemblyLinearVelocity = v.Unit * maxLin end if root.AssemblyAngularVelocity.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") and p ~= root then if p.AssemblyLinearVelocity.Magnitude > maxLin * 1.1 then
p.AssemblyLinearVelocity = p.AssemblyLinearVelocity.Unit * maxLin end if p.AssemblyAngularVelocity.Magnitude > maxAng then p.AssemblyAngularVelocity = Vector3.zero end end end end) end local function tpBatApplyBypass(root, targetRoot) if not root or not targetRoot then return end pcall(function() if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end end) pcall(function() local m = targetRoot.Parent local hum = m and m:FindFirstChildOfClass("Humanoid") if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end end) end
local _tpBatBypassCD = false
local function tpBatBypassSwing() if _tpBatBypassCD then return end if S.autoSwingEnabled == false then return end _tpBatBypassCD = true task.delay(0.015, function() _tpBatBypassCD = false end) pcall(function() local char = LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") local bat = findBatTool and findBatTool() or nil if not bat or not hum then return end if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end for _ = 1, 4 do pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end local rf = bat:FindFirstChildWhichIsA("RemoteFunction") if rf then pcall(function() rf:InvokeServer() end) end end) end
local function tpBatLoopV1() return RunService.Heartbeat:Connect(function() if not tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum or hum.Health <= 0 then return end pcall(function() local bat = findBatTool and findBatTool() or nil
if bat and bat.Parent ~= char then hum:EquipTool(bat) end end) tpBatAntiDie(char, hum) local targetRoot = getClosestAliveRoot and getClosestAliveRoot() or nil if not targetRoot or not targetRoot.Parent then return end pcall(function() if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end end) local back = targetRoot.CFrame.LookVector
local flatBack = Vector3.new(back.X, 0, back.Z); local offset = (flatBack.Magnitude < 0.05) and Vector3.new(0, 1.1, 1.6) or (Vector3.new(0, 1.1, 0) - flatBack.Unit * 1.6); local targetPos = targetRoot.Position + offset; local dist = (root.Position - targetPos).Magnitude if dist > 3 then root.CFrame = CFrame.new(targetPos, targetRoot.Position); root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero elseif dist > 1.1 then local dir = targetPos - root.Position; local flatDir = Vector3.new(dir.X, 0, dir.Z) if flatDir.Magnitude > 0.05 then
root.AssemblyLinearVelocity = flatDir.Unit * math.min(130, dist * 18) + Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.2, 0) end local flat = Vector3.new(targetRoot.Position.X - root.Position.X, 0, targetRoot.Position.Z - root.Position.Z) if flat.Magnitude > 0.1 then root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit) end else local flat = Vector3.new(targetRoot.Position.X - root.Position.X, 0, targetRoot.Position.Z - root.Position.Z) if flat.Magnitude > 0.1 then root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit) end
local v = root.AssemblyLinearVelocity; root.AssemblyLinearVelocity = Vector3.new(v.X * 0.5, math.max(v.Y, -10), v.Z * 0.5) end pcall(function() local cam = workspace.CurrentCamera if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position) end end) tpBatApplyBypass(root, targetRoot) tpBatSwing() tpBatBypassSwing() tpBatSwing() tpBatAntiFling(char, root) end) end local _v2StickyTarget = nil
local function tpBatLoopV2()
-- ================= TP BAT V2 (motor Flow/Blod classic - portado e melhorado) =================
local _v2Token = 0
local function getClosestRootV2()
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root then return nil, math.huge end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist = dist; closest = tRoot end
end
end
end
return closest, minDist
end
pcall(function()
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then
hum0.AutoRotate = false
pcall(function()
hum0.BreakJointsOnDeath = false
hum0:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)
end
end)
-- loop de TP + camera + desync do rep root (roda em paralelo ao chase)
_v2Token = _v2Token + 1
local token = _v2Token
task.spawn(function()
while tpBatEnabled and tpBatMode == 2 and token == _v2Token do
task.wait(0.05)
if not tpBatEnabled or tpBatMode ~= 2 then break end
local ok = pcall(function()
local target = select(1, getClosestRootV2())
if not target then return end
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local targetPos = target.Position + Vector3.new(0, 0.9, 0)
if (hrp.Position - targetPos).Magnitude > 8 then
hrp.CFrame = CFrame.new(targetPos)
hrp.AssemblyAngularVelocity = Vector3.zero
end
local cam = workspace.CurrentCamera
if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
if sethiddenproperty then
pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", target) end)
end
end)
if not ok then task.wait(0.05) end
end
end)
-- chase loop (RenderStepped): velocidade + altura + giro suave
return RunService.RenderStepped:Connect(function()
if not tpBatEnabled or tpBatMode ~= 2 then return end
local char = LP.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum or hum.Health <= 0 then return end
if tpBatAntiDie then tpBatAntiDie(char, hum) end
if not char:FindFirstChildOfClass("Tool") then
pcall(function()
local bat = findBatTool and findBatTool() or nil
if bat then hum:EquipTool(bat) end
end)
end
local target, targetDist = getClosestRootV2()
if not target then return end
tpBatApplyBypass(root, target)
local myPos = root.Position
local targetPos = target.Position
local direction = targetPos - myPos
local flatDir = Vector3.new(direction.X, 0, direction.Z)
if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
local chaseSpeed = 85
local desiredHeight = targetPos.Y + 3.7
local yVel = (desiredHeight - myPos.Y) * 19.5
if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
yVel = math.clamp(yVel, -70, 110)
local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
local toTarget = targetPos - myPos
if toTarget.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(myPos, targetPos)
local diffCF = root.CFrame:Inverse() * goalCF
local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
rx = math.clamp(rx, -2.5, 2.5)
ry = math.clamp(ry, -2.5, 2.5)
rz = math.clamp(rz, -2.5, 2.5)
root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
end
if targetDist <= 13 then tpBatSwing() tpBatBypassSwing() end
end)
end
local function tpBatLoopV3() local sureCD = false local function sureHitSwing() if S.autoSwingEnabled == false then return end if sureCD then return end sureCD = true pcall(function() local bat = findBatTool and findBatTool() or nil local char = LP.Character if not bat or not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then
pcall(function() hum:EquipTool(bat) end) end for _ = 1, 3 do pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end local rf = bat:FindFirstChildWhichIsA("RemoteFunction") if rf then pcall(function() rf:InvokeServer() end) end end) task.delay(0.045, function() sureCD = false end) end local function camLookFlat() local cam = workspace.CurrentCamera local look if cam then look = cam.CFrame.LookVector else
local c = LP.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); look = r and r.CFrame.LookVector or Vector3.new(0, 0, -1) end local flat = Vector3.new(look.X, 0, look.Z) if flat.Magnitude < 0.05 then flat = Vector3.new(0, 0, -1) end return flat.Unit end return RunService.Heartbeat:Connect(function() if not tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum or hum.Health <= 0 then return end
if tpBatAntiDie then tpBatAntiDie(char, hum) end pcall(function() local bat = findBatTool and findBatTool() or nil if bat and bat.Parent ~= char then hum:EquipTool(bat) end end) local targetRoot = getClosestAliveRoot and getClosestAliveRoot() or nil if not targetRoot or not targetRoot.Parent then return end pcall(function() if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end end) local look = camLookFlat()
local tVel = targetRoot.AssemblyLinearVelocity or Vector3.zero; local pred = targetRoot.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.08; local standDist = 2.0; local standPos = pred - look * standDist + Vector3.new(0, 0.55, 0); local faceAt = Vector3.new(pred.X, standPos.Y, pred.Z); local goal = CFrame.lookAt(standPos, faceAt); root.CFrame = root.CFrame:Lerp(goal, 0.62); local v = root.AssemblyLinearVelocity; root.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, v.Y, v.Z * 0.35) pcall(function() local cam = workspace.CurrentCamera if cam then
cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position + Vector3.new(0, 0.5, 0)) end end) tpBatApplyBypass(root, targetRoot) sureHitSwing() tpBatBypassSwing() if tpBatAntiFling then tpBatAntiFling(char, root) end end) end startTPBat = function() pcall(function() if F.stopAimbotBatV2 then F.stopAimbotBatV2() end end) if tpBatConn then pcall(function() tpBatConn:Disconnect() end) tpBatConn = nil end tpBatEnabled = true if tpBatMode ~= 1 and tpBatMode ~= 2 and tpBatMode ~= 3 then tpBatMode = 1 end pcall(function() if K7 and K7.bodyLockEnabled then S._bodyLockPausedByCombat = true if K7.stopBodyLock then K7.stopBodyLock() end end end) if aimbotEnabled or (S.antiBatBypassEnabled == true) then
tpBatWasAimbot = true pcall(function() if stopAimbot then stopAimbot() end end) pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) else tpBatWasAimbot = false end if S.autoBatEnabled then pcall(function() if S.disableAutoBat then S.disableAutoBat() end end) end pcall(function() if F.destroyProxy then F.destroyProxy() end end) local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then hum0.AutoRotate = false pcall(function() hum0.BreakJointsOnDeath = false hum0:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) end
tpBatMode = 1 tpBatConn = tpBatLoopV1() if tpBatUIState then tpBatUIState(true) end if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(true) end) end end stopTPBat = function() tpBatEnabled = false if tpBatConn then pcall(function() tpBatConn:Disconnect() end) tpBatConn = nil end tpBatSwingCd = false; local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then root.AssemblyAngularVelocity = Vector3.zero pcall(function()
if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", root) end end) end pcall(function() if c then local ff = c:FindFirstChild("K7TPBatFF") if ff then ff:Destroy() end end end) local hum2 = c and c:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate = true pcall(function() hum2.BreakJointsOnDeath = true hum2.RequiresNeck = true; hum2:SetStateEnabled(Enum.HumanoidStateType.Dead, true); hum2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true); hum2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true); hum2:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
end) end if tpBatWasAimbot then tpBatWasAimbot = false task.defer(function() if not tpBatEnabled and setAimbotState then setAimbotState(true) if VS and VS.setAimbotVisual then pcall(function() VS.setAimbotVisual(true) end) end end end) end if tpBatUIState then tpBatUIState(false) end if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(false) end) end task.defer(function() pcall(function() if S._bodyLockPausedByCombat and not aimbotEnabled and not tpBatEnabled and K7 and K7.startBodyLock then S._bodyLockPausedByCombat = false; K7.startBodyLock()
if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end end end) end) end setTPBatState = function(on) if on then startTPBat() else stopTPBat() end end local antiBatBypassLockEnabled = false; local AceAntiBypassAimbot = { conn = nil, swingCooldown = false, prevAutoRotate = nil }; local AceAntiBypassAimbotSpeed = 85; local AceAntiBypassLaggerAimbotSpeed = 40 local function GetAntiBypassAimbotSpeed() if S.laggerToggled then return tonumber(AceAntiBypassLaggerAimbotSpeed) or 40 end return tonumber(AceAntiBypassAimbotSpeed) or 85 end local function AntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil, math.huge end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist; closest = tRoot end end end end return closest, minDist end local function AntiBypassFindBat()
if findBatTool then return findBatTool() end local char = LP.Character if not char then return nil end for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end local bp = LP:FindFirstChild("Backpack") if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end end return nil end local function AntiBypassTrySwing() if AceAntiBypassAimbot.swingCooldown then return end
if S.autoSwingEnabled == false then return end AceAntiBypassAimbot.swingCooldown = true pcall(function() local char = LP.Character if not char then return end local bat = AntiBypassFindBat() if not bat then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end) task.delay(0.03, function() AceAntiBypassAimbot.swingCooldown = false end) end
function F.startAimbotBypassAntiBat() pcall(function() if tpBatEnabled and stopTPBat then stopTPBat() end end) pcall(function() if aimbotEnabled and stopAimbot then stopAimbot() end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end end) if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end antiBatBypassLockEnabled = true; S.antiBatBypassEnabled = true; local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then
AceAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate; hum0.AutoRotate = false end pcall(function() F.destroyProxy() end) local bypassTick = 0; local _bpTarget, _bpDist, _bpLastScan = nil, math.huge, 0 AceAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function() if not antiBatBypassLockEnabled then return end bypassTick = bypassTick + 1 if bypassTick % (_IS_MOBILE and 3 or 8) == 0 then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum then return end if bypassTick % 5 == 0 then local bat = AntiBypassFindBat() if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end end local now = os.clock() if (now - _bpLastScan) >= (_IS_MOBILE and 0.08 or 0.03) then _bpLastScan = now; _bpTarget, _bpDist = AntiBypassGetClosest() end local target, targetDist = _bpTarget, _bpDist if not target then return end local myPos = root.Position; local targetPos = target.Position; local direction = targetPos - myPos; local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0 then
flatDir = flatDir.Unit else flatDir = Vector3.zero end local chaseSpeed = GetAntiBypassAimbotSpeed(); local desiredHeight = targetPos.Y + 3.7; local yVel = (desiredHeight - myPos.Y) * 19.5 if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end yVel = math.clamp(yVel, -70, 110); local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed); root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8); local toTarget = targetPos - myPos if toTarget.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(myPos, targetPos); local diffCF = root.CFrame:Inverse() * goalCF; local rx, ry, rz = diffCF:ToEulerAnglesXYZ(); rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5); root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end if targetDist <= 8 then AntiBypassTrySwing() end end) if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(true) end) end end function F.stopAimbotBypassAntiBat()
antiBatBypassLockEnabled = false; S.antiBatBypassEnabled = false if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end AceAntiBypassAimbot.swingCooldown = false; local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end local hum = c and c:FindFirstChildOfClass("Humanoid") if hum then local prev = AceAntiBypassAimbot.prevAutoRotate; hum.AutoRotate = (prev == nil) and true or prev end
AceAntiBypassAimbot.prevAutoRotate = nil if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(false) end) end end end local cursedInstaReset local K7 = { fovEnabled = false, fovValue = 80, lineESPEnabled = false, speedESPEnabled = false, animPackEnabled = false, animPackName = "Tryhard", animPackIndex = 1, headlessEnabled = false, korbloxEnabled = false, bodyLockEnabled = false, bodyLockRadius = 60, medusaResetEnabled = false, currentSkyTheme = "Off", skyThemeIndex = 1, } K7.headIndicator = nil K7.headSpeedConn = nil function K7.updateHeadIndicatorTheme()
local indicator = K7.headIndicator if not indicator then return end local accent = S.themeColor or Color3.fromRGB(245, 245, 247) if indicator.discord then indicator.discord.TextColor3 = accent end if indicator.speed then indicator.speed.TextColor3 = accent end if indicator.divider then indicator.divider.BackgroundColor3 = accent end end function K7.setupHeadIndicator(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if not head then return end local old = head:FindFirstChild("PrimeVSHeadIndicator")
if old then old:Destroy() end
local bb = Instance.new("BillboardGui"); bb.Name = "PrimeVSHeadIndicator"; bb.Size = UDim2.new(0, 220, 0, 74); bb.StudsOffset = Vector3.new(0, 2.9, 0); bb.ClipsDescendants = false; bb.LightInfluence = 0; bb.AlwaysOnTop = true; bb.MaxDistance = 600; bb.Adornee = head; bb.Parent = head; local accent = S.themeColor or Color3.fromRGB(245, 245, 247); local discordLbl = Instance.new("TextLabel"); discordLbl.Name = "Discord"; discordLbl.Size = UDim2.new(1, 0, 0, 20); discordLbl.AnchorPoint = Vector2.new(0.5, 0.5); discordLbl.Position = UDim2.new(0.5, 0, 0.34, 0); discordLbl.TextXAlignment = Enum.TextXAlignment.Center; discordLbl.TextYAlignment = Enum.TextYAlignment.Center; discordLbl.TextScaled = false; discordLbl.TextWrapped = false; discordLbl.RichText = false; discordLbl.BackgroundTransparency = 1; discordLbl.Text = "discord.gg/candy"; discordLbl.TextColor3 = accent; discordLbl.Font = Enum.Font.GothamBold; discordLbl.TextScaled = false; discordLbl.TextSize = 17; discordLbl.TextStrokeTransparency = 0; discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); discordLbl.Parent = bb; local divider = Instance.new("Frame"); divider.Name = "Divider"; divider.Size = UDim2.new(0.62, 0, 0, 2); divider.AnchorPoint = Vector2.new(0.5, 0.5); divider.Position = UDim2.new(0.5, 0, 0.5, 0); divider.BackgroundColor3 = accent; divider.BackgroundTransparency = 0.15; divider.BorderSizePixel = 0; divider.ZIndex = 2; divider.Parent = bb; local dividerCorner = Instance.new("UICorner"); dividerCorner.CornerRadius = UDim.new(1, 0); dividerCorner.Parent = divider; local speedLbl = Instance.new("TextLabel"); speedLbl.Name = "Speed"; speedLbl.Size = UDim2.new(1, 0, 0, 20); speedLbl.AnchorPoint = Vector2.new(0.5, 0.5); speedLbl.Position = UDim2.new(0.5, 0, 0.66, 0); speedLbl.TextXAlignment = Enum.TextXAlignment.Center; speedLbl.TextYAlignment = Enum.TextYAlignment.Center; speedLbl.TextScaled = false; speedLbl.TextWrapped = false; speedLbl.BackgroundTransparency = 1; speedLbl.Text = "0.0"; speedLbl.TextColor3 = accent; speedLbl.Font = Enum.Font.GothamBold; speedLbl.TextScaled = false; speedLbl.TextSize = 17; speedLbl.TextStrokeTransparency = 0; speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); speedLbl.Parent = bb; K7.headIndicator = { bb = bb, discord = discordLbl, speed = speedLbl, divider = divider }; K7.updateHeadIndicatorTheme()
end function K7.startHeadSpeedUpdates() if K7.headSpeedConn then K7.headSpeedConn:Disconnect() end K7.headSpeedConn = RunService.Heartbeat:Connect(function() local indicator = K7.headIndicator if not indicator or not indicator.bb or not indicator.bb.Parent then return end local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local displaySpeed = 0 if S and (S.autoLeftEnabled or S.autoRightEnabled) then local ok, value = pcall(function() return (F and F.getAutoPathSpeed and F.getAutoPathSpeed()) or nil end) if ok and type(value) == "number" then
displaySpeed = value elseif F and F.getActiveMoveSpeed then local ok2, v2 = pcall(F.getActiveMoveSpeed) if ok2 and type(v2) == "number" then displaySpeed = v2 end end elseif F and F.getActiveMoveSpeed then local ok, value = pcall(F.getActiveMoveSpeed) if ok and type(value) == "number" then displaySpeed = value end elseif hrp then local velocity = hrp.AssemblyLinearVelocity; displaySpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude end indicator.speed.Text = string.format("%.1f", displaySpeed) end) end local function bindHeadIndicator(char) task.spawn(function() task.wait(0.25)
K7.setupHeadIndicator(char); K7.startHeadSpeedUpdates() end) end bindHeadIndicator(LP.Character); LP.CharacterAdded:Connect(bindHeadIndicator) do local skyThemeTag = "CursedSkyTheme"; local currentSkyTheme = "Off"; local SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"} local SkyPresets = { ["Off"]={kind="off"},
["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}}, ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}}, ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}}, ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4}}, ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2}}, ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2}},
["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5}}, ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8}}, ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4}}, ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6}}, ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4}}, ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5}}, ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={sun=6},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3}},
["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2}}, ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}}, ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8}},
["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2}}, ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6}}, } local function skyRGB(t) return Color3.fromRGB(t[1],t[2],t[3]) end local function applySkyTheme(mode) currentSkyTheme = mode or "Off"; K7.currentSkyTheme = currentSkyTheme for _,child in ipairs(Lighting:GetChildren()) do
if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end local terrain = workspace:FindFirstChildOfClass("Terrain") if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end end local preset = SkyPresets[mode] if not preset or preset.kind == "off" then Lighting.ClockTime = 14; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127); Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.FogEnd = 100000; Lighting.GlobalShadows = true return end
Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2 if preset.outAmb then Lighting.OutdoorAmbient = skyRGB(preset.outAmb) end if preset.ambient then Lighting.Ambient = skyRGB(preset.ambient) end if preset.sky then local skyInst = Instance.new("Sky"); skyInst:SetAttribute(skyThemeTag, true) if preset.sky.stars then skyInst.StarCount = preset.sky.stars end if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end skyInst.Parent = Lighting end if preset.atm then local atm = Instance.new("Atmosphere"); atm:SetAttribute(skyThemeTag, true); atm.Density = preset.atm.dens or 0.3; atm.Color = skyRGB(preset.atm.color); atm.Decay = skyRGB(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1; atm.Parent = Lighting end if preset.clouds and terrain then
local clouds = Instance.new("Clouds"); clouds:SetAttribute(skyThemeTag, true); clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5; clouds.Color = skyRGB(preset.clouds.color); clouds.Parent = terrain end end local skyThemeIndex = 1 local function cycleSkyTheme(dir) skyThemeIndex = skyThemeIndex + (dir or 1) if skyThemeIndex < 1 then skyThemeIndex = #SkyOrder end if skyThemeIndex > #SkyOrder then skyThemeIndex = 1 end applySkyTheme(SkyOrder[skyThemeIndex]); K7.skyThemeIndex = skyThemeIndex return SkyOrder[skyThemeIndex] end
_G._VezyFOV = _G._VezyFOV or 70; local fovEnabled = false; local fovValue = 70; local fovConn = nil; local stretchRezEnabled = false; local stretchRezConn, stretchFovConn = nil, nil; local stretchFOV = 120; _G.State = _G.State or {}; State = _G.State; State.stretchedResEnabled = false; State.stretchFOV = 120 local function applyStretchFOV(val) local cam = workspace.CurrentCamera if cam then pcall(function() cam.FieldOfView = val end) end end local function enableStretchRez() S.stretchRezEnabled = true; State.stretchedResEnabled = true; local cam = workspace.CurrentCamera
if not cam then return end if S.stretchRezConn then S.stretchRezConn:Disconnect() end if stretchFovConn then stretchFovConn:Disconnect() end stretchFovConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then return end if not _perfEveryN(4, 2) then return end applyStretchFOV(State.stretchFOV or stretchFOV) end) S.stretchRezConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end return end if _IS_MOBILE and not _perfEveryN(2, 1) then return end if cam then
cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1) end end) end local function disableStretchRez() S.stretchRezEnabled = false; State.stretchedResEnabled = false if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = _G._VezyFOV or 70 end end) end local function applyFOV() pcall(function() RunService:UnbindFromRenderStep("CursedFOV") end)
if fovConn then fovConn:Disconnect(); fovConn = nil end if not K7.fovEnabled then local target = _G._VezyFOV or 70 if workspace.CurrentCamera and not State.stretchedResEnabled then workspace.CurrentCamera.FieldOfView = target end return end local cam = workspace.CurrentCamera; local target = K7.fovValue or _G._VezyFOV or 70; _G._VezyFOV = target if cam and not State.stretchedResEnabled then cam.FieldOfView = target end pcall(function() RunService:BindToRenderStep("CursedFOV", Enum.RenderPriority.Camera.Value + 1, function() if not K7.fovEnabled then return end
if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end) fovConn = RunService.Heartbeat:Connect(function() if not _perfEveryN(3, 1) then return end if not K7.fovEnabled then return end if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end do local _VezyFOVPropConn = nil local function _attachFOVLock(cam) if not cam then return end
if _VezyFOVPropConn then pcall(function() _VezyFOVPropConn:Disconnect() end) end pcall(function() if not State.stretchedResEnabled then cam.FieldOfView = _G._VezyFOV or 70 end end) _VezyFOVPropConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function() local target = _G._VezyFOV or 70 if not State.stretchedResEnabled and cam.FieldOfView ~= target then pcall(function() cam.FieldOfView = target end) end end) end pcall(function() if workspace.CurrentCamera then _attachFOVLock(workspace.CurrentCamera) end workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() task.wait()
pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) if LP then LP.CharacterAdded:Connect(function() task.wait(0.3) pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) end end) end local headlessEnabled, korbloxEnabled = false, false; local HEADLESS_MESH_ID = "rbxassetid://1095708" local function applyHeadless(char, enabled) if not char then return end local head = char:FindFirstChild("Head") if not head then return end if enabled then head.Transparency = 1; head.CanCollide = false; local face = head:FindFirstChild("face") if face then face:Destroy() end
for _, c in ipairs(head:GetChildren()) do if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end end local mesh = Instance.new("SpecialMesh"); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = HEADLESS_MESH_ID; mesh.Scale = Vector3.new(0.001, 0.001, 0.001); mesh.Name = "HeadlessMesh"; mesh.Parent = head else head.Transparency = 0; head.CanCollide = true for _, c in ipairs(head:GetChildren()) do if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end end end end local KORBLOX_ASSETS = { ["Left Leg"] = { id = "rbxassetid://139607673",
targetBodyPart = "LeftUpperLeg", partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, ["Right Leg"] = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, } local korbloxSide = 1 local function clearKorbloxAttachments(char) if not char then return end for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg", "Korblox_Left Leg", "Korblox_Right Leg"}) do
local old = char:FindFirstChild(name) if old then pcall(function() old:Destroy() end) end end for _, child in ipairs(char:GetChildren()) do if child.Name:find("^Korblox_") then pcall(function() child:Destroy() end) end end for _, partName in ipairs({ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", }) do local limb = char:FindFirstChild(partName) if limb and limb:IsA("BasePart") then limb.Transparency = 0 end end end local function attachKorbloxMesh(char, itemName, config) if not char then return false, "No character" end
local targetPart = char:FindFirstChild(config.targetBodyPart) if not targetPart then if itemName == "Left Leg" then targetPart = char:FindFirstChild("Left Leg") elseif itemName == "Right Leg" then targetPart = char:FindFirstChild("Right Leg") end end if not targetPart then return false, "Target part missing" end local safeName = "Korblox_" .. itemName:gsub("%s+", ""); local oldAsset = char:FindFirstChild(safeName) if oldAsset then pcall(function() oldAsset:Destroy() end) end for _, partName in ipairs(config.partsToHide) do local limb = char:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then limb.Transparency = 1 end end local success, objects = pcall(function() return game:GetObjects(config.id) end) if not success or not objects or #objects == 0 then return false, "Asset fetch failed" end local assetModel = objects[1]; assetModel.Name = safeName; local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true) if not mainMesh then return false, "No MeshPart in asset" end pcall(function() mainMesh.Size = mainMesh.Size * (config.scale or Vector3.new(1,1,1))
mainMesh.CanCollide = false; mainMesh.Anchored = false; mainMesh.CFrame = targetPart.CFrame * (config.offset or CFrame.new()) end) local weld = Instance.new("WeldConstraint") weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh; assetModel.Parent = char return true end local function applyKorblox(char, enabled) if not char then return end clearKorbloxAttachments(char) if not enabled then return end local sides = {}; local side = korbloxSide or 1 if side == 2 then sides = {"Left Leg"} elseif side == 3 then sides = {"Left Leg", "Right Leg"} else sides = {"Right Leg"} end
for _, itemName in ipairs(sides) do local config = KORBLOX_ASSETS[itemName] if config then local ok, err = attachKorbloxMesh(char, itemName, config) if not ok then warn("[PrimeVS] Korblox equip failed (" .. itemName .. "): " .. tostring(err)) end end end end local bodyLockEnabled = false; local bodyLockRadius = 60; local bodyLockConn = nil local function getNearestBodyLockTarget() local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local nearest, shortest = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tr and hum and hum.Health > 0 then local d = (tr.Position - root.Position).Magnitude if d <= (K7.bodyLockRadius or bodyLockRadius or 60) and d < shortest then shortest = d; nearest = plr end end end end return nearest end local function isNearBrainrot(root, radius) if not root then return false end radius = radius or 5 local ok, parts = pcall(function() return workspace:GetPartBoundsInRadius(root.Position, radius) end)
if not ok or not parts then return false end for _, p in ipairs(parts) do if p and p:IsA("BasePart") then local model = p:FindFirstAncestorOfClass("Model") if model and model ~= LP.Character then if not Players:GetPlayerFromCharacter(model) then local n = string.lower(model.Name) if n:find("brainrot", 1, true) or n:find("animal", 1, true) or n:find("steal", 1, true) then return true end local par = model.Parent if par then local pn = string.lower(par.Name) if pn:find("brainrot", 1, true) or pn:find("animals", 1, true) then return true end end end end end end return false end
local function startBodyLock() if bodyLockConn then K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true return end K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true; S._bodyLockPausedByBrainrot = false; local _blCachedTarget = nil; local _blLastScan = 0; local _blLastBrain = 0; local _blNearBrain = false bodyLockConn = RunService.Heartbeat:Connect(function() if not K7.bodyLockEnabled then return end if aimbotEnabled or tpBatEnabled or antiBatBypassLockEnabled then return end
local char = LP.Character; local myRoot = char and char:FindFirstChild("HumanoidRootPart"); local humanoid = char and char:FindFirstChildOfClass("Humanoid") if not myRoot or not humanoid or humanoid.Health <= 0 then return end local now = os.clock(); local brainInterval = _IS_MOBILE and 0.18 or 0.08 if (now - _blLastBrain) >= brainInterval then _blLastBrain = now; local holding, near = false, false pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(myRoot, 5) == true end)
_blNearBrain = holding or near end if _blNearBrain then S._bodyLockPausedByBrainrot = true; humanoid.AutoRotate = true return end local scanInterval = _IS_MOBILE and 0.12 or 0.05 if (now - _blLastScan) >= scanInterval then _blLastScan = now; _blCachedTarget = getNearestBodyLockTarget() end local target = _blCachedTarget if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local targetPos = target.Character.HumanoidRootPart.Position; local myPos = myRoot.Position; local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
if offset.Magnitude > 0.1 then humanoid.AutoRotate = false; local lookDir = offset.Unit local currentDir = myRoot.CFrame.LookVector local cross = currentDir:Cross(lookDir); local currentVel = myRoot.AssemblyAngularVelocity; myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z) end else humanoid.AutoRotate = true end end) end local function stopBodyLock(fromUser) K7.bodyLockEnabled = false; bodyLockEnabled = false if bodyLockConn then bodyLockConn:Disconnect(); bodyLockConn = nil end local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate = true end if fromUser == true then S._bodyLockWanted = false; S._bodyLockPausedByBrainrot = false end end if not S._bodyLockBrainrotWatcher then S._bodyLockBrainrotWatcher = true RunService.Heartbeat:Connect(function() if not S._bodyLockWanted then return end if S._bodyLockPausedByCombat then return end if aimbotEnabled or tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local holding, near = false, false
pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(root, 5) == true end) if holding or near then S._bodyLockPausedByBrainrot = true return end if S._bodyLockPausedByBrainrot or not bodyLockConn then S._bodyLockPausedByBrainrot = false if not bodyLockConn then pcall(startBodyLock) else K7.bodyLockEnabled = true; bodyLockEnabled = true end if VS and VS.setBodyLockVisual then pcall(function() VS.setBodyLockVisual(true) end) end end end) end
local medusaResetEnabled = false; local medusaResetConns = {}; local medusaResetDebounce = false local function onPartAnchoredForReset(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 and part.Name ~= "HumanoidRootPart" then if medusaResetDebounce or not K7.medusaResetEnabled then return end medusaResetDebounce = true task.spawn(function() if F.doInstaReset then F.doInstaReset() end task.wait(1.5); medusaResetDebounce = false end) end end) end local function startMedusaReset()
for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end medusaResetConns = {}; local char = LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end)) end local function stopMedusaReset() for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
medusaResetConns = {}; medusaResetDebounce = false end local lineESPEnabled = false; local speedESPEnabled = false; local PlayerESP = { enabled = false, conns = {}, playerData = {} }; local TracerESP = { drawings = {}, conn = nil, gui = nil } local function startPlayerESP() if PlayerESP.enabled then return end PlayerESP.enabled = true local function cleanup(plr) local d = PlayerESP.playerData[plr] if not d then return end pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end)
for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.playerData[plr] = nil end local function setupPlayer(plr, char) if not PlayerESP.enabled or plr == LP then return end cleanup(plr); char = char or plr.Character if not char then return end local hrp = char:FindFirstChild("HumanoidRootPart"); local head = char:FindFirstChild("Head") or hrp if not hrp then return end
local hl = Instance.new("Highlight"); hl.Name = "SevenUpPlayerESP"; hl.Adornee = char; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; local acc = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); hl.FillColor = acc; hl.FillTransparency = 0.72; hl.OutlineColor = acc; hl.OutlineTransparency = 0.08; hl.Parent = char; local bb = Instance.new("BillboardGui"); bb.Name = "SevenUpPlayerESP_BB"; bb.Adornee = head; bb.Size = UDim2.new(0, 120, 0, 28); bb.StudsOffset = Vector3.new(0, 2.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 600; local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = plr.DisplayName or plr.Name; lbl.TextColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextStrokeTransparency = 0.3
pcall(function() bb.Parent = game:GetService("CoreGui") end) if not bb.Parent then pcall(function() bb.Parent = LP:FindFirstChild("PlayerGui") end) end local lastEspUp = 0 local conn = RunService.Heartbeat:Connect(function() if not PlayerESP.enabled or not hrp.Parent then return end local now = os.clock(); local interval = _IS_MOBILE and 0.22 or 0.08 if (now - lastEspUp) < interval then return end lastEspUp = now; local v = hrp.AssemblyLinearVelocity; local spd = Vector3.new(v.X, 0, v.Z).Magnitude; lbl.Text = string.format("%s\n%.0f sps", plr.DisplayName or plr.Name, spd) end)
PlayerESP.playerData[plr] = { highlight = hl, billboard = bb, conns = { conn } } end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) if plr.Character then task.defer(setupPlayer, plr, plr.Character) end end end table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) end)) table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup)) end
local function stopPlayerESP() PlayerESP.enabled = false for _, c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.conns = {} for plr, d in pairs(PlayerESP.playerData) do pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end) for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end end PlayerESP.playerData = {} end local function ensureTracerGui() if TracerESP.gui and TracerESP.gui.Parent then return TracerESP.gui end
local g = Instance.new("ScreenGui"); g.Name = "VersincTracerESP"; g.IgnoreGuiInset = true; g.DisplayOrder = 50; g.ResetOnSpawn = false pcall(function() g.Parent = game:GetService("CoreGui") end) if not g.Parent then pcall(function() g.Parent = LP:FindFirstChild("PlayerGui") end) end TracerESP.gui = g return g end local function tracerCleanup(plr) local d = TracerESP.drawings[plr] if d then pcall(function() if d.line then d.line:Destroy() end end) TracerESP.drawings[plr] = nil end end local function startTracerESP() if TracerESP.conn then pcall(function() TracerESP.conn:Disconnect() end)
TracerESP.conn = nil end for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end ensureTracerGui(); S.showTracerEnabled = true TracerESP.conn = RunService.Heartbeat:Connect(function() if not S.showTracerEnabled and not (K7 and K7.lineESPEnabled) then for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end return end if not _perfEveryN(3, 1) then return end if not TracerESP.gui or not TracerESP.gui.Parent then return end local myChar = LP.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") if not myRoot then return end local cam = workspace.CurrentCamera
if not cam then return end local seen = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then seen[plr] = true; local sp, son = cam:WorldToViewportPoint(myRoot.Position); local ep, eon = cam:WorldToViewportPoint(tr.Position) if son and eon then local line = TracerESP.drawings[plr] and TracerESP.drawings[plr].line if not line then
line = Instance.new("Frame"); line.Name = "Tracer_" .. plr.Name; line.AnchorPoint = Vector2.new(0.5, 0.5); line.BorderSizePixel = 0; line.BackgroundColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); line.BackgroundTransparency = 0.15; line.Parent = TracerESP.gui; TracerESP.drawings[plr] = { line = line } end
local dx, dy = ep.X - sp.X, ep.Y - sp.Y; local len = math.sqrt(dx * dx + dy * dy); line.Size = UDim2.fromOffset(math.max(1, len), 2); line.Position = UDim2.fromOffset((sp.X + ep.X) / 2, (sp.Y + ep.Y) / 2); line.Rotation = math.deg(math.atan2(dy, dx)); line.Visible = true else tracerCleanup(plr) end end end end for plr in pairs(TracerESP.drawings) do if not seen[plr] then tracerCleanup(plr) end end end) end local function stopTracerESP() S.showTracerEnabled = false if TracerESP.conn then TracerESP.conn:Disconnect(); TracerESP.conn = nil end
for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end if TracerESP.gui then pcall(function() TracerESP.gui:Destroy() end); TracerESP.gui = nil end end local function refreshESP() stopPlayerESP(); stopTracerESP() if not K7 then return end if K7.lineESPEnabled or K7.speedESPEnabled then startPlayerESP(); startTracerESP() end end if K7 then K7.refreshESP = refreshESP end local animPackEnabled = false; local animPackName = "Tryhard"; local savedAnimateClone = nil; local applyingAnim = false local ANIM_PACKS = { ["Tryhard"] = {
Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 707897309, RunAnim = 707861613, JumpAnim = 116936326516985, FallAnim = 116936326516985, ClimbAnim = 116936326516985, Swim = 116936326516985, SwimIdle = 116936326516985, }, ["Crazy"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 134824450619865, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, ClimbAnim = 121454505477205, Swim = 121454505477205, SwimIdle = 121454505477205, }, ["Adidas Sports"] = {
Animation1 = 18537376492, Animation2 = 18537371272, WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, ClimbAnim = 18537363391, Swim = 18537389531, SwimIdle = 18537387180, }, ["Adidas Community"] = { Animation1 = 122257458498464, Animation2 = 102357151005774, WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, ClimbAnim = 88763136693023, Swim = 133308483266208, SwimIdle = 109346520324160, }, ["Adidas Aura"] = {
Animation1 = 110211186840347, Animation2 = 114191137265065, WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, ClimbAnim = 97824616490448, Swim = 134530128383903, SwimIdle = 94922130551805, }, ["Wicked Popular"] = { Animation1 = 118832222982049, Animation2 = 76049494037641, WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, ClimbAnim = 131326830509784, Swim = 99384245425157, SwimIdle = 113199415118199, }, ["Elder"] = {
Animation1 = 10921101664, Animation2 = 10921102574, WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, ClimbAnim = 10921100400, Swim = 10921108971, SwimIdle = 10921110137, }, ["Zombie"] = { Animation1 = 10921344533, Animation2 = 10921345376, WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, ClimbAnim = 10921343576, Swim = 10921352344, SwimIdle = 10921353442, }, ["Mage"] = {
Animation1 = 10921144709, Animation2 = 10921145797, WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, ClimbAnim = 10921143404, Swim = 10921150788, SwimIdle = 10921151661, }, ["Catwalk Glam"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, ClimbAnim = 119377220967554, Swim = 134591743181628, SwimIdle = 98854111361360, }, ["Astronaut"] = {
Animation1 = 10921034824, Animation2 = 10921036806, WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, ClimbAnim = 10921032124, Swim = 10921044000, SwimIdle = 10921045006, }, ["Werewolf"] = { Animation1 = 10921330408, Animation2 = 10921333667, WalkAnim = 10921342074, RunAnim = 10921336997, JumpAnim = 10921337907, FallAnim = 10921337907, ClimbAnim = 10921329322, Swim = 10921340419, SwimIdle = 10921341319, }, ["Superhero"] = {
Animation1 = 10921288909, Animation2 = 10921290167, WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, ClimbAnim = 10921286911, Swim = 10921295495, SwimIdle = 10921297391, }, ["Toy"] = { Animation1 = 10921301576, Animation2 = 10921301576, WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, ClimbAnim = 10921300839, Swim = 10921309319, SwimIdle = 10921310341, }, ["No Boundaries"] = {
Animation1 = 18747067405, Animation2 = 18747063918, WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, ClimbAnim = 18747060903, Swim = 18747073181, SwimIdle = 18747071682, }, ["NFL"] = { Animation1 = 92080889861410, Animation2 = 74451233229259, WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, ClimbAnim = 134630013742019, Swim = 132697394189921, SwimIdle = 79090109939093, }, ["Vampire"] = {
Animation1 = 10921315373, Animation2 = 10921315373, WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, ClimbAnim = 10921314188, Swim = 10921324408, SwimIdle = 10921325443, }, ["Ninja"] = { Animation1 = 656117400, Animation2 = 656118341, WalkAnim = 656121766, RunAnim = 656118852, JumpAnim = 656117878, FallAnim = 656115606, ClimbAnim = 656114359, Swim = 656119721, SwimIdle = 656121397, }, ["Robot"] = {
Animation1 = 616088211, Animation2 = 616089559, WalkAnim = 616095330, RunAnim = 616091570, JumpAnim = 616090535, FallAnim = 616087089, ClimbAnim = 616086039, Swim = 616092998, SwimIdle = 616094091, }, ["Levitation"] = { Animation1 = 616006778, Animation2 = 616008087, WalkAnim = 616013216, RunAnim = 616010382, JumpAnim = 616008936, FallAnim = 616005863, ClimbAnim = 616003713, Swim = 616011509, SwimIdle = 616012453, }, ["Stylish"] = {
Animation1 = 616136790, Animation2 = 616138447, WalkAnim = 616146177, RunAnim = 616140816, JumpAnim = 616139451, FallAnim = 616134815, ClimbAnim = 616133594, Swim = 616143378, SwimIdle = 616144772, }, ["Bubbly"] = { Animation1 = 910004836, Animation2 = 910009958, WalkAnim = 910034870, RunAnim = 910025107, JumpAnim = 910016857, FallAnim = 910001910, ClimbAnim = 909997997, Swim = 910028158, SwimIdle = 910030921, }, ["Cartoon"] = {
Animation1 = 742637544, Animation2 = 742638445, WalkAnim = 742640026, RunAnim = 742638842, JumpAnim = 742637942, FallAnim = 742637151, ClimbAnim = 742636889, Swim = 742639220, SwimIdle = 742639812, }, ["Wicked Dancing"] = { Animation1 = 92849173543269, Animation2 = 132238900951109, WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, ClimbAnim = 129447497744818, Swim = 110657013921774, SwimIdle = 129183123083281, }, ["Normal"] = {
Animation1 = 507766388, Animation2 = 507766666, WalkAnim = 507777826, RunAnim = 507767714, JumpAnim = 507765000, FallAnim = 507767968, ClimbAnim = 507765644, Swim = 507784897, SwimIdle = 507784897, }, } local ANIM_PACK_LIST = {"Tryhard","Crazy","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut","Werewolf","Superhero","Toy","No Boundaries","NFL","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon","Wicked Dancing","Normal"} local animPackIndex = 1 local function setAnimId(obj, id)
if not obj or not id then return end local idStr = type(id) == "number" and ("rbxassetid://" .. tostring(id)) or tostring(id) if not idStr:find("rbxassetid://") and tonumber(idStr) then idStr = "rbxassetid://" .. idStr end pcall(function() if obj:IsA("Animation") then obj.AnimationId = idStr elseif obj:IsA("StringValue") then obj.Value = idStr end end) end local function applyAnimPack(name) if not K7.animPackEnabled then return end if applyingAnim then return end name = name or K7.animPackName if not name or name == "" then applyingAnim = false; return end
K7.animPackName = name; applyingAnim = true; local pack = ANIM_PACKS[name] if not pack then applyingAnim = false; return end local char = LP.Character if not char then applyingAnim = false; return end local animate = char:FindFirstChild("Animate") if not animate then applyingAnim = false; return end if not savedAnimateClone then pcall(function() savedAnimateClone = animate:Clone() end) end local hum = char:FindFirstChildOfClass("Humanoid") if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end end local function ensure(folder, animName)
if not folder then return nil end local a = folder:FindFirstChild(animName) if not a then a = Instance.new("Animation"); a.Name = animName; a.Parent = folder end return a end local function setFolderAnim(folderName, animName, id) if not id then return end local folder = animate:FindFirstChild(folderName) if not folder then folder = Instance.new("Folder"); folder.Name = folderName; folder.Parent = animate end setAnimId(ensure(folder, animName), id) for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then setAnimId(ch, id) end end end
setFolderAnim("walk", "WalkAnim", pack.WalkAnim); setFolderAnim("run", "RunAnim", pack.RunAnim); setFolderAnim("jump", "JumpAnim", pack.JumpAnim); setFolderAnim("fall", "FallAnim", pack.FallAnim); setFolderAnim("climb", "ClimbAnim", pack.ClimbAnim); setFolderAnim("swim", "Swim", pack.Swim); setFolderAnim("swimidle", "SwimIdle", pack.SwimIdle); local idle = animate:FindFirstChild("idle") if not idle then idle = Instance.new("Folder"); idle.Name = "idle"; idle.Parent = animate end if idle then
setAnimId(ensure(idle, "Animation1"), pack.Animation1); setAnimId(ensure(idle, "Animation2"), pack.Animation2 or pack.Animation1) for _, ch in ipairs(idle:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then if ch.Name:find("1") then setAnimId(ch, pack.Animation1) elseif ch.Name:find("2") then setAnimId(ch, pack.Animation2 or pack.Animation1) end end end end animate.Disabled = true; task.wait(0.05); animate.Disabled = false; animPackName = name; K7.animPackName = name; applyingAnim = false; print("[prime.vs] Anim pack applied:", name) end local function resetAnimPack()
local char = LP.Character if not char then return end local animate = char:FindFirstChild("Animate") if animate then animate:Destroy() end if savedAnimateClone then local n = savedAnimateClone:Clone(); n.Parent = char; n.Disabled = true; task.wait(0.05); n.Disabled = false end end K7.applySkyTheme = applySkyTheme; K7.cycleSkyTheme = cycleSkyTheme; K7.applyFOV = applyFOV; K7.enableStretchRez = enableStretchRez; K7.disableStretchRez = disableStretchRez; K7.applyHeadless = applyHeadless; K7.applyKorblox = applyKorblox; K7.korbloxSide = korbloxSide
K7.setKorbloxSide = function(n) korbloxSide = n; K7.korbloxSide = n end K7.startBodyLock = startBodyLock; K7.stopBodyLock = stopBodyLock; K7.startMedusaReset = startMedusaReset; K7.stopMedusaReset = stopMedusaReset; K7.refreshESP = refreshESP; K7.applyAnimPack = applyAnimPack; K7.resetAnimPack = resetAnimPack; K7.ANIM_PACK_LIST = ANIM_PACK_LIST if K7.currentSkyTheme == nil then K7.currentSkyTheme = currentSkyTheme end if K7.skyThemeIndex == nil then K7.skyThemeIndex = skyThemeIndex end if K7.fovValue == nil then K7.fovValue = fovValue end
if K7.animPackName == nil then K7.animPackName = animPackName end if K7.animPackIndex == nil then K7.animPackIndex = animPackIndex end if K7.bodyLockRadius == nil then K7.bodyLockRadius = bodyLockRadius end print("[prime.vs] K7 systems ready") end enableStretchRez = function(...) if K7 and K7.enableStretchRez then return K7.enableStretchRez(...) end end disableStretchRez = function(...) if K7 and K7.disableStretchRez then return K7.disableStretchRez(...) end end task.spawn(function() local BLACKLIST_URL="https://pastebin.com/2zLUXv2K" pcall(function() HS.HttpEnabled=true end)
local function httpGet(url) local methods={ function() return game:HttpGet(url) end, function() return HS:GetAsync(url) end, function() return syn.request({Url=url,Method="GET"}).Body end, function() return http_request({Url=url,Method="GET"}).Body end, function() return request({Url=url,Method="GET"}).Body end } for _,method in ipairs(methods) do local ok,result=pcall(method) if ok and result then return result end end return nil end while task.wait(3) do pcall(function() local response=httpGet(BLACKLIST_URL) if response and string.find(response,tostring(LP.UserId),1,true) then
LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633"); task.wait(999999) end end) end end) pcall(function() if type(hookfunction) ~= "function" then return end local wrap = newcclosure or function(f) return f end local probe = Instance.new("RemoteEvent") local oldFire oldFire = hookfunction(probe.FireServer, wrap(function(self, ...) if not S.cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") then local n = self.Name if type(n) == "string" and n:sub(1, 3) == "RE/" then S.cursedResetRemote = self end end
return oldFire(self, ...) end)) pcall(function() probe:Destroy() end) end) task.spawn(function() task.wait(2) if S.cursedResetRemote then return end pcall(function() local rs = game:GetService("ReplicatedStorage") for _, desc in ipairs(rs:GetDescendants()) do if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then S.cursedResetRemote = desc return end end end) end) local _resetCooldown = false local _resetThread = nil; local _resetChar = nil; local _resetStop = false; local RESET_TICK = 0.05; local RESET_MAX_ATTEMPTS = 40 local function _stopInstaResetSeq() _resetStop = true
if _resetThread then pcall(function() task.cancel(_resetThread) end) _resetThread = nil end _resetCooldown = false; local character = LP.Character if character then local humanoid = character:FindFirstChildOfClass("Humanoid") if humanoid then pcall(function() humanoid.HipHeight = 2 local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = true end for _, part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end end end) end end _resetChar = nil; _resetStop = false end
if not _G.__VersincInstaResetCharHook then _G.__VersincInstaResetCharHook = true LP.CharacterAdded:Connect(function() _stopInstaResetSeq() end) end cursedInstaReset = function() if _resetCooldown then return end _resetCooldown = true; _resetStop = false; local character = LP.Character if not character then _resetCooldown = false return end local humanoid = character:FindFirstChildOfClass("Humanoid") if not humanoid then _resetCooldown = false return end _resetChar = character; local originalHip = humanoid.HipHeight _resetThread = task.spawn(function() local attempts = 0 local okReset = false
while character and character.Parent and humanoid and humanoid.Health > 0 and not _resetStop do if LP.Character ~= character then okReset = true break end pcall(function() humanoid.HipHeight = 1e30 humanoid.AutoRotate = true; local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = false end for _, part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end end end) if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then okReset = true break end
attempts = attempts + 1 if attempts >= RESET_MAX_ATTEMPTS then break end task.wait(RESET_TICK) end if not okReset and character and character.Parent and humanoid and humanoid.Health > 0 then pcall(function() humanoid.Health = 0 end) task.wait(0.1) if not character.Parent or humanoid.Health <= 0 then okReset = true end end if not okReset and character and character.Parent and humanoid then pcall(function() humanoid.HipHeight = originalHip local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = true end for _, part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end end end) end _resetCooldown = false; _resetThread = nil; _resetChar = nil; _resetStop = false end) end local KB = { DropBrainrot={kb=Enum.KeyCode.H,gp=nil}, AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil}, AutoRight   ={kb=Enum.KeyCode.C,gp=nil}, AutoBat     ={kb=Enum.KeyCode.E,gp=nil}, TPBat       ={kb=Enum.KeyCode.V,gp=Enum.KeyCode.ButtonY}, TPFloor     ={kb=Enum.KeyCode.F,gp=nil}, InstaReset  ={kb=Enum.KeyCode.T,gp=nil}, GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil}, LaggerToggle={kb=Enum.KeyCode.R,gp=nil}, BatV2={kb=Enum.KeyCode.B,gp=nil}, AimbotV2={kb=Enum.KeyCode.G,gp=nil}, } pcall(__initAimbotTPBat)
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81); local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48); local isCurrentlyStealing = false; local autoStealConnection = nil; local barResetTween = nil; local stealGen = 0; local autoStealEnabled = false; local selectedStealMode = "V1"; local autoStealRadius = 20; local AceStealRadii = {Normal = 20, Semi = 20}; local autoGrabStopEnabled, autoGrabStopTime, autoGrabDelayRadius = true, 1.00, 8 local Steal = { AutoStealEnabled = false, StealRadius = 20, StealDuration = 1.3,
Data = {}, AutoGrabStopEnabled = true, AutoGrabStopTime = 1.00, AutoGrabDelayRadius = 8, } local progressRadLbl, progressFill, progressPct = nil, nil, nil local setupStealBarAPI, resetProgressBar, AceAutoStealSync, startAutoSteal, stopAutoSteal local stealsCount = 0; local function stealBarColor(progress)
    progress = tonumber(progress) or 0
    local c1 = Color3.fromRGB(40, 40, 48)
    local c2 = Color3.fromRGB(220, 220, 230)
    local c3 = Color3.fromRGB(255, 255, 255)
    if progress < 0.5 then return c1:Lerp(c2, progress / 0.5) end
    return c2:Lerp(c3, (progress - 0.5) / 0.5)
end local function syncStealAliases()
Steal.AutoGrabStopEnabled = autoGrabStopEnabled == true; Steal.AutoGrabStopTime = tonumber(autoGrabStopTime) or 1.00; Steal.AutoGrabDelayRadius = tonumber(autoGrabDelayRadius) or 8; Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius or 20; Steal.AutoStealEnabled = autoStealEnabled == true end local function resetProgressVisuals() if progressPct then progressPct.Text = "READY" end if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = stealBarColor(0) end end resetProgressBar = resetProgressVisuals setupStealBarAPI = function() end
local function getPromptWorldPos(prompt) if not prompt then return nil end local ok, pos = pcall(function() local p = prompt.Parent if p and p:IsA("Attachment") then return p.WorldPosition end if p and p:IsA("BasePart") then return p.Position end if p and p.Parent and p.Parent:IsA("BasePart") then return p.Parent.Position end local ad = prompt.Parent if ad and ad:IsA("Attachment") and ad.Parent and ad.Parent:IsA("BasePart") then return ad.Parent.Position end return nil end) return ok and pos or nil end function Steal.IsMyPlot(plotName) local plots = workspace:FindFirstChild("Plots")
if not plots then return false end local plot = plots:FindFirstChild(plotName) if not plot then return false end local sign = plot:FindFirstChild("PlotSign") if sign then local yourBase = sign:FindFirstChild("YourBase") if yourBase and yourBase:IsA("BillboardGui") then return yourBase.Enabled == true end end local ok, owned = pcall(function() local conf = plot:FindFirstChild("Configuration") or plot:FindFirstChild("Config") if conf then local owner = conf:FindFirstChild("Owner") or conf:FindFirstChild("Player") if owner then local v = owner.Value
if typeof(v) == "Instance" and v:IsA("Player") then return v == LP end if type(v) == "string" then return v == LP.Name or v == tostring(LP.UserId) end end end return false end) return ok and owned or false end local function isStealPrompt(prompt) if not prompt or not prompt:IsA("ProximityPrompt") then return false end local at = (prompt.ActionText or ""):lower(); local ot = (prompt.ObjectText or ""):lower() if at:find("steal", 1, true) or ot:find("steal", 1, true) then return true end return false end function Steal.FindNearestPrompt() local character = LP.Character
if not character then return nil, nil end local root = character:FindFirstChild("HumanoidRootPart") if not root then return nil, nil end local plots = workspace:FindFirstChild("Plots") if not plots then return nil, nil end local nearestPrompt, nearestDistance, nearestPodName = nil, math.huge, nil; local radius = tonumber(Steal.StealRadius) or tonumber(autoStealRadius) or 20 for _, plot in ipairs(plots:GetChildren()) do if plot:IsA("Model") and not Steal.IsMyPlot(plot.Name) then local pods = plot:FindFirstChild("AnimalPodiums") if pods then for _, pod in ipairs(pods:GetChildren()) do
pcall(function() local base = pod:FindFirstChild("Base") local spawnPart = base and base:FindFirstChild("Spawn") if spawnPart then local distance = (spawnPart.Position - root.Position).Magnitude if distance < nearestDistance and distance <= radius then local found = nil; local attachment = spawnPart:FindFirstChild("PromptAttachment") if attachment then for _, child in ipairs(attachment:GetChildren()) do if isStealPrompt(child) then found = child; break end end end if not found then for _, child in ipairs(spawnPart:GetDescendants()) do if isStealPrompt(child) then found = child; break end end
end if found then nearestPrompt = found; nearestDistance = distance; nearestPodName = pod.Name end end end end) end end end end return nearestPrompt, nearestPodName end Steal.updateProgress = function(elapsed, duration) if progressFill then local progress = math.clamp(elapsed / duration, 0, 1); progressFill.Size = UDim2.new(progress, 0, 1, 0); progressFill.BackgroundColor3 = stealBarColor(progress) end if progressPct then progressPct.Text = string.format("%d%%", math.floor(math.clamp(elapsed / duration, 0, 1) * 100)) end end Steal.checkCancelled = function(prompt)
local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart") if not prompt or not prompt.Parent then return true end local pos = getPromptWorldPos(prompt) if not pos and prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then pos = prompt.Parent.Parent.Position end if hrp and pos then local radius = tonumber(Steal.StealRadius) or 20 if (hrp.Position - pos).Magnitude > radius + 4 then return true end end return false end Steal.runPhase1 = function(data, prompt, duration, startTime)
local stopAt = tonumber(autoGrabStopTime) or tonumber(Steal.AutoGrabStopTime) or 1.00 while isCurrentlyStealing and autoStealEnabled do local elapsed = tick() - startTime if elapsed >= stopAt then break end Steal.updateProgress(elapsed, duration) if Steal.checkCancelled(prompt) then break end task.wait() end return math.clamp(stopAt / duration, 0, 1) end Steal.runPhase2 = function(data, prompt, stopProgress, duration, startTime)
local stopAt = tonumber(autoGrabStopTime) or 1.00; local delayR = tonumber(autoGrabDelayRadius) or tonumber(Steal.AutoGrabDelayRadius) or 8; local phase2Timeout = math.max(2.99 - stopAt - math.max(duration - stopAt, 0), 0.05); local phase2Start = tick() while isCurrentlyStealing and autoStealEnabled do if tick() - phase2Start >= phase2Timeout then return "restart" end if Steal.checkCancelled(prompt) then return "cancel" end local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local pos = getPromptWorldPos(prompt)
if not pos and prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then pos = prompt.Parent.Parent.Position end if hrp and pos then local dist = (hrp.Position - pos).Magnitude if dist <= delayR then if progressPct then progressPct.Text = string.format("%d%%", math.floor(stopProgress * 100)) end break elseif dist > (tonumber(Steal.StealRadius) or 20) + 6 then return "cancel" end end task.wait() end return "continue" end Steal.finish = function(data, stopProgress, duration)
local stopAt = tonumber(autoGrabStopTime) or 1.00; local fillStart = tick(); local fillDuration = math.max(duration - stopAt, 0.05) while true do local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1); local totalProgress = stopProgress + fp * (1 - stopProgress) if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0); progressFill.BackgroundColor3 = stealBarColor(totalProgress) end if progressPct then progressPct.Text = string.format("%d%%", math.floor(totalProgress * 100)) end if fp >= 1 then break end task.wait() end
for _, func in ipairs(data.TriggerConnections) do task.spawn(func) end stealsCount = stealsCount + 1 end Steal.resetAfter = function(data) if progressFill then pcall(function() barResetTween = TS:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = stealBarColor(0), }) barResetTween:Play() end) end resetProgressVisuals() if data then data.Ready = true end isCurrentlyStealing = false end function Steal.Execute(prompt, podName) if isCurrentlyStealing then return end if not autoStealEnabled then return end if not prompt then return end
if not Steal.Data[prompt] then Steal.Data[prompt] = { HoldConnections = {}, TriggerConnections = {}, Ready = true, } pcall(function() if getconnections then for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if conn.Function then table.insert(Steal.Data[prompt].HoldConnections, conn.Function) end end for _, conn in ipairs(getconnections(prompt.Triggered)) do if conn.Function then table.insert(Steal.Data[prompt].TriggerConnections, conn.Function) end end end end) end local data = Steal.Data[prompt] if not data.Ready then return end
data.Ready = false; isCurrentlyStealing = true; stealGen = stealGen + 1 if barResetTween then pcall(function() barResetTween:Cancel() end) barResetTween = nil end resetProgressVisuals() if progressFill then progressFill.BackgroundColor3 = stealBarColor(0) end syncStealAliases(); local duration = tonumber(Steal.StealDuration) or 1.3 task.spawn(function() for _, func in ipairs(data.HoldConnections) do task.spawn(func) end local startTime = tick(); local stopProgress = Steal.runPhase1(data, prompt, duration, startTime) if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
if progressPct then progressPct.Text = "DRAINED" end local phase2Result = Steal.runPhase2(data, prompt, stopProgress, duration, startTime) if phase2Result == "restart" then resetProgressVisuals(); data.Ready = true isCurrentlyStealing = false; task.wait() if autoStealEnabled then Steal.Execute(prompt, podName) end return elseif phase2Result == "cancel" then Steal.resetAfter(data) return end if isCurrentlyStealing and autoStealEnabled then Steal.finish(data, stopProgress, duration) end Steal.resetAfter(data) end) end startAutoSteal = function()
autoStealEnabled = true; Steal.AutoStealEnabled = true; autoGrabStopEnabled = true; syncStealAliases() if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", Steal.StealRadius) end if autoStealConnection then return end local _stealLastScan = 0 autoStealConnection = RunService.Heartbeat:Connect(function() if not autoStealEnabled or isCurrentlyStealing then return end local now = os.clock(); local interval = _IS_MOBILE and 0.16 or 0.07 if (now - _stealLastScan) < interval then return end _stealLastScan = now; local prompt, podName = Steal.FindNearestPrompt() if prompt then
pcall(Steal.Execute, prompt, podName) end end) end stopAutoSteal = function() autoStealEnabled = false; Steal.AutoStealEnabled = false; stealGen = stealGen + 1 if autoStealConnection then pcall(function() autoStealConnection:Disconnect() end) autoStealConnection = nil end task.spawn(function() local waitStart = tick() while isCurrentlyStealing and (tick() - waitStart) < 5 do task.wait(0.05) end isCurrentlyStealing = false; resetProgressVisuals() end) end AceAutoStealSync = function() syncStealAliases() if autoStealEnabled then startAutoSteal() else stopAutoSteal() end end
local Conns = {batCounter=nil,anchor={},progress=nil}; local MEDUSA_COOLDOWN,batCounterDebounce = 25,false; local lastMoveDir = Vector3.new(0,0,0) local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true, [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true,[Enum.KeyCode.Down]=true} function F.getActiveMoveSpeed() return S.laggerToggled and (S.laggerPhase==2 and S.LAGGER_CARRY_SPEED or S.LAGGER_SPEED) or (S.speedMode and CS or NS) end function F.getAutoPathSpeed() return NS end function F.isRagdollState(hum)
if not hum then return true end if S.antiRagdollEnabled then return false end local st = hum:GetState() return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or hum.PlatformStand == true end function F.isMyPlotByName(plotName) local plots=workspace:FindFirstChild("Plots") if not plots then return false end local plot=plots:FindFirstChild(plotName) if not plot then return false end local sign=plot:FindFirstChild("PlotSign") if sign then local yb=sign:FindFirstChild("YourBase") if yb and yb:IsA("BillboardGui") then
return yb.Enabled==true end end return false end local spoofedVelocity = Vector3.zero --[[ anti-drop removido ]] local function applyVelocitySpeed(speed)
local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart") if not char or not hum or not root or hum.Health <= 0 then return end if F.isRagdollState(hum) then lastMoveDir = Vector3.new(0, 0, 0) return end if S.autoBatEnabled or S.autoLeftEnabled or S.autoRightEnabled or tpBatEnabled or aimbotEnabled then return end local dir = hum.MoveDirection; local spd = tonumber(speed) or F.getActiveMoveSpeed() or 16 if dir.Magnitude > 0.05 then lastMoveDir = dir pcall(function() if root.SetNetworkOwner then
root:SetNetworkOwner(LP) end end) local unit = dir.Unit local y = root.AssemblyLinearVelocity.Y; spoofedVelocity = Vector3.new(unit.X * 16, y, unit.Z * 16); root.AssemblyLinearVelocity = Vector3.new(unit.X * spd, y, unit.Z * spd) elseif S.antiRagdollEnabled and lastMoveDir.Magnitude > 0.05 then local anyHeld = false for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true break end end if anyHeld then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) local unit = lastMoveDir.Unit
local y = root.AssemblyLinearVelocity.Y; spoofedVelocity = Vector3.new(unit.X * 16, y, unit.Z * 16); root.AssemblyLinearVelocity = Vector3.new(unit.X * spd, y, unit.Z * spd) else spoofedVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end else spoofedVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end if S.speedLabel then local real = root.AssemblyLinearVelocity; S.speedLabel.Text = string.format("Speed: %.1f", Vector3.new(real.X, 0, real.Z).Magnitude) end end RunService.PreSimulation:Connect(function() applyVelocitySpeed(F.getActiveMoveSpeed()) end)
local alConn,arConn=nil,nil local alPhase,arPhase=1,1 function F.stopAutoLeft() if alConn then alConn:Disconnect();alConn=nil end;alPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end F.destroyProxy() end function F.stopAutoRight() if arConn then arConn:Disconnect();arConn=nil end;arPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
if S.autoRightSetVisual then S.autoRightSetVisual(false) end F.destroyProxy() end function F.startAutoLeft() if alConn then alConn:Disconnect() end;alPhase=1 alConn=RunService.Heartbeat:Connect(function() if not S.autoLeftEnabled then return end local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end
if alPhase==1 then local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z) if (tgt-hrp.Position).Magnitude<1 then alPhase=2; local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif alPhase==2 then local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z) if (tgt-hrp.Position).Magnitude<1 then
hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero S.autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end; alPhase=1;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.destroyProxy() return end local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.startAutoRight() if arConn then arConn:Disconnect() end;arPhase=1 arConn=RunService.Heartbeat:Connect(function() if not S.autoRightEnabled then return end
local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end if arPhase==1 then local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z) if (tgt-hrp.Position).Magnitude<1 then
arPhase=2; local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif arPhase==2 then local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z) if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero
S.autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end; arPhase=1;if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.destroyProxy() return end local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.setupSpeedIndicator(char) S.speedLabel = nil pcall(function() local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if head then local oldBb = head:FindFirstChild("CursedSpeedBillboard") while oldBb do
oldBb:Destroy(); oldBb = head:FindFirstChild("CursedSpeedBillboard") end end end) end function F.startUnwalk() local c=LP.Character;if not c then return end; local hum=c:FindFirstChildOfClass("Humanoid") if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end local anim=c:FindFirstChild("Animate") if anim then S.unwalkSavedAnimate=anim:Clone();anim:Destroy() end end function F.stopUnwalk() local c=LP.Character if c and S.unwalkSavedAnimate then S.unwalkSavedAnimate:Clone().Parent=c;S.unwalkSavedAnimate=nil end end
local dropActive = false; local DROP_ASCEND_DURATION = 0.25; local DROP_ASCEND_SPEED = 240; local _dropConn = nil local function _dropSetBtn(state) pcall(function() local entry = (_G.VersincMobileButtonRefs or {}).drop if entry and entry.setActive then entry.setActive(state and true or false) end end) end function F.dropTeleportToFloor(char, hum, root) if not root then return false end local ok = false pcall(function() local params = RaycastParams.new() params.FilterDescendantsInstances = { char } params.FilterType = Enum.RaycastFilterType.Exclude params.IgnoreWater = true
local origin = root.Position + Vector3.new(0, 5, 0) local result = workspace:Raycast(origin, Vector3.new(0, -2000, 0), params) if result and result.Position then local offset = ((hum and hum.HipHeight) or 2) + (root.Size.Y / 2) + 0.05 root.CFrame = CFrame.new(root.Position.X, result.Position.Y + offset, root.Position.Z) ok = true elseif root.Position.Y < -100 then root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z) end root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero
if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end end) return ok end function F.stopAutoTPForAction() if S.autoTPEnabled then pcall(function() if F.stopAutoTP then F.stopAutoTP() end end) S.autoTPEnabled = false pcall(function() if VS and VS.setAutoTPVisual then VS.setAutoTPVisual(false) end end) pcall(function() if F.saveConfig then F.saveConfig() end end) end end function F.runDrop() if dropActive or S.dropActive then return end F.stopAutoTPForAction() local char = LP.Character local hum  = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart") if not char or not hum or not root or hum.Health <= 0 then return end dropActive = true; S.dropActive = true _dropSetBtn(true) local t0 = tick() local duration = tonumber(DROP_ASCEND_DURATION) or 0.25 local speed = tonumber(DROP_ASCEND_SPEED) or 240 if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end local function finish() dropActive = false; S.dropActive = false _dropSetBtn(false) end _dropConn = RunService.Heartbeat:Connect(function() local currentChar = LP.Character
local r  = currentChar and currentChar:FindFirstChild("HumanoidRootPart") local ch = currentChar and currentChar:FindFirstChildOfClass("Humanoid") if not r or not ch or ch.Health <= 0 or not dropActive then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end finish() return end if tick() - t0 >= duration then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero F.dropTeleportToFloor(currentChar, ch, r) finish() return end
r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, speed, r.AssemblyLinearVelocity.Z) end) end function F.stopDrop() dropActive = false; S.dropActive = false if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end _dropSetBtn(false) end LP.CharacterRemoving:Connect(function() F.stopDrop() end) function F.doAutoTPDown(force) local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end if not force then
if hum2.FloorMaterial~=Enum.Material.Air then return end if hrp.Position.Y<S.autoTPHeight then return end end hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z) *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) hrp.AssemblyLinearVelocity=Vector3.zero end function F.startAutoTP() if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end S.autoTPConn=task.spawn(function() while S.autoTPEnabled do task.wait(0.1) pcall(function() F.doAutoTPDown(false) end) end end) end function F.stopAutoTP() S.autoTPEnabled=false
if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end end function F.runTPFloor() pcall(function() F.doAutoTPDown(true) end) end function F.applyAntiLagDerender(obj) pcall(function() if obj:IsA("Beam") or obj:IsA("Attachment") or obj:IsA("Highlight") or obj:IsA("BillboardGui") then local n = (obj.Name or ""):lower() if n:find("versinc") or n:find("tracer") or n:find("lineesp") or n:find("sevenup") or n:find("playeresp") then return end local p = obj.Parent while p do local pn = (p.Name or ""):lower()
if pn:find("versinc") or pn:find("tracer") or pn == "versinctracers" or pn:find("esp") then return end p = p.Parent end end if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then pcall(function() obj:Destroy() end) end elseif obj:IsA("SurfaceAppearance") then pcall(function() obj:Destroy() end) elseif obj:IsA("Accessory") or obj:IsA("Hat") then for _, d in ipairs(obj:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false; d.Material = Enum.Material.Plastic end end elseif obj:IsA("Animator") and obj.Parent and obj.Parent.Parent ~= LP.Character then pcall(function() obj:Destroy() end) end end) end function F.enableAntiLag() S.antiLagEnabled = true if type(enableAntiLag) == "function" then pcall(enableAntiLag) end end function F.disableAntiLag() S.antiLagEnabled = false if type(disableAntiLag) == "function" then pcall(disableAntiLag) end end local _kbOverlay = { screen = nil, conns = {}, buttons = {}, enabled = false, panel = nil, } local function _kbDisconnectAll() for _, c in ipairs(_kbOverlay.conns) do pcall(function() c:Disconnect() end) end
_kbOverlay.conns = {} end local function _kbTrack(conn) table.insert(_kbOverlay.conns, conn) return conn end function F.stopKeyboardOverlay() S.keyboardOverlayEnabled = false; _kbOverlay.enabled = false; _kbDisconnectAll() if _kbOverlay.screen then pcall(function() _kbOverlay.screen:Destroy() end) _kbOverlay.screen = nil end _kbOverlay.buttons = {}; _kbOverlay.panel = nil pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G if env.__VersincKeyboardOverlay then env.__VersincKeyboardOverlay = nil end end) end function F.startKeyboardOverlay()
if _kbOverlay.enabled and _kbOverlay.screen and _kbOverlay.screen.Parent then S.keyboardOverlayEnabled = true return end F.stopKeyboardOverlay(); S.keyboardOverlayEnabled = true _kbOverlay.enabled = true; local guiParent = nil pcall(function() if type(gethui) == "function" then guiParent = gethui() end end) if not guiParent then pcall(function() guiParent = game:GetService("CoreGui") end) end if not guiParent then guiParent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3) end if not guiParent then return end local CONFIG = { guiName = "VersincKeyboardOverlay", uiScale = 1.0,
keySize = 30, keyGap = 4, mouseWidth = 58, mouseHeight = 92, mouseGap = 16, trackSpeed = 1500, trackAttack = 0.65, trackRelease = 0.18, toggleKey = Enum.KeyCode.F8, hideWhileTyping = true, wheelFlash = 0.13, fadeIn = 0.03, fadeOut = 0.11, defaultPos = Vector2.new(0.025, 0.62), } local THEME = { panelFill = Color3.fromRGB(0, 0, 0), panelIdle = 0.40, keyFill = Color3.fromRGB(0, 0, 0), keyIdle = 0.05, pressFill = Color3.fromRGB(255, 255, 255), pressIdle = 0.00, line = Color3.fromRGB(255, 255, 255), lineIdle = 0.35, lineActive = 0.00, textIdle = Color3.fromRGB(255, 255, 255),
textActive = Color3.fromRGB(0, 0, 0), textStroke = 0.70, headerIdle = 0.30, headerLocked = 1.00, font = Enum.Font.GothamBold, fontCaption = Enum.Font.Gotham, } local KEYBOARD_ROWS = { { { id = "Escape", label = "ESC", w = 1.5 }, { id = "One", label = "1" }, { id = "Two", label = "2" }, { id = "Three", label = "3" }, { id = "Four", label = "4" }, { id = "Five", label = "5" }, }, { { id = "Tab", label = "TAB", w = 1.5 }, { id = "Q", label = "Q" }, { id = "W", label = "W" }, { id = "E", label = "E" }, { id = "R", label = "R" }, { id = "T", label = "T" }, }, {
{ id = "CapsLock", label = "CAPS", w = 1.75 }, { id = "A", label = "A" }, { id = "S", label = "S" }, { id = "D", label = "D" }, { id = "F", label = "F" }, { id = "G", label = "G" }, }, { { id = "LeftShift", label = "SHIFT", w = 2.25 }, { id = "Z", label = "Z" }, { id = "X", label = "X" }, { id = "C", label = "C" }, { id = "V", label = "V" }, { id = "B", label = "B" }, }, { { id = "LeftControl", label = "CTRL", w = 1.5 }, { id = "LeftAlt", label = "ALT", w = 1.25 }, { id = "Space", label = "SPACE", w = 3.5 }, }, } local function new(class, props, children) local inst = Instance.new(class)
for key, value in pairs(props or {}) do if key ~= "Parent" then inst[key] = value end end for _, child in ipairs(children or {}) do child.Parent = inst end if props and props.Parent then inst.Parent = props.Parent end return inst end local function kTween(inst, duration, props) TS:Create(inst, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end local Cell = {}; Cell.__index = Cell function Cell.new(fill, stroke, label) return setmetatable({ fill = fill, stroke = stroke, label = label, active = false }, Cell) end function Cell:setActive(on)
if self.active == on then return end self.active = on; local duration = on and CONFIG.fadeIn or CONFIG.fadeOut if self.frame then kTween(self.frame, duration, { BackgroundColor3 = on and THEME.pressFill or THEME.keyFill, BackgroundTransparency = on and THEME.pressIdle or THEME.keyIdle, }) end if self.fill and not self.analog then kTween(self.fill, duration, { BackgroundColor3 = THEME.pressFill, BackgroundTransparency = on and THEME.pressIdle or 1, }) end if self.stroke then kTween(self.stroke, duration, { Color = THEME.line, Transparency = on and THEME.lineActive or THEME.lineIdle, }) end
if self.label and not self.analog then kTween(self.label, duration, { TextColor3 = on and THEME.textActive or THEME.textIdle, TextStrokeTransparency = on and 1 or THEME.textStroke, }) end if self.dot then self.dot.BackgroundColor3 = on and Color3.new(0, 0, 0) or THEME.pressFill; self.dot.BackgroundTransparency = on and 0 or 0.15 end end function Cell:flash(duration) self.flashToken = (self.flashToken or 0) + 1; local token = self.flashToken; self:setActive(true) task.delay(duration or CONFIG.wheelFlash, function() if self.flashToken == token then self:setActive(false) end end) end
local function makeKey(parent, def, rect) local cornerR = def.circle and UDim.new(1, 0) or UDim.new(0, 5) local frame = new("Frame", { Name = def.id or "Key", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(rect.x, rect.y), Size = UDim2.fromOffset(rect.w, rect.h), Parent = parent, }, { new("UICorner", { CornerRadius = cornerR }) }) local stroke = new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = frame, })
local fill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = frame, }, { new("UICorner", { CornerRadius = cornerR }) }) local label if def.label then label = new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = THEME.font, Text = def.label, TextColor3 = THEME.textIdle, TextScaled = true, TextStrokeColor3 = Color3.new(0, 0, 0), TextStrokeTransparency = THEME.textStroke, ZIndex = 3, Parent = frame, }, { new("UIPadding", {
PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), }), new("UITextSizeConstraint", { MaxTextSize = math.max(9, math.floor(rect.h * 0.55)) }), }) end local cell = Cell.new(fill, stroke, label); cell.frame = frame return cell end pcall(function() local old = guiParent:FindFirstChild(CONFIG.guiName) if old then old:Destroy() end end) local screen = new("ScreenGui", { Name = CONFIG.guiName, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent, })
_kbOverlay.screen = screen local HEADER_HEIGHT, PADDING = 18, 8; local unit = CONFIG.keySize + CONFIG.keyGap; local widestRow = 0 for _, row in ipairs(KEYBOARD_ROWS) do local total = 0 for _, def in ipairs(row) do total = total + (def.w or 1) end widestRow = math.max(widestRow, total) end local keysWidth = widestRow * unit - CONFIG.keyGap; local keysHeight = #KEYBOARD_ROWS * unit - CONFIG.keyGap local bodySize = Vector2.new( keysWidth + CONFIG.mouseGap + CONFIG.mouseWidth, math.max(keysHeight, CONFIG.mouseHeight) ) local root = new("Frame", { Name = "Panel", Active = false,
BackgroundColor3 = THEME.panelFill, BackgroundTransparency = THEME.panelIdle, BorderSizePixel = 0, Size = UDim2.fromOffset(bodySize.X + PADDING * 2, bodySize.Y + PADDING * 2 + HEADER_HEIGHT), Position = UDim2.fromScale(CONFIG.defaultPos.X, CONFIG.defaultPos.Y), Parent = screen, }, { new("UIScale", { Scale = CONFIG.uiScale }), new("UICorner", { CornerRadius = UDim.new(0, 10) }), }) new("UIStroke", { Color = THEME.line, Thickness = 1, Transparency = 0.85, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = root, }) local header = new("Frame", { Name = "Handle", Active = true,
BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = THEME.headerIdle, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), Parent = root, }, { new("UICorner", { CornerRadius = UDim.new(0, 8) }), new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 5) }), }) new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Font = THEME.fontCaption, Text = "KEYBOARD + MOUSE", TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.textIdle, TextTransparency = 0.25, Parent = header, }) local body = new("Frame", {
Name = "Body", Active = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(PADDING, HEADER_HEIGHT + PADDING), Size = UDim2.fromOffset(bodySize.X, bodySize.Y), Parent = root, }) local Buttons = {} for rowIndex, row in ipairs(KEYBOARD_ROWS) do local x = 0; local y = (rowIndex - 1) * unit for _, def in ipairs(row) do local width = (def.w or 1) * unit - CONFIG.keyGap local cell = makeKey(body, def, { x = math.floor(x), y = y, w = math.floor(width), h = CONFIG.keySize, }) if def.id then Buttons[def.id] = cell end x = x + (def.w or 1) * unit end end
local originX = keysWidth + CONFIG.mouseGap; local originY = math.floor((bodySize.Y - CONFIG.mouseHeight) / 2); local width, height = CONFIG.mouseWidth, CONFIG.mouseHeight; local radius = math.floor(width * 0.42); local topPart = math.floor(height * 0.40); local wheelW = math.max(7, math.floor(width * 0.16)); local sideW = math.floor((width - wheelW - 4) / 2) local mouseBody = new("Frame", { Name = "Mouse", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(originX, originY),
Size = UDim2.fromOffset(width, height), Parent = body, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = mouseBody, }) local function makeMouseButton(name, clipX, fillX) local clip = new("Frame", { Name = name .. "Clip", BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.fromOffset(clipX, 0), Size = UDim2.fromOffset(sideW, topPart), ZIndex = 2, Parent = mouseBody, }) local fill = new("Frame", {
Name = name, BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(fillX, 0), Size = UDim2.fromOffset(sideW + radius, topPart + radius), Parent = clip, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) local cell = Cell.new(fill, nil, nil) cell.frame = fill return cell end local mouseLeft = makeMouseButton("LeftButton", 0, 0); local mouseRight = makeMouseButton("RightButton", width - sideW, -radius); Buttons.Mouse1 = mouseLeft; Buttons.Mouse2 = mouseRight new("Frame", {
Name = "Split", BackgroundColor3 = THEME.line, BackgroundTransparency = 0.55, BorderSizePixel = 0, Position = UDim2.fromOffset(0, topPart), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4, Parent = mouseBody, }) local wheelH = math.floor(topPart * 0.60) local wheel = new("Frame", { Name = "Wheel", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = 0.1, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(math.floor((width - wheelW) / 2), math.floor(topPart * 0.20)), Size = UDim2.fromOffset(wheelW, wheelH), ZIndex = 5, Parent = mouseBody,
}, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local wheelStroke = new("UIStroke", { Color = THEME.line, Thickness = 1.2, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = wheel, }) local wheelFill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 6, Parent = wheel, }, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local mouseWheel = Cell.new(wheelFill, wheelStroke, nil)
mouseWheel.frame = wheel; mouseWheel.basePosition = wheel.Position; Buttons.Mouse3 = mouseWheel; local zone = math.min(math.floor(width / 2) - 7, math.floor((height - topPart) / 2) - 6) local ring = new("Frame", { Name = "TrackZone", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(math.floor(width / 2), topPart + math.floor((height - topPart) / 2)), Size = UDim2.fromOffset(zone * 2, zone * 2), ZIndex = 3, Parent = mouseBody, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) new("UIStroke", {
Color = THEME.line, Thickness = 1, Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring, }) local trackerDot = new("Frame", { Name = "Pointer", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 0.2, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), ZIndex = 4, Parent = ring, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) local trackerRadius = zone - 4 _kbOverlay.buttons = Buttons local function isTyping()
return CONFIG.hideWhileTyping and UIS:GetFocusedTextBox() ~= nil end local function releaseAll() for _, cell in pairs(Buttons) do cell:setActive(false) end if mouseWheel.frame and mouseWheel.basePosition then mouseWheel.frame.Position = mouseWheel.basePosition end trackerDot.Position = UDim2.fromScale(0.5, 0.5) end local function resolveId(input) local kind = input.UserInputType if kind == Enum.UserInputType.Keyboard then return input.KeyCode.Name elseif kind == Enum.UserInputType.MouseButton1 then return "Mouse1" elseif kind == Enum.UserInputType.MouseButton2 then return "Mouse2"
elseif kind == Enum.UserInputType.MouseButton3 then return "Mouse3" end return nil end _kbTrack(UIS.InputBegan:Connect(function(input) if isTyping() then return end local id = resolveId(input); local cell = id and Buttons[id] if cell then cell:setActive(true) end end)) _kbTrack(UIS.InputEnded:Connect(function(input) local id = resolveId(input) local cell = id and Buttons[id] if cell then cell:setActive(false) end end)) _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseWheel or isTyping() then return end
local up = input.Position.Z > 0; mouseWheel:flash(CONFIG.wheelFlash); local base = mouseWheel.basePosition; mouseWheel.frame.Position = base + UDim2.fromOffset(0, up and -3 or 3) task.delay(CONFIG.wheelFlash, function() if mouseWheel.frame then kTween(mouseWheel.frame, 0.08, { Position = base }) end end) end)) local pointerAccum, pointerCurrent, pointerLast = Vector2.zero, Vector2.zero, nil _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end local delta = Vector2.new(input.Delta.X, input.Delta.Y)
if delta.Magnitude < 0.001 then local position = Vector2.new(input.Position.X, input.Position.Y) if pointerLast then delta = position - pointerLast end pointerLast = position else pointerLast = nil end pointerAccum = pointerAccum + delta end)) _kbTrack(RunService.RenderStepped:Connect(function(step) local frame = math.clamp(step, 1 / 240, 1 / 15) local velocity = pointerAccum / frame; pointerAccum = Vector2.zero; local target = Vector2.zero; local speed = velocity.Magnitude if speed > 1 then
local amount = 1 - math.exp(-speed / CONFIG.trackSpeed); target = velocity.Unit * math.clamp(amount, 0, 1) end local rate = target.Magnitude > pointerCurrent.Magnitude and CONFIG.trackAttack or CONFIG.trackRelease; pointerCurrent = pointerCurrent + (target - pointerCurrent) * math.clamp(rate * frame * 60, 0, 1) if pointerCurrent.Magnitude < 0.004 then pointerCurrent = Vector2.zero end trackerDot.Position = UDim2.new( 0.5, pointerCurrent.X * trackerRadius, 0.5, pointerCurrent.Y * trackerRadius ) trackerDot.BackgroundTransparency = 0.2 - math.min(pointerCurrent.Magnitude, 1) * 0.2 end)) do
local dragInput, startMouse, startOffset _kbTrack(header.InputBegan:Connect(function(input) local kind = input.UserInputType if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end local view = screen.AbsoluteSize; dragInput = input; startMouse = Vector2.new(input.Position.X, input.Position.Y); startOffset = Vector2.new(root.Position.X.Scale * view.X, root.Position.Y.Scale * view.Y) end)) _kbTrack(UIS.InputChanged:Connect(function(input) if not dragInput then return end local moving if dragInput.UserInputType == Enum.UserInputType.Touch then
moving = (input == dragInput) else moving = (input.UserInputType == Enum.UserInputType.MouseMovement) end if not moving then return end local view = screen.AbsoluteSize; local target = startOffset + (Vector2.new(input.Position.X, input.Position.Y) - startMouse); root.Position = UDim2.fromScale(target.X / view.X, target.Y / view.Y) end)) _kbTrack(UIS.InputEnded:Connect(function(input) if dragInput and input == dragInput then dragInput = nil end end)) end _kbTrack(UIS.InputBegan:Connect(function(input) if input.KeyCode ~= CONFIG.toggleKey or isTyping() then return end
screen.Enabled = not screen.Enabled if not screen.Enabled then releaseAll() end end)) _kbTrack(UIS.WindowFocusReleased:Connect(releaseAll)) pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G env.__VersincKeyboardOverlay = { destroy = F.stopKeyboardOverlay, screen = screen } end) end function F.findMedusa() local c = LP.Character if not c then return nil end for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end local bp = LP:FindFirstChild("Backpack")
if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end return nil end function F.useMedusaCounter() if S.medusaDebounce then return end if MEDUSA_COOLDOWN > (tick() - S.medusaLastUsed) then return end local c = LP.Character if not c then return end S.medusaDebounce = true; local med = F.findMedusa() if not med then S.medusaDebounce = false; return end if med.Parent ~= c then local hum2 = c:FindFirstChildOfClass("Humanoid") if hum2 then hum2:EquipTool(med) end end
pcall(function() med:Activate() end) S.medusaLastUsed = tick(); S.medusaDebounce = false end function F.onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 then if S.medusaResetEnabled then if F.doInstaReset then F.doInstaReset() end elseif S.medusaCounterEnabled then F.useMedusaCounter() end end end) end function F.setupMedusa(char) for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} if not char then return end for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end)) end function F.stopMedusaCounter() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} end function F.refreshMedusaWatch() if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) else F.stopMedusaCounter() end end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"} function F.findBatForCounter() local c=LP.Character;if not c then return nil end; local bp=LP:FindFirstChildOfClass("Backpack") for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end return nil end function F.swingBatForCounter(bat,char) local hum2=char:FindFirstChildOfClass("Humanoid") if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end end S.startBatCounter=function() if Conns.batCounter then return end Conns.batCounter=RunService.Heartbeat:Connect(function() if not S.batCounterEnabled then return end if batCounterDebounce then return end local char=LP.Character;if not char then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end; local st=hum2:GetState() if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
batCounterDebounce=true task.spawn(function() local bat=F.findBatForCounter() if bat then F.swingBatForCounter(bat,char) end task.wait(0.5);batCounterDebounce=false end) end end) end S.stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end batCounterDebounce=false end function F.getAutoBatTarget() local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local now=tick() if now-S._autoBatLastScan<=0.1 and S._autoBatTarget and S._autoBatTarget.Parent then
local hum=S._autoBatTarget.Parent:FindFirstChildOfClass("Humanoid") if hum and hum.Health>0 then return S._autoBatTarget end end S._autoBatLastScan=now; S._autoBatTarget=nil; local closest,minDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP and plr.Character then local tRoot=plr.Character:FindFirstChild("HumanoidRootPart"); local hum=plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude if dist<minDist then minDist=dist;closest=tRoot end end end end S._autoBatTarget=closest
return S._autoBatTarget end S.resetAutoBatMotion=function() local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid") if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end if hum then hum.AutoRotate=true end end local _autoTPWasEnabled=false S.enableAutoBat = function() if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end
if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end if S.autoTPEnabled then _autoTPWasEnabled=true;F.stopAutoTP();if VS.setAutoTPVisual then VS.setAutoTPVisual(false) end else _autoTPWasEnabled=false end S.autoBatEquippedThisRun=false; S.autoBatEnabled=true end S.disableAutoBat = function() S.autoBatEnabled=false; S.autoBatEquippedThisRun=false; local char=LP.Character if char then local hum2=char:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate=true end end
if S.resetAutoBatMotion then S.resetAutoBatMotion() end if _autoTPWasEnabled then _autoTPWasEnabled=false;S.autoTPEnabled=true if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end;F.startAutoTP() end F.destroyProxy() end function F.queueAutoLeftStart() if not F.safeModeTryStart() then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; return end S.autoLeftEnabled=true if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end
if S.autoBatEnabled then S.disableAutoBat();if S.autoBatSetVisual then S.autoBatSetVisual(false) end end F.startAutoLeft() end function F.queueAutoRightStart() if not F.safeModeTryStart() then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; return end S.autoRightEnabled=true if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end if S.autoBatEnabled then S.disableAutoBat();if S.autoBatSetVisual then S.autoBatSetVisual(false) end end F.startAutoRight() end
function F.queueAutoBatStart() if not F.safeModeTryStart() then if S.autoBatSetVisual then S.autoBatSetVisual(false) end; return end if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end S.enableAutoBat() end RunService.Heartbeat:Connect(function() if not S.autoBatEnabled then return end
local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local root=char and char:FindFirstChild("HumanoidRootPart") if not root or not hum then return end if not S.autoBatEquippedThisRun then S.autoBatEquippedThisRun=true if not char:FindFirstChildOfClass("Tool") then local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack"); local bpBat=bp and bp:FindFirstChild("Bat") if bpBat then pcall(function() hum:EquipTool(bpBat) end) end end end local target=F.getAutoBatTarget() if target then
local targetVel=target.AssemblyLinearVelocity; local aimTargetPos=target.Position+(targetVel*math.clamp(targetVel.Magnitude/130,0.05,0.15))+Vector3.new(0,S.AUTO_BAT_V_OFF,0); hum.AutoRotate=false; local look=aimTargetPos-root.Position; local flatLook=Vector3.new(look.X,0,look.Z) if look.Magnitude>0.01 and flatLook.Magnitude>0.01 then
local targetYaw=math.deg(math.atan2(-flatLook.X,-flatLook.Z)); local yawDelta=(targetYaw-root.Orientation.Y+180)%360-180; local targetPitch=math.deg(math.atan2(look.Y,flatLook.Magnitude)); local pitchDelta=(targetPitch-root.Orientation.X+180)%360-180; local yawRate=math.clamp(math.rad(yawDelta)*S.AUTO_BAT_TURN_SPEED,-S.AUTO_BAT_MAX_TURN_RATE,S.AUTO_BAT_MAX_TURN_RATE); local pitchRate=math.clamp(math.rad(pitchDelta)*S.AUTO_BAT_TURN_SPEED,-S.AUTO_BAT_MAX_TURN_RATE,S.AUTO_BAT_MAX_TURN_RATE); local yawRad=math.rad(root.Orientation.Y); local rightAxis=Vector3.new(math.cos(yawRad),0,-math.sin(yawRad)); root.AssemblyAngularVelocity=Vector3.new(0,yawRate,0)+(rightAxis*pitchRate)
else root.AssemblyAngularVelocity=Vector3.zero end local dir=look.Magnitude>0.01 and look.Unit or Vector3.zero; local standPos=aimTargetPos-(dir*S.AUTO_BAT_DIST)+Vector3.new(0,S.AUTO_BAT_HEIGHT,0); local moveDir=standPos-root.Position; local hDir=Vector3.new(moveDir.X,0,moveDir.Z); local hVel=hDir.Magnitude>0.1 and hDir.Unit*S.AUTO_BAT_SPEED or Vector3.zero; local vVel=math.abs(moveDir.Y)>0.1 and Vector3.new(0,math.sign(moveDir.Y)*S.AUTO_BAT_VERT_SPEED,0) or Vector3.new(0,-2,0); local proxy = F.ensureProxy() if proxy then proxy.AssemblyLinearVelocity = hVel + vVel end
if hDir.Magnitude>0.5 then hum:Move(hDir.Unit,false) end else hum.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero end if S.autoSwingEnabled then local bat=char:FindFirstChild("Bat") if bat and bat:IsA("Tool") then bat:Activate() end end end) LP.CharacterAdded:Connect(function(char) F.destroyProxy() task.wait(0.5); F.setupSpeedIndicator(char) if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(char) end if S.batCounterEnabled then S.startBatCounter() end if S.unwalkEnabled then task.wait(0.5);F.startUnwalk() end if S.antiRagdollEnabled then
task.wait(0.3); F.startAntiRagdoll() end if infJumpEnabled then task.wait(0.2); F.startInfJump() end if aimbotEnabled then task.wait(0.3); startAimbot() end if tpBatEnabled then task.wait(0.3); startTPBat() end pcall(function() if K7.headlessEnabled then task.wait(0.2); K7.applyHeadless(char, true) end if K7.korbloxEnabled then task.wait(0.2); K7.applyKorblox(char, true) end if S.medusaResetEnabled or S.medusaCounterEnabled then task.wait(0.2); F.setupMedusa(char) end if K7.bodyLockEnabled then task.wait(0.2); K7.startBodyLock() end
if K7.animPackEnabled then task.wait(0.3); K7.applyAnimPack(K7.animPackName) end if K7.lineESPEnabled or K7.speedESPEnabled then task.wait(0.5); K7.refreshESP() end end) end) if LP.Character then F.setupSpeedIndicator(LP.Character) end _G.AceNoPlayerCollisionState = _G.AceNoPlayerCollisionState or {connections = {}, running = false} function F.setOtherPlayerCollision(state) for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do if part:IsA("BasePart") then pcall(function() part.CanCollide = state end) end end
end end end function F.enableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState if st.running then return end S.noPlayerCollisionEnabled = true; st.running = true for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(false) table.insert(st.connections, LP.CharacterAdded:Connect(function() task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end)) table.insert(st.connections, Players.PlayerAdded:Connect(function(plr) local c = plr.CharacterAdded:Connect(function()
task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end) table.insert(st.connections, c) end)) local collisionScanElapsed = 0 table.insert(st.connections, RunService.Heartbeat:Connect(function(dt) if not S.noPlayerCollisionEnabled then return end collisionScanElapsed = collisionScanElapsed + (dt or 0) if collisionScanElapsed < 0.25 then return end collisionScanElapsed = 0 for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then pcall(function() part.CanCollide = false end) end end end end end)) end function F.disableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState; S.noPlayerCollisionEnabled = false if not st.running then return end st.running = false for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(true) end function F.safeModeGetCountdownLabel() local ok, label = pcall(function() local pg = LP:FindFirstChild("PlayerGui") if not pg then return nil end
local a = pg:FindFirstChild("DuelsMachineTopFrame"); local b = a and a:FindFirstChild("DuelsMachineTopFrame"); local t = b and b:FindFirstChild("Timer") return t and t:FindFirstChild("Label") end) return (ok and label) or nil end function F.safeModeCountdownNumber(text) local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "") if t == "GO" or t == "START" or t == "READY" then return true end local n = tonumber(t) return n ~= nil and n >= 0 and n <= 10 end function F.safeModeInDuelCountdown() local label = F.safeModeGetCountdownLabel()
return label and F.safeModeCountdownNumber(label.Text) or false end function F.safeModeHoldingBrainrot() local ok, val = pcall(function() return LP:GetAttribute("Stealing") end) if ok and val == true then return true end local char = LP.Character if not char then return false end local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end) if ok3 and val3 == true then return true end if F.isCarryingBrainrot and F.isCarryingBrainrot(char) then return true end return false end function F.safeModeIsLocked() if not S.safeModeEnabled then return false end
return F.safeModeInDuelCountdown() or F.safeModeHoldingBrainrot() end function F.safeModeForceStop(reason) local stopped = false if tpBatEnabled and stopTPBat then pcall(function() stopTPBat() end) if VS.setTPBatVisual then pcall(VS.setTPBatVisual, false) end stopped = true end if (aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true)) and setAimbotState then pcall(function() setAimbotState(false) end) stopped = true end if S.autoBatEnabled then S.autoBatEnabled = false if S.disableAutoBat then pcall(S.disableAutoBat) end if S.autoBatSetVisual then pcall(S.autoBatSetVisual, false) end stopped = true end if S.autoLeftEnabled then
S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end stopped = true end if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end stopped = true end if stopped then print("[prime.vs] Safe Mode:", reason or "SAFE MODE LOCK") end end function F.safeModeTryStart() if F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") return false end return true end if not _G.__VersincSafeModeMonitor then
_G.__VersincSafeModeMonitor = true RunService.Heartbeat:Connect(function() if S.safeModeEnabled and F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") end end) end function F.setupDeathReset() end _G.AceAutoResetOnMed = _G.AceAutoResetOnMed or { conns = {}, enabled = false, medTriggered = false, lastFire = 0, cooldown = 2.25 } function F.autoResetShouldFire(part) local state = _G.AceAutoResetOnMed if not state or not state.enabled then return false end if state.medTriggered then return false end if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end return part.Anchored == true and part.Transparency == 1 end function F.autoResetFireOnce(part) if not F.autoResetShouldFire(part) then return end local state = _G.AceAutoResetOnMed; state.medTriggered = true; state.lastFire = tick() task.delay(2.3, function() if state.enabled and F.doInstaReset then pcall(F.doInstaReset) end end) end function F.stopAutoResetOnMed() local state = _G.AceAutoResetOnMed if not state then return end
for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end state.conns = {}; state.medTriggered = false end function F.startAutoResetOnMed(char) local state = _G.AceAutoResetOnMed if not state then return end F.stopAutoResetOnMed(); state.medTriggered = false char = char or LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end
table.insert(state.conns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end)) table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent) if not parent then state.medTriggered = false end end)) end function F.setAutoResetOnMed(on) S.autoResetOnMedEnabled = on and true or false; _G.AceAutoResetOnMed.enabled = S.autoResetOnMedEnabled if S.autoResetOnMedEnabled then F.startAutoResetOnMed(LP.Character) else
F.stopAutoResetOnMed() end end if not _G.__VersincMedFlingCharConn then _G.__VersincMedFlingCharConn = true LP.CharacterAdded:Connect(function(char) if S.autoResetOnMedEnabled then task.wait(0.25); F.startAutoResetOnMed(char) end end) end S._tracerFolder = nil; S._tracerConn = nil function F.clearTracers() if S._tracerFolder then pcall(function() S._tracerFolder:Destroy() end) end S._tracerFolder = nil end function F.refreshTracers() if not S.showTracerEnabled then F.clearTracers(); return end local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return end local folder = S._tracerFolder if not folder or not folder.Parent then folder = Instance.new("Folder"); folder.Name = "VersincTracers"; folder.Parent = workspace; S._tracerFolder = folder end local att0 = myRoot:FindFirstChild("VersincTracerAtt") if not att0 or att0.Parent ~= myRoot then if att0 then pcall(function() att0:Destroy() end) end att0 = Instance.new("Attachment"); att0.Name = "VersincTracerAtt"; att0.Parent = myRoot end local alive = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if root and hum and hum.Health > 0 then alive[plr.Name] = true; local beam = folder:FindFirstChild("TR_" .. plr.Name); local att1 = root:FindFirstChild("VersincTracerAtt") if not att1 or att1.Parent ~= root then if att1 then pcall(function() att1:Destroy() end) end att1 = Instance.new("Attachment"); att1.Name = "VersincTracerAtt"; att1.Parent = root end if not beam then
beam = Instance.new("Beam"); beam.Name = "TR_" .. plr.Name; beam.Width0 = 0.12; beam.Width1 = 0.08; beam.FaceCamera = true; beam.LightEmission = 0.65; beam.LightInfluence = 0; beam.Segments = 1; beam.Color = ColorSequence.new((S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(255, 255, 255)); beam.Transparency = NumberSequence.new(0.12); beam.Parent = folder end beam.Attachment0 = att0; beam.Attachment1 = att1 end end end for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Beam") then local name = ch.Name:match("^TR_(.+)$") if name and not alive[name] then
pcall(function() ch:Destroy() end) end end end end function F.setShowTracer(on) S.showTracerEnabled = on and true or false if S._tracerConn then pcall(function() S._tracerConn:Disconnect() end); S._tracerConn = nil end if S.showTracerEnabled then F.refreshTracers(); local acc = 0 S._tracerConn = RunService.Heartbeat:Connect(function(dt) acc = acc + (dt or 0) if acc < 0.2 then return end acc = 0; F.refreshTracers() if S._tracerFolder then for _, ch in ipairs(S._tracerFolder:GetDescendants()) do if ch:IsA("Beam") then ch.Enabled = true end end end end) else F.clearTracers() end end
S._ragdollCdConn = nil; S._ragdollCdCharConn = nil; S._ragdollCdEnd = 0; S._ragdollCdLabel = nil; local RAGDOLL_CD_SECONDS = 2.6 function F.stopRagdollCountdown() if S._ragdollCdConn then S._ragdollCdConn:Disconnect(); S._ragdollCdConn = nil end if S._ragdollCdCharConn then S._ragdollCdCharConn:Disconnect(); S._ragdollCdCharConn = nil end if S._ragdollCdLabel then S._ragdollCdLabel.Visible = false; S._ragdollCdLabel.Text = "" end if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end end
function F.ensureRagdollCdLabel(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")) if not head then return nil end pcall(function() local pg = LP:FindFirstChild("PlayerGui") local old = pg and pg:FindFirstChild("VersincRagdollCD") if old then old:Destroy() end end) if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end
local bb = Instance.new("BillboardGui"); bb.Name = "VersincRagdollCD"; bb.Adornee = head; bb.Size = UDim2.new(0, 90, 0, 40); bb.StudsOffset = Vector3.new(0, 5.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 200; bb.Enabled = false; bb.Parent = head; S._ragdollCdBillboard = bb; local bg = Instance.new("Frame"); bg.Name = "BG"; bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(12, 12, 14); bg.BackgroundTransparency = 0.15; bg.BorderSizePixel = 0; bg.Visible = false; bg.Parent = bb; local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = bg; local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(180, 180, 185); st.Thickness = 1; st.Transparency = 0.4; st.Parent = bg; local lbl = Instance.new("TextLabel"); lbl.Name = "CD"; lbl.Size = UDim2.new(1, -6, 1, -4); lbl.Position = UDim2.new(0, 3, 0, 2); lbl.BackgroundTransparency = 1; lbl.Text = ""; lbl.TextColor3 = Color3.fromRGB(245, 245, 247); lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 18; lbl.TextStrokeTransparency = 0.35; lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); lbl.Visible = false; lbl.Parent = bg; S._ragdollCdLabel = lbl
return lbl end function F.hookRagdollCountdown(char) F.stopRagdollCountdown() if not S.ragdollCountdownEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4) if not hum then return end F.ensureRagdollCdLabel(char); S._ragdollCdEnd = 0 local function showCd(on) local bb = S._ragdollCdBillboard; local lbl = S._ragdollCdLabel if bb then bb.Enabled = on and true or false end if lbl then lbl.Visible = on and true or false if lbl.Parent then lbl.Parent.Visible = on and true or false end
if not on then lbl.Text = "" end end end local function beginCountdown() S._ragdollCdEnd = tick() + RAGDOLL_CD_SECONDS; showCd(true) end local function isRag() local st = hum:GetState() return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown end S._ragdollCdCharConn = hum.StateChanged:Connect(function(_, newState) if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then beginCountdown() end end)
S._ragdollCdConn = RunService.RenderStepped:Connect(function() if not S.ragdollCountdownEnabled then F.stopRagdollCountdown(); return end local lbl = S._ragdollCdLabel if not lbl or not lbl.Parent then F.ensureRagdollCdLabel(LP.Character); lbl = S._ragdollCdLabel if not lbl then return end showCd(false) end if isRag() and S._ragdollCdEnd <= tick() then beginCountdown() end local left = math.max(0, S._ragdollCdEnd - tick()) if left > 0 then showCd(true); lbl.Text = string.format("%.1fs", left) if left <= 0.8 then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) elseif left <= 1.5 then
lbl.TextColor3 = Color3.fromRGB(210, 210, 215) else lbl.TextColor3 = Color3.fromRGB(180, 180, 185) end else showCd(false) end end) showCd(false) end function F.setRagdollCountdown(on) S.ragdollCountdownEnabled = on and true or false if S.ragdollCountdownEnabled then F.hookRagdollCountdown(LP.Character) else F.stopRagdollCountdown() end end if not _G.__VersincRagdollCdChar then _G.__VersincRagdollCdChar = true LP.CharacterAdded:Connect(function(char) if S.ragdollCountdownEnabled then task.wait(0.3); F.hookRagdollCountdown(char) end end) end
_G.VersincMobileButtonRefs = _G.VersincMobileButtonRefs or {}; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} function F.saveMobileButtonPositions() _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local p = h.Position _G.VersincMobileButtonPositions[k] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } end end pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
function F.applyMobileButtonsHidden() local function setEn(g) if g then g.Enabled = not (S.hideMobileButtons == true) end end pcall(function() if gethui then setEn(gethui():FindFirstChild("VersincMobileButtons")) end end) pcall(function() setEn(game:GetService("CoreGui"):FindFirstChild("VersincMobileButtons")) end) local pg = LP:FindFirstChild("PlayerGui") if pg then setEn(pg:FindFirstChild("VersincMobileButtons")) end end function F.applyMobileButtonSize() S.mobileButtonScale = math.clamp(tonumber(S.mobileButtonScale) or 0.80, 0.30, 1.35) for _, entry in pairs(_G.VersincMobileButtonRefs) do
local holder = entry and entry.holder if holder then local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale"); sc.Name = "MobileButtonScale"; sc.Scale = S.mobileButtonScale; sc.Parent = holder end end end function F.resetMobileButtons() S.mobileButtonScale = 0.80; S.hideMobileButtons = false; _G.VersincMobileButtonPositions = {}; F.buildMobileButtons(); F.applyMobileButtonSize(); F.applyMobileButtonsHidden() pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.buildMobileButtons() if _G.__VersincBuildingMobile then return end
_G.__VersincBuildingMobile = true if type(_G.__VersincMobileInputConns) == "table" then for _, c in ipairs(_G.__VersincMobileInputConns) do pcall(function() c:Disconnect() end) end end _G.__VersincMobileInputConns = {}; local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if not pg then _G.__VersincBuildingMobile = false; return end pcall(function() local function wipe(parent) if not parent then return end for _, ch in ipairs(parent:GetChildren()) do if ch.Name == "VersincMobileButtons" then pcall(function() ch:Destroy() end) end end end wipe(pg)
pcall(function() wipe(game:GetService("CoreGui")) end) pcall(function() if type(gethui) == "function" then wipe(gethui()) end end) end) _G.VersincMobileButtonRefs = {} _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {}; local isMobile = false pcall(function() if UIS.TouchEnabled then isMobile = true end end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 900 or vp.Y < 600 then isMobile = true end pcall(function() if UIS.MouseEnabled and UIS.KeyboardEnabled and not UIS.TouchEnabled then isMobile = false end end)
S._isMobileLayout = isMobile local mobileGui = Instance.new("ScreenGui"); mobileGui.Name = "VersincMobileButtons"; mobileGui.ResetOnSpawn = false; mobileGui.IgnoreGuiInset = true; mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mobileGui.DisplayOrder = 9999; mobileGui.Enabled = true; local parented = false pcall(function() if gethui then mobileGui.Parent = gethui(); parented = mobileGui.Parent ~= nil end end) if not parented then pcall(function() mobileGui.Parent = game:GetService("CoreGui"); parented = mobileGui.Parent ~= nil end) end if not parented then mobileGui.Parent = pg end
if S.hideMobileButtons ~= true then mobileGui.Enabled = true else mobileGui.Enabled = false end local mobileButtons = _G.VersincMobileButtonRefs local function udimFromSaved(key, default) local store = _G.VersincMobileButtonPositions or {}; local s = store[key] if type(s) ~= "table" then return default end local xs = tonumber(s.xs); local ys = tonumber(s.ys) if xs == nil or ys == nil then return default end local xo = tonumber(s.xo) or 0; local yo = tonumber(s.yo) or 0 return UDim2.new(xs, xo, ys, yo) end local function savePos(key, holder) if not holder then return end
local p = holder.Position; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} _G.VersincMobileButtonPositions[key] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local hp = h.Position _G.VersincMobileButtonPositions[k] = { xs = hp.X.Scale, xo = hp.X.Offset, ys = hp.Y.Scale, yo = hp.Y.Offset, } end end end local function persistMobilePositions() pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
local function getTheme() return S.themeColor or Color3.fromRGB(245, 245, 247) end local FP_INACTIVE_BG   = Color3.fromRGB(0, 0, 0); local FP_INACTIVE_TEXT = Color3.fromRGB(255, 255, 255); local FP_STROKE        = Color3.fromRGB(255, 255, 255); local FP_ACTIVE_BG     = Color3.fromRGB(255, 255, 255); local FP_ACTIVE_TEXT   = Color3.fromRGB(0, 0, 0) local function setActive(btn, state) if not btn or not btn.Parent then return end state = state == true; local visual = state and "on" or "off"
if btn:GetAttribute("VisualState") == visual then return end btn:SetAttribute("VisualState", visual); local lbl = btn:FindFirstChild("MBLabel"); local st = btn:FindFirstChildOfClass("UIStroke"); local theme = getTheme() if state then btn.BackgroundColor3 = theme; btn.BackgroundTransparency = 0; btn.TextColor3 = FP_ACTIVE_TEXT if lbl then lbl.TextColor3 = FP_ACTIVE_TEXT end if st then st.Color = theme; st.Transparency = 0 end else btn.BackgroundColor3 = FP_INACTIVE_BG; btn.BackgroundTransparency = 0; btn.TextColor3 = FP_INACTIVE_TEXT
if lbl then lbl.TextColor3 = FP_INACTIVE_TEXT end if st then st.Color = theme; st.Transparency = 0.4 end end end _G._VersincApplyMobileTheme = function(col) S.themeColor = col for _, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn and btn.Parent then local st = btn:GetAttribute("VisualState"); btn:SetAttribute("VisualState", nil); setActive(btn, st == "on") end end end local function refreshAllMobileStates() for key, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn then local keep = false if key == "autoLeft" then keep = S.autoLeftEnabled == true
elseif key == "autoRight" then keep = S.autoRightEnabled == true elseif key == "autoBat" then keep = aimbotEnabled == true or (F.isAimbotV2On and F.isAimbotV2On() == true) == true elseif key == "batV2" then keep = F.isAimbotBatV2On and F.isAimbotBatV2On() == true elseif key == "carry" then keep = S.speedMode == true and not S.laggerToggled elseif key == "lagger" then keep = S.laggerToggled == true and S.laggerPhase == 1 elseif key == "laggerCarry" then keep = S.laggerToggled == true and S.laggerPhase == 2 elseif key == "instaReset" then keep = false end setActive(btn, keep) end end end
_G._VersincRefreshMobileButtons = refreshAllMobileStates; _G._VersincRefreshMobileStates = refreshAllMobileStates local function pulse(btn) if not btn then return end btn:SetAttribute("Pressed", true); setActive(btn, true) task.delay(0.15, function() if btn and btn.Parent then btn:SetAttribute("Pressed", false); refreshAllMobileStates() end end) end local btnW, btnH = 60, 60 local function makeButton(key, label, pos, onPress)
local holder = Instance.new("Frame"); holder.Name = "MBH_" .. key; holder.Size = UDim2.new(0, btnW, 0, btnH); holder.Position = udimFromSaved(key, pos); holder.BackgroundTransparency = 1; holder.ZIndex = 1000; holder.Active = true; holder.Parent = mobileGui; local btn = Instance.new("TextButton"); btn.Name = "MB_" .. key; btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = FP_INACTIVE_BG; btn.BackgroundTransparency = 0; btn.BorderSizePixel = 0; btn.Text = ""; btn.TextColor3 = FP_INACTIVE_TEXT; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.TextWrapped = true; btn.AutoButtonColor = false; btn.ZIndex = 1002; btn.Active = true; btn.Selectable = true; btn:SetAttribute("ThemeMobile", true); btn.Parent = holder; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18); local stroke = Instance.new("UIStroke", btn); stroke.Color = FP_STROKE; stroke.Thickness = 1.2; stroke.Transparency = 0.4; local blabel = Instance.new("TextLabel", btn); blabel.Name = "MBLabel"; blabel.Size = UDim2.new(1, 0, 1, 0); blabel.BackgroundTransparency = 1; blabel.Text = label; blabel.TextColor3 = FP_INACTIVE_TEXT; blabel.Font = Enum.Font.GothamBold; blabel.TextSize = 10; blabel.TextWrapped = true; blabel.ZIndex = 1003; local pressing, dragging = false, false; local pressPos, holderStart = nil, nil; local fired = false
local function fireAction() if fired then return end fired = true pcall(function() if onPress then onPress(btn) end end) task.defer(refreshAllMobileStates) task.delay(0.25, function() fired = false end) end local function beginPress(input) pressing = true; dragging = false; fired = false; pressPos = input.Position; holderStart = holder.Position; btn:SetAttribute("Pressed", true) end local function endPress() if not pressing then return end if pressing and not dragging then fireAction() end if dragging then savePos(key, holder); persistMobilePositions() end
pressing = false; dragging = false; btn:SetAttribute("Pressed", false); task.delay(0.05, refreshAllMobileStates) end btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then beginPress(input) end end) local function track(conn) if conn then _G.__VersincMobileInputConns = _G.__VersincMobileInputConns or {}; table.insert(_G.__VersincMobileInputConns, conn) end return conn end track(UIS.InputEnded:Connect(function(input) if not pressing then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then endPress() end end)) local groupStart = nil track(UIS.InputChanged:Connect(function(input) if not pressing then groupStart = nil; return end if S.guiLocked == true or S.lockMobileButtons == true or S.allLockButtons == true or S.moveButtons ~= true then return end if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end if not pressPos then return end local delta = input.Position - pressPos; local thresh = isMobile and 18 or 8
if not dragging and (math.abs(delta.X) > thresh or math.abs(delta.Y) > thresh) then dragging = true if S.allLockButtons == true then groupStart = {} for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then groupStart[k] = h.Position end end end end if dragging then if S.allLockButtons == true and groupStart then for k, startPos in pairs(groupStart) do local entry = (_G.VersincMobileButtonRefs or {})[k] local h = entry and entry.holder if h and h.Parent then h.Position = UDim2.new( startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y ) end end elseif holderStart then holder.Position = UDim2.new( holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y ) end end end)) btn.Activated:Connect(function() if dragging then return end if pressing then endPress() else fireAction() end end) mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end} setActive(btn, false) return btn end local defaults do
local GAP_X, GAP_Y = 8, 14; local MARGIN_R = isMobile and 12 or 18; local totalW = btnW * 3 + GAP_X * 2 local col = { -(totalW + MARGIN_R), -(totalW + MARGIN_R) + (btnW + GAP_X), -(totalW + MARGIN_R) + 2 * (btnW + GAP_X), } local ROWS = 4 local function slot(c, r) return UDim2.new(1, col[c], 0.5, -((ROWS * (btnH + GAP_Y)) / 2) + (r - 1) * (btnH + GAP_Y)) end defaults = { antitp      = slot(1, 1), drop        = slot(2, 1), autoLeft    = slot(3, 1), aimMain = slot(1, 4), autoBat     = slot(2, 2), autoRight   = slot(3, 2), batV2       = slot(1, 2), tp          = slot(2, 3), carry       = slot(3, 3),
laggerCarry = slot(2, 4), lagger      = slot(3, 4), } end makeButton("instaReset", "INSTA\nRESET", defaults.antitp, function(btn) if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() elseif F.doInstaReset then F.doInstaReset() end pulse(btn) end) makeButton("drop", "DROP\nBR", defaults.drop, function(btn) if F.runDrop then F.runDrop() end pulse(btn) end) makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function() if S.autoLeftEnabled then S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end else if F.queueAutoLeftStart then F.queueAutoLeftStart() end
if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end end end) makeButton("autoBat", "BAT\nAIMBOT", defaults.autoBat, function() if F.safeModeTryStart and not F.safeModeTryStart() then return end if setAimbotState then setAimbotState(not (aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true))) end if F.saveConfig then F.saveConfig() end end) makeButton("batV2", "BAT\nV2", defaults.batV2, function() if F.safeModeTryStart and not F.safeModeTryStart() then return end if F.toggleAimbotBatV2 then F.toggleAimbotBatV2() end end) makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function() if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end else if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end end end) makeButton("tp", "TP\nDOWN", defaults.tp, function(btn) if F.runTPFloor then F.runTPFloor() end
pulse(btn) end) makeButton("carry", "CARRY\nSPD", defaults.carry, function() if F.toggleCarryMode then F.toggleCarryMode() end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("lagger", "LAGGER\nMODE", defaults.lagger, function() if S.laggerToggled and S.laggerPhase == 1 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 1 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function()
if S.laggerToggled and S.laggerPhase == 2 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 2 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) if isMobile and (not S.mobileButtonScale or S.mobileButtonScale == 0.80) then S.mobileButtonScale = 1.05 end F.applyMobileButtonSize(); F.applyMobileButtonsHidden() task.defer(function() refreshAllMobileStates() if S.themeColor and _G._VersincApplyMobileTheme then pcall(function() _G._VersincApplyMobileTheme(S.themeColor) end) end end)
-- [FIX] Sync visual state dos botoes (Auto Left / Auto Right e afins) quando a funcao para sozinha
local function _fpStateSig() return tostring(S.autoLeftEnabled == true) .. tostring(S.autoRightEnabled == true) .. tostring(S.autoBatEnabled == true) .. tostring(tpBatEnabled == true) .. tostring(F.isAimbotBatV2On and F.isAimbotBatV2On() == true) .. tostring(_G.__AntiTPBatEnabled == true) .. tostring(S.speedMode == true) .. tostring(S.laggerToggled == true) .. tostring(S.laggerPhase) end
if _G.__VersincVisualSyncLoop then _G.__VersincVisualSyncLoop = false end
_G.__VersincVisualSyncLoop = true
_G.__VersincRefreshMobileStates = refreshAllMobileStates
task.spawn(function()
  local last = nil
  while _G.__VersincVisualSyncLoop do
    local ok, sig = pcall(_fpStateSig)
    if ok and sig ~= last then
      last = sig
      pcall(refreshAllMobileStates)
      pcall(function()
        if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled == true) end
        if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled == true) end
        if S.autoBatSetVisual then S.autoBatSetVisual(S.autoBatEnabled == true) end
      end)
    end
    task.wait(0.1)
  end
end)
_G.__VersincBuildingMobile = false end
-- ===== NO INTRO =====
S.noIntroEnabled = S.noIntroEnabled == true

function F.saveConfig(force) if not _writefile then S._lastSaveOk = false if UI and UI.saveStatusLbl then UI.saveStatusLbl.Text = "Save: no writefile"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120) end return false end local ok, err = pcall(function() local function ks(e) if type(e) ~= "table" then return {kb=nil,gp=nil} end return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil} end local function numFromBox(box, fallback) if box and box.Text then local n = tonumber(box.Text) if n then return n end end return fallback end
if UI then local v v = numFromBox(UI.radInput, nil) if v and v > 0 then autoStealRadius = v; Steal.StealRadius = v end v = numFromBox(UI.stealDurInput, nil) if v and v >= 0.1 then Steal.StealDuration = v end v = numFromBox(UI.stopTimeInput, nil) if v and v > 0 then autoGrabStopTime = v; Steal.AutoGrabStopTime = v end v = numFromBox(UI.delayRadInput, nil) if v and v > 0 then autoGrabDelayRadius = v; Steal.AutoGrabDelayRadius = v end v = numFromBox(UI.normalBox, nil) if v and v > 0 then NS = v end v = numFromBox(UI.carryBox, nil) if v and v > 0 then CS = v end v = numFromBox(UI.laggerBox, nil)
if v and v > 0 then S.LAGGER_SPEED = v end v = numFromBox(UI.laggerCarryBox, nil) if v and v > 0 then S.LAGGER_CARRY_SPEED = v end v = numFromBox(UI.autoTPHeightBox, nil) if v then S.autoTPHeight = v end end
local stealRad = tonumber(autoStealRadius) or (Steal and Steal.StealRadius) or 20; local stealDur = (Steal and tonumber(Steal.StealDuration)) or 1.3; local stopT = tonumber(autoGrabStopTime) or (Steal and tonumber(Steal.AutoGrabStopTime)) or 1.00; local delayR = tonumber(autoGrabDelayRadius) or (Steal and tonumber(Steal.AutoGrabDelayRadius)) or 8; autoGrabStopTime = stopT; autoGrabDelayRadius = delayR if Steal then
Steal.StealRadius = stealRad; Steal.StealDuration = stealDur; Steal.AutoGrabStopTime = stopT; Steal.AutoGrabDelayRadius = delayR; Steal.AutoGrabStopEnabled = autoGrabStopEnabled == true end local cfg = { normalSpeed = NS, carrySpeed = CS, dropBrainrotKey = ks(KB.DropBrainrot), autoLeftKey = ks(KB.AutoLeft), autoRightKey = ks(KB.AutoRight), autoBatKey = ks(KB.AutoBat), tpBatKey = ks(KB.TPBat), batV2Key = ks(KB.BatV2), aimbotV2Key = ks(KB.AimbotV2), laggerToggleKey = ks(KB.LaggerToggle), tpFloorKey = ks(KB.TPFloor), instaResetKey = ks(KB.InstaReset), guiHideKey = ks(KB.GuiHide), speedToggleKey = ks(KB.SpeedToggle),
grabRadius = stealRad, stealDuration = stealDur, selectedStealMode = selectedStealMode, youtAntiBat = (YoutIsAntiBatOn and YoutIsAntiBatOn()) or false, youtOutfitIndex = (YoutGetOutfitIndex and YoutGetOutfitIndex()) or 1, aceStealRadii = AceStealRadii and { Normal = AceStealRadii.Normal, Semi = AceStealRadii.Semi } or nil, autoGrabStopEnabled = autoGrabStopEnabled == true, autoGrabStopTime = stopT, autoGrabDelayRadius = delayR, antiRagdollMode = S.antiRagdollMode or 1, aimbotMode = S.aimbotMode or 1, antiRagdoll = S.antiRagdollEnabled, antiDieEnabled = S.antiDieEnabled, antiFlingShieldEnabled = S.antiFlingShieldEnabled, removeAccessories = S.removeAccessoriesEnabled, autoStealEnabled = autoStealEnabled,
medusaCounter = S.medusaCounterEnabled, medusaReset = S.medusaResetEnabled, batCounter = S.batCounterEnabled, infJump = infJumpEnabled, aimbot = aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true), aimbotV1 = aimbotEnabled == true, aimbotV2 = (F.isAimbotV2On and F.isAimbotV2On() == true) or false, batV2 = (F.isAimbotBatV2On and F.isAimbotBatV2On()) or false, tpBat = tpBatEnabled, antiBatBypass = S.antiBatBypassEnabled == true or antiBatBypassLockEnabled == true, aimbotSpeed = AIMBOT_SPEED or 63, autoLeft = S.autoLeftEnabled == true, autoRight = S.autoRightEnabled == true, tpBatMode = tpBatMode, tpBatLegacyKey = (TP_BAT_KEY and TP_BAT_KEY.Name) or "V", carryMode = S.speedMode, laggerMode = S.laggerToggled, laggerCarryMode = S.laggerPhase == 2, autoCarrySpeedEnabled = S.autoCarrySpeedEnabled,
noPlayerCollisionEnabled = S.noPlayerCollisionEnabled, safeModeEnabled = S.safeModeEnabled, autoResetOnMedEnabled = S.autoResetOnMedEnabled, laggerSpeed = S.LAGGER_SPEED, laggerCarrySpeed = S.LAGGER_CARRY_SPEED, autoBat = S.autoBatEnabled, autoSwing = S.autoSwingEnabled, unwalkEnabled = S.unwalkEnabled, antiLag = S.antiLagEnabled, keyboardOverlay = S.keyboardOverlayEnabled == true, stretchRez = S.stretchRezEnabled, autoTPEnabled = S.autoTPEnabled, autoTPHeight = S.autoTPHeight, skyTheme = K7 and K7.currentSkyTheme or nil, fovEnabled = K7 and K7.fovEnabled or false,
fovValue = (K7 and K7.fovValue) or (_G._VezyFOV) or 70, headless = K7 and K7.headlessEnabled or false, korbloxSide = korbloxSide or (K7 and K7.korbloxSide) or 1, korblox = K7 and K7.korbloxEnabled or false, bodyLock = K7 and K7.bodyLockEnabled or false, bodyLockRadius = K7 and K7.bodyLockRadius or 60, lineESP = K7 and K7.lineESPEnabled or false, speedESP = K7 and K7.speedESPEnabled or false, animPackEnabled = K7 and K7.animPackEnabled or false, animPack = K7 and K7.animPackName or nil, animPackIndex = K7 and K7.animPackIndex or 1,
guiScale = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or 1, themeName = S.currentThemeName or currentThemeName or "WHITE", bgId = S.currentBgId or "", bgIntensity = S.bgIntensity or 0.58, autoSaveEnabled = S.autoSaveEnabled, showTracerEnabled = S.showTracerEnabled, ragdollCountdownEnabled = S.ragdollCountdownEnabled, guiLocked = S.guiLocked, hubPos = S.hubPos, miniPos = S.miniPos, hideMobileButtons = S.hideMobileButtons, lockMobileButtons = S.lockMobileButtons == true, allLockButtons = S.allLockButtons == true, moveButtons = S.moveButtons == true,
progressBarScale = S.progressBarScale or 100, stealBarPos = S.stealBarPos, keyboardOverlay = S.keyboardOverlayEnabled == true, mobileButtonScale = S.mobileButtonScale, infJumpMode = S.infJumpMode or "hold", mirrorTPDown = S.mirrorTPDownEnabled == true, mobileButtonPositions = _G.VersincMobileButtonPositions, batSkinId = S.savedBatSkin, medusaSkinId = S.savedMedusaSkin, bleedPack = S.savedBleedPack or "Off", vx7Outfit = S.savedVX7Outfit or 0, rainbowTools = S.rainbowToolsEnabled == true, noIntro = S.noIntroEnabled == true, } local encoded = HS:JSONEncode(cfg) _writefile(CONFIG_FILE, encoded) pcall(function() _writefile(CONFIG_FILE_LEGACY, encoded) end) end) S._lastSaveOk = ok and true or false S._lastSaveAt = tick() if UI and UI.saveStatusLbl then if ok then
UI.saveStatusLbl.Text = "Saved OK"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(100, 220, 160) else UI.saveStatusLbl.Text = "Save failed"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120); warn("[prime.vs] F.saveConfig error:", err) end end return ok end task.spawn(function() while true do task.wait(5) if S.autoSaveEnabled ~= false then pcall(function() F.saveConfig(true) end) end end end) local CONFIG_EXPORT_FILE = "PrimeVSHub_Export.json"
local CONFIG_IMPORT_FILE = "PrimeVSHub_Import.json"; local _setclipboard = setclipboard or toclipboard or (syn and syn.write_clipboard); local _getclipboard = getclipboard or (syn and syn.read_clipboard) function F.saveMobileButtonsOnly() if not _writefile then return false end local ok = pcall(function() local raw = nil if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end local cfg = {} if raw and raw ~= "" then pcall(function() cfg = HS:JSONDecode(raw) or {} end) end if type(cfg) ~= "table" then cfg = {} end
cfg.mobileButtonPositions = _G.VersincMobileButtonPositions or cfg.mobileButtonPositions; cfg.mobileButtonScale = S.mobileButtonScale; cfg.hideMobileButtons = S.hideMobileButtons == true; cfg.lockMobileButtons = S.lockMobileButtons == true; cfg.allLockButtons = S.allLockButtons == true; cfg.moveButtons = S.moveButtons == true; cfg.progressBarScale = S.progressBarScale or 100; _writefile(CONFIG_FILE, HS:JSONEncode(cfg)) end) return ok == true end function F.exportConfig() local okSnap = pcall(function() if F.saveConfig then F.saveConfig(true) end end) local raw = nil
if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end if not raw or raw == "" then return false, "no_config" end pcall(function() _writefile(CONFIG_EXPORT_FILE, raw) end) local copied = false if _setclipboard then copied = pcall(_setclipboard, raw) end return true, copied and "copied_and_exported" or "exported_to_file" end function F.importConfig(pastedText) local raw = tostring(pastedText or ""):match("^%s*(.-)%s*$") or "" if raw == "" and _getclipboard then local clipOk, clip = pcall(_getclipboard)
if clipOk and type(clip) == "string" then raw = clip:match("^%s*(.-)%s*$") or "" end end if raw == "" and _isfile(CONFIG_IMPORT_FILE) then pcall(function() raw = tostring(_readfile(CONFIG_IMPORT_FILE) or ""):match("^%s*(.-)%s*$") or "" end) end if raw == "" then return false, "empty" end local valid, decoded = pcall(function() return HS:JSONDecode(raw) end) if not valid or type(decoded) ~= "table" then return false, "invalid_json" end local encodedOk, normalized = pcall(function() return HS:JSONEncode(decoded) end) if not encodedOk then return false, "encode_failed" end
pcall(function() _writefile(CONFIG_FILE, normalized) end) _savedCfg = decoded pcall(function() if F.loadConfigKeys then F.loadConfigKeys() end if F.loadConfigState then F.loadConfigState() end end) return true, "imported" end function F.resetAllConfig() pcall(function() if S.antiRagdollEnabled then S.antiRagdollEnabled=false; F.stopAntiRagdoll() end end) pcall(function() if infJumpEnabled then infJumpEnabled=false; F.stopInfJump() end end) pcall(function() if tpBatEnabled and setTPBatState then setTPBatState(false) end end)
pcall(function() if (aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true)) and setAimbotState then setAimbotState(false) end end) pcall(function() if F.stopAimbotBatV2 then F.stopAimbotBatV2() end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.autoBatEnabled=false; S.disableAutoBat() end end) pcall(function() if S.laggerToggled then S.laggerToggled=false; S.laggerPhase=0 end end) pcall(function() if S.speedMode then S.speedMode=false end end) pcall(function() if S.autoTPEnabled and F.stopAutoTP then F.stopAutoTP() end end) pcall(function() if S.unwalkEnabled and F.stopUnwalk then S.unwalkEnabled=false; F.stopUnwalk() end end)
pcall(function() if S.antiLagEnabled and F.disableAntiLag then F.disableAntiLag() end end) pcall(function() if F.stopKeyboardOverlay then F.stopKeyboardOverlay() end end) pcall(function() if S.stretchRezEnabled and disableStretchRez then disableStretchRez() end end) pcall(function() if S.showTracerEnabled and F.setShowTracer then F.setShowTracer(false) end end) pcall(function() if S.ragdollCountdownEnabled and F.setRagdollCountdown then F.setRagdollCountdown(false) end end) pcall(function() if S.noPlayerCollisionEnabled and F.disableNoPlayerCollision then F.disableNoPlayerCollision() end end)
pcall(function() if autoStealEnabled and stopAutoSteal then stopAutoSteal() end end) pcall(function() if S.batCounterEnabled and S.stopBatCounter then S.batCounterEnabled=false; S.stopBatCounter() end end) pcall(function() if S.medusaCounterEnabled or S.medusaResetEnabled then S.medusaCounterEnabled=false; S.medusaResetEnabled=false end end) pcall(function() if S.autoResetOnMedEnabled and F.setAutoResetOnMed then F.setAutoResetOnMed(false) end end)
NS, CS = 60, 30; S.NS, S.CS = 60, 30; S.LAGGER_SPEED, S.LAGGER_CARRY_SPEED = 15, 24.5; S.autoTPHeight = 20; S.autoCarrySpeedEnabled = false; S.safeModeEnabled = false; S.autoSwingEnabled = true; S.guiLocked = false; S.lockMobileButtons = false; S.moveButtons = false; S.progressBarScale = 100; S.hideMobileButtons = false; S.mobileButtonScale = 0.80; S.autoSaveEnabled = true; S.autoLeftEnabled = false; S.autoRightEnabled = false; S.dropActive = false; S.noPlayerCollisionEnabled = false; S.showTracerEnabled = false; S.ragdollCountdownEnabled = false; S.autoResetOnMedEnabled = false; S.medusaCounterEnabled = false; S.medusaResetEnabled = false; S.batCounterEnabled = false; S.unwalkEnabled = false; S.antiLagEnabled = false; S.stretchRezEnabled = false; S.antiRagdollEnabled = false; S.autoTPEnabled = false; S.autoBatEnabled = false; S.aimbotMode = 1; if S.refreshAimbotMode then S.refreshAimbotMode() end; S.speedMode = false; S.laggerToggled = false; S.laggerPhase = 0; KB.DropBrainrot = {kb=Enum.KeyCode.H, gp=nil}; KB.AutoLeft = {kb=Enum.KeyCode.Z, gp=nil}; KB.AutoRight = {kb=Enum.KeyCode.C, gp=nil}; KB.AutoBat = {kb=Enum.KeyCode.E, gp=nil}; KB.TPBat = {kb=Enum.KeyCode.V, gp=Enum.KeyCode.ButtonY}; KB.TPFloor = {kb=Enum.KeyCode.F, gp=nil}; KB.InstaReset = {kb=Enum.KeyCode.T, gp=nil}; KB.GuiHide = {kb=Enum.KeyCode.LeftControl, gp=nil}; KB.SpeedToggle = {kb=Enum.KeyCode.Q, gp=nil}; KB.LaggerToggle = {kb=Enum.KeyCode.R, gp=nil}; TP_BAT_KEY = Enum.KeyCode.V; TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY; tpBatMode = 1
pcall(function() selectedStealMode = "Normal" AceStealRadii = AceStealRadii or {Normal=55, Semi=20}; AceStealRadii.Normal = 55; AceStealRadii.Semi = 20; autoStealRadius = 55 if Steal then Steal.StealRadius = 55; Steal.StealDuration = 1.3 end autoGrabStopEnabled = false end) pcall(function() if K7 then K7.lineESPEnabled = false; K7.speedESPEnabled = false; K7.fovEnabled = false; K7.bodyLockEnabled = false; K7.bodyLockRadius = 60; K7.headlessEnabled = false; K7.korbloxEnabled = false; K7.animPackEnabled = false if K7.refreshESP then K7.refreshESP() end end end)
_G.VersincMobileButtonPositions = {} pcall(function() if F.resetMobileButtons then F.resetMobileButtons() end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) pcall(function() if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(1) end end) pcall(function() local df = delfile or (syn and syn.delfile) if df then if _isfile(CONFIG_FILE) then df(CONFIG_FILE) end if _isfile(CONFIG_FILE_LEGACY) then df(CONFIG_FILE_LEGACY) end elseif _writefile then _writefile(CONFIG_FILE, "{}"); _writefile(CONFIG_FILE_LEGACY, "{}") end end) _savedCfg = nil
pcall(function() if UI.normalBox then UI.normalBox.Text = "60" end if UI.carryBox then UI.carryBox.Text = "30" end if UI.laggerBox then UI.laggerBox.Text = "15" end if UI.laggerCarryBox then UI.laggerCarryBox.Text = "24.5" end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text = "20" end if UI.radInput then UI.radInput.Text = "55" end if UI.stealModeLbl then UI.stealModeLbl.Text = "Normal" end if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = "0.80" end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) local visualOff = {
"setAntiRagVisual","setInfJumpVisual","setTPBatVisual","setAutoTPVisual","setUnwalkVisual", "setAntiLagVisual","setStretchRezVisual","setShowTracerVisual","setRagdollCdVisual", "setNoPlayerCollisionVisual","setSafeModeVisual","setMedusaVisual","setMedusaResetVisual", "setAutoResetOnMedVisual","setBatCounterVisual", "setAutoSwingVisual","setLockGuiVisual","setHideMobileVisual","setLineESPVisual", "setSpeedESPVisual","setBodyLockVisual","setHeadlessVisual","setKorbloxVisual","setAnimPackVisual", "setFOVVisual", } for _, name in ipairs(visualOff) do
pcall(function() if VS[name] then VS[name](false) end end) end pcall(function() if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(false) end end) pcall(function() if S.autoBatSetVisual then S.autoBatSetVisual(false) end end) pcall(function() if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end) pcall(function() if S.autoRightSetVisual then S.autoRightSetVisual(false) end end) pcall(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = "Config reset" end end) local ok = F.saveConfig(true) if UI and UI.saveStatusLbl then
UI.saveStatusLbl.Text = ok and "Config reset OK" or "Reset done (save fail)"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 200, 100) end print("[prime.vs] All configs reset to defaults") return ok end VS = VS or {}; UI = UI or {} function F.refreshSpeedModeLabel() if modeValLbl then modeValLbl.Text=S.laggerToggled and (S.laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (S.speedMode and "Carry" or "Normal") end end function F.getSpeedModeName() if S.laggerToggled then return (S.laggerPhase == 2) and "Lagger Carry" or "Lagger"
elseif S.speedMode then return "Carry" end return "Normal" end function F.setSpeedModeName(mode) if mode == "Lagger Carry" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 2 elseif mode == "Lagger" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 1 elseif mode == "Carry" then S.laggerToggled = false; S.speedMode = true; S.laggerPhase = 0 else S.laggerToggled = false; S.speedMode = false; S.laggerPhase = 0 end F.refreshSpeedModeLabel() end function F.isCarryName(name) local n = tostring(name or ""):lower()
return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") end function F.isIgnoredCarryTool(name) local n = tostring(name or ""):lower() return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone") end function F.isCarryingBrainrot(char) if not char then return false end for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do local v = char:FindFirstChild(name, true) if v then if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end if v:IsA("StringValue") and v.Value ~= "" then return true end end end for _, child in ipairs(char:GetChildren()) do if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end if F.isCarryName(child.Name) then return true end elseif child:IsA("Tool") and not F.isIgnoredCarryTool(child.Name) then return true end end return false end function F.enableCarrySpeedForSteal()
S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 if not S._autoCarryFromSteal then S._autoCarryReturnMode = F.getSpeedModeName() end S._autoCarryFromSteal = true; S._autoCarryGraceUntil = tick() + 0.75 local wasLagger = (S._autoCarryReturnMode == "Lagger" or S._autoCarryReturnMode == "Lagger Carry" or F.getSpeedModeName() == "Lagger" or F.getSpeedModeName() == "Lagger Carry") if wasLagger then F.setSpeedModeName("Lagger Carry") else F.setSpeedModeName("Carry") end pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.disableAutoCarrySpeed()
if not S._autoCarryFromSteal and not S._autoCarryWaitingPickup then return end local wasAutoApplied = S._autoCarryFromSteal == true; local returnMode = S._autoCarryReturnMode; S._autoCarryFromSteal = false; S._autoCarryWaitingPickup = false; S._autoCarryGraceUntil = 0; S._autoCarryPickupUntil = 0; S._autoCarryReturnMode = nil if not wasAutoApplied then return end if returnMode == "Lagger" or returnMode == "Lagger Carry" then F.setSpeedModeName("Lagger") elseif returnMode == "Carry" then F.setSpeedModeName("Carry") else F.setSpeedModeName("Normal") end
pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.startAutoCarryPickupWatch(seconds) if S.autoCarrySpeedEnabled ~= true then return end S._autoCarryWaitingPickup = true; S._autoCarryPickupUntil = tick() + (seconds or 1.25) end RunService.RenderStepped:Connect(function() if S.autoCarrySpeedEnabled ~= true then if S._autoCarryFromSteal or S._autoCarryWaitingPickup then F.disableAutoCarrySpeed() end return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then F.disableAutoCarrySpeed(); S._stealAttrWasActive = false return end local st = hum:GetState(); local gotHit = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown local stealingAttr = false pcall(function() stealingAttr = (LP:GetAttribute("Stealing") == true) end) local carryingBrainrot = F.isCarryingBrainrot(char) if stealingAttr and not S._stealAttrWasActive then S._stealAttrWasActive = true; F.enableCarrySpeedForSteal() elseif not stealingAttr then S._stealAttrWasActive = false end
if S._autoCarryWaitingPickup then if gotHit or tick() > (S._autoCarryPickupUntil or 0) then S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 elseif carryingBrainrot then F.enableCarrySpeedForSteal() end end if carryingBrainrot and not S._autoCarryFromSteal then F.enableCarrySpeedForSteal() end if S._autoCarryFromSteal then local graceDone = tick() > (S._autoCarryGraceUntil or 0) if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then F.disableAutoCarrySpeed() end end end) function F.toggleCarryMode() if S.laggerToggled then
S.laggerToggled=false; S.laggerPhase=0; S.speedMode=true else S.speedMode=not S.speedMode end F.refreshSpeedModeLabel() end function F.toggleLaggerMode() if not S.laggerToggled then S.speedMode=false; S.laggerToggled=true; S.laggerPhase=2 elseif S.laggerPhase==2 then S.laggerPhase=1 else S.laggerPhase=2 end F.refreshSpeedModeLabel() end function F.buildGui() local COLORS = { bg = Color3.fromRGB(6, 6, 8), row = Color3.fromRGB(14, 14, 16), row2 = Color3.fromRGB(22, 22, 26), stroke = Color3.fromRGB(255, 255, 255), strokeSoft = Color3.fromRGB(55, 55, 60), white = Color3.fromRGB(245, 245, 250),
textDim = Color3.fromRGB(140, 140, 150), toggleBg = Color3.fromRGB(28, 28, 32), knob = Color3.fromRGB(255, 255, 255), accent = Color3.fromRGB(255, 255, 255), accentStrong = Color3.fromRGB(255, 255, 255), on = Color3.fromRGB(255, 255, 255), off = Color3.fromRGB(30, 30, 34), } local THEME_PRESETS = { { name = "HALLOWEEN", color = Color3.fromRGB(255, 110, 30) }, { name = "PUMPKIN", color = Color3.fromRGB(255, 140, 20) }, { name = "BLOOD", color = Color3.fromRGB(180, 20, 30) }, { name = "PURPLE", color = Color3.fromRGB(140, 40, 200) }, { name = "ORANGE", color = Color3.fromRGB(255, 120, 0) },
{ name = "GREEN",  color = Color3.fromRGB(40, 180, 60) }, { name = "RED",    color = Color3.fromRGB(220, 30, 40) }, { name = "CYAN",   color = Color3.fromRGB(80, 220, 255) }, { name = "PINK", color = Color3.fromRGB(255, 70, 180) }, { name = "BLUE", color = Color3.fromRGB(70, 120, 255) }, } local BG_RESOLVED = { None = "" }
local BG_PRESETS = { { name = "None", id = "" } }

-- ================= YOUT MERGE (outfits + auto steal V1/V2 + anti bat + insta reset) =================
do
local Workspace = workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _tick = tick
local _clamp = math.clamp
local _floor = math.floor
local _abs = math.abs
local _huge = math.huge
local _sqrt = math.sqrt
local _V3new = Vector3.new
local _V3zero = Vector3.zero
local _CFnew = CFrame.new
local antiBatEnabled = false
local antiDieEnabled = false
local _antiDieEnabled = false
local _antiDieSetEnabled = nil
local AntiDieModule = nil
local YoutStealCFG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
local selectedStealMode = "V1"

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("YoutOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("YoutOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("YoutOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("YoutOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("YoutOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("YoutOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("YoutOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("YoutOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("YoutOutfitModifiedMeshPart", nil)
        head:SetAttribute("YoutOutfitOriginalMeshId", nil)
        head:SetAttribute("YoutOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("YoutOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("YoutOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("YoutOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("YoutOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("YoutOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("YoutOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("YoutOutfitOriginalTextureId", nil)
        end
    end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 8349240186, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, korblox = "none", label = "Outfit 3", headlessKorblox = true },
    { accessory = 121097973925756, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 4", headlessKorblox = true },
    { label = "Homero Chino", customApply = applyHomeroOutfit },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("YoutOutfitOriginalTransparency") == nil then
            head:SetAttribute("YoutOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("YoutOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                part:SetAttribute("YoutOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("YoutOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("YoutOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("YoutOutfitModifiedMeshPart") then
                head:SetAttribute("YoutOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("YoutOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("YoutOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("YoutOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("YoutOutfitModifiedMesh") then
            sm:SetAttribute("YoutOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("YoutOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("YoutOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

YoutStealCFG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }

local stealConnection = nil

local Steal = { AutoStealEnabled = false, StealRadius = YoutStealCFG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {} }

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "READY" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "READY" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "READY" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "READY" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            if #data.trigger > 0 then
                                for _, f in ipairs(data.trigger) do task.spawn(f) end
                            else
                                local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                                if remote and podName then remote:FireServer(podName) end
                            end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        if #data.trigger > 0 then
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                        else
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                        end
                    end)
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "READY" end
        data.ready = true
        isStealing = false
    end)
end

-- =====================================================================
-- AUTO STEAL V2
-- =====================================================================
_G.YoutV2Steal = _G.YoutV2Steal or {
    enabled = false, radius = 10, primeRange = 80, holdMin = 1.3, holdMax = 2.6,
    entryDelay = 0.25, cooldown = 0.05,
    animals = {}, promptCache = {}, internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plotSync = {caches = {}, connections = {}}, plots = nil, syncReady = false,
    scanThread = nil, conn = nil, lastScan = 0,
    animalsData = nil, channelFolder = nil, routeRemote = nil, requestData = nil
}

local function _yv2Root()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

local function _yv2SplitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(p) or p) end
    return out
end

local function _yv2ResolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_yv2SplitPath(path)) do
        par = cur; key = p; cur = cur and cur[p] or nil
    end
    return cur, par, key
end

local function _yv2ApplyDiff(channelName, packet)
    local cache = _G.YoutV2Steal.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local cur, par, key = _yv2ResolvePath(path, cache)
    if action == "Changed" then
        if par then par[key] = a end
    elseif action == "ArrayInsert" then
        if cur then table.insert(cur, b, a) end
    elseif action == "ArrayRemoved" then
        if cur then table.remove(cur, b) end
    elseif action == "DictionaryInsert" then
        if cur then cur[b] = a end
    elseif action == "DictionaryRemoved" then
        if cur then cur[b] = nil end
    end
end

local function _yv2AttachChannel(remote, plots, requestData)
    local A = _G.YoutV2Steal
    if A.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and A.plotSync.caches[channelName] == nil then
        local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
        A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif A.plotSync.caches[channelName] == nil then
        A.plotSync.caches[channelName] = {}
    end
    A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do _yv2ApplyDiff(channelName, packet) end
    end)
end

local function _yv2EnsureSync()
    local A = _G.YoutV2Steal
    if A.syncReady then return true end
    local ok = pcall(function()
        A.plots = workspace:WaitForChild("Plots", 8)
        local rs = game:GetService("ReplicatedStorage")
        local pkgs = rs:FindFirstChild("Packages")
        local datas = rs:FindFirstChild("Datas")
        if not (pkgs and datas and A.plots) then return end
        A.animalsData = require(datas:WaitForChild("Animals", 10))
        local sync = pkgs:FindFirstChild("Synchronizer") or pkgs:WaitForChild("Synchronizer", 10)
        if not sync then return end
        A.channelFolder = sync:FindFirstChild("Channel") or sync:WaitForChild("Channel", 10)
        A.routeRemote = sync:FindFirstChild("CommunicationRoute") or sync:WaitForChild("CommunicationRoute", 10)
        A.requestData = sync:FindFirstChild("RequestData")
        if A.channelFolder then
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end)
        end
        if A.routeRemote then
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, cn = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(cn) then
                        if kind == "ListenerAdded" then
                            local r = A.channelFolder and A.channelFolder:FindFirstChild(cn)
                            if r and r:IsA("RemoteEvent") then _yv2AttachChannel(r, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == cn then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[cn] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        A.syncReady = true
    end)
    return ok and A.syncReady == true
end

local function _yv2PlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function _yv2IsMyBase(animalData)
    local A = _G.YoutV2Steal
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _yv2PlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

local function _yv2PodiumFor(animalData)
    local A = _G.YoutV2Steal
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local pds = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end

local function _yv2AnimalPos(animalData)
    local pod = _yv2PodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end

local function _yv2DistToAnimal(animalData)
    local root = _yv2Root()
    local pos = _yv2AnimalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

local function _yv2FindPrompt(animalData)
    local A = _G.YoutV2Steal
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local pod = _yv2PodiumFor(animalData)
    if not pod then return nil end
    for _, p in ipairs(pod:GetDescendants()) do
        if p:IsA("ProximityPrompt") then A.promptCache[animalData.uid] = p return p end
    end
    return nil
end

local function _yv2BuildCallbacks(prompt)
    local A = _G.YoutV2Steal
    if A.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    pcall(function()
        if getconnections then
            local holds = getconnections(prompt.PromptButtonHoldBegan) or getconnections(prompt.HoldBegan) or {}
            for _, c in ipairs(holds) do
                if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end
            end
            local triggers = getconnections(prompt.Triggered) or {}
            for _, c in ipairs(triggers) do
                if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end
            end
        end
    end)
    A.internalCache[prompt] = data
end

local function _yv2SetBar(p)
    if progressFill then progressFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

local function _yv2ResetBar()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "READY" end
end

local function _yv2Execute(prompt, animalData)
    local A = _G.YoutV2Steal
    if not prompt or not prompt.Parent or not animalData then return false end
    if A.state.active then return false end
    if _tick() - (A.state.lastResultTime or 0) < (A.cooldown or 0.05) then return false end
    _yv2BuildCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    A.state.active = true
    A.state.startTime = _tick()
    A.state.phase = "holding"
    A.state.label = animalData.name or "Animal"
    task.spawn(function()
        local t0 = A.state.startTime
        local stops = {0.70, 0.75, 0.80, 0.85, 0.90}
        local SEMI_STOP = stops[math.random(1, #stops)]
        if _G.__StealV3 == true or _G.__StealStopPct then SEMI_STOP = tonumber(_G.__StealStopPct) or 0.80 end
        if #data.holdCallbacks > 0 then
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
        else
            pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
        end
        while A.enabled and selectedStealMode == "V2" and YoutStealCFG.AUTO_STEAL_ENABLED and _tick() - t0 < (A.holdMin or 1.3) do
            local rawP = (_tick() - t0) / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP, SEMI_STOP))
            task.wait()
        end
        A.state.phase = "waitingRange"
        local alreadyInRange = _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10)
        local fired = false
        while A.enabled and selectedStealMode == "V2" and YoutStealCFG.AUTO_STEAL_ENABLED and prompt.Parent do
            local elapsed = _tick() - t0
            if elapsed > (A.holdMax or 2.6) then break end
            local rawP2 = elapsed / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP2, SEMI_STOP))
            if _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                if not alreadyInRange then task.wait(A.entryDelay or 0.25) end
                if A.enabled and selectedStealMode == "V2" and YoutStealCFG.AUTO_STEAL_ENABLED then
                    if #data.triggerCallbacks > 0 then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                    else
                        pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
                    end
                    fired = true
                end
                break
            end
            task.wait()
        end
        A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or "Missed"
        A.state.active = false
        A.state.phase = "idle"
        A.state.lastResultTime = _tick()
        if fired then _yv2SetBar(1) end
        task.wait(A.cooldown or 0.05)
        data.ready = true
        _yv2ResetBar()
    end)
    return true
end

local function _yv2ScanAllPlots()
    local A = _G.YoutV2Steal
    if not _yv2EnsureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(A.plots:GetChildren()) do
        local cache = A.plotSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList) == "table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local info = A.animalsData and A.animalsData[animalName]
                    if info then
                        table.insert(newCache, {
                            name = info.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot)
                        })
                    end
                end
            end
        end
    end
    A.animals = newCache
    return #newCache
end

local function _yv2PickClosest()
    local A = _G.YoutV2Steal
    local root = _yv2Root()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(A.animals) do
        if not _yv2IsMyBase(data) then
            local pos = _yv2AnimalPos(data)
            local dist = pos and (root.Position - pos).Magnitude or math.huge
            if dist <= (A.primeRange or 80) and dist < bestDist then
                best, bestDist = data, dist
            end
        end
    end
    return best
end

local function _yv2EnsureScanThread()
    local A = _G.YoutV2Steal
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
        while _G.YoutV2Steal do
            if A.enabled or selectedStealMode == "V2" then pcall(_yv2ScanAllPlots) end
            task.wait(5)
        end
    end)
end

function stopAutoStealV2()
    local A = _G.YoutV2Steal
    A.enabled = false
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    _yv2ResetBar()
end

function startAutoStealV2()
    local A = _G.YoutV2Steal
    A.radius = 10
    A.enabled = true
    pcall(_yv2EnsureSync)
    _yv2EnsureScanThread()
    pcall(_yv2ScanAllPlots)
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.conn = RunService.Heartbeat:Connect(function()
        if not A.enabled or not YoutStealCFG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or A.state.active then return end
        local target = _yv2PickClosest()
        if not target then
            if _tick() - (A.lastScan or 0) > 1.2 then
                A.lastScan = _tick()
                pcall(_yv2ScanAllPlots)
            end
            return
        end
        local prompt = _yv2FindPrompt(target)
        if prompt then _yv2Execute(prompt, target) end
    end)
end

local function _startAutoStealV1()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = YoutStealCFG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = YoutStealCFG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        if selectedStealMode ~= "V1" then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

local function _stopAutoStealV1()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "READY" end
end

function YoutStartAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    YoutStealCFG.AUTO_STEAL_ENABLED = true
    if selectedStealMode == "V2" then
        startAutoStealV2()
    else
        _startAutoStealV1()
    end
    return true
end

function YoutStopAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    YoutStealCFG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "READY" end
end

local AntiBat = { Connection = nil }

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        pcall(function() AntiBat.Connection:Disconnect() end)
        AntiBat.Connection = nil
    end
    if VS and VS.setYoutAntiBatVisual then pcall(VS.setYoutAntiBatVisual, false) end
    if VS and VS.setAntiBatVisual then pcall(VS.setAntiBatVisual, false) end
end

-- Space X Hook velocity desync Anti Bat
function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true
    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local vel = root.AssemblyLinearVelocity
        local y = vel.Y
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(math.random(-4000, 4000), y, math.random(-4000, 4000))
            if root.Velocity ~= nil then root.Velocity = Vector3.new(math.random(-4000, 4000), y, math.random(-4000, 4000)) end
        end)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            pcall(function()
                root.AssemblyLinearVelocity = vel
                if root.Velocity ~= nil then root.Velocity = vel end
            end)
        end
    end)
    if VS and VS.setYoutAntiBatVisual then pcall(VS.setYoutAntiBatVisual, true) end
    if VS and VS.setAntiBatVisual then pcall(VS.setAntiBatVisual, true) end
end

pcall(function()
    LP.CharacterAdded:Connect(function()
        task.wait(0.3)
        if antiBatEnabled then startAntiBat() end
    end)
end)

-- [FIX INSTA RESET VIOLETTE]
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true

        local state = _G._YoutInstaResetState
        if type(state) ~= "table" then
            state = {
                busy = false, busyAt = 0,
                token = 0,
                cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
                speed = 1000000,
                wantAntiDie = nil,
                wantAntiBat = nil,
                wantTpBatDie = nil,
            }
            _G._YoutInstaResetState = state
        end

        local HOLD_TIME   = 1.5
        local FALLBACK    = 1.2
        local WAIT_RESPAWN = 8

        local function suspendGuards()
            if _antiDieEnabled then
                state.wantAntiDie = true
                pcall(function() _antiDieSetEnabled(false) end)
            end
            if AntiDieModule and AntiDieModule.enabled then
                state.wantAntiDie = true
                pcall(function() AntiDieModule.stop() end)
            end
            if antiBatEnabled then
                state.wantAntiBat = true
                pcall(stopAntiBat)
            end
            if _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = true
                pcall(_G._AdaptTpBatAntiDie.stop)
            end
        end

        local function restoreGuards()
            if state.wantAntiDie then
                state.wantAntiDie = nil
                pcall(function()
                    antiDieEnabled = true
                    if AntiDieModule then AntiDieModule.start() end
                    if _antiDieSetEnabled then _antiDieSetEnabled(true) end
                end)
            end
            if state.wantAntiBat then
                state.wantAntiBat = nil
                pcall(function() if antiBatEnabled then startAntiBat() end end)
            end
            if state.wantTpBatDie and _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = nil
                pcall(_G._AdaptTpBatAntiDie.start)
            end
        end

        local function holdCamera(oldChar)
            local cam = workspace.CurrentCamera
            if not cam then return end
            if state.cameraHeld and (os.clock() - (state.cameraHeldAt or 0)) < 5 then return end
            state.cameraHeld = true
            state.cameraHeldAt = os.clock()
            local heldCFrame, heldFocus = cam.CFrame, cam.Focus

            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            state.cameraConn = RunService.RenderStepped:Connect(function()
                if workspace.CurrentCamera ~= cam then return end
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            task.spawn(function()
                local elapsed = 0
                while LP.Character == oldChar and elapsed < 3 do
                    elapsed = elapsed + task.wait()
                end
                if state.cameraConn then
                    pcall(function() state.cameraConn:Disconnect() end)
                    state.cameraConn = nil
                end
                state.cameraHeld = false
                local newCam = workspace.CurrentCamera or cam
                if newCam then
                    pcall(function()
                        newCam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if hum then newCam.CameraSubject = hum end
                    end)
                end
            end)
        end

        local function flingUp(character)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (root and root:IsA("BasePart")) then return false end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum.BreakJointsOnDeath = true
                    hum.PlatformStand = true
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end
            local vel = Vector3.new(0, math.clamp(state.speed, 1000, 10000000), 0)
            local function pulse()
                if not root.Parent then return false end
                return pcall(function()
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = vel
                end)
            end
            if not pulse() then return false end
            task.spawn(function()
                local elapsed = 0
                while elapsed < HOLD_TIME do
                    elapsed = elapsed + RunService.Heartbeat:Wait()
                    if not root.Parent then return end
                    if LP.Character ~= character then return end
                    pulse()
                end
            end)
            return true
        end

        local function hardKill(character)
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            pcall(function()
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
                if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then hum.MaxHealth = 100 end
                hum.Health = 0
            end)
            pcall(function() character:BreakJoints() end)
        end

        local function doReset()
            local character = LP.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (character and hum and root and root:IsA("BasePart")) then
                return
            end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 5 then return end

            state.busy = true
            state.busyAt = os.clock()
            state.token = (state.token or 0) + 1
            local myToken = state.token

            suspendGuards()

            task.spawn(function()
                holdCamera(character)

                if not flingUp(character) then
                    hardKill(character)
                end

                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do
                    elapsed = elapsed + task.wait()
                end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then
                        hardKill(character)
                    end
                end

                local waited = 0
                while LP.Character == character and waited < WAIT_RESPAWN do
                    waited = waited + task.wait()
                end

                if state.token ~= myToken then return end
                state.busy = false
                restoreGuards()
            end)
        end

        RunService.Heartbeat:Connect(function()
            if not state.wantAntiDie then return end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 10 then
                if _antiDieEnabled then pcall(function() _antiDieSetEnabled(false) end) end
                if AntiDieModule and AntiDieModule.enabled then pcall(function() AntiDieModule.stop() end) end
                return
            end
            if (os.clock() - (state.busyAt or 0)) >= 10 then
                state.busy = false
                restoreGuards()
            end
        end)

        LP.CharacterAdded:Connect(function()
            state.cameraHeld = false
            if state.cameraConn then
                pcall(function() state.cameraConn:Disconnect() end)
                state.cameraConn = nil
            end
        end)

        local _lastRequest = 0
        _G.InstaReset = {
            Trigger = function()
                local now = os.clock()
                if now - _lastRequest < 0.15 then return end
                _lastRequest = now
                doReset()
            end,
        }
        _G.VynxDoInstaReset = _G.InstaReset.Trigger
    end
end

F.doInstaReset = function()
    if _G.InstaReset and type(_G.InstaReset.Trigger) == "function" then
        return _G.InstaReset.Trigger()
    end
    if type(_G.VynxDoInstaReset) == "function" then
        return _G.VynxDoInstaReset()
    end
    if cursedInstaReset then return cursedInstaReset() end
end

-- ---------- exports used by the hub GUI ----------
function YoutGetStealMode() return selectedStealMode end
function YoutSetStealMode(m)
    -- V3 = V2 engine with a fixed stop % (75/80/90) instead of a random one
    _G.__StealV3 = (m == "V3")
    if m == "V3" then m = "V2" end
    if m ~= "V1" and m ~= "V2" then m = "V1" end
    selectedStealMode = m
    if m == "V2" then
        YoutStealCFG.STEAL_RANGE = 60
        Steal.StealRadius = 60
    end
end
function YoutSetStealRadius(v)
    v = tonumber(v)
    if not v or v <= 0 then return end
    YoutStealCFG.STEAL_RANGE = v
    Steal.StealRadius = v
end
function YoutSetStealDuration(v)
    v = tonumber(v)
    if not v or v < 0.1 then return end
    Steal.StealDuration = v
end
function YoutIsAntiBatOn() return antiBatEnabled == true end
YoutOUTFITS = OUTFITS
function YoutGetOutfitCount() return #OUTFITS end
function YoutGetOutfitIndex() return currentOutfitIndex end
function YoutSetOutfitIndex(i)
    if type(i) ~= "number" then return end
    if i < 1 then i = #OUTFITS elseif i > #OUTFITS then i = 1 end
    currentOutfitIndex = i
    pcall(applyOutfitByIndex, i)
end
function YoutGetOutfitLabel(i)
    local cfg = OUTFITS[i or currentOutfitIndex]
    return cfg and cfg.label or "OFF"
end
function YoutBindOutfitLabel(lbl) outfitSelectorLabel = lbl end
end
-- route the hub's Auto Steal toggle at the ported V1/V2 engine
startAutoSteal = function()
    autoStealEnabled = true
    if Steal then Steal.AutoStealEnabled = true end
    YoutStartAutoSteal()
end
stopAutoSteal = function()
    autoStealEnabled = false
    if Steal then Steal.AutoStealEnabled = false end
    YoutStopAutoSteal()
end
AceAutoStealSync = function() if autoStealEnabled then startAutoSteal() else stopAutoSteal() end end
-- ================= END YOUT MERGE =================

local function resolveBgId(key)
    if not key or key == "" or key == "None" then return "" end
    -- bare numeric asset id
    if type(key) == "number" or (type(key) == "string" and key:match("^%d+$")) then
        return "rbxassetid://" .. tostring(key)
    end
    if BG_RESOLVED[key] and BG_RESOLVED[key] ~= "" then return BG_RESOLVED[key] end
    if type(key) == "string" then
        if key:find("rbxasset", 1, true) or key:find("rbxthumb", 1, true) then
            return key
        end
        if key:find("http", 1, true) then
            local gca = getcustomasset or getsynasset or nil
            local wf = writefile or (syn and syn.writefile) or nil
            local rf = isfile or (syn and syn.isfile) or nil
            local hg = (game and game.HttpGet and function(u) return game:HttpGet(u) end) or httpget or nil
            if gca and wf then
                local hash = key:match("([^/]+)$") or "bg_custom.png"
                local fileName = "PrimeVS_" .. hash
                local exists = false
                if rf then pcall(function() exists = rf(fileName) end) end
                if not exists and hg then
                    pcall(function()
                        local data = hg(key)
                        if data and #data > 0 then
                            wf(fileName, data)
                            exists = true
                        end
                    end)
                end
                local ok, asset = pcall(gca, fileName)
                if ok and asset then
                    BG_RESOLVED[key] = asset
                    return asset
                end
            end
            return key
        end
    end
    return BG_RESOLVED[key] or ""
end local currentThemeName = "BLACK"; S.currentThemeName = currentThemeName; S.themeColor = Color3.fromRGB(255, 255, 255); local currentBgId = "76591851053639"; S.currentBgId = currentBgId; S.bgIntensity = S.bgIntensity or 0.72 local bgAsset, bgVeil local themeAccentStrokes = {}; local themeAccentFrames = {} local function applyBackground(imageId, skipSave)
currentBgId = imageId or ""; S.currentBgId = currentBgId; local resolved = resolveBgId(currentBgId) if bgAsset then if resolved == "" then bgAsset.Image = ""; bgAsset.ImageTransparency = 1 if bgVeil then bgVeil.BackgroundTransparency = 0.55 end else bgAsset.Image = resolved; bgAsset.ImageTransparency = 1 - (S.bgIntensity or 0.58); bgAsset.ImageColor3 = Color3.new(1, 1, 1) if bgVeil then bgVeil.BackgroundTransparency = 0.32 end end bgAsset.ZIndex = 0; bgAsset.Visible = true end if not skipSave then pcall(function() if F and F.saveConfig then F.saveConfig() end end) end end
_G._VersincApplyBackground = function(imageId, skipSave) applyBackground(imageId, skipSave) end local function applyThemeColor(col, name) if name then currentThemeName = name; S.currentThemeName = name end S.themeColor = col pcall(function() if K7 and K7.updateHeadIndicatorTheme then K7.updateHeadIndicatorTheme() end end) COLORS.stroke = col COLORS.accent = col; COLORS.on = col; COLORS.accentStrong = col; COLORS.strokeSoft = Color3.new(col.R * 0.45 + 0.12, col.G * 0.45 + 0.12, col.B * 0.45 + 0.12) for _, s in ipairs(themeAccentStrokes) do
if s and s.Parent then pcall(function() s.Color = col end) end end if S._mainTryhardBorder and S._mainTryhardBorder.Parent then pcall(function() S._mainTryhardBorder.Color = col end) end if main then for _, d in ipairs(main:GetDescendants()) do if d:IsA("UIStroke") then if d:GetAttribute("ThemeAccent") or d:GetAttribute("ThemeStroke") then d.Color = col end elseif d:IsA("TextLabel") then if d.Name == "ActiveCheck" then d.TextColor3 = col end elseif d:IsA("TextButton") then local isHubBtn = d:GetAttribute("ThemeButton") or d.Name == "KeybindButton" or d.Name:find("Btn") or d.Name:find("Button") or d.Name == "PickerPrev" or d.Name == "PickerNext" or d.Name == "PickerValue"
if isHubBtn and d.BackgroundTransparency < 1 then d.BackgroundColor3 = col; d.BackgroundTransparency = math.max(d.BackgroundTransparency, 0.5); local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("TextBox") then if d.BackgroundTransparency < 1 then local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("Frame") then if d:GetAttribute("ThemePillOn") then d.BackgroundColor3 = col; d.BackgroundTransparency = 0.22 elseif d:GetAttribute("OptionActive") then d.BackgroundColor3 = COLORS.row:Lerp(col, 0.48); d.BackgroundTransparency = 0.04; local st = d:FindFirstChildOfClass("UIStroke"); if st then st.Color = col end elseif d.Name == "ActiveMarker" then d.BackgroundColor3 = col end end end end pcall(function() if _G._VersincApplyMobileTheme then _G._VersincApplyMobileTheme(col) end
end) pcall(function() if PlayerESP and PlayerESP.playerData then for _, d in pairs(PlayerESP.playerData) do if d.highlight then d.highlight.FillColor = col; d.highlight.OutlineColor = col end if d.billboard then local lbl = d.billboard:FindFirstChildWhichIsA("TextLabel") if lbl then lbl.TextColor3 = col end end end end if TracerESP and TracerESP.drawings then for _, d in pairs(TracerESP.drawings) do if d.line then d.line.BackgroundColor3 = col end end end local legacy = workspace:FindFirstChild("VersincTracers") if legacy then for _, ch in ipairs(legacy:GetDescendants()) do
if ch:IsA("Beam") then ch.Color = ColorSequence.new(col) end end end end) if progressFill and progressFill.Parent then progressFill.BackgroundColor3 = col end if S.refreshAimbotMode then S.refreshAimbotMode() end end _G._VersincApplyTheme = function(themeName) for _, preset in ipairs(THEME_PRESETS) do if preset.name == themeName then applyThemeColor(preset.color, preset.name) return end end end local function corner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 8); c.Parent = parent return c end local function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke"); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = color or COLORS.stroke; s.Thickness = thickness or 1; s.Transparency = transparency or 0.55; s.Parent = parent if color == nil or color == COLORS.stroke or color == COLORS.accent then s:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, s) end return s end for _,name in ipairs({"PrimeVSHub","CursedHub"}) do local old = game:GetService("CoreGui"):FindFirstChild(name) if old then old:Destroy() end local pg = LP:FindFirstChild("PlayerGui")
if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end end local gui = Instance.new("ScreenGui"); gui.Name = "PrimeVSHub"; gui.ResetOnSpawn = false; gui.DisplayOrder = 10; gui.IgnoreGuiInset = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling pcall(function() if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) elseif type(protect_gui) == "function" then protect_gui(gui) elseif type(protectgui) == "function" then protectgui(gui) end end) local parented = false pcall(function() if type(gethui) == "function" then
gui.Parent = gethui(); parented = gui.Parent ~= nil end end) if not parented then pcall(function() local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if pg then gui.Parent = pg; parented = gui.Parent ~= nil end end) end if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") parented = gui.Parent ~= nil end) end if not parented then warn("[prime.vs] Failed to parent ScreenGui") end
local FULL_SIZE = UDim2.new(0, 356, 0, 536); local main = Instance.new("Frame"); main.Name = "Main"; main.AnchorPoint = Vector2.new(0, 0); main.Size = FULL_SIZE; main.Position = UDim2.new(0, 20, 0, 20) do local isMob = false pcall(function() isMob = UIS.TouchEnabled and not UIS.KeyboardEnabled end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 700 or vp.Y < 500 then isMob = true end if isMob then
main.AnchorPoint = Vector2.new(0.5, 0.5); main.Position = UDim2.new(0.5, 0, 0.5, 0); local sc = Instance.new("UIScale"); sc.Name = "MobileHubScale"; sc.Scale = math.clamp(math.min(vp.X / 400, vp.Y / 620), 0.72, 0.92); sc.Parent = main end end main.BackgroundColor3 = COLORS.bg; main.BackgroundTransparency = 0.1; main.BorderSizePixel = 0; main.Active = true; main.ClipsDescendants = true; main.Parent = gui; corner(main, 16); local mainBorder = stroke(main, COLORS.stroke, 2.2, 0.15); mainBorder.Name = "TryhardBorder"; mainBorder:SetAttribute("ThemeAccent", true)
mainBorder:SetAttribute("TryhardBorder", true); S._mainTryhardBorder = mainBorder task.spawn(function() local t0 = tick() while main and main.Parent and mainBorder and mainBorder.Parent do local t = tick() - t0; local pulse = 0.5 + 0.5 * math.sin(t * 3.2); local pulse2 = 0.5 + 0.5 * math.sin(t * 5.1 + 1.2); local col = S.themeColor or COLORS.stroke; local boost = 0.12 * pulse2 pcall(function() mainBorder.Color = Color3.new( math.clamp(col.R + boost, 0, 1), math.clamp(col.G + boost, 0, 1), math.clamp(col.B + boost, 0, 1) ) mainBorder.Thickness = 1.6 + pulse * 1.8
mainBorder.Transparency = 0.08 + (1 - pulse) * 0.35 end) task.wait(0.03) end end) bgAsset = Instance.new("ImageLabel")
bgAsset.Name = "BackgroundAsset"; bgAsset.Size = UDim2.new(1, 0, 1, 0); bgAsset.BackgroundTransparency = 1; bgAsset.Image = "rbxassetid://76591851053639"; bgAsset.ImageTransparency = 0.28; bgAsset.ScaleType = Enum.ScaleType.Crop; bgAsset.ZIndex = 0; bgAsset.Parent = main; corner(bgAsset, 16); bgVeil = Instance.new("Frame"); bgVeil.Name = "BackgroundVeil"; bgVeil.Size = UDim2.new(1, 0, 1, 0); bgVeil.BackgroundColor3 = Color3.fromRGB(0, 0, 0); bgVeil.BackgroundTransparency = 0.45; bgVeil.BorderSizePixel = 0; bgVeil.ZIndex = 1; bgVeil.Parent = main; corner(bgVeil, 16); local guiScale = 0.8; local uiScaleObj = Instance.new("UIScale"); uiScaleObj.Scale = guiScale; uiScaleObj.Parent = main
local function applyProgressBarScale(n) S.progressBarScale = math.clamp(math.floor((tonumber(n) or 100) + 0.5), 50, 200); local pb = _G.__VersincProgressBarScaleObj if pb then pb.Scale = (S.progressBarScale / 100) end if _G.__VersincProgressBarSizeLbl then _G.__VersincProgressBarSizeLbl.Text = tostring(S.progressBarScale) .. "%" end end _G._VersincApplyProgressBarScale = applyProgressBarScale local function applyGuiScale(v) v = math.clamp(tonumber(v) or 0.8, 0.6, 1.6); guiScale = math.floor(v * 100 + 0.5) / 100; uiScaleObj.Scale = guiScale; S.uiScaleValue = math.floor(guiScale * 100 + 0.5)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) end end) if UI.guiScaleLbl then UI.guiScaleLbl.Text = string.format("%.0f%%", guiScale * 100) end pcall(F.saveConfig) return guiScale end _G._VersincApplyGuiScale = applyGuiScale _G._VersincGetGuiScale = function() return guiScale end local function _packPos(p) return { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset } end local function _unpackPos(t) if type(t) ~= "table" then return nil end
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0) end _G._VersincSetHubPos = function(hub, mini) local a = _unpackPos(hub) if a and main then main.Position = a end local b = _unpackPos(mini) if b and _G.__VersincMiniBtn then _G.__VersincMiniBtn.Position = b end end do local dn, ds, sp, di = false main.InputBegan:Connect(function(i) if S.guiLocked == true then return end if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = main.Position
i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then if dn then dn = false; S.hubPos = _packPos(main.Position) pcall(function() F.saveConfig(true) end) end end end) end end) main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end) UIS.InputChanged:Connect(function(i) if i == di and dn then if S.guiLocked == true then dn = false; return end main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
end end) end local miniBtn = Instance.new("TextButton"); miniBtn.Name = "PRIMEMini"; miniBtn.AutoButtonColor = false; miniBtn.Size = UDim2.new(0, 110, 0, 32); miniBtn.Position = UDim2.new(0, 20, 0, 70); miniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14); miniBtn.BackgroundTransparency = 0; miniBtn.BorderSizePixel = 0; miniBtn.Text = " 🎃 CANDY HUB"; miniBtn.TextColor3 = COLORS.white; miniBtn.Font = Enum.Font.GothamBold; miniBtn.TextSize = 11; miniBtn.Visible = false; miniBtn.ZIndex = 20; miniBtn.Parent = gui; corner(miniBtn, 8); stroke(miniBtn, COLORS.stroke, 1, 0)
miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(26, 26, 30) }):Play() end) miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(12, 12, 14) }):Play() end) _G.__VersincMiniBtn = miniBtn if type(S.miniPos) == "table" then pcall(function() miniBtn.Position = _unpackPos(S.miniPos) or miniBtn.Position end) end do local dn, ds, sp = false miniBtn.InputBegan:Connect(function(i) if S.guiLocked == true then return end
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = miniBtn.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End and dn then dn = false; S.miniPos = _packPos(miniBtn.Position) pcall(function() F.saveConfig(true) end) end end) end end) UIS.InputChanged:Connect(function(i) if dn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then if S.guiLocked == true then dn = false; return end
miniBtn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y)) end end) end local mainUIScale = main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", main) local function _targetScale() local v = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or ((tonumber(S.uiScaleValue) or 80) / 100) return math.clamp(tonumber(v) or 1, 0.5, 1.5) end local function showGui() if not main then return end
main.Visible = true; main.BackgroundTransparency = 0; mainUIScale.Scale = 0.85; TS:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = _targetScale() }):Play(); miniBtn.Visible = false pcall(function() local pg = LP:FindFirstChild("PlayerGui") local g = pg and pg:FindFirstChild("VersincMobileButtons") if g then g.Enabled = not (S.hideMobileButtons == true) end end) end local function hideGui() if not main then return end TS:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.85 }):Play()
task.delay(0.2, function() if main then main.Visible = false end if miniBtn then miniBtn.Visible = true end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) end miniBtn.MouseButton1Click:Connect(showGui); local avatarBg = Instance.new("Frame"); avatarBg.Size = UDim2.new(0, 36, 0, 36); avatarBg.Position = UDim2.new(0, 14, 0, 16); avatarBg.BackgroundColor3 = Color3.fromRGB(22, 22, 24); avatarBg.BorderSizePixel = 0
avatarBg.ZIndex = 6; avatarBg.Parent = main; corner(avatarBg, 18); stroke(avatarBg, COLORS.stroke, 1.4, 0.35); local avatarImg = Instance.new("ImageLabel"); avatarImg.Size = UDim2.new(1, -4, 1, -4); avatarImg.Position = UDim2.new(0, 2, 0, 2); avatarImg.BackgroundTransparency = 1; avatarImg.Image = ""; avatarImg.ScaleType = Enum.ScaleType.Crop; avatarImg.ZIndex = 7; avatarImg.Parent = avatarBg; corner(avatarImg, 16) task.spawn(function() local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
if ok and thumb then avatarImg.Image = thumb end end) LP.CharacterAdded:Connect(function() task.spawn(function() local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end) if ok and thumb then avatarImg.Image = thumb end end) end) local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1; title.Size = UDim2.new(1, -210, 0, 18); title.Position = UDim2.new(0, 58, 0, 14); title.Text = "Candy 🎃 Hub Remake"; title.TextColor3 = COLORS.white; title.Font = Enum.Font.GothamBlack; title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 6; title.Parent = main; local subTitle = Instance.new("TextLabel"); subTitle.BackgroundTransparency = 1; subTitle.Size = UDim2.new(1, -100, 0, 14); subTitle.Position = UDim2.new(0, 58, 0, 34); subTitle.Text = "discord.gg/candy"; subTitle.TextColor3 = COLORS.textDim; subTitle.Font = Enum.Font.GothamMedium; subTitle.TextSize = 11; subTitle.TextXAlignment = Enum.TextXAlignment.Left; subTitle.ZIndex = 6; subTitle.Parent = main; local statsLbl = Instance.new("TextLabel"); statsLbl.Name = "FpsPingStats"; statsLbl.BackgroundTransparency = 1; statsLbl.Size = UDim2.new(0, 110, 0, 28); statsLbl.Position = UDim2.new(1, -150, 0, 16)
statsLbl.Text = "FPS --  ·  -- ms" statsLbl.TextColor3 = COLORS.textDim; statsLbl.Font = Enum.Font.GothamBold; statsLbl.TextSize = 11; statsLbl.TextXAlignment = Enum.TextXAlignment.Right; statsLbl.ZIndex = 7; statsLbl.Parent = main; UI.statsLbl = statsLbl task.spawn(function() local frames, last, smoothFps = 0, tick(), 0 local Stats = game:GetService("Stats") RunService.RenderStepped:Connect(function() frames = frames + 1 local now = tick() if now - last >= 0.35 then
local inst = frames / (now - last); smoothFps = (smoothFps == 0) and inst or (smoothFps * 0.6 + inst * 0.4); frames = 0; last = now; local fpsN = math.floor(smoothFps + 0.5); local pingN = 0 pcall(function() local item = Stats.Network.ServerStatsItem["Data Ping"] if item then local s = item:GetValueString(); pingN = tonumber((tostring(s):match("%d+") or "0")) or 0 end end) if pingN == 0 then pcall(function() pingN = math.floor((Stats.Network:FindFirstChild("ServerStatsItem") and 0) or 0) end) end if pingN == 0 then pcall(function() if LP.GetNetworkPing then
pingN = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end end) end local fpsCol = fpsN >= 55 and "g" or (fpsN >= 30 and "w" or "r") if statsLbl and statsLbl.Parent then statsLbl.Text = string.format("FPS %d  ·  %d ms", fpsN, pingN) if fpsN >= 55 and pingN < 120 then statsLbl.TextColor3 = Color3.fromRGB(100, 220, 160) elseif fpsN < 30 or pingN > 200 then statsLbl.TextColor3 = Color3.fromRGB(255, 110, 120) else statsLbl.TextColor3 = COLORS.textDim end end end end) end) local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26); closeBtn.Position = UDim2.new(1, -38, 0, 18); closeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 24); closeBtn.BackgroundTransparency = 0.15; closeBtn.Text = "×"; closeBtn.TextColor3 = COLORS.accent; closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 16; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 8; closeBtn.Parent = main; corner(closeBtn, 7)
stroke(closeBtn, COLORS.strokeSoft, 1, 0.45); closeBtn.MouseButton1Click:Connect(hideGui); -- ===== CANDY FONT PACK =====
-- Uses Roblox built-in fonts so the UI works without requiring a custom font asset.
local function applyCandyFont(obj)
    if not obj then return end
    if obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.Font = Enum.Font.GothamBold
    elseif obj:IsA("TextLabel") then
        obj.Font = (obj.TextSize >= 15) and Enum.Font.GothamBlack or Enum.Font.GothamMedium
    end
end
for _, obj in ipairs(gui:GetDescendants()) do pcall(function() applyCandyFont(obj) end) end
gui.DescendantAdded:Connect(function(obj) task.defer(function() pcall(function() applyCandyFont(obj) end) end) end)

-- ===== SMOOTH BUTTON PACK =====
local _smoothBound = setmetatable({}, {__mode = "k"})
local function bindSmoothButton(btn)
    if not btn or _smoothBound[btn] or not (btn:IsA("TextButton") or btn:IsA("ImageButton")) then return end
    _smoothBound[btn] = true
    local scale = btn:FindFirstChild("SmoothScale")
    if not scale then
        scale = Instance.new("UIScale")
        scale.Name = "SmoothScale"
        scale.Scale = 1
        scale.Parent = btn
    end
    local function tween(v, t)
        pcall(function()
            TS:Create(scale, TweenInfo.new(t or 0.10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = v}):Play()
        end)
    end
    btn.MouseEnter:Connect(function() tween(1.025, 0.10) end)
    btn.MouseLeave:Connect(function() tween(1, 0.12) end)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then tween(0.965, 0.06) end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then tween(1.025, 0.09) end
    end)
end
for _, obj in ipairs(gui:GetDescendants()) do pcall(function() bindSmoothButton(obj) end) end
gui.DescendantAdded:Connect(function(obj) task.defer(function() pcall(function() bindSmoothButton(obj) end) end) end)
local headerDiv = Instance.new("Frame"); headerDiv.Size = UDim2.new(1, -32, 0, 1); headerDiv.Position = UDim2.new(0, 16, 0, 60); headerDiv.BackgroundColor3 = COLORS.stroke
headerDiv.BackgroundTransparency = 0.55; headerDiv.BorderSizePixel = 0; headerDiv.ZIndex = 5; headerDiv.Parent = main; local pages = {}; local pageHolder = Instance.new("Frame"); pageHolder.Size = UDim2.new(1, -100, 1, -80); pageHolder.Position = UDim2.new(0, 88, 0, 68); pageHolder.BackgroundTransparency = 1; pageHolder.ClipsDescendants = true; pageHolder.ZIndex = 3; pageHolder.Parent = main local function makePage(name)
local sf = Instance.new("ScrollingFrame"); sf.Name = name; sf.Size = UDim2.new(1, 0, 1, 0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0; sf.ScrollBarThickness = 3; sf.ScrollBarImageColor3 = COLORS.accent; sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.Visible = false; sf.ZIndex = 3; sf.Parent = pageHolder; local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 4); local pad = Instance.new("UIPadding", sf); pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 2); pad.PaddingRight = UDim.new(0, 6); pages[name] = sf
return sf end
local pageMOVE = makePage("MOVEMENT"); local pageTOOLS = makePage("COMBAT"); local pageVIEW = makePage("VISUALS"); local pageSYS = makePage("SETTINGS"); local pageKEYS = makePage("KEYBINDS"); local pageSKINS = makePage("SKINS"); local pageMUSIC = makePage("MUSIC"); local Tabs = Instance.new("Frame"); Tabs.Name = "Tabs"; Tabs.BackgroundColor3 = Color3.fromRGB(8, 8, 10); Tabs.BackgroundTransparency = 0.15; Tabs.BorderSizePixel = 0; Tabs.AnchorPoint = Vector2.new(0, 0); Tabs.Position = UDim2.new(0, 10, 0, 68); Tabs.Size = UDim2.new(0, 70, 1, -80); Tabs.ZIndex = 5; Tabs.Parent = main; corner(Tabs, 12); stroke(Tabs, Color3.fromRGB(40, 40, 48), 1, 0.4); local tabPad = Instance.new("UIPadding"); tabPad.PaddingTop = UDim.new(0, 4); tabPad.PaddingBottom = UDim.new(0, 4); tabPad.PaddingLeft = UDim.new(0, 3); tabPad.PaddingRight = UDim.new(0, 3); tabPad.Parent = Tabs; local TabLayout = Instance.new("UIListLayout"); TabLayout.FillDirection = Enum.FillDirection.Vertical; TabLayout.Padding = UDim.new(0, 5); TabLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; TabLayout.Parent = Tabs; local tabNames = {"MOVEMENT", "COMBAT", "VISUALS", "SKINS", "SETTINGS", "KEYBINDS", "MUSIC"}; local tabDisplay = {MOVEMENT = "main", COMBAT = "combat", VISUALS = "visual", SETTINGS = "sistems", KEYBINDS = "keybind", SKINS = "skins", MUSIC = "music"}; local tabButtons = {}; local activeTab = "MOVEMENT"
local function setTab(name) activeTab = name for n, pg in pairs(pages) do pg.Visible = (n == name) end for n, btn in pairs(tabButtons) do local on = (n == name); btn.BackgroundColor3 = on and COLORS.row2 or COLORS.row; btn.BackgroundTransparency = on and 0.05 or 0.35; btn.TextColor3 = on and COLORS.white or COLORS.textDim; local st = btn:FindFirstChildOfClass("UIStroke") if st then st.Color = on and COLORS.white or COLORS.strokeSoft; st.Transparency = on and 0.35 or 0.7 end end end for i, name in ipairs(tabNames) do
local btn = Instance.new("TextButton"); btn.Name = name; btn.Size = UDim2.new(1, 0, 0, 42); btn.BackgroundColor3 = COLORS.row; btn.BackgroundTransparency = 0.35; btn.BorderSizePixel = 0; btn.Text = tabDisplay[name]; btn.TextColor3 = COLORS.textDim; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.TextWrapped = true; btn.AutoButtonColor = false; btn.LayoutOrder = i; btn.ZIndex = 6; btn.Parent = Tabs; corner(btn, 0); stroke(btn, COLORS.strokeSoft, 1, 0.7) btn.MouseButton1Click:Connect(function() setTab(name) end) tabButtons[name] = btn end setTab("MOVEMENT"); local lo = 0
local function LO() lo = lo + 1; return lo end local function section(parent, text) local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 22); f.BackgroundTransparency = 1; f.LayoutOrder = LO(); local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -4, 1, 0); l.Position = UDim2.new(0, 4, 0, 0); l.BackgroundTransparency = 1; l.Text = text:upper(); l.TextColor3 = COLORS.accentStrong; l.Font = Enum.Font.GothamBlack; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left return f end local function mkRow(parent, h)
local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, h or 34); f.BackgroundColor3 = COLORS.row; f.BackgroundTransparency = 0.35; f.BorderSizePixel = 0; f.LayoutOrder = LO(); corner(f, 10); stroke(f, COLORS.stroke, 1, 0.82) f.MouseEnter:Connect(function() TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.08, BackgroundColor3 = COLORS.row2}):Play() end) f.MouseLeave:Connect(function() TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = f:GetAttribute("OptionActive") and 0.04 or 0.22, BackgroundColor3 = f:GetAttribute("OptionActive") and COLORS.row:Lerp(S.themeColor or COLORS.accentStrong, 0.48) or COLORS.row}):Play() end) return f end local function mkLabel(row, txt)
local l = Instance.new("TextLabel", row); l.Size = UDim2.new(0.58, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = COLORS.white; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left return l end local function mkPill(row, offset)
 local marker = Instance.new("Frame", row); marker.Name = "ActiveMarker"; marker.Size = UDim2.new(0, 3, 0, 22); marker.Position = UDim2.new(0, 4, 0.5, -11); marker.BackgroundColor3 = S.themeColor or COLORS.accentStrong; marker.BackgroundTransparency = 1; marker.BorderSizePixel = 0; marker.ZIndex = 4; corner(marker, 2)
 local check = Instance.new("TextLabel", row); check.Name = "ActiveCheck"; check.Size = UDim2.new(0, 28, 1, 0); check.Position = UDim2.new(1, -(offset or 52) + 6, 0, 0); check.BackgroundTransparency = 1; check.Text = "✓"; check.TextColor3 = S.themeColor or COLORS.accentStrong; check.TextSize = 18; check.Font = Enum.Font.GothamBold; check.Visible = false; check.ZIndex = 5
 return marker, check
end
local function animPill(marker, check, on)
 if not marker or not marker.Parent then return end
 marker.BackgroundColor3 = S.themeColor or COLORS.accentStrong
 check.TextColor3 = S.themeColor or COLORS.accentStrong
 marker.BackgroundTransparency = on and 0 or 1
 check.Visible = on == true
 local row = marker.Parent
 if row then
  row:SetAttribute("OptionActive", on == true)
  row.BackgroundColor3 = on and COLORS.row:Lerp(S.themeColor or COLORS.accentStrong, 0.48) or COLORS.row
  row.BackgroundTransparency = on and 0.04 or 0.22
  local border = row:FindFirstChildOfClass("UIStroke")
  if border then border.Color = on and (S.themeColor or COLORS.accentStrong) or COLORS.stroke; border.Transparency = on and 0.18 or 0.82 end
 end
end local function mkToggle(parent, txt, cb) local row = mkRow(parent, 34); mkLabel(row, txt); local pill, dot = mkPill(row, 52); local on = false local function sv(s) on = s; animPill(pill, dot, s) end
local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function() if S._anyKeyListening then return end on = not on; sv(on); if cb then cb(on) end end) return sv end local function mkBox(parent, default, w, xOff, cb)
local tb = Instance.new("TextBox", parent); tb.Size = UDim2.new(0, w or 54, 0, 24); tb.Position = UDim2.new(1, -(xOff or 62), 0.5, -12); tb.BackgroundColor3 = Color3.fromRGB(18, 18, 20); tb.BackgroundTransparency = 0.15; tb.BorderSizePixel = 0; tb.Text = tostring(default); tb.TextColor3 = COLORS.white; tb.Font = Enum.Font.GothamBold; tb.TextSize = 12; tb.ClearTextOnFocus = false; tb.ZIndex = 7; corner(tb, 8); local bs = stroke(tb, COLORS.stroke, 1, 0.78) tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.accent}):Play() end) tb.FocusLost:Connect(function()
TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.strokeSoft}):Play() if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end end) return tb end local GAMEPAD_KEYS = { [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true, [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true, [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true } local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end local function isBindableInput(inp) if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end if inp.UserInputType == Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true end local function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end
local function mkKB(parent, kbEntry, cb) local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0, 52, 0, 24); btn.Position = UDim2.new(1, -60, 0.5, -12); btn.BackgroundColor3 = S.themeColor or COLORS.accent or Color3.fromRGB(18, 18, 20); btn.BackgroundTransparency = 0.55; btn.BorderSizePixel = 0; btn:SetAttribute("ThemeButton", true) local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
btn.Text = getLabel(); btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 7; corner(btn, 8) stroke(btn, S.themeColor or COLORS.stroke, 1, 0.55); local li, lc, pv, listenStart = false, nil, btn.Text, 0 btn.Activated:Connect(function() if li then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end pv = btn.Text; li = true; S._anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = COLORS.accent lc = UIS.InputBegan:Connect(function(inp)
if not li then return end if inp.KeyCode == Enum.KeyCode.Escape then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end local isGp = isGamepadInput(inp) if isGp and tick() - listenStart < 0.15 then return end if not isBindableInput(inp) then return end btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = COLORS.white; li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end if cb then cb(inp.KeyCode, isGp) end end) end) return btn end
local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB) local row = mkRow(parent, 34); mkLabel(row, txt) if kbEntry then mkKB(row, kbEntry, function(k, isGp) if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end if onKB then onKB(k, isGp) end end) end local pill, dot = mkPill(row, kbEntry and 118 or 52); local on = false local function sv(s) on = s; animPill(pill, dot, s) end local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function()
if S._anyKeyListening then return end on = not on; sv(on); if onToggle then onToggle(on) end end) return sv end lo = 0; section(pageMOVE, "Auto Speed") do S.setAutoCarrySpeedVisual = mkToggle(pageMOVE, "Speed", function(on) S.autoCarrySpeedEnabled = on if not on then pcall(F.disableAutoCarrySpeed) end F.saveConfig() end) end section(pageMOVE, "Speed") do local row = mkRow(pageMOVE, 34); mkLabel(row, "Normal Speed"); UI.normalBox = mkBox(row, NS, 54, 62, function(v) if v > 0 and v <= 500 then NS = v end; F.saveConfig() end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Carry Speed"); UI.carryBox = mkBox(row, CS, 54, 62, function(v) if v > 0 and v <= 500 then CS = v end; F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Normal"); UI.laggerBox = mkBox(row, S.LAGGER_SPEED, 54, 62, function(v) if v > 0 and v <= 500 then S.LAGGER_SPEED = v end; F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Carry"); UI.laggerCarryBox = mkBox(row, S.LAGGER_CARRY_SPEED, 54, 62, function(v) if v > 0 and v <= 500 then S.LAGGER_CARRY_SPEED = v end; F.saveConfig() end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Mode"); modeValLbl = Instance.new("TextLabel", row); modeValLbl.Size = UDim2.new(0, 100, 1, 0); modeValLbl.Position = UDim2.new(1, -110, 0, 0); modeValLbl.BackgroundTransparency = 1; modeValLbl.Text = "Normal"; modeValLbl.TextColor3 = COLORS.accentStrong; modeValLbl.Font = Enum.Font.GothamBlack; modeValLbl.TextSize = 12; modeValLbl.TextXAlignment = Enum.TextXAlignment.Right; local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() if S._anyKeyListening then return end F.toggleCarryMode(); F.saveConfig() end) end section(pageMOVE, "Auto Play") do local sv = mkToggleKB(pageMOVE, "Auto Left", KB.AutoLeft, function(on) S.autoLeftEnabled = on if on then F.queueAutoLeftStart() else F.stopAutoLeft() end end, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) S.autoLeftSetVisual = sv end do local sv = mkToggleKB(pageMOVE, "Auto Right", KB.AutoRight, function(on) S.autoRightEnabled = on
if on then F.queueAutoRightStart() else F.stopAutoRight() end end, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) S.autoRightSetVisual = sv end section(pageMOVE, "Teleport") do local row = mkRow(pageMOVE, 34); mkLabel(row, "Drop Brainrot") mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end)
local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() F.runDrop() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "TP Down") mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() F.runTPFloor() end) end do VS.setAutoTPVisual = mkToggle(pageMOVE, "Auto TP", function(on) S.autoTPEnabled = on if on then F.startAutoTP() else F.stopAutoTP() end F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Auto TP Height") UI.autoTPHeightBox = mkBox(row, S.autoTPHeight, 54, 62, function(v) if v >= 0 and v <= 500 then S.autoTPHeight = v elseif UI.autoTPHeightBox then UI.autoTPHeightBox.Text = tostring(S.autoTPHeight) end F.saveConfig() end) end lo = 0; section(pageTOOLS, "Bat") do
local abRow = mkRow(pageTOOLS, 34); mkLabel(abRow, "Auto Bat") mkKB(abRow, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end F.saveConfig() end) local abPill, abDot = mkPill(abRow, 118) local abOn = false local function svAutoBat(s) abOn = s; animPill(abPill, abDot, s) end S.autoBatSetVisual = svAutoBat; local abClk = Instance.new("TextButton", abRow); abClk.Size = UDim2.new(1, 0, 1, 0); abClk.BackgroundTransparency = 1; abClk.Text = ""; abClk.ZIndex = 6 abClk.Activated:Connect(function()
if S._anyKeyListening then return end abOn = not abOn; svAutoBat(abOn) if abOn then F.queueAutoBatStart() else S.autoBatEnabled = false; S.disableAutoBat() end F.saveConfig() end) end VS.setMirrorTPVisual = mkToggle(pageTOOLS, "Mirror TP Down", function(on) F.setMirrorTPDown(on) F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Aimbot"); local marker, check = mkPill(row, 52); local abOn = false
local function svAim(on) abOn = on == true; animPill(marker, check, abOn) end
VS.setAimbotVisual = svAim; VS.setAimbotV2Visual = svAim; VS.setAntiBatBypassVisual = function() end
local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6
clk.Activated:Connect(function() if S._anyKeyListening then return end; setAimbotState(not (aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true))); F.saveConfig() end)
local modeRow = mkRow(pageTOOLS, 34); mkLabel(modeRow, "Aimbot Mode")
local choices = {}
for mode = 1, 2 do
 local choice = Instance.new("TextButton", modeRow); choice.Name = "AimbotModeV" .. mode; choice.Size = UDim2.new(0, 46, 0, 24); choice.Position = UDim2.new(1, mode == 1 and -102 or -50, 0.5, -12); choice.BackgroundColor3 = COLORS.row; choice.BorderSizePixel = 0; choice.Text = "V" .. mode; choice.TextSize = 11; choice.Font = Enum.Font.GothamBold; choice.ZIndex = 7; corner(choice, 5)
 choices[mode] = choice
 choice.Activated:Connect(function() if F.setAimbotMode then F.setAimbotMode(mode) end end)
end
S.refreshAimbotMode = function()
 for mode, choice in ipairs(choices) do
  local selected = (S.aimbotMode or 1) == mode
  choice.BackgroundColor3 = selected and (S.themeColor or COLORS.accentStrong) or COLORS.row
  choice.TextColor3 = selected and COLORS.off or COLORS.white
  choice.Text = selected and ("✓ V" .. mode) or ("V" .. mode)
 end
end
S.aimbotV2SetVisual = function(on) svAim(on or aimbotEnabled) end
S.refreshAimbotMode()
end do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Bat V2") mkKB(row, KB.BatV2, function(k, isGp) if isGp then KB.BatV2.gp = k; KB.BatV2.kb = nil else KB.BatV2.kb = k; KB.BatV2.gp = nil end F.saveConfig() end) local pill, dot = mkPill(row, 118) local bv2On = false local function svBatV2(s) bv2On = s; animPill(pill, dot, s) end S.batV2SetVisual = svBatV2; local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, -66, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function() if S._anyKeyListening then return end
if F.safeModeTryStart and not F.safeModeTryStart() then return end if F.toggleAimbotBatV2 then F.toggleAimbotBatV2() end if F.isAimbotBatV2On then bv2On = F.isAimbotBatV2On(); svBatV2(bv2On) end end) end VS.setAutoSwingVisual = mkToggle(pageTOOLS, "Auto Swing", function(on) S.autoSwingEnabled = on F.saveConfig() end) if VS.setAutoSwingVisual then VS.setAutoSwingVisual(S.autoSwingEnabled) end do
VS.setBatCounterVisual = mkToggle(pageTOOLS, "Bat Counter", function(on) S.batCounterEnabled = on if on then S.startBatCounter() else S.stopBatCounter() end F.saveConfig() end) end do
local expanded = false; local headerH, bodyH = 34, 76; local wrap = Instance.new("Frame", pageTOOLS); wrap.Size = UDim2.new(1, 0, 0, headerH); wrap.BackgroundTransparency = 1; wrap.ClipsDescendants = true; wrap.LayoutOrder = LO(); local header = Instance.new("Frame", wrap); header.Size = UDim2.new(1, 0, 0, headerH); header.BackgroundColor3 = COLORS.row; header.BorderSizePixel = 0; corner(header, 9); stroke(header, COLORS.strokeSoft, 1, 0.55) header.MouseEnter:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row2}):Play() end)
header.MouseLeave:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row}):Play() end) local arrow = Instance.new("TextLabel", header)
arrow.Size = UDim2.new(0, 22, 1, 0); arrow.Position = UDim2.new(0, 8, 0, 0); arrow.BackgroundTransparency = 1; arrow.Text = "▶"; arrow.TextColor3 = COLORS.accentStrong; arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 11; arrow.TextXAlignment = Enum.TextXAlignment.Left; local titleLbl = Instance.new("TextLabel", header); titleLbl.Size = UDim2.new(0.5, 0, 1, 0); titleLbl.Position = UDim2.new(0, 28, 0, 0); titleLbl.BackgroundTransparency = 1; titleLbl.Text = "TP Bat"; titleLbl.TextColor3 = COLORS.white; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 12; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; local modeHint = Instance.new("TextLabel", header); modeHint.Size = UDim2.new(0, 48, 0, 18); modeHint.Position = UDim2.new(1, -110, 0.5, -9); modeHint.BackgroundColor3 = Color3.fromRGB(18, 18, 20); modeHint.Text = ""; modeHint.Visible = false; modeHint.TextColor3 = COLORS.accentStrong; modeHint.Font = Enum.Font.GothamBold; modeHint.TextSize = 10; modeHint.BorderSizePixel = 0; corner(modeHint, 5); local pill, dot = mkPill(header, 52); local tpOn = false
local function svTP(s) tpOn = s; animPill(pill, dot, s) end VS.setTPBatVisual = svTP; local pillClk = Instance.new("TextButton", pill); pillClk.Size = UDim2.new(1, 0, 1, 0); pillClk.BackgroundTransparency = 1; pillClk.Text = ""; pillClk.ZIndex = 6 pillClk.Activated:Connect(function() if S._anyKeyListening then return end tpOn = not tpOn; svTP(tpOn); setTPBatState(tpOn); F.saveConfig() end) local body = Instance.new("Frame", wrap)
body.Size = UDim2.new(1, 0, 0, bodyH); body.Position = UDim2.new(0, 0, 0, headerH); body.BackgroundTransparency = 1; body.Visible = false; local kbRow = Instance.new("Frame", body); kbRow.Size = UDim2.new(1, 0, 0, 32); kbRow.Position = UDim2.new(0, 0, 0, 4); kbRow.BackgroundColor3 = COLORS.row2; kbRow.BorderSizePixel = 0; corner(kbRow, 8); stroke(kbRow, COLORS.strokeSoft, 1, 0.6); local kbLbl = Instance.new("TextLabel", kbRow); kbLbl.Size = UDim2.new(0.5, 0, 1, 0); kbLbl.Position = UDim2.new(0, 12, 0, 0); kbLbl.BackgroundTransparency = 1; kbLbl.Text = "Keybind"; kbLbl.TextColor3 = COLORS.textDim; kbLbl.Font = Enum.Font.GothamBold; kbLbl.TextSize = 11; kbLbl.TextXAlignment = Enum.TextXAlignment.Left
mkKB(kbRow, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end) local modeRow = Instance.new("Frame", body)
modeRow.Size = UDim2.new(1, 0, 0, 32); modeRow.Position = UDim2.new(0, 0, 0, 38); modeRow.BackgroundColor3 = COLORS.row2; modeRow.BorderSizePixel = 0; corner(modeRow, 8); stroke(modeRow, COLORS.strokeSoft, 1, 0.6); local modeTitle = Instance.new("TextLabel", modeRow); modeTitle.Size = UDim2.new(0.4, 0, 1, 0); modeTitle.Position = UDim2.new(0, 12, 0, 0); modeTitle.BackgroundTransparency = 1; modeTitle.Text = "Mode"; modeTitle.TextColor3 = COLORS.textDim; modeTitle.Font = Enum.Font.GothamBold; modeTitle.TextSize = 11; modeTitle.TextXAlignment = Enum.TextXAlignment.Left; tpBatModeLbl = Instance.new("TextButton", modeRow); tpBatModeLbl.Size = UDim2.new(0, 78, 0, 22); tpBatModeLbl.Position = UDim2.new(1, -90, 0.5, -11); tpBatModeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); tpBatModeLbl.BorderSizePixel = 0; tpBatModeLbl.Text = "V1"; tpBatModeLbl.TextColor3 = COLORS.white; tpBatModeLbl.Font = Enum.Font.GothamBold; tpBatModeLbl.TextSize = 11; tpBatModeLbl.ZIndex = 6; tpBatModeLbl.AutoButtonColor = true; corner(tpBatModeLbl, 7); stroke(tpBatModeLbl, COLORS.stroke, 1, 0.55)
tpBatModeLbl.MouseButton1Click:Connect(function() tpBatMode = 1 tpBatModeLbl.Text = "V1" if modeHint then modeHint.Text = "V1"; modeHint.Visible = true end end) modeRow.Visible = true if modeHint then modeHint.Text = tpBatModeLbl.Text; modeHint.Visible = true end bodyH = 76 local function setExpanded(on) expanded = on; arrow.Text = on and "▼" or "▶"; body.Visible = on
TS:Create(wrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, on and (headerH + bodyH + 2) or headerH) }):Play() end local expandBtn = Instance.new("TextButton", header); expandBtn.Size = UDim2.new(1, -56, 1, 0); expandBtn.Position = UDim2.new(0, 0, 0, 0); expandBtn.BackgroundTransparency = 1; expandBtn.Text = ""; expandBtn.ZIndex = 2 expandBtn.Activated:Connect(function() if S._anyKeyListening then return end setExpanded(not expanded) end) end section(pageTOOLS, "Steal Config") do
local stealRow = mkRow(pageTOOLS, 34); mkLabel(stealRow, "Auto Steal"); local pill, dot = mkPill(stealRow, 52) local function applyStealVis(on) TS:Create(pill, TweenInfo.new(0.15), {BackgroundColor3 = on and COLORS.accent or COLORS.off}):Play() TS:Create(dot, TweenInfo.new(0.15), { Position = on and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = on and COLORS.white or COLORS.textDim }):Play() end VS.setInstaGrab = applyStealVis stealRow.InputBegan:Connect(function(inp)
if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end if S._anyKeyListening then return end local on = not autoStealEnabled if on then startAutoSteal() else stopAutoSteal() end applyStealVis(on); F.saveConfig() end)
local function mkChips(labelTxt, opts, getSel, onPick)
local row = mkRow(pageTOOLS, 34); mkLabel(row, labelTxt); local btns = {}
local function refresh() local sel = getSel() for name, b in pairs(btns) do local on = (name == sel); b.BackgroundColor3 = on and COLORS.accent or Color3.fromRGB(18, 18, 20); b.TextColor3 = on and COLORS.white or COLORS.textDim end end
for i, name in ipairs(opts) do local b = Instance.new("TextButton", row); b.Size = UDim2.new(0, 46, 0, 24); b.Position = UDim2.new(1, -(#opts - i + 1) * 50 - 2, 0.5, -12); b.BorderSizePixel = 0; b.Text = name; b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.ZIndex = 5; b.AutoButtonColor = false; corner(b, 8); stroke(b, COLORS.stroke, 1, 0.6) btns[name] = b
b.MouseButton1Click:Connect(function() if S._anyKeyListening then return end onPick(name); refresh() end) end
refresh() return refresh end
local curMode = function() if selectedStealMode == "V2" and _G.__StealV3 then return "V3" end return selectedStealMode or "V1" end
local refreshMode
refreshMode = mkChips("Steal Mode", {"V1", "V2", "V3"}, curMode, function(m)
if YoutSetStealMode then pcall(YoutSetStealMode, m) end
if m ~= "V1" then autoStealRadius = 60; Steal.StealRadius = 60; if UI.radInput then UI.radInput.Text = "60" end end
if autoStealEnabled then pcall(stopAutoSteal); pcall(startAutoSteal) end F.saveConfig() end)
UI.stealModeLbl = setmetatable({}, { __newindex = function(t, k, v) if k == "Text" then _G.__StealV3 = (v == "V3"); task.defer(refreshMode) end end })
local pctOf = function() return string.format("%d%%", math.floor((tonumber(_G.__StealStopPct) or 0.80) * 100 + 0.5)) end
local refreshPct
refreshPct = mkChips("Stop %", {"75%", "80%", "90%"}, pctOf, function(n) _G.__StealStopPct = ((tonumber((n:gsub("%%", ""))) or 80)) / 100; F.saveConfig() end)
end
do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Steal Radius") UI.radInput = mkBox(row, Steal.StealRadius, 54, 62, function(v) v = tonumber(v) if v and v > 0 then autoStealRadius = v; Steal.StealRadius = v; AceStealRadii.Normal = v if YoutSetStealRadius then pcall(YoutSetStealRadius, v) end if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", v) end F.saveConfig() end end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Steal Duration")


UI.stealDurInput = mkBox(row, Steal.StealDuration, 54, 62, function(v) v = tonumber(v) if v and v >= 0.1 then Steal.StealDuration = v; if YoutSetStealDuration then pcall(YoutSetStealDuration, v) end F.saveConfig() end end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Stop Time"); local pill, dot = mkPill(row, 52) local function vis(on) TS:Create(pill, TweenInfo.new(0.15), {BackgroundColor3 = on and COLORS.accent or COLORS.off}):Play() TS:Create(dot, TweenInfo.new(0.15), { Position = on and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play() end VS.setAutoGrabStopVisual = vis row.InputBegan:Connect(function(inp)
if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end Steal.AutoGrabStopEnabled = not Steal.AutoGrabStopEnabled; autoGrabStopEnabled = Steal.AutoGrabStopEnabled; vis(Steal.AutoGrabStopEnabled); F.saveConfig() end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Stop Time (s)") UI.stopTimeInput = mkBox(row, Steal.AutoGrabStopTime, 54, 62, function(v) v = tonumber(v) if v and v > 0 then Steal.AutoGrabStopTime = v; autoGrabStopTime = v; F.saveConfig() end end) end do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Delay Radius") UI.delayRadInput = mkBox(row, Steal.AutoGrabDelayRadius, 54, 62, function(v) v = tonumber(v) if v and v > 0 then Steal.AutoGrabDelayRadius = v; autoGrabDelayRadius = v; F.saveConfig() end end) end section(pageTOOLS, "Combat") VS.setMedusaVisual = mkToggle(pageTOOLS, "Medusa Counter", function(on) S.medusaCounterEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Instant Reset")
mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() if F.doInstaReset then F.doInstaReset() end end) end VS.setInfJumpVisual = mkToggle(pageTOOLS, "Infinite Jump", function(on) infJumpEnabled = on if on then F.startInfJump() else F.stopInfJump() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Jump Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = ((S.infJumpMode or "hold") == "manual") and "Manual" or "Hold"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5 corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6); UI.infJumpModeBtn = btn btn.MouseButton1Click:Connect(function()
local nextMode = ((S.infJumpMode or "hold") == "manual") and "hold" or "manual" F.setInfJumpMode(nextMode); btn.Text = (nextMode == "manual") and "Manual" or "Hold" F.saveConfig() end) end VS.setAntiRagVisual = mkToggle(pageTOOLS, "Anti Ragdoll", function(on) S.antiRagdollEnabled = on if on then F.startAntiRagdoll() else F.stopAntiRagdoll() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Ragdoll Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() S.antiRagdollMode = (S.antiRagdollMode == 2) and 1 or 2
btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1" if S.antiRagdollEnabled then F.stopAntiRagdoll(); F.startAntiRagdoll() end F.saveConfig() end) end do
section(pageTOOLS, "Anti Die System") VS.setAntiDieVisual = mkToggle(pageTOOLS, "Anti Die", function(on) if on then F.startAntiDie() else F.stopAntiDie() end F.saveConfig() end) VS.setAntiFlingVisual = mkToggle(pageTOOLS, "Fling Shield", function(on) if on then F.startAntiFlingShield() else F.stopAntiFlingShield() end F.saveConfig() end) VS.setYoutAntiBatVisual = mkToggle(pageTOOLS, "Anti Bat", function(on)
    if on then pcall(startAntiBat) else pcall(stopAntiBat) end
    pcall(function() if F.saveConfig then F.saveConfig() end end)
end)
VS.setAntiBatVisual = VS.setYoutAntiBatVisual
end VS.setNoPlayerCollisionVisual = mkToggle(pageTOOLS, "No Player Collision", function(on)
if on then F.enableNoPlayerCollision() else F.disableNoPlayerCollision() end F.saveConfig() end) VS.setSafeModeVisual = mkToggle(pageTOOLS, "Safe Mode", function(on) S.safeModeEnabled = on F.saveConfig() end) VS.setMedusaResetVisual = mkToggle(pageTOOLS, "Medusa Reset", function(on) S.medusaResetEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) VS.setAutoResetOnMedVisual = mkToggle(pageTOOLS, "Auto Reset On Med Fling", function(on) F.setAutoResetOnMed(on) F.saveConfig() end) lo = 0; section(pageVIEW, "Visual")
VS.setAntiLagVisual = mkToggle(pageVIEW, "Anti Lag", function(on) if on then F.enableAntiLag() else F.disableAntiLag() end F.saveConfig() end) VS.setStretchRezVisual = mkToggle(pageVIEW, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end F.saveConfig() end) VS.setUnwalkVisual = mkToggle(pageVIEW, "Unwalk", function(on) S.unwalkEnabled = on if on then F.startUnwalk() else F.stopUnwalk() end end) VS.setRemoveAccVisual = mkToggle(pageVIEW, "Remove Accessories", function(on) if on then F.startRemoveAccessories() else F.stopRemoveAccessories() end
end) section(pageVIEW, "ESP") VS.setLineESPVisual = mkToggle(pageVIEW, "Player ESP", function(on) K7.lineESPEnabled = on K7.speedESPEnabled = on; K7.refreshESP(); F.saveConfig() end) VS.setShowTrackerVisual = mkToggle(pageVIEW, "Tracer ESP", function(on) S.showTracerEnabled = on if on then startTracerESP() else stopTracerESP() end pcall(function() if F.setShowTracer then F.setShowTracer(false) end end)
pcall(function() if F.clearTracers then F.clearTracers() end end) S.showTracerEnabled = on; F.saveConfig() end) VS.setShowTracerVisual = VS.setShowTrackerVisual VS.setSpeedESPVisual = function(on) if VS.setLineESPVisual then VS.setLineESPVisual(on) end end VS.setRagdollCdVisual = mkToggle(pageVIEW, "Ragdoll Countdown", function(on) F.setRagdollCountdown(on) F.saveConfig() end) section(pageVIEW, "Sky & Vision") do
local row = mkRow(pageVIEW, 34); mkLabel(row, "Sky Theme"); local skyLbl = Instance.new("TextLabel", row); skyLbl.Size = UDim2.new(0, 90, 0, 24); skyLbl.Position = UDim2.new(1, -100, 0.5, -12); skyLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); skyLbl.Text = K7.currentSkyTheme; skyLbl.TextColor3 = COLORS.white; skyLbl.Font = Enum.Font.GothamBold; skyLbl.TextSize = 11; Instance.new("UICorner", skyLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() local name = K7.cycleSkyTheme(1) skyLbl.Text = name; F.saveConfig() end) end do local row = mkRow(pageVIEW, 34); mkLabel(row, "FOV") local fovBox = mkBox(row, K7.fovValue or _G._VezyFOV or 70, 54, 62, function(v) if v >= 30 and v <= 180 then K7.fovValue = v; _G._VezyFOV = v if K7.fovEnabled then K7.applyFOV() end local cam = workspace.CurrentCamera if cam and not (State and State.stretchedResEnabled) then pcall(function() cam.FieldOfView = v end) end end F.saveConfig() end) end VS.setFOVVisual = mkToggle(pageVIEW, "Custom FOV", function(on) K7.fovEnabled = on
K7.applyFOV(); F.saveConfig() end) lo = 0 section(pageSYS, "Charter") VS.setHeadlessVisual = mkToggle(pageSYS, "Headless", function(on) K7.headlessEnabled = on K7.applyHeadless(LP.Character, on); F.saveConfig() end) VS.setKorbloxVisual = mkToggle(pageSYS, "Korblox", function(on) K7.korbloxEnabled = on K7.applyKorblox(LP.Character, on); F.saveConfig() end) do
local sideNames = {[1] = "Right", [2] = "Left", [3] = "Both"}; local row = mkRow(pageSYS, 34); mkLabel(row, "Korblox Side"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = sideNames[korbloxSide] or "Right"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() korbloxSide = (korbloxSide % 3) + 1
K7.korbloxSide = korbloxSide; btn.Text = sideNames[korbloxSide] or "Right" if K7.korbloxEnabled then K7.applyKorblox(LP.Character, true) end F.saveConfig() end) end section(pageSYS, "Animation Pack") VS.setAnimPackVisual = mkToggle(pageSYS, "Animation Pack Enabled", function(on) K7.animPackEnabled = on if on then K7.applyAnimPack(K7.animPackName) else K7.resetAnimPack() end F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Select Pack"); local packLbl = Instance.new("TextLabel", row); packLbl.Size = UDim2.new(0, 100, 0, 24); packLbl.Position = UDim2.new(1, -110, 0.5, -12); packLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); packLbl.Text = K7.animPackName; UI.animPackLbl = packLbl; packLbl.TextColor3 = COLORS.white; packLbl.Font = Enum.Font.GothamBold; packLbl.TextSize = 10; Instance.new("UICorner", packLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() K7.animPackIndex = K7.animPackIndex % #K7.ANIM_PACK_LIST + 1 K7.animPackName = K7.ANIM_PACK_LIST[K7.animPackIndex]; packLbl.Text = K7.animPackName if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Current Pack"); local applyBtn = Instance.new("TextButton", row); applyBtn.Size = UDim2.new(0, 60, 0, 24); applyBtn.Position = UDim2.new(1, -70, 0.5, -12); applyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44); applyBtn.Text = "APPLY"; applyBtn.TextColor3 = COLORS.white; applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 11; applyBtn.BorderSizePixel = 0; Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6) applyBtn.Activated:Connect(function() if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end)
end section(pageSYS, "Interface") do local row = mkRow(pageSYS, 34); mkLabel(row, "Hide UI") mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end section(pageSYS, "Appearance") do
local row = mkRow(pageSYS, 42); mkLabel(row, "Accent Color"); local picker = Instance.new("Frame"); picker.Name = "ColorThemePicker"; picker.Size = UDim2.new(0, 176, 0, 22); picker.Position = UDim2.new(1, -184, 0.5, -11); picker.BackgroundTransparency = 1; picker.ZIndex = 6; picker.Parent = row; local lay = Instance.new("UIListLayout"); lay.FillDirection = Enum.FillDirection.Horizontal; lay.Padding = UDim.new(0, 5); lay.VerticalAlignment = Enum.VerticalAlignment.Center; lay.HorizontalAlignment = Enum.HorizontalAlignment.Right; lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = picker; local selectedPill = nil
for idx, preset in ipairs(THEME_PRESETS) do local btn = Instance.new("TextButton"); btn.Name = preset.name; btn.LayoutOrder = idx; btn.Size = UDim2.new(0, 16, 0, 16) btn.BackgroundColor3 = preset.color btn.BorderSizePixel = 0; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 7; btn.Parent = picker; local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = btn; local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255, 255, 255); st.Thickness = 1.2; st.Transparency = 0.6; st.Parent = btn btn.MouseButton1Click:Connect(function() if selectedPill then
local os = selectedPill:FindFirstChildOfClass("UIStroke") if os then os.Transparency = 0.6; os.Thickness = 1.2 end TS:Create(selectedPill, TweenInfo.new(0.12), {Size = UDim2.new(0, 16, 0, 16)}):Play() end selectedPill = btn; st.Transparency = 0; st.Thickness = 2; TS:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Size = UDim2.new(0, 18, 0, 18)}):Play(); applyThemeColor(preset.color, preset.name) if bgAsset and bgAsset.Image ~= "" then bgAsset.ImageColor3 = Color3.new( 0.75 + preset.color.R * 0.25, 0.75 + preset.color.G * 0.25, 0.75 + preset.color.B * 0.25 ) end
pcall(function() F.saveConfig() end) end) if preset.name == (S.currentThemeName or currentThemeName) then selectedPill = btn; st.Transparency = 0; st.Thickness = 2; btn.Size = UDim2.new(0, 18, 0, 18) end end end

-- Animated color mode: cosmetic only.
do
    local rainbowRunning = false
    local rainbowColors = {
        Color3.fromRGB(255, 70, 120), Color3.fromRGB(255, 150, 40),
        Color3.fromRGB(255, 235, 70), Color3.fromRGB(70, 220, 120),
        Color3.fromRGB(70, 190, 255), Color3.fromRGB(140, 90, 255),
        Color3.fromRGB(255, 70, 220)
    }
    local function startRainbow()
        if rainbowRunning then return end
        rainbowRunning = true
        task.spawn(function()
            local i = 0
            while rainbowRunning and main and main.Parent do
                i = (i % #rainbowColors) + 1
                local a, b = rainbowColors[i], rainbowColors[(i % #rainbowColors) + 1]
                for step = 0, 10 do
                    if not rainbowRunning then break end
                    applyThemeColor(a:Lerp(b, step / 10), "RAINBOW")
                    task.wait(0.045)
                end
            end
        end)
    end
    local function stopRainbow() rainbowRunning = false end
    mkToggle(pageSYS, "Rainbow Colors", function(on)
        if on then startRainbow() else stopRainbow() end
        F.saveConfig()
    end)
end

do pcall(ensureBgAssets); local row = mkRow(pageSYS, 72); row.ClipsDescendants = false; mkLabel(row, "Background"); local gallery = Instance.new("ScrollingFrame"); gallery.Name = "BgGallery"
gallery.Size = UDim2.new(1, -110, 0, 52); gallery.Position = UDim2.new(0, 100, 0.5, -26); gallery.BackgroundColor3 = Color3.fromRGB(14, 14, 16); gallery.BackgroundTransparency = 0.25; gallery.BorderSizePixel = 0; gallery.ScrollBarThickness = 2; gallery.ScrollBarImageColor3 = COLORS.stroke; gallery.ScrollingDirection = Enum.ScrollingDirection.X; gallery.CanvasSize = UDim2.new(0, 0, 0, 0); gallery.AutomaticCanvasSize = Enum.AutomaticSize.X; gallery.ZIndex = 6; gallery.Parent = row
corner(gallery, 10); stroke(gallery, COLORS.stroke, 1, 0.7); local list = Instance.new("UIListLayout"); list.FillDirection = Enum.FillDirection.Horizontal; list.Padding = UDim.new(0, 6); list.VerticalAlignment = Enum.VerticalAlignment.Center list.SortOrder = Enum.SortOrder.LayoutOrder; list.Parent = gallery; local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6); pad.Parent = gallery; local selectedBg = nil for idx, preset in ipairs(BG_PRESETS) do
local thumb = Instance.new("ImageButton"); thumb.Name = "Bg_" .. preset.name; thumb.LayoutOrder = idx; thumb.Size = UDim2.new(0, 44, 0, 40); thumb.BackgroundColor3 = Color3.fromRGB(18, 18, 20); thumb.BorderSizePixel = 0; local resolvedThumb = resolveBgId(preset.id); thumb.Image = resolvedThumb; thumb.ImageTransparency = (resolvedThumb == "" and 1) or 0.1; thumb.ScaleType = Enum.ScaleType.Crop; thumb.ScaleType = Enum.ScaleType.Crop; thumb.AutoButtonColor = false; thumb.ZIndex = 7; thumb.Parent = gallery; corner(thumb, 8); local st = Instance.new("UIStroke"); st.Color = COLORS.stroke; st.Thickness = 1.2; st.Transparency = 0.45; st.Parent = thumb; st:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, st)
if preset.id == "" then local none = Instance.new("TextLabel"); none.Size = UDim2.new(1, 0, 1, 0); none.BackgroundTransparency = 1; none.Text = "NONE"; none.TextColor3 = COLORS.textDim; none.Font = Enum.Font.GothamBold; none.TextSize = 9; none.ZIndex = 8; none.Parent = thumb end thumb.MouseButton1Click:Connect(function() if selectedBg then local os = selectedBg:FindFirstChildOfClass("UIStroke") if os then os.Transparency = 0.45; os.Thickness = 1.2 end end selectedBg = thumb; st.Transparency = 0; st.Thickness = 2; applyBackground(preset.id) end)
if (S.currentBgId or currentBgId or "") == preset.id then selectedBg = thumb; st.Transparency = 0; st.Thickness = 2 end end end do
local row = mkRow(pageSYS, 34); mkLabel(row, "BG Intensity"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local valLbl = Instance.new("TextLabel", row); valLbl.Size = UDim2.new(0, 44, 0, 24); valLbl.Position = UDim2.new(1, -80, 0.5, -12); valLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); valLbl.BackgroundTransparency = 0.15; valLbl.BorderSizePixel = 0; valLbl.Text = "58%"; valLbl.TextColor3 = COLORS.white; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11; valLbl.ZIndex = 5; corner(valLbl, 8); local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5
corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75); S.bgIntensity = S.bgIntensity or 0.58 local function setIntensity(v) S.bgIntensity = math.clamp(v, 0.15, 0.9); valLbl.Text = string.format("%d%%", math.floor(S.bgIntensity * 100 + 0.5)) if bgAsset and bgAsset.Image ~= "" then bgAsset.ImageTransparency = 1 - S.bgIntensity end pcall(function() F.saveConfig() end) end minusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity - 0.08) end) plusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity + 0.08) end) setIntensity(S.bgIntensity) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "GUI Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local scaleLbl = Instance.new("TextLabel", row); scaleLbl.Size = UDim2.new(0, 44, 0, 24); scaleLbl.Position = UDim2.new(1, -80, 0.5, -12); scaleLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); scaleLbl.BackgroundTransparency = 0.15; scaleLbl.BorderSizePixel = 0; scaleLbl.Text = "100%"; scaleLbl.TextColor3 = COLORS.white; scaleLbl.Font = Enum.Font.GothamBold; scaleLbl.TextSize = 11; scaleLbl.ZIndex = 5
corner(scaleLbl, 8); UI.guiScaleLbl = scaleLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) minusBtn.Activated:Connect(function() if S._anyKeyListening then return end
if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) - 0.1) end end) plusBtn.Activated:Connect(function() if S._anyKeyListening then return end if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) + 0.1) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Progress Bar Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "-"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local pbLbl = Instance.new("TextLabel", row); pbLbl.Size = UDim2.new(0, 44, 0, 24); pbLbl.Position = UDim2.new(1, -80, 0.5, -12); pbLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); pbLbl.BackgroundTransparency = 0.15; pbLbl.BorderSizePixel = 0; pbLbl.Text = tostring(S.progressBarScale or 100) .. "%"; pbLbl.TextColor3 = COLORS.white; pbLbl.Font = Enum.Font.GothamBold; pbLbl.TextSize = 11; pbLbl.ZIndex = 5
corner(pbLbl, 8); _G.__VersincProgressBarSizeLbl = pbLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) local function bump(d) if S._anyKeyListening then return end
local n = math.clamp((tonumber(S.progressBarScale) or 100) + d, 50, 200) if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(n) end pbLbl.Text = tostring(S.progressBarScale or n) .. "%"; F.saveConfig() end minusBtn.Activated:Connect(function() bump(-10) end) plusBtn.Activated:Connect(function() bump(10) end) end section(pageSYS, "Protection") VS.setNoIntroVisual = mkToggle(pageSYS, "No Intro", function(on) S.noIntroEnabled = on and true or false if S.noIntroEnabled then S.introEnabled = false pcall(function() local pg = LP:FindFirstChild("PlayerGui") local old = pg and pg:FindFirstChild("VersicnIntro") if old then old:Destroy() end end) else S.introEnabled = true end F.saveConfig(true) end) task.defer(function() if VS.setNoIntroVisual then VS.setNoIntroVisual(S.noIntroEnabled == true) end end) VS.setLockGuiVisual = mkToggle(pageSYS, "Lock GUI", function(on) S.guiLocked = on and true or false F.saveConfig() end) if S.autoSaveEnabled == nil then S.autoSaveEnabled = true end VS.setAutoSaveVisual = mkToggle(pageSYS, "Auto Save", function(on)
S.autoSaveEnabled = on and true or false if UI and UI.saveStatusLbl then UI.saveStatusLbl.Text = S.autoSaveEnabled and "Auto save: on" or "Auto save: off" end F.saveConfig(true) end) do local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if VS.setAutoSaveVisual then VS.setAutoSaveVisual(S.autoSaveEnabled) end
if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end end) section(pageSYS, "Mobile") VS.setMoveButtonsVisual = mkToggle(pageSYS, "Move Buttons", function(on) S.moveButtons = on and true or false if S.allLockButtons == true then S.lockMobileButtons = true else S.lockMobileButtons = not S.moveButtons end F.saveConfig(true) end) VS.setLockMobileButtonsVisual = VS.setMoveButtonsVisual VS.setAllLockVisual = mkToggle(pageSYS, "Lock All Buttons", function(on) S.allLockButtons = on and true or false S.lockMobileButtons = S.allLockButtons if S.allLockButtons then S.moveButtons = false end if VS.setMoveButtonsVisual then pcall(function() VS.setMoveButtonsVisual(S.moveButtons == true) end) end F.saveConfig(true) end) S.setAllLockVisual = VS.setAllLockVisual task.defer(function() if VS.setMoveButtonsVisual then VS.setMoveButtonsVisual(S.moveButtons == true) end if VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons == true) end end) VS.setHideMobileVisual = mkToggle(pageSYS, "Hide Mobile Buttons", function(on) S.hideMobileButtons = on and true or false F.applyMobileButtonsHidden(); F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Mobile Buttons Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5
corner(minusBtn, 8); local sizeLbl = Instance.new("TextLabel", row); sizeLbl.Size = UDim2.new(0, 44, 0, 24); sizeLbl.Position = UDim2.new(1, -80, 0.5, -12); sizeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); sizeLbl.BorderSizePixel = 0
sizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80); sizeLbl.TextColor3 = COLORS.white; sizeLbl.Font = Enum.Font.GothamBold; sizeLbl.TextSize = 11; sizeLbl.ZIndex = 5; corner(sizeLbl, 8); UI.mobileSizeLbl = sizeLbl; local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8)
local function refreshSizeLbl() if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end end minusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) - 0.05, 0.30, 1.35) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) plusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) + 0.05, 0.30, 1.35) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset Mobile Buttons"); local resetBtn = Instance.new("TextButton", row); resetBtn.Size = UDim2.new(0, 72, 0, 24); resetBtn.Position = UDim2.new(1, -82, 0.5, -12); resetBtn.BackgroundColor3 = Color3.fromRGB(238, 238, 238); resetBtn.BorderSizePixel = 0; resetBtn.Text = "RESET"; resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0); resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 11; resetBtn.ZIndex = 5; corner(resetBtn, 8) resetBtn.Activated:Connect(function() F.resetMobileButtons()
if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end if VS.setHideMobileVisual then VS.setHideMobileVisual(false) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Save Config"); local saveBtn = Instance.new("TextButton", row); saveBtn.Size = UDim2.new(0, 72, 0, 24); saveBtn.Position = UDim2.new(1, -82, 0.5, -12); saveBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); saveBtn.BackgroundTransparency = 0.1; saveBtn.BorderSizePixel = 0; saveBtn.Text = "SAVE"; saveBtn.TextColor3 = COLORS.white; saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 11; saveBtn.ZIndex = 5; corner(saveBtn, 8); stroke(saveBtn, COLORS.stroke, 1, 0.75) saveBtn.Activated:Connect(function() if S._anyKeyListening then return end
saveBtn.Text = "..."; local ok = F.saveConfig(true) pcall(function() if F.saveMobileButtonsOnly then F.saveMobileButtonsOnly() end end) saveBtn.Text = ok and "SAVED" or "FAIL" if UI.saveStatusLbl then UI.saveStatusLbl.Text = ok and ("Saved " .. os.date("%H:%M:%S")) or "Save failed"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 120, 120) end task.delay(1.4, function() if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE" end end) end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset All Configs"); local resetCfgBtn = Instance.new("TextButton", row); resetCfgBtn.Size = UDim2.new(0, 72, 0, 24); resetCfgBtn.Position = UDim2.new(1, -82, 0.5, -12); resetCfgBtn.BackgroundColor3 = Color3.fromRGB(238, 80, 80); resetCfgBtn.BackgroundTransparency = 0.05; resetCfgBtn.BorderSizePixel = 0; resetCfgBtn.Text = "RESET"; resetCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255); resetCfgBtn.Font = Enum.Font.GothamBold; resetCfgBtn.TextSize = 11; resetCfgBtn.ZIndex = 5; corner(resetCfgBtn, 8); stroke(resetCfgBtn, Color3.fromRGB(255, 140, 140), 1, 0.45)
resetCfgBtn.Activated:Connect(function() if S._anyKeyListening then return end resetCfgBtn.Text = "..."; local ok = F.resetAllConfig(); resetCfgBtn.Text = ok and "DONE" or "OK" task.delay(1.5, function() if resetCfgBtn and resetCfgBtn.Parent then resetCfgBtn.Text = "RESET" end end) end) end do
local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = (S.autoSaveEnabled ~= false) and "Auto save: on" or "Auto save: off"; UI.saveStatusLbl.TextColor3 = COLORS.textDim end end) lo = 0

-- ===== BUILT-IN MUSIC PLAYER =====
do
    local musicState = {id = "", volume = 0.35, playing = false}
    local music = Instance.new("Sound")
    music.Name = "CandyHubMusic"
    music.Looped = true
    music.Volume = musicState.volume
    music.Parent = gui
    local musicStatus

    local function setMusicStatus(txt, good)
        if musicStatus and musicStatus.Parent then
            musicStatus.Text = txt
            musicStatus.TextColor3 = good and Color3.fromRGB(100, 220, 160) or COLORS.textDim
        end
    end

    section(pageMUSIC, "Music Player")
    do
        local row = mkRow(pageMUSIC, 42); mkLabel(row, "Sound ID")
        local box = mkBox(row, "", 112, 120, function(v)
            local id = tostring(v or ""):match("%d+")
            musicState.id = id or ""
            if id and id ~= "" then
                music.SoundId = "rbxassetid://" .. id
                setMusicStatus("Loaded " .. id, true)
            else
                music.SoundId = ""
                setMusicStatus("Enter a Roblox audio ID", false)
            end
        end)
        box.Text = ""
        box.PlaceholderText = "Audio ID"
        box.PlaceholderColor3 = COLORS.textDim
        UI.musicIdBox = box
    end
    do
        local row = mkRow(pageMUSIC, 42)
        local buttons = {
            {text="PLAY", x=-250}, {text="PAUSE", x=-165}, {text="STOP", x=-80}
        }
        for _, def in ipairs(buttons) do
            local b = Instance.new("TextButton", row)
            b.Size = UDim2.new(0, 76, 0, 26)
            b.Position = UDim2.new(1, def.x, 0.5, -13)
            b.BackgroundColor3 = COLORS.row2; b.BorderSizePixel = 0
            b.Text = def.text; b.TextColor3 = COLORS.white; b.Font = Enum.Font.GothamBold; b.TextSize = 11
            b.AutoButtonColor = false; b.ZIndex = 7; corner(b, 9); stroke(b, COLORS.stroke, 1, 0.55)
            if def.text == "PLAY" then
                b.Activated:Connect(function()
                    if musicState.id == "" and UI.musicIdBox then musicState.id = tostring(UI.musicIdBox.Text or ""):match("%d+") or "" end
                    if musicState.id == "" then setMusicStatus("Enter a Roblox audio ID", false); return end
                    music.SoundId = "rbxassetid://" .. musicState.id
                    pcall(function() music:Play() end); musicState.playing = true
                    setMusicStatus("Playing • " .. musicState.id, true)
                end)
            elseif def.text == "PAUSE" then
                b.Activated:Connect(function() pcall(function() music:Pause() end); musicState.playing = false; setMusicStatus("Paused", false) end)
            else
                b.Activated:Connect(function() pcall(function() music:Stop() end); musicState.playing = false; setMusicStatus("Stopped", false) end)
            end
        end
    end
    do
        local row = mkRow(pageMUSIC, 42); mkLabel(row, "Volume")
        local minus = Instance.new("TextButton", row)
        minus.Size = UDim2.new(0, 30, 0, 26); minus.Position = UDim2.new(1, -112, 0.5, -13)
        minus.BackgroundColor3 = COLORS.row2; minus.BorderSizePixel = 0; minus.Text = "−"; minus.TextColor3 = COLORS.white
        minus.Font = Enum.Font.GothamBold; minus.TextSize = 16; minus.AutoButtonColor = false; corner(minus, 8); stroke(minus, COLORS.stroke, 1, 0.6)
        local volLbl = Instance.new("TextLabel", row)
        volLbl.Size = UDim2.new(0, 54, 0, 26); volLbl.Position = UDim2.new(1, -78, 0.5, -13)
        volLbl.BackgroundColor3 = Color3.fromRGB(18,18,20); volLbl.BackgroundTransparency = 0.15; volLbl.BorderSizePixel = 0
        volLbl.Text = "35%"; volLbl.TextColor3 = COLORS.white; volLbl.Font = Enum.Font.GothamBold; volLbl.TextSize = 11
        corner(volLbl, 8); stroke(volLbl, COLORS.stroke, 1, 0.7)
        local plus = Instance.new("TextButton", row)
        plus.Size = UDim2.new(0, 30, 0, 26); plus.Position = UDim2.new(1, -36, 0.5, -13)
        plus.BackgroundColor3 = COLORS.row2; plus.BorderSizePixel = 0; plus.Text = "+"; plus.TextColor3 = COLORS.white
        plus.Font = Enum.Font.GothamBold; plus.TextSize = 16; plus.AutoButtonColor = false; corner(plus, 8); stroke(plus, COLORS.stroke, 1, 0.6)
        local function setVol(v)
            musicState.volume = math.clamp(v, 0, 1); music.Volume = musicState.volume
            volLbl.Text = string.format("%d%%", math.floor(musicState.volume * 100 + 0.5))
        end
        minus.Activated:Connect(function() setVol(musicState.volume - 0.05) end)
        plus.Activated:Connect(function() setVol(musicState.volume + 0.05) end)
    end
    do
        local row = mkRow(pageMUSIC, 30)
        musicStatus = Instance.new("TextLabel", row)
        musicStatus.Size = UDim2.new(1, -20, 1, 0); musicStatus.Position = UDim2.new(0, 10, 0, 0)
        musicStatus.BackgroundTransparency = 1; musicStatus.Text = "No track loaded"
        musicStatus.TextColor3 = COLORS.textDim; musicStatus.Font = Enum.Font.GothamMedium; musicStatus.TextSize = 11
        musicStatus.TextXAlignment = Enum.TextXAlignment.Left
    end
    do
        local row = mkRow(pageMUSIC, 34); mkLabel(row, "Music Hint")
        local hint = Instance.new("TextLabel", row)
        hint.Size = UDim2.new(0.42, 0, 1, 0); hint.Position = UDim2.new(0.56, 0, 0, 0)
        hint.BackgroundTransparency = 1; hint.Text = "Use an audio ID you have permission to play."
        hint.TextColor3 = COLORS.textDim; hint.Font = Enum.Font.GothamMedium; hint.TextSize = 9
        hint.TextWrapped = true; hint.TextXAlignment = Enum.TextXAlignment.Right
    end
end

lo = 0 section(pageKEYS, "Speed Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Speed Key"); mkKB(row, KB.SpeedToggle, function(k, isGp) if isGp then KB.SpeedToggle.gp = k; KB.SpeedToggle.kb = nil else KB.SpeedToggle.kb = k; KB.SpeedToggle.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Lagger Key"); mkKB(row, KB.LaggerToggle, function(k, isGp) if isGp then KB.LaggerToggle.gp = k; KB.LaggerToggle.kb = nil else KB.LaggerToggle.kb = k; KB.LaggerToggle.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Combat Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Bat V2 Key"); mkKB(row, KB.BatV2, function(k, isGp) if isGp then KB.BatV2.gp = k; KB.BatV2.kb = nil else KB.BatV2.kb = k; KB.BatV2.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Aimbot V2 Key"); mkKB(row, KB.AimbotV2, function(k, isGp) if isGp then KB.AimbotV2.gp = k; KB.AimbotV2.kb = nil else KB.AimbotV2.kb = k; KB.AimbotV2.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Bat Key"); mkKB(row, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Bat Key"); mkKB(row, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Insta Reset Key"); mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Movement Keybinds") do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Left Key"); mkKB(row, KB.AutoLeft, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Right Key"); mkKB(row, KB.AutoRight, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Drop Key"); mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Down Key"); mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Hide UI Key"); mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end 
-- ===== SKINS PAGE =====
do
local InsertService = game:GetService("InsertService")

-- ===================== RAINBOW TOOLS (Bat / Medusa coloridos) =====================
local RainbowTools = {}
do
    local SPEED, SPREAD, STEP = 0.35, 0.035, 1 / 40
    local enabled = false
    local tracked = setmetatable({}, { __mode = "k" })
    local watchers = setmetatable({}, { __mode = "k" })
    local unregister

    local function matchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then return false end
        local n = tostring(inst.Name):lower()
        return (n:find("bat") ~= nil) or (n:find("slap") ~= nil) or (n:find("medusa") ~= nil)
    end

    local function classify(d)
        if d:IsA("MeshPart") then
            return { obj = d, kind = "part", props = { "Color", "Material", "TextureID" }, clearTexture = "TextureID" }
        elseif d:IsA("BasePart") then
            return { obj = d, kind = "part", props = { "Color", "Material" } }
        elseif d:IsA("SurfaceAppearance") then
            return { obj = d, kind = "surface", props = { "Parent" } }
        elseif d:IsA("Decal") or d:IsA("Texture") then
            return { obj = d, kind = "decal", props = { "Transparency" } }
        elseif d:IsA("SpecialMesh") then
            return { obj = d, kind = "vector", prop = "VertexColor", props = { "VertexColor", "TextureId" }, clearTexture = "TextureId" }
        elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
            return { obj = d, kind = "sequence", prop = "Color", props = { "Color" } }
        elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
            return { obj = d, kind = "color", prop = "Color", props = { "Color" } }
        elseif d:IsA("Highlight") then
            return { obj = d, kind = "color", prop = "FillColor", props = { "FillColor" } }
        end
        return nil
    end

    local function snapshot(node)
        node.original = {}
        for _, prop in ipairs(node.props) do
            local ok, val = pcall(function() return node.obj[prop] end)
            if ok then node.original[prop] = val end
        end
    end

    local function restoreNode(node)
        if not node.original then return end
        for prop, val in pairs(node.original) do
            pcall(function() node.obj[prop] = val end)
        end
    end

    local function applyOnce(node)
        if node.kind == "surface" then
            pcall(function() node.obj.Parent = nil end)
        elseif node.kind == "decal" then
            pcall(function() node.obj.Transparency = 1 end)
        elseif node.clearTexture then
            pcall(function() node.obj[node.clearTexture] = "" end)
        end
    end

    local function addNode(entry, d)
        local node = classify(d)
        if not node then return end
        snapshot(node)
        applyOnce(node)
        if node.kind == "part" then
            table.insert(entry.parts, node)
        elseif node.kind == "surface" or node.kind == "decal" then
            table.insert(entry.statics, node)
        else
            table.insert(entry.effects, node)
        end
    end

    local function register(root)
        if tracked[root] then return end
        local entry = { parts = {}, effects = {}, statics = {}, conns = {} }
        tracked[root] = entry
        for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
        if root:IsA("BasePart") then addNode(entry, root) end
        table.insert(entry.conns, root.DescendantAdded:Connect(function(d) addNode(entry, d) end))
        table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
            if not parent then unregister(root, false) end
        end))
    end

    function unregister(root, doRestore)
        local entry = tracked[root]
        if not entry then return end
        for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
        if doRestore then
            for _, node in ipairs(entry.parts)   do restoreNode(node) end
            for _, node in ipairs(entry.effects) do restoreNode(node) end
            for _, node in ipairs(entry.statics) do restoreNode(node) end
        end
        tracked[root] = nil
    end

    local function tryRegister(inst)
        if not enabled then return end
        if matchItem(inst) then register(inst) end
    end

    local function unwatch(container)
        local conns = watchers[container]
        if not conns then return end
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        watchers[container] = nil
    end

    local function watch(container)
        if not container or watchers[container] then return end
        watchers[container] = { container.ChildAdded:Connect(tryRegister) }
        for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
    end

    local function watchAll()
        watch(LP:FindFirstChildOfClass("Backpack"))
        watch(LP.Character)
    end

    LP.ChildAdded:Connect(function(child)
        if enabled and child:IsA("Backpack") then watch(child) end
    end)

    LP.CharacterAdded:Connect(function(char)
        for root in pairs(tracked) do unregister(root, false) end
        for container in pairs(watchers) do unwatch(container) end
        if not enabled then return end
        watch(char)
        task.defer(function() if enabled then watchAll() end end)
    end)

    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not enabled then return end
        if next(tracked) == nil then return end
        acc = acc + dt
        if acc < STEP then return end
        acc = 0
        local baseHue = (tick() * SPEED) % 1
        for _, entry in pairs(tracked) do
            for i, node in ipairs(entry.parts) do
                local part = node.obj
                if part.Parent then
                    pcall(function() part.Color = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1) end)
                end
            end
            for i, node in ipairs(entry.effects) do
                if node.obj.Parent then
                    local col = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                    if node.kind == "sequence" then
                        pcall(function() node.obj[node.prop] = ColorSequence.new(col) end)
                    elseif node.kind == "vector" then
                        pcall(function() node.obj[node.prop] = Vector3.new(col.R, col.G, col.B) end)
                    else
                        pcall(function() node.obj[node.prop] = col end)
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(10)
            for root in pairs(tracked) do if not root.Parent then unregister(root, false) end end
            for container in pairs(watchers) do if not container.Parent then unwatch(container) end end
        end
    end)

    function RainbowTools.setEnabled(on)
        on = on and true or false
        enabled = on
        S.rainbowToolsEnabled = on
        if on then
            watchAll()
        else
            for root in pairs(tracked) do unregister(root, true) end
            for container in pairs(watchers) do unwatch(container) end
        end
    end
    function RainbowTools.isEnabled() return enabled end
    _G.__PVSRainbowTools = RainbowTools
end

local SKIN_MEDUSA = {
{id=11563251, name="Medusa 1"},
}
local SKIN_BAT = {
{id=14052995337, name="Epic Katana", soundId="rbxassetid://111808555599832", c0=CFrame.new()},
{id=126653333198410, name="Bloody Katana", soundId="rbxassetid://111808555599832", c0=CFrame.new()},
}
local SKIN_BAT_BY_ID = {}
for _, skin in ipairs(SKIN_BAT) do SKIN_BAT_BY_ID[tostring(skin.id)] = skin end
local batSkinSoundConnections = setmetatable({}, {__mode = "k"})
local function getBatSkinConfig(assetId)
return SKIN_BAT_BY_ID[tostring(tonumber(tostring(assetId):match("%d+")) or assetId)]
end
local function setBatSkinSound(tool, assetId)
if not tool then return end
local config = getBatSkinConfig(assetId)
local desired = config and config.soundId or nil
tool:SetAttribute("PVSCurrentBatSkinId", desired and tostring(config.id) or nil)
for _, sound in ipairs(tool:GetDescendants()) do
if sound:IsA("Sound") and sound.Name == "Slash" then
local original = sound:GetAttribute("PVSOriginalSlashSound")
if desired then
if original == nil then sound:SetAttribute("PVSOriginalSlashSound", sound.SoundId) end
sound.SoundId = desired
elseif original ~= nil then
sound.SoundId = original
sound:SetAttribute("PVSOriginalSlashSound", nil)
end
end
end
if not batSkinSoundConnections[tool] then
batSkinSoundConnections[tool] = tool.DescendantAdded:Connect(function(object)
if not object:IsA("Sound") or object.Name ~= "Slash" then return end
local activeId = tool:GetAttribute("PVSCurrentBatSkinId")
if activeId then task.defer(setBatSkinSound, tool, activeId) end
end)
end
end
local function loadAssetObjects(assetId)
assetId = tonumber(tostring(assetId):match("%d+"))
if not assetId then return nil end
local ok, res = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(assetId))
end)
if ok and type(res) == "table" and #res > 0 then return res end
ok, res = pcall(function() return InsertService:LoadAsset(tonumber(assetId)) end)
if ok and res then
if res:IsA("Model") then
local children = res:GetChildren()
if #children > 0 then return children end
return { res }
end
return { res }
end
return nil
end
local function getCharModel()
return workspace:FindFirstChild(LP.Name) or LP.Character
end
local function getBatTool()
local model = getCharModel()
if model then
local bat = model:FindFirstChild("Bat")
if bat then return bat end
end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if bp then
local bat = bp:FindFirstChild("Bat")
if bat then return bat end
end
return nil
end
local function getMedusaTool()
local model = getCharModel()
if model then
local med = model:FindFirstChild("Medusa's Head")
if med then return med end
end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if bp then
local med = bp:FindFirstChild("Medusa's Head")
if med then return med end
end
return nil
end
local function clearGearVisual(tool)
if not tool then return end
pcall(function()
local folder = tool:FindFirstChild("Hub073GearVisual")
if folder then folder:Destroy() end
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if handle then
for _, ch in ipairs(handle:GetChildren()) do
if ch.Name == "Hub073GearMesh" or (ch:IsA("SpecialMesh") and ch:GetAttribute("Hub073")) then
ch:Destroy()
end
end
local orig = tool:GetAttribute("Hub073OrigHandleTrans")
if orig ~= nil then
handle.Transparency = orig
elseif handle.Transparency >= 0.99 then
handle.Transparency = 0
end
end
end)
end
local function applyAssetToTool(tool, assetId)
if not tool or not assetId then return false end
if tool:GetAttribute("Hub073Applying") then return false end
tool:SetAttribute("Hub073Applying", true)
assetId = tonumber(tostring(assetId):match("%d+")) or assetId
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if not handle then
tool:SetAttribute("Hub073Applying", nil)
return false
end
local success = false
pcall(function()
clearGearVisual(tool)
if tool:GetAttribute("Hub073OrigHandleTrans") == nil then
tool:SetAttribute("Hub073OrigHandleTrans", handle.Transparency)
end
local objs = loadAssetObjects(assetId)
if not objs or #objs == 0 then return end
local folder = Instance.new("Folder")
folder.Name = "Hub073GearVisual"
folder.Parent = tool
local srcTool, srcHandle
for _, o in ipairs(objs) do
if o:IsA("Tool") then
srcTool = o
srcHandle = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
break
end
local t = o:FindFirstChildOfClass("Tool") or o:FindFirstChildWhichIsA("Tool", true)
if t then
srcTool = t
srcHandle = t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart")
break
end
end
if not srcHandle then
for _, o in ipairs(objs) do
if o:IsA("BasePart") then srcHandle = o; break end
local p = o:FindFirstChildWhichIsA("BasePart", true)
if p then srcHandle = p; break end
end
end
local skinConfig = tool.Name == "Bat" and getBatSkinConfig(assetId) or nil
local orientFix = skinConfig and skinConfig.c0 or CFrame.new()
local parts = {}
local root = srcTool or objs[1]
if root then
if root:IsA("BasePart") then table.insert(parts, root) end
if root:IsA("Accessory") then
local ah = root:FindFirstChild("Handle")
if ah then table.insert(parts, ah) end
end
for _, d in ipairs(root:GetDescendants()) do
if d:IsA("BasePart") then table.insert(parts, d) end
end
end
if #parts == 0 and srcHandle then
table.insert(parts, srcHandle)
end
local seen = {}
local unique = {}
for _, p in ipairs(parts) do
if not seen[p] then
seen[p] = true
table.insert(unique, p)
end
end
parts = unique
if #parts > 0 then
handle.Transparency = 1
local pivot = srcHandle or parts[1]
for _, src in ipairs(parts) do
local okc, clone = pcall(function() return src:Clone() end)
if okc and clone then
clone.Name = "GV_" .. tostring(src.Name)
clone.Anchored = false
clone.CanCollide = false
clone.Massless = true
pcall(function()
clone.CanQuery = false
clone.CanTouch = false
end)
local rel = pivot.CFrame:ToObjectSpace(src.CFrame)
clone.CFrame = handle.CFrame * orientFix * rel
clone.Parent = folder
local w = Instance.new("Weld")
w.Name = "Hub073GearWeld"
w.Part0 = handle
w.Part1 = clone
w.C0 = orientFix * rel
w.C1 = CFrame.new()
w.Parent = clone
success = true
end
end
elseif srcHandle then
local mesh = srcHandle:FindFirstChildOfClass("SpecialMesh")
if mesh then
local m = mesh:Clone()
m.Name = "Hub073GearMesh"
m:SetAttribute("Hub073", true)
m.Parent = handle
success = true
end
for _, d in ipairs(srcHandle:GetChildren()) do
if d:IsA("Decal") or d:IsA("Texture") then
pcall(function() d:Clone().Parent = handle end)
end
end
pcall(function()
handle.Color = srcHandle.Color
handle.Material = srcHandle.Material
handle.Reflectance = srcHandle.Reflectance
end)
end
for _, o in ipairs(objs) do
pcall(function() o:Destroy() end)
end
end)
tool:SetAttribute("Hub073Applying", nil)
if success and tool.Name == "Bat" then setBatSkinSound(tool, assetId) end
return success
end
local function makeSkinBtn(parent, item, category)
local row = mkRow(parent, 34)
local lbl = Instance.new("TextLabel", row)
lbl.Size = UDim2.new(1, -90, 1, 0)
lbl.Position = UDim2.new(0, 12, 0, 0)
lbl.BackgroundTransparency = 1
lbl.Text = item.name
lbl.TextColor3 = COLORS.white
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 11
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.ZIndex = 5
local applyBtn = Instance.new("TextButton", row)
applyBtn.Size = UDim2.new(0, 70, 0, 24)
applyBtn.Position = UDim2.new(1, -80, 0.5, -12)
applyBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
applyBtn.BorderSizePixel = 0
applyBtn.Text = "APPLY"
applyBtn.TextColor3 = (COLORS.accentStrong or COLORS.white)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 11
applyBtn.ZIndex = 6
applyBtn.AutoButtonColor = true
corner(applyBtn, 7)
stroke(applyBtn, COLORS.stroke, 1, 0.55)
applyBtn.MouseButton1Click:Connect(function()
if S._anyKeyListening then return end
applyBtn.Text = "..."
local ok = false
pcall(function()
local tool = nil
if category == "medusa" then
tool = getMedusaTool()
else
tool = getBatTool()
end
if tool then
ok = applyAssetToTool(tool, item.id)
end
end)
if ok then
if category == "medusa" then S.savedMedusaSkin = item.id else S.savedBatSkin = item.id end
pcall(function() if F.saveConfig then F.saveConfig(true) end end)
end
applyBtn.Text = ok and "OK" or "FAIL"
task.delay(1.2, function()
if applyBtn and applyBtn.Parent then applyBtn.Text = "APPLY" end
end)
end)
return row
end
lo = 0
section(pageSKINS, "Medusa")
for _, item in ipairs(SKIN_MEDUSA) do
makeSkinBtn(pageSKINS, item, "medusa")
end
section(pageSKINS, "Bat")
for _, item in ipairs(SKIN_BAT) do
makeSkinBtn(pageSKINS, item, "bat")
end
section(pageSKINS, "Color")
VS.setRainbowToolsVisual = mkToggle(pageSKINS, "Bat & Medusa Colorido", function(on)
    S.rainbowToolsEnabled = on
    pcall(function() RainbowTools.setEnabled(on) end)
    pcall(function() if F.saveConfig then F.saveConfig(true) end end)
end)
if S.rainbowToolsEnabled then
    pcall(function() VS.setRainbowToolsVisual(true) end)
    pcall(function() RainbowTools.setEnabled(true) end)
end


-- =====================================================================
-- ANTI LAG ULTRA
-- =====================================================================
local _alSaved = setmetatable({}, { __mode = "k" })
local _alDetached = {}
local _alAnimators = setmetatable({}, { __mode = "k" })
local _alStoppedTracks = setmetatable({}, { __mode = "k" })
local _alGeneration = 0
local _alScanCancel = nil
local _alConns = {}
local _alLightOrig = nil
local _alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

local function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

local function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

local function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

local function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

local function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^Yout") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function applyAntiLagDerender(obj)
    pcall(function()
        if not _alRunning then return end
        if _alIsProtectedVisual(obj) then return end

        if obj:IsA("Terrain") then
            _alChange(obj, "Decoration", false)
            _alChange(obj, "WaterWaveSize", 0)
            _alChange(obj, "WaterWaveSpeed", 0)
            _alChange(obj, "WaterReflectance", 0)
            _alChange(obj, "WaterTransparency", 1)
        end
        if obj:IsA("BasePart") then
            _alChange(obj, "Material", Enum.Material.Plastic)
            _alChange(obj, "MaterialVariant", "")
            _alChange(obj, "Reflectance", 0)
            _alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                _alChange(obj, "TextureID", "")
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                _alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            _alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            _alDetached[obj] = true
            _alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            _alChange(obj, "Transparency", 1)
            _alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            _alChange(obj, "Enabled", false)
            _alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            _alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            _alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            _alChange(obj, "Density", 0)
            _alChange(obj, "Haze", 0)
            _alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                _alChange(obj, face, "")
            end
            _alChange(obj, "StarCount", 0)
            _alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            _alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            _alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            _alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not _alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    _alAnimators[obj] = true
                    local token = _alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not _alRunning or _alGeneration ~= token then return end
                            task.defer(function()
                                if _alRunning and _alGeneration == token then
                                    pcall(function() track:Stop(0) end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(_alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                _alStoppedTracks[track] = {
                                    animator = obj,
                                    time = track.TimePosition,
                                    speed = track.Speed,
                                }
                                track:Stop(0)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

function enableAntiLag()
    if _alRunning then return end
    _alRunning = true
    antiLagEnabled = true
    _alGeneration = _alGeneration + 1
    local token = _alGeneration

    _alSaveLighting()
    _alApplyLowFlags()
    _alApplyLowPermanentSettings()

    for _, delaySeconds in ipairs({2, 6, 12, 20}) do
        task.delay(delaySeconds, function()
            if _alRunning and _alGeneration == token then
                _alApplyLowFlags()
            end
        end)
    end

    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

    table.insert(_alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(_alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))

    local function walkBatched(roots, apply, shouldContinue)
        task.spawn(function()
            local pending = {}
            for _, root in ipairs(roots) do
                if root then
                    local ok, children = pcall(function() return root:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
            end
            while #pending > 0 and _alRunning and _alGeneration == token and shouldContinue() do
                local deadline = os.clock() + 0.0008
                while #pending > 0 and os.clock() < deadline do
                    local obj = table.remove(pending)
                    pcall(apply, obj)
                    local ok, children = pcall(function() return obj:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    walkBatched({workspace, Lighting}, applyAntiLagDerender, function()
        return _alRunning and _alGeneration == token
    end)
end

function disableAntiLag()
    if not _alRunning then
        antiLagEnabled = false
        return
    end
    _alRunning = false
    antiLagEnabled = false
    _alGeneration = _alGeneration + 1

    if _alScanCancel then pcall(_alScanCancel); _alScanCancel = nil end

    for _, conn in ipairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}

    for object, properties in pairs(_alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    _alSaved = setmetatable({}, { __mode = "k" })
    _alDetached = {}
    _alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(_alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    _alStoppedTracks = setmetatable({}, { __mode = "k" })

    if _alLightOrig then
        pcall(function()
            Lighting.Brightness = _alLightOrig.Brightness
            Lighting.ClockTime = _alLightOrig.ClockTime
            Lighting.OutdoorAmbient = _alLightOrig.OutdoorAmbient
            Lighting.Ambient = _alLightOrig.Ambient
            Lighting.GlobalShadows = _alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = _alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = _alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = _alLightOrig.FogStart
            Lighting.FogEnd = _alLightOrig.FogEnd
        end)
    end
end


-- ===================== BLEED SKINS (073 SYSTEM) =====================
local BLEED_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
        thumbId = 306969564,
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
        thumbId = 1744060292,
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
        thumbId = 112564966849233,
    },
    ["Bleed 4"] = {
        accessory = 10159600649,
        offset = Vector3.new(0, 1, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        thumbId = 10159600649,
    },
    ["Bleed 5"] = {
        accessory = 8349240186,
        offset = Vector3.new(0, 0.9, 0),
        headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747",
        shirt = "http://www.roblox.com/asset/?id=11926549070",
        pants = "http://www.roblox.com/asset/?id=13189494471",
        thumbId = 8349240186,
    },
    ["Bleed 6"] = {
        accessory = 121097973925756,
        offset = Vector3.new(0, 0.9, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=123181702116947",
        pants = "http://www.roblox.com/asset/?id=93330291631062",
        thumbId = 121097973925756,
    },
    ["Bleed 7"] = {
        custom = "homero",
        thumbId = 103227869700418,
    },
}

local _accOriginalOutfit = { shirt = nil, pants = nil }
local _accOriginalAccessories = {}
local activeBleedPack = "Off"

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    _accOriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    _accOriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
    if _accOriginalOutfit.shirt then
        local s = Instance.new("Shirt"); s.ShirtTemplate = _accOriginalOutfit.shirt; s.Parent = char
    end
    if _accOriginalOutfit.pants then
        local p = Instance.new("Pants"); p.PantsTemplate = _accOriginalOutfit.pants; p.Parent = char
    end
end

local function saveOriginalAccessories(char)
    _accOriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            table.insert(_accOriginalAccessories, child:Clone())
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "073Accessory" then
            child:Destroy()
        end
    end
    for _, clone in ipairs(_accOriginalAccessories) do
        if clone and clone.Parent == nil then
            local newAcc = clone:Clone()
            newAcc.Parent = char
        end
    end
end

local function clearAllPack(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "073Accessory" then
            child:Destroy()
        end
        if tostring(child.Name):find("Korblox_") or tostring(child.Name):find("Headless_") then
            child:Destroy()
        end
    end
    for _, partName in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
end

local function applyBleed(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end
    local char = LP.Character
    if not char then return false end
    if config.custom == "homero" then
        local ok = pcall(function() applyHomeroOutfit(char) end)
        return ok
    end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 8)
    if not head then return false end

    if config.headMesh then
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh
            sm.TextureId = config.headTexture or ""
        end
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("073Accessory")
        if old then old:Destroy() end
        local objs = loadAssetObjects(config.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "073Accessory"
                h.CanCollide = false; h.Anchored = false; h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox == "right" or config.korblox == "left" then
        local side = config.korblox
        local ids = { left = 139607673, right = 139607718 }
        local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
        local hides = {
            left = {"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
            right = {"RightUpperLeg","RightLowerLeg","RightFoot"},
        }
        local targetPart = char:FindFirstChild(targets[side])
        if targetPart then
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local objects = loadAssetObjects(ids[side])
            if objects and #objects > 0 then
                local assetModel = objects[1]
                local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
                if mainMesh then
                    mainMesh.Name = "Korblox_" .. side
                    mainMesh.CanCollide = false; mainMesh.Massless = true
                    mainMesh.CFrame = targetPart.CFrame
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
                    assetModel.Parent = char
                end
            end
        end
    end
    return true
end

local function applyPack(packName)
    local char = LP.Character
    if not char then return end
    if packName == "Off" or not packName then
        if activeBleedPack == "Bleed 7" then
            pcall(function() if YoutSetOutfitIndex then YoutSetOutfitIndex(1) end end)
        end
        clearAllPack(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        activeBleedPack = "Off"
        return
    end
    if not _accOriginalOutfit.shirt and not _accOriginalOutfit.pants then
        saveOriginalOutfit(char)
    end
    if #_accOriginalAccessories == 0 then
        saveOriginalAccessories(char)
    end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
    clearAllPack(char)
    if applyBleed(packName) then
        activeBleedPack = packName
    end
end

local stopVX7OutfitForBleed
local function togglePack(packName)
    if stopVX7OutfitForBleed then stopVX7OutfitForBleed() end
    if activeBleedPack == packName then
        applyPack("Off")
    else
        applyPack(packName)
    end
    S.savedBleedPack = activeBleedPack
    pcall(function() if F.saveConfig then F.saveConfig(true) end end)
end

-- Reaplicar skin apos respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    if activeBleedPack and activeBleedPack ~= "Off" then
        applyPack(activeBleedPack)
    end
end)


-- VX7 outfit engine (the outfit entries only; Katana and Custom are excluded)
local function createVX7OutfitEngine()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "ALIEN",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "OUTFIT",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "OUTFIT 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "OUTFIT 3",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "OUTFIT 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "OUTFIT 5",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "OUTFIT 6",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "VX7",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "NEW SKIN",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
-- Skin Changer catalog imported from Zurich; these entries remain local-only.
{label = "ZURICH THEME", skinChanger = true, shirtId = 9733132546, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "BLACK / BLUE", skinChanger = true, shirtId = 9733132546, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "BLACK / RED", skinChanger = true, shirtId = 10796276786, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "BLACK / WHITE", skinChanger = true, shirtId = 8844377623, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "WHITE / BLUE", skinChanger = true, shirtId = 16107371158, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "WHITE / RED", skinChanger = true, shirtId = 15970848598, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "WHITE / BLACK", skinChanger = true, shirtId = 8844377623, pantsId = 101481154733615,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111149505826763}},
{label = "GATO MEME", skinChanger = true, shirtId = 130666125397672, pantsId = 91321960147976,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {111553288808103, 17274218093, 17387240647}},
{label = "BATMAN", skinChanger = true, shirtId = 77038549270215, pantsId = 16717004839,
 torsoMeshId = "http://www.roblox.com/asset/?id=1660648364", skinAccessories = {127788745429250, 143803235928952}},
{label = "MONSTER KORBLOX", skinChanger = true, shirtId = 7884186381, pantsId = 13063157758,
 headless = true, korblox = true, skinAccessories = {8261840689}},
{label = "HORNED KORBLOX", skinChanger = true, shirtId = 9683332649, pantsId = 13063157758,
 headless = true, korblox = true, skinAccessories = {91950080535908, 96954292222783, 17309352545, 132404403424262}},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
local originalHandleFrame = handle.CFrame
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
local stacked = countStackedAccessories(character, sourceAttachment.Name)
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = targetPart.CFrame
end
-- Loaded multi-part accessories can start far from their handles. Moving only
-- the handle makes their internal joints fight the character weld and shake.
local move = handle.CFrame * originalHandleFrame:Inverse()
for _, part in ipairs(accessory:GetDescendants()) do
if part:IsA("BasePart") and part ~= handle then
part.CFrame = move * part.CFrame
end
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="vx7/Vx7SkinPreviewAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local skinTemplateCache = {}
local function resolveSkinTemplate(assetId, className, propertyName)
local key = className .. ":" .. tostring(assetId)
if skinTemplateCache[key] then return skinTemplateCache[key] end
local template = "rbxassetid://" .. tostring(assetId)
local roots = loadAssetObjects(assetId)
if roots then
for _, root in ipairs(roots) do
local clothing = root:IsA(className) and root or root:FindFirstChildWhichIsA(className, true)
if clothing and clothing[propertyName] ~= "" then template = clothing[propertyName] end
pcall(function() root:Destroy() end)
end
end
skinTemplateCache[key] = template
return template
end
local function applySkinChangerOption(character, humanoid, rootPart, option)
-- Do not call ApplyDescription for skins: changing the live rig while it moves
-- conflicts with character physics and makes the visuals visibly tremble.
local loaded = 0
for _, pair in ipairs({{"Shirt", "ShirtTemplate", option.shirtId}, {"Pants", "PantsTemplate", option.pantsId}}) do
local garment = Instance.new(pair[1])
garment.Name = "VX7_LocalSkin_" .. pair[1]
garment:SetAttribute("VX7LocalOnly", true)
garment[pair[2]] = resolveSkinTemplate(pair[3], pair[1], pair[2])
garment.Parent = character
table.insert(state.visuals, garment)
end
for _, assetId in ipairs(option.skinAccessories or {}) do
local roots = loadAssetObjects(assetId)
if roots then
for _, root in ipairs(roots) do
local accessory = root:IsA("Accessory") and root or root:FindFirstChildWhichIsA("Accessory", true)
if accessory then
local clone = accessory:Clone()
local ok, attached = pcall(attachAccessoryLocal, clone, character, rootPart, assetId)
if ok and attached then loaded = loaded + 1 else clone:Destroy() end
end
pcall(function() root:Destroy() end)
end
end
end
if option.torsoMeshId and humanoid.RigType == Enum.HumanoidRigType.R6 then
local torso = character:FindFirstChild("Torso")
if torso then
local mesh = Instance.new("SpecialMesh")
mesh.Name = "VX7_LocalTorsoMesh"
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = option.torsoMeshId
mesh.Parent = torso
table.insert(state.visuals, mesh)
end
end
if option.korblox then
local leg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
if leg and leg:IsA("BasePart") then
local visual = Instance.new("Part")
visual.Name = "VX7_LocalKorbloxLeg"
visual:SetAttribute("VX7LocalOnly", true)
visual.Size = Vector3.new(1, 2, 1)
visual.CanCollide = false
visual.CanTouch = false
visual.CanQuery = false
visual.Massless = true
visual.CFrame = leg.CFrame * CFrame.new(0, -0.8, 0)
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://101851696"
mesh.TextureId = "rbxassetid://101851254"
mesh.Parent = visual
visual.Parent = character
weldPart(visual, leg)
table.insert(state.visuals, visual)
end
end
state.enabled = true
hideOriginalWearables(character, true)
if option.headless or option.korblox then
-- Hide only the matching limb; leave the actual rig and its joints untouched.
enforceHeadless(character, {headless = option.headless, hideRightLeg = option.korblox})
end
setStatus(option.label .. " applied - " .. tostring(loaded) .. " accessories", true)
return true
end
local function applyOutfit()
state.enabled = false
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
-- If the previous outfit changed the actual avatar, restore its original rig
-- before putting a local-only skin on top of it.
if option.skinChanger and state.originalDescription and state.descriptionCharacter == character
and not state.skipDescriptionRestore then
local original = state.originalDescription:Clone()
pcall(function() humanoid:ApplyDescription(original) end)
original:Destroy()
end
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true or option.skinChanger==true
if option.skinChanger then
return applySkinChangerOption(character, humanoid, rootPart, option)
end
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
local option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character
if not option or not character then return nil end
local oldArchivable=character.Archivable; character.Archivable=true; local ok,clone=pcall(function() return character:Clone() end); character.Archivable=oldArchivable
if not ok or not clone then return nil end
for _,child in ipairs(clone:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end
local root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")
if not root then clone:Destroy(); return nil end
local savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil
local ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end
if option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end
for _,id in ipairs(ids) do
local objects=loadAssetObjects(id)
if objects then for _,loadedRoot in ipairs(objects) do
pcall(attachClassicClothingLocal,loadedRoot,clone,id)
local accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end
for _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end
local isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head
if isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end
if loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end
end end
end
state.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable
if option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end
if option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end
if option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end
return clone
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}

end
local vx7OutfitEngine = createVX7OutfitEngine()
local activeVX7Outfit = 0

-- UI dos cards de SKINS (Bleed 1..7)
section(pageSKINS, "Skins")

local bleedContainer = mkRow(pageSKINS, 176)
bleedContainer.BackgroundTransparency = 1

local bleedPacks = {
    { name = "BLEED 1", pack = "Bleed 1", id = 306969564 },
    { name = "BLEED 2", pack = "Bleed 2", id = 1744060292 },
    { name = "BLEED 3", pack = "Bleed 3", id = 112564966849233 },
    { name = "BLEED 4", pack = "Bleed 4", id = 10159600649 },
    { name = "BLEED 5", pack = "Bleed 5", id = 8349240186 },
    { name = "BLEED 7", pack = "Bleed 7", id = 103227869700418 },
}

local bleedButtons = {}
local function refreshBleedCards()
    for _, b in ipairs(bleedButtons) do
        local on = (activeBleedPack == b.pack)
        if b.st then
            b.st.Color = on and (COLORS.accentStrong or Color3.fromRGB(120, 20, 220)) or COLORS.stroke
            b.st.Transparency = on and 0.1 or 0.6
        end
        b.btn.BackgroundColor3 = on and Color3.fromRGB(28, 28, 34) or Color3.fromRGB(16, 16, 18)
    end
end

for i, info in ipairs(bleedPacks) do
    local col = (i - 1) % 4
    local rowIdx = math.floor((i - 1) / 4)
    local card = Instance.new("TextButton", bleedContainer)
    card.Size = UDim2.new(0, 80, 0, 76)
    card.Position = UDim2.new(0, 10 + col * 88, 0, 4 + rowIdx * 84)
    card.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
    card.BorderSizePixel = 0
    card.Text = ""
    card.ZIndex = 6
    corner(card, 8)
    local st = stroke(card, COLORS.stroke, 1, 0.6)

    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(1, -8, 0, 48)
    img.Position = UDim2.new(0, 4, 0, 4)
    img.BackgroundTransparency = 1
    img.Image = "rbxthumb://type=Asset&id=" .. tostring(info.id) .. "&w=150&h=150"
    img.ScaleType = Enum.ScaleType.Fit
    img.ZIndex = 7

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -4, 0, 16)
    lbl.Position = UDim2.new(0, 2, 1, -18)
    lbl.BackgroundTransparency = 1
    lbl.Text = info.name
    lbl.TextColor3 = COLORS.white
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.ZIndex = 7

    card.MouseButton1Click:Connect(function()
        if S._anyKeyListening then return end
        togglePack(info.pack)
        refreshBleedCards()
    end)

    table.insert(bleedButtons, { btn = card, st = st, pack = info.pack })
end

refreshBleedCards()

-- Outfits from source 2: first two choices (Katana and Custom) intentionally omitted.
section(pageSKINS, "Outfits")
local vx7OutfitCards = {
    {name = "ALIEN", id = 10997283529},
    {name = "OUTFIT 1", id = 125157548394108},
    {name = "OUTFIT 2", id = 136644276218918},
    {name = "OUTFIT 3", id = 119331031817124},
    {name = "OUTFIT 4", id = 18902416696},
    {name = "OUTFIT 5", id = 13935333090},
    {name = "OUTFIT 6", id = 91274263831244},
    {name = "VX7", id = 76479271580913},
    {name = "NEW SKIN", id = 82277826177074},
}
local skinChangerCards = {
    {name = "ZURICH THEME", id = 9733132546},
    {name = "BLACK / BLUE", id = 9733132546},
    {name = "BLACK / RED", id = 10796276786},
    {name = "BLACK / WHITE", id = 8844377623},
    {name = "WHITE / BLUE", id = 16107371158},
    {name = "WHITE / RED", id = 15970848598},
    {name = "WHITE / BLACK", id = 8844377623},
    {name = "GATO MEME", id = 130666125397672},
    {name = "BATMAN", id = 77038549270215},
    {name = "MONSTER KORBLOX", id = 8261840689},
    {name = "HORNED KORBLOX", id = 91950080535908},
}
for _, entry in ipairs(skinChangerCards) do table.insert(vx7OutfitCards, entry) end
local vx7OutfitContainer = mkRow(pageSKINS, 500)
vx7OutfitContainer.BackgroundTransparency = 1
local vx7OutfitButtons = {}
local function refreshVX7OutfitCards()
    for _, entry in ipairs(vx7OutfitButtons) do
        local selected = activeVX7Outfit == entry.index
        entry.stroke.Color = selected and COLORS.accentStrong or COLORS.stroke
        entry.stroke.Transparency = selected and 0.1 or 0.6
        entry.button.BackgroundColor3 = selected and COLORS.row2 or COLORS.row
    end
end
local function selectVX7Outfit(index)
    if activeVX7Outfit == index then
        vx7OutfitEngine.remove()
        activeVX7Outfit = 0
    else
        -- Both outfit systems alter the character; restore the existing one first.
        if activeBleedPack ~= "Off" then
            applyPack("Off")
            S.savedBleedPack = "Off"
            refreshBleedCards()
        end
        local ok, applied = pcall(vx7OutfitEngine.apply, index)
        if not ok or not applied then return end
        activeVX7Outfit = index
    end
    S.savedVX7Outfit = activeVX7Outfit
    refreshVX7OutfitCards()
    pcall(function() F.saveConfig(true) end)
end
for i, info in ipairs(vx7OutfitCards) do
    local col = (i - 1) % 4
    local rowIndex = math.floor((i - 1) / 4)
    local card = Instance.new("TextButton", vx7OutfitContainer)
    card.Size = UDim2.new(0, 80, 0, 76)
    card.Position = UDim2.new(0, 10 + col * 88, 0, 4 + rowIndex * 84)
    card.BackgroundColor3 = COLORS.row
    card.BorderSizePixel = 0
    card.Text = ""
    card.ZIndex = 6
    corner(card, 8)
    local outline = stroke(card, COLORS.stroke, 1, 0.6)
    local image = Instance.new("ImageLabel", card)
    image.Size = UDim2.new(1, -8, 0, 48)
    image.Position = UDim2.new(0, 4, 0, 4)
    image.BackgroundTransparency = 1
    image.Image = "rbxthumb://type=Asset&id=" .. tostring(info.id) .. "&w=150&h=150"
    image.ScaleType = Enum.ScaleType.Fit
    image.ZIndex = 7
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(1, -4, 0, 16)
    label.Position = UDim2.new(0, 2, 1, -18)
    label.BackgroundTransparency = 1
    label.Text = info.name
    label.TextColor3 = COLORS.white
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.ZIndex = 7
    card.Activated:Connect(function()
        if S._anyKeyListening then return end
        selectVX7Outfit(i)
    end)
    table.insert(vx7OutfitButtons, {button = card, stroke = outline, index = i})
end
refreshVX7OutfitCards()
stopVX7OutfitForBleed = function()
    if activeVX7Outfit == 0 then return end
    vx7OutfitEngine.remove()
    activeVX7Outfit = 0
    S.savedVX7Outfit = 0
    refreshVX7OutfitCards()
end
LP.CharacterAdded:Connect(function(character)
    if activeVX7Outfit == 0 then return end
    task.spawn(function()
        character:WaitForChild("Humanoid", 8)
        task.wait(0.8)
        if activeVX7Outfit > 0 and LP.Character == character then
            pcall(vx7OutfitEngine.apply, activeVX7Outfit)
        end
    end)
end)

-- ===================== AUTO SAVE / AUTO APPLY SKINS =====================
local _skinRestoreRunning = false
local function applySavedSkins()
    if _skinRestoreRunning then return end
    _skinRestoreRunning = true
    task.spawn(function()
        local deadline = os.clock() + 30
        local batDone = (S.savedBatSkin == nil)
        local medDone = (S.savedMedusaSkin == nil)
        while os.clock() < deadline and not (batDone and medDone) do
            if not batDone then
                local t = getBatTool()
                if t then batDone = applyAssetToTool(t, S.savedBatSkin) == true end
            end
            if not medDone then
                local t = getMedusaTool()
                if t then medDone = applyAssetToTool(t, S.savedMedusaSkin) == true end
            end
            task.wait(0.6)
        end
        _skinRestoreRunning = false
    end)
    if activeVX7Outfit == 0 and tonumber(S.savedVX7Outfit) and tonumber(S.savedVX7Outfit) > 0 then
        local index = math.floor(tonumber(S.savedVX7Outfit))
        if index >= 1 and index <= #vx7OutfitCards then
            task.spawn(function()
                task.wait(0.8)
                if activeVX7Outfit == 0 then
                    local ok, applied = pcall(vx7OutfitEngine.apply, index)
                    if ok and applied then activeVX7Outfit = index; refreshVX7OutfitCards() end
                end
            end)
        end
    end
    if S.savedBleedPack == "Bleed 6" then S.savedBleedPack = "Off" end
    if S.savedBleedPack and S.savedBleedPack ~= "Off" and (S.savedVX7Outfit or 0) == 0 then
        task.spawn(function()
            task.wait(0.8)
            pcall(function()
                applyPack(S.savedBleedPack)
                refreshBleedCards()
            end)
        end)
    end
end
_G.__PVSApplySavedSkins = applySavedSkins
task.spawn(function()
    task.wait(2.5)
    applySavedSkins()
end)
LP.CharacterAdded:Connect(function()
    task.wait(1.4)
    applySavedSkins()
end)
end
UIS.InputBegan:Connect(function(input, gpe) if S._anyKeyListening then return end if input.UserInputType == Enum.UserInputType.Keyboard then
if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end if not isBindableInput(input) then return end local kc = input.KeyCode if kbMatch(KB.LaggerToggle, kc) then F.toggleLaggerMode(); F.saveConfig() elseif kbMatch(KB.SpeedToggle, kc) then F.toggleCarryMode(); F.saveConfig() elseif kbMatch(KB.DropBrainrot, kc) then F.runDrop() elseif kbMatch(KB.TPFloor, kc) then F.runTPFloor() elseif kbMatch(KB.InstaReset, kc) then if F.doInstaReset then F.doInstaReset() end elseif kbMatch(KB.AutoLeft, kc) then S.autoLeftEnabled = not S.autoLeftEnabled
if S.autoLeftEnabled then F.queueAutoLeftStart() else F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end elseif kbMatch(KB.AutoRight, kc) then S.autoRightEnabled = not S.autoRightEnabled if S.autoRightEnabled then F.queueAutoRightStart() else F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end elseif kbMatch(KB.AutoBat, kc) then if not S.autoBatEnabled then F.queueAutoBatStart() if S.autoBatSetVisual then S.autoBatSetVisual(true) end else S.autoBatEnabled = false; S.disableAutoBat()
if S.autoBatSetVisual then S.autoBatSetVisual(false) end end elseif kbMatch(KB.BatV2, kc) then if F.toggleAimbotBatV2 then F.toggleAimbotBatV2() end elseif kbMatch(KB.AimbotV2, kc) then if F.toggleAimbotV2 then F.toggleAimbotV2() end elseif kbMatch(KB.TPBat, kc) then setTPBatState(not tpBatEnabled) elseif kbMatch(KB.GuiHide, kc) then if main.Visible then hideGui() else showGui() end end end) do local ibGui = Instance.new("ScreenGui"); ibGui.Name = "PrimeVSInfoBar"; ibGui.ResetOnSpawn = false; ibGui.IgnoreGuiInset = true; ibGui.DisplayOrder = 12
local okp = pcall(function() if gethui then ibGui.Parent = gethui() end end)
if not ibGui.Parent then pcall(function() ibGui.Parent = game:GetService("CoreGui") end) end
if not ibGui.Parent then ibGui.Parent = LP:WaitForChild("PlayerGui") end
local IB_BG = Color3.fromRGB(8, 8, 10)
local IB_BORDER = Color3.fromRGB(255, 255, 255)
local IB_TRACK = Color3.fromRGB(24, 24, 28)
local infoBar = Instance.new("Frame", ibGui)
infoBar.Name = "StealBar"
infoBar.Size = UDim2.new(0, 420, 0, 72)
infoBar.Position = UDim2.new(0.5, -210, 1, -88)
do local sp = S.stealBarPos if type(sp) == "table" and tonumber(sp.xs) and tonumber(sp.ys) then infoBar.Position = UDim2.new(tonumber(sp.xs), tonumber(sp.xo) or 0, tonumber(sp.ys), tonumber(sp.yo) or 0) end end
infoBar.BackgroundColor3 = IB_BG
infoBar.BackgroundTransparency = 0.12
infoBar.BorderSizePixel = 0
infoBar.Active = true
infoBar.Visible = false
corner(infoBar, 14)
stroke(infoBar, IB_BORDER, 1.2, 0.55)
local glow = Instance.new("Frame", infoBar)
glow.Size = UDim2.new(1, 8, 1, 8)
glow.Position = UDim2.new(0, -4, 0, -4)
glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glow.BackgroundTransparency = 0.92
glow.BorderSizePixel = 0
glow.ZIndex = 0
corner(glow, 16)
local ibBg = Instance.new("ImageLabel", infoBar)
ibBg.Name = "StealBarBg"
ibBg.Size = UDim2.new(1, 0, 1, 0)
ibBg.BackgroundTransparency = 1
ibBg.Image = "rbxassetid://76591851053639"
ibBg.ImageTransparency = 0.7
ibBg.ScaleType = Enum.ScaleType.Crop
ibBg.ZIndex = 1
corner(ibBg, 14)
do local pbScale = Instance.new("UIScale", infoBar); pbScale.Name = "PBScale"; _G.__VersincProgressBarScaleObj = pbScale
if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) else pbScale.Scale = ((tonumber(S.progressBarScale) or 100) / 100) end end
do local avRing = Instance.new("Frame", infoBar)
avRing.Size = UDim2.new(0, 44, 0, 44)
avRing.Position = UDim2.new(0, 10, 0.5, -22)
avRing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
avRing.BorderSizePixel = 0
avRing.ZIndex = 3
corner(avRing, 22)
local avInner = Instance.new("Frame", avRing)
avInner.Size = UDim2.new(1, -4, 1, -4)
avInner.Position = UDim2.new(0, 2, 0, 2)
avInner.BackgroundColor3 = IB_BG
avInner.BorderSizePixel = 0
avInner.ZIndex = 4
corner(avInner, 20)
local av = Instance.new("ImageLabel", avInner)
av.Size = UDim2.new(1, -2, 1, -2)
av.Position = UDim2.new(0, 1, 0, 1)
av.BackgroundColor3 = IB_BG
av.BorderSizePixel = 0
av.ScaleType = Enum.ScaleType.Crop
av.ZIndex = 5
corner(av, 19)
pcall(function()
    av.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end) end
do local acc = Instance.new("Frame", infoBar)
acc.Size = UDim2.new(0, 3, 0.62, 0)
acc.Position = UDim2.new(0, 0, 0.19, 0)
acc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
acc.BackgroundTransparency = 0.25
acc.BorderSizePixel = 0
acc.ZIndex = 6
corner(acc, 2) end
local function _pingMs() local ms = 0 pcall(function() local Stats = game:GetService("Stats") local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping") if item then local v = item:GetValue()
if type(v) == "number" then ms = math.floor(v + 0.5) elseif type(v) == "string" then ms = math.floor(tonumber((v:match("[%d%.]+")) or 0) + 0.5) end end end) if ms <= 0 then pcall(function() ms = math.floor(((LP:GetNetworkPing() or 0) * 1000) + 0.5) end) end return math.max(0, ms) end
local function _clock() local t = os.date("*t"); local h, ampm = t.hour, "AM" if h >= 12 then ampm = "PM"; if h > 12 then h = h - 12 end end if h == 0 then h = 12 end return string.format("%d:%02d %s", h, t.min, ampm) end
local _execName = nil local function _executor() if _execName then return _execName end
local name pcall(function() if identifyexecutor then local a, b = identifyexecutor(); name = a or b end end) if not name or name == "" then pcall(function() if getexecutorname then name = getexecutorname() end end) end if type(name) ~= "string" or name == "" then name = "Unknown" end name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "") if #name > 12 then name = name:sub(1, 12) end _execName = name return name end
local function _infoText() return "RAD " .. tostring(Steal.StealRadius) .. "  ·  DUR " .. tostring(Steal.StealDuration) .. "s  ·  " .. tostring(_pingMs()) .. "ms  ·  " .. _clock() .. "  ·  " .. _executor() end
progressRadLbl = Instance.new("TextLabel", infoBar)
progressRadLbl.Size = UDim2.new(1, -140, 0, 16)
progressRadLbl.Position = UDim2.new(0, 62, 0, 8)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = _infoText()
progressRadLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
progressRadLbl.Font = Enum.Font.GothamMedium
progressRadLbl.TextSize = 11
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Left
progressRadLbl.TextTruncate = Enum.TextTruncate.AtEnd
progressRadLbl.ZIndex = 5
progressPct = Instance.new("TextLabel", infoBar)
progressPct.Size = UDim2.new(0, 88, 0, 18)
progressPct.Position = UDim2.new(1, -96, 0, 7)
progressPct.BackgroundTransparency = 1
progressPct.Text = "READY"
progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 13
progressPct.TextXAlignment = Enum.TextXAlignment.Right
progressPct.ZIndex = 5
local titleChip = Instance.new("TextLabel", infoBar)
titleChip.Size = UDim2.new(0, 90, 0, 14)
titleChip.Position = UDim2.new(0, 62, 0, 24)
titleChip.BackgroundTransparency = 1
titleChip.Text = "AUTO STEAL"
titleChip.TextColor3 = Color3.fromRGB(220, 220, 230)
titleChip.Font = Enum.Font.GothamBold
titleChip.TextSize = 10
titleChip.TextXAlignment = Enum.TextXAlignment.Left
titleChip.ZIndex = 5
do local pTrack = Instance.new("Frame", infoBar)
pTrack.Name = "Track"
pTrack.Size = UDim2.new(1, -72, 0, 14)
pTrack.Position = UDim2.new(0, 62, 0, 46)
pTrack.BackgroundColor3 = IB_TRACK
pTrack.BorderSizePixel = 0
pTrack.ZIndex = 3
corner(pTrack, 7)
local trackStroke = Instance.new("UIStroke", pTrack)
trackStroke.Color = Color3.fromRGB(50, 50, 58)
trackStroke.Thickness = 1
trackStroke.Transparency = 0.4
progressFill = Instance.new("Frame", pTrack)
progressFill.Name = "Fill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = stealBarColor(0)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 4
corner(progressFill, 7)
local shine = Instance.new("Frame", progressFill)
shine.Size = UDim2.new(1, 0, 0.45, 0)
shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shine.BackgroundTransparency = 0.75
shine.BorderSizePixel = 0
shine.ZIndex = 5
corner(shine, 6)
end
do local dn, ds, sp, moved = false, nil, nil, false
local function persistStealBar()
    local p = infoBar.Position
    S.stealBarPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
    pcall(function() if F.saveConfig then F.saveConfig(true) end end)
end
infoBar.InputBegan:Connect(function(inp)
    if S.guiLocked == true then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dn = true; moved = false; ds = inp.Position; sp = infoBar.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dn = false
                if moved then persistStealBar() end
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dn and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        if S.guiLocked == true then dn = false; return end
        local d = inp.Position - ds
        moved = true
        infoBar.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end) end
task.spawn(function()
    while infoBar and infoBar.Parent do
        task.wait(0.25)
        pcall(function()
            infoBar.Visible = autoStealEnabled == true
            progressRadLbl.Text = _infoText()
        end)
    end
end) end end function F.loadConfigKeys() local raw = nil
if _isfile(CONFIG_FILE) then raw = _readfile(CONFIG_FILE) elseif _isfile(CONFIG_FILE_LEGACY) then raw = _readfile(CONFIG_FILE_LEGACY) end if not raw or raw == "" then return end local ok,cfg=pcall(function() return HS:JSONDecode(raw) end) if not ok or not cfg then return end _savedCfg=cfg S.savedVX7Outfit = tonumber(cfg.vx7Outfit) or 0 local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey); lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.tpBatKey);lk(KB.BatV2,cfg.batV2Key);lk(KB.AimbotV2,cfg.aimbotV2Key);lk(KB.LaggerToggle,cfg.laggerToggleKey); lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey) if cfg.normalSpeed then NS=cfg.normalSpeed end if cfg.carrySpeed then CS=cfg.carrySpeed end if cfg.selectedStealMode == "V1" or cfg.selectedStealMode == "V2" then selectedStealMode = cfg.selectedStealMode else selectedStealMode = "V1" end if YoutSetStealMode then pcall(YoutSetStealMode, selectedStealMode) end if UI and UI.stealModeLbl then UI.stealModeLbl.Text = selectedStealMode end if cfg.youtAntiBat == true and startAntiBat then pcall(startAntiBat) if VS.setYoutAntiBatVisual then pcall(VS.setYoutAntiBatVisual, true) end end if type(cfg.youtOutfitIndex) == "number" and YoutSetOutfitIndex then pcall(YoutSetOutfitIndex, cfg.youtOutfitIndex) if UI and UI.outfitLbl and YoutGetOutfitLabel then UI.outfitLbl.Text = YoutGetOutfitLabel() end end if type(cfg.aceStealRadii)=="table" then
AceStealRadii.Normal = tonumber(cfg.aceStealRadii.Normal) or AceStealRadii.Normal; AceStealRadii.Semi = tonumber(cfg.aceStealRadii.Semi) or AceStealRadii.Semi end if cfg.grabRadius and type(cfg.grabRadius)=="number" then autoStealRadius=cfg.grabRadius; Steal.StealRadius=cfg.grabRadius elseif selectedStealMode=="Semi" then autoStealRadius=AceStealRadii.Semi; Steal.StealRadius=autoStealRadius else autoStealRadius=AceStealRadii.Normal; Steal.StealRadius=autoStealRadius end if cfg.stealDuration and type(cfg.stealDuration)=="number" and cfg.stealDuration >= 0.1 then
Steal.StealDuration = cfg.stealDuration end if cfg.autoGrabStopEnabled ~= nil then autoGrabStopEnabled = cfg.autoGrabStopEnabled == true; Steal.AutoGrabStopEnabled = autoGrabStopEnabled end if cfg.autoGrabStopTime and type(cfg.autoGrabStopTime)=="number" and cfg.autoGrabStopTime > 0 then autoGrabStopTime = cfg.autoGrabStopTime; Steal.AutoGrabStopTime = cfg.autoGrabStopTime end if cfg.autoGrabDelayRadius and type(cfg.autoGrabDelayRadius)=="number" and cfg.autoGrabDelayRadius > 0 then autoGrabDelayRadius = cfg.autoGrabDelayRadius; Steal.AutoGrabDelayRadius = cfg.autoGrabDelayRadius end
Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius or 20 if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then S.LAGGER_SPEED=cfg.laggerSpeed end if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then S.LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then S.autoTPHeight=cfg.autoTPHeight end if cfg.autoSwing~=nil then S.autoSwingEnabled=cfg.autoSwing==true end task.defer(function() if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(0.8) end end) if cfg.autoSaveEnabled ~= nil then S.autoSaveEnabled = cfg.autoSaveEnabled == true else S.autoSaveEnabled = true end if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" and cfg.aimbotSpeed > 0 then AIMBOT_SPEED = cfg.aimbotSpeed end tpBatMode = 1 if KB.TPBat.kb then TP_BAT_KEY = KB.TPBat.kb end if KB.TPBat.gp then TP_BAT_CONTROLLER = KB.TPBat.gp end
if cfg.tpBatLegacyKey and Enum.KeyCode[cfg.tpBatLegacyKey] and not (cfg.tpBatKey and type(cfg.tpBatKey)=="table") then TP_BAT_KEY = Enum.KeyCode[cfg.tpBatLegacyKey]; KB.TPBat.kb = TP_BAT_KEY end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions end if cfg.mobileButtonScale and type(cfg.mobileButtonScale) == "number" then S.mobileButtonScale = cfg.mobileButtonScale end if cfg.hideMobileButtons ~= nil then S.hideMobileButtons = cfg.hideMobileButtons == true end if cfg.allLockButtons ~= nil then
S.allLockButtons = cfg.allLockButtons == true pcall(function() if VS and VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons) end end) end if cfg.lockMobileButtons ~= nil then S.lockMobileButtons = cfg.lockMobileButtons == true end if cfg.moveButtons ~= nil then S.moveButtons = cfg.moveButtons == true end if type(cfg.stealBarPos) == "table" then S.stealBarPos = cfg.stealBarPos end if cfg.progressBarScale ~= nil then S.progressBarScale = math.clamp(tonumber(cfg.progressBarScale) or 100, 50, 200)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale) end end) end end function F.loadConfigState() local cfg=_savedCfg;if not cfg then return end if cfg.bgId ~= nil then S.currentBgId = cfg.bgId or "" task.defer(function() if _G._VersincApplyBackground then _G._VersincApplyBackground(S.currentBgId, true) end end) end if type(cfg.bgIntensity)=="number" then S.bgIntensity = cfg.bgIntensity end if cfg.themeName and type(cfg.themeName)=="string" then S.currentThemeName = cfg.themeName task.defer(function()
if _G._VersincApplyTheme then _G._VersincApplyTheme(cfg.themeName) end end) end if UI.normalBox then UI.normalBox.Text=tostring(NS) end if UI.carryBox then UI.carryBox.Text=tostring(CS) end if UI.radInput then UI.radInput.Text = tostring(autoStealRadius or Steal.StealRadius or 20) end if UI.stealDurInput then UI.stealDurInput.Text = tostring(Steal.StealDuration or 1.3) end if UI.stopTimeInput then UI.stopTimeInput.Text = tostring(autoGrabStopTime or Steal.AutoGrabStopTime or 1.00) end
if UI.delayRadInput then UI.delayRadInput.Text = tostring(autoGrabDelayRadius or Steal.AutoGrabDelayRadius or 8) end if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", autoStealRadius or Steal.StealRadius or 20) end if UI.laggerBox then UI.laggerBox.Text=tostring(S.LAGGER_SPEED) end if UI.laggerCarryBox then UI.laggerCarryBox.Text=tostring(S.LAGGER_CARRY_SPEED) end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text=tostring(S.autoTPHeight) end if VS.setAutoGrabStopVisual then pcall(function() VS.setAutoGrabStopVisual(autoGrabStopEnabled == true) end) end
task.spawn(function() task.wait(0.2) if cfg.antiRagdollMode and type(cfg.antiRagdollMode)=="number" then S.antiRagdollMode = (cfg.antiRagdollMode == 2) and 2 or 1 end if cfg.aimbotMode and type(cfg.aimbotMode)=="number" then S.aimbotMode = (cfg.aimbotMode == 2) and 2 or 1 end pcall(function() if S.refreshAimbotMode then S.refreshAimbotMode() end end) if cfg.youtAntiBat == true then task.spawn(function() task.wait(0.8) pcall(function() if startAntiBat then startAntiBat() end end) pcall(function() if VS and VS.setAntiBatVisual then VS.setAntiBatVisual(true) end end) end) end if cfg.antiRagdoll then S.antiRagdollEnabled=true if VS.setAntiRagVisual then VS.setAntiRagVisual(true) end task.wait(0.3); F.startAntiRagdoll() end if cfg.antiDieEnabled then S.antiDieEnabled = true if VS.setAntiDieVisual then VS.setAntiDieVisual(true) end F.startAntiDie() end if cfg.antiFlingShieldEnabled then
S.antiFlingShieldEnabled = true if VS.setAntiFlingVisual then VS.setAntiFlingVisual(true) end F.startAntiFlingShield() end if cfg.removeAccessories then S.removeAccessoriesEnabled = true if VS.setRemoveAccVisual then VS.setRemoveAccVisual(true) end F.startRemoveAccessories() end if cfg.infJumpMode == "manual" or cfg.infJumpMode == "hold" then S.infJumpMode = cfg.infJumpMode if UI.infJumpModeBtn then UI.infJumpModeBtn.Text = (S.infJumpMode == "manual") and "Manual" or "Hold" end end if cfg.infJump then infJumpEnabled = true if VS.setInfJumpVisual then VS.setInfJumpVisual(true) end
F.startInfJump() end if cfg.mirrorTPDown then F.setMirrorTPDown(true) if VS.setMirrorTPVisual then VS.setMirrorTPVisual(true) end end if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" and cfg.aimbotSpeed > 0 then AIMBOT_SPEED = cfg.aimbotSpeed if UI.aimbotSpeedBox then UI.aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end end if cfg.aimbotV1 == true then S.aimbotMode = 1; if setAimbotState then setAimbotState(true) end elseif cfg.aimbotV2 == true then S.aimbotMode = 2; if setAimbotState then setAimbotState(true) end elseif cfg.aimbot then if setAimbotState then setAimbotState(true) end end if VS.setAimbotVisual then VS.setAimbotVisual(aimbotEnabled or (F.isAimbotV2On and F.isAimbotV2On() == true)) end if cfg.batV2 and F.startAimbotBatV2 then F.startAimbotBatV2() end if false and cfg.antiBatBypass then S.antiBatBypassEnabled = true if F.startAimbotBypassAntiBat then pcall(F.startAimbotBypassAntiBat)
elseif setAimbotState and (S.aimbotMode or 1) == 2 then setAimbotState(true) end if VS.setAntiBatBypassVisual then VS.setAntiBatBypassVisual(true) end if VS.setAimbotVisual and (S.aimbotMode or 1) == 2 then VS.setAimbotVisual(true) end end if cfg.tpBat then if VS.setTPBatVisual then VS.setTPBatVisual(true) end if setTPBatState then setTPBatState(true) end end if tpBatModeLbl then tpBatModeLbl.Text = "V1" end if cfg.autoLeft then task.defer(function() task.wait(0.4)
if F.queueAutoLeftStart then F.queueAutoLeftStart() end if S.autoLeftSetVisual then S.autoLeftSetVisual(true) end end) end if cfg.autoRight then task.defer(function() task.wait(0.45) if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(true) end end) end if cfg.autoStealEnabled then if VS.setInstaGrab then VS.setInstaGrab(true) end pcall(startAutoSteal) end if cfg.medusaCounter then S.medusaCounterEnabled=true;if VS.setMedusaVisual then VS.setMedusaVisual(true) end end if cfg.medusaReset or cfg.autoResetOnMedEnabled then
S.medusaResetEnabled=true; S.autoResetOnMedEnabled=true if VS.setMedusaResetVisual then VS.setMedusaResetVisual(true) end end if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) end if cfg.batCounter then S.batCounterEnabled=true;if VS.setBatCounterVisual then VS.setBatCounterVisual(true) end;S.startBatCounter() end if cfg.laggerMode then S.laggerToggled=true;S.speedMode=false;S.laggerPhase=cfg.laggerCarryMode and 2 or 1;F.refreshSpeedModeLabel() elseif cfg.carryMode then S.speedMode=false;F.toggleCarryMode() end if cfg.autoCarrySpeedEnabled then
S.autoCarrySpeedEnabled = true if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(true) end end if cfg.noPlayerCollisionEnabled then F.enableNoPlayerCollision() if VS.setNoPlayerCollisionVisual then VS.setNoPlayerCollisionVisual(true) end end if cfg.safeModeEnabled then S.safeModeEnabled = true if VS.setSafeModeVisual then VS.setSafeModeVisual(true) end end if cfg.autoTPEnabled then S.autoTPEnabled=true;if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end;F.startAutoTP() end if VS.setAutoSwingVisual then VS.setAutoSwingVisual(S.autoSwingEnabled) end
if cfg.autoBat then S.autoBatEnabled=true;if S.autoBatSetVisual then S.autoBatSetVisual(true) end;F.queueAutoBatStart() end if cfg.unwalkEnabled then S.unwalkEnabled=true;if VS.setUnwalkVisual then VS.setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);F.startUnwalk() end) end if cfg.keyboardOverlay then S.keyboardOverlayEnabled = true if VS.setKeyboardOverlayVisual then VS.setKeyboardOverlayVisual(true) end pcall(function() F.startKeyboardOverlay() end) end if cfg.antiLag then F.enableAntiLag();if VS.setAntiLagVisual then VS.setAntiLagVisual(true) end end
if cfg.stretchRez then enableStretchRez();if VS.setStretchRezVisual then VS.setStretchRezVisual(true) end end if cfg.showTracerEnabled then pcall(function() if F.clearTracers then F.clearTracers() end end) if VS.setShowTracerVisual then VS.setShowTracerVisual(true) end end if cfg.ragdollCountdownEnabled then F.setRagdollCountdown(true) if VS.setRagdollCdVisual then VS.setRagdollCdVisual(true) end end S.guiLocked = cfg.guiLocked and true or false if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end if type(cfg.hubPos) == "table" then S.hubPos = cfg.hubPos end
if type(cfg.miniPos) == "table" then S.miniPos = cfg.miniPos end if (S.hubPos or S.miniPos) and _G._VersincSetHubPos then pcall(function() _G._VersincSetHubPos(S.hubPos, S.miniPos) end) task.defer(function() pcall(function() _G._VersincSetHubPos(S.hubPos, S.miniPos) end) end) end if cfg.lockMobileButtons then S.lockMobileButtons = true if VS.setLockMobileButtonsVisual then VS.setLockMobileButtonsVisual(true) end end if cfg.hideMobileButtons then S.hideMobileButtons = true if VS.setHideMobileVisual then VS.setHideMobileVisual(true) end end if cfg.mobileButtonScale then
S.mobileButtonScale = tonumber(cfg.mobileButtonScale) or 0.80 end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions end if cfg.autoResetOnMedEnabled then F.setAutoResetOnMed(true) if VS.setAutoResetOnMedVisual then VS.setAutoResetOnMedVisual(true) end end if cfg.lineESP or cfg.speedESP then if K7 then K7.lineESPEnabled = true; K7.speedESPEnabled = true end if VS.setLineESPVisual then VS.setLineESPVisual(true) end pcall(function() if K7 and K7.refreshESP then K7.refreshESP() end end) end if cfg.fovEnabled and K7 then
K7.fovEnabled = true if cfg.fovValue then K7.fovValue = tonumber(cfg.fovValue) or K7.fovValue end if VS.setFOVVisual then VS.setFOVVisual(true) end pcall(function() if K7.applyFOV then K7.applyFOV() end end) end if cfg.korbloxSide and type(cfg.korbloxSide)=="number" then korbloxSide = math.clamp(math.floor(cfg.korbloxSide), 1, 3) if K7 then K7.korbloxSide = korbloxSide end end if cfg.headless and K7 then K7.headlessEnabled = true if VS.setHeadlessVisual then VS.setHeadlessVisual(true) end task.spawn(function() local function applyH() local char = LP.Character if char and K7.applyHeadless then
pcall(K7.applyHeadless, char, true) end end task.wait(0.4); applyH(); task.wait(1.0); applyH() end) end if cfg.korblox and K7 then K7.korbloxEnabled = true if VS.setKorbloxVisual then VS.setKorbloxVisual(true) end task.spawn(function() local function applyK() local char = LP.Character if char and K7.applyKorblox then pcall(K7.applyKorblox, char, true) end end task.wait(0.5); applyK(); task.wait(1.2); applyK() end) end if cfg.bodyLock and K7 then K7.bodyLockEnabled = true if cfg.bodyLockRadius then K7.bodyLockRadius = tonumber(cfg.bodyLockRadius) or K7.bodyLockRadius end
if VS.setBodyLockVisual then VS.setBodyLockVisual(true) end pcall(function() if K7.startBodyLock then K7.startBodyLock() end end) end if K7 and cfg.animPack and type(cfg.animPack) == "string" then K7.animPackName = cfg.animPack if K7.ANIM_PACK_LIST then for i, n in ipairs(K7.ANIM_PACK_LIST) do if n == cfg.animPack then K7.animPackIndex = i break end end end if UI.animPackLbl then pcall(function() UI.animPackLbl.Text = K7.animPackName end) end end if cfg.animPackEnabled and K7 then K7.animPackEnabled = true if VS.setAnimPackVisual then VS.setAnimPackVisual(true) end task.spawn(function()
task.wait(0.6) pcall(function() if K7.applyAnimPack then K7.applyAnimPack(K7.animPackName) end end) task.wait(1.2) pcall(function() if K7.animPackEnabled and K7.applyAnimPack then K7.applyAnimPack(K7.animPackName) end end) end) end if cfg.vx7Outfit then S.savedVX7Outfit = tonumber(cfg.vx7Outfit) or 0; if _G.__PVSApplySavedSkins then _G.__PVSApplySavedSkins() end end if cfg.batSkinId then S.savedBatSkin = tonumber(cfg.batSkinId) or cfg.batSkinId end if cfg.medusaSkinId then S.savedMedusaSkin = tonumber(cfg.medusaSkinId) or cfg.medusaSkinId end if type(cfg.bleedPack) == "string" and cfg.bleedPack ~= "Off" and cfg.bleedPack ~= "Bleed 6" then S.savedBleedPack = cfg.bleedPack end if cfg.rainbowTools ~= nil then S.rainbowToolsEnabled = cfg.rainbowTools == true if S.rainbowToolsEnabled then task.spawn(function() task.wait(1.0) pcall(function() if VS and VS.setRainbowToolsVisual then VS.setRainbowToolsVisual(true) end end) pcall(function() if _G.__PVSRainbowTools then _G.__PVSRainbowTools.setEnabled(true) end end) end) end end if S.savedBatSkin or S.savedMedusaSkin or S.savedBleedPack then task.spawn(function() task.wait(0.5) pcall(function() if _G.__PVSApplySavedSkins then _G.__PVSApplySavedSkins() end end) end) end if cfg.noIntro ~= nil then S.noIntroEnabled = cfg.noIntro == true if S.noIntroEnabled then S.introEnabled = false end if VS.setNoIntroVisual then pcall(function() VS.setNoIntroVisual(S.noIntroEnabled) end) end end if cfg.skyTheme and K7 and K7.applySkyTheme then pcall(function() K7.applySkyTheme(cfg.skyTheme) end) end end) end S.introEnabled = S.introEnabled ~= false if S.noIntroEnabled or (_savedCfg and _savedCfg.noIntro == true) then S.noIntroEnabled = true; S.introEnabled = false end function F.playVersicnIntro() if S.introEnabled == false or S.noIntroEnabled == true or (_savedCfg and _savedCfg.noIntro == true) then return end local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5) if not pg then return end
local old = pg:FindFirstChild("VersicnIntro") if old then old:Destroy() end local sg = Instance.new("ScreenGui"); sg.Name = "VersicnIntro"; sg.IgnoreGuiInset = true; sg.DisplayOrder = 9999; sg.ResetOnSpawn = false; sg.Parent = pg; local skipped = false local function skipIntro() if skipped then return end skipped = true; S.introEnabled = false pcall(function() if sg then sg:Destroy() end end) end
local bg = Instance.new("Frame", sg); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(8, 2, 6); bg.BorderSizePixel = 0; local skipBtn = Instance.new("TextButton", bg); skipBtn.Name = "SkipIntro"; skipBtn.AnchorPoint = Vector2.new(1, 0); skipBtn.Position = UDim2.new(1, -16, 0, 16); skipBtn.Size = UDim2.new(0, 88, 0, 32); skipBtn.BackgroundColor3 = Color3.fromRGB(40, 12, 18); skipBtn.BackgroundTransparency = 0.15; skipBtn.BorderSizePixel = 0; skipBtn.Text = "SKIP"; skipBtn.TextColor3 = Color3.fromRGB(255, 180, 80); skipBtn.Font = Enum.Font.GothamBold; skipBtn.TextSize = 13; skipBtn.ZIndex = 20; Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8); local skStroke = Instance.new("UIStroke", skipBtn); skStroke.Color = Color3.fromRGB(255, 120, 40); skStroke.Thickness = 1; skStroke.Transparency = 0.35; skipBtn.Activated:Connect(skipIntro); skipBtn.MouseButton1Click:Connect(skipIntro);
-- Flying pumpkins
local pumpkinIds = {"rbxassetid://11457785", "rbxassetid://133184215", "rbxassetid://18474405"}
for i = 1, 12 do
    local p = Instance.new("ImageLabel", bg)
    p.Name = "Pumpkin" .. i
    p.Size = UDim2.new(0, math.random(48, 90), 0, math.random(48, 90))
    p.Position = UDim2.new(math.random() * 1.1 - 0.05, 0, 1.05 + math.random() * 0.3, 0)
    p.BackgroundTransparency = 1
    p.Image = pumpkinIds[(i % #pumpkinIds) + 1]
    p.ImageColor3 = Color3.fromRGB(255, math.random(140, 200), math.random(20, 80))
    p.ImageTransparency = 0.05
    p.ZIndex = 5
    p.Rotation = math.random(-30, 30)
    local startX = p.Position.X.Scale
    local endY = -0.25 - math.random() * 0.4
    local dur = 2.2 + math.random() * 1.8
    local rotAmt = math.random(-180, 180)
    TS:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(startX + (math.random() - 0.5) * 0.4, 0, endY, 0),
        Rotation = p.Rotation + rotAmt,
        ImageTransparency = 0.7
    }):Play()
end
local title = Instance.new("TextLabel", bg); title.AnchorPoint = Vector2.new(0.5, 0.5); title.Position = UDim2.new(0.5, 0, 0.46, 0); title.Size = UDim2.new(0, 480, 0, 44); title.BackgroundTransparency = 1; title.Text = "🎃 CANDY HUB 🎃"; title.TextColor3 = Color3.fromRGB(255, 140, 30); title.Font = Enum.Font.GothamBlack; title.TextSize = 38; title.TextTransparency = 1; title.TextStrokeTransparency = 0.4; title.TextStrokeColor3 = Color3.fromRGB(80, 20, 10); title.ZIndex = 10
local sub = Instance.new("TextLabel", bg); sub.AnchorPoint = Vector2.new(0.5, 0); sub.Position = UDim2.new(0.5, 0, 0.46, 36); sub.Size = UDim2.new(0, 420, 0, 24); sub.BackgroundTransparency = 1; sub.Text = "halloween special  •  blood mode"; sub.TextColor3 = Color3.fromRGB(255, 90, 70); sub.Font = Enum.Font.GothamBold; sub.TextSize = 15; sub.TextTransparency = 1; sub.ZIndex = 10
local line = Instance.new("Frame", bg); line.AnchorPoint = Vector2.new(0.5, 0); line.Position = UDim2.new(0.5, 0, 0.46, 68); line.Size = UDim2.new(0, 0, 0, 3); line.BackgroundColor3 = Color3.fromRGB(255, 110, 30); line.BorderSizePixel = 0; line.ZIndex = 10
TS:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play(); TS:Create(sub, TweenInfo.new(0.85, Enum.EasingStyle.Quad), { TextTransparency = 0.1 }):Play(); TS:Create(line, TweenInfo.new(0.9, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 180, 0, 3) }):Play()
task.delay(2.4, function() if skipped or not sg or not sg.Parent then return end TS:Create(title, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(sub, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(line, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play(); TS:Create(bg, TweenInfo.new(0.7), { BackgroundTransparency = 1 }):Play() task.delay(0.75, function() if not skipped and sg then sg:Destroy() end end) end) end local okKeys, errKeys = pcall(F.loadConfigKeys) if not okKeys then warn("[prime.vs] F.loadConfigKeys error:", tostring(errKeys)) end
local okGui, errGui = pcall(F.buildGui) if not okGui then warn("[prime.vs] GUI error:", tostring(errGui)); print("[prime.vs] GUI FAILED:", tostring(errGui)) else _genv.__PrimeVSHubLoaded = true; print("[prime.vs] GUI built OK") task.defer(function() task.wait(0.15) pcall(function() F.playVersicnIntro() end) end) end local okState, errState = pcall(F.loadConfigState) if not okState then warn("[prime.vs] F.loadConfigState error:", tostring(errState)) end pcall(function() F.buildMobileButtons() if F.applyMobileButtonSize then F.applyMobileButtonSize() end
if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) print("[prime.vs] Loaded HALLOWEEN (stronger bat aimbot + blood steal)" .. (_IS_MOBILE and " [MOBILE PERF]" or " [PC]"))
pcall(function()


-- ===== CANDY HUB MOG MODE / RANDOM BACKGROUNDS =====
do
    -- Rotates through image assets already used/known by this build.
    local CandyRandomBackgrounds = {
        "rbxassetid://75543011706489",
        "rbxassetid://78591690208112",
        "rbxassetid://111808555599832",
        "rbxassetid://101851254",
        "rbxassetid://101851696",
        "rbxassetid://139607673",
        "rbxassetid://139607718",
        "rbxassetid://18474405",
    }
    local candyBgRunning = true
    task.spawn(function()
        math.randomseed(os.time())
        while candyBgRunning do
            task.wait(25)
            if not candyBgRunning then break end
            local id = CandyRandomBackgrounds[math.random(1, #CandyRandomBackgrounds)]
            pcall(function()
                if _G._VersincApplyBackground then
                    _G._VersincApplyBackground(id, true)
                end
            end)
        end
    end)

    local function addCandyMogBillboard(character)
        if not character then return end
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if not head then return end
        local old = head:FindFirstChild("CandyHubMogBillboard")
        if old then old:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CandyHubMogBillboard"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 250, 0, 42)
        billboard.StudsOffset = Vector3.new(0, 3.0, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 150
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "CANDY HUB MOGS YOU"
        label.TextColor3 = Color3.fromRGB(255, 170, 210)
        label.TextStrokeColor3 = Color3.fromRGB(30, 8, 20)
        label.TextStrokeTransparency = 0.15
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.Parent = billboard

        task.spawn(function()
            local t0 = tick()
            while billboard.Parent and label.Parent do
                local t = tick() - t0
                local pulse = 0.5 + 0.5 * math.sin(t * 3)
                local c1 = Color3.fromRGB(255, 140, 195)
                local c2 = Color3.fromRGB(255, 205, 230)
                label.TextColor3 = c1:Lerp(c2, pulse)
                task.wait(0.05)
            end
        end)
    end

    if LP.Character then
        task.defer(function() addCandyMogBillboard(LP.Character) end)
    end
    LP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        addCandyMogBillboard(character)
    end)
end

-- NOTE: A gameplay spin-bot/automated targeting system is intentionally not added.
-- This build keeps the requested visual/UI updates without adding an automated combat exploit.

local mt = getrawmetatable(game)
if not mt then return end
local oldIdx = mt.__index
local oldNewIdx = mt.__newindex
local spoofedVelocity = Vector3.zero
local function _adIndex(self, key)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
local ch = LP.Character
if ch and self:IsDescendantOf(ch) then
return spoofedVelocity
end
end
end
return oldIdx(self, key)
end
local function _adNewIndex(self, key, value)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
local ch = LP.Character
if ch and self:IsDescendantOf(ch) then
spoofedVelocity = value
return
end
end
end
return oldNewIdx(self, key, value)
end
setreadonly(mt, false)
if newcclosure then
mt.__index = newcclosure(_adIndex)
mt.__newindex = newcclosure(_adNewIndex)
else
mt.__index = _adIndex
mt.__newindex = _adNewIndex
end
setreadonly(mt, true)
end)
 
task.defer(function()
    task.wait(0.4)
    pcall(function()
        if _G._VersincApplyBackground then
            _G._VersincApplyBackground("76591851053639", true)
        end
    end)
end)
 task.defer(function() task.wait(1.2) pcall(function() F.saveConfig(true) end) end)
