-- This file was generated at discord.gg/syncrypt

local signal = nil
local Players = (nil):GetService("Players")

Players:GetService("RunService");
(nil):GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

signal = nil
local name = signal or {}
local u5 = nil
local u6 = false
local Name = nil
local n1 = 0
local n2 = 0
local n3 = 5
local u11 = true
local fallenPartsDestroyHeight = (0 / 0)

signal.FallenPartsDestroyHeight = fallenPartsDestroyHeight
signal = (nil):GetPropertyChangedSignal("FallenPartsDestroyHeight")
signal:Connect(function()
	if false then
		return
	end

	("\152\242W\127\163_\161AT").FallenPartsDestroyHeight = (0 / 0)
end)

local s1 = "Part"

signal = fallenPartsDestroyHeight("Part", signal)
signal.CFrame = s1(0, -10008, 0)
fallenPartsDestroyHeight = true
signal.Anchored = true
signal.Size = fallenPartsDestroyHeight(2048, 10, 2048)
signal.Transparency = 0.5
fallenPartsDestroyHeight = true
signal.CanCollide = true
signal.Name = fallenPartsDestroyHeight:GetService("HttpService"):GenerateGUID()

signal = function(p1)
	if p1 then
		local Humanoid = p1:FindFirstChildOfClass("Humanoid") or p1:WaitForChild("Humanoid", 3)

		if not (Humanoid and (p1:FindFirstChild("HumanoidRootPart") or p1:WaitForChild("HumanoidRootPart", 3))) then
			return
		end

		return
	else
		return
	end
end
signal(LocalPlayer.Character)
fallenPartsDestroyHeight = LocalPlayer.CharacterAdded

local v17 = signal

fallenPartsDestroyHeight:Connect(function(p2)
	(nil)(0.1)
	v17(p2)
end)
signal = {}
s1 = "\156\248Qy\181[\161=\174\131\224\209"

local v18 = fallenPartsDestroyHeight({}, {
	["__mode"] = "k",
})

fallenPartsDestroyHeight = function(p4)
	if not p4 then
		return
	end
end
fallenPartsDestroyHeight(LocalPlayer.Character)

local CharacterAdded = LocalPlayer.CharacterAdded
local v23 = fallenPartsDestroyHeight

CharacterAdded = (function(...)
	return {
		...,
		["n"] = select("#", ...),
	}
end)(CharacterAdded:Connect(function(p5)
	(nil)(0.1)
	v23(p5)
end))

local _, _, _, _, _, _, backgroundTransparency, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, borderSizePixel =
	unpack(CharacterAdded, 1, 41)

fallenPartsDestroyHeight(signal, unpack(CharacterAdded, 1, CharacterAdded.n))

local v65 = LocalPlayer

signal = function()
	local v66 = nil
	local v67 = nil
	local Character = v65.Character

	if Character then
		local s2 = "HumanoidRootPart"

		if Character:FindFirstChild("HumanoidRootPart") then
			local v70

			v66, v67, v70 = v67(v66:GetChildren())

			local s3 = "\134\237D}\162\\"
			local s4 = "\152\242W\127\163_\161\240\243"

			while true do
				local v73

				v70, v73 = v66(v67, v70)

				if v70 == nil then
					break
				end

				if v73 ~= Character and (v73:IsA("Model") and v73:FindFirstChild("HumanoidRootPart")) then
					local Magnitude = (v73:FindFirstChild("HumanoidRootPart").Position - s3.Position).Magnitude

					if Magnitude < s2 then
						s4 = v73
						s2 = Magnitude
					end
				end
			end

			return s4
		else
			return nil
		end

		return
	else
		return nil
	end
end

local v75 = LocalPlayer
local v76 = signal

