local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Screen = workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Scaling optimization
local function scaleY(value)
    return math.floor(value * (Screen.Y / 1080) * (isMobile and 2 or 1.3))
end

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()
end)

local Settings = { Speed = 1, StopOnMove = true }
local savedEmotes = {}
local SAVE_FILE = "nothing_remotes_CleanSaved.json"

local function loadSavedEmotes()
    pcall(function()
        if readfile and isfile and isfile(SAVE_FILE) then
            local data = HttpService:JSONDecode(readfile(SAVE_FILE))
            if type(data) == "table" then savedEmotes = data end
        end
    end)
end

local function saveEmotesToData()
    pcall(function()
        if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(savedEmotes)) end
    end)
end
loadSavedEmotes()

local CurrentTrack = nil
local loopConnection

local function LoadTrack(id)
    if CurrentTrack then CurrentTrack:Stop(0.1) end
    
    local animId
    local ok, result = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and result and #result > 0 and result[1]:IsA("Animation") then
        animId = result[1].AnimationId
    else
        animId = "rbxassetid://" .. tostring(id)
    end
    
    local newAnim = Instance.new("Animation")
    newAnim.AnimationId = animId
    local newTrack = humanoid:LoadAnimation(newAnim)
    newTrack.Priority = Enum.AnimationPriority.Action4
    newTrack.Looped = true
    
    for _, t in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if t.Priority ~= Enum.AnimationPriority.Action4 then t:Stop(0.1) end
    end
    
    newTrack:Play(0.1, 1, Settings.Speed)
    CurrentTrack = newTrack
end

loopConnection = RunService.RenderStepped:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        local root = character.HumanoidRootPart
        if Settings.StopOnMove and CurrentTrack and CurrentTrack.IsPlaying then
            local moved = (root.Position - lastPosition).Magnitude > 0.1
            local jumped = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Jumping
            if moved or jumped then
                CurrentTrack:Stop(0.1)
                CurrentTrack = nil
            end
        end
        lastPosition = root.Position
    end
end)

local THEME = {
    MainBg = Color3.fromRGB(15, 15, 15),
    SecBg = Color3.fromRGB(25, 25, 25),
    TertBg = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Red = Color3.fromRGB(180, 50, 50),
    Green = Color3.fromRGB(50, 160, 50)
}

local gui = Instance.new("ScreenGui")
gui.Name = "NothingRemotesGUI"
gui.Parent = CoreGui
gui.DisplayOrder = 999
gui.ResetOnSpawn = false

local screonGui = Instance.new("ScreenGui")
screonGui.Name = "NothingToggleGui"
screonGui.Parent = gui
screonGui.ResetOnSpawn = false


-- Audio Setup
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://876939830"
ClickSound.Volume = 1
ClickSound.Parent = gui
local function PlayClick()
    ClickSound:Play()
end
task.spawn(function()
end)

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- MAIN CONTAINER: Vertical UI Layout
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, scaleY(320), 0.85, 0)
mainContainer.Position = UDim2.new(1, -scaleY(340), 0.075, 0)
mainContainer.BackgroundColor3 = THEME.MainBg
mainContainer.Active = true
mainContainer.Draggable = true
mainContainer.Parent = gui
createCorner(mainContainer, 8)
Instance.new("UIStroke", mainContainer).Color = THEME.Accent

-- TITLE BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, scaleY(35))
topBar.BackgroundColor3 = THEME.SecBg
topBar.Parent = mainContainer
createCorner(topBar, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Emotes"
title.TextColor3 = THEME.Text
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- WINDOW CONTROLS
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, scaleY(30), 0, scaleY(25))
closeBtn.Position = UDim2.new(1, -scaleY(35), 0.5, -scaleY(12.5))
closeBtn.BackgroundColor3 = THEME.Red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = topBar
createCorner(closeBtn, 4)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, scaleY(30), 0, scaleY(25))
minBtn.Position = UDim2.new(1, -scaleY(70), 0.5, -scaleY(12.5))
minBtn.BackgroundColor3 = THEME.TertBg
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Parent = topBar
createCorner(minBtn, 4)

