--// CLIENT-SIDED MORPH + FACE GUI + PLAYER GRAB + CAMERA
--// LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local MESH_ID = "rbxassetid://117463870444433"

local MESH_SCALE = Vector3.new(1.25, 1.25, 1.25)

local MORPH_Y_OFFSET = -2

local Faces = {
	["Hurt Face"] = "rbxassetid://75715580041052",
	["Smile"] = "rbxassetid://94483448038209",
	["Bored"] = "rbxassetid://124763361880005",
	["Tired"] = "rbxassetid://132725992789570",
	["Tired (Speak)"] = "rbxassetid://109732784554716",
	["Normal"] = "rbxassetid://108513786888650",
	["Talk Normal"] = "rbxassetid://75661658252242"
}

local FaceOrder = {
	"Hurt Face",
	"Smile",
	"Bored",
	"Tired",
	"Tired (Speak)",
	"Normal",
	"Talk Normal"
}

local CurrentTexture = Faces["Normal"]
local CurrentMorph = nil
local SelectedButton = nil

--==================================================
-- GRAB VARIABLES
--==================================================

local GrabEnabled = false
local SelectedPlayer = nil
local GrabWeld = nil
local NormalWeld = nil

--==================================================
-- CAMERA VARIABLES
--==================================================

local Camera = workspace.CurrentCamera
local CameraFollowing = false

--==================================================
-- REMOVE OLD GUI
--==================================================

local OldGui = PlayerGui:FindFirstChild("MorphFaceGUI")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorphFaceGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- HELPER FUNCTIONS
--==================================================

local function AddCorner(Object, Radius)

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, Radius)
	Corner.Parent = Object

	return Corner
end

local function AddStroke(Object, Thickness)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(145, 105, 0)
	Stroke.Thickness = Thickness
	Stroke.Parent = Object

	return Stroke
end

--==================================================
-- FACE GUI
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 270, 0, 390)
Main.Position = UDim2.new(0, 20, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(255, 221, 40)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

AddCorner(Main, 10)
AddStroke(Main, 4)

--==================================================
-- FACE TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -55, 0, 45)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "MORPH FACES"
Title.TextColor3 = Color3.fromRGB(75, 55, 0)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

--==================================================
-- FACE X BUTTON
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -43, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 135, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 19
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Main

AddCorner(CloseButton, 7)

--==================================================
-- FACE BUTTON CONTAINER
--==================================================

local Container = Instance.new("ScrollingFrame")
Container.Name = "FaceButtons"
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 5
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

--==================================================
-- FACE BUTTONS
--==================================================

local Buttons = {}

local function SelectFace(Name, Button)

	if not CurrentMorph then
		return
	end

	if not CurrentMorph.Parent then
		return
	end

	CurrentTexture = Faces[Name]
	CurrentMorph.TextureId = CurrentTexture

	if SelectedButton then
		SelectedButton.BackgroundColor3 =
			Color3.fromRGB(255, 235, 90)
	end

	Button.BackgroundColor3 =
		Color3.fromRGB(205, 160, 0)

	SelectedButton = Button
end

