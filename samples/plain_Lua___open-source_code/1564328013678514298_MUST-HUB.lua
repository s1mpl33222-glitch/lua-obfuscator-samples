local t1 = {}

_G.__PropHubPremiumKeyOK = nil
_G.__PropHubPremiumKeyFailed = nil

local t2 = {
	value1 = "I LUV MUST",
	value2 = "MUST HUB",
	value3 = false,
	value4 = {
		N0T_Z0RO100= true,
		N0T_Z0RO100= true
	}
}

function t2.value5(p1)
	return p1 == t2.value1
end
function t2.value6()
	if t2.value3 then
		return false
	end

	local readfile_ = readfile

	if readfile_ then
		readfile_ = writefile

		if readfile_ then
			readfile_ = isfile
		end
	end

	if not readfile_ then
		return false
	end

	local u4 = nil

	local function v5()
		local v6 = isfile(t2.value2)

		if v6 then
			v6 = readfile(t2.value2) == t2.value1
		end

		if not v6 then
			return
		end

		u4 = true
	end

	u4 = false
	pcall(v5)

	return u4
end
function t2.value7()
	if t2.value3 then
		return
	end

	if not writefile then
		return
	end

	local function v7()
		writefile(t2.value2, t2.value1)
	end

	pcall(v7)
end

local function v8()
	local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local PropHubPremiumsKeyGate = PlayerGui:FindFirstChild("MustHubPremiumsKeyGate")

	if PropHubPremiumsKeyGate then
		PropHubPremiumsKeyGate:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "MusthubPremiumKeyGate"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Frame_ = Instance.new("Frame", ScreenGui)

	Frame_.Size = UDim2.new(1, 0, 1, 0)
	Frame_.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame_.BackgroundTransparency = 0.5
	Frame_.BorderSizePixel = 0
	Frame_.Active = true

	local Frame_2 = Instance.new("Frame", Frame_)

	Frame_2.Size = UDim2.new(0, 360, 0, 200)
	Frame_2.Position = UDim2.new(0.5, -180, 0.5, -100)
	Frame_2.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
	Frame_2.BorderSizePixel = 0
	Instance.new("UICorner", Frame_2).CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Frame_2)

	UIStroke.Color = Color3.fromRGB(220, 40, 40)
	UIStroke.Thickness = 2

	local TextLabel = Instance.new("TextLabel", Frame_2)

	TextLabel.Size = UDim2.new(1, -20, 0, 40)
	TextLabel.Position = UDim2.new(0, 10, 0, 15)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "MUST HUB PREMIUM — KEY REQUIRED"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 18
	TextLabel.TextColor3 = Color3.fromRGB(255, 130, 130)
	TextLabel.TextStrokeTransparency = 0.6

	local TextLabel2 = Instance.new("TextLabel", Frame_2)

	TextLabel2.Size = UDim2.new(1, -20, 0, 20)
	TextLabel2.Position = UDim2.new(0, 10, 0, 55)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "Enter the key to continue"
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 14
	TextLabel2.TextColor3 = Color3.fromRGB(200, 180, 180)

	local TextBox = Instance.new("TextBox", Frame_2)

	TextBox.Size = UDim2.new(1, -40, 0, 40)
	TextBox.Position = UDim2.new(0, 20, 0, 90)
	TextBox.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
	TextBox.BorderSizePixel = 0
	TextBox.Font = Enum.Font.Gotham
	TextBox.TextSize = 16
	TextBox.TextColor3 = Color3.new(1, 1, 1)
	TextBox.PlaceholderText = "Key..."
	TextBox.PlaceholderColor3 = Color3.fromRGB(180, 140, 140)
	TextBox.Text = ""
	TextBox.ClearTextOnFocus = false
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", TextBox).Color = Color3.fromRGB(220, 40, 40)

	local TextLabel3 = Instance.new("TextLabel", Frame_2)

	TextLabel3.Size = UDim2.new(1, -20, 0, 20)
	TextLabel3.Position = UDim2.new(0, 10, 0, 135)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = ""
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 13
	TextLabel3.TextColor3 = Color3.fromRGB(255, 80, 80)

	local TextButton = Instance.new("TextButton", Frame_2)

	TextButton.Size = UDim2.new(0, 140, 0, 32)
	TextButton.Position = UDim2.new(0.5, -70, 1, -45)
	TextButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	TextButton.BorderSizePixel = 0
	TextButton.Text = "Submit"
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 14
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

	local n1 = 0

	local function v21()
		if t2.value5(TextBox.Text) then
			TextLabel3.Text = "Key accepted. Loading..."
			TextLabel3.TextColor3 = Color3.fromRGB(80, 220, 120)
			TextButton.Text = "Loading..."
			TextButton.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
			t2.value7()
			task.wait(0.6)
			ScreenGui:Destroy()
			_G.__PropHubPremiumKeyOK = true
		else
			n1 = n1 + 1
			TextLabel3.Text = "Invalid key. Attempt " .. n1
			TextLabel3.TextColor3 = Color3.fromRGB(255, 80, 80)
			TextBox.Text = ""

			local Position = Frame_2.Position

			for i = 1, 6 do
				Frame_2.Position = Position + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)
				task.wait(0.03)
			end

			Frame_2.Position = Position

			if not (n1 >= 5) then
				return
			end

			TextLabel3.Text = "Too many attempts. Rejoin."
			TextButton.Text = "Locked"
			TextButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
			task.wait(2)
			ScreenGui:Destroy()
			_G.__PropHubPremiumKeyFailed = true
		end
	end

	TextButton.MouseButton1Click:Connect(v21)
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end

		v21()
	end)
	task.spawn(function()
		if not t2.value6() then
			return
		end

		TextLabel3.Text = "Saved key found. Loading..."
		TextLabel3.TextColor3 = Color3.fromRGB(80, 220, 120)
		task.wait(0.4)

		local Parent = ScreenGui

		if Parent then
			Parent = ScreenGui.Parent
		end

		if Parent then
			ScreenGui:Destroy()
		end

		_G.__PropHubPremiumKeyOK = true
	end)
end

if not _G.__PropHubPremiumKeyOK then
	v8()
	t1.value2 = 0

	while true do
		t1.value4 = not _G.__PropHubPremiumKeyOK
		t1.value3 = t1.value4

		if t1.value4 then
			t1.value5 = t1.value1

			local value4 = not _G.__PropHubPremiumKeyFailed

			if value4 then
				value4 = t1.value2 < 120
			end

			t1.value4 = value4

			local value5 = t1.value5
			local value42 = t1.value4

			t1.value1 = value5
			t1.value3 = value42
		end

		if not t1.value3 then
			break
		end

		task.wait(0.25)
		t1.value2 = t1.value2 + 0.25
	end

	t1.value5 = _G.__PropHubPremiumKeyFailed

	local value5 = t1.value5

	if not t1.value5 then
		value5 = not _G.__PropHubPremiumKeyOK
	end

	if value5 then
		return
	end
