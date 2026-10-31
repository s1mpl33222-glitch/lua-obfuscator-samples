if not game:IsLoaded() then
	game.Loaded:Wait()
end

local TweenService = game:GetService("TweenService")

game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

ScreenGui.Name = "BlickShotLoading"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)

Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(26, 32, 44)
Frame.BackgroundTransparency = 1
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local ImageLabel = Instance.new("ImageLabel", Frame)

ImageLabel.Size = UDim2.new(0, 60, 0, 60)
ImageLabel.Position = UDim2.new(0.5, -30, 0, 20)
ImageLabel.BackgroundTransparency = 1
ImageLabel.ImageTransparency = 1
ImageLabel.Image = "rbxassetid://96361480245003"

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Text = "Subscribe to BlickShot"
TextLabel.Size = UDim2.new(1, -20, 0, 40)
TextLabel.Position = UDim2.new(0, 10, 0, 90)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 20
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.TextTransparency = 1

local Frame2 = Instance.new("Frame", Frame)

Frame2.Size = UDim2.new(1, -40, 0, 8)
Frame2.Position = UDim2.new(0, 20, 0, 140)
Frame2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame2.BackgroundTransparency = 0.2
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

local Frame3 = Instance.new("Frame", Frame2)

Frame3.Size = UDim2.new(0, 0, 1, 0)
Frame3.Position = UDim2.new(0, 0, 0, 0)
Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame3.BackgroundTransparency = 0
Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
TweenService:Create(Frame, TweenInfo.new(0.4), {
	BackgroundTransparency = 0
}):Play()
TweenService:Create(ImageLabel, TweenInfo.new(0.4), {
	ImageTransparency = 0
}):Play()
TweenService:Create(TextLabel, TweenInfo.new(0.4), {
	TextTransparency = 0
}):Play()

local tween = TweenService:Create(Frame3, TweenInfo.new(3.2, Enum.EasingStyle.Linear), {
	Size = UDim2.new(1, 0, 1, 0)
})

tween:Play()
tween.Completed:Wait()

local n1 = 0.5

TweenService:Create(Frame, TweenInfo.new(n1), {
	BackgroundTransparency = 1
}):Play()
TweenService:Create(ImageLabel, TweenInfo.new(n1), {
	ImageTransparency = 1
}):Play()
TweenService:Create(TextLabel, TweenInfo.new(n1), {
	TextTransparency = 1
}):Play()
TweenService:Create(Frame3, TweenInfo.new(n1), {
	BackgroundTransparency = 1
}):Play()
TweenService:Create(Frame2, TweenInfo.new(n1), {
	BackgroundTransparency = 1
}):Play()
task.wait(n1 + 0.1)
ScreenGui:Destroy()
get_service = setmetatable({}, {
	__index = function(_, p1)
		return cloneref(game.GetService(game, p1))
	end
})

local _ = get_service.ProximityPromptService
local MarketplaceService = get_service.MarketplaceService
local ReplicatedStorage = get_service.ReplicatedStorage
local UserInputService = get_service.UserInputService
local VirtualUser = get_service.VirtualUser
local RunService = get_service.RunService
local Workspace = get_service.Workspace
local Players = get_service.Players
local _ = get_service.Stats

MarketplaceService:GetProductInfo(game.PlaceId)

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer.Backpack
local World = Workspace:FindFirstChild("World")

if not World then
	return LocalPlayer:Kick("World folder not found!")
end

local NPCs = World:FindFirstChild("NPCs")

if not NPCs then
	return LocalPlayer:Kick("NPCs folder not found!")
end

if not World:FindFirstChild("Zones"):FindFirstChild("_Ambience") then
	return LocalPlayer:Kick("Zones folder not found!")
end

local _NoDig = World:FindFirstChild("Zones"):FindFirstChild("_NoDig")

if not _NoDig then
	return LocalPlayer:Kick("Holes folder not found!")
end

local Totems = Workspace:FindFirstChild("Active"):FindFirstChild("Totems")

if not Totems then
	return LocalPlayer:Kick("Totems folder not found!")
end

if not Workspace:FindFirstChild("Spawns"):FindFirstChild("BossSpawns") then
	return LocalPlayer:Kick("Bosses folder not found!")
end

local s1 = "Notify"
local s2 = "Fire Signal"
local s3 = "Legit"
local n2 = 5
local n3 = 10
local u30 = false
local u31 = false
local u32 = false
local u33 = false
local u34 = false
local u35 = false
local u36 = false
local u37 = false
local u38 = false

function get_tool()
	return LocalPlayer.Character:FindFirstChildOfClass("Tool")