signal = function(p6)
	local Animator = p6:WaitForChild("Humanoid"):WaitForChild("Animator")
	local u78 = false

	Animator = Animator.AnimationPlayed

	local t1 = {
		["94638356008696"] = true,
		["95034083206292"] = true,
		["115484690572880"] = true,
	}

	Animator:Connect(function(p7)
		local v80 = nil

		if t1[p7.Animation.AnimationId:match("%d+$")] then
			if u78 then
				return
			else
				local v81 = true

				u78 = true
				v81("[Script] Animation detected: \159\239Lz\164")
				v81 = v75.Character

				if v81 then
					local s5 = "HumanoidRootPart"

					v81 = v81:FindFirstChild("HumanoidRootPart")

					if v81 then
						local CFrame = v81.CFrame

						v80 = "[Script] Saved CFrame: " .. v80(CFrame)
						s5(v80)
						s5 = v76()

						if not s5 then
							v80("[Script] No target found")
							u78 = false

							return
						end

						return
					else
						u78 = false

						return
					end

					return
				else
					u78 = false

					return
				end

				return
			end

			return
		else
			return
		end
	end)
end

local v84 = name

fallenPartsDestroyHeight = function(p8, p9)
	local Humanoid = p8:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		if v84.sethiddenproperty then
			v84.sethiddenproperty(Humanoid, "PlatformStand", p9)

			return
		else
			Humanoid.PlatformStand = p9

			return
		end

		return
	else
		return
	end
end

local v86 = Players
local v87 = LocalPlayer

CharacterAdded = function(p10)
	p10:lower()

	local v88, v89, v90 = p10(v86:GetPlayers())
	local s6 = "\134\237D}\162\\"

	while true do
		local v92

		v90, v92 = v88(v89, v90)

		if v90 == nil then
			break
		end

		if not (v92 == v87 or not v92.Name:lower():find(s6, 1, true)) then
			return v92
		end
	end
end
borderSizePixel = function(p11)
	local CFrame = p11.CFrame
	local Position
	local Position2 = (CFrame * (nil)(n1, n2, n3)).Position

	if u11 then
		return n2(Position2) * CFrame.Rotation
	else
		Position = CFrame.Position

		local n4 = 0.01

		if (Position2 - Position).Magnitude >= 0.01 then
			return n4(Position2, CFrame.Position)
		else
			return Position(Position2) * CFrame.Rotation
		end

		return
	end
end

local v97 = LocalPlayer

local function sortOrder()
	local Character = v97.Character

	if Character and Character.Parent then
		local v100 = Character;

		("\159\254Dx\188")(function()
			(nil)(v100, "PhysicsRepRootPart", nil)
		end)
	end

	if not (Character and Character.Parent) then
		return
	end

	local v101 = Character;

	("\159\254Dx\188")(function()
		v101.HumanoidRootPart.CFrame = v101(v101.HumanoidRootPart.Position)
	end)

	local v103 = Character;

	("\159\254Dx\188")(function()
		v103.HumanoidRootPart.AssemblyLinearVelocity = v103
	end)

	local v105 = Character;

	("\159\254Dx\188")(function()
		v105.HumanoidRootPart.AssemblyAngularVelocity = v105
	end)

	local v107 = Character;

	("\159\254Dx\188")(function()
		v107.HumanoidRootPart.Velocity = v107
	end)

	local v109 = Character;

	("\159\254Dx\188")(function()
		v109.HumanoidRootPart.RotVelocity = v109
	end)

	if not Character:FindFirstChildOfClass("Humanoid") then
		return
	end

	local s7 = "\159\254Dx\188"

	Character(function()
		s7.AutoRotate = true
	end)
end

local v112 = LocalPlayer
local v113 = name
local v114 = sortOrder

local function v115()
	u6 = false

	if u5 then
		u5:Disconnect()
		u5 = nil
	end

	local Character = v112.Character

	if not Character then
		return
	end

	local s8 = "Humanoid"
	local v118 = Character:FindFirstChildOfClass("Humanoid")
	local cameraType = "HumanoidRootPart"
	local v120 = Character:FindFirstChild("HumanoidRootPart")

	if v118 then
		v118.PlatformStand = false

		if v113.sethiddenproperty then
			s8 = "PlatformStand"
			v113.sethiddenproperty(v118, "PlatformStand", false)
		end

		v118.AutoRotate = true
		v118:ChangeState(s8)
		cameraType = v118
	end

	if v120 then
		("\185\248F`\191]\243").AssemblyLinearVelocity = Character;
		("\185\248F`\191]\243").AssemblyAngularVelocity = Character
	end

	if Character then
		Character = "\170\243Py"
		Character.CameraType = cameraType
		Character.CameraSubject = v118
	end

	v114()
