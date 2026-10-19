local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

lib:Localization({
	["Enabled"] = true,
	["Prefix"] = "loc:",
	["DefaultLanguage"] = "en",
	["Translations"] = {
		["en"] = {
			["WINDUI_EXAMPLE"] = "YQANTG",
			["WELCOME"] = "Welcome to YQANTG V3.3",
			["LIB_DESC"] = "Thanks for use my script",
			["FEATURES"] = "Misc",
			["TAB1"] = "New",
			["TAB2"] = "Auto Block",
			["TAB3"] = "Camlock",
			["TAB4"] = "Local",
			["TAB5"] = "Other",
			["TAB6"] = "Tech",
			["TAB7"] = "Movest",
			["TAB8"] = "Anti",
			["TAB9"] = "Server",
			["TAB10"] = "Shader",
			["TAB11"] = "Farm",
			["TAB12"] = "Hub",
			["TAB13"] = "Admin"
		}
	}
})
lib:SetTheme("Dark")
lib.TransparencyValue = 0.2

local v2 = lib:CreateWindow({
	["Title"] = "loc:WINDUI_EXAMPLE",
	["Icon"] = "geist:window",
	["Author"] = "loc:WELCOME",
	["Folder"] = "WindUI_Example",
	["Size"] = UDim2.fromOffset(300, 300),
	["Theme"] = "Dark"
})
local parent = {
	["Main"] = v2:Section({
		["Title"] = "loc:FEATURES",
		["Opened"] = true
	})
}
local t1 = {
	"geist:plus",
	"geist:shield",
	"geist:target",
	"geist:user",
	"geist:more-horizontal",
	"geist:cpu",
	"geist:arrow-up-right",
	"geist:slash",
	"geist:cloud",
	"geist:sun",
	"geist:box",
	"geist:menu",
	"geist:key"
}
local t2 = {}

for i = 1, 13 do
	t2[i] = parent.Main:Tab({
		["Title"] = "loc:TAB" .. i,
		["Icon"] = t1[i],
		["Desc"] = "This is Tab " .. i
	})
end

t2[7]:Button({
	["Title"] = "Basic Emote",
	["Icon"] = "shield-check",
	["Callback"] = function()
		getgenv().GuiKeybind = "T"
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/EmoteGui/refs/heads/main/Protected_4900496055951847.lua"))()
	end
})
t2[7]:Button({
	["Title"] = "Emerge Emote",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/HAHAHHA/refs/heads/main/EmergeButLow", true))()
	end
})
t2[7]:Button({
	["Title"] = "Sukuna Emote",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/Sukunaslash/refs/heads/main/WorldCuttingSlash", true))()
	end
})
t2[7]:Button({
	["Title"] = "MIUI",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()
	end
})
t2[7]:Button({
	["Title"] = "Gojo v2 (Saitama)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-The-Strongest-Battleground-Gojo-manga-Tsb-30660"))()
	end
})
t2[7]:Button({
	["Title"] = "Overhaul (Saitama)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/SaitamaOverhaul/refs/heads/main/Latest.lua"))()
	end
})
t2[7]:Button({
	["Title"] = "Movest UI",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://gist.githubusercontent.com/proscripter400/b24547203a4cc12bdcfe77fd13dd7580/raw/fb8048c0d5b59d626879b1a06cfedaae3e7ee205/charhub"))()
	end
})
t2[7]:Button({
	["Title"] = "Wally West (Saitama)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Nova2ezz/west/refs/heads/main/Protected_4638864115822087.lua.txt"))()
	end
})
t2[7]:Button({
	["Title"] = "Orbitical Warrior (Saitama)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AeryAlex/Scripts/refs/heads/main/Orbitical%20Warrior%20(Obsfucted).lua"))()
	end
})
t2[7]:Button({
	["Title"] = "Sukuna v2 (Saitama)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-The-Strongest-Battleground-heian-sukuna-Moveset-30680"))()
	end
})
t2[1]:Button({
	["Title"] = "New Ui",
	["Icon"] = "shield-check",
	["Callback"] = function()
		print("")
	end
})
t2[1]:Button({
	["Title"] = "Fix some bug",
	["Icon"] = "shield-check",
	["Callback"] = function()
		print("")
	end
})
t2[2]:Button({
	["Title"] = "Auto Block V11",
	["Icon"] = "shield-plus",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/CombatGUI/refs/heads/main/TSBCombatGUI"))()
	end
})
t2[2]:Button({
	["Title"] = "Auto Block V6",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6520709616677918.lua.txt"))()
	end
})
t2[3]:Button({
	["Title"] = "Slient Aim Rework",
	["Icon"] = "target",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6124417452209241.lua.txt"))()
	end
})
t2[3]:Button({
	["Title"] = "Bot Follow + Slient Aim",
	["Icon"] = "bot",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Bot"))()
	end
})
t2[3]:Button({
	["Title"] = "Camlock",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/HomeMadeScripts/Camlock-aimlock/main/obf_Wxr6QgzF76G1y2Ch77KN4Zt5Nz0A6GIl61gitv3mRR2t3V103al5d0g26s4KY04r.lua.txt"))()
	end
})
t2[4]:Button({
	["Title"] = "Free emote slots",
	["Icon"] = "smile",
	["Callback"] = function()
		game.Players.LocalPlayer:SetAttribute("ExtraSlots", true)
	end
})
t2[4]:Toggle({
	["Title"] = "No Dash Cooldown",
	["Default"] = false,
	["Callback"] = function(p1)
		if p1 then
			workspace:SetAttribute("VIPServer", tostring(game.Players.LocalPlayer.UserId))
			workspace:SetAttribute("VIPServerOwner", game.Players.LocalPlayer.Name)
			workspace:SetAttribute("NoDashCooldown", true)
		else
			workspace:SetAttribute("NoDashCooldown", false)
		end
	end
})

local LocalPlayer = game:GetService("Players").LocalPlayer

t2[4]:Toggle({
	["Title"] = "Auto Respawn",
	["Default"] = false,
	["Callback"] = function(p2)
		if p2 then
			getgenv().RespawnAtDeathPos = true

			if getgenv()._RespawnConn then
				getgenv()._RespawnConn:Disconnect()
			end

			if getgenv()._DiedConn then
				getgenv()._DiedConn:Disconnect()
			end

			local function v8()
				local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				Character = Character:FindFirstChild("HumanoidRootPart")

				if not (Humanoid and Character) then
					return
				end

				if getgenv()._DiedConn then
					getgenv()._DiedConn:Disconnect()
				end

				getgenv()._DiedConn = Humanoid.Died:Connect(function()
					if not getgenv().RespawnAtDeathPos then
						return
					end

					getgenv()._LastDeathPosition = Character.Position
				end)
			end

			getgenv()._RespawnConn = LocalPlayer.CharacterAdded:Connect(function(character)
				task.spawn(function()
					local HumanoidRootPart = getgenv().RespawnAtDeathPos and getgenv()._LastDeathPosition and character:WaitForChild("HumanoidRootPart", 5)

					if not HumanoidRootPart then
						v8()

						return
					end

					HumanoidRootPart.CFrame = CFrame.new(getgenv()._LastDeathPosition + Vector3.new(0, 3, 0))
					v8()
				end)
			end)
			v8()
			print("Auto Respawn: ON")
		else
			getgenv().RespawnAtDeathPos = false

			if getgenv()._RespawnConn then
				getgenv()._RespawnConn:Disconnect()
			end

			if getgenv()._DiedConn then
				getgenv()._DiedConn:Disconnect()
			end

			getgenv()._RespawnConn = nil
			getgenv()._DiedConn = nil
			getgenv()._LastDeathPosition = nil
			print("Auto Respawn: OFF")
		end
	end
})
t2[4]:Toggle({
	["Title"] = "Auto Fake Out",
	["Default"] = false,
	["Callback"] = function(p3)
		if p3 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/L1(FO)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/L2(FO)"))()
		end
	end
})

local LocalPlayer2 = game.Players.LocalPlayer
local s1 = "rbxassetid://10470389827"

local function v14(p4)
	local v15, v16, v17 = ipairs(p4:GetPlayingAnimationTracks())

	while true do
		local v18

		v17, v18 = v15(v16, v17)

		if v17 == nil then
			break
		end

		if v18.Animation and v18.Animation.AnimationId == s1 then
			v18:Stop()
			pcall(function()
				v18:Destroy()
			end)
		end
	end
