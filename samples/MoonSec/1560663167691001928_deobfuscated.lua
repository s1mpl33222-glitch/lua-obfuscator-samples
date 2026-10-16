local u1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

u1:Localization({
	Enabled = true,
	Prefix = "loc:",
	DefaultLanguage = "en",
	Translations = {
		en = {
			WINDUI_EXAMPLE = "YQANTG",
			WELCOME = "Welcome to YQANTG V3.3",
			LIB_DESC = "Thanks for use my script",
			FEATURES = "Misc",
			TAB1 = "New",
			TAB2 = "Auto Block",
			TAB3 = "Camlock",
			TAB4 = "Local",
			TAB5 = "Other",
			TAB6 = "Tech",
			TAB7 = "Movest",
			TAB8 = "Anti",
			TAB9 = "Server",
			TAB10 = "Shader",
			TAB11 = "Farm",
			TAB12 = "Hub",
			TAB13 = "Admin"
		}
	}
})
u1:SetTheme("Dark")
u1.TransparencyValue = 0.2

local u2 = u1:CreateWindow({
	Title = "loc:WINDUI_EXAMPLE",
	Icon = "geist:window",
	Author = "loc:WELCOME",
	Folder = "WindUI_Example",
	Size = UDim2.fromOffset(300, 300),
	Theme = "Dark"
})
local t1 = {
	Main = u2:Section({
		Title = "loc:FEATURES",
		Opened = true
	})
}
local t2 = {}

for i = 1, 13 do
	t2[i] = t1.Main:Tab({
		Title = "loc:TAB" .. i,
		Icon = ({
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
		})[i],
		Desc = "This is Tab " .. i
	})
end

t2[7]:Button({
	Title = "Basic Emote",
	Icon = "shield-check",
	Callback = function()
		getgenv().GuiKeybind = "T"
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/EmoteGui/refs/heads/main/Protected_4900496055951847.lua"))()
	end
})
t2[7]:Button({
	Title = "Emerge Emote",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/HAHAHHA/refs/heads/main/EmergeButLow", true))()
	end
})
t2[7]:Button({
	Title = "Sukuna Emote",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/Sukunaslash/refs/heads/main/WorldCuttingSlash", true))()
	end
})
t2[7]:Button({
	Title = "MIUI",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()
	end
})
t2[7]:Button({
	Title = "Gojo v2 (Saitama)",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-The-Strongest-Battleground-Gojo-manga-Tsb-30660"))()
	end
})
t2[7]:Button({
	Title = "Overhaul (Saitama)",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/SaitamaOverhaul/refs/heads/main/Latest.lua"))()
	end
})
t2[7]:Button({
	Title = "Movest UI",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://gist.githubusercontent.com/proscripter400/b24547203a4cc12bdcfe77fd13dd7580/raw/fb8048c0d5b59d626879b1a06cfedaae3e7ee205/charhub"))()
	end
})
t2[7]:Button({
	Title = "Wally West (Saitama)",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Nova2ezz/west/refs/heads/main/Protected_4638864115822087.lua.txt"))()
	end
})
t2[7]:Button({
	Title = "Orbitical Warrior (Saitama)",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AeryAlex/Scripts/refs/heads/main/Orbitical%20Warrior%20(Obsfucted).lua"))()
	end
})
t2[7]:Button({
	Title = "Sukuna v2 (Saitama)",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-The-Strongest-Battleground-heian-sukuna-Moveset-30680"))()
	end
})
t2[1]:Button({
	Title = "New Ui",
	Icon = "shield-check",
	Callback = function()
		print("")
	end
})
t2[1]:Button({
	Title = "Fix some bug",
	Icon = "shield-check",
	Callback = function()
		print("")
	end
})
t2[2]:Button({
	Title = "Auto Block V11",
	Icon = "shield-plus",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/CombatGUI/refs/heads/main/TSBCombatGUI"))()
	end
})
t2[2]:Button({
	Title = "Auto Block V6",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6520709616677918.lua.txt"))()
	end
})
t2[3]:Button({
	Title = "Slient Aim Rework",
	Icon = "target",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6124417452209241.lua.txt"))()
	end
})
t2[3]:Button({
	Title = "Bot Follow + Slient Aim",
	Icon = "bot",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Bot"))()
	end
})
t2[3]:Button({
	Title = "Camlock",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/HomeMadeScripts/Camlock-aimlock/main/obf_Wxr6QgzF76G1y2Ch77KN4Zt5Nz0A6GIl61gitv3mRR2t3V103al5d0g26s4KY04r.lua.txt"))()
	end
})
t2[4]:Button({
	Title = "Free emote slots",
	Icon = "smile",
	Callback = function()
		game.Players.LocalPlayer:SetAttribute("ExtraSlots", true)
	end
})
t2[4]:Toggle({
	Title = "No Dash Cooldown",
	Default = false,
	Callback = function(p1)
		if not p1 then
			workspace:SetAttribute("NoDashCooldown", false)
		else
			workspace:SetAttribute("VIPServer", tostring(game.Players.LocalPlayer.UserId))
			workspace:SetAttribute("VIPServerOwner", game.Players.LocalPlayer.Name)
			workspace:SetAttribute("NoDashCooldown", true)
		end
	end
})

local LocalPlayer = game:GetService("Players").LocalPlayer

t2[4]:Toggle({
	Title = "Auto Respawn",
	Default = false,
	Callback = function(p2)
		-- upvalues: LocalPlayer (ref)
		if not p2 then
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
		else
			getgenv().RespawnAtDeathPos = true

			if getgenv()._RespawnConn then
				getgenv()._RespawnConn:Disconnect()
			end

			if getgenv()._DiedConn then
				getgenv()._DiedConn:Disconnect()
			end

			local function u230()
				-- upvalues: LocalPlayer (ref)
				local v331 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local Humanoid = v331:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart = v331:FindFirstChild("HumanoidRootPart")

				if Humanoid and HumanoidRootPart then
					if getgenv()._DiedConn then
						getgenv()._DiedConn:Disconnect()
					end

					getgenv()._DiedConn = Humanoid.Died:Connect(function()
						-- upvalues: HumanoidRootPart (ref)
						if getgenv().RespawnAtDeathPos then
							getgenv()._LastDeathPosition = HumanoidRootPart.Position
						end
					end)
				end
			end

			getgenv()._RespawnConn = LocalPlayer.CharacterAdded:Connect(function(character)
				-- upvalues: u230 (ref)
				task.spawn(function()
					-- upvalues: character (ref), u230 (ref)
					if getgenv().RespawnAtDeathPos and getgenv()._LastDeathPosition then
						local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

						if HumanoidRootPart then
							HumanoidRootPart.CFrame = CFrame.new(getgenv()._LastDeathPosition + Vector3.new(0, 3, 0))
						end
					end

					u230()
				end)
			end)
			u230()
			print("Auto Respawn: ON")
		end
	end
})
t2[4]:Toggle({
	Title = "Auto Fake Out",
	Default = false,
	Callback = function(p3)
		if not p3 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/L2(FO)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/L1(FO)"))()
		end
	end
})

local LocalPlayer2 = game.Players.LocalPlayer
local s1 = "rbxassetid://10470389827"

local function u9(p4)
	-- upvalues: s1 (ref)
	for _, v in ipairs(p4:GetPlayingAnimationTracks()) do
		if v.Animation and v.Animation.AnimationId == s1 then
			v:Stop()
			pcall(function()
				-- upvalues: v (ref)
				v:Destroy()
			end)
		end
	end
