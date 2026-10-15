-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer, TweenService, u12, u16, u23, u25, u29, v32, ImageButton, TextLabel, ImageButton2, Frame, TextButton, u95, u97, u98, u99, n3, u101, n4, u104, u105, u108, u109, n5, t2, u114, u115, u129, u146, Frame2, Frame3, v209, v235, v236, u237, u238, v242, v243, u244, u245, u246, v251, u259, u267, u275, u281, u282, u283, u284, u285

do
	local u96, u102, u113, u118, id, t10, u127, u176, u177, u178, u179, u180, u181, u182, u184, u211
	local UserInputService = game:GetService("UserInputService")

	game:GetService("Lighting")

	local Workspace, Debris, t3, v168, v170

	do
		local u106, n6, t5, u135, u136, u137
		local ScreenGui, v149, v175

		do
			local u26, n1, n2, u30, u107, n7, n8, t11, u133, u134, u138, u139, n9, n10, t12, u143, n11, n12, u191, u193
			local u150, u151, v188

			do
				local TextChatService, Chat, t4
				local ReplicatedStorage = game:GetService("ReplicatedStorage")

				game:GetService("ProximityPromptService")
				LocalPlayer = Players.LocalPlayer
				game:GetService("StarterGui")

				do
					local CoreGui = game:GetService("CoreGui")

					Workspace = game:GetService("Workspace")
					Debris = game:GetService("Debris")
					TweenService = game:GetService("TweenService")
					TextChatService = game:GetService("TextChatService")
					Chat = game:GetService("Chat")

					if game.PlaceId == 2788229376 then
						loadstring(game:HttpGet("https://pastebin.com/raw/JFrBJBZw"))()
					end

					u12 = getgenv and getgenv() or _G
					u12.FPDH = workspace.FallenPartsDestroyHeight
					loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()

					do
						local v13 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

						v13:Notify({
							Title = "made by GioBolqv1",
							Description = "follow me on Roblox plz",
						}, {
							OutlineColor = Color3.fromRGB(80, 80, 80),
							Time = 6,
							Type = "default",
						})

						local delay = task.delay
						local u15 = v13

						delay(6, function()
							u15:Notify({
								Title = "I CAN DO WHATEVER THE",
								Description = "FUUUUUUUCK I WANT *goons*",
							}, {
								OutlineColor = Color3.fromRGB(80, 80, 80),
								Time = 1,
								Type = "default",
							})
						end)
					end

					u16 = nil

					local _pcall = pcall
					local u18 = CoreGui
					local v19, _ = pcall(function()
						u16 = u18

						local _ = u18.Name
					end)

					if not v19 or true then
						u16 = LocalPlayer:WaitForChild("PlayerGui")
					end
				end

				ScreenGui = Instance.new("ScreenGui")
				ScreenGui.Name = "CustomClientUI"
				ScreenGui.ResetOnSpawn = false
				ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				ScreenGui.Parent = u16
				local u22 = false
				u23 = true

				local t1 = {}

				u25 = false
				u26 = true
				n1 = 0.15
				n2 = 3.5
				u29 = false
				u30 = true

				do
					local u31 = UserInputService

					function v32(p1, p2, p3)
						local u321 = nil
						local u322 = nil
						local p4Position = nil
						local Position = nil
						local InputBegan = p1.InputBegan
						local u326 = p3
						local u327 = p2
						local u328 = p1

						InputBegan:Connect(function(p4)
							if p4.UserInputType == Enum.UserInputType.Touch or p4.UserInputType == Enum.UserInputType.MouseButton1 then
								if u326 and u22 then
									local connection = nil
									local Changed = p4.Changed
									local u585 = p4
									Changed:Connect(function()
										if u585.UserInputState == Enum.UserInputState.End then
											connection:Disconnect()

											if u327 then
												u327()
											end
										end
									end)

									return
								end

								u321 = true
								p4Position = p4.Position
								Position = u328.Position

								local connection = nil
								local Changed = p4.Changed
								local u588 = p4
								Changed:Connect(function()
									if u588.UserInputState == Enum.UserInputState.End then
										if not u321 then
											return
										end

										u321 = false
										connection:Disconnect()

										if (u588.Position - p4Position).Magnitude < 6 and u327 then
											u327()
										end
									end
								end)
							end
						end)
						p1.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
								u322 = input
							end
						end)

						local InputChanged = u31.InputChanged
						local u330 = p1

						InputChanged:Connect(function(p5)
							if p5 == u322 and u321 then
								local v591 = p5.Position - p4Position

								u330.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v591.X, Position.Y.Scale, Position.Y.Offset + v591.Y)
							end
						end)
					end

					ImageButton = Instance.new("ImageButton")
					ImageButton.Size = UDim2.new(0, 100, 0, 45)
					ImageButton.Position = UDim2.new(0.95, -120, 0.45, 0)
					ImageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					ImageButton.Image = "rbxthumb://type=Asset&id=101173184874869&w=150&h=150"
					ImageButton.ScaleType = Enum.ScaleType.Stretch
					ImageButton.Active = true
					ImageButton.BorderSizePixel = 0
					ImageButton.Parent = ScreenGui
					TextLabel = Instance.new("TextLabel")
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Text = "Homelander: OFF"
					TextLabel.TextColor3 = Color3.new(1, 1, 1)
					TextLabel.Font = Enum.Font.Fantasy
					TextLabel.TextSize = 12.7
					TextLabel.ZIndex = 2
					TextLabel.Parent = ImageButton

					local UIStroke = Instance.new("UIStroke")

					UIStroke.Thickness = 1.5
					UIStroke.Color = Color3.fromRGB(0, 0, 0)
					UIStroke.Parent = TextLabel

					local UICorner = Instance.new("UICorner")

					UICorner.CornerRadius = UDim.new(0.2, 0)
					UICorner.Parent = ImageButton

					local UIStroke2 = Instance.new("UIStroke")

					UIStroke2.Thickness = 2
					UIStroke2.Color = Color3.fromRGB(50, 50, 50)
					UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					UIStroke2.Parent = ImageButton
					ImageButton2 = Instance.new("ImageButton")
					ImageButton2.Name = "SettingButton"
					ImageButton2.Size = UDim2.new(0, 45, 0, 45)
					ImageButton2.Position = UDim2.new(0.05, 0, 0.45, 0)
					ImageButton2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					ImageButton2.Image = "rbxthumb://type=Asset&id=104077005427988&w=150&h=150"
					ImageButton2.ScaleType = Enum.ScaleType.Stretch
					ImageButton2.Active = true
					ImageButton2.BorderSizePixel = 0
					ImageButton2.Visible = false
					ImageButton2.Parent = ScreenGui

					local UICorner2 = Instance.new("UICorner")

					UICorner2.CornerRadius = UDim.new(0.3, 0)
					UICorner2.Parent = ImageButton2
				end

				do
					local TextButton2, TextButton3

					do
						local UIStroke = Instance.new("UIStroke")

						UIStroke.Thickness = 2
						UIStroke.Color = Color3.fromRGB(50, 50, 50)
						UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						UIStroke.Parent = ImageButton2
						Frame = Instance.new("Frame")
						Frame.Size = UDim2.new(0, 230, 0, 265)
						Frame.Position = UDim2.new(1, 10, 0.5, -132)
						Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
						Frame.BorderSizePixel = 0
						Frame.Visible = false
						Frame.Parent = ImageButton2

						local UICorner = Instance.new("UICorner")

						UICorner.CornerRadius = UDim.new(0.1, 0)
						UICorner.Parent = Frame

						local UIStroke3 = Instance.new("UIStroke")

						UIStroke3.Thickness = 2
						UIStroke3.Color = Color3.fromRGB(60, 60, 60)
						UIStroke3.Parent = Frame
						TextButton2 = Instance.new("TextButton")
						TextButton2.Size = UDim2.new(0, 100, 0, 26)
						TextButton2.Position = UDim2.new(0.05, 0, 0, 6)
						TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						TextButton2.TextColor3 = Color3.new(1, 1, 1)
						TextButton2.Font = Enum.Font.Fantasy
						TextButton2.TextSize = 11
						TextButton2.Text = "lock buttons"
						TextButton2.Parent = Frame

						local UICorner3 = Instance.new("UICorner")

						UICorner3.CornerRadius = UDim.new(0.2, 0)
						UICorner3.Parent = TextButton2
						TextButton3 = Instance.new("TextButton")
						TextButton3.Size = UDim2.new(0, 110, 0, 26)
						TextButton3.Position = UDim2.new(0.5, 0, 0, 6)
						TextButton3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						TextButton3.TextColor3 = Color3.new(1, 1, 1)
						TextButton3.Font = Enum.Font.Fantasy
						TextButton3.TextSize = 10
						TextButton3.Text = "camera follow: on"
						TextButton3.Parent = Frame

						local UICorner4 = Instance.new("UICorner")

						UICorner4.CornerRadius = UDim.new(0.2, 0)
						UICorner4.Parent = TextButton3
						TextButton = Instance.new("TextButton")
						TextButton.Size = UDim2.new(0, 100, 0, 26)
						TextButton.Position = UDim2.new(0.05, 0, 0, 38)
						TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						TextButton.TextColor3 = Color3.new(1, 1, 1)
						TextButton.Font = Enum.Font.Fantasy
						TextButton.TextSize = 11
						TextButton.Text = "hide buttons"
						TextButton.Parent = Frame

						local UICorner5 = Instance.new("UICorner")

						UICorner5.CornerRadius = UDim.new(0.2, 0)
						UICorner5.Parent = TextButton
					end

					local v80, MouseButton1Click

					do
						local v74

						do
							local TextButton4

							do
								local TextButton5

								do
									local TextButton6 = Instance.new("TextButton")

									TextButton6.Size = UDim2.new(0, 110, 0, 26)
									TextButton6.Position = UDim2.new(0.5, 0, 0, 38)
									TextButton6.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
									TextButton6.TextColor3 = Color3.new(1, 1, 1)
									TextButton6.Font = Enum.Font.Fantasy
									TextButton6.TextSize = 8.5
									TextButton6.Text = "camera lift during laser: on"
									TextButton6.Parent = Frame

									local UICorner = Instance.new("UICorner")

									UICorner.CornerRadius = UDim.new(0.2, 0)
									UICorner.Parent = TextButton6

									local MouseButton1Click2 = TextButton6.MouseButton1Click
									local u53 = TextButton6

									MouseButton1Click2:Connect(function()
										u26 = not u26
										u53.Text = "camera lift during laser: " .. (u26 and "on" or "off")
									end)

									local TextLabel2 = Instance.new("TextLabel")

									TextLabel2.Size = UDim2.new(0.5, 0, 0, 22)
									TextLabel2.Position = UDim2.new(0.05, 0, 0, 70)
									TextLabel2.BackgroundTransparency = 1
									TextLabel2.TextColor3 = Color3.new(1, 1, 1)
									TextLabel2.Font = Enum.Font.Fantasy
									TextLabel2.TextSize = 10
									TextLabel2.Text = "laser eye offset:"
									TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
									TextLabel2.Parent = Frame
									TextButton5 = Instance.new("TextButton")
									TextButton5.Size = UDim2.new(0, 40, 0, 22)
									TextButton5.Position = UDim2.new(0.55, 0, 0, 70)
									TextButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
									TextButton5.TextColor3 = Color3.new(1, 1, 1)
									TextButton5.Font = Enum.Font.Fantasy
									TextButton5.TextSize = 13
									TextButton5.Text = "▲"
									TextButton5.Parent = Frame

									local UICorner6 = Instance.new("UICorner")

									UICorner6.CornerRadius = UDim.new(0.2, 0)
									UICorner6.Parent = TextButton5
								end

								local TextButton7 = Instance.new("TextButton")

								TextButton7.Size = UDim2.new(0, 40, 0, 22)
								TextButton7.Position = UDim2.new(0.75, 0, 0, 70)
								TextButton7.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
								TextButton7.TextColor3 = Color3.new(1, 1, 1)
								TextButton7.Font = Enum.Font.Fantasy
								TextButton7.TextSize = 13
								TextButton7.Text = "▼"
								TextButton7.Parent = Frame

								local UICorner = Instance.new("UICorner")

								UICorner.CornerRadius = UDim.new(0.2, 0)
								UICorner.Parent = TextButton7
								TextButton5.MouseButton1Click:Connect(function()
									n1 = n1 + 0.05
								end)
								TextButton7.MouseButton1Click:Connect(function()
									n1 = n1 - 0.05
								end)

								local TextButton8 = Instance.new("TextButton")

								TextButton8.Size = UDim2.new(0, 100, 0, 26)
								TextButton8.Position = UDim2.new(0.05, 0, 0, 102)
								TextButton8.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
								TextButton8.TextColor3 = Color3.new(1, 1, 1)
								TextButton8.Font = Enum.Font.Fantasy
								TextButton8.TextSize = 11
								TextButton8.Text = "shiftlock: off"
								TextButton8.Parent = Frame

								local UICorner7 = Instance.new("UICorner")

								UICorner7.CornerRadius = UDim.new(0.2, 0)
								UICorner7.Parent = TextButton8

								local MouseButton1Click3 = TextButton8.MouseButton1Click
								local u62 = TextButton8

								MouseButton1Click3:Connect(function()
									u29 = not u29
									u62.Text = "shiftlock: " .. (u29 and "on" or "off")
								end)
								TextButton4 = Instance.new("TextButton")
								TextButton4.Size = UDim2.new(0, 110, 0, 26)
								TextButton4.Position = UDim2.new(0.5, 0, 0, 102)
								TextButton4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
								TextButton4.TextColor3 = Color3.new(1, 1, 1)
								TextButton4.Font = Enum.Font.Fantasy
								TextButton4.TextSize = 10
								TextButton4.Text = "laser fling: on"
								TextButton4.Parent = Frame

								local UICorner8 = Instance.new("UICorner")

								UICorner8.CornerRadius = UDim.new(0.2, 0)
								UICorner8.Parent = TextButton4
							end

							local MouseButton1Click4 = TextButton4.MouseButton1Click
							local u66 = TextButton4

							MouseButton1Click4:Connect(function()
								u30 = not u30
								u66.Text = "laser fling: " .. (u30 and "on" or "off")

								if not u30 then
									laserCurrentTarget = nil
								end
							end)

							local TextLabel3 = Instance.new("TextLabel")

							TextLabel3.Size = UDim2.new(0.5, 0, 0, 22)
							TextLabel3.Position = UDim2.new(0.05, 0, 0, 134)
							TextLabel3.BackgroundTransparency = 1
							TextLabel3.TextColor3 = Color3.new(1, 1, 1)
							TextLabel3.Font = Enum.Font.Fantasy
							TextLabel3.TextSize = 10
							TextLabel3.Text = "camera X offset:"
							TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
							TextLabel3.Parent = Frame

							local TextButton9 = Instance.new("TextButton")

							TextButton9.Size = UDim2.new(0, 40, 0, 22)
							TextButton9.Position = UDim2.new(0.55, 0, 0, 134)
							TextButton9.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
							TextButton9.TextColor3 = Color3.new(1, 1, 1)
							TextButton9.Font = Enum.Font.Fantasy
							TextButton9.TextSize = 13
							TextButton9.Text = "◀"
							TextButton9.Parent = Frame

							local UICorner = Instance.new("UICorner")

							UICorner.CornerRadius = UDim.new(0.2, 0)
							UICorner.Parent = TextButton9

							local TextButton10 = Instance.new("TextButton")

							TextButton10.Size = UDim2.new(0, 40, 0, 22)
							TextButton10.Position = UDim2.new(0.75, 0, 0, 134)
							TextButton10.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
							TextButton10.TextColor3 = Color3.new(1, 1, 1)
							TextButton10.Font = Enum.Font.Fantasy
							TextButton10.TextSize = 13
							TextButton10.Text = "▶"
							TextButton10.Parent = Frame

							local UICorner9 = Instance.new("UICorner")

							UICorner9.CornerRadius = UDim.new(0.2, 0)
							UICorner9.Parent = TextButton10
							TextButton9.MouseButton1Click:Connect(function()
								n2 = n2 - 0.5
							end)
							TextButton10.MouseButton1Click:Connect(function()
								n2 = n2 + 0.5
							end)

							local Frame4 = Instance.new("Frame")

							Frame4.Size = UDim2.new(0.9, 0, 0, 60)
							Frame4.Position = UDim2.new(0.05, 0, 0, 168)
							Frame4.BackgroundTransparency = 1
							Frame4.Parent = Frame

							local u73 = Frame4

							function v74(p6, p7)
								local TextButton11 = Instance.new("TextButton")

								TextButton11.Size = UDim2.new(0, 25, 0, 25)
								TextButton11.Position = p7
								TextButton11.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
								TextButton11.TextColor3 = Color3.new(1, 1, 1)
								TextButton11.Font = Enum.Font.Fantasy
								TextButton11.TextSize = 16
								TextButton11.Text = p6
								TextButton11.Parent = u73

								local UICorner10 = Instance.new("UICorner")

								UICorner10.CornerRadius = UDim.new(0.2, 0)
								UICorner10.Parent = TextButton11

								return TextButton11
							end
						end

						local v75 = v74("↑", UDim2.new(0.5, -12, 0, 0))
						local v76 = v74("↓", UDim2.new(0.5, -12, 0, 32))
						local v77 = v74("←", UDim2.new(0.5, -42, 0, 16))
						local v78 = v74("→", UDim2.new(0.5, 18, 0, 16))
						local u79 = t1

						function v80(p8, p9)
							for _, v in ipairs(u79) do
								v.Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset + p8, v.Position.Y.Scale, v.Position.Y.Offset + p9)
							end
						end

						local MouseButton1Click5 = v75.MouseButton1Click
						local u82 = v80

						MouseButton1Click5:Connect(function()
							u82(0, -5)
						end)

						local MouseButton1Click6 = v76.MouseButton1Click
						local u84 = v80

						MouseButton1Click6:Connect(function()
							u84(0, 5)
						end)

						local MouseButton1Click7 = v77.MouseButton1Click
						local u86 = v80

						MouseButton1Click7:Connect(function()
							u86(-5, 0)
						end)
						MouseButton1Click = v78.MouseButton1Click
					end

					local u88 = v80

					MouseButton1Click:Connect(function()
						u88(5, 0)
					end)

					local MouseButton1Click8 = TextButton2.MouseButton1Click
					local u90 = TextButton2

					MouseButton1Click8:Connect(function()
						u22 = not u22
						u90.Text = u22 and "unlock buttons" or "lock buttons"
					end)

					local MouseButton1Click9 = TextButton3.MouseButton1Click
					local u92 = TextButton3

					MouseButton1Click9:Connect(function()
						u23 = not u23
						u92.Text = u23 and "camera follow: on" or "camera follow: off"
					end)
					local u94 = Frame

					v32(ImageButton2, function()
						u94.Visible = not u94.Visible
					end, false)
					u95 = false
					u96 = nil
					u97 = false
					u98 = nil
					u99 = false
					n3 = 1
					u101 = false
					u102 = false
					n4 = 1
					u104 = false
					u105 = true
					u106 = false
					u107 = nil
					u108 = false
					u109 = nil
					n5 = 0
					t2 = {
						[0] = 1,
						[1] = 0.5,
						[2] = 1.5,
					}

					local _ = {
						[0] = "Normal",
						[1] = "Slow",
						[2] = "Fast",
					}

					Color3.fromRGB(0, 255, 0)
					u113 = nil
					u114 = nil
					u115 = nil
					t3 = {}
					t4 = {}
					u118 = nil
					n6 = 1
					t5 = {}

					local t6 = {
						id = "rbxassetid://126046533185038",
						name = "idle V1",
					}
					local t7 = {
						id = "rbxassetid://116874847956719",
						name = "idle V2",
					}
					local t8 = {
						id = "rbxassetid://96251694399659",
						name = "idle V3",
					}
					local t9 = {
						id = "rbxassetid://70950173927129",
						name = "idle V4",
					}

					t5[1] = t6
					t5[2] = t7
					t5[3] = t8
					t5[4] = t9
				end

				id = t5[1].id
				t10 = {
					{
						id = "rbxassetid://114833664438028",
						name = "Fly",
					},
				}
				u127 = false
				local u128 = false
				u129 = false
				n7 = 0
				n8 = 0
				t11 = {}
				u133 = nil
				u134 = nil
				u135 = nil
				u136 = nil
				u137 = false
				u138 = nil
				u139 = nil
				n9 = 0
				n10 = 0
				t12 = {}
				u143 = nil
				n11 = 0
				n12 = 0
				u146 = nil

				local u147 = ReplicatedStorage
				local u148 = LocalPlayer

				function v149(p10)
					local v340 = false

					if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
						local v341 = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")

						if v341 then
							v341:SendAsync(p10)
							v340 = true
						end
					end

					if not v340 then
						local SayMessageRequest = u147:FindFirstChild("SayMessageRequest", true)

						if SayMessageRequest and SayMessageRequest:IsA("RemoteEvent") then
							SayMessageRequest:FireServer(p10, "All")
						end

						if u148.Character and u148.Character:FindFirstChild("Head") then
							Chat:Chat(u148.Character.Head, p10, Enum.ChatColor.White)
						end
					end
				end

				u150 = RunService
				u151 = LocalPlayer

				if game.PlaceId == 189707 then
					local RenderStepped, LocalPlayer2, u157, u158

					do
						local Heartbeat

						do
							local RunService2 = game:GetService("RunService")

							Heartbeat = RunService2.Heartbeat
							RenderStepped = RunService2.RenderStepped
						end

						LocalPlayer2 = game.Players.LocalPlayer

						local zero = Vector3.zero

						u157 = Heartbeat
						u158 = zero
					end

					local u159 = RenderStepped

					local function v160(p11)
						local HumanoidRootPart = p11:WaitForChild("HumanoidRootPart")

						if HumanoidRootPart then
							local connection = nil
							local u347 = HumanoidRootPart

							connection = u157:Connect(function()
								if not u347.Parent then
									connection:Disconnect()
								end

								local AssemblyLinearVelocity = u347.AssemblyLinearVelocity

								u347.AssemblyLinearVelocity = u158
								u159:Wait()
								u347.AssemblyLinearVelocity = AssemblyLinearVelocity
							end)
						end
					end

					if LocalPlayer2.Character then
						v160(LocalPlayer2.Character)
					end

					LocalPlayer2.CharacterAdded:Connect(v160)
				else
					print("Error not found natural disasters survival game!")
				end

				function v168(p12)
					local v370 = p12 or 0.4

					for _, v in pairs(t4) do
						v:Stop(v370)
					end

					if u118 then
						if coroutine.status(u118) ~= "dead" then
							task.cancel(u118)
						end

						u118 = nil
					end

					t4 = {}
				end

				local u169 = LocalPlayer

				function v170(p13, p14, p15)
					local Character = u169.Character
					local v377 = Character and Character:FindFirstChildOfClass("Humanoid")

					if v377 then
						local v378 = p15 or 0.4
						local Animation = Instance.new("Animation")

						Animation.AnimationId = p13

						local track = v377:LoadAnimation(Animation)

						track.Looped = p14
						track:Play(v378)

						table.insert(t4, track)

						return track
					end
				end

				Frame2 = Instance.new("Frame")
				Frame2.Name = "ActionButtons"
				Frame2.Size = UDim2.new(0, 400, 0, 400)
				Frame2.Position = UDim2.new(1, -420, 0, 50)
				Frame2.BackgroundTransparency = 1
				Frame2.Visible = false
				Frame2.Parent = ScreenGui
				Frame3 = Instance.new("Frame")
				Frame3.Name = "UtilityButtons"
				Frame3.Size = UDim2.new(0, 310, 0, 100)
				Frame3.Position = UDim2.new(1, -310, 0, 20)
				Frame3.BackgroundTransparency = 1
				Frame3.Visible = false
				Frame3.Parent = ScreenGui

				local u173 = Frame2
				local u174 = t1

				function v175(p16, p17, p18, p19, p20)
					local ImageButton3 = Instance.new("ImageButton")

					ImageButton3.Name = p16
					ImageButton3.Size = UDim2.new(0, 45, 0, 45)
					ImageButton3.Position = p17
					ImageButton3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ImageButton3.BorderSizePixel = 0
					ImageButton3.Active = true
					ImageButton3.AutoButtonColor = true
					ImageButton3.Parent = p20 or u173

					table.insert(u174, ImageButton3)

					local UICorner = Instance.new("UICorner")

					UICorner.CornerRadius = UDim.new(0.3, 0)
					UICorner.Parent = ImageButton3

					local UIStroke = Instance.new("UIStroke")

					UIStroke.Thickness = 2
					UIStroke.Color = Color3.fromRGB(60, 60, 60)
					UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					UIStroke.Parent = ImageButton3

					if p18 then
						ImageButton3.Image = "rbxthumb://type=Asset&id=" .. p18 .. "&w=150&h=150"
					end

					local TextLabel4 = Instance.new("TextLabel")

					TextLabel4.Size = UDim2.new(1, 0, 1, 0)
					TextLabel4.BackgroundTransparency = 1
					TextLabel4.TextColor3 = Color3.new(1, 1, 1)
					TextLabel4.Font = Enum.Font.Fantasy
					TextLabel4.TextSize = 8
					TextLabel4.TextWrapped = true
					TextLabel4.Text = p19 or ""
					TextLabel4.Parent = ImageButton3

					return ImageButton3, UIStroke
				end

				u176 = nil
				u177 = nil
				u178 = nil
				u179 = nil
				u180 = nil
				u181 = nil
				u182 = nil
				local u183 = nil
				u184 = false
				local u185 = false
				local u187 = Workspace

				function v188()
					local Part = Instance.new("Part")

					Part.Size = Vector3.new(0.05, 0.05, 0.05)
					Part.Anchored = true
					Part.CanCollide = false
					Part.Transparency = 1
					Part.CastShadow = false
					Part.Parent = u187

					local Attachment = Instance.new("Attachment", Part)
					local Part2 = Instance.new("Part")

					Part2.Size = Vector3.new(0.05, 0.05, 0.05)
					Part2.Anchored = true
					Part2.CanCollide = false
					Part2.Transparency = 1
					Part2.CastShadow = false
					Part2.Parent = u187

					local Attachment2 = Instance.new("Attachment", Part2)
					local u426 = Part
					local u427 = Attachment
					local u428 = Attachment2

					local function v429(p21, p22, p23, p24, p25)
						local Beam = Instance.new("Beam", u426)

						Beam.Attachment0 = u427
						Beam.Attachment1 = u428
						Beam.LightEmission = 1
						Beam.LightInfluence = 0
						Beam.FaceCamera = true
						Beam.Segments = 1
						Beam.Width0 = p21
						Beam.Width1 = p22
						Beam.Color = ColorSequence.new(p25)
						Beam.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, p23),
							NumberSequenceKeypoint.new(1, p24),
						})
					end

					v429(0.09, 0.04, 0, 0, {
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 220)),
						ColorSequenceKeypoint.new(0.04, Color3.fromRGB(255, 40, 40)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 0, 0)),
					})
					v429(0.5, 0.15, 0.25, 0.88, {
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 0)),
					})
					v429(1.1, 0.3, 0.65, 1, {
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
					})

					return {
						origin = Part,
						endpoint = Part2,
					}
				end
				local u190 = LocalPlayer

				function u191()
					local raycastParams = RaycastParams.new()

					raycastParams.FilterType = Enum.RaycastFilterType.Exclude

					local Character = u190.Character
					local t13 = {}

					if Character then
						table.insert(t13, Character)
					end

					if u133 then
						local origin = u133.origin

						table.insert(t13, origin)

						local endpoint = u133.endpoint

						table.insert(t13, endpoint)
					end

					if u134 then
						local origin = u134.origin

						table.insert(t13, origin)

						local endpoint = u134.endpoint

						table.insert(t13, endpoint)
					end

					raycastParams.FilterDescendantsInstances = t13

					return raycastParams
				end
			end

			local u192 = Players

			function u193(p26)
				if not t11[p26] then
					t11[p26] = true

					local Humanoid = p26:FindFirstChildOfClass("Humanoid")

					if Humanoid and Humanoid.Health > 0 and not u192:GetPlayerFromCharacter(p26) then
						Humanoid.Health = 0
						p26:BreakJoints()
					end

					local delay = task.delay
					local u440 = p26

					delay(0.5, function()
						t11[u440] = nil
					end)

					return
				end
			end

			local u194 = LocalPlayer

			local function v195(p27)
				if p27 and p27 ~= u194 and p27.Character then
					if not t12[p27] or not (tick() - t12[p27] < 8) then
						local Character = p27.Character
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
						local Humanoid = Character:FindFirstChildOfClass("Humanoid")
						local BodyEffects = Character:FindFirstChild("BodyEffects")

						if HumanoidRootPart and Humanoid and not (Humanoid.Health < 2) then
							if not Character:FindFirstChildOfClass("ForceField") then
								local v446 = BodyEffects and (BodyEffects:FindFirstChild("K.O") or BodyEffects:FindFirstChild("KO"))

								if not v446 or v446.Value ~= true then
									local Character2 = u194.Character
									local v448 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

									if v448 then
										if not ((v448.Position - HumanoidRootPart.Position).Magnitude > 1000) then
											return true
										end

										return false
									end

									return false
								end

								return false
							end

							return false
						end

						return false
					end

					return false
				end

				return false
			end
			local u196 = nil
			local u202 = LocalPlayer
			local u203 = RunService
			local u204 = Workspace
			local u205 = v195
			local u206 = t3
			local u207 = v188
			local u208 = Players

			function v209()
				if not u137 then
					u137 = true
					u129 = false
					n7 = 0
					n8 = tick()
					t11 = {}
					u139 = nil
					n9 = 0
					n10 = 0
					t12 = {}
					n11 = 0
					n12 = 0

					if u133 then
						u133.origin:Destroy()
						u133.endpoint:Destroy()
						u133 = nil
					end

					if u134 then
						u134.origin:Destroy()
						u134.endpoint:Destroy()
						u134 = nil
					end

					local Character = u202.Character
					local v450 = Character and Character:FindFirstChild("Head")

					if not u135 then
						u135 = Instance.new("Sound")
						u135.SoundId = "rbxassetid://80876450442880"
						u135.Looped = false
						u135.Volume = 0.6
					end

					if v450 then
						u135.Parent = v450
					end

					if u196 then
						u196:Disconnect()
					end

					u196 = u203.Heartbeat:Connect(function()
						local Character3 = u202.Character
						local v654 = Character3 and Character3:FindFirstChild("HumanoidRootPart")
						local v655 = Character3 and Character3:FindFirstChildOfClass("Humanoid")
						local CurrentCamera = u204.CurrentCamera

						if v654 and v655 and CurrentCamera then
							local CFrame2 = v654.CFrame
							local Velocity = v654.Velocity
							local RotVelocity = v654.RotVelocity
							local v660 = CFrame2
							local v661 = false

							if u139 then
								local Character4 = u139.Character
								local v663 = Character4 and Character4:FindFirstChild("HumanoidRootPart")
								local v664 = Character4 and Character4:FindFirstChildOfClass("Humanoid")

								if not u30 or not v663 or not v664 or not u205(u139) then
									u139 = nil
								else
									local Magnitude = v663.Velocity.Magnitude
									local v666 = tick() - n9

									if not (Magnitude > 500) and not (v664.Health < 2) and not (v666 > 3) then
										v661 = true
										n11 = n11 + 1
										n12 = n12 + 100

										local WalkSpeed = v664.WalkSpeed
										local MoveDirection = v664.MoveDirection

										CFrame.new()
										local v673

										if not (Magnitude >= 50) then
											local v669 = n11 % 2 == 0 and 1.5 or -1.5
											local v670 = CFrame.new(0, v669, 0) + MoveDirection * Magnitude / 1.25
											local Angles = CFrame.Angles

											v673 = v670 * Angles(math.rad(n12), 0, 0)
										else
											local v674 = n11 % 3

											if v674 ~= 0 then
												if v674 ~= 1 then
													v673 = CFrame.new(0, 1.5, WalkSpeed) * CFrame.Angles(1.5707963267948966, 0, 0)
												else
													v673 = CFrame.new(0, -1.5, -WalkSpeed) * CFrame.Angles(0, 0, 0)
												end
											else
												v673 = CFrame.new(0, 1.5, WalkSpeed) * CFrame.Angles(1.5707963267948966, 0, 0)
											end
										end

										v660 = CFrame.new(v663.Position) * v673
										v654.Velocity = Vector3.new(90000000, 900000000, 90000000)
										local u676 = v654

										pcall(function()
											u676.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
										end)
									else
										t12[u139] = tick()
										u139 = nil
									end
								end
							end

							if not v661 then
								if u143 then
									u143:Destroy()
									u143 = nil
								end

								local Character5 = u202.Character
								local v678 = Character5 and Character5:FindFirstChildOfClass("Humanoid")

								if not u206.camPart or CurrentCamera.CameraSubject == u206.camPart then
									if not u206.camPart and v678 and v678 ~= CurrentCamera.CameraSubject then
										CurrentCamera.CameraSubject = v678
									end

									return
								end

								CurrentCamera.CameraSubject = u206.camPart

								return
							end

							if not u143 then
								u143 = Instance.new("Part")
								u143.Name = "LaserStableCameraProxy"
								u143.Size = Vector3.new(0.1, 0.1, 0.1)
								u143.Transparency = 1
								u143.Anchored = true
								u143.CanCollide = false
								u143.Parent = u204
								CurrentCamera.CameraSubject = u143
							end

							local v679 = CFrame2 * CFrame.new(0, 1.5, 0)
							local v680

							if not u26 then
								v680 = v679 * CFrame.new(0, 0.5, 0)
							else
								v680 = v679 * CFrame.new(n2 * n7, 0.5, 0)
							end

							u143.CFrame = v680
							v654.CFrame = v660
							u203.RenderStepped:Wait()
							v654.CFrame = CFrame2
							v654.Velocity = Velocity
							local u682 = v654
							local u683 = RotVelocity

							pcall(function()
								u682.RotVelocity = u683
							end)

							return
						end
					end)
					u138 = u203.RenderStepped:Connect(function()
						local Character6 = u202.Character
						local v685 = Character6 and Character6:FindFirstChild("Head")

						if v685 then
							local timestamp = tick()
							local v687 = timestamp - n8
							local v688 = math.min(v687, 0.05)

							n8 = timestamp

							local CFrame3 = v685.CFrame
							local LookVector = CFrame3.LookVector
							local Position = (CFrame3 * CFrame.new(-0.23, n1, -0.55)).Position
							local Position2 = (CFrame3 * CFrame.new(0.23, n1, -0.55)).Position

							if not u129 then
								local v693 = n7 - v688 / 0.4

								n7 = math.max(0, v693)
							else
								local v694 = n7 + v688 / 0.7

								n7 = math.min(1, v694)
							end

							if u206.camWeld then
								if not u26 then
									u206.camWeld.C0 = CFrame.new(0, 0.5, 0)
								else
									u206.camWeld.C0 = CFrame.new(n2 * n7, 0.5, 0)
								end
							end

							if not (n7 > 0) then
								if u133 then
									u133.origin:Destroy()
									u133.endpoint:Destroy()
									u133 = nil
								end

								if u134 then
									u134.origin:Destroy()
									u134.endpoint:Destroy()
									u134 = nil
								end

								u139 = nil

								return
							end

							if not u133 or not u134 then
								u133 = u207()
								u134 = u207()
							end

							local v695 = n7 ^ 3 * 1000
							local v696 = u191()
							local raycastResult = u204:Raycast(Position, LookVector * v695, v696)
							local raycastResult2 = u204:Raycast(Position2, LookVector * v695, v696)
							local v699 = raycastResult and raycastResult.Position or Position + LookVector * v695
							local v700 = raycastResult2 and raycastResult2.Position or Position2 + LookVector * v695

							u133.origin.Position = Position
							u133.endpoint.Position = v699
							u134.origin.Position = Position2
							u134.endpoint.Position = v700

							local v701 = nil

							if u129 then
								for _, v in ipairs({
									raycastResult,
									raycastResult2,
								}) do
									if v and v.Instance then
										local Model = v.Instance:FindFirstAncestorOfClass("Model")

										if Model then
											local player = u208:GetPlayerFromCharacter(Model)

											if player and u205(player) then
												v701 = player
											end

											u193(Model)
										end
									end
								end
							end

							if not v701 then
								if not u139 then
									u139 = nil

									return
								end

								if not (tick() - n10 < 0.7) then
									u139 = nil

									return
								end

								return
							end

							if v701 ~= u139 then
								u139 = v701
								n9 = tick()
							end

							n10 = tick()

							return
						end
					end)

					return
				end
			end

			local u210 = t3

			function u211(p28)
				if u137 then
					local v452 = u129

					u137 = false
					u129 = false
					n7 = 0
					t11 = {}

					if u133 then
						u133.origin:Destroy()
						u133.endpoint:Destroy()
						u133 = nil
					end

					if u134 then
						u134.origin:Destroy()
						u134.endpoint:Destroy()
						u134 = nil
					end

					if not v452 or not p28 then
						if u136 then
							task.cancel(u136)
							u136 = nil
						end

						if u135 then
							u135:Stop()
						end
					else
						if u136 then
							task.cancel(u136)
							u136 = nil
						end

						if u135 then
							u135.Looped = false
							u135.TimePosition = 1.65
							u135:Play()
						end
					end

					if u210.camWeld then
						u210.camWeld.C0 = CFrame.new(0, 0.5, 0)
					end

					if u138 then
						u138:Disconnect()
						u138 = nil
					end

					if u196 then
						u196:Disconnect()
						u196 = nil
					end

					if u143 then
						u143:Destroy()
						u143 = nil
					end

					u139 = nil

					return
				end
			end

			(function()
				if u107 then
					u107:Disconnect()
				end

				u107 = u150.Heartbeat:Connect(function()
					if u106 then
						local Character = u151.Character
						local v593 = Character and Character:FindFirstChild("HumanoidRootPart")

						if v593 then
							local spawn = task.spawn
							local u595 = v593

							spawn(function()
								local Velocity = u595.Velocity

								u595.Velocity = Vector3.new(450000000, 4500000000, 450000000)
								u150.RenderStepped:Wait()

								if u595 then
									u595.Velocity = Velocity
								end
							end)

							return
						end

						return
					end
				end)
			end)()

			local v212 = v175("RandVoiceBtn", UDim2.new(0, 305, 0, 70), "126139598282367", "Random Voicelines")
			local t14 = {}
			local t15 = {
				"you people should be thanking Christ that I am who and what I am, because you need ME!",
				"I am your lord, your saviour. I am your God.",
				"I don't make mistakes, i'm not just like the rest of you.. I'm stronger, I'm smarter... I'm better. I AM BETTER!!",
				"I'm the homelander and I can do whatever the #### I want",
				"the only man in the sky, is me",
				"I AM GOD!",
			}

			local u215 = v149

			v32(v212, function()
				local t16 = {}

				for _, v in ipairs(t15) do
					local v456 = false

					for _, v2 in ipairs(t14) do
						if v == v2 then
							v456 = true
						end
					end

					if not v456 then
						table.insert(t16, v)
					end
				end

				if #t16 == 0 then
					t16 = t15
				end

				if #t16 > 0 then
					local v459 = t16[math.random(1, #t16)]

					u215(v459)

					table.insert(t14, v459)

					if #t14 > 2 then
						table.remove(t14, 1)
					end
				end
			end, true)
		end

		local v216 = v175("MemeVoiceBtn", UDim2.new(0, 255, 0, 70), "78691293764532", "")
		local t17 = {
			"have you seen the memes about me?",
			"Ashley don't look at him look at me! ASHLEY! look. at. me.",
			"hahahaha.... HAHAHAHAHAHA",
			"yummers",
			"hahahaha, alriiight",
			"it was perfect. perfect, down to the last minute detail.",
		}
		local t18 = {}

		local u219 = v149

		v32(v216, function()
			local t19 = {}

			for _, v in ipairs(t17) do
				local v464 = false

				for _, v3 in ipairs(t18) do
					if v == v3 then
						v464 = true
					end
				end

				if not v464 then
					table.insert(t19, v)
				end
			end

			if #t19 == 0 then
				t19 = t17
			end

			if #t19 > 0 then
				local v467 = t19[math.random(1, #t19)]

				u219(v467)

				table.insert(t18, v467)

				if #t18 > 2 then
					table.remove(t18, 1)
				end
			end
		end, true)
		local u220 = v175("SpeedBtn", UDim2.new(0, 210, 0, 0), "129624286483532", "Normal", Frame3)

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Thickness = 1.5
		UIStroke.Color = Color3.fromRGB(0, 0, 0)
		UIStroke.Parent = u220.TextLabel
		local u223 = t2

		v32(u220, function()
			n5 = (n5 + 1) % 3
			u220.TextLabel.Text = u223[n5] == 1 and "Normal" or (u223[n5] == 0.5 and "Slow" or "Fast")
		end, true)
		local u224 = v175("LandBtn", UDim2.new(0, 195, 0, 145), nil, "Ground Land: ON")
		v32(u224, function()
			u105 = not u105
			u224.TextLabel.Text = "Ground Land: " .. (u105 and "ON" or "OFF")
		end, true)
		local u225 = v175("IdleAnimBtn", UDim2.new(0, 260, 0, 0), nil, "fly idle:\nidle V1", Frame3)
		u225.TextLabel.Text = "fly idle:\n" .. t5[n6].name
		local u227 = v168
		local u228 = v170

		v32(u225, function()
			n6 = n6 % #t5 + 1
			u225.TextLabel.Text = "fly idle:\n" .. t5[n6].name
			id = t5[n6].id

			if u97 and u113 == false and not u101 then
				u227(0.8)
				u228(id, true, 0.8)
			end
		end, true)
		local u229 = v175("FlingBtn", UDim2.new(0, 140, 0, 125), nil, "Fling: OFF")
		v32(u229, function()
			u106 = not u106
			u229.TextLabel.Text = "Fling: " .. (u106 and "ON" or "OFF")
		end, true)
		local u230 = false
		local t20 = {}
		local u232 = v175("XRayBtn", UDim2.new(0, 155, 0, 70), nil, "X-Ray: OFF")
		local u234 = Workspace

		v32(u232, function()
			u230 = not u230
			u232.TextLabel.Text = "X-Ray: " .. (u230 and "ON" or "OFF")

			if not u230 then
				for k, v in pairs(t20) do
					if k and k.Parent then
						k.Transparency = v
					end
				end

				t20 = {}

				return
			end

			t20 = {}

			for _, descendant in ipairs(u234:GetDescendants()) do
				if descendant:IsA("BasePart") then
					local v473 = false
					local Model = descendant:FindFirstAncestorOfClass("Model")

					if Model and Model:FindFirstChildOfClass("Humanoid") then
						v473 = true
					end

					if not v473 and descendant.Transparency < 1 then
						t20[descendant] = descendant.Transparency
						descendant.Transparency = 0.6
					end
				end
			end
		end, true)
		v235, v236 = v175("TryingFlyBtn", UDim2.new(0.95, -120, 0.45, 50), "127754775766218", "", ScreenGui)
		v235.Visible = false
		u237 = false
		u238 = nil

		local u239 = v236
		local u240 = v168
		local u241 = LocalPlayer

		v32(v235, function()
			if u97 then
				u237 = not u237
				u239.Color = u237 and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(60, 60, 60)

				if not u237 then
					if u238 then
						u238:Stop(0.2)
						u238 = nil
					end

					u113 = nil

					if u146 then
						u146(false)
					end
				else
					u240(0.2)

					local Character = u241.Character
					local v476 = Character and Character:FindFirstChildOfClass("Humanoid")

					if v476 then
						local Animation = Instance.new("Animation")

						Animation.AnimationId = "rbxassetid://89569027537835"
						u238 = v476:LoadAnimation(Animation)
						u238.Priority = Enum.AnimationPriority.Action4
						u238.Looped = true
						u238:Play(0.2)

						return
					end
				end

				return
			end
		end, true)
		v242, v243 = v175("CompoundBtn", UDim2.new(0.95, -70, 0.45, 50), "112901173121233", "", ScreenGui)
		v242.Visible = false
		u244 = false
		u245 = nil
		u246 = nil

		local u247 = v243
		local u248 = v168
		local u249 = LocalPlayer

		v32(v242, function()
			if u97 then
				u244 = not u244
				u247.Color = u244 and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(60, 60, 60)

				if not u244 then
					if u246 then
						task.cancel(u246)
						u246 = nil
					end

					if u245 then
						u245:Stop(0.2)
						u245 = nil
					end

					u113 = nil

					if u146 then
						u146(false)
					end
				else
					u248(0.2)

					local Character = u249.Character
					local v479 = Character and Character:FindFirstChildOfClass("Humanoid")

					if v479 then
						local Animation = Instance.new("Animation")

						Animation.AnimationId = "rbxassetid://82731245433251"
						u245 = v479:LoadAnimation(Animation)
						u245.Priority = Enum.AnimationPriority.Action4
						u245.Looped = false
						u245:Play(0.2)
						u246 = task.spawn(function()
							u245.TimePosition = 0
							u245:AdjustSpeed(1)

							local timestamp = tick()

							while u244 and tick() - timestamp < 3.5 do
								task.wait()
							end

							if u244 then
								while u244 do
									u245.TimePosition = 3.5
									u245:AdjustSpeed(-0.2)

									local timestamp2 = tick()

									while u244 and tick() - timestamp2 < 2.5 do
										task.wait()
									end

									if not u244 then
										return
									end
								end

								return
							end
						end)

						return
					end
				end

				return
			end
		end, true)

		local v250

		v250, v251 = v175("LaserEyesBtn", UDim2.new(0, 205, 0, 70), "137555465918674", "")

		local u252 = v251
		local u253 = v209

		v32(v250, function()
			if not u137 then
				u253()
				u129 = true

				if u136 then
					task.cancel(u136)
					u136 = nil
				end

				if u135 then
					u136 = task.spawn(function()
						u135.TimePosition = 0
						u135.Looped = false
						u135:Play()

						local timestamp = tick()

						repeat
							task.wait()
						until not u135.IsPlaying or u135.TimePosition >= 1.5 or tick() - timestamp > 5

						while u129 and u137 do
							u135.TimePosition = 1.1
							u135.Looped = false

							if not u135.IsPlaying then
								u135:Play()
							end

							local timestamp3 = tick()

							repeat
								task.wait()
							until not u137 or not u129 or u135.TimePosition >= 1.5 or tick() - timestamp3 > 2

							if not u129 or not u137 then
								return
							end
						end
					end)
				end

				u252.Color = Color3.fromRGB(180, 0, 0)

				return
			end

			u129 = not u129

			if not u129 then
				if u136 then
					task.cancel(u136)
					u136 = nil
				end

				if u135 then
					u135.Looped = false
					u135.TimePosition = 1.65
					u135:Play()
				end
			else
				if u136 then
					task.cancel(u136)
					u136 = nil
				end

				if u135 then
					u136 = task.spawn(function()
						u135.TimePosition = 0
						u135.Looped = false
						u135:Play()

						local timestamp = tick()

						repeat
							task.wait()
						until not u135.IsPlaying or u135.TimePosition >= 1.5 or tick() - timestamp > 5

						while u129 and u137 do
							u135.TimePosition = 1.1
							u135.Looped = false

							if not u135.IsPlaying then
								u135:Play()
							end

							local timestamp4 = tick()

							repeat
								task.wait()
							until not u137 or not u129 or u135.TimePosition >= 1.5 or tick() - timestamp4 > 2

							if not u129 or not u137 then
								return
							end
						end
					end)
				end
			end

			u252.Color = u129 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
		end, true)
	end

	task.spawn(function()
		while true do
			if u101 then
				if u184 then
					u184 = false

					if u176 then
						u176:Stop(0.3)
					end

					if u177 then
						u177:Stop(0.3)
					end

					if u178 then
						u178:Stop(0.3)
					end

					if u179 then
						u179:Stop(0.3)
					end

					if u180 then
						u180:Stop(0.3)
					end

					if u181 then
						u181:Stop(0.3)
					end

					if u182 then
						u182:Stop(0.3)
					end
				end

				task.wait()
			else
				task.wait()
			end
		end
	end)
	local n13 = 0
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or u101 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			n13 = tick()
		end
	end)
	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed or u101 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if tick() - n13 <= 0.2 then
			end
		end
	end)
	local t21 = {}

	local u256 = LocalPlayer

	function rebuildNoclipCache()
		t21 = {}

		if u256.Character then
			for _, descendant in ipairs(u256.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					table.insert(t21, descendant)
				end
			end
		end
	end

	local u257 = RunService
	local u258 = LocalPlayer

	function u259(p29)
		u95 = p29

		if u96 then
			u96:Disconnect()
			u96 = nil
		end

		if not p29 then
			if u258.Character then
				local HumanoidRootPart = u258.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					local _pcall = pcall
					local u491 = HumanoidRootPart

					pcall(function()
						u491.CanCollide = true
					end)
				end
			end

			return
		end

		rebuildNoclipCache()
		u96 = u257.RenderStepped:Connect(function()
			for _, v in ipairs(t21) do
				v.CanCollide = false
			end
		end)
	end

	local u260 = v168
	local u261 = v170
	local u262 = Workspace
	local u263 = RunService

	function u146(p30)
		if u101 then
			return
		end

		u127 = p30

		if p30 ~= u113 then
			u113 = p30

			if not p30 then
				u260(0.8)
				u261(id, true, 0.8)
				n3 = 1
				n4 = 1

				return
			end

			u260(0.4)
			u118 = task.spawn(function()
				if n4 ~= 3 then
					n4 = 1

					local timestamp = tick()
					local n14 = 0.225
					local v716 = u261("rbxassetid://114833664438028", false, 0.2)

					if v716 then
						v716:AdjustSpeed(2)
					end

					while n14 > tick() - timestamp do
						n3 = 1 + (tick() - timestamp) / n14 * 1
						task.wait()
					end

					if v716 then
						v716:Stop(0.2)
					end

					n4 = 2

					local timestamp5 = tick()
					local n15 = 0.33
					local v719 = u261("rbxassetid://114833664438028", false, 0.2)

					if v719 then
						v719:AdjustSpeed(2)
					end

					while n15 > tick() - timestamp5 do
						n3 = 2 + (tick() - timestamp5) / n15 * 3
						task.wait()
					end

					if v719 then
						v719:Stop(0.3)
					end

					n4 = 3

					local v720 = u261(t10[1].id, true, 0.3)

					if v720 then
						v720.Priority = Enum.AnimationPriority.Action2
						v720.TimePosition = 1
						v720:AdjustSpeed(8)

						local delay = task.delay
						local u722 = v720

						delay(0.1, function()
							if u722 then
								u722:AdjustSpeed(1)
							end
						end)
					end

					local CurrentCamera = u262.CurrentCamera
					local spawn = task.spawn
					local u725 = CurrentCamera

					spawn(function()
						task.wait(0.5)

						while u97 and n4 == 3 and not u101 do
							local v772 = 0.5 + n3 / 10 * 0.7
							local vector3 =
								Vector3.new(math.random(-100, 100) / 1000 * v772, math.random(-100, 100) / 1000 * v772, math.random(-100, 100) / 1000 * v772)

							u725.CFrame = u725.CFrame * CFrame.new(vector3)
							u263.RenderStepped:Wait()
						end
					end)

					local timestamp6 = tick()

					while u113 == true do
						local v727 = (tick() - timestamp6) / 5

						currentStage3Multiplier = 5 + math.min(v727, 1) * 5
						n3 = currentStage3Multiplier
						task.wait()
					end

					return
				end

				local v728 = u261(t10[1].id, true, 0.3)

				if v728 then
					v728.Priority = Enum.AnimationPriority.Action2
					v728.TimePosition = 1
					v728:AdjustSpeed(8)

					local delay = task.delay
					local u730 = v728

					delay(0.1, function()
						if u730 then
							u730:AdjustSpeed(1)
						end
					end)
				end

				local CurrentCamera = u262.CurrentCamera
				local spawn = task.spawn
				local u733 = CurrentCamera

				spawn(function()
					task.wait(0.5)

					while u97 and n4 == 3 and not u101 do
						local v770 = 0.5 + n3 / 10 * 0.7
						local vector3 =
							Vector3.new(math.random(-100, 100) / 1000 * v770, math.random(-100, 100) / 1000 * v770, math.random(-100, 100) / 1000 * v770)

						u733.CFrame = u733.CFrame * CFrame.new(vector3)
						u263.RenderStepped:Wait()
					end
				end)
			end)

			return
		end
	end

	local u264 = LocalPlayer
	local u265 = Workspace
	local u266 = UserInputService

	function u267()
		local Character = u264.Character
		local v494 = Character and Character:FindFirstChildOfClass("Humanoid")
		local CurrentCamera = u265.CurrentCamera

		if v494 and CurrentCamera then
			local vector3 = Vector3.new()
			local v497 = false

			if u266:IsKeyDown(Enum.KeyCode.W) then
				vector3 = vector3 + CurrentCamera.CFrame.LookVector
				v497 = true
			end

			if u266:IsKeyDown(Enum.KeyCode.S) then
				vector3 = vector3 - CurrentCamera.CFrame.LookVector
				v497 = true
			end

			if u266:IsKeyDown(Enum.KeyCode.A) then
				vector3 = vector3 - CurrentCamera.CFrame.RightVector
				v497 = true
			end

			if u266:IsKeyDown(Enum.KeyCode.D) then
				vector3 = vector3 + CurrentCamera.CFrame.RightVector
				v497 = true
			end

			local vector3_2 = Vector3.new(0, 0, 0)

			if u266:IsKeyDown(Enum.KeyCode.Space) then
				local v499 = n4 == 3 and 2 or 1

				vector3_2 = vector3_2 + Vector3.new(0, 1 * v499, 0)
				v497 = true
			end

			if u266:IsKeyDown(Enum.KeyCode.LeftShift) then
				local v500 = n4 == 3 and 10 or 1

				vector3_2 = vector3_2 - Vector3.new(0, 1 * v500, 0)
				v497 = true
			end

			local v501 = vector3 + vector3_2

			if not v497 and v494.MoveDirection.Magnitude > 0.05 then
				local MoveDirection = v494.MoveDirection
				local Unit = Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z).Unit
				local Unit2 = Vector3.new(CurrentCamera.CFrame.RightVector.X, 0, CurrentCamera.CFrame.RightVector.Z).Unit
				local v505 = MoveDirection:Dot(Unit)
				local v506 = MoveDirection:Dot(Unit2)

				v501 = v501 + CurrentCamera.CFrame.RightVector * v506 + CurrentCamera.CFrame.LookVector * v505
			end

			return v501.Magnitude > 0 and v501.Unit or Vector3.new()
		end

		return Vector3.new()
	end

	local u268 = v168
	local u269 = LocalPlayer
	local u270 = Debris
	local u271 = TweenService
	local u272 = Workspace
	local u273 = RunService
	local u274 = v170

	function u275(p31, p32)
		if u101 or u102 or not u105 then
			return
		end

		if n4 >= 2 then
			u101 = true
			u102 = true
			u109 = nil
			u268(0.1)

			local Character = u269.Character
			local v510 = Character and Character:FindFirstChild("HumanoidRootPart")
			local v511 = Character and Character:FindFirstChildOfClass("Humanoid")
			local v512 = p32 and p32.Color or Color3.fromRGB(100, 100, 100)
			local u513 = p32 and p32.Material or Enum.Material.Plastic
			local v514 = n3 / 5
			local spawn = task.spawn
			local u516 = v514
			local u517 = p31
			local u518 = v512

			spawn(function()
				local v734 = 15 * u516
				local v735 = math.floor(v734)

				for i = 1, v735 do
					local v737 = i / v735 * 3.141592653589793 * 2
					local v738 = math.random(4, 12) * u516
					local vector3 = Vector3.new(math.cos(v737) * v738, 0, math.sin(v737) * v738)
					local v740 = math.random(100, 300) / 100 * u516
					local Part = Instance.new("Part")

					Part.Size = Vector3.new(v740, v740, v740)
					Part.Position = u517 + vector3 + Vector3.new(0, -1, 0)
					Part.Color = u518
					Part.Material = u513
					Part.CanCollide = false
					Part.Anchored = false
					Part.Parent = workspace

					local v742 = 30 * u516

					Part.AssemblyLinearVelocity = Vector3.new(0, v742, 0) + vector3.Unit * (10 * u516)
					Part.AssemblyAngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
					u270:AddItem(Part, 2.5)

					local spawn2 = task.spawn
					local u744 = Part

					spawn2(function()
						task.wait(1.5)
						u271:Create(u744, TweenInfo.new(1), {
							Transparency = 1,
						}):Play()
					end)
				end
			end)

			local v519 = v514 * 1.5
			local CurrentCamera = u272.CurrentCamera
			local timestamp = tick()
			local spawn3 = task.spawn
			local u523 = timestamp
			local n16 = 0.8
			local u525 = v519
			local u526 = CurrentCamera

			spawn3(function()
				while tick() - u523 < n16 do
					local vector3 =
						Vector3.new(math.random(-100, 100) / 1000 * u525, math.random(-100, 100) / 1000 * u525, math.random(-100, 100) / 1000 * u525)

					u526.CFrame = u526.CFrame * CFrame.new(vector3)
					u273.RenderStepped:Wait()
				end
			end)

			if u115 then
				u115.velocity = Vector3.new(0, 0, 0)
			end

			if v510 then
				v510.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v510.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end

			if v510 and v511 then
				local v527 = v510.Size.Y / 2 + v511.HipHeight
				local v528 = p31.Y + v527
				local LookVector = v510.CFrame.LookVector
				local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
				local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local cFrame = CFrame.lookAt(Vector3.new(v510.Position.X, v528, v510.Position.Z), Vector3.new(v510.Position.X, v528, v510.Position.Z) + Unit)

				u271:Create(v510, tweenInfo, {
					CFrame = cFrame,
				}):Play()
				task.wait(0.08)
				v510.CFrame = cFrame
			end

			local v533 = u274("rbxassetid://79698004825744", false, 0.1)

			if v533 then
				v533:AdjustSpeed(2)

				local v534 = v533.Length / 2 - 0.5
				local v535 = math.max(0, v534)
				local timestamp7 = tick()

				while v535 > tick() - timestamp7 do
					if not u97 then
						v533:Stop(0.1)

						if v511 then
							v511.AutoRotate = true
							v511.PlatformStand = false
						end

						local CurrentCamera2 = u272.CurrentCamera

						if CurrentCamera2 and v511 then
							CurrentCamera2.CameraSubject = v511
							CurrentCamera2.CameraType = Enum.CameraType.Custom
						end

						u268(0)
						u101 = false
						u113 = nil
						task.delay(0.3, function()
							u102 = false
						end)

						return
					end

					task.wait()
				end

				if u97 then
					n4 = 1
					u274(id, true, 0.5)

					local timestamp8 = tick()

					while tick() - timestamp8 < 0.5 do
						if not u97 then
							if v511 then
								v511.AutoRotate = true
								v511.PlatformStand = false
							end

							local CurrentCamera3 = u272.CurrentCamera

							if CurrentCamera3 and v511 then
								CurrentCamera3.CameraSubject = v511
								CurrentCamera3.CameraType = Enum.CameraType.Custom
							end

							u268(0)
							u101 = false
							u113 = nil
							task.delay(0.3, function()
								u102 = false
							end)

							return
						end

						task.wait()
					end
				end
			end

			u101 = false
			u113 = nil
			task.delay(0.3, function()
				u102 = false
			end)

			return
		end
	end

	local u276 = t3
	local u277 = v168
	local u278 = LocalPlayer
	local u279 = Workspace
	local u280 = TweenService

	function u281()
		if u114 then
			u114:Destroy()
		end

		if u115 then
			u115:Destroy()
		end

		if u276.camPart then
			u276.camPart:Destroy()
		end

		u277()
		u113 = nil
		n3 = 1
		n4 = 1
		u109 = nil
		u108 = false

		if u98 then
			u98:Destroy()
			u98 = nil
		end

		local Character = u278.Character
		local v541 = Character and Character:FindFirstChildOfClass("Humanoid")
		local CurrentCamera = u279.CurrentCamera

		if CurrentCamera and v541 then
			CurrentCamera.CameraSubject = v541
			CurrentCamera.CameraType = Enum.CameraType.Custom
			v541.AutoRotate = true
			v541.PlatformStand = false
			v541.CameraOffset = Vector3.new(0, 0, 0)
			u280:Create(CurrentCamera, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				FieldOfView = 70,
			}):Play()
		end

		if u276.flyLoop then
			u276.flyLoop:Disconnect()
			u276.flyLoop = nil
		end

		u211(false)
	end

	u282 = LocalPlayer
	u283 = Workspace
	u284 = RunService
	u285 = t3
end

local u286 = Players
local u287 = t2
local u288 = TweenService
local u289 = v209

local function u290()
	local Character = u282.Character
	local v544 = Character and Character:FindFirstChildOfClass("Humanoid")
	local v545 = Character and Character:FindFirstChild("HumanoidRootPart")
	local v546 = Character and Character:FindFirstChild("Head")
	local CurrentCamera = u283.CurrentCamera

	if v545 and v544 and CurrentCamera then
		if not u104 then
			local spawn = task.spawn
			local u549 = v545
			local u550 = v544

			spawn(function()
				u549.Anchored = true

				local Animation = Instance.new("Animation")

				Animation.AnimationId = "rbxassetid://79698004825744"

				local track = u550:LoadAnimation(Animation)

				track:Play()
				track:Stop()
				u284.Heartbeat:Wait()
				u549.Anchored = false
				u104 = true
			end)
		end

		v544.AutoRotate = false
		v544.PlatformStand = true

		if not u98 then
			u98 = Instance.new("Part")
			u98.Name = "MobileFlyGroundPart"
			u98.Size = Vector3.new(10, 10, 10)
			u98.Transparency = 1
			u98.CanCollide = false
			u98.Anchored = false
			u98.Massless = true
			u98.Parent = workspace
		end

		u114 = Instance.new("BodyGyro")
		u114.P = 40000
		u114.D = 500
		u114.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
		u114.Parent = v545
		u115 = Instance.new("BodyVelocity")
		u115.velocity = Vector3.zero
		u115.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
		u115.Parent = v545

		if v546 then
			local Part = Instance.new("Part")

			Part.Name = "CamFocus"
			Part.Transparency = 1
			Part.CanCollide = false
			Part.Massless = true
			Part.Size = Vector3.new(0.1, 0.1, 0.1)
			Part.Parent = Character

			local Weld = Instance.new("Weld")

			Weld.Part0 = v546
			Weld.Part1 = Part
			Weld.C0 = CFrame.new(0, 0.5, 0)
			Weld.Parent = Part
			CurrentCamera.CameraSubject = Part
			u285.camPart = Part
			u285.camWeld = Weld
		end
		local RenderStepped = u284.RenderStepped
		local u555 = v545
		local u556 = CurrentCamera
		local u557 = Character

		u285.flyLoop = RenderStepped:Connect(function(p33)
			if u97 and u555 and u556 and not u101 and not u108 then
				local v749 = u267()
				local t22 = {}

				t22[1] = u557
				t22[2] = u98

				for _, player in ipairs(u286:GetPlayers()) do
					if player.Character then
						local Character7 = player.Character

						table.insert(t22, Character7)
					end
				end

				local raycastParams = RaycastParams.new()

				raycastParams.FilterDescendantsInstances = t22
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local v757 = u115.velocity.Y < -5
				if not v757 then
					u109 = nil
				elseif u109 == nil then
					local raycastResult = workspace:Raycast(u555.Position, Vector3.new(0, -500, 0), raycastParams)

					u109 = raycastResult and u555.Position.Y - raycastResult.Position.Y or 999
				end

				local v759 = u115.velocity.Magnitude * p33 * 0.75 + 1
				local v760 = math.max(3, v759)
				local raycastResult = workspace:Raycast(u555.Position, Vector3.new(0, -v760, 0), raycastParams)

				if
					not raycastResult
					or not raycastResult.Instance
					or not u105
					or not v757
					or not raycastResult.Instance.CanCollide
					or not (raycastResult.Instance.Transparency <= 0.75)
					or not (n4 >= 2)
					or not (u115.velocity.Magnitude > 30)
					or not ((u109 or 0) >= 5)
				then
					if not (v749.Magnitude > 0) then
						u115.velocity = Vector3.zero

						if not u29 then
							if u23 then
								u114.CFrame = u114.CFrame:Lerp(CFrame.lookAt(u555.Position, u555.Position + u556.CFrame.LookVector), 0.1)
							end
						else
							u114.CFrame = u114.CFrame:Lerp(CFrame.lookAt(u555.Position, u555.Position + u556.CFrame.LookVector), 0.1)
						end

						u146(false)

						if u556.FieldOfView ~= 70 then
							u288:Create(u556, TweenInfo.new(0.7), {
								FieldOfView = 70,
							}):Play()
						end
					else
						u115.velocity = v749 * (33.8 * n3 * u287[n5])

						if not u29 then
							if not u23 then
								local vector3 = Vector3.new(v749.X, 0, v749.Z)

								if vector3.Magnitude > 0.05 then
									u114.CFrame = u114.CFrame:Lerp(CFrame.lookAt(u555.Position, u555.Position + vector3.Unit), 0.15)
								end
							else
								u114.CFrame = u114.CFrame:Lerp(CFrame.lookAt(u555.Position, u555.Position + v749), 0.15)
							end
						else
							u114.CFrame = u114.CFrame:Lerp(CFrame.lookAt(u555.Position, u555.Position + u556.CFrame.LookVector), 0.15)
						end

						u146(true)

						if n4 == 3 then
							if u556.FieldOfView < 89.9 then
								u288:Create(u556, TweenInfo.new(0.35), {
									FieldOfView = 90,
								}):Play()
							end
						elseif u556.FieldOfView > 70.1 then
							u288:Create(u556, TweenInfo.new(0.7), {
								FieldOfView = 70,
							}):Play()
						end
					end

					pcall(function()
						if u98 and u555 then
							u98.CFrame = u555.CFrame * CFrame.new(0, -(u555.Size.Y / 2) - 5, 0)
						end
					end)

					return
				end

				u275(raycastResult.Position, raycastResult.Instance)

				return
			end
		end)
		u146(false)
		u289()

		return
	end
end
local MouseButton1Click = TextButton.MouseButton1Click
local u296 = Frame2
local u297 = Frame3
local u298 = v235
local u299 = v242

MouseButton1Click:Connect(function()
	u25 = not u25
	TextButton.Text = u25 and "show buttons" or "hide buttons"

	if not u25 then
		if u97 then
			u296.Visible = true
			u297.Visible = true
			u298.Visible = true
			u299.Visible = true
		end

		return
	end

	u296.Visible = false
	u297.Visible = false
	u298.Visible = false
	u299.Visible = false
end)

local u300 = Frame2
local u301 = Frame3
local u302 = v235
local u303 = v242
local u304 = v236
local u305 = v243
local u306 = v251
local u307 = Frame

v32(ImageButton, function()
	u97 = not u97
	TextLabel.Text = "Homelander: " .. (u97 and "ON" or "OFF")

	if not u97 then
		u101 = false
	end

	if not u97 then
		u300.Visible = false
		u301.Visible = false
		u302.Visible = false
		u303.Visible = false
		ImageButton2.Visible = false
	else
		if not u25 then
			u300.Visible = true
			u301.Visible = true
			u302.Visible = true
			u303.Visible = true
		end

		ImageButton2.Visible = true
	end

	if not u97 then
		if u237 then
			u237 = false

			if u238 then
				u238:Stop(0.2)
				u238 = nil
			end

			u304.Color = Color3.fromRGB(60, 60, 60)
		end

		if u244 then
			u244 = false

			if u246 then
				task.cancel(u246)
				u246 = nil
			end

			if u245 then
				u245:Stop(0.2)
				u245 = nil
			end

			u305.Color = Color3.fromRGB(60, 60, 60)
		end

		if u129 then
			u129 = false
			u306.Color = Color3.fromRGB(60, 60, 60)
		end

		u281()
		u259(u99)
		u307.Visible = false

		return
	end

	u99 = u95
	u259(true)
	u290()
end, false)
LocalPlayer.CharacterAdded:Connect(function(character)
	local HumanoidRootPart

	rebuildNoclipCache()

	if u97 then
		u281()
		task.wait(0.2)

		if u97 then
			u259(true)
			u290()
		end
	end

	if game.PlaceId == 189707 then
		local RunService3 = game:GetService("RunService")
		local Heartbeat = RunService3.Heartbeat
		local RenderStepped = RunService3.RenderStepped
		local _ = game.Players.LocalPlayer
		local zero = Vector3.zero

		HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

		if HumanoidRootPart then
			local connection = nil
			local u569 = zero
			local u570 = RenderStepped
			Heartbeat:Connect(function()
				if not HumanoidRootPart.Parent then
					connection:Disconnect()
				end

				local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

				HumanoidRootPart.AssemblyLinearVelocity = u569
				u570:Wait()
				HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
			end)
		end
	end
end)

local t23 = {
	["1"] = Instance.new("ScreenGui", u16),
}
t23["2"] = Instance.new("Frame", t23["1"])
t23["2"].BackgroundColor3 = Color3.fromRGB(254, 199, 255)
t23["2"].Size = UDim2.new(0, 316, 0, 128)
t23["2"].Position = UDim2.new(0.5, -150, 0.5, -50)
t23["5"] = Instance.new("ImageLabel", t23["2"])
t23["5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t23["5"].Size = UDim2.new(0, 316, 0, 142)
t23["5"].Position = UDim2.new(0, 0, -0.10938, 0)

local TextBox = Instance.new("TextBox", t23["5"])

TextBox.PlaceholderText = "shortened name/display"
TextBox.Size = UDim2.new(0.9, -20, 0.3, -10)
TextBox.Position = UDim2.new(0.05, 0, 0.3, 0)
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(113, 27, 255)
TextBox.TextColor3 = Color3.new(1, 1, 1)

local TextButton12 = Instance.new("TextButton", t23["5"])

TextButton12.Size = UDim2.new(0.4, 0, 0.25, 0)
TextButton12.Position = UDim2.new(0.3, 0, 0.65, 0)
TextButton12.Text = "banish >:3"
TextButton12.BackgroundColor3 = Color3.fromRGB(255, 232, 204)

local u311 = Players
local u312 = LocalPlayer

local function u313(p34)
	local v572 = p34:lower()

	for _, player in pairs(u311:GetPlayers()) do
		if player ~= u312 and (player.Name:lower():match("^" .. v572) or player.DisplayName:lower():match("^" .. v572)) then
			return player
		end
	end
end

local MouseButton1Click10 = TextButton12.MouseButton1Click
local u315 = LocalPlayer
local u316 = RunService

MouseButton1Click10:Connect(function()
	local v575 = u313(TextBox.Text)

	if v575 then
		local Character = u315.Character
		local v577 = Character and Character:FindFirstChild("HumanoidRootPart")
		local v578 = v575.Character and v575.Character:FindFirstChild("HumanoidRootPart")

		if v577 and v578 then
			local CFrame4 = v577.CFrame

			workspace.FallenPartsDestroyHeight = -99999
			local BodyVelocity = Instance.new("BodyVelocity", v577)

			BodyVelocity.Velocity = Vector3.new(450000000, 4500000000, 450000000)
			BodyVelocity.MaxForce = Vector3.new(1e999, 1e999, 1e999)

			local timestamp = tick()

			while tick() - timestamp < 1.5 do
				v577.CFrame = v578.CFrame
				u316.Heartbeat:Wait()
			end

			BodyVelocity:Destroy()
			v577.CFrame = CFrame4
			workspace.FallenPartsDestroyHeight = u12.FPDH
		end
	end
end)
