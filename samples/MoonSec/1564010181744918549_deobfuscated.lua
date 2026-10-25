local n1 = 3077
local HttpService = game:GetService("HttpService")
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local syn_ = not request and (not http_request and syn)

if syn_ then
	syn_ = syn.request
end

local s1 = "JDarks15/key.json"
local ScreenGui = Instance.new("ScreenGui")

function onMessage(p1)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "JDarks",
		Text = p1,
		Duration = 5
	})
end

local function v8(p2)
	if isfolder("JDarks15") then
		v10 = {
			key = p2,
			time = os.time()
		}
		v11 = HttpService
		writefile(s1, v11:JSONEncode(v10))

		return
	end

	makefolder("JDarks15")

	local t1 = {
		key = p2,
		time = os.time()
	}
	local v12 = HttpService

	writefile(s1, v12:JSONEncode(t1))
end
local function v13()
	if not isfile(s1) then
		return nil
	end

	local data = HttpService:JSONDecode(readfile(s1))

	if not (os.time() - data.time >= 86400) then
		return data.key
	end

	delfile(s1)

	return nil
end
local function v14()
	local v15 = syn_
	local t2 = {
		Url = "https://api.platoboost.com/public/start",
		Method = "POST",
		Body = HttpService:JSONEncode({
			service = n1,
			identifier = LocalPlayer.UserId
		}),
		Headers = {
			["Content-Type"] = "application/json"
		}
	}
	local v16 = v15(t2)

	if v16 and v16.StatusCode == 200 then
		local data = HttpService:JSONDecode(v16.Body)

		if data.success then
			setclipboard(data.data.url)
			onMessage("Key link copied! Paste it in your browser.")
		else
			onMessage("Error: " .. data.message)
		end
	else
		onMessage("Failed to get key link. Try again later.")
	end
end
local function v18(p3)
	local v19 = syn_({
		Url = "https://api.platoboost.com/public/whitelist/" .. n1 .. "?identifier=" .. LocalPlayer.UserId .. "&key=" .. p3,
		Method = "GET"
	})

	if v19 and v19.StatusCode == 200 then
		local data = HttpService:JSONDecode(v19.Body)

		if data.success and data.data.valid then
			onMessage("Key is valid! Access granted.")
			v8(p3)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RedJDark/MAIN/refs/heads/main/eyeyey"))()
			ScreenGui.Parent = nil
			ScreenGui:Destroy()

			return true
		else
			onMessage("Invalid key! Try again.")

			return false
		end
	else
		onMessage("Server error. Try again later.")

		return false
	end
end

ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local TextButton2 = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "JDarks"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 22
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextButton.Parent = Frame
TextButton.Size = UDim2.new(0, 280, 0, 40)
TextButton.Position = UDim2.new(0, 10, 0, 40)
TextButton.Text = "Get Key (Copy Link)"
TextButton.MouseButton1Click:Connect(v14)
TextBox.Parent = Frame
TextBox.Size = UDim2.new(0, 280, 0, 30)
TextBox.Position = UDim2.new(0, 10, 0, 90)
TextBox.PlaceholderText = "Enter Key Here"
TextButton2.Parent = Frame
TextButton2.Size = UDim2.new(0, 280, 0, 40)
TextButton2.Position = UDim2.new(0, 10, 0, 130)
TextButton2.Text = "Check Key"
TextButton2.MouseButton1Click:Connect(function()
	v18(TextBox.Text)
end)
task.spawn(function()
	local v26 = v13()

	if not v26 then
		return
	end

	onMessage("Using saved key... Verifying now.")
	v18(v26)
end)
