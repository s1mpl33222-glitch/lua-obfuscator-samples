--[[ concept fully deobfusted ]]

pcall(function()
	if not game:IsLoaded() then game.Loaded:Wait() end
end)
task.wait(0.2)

pcall(function()
	if getgenv().__coneptStop then getgenv().__conceptStop() end
end)

pcall(function()
	local lp = game:GetService("Players").LocalPlayer
	if lp and hookfunction then
		local oldKick = lp.Kick
		hookfunction(oldKick, newcclosure(function(self, ...)
			if self == lp then return end
			return oldKick(self, ...)
		end))
	end
end)

local function loadUrl(url)
	for _ = 1, 2 do
		local ok, res = pcall(function()
			return loadstring(game:HttpGet(url, true))()
		end)
		if ok and res ~= nil then return res end
		ok, res = pcall(function()
			return loadstring(game:HttpGet(url))()
		end)
		if ok and res ~= nil then return res end
		task.wait(0.3)
	end
	return nil
end

local Library, ThemeManager, SaveManager
do
	local sources = {
		{ "https://raw.githubusercontent.com/visnoukkk/Creep.cc/main/Source.lua",
		  "https://raw.githubusercontent.com/visnoukkk/Creep.cc/main/addons/ThemeManager.lua",
		  "https://raw.githubusercontent.com/visnoukkk/Creep.cc/main/addons/SaveManager.lua" },
		{ "https://raw.githubusercontent.com/visnoukkk/Creep.cc/refs/heads/main/Source.lua",
		  "https://raw.githubusercontent.com/visnoukkk/Creep.cc/refs/heads/main/addons/ThemeManager.lua",
		  "https://raw.githubusercontent.com/visnoukkk/Creep.cc/refs/heads/main/addons/SaveManager.lua" },
		{ "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/Library.lua",
		  "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/ThemeManager.lua",
		  "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/SaveManager.lua" },
	}
	for i = 1, #sources do
		local s = sources[i]
		Library = loadUrl(s[1])
		if type(Library) == "table" and Library.CreateWindow then
			ThemeManager = loadUrl(s[2])
			SaveManager = loadUrl(s[3])
			break
		end
		Library = nil
	end
end

if type(Library) ~= "table" or not Library.CreateWindow then
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "concept",
			Text = "UI load failed — enable HTTP / try another executor",
			Duration = 10,
		})
	end)
	warn("[NemesisHub] UI library failed")
	return
end

local function ApplyArchTheme()
	pcall(function()
		Library.FontColor = Color3.fromRGB(255, 255, 255)
		Library.MainColor = Color3.fromRGB(14, 13, 13)
		Library.BackgroundColor = Color3.fromRGB(14, 13, 13)
		Library.AccentColor = Color3.fromRGB(67, 107, 188)
		Library.OutlineColor = Color3.fromRGB(17, 12, 12)
		if Library.UpdateColorsUsingRegistry then Library:UpdateColorsUsingRegistry() end
	end)
end
ApplyArchTheme()


local Window = Library:CreateWindow({
	Title = "concept — discord.gg/s7H9ap9ZDn",
	Center = true,
	AutoShow = true,
})
local Tabs = {
	Main = Window:AddTab("Main"),
	World = Window:AddTab("World"),
	Visuals = Window:AddTab("Visuals"),
	Character = Window:AddTab("Character"),
	Settings = Window:AddTab("Settings"),
}

------------------------------------------------------------------------
-- Skin Changer (NemesisHub — same engine, same weapon list)
------------------------------------------------------------------------
do
	if type(getgenv().Toggles) ~= "table" then getgenv().Toggles = (Library and Library.Toggles) or {} end
	if type(getgenv().Options) ~= "table" then getgenv().Options = (Library and Library.Options) or {} end
	local Toggles = getgenv().Toggles
	local Options = getgenv().Options
	-- ensure Library is visible to skin helpers
	getgenv().Library = Library

	local VisTabbox = Tabs.Visuals:AddLeftTabbox()
	local SkinBox = VisTabbox:AddTab("Visuals")
	local OverrideBox = VisTabbox:AddTab("Override")
	local ItemBox = VisTabbox:AddTab("Viewmodel")

	----------------------------------------------------------------
	-- Skin Changer (Nation enchants / Lion — exact)
	----------------------------------------------------------------
	do
		SkinBox:AddToggle("ShowSkinChanger", {
			Text = "Show Skin Changer",
			Default = false,
			Callback = function(v)
				task.spawn(function()
					local function show(on)
						if shared and shared.LionCosmeticChanger and shared.LionCosmeticChanger.SetVisible then
							shared.LionCosmeticChanger.SetVisible(on)
							return true
						end
						if getgenv().NemesisShowNationSkins then
							getgenv().NemesisShowNationSkins(on)
							return true
						end
						return false
					end
					if show(v) then
						--
						return
					end
					-- wait for Nation module to finish loading
					for i = 1, 25 do
						task.wait(0.2)
						if show(v) then
							--
							return
						end
					end
					Library:Notify("Skin changer failed to load — rejoin Rivals then re-execute")
				end)
			end,
		})
		SkinBox:AddLabel("Nation skins: Skin / Wrap / Charm / Finisher")
	end


-- Nation / Lion skin changer (from businessramie-collab/ArchHub Nation enchants)
shared = shared or getgenv().shared or {}
getgenv().shared = shared
task.spawn(function()
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- ScreenGui host for cosmetic window
local skinHost = Instance.new("ScreenGui")
skinHost.Name = "NemesisNationSkins"
skinHost.ResetOnSpawn = false
skinHost.ZIndexBehavior = Enum.ZIndexBehavior.Global
skinHost.DisplayOrder = 100000
skinHost.IgnoreGuiInset = true
skinHost.Enabled = true
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(skinHost) end
	if gethui then skinHost.Parent = gethui() end
end)
if not skinHost.Parent then
	pcall(function() skinHost.Parent = CoreGui end)
end
if not skinHost.Parent then
	skinHost.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local mainapi = {
	MainScreenGui = skinHost,
	ClickGuiStatus = true,
	Clean = function(_, conn)
		-- keep connection alive for skin GUI visibility loop
	end,
}

local function makeDraggable(frame, _)
	if not frame then return end
	frame.Active = true
	local dragging, dragStart, startPos
	local uis = game:GetService("UserInputService")
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	uis.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- Always show cosmetic GUI when Wanted (no Lion menu dependency)
-- patched after shared.LionCosmeticChanger is set via Heartbeat override below



            -- Unlock All module removed
local plrs = game:GetService("Players")
local reps = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local collectionService = game:GetService("CollectionService")

local lp = plrs.LocalPlayer
if not lp then return end

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 10)
if not lps then return end

local ctrls = lps:FindFirstChild("Controllers") or lps:WaitForChild("Controllers", 10)
local rmods = reps:FindFirstChild("Modules") or reps:WaitForChild("Modules", 10)
if not ctrls or not rmods then return end

local function safeRequireModule(module)
	if not module then return nil end
	local ok, result = pcall(require, module)
	return ok and result or nil
end

local elib = safeRequireModule(rmods:WaitForChild("EnumLibrary", 10))
if elib and elib.WaitForEnumBuilder then
	pcall(function()
		elib:WaitForEnumBuilder()
	end)
end
local clib = safeRequireModule(rmods:WaitForChild("CosmeticLibrary", 10))
local ilib = safeRequireModule(rmods:WaitForChild("ItemLibrary", 10))
local consts = safeRequireModule(rmods:WaitForChild("CONSTANTS", 10))
local dctrl = safeRequireModule(ctrls:WaitForChild("PlayerDataController", 10))
if not (clib and clib.Cosmetics and dctrl) then
	warn("[NemesisHub.gg | V3] Nation skins: missing CosmeticLibrary/PlayerDataController")
	getgenv().NemesisShowNationSkins = function()
		warn("[NemesisHub.gg | V3] Skin modules not ready — rejoin Rivals and re-execute")
	end
	return
end
-- ilib/consts/elib optional
ilib = ilib or {}
consts = consts or {}
elib = elib or {}
local coss = clib.Cosmetics

local function findDescendantByName(parent, name)
	if not parent then return nil end
	local direct = parent:FindFirstChild(name)
	if direct then return direct end
	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.Name == name then
			return descendant
		end
	end
	return nil
end

local KNIFE_CUSTOM_SKIN = "Knife (Custom Skin)"
local REAVER_KNIFE_CUSTOM_SKIN = "reaver"
local DAGGERS_CUSTOM_SKIN = "Jett"
local SATCHEL_CUSTOM_SKIN = "Raze"
local SNIPER_CUSTOM_SKIN = "Chamber"
local RPG_CUSTOM_SKIN = "RPG Raze"
local FISTS_CUSTOM_SKIN = "Agent"
local BOW_CUSTOM_SKIN = "Sova"
local ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
local DICE_TRIPMINE_SKIN = "Subspace Tripmine (Custom Skin)"
local DICE_TRIPMINE_OUTER_MESH_ID = "rbxassetid://5555691474"
local DICE_TRIPMINE_INNER_MESH_ID = "rbxassetid://5555691356"
local DICE_TRIPMINE_IMAGE_ID = "rbxassetid://98372867049331"
local DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
local DICE_TRIPMINE_MESH_SCALE = 3.35
local DICE_TRIPMINE_WORLD_MESH_SCALE = 3.25
local SPIKE_TRIPMINE_SKIN = "Spike"
local SPIKE_TRIPMINE_MESH_ID = "rbxassetid://97754746098028"
local TRIPMINE_STAR_REMOVE_MESH_ID = "rbxassetid://13792525075"
local SPIKE_TRIPMINE_MESH_SCALE = 85
local SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50
local SNIPER_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://98786413608787"
local SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
local SNIPER_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.025, 0.025, 0.025)
local SNIPER_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0, -0.25, 0)
local DAGGERS_CUSTOM_SOURCE_MESH_ID = "rbxassetid://94772705561955"
local DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
local DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://79246900644201"
local DAGGERS_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.03, 0.03, 0.03)
local DAGGERS_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, -90)
local SATCHEL_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://129982008330139"
local SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://121713947189258"
local SATCHEL_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.5, 0.5, 0.5)
local SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE = Vector3.new(0.6, 0.6, 0.6)
local SATCHEL_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, -90, 0)
local RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://81554047161707"
local RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
local RPG_CUSTOM_REPLACEMENT_SCALE = 0.5
local RPG_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, 0)
local RPG_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0.04, 0, 0)
local FISTS_CUSTOM_LEFT_MESH_ID = "rbxassetid://120273083766829"
local FISTS_CUSTOM_LEFT_TEXTURE_ID = "rbxassetid://124608382264962"
local FISTS_CUSTOM_RIGHT_MESH_ID = "rbxassetid://129220833982000"
local FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
local FISTS_CUSTOM_MESH_SCALE = Vector3.new(0.1, 0.1, 0.1)
local FISTS_CUSTOM_LEFT_ROTATION = Vector3.new(45, 0, 0)
local FISTS_CUSTOM_RIGHT_ROTATION = Vector3.new(-45, 0, 0)
local BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://80147707463344"
local BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
local BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID = "rbxassetid://97839236861642"
local BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID = "rbxassetid://82458179247269"
local BOW_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.25, 0.25, 0.25)

local CUSTOM_SKIN_IMAGE_OVERRIDES = {
	[REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["sky"] = { Image = "", ImageHighResolution = "" },
	["Camera"] = { Image = "", ImageHighResolution = "" },
	["Grenade Raze"] = { Image = "", ImageHighResolution = "" },
	[DAGGERS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SATCHEL_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SNIPER_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["Operator"] = { Image = "", ImageHighResolution = "" },
	[RPG_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[FISTS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[BOW_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[ASSAULT_RIFLE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[DICE_TRIPMINE_SKIN] = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
	[SPIKE_TRIPMINE_SKIN] = { Image = "", ImageHighResolution = "" }
}

local SNIPER_MESH_SKIN_OVERRIDES = {
	[SNIPER_CUSTOM_SKIN] = {
		Skin = SNIPER_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://95497877882755",
			"rbxassetid://118920880889483",
			"rbxassetid://80662423119419"
		},
		RemoveMeshIds = {
			"rbxassetid://100168191352015",
			"rbxassetid://82935541182957",
			"rbxassetid://95388370230390",
			"rbxassetid://84918196407550"
		},
		ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
		ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
	},
	["Operator"] = {
		Skin = "Operator",
		BodyMeshIds = {
			"rbxassetid://13188893115",
			"rbxassetid://13188892761",
			"rbxassetid://14778413014",
			"rbxassetid://13188893017",
			"rbxassetid://14774727092"
		},
		RemoveMeshIds = {
			"rbxassetid://13188893310",
			"rbxassetid://13188892855"
		},
		BulletMeshIds = {
			"rbxassetid://14002915797"
		},
		MagazineMeshIds = {
			"rbxassetid://13188892532",
			"rbxassetid://13188892651"
		},
		BodyReplacementMeshId = "rbxassetid://132995629661821",
		BodyReplacementTextureId = "rbxassetid://80634410259243",
		ScopeReplacementMeshId = "rbxassetid://103988563532751",
		ScopeReplacementTextureId = "rbxassetid://136789986141252",
		MagazineReplacementMeshId = "rbxassetid://80074307887476",
		MagazineReplacementTextureId = "rbxassetid://80634410259243",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementOffset = Vector3.new(0, -0.25, 0),
		ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
		MagazineOffset = Vector3.new(0.7, 0, 0.05),
		BulletOffset = Vector3.new(-1.25, 0, 0),
		ReplacementVersion = 9
	}
}

local DAGGERS_MESH_SKIN_OVERRIDES = {
	[DAGGERS_CUSTOM_SKIN] = {
		Skin = DAGGERS_CUSTOM_SKIN,
		SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
		ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
		ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 6,
		FallbackBodyNames = { "LeftBody", "RightBody" }
	}
}

local SATCHEL_MESH_SKIN_OVERRIDES = {
	[SATCHEL_CUSTOM_SKIN] = {
		Skin = SATCHEL_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://138805549853994",
			"rbxassetid://125258747465100",
			"rbxassetid://111319295872696",
			"rbxassetid://129504437671598",
			"rbxassetid://104440368867933"
		},
		ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
		WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
		ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 5
	},
	[REAVER_KNIFE_CUSTOM_SKIN] = {
		Skin = REAVER_KNIFE_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://85166039303292",
			"rbxassetid://125674590013235",
			"rbxassetid://97042702941502",
			"rbxassetid://116723276788898",
			"rbxassetid://99266754879173"
		},
		ReplacementMeshId = "rbxassetid://76054449109492",
		ReplacementTextureId = "rbxassetid://117578984602503",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementRotation = Vector3.new(0, 90, 0),
		ReplacementOffset = Vector3.new(0, 0.5, 0),
		ReplacementVersion = 3
	},
	["sky"] = {
		Skin = "sky",
		SourceMeshIds = { "rbxassetid://140203670599306" },
		ReplacementMeshId = "rbxassetid://78577370691269",
		ReplacementTextureId = "rbxassetid://130284287910497",
		ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
		ReplacementRotation = Vector3.new(0, 90, 0),
		WorldSourceMeshIds = { "rbxassetid://140203670599306" },
		WorldReplacementMeshId = "rbxassetid://111122607123480",
		WorldReplacementTextureId = "rbxassetid://86629139856581",
		WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		WorldReplacementRotation = Vector3.zero,
		ReplacementVersion = 2
	},
	["Grenade Raze"] = {
		Skin = "Grenade Raze",
		SourceMeshIds = {
			"rbxassetid://87132852844264",
			"rbxassetid://96681677373844",
			"rbxassetid://121396126155803",
			"rbxassetid://121842208464560"
		},
		ReplacementMeshId = "rbxassetid://80612596590820",
		ReplacementTextureId = "rbxassetid://123233413518598",
		ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
		ReplacementVersion = 2
	},
	["Camera"] = {
		Skin = "Camera",
		SourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		ReplacementMeshId = "rbxassetid://112849634500139",
		ReplacementTextureId = "rbxassetid://126465878813440",
		ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
		ReplacementRotation = Vector3.new(0, 0, -90),
		WorldSourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		WorldReplacementSize = Vector3.new(2, 2, 2),
		WorldReplacementRotation = Vector3.new(0, 90, -90),
		ReplacementVersion = 2
	}
}

local RPG_MESH_SKIN_OVERRIDES = {
	[RPG_CUSTOM_SKIN] = {
		Skin = RPG_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17638908187",
			"rbxassetid://17638908626"
		},
		JuggleMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		RocketMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
		ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
		ReplacementVersion = 3
	}
}

local FISTS_MESH_SKIN_OVERRIDES = {
	[FISTS_CUSTOM_SKIN] = {
		Skin = FISTS_CUSTOM_SKIN,
		LeftPartName = "LeftItem",
		RightPartName = "RightItem",
		LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID,
		LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
		RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID,
		RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
		MeshScale = FISTS_CUSTOM_MESH_SCALE,
		LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
		RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
		ReplacementVersion = 1
	}
}

local BOW_MESH_SKIN_OVERRIDES = {
	[BOW_CUSTOM_SKIN] = {
		Skin = BOW_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://116947825701555",
			"rbxassetid://80510746199823"
		},
		ArrowMeshIds = {
			"rbxassetid://108027163190911",
			"rbxassetid://114261802270550"
		},
		BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
		ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
		ReplacementVersion = 2
	}
}

local ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
	[ASSAULT_RIFLE_CUSTOM_SKIN] = {
		Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17661950733",
			"rbxassetid://17661950585",
			"rbxassetid://17662005180",
			"rbxassetid://17662016762"
		},
		BoltMeshIds = {
			"rbxassetid://17661950452"
		},
		MagazineMeshIds = {
			"rbxassetid://17662005301",
			"rbxassetid://17662005453"
		},
		ReloadMagazineMeshIds = {
			"rbxassetid://17662005453",
			"rbxassetid://17662005301"
		},
		BodyReplacementMeshId = "rbxassetid://138100951261312",
		BodyReplacementTextureId = "rbxassetid://84167100219585",
		MagazineReplacementMeshId = "rbxassetid://92935167277909",
		MagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
		ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
		ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
		MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
		ReplacementVersion = 6
	}
}

local TRIPMINE_MESH_SKIN_OVERRIDES = {
	[DICE_TRIPMINE_SKIN] = {
		Skin = DICE_TRIPMINE_SKIN,
		MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = DICE_TRIPMINE_MESH_SCALE,
		WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		ExtraMeshScale = 1.15,
		WorldExtraMeshScale = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Material = Enum.Material.SmoothPlastic,
		Reflectance = 0,
		ClearTexture = true
	},
	[SPIKE_TRIPMINE_SKIN] = {
		Skin = SPIKE_TRIPMINE_SKIN,
		MeshId = SPIKE_TRIPMINE_MESH_ID,
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = SPIKE_TRIPMINE_MESH_SCALE,
		WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		Color = Color3.fromRGB(163, 162, 165),
		ClearTexture = true
	}
}

local function normalizeAssetId(assetId)
	return tostring(assetId or ""):match("%d+") or ""
end

local function getTripmineMeshIds(profile)
	local ids = {}
	if type(profile and profile.MeshIds) == "table" then
		for _, meshId in ipairs(profile.MeshIds) do
			if normalizeAssetId(meshId) ~= "" then
				table.insert(ids, meshId)
			end
		end
	elseif profile and normalizeAssetId(profile.MeshId) ~= "" then
		table.insert(ids, profile.MeshId)
	end
	return ids
end

local function getTripmineExtraMeshScale(profile, worldVisual)
	if worldVisual then
		return profile and profile.WorldExtraMeshScale or 1
	end
	return profile and profile.ExtraMeshScale or 1
end

local function getTripmineMeshSignature(profile, worldVisual)
	local normalized = {}
	for _, meshId in ipairs(getTripmineMeshIds(profile)) do
		table.insert(normalized, normalizeAssetId(meshId))
	end
	return table.concat(normalized, ",") .. "|" .. tostring(getTripmineExtraMeshScale(profile, worldVisual))
end

local function scaleTripmineMeshVector(scale, multiplier)
	multiplier = multiplier or 1
	if typeof(scale) == "Vector3" then
		return scale * multiplier
	end
	return Vector3.new(scale, scale, scale) * multiplier
end

local function meshMatchesAssetId(inst, assetId)
	local id = normalizeAssetId(assetId)
	if id == "" or typeof(inst) ~= "Instance" then return false end
	if inst:IsA("SpecialMesh") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureId) == id
	elseif inst:IsA("MeshPart") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureID) == id
	end
	return false
end