for Index, Name in ipairs(FaceOrder) do

	local Button = Instance.new("TextButton")

	Button.Name = Name
	Button.LayoutOrder = Index
	Button.Size = UDim2.new(1, -5, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(255, 235, 90)
	Button.BorderSizePixel = 0
	Button.Text = Name
	Button.TextColor3 = Color3.fromRGB(75, 55, 0)
	Button.TextSize = 16
	Button.Font = Enum.Font.GothamBold
	Button.Parent = Container

	AddCorner(Button, 7)
	AddStroke(Button, 2)

	Buttons[Name] = Button

	Button.MouseButton1Click:Connect(function()
		SelectFace(Name, Button)
	end)
end

--==================================================
-- FACE RETURN UI
--==================================================

local ReturnUI = Instance.new("TextButton")
ReturnUI.Name = "ReturnUI"
ReturnUI.Size = UDim2.new(0, 125, 0, 40)
ReturnUI.Position = UDim2.new(0, 20, 1, -60)
ReturnUI.BackgroundColor3 = Color3.fromRGB(255, 221, 40)
ReturnUI.BorderSizePixel = 0
ReturnUI.Text = "Return UI"
ReturnUI.TextColor3 = Color3.fromRGB(75, 55, 0)
ReturnUI.TextSize = 16
ReturnUI.Font = Enum.Font.GothamBold
ReturnUI.Visible = false
ReturnUI.Parent = ScreenGui

AddCorner(ReturnUI, 8)
AddStroke(ReturnUI, 3)

--==================================================
-- PLAYER GRAB GUI
--==================================================

local GrabFrame = Instance.new("Frame")
GrabFrame.Name = "PlayerGrab"
GrabFrame.Size = UDim2.new(0, 280, 0, 300)
GrabFrame.Position = UDim2.new(0, 305, 0.5, -150)
GrabFrame.BackgroundColor3 = Color3.fromRGB(255, 221, 40)
GrabFrame.BorderSizePixel = 0
GrabFrame.Parent = ScreenGui

AddCorner(GrabFrame, 10)
AddStroke(GrabFrame, 4)

--==================================================
-- GRAB TITLE
--==================================================

local GrabTitle = Instance.new("TextLabel")
GrabTitle.Name = "GrabTitle"
GrabTitle.Size = UDim2.new(1, -50, 0, 35)
GrabTitle.Position = UDim2.new(0, 10, 0, 5)
GrabTitle.BackgroundTransparency = 1
GrabTitle.Text = "PLAYER GRAB"
GrabTitle.TextColor3 = Color3.fromRGB(75, 55, 0)
GrabTitle.TextSize = 20
GrabTitle.Font = Enum.Font.GothamBold
GrabTitle.TextXAlignment = Enum.TextXAlignment.Left
GrabTitle.Parent = GrabFrame

--==================================================
-- GRAB X
--==================================================

local GrabClose = Instance.new("TextButton")
GrabClose.Name = "GrabClose"
GrabClose.Size = UDim2.new(0, 35, 0, 35)
GrabClose.Position = UDim2.new(1, -43, 0, 5)
GrabClose.BackgroundColor3 = Color3.fromRGB(180, 135, 0)
GrabClose.BorderSizePixel = 0
GrabClose.Text = "X"
GrabClose.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabClose.TextSize = 19
GrabClose.Font = Enum.Font.GothamBold
GrabClose.Parent = GrabFrame

AddCorner(GrabClose, 7)

--==================================================
-- GRAB RETURN UI
--==================================================

local GrabReturnUI = Instance.new("TextButton")
GrabReturnUI.Name = "GrabReturnUI"
GrabReturnUI.Size = UDim2.new(0, 125, 0, 40)
GrabReturnUI.Position = UDim2.new(0, 160, 1, -60)
GrabReturnUI.BackgroundColor3 = Color3.fromRGB(255, 221, 40)
GrabReturnUI.BorderSizePixel = 0
GrabReturnUI.Text = "Return UI"
GrabReturnUI.TextColor3 = Color3.fromRGB(75, 55, 0)
GrabReturnUI.TextSize = 16
GrabReturnUI.Font = Enum.Font.GothamBold
GrabReturnUI.Visible = false
GrabReturnUI.Parent = ScreenGui

AddCorner(GrabReturnUI, 8)
AddStroke(GrabReturnUI, 3)

--==================================================
-- SEARCH BOX
--==================================================

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(255, 235, 90)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search players..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(75, 55, 0)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 100, 30)
SearchBox.TextSize = 15
SearchBox.Font = Enum.Font.Gotham
SearchBox.Parent = GrabFrame

AddCorner(SearchBox, 7)

--==================================================
-- PLAYER LIST
--==================================================

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, -20, 0, 125)
PlayerList.Position = UDim2.new(0, 10, 0, 87)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = GrabFrame

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0, 5)
PlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerLayout.Parent = PlayerList

--==================================================
-- GRAB BUTTON
--==================================================

local GrabButton = Instance.new("TextButton")
GrabButton.Name = "GrabToggle"
GrabButton.Size = UDim2.new(1, -20, 0, 40)
GrabButton.Position = UDim2.new(0, 10, 1, -50)
GrabButton.BackgroundColor3 = Color3.fromRGB(180, 135, 0)
GrabButton.BorderSizePixel = 0
GrabButton.Text = "GRAB: OFF"
GrabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabButton.TextSize = 17
GrabButton.Font = Enum.Font.GothamBold
GrabButton.Parent = GrabFrame

