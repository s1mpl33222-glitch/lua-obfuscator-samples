-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local Players = game:GetService("Players")

game:GetService("TweenService")

local t1 = {
	value1 = game:GetService("HttpService"),
	value2 = Players.LocalPlayer,
	value3 = nil
}

t1.value3 = nil
pcall(function()
	local syn_ = syn

	if syn_ then
		syn_ = syn.crypt

		if syn_ then
			syn_ = syn.crypt.decrypt
		end
	end

	if not syn_ then
		syn_ = getgenv

		if syn_ then
			syn_ = getgenv().NoksVIP_Key
		end
	end

	t1.value3 = syn_

	if t1.value3 then
		return
	end

	t1.value3 = game:GetService("HttpService"):JSONDecode(readfile("NoksVIP_Key.txt") or "null")
end)

function t1.value4(p1)
	pcall(function()
		writefile("NoksVIP_Key.txt", t1.value1:JSONEncode(p1))

		local syn_ = syn

		if syn_ then
			syn_ = syn.crypt
		end

		if not syn_ then
			getgenv().NoksVIP_Key = p1

			return
		end

		syn.crypt.encrypt(p1)
		getgenv().NoksVIP_Key = p1
	end)
end
function t1.value5(p2)
	local v6 = string.upper(string.gsub(p2, "%s", ""))

	return string.match(v6, "^[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$") ~= nil
end
function t1.value6(p3)
	return t1.value5(p3)