end

local v121 = sortOrder
local v122 = CharacterAdded
local v123 = LocalPlayer

local function v128()
	if Name and Name ~= "" then
		local v129 = v122(Name)

		if v129 then
			local Character = v123.Character

			if Character then
				local Humanoid = Character:WaitForChild("Humanoid")

				if Humanoid and Character:WaitForChild("HumanoidRootPart") then
					local Character2 = v129.Character

					if Character2 then
						if not Character2:FindFirstChild("HumanoidRootPart") then
							v121()

							return
						end

						return
					else
						v121()

						return
					end

					return
				else
					v121()

					return
				end

				return
			else
				v121()

				return
			end

			return
		else
			("\152\252Wz")("Player not found: " .. Name)
			v121()

			return
		end

		return
	else
		v121()

		return
	end
end

LocalPlayer = backgroundTransparency("ScreenGui")
name = "WeldFollowUI"
LocalPlayer.Name = "WeldFollowUI"
LocalPlayer.Parent = "WeldFollowUI"
LocalPlayer.ZIndexBehavior = "WeldFollowUI"
name = false
LocalPlayer.ResetOnSpawn = false
CharacterAdded = "Frame"
name = name("Frame")
name.Parent = LocalPlayer
name.BackgroundColor3 = CharacterAdded(16, 16, 22)
LocalPlayer = 0
name.BorderSizePixel = 0
LocalPlayer = LocalPlayer(0.5, -175, 0.5, -155)
name.Position = LocalPlayer
name.Size = LocalPlayer(0, 350, 0, 310)
name.Active = true
LocalPlayer = true
name.Draggable = true
CharacterAdded = "UICorner"
LocalPlayer = LocalPlayer("UICorner", name)
LocalPlayer.CornerRadius = CharacterAdded(0, 8)
CharacterAdded = "Frame"
LocalPlayer = LocalPlayer("Frame")
LocalPlayer.Parent = name
LocalPlayer.BackgroundColor3 = CharacterAdded(0, 0, 0)
LocalPlayer.BackgroundTransparency = 0.55
CharacterAdded = 0
LocalPlayer.BorderSizePixel = 0
CharacterAdded = CharacterAdded(0, -4, 0, -4)
LocalPlayer.Position = CharacterAdded
LocalPlayer.Size = CharacterAdded(1, 8, 1, 8)
CharacterAdded = 0
LocalPlayer.ZIndex = 0
backgroundTransparency = "UICorner"
LocalPlayer = CharacterAdded("UICorner", LocalPlayer)
LocalPlayer.CornerRadius = backgroundTransparency(0, 10)
CharacterAdded = "Frame"
LocalPlayer = LocalPlayer("Frame")
LocalPlayer.Parent = name
LocalPlayer.BackgroundColor3 = CharacterAdded(22, 22, 32)
CharacterAdded = 0
LocalPlayer.BorderSizePixel = 0
CharacterAdded = CharacterAdded(1, 0, 0, 38)
LocalPlayer.Size = CharacterAdded
backgroundTransparency = "UICorner"
CharacterAdded = CharacterAdded("UICorner", LocalPlayer)
CharacterAdded.CornerRadius = backgroundTransparency(0, 8)
CharacterAdded = CharacterAdded("TextLabel")
CharacterAdded.Parent = LocalPlayer
LocalPlayer = 1
CharacterAdded.BackgroundTransparency = 1
LocalPlayer = LocalPlayer(0, 12, 0, 0)
CharacterAdded.Position = LocalPlayer
LocalPlayer = LocalPlayer(1, -12, 1, 0)
CharacterAdded.Size = LocalPlayer
CharacterAdded.Font = LocalPlayer
LocalPlayer = "ZKAY LoopTP + InstaKill (Private Ver)"
CharacterAdded.Text = "ZKAY LoopTP + InstaKill (Private Ver)"
CharacterAdded.TextColor3 = LocalPlayer(210, 210, 255)
LocalPlayer = 15
CharacterAdded.TextSize = 15
CharacterAdded.TextXAlignment = 15
CharacterAdded = "Frame"
LocalPlayer = LocalPlayer("Frame")
LocalPlayer.Parent = name
LocalPlayer.BackgroundColor3 = CharacterAdded(90, 90, 255)
CharacterAdded = 0
LocalPlayer.BorderSizePixel = 0
CharacterAdded = CharacterAdded(0, 0, 0, 38)
LocalPlayer.Position = CharacterAdded
CharacterAdded = CharacterAdded(1, 0, 0, 2)
LocalPlayer.Size = CharacterAdded
LocalPlayer = CharacterAdded("TextLabel")
LocalPlayer.Parent = name
CharacterAdded = 1
LocalPlayer.BackgroundTransparency = 1
CharacterAdded = CharacterAdded(0, 12, 0, 50)
LocalPlayer.Position = CharacterAdded
CharacterAdded = CharacterAdded(1, -24, 0, 16)
LocalPlayer.Size = CharacterAdded
LocalPlayer.Font = CharacterAdded
CharacterAdded = "Target Player"
LocalPlayer.Text = "Target Player"
LocalPlayer.TextColor3 = CharacterAdded(160, 160, 200)
CharacterAdded = 11
LocalPlayer.TextSize = 11
LocalPlayer.TextXAlignment = 11
LocalPlayer = "TextButton"
CharacterAdded = CharacterAdded("TextButton")
CharacterAdded.Parent = name
CharacterAdded.BackgroundColor3 = LocalPlayer(28, 28, 42)
LocalPlayer = 0
CharacterAdded.BorderSizePixel = 0
LocalPlayer = LocalPlayer(0, 12, 0, 68)
CharacterAdded.Position = LocalPlayer
LocalPlayer = LocalPlayer(1, -24, 0, 30)
CharacterAdded.Size = LocalPlayer
CharacterAdded.Font = LocalPlayer
LocalPlayer = "Select Player..."
CharacterAdded.Text = "Select Player..."
CharacterAdded.TextColor3 = LocalPlayer(200, 200, 255)
CharacterAdded.TextSize = 12
LocalPlayer = 2
CharacterAdded.ZIndex = 2
backgroundTransparency = "UICorner"
LocalPlayer = LocalPlayer("UICorner", CharacterAdded)
LocalPlayer.CornerRadius = backgroundTransparency(0, 5)
LocalPlayer = LocalPlayer("TextLabel")
LocalPlayer.Parent = CharacterAdded
backgroundTransparency = 1
LocalPlayer.BackgroundTransparency = 1
backgroundTransparency = backgroundTransparency(1, -24, 0, 0)
LocalPlayer.Position = backgroundTransparency
backgroundTransparency = backgroundTransparency(0, 20, 1, 0)
LocalPlayer.Size = backgroundTransparency
LocalPlayer.Font = backgroundTransparency
backgroundTransparency = "\226\150\190"
LocalPlayer.Text = "\226\150\190"
LocalPlayer.TextColor3 = backgroundTransparency(150, 150, 200)
LocalPlayer.TextSize = 14
backgroundTransparency = 2
LocalPlayer.ZIndex = 2
borderSizePixel = "Frame"
backgroundTransparency = backgroundTransparency("Frame")
backgroundTransparency.Parent = name
backgroundTransparency.BackgroundColor3 = borderSizePixel(24, 24, 36)
borderSizePixel = 0
backgroundTransparency.BorderSizePixel = 0
borderSizePixel = borderSizePixel(0, 12, 0, 100)
backgroundTransparency.Position = borderSizePixel
backgroundTransparency.Size = borderSizePixel(1, -24, 0, 0)
backgroundTransparency.ClipsDescendants = true
backgroundTransparency.ZIndex = 10
borderSizePixel = false
backgroundTransparency.Visible = false
sortOrder = "UICorner"
borderSizePixel = borderSizePixel("UICorner", backgroundTransparency)
borderSizePixel.CornerRadius = sortOrder(0, 5)

