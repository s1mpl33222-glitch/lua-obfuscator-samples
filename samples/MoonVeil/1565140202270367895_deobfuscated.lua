-- This file was generated at discord.gg/syncrypt

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
						print("[Jacob Helper] SUCCESSful hit on:", v22)
						print("[Jacob Helper] Response:", result.Body)

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
	Title = "Jacob Helper",
	Subtitle = "Verify your key to access Operation One Automation",
	Icon = "rbxassetid://95721401302279",
	IconSize = UDim2.new(0, 30, 0, 30),
}
lib.Links = {
	GetKey = "https://ads.pandauth.com/security_getkey/jacobhelper",
	Discord = "https://discord.gg/9mgCFuNK8n",
}
lib.Storage = {
	FileName = "JacobHelper_Key",
	Remember = true,
	AutoLoad = true,
}
lib.Options = {
	Keyless = false,
	Blur = true,
	Draggable = true,
}
lib.Theme = {
	Accent = Color3.fromRGB(88, 101, 242),
	AccentHover = Color3.fromRGB(114, 137, 218),
	Background = Color3.fromRGB(15, 15, 15),
	Header = Color3.fromRGB(20, 20, 20),
	Input = Color3.fromRGB(30, 30, 30),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(150, 150, 150),
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
		Version = "v3.2.0",
		Date = "June 23, 2026",
		Changes = { "Fixed ESP Corpse Filtering", "Fixed Sidebar", "Added Key System" },
	},
	{
		Version = "v3.1.0",
		Date = "Previous",
		Changes = { "Added Viewmodel Tracking", "Added Triggerbot" },
	},
}

lib.Changelog = changelog
lib.Shop = {
	Enabled = false,
}

