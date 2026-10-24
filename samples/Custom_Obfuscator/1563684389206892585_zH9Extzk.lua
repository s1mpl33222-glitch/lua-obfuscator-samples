local ScriptText = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/r3take/Forsakan/refs/heads/main/Viperware"))()'

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	LocalPlayer.PlayerGui:FindFirstChild("CopyScriptGUI"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CopyScriptGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 900, 0, 80)
Frame.Position = UDim2.new(0.5, -450, 0.1, 0)
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame)

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -120, 1, -10)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.Text = ScriptText
TextBox.ClearTextOnFocus = false
TextBox.TextEditable = false
TextBox.TextWrapped = false
TextBox.TextScaled = false
TextBox.TextSize = 16
TextBox.TextXAlignment = Enum.TextXAlignment.Left

TextBox.Focused:Connect(function()
	TextBox.SelectionStart = 1
	TextBox.CursorPosition = #ScriptText + 1
end)

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = Frame
CopyButton.Size = UDim2.new(0, 50, 0, 50)
CopyButton.Position = UDim2.new(1, -110, 0.5, -25)
CopyButton.Text = "📋"
CopyButton.TextSize = 28

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(1, -55, 0.5, -25)
CloseButton.Text = "X"
CloseButton.TextSize = 24

local function Notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 3
		})
	end)
end

CopyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(ScriptText)
		Notify("Copied!", "Script copied to clipboard.")
	else
		Notify("Clipboard Error", "setclipboard is unavailable.")
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)