end

loadstring = loadstring or load

function t1.value4(p2)
	for _, v in ipairs({
		{
			name = "request",
			fn = function()
				local t3 = {
					Url = p2,
					Method = "GET"
				}

				return request(t3).Body
			end
		},
		{
			name = "http_request",
			fn = function()
				local t4 = {
					Url = p2,
					Method = "GET"
				}

				return http_request(t4).Body
			end
		},
		{
			name = "game:HttpGet",
			fn = function()
				return game:HttpGet(p2)
			end
		},
		{
			name = "syn.request",
			fn = function()
				local t5 = {
					Url = p2,
					Method = "GET"
				}

				return syn.request(t5).Body
			end
		},
		{
			name = "http.request",
			fn = function()
				local t6 = {
					Url = p2,
					Method = "GET"
				}

				return http.request(t6).Body
			end
		}
	}) do
		local ok, result = pcall(v.fn)

		if ok then
			if type(result) == "string" then
				ok = #result > 0
			else
				ok = false
			end
		end

		if ok then
			return result, v.name
		end
	end

	return nil, nil
end

t2.value8 = t1.value4
t1.value4 = {
	"MLModelDeliveryService",
	"PartyEmulatorService",
	"OmniRecommendationsService",
	"PlatformFriendsService"
}
t2.value9 = t1.value4
t2.value10 = nil

