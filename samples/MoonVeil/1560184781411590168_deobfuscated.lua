-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")
game:GetService("VirtualInputManager")
game:GetService("UserInputService")

local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Fireworks = ReplicatedStorage.Assets.Fireworks
local Fireworks2 = workspace.Fireworks
local HiddenCache = ReplicatedStorage.HiddenCache
local HuntInstances = workspace.HuntInstances
local u9 = workspace:FindFirstChild("ShopInterior") or HiddenCache.ShopInterior
local v10 = u9:FindFirstChild("Shops Room") or u9.Rooms["Shops Room"]
local v11 = HiddenCache:FindFirstChild("PyroPoint") or workspace.PyroPoint
local u12 = false
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
}
local t6 = {}

for _, v in pairs(getgc(true)) do
	if typeof(v) == "table" then
		if not rawget(v, "loadouts") then
			if not rawget(v, "120xPowPow") then
				if rawget(v, "LoadoutSaves") then
					LS = v.LoadoutSaves
				end
			else
				for k, v2 in pairs(v) do
					if typeof(v2) == "table" and rawget(v2, "Cooldown") then
						t4[k] = v2.Cooldown * 6
					end
				end
			end
		else
			t1.fireworksetup = v.fireworksetup
			t1.loadouts = v.loadouts
		end
	end
end

local n1 = 1

for k, _ in pairs(LS) do
	if typeof(k) == "string" and n1 <= #t5 then
		t6[t5[n1]] = k
		n1 = n1 + 1
	end
end

for _, child in pairs(HiddenCache:GetChildren()) do
	child.Parent = workspace
end

local ChildAdded = HiddenCache.ChildAdded
local u29 = HiddenCache

ChildAdded:Connect(function(p1)
	local defer = task.defer
	local u78 = p1

	defer(function()
		if u78.Parent == u29 then
			u78.Parent = workspace
		end
	end)
end)
LocalPlayer.Idled:Connect(function()
	local VirtualUser = game:GetService("VirtualUser")

	VirtualUser:CaptureController()

	local v80 = (function(...)
		local t7 = { ... }

		t7.n = select("#", ...)

		return t7
	end)(Vector2.new())

	unpack(v80, 1, 1)
	VirtualUser:ClickButton2(unpack(v80, 1, v80.n))
end)

function getPartPos(p2)
	if not p2.Parent:IsA("Model") then
		return p2.Parent.Position
	end

	return p2.Parent:GetPivot().Position
end

local u30 = LocalPlayer
local u31 = CurrentCamera

function lightFireworks(_, p4)
	if p4:GetAttribute("OwnerId") == u30.UserId then
		local u84 = p4

		local function u85()
			local timestamp = tick()
			local v151 = u84:FindFirstChild("FusePrompt") or u84:FindFirstChild("PromptPart") and u84.PromptPart:FindFirstChild("FusePrompt")

			v151.MaxActivationDistance = 30
			task.wait(0.1)
			v151:InputHoldBegin()

			repeat
				u31.CFrame = CFrame.lookAt(u31.CFrame.Position, getPartPos(v151))

				if tick() - timestamp >= 5 then
					v151:InputHoldEnd()

					return u85()
				end

				task.wait(0.01)
			until not u84.Parent
		end

		u85()
	end
end

local u32 = t3
local u33 = t4

function checkTbl(p5, p6)
	if not u32[p5][p6] then
		u32[p5][p6] = u33[p6]
	end
end

local u34 = Fireworks2

function checkTime(p7, p8)
	local timestamp = tick()

	while true do
		local p7_2 = u34:FindFirstChild(p7)

		if p7_2 then
			break
		end

		if not p7_2 and p8 <= tick() - timestamp then
			return false
		end

		task.wait()
	end

	return true
end

local u35 = LocalPlayer
local u36 = Fireworks
local u37 = t2
local u38 = t1
local u39 = Fireworks2