end
function closest_totem()
	local n4 = 9e99
	local v40 = nil

	for _, v in Totems:GetChildren() do
		if v:GetAttribute("IsActive") then
			local Magnitude = (v:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude

			if Magnitude < n4 then
				v40 = v
				n4 = Magnitude
			end
		end
	end

	return v40
end

LocalPlayer.Idled:Connect(function()
	if not u35 then
		return
	end

	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
	if not ((u36 or u33) and (not u30 and child.Name == "Dig")) then
		return
	end

	local Area_Strong = child:FindFirstChild("Safezone"):FindFirstChild("Holder"):FindFirstChild("Area_Strong")
	local PlayerBar = child:FindFirstChild("Safezone"):FindFirstChild("Holder"):FindFirstChild("PlayerBar")
	local MobileClick = child:FindFirstChild("MobileClick")
	local connection = nil
	local v48 = PlayerBar

	connection = PlayerBar.GetPropertyChangedSignal(v48, "Position"):Connect(function()
		if (u36 or u33) and not u30 then
			local v49 = not u33 and u36
			local v50, v51

			if not v49 then
				if v49 then
					PlayerBar.Position = UDim2.new(Area_Strong.Position.X.Scale, 0, 0, 0)

					if s2 ~= "Fire Signal" then
						v50 = s2 == "Tool Activate" and get_tool()

						if not v50 then
							return
						end

						v50:Activate()
						task.wait()
					else
						firesignal(MobileClick.Activated)
						task.wait()
					end
				else
					if not (u36 and (s3 == "Legit" and math.abs(PlayerBar.Position.X.Scale - Area_Strong.Position.X.Scale) <= 0.04)) then
						return
					end

					if s2 ~= "Fire Signal" then
						v51 = s2 == "Tool Activate" and get_tool()

						if not v51 then
							return
						end

						v51:Activate()
						task.wait()
					else
						firesignal(MobileClick.Activated)
						task.wait()
					end
				end

				return
			end

			v49 = s3 == "Blatant"

			if v49 then
				PlayerBar.Position = UDim2.new(Area_Strong.Position.X.Scale, 0, 0, 0)

				if s2 ~= "Fire Signal" then
					v50 = s2 == "Tool Activate" and get_tool()

					if not v50 then
						return
					end

					v50:Activate()
					task.wait()
				else
					firesignal(MobileClick.Activated)
					task.wait()
				end
			else
				if not (u36 and (s3 == "Legit" and math.abs(PlayerBar.Position.X.Scale - Area_Strong.Position.X.Scale) <= 0.04)) then
					return
				end

				if s2 ~= "Fire Signal" then
					v51 = s2 == "Tool Activate" and get_tool()

					if not v51 then
						return
					end

					v51:Activate()
					task.wait()
				else
					firesignal(MobileClick.Activated)
					task.wait()
				end
			end
		else
			if not connection then
				return
			end

			connection:Disconnect()
			connection = nil
		end
	end)
	child.AncestryChanged:Connect(function()
		if child.Parent or not connection then
			return
		end

		connection:Disconnect()
		connection = nil
	end)
end)
UserInputService.JumpRequest:Connect(function()
	if not (u34 and not u38) then
		return
	end

	u38 = true
	LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
	task.wait()
	u38 = false
end)
RunService.Heartbeat:Connect(function()
	if not (u37 and LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0)) then
		return
	end

	LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * n3 / 10)
end)

function is_staff(p2)
	local rankInGroup = p2:GetRankInGroup(35289532)
	local roleInGroup = p2:GetRoleInGroup(35289532)

	if not (rankInGroup >= 2) then
		return
	end

	if s1 ~= "Kick" then
		if s1 ~= "Notify" then
			return
		end

		customNotify({
			Title = "Staff Detected!",
			Content = roleInGroup .. " detected! Username: " .. p2.DisplayName,
			Icon = "message-circle-warning",
			Duration = 5
		})
	else
		LocalPlayer:Kick(roleInGroup .. " detected! Username: " .. p2.DisplayName)
	end
end

Players.PlayerAdded:Connect(function(player)
	is_staff(player)
end)

local ScreenGui2 = Instance.new("ScreenGui", game.CoreGui)

ScreenGui2.Name = "CustomGUI"
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.ResetOnSpawn = false
ScreenGui2.Enabled = true

local ImageButton = Instance.new("ImageButton")

ImageButton.Name = "MinimizedButton"
ImageButton.Image = "rbxassetid://96361480245003"
ImageButton.Size = UDim2.new(0, 60, 0, 60)
ImageButton.Position = UDim2.new(0, 20, 0.5, -30)
ImageButton.Visible = false
ImageButton.BackgroundTransparency = 0
ImageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ImageButton.Parent = ScreenGui2
Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(1, 0)