AddCorner(GrabButton, 7)

--==================================================
-- HIDE CHARACTER
--==================================================

local function HideCharacter(Character)

	for _, Object in ipairs(Character:GetDescendants()) do

		if Object:IsA("BasePart") then
			Object.LocalTransparencyModifier = 1

		elseif Object:IsA("Decal") or Object:IsA("Texture") then
			Object.Transparency = 1
		end
	end
end

local function KeepCharacterHidden(Character)

	task.spawn(function()

		while Character.Parent do

			for _, Object in ipairs(Character:GetDescendants()) do

				if Object:IsA("BasePart") then

					if Object.Name ~= "ClientMorph" then
						Object.LocalTransparencyModifier = 1
					end

				elseif Object:IsA("Decal") or Object:IsA("Texture") then
					Object.Transparency = 1
				end
			end

			task.wait(0.5)
		end
	end)
end

--==================================================
-- CREATE MORPH
--==================================================

local function CreateMorph(Character)

	local Root =
		Character:WaitForChild(
			"HumanoidRootPart",
			10
		)

	if not Root then
		warn("Morph: HumanoidRootPart not found")
		return
	end

	local OldMorph =
		Character:FindFirstChild("ClientMorph")

	if OldMorph then
		OldMorph:Destroy()
	end

	HideCharacter(Character)
	KeepCharacterHidden(Character)

	local Holder = Instance.new("Part")

	Holder.Name = "ClientMorph"
	Holder.Size = Vector3.new(2, 2, 2)

	Holder.Transparency = 0

	Holder.CanCollide = false
	Holder.CanTouch = false
	Holder.CanQuery = false
	Holder.Massless = true
	Holder.CastShadow = false
	Holder.Anchored = false

	Holder.Parent = Character

	local Mesh = Instance.new("SpecialMesh")

	Mesh.Name = "MorphMesh"

	Mesh.MeshType =
		Enum.MeshType.FileMesh

	Mesh.MeshId = MESH_ID

	Mesh.TextureId =
		CurrentTexture

	Mesh.Scale =
		MESH_SCALE

	Mesh.Parent = Holder

	CurrentMorph = Mesh

	Holder.CFrame =
		Root.CFrame *
		CFrame.new(0, MORPH_Y_OFFSET, 0)

	local Weld = Instance.new("Weld")

	Weld.Name = "MorphWeld"

	Weld.Part0 = Root
	Weld.Part1 = Holder

	Weld.C0 =
		CFrame.new(0, MORPH_Y_OFFSET, 0)

	Weld.Parent = Holder

	NormalWeld = Weld
end

--==================================================
-- STOP GRAB
--==================================================

local function StopGrab()

	GrabEnabled = false

	if GrabWeld then
		GrabWeld:Destroy()
		GrabWeld = nil
	end

	if CurrentMorph and CurrentMorph.Parent then

		local Holder =
			CurrentMorph.Parent

		local Character =
			Player.Character

		local Root =
			Character and
			Character:FindFirstChild(
				"HumanoidRootPart"
			)

		if Root then

			Holder.CFrame =
				Root.CFrame *
				CFrame.new(
					0,
					MORPH_Y_OFFSET,
					0
				)

			local Weld =
				Instance.new("Weld")

			Weld.Name = "MorphWeld"

			Weld.Part0 = Root
			Weld.Part1 = Holder

			Weld.C0 =
				CFrame.new(
					0,
					MORPH_Y_OFFSET,
					0
				)

			Weld.Parent = Holder

			NormalWeld = Weld
		end
	end

	-- Restore camera
	CameraFollowing = false

	Camera.CameraType =
		Enum.CameraType.Custom

	local Character =
		Player.Character

	local Humanoid =
		Character and
		Character:FindFirstChildOfClass(
			"Humanoid"
		)

	if Humanoid then
		Camera.CameraSubject = Humanoid
	end
end