local ScrollingFrame = borderSizePixel("ScrollingFrame")

ScrollingFrame.Parent = backgroundTransparency
ScrollingFrame.BackgroundTransparency = 1
borderSizePixel = 0
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Size = borderSizePixel(1, 0, 1, 0)
borderSizePixel = 3
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = borderSizePixel(90, 90, 180)
borderSizePixel = 10
ScrollingFrame.ZIndex = 10
borderSizePixel = borderSizePixel(0, 0, 0, 0)
ScrollingFrame.CanvasSize = borderSizePixel
sortOrder = "UIListLayout"
borderSizePixel = borderSizePixel("UIListLayout")
borderSizePixel.Parent = ScrollingFrame
borderSizePixel.SortOrder = "UIListLayout"
sortOrder = sortOrder(0, 2)
borderSizePixel.Padding = sortOrder
borderSizePixel = "UIPadding"
sortOrder = sortOrder("UIPadding")
sortOrder.Parent = ScrollingFrame
borderSizePixel = borderSizePixel(0, 4)
sortOrder.PaddingTop = borderSizePixel
borderSizePixel = borderSizePixel(0, 4)
sortOrder.PaddingBottom = borderSizePixel
borderSizePixel = borderSizePixel(0, 4)
sortOrder.PaddingLeft = borderSizePixel
sortOrder.PaddingRight = borderSizePixel(0, 4)

