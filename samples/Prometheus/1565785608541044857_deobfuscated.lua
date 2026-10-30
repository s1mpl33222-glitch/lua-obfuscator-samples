-- This file was generated at discord.gg/syncrypt

local game_ = game
local v3 = game_.GetService(game_, "Players")
local t1 = {
	value1 = game:GetService("ReplicatedStorage"),
	value2 = game:GetService("RunService"),
	value3 = game:GetService("Lighting"),
	value4 = game:GetService("Stats"),
	value5 = game:GetService("VirtualUser"),
	value6 = v3.LocalPlayer
}
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/csgo1compte-cloud/RayVoidUi/refs/heads/main/RayVoid"))()

lib:MainCredit()
lib:SetScriptName("Survive-Zombie-Arena")

local t2 = {
	Name = "Survive Zombie Arena | AKkiwi HUB",
	LoadingTitle = "Survive Zombie Arena Script",
	LoadingSubtitle = "by AKkiwi",
	ConfigurationSaving = {
		Enabled = true,
		FileName = "Survive Zombie Arena"
	}
}
local v6 = lib:CreateWindow(t2)
local Main = v6:CreateTab("Main", "shield")
local Shop = v6:CreateTab("Shop", "banknote")
local Roll = v6:CreateTab("Roll", "dices")
local v10 = v6.CreateTab(v6, "Misc", "settings")

t1.value7 = 60
t1.value8 = 8
t1.value9 = false
t1.value10 = false
t1.value11 = false
t1.value12 = false
t1.value13 = false
t1.value14 = false
t1.value15 = false
t1.value16 = false
t1.value17 = false
t1.value18 = false
t1.value19 = false
t1.value20 = false
t1.value21 = nil
t1.value22 = nil

local cFrame = CFrame.new(-221.61351, 41.3945541, -283.593719, 0.998308182, -0.000439744443, 0.0581427775, 8.71979555e-9, 0.99997139, 0.00756281661, -0.0581444427, -0.00755002117, 0.998279631)

t1.value23 = nil
t1.value24 = cFrame
t1.value25 = nil
t1.value26 = nil
t1.value27 = 60
t1.value28 = 0
t1.value29 = 0

function t1.value30()
	if os.clock() - t1.value28 >= 1 then
	elseif t1.value29 >= t1.value27 then
		return false
	else
		t1.value29 = t1.value29 + 1

		return true
	end

	t1.value29 = 0

	if t1.value29 >= t1.value27 then
		return false
	else
		t1.value29 = t1.value29 + 1

		return true
	end
end
function t1.value31()
	local Character = t1.value6.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			return HumanoidRootPart, Character
		else
			return nil, Character
		end
	else
		return nil, nil
	end
end

t1.value25 = {}

function t1.value32(p1, p2)
	local v14 = p1 .. "/" .. p2
	local v15 = t1.value25[v14]
	local Parent

	if v15 then
		Parent = v15.Parent
	else
		Parent = v15
	end

	if Parent then
		return v15
	end

	local function v17()
		return t1.value1:WaitForChild("Remotes", 5):WaitForChild(p1, 5):WaitForChild(p2, 5)
	end

	local ok, result = pcall(v17)

	if ok and result then
		t1.value25[v14] = result

		return result
	else
		warn("[ZombieArena] remote introuvable : " .. v14)

		return nil
	end
end

t1.value33 = 0.4
t1.value26 = {}
t1.value23 = 0

function t1.value34(p3)
	if not (p3 - t1.value23 < 2) then
		t1.value23 = p3

		for k, v in pairs(t1.value26) do
			if p3 - v > 3 then
				t1.value26[k] = nil
			end
		end
	end
end

local function v22(p4, p5)
	local v23 = t1.value31()

	if not v23 then
		return {}
	end

	local Zombies_Local = workspace:FindFirstChild("Zombies_Local")

	if not Zombies_Local then
		return {}
	end

	local now = os.clock()

	t1.value34(now)

	local Position = v23.Position
	local GetChildren = Zombies_Local.GetChildren
	local t3 = {}

	for _, v in ipairs(GetChildren(Zombies_Local)) do
		local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local Name = v.Name
			local v33 = tonumber(Name:match("%d+"))

			if v33 then
				local v34 = t1.value26[v33]

				if not v34 or now - v34 >= t1.value33 then
					local Magnitude = (HumanoidRootPart.Position - Position).Magnitude

					if Magnitude <= p5 then
						table.insert(t3, {
							id = v33,
							pos = HumanoidRootPart.Position,
							dist = Magnitude
						})
					end
				end
			end
		end
	end

	table.sort(t3, function(p6, p7)
		return p6.dist < p7.dist
	end)

	while p4 < #t3 do
		table.remove(t3)
	end

	return t3
end

function t1.value35()
	local _, v37 = t1.value31()

	if v37 then
		for _, child in ipairs(v37:GetChildren()) do
			if child:IsA("Tool") then
				return child.Name
			end
		end

		return nil
	else
		return nil
	end
