-- This file was generated at discord.gg/syncrypt

local chemistryModule = {}
local Players = game:GetService("Players")
local t1 = {
	value1 = game:GetService("PathfindingService"),
	value2 = game:GetService("ReplicatedStorage"),
	value3 = Players.LocalPlayer
}
local Character = t1.value3.Character or t1.value3.CharacterAdded:Wait()

t1.value4 = Character:WaitForChild("Humanoid")
t1.value5 = Character:WaitForChild("HumanoidRootPart")

local _ = t1.value3.PlayerScripts.Modules.SchoolHandler.PhysicsClassHandler

t1.value6 = false
t1.value7 = false
t1.value8 = false

local Workspace = game.Workspace

t1.value9 = nil
t1.value10 = Workspace
t1.value11 = nil

function t1.value12(p1, p2)
	local Unit = (p1.Position - t1.value5.Position).Unit
	local v8 = p1.Position - Unit * (p2 or 6)
	local v9 = t1.value1:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = false
	})

	v9:ComputeAsync(t1.value5.Position, v8)

	if v9.Status == Enum.PathStatus.Success then
		for _, v in ipairs(v9.GetWaypoints(v9)) do
			t1.value4:MoveTo(v.Position)

			if not t1.value4.MoveToFinished:Wait() then
				return false
			end

			if v.Action == Enum.PathWaypointAction.Jump then
				t1.value4.Jump = true
			end
		end

		return true
	else
		return false
	end
end

t1.value9 = (function()
	local Function = getconnections(t1.value2.Modules.DataService.DescendantAdded)[1].Function
	local v13 = getupvalue(Function, 1)
	local v14 = getupvalue(getupvalue(Function, 2), 1)
	local next_ = next
	local key = nil
	local t2 = {}

	while true do
		local v18

		key, v18 = next_(v14, key)

		if not key then
			break
		end

		if v18:sub(1, 2) == "F_" then
			v18 = v18:sub(3) or v18
		end

		t2[v18] = v13[key]
	end

	return t2
end)()

