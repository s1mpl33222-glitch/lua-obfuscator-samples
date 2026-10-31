-- This file was generated at discord.gg/syncrypt

local t1 = {}
local GameId = game.GameId
local t2 = {
	value1 = GameId == 335760407
}

print("Script loading...")
print("Game ID: " .. tostring(GameId))

if t2.value1 then
	print("✓ Detected TPS Street Soccer (ID: 335760407)")
else
	print("✗ Not TPS Street Soccer - TPS bypasses disabled")
end

print("Loading universal Adonis anticheat bypass...")
t2.value2 = nil

local v4, v5, v6 = pairs(getgc(true))

while true do
	local v7

	v6, v7 = v4(v5, v6)

	if not v6 then
		break
	end

	if type(v7) == "table" then
		local value = rawget(v7, "Anti")

		if value then
			value = rawget(v7, "Remote")
		end

		if value then
			t2.value2 = v7

			break
		end
	end
end

if t2.value2 then
	warn("Found Adonis Anticheat. Applying universal bypass...")
	t1.value2 = game:GetService("Players").LocalPlayer

	local value2 = t1.value2
	local Disconnect = t2.value2.Disconnect

	function t1.value2(p1, p2)
		if not p1 then
			return
		end

		hookfunction(p1, newcclosure(function(...)
			warn("Blocked " .. p2)
		end))
	end

	t1.value2(Disconnect, "Disconnect")
	t1.value2(t2.value2.Kill, "Kill")

	local Send = t2.value2.Remote.Send

	if Send then
		local v12 = nil

		local function v13(p3, ...)
			if p3 ~= "Detected" then
				return v12(p3, ...)
			end
		end

		v12 = hookfunction(Send, newcclosure(v13))
	end

	local Fire = t2.value2.Remote.Fire

	if Fire then
		local v15 = nil

		local function v16(p4, ...)
			local NewDecrypt = t2.value2.Remote.NewDecrypt
			local Key = t2.value2.Core.Key
			local v19

			if NewDecrypt then
				if Key then
					v19 = type(p4) == "string"
				else
					v19 = Key
				end
			else
				v19 = NewDecrypt
			end

			if not v19 then
				return v15(p4, ...)
			end

			local ok, result = pcall(NewDecrypt, p4, Key)

			if not ok then
				if not ok then
					return v15(p4, ...)
				end

				return
			end

			ok = result == "Detected" and true or result == "BadMemes"

			if not ok then
				return v15(p4, ...)
			end
		end

		v15 = hookfunction(Fire, newcclosure(v16))
	end

	local Kick = value2.Kick
	local v23 = nil

	local function v24(p5, ...)
		if p5 ~= value2 then
			return v23(p5, ...)
		end
	end

	v23 = nil
	v23 = hookfunction(Kick, newcclosure(v24))
	warn("Universal Adonis Anticheat Bypass Applied ✓")
else
	print("No Adonis anticheat detected - skipping universal bypass")
end

if t2.value1 then
	print("Applying TPS Street Soccer specific bypasses...")

	local v25, v26, v27 = getgc()

	while true do
		local v28

		v27, v28 = v25(v26, v27)

		if not v27 then
			break
		end

		local v29 = typeof(v28) == "function"

		if v29 then
			v29 = islclosure(v28)
		end

		if v29 then
			local v30 = debug.getconstants(v28)
			local value1 = table.find(v30, "Asset Editing")

			if not value1 then
				value1 = table.find(v30, 23)

				if value1 then
					t1.value1 = table.find(v30, 50)
					value1 = t1.value1

					if t1.value1 then
						value1 = table.find(v30, 65)
					end
				end
			end

			if value1 then
				warn("Found TPS anticheat function - patching...")

				for i = 1, #v30 do
					if v30[i] == 23 then
						debug.setconstant(v28, i, 9000000000)
					elseif v30[i] == 50 then
						debug.setconstant(v28, i, 9000000000)
					elseif v30[i] == 65 then
						debug.setconstant(v28, i, 9000000000)
					end
				end

				print("TPS anticheat constants patched ✓")
			end
		end
	end

	t1.value2 = game:GetService("Workspace"):FindFirstChild("FE")

	if t1.value2 then
		local Actions = t1.value2:FindFirstChild("Actions")

		if Actions then
			local KeepYourHeadUp = Actions:FindFirstChild("KeepYourHeadUp")

			if KeepYourHeadUp then
				local v35 = nil

				v35 = hookmetamethod(game, "__namecall", function(p6, ...)
					local v36 = p6 == KeepYourHeadUp

					if not v36 then
						if not v36 then
							return v35(p6, ...)
						end

						return
					end

					if getnamecallmethod() == "FireServer" then
						v36 = not checkcaller()
					else
						v36 = false
					end

					if not v36 then
						return v35(p6, ...)
					end
				end)
				warn("TPS Anticheat Remote Hooked ✓")
			else
				print("TPS remote not found - skipping remote hook")
			end
		else
			print("TPS actions not found - skipping remote hook")
		end
	else
		print("TPS FE not found - skipping remote hook")
	end

	warn("TPS Street Soccer specific bypasses applied successfully!")
