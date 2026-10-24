-- This file was generated at discord.gg/syncrypt

if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
	game:GetService("CoreGui").ToraScript:Destroy()
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v2 = lib:CreateWindow("Bike For Egg!")

task.spawn(function()
	local now = tick()
	local t1 = { "%H", "%M", "%S" }

	while task.wait() do
		if tick() - now >= 1 then
			now = tick()
			os.date(table.concat(t1, ":"))
		end
	end
end)

local function v5(p1)
	local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
	local pairs_ = pairs
	local v8, v9, v10 = pairs_(workspace.AreaEggSlotsClient:GetDescendants())
	local v11 = -math.huge
	local v12 = nil

	while true do
		local v13

		v10, v13 = v8(v9, v10)

		if not v10 then
			break
		end

		local isBasePart

		if v13.Name == "Hitbox" then
			isBasePart = v13:IsA("BasePart")
		else
			isBasePart = false
		end

		if isBasePart then
			local v15 = p1 == "Far"

			if v15 then
				v15 = v13.Position.X
			end

			local Y = v15 or v13.Size.Y

			if v11 < Y then
				v12 = v13
				v11 = Y
				pairs_ = v11

				local v17 = v11

				v11 = pairs_
				v17 = pairs_
			end
		end
	end

	if not v12 then
		return
	end

	HumanoidRootPart.CFrame = v12.CFrame
	task.wait(0.2)

	local EggsRequestAreaEggCarry = game:GetService("ReplicatedStorage").Network:FindFirstChild("Eggs: RequestAreaEggCarry")
	local Parent = v12.Parent

	EggsRequestAreaEggCarry.InvokeServer(EggsRequestAreaEggCarry, {
		Uid = Parent.Name
	})
	task.wait(0.2)
	HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame
end

v2.AddButton(v2, {
	text = "Get Last Egg",
	flag = "button",
	callback = function()
		v5("Far")
	end
})
v2.AddButton(v2, {
	text = "Get Big Egg",
	flag = "button",
	callback = function()
		v5("Big")
	end
})

local game_ = game
local UserId = game_.GetService(game_, "Players").LocalPlayer.UserId
local Parent = nil

for _, descendant in pairs(workspace.Plots:GetDescendants()) do
	local v25 = descendant.Name == "PlayerIcon"

	if v25 then
		v25 = descendant.Image == "rbxthumb://type=AvatarHeadShot&id=" .. UserId .. "&w=48&h=48"
	end

	if v25 then
		Parent = descendant.Parent.Parent.Parent.Parent

		break
	end
end

v2.AddToggle(v2, {
	text = "Auto Place",
	flag = "toggle",
	state = false,
	callback = function(p2)
		_G.Place = p2
		print("Place: ", p2)

		if not p2 then
			return
		end

		Place()
	end
})

function Place()
	local function v26()
		_G.Place = true

		while _G.Place do
			wait()

			local function v27()
				local Character = game:GetService("Players").LocalPlayer.PlayerGui.DropHeldEgg.Enabled == false and game:GetService("Players").LocalPlayer.Character

				if not Character then
					wait(0.2)

					return
				end

				local GetChildren = Character.GetChildren

				for _, v in pairs(GetChildren(Character)) do
					local isTool = v:IsA("Tool")

					if isTool then
						isTool = v.Name:find("Egg", 1, true)
					end

					if isTool then
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart then
							return
						end

						local CFrame_ = HumanoidRootPart.CFrame

						HumanoidRootPart.CFrame = Parent.PlotSign.CFrame
						task.wait(0.2)

						local t2 = {
							{
								LocalCFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.5707963705063, 0),
								Uid = v:GetAttribute("UID")
							}
						}

						game:GetService("ReplicatedStorage").Network:FindFirstChild("Eggs: RequestPlaceEgg"):InvokeServer(unpack(t2))
						task.wait(0.2)
						HumanoidRootPart.CFrame = CFrame_

						break
					end
				end

				wait(0.2)
			end

			pcall(v27)
		end
	end

	spawn(v26)
end

v2.AddToggle(v2, {
	text = "Auto Hatch",
	flag = "toggle",
	state = false,
	callback = function(p3)
		_G.Hatch = p3
		print("Hatch: ", p3)

		if not p3 then
			return
		end

		Hatch()
	end
})

function Hatch()
	spawn(function()
		_G.Hatch = true

		while _G.Hatch do
			wait()
			pcall(function()
				local pairs_ = pairs
				local workspace_ = workspace

				for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
					local v40 = descendant.Name == "ReadyEggPulseHighlight"

					if v40 then
						v40 = string.find(descendant.Parent.Name, game.Players.LocalPlayer.UserId)
					end

					if v40 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = descendant.Parent:GetPivot("WorldPivot") * CFrame.new(0, 5, 0)
						game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
						wait(0.1)
						game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
					end
				end

				wait()
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Equip Best",
	flag = "toggle",
	state = false,
	callback = function(p4)
		_G.Equip = p4
		print("Equip: ", p4)

		if not p4 then
			return
		end

		Equip()
	end
})

function Equip()
	spawn(function()
		_G.Equip = true

		while _G.Equip do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Network:FindFirstChild("Backpack: EquipBest"):InvokeServer()
				wait(5)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Auto Upgrade",
	flag = "toggle",
	state = false,
	callback = function(p5)
		_G.Upgrade = p5
		print("Upgrade: ", p5)

		if not p5 then
			return
		end

		Upgrade()
	end
})

function Upgrade()
	local function v41()
		_G.Upgrade = true

		while _G.Upgrade do
			local function v42()
				if Parent.PlotUpgrade.Sign.CanUpgrade.Enabled == true then
					game:GetService("ReplicatedStorage").Network:FindFirstChild("Plots: RequestBaseUpgrade"):FireServer()
				end

				if Parent.TreadmillUpgrade.Sign.CanUpgrade.Enabled ~= true then
					wait(1)

					return
				end

				local Upgrade_ = Parent.TreadmillUpgrade.Sign.SurfaceGui.Frame.Upgrade

				for _, v in ipairs(getconnections(Upgrade_.Activated)) do
					v:Fire()
				end

				wait(1)
			end

			wait()
			pcall(v42)
		end
	end

	spawn(v41)
end

local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
local v47, v48, v49 = pairs(workspace.__OBJECTS.Areas.GuardAreas:GetChildren())
local t3 = {}

while true do
	local v51

	v49, v51 = v47(v48, v49)

	if not v49 then
		break
	end

	if v51:IsA("Model") then
		table.insert(t3, {
			Name = v51.Name,
			Distance = (v51.WorldPivot.Position - HumanoidRootPart.Position).Magnitude
		})
	end
end

table.sort(t3, function(p6, p7)
	return p6.Distance < p7.Distance
end)

local t4 = {}

for _, v in ipairs(t3) do
	local Name = v.Name

	table.insert(t4, Name)
end

v2:AddList({
	text = "Teleport",
	flag = "list",
	value = "==Select Zone==",
	values = t4,
	callback = function(p8)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.__OBJECTS.Areas.GuardAreas[p8].ClosestExitPoint.CFrame
	end
})
v2.AddButton(v2, {
	text = "Goto SafeZone",
	flag = "button",
	callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame
	end
})
v2.AddLabel(v2, {
	text = "YouTube: Tora IsMe"
})
lib:Init()
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
	fireproximityprompt(prompt)
end)