end
local function v19(character)
	local Humanoid = character:WaitForChild("Humanoid")
	local connection = Humanoid.AnimationPlayed:Connect(function(p5)
		if not (p5.Animation and p5.Animation.AnimationId == s1) then
			return
		end

		p5:Stop()
		pcall(function()
			p5:Destroy()
		end)
	end)
	local thread = task.spawn(function()
		while Humanoid.Parent do
			v14(Humanoid)
			task.wait(0.05)
		end
	end)

	character.AncestryChanged:Connect(function(_, parent2)
		if parent2 then
			return
		end

		if connection then
			connection:Disconnect()
		end

		task.cancel(thread)
	end)
end

t2[4]:Toggle({
	["Title"] = "Invisible Block",
	["Default"] = false,
	["Callback"] = function(p6)
		if p6 then
			if LocalPlayer2.Character then
				v19(LocalPlayer2.Character)
			end

			LocalPlayer2.CharacterAdded:Connect(v19)
			print("Invisible Block: ON")
		else
			print("Invisible Block: OFF")
		end
	end
})
t2[4]:Toggle({
	["Title"] = "No Stun",
	["Default"] = false,
	["Callback"] = function(p7)
		if p7 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NST(L1)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NST(L2)"))()
		end
	end
})
t2[4]:Toggle({
	["Title"] = "No Slowed",
	["Default"] = false,
	["Callback"] = function(p8)
		if p8 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NSL(L1)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NSL(L2)"))()
		end
	end
})

local t3 = {
	["rbxassetid://10480793962"] = true,
	["rbxassetid://10480796021"] = true,
	["rbxassetid://10470104242"] = true
}

local function v24(p9)
	local Humanoid = p9:WaitForChild("Humanoid")
	local HumanoidRootPart = p9:WaitForChild("HumanoidRootPart")

	Humanoid.AnimationPlayed:Connect(function(p10)
		if not (getgenv().AntiDelayEnabled and t3[p10.Animation.AnimationId]) then
			return
		end

		task.wait(0.21)
		p10:Stop()
	end)
	task.spawn(function()
		while p9 and p9.Parent == workspace do
			task.wait(100)

			if HumanoidRootPart and HumanoidRootPart.PlatformStand then
				HumanoidRootPart.PlatformStand = true
			end
		end
	end)
end

parent = game:GetService("Players").LocalPlayer
parent.CharacterAdded:Connect(function(character)
	task.defer(function()
		v24(character)
	end)
end)
v24(parent.Character or parent.CharacterAdded:Wait())
t2[4]:Toggle({
	["Title"] = "No Slide Dash Endlag",
	["Default"] = false,
	["Callback"] = function(p11)
		getgenv().AntiDelayEnabled = p11

		if p11 then
			print("No Slide Dash Endlag: ON")
		else
			print("No Slide Dash Endlag: OFF")
		end
	end
})
t2[4]:Toggle({
	["Title"] = "Free Rotate Ult",
	["Default"] = false,
	["Callback"] = function(p12)
		if p12 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FRU(L1)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FLU(L2)"))()
		end
	end
})
t2[4]:Toggle({
	["Title"] = "Death Counter Indicator",
	["Default"] = false,
	["Callback"] = function(p13)
		setState(p13)
	end
})
t2[5]:Button({
	["Title"] = "Orbit Gui!",
	["Icon"] = "rotate-cw",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Orbit%20by%20YQANTG"))()
	end
})
t2[5]:Button({
	["Title"] = "Auto Toxic",
	["Icon"] = "skull",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ArchIsDead/Arch-Vault/refs/heads/main/auto-toxic.lua"))()
	end
})
t2[5]:Toggle({
	["Title"] = "M1 Reach",
	["Default"] = false,
	["Callback"] = function(p14)
		if p14 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/MR(L1)"))()
		else
			_G.TweenReachHold = false
			_G.TweenReachLooping = false
		end
	end
})
t2[5]:Toggle({
	["Title"] = "Auto WallCombo Under",
	["Default"] = false,
	["Callback"] = function(p15)
		if p15 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/ATWC(L1)"))()
		else
			_G.AutoWallCombo = false
			_G.BurrowRunning = false

			local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

			if not PlayerGui then
				return
			end

			local v28, v29

			PlayerGui, v28, v29 = pairs(PlayerGui:GetChildren())

			while true do
				local v30

				v29, v30 = PlayerGui(v28, v29)

				if v29 == nil then
					break
				end

				if v30.Name == "StickGui" then
					v30:Destroy()
				end
			end
		end
	end
})
parent = game:GetService("Players")

local RunService = game:GetService("RunService")

game:GetService("ReplicatedStorage")

local LocalPlayer3 = parent.LocalPlayer
local Character = LocalPlayer3.Character or LocalPlayer3.CharacterAdded:Wait()
local HumanoidRootPart = Character
local Humanoid = Character.WaitForChild(HumanoidRootPart, "Humanoid")

HumanoidRootPart = Character

local HumanoidRootPart2 = Character.WaitForChild(HumanoidRootPart, "HumanoidRootPart")
local t4 = {
	["13294471966"] = true,
	["10469643643"] = true,
	["13295936866"] = true,
	["13378708199"] = true,
	["14136436157"] = true,
	["15162694192"] = true,
	["16552234590"] = true,
	["17889290569"] = true,
	["134775406437626"] = true,
	["10470104242"] = true
}
local AlignPosition = nil
local AlignOrientation = nil
local connection = nil
local Part = nil
local u42 = false
local n1 = 10
local u44 = false

LocalPlayer3.CharacterAdded:Connect(function(character)
	Character = character
	Humanoid = character:WaitForChild("Humanoid")
	HumanoidRootPart2 = character:WaitForChild("HumanoidRootPart")
	setupAnimEvent()
end)
LocalPlayer3 = Instance.new("ScreenGui", LocalPlayer3:WaitForChild("PlayerGui"))
LocalPlayer3.Name = "WallcomboCooldownUI"
LocalPlayer3.ResetOnSpawn = false

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 300, 0, 20)
Frame.Position = UDim2.new(0.5, -150, 0.5, 40)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = false
Frame.Parent = LocalPlayer3
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Frame2 = Instance.new("Frame", Frame)

Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame2.Size = UDim2.new(0, 0, 1, 0)
Frame2.Position = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 0.7
TextLabel.TextColor3 = Color3.new(1, 0, 0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextScaled = true
TextLabel.Text = "Cooldown"

local function v48()
	if AlignPosition then
		AlignPosition:Destroy()
	end

	if AlignOrientation then
		AlignOrientation:Destroy()
	end

	if connection then
		connection:Disconnect()
	end

	local v49

	if not Part then
		v69 = HumanoidRootPart2
		v69, v70, v71 = ipairs(v69:GetChildren())

		while true do
			v71, v49 = v69(v70, v71)

			if v71 == nil then
				break
			end

			if v49:IsA("Attachment") or v49.Name == "HasSnapped" then
				v49:Destroy()
			end
		end

		return
	end

	Part:Destroy()

	local v50 = HumanoidRootPart2
	local v51, v52

	v50, v51, v52 = ipairs(v50:GetChildren())

	while true do
		v52, v49 = v50(v51, v52)

		if v52 == nil then
			break
		end

		if v49:IsA("Attachment") or v49.Name == "HasSnapped" then
			v49:Destroy()
		end
	end
end
local function v53(p16)
	v48()
	Part = Instance.new("Part")
	Part.Size = Vector3.new(0.5, 0.5, 0.5)
	Part.Transparency = 1
	Part.Anchored = true
	Part.CanCollide = false
	Part.Name = "FollowPart"
	Part.Parent = workspace

	local Attachment = Instance.new("Attachment", HumanoidRootPart2)
	local Attachment2 = Instance.new("Attachment", Part)
	local Attachment3 = Instance.new("Attachment", HumanoidRootPart2)
	local Attachment4 = Instance.new("Attachment", Part)

	AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Attachment0 = Attachment
	AlignPosition.Attachment1 = Attachment2
	AlignPosition.RigidityEnabled = true
	AlignPosition.Responsiveness = 200
	AlignPosition.MaxForce = math.huge
	AlignPosition.Parent = HumanoidRootPart2
	AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Attachment0 = Attachment3
	AlignOrientation.Attachment1 = Attachment4
	AlignOrientation.RigidityEnabled = true
	AlignOrientation.Responsiveness = 200
	AlignOrientation.MaxTorque = math.huge
	AlignOrientation.Parent = HumanoidRootPart2
	connection = RunService.RenderStepped:Connect(function()
		if not (p16 and p16.Parent) then
			return
		end

		local cFrame = p16.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)

		Part.CFrame = cFrame

		if HumanoidRootPart2:FindFirstChild("HasSnapped") then
			return
		end

		HumanoidRootPart2.CFrame = cFrame
		cFrame = Instance.new("BoolValue")
		cFrame.Name = "HasSnapped"
		cFrame.Parent = HumanoidRootPart2
	end)
