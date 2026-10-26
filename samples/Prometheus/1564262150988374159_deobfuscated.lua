-- This file was generated at discord.gg/syncrypt

local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

pcall(function()
	ReplicatedFirst:RemoveDefaultLoadingScreen()
end)

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://9114223179"
Sound.Volume = 1.5
Sound.Parent = SoundService

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "Far3onLoadingScreen"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Name = "Background"
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")

UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 6, 10)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(10, 4, 8)), ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 3, 5)) })
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Name = "ParticlesFrame"
Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.BackgroundTransparency = 1
Frame2.ClipsDescendants = true
Frame2.Parent = Frame
task.spawn(function()
	while true do
		local Parent = Frame

		if Parent then
			Parent = Frame.Parent
		end

		if not Parent then
			return
		end

		local Frame3 = Instance.new("Frame")

		Frame3.BorderSizePixel = 0

		local v13 = math.random(1, 3)
		local v14 = v13 * 2

		Frame3.Size = UDim2.new(0, v14, 0, v14 * math.random(3, 6))
		Frame3.BackgroundTransparency = 0.2 * (4 - v13)

		if v13 == 3 then
			Frame3.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		else
			Frame3.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
		end

		local v15 = math.random(0, 100) / 100

		Frame3.Position = UDim2.new(v15, 0, -0.05, 0)

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame3
		Frame3.Parent = Frame2

		local v17 = math.random(12, 28) / 10 / (v13 * 0.4)
		local v18 = TweenService
		local tweenInfo = TweenInfo.new(v17, Enum.EasingStyle.Linear)
		local uDim2New = UDim2.new
		local v21 = math.random(-5, 5)
		local v22 = v18.Create(v18, Frame3, tweenInfo, {
			Position = uDim2New(v15 + v21 / 100, 0, 1.05, 0),
			BackgroundTransparency = 1
		})

		v22:Play()
		v22.Completed:Connect(function()
			Frame3:Destroy()
		end)
		task.wait(0.05)
	end
end)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Spinner"
ImageLabel.Size = UDim2.new(0, 64, 0, 64)
ImageLabel.Position = UDim2.new(0.5, -32, 0.28, 0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://6031225818"
ImageLabel.ImageColor3 = Color3.fromRGB(255, 45, 45)
ImageLabel.Parent = Frame
task.spawn(function()
	while true do
		local Parent = Frame

		if Parent then
			Parent = Frame.Parent
		end

		if not Parent then
			return
		end

		ImageLabel.Rotation = ImageLabel.Rotation + 3
		task.wait(0.016)
	end
end)

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "TitleLabel"
TextLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
TextLabel.Position = UDim2.new(0.05, 0, 0.38, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = ""
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.Parent = Frame

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(255, 30, 30)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = TextLabel
task.spawn(function()
	while true do
		local Parent = TextLabel

		if Parent then
			Parent = TextLabel.Parent
		end

		if not Parent then
			return
		end

		local tween = TweenService:Create(UIStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Thickness = 3.5,
			Transparency = 0
		})
		local tween2 = TweenService:Create(UIStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Thickness = 1.5,
			Transparency = 0.4
		})

		tween:Play()
		tween.Completed:Wait()
		tween2:Play()
		tween2.Completed:Wait()
	end
end)

local Frame3 = Instance.new("Frame")

Frame3.Name = "BarBackground"
Frame3.Size = UDim2.new(0.45, 0, 0.028, 0)
Frame3.Position = UDim2.new(0.275, 0, 0.52, 0)
Frame3.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = Color3.fromRGB(255, 40, 40)
UIStroke2.Thickness = 1.5
UIStroke2.Transparency = 0.4
UIStroke2.Parent = Frame3

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame3

local Frame4 = Instance.new("Frame")

Frame4.Name = "RedBar"
Frame4.Size = UDim2.new(0, 0, 1, 0)
Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame4.BorderSizePixel = 0
Frame4.Parent = Frame3

local UIGradient2 = Instance.new("UIGradient")

UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)), ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 120)) })
UIGradient2.Parent = Frame4

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = Frame4

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "PercentLabel"
TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "0%"
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextSize = 13
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.ZIndex = 3
TextLabel2.Parent = Frame3

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Name = "StatusLabel"
TextLabel3.Size = UDim2.new(0.6, 0, 0.035, 0)
TextLabel3.Position = UDim2.new(0.2, 0, 0.57, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "INITIALIZING..."
TextLabel3.TextColor3 = Color3.fromRGB(180, 180, 195)
TextLabel3.TextScaled = true
TextLabel3.Font = Enum.Font.GothamMedium
TextLabel3.Parent = Frame

local t1 = {
	"Connecting to Far3on Chat core...",
	"جاري التحميل  ...",
	"Loading UI components & assets...",
	"تم تحميل Far3on Chat V0.4..."
}

local function v39(p1, p2)
	local v40 = TweenService
	local v41 = Frame4
	local tweenInfoNew = TweenInfo.new
	local EasingStyle = Enum.EasingStyle

	v40.Create(v40, v41, tweenInfoNew(p2, EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(p1, 0, 1, 0)
	}):Play()

	local match = string.match
	local Text = TextLabel2.Text
	local v46 = tonumber(match(Text, "%d+")) or 0
	local v47 = p1 * 100
	local v48 = math.floor(v47)

	task.spawn(function()
		for i = v46, v48 do
			TextLabel2.Text = i .. "%"

			local wait = task.wait
			local v51 = p2
			local v52 = v48 - v46

			wait(v51 / math.max(v52, 1))
		end
	end)
end

(function()
	task.spawn(function()
		task.spawn(function()
			local n1 = 1

			while true do
				local Parent = Frame

				if Parent then
					Parent = Frame.Parent
				end

				if not Parent then
					return
				end

				TextLabel3.Text = string.upper(t1[n1])
				n1 = n1 % #t1 + 1
				task.wait(1.1)
			end
		end)

		for i = 1, 16 do
			TextLabel.Text = string.sub("FAR3ON CHAT V0.4", 1, i) .. "  █"
			v39(i / 16 * 0.45, 0.04)
			task.wait(0.04)
		end

		task.wait(0.3)

		for i = 16, 0, -1 do
			TextLabel.Text = string.sub("FAR3ON CHAT V0.4", 1, i) .. "  █"
			task.wait(0.02)
		end

		task.wait(0.1)

		local t2 = {}

		for match in string.gmatch("شات فرعون  تحديث 0.4", "[%z\1-\127\194-\244][\128-\191]*") do
			table.insert(t2, match)
		end

		local text = ""

		for i, v in ipairs(t2) do
			text = text .. v
			TextLabel.Text = text .. "  █"
			v39(0.45 + i / #t2 * 0.55, 0.05)
			task.wait(0.05)
		end

		TextLabel.Text = text
		TextLabel2.Text = "100% - SUCCESS"
		TextLabel3.Text = "تم التحميل LOADED SUCCESSFULLY!"
		TextLabel3.TextColor3 = Color3.fromRGB(80, 255, 120)
		task.wait(0.6)

		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local v63 = Frame

		for _, descendant in ipairs(v63.GetDescendants(v63)) do
			if descendant:IsA("Frame") then
				TweenService:Create(descendant, tweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("TextLabel") then
				local v66 = TweenService

				v66.Create(v66, descendant, tweenInfo, {
					TextTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				local v67 = TweenService

				v67.Create(v67, descendant, tweenInfo, {
					Transparency = 1
				}):Play()
			elseif descendant:IsA("ImageLabel") then
				local v68 = TweenService

				v68.Create(v68, descendant, tweenInfo, {
					ImageTransparency = 1
				}):Play()
			end
		end

		TweenService:Create(Frame, tweenInfo, {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.8)
		ScreenGui:Destroy()
		Sound:Play()
		task.wait(0.2)

		local ok, result = pcall(function()
			loadstring(game:HttpGet("https://pastebin.com/raw/hVSU0UpC"))()
		end)

		if ok then
			print("Script Executed Successfully!")
		else
			warn("Execution Error: " .. tostring(result))
		end
	end)
end)()
