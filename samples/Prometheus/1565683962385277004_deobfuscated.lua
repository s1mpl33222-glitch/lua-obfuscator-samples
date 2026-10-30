-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local game_ = game
local t1 = {
	value1 = game_.GetService(game_, "ReplicatedStorage"),
	value2 = game:GetService("RunService"),
	value3 = Players.LocalPlayer
}
local lib = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

t1.value4 = 25
t1.value5 = nil
t1.value6 = 4
t1.value7 = 30
t1.value8 = 8
t1.value9 = 3
t1.value10 = 0.03
t1.value11 = 0.08
t1.value12 = Vector3.new(0, 3, 0)

function t1.value13(p1)
	if p1 then
		if p1:IsA("Attachment") then
			return p1.WorldCFrame
		elseif p1:IsA("PVInstance") then
			return p1.GetPivot(p1)
		else
			return nil
		end
	else
		return nil
	end
end
function t1.value14(p2)
	if not p2 then
		return
	end

	local function v5()
		t1.value3:RequestStreamAroundAsync(p2["\238\17\189˕\245\186\179"])
	end

	pcall(v5)
end

t1.value15 = nil

function t1.value15()
	local Character = t1.value3.Character

	if not Character then
		return Character
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	return Character
end
function t1.value16()
	local function v7()
		return t1.value3:GetNetworkPing()
	end

	local ok, result = pcall(v7)
	local v10 = (not ok or type(result) ~= "number") and 0.1 or result

	return math.clamp(v10 * 2 + t1.value11, 0.12, 0.6)
end
function t1.value17(p3)
	local v11 = t1.value15()

	if v11 then
		v11.CFrame = p3
		v11.AssemblyLinearVelocity = Vector3.zero
	end

	local connection = t1.value2.Heartbeat:Connect(function()
		local v13 = t1.value15()

		if not v13 then
			return
		end

		v13.CFrame = p3
		v13.AssemblyLinearVelocity = Vector3.zero
		v13.AssemblyAngularVelocity = Vector3.zero
	end)

	return function()
		connection:Disconnect()
	end
end
function t1.value18(p4, p5)
	local v14 = t1.value17(p4)

	task.wait(t1.value16())

	local ok, result = pcall(p5)

	v14()

	if ok then
		return result
	else
		warn("[Arcane Hub]", result)

		return nil
	end
end
function t1.value19(p6)
	pcall(function()
		p6.HoldDuration = 0

		local v17 = p6
		local MaxActivationDistance = p6.MaxActivationDistance

		v17.MaxActivationDistance = math.max(MaxActivationDistance, 50)
		p6.RequiresLineOfSight = false
	end)

	local ok

	if fireproximityprompt then
		ok = pcall(fireproximityprompt, p6)
	else
		ok = false
	end

	if ok then
		return
	end

	pcall(function()
		p6:InputHoldBegin()
		task.wait(0.05)
		p6:InputHoldEnd()
	end)
end

t1.value5 = false

function t1.value20(p7)
	while t1.value5 do
		task.wait(0.05)
	end

	local ok, result = pcall(p7)

	t1.value5 = false

	if ok then
		return
	end

	warn("[Arcane Hub]", result)
end
function t1.value21(p8)
	if p8 == nil then
		return false
	elseif typeof(p8) == "Instance" then
		return p8 == t1.value3 or p8.Name == t1.value3.Name
	elseif type(p8) == "string" then
		return p8 == t1.value3.Name or p8 == t1.value3.DisplayName
	else
		return false
	end
end

t1.value22 = nil
t1.value23 = nil

local function v22()
	local value22 = t1.value22

	if value22 then
		value22 = t1.value22.Parent
	end

	if value22 then
		return t1.value22
	end

	local Tycoon = workspace:FindFirstChild("Tycoon")
	local Owner

	if not Tycoon then
		if Tycoon then
			for _, child in ipairs(Tycoon.GetChildren(Tycoon)) do
				Owner = child:FindFirstChild("Owner")

				if Owner then
					Owner = t1.value21(Owner.Value)
				end

				if Owner then
					return child
				end
			end
		else
			return nil
		end

		return
	end

	Tycoon = Tycoon:FindFirstChild("Tycoons")

	if Tycoon then
		for _, child in ipairs(Tycoon.GetChildren(Tycoon)) do
			Owner = child:FindFirstChild("Owner")

			if Owner then
				Owner = t1.value21(Owner.Value)
			end

			if Owner then
				return child
			end
		end
	else
		return nil
	end
