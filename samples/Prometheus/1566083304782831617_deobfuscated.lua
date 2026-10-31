-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack

if not LPH_OBFUSCATED then
	t1.value1 = getgenv()

	function t1.value2(p1)
		return p1
	end

	t1.value1.LPH_NO_VIRTUALIZE = t1.value2
	t1.value1 = getgenv()

	function t1.value2(p2)
		return p2
	end

	t1.value1.LPH_JIT = t1.value2
	t1.value1 = getgenv()

	function t1.value2(p3)
		return p3
	end

	t1.value1.LPH_ENCSTR = t1.value2
	t1.value1 = getgenv()

	function t1.value2(p4)
		return p4
	end

	t1.value1.LPH_ENCNUM = t1.value2
	t1.value1 = getgenv()

	function t1.value2()
		while true do

		end
	end

	t1.value1.LPH_CRASH = t1.value2
	t1.value1 = getgenv()
	t1.value1.LPH_OBFUSCATED = false
end

t1.value1 = game:GetService("HttpService")

local t2 = {
	value1 = t1.value1
}

t1.value2 = game:GetService("TweenService")
t2.value2 = t1.value2
t2.value3 = game:GetService("UserInputService")
t2.value4 = game:GetService("CoreGui")
t2.value5 = game:GetService("Lighting")
t2.value6 = false

local PlaceId = game.PlaceId

t2.value7 = tostring(PlaceId)
t2.value8 = nil

local lua = LPH_ENCSTR("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")

t2.value9 = nil
t2.value9 = lua

local ok, value4 = pcall(function()
	return loadstring(game:HttpGet(t2.value9))()
end)

t1.value3 = ok
t1.value4 = value4
t2.value10 = t1.value3
t2.value11 = t1.value4
t2.value12 = "rbxassetid://103660255446080"

local value10 = t2.value10
local value13 = "rbxassetid://10747384394"

if value10 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value10 = t2.value11.x
	else
		value10 = false
	end
end

if value10 then
	value13 = t2.value11.x
end

t2.value13 = value13

local value102 = t2.value10
local value14 = "rbxassetid://10734896206"

if value102 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value102 = t2.value11.minus
	else
		value102 = false
	end
end

if value102 then
	value14 = t2.value11.minus
end

t2.value14 = value14

local value103 = t2.value10
local value15 = "rbxassetid://10723415903"

if value103 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value103 = t2.value11.key
	else
		value103 = false
	end
end

if value103 then
	value15 = t2.value11.key
end

t2.value15 = value15

local value104 = t2.value10
local value16 = "rbxassetid://10723343301"

if value104 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value104 = t2.value11.info
	else
		value104 = false
	end
end

if value104 then
	value16 = t2.value11.info
end

t2.value16 = value16

local value105 = t2.value10
local value17 = "rbxassetid://10709790644"

if value105 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value105 = t2.value11.check
	else
		value105 = false
	end
end

if value105 then
	value17 = t2.value11.check
end

t2.value17 = value17

local value106 = t2.value10
local value18 = "rbxassetid://10723345518"

if value106 then
	local value11 = t2.value11

	if type(value11) == "table" then
		value106 = t2.value11.link
	else
		value106 = false
	end
end

if value106 then
	value18 = t2.value11.link
end

t2.value18 = value18

local lua2 = LPH_ENCSTR("https://weretool.xyz/wgrthojtykopuyojekfsngkjowaeruiftgwejfgbsadjxdcvbjre/gkjerpohjoperjghoijeroigjiodfhviujwegj.lua")

t2.value19 = loadstring(unpack_({ game:HttpGet(lua2) }))()

function t2.value20(p5, p6)
	local v27 = LPH_ENCSTR("https://weretool.xyz/api/v1/get-all-modules?token=") .. p5 .. "&place_id=" .. tostring(p6)
	local ok2, result = pcall(function()
		return game:HttpGet(v27)
	end)

	if not (ok2 and result) then
		return {}
	end

	local ok3, result2 = pcall(function()
		return t2.value1:JSONDecode(result)
	end)

	if not (ok3 and (result2 and (result2.success and result2.modules))) then
		return {}
	end

	local t3 = {}

	for k, module in pairs(result2.modules) do
		local ok4, result3 = pcall(function()
			return loadstring(module)()
		end)

		if ok4 then
			t3[k] = result3
		end
	end

	return t3
