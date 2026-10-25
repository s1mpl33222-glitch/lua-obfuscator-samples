-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FPSBoosterGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")

TextButton.Name = "ToggleButton"
TextButton.Size = UDim2.new(0, 50, 0, 50)
TextButton.Position = UDim2.new(0, 10, 0.5, -25)
TextButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
TextButton.Text = "⚡"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 24
TextButton.Font = Enum.Font.GothamBold
TextButton.BorderSizePixel = 0
TextButton.Active = true
TextButton.Draggable = true
TextButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = TextButton

local Frame = Instance.new("Frame")

Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = Frame

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Shadow"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, -15, 0, -15)
ImageLabel.Size = UDim2.new(1, 30, 1, 30)
ImageLabel.ZIndex = 0
ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.ImageTransparency = 0.7
ImageLabel.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Name = "Header"
Frame2.Size = UDim2.new(1, 0, 0, 40)
Frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 12)
UICorner3.Parent = Frame2

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -20, 1, 0)
TextLabel.Position = UDim2.new(0, 10, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "⚡ FPS BOOSTER"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, -20, 0, 30)
TextLabel2.Position = UDim2.new(0, 10, 0, 50)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "FPS: Calculating..."
TextLabel2.TextColor3 = Color3.fromRGB(100, 255, 100)
TextLabel2.TextSize = 18
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame

local function v15(p1, p2, p3)
	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, -20, 0, 35)
	Frame3.Position = p2
	Frame3.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame3

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -60, 1, 0)
	TextLabel3.Position = UDim2.new(0, 10, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = p1
	TextLabel3.TextColor3 = Color3.fromRGB(220, 220, 220)
	TextLabel3.TextSize = 13
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 45, 0, 22)
	Frame4.Position = UDim2.new(1, -50, 0.5, -11)
	Frame4.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame3

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)
	UICorner5.Parent = Frame4

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0, 18, 0, 18)
	Frame5.Position = UDim2.new(0, 2, 0.5, -9)
	Frame5.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame4

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(1, 0)
	UICorner6.Parent = Frame5

	local u23 = false

	local function v24()
		u23 = not u23

		local color3 = u23

		if color3 then
			color3 = Color3.fromRGB(100, 255, 100)
		end

		local color32 = color3 or Color3.fromRGB(60, 60, 75)
		local uDim2 = u23

		if not uDim2 then
			v29 = uDim2 or UDim2.new(0, 2, 0.5, -9)
			TweenService:Create(Frame4, TweenInfo.new(0.2), {
				BackgroundColor3 = color32
			}):Play()
			TweenService:Create(Frame5, TweenInfo.new(0.2), {
				Position = v29
			}):Play()
			p3(u23)

			return
		end

		uDim2 = UDim2.new(1, -20, 0.5, -9)

		local uDim22 = uDim2 or UDim2.new(0, 2, 0.5, -9)

		TweenService:Create(Frame4, TweenInfo.new(0.2), {
			BackgroundColor3 = color32
		}):Play()
		TweenService:Create(Frame5, TweenInfo.new(0.2), {
			Position = uDim22
		}):Play()
		p3(u23)
	end

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, 0, 1, 0)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = ""
	TextButton2.Parent = Frame3
	TextButton2.MouseButton1Click:Connect(v24)

	return u23
end

local u30 = false

v15("🔓 FPS Unlock", UDim2.new(0, 10, 0, 90), function(p4)
	u30 = p4

	if p4 then
		setfpscap(999)
	else
		setfpscap(60)
	end
end)

local u31 = false
local t1 = {}

