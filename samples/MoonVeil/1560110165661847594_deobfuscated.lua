-- This file was generated at discord.gg/syncrypt

print("successfully loaded")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local uDim2 = nil
local u9 = HttpService

pcall(function()
	local v34 = (function(...)
		local t1 = { ... }

		t1.n = select("#", ...)

		return t1
	end)(readfile("ChocolaAcceptPos.txt"))
	local data = u9:JSONDecode(unpack(v34, 1, v34.n))

	if data then
		uDim2 = UDim2.new(data.X, data.XOffset, data.Y, data.YOffset)
	end
end)

local u10 = HttpService

local function u11(p1)
	if p1 then
		local p1Position = p1.Position
		local t2 = {
			X = p1Position.X.Scale,
			XOffset = p1Position.X.Offset,
			Y = p1Position.Y.Scale,
			YOffset = p1Position.Y.Offset,
		}
		local u44 = t2

		pcall(function()
			writefile("ChocolaAcceptPos.txt", u10:JSONEncode(u44))
		end)

		return
	end
end

local u12 = true
local u13
local u14 = nil
local u15 = nil
local u16
local t3 = {
	Dark = Color3.fromRGB(8, 18, 40),
	Light = Color3.fromRGB(0, 200, 255),
	Border = Color3.fromRGB(100, 200, 255),
	Gradient1 = Color3.fromRGB(0, 80, 255),
	Gradient2 = Color3.fromRGB(0, 200, 255),
	Discord = Color3.fromRGB(160, 200, 255),
	Success = Color3.fromRGB(0, 255, 120),
	Error = Color3.fromRGB(255, 80, 100),
}
local u18 = CoreGui
local u19 = t3
local u20 = RunService
local u21 = UserInputService