end

function t1.value24(p9)
	local Essentials = p9:FindFirstChild("Essentials")

	if Essentials then
		Essentials = Essentials:FindFirstChild("Oil Collector")
	end

	if Essentials then
		Essentials = Essentials:FindFirstChild("Collector")
	end

	if not Essentials then
		return Essentials
	end

	Essentials = Essentials:FindFirstChild("BarrelSlot")

	return Essentials
end

local function v31()
	local v32 = v22()

	if not v32 then
		return nil
	end

	local v33 = t1.value24(v32)

	if v33 then
		t1.value23 = t1.value13(v33)

		return v33
	end

	local n1

	if t1.value23 then
		t1.value14(t1.value23)
		n1 = 0
	else
		n1 = 0
	end

	while true do
		local v35 = not v33

		if v35 then
			v35 = n1 < t1.value9
		end

		if not v35 then
			break
		end

		task.wait(0.1)
		n1 = n1 + 0.1
		v33 = t1.value24(v32)
	end

	if not v33 then
		return v33
	end

	t1.value23 = t1.value13(v33)

	return v33
end

t1.value25 = nil

function t1.value25()
	return workspace:FindFirstChild("Game Systems")
end
function t1.value26()
	local CollectiblesWorkspace = t1.value25()

	if CollectiblesWorkspace then
		CollectiblesWorkspace = CollectiblesWorkspace:FindFirstChild("Collectibles Workspace")
	end

	if not CollectiblesWorkspace then
		return CollectiblesWorkspace
	end

	CollectiblesWorkspace = CollectiblesWorkspace:FindFirstChild("OilBarrel")

	return CollectiblesWorkspace
end
function t1.value27()
	local t2 = { pcall(function()
			t1.value1.Packages.Knit.Services.CollectibleService.RF.RequestCollectibleDrop:InvokeServer()
		end) }
	local v38 = t2[2]

	if t2[1] then
		return
	end

	warn("[Arcane Hub] Drop error:", v38)
end
function t1.value28(p10)
	local PromptPart = p10:FindFirstChild("PromptPart")

	if PromptPart then
		v48 = PromptPart:FindFirstChildWhichIsA("ProximityPrompt", true)
	else
		v48 = PromptPart
	end

	if v48 then
		return v48, PromptPart
	end

	local ProximityPrompt = p10:FindFirstChildWhichIsA("ProximityPrompt", true)

	if ProximityPrompt then
		PromptPart = ProximityPrompt.Parent
	else
		PromptPart = ProximityPrompt
	end

	return ProximityPrompt, PromptPart
end
function t1.value29(p11, p12, p13)
	return not p11.Parent or (not p12.Parent or (not p12.Enabled or (p11:GetPivot().Position - p13).Magnitude > 5))
end

local function v41(p14, p15, p16)
	local v42 = t1.value13(p16)

	if not v42 then
		return false
	end

	local Position = p14:GetPivot().Position
	local v44 = t1.value17(v42 + t1.value12)

	task.wait(t1.value16())

	local v45 = false

	for _ = 1, t1.value6 do
		if not (p14.Parent and p15.Parent) then
			v45 = true

			return
		end

		if not p15.Enabled then
			v44()

			return v45
		end

		t1.value19(p15)

		for _ = 1, 13 do
			task.wait(t1.value10)

			if t1.value29(p14, p15, Position) then
				v45 = true

				break
			end
		end

		if v45 then
			v44()

			return v45
		end
	end

	v44()

	return v45
end

t1.value30 = lib:CreateWindow({
	name = "Arcane Hub",
	subtitle = "Rayfield Gen2",
	sidebarLayout = true
})

local v49 = t1.value30:CreateTab({
	name = "Auto Farm"
})

t1.value31 = false
t1.value32 = false
t1.value33 = setmetatable({}, {
	__mode = "k"
})
t1.value34 = setmetatable({}, {
	__mode = "k"
})
t1.value35 = 0

local function v50(p17)
	if not (os["Iq\143\182Q"]() - t1.value35 > 10) then
		return
	end

	os.clock()
	t1.value30:Notify({
		title = "Arcane Hub",
		content = p17
	})
end

