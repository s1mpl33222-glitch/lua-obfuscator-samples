-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t2 = {
	value1 = game:GetService("TweenService")
}
local Players = game:GetService("Players")

t2.value2 = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	return
end

LocalPlayer:WaitForChild("PlayerGui")

local t1 = {
	value1 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
}
local t3 = {
	value1 = t1.value1
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
t1.value2 = t3.value1
t1.value5 = "The strongest battleground" .. t3.value1.Version
t1.value11 = UDim2.fromOffset(580, 460)
t1.value12 = t1.value2.CreateWindow
t1.value14 = Enum.KeyCode.LeftControl
t1.value12 = t1.value12(t1.value2, {
	Title = t1.value5,
	SubTitle = "By Diablo",
	TabWidth = 160,
	Size = t1.value11,
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = t1.value14
})
t3.value2 = t1.value12
t1.value5 = t3.value2:AddTab({
	Title = "Misc",
	Icon = "box"
})
t1.value7 = t3.value2:AddTab({
	Title = "Local",
	Icon = "user"
})
t1.value8 = t3.value2:AddTab({
	Title = "Esp",
	Icon = "eye"
})
t1.value6 = t3.value2:AddTab({
	Title = "Dummy",
	Icon = "target"
})
t1.value9 = t3.value2:AddTab({
	Title = "Tech",
	Icon = "cpu"
})
t1.value13 = t3.value2:AddTab({
	Title = "Auto",
	Icon = "play"
})
t1.value14 = t3.value2:AddTab({
	Title = "Server",
	Icon = "server"
})
t1.value15 = t3.value2:AddTab({
	Title = "Auto Block",
	Icon = "shield"
})
t1.value16 = t3.value2:AddTab({
	Title = "Admin",
	Icon = "lock"
})
t1.value18 = t3.value2:AddTab({
	Title = "Movements",
	Icon = "move"
})
t1.value21 = t3.value2:AddTab({
	Title = "Others",
	Icon = "more-horizontal"
})
t1.value23 = t3.value2:AddTab({
	Title = "Settings",
	Icon = "settings"
})
t1.value12 = {
	Misc = t1.value5,
	Local = t1.value7,
	Esp = t1.value8,
	Dummy = t1.value6,
	Tech = t1.value9,
	Auto = t1.value13,
	Server = t1.value14,
	AutoBlock = t1.value15,
	Admin = t1.value16,
	Movements = t1.value18,
	Others = t1.value21,
	Settings = t1.value23
}
t1.value3 = t3.value1.Options
t3.value1:Notify({
	Title = "Diablo",
	Content = "The script has been loaded successfully.",
	Duration = 8
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()
end

t1.value5(t1.value4, {
	Title = "M1 Reach",
	Description = "Enable M1 Reach functionality",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/Aimbot/refs/heads/main/Tsb-Aimbot"))()
end

t1.value5(t1.value4, {
	Title = "FaceLock",
	Description = "Enable FaceLock aimbot",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/AutofarmTsb/refs/heads/main/TsbAutofarmToggleStick"))()
end

t1.value4:AddButton({
	Title = "Auto-Farm",
	Description = "Toggle auto-farming",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Block%20Aimlock"))()
end

t1.value5(t1.value4, {
	Title = "Block Aimlock-Progress",
	Description = "Enable block aimlock (in progress)",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Orbit%20by%20YQANTG"))()
end

t1.value5(t1.value4, {
	Title = "Orbit-Progress",
	Description = "Enable orbit feature (in progress)",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Fake%20Dash%20Q"))()
end

t1.value5(t1.value4, {
	Title = "Fake Dash (Q)",
	Description = "Enable fake dash on Q (in progress)",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/No-endlag-side-dash/refs/heads/main/No%20endlag%20side%20dash"))()
end

t1.value5(t1.value4, {
	Title = "No Slide Dash EndLag",
	Description = "Remove slide dash end lag (in progress)",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Delta-Scripts/refs/heads/main/MobileKeyboard.txt"))()
end

t1.value5(t1.value4, {
	Title = "Keyboard",
	Description = "Enable mobile keyboard support",
	Callback = t1.value11
})
t1.value4 = t1.value12.Misc
t1.value5 = t1.value4.AddButton

function t1.value11()
	loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
end

t1.value5(t1.value4, {
	Title = "Invisible-Fe",
	Description = "Enable invisibility (FE)",
	Callback = t1.value11
})
t1.value4 = game.Players.LocalPlayer
t3.value3 = t1.value4
t1.value7 = t3.value3.Character
t1.value4 = t1.value7

if not t1.value7 then
	t1.value4 = t3.value3.CharacterAdded:Wait()
end

t3.value4 = t1.value4
t1.value4 = t3.value4
t1.value7 = t1.value4.WaitForChild
t1.value7 = t1.value7(t1.value4, "Humanoid")
t3.value5 = t1.value7
t3.value6 = false
t3.value7 = nil
t3.value8 = {}
t3.value9 = nil
t3.value10 = 0

function t1.value9()
	local Animation = Instance.new("Animation")

	Animation.AnimationId = "rbxassetid://114586157428274"
	t3.value5:LoadAnimation(Animation):Play()
	t3.value7 = Instance.new("Highlight")
	t3.value7.Adornee = t3.value4
	t3.value7.FillTransparency = 1
	t3.value7.OutlineTransparency = 0
	t3.value7.OutlineColor = Color3.fromRGB(255, 0, 255)
	t3.value7.Parent = t3.value4

	for _, v in pairs({ "UpperTorso", "LowerTorso", "HumanoidRootPart" }) do
		local v10 = t3.value4:FindFirstChild(v)

		if v10 then
			local Attachment = Instance.new("Attachment", v10)
			local ParticleEmitter = Instance.new("ParticleEmitter", Attachment)

			ParticleEmitter.Name = "DarkAura"
			ParticleEmitter.Rate = 30
			ParticleEmitter.Lifetime = NumberRange.new(1.2, 2)
			ParticleEmitter.Speed = NumberRange.new(2, 5)
			ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0) })
			ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
			ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(15, 15, 15))
			ParticleEmitter.Rotation = NumberRange.new(0, 360)
			ParticleEmitter.RotSpeed = NumberRange.new(-90, 90)
			ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
			ParticleEmitter.ZOffset = -1

			local value8 = t3.value8

			table.insert(value8, ParticleEmitter)
		end
	end

	t3.value9 = game:GetService("RunService").RenderStepped:Connect(function(dt)
		local value6 = t3.value6

		if value6 then
			value6 = t3.value7
		end

		if not value6 then
			return
		end

		local v15 = t3

		v15.value10 = v15.value10 + dt * 0.25

		local value10 = t3.value10
		local v17 = math.sin(value10) * 127 + 128
		local v18 = math.sin(t3.value10 + 2)
		local math_ = math
		local v20 = v18 * 127 + 128
		local v21 = math_.sin(t3.value10 + 4) * 127 + 128

		t3.value7.OutlineColor = Color3.fromRGB(v17, v20, v21)
	end)
end

t3.value9 = nil

function t1.value10()
	if not t3.value7 then
		for _, v in pairs(t3.value8) do
			if v then
				v:Destroy()
			end
		end

		if not t3.value9 then
			return
		end

		t3.value9:Disconnect()

		return
	end

	t3.value7:Destroy()

	for _, v in pairs(t3.value8) do
		if v then
			v:Destroy()
		end
	end

	if not t3.value9 then
		return
	end

	t3.value9:Disconnect()
end

t3.value11 = t1.value9
t3.value12 = t1.value10
t1.value10 = t1.value12.Local
t1.value13 = t1.value10.AddToggle

function t1.value18(p1)
	t3.value6 = p1

	if p1 then
		t3.value11()
	else
		t3.value12()
	end
end

t1.value13(t1.value10, "AuraToggle", {
	Title = "Aura (Client)",
	Default = false,
	Callback = t1.value18
})
t3.value13 = false
t3.value14 = "rbxassetid://10470389827"
t3.value15 = nil

function t1.value15(p2)
	for _, v in ipairs(p2:GetPlayingAnimationTracks()) do
		local Animation = v.Animation

		if Animation then
			Animation = v.Animation.AnimationId == t3.value14
		end

		if Animation then
			v:Stop()
			v:Destroy()
		end
	end
end

t3.value16 = nil

function t1.value16()
	if t3.value15 then
		t3.value15:Disconnect()
	end

	if not t3.value16 then
		return
	end

	task.cancel(t3.value16)
end

t3.value17 = nil

function t1.value19()
	local Character = t3.value3.Character or t3.value3.CharacterAdded:Wait()
	local v30 = Character.WaitForChild(Character, "Humanoid")

	task.spawn(function()
		while true do
			local value13 = t3.value13

			if value13 then
				value13 = v30

				if value13 then
					value13 = v30.Parent
				end
			end

			if not value13 then
				return
			end

			t3.value17(v30)
			task.wait(0.05)
		end
	end)
	v30.AnimationPlayed:Connect(function(p3)
		local Animation = p3.Animation

		if Animation then
			Animation = p3.Animation.AnimationId == t3.value14
		end

		if not Animation then
			return
		end

		p3:Stop()
		p3:Destroy()
	end)
end

t3.value17 = t1.value15
t3.value18 = t1.value19
t3.value19 = t1.value16
t1.value16 = t1.value12.Local
t1.value17 = t1.value16.AddToggle

function t1.value25(p4)
	t3.value13 = p4

	if not p4 then
		t3.value19()

		return
	end

	t3.value18()
	t3.value3.CharacterAdded:Connect(function()
		if not t3.value13 then
			return
		end

		task.wait(1)
		t3.value18()
	end)
end

t1.value17(t1.value16, "InvisibleBlockToggle", {
	Title = "Invisible Block",
	Default = false,
	Callback = t1.value25
})

function t1.value17()
	_G.StunBypass = game:GetService("RunService").RenderStepped:Connect(function()
		local Character = game.Players.LocalPlayer.Character

		if not Character then
			return
		end

		if Character:FindFirstChild("Stunned") then
			Character.Stunned:Destroy()
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if not Humanoid then
			return
		end

		Humanoid.PlatformStand = false

		if Humanoid.WalkSpeed ~= 0 then
			return
		end

		Humanoid.WalkSpeed = 16
	end)
end
function t1.value18()
	if not _G.StunBypass then
		return
	end

	_G.StunBypass:Disconnect()
	_G.StunBypass = nil
end

t3.value20 = t1.value17
t3.value21 = t1.value18
t1.value18 = t1.value12.Local
t1.value20 = t1.value18.AddToggle

function t1.value26(p5)
	if p5 then
		t3.value20()
	else
		t3.value21()
	end
end

t1.value20(t1.value18, "NoStunToggle", {
	Title = "No Stun",
	Default = false,
	Callback = t1.value26
})

function t1.value21()
	if not _G.NoSlowLoop then
		return
	end

	_G.NoSlowLoop:Disconnect()
	_G.NoSlowLoop = nil
end

t3.value22 = t1.value21
t1.value21 = t1.value12.Local
t1.value22 = t1.value21.AddToggle

function t1.value28(p6)
	if not p6 then
		t3.value22()

		return
	end

	_G.NoSlowLoop = game:GetService("RunService").RenderStepped:Connect(function()
		local Character = game.Players.LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChild("Humanoid")

		if not Humanoid then
			return
		end

		if Humanoid.WalkSpeed < 20 then
			Humanoid.WalkSpeed = 20
		end

		Humanoid.PlatformStand = false
	end)
end

t1.value22(t1.value21, "NoSlowedToggle", {
	Title = "No Slowed",
	Default = false,
	Callback = t1.value28
})
t1.value24 = t1.value12.Local

function t1.value31(p7)
	local Players2 = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LocalPlayer2 = Players2.LocalPlayer

	if not LocalPlayer2.Character then
		LocalPlayer2.CharacterAdded:Wait()
	end

	local t4 = { "12447707844", "12342141464", "12772543293" }

	local function v41(p8)
		for _, v in pairs(t4) do
			if p8:find(v) then
				return true
			end
		end

		return false
	end

	if _G.BlockAnimConnection then
		_G.BlockAnimConnection:Disconnect()
		_G.BlockAnimConnection = nil
	end

	if not p7 then
		return
	end

	_G.BlockAnimConnection = RunService.Stepped:Connect(function()
		if not p7 then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

		if not Animator then
			return
		end

		for _, v in ipairs(Animator:GetPlayingAnimationTracks()) do
			local Animation = v.Animation
			local v50

			if Animation then
				v50 = v41(Animation.AnimationId)
			else
				v50 = Animation
			end

			if v50 then
				v:Stop(0)
				pcall(function()
					v:Destroy()
				end)
				print("Blocked animation: " .. Animation.AnimationId)
			end
		end
	end)
end

t1.value24:AddToggle("NoAnimUltToggle", {
	Title = "No Anim Ult",
	Default = false,
	Callback = t1.value31
})
t1.value24 = t1.value12.Local
t1.value25 = t1.value24.AddToggle

function t1.value31(p9)
	local Players2 = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer2 = Players2.LocalPlayer
	local CurrentCamera = Workspace.CurrentCamera

	if _G.FaceCamConnection then
		_G.FaceCamConnection:Disconnect()
		_G.FaceCamConnection = nil
	end

	if not p9 then
		return
	end

	_G.FaceCamConnection = RunService.RenderStepped:Connect(function()
		local Character = LocalPlayer2.Character

		if Character then
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				local LookVector = CurrentCamera.CFrame.LookVector
				local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit

				HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Unit)

				return
			else
				return
			end
		end
	end)
end

t1.value25(t1.value24, "FaceCameraYToggle", {
	Title = "Face Camera Y",
	Default = false,
	Callback = t1.value31
})
t3.value23 = nil

function t1.value27(p10)
	if p10 == t3.value3 then
	elseif t3.value23[p10] then
		return
	else
		local Head = p10:FindFirstChild("Head")

		if Head then
			local BillboardGui = Instance.new("BillboardGui")

			BillboardGui.Name = "NameESP"
			BillboardGui.Size = UDim2.new(0, 100, 0, 20)
			BillboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
			BillboardGui.AlwaysOnTop = true
			BillboardGui.Adornee = Head
			BillboardGui.Parent = Head

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p10.Name
			TextLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
			TextLabel.TextStrokeTransparency = 0.4
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Parent = BillboardGui
			t3.value23[p10] = BillboardGui

			return
		else
			return
		end
	end
end

t3.value24 = false
t3.value25 = {}
t3.value23 = {}

function t1.value29()
	for _, v in pairs(t3.value23) do
		if v then
			v:Destroy()
		end
	end

	for _, v in ipairs(t3.value25) do
		if v then
			v:Disconnect()
		end
	end

	t3.value25 = {}
end

t3.value26 = t1.value27

local function v67()
	local ipairs_ = ipairs
	local Players2 = game.Players

	for _, player in ipairs_(Players2.GetPlayers(Players2)) do
		if player.Character then
			t3.value26(player.Character)
		end
	end

	table.insert(t3.value25, game.Players.PlayerAdded:Connect(function(player)
		local function v72(character)
			character:FindFirstChild("Head")

			repeat
				task.wait()
			until character:FindFirstChild("Head")

			t3.value26(character)
		end

		player.CharacterAdded:Connect(v72)
	end))

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= t3.value3 then
			table.insert(t3.value25, player.CharacterAdded:Connect(function(character)
				character:FindFirstChild("Head")

				repeat
					task.wait()
				until character:FindFirstChild("Head")

				t3.value26(character)
			end))
		end
	end
end

t3.value27 = t1.value29
t1.value29 = t1.value12.Esp
t1.value30 = t1.value29.AddToggle

function t1.value35(p11)
	t3.value24 = p11

	if p11 then
		v67()
	else
		t3.value27()
	end
end

t1.value30(t1.value29, "ESPNameToggle", {
	Title = "ESP Name",
	Default = false,
	Callback = t1.value35
})
t3.value28 = nil
t3.value29 = false

function t1.value32(p12, p13)
	if p13 == t3.value3 then
	elseif t3.value28[p13] then
		return
	else
		local Highlight = Instance.new("Highlight")

		Highlight.Name = "PlayerHighlight"
		Highlight.Adornee = p12
		Highlight.FillTransparency = 1
		Highlight.OutlineTransparency = 0
		Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
		Highlight.Parent = p12
		t3.value28[p13] = Highlight

		return
	end
end

t3.value30 = {}
t3.value28 = {}
t3.value31 = nil

function t1.value33()
	local ipairs_ = ipairs
	local Players2 = game.Players

	for _, player in ipairs_(Players2.GetPlayers(Players2)) do
		if player.Character then
			t3.value31(player.Character, player)
		end
	end

	local value30 = t3.value30
	local PlayerAdded = game.Players.PlayerAdded

	local function v82(p14)
		local value302 = t3.value30
		local CharacterAdded = p14.CharacterAdded

		local function v85(p15)
			p15:FindFirstChild("HumanoidRootPart")

			repeat
				task.wait()
			until p15:FindFirstChild("HumanoidRootPart")

			t3.value31(p15, p14)
		end

		table.insert(value302, CharacterAdded:Connect(v85))
	end

	table.insert(value30, PlayerAdded:Connect(v82))

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= t3.value3 then
			table.insert(t3.value30, player.CharacterAdded:Connect(function(character)
				character:FindFirstChild("HumanoidRootPart")

				repeat
					task.wait()
				until character:FindFirstChild("HumanoidRootPart")

				t3.value31(character, player)
			end))
		end
	end
end
function t1.value34()
	for _, v in pairs(t3.value28) do
		if v then
			v:Destroy()
		end
	end

	for _, v in ipairs(t3.value30) do
		if v then
			v:Disconnect()
		end
	end
end

t3.value31 = t1.value32
t3.value32 = t1.value33
t3.value33 = t1.value34
t1.value34 = t1.value12.Esp

function t1.value40(p16)
	t3.value29 = p16

	if p16 then
		t3.value32()
	else
		t3.value33()
	end
end

t1.value34:AddToggle("HighlightToggle", {
	Title = "Highlight",
	Default = false,
	Callback = t1.value40
})
t3.value34 = false
t3.value35 = {}
t3.value36 = {}

function t1.value36(p17)
	if p17 == t3.value3 then
	elseif t3.value35[p17] then
		return
	elseif p17.Character then
		local HumanoidRootPart = p17.Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local BoxHandleAdornment = Instance.new("BoxHandleAdornment")

			BoxHandleAdornment.Name = "PurpleBox"
			BoxHandleAdornment.Adornee = HumanoidRootPart
			BoxHandleAdornment.AlwaysOnTop = true
			BoxHandleAdornment.ZIndex = 5
			BoxHandleAdornment.Size = Vector3.new(2, 2, 1)
			BoxHandleAdornment.Color3 = Color3.fromRGB(170, 0, 255)
			BoxHandleAdornment.Transparency = 0.3
			BoxHandleAdornment.Parent = HumanoidRootPart
			t3.value35[p17] = BoxHandleAdornment

			return
		else
			return
		end
	else
		return
	end
end

t3.value37 = nil

function t1.value37()
	local pairs_ = pairs
	local Players2 = game.Players

	for _, player in pairs_(Players2.GetPlayers(Players2)) do
		if player.Character then
			t3.value37(player)
		end
	end

	table.insert(t3.value36, game.Players.PlayerAdded:Connect(function(player)
		local value36 = t3.value36
		local CharacterAdded = player.CharacterAdded

		local function v100(p18)
			p18:FindFirstChild("HumanoidRootPart")

			repeat
				task.wait()
			until p18:FindFirstChild("HumanoidRootPart")

			t3.value37(player)
		end

		table.insert(value36, CharacterAdded:Connect(v100))
	end))

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= t3.value3 then
			table.insert(t3.value36, player.CharacterAdded:Connect(function(character)
				character:FindFirstChild("HumanoidRootPart")

				repeat
					task.wait()
				until character:FindFirstChild("HumanoidRootPart")

				t3.value37(player)
			end))
		end
	end
end

t3.value37 = t1.value36

function t1.value38()
	for _, v in pairs(t3.value35) do
		if v then
			v:Destroy()
		end
	end

	for _, v in ipairs(t3.value36) do
		if v then
			v:Disconnect()
		end
	end
end

t3.value38 = t1.value37
t3.value39 = t1.value38
t1.value38 = t1.value12.Esp
t1.value39 = t1.value38.AddToggle

function t1.value45(p19)
	t3.value34 = p19

	if p19 then
		t3.value38()
	else
		t3.value39()
	end
end

t1.value39(t1.value38, "ShowHRPToggle", {
	Title = "Show HRP",
	Default = false,
	Callback = t1.value45
})
t3.value40 = nil
t3.value41 = nil

function t1.value40()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "PlayerCountGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = t3.value3:WaitForChild("PlayerGui")
	t3.value41 = Instance.new("TextLabel")
	t3.value41.Size = UDim2.new(0, 220, 0, 50)
	t3.value41.Position = UDim2.new(0.5, -100, 0, 50)
	t3.value41.BackgroundTransparency = 1
	t3.value41.TextColor3 = Color3.new(1, 1, 1)
	t3.value41.TextStrokeTransparency = 0.2
	t3.value41.TextStrokeColor3 = Color3.new(0, 0, 0)
	t3.value41.TextScaled = true
	t3.value41.Font = Enum.Font.GothamBlack
	t3.value41.TextTransparency = 1
	t3.value41.Text = "Players: " .. #game.Players:GetPlayers()
	t3.value41.Parent = ScreenGui
	t2.value1:Create(t3.value41, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()
	t3.value40 = t2.value2.RenderStepped:Connect(function()
		if not t3.value41 then
			return
		end

		t3.value41.Text = "Players: " .. #game.Players:GetPlayers()
	end)
end
function t1.value41()
	if t3.value40 then
		t3.value40:Disconnect()
	end

	if t3.value41 then
		t3.value41:Destroy()
		t3.value41 = nil
	end

	local PlayerCountGui = t3.value3:FindFirstChild("PlayerGui"):FindFirstChild("PlayerCountGui")

	if not PlayerCountGui then
		return
	end

	PlayerCountGui:Destroy()
end

t3.value41 = nil
t3.value42 = t1.value40
t3.value43 = t1.value41
t1.value41 = t1.value12.Esp
t1.value42 = t1.value41.AddToggle

function t1.value49(p20)
	if p20 then
		t3.value42()
	else
		t3.value43()
	end
end

t1.value42(t1.value41, "ShowCountToggle", {
	Title = "Show Count",
	Default = false,
	Callback = t1.value49
})
t1.value44 = Color3.fromRGB
t1.value45 = { t1.value44(0, 170, 255) }
t1.value43 = { "Garou", unpack_(t1.value45) }
t1.value46 = Color3.fromRGB
t1.value47 = { t1.value46(0, 170, 255) }
t1.value44 = { "Garou", unpack_(t1.value47) }
t1.value48 = Color3.fromRGB
t1.value46 = { "Saitama", t1.value48(139, 69, 19) }
t1.value50 = Color3.fromRGB
t1.value51 = { t1.value50(139, 69, 19) }
t1.value48 = { "Saitama", unpack_(t1.value51) }
t1.value52 = Color3.fromRGB
t1.value53 = { t1.value52(255, 0, 0) }
t1.value50 = { "Monster Form", unpack_(t1.value53) }
t1.value54 = Color3.fromRGB
t1.value55 = { t1.value54(255, 255, 255) }
t1.value52 = { "Brutal Demon", unpack_(t1.value55) }
t1.value56 = Color3.fromRGB
t1.value54 = { "Brutal Demon", t1.value56(255, 255, 255) }
t1.value58 = Color3.fromRGB
t1.value59 = { t1.value58(255, 140, 0) }
t1.value56 = { "Cyborg", unpack_(t1.value59) }
t1.value60 = Color3.fromRGB
t1.value61 = { t1.value60(255, 140, 0) }
t1.value58 = { "Cyborg", unpack_(t1.value61) }
t1.value62 = Color3.fromRGB
t1.value60 = { "Sonic", t1.value62(255, 105, 180) }
t1.value64 = Color3.fromRGB
t1.value62 = { "Sonic", t1.value64(255, 105, 180) }
t1.value65 = Color3.fromRGB
t1.value66 = { t1.value65(255, 255, 0) }
t1.value64 = { "Blade Master", unpack_(t1.value66) }
t1.value67 = Color3.fromRGB
t1.value68 = { t1.value67(255, 255, 0) }
t1.value65 = { "Blade Master", unpack_(t1.value68) }
t1.value69 = Color3.fromRGB
t1.value67 = { "Tatsumaki", t1.value69(0, 255, 0) }
t1.value70 = Color3.fromRGB
t1.value71 = { t1.value70(0, 255, 0) }
t1.value69 = { "Tatsumaki", unpack_(t1.value71) }
t1.value72 = Color3.fromRGB
t1.value73 = { t1.value72(128, 0, 128) }
t1.value70 = { "Martial Artist", unpack_(t1.value73) }
t1.value74 = Color3.fromRGB
t1.value72 = { "Martial Artist", t1.value74(128, 0, 128) }
t3.value44 = {
	["Flowing Water"] = t1.value43,
	["Crushed Rock"] = t1.value44,
	["Normal Punch"] = t1.value46,
	["Serious Punch"] = t1.value48,
	["Binding Cloth"] = t1.value50,
	Beatdown = t1.value52,
	["Death Blow"] = t1.value54,
	["Blitz Shot"] = t1.value56,
	["Flamewave Cannon"] = t1.value58,
	["Explosive Shuriken"] = t1.value60,
	Carnage = t1.value62,
	["Atmos Cleave"] = t1.value64,
	["Atomic Slash"] = t1.value65,
	["Crushing Pull"] = t1.value67,
	["Psychic Ricochet"] = t1.value69,
	["Bullet Barrage"] = t1.value70,
	["Earth Splitting Strike"] = t1.value72
}
t1.value43 = Instance.new("Folder", workspace)
t3.value45 = t1.value43
t1.value43 = t3.value45
t1.value43.Name = "DynamicESP"

function t1.value46()
	local ipairs_ = ipairs
	local value45 = t3.value45

	for _, child in ipairs_(value45.GetChildren(value45)) do
		child:Destroy()
	end
end

t3.value46 = false

function t1.value44(p21)
	local Backpack = p21:FindFirstChildOfClass("Backpack")

	if Backpack then
		for k, v in pairs(t3.value44) do
			if Backpack:FindFirstChild(k) then
				return v[1], v[2]
			end
		end

		return "Tech Prodigy", Color3.fromRGB(200, 200, 200)
	else
		return "Tech Prodigy", Color3.fromRGB(200, 200, 200)
	end
end

t3.value47 = t1.value44

function t1.value45(p22, p23, p24)
	local Character = p22.Character

	if Character and Character:FindFirstChild("Head") then
		if t3.value45:FindFirstChild(p22.Name) then
			return
		else
			local BillboardGui = Instance.new("BillboardGui")

			BillboardGui.Name = p22.Name
			BillboardGui.Adornee = Character.Head
			BillboardGui.Size = UDim2.new(0, 100, 0, 20)
			BillboardGui.StudsOffset = Vector3.new(3.5, 0.5, 0)
			BillboardGui.AlwaysOnTop = true
			BillboardGui.Parent = t3.value45

			local TextLabel = Instance.new("TextLabel", BillboardGui)

			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p23
			TextLabel.TextColor3 = p24
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextScaled = false
			TextLabel.TextSize = 12
			TextLabel.TextStrokeTransparency = 0.6
			TextLabel.TextTransparency = 1
			t2.value1:Create(TextLabel, TweenInfo.new(0.3), {
				TextTransparency = 0,
				TextStrokeTransparency = 0.3
			}):Play()

			return
		end
	end
end

t3.value48 = t1.value45
t3.value49 = t1.value46

function t1.value47(p25)
	if p25 == game.Players.LocalPlayer then
	elseif p25.Character and p25.Character:FindFirstChild("Head") then
		local v119, v120 = t3.value47(p25)

		t3.value48(p25, v119, v120)

		return
	else
		return
	end
end

t3.value50 = t1.value47

function t1.value48()
	t3.value49()

	local ipairs_ = ipairs
	local Players2 = game.Players

	for _, player in ipairs_(Players2.GetPlayers(Players2)) do
		t3.value50(player)
	end
end

t3.value51 = t1.value48
t1.value48 = t1.value12.Esp

function t1.value57(p26)
	t3.value46 = p26

	if not t3.value46 then
		t3.value49()

		return
	end

	t3.value51()

	local pairs_ = pairs
	local Players2 = game.Players

	for _, player in pairs_(Players2.GetPlayers(Players2)) do
		local CharacterAdded = player.CharacterAdded

		local function v130()
			if not t3.value46 then
				return
			end

			task.wait(1)
			t3.value50(player)
		end

		CharacterAdded.Connect(CharacterAdded, v130)
	end

	game.Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			if not t3.value46 then
				return
			end

			task.wait(1)
			t3.value50(player)
		end)
	end)
	task.spawn(function()
		while t3.value46 do
			t3.value51()
			task.wait(2)
		end
	end)
end

t1.value48:AddToggle("EspCharacterToggle", {
	Title = "Esp Character",
	Default = false,
	Callback = t1.value57
})
t3.value52 = nil
t3.value53 = {}
t1.value48 = {}

function t1.value54()
	for _, v in pairs(t3.value53) do
		if v then
			v:Destroy()
		end
	end

	t3.value53 = {}

	for _, v in pairs(t3.value52) do
		if v then
			v:Disconnect()
		end
	end

	t3.value52 = {}
end

t3.value52 = t1.value48
t3.value54 = false

function t1.value52(p27)
	if not t3.value53[p27] then
		local Highlight = Instance.new("Highlight")

		Highlight.Adornee = p27
		Highlight.FillTransparency = 1
		Highlight.OutlineTransparency = 0
		Highlight.OutlineColor = Color3.fromRGB(170, 0, 255)
		Highlight.Parent = p27
		t3.value53[p27] = Highlight
	end
end

t3.value55 = t1.value52

local function v136()
	local Live = workspace:FindFirstChild("Live")

	if not Live then
		return
	end

	for _, child in pairs(Live:GetChildren()) do
		local isModel = child:IsA("Model")

		if isModel then
			isModel = child.Name == "Weakest Dummy"
		end

		if isModel then
			t3.value55(child)
		end
	end

	local value52 = t3.value52
	local ChildAdded = Live.ChildAdded

	local function v143(p28)
		local isModel = p28:IsA("Model")

		if isModel then
			isModel = p28.Name == "Weakest Dummy"
		end

		if not isModel then
			return
		end

		task.wait(0.2)
		t3.value55(p28)
	end

	table.insert(value52, ChildAdded:Connect(v143))
end

t3.value56 = t1.value54
t1.value54 = t1.value12.Dummy
t1.value55 = t1.value54.AddToggle

function t1.value63(p29)
	t3.value54 = p29

	if p29 then
		v136()
	else
		t3.value56()
	end
end

t1.value55(t1.value54, "DummyHighlightToggle", {
	Title = "Highlight",
	Default = false,
	Callback = t1.value63
})
t3.value57 = {}
t3.value58 = {}

function t1.value60()
	for _, v in pairs(t3.value57) do
		if v then
			v:Destroy()
		end
	end

	t3.value57 = {}

	for _, v in ipairs(t3.value58) do
		if v then
			v:Disconnect()
		end
	end

	t3.value58 = {}
end

t3.value59 = false

local function v149(p30)
	if not t3.value57[p30] then
		local HumanoidRootPart = p30:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local BillboardGui = Instance.new("BillboardGui")

			BillboardGui.Name = "NameTag"
			BillboardGui.Size = UDim2.new(0, 100, 0, 25)
			BillboardGui.Adornee = HumanoidRootPart
			BillboardGui.AlwaysOnTop = true
			BillboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
			BillboardGui.Parent = p30

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p30.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
			TextLabel.TextStrokeTransparency = 0.2
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Parent = BillboardGui
			t3.value57[p30] = BillboardGui

			return
		else
			return
		end
	end
end
local function v153()
	local Live = workspace:FindFirstChild("Live")

	if not Live then
		return
	end

	for _, child in pairs(Live:GetChildren()) do
		local isModel = child:IsA("Model")

		if isModel then
			isModel = child.Name == "Weakest Dummy"
		end

		if isModel then
			v149(child)
		end
	end

	local value58 = t3.value58
	local ChildAdded = Live.ChildAdded

	local function v160(p31)
		local isModel = p31:IsA("Model")

		if isModel then
			isModel = p31.Name == "Weakest Dummy"
		end

		if not isModel then
			return
		end

		task.wait(0.2)
		v149(p31)
	end

	table.insert(value58, ChildAdded:Connect(v160))
end

t3.value60 = t1.value60
t1.value60 = t1.value12.Dummy
t1.value61 = t1.value60.AddToggle

function t1.value68(p32)
	t3.value59 = p32

	if p32 then
		v153()
	else
		t3.value60()
	end
end

t1.value61(t1.value60, "ShowNameToggle", {
	Title = "Show Name",
	Default = false,
	Callback = t1.value68
})
t3.value61 = nil
t3.value62 = false
t3.value63 = 5

function t1.value65()
	local Live = workspace:FindFirstChild("Live")

	if Live then
		local Character = t3.value3.Character

		if Character and Character:FindFirstChild("HumanoidRootPart") then
			local Position = Character.HumanoidRootPart.Position
			local math_ = math
			local GetChildren = Live.GetChildren
			local huge = math_.huge
			local v168 = nil

			for _, v in pairs(GetChildren(Live)) do
				local isModel = v:IsA("Model")

				if isModel then
					if v.Name == "Weakest Dummy" then
						isModel = v:FindFirstChild("HumanoidRootPart")
					else
						isModel = false
					end
				end

				if isModel then
					local Magnitude = (v.HumanoidRootPart.Position - Position).Magnitude

					if Magnitude < huge then
						v168 = v
						huge = Magnitude
					end
				end
			end

			return v168
		else
			return nil
		end
	else
		return nil
	end
end

t3.value64 = 2

function t1.value67()
	if not t3.value61 then
		return
	end

	t3.value61:Disconnect()
end

t3.value65 = 0
t3.value66 = t1.value65
t3.value67 = t1.value67
t1.value67 = t1.value12.Dummy
t1.value68 = t1.value67.AddToggle

function t1.value75(p33)
	t3.value62 = p33

	if not p33 then
		t3.value67()

		return
	end

	t3.value65 = 0
	game:GetService("RunService").RenderStepped:Connect(function(dt)
		local Character = t3.value3.Character

		if Character and Character:FindFirstChild("HumanoidRootPart") then
			local HumanoidRootPart = Character.HumanoidRootPart
			local v175 = t3.value66()

			if v175 and v175:FindFirstChild("HumanoidRootPart") then
				local Position = v175.HumanoidRootPart.Position
				local v177 = dt * t3.value64
				local v178 = t3

				v178.value65 = v178.value65 + v177

				local vector3New = Vector3.new
				local value65 = t3.value65
				local v181 = math.cos(value65) * t3.value63
				local value652 = t3.value65
				local v183 = Position + vector3New(v181, 0, math.sin(value652) * t3.value63)
				local v184 = HumanoidRootPart.CFrame - HumanoidRootPart.Position

				HumanoidRootPart.CFrame = CFrame.new(v183) * v184

				return
			else
				return
			end
		end
	end)
end

t1.value68(t1.value67, "OrbitToggle", {
	Title = "Orbit",
	Default = false,
	Callback = t1.value75
})
t1.value67 = t1.value12.Dummy
t1.value68 = t1.value67.AddButton

function t1.value74()
	local Character = t3.value3.Character

	if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	local HumanoidRootPart = Character.HumanoidRootPart
	local v187 = t3.value66()
	local HumanoidRootPart2

	if v187 then
		HumanoidRootPart2 = v187:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart2 = v187
	end

	if not HumanoidRootPart2 then
		return
	end

	local Position = v187.HumanoidRootPart.Position
	local vector3 = Vector3.new(Position.X, HumanoidRootPart.Position.Y, Position.Z)
	local v191 = HumanoidRootPart.CFrame - HumanoidRootPart.Position
	local t5 = {
		CFrame = CFrame.new(vector3) * v191
	}

	game:GetService("TweenService"):Create(HumanoidRootPart, TweenInfo.new(0.6, Enum.EasingStyle.Sine), t5):Play()
end

t1.value68(t1.value67, {
	Title = "Tween",
	Description = "Tween to closest dummy",
	Callback = t1.value74
})
t1.value67 = t1.value12.Dummy
t1.value68 = t1.value67.AddButton

function t1.value74()
	local Character = t3.value3.Character

	if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	local HumanoidRootPart = Character.HumanoidRootPart
	local v195 = t3.value66()
	local HumanoidRootPart2

	if v195 then
		HumanoidRootPart2 = v195:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart2 = v195
	end

	if not HumanoidRootPart2 then
		return
	end

	local Position = v195.HumanoidRootPart.Position
	local vector3 = Vector3.new(Position.X, HumanoidRootPart.Position.Y, Position.Z)
	local v199 = HumanoidRootPart.CFrame - HumanoidRootPart.Position

	HumanoidRootPart.CFrame = CFrame.new(vector3) * v199
end

t1.value68(t1.value67, {
	Title = "Teleport",
	Description = "Teleport to closest dummy",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech
t1.value68 = t1.value67.AddButton

function t1.value74()
	getgenv().keybinds = {
		m1reset = Enum.KeyCode.R,
		emotedash = Enum.KeyCode.T,
		rotation = Enum.KeyCode.H
	}
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
end

t1.value68(t1.value67, {
	Title = "M1 Reset",
	Description = "Enable M1 reset and emote dash",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/AutoKyoto/refs/heads/main/Tsb-AutoKyotoByKieuro"))()
end

t1.value67:AddButton({
	Title = "Auto Kyoto",
	Description = "Enable auto Kyoto tech",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/Merebennie-Hub/refs/heads/main/Loopdash%20Script"))()
end

t1.value68(t1.value67, {
	Title = "Loop Dash",
	Description = "Enable loop dash",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/InstantLethal/refs/heads/main/Protected_5983112998592296.lua"))()
end

t1.value67:AddButton({
	Title = "Lethal Dash",
	Description = "Enable lethal dash",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/KxF-Tech/refs/heads/main/KxF-TechTsb"))()
end

t1.value68(t1.value67, {
	Title = "KxF Tech-UpperCut",
	Description = "Enable KxF uppercut tech",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Supa%20tech%20script"))()
end

t1.value67:AddButton({
	Title = "Supa Dash-Process",
	Description = "Enable Supa dash (in progress)",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/NewAutoTech/refs/heads/main/Protected_6389347658054908.lua"))()
end

t1.value68(t1.value67, {
	Title = "BackDash (MB)-Process",
	Description = "Enable back dash for mobile (in progress)",
	Callback = t1.value74
})
t1.value67 = t1.value12.Tech
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/NewAutoTech/refs/heads/main/Protected_6389347658054908.lua"))()
end

t1.value68(t1.value67, {
	Title = "BackDash (PC)-Process",
	Description = "Enable back dash for PC (in progress)",
	Callback = t1.value74
})
t1.value67 = t1.value12.Admin
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

t1.value68(t1.value67, {
	Title = "Infinite Yield",
	Description = "Load Infinite Yield admin commands",
	Callback = t1.value74
})
t1.value67 = t1.value12.Admin
t1.value68 = t1.value67.AddButton

function t1.value74()
	loadstring(game:HttpGet("https://github.com/FilteringEnabled/NamelessAdmin/blob/main/Source?raw=true"))()
end

t1.value68(t1.value67, {
	Title = "Nameless",
	Description = "Load Nameless admin commands",
	Callback = t1.value74
})
t3.value68 = false
t3.value69 = nil
t3.value70 = "rbxassetid://13294471966"

function t1.value72()
	local Character = t3.value3.Character

	if Character then
		Character = t3.value3.Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	Character.CFrame = Character.CFrame * CFrame.new(0, 0, 3)
end

t3.value71 = 0.23

local function v201()
	local t6 = {
		{
			Dash = Enum.KeyCode.W,
			Key = Enum.KeyCode.Q,
			Goal = "KeyPress"
		}
	}
	local Character = t3.value3.Character
	local Communicate

	if Character then
		Communicate = Character:FindFirstChild("Communicate")
	else
		Communicate = Character
	end

	if not Communicate then
		return
	end

	Character.Communicate:FireServer(unpack_({ unpack(t6) }))
end

t3.value72 = t1.value72

local function v205()
	local function v206(p34)
		local Animation = p34.Animation

		if Animation then
			if p34.Animation.AnimationId == t3.value70 then
				Animation = not t3.value68
			else
				Animation = false
			end
		end

		if not Animation then
			return
		end

		local function v208()
			t3.value72()
			v201()
		end

		task.delay(t3.value71, v208)
		task.delay(5, function() end)
	end

	t3.value69 = (t3.value3.Character or t3.value3.CharacterAdded:Wait()):WaitForChild("Humanoid").AnimationPlayed:Connect(v206)
end

t1.value73 = t1.value12.Auto
t1.value74 = t1.value73.AddToggle

function t1.value78(p35)
	if p35 then
		v205()
		t3.value3.CharacterAdded:Connect(function()
			task.wait(1)
			v205()
		end)

		return
	end

	if not t3.value69 then
		return
	end

	t3.value69:Disconnect()
end

t1.value74(t1.value73, "AutoTwistedToggle", {
	Title = "Auto Twisted",
	Default = false,
	Callback = t1.value78
})
t1.value74 = game:GetService("TweenService")
t3.value73 = t1.value74
t1.value75 = workspace
t1.value74 = t1.value75.CurrentCamera
t3.value74 = nil

function t1.value76()
	local t7 = {
		{
			Dash = Enum.KeyCode.W,
			Key = Enum.KeyCode.Q,
			Goal = "KeyPress"
		}
	}
	local Character = t3.value3.Character
	local Communicate

	if Character then
		Communicate = Character:FindFirstChild("Communicate")
	else
		Communicate = Character
	end

	if not Communicate then
		v230 = t3.value74.CFrame
		v231 = v230 * CFrame.Angles(40, -1.5707963267948966, 180)
		t3.value74.CameraType = Enum.CameraType.Scriptable
		v232 = t3.value73:Create(t3.value74, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
			CFrame = v231
		})
		v232:Play()
		v232.Completed:Wait()
		wait(0.00001)
		v233 = t3.value73:Create(t3.value74, TweenInfo.new(0.001, Enum.EasingStyle.Sine), {
			CFrame = v230
		})
		v233:Play()
		v233.Completed:Wait()
		wait(0.1)
		v234 = {
			CFrame = v230 * CFrame.Angles(-0.10471975511965978, 0.3490658503988659, 0)
		}
		v235 = t3.value73:Create(t3.value74, TweenInfo.new(0.0001, Enum.EasingStyle.Sine), v234)
		v235:Play()
		v235.Completed:Wait()
		t3.value74.CameraType = Enum.CameraType.Custom

		return
	end

	Character.Communicate:FireServer(unpack(t7))

	local CFrame_ = t3.value74.CFrame
	local v213 = CFrame_ * CFrame.Angles(40, -1.5707963267948966, 180)

	t3.value74.CameraType = Enum.CameraType.Scriptable

	local tween = t3.value73:Create(t3.value74, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
		CFrame = v213
	})

	tween:Play()
	tween.Completed:Wait()
	wait(0.00001)

	local tween2 = t3.value73:Create(t3.value74, TweenInfo.new(0.001, Enum.EasingStyle.Sine), {
		CFrame = CFrame_
	})

	tween2:Play()
	tween2.Completed:Wait()
	wait(0.1)

	local t8 = {
		CFrame = CFrame_ * CFrame.Angles(-0.10471975511965978, 0.3490658503988659, 0)
	}
	local tween3 = t3.value73:Create(t3.value74, TweenInfo.new(0.0001, Enum.EasingStyle.Sine), t8)

	tween3:Play()
	tween3.Completed:Wait()
	t3.value74.CameraType = Enum.CameraType.Custom
end

t3.value74 = t1.value74
t3.value75 = false
t3.value76 = nil
t3.value77 = nil
t3.value78 = t1.value76

local function v218()
	local Humanoid = (t3.value3.Character or t3.value3.CharacterAdded:Wait()):WaitForChild("Humanoid")
	local Animator = Humanoid:FindFirstChildOfClass("Animator")

	if Animator then
		t3.value76 = Animator.AnimationPlayed:Connect(function(p36)
			local Animation = p36.Animation

			if Animation then
				if p36.Animation.AnimationId == t3.value70 then
					Animation = not t3.value75
				else
					Animation = false
				end
			end

			if not Animation then
				return
			end

			local Character = t3.value3.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			if Character then
				local v223 = Character.CFrame.LookVector * -1

				Character.CFrame = Character.CFrame + v223
			end

			local function v224()
				t3.value78()
				wait(5)
			end

			task.delay(0.25, v224)
		end)
	else
		local function v225(child)
			if not child:IsA("Animator") then
				return
			end

			t3.value76 = child.AnimationPlayed:Connect(function(p37)
				local Animation = p37.Animation

				if Animation then
					if p37.Animation.AnimationId == t3.value70 then
						Animation = not t3.value75
					else
						Animation = false
					end
				end

				if not Animation then
					return
				end

				local Character = t3.value3.Character

				if Character then
					Character = Character:FindFirstChild("HumanoidRootPart")
				end

				if Character then
					local v228 = Character.CFrame.LookVector * -1

					Character.CFrame = Character.CFrame + v228
				end

				local function v229()
					t3.value78()
					wait(5)
				end

				task.delay(0.25, v229)
			end)
		end

		Humanoid.ChildAdded:Connect(v225)
	end
end

t1.value77 = t1.value12.Auto
t1.value78 = t1.value77.AddToggle

function t1.value83(p38)
	if p38 then
		v218()
		t3.value77 = t3.value3.CharacterAdded:Connect(v218)

		return
	end

	if t3.value76 then
		t3.value76:Disconnect()
	end

	if not t3.value77 then
		return
	end

	t3.value77:Disconnect()
end

t1.value78(t1.value77, "InstantTwistedToggle", {
	Title = "Instant Twisted",
	Default = false,
	Callback = t1.value83
})
t3.value79 = "rbxassetid://12296113986"
t3.value80 = false

function t1.value79()
	local Character = t3.value3.Character

	if Character then
		Character = Character:FindFirstChild("Humanoid")
	end

	if not Character then
		return
	end

	Character.Jump = true
end
function t1.value82()
	local Character = t3.value3.Character

	if Character then
		Character = Character:FindFirstChild("Communicate")
	end

	if not Character then
		return
	end

	local t9 = {
		{
			Dash = Enum.KeyCode.W,
			Key = Enum.KeyCode.Q,
			Goal = "KeyPress"
		}
	}

	Character:FireServer(unpack(t9))
end

t3.value81 = nil

function t1.value80()
	local Character = t3.value3.Character

	if Character then
		Character = Character:FindFirstChild("Humanoid")
	end

	if not Character then
		return
	end

	Character.Jump = false
end
function t1.value81()
	local Character = t3.value3.Character
	local CFrame_, v236

	if not Character then
		if Character then
			CFrame_ = Character.CFrame
			v236 = -CFrame_.LookVector
			Character.CFrame = CFrame.lookAt(CFrame_.Position, CFrame_.Position + v236)
			t3.value74.CFrame = CFrame.lookAt(t3.value74.CFrame.Position, t3.value74.CFrame.Position + v236)
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		CFrame_ = Character.CFrame
		v236 = -CFrame_.LookVector
		Character.CFrame = CFrame.lookAt(CFrame_.Position, CFrame_.Position + v236)
		t3.value74.CFrame = CFrame.lookAt(t3.value74.CFrame.Position, t3.value74.CFrame.Position + v236)
	end
end

t3.value82 = nil
t3.value83 = t1.value79
t3.value84 = t1.value80
t3.value85 = t1.value81
t3.value86 = nil

function t1.value83(p39)
	t3.value81 = p39.AnimationPlayed:Connect(function(p40)
		local Animation = p40.Animation

		if Animation then
			if p40.Animation.AnimationId == t3.value79 then
				Animation = not t3.value80
			else
				Animation = false
			end
		end

		if not Animation then
			return
		end

		t3.value83()
		task.delay(2, function()
			t3.value86()
			task.delay(0.26, function()
				t3.value85()
				t3.value84()
			end)
		end)
	end)
end

t3.value86 = t1.value82
t3.value87 = nil
t3.value87 = t1.value83

function t3.value88()
	local Humanoid = (t3.value3.Character or t3.value3.CharacterAdded:Wait()):WaitForChild("Humanoid")

	t3.value87(Humanoid)
end

local Auto = t1.value12.Auto

Auto.AddToggle(Auto, "AutoSupaToggle", {
	Title = "Auto Supa",
	Default = false,
	Callback = function(p41)
		if p41 then
			t3.value88()
			t3.value82 = t3.value3.CharacterAdded:Connect(t3.value88)

			return
		end

		if t3.value81 then
			t3.value81:Disconnect()
		end

		if not t3.value82 then
			return
		end

		t3.value82:Disconnect()
	end
})
t3.value89 = "rbxassetid://12273188754"
t3.value90 = nil
t3.value91 = false

local Auto2 = t1.value12.Auto

Auto2.AddToggle(Auto2, "FlowingGraspToggle", {
	Title = "Flowing + Grasp",
	Default = false,
	Callback = function(p42)
		t3.value91 = p42

		if t3.value90 then
			t3.value90:Disconnect()
		end

		if not t3.value91 then
			return
		end

		game:GetService("RunService").RenderStepped:Connect(function()
			local Character = t3.value3.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChild("Humanoid")
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not (Humanoid and HumanoidRootPart) then
				return
			end

			local GetPlayingAnimationTracks = Humanoid.GetPlayingAnimationTracks
			local v245, v246, v247 = ipairs(GetPlayingAnimationTracks(Humanoid))
			local v248 = false

			while true do
				local v249

				v247, v249 = v245(v246, v247)

				if not v247 then
					break
				end

				local Animation = v249.Animation

				if Animation then
					Animation = v249.Animation.AnimationId == t3.value89
				end

				if Animation then
					v248 = true

					break
				end
			end

			if not (v248 and true or v248) then
				return
			end

			local function v251()
				local v252 = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector * 24
				local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local tween = t3.value73:Create(HumanoidRootPart, tweenInfo, {
					CFrame = v252
				})

				tween:Play()
				tween.Completed:Wait()

				local HunterSGrasp = t3.value3.Backpack:FindFirstChild("Hunter\'s Grasp")
				local Communicate = Character:FindFirstChild("Communicate")

				if not (HunterSGrasp and Communicate) then
					return
				end

				local t10 = {
					{
						Tool = HunterSGrasp,
						Goal = "Console Move"
					}
				}

				Communicate:FireServer(unpack_({ unpack(t10) }))
			end

			task.delay(1.8, v251)
		end)
	end
})
t3.value92 = "rbxassetid://10503381238"
t3.value93 = Vector3.new(0, 8, 0)
t3.value94 = false
t3.value95 = nil

local Auto3 = t1.value12.Auto

Auto3.AddToggle(Auto3, "UpperGraspToggle", {
	Title = "Upper + Grasp",
	Default = false,
	Callback = function(p43)
		t3.value94 = p43

		if t3.value95 then
			t3.value95:Disconnect()
		end

		if not t3.value94 then
			return
		end

		game:GetService("RunService").RenderStepped:Connect(function()
			local Character = t3.value3.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChild("Humanoid")
			else
				Humanoid = Character
			end

			if not (Character and (HumanoidRootPart and Humanoid)) then
				return
			end

			local GetPlayingAnimationTracks = Humanoid.GetPlayingAnimationTracks
			local v263, v264, v265 = ipairs(GetPlayingAnimationTracks(Humanoid))
			local v266 = false

			while true do
				local v267

				v265, v267 = v263(v264, v265)

				if not v265 then
					break
				end

				local Animation = v267.Animation

				if Animation then
					Animation = v267.Animation.AnimationId == t3.value92
				end

				if Animation then
					v266 = true

					break
				end
			end

			if v266 then
				local v269 = true

				v266 = v269 and true or v269
			end

			if not v266 then
				return
			end

			local function v270()
				local v271 = nil
				local n1 = 7
				local Live = workspace:FindFirstChild("Live")

				if Live then
					for _, child in ipairs(Live:GetChildren()) do
						local isModel = child:IsA("Model")

						if isModel then
							isModel = child ~= Character
						end

						if isModel then
							local Torso = child:FindFirstChild("Torso") or child:FindFirstChild("UpperTorso")

							if Torso then
								local Magnitude = (HumanoidRootPart.Position - Torso.Position).Magnitude

								if Magnitude <= n1 then
									v271 = Torso
									n1 = Magnitude
								end
							end
						end
					end
				end

				if v271 then
					local v279 = v271.Position + t3.value93
					local tween = t3.value73:Create(HumanoidRootPart, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
						CFrame = CFrame.new(v279)
					})

					tween:Play()
					tween.Completed:Wait()
				end

				local HunterSGrasp = t3.value3.Backpack:FindFirstChild("Hunter\'s Grasp")
				local Communicate = Character:FindFirstChild("Communicate")

				if HunterSGrasp and Communicate then
					Communicate:FireServer(unpack({
						{
							Tool = HunterSGrasp,
							Goal = "Console Move"
						}
					}))
				end

				task.delay(15, function() end)
			end

			task.delay(0.18, v270)
		end)
	end
})

local Auto4 = t1.value12.Auto

Auto4.AddToggle(Auto4, "SlideM1Toggle", {
	Title = "Slide + M1",
	Default = false,
	Callback = function(p44)
		local LocalPlayer2 = game:GetService("Players").LocalPlayer
		local t11 = {
			["10480796021"] = true,
			["10480793962"] = true
		}

		if _G.SlideM1Connection then
			_G.SlideM1Connection:Disconnect()
			_G.SlideM1Connection = nil
		end

		if p44 then
			local function v286(p45)
				local Humanoid = p45:WaitForChild("Humanoid", 3)
				local Animator

				if Humanoid then
					Animator = Humanoid:FindFirstChildOfClass("Animator")
				else
					Animator = Humanoid
				end

				local v289 = p45.FindFirstChild(p45, "Communicate")

				if not (Humanoid and (Animator and v289)) then
					return
				end

				if _G.SlideM1AnimConnection then
					_G.SlideM1AnimConnection:Disconnect()
				end

				_G.SlideM1AnimConnection = Animator.AnimationPlayed:Connect(function(p46)
					if not p44 then
						return
					end

					local match = p46.Animation.AnimationId:match("%d+")

					if match then
						match = t11[match] and true
					end

					if not match then
						return
					end

					v289:FireServer({
						Mobile = true,
						Goal = "LeftClick"
					})
					v289:FireServer({
						Goal = "LeftClickRelease",
						Mobile = true
					})
					task.delay(1.5, function() end)
				end)
			end

			if LocalPlayer2.Character then
				v286(LocalPlayer2.Character)
			end

			if _G.SlideM1CharConnection then
				_G.SlideM1CharConnection:Disconnect()
			end

			_G.SlideM1CharConnection = LocalPlayer2.CharacterAdded:Connect(function(character)
				task.wait(1)

				if not p44 then
					return
				end

				v286(character)
			end)

			return
		end

		if _G.SlideM1AnimConnection then
			_G.SlideM1AnimConnection:Disconnect()
			_G.SlideM1AnimConnection = nil
		end

		if not _G.SlideM1CharConnection then
			return
		end

		_G.SlideM1CharConnection:Disconnect()
		_G.SlideM1CharConnection = nil
	end
})

local Auto5 = t1.value12.Auto

Auto5.AddToggle(Auto5, "AutoSurfToggle", {
	Title = "Auto Surf",
	Default = false,
	Callback = function(p47)
		local Players2 = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local RunService = game:GetService("RunService")
		local LocalPlayer2 = Players2.LocalPlayer
		local v296 = false

		if not p47 then
			return
		end

		local function v297()
			local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				HumanoidRootPart.Anchored = false

				local Unit = HumanoidRootPart.CFrame.LookVector.Unit
				local t12 = {
					CFrame = HumanoidRootPart.CFrame + Unit * 50
				}
				local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.78, Enum.EasingStyle.Linear), t12)

				tween:Play()
				tween.Completed:Wait()
			end
		end
		local function v302()
			local Humanoid = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")

			if Humanoid then
				local GetPlayingAnimationTracks = Humanoid.GetPlayingAnimationTracks

				for _, v in ipairs(GetPlayingAnimationTracks(Humanoid)) do
					local Animation = v.Animation

					if Animation then
						Animation = v.Animation.AnimationId == "rbxassetid://12309835105"
					end

					if Animation then
						return true
					end
				end

				return false
			else
				return false
			end
		end

		RunService.RenderStepped:Connect(function()
			if not p47 then
				return
			end

			if v296 then
				return
			end

			if not v302() then
				return
			end

			task.wait(0.6)
			v297()
			task.wait(1.5)
		end)

		if LocalPlayer2.Character and not LocalPlayer2.Character then
			LocalPlayer2.CharacterAdded:Wait()
		end

		LocalPlayer2.CharacterAdded:Connect(function()
			task.wait(1)

			if not (p47 and not LocalPlayer2.Character) then
				return
			end

			LocalPlayer2.CharacterAdded:Wait()
		end)
	end
})

local Auto6 = t1.value12.Auto

Auto6.AddToggle(Auto6, "TrueDownSlamToggle", {
	Title = "True DownSlam",
	Default = false,
	Callback = function(p48)
		local Players2 = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local Workspace = game:GetService("Workspace")
		local LocalPlayer2 = Players2.LocalPlayer
		local CurrentCamera = Workspace.CurrentCamera
		local t13 = {
			["rbxassetid://13532600125"] = true,
			["rbxassetid://10469630950"] = true,
			["rbxassetid://13296577783"] = true,
			["rbxassetid://13370310513"] = true,
			["rbxassetid://15240216931"] = true,
			["rbxassetid://16515520431"] = true,
			["rbxassetid://17889461810"] = true
		}
		local t14 = {
			["rbxassetid://13532604085"] = true,
			["rbxassetid://10469639222"] = true,
			["rbxassetid://13295919399"] = true,
			["rbxassetid://13370351717"] = true,
			["rbxassetid://15240176873"] = true,
			["rbxassetid://16515448089"] = true,
			["rbxassetid://17889471098"] = true
		}
		local t15 = {}
		local Character = LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()
		local Humanoid = Character:WaitForChild("Humanoid")

		Character.PrimaryPart = Character:WaitForChild("HumanoidRootPart")

		local v319 = nil

		local function v320()
			if not (v319 and v319.PrimaryPart) then
				return
			end

			local CameraSubject = CurrentCamera.CameraSubject

			CurrentCamera.CameraSubject = nil

			local pivot = v319:GetPivot()
			local v323 = pivot + Vector3.new(0, 7, 0)
			local n2 = 0
			local n3 = 1
			local v326 = false
			local n4 = 10
			local n5 = 10
			local n6 = 0.1

			while true do
				n2 = n2 + n3

				local v330 = ((not v326 or n4 > n2) and true or false) and not v326

				if v330 then
					v330 = n2 <= n4
				end

				if not v330 then
					CurrentCamera.CameraSubject = CameraSubject

					return
				end

				v319:PivotTo(unpack_({ pivot.Lerp(pivot, v323, n2 / n5) }))
				task.wait(n6 / n5)
			end
		end

		v319 = Character

		local u331 = Humanoid

		RunService.RenderStepped:Connect(function()
			if not p48 then
				return
			end

			if LocalPlayer2.Character ~= v319 then
				local Character2 = LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()
				local Humanoid2 = Character2:WaitForChild("Humanoid")

				Character2.PrimaryPart = Character2:WaitForChild("HumanoidRootPart")
				u331 = Humanoid2
			end

			local v334 = u331

			for _, v in pairs(v334.GetPlayingAnimationTracks(v334)) do
				local AnimationId = v.Animation.AnimationId
				local v338 = tostring(AnimationId)
				local now = tick()
				local v340 = t13[v338]

				if v340 then
					v340 = not t15[v338] or now - t15[v338] > 0.5
				end

				if v340 then
					t15[v338] = now
					task.delay(0.15, v320)
				else
					local v341 = t14[v338]

					if v341 then
						v341 = not t15[v338] or now - t15[v338] > 0.5
					end

					if v341 then
						t15[v338] = now

						local function v342()
							u331:ChangeState(Enum.HumanoidStateType.Jumping)
						end

						task.delay(0.15, v342)
					end
				end
			end
		end)
	end
})
t1.value12.Auto:AddToggle("WhirlwindDunkToggle", {
	Title = "Whirlwind Dunk",
	Default = false,
	Callback = function(p49)
		local Players2 = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local LocalPlayer2 = Players2.LocalPlayer
		local s1 = "rbxassetid://12296113986"
		local u347 = false
		local u348 = nil

		if _G.TeleportAnimConnection then
			_G.TeleportAnimConnection:Disconnect()
			_G.TeleportAnimConnection = nil
		end

		if not p49 then
			return
		end

		_G.TeleportAnimConnection = RunService.RenderStepped:Connect(function()
			local Character = LocalPlayer2.Character

			if not Character or u347 then
				return
			end

			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			local v351 = not Humanoid
			local v352 = Character.FindFirstChild(Character, "HumanoidRootPart")

			if v351 or not v352 then
				return
			end

			local v353, v354, v355 = ipairs(Humanoid:GetPlayingAnimationTracks())

			while true do
				local v356

				v355, v356 = v353(v354, v355)

				if not v355 then
					break
				end

				local Animation = v356.Animation

				if Animation then
					Animation = v356.Animation.AnimationId == s1
				end

				if Animation then
					if u348 == v356 then
						return
					end

					u348 = v356
					u347 = true
					task.delay(1.3, function()
						local Parent = v352

						if Parent then
							Parent = v352.Parent
						end

						if not Parent then
							u347 = false

							return
						end

						v352.CFrame = v352.CFrame + Vector3.new(0, 5, 0)
						u347 = false
					end)

					break
				end
			end

			local v359 = u348

			if not v359 then
				return
			end

			v359 = not u348.IsPlaying
		end)
	end
})

local Server = t1.value12.Server

Server.AddButton(Server, {
	Title = "Anti Lag",
	Description = "Reduce server lag",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Antilag%20script"))()
	end
})

local Server2 = t1.value12.Server

Server2.AddButton(Server2, {
	Title = "Rejoin",
	Description = "Rejoin the same server",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local LocalPlayer2 = game.Players.LocalPlayer
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "RejoinGui"
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel.TextScaled = true
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = ""
		TextLabel.Parent = ScreenGui
		TextLabel.Text = "Rejoining in " .. 5 .. "..."
		task.wait(1)
		TextLabel.Text = "Rejoining in " .. 4 .. "..."
		task.wait(1)
		TextLabel.Text = "Rejoining in " .. 3 .. "..."
		task.wait(1)
		TextLabel.Text = "Rejoining in " .. 2 .. "..."
		task.wait(1)
		TextLabel.Text = "Rejoining in " .. 1 .. "..."
		task.wait(1)
		ScreenGui:Destroy()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer2)
	end
})

local Server3 = t1.value12.Server

Server3.AddButton(Server3, {
	Title = "Server Hop",
	Description = "Hop to a different server",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer2 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "ServerHopGui"
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel.TextScaled = true
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = ""
		TextLabel.Parent = ScreenGui

		for i = 5, 1, -1 do
			TextLabel.Text = "Hopping in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui:Destroy()

		local v374 = (function()
			local function v375()
				return HttpService:JSONDecode(unpack_({ game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") }))
			end

			local t16 = {}
			local ok, result = pcall(v375)

			if ok then
				if result then
					ok = result.data
				else
					ok = result
				end
			end

			if ok then
				for _, v in pairs(result.data) do
					local v381 = v.playing < v.maxPlayers

					if v381 then
						v381 = v.id ~= game.JobId
					end

					if v381 then
						local id = v.id

						table.insert(t16, id)
					end
				end
			end

			local v383 = #t16 > 0

			if not v383 then
				return v383 or nil
			end

			v383 = t16[math.random(1, #t16)]

			return v383 or nil
		end)()

		if v374 then
			TeleportService:TeleportToPlaceInstance(PlaceId, v374, LocalPlayer2)
		else
			t3.value1:Notify({
				Title = "Server Hop",
				Content = "No available servers found.",
				Duration = 5
			})
		end
	end
})

local Server4 = t1.value12.Server

Server4.AddButton(Server4, {
	Title = "Small Server",
	Description = "Join a server with less than 5 players",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer2 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "SmallServerGui"
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel.TextScaled = true
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = ""
		TextLabel.Parent = ScreenGui

		for i = 5, 1, -1 do
			TextLabel.Text = "Finding server < 5 players in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui:Destroy()

		local v392 = (function()
			local s2 = ""
			local t17 = {}

			for _ = 1, 5 do
				local v396 = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

				if s2 ~= "" then
					v396 = v396 .. "&cursor=" .. s2
				end

				local function v397()
					return HttpService:JSONDecode(unpack_({ game:HttpGet(v396) }))
				end

				local ok, result = pcall(v397)

				if ok then
					if result then
						ok = result.data
					else
						ok = result
					end
				end

				if not ok then
					break
				end

				for _, v in pairs(result.data) do
					local v402 = v.playing < 5

					if v402 then
						v402 = v.id ~= game.JobId
					end

					if v402 then
						local id = v.id

						table.insert(t17, id)
					end
				end

				if not result.nextPageCursor then
					break
				end

				s2 = result.nextPageCursor
			end

			local v404 = #t17 > 0

			if not v404 then
				return v404 or nil
			end

			v404 = t17[math.random(1, #t17)]

			return v404 or nil
		end)()

		if v392 then
			TeleportService:TeleportToPlaceInstance(PlaceId, v392, LocalPlayer2)
		else
			t3.value1:Notify({
				Title = "Small Server",
				Content = "No servers with less than 5 players found.",
				Duration = 5
			})
		end
	end
})
t1.value12.Server:AddButton({
	Title = "Exit Server",
	Description = "Exit the current server",
	Callback = function()
		local LocalPlayer2 = game.Players.LocalPlayer
		local value2 = t3.value2

		value2.Dialog(value2, {
			Title = "Exit Server",
			Content = "Do you want to exit the server?",
			Buttons = {
				{
					Title = "Yes",
					Callback = function()
						LocalPlayer2:Kick("You have exited the server.")
					end
				},
				{
					Title = "No",
					Callback = function()
						print("Exit cancelled.")
					end
				}
			}
		})
	end
})

local Server5 = t1.value12.Server

Server5.AddButton(Server5, {
	Title = "Check Ping",
	Description = "Display current ping",
	Callback = function()
		local LocalPlayer2 = game:GetService("Players").LocalPlayer
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "PingDisplay"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0, 150, 0, 40)
		TextLabel.Position = UDim2.new(1, -160, 0, 10)
		TextLabel.BackgroundTransparency = 0.4
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 20
		TextLabel.Text = "PING: -- ms"
		TextLabel.Parent = ScreenGui
		task.spawn(function()
			while true do
				local v411 = LocalPlayer2:GetNetworkPing() * 1000
				local v412 = math.floor(v411)

				TextLabel.Text = "PING: " .. v412 .. " ms"

				if v412 <= 80 then
					TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
				elseif v412 <= 150 then
					TextLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
				else
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end

				wait(1)
			end
		end)
	end
})

local Server6 = t1.value12.Server

Server6.AddToggle(Server6, "AntiKickToggle", {
	Title = "Anti Kick",
	Default = false,
	Callback = function(p50)
		local Players2 = game:GetService("Players")
		local StarterGui = game:GetService("StarterGui")
		local LocalPlayer2 = Players2.LocalPlayer
		local t18 = {}

		local function v418()
			local v419 = getrawmetatable(game)
			local __namecall = v419.__namecall

			setreadonly(v419, false)

			local function v421(p51, ...)
				local v422

				if getnamecallmethod() == "Kick" then
					v422 = p51 == LocalPlayer2
				else
					v422 = false
				end

				if v422 then
					warn("[AntiKick]: Kick blocked (Namecall)")

					return nil
				else
					return __namecall(p51, ...)
				end
			end

			v419.__namecall = newcclosure(v421)

			function LocalPlayer2.Kick()
				warn("[AntiKick]: Kick blocked (Direct)")

				return nil
			end

			setreadonly(v419, true)
		end
		local function v423()
			for _, v in pairs(getgc(true)) do
				local v426

				if typeof(v) == "function" then
					v426 = islclosure(v)
				else
					v426 = false
				end

				if v426 then
					local v427 = debug.getinfo(v)
					local name = v427.name

					if name then
						name = string.lower(v427.name):match("kick")
					end

					if name then
						hookfunction(v, function(...)
							warn("[AntiKick]: Exploit Kick blocked")

							return nil
						end)
					end
				end
			end
		end
		local function v429()
			for _, v in ipairs(t18) do
				if typeof(v) == "RBXScriptConnection" then
					pcall(function()
						v:Disconnect()
					end)
				end
			end

			table.clear(t18)
		end

		if not p50 then
			v429()

			return
		end

		v418()

		local connection = StarterGui.MessageBoxPrompted:Connect(function()
			warn("[AntiKick]: MessageBox blocked")
		end)

		table.insert(t18, connection)
		v423()
	end
})

local AutoBlock = t1.value12.AutoBlock

AutoBlock.AddButton(AutoBlock, {
	Title = "Auto-Block",
	Description = "Enable auto-block functionality",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/CombatGUI/refs/heads/main/TSBCombatGUI"))()
	end
})

local Movements = t1.value12.Movements

Movements.AddButton(Movements, {
	Title = "ChainsawMan",
	Description = "Enable ChainsawMan movement",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/ChainsawMan/refs/heads/main/TsbChainsawManMovement"))()
	end
})
t1.value12.Movements:AddButton({
	Title = "Black Aura",
	Description = "Enable Black Aura movement",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/weatherwess-lgtm/TsbAllAllIn/refs/heads/main/TsbScriptTechAndMore"))()
	end
})
t1.value12.Others:AddButton({
	Title = "Blade Ball Ton618",
	Description = "Load Blade Ball Ton618 script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/BladeBallTon618/refs/heads/main/Ton618"))()
	end
})

local Others = t1.value12.Others

Others.AddButton(Others, {
	Title = "Ink-Game",
	Description = "Load Ink-Game script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lebumbum/leyield/refs/heads/main/inkgame"))()
	end
})

local Others2 = t1.value12.Others

Others2.AddButton(Others2, {
	Title = "Untitle-Boxing",
	Description = "Load Untitile-Boxing script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lebumbum/leyield/refs/heads/main/inkgame"))()
	end
})

local Others3 = t1.value12.Others

Others3.AddButton(Others3, {
	Title = "Yba-ItemFarm",
	Description = "Load Yba-ItemFarm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/Yba/refs/heads/main/Yba-ItemFarm"))()
	end
})

local Others4 = t1.value12.Others

Others4.AddButton(Others4, {
	Title = "99Nights",
	Description = "Load 99Nights",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()
	end
})
t1.value12.Others:AddButton({
	Title = "Ro-Ghoul",
	Description = "Load Ro-Ghoul",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/DashBoostSolora.lua"))()
	end
})

local Others5 = t1.value12.Others

Others5.AddButton(Others5, {
	Title = "Arsenal-Ton618",
	Description = "Load Arsenal-Ton618",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/ArsenalTon618/refs/heads/main/ArsenalTon618"))()
	end
})

local Others6 = t1.value12.Others

Others6.AddButton(Others6, {
	Title = "Arsenal-Ton618v2",
	Description = "Load Arsenal-Ton618v2",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KieurOo/ArsenalTon618V2/refs/heads/main/Ton-618-luaScript"))()
	end
})
t3.value2:Show()
