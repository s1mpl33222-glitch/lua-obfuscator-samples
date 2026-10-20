--Bruh are you serious right now
if true then return end
local plr = game:GetService("Players").LocalPlayer
if plr.PlayerGui:FindFirstChild("TeamGui") or game.PlaceId~=155615604 then
	return
end
local HideGui = function()
	local Camera = game:GetService("Workspace").CurrentCamera
	task.delay(0.05,function()
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,true)
	end)
	for i = 1, 3 do
		pcall(function()
			plr.PlayerGui:FindFirstChild("Home"):FindFirstChild("intro").Visible=false
			plr.PlayerGui:FindFirstChild("Home"):FindFirstChild("hud").Visible=true
			Camera.FieldOfView=70
			Camera.CameraType=Enum.CameraType.Custom
			Camera.CameraSubject=plr.Character:FindFirstChild("Humanoid")
		end)
		wait()
	end
end

local TeamGui = Instance.new("ScreenGui")
local TeamFrame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local InmateImage = Instance.new("ImageLabel")
local GuardImage = Instance.new("ImageLabel")
local CriminalImage = Instance.new("ImageLabel")
local InmateButton = Instance.new("TextButton")
local GuardButton = Instance.new("TextButton")
local CriminalButton = Instance.new("TextButton")

TeamGui.Name = "TeamGui"
TeamGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TeamGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TeamGui.ResetOnSpawn = false

TeamFrame.Name = "TeamFrame"
TeamFrame.Parent = TeamGui
TeamFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TeamFrame.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
TeamFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeamFrame.BorderSizePixel = 0
TeamFrame.Position = UDim2.new(0.498828262, 0, 0.498792917, 0)
TeamFrame.Size = UDim2.new(0, 369, 0, 191)
TeamFrame.Visible = plr.Team.Name=="Neutral"

TextLabel.Parent = TeamFrame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0, 369, 0, 37)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "Select Team"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

InmateImage.Name = "InmateImage"
InmateImage.Parent = TeamFrame
InmateImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InmateImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
InmateImage.BorderSizePixel = 0
InmateImage.Position = UDim2.new(0.363143623, 0, 0.235602096, 0)
InmateImage.Size = UDim2.new(0, 100, 0, 100)
InmateImage.Image = "rbxassetid://105432394347477"

GuardImage.Name = "GuardImage"
GuardImage.Parent = TeamFrame
GuardImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuardImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuardImage.BorderSizePixel = 0
GuardImage.Position = UDim2.new(0.680216789, 0, 0.235602096, 0)
GuardImage.Size = UDim2.new(0, 100, 0, 100)
GuardImage.Image = "rbxassetid://136330693516119"

CriminalImage.Name = "CriminalImage"
CriminalImage.Parent = TeamFrame
CriminalImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CriminalImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
CriminalImage.BorderSizePixel = 0
CriminalImage.Position = UDim2.new(0.0460704602, 0, 0.235602096, 0)
CriminalImage.Size = UDim2.new(0, 100, 0, 100)
CriminalImage.Image = "rbxassetid://119068648583522"

InmateButton.Name = "InmateButton"
InmateButton.Parent = TeamFrame
InmateButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
InmateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
InmateButton.BorderSizePixel = 0
InmateButton.Position = UDim2.new(0.363143623, 0, 0.806282699, 0)
InmateButton.Size = UDim2.new(0, 100, 0, 27)
InmateButton.Font = Enum.Font.FredokaOne
InmateButton.Text = "INMATES"
InmateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InmateButton.TextScaled = true
InmateButton.TextSize = 14.000
InmateButton.TextWrapped = true

GuardButton.Name = "GuardButton"
GuardButton.Parent = TeamFrame
GuardButton.BackgroundColor3 = Color3.fromRGB(0, 17, 255)
GuardButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuardButton.BorderSizePixel = 0
GuardButton.Position = UDim2.new(0.680216789, 0, 0.806282699, 0)
GuardButton.Size = UDim2.new(0, 100, 0, 27)
GuardButton.Font = Enum.Font.FredokaOne
GuardButton.Text = "GUARDS"
GuardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuardButton.TextScaled = true
GuardButton.TextSize = 14.000
GuardButton.TextWrapped = true

CriminalButton.Name = "CriminalButton"
CriminalButton.Parent = TeamFrame
CriminalButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CriminalButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CriminalButton.BorderSizePixel = 0
CriminalButton.Position = UDim2.new(0.0460704602, 0, 0.806282699, 0)
CriminalButton.Size = UDim2.new(0, 100, 0, 27)
CriminalButton.Font = Enum.Font.FredokaOne
CriminalButton.Text = "CRIMINALS"
CriminalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CriminalButton.TextScaled = true
CriminalButton.TextSize = 14.000
CriminalButton.TextWrapped = true

local LockButton = Instance.new("ImageButton")
LockButton.Name = "LockButton"
LockButton.Parent = TeamFrame
LockButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LockButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
LockButton.BorderSizePixel = 0
LockButton.Position = UDim2.new(0.0189701896, 0, 0.031413611, 0)
LockButton.Size = UDim2.new(0, 25, 0, 25)
LockButton.Image = "rbxassetid://4625478089"
TeamFrame.Active = true
TeamFrame.Draggable = false
LockButton.MouseButton1Click:Connect(function()
	if TeamFrame.Draggable then
		LockButton.Image = "rbxassetid://4625478089"
		TeamFrame.Draggable = false
	else
		LockButton.Image = "rbxassetid://79152117433951"
		TeamFrame.Draggable = true
	end
end)

GuardButton.MouseButton1Click:Connect(function()
	workspace.Remote.TeamEvent:FireServer("Bright blue")
	if #game:GetService("Teams").Guards:GetPlayers()>7 then
		game:GetService("StarterGui"):SetCore("SendNotification",{Title="Guards is full",Text="Guards team is currently full!",Duration=5,})
		_G.TopBarNotif("Error! Guards team is currently full. Please select a different team.",nil,true)
	end
end)
InmateButton.MouseButton1Click:Connect(function()
	workspace.Remote.TeamEvent:FireServer("Bright orange")
end)
CriminalButton.MouseButton1Click:Connect(function()
	if #game:GetService("Teams").Guards:GetPlayers()>7 then
		workspace.Remote.TeamEvent:FireServer("Bright orange")
	end
	workspace.Remote.TeamEvent:FireServer("Bright blue")
	local RS = game:GetService("RunService").RenderStepped
	repeat RS:Wait()
		pcall(function()
			plr.Character:PivotTo(workspace["Criminals Spawn"].SpawnLocation:GetPivot()*CFrame.new(0,1.5,0))
		end)
	until plr.Team.Name=="Criminals"
end)
plr.CharacterAdded:Connect(function()
	if plr.Team.Name=="Neutral" then
		task.spawn(HideGui)
		TeamFrame.Visible = true
		local char = plr.Character
		local hum = char:WaitForChild("Humanoid",1)
		repeat task.wait() until hum.Health==0 or plr.Character~=char
		if plr.Team.Name=="Neutral" and hum.Health==0 then
			workspace.Remote.TeamEvent:FireServer("Medium stone grey")
		end
	else
		TeamFrame.Visible = false
	end
end)
if plr.Team.Name=="Neutral" then
	task.spawn(HideGui)
end
pcall(function()
	plr.PlayerGui:FindFirstChild("Home"):FindFirstChild("fadeFrame").Visible = false
end)
return HideGui