else
	print("Skipping TPS-specific bypasses (not in TPS Street Soccer)")
end

print("Loading Football Reach UI...")

local Players = game:GetService("Players")

t1.value2 = game
t2.value3 = t1.value2.GetService(t1.value2, "RunService")
t2.value4 = game:GetService("UserInputService")
t2.value5 = game:GetService("TweenService")
t2.value6 = game:GetService("Workspace")
t2.value7 = Players.LocalPlayer
t2.value8 = false
t2.value9 = 50
t2.value10 = nil
t2.value11 = {}
t2.value12 = true
t2.value13 = nil
t2.value14 = 2
t2.value15 = 0
t2.value16 = 2
t2.value17 = false
t2.value18 = Instance.new("ScreenGui")
t2.value18.Name = "=×©™÷€¶°"
t2.value18.ResetOnSpawn = false
t2.value18.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local syn_ = syn

if syn_ then
	syn_ = syn.protect_gui
end

if syn_ then
	syn.protect_gui(t2.value18)
elseif gethui then
	t2.value18.Parent = gethui()
else
	t2.value18.Parent = game:GetService("CoreGui")
end

t2.value19 = Instance.new("Frame")
t2.value19.Name = "MainWindow"
t2.value19.Size = UDim2.new(0, 280, 0, 280)
t2.value19.Position = UDim2.new(0.5, -140, 0.5, -140)
t2.value19.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
t2.value19.BorderSizePixel = 0
t2.value19.ClipsDescendants = true

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = t2.value19

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Shadow"
ImageLabel.Size = UDim2.new(1, 10, 1, 10)
ImageLabel.Position = UDim2.new(0, -5, 0, -5)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://5554236805"
ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.ImageTransparency = 0.8
ImageLabel.ScaleType = Enum.ScaleType.Slice
ImageLabel.SliceCenter = Rect.new(23, 23, 277, 277)
ImageLabel.Parent = t2.value19

local Frame = Instance.new("Frame")