end
local function u10(p5)
	-- upvalues: s1 (ref), u9 (ref)
	local Humanoid = p5:WaitForChild("Humanoid")
	local connection = Humanoid.AnimationPlayed:Connect(function(animation)
		-- upvalues: s1 (ref)
		if animation.Animation and animation.Animation.AnimationId == s1 then
			animation:Stop()
			pcall(function()
				-- upvalues: animation (ref)
				animation:Destroy()
			end)
		end
	end)
	local thread = task.spawn(function()
		-- upvalues: Humanoid (ref), u9 (ref)
		while Humanoid.Parent do
			u9(Humanoid)
			task.wait(0.05)
		end
	end)

	p5.AncestryChanged:Connect(function(_, parent)
		-- upvalues: connection (ref), thread (ref)
		if not parent then
			if connection then
				connection:Disconnect()
			end

			task.cancel(thread)
		end
	end)
end

t2[4]:Toggle({
	Title = "Invisible Block",
	Default = false,
	Callback = function(p7)
		-- upvalues: LocalPlayer2 (ref), u10 (ref)
		if not p7 then
			print("Invisible Block: OFF")
		else
			if LocalPlayer2.Character then
				u10(LocalPlayer2.Character)
			end

			LocalPlayer2.CharacterAdded:Connect(u10)
			print("Invisible Block: ON")
		end
	end
})
t2[4]:Toggle({
	Title = "No Stun",
	Default = false,
	Callback = function(p8)
		if not p8 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NST(L2)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NST(L1)"))()
		end
	end
})
t2[4]:Toggle({
	Title = "No Slowed",
	Default = false,
	Callback = function(p9)
		if not p9 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NSL(L2)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/NSL(L1)"))()
		end
	end
})

local t3 = {
	["rbxassetid://10480793962"] = true,
	["rbxassetid://10480796021"] = true,
	["rbxassetid://10470104242"] = true
}

local function u12(p10)
	-- upvalues: t3 (ref)
	local Humanoid = p10:WaitForChild("Humanoid")
	local HumanoidRootPart = p10:WaitForChild("HumanoidRootPart")

	Humanoid.AnimationPlayed:Connect(function(animation)
		-- upvalues: t3 (ref)
		if getgenv().AntiDelayEnabled and t3[animation.Animation.AnimationId] then
			task.wait(0.21)
			animation:Stop()
		end
	end)
	task.spawn(function()
		-- upvalues: p10 (ref), HumanoidRootPart (ref)
		while p10 and p10.Parent == workspace do
			task.wait(100)

			if HumanoidRootPart and HumanoidRootPart.PlatformStand then
				HumanoidRootPart.PlatformStand = true
			end
		end
	end)
end

local LocalPlayer3 = game:GetService("Players").LocalPlayer