function t2.value10(p3)
	if type(p3) ~= "string" then
		return p3
	end

	local v37 = p3 .. "\n"
	local t7 = {}

	for match in v37.gmatch(v37, "([^\n]*)\n") do
		local v40, v41, v42 = ipairs(t2.value9)
		local v43 = false

		while true do
			local v44

			v42, v44 = v40(v41, v42)

			if not v42 then
				break
			end

			if string.find(match, v44, 1, true) then
				v43 = true

				break
			end
		end

		if not v43 then
			t7[#t7 + 1] = match
		end
	end

	local v45 = table.concat(t7, "\n")
	local v46 = string.gsub(v45, "while%s+true%s+do%s*end", "do end")
	local v47 = string.gsub(v46, "while%s+true%s+do%s*task%.wait%b()%s*end", "do end")
	local v48 = string.gsub(v47, "while%s+true%s+do%s*wait%b()%s*end", "do end")

	return string.gsub(v48, "while%s+true%s+do%s*task%.wait%b()%s*task%.wait%b()%s*end", "do end")
end

t2.value11 = nil

function t2.value11(p4, ...)
	local v49, v50 = t2.value8(p4)

	if v49 then
		local v51 = t2.value10(v49)

		print("[MUST HUB PREMIUM] Fetched via " .. tostring(v50) .. " (" .. #v51 .. " bytes, stripped)")

		if loadstring then
			local chunk, v53 = loadstring(v51)

			if chunk then
				local ok, result = pcall(chunk, ...)

				if ok then
					print("[Must hub premiums] Executed OK")

					return
				else
					warn("[Must Hub Premiums] Runtime error: " .. tostring(result))

					return
				end
			else
				warn("[Must Hub Premiums] Compile failed: " .. tostring(v53))

				return
			end
		else
			warn("[Must Hub Premiums] loadstring unavailable")

			return
		end
	else
		warn("[Must Hub Premiums] All HTTP methods failed: " .. p4)
	end
end
function t2.value12(p5)
	local v56, v57 = t2.value8(p5)

	if v56 then
		local v58 = t2.value10(v56)

		print("[Must Hub Premiums] Fetched via " .. tostring(v57) .. " (" .. #v58 .. " bytes, stripped)")

		if loadstring then
			local v59 = "local error = function() return nil end\n" .. v58
			local chunk, v61 = loadstring(v59)

			if chunk then
				local ok, result = pcall(chunk)

				if ok then
					print("[Must Hub Premiums] Executed OK (patched)")

					return
				else
					warn("[Must Hub Premiums] Runtime error: " .. tostring(result))

					return
				end
			else
				warn("[Must Hub Premiums] Compile failed: " .. tostring(v61))

				return
			end
		else
			warn("[Must Hub Premiums] loadstring unavailable")

			return
		end
	else
		warn("[Must Hub Premiums] All HTTP methods failed: " .. p5)
	end
end

t2.value13 = game:GetService("UserInputService")

local LocalPlayer = game.Players.LocalPlayer

Folder = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
t2.value14 = nil
t2.value15 = nil
t2.value16 = nil
t2.value17 = nil
t2.value18 = nil
t2.value19 = nil
t2.value20 = nil
t2.value21 = nil
t2.value22 = nil
t2.value23 = nil
t2.value24 = nil
t2.value25 = nil
t2.value26 = nil
t2.value27 = nil
t2.value28 = nil
t2.value29 = nil
t2.value30 = nil
t2.value31 = nil
t2.value32 = nil
t2.value33 = Instance.new("IntValue")
t2.value33.Value = 0
Instance.new("IntValue").Value = 0
t2.value34 = Instance.new("IntValue")
t2.value34.Value = 0
t2.value35 = Instance.new("IntValue")
t2.value35.Value = 0
t2.value36 = UDim2.new(0, 0, 0, 0)
t2.value37 = Color3.new(0.62745098039216, 0.07843137254902, 0.07843137254902)

function Execute(p6)
	local thread = coroutine.create(p6)
	local v66, v67 = coroutine.resume(thread)

	if v66 then
		return thread
	end

	warn("[Must Hub Premiums] Execute: " .. tostring(v67))

	return thread
end
function PlaySFX(p7, p8, p9, p10)
	t2.value18 = Instance.new("Sound", workspace)
	t2.value18.PlayOnRemove = true
	t2.value18.SoundId = "rbxassetid://" .. p7
	t2.value18.Volume = p8
	t2.value18.Pitch = p9
	t2.value18.Looped = p10

	if p10 then
		t2.value18:Play()

		return t2.value18
	end

	t2.value18.Ended:Connect(function()
		local value18 = t2.value18

		if value18 then
			value18 = t2.value18.Parent
		end

		if not value18 then
			return
		end

		t2.value18:Destroy()
	end)
	t2.value18:Play()

	return t2.value18
end
function Frame(p11, p12, p13)
	t2.value19 = Instance.new("Frame", p11)
	t2.value19.Size = p12
	t2.value19.Position = p13

	return t2.value19
end
function ScrollFrame(p14, p15, p16)
	t2.value19 = Instance.new("ScrollingFrame", p14)
	t2.value19.Size = p15
	t2.value19.Position = p16
	t2.value19.ScrollBarThickness = 10

	return t2.value19
end
function Label(p17, p18, p19, p20, p21)
	t2.value20 = Instance.new("TextLabel", p17)
	t2.value20.Size = p19
	t2.value20.Position = p20
	t2.value20.Text = p18
	t2.value20.BackgroundTransparency = 1
	t2.value20.Font = Enum.Font.Legacy
	t2.value20.TextColor3 = Color3.new(1, 1, 1)
	t2.value20.TextStrokeTransparency = 0.5
	t2.value20.TextWrapped = true

	if p21 == nil then
		return t2.value20
	end

	if p21 == 1 then
		t2.value20.Size = UDim2.new(1, -10, 0, 35)
	end

	t2.value20.Position = UDim2.new(0, 0, 0, 35 * p21.Value)
	t2.value20.BackgroundColor3 = t2.value37
	t2.value20.BackgroundTransparency = 0.85
	t2.value20.BorderSizePixel = 0
	p21.Value = p21.Value + 1

	return t2.value20
end
function Button(p22, p23, p24, p25, p26, p27)
	t2.value20 = Instance.new("TextButton", p22)
	t2.value20.Size = p24
	t2.value20.Position = p25
	t2.value20.Text = p23
	t2.value20.Style = Enum.ButtonStyle.RobloxButton
	t2.value20.Font = Enum.Font.Legacy
	t2.value20.TextColor3 = Color3.new(1, 1, 1)
	t2.value20.TextStrokeTransparency = 0.5
	t2.value20.TextWrapped = true
	t2.value20.MouseButton1Click:Connect(function()
		local function v69()
			PlaySFX(156785206, 0.75, 1.25)
			p26()
		end

		pcall(v69)
	end)

	if p27 == nil then
		return t2.value20
	end

	if p24 == t2.value36 then
		t2.value20.Size = UDim2.new(1, -10, 0, 35)
	end

	t2.value20.Position = UDim2.new(0, 0, 0, 35 * p27.Value)
	t2.value20.Style = Enum.ButtonStyle.Custom
	t2.value20.BackgroundColor3 = t2.value37
	t2.value20.BackgroundTransparency = 0.85
	t2.value20.BorderSizePixel = 0
	p27.Value = p27.Value + 1

	return t2.value20
end
function ImageLabel(p28, p29, p30, p31)
	t2.value20 = Instance.new("ImageLabel", p28)
	t2.value20.Image = "rbxassetid://" .. p29
	t2.value20.Size = p30
	t2.value20.Position = p31
	t2.value20.BackgroundTransparency = 1

	return t2.value20
end
function ToggleMenu()
	if t2.value32 == true then
		PlaySFX(243152215, 0.85, 1)

		local value23 = t2.value23
		local UDim2_ = UDim2

		value23.TweenPosition(value23, UDim2_.new(0.5, -250, -0.5, -175), "Out", "Quad", 0.5, true)
		PlaySFX(145487017, 0.85, 1.1)
		t2.value29:TweenPosition(UDim2.new(0, 0, 1, -50), "Out", "Quad", 0.25, true)
		t2.value32 = false
	else
		PlaySFX(243152215, 0.85, 1)
		t2.value23:TweenPosition(UDim2.new(0.5, -250, 0.5, -175), "Out", "Quad", 0.5, true)
		PlaySFX(145487017, 0.85, 1.1)
		t2.value29:TweenPosition(UDim2.new(0, -50, 1, -50), "Out", "Quad", 0.25, true)
		t2.value32 = true
	end
end
function AddTab(p32, p33, p34, p35)
	if p35 == nil then
		return
	end

	t2.value21 = Frame(p33, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
	t2.value21.BackgroundTransparency = 1
	t2.value21.BorderSizePixel = 0
	t2.value21.Name = p34
	t2.value21.Visible = false

	if p35.Value == 0 then
		t2.value21.Visible = true
	end

	Instance.new("IntValue", t2.value21).Name = "IsATab"
	t2.value20 = Button(p32, p34, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 5 + 40 * p35.Value), function()
		local v72 = p33

		for _, child in pairs(v72.GetChildren(v72)) do
			child.Visible = child.Name == p34
		end
	end)
	t2.value20.Style = Enum.ButtonStyle.Custom
	t2.value20.BackgroundColor3 = t2.value37
	t2.value20.BackgroundTransparency = 0.85
	t2.value20.BorderSizePixel = 0
	Instance.new("IntValue", t2.value20).Name = "IsATabButton"
	p35.Value = p35.Value + 1

	if p32.Parent.ClassName ~= "ScrollingFrame" then
		return t2.value21
	end

	p32.Parent.CanvasSize = UDim2.new(0, 0, 0, 5 + 40 * p35.Value)

	return t2.value21
end
function AddHotkey(p36, p37)
	t2.value13.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode ~= p36 then
			return
		end

		p37()
	end)
end
function t2.value38()
	t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Mickey-Chat-85762")
end
function t2.value39()
	t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Slayer-Hub-246319")
end
function t2.value40()
	t2.value11("https://scriptblox.com/raw/Brookhaven-RP-MUST-V4-BYPASSER-BY-N0TZ0RO100-232472")
end
function t2.value41()
	t2.value11("https://scriptblox.com/raw/Universal-Script-Fly-Ui-by-N0TZ0R0100-UPDATED-233378")
end
function t2.value42()
	t2.value11("https://scriptblox.com/raw/Universal-Script-Must-Universal-by-N0TZ0R0100-UPDATED-233184")
end
function t2.value43()
	t2.value11("https://pastefy.app/hFGaIIbr")
end
function t2.value44()
	t2.value11("https://scriptblox.com/raw/Brookhaven-RP-HX-Hexagon-Client-90722")
end
function t2.value45()
	t2.value11("https://scriptblox.com/raw/Brookhaven-RP-Rumi-Music-Hub-231585")
end
function t2.value46()
	local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	local DraggableGui = PlayerGui:FindFirstChild("DraggableGui")

	if DraggableGui then
		DraggableGui:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "DraggableGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Frame_ = Instance.new("Frame")

	Frame_.Name = "MainFrame"
	Frame_.Size = UDim2.fromOffset(160, 200)
	Frame_.Position = UDim2.new(0, 40, 0, 40)
	Frame_.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	Frame_.BorderSizePixel = 0
	Frame_.Active = true
	Frame_.ClipsDescendants = true
	Frame_.Parent = ScreenGui

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame_

	local ImageLabel_ = Instance.new("ImageLabel")

	ImageLabel_.Name = "Background"
	ImageLabel_.Size = UDim2.fromScale(1, 1)
	ImageLabel_.Position = UDim2.fromScale(0, 0)
	ImageLabel_.BackgroundTransparency = 1
	ImageLabel_.Image = "rbxassetid://77020598491913"
	ImageLabel_.ScaleType = Enum.ScaleType.Stretch
	ImageLabel_.ZIndex = 1
	ImageLabel_.Parent = Frame_

	local Frame_2 = Instance.new("Frame")

	Frame_2.Name = "TitleBar"
	Frame_2.Size = UDim2.new(1, 0, 0, 22)
	Frame_2.Position = UDim2.new(0, 0, 0, 0)
	Frame_2.BackgroundTransparency = 1
	Frame_2.BorderSizePixel = 0
	Frame_2.ZIndex = 2
	Frame_2.Parent = Frame_

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "Title"
	TextLabel.Size = UDim2.fromScale(1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Must hub"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 16
	TextLabel.TextStrokeTransparency = 1
	TextLabel.ZIndex = 3
	TextLabel.Parent = Frame_2

	local Frame_3 = Instance.new("Frame")

	Frame_3.Name = "ButtonHolder"
	Frame_3.Size = UDim2.new(1, 0, 1, -22)
	Frame_3.Position = UDim2.new(0, 0, 0, 22)
	Frame_3.BackgroundTransparency = 1
	Frame_3.ZIndex = 2
	Frame_3.Parent = Frame_

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 6)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame_3

	local function createTextButton(p38, p39, p40, p41)
		local TextButton = Instance.new("TextButton")

		TextButton.Name = p38
		TextButton.Size = UDim2.new(1, -20, 0, 32)
		TextButton.BackgroundTransparency = 1
		TextButton.BorderSizePixel = 0
		TextButton.Text = p39
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.Font = Enum.Font.GothamBold
		TextButton.TextSize = 13
		TextButton.TextStrokeTransparency = 1
		TextButton.AutoButtonColor = false
		TextButton.LayoutOrder = p40
		TextButton.ZIndex = 3
		TextButton.Parent = Frame_3

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Color = Color3.fromRGB(255, 255, 255)
		UIStroke2.Thickness = 1
		UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke2.Parent = TextButton
		TextButton.MouseButton1Click:Connect(p41)

		return TextButton
	end

	createTextButton("Musthubv3", "Must Hub V3", 1, function()
		pcall(function()
			t2.value11("https://pastefy.app/w5FYqDgg/raw")
		end)
	end)
	createTextButton("CurseHand", "Curse Hand", 2, function()
		local function v88()
			t2.value11("https://pastefy.app/rpXEbmwm/raw")
		end

		pcall(v88)
	end)
	createTextButton("AllSeeingHand", "All Seeing Hand", 3, function()
		local function v89()
			t2.value11("https://pastefy.app/cYwNpzjP/raw")
		end

		pcall(v89)
	end)

	local u90 = false

	Frame_.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u90 = true

		local _ = input.Position
		local _ = Frame_.Position
	end)
	t2.value13.InputChanged:Connect(function(input)
		local v93 = u90

		if v93 then
			v93 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v93 then
			return
		end

		local v94 = input.Position - nil

		Frame_.Position = UDim2.new((nil).X.Scale, (nil).X.Offset + v94.X, (nil).Y.Scale, (nil).Y.Offset + v94.Y)
	end)
	t2.value13.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
	end)