Frame.Name = "TitleBar"
Frame.Size = UDim2.new(1, 0, 0, 35)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Title"
TextLabel.Size = UDim2.new(1, -80, 1, 0)
TextLabel.Position = UDim2.new(0, 15, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "USFR - SGX"

if t2.value1 then
	TextLabel.Text = "TPS REACH"
end

TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
t2.value20 = Instance.new("TextButton")
t2.value20.Name = "CloseButton"
t2.value20.Size = UDim2.new(0, 25, 0, 25)
t2.value20.Position = UDim2.new(1, -30, 0, 5)
t2.value20.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
t2.value20.Text = "×"
t2.value20.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value20.Font = Enum.Font.GothamBold
t2.value20.TextSize = 18
t2.value20.AutoButtonColor = false

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = t2.value20
t2.value21 = Instance.new("TextButton")
t2.value21.Name = "MinimizeButton"
t2.value21.Size = UDim2.new(0, 25, 0, 25)
t2.value21.Position = UDim2.new(1, -60, 0, 5)
t2.value21.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
t2.value21.Text = "_"
t2.value21.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value21.Font = Enum.Font.GothamBold
t2.value21.TextSize = 16
t2.value21.AutoButtonColor = false

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = t2.value21
Frame.Parent = t2.value19
TextLabel.Parent = Frame
t2.value20.Parent = Frame
t2.value21.Parent = Frame
t2.value22 = Instance.new("Frame")
t2.value22.Name = "Content"
t2.value22.Size = UDim2.new(1, 0, 1, -35)
t2.value22.Position = UDim2.new(0, 0, 0, 35)
t2.value22.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
t2.value22.BackgroundTransparency = 0.3
t2.value22.ClipsDescendants = true

local UICorner5 = Instance.new("UICorner")

UICorner5.CornerRadius = UDim.new(0, 8)
UICorner5.Parent = t2.value22

if t2.value1 then
	local Frame2 = Instance.new("Frame")

	Frame2.Name = "StatusSection"
	t1.value3 = UDim2.new(1, -20, 0, 30)
	Frame2.Size = t1.value3
	t1.value3 = UDim2.new(0, 10, 0, 10)
	Frame2.Position = t1.value3
	t1.value3 = Color3.fromRGB(40, 40, 45)
	Frame2.BackgroundColor3 = t1.value3
	Frame2.BorderSizePixel = 0

	local UICorner6 = Instance.new("UICorner")

	t1.value4 = UDim.new(0, 8)
	UICorner6.CornerRadius = t1.value4
	UICorner6.Parent = Frame2
	t1.value3 = Instance.new("TextLabel")
	t1.value3.Name = "StatusText"
	t1.value5 = UDim2.new(1, -10, 1, -10)
	t1.value3.Size = t1.value5
	t1.value5 = UDim2.new(0, 5, 0, 5)
	t1.value3.Position = t1.value5
	t1.value3.BackgroundTransparency = 1
	t1.value3.Text = "✓ TPS Street Soccer"
	t1.value5 = Color3.fromRGB(0, 255, 0)
	t1.value3.TextColor3 = t1.value5
	t1.value4 = Enum.Font.Gotham
	t1.value3.Font = t1.value4
	t1.value3.TextSize = 12
	t1.value4 = Enum.TextXAlignment.Left
	t1.value3.TextXAlignment = t1.value4
	t1.value4 = Enum.TextYAlignment.Center
	t1.value3.TextYAlignment = t1.value4
	t1.value3.Parent = Frame2
	t1.value4 = t2.value22
	Frame2.Parent = t1.value4
end

local v49 = t2.value1 and 50 or 10
local Frame2 = Instance.new("Frame")

Frame2.Name = "EnableSection"
Frame2.Size = UDim2.new(1, -20, 0, 60)
Frame2.Position = UDim2.new(0, 10, 0, v49)
Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame2.BorderSizePixel = 0
Frame2.Visible = true
t1.value3 = Instance.new("UICorner")
t1.value3.CornerRadius = UDim.new(0, 8)
t1.value3.Parent = Frame2
t1.value4 = Instance.new("TextLabel")
t1.value4.Name = "EnableTitle"
t1.value4.Size = UDim2.new(1, 0, 0, 25)
t1.value4.Position = UDim2.new(0, 0, 0, 0)
t1.value4.BackgroundTransparency = 1
t1.value4.Text = "REACH CONTROL"
t1.value4.TextColor3 = Color3.fromRGB(180, 180, 190)
t1.value4.Font = Enum.Font.GothamSemibold
t1.value4.TextSize = 12
t1.value4.TextXAlignment = Enum.TextXAlignment.Left
t1.value4.Visible = true
t1.value5 = Instance.new("UIPadding")
t1.value5.PaddingLeft = UDim.new(0, 10)
t1.value5.Parent = t1.value4
t2.value23 = Instance.new("TextButton")
t2.value23.Name = "ToggleButton"
t2.value23.Size = UDim2.new(0, 100, 0, 30)
t2.value23.Position = UDim2.new(0.5, -50, 0.5, -15)
t2.value23.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
t2.value23.Text = "DISABLED"
t2.value23.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value23.Font = Enum.Font.GothamBold
t2.value23.TextSize = 12
t2.value23.AutoButtonColor = false
t2.value23.Visible = true

local UICorner6 = Instance.new("UICorner")

UICorner6.CornerRadius = UDim.new(0, 6)
UICorner6.Parent = t2.value23

local v52 = t2.value1 and 120 or 80
local Frame3 = Instance.new("Frame")

Frame3.Name = "ReachSection"
Frame3.Size = UDim2.new(1, -20, 0, 120)
Frame3.Position = UDim2.new(0, 10, 0, v52)
Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame3.BorderSizePixel = 0
Frame3.Visible = true

local UICorner7 = Instance.new("UICorner")

UICorner7.CornerRadius = UDim.new(0, 8)
UICorner7.Parent = Frame3

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "ReachTitle"
TextLabel2.Size = UDim2.new(1, 0, 0, 25)
TextLabel2.Position = UDim2.new(0, 0, 0, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "REACH SETTINGS"
TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 190)
TextLabel2.Font = Enum.Font.GothamSemibold
TextLabel2.TextSize = 12
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Visible = true

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.Parent = TextLabel2
t2.value24 = Instance.new("TextLabel")
t2.value24.Name = "CurrentReach"
t2.value24.Size = UDim2.new(1, 0, 0, 30)
t2.value24.Position = UDim2.new(0, 0, 0, 25)
t2.value24.BackgroundTransparency = 1
t2.value24.Text = "50"
t2.value24.TextColor3 = Color3.fromRGB(100, 180, 255)
t2.value24.Font = Enum.Font.GothamBold
t2.value24.TextSize = 24
t2.value24.Visible = true

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Name = "ReachUnit"
TextLabel3.Size = UDim2.new(1, 0, 0, 15)
TextLabel3.Position = UDim2.new(0, 0, 0, 55)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "STUDS"
TextLabel3.TextColor3 = Color3.fromRGB(150, 150, 160)
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.TextSize = 10
TextLabel3.Visible = true

local Frame4 = Instance.new("Frame")

Frame4.Name = "ButtonContainer"
Frame4.Size = UDim2.new(1, -20, 0, 40)
Frame4.Position = UDim2.new(0, 10, 0, 75)
Frame4.BackgroundTransparency = 1
Frame4.Visible = true
t2.value25 = Instance.new("TextButton")
t2.value25.Name = "MinusButton"
t2.value25.Size = UDim2.new(0, 60, 1, 0)
t2.value25.Position = UDim2.new(0, 0, 0, 0)
t2.value25.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
t2.value25.Text = "-"
t2.value25.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value25.Font = Enum.Font.GothamBold
t2.value25.TextSize = 20
t2.value25.AutoButtonColor = false
t2.value25.Visible = true

local UICorner8 = Instance.new("UICorner")

UICorner8.CornerRadius = UDim.new(0, 6)
UICorner8.Parent = t2.value25
t2.value26 = Instance.new("TextButton")
t2.value26.Name = "PlusButton"
t2.value26.Size = UDim2.new(0, 60, 1, 0)
t2.value26.Position = UDim2.new(1, -60, 0, 0)
t2.value26.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
t2.value26.Text = "+"
t2.value26.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value26.Font = Enum.Font.GothamBold
t2.value26.TextSize = 20
t2.value26.AutoButtonColor = false
t2.value26.Visible = true

local UICorner9 = Instance.new("UICorner")

UICorner9.CornerRadius = UDim.new(0, 6)
UICorner9.Parent = t2.value26

local Frame5 = Instance.new("Frame")

Frame5.Name = "NumberBoxContainer"
Frame5.Size = UDim2.new(0, 60, 1, 0)
Frame5.Position = UDim2.new(0.5, -30, 0, 0)
Frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
Frame5.Visible = true

local UICorner10 = Instance.new("UICorner")

UICorner10.CornerRadius = UDim.new(0, 6)
UICorner10.Parent = Frame5
t2.value27 = Instance.new("TextBox")
t2.value27.Name = "NumberBox"
t2.value27.Size = UDim2.new(1, -6, 1, -6)
t2.value27.Position = UDim2.new(0, 3, 0, 3)
t2.value27.BackgroundTransparency = 1
t2.value27.Text = "50"
t2.value27.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value27.Font = Enum.Font.GothamSemibold
t2.value27.TextSize = 14
t2.value27.PlaceholderText = "Enter reach"
t2.value27.ClearTextOnFocus = false
t2.value27.TextScaled = true
t2.value27.Visible = true

local TextLabel4 = Instance.new("TextLabel")

TextLabel4.Name = "LimitsInfo"
TextLabel4.Size = UDim2.new(1, 0, 0, 15)
TextLabel4.Position = UDim2.new(0, 0, 0, 120)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Min: 1 | Max: inf"
TextLabel4.TextColor3 = Color3.fromRGB(120, 120, 130)
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.TextSize = 10
TextLabel4.Visible = true

local TextLabel5 = Instance.new("TextLabel")

TextLabel5.Name = "CreatorLabel"
TextLabel5.Size = UDim2.new(1, 0, 0, 15)
TextLabel5.Position = UDim2.new(0, 0, 1, -20)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "Football Reach Script"
TextLabel5.TextColor3 = Color3.fromRGB(100, 100, 110)
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.TextSize = 10
TextLabel5.Visible = true
t1.value4.Parent = Frame2
t2.value23.Parent = Frame2
Frame2.Parent = t2.value22
TextLabel2.Parent = Frame3
t2.value24.Parent = Frame3
TextLabel3.Parent = Frame3
Frame4.Parent = Frame3
t2.value25.Parent = Frame4
t2.value26.Parent = Frame4
Frame5.Parent = Frame4
t2.value27.Parent = Frame5
TextLabel4.Parent = Frame3
Frame3.Parent = t2.value22
TextLabel5.Parent = t2.value22
t2.value22.Parent = t2.value19
t2.value19.Parent = t2.value18

function createWireframeBox()
	if t2.value13 then
		t2.value13:Destroy()
		t2.value13 = nil
	end

	t2.value13 = Instance.new("Part")
	t2.value13.Name = "ReachWireframe"
	t2.value13.Size = Vector3.new(t2.value9 * t2.value14, t2.value9 * t2.value14, t2.value9 * t2.value14)
	t2.value13.Transparency = 1
	t2.value13.Anchored = true
	t2.value13.CanCollide = false
	t2.value13.Material = Enum.Material.ForceField
	t2.value13.Color = Color3.fromRGB(0, 255, 255)

	local SelectionBox = Instance.new("SelectionBox")

	SelectionBox.Name = "WireframeOutline"
	SelectionBox.Adornee = t2.value13
	SelectionBox.Color3 = Color3.fromRGB(0, 255, 255)
	SelectionBox.LineThickness = 0.05
	SelectionBox.Transparency = 0.5
	SelectionBox.Parent = t2.value13
	t2.value13.Parent = t2.value6
	t2.value3.Heartbeat:Connect(function()
		local value13 = t2.value13

		if value13 then
			value13 = t2.value7.Character
		end

		local HumanoidRootPart = value13 and t2.value7.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		t2.value13.CFrame = HumanoidRootPart.CFrame
		t2.value13.Size = Vector3.new(t2.value9 * t2.value14, t2.value9 * t2.value14, t2.value9 * t2.value14)
	end)
end
function destroyWireframe()
	if not t2.value13 then
		return
	end

	t2.value13:Destroy()
	t2.value13 = nil
end

t2.value28 = nil

function t2.value28()
	local value24 = t2.value24
	local value9 = t2.value9

	value24.Text = tostring(value9)

	local value27 = t2.value27
	local value92 = t2.value9

	value27.Text = tostring(value92)

	if not t2.value13 then
		return
	end

	t2.value13.Size = Vector3.new(t2.value9 * t2.value14, t2.value9 * t2.value14, t2.value9 * t2.value14)
end
function t2.value29()
	if t2.value8 then
		t2.value23.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
		t2.value23.Text = "ENABLED"
		createWireframeBox()
	else
		t2.value23.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		t2.value23.Text = "DISABLED"
		destroyWireframe()
	end
end
function t2.value30(p7)
	local v72 = t2.value9 + p7

	t2.value9 = v72 < 1 and 1 or (v72 > 1000000000000000 and 1000000000000000 or v72)
	t2.value28()
end

(function(p8, p9)
	local u73 = false
	local u74 = nil
	local Position = nil
	local Position2 = nil

	p9.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u73 = true
		Position = input.Position
		Position2 = p8.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u73 = false
		end)
	end)
	p9.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u74 = input
	end)
	t2.value4.InputChanged:Connect(function(input)
		local v77

		if input == u74 then
			v77 = u73
		else
			v77 = false
		end

		if not v77 then
			return
		end

		local v78 = input.Position - Position

		p8.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v78.X, Position2.Y.Scale, Position2.Y.Offset + v78.Y)
	end)
