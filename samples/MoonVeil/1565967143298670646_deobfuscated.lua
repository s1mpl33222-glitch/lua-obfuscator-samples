-- This file was generated at discord.gg/syncrypt

if not game:IsLoaded() then
	repeat
		task.wait()
	until game:IsLoaded()

	task.wait(math.random(3, 5) + math.random())
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/SyndromeXph/Patriot-Key-System-Ui-Library/refs/heads/main/PatriotUi.luau"))()
local HttpService = game:GetService("HttpService")
local Callbacks = lib.Callbacks
local v4 = HttpService

function Callbacks.OnVerify(p1)
	local function v5(...)
		return {
			...,
			n = select("#", ...),
		}
	end

	local v6 = gethwid() or "UNKNOWN_HWID"
	local UserId = game.Players.LocalPlayer.UserId
	local v8 = tostring(UserId)
	local t1 = {
		"https://api.pandauth.com/api/v1/keys/validate",
		"https://api.pandauth.com/api/v1/keys/validate-account",
		"https://api.pandauth.com/api/v1/validate",
		"https://api.pandauth.com/api/v1/auth/validate",
	}
	local json = v4:JSONEncode({
		ServiceID = "jacobhelper",
		Key = p1,
		HWID = v6,
		AccountID = v8,
	})
	local json2 = v4:JSONEncode({
		serviceId = "jacobhelper",
		key = p1,
		hwid = v6,
		accountId = v8,
	})
	local json3 = v4:JSONEncode({
		ServiceID = "jacobhelper",
		Key = p1,
		HWID = v6,
	})
	local v14 = v5(v4:JSONEncode({
		serviceId = "jacobhelper",
		key = p1,
		hwid = v6,
	}))
	local t2 = {
		json,
		json2,
		json3,
	}

	(function(p2, p3, p4, p5)
		for i = p5, p4.n do
			local v16 = p4[i]

			p2[i - p5 + p3] = v16
		end
	end)(t2, 4, v14, 1)

	local t3 = {
		["Content-Type"] = "application/json",
	}
	local v18, v19, v20 = ipairs(t1)
	local t4 = {
		{
			["Content-Type"] = "application/json",
			["X-API-Key"] = "nigga1234",
		},
		t3,
	}

	while true do
		local v22

		v20, v22 = v18(v19, v20)

		if v20 == nil then
			break
		end

		for _, v in ipairs(t4) do
			for _, v2 in ipairs(t2) do
				local pcall_ = pcall
				local v28 = v22
				local v29 = v
				local v30 = v2
				local ok, result = pcall(function()
					local t5 = {
						Url = v28,
						Method = "POST",
						Headers = v29,
						Body = v30,
					}

					return request(t5)
				end)

				if
					ok
					and (
						result
						and (
							result.Body
							and not (
								string.find(result.Body, "Cannot POST")
								or (string.find(result.Body, "<!DOCTYPE html>") or string.find(result.Body, "404 Not Found"))
							)
						)
					)
				then
					local ok2, result2 = pcall(v4.JSONDecode, v4, result.Body)

					if ok2 and result2 then
						if result2.Authenticated_Status == "Success" or (result2.success == true or (result2.valid == true or result2.status == "valid")) then
							return {
								valid = true,
							}
						else
							local Note = result2.Note or (result2.message or result2.error or "Invalid Key or HWID Locked.")

							return {
								valid = false,
								message = tostring(Note),
							}
						end
					end
				end
			end
		end
	end

	for _, v in ipairs(t1) do
		local t6 = {}
		local v40 = string.format("%s?ServiceID=%s&Key=%s&HWID=%s&AccountID=%s", v, "jacobhelper", p1, v6, v8)
		local v41 = v5(string.format("%s?serviceId=%s&key=%s&hwid=%s", v, "jacobhelper", p1, v6))

		__set_list(t6, 1, { v40, unpack(v41, 1, v41.n) })

		for _, v2 in ipairs(t6) do
			local pcall_ = pcall
			local v45 = v2
			local v46 = t3
			local ok, result = pcall(function()
				local t7 = {
					Url = v45,
					Method = "GET",
					Headers = v46,
				}

				return request(t7)
			end)

			if ok and (result and (result.Body and not (string.find(result.Body, "Cannot GET") or string.find(result.Body, "<!DOCTYPE html>")))) then
				local ok2, result2 = pcall(v4.JSONDecode, v4, result.Body)

				if ok2 and result2 then
					return (result2.Authenticated_Status == "Success" or (result2.success == true or result2.valid == true)) and {
						valid = true,
					} or {
						valid = false,
						message = result2.Note or (result2.message or "Invalid Key"),
					}
				end
			end
		end
	end

	return {
		valid = false,
		message = "Validation server unreachable.",
	}
end

lib.Appearance = {
	Title = "Jacob's Helper",
	Subtitle = "Verify your key to access BABFT Automation",
	Icon = "rbxassetid://95721401302279",
	IconSize = UDim2.new(0, 30, 0, 30),
}
lib.Links = {
	GetKey = "https://ads.pandauth.com/security_getkey/jacobhelper",
	Discord = "https://discord.gg/9mgCFuNK8n",
}
lib.Storage = {
	FileName = "JacobsHelper_Key",
	Remember = true,
	AutoLoad = true,
}
lib.Options = {
	Keyless = false,
	Blur = true,
	Draggable = true,
}
lib.Theme = {
	Accent = Color3.fromRGB(0, 170, 255),
	AccentHover = Color3.fromRGB(0, 140, 210),
	Background = Color3.fromRGB(15, 17, 21),
	Header = Color3.fromRGB(20, 22, 27),
	Input = Color3.fromRGB(30, 34, 42),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(150, 155, 160),
	Success = Color3.fromRGB(50, 255, 50),
	Error = Color3.fromRGB(255, 50, 50),
	Warning = Color3.fromRGB(255, 200, 0),
	StatusIdle = Color3.fromRGB(100, 100, 100),
	Discord = Color3.fromRGB(88, 101, 242),
	DiscordHover = Color3.fromRGB(114, 137, 218),
	Divider = Color3.fromRGB(40, 40, 40),
	Pending = Color3.fromRGB(50, 50, 50),
}