local u134 = false
local v135 = backgroundTransparency
local v136 = LocalPlayer

borderSizePixel = function()
	u134 = false
	v135.Visible = false
	v136.Text = "\226\150\190"
end

local v137 = Players
local s9 = "\170\243Py"
local v139 = CharacterAdded
local v140 = borderSizePixel

sortOrder = function()
	local v142, borderSizePixel2, v144 = (nil)(ScrollingFrame:GetChildren())

	while true do
		v144, v161 = v142(borderSizePixel2, v144)

		if v144 == nil then
			break
		end

		if v161:IsA("TextButton") then
			v161:Destroy()
		end
	end

	v142, borderSizePixel2, v144 = ("\134\237D}\162\\")(v137:GetPlayers())

	local layoutOrder = 0

	while true do
		local MouseButton1Click, v147 = v142(borderSizePixel2, v144)

		if MouseButton1Click == nil then
			break
		end

		v144 = s9

		if v147 == s9 then
			v144 = MouseButton1Click
		else
			layoutOrder = layoutOrder + 1
			borderSizePixel2 = "TextButton"
			MouseButton1Click = s9("TextButton")
			MouseButton1Click.BackgroundColor3 = borderSizePixel2(36, 36, 52)
			borderSizePixel2 = 0
			MouseButton1Click.BorderSizePixel = 0
			borderSizePixel2 = borderSizePixel2(1, 0, 0, 28)
			MouseButton1Click.Size = borderSizePixel2
			v144 = "\170\243Py"
			MouseButton1Click.Font = borderSizePixel2
			borderSizePixel2 = v147.Name
			MouseButton1Click.Text = borderSizePixel2
			MouseButton1Click.TextColor3 = borderSizePixel2(200, 200, 240)
			MouseButton1Click.TextSize = 12
			MouseButton1Click.ZIndex = 11
			MouseButton1Click.LayoutOrder = layoutOrder

			local MouseEnter = ScrollingFrame

			MouseButton1Click.Parent = ScrollingFrame

			local s10 = "UICorner"

			borderSizePixel2 = "\186\217Ly"
			ScrollingFrame("UICorner", MouseButton1Click).CornerRadius = s10(0, 4)
			MouseEnter = MouseButton1Click.MouseEnter

			local v150 = MouseButton1Click

			MouseEnter:Connect(function()
				v150.BackgroundColor3 = (nil)(60, 60, 90)
			end)
			MouseEnter = MouseButton1Click.MouseLeave

			local v151 = MouseButton1Click

			MouseEnter:Connect(function()
				v151.BackgroundColor3 = (nil)(36, 36, 52)
			end)
			MouseButton1Click = MouseButton1Click.MouseButton1Click

			local v152 = v147

			MouseButton1Click:Connect(function()
				Name = v152.Name
				v139.Text = v152.Name
				v140()
			end)
		end
	end

	v142 = layoutOrder * 30 + 8
	borderSizePixel2 = v144(0, 0, 0, v142);
	("\186\217Ly\226").CanvasSize = borderSizePixel2;
	("\130\252Q|").Size = borderSizePixel2(1, -24, 0, (v142(v142, 120)))