end)(t2.value19, Frame)
t2.value20.MouseButton1Click:Connect(function()
	t2.value18:Destroy()
	destroyWireframe()
	stopReach()
end)
t2.value20.MouseEnter:Connect(function()
	t2.value20.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
end)
t2.value20.MouseLeave:Connect(function()
	t2.value20.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end)
t2.value21.MouseButton1Click:Connect(function()
	t2.value12 = not t2.value12
	t2.value22.Visible = t2.value12

	if t2.value12 then
		t2.value21.Text = "_"
		t2.value19.Size = UDim2.new(0, 280, 0, 280)
	else
		t2.value21.Text = "□"
		t2.value19.Size = UDim2.new(0, 280, 0, 35)
	end
end)
t2.value21.MouseEnter:Connect(function()
	t2.value21.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
end)
t2.value21.MouseLeave:Connect(function()
	t2.value21.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
end)
t2.value23.MouseButton1Click:Connect(function()
	t2.value8 = not t2.value8
	t2.value29()

	if t2.value8 then
		startReach()
		createNotification("Reach Enabled", "Touch reach + wireframe active")
	else
		stopReach()
		createNotification("Reach Disabled", "Touch reach + wireframe off")
	end
end)
t2.value23.MouseEnter:Connect(function()
	if t2.value8 then
		t2.value23.BackgroundColor3 = Color3.fromRGB(70, 200, 110)
	else
		t2.value23.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
	end
end)
t2.value23.MouseLeave:Connect(function()
	t2.value29()
end)
t2.value25.MouseButton1Click:Connect(function()
	t2.value30(-1)
end)
t2.value25.MouseEnter:Connect(function()
	t2.value25.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
end)
t2.value25.MouseLeave:Connect(function()
	t2.value25.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end)