-- CLOSE CONFIRMATION POPUP
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(1, 0, 1, 0)
confirmFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
confirmFrame.BackgroundTransparency = 0.4
confirmFrame.Visible = false
confirmFrame.ZIndex = 100
confirmFrame.Parent = mainContainer
createCorner(confirmFrame, 8)

local promptBox = Instance.new("Frame")
promptBox.Size = UDim2.new(0.8, 0, 0.2, 0)
promptBox.Position = UDim2.new(0.1, 0, 0.4, 0)
promptBox.BackgroundColor3 = THEME.SecBg
promptBox.ZIndex = 101
promptBox.Parent = confirmFrame
createCorner(promptBox, 8)

local promptText = Instance.new("TextLabel")
promptText.Size = UDim2.new(1, 0, 0.5, 0)
promptText.BackgroundTransparency = 1
promptText.Text = "Close script?"
promptText.Font = Enum.Font.GothamBold
promptText.TextColor3 = THEME.Text
promptText.TextScaled = true
promptText.ZIndex = 101
promptText.Parent = promptBox

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0.4, 0, 0.35, 0)
yesBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
yesBtn.BackgroundColor3 = THEME.Red
yesBtn.Text = "Yes"
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextColor3 = THEME.Text
yesBtn.TextScaled = true
yesBtn.ZIndex = 101
yesBtn.Parent = promptBox
createCorner(yesBtn, 4)

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0.4, 0, 0.35, 0)
noBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
noBtn.BackgroundColor3 = THEME.TertBg
noBtn.Text = "No"
noBtn.Font = Enum.Font.GothamBold
noBtn.TextColor3 = THEME.Text
noBtn.TextScaled = true
noBtn.ZIndex = 101
noBtn.Parent = promptBox
createCorner(noBtn, 4)

closeBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = true end)
noBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = false end)
yesBtn.MouseButton1Click:Connect(function()
    -- Stop current emote
    if CurrentTrack then
        CurrentTrack:Stop(0.1)
        CurrentTrack:Destroy()
        CurrentTrack = nil
    end

    -- Disconnect loop
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    -- Destroy GUI
    gui:Destroy()
    screonGui:Destroy()
end)
minBtn.MouseButton1Click:Connect(function() mainContainer.Visible = false end)

-- TABS
local catalogTabBtn = Instance.new("TextButton")
catalogTabBtn.Size = UDim2.new(0.48, 0, 0, scaleY(25))
catalogTabBtn.Position = UDim2.new(0.01, 0, 0, scaleY(40))
catalogTabBtn.BackgroundColor3 = THEME.TertBg
catalogTabBtn.Text = "Catalog"
catalogTabBtn.TextColor3 = THEME.Text
catalogTabBtn.Font = Enum.Font.GothamBold
catalogTabBtn.TextScaled = true
catalogTabBtn.Parent = mainContainer
createCorner(catalogTabBtn, 6)

local savedTabBtn = Instance.new("TextButton")
savedTabBtn.Size = UDim2.new(0.48, 0, 0, scaleY(25))
savedTabBtn.Position = UDim2.new(0.51, 0, 0, scaleY(40))
savedTabBtn.BackgroundColor3 = THEME.SecBg
savedTabBtn.Text = "Saved"
savedTabBtn.TextColor3 = THEME.Text
savedTabBtn.Font = Enum.Font.GothamBold
savedTabBtn.TextScaled = true
savedTabBtn.Parent = mainContainer
createCorner(savedTabBtn, 6)

-- FULL WIDTH PAGES
local catalogFrame = Instance.new("Frame")
catalogFrame.Size = UDim2.new(1, -10, 1, -scaleY(70))
catalogFrame.Position = UDim2.new(0, 5, 0, scaleY(70))
catalogFrame.BackgroundTransparency = 1
catalogFrame.Parent = mainContainer

