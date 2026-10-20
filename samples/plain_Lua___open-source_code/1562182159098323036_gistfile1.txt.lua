-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- UNLOAD & STATE SYSTEM TRACKER
-- ==========================================
local isUnloaded = false
local Connections = {}

local function TrackConnection(conn)
	if conn then
		table.insert(Connections, conn)
	end
	return conn
end

-- UI Parent Setup
local TargetParent = game:GetService("CoreGui")
if gethui then TargetParent = gethui() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SillyTextureLuaUI_v7"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = TargetParent end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ==========================================
-- HELPER: BATCH PROCESSING 
-- ==========================================
local function batchProcess(items, callback, batchSize)
    batchSize = batchSize or 120
    task.spawn(function()
        for i = 1, #items do
            if isUnloaded then break end -- 若已 Unload 則立刻中止
            callback(items[i])
            if i % batchSize == 0 then
                task.wait()
            end
        end
    end)
end

-- ==========================================
-- NOTIFICATION SYSTEM (BOTTOM LEFT)
-- ==========================================
local function showNotification(titleText, bodyText, duration)
    if isUnloaded then return end
    duration = duration or 5

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotificationFrame"
    NotifFrame.Size = UDim2.new(0, 250, 0, 52)
    NotifFrame.Position = UDim2.new(0, -270, 1, -70)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    NotifFrame.BorderColor3 = Color3.fromRGB(65, 65, 70)
    NotifFrame.BorderSizePixel = 1
    NotifFrame.ZIndex = 200
    NotifFrame.Parent = ScreenGui

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 3, 1, 0)
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    AccentBar.BorderSizePixel = 0
    AccentBar.ZIndex = 201
    AccentBar.Parent = NotifFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -15, 0, 20)
    NotifTitle.Position = UDim2.new(0, 12, 0, 6)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Font = Enum.Font.Code
    NotifTitle.Text = titleText
    NotifTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
    NotifTitle.TextSize = 12
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.ZIndex = 201
    NotifTitle.Parent = NotifFrame

    local NotifBody = Instance.new("TextLabel")
    NotifBody.Size = UDim2.new(1, -15, 0, 20)
    NotifBody.Position = UDim2.new(0, 12, 0, 26)
    NotifBody.BackgroundTransparency = 1
    NotifBody.Font = Enum.Font.Code
    NotifBody.Text = bodyText
    NotifBody.TextColor3 = Color3.fromRGB(200, 200, 205)
    NotifBody.TextSize = 11
    NotifBody.TextXAlignment = Enum.TextXAlignment.Left
    NotifBody.ZIndex = 201
    NotifBody.Parent = NotifFrame

    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 15, 1, -70)
    })
    tweenIn:Play()

    task.delay(duration, function()
        if not isUnloaded and NotifFrame and NotifFrame.Parent then
            local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0, -270, 1, -70)
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end
    end)
end

showNotification("Script Loaded!", "made by n1ghtmare_delta on TT", 5)

-- ==========================================
-- MAIN CONTAINER BUILD
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderColor3 = Color3.fromRGB(65, 65, 70)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Screen Toggle Button
local ScreenMenuBtn = Instance.new("TextButton")
ScreenMenuBtn.Name = "ScreenMenuBtn"
ScreenMenuBtn.Size = UDim2.new(0, 110, 0, 30)
ScreenMenuBtn.Position = UDim2.new(0, 10, 0, 50)
ScreenMenuBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ScreenMenuBtn.BorderColor3 = Color3.fromRGB(75, 75, 80)
ScreenMenuBtn.BorderSizePixel = 1
ScreenMenuBtn.Font = Enum.Font.Code
ScreenMenuBtn.Text = "close ui[🏆]"
ScreenMenuBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
ScreenMenuBtn.TextSize = 12
ScreenMenuBtn.ZIndex = 100
ScreenMenuBtn.Active = true
ScreenMenuBtn.Draggable = true
ScreenMenuBtn.Parent = ScreenGui

local function updateMenuButtonText()
    if isUnloaded then return end
    ScreenMenuBtn.Text = MainFrame.Visible and "close ui[🟢]" or "open ui[🟡]"
end

TrackConnection(ScreenMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    updateMenuButtonText()
end))