t2.value26.MouseButton1Click:Connect(function()
	t2.value30(1)
end)
t2.value26.MouseEnter:Connect(function()
	t2.value26.BackgroundColor3 = Color3.fromRGB(70, 200, 110)
end)
t2.value26.MouseLeave:Connect(function()
	t2.value26.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
end)
t2.value27.FocusLost:Connect(function()
	local Text = t2.value27.Text
	local v80 = tonumber(Text)

	if not v80 then
		t2.value28()

		return
	end

	t2.value9 = v80 < 1 and 1 or (v80 > 1000000000000000 and 999999999999999 or v80)
	t2.value28()
end)
t2.value27:GetPropertyChangedSignal("Text"):Connect(function()
	local Text = t2.value27.Text
	local match = Text:match("[^%d]")

	if match then
		match = Text ~= ""
	end

	if not match then
		return
	end

	t2.value27.Text = Text:gsub("[^%d]", "")
end)
t2.value28()
t2.value31 = nil
t2.value29()

function createNotification(p10, p11)
	local Frame6 = Instance.new("Frame")

	Frame6.Name = "Notification"
	Frame6.Size = UDim2.new(0, 220, 0, 70)
	Frame6.Position = UDim2.new(1, -230, 0, 20)
	Frame6.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	Frame6.BorderSizePixel = 0

	local UICorner11 = Instance.new("UICorner")

	UICorner11.CornerRadius = UDim.new(0, 8)
	UICorner11.Parent = Frame6

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Size = UDim2.new(1, 10, 1, 10)
	ImageLabel2.Position = UDim2.new(0, -5, 0, -5)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = "rbxassetid://5554236805"
	ImageLabel2.ImageColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel2.ImageTransparency = 0.8
	ImageLabel2.ScaleType = Enum.ScaleType.Slice
	ImageLabel2.SliceCenter = Rect.new(23, 23, 277, 277)
	ImageLabel2.Parent = Frame6

	local TextLabel6 = Instance.new("TextLabel")

	TextLabel6.Size = UDim2.new(1, -10, 0, 20)
	TextLabel6.Position = UDim2.new(0, 5, 0, 5)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Text = p10
	TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel6.Font = Enum.Font.GothamBold
	TextLabel6.TextSize = 12
	TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel6.Parent = Frame6

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(1, -10, 0, 40)
	TextLabel7.Position = UDim2.new(0, 5, 0, 25)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = p11
	TextLabel7.TextColor3 = Color3.fromRGB(180, 180, 190)
	TextLabel7.Font = Enum.Font.Gotham
	TextLabel7.TextSize = 10
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel7.TextWrapped = true
	TextLabel7.Parent = Frame6
	Frame6.Parent = t2.value18
	Frame6.Position = UDim2.new(1, 250, 0, 20)
	t2.value5:Create(Frame6, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -230, 0, 20)
	}):Play()
	wait(3)

	local value5 = t2.value5
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local uDim2New = UDim2.new
	local v91 = value5.Create(value5, Frame6, tweenInfo, {
		Position = uDim2New(1, 250, 0, 20)
	})

	v91:Play()
	v91.Completed:Connect(function()
		Frame6:Destroy()
	end)
