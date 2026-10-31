-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("VirtualInputManager")
game:GetService("UserInputService")

local Workspace = game.Workspace
local DataService = ReplicatedStorage.Modules.DataService
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local v9 = Character.WaitForChild(Character, "HumanoidRootPart")
local Function = getconnections(DataService.DescendantAdded)[1].Function
local v11 = getupvalue(Function, 1)
local next_ = next
local v13, key = getupvalue(getupvalue(Function, 2), 1)
local t1 = {}
local t2 = {}

while true do
	local v17

	key, v17 = next_(v13, key)

	if not key then
		break
	end

	if v17:sub(1, 2) == "F_" then
		v17 = v17:sub(3) or v17
	end

	t1[v17] = v11[key]
end

local function v18(p1, p2)
	repeat
		local v19 = p1:FindFirstChild(p2)

		task.wait(0.2)
	until v19

	return v20
end

local modules = v18(LocalPlayer:WaitForChild("PlayerScripts"), "Modules")
local HUDHandler = require(v18(modules, "_UI"):WaitForChild("HUDHandler"))

local function v22()
	local NPCOrigins = Workspace._game.WinterActivityArea.NPCOrigins

	if NPCOrigins then
		local GetChildren = NPCOrigins.GetChildren
		local huge = math.huge
		local v26 = nil

		for _, v in ipairs(GetChildren(NPCOrigins)) do
			if v:IsA("BasePart") then
				local Magnitude = (v9.Position - v.Position).Magnitude

				if Magnitude < huge then
					v26 = v
					huge = Magnitude
				end
			end
		end

		return v26
	else
		return nil
	end
end

local _ = HUDHandler.HotbarUI
local v31 = nil

local function v32()
	local SnowballPileOrigins = Workspace._game.WinterActivityArea.SnowballPileOrigins

	if SnowballPileOrigins then
		local huge = math.huge
		local v35 = nil

		for _, child in ipairs(SnowballPileOrigins:GetChildren()) do
			local SnowballPile = child:FindFirstChild("SnowballPile")

			if SnowballPile then
				local v39 = v31(SnowballPile)

				if v39 then
					local Magnitude = (v9.Position - v39.Position).Magnitude

					if Magnitude < huge then
						v35 = SnowballPile
						huge = Magnitude
					end
				end
			end
		end

		return v35
	else
		return nil
	end
end
local function v41(p3, p4)
	local v42 = v31(p3)

	if not v42 then
		return false
	end

	local function v43()
		setthreadidentity(2)
		require(LocalPlayer.PlayerScripts.Modules.InteractionHandler):ShowMenu(p3, v42.Position, v42)
		setthreadidentity(7)

		local _interactUI = LocalPlayer.PlayerGui:FindFirstChild("_interactUI")

		if _interactUI then
			local Center = _interactUI:FindFirstChild("Center")

			if Center then
				local now = tick()
				local _ = tick() - now > 5

				while true do
					local GetChildren = Center.GetChildren

					for _, v in ipairs(GetChildren(Center)) do
						local isTextButton = v:IsA("TextButton")

						if isTextButton then
							isTextButton = v.Visible
						end

						if isTextButton and v.Text == p4 then
							firesignal(v.Activated)
							firesignal(v.MouseButton1Click)

							return true
						end

						local TextLabel = v:FindFirstChild("TextLabel")

						if TextLabel then
							TextLabel = TextLabel.Text == p4
						end

						if TextLabel then
							firesignal(v.Activated)
							firesignal(v.MouseButton1Click)

							return true
						end
					end

					task.wait(0.1)

					if tick() - now > 5 then
						return false
					end
				end

				return
			else
				return false
			end
		else
			return false
		end
	end

	local t3 = { pcall(v43) }
	local v54 = t3[2]

	if t3[1] then
		return v54
	end

	warn("[quickInteract] ERROR:", v54)

	return v54
end

v31 = function(p5)
	if p5 then
		if p5:IsA("Model") then
			return p5.PrimaryPart or p5:FindFirstChildWhichIsA("BasePart")
		elseif p5:IsA("BasePart") then
			return p5
		else
			return
		end
	else
		return nil
	end
end

local function v55(p6)
	local v56 = PathfindingService:CreatePath({
		AgentCanJump = false
	})

	v56:ComputeAsync(v9.Position, p6)

	local waypoints = v56:GetWaypoints()

	for _, waypoint in ipairs(waypoints) do
		Humanoid:MoveTo(waypoint.Position)
		Humanoid.MoveToFinished:Wait()
	end
end

local u60 = false

function t2.startSnowBall()
	if u60 then
		return
	end

	u60 = true
	task.spawn(function()
		while u60 do
			local v61 = v32()

			if v61 then
				v55(v31(v61).Position)
				v41(v61, "Take")
				task.wait(0.4)

				local v62 = v22()

				if v62 then
					local Position = v62.Position
					local Position2 = v9.Position
					local vector3 = Vector3.new(Position.X, Position2.Y, Position.Z)

					v9.CFrame = CFrame.lookAt(Position2, vector3)
					task.wait(0.2)
					t1.SnowballSkirmish:FireServer({})
				end

				task.wait(0.5)
			else
				task.wait(1)
			end
		end
	end)
end
function t2.stopSnowBall() end

return t2