local function isCustomTripmineMeshIgnored(inst)
	local current = inst
	while current do
		if current:GetAttribute("__LionHiddenTripmineMesh") then
			return true
		end
		local compactName = tostring(current.Name or ""):lower():gsub("[%s_%-%p]", "")
		if compactName:find("arm", 1, true)
			or compactName:find("hand", 1, true)
			or compactName:find("fake", 1, true)
			or compactName:find("charm", 1, true)
			or compactName:find("hitbox", 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function scoreCustomTripmineMeshTarget(root, meshLike, removedMeshId)
	if removedMeshId and meshMatchesAssetId(meshLike, removedMeshId) then return nil end
	local part = meshLike:IsA("SpecialMesh") and meshLike.Parent or meshLike
	if not (part and part:IsA("BasePart")) or isCustomTripmineMeshIgnored(part) then return nil end
	local score = part.Size.Magnitude
	local name = tostring(part.Name or ""):lower()
	if root:IsA("Model") and part == root.PrimaryPart then score += 1000 end
	if name:find("mesh", 1, true) then score += 500 end
	if name:find("body", 1, true) then score += 250 end
	if name:find("mine", 1, true) or name:find("trip", 1, true) then score += 250 end
	return score
end

local function findCustomTripmineMeshTarget(root, profile)
	if typeof(root) ~= "Instance" then return nil end
	local best, bestScore = nil, -math.huge
	local removedMeshId = profile and (profile.RemoveMeshId or profile.HideMeshId)
	local function consider(obj)
		if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
			local score = scoreCustomTripmineMeshTarget(root, obj, removedMeshId)
			if score and score > bestScore then
				best = obj
				bestScore = score
			end
		end
	end
	consider(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		consider(descendant)
	end
	return best
end

local function removeTripmineMeshAsset(root, assetId)
	if typeof(root) ~= "Instance" or not assetId then return end
	local remove = {}
	local function queueIfMatch(obj)
		if meshMatchesAssetId(obj, assetId) then
			local part = obj:IsA("SpecialMesh") and obj.Parent or obj
			if part and part:IsA("BasePart") then
				table.insert(remove, part)
			elseif obj:IsA("SpecialMesh") then
				table.insert(remove, obj)
			end
		end
	end
	queueIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		queueIfMatch(obj)
	end
	for _, obj in ipairs(remove) do
		if obj and obj.Parent then
			obj:SetAttribute("__LionRemovedTripmineMesh", true)
			obj:Destroy()
		end
	end
end

local function removeCustomTripmineExtraMeshes(root)
	if typeof(root) ~= "Instance" then return end
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:GetAttribute("__LionCustomTripmineExtraMesh") then
			obj:Destroy()
		end
	end
end

local function getMeshLikePart(obj)
	if typeof(obj) ~= "Instance" then return nil end
	if obj:IsA("SpecialMesh") then
		return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent or nil
	end
	return obj:IsA("BasePart") and obj or nil
end

local function meshMatchesAnyAssetId(inst, assetIds)
	for _, assetId in ipairs(assetIds or {}) do
		if meshMatchesAssetId(inst, assetId) then
			return true
		end
	end
	return false
end

local function rotationCFrameFromDegrees(rotation)
	if typeof(rotation) ~= "Vector3" then return CFrame.identity end
	return CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
end

local function namePathContains(inst, needle)
	needle = tostring(needle or ""):lower()
	if needle == "" then return false end
	local current = inst
	while current and current ~= game do
		if tostring(current.Name or ""):lower():find(needle, 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideDaggerMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionDaggerHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function addReplacementSpecialMesh(part, profile, defaultScale)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = profile.ReplacementMeshId
	pcall(function() mesh.TextureId = profile.ReplacementTextureId or "" end)
	mesh.Scale = profile.ReplacementMeshScale or profile.ReplacementSize or defaultScale or Vector3.new(1, 1, 1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = part
	return mesh
end

local function createDaggerReplacementMeshPart(anchor, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	if anchor:GetAttribute("__LionDaggerReplacementMeshPart") then return true end

	local parent = anchor.Parent
	if not parent then return false end
	local originalName = anchor.Name
	anchor.Name = "__LionDaggerAnchor_" .. originalName

	local replacement = Instance.new("Part")
	replacement.Name = originalName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = anchor.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomDaggerMesh", true)
	replacement:SetAttribute("__LionDaggerReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile)
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionDaggerReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	hideDaggerMeshAnchor(anchor)
	return true
end

local function applyMeshReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionDaggerReplacementMeshPart") or obj:GetAttribute("__LionDaggerHiddenAnchor") then
		return false
	end
	local part = getMeshLikePart(obj)
	if obj:IsA("MeshPart") then
		return createDaggerReplacementMeshPart(obj, profile)
	elseif obj:IsA("SpecialMesh") then
		if part then
			part.Transparency = 0
			part.LocalTransparencyModifier = 0
			part.Color = Color3.fromRGB(255, 255, 255)
			pcall(function() part.CastShadow = false end)
			if profile.ReplacementRotation then
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end
		end
		pcall(function() obj.MeshId = profile.ReplacementMeshId end)
		pcall(function() obj.TextureId = profile.ReplacementTextureId or "" end)
		if profile.ReplacementSize then
			pcall(function() obj.Scale = profile.ReplacementSize end)
		end
		obj:SetAttribute("__LionCustomDaggerMesh", true)
		return true
	end
	return false
end

local function getDaggerMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local rotation = profile.ReplacementRotation or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyDaggerMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getDaggerMeshSignature(profile)
	if root:GetAttribute("__LionDaggerMeshSkin") == profile.Skin
		and root:GetAttribute("__LionDaggerMeshSignature") == signature then
		return true
	end

	local replaced, seen = 0, {}
	local function replaceIfTarget(obj)
		if seen[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seen[obj] = true
		if applyMeshReplacementToObject(obj, profile) then
			replaced += 1
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	for _, bodyName in ipairs(profile.FallbackBodyNames or {}) do
		for _, obj in ipairs(root:GetDescendants()) do
			if obj.Name == bodyName then
				local target = obj:FindFirstChild("MeshPart")
				if target and not seen[target] and target:IsA("MeshPart") then
					seen[target] = true
					if applyMeshReplacementToObject(target, profile) then
						replaced += 1
					end
				end
			end
		end
	end

	root:SetAttribute("__LionDaggerMeshSkin", profile.Skin)
	root:SetAttribute("__LionDaggerMeshSignature", signature)
	root:SetAttribute("__LionDaggerMeshCount", replaced)
	return replaced > 0
end

local function hideSatchelMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionSatchelHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function getReplacementAverageCFrame(parts)
	local first = parts and parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

local function createSatchelReplacementMeshPart(root, profile, anchors)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionSatchelReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomSatchelReplacement"
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
		* CFrame.new(profile.ReplacementOffset or Vector3.zero)
		* rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSatchelMesh", true)
	replacement:SetAttribute("__LionSatchelReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile, Vector3.new(1, 1, 1))
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionSatchelReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	for _, part in ipairs(anchors) do
		if part and part.Parent then
			if not part.Name:find("__LionSatchelAnchor_", 1, true) then
				part.Name = "__LionSatchelAnchor_" .. part.Name
			end
			hideSatchelMeshAnchor(part)
		end
	end
	return true
end

local function applySatchelReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionSatchelReplacementMeshPart") then return false end
	local part = getMeshLikePart(obj)
	if part and part:GetAttribute("__LionSatchelHiddenAnchor") then return false end
	return part and createSatchelReplacementMeshPart(part.Parent or part, profile, { part }) or false
end

local function getSatchelMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applySatchelMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSatchelMeshSignature(profile)
	if root:GetAttribute("__LionSatchelMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSatchelMeshSignature") == signature then
		return true
	end

	local bodyParts, seenObjects, seenParts = {}, {}, {}
	local function replaceIfTarget(obj)
		if seenObjects[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seenObjects[obj] = true
		local part = getMeshLikePart(obj)
		if part and not seenParts[part] then
			seenParts[part] = true
			table.insert(bodyParts, part)
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	local replaced = createSatchelReplacementMeshPart(root, profile, bodyParts) and 1 or 0

	root:SetAttribute("__LionSatchelMeshSkin", profile.Skin)
	root:SetAttribute("__LionSatchelMeshSignature", signature)
	root:SetAttribute("__LionSatchelMeshCount", replaced)
	return replaced > 0
end

local function getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	local profile = SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile and worldAsset and (
		profile.WorldSourceMeshIds
		or profile.WorldReplacementMeshId
		or profile.WorldReplacementTextureId
		or profile.WorldReplacementSize
		or profile.WorldReplacementRotation
		or profile.WorldReplacementOffset
	) then
		local worldProfile = table.clone(profile)
		worldProfile.SourceMeshIds = profile.WorldSourceMeshIds or profile.SourceMeshIds
		worldProfile.ReplacementMeshId = profile.WorldReplacementMeshId or profile.ReplacementMeshId
		worldProfile.ReplacementTextureId = profile.WorldReplacementTextureId or profile.ReplacementTextureId
		worldProfile.ReplacementSize = profile.WorldReplacementSize or profile.ReplacementSize
		worldProfile.ReplacementRotation = profile.WorldReplacementRotation or profile.ReplacementRotation
		worldProfile.ReplacementOffset = profile.WorldReplacementOffset or profile.ReplacementOffset
		return worldProfile
	end
	return profile
end

local function hideRpgMeshPart(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionRpgHiddenPart") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionRpgHiddenPart", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function applyRpgMeshReplacement(obj, meshId, textureId, profile)
	local part = getMeshLikePart(obj)
	if not part or part:GetAttribute("__LionRpgHiddenPart") then return false end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionCustomRpgMesh", true)
	part:SetAttribute("IgnoreTransparency", true)
	if not part:GetAttribute("__LionRpgReplacementAdjusted") then
		local scale = tonumber(profile and profile.ReplacementScale) or 1
		if scale ~= 1 then
			pcall(function()
				part.Size = part.Size * scale
			end)
		end
		if profile and profile.ReplacementOffset then
			pcall(function()
				part.CFrame = part.CFrame * CFrame.new(profile.ReplacementOffset)
			end)
		end
		if profile and profile.ReplacementRotation then
			pcall(function()
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end)
		end
		part:SetAttribute("__LionRpgReplacementAdjusted", true)
	end
	if obj:IsA("MeshPart") then
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureID = textureId or "" end)
		return true
	elseif obj:IsA("SpecialMesh") then
		pcall(function() obj.MeshType = Enum.MeshType.FileMesh end)
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureId = textureId or "" end)
		pcall(function() obj.VertexColor = Vector3.new(1, 1, 1) end)
		return true
	end
	return false
end

local function getRpgMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.JuggleMeshIds or {}, ","),
		table.concat(profile.RocketMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ReplacementScale or 1),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyRpgMeshProfile(root, profile, options)
	if typeof(root) ~= "Instance" or not profile then return false end
	options = options or {}
	local signature = getRpgMeshSignature(profile)
	if root:GetAttribute("__LionRpgMeshSkin") == profile.Skin
		and root:GetAttribute("__LionRpgMeshSignature") == signature
		and root:GetAttribute("__LionRpgRocketVisible") == false then
		return true
	end

	local changed, removed, seen = 0, 0, {}
	local function applyIfTarget(obj)
		if seen[obj] then return end
		if not (meshMatchesAnyAssetId(obj, profile.BodyMeshIds)
			or meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)
			or meshMatchesAnyAssetId(obj, profile.RocketMeshIds)) then
			return
		end
		seen[obj] = true
		local part = getMeshLikePart(obj)
		if not part then return end
		if (namePathContains(obj, "rocket") and meshMatchesAnyAssetId(obj, profile.RocketMeshIds))
			or (namePathContains(obj, "juggle") and meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)) then
			if hideRpgMeshPart(part) then removed += 1 end
		elseif meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			if applyRpgMeshReplacement(obj, profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
				changed += 1
			end
		end
	end

	applyIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		applyIfTarget(obj)
	end

	root:SetAttribute("__LionRpgMeshSkin", profile.Skin)
	root:SetAttribute("__LionRpgMeshSignature", signature)
	root:SetAttribute("__LionRpgRocketVisible", false)
	root:SetAttribute("__LionRpgMeshCount", changed)
	root:SetAttribute("__LionRpgHiddenCount", removed)
	return changed > 0 or removed > 0
end

local function createFistsReplacementPart(part, meshId, textureId, meshScale, rotation)
	if not (part and part:IsA("BasePart")) then return false end
	for _, child in ipairs(part:GetChildren()) do
		child:Destroy()
	end

	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionFistsHiddenAnchor", true)
	part:SetAttribute("IgnoreTransparency", true)

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomFistsMesh"
	replacement.Size = part.Size
	replacement.CFrame = part.CFrame * rotationCFrameFromDegrees(rotation)
	replacement.Anchored = false
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomFistsMesh", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	replacement.Parent = part

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = meshScale or Vector3.new(0.1, 0.1, 0.1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomFistsMeshWeld"
	weld.Part0 = part
	weld.Part1 = replacement
	weld.Parent = replacement
	return true
end

local function getFistsMeshSignature(profile)
	local scale = profile.MeshScale or Vector3.zero
	local leftRotation = profile.LeftRotation or Vector3.zero
	local rightRotation = profile.RightRotation or Vector3.zero
	return table.concat({
		tostring(profile.LeftMeshId or ""),
		tostring(profile.LeftTextureId or ""),
		tostring(profile.RightMeshId or ""),
		tostring(profile.RightTextureId or ""),
		tostring(scale.X),
		tostring(scale.Y),
		tostring(scale.Z),
		tostring(leftRotation.X),
		tostring(leftRotation.Y),
		tostring(leftRotation.Z),
		tostring(rightRotation.X),
		tostring(rightRotation.Y),
		tostring(rightRotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyFistsMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getFistsMeshSignature(profile)
	if root:GetAttribute("__LionFistsMeshSkin") == profile.Skin
		and root:GetAttribute("__LionFistsMeshSignature") == signature
		and (root:GetAttribute("__LionFistsMeshCount") or 0) > 0 then
		return true
	end

	local left = findDescendantByName(root, profile.LeftPartName or "LeftItem")
	local right = findDescendantByName(root, profile.RightPartName or "RightItem")
	local applied = 0
	if createFistsReplacementPart(left, profile.LeftMeshId, profile.LeftTextureId, profile.MeshScale, profile.LeftRotation) then
		applied += 1
	end
	if createFistsReplacementPart(right, profile.RightMeshId, profile.RightTextureId, profile.MeshScale, profile.RightRotation) then
		applied += 1
	end

	root:SetAttribute("__LionFistsMeshSkin", profile.Skin)
	root:SetAttribute("__LionFistsMeshSignature", signature)
	root:SetAttribute("__LionFistsMeshCount", applied)
	return applied > 0
end

local function hideBowMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionBowHiddenAnchor") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionBowHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createBowReplacementMeshPart(root, anchors, replacementName, meshId, textureId, profile)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionBowReplacementMeshPart") and descendant.Name == replacementName then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = replacementName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomBowMesh", true)
	replacement:SetAttribute("__LionBowReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = profile.ReplacementSize or Vector3.new(0.5, 0.5, 0.5)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionBowReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	for _, part in ipairs(anchors) do
		hideBowMeshAnchor(part)
	end
	return true
end

local function getBowMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.ArrowMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ArrowReplacementMeshId or ""),
		tostring(profile.ArrowReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyBowMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getBowMeshSignature(profile)
	if root:GetAttribute("__LionBowMeshSkin") == profile.Skin
		and root:GetAttribute("__LionBowMeshSignature") == signature
		and (root:GetAttribute("__LionBowMeshCount") or 0) > 0 then
		return true
	end

	local bodyParts, arrowParts, seenParts = {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		if meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif meshMatchesAnyAssetId(obj, profile.ArrowMeshIds) then
			seenParts[part] = true
			table.insert(arrowParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local applied = 0
	if createBowReplacementMeshPart(root, bodyParts, "__LionCustomBowBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
		applied += 1
	end
	if createBowReplacementMeshPart(root, arrowParts, "__LionCustomBowArrow", profile.ArrowReplacementMeshId, profile.ArrowReplacementTextureId, profile) then
		applied += 1
	end

	root:SetAttribute("__LionBowMeshSkin", profile.Skin)
	root:SetAttribute("__LionBowMeshSignature", signature)
	root:SetAttribute("__LionBowMeshCount", applied)
	return applied > 0
end

local function hideAssaultRifleMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionAssaultRifleHiddenAnchor", true)
	part:SetAttribute("__LionAssaultRifleAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createAssaultRifleReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	replacement.Size = profile.ReplacementSize or Vector3.new(0.35, 0.35, 0.35)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomAssaultRifleMesh", true)
	replacement:SetAttribute("__LionAssaultRifleReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionAssaultRifleReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	return true
end

local function getAssaultRifleMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.BoltMeshIds or {}, ","),
		table.concat(profile.MagazineMeshIds or {}, ","),
		table.concat(profile.ReloadMagazineMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(profile.ReloadMagazineReplacementMeshId or ""),
		tostring(profile.ReloadMagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(replacementOffset.X),
		tostring(replacementOffset.Y),
		tostring(replacementOffset.Z),
		tostring(magazineOffset.X),
		tostring(magazineOffset.Y),
		tostring(magazineOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyAssaultRifleMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getAssaultRifleMeshSignature(profile)
	if root:GetAttribute("__LionAssaultRifleMeshSkin") == profile.Skin
		and root:GetAttribute("__LionAssaultRifleMeshSignature") == signature
		and (root:GetAttribute("__LionAssaultRifleMeshCount") or 0) > 0 then
		return true
	end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionAssaultRifleReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, reloadMagazineParts, boltParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionAssaultRifleAnchorType")
		local isReloadMagazine = previousType == "ReloadMagazine"
			or (meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) and namePathContains(obj, "reload"))
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif isReloadMagazine then
			seenParts[part] = true
			table.insert(reloadMagazineParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) or meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bolt" or meshMatchesAnyAssetId(obj, profile.BoltMeshIds) then
			seenParts[part] = true
			table.insert(boltParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1] or boltParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	local reloadMagazineAnchor = reloadMagazineParts[1] or magazineAnchor
	local bodyCFrame = bodyParts[1] and getReplacementAverageCFrame(bodyParts) or (bodyAnchor and bodyAnchor.CFrame) or CFrame.identity
	local reloadMagazineCFrame = reloadMagazineParts[1] and getReplacementAverageCFrame(reloadMagazineParts) or bodyCFrame
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	bodyCFrame = bodyCFrame * CFrame.new(replacementOffset)
	reloadMagazineCFrame = reloadMagazineCFrame * CFrame.new(replacementOffset)
	local applied = 0
	if createAssaultRifleReplacementMeshPart(root, bodyAnchor, "__LionCustomAssaultRifleBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if createAssaultRifleReplacementMeshPart(root, magazineAnchor, "__LionCustomAssaultRifleMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, bodyCFrame * CFrame.new(magazineOffset), profile) then
		applied += 1
	end
	if reloadMagazineParts[1] and createAssaultRifleReplacementMeshPart(root, reloadMagazineAnchor, "__LionCustomAssaultRifleReloadMagazine", profile.ReloadMagazineReplacementMeshId or profile.MagazineReplacementMeshId, profile.ReloadMagazineReplacementTextureId or profile.MagazineReplacementTextureId, reloadMagazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		hideAssaultRifleMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		hideAssaultRifleMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(reloadMagazineParts) do
		hideAssaultRifleMeshAnchor(part, "ReloadMagazine")
	end
	for _, part in ipairs(boltParts) do
		hideAssaultRifleMeshAnchor(part, "Bolt")
	end

	root:SetAttribute("__LionAssaultRifleMeshSkin", profile.Skin)
	root:SetAttribute("__LionAssaultRifleMeshSignature", signature)
	root:SetAttribute("__LionAssaultRifleMeshCount", applied)
	return applied > 0
end

function __LionHideSniperMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Material = Enum.Material.SmoothPlastic end)
	pcall(function() part.Reflectance = 0 end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionHiddenSniperMesh", true)
	part:SetAttribute("__LionCustomSniperHiddenPart", true)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

function __LionOffsetSniperVisibleAnchor(part, anchorType, offset)
	if not (part and part:IsA("BasePart")) then return false end
	local originalCFrame = part:GetAttribute("__LionSniperOriginalCFrame")
	if typeof(originalCFrame) ~= "CFrame" then
		originalCFrame = part.CFrame
		part:SetAttribute("__LionSniperOriginalCFrame", originalCFrame)
	end
	part.CFrame = originalCFrame * CFrame.new(offset or Vector3.zero)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("__LionSniperVisibleOffset", true)
	return true
end

local function hideSniperMeshId(root, assetId)
	local parts = {}
	if typeof(root) ~= "Instance" or not assetId then return parts end
	local seen = {}

	local function hideIfMatch(obj)
		if not meshMatchesAssetId(obj, assetId) then return end
		local part = getMeshLikePart(obj)
		if part and not seen[part] then
			seen[part] = true
			if __LionHideSniperMeshAnchor(part) then
				table.insert(parts, part)
			end
		elseif obj:IsA("SpecialMesh") then
			obj.Scale = Vector3.zero
		end
	end

	hideIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		hideIfMatch(obj)
	end
	return parts
end

local function getAverageCFrame(parts)
	local first = parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

function __LionCreateSniperReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	replacement.Size = profile.ReplacementSize or Vector3.new(0.05, 0.05, 0.05)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSniperReplacement", true)
	replacement:SetAttribute("WrapGroup", 1)
	replacement:SetAttribute("IgnoreTransparency", true)
	pcall(function() replacement:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(replacement, "Wrappable") end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionCustomSniperReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end
	return true
end

local function setupSniperReplacementPart(root, profile, bodyParts)
	local anchor = bodyParts[1]
	if not anchor then return false end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	return __LionCreateSniperReplacementMeshPart(
		root,
		anchor,
		"__LionCustomSniperReplacement",
		profile.ReplacementMeshId,
		profile.ReplacementTextureId,
		getAverageCFrame(bodyParts) * CFrame.new(profile.ReplacementOffset or Vector3.zero),
		profile
	)
end

local function getSniperMeshSignature(profile)
	local body = table.concat(profile.BodyMeshIds or {}, ",")
	local remove = table.concat(profile.RemoveMeshIds or {}, ",")
	local magazine = table.concat(profile.MagazineMeshIds or {}, ",")
	local bullet = table.concat(profile.BulletMeshIds or {}, ",")
	local size = profile.ReplacementSize or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local bulletOffset = profile.BulletOffset or Vector3.zero
	return table.concat({
		body,
		remove,
		magazine,
		bullet,
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ScopeReplacementMeshId or ""),
		tostring(profile.ScopeReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring((profile.ScopeOffset or Vector3.zero).X),
		tostring((profile.ScopeOffset or Vector3.zero).Y),
		tostring((profile.ScopeOffset or Vector3.zero).Z),
		tostring((profile.MagazineOffset or Vector3.zero).X),
		tostring((profile.MagazineOffset or Vector3.zero).Y),
		tostring((profile.MagazineOffset or Vector3.zero).Z),
		tostring(bulletOffset.X),
		tostring(bulletOffset.Y),
		tostring(bulletOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

function __LionApplySniperMultiMeshProfile(root, profile)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, bulletParts, removeParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionSniperAnchorType")
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bullet" or meshMatchesAnyAssetId(obj, profile.BulletMeshIds) then
			seenParts[part] = true
			table.insert(bulletParts, part)
		elseif previousType == "Remove" or meshMatchesAnyAssetId(obj, profile.RemoveMeshIds) then
			seenParts[part] = true
			table.insert(removeParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	if not bodyAnchor then return false end

	local offset = profile.ReplacementOffset or Vector3.zero
	local bodyCFrame = (bodyParts[1] and getReplacementAverageCFrame(bodyParts) or bodyAnchor.CFrame) * CFrame.new(offset)
	local scopeCFrame = bodyCFrame * CFrame.new(profile.ScopeOffset or Vector3.zero)
	local magazineCFrame = bodyCFrame * CFrame.new(profile.MagazineOffset or Vector3.zero)
	local applied = 0
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperReplacement", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperScope", profile.ScopeReplacementMeshId, profile.ScopeReplacementTextureId, scopeCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, magazineAnchor, "__LionCustomSniperMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, magazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		__LionHideSniperMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		__LionHideSniperMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(bulletParts) do
		__LionOffsetSniperVisibleAnchor(part, "Bullet", profile.BulletOffset or Vector3.zero)
	end
	for _, part in ipairs(removeParts) do
		__LionHideSniperMeshAnchor(part, "Remove")
	end
	return applied > 0
end

local function applySniperMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSniperMeshSignature(profile)
	if root:GetAttribute("__LionSniperMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSniperMeshSignature") == signature then
		return true
	end

	local applied
	if profile.BodyReplacementMeshId or profile.ScopeReplacementMeshId or profile.MagazineReplacementMeshId then
		applied = __LionApplySniperMultiMeshProfile(root, profile)
		if not applied then return false end
		root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
		root:SetAttribute("__LionSniperMeshSignature", signature)
		return true
	end

	local bodyParts = {}
	for _, meshId in ipairs(profile.BodyMeshIds or {}) do
		for _, part in ipairs(hideSniperMeshId(root, meshId)) do
			table.insert(bodyParts, part)
		end
	end
	for _, meshId in ipairs(profile.RemoveMeshIds or {}) do
		hideSniperMeshId(root, meshId)
	end

	if not setupSniperReplacementPart(root, profile, bodyParts) then
		return false
	end
	root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
	root:SetAttribute("__LionSniperMeshSignature", signature)
	return true
end

local function applyTripminePartVisual(part, profile)
	if not (part and part:IsA("BasePart")) then return end
	local color = profile.Color
	if color then
		part.Color = color
		part.BrickColor = BrickColor.new(color)
	end
	part.Material = profile.Material or Enum.Material.SmoothPlastic
	if profile.Reflectance then
		part.Reflectance = profile.Reflectance
	end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	if part:GetAttribute("WrapGroup") == nil then
		part:SetAttribute("WrapGroup", 1)
	end
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(part, "Wrappable") end)
end

local function addTripmineExtraMeshPart(basePart, meshId, meshScale, profile, index)
	if not (basePart and basePart:IsA("BasePart") and basePart.Parent) then return nil end
	local overlay = Instance.new("Part")
	overlay.Name = "__LionCustomTripmineMeshExtra" .. tostring(index or "")
	overlay.Anchored = basePart.Anchored
	overlay.CFrame = basePart.CFrame
	overlay.Size = basePart.Size
	overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
	overlay:SetAttribute("__LionCustomTripmineExtraMesh", true)
	applyTripminePartVisual(overlay, profile)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	if profile.ClearTexture then
		pcall(function() mesh.TextureId = "" end)
	elseif profile.TextureId then
		pcall(function() mesh.TextureId = profile.TextureId end)
	end
	mesh.Scale = meshScale
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = overlay
	overlay.Parent = basePart.Parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomTripmineMeshExtraWeld"
	weld.Part0 = basePart
	weld.Part1 = overlay
	weld.Parent = overlay
	return overlay
end

local function applyTripmineMeshProfile(root, profile, worldVisual)
	if typeof(root) ~= "Instance" then return false end
	if not profile then return false end
	local meshIds = getTripmineMeshIds(profile)
	if #meshIds == 0 then return false end
	local extraMeshScale = getTripmineExtraMeshScale(profile, worldVisual)
	local meshSignature = getTripmineMeshSignature(profile, worldVisual)
	local meshScale = (worldVisual and profile.WorldScale) or profile.Scale or 1
	if root:GetAttribute("__LionTripmineMeshSkin") == profile.Skin
		and root:GetAttribute("__LionCustomTripmineMeshIds") == meshSignature
		and root:GetAttribute("__LionCustomTripmineMeshScale") == meshScale then
		return true
	end
	removeCustomTripmineExtraMeshes(root)
	removeTripmineMeshAsset(root, profile.RemoveMeshId or profile.HideMeshId)
	local target = findCustomTripmineMeshTarget(root, profile)
	if not target then return false end
	local customPart

	if target:IsA("SpecialMesh") then
		pcall(function() target.MeshType = Enum.MeshType.FileMesh end)
		target.MeshId = meshIds[1]
		if profile.TextureId then
			pcall(function() target.TextureId = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureId = "" end)
		end
		target.Scale = target.Scale * meshScale
		pcall(function() target.VertexColor = Vector3.new(1, 1, 1) end)
		customPart = target.Parent
		applyTripminePartVisual(customPart, profile)
		for index = 2, #meshIds do
			addTripmineExtraMeshPart(customPart, meshIds[index], scaleTripmineMeshVector(target.Scale, extraMeshScale), profile, index)
		end
	elseif target:IsA("MeshPart") then
		local originalSize = target.Size
		local okMesh = pcall(function()
			target.MeshId = meshIds[1]
		end)
		if profile.TextureId then
			pcall(function() target.TextureID = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureID = "" end)
		end
		applyTripminePartVisual(target, profile)
		if okMesh then
			pcall(function()
				target.Size = originalSize * meshScale
			end)
			customPart = target
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(target, meshIds[index], scaleTripmineMeshVector(Vector3.new(1, 1, 1), extraMeshScale), profile, index)
			end
		elseif target.Parent then
			pcall(function()
				target.Transparency = 1
				target.LocalTransparencyModifier = 1
			end)
			local overlay = target.Parent:FindFirstChild("__LionCustomTripmineMesh")
			if not (overlay and overlay:IsA("BasePart")) then
				overlay = Instance.new("Part")
				overlay.Name = "__LionCustomTripmineMesh"
				overlay.Anchored = target.Anchored
				overlay.CanCollide = false
				overlay.CanTouch = false
				overlay.CanQuery = false
				overlay.Massless = true
				overlay.Parent = target.Parent
			end
			overlay.Size = originalSize
			overlay.CFrame = target.CFrame
			applyTripminePartVisual(overlay, profile)
			local mesh = overlay:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = meshIds[1]
			if profile.TextureId then
				pcall(function() mesh.TextureId = profile.TextureId end)
			elseif profile.ClearTexture then
				pcall(function() mesh.TextureId = "" end)
			end
			mesh.Scale = Vector3.new(meshScale, meshScale, meshScale)
			pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
			mesh.Parent = overlay
			overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
			customPart = overlay
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(overlay, meshIds[index], scaleTripmineMeshVector(meshScale, extraMeshScale), profile, index)
			end
			if not overlay:FindFirstChild("__LionCustomTripmineMeshWeld") then
				local weld = Instance.new("WeldConstraint")
				weld.Name = "__LionCustomTripmineMeshWeld"
				weld.Part0 = target
				weld.Part1 = overlay
				weld.Parent = overlay
			end
		end
	end

	if customPart and customPart:IsA("BasePart") then
		customPart:SetAttribute("__LionCustomTripmineMeshPart", true)
	end
	root:SetAttribute("__LionTripmineMeshSkin", profile.Skin)
	root:SetAttribute("__LionCustomTripmineMeshId", meshIds[1])
	root:SetAttribute("__LionCustomTripmineMeshIds", meshSignature)
	root:SetAttribute("__LionCustomTripmineMeshScale", meshScale)
	return true
end

local function applyVirtualViewModelAssetOverrides(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		applyTripmineMeshProfile(asset, profile)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		applyDaggerMeshProfile(asset, daggerProfile)
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		applySatchelMeshProfile(asset, satchelProfile)
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		applyRpgMeshProfile(asset, rpgProfile)
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		applyFistsMeshProfile(asset, fistsProfile)
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		applyBowMeshProfile(asset, bowProfile)
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		applyAssaultRifleMeshProfile(asset, assaultRifleProfile)
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		applySniperMeshProfile(asset, sniperProfile)
	end
end

local function shouldRebuildVirtualViewModelAsset(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		local meshIds = getTripmineMeshIds(profile)
		return not asset
			or asset:GetAttribute("__LionTripmineMeshSkin") ~= profile.Skin
			or asset:GetAttribute("__LionCustomTripmineMeshIds") ~= getTripmineMeshSignature(profile)
			or asset:GetAttribute("__LionCustomTripmineMeshScale") ~= (profile.Scale or 1)
			or asset:GetAttribute("__LionCustomTripmineMeshId") ~= meshIds[1]
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		return not asset
			or asset:GetAttribute("__LionSniperMeshSkin") ~= sniperProfile.Skin
			or asset:GetAttribute("__LionSniperMeshSignature") ~= getSniperMeshSignature(sniperProfile)
			or not asset:FindFirstChild("__LionCustomSniperReplacement", true)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		return not asset
			or asset:GetAttribute("__LionDaggerMeshSkin") ~= daggerProfile.Skin
			or asset:GetAttribute("__LionDaggerMeshSignature") ~= getDaggerMeshSignature(daggerProfile)
			or (asset:GetAttribute("__LionDaggerMeshCount") or 0) <= 0
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		return not asset
			or asset:GetAttribute("__LionSatchelMeshSkin") ~= satchelProfile.Skin
			or asset:GetAttribute("__LionSatchelMeshSignature") ~= getSatchelMeshSignature(satchelProfile)
			or (asset:GetAttribute("__LionSatchelMeshCount") or 0) <= 0
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		return not asset
			or asset:GetAttribute("__LionRpgMeshSkin") ~= rpgProfile.Skin
			or asset:GetAttribute("__LionRpgMeshSignature") ~= getRpgMeshSignature(rpgProfile)
			or asset:GetAttribute("__LionRpgRocketVisible") ~= false
			or ((asset:GetAttribute("__LionRpgMeshCount") or 0) + (asset:GetAttribute("__LionRpgHiddenCount") or 0)) <= 0
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		return not asset
			or asset:GetAttribute("__LionFistsMeshSkin") ~= fistsProfile.Skin
			or asset:GetAttribute("__LionFistsMeshSignature") ~= getFistsMeshSignature(fistsProfile)
			or (asset:GetAttribute("__LionFistsMeshCount") or 0) <= 0
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		return not asset
			or asset:GetAttribute("__LionBowMeshSkin") ~= bowProfile.Skin
			or asset:GetAttribute("__LionBowMeshSignature") ~= getBowMeshSignature(bowProfile)
			or (asset:GetAttribute("__LionBowMeshCount") or 0) <= 0
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		return not asset
			or asset:GetAttribute("__LionAssaultRifleMeshSkin") ~= assaultRifleProfile.Skin
			or asset:GetAttribute("__LionAssaultRifleMeshSignature") ~= getAssaultRifleMeshSignature(assaultRifleProfile)
			or (asset:GetAttribute("__LionAssaultRifleMeshCount") or 0) <= 0
	end
	return cosmeticName == DICE_TRIPMINE_SKIN
		and asset
		and asset:GetAttribute("__LionRightArmRetargeted")
end

local function ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	local sourceInfo = ilib.ViewModels and ilib.ViewModels[viewModelName]
	if not sourceInfo then return nil end

	if cosmeticName ~= viewModelName then
		local usesSourceAnimations = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName] or DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName] or SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName] or RPG_MESH_SKIN_OVERRIDES[cosmeticName] or FISTS_MESH_SKIN_OVERRIDES[cosmeticName] or BOW_MESH_SKIN_OVERRIDES[cosmeticName] or ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName] or cosmeticName == KNIFE_CUSTOM_SKIN or cosmeticName == "Grenade (Custom Skin)" or cosmeticName == "Molotov (Custom Skin)" or cosmeticName == "Satchel (Custom Skin)" or cosmeticName == "Smoke Grenade (Custom Skin)" or cosmeticName == "Warpstone (Custom Skin)" or cosmeticName == "sky"
		local animationInfo = usesSourceAnimations and sourceInfo or ilib.ViewModels[itemName]
		local baseInfo = animationInfo or sourceInfo
		local virtualInfo = table.clone(sourceInfo)
		if type(baseInfo.Animations) == "table" then
			virtualInfo.Animations = table.clone(baseInfo.Animations)
		end
		ilib.ViewModels[cosmeticName] = virtualInfo

		pcall(function()
			local viewModelAssets = lps.Assets and lps.Assets:FindFirstChild("ViewModels")
			if not viewModelAssets then return end
			local existingAsset = findDescendantByName(viewModelAssets, cosmeticName)
			if existingAsset then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingAsset, false) then
					existingAsset:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingAsset, false)
					return
				end
			end

			local sourceAsset = findDescendantByName(viewModelAssets, viewModelName)
			if sourceAsset then
				local clonedAsset = sourceAsset:Clone()
				clonedAsset.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedAsset, false)
				clonedAsset.Parent = viewModelAssets
			end
		end)

		pcall(function()
			local throwables = lps.Assets and lps.Assets:FindFirstChild("Throwables")
			if not throwables then return end
			local existingThrowable = throwables:FindFirstChild(cosmeticName)
			if existingThrowable then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingThrowable, true) then
					existingThrowable:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingThrowable, true)
					return
				end
			end
			local sourceThrowable = findDescendantByName(throwables, viewModelName)
			if sourceThrowable then
				local clonedThrowable = sourceThrowable:Clone()
				clonedThrowable.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedThrowable, true)
				clonedThrowable.Parent = throwables
			end
		end)

		pcall(function()
			if itemName ~= "Jump Pad" then return end
			local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
			local jumpPads = misc and misc:FindFirstChild("JumpPads")
			if not jumpPads then return end
			local existingJumpPad = jumpPads:FindFirstChild(cosmeticName)
			if existingJumpPad then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingJumpPad, true) then
					existingJumpPad:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingJumpPad, true)
					return
				end
			end
			local sourceJumpPad = jumpPads:FindFirstChild(viewModelName) or jumpPads:FindFirstChild("Default")
			if sourceJumpPad then
				local clonedJumpPad = sourceJumpPad:Clone()
				clonedJumpPad.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedJumpPad, true)
				clonedJumpPad.Parent = jumpPads
			end
		end)
	end

	return sourceInfo
end

local function registerVirtualWeaponSkin(cosmeticName, itemName, viewModelName, rarity, displayName, worldViewModelName)
	local viewModelInfo = ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	if not viewModelInfo then return end
	local imageInfo = cosmeticName == DICE_TRIPMINE_SKIN and ilib.ViewModels and ilib.ViewModels["RNG Dice"] or viewModelInfo
	local image = imageInfo.Image or ""
	local imageHighResolution = imageInfo.ImageHighResolution or imageInfo.Image or ""
	local imageOverride = CUSTOM_SKIN_IMAGE_OVERRIDES[cosmeticName]
	if imageOverride then
		image = imageOverride.Image or ""
		imageHighResolution = imageOverride.ImageHighResolution or imageOverride.Image or ""
	end

	if ilib.ViewModels and ilib.ViewModels[cosmeticName] then
		ilib.ViewModels[cosmeticName].Image = image
		ilib.ViewModels[cosmeticName].ImageHighResolution = imageHighResolution
	end

	coss[cosmeticName] = {
		Rarity = rarity or "Contraband",
		Type = "Skin",
		DisplayName = displayName or cosmeticName,
		ViewModelName = cosmeticName,
		SourceViewModelName = viewModelName,
		WorldViewModelName = worldViewModelName or viewModelName,
		Image = image,
		ImageHighResolution = imageHighResolution,
		ImageScale = 3,
		ItemName = itemName,
		Owned = true,
		Unlocked = true,
		Locked = false
	}
end

local function registerVirtualWeaponSkins()
	coss["Flashbang (Custom Skin)"] = nil
	if ilib.ViewModels then
		ilib.ViewModels["Flashbang (Custom Skin)"] = nil
	end
	registerVirtualWeaponSkin(KNIFE_CUSTOM_SKIN, "Knife", "Glast Shard", "Contraband")
	registerVirtualWeaponSkin(REAVER_KNIFE_CUSTOM_SKIN, "Knife", "Pencil", "Contraband", "reaver")
	registerVirtualWeaponSkin(DAGGERS_CUSTOM_SKIN, "Daggers", "Keynais", "Contraband")
	registerVirtualWeaponSkin("Grenade (Custom Skin)", "Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Grenade Raze", "Grenade", "Glorious Grenade", "Contraband", "Raze")
	registerVirtualWeaponSkin("sky", "Flashbang", "Shining Star", "Contraband")
	registerVirtualWeaponSkin("Molotov (Custom Skin)", "Molotov", "Elixir", "Contraband", "Elixir")
	registerVirtualWeaponSkin("Satchel (Custom Skin)", "Satchel", "Elixir", "Contraband")
	registerVirtualWeaponSkin(SATCHEL_CUSTOM_SKIN, "Satchel", "Satchel", "Contraband", "Raze", SATCHEL_CUSTOM_SKIN)
	registerVirtualWeaponSkin("Smoke Grenade (Custom Skin)", "Smoke Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Warpstone (Custom Skin)", "Warpstone", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Scythe (Custom Skin)", "Scythe", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Katana (Custom Skin)", "Katana", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Spear (Custom Skin)", "Spear", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Handgun (Custom Skin)", "Handgun", "Glass Cannon", "Contraband")
	registerVirtualWeaponSkin(SNIPER_CUSTOM_SKIN, "Sniper", "Keyper", "Contraband")
	registerVirtualWeaponSkin("Operator", "Sniper", "Sniper", "Contraband")
	registerVirtualWeaponSkin("Medkit (Custom Skin)", "Medkit", "RNG Dice", "Contraband")
	registerVirtualWeaponSkin(RPG_CUSTOM_SKIN, "RPG", "Nuke Launcher", "Contraband", "Raze", RPG_CUSTOM_SKIN)
	registerVirtualWeaponSkin(FISTS_CUSTOM_SKIN, "Fists", "Fists", "Contraband", "Agent")
	registerVirtualWeaponSkin(BOW_CUSTOM_SKIN, "Bow", "Frostbite Bow", "Contraband")
	registerVirtualWeaponSkin(ASSAULT_RIFLE_CUSTOM_SKIN, "Assault Rifle", "AK-47", "Contraband")
	registerVirtualWeaponSkin("Camera", "Jump Pad", "Jump Pad", "Contraband", "Camera", "Camera")
	registerVirtualWeaponSkin(DICE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", nil, DICE_TRIPMINE_SKIN)
	registerVirtualWeaponSkin(SPIKE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", "Spike", SPIKE_TRIPMINE_SKIN)
end

registerVirtualWeaponSkins()

local cdata = dctrl.CurrentData
if not cdata then
	task.spawn(function()
		repeat task.wait() until dctrl.CurrentData
		cdata = dctrl.CurrentData
	end)
end

local equip, favs = {}, {}
local cwep, vprof, lwep
local lpname = lp.Name
local fcache = {}
getgenv().NemesisEquipTable = equip
getgenv().NemesisFinisherCache = fcache

-- Serialize equip to name-only map (JSON-safe) and save forever
local function nemesisSerializeEquip()
	local out = {}
	for weapon, slots in pairs(equip) do
		if type(weapon) == "string" and type(slots) == "table" then
			local row = {}
			for ctype, cos in pairs(slots) do
				local name = nil
				if type(cos) == "string" then
					name = cos
				elseif type(cos) == "table" then
					name = cos.Name or cos.DisplayName
				end
				if type(name) == "string" and name ~= "" and name ~= "None" then
					row[ctype] = name
				end
			end
			if next(row) then out[weapon] = row end
		end
	end
	-- finisher cache names
	local fc = {}
	for w, n in pairs(fcache) do
		if type(w) == "string" and type(n) == "string" then fc[w] = n end
	end
	getgenv().NemesisEquipNames = out
	getgenv().NemesisFinisherNames = fc
	getgenv().NemesisSkinConfig = getgenv().NemesisSkinConfig or {}
	getgenv().NemesisSkinConfig.equip = out
	getgenv().NemesisSkinConfig.fcache = fc
	getgenv().NemesisCosmeticMirror = getgenv().NemesisSkinConfig
	getgenv().LionSkinState = getgenv().NemesisSkinConfig
	return out
end
getgenv().NemesisSerializeEquip = nemesisSerializeEquip

local function nemesisPersistSkins()
	pcall(nemesisSerializeEquip)
	if getgenv().NemesisSaveSkins then
		pcall(getgenv().NemesisSaveSkins)
	end
end
getgenv().NemesisPersistSkins = nemesisPersistSkins

local function banned(n)
	if type(n) ~= "string" then return true end
	return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll") or n:find("Fall Apart") or n:find("Every Finisher Ever")
end

local function toenum(n)
	if not elib then return nil end
	local ok, id = pcall(elib.ToEnum, elib, n)
	return ok and id or nil
end

local function clonecos(name, ctype, inv, favonly)
	if banned(name) then return nil end
	local base = coss[name]
	if not base then return nil end
	local d = table.clone(base)
	d.Name = name
	d.Type = d.Type or ctype
	d.Seed = d.Seed or math.random(1, 1000000)
	d.Owned = true
	d.Unlocked = true
	d.Locked = false
	d.Amount = math.max(1, tonumber(d.Amount) or 1)
	d.Count = math.max(1, tonumber(d.Count) or 1)
	local eid = toenum(name)
	if eid then d.Enum = eid d.ObjectID = d.ObjectID or eid end
	if inv ~= nil then d.Inverted = inv end
	if favonly ~= nil then d.OnlyUseFavorites = favonly end
	return d
end

-- savecfg and loadcfg removed

local finv = {}
local function rebuildinv()
	table.clear(finv)
	for _, cos in equip do
		for _, cd in cos do
			if cd and cd.Name and not banned(cd.Name) then
				finv[cd.Name] = cd
			end
		end
	end
end

rebuildinv()

local oget = dctrl.Get
dctrl.Get = function(self, key)
	local data = oget(self, key)
	if key == "CosmeticInventory" then
		local proxy = {}
		if data then for k, v in data do if not banned(k) then proxy[k] = v end end end
		for name, cosmetic in finv do
			if proxy[name] == nil or type(proxy[name]) == "boolean" then
				proxy[name] = cosmetic
			end
		end
		return proxy
	end
	if key == "FavoritedCosmetics" then
		local res = data and table.clone(data) or {}
		for wep, fv in favs do
			local slot = res[wep] or {}
			res[wep] = slot
			for name, isfav in fv do
				if not banned(name) then slot[name] = isfav end
			end
		end
		return res
	end
	return data
end

local ogetwep = dctrl.GetWeaponData
dctrl.GetWeaponData = function(self, wname)
	local data = ogetwep(self, wname)
	if not data then return nil end
	local merged = table.clone(data)
	merged.Name = wname
	local weq = equip[wname]
	if weq then for ct, cd in weq do merged[ct] = cd end end
	return merged
end

local function saferep(key)
	pcall(function()
		if not cdata and dctrl.CurrentData then cdata = dctrl.CurrentData end
		if cdata then cdata:Replicate(key) end
	end)
end

local fctrl, wrapController
pcall(function() fctrl = require(ctrls:WaitForChild("FighterController", 10)) end)
pcall(function() wrapController = require(ctrls:WaitForChild("WrapController", 10)) end)
local replicatedClass
pcall(function()
	local identity = getthreadidentity and getthreadidentity()
	if setthreadidentity then pcall(setthreadidentity, 2) end
	local ok, result = pcall(require, reps.Modules.ReplicatedClass)
	if identity and setthreadidentity then pcall(setthreadidentity, identity) end
	if ok then replicatedClass = result end
end)
local charmAssets, wrapPreviewAsset, wrapTextureAssets
pcall(function()
	charmAssets = lps.Assets:WaitForChild("Charms", 10)
	wrapPreviewAsset = lps.Assets:WaitForChild("Misc", 10):WaitForChild("Wrap", 10)
	wrapTextureAssets = lps.Assets:WaitForChild("WrapTextures", 10)
end)

local function resolveViewModelName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	return skinName or weapon
end

local function resolveViewModelSourceName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	return skin and (skin.SourceViewModelName or skin.ViewModelName or skin.Name) or weapon
end

local virtualViewModelClassOverrides = {
	[KNIFE_CUSTOM_SKIN] = "Knife",
	[REAVER_KNIFE_CUSTOM_SKIN] = "Knife",
	[DAGGERS_CUSTOM_SKIN] = "Keynais",
	[SNIPER_CUSTOM_SKIN] = "Keyper",
	["Operator"] = "Sniper",
	[RPG_CUSTOM_SKIN] = "Nuke Launcher",
	[FISTS_CUSTOM_SKIN] = "Fists",
		[BOW_CUSTOM_SKIN] = "Frostbite Bow",
		[ASSAULT_RIFLE_CUSTOM_SKIN] = "AK-47",
		["Grenade (Custom Skin)"] = "Elixir",
		["Grenade Raze"] = "Glorious Grenade",
		["sky"] = "Shining Star",
	["Molotov (Custom Skin)"] = "Elixir",
	["Satchel (Custom Skin)"] = "Elixir",
	["Smoke Grenade (Custom Skin)"] = "Elixir",
	["Warpstone (Custom Skin)"] = "Elixir",
	[SATCHEL_CUSTOM_SKIN] = "BaseSatchel",
	[DICE_TRIPMINE_SKIN] = "SubspaceTripmine",
	[SPIKE_TRIPMINE_SKIN] = "SubspaceTripmine"
}

local function resolveViewModelClassName(_, cosmetics, resolvedName)
	return (resolvedName and virtualViewModelClassOverrides[resolvedName]) or resolvedName
end

local resolveViewModelClass
local clientViewModelClass
local clientViewModelBaseNew
local constructingVirtualViewModelClass = false

local function getewep()
	if not fctrl then return nil end
	local fighter = fctrl:GetFighter(lp)
	if not fighter or not fighter.Items then return nil end
	for _, item in fighter.Items do
		if item.IsEquipped then return item.Name end
	end
	return nil
end

if hookfunction then
	local rems = reps:FindFirstChild("Remotes")
	local drems = rems and rems:FindFirstChild("Data")
	local eqrem = drems and drems:FindFirstChild("EquipCosmetic")
	local favrem = drems and drems:FindFirstChild("FavoriteCosmetic")
	local rrems = rems and rems:FindFirstChild("Replication")
	local frems = rrems and rrems:FindFirstChild("Fighter")
	local uirem = frems and frems:FindFirstChild("UseItem")

	if eqrem then
		local oldFireServer
		oldFireServer = hookfunction(eqrem.FireServer, newcclosure(function(self, ...)
			local args = { ... }

			if uirem and self == uirem and fctrl then
				pcall(function()
					local fighter = fctrl:GetFighter(lp)
					if fighter and fighter.Items then
						local oid = args[1]
						for _, item in fighter.Items do
							if item:Get("ObjectID") == oid then
								lwep = item.Name
								break
							end
						end
					end
				end)
			end

			if self == eqrem then
				local wname, ctype, cname, opts = args[1], args[2], args[3], args[4] or {}
				if not cname or cname == "None" or cname == "" then
					equip[wname] = equip[wname] or {}
					equip[wname][ctype] = nil
					if not next(equip[wname]) then equip[wname] = nil end
					rebuildinv()
					task.defer(function()
						saferep("WeaponInventory")
					end)
					return oldFireServer(self, ...)
				end
				if banned(cname) then return oldFireServer(self, ...) end
				local rdata = oget(dctrl, "CosmeticInventory")
				if rdata and type(rdata[cname]) ~= "boolean" and rdata[cname] ~= nil then
					return oldFireServer(self, ...)
				end
				equip[wname] = equip[wname] or {}
				local cloned = clonecos(cname, ctype, opts.IsInverted, opts.OnlyUseFavorites)
				if cloned then equip[wname][ctype] = cloned end
				if ctype == "Finisher" then fcache[wname] = cname end
				rebuildinv()
				task.defer(function()
					saferep("WeaponInventory")
				end)
				return
			end

			if self == favrem then
				local fwep, fname, fstate = args[1], args[2], args[3]
				if not fname or fname == "None" or fname == "" then return oldFireServer(self, ...) end
				if banned(fname) then return oldFireServer(self, ...) end
				favs[fwep] = favs[fwep] or {}
				favs[fwep][fname] = fstate or nil
				task.spawn(saferep, "FavoritedCosmetics")
				return
			end

			return oldFireServer(self, ...)
		end))
	end
end

local citem
pcall(function() citem = require(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

local function applyLiveFistsMeshProfile(wname, viewModel)
	if wname ~= "Fists" then return end
	local skin = equip[wname] and equip[wname].Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	local profile = skinName and FISTS_MESH_SKIN_OVERRIDES[skinName]
	if not profile then return end

	task.spawn(function()
		for _ = 1, 30 do
			local model
			if typeof(viewModel) == "Instance" then
				model = viewModel
			elseif type(viewModel) == "table" then
				model = viewModel.Model or viewModel.ItemModel
			end
			if typeof(model) == "Instance" then
				if applyFistsMeshProfile(model, profile) then
					return
				end
			end
			task.wait()
		end
	end)
end

if citem and citem._CreateViewModel then
	local ocvm = citem._CreateViewModel
	citem._CreateViewModel = function(self, vmref)
		local wname = self.Name
		local wplr = self.ClientFighter and self.ClientFighter.Player
		cwep = (wplr == lp) and wname or nil
		local directClass
		if wplr == lp and equip[wname] and vmref then
			local cos = equip[wname]
			local dk = self:ToEnum("Data")
			local data = vmref[dk] or vmref.Data or {}
			if data then
				if vmref[dk] ~= nil or vmref.Data == nil then
					vmref[dk] = data
					vmref.Data = nil
				else
					vmref.Data = data
				end
				local resolvedName = resolveViewModelName(wname, cos)
				local className = resolveViewModelClassName(wname, cos, resolvedName)
				if cos.Skin then
					data[self:ToEnum("Skin")] = cos.Skin
				end
				data[self:ToEnum("Name")] = resolvedName
				if cos.Wrap then
					data[self:ToEnum("Wrap")] = cos.Wrap
				end
				if cos.Charm then
					data[self:ToEnum("Charm")] = cos.Charm
				end
				data.Skin = nil
				data.Name = nil
				data.Wrap = nil
				data.Charm = nil
				if className ~= resolvedName and resolveViewModelClass then
					directClass = resolveViewModelClass(className)
				end
			end
		end
		if directClass and directClass ~= clientViewModelClass and directClass.new then
			local identity = getthreadidentity and getthreadidentity() or 8
			constructingVirtualViewModelClass = true
			local ok, res = pcall(function()
				if setthreadidentity then pcall(setthreadidentity, 2) end
				return directClass.new(vmref, self)
			end)
			constructingVirtualViewModelClass = false
			if setthreadidentity then pcall(setthreadidentity, identity) end
			cwep = nil
			if ok then
				applyLiveFistsMeshProfile(wname, res)
				return res
			end
		end
		local res = ocvm(self, vmref)
		cwep = nil
		applyLiveFistsMeshProfile(wname, res)
		return res
	end
end

local vmmod = lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if vmmod then
	local cvm = require(vmmod)
	clientViewModelClass = cvm
	if cvm.GetWrap then
		local ogw = cvm.GetWrap
		cvm.GetWrap = function(self)
			local ci = self.ClientItem
			local wname = ci and ci.Name
			local wplr = ci and ci.ClientFighter and ci.ClientFighter.Player
			local weq = wname and wplr == lp and equip[wname]
			return (weq and weq.Wrap) or ogw(self)
		end
	end
	if cvm._UpdateWrap and wrapController then
		local oldUpdateWrap = cvm._UpdateWrap
		local function isCustomTripmineViewModel(self)
			if not self then return false end
			if TRIPMINE_MESH_SKIN_OVERRIDES[self.Name] then
				return true
			end
			local ci = self.ClientItem
			local weapon = ci and ci.Name
			local skin = weapon and equip[weapon] and equip[weapon].Skin
			local skinName = skin and (skin.ViewModelName or skin.Name)
			return weapon == "Subspace Tripmine" and TRIPMINE_MESH_SKIN_OVERRIDES[skinName] ~= nil
		end
		local function collectCustomTripmineWrapTargets(model)
			local targets = {}
			for _, descendant in ipairs(model:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
					if descendant:GetAttribute("WrapGroup") == nil then
						descendant:SetAttribute("WrapGroup", 1)
					end
					descendant:SetAttribute("IgnoreTransparency", true)
					pcall(function() descendant:AddTag("Wrappable") end)
					pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
					table.insert(targets, descendant)
				end
			end
			return targets
		end
		cvm._UpdateWrap = function(self, ...)
			if isCustomTripmineViewModel(self) and self.Model then
				local targets = collectCustomTripmineWrapTargets(self.Model)
				if #targets > 0 then
					local wrap = self.GetWrap and self:GetWrap() or nil
					if self._original_wrap_properties then
						pcall(wrapController.ResetWrap, wrapController, self._original_wrap_properties)
						self._original_wrap_properties = nil
					end
					if self.__LionCustomTripmineWrapProperties then
						pcall(wrapController.ResetWrap, wrapController, self.__LionCustomTripmineWrapProperties)
						self.__LionCustomTripmineWrapProperties = nil
					end
					if wrap then
						self.__LionCustomTripmineWrapProperties = wrapController:RecordOriginalWrapProperties(targets)
						wrapController:ApplyWrap(self.__LionCustomTripmineWrapProperties, wrap, true)
					end
					if self._UpdateLocalTransparencyModifiers then
						pcall(self._UpdateLocalTransparencyModifiers, self)
					end
					return
				end
			end
			return oldUpdateWrap(self, ...)
		end
	end
	local onew = cvm.new
	clientViewModelBaseNew = onew
	cvm.new = function(rdata, cliitm)
		if constructingVirtualViewModelClass then
			return onew(rdata, cliitm)
		end
		local wplr = cliitm.ClientFighter and cliitm.ClientFighter.Player
		local wname = cwep or cliitm.Name
		local className = wname
		if wplr == lp and equip[wname] then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			if rdata[dk] ~= nil or rdata.Data == nil then
				rdata[dk] = slot
				rdata.Data = nil
			else
				rdata.Data = slot
			end
			local cos = equip[wname]
			local resolvedName = resolveViewModelName(wname, cos)
			className = resolveViewModelClassName(wname, cos, resolvedName)
			if cos.Skin then
				slot[rcls:ToEnum("Skin")] = cos.Skin
			end
			slot[rcls:ToEnum("Name")] = resolvedName
			if cos.Wrap then
				slot[rcls:ToEnum("Wrap")] = cos.Wrap
			end
			if cos.Charm then
				slot[rcls:ToEnum("Charm")] = cos.Charm
			end
			slot.Skin = nil
			slot.Name = nil
			slot.Wrap = nil
			slot.Charm = nil
		end
		local targetNew = onew
		local targetClass = className ~= wname and resolveViewModelClass and resolveViewModelClass(className)
		if targetClass and targetClass ~= clientViewModelClass and targetClass.new then
			targetNew = targetClass.new
		end
		constructingVirtualViewModelClass = targetNew ~= onew
		local ok, res = pcall(targetNew, rdata, cliitm)
		constructingVirtualViewModelClass = false
		if not ok and wplr == lp and equip[wname] and equip[wname].Skin then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			rdata[dk] = slot
			rdata.Data = nil
			slot[rcls:ToEnum("Name")] = wname
			slot.Name = nil
			ok, res = pcall(onew, rdata, cliitm)
		end
		if not ok then error(res) end
		if wplr == lp and equip[wname] and res then
			for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
				if res[method] then
					pcall(res[method], res)
				end
			end
			applyLiveFistsMeshProfile(wname, res)
		end
		return res
	end
end

local viewModelClassCache = {}
local function normalizeViewModelName(name)
	return tostring(name or ""):gsub("[%W_]+", ""):lower()
end

resolveViewModelClass = function(name)
	if not clientViewModelClass then return nil end
	local key = normalizeViewModelName(name)
	if viewModelClassCache[key] ~= nil then
		return viewModelClassCache[key] or clientViewModelClass
	end
	local targetClass = clientViewModelClass
	local vmFolder = lps.Modules:FindFirstChild("ViewModels")
	if vmFolder then
		for _, module in pairs(vmFolder:GetDescendants()) do
			if module:IsA("ModuleScript") and normalizeViewModelName(module.Name) == key then
				local ok, customClass = pcall(require, module)
				if ok and type(customClass) == "table" and type(customClass.new) == "function" then
					targetClass = customClass
				end
				break
			end
		end
	end
	viewModelClassCache[key] = targetClass
	return targetClass
end

local function getLocalItem(weapon)
	local fighter = fctrl and fctrl:GetFighter(lp)
	for _, item in pairs(fighter and fighter.Items or {}) do
		if item.Name == weapon then
			return item
		end
	end
end

local function getWorldSkinName(weapon)
	local skin = equip[weapon] and equip[weapon].Skin
	return skin and (skin.WorldViewModelName or skin.SourceViewModelName or skin.ViewModelName or skin.Name)
end

local function getEquippedWeaponWrap(weapon)
	local item = getLocalItem(weapon)
	if item and item.GetWrap then
		local ok, wrap = pcall(item.GetWrap, item)
		if ok then
			return wrap
		end
	end
	return equip[weapon] and equip[weapon].Wrap
end

local function isInsideWorkspaceViewModels(inst)
	local viewModels = workspace:FindFirstChild("ViewModels")
	return viewModels and inst:IsDescendantOf(viewModels)
end

local function isRpgRazeEquipped()
	return getWorldSkinName("RPG") == RPG_CUSTOM_SKIN
end

local function tryApplyRpgProjectileSkin(inst)
	local profile = RPG_MESH_SKIN_OVERRIDES[RPG_CUSTOM_SKIN]
	if not (profile and isRpgRazeEquipped() and typeof(inst) == "Instance") then return end
	if isInsideWorkspaceViewModels(inst) then return end
	if inst:GetAttribute("__LionRpgProjectileSkinChecked") then return end

	local shouldApply = false
	if inst:IsA("MeshPart") or inst:IsA("SpecialMesh") then
		shouldApply = meshMatchesAnyAssetId(inst, profile.RocketMeshIds) or meshMatchesAnyAssetId(inst, profile.JuggleMeshIds)
	elseif inst:IsA("Model") then
		shouldApply = namePathContains(inst, "rocket") or namePathContains(inst, "projectile")
	end
	if not shouldApply then return end

	inst:SetAttribute("__LionRpgProjectileSkinChecked", true)
	applyRpgMeshProfile(inst, profile, {
		ShowRocket = true,
		ForceRocket = true
	})
end

local function installRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__LionRpgProjectileSkinHookState or {}
	env.__LionRpgProjectileSkinHookState = state
	local version = 2
	if state.Version == version and state.Connection then return end
	if state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	state.Version = version
	state.Connection = workspace.DescendantAdded:Connect(function(inst)
		task.defer(tryApplyRpgProjectileSkin, inst)
	end)
	task.defer(function()
		for _, inst in ipairs(workspace:GetDescendants()) do
			tryApplyRpgProjectileSkin(inst)
		end
	end)
end

local function disableRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__LionRpgProjectileSkinHookState
	if state and state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	env.__LionRpgProjectileSkinHookState = {
		Version = 3,
		Connection = nil
	}
end

local function ensurePlacedTripmineWrapTargets(visual)
	if typeof(visual) ~= "Instance" then return end
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
			if descendant:GetAttribute("WrapGroup") == nil then
				descendant:SetAttribute("WrapGroup", 1)
			end
			descendant:SetAttribute("IgnoreTransparency", true)
			pcall(function() descendant:AddTag("Wrappable") end)
			pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
		end
	end
end

local function applyPlacedTripmineWrap(visual)
	if not wrapController or typeof(visual) ~= "Instance" then return end
	ensurePlacedTripmineWrapTargets(visual)
	local wrap = getEquippedWeaponWrap("Subspace Tripmine")
	pcall(function()
		local originalWrapProperties = wrapController:RecordOriginalWrapProperties(visual)
		wrapController:ApplyWrap(originalWrapProperties, wrap, true)
	end)
end

local function isLocalPlacedObject(object, weapon)
	local userId = object:GetAttribute("PlacedByUserID")
		or object:GetAttribute("ThrownByUserID")
		or object:GetAttribute("OwnerUserID")
	if userId ~= nil then
		return tonumber(userId) == lp.UserId
	end

	local objectId = object:GetAttribute("ObjectID")
	local item = getLocalItem(weapon)
	return objectId ~= nil and item and item.Get and item:Get("ObjectID") == objectId
end

local function isInsidePlacedSkinVisual(inst)
	local current = inst
	while current do
		if current.Name == "__LionPlacedSkin" or current:GetAttribute("__LionPlacedSkin") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideOriginalTripmineVisual(object)
	if typeof(object) ~= "Instance" then return end

	local function hide(inst)
		if isInsidePlacedSkinVisual(inst) then return end
		if inst:IsA("BasePart") then
			inst.Transparency = 1
			inst.LocalTransparencyModifier = 1
		elseif inst:IsA("Decal") or inst:IsA("Texture") then
			inst.Transparency = 1
		elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
			inst.Enabled = false
		end
	end

	for _, descendant in ipairs(object:GetDescendants()) do
		hide(descendant)
	end

	if not object:GetAttribute("__LionHideOriginalTripmineHook") then
		object:SetAttribute("__LionHideOriginalTripmineHook", true)
		local connection
		connection = object.DescendantAdded:Connect(function(descendant)
			task.defer(hide, descendant)
		end)
		task.delay(8, function()
			if connection then
				connection:Disconnect()
			end
		end)
	end

	if not object:GetAttribute("__LionHideOriginalTripmineLoop") then
		object:SetAttribute("__LionHideOriginalTripmineLoop", true)
		task.spawn(function()
			for _ = 1, 80 do
				if not object.Parent then break end
				for _, descendant in ipairs(object:GetDescendants()) do
					hide(descendant)
				end
				task.wait(0.1)
			end
			if object.Parent then
				object:SetAttribute("__LionHideOriginalTripmineLoop", nil)
			end
		end)
	end
end

local function prunePlacedTripmineVisualToCustomMesh(visual)
	if typeof(visual) ~= "Instance" then return end
	local primaryPart
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant:GetAttribute("__LionCustomTripmineMeshPart") then
				primaryPart = primaryPart or descendant
			else
				descendant:Destroy()
			end
		end
	end
	if visual:IsA("Model") and primaryPart then
		visual.PrimaryPart = primaryPart
	end
end

local function isInsideCustomTripmineMeshPart(inst)
	local current = inst
	while current do
		if current:IsA("BasePart") and current:GetAttribute("__LionCustomTripmineMeshPart") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function forcePlacedSkinVisualVisible(visual)
	if typeof(visual) ~= "Instance" then return end

	local function show(inst)
		if inst:IsA("BasePart") and inst:GetAttribute("__LionCustomTripmineMeshPart") then
			inst.Transparency = 0
			inst.LocalTransparencyModifier = 0
		elseif (inst:IsA("Decal") or inst:IsA("Texture")) and isInsideCustomTripmineMeshPart(inst) then
			inst.Transparency = 0
		end
	end

	for _, descendant in ipairs(visual:GetDescendants()) do
		show(descendant)
	end

	if not visual:GetAttribute("__LionShowPlacedSkinLoop") then
		visual:SetAttribute("__LionShowPlacedSkinLoop", true)
		local connection
		connection = visual.DescendantAdded:Connect(function(descendant)
			task.defer(show, descendant)
		end)
		task.spawn(function()
			for _ = 1, 100 do
				if not visual.Parent then break end
				for _, descendant in ipairs(visual:GetDescendants()) do
					show(descendant)
				end
				task.wait(0.1)
			end
			if connection then
				connection:Disconnect()
			end
			if visual.Parent then
				visual:SetAttribute("__LionShowPlacedSkinLoop", nil)
			end
		end)
	end
end

local function pivotPlacedTripmineVisual(visual, hitbox, profile)
	if not (visual and visual:IsA("Model") and hitbox and hitbox:IsA("BasePart")) then return end
	local boundsCFrame, boundsSize = visual:GetBoundingBox()
	local centerOffset = visual:GetPivot():ToObjectSpace(boundsCFrame)
	local groundOffset = profile and profile.WorldGroundOffset or 0
	local targetCenterOffsetY = (-hitbox.Size.Y * 0.5) + (boundsSize.Y * 0.5) + groundOffset
	local targetBoundsCFrame = hitbox.CFrame * CFrame.new(0, targetCenterOffsetY, 0)
	visual:PivotTo(targetBoundsCFrame * centerOffset:Inverse())
end

local function installPlacedCosmeticHooks()
	local components = lps.Modules:FindFirstChild("GameComponents")
	if not components then return end

	pcall(function()
		local jumpPads = require(components:WaitForChild("JumpPads", 10))
		if jumpPads.__LionSkinHook then return end
		jumpPads.__LionSkinHook = true
		local oldObjectAdded = jumpPads._ObjectAdded
		jumpPads._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Jump Pad")
			if skinName and isLocalPlacedObject(object, "Jump Pad") then
				object:SetAttribute("ViewModelName", skinName)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local tripmines = require(components:WaitForChild("SubspaceTripmines", 10))
		if tripmines.__LionSkinHook then return end
		tripmines.__LionSkinHook = true
		local oldObjectAdded = tripmines._ObjectAdded
		tripmines._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Subspace Tripmine")
			local placedSkinName = skinName == "RNG Dice" and DICE_TRIPMINE_SKIN or skinName
			local meshProfile = TRIPMINE_MESH_SKIN_OVERRIDES[placedSkinName]
			if meshProfile and isLocalPlacedObject(object, "Subspace Tripmine") then
				task.defer(function()
					if not object.Parent or object:FindFirstChild("__LionPlacedSkin") then return end
					hideOriginalTripmineVisual(object)

					local throwables = lps.Assets:FindFirstChild("Throwables")
					local viewModels = lps.Assets:FindFirstChild("ViewModels")
					local sourceName = meshProfile.BaseAssetName or "Subspace Tripmine"
					local source = (throwables and findDescendantByName(throwables, sourceName)) or (viewModels and findDescendantByName(viewModels, sourceName))
					local hitbox = object:FindFirstChild("Hitbox", true)
					if not source or not hitbox or not hitbox:IsA("BasePart") then return end

					local visual = source:Clone()
					if not applyTripmineMeshProfile(visual, meshProfile, true) then
						visual:Destroy()
						return
					end
					prunePlacedTripmineVisualToCustomMesh(visual)
					if visual:IsA("BasePart") then
						local model = Instance.new("Model")
						model.Name = visual.Name
						visual.Parent = model
						model.PrimaryPart = visual
						visual = model
					end
					if not visual:IsA("Model") then return end
					for _, descendant in pairs(visual:GetDescendants()) do
						if descendant.Name == "_right_arm" or descendant.Name == "_left_arm" or descendant.Name == "_fake" then
							descendant:Destroy()
						end
					end
					visual.Name = "__LionPlacedSkin"
					visual:SetAttribute("__LionPlacedSkin", true)
					visual.Parent = object
					hideOriginalTripmineVisual(object)
					pivotPlacedTripmineVisual(visual, hitbox, meshProfile)
					forcePlacedSkinVisualVisible(visual)
					for _, part in pairs(visual:GetDescendants()) do
						if part:IsA("BasePart") then
							part.Anchored = false
							part.CanCollide = false
							part.CanTouch = false
							part.CanQuery = false
							part.Massless = true
							local weld = Instance.new("WeldConstraint")
							weld.Part0 = hitbox
							weld.Part1 = part
							weld.Parent = part
						end
					end
					applyPlacedTripmineWrap(visual)
					forcePlacedSkinVisualVisible(visual)
				end)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local fireHitboxes = require(components:WaitForChild("FireHitboxes", 10))
		local fireAssets = lps.Assets:WaitForChild("Misc", 10):WaitForChild("FireHitboxes", 10)
		if not fireAssets:FindFirstChild("Elixir") then
			local elixirEffect = lps.Assets.Misc:FindFirstChild("ElixirExplosionEffect")
			local defaultFire = fireAssets:FindFirstChild("Default")
			if elixirEffect and defaultFire then
				local elixirFire = defaultFire:Clone()
				elixirFire.Name = "Elixir"
				for _, effect in pairs(elixirFire:GetDescendants()) do
					if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") then
						effect:Destroy()
					end
				end
				local primary = elixirFire:FindFirstChild("Primary")
				local attachment = elixirEffect:FindFirstChild("Attachment")
				if primary and attachment then
					attachment:Clone().Parent = primary
				end
				elixirFire.Parent = fireAssets
			end
		end

		local collectionService = game:GetService("CollectionService")
		local function replaceFireVisual(object)
			local skinName = getWorldSkinName("Molotov")
			if not skinName or not isLocalPlacedObject(object, "Molotov") then return end
			object:SetAttribute("ViewModelName", skinName)
			task.spawn(function()
				local entry
				for _ = 1, 20 do
					entry = fireHitboxes._fire_hitboxes and fireHitboxes._fire_hitboxes[object]
					if entry and entry.Visual then break end
					task.wait()
				end
				if not entry or not entry.Visual or not object.Parent then return end
				local source = fireAssets:FindFirstChild(skinName) or fireAssets:FindFirstChild("Default")
				if not source then return end

				local visual = source:Clone()
				visual.Name = skinName
				visual.PrimaryPart = visual:FindFirstChild("Primary")
				if not visual.PrimaryPart then return end
				visual.PrimaryPart.Size = object.Size
				visual:PivotTo(object.CFrame)
				visual.Parent = workspace
				for _, sound in ipairs({entry.Sound1, entry.Sound2}) do
					if sound then sound.Parent = visual.PrimaryPart end
				end
				local oldVisual = entry.Visual
				entry.Visual = visual
				oldVisual:Destroy()
			end)
		end

		collectionService:GetInstanceAddedSignal("FireHitbox"):Connect(replaceFireVisual)
		for _, object in pairs(collectionService:GetTagged("FireHitbox")) do
			task.defer(replaceFireVisual, object)
		end
	end)

	pcall(function()
		local smokeModule = lps.Modules:FindFirstChild("SmokeCloud")
		if not smokeModule then return end
		local smokeCloud = require(smokeModule)
		if smokeCloud.__LionSkinHook or type(smokeCloud.new) ~= "function" then return end
		smokeCloud.__LionSkinHook = true

		local oldNew = smokeCloud.new
		smokeCloud.new = function(...)
			local args = { ... }
			local cloud = oldNew(...)
			task.defer(function()
				local skinName = getWorldSkinName("Smoke Grenade")
				if skinName ~= "Elixir" or type(cloud) ~= "table" then return end

				local ownerObject
				for _, value in ipairs(args) do
					if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
						ownerObject = value
						break
					end
				end

				local model = cloud.Model
				if not ownerObject then
					for _, value in pairs(cloud) do
						if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
							ownerObject = value
							break
						end
					end
				end
				if not ownerObject and typeof(model) == "Instance" and isLocalPlacedObject(model, "Smoke Grenade") then
					ownerObject = model
				end
				if not ownerObject then
					local item = getLocalItem("Smoke Grenade")
					local localObjectId = item and item.Get and item:Get("ObjectID")
					local cloudObjectId = rawget(cloud, "ObjectID") or rawget(cloud, "_object_id")
					if localObjectId ~= nil and cloudObjectId == localObjectId then
						ownerObject = model
					end
				end
				if not ownerObject or typeof(model) ~= "Instance" or not model.Parent then return end
				if model:FindFirstChild("__LionSmokeSkin") then return end

				for _, descendant in pairs(model:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 1
					end
				end

				local throwables = lps.Assets:FindFirstChild("Throwables")
				local source = throwables and throwables:FindFirstChild(skinName)
				if not source then return end

				local visual = source:Clone()
				visual.Name = "__LionSmokeSkin"
				local anchor = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
				if not anchor then
					anchor = Instance.new("Part")
					anchor.Name = "__LionSmokeAnchor"
					anchor.Size = Vector3.new(0.1, 0.1, 0.1)
					anchor.Transparency = 1
					anchor.Anchored = true
					anchor.CanCollide = false
					anchor.CanTouch = false
					anchor.CanQuery = false
					anchor.CFrame = model:IsA("Model") and model:GetPivot() or CFrame.new()
					anchor.Parent = model
				end

				visual.Parent = model
				visual:PivotTo(anchor.CFrame)
				for _, part in pairs(visual:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Anchored = false
						part.CanCollide = false
						part.CanTouch = false
						part.CanQuery = false
						part.Massless = true
						local weld = Instance.new("WeldConstraint")
						weld.Part0 = anchor
						weld.Part1 = part
						weld.Parent = part
					end
				end
			end)
			return cloud
		end
	end)
end

disableRpgProjectileSkinHook()
installPlacedCosmeticHooks()

local function isValidViewModel(viewModel)
	return type(viewModel) == "table"
		and viewModel._destroyed ~= true
		and typeof(viewModel.Model) == "Instance"
		and typeof(viewModel.ItemModel) == "Instance"
end

local ogvi = ilib.GetViewModelImageFromWeaponData
ilib.GetViewModelImageFromWeaponData = function(self, wdata, hires)
	if not wdata then return ogvi(self, wdata, hires) end
	local wname = wdata.Name
	local weq = equip[wname]
	if weq and weq.Skin then
		local skinViewModelName = weq.Skin.ViewModelName or weq.Skin.Name
		local skinSourceName = weq.Skin.SourceViewModelName or skinViewModelName
		local sinfo = self.ViewModels[skinViewModelName] or self.ViewModels[skinSourceName]
		if sinfo then return sinfo[hires and "ImageHighResolution" or "Image"] or sinfo.Image end
		return weq.Skin[hires and "ImageHighResolution" or "Image"] or weq.Skin.Image or ""
	end
	return ogvi(self, wdata, hires)
end

pcall(function()
	local vpmod = require(lps.Modules.Pages.ViewProfile)
	if vpmod and vpmod.Fetch then
		local ofetch = vpmod.Fetch
		vpmod.Fetch = function(self, tplr)
			vprof = tplr
			return ofetch(self, tplr)
		end
	end
end)

local cent
pcall(function() cent = require(lps.Modules.ClientReplicatedClasses.ClientEntity) end)

if cent and cent._PlayFinisher then
	local ofin = cent._PlayFinisher
	cent._PlayFinisher = function(self, fname, ...)
		local ewep = getewep()
		local tfin = ewep and (fcache[ewep] or (equip[ewep] and equip[ewep].Finisher and equip[ewep].Finisher.Name))
		return ofin(self, tfin or fname, ...)
	end
end

rebuildinv()

for wname, wdata in equip do
	if wdata.Finisher and wdata.Finisher.Name then
		fcache[wname] = wdata.Finisher.Name
	end
end

local cosmeticGuiState = {
	Wanted = false,
	Gui = nil,
	WeaponSearch = "",
	CosmeticSearch = "",
	Mode = "Skin",
	SelectedWeapon = nil,
	SelectedCosmetic = nil,
	Weapons = {},
	Cosmetics = {},
	Columns = 4,
	TileW = 115,
	TileH = 100
}

local function displayName(name, data)
	return tostring((data and (data.DisplayName or data.Name)) or name or "")
end

local function iconFrom(data, fallback, name)
	if not data then return fallback or "" end
	local cosmeticImage = name and consts and consts.COSMETIC_IMAGES and consts.COSMETIC_IMAGES[name]
	local typeInfo = data.Type and clib.Types and clib.Types[data.Type]
	return cosmeticImage
		or data.ImageHighResolution
		or data.Image
		or data.Icon
		or data.Texture
		or fallback
		or (typeInfo and typeInfo.Image)
		or ""
end

local function sortByName(list)
	table.sort(list, function(a, b)
		return tostring(a.Name):lower() < tostring(b.Name):lower()
	end)
	return list
end

local function cosmeticMatchesWeapon(data, weapon)
	if not data then return false end
	local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
	if itemName then
		return tostring(itemName):lower() == tostring(weapon or ""):lower()
	end
	return data.Type ~= "Skin"
end

local function rebuildCosmeticLists()
	table.clear(cosmeticGuiState.Weapons)
	table.clear(cosmeticGuiState.Cosmetics)

	for name, data in pairs(coss) do
		if not banned(name) and data.Type == "Weapon" then
			local dispName = displayName(name, data)
			local dispImg = iconFrom(data, ilib.Items and ilib.Items[name] and ilib.Items[name].Image, name)
			if equip[name] and equip[name].Skin then
				local skinData = equip[name].Skin
				dispName = displayName(skinData.Name, skinData)
				dispImg = iconFrom(skinData, nil, skinData.Name)
			end
			table.insert(cosmeticGuiState.Weapons, {
				Name = name,
				Display = dispName,
				Image = dispImg,
				Data = data
			})
		end
	end

	if #cosmeticGuiState.Weapons == 0 and ilib.ItemsAlphabetized then
		for _, name in ipairs(ilib.ItemsAlphabetized) do
			local data = ilib.Items and ilib.Items[name]
			if data and not banned(name) then
				local dispName = displayName(name, data)
				local dispImg = iconFrom(data, nil, name)
				if equip[name] and equip[name].Skin then
					local skinData = equip[name].Skin
					dispName = displayName(skinData.Name, skinData)
					dispImg = iconFrom(skinData, nil, skinData.Name)
				end
				table.insert(cosmeticGuiState.Weapons, {
					Name = name,
					Display = dispName,
					Image = dispImg,
					Data = data
				})
			end
		end
	end

	sortByName(cosmeticGuiState.Weapons)
	if not cosmeticGuiState.SelectedWeapon and cosmeticGuiState.Weapons[1] then
		cosmeticGuiState.SelectedWeapon = cosmeticGuiState.Weapons[1].Name
	end

	local mode = cosmeticGuiState.Mode
	for name, data in pairs(coss) do
		if not banned(name) and data.Type == mode and cosmeticMatchesWeapon(data, cosmeticGuiState.SelectedWeapon) then
			table.insert(cosmeticGuiState.Cosmetics, {
				Name = name,
				Display = displayName(name, data),
				Image = iconFrom(data, nil, name),
				Data = data
			})
		end
	end

	sortByName(cosmeticGuiState.Cosmetics)
end

local function forceCosmeticUpdate(weapon, ctype)
	task.spawn(function()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")

		local selected = equip[weapon] and equip[weapon][ctype]
		local fighter = fctrl and fctrl:GetFighter(lp)
		if not fighter then return end
		local item
		for _, fighterItem in fighter.Items or {} do
			if fighterItem.Name == weapon then
				item = fighterItem
				break
			end
		end
		if not item then return end
		local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true

		local function refreshHotbar()
			local hotbar = fighter.FighterInterface and fighter.FighterInterface.Hotbar
			for _, hotbarSlot in pairs(hotbar and hotbar._hotbar_slots or {}) do
				if hotbarSlot.ClientItem == item then
					if hotbarSlot._Setup then
						pcall(hotbarSlot._Setup, hotbarSlot)
					end
					if hotbarSlot.UpdateVisuals then
						pcall(hotbarSlot.UpdateVisuals, hotbarSlot)
					end
					break
				end
			end
		end

		pcall(function()
			if item.Set then item:Set(ctype, selected) end
		end)
		pcall(function()
			if item.Data then item.Data[ctype] = selected end
		end)

		local rebuilt = false
		local oldViewModel = item.ViewModel
		if oldViewModel and oldViewModel._serial and replicatedClass and clientViewModelClass then
			local serial = table.clone(oldViewModel._serial)
			local dataKey = replicatedClass:ToEnum("Data")
			local data = table.clone(serial.Data or serial[dataKey] or {})
			serial[dataKey] = data
			serial.Data = nil

			local cosmetics = equip[weapon] or {}
			for _, cosmeticType in ipairs({"Skin", "Wrap", "Charm"}) do
				local cosmetic = cosmetics[cosmeticType]
				data[replicatedClass:ToEnum(cosmeticType)] = cosmetic
				data[cosmeticType] = nil
				if oldViewModel.Data then
					oldViewModel.Data[cosmeticType] = cosmetic
				end
			end
			local resolvedName = resolveViewModelName(weapon, cosmetics)
			data[replicatedClass:ToEnum("Name")] = resolvedName
			data.Name = nil

			local className = resolveViewModelClassName(weapon, cosmetics, resolvedName)
			local targetClass = resolveViewModelClass(className) or clientViewModelClass
			local identity = getthreadidentity and getthreadidentity() or 8
			constructingVirtualViewModelClass = targetClass ~= clientViewModelClass
			local ok, newViewModel = pcall(function()
				if setthreadidentity then pcall(setthreadidentity, 2) end
				return targetClass.new(serial, item)
			end)
			constructingVirtualViewModelClass = false
			if setthreadidentity then pcall(setthreadidentity, identity) end

			if (not ok or not isValidViewModel(newViewModel)) and resolvedName ~= weapon then
				if newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
					pcall(newViewModel.Destroy, newViewModel)
				end
				data[replicatedClass:ToEnum("Name")] = weapon
				data.Name = nil
				ok, newViewModel = pcall(function()
					if setthreadidentity then pcall(setthreadidentity, 2) end
					return (clientViewModelBaseNew or clientViewModelClass.new)(serial, item)
				end)
				if setthreadidentity then pcall(setthreadidentity, identity) end
			end

			if ok and isValidViewModel(newViewModel) then
				if wasEquipped and oldViewModel.Unequip then
					pcall(oldViewModel.Unequip, oldViewModel)
				end
				item.ViewModel = newViewModel
				if wasEquipped and newViewModel.Equip then
					pcall(newViewModel.Equip, newViewModel, true)
				end
				if oldViewModel ~= newViewModel and oldViewModel.Destroy then
					pcall(oldViewModel.Destroy, oldViewModel)
				end
				refreshHotbar()
				rebuilt = true
			elseif newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
				pcall(newViewModel.Destroy, newViewModel)
			end
		end

		local vm = item.ViewModel
		for _, obj in ipairs({item, vm}) do
			if obj then
				for _, method in ipairs({
					"_UpdateWrap",
					"UpdateWrap",
					"_UpdateCharm",
					"UpdateCharm",
					"_UpdateCosmetics",
					"UpdateCosmetics",
					"_RefreshViewModel",
					"RefreshViewModel",
					"UpdateViewModel"
				}) do
					if obj[method] then
						pcall(obj[method], obj)
					end
				end
			end
		end

		task.wait(0.1)
		saferep("WeaponInventory")
		refreshHotbar()
	end)
end

local function applyCosmeticToWeapon(weapon, cosmeticName, ctype, skipRebuild)
	if not weapon or weapon == "" then return end
	ctype = ctype or cosmeticGuiState.Mode
	equip[weapon] = equip[weapon] or {}

	if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
		equip[weapon][ctype] = nil
	else
		if cosmeticName == "__random" then
			local pool = cosmeticGuiState.Cosmetics
			local pick = pool[math.random(1, math.max(1, #pool))]
			cosmeticName = pick and pick.Name or nil
		end
		local cloned = cosmeticName and clonecos(cosmeticName, ctype)
		if cloned then
			equip[weapon][ctype] = cloned
			if ctype == "Finisher" then
				fcache[weapon] = cloned.Name
			end
		end
	end

	if equip[weapon] and not next(equip[weapon]) then
		equip[weapon] = nil
	end
	if not skipRebuild then
		rebuildinv()
		task.defer(function()
			saferep("CosmeticInventory")
			saferep("WeaponInventory")
			forceCosmeticUpdate(weapon, ctype)
		end)
	end
	-- always persist names to disk
	pcall(nemesisPersistSkins)
end
getgenv().NemesisApplyCosmetic = applyCosmeticToWeapon
getgenv().NemesisRebuildInv = rebuildinv
getgenv().NemesisSafeRep = saferep
getgenv().NemesisForceCosmeticUpdate = forceCosmeticUpdate

local function makeCosmeticChanger()
	if cosmeticGuiState.Gui then return cosmeticGuiState.Gui end
	rebuildCosmeticLists()

	local gui = Instance.new("Frame")
	gui.Name = "LionCosmeticChanger"
	gui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	gui.BorderColor3 = Color3.fromRGB(45, 45, 45)
	gui.BorderSizePixel = 1
	local UIS = game:GetService("UserInputService")
	local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
	-- compact: mobile small, PC normal (not huge)
	local gw = isMobile and 320 or 540
	local gh = isMobile and 400 or 460
	cosmeticGuiState.Columns = isMobile and 3 or 4
	cosmeticGuiState.TileW = isMobile and 95 or 115
	cosmeticGuiState.TileH = isMobile and 88 or 100
	gui.AnchorPoint = Vector2.new(0.5, 0.5)
	gui.Position = UDim2.fromScale(0.5, 0.5)
	gui.Size = UDim2.fromOffset(gw, gh)
	gui.Visible = cosmeticGuiState.Wanted == true
	gui.ZIndex = 900
	gui.Active = true
	gui.Parent = mainapi.MainScreenGui
	cosmeticGuiState.Gui = gui

	makeDraggable(gui, nil)

	local title = Instance.new("TextLabel")
	title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	title.BorderSizePixel = 0
	title.Font = Enum.Font.Code
	title.Text = "Skin Changer  (drag me)"
	title.TextColor3 = Color3.fromRGB(235, 235, 235)
	title.TextSize = isMobile and 14 or 15
	title.Size = UDim2.new(1, 0, 0, 28)
	title.ZIndex = 901
	title.Parent = gui

	local body = Instance.new("Frame")
	body.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	body.BorderColor3 = Color3.fromRGB(38, 38, 38)
	body.Position = UDim2.fromOffset(8, 32)
	body.Size = UDim2.new(1, -16, 1, -40)
	body.ZIndex = 901
	body.Parent = gui

	local function mkText(parent, text, pos, size, fontSize)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.Text = text
		label.TextColor3 = Color3.fromRGB(235, 235, 235)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextSize = fontSize or 14
		label.Position = pos
		label.Size = size
		label.ZIndex = 902
		label.Parent = parent
		return label
	end

	local function mkBox(parent, placeholder, pos, size)
		local box = Instance.new("TextBox")
		box.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
		box.BorderColor3 = Color3.fromRGB(42, 42, 42)
		box.ClearTextOnFocus = false
		box.Font = Enum.Font.Code
		box.PlaceholderText = placeholder
		box.PlaceholderColor3 = Color3.fromRGB(155, 155, 155)
		box.Text = ""
		box.TextColor3 = Color3.fromRGB(220, 220, 220)
		box.TextSize = 14
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Position = pos
		box.Size = size
		box.ZIndex = 902
		box.Parent = parent
		return box
	end

	local function mkButton(parent, text, pos, size)
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
		btn.Font = Enum.Font.Code
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(235, 235, 235)
		btn.TextSize = 14
		btn.Position = pos
		btn.Size = size
		btn.ZIndex = 902
		btn.Parent = parent
		return btn
	end

	-- Weapons on top (scroll if many, all listed), cosmetics below
	local weaponGridH = isMobile and 150 or 170
	local weaponGrid = Instance.new("ScrollingFrame")
	weaponGrid.Name = "WeaponGrid"
	weaponGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	weaponGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
	weaponGrid.CanvasSize = UDim2.new()
	weaponGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
	weaponGrid.ScrollBarThickness = 5
	weaponGrid.ScrollingDirection = Enum.ScrollingDirection.Y
	weaponGrid.Position = UDim2.fromOffset(8, 44)
	weaponGrid.Size = UDim2.new(1, -16, 0, weaponGridH)
	weaponGrid.ZIndex = 902
	weaponGrid.Parent = body

	local cosmeticGrid = Instance.new("ScrollingFrame")
	cosmeticGrid.Name = "CosmeticGrid"
	cosmeticGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	cosmeticGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
	cosmeticGrid.CanvasSize = UDim2.new()
	cosmeticGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
	cosmeticGrid.ScrollBarThickness = 5
	cosmeticGrid.ScrollingDirection = Enum.ScrollingDirection.Y
	cosmeticGrid.Position = UDim2.new(0, 8, 0, 44 + weaponGridH + 36)
	cosmeticGrid.Size = UDim2.new(1, -16, 1, -(44 + weaponGridH + 44))
	cosmeticGrid.ZIndex = 902
	cosmeticGrid.Parent = body

	mkText(body, "weapons", UDim2.fromOffset(8, 4), UDim2.new(0.5, -10, 0, 16), 12)
	local weaponSearch = mkBox(body, "search weapons...", UDim2.fromOffset(8, 20), UDim2.new(1, -16, 0, 22))
	-- cosmetic filter sits just under weapon grid
	local cosFilterY = 44 + weaponGridH + 4
	mkText(body, "cosmetics", UDim2.fromOffset(8, cosFilterY), UDim2.new(0.5, -10, 0, 16), 12)
	local cosmeticSearch = mkBox(body, "search skins/wraps...", UDim2.fromOffset(8, cosFilterY + 16), UDim2.new(1, -16, 0, 22))
	-- fix cosmetic grid Y to sit under search
	cosmeticGrid.Position = UDim2.new(0, 8, 0, cosFilterY + 40)
	cosmeticGrid.Size = UDim2.new(1, -16, 1, -(cosFilterY + 40 + 34))

	-- mode + actions on bottom bar (always visible)
	local modeButton = mkButton(body, "mode: skin  >", UDim2.new(0, 8, 1, -30), UDim2.new(0.42, -10, 0, 26))
	local modeMenu = Instance.new("Frame")
	modeMenu.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	modeMenu.BorderColor3 = Color3.fromRGB(45, 45, 45)
	modeMenu.Position = UDim2.new(0, 8, 1, -138)
	modeMenu.Size = UDim2.new(0.42, -10, 0, 104)
	modeMenu.Visible = false
	modeMenu.ZIndex = 910
	modeMenu.Parent = body

	local modes = {"Skin", "Wrap", "Charm", "Finisher"}
	for i, mode in ipairs(modes) do
		local row = mkButton(modeMenu, mode:lower(), UDim2.fromOffset(0, (i - 1) * 26), UDim2.new(1, 0, 0, 26))
		row.ZIndex = 911
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.MouseButton1Click:Connect(function()
			cosmeticGuiState.Mode = mode
			if cosmeticGuiState.SelectedWeapon then
				local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
				if currentEquip and currentEquip[mode] then
					cosmeticGuiState.SelectedCosmetic = currentEquip[mode].Name
				else
					cosmeticGuiState.SelectedCosmetic = nil
				end
			else
				cosmeticGuiState.SelectedCosmetic = nil
			end
			modeButton.Text = "mode: " .. mode:lower() .. "  >"
			modeMenu.Visible = false
			rebuildCosmeticLists()
			task.defer(function()
				if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
			end)
		end)
	end

	local applyAll = mkButton(body, "apply all", UDim2.new(0.42, 0, 1, -30), UDim2.new(0.28, -6, 0, 26))
	local reset = mkButton(body, "reset", UDim2.new(0.70, -4, 1, -30), UDim2.new(0.15, -4, 0, 26))
	local close = mkButton(body, "close", UDim2.new(0.85, -4, 1, -30), UDim2.new(0.15, -4, 0, 26))

	local function passes(entry, query)
		query = tostring(query or ""):lower()
		return query == "" or entry.Name:lower():find(query, 1, true) or entry.Display:lower():find(query, 1, true)
	end

	local function clearChildren(frame)
		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("GuiObject") then child:Destroy() end
		end
	end

	local function makeWrapPreview(parent, entry)
		local data = entry and entry.Data
		local groups = data and data.WrapGroups
		if not groups then return false end

		local viewport = Instance.new("ViewportFrame")
		viewport.BackgroundTransparency = 1
		viewport.Position = UDim2.fromOffset(2, 1)
		viewport.Size = UDim2.fromOffset(126, 90)
		viewport.LightColor = Color3.fromRGB(255, 255, 255)
		viewport.Ambient = Color3.fromRGB(180, 180, 180)
		viewport.ZIndex = 904
		viewport.Parent = parent

		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new(0, 0.15, 0.75) * CFrame.Angles(math.rad(-8), 0, 0)
		camera.Parent = viewport
		viewport.CurrentCamera = camera

		local model
		if wrapPreviewAsset then
			local ok, cloned = pcall(function()
				return wrapPreviewAsset:Clone()
			end)
			if ok and cloned then
				model = cloned
				model.Parent = viewport
			end
		end

		if model then
			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Anchored = true
					obj.CanCollide = false
				end
			end
			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("BasePart") then
					local wrapGroup = obj:GetAttribute("WrapGroup")
					local group = groups[wrapGroup] or groups[1] or {}
					if typeof(group.Color) == "Color3" then obj.Color = group.Color end
					if group.Transparency ~= nil then obj.Transparency = group.Transparency end
					if group.Reflectance ~= nil then obj.Reflectance = group.Reflectance end
					if group.Material then obj.Material = group.Material end
					pcall(function()
						obj.MaterialVariant = group.MaterialVariant or ""
					end)
					if obj:IsA("MeshPart") then
						pcall(function()
							obj.TextureID = ""
						end)
					end
					if group.Textures and wrapTextureAssets then
						local folder = wrapTextureAssets:FindFirstChild(group.Textures)
						if folder then
							for _, texture in ipairs(folder:GetChildren()) do
								pcall(function()
									local clonedTexture = texture:Clone()
									if clonedTexture.LocalTransparencyModifier ~= nil then
										clonedTexture.LocalTransparencyModifier = obj.LocalTransparencyModifier
									end
									clonedTexture.Parent = obj
								end)
							end
						end
					end
				end
			end
			pcall(function()
				model:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-10), math.rad(24), math.rad(-8)))
				local _, size = model:GetBoundingBox()
				local scale = math.max(size.X, size.Y, size.Z)
				camera.CFrame = CFrame.new(0, 0.05, math.clamp(scale * 0.41, 0.43, 1.15)) * CFrame.Angles(math.rad(-7), 0, 0)
			end)
			return true
		end

		model = Instance.new("Model")
		model.Name = "WrapPreview"
		model.Parent = viewport

		local sliceCount = math.max(1, math.min(3, #groups))
		for i = 1, sliceCount do
			local group = groups[i]
			local color = group and group.Color or Color3.fromRGB(150, 150, 150)
			if typeof(color) ~= "Color3" then color = Color3.fromRGB(150, 150, 150) end
			local slice = Instance.new("Part")
			slice.Anchored = true
			slice.CanCollide = false
			slice.Material = (group and group.Material) or Enum.Material.SmoothPlastic
			slice.Color = color
			slice.Transparency = group and group.Transparency or 0
			slice.Reflectance = group and group.Reflectance or 0
			slice.Size = Vector3.new(1.8 / sliceCount, 1.55, 0.22)
			slice.CFrame = CFrame.new((i - (sliceCount + 1) / 2) * (1.8 / sliceCount), 0, 0) * CFrame.Angles(0, math.rad(-18), math.rad(-8))
			slice.Parent = model
		end

		return true
	end

	local function makeCharmPreview(parent, entry)
		if not entry or not entry.Data or entry.Data.Type ~= "Charm" then return false end
		if charmAssets then
			local source = charmAssets:FindFirstChild(entry.Name)
			if source then
				local ok = pcall(function()
					local viewport = Instance.new("ViewportFrame")
					viewport.BackgroundTransparency = 1
					viewport.Position = UDim2.fromOffset(2, 1)
					viewport.Size = UDim2.fromOffset(126, 90)
					viewport.LightColor = Color3.fromRGB(255, 255, 255)
					viewport.Ambient = Color3.fromRGB(190, 190, 190)
					viewport.ZIndex = 904
					viewport.Parent = parent

					local camera = Instance.new("Camera")
					camera.CFrame = CFrame.new(0, 0, 0.2)
					camera.Parent = viewport
					viewport.CurrentCamera = camera

					local clone = source:Clone()
					clone.Parent = viewport
					local hook = clone:FindFirstChild("Hook", true)
					if hook then hook:Destroy() end

					if clone:IsA("Model") then
						local primary = clone.PrimaryPart or clone:FindFirstChild("Primary") or clone:FindFirstChildWhichIsA("BasePart", true)
						if primary then clone.PrimaryPart = primary end
						clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-12), math.rad(35), 0))
						local _, size = clone:GetBoundingBox()
						local scale = math.max(size.X, size.Y, size.Z)
						if scale > 0 then
							camera.CFrame = CFrame.new(0, 0, math.clamp(scale * 0.107, 0.113, 0.333))
						end
					elseif clone:IsA("BasePart") then
						clone.Anchored = true
						clone.CFrame = CFrame.new()
					end
				end)
				if ok then return true end
			end
		end

		local hash = 0
		for i = 1, #entry.Name do
			hash = (hash + string.byte(entry.Name, i) * i) % 255
		end
		local color = Color3.fromHSV(hash / 255, 0.65, 1)

		local badge = Instance.new("Frame")
		badge.BackgroundColor3 = color
		badge.BorderColor3 = Color3.fromRGB(235, 235, 235)
		badge.Position = UDim2.fromOffset(30, 8)
		badge.Size = UDim2.fromOffset(70, 70)
		badge.Rotation = 45
		badge.ZIndex = 904
		badge.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = badge

		local text = Instance.new("TextLabel")
		text.BackgroundTransparency = 1
		text.Font = Enum.Font.SourceSansBold
		text.Text = string.sub(entry.Display or entry.Name or "C", 1, 1):upper()
		text.TextColor3 = Color3.fromRGB(255, 255, 255)
		text.TextScaled = true
		text.Rotation = -45
		text.Position = UDim2.fromOffset(10, 10)
		text.Size = UDim2.fromOffset(50, 50)
		text.ZIndex = 905
		text.Parent = badge
		return true
	end

	local function makeTile(parent, entry, index, selected, callback, rightCallback, largeWeaponPreview)
		local col = (index - 1) % cosmeticGuiState.Columns
		local row = math.floor((index - 1) / cosmeticGuiState.Columns)
		local tile = Instance.new("TextButton")
		tile.AutoButtonColor = false
		tile.BackgroundColor3 = selected and Color3.fromRGB(28, 44, 35) or Color3.fromRGB(20, 20, 20)
		tile.BorderColor3 = selected and Color3.fromRGB(70, 140, 95) or Color3.fromRGB(28, 28, 28)
		tile.Position = UDim2.fromOffset(col * cosmeticGuiState.TileW, row * cosmeticGuiState.TileH)
		tile.Size = UDim2.fromOffset(cosmeticGuiState.TileW, cosmeticGuiState.TileH)
		tile.ClipsDescendants = true
		tile.Text = ""
		tile.ZIndex = 903
		tile.Parent = parent

		local hasCustomPreview = false
		if not hasCustomPreview and (entry.Image == nil or entry.Image == "") and entry.Data and entry.Data.Type == "Wrap" then
			hasCustomPreview = makeWrapPreview(tile, entry)
		end
		if not hasCustomPreview and (entry.Image == nil or entry.Image == "") and entry.Data and entry.Data.Type == "Charm" then
			hasCustomPreview = makeCharmPreview(tile, entry)
		end
		if not hasCustomPreview then
			local img = Instance.new("ImageLabel")
			img.BackgroundTransparency = 1
			img.Image = entry.Image or ""
			img.ScaleType = Enum.ScaleType.Fit
			img.Position = largeWeaponPreview and UDim2.fromOffset(-61, -43) or UDim2.fromOffset(14, 9)
			img.Size = largeWeaponPreview and UDim2.fromOffset(252, 176) or UDim2.fromOffset(102, 76)
			img.ZIndex = 904
			img.Parent = tile
		end

		local name = Instance.new("TextLabel")
		name.BackgroundTransparency = 1
		name.Font = Enum.Font.SourceSansBold
		name.Text = entry.Display
		name.TextColor3 = Color3.fromRGB(245, 245, 245)
		name.TextScaled = true
		name.TextWrapped = true
		name.Position = UDim2.fromOffset(6, 86)
		name.Size = UDim2.fromOffset(118, 32)
		name.ZIndex = 904
		name.Parent = tile

		tile.MouseButton1Click:Connect(function()
			callback(entry)
		end)
		tile.MouseButton2Click:Connect(function()
			if rightCallback then rightCallback(entry) end
		end)
	end

	local function refresh()
		clearChildren(weaponGrid)
		clearChildren(cosmeticGrid)
		local wcount = 0
		for _, entry in ipairs(cosmeticGuiState.Weapons) do
			if passes(entry, cosmeticGuiState.WeaponSearch) then
				wcount += 1
				makeTile(weaponGrid, entry, wcount, cosmeticGuiState.SelectedWeapon == entry.Name, function(chosen)
					cosmeticGuiState.SelectedWeapon = chosen.Name
					local currentEquip = equip[chosen.Name]
					if currentEquip and currentEquip[cosmeticGuiState.Mode] then
						cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
					else
						cosmeticGuiState.SelectedCosmetic = nil
					end
					rebuildCosmeticLists()
					refresh()
				end, function(chosen)
					cosmeticGuiState.SelectedWeapon = chosen.Name
					applyCosmeticToWeapon(chosen.Name, cosmeticGuiState.SelectedCosmetic, cosmeticGuiState.Mode)
					rebuildCosmeticLists()
					refresh()
				end, true)
			end
		end
		weaponGrid.CanvasSize = UDim2.fromOffset(0, math.max(264, math.ceil(wcount / cosmeticGuiState.Columns) * cosmeticGuiState.TileH))

		local randomEntry = {Name = "__random", Display = "Random", Image = "rbxassetid://132973552546079"}
		makeTile(cosmeticGrid, randomEntry, 1, cosmeticGuiState.SelectedCosmetic == "__random", function()
			cosmeticGuiState.SelectedCosmetic = "__random"
			if cosmeticGuiState.SelectedWeapon then applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, "__random", cosmeticGuiState.Mode) end
			rebuildCosmeticLists()
			refresh()
		end)

		local ccount = 1
		for _, entry in ipairs(cosmeticGuiState.Cosmetics) do
			if passes(entry, cosmeticGuiState.CosmeticSearch) then
				ccount += 1
				makeTile(cosmeticGrid, entry, ccount, cosmeticGuiState.SelectedCosmetic == entry.Name, function(chosen)
					cosmeticGuiState.SelectedCosmetic = chosen.Name
					if cosmeticGuiState.SelectedWeapon then applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, chosen.Name, cosmeticGuiState.Mode) end
					rebuildCosmeticLists()
					refresh()
				end, nil, cosmeticGuiState.Mode == "Skin")
			end
		end
		cosmeticGrid.CanvasSize = UDim2.fromOffset(0, math.max(276, math.ceil(ccount / cosmeticGuiState.Columns) * cosmeticGuiState.TileH))
	end

	cosmeticGuiState.Refresh = refresh

	local wSearchThread, cSearchThread
	weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.WeaponSearch = weaponSearch.Text
		if wSearchThread then task.cancel(wSearchThread) end
		wSearchThread = task.delay(0.1, refresh)
	end)
	cosmeticSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.CosmeticSearch = cosmeticSearch.Text
		if cSearchThread then task.cancel(cSearchThread) end
		cSearchThread = task.delay(0.1, refresh)
	end)
	modeButton.MouseButton1Click:Connect(function()
		modeMenu.Visible = not modeMenu.Visible
	end)
	applyAll.MouseButton1Click:Connect(function()
		local selected = cosmeticGuiState.SelectedCosmetic
		if not selected then return end
		for _, weapon in ipairs(cosmeticGuiState.Weapons) do
			applyCosmeticToWeapon(weapon.Name, selected, cosmeticGuiState.Mode, true)
			task.defer(forceCosmeticUpdate, weapon.Name, cosmeticGuiState.Mode)
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
		pcall(nemesisPersistSkins)
	end)
	reset.MouseButton1Click:Connect(function()
		table.clear(equip)
		table.clear(fcache)
		rebuildinv()
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
		pcall(nemesisPersistSkins)
	end)
	close.MouseButton1Click:Connect(function()
		cosmeticGuiState.Wanted = false
		if shared.LionCosmeticChangerToggle and shared.LionCosmeticChangerToggle.Toggle then
			shared.LionCosmeticChangerToggle:Toggle(false)
		else
			gui.Visible = false
		end
	end)

	local nextCosmeticGuiUpdate = 0
	mainapi:Clean(RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now < nextCosmeticGuiUpdate then return end
		nextCosmeticGuiUpdate = now + 0.1
		local menuOpen = true -- always allow when Wanted
-- no LionWindow check
		gui.Visible = cosmeticGuiState.Wanted and menuOpen
	end))

	refresh()
	return gui
end

shared.LionCosmeticChanger = {
	SetVisible = function(visible)
		cosmeticGuiState.Wanted = visible == true
		local g = makeCosmeticChanger()
		if g then
			g.Visible = visible == true
		end
		if visible then
			pcall(rebuildCosmeticLists)
			if cosmeticGuiState.Refresh then pcall(cosmeticGuiState.Refresh) end
		end
	end,
	Toggle = function()
		cosmeticGuiState.Wanted = not cosmeticGuiState.Wanted
		makeCosmeticChanger()
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	Refresh = function()
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	GetEquipData = function()
		local export = {}
		for w, cats in pairs(equip) do
			export[w] = {}
			for cat, data in pairs(cats) do
				export[w][cat] = data and data.Name or nil
			end
		end
		return export
	end,
	LoadEquipData = function(data)
		if type(data) ~= "table" then return end
		for w, cats in pairs(data) do
			if type(cats) == "table" then
				for cat, name in pairs(cats) do
					applyCosmeticToWeapon(w, name, cat, true)
					task.defer(function()
						pcall(forceCosmeticUpdate, w, cat)
					end)
				end
			end
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		if cosmeticGuiState.SelectedWeapon then
			local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
			if currentEquip and currentEquip[cosmeticGuiState.Mode] then
				cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
			else
				cosmeticGuiState.SelectedCosmetic = nil
			end
		end
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	Apply = applyCosmeticToWeapon,
	State = cosmeticGuiState
}



-- Register show helper ASAP
getgenv().NemesisShowNationSkins = function(v)
	v = v == true
	if shared.LionCosmeticChanger and shared.LionCosmeticChanger.SetVisible then
		shared.LionCosmeticChanger.SetVisible(v)
		return
	end
	-- last resort: find gui
	pcall(function()
		local host = game:GetService("CoreGui"):FindFirstChild("NemesisNationSkins")
		if host then
			for _, c in ipairs(host:GetChildren()) do
				if c:IsA("Frame") then c.Visible = v end
			end
		end
	end)
end
pcall(function()
	-- prebuild once so first toggle is instant
	if shared.LionCosmeticChanger and shared.LionCosmeticChanger.SetVisible then
		-- leave hidden until user toggles
	end
end)

end)
end


local RageHudLabel
local HudEnabled = false
local lastNotify = 0
local function setRageHud(msg)
	if not (getgenv().Config and getgenv().Config.Enabled) then return end
	local text = (msg and msg ~= "") and msg or "ragebot: idle"
	if RageHudLabel then
		pcall(function()
			if type(RageHudLabel.SetText) == "function" then
				RageHudLabel:SetText(text)
			elseif RageHudLabel.Text then
				RageHudLabel.Text = text
			end
		end)
	end
	if HudEnabled and tick() - lastNotify > 1.5 then
		lastNotify = tick()
		local custom = getgenv().NotifyText
		if custom and custom ~= "" then
			pcall(function() Library:Notify(custom .. " @" .. (text:match("@(.+)$") or "")) end)
		end
	end
end

------------------------------------------------------------------------
-- Shared FOV + scanner (fixed for actual hits)
------------------------------------------------------------------------
local function createFOVRing(name)
	local LP = game:GetService("Players").LocalPlayer
	local parent = (LP and LP:FindFirstChild("PlayerGui")) or game:GetService("CoreGui")
	pcall(function()
		local old = parent:FindFirstChild(name)
		if old then old:Destroy() end
	end)
	local gui = Instance.new("ScreenGui")
	gui.Name = name
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 120
	gui.Parent = parent
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.AnchorPoint = Vector2.new(0.5, 0.5)
	fill.Position = UDim2.fromScale(0.5, 0.5)
	fill.Size = UDim2.fromOffset(200, 200)
	fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fill.BackgroundTransparency = 0.85
	fill.BorderSizePixel = 0
	fill.Visible = false
	fill.Parent = gui
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = fill
	return {
		Fill = fill,
		Stroke = stroke,
		Update = function(_, cfg)
			if not cfg.ShowFOV then fill.Visible = false return end
			local r = math.clamp(tonumber(cfg.Radius) or 150, 10, 800)
			fill.Size = UDim2.fromOffset(r * 2, r * 2)
			fill.Visible = true
			local t = 0
			if cfg.MovingRotation then
				t = ((cfg._rot or 0) + (cfg.Rotation or 0)) % 360 / 360
			else
				t = (cfg.Rotation or 0) % 360 / 360
			end
			local function lerp(a, b, u)
				return Color3.new(a.R+(b.R-a.R)*u, a.G+(b.G-a.G)*u, a.B+(b.B-a.B)*u)
			end
			local function g3(c1, c2, c3, u)
				if u < 0.5 then return lerp(c1, c2, u * 2) end
				return lerp(c2, c3, (u - 0.5) * 2)
			end
			if cfg.Fill then
				fill.BackgroundColor3 = g3(cfg.Fill1, cfg.Fill2, cfg.Fill3, t)
				fill.BackgroundTransparency = 0.75
			else
				fill.BackgroundTransparency = 1
			end
			stroke.Enabled = cfg.Outline ~= false
			if stroke.Enabled then
				stroke.Color = g3(cfg.Outline1, cfg.Outline2, cfg.Outline3, t)
			end
		end,
	}
end

local function makeTargetScanner(cfg)
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local LP = Players.LocalPlayer
	return function()
		local cam = Workspace.CurrentCamera
		if not cam then return nil end
		local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
		local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		local best, bestD = nil, math.huge
		local radius = tonumber(cfg.Radius) or 150

		local function isEnemyScan(plr)
			if not plr or plr == LP then return false end
			if not cfg.TeamCheck then return true end
			if plr.Team ~= nil and LP.Team ~= nil then
				return plr.Team ~= LP.Team
			end
			local pTeam = plr:GetAttribute("TeamID") or plr:GetAttribute("Team")
			local lTeam = LP:GetAttribute("TeamID") or LP:GetAttribute("Team")
			if pTeam ~= nil and lTeam ~= nil then
				return pTeam ~= lTeam
			end
			if plr.TeamColor and LP.TeamColor then
				return plr.TeamColor ~= LP.TeamColor
			end
			return true
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local teamSkip = not isEnemyScan(plr)
				if not teamSkip then
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						local part
						if cfg.ClosestPart then
							part = plr.Character:FindFirstChild("HumanoidRootPart")
								or plr.Character:FindFirstChild("Head")
						else
							local tn = cfg.TargetPart or "Head"
							part = plr.Character:FindFirstChild(tn)
								or plr.Character:FindFirstChild("Head")
								or plr.Character:FindFirstChild("HumanoidRootPart")
						end
						if part then
							local dist3d = myRoot and (myRoot.Position - part.Position).Magnitude or 0
							if not cfg.LimitDistance or dist3d <= (cfg.MaxDistance or 2000) then
								local pos, onScreen = cam:WorldToViewportPoint(part.Position)
								-- accept slightly off-screen if Z positive (helps hits)
								if pos.Z > 0 then
									local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
									if d <= radius and d < bestD then
										bestD, best = d, part
									end
								end
							end
						end
					end
				end
			end
		end
		return best
	end
end

local function fireAtPart(part)
	if not part or not part.Parent then return false end
	local ok = pcall(function()
		local LP = game:GetService("Players").LocalPlayer
		local repS = game:GetService("ReplicatedStorage")
		local util = require(repS.Modules.Utility)
		local enum = require(repS.Modules.EnumLibrary)
		local FC = require(LP.PlayerScripts.Controllers.FighterController)
		local item = FC.LocalFighter and FC.LocalFighter.EquippedItem
		if not item then return end
		local objectId = item:Get("ObjectID")
		if not objectId then return end
		local cam = workspace.CurrentCamera
		local origin = cam and cam.CFrame.Position or part.Position
		local aimCF = CFrame.lookAt(origin, part.Position)
		local cameradata = {
			[utf8.char(1)] = {
				[utf8.char(0)] = util:EncodeCFrame(aimCF),
				[utf8.char(1)] = util:EncodeCFrame(part.CFrame),
				[utf8.char(2)] = part,
				[utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position))),
			}
		}
		repS.Remotes.Replication.Fighter.UseItem:FireServer(
			objectId,
			enum:ToEnum("StartShooting"),
			cameradata,
			nil
		)
	end)
	return ok
end

local function addAimUI(box, prefix, cfg, ring, isAimbot)
	box:AddToggle(prefix .. "Enabled", {
		Text = "Enabled", Default = false,
		Callback = function(v)
			cfg.Enabled = v
			Library:Notify((isAimbot and "Aimbot" or "Silent Aim") .. (v and " ON" or " OFF"))
		end,
	})
	box:AddToggle(prefix .. "Manip", {
		Text = "Manipulation", Default = false,
		Callback = function(v) cfg.Manipulation = v end,
	})
	box:AddToggle(prefix .. "Closest", {
		Text = "Closest Part", Default = false,
		Callback = function(v) cfg.ClosestPart = v end,
	})
	box:AddToggle(prefix .. "Visualize", {
		Text = "Visualize", Default = false,
		Callback = function(v) cfg.Visualize = v end,
	})

	-- Show FOV: colors only appear under this toggle when enabled (Linoria nested pickers)
	local fovToggle = box:AddToggle(prefix .. "ShowFOV", {
		Text = "Show FOV", Default = false,
		Callback = function(v)
			cfg.ShowFOV = v
			ring:Update(cfg)
		end,
	})
	-- 3 FOV / outline / fill color pairs nested on the Show FOV toggle
	pcall(function()
		fovToggle:AddColorPicker(prefix .. "FOV1", {
			Default = Color3.fromRGB(255,255,255),
			Title = "FOV 1",
			Callback = function(c) cfg.Outline1 = c ring:Update(cfg) end,
		})
		fovToggle:AddColorPicker(prefix .. "FOV2", {
			Default = Color3.fromRGB(255,255,255),
			Title = "FOV 2",
			Callback = function(c) cfg.Outline2 = c ring:Update(cfg) end,
		})
		fovToggle:AddColorPicker(prefix .. "FOV3", {
			Default = Color3.fromRGB(255,255,255),
			Title = "FOV 3",
			Callback = function(c) cfg.Outline3 = c ring:Update(cfg) end,
		})
	end)

	box:AddToggle(prefix .. "Outline", {
		Text = "Outline", Default = true,
		Callback = function(v) cfg.Outline = v ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Out1", {
		Default = Color3.fromRGB(200,200,200), Title = "Outline 1",
		Callback = function(c) cfg.Outline1 = c ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Out2", {
		Default = Color3.fromRGB(180,180,180), Title = "Outline 2",
		Callback = function(c) cfg.Outline2 = c ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Out3", {
		Default = Color3.fromRGB(160,160,160), Title = "Outline 3",
		Callback = function(c) cfg.Outline3 = c ring:Update(cfg) end,
	})

	box:AddToggle(prefix .. "Fill", {
		Text = "Fill", Default = true,
		Callback = function(v) cfg.Fill = v ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Fill1", {
		Default = Color3.fromRGB(150,150,150), Title = "Fill 1",
		Callback = function(c) cfg.Fill1 = c ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Fill2", {
		Default = Color3.fromRGB(120,120,120), Title = "Fill 2",
		Callback = function(c) cfg.Fill2 = c ring:Update(cfg) end,
	}):AddColorPicker(prefix .. "Fill3", {
		Default = Color3.fromRGB(100,100,100), Title = "Fill 3",
		Callback = function(c) cfg.Fill3 = c ring:Update(cfg) end,
	})

	-- Hide outline/fill color rows until Show FOV is on
	local function setColorVisibility(visible)
		pcall(function()
			for _, id in ipairs({
				prefix .. "Out1", prefix .. "Out2", prefix .. "Out3",
				prefix .. "Fill1", prefix .. "Fill2", prefix .. "Fill3",
				prefix .. "FOV1", prefix .. "FOV2", prefix .. "FOV3",
			}) do
				local o = Options and Options[id]
				if o then
					if type(o.SetVisible) == "function" then
						o:SetVisible(visible)
					elseif o.Frame then
						o.Frame.Visible = visible
					end
				end
			end
			for _, id in ipairs({ prefix .. "Outline", prefix .. "Fill" }) do
				local t = Toggles and Toggles[id]
				if t then
					if type(t.SetVisible) == "function" then
						t:SetVisible(visible)
					elseif t.Frame then
						t.Frame.Visible = visible
					end
				end
			end
		end)
	end
	task.defer(function()
		setColorVisibility(false)
		if Toggles and Toggles[prefix .. "ShowFOV"] then
			Toggles[prefix .. "ShowFOV"]:OnChanged(function()
				setColorVisibility(Toggles[prefix .. "ShowFOV"].Value == true)
			end)
		end
	end)

	box:AddSlider(prefix .. "Lerp", {
		Text = "Lerp", Min = 0.05, Max = 1, Default = isAimbot and 0.4 or 1, Rounding = 2,
		Callback = function(v) cfg.Lerp = v end,
	})
	if isAimbot then
		box:AddSlider(prefix .. "Smooth", {
			Text = "Smoothing", Min = 0.05, Max = 1, Default = 0.4, Rounding = 2,
			Callback = function(v) cfg.Smoothing = v end,
		})
	end
	box:AddToggle(prefix .. "MoveRot", {
		Text = "Moving Rotation", Default = false,
		Callback = function(v) cfg.MovingRotation = v end,
	})
	box:AddSlider(prefix .. "Rot", {
		Text = "Rotation", Min = 0, Max = 360, Default = 0, Rounding = 0,
		Callback = function(v) cfg.Rotation = v end,
	})
	box:AddSlider(prefix .. "Speed", {
		Text = "Speed (rps)", Min = 0, Max = 10, Default = 1, Rounding = 1,
		Callback = function(v) cfg.Speed = v end,
	})
	box:AddSlider(prefix .. "Radius", {
		Text = "Radius", Min = 20, Max = 600, Default = 200, Rounding = 0,
		Callback = function(v) cfg.Radius = v ring:Update(cfg) end,
	})
	box:AddSlider(prefix .. "HitChance", {
		Text = "Hit Chance", Min = 1, Max = 100, Default = 100, Rounding = 0,
		Callback = function(v) cfg.HitChance = v end,
	})
end

------------------------------------------------------------------------
-- SILENT AIM + AIMBOT (two tabs, one box)
------------------------------------------------------------------------
local okAim, aimBox = pcall(function() return Tabs.Main:AddTabbox({ Side = 1 }) end)
_G.__AimBox = okAim and aimBox or nil
if not _G.__AimBox then
	_G.__AimBox = {
		AddTab = function(_, name)
			return Tabs.Main:AddLeftGroupbox(name)
		end,
	}
end
do
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	getgenv().SilentAim = {
		Enabled = false, Manipulation = false, ClosestPart = false, Visualize = false,
		ShowFOV = false, Outline = true, Fill = true, MovingRotation = false,
		Radius = 200, HitChance = 100, Lerp = 1, Rotation = 0, Speed = 1,
		VisibleOnly = false, LimitDistance = false, MaxDistance = 2000,
		TargetPart = "Head", TeamCheck = true,
		Outline1 = Color3.fromRGB(255,255,255), Outline2 = Color3.fromRGB(255,255,255), Outline3 = Color3.fromRGB(255,255,255),
		Fill1 = Color3.fromRGB(150,150,150), Fill2 = Color3.fromRGB(120,120,120), Fill3 = Color3.fromRGB(100,100,100),
		_rot = 0, Target = nil,
	}
	local SA = getgenv().SilentAim
	local saRing = createFOVRing("ArchSilentFOV")
	local scan = makeTargetScanner(SA)
	local vizLine = Drawing.new("Line")
	vizLine.Visible = false
	vizLine.Thickness = 1.5
	vizLine.Color = Color3.fromRGB(100, 160, 255)
	local cached = nil

	local SABox = _G.__AimBox and _G.__AimBox:AddTab("Silent Aim")
	addAimUI(SABox, "SA", SA, saRing, false)

	RunService.Heartbeat:Connect(function(dt)
		if SA.ShowFOV then
			if SA.MovingRotation then
				SA._rot = (SA._rot + (SA.Speed or 1) * dt * 360) % 360
			end
			saRing:Update(SA)
		else
			saRing.Fill.Visible = false
		end
		if SA.Enabled then
			cached = scan()
			SA.Target = cached
			if SA.Visualize and cached and cached.Parent then
				local cam = workspace.CurrentCamera
				local origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
				local pos, vis = cam:WorldToViewportPoint(cached.Position)
				vizLine.Visible = vis
				if vis then vizLine.From = origin vizLine.To = Vector2.new(pos.X, pos.Y) end
			else
				vizLine.Visible = false
			end
		else
			cached = nil
			SA.Target = nil
			vizLine.Visible = false
		end
	end)

	-- Method 1: hook UseItem (best — real shot redirected)
	task.defer(function()
		pcall(function()
			local repS = game:GetService("ReplicatedStorage")
			local remote = repS:WaitForChild("Remotes", 8)
				:WaitForChild("Replication", 8)
				:WaitForChild("Fighter", 8)
				:WaitForChild("UseItem", 8)
			if not remote then return end
			if hookmetamethod then
				local oldNamecall
				oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
					local method = getnamecallmethod and getnamecallmethod() or ""
					if SA.Enabled and not (getgenv().Config and getgenv().Config.Enabled) and self == remote and method == "FireServer" then
						local args = {...}
						if math.random(1, 100) <= (SA.HitChance or 100) then
							local part = cached or scan()
							if part and part.Parent then
								pcall(function()
									local util = require(repS.Modules.Utility)
									local cam = workspace.CurrentCamera
									local aimCF = CFrame.lookAt(cam.CFrame.Position, part.Position)
									args[3] = {
										[utf8.char(1)] = {
											[utf8.char(0)] = util:EncodeCFrame(aimCF),
											[utf8.char(1)] = util:EncodeCFrame(part.CFrame),
											[utf8.char(2)] = part,
											[utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position))),
										}
									}
								end)
							end
						end
						return oldNamecall(self, table.unpack(args))
					end
					return oldNamecall(self, ...)
				end))
			elseif hookfunction then
				local old
				old = hookfunction(remote.FireServer, newcclosure(function(self, ...)
					if self == remote and SA.Enabled and not (getgenv().Config and getgenv().Config.Enabled) then
						local args = {...}
						if math.random(1, 100) <= (SA.HitChance or 100) then
							local part = cached or scan()
							if part and part.Parent then
								pcall(function()
									local util = require(repS.Modules.Utility)
									local cam = workspace.CurrentCamera
									local aimCF = CFrame.lookAt(cam.CFrame.Position, part.Position)
									args[3] = {
										[utf8.char(1)] = {
											[utf8.char(0)] = util:EncodeCFrame(aimCF),
											[utf8.char(1)] = util:EncodeCFrame(part.CFrame),
											[utf8.char(2)] = part,
											[utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position))),
										}
									}
								end)
							end
						end
						return old(self, table.unpack(args))
					end
					return old(self, ...)
				end))
			end
		end)
	end)

	-- Method 2: also fire redirected shot on click (guarantees hits even if hook fails)
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp or not SA.Enabled then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.KeyCode ~= Enum.KeyCode.ButtonR2 then return end
		if math.random(1, 100) > (SA.HitChance or 100) then return end
		local part = cached or scan()
		if part then
			task.spawn(function() fireAtPart(part) end)
		end
	end)

	-- Manipulation: keep firing at target while holding
	local holding = false
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
			holding = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
			holding = false
		end
	end)
	local lastManip = 0
	RunService.Heartbeat:Connect(function()
		if not SA.Enabled or not SA.Manipulation or not holding then return end
		if tick() - lastManip < 0.07 then return end
		lastManip = tick()
		local part = cached or scan()
		if part then fireAtPart(part) end
	end)