local Frame4 = Instance.new("Frame")

Frame4.Name = "MainFrame"
Frame4.Size = UDim2.new(0, 600, 0, 400)
Frame4.Position = UDim2.new(0.5, -300, 0.5, -200)
Frame4.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame4.BorderSizePixel = 0
Frame4.Visible = true
Frame4.Parent = ScreenGui2
Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 10)

local Frame5 = Instance.new("Frame")

Frame5.Name = "TopBar"
Frame5.Size = UDim2.new(1, 0, 0, 30)
Frame5.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame5.BorderSizePixel = 0
Frame5.Parent = Frame4
Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 10)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "TitleLabel"
TextLabel2.Size = UDim2.new(1, -70, 1, 0)
TextLabel2.Position = UDim2.new(0, 10, 0, 0)
TextLabel2.Text = "Dig by BlickShot"
TextLabel2.TextColor3 = Color3.new(1, 1, 1)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 18
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame5

local TextButton = Instance.new("TextButton")

TextButton.Name = "CloseButton"
TextButton.Text = "X"
TextButton.Size = UDim2.new(0, 30, 0, 30)
TextButton.Position = UDim2.new(1, -30, 0, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.Gotham
TextButton.TextSize = 18
TextButton.Parent = Frame5

local TextButton2 = Instance.new("TextButton")

TextButton2.Name = "MinimizeButton"
TextButton2.Text = "-"
TextButton2.Size = UDim2.new(0, 30, 0, 30)
TextButton2.Position = UDim2.new(1, -60, 0, 0)
TextButton2.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
TextButton2.TextColor3 = Color3.new(1, 1, 1)
TextButton2.Font = Enum.Font.Gotham
TextButton2.TextSize = 18
TextButton2.Parent = Frame5

local Frame6 = Instance.new("Frame")

Frame6.Name = "TabPanel"
Frame6.Size = UDim2.new(0, 120, 1, -30)
Frame6.Position = UDim2.new(0, 0, 0, 30)
Frame6.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame6.Parent = Frame4
Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", Frame6)

UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Frame7 = Instance.new("Frame")

Frame7.Name = "ContentFrame"
Frame7.Size = UDim2.new(1, -120, 1, -30)
Frame7.Position = UDim2.new(0, 120, 0, 30)
Frame7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame7.BorderSizePixel = 0
Frame7.Parent = Frame4
Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 10)

local t1 = {}
local u65 = nil

local function createScrollingFrame(p3)
	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = p3 .. "TabButton"
	TextButton3.Size = UDim2.new(1, -20, 0, 40)
	TextButton3.Position = UDim2.new(0, 10, 0, 0)
	TextButton3.Text = p3
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	TextButton3.BorderSizePixel = 0
	TextButton3.Font = Enum.Font.Gotham
	TextButton3.TextSize = 16
	TextButton3.TextXAlignment = Enum.TextXAlignment.Left
	TextButton3.AutoButtonColor = true
	TextButton3.Parent = Frame6
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 20)

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = p3 .. "Content"
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Visible = false
	ScrollingFrame.Parent = Frame7
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
	ScrollingFrame.ScrollBarThickness = 6
	ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

	local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

	UIListLayout2.Padding = UDim.new(0, 10)
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout2.FillDirection = Enum.FillDirection.Vertical
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	t1[p3] = ScrollingFrame
	TextButton3.MouseButton1Click:Connect(function()
		if not u65 then
			ScrollingFrame.Visible = true
			TextButton3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			u65 = p3

			return
		end

		t1[u65].Visible = false
		Frame6:FindFirstChild(u65 .. "TabButton").BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ScrollingFrame.Visible = true
		TextButton3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		u65 = p3
	end)

	return ScrollingFrame
end

local Farm = createScrollingFrame("Farm")
local Misc = createScrollingFrame("Misc")
local Inventory = createScrollingFrame("Inventory")
local Teleport = createScrollingFrame("Teleport")

if Farm then
	Farm.Visible = true

	local v74 = Frame6

	Frame6.FindFirstChild(v74, "FarmTabButton").BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	u65 = "Farm"
end

local u75 = false
local vector2 = Vector2.new()
local uDim2 = UDim2.new()

Frame5.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u75 = true
	vector2 = UserInputService:GetMouseLocation()
	uDim2 = Frame4.Position
	input.Handled = true
