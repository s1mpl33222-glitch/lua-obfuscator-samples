local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local BASE_URL = "https://gitlab.com/soluna-development/api/-/raw/main/src/scripts/"

local scripts = {
	{Category = "Rivals", Name = "Rivals Classic", ToggleKey = "Rivals_Classic", FilePath = "Rivals/Classic.lua"},
	{Category = "Rivals", Name = "Rivals Modern", ToggleKey = "Rivals_Modern", FilePath = "Rivals/Modern.lua"},
	{Category = "Rivals", Name = "Rivals Rewrite", ToggleKey = "Rivals_Rewrite", FilePath = "Rivals/Rewrite.lua"},
	{Category = "Rivals", Name = "Rivals Skin Changer", ToggleKey = "Rivals_SkinChanger", FilePath = "Rivals/Skin-Changer.lua"},
	{Category = "FPS", Name = "Arsenal", ToggleKey = "Arsenal", FilePath = "Arsenal.lua"},
	{Category = "FPS", Name = "Murderers VS Sheriffs DUELS", ToggleKey = "Murderers VS Sheriffs DUELS", FilePath = "Murderers-VS-Sheriffs-DUELS.lua"},
	{Category = "Fighting", Name = "Bladeball", ToggleKey = "Bladeball", FilePath = "Bladeball.lua"},
	{Category = "Fighting", Name = "Fling Things and People", ToggleKey = "FlingThingsAndPeople", FilePath = "Fling-Things-and-People.lua"},
	{Category = "Misc", Name = "Murder Mystery 2", ToggleKey = "MurderMystery2", FilePath = "Murder-Mystery-2.lua"},
	{Category = "Misc", Name = "99 Nights in the Forest", ToggleKey = "NightsInTheForest", FilePath = "99-Nights-in-the-Forest.lua"},
	{Category = "Misc", Name = "The Wild West", ToggleKey = "TheWildWest", FilePath = "The-Wild-West.lua"},
	{Category = "Misc", Name = "Doors", ToggleKey = "Doors", FilePath = "Doors.lua"},
}

local categoryOrder = {"Rivals", "FPS", "Fighting", "Misc"}
local categoryIcons = {
	Rivals = "swords",
	FPS = "target",
	Fighting = "swords",
	Misc = "layout-grid",
}

local DefaultScriptToggles = {}
for _, script in ipairs(scripts) do
	DefaultScriptToggles[script.ToggleKey] = false
end

local DefaultSettings = {
	AutoLoadEnabled = false,
	TeleportLoadEnabled = false,
	DisableScriptLoader = false,
	SelectedVersion = nil,
	SelectedTab = "Rivals",
	ThemeColor = "Darker",
	ScriptToggles = DefaultScriptToggles
}

local Settings = table.clone(DefaultSettings)

local function loadSettings()
	local success, saved = pcall(function()
		return HttpService:JSONDecode(readfile("SolunaLoaderSettings.json"))
	end)
	if success and saved then
		for k, v in pairs(DefaultSettings) do
			if saved[k] == nil then
				saved[k] = v
			end
		end
		if not saved.ScriptToggles then
			saved.ScriptToggles = DefaultScriptToggles
		else
			for k, v in pairs(DefaultScriptToggles) do
				if saved.ScriptToggles[k] == nil then
					saved.ScriptToggles[k] = v
				end
			end
		end
		Settings = saved
	end
end

local function saveSettings()
	writefile("SolunaLoaderSettings.json", HttpService:JSONEncode(Settings))
end

pcall(loadSettings)

if Settings.DisableScriptLoader then
	return
end

local function loadScript(filePath)
	loadstring(game:HttpGet(BASE_URL .. filePath))()
end

if Settings.AutoLoadEnabled then
	local anyLoaded = false
	for _, script in ipairs(scripts) do
		if Settings.ScriptToggles[script.ToggleKey] then
			loadScript(script.FilePath)
			anyLoaded = true
		end
	end
	if anyLoaded then
		return
	end
end

if Settings.TeleportLoadEnabled then
	queue_on_teleport([[
        spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local function isGameLoaded()
                return game:IsLoaded() and LocalPlayer and LocalPlayer.Character and
                       LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                       workspace.CurrentCamera
            end
            if not LocalPlayer then
                LocalPlayer = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
                LocalPlayer = Players.LocalPlayer
            end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.CharacterAdded:Wait()
                while not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                    task.wait(0.1)
                end
            end
            if not isGameLoaded() then
                repeat task.wait(0.1) until isGameLoaded()
            end
            task.wait(1)
            pcall(function()
                loadstring(game:HttpGet("https://gitlab.com/soluna-development/api/-/raw/main/src/Loader.lua?ref_type=heads"))()
            end)
        end)
    ]])
end

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow({
	Title = "Soluna",
	SubTitle = "Script Loader",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = Settings.ThemeColor or "Darker",
	MinSize = Vector2.new(470, 380),
	MinimizeKey = Enum.KeyCode.RightControl
})

Window:Dialog({
	Title = "Script Updated",
	Content = "Added Murderers VS Sheriffs DUELS and Fling Things and People!",
	Buttons = {
		{
			Title = "Okay",
			Callback = function()
				
			end
		}
	}
})

local Tabs = {}