end
function t2.value21(p7)
	if t2.value6 then
		return
	end

	local value8 = t2.value8
	local t4 = {
		Title = "Loader",
		Content = "Injecting Payload...",
		Duration = 3,
		Icon = t2.value12
	}

	value8.Notify(value8, t4)

	local v39 = LPH_ENCSTR("https://weretool.xyz/api/v1/get-payload?token=") .. p7 .. "&place_id=" .. t2.value7
	local v40 = t2.value20(p7, t2.value7)

	_G.WereToolsModules = v40
	_G.WereToolsSessionToken = p7
	_G.auth = t2.value19

	if getgenv then
		getgenv().WereToolsModules = v40
		getgenv().auth = t2.value19
	end

	local ok2, result = pcall(game.HttpGet, game, v39)

	if not (ok2 and result) then
		t2.value8:Notify({
			Title = "Error",
			Content = "Failed to download payload.",
			Duration = 5
		})

		return
	end

	if result:sub(1, 1) == "{" then
		local ok3, result2 = pcall(function()
			return t2.value1:JSONDecode(result)
		end)

		if ok3 then
			if result2 then
				ok3 = result2.success == false
			else
				ok3 = result2
			end
		end

		if ok3 then
			local value82 = t2.value8
			local t5 = {
				Title = "Error",
				Content = result2.message or "Session Invalid",
				Duration = 5
			}

			value82.Notify(value82, t5)
			t2.value19._io_d()

			return
		end
	end

	local ok3, result2 = pcall(function()
		loadstring(result)()
	end)

	if not ok3 then
		local value82 = t2.value8

		value82.Notify(value82, {
			Title = "Error",
			Content = "Payload Crashed: " .. tostring(result2),
			Duration = 8
		})
	end
end

t2.value22 = {}
t2.value22.__index = t2.value22

local function v50(p8, p9, p10, p11, p12, p13)
	local tweenInfo = TweenInfo.new(p10 or 0.3, p11 or Enum.EasingStyle.Quint, Enum.EasingDirection.Out, p12 or 0, p13 or false)
	local tween = t2.value2:Create(p8, tweenInfo, p9)

	tween:Play()

	return tween
end

