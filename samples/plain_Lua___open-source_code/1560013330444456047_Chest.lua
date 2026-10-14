--[[ 
Safe Simulation: GravityHub Status + Config + Simulated Farm Loop
- An toàn: KHÔNG teleport, KHÔNG noclip, KHÔNG hop server thật, KHÔNG read/write file.
- Mục đích: test UI, config, trạng thái (Chest Bypass / Stop Item / Hopping Server).
- Dùng trong Studio hoặc client để verify logic UI/config trước khi tích hợp phần khác.
--]]

-- =====================
-- [0] Defaults & config
-- =====================
-- You can set getgenv().GravityHub before loading this script. Example:
-- getgenv().GravityHub = { ["Team"] = "Marines", ["Farm Chest"] = true, ["Stop Item"] = true, ["Hopping Server"] = true }

local cfg = getgenv().GravityHub or {}
-- safe defaults if missing
local CFG = {
	Team = cfg["Team"] or "Marines",
	["Farm Chest"] = (cfg["Farm Chest"] == nil) and true or cfg["Farm Chest"],
	["Stop Item"] = (cfg["Stop Item"] == nil) and true or cfg["Stop Item"],
	["Hopping Server"] = (cfg["Hopping Server"] == nil) and true or cfg["Hopping Server"],
}

-- =====================
-- [1] Services & locals
-- =====================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- =====================
-- [2] Clear previous UI
-- =====================
if CoreGui:FindFirstChild("Status_UI") then
	CoreGui.Status_UI:Destroy()
end

-- =====================
-- [3] Create Status UI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "Status_UI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 70)
frame.Position = UDim2.new(0.5, 0, 0.07, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 220, 70)
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 230, 120)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local statusText = Instance.new("TextLabel", frame)
statusText.Size = UDim2.new(1, -10, 0.5, 0)
statusText.Position = UDim2.new(0.5, 0, 0, 5)
statusText.AnchorPoint = Vector2.new(0.5, 0)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 18
statusText.TextColor3 = Color3.fromRGB(255,230,120)
statusText.Text = "Gravity Hub - Auto Chest"

local itemText = Instance.new("TextLabel", frame)
itemText.Size = UDim2.new(1, -10, 0.5, 0)
itemText.Position = UDim2.new(0.5, 0, 0.5, 0)
itemText.AnchorPoint = Vector2.new(0.5, 0)
itemText.BackgroundTransparency = 1
itemText.Font = Enum.Font.Gotham
itemText.TextSize = 16
itemText.TextColor3 = Color3.fromRGB(255,230,120)
itemText.Text = "Status : Chest Bypass" -- initial

-- small helper: fade text when changing (so it's visually smooth)
local function setItemText(newText)
	-- fade out -> change -> fade in
	pcall(function()
		local out = TweenService:Create(itemText, TweenInfo.new(0.18), {TextTransparency = 1})
		local inn = TweenService:Create(itemText, TweenInfo.new(0.18), {TextTransparency = 0})
		out:Play(); out.Completed:Wait()
		itemText.Text = newText
		inn:Play()
	end)
end

-- subtle border glow loop (only color tween, not touching status text)
task.spawn(function()
	while true do
		local a = TweenService:Create(stroke, TweenInfo.new(1.2), {Color = Color3.fromRGB(255,255,180)})
		local b = TweenService:Create(stroke, TweenInfo.new(1.2), {Color = Color3.fromRGB(255,200,60)})
		a:Play(); a.Completed:Wait()
		b:Play(); b.Completed:Wait()
	end
end)

-- =====================
-- [4] Simulation helpers
-- =====================
-- NOTE: This simulation DOES NOT teleport or noclip.
-- It only simulates detecting chests and picking them up.

-- find parts named "Chest" in workspace (safe read)
local function collectChestParts()
	local list = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower():match("chest") then
			table.insert(list, obj)
		end
	end
	return list
end

-- check backpack/character for rare items (safe read only)
local function hasRareItem()
	-- check both backpack and character
	local bp = LocalPlayer:FindFirstChild("Backpack")
	local char = LocalPlayer.Character
	local function check(container)
		if not container then return false end
		for _, c in pairs(container:GetChildren()) do
			local n = c.Name
			if n == "God's Chalice" or n == "Sweet Chalice" or n == "Fist of Darkness" then
				return true
			end
		end
		return false
	end
	return check(bp) or check(char)
end

-- =====================
-- [5] Simulated farm loop (safe)
-- =====================
-- Behavior:
--  - If cfg["Farm Chest"] == false -> do nothing
--  - While farming: set status "Chest Bypass"
--  - If rare item detected and cfg["Stop Item"] -> set "Stop Item" and stop farming
--  - If no chests found and cfg["Hopping Server"] -> set "Hopping Server" and simulate hop (no real hop)
--  - Plays nice delays for UI visibility

local Farming = false

local function simulateHop()
	-- simulated hop: just show status, wait, then re-scan (no actual teleport or file ops)
	setItemText("Status : Hopping Server")
	-- simulate server change delay
	task.wait(2)
end

local function startSimulatedFarm()
	if not CFG["Farm Chest"] then
		setItemText("Status : Chest Bypass")
		return
	end
	if Farming then return end
	Farming = true

	task.spawn(function()
		while Farming do
			-- check rare item
			if CFG["Stop Item"] and hasRareItem() then
				-- stop farming
				setItemText("Status : Stop Item")
				Farming = false
				break
			end

			local chests = collectChestParts()
			if #chests > 0 then
				-- simulate "teleport & pick" by marking UI and removing one chest from list (safe)
				setItemText("Status : Chest Bypass")
				-- to simulate progress, we pretend to "collect" the first chest
				-- (we do NOT modify workspace parts; just wait briefly to represent action)
				task.wait(0.25) -- simulate instant pick
			else
				-- no chests -> simulate hop if allowed
				if CFG["Hopping Server"] then
					setItemText("Status : Hopping Server")
					-- simulated hop
					simulateHop()
					-- after simulated hop, continue loop to rescan
					task.wait(0.5)
				else
					-- nothing to do, just idle
					setItemText("Status : Chest Bypass")
					task.wait(1)
				end
			end
			task.wait(0.1)
		end
	end)
end

local function stopSimulatedFarm()
	Farming = false
end

-- =====================
-- [6] Auto start on load if config allows
-- =====================
-- Start farm automatically if Farm Chest enabled in config
if CFG["Farm Chest"] then
	setItemText("Status : Chest Bypass")
	startSimulatedFarm()
else
	setItemText("Status : Chest Bypass")
end

-- =====================
-- [7] Expose control API (optional)
-- =====================
-- You can control from outside (safe) using:
-- getgenv().GravityHubControls = { Start = function() ... end, Stop = function() ... end }
getgenv().GravityHubControls = {
	Start = startSimulatedFarm,
	Stop = stopSimulatedFarm,
	SetConfig = function(newCfg)
		-- merge new config keys safely
		if type(newCfg) ~= "table" then return end
		for k,v in pairs(newCfg) do
			if CFG[k] ~= nil then CFG[k] = v end
		end
	end,
	GetConfig = function() return CFG end,
}

-- End of safe simulation script