LocalPlayer3.CharacterAdded:Connect(function(character)
	-- upvalues: u12 (ref)
	task.defer(function()
		-- upvalues: u12 (ref), character (ref)
		u12(character)
	end)
end)
u12(LocalPlayer3.Character or LocalPlayer3.CharacterAdded:Wait())
t2[4]:Toggle({
	Title = "No Slide Dash Endlag",
	Default = false,
	Callback = function(p11)
		getgenv().AntiDelayEnabled = p11

		if not p11 then
			print("No Slide Dash Endlag: OFF")
		else
			print("No Slide Dash Endlag: ON")
		end
	end
})
t2[4]:Toggle({
	Title = "Free Rotate Ult",
	Default = false,
	Callback = function(p12)
		if not p12 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FLU(L2)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FRU(L1)"))()
		end
	end
})
t2[4]:Toggle({
	Title = "Death Counter Indicator",
	Default = false,
	Callback = function(p13)
		setState(p13)
	end
})
t2[5]:Button({
	Title = "Orbit Gui!",
	Icon = "rotate-cw",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Orbit%20by%20YQANTG"))()
	end
})
t2[5]:Button({
	Title = "Auto Toxic",
	Icon = "skull",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ArchIsDead/Arch-Vault/refs/heads/main/auto-toxic.lua"))()
	end
})
t2[5]:Toggle({
	Title = "M1 Reach",
	Default = false,
	Callback = function(p14)
		if not p14 then
			_G.TweenReachHold = false
			_G.TweenReachLooping = false
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/MR(L1)"))()
		end
	end
})
t2[5]:Toggle({
	Title = "Auto WallCombo Under",
	Default = false,
	Callback = function(p15)
		if not p15 then
			_G.AutoWallCombo = false
			_G.BurrowRunning = false

			local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

			if PlayerGui then
				for _, child in pairs(PlayerGui:GetChildren()) do
					if child.Name == "StickGui" then
						child:Destroy()
					end
				end
			end
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/ATWC(L1)"))()
		end
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

game:GetService("ReplicatedStorage")

local LocalPlayer4 = Players.LocalPlayer
local u17 = LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()
local Humanoid = u17:WaitForChild("Humanoid")
local HumanoidRootPart = u17:WaitForChild("HumanoidRootPart")
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
local u25 = false
local n1 = 10
local u27 = false

LocalPlayer4.CharacterAdded:Connect(function(character)
	-- upvalues: u17 (ref), Humanoid (ref), HumanoidRootPart (ref)
	u17 = character
	Humanoid = character:WaitForChild("Humanoid")
	HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
	setupAnimEvent()
end)

local ScreenGui = Instance.new("ScreenGui", LocalPlayer4:WaitForChild("PlayerGui"))

ScreenGui.Name = "WallcomboCooldownUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 300, 0, 20)
Frame.Position = UDim2.new(0.5, -150, 0.5, 40)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = false
Frame.Parent = ScreenGui
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

local function u32()
	-- upvalues: AlignPosition (ref), AlignOrientation (ref), connection (ref), Part (ref), HumanoidRootPart (ref)
	if AlignPosition then
		AlignPosition:Destroy()
	end

	if AlignOrientation then
		AlignOrientation:Destroy()
	end

	if connection then
		connection:Disconnect()
	end

	if Part then
		Part:Destroy()
	end

	for _, child in ipairs(HumanoidRootPart:GetChildren()) do
		if child:IsA("Attachment") or child.Name == "HasSnapped" then
			child:Destroy()
		end
	end
end
local function u33(p16)
	-- upvalues: u32 (ref), Part (ref), HumanoidRootPart (ref), AlignPosition (ref), AlignOrientation (ref), connection (ref), RunService (ref)
	u32()
	Part = Instance.new("Part")
	Part.Size = Vector3.new(0.5, 0.5, 0.5)
	Part.Transparency = 1
	Part.Anchored = true
	Part.CanCollide = false
	Part.Name = "FollowPart"
	Part.Parent = workspace

	local Attachment = Instance.new("Attachment", HumanoidRootPart)
	local Attachment2 = Instance.new("Attachment", Part)
	local Attachment3 = Instance.new("Attachment", HumanoidRootPart)
	local Attachment4 = Instance.new("Attachment", Part)

	AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Attachment0 = Attachment
	AlignPosition.Attachment1 = Attachment2
	AlignPosition.RigidityEnabled = true
	AlignPosition.Responsiveness = 200
	AlignPosition.MaxForce = math.huge
	AlignPosition.Parent = HumanoidRootPart
	AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Attachment0 = Attachment3
	AlignOrientation.Attachment1 = Attachment4
	AlignOrientation.RigidityEnabled = true
	AlignOrientation.Responsiveness = 200
	AlignOrientation.MaxTorque = math.huge
	AlignOrientation.Parent = HumanoidRootPart
	connection = RunService.RenderStepped:Connect(function()
		-- upvalues: p16 (ref), Part (ref), HumanoidRootPart (ref)
		if p16 and p16.Parent then
			local v336 = p16.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)

			Part.CFrame = v336

			if not HumanoidRootPart:FindFirstChild("HasSnapped") then
				HumanoidRootPart.CFrame = v336

				local BoolValue = Instance.new("BoolValue")

				BoolValue.Name = "HasSnapped"
				BoolValue.Parent = HumanoidRootPart
			end
		end
	end)
end
local function u34()
	-- upvalues: n1 (ref), u17 (ref), HumanoidRootPart (ref), Players (ref)
	local v303 = nil
	local v304 = n1

	for _, child in pairs(workspace.Live:GetChildren()) do
		if child:IsA("Model") and child ~= u17 then
			local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
			local Humanoid2 = child:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart2 and Humanoid2 and Humanoid2.Health > 0 then
				local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

				if Magnitude <= v304 and (child.Name == "Weakest Dummy" or Players:GetPlayerFromCharacter(child)) then
					v303 = HumanoidRootPart2
					v304 = Magnitude
				end
			end
		end
	end

	return v303
end
local function u35(p17)
	-- upvalues: u27 (ref), Frame (ref), Frame2 (ref), TextLabel (ref)
	u27 = true
	Frame.Visible = true
	Frame2.Size = UDim2.new(0, 0, 1, 0)

	for i = 0, p17 * 10 do
		local v185 = i / (p17 * 10)

		Frame2.Size = UDim2.new(v185, 0, 1, 0)
		TextLabel.Text = string.format("Cooldown: %.2f", p17 - i / 10)
		task.wait(0.1)
	end

	Frame.Visible = false
	u27 = false
end

function setupAnimEvent()
	-- upvalues: Humanoid (ref), u25 (ref), u27 (ref), t4 (ref), u34 (ref), u33 (ref), u17 (ref), u32 (ref), u35 (ref)
	Humanoid.AnimationPlayed:Connect(function(animation)
		-- upvalues: u25 (ref), u27 (ref), t4 (ref), u34 (ref), u33 (ref), u17 (ref), u32 (ref), u35 (ref)
		if u25 and not u27 then
			local v335 = animation.Animation and string.match(animation.Animation.AnimationId, "%d+")

			if v335 and t4[v335] then
				u27 = true
				task.delay(1E-05, function()
					-- upvalues: u34 (ref), u33 (ref), u17 (ref), u32 (ref), u35 (ref)
					local v362 = u34()

					if v362 then
						u33(v362)
						task.delay(0.15, function()
							-- upvalues: u17 (ref)
							u17.Communicate:FireServer({
								Goal = "LeftClick",
								Mobile = true
							})
							task.delay(0.1, function()
								-- upvalues: u17 (ref)
								for _ = 1, 2 do
									u17.Communicate:FireServer({
										Goal = "Wall Combo"
									})
									task.wait(0.05)
								end
							end)
							task.delay(0.3, function()
								-- upvalues: u17 (ref)
								u17.Communicate:FireServer({
									Goal = "LeftClickRelease",
									Mobile = true
								})
							end)
						end)
						task.delay(0.8, u32)
						task.spawn(u35, 10)
					end
				end)

				return
			end

			return
		end
	end)
end

setupAnimEvent()
t2[5]:Toggle({
	Title = "Auto WallCombo Upper",
	Default = false,
	Callback = function(p18)
		-- upvalues: u25 (ref)
		u25 = p18
	end
})

local Players2 = game:GetService("Players")
local RunService2 = game:GetService("RunService")
local LocalPlayer5 = Players2.LocalPlayer
local u39 = LocalPlayer5.Character or LocalPlayer5.CharacterAdded:Wait()
local HumanoidRootPart3 = u39:WaitForChild("HumanoidRootPart")
local Communicate = u39:WaitForChild("Communicate")
local Live = workspace:WaitForChild("Live")
local t5 = {
	["rbxassetid://10479335397"] = true,
	["rbxassetid://13380255751"] = true,
	["rbxassetid://134775406437626"] = true
}
local t6 = {
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
local t7 = {
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
}

for k in pairs(t7) do
	t6[k] = true
end

local t8 = {}
local u48 = nil

local function u49(p19, p20, p21)
	return p21 >= (p19 - p20).Magnitude
end
local function u50()
	-- upvalues: LocalPlayer5 (ref), Communicate (ref)
	local v186 = LocalPlayer5.Backpack:FindFirstChild("Prey's Peril")

	if v186 then
		Communicate:FireServer({
			Tool = v186,
			Goal = "Console Move"
		})
	end

	local v187 = LocalPlayer5.Backpack:FindFirstChild("Split Second Counter")

	if v187 then
		Communicate:FireServer({
			Tool = v187,
			Goal = "Console Move"
		})
	end
end

t2[4]:Toggle({
	Title = "Auto Counter",
	Default = false,
	Callback = function(p22)
		-- upvalues: u48 (ref), RunService2 (ref), Live (ref), u39 (ref), t5 (ref), t6 (ref), u49 (ref), HumanoidRootPart3 (ref), t8 (ref), u50 (ref)
		if not p22 then
			print("Auto Counter: OFF")

			if u48 then
				u48:Disconnect()
				u48 = nil
			end

			table.clear(t8)
		else
			print("Auto Counter: ON")
			u48 = RunService2.Heartbeat:Connect(function()
				-- upvalues: Live (ref), u39 (ref), t5 (ref), t6 (ref), u49 (ref), HumanoidRootPart3 (ref), t8 (ref), u50 (ref)
				for _, child in pairs(Live:GetChildren()) do
					if child:IsA("Model") and child ~= u39 and child:FindFirstChild("HumanoidRootPart") then
						local Humanoid3 = child:FindFirstChildOfClass("Humanoid")
						local v347 = Humanoid3 and Humanoid3:FindFirstChildOfClass("Animator")

						if v347 then
							for _, v in pairs(v347:GetPlayingAnimationTracks()) do
								local AnimationId = v.Animation.AnimationId
								local v351 = child:GetDebugId() .. AnimationId
								local v352 = t5[AnimationId] and 13 or 13

								if not t5[AnimationId] and not t6[AnimationId] or not u49(HumanoidRootPart3.Position, child.HumanoidRootPart.Position, v352) then
									t8[v351] = nil
								elseif not t8[v351] then
									t8[v351] = true

									if not t5[AnimationId] then
										u50()
									else
										task.delay(0.0001, u50)
									end
								end
							end
						end
					end
				end
			end)
		end
	end
})
t2[6]:Button({
	Title = "M1 Reset",
	Icon = "shield-check",
	Callback = function()
		getgenv().keybinds = {
			m1reset = Enum.KeyCode.R,
			emotedash = Enum.KeyCode.T,
			rotation = Enum.KeyCode.H
		}
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
	end
})
t2[6]:Button({
	Title = "Kai Tech",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Kai"))()
	end
})
t2[6]:Button({
	Title = "BackDash (Mobile)",
	Icon = "shield-check",
	Callback = function()
		print("Clicked: BackDash (Mobile)")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/main/backdash%20mobile"))()
	end
})
t2[6]:Button({
	Title = "BackDash (PC)",
	Icon = "shield-check",
	Callback = function()
		print("Clicked: BackDash (PC)")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/main/backdashpc"))()
	end
})
t2[6]:Button({
	Title = "Auto UpperPunch",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/autoupperpunch%20(1).txt"))()
	end
})
t2[6]:Button({
	Title = "Tornado Tech",
	Icon = "shield-check",
	Callback = function()
		print("Clicked: Tornado Tech")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Tornado%20Tech%20script"))()
	end
})
t2[6]:Button({
	Title = "Kiba Tech V1",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/kiba.txt"))()
	end
})
t2[6]:Button({
	Title = "Kiba Tech V2.1",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/FixTooHighh.txt"))()
	end
})
t2[6]:Button({
	Title = "Freeze Tech",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/hahahajjws.txt"))()
	end
})
t2[6]:Button({
	Title = "Tornado Twisted",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/tornadotwisted.txt"))()
	end
})
t2[6]:Button({
	Title = "Loop dash old",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_5502107740408834.lua.txt"))()
	end
})
t2[11]:Toggle({
	Title = "Auto Farm Near",
	Default = false,
	Callback = function(p23)
		if not p23 then
			_G.StickFarmOn = false

			if _G.StickFarmCleanup then
				_G.StickFarmCleanup()
				_G.StickFarmCleanup = nil
			end
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/ATFN"))()
		end
	end
})

local LocalPlayer6 = game.Players.LocalPlayer
local u52 = LocalPlayer6.Character or LocalPlayer6.CharacterAdded:Wait()
local HumanoidRootPart4 = u52:WaitForChild("HumanoidRootPart")
local CurrentCamera = workspace.CurrentCamera
local RunService3 = game:GetService("RunService")
local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "StickGui"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.Parent = LocalPlayer6:WaitForChild("PlayerGui")

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
TextButton.Parent = ScreenGui2

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TextButton
TextButton.Active = true
TextButton.Draggable = true

local u59 = false
local u60 = nil
local connection2 = nil
local connection3 = nil
local HumanoidRootPart4CFrame = nil
local CameraType = nil

local function u65()
	-- upvalues: LocalPlayer6 (ref), HumanoidRootPart4 (ref)
	local v140 = nil
	local huge = math.huge

	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= LocalPlayer6 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local Magnitude = (player.Character.HumanoidRootPart.Position - HumanoidRootPart4.Position).Magnitude

			if Magnitude < 10000 and player.Character.Humanoid.Health > 0 and Magnitude < huge then
				huge = Magnitude
				v140 = player
			end
		end
	end

	return v140
end
local function u66()
	-- upvalues: connection3 (ref), RunService3 (ref), u52 (ref)
	connection3 = RunService3.Stepped:Connect(function()
		-- upvalues: u52 (ref)
		for _, descendant in ipairs(u52:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false
			end
		end
	end)
end
local function u67()
	-- upvalues: connection3 (ref), u52 (ref)
	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	for _, descendant in ipairs(u52:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = true
		end
	end
end
local function u68()
	-- upvalues: HumanoidRootPart4CFrame (ref), HumanoidRootPart4 (ref), CameraType (ref), CurrentCamera (ref), u66 (ref), connection2 (ref), RunService3 (ref), u59 (ref), u60 (ref), u65 (ref), u52 (ref)
	HumanoidRootPart4CFrame = HumanoidRootPart4.CFrame
	CameraType = CurrentCamera.CameraType
	u66()
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	connection2 = RunService3.RenderStepped:Connect(function()
		-- upvalues: u59 (ref), u60 (ref), u65 (ref), HumanoidRootPart4 (ref), u52 (ref), CurrentCamera (ref)
		if u59 then
			if not u60 or not u60.Character or not u60.Character:FindFirstChild("HumanoidRootPart") or u60.Character:FindFirstChild("Humanoid").Health <= 0 then
				u60 = u65()
			end

			if u60 and u60.Character and u60.Character:FindFirstChild("HumanoidRootPart") then
				local HumanoidRootPartPosition = u60.Character.HumanoidRootPart.Position
				local Unit = (HumanoidRootPartPosition - HumanoidRootPart4.Position).Unit
				local v340 = HumanoidRootPartPosition - Vector3.new(0, 5, 0)
				local Humanoid4 = u52:FindFirstChildOfClass("Humanoid")

				if Humanoid4 then
					Humanoid4.PlatformStand = true
					Humanoid4.Sit = false
				end

				HumanoidRootPart4.Velocity = Vector3.zero
				HumanoidRootPart4.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart4.RotVelocity = Vector3.zero
				HumanoidRootPart4.AssemblyAngularVelocity = Vector3.zero
				HumanoidRootPart4.CFrame = CFrame.new(v340, v340 + Unit)

				local v342 = HumanoidRootPartPosition + Vector3.new(0, 14, 20)

				CurrentCamera.CFrame = CFrame.new(v342, HumanoidRootPartPosition)
			end

			return
		end
	end)
end
local function u69()
	-- upvalues: connection2 (ref), u67 (ref), u52 (ref), HumanoidRootPart4CFrame (ref), HumanoidRootPart4 (ref), CameraType (ref), CurrentCamera (ref), u60 (ref)
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	u67()

	local Humanoid5 = u52:FindFirstChildOfClass("Humanoid")

	if Humanoid5 then
		Humanoid5.PlatformStand = false
	end

	if HumanoidRootPart4CFrame then
		HumanoidRootPart4.CFrame = HumanoidRootPart4CFrame
	end

	if CameraType then
		CurrentCamera.CameraType = CameraType
	end

	u60 = nil
end

TextButton.MouseButton1Click:Connect(function()
	-- upvalues: u59 (ref), TextButton (ref), u68 (ref), u69 (ref)
	u59 = not u59
	TextButton.Text = u59 and "Under (On)" or "Under"

	if not u59 then
		u69()
	else
		u68()
	end
end)
t2[11]:Toggle({
	Title = "Under",
	Default = false,
	Callback = function(p24)
		-- upvalues: TextButton (ref), u59 (ref), u68 (ref), u69 (ref)
		TextButton.Visible = p24

		if not p24 then
			u59 = false
			TextButton.Text = "Under"
			u69()
		else
			u59 = true
			TextButton.Text = "Under (On)"
			u68()
		end
	end
})

local Players3 = game:GetService("Players")
local RunService4 = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer7 = Players3.LocalPlayer
local u74 = LocalPlayer7.Character or LocalPlayer7.CharacterAdded:Wait()
local HumanoidRootPart5 = u74:WaitForChild("HumanoidRootPart")
local ScreenGui3 = Instance.new("ScreenGui", LocalPlayer7:WaitForChild("PlayerGui"))

ScreenGui3.Name = "FollowGui"
ScreenGui3.ResetOnSpawn = false

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(0, 50, 0, 50)
Frame3.Position = UDim2.new(0, 10, 0.4, 0)
Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame3.BackgroundTransparency = 0
Frame3.BorderSizePixel = 0
Frame3.Name = "FollowFrame"
Frame3.Parent = ScreenGui3
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

local u79 = false
local connection4 = nil
local HumanoidRootPart5CFrame = nil
local u82 = nil

local function u83()
	-- upvalues: u74 (ref), HumanoidRootPart5 (ref)
	local v151 = nil
	local n2 = 300

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") and descendant ~= u74 then
			local HumanoidRootPart6 = descendant:FindFirstChild("HumanoidRootPart")
			local Humanoid6 = descendant:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart6 and Humanoid6 and Humanoid6.Health > 0 then
				local Magnitude = (HumanoidRootPart6.Position - HumanoidRootPart5.Position).Magnitude

				if Magnitude < n2 then
					v151 = HumanoidRootPart6
					n2 = Magnitude
				end
			end
		end
	end

	return v151
end
local function u84()
	-- upvalues: connection4 (ref), HumanoidRootPart5CFrame (ref), HumanoidRootPart5 (ref), u82 (ref), u83 (ref), RunService4 (ref)
	if connection4 then
		connection4:Disconnect()
	end

	HumanoidRootPart5CFrame = HumanoidRootPart5.CFrame
	u82 = u83()
	connection4 = RunService4.RenderStepped:Connect(function()
		-- upvalues: u82 (ref), HumanoidRootPart5 (ref)
		if u82 and u82.Parent and u82:IsDescendantOf(workspace) then
			local v315 = u82
			local v316 = v315.CFrame.LookVector * -4.8
			local v317 = v315.Position + v316
			local HumanoidRootPart5Position = HumanoidRootPart5.Position

			HumanoidRootPart5.CFrame = CFrame.new(HumanoidRootPart5Position:Lerp(v317, 0.2), v315.Position)
		end
	end)
end
local function u85()
	-- upvalues: HumanoidRootPart5CFrame (ref), TweenService (ref), HumanoidRootPart5 (ref)
	if HumanoidRootPart5CFrame then
		TweenService:Create(HumanoidRootPart5, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
			CFrame = HumanoidRootPart5CFrame
		}):Play()
	end
end

TextButton2.MouseButton1Click:Connect(function()
	-- upvalues: u79 (ref), TextButton2 (ref), u84 (ref), connection4 (ref), u85 (ref), u82 (ref)
	u79 = not u79
	TextButton2.Text = u79 and "ON" or "OFF"
	TextButton2.BackgroundColor3 = u79 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(60, 60, 60)

	if not u79 then
		if connection4 then
			connection4:Disconnect()
		end

		u85()
		u82 = nil
	else
		u84()
	end
end)
t2[11]:Toggle({
	Title = "Behind",
	Default = false,
	Callback = function(p25)
		-- upvalues: Frame3 (ref), u79 (ref), TextButton2 (ref), u84 (ref), connection4 (ref), u85 (ref), u82 (ref)
		Frame3.Visible = p25

		if not p25 then
			u79 = false
			TextButton2.Text = "OFF"
			TextButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

			if connection4 then
				connection4:Disconnect()
			end

			u85()
			u82 = nil
		else
			u79 = true
			TextButton2.Text = "ON"
			TextButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			u84()
		end
	end
})

local Players4 = game:GetService("Players")
local TweenService2 = game:GetService("TweenService")
local RunService5 = game:GetService("RunService")
local LocalPlayer8 = Players4.LocalPlayer
local u90 = LocalPlayer8.Character or LocalPlayer8.CharacterAdded:Wait()
local HumanoidRootPart7 = u90:WaitForChild("HumanoidRootPart")
local ScreenGui4 = Instance.new("ScreenGui", LocalPlayer8:WaitForChild("PlayerGui"))

ScreenGui4.Name = "FollowGui"
ScreenGui4.ResetOnSpawn = false

local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(0, 50, 0, 50)
Frame4.Position = UDim2.new(0, 10, 0.1, 0)
Frame4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame4.BorderSizePixel = 0
Frame4.Name = "FollowFrame"
Frame4.Parent = ScreenGui4
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

local u95 = false
local AlignPosition2 = nil
local AlignOrientation2 = nil
local connection5 = nil
local Part2 = nil
local HumanoidRootPart7CFrame = nil
local u101 = nil

local function u102()
	-- upvalues: u90 (ref), HumanoidRootPart7 (ref)
	local v231 = nil
	local n3 = 300

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") and descendant ~= u90 then
			local HumanoidRootPart8 = descendant:FindFirstChild("HumanoidRootPart")
			local Humanoid7 = descendant:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart8 and Humanoid7 and Humanoid7.Health > 0 then
				local Magnitude = (HumanoidRootPart8.Position - HumanoidRootPart7.Position).Magnitude

				if Magnitude < n3 then
					v231 = HumanoidRootPart8
					n3 = Magnitude
				end
			end
		end
	end

	return v231
end
local function u103(p26)
	-- upvalues: HumanoidRootPart7CFrame (ref), HumanoidRootPart7 (ref), AlignPosition2 (ref), AlignOrientation2 (ref), connection5 (ref), Part2 (ref), RunService5 (ref), u95 (ref)
	HumanoidRootPart7CFrame = HumanoidRootPart7.CFrame

	if AlignPosition2 then
		AlignPosition2:Destroy()
	end

	if AlignOrientation2 then
		AlignOrientation2:Destroy()
	end

	if connection5 then
		connection5:Disconnect()
	end

	if Part2 then
		Part2:Destroy()
	end

	for _, child in HumanoidRootPart7:GetChildren() do
		if child:IsA("Attachment") then
			child:Destroy()
		end
	end

	Part2 = Instance.new("Part")
	Part2.Size = Vector3.new(0.5, 0.5, 0.5)
	Part2.Transparency = 1
	Part2.Anchored = true
	Part2.CanCollide = false
	Part2.Name = "FollowAttachPart"
	Part2.Parent = workspace

	local Attachment = Instance.new("Attachment", HumanoidRootPart7)
	local Attachment5 = Instance.new("Attachment", Part2)
	local Attachment6 = Instance.new("Attachment", HumanoidRootPart7)
	local Attachment7 = Instance.new("Attachment", Part2)

	AlignPosition2 = Instance.new("AlignPosition")
	AlignPosition2.Attachment0 = Attachment
	AlignPosition2.Attachment1 = Attachment5
	AlignPosition2.RigidityEnabled = true
	AlignPosition2.Responsiveness = 200
	AlignPosition2.MaxForce = math.huge
	AlignPosition2.Parent = HumanoidRootPart7
	AlignOrientation2 = Instance.new("AlignOrientation")
	AlignOrientation2.Attachment0 = Attachment6
	AlignOrientation2.Attachment1 = Attachment7
	AlignOrientation2.RigidityEnabled = true
	AlignOrientation2.Responsiveness = 200
	AlignOrientation2.MaxTorque = math.huge
	AlignOrientation2.Parent = HumanoidRootPart7
	connection5 = RunService5.RenderStepped:Connect(function()
		-- upvalues: u95 (ref), p26 (ref), Part2 (ref)
		if u95 then
			if p26 and p26.Parent and p26:IsDescendantOf(workspace) then
				Part2.CFrame = p26.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
			end

			return
		end
	end)
end
local function u104()
	-- upvalues: u95 (ref), AlignPosition2 (ref), AlignOrientation2 (ref), connection5 (ref), Part2 (ref), HumanoidRootPart7 (ref), HumanoidRootPart7CFrame (ref), TweenService2 (ref)
	u95 = false

	if AlignPosition2 then
		AlignPosition2:Destroy()
	end

	if AlignOrientation2 then
		AlignOrientation2:Destroy()
	end

	if connection5 then
		connection5:Disconnect()
	end

	if Part2 then
		Part2:Destroy()
	end

	for _, child in HumanoidRootPart7:GetChildren() do
		if child:IsA("Attachment") then
			child:Destroy()
		end
	end

	if HumanoidRootPart7CFrame then
		TweenService2:Create(HumanoidRootPart7, TweenInfo.new(0.001, Enum.EasingStyle.Sine), {
			CFrame = HumanoidRootPart7CFrame
		}):Play()
	end
end

TextButton3.MouseButton1Click:Connect(function()
	-- upvalues: u95 (ref), TextButton3 (ref), u101 (ref), u102 (ref), u103 (ref), u104 (ref)
	u95 = not u95
	TextButton3.Text = u95 and "ON" or "OFF"
	TextButton3.BackgroundColor3 = u95 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)

	if not u95 then
		u104()
		u101 = nil
	else
		u101 = u102()

		if not u101 then
			TextButton3.Text = "NO TARGET"
			u95 = false
		else
			u103(u101)
		end
	end
end)
t2[11]:Toggle({
	Title = "Upper",
	Default = false,
	Callback = function(p27)
		-- upvalues: Frame4 (ref)
		Frame4.Visible = p27
	end
})

local Lighting = game:GetService("Lighting")

local function u106()
	-- upvalues: Lighting (ref)
	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("PostEffect") or child:IsA("Atmosphere") then
			child:Destroy()
		end
	end
end

local t9 = {
	Morning = function()
		-- upvalues: Lighting (ref)
		local v246 = Lighting
		local v247 = Lighting

		Lighting.Brightness = 3
		v247.ClockTime = 7.5
		v246.TimeOfDay = "07:30:00"
		Lighting.OutdoorAmbient = Color3.fromRGB(180, 200, 220)
		Instance.new("Atmosphere", Lighting):SetAttribute("Config", {
			Density = 0.3,
			Color = Color3.fromRGB(200, 220, 255),
			Decay = Color3.fromRGB(255, 240, 200)
		})

		local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)
		local color3 = Color3.fromRGB(255, 255, 230)

		ColorCorrectionEffect.Brightness = 0.1
		ColorCorrectionEffect.Contrast = 0.15
		ColorCorrectionEffect.Saturation = 0.05
		ColorCorrectionEffect.TintColor = color3
		Instance.new("SunRaysEffect", Lighting).Intensity = 0.25
	end,
	Afternoon = function()
		-- upvalues: Lighting (ref)
		local v199 = Lighting
		local v200 = Lighting

		Lighting.Brightness = 3.5
		v200.ClockTime = 15
		v199.TimeOfDay = "15:00:00"
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 230)

		local Atmosphere = Instance.new("Atmosphere", Lighting)
		local color3 = Color3.fromRGB(220, 235, 255)

		Atmosphere.Decay = Color3.fromRGB(255, 220, 180)
		Atmosphere.Color = color3
		Atmosphere.Density = 0.25

		local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)
		local color3_2 = Color3.fromRGB(255, 245, 210)

		ColorCorrectionEffect.Brightness = 0.05
		ColorCorrectionEffect.Contrast = 0.2
		ColorCorrectionEffect.Saturation = 0.1
		ColorCorrectionEffect.TintColor = color3_2
		Instance.new("SunRaysEffect", Lighting).Intensity = 0.35
	end,
	["Ultra Shader Pro (HD+)"] = function()
		-- upvalues: Lighting (ref)
		local v270 = Lighting
		local v271 = Lighting

		Lighting.TimeOfDay = "11:00:00"
		v271.ClockTime = 11
		v270.Brightness = 3.2

		local v272 = Lighting
		local v273 = Lighting

		Lighting.GlobalShadows = true
		v273.EnvironmentSpecularScale = 1
		v272.EnvironmentDiffuseScale = 1

		local v274 = Lighting
		local v275 = Lighting
		local color3 = Color3.fromRGB(75, 75, 75)

		v275.Ambient = Color3.fromRGB(105, 105, 105)
		v274.OutdoorAmbient = color3

		local v277 = Lighting

		Lighting.FogColor = Color3.fromRGB(235, 235, 235)
		v277.FogEnd = 150000

		local Atmosphere = Instance.new("Atmosphere", Lighting)

		Atmosphere.Haze = 1
		Atmosphere.Glare = 0.2
		Atmosphere.Offset = 0.2
		Atmosphere.Density = 0.1

		local color3_3 = Color3.fromRGB(255, 255, 255)

		Atmosphere.Decay = Color3.fromRGB(180, 180, 180)
		Atmosphere.Color = color3_3

		local BloomEffect = Instance.new("BloomEffect", Lighting)

		BloomEffect.Size = 38
		BloomEffect.Threshold = 1
		BloomEffect.Intensity = 0.85

		local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect", Lighting)

		DepthOfFieldEffect.FarIntensity = 0.03
		DepthOfFieldEffect.NearIntensity = 0.15
		DepthOfFieldEffect.InFocusRadius = 50
		DepthOfFieldEffect.FocusDistance = 90

		local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)

		ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
		ColorCorrectionEffect.Saturation = 0.15
		ColorCorrectionEffect.Contrast = 0.22
		ColorCorrectionEffect.Brightness = 0.06

		local SunRaysEffect = Instance.new("SunRaysEffect", Lighting)

		SunRaysEffect.Spread = 0
		SunRaysEffect.Intensity = 0
	end
}