function t2.value22.new(p14)
	local value22 = t2.value22
	local obj = setmetatable({}, value22)

	obj.Config = p14
	obj.IsMinimized = false
	obj.ActiveTweens = {}

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "WereToolsUI"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		ScreenGui.Parent = gethui()
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = t2.value4
	end

	obj.Gui = ScreenGui

	local BlurEffect = Instance.new("BlurEffect")

	BlurEffect.Name = "WereToolsBlur"
	BlurEffect.Size = 0
	pcall(function()
		BlurEffect.Parent = t2.value5
	end)
	obj.BlurEffect = BlurEffect

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 1
	obj.Background = Frame

	local Frame2 = Instance.new("Frame", ScreenGui)

	Frame2.Name = "NotifyContainer"
	Frame2.Size = UDim2.new(0, 320, 1, -20)
	Frame2.Position = UDim2.new(1, -340, 0, 20)
	Frame2.BackgroundTransparency = 1
	obj.NotifyContainer = Frame2

	local UIListLayout = Instance.new("UIListLayout", Frame2)

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout.Padding = UDim.new(0, 10)

	local Frame3 = Instance.new("Frame", Frame)

	Frame3.Size = UDim2.new(0, 420, 0, 230)
	Frame3.Position = UDim2.new(0.5, -210, 0.5, -95)
	Frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	Frame3.BackgroundTransparency = 1
	Frame3.ClipsDescendants = true
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 12)
	obj.MainFrame = Frame3
	obj.UIStroke = Instance.new("UIStroke", Frame3)
	obj.UIStroke.Color = Color3.fromRGB(255, 255, 255)
	obj.UIStroke.Transparency = 1
	obj.UIStroke.Thickness = 1.2

	local UIGradient = Instance.new("UIGradient", obj.UIStroke)

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45)) })

	local v62 = v50(UIGradient, {
		Rotation = 360
	}, 5, Enum.EasingStyle.Linear, -1, false)
	local v63 = v50(obj.UIStroke, {
		Transparency = 0.5
	}, 3, Enum.EasingStyle.Sine, -1, true)
	local ActiveTweens = obj.ActiveTweens

	table.insert(ActiveTweens, v62)

	local ActiveTweens2 = obj.ActiveTweens

	table.insert(ActiveTweens2, v63)

	local Frame4 = Instance.new("Frame", Frame3)

	Frame4.Size = UDim2.new(1, 0, 0, 40)
	Frame4.BackgroundTransparency = 1
	obj:MakeDraggable(Frame4, Frame3)

	local ImageLabel = Instance.new("ImageLabel", Frame4)

	ImageLabel.Size = UDim2.new(0, 30, 0, 30)
	ImageLabel.Position = UDim2.new(0, 12, 0.5, -15)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = t2.value12
	ImageLabel.ImageTransparency = 1
	obj.Logo = ImageLabel

	local TextLabel = Instance.new("TextLabel", Frame4)

	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 45, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p14.Title
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextTransparency = 1
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	obj.Title = TextLabel

	local ImageButton = Instance.new("ImageButton", Frame4)

	ImageButton.Size = UDim2.new(0, 24, 0, 24)
	ImageButton.Position = UDim2.new(1, -60, 0.5, -12)
	ImageButton.BackgroundTransparency = 1
	ImageButton.Image = t2.value14
	ImageButton.ImageColor3 = Color3.fromRGB(180, 180, 180)
	ImageButton.ImageTransparency = 1
	obj.MinBtn = ImageButton

	local ImageButton2 = Instance.new("ImageButton", Frame4)

	ImageButton2.Size = UDim2.new(0, 24, 0, 24)
	ImageButton2.Position = UDim2.new(1, -30, 0.5, -12)
	ImageButton2.BackgroundTransparency = 1
	ImageButton2.Image = t2.value13
	ImageButton2.ImageColor3 = Color3.fromRGB(180, 180, 180)
	ImageButton2.ImageTransparency = 1
	obj.CloseBtn = ImageButton2

	local Frame5 = Instance.new("Frame", Frame3)

	Frame5.Size = UDim2.new(1, 0, 1, -40)
	Frame5.Position = UDim2.new(0, 0, 0, 40)
	Frame5.BackgroundTransparency = 1
	obj.Content = Frame5

	local TextLabel2 = Instance.new("TextLabel", Frame5)

	TextLabel2.Size = UDim2.new(1, 0, 0, 20)
	TextLabel2.Position = UDim2.new(0, 0, 0.5, -10)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p14.Note
	TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 190)
	TextLabel2.TextTransparency = 1
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 13
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	obj.Note = TextLabel2

	local Frame6 = Instance.new("Frame", Frame5)

	Frame6.Size = UDim2.new(1, -30, 0, 40)
	Frame6.Position = UDim2.new(0, 15, 0, 45)
	Frame6.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	Frame6.BackgroundTransparency = 1
	Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 8)
	obj.InputStroke = Instance.new("UIStroke", Frame6)
	obj.InputStroke.Color = Color3.fromRGB(80, 80, 90)
	obj.InputStroke.Transparency = 1
	obj.InputFrame = Frame6

	local ImageLabel2 = Instance.new("ImageLabel", Frame6)

	ImageLabel2.Size = UDim2.new(0, 18, 0, 18)
	ImageLabel2.Position = UDim2.new(0, 12, 0.5, -9)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = t2.value15
	ImageLabel2.ImageColor3 = Color3.fromRGB(160, 160, 170)
	ImageLabel2.ImageTransparency = 1
	obj.InputIcon = ImageLabel2

	local TextBox = Instance.new("TextBox", Frame6)

	TextBox.Size = UDim2.new(1, -45, 1, 0)
	TextBox.Position = UDim2.new(0, 40, 0, 0)
	TextBox.BackgroundTransparency = 1
	TextBox.Text = ""
	TextBox.PlaceholderText = "Enter your key here..."
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextTransparency = 1
	TextBox.Font = Enum.Font.Gotham
	TextBox.TextSize = 14
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	obj.TextBox = TextBox

	local uDim2 = UDim2.new(0.5, 5, 0, 105)
	local color3 = Color3.fromRGB(255, 255, 255)
	local Color3_ = Color3

	obj.SubmitBtn = obj.CreateButton(obj, "Verify Key", uDim2, color3, Color3_.fromRGB(0, 0, 0), true, t2.value17)
	obj.GetKeyBtn = obj:CreateButton("Get Key", UDim2.new(0, 15, 0, 105), Color3.fromRGB(45, 45, 50), Color3.fromRGB(255, 255, 255), false, t2.value18)
	obj:SetupHover(ImageButton2, Color3.fromRGB(255, 80, 80), Color3.fromRGB(180, 180, 180))
	obj:SetupHover(ImageButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180))
	ImageButton2.MouseButton1Click:Connect(function()
		obj:Close(true)
	end)
	ImageButton.MouseButton1Click:Connect(function()
		obj:ToggleMinimize()
	end)
	obj.GetKeyBtn.MouseButton1Click:Connect(function()
		setclipboard(obj.Config.Link)
		obj:Notify({
			Title = "Success",
			Content = "Key link copied to clipboard!",
			Duration = 3,
			Icon = t2.value16
		})
	end)
	obj.SubmitBtn.MouseButton1Click:Connect(function()
		obj.SubmitBtn.TextLabel.Text = "Checking..."

		local v79, v80 = obj.Config.Callback(obj.TextBox.Text)

		if v79 then
			obj.SubmitBtn.TextLabel.Text = "Success!"
			obj.SubmitBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
			obj:Close(false)
		else
			obj.SubmitBtn.TextLabel.Text = "Verify Key"

			local v81 = obj

			v81.Shake(v81)
			obj:Notify({
				Title = "Authentication Error",
				Content = v80 or "Invalid key!",
				Duration = 3
			})
		end
	end)

	return obj