end

t2.value47 = {
	{ "Wing Prop2", function()
			t2.value11("https://pastefy.app/RM1MkrT4/raw")
		end },
	{ "Wing Prop", function()
			t2.value11("https://pastefy.app/IJHHtWR6/raw")
		end },
	{ "Shark Prop", function()
			t2.value11("https://pastefy.app/thWRWou1/raw")
		end },
	{ "B2 Spirit Prop", function()
			t2.value11("https://pastefy.app/b0JRIsKj/raw")
		end },
	{ "Avarice Scythe", function()
			t2.value11("https://pastefy.app/oneTZn9W/raw")
		end },
	{ "Gojo Controller", function()
			t2.value11("https://pastefy.app/3MShESQ2/raw")
		end },
	{ "Wither Prop", function()
			t2.value11("https://pastefy.app/q4Js0TjY/raw")
		end },
	{ "Wither Storm", function()
			t2.value11("https://pastefy.app/5NOFcoUP/raw")
		end },
	{ "Wither Prop2", function()
			t2.value11("https://pastefy.app/6jvLhYaS/raw")
		end },
	{ "B2-Spirit2", function()
			t2.value11("https://pastefy.app/we9aonad/raw")
		end },
	{ "Wither3", function()
			t2.value11("https://pastefy.app/0eGHRHNp/raw")
		end },
	{ "Wither Storm2", function()
			t2.value11("https://pastefy.app/r4nWQYzg/raw")
		end },
	{ "Verity Prop", function()
			t2.value11("https://pastefy.app/x1BOck3z/raw")
		end },
	{ "Godzilla Prop", function()
			t2.value11("https://raw.githubusercontent.com/Johan319/Fe-Godzilla-Obfuscator/refs/heads/main/godzilla")
		end },
	{ "Raiden (Dyton Security)", function()
			t2.value11("https://encrypt-x.pages.dev/Scripts?Id=raidenmaru", "raidenmaru")
		end },
	{ "Nothing Panel (Mecha)", function()
			t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Nothing-Panel-223707")
		end },
	{ "Wing Prop3", function()
			t2.value11("https://pastefy.app/6ZVZWkbb/raw")
		end },
	{ "Ender Dragon", function()
			t2.value11("https://pastefy.app/knN2ER4f/raw")
		end },
	{ "Radar Terror", function()
			t2.value11("https://pastefy.app/lXwhhrxw/raw")
		end },
	{ "B2 Spirit Prop3", function()
			t2.value11("https://pastefy.app/J35BTsjO/raw")
		end },
	{ "Rodan Prop", function()
			t2.value11("https://pastefy.app/MeSs5ehk/raw")
		end },
	{ "Dual Spider Engine", function()
			t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Engine-spider-props-use-sit-props-243775")
		end },
	{ "Spear Prop", function()
			t2.value11("https://pastefy.app/pDY43Jvl/raw")
		end },
	{ "Curse Engine", function()
			t2.value11("https://pastefy.app/LCb15eUP/raw")
		end },
	{ "Sukuna", function()
			t2.value11("https://pastefy.app/XvOVpQB0/raw")
		end },
	{ "SCMD Prop (Key Xiandi)", function()
			t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Wings-cmback-use-prop-Brookhaven-key-xiandi-211092")
		end },
	{ "Avarice Prop", function()
			t2.value11("https://rawscripts.net/raw/Brookhaven-RP-AVARICE-WINGS-BY-NIZAM-217994")
		end },
	{ "Eryx (Key: ErYxOnToP)", function()
			t2.value11("https://rawscripts.net/raw/Universal-Script-ErYx-Prop-Animations-by-vansh-238691")
		end },
	{ "TXR Prop", function()
			t2.value11("https://rawscripts.net/raw/Universal-Script-TXR-ASHU-ROBOT-POWERFULL-TROLL-SCRIPT-241380")
		end },
	{ "Reptile", function()
			t2.value11("https://pastefy.app/vtA0dM2D/raw")
		end },
	{ "Wings Prop V4", function()
			t2.value11("https://rawscripts.net/raw/Universal-Script-Wings-By-yanzz-227428")
		end },
	{ "Immortal Demon", function()
			t2.value11("https://pastefy.app/50yM3llG/raw")
		end },
	{ "Leviathan", function()
			t2.value11("https://pastefy.app/tPvt3Uv8/raw")
		end },
	{ "Hand Prop", function()
			t2.value11("https://pastefy.app/8oXtJqyl/raw")
		end },
	{ "Soul Revenger", function()
			t2.value11("https://pastefy.app/DyTYj5Yu/raw")
		end },
	{ "Siren Head The Nightmare Stalker (Dyton Security)", function()
			t2.value12("https://api.rubis.app/v2/scrap/sOHDXpo9eskJoAu4/raw")
		end },
	{ "Susano", function()
			t2.value11("https://pastefy.app/90HgaYmZ/raw")
		end },
	{ "Susano 2", function()
			t2.value11("https://pastefy.app/QSpPmcOu/raw")
		end },
	{ "plane prop", function()
			t2.value11("https://pastefy.app/1cxYPFnt/raw?part=Phi%20c%C6%A1%20brookhaven")
		end },
	{ "Wither Storm 3", function()
			t2.value11("https://pastefy.app/l4ELsID8/raw")
		end },
	{ "All Seeing Hand", function()
			t2.value11("https://pastefy.app/cYwNpzjP/raw")
		end },
	{ "Join Discord", function()
			local discord = "https://discord.gg/Pb7CD2qD"

			if setclipboard then
				setclipboard(discord)
				print("Discord link copied!")
			else
				print("Discord: " .. discord)
			end
		end }
}