end
function t2.value32(p12)
	local t3 = {}

	if p12 then
		for _, descendant in ipairs(p12:GetDescendants()) do
			if descendant:IsA("BasePart") then
				table.insert(t3, descendant)
			end
		end

		return t3
	else
		return t3
	end
end
function t2.value33(p13)
	local t4 = {}

	if p13 then
		local GetChildren = p13.GetChildren

		for _, v in ipairs(GetChildren(p13)) do
			if v:IsA("Tool") then
				table.insert(t4, v)
			end
		end

		return t4
	else
		return t4
	end
end

t2.value31 = {}

function t2.value34(p14)
	if t2.value31[p14] then
		return t2.value31[p14]
	else
		local t5 = {
			remotes = {},
			scripts = {},
			special = {}
		}

		for _, descendant in ipairs(p14:GetDescendants()) do
			if descendant:IsA("RemoteEvent") then
				local remotes = t5.remotes

				table.insert(remotes, descendant)
			elseif descendant:IsA("RemoteFunction") then
				local remotes = t5.remotes

				table.insert(remotes, descendant)
			elseif descendant:IsA("Script") then
				local v104 = descendant.Name:lower()

				if v104:find("activate") or (v104:find("tool") or v104:find("handle")) then
					local scripts = t5.scripts

					table.insert(scripts, descendant)
				end
			else
				local isBasePart = descendant:IsA("BasePart")

				if isBasePart then
					isBasePart = descendant.Name:lower():find("handle")
				end

				if isBasePart then
					t5.special.handle = descendant
				end
			end
		end

		if not (p14:IsA("Tool") and p14:FindFirstChildOfClass("Animation")) then
			t2.value31[p14] = t5

			return t5
		end

		t5.special.animation = true
		t2.value31[p14] = t5

		return t5
	end