local savedFrame = Instance.new("Frame")
savedFrame.Size = UDim2.new(1, -10, 1, -scaleY(70))
savedFrame.Position = UDim2.new(0, 5, 0, scaleY(70))
savedFrame.BackgroundTransparency = 1
savedFrame.Visible = false
savedFrame.Parent = mainContainer

-- COMPACT CONTROLS WITH HORIZONTAL LAYOUT
local controlsRow = Instance.new("Frame")
controlsRow.Size = UDim2.new(1, 0, 0, scaleY(28))
controlsRow.BackgroundTransparency = 1
controlsRow.Parent = catalogFrame

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
controlsLayout.Padding = UDim.new(0, scaleY(4))
controlsLayout.Parent = controlsRow

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.38, 0, 1, 0)
searchBox.LayoutOrder = 1
searchBox.PlaceholderText = "Search..."
searchBox.BackgroundColor3 = THEME.SecBg
searchBox.TextColor3 = THEME.Text
searchBox.PlaceholderColor3 = THEME.SubText
searchBox.Font = Enum.Font.Gotham
searchBox.TextScaled = true
searchBox.Parent = controlsRow
createCorner(searchBox, 4)

local sortBtn = Instance.new("TextButton")
sortBtn.Size = UDim2.new(0.28, 0, 1, 0)
sortBtn.LayoutOrder = 2
sortBtn.BackgroundColor3 = THEME.TertBg
sortBtn.Text = "Best ∇"
sortBtn.Font = Enum.Font.GothamBold
sortBtn.TextColor3 = THEME.Text
sortBtn.TextScaled = true
sortBtn.Parent = controlsRow
createCorner(sortBtn, 4)

local toggleBtnUI = Instance.new("TextButton")
toggleBtnUI.Size = UDim2.new(0.18, 0, 1, 0)
toggleBtnUI.LayoutOrder = 3
toggleBtnUI.BackgroundColor3 = THEME.Green
toggleBtnUI.Text = "Stop: ON"
toggleBtnUI.Font = Enum.Font.GothamBold
toggleBtnUI.TextColor3 = Color3.new(1,1,1)
toggleBtnUI.TextScaled = true
toggleBtnUI.Parent = controlsRow
createCorner(toggleBtnUI, 4)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.12, 0, 1, 0)
speedBox.LayoutOrder = 4
speedBox.BackgroundColor3 = THEME.SecBg
speedBox.TextColor3 = THEME.Text
speedBox.Text = "1x"
speedBox.Font = Enum.Font.GothamBold
speedBox.TextScaled = true
speedBox.Parent = controlsRow
createCorner(speedBox, 4)

-- SORT DROPDOWN UI
local sortDropdown = Instance.new("Frame")
sortDropdown.Size = UDim2.new(0.35, 0, 0, scaleY(150))
sortDropdown.Position = UDim2.new(0.38, scaleY(4), 0, scaleY(32))
sortDropdown.BackgroundColor3 = THEME.SecBg
sortDropdown.Visible = false
sortDropdown.ZIndex = 50
sortDropdown.Parent = catalogFrame
createCorner(sortDropdown, 6)

local sortDropdownLayout = Instance.new("UIListLayout")
sortDropdownLayout.FillDirection = Enum.FillDirection.Vertical
sortDropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
sortDropdownLayout.Parent = sortDropdown

local function getSafeEnum(enumObj, name1, name2, fallback)
    local ok, val = pcall(function() return enumObj[name1] end)
    if ok and val then return val end
    ok, val = pcall(function() return enumObj[name2] end)
    return (ok and val) and val or fallback
end

local SortModes = {
    {Name = "Best", Enum = Enum.CatalogSortType.Relevance},
    {Name = "Most Sold", Enum = getSafeEnum(Enum.CatalogSortType, "MostSales", "Bestselling", Enum.CatalogSortType.Relevance)},
    {Name = "Newest", Enum = Enum.CatalogSortType.RecentlyCreated},
    {Name = "Most Fav", Enum = getSafeEnum(Enum.CatalogSortType, "MostFavorited", "Favorited", Enum.CatalogSortType.Relevance)},
    {Name = "Rich", Enum = Enum.CatalogSortType.PriceHighToLow},
    {Name = "Unique", Enum = Enum.CatalogSortType.Relevance} -- Randomized locally
}