end
local function v59()
	local v60 = n1
	local v61, v62, v63 = pairs(workspace.Live:GetChildren())
	local v64 = nil

	while true do
		local v65

		v63, v65 = v61(v62, v63)

		if v63 == nil then
			break
		end

		if v65:IsA("Model") and v65 ~= Character then
			local HumanoidRootPart3 = v65:FindFirstChild("HumanoidRootPart")
			local Humanoid2 = v65:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart3 and (Humanoid2 and Humanoid2.Health > 0) then
				Humanoid2 = (HumanoidRootPart3.Position - HumanoidRootPart2.Position).Magnitude

				if Humanoid2 <= v60 then
					if v65.Name == "Weakest Dummy" then
						v64 = HumanoidRootPart3
						v60 = Humanoid2
					elseif parent:GetPlayerFromCharacter(v65) then
						v64 = HumanoidRootPart3
						v60 = Humanoid2
					end
				end
			end
		end
	end

	return v64
end
local function v68(p17)
	u44 = true
	Frame.Visible = true
	Frame2.Size = UDim2.new(0, 0, 1, 0)

	for i = 0, p17 * 10 do
		local v72 = i / (p17 * 10)

		Frame2.Size = UDim2.new(v72, 0, 1, 0)
		TextLabel.Text = string.format("Cooldown: %.2f", p17 - i / 10)
		task.wait(0.1)
	end

	Frame.Visible = false
	u44 = false
end

function setupAnimEvent()
	Humanoid.AnimationPlayed:Connect(function(p18)
		if not (u42 and not u44) then
			return
		end

		local Animation = p18.Animation

		if not Animation then
			if not (Animation and t4[Animation]) then
				return
			end

			return
		end

		Animation = string.match(p18.Animation.AnimationId, "%d+")

		if not (Animation and t4[Animation]) then
			return
		end
	end)
end

setupAnimEvent()
t2[5]:Toggle({
	["Title"] = "Auto WallCombo Upper",
	["Default"] = false,
	["Callback"] = function(p19)
		u42 = p19
	end
})
parent = game:GetService("Players")
RunService = game:GetService("RunService")
parent = parent.LocalPlayer
LocalPlayer3 = parent.Character or parent.CharacterAdded:Wait()
HumanoidRootPart = LocalPlayer3:WaitForChild("HumanoidRootPart")
t1 = LocalPlayer3:WaitForChild("Communicate")

local Live = workspace:WaitForChild("Live")
local v73, v74, v75 = pairs({
	["rbxassetid://10468665991"] = true,
	["rbxassetid://10466974800"] = true,
	["rbxassetid://10471336737"] = true,
	["rbxassetid://12510170988"] = true,
	["rbxassetid://12272894215"] = true,
	["rbxassetid://12296882427"] = true,
	["rbxassetid://12307656616"] = true,
	["rbxassetid://101588604872680"] = true,
	["rbxassetid://105442749844047"] = true,
	["rbxassetid://109617620932970"] = true,
	["rbxassetid://131820095363270"] = true,
	["rbxassetid://135289891173395"] = true,
	["rbxassetid://125955606488863"] = true,
	["rbxassetid://12534735382"] = true,
	["rbxassetid://12502664044"] = true,
	["rbxassetid://12509505723"] = true,
	["rbxassetid://12618271998"] = true,
	["rbxassetid://12684390285"] = true,
	["rbxassetid://13376869471"] = true,
	["rbxassetid://13294790250"] = true,
	["rbxassetid://13376962659"] = true,
	["rbxassetid://13501296372"] = true,
	["rbxassetid://13556985475"] = true,
	["rbxassetid://145162735010"] = true,
	["rbxassetid://14046756619"] = true,
	["rbxassetid://14299135500"] = true,
	["rbxassetid://14351441234"] = true,
	["rbxassetid://15290930205"] = true,
	["rbxassetid://15145462680"] = true,
	["rbxassetid://15295895753"] = true,
	["rbxassetid://15295336270"] = true,
	["rbxassetid://16139108718"] = true,
	["rbxassetid://16515850153"] = true,
	["rbxassetid://16431491215"] = true,
	["rbxassetid://16597322398"] = true,
	["rbxassetid://16597912086"] = true,
	["rbxassetid://17799224866"] = true,
	["rbxassetid://17838006839"] = true,
	["rbxassetid://17857788598"] = true,
	["rbxassetid://18179181663"] = true,
	["rbxassetid://113166426814229"] = true,
	["rbxassetid://116753755471636"] = true,
	["rbxassetid://116153572280464"] = true,
	["rbxassetid://114095570398448"] = true,
	["rbxassetid://77509627104305"] = true
})
local t5 = {
	["rbxassetid://10469493270"] = true,
	["rbxassetid://10469630950"] = true,
	["rbxassetid://10469639222"] = true,
	["rbxassetid://10469643643"] = true,
	["rbxassetid://13532562418"] = true,
	["rbxassetid://13532600125"] = true,
	["rbxassetid://13532604085"] = true,
	["rbxassetid://13294471966"] = true,
	["rbxassetid://13491635433"] = true,
	["rbxassetid://13296577783"] = true,
	["rbxassetid://13295919399"] = true,
	["rbxassetid://13295936866"] = true,
	["rbxassetid://13370310513"] = true,
	["rbxassetid://13390230973"] = true,
	["rbxassetid://13378751717"] = true,
	["rbxassetid://13378708199"] = true,
	["rbxassetid://14004222985"] = true,
	["rbxassetid://13997092940"] = true,
	["rbxassetid://14001963401"] = true,
	["rbxassetid://14136436157"] = true,
	["rbxassetid://15259161390"] = true,
	["rbxassetid://15240216931"] = true,
	["rbxassetid://15240176873"] = true,
	["rbxassetid://15162694192"] = true,
	["rbxassetid://16515503507"] = true,
	["rbxassetid://16515520431"] = true,
	["rbxassetid://16515448089"] = true,
	["rbxassetid://16552234590"] = true,
	["rbxassetid://17889458563"] = true,
	["rbxassetid://17889461810"] = true,
	["rbxassetid://17889471098"] = true,
	["rbxassetid://17889290569"] = true,
	["rbxassetid://123005629431309"] = true,
	["rbxassetid://100059874351664"] = true,
	["rbxassetid://104895379416342"] = true
}
local t6 = {
	["rbxassetid://10479335397"] = true,
	["rbxassetid://13380255751"] = true,
	["rbxassetid://134775406437626"] = true
}

while true do
	v75 = v73(v74, v75)

	if v75 == nil then
		break
	end

	t5[v75] = true
end

local t7 = {}
local connection2 = nil

local function v80(p20, p21, p22)
	return (p20 - p21).Magnitude <= p22
end
local function v81()
	local PreySPeril = parent.Backpack:FindFirstChild("Prey\'s Peril")

	if PreySPeril then
		t1:FireServer({
			["Tool"] = PreySPeril,
			["Goal"] = "Console Move"
		})
	end

	PreySPeril = parent.Backpack:FindFirstChild("Split Second Counter")

	if not PreySPeril then
		return
	end

	t1:FireServer({
		["Tool"] = PreySPeril,
		["Goal"] = "Console Move"
	})
end