local function u108(p28)
	-- upvalues: u106 (ref), t9 (ref)
	u106()

	if t9[p28] then
		t9[p28]()
	end
end

local s2 = "Morning"

t2[10]:Dropdown({
	Title = "Select Shader",
	Values = {
		"Morning",
		"Afternoon",
		"Ultra Shader Pro (HD+)"
	},
	Value = "Morning",
	Callback = function(p29)
		-- upvalues: s2 (ref), u1 (ref)
		s2 = p29
		u1:Notify({
			Title = "Shader Changed",
			Content = "Selected: " .. p29,
			Duration = 2
		})
	end
})
t2[10]:Button({
	Title = "Apply Shader",
	Icon = "shield-check",
	Callback = function()
		-- upvalues: u108 (ref), s2 (ref)
		u108(s2)
	end
})
t2[12]:Button({
	Title = "Our Hub ( by IDK )",
	Icon = "shield-check",
	Callback = function()
		local v191 = "https://raw.githubusercontent.com/" .. "Slaphello" .. "/" .. "IDKHub" .. "/" .. "main" .. "/" .. "Hub"

		loadstring(game:HttpGet(v191))()
	end
})
t2[9]:Button({
	Title = "Rejoin",
	Icon = "shield-check",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local LocalPlayer9 = game.Players.LocalPlayer
		local ScreenGui5 = Instance.new("ScreenGui")

		ScreenGui5.Name = "RejoinGui"
		ScreenGui5.ResetOnSpawn = false
		ScreenGui5.Parent = LocalPlayer9:WaitForChild("PlayerGui")

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel2.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextScaled = true
		TextLabel2.Parent = ScreenGui5

		for i = 0.5, 1, -1 do
			TextLabel2.Text = "Rejoining in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui5:Destroy()
		TeleportService:Teleport(game.PlaceId, LocalPlayer9)
	end
})
t2[9]:Button({
	Title = "Server Hop",
	Icon = "shield-check",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer10 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui6 = Instance.new("ScreenGui", LocalPlayer10:WaitForChild("PlayerGui"))

		ScreenGui6.Name = "ServerHopGui"
		ScreenGui6.ResetOnSpawn = false

		local TextLabel3 = Instance.new("TextLabel", ScreenGui6)

		TextLabel3.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel3.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.TextColor3 = Color3.new(1, 1, 1)
		TextLabel3.Font = Enum.Font.GothamBold
		TextLabel3.TextScaled = true

		for i = 2, 1, -1 do
			TextLabel3.Text = "Hopping in " .. i .. "..."
			task.wait(1)
		end

		ScreenGui6:Destroy()

		local v227 = (function()
			-- upvalues: HttpService (ref), PlaceId (ref)
			local t10 = {}
			local ok, result = pcall(function()
				-- upvalues: HttpService (ref), PlaceId (ref)
				return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			end)

			if ok and (result and result.data) then
				for _, v in pairs(result.data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						table.insert(t10, v.id)
					end
				end
			end

			return #t10 > 0 and t10[math.random(1, #t10)] or nil
		end)()

		if not v227 then
			warn("Miss")
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, v227, LocalPlayer10)
		end
	end
})
t2[9]:Button({
	Title = "Small Server",
	Icon = "shield-check",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local LocalPlayer11 = game.Players.LocalPlayer
		local PlaceId = game.PlaceId
		local ScreenGui7 = Instance.new("ScreenGui", LocalPlayer11:WaitForChild("PlayerGui"))

		ScreenGui7.Name = "SmallServerGui"
		ScreenGui7.ResetOnSpawn = false

		local TextLabel4 = Instance.new("TextLabel", ScreenGui7)

		TextLabel4.Size = UDim2.new(0.3, 0, 0.2, 0)
		TextLabel4.Position = UDim2.new(0.35, 0, 0.4, 0)
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.TextColor3 = Color3.new(1, 1, 1)
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextScaled = true

		for i = 2, 1, -1 do
			TextLabel4.Text = "Tìm server < 5 người trong " .. i .. "..."
			task.wait(1)
		end

		ScreenGui7:Destroy()

		local v297 = (function()
			-- upvalues: PlaceId (ref), HttpService (ref)
			local t11 = {}
			local s3 = ""

			for _ = 1, 2 do
				local u356 = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

				if s3 ~= "" then
					u356 = u356 .. "&cursor=" .. s3
				end

				local ok, result = pcall(function()
					-- upvalues: HttpService (ref), u356 (ref)
					return HttpService:JSONDecode(game:HttpGet(u356))
				end)

				if not ok or not result or not result.data then
					return #t11 > 0 and t11[math.random(1, #t11)] or nil
				end

				for _, v in pairs(result.data) do
					if v.playing < 2 and v.id ~= game.JobId then
						table.insert(t11, v.id)
					end
				end

				if not result.nextPageCursor then
					return #t11 > 0 and t11[math.random(1, #t11)] or nil
				end

				s3 = result.nextPageCursor
			end

			return #t11 > 0 and t11[math.random(1, #t11)] or nil
		end)()

		if not v297 then
			warn("Miss")
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, v297, LocalPlayer11)
		end
	end
})
t2[9]:Button({
	Title = "Check Ping",
	Icon = "shield-check",
	Callback = function()
		local LocalPlayer12 = game:GetService("Players").LocalPlayer
		local ScreenGui8 = Instance.new("ScreenGui")

		ScreenGui8.Name = "PingDisplay"
		ScreenGui8.ResetOnSpawn = false
		ScreenGui8.Parent = LocalPlayer12:WaitForChild("PlayerGui")

		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Size = UDim2.new(0, 150, 0, 40)
		TextLabel5.Position = UDim2.new(1, -160, 0, 10)
		TextLabel5.BackgroundTransparency = 0.4
		TextLabel5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel5.TextColor3 = Color3.new(1, 1, 1)
		TextLabel5.Font = Enum.Font.GothamBold
		TextLabel5.TextSize = 20
		TextLabel5.Text = "PING: -- ms"
		TextLabel5.Parent = ScreenGui8
		spawn(function()
			-- upvalues: LocalPlayer12 (ref), TextLabel5 (ref)
			while true do
				local v323 = math.floor(LocalPlayer12:GetNetworkPing() * 1000)

				TextLabel5.Text = "PING: " .. v323 .. " ms"

				if not (v323 <= 80) then
					if not (v323 <= 150) then
						TextLabel5.TextColor3 = Color3.fromRGB(255, 0, 0)
					else
						TextLabel5.TextColor3 = Color3.fromRGB(255, 170, 0)
					end
				else
					TextLabel5.TextColor3 = Color3.fromRGB(0, 255, 0)
				end

				wait(1)
			end
		end)
	end
})
t2[8]:Toggle({
	Title = "Anti Afk",
	Default = false,
	Callback = function(p30)
		if not p30 then
			if getgenv().AntiAFK_Connection then
				getgenv().AntiAFK_Connection:Disconnect()
				getgenv().AntiAFK_Connection = nil
			end

			warn("[ AntiAFK]: Disabled")
		else
			getgenv().AntiAFK_Connection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
				local VirtualUser = game:GetService("VirtualUser")

				VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			end)
			warn("[ AntiAFK]: Enabled")
		end
	end
})
t2[13]:Button({
	Title = "Infinite Yield",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})