-- Header Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 22)
TitleLabel.Position = UDim2.new(0, 10, 0, 2)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.Code
TitleLabel.Text = "silly texture lua | [acid] | follow realacidontop on tiktok!"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Keybind Handler (RightShift)
TrackConnection(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        updateMenuButtonText()
    end
end))

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 24)
TabBar.Position = UDim2.new(0, 5, 0, 26)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
TabBar.BorderColor3 = Color3.fromRGB(50, 50, 55)
TabBar.BorderSizePixel = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -10, 1, -56)
ContentContainer.Position = UDim2.new(0, 5, 0, 54)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local function createTab(name, width)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, width, 1, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TabButton.BorderColor3 = Color3.fromRGB(55, 55, 60)
    TabButton.BorderSizePixel = 1
    TabButton.Font = Enum.Font.Code
    TabButton.Text = "[" .. name .. "]"
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabButton.TextSize = 11
    TabButton.Parent = TabBar

    local TabPage = Instance.new("Frame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.Parent = ContentContainer

    TrackConnection(TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.TextColor3 = Color3.fromRGB(160, 160, 165)
            tab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        end
        TabPage.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    end))

    table.insert(Tabs, { Button = TabButton, Page = TabPage })
    if #Tabs == 1 then
        TabPage.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    end

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.Parent = TabPage

    return TabPage
end

-- UI Tabs Creation
local TexturesTab = createTab("Texture Pack", 100)
local MapTab = createTab("Map Darkener", 100)
local ScriptsTab = createTab("patience", 100)
local SettingsTab = createTab("unload", 100)

-- ==========================================
-- TEXTURE PACK SYSTEM
-- ==========================================
local OriginalAssets = setmetatable({}, {__mode = "k"})
local ActivePackDisableFunc = nil
local ActivePackButton = nil

local function getAsset(url: string): string
	local success, result = pcall(function()
		if writefile and isfile and getcustomasset then
			local fileName = "tex_" .. tostring(string.len(url) % 99999) .. "_" .. tostring(string.byte(url, 10) or 1) .. ".asset"
			if not isfile(fileName) then
				local data = game:HttpGet(url)
				if data and #data > 80 then writefile(fileName, data) end
			end
			local asset = getcustomasset(fileName)
			if asset and asset ~= "" then return asset end
		end
		return url
	end)
	return (success and result) or url
end