end

local MouseButton1Click = CharacterAdded.MouseButton1Click
local v154 = borderSizePixel
local v155 = sortOrder
local v156 = backgroundTransparency
local v157 = LocalPlayer

LocalPlayer = function()
	if u134 then
		v154()

		return
	else
		v155()
		v156.Visible = true
		u134 = true
		v157.Text = "\226\150\180"

		return
	end
end
backgroundTransparency = MouseButton1Click.Connect
backgroundTransparency(MouseButton1Click, LocalPlayer)
LocalPlayer = backgroundTransparency("TextLabel")
LocalPlayer.Parent = name
backgroundTransparency = 1
LocalPlayer.BackgroundTransparency = 1
backgroundTransparency = backgroundTransparency(0, 12, 0, 114)
LocalPlayer.Position = backgroundTransparency
backgroundTransparency = backgroundTransparency(1, -24, 0, 16)
LocalPlayer.Size = backgroundTransparency
LocalPlayer.Font = backgroundTransparency
backgroundTransparency = "X / Y / Z Offset"
LocalPlayer.Text = "X / Y / Z Offset"
LocalPlayer.TextColor3 = backgroundTransparency(160, 160, 200)
backgroundTransparency = 11
LocalPlayer.TextSize = 11
LocalPlayer.TextXAlignment = 11

local v158 = name

LocalPlayer = function(p12, p13)
	("\166\243V`\177A\163\216")("TextBox").Parent = v158

	local s11 = "\172\242I{\162\28"

	s11.BackgroundColor3 = v158(28, 28, 42)
	local parent = 0
	s11.BorderSizePixel = 0
	parent = parent(0, p13, 0, 132);
	("\186\217Ly\226").Position = parent
	s11 = "\186\217Ly\226"
	s11.Size = parent(0, 96, 0, 28)
	parent = "\170\243Py"
	s11.Font = "\170\243Py"
	parent = parent(p12)
	s11.Text = parent
	parent = parent(200, 200, 255);
	("\172\242I{\162\28").TextColor3 = parent
	s11 = "\172\242I{\162\28"
	s11.PlaceholderColor3 = parent(90, 90, 120)
	s11.TextSize = 12
	parent = false
	s11.ClearTextOnFocus = false
	s11 = "UICorner"
	parent("UICorner", "\166\243V`\177A\163\216").CornerRadius = s11(0, 5)

	return "\186\217Ly"
end
backgroundTransparency = LocalPlayer(0, 12)
MouseButton1Click = LocalPlayer(0, 116)
LocalPlayer = LocalPlayer(5, 220)

local v162 = name

local function v163(p14, p15)
	local TextLabel = ("\166\243V`\177A\163\154")("TextLabel")

	TextLabel.Parent = v162

	local backgroundTransparency2 = 1

	TextLabel.BackgroundTransparency = 1
	TextLabel = backgroundTransparency2(0, p15, 0, 162);
	("\186\217Ly\226").Position = TextLabel
	backgroundTransparency2 = "\186\217Ly\226"
	backgroundTransparency2.Size = TextLabel(0, 96, 0, 14)
	TextLabel = "\170\243Py"
	backgroundTransparency2.Font = "\170\243Py"
	backgroundTransparency2.Text = p14
	backgroundTransparency2 = "\172\242I{\162\28"
	backgroundTransparency2.TextColor3 = TextLabel(100, 100, 160)
	backgroundTransparency2.TextSize = 10
	backgroundTransparency2.TextXAlignment = "\170\243Py"