end
function t1.value36()
	task.spawn(function()
		pcall(function()
			local DataRemotes = t1.value32("DataRemotes", "SetSetting")

			if not DataRemotes then
				return
			end

			DataRemotes:FireServer("PerformanceMode", true)
		end)
	end)
end

pcall(function()
	t1.value6.Idled:Connect(function()
		t1.value5:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		t1.value5:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)
Main:CreateSection("Kill Aura")
Main.CreateToggle(Main, {
	Name = "Auto Kill (Gun)",
	CurrentValue = false,
	Flag = "ZA_AutoGun",
	Callback = function(p8)
		t1.value9 = p8

		if not p8 or t1.value10 then
			return
		end

		t1.value36()
		task.spawn(function()
			while t1.value9 do
				local NetRemotes = t1.value32("NetRemotes", "GunFire")
				local GunRemotes = t1.value32("GunRemotes", "GunHit")
				local v43 = t1.value35()
				local v44 = t1.value31()
				local v45

				if NetRemotes then
					if GunRemotes then
						v45 = v43 and v44
					else
						v45 = GunRemotes
					end
				else
					v45 = NetRemotes
				end

				if v45 then
					local Position = v44.Position
					local v47 = v22(t1.value8, t1.value7)
					local now = os.clock()

					for _, v in ipairs(v47) do
						local v51 = t1.value30()

						if v51 then
							v51 = t1.value30()
						end

						if v51 then
							t1.value26[v.id] = now

							local v52 = v.pos - Position
							local v53 = v52.Magnitude > 0

							if v53 then
								v53 = v52.Unit
							end

							local function v54()
								NetRemotes:FireServer(v43, Position, v52)
								GunRemotes:FireServer(v43, v.id, v.pos)
							end

							local _ = v53 or Vector3.new(0, 0, 1)

							pcall(v54)
						end
					end
				end

				task.wait(0.2)
			end
		end)
	end
})
Main.CreateSlider(Main, {
	Name = "Range",
	Range = { 20, 500 },
	Increment = 10,
	Suffix = " studs",
	CurrentValue = 60,
	Flag = "ZA_Range",
	Callback = function(p9)
		t1.value7 = p9
	end
})
Main:CreateSlider({
	Name = "Cibles par cycle",
	Range = { 1, 25 },
	Increment = 1,
	Suffix = " zombies",
	CurrentValue = 8,
	Flag = "ZA_Count",
	Callback = function(p10)
		t1.value8 = p10
	end
})
Main.CreateSection(Main, "Position")
t1.value37 = nil
t1.value38 = Main.CreateToggle(Main, {
	Name = "Safe Zone (position actuelle)",
	CurrentValue = false,
	Flag = "ZA_SafeZone",
	Callback = function(p11)
		t1.value11 = p11

		if p11 then
			local value13 = t1.value13

			if value13 then
				value13 = t1.value37
			end

			if value13 then
				local function v57()
					t1.value37:Set(false)
				end

				pcall(v57)
			end

			local v58 = t1.value31()

			if not v58 then
				t1.value11 = false
				warn("[ZombieArena] Safe Zone : pas de HRP")

				return
			end

			t1.value21 = v58.CFrame + Vector3.new(0, 20, 0)
		end

		if not p11 or t1.value12 then
			return
		end

		task.spawn(function()
			while t1.value11 do
				local v59 = t1.value31()
				local value21

				if v59 then
					value21 = t1.value21
				else
					value21 = v59
				end

				if value21 then
					v59.AssemblyLinearVelocity = Vector3.zero
					v59.AssemblyAngularVelocity = Vector3.zero
					v59.CFrame = t1.value21
				end

				task.wait()
			end
		end)
	end
})
t1.value37 = Main.CreateToggle(Main, {
	Name = "AFK Spot (position fixe)",
	CurrentValue = false,
	Flag = "ZA_AfkSpot",
	Callback = function(p12)
		t1.value13 = p12

		local value11

		if p12 then
			value11 = t1.value11

			if value11 then
				value11 = t1.value38
			end
		else
			value11 = p12
		end

		if value11 then
			pcall(function()
				t1.value38:Set(false)
			end)
		end

		if not p12 or t1.value14 then
			return
		end

		task.spawn(function()
			while t1.value13 do
				local v62 = t1.value31()

				if v62 then
					v62.AssemblyLinearVelocity = Vector3.zero
					v62.AssemblyAngularVelocity = Vector3.zero
					v62.CFrame = t1.value24
				end

				task.wait()
			end
		end)
	end
})
Shop:CreateSection("Upgrades")
Shop.CreateToggle(Shop, {
	Name = "Auto Upgrade Health",
	CurrentValue = false,
	Flag = "ZA_UpgradeHp",
	Callback = function(p13)
		t1.value15 = p13

		if not p13 or t1.value16 then
			return
		end

		task.spawn(function()
			while t1.value15 do
				local UpgradeRemotes = t1.value32("UpgradeRemotes", "PurchaseHealthUpgrade")
				local v64

				if UpgradeRemotes then
					v64 = t1.value30()
				else
					v64 = UpgradeRemotes
				end

				if v64 then
					pcall(function()
						UpgradeRemotes:FireServer()
					end)
				end

				task.wait(0.5)
			end
		end)
	end
})
Shop.CreateToggle(Shop, {
	Name = "Auto Upgrade Weapon",
	CurrentValue = false,
	Flag = "ZA_UpgradeWp",
	Callback = function(p14)
		t1.value17 = p14

		if not p14 or t1.value18 then
			return
		end

		task.spawn(function()
			while t1.value17 do
				local UpgradeRemotes = t1.value32("UpgradeRemotes", "PurchaseWeaponUpgrade")
				local v66

				if UpgradeRemotes then
					v66 = t1.value30()
				else
					v66 = UpgradeRemotes
				end

				if v66 then
					pcall(function()
						UpgradeRemotes:FireServer()
					end)
				end

				task.wait(1)
			end
		end)
	end
})
Roll:CreateSection("Crates")
Roll.CreateToggle(Roll, {
	Name = "Roll Bloodmoon Crate",
	CurrentValue = false,
	Flag = "ZA_RollBloodmoon",
	Callback = function(p15)
		t1.value19 = p15

		if not p15 or t1.value20 then
			return
		end

		task.spawn(function()
			while t1.value19 do
				local EventRemotes = t1.value32("EventRemotes", "BloodmoonRequestSpin")

				if EventRemotes then
					pcall(function()
						EventRemotes:InvokeServer()
					end)
				end

				task.wait(0.5)
			end
		end)
	end
})
v10:CreateSection("Performance")

function t1.value39(p16)
	return p16:IsA("ParticleEmitter") or (p16:IsA("Trail") or (p16:IsA("Smoke") or (p16:IsA("Fire") or (p16:IsA("Sparkles") or p16:IsA("Beam")))))
end

v10.CreateToggle(v10, {
	Name = "FPS Boost",
	CurrentValue = false,
	Flag = "ZA_FpsBoost",
	Callback = function(p17)
		if p17 then
			local function v68()
				t1.value3.GlobalShadows = false
				t1.value3.FogEnd = 9000000000
				t1.value3.FogStart = 9000000000
				t1.value3.Brightness = 1.5
				t1.value3.Ambient = Color3.new(0.5, 0.5, 0.5)
				t1.value3.ClockTime = 14
			end

			pcall(v68)

			local Terrain = workspace:FindFirstChildOfClass("Terrain")

			if Terrain then
				pcall(function()
					Terrain.WaterWaveSize = 0
					Terrain.WaterWaveSpeed = 0
					Terrain.WaterReflectance = 0
					Terrain.WaterTransparency = 1
				end)
			end

			task.spawn(function()
				local ipairs_ = ipairs
				local workspace_ = workspace
				local v72, v73, v74 = ipairs_(workspace_.GetDescendants(workspace_))

				while true do
					local v75

					v74, v75 = v72(v73, v74)

					if not v74 then
						break
					end

					if v75:IsA("BasePart") then
						v75.CastShadow = false
					elseif t1.value39(v75) then
						pcall(function()
							v75:Destroy()
						end)
					elseif v75:IsA("Decal") then
						v75.Transparency = 1
					end
				end

				for _, child in ipairs(t1.value3:GetChildren()) do
					if child:IsA("PostEffect") then
						child.Enabled = false
					end
				end
			end)

			if t1.value22 then
				t1.value22:Disconnect()
			end

			t1.value22 = workspace.DescendantAdded:Connect(function(descendant)
				if t1.value39(descendant) then
					pcall(function()
						descendant:Destroy()
					end)

					return
				end

				if not descendant:IsA("BasePart") then
					return
				end

				descendant.CastShadow = false
			end)

			return
		end

		if not t1.value22 then
			return
		end

		t1.value22:Disconnect()
	end
})
v10:CreateSection("Stats")
t1.value40 = v10:CreateLabel("FPS: -- | Ping: -- ms")
task.spawn(function()
	local n1 = 0
	local now = os.clock()
	local n2 = 0

	t1.value2.RenderStepped:Connect(function()
		n1 = n1 + 1

		local now2 = os.clock()

		if not (now2 - now >= 1) then
			return
		end

		local v82 = n1 / (now2 - now)

		n2 = math.floor(v82)
	end)

	while true do
		local u83 = nil

		local function v84()
			local value = t1.value4.Network.ServerStatsItem["Data Ping"]:GetValue()

			u83 = math.floor(value)
		end

		u83 = 0
		pcall(v84)
		pcall(function()
			t1.value40:Set("FPS: " .. n2 .. " | Ping: " .. u83 .. " ms | Remotes/s: " .. t1.value29)
		end)
		task.wait(2)
	end
end)
lib:Notify({
	Title = "Survive Zombie Arena",
	Content = "Script charge.",
	Duration = 4
})