local changelog = {
	{
		Version = "v2.0",
		Date = "BABFT Release",
		Changes = { "Custom UI", "Key System", "Full Feature Set" },
	},
}

lib.Changelog = changelog
lib.Shop = {
	Enabled = false,
}

function lib.Callbacks.OnSuccess()
	task.spawn(function()
		local ok, result = pcall(function()
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local UserInputService = game:GetService("UserInputService")
			local TweenService = game:GetService("TweenService")
			local CoreGui = game:GetService("CoreGui")
			local Lighting = game:GetService("Lighting")
			local LocalPlayer = Players.LocalPlayer
			local CurrentCamera = workspace.CurrentCamera
			local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local Humanoid = Character:WaitForChild("Humanoid")
			local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

			LocalPlayer.CharacterAdded:Connect(function(character)
				Character = character
				Humanoid = character:WaitForChild("Humanoid")
				HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
			end)

			local t9 = {
				IsLocalPlayerSitting = function(_, p6)
					local v70 = p6 or Humanoid

					return v70 and (v70.SeatPart and v70.Sit) or false
				end,
			}

			_G.SpeedModify = false
			_G.SpeedModifyValue = 16

			local spawn = task.spawn
			local v72 = t9

			spawn(function()
				while true do
					repeat
						local v73 = task.wait()
					until _G.SpeedModify and Humanoid.MoveDirection.Magnitude > 0 and not v72:IsLocalPlayerSitting()

					HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Humanoid.MoveDirection * ((_G.SpeedModifyValue - Humanoid.WalkSpeed) * v86)
				end
			end)
			_G.LocalNoclip = false

			local Stepped = RunService.Stepped
			local t10 = { "LowerTorso", "UpperTorso", "HumanoidRootPart" }

			Stepped:Connect(function()
				pcall(function()
					local v77 = Character

					for _, child in ipairs(v77:GetChildren()) do
						if child:IsA("BasePart") and table.find(t10, child.Name) then
							child.CanCollide = not _G.LocalNoclip
						end
					end
				end)
			end)

			local t11 = {
				Enabled = false,
				Speed = 2,
				Platform = nil,
				UseKey = false,
			}
			local v81 = t11

			local function v82(p7)
				v81.Enabled = p7

				if p7 then
					v81.Platform = Instance.new("Part")
					v81.Platform.Anchored = true
					v81.Platform.CanCollide = true
					v81.Platform.Transparency = 1
					v81.Platform.Size = Vector3.new(4, 1, 2)
					v81.Platform.Parent = workspace

					return
				end

				if not v81.Platform then
					return
				end

				v81.Platform:Destroy()
				v81.Platform = nil
			end

			local Heartbeat = RunService.Heartbeat
			local v84 = t11
			local v85 = UserInputService

			Heartbeat:Connect(function()
				if not (v84.Enabled and (HumanoidRootPart and Humanoid)) then
					return
				end

				local CurrentCamera2 = workspace.CurrentCamera
				local vector3 = Vector3.zero

				if v85:IsKeyDown(Enum.KeyCode.W) then
					vector3 = vector3 + CurrentCamera2.CFrame.LookVector
				end

				if v85:IsKeyDown(Enum.KeyCode.S) then
					vector3 = vector3 - CurrentCamera2.CFrame.LookVector
				end

				if v85:IsKeyDown(Enum.KeyCode.A) then
					vector3 = vector3 - CurrentCamera2.CFrame.RightVector
				end

				if v85:IsKeyDown(Enum.KeyCode.D) then
					vector3 = vector3 + CurrentCamera2.CFrame.RightVector
				end

				if vector3.Magnitude > 0 then
					vector3 = vector3.Unit * v84.Speed
				end

				HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + vector3
				HumanoidRootPart.CFrame = CFrame.lookAt(
					HumanoidRootPart.Position,
					HumanoidRootPart.Position + Vector3.new(CurrentCamera2.CFrame.LookVector.X, 0, CurrentCamera2.CFrame.LookVector.Z)
				)

				if v84.Platform then
					v84.Platform.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -3.5, 0)
				end

				if Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
					return
				end

				Humanoid:Move(Vector3.zero)
			end)
			_G.ChangeWorldTime = false
			_G.ClockTime = 12
			_G.ESPEnabled = false
			_G.ESPViewHealth = false
			_G.ESPViewDistance = true
			_G.HideDead = true

			local v89, v90, v91 = ipairs(Players:GetPlayers())
			local v92 = Humanoid
			local t12 = {}
			local connection = nil
			local u95
			local connection2 = nil

			while true do
				local v97

				v91, v97 = v89(v90, v91)

				if v91 == nil then
					break
				end

				if v97 ~= LocalPlayer then
					if v97.Character then
						local Character2 = v97.Character

						if
							Character2
							and (
								Character2:IsA("Model")
								and (Character2:FindFirstChild("HumanoidRootPart") and Character2.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent)
							)
						then
							Character2.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
						end
					end

					v97.CharacterAdded:Connect(function(character)
						task.wait(0.2)

						if
							not (
								character
								and (
									character:IsA("Model")
									and (character:FindFirstChild("HumanoidRootPart") and character.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent)
								)
							)
						then
							return
						end

						character.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
					end)
				end
			end

			local PlayerAdded = Players.PlayerAdded
			local v100 = LocalPlayer

			PlayerAdded:Connect(function(p8)
				if p8 == v100 then
					return
				end

				if p8.Character then
					local Character2 = p8.Character

					if
						Character2
						and (
							Character2:IsA("Model")
							and (Character2:FindFirstChild("HumanoidRootPart") and Character2.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent)
						)
					then
						Character2.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
					end
				end

				p8.CharacterAdded:Connect(function(character)
					task.wait(0.2)

					if
						not (
							character
							and (
								character:IsA("Model")
								and (character:FindFirstChild("HumanoidRootPart") and character.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent)
							)
						)
					then
						return
					end

					character.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
				end)
			end)

			local v102 = t12

			local function v103(p9)
				local t13 = {
					box = Drawing.new("Square"),
				}

				t13.box.Thickness = 1
				t13.box.Filled = false
				t13.box.Visible = false
				t13.box.ZIndex = 2
				t13.outline = Drawing.new("Square")
				t13.outline.Thickness = 3
				t13.outline.Filled = false
				t13.outline.Color = Color3.new(0, 0, 0)
				t13.outline.Visible = false
				t13.outline.ZIndex = 1
				t13.name = Drawing.new("Text")
				t13.name.Center = true
				t13.name.Outline = true
				t13.name.Size = 16
				t13.name.Visible = false
				t13.name.ZIndex = 3
				v102[p9] = t13
			end

			local v105 = t12

			local function v106(player)
				local v107 = v105[player]

				if v107 then
					for _, v in pairs(v107) do
						v:Remove()
					end

					v105[player] = nil
				end
			end

			local v110 = CurrentCamera

			local function v111(p10, p11)
				if not _G.ESPEnabled then
					p11.box.Visible = false
					p11.outline.Visible = false
					p11.name.Visible = false

					return
				end

				local Character2 = p10.Character
				local HumanoidRootPart2

				if Character2 then
					HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
				else
					HumanoidRootPart2 = Character2
				end

				local Humanoid2

				if Character2 then
					Humanoid2 = Character2:FindFirstChildWhichIsA("Humanoid")
				else
					Humanoid2 = Character2
				end

				if Character2 then
					Character2 = Character2:FindFirstChild("Head")
				end

				if not (HumanoidRootPart2 and (Humanoid2 and Character2)) then
					p11.box.Visible = false
					p11.outline.Visible = false
					p11.name.Visible = false

					return
				end

				if _G.HideDead and Humanoid2.Health <= 0 then
					p11.box.Visible = false
					p11.outline.Visible = false
					p11.name.Visible = false

					return
				end

				local v115, v116 = v110:WorldToViewportPoint(Character2.Position + Vector3.new(0, 0.5, 0))
				local v117, v118 = v110:WorldToViewportPoint(HumanoidRootPart2.Position - Vector3.new(0, 3, 0))

				if not (v116 and (v118 and v115.Z > 0)) then
					p11.box.Visible = false
					p11.outline.Visible = false
					p11.name.Visible = false

					return
				end

				local v119 = v115.Y - v117.Y
				local v120 = math.abs(v119) * 1.1
				local v121 = v120 * 0.7
				local v122 = v115.X - v121 / 2
				local Y = v115.Y

				p11.box.Size = Vector2.new(v121, v120)
				p11.box.Position = Vector2.new(v122, Y)
				p11.outline.Size = p11.box.Size
				p11.outline.Position = p11.box.Position

				local s1 = ""

				if _G.ESPViewHealth then
					local Health = Humanoid2.Health

					s1 = "" .. " | HP: " .. math.floor(Health)
				end

				if not _G.ESPViewDistance then
					v151 = p10.Team and p10.Team.TeamColor.Color or Color3.new(1, 1, 1)
					p11.box.Color = v151
					p11.name.Color = v151
					p11.name.Text = p10.Name .. s1
					p11.name.Position = Vector2.new(v115.X, Y - 18)
					p11.box.Visible = true
					p11.outline.Visible = true
					p11.name.Visible = true

					return
				end

				local Magnitude = (HumanoidRootPart2.Position - v110.CFrame.Position).Magnitude
				local _ = s1 .. " | " .. math.floor(Magnitude) .. "m"
				local Color = p10.Team and p10.Team.TeamColor.Color or Color3.new(1, 1, 1)

				p11.box.Color = Color
				p11.name.Color = Color
				p11.name.Text = p10.Name .. s1
				p11.name.Position = Vector2.new(v115.X, Y - 18)
				p11.box.Visible = true
				p11.outline.Visible = true
				p11.name.Visible = true
			end

			local RenderStepped = RunService.RenderStepped
			local v130 = t12
			local v131 = LocalPlayer
			local v132 = v111

			RenderStepped:Connect(function()
				for k, v in pairs(v130) do
					if k ~= v131 then
						v132(k, v)
					end
				end
			end)

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					v103(player)
				end
			end

			local PlayerAdded2 = Players.PlayerAdded
			local v138 = LocalPlayer
			local v139 = v103

			PlayerAdded2:Connect(function(p12)
				if p12 == v138 then
					return
				end

				v139(p12)
			end)
			Players.PlayerRemoving:Connect(v106)
			getgenv().wasActive = false
			getgenv().activeTweens = {}
			getgenv().isFarming = false

			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "JacobsHelper_BABFT"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			local v142 = ScreenGui
			local v143 = CoreGui

			if
				not pcall(function()
					if gethui then
						v142.Parent = gethui()
					elseif syn and syn.protect_gui then
						syn.protect_gui(v142)
						v142.Parent = v143

						return
					else
						v142.Parent = v143

						return
					end
				end)
			then
				ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
			end

			local t14 = {
				BG = Color3.fromRGB(15, 17, 21),
				Panel = Color3.fromRGB(20, 22, 27),
				PanelAlt = Color3.fromRGB(30, 34, 42),
				Border = Color3.fromRGB(45, 50, 60),
				Accent = Color3.fromRGB(0, 170, 255),
				Text = Color3.fromRGB(220, 225, 230),
				TextDim = Color3.fromRGB(150, 155, 160),
				ToggleOff = Color3.fromRGB(45, 50, 60),
				Section = Color3.fromRGB(0, 170, 255),
			}
			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.new(0, 560, 0, 430)
			Frame.Position = UDim2.new(0.5, -280, 0.5, -215)
			Frame.BackgroundColor3 = t14.BG
			Frame.BorderSizePixel = 0
			Frame.Parent = ScreenGui
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

			local UIStroke = Instance.new("UIStroke", Frame)

			UIStroke.Color = t14.Border
			UIStroke.Thickness = 1

			local Frame2 = Instance.new("Frame")

			Frame2.Size = UDim2.new(1, 0, 0, 42)
			Frame2.BackgroundColor3 = t14.Panel
			Frame2.BorderSizePixel = 0
			Frame2.Parent = Frame
			Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 10)

			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(1, 0, 0, 20)
			Frame3.Position = UDim2.new(0, 0, 0, 22)
			Frame3.BackgroundColor3 = t14.Panel
			Frame3.BorderSizePixel = 0
			Frame3.Parent = Frame2

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -100, 1, 0)
			TextLabel.Position = UDim2.new(0, 15, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "jacob's helper"
			TextLabel.TextColor3 = t14.Accent
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 14
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Frame2

			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.new(0, 50, 1, 0)
			TextLabel2.Position = UDim2.new(1, -95, 0, 0)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = "v2.0"
			TextLabel2.TextColor3 = t14.TextDim
			TextLabel2.Font = Enum.Font.Gotham
			TextLabel2.TextSize = 11
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel2.Parent = Frame2

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(0, 28, 0, 28)
			TextButton.Position = UDim2.new(1, -36, 0.5, -14)
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
			TextButton.Text = ""
			TextButton.Parent = Frame2
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.new(1, 0, 0, 35)
			Frame4.Position = UDim2.new(0, 0, 0, 42)
			Frame4.BackgroundTransparency = 1
			Frame4.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout", Frame4)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0, 5)

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.new(1, -20, 1, -92)
			Frame5.Position = UDim2.new(0, 10, 0, 82)
			Frame5.BackgroundTransparency = 1
			Frame5.Parent = Frame

			local v155 = t14
			local v156 = Frame4
			local v157 = TweenService

			local function createScrollingFrame(p13)
				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0, 95, 0, 28)
				TextButton2.BackgroundColor3 = v155.PanelAlt
				TextButton2.Text = p13
				TextButton2.TextColor3 = v155.TextDim
				TextButton2.Font = Enum.Font.GothamMedium
				TextButton2.TextSize = 12
				TextButton2.AutoButtonColor = false
				TextButton2.Parent = v156
				Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

				local ScrollingFrame = Instance.new("ScrollingFrame")

				ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
				ScrollingFrame.BackgroundTransparency = 1
				ScrollingFrame.BorderSizePixel = 0
				ScrollingFrame.ScrollBarThickness = 3
				ScrollingFrame.ScrollBarImageColor3 = v155.Accent
				ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
				ScrollingFrame.Visible = false
				ScrollingFrame.Parent = Frame5

				local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

				UIListLayout2.Padding = UDim.new(0, 6)
				UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center

				local UIPadding = Instance.new("UIPadding", ScrollingFrame)

				UIPadding.PaddingTop = UDim.new(0, 5)
				UIPadding.PaddingBottom = UDim.new(0, 10)

				local MouseButton1Click = TextButton2.MouseButton1Click
				local v164 = TextButton2
				local v165 = ScrollingFrame

				MouseButton1Click:Connect(function()
					local v166 = Frame5

					for _, child in ipairs(v166:GetChildren()) do
						if child:IsA("ScrollingFrame") then
							child.Visible = false
						end
					end

					local v169 = v156

					for _, child in ipairs(v169:GetChildren()) do
						if child:IsA("TextButton") then
							v157:Create(child, TweenInfo.new(0.2), {
								BackgroundColor3 = v155.PanelAlt,
								TextColor3 = v155.TextDim,
							}):Play()
						end
					end

					v157:Create(v164, TweenInfo.new(0.2), {
						BackgroundColor3 = v155.Accent,
						TextColor3 = Color3.fromRGB(255, 255, 255),
					}):Play()
					v165.Visible = true
				end)

				return ScrollingFrame
			end

			local v172 = t14

			local function createTextLabel(p14, p15)
				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.Size = UDim2.new(1, -10, 0, 22)
				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Text = "  " .. p15
				TextLabel3.TextColor3 = v172.Section
				TextLabel3.Font = Enum.Font.GothamBold
				TextLabel3.TextSize = 12
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.Parent = p14

				return TextLabel3
			end

			local v175 = t14
			local v176 = TweenService

			local function v177(p16, p17, p18, p19)
				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(1, -10, 0, 38)
				Frame6.BackgroundColor3 = v175.PanelAlt
				Frame6.Parent = p16
				Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 6)

				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.Size = UDim2.new(1, -70, 1, 0)
				TextLabel3.Position = UDim2.new(0, 15, 0, 0)
				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Text = p17
				TextLabel3.TextColor3 = v175.Text
				TextLabel3.Font = Enum.Font.GothamMedium
				TextLabel3.TextSize = 13
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.Parent = Frame6

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0, 40, 0, 20)
				TextButton2.Position = UDim2.new(1, -55, 0.5, -10)
				TextButton2.BackgroundColor3 = p18 and v175.Accent or v175.ToggleOff
				TextButton2.Text = ""
				TextButton2.Parent = Frame6
				Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

				local Frame7 = Instance.new("Frame")

				Frame7.Size = UDim2.new(0, 14, 0, 14)
				Frame7.Position = p18 and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
				Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame7.Parent = TextButton2
				Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

				local value = p18
				local MouseButton1Click = TextButton2.MouseButton1Click
				local v184 = TextButton2
				local v185 = Frame7
				local v186 = p19

				MouseButton1Click:Connect(function()
					value = not value
					v176:Create(v184, TweenInfo.new(0.2), {
						BackgroundColor3 = value and v175.Accent or v175.ToggleOff,
					}):Play()
					v176:Create(v185, TweenInfo.new(0.2), {
						Position = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
					}):Play()
					v186(value)
				end)

				local t15 = {
					Value = p18,
				}
				local v188 = TextButton2
				local v189 = Frame7
				local v190 = p19

				function t15.SetValue(p20, p21)
					if p21 ~= value then
						value = p21
						p20.Value = p21
						v176:Create(v188, TweenInfo.new(0.2), {
							BackgroundColor3 = p21 and v175.Accent or v175.ToggleOff,
						}):Play()
						v176:Create(v189, TweenInfo.new(0.2), {
							Position = p21 and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
						}):Play()
						v190(p21)
					end
				end

				return t15
			end

			local v191 = t14
			local v192 = UserInputService

			local function createFrame(p22, p23, p24, p25, p26, p27, p28)
				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(1, -10, 0, 50)
				Frame6.BackgroundColor3 = v191.PanelAlt
				Frame6.Parent = p22
				Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 6)

				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.Size = UDim2.new(1, -100, 0, 20)
				TextLabel3.Position = UDim2.new(0, 15, 0, 5)
				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Text = p23
				TextLabel3.TextColor3 = v191.Text
				TextLabel3.Font = Enum.Font.GothamMedium
				TextLabel3.TextSize = 13
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.Parent = Frame6

				local TextLabel4 = Instance.new("TextLabel")

				TextLabel4.Size = UDim2.new(0, 80, 0, 20)
				TextLabel4.Position = UDim2.new(1, -95, 0, 5)
				TextLabel4.BackgroundTransparency = 1
				TextLabel4.Text = tostring(p26)
				TextLabel4.TextColor3 = v191.Accent
				TextLabel4.Font = Enum.Font.GothamBold
				TextLabel4.TextSize = 13
				TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
				TextLabel4.Parent = Frame6

				local Frame7 = Instance.new("Frame")

				Frame7.Size = UDim2.new(1, -30, 0, 4)
				Frame7.Position = UDim2.new(0, 15, 0, 35)
				Frame7.BackgroundColor3 = v191.ToggleOff
				Frame7.Parent = Frame6
				Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

				local Frame8 = Instance.new("Frame")

				Frame8.Size = UDim2.new((p26 - p24) / (p25 - p24), 0, 1, 0)
				Frame8.BackgroundColor3 = v191.Accent
				Frame8.Parent = Frame7
				Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)

				local Frame9 = Instance.new("Frame")

				Frame9.Size = UDim2.new(0, 14, 0, 14)
				Frame9.Position = UDim2.new((p26 - p24) / (p25 - p24), -7, 0.5, -7)
				Frame9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame9.Parent = Frame7
				Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

				local u200 = false
				local v201 = Frame7
				local v202 = p24
				local v203 = p25

				local function v204(p29)
					local v205 = (p29.Position.X - v201.AbsolutePosition.X) / v201.AbsoluteSize.X
					local v206 = math.clamp(v205, 0, 1)
					local v207 = (v202 + (v203 - v202) * v206) / p27 + 0.5
					local v208 = math.floor(v207) * p27
					local v211 = math.clamp(v208, v202, v203)
					local v212 = (v211 - v202) / (v203 - v202)

					Frame8.Size = UDim2.new(v212, 0, 1, 0)
					Frame9.Position = UDim2.new(v212, -7, 0.5, -7)
					TextLabel4.Text = string.format("%g", v211)
					p28(v211)
				end

				local InputBegan = Frame7.InputBegan
				local v214 = v204

				InputBegan:Connect(function(p30)
					if not (p30.UserInputType == Enum.UserInputType.MouseButton1 or p30.UserInputType == Enum.UserInputType.Touch) then
						return
					end

					u200 = true
					v214(p30)
				end)

				local InputChanged = v192.InputChanged
				local v216 = v204

				InputChanged:Connect(function(p31)
					if not (u200 and (p31.UserInputType == Enum.UserInputType.MouseMovement or p31.UserInputType == Enum.UserInputType.Touch)) then
						return
					end

					v216(p31)
				end)
				v192.InputEnded:Connect(function(input)
					if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						return
					end

					u200 = false
				end)

				return Frame6
			end
			local v219 = t14
			local v220 = TweenService

			local function createFrame2(p32, p33, p34, p35, p36, p37)
				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(1, -10, 0, 35)
				Frame6.BackgroundColor3 = v219.PanelAlt
				Frame6.Parent = p32
				Frame6.ClipsDescendants = true
				Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 6)

				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(1, 0, 0, 35)
				TextButton2.BackgroundTransparency = 1
				TextButton2.Text = p33 .. " : Select"
				TextButton2.TextColor3 = v219.Text
				TextButton2.Font = Enum.Font.GothamMedium
				TextButton2.TextSize = 13
				TextButton2.TextXAlignment = Enum.TextXAlignment.Left
				TextButton2.Parent = Frame6
				Instance.new("UIPadding", TextButton2).PaddingLeft = UDim.new(0, 15)

				local Frame7 = Instance.new("Frame")

				Frame7.Size = UDim2.new(1, 0, 0, #p34 * 30)
				Frame7.Position = UDim2.new(0, 0, 0, 35)
				Frame7.BackgroundColor3 = v219.BG
				Frame7.BorderSizePixel = 0
				Frame7.Visible = false
				Frame7.Parent = Frame6
				Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 6)
				Instance.new("UIListLayout", Frame7).Padding = UDim.new(0, 2)

				local visible = false
				local MouseButton1Click = TextButton2.MouseButton1Click
				local v227 = Frame7
				local v228 = Frame6
				local v229 = p34

				MouseButton1Click:Connect(function()
					visible = not visible
					v227.Visible = visible

					if visible then
						v220:Create(v228, TweenInfo.new(0.2), {
							Size = UDim2.new(1, -10, 0, 35 + #v229 * 32),
						}):Play()
					else
						v220:Create(v228, TweenInfo.new(0.2), {
							Size = UDim2.new(1, -10, 0, 35),
						}):Play()
					end
				end)

				if p35 then
					local t16 = {}

					if p36 then
						for _, v in ipairs(p36) do
							t16[v] = true
						end
					end

					for _, v in ipairs(p34) do
						local TextButton3 = Instance.new("TextButton")

						TextButton3.Size = UDim2.new(1, 0, 0, 28)
						TextButton3.BackgroundTransparency = 1
						TextButton3.Text = (t16[v] and "  ☑ " or "  ☐ ") .. v
						TextButton3.TextColor3 = t16[v] and v219.Accent or v219.TextDim
						TextButton3.Font = Enum.Font.Gotham
						TextButton3.TextSize = 12
						TextButton3.TextXAlignment = Enum.TextXAlignment.Left
						TextButton3.Parent = Frame7

						local MouseButton1Click2 = TextButton3.MouseButton1Click
						local v237 = t16
						local v238 = v
						local v239 = TextButton3
						local v240 = p37

						MouseButton1Click2:Connect(function()
							v237[v238] = not v237[v238]
							v239.Text = (v237[v238] and "  ☑ " or "  ☐ ") .. v238
							v239.TextColor3 = v237[v238] and v219.Accent or v219.TextDim
							v240(v237)
						end)
					end

					if not (p36 and #p36 > 0) then
						return Frame6
					end

					p37(t16)
				else
					local v241, v242, v243 = ipairs(p34)
					local u244

					while true do
						local v245

						v243, v245 = v241(v242, v243)

						if v243 == nil then
							break
						end

						local TextButton3 = Instance.new("TextButton")

						TextButton3.Size = UDim2.new(1, 0, 0, 28)
						TextButton3.BackgroundTransparency = 1
						TextButton3.Text = v245
						TextButton3.TextColor3 = v219.TextDim
						TextButton3.Font = Enum.Font.Gotham
						TextButton3.TextSize = 12
						TextButton3.TextXAlignment = Enum.TextXAlignment.Left
						TextButton3.Parent = Frame7
						Instance.new("UIPadding", TextButton3).PaddingLeft = UDim.new(0, 15)

						local MouseButton1Click2 = TextButton3.MouseButton1Click
						local v248 = TextButton2
						local v249 = p33
						local v250 = v245
						local v251 = p37
						local v252 = Frame6
						local v253 = Frame7

						MouseButton1Click2:Connect(function()
							v248.Text = v249 .. " : " .. v250
							v251(v250)
							u244 = false
							v220:Create(v252, TweenInfo.new(0.2), {
								Size = UDim2.new(1, -10, 0, 35),
							}):Play()
							task.delay(0.2, function()
								v253.Visible = false
							end)
						end)
					end
				end

				return Frame6
			end
			local v255 = t14
			local v256 = UserInputService

			local function createFrame3(p38, p39, p40, p41)
				local Frame6 = Instance.new("Frame")

				Frame6.Size = UDim2.new(1, -10, 0, 38)
				Frame6.BackgroundColor3 = v255.PanelAlt
				Frame6.Parent = p38
				Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 6)

				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.Size = UDim2.new(1, -100, 1, 0)
				TextLabel3.Position = UDim2.new(0, 15, 0, 0)
				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Text = p39
				TextLabel3.TextColor3 = v255.Text
				TextLabel3.Font = Enum.Font.GothamMedium
				TextLabel3.TextSize = 13
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.Parent = Frame6

				local G = Enum.KeyCode[p40] or Enum.KeyCode.G
				local u261 = false
				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0, 70, 0, 24)
				TextButton2.Position = UDim2.new(1, -85, 0.5, -12)
				TextButton2.BackgroundColor3 = v255.BG
				TextButton2.Text = p40
				TextButton2.TextColor3 = v255.Accent
				TextButton2.Font = Enum.Font.GothamMedium
				TextButton2.TextSize = 11
				TextButton2.Parent = Frame6
				Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)

				local MouseButton1Click = TextButton2.MouseButton1Click
				local v264 = TextButton2

				MouseButton1Click:Connect(function()
					u261 = true
					v264.Text = "..."
					v264.TextColor3 = v255.TextDim
				end)

				local InputBegan = v256.InputBegan
				local v266 = TextButton2
				local v267 = p41

				InputBegan:Connect(function(p42, p43)
					if u261 and p42.UserInputType == Enum.UserInputType.Keyboard then
						G = p42.KeyCode
						v266.Text = p42.KeyCode.Name
						v266.TextColor3 = v255.Accent
						u261 = false

						return
					end

					if p43 or (u261 or p42.KeyCode ~= G) then
						return
					end

					v267()
				end)

				return Frame6
			end

			local Player = createScrollingFrame("Player")
			local Visuals = createScrollingFrame("Visuals")
			local Anti = createScrollingFrame("Anti")
			local Autofarm = createScrollingFrame("Autofarm")
			local Info = createScrollingFrame("Info")

			createTextLabel(Player, "Walkspeed")
			v177(Player, "Walk Speed", false, function(p44)
				_G.SpeedModify = p44
			end)
			createFrame(Player, "Walkspeed Value", 16, 500, 16, 1, function(p45)
				_G.SpeedModifyValue = p45
			end)
			createTextLabel(Player, "Player Fly")

			local playerFly = v177(Player, "Player Fly", false, v82)
			local v274 = t11

			v177(Player, "Use Fly Keybind", false, function(p46)
				v274.UseKey = p46
			end)

			local v275 = t11

			createFrame(Player, "Fly Speed", 1, 100, 2, 1, function(p47)
				v275.Speed = p47
			end)

			local v276 = t11
			local v277 = playerFly

			createFrame3(Player, "Fly Keybind", "G", function()
				if not v276.UseKey then
					return
				end

				v277:SetValue(not v277.Value)
			end)
			createTextLabel(Player, "Other")
			v177(Player, "Noclip", false, function(p48)
				_G.LocalNoclip = p48
			end)

			local v278 = UserInputService

			v177(Player, "Infinite Jump", false, function(p49)
				u95 = p49

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if not p49 then
					return
				end

				connection2 = v278.JumpRequest:Connect(function()
					v92:ChangeState(Enum.HumanoidStateType.Jumping)
				end)
			end)
			createTextLabel(Visuals, "Time")

			local v279 = Lighting

			createFrame(Visuals, "World Time", 0, 23, 12, 1, function(p50)
				_G.ClockTime = tonumber(p50)

				if not _G.ChangeWorldTime then
					return
				end

				v279.ClockTime = _G.ClockTime
			end)

			local v280 = Lighting

			v177(Visuals, "Time Changer", false, function(p51)
				_G.ChangeWorldTime = p51

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if not p51 then
					return
				end

				v280.ClockTime = _G.ClockTime
				connection = v280:GetPropertyChangedSignal("ClockTime"):Connect(function()
					if v280.ClockTime == _G.ClockTime then
						return
					end

					v280.ClockTime = _G.ClockTime
				end)
			end)
			createTextLabel(Visuals, "ESP")
			v177(Visuals, "Enable ESP", false, function(p52)
				_G.ESPEnabled = p52
			end)
			createFrame2(Visuals, "ESP Settings", { "View Health", "View Distance" }, true, { "View Distance" }, function(p53)
				_G.ESPViewHealth = p53["View Health"] == true
				_G.ESPViewDistance = p53["View Distance"] == true
			end)
			v177(Anti, "Anti Water Damage", false, function(p54)
				local Water = workspace:FindFirstChild("Water")

				if not Water then
					return
				end

				Water.CanTouch = not p54
			end)
			v177(Anti, "Anti Obstacles", false, function(p55)
				local BoatStages = workspace:FindFirstChild("BoatStages")

				if not BoatStages then
					return
				end

				local v283 = p55;

				(function(p56)
					for _, descendant in pairs(p56:GetDescendants()) do
						if descendant:IsA("ParticleEmitter") then
							local Parent = descendant.Parent

							if Parent and Parent:IsA("BasePart") then
								Parent.CanTouch = not v283
								Parent.CanCollide = not v283
							end
						end
					end
				end)(BoatStages)
			end)
			v177(Anti, "Anti Isolation", false, function(p57)
				getgenv().antiIsolationEnabled = p57
				getgenv().trackedParts = getgenv().trackedParts or {}
				getgenv().originalStates = getgenv().originalStates or {}

				local t17 = {
					"WhiteZone",
					"Really redZone",
					"Really blueZone",
					"New YellerZone",
					"MagentaZone",
					"CamoZone",
					"BlackZone",
				}
				local v288 = p57

				local function v289(p58)
					if not p58:IsA("BasePart") then
						return
					end

					if v288 then
						getgenv().originalStates[p58] = {
							CanCollide = p58.CanCollide,
							CanTouch = p58.CanTouch,
						}
						p58.CanCollide = false
						p58.CanTouch = false
						getgenv().trackedParts[p58] = true

						return
					end

					local v290 = getgenv().originalStates[p58]

					if not v290 then
						getgenv().originalStates[p58] = nil
						getgenv().trackedParts[p58] = nil

						return
					end

					p58.CanCollide = v290.CanCollide
					p58.CanTouch = v290.CanTouch
					getgenv().originalStates[p58] = nil
					getgenv().trackedParts[p58] = nil
				end

				if p57 then
					for _, v in pairs(t17) do
						local v293 = workspace:FindFirstChild(v)

						if v293 then
							local Lock = v293:FindFirstChild("Lock")

							if Lock then
								Lock = Lock:FindFirstChild("Part")
							end

							if Lock then
								v289(Lock)
							end
						end
					end
				else
					for k, trackedPart in pairs(getgenv().trackedParts) do
						v289(k)
					end
				end
			end)

			local v297 = LocalPlayer
			local v298 = TweenService

			v177(Autofarm, "Autofarm", false, function(p59)
				getgenv().auto = p59

				if p59 then
					getgenv().wasActive = true
					task.spawn(function()
						local speed = getgenv().speed

						if typeof(speed) ~= "number" then
							getgenv().speed = 25
						end

						if getgenv().isFarming then
							return
						end

						getgenv().isFarming = true

						while getgenv().auto do
							local Character2 = v297.Character

							if Character2 then
								local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")

								if HumanoidRootPart2 then
									game.Workspace.Gravity = 0
									Character2.Humanoid:ChangeState(11)

									local tween = v298:Create(HumanoidRootPart2, TweenInfo.new(0.05), {
										CFrame = CFrame.new(-57, 74, 785),
									})
									local tween2 = v298:Create(HumanoidRootPart2, TweenInfo.new(getgenv().speed - 4), {
										CFrame = CFrame.new(-57, 74, 8957),
									})
									local tween3 = v298:Create(HumanoidRootPart2, TweenInfo.new(2), {
										CFrame = CFrame.new(-57, -357, 9496),
									})

									getgenv().activeTweens = { tween, tween2, tween3 }
									local v306 = tween
									local v307 = tween2
									local v308 = tween3

									pcall(function()
										v306:Play()
										v306.Completed:Wait()

										if getgenv().auto then
											v307:Play()
											v307.Completed:Wait()

											if getgenv().auto then
												v308:Play()
												v308.Completed:Wait()
												game.Workspace.Gravity = 196.2

												return
											else
												return
											end
										end
									end)
									v297.CharacterAdded:Wait()
									task.wait(5)
								end
							else
								v297.CharacterAdded:Wait()
							end
						end

						getgenv().isFarming = false
					end)

					return
				end

				if not getgenv().wasActive then
					getgenv().wasActive = false
					getgenv().isFarming = false

					return
				end

				for _, activeTween in pairs(getgenv().activeTweens) do
					if activeTween then
						activeTween:Cancel()
					end
				end

				game.Workspace.Gravity = 196.2

				local Character2 = v297.Character

				if not (Character2 and Character2:FindFirstChild("Humanoid")) then
					getgenv().wasActive = false
					getgenv().isFarming = false

					return
				end

				Character2.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				Character2.Humanoid.Health = 0
				getgenv().wasActive = false
				getgenv().isFarming = false
			end)

			local VirtualInputManager = game:GetService("VirtualInputManager")

			v177(Autofarm, "Anti-AFK", false, function(p60)
				getgenv().antiAfk = p60

				if not p60 then
					return
				end

				task.spawn(function()
					while getgenv().antiAfk do
						VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
						VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
						task.wait(300)
					end
				end)
			end)
			createTextLabel(Info, "About")

			local v313 = t14

			local function createTextLabel2(p61, p62)
				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.Size = UDim2.new(1, -10, 0, 25)
				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Text = "  " .. p62
				TextLabel3.TextColor3 = v313.TextDim
				TextLabel3.Font = Enum.Font.Gotham
				TextLabel3.TextSize = 12
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.Parent = p61

				return TextLabel3
			end

			createTextLabel2(Info, "Jacob's Helper — Build A Boat For Treasure")
			createTextLabel2(Info, "Version: 2.0")
			createTextLabel2(Info, "Toggle Menu: RightShift")
			createTextLabel(Info, "Controls")
			createTextLabel2(Info, "Press RightShift to toggle this menu")
			createTextLabel2(Info, "Configure fly keybind in Player tab")

			for _, child in ipairs(Frame4:GetChildren()) do
				if child:IsA("TextButton") then
					TweenService:Create(child, TweenInfo.new(0.2), {
						BackgroundColor3 = t14.Accent,
						TextColor3 = Color3.fromRGB(255, 255, 255),
					}):Play()

					break
				end
			end

			Player.Visible = true

			local v318 = Frame

			local function toggleVisible()
				v318.Visible = not v318.Visible
			end

			TextButton.MouseButton1Click:Connect(toggleVisible)

			local InputBegan = UserInputService.InputBegan
			local v321 = Frame

			InputBegan:Connect(function(p63, _)
				if p63.KeyCode ~= Enum.KeyCode.RightShift then
					return
				end

				v321.Visible = not v321.Visible
			end)

			local u322 = nil
			local Position = nil
			local Position2 = nil
			local InputBegan2 = Frame2.InputBegan
			local v326 = Frame

			InputBegan2:Connect(function(p64)
				if not (p64.UserInputType == Enum.UserInputType.MouseButton1 or p64.UserInputType == Enum.UserInputType.Touch) then
					return
				end

				u322 = true
				Position = p64.Position
				Position2 = v326.Position
			end)

			local InputChanged = UserInputService.InputChanged
			local v328 = Frame

			InputChanged:Connect(function(p65)
				if not (u322 and (p65.UserInputType == Enum.UserInputType.MouseMovement or p65.UserInputType == Enum.UserInputType.Touch)) then
					return
				end

				local v329 = p65.Position - Position

				v328.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v329.X, Position2.Y.Scale, Position2.Y.Offset + v329.Y)
			end)
			UserInputService.InputEnded:Connect(function(input)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					return
				end

				u322 = false
			end)

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.new(0, 250, 0, 50)
			Frame6.Position = UDim2.new(1, 0, 0.85, 0)
			Frame6.BackgroundColor3 = t14.Panel
			Frame6.BorderSizePixel = 0
			Frame6.Parent = ScreenGui
			Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", Frame6).Color = t14.Border

			local Frame7 = Instance.new("Frame")

			Frame7.Size = UDim2.new(0, 3, 1, -10)
			Frame7.Position = UDim2.new(0, 5, 0, 5)
			Frame7.BackgroundColor3 = t14.Accent
			Frame7.BorderSizePixel = 0
			Frame7.Parent = Frame6
			Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 2)

			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Size = UDim2.new(1, -25, 0, 20)
			TextLabel3.Position = UDim2.new(0, 18, 0, 5)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Text = "Jacob's Helper"
			TextLabel3.TextColor3 = t14.Accent
			TextLabel3.Font = Enum.Font.GothamBold
			TextLabel3.TextSize = 12
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel3.Parent = Frame6

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(1, -25, 0, 18)
			TextLabel4.Position = UDim2.new(0, 18, 0, 25)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = "Script successfully loaded!"
			TextLabel4.TextColor3 = t14.TextDim
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 11
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.Parent = Frame6
			TweenService:Create(Frame6, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -265, 0.85, 0),
			}):Play()

			local delay = task.delay
			local v335 = TweenService

			delay(5, function()
				local tween = v335:Create(Frame6, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					Position = UDim2.new(1, 0, 0.85, 0),
				})

				tween:Play()
				tween.Completed:Connect(function()
					Frame6:Destroy()
				end)
			end)
		end)

		if ok then
			return
		end

		warn("[Jacob's Helper] UI Error: " .. tostring(result))
	end)
end
function lib.Callbacks.OnFail(p66)
	warn("[Jacob's Helper] Validation Failed: " .. tostring(p66))
end
function lib.Callbacks.OnClose()
	warn("[Jacob's Helper] User closed verification window.")
end

lib:Launch()
