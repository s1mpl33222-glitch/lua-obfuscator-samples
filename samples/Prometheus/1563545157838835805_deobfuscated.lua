-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local lib = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v3 = nil
local Key = lib:CreateWindow({
	Name = "Bike Universe",
	LoadingTitle = "Bike Universe",
	LoadingSubtitle = "key required",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
}):CreateTab("Key", nil)

Key:CreateSection("Authentication")

local s1 = ""
local t1 = {
	Name = "Key",
	PlaceholderText = "Enter your key...",
	RemoveTextAfterFocusLost = false,
	Callback = function(p1)
		s1 = p1
	end
}
local v7 = Key.CreateInput(Key, t1)

Key:CreateButton({
	Name = "Submit Key",
	Callback = function()
		local v8 = s1 or ""
		local CurrentValue = v7

		if CurrentValue then
			CurrentValue = v7.CurrentValue
		end

		if CurrentValue then
			v8 = v7.CurrentValue
		end

		local v10 = v8:gsub("^%s*(.-)%s*$", "%1"):upper()
		local s2 = "KEY-7123812"

		if v10 ~= s2.upper(s2) then
			local v12 = lib
			local v13 = #v10
			local v14 = tostring(v13)

			v12.Notify(v12, {
				Title = "Invalid Key",
				Content = "Got [" .. v10 .. "] (" .. v14 .. " chars)",
				Duration = 4
			})

			return
		end

		pcall(function()
			lib:Destroy()
		end)
		task.wait(0.4)

		local ok, result = pcall(function()
			return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
		end)

		if not (ok and result) then
			warn("[Bike Universe] Rayfield reload failed: " .. tostring(result))

			return
		end

		lib = result

		local ok2, result2 = pcall(v3)

		if ok2 then
			return
		end

		warn("[Bike Universe] Main hub error: " .. tostring(result2))
	end
})

local t2 = {
	Name = "Copy Get-Key Link",
	Callback = function()
		local ok = pcall(function()
			setclipboard("https://link-hub.net/1450468/Vz9nDu9dPJ4C")
		end)

		lib:Notify({
			Title = ok and "Copied" or "Copy Failed",
			Content = ok and "https://link-hub.net/1450468/Vz9nDu9dPJ4C" or "Executor lacks setclipboard.",
			Duration = 3
		})
	end
}