t2[13]:Button({
	Title = "Nameless",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://github.com/FilteringEnabled/NamelessAdmin/blob/main/Source?raw=true"))()
	end
})

local LocalPlayer13 = game:GetService("Players").LocalPlayer
local u111 = false

local function u112(p31)
	for _, descendant in pairs(p31:GetDescendants()) do
		if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
			descendant:Destroy()
		end
	end
end
local function u113()
end

LocalPlayer13.CharacterAdded:Connect(function(character)
	-- upvalues: u111 (ref), u112 (ref)
	if u111 then
		task.wait(0.5)
		u112(character)
	end
end)
t2[8]:Toggle({
	Title = "Anti Ragdoll",
	Default = false,
	Callback = function(p32)
		-- upvalues: u111 (ref), LocalPlayer13 (ref), u112 (ref), u113 (ref)
		u111 = p32

		if not p32 then
			u113()
		elseif LocalPlayer13.Character then
			u112(LocalPlayer13.Character)
		end
	end
})

local Players5 = game:GetService("Players")
local RunService6 = game:GetService("RunService")
local LocalPlayer14 = Players5.LocalPlayer
local CurrentCamera2 = workspace.CurrentCamera
local u118 = false
local u119 = nil

t2[8]:Toggle({
	Title = "Anti Camlock",
	Default = false,
	Callback = function(p33)
		-- upvalues: u118 (ref), u119 (ref), RunService6 (ref), LocalPlayer14 (ref), CurrentCamera2 (ref)
		u118 = p33

		if not p33 then
			if u119 then
				u119:Disconnect()
				u119 = nil
			end
		else
			u119 = RunService6.RenderStepped:Connect(function()
				-- upvalues: LocalPlayer14 (ref), CurrentCamera2 (ref)
				local v314 = LocalPlayer14.Character and LocalPlayer14.Character:FindFirstChildWhichIsA("Humanoid")

				if v314 and v314 ~= CurrentCamera2.CameraSubject then
					CurrentCamera2.CameraSubject = v314
				end
			end)
		end
	end
})
t2[8]:Button({
	Title = "Anti lag ( Remove effect )",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Protected_5743487458031851.lua.txt"))()
	end
})
t2[6]:Button({
	Title = "All in one",
	Icon = "shield-check",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTG/YQANTG/refs/heads/main/alltechsceiot.txt"))()
	end
})
u2:Tag({
	Title = "v3.3",
	Color = Color3.fromHex("#30ff6a")
})
u2:Tag({
	Title = "Beta",
	Color = Color3.fromHex("#315dff")
})

