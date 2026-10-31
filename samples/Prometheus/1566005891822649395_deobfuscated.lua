-- This file was generated at discord.gg/syncrypt

queue_on_teleport("if not game:IsLoaded() then\n    game.Loaded:Wait()\nend\n\nlocal Players = game:GetService(\"Players\")\nwhile not Players.LocalPlayer do\n    task.wait()\nend\n\n-- Allow workspace objects and remotes to finish replicating after the teleport.\ntask.wait(5)\n\nlocal source = game:HttpGet(\"https://raw.githubusercontent.com/AstroPublic/Slap-battles/refs/heads/main/main\")\nlocal chunk, compileError = loadstring(source)\nif not chunk then\n    warn(\"Rejoin script compile failed: \" .. tostring(compileError))\nelse\n    local ok, runtimeError = pcall(chunk)\n    if not ok then\n        warn(\"Rejoin script runtime failed: \" .. tostring(runtimeError))\n    end\nend\n")
getgenv().enabled = true
getgenv().maxHits = 15
getgenv().hitInterval = 0.7
getgenv().followDistance = 5

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local game_ = game
local v4 = game_.GetService(game_, "TeleportService")
local LocalPlayer = Players.LocalPlayer

GuiService.ErrorMessageChanged:Connect(function(p1)
	if p1 then
		p1 = p1 ~= ""
	end

	if not (p1 and LocalPlayer) then
		return
	end

	wait()
	v4:Teleport(game.PlaceId, LocalPlayer)
end)

local Players2 = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer2 = Players2.LocalPlayer
local u10 = nil
local boundary = workspace.Terrain:FindFirstChild("boundary")

if not boundary then
	boundary = Instance.new("Part")
	boundary.Name = "boundary"
	boundary.Parent = workspace.Terrain
end

boundary.Size = Vector3.new(250, 100, 220)
boundary.CFrame = CFrame.new(0, 0, 0)
boundary.CanCollide = false
boundary.CanTouch = false
boundary.CanQuery = false
boundary.CastShadow = false
boundary.Material = Enum.Material.ForceField
boundary.Transparency = 0
boundary.Anchored = true

local Lobby = workspace:FindFirstChild("Lobby")
local bound2

if Lobby then
	bound2 = Lobby:FindFirstChild("bound2")
else
	bound2 = Lobby
end

local v14

if Lobby then
	v14 = not bound2
else
	v14 = Lobby
end

if v14 then
	bound2 = Instance.new("Part")
	bound2.Name = "bound2"
	bound2.Parent = Lobby
end

if bound2 then
	bound2.Size = Vector3.new(50, 10, 50)
	bound2.CFrame = CFrame.new(-1299.06494, 327.788727, -12.2051487)
	bound2.Anchored = true
	bound2.CanCollide = false
	bound2.CanTouch = false
	bound2.CanQuery = false
	bound2.CastShadow = false
	bound2.Material = Enum.Material.ForceField
	bound2.Transparency = 0
end

local function v15(p2)
	if not (p2 and (boundary and boundary.Parent)) then
		return false
	end

	local v16 = boundary.CFrame:PointToObjectSpace(p2.Position)
	local v17 = boundary.Size / 2
	local X = v16.X
	local v19 = math.abs(X) <= v17.X

	if not v19 then
		return v19
	end

	v19 = math.abs(v16.Y) <= v17.Y

	if not v19 then
		return v19
	end

	local Z = v16.Z

	v19 = math.abs(Z) <= v17.Z

	return v19
end
local function v21(p3)
	if not (p3 and (bound2 and bound2.Parent)) then
		return false
	end

	local v22 = bound2.CFrame:PointToObjectSpace(p3.Position)
	local v23 = bound2.Size / 2
	local X = v22.X
	local v25 = math.abs(X) <= v23.X

	if not v25 then
		return v25
	end

	v25 = math.abs(v22.Y) <= v23.Y

	if not v25 then
		return v25
	end

	local Z = v22.Z

	v25 = math.abs(Z) <= v23.Z

	return v25
