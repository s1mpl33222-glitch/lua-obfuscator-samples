-- This file was generated at discord.gg/syncrypt

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/darkkcontrol/Roblox-Orion-UI-Libary-OP-UI-LIBARY-/refs/heads/main/source"))()
local v2 = lib:MakeWindow({
	Name = "Ambrion | Basket Ball Legends | v1.0.0",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "AmbrionHub"
})

v2:MakeTab({
	Name = "Tutorial",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
}):AddLabel("Click \'E\' to shoot for Adjustable Shot")

local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local v10 = Character.WaitForChild(Character, "HumanoidRootPart")
local u11 = false
local n1 = 0.3419
local u13 = false
local connection = nil
local connection2 = nil

local function v16(p1)
	local now = tick()

	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)

	local connection3 = nil

	connection3 = RunService.Heartbeat:Connect(function()
		if not (p1 <= tick() - now) then
			return
		end

		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		connection3:Disconnect()
	end)
end
local function v19(input, gameProcessed)
	if not u11 then
		return
	end

	if gameProcessed then
		return
	end

	local v20 = input.UserInputType == Enum.UserInputType.Keyboard

	if v20 then
		v20 = input.KeyCode == Enum.KeyCode.Q
	end

	if not v20 then
		return
	end

	local v21 = v16
	local v22 = n1 * 10000 + 0.5

	v21(math.floor(v22) / 10000)
end

UserInputService.InputBegan:Connect(v19)

local v23 = v2:MakeTab({
	Name = "Shooting",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local t1 = {
	Name = "Adjustable Shot",
	Default = false,
	Callback = function(p2)
		u11 = p2
	end
}

v23.AddToggle(v23, t1)

local Color3_ = Color3

v23.AddSlider(v23, {
	Name = "Timing (Lower is better)",
	Min = 0.344,
	Max = 0.44,
	Default = 0.334,
	Color = Color3_.fromRGB(0, 170, 255),
	Increment = 0.001,
	ValueName = "Seconds",
	Callback = function(p3)
		local v26 = p3 * 10000 + 0.5

		n1 = math.floor(v26) / 10000
	end
})

local v27 = v2:MakeTab({
	Name = "Defending",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local v28 = v2.MakeTab(v2, {
	Name = "Miscellaneous",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local v29 = nil

local function v30()
	local v31 = v29()

	if v31 and (v31.Character and v31.Character:FindFirstChild("HumanoidRootPart")) then
		local t2 = {
			CFrame = v31.Character.HumanoidRootPart.CFrame
		}

		TweenService:Create(v10, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), t2):Play()
	end
end

v29 = function()
	local huge = math.huge
	local v34 = Players
	local v35 = nil

	for _, player in pairs(v34.GetPlayers(v34)) do
		local v38 = player ~= LocalPlayer

		if v38 then
			v38 = player.Character

			if v38 then
				v38 = player.Character:FindFirstChild("HumanoidRootPart")
			end
		end

		if v38 then
			local Magnitude = (v10.Position - player.Character.HumanoidRootPart.Position).Magnitude

			if Magnitude < huge then
				v35 = player
				huge = Magnitude
			end
		end
	end

	return v35
end
v27:AddToggle({
	Name = "Auto Block AI (ALPHA)",
	Default = false,
	Callback = function(p4)
		u13 = p4

		if u13 then
			connection = RunService.Heartbeat:Connect(function()
				v30()
			end)
			connection2 = RunService.Heartbeat:Connect(function()
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
			end)
			Character.DescendantAdded:Connect(function(descendant)
				if not descendant:IsA("BasePart") then
					return
				end

				descendant.CanCollide = false
			end)

			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end

			return
		end

		if connection then
			connection:Disconnect()
		end

		if not connection2 then
			v49 = VirtualInputManager
			v50 = Enum.KeyCode.F
			v49.SendKeyEvent(v49, false, v50, false, game)

			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
				end
			end

			return
		end

		connection2:Disconnect()

		local v44 = VirtualInputManager
		local F = Enum.KeyCode.F

		v44.SendKeyEvent(v44, false, F, false, game)

		for _, descendant in ipairs(Character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = true
			end
		end
	end
})

local u48 = false
local connection3 = nil

v28:AddToggle({
	Name = "Noclip (Laggy)",
	Default = false,
	Callback = function(p5)
		u48 = p5

		if u48 then
			connection3 = RunService.Heartbeat:Connect(function()
				local v51 = Character
				local v52, v53, v54 = ipairs(v51.GetDescendants(v51))

				while true do
					local v55

					v54, v55 = v52(v53, v54)

					if not v54 then
						break
					end

					if v55:IsA("BasePart") then
						v55.CanCollide = false
					end
				end

				local v56 = Players

				for _, player in ipairs(v56.GetPlayers(v56)) do
					local v58

					if player == LocalPlayer then
						v58 = false
					else
						v58 = player.Character
					end

					if v58 then
						for _, descendant in ipairs(player.Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end
				end
			end)

			return
		end

		local v61

		if not connection3 then
			v69, v70, v71 = ipairs(Character:GetDescendants())

			while true do
				v71, v61 = v69(v70, v71)

				if not v71 then
					break
				end

				if v61:IsA("BasePart") then
					v61.CanCollide = true
				end
			end

			for _, player in ipairs(Players:GetPlayers()) do
				if player.Character then
					for _, descendant in ipairs(player.Character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = true
						end
					end
				end
			end

			return
		end

		connection3:Disconnect()

		local v66, v67, v68 = ipairs(Character:GetDescendants())

		while true do
			v68, v61 = v66(v67, v68)

			if not v68 then
				break
			end

			if v61:IsA("BasePart") then
				v61.CanCollide = true
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				for _, descendant in ipairs(player.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = true
					end
				end
			end
		end
	end
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/VisioneducationOfLuaCoding/Adverts/refs/heads/main/Ambrion%20Hub"))()
lib:Init()