--==================================================
-- START GRAB
--==================================================

local function StartGrab(TargetPlayer)

	if not CurrentMorph then
		return false
	end

	if not TargetPlayer then
		return false
	end

	local TargetCharacter =
		TargetPlayer.Character

	if not TargetCharacter then
		return false
	end

	local Hand =
		TargetCharacter:FindFirstChild(
			"RightHand"
		)
		or TargetCharacter:FindFirstChild(
			"Right Arm"
		)

	if not Hand then
		return false
	end

	local Holder =
		CurrentMorph.Parent

	if not Holder then
		return false
	end

	if NormalWeld then
		NormalWeld:Destroy()
		NormalWeld = nil
	end

	if GrabWeld then
		GrabWeld:Destroy()
		GrabWeld = nil
	end

	SelectedPlayer =
		TargetPlayer

	GrabEnabled = true

	Holder.CFrame =
		Hand.CFrame *
		CFrame.new(0, -0.5, 0)

	local Weld =
		Instance.new("Weld")

	Weld.Name = "GrabWeld"

	Weld.Part0 = Hand
	Weld.Part1 = Holder

	Weld.C0 =
		CFrame.new(0, -0.5, 0)

	Weld.Parent = Holder

	GrabWeld = Weld

	-- Camera follows target
	CameraFollowing = true

	Camera.CameraType =
		Enum.CameraType.Custom

	local TargetHumanoid =
		TargetCharacter:FindFirstChildOfClass(
			"Humanoid"
		)

	if TargetHumanoid then
		Camera.CameraSubject =
			TargetHumanoid
	else
		Camera.CameraSubject =
			TargetCharacter
	end

	return true
end

--==================================================
-- PLAYER LIST
--==================================================

local function UpdatePlayerList()

	for _, Object in ipairs(
		PlayerList:GetChildren()
	) do

		if Object:IsA("TextButton") then
			Object:Destroy()
		end
	end

	local Search =
		string.lower(
			SearchBox.Text
		)

	for _, TargetPlayer in ipairs(
		Players:GetPlayers()
	) do

		if TargetPlayer ~= Player then

			local Username =
				string.lower(
					TargetPlayer.Name
				)

			local DisplayName =
				string.lower(
					TargetPlayer.DisplayName
				)

			if Search == ""
				or string.find(
					Username,
					Search,
					1,
					true
				)
				or string.find(
					DisplayName,
					Search,
					1,
					true
				) then

				local Button =
					Instance.new("TextButton")

				Button.Size =
					UDim2.new(1, 0, 0, 32)

				Button.BackgroundColor3 =
					Color3.fromRGB(
						255,
						235,
						90
					)

				Button.BorderSizePixel = 0

				Button.Text =
					TargetPlayer.DisplayName
					.. " ("
					.. TargetPlayer.Name
					.. ")"

				Button.TextColor3 =
					Color3.fromRGB(
						75,
						55,
						0
					)

				Button.TextSize = 14
				Button.Font =
					Enum.Font.GothamBold

				Button.Parent =
					PlayerList

				AddCorner(Button, 6)

				if SelectedPlayer ==
					TargetPlayer then

					Button.BackgroundColor3 =
						Color3.fromRGB(
							205,
							160,
							0
						)
				end

				Button.MouseButton1Click:Connect(
					function()

						SelectedPlayer =
							TargetPlayer

						if GrabEnabled then

							local Success =
								StartGrab(
									TargetPlayer
								)

							if not Success then

								StopGrab()

								GrabButton.Text =
									"GRAB: OFF"

								GrabButton.BackgroundColor3 =
									Color3.fromRGB(
										180,
										135,
										0
									)
							end
						end

						UpdatePlayerList()
					end
				)
			end
		end
	end
end

SearchBox:GetPropertyChangedSignal(
	"Text"
):Connect(UpdatePlayerList)

Players.PlayerAdded:Connect(
	function()
		task.wait(0.1)
		UpdatePlayerList()
	end
)

Players.PlayerRemoving:Connect(
	function(RemovingPlayer)

		if SelectedPlayer ==
			RemovingPlayer then

			StopGrab()

			SelectedPlayer = nil

			GrabButton.Text =
				"GRAB: OFF"

			GrabButton.BackgroundColor3 =
				Color3.fromRGB(
					180,
					135,
					0
				)
		end

		UpdatePlayerList()
	end
)