end
local function v27(p4)
	local Character = LocalPlayer2.Character
	local huge, v30, v31, v32, Character2, Magnitude

	if Character then
	elseif Character then
		huge = math.huge
		v30 = Players2
		v31 = nil

		for _, player in ipairs(v30.GetPlayers(v30)) do
			if player == LocalPlayer2 then
				v32 = false
			else
				v32 = player ~= p4
			end

			if v32 then
				Character2 = player.Character

				if Character2 then
					Character2 = Character2:FindFirstChild("HumanoidRootPart")
				end

				if Character2 then
					Magnitude = (Character2.Position - Character.Position).Magnitude

					if Magnitude < huge then
						v31 = player
						huge = Magnitude
					end
				end
			end
		end

		return v31
	else
		return nil
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		huge = math.huge
		v30 = Players2
		v31 = nil

		for _, player in ipairs(v30.GetPlayers(v30)) do
			if player == LocalPlayer2 then
				v32 = false
			else
				v32 = player ~= p4
			end

			if v32 then
				Character2 = player.Character

				if Character2 then
					Character2 = Character2:FindFirstChild("HumanoidRootPart")
				end

				if Character2 then
					Magnitude = (Character2.Position - Character.Position).Magnitude

					if Magnitude < huge then
						v31 = player
						huge = Magnitude
					end
				end
			end
		end

		return v31
	else
		return nil
	end
end

local u39 = nil

local function v40()
	local Character = LocalPlayer2.Character

	if Character then
		for _, child in ipairs(Character:GetChildren()) do
			if child:IsA("Tool") then
				return child.Name
			end
		end
	end

	local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

	if not Backpack then
		return nil
	end

	local GetChildren = Backpack.GetChildren

	for _, v in ipairs(GetChildren(Backpack)) do
		if v:IsA("Tool") then
			return v.Name
		end
	end

	return nil
end
local function v48(p5)
	if u39 == p5 then
		return
	end

	u39 = p5
	warn(p5)
end

u39 = nil

local function v49()
	local v50 = v40()

	if v50 then
		local v51 = v50 == "Default" and "b" or false or (v50 == "Lag" and true or (v50 == "Stick" and "GeneralHit" or v50 .. "Hit"))
		local t1 = { v51, v50 .. "Hit" }

		for _, v in ipairs(t1) do
			local v55 = ReplicatedStorage:FindFirstChild(v)
			local isRemoteEvent

			if v55 then
				isRemoteEvent = v55:IsA("RemoteEvent")
			else
				isRemoteEvent = v55
			end

			if isRemoteEvent then
				return v55
			end

			for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
				local isRemoteEvent2

				if descendant.Name == v then
					isRemoteEvent2 = descendant:IsA("RemoteEvent")
				else
					isRemoteEvent2 = false
				end

				if isRemoteEvent2 then
					return descendant
				end
			end
		end

		v48("Aura: no RemoteEvent found for Tool \'" .. v50 .. "\'. Tried \'" .. v51 .. "\' and \'" .. v50 .. "Hit\'.")

		return nil
	else
		v48("Aura: no Tool found in Character or Backpack.")

		return nil
	end
end

RunService.Heartbeat:Connect(function()
	u10 = v27()
end)

local CFrame_ = nil
local n1 = 0
local n2 = 0
local n3 = 0

local function v64(p6, p7)
	local Character = LocalPlayer2.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	if p6 then
		if p6.Parent ~= Character then
			p6 = false
		end
	end

	local v68 = p6 or HumanoidRootPart

	if getgenv().enabled ~= true then
		return
	end

	local v69 = p7 or CFrame_

	if v68 and v69 then
		v68.CFrame = v69
	end

	if v68 then
		v68.AssemblyLinearVelocity = Vector3.zero
		v68.AssemblyAngularVelocity = Vector3.zero
	end

	local v70

	if Humanoid then
		v70 = Humanoid.Health > 0
	else
		v70 = Humanoid
	end

	if not v70 then
		return
	end

	Humanoid.Sit = false
	Humanoid.PlatformStand = false
	Humanoid.AutoRotate = true
	Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