end

------------------------------------------------------------------------
-- AIMBOT — camera lock (does not block your shots)
------------------------------------------------------------------------
do
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	getgenv().Aimbot = {
		Enabled = false, Manipulation = false, ClosestPart = false, Visualize = false,
		ShowFOV = false, Outline = true, Fill = true, MovingRotation = false,
		Radius = 200, HitChance = 100, Lerp = 0.4, Smoothing = 0.4,
		Rotation = 0, Speed = 1, Holding = false,
		LimitDistance = false, MaxDistance = 2000, TargetPart = "Head", TeamCheck = true,
		Outline1 = Color3.fromRGB(255,255,255), Outline2 = Color3.fromRGB(255,255,255), Outline3 = Color3.fromRGB(255,255,255),
		Fill1 = Color3.fromRGB(150,150,150), Fill2 = Color3.fromRGB(120,120,120), Fill3 = Color3.fromRGB(100,100,100),
		_rot = 0, Target = nil,
	}
	local AB = getgenv().Aimbot
	local abRing = createFOVRing("ArchAimbotFOV")
	local scan = makeTargetScanner(AB)
	local vizLine = Drawing.new("Line")
	vizLine.Visible = false
	vizLine.Thickness = 1.5
	vizLine.Color = Color3.fromRGB(100, 255, 140)
	local cached = nil

	local ABBox = _G.__AimBox:AddTab("Aimbot")
	addAimUI(ABBox, "AB", AB, abRing, true)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.MouseButton2
			or input.KeyCode == Enum.KeyCode.ButtonL2 then
			AB.Holding = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2
			or input.KeyCode == Enum.KeyCode.ButtonL2 then
			AB.Holding = false
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		if AB.ShowFOV then
			if AB.MovingRotation then
				AB._rot = (AB._rot + (AB.Speed or 1) * dt * 360) % 360
			end
			abRing:Update(AB)
		else
			abRing.Fill.Visible = false
		end

		if not AB.Enabled or (getgenv().Config and getgenv().Config.Enabled) or (not AB.Holding and not AB.Manipulation) then
			AB.Target = nil
			vizLine.Visible = false
			return
		end

		cached = scan()
		AB.Target = cached
		if not cached or not cached.Parent then
			vizLine.Visible = false
			return
		end

		local cam = workspace.CurrentCamera
		if not cam then return end
		local smooth = math.clamp(AB.Smoothing or AB.Lerp or 0.4, 0.05, 1)
		local goal = CFrame.lookAt(cam.CFrame.Position, cached.Position)
		cam.CFrame = cam.CFrame:Lerp(goal, smooth)

		if AB.Visualize then
			local origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
			local pos, vis = cam:WorldToViewportPoint(cached.Position)
			vizLine.Visible = vis
			if vis then vizLine.From = origin vizLine.To = Vector2.new(pos.X, pos.Y) end
		else
			vizLine.Visible = false
		end

		pcall(function()
			if mousemoverel then
				local pos, vis = cam:WorldToViewportPoint(cached.Position)
				if vis then
					local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
					local delta = Vector2.new(pos.X, pos.Y) - center
					mousemoverel(delta.X * smooth * 0.45, delta.Y * smooth * 0.45)
				end
			end
		end)
	end)