local u120 = u2:Tag({
	Title = "--:--",
	Radius = 0,
	Color = u1:Gradient({
		["0"] = {
			Color = Color3.fromHex("#FF0F7B"),
			Transparency = 0
		},
		["100"] = {
			Color = Color3.fromHex("#F89B29"),
			Transparency = 0
		}
	}, {
		Rotation = 45
	})
})
local n4 = 0

task.spawn(function()
	-- upvalues: n4 (ref), u120 (ref)
	while true do
		local v148 = os.date("*t")
		local v149 = string.format("%02d", v148.hour)
		local v150 = string.format("%02d", v148.min)

		n4 = (n4 + 0.01) % 1
		Color3.fromHSV(n4, 1, 1)
		u120:SetTitle(v149 .. ":" .. v150)
		task.wait(0.06)
	end
end)
u2:CreateTopbarButton("theme-switcher", "moon", function()
	-- upvalues: u1 (ref)
	u1:SetTheme(u1:GetCurrentTheme() == "Dark" and "Light" or "Dark")
	u1:Notify({
		Title = "Theme Changed",
		Content = "Current theme: " .. u1:GetCurrentTheme(),
		Duration = 2
	})
end, 990)
u2:OnClose(function()
	-- upvalues: u1 (ref)
	print("WindUI closed")
	u1:Notify({
		Title = "Closed",
		Content = "Window has been closed.",
		Duration = 0
	})
end)
t2[10]:Toggle({
	Title = "Ultra Shader",
	Default = false,
	Callback = function(p34)
		if not p34 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/US(L2)"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV3/YQANTGV3/refs/heads/main/US(L1)"))()
		end
	end
})