function t1.value36()
	while true do
		if not t1.value31 then
			return
		end

		local u51 = false
		local v52 = t1.value26()

		if v52 then
			for _, child in ipairs(v52:GetChildren()) do
				if not t1.value31 then
					break
				end

				local v54, v55 = t1.value28(child)
				local v56 = t1.value33[child]

				if v56 then
					v56 = os.clock() - t1.value33[child] < t1.value7
				end

				local Enabled

				if v54 then
					if v55 then
						Enabled = v54.Enabled

						if Enabled then
							Enabled = not v56
						end
					else
						Enabled = v55
					end
				else
					Enabled = v54
				end

				if Enabled then
					local function v58()
						if not (v54.Enabled and v54.Parent) then
							return
						end

						local v59 = v31()
						local value23 = t1.value13(v59) or t1.value23

						if not value23 then
							v50("BarrelSlot not found, waiting for it to load...")

							return
						end

						if (child:GetPivot().Position - value23.Position).Magnitude <= t1.value4 then
							return
						end

						if not v41(child, v54, v55) then
							return
						end

						local v61 = v31() or v59
						local v62 = t1.value13(v61) or value23

						t1.value18(v62 + Vector3.new(0, 4, 0), t1.value27)
						t1.value33[child] = os.clock()
						u51 = true
					end

					t1.value20(v58)
				end
			end
		end

		task.wait(u51 and 0.1 or 0.5)
	end
end

t1.value37 = {
	"airdrop",
	"cashpallet",
	"researchpile",
	"researchpallet"
}

function t1.value38(p18)
	local v63 = p18.GetFullName(p18):lower()

	if v63:find("oilbarrel", 1, true) then
		return false
	else
		for _, v in ipairs(t1.value37) do
			if v63:find(v, 1, true) then
				return true
			end
		end

		return false
	end
end
function t1.value39()
	local t3 = {}
	local v67 = t1.value25()

	if v67 then
		for _, descendant in ipairs(v67:GetDescendants()) do
			local isProximityPrompt = descendant:IsA("ProximityPrompt")

			if isProximityPrompt then
				isProximityPrompt = t1.value38(descendant)
			end

			if isProximityPrompt then
				t3[#t3 + 1] = descendant
			end
		end

		return t3
	else
		return t3
	end
end
function t1.value40(p19)
	local v71 = t1.value15()

	if not v71 then
		return
	end

	local v72 = t1.value13(p19.Parent)

	if not v72 then
		return
	end

	local CFrame = v71.CFrame

	t1.value14(v72)

	local v74 = t1.value17(v72 + t1.value12)

	task.wait(t1.value16())

	for _ = 1, 3 do
		if not (p19.Parent and p19.Enabled) then
			break
		end

		t1.value19(p19)

		local n2 = 0

		while n2 < 0.6 do
			task.wait(t1.value10)
			n2 = n2 + t1.value10

			if not (p19.Parent and p19.Enabled) then
				break
			end
		end
	end

	v74()

	local v77 = t1.value15()

	if not v77 then
		return
	end

	v77.CFrame = CFrame
end

local function v78()
	while true do
		if not t1.value32 then
			return
		end

		local u79 = false

		for _, v in ipairs(t1.value39()) do
			if not t1.value32 then
				break
			end

			local Parent = v.Parent

			if Parent then
				Parent = v.Enabled
			end

			if Parent then
				local v83 = t1.value34[v]

				if v83 then
					v83 = os.clock() - t1.value34[v] < t1.value8
				end

				if not v83 then
					local function v84()
						local Parent2 = v.Parent

						if Parent2 then
							Parent2 = v.Enabled
						end

						if not Parent2 then
							return
						end

						t1.value40(v)
						t1.value34[v] = os.clock()
						u79 = true
					end

					t1.value20(v84)
				end
			end
		end

		task.wait(u79 and 0.1 or 0.5)
	end
end

v49.CreateToggle(v49, {
	name = "Bring Oil Barrels to Oil Collector",
	description = "Picks up ready barrels and drops them at your BarrelSlot",
	value = false,
	callback = function(p20)
		t1.value31 = p20

		if not p20 then
			return
		end

		local v86 = v22()

		if not v86 then
			t1.value30:Notify({
				title = "Arcane Hub",
				content = "Your base was not found."
			})

			return
		end

		local value30 = t1.value30
		local t4 = {
			title = "\2\4U{pQ1\235\30\132",
			content = "Your base: " .. v86.Name
		}

		value30.Notify(value30, t4)
		task.spawn(t1.value36)
	end
})
v49.CreateToggle(v49, {
	name = "Collect Cash & Research Airdrops",
	description = "Teleports to airdrops, collects them and returns you back",
	value = false,
	callback = function(p21)
		t1.value32 = p21

		if not p21 then
			return
		end

		task.spawn(v78)
	end
})