end

------------------------------------------------------------------------
-- TARGETING
------------------------------------------------------------------------
------------------------------------------------------------------------
-- TARGETING
------------------------------------------------------------------------
------------------------------------------------------------------------
-- TARGETING (shared — applies to Silent Aim + Aimbot)
------------------------------------------------------------------------
do
	local TBox = Tabs.Main:AddLeftGroupbox("Targeting")
	-- Bind to both configs when changed
	local function both(key, val)
		if getgenv().SilentAim then getgenv().SilentAim[key] = val end
		if getgenv().Aimbot then getgenv().Aimbot[key] = val end
	end
	TBox:AddToggle("TVisible", {
		Text = "Visible Only", Default = false,
		Callback = function(v) both("VisibleOnly", v) end,
	})
	TBox:AddToggle("TIgnoreProt", {
		Text = "Ignore Protected", Default = false,
		Callback = function(v) both("IgnoreProtected", v) end,
	})
	TBox:AddToggle("TDisableFlash", {
		Text = "Disable On Flash", Default = false,
		Callback = function(v) both("DisableOnFlash", v) end,
	})
	TBox:AddToggle("TLimitDist", {
		Text = "Limit Distance", Default = false,
		Callback = function(v) both("LimitDistance", v) end,
	})
	TBox:AddSlider("TMaxDist", {
		Text = "Max Distance", Min = 50, Max = 2000, Default = 500, Rounding = 0,
		Callback = function(v) both("MaxDistance", v) end,
	})
	TBox:AddSlider("TReaction", {
		Text = "Reaction Time (ms)", Min = 0, Max = 500, Default = 0, Rounding = 0,
		Callback = function(v) both("ReactionTime", v) end,
	})
	TBox:AddSlider("TForget", {
		Text = "Forget Time (s)", Min = 0, Max = 5, Default = 1, Rounding = 1,
		Callback = function(v) both("ForgetTime", v) end,
	})
	TBox:AddDropdown("TTargetPart", {
		Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
		Default = 1,
		Text = "Target Part",
		Callback = function(v) both("TargetPart", v) end,
	})
	TBox:AddToggle("TTeam", {
		Text = "Team Check", Default = true,
		Callback = function(v) both("TeamCheck", v) end,
	})
	TBox:AddDropdown("TBlacklist", {
		Values = { "None", "LeftHand, LeftLowerArm", "RightHand, RightLowerArm", "Both Hands" },
		Default = 1,
		Text = "Closest Part Blacklist",
		Callback = function(v)
			both("ClosestBlacklist", v)
		end,
	})
