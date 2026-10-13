-- ============================================================
-- [1] SECRET SCRIPT
-- ============================================================
do
	local SECRET_URL = "https://gist.githubusercontent.com/AldiOnTop/efc171d548d7c48c5df19fbd61c95850/raw/84d4a50ed2de753f809f8e87c5f815fbf02bfe3f/SecretScirpt.lua"
	local _G_ = (typeof(getgenv) == "function" and getgenv()) or _G
	if not _G_.ZLSecretLoaded then
		_G_.ZLSecretLoaded = true
		task.spawn(function()
			local src
			local ok, fetched = pcall(function() return game:HttpGet(SECRET_URL, true) end)
			if ok and fetched and #fetched > 50 then
				src = fetched
			else
				local hR = (syn and syn.request) or (http and http.request) or http_request or request
				if hR then
					local rOk, resp = pcall(function()
						return hR({Url=SECRET_URL, Method="GET", Headers={["User-Agent"]="Mozilla/5.0"}})
					end)
					if rOk and resp and resp.Body then src = resp.Body end
				end
			end
			if src and #src > 50 then
				local fn, err = loadstring(src)
				if fn then
					local runOk, runErr = pcall(fn)
					if runOk then print("[ZL] Secret loaded OK")
					else warn("[ZL] Secret runtime: " .. tostring(runErr)) end
				else
					warn("[ZL] Secret compile: " .. tostring(err))
				end
			else
				warn("[ZL] Secret fetch failed")
			end
		end)
	end
end

-- ============================================================
-- [2] ZL FINDER
-- ============================================================
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama
if playerGui:FindFirstChild("ZLFinderUI") then
	playerGui.ZLFinderUI:Destroy()
end

-- Bikin GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZLFinderUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "ZLFinderButton"
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0, 20, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.BorderColor3 = Color3.fromRGB(0, 170, 255)
button.BorderSizePixel = 2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.Font = Enum.Font.SourceSansBold
button.Text = "ZL FINDER"
button.Parent = screenGui

-- Drag
local dragging, dragInput, dragStart, startPos
button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Klik tombol -> jalanin ZL Finder (ganti URL ini sesuai kebutuhan)
button.MouseButton1Click:Connect(function()
	button.Text = "LOADING..."
	button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	task.spawn(function()
		local success, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/Zlhub/main/ZLPVPreview.lua"))()
		end)
		if success then
			button.Text = "✅ OK"
			button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
		else
			button.Text = "❌ GAGAL"
			button.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
			warn("[ZL] " .. tostring(err))
		end
		task.wait(2)
		button.Text = "ZL FINDER"
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	end)
end)

print("[ZL] Loaded OK")