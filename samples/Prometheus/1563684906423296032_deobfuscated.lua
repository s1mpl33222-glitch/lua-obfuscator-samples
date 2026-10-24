-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("Players")
}
local RunService = game:GetService("RunService")

t1.value2 = game:GetService("UserInputService")
t1.value3 = game:GetService("Workspace")
t1.value4 = t1.value1.LocalPlayer
t1.value5 = t1.value3.CurrentCamera or t1.value3:FindFirstChild("Camera")

local _ = t1.value5
local t2 = {}

while true do
	t2.value1 = t1.value3.CurrentCamera

	local value1 = t2.value1

	if not t2.value1 then
		value1 = t1.value3:FindFirstChild("Camera")
	end

	t1.value5 = value1
	task.wait(0.1)

	if t1.value5 then
		t1.value6 = {
			Aimbot = {
				Enabled = false,
				Key = "RightClick",
				Smoothness = 0.5,
				TargetPart = "PhysicalHitboxHead",
				TeamCheck = true,
				WallCheck = false,
				FOV_Radius = 150,
				FOV_Visible = false,
				FOV_Color = Color3.fromRGB(255, 255, 255)
			},
			ESP = {
				Enabled = false,
				RefreshRateMs = 0,
				TeamCheck = true,
				Box = false,
				BoxColor = Color3.fromRGB(255, 0, 0),
				BoxTeamColor = false,
				HealthBar = false,
				HealthText = false,
				Glow = false,
				GlowColor = Color3.fromRGB(255, 0, 0),
				GlowTransparency = 0.5,
				GlowOutlineColor = Color3.fromRGB(255, 255, 255)
			}
		}
		t1.value7 = Drawing.new("Circle")
		t1.value7.Position = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2)
		t1.value7.Radius = t1.value6.Aimbot.FOV_Radius
		t1.value7.Filled = false
		t1.value7.Color = t1.value6.Aimbot.FOV_Color
		t1.value7.Visible = t1.value6.Aimbot.FOV_Visible
		t1.value7.Thickness = 1
		t1.value5:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			t1.value7.Position = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2)
		end)
		t1.value8 = nil

		function t1.value9(p1)
			if not t1.value6.Aimbot.TeamCheck then
				return true
			end

			if p1 == t1.value4 then
				return false
			end

			local attribute = t1.value4:GetAttribute("TeamID")
			local attribute2 = p1:GetAttribute("TeamID")
			local v8 = attribute == nil

			if not v8 then
				return v8 and true or attribute ~= attribute2
			end

			v8 = attribute2 == nil

			return v8 and true or attribute ~= attribute2
		end
		function t1.value10(p2)
			local TargetPart = t1.value6.Aimbot.TargetPart
			local v10 = p2:FindFirstChild(TargetPart)

			if v10 then
				return v10
			elseif TargetPart == "PhysicalHitboxHead" and true or TargetPart == "HitboxHead" then
				return p2:FindFirstChild("PhysicalHitboxHead") or (p2:FindFirstChild("HitboxHead") or p2:FindFirstChild("Head"))
			elseif TargetPart == "HitboxBody" then
				return p2:FindFirstChild("HitboxBody") or (p2:FindFirstChild("HumanoidRootPart") or p2:FindFirstChild("UpperTorso"))
			else
				return p2:FindFirstChild("Head") or p2.PrimaryPart
			end
		end

		t1.value8 = {}

		function t1.value11(p3)
			local t3 = {
				Box = Drawing.new("Square"),
				BoxOutline = Drawing.new("Square"),
				HealthBar = Drawing.new("Square"),
				HealthBarOutline = Drawing.new("Square"),
				HealthText = Drawing.new("Text"),
				Highlight = Instance.new("Highlight")
			}

			t3.Box.Thickness = 1
			t3.Box.Filled = false
			t3.Box.Color = t1.value6.ESP.BoxColor
			t3.BoxOutline.Thickness = 3
			t3.BoxOutline.Filled = false
			t3.BoxOutline.Color = Color3.new(0, 0, 0)
			t3.HealthBar.Thickness = 1
			t3.HealthBar.Filled = true
			t3.HealthBarOutline.Thickness = 1
			t3.HealthBarOutline.Filled = false
			t3.HealthBarOutline.Color = Color3.new(0, 0, 0)
			t3.HealthText.Size = 13
			t3.HealthText.Center = true
			t3.HealthText.Outline = true
			t3.HealthText.Color = Color3.new(1, 1, 1)
			t3.Highlight.FillColor = t1.value6.ESP.GlowColor
			t3.Highlight.FillTransparency = t1.value6.ESP.GlowTransparency
			t3.Highlight.OutlineColor = t1.value6.ESP.GlowOutlineColor
			t3.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

			local syn_ = syn

			if syn_ then
				syn_ = syn.protect_gui
			end

			if syn_ then
				syn.protect_gui(t3.Highlight)
			end

			if pcall(function()
				t3.Highlight.Parent = game:GetService("CoreGui")
			end) then
				t1.value8[p3] = t3

				return
			end

			t3.Highlight.Parent = workspace:FindFirstChild("Camera") or workspace
			t1.value8[p3] = t3
		end

		t1.value12 = 0
		RunService.RenderStepped:Connect(function()
			t1.value5 = t1.value3.CurrentCamera or t1.value3:FindFirstChild("Camera")

			if not t1.value5 then
				return
			end

			local value7 = t1.value7
			local s1 = "Visible"
			local FOV_Visible = t1.value6.Aimbot.FOV_Visible

			if FOV_Visible then
				FOV_Visible = t1.value6.Aimbot.Enabled
			end

			value7[s1] = FOV_Visible
			t1.value7.Radius = t1.value6.Aimbot.FOV_Radius

			local v16 = (tick() - t1.value12) * 1000 >= t1.value6.ESP.RefreshRateMs
			local ipairs_ = ipairs
			local value12 = t1.value1

			for _, player in ipairs_(value12.GetPlayers(value12)) do
				if player ~= t1.value4 then
					local v21 = t1.value8[player]

					if not v21 then
						t1.value11(player)
						v21 = t1.value8[player]
					end

					local Character = player.Character
					local v23

					if v16 then
						v23 = v21.LastEnemyState ~= nil
					else
						v23 = v16
					end

					if v23 then
						v21.LastEnemyState = t1.value9(player)
					elseif v21.LastEnemyState == nil then
						v21.LastEnemyState = t1.value9(player)
					end

					local LastEnemyState = v21.LastEnemyState
					local Enabled = t1.value6.ESP.Enabled

					if Enabled then
						local Character2 = player.Character

						if Character2 then
							Enabled = Character2:FindFirstChild("Humanoid")

							if Enabled then
								Enabled = Enabled.Health > 0
							end
						else
							Enabled = false
						end

						if Enabled then
							Enabled = not t1.value6.ESP.TeamCheck or LastEnemyState
						end
					end

					if Enabled then
						local HitboxBody = Character:FindFirstChild("HitboxBody") or Character:FindFirstChild("HumanoidRootPart")
						local PhysicalHitboxHead = Character:FindFirstChild("PhysicalHitboxHead") or (Character:FindFirstChild("HitboxHead") or Character:FindFirstChild("Head"))
						local Humanoid = Character:FindFirstChild("Humanoid")
						local v30

						if HitboxBody then
							if PhysicalHitboxHead then
								if Humanoid then
									v30 = Humanoid.MaxHealth > 0
								else
									v30 = Humanoid
								end
							else
								v30 = PhysicalHitboxHead
							end
						else
							v30 = HitboxBody
						end

						if v30 then
							local v31, v32 = t1.value5:WorldToViewportPoint(HitboxBody.Position)
							local value5 = t1.value5
							local Position = PhysicalHitboxHead.Position
							local Vector3_ = Vector3
							local v36 = value5.WorldToViewportPoint(value5, Position + Vector3_.new(0, 0.5, 0))
							local v37 = t1.value5:WorldToViewportPoint(HitboxBody.Position - Vector3.new(0, 3, 0))

							if v32 then
								local v38 = v36.Y - v37.Y
								local v39 = math.abs(v38)
								local v40 = v39 / 2
								local vector2 = Vector2.new(v40, v39)
								local vector22 = Vector2.new(v31.X - v40 / 2, v36.Y)
								local BoxColor = t1.value6.ESP.BoxColor
								local BoxTeamColor = t1.value6.ESP.BoxTeamColor

								if BoxTeamColor then
									BoxTeamColor = player.TeamColor
								end

								if BoxTeamColor then
									BoxColor = player.TeamColor.Color
								end

								v21.Box.Size = vector2
								v21.Box.Position = vector22
								v21.Box.Visible = t1.value6.ESP.Box
								v21.Box.Color = BoxColor
								v21.BoxOutline.Size = vector2
								v21.BoxOutline.Position = vector22
								v21.BoxOutline.Visible = t1.value6.ESP.Box

								local MaxHealth = Humanoid.MaxHealth > 0 and (Humanoid.MaxHealth or 100) or 100
								local v46 = Humanoid.Health / MaxHealth
								local v47 = math.clamp(v46, 0, 1)
								local color3 = Color3.fromHSV(v47 * 0.3, 1, 1)
								local vector23 = Vector2.new(2, v39)
								local vector24 = Vector2.new(vector22.X - 6, vector22.Y)

								v21.HealthBarOutline.Size = vector23 + Vector2.new(2, 2)
								v21.HealthBarOutline.Position = vector24 - Vector2.new(1, 1)
								v21.HealthBarOutline.Visible = t1.value6.ESP.HealthBar
								v21.HealthBar.Size = Vector2.new(2, v39 * v47)
								v21.HealthBar.Position = Vector2.new(vector22.X - 5, vector22.Y + (v39 - v21.HealthBar.Size.Y))
								v21.HealthBar.Color = color3
								v21.HealthBar.Visible = t1.value6.ESP.HealthBar

								local HealthText = v21.HealthText
								local Health = Humanoid.Health
								local v53 = math.floor(Health)

								HealthText.Text = tostring(v53) .. " HP"
								v21.HealthText.Position = Vector2.new(vector22.X - 25, v21.HealthBar.Position.Y - 5)
								v21.HealthText.Visible = t1.value6.ESP.HealthText
								v21.HealthText.Color = color3

								if t1.value6.ESP.Glow then
									v21.Highlight.Adornee = Character
									v21.Highlight.FillColor = t1.value6.ESP.GlowColor

									local BoxTeamColor2 = t1.value6.ESP.BoxTeamColor

									if BoxTeamColor2 then
										BoxTeamColor2 = player.TeamColor
									end

									if BoxTeamColor2 then
										v21.Highlight.FillColor = player.TeamColor.Color
									end
								else
									v21.Highlight.Adornee = nil
								end
							else
								v21.Box.Visible = false
								v21.BoxOutline.Visible = false
								v21.HealthBar.Visible = false
								v21.HealthBarOutline.Visible = false
								v21.HealthText.Visible = false
								v21.Highlight.Adornee = nil
							end
						end
					else
						v21.Box.Visible = false
						v21.BoxOutline.Visible = false
						v21.HealthBar.Visible = false
						v21.HealthBarOutline.Visible = false
						v21.HealthText.Visible = false
						v21.Highlight.Adornee = nil
					end
				end
			end
		end)

		local PlayerRemoving = t1.value1.PlayerRemoving

		PlayerRemoving.Connect(PlayerRemoving, function(p4)
			local v56 = t1.value8[p4]

			if not v56 then
				return
			end

			v56.Box:Remove()
			v56.BoxOutline:Remove()
			v56.HealthBar:Remove()
			v56.HealthBarOutline:Remove()
			v56.HealthText:Remove()

			if v56.Highlight then
				v56.Highlight:Destroy()
			end

			t1.value8[p4] = nil
		end)

		function t1.value13()
			local FOV_Radius = t1.value6.Aimbot.FOV_Radius
			local vector2 = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2)
			local ipairs_ = ipairs
			local value12 = t1.value1
			local v61 = nil

			for _, player in ipairs_(value12.GetPlayers(value12)) do
				local v64 = player ~= t1.value4

				if v64 then
					local Character = player.Character

					if Character then
						v64 = Character:FindFirstChild("Humanoid")

						if v64 then
							v64 = v64.Health > 0
						end
					else
						v64 = false
					end

					if v64 then
						v64 = t1.value9(player)
					end
				end

				if v64 then
					local Character = player.Character
					local v67

					if Character then
						v67 = t1.value10(Character)
					else
						v67 = Character
					end

					if v67 then
						local v68, v69 = t1.value5:WorldToViewportPoint(v67.Position)

						if v69 then
							local Magnitude = (Vector2.new(v68.X, v68.Y) - vector2).Magnitude
							local v71

							if Magnitude < t1.value6.Aimbot.FOV_Radius then
								v71 = Magnitude < FOV_Radius
							else
								v71 = false
							end

							if v71 then
								if t1.value6.Aimbot.WallCheck then
									local raycastParams = RaycastParams.new()

									raycastParams.FilterDescendantsInstances = { t1.value4.Character, t1.value5 }
									raycastParams.FilterType = Enum.RaycastFilterType.Exclude

									local v73 = v67.Position - t1.value5.CFrame.Position
									local hit = t1.value3:Raycast(t1.value5.CFrame.Position, v73.Unit * (v73.Magnitude + 1), raycastParams)
									local v75 = hit == nil

									if not v75 then
										v75 = hit.Instance

										if v75 then
											v75 = hit.Instance:IsDescendantOf(Character)
										end
									end

									if v75 then
										v61 = player
										FOV_Radius = Magnitude
									end
								else
									v61 = player
									FOV_Radius = Magnitude
								end
							end
						end
					end
				end
			end

			return v61
		end
		function t1.value14()
			local Key = t1.value6.Aimbot.Key

			if type(Key) ~= "string" then
				return false
			end

			local ok, result = pcall(function()
				local v79 = Key

				return Enum.UserInputType[tostring(v79)]
			end)

			if ok and result then
				local value2 = t1.value2

				return value2.IsMouseButtonPressed(value2, result)
			end

			local ok2, result2 = pcall(function()
				local v83 = Key

				return Enum.KeyCode[tostring(v83)]
			end)

			if ok2 and result2 then
				local value2 = t1.value2

				return value2.IsKeyDown(value2, result2)
			elseif tostring(Key) == "RightClick" then
				local value2 = t1.value2
				local MouseButton2 = Enum.UserInputType.MouseButton2

				return value2.IsMouseButtonPressed(value2, MouseButton2)
			elseif tostring(Key) == "LeftClick" then
				local value2 = t1.value2
				local MouseButton1 = Enum.UserInputType.MouseButton1

				return value2.IsMouseButtonPressed(value2, MouseButton1)
			else
				return false
			end
		end

		RunService:BindToRenderStep("RivalsAimbotStep", Enum.RenderPriority.Camera.Value + 1, function()
			t1.value5 = t1.value3.CurrentCamera or t1.value3:FindFirstChild("Camera")

			if not t1.value5 then
				return
			end

			local Enabled = t1.value6.Aimbot.Enabled

			if Enabled then
				Enabled = t1.value14()
			end

			if not Enabled then
				return
			end

			local v90 = t1.value13()
			local Character

			if v90 then
				Character = v90.Character
			else
				Character = v90
			end

			local v92 = Character and t1.value10(v90.Character)

			if not v92 then
				return
			end

			local v93, mousemoverel_ = t1.value5:WorldToViewportPoint(v92.Position)

			if mousemoverel_ then
				mousemoverel_ = mousemoverel
			end

			if not mousemoverel_ then
				return
			end

			local vector2 = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2)
			local vector22 = Vector2.new(v93.X - vector2.X, v93.Y - vector2.Y)

			mousemoverel(vector22.X * t1.value6.Aimbot.Smoothness, vector22.Y * t1.value6.Aimbot.Smoothness)
		end)

		local ok, value2 = pcall(function()
			return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
		end)

		t2.value2 = value2
		t1.value15 = t2.value2
		t2.value2 = not (ok and t1.value15)

		if t2.value2 then
			warn("CRITICAL ERROR: Fluent UI Library failed to load.")

			return
		end

		local HttpService = game:GetService("HttpService")

		t2.value4 = isfile("BreezeLogo_Rivals.png")

		if not t2.value4 then
			function t2.value5()
				return game:HttpGet("https://i.imgur.com/s2zJdPS.png")
			end

			local ok2, value4 = pcall(t2.value5)

			t2.value3 = ok2
			t2.value4 = value4

			local value3 = t2.value3

			if value3 then
				value3 = t2.value4
			end

			if value3 then
				writefile("BreezeLogo_Rivals.png", t2.value4)
			end
		end

		local s2 = ""
		local s3 = "Unknown API Error"
		local v105 = string.gsub("Breeze Beta 1.0", " ", "%%20")
		local v106 = v105 .. "&ownerid=wV5LthSnHN&type=init&ver=1.0"
		local v107 = nil

		local function v108()
			return game:HttpGet(v107)
		end

		v107 = "https://keyauth.win/api/1.1/?name=" .. v106

		local ok2, value12 = pcall(v108)

		t2.value11 = ok2
		t2.value12 = value12

		local value122 = t2.value12
		local value11 = t2.value11

		if t2.value11 then
			value11 = value122 ~= "KeyAuth_Invalid"
		end

		if value11 then
			local ok3, value6 = pcall(function()
				return HttpService:JSONDecode(value122)
			end)

			t2.value6 = value6

			if ok3 then
				ok3 = t2.value6
			end

			if ok3 then
				if t2.value6.success then
					s2 = t2.value6.sessionid
				else
					s3 = t2.value6.message or "Init Request Failed"
					warn("KeyAuth Init Failed: " .. tostring(s3))
				end
			else
				s3 = "Failed to parse API JSON"
			end
		else
			warn("Failed to reach KeyAuth servers. " .. tostring(value122))
			s3 = "Server Unreachable"
		end

		t2.value6 = t1.value15
		t2.value13 = UDim2.fromOffset(580, 460)

		local CreateWindow = t2.value6.CreateWindow

		t2.value15 = Enum.KeyCode.RightControl

		local v116 = CreateWindow(t2.value6, {
			Title = "Breeze Rivals Menu",
			SubTitle = "by Breeze",
			TabWidth = 160,
			Size = t2.value13,
			Acrylic = true,
			Theme = "Dark",
			MinimizeKey = t2.value15
		})

		t2.value7 = isfile("BreezeLogo_Rivals.png")

		if t2.value7 then
			task.spawn(function()
				task.wait(0.5)

				local CoreGui = game:GetService("CoreGui")
				local v118, v119, v120 = pairs(CoreGui:GetChildren())
				local TitleBar = nil

				while true do
					local v122

					v120, v122 = v118(v119, v120)

					if not v120 then
						break
					end

					local isScreenGui = v122:IsA("ScreenGui")

					if isScreenGui then
						isScreenGui = v122:FindFirstChild("Window")
					end

					TitleBar = isScreenGui and v122.Window:FindFirstChild("TitleBar")

					if TitleBar then
						break
					end
				end

				if not TitleBar then
					return
				end

				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Name = "CustomLogo"
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.Position = UDim2.new(0, 10, 0.5, 0)
				ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
				ImageLabel.Size = UDim2.new(0, 24, 0, 24)
				ImageLabel.Image = getcustomasset("BreezeLogo_Rivals.png")
				ImageLabel.Parent = TitleBar

				local Title = TitleBar:FindFirstChild("Title")

				if not Title then
					return
				end

				Title.Position = UDim2.new(0, 40, 0.5, 0)
			end)
		end

		t2.value9 = v116:AddTab({
			Title = "Login",
			Icon = "key"
		})

		local t4 = {
			Login = t2.value9,
			Aimbot = nil,
			ESP = nil
		}

		v116:SelectTab(1)

		function t2.value8()
			t4.Aimbot = v116:AddTab({
				Title = "Aimbot",
				Icon = "crosshair"
			})
			t4.ESP = v116:AddTab({
				Title = "ESP",
				Icon = "eye"
			})
			v116:SelectTab(2)

			local Aimbot = t4.Aimbot

			Aimbot.AddDropdown(Aimbot, "AimKey", {
				Title = "Aimbot Aimlock Key",
				Values = {
					"RightClick",
					"LeftClick",
					"E",
					"Q",
					"LeftShift",
					"LeftControl"
				},
				Multi = false,
				Default = 1
			}):OnChanged(function(p5)
				t1.value6.Aimbot.Key = p5
			end)
			t4.Aimbot:AddToggle("AimbotEnabled", {
				Title = "Enable Aimbot",
				Default = false
			}):OnChanged(function(p6)
				t1.value6.Aimbot.Enabled = p6
			end)
			t4.Aimbot:AddToggle("FOVVisible", {
				Title = "Show FOV Circle",
				Default = false
			}):OnChanged(function(p7)
				t1.value6.Aimbot.FOV_Visible = p7
			end)
			t4.Aimbot:AddToggle("AimbotTeamCheck", {
				Title = "Team Check (Rivals Perfect Check)",
				Default = true
			}):OnChanged(function(p8)
				t1.value6.Aimbot.TeamCheck = p8
			end)

			local Aimbot2 = t4.Aimbot
			local t5 = {
				Title = "Aimbot Smoothness",
				Default = 0.5,
				Min = 0.01,
				Max = 1,
				Rounding = 2,
				Callback = function(p9)
					t1.value6.Aimbot.Smoothness = p9
				end
			}

			Aimbot2.AddSlider(Aimbot2, "AimbotSmoothness", t5)

			local Aimbot3 = t4.Aimbot
			local t6 = {
				Title = "FOV Radius",
				Default = 150,
				Min = 10,
				Max = 500,
				Rounding = 0,
				Callback = function(p10)
					t1.value6.Aimbot.FOV_Radius = p10
				end
			}

			Aimbot3.AddSlider(Aimbot3, "FOVRadius", t6)
			t4.Aimbot:AddToggle("WallCheck", {
				Title = "Wall Check",
				Default = false
			}):OnChanged(function(p11)
				t1.value6.Aimbot.WallCheck = p11
			end)

			local Aimbot4 = t4.Aimbot

			Aimbot4.AddDropdown(Aimbot4, "TargetPart", {
				Title = "Target Body Part",
				Values = {
					"PhysicalHitboxHead",
					"HitboxHead",
					"Head",
					"HitboxBody",
					"HumanoidRootPart"
				},
				Multi = false,
				Default = 1
			}):OnChanged(function(p12)
				t1.value6.Aimbot.TargetPart = p12
			end)
			t4.ESP:AddToggle("MasterESP", {
				Title = "Master ESP Switch",
				Default = false
			}):OnChanged(function(p13)
				t1.value6.ESP.Enabled = p13
			end)
			t4.ESP:AddToggle("ESPTeamCheck", {
				Title = "Team Check (Rivals Perfect Check)",
				Default = true
			}):OnChanged(function(p14)
				t1.value6.ESP.TeamCheck = p14
			end)

			local ESP = t4.ESP
			local t7 = {
				Title = "ESP Refresh Rate (ms)",
				Default = 0,
				Min = 0,
				Max = 1000,
				Rounding = 0,
				Callback = function(p15)
					t1.value6.ESP.RefreshRateMs = p15
				end
			}

			ESP.AddSlider(ESP, "ESPRefreshRate", t7)
			t4.ESP:AddToggle("BoxESP", {
				Title = "Box ESP",
				Default = false
			}):OnChanged(function(p16)
				t1.value6.ESP.Box = p16
			end)
			t4.ESP:AddToggle("HealthBar", {
				Title = "Health Bar",
				Default = false
			}):OnChanged(function(p17)
				t1.value6.ESP.HealthBar = p17
			end)
			t4.ESP:AddToggle("HealthText", {
				Title = "Health Text",
				Default = false
			}):OnChanged(function(p18)
				t1.value6.ESP.HealthText = p18
			end)
			t4.ESP:AddToggle("GlowESP", {
				Title = "Glow ESP",
				Default = false
			}):OnChanged(function(p19)
				t1.value6.ESP.Glow = p19
			end)
			t1.value15:Notify({
				Title = "Breeze Menu Loaded",
				Content = "The Rivals Exploit has successfully authenticated.",
				Duration = 5
			})
		end

		local value8 = t2.value8
		local s4 = ""

		t2.value8 = t4.Login
		t2.value10 = t2.value8.AddInput

		function t2.value16(p20)
			s4 = p20
		end

		t2.value10(t2.value8, "KeyInput", {
			Title = "Enter License Key",
			Default = "",
			Placeholder = "Paste Key Here...",
			Numeric = false,
			Finished = false,
			Callback = t2.value16
		})
		t2.value8 = t4.Login
		t2.value10 = t2.value8.AddButton

		function t2.value14()
			if s4 == "" then
				local function v137()
					if not getclipboard then
						return
					end

					s4 = getclipboard()
				end

				pcall(v137)
			end

			s4 = string.gsub(s4, "^%s*(.-)%s*$", "%1")

			if s4 == "" then
				t1.value15:Notify({
					Title = "Error",
					Content = "Key cannot be empty! Your clipboard is empty.",
					Duration = 4
				})

				return
			end

			if s2 == "" then
				local v138 = s3

				t1.value15:Notify({
					Title = "API Error",
					Content = "Init Failed: " .. tostring(v138),
					Duration = 6
				})

				return
			end

			t1.value15:Notify({
				Title = "Verifying",
				Content = "Checking key with KeyAuth...",
				Duration = 2
			})

			local s5 = "Unknown_HWID"

			pcall(function()
				if gethwid then
					s5 = gethwid()
				else
					local UserId = game:GetService("Players").LocalPlayer.UserId

					s5 = tostring(UserId)
				end
			end)

			local data = HttpService:JSONDecode((game:HttpGet("https://keyauth.win/api/1.1/?name=" .. v105 .. "&ownerid=" .. "wV5LthSnHN" .. "&type=license&key=" .. s4 .. "&hwid=" .. s5 .. "&ver=" .. "1.0" .. "&sessionid=" .. s2)))

			if data.success then
				t1.value15:Notify({
					Title = "Success!",
					Content = "Key Verified! Loading features...",
					Duration = 3
				})
				task.wait(1)
				value8()
				task.spawn(function()
					t4.Login = nil

					local ScreenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")

					if not ScreenGui then
						return
					end

					local Window = ScreenGui:FindFirstChild("Window")

					if Window then
						Window = ScreenGui.Window:FindFirstChild("TabHolder")
					end

					if Window then
						local GetDescendants = Window.GetDescendants

						for _, v in pairs(GetDescendants(Window)) do
							local isTextLabel = v:IsA("TextLabel")

							if isTextLabel then
								isTextLabel = v.Text == "Login"
							end

							if isTextLabel then
								local Parent = v.Parent
								local Parent2

								if Parent then
									Parent2 = Parent.Parent
								else
									Parent2 = Parent
								end

								if Parent2 then
									Parent.Parent:Destroy()
								end
							end
						end
					end

					local Window2 = ScreenGui:FindFirstChild("Window")

					if Window2 then
						Window2 = ScreenGui.Window:FindFirstChild("Elements")
					end

					if not Window2 then
						return
					end

					local v151 = Window2:GetChildren()[1]
					local isScrollingFrame

					if v151 then
						isScrollingFrame = v151:IsA("ScrollingFrame")
					else
						isScrollingFrame = v151
					end

					if not isScrollingFrame then
						return
					end

					v151:Destroy()
				end)
			else
				t1.value15:Notify({
					Title = "Invalid",
					Content = data.message or "Invalid Key",
					Duration = 3
				})
			end
		end

		t2.value10(t2.value8, {
			Title = "Verify Key",
			Description = "Login.",
			Callback = t2.value14
		})

		return
	end
end