end
function t2.value22.Notify(p15, p16)
	local Title = p16.Title or "Notification"
	local Content = p16.Content or "..."
	local Duration = p16.Duration or 3
	local Icon = p16.Icon or t2.value16
	local Frame = Instance.new("Frame", p15.NotifyContainer)

	Frame.Size = UDim2.new(1, 0, 0, 65)
	Frame.BackgroundTransparency = 1

	local Frame2 = Instance.new("Frame", Frame)

	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.Position = UDim2.new(1, 50, 0, 0)
	Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	Frame2.BackgroundTransparency = 1
	Frame2.ClipsDescendants = true
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 8)

	local UIStroke = Instance.new("UIStroke", Frame2)

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.2
	UIStroke.Transparency = 1

	local UIGradient = Instance.new("UIGradient", UIStroke)

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45)) })

	local v90 = v50(UIGradient, {
		Rotation = 360
	}, 5, Enum.EasingStyle.Linear, -1, false)
	local ActiveTweens = p15.ActiveTweens

	table.insert(ActiveTweens, v90)

	local ImageLabel = Instance.new("ImageLabel", Frame2)

	ImageLabel.Size = UDim2.new(0, 34, 0, 34)
	ImageLabel.Position = UDim2.new(0, 8, 0, 12)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = Icon
	ImageLabel.ImageTransparency = 1

	local TextLabel = Instance.new("TextLabel", Frame2)

	TextLabel.Size = UDim2.new(1, -55, 0, 20)
	TextLabel.Position = UDim2.new(0, 45, 0, 12)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Title
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextTransparency = 1
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local TextLabel2 = Instance.new("TextLabel", Frame2)

	TextLabel2.Size = UDim2.new(1, -55, 0, 15)
	TextLabel2.Position = UDim2.new(0, 45, 0, 32)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = Content
	TextLabel2.TextColor3 = Color3.fromRGB(160, 160, 160)
	TextLabel2.TextTransparency = 1
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 12
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

	local Frame3 = Instance.new("Frame", Frame2)

	Frame3.Size = UDim2.new(1, 0, 0, 2)
	Frame3.Position = UDim2.new(0, 0, 1, -2)
	Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	Frame3.BorderSizePixel = 0
	Frame3.BackgroundTransparency = 1

	local Frame4 = Instance.new("Frame", Frame3)

	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
	Frame4.BorderSizePixel = 0
	Frame4.BackgroundTransparency = 1
	v50(Frame2, {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.25
	}, 0.5)
	v50(UIStroke, {
		Transparency = 0.5
	}, 0.5)
	v50(ImageLabel, {
		ImageTransparency = 0
	}, 0.5)
	v50(TextLabel, {
		TextTransparency = 0
	}, 0.5)
	v50(TextLabel2, {
		TextTransparency = 0
	}, 0.5)
	v50(Frame3, {
		BackgroundTransparency = 0
	}, 0.5)
	v50(Frame4, {
		BackgroundTransparency = 0.2
	}, 0.5)
	t2.value2:Create(Frame4, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()
	task.spawn(function()
		task.wait(Duration)

		local v97 = v50(Frame2, {
			Position = UDim2.new(1, 50, 0, 0),
			BackgroundTransparency = 1
		}, 0.4)

		v50(UIStroke, {
			Transparency = 1
		}, 0.4)
		v50(ImageLabel, {
			ImageTransparency = 1
		}, 0.4)
		v50(TextLabel, {
			TextTransparency = 1
		}, 0.4)
		v50(TextLabel2, {
			TextTransparency = 1
		}, 0.4)
		v50(Frame3, {
			BackgroundTransparency = 1
		}, 0.4)
		v50(Frame4, {
			BackgroundTransparency = 1
		}, 0.4)
		v97.Completed:Connect(function()
			if not v90 then
				Frame:Destroy()

				return
			end

			v90:Cancel()
			Frame:Destroy()
		end)
	end)
end
function t2.value22.SetupHover(_, p17, p18, p19)
	p17.MouseEnter:Connect(function()
		v50(p17, {
			ImageColor3 = p18
		}, 0.2)
	end)
	p17.MouseLeave:Connect(function()
		v50(p17, {
			ImageColor3 = p19
		}, 0.2)
	end)
end
function t2.value22.CreateButton(p20, p21, p22, p23, p24, p25, p26)
	local TextButton = Instance.new("TextButton", p20.Content)

	TextButton.Size = UDim2.new(0.5, -25, 0, 40)
	TextButton.Position = p22
	TextButton.BackgroundColor3 = p23
	TextButton.BackgroundTransparency = 1
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

	if p26 then
		local ImageLabel = Instance.new("ImageLabel", TextButton)

		ImageLabel.Name = "BtnIcon"
		ImageLabel.Size = UDim2.new(0, 16, 0, 16)
		ImageLabel.Position = UDim2.new(0, 14, 0.5, -8)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = p26
		ImageLabel.ImageColor3 = p24
		ImageLabel.ImageTransparency = 1
	end

	local TextLabel = Instance.new("TextLabel", TextButton)

	if p26 then
		TextLabel.Size = UDim2.new(1, -38, 1, 0)
		TextLabel.Position = UDim2.new(0, 38, 0, 0)
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	else
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	end

	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p21
	TextLabel.TextColor3 = p24
	TextLabel.TextTransparency = 1
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextSize = 13

	local v101 = p25 and 0 or 0.3
	local v102 = p25 and 0.2 or 0.5

	TextButton:SetAttribute("TargetTransparency", v101)
	TextButton.MouseEnter:Connect(function()
		v50(TextButton, {
			BackgroundTransparency = v102
		}, 0.2)
	end)
	TextButton.MouseLeave:Connect(function()
		v50(TextButton, {
			BackgroundTransparency = v101
		}, 0.2)
	end)

	return TextButton
end
function t2.value22.MakeDraggable(_, p27, p28)
	local u103 = nil
	local u104 = nil
	local Position = nil
	local Position2 = nil

	local function v107(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u103 = true
		Position = input.Position
		Position2 = p28.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u103 = false
		end)
	end

	p27.InputBegan:Connect(v107)
	p27.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u104 = input
	end)
	t2.value3.InputChanged:Connect(function(input)
		local v108

		if input == u104 then
			v108 = u103
		else
			v108 = false
		end

		if not v108 then
			return
		end

		local v109 = input.Position - Position

		v50(p28, {
			Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v109.X, Position2.Y.Scale, Position2.Y.Offset + v109.Y)
		}, 0.1)
	end)