local t12 = {
	Settings = u2:Section({
		Title = "Change",
		Opened = true
	}),
	Utilities = u2:Section({
		Title = "Config",
		Opened = true
	})
}
local t13 = {
	Appearance = t12.Settings:Tab({
		Title = "Change Color Grou",
		Icon = "brush"
	}),
	Config = t12.Utilities:Tab({
		Title = "Config",
		Icon = "settings"
	})
}

t13.Config:Paragraph({
	Title = "Configuration Manager",
	Desc = "Save and load your settings",
	Image = "save",
	ImageSize = 20,
	Color = "White"
})
t13.Config:Slider({
	Title = "Ui Transparency",
	Value = {
		Min = 0,
		Max = 1,
		Default = 0.2
	},
	Step = 0.1,
	Callback = function(p35)
		-- upvalues: u1 (ref), u2 (ref)
		u1.TransparencyValue = tonumber(p35)
		u2:ToggleTransparency(tonumber(p35) > 0)
	end
})

local s4 = "default"
local u125 = nil
local t14 = {
	name = "Player1",
	level = 1,
	inventory = {
		"sword",
		"shield",
		"potion"
	}
}

t13.Config:Input({
	Title = "Config Name",
	Value = s4,
	Callback = function(p36)
		-- upvalues: s4 (ref)
		s4 = p36 or "default"
	end
})