local function v33(p5)
	u31 = p5

	if p5 then
		local function v34(p6)
			if p6:IsA("Part") or (p6:IsA("MeshPart") or p6:IsA("UnionOperation")) then
				if t1[p6] then
					p6.Material = Enum.Material.SmoothPlastic
					p6.Reflectance = 0

					return
				end

				t1[p6] = {
					Material = p6.Material,
					Reflectance = p6.Reflectance
				}
				p6.Material = Enum.Material.SmoothPlastic
				p6.Reflectance = 0
			elseif p6:IsA("Decal") or p6:IsA("Texture") then
				if t1[p6] then
					p6.Transparency = 1

					return
				end

				t1[p6] = {
					Transparency = p6.Transparency
				}
				p6.Transparency = 1

				return
			else
				if not (p6:IsA("ParticleEmitter") or (p6:IsA("Trail") or p6:IsA("Beam"))) then
					return
				end

				if not t1[p6] then
					t1[p6] = {
						Enabled = p6.Enabled
					}
				end

				p6.Enabled = false

				return
			end
		end

		for _, descendant in pairs(workspace:GetDescendants()) do
			v34(descendant)
		end

		workspace.DescendantAdded:Connect(function(descendant)
			if not u31 then
				return
			end

			task.wait(0.1)
			v34(descendant)
		end)
		game:GetService("Lighting").GlobalShadows = false
	else
		for k, v in pairs(t1) do
			local Parent

			if k then
				Parent = k.Parent
			else
				Parent = k
			end

			if Parent then
				for k2, v2 in pairs(v) do
					pcall(function()
						k[k2] = v2
					end)
				end
			end
		end

		game:GetService("Lighting").GlobalShadows = true
	end
end

v15("🛠️ Lag Fix", UDim2.new(0, 10, 0, 135), v33)

local now = tick()
local n1 = 0
local n2 = 0

local function v45()
	n1 = n1 + 1

	if not (tick() - now >= 1) then
		return
	end

	n2 = n1

	local textColor3 = n2 >= 50

	if textColor3 then
		textColor3 = Color3.fromRGB(100, 255, 100)
	end

	if not textColor3 then
		local v47 = n2 >= 30

		if v47 then
			v47 = Color3.fromRGB(255, 200, 100)
		end

		textColor3 = v47 or Color3.fromRGB(255, 100, 100)
	end

	TextLabel2.Text = string.format("FPS: %d", n2)
	TextLabel2.TextColor3 = textColor3
end

RunService.RenderStepped:Connect(v45)

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0, 30, 0, 30)
TextButton2.Position = UDim2.new(1, -35, 0, 5)
TextButton2.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TextButton2.Text = "×"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.TextSize = 20
TextButton2.Font = Enum.Font.GothamBold
TextButton2.BorderSizePixel = 0
TextButton2.Parent = Frame2

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = TextButton2
TextButton2.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local visible = true

TextButton.MouseButton1Click:Connect(function()
	visible = not visible
	Frame.Visible = visible

	if visible then
		local v51 = TweenService
		local v52 = TextButton
		local tweenInfo = TweenInfo.new(0.2)
		local color3 = Color3.fromRGB

		v51.Create(v51, v52, tweenInfo, {
			BackgroundColor3 = color3(100, 255, 100)
		}):Play()
	else
		TweenService:Create(TextButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		}):Play()
	end
end);
(function(p7)
	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 200, 0, 40)
	TextLabel3.Position = UDim2.new(0.5, -100, 0, -50)
	TextLabel3.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	TextLabel3.Text = p7
	TextLabel3.TextColor3 = Color3.fromRGB(100, 255, 100)
	TextLabel3.TextSize = 14
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.BorderSizePixel = 0
	TextLabel3.Parent = ScreenGui

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 10)
	UICorner5.Parent = TextLabel3
	TweenService:Create(TextLabel3, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -100, 0, 20)
	}):Play()
	task.wait(2)
	TweenService:Create(TextLabel3, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -100, 0, -50)
	}):Play()
	task.wait(0.3)
	TextLabel3:Destroy()
end)("✅ FPS Booster Loaded!")
print("FPS Booster successfully loaded!")
print("Script by: MortalHere")