function GeneratePropTab()
	local v97 = AddTab(t2.value30, t2.value31, "Prop", t2.value33)

	v97.Size = UDim2.new(1, 10, 1, 0)
	v97.ClipsDescendants = true

	local IntValue = Instance.new("IntValue", v97)

	IntValue.Value = 1

	local value = #t2.value47
	local uDim2 = UDim2.new(0.5, -75, 0.5, -75)
	local uDim22 = UDim2.new(0, 150, 0, 150)
	local uDim23 = UDim2.new(0, 75, 0, 75)
	local Frame_ = Instance.new("Frame", v97)

	Frame_.Size = UDim2.new(1, 0, 1, 0)
	Frame_.BackgroundTransparency = 1
	Frame_.ClipsDescendants = true

	local TextBox = Instance.new("TextBox", Frame_)

	TextBox.BackgroundColor3 = t2.value37
	TextBox.BackgroundTransparency = 0.85
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, -100, 0, 5)
	TextBox.Size = UDim2.new(0, 200, 0, 20)
	TextBox.Font = Enum.Font.Legacy
	TextBox.TextColor3 = Color3.new(1, 1, 1)
	TextBox.TextStrokeTransparency = 0.5
	TextBox.Text = "Search..."
	TextBox.ClearTextOnFocus = true
	TextBox.ZIndex = 5
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end

		local v105 = string.lower(TextBox.Text)

		for _, child in pairs(Frame_:GetChildren()) do
			local v108 = child.Name == "Cube"

			if v108 then
				v108 = child:FindFirstChild("Title")

				if v108 then
					v108 = child:FindFirstChild("Id")
				end
			end

			if v108 and string.find(string.lower(child.Title.Text), v105, 1, true) then
				IntValue.Value = child.Id.Value

				return
			end
		end
	end)

	local function createFrame(p42, p43, p44, p45)
		local Frame_2 = Instance.new("Frame", p42)

		Frame_2.BorderSizePixel = 0
		Frame_2.Name = "Cube"
		Frame_2.BackgroundTransparency = 0.85
		Frame_2.BackgroundColor3 = t2.value37

		local IntValue2 = Instance.new("IntValue", Frame_2)

		IntValue2.Name = "Id"
		IntValue2.Value = p44

		local TextLabel = Instance.new("TextLabel", Frame_2)

		TextLabel.Text = "  ID: " .. p44
		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.new(0, 100, 0, 20)
		TextLabel.Font = Enum.Font.Legacy
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextStrokeTransparency = 0.5
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.ZIndex = 2

		local TextLabel2 = Instance.new("TextLabel", Frame_2)

		TextLabel2.Text = p43
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Size = UDim2.new(1, 0, 0.1, 0)
		TextLabel2.Position = UDim2.new(0, 0, 0.15, 0)
		TextLabel2.Font = Enum.Font.Legacy
		TextLabel2.TextScaled = true
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.TextStrokeTransparency = 0.5
		TextLabel2.Name = "Title"
		TextLabel2.ZIndex = 2

		local TextButton = Instance.new("TextButton", Frame_2)

		TextButton.Text = "Execute"
		TextButton.BackgroundColor3 = t2.value37
		TextButton.BackgroundTransparency = 0.85
		TextButton.Size = UDim2.new(0.75, 0, 0.2, 0)
		TextButton.Position = UDim2.new(0.125, 0, 0.75, 0)
		TextButton.Font = Enum.Font.Legacy
		TextButton.TextScaled = true
		TextButton.TextColor3 = Color3.new(1, 1, 1)
		TextButton.TextStrokeTransparency = 0.5
		TextButton.BorderSizePixel = 0
		TextButton.ZIndex = 2
		TextButton.MouseButton1Click:Connect(function()
			PlaySFX(156785206, 0.75, 1.25)
			pcall(p45)
		end)

		return Frame_2
	end

	for i, v in ipairs(t2.value47) do
		createFrame(Frame_, v[1], i, v[2])
	end

	local function v117()
		PlaySFX(156785206, 0.75, 1.25)

		if IntValue.Value > 1 then
			IntValue.Value = IntValue.Value - 1
		else
			IntValue.Value = value
		end
	end

	local TextButton = Instance.new("TextButton", Frame_)

	TextButton.Size = UDim2.new(0, 50, 1, 0)
	TextButton.Text = "<"
	TextButton.BackgroundTransparency = 0.85
	TextButton.BackgroundColor3 = t2.value37
	TextButton.BorderSizePixel = 0
	TextButton.Font = Enum.Font.Legacy
	TextButton.TextStrokeTransparency = 0.5
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.ZIndex = 3
	TextButton.MouseButton1Click:Connect(v117)

	local TextButton2 = Instance.new("TextButton", Frame_)

	TextButton2.Size = UDim2.new(0, 50, 1, 0)
	TextButton2.Position = UDim2.new(1, -50, 0, 0)
	TextButton2.BackgroundTransparency = 0.85
	TextButton2.BackgroundColor3 = t2.value37
	TextButton2.BorderSizePixel = 0
	TextButton2.Text = ">"
	TextButton2.Font = Enum.Font.Legacy
	TextButton2.TextStrokeTransparency = 0.5
	TextButton2.TextColor3 = Color3.new(1, 1, 1)
	TextButton2.ZIndex = 3
	TextButton2.MouseButton1Click:Connect(function()
		PlaySFX(156785206, 0.75, 1.25)

		if IntValue.Value < value then
			IntValue.Value = IntValue.Value + 1
		else
			IntValue.Value = 1
		end
	end)
	AddHotkey(Enum.KeyCode.Q, function()
		local value32 = t2.value32

		if value32 then
			value32 = v97.Visible
		end

		if not value32 then
			return
		end

		v117()
	end)
	AddHotkey(Enum.KeyCode.E, function()
		local value32 = t2.value32

		if value32 then
			value32 = v97.Visible
		end

		if not value32 then
			return
		end

		PlaySFX(156785206, 0.75, 1.25)

		if IntValue.Value < value then
			IntValue.Value = IntValue.Value + 1

			return
		end

		IntValue.Value = 1
	end)

	local function v122()
		local v123 = Frame_

		for _, child in pairs(v123.GetChildren(v123)) do
			local v126 = child.Name == "Cube"

			if v126 then
				v126 = child:FindFirstChild("Id")
			end

			if v126 then
				if child.Id.Value == IntValue.Value then
					child:TweenSizeAndPosition(uDim22, uDim2, "Out", "Quad", 0.75, true)
				elseif child.Id.Value > IntValue.Value then
					if child.Id.Value > IntValue.Value + 1 then
						child:TweenSizeAndPosition(uDim23, UDim2.new(1.5, -37.5, 0.25, -75), "Out", "Quad", 0.75, true)
					else
						child:TweenSizeAndPosition(uDim23, UDim2.new(0.75, -37.5, 0.25, 0), "Out", "Quad", 0.75, true)
					end
				elseif child.Id.Value < IntValue.Value then
					if child.Id.Value < IntValue.Value - 1 then
						child:TweenSizeAndPosition(uDim23, UDim2.new(-0.5, -37.5, 0.25, -75), "Out", "Quad", 0.75, true)
					else
						local v127 = uDim23
						local UDim2_ = UDim2

						child.TweenSizeAndPosition(child, v127, UDim2_.new(0.25, -37.5, 0.25, 0), "Out", "Quad", 0.75, true)
					end
				end
			end
		end
	end

	IntValue.Changed:Connect(v122)
	task.wait()
	v122()