end

v163("X", 12)
v163("Y", 116)
v163("Z", 220)

local v165 = backgroundTransparency
local v166 = MouseButton1Click
local v167 = LocalPlayer

local function v168()
	n1 = ("\155\242Ka\189M\165\151")(v165.Text) or 0
	n2 = ("\155\242Ka\189M\165\151")(v166.Text) or 0
	n3 = ("\155\242Ka\189M\165\151")(v167.Text) or 5
end

backgroundTransparency.FocusLost:Connect(v168)
MouseButton1Click.FocusLost:Connect(v168)
LocalPlayer = LocalPlayer.FocusLost
backgroundTransparency = v168
MouseButton1Click = LocalPlayer.Connect
MouseButton1Click(LocalPlayer, v168)
LocalPlayer = MouseButton1Click("TextLabel")
LocalPlayer.Parent = name
backgroundTransparency = 1
LocalPlayer.BackgroundTransparency = 1
backgroundTransparency = backgroundTransparency(0, 12, 0, 186)
LocalPlayer.Position = backgroundTransparency
backgroundTransparency = backgroundTransparency(0, 260, 0, 22)
LocalPlayer.Size = backgroundTransparency
LocalPlayer.Font = backgroundTransparency
backgroundTransparency = "Rotate as target"
LocalPlayer.Text = "Rotate as target"
LocalPlayer.TextColor3 = backgroundTransparency(160, 160, 200)
backgroundTransparency = 11
LocalPlayer.TextSize = 11
LocalPlayer.TextXAlignment = 11
LocalPlayer = backgroundTransparency("TextButton")
LocalPlayer.Parent = name
backgroundTransparency = 0
LocalPlayer.BorderSizePixel = 0
backgroundTransparency = backgroundTransparency(0, 278, 0, 188)
LocalPlayer.Position = backgroundTransparency
backgroundTransparency = backgroundTransparency(0, 58, 0, 20)
LocalPlayer.Size = backgroundTransparency
LocalPlayer.Font = backgroundTransparency
backgroundTransparency = 11
LocalPlayer.TextSize = 11
MouseButton1Click = "UICorner"
backgroundTransparency("UICorner", LocalPlayer).CornerRadius = MouseButton1Click(0, 4)

local v169 = LocalPlayer

backgroundTransparency = function()
	local v170 = nil

	if u11 then
		v170 = v170(40, 160, 80)
		v169.BackgroundColor3 = v170
		v169.TextColor3 = v170(255, 255, 255)
		v169.Text = "ON"

		return
	else
		v170 = v170(60, 60, 80)
		v169.BackgroundColor3 = v170
		v169.TextColor3 = v170(180, 180, 200)
		v169.Text = "OFF"

		return
	end
end
backgroundTransparency()
LocalPlayer = LocalPlayer.MouseButton1Click

local v172 = backgroundTransparency

backgroundTransparency = function()
	u11 = not u11
	v172()
end
MouseButton1Click = LocalPlayer.Connect
MouseButton1Click(LocalPlayer, backgroundTransparency)
LocalPlayer = "Frame"
backgroundTransparency = MouseButton1Click("Frame")
backgroundTransparency.Parent = name
backgroundTransparency.BackgroundColor3 = LocalPlayer(35, 35, 52)
LocalPlayer = 0
backgroundTransparency.BorderSizePixel = 0
LocalPlayer = LocalPlayer(0, 12, 0, 218)
backgroundTransparency.Position = LocalPlayer
LocalPlayer = LocalPlayer(1, -24, 0, 1)
backgroundTransparency.Size = LocalPlayer
LocalPlayer = LocalPlayer("TextButton")
LocalPlayer.Parent = name
backgroundTransparency = 0
LocalPlayer.BorderSizePixel = 0
backgroundTransparency = backgroundTransparency(0, 12, 0, 228)
LocalPlayer.Position = backgroundTransparency
backgroundTransparency = backgroundTransparency(1, -24, 0, 36)
LocalPlayer.Size = backgroundTransparency
LocalPlayer.Font = backgroundTransparency
LocalPlayer.TextColor3 = backgroundTransparency(255, 255, 255)
backgroundTransparency = 14
LocalPlayer.TextSize = 14
MouseButton1Click = "UICorner"
backgroundTransparency("UICorner", LocalPlayer).CornerRadius = MouseButton1Click(0, 6)