end)
UserInputService.InputChanged:Connect(function(input)
	if not (u75 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
		return
	end

	local v78 = UserInputService:GetMouseLocation() - vector2

	Frame4.Position = UDim2.new(uDim2.X.Scale, uDim2.X.Offset + v78.X, uDim2.Y.Scale, uDim2.Y.Offset + v78.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u75 = false
end)

local u79 = false
local vector22 = Vector2.new()
local uDim22 = UDim2.new()

ImageButton.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u79 = true
	vector22 = UserInputService:GetMouseLocation()
	uDim22 = ImageButton.Position
	input.Handled = true
end)
UserInputService.InputChanged:Connect(function(input)
	if not (u79 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
		return
	end

	local v82 = UserInputService:GetMouseLocation() - vector22

	ImageButton.Position = UDim2.new(uDim22.X.Scale, uDim22.X.Offset + v82.X, uDim22.Y.Scale, uDim22.Y.Offset + v82.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u79 = false
end)
TextButton.MouseButton1Click:Connect(function()
	ScreenGui2:Destroy()
end)
TextButton2.MouseButton1Click:Connect(function()
	Frame4.Visible = false
	ImageButton.Visible = true
end)
ImageButton.MouseButton1Click:Connect(function()
	Frame4.Visible = true
	ImageButton.Visible = false
end)

local function createTextLabel(p4, p5)
	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Section_" .. p5:gsub(" ", "_")
	TextLabel3.Size = UDim2.new(1, 0, 0, 25)
	TextLabel3.Text = p5
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 17
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.TextWrapped = true
	TextLabel3.Parent = p4

	return TextLabel3
end
local function createFrame(p6, p7)
	local Frame8 = Instance.new("Frame")

	Frame8.Name = "Toggle_" .. p7.Title:gsub(" ", "_")
	Frame8.Size = UDim2.new(1, 0, 0, 50)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = p6

	local UIListLayout2 = Instance.new("UIListLayout", Frame8)

	UIListLayout2.Padding = UDim.new(0, 5)
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout2.FillDirection = Enum.FillDirection.Vertical
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Title"
	TextLabel3.Size = UDim2.new(1, -40, 0, 18)
	TextLabel3.Text = p7.Title
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 16
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.TextWrapped = true
	TextLabel3.Parent = Frame8

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = "Description"
	TextLabel4.Size = UDim2.new(1, -40, 0, 15)
	TextLabel4.Text = p7.Desc or ""
	TextLabel4.TextColor3 = Color3.fromRGB(180, 180, 180)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 12
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.TextWrapped = true
	TextLabel4.Parent = Frame8

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = "ToggleButton"
	TextButton3.Size = UDim2.new(0, 20, 0, 20)
	TextButton3.Position = UDim2.new(1, -20, 0.5, -10)
	TextButton3.BackgroundColor3 = p7.Default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 100)
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.Text = p7.Default and "��" or ""
	TextButton3.Font = Enum.Font.Gotham
	TextButton3.TextSize = 16
	TextButton3.Parent = Frame8
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 5)

	local Default = p7.Default

	TextButton3.MouseButton1Click:Connect(function()
		Default = not Default
		TextButton3.BackgroundColor3 = Default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 100)
		TextButton3.Text = Default and "��" or ""

		if not p7.Callback then
			return
		end

		p7.Callback(Default)
	end)

	return Frame8