Key.CreateButton(Key, t2)
v3 = function()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Lighting = game:GetService("Lighting")
	local TeleportService = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local LocalPlayer = Players.LocalPlayer
	local CurrentCamera = workspace.CurrentCamera
	local v29 = lib
	local v30 = v29.CreateWindow(v29, {
		Name = "Bike Universe",
		LoadingTitle = "Bike Universe",
		LoadingSubtitle = "by ANON",
		ConfigurationSaving = {
			Enabled = false
		},
		KeySystem = false
	})
	local Movement = v30:CreateTab("Movement", nil)
	local Visuals = v30:CreateTab("Visuals", nil)
	local Teleport = v30:CreateTab("Teleport", nil)
	local v34 = v30.CreateTab(v30, "Misc", nil)
	local u35 = false
	local n1 = 80
	local u37 = false
	local u38 = false
	local s3 = ""

	Movement:CreateSection("Speed & Jump")
	Movement.CreateSlider(Movement, {
		Name = "WalkSpeed",
		Range = { 16, 300 },
		Increment = 1,
		Suffix = "studs/s",
		CurrentValue = 16,
		Callback = function(p2)
			local Character = LocalPlayer.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			if not Humanoid then
				return
			end

			Character.Humanoid.WalkSpeed = p2
		end
	})
	Movement.CreateSlider(Movement, {
		Name = "JumpPower",
		Range = { 50, 500 },
		Increment = 1,
		Suffix = "power",
		CurrentValue = 50,
		Callback = function(p3)
			local Character = LocalPlayer.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			if not Humanoid then
				return
			end

			Character.Humanoid.UseJumpPower = true
			Character.Humanoid.JumpPower = p3
		end
	})
	Movement:CreateSection("Flight")

	local t3 = {
		Name = "Fly Speed",
		Range = { 20, 300 },
		Increment = 5,
		Suffix = "studs/s",
		CurrentValue = 80,
		Callback = function(p4)
			n1 = p4
		end
	}

	Movement.CreateSlider(Movement, t3)

	local t4 = {
		Name = "Fly",
		CurrentValue = false,
		Callback = function(p5)
			u35 = p5

			local Character = LocalPlayer.Character

			if not Character then
				return
			end

			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			if u35 then
				local BodyVelocity = Instance.new("BodyVelocity")

				BodyVelocity.Name = "FlyBV"
				BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
				BodyVelocity.Velocity = Vector3.zero
				BodyVelocity.Parent = HumanoidRootPart

				local BodyGyro = Instance.new("BodyGyro")

				BodyGyro.Name = "FlyBG"
				BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
				BodyGyro.P = 10000
				BodyGyro.Parent = HumanoidRootPart
				task.spawn(function()
					while true do
						local Parent = u35

						if Parent then
							Parent = HumanoidRootPart.Parent
						end

						if not Parent then
							return
						end

						local vector3 = Vector3.zero
						local CFrame_ = CurrentCamera.CFrame

						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							vector3 = vector3 + CFrame_.LookVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							vector3 = vector3 - CFrame_.LookVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							vector3 = vector3 - CFrame_.RightVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							vector3 = vector3 + CFrame_.RightVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							vector3 = vector3 + Vector3.new(0, 1, 0)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
							vector3 = vector3 - Vector3.new(0, 1, 0)
						end

						local FlyBV = HumanoidRootPart:FindFirstChild("FlyBV")
						local FlyBG = HumanoidRootPart:FindFirstChild("FlyBG")

						if FlyBV and FlyBG then
							local s4 = "Velocity"
							local v56

							if vector3.Magnitude > 0 then
								v56 = vector3.Unit * n1
							else
								v56 = false
							end

							FlyBV[s4] = v56 or Vector3.zero
							FlyBG.CFrame = CFrame_
						end

						RunService.RenderStepped:Wait()
					end
				end)

				return
			end

			local FlyBV = HumanoidRootPart:FindFirstChild("FlyBV")

			if FlyBV then
				FlyBV:Destroy()
			end

			local FlyBG = HumanoidRootPart:FindFirstChild("FlyBG")

			if not FlyBG then
				return
			end

			FlyBG:Destroy()
		end
	}

	Movement.CreateToggle(Movement, t4)
	Movement:CreateToggle({
		Name = "Noclip",
		CurrentValue = false,
		Callback = function(p6)
			u37 = p6
		end
	})
	RunService.Stepped:Connect(function()
		local Character = u37

		if Character then
			Character = LocalPlayer.Character
		end

		if not Character then
			return
		end

		local ipairs_ = ipairs
		local Character2 = LocalPlayer.Character

		for _, descendant in ipairs_(Character2.GetDescendants(Character2)) do
			local isBasePart = descendant:IsA("BasePart")

			if isBasePart then
				isBasePart = descendant.CanCollide
			end

			if isBasePart then
				descendant.CanCollide = false
			end
		end
	end)
	Visuals:CreateSection("Player ESP")

	local t5 = {
		Name = "ESP Players",
		CurrentValue = false,
		Callback = function(p7)
			u38 = p7

			if p7 then
				return
			end

			local v66 = Players

			for _, player in ipairs(v66.GetPlayers(v66)) do
				if player.Character then
					local ESP_Highlight = player.Character:FindFirstChild("ESP_Highlight")

					if ESP_Highlight then
						ESP_Highlight:Destroy()
					end
				end
			end
		end
	}

	Visuals.CreateToggle(Visuals, t5)
	task.spawn(function()
		while task.wait(1) do
			if u38 then
				local v70 = Players

				for _, player in ipairs(v70.GetPlayers(v70)) do
					local v73 = player ~= LocalPlayer

					if v73 then
						v73 = player.Character

						if v73 then
							v73 = not player.Character:FindFirstChild("ESP_Highlight")
						end
					end

					if v73 then
						local Highlight = Instance.new("Highlight")

						Highlight.Name = "ESP_Highlight"
						Highlight.Adornee = player.Character
						Highlight.Parent = player.Character
						Highlight.FillColor = Color3.fromRGB(0, 255, 80)
						Highlight.FillTransparency = 0.5
						Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						Highlight.OutlineTransparency = 0
						Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					end
				end
			end
		end
	end)
	Visuals:CreateSection("World")
	Visuals:CreateToggle({
		Name = "Fullbright",
		CurrentValue = false,
		Callback = function(p8)
			if p8 then
				Lighting.Ambient = Color3.fromRGB(255, 255, 255)
				Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
				Lighting.Brightness = 2
			else
				Lighting.Ambient = Color3.fromRGB(70, 70, 70)
				Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
				Lighting.Brightness = 1
			end
		end
	})
	Teleport:CreateSection("Player Teleport")

	local function v75()
		local t6 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local Name = player.Name

				table.insert(t6, Name)
			end
		end

		return #t6 == 0 and { "(no players)" } or t6
	end

	local t7 = {
		Name = "Target Player",
		Options = v75(),
		CurrentOption = {},
		Callback = function(p9)
			if type(p9) ~= "table" then
				s3 = p9

				return
			end

			p9 = p9[1] or p9
			s3 = p9
		end
	}
	local v81 = Teleport.CreateDropdown(Teleport, t7)
	local t8 = {
		Name = "Refresh Player List",
		Callback = function()
			local function v83()
				v81:Refresh(v75(), true)
			end

			pcall(v83)
			lib:Notify({
				Title = "Refreshed",
				Content = "Player list updated.",
				Duration = 2
			})
		end
	}

	Teleport.CreateButton(Teleport, t8)

	local t9 = {
		Name = "Teleport to Player",
		Callback = function()
			if s3 == "" or s3 == "(no players)" then
				return
			end

			local v85 = Players:FindFirstChild(s3)
			local Character

			if v85 then
				Character = v85.Character

				if Character then
					Character = v85.Character:FindFirstChild("HumanoidRootPart")
				end
			else
				Character = v85
			end

			if not Character then
				return
			end

			local Character2 = LocalPlayer.Character
			local HumanoidRootPart

			if Character2 then
				HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character2
			end

			if not HumanoidRootPart then
				return
			end

			Character2.HumanoidRootPart.CFrame = v85.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		end
	}

	Teleport.CreateButton(Teleport, t9)
	Teleport.CreateButton(Teleport, {
		Name = "Teleport to Spawn",
		Callback = function()
			local Character = LocalPlayer.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local SpawnLocation = HumanoidRootPart and workspace:FindFirstChildOfClass("SpawnLocation")

			if not SpawnLocation then
				return
			end

			Character.HumanoidRootPart.CFrame = SpawnLocation.CFrame + Vector3.new(0, 3, 0)
		end
	})
	v34:CreateSection("Session")
	v34:CreateButton({
		Name = "Rejoin Server",
		Callback = function()
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end
	})

	local t10 = {
		Name = "Server Hop",
		Callback = function()
			local function v93()
				return HttpService:JSONDecode(unpack_({ game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100") }))
			end

			local ok, result = pcall(v93)

			if ok then
				if result then
					ok = result.data
				else
					ok = result
				end
			end

			if not ok then
				return
			end

			for _, v in ipairs(result.data) do
				local v98 = v.playing < v.maxPlayers

				if v98 then
					v98 = v.id ~= game.JobId
				end

				if v98 then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)

					return
				end
			end
		end
	}

	v34.CreateButton(v34, t10)
	v34:CreateButton({
		Name = "Copy Get-Key Link",
		Callback = function()
			local ok = pcall(function()
				setclipboard("https://link-hub.net/1450468/Vz9nDu9dPJ4C")
			end)

			lib:Notify({
				Title = ok and "Copied" or ok or "Copy Failed",
				Content = ok and "https://link-hub.net/1450468/Vz9nDu9dPJ4C" or "Executor lacks setclipboard.",
				Duration = 3
			})
		end
	})
end
