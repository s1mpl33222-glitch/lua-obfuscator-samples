-- LocalScript : วางใน StarterPlayer > StarterPlayerScripts
-- ⚡️Killua Hub👑
-- ฟังก์ชัน: บิน (0-500) / กระโดดไม่จำกัด / ทะลุ / ESP มองเห็นผู้เล่น / วาร์ปไปหาผู้เล่น
-- + Loading Screen เต็มจอ (เสียง 6004690589)

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== สถานะ =====
local State = { Fly = false, InfJump = false, Noclip = false, ESP = false, Speed = 50, Walk = false, WalkSpeed = 50, GunESP = false, AutoGun = false, LobbyPos = nil, AntiFling = false, God = false }
local flyUp, flyDown = false, false
local bv, bg, flyConn

-- ===== ตั้งค่ารูปพื้นหลัง =====
local BG_IMAGE_ID     = "82142054150548"
local BG_TRANSPARENCY = 0.65

-- ===== ธีมสี =====
local BLUE      = Color3.fromRGB(20, 20, 20)
local DARKBLUE  = Color3.fromRGB(0, 0, 0)
local LIGHTBLUE = Color3.fromRGB(228, 228, 232)
local WHITE     = Color3.fromRGB(255, 255, 255)
local GRAY      = Color3.fromRGB(203, 213, 225)
-- สี ESP ตามบทบาท
local ESP_KNIFE    = Color3.fromRGB(255, 50, 50)   -- มีมีด = แดง
local ESP_GUN      = Color3.fromRGB(40, 140, 255)  -- มีปืน = ฟ้า
local ESP_INNOCENT = Color3.fromRGB(60, 220, 90)   -- บริสุทธิ์ = เขียว
-- ชื่อไอเทมที่ใช้ตรวจ (ไม่สนตัวพิมพ์เล็กใหญ่ ใช้การค้นหาบางส่วนของชื่อ)
local KNIFE_NAMES = { "knife" }
local GUN_NAMES   = { "gun", "revolver" }
-- ชื่อวัตถุปืนที่ตกพื้น (ค้นหาบางส่วนของชื่อ ไม่สนตัวพิมพ์เล็กใหญ่)
local DROPPED_GUN_NAMES = { "gundrop", "gun_drop", "droppedgun" }
local ESP_DROPPED = Color3.fromRGB(255, 200, 40) -- สีปืนตก = เหลือง

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function corner(o, r) make("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end

-- ===== ฟังก์ชันหลัก =====
local function getChar()
	local c = player.Character
	if not c then return end
	return c, c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if bv then bv:Destroy() bv = nil end
	if bg then bg:Destroy() bg = nil end
	local _, hum = getChar()
	if hum then hum.PlatformStand = false end
end

local function startFly()
	stopFly()
	local _, hum, hrp = getChar()
	if not hum or not hrp then return end
	hum.PlatformStand = true
	bv = make("BodyVelocity", { MaxForce = Vector3.new(9e9, 9e9, 9e9), Velocity = Vector3.zero }, hrp)
	bg = make("BodyGyro",     { MaxTorque = Vector3.new(9e9, 9e9, 9e9), P = 9e4 }, hrp)

	flyConn = RunService.RenderStepped:Connect(function()
		if not State.Fly then return end
		local _, h, root = getChar()
		if not h or not root then return end
		bg.CFrame = camera.CFrame
		local rel = camera.CFrame:VectorToObjectSpace(h.MoveDirection)
		local dir = camera.CFrame.LookVector * (-rel.Z) + camera.CFrame.RightVector * rel.X
		if flyUp   then dir += Vector3.new(0,  1, 0) end
		if flyDown then dir -= Vector3.new(0,  1, 0) end
		bv.Velocity = dir * State.Speed
	end)
end

local function setFly(on)
	State.Fly = on
	if on then startFly() else stopFly() end
end

-- วิ่งเร็ว (WalkSpeed)
local defaultWalk = 16
local function setWalk(on)
	State.Walk = on
	local _, hum = getChar()
	if on then
		if hum then defaultWalk = hum.WalkSpeed end
	else
		if hum then hum.WalkSpeed = defaultWalk end
	end
end

RunService.Heartbeat:Connect(function()
	if not State.Walk then return end
	local _, hum = getChar()
	if hum and hum.WalkSpeed ~= State.WalkSpeed then hum.WalkSpeed = State.WalkSpeed end
end)

-- อมตะ (God Mode)
local godConns = {}
local function godApply()
	local _, hum = getChar()
	if not hum then return end
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.MaxHealth = math.huge
	hum.Health = math.huge
	table.insert(godConns, hum.HealthChanged:Connect(function()
		if State.God and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
	end))
end

local function setGod(on)
	State.God = on
	for _, c in ipairs(godConns) do c:Disconnect() end
	godConns = {}
	if on then
		godApply()
		table.insert(godConns, player.CharacterAdded:Connect(function()
			task.wait(0.5)
			if State.God then godApply() end
		end))
	else
		local _, hum = getChar()
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end

-- Anti-Fling (กันคนดีด/ป่วนฟิสิกส์)
local acOrig = setmetatable({}, { __mode = "k" })
local acStepped, acBeat, lastSafeCF

local function setAntiFling(on)
	State.AntiFling = on
	if acStepped then acStepped:Disconnect() acStepped = nil end
	if acBeat then acBeat:Disconnect() acBeat = nil end

	if not on then
		for part, was in pairs(acOrig) do
			if part and part.Parent then part.CanCollide = was end
		end
		acOrig = setmetatable({}, { __mode = "k" })
		return
	end

	-- 1) ตัวผู้เล่นอื่นไม่ชนตัวเรา (ฝั่งเราเท่านั้น)
	acStepped = RunService.Stepped:Connect(function()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				for _, p in ipairs(plr.Character:GetDescendants()) do
					if p:IsA("BasePart") and p.CanCollide then
						if acOrig[p] == nil then acOrig[p] = true end
						p.CanCollide = false
					end
				end
			end
		end
	end)

	-- 2) ถ้าความเร็วหรือแรงหมุนผิดปกติ = โดนดีด -> หยุดแรงและดึงกลับที่เดิม
	acBeat = RunService.Heartbeat:Connect(function()
		local _, _, root = getChar()
		if not root or State.Flinging then return end
		local allowed = math.max(State.Fly and State.Speed or 0, State.Walk and State.WalkSpeed or 0, 16)
		local lin = root.AssemblyLinearVelocity.Magnitude
		local ang = root.AssemblyAngularVelocity.Magnitude
		if lin > allowed + 400 or ang > 120 then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			if lastSafeCF then root.CFrame = lastSafeCF end
		else
			lastSafeCF = root.CFrame
		end
	end)