end
local function createFrame2(p8, p9)
	local Frame8 = Instance.new("Frame")

	Frame8.Name = "Dropdown_" .. p9.Title:gsub(" ", "_")
	Frame8.Size = UDim2.new(1, 0, 0, 70)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = p8

	local UIListLayout2 = Instance.new("UIListLayout", Frame8)

	UIListLayout2.Padding = UDim.new(0, 5)
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout2.FillDirection = Enum.FillDirection.Vertical
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Title"
	TextLabel3.Size = UDim2.new(1, 0, 0, 18)
	TextLabel3.Text = p9.Title
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 16
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.TextWrapped = true
	TextLabel3.Parent = Frame8

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = "MainButton"
	TextButton3.Size = UDim2.new(1, -20, 0, 30)
	TextButton3.Position = UDim2.new(0, 10, 0, 0)
	TextButton3.Text = p9.Value
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	TextButton3.BorderSizePixel = 0
	TextButton3.Font = Enum.Font.Gotham
	TextButton3.TextSize = 14
	TextButton3.TextXAlignment = Enum.TextXAlignment.Left
	TextButton3.Parent = Frame8
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 5)

	local Frame9 = Instance.new("Frame")

	Frame9.Name = "DropdownPanel"
	Frame9.Size = UDim2.new(1, -20, 0, 0)
	Frame9.Position = UDim2.new(0, 10, 0, 0)
	Frame9.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Frame9.BorderSizePixel = 0
	Frame9.Visible = false
	Frame9.ZIndex = 2
	Frame9.Parent = Frame8

	local UIListLayout3 = Instance.new("UIListLayout", Frame9)

	UIListLayout3.Padding = UDim.new(0, 2)
	UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout3.FillDirection = Enum.FillDirection.Vertical
	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 5)

	for _, value in ipairs(p9.Values) do
		local TextButton4 = Instance.new("TextButton")

		TextButton4.Name = "Option_" .. value:gsub(" ", "_")
		TextButton4.Size = UDim2.new(1, 0, 0, 25)
		TextButton4.Text = value
		TextButton4.TextColor3 = Color3.new(1, 1, 1)
		TextButton4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TextButton4.BorderSizePixel = 0
		TextButton4.Font = Enum.Font.Gotham
		TextButton4.TextSize = 14
		TextButton4.TextXAlignment = Enum.TextXAlignment.Left
		TextButton4.Parent = Frame9
		TextButton4.MouseButton1Click:Connect(function()
			TextButton3.Text = value
			Frame9.Visible = false
			Frame8.Size = UDim2.new(1, 0, 0, 70)

			if not p9.Callback then
				return
			end

			p9.Callback(value)
		end)
	end

	TextButton3.MouseButton1Click:Connect(function()
		Frame9.Visible = not Frame9.Visible

		if Frame9.Visible then
			Frame8.Size = UDim2.new(1, 0, 0, 70 + 25 * #p9.Values + 2 * (#p9.Values - 1))
		else
			Frame8.Size = UDim2.new(1, 0, 0, 70)
		end
	end)

	return Frame8
end
local function createFrame3(p10, p11)
	local Frame8 = Instance.new("Frame")

	Frame8.Name = "Slider_" .. p11.Title:gsub(" ", "_")
	Frame8.Size = UDim2.new(1, 0, 0, 80)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = p10

	local UIListLayout2 = Instance.new("UIListLayout", Frame8)

	UIListLayout2.Padding = UDim.new(0, 5)
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout2.FillDirection = Enum.FillDirection.Vertical
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Title"
	TextLabel3.Size = UDim2.new(1, 0, 0, 18)
	TextLabel3.Text = p11.Title
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 16
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.TextWrapped = true
	TextLabel3.Parent = Frame8

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = "ValueLabel"
	TextLabel4.Size = UDim2.new(1, 0, 0, 15)
	TextLabel4.Text = tostring(p11.Value.Default)
	TextLabel4.TextColor3 = Color3.fromRGB(180, 180, 180)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 12
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame8

	local Frame9 = Instance.new("Frame")

	Frame9.Name = "SliderTrack"
	Frame9.Size = UDim2.new(1, -40, 0, 10)
	Frame9.Position = UDim2.new(0, 20, 0, 0)
	Frame9.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame8
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = "SliderThumb"
	TextButton3.Size = UDim2.new(0, 20, 0, 20)
	TextButton3.Position = UDim2.new(0, 0, 0.5, -10)
	TextButton3.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.Text = ""
	TextButton3.BorderSizePixel = 0
	TextButton3.Parent = Frame9
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(1, 0)

	local Min = p11.Value.Min
	local Max = p11.Value.Max
	local Step = p11.Step or 1
	local Default = p11.Value.Default
	local v113 = (Default - Min) / (Max - Min)

	TextButton3.Position = UDim2.new(v113, 0, 0.5, -10)
	TextLabel4.Text = tostring(Default)

	local u114 = false

	TextButton3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u114 = true
		input.Handled = true
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not (u114 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
			return
		end

		local X = UserInputService:GetMouseLocation().X
		local X2 = Frame9.AbsolutePosition.X
		local X3 = Frame9.AbsoluteSize.X
		local v118 = Min + math.clamp(X - X2, 0, X3) / X3 * (Max - Min)
		local v119 = math.round(v118 / Step) * Step
		local v120 = math.clamp(v119, Min, Max)

		if v120 == Default then
			return
		end

		Default = v120
		TextLabel4.Text = tostring(Default)

		local v121 = (Default - Min) / (Max - Min)

		TextButton3.Position = UDim2.new(v121, 0, 0.5, -10)

		if not p11.Callback then
			return
		end

		p11.Callback(Default)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u114 = false
	end)

	return Frame8
end
local function createTextButton(p12, p13)
	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = "Button_" .. p13.Title:gsub(" ", "_")
	TextButton3.Size = UDim2.new(1, -20, 0, 40)
	TextButton3.Position = UDim2.new(0, 10, 0, 0)
	TextButton3.Text = p13.Title
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	TextButton3.BorderSizePixel = 0
	TextButton3.Font = Enum.Font.Gotham
	TextButton3.TextSize = 16
	TextButton3.TextXAlignment = Enum.TextXAlignment.Center
	TextButton3.AutoButtonColor = true
	TextButton3.Parent = p12
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 5)

	if p13.Desc then
		local TextLabel3 = Instance.new("TextLabel")

		TextLabel3.Name = "Description"
		TextLabel3.Size = UDim2.new(1, 0, 0, 15)
		TextLabel3.Text = p13.Desc
		TextLabel3.TextColor3 = Color3.fromRGB(180, 180, 180)
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.Font = Enum.Font.Gotham
		TextLabel3.TextSize = 12
		TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
		TextLabel3.TextWrapped = true
		TextLabel3.Parent = TextButton3
		TextLabel3.Position = UDim2.new(0, 0, 1, -15)
	end

	TextButton3.MouseButton1Click:Connect(function()
		if not p13.Callback then
			return
		end

		p13.Callback()
	end)

	return TextButton3