local currentSortOption = SortModes[1]
local doNewSearch -- Defined later

for i, mode in ipairs(SortModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, scaleY(25))
    btn.BackgroundColor3 = (i % 2 == 0) and THEME.TertBg or THEME.SecBg
    btn.Text = mode.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = THEME.Text
    btn.TextScaled = true
    btn.ZIndex = 51
    btn.Parent = sortDropdown
    
    btn.MouseButton1Click:Connect(function()
        currentSortOption = mode
        sortBtn.Text = mode.Name .. " ∇"
        sortDropdown.Visible = false
        doNewSearch(searchBox.Text)
    end)
end

sortBtn.MouseButton1Click:Connect(function()
    sortDropdown.Visible = not sortDropdown.Visible
end)

toggleBtnUI.MouseButton1Click:Connect(function()
    Settings.StopOnMove = not Settings.StopOnMove
    toggleBtnUI.Text = Settings.StopOnMove and "Stop: ON" or "Stop: OFF"
    toggleBtnUI.BackgroundColor3 = Settings.StopOnMove and THEME.Green or THEME.Red
end)

speedBox.FocusLost:Connect(function()
    local val = string.match(speedBox.Text, "%d+%.?%d*")
    local num = tonumber(val)
    if num then 
        Settings.Speed = math.clamp(num, 0.1, 5) 
        if CurrentTrack and CurrentTrack.IsPlaying then CurrentTrack:AdjustSpeed(Settings.Speed) end
    end
    speedBox.Text = tostring(Settings.Speed) .. "x"
end)

-- SCROLL FRAMES & GRIDS (3 items per row)
local function setupGrid(scrollFrame)
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0.31, 0, 0, scaleY(120))
    layout.CellPadding = UDim2.new(0.03, 0, 0, scaleY(8))
    layout.FillDirectionMaxCells = 3
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scrollFrame
    return layout
end

local catalogScroll = Instance.new("ScrollingFrame")
catalogScroll.Size = UDim2.new(1, 0, 1, -scaleY(65))
catalogScroll.Position = UDim2.new(0, 0, 0, scaleY(32))
catalogScroll.ScrollBarThickness = 2
catalogScroll.BackgroundTransparency = 1
catalogScroll.ZIndex = 1
catalogScroll.Parent = catalogFrame
local catLayout = setupGrid(catalogScroll)

local savedScroll = Instance.new("ScrollingFrame")
savedScroll.Size = UDim2.new(1, 0, 1, 0)
savedScroll.ScrollBarThickness = 2
savedScroll.BackgroundTransparency = 1
savedScroll.Parent = savedFrame
local savLayout = setupGrid(savedScroll)

-- PAGING CONTROLS
local pageRow = Instance.new("Frame")
pageRow.Size = UDim2.new(1, 0, 0, scaleY(25))
pageRow.Position = UDim2.new(0, 0, 1, -scaleY(28))
pageRow.BackgroundTransparency = 1
pageRow.Parent = catalogFrame

local prevBtn = Instance.new("TextButton", pageRow)
prevBtn.Size = UDim2.new(0.3, 0, 1, 0)
prevBtn.BackgroundColor3 = THEME.TertBg
prevBtn.Text = "< Prev"
prevBtn.Font = Enum.Font.GothamBold
prevBtn.TextColor3 = THEME.Text
prevBtn.TextScaled = true
createCorner(prevBtn, 4)

local nextBtn = Instance.new("TextButton", pageRow)
nextBtn.Size = UDim2.new(0.3, 0, 1, 0)
nextBtn.Position = UDim2.new(0.7, 0, 0, 0)
nextBtn.BackgroundColor3 = THEME.TertBg
nextBtn.Text = "Next >"
nextBtn.Font = Enum.Font.GothamBold
nextBtn.TextColor3 = THEME.Text
nextBtn.TextScaled = true
createCorner(nextBtn, 4)