end

-- กระโดดไม่จำกัด
UIS.JumpRequest:Connect(function()
	if State.InfJump then
		local _, hum = getChar()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ทะลุ
RunService.Stepped:Connect(function()
	if not State.Noclip or State.Flinging then return end
	local char = getChar()
	if not char then return end
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end)

-- ปุ่มขึ้น/ลง (E / Q)
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.E then flyUp   = true end
	if i.KeyCode == Enum.KeyCode.Q then flyDown = true end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.E then flyUp   = false end
	if i.KeyCode == Enum.KeyCode.Q then flyDown = false end
end)

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	if State.Fly then startFly() end
end)

-- =====================================================
--  ESP (มองเห็นผู้เล่น: ไฮไลต์ + ชื่อ + ระยะ)
-- =====================================================
local espData = {}
local espConn

local function hasToolNamed(plr, names)
	local containers = { plr.Character, plr:FindFirstChildOfClass("Backpack") }
	for _, c in ipairs(containers) do
		if c then
			for _, t in ipairs(c:GetChildren()) do
				if t:IsA("Tool") then
					local n = string.lower(t.Name)
					for _, key in ipairs(names) do
						if string.find(n, key, 1, true) then return true end
					end
				end
			end
		end
	end
	return false
end

local function roleFromValue(plr)
	local r = plr:GetAttribute("Role")
	if r == nil then
		local v = plr:FindFirstChild("Role")
		if v and v:IsA("ValueBase") then r = v.Value end
	end
	if type(r) == "string" then
		local l = string.lower(r)
		if string.find(l, "murder", 1, true) or string.find(l, "knife", 1, true) then return ESP_KNIFE end
		if string.find(l, "sheriff", 1, true) or string.find(l, "detective", 1, true) or string.find(l, "gun", 1, true) then return ESP_GUN end
	end
	return nil
end

local function roleColor(plr)
	if hasToolNamed(plr, KNIFE_NAMES) then return ESP_KNIFE end
	if hasToolNamed(plr, GUN_NAMES) then return ESP_GUN end
	return roleFromValue(plr) or ESP_INNOCENT
end

local function refreshRole(plr)
	local d = espData[plr]
	if d and d.hl then
		local c = roleColor(plr)
		d.hl.FillColor = c
		d.hl.OutlineColor = c
		if d.stroke then d.stroke.Color = c end
	end
end

local function clearESP(plr)
	local d = espData[plr]
	if d then
		if d.conns then
			for _, c in ipairs(d.conns) do c:Disconnect() end
		end
		if d.hl then d.hl:Destroy() end
		if d.bb then d.bb:Destroy() end
		espData[plr] = nil
	end
end

local function addESP(plr)
	if plr == player then return end
	clearESP(plr)
	local char = plr.Character
	if not char then return end
	local head = char:WaitForChild("Head", 5)
	if not head or plr.Character ~= char then return end

	local hl = make("Highlight", {
		Name = "KilluaESP", FillColor = roleColor(plr), OutlineColor = roleColor(plr),
		FillTransparency = 0.5, OutlineTransparency = 0,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, char)

	local bb = make("BillboardGui", {
		Name = "KilluaESP", Adornee = head, AlwaysOnTop = true,
		Size = UDim2.fromOffset(130, 36), StudsOffset = Vector3.new(0, 2.6, 0),
	}, head)

	local label = make("TextLabel", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		Text = plr.DisplayName, TextColor3 = WHITE, TextStrokeTransparency = 0.4,
		Font = Enum.Font.GothamBold, TextSize = 14,
	}, bb)

	local conns = {}
	espData[plr] = { hl = hl, bb = bb, label = label, char = char, conns = conns }

	-- เห็นทันทีที่ได้ไอเทม/บทบาท
	local function watch(container)
		if not container then return end
		table.insert(conns, container.ChildAdded:Connect(function() refreshRole(plr) end))
		table.insert(conns, container.ChildRemoved:Connect(function() task.defer(refreshRole, plr) end))
	end
	watch(char)
	table.insert(conns, plr:GetAttributeChangedSignal("Role"):Connect(function() refreshRole(plr) end))
	task.spawn(function()
		local bp = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack", 5)
		if espData[plr] and espData[plr].conns == conns then
			watch(bp)
			refreshRole(plr)
		end
	end)
end