function placeFireworks(p9)
	if not u35:GetAttribute("LighterActive") then
		u35:GetAttributeChangedSignal("LighterActive"):Wait()
	end

	local PrimaryPart = u35.Character.PrimaryPart
	local n2 = 0
	local u95 = false

	for _, child in pairs(u35.Backpack:GetChildren()) do
		if u36:FindFirstChild(child.Name) and u12 then
			local u98 = p9
			local u99 = child
			local u100 = PrimaryPart

			local function u101()
				u37[u98][u99.Name] = tick()

				local v152 = u36[u99.Name].Prim.Size.Z + 2

				u38.fireworksetup:InvokeServer({
					Type = "Place",
					Tool = u99,
					TargetFrame = u100.CFrame * CFrame.new(0, -u35.Character.Humanoid.HipHeight, -v152),
				})

				if checkTime(u99.Name, 3) then
					lightFireworks(u98, u39[u99.Name])
					checkTbl(u98, u99.Name)

					return
				end

				n2 = n2 + 1

				if not (n2 >= 3) then
					return u101()
				end

				checkTbl(u98, u99.Name)
				u95 = true
				task.wait(3)
			end

			u101()

			if u95 then
				break
			end
		end
	end
end

local u40 = LocalPlayer
local u41 = v10
local u42 = t1

function getLoadout(p10, p11)
	if not p11 then
		u40.Character.PrimaryPart.CFrame = u41.Counter.CFrame + Vector3.new(0, 0, -10)
	else
		local DisplayBeam = p11.Shops.Fireworks.DisplayBeam

		u40.Character.PrimaryPart.CFrame = CFrame.new(DisplayBeam.Position + DisplayBeam.CFrame.LookVector * 5, DisplayBeam.Position)
	end

	task.wait(0.3)

	local loadouts = u42.loadouts
	local fromstring = buffer.fromstring
	local v107 = #p10
	local v108 = (function(...)
		local t8 = { ... }

		t8.n = select("#", ...)

		return t8
	end)(fromstring(string.char(v107) .. p10 .. "\000\000\004Load"))

	loadouts:InvokeServer(unpack(v108, 1, v108.n))
end

local u43 = LocalPlayer

function lighterFunc()
	local v116 = u43.Character or u43.CharacterAdded:Wait()

	while u12 do
		for _, child in pairs(v116:GetChildren()) do
			if child.Name:find("Lighter") and not u43:GetAttribute("LighterActive") then
				child:Activate()

				break
			end
		end

		for _, child in pairs(u43.Backpack:GetChildren()) do
			if child.Name:find("Lighter") then
				v116.Humanoid:EquipTool(child)

				break
			end
		end

		task.wait(1)
	end
end

local u44 = v11
local u45 = LocalPlayer

function checkBarge()
	for _, child in pairs(u44.BargeSpots:GetChildren()) do
		if child:GetAttribute("OwnerId") == u45.UserId then
			for _, child2 in pairs(child:GetChildren()) do
				if child2.Name:find("Barge") then
					return child2
				end
			end
		end
	end

	return nil
end

local n3 = 1
local u47 = LocalPlayer
local u48 = t5
local u49 = t6
local u50 = t3
local u51 = t2

function autofarmLoop()
	local v125 = true
	local PrimaryPart = u47.Character.PrimaryPart
	local PrimaryPartCFrame = PrimaryPart.CFrame

	if n3 > #u48 then
		n3 = 1
	end

	local v128 = u49[u48[n3]]

	if LS[v128] then
		if not u50[v128] then
			u50[v128] = {}
		end

		if not u51[v128] then
			u51[v128] = {}
		end

		for k, v in pairs(u51[v128]) do
			if k and u50[v128][k] and tick() - v <= u50[v128][k] then
				v125 = false

				break
			end
		end

		if v125 then
			local v131 = checkBarge()

			getLoadout(v128, v131)
			task.wait(0.2)
			PrimaryPart.CFrame = PrimaryPartCFrame
			task.wait(0.2)
			placeFireworks(v128)
		end
	end

	n3 = n3 + 1

	return v128, v125
end
function grabCollectables()
	local v132 = false

	for _, child in pairs(HuntInstances:GetChildren()) do
		if child:IsA("Folder") then
			for _, child3 in pairs(child:GetChildren()) do
				if child3 and child3:FindFirstChild("ProximityPrompt") then
					v132 = true
					fireproximityprompt(child3.ProximityPrompt)
					task.wait(0.5)
				end
			end
		end
	end

	return v132
end

