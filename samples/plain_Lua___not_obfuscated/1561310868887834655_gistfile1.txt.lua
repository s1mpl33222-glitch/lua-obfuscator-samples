-- Ficha Hub - Monochrome | @5mhe on discord
-- thanks for using it <3
-- FIX v1.1: keypad now reads after each fire (server may debounce rapid fires)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local me = Players.LocalPlayer
local myGui = me:WaitForChild("PlayerGui")

-- Ui parents u know gangggg
local function uiParent()
	local ok, h = pcall(gethui)
	if ok and h then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and c then return c end
	return myGui
end

-- this shi clean out the old one if present boiii
if getgenv().FichaMonoLoaded then
	pcall(function() getgenv().FichaMonoUnload() end)
	task.wait(0.3)
end
getgenv().FichaMonoLoaded = true

-- reload
local stillAlive = true
local myConns = {}
local myThreads = {}

local RL = nil
pcall(function() RL = (getgenv and getgenv().STATE or nil) end)

local function track(c)
	table.insert(myConns, c)
	return c
end

local function killAll()
	stillAlive = false
	for _, c in pairs(myConns) do pcall(function() c:Disconnect() end) end
	table.clear(myConns)
	for _, t in pairs(myThreads) do pcall(function() task.cancel(t) end) end
	table.clear(myThreads)
	pcall(function() RunService:UnbindFromRenderStep("FichaSpeed") end)
end

if RL and RL.onCleanup then
	RL.onCleanup(function()
		stillAlive = false
		for _, c in pairs(myConns) do pcall(function() c:Disconnect() end) end
		for _, t in pairs(myThreads) do pcall(function() task.cancel(t) end) end
		pcall(function() RunService:UnbindFromRenderStep("FichaSpeed") end)
	end)
end

getgenv().FichaMonoUnload = killAll

local function isAlive()
	if RL and RL.alive then return RL.alive() end
	return stillAlive
end

local function loop(fn, waitTime)
	local th = task.spawn(function()
		while isAlive() do
			local ok = pcall(fn)
			if not ok then task.wait(1) else task.wait(waitTime or 0.5) end
		end
	end)
	table.insert(myThreads, th)
end

local function note(title, msg, dur)
	pcall(function() WindUI:Notify({ Title = title, Content = msg, Duration = dur or 3, Icon = "eye" }) end)
end

local function char() return me.Character end
local function hrp()
	local c = char()
	if c then return c:FindFirstChild("HumanoidRootPart") end
	return nil
end
local function hum()
	local c = char()
	if c then return c:FindFirstChildOfClass("Humanoid") end
	return nil
end
local function pfc()
	local ps = me:FindFirstChild("PlayerScripts")
	if ps then return ps:FindFirstChild("PolishedFirstPersonCamera") end
	return nil
end
local function monoFolder() return Workspace:FindFirstChild("monochrome") end
local function myPos()
	local h = hrp()
	if h then return h.Position end
	return nil
end

local function tpTo(pos, up)
	local h = hrp()
	if not h or not pos then return false end
	up = up or 3
	h.AssemblyLinearVelocity = Vector3.zero
	h.AssemblyAngularVelocity = Vector3.zero
	h.CFrame = CFrame.new(pos + Vector3.new(0, up, 0))
	return true
end

local function tweenTo(pos, up)
	local h = hrp()
	if not h or not pos then return false end
	up = up or 3
	local target = CFrame.new(pos + Vector3.new(0, up, 0))
	local dist = (h.Position - target.Position).Magnitude
	local t = math.clamp(dist / 55, 0.4, 4)
	local tw = TweenService:Create(h, TweenInfo.new(t, Enum.EasingStyle.Linear), { CFrame = target })
	tw:Play()
	tw.Completed:Wait()
	return true
end

local function firstPart(inst)
	if inst:IsA("BasePart") then return inst end
	for _, v in pairs(inst:GetDescendants()) do
		if v:IsA("BasePart") then return v end
	end
	return nil
end

local function anchorPart(pr)
	local host = pr.Parent
	if host and host:IsA("BasePart") then return host end
	local p = host
	while p and p ~= Workspace do
		if p:IsA("BasePart") then return p end
		p = p.Parent
	end
	if host then
		local top = host.Parent
		if top then return firstPart(top) end
	end
	return nil
end

-- idek atp i forgot
local function promptPos(pr)
	if not pr or not pr.Parent then return nil end
	local host = pr.Parent
	if host:IsA("Attachment") then
		local ok, wp = pcall(function() return host.WorldPosition end)
		if ok and wp then return wp end
	end
	if host:IsA("BasePart") then return host.Position end
	local p = host.Parent
	while p and p ~= Workspace do
		if p:IsA("BasePart") then return p.Position end
		p = p.Parent
	end
	if host then
		local b = firstPart(host)
		if b then return b.Position end
	end
	return nil
end

local function pressPrompt(pr)
	if typeof(fireproximityprompt) == "function" then
		pcall(function() fireproximityprompt(pr) end)
	else
		pcall(function()
			pr.HoldDuration = 0
			pr.RequiresLineOfSight = false
		end)
	end
end

local function readCodeRaw()
	local m = monoFolder()
	if not m then return "???" end
	local cn = m:FindFirstChild("CodeNote", true)
	if cn and cn:IsA("BasePart") then
		local printed = cn:FindFirstChild("Printed")
		if printed then
			local digits = printed:FindFirstChild("Digits")
			if digits and digits:IsA("TextLabel") then return digits.Text end
		end
		for _, d in pairs(cn:GetDescendants()) do
			if d:IsA("TextLabel") and #d.Text >= 3 then return d.Text end
		end
	end
	return "???"
end

local function codeNumbers()
	local raw = readCodeRaw()
	local t = {}
	for ch in string.gmatch(raw, "%d") do table.insert(t, tonumber(ch)) end
	return t
end

local function keyModel(i)
	local m = monoFolder()
	if m then return m:FindFirstChild("HiddenKey" .. i) end
	return nil
end

local function codePart()
	local m = monoFolder()
	if not m then return nil end
	local cn = m:FindFirstChild("CodeNote", true)
	if cn and cn:IsA("BasePart") then return cn end
	return nil
end

