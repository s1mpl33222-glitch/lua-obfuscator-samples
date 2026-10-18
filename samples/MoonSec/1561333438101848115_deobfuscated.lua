local function v1()
	if not isfolder("CodeQuestJsSaves") then
		makefolder("CodeQuestJsSaves")
	end

	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local TextBox = Instance.new("TextBox")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TextButton = Instance.new("TextButton")
	local TextButton2 = Instance.new("TextButton")

	ScreenGui.Parent = gethui()
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.543589771, 0, 0.228828833, 0)
	Frame.Size = UDim2.new(0.299145311, 0, 0.344144136, 0)
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.9
	UIStroke.Parent = Frame
	TextBox.Name = "name"
	TextBox.Parent = Frame
	TextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.182857141, 0, 0.209424078, 0)
	TextBox.Size = UDim2.new(0.631428599, 0, 0.188481674, 0)
	TextBox.Font = Enum.Font.SourceSans
	TextBox.PlaceholderColor3 = Color3.fromRGB(138, 138, 138)
	TextBox.Text = "build"
	TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.TextSize = 14
	TextBox.ClearTextOnFocus = false
	UICorner.Parent = TextBox
	TextButton.Name = "save"
	TextButton.Parent = Frame
	TextButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.0857142881, 0, 0.623036623, 0)
	TextButton.Size = UDim2.new(0.288571417, 0, 0.204188481, 0)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.Text = "Save"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextScaled = true
	TextButton.TextSize = 14
	TextButton.TextWrapped = true
	TextButton2.Name = "build"
	TextButton2.Parent = Frame
	TextButton2.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	TextButton2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextButton2.BorderSizePixel = 0
	TextButton2.Position = UDim2.new(0.625714302, 0, 0.623036623, 0)
	TextButton2.Size = UDim2.new(0.288571417, 0, 0.204188481, 0)
	TextButton2.Font = Enum.Font.SourceSans
	TextButton2.Text = "Build"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.TextScaled = true
	TextButton2.TextSize = 14
	TextButton2.TextWrapped = true

	local v9 = cloneref(game:GetService("UserInputService"))
	local v10 = cloneref(game:GetService("TweenService"))

	cloneref(game:GetService("TextService"))
	cloneref(game:GetService("HttpService"))

	local n1 = 0.25

	ScreenGui = function(p1, p2)
		local Position = nil
		local u13 = nil
		local Position2 = nil

		local function v15(p3)
			local v16 = p3.Position - Position2
			local v17 = v10

			v16 = {
				["Position"] = UDim2.new(Position.X.Scale, Position.X.Offset + v16.X, Position.Y.Scale, Position.Y.Offset + v16.Y)
			}
			v17:Create(p1, TweenInfo.new(n1), v16):Play()
		end

		(p2 or p1).InputBegan:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			u13 = true
			Position2 = input.Position
			Position = p1.Position
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End then
					return
				end

				u13 = false
			end)
		end)
		v9.InputChanged:Connect(function(input)
			if not ((input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and u13) then
				return
			end

			v15(input)
		end)
	end
	ScreenGui(Frame)
	ScreenGui(Frame, TextButton)
	ScreenGui(Frame, TextButton2)
	ScreenGui = function()
		local TweenService = game:GetService("TweenService")
		local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

		local function _(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28)
			local s1

			if p4 == "Part" then
				s1 = "Part"
			elseif p4 == "SpawnLocation" then
				s1 = "Spawn"
			elseif p4 == "Truss" then
				s1 = "Truss"
			elseif p4 == "Sound" then
				s1 = "Sound"
			elseif p4 == "Touch" then
				s1 = "Touch"
			elseif p4 == "Teleport" then
				s1 = "Teleport"
			elseif p4 == "Damage" then
				s1 = "Damage"
			elseif p4 == "Image" then
				s1 = "Image"
			elseif p4 == "MovesetClear" then
				s1 = "MovesetClear"
			elseif p4 == "Moveset" then
				s1 = "Moveset"
			elseif p4 == "Light" then
				s1 = "Light"
			elseif p4 == "Boost" then
				s1 = "Boost"
			elseif p4 == "And" then
				s1 = "And"
			elseif p4 == "Not" then
				s1 = "Not"
			else
				if p4 ~= "Timer" then
					return
				end

				s1 = "Timer"
			end

			local t1 = { "Create", s1, Vector3.new(p5.x, p5.y, p5.z) }

			game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(t1))
			wait(0.5)
			t1 = Vector3.new(p5.x, p5.y, p5.z)
			Vector3.new(p6.x, p6.y, p6.z)

			local vector3 = p15 and Vector3.new(p15.x, p15.y + 10, p15.z) or false
			local name = p4 .. "_" .. math.random(100, 1000000)

			if s1 == "Touch" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"",
					p25
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Sound" then
				wait(1)
				game.workspace.Logic[s1].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"SoundId",
					p16
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"SoundVol",
					p17
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"SoundRange",
					p18
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"SoundLoop",
					p19
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Teleport" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = CFrame.new(vector3)
				t1 = TweenService:Create(HumanoidRootPart, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
					["CFrame"] = s1
				})
				t1:Play()
				t1.Completed:Wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(s1)
				wait(10)
				s1 = { "LogicProp", game.workspace.Logic[name] or game.workspace.Logic[p4], "Destination" }
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Damage" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Damage",
					p20
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Image" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Image",
					p21
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "MovesetClear" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Moveset" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"MoveName",
					p24
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Cooldown",
					p22
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Key",
					p23
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Light" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p25,
					p14
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Flip",
					p26
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Boost" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				wait(1)
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Boost",
					Vector3.new(p27.x, p27.y, p27.z)
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Boost" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					""
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				wait(1)
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Boost",
					Vector3.new(p27.x, p27.y, p27.z)
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "And" or s1 == "Not" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					p25
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			elseif s1 == "Timer" then
				wait(1)
				game.workspace.Logic[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Logic[name] or game.workspace.Logic[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Inputs",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					p14,
					p25
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"LogicProp",
					game.workspace.Logic[name] or game.workspace.Logic[p4],
					"Delay",
					p28
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			else
				game.workspace.Map.Destructible.Buildable[p4].Name = name
				s1 = {
					"Move",
					{
						{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4], CFrame.new(t1) * CFrame.Angles(math.rad(p12.x), math.rad(p12.y), math.rad(p12.z)), Vector3.new(p6.x, p6.y, p6.z) }
					}
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Transparency",
					{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					p7
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Color",
					{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					Color3.fromRGB(p9.r * 255, p9.g * 255, p9.b * 255)
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Material",
					{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					Enum.Material[p8]
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Collide",
					{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					p10,
					p13
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					[1] = "Collide",
					[2] = { game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					[4] = p10
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
				s1 = {
					"Breakable",
					{ game.workspace.Map.Destructible.Buildable[name] or game.workspace.Map.Destructible.Buildable[p4] },
					p11
				}
				game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer(unpack(s1))
			end
		end

		local _ = game:GetService("HttpService")
		local v26 = "CodeQuestJsSaves/" .. tostring(TextBox.Text) .. ".txt"

		if not isfile(v26) then
			TextBox.Text = "Invalid name"

			return
		end
	end
	Frame = function()
		local HttpService = game:GetService("HttpService")
		local Buildable = game.workspace.Map.Destructible.Buildable
		local Buildable2 = game.workspace.Map.Core.Buildable
		local Logic = game.workspace.Logic
		local v31, Rotation

		Buildable, v31, Rotation = ipairs(Buildable:GetChildren())

		local n2 = 0
		local t2 = {}
		local Rotation2, Rotation3

		while true do
			Rotation, Rotation2 = Buildable(v31, Rotation)

			if Rotation == nil then
				break
			end

			n2 = n2 + 1

			if n2 % 1000 == 0 then
				print(n2)
			end

			Rotation3 = Rotation2.Rotation
			table.insert(t2, {
				["Name"] = Rotation2.Name,
				["Position"] = {
					["x"] = Rotation2.Position.X,
					["y"] = Rotation2.Position.Y,
					["z"] = Rotation2.Position.Z
				},
				["Size"] = {
					["x"] = Rotation2.Size.X,
					["y"] = Rotation2.Size.Y,
					["z"] = Rotation2.Size.Z
				},
				["Transparency"] = Rotation2.Transparency,
				["Material"] = Rotation2.Material.Name,
				["Color"] = {
					["r"] = Rotation2.Color.R,
					["g"] = Rotation2.Color.G,
					["b"] = Rotation2.Color.B
				},
				["CanCollide"] = Rotation2.CanCollide,
				["Break"] = true,
				["Rotation"] = {
					["x"] = Rotation3.X,
					["y"] = Rotation3.Y,
					["z"] = Rotation3.Z
				},
				["cast"] = Rotation2.CastShadow,
				["Id"] = false,
				["telep"] = false
			})
			task.wait()
		end

		Buildable, Buildable2, v31 = ipairs(Buildable2:GetChildren())

		while true do
			v31, Rotation = Buildable(Buildable2, v31)

			if v31 == nil then
				break
			end

			n2 = n2 + 1

			if n2 % 1000 == 0 then
				print(n2)
			end

			Rotation2 = Rotation.Rotation
			table.insert(t2, {
				["Name"] = Rotation.Name,
				["Position"] = {
					["x"] = Rotation.Position.X,
					["y"] = Rotation.Position.Y,
					["z"] = Rotation.Position.Z
				},
				["Size"] = {
					["x"] = Rotation.Size.X,
					["y"] = Rotation.Size.Y,
					["z"] = Rotation.Size.Z
				},
				["Transparency"] = Rotation.Transparency,
				["Material"] = Rotation.Material.Name,
				["Color"] = {
					["r"] = Rotation.Color.R,
					["g"] = Rotation.Color.G,
					["b"] = Rotation.Color.B
				},
				["CanCollide"] = Rotation.CanCollide,
				["Break"] = false,
				["Rotation"] = {
					["x"] = Rotation2.X,
					["y"] = Rotation2.Y,
					["z"] = Rotation2.Z
				},
				["cast"] = Rotation.CastShadow,
				["Id"] = false,
				["telep"] = false
			})
			task.wait()
		end

		Buildable, Buildable2, Logic = ipairs(Logic:GetChildren())

		while true do
			Logic, v31 = Buildable(Buildable2, Logic)

			if Logic == nil then
				break
			end

			n2 = n2 + 1

			if n2 % 1000 == 0 then
				print(n2)
			end

			Rotation = v31.Rotation
			Rotation2 = table.insert
			Rotation = {
				["Name"] = v31.Name,
				["Position"] = {
					["x"] = v31.Position.X,
					["y"] = v31.Position.Y,
					["z"] = v31.Position.Z
				},
				["Size"] = {
					["x"] = v31.Size.X,
					["y"] = v31.Size.Y,
					["z"] = v31.Size.Z
				},
				["Transparency"] = false,
				["Material"] = false,
				["Color"] = false,
				["CanCollide"] = false,
				["Break"] = false,
				["Rotation"] = {
					["x"] = Rotation.X,
					["y"] = Rotation.Y,
					["z"] = Rotation.Z
				},
				["cast"] = v31.CastShadow,
				["I"] = v31:GetAttribute("I") or false,
				["telep"] = v31:GetAttribute("Des") and ({
					["x"] = v31:GetAttribute("Des").Position.X,
					["y"] = v31:GetAttribute("Des").Position.Y,
					["z"] = v31:GetAttribute("Des").Position.Z
				} or false) or false
			}

			if v31.Name ~= "Sound" or not v31.Core.Sound.SoundId then
				Rotation3 = false
			else
				Rotation3 = v31.Core.Sound.SoundId:match("rbxassetid://(%d+)") or false
			end

			Rotation.sound = Rotation3

			if v31.Name ~= "Sound" then
				Rotation3 = false
			else
				Rotation3 = v31.Core.Sound.Volume or false
			end

			Rotation.volume = Rotation3

			if v31.Name ~= "Sound" then
				Rotation3 = false
			else
				Rotation3 = v31.Core.Sound.RollOffMaxDistance or false
			end

			Rotation.distance = Rotation3

			if v31.Name ~= "Sound" then
				Rotation3 = false
			else
				Rotation3 = v31.Core.Sound.Looped or false
			end

			Rotation.loop = Rotation3

			if v31.Name ~= "Damage" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("DMG") or false
			end

			Rotation.dmg = Rotation3

			if v31.Name ~= "Image" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("IMG") or false
			end

			Rotation.img = Rotation3

			if v31.Name ~= "Moveset" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("CD") or false
			end

			Rotation.cd = Rotation3

			if v31.Name ~= "Moveset" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("Key") or false
			end

			Rotation.key = Rotation3

			if v31.Name ~= "Moveset" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("MoveName") or false
			end

			Rotation.mname = Rotation3
			Rotation.O = v31:GetAttribute("O") or false

			if v31.Name ~= "Light" then
				Rotation3 = false
			else
				Rotation3 = v31:GetAttribute("Flip") or false
			end

			Rotation.flip = Rotation3
			Rotation.boost = v31:GetAttribute("Boost") and ({
				["x"] = v31:GetAttribute("Boost").X,
				["y"] = v31:GetAttribute("Boost").Y,
				["z"] = v31:GetAttribute("Boost").Z
			} or false) or false
			Rotation.time = v31:GetAttribute("Time") or false
			Rotation2(t2, Rotation)
			task.wait()
		end

		local function v37(p29, p30)
			local t3, v39

			if type(p29) ~= "string" then
				if type(p29) ~= "table" then
					error("Unsupported data type: " .. type(p29))

					return
				else
					local v40, v41, v42 = ipairs(p29)

					t3 = {}

					while true do
						v42, v39 = v40(v41, v42)

						if v42 == nil then
							break
						end

						if type(v39) ~= "string" then
							table.insert(t3, v39)
						else
							table.insert(t3, v37(v39, p30))
						end
					end

					return t3
				end

				return
			else
				t3 = {}

				for i = 1, #p29 do
					v39 = string.byte(p29, i)
					table.insert(t3, string.char(bit32.bxor(v39, p30)))
				end

				return table.concat(t3)
			end
		end

		HttpService = v37(HttpService:JSONEncode(t2), 231)
		writefile("CodeQuestJsSaves/" .. tostring(TextBox.Text) .. ".txt", HttpService)
		game.StarterGui:SetCore("SendNotification", {
			["Title"] = "Successfully",
			["Text"] = "The map is saved",
			["Duration"] = 5
		})
	end
	TextButton.MouseButton1Click:Connect(Frame)
	TextButton2.MouseButton1Click:Connect(ScreenGui)
end

local lib = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local s2 = "32bb5952e00a4e658a2567f38d38c101"
local t4 = {
	["publicToken"] = "ae076278268b43fdaac771ee939354b1",
	["privateToken"] = "28712e64120246d09e58b4ebfd538d24",
	["trueData"] = s2,
	["falseData"] = "13872a44df4641f0b145aacb14174120"
}

lib.Set(t4)

local lib2 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local s3 = ""

t4 = lib2
t4 = lib2.CreateWindow(t4, {
	["Title"] = "Key System",
	["SubTitle"] = "QUEST X ",
	["TabWidth"] = 160,
	["Size"] = UDim2.fromOffset(580, 340),
	["Acrylic"] = false,
	["Theme"] = "Dark",
	["MinimizeKey"] = Enum.KeyCode.LeftControl
})

local t5 = {
	["KeySys"] = t4:AddTab({
		["Title"] = "Key System",
		["Icon"] = "key"
	})
}

t5.KeySys:AddInput("Input", {
	["Title"] = "Enter Key",
	["Description"] = "Enter Key Here",
	["Default"] = "",
	["Placeholder"] = "Enter key\226\128\166",
	["Numeric"] = false,
	["Finished"] = false,
	["Callback"] = function(p31)
		s3 = p31
	end
})
t5.KeySys:AddButton({
	["Title"] = "Check Key",
	["Description"] = "Enter Key before pressing this button",
	["Callback"] = function()
		if lib.validateDefaultKey(s3) ~= s2 then
			s3 = "Invalid key"
		else
			lib2:Destroy()
			v1()
		end
	end
})
t5.KeySys:AddButton({
	["Title"] = "Get Key",
	["Description"] = "Get Key here",
	["Callback"] = function()
		setclipboard(lib.getLink())
	end
})
t4:SelectTab(1)