local u52 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v53 = u52:CreateWindow({
	Name = "Pyro Panel",
	Icon = 0,
	LoadingTitle = "Fireworks Playground Script",
	LoadingSubtitle = "By Murvity",
	ShowText = "UI",
	Theme = "Default",
	ToggleUIKeybind = "X",
})

function notify(p12, p13, p14)
	u52:Notify({
		Title = p12,
		Content = p13,
		Duration = 5,
		Image = p14,
	})
end

local v54 = v53:CreateTab("Main", "list")

v54:CreateSection("Farming")

local t9 = {
	Name = "Autofarm",
	CurrentValue = false,
}
local u56 = LocalPlayer

function t9.Callback(p15)
	u12 = p15

	if p15 then
		if not u56:GetAttribute("HideFireworkFX") then
			notify("Autofarm", "Enable 'Delete when lit' in settings before using the autofarm.", "circle-alert")
		else
			task.spawn(lighterFunc)

			while u12 do
				local ok, result, v143 = pcall(autofarmLoop)

				if not ok then
					notify("Runtime Error", tostring(result) .. ".", "circle-alert")
				elseif not ok or not v143 then
					if ok and not v143 then
						notify("Autofarm", "Loadout '" .. result .. "' is not ready to be placed yet, moving on in a few seconds...", "circle-alert")
						task.wait(5)
					end
				elseif result then
					notify("Autofarm", "Finished placing and lighting loadout '" .. result .. "'.", "smile")
				end

				task.wait(0.1)
			end
		end
	end
end

v54:CreateToggle(t9)
v54:CreateButton({
	Name = "Retrieve Collectables",
	Callback = function()
		local v144 = grabCollectables()

		task.wait(0.1)

		if not v144 then
			notify("Collectables", "All items have already been found.", "circle-alert")

			return
		end

		notify("Collectables", "All items have been collected!", "thumbs-up")
	end,
})
v54:CreateSection("Teleports")

local t10 = {
	Name = "Shop",
}
local u58 = LocalPlayer

function t10.Callback()
	u58.Character.PrimaryPart.CFrame = u9.Rooms.Lobby["ExitDoor.009"].CFrame + Vector3.new(15, 0, 0)
end

v54:CreateButton(t10)

local t11 = {
	Name = "Pyro Point",
}
local u60 = LocalPlayer
local u61 = v11

function t11.Callback()
	u60.Character.PrimaryPart.CFrame = u61.ShopZone.EnterDoor.Part.CFrame + Vector3.new(10, 0, 0)
end

v54:CreateButton(t11)

local v62 = v53:CreateTab("Misc", "rewind")

v62:CreateSection("Loadouts")

for k, _ in pairs(LS) do
	local t12 = {
		Name = k,
	}
	local u66 = LocalPlayer
	local u67 = k

	function t12.Callback()
		local PrimaryPartCFrame = u66.Character.PrimaryPart.CFrame

		getLoadout(u67, checkBarge())
		u66.Character.PrimaryPart.CFrame = PrimaryPartCFrame
	end

	v62:CreateButton(t12)
	task.wait(0.1)
end

v62:CreateSection("Character")

local t13 = {
	Name = "Walk Speed",
	Range = {
		0,
		100,
	},
	Increment = 1,
	Suffix = "",
	CurrentValue = LocalPlayer.Character.Humanoid.WalkSpeed,
}
local u69 = LocalPlayer

function t13.Callback(p16)
	u69.Character.Humanoid.WalkSpeed = p16
end

v62:CreateSlider(t13)

local t14 = {
	Name = "Jump Power",
	Range = {
		0,
		100,
	},
	Increment = 1,
	Suffix = "",
}
local JumpHeight = LocalPlayer.Character.Humanoid.JumpHeight

t14.CurrentValue = math.round(JumpHeight)

local u72 = LocalPlayer

function t14.Callback(p17)
	u72.Character.Humanoid.JumpHeight = p17
end

v62:CreateSlider(t14)

local t15 = {
	Name = "Hip Height",
	Range = {
		0,
		100,
	},
	Increment = 1,
	Suffix = "",
}
local HipHeight = LocalPlayer.Character.Humanoid.HipHeight

t15.CurrentValue = math.round(HipHeight)

local u75 = LocalPlayer

function t15.Callback(p18)
	u75.Character.Humanoid.HipHeight = p18
end

v62:CreateSlider(t15)