local function u22()
	local ChocolaAutoAccept = u18.RobloxGui:FindFirstChild("ChocolaAutoAccept")

	if ChocolaAutoAccept then
		ChocolaAutoAccept:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ChocolaAutoAccept"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = u18.RobloxGui

	local Frame = Instance.new("Frame")

	Frame.Name = "MainFrame"
	Frame.Size = UDim2.new(0, 230, 0, 0)

	if not uDim2 then
		Frame.Position = UDim2.new(0.5, -115, 0.6, 0)
	else
		Frame.Position = uDim2
	end

	Frame.BackgroundColor3 = u19.Dark
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Frame.ClipsDescendants = true
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Color = u19.Border
	UIStroke.Thickness = 2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local n1 = 0
	local Heartbeat = u20.Heartbeat
	local u51 = UIStroke
	local connection = Heartbeat:Connect(function()
		n1 = n1 + 0.005

		if n1 > 1 then
			n1 = 0
		end

		local v90 = n1 * 3.141592653589793
		local v91 = 80 + 120 * math.sin(v90)
		local v92 = n1 * 3.141592653589793 + 0.5
		local v93 = 180 + 75 * math.sin(v92)

		u51.Color = Color3.fromRGB(0, v91, v93)
	end)
	local Frame2 = Instance.new("Frame", Frame)

	Frame2.Size = UDim2.new(1, 0, 0, 30)
	Frame2.BackgroundTransparency = 1

	local TextLabel = Instance.new("TextLabel", Frame2)

	TextLabel.Size = UDim2.new(1, -40, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Text = "CHOCOLA AUTO ACCEPT"
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextSize = 12
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UIGradient", TextLabel).Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, u19.Gradient1),
		ColorSequenceKeypoint.new(0.5, u19.Gradient2),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})

	local Frame3 = Instance.new("Frame", Frame2)

	Frame3.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
	Frame3.Size = UDim2.new(0, 20, 0, 20)
	Frame3.Position = UDim2.new(1, -26, 0.5, -10)
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 5)

	local TextButton = Instance.new("TextButton", Frame3)

	TextButton.Text = "-"
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 15
	TextButton.TextColor3 = u19.Light
	TextButton.BackgroundTransparency = 1
	TextButton.Size = UDim2.new(1, 0, 1, 0)

	local Frame4 = Instance.new("Frame", Frame)

	Frame4.Size = UDim2.new(1, -16, 1, -45)
	Frame4.Position = UDim2.new(0, 8, 0, 35)
	Frame4.BackgroundTransparency = 1
	Frame4.ClipsDescendants = true

	local UIListLayout = Instance.new("UIListLayout", Frame4)

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local u59 = Frame
	local u60 = UIListLayout

	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		task.wait()
		u59.Size = UDim2.new(0, 230, 0, u60.AbsoluteContentSize.Y + 45)
	end)

	local Frame5 = Instance.new("Frame", Frame4)

	Frame5.Size = UDim2.new(0.95, 0, 0, 28)
	Frame5.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
	Frame5.BorderSizePixel = 0
	Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 6)

	local TextLabel2 = Instance.new("TextLabel", Frame5)

	TextLabel2.Size = UDim2.new(0.6, 0, 1, 0)
	TextLabel2.Position = UDim2.new(0, 10, 0, 0)
	TextLabel2.Text = "Accept Trades"
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 11
	TextLabel2.TextColor3 = Color3.fromRGB(160, 200, 255)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

	local TextButton2 = Instance.new("TextButton", Frame5)

	TextButton2.Size = UDim2.new(0, 50, 0, 22)
	TextButton2.Position = UDim2.new(1, -55, 0.5, -11)
	TextButton2.BackgroundColor3 = u19.Success
	TextButton2.Text = "ON"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.TextSize = 10
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.BorderSizePixel = 0
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

	local MouseButton1Click = TextButton2.MouseButton1Click
	local u65 = TextButton2

	MouseButton1Click:Connect(function()
		u12 = not u12

		if not u12 then
			u65.BackgroundColor3 = u19.Error
			u65.Text = "OFF"

			return
		end

		u65.BackgroundColor3 = u19.Success
		u65.Text = "ON"
	end)

	local TextLabel3 = Instance.new("TextLabel", Frame4)

	TextLabel3.Size = UDim2.new(0.95, 0, 0, 22)
	TextLabel3.Text = "● Active"
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextSize = 13
	TextLabel3.TextColor3 = u19.Success
	TextLabel3.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
	TextLabel3.BorderSizePixel = 0
	Instance.new("UICorner", TextLabel3).CornerRadius = UDim.new(0, 6)
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Center

	local TextLabel4 = Instance.new("TextLabel", Frame4)

	TextLabel4.Size = UDim2.new(0.95, 0, 0, 18)
	TextLabel4.Text = "discord.gg/74GMyygaMy"
	TextLabel4.Font = Enum.Font.GothamBold
	TextLabel4.TextSize = 12
	TextLabel4.TextColor3 = u19.Discord
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Center

	local u68 = false
	local n2 = 0
	local MouseButton1Click2 = TextButton.MouseButton1Click
	local u71 = Frame
	local u72 = UIListLayout

	MouseButton1Click2:Connect(function()
		u68 = not u68

		if not u68 then
			u71.Size = UDim2.new(0, 230, 0, n2)
			Frame4.Visible = true
			TextButton.Text = "-"
			task.wait(0.05)

			local v94 = u72.AbsoluteContentSize.Y + 45

			if v94 ~= n2 then
				n2 = v94
				u71.Size = UDim2.new(0, 230, 0, v94)
			end
		else
			n2 = u71.Size.Y.Offset
			u71.Size = UDim2.new(0, 230, 0, 30)
			Frame4.Visible = false
			TextButton.Text = "+"
		end

		task.wait(0.1)
		u11(u71)
	end)

	local u73 = false
	local p2Position = nil
	local Position = nil
	local InputBegan = Frame.InputBegan
	local u77 = Frame

	InputBegan:Connect(function(p2)
		if p2.UserInputType == Enum.UserInputType.MouseButton1 then
			u73 = true
			p2Position = p2.Position
			Position = u77.Position
		end
	end)

	local InputChanged = u21.InputChanged
	local u79 = Frame

	InputChanged:Connect(function(p3)
		if u73 and p3.UserInputType == Enum.UserInputType.MouseMovement then
			local v97 = p3.Position - p2Position

			u79.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v97.X, Position.Y.Scale, Position.Y.Offset + v97.Y)
		end
	end)

	local InputEnded = u21.InputEnded
	local u81 = Frame

	InputEnded:Connect(function(p4)
		if p4.UserInputType == Enum.UserInputType.MouseButton1 then
			u73 = false
			u11(u81)
		end
	end)

	local AncestryChanged = Frame.AncestryChanged
	local u83 = Frame

	AncestryChanged:Connect(function()
		if not u83.Parent and connection then
			connection:Disconnect()
		end
	end)

	return TextButton2, TextLabel3, Frame
end

local u23 = LocalPlayer
local u24 = t3

