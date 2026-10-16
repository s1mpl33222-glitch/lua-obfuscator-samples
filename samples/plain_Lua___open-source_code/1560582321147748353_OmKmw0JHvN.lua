local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
getgenv().desync = false

local gui = Instance.new("ScreenGui")
gui.Name = "DESYNC"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 85)
frame.Position = UDim2.new(0.5, -100, 0.5, -42)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 25)
dragBar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
dragBar.BorderSizePixel = 0
dragBar.Text = "Drag"
dragBar.TextColor3 = Color3.new(1, 1, 1)
dragBar.Font = Enum.Font.GothamBold
dragBar.TextSize = 14
dragBar.Active = true
dragBar.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 35)
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.BorderSizePixel = 0
button.Text = "Desync: off"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.Gotham
button.TextSize = 14
button.Parent = frame

local function setButtonText(text)
	button.Text = text
end

local enabled = false

local function onToggle(state)
	getgenv().desync = state
    print(state)
end

button.MouseButton1Click:Connect(function()
	enabled = not enabled
	setButtonText("Desync: " .. (enabled and "on" or "off"))
	onToggle(enabled)
end)

-- Dragging
local dragging = false
local dragStart, startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

raknet.add_send_hook(function(packet)
    if (packet.PacketId == 0x1B or packet.PacketId == 161) and getgenv().desync then
        local buf = packet.AsBuffer
        buffer.writeu32(buf, 1, -1)
        print("hooked packet")
        packet:SetData(buf)
    end
end)
print("init")