t2[4]:Toggle({
	["Title"] = "Auto Counter",
	["Default"] = false,
	["Callback"] = function(p23)
		if p23 then
			print("Auto Counter: ON")
			connection2 = RunService.Heartbeat:Connect(function()
				local v83 = Live
				local v84, v85

				v83, v84, v85 = pairs(v83:GetChildren())

				while true do
					local v86

					v85, v86 = v83(v84, v85)

					if v85 == nil then
						break
					end

					if v86:IsA("Model") and (v86 ~= LocalPlayer3 and v86:FindFirstChild("HumanoidRootPart")) then
						local Humanoid2 = v86:FindFirstChildOfClass("Humanoid")

						if Humanoid2 then
							Humanoid2 = Humanoid2:FindFirstChildOfClass("Animator")
						end

						if Humanoid2 then
							local v88, v89

							Humanoid2, v88, v89 = pairs(Humanoid2:GetPlayingAnimationTracks())

							while true do
								local AnimationId

								v89, AnimationId = Humanoid2(v88, v89)

								if v89 == nil then
									break
								end

								AnimationId = AnimationId.Animation.AnimationId

								local v91 = v86:GetDebugId() .. AnimationId
								local v92 = t6[AnimationId] and 13 or 13

								if (t6[AnimationId] or t5[AnimationId]) and v80(HumanoidRootPart.Position, v86.HumanoidRootPart.Position, v92) then
									if not t7[v91] then
										t7[v91] = true

										if t6[AnimationId] then
											task.delay(0.0001, v81)
										else
											v81()
										end
									end
								else
									t7[v91] = nil
								end
							end
						end
					end
				end
			end)
		else
			print("Auto Counter: OFF")

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			table.clear(t7)
		end
	end
})
t2[6]:Button({
	["Title"] = "M1 Reset",
	["Icon"] = "shield-check",
	["Callback"] = function()
		getgenv().keybinds = {
			["m1reset"] = Enum.KeyCode.R,
			["emotedash"] = Enum.KeyCode.T,
			["rotation"] = Enum.KeyCode.H
		}
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
	end
})
t2[6]:Button({
	["Title"] = "Kai Tech",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Kai"))()
	end
})
t2[6]:Button({
	["Title"] = "BackDash (Mobile)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		print("Clicked: BackDash (Mobile)")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/main/backdash%20mobile"))()
	end
})
t2[6]:Button({
	["Title"] = "BackDash (PC)",
	["Icon"] = "shield-check",
	["Callback"] = function()
		print("Clicked: BackDash (PC)")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/main/backdashpc"))()
	end
})
t2[6]:Button({
	["Title"] = "Auto UpperPunch",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/autoupperpunch%20(1).txt"))()
	end
})
t2[6]:Button({
	["Title"] = "Tornado Tech",
	["Icon"] = "shield-check",
	["Callback"] = function()
		print("Clicked: Tornado Tech")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Tornado%20Tech%20script"))()
	end
})
t2[6]:Button({
	["Title"] = "Kiba Tech V1",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/kiba.txt"))()
	end
})
t2[6]:Button({
	["Title"] = "Kiba Tech V2.1",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FixTooHighh.txt"))()
	end
})
t2[6]:Button({
	["Title"] = "Freeze Tech",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/hahahajjws.txt"))()
	end
})
t2[6]:Button({
	["Title"] = "Tornado Twisted",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/tornadotwisted.txt"))()
	end
})
t2[6]:Button({
	["Title"] = "Loop dash old",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_5502107740408834.lua.txt"))()
	end
})
t2[11]:Toggle({
	["Title"] = "Auto Farm Near",
	["Default"] = false,
	["Callback"] = function(p24)
		if p24 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/ATFN"))()
		else
			_G.StickFarmOn = false

			if not _G.StickFarmCleanup then
				return
			end

			_G.StickFarmCleanup()
			_G.StickFarmCleanup = nil
		end
	end
})
parent = game.Players.LocalPlayer

local Character2 = parent.Character or parent.CharacterAdded:Wait()

RunService = Character2

local v94 = Character2.WaitForChild(RunService, "HumanoidRootPart")
local CurrentCamera = workspace.CurrentCamera
local RunService2 = game:GetService("RunService")

RunService = Instance.new("ScreenGui")
RunService.Name = "StickGui"
RunService.ResetOnSpawn = false
RunService.Parent = parent:WaitForChild("PlayerGui")

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 120, 0, 50)
TextButton.Position = UDim2.new(0, 20, 0, 120)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Under"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.BorderSizePixel = 0
TextButton.Name = "StickButton"
TextButton.Visible = false
TextButton.Parent = RunService
RunService = Instance.new("UICorner")
RunService.CornerRadius = UDim.new(0, 12)
RunService.Parent = TextButton
TextButton.Active = true
TextButton.Draggable = true

local u98 = false
local u99 = nil
local connection3 = nil
local connection4 = nil
local CFrame_ = nil
local CameraType = nil

local function v104()
	local huge = math.huge
	local v106, v107, v108 = pairs(game.Players:GetPlayers())
	local v109 = nil

	while true do
		local v110

		v108, v110 = v106(v107, v108)

		if v108 == nil then
			break
		end

		if v110 ~= parent and v110.Character and (v110.Character:FindFirstChild("HumanoidRootPart") and v110.Character:FindFirstChild("Humanoid")) then
			local Magnitude = (v110.Character.HumanoidRootPart.Position - v94.Position).Magnitude

			if Magnitude < 10000 and v110.Character.Humanoid.Health > 0 then
				if Magnitude < huge then
					v109 = v110
					huge = Magnitude
				end
			end
		end
	end

	return v109
end
local function v112()
	connection4 = RunService2.Stepped:Connect(function()
		local v113 = Character2
		local v114, v115

		v113, v114, v115 = ipairs(v113:GetDescendants())

		while true do
			local v116

			v115, v116 = v113(v114, v115)

			if v115 == nil then
				break
			end

			if v116:IsA("BasePart") then
				v116.CanCollide = false
			end
		end
	end)
end
local function v117()
	local v118

	if not connection4 then
		v147 = Character2
		v147, v148, v149 = ipairs(v147:GetDescendants())

		while true do
			v149, v118 = v147(v148, v149)

			if v149 == nil then
				break
			end

			if v118:IsA("BasePart") then
				v118.CanCollide = true
			end
		end

		return
	end

	connection4:Disconnect()
	connection4 = nil

	local v119 = Character2
	local v120, v121

	v119, v120, v121 = ipairs(v119:GetDescendants())

	while true do
		v121, v118 = v119(v120, v121)

		if v121 == nil then
			break
		end

		if v118:IsA("BasePart") then
			v118.CanCollide = true
		end
	end