end
function t2.value22.ToggleMinimize(p29)
	p29.IsMinimized = not p29.IsMinimized

	if p29.IsMinimized then
		v50(p29.MainFrame, {
			Size = UDim2.new(0, 420, 0, 40)
		}, 0.4)

		local pairs_ = pairs
		local Content = p29.Content

		for _, descendant in pairs_(Content.GetDescendants(Content)) do
			if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
				v50(descendant, {
					TextTransparency = 1
				}, 0.2)
			elseif descendant:IsA("ImageLabel") then
				v50(descendant, {
					ImageTransparency = 1
				}, 0.2)
			elseif descendant:IsA("Frame") or descendant:IsA("TextButton") then
				v50(descendant, {
					BackgroundTransparency = 1
				}, 0.2)
			elseif descendant:IsA("UIStroke") then
				v50(descendant, {
					Transparency = 1
				}, 0.2)
			end
		end
	else
		v50(p29.MainFrame, {
			Size = UDim2.new(0, 420, 0, 230)
		}, 0.4)

		local pairs_ = pairs
		local Content = p29.Content

		for _, child in pairs_(Content.GetChildren(Content)) do
			if child:IsA("TextLabel") then
				v50(child, {
					TextTransparency = 0
				}, 0.3)
			elseif child:IsA("Frame") or child:IsA("TextButton") then
				v50(child, {
					BackgroundTransparency = child:GetAttribute("TargetTransparency") or (child == p29.InputFrame and 0.4 or 0)
				}, 0.3)

				if child:FindFirstChild("TextLabel") then
					v50(child.TextLabel, {
						TextTransparency = 0
					}, 0.3)
				end

				if child:FindFirstChild("BtnIcon") then
					v50(child.BtnIcon, {
						ImageTransparency = 0
					}, 0.3)
				end
			end
		end

		v50(p29.TextBox, {
			TextTransparency = 0
		}, 0.3)
		v50(p29.InputIcon, {
			ImageTransparency = 0
		}, 0.3)
		v50(p29.InputStroke, {
			Transparency = 0.5
		}, 0.3)
	end
