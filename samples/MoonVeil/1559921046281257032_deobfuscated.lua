-- This file was generated at discord.gg/syncrypt

local _type = type
local _getmetatable = getmetatable
local _pairs = pairs
local bxor = bit32.bxor

local u6 = getfenv()
local _ = string.char
local _ = string.byte
local _ = bit32.bxor
local _select = select

local function u11(...)
	return {
		{ ... },
		(_select("#", ...)),
	}
end

local u12 = (function()
	local function Hda(p1, p2, p3)
		if p3 < p2 then
			return
		end

		return p1[p2], Hda(p1, p2 + 1, p3)
	end

	return Hda
end)()
local _ = string.gsub
local _ = string.char

return (function(...)
	local v27 = u6.game.GetService(u6.game, "Players")
	local v28 = u6.game.GetService(u6.game, "RunService")
	local v29 = u6.game.GetService(u6.game, "StarterGui")
	local v30 = u6.game.GetService(u6.game, "TweenService")
	local v31 = u6.game.GetService(u6.game, "UserInputService")
	local LocalPlayer = v27.LocalPlayer

	for _, v34 in u6.ipairs(LocalPlayer.PlayerGui.GetChildren(LocalPlayer.PlayerGui)) do
		local t4_1, t4_2

		if v34.Name == "SecretService" then
			t4_1 = "\026>\140*)\144'"
			t4_2 = "^[\255"
			t4_1 = "Destroy"
			t4_1 = v34:Destroy()
		end
	end

	local v37 = u6.Instance.new("ScreenGui")

	v37.Name = "SecretService"
	v37.ResetOnSpawn = false
	v37.Parent = LocalPlayer.PlayerGui

	local v38 = u6.Instance.new("Frame")

	v38.Size = u6.UDim2.fromOffset(400, 200)
	v38.Position = u6.UDim2.fromScale(0.5, 0.5)
	v38.AnchorPoint = u6.Vector2.new(0.5, 0.5)
	v38.BackgroundColor3 = u6.Color3.fromRGB(14, 14, 18)
	v38.BorderColor3 = u6.Color3.fromRGB(80, 80, 120)
	v38.BorderSizePixel = 2
	v38.Parent = v37

	local v39 = u6.Instance.new("TextLabel")

	v39.Text = "Welcome, " .. LocalPlayer.Name .. "!"
	v39.Size = u6.UDim2.new(1, 0, 1, 0)
	v39.BackgroundTransparency = 1
	v39.TextColor3 = u6.Color3.fromRGB(235, 235, 235)
	v39.Font = u6.Enum.Font.GothamBold
	v39.TextSize = 24
	v39.Parent = v38
	u6.task.wait(2)
	v30:Create(v38, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
		["BackgroundTransparency"] = 1,
	}).Play(v30:Create(v38, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
		["BackgroundTransparency"] = 1,
	}))
	v30:Create(v39, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
		TextTransparency = 1,
	}).Play(v30:Create(v39, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
		TextTransparency = 1,
	}))
	u6.task.wait(0.5)
	v38:Destroy()

	local v40 = u6.Instance.new("Frame")

	v40.Size = u6.UDim2.fromOffset(500, 250)
	v40.Position = u6.UDim2.fromScale(0.5, 0.5)
	v40.AnchorPoint = u6.Vector2.new(0.5, 0.5)
	v40.BackgroundColor3 = u6.Color3.fromRGB(30, 30, 40)
	v40.BorderColor3 = u6.Color3.fromRGB(100, 100, 150)
	v40.BorderSizePixel = 2
	v40.Parent = v37

	local v41 = u6.Instance.new("TextLabel")

	v41.Text = "⚠ Important! ⚠\n\nMake sure your prefix is set to ';'.\nClick the HD Icon at the top left,\nthen go to Settings and change Prefix to ';'."
	v41.Size = u6.UDim2.new(1, -20, 1, -60)
	v41.Position = u6.UDim2.fromOffset(10, 10)
	v41.BackgroundTransparency = 1
	v41.TextColor3 = u6.Color3.fromRGB(235, 235, 235)
	v41.Font = u6.Enum.Font.GothamBold
	v41.TextSize = 18
	v41.TextWrapped = true
	v41.TextYAlignment = u6.Enum.TextYAlignment.Top
	v41.Parent = v40

	local v42 = u6.Instance.new("TextButton")

	v42.Text = "CONTINUE"
	local t6_4 = u6.UDim2
	t6_4 = t6_4.fromOffset
	v42.Size = t6_4(140, 40)
	t6_4 = u6.UDim2
	t6_4 = t6_4.new
	v42.Position = t6_4(0.5, -70, 1, -50)
	t6_4 = u6.Color3
	t6_4 = t6_4.fromRGB
	v42.BackgroundColor3 = t6_4(60, 90, 150)
	t6_4 = u6.Color3
	t6_4 = t6_4.fromRGB
	v42.TextColor3 = t6_4(255, 255, 255)
	t6_4 = u6.Enum
	t6_4 = t6_4.Font
	t6_4 = t6_4.GothamBold
	v42.Font = t6_4
	v42.TextSize = 18
	v42.Parent = v40
	t6_4 = v42.MouseButton1Click
	t6_4 = t6_4.Connect
	local t6_1 = v42.MouseButton1Click
	t6_4(t6_1, function()
		return (function()
			v30.Create(v30, v40, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				BackgroundTransparency = 1,
			}).Play(v30:Create(v40, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				BackgroundTransparency = 1,
			}))
			v30.Create(v30, v41, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				["TextTransparency"] = 1,
			}).Play(v30:Create(v41, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				["TextTransparency"] = 1,
			}))
			v30.Create(v30, v42, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				TextTransparency = 1,
			}).Play(v30:Create(v42, u6.TweenInfo.new(0.5, u6.Enum.EasingStyle.Quart), {
				TextTransparency = 1,
			}))
			u6.task.wait(0.5)
			v40:Destroy()

			local v69 = u6.Instance.new("Frame")

			v69.Size = u6.UDim2.fromOffset(650, 370)
			v69.Position = u6.UDim2.fromScale(0.5, 0.5)
			v69.AnchorPoint = u6.Vector2.new(0.5, 0.5)
			v69.BackgroundColor3 = u6.Color3.fromRGB(14, 14, 18)
			v69.BorderColor3 = u6.Color3.fromRGB(80, 80, 120)
			v69.Parent = v37

			local u70 = nil
			local u71 = nil
			local u72 = nil

			v69.InputBegan.Connect(v69.InputBegan, function(p8)
				local t10_1 = {
					[11878] = true,
				}

				return (function(p9)
					local t12_1
					local t12_3 = function(p10)
						return p9[p10 + -3858]
					end

					if p8.UserInputType == u6.Enum.UserInputType.MouseButton1 then
						u70 = t12_3(15736)
						t12_1 = p8.Position
						u71 = t12_1
						t12_1 = v69.Position
						u72 = t12_1
					end
				end)(t10_1)
			end)
			v31.InputEnded.Connect(v31.InputEnded, function(p11)
				local t14_1 = {
					[28899] = false,
				}

				return (function(p12)
					local t16_3 = function(p13)
						return p12[p13 + -2395]
					end

					if p11.UserInputType == u6.Enum.UserInputType.MouseButton1 then
						u70 = t16_3(31294)
					end
				end)(t14_1)
			end)
			v31.InputChanged.Connect(v31.InputChanged, function(p14)
				local t18_1, t18_2, t18_4, t18_5, t18_6, t18_7, t18_8

				if u70 and p14.UserInputType == u6.Enum.UserInputType.MouseMovement then
					t18_7 = p14.Position
					t18_7 = t18_7 - u71
					t18_8 = t18_7
					t18_7 = u6.UDim2
					t18_7 = t18_7.new
					t18_4 = u72.X
					t18_4 = t18_4.Scale
					t18_2 = u72.X
					t18_2 = t18_2.Offset
					t18_6 = t18_8.X
					t18_2 = t18_2 + t18_6
					t18_6 = u72.Y
					t18_6 = t18_6.Scale
					t18_5 = u72.Y
					t18_5 = t18_5.Offset
					t18_1 = t18_8.Y
					t18_5 = t18_5 + t18_1
					v69.Position = t18_7(t18_4, t18_2, t18_6, t18_5)
				end
			end)

			local v73 = u6.Instance.new("Frame")

			v73.Size = u6.UDim2.new(1, 0, 0, 40)
			v73.BackgroundColor3 = u6.Color3.fromRGB(18, 18, 24)
			v73.BorderSizePixel = 0
			v73.Parent = v69

			local v74 = u6.Instance.new("TextLabel")

			v74.Text = "[FREE ADMIN] Secret Service"
			v74.Size = u6.UDim2.new(0, 200, 0, 30)
			v74.Position = u6.UDim2.fromOffset(10, 5)
			v74.BackgroundTransparency = 1
			v74.TextColor3 = u6.Color3.fromRGB(235, 235, 235)
			v74.Font = u6.Enum.Font.GothamBold
			v74.TextSize = 18
			v74.TextXAlignment = u6.Enum.TextXAlignment.Left
			v74.Parent = v73

			local v75 = u6.Instance.new("TextLabel")

			v75.Text = "FPS: 60 | Ping: 0ms"
			v75.Size = u6.UDim2.new(0, 150, 0, 30)
			v75.Position = u6.UDim2.new(0.5, -75, 0, 5)
			v75.BackgroundTransparency = 1
			v75.TextColor3 = u6.Color3.fromRGB(150, 220, 150)
			v75.Font = u6.Enum.Font.Code
			v75.TextSize = 14
			v75.Parent = v73

			local u76 = u6.tick()
			local n1 = 60

			v28.RenderStepped.Connect(v28.RenderStepped, function()
				return (function()
					local v158 = u6.tick()

					n1 = u6.math.floor(1 / (v158 - u76))
					u76 = v158

					local v159 = u6.math.floor(LocalPlayer:GetNetworkPing() * 1000)

					v75.Text = u6.string.format("FPS: %d | Ping: %dms", n1, v159)
				end)()
			end)

			local v78 = u6.Instance.new("ImageLabel")

			v78.Size = u6.UDim2.fromOffset(30, 30)
			v78.Position = u6.UDim2.fromOffset(470, 5)
			v78.BackgroundColor3 = u6.Color3.fromRGB(40, 40, 50)
			v78.BorderSizePixel = 0
			v78.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
			v78.Parent = v73

			local v79 = u6.Instance.new("UICorner")

			v79.CornerRadius = u6.UDim.new(1, 0)
			v79.Parent = v78

			local v80 = u6.Instance.new("TextLabel")

			v80.Text = LocalPlayer.Name
			v80.Size = u6.UDim2.new(0, 100, 1, 0)
			v80.Position = u6.UDim2.fromOffset(505, 0)
			v80.BackgroundTransparency = 1
			v80.TextColor3 = u6.Color3.fromRGB(235, 235, 235)
			v80.Font = u6.Enum.Font.GothamBold
			v80.TextSize = 14
			v80.TextXAlignment = u6.Enum.TextXAlignment.Left
			v80.Parent = v73

			local v81 = u6.Instance.new("TextButton")

			v81.Text = "X"
			v81.Size = u6.UDim2.fromOffset(30, 30)
			v81.Position = u6.UDim2.fromOffset(610, 5)
			v81.BackgroundColor3 = u6.Color3.fromRGB(150, 50, 50)
			v81.TextColor3 = u6.Color3.new(1, 1, 1)
			v81.Font = u6.Enum.Font.GothamBold
			v81.TextSize = 16
			v81.Parent = v73
			v81.MouseButton1Click.Connect(v81.MouseButton1Click, function()
				v37:Destroy()
			end)

			local v82 = u6.Instance.new("Frame")

			v82.Size = u6.UDim2.new(1, -10, 1, -50)
			v82.Position = u6.UDim2.fromOffset(5, 45)
			v82.BackgroundTransparency = 1
			v82.Parent = v69

			local v83 = u6.Instance.new("ScrollingFrame")

			v83.Size = u6.UDim2.new(0.6, -5, 1, -40)
			v83.CanvasSize = u6.UDim2.new(0, 0, 0, 0)
			v83.ScrollBarThickness = 6
			v83.BackgroundColor3 = u6.Color3.fromRGB(22, 22, 28)
			v83.BorderSizePixel = 0
			v83.Parent = v82

			local v84 = u6.Instance.new("TextBox")

			v84.Size = u6.UDim2.new(1, -10, 1, 0)
			v84.Position = u6.UDim2.fromOffset(5, 5)
			v84.BackgroundTransparency = 1
			v84.TextColor3 = u6.Color3.fromRGB(235, 235, 235)
			v84.Font = u6.Enum.Font.Code
			v84.TextSize = 15
			v84.MultiLine = true
			v84.ClearTextOnFocus = false
			v84.TextWrapped = true
			v84.TextXAlignment = u6.Enum.TextXAlignment.Left
			v84.TextYAlignment = u6.Enum.TextYAlignment.Top
			v84.Text = "-- Type your command here. Example ;dog all --"
			v84.Parent = v83

			local function jyb()
				return (function()
					local v162 = v84.TextBounds.Y + 20

					v84.Size = u6.UDim2.new(1, -10, 0, u6.math.max(v162, v83.AbsoluteSize.Y - 10))
					v83.CanvasSize = u6.UDim2.new(0, 0, 0, v162)
				end)()
			end

			v84:GetPropertyChangedSignal("Text").Connect(v84:GetPropertyChangedSignal("Text"), jyb)
			v83:GetPropertyChangedSignal("AbsoluteSize").Connect(v83:GetPropertyChangedSignal("AbsoluteSize"), jyb)
			jyb()
			u6.task.spawn(function()
				return (function()
					local v165 = u6.game.GetService(u6.game, "ReplicatedStorage")

					v165:WaitForChild("HDAdminClient")
						.WaitForChild(v165:WaitForChild("HDAdminClient"), "Signals")
						.WaitForChild(v165:WaitForChild("HDAdminClient").WaitForChild(v165:WaitForChild("HDAdminClient"), "Signals"), "RequestCommand")
						:InvokeServer(";notice me [🌙  RandomDudeXD]: Hey thanks for using Secret Service! | Script made by RandomDudeXD")
				end)()
			end)

			local v86 = u6.Instance.new("TextButton")

			v86.Text = "EXECUTE"
			v86.Size = u6.UDim2.fromOffset(140, 32)
			v86.Position = u6.UDim2.new(0.3, -70, 1, -34)
			v86.BackgroundColor3 = u6.Color3.fromRGB(60, 90, 150)
			v86.TextColor3 = u6.Color3.new(1, 1, 1)
			v86.Font = u6.Enum.Font.GothamBold
			v86.TextSize = 18
			v86.Parent = v82
			v86.MouseButton1Click.Connect(v86.MouseButton1Click, function()
				return (function()
					local Text = v84.Text
					local t22_3
					local t22_5 = u6.pcall
					t22_5 = u11(t22_5(function()
						local t24_6 = {
							[-9608] = "ReplicatedStorage",
							[3215] = "RequestCommand",
							[-1469] = 1,
						}

						return (function(p23)
							local t26_3, t26_4, t26_5, t26_6, t26_8
							local t26_7 = function(p24)
								return p23[p24 - -5251]
							end

							if Text:sub(t26_7(-6720), 1) ~= ";" then
								t26_4 = u6.loadstring
								t26_4 = t26_4(Text)
								t26_4()
							else
								t26_4 = u6.game
								t26_4 = t26_4.GetService
								t26_6 = u6.game
								t26_3 = u11(t26_7(-14859))
								t26_5 = t26_4(t26_6, u12(t26_3[1], 1, t26_3[2]))
								t26_4 = t26_5.WaitForChild
								t26_4 = u11(t26_4(t26_5, "HDAdminClient"))
								t26_4 = u12(t26_4[1], 1, t26_4[2]).WaitForChild
								t26_6 = t26_5:WaitForChild("HDAdminClient")
								t26_4 = u11(t26_4(t26_6, "Signals"))
								t26_4 = u12(t26_4[1], 1, t26_4[2]).WaitForChild
								t26_6 = t26_5:WaitForChild("HDAdminClient")
								t26_6 = t26_6.WaitForChild
								t26_3 = t26_5:WaitForChild("HDAdminClient")
								t26_6 = t26_6(t26_3, "Signals")
								t26_3 = u11(t26_7(-2036))
								t26_8 = t26_4(t26_6, u12(t26_3[1], 1, t26_3[2]))
								t26_8:InvokeServer(Text)
							end
						end)(t24_6)
					end))

					local v174, v175 = u12(t22_5[1], 1, t22_5[2])
					local t22_11 = v174
					local t22_4 = v175
					t22_5 = v29.SetCore
					local t22_7 = "SendNotification"
					local t22_9 = "Title"
					local t22_2 = v174

					if v174 then
						t22_2 = "Executed"
					end

					t22_2 = t22_2
					local t22_10 = t22_2

					if not t22_2 then
						t22_10 = "Error"
					end

					t22_2 = t22_10
					t22_10 = "Text"
					local t22_8 = t22_11

					if t22_11 then
						t22_8 = "Command ran."
					end

					t22_8 = t22_8
					local t22_1 = t22_8

					if not t22_8 then
						t22_3 = u6.tostring
						t22_3 = t22_3(t22_4)
						t22_1 = t22_3
					end
					t22_9 = {
						[t22_9] = t22_2,
						[t22_10] = t22_1,
						["Duration"] = 4,
					}
					t22_5(v29, t22_7, t22_9)
				end)()
			end)

			local v87 = u6.Instance.new("Frame")

			v87.Size = u6.UDim2.new(0.4, -5, 1, 0)
			v87.Position = u6.UDim2.fromScale(0.6, 0)
			v87.BackgroundColor3 = u6.Color3.fromRGB(18, 18, 28)
			v87.Parent = v82

			local v88 = u6.Instance.new("ScrollingFrame")

			v88.Size = u6.UDim2.new(0.45, -6, 1, -10)
			v88.Position = u6.UDim2.fromOffset(4, 4)
			v88.CanvasSize = u6.UDim2.new(0, 0, 0, 0)
			v88.ScrollBarThickness = 6
			v88.BackgroundColor3 = u6.Color3.fromRGB(22, 22, 34)
			v88.Parent = v87

			local v89 = u6.Instance.new("UIListLayout")

			v89.Padding = u6.UDim.new(0, 4)
			v89.Parent = v88
			v89:GetPropertyChangedSignal("AbsoluteContentSize").Connect(v89:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				return (function()
					v88.CanvasSize = u6.UDim2.new(0, 0, 0, v89.AbsoluteContentSize.Y + 6)
				end)()
			end)

			local v90 = u6.Instance.new("Frame")

			v90.Size = u6.UDim2.new(0.55, -8, 1, -10)
			v90.Position = u6.UDim2.new(0.45, 4, 0, 4)
			v90.BackgroundColor3 = u6.Color3.fromRGB(22, 22, 34)
			v90.Parent = v87

			local u91 = nil

			local function ip(p27, p28)
				return (function()
					local v180 = u6.Instance.new("TextButton")

					v180.Text = p27
					v180.Size = u6.UDim2.new(1, -10, 0, 18)
					v180.Position = u6.UDim2.fromOffset(5, p28)
					v180.BackgroundColor3 = u6.Color3.fromRGB(45, 45, 70)
					v180.TextColor3 = u6.Color3.new(1, 1, 1)
					v180.Font = u6.Enum.Font.GothamBold
					v180.TextSize = 14
					v180.Parent = v90

					return v180
				end)()
			end

			local v93 = ip("View", 2)
			local v94 = ip("Unview", 28)
			local v95 = ip("Bring", 54)
			local v96 = ip("Teleport To", 80)
			local v97 = ip("Jail", 106)
			local v98 = ip("Unjail", 132)
			local v99 = ip("Freeze", 158)
			local v100 = ip("Unfreeze", 184)
			local v101 = ip("Loud Music", 210)
			local v102 = ip("Unmusic", 236)
			local v103 = ip("Advertise", 262)

			ip("More Coming Soon..", 288)

			local function jqb(p31)
				return (function()
					local v183 = u6.game.GetService(u6.game, "ReplicatedStorage")

					v183:WaitForChild("HDAdminClient")
						.WaitForChild(v183:WaitForChild("HDAdminClient"), "Signals")
						.WaitForChild(v183:WaitForChild("HDAdminClient").WaitForChild(v183:WaitForChild("HDAdminClient"), "Signals"), "RequestCommand")
						:InvokeServer(p31)
				end)()
			end

			v93.MouseButton1Click.Connect(v93.MouseButton1Click, function()
				local t28_2, t28_3

				if u91 then
					t28_3 = u91.Name
					t28_2 = ";view " .. t28_3
					jqb(t28_2)
				end
			end)
			v94.MouseButton1Click.Connect(v94.MouseButton1Click, function()
				return (function()
					jqb(";view")
				end)()
			end)
			v95.MouseButton1Click.Connect(v95.MouseButton1Click, function()
				local t30_1, t30_2

				if u91 then
					t30_2 = u91.Name
					t30_1 = ";bring " .. t30_2
					jqb(t30_1)
				end
			end)
			v96.MouseButton1Click.Connect(v96.MouseButton1Click, function()
				local t32_2 = {
					[7657] = " ",
				}

				return (function(p36)
					local t34_1, t34_2, t34_3, t34_4
					local t34_5 = function(p37)
						return p36[p37 + 5020]
					end

					if u91 then
						t34_4 = LocalPlayer.Name
						t34_3 = t34_5(2637)
						t34_1 = u91.Name
						t34_3 = t34_3 .. t34_1
						t34_4 = t34_4 .. t34_3
						t34_2 = ";tp " .. t34_4
						jqb(t34_2)
					end
				end)(t32_2)
			end)
			v97.MouseButton1Click.Connect(v97.MouseButton1Click, function()
				local t36_1, t36_3

				if u91 then
					t36_3 = u91.Name
					t36_1 = ";jail " .. t36_3
					jqb(t36_1)
				end
			end)
			local t38_1 = v98.MouseButton1Click
			t38_1 = t38_1.Connect
			local t38_2 = v98.MouseButton1Click
			t38_1(t38_2, function()
				local t40_1 = {
					[-32591] = ";unjail ",
				}

				return (function(p38)
					local t42_1, t42_2
					local t42_4 = function(p39)
						return p38[p39 - -29183]
					end

					if u91 then
						t42_1 = t42_4(-61774)
						t42_2 = u91.Name
						t42_1 = t42_1 .. t42_2
						jqb(t42_1)
					end
				end)(t40_1)
			end)
			t38_1 = v99.MouseButton1Click
			t38_1 = t38_1.Connect
			t38_2 = v99.MouseButton1Click
			t38_1(t38_2, function()
				local t44_1 = {
					[-14528] = ";freeze ",
				}

				return (function(p40)
					local t46_1, t46_2
					local t46_4 = function(p41)
						return p40[p41 + 15083]
					end

					if u91 then
						t46_2 = t46_4(-29611)
						t46_1 = u91.Name
						t46_2 = t46_2 .. t46_1
						jqb(t46_2)
					end
				end)(t44_1)
			end)
			t38_1 = v100.MouseButton1Click
			t38_1 = t38_1.Connect
			t38_2 = v100.MouseButton1Click
			t38_1(t38_2, function()
				local t48_1, t48_3

				if u91 then
					t48_1 = u91.Name
					t48_3 = ";thaw " .. t48_1
					jqb(t48_3)
				end
			end)
			t38_1 = v101.MouseButton1Click
			t38_1 = t38_1.Connect
			t38_2 = v101.MouseButton1Click
			t38_1(t38_2, function()
				return (function()
					jqb(";music 98194978279262")
					jqb(";volume 10")
				end)()
			end)
			t38_1 = v102.MouseButton1Click
			t38_1 = t38_1.Connect
			t38_2 = v102.MouseButton1Click
			t38_1(t38_2, function()
				return (function()
					jqb(";unmusic")
				end)()
			end)
			t38_1 = v103.MouseButton1Click
			t38_1 = t38_1.Connect
			t38_2 = v103.MouseButton1Click
			t38_1(t38_2, function()
				return (function()
					jqb(";serverhint [Secret Service]: ❗ Secret Service script on top | Made by RandomDudeXD on Scriptblox ❗")
					u6.task.wait(0.1)
					jqb(";servermessage [Secret Service]: \226\157\151 Secret Service script on top | Made by RandomDudeXD on Scriptblox \226\157\151")
				end)()
			end)
			local t38_4 = function()
				local t50_7 = {
					[23930] = 0,
					[-30810] = 35,
					[32104] = 55,
					[-32344] = "TextButton",
					[-30536] = 14,
					[14918] = 220,
				}

				return (function(p48)
					local t52_8, t52_9, t52_10
					local t52_6 = function(p49)
						return p48[p49 - -3876]
					end
					local t52_2 = u6.ipairs
					local t52_1 = v88.GetChildren
					t52_1 = u11(t52_1(v88))
					t52_2 = u11(t52_2(u12(t52_1[1], 1, t52_1[2])))

					local v228, v229, v230 = u12(t52_2[1], 1, t52_2[2])
					local t52_3 = v228
					local t52_4 = v229
					local t52_5 = v230

					if _type(v228) ~= "function" then
						t52_10 = (_getmetatable(v228))
						if t52_10 ~= nil and t52_10.__iter ~= nil then
							t52_2 = t52_10.__iter
							t52_2 = u11(t52_2(v228))

							local v231, v232, v233 = u12(t52_2[1], 1, t52_2[2])

							t52_3 = v231
							t52_4 = v232
							t52_5 = v233
						elseif _type(t52_3) == "table" then
							t52_2 = u11(_pairs(v228))

							local v234, v235, v236 = u12(t52_2[1], 1, t52_2[2])

							t52_3 = v234
							t52_4 = v235
							t52_5 = v236
						end
					end

					while true do
						local v237, v238 = t52_3(t52_4, t52_5)

						t52_9 = v237
						t52_8 = v238
						t52_5 = v237

						if v237 == nil then
							break
						end

						if t52_8:IsA(t52_6(-36220)) then
							t52_2 = "C4\179s#\175~"
							t52_1 = "\aQ\192"
							t52_2 = "Destroy"
							t52_2 = t52_8:Destroy()
						end
					end

					for _, v240 in u6.ipairs(v27:GetPlayers()) do
						local t54_1, t54_2, t54_3, t54_4, t54_5, t54_6, t54_7

						if v240 ~= LocalPlayer then
							t54_1 = "\194\v\014\157\234\v\030\140"
							t54_2 = "\139e}\233"
							t54_1 = u6.Instance
							t54_2 = "\194\201\219"
							t54_3 = "\172"
							t54_1 = t54_1.new
							t54_2 = "h7v\153OI&z\130c"
							t54_3 = "<R\014\237\r"
							t54_4 = t54_1("TextButton")
							t54_1 = "\190\153\157\157"
							t54_2 = "\240\248"
							t54_1 = "Name"
							t54_1 = v240.Name
							t54_4.Text = t54_1
							t54_1 = "\249w\197^\158"
							t54_2 = "\1723"
							t54_1 = u6.UDim2
							t54_2 = "\254\245\231"
							t54_3 = "\144"
							t54_1 = t54_1.new
							t54_2 = -4370
							t54_3 = 4371
							t54_2 = 1
							t54_3 = 31155
							t54_6 = 31161
							t54_3 = -6
							t54_6 = 40748
							t54_7 = -20694
							t54_6 = 20054
							t54_6 = t52_6(20054)
							t54_7 = 78078
							t54_5 = 3003
							t54_7 = 26
							t54_4.Size = t54_1(1, -6, t54_6, 26)
							t54_1 = "\174D\173\130Y\242"
							t54_2 = "\237+\193"
							t54_1 = u6.Color3
							t54_2 = "\192/\a\203\015/\228"
							t54_3 = "\166]h"
							t54_1 = t54_1.fromRGB
							t54_2 = 423203886
							t54_3 = -12201
							t54_2 = -34686
							t54_2 = t52_6(-34686)
							t54_3 = 0.02280130293159609
							t54_6 = 1535
							t54_3 = 35
							t54_6 = -580282996
							t54_7 = -20557
							t54_6 = 28228
							t54_6 = u11(t52_6(28228))
							t54_4.BackgroundColor3 = t54_1(t54_2, 35, u12(t54_6[1], 1, t54_6[2]))
							t54_1 = "w\197\241[خ"
							t54_2 = "4\170\157"
							t54_1 = u6.Color3
							t54_2 = "\031y\024\020Y0;"
							t54_3 = "y\vw"
							t54_1 = t54_1.fromRGB
							t54_2 = 5710100
							t54_3 = 25955
							t54_2 = 220
							t54_3 = -0.37510615891565036
							t54_6 = -29437
							t54_3 = 11042
							t54_3 = t52_6(11042)
							t54_6 = 28320
							t54_7 = -28100
							t54_6 = 220
							t54_4.TextColor3 = t54_1(220, t54_3, 220)
							t54_1 = "\187{\139x"
							t54_2 = "\254\021"
							t54_1 = "Enum"
							t54_1 = u6.Enum
							t54_2 = "\237=\197&"
							t54_3 = "\171R"
							t54_2 = "Font"
							t54_1 = t54_1.Font
							t54_2 = "(U\015_"
							t54_3 = "k:"
							t54_2 = "Code"
							t54_1 = t54_1.Code
							t54_4.Font = t54_1
							t54_1 = -21069
							t54_2 = -13343
							t54_1 = -34412
							t54_4.TextSize = t52_6(-34412)
							t54_4.Parent = v88
							t54_1 = "\191Sɬ&\149\2549\134S\210\238\000\187\226.\153"
							t54_2 = "\242<\188\223C\215\139M"
							t54_1 = "MouseButton1Click"
							t54_1 = t54_4.MouseButton1Click
							t54_2 = "l-,A'!["
							t54_3 = "/BB"
							t54_2 = "Connect"
							t54_1 = t54_1.Connect
							t54_2 = "\191Sɬ&\149\2549\134S\210\238\000\187\226.\153"
							t54_3 = "\242<\188\223C\215\139M"
							t54_2 = "MouseButton1Click"
							t54_2 = t54_4.MouseButton1Click
							t54_1 = t54_1(t54_2, function()
								u91 = v240
							end)
						end
					end
				end)(t50_7)
			end
			t38_4()
			t38_1 = v27.PlayerAdded
			t38_1 = t38_1.Connect
			t38_2 = v27.PlayerAdded
			t38_1(t38_2, t38_4)
			t38_1 = v27.PlayerRemoving
			t38_1 = t38_1.Connect
			t38_2 = v27.PlayerRemoving
			t38_1(t38_2, t38_4)
		end)()
	end)
end)(...)