local function setESP(on)
	State.ESP = on
	if on then
		for _, plr in ipairs(Players:GetPlayers()) do task.spawn(addESP, plr) end
		if espConn then espConn:Disconnect() end
		local acc = 0
		espConn = RunService.Heartbeat:Connect(function(dt)
			acc += dt
			local updateColor = acc >= 0.1
			if updateColor then acc = 0 end
			local _, _, myRoot = getChar()
			for plr, d in pairs(espData) do
				local root = d.char and d.char:FindFirstChild("HumanoidRootPart")
				if myRoot and root then
					local dist = math.floor((root.Position - myRoot.Position).Magnitude)
					d.label.Text = plr.DisplayName .. "\n[" .. dist .. "m]"
				end
				if updateColor then
					local c = roleColor(plr)
					d.hl.FillColor = c
					d.hl.OutlineColor = c
					if d.stroke then d.stroke.Color = c end
				end
			end
		end)
	else
		if espConn then espConn:Disconnect() espConn = nil end
		for plr in pairs(espData) do clearESP(plr) end
	end
end

local function hookESP(plr)
	if plr == player then return end
	plr.CharacterAdded:Connect(function()
		if State.ESP then
			task.spawn(addESP, plr)
		end
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do hookESP(plr) end
Players.PlayerAdded:Connect(hookESP)
Players.PlayerRemoving:Connect(clearESP)

-- =====================================================
--  ESP ปืนตก (แสดงตอนปืนตกพื้น เช่น นายอำเภอตาย)
-- =====================================================
local StarterGui = game:GetService("StarterGui")
local gunData = {}
local gunConns = {}
local gunLoop

local function nameHas(inst, list)
	local n = string.lower(inst.Name)
	for _, key in ipairs(list) do
		if string.find(n, key, 1, true) then return true end
	end
	return false
end

local function insideCharacter(inst)
	local a = inst.Parent
	while a and a ~= workspace do
		if a:IsA("Model") and Players:GetPlayerFromCharacter(a) then return true end
		a = a.Parent
	end
	return false
end

local function isDroppedGun(inst)
	if not (inst:IsA("BasePart") or inst:IsA("Tool") or inst:IsA("Model")) then return false end
	if insideCharacter(inst) then return false end
	if inst.Parent and gunData[inst.Parent] then return false end -- ลูกของวัตถุที่จับแล้ว
	if nameHas(inst, DROPPED_GUN_NAMES) then return true end
	if inst:IsA("Tool") and nameHas(inst, GUN_NAMES) then return true end
	return false
end

local function clearGun(inst)
	local d = gunData[inst]
	if d then
		if d.hl then d.hl:Destroy() end
		if d.bb then d.bb:Destroy() end
		gunData[inst] = nil
	end
end

local function gunPart(inst)
	if inst:IsA("BasePart") then return inst end
	if inst:IsA("Tool") then return inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart", true) end
	if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true) end
end

local function addGun(inst, announce)
	if gunData[inst] or not isDroppedGun(inst) then return end
	local part = gunPart(inst)
	if not part then return end

	local hl = make("Highlight", {
		Name = "KilluaGunESP", Adornee = inst, FillColor = ESP_DROPPED, OutlineColor = WHITE,
		FillTransparency = 0.3, OutlineTransparency = 0,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, inst)

	local bb = make("BillboardGui", {
		Name = "KilluaGunESP", Adornee = part, AlwaysOnTop = true,
		Size = UDim2.fromOffset(130, 36), StudsOffset = Vector3.new(0, 2, 0),
	}, part)

	local label = make("TextLabel", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		Text = "🔫 ปืนตก", TextColor3 = ESP_DROPPED, TextStrokeTransparency = 0.3,
		Font = Enum.Font.GothamBold, TextSize = 15,
	}, bb)

	gunData[inst] = { hl = hl, bb = bb, label = label, part = part }

	if announce then
		pcall(function()
			StarterGui:SetCore("SendNotification", { Title = "Killua Hub", Text = "🔫 ปืนตกแล้ว!", Duration = 3 })
		end)
	end
end

local function setGunESP(on)
	State.GunESP = on
	for _, c in ipairs(gunConns) do c:Disconnect() end
	gunConns = {}
	if gunLoop then gunLoop:Disconnect() gunLoop = nil end

	if not on then
		for inst in pairs(gunData) do clearGun(inst) end
		return
	end

	-- สแกนของที่มีอยู่แล้ว
	for _, inst in ipairs(workspace:GetDescendants()) do addGun(inst, false) end

	-- ดักปืนที่ตกใหม่
	table.insert(gunConns, workspace.DescendantAdded:Connect(function(inst)
		task.defer(addGun, inst, true)
	end))
	table.insert(gunConns, workspace.DescendantRemoving:Connect(clearGun))

	-- อัปเดตระยะ
	local acc = 0
	gunLoop = RunService.Heartbeat:Connect(function(dt)
		acc += dt
		if acc < 0.1 then return end
		acc = 0
		local _, _, myRoot = getChar()
		for inst, d in pairs(gunData) do
			if not d.part.Parent then
				clearGun(inst)
			elseif myRoot then
				local dist = math.floor((d.part.Position - myRoot.Position).Magnitude)
				d.label.Text = "🔫 ปืนตก [" .. dist .. "m]"
			end
		end
	end)
end

-- =====================================================
--  วาร์ปเก็บปืนอัตโนมัติ (เก็บแล้วกลับที่เดิม)
-- =====================================================
local autoGunConn
local grabbing = false