end
function t2.value35(p15, p16)
	pcall(function()
		local v107 = t2.value34(p15)
		local v108, v109, v110 = ipairs(v107.remotes)

		while true do
			local v111

			v110, v111 = v108(v109, v110)

			if not v110 then
				break
			end

			pcall(function()
				if v111:IsA("RemoteEvent") then
					v111:FireServer(p16)
					v111:FireServer()

					return
				end

				if not v111:IsA("RemoteFunction") then
					return
				end

				v111:InvokeServer(p16)
				v111:InvokeServer()
			end)
		end

		local function v112()
			p15:Activate()
			p15:Activate()
		end

		pcall(v112)

		for _, script in ipairs(v107.scripts) do
			pcall(function()
				if script.Disabled ~= false then
					return
				end

				local function v115()
					script:Fire()
				end

				if pcall(v115) then
					return
				end

				local v116 = script

				for _, descendant in ipairs(v116.GetDescendants(v116)) do
					local isBoolValue = descendant:IsA("BoolValue")

					if isBoolValue then
						isBoolValue = descendant.Name:lower():find("active")
					end

					if isBoolValue then
						descendant.Value = true
					else
						local isNumberValue = descendant:IsA("NumberValue")

						if isNumberValue then
							isNumberValue = descendant.Name:lower():find("trigger")
						end

						if isNumberValue then
							descendant.Value = 1
						end
					end
				end
			end)
		end

		if v107.special.handle then
			local function v121()
				firetouchinterest(p16, v107.special.handle, 0)
				firetouchinterest(p16, v107.special.handle, 1)
			end

			pcall(v121)
		end

		if v107.special.animation then
			local function v122()
				local Character = t2.value7.Character

				if Character then
					Character = t2.value7.Character:FindFirstChildOfClass("Humanoid")
				end

				local Animator = Character and Character:FindFirstChildOfClass("Animator")

				if not Animator then
					return
				end

				local v125 = p15

				for _, descendant in ipairs(v125.GetDescendants(v125)) do
					if descendant:IsA("Animation") then
						local v128 = Animator:LoadAnimation(descendant)

						if v128 then
							v128:Play()
						end
					end
				end
			end

			pcall(v122)
		end

		pcall(function()
			local MouseEvent = p15:FindFirstChild("MouseEvent") or p15:FindFirstChild("ClickDetector")

			if not (MouseEvent and MouseEvent:IsA("ClickDetector")) then
				return
			end

			MouseEvent:Fire()
			MouseEvent:Fire()
		end)
		pcall(function()
			if not p15:IsA("Tool") then
				return
			end

			p15.Enabled = true
			p15.Enabled = false
			p15.Enabled = true
		end)
	end)
end

t2.value36 = {}

for _, v in ipairs({
	"Ball",
	"ball",
	"BALL",
	"BallPart",
	"ballPart",
	"BALLPART",
	"Ballpart",
	"BALLPART",
	"Balls",
	"balls",
	"BALLS",
	"Football",
	"football",
	"FOOTBALL",
	"Football\'s",
	"football\'s",
	"FOOTBALL\'S",
	"Footballs",
	"footballs",
	"FOOTBALLS",
	"TPS",
	"tps",
	"Tps",
	"SoccerBall",
	"soccerball",
	"SOCCERBALL",
	"Soccer",
	"soccer",
	"SOCCER",
	"Soccer Ball",
	"soccer ball",
	"SOCCER BALL"
}) do
	t1.value6 = t2.value36
	t1.value6[v] = true
end

function t2.value37(p17)
	if p17 then
		local v132 = p17:lower()

		return t2.value36[p17] and true or ((v132:find("ball") or (v132:find("football") or v132:find("soccer"))) and true or v132 == "tps")
	else
		return false
	end
end

t2.value38 = nil

function t2.value38()
	local t6 = {}
	local t7 = {}

	local function v135(p18)
		if p18 then
			local GetDescendants = p18.GetDescendants

			for _, v in ipairs(GetDescendants(p18)) do
				if t2.value37(v.Name) then
					local isMeshPart = not v:IsA("BasePart") and v:IsA("MeshPart")

					if isMeshPart then
						isMeshPart = not t7[v]
					end

					if isMeshPart then
						local v140 = t6

						table.insert(v140, v)
						t7[v] = true
					else
						local isFolder = not v:IsA("Model") and v:IsA("Folder")

						if isFolder then
							isFolder = not t7[v]
						end

						if isFolder then
							local GetDescendants2 = v.GetDescendants

							for _, v2 in ipairs(GetDescendants2(v)) do
								local isBasePart = v2:IsA("BasePart") or v2:IsA("MeshPart")

								if isBasePart then
									isBasePart = not t7[v2]
								end

								if isBasePart then
									local v146 = t6

									table.insert(v146, v2)
									t7[v2] = true
								end
							end

							t7[v] = true
						end
					end
				end
			end
		end
	end

	v135(t2.value6)

	local t8 = {
		t2.value6:FindFirstChild("Game"),
		t2.value6:FindFirstChild("Interactive"),
		t2.value6:FindFirstChild("Balls"),
		t2.value6:FindFirstChild("Football"),
		t2.value6:FindFirstChild("GameObjects"),
		t2.value6:FindFirstChild("Objects"),
		t2.value6:FindFirstChild("Items")
	}
	local v148, v149, v150 = ipairs(t8)

	while true do
		local v151

		v150, v151 = v148(v149, v150)

		if not v150 then
			break
		end

		if v151 then
			v135(v151)
		end
	end

	if not t2.value1 then
		return t6
	end

	local WorkspaceStadiumFolder = t2.value6:FindFirstChild("WorkspaceStadiumFolder")
	local TPSSystem = t2.value6:FindFirstChild("TPSSystem")
	local value6 = t2.value6
	local t9 = { WorkspaceStadiumFolder, TPSSystem, value6.FindFirstChild(value6, "WorkspaceLeaderboards") }

	for _, v in ipairs(t9) do
		if v then
			v135(v)
		end
	end

	return t6