end
function t1.value7()
	local t2 = {
		value1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/Library.lua"))()
	}
	local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/ThemeManager.lua"))()
	local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/SaveManager.lua"))()

	t2.value2 = game:GetService("Players")
	t2.value3 = game:GetService("RunService")

	local UserInputService = game:GetService("UserInputService")

	t2.value4 = game:GetService("Lighting")
	t2.value5 = game:GetService("ReplicatedStorage")
	t2.value6 = game:GetService("Workspace")
	t2.value7 = t2.value2.LocalPlayer
	t2.value8 = workspace.CurrentCamera

	local Options = t2.value1.Options

	t2.value9 = t2.value1.Toggles
	t2.value1.ShowToggleFrameInKeybinds = true
	t2.value1.ShowCustomCursor = true
	t2.value1.NotifySide = "Left"

	local v12 = t2.value1:CreateWindow({
		Title = "NOKS VIP HUB",
		Center = true,
		AutoShow = true,
		Resizable = true,
		ShowCustomCursor = true,
		UnlockMouseWhileOpen = true,
		NotifySide = "Left",
		TabPadding = 8,
		MenuFadeTime = 0.2
	})
	local t3 = {
		Combat = v12:AddTab("Combat"),
		Visual = v12:AddTab("Visual"),
		Misc = v12:AddTab("Misc"),
		["UI Settings"] = v12:AddTab("UI Settings")
	}

	t2.value10 = {
		ENABLE_LOCK = false,
		ENABLE_SILENT_AIM = false,
		ENABLE_TRIGGERBOT = false,
		ENABLE_PREDICTION = false,
		FOV = 120,
		ENABLE_FOV_CIRCLE = false,
		AIM_SMOOTHNESS = 0.3,
		PREDICTION_STRENGTH = 1,
		TRIGGER_DELAY = 0.05,
		HITBOX_TARGET = "Head",
		ENABLE_XRAY = false,
		ENABLE_ESP = false,
		ENABLE_TRACERS = false,
		ENABLE_DARK_TEXTURE = false,
		ENABLE_LOW_TEXTURE = false,
		ENABLE_SELF_CHAMS = false,
		ENABLE_WEAPON_CHAMS = false,
		SELF_CHAMS_COLOR = Color3.fromRGB(255, 0, 0),
		WEAPON_CHAMS_COLOR = Color3.fromRGB(255, 0, 0),
		ENABLE_TEXTURE_COLOR = false,
		ENABLE_INFJUMP = false,
		ENABLE_FLY = false,
		ENABLE_NOCLIP = false,
		FLY_SPEED = 70,
		FOLLOW_HEIGHT = 18,
		ENABLE_UNLOCK_ALL = false,
		ENABLE_ANTI_MOD = false,
		ENABLE_SKY_CHANGER = false,
		ENABLE_CUSTOM_SKY_1 = false,
		ENABLE_CUSTOM_SKY_2 = false,
		ENABLE_STRETCH_RES = false,
		STRETCH_AMOUNT = 0.81,
		ENABLE_SOUND_REPLACER = false,
		AUTO_RETARGET = true,
		RETARGET_DELAY = 1
	}

	local t4 = {
		"Head",
		"UpperTorso",
		"LowerTorso",
		"HumanoidRootPart"
	}

	t2.value11 = {}
	t2.value12 = nil
	t2.value13 = {}
	t2.value14 = {}
	t2.value15 = false
	t2.value16 = 70
	t2.value17 = nil
	t2.value18 = nil
	t2.value19 = nil
	t2.value20 = nil
	t2.value21 = false
	t2.value22 = nil
	t2.value23 = nil
	t2.value24 = false
	t2.value25 = nil
	t2.value26 = nil
	t2.value27 = nil
	t2.value28 = nil
	t2.value29 = {}
	t2.value30 = false
	t2.value31 = nil
	t2.value32 = Color3.fromRGB(255, 0, 0)

	function t2.value33(p4)
		local pairs_ = pairs
		local value6 = t2.value6

		for _, descendant in pairs_(value6.GetDescendants(value6)) do
			pcall(function()
				if descendant:IsA("BasePart") then
					local Model = descendant:FindFirstAncestorOfClass("Model")

					if Model then
						Model = Model:FindFirstChildOfClass("Humanoid")
					end

					if not Model then
						descendant.Color = p4
					end
				end

				if descendant:IsA("Decal") or descendant:IsA("Texture") then
					descendant.Color3 = p4
				end

				if not descendant:IsA("ColorCorrectionEffect") then
					return
				end

				descendant.TintColor = p4
			end)
		end
	end

	local function v20(p5)
		if t2.value31 then
			t2.value31:Disconnect()
		end

		t2.value30 = true
		t2.value32 = p5
		t2.value33(p5)
		t2.value31 = t2.value6.DescendantAdded:Connect(function(descendant)
			if not t2.value30 then
				return
			end

			task.wait(0.05)
			pcall(function()
				if descendant:IsA("BasePart") then
					local Model = descendant:FindFirstAncestorOfClass("Model")

					if Model then
						Model = Model:FindFirstChildOfClass("Humanoid")
					end

					if not Model then
						descendant.Color = t2.value32
					end
				end

				if not (descendant:IsA("Decal") or descendant:IsA("Texture")) then
					return
				end

				descendant.Color3 = t2.value32
			end)
		end)
		t2.value1:Notify("Texture Color Changer activated!")
	end

	function t2.value34()
		if not t2.value31 then
			t2.value1:Notify("Texture Color Changer disabled!")

			return
		end

		t2.value31:Disconnect()
		t2.value1:Notify("Texture Color Changer disabled!")
	end

	t2.value35 = Instance.new("ScreenGui", game.CoreGui)
	t2.value35.Name = "NoksVIP_FOVCircle"
	t2.value35.ResetOnSpawn = false
	t2.value35.IgnoreGuiInset = true
	t2.value36 = Instance.new("Frame", t2.value35)
	t2.value36.Size = UDim2.new(0, t2.value10.FOV, 0, t2.value10.FOV)
	t2.value36.AnchorPoint = Vector2.new(0.5, 0.5)
	t2.value36.BackgroundTransparency = 1

	local value36 = t2.value36
	local ENABLE_FOV_CIRCLE = t2.value10.ENABLE_FOV_CIRCLE

	if ENABLE_FOV_CIRCLE then
		ENABLE_FOV_CIRCLE = t2.value10.ENABLE_LOCK or t2.value10.ENABLE_SILENT_AIM
	end

	value36.Visible = ENABLE_FOV_CIRCLE
	Instance.new("UICorner", t2.value36).CornerRadius = UDim.new(1, 0)

	local UIStroke = Instance.new("UIStroke", t2.value36)

	UIStroke.Thickness = 2
	UIStroke.Color = Color3.fromRGB(140, 60, 220)

	local function v25()
		if t2.value36 then
			t2.value36.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end

	function t2.value37()
		if not t2.value36 then
			return
		end

		local value362 = t2.value36
		local s1 = "Visible"
		local ENABLE_FOV_CIRCLE2 = t2.value10.ENABLE_FOV_CIRCLE

		if ENABLE_FOV_CIRCLE2 then
			ENABLE_FOV_CIRCLE2 = t2.value10.ENABLE_LOCK or t2.value10.ENABLE_SILENT_AIM
		end

		value362[s1] = ENABLE_FOV_CIRCLE2
	end

	v25()
	t2.value8:GetPropertyChangedSignal("ViewportSize"):Connect(v25)
	t2.value3.RenderStepped:Connect(v25)

	function t2.value38(p6)
		local HITBOX_TARGET = t2.value10.HITBOX_TARGET

		if HITBOX_TARGET == "Head" then
			return p6.FindFirstChild(p6, "Head")
		elseif HITBOX_TARGET == "UpperTorso" then
			return p6.FindFirstChild(p6, "UpperTorso")
		elseif HITBOX_TARGET == "LowerTorso" then
			return p6.FindFirstChild(p6, "LowerTorso")
		elseif HITBOX_TARGET == "HumanoidRootPart" then
			return p6.FindFirstChild(p6, "HumanoidRootPart")
		else
			return p6.FindFirstChild(p6, "Head")
		end
	end
	function t2.value39()
		local vector2 = Vector2.new(t2.value8.ViewportSize.X / 2, t2.value8.ViewportSize.Y / 2)
		local v31 = t2.value10.FOV / 2
		local pairs_ = pairs
		local value2 = t2.value2
		local v34 = nil

		for _, player in pairs_(value2.GetPlayers(value2)) do
			local v37

			if player == t2.value7 then
				v37 = false
			else
				v37 = player.Character
			end

			if v37 then
				local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid = Humanoid.Health > 0
				end

				if Humanoid then
					local v39 = t2.value38(player.Character)

					if v39 then
						local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

						if HumanoidRootPart then
							HumanoidRootPart = HumanoidRootPart.AssemblyLinearVelocity
						end

						local vector3 = HumanoidRootPart or Vector3.new(0, 0, 0)
						local v42

						if t2.value10.ENABLE_PREDICTION then
							local Position = v39.Position

							v42 = Position + vector3 * ((Position - t2.value8.CFrame.Position).Magnitude / 999999) * t2.value10.PREDICTION_STRENGTH
						else
							v42 = v39.Position
						end

						local v44, v45 = t2.value8:WorldToViewportPoint(v42)

						if v45 then
							local raycastParams = RaycastParams.new()

							raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
							raycastParams.FilterDescendantsInstances = { t2.value7.Character }

							local hit = t2.value6:Raycast(t2.value8.CFrame.Position, v42 - t2.value8.CFrame.Position, raycastParams)

							if not hit or hit.Instance:IsDescendantOf(player.Character) then
								local Magnitude = (Vector2.new(v44.X, v44.Y) - vector2).Magnitude

								if Magnitude <= v31 then
									v34 = v42
									v31 = Magnitude
								end
							end
						end
					end
				end
			end
		end

		return v34
	end

	t2.value3:BindToRenderStep("NoksVIP_SmoothAim", Enum.RenderPriority.Camera.Value + 1, function()
		if not t2.value10.ENABLE_LOCK then
			return
		end

		if t2.value21 then
			return
		end

		if not t2.value7.Character then
			return
		end

		local v49 = t2.value39()

		if not v49 then
			return
		end

		local Position = t2.value8.CFrame.Position
		local cFrame = CFrame.new(Position, v49)
		local AIM_SMOOTHNESS = t2.value10.AIM_SMOOTHNESS

		t2.value8.CFrame = t2.value8.CFrame:Lerp(cFrame, AIM_SMOOTHNESS)
	end)
	task.spawn(function()
		while true do
			if t2.value10.ENABLE_TRIGGERBOT and t2.value39() then
				pcall(function()
					mouse1press()
					task.wait(t2.value10.TRIGGER_DELAY)
					mouse1release()
				end)
			end

			task.wait(t2.value10.TRIGGER_DELAY)
		end
	end)

	function t2.value40(p7)
		if not p7.Character then
			return false
		end

		local Humanoid = p7.Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return Humanoid
		end

		Humanoid = Humanoid.Health > 0

		return Humanoid
	end

	local function v54()
		local huge = math.huge
		local v56 = nil
		local Character = t2.value7.Character
		local pairs_, value2, v60, Magnitude

		if Character then
		elseif Character then
			pairs_ = pairs
			value2 = t2.value2

			for _, player in pairs_(value2.GetPlayers(value2)) do
				v60 = player ~= t2.value7

				if v60 then
					v60 = t2.value40(player)

					if v60 then
						v60 = player.Character

						if v60 then
							v60 = player.Character:FindFirstChild("HumanoidRootPart")
						end
					end
				end

				if v60 then
					Magnitude = (Character - player.Character.HumanoidRootPart.Position).Magnitude

					if Magnitude < huge then
						v56 = player
						huge = Magnitude
					end
				end
			end

			return v56
		else
			return nil
		end

		Character = t2.value7.Character:FindFirstChild("HumanoidRootPart")

		if Character then
		elseif Character then
			pairs_ = pairs
			value2 = t2.value2

			for _, player in pairs_(value2.GetPlayers(value2)) do
				v60 = player ~= t2.value7

				if v60 then
					v60 = t2.value40(player)

					if v60 then
						v60 = player.Character

						if v60 then
							v60 = player.Character:FindFirstChild("HumanoidRootPart")
						end
					end
				end

				if v60 then
					Magnitude = (Character - player.Character.HumanoidRootPart.Position).Magnitude

					if Magnitude < huge then
						v56 = player
						huge = Magnitude
					end
				end
			end

			return v56
		else
			return nil
		end

		Character = t2.value7.Character.HumanoidRootPart.Position

		if Character then
			pairs_ = pairs
			value2 = t2.value2

			for _, player in pairs_(value2.GetPlayers(value2)) do
				v60 = player ~= t2.value7

				if v60 then
					v60 = t2.value40(player)

					if v60 then
						v60 = player.Character

						if v60 then
							v60 = player.Character:FindFirstChild("HumanoidRootPart")
						end
					end
				end

				if v60 then
					Magnitude = (Character - player.Character.HumanoidRootPart.Position).Magnitude

					if Magnitude < huge then
						v56 = player
						huge = Magnitude
					end
				end
			end

			return v56
		else
			return nil
		end
	end

	function t2.value41()
		t2.value21 = false

		if not t2.value23 then
			t2.value22 = nil

			return
		end

		t2.value23:Disconnect()
		t2.value22 = nil
	end

	local function v68()
		if t2.value21 then
			t2.value41()

			return
		end

		t2.value21 = true
		t2.value1:Notify("Teleport Follow started!")
		t2.value3.RenderStepped:Connect(function()
			if not t2.value21 then
				return
			end

			local Character = t2.value7.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if not Humanoid then
				return
			end

			if Humanoid.Health <= 0 then
				if not t2.value10.AUTO_RETARGET then
					return
				end

				task.wait(t2.value10.RETARGET_DELAY)
				t2.value22 = v54()

				if not t2.value22 then
					return
				end

				t2.value1:Notify("Re-targeting to: " .. t2.value22.Name)
			else
				if not (t2.value22 and t2.value40(t2.value22)) then
					t2.value22 = v54()

					if not t2.value22 then
						return
					end

					t2.value1:Notify("New target: " .. t2.value22.Name)
				end

				local value22 = t2.value22

				if value22 then
					value22 = t2.value22.Character
				end

				if not value22 then
					return
				end

				local HumanoidRootPart = t2.value22.Character:FindFirstChild("HumanoidRootPart")
				local HumanoidRootPart2 = HumanoidRootPart and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart2 then
					return
				end

				HumanoidRootPart2.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, t2.value10.FOLLOW_HEIGHT, 0)
			end
		end)
	end

	function t2.value42(p8)
		if not p8:IsA("BasePart") then
			return false
		end

		if p8:FindFirstAncestorOfClass("Tool") then
			return false
		end

		local Model = p8:FindFirstAncestorOfClass("Model")

		if Model then
		elseif Model then
			return false
		elseif p8:FindFirstChildWhichIsA("SpecialMesh") or p8:FindFirstChildWhichIsA("MeshPart") then
			return false
		elseif p8.Size.Magnitude < 5 then
			return false
		elseif p8.Material == Enum.Material.Grass or p8.Name:lower():find("tree") then
			return false
		else
			return p8.Anchored and true or false
		end

		Model = Model:FindFirstChildOfClass("Humanoid")

		if Model then
			return false
		elseif p8:FindFirstChildWhichIsA("SpecialMesh") or p8:FindFirstChildWhichIsA("MeshPart") then
			return false
		elseif p8.Size.Magnitude < 5 then
			return false
		elseif p8.Material == Enum.Material.Grass or p8.Name:lower():find("tree") then
			return false
		else
			return p8.Anchored and true or false
		end
	end

	local function v75()
		local pairs_ = pairs
		local value6 = t2.value6

		for _, descendant in pairs_(value6.GetDescendants(value6)) do
			if t2.value42(descendant) then
				pcall(function()
					descendant.Color = Color3.fromRGB(50, 50, 50)
					descendant.Material = Enum.Material.SmoothPlastic
				end)
			end
		end
	end
	local function v80()
		if t2.value25 then
			t2.value25:Disconnect()
		end

		t2.value24 = true
		v75()
		t2.value25 = t2.value6.DescendantAdded:Connect(function(descendant)
			local value24 = t2.value24

			if value24 then
				value24 = t2.value42(descendant)
			end

			if not value24 then
				return
			end

			task.wait(0.1)
			pcall(function()
				descendant.Color = Color3.fromRGB(50, 50, 50)
				descendant.Material = Enum.Material.SmoothPlastic
			end)
		end)
		t2.value1:Notify("Dark Texture applied!")
	end

	function t2.value43()
		if not t2.value25 then
			t2.value1:Notify("Dark Texture disabled!")

			return
		end

		t2.value25:Disconnect()
		t2.value1:Notify("Dark Texture disabled!")
	end

	local function v82()
		local pairs_ = pairs
		local value6 = t2.value6

		for _, descendant in pairs_(value6.GetDescendants(value6)) do
			local isBasePart = descendant:IsA("BasePart")

			if isBasePart then
				isBasePart = not descendant:FindFirstAncestorOfClass("Tool")
			end

			if isBasePart then
				local Model = descendant:FindFirstAncestorOfClass("Model")

				if Model then
					Model = Model:FindFirstChildOfClass("Humanoid")
				end

				if not Model then
					local function v89()
						t2.value29[descendant] = descendant.Material
						descendant.Material = Enum.Material.Plastic
					end

					pcall(v89)
				end
			end
		end
	end
	local function v90()
		if t2.value26 then
			t2.value26:Disconnect()
		end

		v82()
		t2.value26 = t2.value6.DescendantAdded:Connect(function(descendant)
			task.wait(0.1)

			local isBasePart = descendant:IsA("BasePart")

			if isBasePart then
				isBasePart = not descendant:FindFirstAncestorOfClass("Tool")
			end

			if not isBasePart then
				return
			end

			local Model = descendant:FindFirstAncestorOfClass("Model")

			if Model then
				Model = Model:FindFirstChildOfClass("Humanoid")
			end

			if Model then
				return
			end

			local function v93()
				t2.value29[descendant] = descendant.Material
				descendant.Material = Enum.Material.Plastic
			end

			pcall(v93)
		end)
		t2.value1:Notify("Low Texture mode enabled!")
	end
	local function v94()
		if t2.value26 then
			t2.value26:Disconnect()
		end

		for k, v in pairs(t2.value29) do
			local Parent

			if k then
				Parent = k.Parent
			else
				Parent = k
			end

			if Parent then
				pcall(function()
					k.Material = v
				end)
			end
		end

		t2.value1:Notify("Low Texture mode disabled!")
	end
	local function v98()
		if t2.value20 then
			t2.value20:Disconnect()
		end

		local Character = t2.value7.Character

		if Character then
			Character = not t2.value21
		end

		if not Character then
			return
		end

		for _, descendant in pairs(t2.value7.Character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = true
			end
		end
	end

	function t2.value44()
		if t2.value21 then
			return
		end

		local Character = t2.value7.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not (HumanoidRootPart and Humanoid) then
			return
		end

		if t2.value19 then
			task.cancel(t2.value19)
		end

		if t2.value17 then
			t2.value17:Destroy()
			t2.value17 = nil
		end

		if t2.value18 then
			t2.value18:Destroy()
			t2.value18 = nil
		end

		t2.value17 = Instance.new("BodyVelocity", HumanoidRootPart)
		t2.value17.MaxForce = Vector3.new(1000000, 1000000, 1000000)
		t2.value17.Velocity = Vector3.new(0, 0, 0)
		t2.value18 = Instance.new("BodyGyro", HumanoidRootPart)
		t2.value18.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
		t2.value18.P = 10000
		Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		t2.value15 = true
		task.spawn(function()
			while true do
				local value15 = t2.value15

				if value15 then
					value15 = Character

					if value15 then
						value15 = Character.Parent

						if value15 then
							value15 = HumanoidRootPart

							if value15 then
								value15 = HumanoidRootPart.Parent
							end
						end
					end
				end

				if not value15 then
					break
				end

				local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid2 then
					local MoveDirection = Humanoid2.MoveDirection

					if t2.value17 then
						local value17 = t2.value17
						local s2 = "Velocity"
						local v110

						if MoveDirection.Magnitude > 0 then
							v110 = MoveDirection * t2.value16
						else
							v110 = false
						end

						value17[s2] = v110 or Vector3.new(0, 0, 0)
					end

					if t2.value18 then
						t2.value18.CFrame = t2.value8.CFrame
					end

					local v111

					if Humanoid2 then
						v111 = Humanoid2:GetState() ~= Enum.HumanoidStateType.Swimming
					else
						v111 = Humanoid2
					end

					if v111 then
						Humanoid2:ChangeState(Enum.HumanoidStateType.Swimming)
					end
				end

				task.wait()
			end

			if t2.value19 then
				task.cancel(t2.value19)
			end

			if t2.value17 then
				t2.value17:Destroy()
				t2.value17 = nil
			end

			if not t2.value18 then
				return
			end

			t2.value18:Destroy()
			t2.value18 = nil
		end)
	end

	local function v112()
		if t2.value19 then
			task.cancel(t2.value19)
		end

		if t2.value17 then
			t2.value17:Destroy()
			t2.value17 = nil
		end

		if t2.value18 then
			t2.value18:Destroy()
			t2.value18 = nil
		end

		local Character = t2.value7.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local v115

		if Humanoid then
			v115 = Humanoid:GetState() == Enum.HumanoidStateType.Swimming
		else
			v115 = Humanoid
		end

		if not v115 then
			return
		end

		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	t2.value7.CharacterAdded:Connect(function(_)
		task.wait(0.5)

		if not t2.value10.ENABLE_FLY then
			return
		end

		v112()
		t2.value44()
		t2.value1:Notify("Fly re-enabled for new round!")
	end)
	t2.value45 = {
		"Head",
		"UpperTorso",
		"RightUpperArm",
		"RightLowerArm",
		"LeftUpperArm",
		"LeftLowerArm",
		"LeftFoot",
		"RightFoot",
		"LowerTorso",
		"LeftHand",
		"RightHand",
		"RightUpperLeg",
		"LeftUpperLeg",
		"LeftLowerLeg",
		"RightLowerLeg"
	}

	local function v116()
		local Character = t2.value7.Character

		if not Character then
			return
		end

		if t2.value10.ENABLE_SELF_CHAMS then
			for _, v in pairs(t2.value45) do
				local v120 = Character:FindFirstChild(v)

				if v120 then
					v120.Material = Enum.Material.ForceField
					v120.Color = t2.value10.SELF_CHAMS_COLOR
				end
			end
		else
			for _, v in pairs(t2.value45) do
				local v123 = Character:FindFirstChild(v)

				if v123 then
					v123.Material = Enum.Material.Plastic
				end
			end
		end

		local Tool = Character:FindFirstChildOfClass("Tool")
		local Handle = Tool and Tool:FindFirstChild("Handle")

		if not Handle then
			return
		end

		if t2.value10.ENABLE_WEAPON_CHAMS then
			Handle.Material = Enum.Material.ForceField
			Handle.Color = t2.value10.WEAPON_CHAMS_COLOR

			return
		end

		Handle.Material = Enum.Material.Plastic
	end

	function t2.value46(p9)
		local value12 = t2.value12

		if value12 then
			value12 = t2.value12:FindFirstChild(p9.Name)
		end

		if value12 then
			t2.value12[p9.Name]:Destroy()
		end

		if t2.value11[p9] then
			t2.value11[p9]:Destroy()
			t2.value11[p9] = nil
		end

		if t2.value13[p9] then
			t2.value13[p9]:Remove()
			t2.value13[p9] = nil
		end

		if not t2.value14[p9] then
			return
		end

		t2.value14[p9]:Disconnect()
		t2.value14[p9] = nil
	end
	function t2.value47(p10)
		if p10 == t2.value7 then
			return
		end

		t2.value46(p10)

		if not t2.value12 then
			t2.value12 = Instance.new("Folder", game.CoreGui)
			t2.value12.Name = "Noks_VIP_ESP"
		end

		local function v127(p11)
			if not p11 then
				return
			end

			local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			if t2.value10.ENABLE_ESP then
				local BillboardGui = Instance.new("BillboardGui")

				BillboardGui.Name = p10.Name
				BillboardGui.Parent = t2.value12
				BillboardGui.AlwaysOnTop = true
				BillboardGui.Size = UDim2.new(5, 0, 2.5, 0)
				BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
				BillboardGui.ResetOnSpawn = false

				local TextLabel = Instance.new("TextLabel", BillboardGui)

				TextLabel.Size = UDim2.new(1, 0, 0.4, 0)
				TextLabel.BackgroundTransparency = 1
				TextLabel.Text = p10.Name
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.Font = Enum.Font.GothamBold
				TextLabel.TextScaled = true

				local Frame = Instance.new("Frame", BillboardGui)

				Frame.Size = UDim2.new(0.8, 0, 0.15, 0)
				Frame.Position = UDim2.new(0.1, 0, 0.45, 0)
				Frame.BackgroundColor3 = Color3.fromRGB(50, 45, 70)

				local Frame2 = Instance.new("Frame", Frame)

				Frame2.Size = UDim2.new(1, 0, 1, 0)
				Frame2.BackgroundColor3 = Color3.fromRGB(140, 60, 220)

				local RenderStepped = t2.value3.RenderStepped
				local v134 = RenderStepped.Connect(RenderStepped, function()
					if not (p10.Character and p10.Character:FindFirstChild("HumanoidRootPart")) then
						BillboardGui.Enabled = false

						return
					end

					local Humanoid = p10.Character:FindFirstChildOfClass("Humanoid")
					local v136

					if Humanoid then
						v136 = Humanoid.Health > 0
					else
						v136 = Humanoid
					end

					if v136 then
						local v137 = Humanoid.Health / Humanoid.MaxHealth

						Frame2.Size = UDim2.new(v137, 0, 1, 0)
						BillboardGui.Enabled = true
						BillboardGui.Adornee = HumanoidRootPart

						if v137 > 0.6 then
							Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
						elseif v137 > 0.3 then
							Frame2.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
						else
							Frame2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
						end
					else
						BillboardGui.Enabled = false
					end

					local ENABLE_TRACERS = t2.value10.ENABLE_TRACERS

					if ENABLE_TRACERS then
						ENABLE_TRACERS = p10.Character

						if ENABLE_TRACERS then
							ENABLE_TRACERS = p10.Character:FindFirstChild("Head")
						end
					end

					if ENABLE_TRACERS then
						local Humanoid2 = p10.Character:FindFirstChildOfClass("Humanoid")

						if Humanoid2 then
							Humanoid2 = Humanoid2.Health > 0
						end

						if Humanoid2 then
						elseif t2.value13[p10] then
							t2.value13[p10].Visible = false

							return
						else
							return
						end

						local Head = p10.Character.Head
						local v141, v142 = t2.value8:WorldToViewportPoint(Head.Position)

						if v142 then
						elseif v142 then
							t2.value13[p10].From = Vector2.new(t2.value8.ViewportSize.X / 2, t2.value8.ViewportSize.Y)
							t2.value13[p10].To = Vector2.new(v141.X, v141.Y)
							t2.value13[p10].Visible = true

							return
						elseif t2.value13[p10] then
							t2.value13[p10].Visible = false

							return
						else
							return
						end

						v142 = t2.value13[p10]

						if v142 then
							t2.value13[p10].From = Vector2.new(t2.value8.ViewportSize.X / 2, t2.value8.ViewportSize.Y)
							t2.value13[p10].To = Vector2.new(v141.X, v141.Y)
							t2.value13[p10].Visible = true

							return
						elseif t2.value13[p10] then
							t2.value13[p10].Visible = false

							return
						else
							return
						end
					else
						if not t2.value13[p10] then
							return
						end

						t2.value13[p10].Visible = false
					end
				end)

				t2.value14[p10] = v134
			end

			if t2.value10.ENABLE_XRAY then
				local Highlight = Instance.new("Highlight")

				Highlight.FillColor = Color3.fromRGB(140, 60, 220)
				Highlight.FillTransparency = 0.6
				Highlight.Adornee = p11
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Parent = p11
				t2.value11[p10] = Highlight

				return
			end

			if not t2.value11[p10] then
				return
			end

			local v144 = p10

			t2.value11[v144]:Destroy()
			t2.value11[p10] = nil
		end

		if p10.Character then
			v127(p10.Character)
		end

		p10.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			v127(character)
		end)

		local ENABLE_TRACERS = t2.value10.ENABLE_TRACERS

		if ENABLE_TRACERS then
			ENABLE_TRACERS = not t2.value13[p10]
		end

		if not ENABLE_TRACERS then
			return
		end

		local value13 = t2.value13
		local Line = Drawing.new("Line")

		Line.Visible = false
		Line.Color = Color3.fromRGB(140, 60, 220)
		Line.Thickness = 2
		Line.Transparency = 0.7
		value13[p10] = Line
	end

	local function v148()
		local pairs_ = pairs
		local value2 = t2.value2

		for _, player in pairs_(value2.GetPlayers(value2)) do
			if player ~= t2.value7 then
				t2.value46(player)
				t2.value47(player)
			end
		end
	end

	UserInputService.JumpRequest:Connect(function()
		local ENABLE_INFJUMP = t2.value10.ENABLE_INFJUMP

		if ENABLE_INFJUMP then
			ENABLE_INFJUMP = t2.value7.Character

			if ENABLE_INFJUMP then
				ENABLE_INFJUMP = not t2.value10.ENABLE_FLY
			end
		end

		if not ENABLE_INFJUMP then
			return
		end

		local Humanoid = t2.value7.Character:FindFirstChildOfClass("Humanoid")
		local v155

		if Humanoid then
			v155 = Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping
		else
			v155 = Humanoid
		end

		if not v155 then
			return
		end

		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	local function v156()
		if t2.value28 then
			t2.value28:Disconnect()
		end

		if not t2.value10.ENABLE_STRETCH_RES then
			return
		end

		t2.value28 = t2.value3.RenderStepped:Connect(function()
			t2.value8.CFrame = t2.value8.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, t2.value10.STRETCH_AMOUNT, 0, 0, 0, 1)
		end)
	end

	function t2.value48()
		if not t2.value28 then
			return
		end

		t2.value28:Disconnect()
	end

	t2.value49 = {
		[13110130082] = 97859770743369,
		[16530229541] = 8941612531,
		[16530229616] = 8941612531,
		[16530229695] = 8941612531,
		[16537337310] = 5043539486,
		[16537449730] = 5043539486,
		[16810041280] = 140314442804010
	}

	local function v157(p12)
		for k, v in pairs(t2.value49) do
			if "rbxassetid://" .. tostring(k) == p12.SoundId or p12.SoundId:find(unpack_({ tostring(k) })) then
				p12.SoundId = "rbxassetid://" .. tostring(v)

				return
			end
		end
	end
	local function v160()
		if not t2.value10.ENABLE_SOUND_REPLACER then
			return
		end

		local ipairs_ = ipairs
		local value6 = t2.value6

		for _, descendant in ipairs_(value6.GetDescendants(value6)) do
			if descendant:IsA("Sound") then
				v157(descendant)
			end
		end

		game.DescendantAdded:Connect(function(descendant)
			if not descendant:IsA("Sound") then
				return
			end

			v157(descendant)
		end)
	end
	local function v165()
		t2.value41()
		v112()
		v98()
		t2.value43()
		v94()
		t2.value48()
		t2.value34()

		if t2.value12 then
			t2.value12:Destroy()
		end

		local v166

		if not t2.value35 then
			t2.value3:UnbindFromRenderStep("NoksVIP_SmoothAim")
			v173, v174, v175 = pairs(t2.value14)

			while true do
				v175, v166 = v173(v174, v175)

				if not v175 then
					break
				end

				if v166 then
					v166:Disconnect()
				end
			end

			for _, v in pairs(t2.value13) do
				if v then
					v:Remove()
				end
			end

			return
		end

		t2.value35:Destroy()
		t2.value3:UnbindFromRenderStep("NoksVIP_SmoothAim")

		local v169, v170, v171 = pairs(t2.value14)

		while true do
			v171, v166 = v169(v170, v171)

			if not v171 then
				break
			end

			if v166 then
				v166:Disconnect()
			end
		end

		for _, v in pairs(t2.value13) do
			if v then
				v:Remove()
			end
		end
	end
	local function v176()
		local v177, v178, v179 = pairs(t2.value5:GetDescendants())
		local v180 = nil

		while true do
			local v181

			v179, v181 = v177(v178, v179)

			if not v179 then
				v181 = v180

				break
			end

			local isModuleScript = v181:IsA("ModuleScript")

			if isModuleScript then
				isModuleScript = v181.Name == "Utility"
			end

			if isModuleScript then
				break
			end
		end

		if not v_u_183 then
			return
		end

		local ok, result = pcall(function()
			return require(v_u_183)
		end)

		if ok then
			if result then
				ok = result.Raycast
			else
				ok = result
			end
		end

		if not ok then
			return
		end

		t2.value27 = result.Raycast

		function result.Raycast(...)
			local t5 = { ... }
			local ENABLE_SILENT_AIM = t2.value10.ENABLE_SILENT_AIM and t2.value39()

			if not ENABLE_SILENT_AIM then
				return t2.value27(table.unpack(t5))
			end

			local v185

			if #t5 >= 4 then
				v185 = t5[4] == 999
			else
				v185 = false
			end

			if not v185 then
				return t2.value27(table.unpack(t5))
			end

			t5[3] = ENABLE_SILENT_AIM

			return t2.value27(table.unpack(t5))
		end
	end

	local Aimbot = t3.Combat:AddLeftGroupbox("Aimbot")
	local World = t3.Combat:AddRightGroupbox("World")

	Aimbot.AddToggle(Aimbot, "ENABLE_LOCK", {
		Text = "Aim Snap",
		Tooltip = "Smooth aim assist",
		Default = t2.value10.ENABLE_LOCK,
		Callback = function(p13)
			t2.value10.ENABLE_LOCK = p13
			t2.value37()
		end
	})
	Aimbot:AddToggle("ENABLE_SILENT_AIM", {
		Text = "Silent Aim",
		Tooltip = "Shots automatically hit enemies",
		Default = t2.value10.ENABLE_SILENT_AIM,
		Callback = function(p14)
			t2.value10.ENABLE_SILENT_AIM = p14
			t2.value37()

			if not p14 then
				return
			end

			task.spawn(v176)
		end
	})
	Aimbot.AddToggle(Aimbot, "ENABLE_TRIGGERBOT", {
		Text = "Triggerbot",
		Tooltip = "Auto shoot when aiming at enemy",
		Default = t2.value10.ENABLE_TRIGGERBOT,
		Callback = function(p15)
			t2.value10.ENABLE_TRIGGERBOT = p15
		end
	})
	Aimbot.AddToggle(Aimbot, "ENABLE_PREDICTION", {
		Text = "Movement Prediction",
		Tooltip = "Predict enemy movement",
		Default = t2.value10.ENABLE_PREDICTION,
		Callback = function(p16)
			t2.value10.ENABLE_PREDICTION = p16
		end
	})

	local value10 = t2.value10

	Aimbot.AddToggle(Aimbot, "ENABLE_FOV_CIRCLE", {
		Text = "Show FOV Circle",
		Tooltip = "Display the FOV circle on screen",
		Default = value10.ENABLE_FOV_CIRCLE,
		Callback = function(p17)
			t2.value10.ENABLE_FOV_CIRCLE = p17
			t2.value37()
		end
	})

	local t6 = {
		Text = "FOV Range",
		Default = t2.value10.FOV,
		Min = 50,
		Max = 400,
		Rounding = 0,
		Suffix = "px",
		Callback = function(p18)
			t2.value10.FOV = p18

			if not t2.value36 then
				return
			end

			t2.value36.Size = UDim2.new(0, t2.value10.FOV, 0, t2.value10.FOV)
		end
	}

	Aimbot.AddSlider(Aimbot, "FOV", t6)

	local value102 = t2.value10

	Aimbot.AddSlider(Aimbot, "AIM_SMOOTHNESS", {
		Text = "Aim Smoothness",
		Default = value102.AIM_SMOOTHNESS,
		Min = 0.05,
		Max = 0.8,
		Rounding = 2,
		Callback = function(p19)
			t2.value10.AIM_SMOOTHNESS = p19
		end
	})

	local t7 = {
		Text = "Triggerbot Delay",
		Default = t2.value10.TRIGGER_DELAY,
		Min = 0.01,
		Max = 0.5,
		Rounding = 2,
		Suffix = "s",
		Callback = function(p20)
			t2.value10.TRIGGER_DELAY = p20
		end
	}

	Aimbot.AddSlider(Aimbot, "TRIGGER_DELAY", t7)

	local t8 = {
		Text = "Prediction Strength",
		Default = t2.value10.PREDICTION_STRENGTH,
		Min = 0.5,
		Max = 2,
		Rounding = 1,
		Suffix = "x",
		Callback = function(p21)
			t2.value10.PREDICTION_STRENGTH = p21
		end
	}

	Aimbot.AddSlider(Aimbot, "PREDICTION_STRENGTH", t8)
	Aimbot.AddDropdown(Aimbot, "HITBOX_TARGET", {
		Text = "Hitbox Target",
		Values = t4,
		Default = "Head",
		Callback = function(p22)
			t2.value10.HITBOX_TARGET = p22
		end
	})
	World:AddToggle("ENABLE_INFJUMP", {
		Text = "Infinite Jump",
		Tooltip = "Unlimited jumps",
		Default = t2.value10.ENABLE_INFJUMP,
		Callback = function(p23)
			t2.value10.ENABLE_INFJUMP = p23
		end
	})

	local t9 = {
		Text = "Fly Mode",
		Tooltip = "Enable flight (auto re-enabled each round)",
		Default = t2.value10.ENABLE_FLY,
		Callback = function(p24)
			t2.value10.ENABLE_FLY = p24

			if p24 then
				t2.value44()
			else
				v112()
			end
		end
	}

	World.AddToggle(World, "ENABLE_FLY", t9)

	local t10 = {
		Text = "Fly Speed",
		Default = t2.value10.FLY_SPEED,
		Min = 20,
		Max = 200,
		Rounding = 0,
		Suffix = "studs/s",
		Callback = function(p25)
			t2.value10.FLY_SPEED = p25
		end
	}

	World.AddSlider(World, "FLY_SPEED", t10)

	local t11 = {
		Text = "Noclip",
		Tooltip = "Walk through walls",
		Default = t2.value10.ENABLE_NOCLIP,
		Callback = function(p26)
			t2.value10.ENABLE_NOCLIP = p26

			if p26 then
				p26 = not t2.value21
			end

			if not p26 then
				v98()

				return
			end

			if t2.value20 then
				t2.value20:Disconnect()
			end

			t2.value20 = t2.value3.Stepped:Connect(function()
				local ENABLE_NOCLIP = t2.value10.ENABLE_NOCLIP

				if ENABLE_NOCLIP then
					ENABLE_NOCLIP = t2.value7.Character

					if ENABLE_NOCLIP then
						ENABLE_NOCLIP = not t2.value21
					end
				end

				if not ENABLE_NOCLIP then
					return
				end

				local pairs_ = pairs
				local Character = t2.value7.Character

				for _, descendant in pairs_(Character.GetDescendants(Character)) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
					end
				end
			end)
		end
	}

	World.AddToggle(World, "ENABLE_NOCLIP", t11)

	local v201 = t3.Visual:AddLeftGroupbox("ESP and Vision")
	local Chams = t3.Visual:AddRightGroupbox("Chams")
	local Effects = t3.Visual:AddLeftGroupbox("Effects")
	local value103 = t2.value10

	v201.AddToggle(v201, "ENABLE_XRAY", {
		Text = "XRay Vision",
		Tooltip = "See players through walls",
		Default = value103.ENABLE_XRAY,
		Callback = function(p27)
			t2.value10.ENABLE_XRAY = p27
			v148()
		end
	})

	local t12 = {
		Text = "ESP Players",
		Tooltip = "Show names and health bars",
		Default = t2.value10.ENABLE_ESP,
		Callback = function(p28)
			t2.value10.ENABLE_ESP = p28
			v148()
		end
	}

	v201.AddToggle(v201, "ENABLE_ESP", t12)
	v201:AddToggle("ENABLE_TRACERS", {
		Text = "Tracers",
		Tooltip = "Lines pointing to players",
		Default = t2.value10.ENABLE_TRACERS,
		Callback = function(p29)
			t2.value10.ENABLE_TRACERS = p29
			v148()
		end
	})
	v201:AddToggle("ENABLE_SELF_CHAMS", {
		Text = "Self Chams",
		Tooltip = "Color your own character",
		Default = t2.value10.ENABLE_SELF_CHAMS,
		Callback = function(p30)
			t2.value10.ENABLE_SELF_CHAMS = p30
		end
	})
	v201.AddToggle(v201, "ENABLE_WEAPON_CHAMS", {
		Text = "Weapon Chams",
		Tooltip = "Color your weapon",
		Default = t2.value10.ENABLE_WEAPON_CHAMS,
		Callback = function(p31)
			t2.value10.ENABLE_WEAPON_CHAMS = p31
		end
	})

	local v206 = v201:AddLabel("Self Chams Color")
	local t13 = {
		Default = t2.value10.SELF_CHAMS_COLOR,
		Title = "Self Chams Color",
		Callback = function(p32)
			t2.value10.SELF_CHAMS_COLOR = p32
		end
	}

	v206.AddColorPicker(v206, "SELF_CHAMS_COLOR", t13)
	v201:AddLabel("Weapon Chams Color"):AddColorPicker("WEAPON_CHAMS_COLOR", {
		Default = t2.value10.WEAPON_CHAMS_COLOR,
		Title = "Weapon Chams Color",
		Callback = function(p33)
			t2.value10.WEAPON_CHAMS_COLOR = p33
		end
	})

	local t14 = {
		Text = "Dark Texture",
		Tooltip = "Charcoal effect on map parts",
		Default = t2.value10.ENABLE_DARK_TEXTURE,
		Callback = function(p34)
			t2.value10.ENABLE_DARK_TEXTURE = p34

			if p34 then
				v80()
			else
				t2.value43()
			end
		end
	}

	Chams.AddToggle(Chams, "ENABLE_DARK_TEXTURE", t14)
	Chams.AddToggle(Chams, "ENABLE_LOW_TEXTURE", {
		Text = "Low Texture Mode",
		Tooltip = "Set all textures to Plastic for better FPS",
		Default = t2.value10.ENABLE_LOW_TEXTURE,
		Callback = function(p35)
			t2.value10.ENABLE_LOW_TEXTURE = p35

			if p35 then
				v90()
			else
				v94()
			end
		end
	})
	Chams:AddButton({
		Text = "FPS BOOST EXTREME",
		Func = function()
			local function v209()
				local pairs_ = pairs
				local value6 = t2.value6

				for _, descendant in pairs_(value6.GetDescendants(value6)) do
					if descendant:IsA("Decal") or descendant:IsA("Texture") then
						descendant:Destroy()
					end

					if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or (descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")))) then
						descendant:Destroy()
					end

					if descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
						descendant:Destroy()
					end

					if descendant:IsA("BloomEffect") or (descendant:IsA("BlurEffect") or descendant:IsA("SunRaysEffect")) then
						descendant:Destroy()
					end

					if descendant:IsA("Water") then
						descendant.Material = Enum.Material.SmoothPlastic
					end
				end

				local Sky = t2.value6:FindFirstChildOfClass("Sky")

				if not Sky then
					t2.value4.ClockTime = 12
					t2.value4.GlobalShadows = false
					t2.value4.Brightness = 1
					t2.value4.Ambient = Color3.fromRGB(80, 80, 80)

					return
				end

				Sky:Destroy()
				t2.value4.ClockTime = 12
				t2.value4.GlobalShadows = false
				t2.value4.Brightness = 1
				t2.value4.Ambient = Color3.fromRGB(80, 80, 80)
			end

			pcall(v209)
			t2.value1:Notify("FPS Boost applied!")
		end,
		Tooltip = "Optimize graphics for more FPS"
	})
	Effects.AddToggle(Effects, "ENABLE_SKY_CHANGER", {
		Text = "Sky Changer",
		Tooltip = "Change the skybox",
		Default = t2.value10.ENABLE_SKY_CHANGER,
		Callback = function(p36)
			t2.value10.ENABLE_SKY_CHANGER = p36

			if not p36 then
				local pairs_ = pairs
				local value4 = t2.value4

				for _, child in pairs_(value4.GetChildren(value4)) do
					if child:IsA("Sky") then
						child:Destroy()
					end
				end

				return
			end

			if t2.value10.ENABLE_CUSTOM_SKY_1 then
				t2.value9.ENABLE_CUSTOM_SKY_1:SetValue(false)
			end

			if t2.value10.ENABLE_CUSTOM_SKY_2 then
				t2.value9.ENABLE_CUSTOM_SKY_2:SetValue(false)
			end

			pcall(function()
				loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Cosmos-sky-60497"))()
			end)
		end
	})

	local value104 = t2.value10

	Effects.AddToggle(Effects, "ENABLE_CUSTOM_SKY_1", {
		Text = "Sky Changer 2 - Custom Assets",
		Tooltip = "Custom skybox assets",
		Default = value104.ENABLE_CUSTOM_SKY_1,
		Callback = function(p37)
			t2.value10.ENABLE_CUSTOM_SKY_1 = p37

			if not p37 then
				local pairs_ = pairs
				local value4 = t2.value4

				for _, child in pairs_(value4.GetChildren(value4)) do
					local isSky = child:IsA("Sky")

					if isSky then
						isSky = child.Name == "CustomSky1"
					end

					if isSky then
						child:Destroy()
					end
				end

				t2.value1:Notify("Sky Changer 2 disabled!")

				return
			end

			if t2.value10.ENABLE_SKY_CHANGER then
				t2.value9.ENABLE_SKY_CHANGER:SetValue(false)
			end

			if not t2.value10.ENABLE_CUSTOM_SKY_2 then
				v253 = pairs
				v254 = t2.value4
				v255 = {
					Bk = "rbxassetid://159454299",
					Dn = "rbxassetid://159454296",
					Ft = "rbxassetid://159454293",
					Lf = "rbxassetid://159454286",
					Rt = "rbxassetid://159454288",
					Up = "rbxassetid://159454300"
				}

				for _, child in v253(v254.GetChildren(v254)) do
					if child:IsA("Sky") then
						child:Destroy()
					end
				end

				v258 = Instance.new("Sky")
				v258.Name = "CustomSky1"
				v258.SkyboxBk = v255.Bk
				v258.SkyboxDn = v255.Dn
				v258.SkyboxFt = v255.Ft
				v258.SkyboxLf = v255.Lf
				v258.SkyboxRt = v255.Rt
				v258.SkyboxUp = v255.Up
				v258.SunAngularSize = 0
				v258.MoonAngularSize = 0
				v258.Parent = t2.value4
				t2.value4.Ambient = Color3.fromRGB(150, 150, 150)
				t2.value4.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
				t2.value1:Notify("Sky Changer 2 activated!")

				return
			end

			t2.value9.ENABLE_CUSTOM_SKY_2:SetValue(false)

			local pairs_ = pairs
			local value4 = t2.value4
			local t15 = {
				Bk = "rbxassetid://159454299",
				Dn = "rbxassetid://159454296",
				Ft = "rbxassetid://159454293",
				Lf = "rbxassetid://159454286",
				Rt = "rbxassetid://159454288",
				Up = "rbxassetid://159454300"
			}

			for _, child in pairs_(value4.GetChildren(value4)) do
				if child:IsA("Sky") then
					child:Destroy()
				end
			end

			local Sky = Instance.new("Sky")

			Sky.Name = "CustomSky1"
			Sky.SkyboxBk = t15.Bk
			Sky.SkyboxDn = t15.Dn
			Sky.SkyboxFt = t15.Ft
			Sky.SkyboxLf = t15.Lf
			Sky.SkyboxRt = t15.Rt
			Sky.SkyboxUp = t15.Up
			Sky.SunAngularSize = 0
			Sky.MoonAngularSize = 0
			Sky.Parent = t2.value4
			t2.value4.Ambient = Color3.fromRGB(150, 150, 150)
			t2.value4.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
			t2.value1:Notify("Sky Changer 2 activated!")
		end
	})
	Effects.AddToggle(Effects, "ENABLE_CUSTOM_SKY_2", {
		Text = "Sky Changer 3 - Space Skybox",
		Tooltip = "Cosmic space skybox",
		Default = t2.value10.ENABLE_CUSTOM_SKY_2,
		Callback = function(p38)
			t2.value10.ENABLE_CUSTOM_SKY_2 = p38

			if not p38 then
				local pairs_ = pairs
				local value4 = t2.value4

				for _, child in pairs_(value4.GetChildren(value4)) do
					local isSky = child:IsA("Sky")

					if isSky then
						isSky = child.Name == "CustomSky2"
					end

					if isSky then
						child:Destroy()
					end
				end

				t2.value1:Notify("Sky Changer 3 disabled!")

				return
			end

			if t2.value10.ENABLE_SKY_CHANGER then
				t2.value9.ENABLE_SKY_CHANGER:SetValue(false)
			end

			if not t2.value10.ENABLE_CUSTOM_SKY_1 then
				v266 = pairs
				v267 = t2.value4

				for _, child in v266(v267.GetChildren(v267)) do
					if child:IsA("Sky") then
						child:Destroy()
					end
				end

				v270 = Instance.new("Sky")
				v270.Name = "CustomSky2"
				v270.SkyboxBk = "rbxassetid://678556371"
				v270.SkyboxDn = "rbxassetid://678556361"
				v270.SkyboxFt = "rbxassetid://678556368"
				v270.SkyboxLf = "rbxassetid://678556373"
				v270.SkyboxRt = "rbxassetid://678556360"
				v270.SkyboxUp = "rbxassetid://678556362"
				v270.Parent = t2.value4
				t2.value1:Notify("Sky Changer 3 (Space) activated!")

				return
			end

			t2.value9.ENABLE_CUSTOM_SKY_1:SetValue(false)

			local pairs_ = pairs
			local value4 = t2.value4

			for _, child in pairs_(value4.GetChildren(value4)) do
				if child:IsA("Sky") then
					child:Destroy()
				end
			end

			local Sky = Instance.new("Sky")

			Sky.Name = "CustomSky2"
			Sky.SkyboxBk = "rbxassetid://678556371"
			Sky.SkyboxDn = "rbxassetid://678556361"
			Sky.SkyboxFt = "rbxassetid://678556368"
			Sky.SkyboxLf = "rbxassetid://678556373"
			Sky.SkyboxRt = "rbxassetid://678556360"
			Sky.SkyboxUp = "rbxassetid://678556362"
			Sky.Parent = t2.value4
			t2.value1:Notify("Sky Changer 3 (Space) activated!")
		end
	})
	Effects.AddToggle(Effects, "ENABLE_STRETCH_RES", {
		Text = "Stretch Resolution",
		Tooltip = "Stretch the screen resolution",
		Default = t2.value10.ENABLE_STRETCH_RES,
		Callback = function(p39)
			t2.value10.ENABLE_STRETCH_RES = p39

			if p39 then
				v156()
			else
				t2.value48()
			end
		end
	})

	local t16 = {
		Text = "Stretch Amount",
		Default = t2.value10.STRETCH_AMOUNT,
		Min = 0.5,
		Max = 1.2,
		Rounding = 2,
		Callback = function(p40)
			t2.value10.STRETCH_AMOUNT = p40

			if not t2.value10.ENABLE_STRETCH_RES then
				return
			end

			t2.value48()
			v156()
		end
	}

	Effects.AddSlider(Effects, "STRETCH_AMOUNT", t16)
	Effects.AddToggle(Effects, "ENABLE_SOUND_REPLACER", {
		Text = "Sound Replacer",
		Tooltip = "Replace game sounds (Kill/Shoot/Win)",
		Default = t2.value10.ENABLE_SOUND_REPLACER,
		Callback = function(p41)
			t2.value10.ENABLE_SOUND_REPLACER = p41

			if not p41 then
				return
			end

			v160()
		end
	})
	Effects.AddToggle(Effects, "ENABLE_TEXTURE_COLOR", {
		Text = "Texture Color Changer",
		Tooltip = "Change the color of all map textures in real time",
		Default = t2.value10.ENABLE_TEXTURE_COLOR,
		Callback = function(p42)
			t2.value10.ENABLE_TEXTURE_COLOR = p42

			if p42 then
				v20(t2.value32)
			else
				t2.value34()
			end
		end
	})

	local v246 = Effects:AddLabel("Texture Color")
	local t17 = {
		Default = t2.value32,
		Title = "Texture Color",
		Callback = function(p43)
			if not t2.value10.ENABLE_TEXTURE_COLOR then
				return
			end

			t2.value33(p43)
		end
	}

	v246.AddColorPicker(v246, "TEXTURE_COLOR_PICKER", t17)

	local v248 = t3.Misc:AddLeftGroupbox("Teleport and Follow")
	local Protection = t3.Misc:AddRightGroupbox("Protection")
	local Other = t3.Misc:AddLeftGroupbox("Other")
	local value105 = t2.value10

	v248.AddSlider(v248, "FOLLOW_HEIGHT", {
		Text = "Follow Height",
		Default = value105.FOLLOW_HEIGHT,
		Min = 1,
		Max = 30,
		Rounding = 0,
		Suffix = "studs",
		Callback = function(p44)
			t2.value10.FOLLOW_HEIGHT = p44
		end
	})

	local value106 = t2.value10

	v248.AddToggle(v248, "AUTO_RETARGET", {
		Text = "Auto Re-target",
		Tooltip = "Automatically find new target after death/round",
		Default = value106.AUTO_RETARGET,
		Callback = function(p45)
			t2.value10.AUTO_RETARGET = p45
		end
	})

	local value107 = t2.value10

	v248.AddSlider(v248, "RETARGET_DELAY", {
		Text = "Re-target Delay",
		Default = value107.RETARGET_DELAY,
		Min = 0.5,
		Max = 5,
		Rounding = 1,
		Suffix = "s",
		Callback = function(p46)
			t2.value10.RETARGET_DELAY = p46
		end
	})
	v248:AddButton({
		Text = "TELEPORT FOLLOW",
		Func = function()
			if t2.value21 then
				t2.value41()
			else
				v68()
			end
		end,
		Tooltip = "Teleport and follow the nearest player"
	})

	local t18 = {
		Text = "Anti Moderator",
		Tooltip = "Detect and alert for staff members",
		Default = t2.value10.ENABLE_ANTI_MOD,
		Callback = function(p47)
			t2.value10.ENABLE_ANTI_MOD = p47

			if not p47 then
				return
			end

			pcall(function()
				shared.StaffDetectorLoading = false
				autoload = true
				loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/Modules/main/StaffDetector.lua"))()
			end)
		end
	}

	Protection.AddToggle(Protection, "ENABLE_ANTI_MOD", t18)
	Other:AddButton({
		Text = "UNLOCK ALL",
		Func = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Offcial/Roblox/refs/heads/main/UnlockAll.lua"))()
				t2.value1:Notify("Unlock All executed!")
			end)
		end,
		Tooltip = "Unlock all items"
	})
	Other.AddButton(Other, {
		Text = "REMOVE SCRIPT",
		Func = function()
			v165()
			t2.value1:Unload()
		end,
		Tooltip = "Remove the script"
	})

	local Menu = t3["UI Settings"]:AddLeftGroupbox("Menu")
	local t19 = {
		Default = t2.value1.KeybindFrame.Visible,
		Text = "Open Keybind Menu",
		Callback = function(p48)
			t2.value1.KeybindFrame.Visible = p48
		end
	}

	Menu.AddToggle(Menu, "KeybindMenuOpen", t19)
	Menu.AddToggle(Menu, "ShowCustomCursor", {
		Text = "Custom Cursor",
		Default = true,
		Callback = function(p49)
			t2.value1.ShowCustomCursor = p49
		end
	})
	Menu:AddDivider()
	Menu:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
		Default = "RightShift",
		NoUI = true,
		Text = "Menu keybind"
	})
	Menu:AddButton("Unload", function()
		v165()
		t2.value1:Unload()
	end)
	t2.value1.ToggleKeybind = Options.MenuKeybind
	task.spawn(function()
		t2.value12 = Instance.new("Folder", game.CoreGui)
		t2.value12.Name = "Noks_VIP_ESP"

		for _, player in pairs(t2.value2:GetPlayers()) do
			task.spawn(function()
				t2.value47(player)
			end)
		end

		t2.value2.PlayerAdded:Connect(t2.value47)
		t2.value2.PlayerRemoving:Connect(t2.value46)
	end)
	t2.value3.RenderStepped:Connect(function()
		v116()
	end)
	t2.value1:SetWatermarkVisibility(true)
	t2.value50 = tick()
	t2.value51 = 0
	t2.value52 = 60

	function t2.value53()
		local value = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()

		return math.floor(value)
	end

	t2.value54 = pcall(function()
		return t2.value53()
	end)
	t2.value55 = game:GetService("RunService").RenderStepped:Connect(function()
		t2.value51 = t2.value51 + 1

		local value1, value52, v262, t20, value12, SetWatermark, t21

		if not (tick() - t2.value50 >= 1) then
			if t2.value54 then
				value1 = t2.value1
				value52 = t2.value52
				v262 = math.floor(value52)
				t20 = { t2.value53() }
				value1:SetWatermark(("NOKS VIP HUB | %d fps | %d ms").format("NOKS VIP HUB | %d fps | %d ms", v262, unpack_(t20)))
			else
				value12 = t2.value1
				SetWatermark = value12.SetWatermark
				t21 = { math.floor(t2.value52) }
				SetWatermark(value12, ("NOKS VIP HUB | %d fps").format("NOKS VIP HUB | %d fps", unpack_(t21)))
			end

			return
		end

		t2.value52 = t2.value51
		tick()

		if t2.value54 then
			value1 = t2.value1
			value52 = t2.value52
			v262 = math.floor(value52)
			t20 = { t2.value53() }
			value1:SetWatermark(("NOKS VIP HUB | %d fps | %d ms").format("NOKS VIP HUB | %d fps | %d ms", v262, unpack_(t20)))
		else
			value12 = t2.value1
			SetWatermark = value12.SetWatermark
			t21 = { math.floor(t2.value52) }
			SetWatermark(value12, ("NOKS VIP HUB | %d fps").format("NOKS VIP HUB | %d fps", unpack_(t21)))
		end
	end)
	t2.value1:OnUnload(function()
		t2.value55:Disconnect()
		v165()
		print("NOKS VIP HUB Unloaded!")
		t2.value1.Unloaded = true
	end)
	lib:SetLibrary(t2.value1)
	lib2:SetLibrary(t2.value1)
	lib2:IgnoreThemeSettings()
	lib2:SetIgnoreIndexes({ "MenuKeybind" })
	lib:SetFolder("NoksVIP")
	lib2:SetFolder("NoksVIP/specific-game")
	lib2:SetSubFolder("specific-place")
	lib2:BuildConfigSection(t3["UI Settings"])
	lib:ApplyToTab(t3["UI Settings"])
	lib2:LoadAutoloadConfig()
	print("NOKS VIP HUB Loaded successfully!")
