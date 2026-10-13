-- This file was generated at discord.gg/syncrypt

local CoreGui = game:GetService("CoreGui")

game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")
local color3 = Color3.fromRGB(24, 24, 24)
local color3_2 = Color3.fromRGB(32, 32, 32)
local color3_3 = Color3.fromRGB(165, 90, 255)
local color3_4 = Color3.fromRGB(240, 240, 245)
local color3_5 = Color3.fromRGB(140, 140, 150)
local color3_6 = Color3.fromRGB(50, 50, 50)
local color3_7 = Color3.fromRGB(62, 62, 62)
local t1 = {
	Background = color3,
	SectionBackground = color3_2,
	Accent = color3_3,
	Text = color3_4,
	SubText = color3_5,
	Stroke = color3_6,
	ButtonStroke = color3_7
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ReflexKeyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok, _ = pcall(function()
	if gethui then
		ScreenGui.Parent = gethui()

		return
	end

	local _syn = syn

	if _syn then
		_syn = syn.protect_gui
	end

	if _syn then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui

		return
	end

	ScreenGui.Parent = CoreGui
end)

if not ok then
	ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
local Frame = Instance.new("Frame")

Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 350, 0, 200)
Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
Frame.BackgroundColor3 = t1.Background
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 1
UIStroke.Color = t1.Stroke
UIStroke.Parent = Frame
local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 2)
Frame2.Position = UDim2.new(0, 0, 0, 0)
Frame2.BackgroundColor3 = t1.Accent
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame
local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -20, 0, 30)
TextLabel.Position = UDim2.new(0, 10, 0, 5)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "reflex.ss  |  Authentication"
TextLabel.TextColor3 = t1.Text
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 13
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame
local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, -20, 0, 1)
Frame3.Position = UDim2.new(0, 10, 0, 35)
Frame3.BackgroundColor3 = t1.Stroke
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame
local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(1, -40, 0, 35)
Frame4.Position = UDim2.new(0, 20, 0, 55)
Frame4.BackgroundColor3 = t1.SectionBackground
Frame4.BorderSizePixel = 0
Frame4.Parent = Frame
local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Thickness = 1
UIStroke2.Color = t1.Stroke
UIStroke2.Parent = Frame4
local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(1, -20, 1, 0)
TextBox.Position = UDim2.new(0, 10, 0, 0)
TextBox.BackgroundTransparency = 1
TextBox.Text = ""
TextBox.PlaceholderText = "Enter your key here..."
TextBox.TextColor3 = t1.Text
TextBox.PlaceholderColor3 = t1.SubText
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 12
TextBox.TextXAlignment = Enum.TextXAlignment.Center
TextBox.Parent = Frame4
local function v22(p1, p2, p3)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, -40, 0, 30)
	TextButton.Position = UDim2.new(0, 20, 0, p2)
	TextButton.BackgroundColor3 = t1.SectionBackground
	TextButton.BorderSizePixel = 0
	TextButton.Text = p1
	TextButton.TextColor3 = t1.Text
	TextButton.Font = Enum.Font.Gotham
	TextButton.TextSize = 12
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame

	local UIStroke3 = Instance.new("UIStroke")

	UIStroke3.Thickness = 1
	UIStroke3.Color = t1.ButtonStroke
	UIStroke3.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.2), {
			BackgroundColor3 = t1.SectionBackground
		}):Play()
	end)
	TextButton.MouseButton1Click:Connect(p3)

	return TextButton
end
v22("Get Key", 100, function()
	if setclipboard then
		setclipboard("https://discord.gg/qH8gGHCcdf")
		TextBox.Text = "Link copied to clipboard!"
		task.wait(1.5)

		if TextBox.Text == "Link copied to clipboard!" then
			TextBox.Text = ""
		end
	end
end)

local u23 = false
local v24 = v22("Check Key", 140, function()
	if TextBox.Text == "Saved key found!" then
		u23 = true
		TextBox.Text = ""
		TextBox.TextColor3 = t1.Text

		local v31 = type(delfile) == "function"

		if v31 then
			v31 = isfile("reflex/jnkie_key.txt")
		end

		if v31 then
			delfile("reflex/jnkie_key.txt")
		end

		return
	end

	local v32 = TextBox.Text:match("^%s*(.-)%s*$")

	if v32 == "" then
		TextBox.Text = "Please enter a key!"
		task.wait(1.5)
		TextBox.Text = ""

		return
	end

	TextBox.TextColor3 = Color3.fromRGB(255, 255, 100)
	TextBox.Text = "Checking key..."

	local ok2, result = pcall(function()
		local v48 = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

		v48.service = "Reflex Loader"
		v48.identifier = "1165195"
		v48.provider = "Linkvertise"

		return v48.check_key(v32)
	end)
	local v35 = false

	if ok2 and result and result.valid then
		v35 = true

		if getgenv then
			local v36 = if result.message ~= "KEYLESS" then v32 else "KEYLESS"

			getgenv().SCRIPT_KEY = v36
			getgenv().Key = v36
			getgenv().Junkie_Key = v36
			_G.Key = v36
		end
	end

	if v35 then
		pcall(function()
			local v49 = type(makefolder) == "function"

			if v49 then
				v49 = not isfolder("reflex")
			end

			if v49 then
				makefolder("reflex")
			end

			if type(writefile) == "function" then
				writefile("reflex/jnkie_key.txt", v32)
			end
		end)
		TextBox.TextColor3 = Color3.fromRGB(100, 255, 100)
		TextBox.Text = "Valid Key! Loading..."
		task.wait(0.8)
		ScreenGui:Destroy()

		local ok3, result2 = pcall(function()
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/c8cfcbe914439b0853072714ed4ca24c691f8903850db28e422bdb599d33eaa1/download"))()
		end)

		if not ok3 then
			warn("Reflex Main Script Load Error: " .. tostring(result2))

			return
		end
	else
		TextBox.TextColor3 = Color3.fromRGB(255, 100, 100)
		TextBox.Text = "Invalid Key!"
		task.wait(1.5)
		TextBox.TextColor3 = t1.Text

		if TextBox.Text == "Invalid Key!" then
			TextBox.Text = ""
		end
	end
end)

task.spawn(function()
	local v39 = type(readfile) == "function"

	if v39 then
		v39 = type(isfile) == "function"
	end

	if v39 and isfile("reflex/jnkie_key.txt") then
		local v40 = readfile("reflex/jnkie_key.txt")
		local v41 = v40

		if v41 then
			v41 = v40 ~= ""
		end

		if v41 then
			local ok4, result = pcall(function()
				local v50 = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

				v50.service = "Reflex Loader"
				v50.identifier = "1165195"
				v50.provider = "Linkvertise"

				return v50.check_key(v40)
			end)

			if ok4 then
				ok4 = result and result.valid
			end

			if ok4 then
				TextBox.TextColor3 = Color3.fromRGB(100, 255, 100)
				TextBox.Text = "Saved key found!"

				for i = 3, 1, -1 do
					if u23 then
						return
					end

					v24.Text = "Auto-loading in " .. i .. "... (Click to Cancel)"
					task.wait(1)
				end

				if u23 then
					return
				end

				if getgenv then
					local v45 = if result.message ~= "KEYLESS" then v40 else "KEYLESS"

					getgenv().SCRIPT_KEY = v45
					getgenv().Key = v45
					getgenv().Junkie_Key = v45
					_G.Key = v45
				end

				ScreenGui:Destroy()

				local _, _ = pcall(function()
					loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/c8cfcbe914439b0853072714ed4ca24c691f8903850db28e422bdb599d33eaa1/download"))()
				end)
			end
		end
	end
end)