end
local function v122()
	CFrame_ = v94.CFrame
	CameraType = CurrentCamera.CameraType
	v112()
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	connection3 = RunService2.RenderStepped:Connect(function()
		if not u98 then
			return
		end

		if not (u99 and u99.Character) or (not u99.Character:FindFirstChild("HumanoidRootPart") or u99.Character:FindFirstChild("Humanoid").Health <= 0) then
			u99 = v104()
		end

		if not (u99 and u99.Character and u99.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		local Position = u99.Character.HumanoidRootPart.Position
		local Unit = (Position - v94.Position).Unit
		local v125 = Position - Vector3.new(0, 5, 0)
		local Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")

		if Humanoid2 then
			Humanoid2.PlatformStand = true
			Humanoid2.Sit = false
		end

		v94.Velocity = Vector3.zero
		v94.AssemblyLinearVelocity = Vector3.zero
		v94.RotVelocity = Vector3.zero
		v94.AssemblyAngularVelocity = Vector3.zero
		v94.CFrame = CFrame.new(v125, v125 + Unit)
		Unit = Position + Vector3.new(0, 14, 20)
		CurrentCamera.CFrame = CFrame.new(Unit, Position)
	end)
end
local function v127()
	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	v117()

	local Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")

	if Humanoid2 then
		Humanoid2.PlatformStand = false
	end

	if CFrame_ then
		v94.CFrame = CFrame_
	end

	if not CameraType then
		u99 = nil

		return
	end

	CurrentCamera.CameraType = CameraType
	u99 = nil
end

TextButton.MouseButton1Click:Connect(function()
	u98 = not u98
	TextButton.Text = u98 and "Under (On)" or "Under"

	if u98 then
		v122()
	else
		v127()
	end
end)
t2[11]:Toggle({
	["Title"] = "Under",
	["Default"] = false,
	["Callback"] = function(p25)
		TextButton.Visible = p25

		if p25 then
			u98 = true
			TextButton.Text = "Under (On)"
			v122()
		else
			u98 = false
			TextButton.Text = "Under"
			v127()
		end
	end
})
parent = game:GetService("Players")
RunService = game:GetService("RunService")
LocalPlayer3 = game:GetService("TweenService")
parent = parent.LocalPlayer

local Character3 = parent.Character or parent.CharacterAdded:Wait()

HumanoidRootPart = Character3

local v130 = Character3.WaitForChild(HumanoidRootPart, "HumanoidRootPart")

parent = Instance.new("ScreenGui", parent:WaitForChild("PlayerGui"))
parent.Name = "FollowGui"
parent.ResetOnSpawn = false

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(0, 50, 0, 50)
Frame3.Position = UDim2.new(0, 10, 0.4, 0)
Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame3.BackgroundTransparency = 0
Frame3.BorderSizePixel = 0
Frame3.Name = "FollowFrame"
Frame3.Parent = parent
Frame3.Active = true
Frame3.Draggable = true
Frame3.Visible = false
Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(1, 0, 1, 0)
TextButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextButton2.Text = "OFF"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.TextScaled = true
TextButton2.Font = Enum.Font.GothamBold
TextButton2.BorderSizePixel = 0
TextButton2.Active = true
TextButton2.Draggable = true
TextButton2.Parent = Frame3
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

local u133 = false
local connection5 = nil
local CFrame_2 = nil
local u136 = nil

local function v137()
	local v138, v139, v140 = ipairs(workspace:GetDescendants())
	local n2 = 300
	local v142 = nil

	while true do
		local Humanoid2

		v140, Humanoid2 = v138(v139, v140)

		if v140 == nil then
			break
		end

		if Humanoid2:IsA("Model") and Humanoid2 ~= Character3 then
			local HumanoidRootPart3 = Humanoid2:FindFirstChild("HumanoidRootPart")

			Humanoid2 = Humanoid2:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart3 and (Humanoid2 and Humanoid2.Health > 0) then
				Humanoid2 = (HumanoidRootPart3.Position - v130.Position).Magnitude

				if Humanoid2 < n2 then
					v142 = HumanoidRootPart3
					n2 = Humanoid2
				end
			end
		end
	end

	return v142
end
local function v145()
	if connection5 then
		connection5:Disconnect()
	end

	CFrame_2 = v130.CFrame
	u136 = v137()
	connection5 = RunService.RenderStepped:Connect(function()
		if not (u136 and u136.Parent and u136:IsDescendantOf(workspace)) then
			return
		end

		local v146 = u136
		local v150 = v146.CFrame.LookVector * -4.8

		v150 = v146.Position + v150

		local Position = v130.Position

		v130.CFrame = CFrame.new(Position:Lerp(v150, 0.2), v146.Position)
	end)
end
local function v151()
	if not CFrame_2 then
		return
	end

	local t8 = {
		["CFrame"] = CFrame_2
	}

	LocalPlayer3:Create(v130, TweenInfo.new(0.2, Enum.EasingStyle.Sine), t8):Play()
end

TextButton2.MouseButton1Click:Connect(function()
	u133 = not u133
	TextButton2.Text = u133 and "ON" or "OFF"
	TextButton2.BackgroundColor3 = u133 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(60, 60, 60)

	if u133 then
		v145()
	else
		if connection5 then
			connection5:Disconnect()
		end

		v151()
		u136 = nil
	end
end)
t2[11]:Toggle({
	["Title"] = "Behind",
	["Default"] = false,
	["Callback"] = function(p26)
		Frame3.Visible = p26

		if p26 then
			u133 = true
			TextButton2.Text = "ON"
			TextButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			v145()
		else
			u133 = false
			TextButton2.Text = "OFF"
			TextButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

			if connection5 then
				connection5:Disconnect()
			end

			v151()
			u136 = nil
		end
	end
})
parent = game:GetService("Players")
RunService = game:GetService("TweenService")
LocalPlayer3 = game:GetService("RunService")
parent = parent.LocalPlayer

local Character4 = parent.Character or parent.CharacterAdded:Wait()

HumanoidRootPart = Character4

local v152 = Character4.WaitForChild(HumanoidRootPart, "HumanoidRootPart")

parent = Instance.new("ScreenGui", parent:WaitForChild("PlayerGui"))
parent.Name = "FollowGui"
parent.ResetOnSpawn = false

local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(0, 50, 0, 50)
Frame4.Position = UDim2.new(0, 10, 0.1, 0)
Frame4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame4.BorderSizePixel = 0
Frame4.Name = "FollowFrame"
Frame4.Parent = parent
Frame4.Active = true
Frame4.Draggable = true
Frame4.Visible = false
Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

local TextButton3 = Instance.new("TextButton")

TextButton3.Size = UDim2.new(1, 0, 1, 0)
TextButton3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextButton3.Text = "OFF"
TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton3.TextScaled = true
TextButton3.Font = Enum.Font.GothamBold
TextButton3.BorderSizePixel = 0
TextButton3.Active = true
TextButton3.Draggable = true
TextButton3.Parent = Frame4
Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(1, 0)

local u155 = false
local AlignPosition2 = nil
local AlignOrientation2 = nil
local connection6 = nil
local Part2 = nil
local CFrame_3 = nil
local u161 = nil

local function v162()
	local v163, v164, v165 = ipairs(workspace:GetDescendants())
	local n3 = 300
	local v167 = nil

	while true do
		local Humanoid2

		v165, Humanoid2 = v163(v164, v165)

		if v165 == nil then
			break
		end

		if Humanoid2:IsA("Model") and Humanoid2 ~= Character4 then
			local HumanoidRootPart3 = Humanoid2:FindFirstChild("HumanoidRootPart")

			Humanoid2 = Humanoid2:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart3 and (Humanoid2 and Humanoid2.Health > 0) then
				Humanoid2 = (HumanoidRootPart3.Position - v152.Position).Magnitude

				if Humanoid2 < n3 then
					v167 = HumanoidRootPart3
					n3 = Humanoid2
				end
			end
		end
	end

	return v167
end
local function v170(p27)
	CFrame_3 = v152.CFrame

	if AlignPosition2 then
		AlignPosition2:Destroy()
	end

	if AlignOrientation2 then
		AlignOrientation2:Destroy()
	end

	if connection6 then
		connection6:Disconnect()
	end

	if Part2 then
		Part2:Destroy()
	end

	local children, Attachment, Attachment2 = v152:GetChildren()

	while true do
		Attachment2, v205 = children(Attachment, Attachment2)

		if Attachment2 == nil then
			break
		end

		if v205:IsA("Attachment") then
			v205:Destroy()
		end
	end

	Part2 = Instance.new("Part")
	Part2.Size = Vector3.new(0.5, 0.5, 0.5)
	Part2.Transparency = 1
	Part2.Anchored = true
	Part2.CanCollide = false
	Part2.Name = "FollowAttachPart"
	Part2.Parent = workspace
	children = Instance.new("Attachment", v152)
	Attachment = Instance.new("Attachment", Part2)
	Attachment2 = Instance.new("Attachment", v152)

	local Attachment3 = Instance.new("Attachment", Part2)

	AlignPosition2 = Instance.new("AlignPosition")
	AlignPosition2.Attachment0 = children
	AlignPosition2.Attachment1 = Attachment
	AlignPosition2.RigidityEnabled = true
	AlignPosition2.Responsiveness = 200
	AlignPosition2.MaxForce = math.huge
	AlignPosition2.Parent = v152
	AlignOrientation2 = Instance.new("AlignOrientation")
	AlignOrientation2.Attachment0 = Attachment2
	AlignOrientation2.Attachment1 = Attachment3
	AlignOrientation2.RigidityEnabled = true
	AlignOrientation2.Responsiveness = 200
	AlignOrientation2.MaxTorque = math.huge
	AlignOrientation2.Parent = v152
	connection6 = LocalPlayer3.RenderStepped:Connect(function()
		if not u155 then
			return
		end

		if not (p27 and p27.Parent and p27:IsDescendantOf(workspace)) then
			return
		end

		Part2.CFrame = p27.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
	end)
end
local function v175()
	u155 = false

	if AlignPosition2 then
		AlignPosition2:Destroy()
	end

	if AlignOrientation2 then
		AlignOrientation2:Destroy()
	end

	if connection6 then
		connection6:Disconnect()
	end

	if Part2 then
		Part2:Destroy()
	end

	local children, v177, v178 = v152:GetChildren()

	while true do
		local v179

		v178, v179 = children(v177, v178)

		if v178 == nil then
			break
		end

		if v179:IsA("Attachment") then
			v179:Destroy()
		end
	end

	if not CFrame_3 then
		return
	end

	children = {
		["CFrame"] = CFrame_3
	}
	RunService:Create(v152, TweenInfo.new(0.001, Enum.EasingStyle.Sine), children):Play()
end

TextButton3.MouseButton1Click:Connect(function()
	u155 = not u155
	TextButton3.Text = u155 and "ON" or "OFF"
	TextButton3.BackgroundColor3 = u155 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)

	if u155 then
		u161 = v162()

		if u161 then
			v170(u161)
		else
			TextButton3.Text = "NO TARGET"
			u155 = false
		end
	else
		v175()
		u161 = nil
	end
end)
t2[11]:Toggle({
	["Title"] = "Upper",
	["Default"] = false,
	["Callback"] = function(p28)
		Frame4.Visible = p28
	end
})