function lib.Callbacks.OnSuccess()
	task.spawn(function()
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local Workspace = game:GetService("Workspace")
		local TweenService = game:GetService("TweenService")
		local Lighting = game:GetService("Lighting")
		local HttpService2 = game:GetService("HttpService")
		local LocalPlayer = Players.LocalPlayer
		local CurrentCamera = Workspace.CurrentCamera
		local Viewmodels = Workspace:WaitForChild("Viewmodels")
		local t10 = {
			Aimbot_Enabled = false,
			Aimbot_FOV = 120,
			Aimbot_Smoothness = 25,
			Aimbot_Part = "head",
			Aimbot_WallCheck = false,
			Aimbot_TeamCheck = true,
			Aimbot_VisibleCheck = false,
			Aimlock_Enabled = false,
			Aimlock_Target = nil,
			Triggerbot_Enabled = false,
			Triggerbot_Delay = 50,
			ESP_Enabled = false,
			ESP_Boxes = true,
			ESP_Names = true,
			ESP_Health = true,
			ESP_Distance = true,
			ESP_Tracers = false,
			ESP_Cham = false,
			ESP_Skeleton = false,
			ESP_TeamCheck = true,
			ESP_MaxDist = 2000,
			Fullbright = false,
			AntiFlash = false,
			Crosshair = false,
			FOVCircle = false,
			Speed_Enabled = false,
			Speed_Value = 35,
			Fly_Enabled = false,
			Fly_Speed = 60,
			Noclip = false,
			NoRecoil = false,
			Recoil_Amount = 100,
			ShowGUI = true,
			Minimized = false,
			ToggleKey = Enum.KeyCode.RightShift,
		}
		local pcall_
		local v71 = HttpService2
		local v72 = t10

		pcall(function()
			local function v73(...)
				return {
					...,
					n = select("#", ...),
				}
			end

			if not isfile("JacobHelper_Configs/config.json") then
				return
			end
			local v75 = v73(readfile("JacobHelper_Configs/config.json"))
			local data = v71:JSONDecode(unpack(v75, 1, v75.n))

			if type(data) ~= "table" then
				return
			end

			for k, v in pairs(data) do
				if type(v) ~= "table" or v.__type ~= "EnumItem" then
					v72[k] = v
				else
					local v87 = v
					local ok, result = pcall(function()
						return Enum[v87.EnumType][v87.Name]
					end)

					if ok then
						v72[k] = result
					end
				end
			end
		end)

		local v90 = HttpService2
		local v91 = LocalPlayer

		pcall_ = function(p6)
			p6.Name = v90:GenerateGUID(false)

			local ok, parent = pcall(function()
				return gethui()
			end)

			if ok and parent then
				p6.Parent = parent

				return p6
			end

			local ok2, result = pcall(function()
				return game:GetService("CoreGui")
			end)

			p6.Parent = ok2 and result and result or v91:WaitForChild("PlayerGui")

			return p6
		end
		local t11 = {}
		local t12 = {}
		local v101 = t12
		local v102 = t11
		local v103 = Viewmodels

		local function v104(p7)
			if not (p7 and p7.Parent) then
				return nil
			end

			local Character = p7.Character
			local v106

			if Character then
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid = Humanoid.Health > 0
				end

				if Humanoid then
					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return nil
					end

					local v109 = v101[p7]

					if v109 and v109.Parent then
						local v110

						if v109 and v109.Parent and v109.Name == "Viewmodel" then
							local torso = v109:FindFirstChild("torso")

							if torso then
								v110 = torso:FindFirstChild("JointMotor") and true or false
							else
								v110 = false
							end
						else
							v110 = false
						end

						if v110 then
							return v109
						end
					end

					local v112 = v103
					local n1 = 30
					local v114 = nil

					for _, child in ipairs(v112:GetChildren()) do
						local v117

						if child and child.Parent and child.Name == "Viewmodel" then
							local torso = child:FindFirstChild("torso")

							if torso then
								v117 = torso:FindFirstChild("JointMotor") and true or false
							else
								v117 = false
							end
						else
							v117 = false
						end

						if v117 and not v102[child] then
							local torso = child:FindFirstChild("torso")

							if torso then
								local Magnitude = (torso.Position - HumanoidRootPart.Position).Magnitude

								if Magnitude < n1 then
									v114 = child
									n1 = Magnitude
								end
							end
						end
					end

					if not v114 then
						return v114
					end

					v102[v114] = p7
					v101[p7] = v114

					return v114
				else
					v106 = v101[p7]

					if not v106 then
						return nil
					end

					v102[v106] = nil
					v101[p7] = nil

					return nil
				end
			else
				v106 = v101[p7]

				if not v106 then
					return nil
				end

				v102[v106] = nil
				v101[p7] = nil

				return nil
			end
		end

		local ChildAdded = Viewmodels.ChildAdded
		local v122 = t11
		local v123 = Players
		local v124 = LocalPlayer
		local v125 = t12

		ChildAdded:Connect(function(p8)
			if p8.Name ~= "Viewmodel" then
				return
			end

			local spawn = task.spawn
			local v127 = p8

			spawn(function()
				task.wait(0.2)

				if not v127.Parent then
					return
				end
				local v129

				if v127 and v127.Parent and v127.Name == "Viewmodel" then
					local torso = v127:FindFirstChild("torso")

					if torso then
						v129 = torso:FindFirstChild("JointMotor") and true or false
					else
						v129 = false
					end
				else
					v129 = false
				end

				if not v129 then
					return
				end

				if v122[v127] then
					return
				end

				local torso = v127:FindFirstChild("torso")

				if not torso then
					return
				end

				local v132 = v123
				local n2 = 30
				local v134 = nil

				for _, player in ipairs(v132:GetPlayers()) do
					if player ~= v124 and not v125[player] then
						local Character = player.Character

						if Character then
							local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

							if Humanoid then
								Humanoid = Humanoid.Health > 0
							end

							if Humanoid then
								local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

								if HumanoidRootPart then
									local Magnitude = (torso.Position - HumanoidRootPart.Position).Magnitude

									if Magnitude < n2 then
										v134 = player
										n2 = Magnitude
									end
								end
							end
						end
					end
				end

				if not v134 then
					return
				end

				v122[v127] = v134
				v125[v134] = v127
			end)
		end)
		ChildAdded = Viewmodels.ChildRemoved

		local v141 = t11
		local v142 = t12

		ChildAdded:Connect(function(p9)
			local v143 = v141[p9]

			if not v143 then
				return
			end

			if v142[v143] == p9 then
				v142[v143] = nil
			end

			v141[p9] = nil
		end)
		ChildAdded = function(p10, p11)
			local v144 = p10:FindFirstChild(p11)

			if v144 then
				return v144.Position
			else
				local torso = p10:FindFirstChild("torso")

				if torso then
					if p11 == "head" then
						return torso.Position + Vector3.new(0, 2.5, 0)
					else
						return torso.Position
					end
				else
					return Vector3.zero
				end
			end
		end

		local v146 = CurrentCamera
		local v147 = LocalPlayer
		local v148 = Viewmodels
		local v149 = Workspace

		local function v150(p12)
			local Position = v146.CFrame.Position
			local v152 = p12 - Position
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			local filterDescendantsInstances = {
				v147.Character,
				v148,
			}

			raycastParams.FilterDescendantsInstances = filterDescendantsInstances

			local hit = v149:Raycast(Position, v152, raycastParams)

			return not hit and true or (hit.Position - p12).Magnitude < 3
		end

		local v157 = t10
		local v158 = CurrentCamera
		local v159 = Players
		local v160 = LocalPlayer
		local v161 = v104
		local v162 = ChildAdded
		local v163 = v150

		v150 = function()
			local Aimbot_FOV = v157.Aimbot_FOV
			local vector2 = Vector2.new(v158.ViewportSize.X / 2, v158.ViewportSize.Y / 2)
			local v167, v168, v169 = ipairs(v159:GetPlayers())
			local v170 = nil

			while true do
				local v171

				v169, v171 = v167(v168, v169)

				if v169 == nil then
					return v170
				end

				if v171 == v160 then
					continue
				end

				if v157.Aimbot_TeamCheck then
					local v172

					if v171 and v160.Team then
						v172 = v171.Team == v160.Team
					else
						v172 = false
					end

					if v172 then
						continue
					end
				end

				local Character = v171.Character

				if Character then
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					if Humanoid then
						Humanoid = Humanoid.Health > 0
					end

					if Humanoid then
						local v175 = v161(v171)

						if v175 then
							local v176 = v162(v175, v157.Aimbot_Part)
							local v177, v178 = v158:WorldToViewportPoint(v176)

							if v178 then
								local Magnitude = (Vector2.new(v177.X, v177.Y) - vector2).Magnitude

								if Magnitude < Aimbot_FOV and (not (v157.Aimbot_VisibleCheck or v157.Aimbot_WallCheck) or v163(v176)) then
									Aimbot_FOV = Magnitude
									v170 = {
										Player = v171,
										Character = Character,
										Viewmodel = v175,
									}
								end
							end
						end
					end
				end

				continue
			end
		end

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.IgnoreGuiInset = true
		pcall_(ScreenGui)

		local t13 = {
			bg = Color3.fromRGB(12, 12, 18),
			topbar = Color3.fromRGB(16, 16, 24),
			sidebar = Color3.fromRGB(14, 14, 21),
			card = Color3.fromRGB(20, 20, 30),
			cardHover = Color3.fromRGB(26, 26, 39),
			accent = Color3.fromRGB(99, 102, 241),
			accentDim = Color3.fromRGB(79, 82, 204),
			text = Color3.fromRGB(228, 228, 234),
			subtext = Color3.fromRGB(130, 130, 150),
			toggleOff = Color3.fromRGB(38, 38, 52),
			track = Color3.fromRGB(30, 30, 44),
			danger = Color3.fromRGB(239, 68, 68),
			green = Color3.fromRGB(34, 197, 94),
		}
		local Frame = Instance.new("Frame")

		Frame.Size = UDim2.new(0, 520, 0, 380)
		Frame.Position = UDim2.new(0.5, -260, 0.5, -190)
		Frame.BackgroundColor3 = t13.bg
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true
		Frame.ClipsDescendants = true
		Frame.Parent = ScreenGui
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

		local UIStroke = Instance.new("UIStroke", Frame)

		UIStroke.Color = t13.accent
		UIStroke.Thickness = 1
		UIStroke.Transparency = 0.6
		UIStroke = Instance.new("Frame")
		UIStroke.Size = UDim2.new(1, 0, 0, 36)
		UIStroke.BackgroundColor3 = t13.topbar
		UIStroke.BorderSizePixel = 0
		UIStroke.Parent = Frame
		Instance.new("UICorner", UIStroke).CornerRadius = UDim.new(0, 8)

		local Frame2 = Instance.new("Frame")

		Frame2.Size = UDim2.new(1, 0, 0, 18)
		Frame2.Position = UDim2.new(0, 0, 0, 18)
		Frame2.BackgroundColor3 = t13.topbar
		Frame2.BorderSizePixel = 0
		Frame2.Parent = UIStroke
		Frame2 = Instance.new("ImageLabel")
		Frame2.Size = UDim2.new(0, 18, 0, 18)
		Frame2.Position = UDim2.new(0, 12, 0, 9)
		Frame2.BackgroundTransparency = 1
		Frame2.Image = "rbxassetid://6031280834"
		Frame2.ImageColor3 = t13.accent
		Frame2.Parent = UIStroke
		Frame2 = Instance.new("TextLabel")
		Frame2.Size = UDim2.new(0, 180, 0, 18)
		Frame2.Position = UDim2.new(0, 36, 0, 9)
		Frame2.BackgroundTransparency = 1
		Frame2.Text = "jacob helper"
		Frame2.TextColor3 = t13.text
		Frame2.Font = Enum.Font.GothamBold
		Frame2.TextSize = 14
		Frame2.TextXAlignment = Enum.TextXAlignment.Left
		Frame2.Parent = UIStroke
		Frame2 = Instance.new("TextLabel")
		Frame2.Size = UDim2.new(0, 60, 0, 14)
		Frame2.Position = UDim2.new(0, 36, 0, 23)
		Frame2.BackgroundTransparency = 1
		Frame2.Text = "v3.2 • s3"
		Frame2.TextColor3 = t13.subtext
		Frame2.Font = Enum.Font.Gotham
		Frame2.TextSize = 9
		Frame2.TextXAlignment = Enum.TextXAlignment.Left
		Frame2.Parent = UIStroke
		Frame2 = Instance.new("TextButton")
		Frame2.Size = UDim2.new(0, 100, 0, 24)
		Frame2.Position = UDim2.new(1, -216, 0, 6)
		Frame2.BackgroundColor3 = t13.accent
		Frame2.Text = "  Copy Discord"
		Frame2.TextColor3 = Color3.fromRGB(255, 255, 255)
		Frame2.Font = Enum.Font.GothamSemibold
		Frame2.TextSize = 11
		Frame2.AutoButtonColor = false
		Frame2.Parent = UIStroke
		Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 5)

		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Size = UDim2.new(0, 14, 0, 14)
		ImageLabel.Position = UDim2.new(0, 8, 0.5, -7)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxassetid://8062124236"
		ImageLabel.Parent = Frame2
		ImageLabel = Frame2.MouseEnter

		local v186 = TweenService
		local v187 = Frame2
		local v188 = t13

		ImageLabel:Connect(function()
			v186:Create(v187, TweenInfo.new(0.15), {
				BackgroundColor3 = v188.accentDim,
			}):Play()
		end)
		ImageLabel = Frame2.MouseLeave

		local v189 = TweenService
		local v190 = Frame2
		local v191 = t13

		ImageLabel:Connect(function()
			v189:Create(v190, TweenInfo.new(0.15), {
				BackgroundColor3 = v191.accent,
			}):Play()
		end)
		ImageLabel = Frame2.MouseButton1Click

		local v192 = Frame2
		local v193 = t13

		ImageLabel:Connect(function()
			pcall(function()
				setclipboard("https://discord.gg/9mgCFuNK8n")
			end)
			v192.Text = "  Copied!"
			v192.BackgroundColor3 = v193.green
			task.delay(1.5, function()
				v192.Text = "  Copy Discord"
				v192.BackgroundColor3 = v193.accent
			end)
		end)
		ImageLabel = Instance.new("TextButton")
		ImageLabel.Size = UDim2.new(0, 28, 0, 24)
		ImageLabel.Position = UDim2.new(1, -104, 0, 6)
		ImageLabel.BackgroundColor3 = t13.card
		ImageLabel.Text = ""
		ImageLabel.AutoButtonColor = false
		ImageLabel.Parent = UIStroke
		Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 5)
		Frame2 = Instance.new("ImageLabel")
		Frame2.Size = UDim2.new(0, 12, 0, 12)
		Frame2.Position = UDim2.new(0.5, -6, 0.5, -6)
		Frame2.BackgroundTransparency = 1
		Frame2.Image = "rbxassetid://6031094678"
		Frame2.ImageColor3 = t13.text
		Frame2.Parent = ImageLabel

		local TextButton = Instance.new("TextButton")

		TextButton.Size = UDim2.new(0, 28, 0, 24)
		TextButton.Position = UDim2.new(1, -70, 0, 6)
		TextButton.BackgroundColor3 = t13.danger
		TextButton.Text = ""
		TextButton.AutoButtonColor = false
		TextButton.Parent = UIStroke
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 5)
		UIStroke = Instance.new("ImageLabel")
		UIStroke.Size = UDim2.new(0, 12, 0, 12)
		UIStroke.Position = UDim2.new(0.5, -6, 0.5, -6)
		UIStroke.BackgroundTransparency = 1
		UIStroke.Image = "rbxassetid://6031094670"
		UIStroke.ImageColor3 = Color3.fromRGB(255, 255, 255)
		UIStroke.Parent = TextButton
		TextButton = TextButton.MouseButton1Click

		local v195 = ScreenGui

		TextButton:Connect(function()
			v195:Destroy()
		end)
		TextButton = Instance.new("Frame")
		TextButton.Size = UDim2.new(0, 120, 1, -36)
		TextButton.Position = UDim2.new(0, 0, 0, 36)
		TextButton.BackgroundColor3 = t13.sidebar
		TextButton.BorderSizePixel = 0
		TextButton.ClipsDescendants = true
		TextButton.Parent = Frame
		UIStroke = Instance.new("UIListLayout")
		UIStroke.Padding = UDim.new(0, 4)
		UIStroke.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIStroke.Parent = TextButton
		UIStroke = Instance.new("UIPadding")
		UIStroke.PaddingTop = UDim.new(0, 10)
		UIStroke.PaddingLeft = UDim.new(0, 6)
		UIStroke.PaddingRight = UDim.new(0, 6)
		UIStroke.Parent = TextButton
		UIStroke = Instance.new("Frame")
		UIStroke.Size = UDim2.new(1, -120, 1, -36)
		UIStroke.Position = UDim2.new(0, 120, 0, 36)
		UIStroke.BackgroundTransparency = 1
		UIStroke.ClipsDescendants = true
		UIStroke.Parent = Frame

		local v196 = t13
		local v197 = TextButton
		local v198 = UIStroke
		local t14 = {}
		local t15 = {}
		local v201 = TweenService

		local function createScrollingFrame(p13, p14)
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(1, 0, 0, 30)
			TextButton2.BackgroundColor3 = p14 and v196.accent or v196.card
			TextButton2.Text = p13
			TextButton2.TextColor3 = p14 and Color3.fromRGB(255, 255, 255) or v196.subtext
			TextButton2.Font = Enum.Font.GothamSemibold
			TextButton2.TextSize = 12
			TextButton2.AutoButtonColor = false
			TextButton2.Parent = v197
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 5)

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Size = UDim2.new(1, -12, 1, -12)
			ScrollingFrame.Position = UDim2.new(0, 6, 0, 6)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = v196.accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.Visible = p14
			ScrollingFrame.Parent = v198

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.Padding = UDim.new(0, 5)
			UIListLayout.Parent = ScrollingFrame

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0, 2)
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.Parent = ScrollingFrame

			table.insert(t14, TextButton2)

			table.insert(t15, ScrollingFrame)

			local MouseButton1Click = TextButton2.MouseButton1Click
			local v210 = TextButton2
			local v211 = ScrollingFrame

			MouseButton1Click:Connect(function()
				for _, v in ipairs(t14) do
					v201:Create(v, TweenInfo.new(0.15), {
						BackgroundColor3 = v196.card,
						TextColor3 = v196.subtext,
					}):Play()
				end

				for _, v in ipairs(t15) do
					v.Visible = false
				end

				v201:Create(v210, TweenInfo.new(0.15), {
					BackgroundColor3 = v196.accent,
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}):Play()
				v211.Visible = true
			end)

			return ScrollingFrame
		end

		local v216 = t13
		local v217 = t10
		local v218 = TweenService
		local v219 = HttpService2

		local function createFrame(p15, p16, p17, p18)
			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(1, -4, 0, 32)
			Frame3.BackgroundColor3 = v216.card
			Frame3.BorderSizePixel = 0
			Frame3.Parent = p15
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 5)

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -56, 1, 0)
			TextLabel.Position = UDim2.new(0, 10, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p16
			TextLabel.TextColor3 = v216.text
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Frame3

			if v217[p17] == nil then
				v217[p17] = p18
			end

			local v223 = v217[p17]
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(0, 40, 0, 20)
			TextButton2.Position = UDim2.new(1, -48, 0.5, -10)
			TextButton2.BackgroundColor3 = v223 and v216.accent or v216.toggleOff
			TextButton2.Text = ""
			TextButton2.AutoButtonColor = false
			TextButton2.Parent = Frame3
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.new(0, 16, 0, 16)
			Frame4.Position = v223 and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame4.BorderSizePixel = 0
			Frame4.Parent = TextButton2
			Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

			local MouseButton1Click = TextButton2.MouseButton1Click
			local v227 = p17

			MouseButton1Click:Connect(function()
				v217[v227] = not v217[v227]

				local v228 = v217[v227]

				v218:Create(TextButton2, TweenInfo.new(0.15), {
					BackgroundColor3 = v228 and v216.accent or v216.toggleOff,
				}):Play()
				v218:Create(Frame4, TweenInfo.new(0.15), {
					Position = v228 and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				}):Play()
				pcall(function()
					local v229, t16, EnumType

					if isfolder("JacobHelper_Configs") then
						v253, v254, v255 = pairs(v217)
						v256 = {}

						while true do
							v255, v229 = v253(v254, v255)

							if v255 == nil then
								break
							end

							if typeof(v229) ~= "EnumItem" then
								v256[v255] = v229
							else
								t16 = {
									__type = "EnumItem",
								}
								EnumType = v229.EnumType
								t16.EnumType = tostring(EnumType)
								t16.Name = v229.Name
								v256[v255] = t16
							end
						end

						v257 = v219
						writefile("JacobHelper_Configs/config.json", v219:JSONEncode(v256))

						return
					end

					makefolder("JacobHelper_Configs")

					local v232, v233, v234 = pairs(v217)
					local t17 = {}

					while true do
						v234, v229 = v232(v233, v234)

						if v234 == nil then
							break
						end

						if typeof(v229) ~= "EnumItem" then
							t17[v234] = v229
						else
							t16 = {
								__type = "EnumItem",
							}
							EnumType = v229.EnumType
							t16.EnumType = tostring(EnumType)
							t16.Name = v229.Name
							t17[v234] = t16
						end
					end

					writefile("JacobHelper_Configs/config.json", v219:JSONEncode(t17))
				end)
			end)

			return Frame3
		end

		local v237 = t13
		local v238 = t10
		local v239 = UserInputService
		local v240 = HttpService2

		local function createFrame2(p19, p20, p21, p22, p23, p24)
			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(1, -4, 0, 42)
			Frame3.BackgroundColor3 = v237.card
			Frame3.BorderSizePixel = 0
			Frame3.Active = true
			Frame3.Parent = p19
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 5)

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -56, 0, 18)
			TextLabel.Position = UDim2.new(0, 10, 0, 4)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p20
			TextLabel.TextColor3 = v237.text
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Frame3

			if v238[p21] == nil then
				v238[p21] = p24
			end

			local v244 = v238[p21]
			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.new(0, 46, 0, 18)
			TextLabel2.Position = UDim2.new(1, -54, 0, 4)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = tostring(v244)
			TextLabel2.TextColor3 = v237.accent
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextSize = 12
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel2.Parent = Frame3

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.new(1, -20, 0, 3)
			Frame4.Position = UDim2.new(0, 10, 0, 30)
			Frame4.BackgroundColor3 = v237.track
			Frame4.BorderSizePixel = 0
			Frame4.Active = true
			Frame4.Parent = Frame3
			Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.new((v244 - p22) / (p23 - p22), 0, 1, 0)
			Frame5.BackgroundColor3 = v237.accent
			Frame5.BorderSizePixel = 0
			Frame5.Parent = Frame4
			Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.new(0, 12, 0, 12)
			Frame6.Position = UDim2.new((v244 - p22) / (p23 - p22), -6, 0.5, -6)
			Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame6.BorderSizePixel = 0
			Frame6.Parent = Frame4
			Instance.new("UICorner", Frame6).CornerRadius = UDim.new(1, 0)

			local u249 = false
			local v250 = Frame4
			local v251 = p22
			local v252 = p21

			local function v258(p25)
				local v259 = (p25.Position.X - v250.AbsolutePosition.X) / v250.AbsoluteSize.X
				local v260 = math.clamp(v259, 0, 1)
				local v261 = v251 + (p23 - v251) * v260 + 0.5
				local v262 = math.floor(v261)

				v238[v252] = v262
				TextLabel2.Text = tostring(v262)
				Frame5.Size = UDim2.new(v260, 0, 1, 0)
				Frame6.Position = UDim2.new(v260, -6, 0.5, -6)
			end

			local InputBegan = Frame4.InputBegan
			local v263 = v258

			InputBegan:Connect(function(p26)
				if p26.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end

				u249 = true
				v263(p26)
			end)

			local InputChanged = v239.InputChanged
			local v264 = v258

			InputChanged:Connect(function(p27)
				if not (u249 and p27.UserInputType == Enum.UserInputType.MouseMovement) then
					return
				end

				v264(p27)
			end)
			v239.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end

				if u249 then
					pcall(function()
						local v265, t18, EnumType

						if isfolder("JacobHelper_Configs") then
							v296, v297, v298 = pairs(v238)
							v299 = {}

							while true do
								v298, v265 = v296(v297, v298)

								if v298 == nil then
									break
								end

								if typeof(v265) ~= "EnumItem" then
									v299[v298] = v265
								else
									t18 = {
										__type = "EnumItem",
									}
									EnumType = v265.EnumType
									t18.EnumType = tostring(EnumType)
									t18.Name = v265.Name
									v299[v298] = t18
								end
							end

							v300 = v240
							writefile("JacobHelper_Configs/config.json", v240:JSONEncode(v299))

							return
						end

						makefolder("JacobHelper_Configs")

						local v266, v267, v268 = pairs(v238)
						local t19 = {}

						while true do
							v268, v265 = v266(v267, v268)

							if v268 == nil then
								break
							end

							if typeof(v265) ~= "EnumItem" then
								t19[v268] = v265
							else
								t18 = {
									__type = "EnumItem",
								}
								EnumType = v265.EnumType
								t18.EnumType = tostring(EnumType)
								t18.Name = v265.Name
								t19[v268] = t18
							end
						end

						writefile("JacobHelper_Configs/config.json", v240:JSONEncode(t19))
					end)
				end

				u249 = false
			end)

			return Frame3
		end

		local v270 = t13
		local v271 = t10
		local v272 = HttpService2

		local function createFrame3(p28, p29, p30, p31, p32)
			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(1, -4, 0, 32)
			Frame3.BackgroundColor3 = v270.card
			Frame3.BorderSizePixel = 0
			Frame3.Parent = p28
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 5)

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(0, 100, 1, 0)
			TextLabel.Position = UDim2.new(0, 10, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p29
			TextLabel.TextColor3 = v270.text
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Frame3

			if v271[p30] == nil then
				v271[p30] = p32
			end

			local v276 = v271[p30]
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(0, 110, 0, 22)
			TextButton2.Position = UDim2.new(1, -118, 0.5, -11)
			TextButton2.BackgroundColor3 = v270.track
			TextButton2.Text = tostring(v276)
			TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton2.Font = Enum.Font.GothamSemibold
			TextButton2.TextSize = 11
			TextButton2.Parent = Frame3
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)

			local v278, v279, u280 = ipairs(p31)
			local n3 = 1

			while true do
				local v282

				u280, v282 = v278(v279, u280)

				if u280 == nil then
					u280 = n3

					break
				end

				if v282 == v276 then
					break
				end
			end

			local MouseButton1Click = TextButton2.MouseButton1Click
			local v284 = p31
			local v285 = p30

			MouseButton1Click:Connect(function()
				u280 = u280 % #v284 + 1
				v271[v285] = v284[u280]
				local v287 = v284[u280]

				TextButton2.Text = tostring(v287)
				pcall(function()
					local v288, t20, EnumType

					if isfolder("JacobHelper_Configs") then
						v327, v328, v329 = pairs(v271)
						v330 = {}

						while true do
							v329, v288 = v327(v328, v329)

							if v329 == nil then
								break
							end

							if typeof(v288) ~= "EnumItem" then
								v330[v329] = v288
							else
								t20 = {
									__type = "EnumItem",
								}
								EnumType = v288.EnumType
								t20.EnumType = tostring(EnumType)
								t20.Name = v288.Name
								v330[v329] = t20
							end
						end

						v331 = v272
						writefile("JacobHelper_Configs/config.json", v272:JSONEncode(v330))

						return
					end

					makefolder("JacobHelper_Configs")

					local v291, v292, v293 = pairs(v271)
					local t21 = {}

					while true do
						v293, v288 = v291(v292, v293)

						if v293 == nil then
							break
						end

						if typeof(v288) ~= "EnumItem" then
							t21[v293] = v288
						else
							t20 = {
								__type = "EnumItem",
							}
							EnumType = v288.EnumType
							t20.EnumType = tostring(EnumType)
							t20.Name = v288.Name
							t21[v293] = t20
						end
					end

					writefile("JacobHelper_Configs/config.json", v272:JSONEncode(t21))
				end)
			end)

			return Frame3
		end

		local v301 = t13
		local v302 = t10
		local v303 = UserInputService
		local v304 = HttpService2

		HttpService2 = function(p33, p34, p35, p36)
			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.new(1, -4, 0, 32)
			Frame3.BackgroundColor3 = v301.card
			Frame3.BorderSizePixel = 0
			Frame3.Parent = p33
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 5)

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -100, 1, 0)
			TextLabel.Position = UDim2.new(0, 10, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p34
			TextLabel.TextColor3 = v301.text
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Frame3

			if v302[p35] == nil then
				v302[p35] = p36
			end

			local v305 = v302[p35]
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(0, 80, 0, 22)
			TextButton2.Position = UDim2.new(1, -88, 0.5, -11)
			TextButton2.BackgroundColor3 = v301.track
			TextButton2.Text = v305.Name
			TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton2.Font = Enum.Font.GothamSemibold
			TextButton2.TextSize = 11
			TextButton2.Parent = Frame3
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)

			local u306 = false
			local MouseButton1Click = TextButton2.MouseButton1Click
			local v307 = TextButton2

			MouseButton1Click:Connect(function()
				u306 = true
				v307.Text = "..."
			end)

			local InputBegan = v303.InputBegan
			local v308 = p35
			local v309 = TextButton2

			InputBegan:Connect(function(p37, _)
				if not (u306 and p37.UserInputType == Enum.UserInputType.Keyboard) then
					return
				end

				v302[v308] = p37.KeyCode
				v309.Text = p37.KeyCode.Name
				u306 = false
				pcall(function()
					local v310, t22, EnumType

					if isfolder("JacobHelper_Configs") then
						v355, v356, v357 = pairs(v302)
						v358 = {}

						while true do
							v357, v310 = v355(v356, v357)

							if v357 == nil then
								break
							end

							if typeof(v310) ~= "EnumItem" then
								v358[v357] = v310
							else
								t22 = {
									__type = "EnumItem",
								}
								EnumType = v310.EnumType
								t22.EnumType = tostring(EnumType)
								t22.Name = v310.Name
								v358[v357] = t22
							end
						end

						v359 = v304
						writefile("JacobHelper_Configs/config.json", v304:JSONEncode(v358))

						return
					end

					makefolder("JacobHelper_Configs")

					local v313, v314, v315 = pairs(v302)
					local t23 = {}

					while true do
						v315, v310 = v313(v314, v315)

						if v315 == nil then
							break
						end

						if typeof(v310) ~= "EnumItem" then
							t23[v315] = v310
						else
							t22 = {
								__type = "EnumItem",
							}
							EnumType = v310.EnumType
							t22.EnumType = tostring(EnumType)
							t22.Name = v310.Name
							t23[v315] = t22
						end
					end

					writefile("JacobHelper_Configs/config.json", v304:JSONEncode(t23))
				end)
			end)

			return Frame3
		end

		local Combat = createScrollingFrame("Combat", true)
		local Visuals = createScrollingFrame("Visuals")
		local Movement = createScrollingFrame("Movement")

		createScrollingFrame = createScrollingFrame("Misc")
		createFrame(Combat, "Aimbot (Right Click)", "Aimbot_Enabled", false)
		createFrame2(Combat, "Aimbot FOV", "Aimbot_FOV", 30, 500, 120)
		createFrame2(Combat, "Smoothness", "Aimbot_Smoothness", 5, 100, 25)
		createFrame3(Combat, "Target Part", "Aimbot_Part", { "head", "torso", "HumanoidRootPart" }, "head")
		createFrame(Combat, "Wall Check", "Aimbot_WallCheck", false)
		createFrame(Combat, "Team Check", "Aimbot_TeamCheck", true)
		createFrame(Combat, "Visible Check", "Aimbot_VisibleCheck", false)
		createFrame(Combat, "Aimlock (Q)", "Aimlock_Enabled", false)
		createFrame(Combat, "Triggerbot", "Triggerbot_Enabled", false)
		createFrame2(Combat, "Triggerbot Delay (ms)", "Triggerbot_Delay", 10, 500, 50)
		createFrame(Combat, "No Recoil", "NoRecoil", false)
		createFrame2(Combat, "Recoil Control %", "Recoil_Amount", 0, 100, 100)
		createFrame(Visuals, "ESP Enabled", "ESP_Enabled", false)
		createFrame(Visuals, "Boxes", "ESP_Boxes", true)
		createFrame(Visuals, "Names", "ESP_Names", true)
		createFrame(Visuals, "Health Bar", "ESP_Health", true)
		createFrame(Visuals, "Distance", "ESP_Distance", true)
		createFrame(Visuals, "Tracers", "ESP_Tracers", false)
		createFrame(Visuals, "Chams", "ESP_Cham", false)
		createFrame(Visuals, "Skeleton", "ESP_Skeleton", false)
		createFrame(Visuals, "Team Check", "ESP_TeamCheck", true)
		createFrame2(Visuals, "Max Distance", "ESP_MaxDist", 100, 5000, 2000)
		createFrame(Visuals, "Fullbright", "Fullbright", false)
		createFrame(Visuals, "Anti-Flash", "AntiFlash", false)
		createFrame(Visuals, "Crosshair", "Crosshair", false)
		createFrame(Visuals, "FOV Circle", "FOVCircle", false)
		createFrame(Movement, "Speed Hack", "Speed_Enabled", false)
		createFrame2(Movement, "Speed Value", "Speed_Value", 16, 100, 35)
		createFrame(Movement, "Fly", "Fly_Enabled", false)
		createFrame2(Movement, "Fly Speed", "Fly_Speed", 20, 200, 60)
		createFrame(Movement, "Noclip", "Noclip", false)
		HttpService2(createScrollingFrame, "Toggle UI Key", "ToggleKey", Enum.KeyCode.RightShift)
		Movement = Instance.new("Frame")
		Movement.Size = UDim2.new(1, -4, 0, 70)
		Movement.BackgroundColor3 = t13.card
		Movement.BorderSizePixel = 0
		Movement.Parent = createScrollingFrame
		Instance.new("UICorner", Movement).CornerRadius = UDim.new(0, 5)
		Visuals = Instance.new("TextLabel")
		Visuals.Size = UDim2.new(1, -20, 1, -20)
		Visuals.Position = UDim2.new(0, 10, 0, 10)
		Visuals.BackgroundTransparency = 1
		Visuals.Text = "Aimbot: Right Click | Aimlock: Q\nUse Toggle Key to show/hide GUI\nClick 'Copy Discord' at top to copy link"
		Visuals.TextColor3 = t13.subtext
		Visuals.Font = Enum.Font.Gotham
		Visuals.TextSize = 11
		Visuals.TextWrapped = true
		Visuals.TextXAlignment = Enum.TextXAlignment.Left
		Visuals.TextYAlignment = Enum.TextYAlignment.Top
		Visuals.Parent = Movement

		local Size = Frame.Size

		Movement = ImageLabel.MouseButton1Click

		local v322 = t10
		local v323 = TextButton
		local v324 = UIStroke
		local v325 = TweenService
		local v326 = Frame
		local v332 = Frame2

		Movement:Connect(function()
			v322.Minimized = not v322.Minimized

			if v322.Minimized then
				v323.Visible = false
				v324.Visible = false
				v325:Create(v326, TweenInfo.new(0.2), {
					Size = UDim2.new(0, 520, 0, 36),
				}):Play()
				v332.Image = "rbxassetid://6031094670"
			else
				v325:Create(v326, TweenInfo.new(0.2), {
					Size = Size,
				}):Play()
				task.wait(0.2)
				v323.Visible = true
				v324.Visible = true
				v332.Image = "rbxassetid://6031094678"
			end
		end)
		Movement = {
			{ "head", "torso" },
			{ "torso", "shoulder1" },
			{ "shoulder1", "arm1" },
			{ "torso", "shoulder2" },
			{ "shoulder2", "arm2" },
			{ "torso", "hip1" },
			{ "hip1", "leg1" },
			{ "torso", "hip2" },
			{ "hip2", "leg2" },
		}
		Visuals = {}

		local v333 = Movement

		Combat = function()
			local t24 = {
				box = Drawing.new("Quad"),
			}

			t24.box.Thickness = 1.5
			t24.box.Filled = false
			t24.box.Visible = false
			t24.name = Drawing.new("Text")
			t24.name.Size = 13
			t24.name.Color = Color3.fromRGB(255, 255, 255)
			t24.name.Center = true
			t24.name.Outline = true
			t24.name.Visible = false
			t24.dist = Drawing.new("Text")
			t24.dist.Size = 12
			t24.dist.Color = Color3.fromRGB(180, 180, 200)
			t24.dist.Center = true
			t24.dist.Outline = true
			t24.dist.Visible = false
			t24.healthBg = Drawing.new("Quad")
			t24.healthBg.Thickness = 0
			t24.healthBg.Filled = true
			t24.healthBg.Color = Color3.fromRGB(0, 0, 0)
			t24.healthBg.Transparency = 0.5
			t24.healthBg.Visible = false
			t24.health = Drawing.new("Quad")
			t24.health.Thickness = 0
			t24.health.Filled = true
			t24.health.Visible = false
			t24.tracer = Drawing.new("Line")
			t24.tracer.Thickness = 1
			t24.tracer.Visible = false
			t24.skeleton = {}

			for _ = 1, #v333 do
				local Line = Drawing.new("Line")

				Line.Thickness = 1.5
				Line.Visible = false

				local skeleton = t24.skeleton

				table.insert(skeleton, Line)
			end

			t24.highlight = nil

			return t24
		end
		createFrame3 = function(p38)
			if not p38 then
				return
			end

			p38.box.Visible = false
			p38.name.Visible = false
			p38.dist.Visible = false
			p38.healthBg.Visible = false
			p38.health.Visible = false
			p38.tracer.Visible = false

			for _, v in ipairs(p38.skeleton) do
				v.Visible = false
			end

			if not p38.highlight then
				return
			end

			p38.highlight.Enabled = false
		end
		createFrame2 = function(p39)
			if not p39 then
				return
			end
			local v336 = p39

			pcall(function()
				v336.box:Remove()
			end)
			local v338 = p39

			pcall(function()
				v338.name:Remove()
			end)
			local v340 = p39

			pcall(function()
				v340.dist:Remove()
			end)
			local v342 = p39

			pcall(function()
				v342.healthBg:Remove()
			end)
			local v344 = p39

			pcall(function()
				v344.health:Remove()
			end)
			local v346 = p39

			pcall(function()
				v346.tracer:Remove()
			end)

			for _, v in ipairs(p39.skeleton) do
				local v350 = v

				pcall(function()
					v350:Remove()
				end)
			end

			if not p39.highlight then
				return
			end
			local v352 = p39

			pcall(function()
				v352.highlight:Destroy()
			end)
		end

		local v353 = t10
		local v354 = createFrame3
		local v360 = LocalPlayer
		local v361 = v104
		local v362 = CurrentCamera
		local v363 = Movement

		Movement = function(p40, p41)
			local v364 = nil

			if not v353.ESP_Enabled then
				v354(p41)

				return
			end

			if not (p40 and p40.Parent) then
				v354(p41)

				return
			end

			if v353.ESP_TeamCheck then
				local v365

				if p40 and v360.Team then
					v365 = p40.Team == v360.Team
				else
					v365 = false
				end

				if v365 then
					v354(p41)

					return
				end
			end

			local Character = p40.Character

			if not Character then
				v354(p41)

				return
			end

			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				Humanoid = Humanoid.Health > 0
			end

			if not Humanoid then
				v354(p41)

				return
			end

			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")

			if not (HumanoidRootPart and Humanoid2) then
				v354(p41)

				return
			end

			local v366 = v361(p40)

			if not (v366 and v366.Parent) then
				v354(p41)

				return
			end

			local torso = v366:FindFirstChild("torso")

			if not torso then
				v354(p41)

				return
			end

			local Magnitude = (v362.CFrame.Position - torso.Position).Magnitude

			if not (v353.ESP_MaxDist >= Magnitude) then
				v354(p41)

				return
			end

			local color3 = Color3.fromRGB(255, 60, 60)

			if v353.ESP_Cham then
				if not (p41.highlight and p41.highlight.Parent) then
					p41.highlight = Instance.new("Highlight")
					p41.highlight.FillTransparency = 0.5
					p41.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					p41.highlight.Parent = v366
				end

				p41.highlight.Enabled = true
				p41.highlight.FillColor = color3
				p41.highlight.Adornee = v366
			elseif p41.highlight then
				p41.highlight.Enabled = false
			end

			if v353.ESP_Skeleton then
				for i, v in ipairs(v363) do
					local v371 = v366:FindFirstChild(v[1])
					local v372 = v366:FindFirstChild(v[2])
					local v373 = p41.skeleton[i]

					if v371 and (v372 and v373) then
						local v374, v375 = v362:WorldToViewportPoint(v371.Position)
						local v376, v377 = v362:WorldToViewportPoint(v372.Position)

						if v375 and v377 then
							v373.From = Vector2.new(v374.X, v374.Y)
							v373.To = Vector2.new(v376.X, v376.Y)
							v373.Color = color3
							v373.Visible = true
						else
							v373.Visible = false
						end
					elseif v373 then
						v373.Visible = false
					end
				end
			else
				for _, v in ipairs(p41.skeleton) do
					v.Visible = false
				end
			end

			local head = v366:FindFirstChild("head")
			local Position

			if head then
				Position = head.Position
			else
				local torso2 = v366:FindFirstChild("torso")

				if torso2 then
					Position = torso2.Position + Vector3.new(0, 2.5, 0)
				else
					Position = Vector3.zero
				end
			end

			local Position2 = torso.Position
			local v384, v385 = v362:WorldToViewportPoint(Position)
			local v386 = v362:WorldToViewportPoint(Position2 - Vector3.new(0, 2, 0))

			if not v385 then
				p41.box.Visible = false
				p41.name.Visible = false
				p41.dist.Visible = false
				p41.healthBg.Visible = false
				p41.health.Visible = false
				p41.tracer.Visible = false

				return
			end

			local v387 = v386.Y - v384.Y
			local v388 = math.abs(v387)
			local v389 = v388 * 0.5

			if v388 < 8 or v389 < 4 then
				p41.box.Visible = false
				p41.name.Visible = false
				p41.dist.Visible = false
				p41.healthBg.Visible = false
				p41.health.Visible = false
				p41.tracer.Visible = false
			else
				local X = v384.X
				local Y = v384.Y
				local Y2 = v386.Y

				if v353.ESP_Boxes then
					p41.box.PointA = Vector2.new(X - v389, Y)
					p41.box.PointB = Vector2.new(X + v389, Y)
					p41.box.PointC = Vector2.new(X + v389, Y2)
					p41.box.PointD = Vector2.new(X - v389, Y2)
					p41.box.Color = color3
					p41.box.Visible = true
				else
					p41.box.Visible = false
				end

				if v353.ESP_Names then
					p41.name.Text = p40.Name
					p41.name.Position = Vector2.new(X, Y - 16)
					p41.name.Visible = true
				else
					p41.name.Visible = false
				end

				if v353.ESP_Distance then
					p41.dist.Text = string.format("[%dm]", (math.floor(Magnitude)))
					p41.dist.Position = Vector2.new(X, Y2 + 2)
					p41.dist.Visible = true
				else
					p41.dist.Visible = false
				end

				if v353.ESP_Health then
					local v393 = Humanoid2.Health / Humanoid2.MaxHealth
					local v394 = math.clamp(v393, 0, 1)
					local v395 = X - v389 - 5

					p41.healthBg.PointA = Vector2.new(v395, Y)
					p41.healthBg.PointB = Vector2.new(v395 + 3, Y)
					p41.healthBg.PointC = Vector2.new(v395 + 3, Y2)
					p41.healthBg.PointD = Vector2.new(v395, Y2)
					p41.healthBg.Visible = true

					local v396 = Y + v388 * v395

					p41.health.PointA = Vector2.new(v395, v396)
					p41.health.PointB = Vector2.new(v395 + 3, v396)
					p41.health.PointC = Vector2.new(v395 + 3, Y2)
					p41.health.PointD = Vector2.new(v395, Y2)

					local health = p41.health
					local color32 = Color3.fromRGB
					local v399 = 255 * v364
					local v400 = math.floor(v399)
					local v401 = 255 * v394

					health.Color = color32(v400, math.floor(v401), 0)
					p41.health.Visible = true
				else
					p41.healthBg.Visible = false
					p41.health.Visible = false
				end

				if v353.ESP_Tracers then
					local ViewportSize = v362.ViewportSize

					p41.tracer.From = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
					p41.tracer.To = Vector2.new(X, Y2)
					p41.tracer.Color = color3
					p41.tracer.Visible = true

					return
				else
					p41.tracer.Visible = false

					return
				end
			end
		end

		local v403 = t11
		local v404 = t12
		local v405 = Players
		local v406 = LocalPlayer
		local v407 = Visuals
		local v408 = Combat
		local v409 = Movement
		local v410 = createFrame3
		local v411 = createFrame2

		Movement = function()
			for k, v in pairs(v403) do
				if k.Parent and v.Parent then
					local v414

					if k and k.Parent and k.Name == "Viewmodel" then
						local torso = k:FindFirstChild("torso")

						if torso then
							v414 = torso:FindFirstChild("JointMotor") and true or false
						else
							v414 = false
						end
					else
						v414 = false
					end

					if not v414 then
						v403[k] = nil

						if v404[v] == k then
							v404[v] = nil
						end
					end
				else
					v403[k] = nil

					if v404[v] == k then
						v404[v] = nil
					end
				end
			end
			local v417, v418, v419 = ipairs(v405:GetPlayers())
			local t25 = {}

			while true do
				local v421

				v419, v421 = v417(v418, v419)

				if v419 == nil then
					break
				end

				if v421 ~= v406 then
					t25[v421] = true

					if not v407[v421] then
						v407[v421] = v408()
					end

					local ok = pcall(v409, v421, v407[v421])

					if not ok then
						v410(v407[v421])
					end
				end
			end

			for k, v in pairs(v407) do
				if not t25[k] then
					v411(v)
					v407[k] = nil
				end
			end
		end

		local v426 = t10
		local v427 = UserInputService
		local v428 = v150
		local v429 = ChildAdded
		local v430 = CurrentCamera

		local function v431()
			if not v426.Aimbot_Enabled then
				return
			end

			if not v427:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				return
			end

			local v432 = v428()

			if not v432 then
				return
			end

			local v433 = v429(v432.Viewmodel, v426.Aimbot_Part)
			local CFrame_ = v430.CFrame

			v430.CFrame = CFrame_:Lerp(CFrame.new(CFrame_.Position, v433), v426.Aimbot_Smoothness / 100)
		end

		local v435 = t10
		local v436 = UserInputService
		local v437 = v150
		local v438 = v104
		local v439 = ChildAdded
		local v440 = CurrentCamera

		Combat = function()
			if not v435.Aimlock_Enabled then
				return
			end

			if not v436:IsKeyDown(Enum.KeyCode.Q) then
				v435.Aimlock_Target = nil

				return
			end

			if not v435.Aimlock_Target then
				v435.Aimlock_Target = v437()
			end

			if not v435.Aimlock_Target then
				return
			end

			local Aimlock_Target = v435.Aimlock_Target

			if Aimlock_Target.Player and (Aimlock_Target.Player.Parent and Aimlock_Target.Player.Character) then
				local Character = Aimlock_Target.Player.Character
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid = Humanoid.Health > 0
				end

				if Humanoid then
					local v444 = v438(Aimlock_Target.Player)

					if v444 then
						local v445 = v439(v444, v435.Aimbot_Part)
						local CFrame_ = v440.CFrame

						v440.CFrame = CFrame_:Lerp(CFrame.new(CFrame_.Position, v445), v435.Aimbot_Smoothness / 100)

						return
					else
						v435.Aimlock_Target = nil

						return
					end
				end
			end

			v435.Aimlock_Target = nil
		end

		local n4 = 0
		local v448 = t10
		local v449 = CurrentCamera
		local v450 = LocalPlayer
		local v451 = Viewmodels
		local v452 = Workspace
		local v453 = Players

		local function v454()
			if not v448.Triggerbot_Enabled then
				return
			end

			if not (tick() - n4 >= v448.Triggerbot_Delay / 1000) then
				return
			end

			local vector2 = Vector2.new(v449.ViewportSize.X / 2, v449.ViewportSize.Y / 2)
			local v456 = v449:ViewportPointToRay(vector2.X, vector2.Y)
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			local filterDescendantsInstances = {
				v450.Character,
				v451,
			}

			raycastParams.FilterDescendantsInstances = filterDescendantsInstances

			local hit = v452:Raycast(v456.Origin, v456.Direction * 500, raycastParams)

			if not hit then
				return
			end

			local Model = hit.Instance:FindFirstAncestorOfClass("Model")

			if not (Model and Model:HasTag("Character")) then
				return
			end

			local Humanoid = Model:FindFirstChildOfClass("Humanoid")

			if not (Humanoid and Humanoid.Health > 0) then
				return
			end
			local v464, v465, v466 = ipairs(v453:GetPlayers())
			local v467 = nil

			while true do
				local v468

				v466, v468 = v464(v465, v466)

				if v466 == nil then
					v468 = v467

					break
				end

				if v468.Character == Model then
					break
				end
			end

			if v523 and v448.Aimbot_TeamCheck then
				local v469

				if v523 and v450.Team then
					v469 = v523.Team == v450.Team
				else
					v469 = false
				end

				if v469 then
					return
				end
			end

			mouse1click()
			n4 = tick()
		end

		local v470 = LocalPlayer
		local v471 = t10
		local v472 = CurrentCamera
		local v473 = UserInputService

		local function v474(p42)
			local Character = v470.Character

			if not Character then
				return
			end

			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if not (HumanoidRootPart and Humanoid) then
				return
			end

			if v471.Speed_Enabled then
				local MoveDirection = Humanoid.MoveDirection

				if MoveDirection.Magnitude > 0 then
					HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + MoveDirection * v471.Speed_Value * p42
				end
			end

			if v471.Fly_Enabled then
				local LookVector = v472.CFrame.LookVector
				local RightVector = v472.CFrame.RightVector
				local vector3 = Vector3.new()

				if v473:IsKeyDown(Enum.KeyCode.W) then
					vector3 = vector3 + LookVector
				end

				if v473:IsKeyDown(Enum.KeyCode.S) then
					vector3 = vector3 - LookVector
				end

				if v473:IsKeyDown(Enum.KeyCode.A) then
					vector3 = vector3 - RightVector
				end

				if v473:IsKeyDown(Enum.KeyCode.D) then
					vector3 = vector3 + RightVector
				end

				if v473:IsKeyDown(Enum.KeyCode.Space) then
					vector3 = vector3 + Vector3.new(0, 1, 0)
				end

				if v473:IsKeyDown(Enum.KeyCode.LeftControl) then
					vector3 = vector3 - Vector3.new(0, 1, 0)
				end

				if vector3.Magnitude > 0 then
					vector3 = vector3.Unit * v471.Fly_Speed
				end

				HumanoidRootPart.AssemblyLinearVelocity = vector3
				Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			end

			if not v471.Noclip then
				return
			end

			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end

		local t26 = {}
		local t27 = {}
		local Circle = nil
		local v487 = t10
		local v488 = Lighting

		local function v489()
			if v487.Fullbright then
				if t26.brightness then
					v488.Brightness = 3
					v488.ClockTime = 12
					v488.FogEnd = 100000
					v488.GlobalShadows = false
					v488.Ambient = Color3.fromRGB(178, 178, 178)
					v488.OutdoorAmbient = Color3.fromRGB(178, 178, 178)

					return
				end

				t26.brightness = v488.Brightness
				t26.clockTime = v488.ClockTime
				t26.fogEnd = v488.FogEnd
				t26.globalShadows = v488.GlobalShadows
				t26.ambient = v488.Ambient
				t26.outdoorAmbient = v488.OutdoorAmbient
				v488.Brightness = 3
				v488.ClockTime = 12
				v488.FogEnd = 100000
				v488.GlobalShadows = false
				v488.Ambient = Color3.fromRGB(178, 178, 178)
				v488.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
			else
				if not t26.brightness then
					return
				end

				v488.Brightness = t26.brightness
				v488.ClockTime = t26.clockTime
				v488.FogEnd = t26.fogEnd
				v488.GlobalShadows = t26.globalShadows
				v488.Ambient = t26.ambient
				v488.OutdoorAmbient = t26.outdoorAmbient
			end
		end

		local v490 = t10
		local v491 = LocalPlayer
		local v492 = Lighting

		local function v493()
			if not v490.AntiFlash then
				return
			end

			local PlayerGui = v491:FindFirstChild("PlayerGui")
			local Flash = PlayerGui and PlayerGui:FindFirstChild("Flash")
			local v496

			if not Flash then
				v556 = v492
				v557, v558, v559 = ipairs(v492:GetChildren())

				while true do
					v559, v496 = v557(v558, v559)

					if v559 == nil then
						break
					end

					if v496:IsA("ColorCorrectionEffect") and (v496.Name == "Flashed" or v496.Name == "Flash") then
						v496.Enabled = false
					end
				end

				return
			end

			local Frame3 = Flash:FindFirstChild("Frame")

			if not (Frame3 and Frame3.BackgroundTransparency < 1) then
				v556 = v492
				v557, v558, v559 = ipairs(v492:GetChildren())

				while true do
					v559, v496 = v557(v558, v559)

					if v559 == nil then
						break
					end

					if v496:IsA("ColorCorrectionEffect") and (v496.Name == "Flashed" or v496.Name == "Flash") then
						v496.Enabled = false
					end
				end

				return
			end

			Frame3.BackgroundTransparency = 1
			local v499, v500, v501 = ipairs(v492:GetChildren())

			while true do
				v501, v496 = v499(v500, v501)

				if v501 == nil then
					break
				end

				if v496:IsA("ColorCorrectionEffect") and (v496.Name == "Flashed" or v496.Name == "Flash") then
					v496.Enabled = false
				end
			end
		end

		local v502 = t10
		local v503 = t13
		local v504 = CurrentCamera

		createFrame3 = function()
			if not v502.Crosshair then
				for _, v in ipairs(t27) do
					v.Visible = false
				end

				return
			end

			local v507

			if #t27 ~= 0 then
				v571 = v504.ViewportSize.X / 2
				v572 = v504.ViewportSize.Y / 2
				t27[1].From = Vector2.new(v571 - 5 - 8, v572)
				t27[1].To = Vector2.new(v571 - 5, v572)
				t27[2].From = Vector2.new(v571 + 5, v572)
				t27[2].To = Vector2.new(v571 + 5 + 8, v572)
				t27[3].From = Vector2.new(v571, v572 - 5 - 8)
				t27[3].To = Vector2.new(v571, v572 - 5)
				t27[4].From = Vector2.new(v571, v572 + 5)
				t27[4].To = Vector2.new(v571, v572 + 5 + 8)
				v573, v574, v575 = ipairs(t27)

				while true do
					v575, v507 = v573(v574, v575)

					if v575 == nil then
						break
					end

					v507.Visible = true
				end

				return
			end

			for _ = 1, 4 do
				local Line = Drawing.new("Line")

				Line.Thickness = 1.5
				Line.Color = v503.accent
				Line.Visible = true

				table.insert(t27, Line)
			end

			local v511 = v504.ViewportSize.X / 2
			local v512 = v504.ViewportSize.Y / 2

			t27[1].From = Vector2.new(v511 - 5 - 8, v512)
			t27[1].To = Vector2.new(v511 - 5, v512)
			t27[2].From = Vector2.new(v511 + 5, v512)
			t27[2].To = Vector2.new(v511 + 5 + 8, v512)
			t27[3].From = Vector2.new(v511, v512 - 5 - 8)
			t27[3].To = Vector2.new(v511, v512 - 5)
			t27[4].From = Vector2.new(v511, v512 + 5)
			t27[4].To = Vector2.new(v511, v512 + 5 + 8)

			local v513, v514, v515 = ipairs(t27)

			while true do
				v515, v507 = v513(v514, v515)

				if v515 == nil then
					break
				end

				v507.Visible = true
			end
		end

		local v516 = t10
		local v517 = t13
		local v518 = CurrentCamera

		local function v519()
			if v516.FOVCircle then
				if Circle then
					Circle.Radius = v516.Aimbot_FOV
					Circle.Position = Vector2.new(v518.ViewportSize.X / 2, v518.ViewportSize.Y / 2)
					Circle.NumSides = 60
					Circle.Visible = true

					return
				end

				Circle = Drawing.new("Circle")
				Circle.Thickness = 1.5
				Circle.Color = v517.accent
				Circle.Filled = false
				Circle.Radius = v516.Aimbot_FOV
				Circle.Position = Vector2.new(v518.ViewportSize.X / 2, v518.ViewportSize.Y / 2)
				Circle.NumSides = 60
				Circle.Visible = true
			else
				if not Circle then
					return
				end

				Circle.Visible = false
			end
		end

		local CFrame_ = nil
		local u521 = false
		local v522 = t10
		local v524 = UserInputService
		local v525 = CurrentCamera

		local function v526()
			if not v522.NoRecoil then
				u521 = false

				return
			end

			if not v524:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				u521 = false
				CFrame_ = v525.CFrame

				return
			end

			if not u521 then
				CFrame_ = v525.CFrame
				u521 = true
			end

			if not CFrame_ then
				return
			end

			local mouseDelta = v524:GetMouseDelta()

			if mouseDelta.Magnitude <= 0 then
				v590 = v525.CFrame.Position
				v591 = CFrame.new(v590, v590 + CFrame_.LookVector)
				v592 = (v522.Recoil_Amount or 100) / 100
				v525.CFrame = v525.CFrame:Lerp(v591, v592)

				return
			end

			local v527 = -mouseDelta.Y * 0.25
			local v528 = math.rad(v527)
			local v529 = -mouseDelta.X * 0.25
			local v530 = math.rad(v529)

			CFrame_ = CFrame_ * CFrame.Angles(v528, v530, 0)

			local Position = v525.CFrame.Position
			local cFrame = CFrame.new(Position, Position + CFrame_.LookVector)
			local v533 = (v522.Recoil_Amount or 100) / 100

			v525.CFrame = v525.CFrame:Lerp(cFrame, v533)
		end

		createFrame = RunService.RenderStepped

		local v534 = Movement
		local v535 = Combat
		local v536 = createFrame3

		createFrame:Connect(function(p43)
			pcall(v534)
			pcall(v431)
			pcall(v535)
			pcall(v454)
			pcall(v474, p43)
			pcall(v493)
			pcall(v536)
			pcall(v519)
			pcall(v526)
		end)
		RunService.Heartbeat:Connect(function()
			pcall(v489)
		end)
		Movement = UserInputService.InputBegan

		local v537 = t10
		local v538 = ScreenGui

		Movement:Connect(function(p44, p45)
			if p45 then
				return
			end

			if p44.KeyCode ~= (v537.ToggleKey or Enum.KeyCode.RightShift) then
				return
			end

			v537.ShowGUI = not v537.ShowGUI
			v538.Enabled = v537.ShowGUI
		end)
		Movement = Players.PlayerRemoving

		local v539 = t12
		local v540 = t11
		local v541 = Visuals
		local v542 = createFrame2

		Movement:Connect(function(p46)
			local v543 = v539[p46]

			if v543 then
				v540[v543] = nil
				v539[p46] = nil
			end

			if not v541[p46] then
				return
			end

			v542(v541[p46])
			v541[p46] = nil
		end)
		Movement = LocalPlayer.CharacterAdded

		local v544 = t10

		Movement:Connect(function()
			v544.Aimlock_Target = nil
		end)

		local ScreenGui2 = Instance.new("ScreenGui")

		pcall_(ScreenGui2)

		local Frame3 = Instance.new("Frame")

		Frame3.Size = UDim2.new(0, 280, 0, 40)
		Frame3.Position = UDim2.new(0.5, -140, 0.85, 0)
		Frame3.BackgroundColor3 = t13.bg
		Frame3.BorderSizePixel = 0
		Frame3.Parent = ScreenGui2
		Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 6)
		Movement = Instance.new("UIStroke", Frame3)
		Movement.Color = t13.accent
		Movement.Thickness = 1
		Movement = Instance.new("Frame")
		Movement.Size = UDim2.new(0, 6, 0, 6)
		Movement.Position = UDim2.new(0, 12, 0.5, -3)
		Movement.BackgroundColor3 = t13.accent
		Movement.BorderSizePixel = 0
		Movement.Parent = Frame3
		Instance.new("UICorner", Movement).CornerRadius = UDim.new(1, 0)
		Movement = Instance.new("TextLabel")
		Movement.Size = UDim2.new(1, -30, 1, 0)
		Movement.Position = UDim2.new(0, 26, 0, 0)
		Movement.BackgroundTransparency = 1
		Movement.Text = "jacob helper v3.2 loaded • press toggle key to hide"
		Movement.TextColor3 = t13.text
		Movement.Font = Enum.Font.GothamSemibold
		Movement.TextSize = 12
		Movement.TextXAlignment = Enum.TextXAlignment.Left
		Movement.Parent = Frame3
		TweenService:Create(Frame3, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -140, 0.92, 0),
		}):Play()
		Movement = task.delay

		local v547 = TweenService

		Movement(4, function()
			v547:Create(Frame3, TweenInfo.new(0.4), {
				Position = UDim2.new(0.5, -140, 1, 0),
			}):Play()
			task.wait(0.5)
			ScreenGui2:Destroy()
		end)
		print("[Jacob Helper v3.2] Loaded | Discord: https://discord.gg/9mgCFuNK8n")
	end)
end
function lib.Callbacks.OnFail(p47)
	warn("[Jacob Helper] Validation Failed: " .. tostring(p47))
end
function lib.Callbacks.OnClose()
	warn("[Jacob Helper] User closed the verification window.")
end

lib:Launch()