end

local function v118()
	local t6 = {}
	local HttpGet = game.HttpGet
	local v121 = type(HttpGet) ~= "function"

	if not v121 then
		v121 = islclosure

		if v121 then
			v121 = islclosure(game.HttpGet)
		end
	end

	local insert

	if v121 then
		insert = table.insert
		insert(t6, "ERR_NET_HOOK: HTTP functions have been tampered.")
	else
		insert = t6
	end

	local getrawmetatable_ = getrawmetatable

	if getrawmetatable_ then
		getrawmetatable_ = getrawmetatable(game)
	end

	local __namecall

	if getrawmetatable_ then
		__namecall = getrawmetatable_.__namecall

		if __namecall then
			__namecall = islclosure

			if __namecall then
				__namecall = islclosure(getrawmetatable_.__namecall)
			end
		end
	else
		__namecall = getrawmetatable_
	end

	if __namecall then
		table.insert(t6, "ERR_MEM_HOOK: Game metatable is hooked.")
	end

	if not getgenv then
		return #t6 == 0, t6
	end

	local genv = getgenv()

	if not (genv.http_spy or (genv.HttpSpy or genv.Spy)) then
		return #t6 == 0, t6
	end

	table.insert(t6, "ERR_SPY_DETECTED: Network monitor active.")

	return #t6 == 0, t6
end