local Lighting = game:GetService("Lighting")

local function v181()
	local v182 = Lighting
	local v183, v184

	v182, v183, v184 = pairs(v182:GetChildren())

	while true do
		local v185

		v184, v185 = v182(v183, v184)

		if v184 == nil then
			break
		end

		if v185:IsA("PostEffect") or v185:IsA("Atmosphere") then
			v185:Destroy()
		end
	end
end

local handlers = {
	["Morning"] = function()
		local ColorCorrectionEffect = Lighting

		ColorCorrectionEffect = Lighting
		Lighting.Brightness = 3
		ColorCorrectionEffect.ClockTime = 7.5
		ColorCorrectionEffect.TimeOfDay = "07:30:00"
		Lighting.OutdoorAmbient = Color3.fromRGB(180, 200, 220)
		Instance.new("Atmosphere", Lighting):SetAttribute("Config", {
			["Density"] = 0.3,
			["Color"] = Color3.fromRGB(200, 220, 255),
			["Decay"] = Color3.fromRGB(255, 240, 200)
		})
		ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)

		local color3 = Color3.fromRGB(255, 255, 230)

		ColorCorrectionEffect.Brightness = 0.1
		ColorCorrectionEffect.Contrast = 0.15
		ColorCorrectionEffect.Saturation = 0.05
		ColorCorrectionEffect.TintColor = color3
		Instance.new("SunRaysEffect", Lighting).Intensity = 0.25
	end,
	["Afternoon"] = function()
		local Atmosphere = Lighting

		Atmosphere = Lighting
		Lighting.Brightness = 3.5
		Atmosphere.ClockTime = 15
		Atmosphere.TimeOfDay = "15:00:00"
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 230)
		Atmosphere = Instance.new("Atmosphere", Lighting)

		local color3 = Color3.fromRGB(220, 235, 255)

		Atmosphere.Decay = Color3.fromRGB(255, 220, 180)
		Atmosphere.Color = color3
		Atmosphere.Density = 0.25
		Atmosphere = Instance.new("ColorCorrectionEffect", Lighting)
		color3 = Color3.fromRGB(255, 245, 210)
		Atmosphere.Brightness = 0.05
		Atmosphere.Contrast = 0.2
		Atmosphere.Saturation = 0.1
		Atmosphere.TintColor = color3
		Instance.new("SunRaysEffect", Lighting).Intensity = 0.35
	end,
	["Ultra Shader Pro (HD+)"] = function()
		local Atmosphere = Lighting

		Atmosphere = Lighting
		Lighting.TimeOfDay = "11:00:00"
		Atmosphere.ClockTime = 11
		Atmosphere.Brightness = 3.2
		Atmosphere = Lighting
		Atmosphere = Lighting
		Lighting.GlobalShadows = true
		Atmosphere.EnvironmentSpecularScale = 1
		Atmosphere.EnvironmentDiffuseScale = 1
		Atmosphere = Lighting
		Atmosphere = Lighting

		local color3 = Color3.fromRGB(75, 75, 75)

		Atmosphere.Ambient = Color3.fromRGB(105, 105, 105)
		Atmosphere.OutdoorAmbient = color3
		Atmosphere = Lighting
		Lighting.FogColor = Color3.fromRGB(235, 235, 235)
		Atmosphere.FogEnd = 150000
		Atmosphere = Instance.new("Atmosphere", Lighting)
		Atmosphere.Haze = 1
		Atmosphere.Glare = 0.2
		Atmosphere.Offset = 0.2
		Atmosphere.Density = 0.1
		color3 = Color3.fromRGB(255, 255, 255)
		Atmosphere.Decay = Color3.fromRGB(180, 180, 180)
		Atmosphere.Color = color3
		Atmosphere = Instance.new("BloomEffect", Lighting)
		Atmosphere.Size = 38
		Atmosphere.Threshold = 1
		Atmosphere.Intensity = 0.85
		Atmosphere = Instance.new("DepthOfFieldEffect", Lighting)
		Atmosphere.FarIntensity = 0.03
		Atmosphere.NearIntensity = 0.15
		Atmosphere.InFocusRadius = 50
		Atmosphere.FocusDistance = 90
		Atmosphere = Instance.new("ColorCorrectionEffect", Lighting)
		Atmosphere.TintColor = Color3.fromRGB(255, 255, 255)
		Atmosphere.Saturation = 0.15
		Atmosphere.Contrast = 0.22
		Atmosphere.Brightness = 0.06
		Atmosphere = Instance.new("SunRaysEffect", Lighting)
		Atmosphere.Spread = 0
		Atmosphere.Intensity = 0
	end
}

local function v193(p29)
	v181()

	if not handlers[p29] then
		return
	end

	handlers[p29]()
end

local s2 = "Morning"