end
local function v125(p14)
	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 300, 0, 100)
	Frame8.Position = UDim2.new(1, -310, 0, 10)
	Frame8.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Frame8.BorderSizePixel = 0
	Frame8.Parent = ScreenGui2
	Frame8.ZIndex = 10
	Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 10)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -20, 0, 20)
	TextLabel3.Position = UDim2.new(0, 10, 0, 10)
	TextLabel3.Text = p14.Title
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 18
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame8

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -20, 0, 50)
	TextLabel4.Position = UDim2.new(0, 10, 0, 35)
	TextLabel4.Text = p14.Content
	TextLabel4.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 14
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.TextWrapped = true
	TextLabel4.Parent = Frame8

	local TweenService2 = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	task.delay(p14.Duration or 5, function()
		local children = Frame8:GetChildren()

		for _, child in ipairs(children) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				TweenService2:Create(child, tweenInfo, {
					TextTransparency = 1
				}):Play()
			end
		end

		TweenService2:Create(Frame8, tweenInfo, {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.5)
		Frame8:Destroy()
	end)
end

local t2 = {
	Notify = v125
}

createTextLabel(Farm, "Dig Settings")
createFrame(Farm, {
	Title = "Auto Dig Minigame",
	Desc = "Automatically does the dig minigame for you",
	Icon = "check",
	Type = "Checkbox",
	Default = u36,
	Callback = function(p15)
		u36 = p15
	end
})
Instance.new("RemoteEvent", ReplicatedStorage:FindFirstChild("Remotes")).Name = "bWFkZSBieSBAa3lsb3NpbGx5IG9uIGRpc2NvcmQgPDM"
createFrame2(Farm, {
	Title = "Choose Dig Option:",
	Values = { "Legit", "Blatant" },
	Value = s3,
	Callback = function(p16)
		s3 = p16
	end
})
createFrame2(Farm, {
	Title = "Choose Dig Method:",
	Values = { "Fire Signal", "Tool Activate" },
	Value = s2,
	Callback = function(p17)
		s2 = p17
	end
})
createFrame(Farm, {
	Title = "Auto Holes",
	Desc = "Creates holes and automatically completes dig minigame blatantly",
	Icon = "check",
	Type = "Checkbox",
	Default = u33,
	Callback = function(p18)
		u33 = p18

		if not p18 then
			return
		end

		task.spawn(function()
			while true do
				local v135, children, v137, v138, v139

				if true then
					if not u30 then
						v135 = get_tool()

						if not (v135 and v135.Name:find("Shovel")) then
							children, v137, v138 = Backpack:GetChildren()

							while true do
								v138, v139 = children(v137, v138)

								if v138 == nil then
									break
								end

								if v139.Name:find("Shovel") then
									v139.Parent = LocalPlayer.Character

									return
								end

								continue
							end

							v135 = get_tool()
						end

						if _NoDig:FindFirstChild(LocalPlayer.Name .. "_Crater_Hitbox") then
							_NoDig[LocalPlayer.Name .. "_Crater_Hitbox"]:Destroy()
						end

						if not LocalPlayer.PlayerGui:FindFirstChild("Dig") and v135 then
							v135:Activate()
						end
					end
				else
					v135 = get_tool()

					if not (v135 and v135.Name:find("Shovel")) then
						children, v137, v138 = Backpack:GetChildren()

						while true do
							v138, v139 = children(v137, v138)

							if v138 == nil then
								break
							end

							if v139.Name:find("Shovel") then
								v139.Parent = LocalPlayer.Character

								return
							end

							continue
						end

						v135 = get_tool()
					end

					if _NoDig:FindFirstChild(LocalPlayer.Name .. "_Crater_Hitbox") then
						_NoDig[LocalPlayer.Name .. "_Crater_Hitbox"]:Destroy()
					end

					if not LocalPlayer.PlayerGui:FindFirstChild("Dig") and v135 then
						v135:Activate()
					end
				end

				task.wait(0.5)

				if not u33 then
					return
				end

				continue
			end
		end)
	end
})
createTextLabel(Farm, "Farm Settings")
createFrame(Farm, {
	Title = "Auto Pizza Delivery",
	Desc = "Automatically does pizza deliveries",
	Icon = "check",
	Type = "Checkbox",
	Default = u30,
	Callback = function(p19)
		u30 = p19

		if p19 then
			task.spawn(function()
				while true do
					print("Auto Pizza: Starting new cycle.")

					local ok, result = pcall(function()
						ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Change_Zone"):FireServer("Penguins Pizza")
						print("Auto Pizza: Fired Change_Zone to Penguins Pizza.")
						ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("StartInfiniteQuest"):InvokeServer("Pizza Penguin")
						print("Auto Pizza: Invoked StartInfiniteQuest.")
						task.wait(math.random(1, 3))

						local Model = Workspace:FindFirstChild("Active"):FindFirstChild("PizzaCustomers"):FindFirstChildOfClass("Model")

						if Model and Model:FindFirstChild("HumanoidRootPart") then
							print("Auto Pizza: Found pizza customer. Moving to position.")
							LocalPlayer.Character:MoveTo(Model.HumanoidRootPart.Position)
							task.wait(math.random(2, 5))
							ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Quest_DeliverPizza"):InvokeServer()
							print("Auto Pizza: Invoked Quest_DeliverPizza.")
							task.wait(math.random(1, 3))
							ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Change_Zone"):FireServer("Penguins Pizza")
							print("Auto Pizza: Fired Change_Zone to Penguins Pizza (return).")
							ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("CompleteInfiniteQuest"):InvokeServer("Pizza Penguin")
							print("Auto Pizza: Invoked CompleteInfiniteQuest.")
						else
							print("Auto Pizza: Pizza customer or HumanoidRootPart not found. Waiting for next cycle.")
							v125({
								Title = "Pizza Customer Not Found",
								Content = "Waiting for pizza customer to spawn...",
								Duration = 3
							})
							task.wait(5)
						end
					end)

					if not ok then
						warn("Auto Pizza Error: " .. tostring(result))
						v125({
							Title = "Auto Pizza Error",
							Content = "An error occurred: " .. tostring(result),
							Duration = 5
						})
					end

					print("Auto Pizza: Cycle complete. Waiting for next cycle (60-90s).")
					task.wait(math.random(60, 90))

					if not u30 then
						print("Auto Pizza: Loop stopped.")

						return
					end
				end
			end)
		else
			print("Auto Pizza: Feature disabled.")
		end
	end
})
createTextLabel(Misc, "Staff Settings")
createFrame(Misc, {
	Title = "Anti Staff",
	Desc = "Kicks/Notifies you when staff joins",
	Icon = "check",
	Type = "Checkbox",
	Default = u31,
	Callback = function(p20)
		u31 = p20

		if not p20 then
			return
		end

		for _, v in Players:GetPlayers() do
			if v ~= LocalPlayer then
				is_staff(v)
			end
		end
	end
})
createFrame2(Misc, {
	Title = "Choose Staff Method:",
	Values = { "Notify", "Kick" },
	Value = s1,
	Callback = function(p21)
		s1 = p21
	end
})
createTextLabel(Misc, "Anti Afk Settings")
createFrame(Misc, {
	Title = "Anti Afk",
	Desc = "Wont disconnect you after 20 minutes",
	Icon = "check",
	Type = "Checkbox",
	Default = u35,
	Callback = function(p22)
		u35 = p22
	end
})
createTextLabel(Misc, "LocalPlayer Settings")
createFrame(Misc, {
	Title = "Inf Jump",
	Desc = "Lets you jump infinitely",
	Icon = "check",
	Type = "Checkbox",
	Default = u34,
	Callback = function(p23)
		u34 = p23
	end
})
createFrame(Misc, {
	Title = "Tp Walk",
	Desc = "Lets You Move Fast",
	Icon = "check",
	Type = "Checkbox",
	Default = u37,
	Callback = function(p24)
		u37 = p24
	end
})
createFrame3(Misc, {
	Title = "Tp Walk Speed:",
	Step = 1,
	Value = {
		Min = 1,
		Max = 100,
		Default = n3
	},
	Callback = function(p25)
		n3 = tonumber(p25)
	end
})
createTextLabel(Inventory, "Sell Settings")
createFrame(Inventory, {
	Title = "Auto Sell",
	Desc = "Automatically sells every item in your inventory",
	Icon = "check",
	Type = "Checkbox",
	Default = u32,
	Callback = function(p26)
		u32 = p26

		if not p26 then
			return
		end

		task.spawn(function()
			while true do
				for _, v in Backpack:GetChildren() do
					ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("SellHeldItem"):FireServer(v)

					continue
				end

				task.wait(n2)

				if not u32 then
					return
				end

				continue
			end
		end)
	end
})
createFrame3(Inventory, {
	Title = "Auto Sell Delay:",
	Step = 1,
	Value = {
		Min = 1,
		Max = 60,
		Default = n2
	},
	Callback = function(p27)
		n2 = tonumber(p27)
	end
})
createTextButton(Inventory, {
	Title = "Sell All Items Once",
	Desc = "Sells all items in your inventory",
	Locked = false,
	Callback = function()
		for _, v in Backpack:GetChildren() do
			ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("SellHeldItem"):FireServer(v)
		end
	end
})
createTextButton(Inventory, {
	Title = "Sell Held Item",
	Desc = "Sells held item",
	Locked = false,
	Callback = function()
		local v149 = get_tool()

		if v149 then
			if v149:GetAttribute("InventoryLink") then
				ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("SellHeldItem"):FireServer(v149)

				return
			else
				return t2:Notify({
					Title = "Cant Sell!",
					Content = "Cant Sell This Item!",
					Icon = "message-circle-warning",
					Duration = 5
				})
			end
		else
			return t2:Notify({
				Title = "No Tool",
				Content = "No Tool Found!",
				Icon = "message-circle-warning",
				Duration = 5
			})
		end
	end
})
createTextLabel(Inventory, "Journal Settings")
createTextButton(Inventory, {
	Title = "Claim Unclaimed Discovered Items",
	Desc = "Claims every unclaimed Discovered item in journal",
	Locked = false,
	Callback = function()
		for _, v in LocalPlayer.PlayerGui:FindFirstChild("HUD"):FindFirstChild("Frame"):FindFirstChild("Journal"):FindFirstChild("Scroller"):GetChildren() do
			if v:IsA("ImageButton") and v:FindFirstChild("Discovered").Visible then
				firesignal(v.MouseButton1Click)
			end
		end
	end
})
createTextLabel(Teleport, "Misc Teleports")
createTextButton(Teleport, {
	Title = "Teleport To Merchant",
	Desc = "Teleports to merchant",
	Locked = false,
	Callback = function()
		local MerchantCart = NPCs:FindFirstChild("Merchant Cart")

		if MerchantCart then
			LocalPlayer.Character:MoveTo(MerchantCart:GetPivot().Position)
		else
			t2:Notify({
				Title = "Error",
				Content = "Merchant Cart not found!",
				Duration = 5
			})
		end
	end
})
createTextButton(Teleport, {
	Title = "Teleport To Meteor",
	Desc = "Teleports to meteor",
	Locked = false,
	Callback = function()
		if Workspace:FindFirstChild("Active"):FindFirstChild("ActiveMeteor") then
			LocalPlayer.Character:MoveTo(Workspace.Active.ActiveMeteor:GetPivot().Position)
		else
			t2:Notify({
				Title = "No Meteor",
				Content = "No Meteor Found!",
				Icon = "message-circle-warning",
				Duration = 5
			})
		end
	end
})
createTextButton(Teleport, {
	Title = "Teleport To EnchantmentAltar",
	Desc = "Teleports to EnchantmentAltar",
	Locked = false,
	Callback = function()
		local EnchantPart = World:FindFirstChild("Interactive"):FindFirstChild("Enchanting"):FindFirstChild("EnchantmentAltar"):FindFirstChild("EnchantPart")

		if EnchantPart then
			LocalPlayer.Character:MoveTo(EnchantPart:GetPivot().Position)
		else
			t2:Notify({
				Title = "Error",
				Content = "Enchantment Altar not found!",
				Duration = 5
			})
		end
	end
})
createTextButton(Teleport, {
	Title = "Teleport To Active Totem",
	Desc = "Teleports to closest active totem",
	Locked = false,
	Callback = function()
		local v154 = closest_totem()

		if v154 then
			LocalPlayer.Character:MoveTo(v154:GetPivot().Position)
		else
			return t2:Notify({
				Title = "No Totem",
				Content = "No Active Totem Found!",
				Icon = "message-circle-warning",
				Duration = 5
			})
		end
	end
})