end
function GenerateTrollTab()
	local v129 = AddTab(t2.value30, t2.value31, "Troll", t2.value33)

	v129.Size = UDim2.new(1, 10, 1, 0)

	local v130 = ScrollFrame(v129, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))

	v130.BackgroundTransparency = 1
	v130.BorderSizePixel = 0
	v130.CanvasSize = UDim2.new(0, 0, 0, 0)

	local t8 = {
		{ "Mickey Chat", t2.value38 },
		{ "Slayer Hub", t2.value39 },
		{ "Must bypasser", t2.value40 },
		{ "Must fly ui", t2.value41 },
		{ "Must universal", t2.value42 }
	}

	for _, v in ipairs(t8) do
		local Button_ = Button
		local v135 = v[1]
		local v136 = v[2]

		Button_(v130, v135, t2.value36, t2.value36, v136, t2.value34)
		v130.CanvasSize = UDim2.new(0, 0, 0, 35 * t2.value34.Value)
	end
end
function GenerateExtraTab()
	local v137 = AddTab(t2.value30, t2.value31, "Extra", t2.value33)

	v137.Size = UDim2.new(1, 10, 1, 0)

	local v138 = ScrollFrame(v137, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))

	v138.BackgroundTransparency = 1
	v138.BorderSizePixel = 0
	v138.CanvasSize = UDim2.new(0, 0, 0, 0)

	local t9 = {
		{ "Prop Gui (not mine)", t2.value43 },
		{ "Hexagon client", t2.value44 },
		{ "Rumi music hub", t2.value45 },
		{ "Terry Hub", t2.value46 }
	}

	for _, v in ipairs(t9) do
		local Button_ = Button
		local v143 = v[1]
		local v144 = v[2]

		Button_(v138, v143, t2.value36, t2.value36, v144, t2.value35)
		v138.CanvasSize = UDim2.new(0, 0, 0, 35 * t2.value35.Value)
	end
end
function GenerateMenu(p46)
	t2.value23 = Frame(p46, UDim2.new(0, 475, 0, 20), UDim2.new(0.5, -250, -0.5, -175))
	t2.value23.Style = Enum.FrameStyle.RobloxRound
	t2.value23.Draggable = true
	t2.value23.Active = true
	t2.value23.ZIndex = 2
	t2.value21 = Frame(t2.value23, UDim2.new(0, 500, 0, 350), UDim2.new(0, -20, 0, -20))
	t2.value21.Style = Enum.FrameStyle.RobloxRound
	t2.value22 = Label(t2.value23, "Must Hub Premiums", UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 15, 0, 0))
	t2.value22.FontSize = Enum.FontSize.Size12
	t2.value22.TextXAlignment = Enum.TextXAlignment.Left
	t2.value22.ZIndex = 3
	t2.value22 = Button(t2.value23, "x", UDim2.new(0, 20, 0, 20), UDim2.new(1, -15, 0, -9), function()
		ToggleMenu()
	end)
	t2.value22.FontSize = Enum.FontSize.Size12
	t2.value22.Style = Enum.ButtonStyle.Custom
	t2.value22.BackgroundTransparency = 1
	t2.value22.ZIndex = 3
	t2.value24 = Frame(t2.value21, UDim2.new(1, -10, 1, -35), UDim2.new(0, 5, 0, 30))
	t2.value24.Name = "Main"
	t2.value24.Style = Enum.FrameStyle.RobloxRound
	t2.value25 = ImageLabel(t2.value21, "79148306484407", UDim2.new(0, 100, 0, 100), UDim2.new(0, -50, 0, -50))
	t2.value25.ZIndex = 4

	local function v145()
		local function v146()
			local v147 = true

			while task.wait(0.0025) do
				if v147 == false then
					t2.value25.Rotation = t2.value25.Rotation + 1
					v147 = t2.value25.Rotation >= 10 and true or v147
				else
					t2.value25.Rotation = t2.value25.Rotation - 1

					if t2.value25.Rotation <= -10 then
						v147 = false
					end
				end
			end
		end

		Execute(v146)
	end

	pcall(v145)
	t2.value26 = Frame(t2.value24, UDim2.new(0, 5, 1, 0), UDim2.new(0, 110, 0, 0))
	t2.value26.BackgroundColor3 = t2.value37
	t2.value26.BackgroundTransparency = 0.5
	t2.value26.BorderSizePixel = 0
	t2.value26 = Frame(t2.value24, UDim2.new(0, 10, 1, 0), UDim2.new(0, 100, 0, 0))
	t2.value26.BackgroundColor3 = t2.value37
	t2.value26.BackgroundTransparency = 0.75
	t2.value26.BorderSizePixel = 0
	t2.value26 = Frame(t2.value24, UDim2.new(0, 10, 1, 0), UDim2.new(1, -10, 0, 0))
	t2.value26.BackgroundColor3 = t2.value37
	t2.value26.BackgroundTransparency = 0.75
	t2.value26.BorderSizePixel = 0
	t2.value27 = ScrollFrame(t2.value24, UDim2.new(0, 110, 1, 0), UDim2.new(0, 0, 0, 0))
	t2.value27.BackgroundColor3 = t2.value37
	t2.value27.BackgroundTransparency = 0.75
	t2.value27.BorderSizePixel = 0
	t2.value28 = Frame(t2.value24, UDim2.new(1, -115, 1, 0), UDim2.new(0, 115, 0, 0))
	t2.value28.BackgroundColor3 = t2.value37
	t2.value28.BackgroundTransparency = 0.75
	t2.value28.BorderSizePixel = 0
	t2.value29 = Button(p46, "SHOW", UDim2.new(0, 50, 0, 50), UDim2.new(0, -50, 1, -50), function()
		ToggleMenu()
	end)
	t2.value29.TextWrapped = false
	t2.value30 = Frame(t2.value27, UDim2.new(0, 100, 0, 0), UDim2.new(0, 0, 0, 0))
	t2.value30.BackgroundTransparency = 1
	t2.value31 = Frame(t2.value28, UDim2.new(1, -10, 1, 0), UDim2.new(0, 0, 0, 0))
	t2.value31.BackgroundTransparency = 1
	GeneratePropTab()
	GenerateTrollTab()
	GenerateExtraTab()

	return t2.value21