function t2.value22.Init(p30)
	if p30.BlurEffect then
		v50(p30.BlurEffect, {
			Size = 20
		}, 0.5)
	end

	v50(p30.Background, {
		BackgroundTransparency = 0.5
	}, 0.5)
	p30.MainFrame.Size = UDim2.new(0, 420, 0, 110)
	v50(p30.MainFrame, {
		BackgroundTransparency = 0.35,
		Position = UDim2.new(0.5, -210, 0.5, -55)
	}, 0.6)

	local t7 = {
		p30.Title,
		p30.Logo,
		p30.MinBtn,
		p30.CloseBtn
	}
	local v127, v128, v129 = pairs(t7)

	while true do
		local v130

		v129, v130 = v127(v128, v129)

		if not v129 then
			break
		end

		if v130:IsA("TextLabel") then
			v50(v130, {
				TextTransparency = 0
			}, 0.6)
		elseif v130:IsA("ImageLabel") or v130:IsA("ImageButton") then
			v50(v130, {
				ImageTransparency = 0
			}, 0.6)
		end
	end

	p30.InputStroke.Transparency = 1
	p30.InputFrame.BackgroundTransparency = 1
	p30.TextBox.TextTransparency = 1
	p30.InputIcon.ImageTransparency = 1
	p30.SubmitBtn.BackgroundTransparency = 1
	p30.GetKeyBtn.BackgroundTransparency = 1
	p30.SubmitBtn:FindFirstChild("TextLabel").TextTransparency = 1
	p30.GetKeyBtn:FindFirstChild("TextLabel").TextTransparency = 1

	if p30.SubmitBtn:FindFirstChild("BtnIcon") then
		p30.SubmitBtn.BtnIcon.ImageTransparency = 1
	end

	if p30.GetKeyBtn:FindFirstChild("BtnIcon") then
		p30.GetKeyBtn.BtnIcon.ImageTransparency = 1
	end

	p30.TextBox.Interactable = false
	p30.SubmitBtn.Interactable = false
	p30.GetKeyBtn.Interactable = false
	v50(p30.Note, {
		TextTransparency = 0
	}, 0.6)
	p30.Note.TextColor3 = Color3.fromRGB(120, 180, 255)

	local v131 = v50(p30.Note, {
		TextTransparency = 0.5
	}, 0.8, Enum.EasingStyle.Sine, -1, true)
	local thread = task.spawn(function()
		local n1 = 0

		while true do
			n1 = (n1 + 1) % 4
			p30.Note.Text = "Checking Environment" .. string.rep(".", n1)
			task.wait(0.3)
		end
	end)

	task.spawn(function()
		task.wait(1.5)

		local v134, v135 = v118()

		task.cancel(thread)

		if v131 then
			v131:Cancel()
		end

		if not v134 then
			p30:Shake()
			p30.Note.Text = "SECURITY THREAT DETECTED"
			v50(p30.Note, {
				TextColor3 = Color3.fromRGB(255, 80, 80)
			}, 0.3)
			v50(p30.UIStroke, {
				Color = Color3.fromRGB(255, 50, 50),
				Transparency = 0
			}, 0.3)

			for _, v in ipairs(v135) do
				warn("[WereTools Security]: " .. v)
			end

			local v138 = p30

			v138.Notify(v138, {
				Title = "Anti-Tamper",
				Content = v135[1],
				Duration = 6,
				Icon = t2.value13
			})
			task.wait(3)
			p30:Close(true)

			if not LPH_CRASH then
				return
			end

			LPH_CRASH()

			return
		end

		v50(p30.Note, {
			TextTransparency = 1
		}, 0.3)
		task.wait(0.3)
		p30.Note.Text = "Environment Secured."
		p30.Note.TextColor3 = Color3.fromRGB(46, 204, 113)
		v50(p30.Note, {
			TextTransparency = 0
		}, 0.3)
		task.wait(0.8)
		v50(p30.Note, {
			TextTransparency = 1
		}, 0.3)
		task.wait(0.3)
		p30.Note.Text = p30.Config.Note
		p30.Note.TextColor3 = Color3.fromRGB(180, 180, 190)
		v50(p30.MainFrame, {
			Size = UDim2.new(0, 420, 0, 230),
			Position = UDim2.new(0.5, -210, 0.5, -115)
		}, 0.6, Enum.EasingStyle.Quint)
		v50(p30.Note, {
			Position = UDim2.new(0, 0, 0, 10),
			TextTransparency = 0
		}, 0.6, Enum.EasingStyle.Quint)
		task.wait(0.3)
		v50(p30.InputFrame, {
			BackgroundTransparency = 0.4
		}, 0.5)
		v50(p30.InputStroke, {
			Transparency = 0.5
		}, 0.5)
		v50(p30.InputIcon, {
			ImageTransparency = 0
		}, 0.5)
		v50(p30.TextBox, {
			TextTransparency = 0
		}, 0.5)
		task.wait(0.15)

		local t8 = {
			BackgroundTransparency = p30.SubmitBtn:GetAttribute("TargetTransparency") or 0
		}

		v50(p30.SubmitBtn, t8, 0.5)
		v50(p30.SubmitBtn:FindFirstChild("TextLabel"), {
			TextTransparency = 0
		}, 0.5)

		if p30.SubmitBtn:FindFirstChild("BtnIcon") then
			v50(p30.SubmitBtn.BtnIcon, {
				ImageTransparency = 0
			}, 0.5)
		end

		task.wait(0.1)

		local t9 = {
			BackgroundTransparency = p30.GetKeyBtn:GetAttribute("TargetTransparency") or 0
		}

		v50(p30.GetKeyBtn, t9, 0.5)
		v50(p30.GetKeyBtn:FindFirstChild("TextLabel"), {
			TextTransparency = 0
		}, 0.5)

		if not p30.GetKeyBtn:FindFirstChild("BtnIcon") then
			p30.TextBox.Interactable = true
			p30.SubmitBtn.Interactable = true
			p30.GetKeyBtn.Interactable = true

			return
		end

		v50(p30.GetKeyBtn.BtnIcon, {
			ImageTransparency = 0
		}, 0.5)
		p30.TextBox.Interactable = true
		p30.SubmitBtn.Interactable = true
		p30.GetKeyBtn.Interactable = true
	end)
end
function t2.value22.Shake(p31)
	local Position = p31.MainFrame.Position
	local n2 = 10

	for _ = 1, 4 do
		v50(p31.MainFrame, {
			Position = Position + UDim2.new(0, n2, 0, 0)
		}, 0.04)
		task.wait(0.04)
		n2 = -n2
	end

	v50(p31.MainFrame, {
		Position = Position
	}, 0.04)
