-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {
	value1 = false
}

pcall(function()
	local getgenv_ = getgenv

	if getgenv_ then
		getgenv_ = getgenv()

		if getgenv_ then
			getgenv_ = getgenv().NoAutoExecute == true
		end
	end

	if not getgenv_ then
		return
	end

	t2.value1 = true
end)

if not t2.value1 then
	if getgenv().AlreadyExecutedTheIntruders then
		return
	end

	t1.value1 = getgenv()
	t1.value1.AlreadyExecutedTheIntruders = true
	task.spawn(function()
		local queue_on_teleport_ = queue_on_teleport or queueonteleport

		if not queue_on_teleport_ then
			return
		end

		pcall(function()
			queue_on_teleport_("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/BestProgramerf/The-Intruders/refs/heads/main/script.lua\"))()")
		end)
	end)
end

repeat
	task.wait()
	t1.value1 = game:IsLoaded()
until t1.value1

t2.value2 = false
t2.value3 = "https://api.luarmor.net/files/v3/loaders/"
t2.value4 = {
	ADS = {
		gameID = 2655311011,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	aNIMElEGACY = {
		gameID = 4844706238,
		scriptId = "628be512160a9e618f927c85963bbcd1"
	},
	PunshWallSimulator = {
		gameID = 4498728505,
		scriptId = ""
	},
	ACS = {
		gameID = 4280746206,
		scriptId = "4f5eb437a694518fd3ea9d5d7136a05a"
	},
	WFS = {
		gameID = 3262314006,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	AnimeEternal = {
		gameID = 7882829745,
		scriptId = "4f5eb437a694518fd3ea9d5d7136a05a"
	},
	RebirthChampionsUltimate = {
		gameID = 7178032757,
		scriptId = "e2916767e617f901b150d4de88f4761c"
	},
	AnimeExpeditions = {
		gameID = 7613921865,
		placeId = 84515722934860,
		scriptId = "e2916767e617f901b150d4de88f4761c"
	},
	CatchaMonster = {
		gameID = 9141743926,
		scriptId = "879ef174bb3e29652467ea4e8817cddd"
	},
	Evomon = {
		gameID = 9826885587,
		scriptId = "879ef174bb3e29652467ea4e8817cddd"
	},
	Gakuran = {
		gameID = 9199655655,
		placeId = 128736949265060,
		scriptId = "879ef174bb3e29652467ea4e8817cddd"
	},
	AnimeCrusaders = {
		gameID = 7660436108,
		scriptId = "4f5eb437a694518fd3ea9d5d7136a05a"
	},
	EmergencyHamburg = {
		gameID = 2992873140,
		scriptId = "4f5eb437a694518fd3ea9d5d7136a05a"
	},
	AnimeApocalypse = {
		gameID = 9073513091,
		scriptId = "4f5eb437a694518fd3ea9d5d7136a05a"
	},
	WeakLegacy2 = {
		gameID = 18337464872,
		scriptId = "628be512160a9e618f927c85963bbcd1"
	},
	AnimeLastStand = {
		gameID = 4509896324,
		scriptId = "628be512160a9e618f927c85963bbcd1"
	},
	AnimeWeapons = {
		gameID = 79189799490564,
		scriptId = "628be512160a9e618f927c85963bbcd1"
	},
	MurderMystery2 = {
		gameID = 66654135,
		scriptId = "628be512160a9e618f927c85963bbcd1"
	},
	TapSimulator = {
		gameID = 8779464785,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	TheForge = {
		gameID = 7671049560,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	FishIt = {
		gameID = 6701277882,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	BladeBall = {
		gameID = 4777817887,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	AnimeFishingOdyssey = {
		gameID = 6936077272,
		placeId = 129705892696040,
		scriptId = "c4ef0d5ea877be9b24a9fb395b5f40d7"
	},
	SlimeRNG = {
		gameID = 9792947201,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	SellLemons = {
		gameID = 7395930870,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	BuildARingFarm = {
		gameID = 10039338037,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	SquidGameX = {
		gameID = 2936053166,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	BeALuckyBlock = {
		gameID = 9787206684,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	GrowaGarden2 = {
		gameID = 10200395747,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	BubbleGumSimulatorINFINITY = {
		gameID = 6504986360,
		placeId = 85896571713843,
		scriptId = "ad915f5b5ca8c28b48b6620e7559fd8e"
	},
	UniversalHub = {
		isFallback = true,
		scriptId = "879ef174bb3e29652467ea4e8817cddd"
	},
	SurviveTheKiller = {
		gameID = 1489026993,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	VesteriaRewritten = {
		gameID = 833209132,
		placeId = 2376885433,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	EscapeLogForBrainrots = {
		gameID = 9497625867,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	SurviveZombieArena = {
		gameID = 9348272796,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	BuildADiggingEmpire = {
		gameID = 8729888050,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	IronSoulDungeon = {
		gameID = 9910245722,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	MineaPlanet = {
		gameID = 10406668651,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	CutGrassAdventure = {
		gameID = 10410945205,
		scriptId = "5a5e21b39c4b1967ac7cec975fa715f3"
	},
	SpinABaddie = {
		gameID = 9319914497,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	AnimeFightingSimulatorEndless = {
		gameID = 9266873836,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	BuildAnEmpire = {
		gameID = 8435447325,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	SpinASoccerCard = {
		gameID = 9272693470,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	HeroesRNG = {
		gameID = 10153098880,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	LineagePiece = {
		gameID = 9382839773,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	PowerPerClick = {
		gameID = 10485201326,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	MagicLoot = {
		gameID = 10506207587,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	},
	DungeonLootr = {
		gameID = 9656201728,
		scriptId = "eccd0fd1b683cad64e81c452dd0190f4"
	}
}

local Players = game:GetService("Players")

t2.value5 = nil
t2.value6 = Players.LocalPlayer
t2.value7 = t2.value6.DisplayName
t2.value8 = game:GetService("UserInputService")
t2.value9 = game:GetService("TweenService")
t2.value10 = game:GetService("CoreGui")
t2.value11 = nil
t2.value12 = {
	linkvertise = "https://ads.luarmor.net/get_key?for=The_Intruders-wnCxRooPLsPs",
	workink = "https://ads.luarmor.net/get_key?for=The_Intruders_2-qnHTgkOYElFH"
}
t2.value13 = (function()
	local game_ = game
	local v7 = game_.GetService(game_, "RunService")
	local t3 = {
		Flags = {}
	}
	local theme = {
		Default = {
			TextFont = "Default",
			TextColor = Color3.fromRGB(240, 240, 240),
			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(34, 34, 34),
			Shadow = Color3.fromRGB(20, 20, 20),
			NotificationBackground = Color3.fromRGB(20, 20, 20),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230)
		}
	}

	t3.Theme = theme

	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local v12 = game:GetObjects("rbxassetid://12673095331")[1]

	v12.Main:Destroy()
	v12.Enabled = false
	v12.Parent = CoreGui

	local CurrentCamera = workspace.CurrentCamera
	local Notifications = v12.Notifications
	local v15 = nil

	local function v16()
		local Template = v15

		if Template then
			Template = v15:FindFirstChild("Template")
		end

		if not Template then
			return
		end

		v15.Template.Visible = false

		local Actions = v15.Template:FindFirstChild("Actions")

		if Actions then
			Actions = v15.Template.Actions:FindFirstChild("Template")
		end

		if not Actions then
			return
		end

		v15.Template.Actions.Template.Visible = false
	end

	v15 = Notifications
	pcall(v16)
	v12.Enabled = true

	local Default = t3.Theme.Default
	local v20 = (function()
		local t4 = {}
		local x = CurrentCamera:ScreenPointToRay(0, 0).Origin.x
		local v23

		if x == x then
			v23 = true
		else
			v23 = false
		end

		while not v23 do
			v7.RenderStepped:wait()

			local x2 = CurrentCamera:ScreenPointToRay(0, 0).Origin.x

			v23 = x2 == x2
		end

		local v25

		if getgenv().SecureMode == nil then
			v25 = CurrentCamera
		elseif getgenv().SecureMode then
			v25 = nil
		else
			v25 = CurrentCamera
		end

		local t5 = {}
		local Folder = Instance.new("Folder", v25)

		Folder.Name = "neon"

		local n1 = 0
		local acos = math.acos
		local max = math.max
		local sqrt = math.sqrt

		function DrawTriangle(p1, p2, p3, p4, p5)
			local magnitude = (p1 - p2).magnitude
			local magnitude2 = (p2 - p3).magnitude
			local v34 = nil
			local magnitude3 = (p3 - p1).magnitude
			local v36 = nil
			local v37 = max(magnitude, magnitude2, magnitude3)
			local v38 = nil

			if magnitude == v37 then
				local v39 = p2

				p2 = p3
				p3 = p1
				p1 = v39
			elseif magnitude2 == v37 then
				local v40 = p2

				p2 = p1
				p1 = p3
				p3 = v40
			elseif magnitude3 ~= v37 then
				p2 = v34
				p3 = v36
				p1 = v38
			end

			local v41 = ((p1 - p3).x * (p2 - p3).x + (p1 - p3).y * (p2 - p3).y + (p1 - p3).z * (p2 - p3).z) / (p3 - p1).magnitude
			local v42 = sqrt((p2 - p3).magnitude ^ 2 - v41 * v41)
			local v43 = (p3 - p1).magnitude - v41
			local cFrame = CFrame.new(p1, p3)
			local cFrame2 = CFrame.Angles(1.5707963267948966, 0, 0)
			local lookVector = (cFrame * cFrame2).lookVector
			local v47 = p3 + CFrame.new(p3, p1).LookVector * v41
			local LookVector = CFrame.new(v47, p2).LookVector
			local v49 = lookVector.x * LookVector.x + lookVector.y * LookVector.y + lookVector.z * LookVector.z
			local cFrame3 = CFrame.Angles(0, 0, acos(v49))
			local v51 = cFrame * cFrame3

			if ((v51 * cFrame2).lookVector - LookVector).magnitude > 0.01 then
				v51 = v51 * CFrame.Angles(0, 0, -2 * acos(v49))
			end

			local cFrame4 = v51 * CFrame.new(0, v42 / 2, -(v43 + v41 / 2))
			local v53 = cFrame * cFrame3 * CFrame.Angles(0, 3.141592653589793, 0)

			if ((v53 * cFrame2).lookVector - LookVector).magnitude > 0.01 then
				v53 = v53 * CFrame.Angles(0, 0, 2 * acos(v49))
			end

			local cFrame5 = v53 * CFrame.new(0, v42 / 2, v43 / 2)

			if p4 then
				p4.WedgeMesh.Scale = Vector3.new(0, v42 / 0.2, v41 / 0.2)
				p4.CFrame = cFrame4
				v60 = p5 or p4:clone()
				v60.WedgeMesh.Scale = Vector3.new(0, v42 / 0.2, v43 / 0.2)
				v60.CFrame = cFrame5

				return p4, v60
			end

			p4 = Instance.new("Part")
			p4.FormFactor = "Custom"
			p4.TopSurface = 0
			p4.BottomSurface = 0
			p4.Anchored = true
			p4.CanCollide = false
			p4.Material = "Glass"
			p4.Size = Vector3.new(0.2, 0.2, 0.2)

			local SpecialMesh = Instance.new("SpecialMesh", p4)

			SpecialMesh.MeshType = 2
			SpecialMesh.Name = "WedgeMesh"
			p4.WedgeMesh.Scale = Vector3.new(0, v42 / 0.2, v41 / 0.2)
			p4.CFrame = cFrame4

			local v56 = p5 or p4:clone()

			v56.WedgeMesh.Scale = Vector3.new(0, v42 / 0.2, v43 / 0.2)
			v56.CFrame = cFrame5

			return p4, v56
		end

		local function v57(p6, p7, p8, p9, p10)
			local v58, v59 = DrawTriangle(p6, p7, p8, p10[1], p10[2])

			p10[1] = v58
			p10[2] = v59

			local v61, v62 = DrawTriangle(p8, p7, p9, p10[3], p10[4])

			p10[3] = v61
			p10[4] = v62
		end

		function t4.BindFrame(_, p11, p12)
			if v25 == nil then
				return
			end

			if t5[p11] then
				return t5[p11].parts
			end

			n1 = n1 + 1

			local v63 = n1
			local v64 = "neon::" .. tostring(v63)
			local t6 = {}
			local Folder2 = Instance.new("Folder", Folder)

			Folder2.Name = p11.Name

			local t7 = {}

			local function v67(p13)
				if not p13:IsA("GuiObject") then
					return
				end

				t7[#t7 + 1] = p13
				v67(p13.Parent)
			end

			v67(p11)

			local function v68(p14)
				local v69 = p11
				local v70 = 1 - 0.05 * p11.ZIndex
				local AbsolutePosition = v69.AbsolutePosition
				local v72 = p11.AbsolutePosition + p11.AbsoluteSize
				local vector2 = Vector2.new(v72.x, AbsolutePosition.y)
				local vector22 = Vector2.new(AbsolutePosition.x, v72.y)
				local n2 = 0

				for _, v in ipairs(t7) do
					n2 = n2 + v.Rotation
				end

				local v78

				if n2 == 0 then
					v78 = false
				else
					v78 = n2 % 180 ~= 0
				end

				if v78 then
					local v79 = AbsolutePosition:lerp(v72, 0.5)
					local v80 = math.rad(n2)
					local v81 = math.sin(v80)
					local v82 = math.rad(n2)
					local v83 = math.cos(v82)

					AbsolutePosition = Vector2.new(v83 * (AbsolutePosition.x - v79.x) - v81 * (AbsolutePosition.y - v79.y), v81 * (AbsolutePosition.x - v79.x) + v83 * (AbsolutePosition.y - v79.y)) + v79
					vector2 = Vector2.new(v83 * (vector2.x - v79.x) - v81 * (vector2.y - v79.y), v81 * (vector2.x - v79.x) + v83 * (vector2.y - v79.y)) + v79
					vector22 = Vector2.new(v83 * (vector22.x - v79.x) - v81 * (vector22.y - v79.y), v81 * (vector22.x - v79.x) + v83 * (vector22.y - v79.y)) + v79
					v72 = Vector2.new(v83 * (v72.x - v79.x) - v81 * (v72.y - v79.y), v81 * (v72.x - v79.x) + v83 * (v72.y - v79.y)) + v79
				end

				v57(CurrentCamera:ScreenPointToRay(AbsolutePosition.x, AbsolutePosition.y, v70).Origin, CurrentCamera:ScreenPointToRay(vector2.x, vector2.y, v70).Origin, CurrentCamera:ScreenPointToRay(vector22.x, vector22.y, v70).Origin, CurrentCamera:ScreenPointToRay(v72.x, v72.y, v70).Origin, t6)

				if not p14 then
					return
				end

				local v84, v85, v86 = pairs(t6)

				while true do
					local v87

					v86, v87 = v84(v85, v86)

					if not v86 then
						break
					end

					v87.Parent = Folder2
				end

				for k, v in pairs(p12) do
					for _, v2 in pairs(t6) do
						v2[k] = v
					end
				end
			end

			v68(true)
			v7:BindToRenderStep(v64, 2000, v68)
			t5[p11] = {
				uid = v64,
				parts = t6
			}

			return t5[p11].parts
		end
		function t4.Modify(_, p15, p16)
			local boundParts = t4:GetBoundParts(p15)

			if not boundParts then
				return
			end

			for k, v in pairs(p16) do
				for _, boundPart in pairs(boundParts) do
					boundPart[k] = v
				end
			end
		end
		function t4.UnbindFrame(_, p17)
			if v25 == nil then
				return
			end

			local v97 = t5[p17]

			if not v97 then
				return
			end

			v7:UnbindFromRenderStep(v97.uid)

			for _, part in pairs(v97.parts) do
				part:Destroy()
			end

			t5[p17] = nil
		end
		function t4.HasBinding(_, p18)
			return t5[p18] ~= nil
		end
		function t4.GetBoundParts(_, p19)
			local parts = t5[p19]

			if not parts then
				return parts
			end

			parts = t5[p19].parts

			return parts
		end

		return t4
	end)()

	function t3.Notify(_, p20)
		local t8 = {
			value1 = nil
		}

		local function v102()
			t8.value1 = t8.value1 or {}

			local u103 = true
			local clone = v15.Template:Clone()

			clone.Parent = v15
			clone.Name = t8.value1.Title or "Unknown Title"
			clone.Visible = true

			local SecureMode = nil
			local DepthOfFieldEffect = nil

			local function v107()
				if not getgenv then
					return
				end

				local genv = getgenv()

				if type(genv) ~= "table" then
					return
				end

				SecureMode = genv.SecureMode
			end

			SecureMode = nil
			pcall(v107)

			if not SecureMode then
				DepthOfFieldEffect = Instance.new("DepthOfFieldEffect", game:GetService("Lighting"))
				DepthOfFieldEffect.Enabled = true
				DepthOfFieldEffect.FarIntensity = 0
				DepthOfFieldEffect.FocusDistance = 51.6
				DepthOfFieldEffect.InFocusRadius = 50
				DepthOfFieldEffect.NearIntensity = 1
			end

			clone.Actions.Template.Visible = false

			local v109

			if t8.value1.Actions then
				v109 = SecureMode

				for _, action in pairs(t8.value1.Actions) do
					u103 = false

					local clone2 = clone.Actions.Template:Clone()

					clone2.BackgroundColor3 = Default.NotificationActionsBackground

					if Default ~= t3.Theme.Default then
						clone2.TextColor3 = Default.TextColor
					end

					clone2.Name = action.Name
					clone2.Visible = true
					clone2.Parent = clone.Actions
					clone2.Text = action.Name
					clone2.BackgroundTransparency = 1
					clone2.TextTransparency = 1
					clone2.Size = UDim2.new(0, clone2.TextBounds.X + 27, 0, 36)
					clone2.MouseButton1Click:Connect(function()
						local ok, result = pcall(action.Callback)

						if ok then
							u103 = true

							return
						end

						print("Rayfield | Action: " .. action.Name .. " Callback Error " .. tostring(result))
						u103 = true
					end)
				end
			else
				v109 = SecureMode
			end

			clone.BackgroundColor3 = Default.Background
			clone.Title.Text = t8.value1.Title or "Unknown"
			clone.Title.TextTransparency = 1
			clone.Title.TextColor3 = Default.TextColor
			clone.Description.Text = t8.value1.Content or "Unknown"
			clone.Description.TextTransparency = 1
			clone.Description.TextColor3 = Default.TextColor
			clone.Icon.ImageColor3 = Default.TextColor

			if t8.value1.Image then
				local Icon = clone.Icon
				local Image = t8.value1.Image

				Icon.Image = "rbxassetid://" .. tostring(Image)
			else
				clone.Icon.Image = "rbxassetid://3944680095"
			end

			clone.Icon.ImageTransparency = 1
			clone.Parent = v15
			clone.Size = UDim2.new(0, 260, 0, 80)
			clone.BackgroundTransparency = 1

			local v117 = TweenService
			local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint)
			local uDim2New = UDim2.new

			v117.Create(v117, clone, tweenInfo, {
				Size = uDim2New(0, 295, 0, 91)
			}):Play()
			TweenService:Create(clone, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 0.1
			}):Play()
			clone:TweenPosition(UDim2.new(0.5, 0, 0.915, 0), "Out", "Quint", 0.8, true)
			wait(0.3)
			TweenService:Create(clone.Icon, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
				ImageTransparency = 0
			}):Play()
			TweenService:Create(clone.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
				TextTransparency = 0
			}):Play()

			local v120 = TweenService
			local Description = clone.Description
			local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Quint)

			v120.Create(v120, Description, tweenInfo2, {
				TextTransparency = 0.2
			}):Play()
			wait(0.2)

			if v109 == nil then
				TweenService:Create(clone, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
					BackgroundTransparency = 0.4
				}):Play()
			elseif v109 then
				TweenService:Create(clone, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
					BackgroundTransparency = 0
				}):Play()
			else
				TweenService:Create(clone, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
					BackgroundTransparency = 0.4
				}):Play()
			end

			if v12.Name == "Rayfield" then
				local v123 = v20
				local BlurModule = clone.BlurModule

				v123.BindFrame(v123, BlurModule, {
					Transparency = 0.98,
					BrickColor = BrickColor.new("Institutional white")
				})
			end

			if t8.value1.Actions then
				wait(0.8)

				local v125 = TweenService
				local tweenInfo3 = TweenInfo.new(0.7, Enum.EasingStyle.Quint)
				local UDim2_ = UDim2

				v125.Create(v125, clone, tweenInfo3, {
					Size = UDim2_.new(0, 295, 0, 132)
				}):Play()
				wait(0.3)

				local ipairs_ = ipairs
				local Actions = clone.Actions

				for _, child in ipairs_(Actions.GetChildren(Actions)) do
					local v132 = child.ClassName == "TextButton"

					if v132 then
						v132 = child.Name ~= "Template"
					end

					if v132 then
						local v133 = TweenService
						local tweenInfo4 = TweenInfo.new(0.5, Enum.EasingStyle.Quint)

						v133.Create(v133, child, tweenInfo4, {
							BackgroundTransparency = 0.2
						}):Play()

						local v135 = TweenService
						local tweenInfoNew = TweenInfo.new
						local EasingStyle = Enum.EasingStyle

						v135.Create(v135, child, tweenInfoNew(0.6, EasingStyle.Quint), {
							TextTransparency = 0
						}):Play()
						wait(0.05)
					end
				end
			else
				wait(t8.value1.Duration or 6)
			end

			repeat
				wait(0.001)
			until u103

			local ipairs_ = ipairs
			local Actions = clone.Actions

			for _, child in ipairs_(Actions.GetChildren(Actions)) do
				local v142 = child.ClassName == "TextButton"

				if v142 then
					v142 = child.Name ~= "Template"
				end

				if v142 then
					local v143 = TweenService
					local tweenInfo3 = TweenInfo.new(0.5, Enum.EasingStyle.Quint)

					v143.Create(v143, child, tweenInfo3, {
						BackgroundTransparency = 1
					}):Play()

					local v145 = TweenService
					local tweenInfo4 = TweenInfo.new(0.6, Enum.EasingStyle.Quint)

					v145.Create(v145, child, tweenInfo4, {
						TextTransparency = 1
					}):Play()
				end
			end

			local v147 = TweenService
			local Title = clone.Title
			local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quint)

			v147.Create(v147, Title, tweenInfo3, {
				Position = UDim2.new(0.47, 0, 0.234, 0)
			}):Play()

			local v150 = TweenService
			local Description2 = clone.Description
			local tweenInfo4 = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
			local UDim2_ = UDim2

			v150.Create(v150, Description2, tweenInfo4, {
				Position = UDim2_.new(0.528, 0, 0.637, 0)
			}):Play()

			local v154 = TweenService
			local tweenInfo5 = TweenInfo.new(0.6, Enum.EasingStyle.Quint)
			local UDim2_2 = UDim2

			v154.Create(v154, clone, tweenInfo5, {
				Size = UDim2_2.new(0, 280, 0, 83)
			}):Play()
			TweenService:Create(clone.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
				ImageTransparency = 1
			}):Play()
			TweenService:Create(clone, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 0.6
			}):Play()
			wait(0.3)
			TweenService:Create(clone.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
				TextTransparency = 0.4
			}):Play()

			local v157 = TweenService
			local Description3 = clone.Description
			local tweenInfo6 = TweenInfo.new(0.6, Enum.EasingStyle.Quint)

			v157.Create(v157, Description3, tweenInfo6, {
				TextTransparency = 0.5
			}):Play()
			wait(0.4)

			local v160 = TweenService
			local tweenInfo7 = TweenInfo.new(0.9, Enum.EasingStyle.Quint)
			local uDim2New2 = UDim2.new

			v160.Create(v160, clone, tweenInfo7, {
				Size = uDim2New2(0, 260, 0, 0)
			}):Play()
			TweenService:Create(clone, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 1
			}):Play()
			TweenService:Create(clone.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
				TextTransparency = 1
			}):Play()
			TweenService:Create(clone.Description, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
				TextTransparency = 1
			}):Play()
			wait(0.2)

			if v109 then
				wait(0.9)
				clone:Destroy()

				return
			end

			v20:UnbindFrame(clone.BlurModule)
			DepthOfFieldEffect:Destroy()
			wait(0.9)
			clone:Destroy()
		end

		t8.value1 = p20
		spawn(v102)
	end

	return t3
end)()
t2.value14 = UDim2
t2.value15 = Enum
t2.value16 = TweenInfo
t2.value17 = getgenv
t2.value18 = writefile
t2.value19 = readfile
t2.value20 = isfile
t2.value21 = setclipboard
t2.value22 = syn
t2.value23 = gethui
t2.value24 = get_hidden_gui
t2.value25 = is_sirhurt_closure

function t2.value26()
	local PlaceId = game.PlaceId
	local GameId = game.GameId
	local pairs_ = pairs
	local v166, v167, v168 = pairs_(t2.value4)

	while true do
		local v169, v170 = v166(v167, v168)

		if not v169 then
			break
		end

		if v170.isFallback then
			v168 = v169
		else
			if v170.gameID == PlaceId or (v170.gameID == GameId or (v170.placeId == PlaceId and true or v170.universeId == GameId)) then
				return v170.scriptId, v169
			end

			local placeIds = v170.placeIds

			if type(placeIds) == "table" then
				pairs_ = ipairs
				v168 = v169

				for _, placeId in pairs_(v170.placeIds) do
					if placeId == PlaceId then
						return v170.scriptId, v169
					end
				end
			else
				v168 = v169
			end
		end
	end

	local UniversalHub = t2.value4.UniversalHub
	local v175

	if UniversalHub then
		v175 = type(UniversalHub) == "table"
	else
		v175 = UniversalHub
	end

	if v175 then
		return UniversalHub.scriptId, "UniversalHub"
	else
		return nil, nil
	end
end
function t2.value27()
	local value17 = t2.value17

	if value17 then
	elseif value17 then
		return t2.value17().script_key or script_key
	else
		return script_key
	end

	value17 = t2.value17()

	if value17 then
		return t2.value17().script_key or script_key
	else
		return script_key
	end
end
function t2.value28()
	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
	end)

	if ok then
	elseif ok then
		return result
	else
		warn("Failed to load Luarmor library: " .. tostring(result))

		return nil
	end

	ok = type(result) == "table"

	if ok then
		return result
	else
		warn("Failed to load Luarmor library: " .. tostring(result))

		return nil
	end
end
function t2.value29(p21, p22)
	if not p22 or (not p21 or p21 == "") then
		return false, "Invalid key or API not loaded", nil
	else
		local v179 = p22.check_key(p21)

		if v179 then
			return v179.code == "KEY_VALID", v179.message or "Unknown error", v179
		else
			return false, "Failed to check key", nil
		end
	end
end
function t2.value30(p23)
	local v180 = nil

	local function v181()
		if t2.value24 or t2.value23 then
			v180.Parent = (t2.value24 or t2.value23)()

			return
		end

		local v182 = not t2.value25

		if v182 then
			v182 = t2.value22

			if v182 then
				v182 = t2.value22.protect_gui
			end
		end

		if v182 then
			t2.value22.protect_gui(v180)
			v180.Parent = t2.value10

			return
		end

		if not t2.value10 then
			return
		end

		v180.Parent = t2.value10
	end

	v180 = p23

	local ok, result = pcall(v181)

	if not (not ok and result) then
		return
	end

	v180.Parent = t2.value6:FindFirstChildWhichIsA("PlayerGui")
end
function t2.value31(p24, p25)
	pcall(function()
		local u185 = false
		local u186 = false
		local u187 = false
		local u188 = false

		p24.InputBegan:Connect(function(input)
			if input.UserInputType ~= t2.value15.UserInputType.MouseButton1 then
				return
			end

			u185 = true
			u187 = input.Position
			u188 = p25.Position
			input.Changed:Connect(function()
				if input.UserInputState ~= t2.value15.UserInputState.End then
					return
				end

				u185 = false
			end)
		end)
		p24.InputChanged:Connect(function(input)
			if input.UserInputType ~= t2.value15.UserInputType.MouseMovement then
				return
			end

			u186 = input
		end)
		t2.value8.InputChanged:Connect(function(input)
			local v189

			if input == u186 then
				v189 = u185
			else
				v189 = false
			end

			if not v189 then
				return
			end

			local v190 = input.Position - u187

			t2.value9:Create(p25, t2.value16.new(0.45, t2.value15.EasingStyle.Quint, t2.value15.EasingDirection.Out), {
				Position = t2.value14.new(u188.X.Scale, u188.X.Offset + v190.X, u188.Y.Scale, u188.Y.Offset + v190.Y)
			}):Play()
		end)
	end)
end
function t2.value32(p26, p27)
	local v191 = p27 or 0.45
	local v192 = t2.value16.new(v191, t2.value15.EasingStyle.Quint, t2.value15.EasingDirection.Out)

	local function v193(p28, p29)
		local v194 = nil

		local function v195()
			t2.value9:Create(p28, v192, v194):Play()
		end

		v194 = p29
		pcall(v195)
	end

	local GetDescendants = p26.GetDescendants

	for _, v in ipairs(GetDescendants(p26)) do
		if v:IsA("TextLabel") or (v:IsA("TextButton") or v:IsA("TextBox")) then
			v193(v, {
				TextTransparency = 1
			})
		end

		if v:IsA("ImageLabel") or v:IsA("ImageButton") then
			v193(v, {
				ImageTransparency = 1
			})
		end

		if v:IsA("Frame") or (v:IsA("TextLabel") or (v:IsA("TextButton") or (v:IsA("TextBox") or (v:IsA("ImageLabel") or (v:IsA("ImageButton") or v:IsA("ScrollingFrame")))))) then
			v193(v, {
				BackgroundTransparency = 1
			})
		end
	end

	v193(p26, {
		BackgroundTransparency = 1
	})
	task.wait(v191 + 0.05)
end

local UserId = t2.value6.UserId

t2.value33 = tostring(UserId) .. "Mykey.txt"
t2.value34 = 86400
t2.value35 = tostring(UserId) .. "_UNCWarningCooldown.txt"

local function v200()
	local ok, result = pcall(function()
		return DateTime.now().UnixTimestamp
	end)

	if ok then
		ok = type(result) == "number"
	end

	if ok then
		return result
	end

	local ok2, result2 = pcall(os.time)

	if not ok2 then
		return not ok2 and 0 or result2
	end

	ok2 = type(result2) == "number"

	return not ok2 and 0 or result2
end

function t2.value36()
	if t2.value20(t2.value35) then
		local v205 = t2.value19(t2.value35)
		local v206 = tonumber(v205)

		if v206 then
			return v206
		else
			return nil
		end
	else
		return nil
	end
end
function t2.value37()
	local v207 = t2.value36()

	if v207 then
		return v200() - v207 < t2.value34
	else
		return false
	end
end
function t2.value38(p30)
	t2.value18(t2.value33, p30)
end
function t2.value39()
	if t2.value20(t2.value33) then
		return t2.value19(t2.value33)
	else
		t2.value18(t2.value33, "")

		return ""
	end
end

t2.value11 = nil

function t2.value40(p31, p32)
	if not p32 then
		local script_id

		if p31 then
			script_id = p31.script_id
		else
			script_id = p31
		end

		p32 = script_id or t2.value11
	end

	if not p32 or p32 == "" then
		local value13 = t2.value13

		value13.Notify(value13, {
			Title = "Unsupported Game",
			Content = "No script configured for this game.",
			Duration = 7
		})

		return
	end

	local v210 = t2.value27()

	if not v210 or v210 == "" then
		t2.value13:Notify({
			Title = "Error!",
			Content = "Script key not set. Please enter a valid key.",
			Duration = 7
		})

		return
	end

	local ok, result = pcall(function()
		p31.load_script()
	end)

	if ok then
		return
	end

	warn("api.load_script failed, falling back to direct loader: " .. tostring(result))

	local v213 = t2.value3 .. p32 .. ".lua"
	local ok2, result2 = pcall(function()
		return loadstring(game:HttpGet(v213))
	end)

	if ok2 and result2 then
		result2()

		return
	end

	warn("Failed to load and execute loader for script_id: " .. tostring(p32))
end
function t2.value41()
	local s1 = "Unknown"

	local function v217()
		local identifyexecutor_ = identifyexecutor

		if type(identifyexecutor_) == "function" then
			local v219 = identifyexecutor()
			local v220

			if type(v219) == "string" then
				v220 = v219 ~= ""
			else
				v220 = false
			end

			if v220 then
				s1 = v219

				return
			else
				return
			end
		end

		local getexecutorname_ = getexecutorname

		if type(getexecutorname_) ~= "function" then
			return
		end

		local v222 = getexecutorname()
		local v223

		if type(v222) == "string" then
			v223 = v222 ~= ""
		else
			v223 = false
		end

		if not v223 then
			return
		end

		s1 = v222
	end

	pcall(v217)

	return s1
end
function t2.value42(p33)
	local t9 = {
		passed = {},
		failed = {}
	}
	local n3 = 100
	local request_

	if type(request) == "function" then
		request_ = request
	else
		request_ = false
	end

	if not request_ then
		local http_request_ = http_request

		if type(http_request_) == "function" then
			request_ = http_request
		else
			request_ = false
		end
	end

	if not request_ then
		return n3, t9
	end

	local s2 = "WEAO-3PService"
	local v229

	if p33 then
		v229 = p33 ~= "Unknown"
	else
		v229 = p33
	end

	if v229 then
		v229 = string.lower(p33)
	end

	local suncKey = nil
	local v231 = v229 or nil
	local suncScrap = nil
	local ok, result = pcall(request_, {
		Url = "https://weao.xyz/api/status/exploits",
		Method = "GET",
		Headers = {
			["User-Agent"] = s2
		}
	})

	if ok then
		if result then
			ok = result.StatusCode == 200
		else
			ok = result
		end
	end

	local v235

	if ok then
		local ok2, result2 = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), result.Body)

		if ok2 then
			ok2 = type(result2) == "table"
		end

		if ok2 then
			v235 = s2

			for _, v in ipairs(result2) do
				local title

				if v231 then
					title = v.title

					if title then
						title = string.find(string.lower(v.title), v231, 1, true)
					end
				else
					title = v231
				end

				if title then
					local sunc = v.sunc

					if sunc then
						sunc = v.sunc.suncScrap

						if sunc then
							sunc = v.sunc.suncKey
						end
					end

					if sunc then
						suncScrap = v.sunc.suncScrap
						suncKey = v.sunc.suncKey

						if type(v.suncPercentage) == "number" then
							n3 = v.suncPercentage
						end
					end

					break
				end
			end
		else
			v235 = s2
		end
	else
		v235 = s2
	end

	if not (suncScrap and suncKey) then
		return n3, t9
	end

	local ok2, result2 = pcall(request_, {
		Url = "https://weao.xyz/api/sunc?scrap=" .. suncScrap .. "&key=" .. suncKey,
		Method = "GET",
		Headers = {
			["User-Agent"] = v235
		}
	})

	if ok2 then
		if result2 then
			ok2 = result2.StatusCode == 200
		else
			ok2 = result2
		end
	end

	if not ok2 then
		return n3, t9
	end

	local ok3, result3 = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), result2.Body)

	if ok3 then
		ok3 = type(result3) == "table"

		if ok3 then
			local tests = result3.tests

			ok3 = type(tests) == "table"
		end
	end

	if not ok3 then
		return n3, t9
	end

	local passed = result3.tests.passed

	if type(passed) == "table" then
		for _, v in ipairs(result3.tests.passed) do
			table.insert(t9.passed, v.name or tostring(v))
		end
	end

	local failed = result3.tests.failed

	if type(failed) == "table" then
		for _, v in ipairs(result3.tests.failed) do
			local failed2 = t9.failed
			local name = v.name or tostring(v)

			table.insert(failed2, name)
		end
	end

	local v255 = #t9.passed + #t9.failed

	if not (v255 > 0) then
		return n3, t9
	end

	local v256 = #t9.passed / v255 * 100

	n3 = math.round(v256)

	return n3, t9
end

t2.value43 = nil

function t2.value44(p34, p35, p36)
	local v257 = p36 or {}
	local onManualDismiss = v257.onManualDismiss
	local isBlocked = v257.isBlocked or false
	local executorName = v257.executorName or "Unknown"
	local failedTests = v257.failedTests or {}
	local passedTests = v257.passedTests or {}
	local color3 = Color3.fromRGB(12, 12, 18)
	local color32 = Color3.fromRGB(20, 20, 30)
	local color33 = Color3.fromRGB(28, 28, 40)
	local color34 = Color3.fromRGB(240, 240, 245)
	local color35 = Color3.fromRGB(160, 165, 180)
	local color36 = Color3.fromRGB(100, 105, 120)
	local color37 = Color3.fromRGB(235, 65, 65)
	local color38 = Color3.fromRGB(245, 158, 50)
	local color39 = Color3.fromRGB(65, 120, 255)
	local color310 = Color3.fromRGB(90, 145, 255)
	local color311 = Color3.fromRGB(50, 205, 100)
	local textColor3

	if p34 >= 85 then
		textColor3 = color311
	else
		textColor3 = false
	end

	if not textColor3 then
		local v275 = p34 >= 50

		if v275 then
			v275 = color38
		end

		textColor3 = v275 or color37
	end

	local v276 = isBlocked and color37 and color37 or color38
	local v277 = #passedTests + #failedTests
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "UNCWarningGui"
	ScreenGui.ZIndexBehavior = t2.value15.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = v257.displayOrder or 220

	local Frame = Instance.new("Frame")

	Frame.Name = "Overlay"
	Frame.Size = t2.value14.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Parent = ScreenGui

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Card"
	Frame2.Size = t2.value14.new(0, 0, 0, 0)
	Frame2.Position = v257.position or t2.value14.new(0.5, 0, 0.5, 0)
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.BackgroundColor3 = color3
	Frame2.BorderSizePixel = 0
	Frame2.ClipsDescendants = true
	Frame2.Parent = Frame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(40, 40, 55)
	UIStroke.Thickness = 1.5
	UIStroke.Transparency = 0
	UIStroke.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "AccentBar"
	Frame3.Size = t2.value14.new(1, 0, 0, 3)
	Frame3.Position = t2.value14.new(0, 0, 0, 0)
	Frame3.BackgroundColor3 = v276
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local n4 = 28
	local Frame4 = Instance.new("Frame")

	Frame4.Name = "HeaderRow"
	Frame4.Size = t2.value14.new(1, -n4 * 2, 0, 56)
	Frame4.Position = t2.value14.new(0, n4, 0, 18)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame2

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "IconCircle"
	Frame5.Size = t2.value14.new(0, 44, 0, 44)
	Frame5.Position = t2.value14.new(0, 0, 0.5, 0)
	Frame5.AnchorPoint = Vector2.new(0, 0.5)
	Frame5.BackgroundColor3 = v276
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame4

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Frame5

	local Frame6 = Instance.new("Frame")

	Frame6.Size = t2.value14.new(0, 56, 0, 56)
	Frame6.Position = t2.value14.new(0.5, 0, 0.5, 0)
	Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame6.BackgroundColor3 = v276
	Frame6.BackgroundTransparency = 0.85
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5
	Instance.new("UICorner", Frame6).CornerRadius = UDim.new(1, 0)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = t2.value14.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = isBlocked and "🚫" or "⚠️"
	TextLabel.TextSize = 22
	TextLabel.Font = t2.value15.Font.GothamBold
	TextLabel.TextColor3 = color34
	TextLabel.Parent = Frame5

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "Title"
	TextLabel2.Size = t2.value14.new(1, -58, 0, 24)
	TextLabel2.Position = t2.value14.new(0, 56, 0, 6)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = isBlocked and "Executor Not Supported" or "Executor Compatibility Warning"
	TextLabel2.TextSize = 17
	TextLabel2.TextColor3 = color34
	TextLabel2.Font = t2.value15.Font.GothamBold
	TextLabel2.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel2.TextTruncate = t2.value15.TextTruncate.AtEnd
	TextLabel2.Parent = Frame4

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "Subtitle"
	TextLabel3.Size = t2.value14.new(1, -58, 0, 18)
	TextLabel3.Position = t2.value14.new(0, 56, 0, 32)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "Detected: " .. executorName
	TextLabel3.TextSize = 13
	TextLabel3.TextColor3 = isBlocked and color37 or color35
	TextLabel3.Font = t2.value15.Font.GothamMedium
	TextLabel3.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel3.Parent = Frame4

	local Frame7 = Instance.new("Frame")

	Frame7.Size = t2.value14.new(1, -n4 * 2, 0, 1)
	Frame7.Position = t2.value14.new(0, n4, 0, 80)
	Frame7.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
	Frame7.BorderSizePixel = 0
	Frame7.Parent = Frame2

	local Frame8 = Instance.new("Frame")

	Frame8.Name = "ScoreSection"
	Frame8.Size = t2.value14.new(1, -n4 * 2, 0, 75)
	Frame8.Position = t2.value14.new(0, n4, 0, 92)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = Frame2

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = "ScoreBig"
	TextLabel4.Size = t2.value14.new(0, 80, 0, 40)
	TextLabel4.Position = t2.value14.new(0, 0, 0, 4)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = p34 .. "%"
	TextLabel4.TextSize = 36
	TextLabel4.TextColor3 = textColor3
	TextLabel4.Font = t2.value15.Font.GothamBold
	TextLabel4.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel4.Parent = Frame8

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Size = t2.value14.new(0, 80, 0, 16)
	TextLabel5.Position = t2.value14.new(0, 0, 0, 44)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = "UNC Score"
	TextLabel5.TextSize = 11
	TextLabel5.TextColor3 = color36
	TextLabel5.Font = t2.value15.Font.GothamMedium
	TextLabel5.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel5.Parent = Frame8

	local Frame9 = Instance.new("Frame")

	Frame9.Name = "BarContainer"
	Frame9.Size = t2.value14.new(1, -100, 0, 75)
	Frame9.Position = t2.value14.new(0, 100, 0, 0)
	Frame9.BackgroundTransparency = 1
	Frame9.Parent = Frame8

	local TextLabel6 = Instance.new("TextLabel")

	TextLabel6.Size = t2.value14.new(0.5, 0, 0, 16)
	TextLabel6.Position = t2.value14.new(0, 0, 0, 2)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Text = "✓ " .. #passedTests .. " passed"
	TextLabel6.TextSize = 12
	TextLabel6.TextColor3 = color311
	TextLabel6.Font = t2.value15.Font.GothamMedium
	TextLabel6.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel6.Parent = Frame9

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = t2.value14.new(0.5, 0, 0, 16)
	TextLabel7.Position = t2.value14.new(0.5, 0, 0, 2)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = "✗ " .. #failedTests .. " failed"
	TextLabel7.TextSize = 12
	TextLabel7.TextColor3 = color37
	TextLabel7.Font = t2.value15.Font.GothamMedium
	TextLabel7.TextXAlignment = t2.value15.TextXAlignment.Right
	TextLabel7.Parent = Frame9

	local Frame10 = Instance.new("Frame")

	Frame10.Name = "BarTrack"
	Frame10.Size = t2.value14.new(1, 0, 0, 10)
	Frame10.Position = t2.value14.new(0, 0, 0, 26)
	Frame10.BackgroundColor3 = color33
	Frame10.BorderSizePixel = 0
	Frame10.ClipsDescendants = true
	Frame10.Parent = Frame9
	Instance.new("UICorner", Frame10).CornerRadius = UDim.new(1, 0)

	local Frame11 = Instance.new("Frame")

	Frame11.Name = "BarFill"
	Frame11.Size = t2.value14.new(0, 0, 1, 0)
	Frame11.BackgroundColor3 = textColor3
	Frame11.BorderSizePixel = 0
	Frame11.Parent = Frame10
	Instance.new("UICorner", Frame11).CornerRadius = UDim.new(1, 0)

	local Frame12 = Instance.new("Frame")

	Frame12.Size = t2.value14.new(0, 2, 1, 4)
	Frame12.Position = t2.value14.new(0.85, -1, 0, -2)
	Frame12.BackgroundColor3 = color36
	Frame12.BorderSizePixel = 0
	Frame12.Parent = Frame10

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Size = t2.value14.new(0, 60, 0, 14)
	TextLabel8.Position = t2.value14.new(0.85, -30, 0, 42)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = "85% min"
	TextLabel8.TextSize = 10
	TextLabel8.TextColor3 = color36
	TextLabel8.Font = t2.value15.Font.Gotham
	TextLabel8.Parent = Frame9

	local TextLabel9 = Instance.new("TextLabel")

	TextLabel9.Size = t2.value14.new(1, 0, 0, 14)
	TextLabel9.Position = t2.value14.new(0, 0, 0, 58)
	TextLabel9.BackgroundTransparency = 1
	TextLabel9.TextSize = 11
	TextLabel9.Font = t2.value15.Font.Gotham
	TextLabel9.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel9.TextColor3 = color36
	TextLabel9.Parent = Frame9

	if v277 > 0 then
		local v304 = #passedTests

		TextLabel9.Text = tostring(v304) .. "/" .. tostring(v277) .. " tests passed"
	else
		TextLabel9.Text = "Could not run tests"
	end

	local Frame13 = Instance.new("Frame")

	Frame13.Size = t2.value14.new(1, -n4 * 2, 0, 1)
	Frame13.Position = t2.value14.new(0, n4, 0, 178)
	Frame13.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
	Frame13.BorderSizePixel = 0
	Frame13.Parent = Frame2

	local Frame14 = Instance.new("Frame")

	Frame14.Name = "MsgCard"
	Frame14.Size = t2.value14.new(1, -n4 * 2, 0, 68)
	Frame14.Position = t2.value14.new(0, n4, 0, 190)
	Frame14.BackgroundColor3 = color32
	Frame14.BorderSizePixel = 0
	Frame14.Parent = Frame2
	Instance.new("UICorner", Frame14).CornerRadius = UDim.new(0, 10)

	local Frame15 = Instance.new("Frame")

	Frame15.Size = t2.value14.new(0, 3, 1, -8)
	Frame15.Position = t2.value14.new(0, 4, 0, 4)
	Frame15.BackgroundColor3 = v276
	Frame15.BorderSizePixel = 0
	Frame15.Parent = Frame14
	Instance.new("UICorner", Frame15).CornerRadius = UDim.new(0, 2)

	local TextLabel10 = Instance.new("TextLabel")

	TextLabel10.Name = "MsgText"
	TextLabel10.Size = t2.value14.new(1, -24, 1, -12)
	TextLabel10.Position = t2.value14.new(0, 16, 0, 6)
	TextLabel10.BackgroundTransparency = 1
	TextLabel10.TextWrapped = true
	TextLabel10.TextXAlignment = t2.value15.TextXAlignment.Left
	TextLabel10.TextYAlignment = t2.value15.TextYAlignment.Top
	TextLabel10.TextSize = 13
	TextLabel10.Font = t2.value15.Font.Gotham
	TextLabel10.TextColor3 = color35
	TextLabel10.Parent = Frame14

	local v309

	if isBlocked then
		TextLabel10.Text = "Your executor (" .. executorName .. ") is missing critical functions like hookmetamethod, hookfunction, and newcclosure. You must switch to a supported executor to run this script."
		v309 = onManualDismiss
	else
		local v310

		if #failedTests > 0 then
			local v311 = #failedTests

			v309 = onManualDismiss

			local t10 = {}

			for i = 1, math.min(5, v311) do
				local v314 = failedTests[i]

				table.insert(t10, v314)
			end

			v310 = "\nFailed: " .. table.concat(t10, ", ")

			if #failedTests > 5 then
				v310 = v310 .. " (+" .. #failedTests - 5 .. " more)"
			end
		else
			v309 = onManualDismiss
			v310 = ""
		end

		TextLabel10.Text = "Your executor scored below the 85% minimum. Some features may crash or not work properly." .. v310
	end

	local Frame16 = Instance.new("Frame")

	Frame16.Name = "SupportedRow"
	Frame16.Size = t2.value14.new(1, -n4 * 2, 0, 36)
	Frame16.Position = t2.value14.new(0, n4, 0, 270)
	Frame16.BackgroundTransparency = 1
	Frame16.Parent = Frame2

	local t11 = { "Delta", "Volt/AWP", "Wave" }
	local floor = math.floor
	local v318 = n4 * 2
	local v319 = (#t11 - 1) * 8
	local v320 = floor((480 - v318 - v319) / #t11)

	for i, v in ipairs(t11) do
		local Frame17 = Instance.new("Frame")

		Frame17.Size = t2.value14.new(0, v320, 0, 32)
		Frame17.Position = t2.value14.new(0, (i - 1) * (v320 + 8), 0, 2)
		Frame17.BackgroundColor3 = color32
		Frame17.BorderSizePixel = 0
		Frame17.Parent = Frame16
		Instance.new("UICorner", Frame17).CornerRadius = UDim.new(0, 8)

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Color = Color3.fromRGB(45, 55, 70)
		UIStroke2.Thickness = 1
		UIStroke2.Parent = Frame17

		local TextLabel11 = Instance.new("TextLabel")

		TextLabel11.Size = t2.value14.new(1, -8, 1, 0)
		TextLabel11.Position = t2.value14.new(0, 4, 0, 0)
		TextLabel11.BackgroundTransparency = 1
		TextLabel11.Text = "✓ " .. v
		TextLabel11.TextSize = 12
		TextLabel11.TextColor3 = color311
		TextLabel11.Font = t2.value15.Font.GothamMedium
		TextLabel11.Parent = Frame17
	end

	local n5 = 318
	local n6 = 42
	local n7 = 10
	local TextButton = Instance.new("TextButton")

	TextButton.Name = "PrimaryBtn"
	TextButton.Size = t2.value14.new(1, -n4 * 2, 0, n6)
	TextButton.Position = t2.value14.new(0, n4, 0, n5)
	TextButton.BackgroundColor3 = color39
	TextButton.BorderSizePixel = 0
	TextButton.AutoButtonColor = false
	TextButton.Text = isBlocked and "Get a Supported Executor" or "Copy Executor Link"
	TextButton.TextSize = 14
	TextButton.TextColor3 = color34
	TextButton.Font = t2.value15.Font.GothamBold
	TextButton.Parent = Frame2
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)
	TextButton.MouseEnter:Connect(function()
		local t12 = {
			BackgroundColor3 = color310
		}

		t2.value9:Create(TextButton, t2.value16.new(0.15), t12):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local t13 = {
			BackgroundColor3 = color39
		}

		t2.value9:Create(TextButton, t2.value16.new(0.15), t13):Play()
	end)

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Name = "SecondaryBtn"
	TextButton2.Size = t2.value14.new(1, -n4 * 2, 0, n6)
	TextButton2.Position = t2.value14.new(0, n4, 0, n5 + n6 + n7)
	TextButton2.BackgroundColor3 = color33
	TextButton2.BorderSizePixel = 0
	TextButton2.AutoButtonColor = false
	TextButton2.Text = isBlocked and "Continue Anyway (Not Recommended)" or isBlocked or "Continue Anyway"
	TextButton2.TextSize = 14

	local v333

	if isBlocked then
		v333 = color37
	else
		v333 = isBlocked
	end

	TextButton2.TextColor3 = v333 or color35
	TextButton2.Font = t2.value15.Font.GothamMedium
	TextButton2.Parent = Frame2
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 10)

	local UIStroke2 = Instance.new("UIStroke")
	local color312

	if isBlocked then
		color312 = Color3.fromRGB(80, 40, 40)
	else
		color312 = isBlocked
	end

	UIStroke2.Color = color312 or Color3.fromRGB(50, 50, 65)
	UIStroke2.Thickness = 1
	UIStroke2.Parent = TextButton2
	TextButton2.MouseEnter:Connect(function()
		local value9 = t2.value9
		local v337 = TextButton2
		local v338 = t2.value16.new(0.15)
		local color313 = Color3.fromRGB

		value9.Create(value9, v337, v338, {
			BackgroundColor3 = color313(38, 38, 50)
		}):Play()
	end)
	TextButton2.MouseLeave:Connect(function()
		local t14 = {
			BackgroundColor3 = color33
		}

		t2.value9:Create(TextButton2, t2.value16.new(0.15), t14):Play()
	end)

	local v341 = n5 + (n6 + n7) * 2 + 8
	local TextLabel11 = Instance.new("TextLabel")

	TextLabel11.Name = "TimerLabel"
	TextLabel11.Size = t2.value14.new(1, -n4 * 2, 0, 18)
	TextLabel11.Position = t2.value14.new(0, n4, 0, v341)
	TextLabel11.BackgroundTransparency = 1
	TextLabel11.TextSize = 11
	TextLabel11.Font = t2.value15.Font.Gotham
	TextLabel11.TextColor3 = color36
	TextLabel11.TextXAlignment = t2.value15.TextXAlignment.Center
	TextLabel11.Parent = Frame2

	if isBlocked then
		TextLabel11.Text = "⚠ Blocked executor — features may not work"
		TextLabel11.TextColor3 = Color3.fromRGB(200, 80, 80)
	else
		TextLabel11.Text = "Auto-closing in 30s..."
	end

	local u343 = false

	TextButton.Activated:Connect(function()
		local function v344()
			t2.value21("https://weao.xyz/")
		end

		pcall(v344)
		TextButton.Text = "✓ Link Copied!"

		local value9 = t2.value9
		local v346 = TextButton
		local v347 = t2.value16.new(0.15)
		local t15 = {
			BackgroundColor3 = color311
		}

		value9.Create(value9, v346, v347, t15):Play()
		task.wait(1.5)

		if u343 then
			return
		end

		local v349 = isBlocked

		TextButton.Text = v349 and "Get a Supported Executor" or v349 or "Copy Executor Link"

		local value92 = t2.value9
		local v351 = TextButton
		local t16 = {
			BackgroundColor3 = color39
		}

		value92.Create(value92, v351, t2.value16.new(0.15), t16):Play()
	end)

	local function v353(p37)
		if u343 then
			return
		end

		u343 = true

		if p37 then
			p37 = onManualDismiss
		end

		if p37 then
			pcall(onManualDismiss)
		end

		t2.value9:Create(Frame2, t2.value16.new(0.3, t2.value15.EasingStyle.Quint, t2.value15.EasingDirection.Out), {
			Size = t2.value14.new(0, 480, 0, 560),
			BackgroundTransparency = 1
		}):Play()
		t2.value9:Create(Frame, t2.value16.new(0.3), {
			BackgroundTransparency = 1
		}):Play()
		t2.value32(Frame2, 0.25)
		task.wait(0.35)
		ScreenGui:Destroy()

		if not p35 then
			return
		end

		p35()
	end

	TextButton2.Activated:Connect(function()
		v353(true)
	end)
	task.spawn(function()
		if isBlocked then
			return
		end

		local n8 = 30

		while n8 >= 0 and not u343 do
			TextLabel11.Text = "Auto-closing in " .. n8 .. "s..."

			if n8 <= 10 then
				TextLabel11.TextColor3 = color37
			elseif n8 <= 20 then
				TextLabel11.TextColor3 = color38
			else
				TextLabel11.TextColor3 = color36
			end

			task.wait(1)
			n8 = n8 - 1
		end

		if u343 then
			return
		end

		v353(false)
	end)
	t2.value30(ScreenGui)
	t2.value31(Frame2, Frame2)
	t2.value9:Create(Frame, t2.value16.new(0.35), {
		BackgroundTransparency = 0.45
	}):Play()

	local value9 = t2.value9
	local new = t2.value16.new
	local value15 = t2.value15

	value9.Create(value9, Frame2, new(0.45, value15.EasingStyle.Back, t2.value15.EasingDirection.Out), {
		Size = t2.value14.new(0, 480, 0, 580)
	}):Play()
	task.delay(0.5, function()
		local Parent = Frame11

		if Parent then
			Parent = Frame11.Parent
		end

		if not Parent then
			return
		end

		local v359 = v277 > 0

		if v359 then
			local v360 = #passedTests / v277

			v359 = math.clamp(v360, 0, 1)
		end

		local value92 = t2.value9
		local v362 = Frame11
		local v363 = t2.value16.new(0.8, t2.value15.EasingStyle.Quint, t2.value15.EasingDirection.Out)
		local t17 = {
			Size = t2.value14.new(v359 or 0, 0, 1, 0)
		}

		value92.Create(value92, v362, v363, t17):Play()
	end)
	task.spawn(function()
		while ScreenGui.Parent do
			local value92 = t2.value9
			local v366 = Frame6
			local value16 = t2.value16

			value92.Create(value92, v366, value16.new(1.2, t2.value15.EasingStyle.Sine, t2.value15.EasingDirection.InOut), {
				BackgroundTransparency = 0.7
			}):Play()
			task.wait(1.2)
			t2.value9:Create(Frame6, t2.value16.new(1.2, t2.value15.EasingStyle.Sine, t2.value15.EasingDirection.InOut), {
				BackgroundTransparency = 0.92
			}):Play()
			task.wait(1.2)
		end
	end)

	return ScreenGui
end
function t2.value45(p38)
	local value2 = t2.value2

	if not value2 then
		local function v369()
			local value17 = t2.value17

			if value17 then
				value17 = t2.value17()

				if value17 then
					value17 = t2.value17().FORCE_UNC_WARNING
				end
			end

			if not value17 then
				return
			end

			value2 = true
		end

		pcall(v369)
	end

	local v371 = t2.value41()
	local n9 = 100
	local t18 = {
		passed = {},
		failed = {}
	}

	local function v374()
		local v375, v376 = t2.value42(v371)

		n9 = v375
		t18 = v376
	end

	pcall(v374)
	t18 = t18 or {
		passed = {},
		failed = {}
	}

	if value2 then
		local v377 = n9 >= 85
	end

	local v378 = v406 and 42 or n9
	local value43 = t2.value43

	if value43 then
		value43 = t2.value43(p38)
	end

	if value43 then
		pcall(function()
			value43.DisplayOrder = 210

			if not value43.Main then
				return
			end

			value43.Main.Visible = true
		end)
	end

	if not (v378 < 85 and true or value2) then
		return
	end

	if not (value2 or not t2.value37()) then
		return
	end

	t2.value44(v378, function()
		local Parent = value43

		if Parent then
			Parent = value43.Parent

			if Parent then
				Parent = value43.Main
			end
		end

		if Parent then
			local value9 = t2.value9
			local Main = value43.Main
			local v383 = t2.value16.new(0.35, t2.value15.EasingStyle.Quint, t2.value15.EasingDirection.Out)

			value9.Create(value9, Main, v383, {
				BackgroundTransparency = 0
			}):Play()

			return
		end

		if value43 and value43.Parent then
			return
		end

		local value432 = t2.value43

		if value432 then
			value432 = t2.value43(p38)
		end

		value43 = value432
	end, {
		keyUI = value43,
		dimBackground = true,
		displayOrder = 220,
		position = t2.value14.new(0.5, 0, 0.5, 0),
		executorName = v371,
		isBlocked = false,
		failedTests = t18.failed,
		passedTests = t18.passed,
		onManualDismiss = function()
			local v385 = v200()

			t2.value18(t2.value35, (tostring(v385)))
		end
	})
end
function t2.value46(p39, p40)
	local Main = p39.Main

	Main.Title.Text = "The Intruders - Key Required"
	Main.Subtitle.Text = "Enter your Luarmor key"
	Main.NoteMessage.Text = "Join our discord for support discord.com/invite/vfkD5VCRKU\nTired of the key system? Get the paid script in our Discord."
	pcall(function()
		Main.NoteMessage.TextWrapped = true
		Main.NoteMessage.TextYAlignment = t2.value15.TextYAlignment.Top
		Main.NoteMessage.AutomaticSize = t2.value15.AutomaticSize.Y
	end)
	t2.value31(Main, Main)
	Main.Size = t2.value14.new(0, 505, 0, 175)
	Main.BackgroundTransparency = 1

	local value9 = t2.value9
	local v388 = t2.value16.new(0.6, t2.value15.EasingStyle.Quint)

	value9.Create(value9, Main, v388, {
		BackgroundTransparency = 0
	}):Play()

	local value92 = t2.value9
	local new = t2.value16.new
	local value15 = t2.value15

	value92.Create(value92, Main, new(0.6, value15.EasingStyle.Quint), {
		Size = t2.value14.new(0, 540, 0, 187)
	}):Play()

	local InputBox = Main.Input.InputBox
	local HidenInput = Main.Input.HidenInput

	InputBox:GetPropertyChangedSignal("Text"):Connect(function()
		local Text = InputBox.Text or ""

		HidenInput.Text = string.rep("•", #Text)
	end)

	local Text = InputBox.Text or ""

	HidenInput.Text = string.rep("•", #Text)
	HidenInput.TextTransparency = 0
	InputBox.TextTransparency = 1

	local Copy = Main.Copy
	local Y = Copy.Position.Y

	Copy.Text = "Linkvertise"
	Copy.Position = t2.value14.new(0, 27, Y.Scale, Y.Offset)
	Copy.Size = t2.value14.new(0, 76, 0, 28)

	local function v398()
		t2.value21(t2.value12.linkvertise)
		t2.value13:Notify({
			Title = "Key Link Copied!",
			Content = "Visit the Linkvertise link to get your key.",
			Duration = 7
		})
	end

	Copy.Activated:Connect(v398)

	local clone = Copy:Clone()

	clone.Name = "Workink"
	clone.Text = "Workink"
	clone.Position = t2.value14.new(0, 113, Y.Scale, Y.Offset)
	clone.Parent = Main
	clone.Activated:Connect(function()
		t2.value21(t2.value12.workink)
		t2.value13:Notify({
			Title = "Key Link Copied!",
			Content = "Visit the Work.ink link to get your key.",
			Duration = 7
		})
	end)

	local Check = Main.Check

	Check.Text = "Verify Key"
	Check.Position = t2.value14.new(0, 199, Y.Scale, Y.Offset)
	Check.Size = t2.value14.new(0, 76, 0, 28)

	local function v401()
		local Text2 = p39.Main.Input.InputBox.Text

		if not Text2 or Text2 == "" then
			t2.value13:Notify({
				Title = "Error!",
				Content = "Please enter a key first.",
				Duration = 5
			})

			return
		end

		local v403, v404, v405 = t2.value29(Text2, p40)

		if v403 then
			if v405 then
				v403 = v405.code == "KEY_VALID"
			else
				v403 = v405
			end
		end

		if not v403 then
			local code

			if v405 then
				code = v405.code
			else
				code = v405
			end

			if code then
				if v405.code == "KEY_HWID_LOCKED" then
					t2.value13:Notify({
						Title = "HWID Locked",
						Content = "Key linked to a different HWID. Please reset it using our bot.",
						Duration = 7
					})

					return
				elseif v405.code == "KEY_INCORRECT" then
					t2.value13:Notify({
						Title = "Invalid Key",
						Content = "Key is wrong or deleted!",
						Duration = 7
					})

					return
				elseif v405.code == "KEY_EXPIRED" then
					t2.value13:Notify({
						Title = "Key Expired",
						Content = "This key has expired and can no longer be used.",
						Duration = 7
					})

					return
				elseif v405.code == "KEY_BANNED" then
					t2.value13:Notify({
						Title = "Key Banned",
						Content = "This key has been blacklisted and can not be used.",
						Duration = 7
					})

					return
				elseif v405.code == "KEY_INVALID" then
					t2.value13:Notify({
						Title = "Invalid Format",
						Content = "Key format is invalid. Please check your key.",
						Duration = 7
					})

					return
				else
					local t19 = {
						Title = "Key Error",
						Content = v404 or ("Failed to validate key. Error: " .. v405.code or "Unknown"),
						Duration = 7
					}

					t2.value13:Notify(t19)

					return
				end
			else
				t2.value13:Notify({
					Title = "Validation Failed",
					Content = v404 or "Failed to validate key. Please try again.",
					Duration = 7
				})

				return
			end
		end

		t2.value38(Text2)

		local value17 = t2.value17

		if value17 then
			value17 = t2.value17()
		end

		if not value17 then
			script_key = Text2
			v439 = t2.value13
			v439.Notify(v439, {
				Title = "Success!",
				Content = "Key verified and saved successfully! Welcome " .. t2.value7,
				Duration = 7
			})
			t2.value32(Main, 0.5)
			p39:Destroy()
			t2.value40(p40, p40.script_id)

			return
		end

		t2.value17().script_key = Text2
		script_key = Text2

		local value13 = t2.value13

		value13.Notify(value13, {
			Title = "Success!",
			Content = "Key verified and saved successfully! Welcome " .. t2.value7,
			Duration = 7
		})
		t2.value32(Main, 0.5)
		p39:Destroy()
		t2.value40(p40, p40.script_id)
	end

	Check.Activated:Connect(v401)
	p39.Main.Input.InputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			enterPressed = #p39.Main.Input.InputBox.Text > 0
		end

		if not enterPressed then
			return
		end

		v401()
	end)

	local u410 = true

	Main.HideP.MouseButton1Click:Connect(function()
		u410 = not u410

		if u410 then
			local Text2 = InputBox.Text or ""

			HidenInput.Text = string.rep("•", #Text2)
			t2.value9:Create(Main.Input.HidenInput, t2.value16.new(0.5, t2.value15.EasingStyle.Quint), {
				TextTransparency = 0
			}):Play()
			t2.value9:Create(Main.Input.InputBox, t2.value16.new(0.5, t2.value15.EasingStyle.Quint), {
				TextTransparency = 1
			}):Play()
		else
			t2.value9:Create(Main.Input.HidenInput, t2.value16.new(0.5, t2.value15.EasingStyle.Quint), {
				TextTransparency = 1
			}):Play()
			t2.value9:Create(Main.Input.InputBox, t2.value16.new(0.5, t2.value15.EasingStyle.Quint), {
				TextTransparency = 0
			}):Play()
		end
	end)
	Main.Hide.MouseButton1Click:Connect(function()
		t2.value32(Main, 0.5)
		p39:Destroy()
	end)
end
function t2.value43(p41)
	local v412 = game:GetObjects("rbxassetid://14681919890")[1]

	if not v412 then
		return nil
	end

	v412.Enabled = true
	v412.ResetOnSpawn = false
	pcall(function()
		local value17 = t2.value17

		if value17 then
			value17 = t2.value17()

			if value17 then
				value17 = t2.value17().KeyUI
			end
		end

		if not value17 then
			return
		end

		t2.value17().KeyUI:Destroy()
	end)

	local value17 = t2.value17

	if value17 then
		value17 = t2.value17()
	end

	if value17 then
		t2.value17().KeyUI = v412
	end

	t2.value30(v412)
	pcall(function()
		v412.DisplayOrder = 210

		if not v412.Main then
			return
		end

		v412.Main.Visible = true
	end)
	t2.value46(v412, p41)

	return v412
end
function t2.value5()
	t2.value18(t2.value33, "")

	local value17 = t2.value17

	if value17 then
		value17 = t2.value17()
	end

	if not value17 then
		script_key = nil

		return
	end

	t2.value17().script_key = nil
	script_key = nil
end
function t2.value47(p42)
	local value27 = t2.value27
	local v417 = value27()
	local v418

	if v417 then
		v418 = v417 ~= ""
	else
		v418 = v417
	end

	local v419, value17, value13, code, value132

	if not v418 then
		v462 = t2.value39()

		if v462 then
			v419 = v462 ~= ""
		else
			v419 = v462
		end

		if not v419 then
			t2.value45(p42)

			return false
		end

		v463, v464, v465 = t2.value29(v462, p42)

		if v463 then
			if v465 then
				v463 = v465.code == "KEY_VALID"
			else
				v463 = v465
			end
		end

		if v463 then
			t2.value38(v462)
			value17 = t2.value17

			if value17 then
				value17 = t2.value17()
			end

			if not value17 then
				script_key = v462
				value13 = t2.value13
				value13.Notify(value13, {
					Title = "Auto-Login!",
					Content = "Using saved key. Welcome " .. t2.value7,
					Duration = 5
				})
				t2.value40(p42, p42.script_id)

				return true
			end

			t2.value17().script_key = v462
			script_key = v462
			value13 = t2.value13
			value13.Notify(value13, {
				Title = "Auto-Login!",
				Content = "Using saved key. Welcome " .. t2.value7,
				Duration = 5
			})
			t2.value40(p42, p42.script_id)

			return true
		else
			t2.value5()

			if v465 then
				code = v465.code
			else
				code = v465
			end

			if code then
				if v465.code == "KEY_EXPIRED" then
					t2.value13:Notify({
						Title = "Saved Key Expired",
						Content = "Your saved key has expired. Please enter a new key.",
						Duration = 7
					})
				elseif v465.code == "KEY_HWID_LOCKED" then
					t2.value13:Notify({
						Title = "HWID Locked",
						Content = "Your saved key is locked to a different HWID. Please enter a new key or reset it.",
						Duration = 7
					})
				else
					t2.value13:Notify({
						Title = "Saved Key Invalid",
						Content = "Your saved key is no longer valid. Please enter a new key.",
						Duration = 7
					})
				end
			else
				value132 = t2.value13
				value132.Notify(value132, {
					Title = "Key Validation Failed",
					Content = "Failed to validate saved key. Please enter a new key.",
					Duration = 7
				})
			end

			t2.value45(p42)

			return false
		end
	end

	value27 = t2.value29

	local v424, _, v426 = value27(v417, p42)

	if v424 then
		if v426 then
			v426 = v426.code == "KEY_VALID"
		end
	else
		v426 = v424
	end

	if v426 then
		t2.value38(v417)

		local value172 = t2.value17

		if value172 then
			value172 = t2.value17()
		end

		if not value172 then
			script_key = v417
			v461 = t2.value13
			v461.Notify(v461, {
				Title = "Key Found!",
				Content = "Using existing script key. Welcome " .. t2.value7,
				Duration = 5
			})
			t2.value40(p42, p42.script_id)

			return true
		end

		t2.value17().script_key = v417
		script_key = v417

		local value133 = t2.value13

		value133.Notify(value133, {
			Title = "Key Found!",
			Content = "Using existing script key. Welcome " .. t2.value7,
			Duration = 5
		})
		t2.value40(p42, p42.script_id)

		return true
	end

	t2.value5()
	t2.value13:Notify({
		Title = "Key Invalid",
		Content = "Existing key is invalid or expired. Please enter a new key.",
		Duration = 7
	})

	local v429 = t2.value39()

	if v429 then
		v419 = v429 ~= ""
	else
		v419 = v429
	end

	if not v419 then
		t2.value45(p42)

		return false
	end

	local v430, _, v432 = t2.value29(v429, p42)

	if v430 then
		if v432 then
			v430 = v432.code == "KEY_VALID"
		else
			v430 = v432
		end
	end

	if v430 then
		t2.value38(v429)
		value17 = t2.value17

		if value17 then
			value17 = t2.value17()
		end

		if not value17 then
			script_key = v429
			value13 = t2.value13
			value13.Notify(value13, {
				Title = "Auto-Login!",
				Content = "Using saved key. Welcome " .. t2.value7,
				Duration = 5
			})
			t2.value40(p42, p42.script_id)

			return true
		end

		t2.value17().script_key = v429
		script_key = v429
		value13 = t2.value13
		value13.Notify(value13, {
			Title = "Auto-Login!",
			Content = "Using saved key. Welcome " .. t2.value7,
			Duration = 5
		})
		t2.value40(p42, p42.script_id)

		return true
	else
		t2.value5()

		if v432 then
			code = v432.code
		else
			code = v432
		end

		if code then
			if v432.code == "KEY_EXPIRED" then
				t2.value13:Notify({
					Title = "Saved Key Expired",
					Content = "Your saved key has expired. Please enter a new key.",
					Duration = 7
				})
			elseif v432.code == "KEY_HWID_LOCKED" then
				t2.value13:Notify({
					Title = "HWID Locked",
					Content = "Your saved key is locked to a different HWID. Please enter a new key or reset it.",
					Duration = 7
				})
			else
				t2.value13:Notify({
					Title = "Saved Key Invalid",
					Content = "Your saved key is no longer valid. Please enter a new key.",
					Duration = 7
				})
			end
		else
			value132 = t2.value13
			value132.Notify(value132, {
				Title = "Key Validation Failed",
				Content = "Failed to validate saved key. Please enter a new key.",
				Duration = 7
			})
		end

		t2.value45(p42)

		return false
	end
end

(function()
	local v433 = t2.value26()

	if v433 then
		if v433 == "" then
			t2.value13:Notify({
				Title = "Missing Loader",
				Content = "No script_id configured for this game.",
				Duration = 7
			})

			return
		else
			local v435 = t2.value28()

			if v435 then
				v435.script_id = v433
				t2.value47(v435)

				return
			else
				t2.value13:Notify({
					Title = "Error!",
					Content = "Failed to load Luarmor API. Please try again later.",
					Duration = 7
				})

				return
			end
		end
	else
		local value13 = t2.value13

		value13.Notify(value13, {
			Title = "Unsupported Game",
			Content = "This game is not supported.",
			Duration = 7
		})
	end
end)()