local function digitPart(i)
	local m = monoFolder()
	if not m then return nil end
	local kp = m:FindFirstChild("Keypad")
	if not kp then return nil end
	local d = kp:FindFirstChild("Digit" .. i)
	if d and d:IsA("BasePart") then return d end
	if d then return firstPart(d) end
	return nil
end

local function digitPrompt(i)
	local m = monoFolder()
	if not m then return nil end
	local kp = m:FindFirstChild("Keypad")
	if not kp then return nil end
	for _, v in pairs(kp:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Name == "DigitPrompt" then
			local p = v.Parent
			if p and string.find(p.Name, "Digit" .. i) then return v end
		end
	end
	return nil
end

local function digitValue(i)
	local m = monoFolder()
	if not m then return nil end
	local kp = m:FindFirstChild("Keypad")
	if not kp then return nil end
	local holder = kp:FindFirstChild("Digit" .. i)
	if not holder then return nil end
	for _, v in pairs(holder:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "Digit" then return tonumber(v.Text) end
	end
	return nil
end

local function elevatorPart()
	local m = monoFolder()
	if not m then return nil end
	local e = m:FindFirstChild("Elevator", true)
	if e and e:IsA("BasePart") then return e end
	return nil
end

local function elevatorPrompt()
	local m = monoFolder()
	if not m then return nil end
	for _, v in pairs(m:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Name == "ElevatorPrompt" then return v end
	end
	return nil
end

local function elevatorPos()
	local pr = elevatorPrompt()
	if pr then
		local pos = promptPos(pr)
		if pos then return pos end
	end
	local e = elevatorPart()
	if e then return e.Position end
	return nil
end

local function monsterPart()
	local ver = Workspace:FindFirstChild("VER")
	if ver then
		local r = ver:FindFirstChild("RootPart")
		if r and r:IsA("BasePart") then return r end
		for _, v in pairs(ver:GetDescendants()) do
			if v:IsA("BasePart") then return v end
		end
	end
	local net = Workspace:FindFirstChild("MonsterNetwork")
	if net then
		local ph = net:FindFirstChild("PlaceholderMonster")
		if ph and ph:IsA("BasePart") then return ph end
	end
	return nil
end

local function monsterDist()
	local p = myPos()
	local mp = monsterPart()
	if not p or not mp then return nil end
	return (mp.Position - p).Magnitude
end

local function promptsCalled(name)
	local out = {}
	local m = monoFolder()
	if not m then return out end
	for _, v in pairs(m:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Name == name then table.insert(out, v) end
	end
	return out
end

local function closestPrompt(list)
	local p = myPos()
	if not p then return nil, nil, nil end
	local best, bestD, bestPos = nil, math.huge, nil
	for _, pr in pairs(list) do
		local pos = promptPos(pr)
		if pos then
			local d = (pos - p).Magnitude
			if d < bestD then bestD = d best = pr bestPos = pos end
		end
	end
	return bestPos, best, bestD
end

local S = {
	SpeedOn = false, Walk = 16, Sprint = 26, SprintMax = 225,
	InfStam = false, AllowJump = false, JumpPower = 50, Gravity = 196.2,
	Fov = 85, FovLock = false,
	Noclip = false, Fly = false, FlySpeed = 35,
	ClickTP = false,
	Instant = false, Reach = false, ReachDist = 25,
	Aura = false, AuraDist = 12, AuraExtra = false,
	Bright = false, NoFog = false,
	AntiScare = false, AntiShake = false, AntiStatic = false, AntiFlicker = false,
	CodeHud = true,
	EspKeys = false, EspCode = false, EspPad = false, EspExit = false,
	EspCloset = false, EspLock = false, EspDrawer = false, EspPry = false,
	EspMonster = false, EspPlayers = false,
	EspDist = 800, EspShowM = true,
	Warn = false, WarnDist = 60,
	Autohide = false, AutohideDist = 35, AutoUnhide = false,
	EscapeMode = "Instant TP",
	AutoRunning = false,
}

getgenv().FichaMono = { cfg = S }

local saved = { light = {}, prompt = {} }

local function startSpeedLoop()
	pcall(function() RunService:UnbindFromRenderStep("FichaSpeed") end)
	RunService:BindToRenderStep("FichaSpeed", Enum.RenderPriority.Last.Value + 1, function(dt)
		if not isAlive() then return end
		dt = dt or 0.016
		local h = hum()
		if h and S.SpeedOn then
			h.WalkSpeed = S.Walk
			local c = pfc()
			if c then
				pcall(function()
					c:SetAttribute("WalkSpeed", S.Walk)
					c:SetAttribute("SprintSpeed", S.Sprint)
					c:SetAttribute("SprintMax", S.SprintMax)
				end)
			end
		end
		if S.FovLock then
			pcall(function() Workspace.CurrentCamera.FieldOfView = S.Fov end)
		end
		if S.Fly then
			local r = hrp()
			if r then
				local cam = Workspace.CurrentCamera
				local move = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0, 1, 0) end
				if move.Magnitude > 0.01 then
					r.CFrame = r.CFrame + move.Unit * S.FlySpeed * dt
				end
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end)
end

local function stopSpeedLoop()
	pcall(function() RunService:UnbindFromRenderStep("FichaSpeed") end)
end

track(RunService.Stepped:Connect(function()
	if not isAlive() then return end
	if S.Noclip or S.Fly or S.AutoRunning then
		local c = char()
		if c then
			for _, v in pairs(c:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end
end))

track(UserInputService.InputBegan:Connect(function(inp, gpe)
	if gpe then return end
	if S.ClickTP and inp.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		local cam = Workspace.CurrentCamera
		local mouse = me:GetMouse()
		if cam and mouse then
			local ray = cam:ScreenPointToRay(mouse.X, mouse.Y)
			local hit = Workspace:Raycast(ray.Origin, ray.Direction * 500)
			if hit then tpTo(hit.Position, 3) end
		end
	end
end))

loop(function()
	if S.InfStam then
		pcall(function()
			local hud = myGui:FindFirstChild("SprintStaminaHud")
			if hud then
				local panel = hud:FindFirstChild("SprintPanel", true)
				if panel then
					local f = panel:FindFirstChild("Fill", true)
					if f and f:IsA("Frame") then f.Size = UDim2.fromScale(1, 1) end
				end
			end
			local c = pfc()
			if c then c:SetAttribute("SprintMax", 9999) end
		end)
	end
end, 0.3)

local function setJump(on)
	local ps = me:FindFirstChild("PlayerScripts")
	if not ps then return end
	local nj = ps:FindFirstChild("NoJump")
	if nj then pcall(function() nj.Disabled = on end) end
	local h = hum()
	if h and on then
		h.UseJumpPower = true
		h.JumpPower = S.JumpPower
		h.JumpHeight = 7.2
	end
end

local function savePrompt(pr)
	if not saved.prompt[pr] then
		saved.prompt[pr] = { Hold = pr.HoldDuration, Dist = pr.MaxActivationDistance, LOS = pr.RequiresLineOfSight }
	end
	if S.Instant then pr.HoldDuration = 0 end
	if S.Reach then pr.MaxActivationDistance = S.ReachDist end
	pcall(function() pr.RequiresLineOfSight = false end)
end

local function applyPrompts()
	for _, v in pairs(promptsCalled("KeyPrompt")) do savePrompt(v) end
	for _, v in pairs(promptsCalled("DrawerPrompt")) do savePrompt(v) end
	for _, v in pairs(promptsCalled("PryPrompt")) do savePrompt(v) end
	for _, v in pairs(promptsCalled("DigitPrompt")) do savePrompt(v) end
	for _, v in pairs(promptsCalled("HidePrompt")) do savePrompt(v) end
	for _, v in pairs(promptsCalled("LockPrompt")) do savePrompt(v) end
	local e = elevatorPrompt()
	if e then savePrompt(e) end
end

local function restorePrompts()
	for pr, o in pairs(saved.prompt) do
		pcall(function()
			if not S.Instant then pr.HoldDuration = o.Hold end
			if not S.Reach then pr.MaxActivationDistance = o.Dist end
		end)
	end
end

loop(function()
	if S.Instant or S.Reach then applyPrompts() end
end, 1.5)

local function setBright(on)
	if on then
		if next(saved.light) == nil then
			saved.light = {
				Amb = Lighting.Ambient, Out = Lighting.OutdoorAmbient,
				Br = Lighting.Brightness, Ex = Lighting.ExposureCompensation, Fog = Lighting.FogEnd,
			}
		end
		Lighting.Ambient = Color3.fromRGB(200, 200, 200)
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
		Lighting.Brightness = 2.5
		Lighting.ExposureCompensation = 0.5
		local cc = Lighting:FindFirstChild("HorrorGrade")
		if cc and cc:IsA("ColorCorrectionEffect") then cc.Enabled = false end
		local at = Lighting:FindFirstChildOfClass("Atmosphere")
		if at then at.Density = 0 end
	else
		if saved.light.Amb then Lighting.Ambient = saved.light.Amb end
		if saved.light.Out then Lighting.OutdoorAmbient = saved.light.Out end
		if saved.light.Br then Lighting.Brightness = saved.light.Br end
		if saved.light.Ex then Lighting.ExposureCompensation = saved.light.Ex end
		if saved.light.Fog then Lighting.FogEnd = saved.light.Fog end
		local cc = Lighting:FindFirstChild("HorrorGrade")
		if cc and cc:IsA("ColorCorrectionEffect") then cc.Enabled = true end
	end
end

loop(function()
	if S.AntiScare then
		pcall(function()
			local v = myGui:FindFirstChild("MonsterKillScareView")
			if v then v.Enabled = false end
		end)
	end
	if S.AntiStatic then
		pcall(function()
			local g = myGui:FindFirstChild("PixelStatic")
			if g then g.Enabled = false end
			local ps = me.PlayerScripts:FindFirstChild("PixelStatic")
			if ps then ps.Disabled = true end
			local vhs = me.PlayerScripts:FindFirstChild("AuthenticVHSEffect")
			if vhs then vhs.Disabled = true end
		end)
	end
	if S.AntiShake then
		pcall(function()
			local s = me.PlayerScripts:FindFirstChild("MonsterProximityShake")
			if s then s.Disabled = true end
		end)
	end
	if S.AntiFlicker then
		pcall(function()
			local f = me.PlayerScripts:FindFirstChild("MapLightFlicker")
			if f then f.Disabled = true end
		end)
	end
	if S.NoFog then
		pcall(function()
			Lighting.FogEnd = 100000
			local at = Lighting:FindFirstChildOfClass("Atmosphere")
			if at then at.Density = 0 at.Haze = 0 end
		end)
	end
end, 0.7)

-- ESP hope u like it cuz there is like 1 refresh rate lololol (im joking dw dada)
local espFolder = nil
local function ensureEsp()
	local ok = pcall(function() return espFolder and espFolder.Parent end)
	if espFolder and ok and espFolder.Parent then return espFolder end
	espFolder = Instance.new("Folder")
	espFolder.Name = "FichaESP"
	espFolder.Parent = uiParent()
	return espFolder
end
ensureEsp()
getgenv().FichaMono.espFolder = ensureEsp

local espColors = {
	Keys = Color3.fromRGB(255, 210, 60),
	Code = Color3.fromRGB(90, 220, 255),
	Pad = Color3.fromRGB(170, 130, 255),
	Exit = Color3.fromRGB(90, 255, 140),
	Closet = Color3.fromRGB(255, 150, 90),
	Lock = Color3.fromRGB(255, 110, 110),
	Drawer = Color3.fromRGB(160, 160, 160),
	Pry = Color3.fromRGB(255, 120, 200),
	Monster = Color3.fromRGB(255, 40, 40),
	Player = Color3.fromRGB(110, 255, 170),
}

local function wipeEsp()
	local f = ensureEsp()
	pcall(function() f:ClearAllChildren() end)
end

local function drawTag(part, text, color)
	if not part or not part.Parent then return end
	local p = myPos()
	if p and S.EspDist > 0 then
		if (part.Position - p).Magnitude > S.EspDist then return end
	end
	local f = ensureEsp()
	local bb = Instance.new("BillboardGui")
	bb.Name = "tag"
	bb.Size = UDim2.fromOffset(160, 36)
	bb.StudsOffset = Vector3.new(0, 2.5, 0)
	bb.AlwaysOnTop = true
	bb.MaxDistance = math.huge
	bb.Adornee = part
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.fromScale(1, 1)
	tl.BackgroundTransparency = 1
	tl.TextScaled = true
	tl.Font = Enum.Font.GothamBold
	tl.TextStrokeTransparency = 0.1
	tl.TextColor3 = color
	local d = ""
	if S.EspShowM and p then
		d = string.format(" [%dm]", math.floor((part.Position - p).Magnitude))
	end
	tl.Text = text .. d
	tl.Parent = bb
	bb.Parent = f
	local hl = Instance.new("Highlight")
	hl.FillTransparency = 0.8
	hl.OutlineTransparency = 0.1
	hl.FillColor = color
	hl.OutlineColor = color
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = part
	hl.Parent = f
end

local function anyEspOn()
	return S.EspKeys or S.EspCode or S.EspPad or S.EspExit or S.EspCloset
		or S.EspLock or S.EspDrawer or S.EspPry or S.EspMonster or S.EspPlayers
end

loop(function()
	if not anyEspOn() then
		local f = ensureEsp()
		if #f:GetChildren() > 0 then wipeEsp() end
		return
	end
	wipeEsp()
	pcall(function()
		if S.EspKeys then
			for i = 1, 4 do
				local m = keyModel(i)
				if m then
					local b = firstPart(m)
					local gone = true
					for _, v in pairs(m:GetDescendants()) do
						if v:IsA("ProximityPrompt") and v.Enabled then gone = false break end
					end
					if b and not gone then drawTag(b, "KEY " .. i, espColors.Keys) end
				end
			end
		end
		if S.EspCode then
			local c = codePart()
			if c then drawTag(c, "CODE: " .. readCodeRaw(), espColors.Code) end
		end
		if S.EspPad then
			for i = 1, 4 do
				local b = digitPart(i)
				if b then
					local v = digitValue(i)
					drawTag(b, "PAD " .. i .. (v ~= nil and ("=" .. v) or ""), espColors.Pad)
				end
			end
		end
		if S.EspExit then
			local e = elevatorPart()
			if e then drawTag(e, "EXIT", espColors.Exit) end
		end
		if S.EspCloset then
			for _, pr in pairs(promptsCalled("HidePrompt")) do
				local pos = promptPos(pr)
				local b = anchorPart(pr)
				if b and pos then drawTag(b, "CLOSET", espColors.Closet) end
			end
		end
		if S.EspLock then
			for _, pr in pairs(promptsCalled("LockPrompt")) do
				local b = anchorPart(pr)
				if b then drawTag(b, "LOCK", espColors.Lock) end
			end
		end
		if S.EspDrawer then
			for _, pr in pairs(promptsCalled("DrawerPrompt")) do
				local b = anchorPart(pr)
				if b then drawTag(b, "DRAWER", espColors.Drawer) end
			end
		end
		if S.EspPry then
			for _, pr in pairs(promptsCalled("PryPrompt")) do
				local b = anchorPart(pr)
				if b then drawTag(b, "PRY", espColors.Pry) end
			end
		end
		if S.EspMonster then
			local mp = monsterPart()
			if mp then drawTag(mp, "MONSTER", espColors.Monster) end
		end
		if S.EspPlayers then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= me and plr.Character then
					local r = plr.Character:FindFirstChild("HumanoidRootPart")
					if r and r:IsA("BasePart") then
						drawTag(r, plr.DisplayName, espColors.Player)
					end
				end
			end
		end
	end)
end, 2)

-- HUD for the code so yk its like say the code on top of yo big ahh screen
local hudGui = nil
local function setHud(on)
	if on then
		local alive = false
		pcall(function() alive = hudGui and hudGui.Parent end)
		if hudGui and alive then return end
		local ok, g = pcall(function()
			local s = Instance.new("ScreenGui")
			s.Name = "FichaCodeHud"
			s.ResetOnSpawn = false
			s.DisplayOrder = 9999
			s.IgnoreGuiInset = true
			local bg = Instance.new("TextLabel")
			bg.Name = "Bar"
			bg.Size = UDim2.fromOffset(380, 40)
			bg.Position = UDim2.new(0.5, -190, 0, 10)
			bg.BackgroundTransparency = 0.3
			bg.BackgroundColor3 = Color3.new(0, 0, 0)
			bg.Font = Enum.Font.GothamBold
			bg.TextScaled = true
			bg.TextColor3 = Color3.fromRGB(90, 220, 255)
			bg.TextStrokeTransparency = 0
			bg.Text = "CODE: ..."
			bg.Parent = s
			s.Parent = uiParent()
			return s
		end)
		if ok and g then
			hudGui = g
			task.spawn(function()
				while isAlive() do
					local good = false
					pcall(function() good = hudGui and hudGui.Parent end)
					if not good or not hudGui then break end
					pcall(function()
						local code = readCodeRaw()
						local keys = tostring(me:GetAttribute("Keys") or 0)
						local md = monsterDist()
						local ms = md and (math.floor(md) .. "m") or "?"
						hudGui.Bar.Text = "CODE: " .. code .. "  |  KEYS " .. keys .. "/4  |  MON " .. ms
					end)
					task.wait(1)
				end
				if isAlive() and S.CodeHud then
					hudGui = nil
					task.wait(1)
					if isAlive() and S.CodeHud then setHud(true) end
				end
			end)
		end
	else
		if hudGui then pcall(function() hudGui:Destroy() end) hudGui = nil end
	end
end

-- Auto Farms but they may not work cuz tired rn

local function collectOneKey(i)
	if not S.AutoRunning then return false end
	local m = keyModel(i)
	if not m then return true end -- gone = collected
	local pr = nil
	for _, v in pairs(m:GetDescendants()) do
		if v:IsA("ProximityPrompt") then pr = v break end
	end
	if not pr then return true end
	if not pr.Enabled then return true end
	local pos = promptPos(pr)
	if not pos then
		local b = firstPart(m)
		if b then pos = b.Position end
	end
	if not pos then return false end
	if S.EscapeMode == "Tween (safer)" then tweenTo(pos, 3) else tpTo(pos, 3) end
	task.wait(0.6) -- wait for teleport to land
	pressPrompt(pr)
	task.wait(1.5) -- big wait so the server registers the key
	if not S.AutoRunning then return false end
	return not pr.Enabled
end

local function autoKeys()
	for i = 1, 4 do
		if not S.AutoRunning then return end
		if collectOneKey(i) then
			note("Keys", "got key " .. i, 2)
		end
		task.wait(0.4)
	end
end

-- KeyPad lololol

local function autoKeypad()
	local nums = codeNumbers()
	if #nums < 4 then
		note("Keypad", "couldnt read code, got: " .. readCodeRaw(), 4)
		return false
	end
	local d1 = digitPart(1)
	if d1 then tpTo(d1.Position, 4) end
	task.wait(0.6)
	for i = 1, 4 do
		if not S.AutoRunning then return false end
		local want = nums[i]
		if want == nil then break end
		local pr = digitPrompt(i)
		if not pr then note("Keypad", "no digit prompt " .. i, 3) return false end
		local attempts = 0
		while attempts < 6 do
			if not S.AutoRunning then return false end
			local cur = digitValue(i)
			if cur == want then break end
			pressPrompt(pr)
			task.wait(1.2) -- big wait so server increments
			attempts = attempts + 1
		end
		local final = digitValue(i)
		if final ~= want then
			note("Keypad", "digit " .. i .. " stuck at " .. tostring(final) .. " want " .. want, 4)
			return false
		end
	end
	note("Keypad", "code in: " .. table.concat(nums, " "), 3)
	return true
end

local function autoElevator()
	if not S.AutoRunning then return false end
	local pos = elevatorPos()
	if pos then
		if S.EscapeMode == "Tween (safer)" then tweenTo(pos, 3) else tpTo(pos, 3) end
	end
	task.wait(0.6)
	local pr = elevatorPrompt()
	if not pr then note("Exit", "no elevator prompt found", 3) return false end
	local tries = 0
	while not pr.Enabled and tries < 40 and S.AutoRunning do
		tries = tries + 1
		task.wait(0.5)
	end
	if not pr.Enabled then
		note("Exit", "still locked (keys/code missing?)", 4)
		return false
	end
	pressPrompt(pr)
	task.wait(1)
	if pr.Enabled then pressPrompt(pr) end
	note("Exit", "fired elevator", 4)
	return true
end

local runId = 0
local function fullAutoEscape()
	if S.AutoRunning then note("Auto", "already running, press stop first", 3) return end
	S.AutoRunning = true
	runId = runId + 1
	local myRun = runId
	local wasNoclip = S.Noclip
	S.Noclip = true
	note("Auto escape", "running (" .. S.EscapeMode .. ") - press STOP to cancel", 5)
	task.spawn(function()
		local ok = pcall(function()
			if myRun ~= runId or not S.AutoRunning then return end
			local keys = tonumber(me:GetAttribute("Keys") or 0) or 0
			if keys < 4 then
				note("Auto", "collecting keys...", 3)
				autoKeys()
			end
			if myRun ~= runId or not S.AutoRunning then return end
			note("Auto", "solving keypad...", 3)
			autoKeypad()
			if myRun ~= runId or not S.AutoRunning then return end
			note("Auto", "going elevator...", 3)
			autoElevator()
		end)
		if not ok then note("Auto", "something broke, try again", 3) end
		S.Noclip = wasNoclip
		if myRun == runId then S.AutoRunning = false end
	end)
end

local function stopAutos()
	runId = runId + 1
	S.AutoRunning = false
	note("Auto", "stopped", 2)
end

-- Aura (Auto takes things if u retarded n tired)
local auraCD = {}
loop(function()
	if S.Aura and isAlive() then
		pcall(function()
			local p = myPos()
			if not p then return end
			local list = promptsCalled("KeyPrompt")
			if S.AuraExtra then
				for _, v in pairs(promptsCalled("DrawerPrompt")) do table.insert(list, v) end
				for _, v in pairs(promptsCalled("PryPrompt")) do table.insert(list, v) end
				for _, v in pairs(promptsCalled("LockPrompt")) do table.insert(list, v) end
			end
			for _, pr in pairs(list) do
				if pr.Enabled then
					if os.clock() - (auraCD[pr] or 0) > 3 then
						local pos = promptPos(pr)
						if pos and (pos - p).Magnitude <= S.AuraDist then
							auraCD[pr] = os.clock()
							pressPrompt(pr)
						end
					end
				end
			end
		end)
	end
end, 0.5)

-- monster (idek what else to say)
local lastWarnT = 0
local lastHideT = 0
loop(function()
	local d = monsterDist()
	if not d then return end
	local isMon = me:GetAttribute("IsMonster") == true
	local hiding = me:GetAttribute("HidingIn")

	if S.Warn and d < S.WarnDist and os.clock() - lastWarnT > 6 and not isMon then
		lastWarnT = os.clock()
		note("MONSTER", string.format("%.0fm away, hide!", d), 4)
	end

	if S.Autohide and not isMon and hiding == nil then
		if d < S.AutohideDist and os.clock() - lastHideT > 10 then
			lastHideT = os.clock()
			task.spawn(function()
				if not S.AutoRunning then return end
				local pos, pr = closestPrompt(promptsCalled("HidePrompt"))
				if pos then
					tpTo(pos, 3)
					task.wait(0.4)
					if pr then pressPrompt(pr) end
					note("Auto-hide", string.format("monster %.0fm, hid", d), 4)
				end
			end)
		end
	end

	if S.AutoUnhide and hiding ~= nil and d > 70 then
		local p = myPos()
		if p then tpTo(p + Vector3.new(5, 0, 5), 3) end
	end

	if S.AntiScare then
		pcall(function()
			local v = myGui:FindFirstChild("MonsterKillScareView")
			if v then v.Enabled = false end
		end)
	end
end, 0.5)

-- Anti AFK (added even if u dont need)
local afkConn = nil
local function setAfk(on)
	if on then
		if afkConn then return end
		afkConn = track(me.Idled:Connect(function()
			pcall(function()
				local vu = game:GetService("VirtualUser")
				vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
				task.wait(1)
				vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
			end)
		end))
	else
		if afkConn then pcall(function() afkConn:Disconnect() end) afkConn = nil end
	end
end

-- FOR THE UI MUEHEHEHEHE
local Window = WindUI:CreateWindow({
	Title = "Ficha Hub - Monochrome",
	Author = "@5mhe on discord",
	Icon = "eye",
	Folder = "FichaHubMono",
	Size = UDim2.fromOffset(620, 480),
	Theme = "Dark",
	ToggleKey = Enum.KeyCode.RightShift,
})

local T_Info = Window:Tab({ Title = "Info & Auto", Icon = "info" })
local T_Esp = Window:Tab({ Title = "ESP", Icon = "eye" })
local T_Player = Window:Tab({ Title = "Player", Icon = "zap" })
local T_Mon = Window:Tab({ Title = "Monster", Icon = "ghost" })
local T_Tp = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local T_Misc = Window:Tab({ Title = "Misc", Icon = "settings" })

local function para(tab, t, d)
	local ok, r = pcall(function() return tab:Paragraph({ Title = t, Desc = d }) end)
	if ok then return r end
	return nil
end

local codePara = para(T_Info, "Door code: ...", "press refresh, it reads the paper for u")
local statPara = para(T_Info, "Status", "loading...")
local monPara = para(T_Mon, "Monster: ?", "turn on warning below")

local function refreshCode()
	local raw = readCodeRaw()
	local nums = codeNumbers()
	local nice = #nums > 0 and table.concat(nums, " ") or raw
	if codePara then
		pcall(function() codePara:SetTitle("Door code: " .. nice) end)
		pcall(function() codePara:SetDesc("paper says: " .. raw .. " | put it in the keypad then elevator") end)
	end
	return raw
end

local function refreshStat()
	local keys = tostring(me:GetAttribute("Keys") or "?")
	local lives = tostring(me:GetAttribute("Lives") or "?")
	local md = monsterDist()
	local ms = md and string.format("%.0fm", md) or "?"
	local isM = me:GetAttribute("IsMonster") == true
	local hid = me:GetAttribute("HidingIn")
	if statPara then
		pcall(function() statPara:SetTitle(string.format("Keys %s/4 | Lives %s | Monster %s", keys, lives, ms)) end)
		pcall(function() statPara:SetDesc(string.format("monster u: %s | hiding: %s | code: %s", tostring(isM), tostring(hid), readCodeRaw())) end)
	end
	if monPara then
		pcall(function() monPara:SetTitle("Monster: " .. ms .. (isM and " (U ARE IT)" or "")) end)
	end
end

loop(function()
	refreshStat()
end, 2)

T_Info:Button({ Title = "Refresh code", Desc = "re-read the paper", Callback = function()
	local r = refreshCode() refreshStat()
	note("Code", "paper says: " .. r, 4)
end })

T_Info:Button({ Title = "Copy code", Desc = "clipboard", Callback = function()
	local r = readCodeRaw()
	pcall(function() if typeof(setclipboard) == "function" then setclipboard(r) end end)
	note("Copied", r, 2)
end })

T_Info:Toggle({ Title = "Code HUD (top bar)", Desc = "always shows code + keys + monster", Value = true, Callback = function(v)
	S.CodeHud = v
	setHud(v)
end })

T_Info:Dropdown({ Title = "Escape mode", Desc = "tween looks less blatant than instant", Values = { "Instant TP", "Tween (safer)" }, Value = "Instant TP", Callback = function(v)
	S.EscapeMode = v
end })

T_Info:Button({ Title = "Auto: collect all keys", Desc = "runs to each key for u", Callback = function()
	if S.AutoRunning then note("Auto", "already running", 2) return end
	S.AutoRunning = true
	runId = runId + 1
	local myRun = runId
	task.spawn(function()
		autoKeys()
		if myRun == runId then S.AutoRunning = false end
	end)
end })

T_Info:Button({ Title = "Auto: solve keypad", Desc = "types the code in", Callback = function()
	if S.AutoRunning then note("Auto", "already running", 2) return end
	S.AutoRunning = true
	runId = runId + 1
	local myRun = runId
	task.spawn(function()
		autoKeypad()
		if myRun == runId then S.AutoRunning = false end
	end)
end })

T_Info:Button({ Title = "Auto: elevator only", Desc = "after keys+code are done", Callback = function()
	if S.AutoRunning then note("Auto", "already running", 2) return end
	S.AutoRunning = true
	runId = runId + 1
	local myRun = runId
	task.spawn(function()
		autoElevator()
		if myRun == runId then S.AutoRunning = false end
	end)
end })

T_Info:Button({ Title = "FULL AUTO ESCAPE", Desc = "keys > code > keypad > elevator", Callback = function() fullAutoEscape() end })
T_Info:Button({ Title = "STOP all autos", Desc = "cancels escape / keys / keypad", Callback = function() stopAutos() end })

T_Info:Toggle({ Title = "Interact aura", Desc = "auto grabs keys near u", Value = false, Callback = function(v) S.Aura = v end })
T_Info:Slider({ Title = "Aura distance", Value = { Min = 5, Max = 30, Default = 12 }, Step = 1, Callback = function(v) S.AuraDist = v end })
T_Info:Toggle({ Title = "Aura also drawers + pry + locks", Value = false, Callback = function(v) S.AuraExtra = v end })

T_Esp:Toggle({ Title = "Keys ESP", Value = false, Callback = function(v) S.EspKeys = v end })
T_Esp:Toggle({ Title = "Code note ESP", Value = false, Callback = function(v) S.EspCode = v end })
T_Esp:Toggle({ Title = "Keypad ESP", Value = false, Callback = function(v) S.EspPad = v end })
T_Esp:Toggle({ Title = "Exit ESP", Value = false, Callback = function(v) S.EspExit = v end })
T_Esp:Toggle({ Title = "Closet ESP", Value = false, Callback = function(v) S.EspCloset = v end })
T_Esp:Toggle({ Title = "Lock ESP", Value = false, Callback = function(v) S.EspLock = v end })
T_Esp:Toggle({ Title = "Drawer ESP (laggy, 28 of em)", Value = false, Callback = function(v) S.EspDrawer = v end })
T_Esp:Toggle({ Title = "Pry ESP", Value = false, Callback = function(v) S.EspPry = v end })
T_Esp:Toggle({ Title = "Monster ESP", Value = false, Callback = function(v) S.EspMonster = v end })
T_Esp:Toggle({ Title = "Players ESP", Value = false, Callback = function(v) S.EspPlayers = v end })
T_Esp:Slider({ Title = "ESP max distance", Value = { Min = 100, Max = 3000, Default = 800 }, Step = 50, Callback = function(v) S.EspDist = v end })
T_Esp:Toggle({ Title = "Show distance [123m]", Value = true, Callback = function(v) S.EspShowM = v end })
T_Esp:Button({ Title = "Clear ESP", Callback = function() wipeEsp() end })

T_Player:Toggle({ Title = "Custom speed", Desc = "RenderStep Last so it sticks", Value = false, Callback = function(v)
	S.SpeedOn = v
	if v then startSpeedLoop() else stopSpeedLoop() startSpeedLoop() end
end })
T_Player:Slider({ Title = "Walk speed", Value = { Min = 9, Max = 60, Default = 16 }, Step = 1, Callback = function(v) S.Walk = v end })
T_Player:Slider({ Title = "Sprint speed", Value = { Min = 9, Max = 60, Default = 26 }, Step = 1, Callback = function(v) S.Sprint = v end })
T_Player:Slider({ Title = "Sprint max (stam pool)", Value = { Min = 50, Max = 9999, Default = 225 }, Step = 5, Callback = function(v) S.SprintMax = v end })
T_Player:Toggle({ Title = "Infinite stamina", Value = false, Callback = function(v) S.InfStam = v end })
T_Player:Toggle({ Title = "Allow jump (kills NoJump)", Value = false, Callback = function(v)
	S.AllowJump = v
	setJump(v)
end })
T_Player:Slider({ Title = "Jump power", Value = { Min = 20, Max = 120, Default = 50 }, Step = 1, Callback = function(v)
	S.JumpPower = v
	if S.AllowJump then setJump(true) end
end })
T_Player:Slider({ Title = "Gravity", Value = { Min = 50, Max = 300, Default = 196 }, Step = 1, Callback = function(v)
	S.Gravity = v
	pcall(function() Workspace.Gravity = v end)
end })
T_Player:Slider({ Title = "FOV", Value = { Min = 70, Max = 120, Default = 85 }, Step = 1, Callback = function(v)
	S.Fov = v
	pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
end })
T_Player:Toggle({ Title = "Lock FOV", Value = false, Callback = function(v) S.FovLock = v end })
T_Player:Toggle({ Title = "Noclip", Value = false, Callback = function(v) S.Noclip = v end })
T_Player:Toggle({ Title = "Fly (WASD + E/Q)", Value = false, Callback = function(v)
	S.Fly = v
	if v then note("Fly", "WASD move, E up Q down", 3) end
end })
T_Player:Slider({ Title = "Fly speed", Value = { Min = 10, Max = 120, Default = 35 }, Step = 1, Callback = function(v) S.FlySpeed = v end })
T_Player:Toggle({ Title = "Instant interact (no hold)", Value = false, Callback = function(v)
	S.Instant = v
	if v then applyPrompts() else restorePrompts() end
end })
T_Player:Toggle({ Title = "Long reach", Value = false, Callback = function(v)
	S.Reach = v
	if v then applyPrompts() else restorePrompts() end
end })
T_Player:Slider({ Title = "Reach distance", Value = { Min = 10, Max = 50, Default = 25 }, Step = 1, Callback = function(v)
	S.ReachDist = v
	if S.Reach then applyPrompts() end
end })
T_Player:Toggle({ Title = "Ctrl+Click teleport", Desc = "hold ctrl and click the floor", Value = false, Callback = function(v) S.ClickTP = v end })
T_Player:Button({ Title = "Reset speed to normal", Callback = function()
	S.SpeedOn = false
	stopSpeedLoop()
	local h = hum()
	if h then h.WalkSpeed = 9 end
	local c = pfc()
	if c then pcall(function() c:SetAttribute("WalkSpeed", 9) c:SetAttribute("SprintSpeed", 22) c:SetAttribute("SprintMax", 225) end) end
	note("Speed", "back to 9 / 22", 2)
end })

T_Mon:Toggle({ Title = "Monster warning", Value = false, Callback = function(v) S.Warn = v end })
T_Mon:Slider({ Title = "Warn distance", Value = { Min = 20, Max = 150, Default = 60 }, Step = 1, Callback = function(v) S.WarnDist = v end })
T_Mon:Toggle({ Title = "Auto-hide in closet", Desc = "tps u in when monster close", Value = false, Callback = function(v) S.Autohide = v end })
T_Mon:Slider({ Title = "Auto-hide distance", Value = { Min = 15, Max = 100, Default = 35 }, Step = 1, Callback = function(v) S.AutohideDist = v end })
T_Mon:Toggle({ Title = "Auto unhide when far", Desc = "steps out when monster 70m+", Value = false, Callback = function(v) S.AutoUnhide = v end })
T_Mon:Button({ Title = "HIDE NOW", Desc = "closest closet", Callback = function()
	local pos, pr = closestPrompt(promptsCalled("HidePrompt"))
	if pos then
		tpTo(pos, 3)
		task.wait(0.3)
		if pr then pressPrompt(pr) end
	else note("Hide", "no closet found", 3) end
end })
T_Mon:Button({ Title = "Unhide / step out", Callback = function()
	local p = myPos()
	if p then tpTo(p + Vector3.new(6, 0, 6), 3) end
end })
T_Mon:Button({ Title = "Where is monster?", Callback = function()
	local mp = monsterPart()
	local p = myPos()
	if mp and p then
		local d = (mp.Position - p).Magnitude
		note("Monster", string.format("%.0fm. %s", d, d < 40 and "HIDE NOW" or "ur fine"), 4)
	else note("Monster", "not found (lobby?)", 3) end
end })
T_Mon:Toggle({ Title = "Anti jumpscare", Value = false, Callback = function(v) S.AntiScare = v end })
T_Mon:Toggle({ Title = "Anti shake", Value = false, Callback = function(v)
	S.AntiShake = v
	if v then pcall(function()
		local s = me.PlayerScripts:FindFirstChild("MonsterProximityShake")
		if s then s.Disabled = true end
	end) end
end })
T_Mon:Toggle({ Title = "Anti static / grain", Value = false, Callback = function(v)
	S.AntiStatic = v
	if v then pcall(function()
		local g = myGui:FindFirstChild("PixelStatic")
		if g then g.Enabled = false end
	end) end
end })
T_Mon:Toggle({ Title = "Anti light flicker", Value = false, Callback = function(v) S.AntiFlicker = v end })

for i = 1, 4 do
	local idx = i
	T_Tp:Button({ Title = "TP to key " .. idx, Callback = function()
		local m = keyModel(idx)
		if m then
			local pr = nil
			for _, v in pairs(m:GetDescendants()) do
				if v:IsA("ProximityPrompt") then pr = v break end
			end
			local pos = pr and promptPos(pr) or nil
			if not pos then
				local b = firstPart(m)
				if b then pos = b.Position end
			end
			if pos then
				if S.EscapeMode == "Tween (safer)" then tweenTo(pos, 3) else tpTo(pos, 3) end
			else note("TP", "key " .. idx .. " gone (collected?)", 3) end
		else note("TP", "key " .. idx .. " missing", 3) end
	end })
end
T_Tp:Button({ Title = "TP to code note", Callback = function()
	local c = codePart()
	if c then tpTo(c.Position, 4) note("TP", "code: " .. readCodeRaw(), 3) end
end })
T_Tp:Button({ Title = "TP to keypad", Callback = function()
	local d = digitPart(1)
	if d then tpTo(d.Position, 4) end
end })
T_Tp:Button({ Title = "TP to elevator / exit", Callback = function()
	local pos = elevatorPos()
	if pos then tpTo(pos, 3) end
end })
T_Tp:Button({ Title = "TP to nearest closet", Callback = function()
	local pos = closestPrompt(promptsCalled("HidePrompt"))
	if pos then tpTo(pos, 3) end
end })
T_Tp:Button({ Title = "TP to safest closet", Desc = "farthest from monster", Callback = function()
	local mp = monsterPart()
	local list = promptsCalled("HidePrompt")
	if #list == 0 then return end
	if not mp then
		local pos = closestPrompt(list)
		if pos then tpTo(pos, 3) end
		return
	end
	local best, bestD = nil, -1
	for _, pr in pairs(list) do
		local pos = promptPos(pr)
		if pos then
			local d = (pos - mp.Position).Magnitude
			if d > bestD then bestD = d best = pos end
		end
	end
	if best then tpTo(best, 3) note("TP", "safest closet", 2) end
end })
T_Tp:Button({ Title = "TP to monster (risky lol)", Callback = function()
	local mp = monsterPart()
	if mp then tpTo(mp.Position + Vector3.new(0, 0, 10), 3) end
end })
T_Tp:Button({ Title = "TP to nearest player", Callback = function()
	local p = myPos()
	if not p then return end
	local best, bestD = nil, math.huge
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= me and plr.Character then
			local r = plr.Character:FindFirstChild("HumanoidRootPart")
			if r then
				local d = (r.Position - p).Magnitude
				if d < bestD then bestD = d best = r.Position end
			end
		end
	end
	if best then tpTo(best, 4) else note("TP", "nobody else here", 3) end
end })
T_Tp:Button({ Title = "Grab nearest key (no tp)", Desc = "fires it from far if reach is on", Callback = function()
	local p = myPos()
	if not p then return end
	local best, bestD = nil, math.huge
	for i = 1, 4 do
		local m = keyModel(i)
		if m then
			for _, v in pairs(m:GetDescendants()) do
				if v:IsA("ProximityPrompt") and v.Enabled then
					local pos = promptPos(v)
					if pos then
						local d = (pos - p).Magnitude
						if d < bestD then bestD = d best = v end
					end
				end
			end
		end
	end
	if best then pressPrompt(best) note("Key", string.format("fired (%.0fm)", bestD), 2)
	else note("Key", "all collected already", 3) end
end })

T_Misc:Toggle({ Title = "Fullbright", Value = false, Callback = function(v)
	S.Bright = v
	setBright(v)
end })
T_Misc:Toggle({ Title = "No fog", Value = false, Callback = function(v) S.NoFog = v end })
T_Misc:Button({ Title = "FPS boost", Desc = "grain + shadows off", Callback = function()
	pcall(function()
		local g = myGui:FindFirstChild("PixelStatic")
		if g then g.Enabled = false end
	end)
	pcall(function() Lighting.GlobalShadows = false end)
	pcall(function()
		for _, v in pairs(Workspace:GetDescendants()) do
			if v:IsA("MeshPart") then v.RenderFidelity = Enum.RenderFidelity.Performance end
		end
	end)
	note("Perf", "boosted", 2)
end })
T_Misc:Toggle({ Title = "Anti AFK", Value = false, Callback = function(v) setAfk(v) end })
T_Misc:Button({ Title = "Unlock mouse", Desc = "for clicking UI", Callback = function()
	pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
end })
T_Misc:Button({ Title = "Copy JobId", Callback = function()
	pcall(function() if typeof(setclipboard) == "function" then setclipboard(game.JobId) end end)
	note("JobId", game.JobId, 3)
end })
T_Misc:Button({ Title = "Copy join script", Callback = function()
	pcall(function()
		if typeof(setclipboard) == "function" then
			setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")')
		end
	end)
	note("Copied", "join script", 2)
end })
T_Misc:Button({ Title = "Rejoin", Callback = function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, me)
end })
T_Misc:Button({ Title = "Server hop", Callback = function()
	TeleportService:Teleport(game.PlaceId, me)
end })
T_Misc:Button({ Title = "Unload hub", Desc = "kills everything + restores", Callback = function()
	stopAutos()
	wipeEsp()
	setHud(false)
	setBright(false)
	restorePrompts()
	stopSpeedLoop()
	setAfk(false)
	local h = hum()
	if h then h.WalkSpeed = 9 end
	local c = pfc()
	if c then pcall(function() c:SetAttribute("WalkSpeed", 9) c:SetAttribute("SprintSpeed", 22) c:SetAttribute("SprintMax", 225) end) end
	pcall(function() if espFolder then espFolder:Destroy() end end)
	getgenv().FichaMono = nil
	getgenv().FichaMonoLoaded = false
	killAll()
	pcall(function() Window:Destroy() end)
end })

-- re-apply stuff after respawn cuz roblox is retarded asf
track(me.CharacterAdded:Connect(function()
	task.wait(1)
	if not isAlive() then return end
	if S.AllowJump then setJump(true) end
	pcall(function() Workspace.Gravity = S.Gravity end)
	ensureEsp()
	if S.CodeHud then setHud(true) end
end))

startSpeedLoop()
refreshCode()
refreshStat()
setHud(S.CodeHud)
note("Ficha Hub", "loaded. code: " .. readCodeRaw() .. " | RightShift = menu", 6)
print("[ficha] monochrome loaded. code:", readCodeRaw())