end
function PlayIntro(p47)
	t2.value14 = Frame(p47, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0))
	t2.value14.Style = Enum.FrameStyle.RobloxRound
	ImageLabel(t2.value14, "79148306484407", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
	PlaySFX(145487017, 1, 0.75)
	t2.value14:TweenSizeAndPosition(UDim2.new(0, 300, 0, 300), UDim2.new(0.5, -150, 0.5, -150), "Out", "Bounce", 0.5, true)
	task.wait(1)
	PlaySFX(145487017, 0.75, 1.25)
	t2.value14:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Bounce", 0.5, true)
	task.wait(0.75)
	t2.value14:Destroy()
	t2.value15 = Frame(p47, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0))
	t2.value15.Style = Enum.FrameStyle.RobloxRound
	t2.value16 = Label(t2.value15, "Must Hub Premiums", UDim2.new(1, 10, 0.5, 10), UDim2.new(0, -5, 0, -5))
	t2.value16.FontSize = Enum.FontSize.Size24
	t2.value17 = Label(t2.value15, "Made by N0T_Z0RO100", UDim2.new(1, 10, 0.4, 0), UDim2.new(0, -5, 0.5, 5))
	t2.value17.FontSize = Enum.FontSize.Size14
	PlaySFX(145487017, 1, 0.75)
	t2.value15:TweenSizeAndPosition(UDim2.new(0, 300, 0, 300), UDim2.new(0.5, -150, 0.5, -150), "Out", "Bounce", 0.5, true)
	task.wait(1)
	PlaySFX(145487017, 0.75, 1.25)
	t2.value15:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Bounce", 0.5, true)
	task.wait(0.75)
	t2.value15:Destroy()
end

t2.value48 = "PHANN_"
t2.value49 = 5
t2.value50 = 180
t2.value51 = Instance.new("ScreenGui")
t2.value51.Name = "MustHubAnnouncements"
t2.value51.ResetOnSpawn = false
t2.value51.IgnoreGuiInset = false
t2.value51.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value51.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
t2.value52 = nil
t2.value53 = nil

