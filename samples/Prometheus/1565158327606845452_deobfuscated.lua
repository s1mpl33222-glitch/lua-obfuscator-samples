-- This file was generated at discord.gg/syncrypt

local s1 = "https://sparkhub.wtf/key"

if getgenv().SparkHubKeySystem then
	return
end

getgenv().SparkHubKeySystem = true
getgenv().UI_CLOSED = false

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local PlaceId = game.PlaceId

local function v7()
	local v8 = (identifyexecutor or (getexecutorname or function()
		return "Unknown"
	end))():lower()

	return (v8:find("xeno") or v8:find("solara")) and "xeno_solara" or "default"
end

local v9 = ({
	["142823291"] = "ab0a4b56eabc57c167e7ac114e4a7e46"
})[tostring(PlaceId)]

if not v9 then
	local v10 = (function()
		local v11 = tostring(game.PlaceId)

		if v11 == "11815767793" and true or v11 == "101993432229107" then
			return v7() == "xeno_solara" and "d40809af9c8a9656fe4de72793008c15" or "33ae7de816736908dbce2232d3f9f4b8"
		elseif v11 == "94217045453265" and true or v11 == "100484168444874" then
			if v7() == "xeno_solara" then
				game.Players.LocalPlayer:Kick("unsupported executor")

				return nil
			else
				return "0f1e1ed816bba3a52ed4b62fae059a96"
			end
		else
			return (v11 == "10449761463" or (v11 == "12360882630" or v11 == "13635175275")) and "4f3ce5ad68f12541980ad94d636140e1" or ((v11 == "606849621" or (v11 == "17190407811" or (v11 == "17190408132" or (v11 == "108098425719662" and true or v11 == "9780994092")))) and "929e5fcc132d987d208489e1ecd54c8b" or nil)
		end
	end)()

	if not v10 then
		local warn_ = warn
		local PlaceId2 = game.PlaceId

		warn_("[Spark Hub] Unsupported game (PlaceId: " .. tostring(PlaceId2) .. ")")
		getgenv().SparkHubKeySystem = nil

		return
	end

	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
	end)

	if ok then
		ok = type(result) == "table"
	end

	if not ok then
		warn("[Spark Hub] Failed to load Luarmor API: " .. tostring(result))
		result = nil
	end

	local function v16(p1, p2)
		if not result then
			return false, "Luarmor API failed to load"
		end

		result.script_id = p2

		local ok2, result2 = pcall(function()
			return result.check_key(p1)
		end)

		if not ok2 then
			return false, "API request failed: " .. tostring(result2)
		end

		if type(result2) ~= "table" then
			return false, "Invalid API response"
		end

		if result2.code == "KEY_VALID" then
			return true, "Key valid"
		end

		if result2.code == "KEY_EXPIRED" then
			return false, "Key has expired!"
		end

		if result2.code == "KEY_BANNED" then
			return false, "Key is blacklisted!"
		end

		if result2.code == "KEY_HWID_LOCKED" then
			return false, "HWID mismatch! Reset key."
		end

		if result2.code == "KEY_INCORRECT" then
			return false, "Key is incorrect or deleted!"
		end

		if result2.code == "KEY_INVALID" then
			return false, "Invalid key format!"
		end

		if result2.code == "INVALID_EXECUTOR" then
			return false, "Executor not supported!"
		end

		if result2.code == "SECURITY_ERROR" then
			return false, "Security validation failed!"
		end

		if result2.code == "TIME_ERROR" then
			return false, "Client time error!"
		end

		local v19 = false
		local message = result2.message

		if message then
			return v19, message
		end

		local code = result2.code

		message = "Check failed: " .. tostring(code)

		return v19, message
	end

	local ok2 = pcall(function()
		local writefile_ = writefile

		return type(writefile_) == "function"
	end)

	local function v24(p3)
		if not ok2 then
			return
		end

		pcall(function()
			writefile("sparkhub_key.txt", p3)
		end)
	end
	local function v25()
		pcall(function()
			local delfile_ = delfile

			if type(delfile_) ~= "function" then
				return
			end

			delfile("sparkhub_key.txt")
		end)
	end

	local v27 = (function()
		if not ok2 then
			return nil
		end

		local ok3, result2 = pcall(function()
			local txt = readfile("sparkhub_key.txt")

			if not txt or txt == "" then
				return nil
			else
				return txt
			end
		end)

		return ok3 and result2 and result2 or nil
	end)()
	local v31

	if v27 then
		v31 = v27 ~= ""
	else
		v31 = v27
	end

	if v31 then
		local v32 = v16(v27, v10)

		if v32 then
			getgenv().script_key = v27
			loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. v10 .. ".lua"))()
			getgenv().SparkHubKeySystem = nil

			return
		end

		v25()
	end

	local TouchEnabled = UserInputService.TouchEnabled

	if TouchEnabled then
		TouchEnabled = not UserInputService.KeyboardEnabled
	end

	local ViewportSize = workspace.CurrentCamera.ViewportSize
	local v36 = ViewportSize.X > ViewportSize.Y
	local v37 = not TouchEnabled or v36
	local t1 = {
		Background = Color3.fromRGB(4, 4, 4),
		Surface = Color3.fromRGB(10, 10, 10),
		SurfaceAlt = Color3.fromRGB(17, 17, 17),
		Border = Color3.fromRGB(255, 255, 255),
		BorderDim = Color3.fromRGB(48, 48, 48),
		BorderFaint = Color3.fromRGB(22, 22, 22),
		Input = Color3.fromRGB(8, 8, 8),
		ButtonPrimary = Color3.fromRGB(255, 255, 255),
		ButtonSecondary = Color3.fromRGB(13, 13, 13),
		HoverPrimary = Color3.fromRGB(210, 210, 210),
		HoverSecondary = Color3.fromRGB(26, 26, 26),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(118, 118, 118),
		TextMuted = Color3.fromRGB(55, 55, 55),
		Star = Color3.fromRGB(255, 255, 255),
		Error = Color3.fromRGB(190, 62, 62),
		Success = Color3.fromRGB(82, 182, 92),
		Discord = Color3.fromRGB(88, 101, 242),
		DiscordHover = Color3.fromRGB(71, 82, 214)
	}
	local t2

	if TouchEnabled and v36 then
		local v40 = ViewportSize.X * 0.87
		local v41 = math.min(510, v40)
		local v42 = ViewportSize.Y * 0.76

		t2 = {
			MainWidth = v41,
			MainHeight = math.min(228, v42),
			TitleBarHeight = 42,
			ButtonHeight = 33,
			InputHeight = 35,
			FontSizeTitle = 15,
			FontSizeButton = 12,
			FontSizeInput = 12,
			FontSizeStatus = 10,
			FontSizeInfo = 10,
			Padding = 11,
			PanelSplit = 0.55
		}
	elseif TouchEnabled then
		local v43 = ViewportSize.X * 0.93

		t2 = {
			MainWidth = math.min(365, v43),
			MainHeight = 275,
			TitleBarHeight = 44,
			ButtonHeight = 36,
			InputHeight = 38,
			FontSizeTitle = 17,
			FontSizeButton = 13,
			FontSizeInput = 13,
			FontSizeStatus = 11,
			FontSizeInfo = 11,
			Padding = 14,
			PanelSplit = 1
		}
	else
		t2 = {
			MainWidth = 560,
			MainHeight = 290,
			TitleBarHeight = 46,
			ButtonHeight = 36,
			InputHeight = 40,
			FontSizeTitle = 20,
			FontSizeButton = 13,
			FontSizeInput = 13,
			FontSizeStatus = 11,
			FontSizeInfo = 11,
			Padding = 18,
			PanelSplit = 0.57
		}
	end

	local function v44(p4, p5)
		local instance = Instance.new(p4)
		local v46, v47, v48 = pairs(p5)

		while true do
			local v49

			v48, v49 = v46(v47, v48)

			if not v48 then
				break
			end

			if v48 ~= "Parent" then
				instance[v48] = v49
			end
		end

		if not p5.Parent then
			return instance
		end

		instance.Parent = p5.Parent

		return instance
	end

	local ScreenGui = v44("ScreenGui", {
		Name = "SparkHubKeySystem",
		Parent = CoreGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999,
		IgnoreGuiInset = true
	})
	local Frame = v44("Frame", {
		Name = "MainFrame",
		Parent = ScreenGui,
		BackgroundColor3 = t1.Background,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, t2.MainWidth, 0, t2.MainHeight),
		ClipsDescendants = true,
		ZIndex = 10
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = Frame
	})

	local UIGradient = v44("UIGradient", {
		Parent = v44("UIStroke", {
			Parent = Frame,
			Color = t1.Border,
			Thickness = 1.2,
			Transparency = 0.45
		}),
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 75)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) }),
		Rotation = 0
	})

	task.spawn(function()
		while true do
			local Parent = Frame

			if Parent then
				Parent = Frame.Parent
			end

			if not Parent then
				return
			end

			for i = 0, 360, 2 do
				if not (Frame and Frame.Parent) then
					break
				end

				UIGradient.Rotation = i
				task.wait(0.05)
			end
		end
	end)

	local Frame2 = v44("Frame", {
		Parent = Frame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = true,
		ZIndex = 11
	})
	local t3 = {}

	local function v57(p6, p7, p8, p9, p10)
		local tween = TweenService:Create(p6, TweenInfo.new(p7, p9 or Enum.EasingStyle.Quint, p10 or Enum.EasingDirection.Out), p8)

		tween:Play()

		return tween
	end

	for _ = 1, TouchEnabled and 28 or 46 do
		local v60 = math.random(1, 2)
		local Frame3 = v44("Frame", {
			Parent = Frame2,
			BackgroundColor3 = t1.Star,
			Size = UDim2.new(0, v60, 0, v60),
			Position = UDim2.new(math.random(), 0, math.random(), 0),
			BorderSizePixel = 0,
			ZIndex = 11,
			BackgroundTransparency = math.random() * 0.3 + 0.5
		})

		v44("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Frame3
		})
		table.insert(t3, {
			frame = Frame3,
			speed = math.random(2, 6) / 15000,
			base = math.random() * 0.25 + 0.5
		})
	end

	task.spawn(function()
		while true do
			local Parent = ScreenGui

			if Parent then
				Parent = ScreenGui.Parent
			end

			if not Parent then
				return
			end

			for _, v in ipairs(t3) do
				local frame = v.frame

				if frame then
					frame = v.frame.Parent
				end

				if frame then
					local v66 = v.frame.Position.Y.Scale + v.speed

					if v66 > 1.05 then
						v.frame.Position = UDim2.new(math.random(), 0, -0.05, 0)
					else
						v.frame.Position = UDim2.new(v.frame.Position.X.Scale, 0, v66, 0)
					end

					local frame2 = v.frame
					local base = v.base
					local v69 = tick() * 0.6

					frame2.BackgroundTransparency = base + math.sin(v69) * 0.12
				end
			end

			RunService.Heartbeat:Wait()
		end
	end)
	task.spawn(function()
		while true do
			local Parent = ScreenGui

			if Parent then
				Parent = ScreenGui.Parent
			end

			if not Parent then
				return
			end

			task.wait(math.random(6, 14))

			local Frame3 = v44("Frame", {
				Parent = Frame2,
				BackgroundColor3 = t1.Star,
				Size = UDim2.new(0, 30, 0, 2),
				Position = UDim2.new(1.1, 0, math.random() * 0.4, 0),
				Rotation = 25,
				BorderSizePixel = 0,
				ZIndex = 11
			})

			v44("UIGradient", {
				Parent = Frame3,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1) })
			})
			v57(Frame3, 1, {
				Position = UDim2.new(-0.2, 0, Frame3.Position.Y.Scale + 0.22, 0)
			}, Enum.EasingStyle.Linear)
			task.delay(1, function()
				local Parent2 = Frame3

				if Parent2 then
					Parent2 = Frame3.Parent
				end

				if not Parent2 then
					return
				end

				Frame3:Destroy()
			end)
		end
	end)

	local Frame3 = v44("Frame", {
		Name = "TitleBar",
		Parent = Frame,
		BackgroundColor3 = t1.Surface,
		Size = UDim2.new(1, 0, 0, t2.TitleBarHeight),
		BorderSizePixel = 0,
		ZIndex = 15
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = Frame3
	})
	v44("Frame", {
		Parent = Frame3,
		BackgroundColor3 = t1.Surface,
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 1, -12),
		BorderSizePixel = 0,
		ZIndex = 15
	})
	v44("Frame", {
		Parent = Frame3,
		BackgroundColor3 = t1.BorderFaint,
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		ZIndex = 16
	})

	local Frame4 = v44("Frame", {
		Parent = Frame3,
		BackgroundColor3 = t1.Background,
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 30, 0, 30),
		ZIndex = 16
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = Frame4
	})
	v44("UIStroke", {
		Parent = Frame4,
		Color = t1.BorderDim,
		Thickness = 1
	})
	v44("ImageLabel", {
		Parent = Frame4,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0.85, 0, 0.85, 0),
		Image = "rbxassetid://83027430816737",
		ZIndex = 17
	})
	v44("TextLabel", {
		Parent = Frame3,
		BackgroundTransparency = 1,
		Text = "Spark Hub",
		Position = UDim2.new(0, 50, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 140, 0, 24),
		Font = Enum.Font.GothamBlack,
		TextColor3 = t1.TextPrimary,
		TextSize = t2.FontSizeTitle,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16
	})

	local Frame5 = v44("Frame", {
		Parent = Frame3,
		BackgroundColor3 = t1.SurfaceAlt,
		Position = UDim2.new(1, -44, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 82, 0, 18),
		ZIndex = 16
	})

	v44("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame5
	})
	v44("UIStroke", {
		Parent = Frame5,
		Color = t1.BorderDim,
		Thickness = 1,
		Transparency = 0.4
	})
	v44("TextLabel", {
		Parent = Frame5,
		BackgroundTransparency = 1,
		Text = "KEY SYSTEM",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		TextColor3 = t1.TextMuted,
		TextSize = 8,
		ZIndex = 17
	})

	local TextButton = v44("TextButton", {
		Parent = Frame3,
		BackgroundColor3 = t1.SurfaceAlt,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 26, 0, 26),
		Text = "X",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = t1.TextMuted,
		AutoButtonColor = false,
		ZIndex = 18
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = TextButton
	})
	TextButton.MouseEnter:Connect(function()
		v57(TextButton, 0.12, {
			BackgroundTransparency = 0,
			TextColor3 = t1.TextPrimary
		})
	end)
	TextButton.MouseLeave:Connect(function()
		v57(TextButton, 0.12, {
			BackgroundTransparency = 1,
			TextColor3 = t1.TextMuted
		})
	end)

	local function v77()
		getgenv().UI_CLOSED = true
		v57(Frame, 0.3, {
			Size = UDim2.new(0, t2.MainWidth, 0, 0),
			BackgroundTransparency = 1
		}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.wait(0.35)
		ScreenGui:Destroy()
		getgenv().SparkHubKeySystem = nil
	end

	TextButton.MouseButton1Click:Connect(v77)

	local Frame6 = v44("Frame", {
		Parent = Frame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, t2.TitleBarHeight),
		Size = UDim2.new(1, 0, 1, -t2.TitleBarHeight),
		ZIndex = 15
	})
	local PanelSplit

	if v37 then
		PanelSplit = t2.PanelSplit
	else
		PanelSplit = v37
	end

	local v80 = PanelSplit or 1
	local Frame7 = v44("Frame", {
		Parent = Frame6,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(v80, 0, 1, 0),
		ZIndex = 15
	})
	local Padding = t2.Padding

	v44("TextLabel", {
		Parent = Frame7,
		BackgroundTransparency = 1,
		Text = "ENTER YOUR KEY",
		Position = UDim2.new(0, Padding, 0, 14),
		Size = UDim2.new(1, -Padding * 2, 0, 14),
		Font = Enum.Font.GothamBold,
		TextColor3 = t1.TextMuted,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16
	})

	local n1 = 35
	local Frame8 = v44("Frame", {
		Parent = Frame7,
		BackgroundColor3 = t1.Input,
		Position = UDim2.new(0, Padding, 0, n1),
		Size = UDim2.new(1, -Padding * 2, 0, t2.InputHeight),
		ZIndex = 16
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 7),
		Parent = Frame8
	})

	local UIStroke = v44("UIStroke", {
		Parent = Frame8,
		Color = t1.BorderDim,
		Thickness = 1,
		Transparency = 0.2
	})
	local TextBox = v44("TextBox", {
		Parent = Frame8,
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Paste your key here...",
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Font = Enum.Font.Gotham,
		TextSize = t2.FontSizeInput,
		TextColor3 = t1.TextPrimary,
		PlaceholderColor3 = t1.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 17
	})
	local v87 = n1 + t2.InputHeight + 10

	local function v88(p11, p12, p13)
		local v89 = v44
		local v90 = Frame7
		local ButtonPrimary

		if p13 then
			ButtonPrimary = t1.ButtonPrimary
		else
			ButtonPrimary = p13
		end

		local ButtonSecondary = ButtonPrimary or t1.ButtonSecondary
		local uDim2 = UDim2.new(0.5, -(Padding + 4), 0, t2.ButtonHeight)
		local GothamBold = Enum.Font.GothamBold
		local FontSizeButton = t2.FontSizeButton
		local Background

		if p13 then
			Background = t1.Background
		else
			Background = p13
		end

		local TextButton2 = v89("TextButton", {
			Name = p11,
			Parent = v90,
			BackgroundColor3 = ButtonSecondary,
			Size = uDim2,
			Text = p12,
			Font = GothamBold,
			TextSize = FontSizeButton,
			TextColor3 = Background or t1.TextPrimary,
			AutoButtonColor = false,
			ZIndex = 17
		})

		v44("UICorner", {
			CornerRadius = UDim.new(0, 7),
			Parent = TextButton2
		})

		if not p13 then
			v44("UIStroke", {
				Parent = TextButton2,
				Color = t1.BorderDim,
				Thickness = 1,
				Transparency = 0.3
			})
		end

		TextButton2.MouseEnter:Connect(function()
			local v98 = v57
			local n2 = 0.12
			local v100 = TextButton2
			local HoverPrimary = p13

			if not HoverPrimary then
				v98(v100, n2, {
					BackgroundColor3 = HoverPrimary or t1.HoverSecondary
				})

				return
			end

			HoverPrimary = t1.HoverPrimary
			v98(v100, n2, {
				BackgroundColor3 = HoverPrimary or t1.HoverSecondary
			})
		end)
		TextButton2.MouseLeave:Connect(function()
			local v102 = v57
			local v103 = TextButton2
			local ButtonPrimary2 = p13

			if not ButtonPrimary2 then
				v102(v103, 0.12, {
					BackgroundColor3 = ButtonPrimary2 or t1.ButtonSecondary
				})

				return
			end

			ButtonPrimary2 = t1.ButtonPrimary
			v102(v103, 0.12, {
				BackgroundColor3 = ButtonPrimary2 or t1.ButtonSecondary
			})
		end)

		return TextButton2
	end

	local VerifyButton = v88("VerifyButton", "VERIFY KEY", true)

	VerifyButton.Position = UDim2.new(0, Padding, 0, v87)

	local GetKeyButton = v88("GetKeyButton", "GET KEY", false)

	GetKeyButton.Position = UDim2.new(0.5, 4, 0, v87)

	local v107 = v87 + t2.ButtonHeight + 10
	local TextButton2 = v44("TextButton", {
		Parent = Frame7,
		BackgroundColor3 = t1.Discord,
		Position = UDim2.new(0, Padding, 0, v107),
		Size = UDim2.new(1, -Padding * 2, 0, t2.ButtonHeight),
		Text = "Join Discord",
		Font = Enum.Font.GothamBold,
		TextSize = t2.FontSizeButton,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
		ZIndex = 17
	})

	v44("UICorner", {
		CornerRadius = UDim.new(0, 7),
		Parent = TextButton2
	})
	TextButton2.MouseEnter:Connect(function()
		v57(TextButton2, 0.12, {
			BackgroundColor3 = t1.DiscordHover
		})
	end)
	TextButton2.MouseLeave:Connect(function()
		v57(TextButton2, 0.12, {
			BackgroundColor3 = t1.Discord
		})
	end)

	local TextLabel = v44("TextLabel", {
		Parent = Frame7,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, Padding, 1, -24),
		Size = UDim2.new(1, -Padding * 2, 0, 18),
		Font = Enum.Font.GothamMedium,
		Text = "",
		TextColor3 = t1.TextSecondary,
		TextSize = t2.FontSizeStatus,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		TextTransparency = 1
	})

	if v37 then
		v44("Frame", {
			Parent = Frame6,
			BackgroundColor3 = t1.BorderFaint,
			Position = UDim2.new(v80, 0, 0, 12),
			Size = UDim2.new(0, 1, 1, -24),
			ZIndex = 16,
			BorderSizePixel = 0
		})

		local Frame9 = v44("Frame", {
			Parent = Frame6,
			BackgroundTransparency = 1,
			Position = UDim2.new(v80, 1, 0, 0),
			Size = UDim2.new(1 - v80, -1, 1, 0),
			ZIndex = 15
		})

		v44("TextLabel", {
			Parent = Frame9,
			BackgroundTransparency = 1,
			Text = "How long does the",
			Position = UDim2.new(0, 16, 0, 18),
			Size = UDim2.new(1, -16, 0, 16),
			Font = Enum.Font.GothamBold,
			TextColor3 = t1.TextSecondary,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 17
		})
		v44("TextLabel", {
			Parent = Frame9,
			BackgroundTransparency = 1,
			Text = "key system take?",
			Position = UDim2.new(0, 16, 0, 34),
			Size = UDim2.new(1, -16, 0, 16),
			Font = Enum.Font.GothamBold,
			TextColor3 = t1.TextSecondary,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 17
		})
		v44("TextLabel", {
			Parent = Frame9,
			BackgroundTransparency = 1,
			Text = "Less than 2 mins.",
			Position = UDim2.new(0, 16, 0, 56),
			Size = UDim2.new(1, -16, 0, 26),
			Font = Enum.Font.GothamBlack,
			TextColor3 = t1.TextPrimary,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 17
		})
		v44("Frame", {
			Parent = Frame9,
			BackgroundColor3 = t1.BorderFaint,
			Position = UDim2.new(0, 0, 1, -56),
			Size = UDim2.new(1, -16, 0, 1),
			ZIndex = 16,
			BorderSizePixel = 0
		})
		v44("TextLabel", {
			Parent = Frame9,
			BackgroundTransparency = 1,
			Text = "Need help?",
			Position = UDim2.new(0, 16, 1, -50),
			Size = UDim2.new(1, -16, 0, 16),
			Font = Enum.Font.GothamBold,
			TextColor3 = t1.TextPrimary,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 17
		})
		v44("TextLabel", {
			Parent = Frame9,
			BackgroundTransparency = 1,
			Text = "Join our Discord server.",
			Position = UDim2.new(0, 16, 1, -34),
			Size = UDim2.new(1, -16, 0, 14),
			Font = Enum.Font.Gotham,
			TextColor3 = t1.TextSecondary,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 17
		})
	end

	local function v111(p14, p15, p16)
		TextLabel.Text = p14

		local v112 = TextLabel

		if p15 then
			p15 = t1.Error
		end

		v112.TextColor3 = p15 or t1.TextPrimary
		v57(TextLabel, 0.2, {
			TextTransparency = 0
		})

		if p16 then
			return
		end

		task.spawn(function()
			task.wait(4)

			if TextLabel.Text ~= p14 then
				return
			end

			v57(TextLabel, 0.35, {
				TextTransparency = 1
			})
		end)
	end

	GetKeyButton.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(s1)
			v111("Get Key link copied to clipboard!", false)
		else
			v111(s1, false, true)
		end
	end)
	VerifyButton.MouseButton1Click:Connect(function()
		local scriptKey = TextBox.Text:gsub("%s+", "")

		if scriptKey == "" then
			v111("Please enter a key!", true)

			local Position = Frame8.Position

			for _ = 1, 3 do
				v57(Frame8, 0.04, {
					Position = Position + UDim2.new(0, 4, 0, 0)
				}, Enum.EasingStyle.Linear)
				task.wait(0.04)
				v57(Frame8, 0.04, {
					Position = Position - UDim2.new(0, 4, 0, 0)
				}, Enum.EasingStyle.Linear)
				task.wait(0.04)
			end

			v57(Frame8, 0.04, {
				Position = Position
			}, Enum.EasingStyle.Linear)
		else
			v111("Verifying...", false, true)

			local v116, v117 = v16(scriptKey, v10)

			if v116 then
				v24(scriptKey)
				v111("Key verified!", false, true)
				v57(UIStroke, 0.25, {
					Color = t1.Success,
					Thickness = 2
				})
				task.wait(1)
				v77()
				getgenv().script_key = scriptKey
				loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. v10 .. ".lua"))()

				return
			else
				v111(v117, true)
				v57(UIStroke, 0.25, {
					Color = t1.Error
				})
				task.wait(0.8)
				v57(UIStroke, 0.25, {
					Color = t1.BorderDim
				})

				return
			end
		end
	end)
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end

		VerifyButton.MouseButton1Click:Fire()
	end)
	TextBox.Focused:Connect(function()
		v57(UIStroke, 0.18, {
			Color = t1.Border,
			Transparency = 0,
			Thickness = 1.5
		})
	end)
	TextButton2.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard("https://discord.gg/ABwF3VcNyC")
			v111("Discord invite copied!", false)
		else
			v111("discord.gg/ABwF3VcNyC", false, true)
		end
	end)

	local u118 = nil
	local Position = nil
	local Position2 = nil

	local function v121(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u118 = true
		Position = input.Position
		Position2 = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u118 = false
		end)
	end

	Frame3.InputBegan:Connect(v121)

	local function v122(input)
		local v123 = u118

		if v123 then
			v123 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v123 then
			return
		end

		local v124 = input.Position - Position

		Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v124.X, Position2.Y.Scale, Position2.Y.Offset + v124.Y)
	end

	UserInputService.InputChanged:Connect(v122)
	Frame.Size = UDim2.new(0, t2.MainWidth, 0, 0)
	Frame.BackgroundTransparency = 1
	v57(Frame, 0.45, {
		Size = UDim2.new(0, t2.MainWidth, 0, t2.MainHeight),
		BackgroundTransparency = 0
	}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	return
end

local ok, result = pcall(function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. v9 .. ".lua"))()
end)

if ok then
	getgenv().SparkHubKeySystem = nil

	return
end

warn("[Spark Hub] Keyless loader failed: " .. tostring(result))
getgenv().SparkHubKeySystem = nil