UpdatePlayerList()

--==================================================
-- GRAB TOGGLE
--==================================================

GrabButton.MouseButton1Click:Connect(
	function()

		if GrabEnabled then

			StopGrab()

			GrabButton.Text =
				"GRAB: OFF"

			GrabButton.BackgroundColor3 =
				Color3.fromRGB(
					180,
					135,
					0
				)

			return
		end

		if not SelectedPlayer then

			GrabButton.Text =
				"SELECT A PLAYER"

			task.delay(1, function()

				if not GrabEnabled then
					GrabButton.Text =
						"GRAB: OFF"
				end

			end)

			return
		end

		local Success =
			StartGrab(
				SelectedPlayer
			)

		if Success then

			GrabButton.Text =
				"GRAB: ON"

			GrabButton.BackgroundColor3 =
				Color3.fromRGB(
					70,
					150,
					70
				)

		else

			GrabButton.Text =
				"GRAB FAILED"

			task.delay(1, function()

				if not GrabEnabled then
					GrabButton.Text =
						"GRAB: OFF"
				end

			end)
		end
	end
)

--==================================================
-- FACE GUI X / RETURN
--==================================================

CloseButton.MouseButton1Click:Connect(
	function()

		Main.Visible = false
		ReturnUI.Visible = true

	end
)

ReturnUI.MouseButton1Click:Connect(
	function()

		Main.Visible = true
		ReturnUI.Visible = false

	end
)

--==================================================
-- GRAB GUI X / RETURN
--==================================================

GrabClose.MouseButton1Click:Connect(
	function()

		GrabFrame.Visible = false
		GrabReturnUI.Visible = true

	end
)

GrabReturnUI.MouseButton1Click:Connect(
	function()

		GrabFrame.Visible = true
		GrabReturnUI.Visible = false

	end
)

--==================================================
-- DRAG FACE GUI
--==================================================

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position

		Input.Changed:Connect(function()

			if Input.UserInputState ==
				Enum.UserInputState.End then

				Dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		local Delta =
			Input.Position - DragStart

		Main.Position =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
	end
end)

--==================================================
-- DRAG GRAB GUI
--==================================================

local GrabDragging = false
local GrabDragStart
local GrabStartPosition

GrabTitle.InputBegan:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		GrabDragging = true
		GrabDragStart = Input.Position
		GrabStartPosition = GrabFrame.Position

		Input.Changed:Connect(function()

			if Input.UserInputState ==
				Enum.UserInputState.End then

				GrabDragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(Input)

	if not GrabDragging then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		local Delta =
			Input.Position - GrabDragStart

		GrabFrame.Position =
			UDim2.new(
				GrabStartPosition.X.Scale,
				GrabStartPosition.X.Offset + Delta.X,
				GrabStartPosition.Y.Scale,
				GrabStartPosition.Y.Offset + Delta.Y
			)
	end
end)

--==================================================
-- START MORPH
--==================================================

local function StartMorph(Character)

	task.wait(1)

	if not Character or not Character.Parent then
		return
	end

	CreateMorph(Character)

	task.wait(0.3)

	if Buttons["Normal"] then

		SelectFace(
			"Normal",
			Buttons["Normal"]
		)
	end
end

if Player.Character then

	task.spawn(function()
		StartMorph(Player.Character)
	end)

end

--==================================================
-- RESPAWN
--==================================================

Player.CharacterAdded:Connect(
	function(Character)

		GrabEnabled = false
		SelectedPlayer = nil
		GrabWeld = nil
		NormalWeld = nil

		CurrentMorph = nil
		SelectedButton = nil

		CameraFollowing = false

		Camera.CameraType =
			Enum.CameraType.Custom

		GrabButton.Text =
			"GRAB: OFF"

		GrabButton.BackgroundColor3 =
			Color3.fromRGB(
				180,
				135,
				0
			)

		task.spawn(function()
			StartMorph(Character)
		end)

		task.wait(0.2)

		UpdatePlayerList()
	end
)