end
function t2.value22.Close(p32, p33)
	if p32.BlurEffect then
		v50(p32.BlurEffect, {
			Size = 0
		}, 0.3)
	end

	v50(p32.Background, {
		BackgroundTransparency = 1
	}, 0.3)

	local v144 = v50(p32.MainFrame, {
		Position = p32.MainFrame.Position + UDim2.new(0, 0, 0, 30),
		BackgroundTransparency = 1
	}, 0.3)
	local pairs_ = pairs
	local MainFrame = p32.MainFrame

	for _, descendant in pairs_(MainFrame.GetDescendants(MainFrame)) do
		if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
			v50(descendant, {
				TextTransparency = 1
			}, 0.2)
		elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
			v50(descendant, {
				ImageTransparency = 1
			}, 0.2)
		elseif descendant:IsA("Frame") or descendant:IsA("TextButton") then
			v50(descendant, {
				BackgroundTransparency = 1
			}, 0.2)
		elseif descendant:IsA("UIStroke") then
			v50(descendant, {
				Transparency = 1
			}, 0.2)
		end
	end

	local function v149()
		for _, activeTween in pairs(p32.ActiveTweens) do
			if activeTween then
				activeTween:Cancel()
			end
		end

		if p32.BlurEffect then
			p32.BlurEffect:Destroy()
		end

		p32.Background:Destroy()
		p32.MainFrame:Destroy()

		if not p33 then
			return
		end

		collectgarbage("collect")

		local v152 = p32

		v152.Notify(v152, {
			Title = "System",
			Content = "RAM successfully cleared (Garbage Collected).",
			Duration = 3,
			Icon = t2.value16
		})
	end

	v144.Completed:Connect(v149)
end

t2.value8 = t2.value22.new({
	Title = "WereTools - Key System",
	Note = "Authenticate to continue.",
	Link = "https://weretool.xyz/redeem",
	Callback = function(p34)
		if p34 == "" then
			return false, "Please enter a key."
		end

		local ok2, result = pcall(function()
			return t2.value19._sys_id()
		end)

		if not ok2 then
			return false, "Hardware ID error!"
		end

		local u155 = nil
		local s1 = ""
		local session_token = nil
		local PlaceId2 = game.PlaceId

		t2.value19._req_01(p34, result, PlaceId2, function(p35, p36)
			if p35 then
				if p36 then
					p35 = p36._validationProof
				else
					p35 = p36
				end
			end

			if p35 then
				local function v159()
					t2.value19._io_w(p34)
				end

				pcall(v159)

				if t2.value19._sec_02(p36._validationProof) then
					session_token = p36.session_token
					u155 = true
				else
					s1 = "Security validation failed"
					u155 = false
				end
			else
				local function v160()
					t2.value19._io_d()
				end

				pcall(v160)
				s1 = "Invalid Key or HWID Mismatch"
				u155 = false
			end
		end)

		local v161 = s1
		local v162 = session_token
		local n3 = 0

		while true do
			local v164

			if u155 == nil then
				v164 = n3 < 100
			else
				v164 = false
			end

			if not v164 then
				local v165

				if u155 == true then
					v165 = v162
				else
					v165 = false
				end

				if not v165 then
					return false, v161
				end

				task.spawn(function()
					t2.value21(v162)
				end)

				return true, "Success!"
			end

			task.wait(0.1)
			n3 = n3 + 1
		end
	end
})
t2.value8:Init()
t2.value8:Notify({
	Title = "WereTools",
	Content = "Key System initialized successfully.",
	Duration = 4,
	Icon = t2.value12
})
task.spawn(function()
	local u166 = nil

	pcall(function()
		u166 = t2.value19._io_r()
	end)

	local v167 = u166

	if v167 then
		v167 = u166 ~= ""
	end

	if not v167 then
		return
	end

	t2.value8.TextBox.Text = u166
	t2.value8.Note.Text = "Auto-authenticating..."
	t2.value8.SubmitBtn.TextLabel.Text = "..."

	local v168 = t2.value8.Config.Callback(u166)

	if v168 then
		t2.value8.SubmitBtn.TextLabel.Text = "Welcome!"
		t2.value8.SubmitBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		task.wait(0.5)
		t2.value8:Close(false)
	else
		t2.value8.TextBox.Text = ""
		t2.value8.SubmitBtn.TextLabel.Text = "Verify Key"
		t2.value8.Note.Text = "Saved key expired."
		t2.value8:Shake()
		t2.value8:Notify({
			Title = "Warning",
			Content = "Saved key expired, please get a new one!",
			Duration = 5,
			Icon = t2.value16
		})
		task.wait(2)
		t2.value8.Note.Text = t2.value8.Config.Note
	end
end)
