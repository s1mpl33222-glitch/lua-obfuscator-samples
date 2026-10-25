 --// Box ESP (ปรับแต่งสีตามเลือด)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

-- ฟังก์ชันเลือกสีตามเลือด
local function getHealthColor(health)
	if health >= 60 then
		return Color3.fromRGB(0, 255, 0) -- เขียว
	elseif health >= 30 then
		return Color3.fromRGB(255, 255, 0) -- เหลือง
	else
		return Color3.fromRGB(255, 0, 0) -- แดง
	end
end

-- ฟังก์ชันสร้างกล่อง
local function createBox()
	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Transparency = 1
	box.Filled = false
	box.Visible = false
	return box
end

-- สร้างกล่องให้ผู้เล่นแต่ละคน
local boxes = {}
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= localPlayer then
		boxes[player] = createBox()
	end
end

Players.PlayerAdded:Connect(function(player)
	if player ~= localPlayer then
		boxes[player] = createBox()
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if boxes[player] then
		boxes[player]:Remove()
		boxes[player] = nil
	end
end)

-- อัปเดตกล่องทุกเฟรม
RunService.RenderStepped:Connect(function()
	for player, box in pairs(boxes) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
			local root = character.HumanoidRootPart
			local hum = character.Humanoid
			local pos, onScreen = camera:WorldToViewportPoint(root.Position)

			if onScreen and hum.Health > 0 then
				local headPos = camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
				local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
				local height = math.abs(headPos.Y - legPos.Y)
				local width = height / 2

				box.Size = Vector2.new(width, height)
				box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
				box.Color = getHealthColor(hum.Health)
				box.Visible = true
			else
				box.Visible = false
			end
		else
			box.Visible = false
		end
	end
end)

-- ส่วน Highlight ESP
local plr = game.Players.LocalPlayer
_G.ESP = true

while _G.ESP do
	wait(1)
	pcall(function()
		for _, v in pairs(game.Players:GetPlayers()) do
			if v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") then
				local hum = v.Character.Humanoid
				local color = getHealthColor(hum.Health)

				local hl = v.Character:FindFirstChild("ESP") or Instance.new("Highlight")
				hl.Name = "ESP"
				hl.FillColor = color
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.Parent = v.Character
			end
		end
	end)
end