local function v25()
	print("[Chocola] Inicializando script...")

	local v84, v85, v86 = u22()

	u16 = v84
	u15 = v85
	u14 = v86
	task.spawn(function()
		while task.wait(45) do
			local Character = u23.Character

			if Character and Character:FindFirstChild("Humanoid") then
				local Humanoid = Character.Humanoid

				if Humanoid and Humanoid.Health > 0 then
					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					print("[Anti-AFK] Saltando...")
				end
			end

			if u15 then
				local _ = u15.Text
				local _ = u15.TextColor3

				u15.Text = "🔄 AFK"
				u15.TextColor3 = Color3.fromRGB(255, 200, 0)
				task.wait(2)

				if not u12 then
					u15.Text = "● Paused"
					u15.TextColor3 = u24.Error
				else
					u15.Text = "● Active"
					u15.TextColor3 = u24.Success
				end
			end
		end
	end)
	task.delay(5, function()
		local PlayerGui = u23:WaitForChild("PlayerGui")
		local DuelsMachinePrompt = PlayerGui:FindFirstChild("DuelsMachinePrompt")

		if not DuelsMachinePrompt then
			warn("DuelsMachinePrompt no encontrado, esperando...")
			DuelsMachinePrompt = PlayerGui:WaitForChild("DuelsMachinePrompt")
		end

		local DuelsMachinePrompt2 = DuelsMachinePrompt:FindFirstChild("DuelsMachinePrompt")

		if not DuelsMachinePrompt2 then
			warn("DuelsMachinePrompt/DuelsMachinePrompt no encontrado, esperando...")
			DuelsMachinePrompt2 = DuelsMachinePrompt:WaitForChild("DuelsMachinePrompt")
		end

		local function v108()
			local Head = (u23.Character or u23.CharacterAdded:Wait()):FindFirstChild("Head")

			if Head then
				if not Head:FindFirstChild("AFKTag") then
					local BillboardGui = Instance.new("BillboardGui")

					BillboardGui.Name = "AFKTag"
					BillboardGui.Size = UDim2.new(0, 200, 0, 50)
					BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
					BillboardGui.AlwaysOnTop = true
					BillboardGui.Parent = Head

					local TextLabel = Instance.new("TextLabel")

					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Text = "Chocola Auto Accept AFK"
					TextLabel.TextColor3 = u24.Light
					TextLabel.TextStrokeTransparency = 0
					TextLabel.TextScaled = true
					TextLabel.Font = Enum.Font.GothamBold
					TextLabel.Parent = BillboardGui

					return
				end

				return
			end
		end

		v108()

		local CharacterAdded = u23.CharacterAdded
		local u110 = v108

		CharacterAdded:Connect(function()
			task.wait(1)
			u110()
		end)

		local function u111(p5)
			if u12 then
				local Yes = p5:FindFirstChild("Yes", true)

				if Yes then
					if firesignal then
						firesignal(Yes.Activated)

						return
					end

					local VirtualInputManager = game:GetService("VirtualInputManager")
					local v125 = Yes.AbsolutePosition + Yes.AbsoluteSize / 2

					VirtualInputManager:SendMouseButtonEvent(v125.X, v125.Y, 0, true, game, 1)
					VirtualInputManager:SendMouseButtonEvent(v125.X, v125.Y, 0, false, game, 1)
				end

				return
			end
		end

		local u112 = PlayerGui
		local spawn = task.spawn

		local function u114()
			if u12 then
				local TradeLiveTrade = u112:FindFirstChild("TradeLiveTrade")

				if TradeLiveTrade then
					local TradeLiveTrade2 = TradeLiveTrade:FindFirstChild("TradeLiveTrade", true)

					if TradeLiveTrade2 then
						local Other = TradeLiveTrade2:FindFirstChild("Other", true)

						if Other then
							local ReadyButton = Other:FindFirstChild("ReadyButton")

							if ReadyButton then
								firesignal(ReadyButton.Activated)
							end

							return
						end

						return
					end

					return
				end

				return
			end
		end

		spawn(function()
			while task.wait(0.5) do
				u114()

				if u15 then
					if not u12 then
						u15.Text = "● Paused"
						u15.TextColor3 = u24.Error
					else
						u15.Text = "● Active"
						u15.TextColor3 = u24.Success
					end
				end
			end
		end)

		if DuelsMachinePrompt2 then
			DuelsMachinePrompt2.ChildAdded:Connect(function(child)
				if child.Name == "Prompt" then
					local Label = child:FindFirstChild("Label", true)

					if Label and Label.Text == "Trade Request" then
						u111(child)
					end
				end
			end)
		end
	end)
	task.spawn(function()
		task.wait(0.5)

		local ContentFrame = u14:FindFirstChild("ContentFrame", true)

		if ContentFrame then
			local UIListLayout = ContentFrame:FindFirstChild("UIListLayout")

			if UIListLayout then
				u14.Size = UDim2.new(0, 230, 0, UIListLayout.AbsoluteContentSize.Y + 45)
			end
		end
	end)
	u13 = true
	print("[Chocola] Script inicializado correctamente")
end

v25()

local CharacterAdded = LocalPlayer.CharacterAdded
local u30 = CoreGui
local u31 = v25

CharacterAdded:Connect(function(_)
	print("[Chocola] Personaje añadido - reiniciando script...")
	task.wait(3)

	local ChocolaAutoAccept = u30.RobloxGui:FindFirstChild("ChocolaAutoAccept")

	if ChocolaAutoAccept then
		ChocolaAutoAccept:Destroy()
	end

	u12 = true
	u13 = false
	u14 = nil
	u15 = nil
	u16 = nil
	u31()
end)

local VirtualInputManager = Instance.new("VirtualInputManager")

task.spawn(function()
	print("[Chocola] 🛡\239\184\143 Anti-Reinicio activado (click cada 60s)")

	while task.wait(60) do
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
		task.wait(0.1)
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
	end
end)