end

------------------------------------------------------------------------
-- TRIGGERBOT (Unnamed-style: fires when target under crosshair / in FOV)
------------------------------------------------------------------------
do
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local LP = Players.LocalPlayer

	getgenv().Triggerbot = {
		Enabled = false,
		Delay = 0,           -- ms before fire after target acquired
		Cooldown = 0.05,      -- min time between clicks
		UseFOV = true,       -- require target inside silent/aim FOV radius
		TeamCheck = true,
		HitChance = 100,
	}
	local TB = getgenv().Triggerbot

	local TBBox = Tabs.Main:AddRightGroupbox("Triggerbot")
	TBBox:AddToggle("TBEnabled", {
		Text = "Enabled",
		Default = false,
		Callback = function(v)
			TB.Enabled = v
			Library:Notify(v and "Triggerbot ON" or "Triggerbot OFF")
		end,
	})
	TBBox:AddSlider("TBDelay", {
		Text = "Reaction Delay (ms)",
		Min = 0, Max = 300, Default = 0, Rounding = 0,
		Callback = function(v) TB.Delay = v end,
	})
	TBBox:AddSlider("TBCooldown", {
		Text = "Click Cooldown",
		Min = 0.02, Max = 0.5, Default = 0.05, Rounding = 2,
		Callback = function(v) TB.Cooldown = v end,
	})
	TBBox:AddToggle("TBUseFOV", {
		Text = "Use FOV Check",
		Default = true,
		Callback = function(v) TB.UseFOV = v end,
	})
	TBBox:AddToggle("TBTeam", {
		Text = "Team Check",
		Default = true,
		Callback = function(v) TB.TeamCheck = v end,
	})
	TBBox:AddSlider("TBHitChance", {
		Text = "Hit Chance",
		Min = 1, Max = 100, Default = 100, Rounding = 0,
		Callback = function(v) TB.HitChance = v end,
	})

	local function getCrosshairTarget()
		local cam = workspace.CurrentCamera
		if not cam then return nil end
		local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
		local radius = 40
		local SA = getgenv().SilentAim
		local AB = getgenv().Aimbot
		if TB.UseFOV then
			if SA and SA.Enabled then
				radius = tonumber(SA.Radius) or 150
			elseif AB and AB.Enabled then
				radius = tonumber(AB.Radius) or 150
			end
		end
		-- prefer silent/aimbot cached target if already locked
		if SA and SA.Enabled and SA.Target and SA.Target.Parent then
			local pos, vis = cam:WorldToViewportPoint(SA.Target.Position)
			if pos.Z > 0 then
				local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
				if d <= radius then return SA.Target end
			end
		end
		if AB and AB.Enabled and AB.Target and AB.Target.Parent then
			local pos, vis = cam:WorldToViewportPoint(AB.Target.Position)
			if pos.Z > 0 then
				local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
				if d <= radius then return AB.Target end
			end
		end
		local best, bestD = nil, radius
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local sameTeam = false
				if TB.TeamCheck then
					if plr.Team and LP.Team and plr.Team == LP.Team then sameTeam = true end
					local pT = plr:GetAttribute("TeamID") or plr:GetAttribute("Team")
					local lT = LP:GetAttribute("TeamID") or LP:GetAttribute("Team")
					if pT ~= nil and lT ~= nil and pT == lT then sameTeam = true end
					if plr.TeamColor and LP.TeamColor and plr.TeamColor == LP.TeamColor then sameTeam = true end
				end
				if not sameTeam then
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					local head = plr.Character:FindFirstChild("Head")
					if hum and hum.Health > 0 and head then
						local pos, onScreen = cam:WorldToViewportPoint(head.Position)
						if pos.Z > 0 then
							local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
							if d <= bestD then
								bestD, best = d, head
							end
						end
					end
				end
			end
		end
		return best
	end

	local function doClick()
		pcall(function()
			if mouse1click then
				mouse1click()
			elseif mouse1press and mouse1release then
				mouse1press()
				task.delay(0.03, mouse1release)
			end
		end)
	end

	local lastClick = 0
	local acquiredAt = 0
	local hadTarget = false

	RunService.Heartbeat:Connect(function()
		if not TB.Enabled then
			hadTarget = false
			acquiredAt = 0
			return
		end
		local target = getCrosshairTarget()
		if not target then
			hadTarget = false
			acquiredAt = 0
			return
		end
		local now = tick()
		if not hadTarget then
			hadTarget = true
			acquiredAt = now
		end
		-- reaction delay
		if (now - acquiredAt) * 1000 < (TB.Delay or 0) then return end
		if now - lastClick < (TB.Cooldown or 0.05) then return end
		if math.random(1, 100) > (TB.HitChance or 100) then return end
		lastClick = now
		doClick()
	end)
end

------------------------------------------------------------------------
-- WEAPONS
------------------------------------------------------------------------
------------------------------------------------------------------------
-- WEAPONS / GUN MODS
------------------------------------------------------------------------

------------------------------------------------------------------------
-- GUN MODS
------------------------------------------------------------------------
do
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local RS = game:GetService("ReplicatedStorage")

	getgenv().CombatMods = {
		RapidFire = false,
		RapidFireCooldown = -0.05,
		NoSpread = false,
		NoRecoil = false,
		MaxAccuracy = false,
		RapidAttack = false,
		GunModule = nil,
		MeleeModule = nil,
		OriginalGunStartShooting = nil,
		OriginalMeleeStartShooting = nil,
		OriginalGetSpread = nil,
		OriginalRecoil = nil,
		NoReload = false,
		ReloadTime = 0,
		ProjectileSpeed = false,
		ProjectileSpeedValue = 9999999999999999,
		EquipCooldown = false,
		EquipCooldownValue = 0,
	}

	task.spawn(function()
		local success, GunModule = pcall(function()
			return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
		end)
		if not (success and GunModule) then return end
		getgenv().CombatMods.GunModule = GunModule

		if GunModule.StartShooting then
			getgenv().CombatMods.OriginalGunStartShooting = GunModule.StartShooting
			GunModule.StartShooting = function(self, p26, p27)
				local oldShootCooldown, oldProjectileSpeed, oldEquipCooldown
				if getgenv().CombatMods.RapidFire then
					oldShootCooldown = self.Info.ShootCooldown
					self.Info.ShootCooldown = getgenv().CombatMods.RapidFireCooldown or -0.05
				end
				if getgenv().CombatMods.ProjectileSpeed then
					pcall(function()
						oldProjectileSpeed = self.Info.ProjectileSpeed
						self.Info.ProjectileSpeed = getgenv().CombatMods.ProjectileSpeedValue
					end)
				end
				if getgenv().CombatMods.EquipCooldown then
					pcall(function()
						oldEquipCooldown = self.Info.EquipCooldown
						self.Info.EquipCooldown = getgenv().CombatMods.EquipCooldownValue
					end)
				end
				if getgenv().CombatMods.NoReload then
					pcall(function()
						self.Info.ReloadTime = getgenv().CombatMods.ReloadTime
					end)
				end
				local result = { getgenv().CombatMods.OriginalGunStartShooting(self, p26, p27) }
				if getgenv().CombatMods.RapidFire and oldShootCooldown ~= nil then
					self.Info.ShootCooldown = oldShootCooldown
				end
				if getgenv().CombatMods.ProjectileSpeed and oldProjectileSpeed then
					self.Info.ProjectileSpeed = oldProjectileSpeed
				end
				if getgenv().CombatMods.EquipCooldown and oldEquipCooldown then
					self.Info.EquipCooldown = oldEquipCooldown
				end
				return unpack(result)
			end
		end

		if GunModule._Recoil then
			getgenv().CombatMods.OriginalRecoil = GunModule._Recoil
			GunModule._Recoil = function(self, multiplier)
				if getgenv().CombatMods.NoRecoil then return end
				return getgenv().CombatMods.OriginalRecoil(self, multiplier)
			end
		end
	end)

	local function ModifyGunModule()
		local gunMod = getgenv().CombatMods and getgenv().CombatMods.GunModule
		if gunMod and gunMod.Info then
			if getgenv().CombatMods.RapidFire then
				gunMod.Info.ShootCooldown = getgenv().CombatMods.RapidFireCooldown or -0.05
			end
			if getgenv().CombatMods.NoRecoil then
				gunMod.Info.Recoil = 0
			end
			if getgenv().CombatMods.NoSpread then
				gunMod.Info.Spread = 0
			end
		end
	end

	task.spawn(function()
		while task.wait(0.5) do
			if getgenv().CombatMods and (getgenv().CombatMods.RapidFire or getgenv().CombatMods.NoRecoil or getgenv().CombatMods.NoSpread) then
				ModifyGunModule()
			end
		end
	end)

	task.spawn(function()
		local success, GameplayUtility = pcall(function()
			return require(RS.Modules.GameplayUtility)
		end)
		if success and GameplayUtility and GameplayUtility.GetSpread then
			getgenv().CombatMods.OriginalGetSpread = GameplayUtility.GetSpread
			GameplayUtility.GetSpread = function(spread, aimMultiplier, isAiming, isCrouching, pelletIndex, totalPellets, consistent)
				if getgenv().CombatMods.NoSpread or getgenv().CombatMods.MaxAccuracy then
					return CFrame.new()
				end
				return getgenv().CombatMods.OriginalGetSpread(spread, aimMultiplier, isAiming, isCrouching, pelletIndex, totalPellets, consistent)
			end
		end
	end)

	task.spawn(function()
		local success, MeleeModule = pcall(function()
			return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
		end)
		if not (success and MeleeModule) then return end
		getgenv().CombatMods.MeleeModule = MeleeModule
		if MeleeModule.StartShooting then
			getgenv().CombatMods.OriginalMeleeStartShooting = MeleeModule.StartShooting
			MeleeModule.StartShooting = function(self, p26, p27)
				local oldAttackCooldown
				if getgenv().CombatMods.RapidAttack then
					oldAttackCooldown = self.Info.AttackCooldown
					self.Info.AttackCooldown = 0
				end
				local result = { getgenv().CombatMods.OriginalMeleeStartShooting(self, p26, p27) }
				if getgenv().CombatMods.RapidAttack and oldAttackCooldown then
					self.Info.AttackCooldown = oldAttackCooldown
				end
				return unpack(result)
			end
		end
	end)

	local muzzleflashconn = nil
	local function nomuzzleflash()
		local viewModels = Workspace:FindFirstChild("ViewModels")
		if not viewModels then return end
		local firstPerson = viewModels:FindFirstChild("FirstPerson")
		if not firstPerson then return end
		for _, model in pairs(firstPerson:GetChildren()) do
			if model:IsA("Model") then
				local itemVisual = model:FindFirstChild("ItemVisual")
				local body = itemVisual and itemVisual:FindFirstChild("Body")
				local bodyPrimary = body and body:FindFirstChild("BodyPrimary")
				local muzzle = bodyPrimary and bodyPrimary:FindFirstChild("_muzzle")
				if muzzle then
					local spotlight = muzzle:FindFirstChild("SpotLight")
					if spotlight then spotlight:Destroy() end
					for _, child in pairs(muzzle:GetChildren()) do
						if child:IsA("ParticleEmitter") and child.Name == "ParticleEmiter" then
							child:Destroy()
						end
					end
				end
			end
		end
	end

	local GunBox = Tabs.Main:AddRightGroupbox("Weapons")
	GunBox:AddToggle("NoSpread", {
		Text = "No Spread",
		Default = false,
		Callback = function(val) getgenv().CombatMods.NoSpread = val end,
	})
	GunBox:AddToggle("NoCooldown", {
		Text = "Full Auto",
		Default = false,
		Callback = function(val) getgenv().CombatMods.RapidFire = val end,
	})
	GunBox:AddToggle("AlwaysBackstab", {
		Text = "Always Backstab",
		Default = false,
		Callback = function(val) getgenv().CombatMods.AlwaysBackstab = val end,
	})
	GunBox:AddToggle("NoRecoil", {
		Text = "No Recoil",
		Default = false,
		Callback = function(val) getgenv().CombatMods.NoRecoil = val end,
	})
	GunBox:AddToggle("MaxAccuracy", {
		Text = "Max Accuracy",
		Default = false,
		Callback = function(val) getgenv().CombatMods.MaxAccuracy = val end,
	})
	GunBox:AddToggle("RapidAttack", {
		Text = "Rapid Attack",
		Default = false,
		Callback = function(val) getgenv().CombatMods.RapidAttack = val end,
	})
	GunBox:AddDropdown("GrenadeOpts", {
		Values = { "None", "Instant", "No Self Damage" },
		Default = 1,
		Text = "Grenade Options",
		Callback = function(v) getgenv().CombatMods.GrenadeOption = v end,
	})
	GunBox:AddSlider("FireratePct", {
		Text = "Firerate",
		Min = 10,
		Max = 200,
		Default = 100,
		Rounding = 0,
		Callback = function(val)
			-- map 100% -> normal; higher = faster (lower cooldown)
			local pct = math.clamp(val, 10, 200) / 100
			getgenv().CombatMods.RapidFireCooldown = -0.05 * pct
			if pct > 1 then getgenv().CombatMods.RapidFire = true end
		end,
	})
	GunBox:AddToggle("NoMuzzleFlash", {
		Text = "No Muzzle Flash",
		Default = false,
		Callback = function(val)
			if val then
				nomuzzleflash()
				if muzzleflashconn then muzzleflashconn:Disconnect() end
				muzzleflashconn = RunService.RenderStepped:Connect(nomuzzleflash)
			else
				if muzzleflashconn then
					muzzleflashconn:Disconnect()
					muzzleflashconn = nil
				end
			end
		end,
	})

	-- Always backstab: force backstab angle on melee when enabled
	getgenv().CombatMods.AlwaysBackstab = false
	RunService.Heartbeat:Connect(function()
		if not getgenv().CombatMods.AlwaysBackstab then return end
		pcall(function()
			local lp = game:GetService("Players").LocalPlayer
			local FC = require(lp.PlayerScripts.Controllers.FighterController)
			local item = FC.LocalFighter and FC.LocalFighter.EquippedItem
			if not item then return end
			pcall(function()
				if item.Info then
					item.Info.CanBackstab = true
					item.Info.BackstabOnly = false
					item.Info.BackstabAngle = 360
				end
			end)
		end)
	end)
end


------------------------------------------------------------------------
-- WORLD (full Lion port)

------------------------------------------------------------------------
-- RAGEBOT (exact source)
------------------------------------------------------------------------
local RageTabbox
pcall(function() RageTabbox = Tabs.Main:AddTabbox({ Side = 2 }) end)
local Box, HudTab
if RageTabbox then
	Box = RageTabbox:AddTab("Ragebot")
	HudTab = RageTabbox:AddTab("Notification")
else
	Box = Tabs.Main:AddRightGroupbox("Ragebot")
	HudTab = Tabs.Main:AddRightGroupbox("Notification")
end
RageHudLabel = Box:AddLabel("ragebot: idle")
HudTab:AddToggle("HudEnabled", {
	Text = "Enabled",
	Default = false,
	Callback = function(v)
		HudEnabled = v
	end,
})
HudTab:AddInput("NotifyText", {
	Text = "Message",
	Placeholder = "type anything",
	Default = "ragebot: voiding",
	Callback = function(txt)
		getgenv().NotifyText = txt
	end,
})
getgenv().NotifyText = "ragebot: voiding"

getgenv().Config = {
	Enabled = false,
	FireRate = 0.002,
	WeaponSlot = "Melee",
	HitDelay = 0.85,
	ReadyAt = 0,
	VoidSpam = true,
	HideTime = 0.25,
	AttackTime = 0.1,
	ShootAttempts = 6,
	AttackMode = "Gun",
	PreferredWeapon = "Primary",
	AutoSwitch = true,
	ProjectileWeapons = false,
	KnifeRagebot = false,
}

local rbConn, gen = nil, 0

local function stopRagebot()
	getgenv().Config.Enabled = false
	gen = gen + 1
	if rbConn then pcall(function() rbConn:Disconnect() end) rbConn = nil end
	pcall(function()
		game:GetService("RunService"):UnbindFromRenderStep("__restore")
	end)
		pcall(function() setRageHud("") end)
end

local function getSlotIndex(name)
	return ({ Primary = 1, Secondary = 2, Melee = 3 })[name] or 1
end

-- Knife ragebot: force melee/knife slot + head only
local function equipKnife(FC)
	if not FC or not FC.LocalFighter then return end
	-- Prefer melee slot (3) — Rivals knife lives there
	pcall(function() FC.LocalFighter:EquipItem(3) end)
	getgenv().Config.WeaponSlot = "Melee"
	-- Try name-based equip if inventory exposes knife tools
	pcall(function()
		local char = game:GetService("Players").LocalPlayer.Character
		if not char then return end
		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local n = string.lower(tool.Name)
				if n:find("knife") or n:find("dagger") or n:find("melee") or n:find("blade") then
					pcall(function() FC.LocalFighter:EquipItem(tool) end)
					break
				end
			end
		end
	end)
end

local lastSwitchAt = 0
local function equipPreferred(FC)
	local cfg = getgenv().Config
	local slot = cfg.PreferredWeapon or cfg.WeaponSlot or "Primary"
	if FC and FC.LocalFighter then
		pcall(function() FC.LocalFighter:EquipItem(getSlotIndex(slot)) end)
	end
	cfg.WeaponSlot = slot
end

local function autoSwitchIfEmpty(FC)
	local cfg = getgenv().Config
	if not cfg.AutoSwitch or not FC or not FC.LocalFighter then return end
	if tick() - lastSwitchAt < 0.3 then return end
	local item = FC.LocalFighter.EquippedItem
	local empty = item == nil
	if item then
		pcall(function()
			local a = item:Get("Ammo")
			if a ~= nil and tonumber(a) == 0 then empty = true end
		end)
	end
	if not empty then return end
	lastSwitchAt = tick()
	local pref = cfg.PreferredWeapon or "Primary"
	for _, s in ipairs({ pref, "Primary", "Secondary", "Melee" }) do
		pcall(function() FC.LocalFighter:EquipItem(getSlotIndex(s)) end)
		cfg.WeaponSlot = s
		return
	end
end

local function startRagebot()
	stopRagebot()
	local myGen = gen
	getgenv().Config.Enabled = true
	getgenv().Config.ReadyAt = tick() + (tonumber(getgenv().Config.HitDelay) or 0.15)

	local ok, err = pcall(function()
		local repS = game:GetService("ReplicatedStorage")
		local plrs = game:GetService("Players")
		local runS = game:GetService("RunService")
		local ws = game:GetService("Workspace")
		local lplr = plrs.LocalPlayer

		local util = require(repS.Modules.Utility)
		local enum = require(repS.Modules.EnumLibrary)

		local FighterController
		local SpectateController
		local t0 = tick()
		while not FighterController and tick() - t0 < 10 and getgenv().Config.Enabled and gen == myGen do
			pcall(function()
				FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
			end)
			task.wait(0.1)
		end
		pcall(function()
			SpectateController = require(lplr.PlayerScripts.Controllers.SpectateController)
		end)
		if not FighterController then
			Library:Notify("Ragebot: wait for game to load, then enable again")
			getgenv().Config.Enabled = false
			return
		end

		local slots = { Primary = 1, Secondary = 2, Melee = 3 }
		local function getSlotNumber()
			local s = getgenv().Config.PreferredWeapon or getgenv().Config.WeaponSlot or "Melee"
			return slots[s] or 3
		end

		task.spawn(function()
			while getgenv().Config.Enabled and gen == myGen do
				pcall(function()
					local lf = FighterController.LocalFighter
					if lf then lf:EquipItem(getSlotNumber()) end
				end)
				task.wait(1)
			end
		end)

		local lastFire = 0
		local deflecting = {}
		pcall(function()
			plrs.PlayerRemoving:Connect(function(player)
				deflecting[player] = nil
			end)
		end)

		local function updateDeflection()
			if not FighterController or not FighterController.Objects then return end
			for _, fighterObj in pairs(FighterController.Objects) do
				local player = fighterObj.Player
				if player then
					local skip = false
					pcall(function()
						if not fighterObj.Entity or not fighterObj.Entity:IsAlive() or fighterObj:Get("IsSpectating") then
							deflecting[player] = false
							skip = true
						end
					end)
					if not skip then
						local isDeflecting = false
						pcall(function()
							local equipped = fighterObj.EquippedItem
							if equipped and equipped.ViewModel and equipped.ViewModel.Name == "Katana" then
								isDeflecting = (equipped._attack_cooldown and equipped._attack_cooldown > tick()) or false
							end
						end)
						deflecting[player] = isDeflecting
					end
				end
			end
		end

		local function isEnemy(player)
			if not player or player == lplr then return false end
			local result = nil
			pcall(function()
				if not SpectateController then return end
				local duel = SpectateController.CurrentDuelSubject
				if not duel then return end
				local localDueler = duel:GetDueler(lplr)
				local localTeam = localDueler and localDueler:Get("TeamID") or nil
				if not localTeam or not duel.Duelers then return end
				for _, dueler in pairs(duel.Duelers) do
					if dueler.Player == player then
						result = dueler:Get("TeamID") ~= localTeam
						return
					end
				end
			end)
			if result ~= nil then return result end
			local pTeam = player:GetAttribute("TeamID")
			local lTeam = lplr:GetAttribute("TeamID")
			if pTeam ~= nil and lTeam ~= nil then return pTeam ~= lTeam end
			if player.Team ~= nil and lplr.Team ~= nil then return player.Team ~= lplr.Team end
			return true
		end

		local function getClosestTarget()
			local char = lplr.Character
			if not char then return nil, nil, nil end
			local myRoot = char:FindFirstChild("HumanoidRootPart")
			if not myRoot then return nil, nil, nil end
			local bestP, bestR, bestH, bestD = nil, nil, nil, 500
			for _, player in ipairs(plrs:GetPlayers()) do
				if isEnemy(player) and player.Character then
					local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
					local pHead = player.Character:FindFirstChild("Head")
					local pHum = player.Character:FindFirstChildWhichIsA("Humanoid")
					if pRoot and pHead and pHum and pHum.Health > 0 then
						local d = (myRoot.Position - pRoot.Position).Magnitude
						if d < bestD then
							bestD, bestP, bestR, bestH = d, player, pRoot, pHead
						end
					end
				end
			end
			return bestP, bestR, bestH
		end

		local function hasKnifeViewModel(targetPlayer)
			if not targetPlayer then return false end
			local viewModels = ws:FindFirstChild("ViewModels")
			if not viewModels then return false end
			local targetName = targetPlayer.Name
			for _, model in ipairs(viewModels:GetChildren()) do
				if model:IsA("Model")
					and string.find(model.Name, targetName, 1, true)
					and string.find(model.Name, "Knife", 1, true) then
					return true
				end
			end
			return false
		end

		rbConn = runS.Heartbeat:Connect(function()
			if gen ~= myGen then return end

			pcall(updateDeflection)
			local targetPlayer, targetRoot, targetHead = getClosestTarget()
			local desyncCF = nil

			if targetRoot and targetHead then
				local desyncPos
				if hasKnifeViewModel(targetPlayer) then
					desyncPos = (targetRoot.CFrame * CFrame.new(0, 5, -12)).Position
				else
					desyncPos = (targetRoot.CFrame * CFrame.new(0, 2, -12)).Position
				end
				desyncCF = CFrame.lookAt(desyncPos, targetHead.Position)
			end

			if desyncCF and lplr.Character then
				local myRoot = lplr.Character:FindFirstChild("HumanoidRootPart")
				if myRoot then
					local oldCF = myRoot.CFrame
					local oldVel = myRoot.AssemblyLinearVelocity
					local oldRot = myRoot.AssemblyAngularVelocity
					myRoot.CFrame = desyncCF
					pcall(function()
						myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					end)
					runS:BindToRenderStep("__restore", 101, function()
						if myRoot and myRoot.Parent then
							myRoot.CFrame = oldCF
							pcall(function()
								myRoot.AssemblyLinearVelocity = oldVel
								myRoot.AssemblyAngularVelocity = oldRot
							end)
						end
						pcall(function() runS:UnbindFromRenderStep("__restore") end)
					end)
				end
			end

			if not getgenv().Config.Enabled then
				pcall(function() setRageHud("") end)
				return
			end
			if not targetPlayer or not targetHead or not targetRoot then
				pcall(function() setRageHud("ragebot: idle") end)
				return
			end
			if deflecting[targetPlayer] then
				pcall(function() setRageHud("ragebot: waiting katana") end)
				return
			end
			if not FighterController.LocalFighter then return end

			if tick() < (getgenv().Config.ReadyAt or 0) then return end

			local item = FighterController.LocalFighter.EquippedItem
			if not item then
				pcall(function() FighterController.LocalFighter:EquipItem(getSlotNumber()) end)
				item = FighterController.LocalFighter.EquippedItem
			end
			if not item then return end

			local rate = tonumber(getgenv().Config.FireRate) or 0.0005
			local slot = getgenv().Config.PreferredWeapon or getgenv().Config.WeaponSlot or "Melee"
			if slot == "Melee" then
				rate = math.min(rate, 0.002)
				pcall(function()
					if item.Info then
						item.Info.AttackCooldown = 0
						item.Info.SwingCooldown = 0
						item.Info.MeleeCooldown = 0
						item.Info.Cooldown = 0
						item.Info.ShootCooldown = 0
					end
				end)
			end
			if tick() - lastFire < rate then
				pcall(function() setRageHud("ragebot: targeting @" .. targetPlayer.Name) end)
				return
			end

			local objectId
			pcall(function() objectId = item:Get("ObjectID") end)
			if not objectId then return end

			lastFire = tick()
			local originPos = desyncCF and desyncCF.Position or targetRoot.Position
			local targetPos = targetHead.Position
			local aimCF = CFrame.lookAt(originPos, targetPos)
			local cameradata = {
				[utf8.char(1)] = {
					[utf8.char(0)] = util:EncodeCFrame(aimCF),
					[utf8.char(1)] = util:EncodeCFrame(targetHead.CFrame),
					[utf8.char(2)] = targetHead,
					[utf8.char(3)] = util:EncodeCFrame(CFrame.new(0, 0, 0)),
				}
			}
			pcall(function()
				repS.Remotes.Replication.Fighter.UseItem:FireServer(
					objectId,
					enum:ToEnum("StartShooting"),
					cameradata,
					nil
				)
			end)
			pcall(function() setRageHud("ragebot: targeting @" .. targetPlayer.Name) end)
		end)

		pcall(function() setRageHud("ragebot: idle") end)
		Library:Notify("Ragebot ON")
	end)

	if not ok then
		pcall(function() Library:Notify("Ragebot: " .. tostring(err)) end)
		stopRagebot()
	end
end

Box:AddToggle("RB", {
	Text = "Enabled",
	Default = false,
	Callback = function(v)
		if v then startRagebot() else stopRagebot() Library:Notify("Ragebot OFF") end
	end,
})

Box:AddSlider("Rate", {
	Text = "Attack",
	Min = 0.0001,
	Max = 0.1,
	Default = 0.0001,
	Rounding = 4,
	Callback = function(v)
		getgenv().Config.FireRate = v
	end,
})

Box:AddDropdown("AttackMode", {
	Values = { "Gun", "Melee", "Any" },
	Default = 1,
	Text = "Attack Mode",
	Callback = function(v)
		getgenv().Config.AttackMode = v
	end,
})

Box:AddDropdown("PreferredWeapon", {
	Values = { "Primary", "Secondary", "Melee" },
	Default = 3,
	Text = "Preferred Weapon",
	Callback = function(v)
		getgenv().Config.PreferredWeapon = v
		getgenv().Config.WeaponSlot = v
		if getgenv().Config.Enabled then
			pcall(function()
				local lp = game:GetService("Players").LocalPlayer
				local FC = require(lp.PlayerScripts.Controllers.FighterController)
				local slots = { Primary = 1, Secondary = 2, Melee = 3 }
				if FC.LocalFighter then
					FC.LocalFighter:EquipItem(slots[v] or 1)
				end
			end)
		end
	end,
})

Box:AddDropdown("Settings", {
	Values = { "Prefer Switch Weapons", "Prefer To Use Projectile Weapons", "Both", "None" },
	Default = 1,
	Text = "Settings",
	Callback = function(v)
		getgenv().Config.AutoSwitch = (v == "Prefer Switch Weapons" or v == "Both")
		getgenv().Config.ProjectileWeapons = (v == "Prefer To Use Projectile Weapons" or v == "Both")
	end,
})