local ConfigManager = u2.ConfigManager

if not ConfigManager then
	t13.Config:Paragraph({
		Title = "Config Manager Not Available",
		Desc = "This feature requires ConfigManager",
		Image = "alert-triangle",
		ImageSize = 20,
		Color = "White"
	})
else
	ConfigManager:Init(u2)
	t13.Config:Button({
		Title = "Save config",
		Icon = "save",
		Variant = "Primary",
		Callback = function()
			-- upvalues: u125 (ref), ConfigManager (ref), s4 (ref), t14 (ref), u1 (ref)
			u125 = ConfigManager:CreateConfig(s4)
			u125:Register("featureToggle", featureToggle)
			u125:Register("intensitySlider", intensitySlider)
			u125:Register("modeDropdown", modeDropdown)
			u125:Register("themeDropdown", themeDropdown)
			u125:Register("transparencySlider", transparencySlider)
			u125:Set("playerData", t14)
			u125:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))

			if not u125:Save() then
				u1:Notify({
					Title = "Error",
					Content = "Failed to save config",
					Icon = "x",
					Duration = 3
				})
			else
				u1:Notify({
					Title = "loc:SAVE_CONFIG",
					Content = "Saved as: " .. s4,
					Icon = "check",
					Duration = 3
				})
			end
		end
	})
	t13.Config:Button({
		Title = "Load config",
		Icon = "folder",
		Callback = function()
			-- upvalues: u125 (ref), ConfigManager (ref), s4 (ref), t14 (ref), u1 (ref), t13 (ref)
			u125 = ConfigManager:CreateConfig(s4)

			local v287 = u125:Load()

			if not v287 then
				u1:Notify({
					Title = "Error",
					Content = "Failed to load config",
					Icon = "x",
					Duration = 3
				})
			else
				if v287.playerData then
					t14 = v287.playerData
				end

				local v288 = v287.lastSave or "Unknown"

				u1:Notify({
					Title = "Load config",
					Content = "Loaded: " .. s4 .. "\nLast save: " .. v288,
					Icon = "refresh-cw",
					Duration = 5
				})
				t13.Config:Paragraph({
					Title = "Player Data",
					Desc = string.format("Name: %s\nLevel: %d\nInventory: %s", t14.name, t14.level, table.concat(t14.inventory, ", "))
				})
			end
		end
	})
end

local LocalPlayer15 = game:GetService("Players").LocalPlayer
local u129 = LocalPlayer15.Character or LocalPlayer15.CharacterAdded:Wait()
local t15 = {
	red = Color3.fromRGB(255, 0, 0),
	green = Color3.fromRGB(0, 255, 0),
	blue = Color3.fromRGB(0, 0, 255),
	yellow = Color3.fromRGB(255, 255, 0),
	orange = Color3.fromRGB(255, 165, 0),
	pink = Color3.fromRGB(255, 105, 180),
	purple = Color3.fromRGB(128, 0, 128),
	brown = Color3.fromRGB(139, 69, 19),
	gray = Color3.fromRGB(128, 128, 128),
	black = Color3.fromRGB(0, 0, 0),
	white = Color3.fromRGB(255, 255, 255),
	cyan = Color3.fromRGB(0, 255, 255),
	magenta = Color3.fromRGB(255, 0, 255),
	lime = Color3.fromRGB(191, 255, 0),
	indigo = Color3.fromRGB(75, 0, 130),
	violet = Color3.fromRGB(238, 130, 238),
	gold = Color3.fromRGB(255, 215, 0),
	silver = Color3.fromRGB(192, 192, 192),
	navy = Color3.fromRGB(0, 0, 128),
	teal = Color3.fromRGB(0, 128, 128),
	maroon = Color3.fromRGB(128, 0, 0),
	olive = Color3.fromRGB(128, 128, 0),
	aqua = Color3.fromRGB(0, 255, 255),
	coral = Color3.fromRGB(255, 127, 80),
	chocolate = Color3.fromRGB(210, 105, 30),
	khaki = Color3.fromRGB(240, 230, 140),
	lavender = Color3.fromRGB(230, 230, 250),
	beige = Color3.fromRGB(245, 245, 220),
	crimson = Color3.fromRGB(220, 20, 60),
	slate = Color3.fromRGB(112, 128, 144)
}
local u131 = nil
local u132 = false
local u133 = nil

local function u134(p37, p38)
	if p37:IsA("ParticleEmitter") or p37:IsA("Trail") or p37:IsA("Beam") then
		p37.Color = ColorSequence.new(p38)
	end
end
local function u135(p39, p40)
	-- upvalues: u133 (ref), u134 (ref), u132 (ref)
	if u133 then
		u133:Disconnect()
		u133 = nil
	end

	for _, descendant in ipairs(p39:GetDescendants()) do
		u134(descendant, p40)
	end

	u133 = p39.DescendantAdded:Connect(function(descendant)
		-- upvalues: u132 (ref), u134 (ref), p40 (ref)
		if u132 then
			u134(descendant, p40)
		end
	end)
end
local function u136(p41)
	-- upvalues: u132 (ref), u133 (ref)
	for _, descendant in ipairs(p41:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
			descendant:Destroy()
		end
	end

	u132 = false

	if u133 then
		u133:Disconnect()
		u133 = nil
	end
end

LocalPlayer15.CharacterAdded:Connect(function(character)
	-- upvalues: u129 (ref), u132 (ref), u131 (ref), u135 (ref)
	u129 = character

	if u132 and u131 then
		u135(character, u131)
	end
end)

local t16 = {}

for k, _ in pairs(t15) do
	table.insert(t16, k)
end

table.sort(t16)
t13.Appearance:Dropdown({
	Title = "Select Color",
	Values = t16,
	Callback = function(p42)
		-- upvalues: t15 (ref), u131 (ref)
		if t15[p42] then
			u131 = t15[p42]
		end
	end
})
t13.Appearance:Button({
	Title = "Apply Color",
	Icon = "brush",
	Callback = function()
		-- upvalues: u131 (ref), u132 (ref), u135 (ref), u129 (ref)
		if not u131 then
			warn("Please select a color first!")
		else
			u132 = true
			u135(u129, u131)
			print("VFX color changed to " .. tostring(u131))
		end
	end
})
t13.Appearance:Button({
	Title = "Reset Color",
	Icon = "rotate-ccw",
	Callback = function()
		-- upvalues: u136 (ref), u129 (ref)
		u136(u129)
		print("VFX reset to default")
	end
})
t13.Appearance:Button({
	Title = "Changer Color By Dovi",
	Icon = "rotate-ccw",
	Callback = function()
		print("")
	end
})