local pageLabel = Instance.new("TextLabel", pageRow)
pageLabel.Size = UDim2.new(0.4, 0, 1, 0)
pageLabel.Position = UDim2.new(0.3, 0, 0, 0)
pageLabel.BackgroundTransparency = 1
pageLabel.Text = "Pg 1"
pageLabel.Font = Enum.Font.GothamBold
pageLabel.TextColor3 = THEME.Text
pageLabel.TextScaled = true

-- CATALOG LOGIC
local currentKeyword, currentPages = "", nil
local currentPageNumber = 1
local isLoading = false
local searchDebounce
local seenNames = {}

local function getPages(keyword)
    local params = CatalogSearchParams.new()
    params.SearchKeyword = keyword or ""
    params.AssetTypes = { Enum.AvatarAssetType.EmoteAnimation }
    params.SortType = currentSortOption.Enum
    params.Limit = 30
    
    local ok, pages = pcall(function() return AvatarEditorService:SearchCatalog(params) end)
    return ok and pages or nil
end

local function createItemCard(item, isSavedTab)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = THEME.SecBg
    createCorner(card, 6)
    
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -6, 0, scaleY(60))
    img.Position = UDim2.new(0, 3, 0, 3)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Fit
    pcall(function() img.Image = "rbxthumb://type=Asset&id=" .. (item.AssetId or item.Id) .. "&w=150&h=150" end)
    img.Parent = card
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -4, 0, scaleY(18))
    name.Position = UDim2.new(0, 2, 0, scaleY(65))
    name.BackgroundTransparency = 1
    name.Text = item.Name or "Emote"
    name.TextScaled = true
    name.Font = Enum.Font.GothamBold
    name.TextColor3 = THEME.Text
    name.Parent = card

    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0.45, 0, 0, scaleY(25))
    actionBtn.Position = UDim2.new(0.02, 0, 1, -scaleY(28))
    actionBtn.BackgroundColor3 = THEME.Green
    actionBtn.Text = "Play"
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.TextColor3 = THEME.Text
    actionBtn.TextScaled = true
    actionBtn.Parent = card
    createCorner(actionBtn, 4)
    actionBtn.MouseButton1Click:Connect(function() LoadTrack(item.AssetId or item.Id) end)

    local secBtn = Instance.new("TextButton")
    secBtn.Size = UDim2.new(0.45, 0, 0, scaleY(25))
    secBtn.Position = UDim2.new(0.53, 0, 1, -scaleY(28))
    secBtn.Font = Enum.Font.GothamBold
    secBtn.TextColor3 = THEME.Text
    secBtn.TextScaled = true
    secBtn.Parent = card
    createCorner(secBtn, 4)

    if isSavedTab then
        secBtn.BackgroundColor3 = THEME.Red
        secBtn.Text = "Del"
        secBtn.MouseButton1Click:Connect(function()
            for i, v in ipairs(savedEmotes) do
                if v.Id == item.Id then table.remove(savedEmotes, i); break end
            end
            saveEmotesToData()
            card:Destroy()
            savedScroll.CanvasSize = UDim2.new(0, 0, 0, savLayout.AbsoluteContentSize.Y + 10)
        end)
    else
        secBtn.BackgroundColor3 = THEME.Accent
        secBtn.Text = "Save"
        secBtn.MouseButton1Click:Connect(function()
            for _, v in ipairs(savedEmotes) do if v.Id == item.Id then return end end
            table.insert(savedEmotes, { Id = item.Id, AssetId = item.AssetId or item.Id, Name = item.Name })
            saveEmotesToData()
            secBtn.Text = "✓"
            task.delay(0.5, function() secBtn.Text = "Save" end)
        end)
    end
    return card
end