end

local value3 = t1.value3

local function v268(p50)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "KeySystem"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = t1.value2:WaitForChild("PlayerGui")

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.Parent = ScreenGui

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.fromOffset(420, 200)
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.Position = UDim2.fromScale(0.5, 0.5)
	Frame2.BackgroundColor3 = Color3.fromRGB(22, 18, 40)
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 16)

	local UIStroke = Instance.new("UIStroke", Frame2)

	UIStroke.Color = Color3.fromRGB(120, 70, 220)
	UIStroke.Thickness = 1.5

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 50)
	TextLabel.Text = "ENTER YOUR KEY"
	TextLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 18
	TextLabel.Parent = Frame2

	local TextBox = Instance.new("TextBox")

	TextBox.Size = UDim2.new(1, -40, 0, 44)
	TextBox.Position = UDim2.fromOffset(20, 65)
	TextBox.PlaceholderText = "XXXXX-XXXXX-XXXXX-XXXXX"
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.PlaceholderColor3 = Color3.fromRGB(100, 85, 140)
	TextBox.BackgroundColor3 = Color3.fromRGB(38, 30, 65)
	TextBox.Font = Enum.Font.GothamMedium
	TextBox.TextSize = 15
	TextBox.ClearTextOnFocus = false
	TextBox.Parent = Frame2
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 10)
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		TextBox.Text = string.upper(TextBox.Text)
	end)

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, -40, 0, 44)
	TextButton.Position = UDim2.fromOffset(20, 125)
	TextButton.Text = "VERIFY"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.BackgroundColor3 = Color3.fromRGB(110, 60, 210)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 16
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame2
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)
	TextButton.MouseButton1Click:Connect(function()
		if not false then
			local match = TextBox.Text:match("^%s*(.-)%s*$")

			if #match == 0 then
				return
			else
				TextButton.Text = "CHECKING..."
				TextButton.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
				task.wait(0.3)

				if t1.value6(match) then
					TextButton.Text = "VALID!"
					TextButton.BackgroundColor3 = Color3.fromRGB(30, 160, 80)
					t1.value4(match)
					task.wait(0.5)
					ScreenGui:Destroy()
					p50(true)

					return
				else
					TextButton.Text = "INVALID"
					TextButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
					task.wait(1.5)
					TextButton.Text = "VERIFY"
					TextButton.BackgroundColor3 = Color3.fromRGB(110, 60, 210)

					return
				end
			end
		end
	end)
end

if value3 then
	value3 = t1.value6(t1.value3)
end

if value3 then
	t1.value7()

	return
end

v268(function(p51)
	if not p51 then
		return
	end

	t1.value7()
end)