------------------------------------------------------------------------
do
	local Lighting = game:GetService("Lighting")
	local SoundService = game:GetService("SoundService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer

	local State = {
		Effects = {},
		Originals = {},
		WeatherPart = nil,
		WeatherEmitters = {},
		AmbienceSound = nil,
		OriginalFOV = nil,
	}

	local function getEffect(className, name)
		local effect = State.Effects[name]
		if effect and effect.Parent then return effect end
		effect = Lighting:FindFirstChild(name)
		if not effect or not effect:IsA(className) then
			effect = Instance.new(className)
			effect.Name = name
		end
		State.Effects[name] = effect
		return effect
	end

	local function saveProp(obj, prop)
		if not obj then return end
		State.Originals[obj] = State.Originals[obj] or {}
		if State.Originals[obj][prop] == nil then
			local ok, val = pcall(function() return obj[prop] end)
			if ok then State.Originals[obj][prop] = val end
		end
	end

	local function setProp(obj, prop, value)
		saveProp(obj, prop)
		pcall(function() obj[prop] = value end)
	end

	local function restoreProp(obj, prop)
		local saved = State.Originals[obj] and State.Originals[obj][prop]
		if saved ~= nil then
			pcall(function() obj[prop] = saved end)
			State.Originals[obj][prop] = nil
		end
	end

	getgenv().ArchWorld = getgenv().ArchWorld or {
		ClockOn = false, Clock = 14,
		AmbientOn = false, Ambient = Color3.fromRGB(140,140,160),
		OutdoorOn = false, Outdoor = Color3.fromRGB(140,140,160),
		CSTopOn = false, CSTop = Color3.fromRGB(180,180,220),
		CSBotOn = false, CSBot = Color3.fromRGB(40,40,60),
		FogColorOn = false, FogColor = Color3.fromRGB(192,192,192),
		FogEndOn = false, FogEnd = 100000,
		FogStartOn = false, FogStart = 0,
		ExposureOn = false, Exposure = 0,
		BrightOn = false, Bright = 1,
		Shadows = true,
	}

	local W = getgenv().ArchWorld

	local function applyLighting()
		if W.AmbientOn then setProp(Lighting, "Ambient", W.Ambient) else restoreProp(Lighting, "Ambient") end
		if W.OutdoorOn then setProp(Lighting, "OutdoorAmbient", W.Outdoor) else restoreProp(Lighting, "OutdoorAmbient") end
		if W.CSTopOn then setProp(Lighting, "ColorShift_Top", W.CSTop) else restoreProp(Lighting, "ColorShift_Top") end
		if W.CSBotOn then setProp(Lighting, "ColorShift_Bottom", W.CSBot) else restoreProp(Lighting, "ColorShift_Bottom") end
		if W.FogColorOn then setProp(Lighting, "FogColor", W.FogColor) else restoreProp(Lighting, "FogColor") end
		if W.FogEndOn then setProp(Lighting, "FogEnd", W.FogEnd) else restoreProp(Lighting, "FogEnd") end
		if W.FogStartOn then setProp(Lighting, "FogStart", W.FogStart) else restoreProp(Lighting, "FogStart") end
		if W.ExposureOn then setProp(Lighting, "ExposureCompensation", W.Exposure) else restoreProp(Lighting, "ExposureCompensation") end
		if W.BrightOn then setProp(Lighting, "Brightness", W.Bright) else restoreProp(Lighting, "Brightness") end
		if W.ClockOn then setProp(Lighting, "ClockTime", W.Clock) else restoreProp(Lighting, "ClockTime") end
		setProp(Lighting, "GlobalShadows", W.Shadows)
	end

	----------------------------------------------------------------
	-- Lighting (Lion)
	----------------------------------------------------------------
	local LightBox = Tabs.World:AddLeftGroupbox("Lighting")
	LightBox:AddToggle("Fullbright", {
		Text = "Fullbright", Default = false,
		Callback = function(v)
			if v then
				setProp(Lighting, "FogEnd", 1e9)
				setProp(Lighting, "Brightness", 2)
				setProp(Lighting, "GlobalShadows", false)
			else
				restoreProp(Lighting, "FogEnd")
				restoreProp(Lighting, "Brightness")
				restoreProp(Lighting, "GlobalShadows")
				applyLighting()
			end
		end,
	})
	LightBox:AddToggle("NoFog", {
		Text = "No Fog", Default = false,
		Callback = function(v)
			if v then setProp(Lighting, "FogEnd", 1e9) else applyLighting() end
		end,
	})
	LightBox:AddToggle("ClockOn", {
		Text = "Clock Time", Default = false,
		Callback = function(v) W.ClockOn = v applyLighting() end,
	})
	LightBox:AddSlider("ClockVal", {
		Text = "Clock", Min = 0, Max = 24, Default = 14, Rounding = 1,
		Callback = function(v) W.Clock = v applyLighting() end,
	})
	LightBox:AddToggle("BrightOn", {
		Text = "Brightness", Default = false,
		Callback = function(v) W.BrightOn = v applyLighting() end,
	})
	LightBox:AddSlider("BrightVal", {
		Text = "Brightness Value", Min = 0, Max = 5, Default = 1, Rounding = 2,
		Callback = function(v) W.Bright = v applyLighting() end,
	})
	LightBox:AddToggle("ExposureOn", {
		Text = "Exposure", Default = false,
		Callback = function(v) W.ExposureOn = v applyLighting() end,
	})
	LightBox:AddSlider("ExposureVal", {
		Text = "Exposure Value", Min = -3, Max = 3, Default = 0, Rounding = 2,
		Callback = function(v) W.Exposure = v applyLighting() end,
	})
	LightBox:AddToggle("FogEndOn", {
		Text = "FogEnd", Default = false,
		Callback = function(v) W.FogEndOn = v applyLighting() end,
	})
	LightBox:AddSlider("FogEndVal", {
		Text = "FogEnd Value", Min = 0, Max = 100000, Default = 1000, Rounding = 0,
		Callback = function(v) W.FogEnd = v applyLighting() end,
	})
	LightBox:AddToggle("FogStartOn", {
		Text = "FogStart", Default = false,
		Callback = function(v) W.FogStartOn = v applyLighting() end,
	})
	LightBox:AddSlider("FogStartVal", {
		Text = "FogStart Value", Min = 0, Max = 1000, Default = 0, Rounding = 0,
		Callback = function(v) W.FogStart = v applyLighting() end,
	})
	LightBox:AddToggle("FogColorOn", {
		Text = "FogColor", Default = false,
		Callback = function(v) W.FogColorOn = v applyLighting() end,
	}):AddColorPicker("FogColorPick", {
		Default = Color3.fromRGB(192,192,192),
		Callback = function(c) W.FogColor = c applyLighting() end,
	})
	LightBox:AddToggle("AmbientOn", {
		Text = "Ambient", Default = false,
		Callback = function(v) W.AmbientOn = v applyLighting() end,
	}):AddColorPicker("AmbientPick", {
		Default = Color3.fromRGB(140,140,160),
		Callback = function(c) W.Ambient = c applyLighting() end,
	})
	LightBox:AddToggle("OutdoorOn", {
		Text = "OutdoorAmbient", Default = false,
		Callback = function(v) W.OutdoorOn = v applyLighting() end,
	}):AddColorPicker("OutdoorPick", {
		Default = Color3.fromRGB(140,140,160),
		Callback = function(c) W.Outdoor = c applyLighting() end,
	})
	LightBox:AddToggle("CSTopOn", {
		Text = "ColorShift_Top", Default = false,
		Callback = function(v) W.CSTopOn = v applyLighting() end,
	}):AddColorPicker("CSTopPick", {
		Default = Color3.fromRGB(180,180,220),
		Callback = function(c) W.CSTop = c applyLighting() end,
	})
	LightBox:AddToggle("CSBotOn", {
		Text = "ColorShift_Bottom", Default = false,
		Callback = function(v) W.CSBotOn = v applyLighting() end,
	}):AddColorPicker("CSBotPick", {
		Default = Color3.fromRGB(40,40,60),
		Callback = function(c) W.CSBot = c applyLighting() end,
	})
	LightBox:AddToggle("Shadows", {
		Text = "Global Shadows", Default = true,
		Callback = function(v) W.Shadows = v applyLighting() end,
	})

	----------------------------------------------------------------
	-- Atmosphere (Lion)
	----------------------------------------------------------------
	local AtmoBox = Tabs.World:AddLeftGroupbox("Atmosphere")
	AtmoBox:AddToggle("AtmoOn", {
		Text = "Atmosphere", Default = false,
		Callback = function(v)
			local a = getEffect("Atmosphere", "ArchAtmosphere")
			a.Parent = v and Lighting or nil
		end,
	})
	AtmoBox:AddSlider("AtmoDensity", {
		Text = "Density", Min = 0, Max = 1, Default = 0.5, Rounding = 2,
		Callback = function(v) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Density", v) end,
	})
	AtmoBox:AddSlider("AtmoOffset", {
		Text = "Offset", Min = 0, Max = 1, Default = 0.4, Rounding = 2,
		Callback = function(v) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Offset", v) end,
	})
	AtmoBox:AddSlider("AtmoGlare", {
		Text = "Glare", Min = 0, Max = 10, Default = 1.5, Rounding = 1,
		Callback = function(v) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Glare", v) end,
	})
	AtmoBox:AddSlider("AtmoHaze", {
		Text = "Haze", Min = 0, Max = 10, Default = 1.5, Rounding = 1,
		Callback = function(v) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Haze", v) end,
	})
	AtmoBox:AddLabel("Color"):AddColorPicker("AtmoColor", {
		Default = Color3.fromRGB(180,190,210),
		Callback = function(c) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Color", c) end,
	})
	AtmoBox:AddLabel("Decay"):AddColorPicker("AtmoDecay", {
		Default = Color3.fromRGB(90,100,120),
		Callback = function(c) setProp(getEffect("Atmosphere", "ArchAtmosphere"), "Decay", c) end,
	})

	----------------------------------------------------------------
	-- Color Correction (Lion)
	----------------------------------------------------------------
	local CCBox = Tabs.World:AddLeftGroupbox("Color Correction")
	CCBox:AddToggle("CCOn", {
		Text = "Color Correction", Default = false,
		Callback = function(v)
			local e = getEffect("ColorCorrectionEffect", "ArchCC")
			e.Parent = Lighting
			e.Enabled = v
		end,
	}):AddColorPicker("CCTint", {
		Default = Color3.fromRGB(255,255,255),
		Callback = function(c)
			local e = getEffect("ColorCorrectionEffect", "ArchCC")
			setProp(e, "TintColor", c)
		end,
	})
	CCBox:AddSlider("CCSat", {
		Text = "Saturation", Min = -2, Max = 2, Default = 0, Rounding = 2,
		Callback = function(v) setProp(getEffect("ColorCorrectionEffect", "ArchCC"), "Saturation", v) end,
	})
	CCBox:AddSlider("CCCon", {
		Text = "Contrast", Min = -2, Max = 2, Default = 0, Rounding = 2,
		Callback = function(v) setProp(getEffect("ColorCorrectionEffect", "ArchCC"), "Contrast", v) end,
	})
	CCBox:AddSlider("CCBright", {
		Text = "Brightness", Min = -2, Max = 2, Default = 0, Rounding = 2,
		Callback = function(v) setProp(getEffect("ColorCorrectionEffect", "ArchCC"), "Brightness", v) end,
	})

	----------------------------------------------------------------
	-- Bloom + SunRays (Lion)
	----------------------------------------------------------------
	local BloomBox = Tabs.World:AddLeftGroupbox("Bloom")
	BloomBox:AddToggle("BloomOn", {
		Text = "Bloom", Default = false,
		Callback = function(v)
			local e = getEffect("BloomEffect", "ArchBloom")
			e.Parent = Lighting
			e.Enabled = v
		end,
	})
	BloomBox:AddSlider("BloomInt", {
		Text = "Intensity", Min = 0, Max = 5, Default = 0.6, Rounding = 2,
		Callback = function(v) setProp(getEffect("BloomEffect", "ArchBloom"), "Intensity", v) end,
	})
	BloomBox:AddSlider("BloomSize", {
		Text = "Size", Min = 0, Max = 100, Default = 26, Rounding = 0,
		Callback = function(v) setProp(getEffect("BloomEffect", "ArchBloom"), "Size", v) end,
	})
	BloomBox:AddSlider("BloomThresh", {
		Text = "Threshold", Min = 0, Max = 5, Default = 0.4, Rounding = 2,
		Callback = function(v) setProp(getEffect("BloomEffect", "ArchBloom"), "Threshold", v) end,
	})

	local SunBox = Tabs.World:AddLeftGroupbox("Sun Rays")
	SunBox:AddToggle("SunOn", {
		Text = "Sun Rays", Default = false,
		Callback = function(v)
			local e = getEffect("SunRaysEffect", "ArchSunRays")
			e.Parent = Lighting
			e.Enabled = v
		end,
	})
	SunBox:AddSlider("SunInt", {
		Text = "Intensity", Min = 0, Max = 1, Default = 0.25, Rounding = 2,
		Callback = function(v) setProp(getEffect("SunRaysEffect", "ArchSunRays"), "Intensity", v) end,
	})
	SunBox:AddSlider("SunSpread", {
		Text = "Spread", Min = 0, Max = 1, Default = 1, Rounding = 2,
		Callback = function(v) setProp(getEffect("SunRaysEffect", "ArchSunRays"), "Spread", v) end,
	})

	----------------------------------------------------------------
	-- Skybox (from Kiciahook testing — 72 presets)
	----------------------------------------------------------------
	local SkyBox = Tabs.World:AddRightGroupbox("Skybox")
	local Skyboxes = {
		["Aesthetic"] = { "rbxassetid://1417494030", "rbxassetid://1417494146", "rbxassetid://1417494253", "rbxassetid://1417494402", "rbxassetid://1417494499", "rbxassetid://1417494643" },
		["Aesthetic2"] = { "rbxassetid://600830446", "rbxassetid://600831635", "rbxassetid://600832720", "rbxassetid://600886090", "rbxassetid://600833862", "rbxassetid://600835177" },
		["Aesthetic3"] = { "rbxassetid://151165214", "rbxassetid://151165197", "rbxassetid://151165224", "rbxassetid://151165191", "rbxassetid://151165206", "rbxassetid://151165227" },
		["AestheticMountains"] = { "rbxassetid://15470198023", "rbxassetid://15470151245", "rbxassetid://15470200128", "rbxassetid://15470202648", "rbxassetid://15470204862", "rbxassetid://15470207755" },
		["Alien"] = { "rbxassetid://159248188", "rbxassetid://159248183", "rbxassetid://159248187", "rbxassetid://159248173", "rbxassetid://159248192", "rbxassetid://159248176" },
		["Ame"] = { "rbxassetid://160185927", "rbxassetid://160185945", "rbxassetid://160186027", "rbxassetid://160186075", "rbxassetid://160186126", "rbxassetid://160186148" },
		["Antartica"] = { "rbxassetid://2118763079", "rbxassetid://2118766919", "rbxassetid://2118765204", "rbxassetid://2118764070", "rbxassetid://2118761853", "rbxassetid://2118766003" },
		["Art"] = { "rbxassetid://9831762777", "rbxassetid://9831764283", "rbxassetid://9831766232", "rbxassetid://9831768023", "rbxassetid://9831768909", "rbxassetid://9831769868" },
		["Beach"] = { "rbxassetid://173380597", "rbxassetid://173380627", "rbxassetid://173380642", "rbxassetid://173380671", "rbxassetid://173380774", "rbxassetid://173380790" },
		["BetterNight"] = { "rbxassetid://15470289121", "rbxassetid://15470291746", "rbxassetid://15470294431", "rbxassetid://15470297162", "rbxassetid://15470299887", "rbxassetid://15470303050" },
		["BetterNight2"] = { "rbxassetid://248431616", "rbxassetid://248431677", "rbxassetid://248431598", "rbxassetid://248431686", "rbxassetid://248431611", "rbxassetid://248431605" },
		["BetterNight3"] = { "rbxassetid://2670643994", "rbxassetid://2670643365", "rbxassetid://2670643214", "rbxassetid://2670643070", "rbxassetid://2670644173", "rbxassetid://2670644331" },
		["BetterSky"] = { "rbxassetid://591058823", "rbxassetid://591059876", "rbxassetid://591058104", "rbxassetid://591057861", "rbxassetid://591057625", "rbxassetid://591059642" },
		["Blizzard"] = { "rbxassetid://16653221738", "rbxassetid://16653222701", "rbxassetid://16653224051", "rbxassetid://16653225849", "rbxassetid://16653227200", "rbxassetid://16653228333" },
		["BlueClouds"] = { "rbxassetid://591058823", "rbxassetid://591059876", "rbxassetid://591058104", "rbxassetid://591057861", "rbxassetid://591057625", "rbxassetid://591059642" },
		["BluePlanet"] = { "rbxassetid://16888989874", "rbxassetid://16888991855", "rbxassetid://16888995219", "rbxassetid://16888998994", "rbxassetid://16889000916", "rbxassetid://16889004122" },
		["BlueSpace"] = { "rbxassetid://16876541778", "rbxassetid://16876543880", "rbxassetid://16876546384", "rbxassetid://16876548320", "rbxassetid://16876550345", "rbxassetid://16876552681" },
		["Cloudy"] = { "rbxassetid://4495864450", "rbxassetid://4495864887", "rbxassetid://4495865458", "rbxassetid://4495866035", "rbxassetid://4495866584", "rbxassetid://4495867486" },
		["DarkClouds"] = { "rbxassetid://190477248", "rbxassetid://190477222", "rbxassetid://190477200", "rbxassetid://190477185", "rbxassetid://190477166", "rbxassetid://190477146" },
		["DarkMountains"] = { "rbxassetid://5098814730", "rbxassetid://5098815227", "rbxassetid://5098815653", "rbxassetid://5098816155", "rbxassetid://5098820352", "rbxassetid://5098819127" },
		["DarkishPink"] = { "rbxassetid://570555736", "rbxassetid://570555964", "rbxassetid://570555800", "rbxassetid://570555840", "rbxassetid://570555882", "rbxassetid://570555929" },
		["Dawn"] = { "rbxassetid://250381017", "rbxassetid://254156892", "rbxassetid://250380916", "rbxassetid://250380953", "rbxassetid://250380985", "rbxassetid://250381047" },
		["FPSBoost"] = { "rbxassetid://11457548274", "rbxassetid://11457548274", "rbxassetid://11457548274", "rbxassetid://11457548274", "rbxassetid://11457548274", "rbxassetid://11457548274" },
		["FakeClouds"] = { "rbxassetid://8496892810", "rbxassetid://8496896250", "rbxassetid://8496892810", "rbxassetid://8496892810", "rbxassetid://8496892810", "rbxassetid://8496897504" },
		["Flame"] = { "rbxassetid://6286780109", "rbxassetid://6286782353", "rbxassetid://6286784186", "rbxassetid://6286785801", "rbxassetid://6286788245", "rbxassetid://6286790025" },
		["FlamingSunset"] = { "rbxassetid://415688378", "rbxassetid://415688193", "rbxassetid://415688242", "rbxassetid://415688310", "rbxassetid://415688274", "rbxassetid://415688354" },
		["FunnyStorm"] = { "rbxassetid://6280934001", "rbxassetid://6280935347", "rbxassetid://6280936575", "rbxassetid://6280938749", "rbxassetid://6280940989", "rbxassetid://6280942402" },
		["Galaxy"] = { "rbxassetid://159454299", "rbxassetid://159454296", "rbxassetid://159454293", "rbxassetid://159454293", "rbxassetid://159454293", "rbxassetid://159454288" },
		["Galaxy2"] = { "rbxassetid://14164368678", "rbxassetid://14164386126", "rbxassetid://14164389230", "rbxassetid://14164398493", "rbxassetid://14164402782", "rbxassetid://14164405298" },
		["Galaxy3"] = { "rbxassetid://14543264135", "rbxassetid://14543358958", "rbxassetid://14543257810", "rbxassetid://14543275895", "rbxassetid://14543280890", "rbxassetid://14543371676" },
		["GreenHaze"] = { "rbxassetid://160193404", "rbxassetid://160193466", "rbxassetid://160193461", "rbxassetid://160193469", "rbxassetid://160193463", "rbxassetid://160193458" },
		["Hell"] = { "rbxassetid://11730840088", "rbxassetid://11730842997", "rbxassetid://11730849615", "rbxassetid://11730852920", "rbxassetid://11730855491", "rbxassetid://11730857150" },
		["Lunar"] = { "rbxassetid://179723991", "rbxassetid://179724005", "rbxassetid://179724018", "rbxassetid://179724029", "rbxassetid://179724037", "rbxassetid://179724054" },
		["LunarNight"] = { "rbxassetid://187713366", "rbxassetid://187712428", "rbxassetid://187712836", "rbxassetid://187713755", "rbxassetid://187714525", "rbxassetid://187712111" },
		["LunarNight2"] = { "rbxassetid://14365026085", "rbxassetid://14365026242", "rbxassetid://14365025735", "rbxassetid://14365025904", "rbxassetid://14365025444", "rbxassetid://14365026442" },
		["MagentaOrange"] = { "rbxassetid://566616113", "rbxassetid://566616232", "rbxassetid://566616141", "rbxassetid://566616044", "rbxassetid://566616082", "rbxassetid://566616187" },
		["Midnight"] = { "rbxassetid://154185004", "rbxassetid://154184960", "rbxassetid://154185021", "rbxassetid://154184943", "rbxassetid://154184972", "rbxassetid://154185031" },
		["Milkyway"] = { "rbxassetid://129876530632297", "rbxassetid://108406529909981", "rbxassetid://104400530594543", "rbxassetid://73372229972523", "rbxassetid://87408857415924", "rbxassetid://137817405681365" },
		["Moon"] = { "rbxassetid://17489386489", "rbxassetid://17489387417", "rbxassetid://17489388310", "rbxassetid://17489389632", "rbxassetid://17489391101", "rbxassetid://17489393055" },
		["Mountains"] = { "rbxassetid://15359410490", "rbxassetid://15359411132", "rbxassetid://15359412131", "rbxassetid://15359411633", "rbxassetid://15359417656", "rbxassetid://15359412677" },
		["Nebula"] = { "rbxassetid://5260808177", "rbxassetid://5260653793", "rbxassetid://5260817288", "rbxassetid://5260800833", "rbxassetid://5260811073", "rbxassetid://5260824661" },
		["Nebula2"] = { "rbxassetid://16932794531", "rbxassetid://16932797813", "rbxassetid://16932800523", "rbxassetid://16932803722", "rbxassetid://16932806825", "rbxassetid://16932810138" },
		["Nebula3"] = { "rbxassetid://17839210699", "rbxassetid://17839215896", "rbxassetid://17839218166", "rbxassetid://17839220800", "rbxassetid://17839223605", "rbxassetid://17839226876" },
		["Nebula4"] = { "rbxassetid://17103618635", "rbxassetid://17103622190", "rbxassetid://17103624898", "rbxassetid://17103628153", "rbxassetid://17103636666", "rbxassetid://17103639457" },
		["Nebula5"] = { "rbxassetid://17124357467", "rbxassetid://17124359797", "rbxassetid://17124362093", "rbxassetid://17124365127", "rbxassetid://17124367200", "rbxassetid://17124369657" },
		["Nebula6"] = { "rbxassetid://16694187412", "rbxassetid://16694190947", "rbxassetid://16694194795", "rbxassetid://16694197080", "rbxassetid://16694200892", "rbxassetid://16694204069" },
		["NetherWorld"] = { "rbxassetid://14365019002", "rbxassetid://14365023350", "rbxassetid://14365018399", "rbxassetid://14365018705", "rbxassetid://14365018143", "rbxassetid://14365019327" },
		["NewYork"] = { "rbxassetid://11333973069", "rbxassetid://11333969768", "rbxassetid://11333964303", "rbxassetid://11333971332", "rbxassetid://11333982864", "rbxassetid://11333967970" },
		["NightMountains"] = { "rbxassetid://264908339", "rbxassetid://264907909", "rbxassetid://264909420", "rbxassetid://264909758", "rbxassetid://264908886", "rbxassetid://264907379" },
		["Orange"] = { "rbxassetid://150939022", "rbxassetid://150939038", "rbxassetid://150939047", "rbxassetid://150939056", "rbxassetid://150939063", "rbxassetid://150939082" },
		["OverPlanet"] = { "rbxassetid://165052268", "rbxassetid://165052286", "rbxassetid://165052328", "rbxassetid://165052365", "rbxassetid://165052306", "rbxassetid://165052345" },
		["Pastel"] = { "rbxassetid://2128458653", "rbxassetid://2128462480", "rbxassetid://2128458653", "rbxassetid://2128462027", "rbxassetid://2128462027", "rbxassetid://2128462236" },
		["Pink"] = { "rbxassetid://271042516", "rbxassetid://271077243", "rbxassetid://271042556", "rbxassetid://271042310", "rbxassetid://271042467", "rbxassetid://271077958" },
		["PinkArt"] = { "rbxassetid://71607054149497", "rbxassetid://78865378050055", "rbxassetid://104560113223878", "rbxassetid://80395333901607", "rbxassetid://87570388049514", "rbxassetid://79190209626172" },
		["PinkMountains"] = { "rbxassetid://160188495", "rbxassetid://160188614", "rbxassetid://160188609", "rbxassetid://160188589", "rbxassetid://160188597", "rbxassetid://160188588" },
		["Pinkie"] = { "rbxassetid://11555017034", "rbxassetid://11555013415", "rbxassetid://11555010145", "rbxassetid://11555006545", "rbxassetid://11555000712", "rbxassetid://11554996247" },
		["Purple"] = { "rbxassetid://8539982183", "rbxassetid://8539981943", "rbxassetid://8539981721", "rbxassetid://8539981424", "rbxassetid://8539980766", "rbxassetid://8539981085" },
		["Purple2"] = { "rbxassetid://8107841671", "rbxassetid://6444884785", "rbxassetid://8107841671", "rbxassetid://8107841671", "rbxassetid://8107841671", "rbxassetid://8107849791" },
		["Purple3"] = { "rbxassetid://433274085", "rbxassetid://433274194", "rbxassetid://433274131", "rbxassetid://433274370", "rbxassetid://433274429", "rbxassetid://433274285" },
		["PurpleClouds"] = { "rbxassetid://570557514", "rbxassetid://570557775", "rbxassetid://570557559", "rbxassetid://570557620", "rbxassetid://570557672", "rbxassetid://570557727" },
		["PurpleMountains"] = { "rbxassetid://17901353811", "rbxassetid://17901366771", "rbxassetid://17901356262", "rbxassetid://17901359687", "rbxassetid://17901362326", "rbxassetid://17901365106" },
		["PurpleNight"] = { "rbxassetid://5260808177", "rbxassetid://5260653793", "rbxassetid://5260817288", "rbxassetid://5260800833", "rbxassetid://5260800833", "rbxassetid://5084576400" },
		["PurplePlanet"] = { "rbxassetid://16262356578", "rbxassetid://16262358026", "rbxassetid://16262360469", "rbxassetid://16262362003", "rbxassetid://16262363873", "rbxassetid://16262366016" },
		["PurpleSpace"] = { "rbxassetid://15983968922", "rbxassetid://15983966825", "rbxassetid://5260817288", "rbxassetid://15983967420", "rbxassetid://15983966246", "rbxassetid://15983964246" },
		["Realistic"] = { "rbxassetid://402559900", "rbxassetid://402559927", "rbxassetid://402559953", "rbxassetid://402559983", "rbxassetid://402560019", "rbxassetid://402560052" },
		["RedNight"] = { "rbxassetid://401664839", "rbxassetid://401664862", "rbxassetid://401664960", "rbxassetid://401664881", "rbxassetid://401664901", "rbxassetid://401664936" },
		["Retro"] = { "rbxassetid://16642396302", "rbxassetid://16642397027", "rbxassetid://16642398372", "rbxassetid://16642399309", "rbxassetid://16642400745", "rbxassetid://16642401907" },
		["Space"] = { "rbxassetid://166509999", "rbxassetid://166510057", "rbxassetid://166510116", "rbxassetid://166510092", "rbxassetid://166510131", "rbxassetid://166510114" },
		["Space2"] = { "rbxassetid://11844076072", "rbxassetid://11844069700", "rbxassetid://11844067209", "rbxassetid://11844063543", "rbxassetid://11844058446", "rbxassetid://11844053742" },
		["Storm"] = { "rbxassetid://1618912481", "rbxassetid://1618913943", "rbxassetid://1618913244", "rbxassetid://1618912849", "rbxassetid://1618911568", "rbxassetid://1618913654" },
		["Valentines"] = { "rbxassetid://11427769401", "rbxassetid://11427770685", "rbxassetid://11427769401", "rbxassetid://11427769401", "rbxassetid://11427769401", "rbxassetid://11427771954" },
		["Winter"] = { "rbxassetid://155657655", "rbxassetid://155674246", "rbxassetid://155657609", "rbxassetid://155657671", "rbxassetid://155657619", "rbxassetid://155674931" },
	}
	local SkyboxSettings = {
		["Aesthetic"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Aesthetic2"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Aesthetic3"] = { StarCount = 500, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["AestheticMountains"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Alien"] = { StarCount = 0, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Ame"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Antartica"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Art"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Beach"] = { StarCount = 0, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["BetterNight"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["BetterNight2"] = { StarCount = 3000, Sun = 0, Moon = 1.5, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["BetterNight3"] = { StarCount = 500, Sun = 21, Moon = 1.5, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["BetterSky"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Blizzard"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["BlueClouds"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["BluePlanet"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["BlueSpace"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Cloudy"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["DarkClouds"] = { StarCount = 0, Sun = 0, Moon = 1.5, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["DarkMountains"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["DarkishPink"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Dawn"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 6.5, Ambient = Color3.fromRGB(170,135,115) },
		["FPSBoost"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["FakeClouds"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Flame"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 18.5, Ambient = Color3.fromRGB(145,95,120) },
		["FlamingSunset"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 18.5, Ambient = Color3.fromRGB(145,95,120) },
		["FunnyStorm"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Galaxy"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Galaxy2"] = { StarCount = 500, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Galaxy3"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["GreenHaze"] = { StarCount = 0, Sun = 0, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Hell"] = { StarCount = 3000, Sun = 0, Moon = 11, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Lunar"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["LunarNight"] = { StarCount = 0, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["LunarNight2"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["MagentaOrange"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Midnight"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Milkyway"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Moon"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Mountains"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Nebula"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Nebula2"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Nebula3"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Nebula4"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Nebula5"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Nebula6"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["NetherWorld"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["NewYork"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["NightMountains"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Orange"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["OverPlanet"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Pastel"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Pink"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PinkArt"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PinkMountains"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Pinkie"] = { StarCount = 0, Sun = 0, Moon = 1.5, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Purple"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Purple2"] = { StarCount = 3000, Sun = 11, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Purple3"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PurpleClouds"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PurpleMountains"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PurpleNight"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["PurplePlanet"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["PurpleSpace"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Realistic"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["RedNight"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Retro"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Space"] = { StarCount = 3000, Sun = 0, Moon = 0, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Space2"] = { StarCount = 3000, Sun = 11, Moon = 20, Clock = 0, Ambient = Color3.fromRGB(40,45,60) },
		["Storm"] = { StarCount = 0, Sun = 0, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Valentines"] = { StarCount = 3000, Sun = 21, Moon = 0, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
		["Winter"] = { StarCount = 3000, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(140,140,150) },
	}
	local skyNames = {
		"Aesthetic",
		"Aesthetic2",
		"Aesthetic3",
		"AestheticMountains",
		"Alien",
		"Ame",
		"Antartica",
		"Art",
		"Beach",
		"BetterNight",
		"BetterNight2",
		"BetterNight3",
		"BetterSky",
		"Blizzard",
		"BlueClouds",
		"BluePlanet",
		"BlueSpace",
		"Cloudy",
		"DarkClouds",
		"DarkMountains",
		"DarkishPink",
		"Dawn",
		"FPSBoost",
		"FakeClouds",
		"Flame",
		"FlamingSunset",
		"FunnyStorm",
		"Galaxy",
		"Galaxy2",
		"Galaxy3",
		"GreenHaze",
		"Hell",
		"Lunar",
		"LunarNight",
		"LunarNight2",
		"MagentaOrange",
		"Midnight",
		"Milkyway",
		"Moon",
		"Mountains",
		"Nebula",
		"Nebula2",
		"Nebula3",
		"Nebula4",
		"Nebula5",
		"Nebula6",
		"NetherWorld",
		"NewYork",
		"NightMountains",
		"Orange",
		"OverPlanet",
		"Pastel",
		"Pink",
		"PinkArt",
		"PinkMountains",
		"Pinkie",
		"Purple",
		"Purple2",
		"Purple3",
		"PurpleClouds",
		"PurpleMountains",
		"PurpleNight",
		"PurplePlanet",
		"PurpleSpace",
		"Realistic",
		"RedNight",
		"Retro",
		"Space",
		"Space2",
		"Storm",
		"Valentines",
		"Winter",
	}
	local skySaved = {}
	local skyState = { Enabled = false, Name = "Aesthetic" }
	local skyOrig = {}

	local function getArchSky()
		local sky = Lighting:FindFirstChild("ArchSky")
		if sky and sky:IsA("Sky") then return sky end
		sky = Instance.new("Sky")
		sky.Name = "ArchSky"
		return sky
	end

	local function restoreGameSkies()
		for sky, parent in pairs(skySaved) do
			if sky and parent then
				pcall(function() sky.Parent = parent end)
			end
			skySaved[sky] = nil
		end
		for prop, val in pairs(skyOrig) do
			pcall(function() Lighting[prop] = val end)
			skyOrig[prop] = nil
		end
	end

	local function applySky(name, enabled)
		local sky = getArchSky()
		local ids = Skyboxes[name]
		local settings = SkyboxSettings[name] or { StarCount = 0, Sun = 21, Moon = 11, Clock = 14, Ambient = Color3.fromRGB(128,128,128) }
		if not ids then
			Library:Notify("Unknown sky: " .. tostring(name))
			return
		end

		sky.SkyboxBk = ids[1]
		sky.SkyboxDn = ids[2]
		sky.SkyboxFt = ids[3]
		sky.SkyboxLf = ids[4]
		sky.SkyboxRt = ids[5]
		sky.SkyboxUp = ids[6]
		sky.StarCount = settings.StarCount or 0
		sky.SunAngularSize = settings.Sun or 21
		sky.MoonAngularSize = settings.Moon or 11
		sky.CelestialBodiesShown = true

		if not enabled then
			sky.Parent = nil
			restoreGameSkies()
			return
		end

		for _, prop in ipairs({"ClockTime", "Ambient", "OutdoorAmbient"}) do
			if skyOrig[prop] == nil then
				skyOrig[prop] = Lighting[prop]
			end
		end
		Lighting.ClockTime = settings.Clock or 14
		Lighting.Ambient = settings.Ambient
		Lighting.OutdoorAmbient = settings.Ambient

		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("Sky") and obj ~= sky then
				skySaved[obj] = obj.Parent
				obj.Parent = nil
			end
		end
		sky.Parent = Lighting
	end

	Lighting.ChildAdded:Connect(function(obj)
		if skyState.Enabled and obj:IsA("Sky") and obj.Name ~= "ArchSky" then
			skySaved[obj] = Lighting
			task.defer(function()
				if skyState.Enabled and obj.Parent then
					obj.Parent = nil
				end
			end)
		end
	end)

	SkyBox:AddToggle("SkyOn", {
		Text = "Enabled", Default = false,
		Callback = function(v)
			skyState.Enabled = v
			applySky(skyState.Name, v)
			Library:Notify(v and ("Skybox: " .. skyState.Name) or "Skybox OFF")
		end,
	})
	SkyBox:AddDropdown("SkySelect", {
		Values = skyNames,
		Default = 1,
		Text = "Skybox",
		Callback = function(v)
			skyState.Name = v
			if skyState.Enabled then
				applySky(v, true)
				Library:Notify("Skybox: " .. v)
			end
		end,
	})

	-- Weather (Lion-style multi-layer particles)
	----------------------------------------------------------------
	local WeatherBox = Tabs.World:AddRightGroupbox("Weather")
	local WeatherTextures = {
		Rain = "rbxassetid://241876422",
		Mist = "rbxassetid://130207970",
		Snow = "rbxassetid://241594419",
	}
	local WeatherPresets = {
		["Heavy Rain"] = {
			Layers = {
				{Texture = WeatherTextures.Rain, Rate = 850, Speed = 125, Lifetime = 0.75, Spread = 3, Size = 0.075, Color = Color3.fromRGB(185, 205, 255), Acceleration = Vector3.new(0, -360, 0), Transparency = 0.05},
				{Texture = WeatherTextures.Mist, Rate = 35, Speed = 7, Lifetime = 3.5, Spread = 35, Size = 0.45, Color = Color3.fromRGB(150, 160, 170), Acceleration = Vector3.new(8, -4, 0), Transparency = 0.82},
			}
		},
		["Rain"] = {
			Layers = {
				{Texture = WeatherTextures.Rain, Rate = 420, Speed = 105, Lifetime = 0.85, Spread = 4, Size = 0.065, Color = Color3.fromRGB(195, 215, 255), Acceleration = Vector3.new(0, -300, 0), Transparency = 0.08},
				{Texture = WeatherTextures.Mist, Rate = 18, Speed = 6, Lifetime = 3.3, Spread = 35, Size = 0.38, Color = Color3.fromRGB(175, 185, 195), Acceleration = Vector3.new(4, -3, 0), Transparency = 0.86},
			}
		},
		["Snow"] = {
			Layers = {
				{Texture = WeatherTextures.Snow, Rate = 180, Speed = 16, Lifetime = 5, Spread = 60, Size = 0.35, Color = Color3.fromRGB(255, 255, 255), Acceleration = Vector3.new(12, -28, 0), Transparency = 0.05},
				{Texture = WeatherTextures.Mist, Rate = 35, Speed = 8, Lifetime = 5, Spread = 90, Size = 1.1, Color = Color3.fromRGB(235, 240, 255), Acceleration = Vector3.new(4, -4, 0), Transparency = 0.8},
			}
		},
		["Dust"] = {
			Layers = {
				{Texture = WeatherTextures.Mist, Rate = 90, Speed = 18, Lifetime = 4, Spread = 70, Size = 0.55, Color = Color3.fromRGB(210, 185, 140), Acceleration = Vector3.new(25, -6, 10), Transparency = 0.55},
				{Texture = WeatherTextures.Mist, Rate = 55, Speed = 12, Lifetime = 5, Spread = 90, Size = 0.9, Color = Color3.fromRGB(190, 160, 110), Acceleration = Vector3.new(40, -3, 5), Transparency = 0.75},
				{Texture = WeatherTextures.Snow, Rate = 40, Speed = 10, Lifetime = 3.5, Spread = 50, Size = 0.12, Color = Color3.fromRGB(180, 150, 100), Acceleration = Vector3.new(30, -8, 8), Transparency = 0.4},
			}
		},
		["Sandstorm"] = {
			Layers = {
				{Texture = WeatherTextures.Mist, Rate = 140, Speed = 35, Lifetime = 2.5, Spread = 45, Size = 0.7, Color = Color3.fromRGB(200, 165, 100), Acceleration = Vector3.new(80, -4, 20), Transparency = 0.5},
				{Texture = WeatherTextures.Mist, Rate = 80, Speed = 28, Lifetime = 3, Spread = 60, Size = 1.2, Color = Color3.fromRGB(170, 130, 80), Acceleration = Vector3.new(95, -2, 15), Transparency = 0.7},
			}
		},
	}
	local weatherNames = {"Heavy Rain", "Rain", "Snow", "Dust", "Sandstorm"}
	local weatherState = { Enabled = false, Name = "Rain", Part = nil, Emitters = {} }

	local function clearWeather()
		pcall(function() RunService:UnbindFromRenderStep("ArchWeather") end)
		for _, e in ipairs(weatherState.Emitters) do
			pcall(function() e:Destroy() end)
		end
		table.clear(weatherState.Emitters)
		if weatherState.Part then
			pcall(function() weatherState.Part:Destroy() end)
			weatherState.Part = nil
		end
	end

	local function applyWeather(name)
		clearWeather()
		local preset = WeatherPresets[name] or WeatherPresets.Rain
		local part = Instance.new("Part")
		part.Name = "ArchWeather"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.new(220, 1, 220)
		part.Parent = workspace
		weatherState.Part = part

		for _, layer in ipairs(preset.Layers) do
			local emitter = Instance.new("ParticleEmitter")
			emitter.Name = "WeatherLayer"
			emitter.Texture = layer.Texture
			emitter.Rate = layer.Rate or 100
			emitter.Speed = NumberRange.new(layer.Speed or 20)
			emitter.Lifetime = NumberRange.new(layer.Lifetime or 2)
			emitter.SpreadAngle = Vector2.new(layer.Spread or 0, layer.Spread or 0)
			emitter.Size = NumberSequence.new(layer.Size or 0.2)
			emitter.Color = ColorSequence.new(layer.Color or Color3.new(1, 1, 1))
			emitter.Transparency = NumberSequence.new(layer.Transparency or 0)
			emitter.Acceleration = layer.Acceleration or Vector3.new(0, -100, 0)
			emitter.Drag = 1
			emitter.LightEmission = 0
			emitter.LightInfluence = 0
			emitter.RotSpeed = NumberRange.new(0)
			emitter.Rotation = NumberRange.new(0, 360)
			emitter.EmissionDirection = Enum.NormalId.Bottom
			pcall(function()
				emitter.Shape = Enum.ParticleEmitterShape.Box
				emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			end)
			emitter.Enabled = true
			emitter.Parent = part
			table.insert(weatherState.Emitters, emitter)
		end

		RunService:BindToRenderStep("ArchWeather", Enum.RenderPriority.Camera.Value + 2, function()
			local cam = workspace.CurrentCamera
			if cam and part and part.Parent then
				part.CFrame = cam.CFrame * CFrame.new(0, 40, 0)
			end
		end)
	end

	WeatherBox:AddToggle("WeatherOn", {
		Text = "Enabled", Default = false,
		Callback = function(v)
			weatherState.Enabled = v
			if v then
				applyWeather(weatherState.Name)
				Library:Notify("Weather: " .. weatherState.Name)
			else
				clearWeather()
				Library:Notify("Weather OFF")
			end
		end,
	})
	WeatherBox:AddDropdown("WeatherType", {
		Values = weatherNames,
		Default = 2,
		Text = "Type",
		Callback = function(v)
			weatherState.Name = v
			if weatherState.Enabled then
				applyWeather(v)
				Library:Notify("Weather: " .. v)
			end
		end,
	})

	-- Ambience (Lion)
	----------------------------------------------------------------
	local AmbBox = Tabs.World:AddRightGroupbox("Ambience")
	local AmbiencePresets = {
		["Heavy Rain"] = "rbxassetid://9112823512",
		["Rain"] = "rbxassetid://9112823512",
		["City"] = "rbxassetid://1842610496",
		["Windy Day"] = "rbxassetid://9112828467",
		["Forest Rain Night"] = "rbxassetid://9112823512",
		["Light Rain And Thunder"] = "rbxassetid://9112823512",
	}
	local ambNames = {}
	for n in pairs(AmbiencePresets) do table.insert(ambNames, n) end
	table.sort(ambNames)

	AmbBox:AddToggle("AmbOn", {
		Text = "Ambience", Default = false,
		Callback = function(v)
			if State.AmbienceSound then
				pcall(function() State.AmbienceSound:Stop() State.AmbienceSound:Destroy() end)
				State.AmbienceSound = nil
			end
			if v then
				local s = Instance.new("Sound")
				s.Name = "ArchAmbience"
				s.Looped = true
				s.Volume = 0.5
				s.SoundId = AmbiencePresets["Rain"]
				s.Parent = SoundService
				s:Play()
				State.AmbienceSound = s
			end
		end,
	})
	AmbBox:AddDropdown("AmbSelect", {
		Values = ambNames,
		Default = 1,
		Text = "Selected",
		Callback = function(v)
			if State.AmbienceSound then
				State.AmbienceSound.SoundId = AmbiencePresets[v] or AmbiencePresets.Rain
				State.AmbienceSound:Play()
			end
		end,
	})
	AmbBox:AddSlider("AmbVol", {
		Text = "Volume", Min = 0, Max = 2, Default = 0.5, Rounding = 2,
		Callback = function(v)
			if State.AmbienceSound then State.AmbienceSound.Volume = v end
		end,
	})

	----------------------------------------------------------------
	-- Effects blur
	----------------------------------------------------------------
	local FXBox = Tabs.World:AddRightGroupbox("Effects")
	FXBox:AddToggle("BlurOn", {
		Text = "Blur", Default = false,
		Callback = function(v)
			local e = getEffect("BlurEffect", "ArchBlur")
			e.Parent = Lighting
			e.Enabled = v
		end,
	})
	FXBox:AddSlider("BlurSize", {
		Text = "Blur Size", Min = 0, Max = 56, Default = 0, Rounding = 0,
		Callback = function(v) setProp(getEffect("BlurEffect", "ArchBlur"), "Size", v) end,
	})

	----------------------------------------------------------------
	-- Camera (Lion FOV / aspect / stretcher)
	----------------------------------------------------------------
	local CamBox = Tabs.World:AddRightGroupbox("Camera")
	CamBox:AddToggle("FOVOn", {
		Text = "FOV Changer", Default = false,
		Callback = function(v)
			local cam = workspace.CurrentCamera
			if v then
				State.OriginalFOV = cam.FieldOfView
				cam.FieldOfView = getgenv().ArchFOV or 90
			else
				if State.OriginalFOV then cam.FieldOfView = State.OriginalFOV end
			end
		end,
	})
	CamBox:AddSlider("FOVVal", {
		Text = "FOV", Min = 1, Max = 120, Default = 90, Rounding = 0,
		Callback = function(v)
			getgenv().ArchFOV = v
			if Toggles.FOVOn and Toggles.FOVOn.Value then
				workspace.CurrentCamera.FieldOfView = v
			end
		end,
	})
	CamBox:AddToggle("Stretcher", {
		Text = "Stretcher / Aspect", Default = false,
		Callback = function(v)
			if getgenv()._ArchStretch then
				pcall(function() getgenv()._ArchStretch:Disconnect() end)
				getgenv()._ArchStretch = nil
			end
			if v then
				local s = getgenv().ArchStretchScale or 0.81
				getgenv()._ArchStretch = RunService.RenderStepped:Connect(function()
					local cam = workspace.CurrentCamera
					cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, s, 0, 0, 0, 1)
				end)
			end
		end,
	})
	CamBox:AddSlider("StretchScale", {
		Text = "Aspect Scale", Min = 0.5, Max = 1.2, Default = 0.81, Rounding = 2,
		Callback = function(v) getgenv().ArchStretchScale = v end,
	})

	----------------------------------------------------------------
	-- Anti FX (Lion)
	----------------------------------------------------------------
	local AntiBox = Tabs.World:AddRightGroupbox("Anti FX")
	getgenv().ArchAnti = getgenv().ArchAnti or { Flash = false, Smoke = false }
	AntiBox:AddToggle("AntiFlash", {
		Text = "Anti Flashbang", Default = false,
		Callback = function(v)
			getgenv().ArchAnti.Flash = v
			pcall(function()
				local Flashed = require(LP.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.Flashed)
				if Flashed and Flashed.Flash and not State.OriginalFlash then
					State.OriginalFlash = Flashed.Flash
					Flashed.Flash = function(...)
						if getgenv().ArchAnti.Flash then return end
						return State.OriginalFlash(...)
					end
				end
			end)
		end,
	})
	AntiBox:AddToggle("AntiSmoke", {
		Text = "Anti Smoke", Default = false,
		Callback = function(v)
			getgenv().ArchAnti.Smoke = v
		end,
	})
end


------------------------------------------------------------------------
-- VISUALS (full Lion port)
------------------------------------------------------------------------
do
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local RS = game:GetService("ReplicatedStorage")
	local SoundService = game:GetService("SoundService")
	local LP = Players.LocalPlayer
	local Camera = Workspace.CurrentCamera

	local materials = {
		"ForceField","Asphalt","Basalt","Brick","Cardboard","Carpet","CeramicTiles",
		"ClayRoofTiles","Cobblestone","Concrete","CorrodedMetal","CrackedLava",
		"DiamondPlate","Fabric","Foil","Glass","Glacier","Granite","Grass","Ground",
		"Ice","LeafyGrass","Limestone","Marble","Metal","Mud","Neon","Pavement",
		"Pebble","Plastic","Rock","RoofShingles","Rubber","Salt","Sand","Sandstone",
		"Slate","SmoothPlastic","Snow","Wood","WoodPlanks",
	}

	getgenv().ArchVis = getgenv().ArchVis or {
		Appearance = false, Color = Color3.new(1,1,1), Material = "ForceField",
		Wireframe = false, DisableTextures = false, Transparency = 1,
		ArmAppearance = false, ArmColor = Color3.new(1,1,1), ArmMaterial = "ForceField",
		ArmDisableClothes = false, ArmTransparency = 1,
		Offset = false, OX = 0, OY = 0, OZ = 0,
		OverrideFPS = false, FPS = 60, RecoilPercent = 100,
		Chams = false, ChamColor = Color3.new(1,1,1), ChamFill = 0.02, ChamOutline = 0.01,
		RemoveVignette = false,
		Crosshair = false,
		CrosshairColor1 = Color3.new(1,1,1), CrosshairColor2 = Color3.new(1,1,1),
		CrosshairColor3 = Color3.new(1,1,1), CrosshairColor4 = Color3.new(1,1,1),
		CrosshairOutline = true,
		CrosshairOutlineColor1 = Color3.new(0,0,0), CrosshairOutlineColor2 = Color3.new(0,0,0),
		CrosshairOutlineColor3 = Color3.new(0,0,0), CrosshairOutlineColor4 = Color3.new(0,0,0),
		CrosshairSize = 8, CrosshairGap = 4, CrosshairThick = 1.5, CrosshairLength = 8,
		CrosshairRot = 0, CrosshairRotSpeed = 0, CrosshairMovingRot = false,
		CrosshairBounce = false, CrosshairBounceSpeed = 2, CrosshairOffset = 0,
		CrosshairLerp = 1, CrosshairDisableGame = true,
		CrosshairMode = "Center",
		Tracers = false, TracerColor = Color3.new(1,1,1),
		HitSounds = false, HitSound = "sparkle", HitVolume = 1,
	}
	local V = getgenv().ArchVis

	----------------------------------------------------------------
	-- Viewmodel helpers
	----------------------------------------------------------------
	local function getVMRoot()
		local vms = Workspace:FindFirstChild("ViewModels")
		return vms and (vms:FindFirstChild("FirstPerson") or vms)
	end
	local function isArm(n)
		n = string.lower(n or "")
		return n:find("arm",1,true) or n:find("hand",1,true) or n:find("glove",1,true) or n:find("shirt",1,true)
	end
	local function applyPart(part, color, matName, wire, noTex, trans)
		if not part:IsA("BasePart") then return end
		pcall(function()
			if color then part.Color = color end
			if matName then
				local ok, mat = pcall(function() return Enum.Material[matName] end)
				if ok and mat then part.Material = mat end
			end
			if wire then part.Material = Enum.Material.ForceField end
			if noTex then
				for _, d in ipairs(part:GetDescendants()) do
					if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
				end
			end
			if trans ~= nil then part.Transparency = math.clamp(trans, 0, 1) end
		end)
	end
	local function refreshViewmodel()
		local root = getVMRoot()
		if not root then return end
		for _, model in ipairs(root:GetChildren()) do
			for _, d in ipairs(model:GetDescendants()) do
				if d:IsA("BasePart") then
					local arm = isArm(d.Name) or isArm(d.Parent and d.Parent.Name)
					if arm and V.ArmAppearance then
						applyPart(d, V.ArmColor, V.ArmMaterial, V.Wireframe, V.DisableTextures, 1 - V.ArmTransparency)
					elseif (not arm) and V.Appearance then
						applyPart(d, V.Color, V.Material, V.Wireframe, V.DisableTextures, 1 - V.Transparency)
					end
				elseif V.ArmDisableClothes and (d:IsA("Clothing") or d:IsA("Shirt") or d:IsA("Pants")) then
					pcall(function() d:Destroy() end)
				end
			end
			if V.Offset and model:IsA("Model") then
				pcall(function()
					if model.PrimaryPart then
						model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame * CFrame.new(V.OX, V.OY, V.OZ))
					end
				end)
			end
		end
		if V.OverrideFPS and setfpscap then
			pcall(setfpscap, V.FPS)
		end
	end
	task.spawn(function()
		while task.wait(0.15) do
			if V.Appearance or V.ArmAppearance or V.Wireframe or V.Offset or V.OverrideFPS then
				pcall(refreshViewmodel)
			end
		end
	end)

	----------------------------------------------------------------
	-- Skin Changer
	----------------------------------------------------------------
	do
		local SkinBox = Tabs.Visuals:AddLeftGroupbox("Skin Changer")
		local skinState = {
			Open = false,
			Gui = nil,
			Mode = "Skin",
			SelectedWeapon = nil,
			SelectedCosmetic = nil,
			WeaponSearch = "",
			CosmeticSearch = "",
			Equip = {},
			Weapons = {},
			Cosmetics = {},
		}
		getgenv().NemesisSkinEquip = skinState.Equip

		local clib, ilib, dctrl, coss, oget, ogetwep
		local hooked = false

		local function banned(n)
			if type(n) ~= "string" then return true end
			return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll") or n:find("Fall Apart")
		end

		local function ensureLibs()
			if hooked and dctrl and clib and coss then return true end
			local ok, err = pcall(function()
				local rs = game:GetService("ReplicatedStorage")
				local mods = rs:WaitForChild("Modules", 10)
				local lp = game:GetService("Players").LocalPlayer
				local lps = lp:WaitForChild("PlayerScripts", 10)
				local ctrls = lps:WaitForChild("Controllers", 10)

				clib = require(mods:WaitForChild("CosmeticLibrary", 8))
				ilib = require(mods:WaitForChild("ItemLibrary", 8))
				dctrl = require(ctrls:WaitForChild("PlayerDataController", 8))
				assert(clib and clib.Cosmetics, "CosmeticLibrary missing")
				assert(dctrl, "PlayerDataController missing")

				coss = clib.Cosmetics
				oget = dctrl.Get
				ogetwep = dctrl.GetWeaponData

				local finv = {}
				local function rebuildinv()
					for k in pairs(finv) do finv[k] = nil end
					for _, cos in pairs(skinState.Equip) do
						for _, cd in pairs(cos) do
							if cd and cd.Name and not banned(cd.Name) then
								finv[cd.Name] = cd
							end
						end
					end
				end
				skinState._rebuildinv = rebuildinv

				dctrl.Get = function(self, key, ...)
					local data = oget(self, key, ...)
					if key == "CosmeticInventory" then
						local proxy = {}
						if type(data) == "table" then
							for k, v in pairs(data) do
								if not banned(tostring(k)) then proxy[k] = v end
							end
						end
						for name, cosmetic in pairs(finv) do
							proxy[name] = cosmetic
						end
						return proxy
					end
					return data
				end

				dctrl.GetWeaponData = function(self, wname, ...)
					local data = ogetwep(self, wname, ...)
					if type(data) ~= "table" then return data end
					local merged = {}
					for k, v in pairs(data) do merged[k] = v end
					local weq = skinState.Equip[wname]
					if not weq then
						local low = tostring(wname):lower()
						for k, v in pairs(skinState.Equip) do
							if tostring(k):lower() == low then weq = v break end
						end
					end
					if weq then
						for _, ct in ipairs({ "Skin", "Wrap", "Charm", "Finisher" }) do
							if weq[ct] then merged[ct] = weq[ct] end
						end
						if weq.Skin and weq.Skin.ViewModelName then
							merged.ViewModelName = weq.Skin.ViewModelName
						end
					end
					return merged
				end

				-- EquipCosmetic hook
				pcall(function()
					if getgenv().__NemesisSkinEquipHooked then return end
					local eqrem = rs.Remotes and rs.Remotes.Data and rs.Remotes.Data.EquipCosmetic
					if not eqrem or not hookfunction then return end
					getgenv().__NemesisSkinEquipHooked = true
					local oldFire
					oldFire = hookfunction(eqrem.FireServer, newcclosure(function(self, ...)
						if self ~= eqrem then return oldFire(self, ...) end
						local args = { ... }
						local wname, ctype, cname = args[1], args[2], args[3]
						if type(wname) == "string" and type(ctype) == "string" and type(cname) == "string"
							and cname ~= "" and cname ~= "None" then
							local equip = getgenv().NemesisSkinEquip or skinState.Equip
							equip[wname] = equip[wname] or {}
							local base = coss and coss[cname]
							local cloned = {}
							if type(base) == "table" then
								for k, v in pairs(base) do cloned[k] = v end
							end
							cloned.Name = cname
							cloned.Type = ctype
							cloned.Owned = true
							cloned.Unlocked = true
							equip[wname][ctype] = cloned
							if skinState._rebuildinv then pcall(skinState._rebuildinv) end
							local inv = oget(dctrl, "CosmeticInventory")
							local owned = inv and inv[cname] ~= nil and type(inv[cname]) ~= "boolean"
							if not owned then return end
						end
						return oldFire(self, ...)
					end))
				end)

				-- ClientViewModel inject
				pcall(function()
					if getgenv().__NemesisSkinVMHooked then return end
					local lp = game:GetService("Players").LocalPlayer
					local path = lp.PlayerScripts:FindFirstChild("Modules")
						and lp.PlayerScripts.Modules:FindFirstChild("ClientReplicatedClasses")
						and lp.PlayerScripts.Modules.ClientReplicatedClasses:FindFirstChild("ClientFighter")
						and lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter:FindFirstChild("ClientItem")
						and lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
					if not path then return end
					local mod = require(path)
					if type(mod) ~= "table" or type(mod.new) ~= "function" then return end
					getgenv().__NemesisSkinVMHooked = true
					local oldNew = mod.new
					mod.new = function(rdata, cliitm)
						local wname
						pcall(function()
							wname = (cliitm and (cliitm.Name or (cliitm.Get and cliitm:Get("Name"))))
								or (rdata and rdata.Name)
						end)
						local equip = getgenv().NemesisSkinEquip or skinState.Equip
						local cos = wname and equip and equip[wname]
						if not cos and wname and equip then
							local low = tostring(wname):lower()
							for k, v in pairs(equip) do
								if tostring(k):lower() == low then cos = v break end
							end
						end
						if cos and type(rdata) == "table" then
							pcall(function()
								local slot = rdata.Data or rdata
								if type(slot) == "table" then
									if cos.Skin then slot.Skin = cos.Skin end
									if cos.Wrap then slot.Wrap = cos.Wrap end
									if cos.Charm then slot.Charm = cos.Charm end
									if cos.Finisher then slot.Finisher = cos.Finisher end
								end
							end)
						end
						local okVM, res = pcall(oldNew, rdata, cliitm)
						if not okVM then return oldNew(rdata, cliitm) end
						return res
					end
				end)

				hooked = true
			end)
			if not ok then
				warn("[NemesisHub] Skin:", err)
				return false
			end
			return hooked
		end

		local function clonecos(name, ctype)
			if not coss or not coss[name] then return nil end
			local cloned = {}
			for k, v in pairs(coss[name]) do cloned[k] = v end
			cloned.Name = name
			cloned.Type = cloned.Type or ctype
			cloned.Owned = true
			cloned.Unlocked = true
			return cloned
		end

		local function forceUpdate(weapon)
			task.spawn(function()
				getgenv().NemesisSkinEquip = skinState.Equip
				if skinState._rebuildinv then pcall(skinState._rebuildinv) end
				pcall(function()
					local weq = skinState.Equip[weapon]
					if not weq then return end
					local eq = game:GetService("ReplicatedStorage").Remotes.Data.EquipCosmetic
					for _, ct in ipairs({ "Skin", "Wrap", "Charm", "Finisher" }) do
						local cd = weq[ct]
						if cd and cd.Name then
							pcall(function() eq:FireServer(weapon, ct, cd.Name, {}) end)
						end
					end
				end)
				pcall(function()
					local FC = require(LP.PlayerScripts.Controllers.FighterController)
					local fighter = FC.LocalFighter
					if not fighter then return end
					local function iname(item)
						local n
						pcall(function() n = item.Name or (item.Get and item:Get("Name")) end)
						return n and tostring(n)
					end
					local eq = fighter.EquippedItem
					if eq and tostring(iname(eq) or ""):lower() == tostring(weapon):lower() then
						local slot = 1
						pcall(function() slot = eq.Slot or eq:Get("Slot") or 1 end)
						pcall(function() if fighter.UnequipItem then fighter:UnequipItem() end end)
						task.wait(0.05)
						pcall(function() fighter:EquipItem(slot) end)
					end
				end)
			end)
		end

		local function applyCosmetic(weapon, cosmeticName, ctype)
			if not weapon or weapon == "" then
				Library:Notify("Select a weapon first")
				return false
			end
			if not ensureLibs() then
				Library:Notify("Skin modules failed — rejoin")
				return false
			end
			ctype = ctype or skinState.Mode or "Skin"
			skinState.Equip[weapon] = skinState.Equip[weapon] or {}
			if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
				skinState.Equip[weapon][ctype] = nil
			else
				local cloned = clonecos(cosmeticName, ctype)
				if not cloned then
					cloned = { Name = cosmeticName, Type = ctype, Owned = true, Unlocked = true }
					if coss and coss[cosmeticName] then
						for k, v in pairs(coss[cosmeticName]) do
							if cloned[k] == nil then cloned[k] = v end
						end
					end
				end
				skinState.Equip[weapon][ctype] = cloned
			end
			if skinState.Equip[weapon] and not next(skinState.Equip[weapon]) then
				skinState.Equip[weapon] = nil
			end
			getgenv().NemesisSkinEquip = skinState.Equip
			forceUpdate(weapon)
			return true
		end

		local function cosmeticMatchesWeapon(data, weapon)
			if not data then return false end
			local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
			if not itemName or tostring(itemName) == "" then
				return data.Type ~= "Skin"
			end
			local w = tostring(weapon or ""):lower()
			local i = tostring(itemName):lower()
			if i == w or i:find(w, 1, true) or w:find(i, 1, true) then return true end
			return false
		end

		local function rebuildLists()
			skinState.Weapons = {}
			skinState.Cosmetics = {}
			if not ensureLibs() then return end
			pcall(function()
				local items = ilib.ItemsAlphabetized or ilib.Items or {}
				local seen = {}
				for k, v in pairs(items) do
					local n = type(v) == "table" and (v.Name or v.ItemName) or (type(k) == "string" and k)
					if n and not seen[n] and not banned(tostring(n)) then
						seen[n] = true
						table.insert(skinState.Weapons, { Name = tostring(n), Display = tostring(n) })
					end
				end
			end)
			table.sort(skinState.Weapons, function(a, b) return a.Display < b.Display end)
			pcall(function()
				local mode = skinState.Mode or "Skin"
				local weapon = skinState.SelectedWeapon
				for name, data in pairs(coss or {}) do
					if type(data) == "table" and not banned(name) then
						local dtype = data.Type or data.CosmeticType or mode
						if tostring(dtype) == mode or (mode == "Skin" and (dtype == "Skin" or not data.Type)) then
							if mode ~= "Skin" or not weapon or cosmeticMatchesWeapon(data, weapon) then
								table.insert(skinState.Cosmetics, {
									Name = name,
									Display = data.DisplayName or name,
									Data = data,
								})
							end
						end
					end
				end
			end)
			table.sort(skinState.Cosmetics, function(a, b) return a.Display < b.Display end)
		end

		local function makeGui()
			if skinState.Gui then return skinState.Gui end
			local UIS = game:GetService("UserInputService")
			local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
			local parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
			local sg = Instance.new("ScreenGui")
			sg.Name = "NemesisSkinChanger"
			sg.ResetOnSpawn = false
			sg.IgnoreGuiInset = true
			sg.DisplayOrder = 999
			sg.Parent = parent

			local W = isMobile and 340 or 780
			local H = isMobile and 500 or 720
			local tileW = isMobile and 100 or 120
			local tileH = isMobile and 100 or 110
			local cols = isMobile and 3 or 5

			local gui = Instance.new("Frame")
			gui.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
			gui.BorderSizePixel = 0
			gui.AnchorPoint = Vector2.new(0.5, 0.5)
			gui.Position = UDim2.fromScale(0.5, 0.5)
			gui.Size = UDim2.fromOffset(W, H)
			gui.Visible = false
			gui.Active = true
			gui.Parent = sg
			Instance.new("UICorner", gui).CornerRadius = UDim.new(0, 8)
			skinState.Gui = gui

			local dragging, dragStart, startPos = false, nil, nil
			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = gui.Position
				end
			end)
			gui.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if not dragging then return end
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local d = input.Position - dragStart
					gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				end
			end)

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, -100, 0, 36)
			title.Position = UDim2.fromOffset(12, 6)
			title.BackgroundTransparency = 1
			title.Text = "Skin Changer"
			title.TextColor3 = Color3.fromRGB(230, 230, 230)
			title.Font = Enum.Font.Code
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = gui

			local close = Instance.new("TextButton")
			close.Size = UDim2.fromOffset(32, 28)
			close.Position = UDim2.new(1, -40, 0, 8)
			close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			close.Text = "X"
			close.TextColor3 = Color3.new(1, 1, 1)
			close.Font = Enum.Font.Code
			close.Parent = gui
			Instance.new("UICorner", close).CornerRadius = UDim.new(0, 4)

			local reset = Instance.new("TextButton")
			reset.Size = UDim2.fromOffset(52, 28)
			reset.Position = UDim2.new(1, -96, 0, 8)
			reset.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			reset.Text = "Reset"
			reset.TextColor3 = Color3.new(1, 1, 1)
			reset.Font = Enum.Font.Code
			reset.TextSize = 12
			reset.Parent = gui
			Instance.new("UICorner", reset).CornerRadius = UDim.new(0, 4)

			local modes = { "Skin", "Wrap", "Charm", "Finisher" }
			local modeBar = Instance.new("Frame")
			modeBar.Size = UDim2.new(1, -16, 0, 30)
			modeBar.Position = UDim2.fromOffset(8, 42)
			modeBar.BackgroundTransparency = 1
			modeBar.Parent = gui
			local modeBtns = {}
			for i, m in ipairs(modes) do
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(0.25, -4, 1, 0)
				b.Position = UDim2.new((i - 1) * 0.25, 2, 0, 0)
				b.BackgroundColor3 = m == "Skin" and Color3.fromRGB(67, 107, 188) or Color3.fromRGB(32, 32, 32)
				b.Text = m
				b.TextColor3 = Color3.new(1, 1, 1)
				b.Font = Enum.Font.Code
				b.TextSize = 12
				b.Parent = modeBar
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
				modeBtns[m] = b
				b.MouseButton1Click:Connect(function()
					skinState.Mode = m
					for mm, bb in pairs(modeBtns) do
						bb.BackgroundColor3 = mm == m and Color3.fromRGB(67, 107, 188) or Color3.fromRGB(32, 32, 32)
					end
					rebuildLists()
					if skinState.Refresh then skinState.Refresh() end
				end)
			end

			local weaponSearch = Instance.new("TextBox")
			weaponSearch.Size = UDim2.new(0.5, -12, 0, 28)
			weaponSearch.Position = UDim2.fromOffset(8, 78)
			weaponSearch.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			weaponSearch.Text = ""
			weaponSearch.PlaceholderText = "Search weapons..."
			weaponSearch.TextColor3 = Color3.new(1, 1, 1)
			weaponSearch.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			weaponSearch.Font = Enum.Font.Code
			weaponSearch.TextSize = 12
			weaponSearch.ClearTextOnFocus = false
			weaponSearch.Parent = gui
			Instance.new("UICorner", weaponSearch).CornerRadius = UDim.new(0, 4)

			local cosSearch = Instance.new("TextBox")
			cosSearch.Size = UDim2.new(0.5, -12, 0, 28)
			cosSearch.Position = UDim2.new(0.5, 4, 0, 78)
			cosSearch.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			cosSearch.Text = ""
			cosSearch.PlaceholderText = "Search skins..."
			cosSearch.TextColor3 = Color3.new(1, 1, 1)
			cosSearch.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			cosSearch.Font = Enum.Font.Code
			cosSearch.TextSize = 12
			cosSearch.ClearTextOnFocus = false
			cosSearch.Parent = gui
			Instance.new("UICorner", cosSearch).CornerRadius = UDim.new(0, 4)

			local weaponScroll = Instance.new("ScrollingFrame")
			weaponScroll.Size = UDim2.new(0.5, -12, 1, -120)
			weaponScroll.Position = UDim2.fromOffset(8, 112)
			weaponScroll.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			weaponScroll.BorderSizePixel = 0
			weaponScroll.ScrollBarThickness = 4
			weaponScroll.CanvasSize = UDim2.fromOffset(0, 0)
			weaponScroll.Parent = gui
			Instance.new("UICorner", weaponScroll).CornerRadius = UDim.new(0, 4)

			local cosScroll = Instance.new("ScrollingFrame")
			cosScroll.Size = UDim2.new(0.5, -12, 1, -120)
			cosScroll.Position = UDim2.new(0.5, 4, 0, 112)
			cosScroll.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			cosScroll.BorderSizePixel = 0
			cosScroll.ScrollBarThickness = 4
			cosScroll.CanvasSize = UDim2.fromOffset(0, 0)
			cosScroll.Parent = gui
			Instance.new("UICorner", cosScroll).CornerRadius = UDim.new(0, 4)

			local function clear(scroll)
				for _, c in ipairs(scroll:GetChildren()) do
					if c:IsA("TextButton") or c:IsA("UIGridLayout") then c:Destroy() end
				end
			end

			local function refresh()
				clear(weaponScroll)
				clear(cosScroll)
				local wg = Instance.new("UIGridLayout")
				wg.CellSize = UDim2.fromOffset(tileW, tileH)
				wg.CellPadding = UDim2.fromOffset(4, 4)
				wg.Parent = weaponScroll
				local cg = Instance.new("UIGridLayout")
				cg.CellSize = UDim2.fromOffset(tileW, tileH)
				cg.CellPadding = UDim2.fromOffset(4, 4)
				cg.Parent = cosScroll
				local wCount, cCount = 0, 0
				local wq = string.lower(skinState.WeaponSearch or "")
				local cq = string.lower(skinState.CosmeticSearch or "")
				for _, entry in ipairs(skinState.Weapons) do
					local d = string.lower(entry.Display or "")
					if wq == "" or d:find(wq, 1, true) then
						wCount = wCount + 1
						local b = Instance.new("TextButton")
						b.Size = UDim2.fromOffset(tileW, tileH)
						b.BackgroundColor3 = skinState.SelectedWeapon == entry.Name and Color3.fromRGB(67, 107, 188) or Color3.fromRGB(35, 35, 35)
						b.Text = entry.Display
						b.TextColor3 = Color3.fromRGB(230, 230, 230)
						b.Font = Enum.Font.Code
						b.TextSize = 11
						b.TextWrapped = true
						b.Parent = weaponScroll
						Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
						b.MouseButton1Click:Connect(function()
							skinState.SelectedWeapon = entry.Name
							rebuildLists()
							refresh()
						end)
					end
				end
				for _, entry in ipairs(skinState.Cosmetics) do
					local d = string.lower(entry.Display or "")
					if cq == "" or d:find(cq, 1, true) then
						cCount = cCount + 1
						local b = Instance.new("TextButton")
						b.Size = UDim2.fromOffset(tileW, tileH)
						b.BackgroundColor3 = skinState.SelectedCosmetic == entry.Name and Color3.fromRGB(67, 107, 188) or Color3.fromRGB(35, 35, 35)
						b.Text = entry.Display
						b.TextColor3 = Color3.fromRGB(230, 230, 230)
						b.Font = Enum.Font.Code
						b.TextSize = 11
						b.TextWrapped = true
						b.Parent = cosScroll
						Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
						b.MouseButton1Click:Connect(function()
							if not skinState.SelectedWeapon then
								Library:Notify("Select a weapon first")
								return
							end
							skinState.SelectedCosmetic = entry.Name
							if applyCosmetic(skinState.SelectedWeapon, entry.Name, skinState.Mode) then
								Library:Notify("Applied " .. entry.Display .. " → " .. skinState.SelectedWeapon)
							else
								Library:Notify("Apply failed")
							end
							refresh()
						end)
					end
				end
				weaponScroll.CanvasSize = UDim2.fromOffset(0, math.ceil(math.max(wCount, 1) / cols) * (tileH + 4) + 8)
				cosScroll.CanvasSize = UDim2.fromOffset(0, math.ceil(math.max(cCount, 1) / cols) * (tileH + 4) + 8)
			end
			skinState.Refresh = refresh

			weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
				skinState.WeaponSearch = weaponSearch.Text
				refresh()
			end)
			cosSearch:GetPropertyChangedSignal("Text"):Connect(function()
				skinState.CosmeticSearch = cosSearch.Text
				refresh()
			end)
			reset.MouseButton1Click:Connect(function()
				for k in pairs(skinState.Equip) do skinState.Equip[k] = nil end
				getgenv().NemesisSkinEquip = skinState.Equip
				Library:Notify("Skins reset")
				rebuildLists()
				refresh()
			end)
			close.MouseButton1Click:Connect(function()
				skinState.Open = false
				gui.Visible = false
				pcall(function()
					if Toggles.ShowSkinChanger then Toggles.ShowSkinChanger:SetValue(false) end
				end)
			end)
			return gui
		end

		SkinBox:AddToggle("ShowSkinChanger", {
			Text = "Show Skin Changer",
			Default = false,
			Callback = function(v)
				if v then
					local gui = makeGui()
					skinState.Open = true
					gui.Visible = true
					Library:Notify("Skin Changer opened")
					task.spawn(function()
						if ensureLibs() then
							rebuildLists()
							if skinState.Refresh then pcall(skinState.Refresh) end
							Library:Notify(string.format("Weapons: %d | Cosmetics: %d", #skinState.Weapons, #skinState.Cosmetics))
						else
							Library:Notify("Skin modules failed — rejoin then re-execute")
						end
					end)
				else
					skinState.Open = false
					if skinState.Gui then skinState.Gui.Visible = false end
				end
			end,
		})
	end

	----------------------------------------------------------------
	-- Override (viewmodel appearance)
	----------------------------------------------------------------
	local OverrideBox = Tabs.Visuals:AddLeftGroupbox("Override")
	OverrideBox:AddToggle("VMApp", {
		Text = "viewmodel appearance", Default = false,
		Callback = function(v) V.Appearance = v if v then refreshViewmodel() end end,
	})
	OverrideBox:AddLabel("color"):AddColorPicker("VMColor", {
		Default = Color3.new(1,1,1),
		Callback = function(c) V.Color = c refreshViewmodel() end,
	})
	OverrideBox:AddDropdown("VMMat", {
		Values = materials, Default = 1, Text = "material",
		Callback = function(v) V.Material = v refreshViewmodel() end,
	})
	OverrideBox:AddToggle("VMWire", {
		Text = "wireframe", Default = false,
		Callback = function(v) V.Wireframe = v refreshViewmodel() end,
	})
	OverrideBox:AddToggle("VMNoTex", {
		Text = "disable textures", Default = false,
		Callback = function(v) V.DisableTextures = v refreshViewmodel() end,
	})
	OverrideBox:AddSlider("VMTrans", {
		Text = "transparency", Min = 0, Max = 100, Default = 100, Rounding = 0,
		Callback = function(v) V.Transparency = v / 100 refreshViewmodel() end,
	})
	OverrideBox:AddToggle("ArmApp", {
		Text = "arm appearance", Default = false,
		Callback = function(v) V.ArmAppearance = v refreshViewmodel() end,
	})
	OverrideBox:AddLabel("arm color"):AddColorPicker("ArmColor", {
		Default = Color3.new(1,1,1),
		Callback = function(c) V.ArmColor = c refreshViewmodel() end,
	})
	OverrideBox:AddDropdown("ArmMat", {
		Values = materials, Default = 1, Text = "arm material",
		Callback = function(v) V.ArmMaterial = v refreshViewmodel() end,
	})
	OverrideBox:AddToggle("ArmNoClothes", {
		Text = "disable clothes", Default = false,
		Callback = function(v) V.ArmDisableClothes = v refreshViewmodel() end,
	})
	OverrideBox:AddSlider("ArmTrans", {
		Text = "arm transparency", Min = 0, Max = 100, Default = 100, Rounding = 0,
		Callback = function(v) V.ArmTransparency = v / 100 refreshViewmodel() end,
	})

	----------------------------------------------------------------
	-- Viewmodel (item / fps / chams / offset)
	----------------------------------------------------------------
	local ItemBox = Tabs.Visuals:AddRightGroupbox("Viewmodel")

	ItemBox:AddToggle("OverrideFPS", {
		Text = "override fps", Default = false,
		Callback = function(v) V.OverrideFPS = v if v and setfpscap then pcall(setfpscap, V.FPS) end end,
	})
	ItemBox:AddSlider("FPSVal", {
		Text = "fps", Min = 1, Max = 240, Default = 60, Rounding = 0,
		Callback = function(v) V.FPS = v if V.OverrideFPS and setfpscap then pcall(setfpscap, v) end end,
	})
	ItemBox:AddSlider("RecoilPct", {
		Text = "recoil percent", Min = 0, Max = 100, Default = 100, Rounding = 0,
		Callback = function(v)
			V.RecoilPercent = v
			pcall(function()
				local gun = require(LP.PlayerScripts.Modules.ItemTypes.Gun)
				if gun and gun._Recoil then
					-- scale is applied via Config elsewhere
				end
			end)
		end,
	})
	ItemBox:AddToggle("Chams", {
		Text = "chams", Default = false,
		Callback = function(v) V.Chams = v end,
	}):AddColorPicker("ChamCol", {
		Default = Color3.new(1,1,1),
		Callback = function(c) V.ChamColor = c end,
	})
	ItemBox:AddSlider("ChamFill", {
		Text = "fill transparency", Min = 0, Max = 100, Default = 2, Rounding = 0,
		Callback = function(v) V.ChamFill = v / 100 end,
	})
	ItemBox:AddSlider("ChamOut", {
		Text = "outline transparency", Min = 0, Max = 100, Default = 1, Rounding = 0,
		Callback = function(v) V.ChamOutline = v / 100 end,
	})
	ItemBox:AddToggle("VMOffset", {
		Text = "offset", Default = false,
		Callback = function(v) V.Offset = v end,
	})
	ItemBox:AddSlider("OffX", {
		Text = "x", Min = -10, Max = 10, Default = 0, Rounding = 2,
		Callback = function(v) V.OX = v end,
	})
	ItemBox:AddSlider("OffY", {
		Text = "y", Min = -10, Max = 10, Default = 0, Rounding = 2,
		Callback = function(v) V.OY = v end,
	})
	ItemBox:AddSlider("OffZ", {
		Text = "z", Min = -10, Max = 10, Default = 0, Rounding = 2,
		Callback = function(v) V.OZ = v end,
	})
	ItemBox:AddToggle("NoVig", {
		Text = "remove vignette", Default = false,
		Callback = function(v)
			V.RemoveVignette = v
			pcall(function()
				for _, g in ipairs(LP.PlayerGui:GetDescendants()) do
					if g:IsA("ImageLabel") and string.lower(g.Name):find("vignette", 1, true) then
						g.Visible = not v
					end
				end
			end)
		end,
	})

	----------------------------------------------------------------
	-- Crosshair (UE-style full options)
	----------------------------------------------------------------
	local CHBox = Tabs.Visuals:AddLeftGroupbox("Crosshair")
	local crossLines = {}
	for i = 1, 16 do
		local l = Drawing.new("Line")
		l.Visible = false
		l.Thickness = 1
		l.Transparency = 1
		crossLines[i] = l
	end
	local crossState = { rot = 0, bounce = 0, smoothGap = 4 }

	local function hideCross()
		for _, l in ipairs(crossLines) do l.Visible = false end
	end

	local function hideGameCrosshair()
		if not V.CrosshairDisableGame then return end
		pcall(function()
			local pg = LP:FindFirstChild("PlayerGui")
			if not pg then return end
			for _, g in ipairs(pg:GetDescendants()) do
				local n = string.lower(g.Name)
				if (n:find("crosshair") or n:find("reticle") or n:find("cursor")) and (g:IsA("ImageLabel") or g:IsA("ImageButton") or g:IsA("Frame")) then
					g.Visible = false
				end
			end
		end)
	end

	local function updateCross(dt)
		if not V.Crosshair then hideCross() return end
		hideGameCrosshair()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local vs = cam.ViewportSize
		local cx, cy = vs.X / 2, vs.Y / 2 + (V.CrosshairOffset or 0)
		if V.CrosshairMode == "Target" then
			local tgt
			pcall(function()
				local SA = getgenv().SilentAim
				local AB = getgenv().Aimbot
				if SA and SA.Enabled and SA.Target then tgt = SA.Target end
				if (not tgt) and AB and AB.Enabled and AB.Target then tgt = AB.Target end
			end)
			if tgt and tgt.Parent then
				local pos, on = cam:WorldToViewportPoint(tgt.Position)
				if on and pos.Z > 0 then
					cx, cy = pos.X, pos.Y
				end
			end
		end

		if V.CrosshairMovingRot then
			crossState.rot = (crossState.rot + (V.CrosshairRotSpeed or 0) * (dt or 0.016) * 360) % 360
		else
			crossState.rot = V.CrosshairRot or 0
		end

		local gap = V.CrosshairGap or 4
		if V.CrosshairBounce then
			crossState.bounce = (crossState.bounce or 0) + (V.CrosshairBounceSpeed or 2) * (dt or 0.016) * math.pi * 2
			gap = gap + math.sin(crossState.bounce) * 3
		end
		local lerp = math.clamp(V.CrosshairLerp or 1, 0.05, 1)
		crossState.smoothGap = crossState.smoothGap + (gap - crossState.smoothGap) * lerp
		gap = crossState.smoothGap

		local length = V.CrosshairLength or V.CrosshairSize or 8
		local thick = V.CrosshairThick or 1.5
		local rot = math.rad(crossState.rot)
		local function rotPt(x, y)
			local cos, sin = math.cos(rot), math.sin(rot)
			return cx + x * cos - y * sin, cy + x * sin + y * cos
		end

		local colors = {
			V.CrosshairColor1 or Color3.new(1,1,1),
			V.CrosshairColor2 or Color3.new(1,1,1),
			V.CrosshairColor3 or Color3.new(1,1,1),
			V.CrosshairColor4 or Color3.new(1,1,1),
		}
		local outCols = {
			V.CrosshairOutlineColor1 or Color3.new(0,0,0),
			V.CrosshairOutlineColor2 or Color3.new(0,0,0),
			V.CrosshairOutlineColor3 or Color3.new(0,0,0),
			V.CrosshairOutlineColor4 or Color3.new(0,0,0),
		}
		-- 4 arms: top, bottom, left, right
		local segs = {
			{0, -(gap + length), 0, -gap},
			{0, gap, 0, gap + length},
			{-(gap + length), 0, -gap, 0},
			{gap, 0, gap + length, 0},
		}
		for i, s in ipairs(segs) do
			local x1, y1 = rotPt(s[1], s[2])
			local x2, y2 = rotPt(s[3], s[4])
			local outline = crossLines[i]
			local main = crossLines[i + 4]
			if V.CrosshairOutline then
				outline.From = Vector2.new(x1, y1)
				outline.To = Vector2.new(x2, y2)
				outline.Color = outCols[i]
				outline.Thickness = thick + 2
				outline.Visible = true
			else
				outline.Visible = false
			end
			main.From = Vector2.new(x1, y1)
			main.To = Vector2.new(x2, y2)
			main.Color = colors[i]
			main.Thickness = thick
			main.Visible = true
		end
		for i = 9, 16 do crossLines[i].Visible = false end
	end

	RunService.RenderStepped:Connect(function(dt)
		pcall(updateCross, dt)
	end)

	CHBox:AddToggle("CHOn", {
		Text = "Enabled", Default = false,
		Callback = function(v) V.Crosshair = v if not v then hideCross() end end,
	})
	CHBox:AddDropdown("CHMode", {
		Values = { "Center", "Target" },
		Default = 1,
		Text = "Mode",
		Callback = function(v) V.CrosshairMode = v end,
	})
	CHBox:AddToggle("CHDisableGame", {
		Text = "Disable Game Crosshair", Default = true,
		Callback = function(v) V.CrosshairDisableGame = v end,
	})
	CHBox:AddToggle("CHOutline", {
		Text = "Outline", Default = true,
		Callback = function(v) V.CrosshairOutline = v end,
	})
	CHBox:AddLabel("Color 1"):AddColorPicker("CHC1", {
		Default = Color3.new(1,1,1), Callback = function(c) V.CrosshairColor1 = c end,
	})
	CHBox:AddLabel("Color 2"):AddColorPicker("CHC2", {
		Default = Color3.new(1,1,1), Callback = function(c) V.CrosshairColor2 = c end,
	})
	CHBox:AddLabel("Color 3"):AddColorPicker("CHC3", {
		Default = Color3.new(1,1,1), Callback = function(c) V.CrosshairColor3 = c end,
	})
	CHBox:AddLabel("Color 4"):AddColorPicker("CHC4", {
		Default = Color3.new(1,1,1), Callback = function(c) V.CrosshairColor4 = c end,
	})
	CHBox:AddLabel("Outline 1"):AddColorPicker("CHO1", {
		Default = Color3.new(0,0,0), Callback = function(c) V.CrosshairOutlineColor1 = c end,
	})
	CHBox:AddLabel("Outline 2"):AddColorPicker("CHO2", {
		Default = Color3.new(0,0,0), Callback = function(c) V.CrosshairOutlineColor2 = c end,
	})
	CHBox:AddLabel("Outline 3"):AddColorPicker("CHO3", {
		Default = Color3.new(0,0,0), Callback = function(c) V.CrosshairOutlineColor3 = c end,
	})
	CHBox:AddLabel("Outline 4"):AddColorPicker("CHO4", {
		Default = Color3.new(0,0,0), Callback = function(c) V.CrosshairOutlineColor4 = c end,
	})
	CHBox:AddSlider("CHLength", {
		Text = "Length", Min = 1, Max = 40, Default = 8, Rounding = 0,
		Callback = function(v) V.CrosshairLength = v V.CrosshairSize = v end,
	})
	CHBox:AddSlider("CHGap", {
		Text = "Gap", Min = 0, Max = 40, Default = 4, Rounding = 0,
		Callback = function(v) V.CrosshairGap = v end,
	})
	CHBox:AddSlider("CHThick", {
		Text = "Thickness", Min = 1, Max = 6, Default = 1.5, Rounding = 1,
		Callback = function(v) V.CrosshairThick = v end,
	})
	CHBox:AddSlider("CHOffset", {
		Text = "Offset Y", Min = -100, Max = 100, Default = 0, Rounding = 0,
		Callback = function(v) V.CrosshairOffset = v end,
	})
	CHBox:AddSlider("CHLerp", {
		Text = "Lerp", Min = 0.05, Max = 1, Default = 1, Rounding = 2,
		Callback = function(v) V.CrosshairLerp = v end,
	})
	CHBox:AddToggle("CHBounce", {
		Text = "Bounce", Default = false,
		Callback = function(v) V.CrosshairBounce = v end,
	})
	CHBox:AddSlider("CHBounceSpd", {
		Text = "Bounce Speed", Min = 0.1, Max = 10, Default = 2, Rounding = 1,
		Callback = function(v) V.CrosshairBounceSpeed = v end,
	})
	CHBox:AddToggle("CHMoveRot", {
		Text = "Moving Rotation", Default = false,
		Callback = function(v) V.CrosshairMovingRot = v end,
	})
	CHBox:AddSlider("CHRot", {
		Text = "Rotation", Min = 0, Max = 360, Default = 0, Rounding = 0,
		Callback = function(v) V.CrosshairRot = v end,
	})
	CHBox:AddSlider("CHRotSpd", {
		Text = "Rotation Speed", Min = 0, Max = 5, Default = 0, Rounding = 1,
		Callback = function(v) V.CrosshairRotSpeed = v end,
	})

	----------------------------------------------------------------
	-- Custom tracers
	----------------------------------------------------------------
	-- Custom tracers (to players)
	----------------------------------------------------------------
	local TrBox = Tabs.Visuals:AddLeftGroupbox("Custom Tracers")
	local tracerLines = {}
	local function getTracer(i)
		if not tracerLines[i] then
			local l = Drawing.new("Line")
			l.Visible = false
			l.Thickness = 1
			l.Transparency = 1
			tracerLines[i] = l
		end
		return tracerLines[i]
	end
	RunService.RenderStepped:Connect(function()
		if not V.Tracers then
			for _, l in pairs(tracerLines) do l.Visible = false end
			return
		end
		local idx = 0
		local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local root = plr.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
					idx = idx + 1
					local line = getTracer(idx)
					if onScreen then
						line.From = origin
						line.To = Vector2.new(pos.X, pos.Y)
						line.Color = V.TracerColor
						line.Visible = true
					else
						line.Visible = false
					end
				end
			end
		end
		for i = idx + 1, #tracerLines do
			if tracerLines[i] then tracerLines[i].Visible = false end
		end
	end)
	TrBox:AddToggle("TrOn", {
		Text = "enabled", Default = false,
		Callback = function(v) V.Tracers = v end,
	}):AddColorPicker("TrCol", {
		Default = Color3.new(1,1,1),
		Callback = function(c) V.TracerColor = c end,
	})

	----------------------------------------------------------------
	-- Hit sounds (Lion presets)
	----------------------------------------------------------------
	local HSBox = Tabs.Visuals:AddRightGroupbox("Hit Sounds")
	local HitSounds = {
		sparkle = "rbxassetid://5852410340",
		bubble = "rbxassetid://6534947588",
		cod = "rbxassetid://160212130",
		cs = "rbxassetid://5447626464",
		osu = "rbxassetid://7146416419",
		rust = "rbxassetid://1255040462",
		bameware = "rbxassetid://6607142002",
		neverlose = "rbxassetid://6607204501",
		gamesense = "rbxassetid://4817809188",
	}
	local hsNames = {}
	for n in pairs(HitSounds) do table.insert(hsNames, n) end
	table.sort(hsNames)

	local lastHealth = {}
	HSBox:AddToggle("HSOn", {
		Text = "enabled", Default = false,
		Callback = function(v) V.HitSounds = v end,
	})
	HSBox:AddDropdown("HSSelect", {
		Values = hsNames, Default = 1, Text = "sound",
		Callback = function(v) V.HitSound = v end,
	})
	HSBox:AddSlider("HSVol", {
		Text = "volume", Min = 0, Max = 5, Default = 1, Rounding = 1,
		Callback = function(v) V.HitVolume = v end,
	})
	RunService.Heartbeat:Connect(function()
		if not V.HitSounds then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					local h = hum.Health
					local prev = lastHealth[plr]
					if prev and h < prev and (prev - h) > 0.5 then
						pcall(function()
							local s = Instance.new("Sound")
							s.SoundId = HitSounds[V.HitSound] or HitSounds.sparkle
							s.Volume = V.HitVolume
							s.Parent = SoundService
							s:Play()
							task.delay(2, function() s:Destroy() end)
						end)
					end
					lastHealth[plr] = h
				end
			end
		end
	end)

	----------------------------------------------------------------
	-- Hit effects (simple highlight flash)
	----------------------------------------------------------------
	local HEBox = Tabs.Visuals:AddRightGroupbox("Hit Effects")
	getgenv().ArchHitFX = false
	HEBox:AddToggle("HEOn", {
		Text = "enabled", Default = false,
		Callback = function(v) getgenv().ArchHitFX = v end,
	}):AddColorPicker("HECol", {
		Default = Color3.fromRGB(255, 80, 80),
		Callback = function(c) getgenv().ArchHitFXColor = c end,
	})
	-- reuse health drop to flash highlight
	local lastHealth2 = {}
	RunService.Heartbeat:Connect(function()
		if not getgenv().ArchHitFX then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					local h = hum.Health
					local prev = lastHealth2[plr]
					if prev and h < prev and (prev - h) > 0.5 then
						pcall(function()
							local hl = Instance.new("Highlight")
							hl.FillColor = getgenv().ArchHitFXColor or Color3.fromRGB(255,80,80)
							hl.OutlineColor = Color3.new(1,1,1)
							hl.FillTransparency = 0.3
							hl.Parent = plr.Character
							task.delay(0.25, function() hl:Destroy() end)
						end)
					end
					lastHealth2[plr] = h
				end
			end
		end
	end)
end


------------------------------------------------------------------------
-- CHARACTER
------------------------------------------------------------------------
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local LP = Players.LocalPlayer

	local charCfg = {
		flyEnabled = false,
		flySpeed = 50,
		noclip = false,
		infJump = false,
		speedEnabled = false,
		walkSpeed = 32,
		jumpEnabled = false,
		jumpPower = 75,
		glideEnabled = false,
		glideSpeed = 280,
		glideAccel = 18,
		antiAfk = false,
	}

	local function getHrp()
		return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end

	local function getHum()
		return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	end

	-- Fly (camera-directed)
	local flyConn = nil
	local function startFly()
		if flyConn then flyConn:Disconnect() end
		flyConn = RunService.Heartbeat:Connect(function(dt)
			local tHrp = getHrp()
			if not tHrp or not charCfg.flyEnabled then return end
			local h = getHum()
			if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
			local c = workspace.CurrentCamera
			local md = Vector3.zero
			if h and h.MoveDirection.Magnitude > 0 then
				local fl = Vector3.new(c.CFrame.LookVector.X, 0, c.CFrame.LookVector.Z)
				md = fl.Magnitude > 0.001
					and Vector3.new(h.MoveDirection.X, c.CFrame.LookVector.Y * h.MoveDirection:Dot(fl.Unit), h.MoveDirection.Z)
					or Vector3.new(h.MoveDirection.X, c.CFrame.LookVector.Y, h.MoveDirection.Z)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				md = md + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				md = md - Vector3.new(0, 1, 0)
			end
			tHrp.AssemblyLinearVelocity = Vector3.zero
			tHrp.AssemblyAngularVelocity = Vector3.zero
			if md.Magnitude > 0 then
				tHrp.CFrame = tHrp.CFrame + (md.Unit * (charCfg.flySpeed * dt))
			end
		end)
	end
	local function stopFly()
		if flyConn then flyConn:Disconnect() flyConn = nil end
		local hrp = getHrp()
		if hrp then
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		end
		local h = getHum()
		if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
	end

	-- Noclip
	RunService.Stepped:Connect(function()
		if not charCfg.noclip or not LP.Character then return end
		for _, p in ipairs(LP.Character:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CanCollide = false
			end
		end
	end)

	-- Infinite jump
	UserInputService.JumpRequest:Connect(function()
		if not charCfg.infJump then return end
		local hum = getHum()
		if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	-- Walk speed / jump power apply
	RunService.Heartbeat:Connect(function()
		local hum = getHum()
		if not hum then return end
		if charCfg.speedEnabled then
			pcall(function()
				hum.WalkSpeed = charCfg.walkSpeed
			end)
		end
		if charCfg.jumpEnabled then
			pcall(function()
				hum.JumpPower = charCfg.jumpPower
				hum.UseJumpPower = true
			end)
		end
	end)

	-- Glide
	local glideConn = nil
	local glideVel = Vector3.zero
	local function startGlide()
		if glideConn then glideConn:Disconnect() end
		glideVel = Vector3.zero
		local hum = getHum()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
		glideConn = RunService.Heartbeat:Connect(function(dt)
			if not charCfg.glideEnabled then return end
			local hrp = getHrp()
			if not hrp then return end
			local cam = workspace.CurrentCamera
			local cf = cam and cam.CFrame or hrp.CFrame
			local f = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
			if f.Magnitude > 0.001 then f = f.Unit end
			local r = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
			if r.Magnitude > 0.001 then r = r.Unit end
			local humC = getHum()
			local md = humC and humC.MoveDirection or Vector3.zero
			local wish = Vector3.zero
			if md.Magnitude > 0.001 then
				wish = f * md:Dot(f) + r * md:Dot(r)
				if wish.Magnitude > 0.001 then wish = wish.Unit end
			end
			local accel = math.clamp(charCfg.glideAccel, 1, 100)
			glideVel = glideVel:Lerp(wish * charCfg.glideSpeed, 1 - math.exp(-accel * dt))
			hrp.AssemblyLinearVelocity = Vector3.new(glideVel.X, hrp.AssemblyLinearVelocity.Y, glideVel.Z)
		end)
	end
	local function stopGlide()
		if glideConn then glideConn:Disconnect() glideConn = nil end
		glideVel = Vector3.zero
	end

	-- Anti AFK
	local antiAfkConn = nil
	local function startAntiAfk()
		if antiAfkConn then antiAfkConn:Disconnect() end
		local VirtualUser = game:GetService("VirtualUser")
		antiAfkConn = LP.Idled:Connect(function()
			if not charCfg.antiAfk then return end
			pcall(function()
				VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			end)
		end)
	end
	local function stopAntiAfk()
		if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
	end

	-- UI
	local CBox = Tabs.Character:AddLeftGroupbox("Movement")
	CBox:AddToggle("FlyMode", {
		Text = "Fly",
		Default = false,
		Callback = function(v)
			charCfg.flyEnabled = v
			if v then startFly() else stopFly() end
			Library:Notify(v and "Fly ON" or "Fly OFF")
		end,
	})
	CBox:AddSlider("FlySpeed", {
		Text = "Fly Speed",
		Default = 50, Min = 1, Max = 2000, Rounding = 0,
		Callback = function(v) charCfg.flySpeed = v end,
	})
	CBox:AddToggle("NoclipMode", {
		Text = "Noclip",
		Default = false,
		Callback = function(v)
			charCfg.noclip = v
			Library:Notify(v and "Noclip ON" or "Noclip OFF")
		end,
	})
	CBox:AddToggle("InfJump", {
		Text = "Infinite Jump",
		Default = false,
		Callback = function(v)
			charCfg.infJump = v
			Library:Notify(v and "Infinite Jump ON" or "Infinite Jump OFF")
		end,
	})
	CBox:AddToggle("SpeedOn", {
		Text = "Speed",
		Default = false,
		Callback = function(v) charCfg.speedEnabled = v end,
	})
	CBox:AddSlider("WalkSpd", {
		Text = "Walk Speed",
		Default = 32, Min = 16, Max = 200, Rounding = 0,
		Callback = function(v) charCfg.walkSpeed = v end,
	})
	CBox:AddToggle("JumpOn", {
		Text = "Jump Power",
		Default = false,
		Callback = function(v) charCfg.jumpEnabled = v end,
	})
	CBox:AddSlider("JumpPow", {
		Text = "Jump Power Value",
		Default = 75, Min = 50, Max = 300, Rounding = 0,
		Callback = function(v) charCfg.jumpPower = v end,
	})

	local GBox = Tabs.Character:AddRightGroupbox("Glide / Utility")
	GBox:AddToggle("GlideMode", {
		Text = "Glide",
		Default = false,
		Callback = function(v)
			charCfg.glideEnabled = v
			if v then startGlide() else stopGlide() end
			Library:Notify(v and "Glide ON" or "Glide OFF")
		end,
	})
	GBox:AddSlider("GlideSpd", {
		Text = "Glide Speed",
		Default = 280, Min = 10, Max = 5000, Rounding = 0,
		Callback = function(v) charCfg.glideSpeed = v end,
	})
	GBox:AddSlider("GlideAcc", {
		Text = "Glide Accel",
		Default = 18, Min = 1, Max = 100, Rounding = 0,
		Callback = function(v) charCfg.glideAccel = v end,
	})
	GBox:AddToggle("AntiAfk", {
		Text = "Anti AFK",
		Default = false,
		Callback = function(v)
			charCfg.antiAfk = v
			if v then startAntiAfk() else stopAntiAfk() end
			Library:Notify(v and "Anti AFK ON" or "Anti AFK OFF")
		end,
	})

	-- Keybinds (right side)
	local KBox = Tabs.Character:AddRightGroupbox("Keybinds")
	KBox:AddLabel("Fly Keybind"):AddKeyPicker("FlyKey", {
		Default = "None",
		Text = "Fly",
		Mode = "Toggle",
		Callback = function(active)
			-- Mode Toggle: fires when key toggles state on some forks
		end,
	})
	KBox:AddLabel("Noclip Keybind"):AddKeyPicker("NoclipKey", {
		Default = "None",
		Text = "Noclip",
		Mode = "Toggle",
	})
	KBox:AddLabel("Inf Jump Keybind"):AddKeyPicker("InfJumpKey", {
		Default = "None",
		Text = "Infinite Jump",
		Mode = "Toggle",
	})
	KBox:AddLabel("Glide Keybind"):AddKeyPicker("GlideKey", {
		Default = "None",
		Text = "Glide",
		Mode = "Toggle",
	})
	KBox:AddLabel("Speed Keybind"):AddKeyPicker("SpeedKey", {
		Default = "None",
		Text = "Speed",
		Mode = "Toggle",
	})

	-- Poll keybind toggles each frame (Linoria KeyPicker GetState)
	RunService.RenderStepped:Connect(function()
		pcall(function()
			local function pressed(id)
				local o = Options and Options[id]
				if not o then return false end
				if type(o.GetState) == "function" then return o:GetState() end
				return o.Value == true
			end
			-- Fly
			if Options.FlyKey then
				local on = pressed("FlyKey")
				if on ~= charCfg.flyEnabled and Options.FlyKey.Mode == "Toggle" then
					-- sync via GetState for Hold modes; for Toggle use Changed
				end
			end
		end)
	end)

	-- Reliable: listen to keybind option changes if available, else InputBegan
	local function toggleFly()
		charCfg.flyEnabled = not charCfg.flyEnabled
		if charCfg.flyEnabled then startFly() else stopFly() end
		pcall(function()
			if Toggles.FlyMode then Toggles.FlyMode:SetValue(charCfg.flyEnabled) end
		end)
		Library:Notify(charCfg.flyEnabled and "Fly ON" or "Fly OFF")
	end
	local function toggleNoclip()
		charCfg.noclip = not charCfg.noclip
		pcall(function()
			if Toggles.NoclipMode then Toggles.NoclipMode:SetValue(charCfg.noclip) end
		end)
		Library:Notify(charCfg.noclip and "Noclip ON" or "Noclip OFF")
	end
	local function toggleInfJump()
		charCfg.infJump = not charCfg.infJump
		pcall(function()
			if Toggles.InfJump then Toggles.InfJump:SetValue(charCfg.infJump) end
		end)
		Library:Notify(charCfg.infJump and "Infinite Jump ON" or "Infinite Jump OFF")
	end
	local function toggleGlide()
		charCfg.glideEnabled = not charCfg.glideEnabled
		if charCfg.glideEnabled then startGlide() else stopGlide() end
		pcall(function()
			if Toggles.GlideMode then Toggles.GlideMode:SetValue(charCfg.glideEnabled) end
		end)
		Library:Notify(charCfg.glideEnabled and "Glide ON" or "Glide OFF")
	end
	local function toggleSpeed()
		charCfg.speedEnabled = not charCfg.speedEnabled
		pcall(function()
			if Toggles.SpeedOn then Toggles.SpeedOn:SetValue(charCfg.speedEnabled) end
		end)
		Library:Notify(charCfg.speedEnabled and "Speed ON" or "Speed OFF")
	end

	local function keyMatches(pickerId, input)
		local o = Options and Options[pickerId]
		if not o then return false end
		local key = o.Value
		if key == nil or key == "" or key == "None" or key == "none" then
			return false -- no key set = never trigger (avoids accidental fly)
		end
		if type(key) == "string" then
			if input.KeyCode and input.KeyCode.Name == key then return true end
			if input.UserInputType and input.UserInputType.Name == key then return true end
			if key == "MB2" and input.UserInputType == Enum.UserInputType.MouseButton2 then return true end
			if key == "MB1" and input.UserInputType == Enum.UserInputType.MouseButton1 then return true end
			if key == "MB3" and input.UserInputType == Enum.UserInputType.MouseButton3 then return true end
		end
		return false
	end

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if keyMatches("FlyKey", input) then toggleFly() end
		if keyMatches("NoclipKey", input) then toggleNoclip() end
		if keyMatches("InfJumpKey", input) then toggleInfJump() end
		if keyMatches("GlideKey", input) then toggleGlide() end
		if keyMatches("SpeedKey", input) then toggleSpeed() end
	end)
end

------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------
local Menu = Tabs.Settings:AddLeftGroupbox("Menu")
Menu:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
	Default = "RightShift",
	NoUI = true,
	Text = "Menu keybind",
})
Library.ToggleKeybind = Options.MenuKeybind
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		pcall(function() Library:Toggle() end)
	end
end)

-- Robust Linoria/Creep value setters (force callback)
local function setToggle(id, value)
	local t = Toggles and Toggles[id]
	if not t then return false end
	local ok = pcall(function()
		if type(t.SetValue) == "function" then
			-- second arg true = fire callback on many Linoria forks
			t:SetValue(value, true)
		else
			t.Value = value
			if type(t.Callback) == "function" then t.Callback(value) end
		end
	end)
	if not ok then
		pcall(function()
			t.Value = value
			if type(t.Callback) == "function" then t.Callback(value) end
		end)
	end
	return true
end

local function setOption(id, value)
	local o = Options and Options[id]
	if not o then return false end
	local ok = pcall(function()
		if type(o.SetValue) == "function" then
			o:SetValue(value)
		elseif type(o.SetValueRGB) == "function" and typeof(value) == "Color3" then
			o:SetValueRGB(value)
		else
			o.Value = value
			if type(o.Callback) == "function" then o.Callback(value) end
		end
	end)
	return ok
end

local function applyRageConfig()
	-- Core config tables (always apply even if UI fails)
	getgenv().Config = getgenv().Config or {}
	getgenv().Config.FireRate = 0.0005
	getgenv().Config.HitDelay = 0.85
	getgenv().Config.WeaponSlot = "Melee"
	getgenv().Config.ReadyAt = tick() + 0.85

	getgenv().ArchVis = getgenv().ArchVis or {}
	getgenv().ArchVis.Crosshair = true
	getgenv().ArchVis.Tracers = true
	getgenv().ArchVis.HitSounds = true
	getgenv().ArchVis.RemoveVignette = true

	-- UI + callbacks
	setOption("Slot", "Melee")
	setOption("Rate", 0.0005)
	setOption("HitDelay", 0.85)
	setToggle("NoReload", true)
	setToggle("NoSpread", true)
	setToggle("NoRecoil", true)
	setToggle("MaxAccuracy", true)
	setToggle("RapidAttack", true)
	setToggle("NoMuzzleFlash", true)
	setOption("RapidFireValue", 0.02)
	setToggle("CHOn", true)
	setToggle("TrOn", true)
	setToggle("HSOn", true)
	setToggle("HEOn", true)
	setToggle("NoVig", true)
	setToggle("FOVOn", true)
	setOption("FOVVal", 100)
	setToggle("AntiFlash", true)
	setToggle("AntiSmoke", true)

	-- Ragebot last (start after other settings)
	setToggle("RB", true)
	pcall(function()
		if not getgenv().Config.Enabled then
			startRagebot()
		end
	end)

	Library:Notify("Loaded Rage config")
end

local function applyLegitConfig()
	getgenv().Config = getgenv().Config or {}
	getgenv().Config.FireRate = 0.05
	getgenv().Config.HitDelay = 0.9
	getgenv().Config.WeaponSlot = "Primary"

	getgenv().ArchVis = getgenv().ArchVis or {}
	getgenv().ArchVis.Crosshair = true
	getgenv().ArchVis.Tracers = true
	getgenv().ArchVis.HitSounds = false
	getgenv().ArchVis.RemoveVignette = true

	-- Turn rage off first
	setToggle("RB", false)
	pcall(stopRagebot)

	setOption("Slot", "Primary")
	setOption("Rate", 0.05)
	setOption("HitDelay", 0.9)
	setToggle("NoReload", false)
	setToggle("NoSpread", false)
	setToggle("NoRecoil", true)
	setToggle("MaxAccuracy", false)
	setToggle("RapidAttack", false)
	setToggle("NoMuzzleFlash", false)
	setOption("RapidFireValue", 0.08)
	setToggle("CHOn", true)
	setToggle("TrOn", true)
	setToggle("HSOn", false)
	setToggle("HEOn", false)
	setToggle("NoVig", true)
	setToggle("FOVOn", false)
	setOption("FOVVal", 70)
	setToggle("AntiFlash", true)
	setToggle("AntiSmoke", true)

	Library:Notify("Loaded Legit config")
end

if ThemeManager and SaveManager then
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	ThemeManager:SetFolder("NemesisHub")
	SaveManager:SetFolder("NemesisHub/rivals")
	pcall(function()
		SaveManager:BuildConfigSection(Tabs.Settings)
		ThemeManager:ApplyToTab(Tabs.Settings)
	end)
end

-- Below config system
local XCS = Tabs.Settings:AddLeftGroupbox("XCS Configs")
XCS:AddDropdown("XCSConfig", {
	Values = { "xcs rag config", "xcs legit config" },
	Default = 1,
	Text = "Config",
	Callback = function(v)
		if v == "xcs rag config" then
			task.spawn(function()
				local ok, err = pcall(applyRageConfig)
				if not ok then
					Library:Notify("xcs rag config error: " .. tostring(err))
					warn("[NemesisHub] xcs rag config:", err)
				else
					Library:Notify("Loaded xcs rag config")
				end
			end)
		elseif v == "xcs legit config" then
			task.spawn(function()
				local ok, err = pcall(applyLegitConfig)
				if not ok then
					Library:Notify("xcs legit config error: " .. tostring(err))
					warn("[NemesisHub] xcs legit config:", err)
				else
					Library:Notify("Loaded xcs legit config")
				end
			end)
		end
	end,
})
XCS:AddButton("Load Selected Config", function()
	local v = Options.XCSConfig and Options.XCSConfig.Value
	if v == "xcs legit config" then
		task.spawn(function() pcall(applyLegitConfig) end)
	else
		task.spawn(function() pcall(applyRageConfig) end)
	end
end)

task.defer(function()
	local UIS = game:GetService("UserInputService")
	if not UIS.TouchEnabled then return end
	local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return end
	local g = Instance.new("ScreenGui")
	g.Name = "ArchToggle"
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = true
	g.DisplayOrder = 1e9
	g.Parent = pg
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(100, 36)
	b.Position = UDim2.fromOffset(12, 90)
	b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	b.Text = "Toggle UI"
	b.TextColor3 = Color3.fromRGB(230, 230, 230)
	b.Font = Enum.Font.Code
	b.TextSize = 13
	b.Parent = g
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.Activated:Connect(function() Library:Toggle() end)
	b.MouseButton1Click:Connect(function() Library:Toggle() end)
end)


ApplyArchTheme()
task.defer(function()
	local uis = game:GetService("UserInputService")
	if not (uis.TouchEnabled and not uis.KeyboardEnabled) then return end
	local g = Instance.new("ScreenGui")
	g.Name = "ToggleUIOverlay"
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = true
	g.DisplayOrder = 99999
	pcall(function() g.Parent = game:GetService("CoreGui") end)
	if not g.Parent then g.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(120, 40)
	b.Position = UDim2.fromOffset(16, 16)
	b.BackgroundColor3 = Color3.fromRGB(155, 150, 219)
	b.BackgroundTransparency = 0.35
	b.Text = "Toggle UI"
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Code
	b.TextSize = 15
	b.Parent = g
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	b.MouseButton1Click:Connect(function() Library:Toggle() end)
	b.TouchTap:Connect(function() Library:Toggle() end)
end)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		Library:Toggle()
	end
end)
task.defer(function()
	pcall(function()
		if getgenv().NemesisLoadSkins then getgenv().NemesisLoadSkins() end
		if getgenv().NemesisApplySavedSkins then getgenv().NemesisApplySavedSkins() end
		-- force rebuild weapon list like Nemesis
		if shared and shared.LionCosmeticChanger and shared.LionCosmeticChanger.Refresh then
			shared.LionCosmeticChanger.Refresh()
		end
	end)
end)
Library:Notify("concept ready")