function t2.value53(p48, p49)
	task.spawn(function()
		local function v148()
			return game:GetService("Players"):GetUserThumbnailAsync(p48, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end

		local ok, result = pcall(v148)

		if not (ok and result) then
			return
		end

		p49(result)
	end)
end

t2.value54 = nil

function t2.value54(p50, p51)
	if t2.value4[string.lower(p51 or "")] ~= true then
		return
	end

	local value52 = t2.value52

	if value52 then
		value52 = t2.value52.Parent
	end

	if value52 then
		t2.value52:Destroy()
	end

	local Frame_ = Instance.new("Frame")

	Frame_.Name = "AnnounceBanner"
	Frame_.Size = UDim2.new(0, 560, 0, 100)
	Frame_.Position = UDim2.new(0.5, -280, 0, -120)
	Frame_.BackgroundColor3 = Color3.fromRGB(35, 5, 5)
	Frame_.BackgroundTransparency = 0.05
	Frame_.BorderSizePixel = 0
	Frame_.ZIndex = 100
	Frame_.Parent = t2.value51
	Instance.new("UICorner", Frame_).CornerRadius = UDim.new(0, 12)

	local UIStroke = Instance.new("UIStroke", Frame_)

	UIStroke.Color = Color3.fromRGB(220, 40, 40)
	UIStroke.Thickness = 2

	local ImageLabel_ = Instance.new("ImageLabel", Frame_)

	ImageLabel_.Name = "Avatar"
	ImageLabel_.Size = UDim2.new(0, 44, 0, 44)
	ImageLabel_.Position = UDim2.new(0, 14, 0, 12)
	ImageLabel_.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
	ImageLabel_.BackgroundTransparency = 0.15
	ImageLabel_.BorderSizePixel = 0
	ImageLabel_.Image = "rbxassetid://0"
	ImageLabel_.ZIndex = 102
	Instance.new("UICorner", ImageLabel_).CornerRadius = UDim.new(1, 0)

	local UIStroke2 = Instance.new("UIStroke", ImageLabel_)

	UIStroke2.Color = Color3.fromRGB(220, 40, 40)
	UIStroke2.Thickness = 1.5

	local v156 = game.Players:FindFirstChild(p51)

	if v156 then
		t2.value53(v156.UserId, function(p52)
			local Parent = ImageLabel_

			if Parent then
				Parent = ImageLabel_.Parent
			end

			if not Parent then
				return
			end

			ImageLabel_.Image = p52
		end)
	end

	local TextLabel = Instance.new("TextLabel", Frame_)

	TextLabel.Size = UDim2.new(1, -82, 0, 22)
	TextLabel.Position = UDim2.new(0, 68, 0, 10)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 15
	TextLabel.TextColor3 = Color3.fromRGB(255, 200, 60)
	TextLabel.TextStrokeTransparency = 1
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 102
	TextLabel.Text = p51 .. "  ·  OWNER"

	local TextLabel2 = Instance.new("TextLabel", Frame_)

	TextLabel2.Size = UDim2.new(1, -82, 0, 13)
	TextLabel2.Position = UDim2.new(0, 68, 0, 32)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 11
	TextLabel2.TextColor3 = Color3.fromRGB(200, 140, 140)
	TextLabel2.TextStrokeTransparency = 1
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.ZIndex = 102
	TextLabel2.Text = "announcement"

	local TextLabel3 = Instance.new("TextLabel", Frame_)

	TextLabel3.Size = UDim2.new(1, -28, 0, 34)
	TextLabel3.Position = UDim2.new(0, 14, 0, 60)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextSize = 17
	TextLabel3.TextColor3 = Color3.new(1, 1, 1)
	TextLabel3.TextStrokeTransparency = 1
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Text = p50
	TextLabel3.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel3.TextWrapped = false
	TextLabel3.ZIndex = 102
	Frame_:TweenPosition(UDim2.new(0.5, -280, 0, 12), "Out", "Quad", 0.4, true)
	task.spawn(function()
		task.wait(t2.value49)

		local Parent = Frame_

		if Parent then
			Parent = Frame_.Parent
		end

		if not Parent then
			return
		end

		Frame_:TweenPosition(UDim2.new(0.5, -280, 0, -120), "Out", "Quad", 0.4, true)
		task.wait(0.5)

		local Parent2 = Frame_

		if Parent2 then
			Parent2 = Frame_.Parent
		end

		if not Parent2 then
			return
		end

		Frame_:Destroy()
	end)
end
function t2.value55(p53)
	local Name = game.Players.LocalPlayer.Name

	if t2.value4[string.lower(Name or "")] ~= true then
		warn("[Must Hub] Not authorized to announce")

		return
	end

	if not p53 or #p53 == 0 then
		return
	end

	if #p53 > t2.value50 then
		local value50 = t2.value50

		p53 = string.sub(p53, 1, value50) .. "..."
	end

	local v165 = t2.value48 .. p53

	if pcall(function()
		local TextChatService = game:GetService("TextChatService")
		local TextChannels = TextChatService.TextChannels

		if TextChannels then
		elseif TextChannels then
			TextChannels:SendAsync(v165)

			return true
		else
			return false
		end

		TextChannels = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

		if TextChannels then
			TextChannels:SendAsync(v165)

			return true
		else
			return false
		end
	end) then
		t2.value54(p53, game.Players.LocalPlayer.Name)

		return
	end

	pcall(function()
		local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
		local SayMessageRequest

		if DefaultChatSystemChatEvents then
			SayMessageRequest = DefaultChatSystemChatEvents.SayMessageRequest
		else
			SayMessageRequest = DefaultChatSystemChatEvents
		end

		if not SayMessageRequest then
			return
		end

		DefaultChatSystemChatEvents.SayMessageRequest:FireServer(v165, "All")
	end)
	t2.value54(p53, game.Players.LocalPlayer.Name)
end
function t2.value56()
	local Name = game.Players.LocalPlayer.Name

	if t2.value4[string.lower(Name or "")] ~= true then
		return
	end

	if not t2.value23 then
		return
	end

	local TextBox = Instance.new("TextBox", t2.value23)

	TextBox.Size = UDim2.new(0, 220, 0, 18)
	TextBox.Position = UDim2.new(0, 130, 0, -9)
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
	TextBox.BorderSizePixel = 0
	TextBox.Font = Enum.Font.Legacy
	TextBox.TextSize = 12
	TextBox.TextColor3 = Color3.new(1, 1, 1)
	TextBox.PlaceholderText = "Announcement..."
	TextBox.PlaceholderColor3 = Color3.fromRGB(180, 140, 140)
	TextBox.Text = ""
	TextBox.ClearTextOnFocus = false
	TextBox.ZIndex = 5
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

	local TextButton = Instance.new("TextButton", t2.value23)

	TextButton.Size = UDim2.new(0, 52, 0, 18)
	TextButton.Position = UDim2.new(0, 355, 0, -9)
	TextButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	TextButton.BorderSizePixel = 0
	TextButton.Font = Enum.Font.Legacy
	TextButton.TextSize = 11
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.Text = "SEND"
	TextButton.ZIndex = 5
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

	local function v173()
		local Text = TextBox.Text
		local v175

		if Text then
			v175 = #Text > 0
		else
			v175 = Text
		end

		if not v175 then
			return
		end

		t2.value55(Text)
		TextBox.Text = ""
	end

	TextButton.MouseButton1Click:Connect(v173)
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end

		local Text = TextBox.Text
		local v177

		if Text then
			v177 = #Text > 0
		else
			v177 = Text
		end

		if not v177 then
			return
		end

		t2.value55(Text)
		TextBox.Text = ""
	end)
end

(function()
	local function v178()
		game:GetService("TextChatService").MessageReceived:Connect(function(p54)
			local Text = p54.Text or ""
			local v180 = #t2.value48

			if string.sub(Text, 1, v180) ~= t2.value48 then
				return
			end

			local v181 = #t2.value48 + 1
			local v182 = string.sub(Text, v181)
			local TextSource = p54.TextSource

			if TextSource then
				TextSource = p54.TextSource.Name
			end

			local v184 = TextSource or "unknown"

			if v184 == game.Players.LocalPlayer.Name then
				return
			end

			t2.value54(v182, v184)
		end)
	end

	pcall(v178)
	pcall(function()
		local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
		local OnMessageDoneFiltering

		if DefaultChatSystemChatEvents then
			OnMessageDoneFiltering = DefaultChatSystemChatEvents.OnMessageDoneFiltering
		else
			OnMessageDoneFiltering = DefaultChatSystemChatEvents
		end

		if not OnMessageDoneFiltering then
			return
		end

		DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(p55)
			local Message = p55.Message or ""
			local v188 = #t2.value48

			if string.sub(Message, 1, v188) ~= t2.value48 then
				return
			end

			local v189 = #t2.value48 + 1
			local v190 = string.sub(Message, v189)
			local FromSpeaker = p55.FromSpeaker or "unknown"

			if FromSpeaker == game.Players.LocalPlayer.Name then
				return
			end

			t2.value54(v190, FromSpeaker)
		end)
	end)
end)()
pcall(function()
	local TextChatService = game:GetService("TextChatService")

	if not TextChatService.OnIncomingMessage then
		return
	end

	local OnIncomingMessage = TextChatService.OnIncomingMessage

	function TextChatService.OnIncomingMessage(p56)
		local Text = p56.Text or ""
		local v195 = #t2.value48

		if string.sub(Text, 1, v195) == t2.value48 then
			local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

			TextChatMessageProperties.TextTransparency = 1

			return TextChatMessageProperties
		elseif OnIncomingMessage then
			return OnIncomingMessage(p56)
		else
			return nil
		end
	end
end)
t2.value57 = Instance.new("ScreenGui", Folder)
t2.value57.Name = "MustHubPremiums"
t2.value57.ResetOnSpawn = false
Execute(function()
	local function v197()
		task.wait(0.25)
		PlayIntro(t2.value57)
		GenerateMenu(t2.value57)
		t2.value56()
		task.wait(0.25)
		PlaySFX(145487017, 0.85, 1.1)
		t2.value29:TweenPosition(UDim2.new(0, 0, 1, -50), "Out", "Bounce", 1, true)
	end

	pcall(v197)
end)
print("[Must Hub Premiums] Loaded — N0T_Z0RO100 + N0T_Z0RO100")
print("[Must Hub Premiums] Prop (42) | Troll (5) | Extra (4)")
print("[Must Hub Premiums] Owners: N0T_Z0RO100, N0T_Z0RO100 | No name tags")