local LOBBY_RADIUS = 120 -- รัศมีล็อบบี้ (studs) รอบจุดที่ตั้งไว้
local LOBBY_TEAMS  = { "lobby" } -- ชื่อทีมที่ถือว่าอยู่ล็อบบี้ (ค้นหาบางส่วน)
local GAME_ATTRS   = { "InGame", "Playing", "Alive" } -- ถ้า Attribute นี้เป็น false = ไม่ได้อยู่ในเกม

local function isInGame()
	-- 1) อยู่ใกล้จุดล็อบบี้ที่ตั้งไว้ = ล็อบบี้
	local _, _, root = getChar()
	if State.LobbyPos and root and (root.Position - State.LobbyPos).Magnitude < LOBBY_RADIUS then
		return false
	end
	-- 2) ทีมล็อบบี้
	local team = player.Team
	if team then
		local tn = string.lower(team.Name)
		for _, key in ipairs(LOBBY_TEAMS) do
			if string.find(tn, key, 1, true) then return false end
		end
	end
	-- 3) Attribute บอกสถานะ
	for _, a in ipairs(GAME_ATTRS) do
		if player:GetAttribute(a) == false then return false end
	end
	return true
end

local function grabGun(inst)
	if grabbing or not State.AutoGun then return end
	if not isInGame() then return end -- อยู่ล็อบบี้ไม่ต้องไปเก็บ
	-- ถ้าเราถือมีดหรือมีปืนอยู่แล้ว ไม่ต้องเก็บ
	if hasToolNamed(player, KNIFE_NAMES) or hasToolNamed(player, GUN_NAMES) then return end
	local part = gunPart(inst)
	local _, _, root = getChar()
	if not part or not root then return end

	grabbing = true
	local origin = root.CFrame
	if bv then bv.MaxForce = Vector3.zero end
	if bg then bg.MaxTorque = Vector3.zero end

	local t0 = tick()
	while State.AutoGun and tick() - t0 < 2 do
		local _, _, r = getChar()
		if not r or not part.Parent then break end
		r.CFrame = part.CFrame
		r.AssemblyLinearVelocity = Vector3.zero
		if hasToolNamed(player, GUN_NAMES) then break end
		RunService.Heartbeat:Wait()
	end

	-- กลับตำแหน่งเดิม
	local _, _, r = getChar()
	if r then
		r.CFrame = origin
		r.AssemblyLinearVelocity = Vector3.zero
	end
	if bv then bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) end
	if bg then bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) end
	grabbing = false
end

local function setAutoGun(on)
	State.AutoGun = on
	if autoGunConn then autoGunConn:Disconnect() autoGunConn = nil end
	if not on then return end

	-- ถ้ามีปืนตกอยู่แล้ว เก็บเลย
	for _, inst in ipairs(workspace:GetDescendants()) do
		if isDroppedGun(inst) then
			task.spawn(grabGun, inst)
			break
		end
	end

	-- ปืนตกใหม่
	autoGunConn = workspace.DescendantAdded:Connect(function(inst)
		task.defer(function()
			if State.AutoGun and isDroppedGun(inst) then grabGun(inst) end
		end)
	end)
end

-- =====================================================
--  ฟลิ้ง (เหวี่ยงผู้เล่นที่เลือก) - ใช้ทดสอบในแมพตัวเอง
-- =====================================================
local FLING_TIME = 4 -- สูงสุดกี่วินาทีต่อครั้ง
local flingConn, flingOrigin

local function stopFling()
	if flingConn then flingConn:Disconnect() flingConn = nil end
	local origin = flingOrigin
	flingOrigin = nil
	task.spawn(function()
		-- คืนตำแหน่งและหยุดแรงหมุนของตัวเรา
		for _ = 1, 15 do
			local _, _, root = getChar()
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				if origin then root.CFrame = origin end
			end
			RunService.Heartbeat:Wait()
		end
		State.Flinging = false
		if bv then bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) end
		if bg then bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) end
	end)
end

local function startFling(plr, onDone)
	if State.Flinging or not plr then return false end
	local _, _, root = getChar()
	if not root then return false end

	State.Flinging = true
	flingOrigin = root.CFrame
	if bv then bv.MaxForce = Vector3.zero end
	if bg then bg.MaxTorque = Vector3.zero end

	local t0, flip = tick(), false
	flingConn = RunService.Heartbeat:Connect(function()
		local _, _, r = getChar()
		local tr = plr.Parent and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if not r or not tr or tick() - t0 > FLING_TIME or tr.AssemblyLinearVelocity.Magnitude > 400 then
			stopFling()
			if onDone then onDone() end
			return
		end
		flip = not flip
		r.CFrame = tr.CFrame * CFrame.new(0, 0, flip and 1.2 or -1.2)
		r.AssemblyAngularVelocity = Vector3.new(0, 5e4, 0)
		r.AssemblyLinearVelocity = Vector3.new(5e4, 5e4, 5e4)
	end)
	return true
end

-- =====================================================
--  วาร์ปไปหาผู้เล่น
-- =====================================================
local function teleportTo(plr)
	local _, _, myRoot = getChar()
	local tchar = plr.Character
	local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")
	if myRoot and troot then
		myRoot.CFrame = troot.CFrame * CFrame.new(0, 1, 3)
	end
end

-- =====================================================
--  GUI ROOT
-- =====================================================
local gui = make("ScreenGui", {
	Name = "FlyMenu",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true
}, player:WaitForChild("PlayerGui"))

-- forward declare ให้ Loading Screen เรียกใช้ก่อนได้
local main, toggleBtn

-- =====================================================
--  LOADING SCREEN
-- =====================================================
local SOUND_ID       = "6004690589"
local LOAD_TIME      = 3.5      -- ระยะเวลาโหลด (วินาที)
local SOUND_MAX_TIME = 3.5      -- ความยาวเสียงที่ต้องการ (ปรับ PlaybackSpeed อัตโนมัติ)