for _, category in ipairs(categoryOrder) do
	Tabs[category] = Window:CreateTab({
		Title = category,
		Icon = categoryIcons[category] or "layout-grid"
	})
end
Tabs.Theme = Window:CreateTab({
	Title = "Theme",
	Icon = "palette"
})
Tabs.Settings = Window:CreateTab({
	Title = "Settings",
	Icon = "settings"
})
Tabs.Info = Window:CreateTab({
	Title = "Info",
	Icon = "info"
})

local allTabsOrder = {}
for _, cat in ipairs(categoryOrder) do table.insert(allTabsOrder, cat) end
table.insert(allTabsOrder, "Theme")
table.insert(allTabsOrder, "Settings")
table.insert(allTabsOrder, "Info")

local selectedTabName = Settings.SelectedTab or "Rivals"
local selectedTabIndex = 1
for i, tabName in ipairs(allTabsOrder) do
	if tabName == selectedTabName then
		selectedTabIndex = i
		break
	end
end
Window:SelectTab(selectedTabIndex)

for _, category in ipairs(categoryOrder) do
	local catScripts = {}
	for _, s in ipairs(scripts) do
		if s.Category == category then
			table.insert(catScripts, s)
		end
	end
	if #catScripts > 0 then
		Tabs[category]:CreateParagraph(category .. "Scripts", {
			Title = category,
			Content = "Select scripts to load for " .. category .. "."
		})
		for _, s in ipairs(catScripts) do
			Tabs[category]:CreateToggle(s.ToggleKey, {
				Title = s.Name,
				Default = Settings.ScriptToggles[s.ToggleKey],
				Callback = function(Value)
					Settings.ScriptToggles[s.ToggleKey] = Value
					saveSettings()
				end
			})
		end
		Tabs[category]:CreateButton({
			Title = "Load Selected " .. category .. " Scripts",
			Description = "Load all toggled " .. category .. " scripts",
			Callback = function()
				local loaded = false
				for _, s in ipairs(catScripts) do
					if Settings.ScriptToggles[s.ToggleKey] then
						Library:Notify({ Title = s.Name, Content = "Loading " .. s.Name .. "...", Duration = 3 })
						loadScript(s.FilePath)
						loaded = true
					end
				end
				if not loaded then
					Library:Notify({ Title = category, Content = "No scripts selected to load", Duration = 3 })
				end
			end
		})
	end
end

Tabs.Theme:CreateParagraph("UI Customization", {
	Title = "Theme Settings",
	Content = "Customize the look and feel of the Soluna Script Loader."
})

Tabs.Theme:CreateDropdown("ThemeDropdown", {
	Title = "UI Theme",
	Values = { "Darker", "Dark", "Light", "Ocean", "Aqua", "Rose", "Violet", "Cyan" },
	Multi = false,
	Default = Settings.ThemeColor or "Darker",
	Callback = function(Value)
		Settings.ThemeColor = Value
		Library:SetTheme(Value)
		saveSettings()
	end
})

Tabs.Info:CreateParagraph("Development Team", {
	Title = "Script Information",
	Content = "This script was made by the Soluna Development Team.\n\nOwner: @endoverdosing\n\nContributing Team Members:\n@aidanqm\n@rvd1\n\nSpecial thanks to @nervigemuecke for helping with the Rivals script.\n\nThank you for your contributions!"
})

Tabs.Info:CreateButton({
	Title = "Copy Discord Link",
	Description = "Click to copy the Soluna Discord server link to your clipboard.",
	Callback = function()
		setclipboard("https://discord.gg/e52GujVvbN")
		Library:Notify({ Title = "Discord Link", Content = "Discord link copied to clipboard!", Duration = 3 })
	end
})

Tabs.Settings:CreateToggle("AutoLoadToggle", {
	Title = "Auto-Load Selected Scripts",
	Default = Settings.AutoLoadEnabled,
	Callback = function(Value)
		Settings.AutoLoadEnabled = Value
		saveSettings()
	end
})

Tabs.Settings:CreateToggle("TeleportLoadToggle", {
	Title = "Load on Teleport",
	Default = Settings.TeleportLoadEnabled,
	Callback = function(Value)
		Settings.TeleportLoadEnabled = Value
		saveSettings()
	end
})

Tabs.Settings:CreateToggle("DisableScriptLoaderToggle", {
	Title = "Disable Script Loader",
	Description = "Completely disables the script loader on next execution",
	Default = Settings.DisableScriptLoader,
	Callback = function(Value)
		Settings.DisableScriptLoader = Value
		saveSettings()
		if Value then
			Library:Notify({ Title = "Script Loader", Content = "Script Loader will be disabled on next execution", Duration = 5 })
		else
			Library:Notify({ Title = "Script Loader", Content = "Script Loader will be enabled on next execution", Duration = 5 })
		end
	end
})

Tabs.Settings:CreateButton({
	Title = "Reload Script Loader",
	Description = "Reloads the script loader with the latest settings",
	Callback = function()
		Library:Notify({ Title = "Script Loader", Content = "Reloading Script Loader...", Duration = 3 })
		task.wait(1)
		loadstring(game:HttpGet("https://gitlab.com/soluna-development/api/-/raw/main/src/Loader.lua?ref_type=heads"))()
	end
})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Library:Notify({
	Title = "Soluna",
	Content = "Script Loaded Successfully!",
	Duration = 5
})