-- تعريف الخدمات واللاعب المحلي
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- متغيرات التحكم والحالات
local isRunning = false
local connection = nil
local afkConnection = nil
local platform = nil
local farmState = "RUNNING"
local timer = 0

-- إنشاء الواجهة العصرية (UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlockspinFarmUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
local mainFooter = Instance.new("UICorner")
mainFooter.CornerRadius = UDim.new(0, 12)
mainFooter.Parent = mainFrame
mainFrame.Parent = screenGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 100)
stroke.Thickness = 2
stroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Blockspin 24/7 Anti-AFK"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local dragging, dragStart, startPos
titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.85, 0, 0, 45)
toggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = toggleButton
toggleButton.Text = "الحالة: متوقف (OFF)"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

-- نظام منع الطرد بسبب الخمول (Anti-AFK 24/7)
local function setupAntiAFK()
	if afkConnection then afkConnection:Disconnect() end
	
	-- منع طرد روبلوكس الأساسي (Idled event)
	player.Idled:Connect(function()
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(0,0))
		end)
	end)
	
	-- حركة بسيطة جداً للكاميرا كل فترة لتجنب أي كشف خمول إضافي من السيرفر
	local afkTimer = 0
	afkConnection = RunService.RenderStepped:Connect(function(dt)
		if not isRunning then return end
		afkTimer = afkTimer + dt
		if afkTimer >= 60 then -- كل دقيقة تحريك خفيف لا يلاحظه اللاعب
			afkTimer = 0
			pcall(function()
				camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(1), 0)
			end)
		end
	end)
end

toggleButton.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	
	if isRunning then
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
		toggleButton.Text = "الحالة: شغال 24/7 (Anti-AFK)"
		
		setupAntiAFK()
		
		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")
		
		if hrp then
			platform = Instance.new("Part")
			platform.Size = Vector3.new(6, 1, 6)
			platform.Position = hrp.Position - Vector3.new(0, 3.5, 0)
			platform.Anchored = true
			platform.BrickColor = BrickColor.new("White")
			platform.Material = Enum.Material.SmoothPlastic
			platform.Parent = workspace
			
			hrp.CFrame = platform.CFrame + Vector3.new(0, 3.5, 0)
		end
		
		farmState = "RUNNING"
		timer = 0
		
		connection = RunService.RenderStepped:Connect(function(dt)
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				local root = char:FindFirstChild("HumanoidRootPart")
				if hum and root then
					
					timer = timer + dt
					
					if farmState == "RUNNING" then
						hum.WalkSpeed = 32
						
						-- ضغط W و Shift لتفريغ العداد للصفر
						pcall(function()
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
						end)
						
						if timer >= 11.0 then 
							farmState = "WAITING"
							timer = 0
							
							pcall(function()
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
							end)
						end
						
					elseif farmState == "WAITING" then
						hum.WalkSpeed = 16
						
						pcall(function()
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
						end)
						
						if timer >= 6.5 then 
							farmState = "RUNNING"
							timer = 0
						end
					end
					
					if platform then
						root.CFrame = CFrame.new(platform.Position.X, platform.Position.Y + 3.5, platform.Position.Z) * (root.CFrame - root.CFrame.Position)
					end
				end
			end
		end)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		toggleButton.Text = "الحالة: متوقف (OFF)"
		
		if afkConnection then
			afkConnection:Disconnect()
			afkConnection = nil
		end
		
		pcall(function()
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
		end)
		
		if platform then
			platform:Destroy()
			platform = nil
		end
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 16
			end
		end
	end
end)