-- เล่นเสียงให้ตรงกับ Loading Screen
local function playSoftSound(soundId, desiredDuration)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. soundId
	s.Volume  = 0.8
	s.Looped  = false
	s.Parent  = workspace.CurrentCamera

	-- รอให้โหลดความยาวเสียงจริงก่อน แล้วค่อยปรับ speed ให้พอดี
	task.spawn(function()
		local waited = 0
		while not s.IsLoaded and waited < 3 do
			task.wait(0.05)
			waited += 0.05
		end
		if desiredDuration and s.TimeLength > 0 then
			s.PlaybackSpeed = s.TimeLength / desiredDuration
		end
		s:Play()
	end)

	-- ทำลายหลังเล่นจบ (กันค้าง)
	task.delay(desiredDuration + 1, function()
		if s then s:Destroy() end
	end)
end

-- 🔥 เล่นทันทีที่ Loading Screen ขึ้น
playSoftSound(SOUND_ID, SOUND_MAX_TIME)

-- พื้นหลังเต็มจอ
local loadingBg = make("ImageLabel", {
	Size               = UDim2.fromScale(1, 1),
	Position           = UDim2.fromScale(0, 0),
	BackgroundColor3   = Color3.fromRGB(0, 0, 0),
	Image              = "rbxassetid://75515029330621",
	ScaleType          = Enum.ScaleType.Crop,
	ZIndex             = 100
}, gui)

-- กล่องโหลด
local loadBox = make("Frame", {
	Size                   = UDim2.fromOffset(340, 150),
	Position               = UDim2.new(0.5, -170, 0.5, -75),
	BackgroundColor3       = Color3.fromRGB(12, 14, 22),
	BackgroundTransparency = 0.1,
	BorderSizePixel        = 0,
	ZIndex                 = 101
}, loadingBg)
corner(loadBox, 14)

make("UIStroke", {
	Color        = Color3.fromRGB(80, 170, 255),
	Thickness    = 2.5,
	Transparency = 0.25
}, loadBox)

local leftSkew = make("Frame", {
	Size                   = UDim2.fromOffset(18, 150),
	Position               = UDim2.new(0, -12, 0, 0),
	BackgroundColor3       = Color3.fromRGB(80, 170, 255),
	BackgroundTransparency = 0.3,
	BorderSizePixel        = 0,
	Rotation               = 12,
	ZIndex                 = 102
}, loadBox)
corner(leftSkew, 6)

local rightSkew = make("Frame", {
	Size                   = UDim2.fromOffset(18, 150),
	Position               = UDim2.new(1, -6, 0, 0),
	BackgroundColor3       = Color3.fromRGB(80, 170, 255),
	BackgroundTransparency = 0.3,
	BorderSizePixel        = 0,
	Rotation               = -12,
	ZIndex                 = 102
}, loadBox)
corner(rightSkew, 6)

local loadTitle = make("TextLabel", {
	Size                   = UDim2.new(1, 0, 0, 42),
	Position               = UDim2.new(0, 0, 0, 28),
	BackgroundTransparency = 1,
	Text                   = "LOADING",
	TextColor3             = WHITE,
	Font                   = Enum.Font.GothamBold,
	TextSize               = 30,
	ZIndex                 = 103
}, loadBox)

local percentLabel = make("TextLabel", {
	Size                   = UDim2.new(1, 0, 0, 28),
	Position               = UDim2.new(0, 0, 0, 72),
	BackgroundTransparency = 1,
	Text                   = "0%",
	TextColor3             = Color3.fromRGB(140, 210, 255),
	Font                   = Enum.Font.GothamBold,
	TextSize               = 22,
	ZIndex                 = 103
}, loadBox)

local barBg = make("Frame", {
	Size             = UDim2.new(0.78, 0, 0, 9),
	Position         = UDim2.new(0.11, 0, 0, 112),
	BackgroundColor3 = Color3.fromRGB(35, 40, 55),
	BorderSizePixel  = 0,
	ZIndex           = 103
}, loadBox)
corner(barBg, 5)