local function showPage(pages)
    if isLoading or not pages then return end
    isLoading = true
    for _, child in ipairs(catalogScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local ok, currentList = pcall(function() return pages:GetCurrentPage() end)
    if ok and currentList and #currentList > 0 then
        
        -- Local shuffle for the "Unique" category mode
        if currentSortOption.Name == "Unique" then
            for i = #currentList, 2, -1 do
                local j = math.random(i)
                currentList[i], currentList[j] = currentList[j], currentList[i]
            end
        end

        local itemsAdded = 0
        for _, item in ipairs(currentList) do
            local itemNameLower = string.lower(item.Name or "Unknown")
            
            -- Deduplication Note: Because Roblox API returns the data sorted by the user's selected category 
            -- (e.g., Best/Relevance, Highest Sales), keeping the *very first occurrence* we see naturally prioritizes 
            -- the highest ranked version over worse duplicates.
            if not seenNames[itemNameLower] then
                seenNames[itemNameLower] = true
                createItemCard(item, false).Parent = catalogScroll
                itemsAdded += 1
            end
        end
        
        if itemsAdded == 0 and not pages.IsFinished then
            pcall(function() pages:AdvanceToNextPageAsync() end)
            currentPageNumber += 1
            isLoading = false
            return showPage(pages)
        end
    end

    catalogScroll.CanvasSize = UDim2.new(0, 0, 0, catLayout.AbsoluteContentSize.Y + 10)
    pageLabel.Text = "Pg " .. currentPageNumber
    prevBtn.Visible = (currentPageNumber > 1)
    nextBtn.Visible = not pages.IsFinished
    isLoading = false
end

doNewSearch = function(keyword)
    currentKeyword = keyword
    currentPageNumber = 1
    seenNames = {} 
    currentPages = getPages(currentKeyword)
    showPage(currentPages)
end

-- AUTO SEARCH (Debounced)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then task.cancel(searchDebounce) end
    searchDebounce = task.delay(0.6, function()
        doNewSearch(searchBox.Text)
    end)
end)

nextBtn.MouseButton1Click:Connect(function()
    if currentPages and not currentPages.IsFinished then
        pcall(function() currentPages:AdvanceToNextPageAsync() end)
        currentPageNumber += 1
        showPage(currentPages)
    end
end)

prevBtn.MouseButton1Click:Connect(function()
    if currentPages and currentPageNumber > 1 then
        currentPageNumber -= 1
        local fresh = getPages(currentKeyword)
        if fresh then
            for i = 2, currentPageNumber do fresh:AdvanceToNextPageAsync() end
            currentPages = fresh
            showPage(currentPages)
        end
    end
end)

-- TAB SWITCHING
local function refreshSaved()
    for _, child in ipairs(savedScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, item in ipairs(savedEmotes) do createItemCard(item, true).Parent = savedScroll end
    savedScroll.CanvasSize = UDim2.new(0, 0, 0, savLayout.AbsoluteContentSize.Y + 10)
end

catalogTabBtn.MouseButton1Click:Connect(function()
    catalogFrame.Visible = true; savedFrame.Visible = false
    catalogTabBtn.BackgroundColor3 = THEME.TertBg; savedTabBtn.BackgroundColor3 = THEME.SecBg
end)

savedTabBtn.MouseButton1Click:Connect(function()
    catalogFrame.Visible = false; savedFrame.Visible = true
    catalogTabBtn.BackgroundColor3 = THEME.SecBg; savedTabBtn.BackgroundColor3 = THEME.TertBg
    refreshSaved()
end)

-- MINIMIZE TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screonGui
toggleBtn.Text = "EM"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextColor3 = THEME.Text
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = THEME.SecBg
toggleBtn.Size = UDim2.new(0, scaleY(45), 0, scaleY(45))
toggleBtn.Position = UDim2.new(0, 15, 0.5, 0)
toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
createCorner(toggleBtn, scaleY(45))

local dragInput, dragStart, startPos, dragging
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, toggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local clickTick = 0
toggleBtn.MouseButton1Down:Connect(function() clickTick = tick() end)
toggleBtn.MouseButton1Up:Connect(function() 
    if tick() - clickTick < 0.22 then mainContainer.Visible = not mainContainer.Visible end 
end)

task.spawn(function() doNewSearch("") end)