t2[10]:Dropdown({
	["Title"] = "Select Shader",
	["Values"] = { "Morning", "Afternoon", "Ultra Shader Pro (HD+)" },
	["Value"] = "Morning",
	["Callback"] = function(p30)
		s2 = p30
		lib:Notify({
			["Title"] = "Shader Changed",
			["Content"] = "Selected: " .. p30,
			["Duration"] = 2
		})
	end
})
t2[10]:Button({
	["Title"] = "Apply Shader",
	["Icon"] = "shield-check",
	["Callback"] = function()
		v193(s2)
	end
})
t2[12]:Button({
	["Title"] = "Our Hub ( by IDK )",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/IDKHub/main/Hub"))()
	end
})
t2[9]:Button({
	["Title"] = "Rejoin",
	["Icon"] = "shield-check",
	["Callback"] = function()
		local TeleportService = game:GetService("TeleportService")
		local LocalPlayer4 = game.Players.LocalPlayer
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "RejoinGui"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.Parent = LocalPlayer4:WaitForChild("PlayerGui")

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel2.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextScaled = true
		TextLabel2.Parent = ScreenGui

		for i = 0.5, 1, -1 do
			TextLabel2.Text = "Rejoining in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui:Destroy()
		TeleportService:Teleport(game.PlaceId, LocalPlayer4)
	end
})
t2[9]:Button({
	["Title"] = "Server Hop",
	["Icon"] = "shield-check",
	["Callback"] = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer4 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui = Instance.new("ScreenGui", LocalPlayer4:WaitForChild("PlayerGui"))

		ScreenGui.Name = "ServerHopGui"
		ScreenGui.ResetOnSpawn = false

		local TextLabel2 = Instance.new("TextLabel", ScreenGui)

		TextLabel2.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel2.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextScaled = true

		for i = 2, 1, -1 do
			TextLabel2.Text = "Hopping in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui:Destroy()
		HttpService = (function()
			local t9 = {}
			local ok, result = pcall(function()
				return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			end)

			if not (ok and (result and result.data)) then
				return #t9 > 0 and t9[math.random(1, #t9)] or nil
			end

			local v210

			ok, result, v210 = pairs(result.data)

			while true do
				local v211

				v210, v211 = ok(result, v210)

				if v210 == nil then
					break
				end

				if v211.playing < v211.maxPlayers and v211.id ~= game.JobId then
					table.insert(t9, v211.id)
				end
			end

			return #t9 > 0 and t9[math.random(1, #t9)] or nil
		end)()

		if HttpService then
			TeleportService:TeleportToPlaceInstance(PlaceId, HttpService, LocalPlayer4)
		else
			warn("Miss")
		end
	end
})
t2[9]:Button({
	["Title"] = "Small Server",
	["Icon"] = "shield-check",
	["Callback"] = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer4 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui = Instance.new("ScreenGui", LocalPlayer4:WaitForChild("PlayerGui"))

		ScreenGui.Name = "SmallServerGui"
		ScreenGui.ResetOnSpawn = false

		local TextLabel2 = Instance.new("TextLabel", ScreenGui)

		TextLabel2.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel2.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextScaled = true

		for i = 2, 1, -1 do
			TextLabel2.Text = "T\195\172m server < 5 ng\198\176\225\187\157i trong " .. i .. "..."
			task.wait(1)
		end

		ScreenGui:Destroy()
		HttpService = (function()
			local s3 = ""
			local t10 = {}

			for _ = 1, 2 do
				local v222 = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

				if s3 ~= "" then
					v222 = v222 .. "&cursor=" .. s3
				end

				local result

				s3, result = pcall(function()
					return HttpService:JSONDecode(game:HttpGet(v222))
				end)

				if not (s3 and (result and result.data)) then
					return #t10 > 0 and t10[math.random(1, #t10)] or nil
				end

				local v224, v225

				s3, v224, v225 = pairs(result.data)

				while true do
					local v226

					v225, v226 = s3(v224, v225)

					if v225 == nil then
						break
					end

					if v226.playing < 2 and v226.id ~= game.JobId then
						table.insert(t10, v226.id)
					end
				end

				if not result.nextPageCursor then
					return #t10 > 0 and t10[math.random(1, #t10)] or nil
				end

				s3 = result.nextPageCursor
			end

			return #t10 > 0 and t10[math.random(1, #t10)] or nil
		end)()

		if HttpService then
			TeleportService:TeleportToPlaceInstance(PlaceId, HttpService, LocalPlayer4)
		else
			warn("Miss")
		end
	end
})
t2[9]:Button({
	["Title"] = "Check Ping",
	["Icon"] = "shield-check",
	["Callback"] = function()
		local LocalPlayer4 = game:GetService("Players").LocalPlayer
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "PingDisplay"
		ScreenGui.ResetOnSpawn = false

		local v229 = LocalPlayer4

		ScreenGui.Parent = LocalPlayer4.WaitForChild(v229, "PlayerGui")

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(0, 150, 0, 40)
		TextLabel2.Position = UDim2.new(1, -160, 0, 10)
		TextLabel2.BackgroundTransparency = 0.4
		TextLabel2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 20
		TextLabel2.Text = "PING: -- ms"
		TextLabel2.Parent = ScreenGui
		spawn(function()
			while true do
				local v231 = LocalPlayer4

				v231 = math.floor(v231:GetNetworkPing() * 1000)
				TextLabel2.Text = "PING: " .. v231 .. " ms"

				if v231 <= 80 then
					TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 0)
				elseif v231 <= 150 then
					TextLabel2.TextColor3 = Color3.fromRGB(255, 170, 0)
				else
					TextLabel2.TextColor3 = Color3.fromRGB(255, 0, 0)
				end

				wait(1)
			end
		end)
	end
})
t2[8]:Toggle({
	["Title"] = "Anti Afk",
	["Default"] = false,
	["Callback"] = function(p31)
		if p31 then
			getgenv().AntiAFK_Connection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
				local VirtualUser = game:GetService("VirtualUser")

				VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			end)
			warn("[ AntiAFK]: Enabled")
		else
			if getgenv().AntiAFK_Connection then
				getgenv().AntiAFK_Connection:Disconnect()
				getgenv().AntiAFK_Connection = nil
			end

			warn("[ AntiAFK]: Disabled")
		end
	end
})
t2[13]:Button({
	["Title"] = "Infinite Yield",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})
t2[13]:Button({
	["Title"] = "Nameless",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://github.com/FilteringEnabled/NamelessAdmin/blob/main/Source?raw=true"))()
	end
})

local LocalPlayer4 = game:GetService("Players").LocalPlayer
local u234 = false

local function v235(p32)
	local v236, v237, v238 = pairs(p32:GetDescendants())

	while true do
		local v239

		v238, v239 = v236(v237, v238)

		if v238 == nil then
			break
		end

		if v239:IsA("BallSocketConstraint") or v239:IsA("HingeConstraint") then
			v239:Destroy()
		end
	end
end
local function v240() end

parent = function(character)
	if not u234 then
		return
	end

	task.wait(0.5)
	v235(character)
end
LocalPlayer4.CharacterAdded:Connect(parent)
t2[8]:Toggle({
	["Title"] = "Anti Ragdoll",
	["Default"] = false,
	["Callback"] = function(p33)
		u234 = p33

		if p33 then
			if not LocalPlayer4.Character then
				return
			end

			v235(LocalPlayer4.Character)
		else
			v240()
		end
	end
})
parent = game:GetService("Players")

local RunService3 = game:GetService("RunService")
local LocalPlayer5 = parent.LocalPlayer
local CurrentCamera2 = workspace.CurrentCamera
local u244 = false
local connection7 = nil

