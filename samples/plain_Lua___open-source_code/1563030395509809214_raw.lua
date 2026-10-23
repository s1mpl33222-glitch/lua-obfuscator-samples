local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local text = Instance.new("TextLabel")
text.Parent = gui
text.Size = UDim2.new(0, 200, 0, 50)
text.Position = UDim2.new(0.5, -100, 0.5, -25)
text.BackgroundColor3 = Color3.new(0, 0, 0)
text.TextColor3 = Color3.new(1, 1, 1)
text.Font = Enum.Font.Code
text.TextSize = 24
text.Text = "Hello World"