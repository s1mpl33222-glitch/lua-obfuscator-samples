local LocalPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.6826, 0, 0.1626, 0)
TextButton.Size = UDim2.new(0.0666, 0, 0.1169, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Instant Twisted"
TextButton.TextColor3 = Color3.fromRGB(245, 245, 245)
TextButton.TextScaled = true
TextButton.TextWrapped = true
TextButton.Draggable = true
UICorner.Parent = TextButton

local t1 = {
	"rbxassetid://13294471966",
	"rbxassetid://134775406437626"
}
local u7 = false
local u8 = nil
local u9 = false
local connection = nil

local function u11()
	-- upvalues: LocalPlayer (ref), u9 (ref), connection (ref), RunService (ref)
	local v12 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HumanoidRootPart = v12:WaitForChild("HumanoidRootPart")
	local Humanoid = v12:WaitForChild("Humanoid")

	u9 = true
	connection = RunService.RenderStepped:Connect(function()
		-- upvalues: u9 (ref), Humanoid (ref)
		if u9 and Humanoid.AutoRotate then
			Humanoid.AutoRotate = false
		end
	end)

	local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
	local v16 = HumanoidRootPartCFrame * CFrame.Angles(0, math.rad(-135), 0)
	local v17 = HumanoidRootPartCFrame * CFrame.Angles(0, math.rad(0), 0)

	task.wait(0.39)

	local t2 = {
		[1] = {
			Dash = Enum.KeyCode.W,
			Key = Enum.KeyCode.Q,
			Goal = "KeyPress"
		}
	}
	local Communicate = v12:FindFirstChild("Communicate")

	if Communicate then
		Communicate:FireServer(unpack(t2))
	end

	HumanoidRootPart.CFrame = v16
	task.wait(0.125)
	HumanoidRootPart.CFrame = v17
	task.wait(0.8)
	u9 = false

	if connection then
		connection:Disconnect()
		connection = nil
	end
end

TextButton.MouseButton1Click:Connect(function()
	-- upvalues: u7 (ref), TextButton (ref), LocalPlayer (ref), u8 (ref), t1 (ref), u11 (ref)
	u7 = not u7
	TextButton.Text = u7 and "ON" or "OFF"

	if not u7 then
		if u8 then
			u8:Disconnect()
			u8 = nil
		end
	else
		u8 = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid").AnimationPlayed:Connect(function(animation)
			-- upvalues: t1 (ref), u11 (ref)
			for _, v in ipairs(t1) do
				if v == animation.Animation.AnimationId then
					task.spawn(u11)

					return
				end
			end
		end)
	end
end)
LocalPlayer.CharacterAdded:Connect(function()
	-- upvalues: u7 (ref), TextButton (ref), u8 (ref), connection (ref)
	u7 = false
	TextButton.Text = "OFF"

	if u8 then
		u8:Disconnect()
		u8 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end
end)