local u71 = nil
local u72 = nil
local u73 = nil
local u74 = nil

CFrame_ = nil

local function v75()
	local v76 = u74
	local v77 = CFrame_

	v64(v76, v77)
	task.defer(function()
		if not LocalPlayer2.Character then
			return
		end

		v64(v76, v77)
	end)
	n2 = os.clock() + getgenv().hitInterval
	u73 = u71 or u73
	u71 = nil
	u72 = nil
	u74 = nil
	CFrame_ = nil
	n3 = 0
end

getgenv().aura = true

local v78 = n2
local v79 = u74
local v80 = u73
local v81 = n3
local v82 = u72

while true do
	task.wait()

	local Character = LocalPlayer2.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	if HumanoidRootPart then
		HumanoidRootPart = v21(HumanoidRootPart)
	end

	if getgenv().enabled ~= true then
		HumanoidRootPart = false
	end

	if HumanoidRootPart then
		local Teleport1

		if Lobby then
			Teleport1 = Lobby:FindFirstChild("Teleport1")
		else
			Teleport1 = Lobby
		end

		local isBasePart

		if Teleport1 then
			isBasePart = Teleport1:IsA("BasePart")
		else
			isBasePart = Teleport1
		end

		if isBasePart then
			v75()
			Character:PivotTo(Teleport1.CFrame)
		end
	end

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if Humanoid then
		Humanoid = Humanoid.Health > 0

		if Humanoid then
			if Character then
				Humanoid = Character:IsA("BasePart")

				if Humanoid then
					Humanoid = v15(Character)
				end
			else
				Humanoid = Character
			end
		end
	end

	if getgenv().enabled == true then
		if Humanoid then
			getgenv().aura = true

			local v88 = not u71

			if v88 then
				v88 = v78 <= os.clock()
			end

			if v88 then
				u71 = v27(v80)

				local Character2 = u71

				if Character2 then
					Character2 = u71.Character
				end

				u72 = Character2

				if u71 then
					u74 = Character
					CFrame_ = Character.CFrame
					n3 = 0
					n1 = os.clock() + getgenv().hitInterval
					v79 = u74
					v81 = n3
					v82 = u72
				else
					v82 = u72
				end
			end

			if u71 then
				if v82 then
					local HumanoidRootPart2 = v82:FindFirstChild("HumanoidRootPart")
				end

				if u71.Parent ~= Players2 or (u71.Character ~= v82 or (Character ~= v79 or not (v91 and v91:IsA("BasePart")))) then
					v75()
				else
					Character.CFrame = v91.CFrame * CFrame.new(0, 0, getgenv().followDistance)

					if not v15(Character) then
						v75()
					end
				end
			end

			local v92 = u71 or v27()
			local Character2

			if v92 then
				Character2 = v92.Character
			else
				Character2 = v92
			end

			if Character2 then
				Character2 = Character2:FindFirstChild("Head")
			end

			local v93 = v49()
			local v94 = n1 <= os.clock()

			if v94 then
				if v93 then
					if v92 then
						v92 = v92.Parent == Players2

						if v92 then
							if Character2 then
								v92 = Character2:IsA("BasePart")
							else
								v92 = Character2
							end
						end
					end
				else
					v92 = v93
				end
			else
				v92 = v94
			end

			if v92 then
				v93:FireServer(Character2)
				n1 = os.clock() + getgenv().hitInterval

				if u71 then
					n3 = v81 + 1
					v81 = n3
				end
			end

			local v95 = u71

			if v95 then
				v95 = getgenv().maxHits <= v81
			end

			if v95 then
				v75()
			end
		else
			getgenv().aura = false
			v75()
		end
	else
		getgenv().aura = false
		u71 = nil
		u72 = nil
		u74 = nil
		CFrame_ = nil
		u73 = nil
		n3 = 0
		n2 = 0
		v78 = n2
		v79 = u74
		v80 = u73
		v81 = n3
		v82 = u72
	end
end