t2[8]:Toggle({
	["Title"] = "Anti Camlock",
	["Default"] = false,
	["Callback"] = function(p34)
		u244 = p34

		if p34 then
			connection7 = RunService3.RenderStepped:Connect(function()
				local Character5 = LocalPlayer5.Character

				if Character5 then
					Character5 = LocalPlayer5.Character:FindFirstChildWhichIsA("Humanoid")
				end

				if not (Character5 and CurrentCamera2.CameraSubject ~= Character5) then
					return
				end

				CurrentCamera2.CameraSubject = Character5
			end)
		else
			if not connection7 then
				return
			end

			connection7:Disconnect()
			connection7 = nil
		end
	end
})
t2[8]:Button({
	["Title"] = "Anti lag ( Remove effect )",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Protected_5743487458031851.lua.txt"))()
	end
})
t2[6]:Button({
	["Title"] = "All in one",
	["Icon"] = "shield-check",
	["Callback"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/alltechsceiot.txt"))()
	end
})
v2:Tag({
	["Title"] = "v3.3",
	["Color"] = Color3.fromHex("#30ff6a")
})
v2:Tag({
	["Title"] = "Beta",
	["Color"] = Color3.fromHex("#315dff")
})

local v247 = v2:Tag({
	["Title"] = "--:--",
	["Radius"] = 0,
	["Color"] = lib:Gradient({
		["0"] = {
			["Color"] = Color3.fromHex("#FF0F7B"),
			["Transparency"] = 0
		},
		["100"] = {
			["Color"] = Color3.fromHex("#F89B29"),
			["Transparency"] = 0
		}
	}, {
		["Rotation"] = 45
	})
})
local n4 = 0

task.spawn(function()
	while true do
		local v249 = os.date("*t")
		local v250 = string.format("%02d", v249.hour)

		v249 = string.format("%02d", v249.min)
		n4 = (n4 + 0.01) % 1
		Color3.fromHSV(n4, 1, 1)
		v247:SetTitle(v250 .. ":" .. v249)
		task.wait(0.06)
	end
end)
v2:CreateTopbarButton("theme-switcher", "moon", function()
	lib:SetTheme(lib:GetCurrentTheme() == "Dark" and "Light" or "Dark")

	local v251 = lib
	local Notify = v251.Notify
	local t11 = {
		["Title"] = "Theme Changed",
		["Content"] = "Current theme: " .. lib:GetCurrentTheme(),
		["Duration"] = 2
	}

	Notify(v251, t11)
end, 990)
v2:OnClose(function()
	print("WindUI closed")
	lib:Notify({
		["Title"] = "Closed",
		["Content"] = "Window has been closed.",
		["Duration"] = 0
	})
end)
t2[10]:Toggle({
	["Title"] = "Ultra Shader",
	["Default"] = false,
	["Callback"] = function(p35)
		if p35 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/US(L1)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/US(L2)"))()
		end
	end
})
parent = {
	["Settings"] = v2:Section({
		["Title"] = "Change",
		["Opened"] = true
	}),
	["Utilities"] = v2:Section({
		["Title"] = "Config",
		["Opened"] = true
	})
}
parent = {
	["Appearance"] = parent.Settings:Tab({
		["Title"] = "Change Color Grou",
		["Icon"] = "brush"
	}),
	["Config"] = parent.Utilities:Tab({
		["Title"] = "Config",
		["Icon"] = "settings"
	})
}
parent.Config:Paragraph({
	["Title"] = "Configuration Manager",
	["Desc"] = "Save and load your settings",
	["Image"] = "save",
	["ImageSize"] = 20,
	["Color"] = "White"
})
parent.Config:Slider({
	["Title"] = "Ui Transparency",
	["Value"] = {
		["Min"] = 0,
		["Max"] = 1,
		["Default"] = 0.2
	},
	["Step"] = 0.1,
	["Callback"] = function(p36)
		lib.TransparencyValue = tonumber(p36)
		v2:ToggleTransparency(tonumber(p36) > 0)
	end
})

local savedAs = "default"

RunService = nil
LocalPlayer3 = {
	["name"] = "Player1",
	["level"] = 1,
	["inventory"] = { "sword", "shield", "potion" }
}
parent.Config:Input({
	["Title"] = "Config Name",
	["Value"] = savedAs,
	["Callback"] = function(p37)
		savedAs = p37 or "default"
	end
})
HumanoidRootPart = v2.ConfigManager

if HumanoidRootPart then
	HumanoidRootPart:Init(v2)
	parent.Config:Button({
		["Title"] = "Save config",
		["Icon"] = "save",
		["Variant"] = "Primary",
		["Callback"] = function()
			RunService = HumanoidRootPart:CreateConfig(savedAs)
			RunService:Register("featureToggle", featureToggle)
			RunService:Register("intensitySlider", intensitySlider)
			RunService:Register("modeDropdown", modeDropdown)
			RunService:Register("themeDropdown", themeDropdown)
			RunService:Register("transparencySlider", transparencySlider)
			RunService:Set("playerData", LocalPlayer3)
			RunService:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))

			if RunService:Save() then
				lib:Notify({
					["Title"] = "loc:SAVE_CONFIG",
					["Content"] = "Saved as: " .. savedAs,
					["Icon"] = "check",
					["Duration"] = 3
				})
			else
				lib:Notify({
					["Title"] = "Error",
					["Content"] = "Failed to save config",
					["Icon"] = "x",
					["Duration"] = 3
				})
			end
		end
	})
	parent.Config:Button({
		["Title"] = "Load config",
		["Icon"] = "folder",
		["Callback"] = function()
			RunService = HumanoidRootPart:CreateConfig(savedAs)

			local v255 = RunService:Load()

			if v255 then
				if v255.playerData then
					LocalPlayer3 = v255.playerData
				end

				lib:Notify({
					["Title"] = "Load config",
					["Content"] = "Loaded: " .. savedAs .. "\nLast save: " .. (v255.lastSave or "Unknown"),
					["Icon"] = "refresh-cw",
					["Duration"] = 5
				})
				parent.Config:Paragraph({
					["Title"] = "Player Data",
					["Desc"] = string.format("Name: %s\nLevel: %d\nInventory: %s", LocalPlayer3.name, LocalPlayer3.level, table.concat(LocalPlayer3.inventory, ", "))
				})
			else
				lib:Notify({
					["Title"] = "Error",
					["Content"] = "Failed to load config",
					["Icon"] = "x",
					["Duration"] = 3
				})
			end
		end
	})
else
	parent.Config:Paragraph({
		["Title"] = "Config Manager Not Available",
		["Desc"] = "This feature requires ConfigManager",
		["Image"] = "alert-triangle",
		["ImageSize"] = 20,
		["Color"] = "White"
	})
end

lib = game:GetService("Players").LocalPlayer

local Character5 = lib.Character or lib.CharacterAdded:Wait()

v2 = {
	["red"] = Color3.fromRGB(255, 0, 0),
	["green"] = Color3.fromRGB(0, 255, 0),
	["blue"] = Color3.fromRGB(0, 0, 255),
	["yellow"] = Color3.fromRGB(255, 255, 0),
	["orange"] = Color3.fromRGB(255, 165, 0),
	["pink"] = Color3.fromRGB(255, 105, 180),
	["purple"] = Color3.fromRGB(128, 0, 128),
	["brown"] = Color3.fromRGB(139, 69, 19),
	["gray"] = Color3.fromRGB(128, 128, 128),
	["black"] = Color3.fromRGB(0, 0, 0),
	["white"] = Color3.fromRGB(255, 255, 255),
	["cyan"] = Color3.fromRGB(0, 255, 255),
	["magenta"] = Color3.fromRGB(255, 0, 255),
	["lime"] = Color3.fromRGB(191, 255, 0),
	["indigo"] = Color3.fromRGB(75, 0, 130),
	["violet"] = Color3.fromRGB(238, 130, 238),
	["gold"] = Color3.fromRGB(255, 215, 0),
	["silver"] = Color3.fromRGB(192, 192, 192),
	["navy"] = Color3.fromRGB(0, 0, 128),
	["teal"] = Color3.fromRGB(0, 128, 128),
	["maroon"] = Color3.fromRGB(128, 0, 0),
	["olive"] = Color3.fromRGB(128, 128, 0),
	["aqua"] = Color3.fromRGB(0, 255, 255),
	["coral"] = Color3.fromRGB(255, 127, 80),
	["chocolate"] = Color3.fromRGB(210, 105, 30),
	["khaki"] = Color3.fromRGB(240, 230, 140),
	["lavender"] = Color3.fromRGB(230, 230, 250),
	["beige"] = Color3.fromRGB(245, 245, 220),
	["crimson"] = Color3.fromRGB(220, 20, 60),
	["slate"] = Color3.fromRGB(112, 128, 144)
}

local v257 = nil
local u258 = false
local connection8 = nil

local function v260(p38, p39)
	if not (p38:IsA("ParticleEmitter") or (p38:IsA("Trail") or p38:IsA("Beam"))) then
		return
	end

	p38.Color = ColorSequence.new(p39)
end
local function v261(p40, p41)
	if connection8 then
		connection8:Disconnect()
		connection8 = nil
	end

	local v262, v263, v264 = ipairs(p40:GetDescendants())

	while true do
		local v265

		v264, v265 = v262(v263, v264)

		if v264 == nil then
			break
		end

		v260(v265, p41)
	end

	connection8 = p40.DescendantAdded:Connect(function(descendant)
		if not u258 then
			return
		end

		v260(descendant, p41)
	end)
end

RunService = function(p42)
	local v266, v267, v268 = ipairs(p42:GetDescendants())

	while true do
		local v269

		v268, v269 = v266(v267, v268)

		if v268 == nil then
			break
		end

		if v269:IsA("ParticleEmitter") or (v269:IsA("Trail") or v269:IsA("Beam")) then
			v269:Destroy()
		end
	end

	u258 = false

	if not connection8 then
		return
	end

	connection8:Disconnect()
	connection8 = nil
end
lib.CharacterAdded:Connect(function(character)
	Character5 = character

	if not (u258 and v257) then
		return
	end

	v261(character, v257)
end)
lib, LocalPlayer3, HumanoidRootPart = pairs(v2)

local v270 = Character5
local v271 = v261
local u272 = u258
local u273 = v257

t1 = {}

while true do
	HumanoidRootPart, t2 = lib(LocalPlayer3, HumanoidRootPart)

	if HumanoidRootPart == nil then
		break
	end

	table.insert(t1, HumanoidRootPart)
end

table.sort(t1)
parent.Appearance:Dropdown({
	["Title"] = "Select Color",
	["Values"] = t1,
	["Callback"] = function(p43)
		if not v2[p43] then
			return
		end

		u273 = v2[p43]
	end
})
parent.Appearance:Button({
	["Title"] = "Apply Color",
	["Icon"] = "brush",
	["Callback"] = function()
		if u273 then
			u272 = true
			v271(v270, u273)
			print("VFX color changed to " .. tostring(u273))
		else
			warn("Please select a color first!")
		end
	end
})
parent.Appearance:Button({
	["Title"] = "Reset Color",
	["Icon"] = "rotate-ccw",
	["Callback"] = function()
		RunService(v270)
		print("VFX reset to default")
	end
})
parent.Appearance:Button({
	["Title"] = "Changer Color By Dovi",
	["Icon"] = "rotate-ccw",
	["Callback"] = function()
		print("")
	end
})