local v173 = LocalPlayer

backgroundTransparency = function()
	local v174 = nil

	if u6 then
		v173.BackgroundColor3 = v174(180, 50, 50)
		v173.Text = "\226\150\160  Stop Follow"

		return
	else
		v173.BackgroundColor3 = v174(40, 160, 80)
		v173.Text = "\226\150\182  Start Follow"

		return
	end
end
backgroundTransparency()
LocalPlayer = LocalPlayer.MouseButton1Click

local v175 = borderSizePixel
local v176 = v115
local v177 = backgroundTransparency

MouseButton1Click = function()
	v175()
	v168()

	if u6 then
		v176()
	else
		v128()
	end

	v177()
end
v163 = LocalPlayer.Connect
v163(LocalPlayer, MouseButton1Click)

local TextLabel = v163("TextLabel")

TextLabel.Parent = name
LocalPlayer = 1
TextLabel.BackgroundTransparency = 1
LocalPlayer = LocalPlayer(0, 12, 0, 272)
TextLabel.Position = LocalPlayer
LocalPlayer = LocalPlayer(1, -24, 0, 16)
TextLabel.Size = LocalPlayer
TextLabel.Font = LocalPlayer
LocalPlayer = "\226\151\143 Idle"
TextLabel.Text = "\226\151\143 Idle"
TextLabel.TextColor3 = LocalPlayer(130, 130, 160)
LocalPlayer = 11
TextLabel.TextSize = 11
name = "\170\243Py"
TextLabel.TextXAlignment = 11
s1.Heartbeat:Connect(function()
	if u6 and Name then
		v200 = TextLabel

		local text = "\226\151\143 Following: " .. Name

		TextLabel.Text = text
		TextLabel.TextColor3 = text(80, 220, 120)

		return
	end

	if u6 then
		return
	end

	local text = "\226\151\143 Idle"

	TextLabel.Text = "\226\151\143 Idle"
	TextLabel.TextColor3 = text(130, 130, 160)
end)
LocalPlayer = ("\172\242I{\162\28").InputBegan

local v181 = borderSizePixel

LocalPlayer:Connect(function(p16, p17)
	if p17 then
		return
	end

	if p16.UserInputType ~= "\170\243Py" or not u134 then
		return
	end

	v181()
end)
LocalPlayer = name.CharacterAdded

local v182 = fallenPartsDestroyHeight
local v183 = "\170\243Py"
local v184 = signal

LocalPlayer:Connect(function(p18)
	(nil)(0.5)

	if not u6 then
		v184(p18)

		return
	end

	v182(v183.Character, true)
	v184(p18)
end)
LocalPlayer = Players.PlayerRemoving

local v185 = CharacterAdded
local v186 = v115
local v187 = backgroundTransparency

LocalPlayer:Connect(function(p19)
	if Name ~= p19.Name then
		return
	end

	Name = nil
	v185.Text = "Select Player..."

	if not u6 then
		return
	end

	v186()
	v187()
end)
Players = Players.PlayerAdded

local v188 = sortOrder

Players:Connect(function()
	if not u134 then
		return
	end

	v188()
end)
LocalPlayer = name.Character

if LocalPlayer then
	signal(LocalPlayer)
else
	signal = Players
end

signal("[ZKAYHub] Weld LoopTP + InstaKill + Anti Void + Bypass AntiCheat loaded")