local Rules = {
	{ids = {7658055825}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/grods.png"},
	{ids = {17803962335}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/attachment.png"},
	{ids = {13854780213}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/logo.png"},
	{ids = {13854780042}, url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartleft.png"},
	{ids = {81461991645938}, url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png"},
	{ids = {16802957270}, url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartbroken.png"},
	{ids = {99115398611290}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/icbtw.png"},
	{ids = {133917828562858, 121503061771505}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/mine.webp"},
	{ids = {17175092502, 17094014569}, url = "rbxassetid://72106446453934"},

	{ids = {106623367501544, 131795064007344, 73543520622815}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/f.png"},
	{ids = {80716950169934}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d-.png"},
	{ids = {136100661820261}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d.png"},
	{ids = {107898816876115}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d+.png"},
	{ids = {134520747948636}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c-.png"},
	{ids = {114166096331502}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c.png"},
	{ids = {90039594400813}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c+.png"},
	{ids = {133903971285645}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b-.png"},
	{ids = {82834564754747}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b.png"},
	{ids = {73345783863790}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b+.png"},
	{ids = {113997689031026}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a-.png"},
	{ids = {88059506918419}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a.png"},
	{ids = {112183171942172}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a+.png"},
	{ids = {104871954739030}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/s.png"},
	{ids = {109012386782238}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/ss.png"},
	{ids = {127982903682334}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/u.png"},
	{ids = {133793956251748}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/top200xrank.png"},
	{ids = {116941545385923}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/nemx.png"},

	{ids = {17138490999}, url = "rbxassetid://1721952882"},
	{ids = {103035811146294}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg"},
	{ids = {16810041280}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg"},
	{ids = {16810321565}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg"},
	{ids = {16770456156, 16492958314}, url = "rbxassetid://2428506580"},
	{ids = {16537337310, 16537449730}, url = "rbxassetid://70643163489676"},
	{ids = {17826470563}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/theeyellow.ogg"},
	{ids = {18221725850, 18239670056, 18221726246}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/winnerwinner.ogg"},
	{ids = {17026600996}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/showscore.base.ogg"},
	{ids = {16530229616}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill1.ogg"},
	{ids = {16530229541}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill2.ogg"},
	{ids = {16530229695}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill3.ogg"},
	{ids = {8483887957}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/clearspin.base.ogg"},
	{ids = {6384899588}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/lego-build.mp3"},
	{ids = {16737738420}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Sliding.mp3"},
	{ids = {70643163489676}, url = "rbxassetid://17405655409"},
	{ids = {91547731028928}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/studio-audience-awwww-sound-fx.mp3"},
	{ids = {138975587469438}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/final-fantasy-vii-victory-fanfare-1.mp3"},
	{ids = {17697682466, 17733314783}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kuchu-toshi.mp3"},
	{ids = {177266782}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/menuclick.base.ogg"},
	{ids = {18525513345}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/achievement_3.base.ogg"},
	{ids = {13110130082}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/target.base.ogg"},
	{ids = {17467242617}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/bluer.ogg"},
	{ids = {17016581922}, url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/elimin.mp3"},
}

local IdMap = {}
for _, rule in ipairs(Rules) do
	local asset = getAsset(rule.url)
	for _, id in ipairs(rule.ids) do IdMap[tostring(id)] = asset end
end

local function restoreAllOriginalAssets()
    for obj, props in pairs(OriginalAssets) do
        if obj and obj.Parent then
            for propName, origVal in pairs(props) do
                pcall(function() obj[propName] = origVal end)
            end
        end
    end
    table.clear(OriginalAssets)
    if ActivePackDisableFunc then
        ActivePackDisableFunc()
        ActivePackDisableFunc = nil
    end
    if ActivePackButton then
        ActivePackButton.Text = string.gsub(ActivePackButton.Text, "%[ON%]", "[OFF]")
        ActivePackButton.TextColor3 = Color3.fromRGB(210, 210, 215)
        ActivePackButton = nil
    end
end

local function applyTextureSwap(obj: Instance)
	if isUnloaded or not obj then return end

	local function replace(property: string)
		local success, value = pcall(function() return obj[property] end)
		if not success or type(value) ~= "string" then return end

		local id = string.match(value, "%d+")
		if id and IdMap[id] then
			if not OriginalAssets[obj] then OriginalAssets[obj] = {} end
			if not OriginalAssets[obj][property] then OriginalAssets[obj][property] = value end
			pcall(function() obj[property] = IdMap[id] end)
		end
	end

	if obj:IsA("Sound") then replace("SoundId")
	elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then replace("Image")
	elseif obj:IsA("Decal") or obj:IsA("Texture") then replace("Texture")
	elseif obj:IsA("MeshPart") then replace("TextureID") end
end

-- Fleasion Custom Pack Button
local FleasionPackBtn = Instance.new("TextButton")
FleasionPackBtn.Size = UDim2.new(1, 0, 0, 28)
FleasionPackBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FleasionPackBtn.BorderColor3 = Color3.fromRGB(65, 65, 70)
FleasionPackBtn.BorderSizePixel = 1
FleasionPackBtn.Font = Enum.Font.Code
FleasionPackBtn.Text = "[OFF] Fleasion Custom Pack"
FleasionPackBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
FleasionPackBtn.TextSize = 11
FleasionPackBtn.Parent = TexturesTab

local packEnabled = false
local textureConn = nil

TrackConnection(FleasionPackBtn.MouseButton1Click:Connect(function()
    packEnabled = not packEnabled
    if packEnabled then
        FleasionPackBtn.Text = "[ON] Fleasion Custom Pack"
        FleasionPackBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        batchProcess(game:GetDescendants(), applyTextureSwap, 150)

        textureConn = game.DescendantAdded:Connect(function(obj)
            if packEnabled and not isUnloaded and (obj:IsA("Sound") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("MeshPart")) then 
                task.defer(applyTextureSwap, obj) 
            end
        end)
        TrackConnection(textureConn)
    else
        FleasionPackBtn.Text = "[OFF] Fleasion Custom Pack"
        FleasionPackBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
        if textureConn then 
            textureConn:Disconnect()
            textureConn = nil 
        end
        restoreAllOriginalAssets()
    end
end))

-- ==========================================
-- MAP DARKENER SYSTEM
-- ==========================================
local darkenerEnabled = false
local darknessLevel = 10
local originalPartColors = setmetatable({}, {__mode = "k"})
local originalLighting = {
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient
}

local function getMultiplier()
    return (10 - darknessLevel) * 0.06
end

local function updateLighting()
    if darkenerEnabled and not isUnloaded then
        local mult = getMultiplier()
        Lighting.Brightness = mult
        Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(20 * mult), math.floor(20 * mult), math.floor(25 * mult))
        Lighting.Ambient = Color3.fromRGB(math.floor(15 * mult), math.floor(15 * mult), math.floor(20 * mult))
    end
end

local function darkenInstance(part)
    if isUnloaded or not darkenerEnabled or not part or not part:IsA("BasePart") or not part:IsDescendantOf(workspace) then return end
    
    local model = part:FindFirstAncestorOfClass("Model")
    if model and Players:GetPlayerFromCharacter(model) then return end
    if part.Name == "HumanoidRootPart" or (part.Parent and part.Parent.Name == "Camera") then return end

    if not originalPartColors[part] then
        originalPartColors[part] = part.Color
    end
    local h, s, v = Color3.toHSV(originalPartColors[part])
    local targetVal = math.clamp(v * getMultiplier(), 0, 1)
    part.Color = Color3.fromHSV(h, s, targetVal)
end

local function applyDarknessToAll()
    updateLighting()
    batchProcess(workspace:GetDescendants(), darkenInstance, 200)
end

local function restoreLightingAndMap()
    darkenerEnabled = false
    Lighting.Brightness = originalLighting.Brightness
    Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
    Lighting.Ambient = originalLighting.Ambient

    for part, origColor in pairs(originalPartColors) do
        if part and part:IsDescendantOf(workspace) then
            pcall(function() part.Color = origColor end)
        end
    end
    table.clear(originalPartColors)
end

local DarkenerBtn = Instance.new("TextButton")
DarkenerBtn.Size = UDim2.new(1, 0, 0, 28)
DarkenerBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DarkenerBtn.BorderColor3 = Color3.fromRGB(65, 65, 70)
DarkenerBtn.BorderSizePixel = 1
DarkenerBtn.Font = Enum.Font.Code
DarkenerBtn.Text = "[OFF] Map Darkener"
DarkenerBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
DarkenerBtn.TextSize = 11
DarkenerBtn.Parent = MapTab

-- Darkness Level Selector UI
local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(1, 0, 0, 18)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Font = Enum.Font.Code
LevelLabel.Text = "Darkness Level: [ 1 (Gray) -> 10 (Black) ]"
LevelLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
LevelLabel.TextSize = 10
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = MapTab

local LevelContainer = Instance.new("Frame")
LevelContainer.Size = UDim2.new(1, 0, 0, 26)
LevelContainer.BackgroundTransparency = 1
LevelContainer.Parent = MapTab

local LevelListLayout = Instance.new("UIListLayout")
LevelListLayout.FillDirection = Enum.FillDirection.Horizontal
LevelListLayout.SortOrder = Enum.SortOrder.LayoutOrder
LevelListLayout.Padding = UDim.new(0, 2)
LevelListLayout.Parent = LevelContainer

local LevelButtons = {}

for i = 1, 10 do
    local LvlBtn = Instance.new("TextButton")
    LvlBtn.Size = UDim2.new(0, 38, 1, 0)
    LvlBtn.BackgroundColor3 = (i == darknessLevel) and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(24, 24, 28)
    LvlBtn.BorderColor3 = (i == darknessLevel) and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 65)
    LvlBtn.BorderSizePixel = 1
    LvlBtn.Font = Enum.Font.Code
    LvlBtn.Text = tostring(i)
    LvlBtn.TextColor3 = (i == darknessLevel) and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(180, 180, 185)
    LvlBtn.TextSize = 10
    LvlBtn.Parent = LevelContainer

    table.insert(LevelButtons, LvlBtn)

    TrackConnection(LvlBtn.MouseButton1Click:Connect(function()
        darknessLevel = i
        for idx, btn in ipairs(LevelButtons) do
            btn.BackgroundColor3 = (idx == darknessLevel) and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(24, 24, 28)
            btn.BorderColor3 = (idx == darknessLevel) and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 65)
            btn.TextColor3 = (idx == darknessLevel) and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(180, 180, 185)
        end
        if darkenerEnabled then
            applyDarknessToAll()
        end
    end))
end

local darkenerConn = nil

TrackConnection(DarkenerBtn.MouseButton1Click:Connect(function()
    darkenerEnabled = not darkenerEnabled
    DarkenerBtn.Text = darkenerEnabled and "[ON] Map Darkener" or "[OFF] Map Darkener"
    DarkenerBtn.TextColor3 = darkenerEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(210, 210, 215)

    if darkenerEnabled then
        applyDarknessToAll()
        darkenerConn = workspace.DescendantAdded:Connect(function(obj)
            if darkenerEnabled and not isUnloaded and obj:IsA("BasePart") then 
                task.defer(darkenInstance, obj) 
            end
        end)
        TrackConnection(darkenerConn)
    else
        if darkenerConn then 
            darkenerConn:Disconnect()
            darkenerConn = nil 
        end
        restoreLightingAndMap()
    end
end))

-- ==========================================
-- PATIENCE
-- ==========================================
local RunScriptBtn = Instance.new("TextButton")
RunScriptBtn.Size = UDim2.new(1, 0, 0, 28)
RunScriptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
RunScriptBtn.BorderColor3 = Color3.fromRGB(65, 65, 70)
RunScriptBtn.BorderSizePixel = 1
RunScriptBtn.Font = Enum.Font.Code
RunScriptBtn.Text = "Execute mc texture"
RunScriptBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
RunScriptBtn.TextSize = 11
RunScriptBtn.Parent = ScriptsTab

local NoticeLabel = Instance.new("TextLabel")
NoticeLabel.Size = UDim2.new(1, 0, 0, 65)
NoticeLabel.BackgroundTransparency = 1
NoticeLabel.Font = Enum.Font.Code
NoticeLabel.Text = "⚠️ NOTICE: This texture pack might load slowly if you execute first time!\n⚠️ Please turn off texture before you execute this texture\n⚠️ Please wait a second if you're first time load mc texture\n⚠️ if you execute this texture, you cant use other texture\n(you can use map darkener even you execute this texture)"
NoticeLabel.TextColor3 = Color3.fromRGB(240, 180, 80)
NoticeLabel.TextSize = 10
NoticeLabel.TextWrapped = true
NoticeLabel.TextXAlignment = Enum.TextXAlignment.Left
NoticeLabel.Parent = ScriptsTab

TrackConnection(RunScriptBtn.MouseButton1Click:Connect(function()
    RunScriptBtn.Text = "Loading... (Please wait)"
    RunScriptBtn.TextColor3 = Color3.fromRGB(240, 200, 100)
    task.spawn(function()
        local s, e = pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/Cb9ExUkB"))() end)
        if not isUnloaded then
            if s then
                RunScriptBtn.Text = "mc texture Loaded Successfully!"
                RunScriptBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                RunScriptBtn.Text = "Failed to load"
                RunScriptBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end)
end))

-- ==========================================
-- ULTIMATE CRASH/UNLOAD SYSTEM
-- ==========================================
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(1, 0, 0, 32)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
UnloadBtn.BorderColor3 = Color3.fromRGB(120, 50, 50)
UnloadBtn.BorderSizePixel = 1
UnloadBtn.Font = Enum.Font.Code
UnloadBtn.Text = "❌ UNLOAD SCRIPT"
UnloadBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
UnloadBtn.TextSize = 12
UnloadBtn.Parent = SettingsTab

local function Unload()
    if isUnloaded then return end
    isUnloaded = true 

    -- 1. no (Connections / Events)
    for _, conn in ipairs(Connections) do
        if conn and conn.Connected then
            pcall(function() conn:Disconnect() end)
        end
    end
    table.clear(Connections)

    -- 2. Textures & Lighting
    restoreAllOriginalAssets()
    restoreLightingAndMap()

    -- 3. ui killer
    if ScreenGui then
        pcall(function() ScreenGui:Destroy() end)
    end

    -- 4. clear
    table.clear(OriginalAssets)
    table.clear(originalPartColors)
    table.clear(IdMap)
    table.clear(Rules)
    table.clear(Tabs)
    table.clear(LevelButtons)

    -- 5.  GC disappear
    pcall(function()
        collectgarbage("collect")
    end)
end

TrackConnection(UnloadBtn.MouseButton1Click:Connect(Unload))