function t1.value13(p3, p4)
	local t3 = {}

	for _ = 1, #p3 do
		local v21 = math.random(1, #p3)

		while t3[v21] do
			v21 = math.random(1, #p3)
		end

		t3[v21] = true

		local scaleName = p3[v21].scaleName or p3[v21].stationName
		local v23 = nil

		local function v24()
			if p4 == "T_BalanceScale" then
				local AttemptClaimStation = t1.value9.AttemptClaimStation
				local t4 = {
					StationName = v23,
					TaskType = p4
				}

				AttemptClaimStation.FireServer(AttemptClaimStation, t4)

				return
			end

			if p4 ~= "T_MixChemicals" then
				return
			end

			local RequestClaimChemistryStation = t1.value9.RequestClaimChemistryStation
			local t5 = {
				StationName = v23
			}

			RequestClaimChemistryStation.InvokeServer(RequestClaimChemistryStation, t5)
		end

		v23 = scaleName

		local t6 = { pcall(v24) }
		local _ = t6[2]

		if t6[1] then
			return p3[v21]
		end
	end

	return nil
end

t1.value14 = false
t1.value15 = nil

function t1.value15(p5, p6)
	local v31 = nil

	local function v32()
		print("Claiming station:", p5, "type:", v31)

		if v31 == "T_BalanceScale" then
			local t7 = {
				StationName = p5,
				TaskType = v31
			}

			t1.value9.AttemptClaimStation:FireServer(t7)

			return
		end

		if v31 ~= "T_MixChemicals" then
			return
		end

		local t8 = {
			StationName = p5
		}

		t1.value9.RequestClaimChemistryStation:InvokeServer(t8)
	end

	v31 = p6
	pcall(v32)
end
function t1.value16()
	if t1.value14 then
		return
	end

	local s1 = "Scale1"
	local ScaleSpawnPosScale1 = t1.value10.Environment.Locations.SchoolArea.School.Interior.Floor2.Science.Interior.Gameplay.ScaleSpawnPosScale1

	if not t1.value12(ScaleSpawnPosScale1, 4) then
		warn("Can\'t go to " .. s1)

		return
	end

	t1.value15(s1, "T_BalanceScale")
	task.wait(1)

	local v37, v38, v39 = pairs(getgc(true))
	local v40 = nil

	while true do
		local v41

		v39, v41 = v37(v38, v39)

		if not v39 then
			v41 = v40

			break
		end

		local v42 = type(v41) == "table"

		if v42 then
			v42 = rawget(v41, "sideBWeight") ~= nil
		end

		if v42 then
			break
		end
	end

	if not v43 then
		warn("sideBWeight is null!")

		return
	end

	local sideBWeight = v43.sideBWeight

	print("SideB:", sideBWeight)

	local WeightsTableParent = ScaleSpawnPosScale1:FindFirstChild(s1):FindFirstChild("WeightsTableParent")
	local t9 = {
		[5] = WeightsTableParent.ScaleWeightHeavy.Main.ClickDetector,
		[2] = WeightsTableParent.ScaleWeightMedium.Main.ClickDetector,
		[1] = WeightsTableParent.ScaleWeightLight.Main.ClickDetector
	}
	local n1 = 0
	local sideAWeights = v43.sideAWeights

	if sideAWeights then
		local sideAWeights2 = v43.sideAWeights

		sideAWeights = type(sideAWeights2) == "table"
	end

	if sideAWeights then
		for _, sideAWeight in pairs(v43.sideAWeights) do
			n1 = n1 + sideAWeight
		end
	end

	local v51 = sideBWeight - n1

	print(" Weights:", n1, "| Need:", v51)

	for _, v in ipairs({ 5, 2, 1 }) do
		if true then
			local v55

			if v <= v51 then
				v55 = v51 > 0
			else
				v55 = false
			end
		end

		if v54 then
			local v56 = t9[v]

			if not v56 then
				break
			end

			fireclickdetector(v56, 0, "MouseClick")
			v51 = v51 - v
			print(("Add %d, Weights Left %d").format("Add %d, Weights Left %d", v, v51))
			task.wait(0.5)

			continue
		end
	end

	print("Done balance task!")
	task.wait(1.5)
	t1.value4.Jump = true
end
function t1.value17()
	local Gameplay = t1.value10.Environment.Locations.SchoolArea.School.Interior.Floor2.Science.Interior.Gameplay
	local GetChildren = Gameplay.GetChildren
	local t10 = {}

	for _, v in ipairs(GetChildren(Gameplay)) do
		local match = v.Name:match("^ChemistryStationSpawnPosChem(%d+)$")

		if match then
			local v62 = tonumber(match)
			local v63 = v:FindFirstChild("Chem" .. v62)

			if v63 then
				local LargeBeakerGlass = v63:FindFirstChild("LargeBeakerGlass")

				if LargeBeakerGlass then
					LargeBeakerGlass = LargeBeakerGlass:FindFirstChild("Origin")
				end

				local isBasePart

				if LargeBeakerGlass then
					isBasePart = LargeBeakerGlass:IsA("BasePart")
				else
					isBasePart = LargeBeakerGlass
				end

				if isBasePart then
					table.insert(t10, {
						id = v62,
						spawn = v,
						station = v63,
						stationName = "Chem" .. v62,
						origin = LargeBeakerGlass
					})
				end
			end
		end
	end

	return t10
end
function t1.value18()
	if t1.value7 then
		return print("Chemical running, skip")
	end

	t1.value7 = true

	local v66 = t1.value17()

	if #v66 == 0 then
		warn("❌ No chemistry station found!")
		t1.value7 = false

		return
	end

	local v67 = t1.value13(v66, "T_MixChemicals")

	if not v67 then
		warn("❌ Cannot claim any chemistry station!")
		t1.value7 = false

		return
	end

	local origin = v67.origin

	if not (origin and origin:IsA("BasePart")) then
		warn("Station has no Origin part")
		t1.value7 = false

		return
	end

	if not (origin and origin:IsA("BasePart")) then
		warn("Station has no Origin part")
		t1.value7 = false

		return
	end

	if not t1.value12(origin, 5) then
		warn("Cannot go to station", v67.stationName)
		t1.value7 = false

		return
	end

	task.wait(1)

	local v69 = t1.value3.PlayerGui.TopbarGui.Topbar.Header.SchoolHeader.SchoolFooter.FrameLeftBottom.TextLabelLeft.Text:lower()
	local t11 = {
		purple = { "RedFlask", v67.stationName, "BlueFlask" },
		green = { "BlueFlask", v67.stationName, "YellowFlask" },
		orange = { "YellowFlask", v67.stationName, "RedFlask" }
	}
	local v71, v72, v73 = pairs(t11)
	local v75 = nil

	while true do
		local v76

		v73, v76 = v71(v72, v73)

		if not v73 then
			v76 = v75

			break
		end

		if v69:find(v73) then
			break
		end
	end

	if not v74 then
		warn("⚠️ Cannot detect color")
		t1.value7 = false

		return
	end

	local stationName = v67.stationName

	table.insert(v74, stationName)

	local function v77(p7)
		if p7 == v67.stationName then
			return origin
		else
			local v78 = t1.value10.Environment.Locations.SchoolArea.School.Interior.Floor2.Science.Interior.Gameplay.ChemistryClass.ChemistryStationTable.Flasks:FindFirstChild(p7)

			if v78 then
				return v78.PrimaryPart or v78:FindFirstChildWhichIsA("BasePart")
			else
				return nil
			end
		end
	end

	for _, v in ipairs(v74) do
		local v81 = v77(v)

		if v81 then
			t1.value12(v81, 4)

			if v == v67.stationName then
				task.wait(1)

				local RequestAttachAndPour = t1.value9.RequestAttachAndPour
				local stationName2 = v67.stationName
				local vector3New = Vector3.new

				RequestAttachAndPour.FireServer(RequestAttachAndPour, {
					AttachOptions = {
						DetachCarried = false,
						LookStrength = 0.2,
						Animation = "PourFlask",
						NoEquipped = false
					},
					Duration = 1.5,
					StationName = stationName2,
					AttachPosition = vector3New(944, 47, -273)
				})
			else
				task.wait(1)
				t1.value9.RequestPickUpFlask:FireServer({
					FlaskName = v
				})
			end

			task.wait(0.6)
		else
			warn("Cannot find flask:", v)
		end
	end

	t1.value7 = false
	t1.value8 = false
	print("Done Mix Chemical:", v67.stationName)
end
function chemistryModule.startChem()
	if t1.value6 then
		return warn("AutoFarm is running!")
	end

	t1.value6 = true
	print("Auto Chemistry started!")

	local t12 = {
		Position = Vector3.new(953.88836669922, 47.305213928223, -267.48876953125)
	}

	t1.value12(t12, 0)

	local TextLabelLeft = nil
	local _ = TextLabelLeft == nil

	repeat
		task.wait(0.5)

		local function v88()
			TextLabelLeft = t1.value3.PlayerGui.TopbarGui.Topbar.Header.SchoolHeader.SchoolFooter.FrameLeftBottom.TextLabelLeft
		end

		pcall(v88)
	until TextLabelLeft ~= nil

	print("Get UI footerLabel!")
	t1.value11 = TextLabelLeft:GetPropertyChangedSignal("Text"):Connect(function()
		if not t1.value6 then
			return
		end

		local v89 = TextLabelLeft.Text:lower()

		if v89:find("claim") then
			if v89:find("balance") then
				if true then
					print("Claim Balance station...")
					t1.value16()

					return
				else
					return
				end
			end

			if not (v89:find("chemical") or (v89:find("mix") or v89:find("color"))) then
				return
			end

			local v90 = not t1.value8

			if v90 then
				v90 = not t1.value7
			end

			if not v90 then
				return
			end

			print("Claim Chem station...")
			t1.value18()
		else
			local pos = v89:find("balance")

			if pos then
				pos = not v89:find("claim")
			end

			if pos then
				pcall(t1.value16)

				return
			end

			local pos2 = v89:find("mix") or v89:find("color")

			if pos2 then
				pos2 = not v89:find("claim")
			end

			if not (pos2 and not t1.value7) then
				return
			end

			pcall(t1.value18)
		end
	end)
end
function chemistryModule.stopChem()
	if not t1.value6 then
		return
	end

	if not t1.value11 then
		print("Chemistry stopped!")

		return
	end

	t1.value11:Disconnect()
	print("Chemistry stopped!")
end

getgenv().ChemistryModule = chemistryModule

return chemistryModule