local barFill = make("Frame", {
	Size             = UDim2.new(0, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(70, 170, 255),
	BorderSizePixel  = 0,
	ZIndex           = 104
}, barBg)
corner(barFill, 5)

-- แอนิเมชันโหลด
task.spawn(function()
	local progress = 0
	local start    = tick()

	while progress < 100 do
		local elapsed = tick() - start
		progress = math.clamp((elapsed / LOAD_TIME) * 100, 0, 100)

		percentLabel.Text = math.floor(progress) .. "%"
		barFill.Size      = UDim2.new(progress / 100, 0, 1, 0)
		task.wait()
	end

	task.wait(0.25)

	local fadeInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(loadingBg,    fadeInfo, { BackgroundTransparency = 1, ImageTransparency = 1 }):Play()
	TweenService:Create(loadBox,      fadeInfo, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(loadTitle,    fadeInfo, { TextTransparency = 1 }):Play()
	TweenService:Create(percentLabel, fadeInfo, { TextTransparency = 1 }):Play()
	TweenService:Create(barBg,        fadeInfo, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(barFill,      fadeInfo, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(leftSkew,     fadeInfo, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(rightSkew,    fadeInfo, { BackgroundTransparency = 1 }):Play()

	task.wait(0.6)
	loadingBg:Destroy()

	if main      then main.Visible      = true end
	if toggleBtn then toggleBtn.Visible = true end
end)

-- =====================================================
--  UI หลัก
-- =====================================================
local TOGGLE_IMAGE_ID = "123738501517887"

toggleBtn = make("ImageButton", {
	Size             = UDim2.fromOffset(50, 50),
	Position         = UDim2.new(0, 10, 0.5, -25),
	BackgroundColor3 = BLUE,
	Image            = "rbxassetid://" .. TOGGLE_IMAGE_ID,
	ScaleType        = Enum.ScaleType.Crop,
	AutoButtonColor  = true,
	Visible          = false
}, gui)
corner(toggleBtn, 12)
make("UIStroke", { Color = WHITE, Thickness = 2 }, toggleBtn)

main = make("Frame", {
	Size             = UDim2.fromOffset(400, 250),
	Position         = UDim2.new(0.5, -200, 0.5, -125),
	BackgroundColor3 = WHITE,
	BorderSizePixel  = 0,
	Active           = true,
	Visible          = false
}, gui)
corner(main, 12)
make("UIStroke", { Color = BLUE, Thickness = 2 }, main)

-- พื้นหลังรูปจางๆ
if BG_IMAGE_ID ~= "" then
	local bgImg = make("ImageLabel", {
		Size                   = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image                  = "rbxassetid://" .. BG_IMAGE_ID,
		ImageTransparency      = BG_TRANSPARENCY,
		ScaleType              = Enum.ScaleType.Crop,
		ZIndex                 = 0,
	}, main)
	corner(bgImg, 12)
end

-- ปุ่มเปิด/ปิด: แตะ = toggle, ลาก = ย้าย
do
	local pressing, dragStart, startPos, moved = false, nil, nil, false
	toggleBtn.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			pressing, moved = true, false
			dragStart = i.Position
			startPos  = toggleBtn.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if pressing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			if moved or d.Magnitude > 8 then
				moved = true
				toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if pressing and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			pressing = false
			if not moved then main.Visible = not main.Visible end
		end
	end)
end

-- Sidebar
local sidebar = make("Frame", { Size = UDim2.new(0, 130, 1, 0), BackgroundColor3 = BLUE, BorderSizePixel = 0 }, main)
corner(sidebar, 12)
make("Frame", { Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -12, 0, 0), BackgroundColor3 = BLUE, BorderSizePixel = 0 }, sidebar)

make("TextLabel", {
	Size = UDim2.new(1, -12, 0, 36), Position = UDim2.new(0, 6, 0, 4), BackgroundTransparency = 1,
	Text = "⚡️Killua Hub👑", TextScaled = true,
	TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 18,
}, sidebar)

-- ลากหน้าต่างด้วย sidebar
sidebar.Active = true
do
	local dragStart, startPos, moving = nil, nil, false
	sidebar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			moving    = true
			dragStart = i.Position
			startPos  = main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if moving and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then moving = false end
	end)
end

local content = make("Frame", { Size = UDim2.new(1, -140, 1, -20), Position = UDim2.new(0, 135, 0, 10), BackgroundTransparency = 1 }, main)

local pages, tabs = {}, {}

local function showPage(name)
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(tabs) do
		b.BackgroundColor3 = (n == name) and WHITE or BLUE
		b.TextColor3       = (n == name) and DARKBLUE or WHITE
	end
end

local function addTab(name, label, order, canvasH)
	local b = make("TextButton", {
		Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 0, 44 + (order - 1) * 40),
		BackgroundColor3 = BLUE, Text = label, TextColor3 = WHITE,
		Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
	}, sidebar)
	corner(b, 8)
	tabs[name]  = b
	if canvasH then
		pages[name] = make("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, canvasH), Visible = false,
		}, content)
	else
		pages[name] = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false }, content)
	end
	b.MouseButton1Click:Connect(function() showPage(name) end)
	return pages[name]
end