end
function t2.value39()
	if t2.value17 then
	elseif tick() - t2.value15 < t2.value16 then
		return
	else
		local v158 = t2.value38()

		t2.value11 = v158

		if #v158 > 0 then
			print("[Football Reach] Found " .. #v158 .. " ball(s) with comprehensive detection")

			for i, v in ipairs(v158) do
				if i <= 5 then
					print("  - " .. v.Name .. " (" .. v:GetFullName() .. ")")
				end
			end

			if #v158 > 5 then
				print("  ... and " .. #v158 - 5 .. " more")

				return
			else
				return
			end
		else
			print("[Football Reach] No balls found with current detection")

			return
		end
	end
end

task.spawn(function()
	while true do
		if t2.value8 then
			t2.value39()
		end

		task.wait(t2.value16)
	end
end)

function t2.value40(p19, p20)
	pcall(function()
		firetouchinterest(p20, p19, 0)
		firetouchinterest(p20, p19, 1)
		firetouchinterest(p19, p20, 0)
		firetouchinterest(p19, p20, 1)
		firetouchinterest(p19, p20, 0)
		firetouchinterest(p19, p20, 1)
	end)
end
function startReach()
	stopReach()
	t2.value10 = t2.value3.Heartbeat:Connect(function()
		if not t2.value8 then
			return
		end

		if tick() - 0 < 0.05 then
			return
		end

		local Character = t2.value7.Character

		if not (Character and Character.PrimaryPart) then
			return
		end

		local Position = Character.PrimaryPart.Position
		local v163 = t2.value32(Character)

		if #v163 == 0 then
			return
		end

		local v164 = t2.value33(Character)

		for _, v in ipairs(t2.value11) do
			local Parent

			if v then
				Parent = v.Parent
			else
				Parent = v
			end

			if Parent then
				local ok, result = pcall(function()
					return v.Position
				end)

				if ok and result and (Position - result).Magnitude <= t2.value9 then
					local v170, v171, v172 = ipairs(v163)

					while true do
						local v173

						v172, v173 = v170(v171, v172)

						if not v172 then
							break
						end

						t2.value40(v173, v)
					end

					if #v164 > 0 then
						local v174, v175, v176 = ipairs(v164)
						local t10 = {}

						while true do
							local v178

							v176, v178 = v174(v175, v176)

							if not v176 then
								break
							end

							local v179 = v178.Name:lower()

							if v179:find("dribble") or (v179:find("sombrero") or (v179:find("skill") or v179:find("move"))) then
								table.insert(t10, 1, v178)
							else
								table.insert(t10, v178)
							end
						end

						for _, v2 in ipairs(t10) do
							t2.value35(v2, v)
							task.spawn(function()
								for _ = 1, 3 do
									t2.value35(v2, v)
									task.wait(0.01)
								end
							end)
						end
					end
				end
			end
		end
	end)
end
function stopReach()
	if not t2.value10 then
		return
	end

	t2.value10:Disconnect()
end

t2.value7.CharacterAdded:Connect(function()
	if not t2.value8 then
		return
	end

	task.wait(0.5)
	startReach()

	if not t2.value13 then
		return
	end

	createWireframeBox()
end)
t2.value7.CharacterAdded:Connect(function()
	local value8 = t2.value8

	if value8 then
		value8 = t2.value13
	end

	if not value8 then
		return
	end

	wait(0.3)
	destroyWireframe()
	createWireframeBox()
end)
t2.value4.InputBegan:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.RightControl then
		return
	end

	t2.value19.Visible = not t2.value19.Visible

	if not t2.value19.Visible then
		return
	end

	createNotification("UI", "UI is now visible")
end)
wait(3)
t2.value22.BackgroundTransparency = 1
createNotification("Script Loaded", "Football Reach UI Ready!")
createNotification("Enhanced BALLS detection", "2 different ways both are great (some games the ball needs to be big to have reach so this doesn\'t has make balls big yet v2 will have it tho)")

if t2.value1 then
	createNotification("TPS Street Soccer", "✓ TPS anticheat bypasses active")
end

createNotification("Controls", "Drag title bar to move\nRightControl: Hide/Show UI")
print("=============================================")
print("I\'M AT YO MAMAS HOUSE AHAHAH")
print("Game ID: " .. tostring(GameId))

if not t2.value1 then
	print("✓ BALLS")
	print("✓ w reach?")
	print("✓ excellent ball detection")
	print("=============================================")

	return
end

print("✓ tps street soccer? bro what")
print("✓ u suck at tps street soccer??")
print("✓ BALLS")
print("✓ w reach?")
print("✓ excellent ball detection")
print("=============================================")