-- สวิตช์
local function addSwitch(parent, text, y, callback)
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 44), Position = UDim2.new(0, 0, 0, y), BackgroundColor3 = LIGHTBLUE }, parent)
	corner(row, 8)
	make("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
		Text = text, TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local sw = make("TextButton", { Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -58, 0.5, -12), BackgroundColor3 = GRAY, Text = "", AutoButtonColor = false }, row)
	corner(sw, 12)
	local knob = make("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = WHITE }, sw)
	corner(knob, 9)
	local on = false
	sw.MouseButton1Click:Connect(function()
		on = not on
		sw.BackgroundColor3 = on and BLUE or GRAY
		knob:TweenPosition(on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quad", 0.15, true)
		callback(on)
	end)
end

-- =====================================================
--  หน้า Player
-- =====================================================
local flyPage = addTab("player", "Player👤", 1, 470)

-- สไลเดอร์ + ปุ่ม -/+ (ใช้ซ้ำได้)
local CAS = game:GetService("ContextActionService")
local function addSlider(parent, y, title, minV, maxV, default, onChange)
	local label = make("TextLabel", {
		Size = UDim2.new(1, -90, 0, 28), Position = UDim2.new(0, 0, 0, y), BackgroundTransparency = 1,
		Text = title .. ": " .. default, TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)

	local function stepBtn(text, xOffset)
		local b = make("TextButton", {
			Size = UDim2.fromOffset(34, 28), Position = UDim2.new(1, xOffset, 0, y),
			BackgroundColor3 = BLUE, Text = text, TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 18,
		}, parent)
		corner(b, 8)
		return b
	end

	local track  = make("Frame", { Size = UDim2.new(1, -16, 0, 10), Position = UDim2.new(0, 8, 0, y + 44), BackgroundColor3 = GRAY }, parent)
	corner(track, 5)
	local fill   = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = BLUE }, track)
	corner(fill, 5)
	local handle = make("Frame", { Size = UDim2.fromOffset(20, 20), Position = UDim2.new(0, -10, 0.5, -10), BackgroundColor3 = WHITE }, track)
	corner(handle, 10)
	make("UIStroke", { Color = BLUE, Thickness = 2 }, handle)

	local value = default
	local function setValue(n)
		value = math.clamp(math.floor(n + 0.5), minV, maxV)
		local a = (value - minV) / (maxV - minV)
		fill.Size       = UDim2.new(a, 0, 1, 0)
		handle.Position = UDim2.new(a, -10, 0.5, -10)
		label.Text      = title .. ": " .. value
		onChange(value)
	end

	local minus = stepBtn("-", -84)
	local plus  = stepBtn("+", -46)
	minus.MouseButton1Click:Connect(function() setValue(value - 1) end)
	plus.MouseButton1Click:Connect(function()  setValue(value + 1) end)

	local function setFromX(x)
		local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		setValue(minV + a * (maxV - minV))
	end
	setValue(default)

	-- พื้นที่แตะสไลเดอร์ (กันกล้องหมุน + กันหน้าเลื่อนตอนลาก)
	local hit = make("TextButton", {
		Size = UDim2.new(1, 20, 0, 36), Position = UDim2.new(0, -10, 0.5, -18),
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Active = true,
	}, track)

	local dragging = false
	local function sinkInput() return Enum.ContextActionResult.Sink end
	local function startDrag()
		dragging = true
		if parent:IsA("ScrollingFrame") then parent.ScrollingEnabled = false end
		CAS:BindActionAtPriority("KilluaSliderSink", sinkInput, false, Enum.ContextActionPriority.High.Value,
			Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseMovement)
	end
	local function stopDrag()
		if not dragging then return end
		dragging = false
		if parent:IsA("ScrollingFrame") then parent.ScrollingEnabled = true end
		CAS:UnbindAction("KilluaSliderSink")
	end

	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			startDrag()
			setFromX(i.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setFromX(i.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
	end)
end

-- บิน
addSwitch(flyPage, "เปิดบิน", 0, setFly)
addSlider(flyPage, 54, "ความเร็วบิน", 0, 500, State.Speed, function(v) State.Speed = v end)

-- กระโดดไม่จำกัด / ทะลุ
addSwitch(flyPage, "กระโดดไม่จำกัด", 124, function(v) State.InfJump = v end)
addSwitch(flyPage, "ทะลุ (Noclip)",   174, function(v) State.Noclip  = v end)

-- วิ่งเร็ว
addSwitch(flyPage, "วิ่งเร็ว", 224, setWalk)
addSlider(flyPage, 278, "ความเร็ววิ่ง", 16, 500, State.WalkSpeed, function(v) State.WalkSpeed = v end)

-- ป้องกัน
addSwitch(flyPage, "Anti-Fling 🛡️", 352, setAntiFling)
addSwitch(flyPage, "อมตะ ♾️", 402, setGod)

-- =====================================================
--  หน้า ESP
-- =====================================================
local espPage = addTab("esp", "ESP👁", 2, 290)
addSwitch(espPage, "ESP มองเห็นผู้เล่น", 0, setESP)
addSwitch(espPage, "ESP ปืนตก 🔫", 54, setGunESP)
addSwitch(espPage, "เก็บปืนอัตโนมัติ", 108, setAutoGun)

-- ตั้งจุดล็อบบี้ (ยืนในล็อบบี้แล้วกด)
local lobbyRow = make("Frame", { Size = UDim2.new(1, -6, 0, 44), Position = UDim2.new(0, 0, 0, 162), BackgroundColor3 = LIGHTBLUE }, espPage)
corner(lobbyRow, 8)
local lobbyLabel = make("TextLabel", {
	Size = UDim2.new(1, -104, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
	Text = "จุดล็อบบี้: ยังไม่ตั้ง", TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, lobbyRow)
local lobbyBtn = make("TextButton", {
	Size = UDim2.fromOffset(86, 30), Position = UDim2.new(1, -94, 0.5, -15),
	BackgroundColor3 = BLUE, Text = "ตั้งจุดนี้", TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 13,
}, lobbyRow)
corner(lobbyBtn, 8)
lobbyBtn.MouseButton1Click:Connect(function()
	local _, _, r = getChar()
	if r then
		State.LobbyPos = r.Position
		lobbyLabel.Text = "จุดล็อบบี้: ตั้งแล้ว ✓"
	end
end)
make("TextLabel", {
	Size = UDim2.new(1, -6, 0, 70), Position = UDim2.new(0, 0, 0, 214), BackgroundTransparency = 1,
	Text = "🔴 มีมีด   🔵 มีปืน   🟢 บริสุทธิ์\nแสดงชื่อและระยะห่าง มองเห็นได้แม้อยู่หลังกำแพง\nปืนตก = สีเหลือง + แจ้งเตือน | เก็บปืนอัตโนมัติ = วาร์ปไปเก็บแล้วกลับที่เดิม\nยืนในล็อบบี้แล้วกด \"ตั้งจุดนี้\" จะไม่เก็บปืนตอนอยู่ล็อบบี้",
	TextColor3 = DARKBLUE, Font = Enum.Font.Gotham, TextSize = 13, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
}, espPage)

-- =====================================================
--  หน้า วาร์ป
-- =====================================================
local tpPage = addTab("tp", "วาร์ป📍", 3)
-- รูปตัวละคร: "Avatar" = เต็มตัว, "AvatarBust" = ครึ่งตัว, "AvatarHeadShot" = หน้า
local TP_AVATAR_TYPE = "Avatar"

local list = make("ScrollingFrame", {
	Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
	ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, tpPage)
make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, list)

local function refreshPlayers()
	for _, c in ipairs(list:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end

	local count = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			count += 1
			local row = make("TextButton", {
				Size = UDim2.new(1, -8, 0, 66), BackgroundColor3 = LIGHTBLUE,
				Text = "", AutoButtonColor = true,
			}, list)
			corner(row, 8)

			make("ImageLabel", {
				Size = UDim2.fromOffset(58, 58), Position = UDim2.new(0, 6, 0.5, -29),
				BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
				Image = "rbxthumb://type=" .. TP_AVATAR_TYPE .. "&id=" .. plr.UserId .. "&w=150&h=150",
			}, row)

			make("TextLabel", {
				Size = UDim2.new(1, -78, 0, 22), Position = UDim2.new(0, 72, 0, 12),
				BackgroundTransparency = 1, Text = plr.DisplayName,
				TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, row)

			make("TextLabel", {
				Size = UDim2.new(1, -78, 0, 18), Position = UDim2.new(0, 72, 0, 34),
				BackgroundTransparency = 1, Text = "@" .. plr.Name .. "  📍",
				TextColor3 = Color3.fromRGB(90, 90, 100), Font = Enum.Font.Gotham, TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, row)

			row.MouseButton1Click:Connect(function() teleportTo(plr) end)
		end
	end

	if count == 0 then
		make("TextLabel", {
			Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1,
			Text = "ไม่มีผู้เล่นคนอื่นในเซิร์ฟเวอร์",
			TextColor3 = DARKBLUE, Font = Enum.Font.Gotham, TextSize = 13,
		}, list)
	end
end

refreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.2) refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) refreshPlayers() end)

-- =====================================================
--  หน้า ฟลิ้ง
-- =====================================================
local flingPage = addTab("fling", "ฟลิ้ง💥", 4)
local flingSel
local flingRows = {}

local selLabel = make("TextLabel", {
	Size = UDim2.new(1, -104, 0, 36), BackgroundTransparency = 1,
	Text = "เลือก: -", TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
}, flingPage)

local flingBtn = make("TextButton", {
	Size = UDim2.fromOffset(98, 36), Position = UDim2.new(1, -98, 0, 0),
	BackgroundColor3 = BLUE, Text = "เริ่มฟลิ้ง", TextColor3 = WHITE,
	Font = Enum.Font.GothamBold, TextSize = 14,
}, flingPage)
corner(flingBtn, 8)

local flingList = make("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -44), Position = UDim2.new(0, 0, 0, 44),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
	CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, flingPage)
make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, flingList)

local function resetFlingBtn()
	flingBtn.Text = "เริ่มฟลิ้ง"
	flingBtn.BackgroundColor3 = BLUE
end

flingBtn.MouseButton1Click:Connect(function()
	if State.Flinging then
		stopFling()
		resetFlingBtn()
		return
	end
	if not flingSel or not flingSel.Parent then
		selLabel.Text = "เลือกผู้เล่นก่อน"
		return
	end
	if startFling(flingSel, resetFlingBtn) then
		flingBtn.Text = "หยุด"
		flingBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	end
end)

local function selectFling(plr)
	flingSel = plr
	for p, r in pairs(flingRows) do r.stroke.Enabled = (p == plr) end
	selLabel.Text = plr and ("เลือก: " .. plr.DisplayName) or "เลือก: -"
end

local function refreshFling()
	for _, c in ipairs(flingList:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
	flingRows = {}
	if flingSel and not flingSel.Parent then flingSel = nil end

	local count = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			count += 1
			local row = make("TextButton", {
				Size = UDim2.new(1, -8, 0, 66), BackgroundColor3 = LIGHTBLUE,
				Text = "", AutoButtonColor = true,
			}, flingList)
			corner(row, 8)
			local stroke = make("UIStroke", { Color = BLUE, Thickness = 2.5, Enabled = (plr == flingSel) }, row)

			make("ImageLabel", {
				Size = UDim2.fromOffset(58, 58), Position = UDim2.new(0, 6, 0.5, -29),
				BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
				Image = "rbxthumb://type=" .. TP_AVATAR_TYPE .. "&id=" .. plr.UserId .. "&w=150&h=150",
			}, row)
			make("TextLabel", {
				Size = UDim2.new(1, -78, 0, 22), Position = UDim2.new(0, 72, 0, 12),
				BackgroundTransparency = 1, Text = plr.DisplayName,
				TextColor3 = DARKBLUE, Font = Enum.Font.GothamBold, TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, row)
			make("TextLabel", {
				Size = UDim2.new(1, -78, 0, 18), Position = UDim2.new(0, 72, 0, 34),
				BackgroundTransparency = 1, Text = "@" .. plr.Name,
				TextColor3 = Color3.fromRGB(90, 90, 100), Font = Enum.Font.Gotham, TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, row)

			flingRows[plr] = { row = row, stroke = stroke }
			row.MouseButton1Click:Connect(function() selectFling(plr) end)
		end
	end

	if count == 0 then
		make("TextLabel", {
			Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1,
			Text = "ไม่มีผู้เล่นคนอื่นในเซิร์ฟเวอร์",
			TextColor3 = DARKBLUE, Font = Enum.Font.Gotham, TextSize = 13,
		}, flingList)
	end
	selectFling(flingSel)
end

refreshFling()
Players.PlayerAdded:Connect(function() task.wait(0.2) refreshFling() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) refreshFling() end)

showPage("player")