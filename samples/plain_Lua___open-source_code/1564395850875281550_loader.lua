local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Input = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local logoUrl = "https://vampauth.com/api/avatar/file/avatars/19499984-8998-4f2a-8253-8e4d1b89e271/uxpzw9ebamf_1792664527021.webp"

local function createWindow()
local parent = Players.LocalPlayer:WaitForChild("PlayerGui")
pcall(function() parent = gethui() end)
local old = parent:FindFirstChild("SentinelKeyUI")
if old then old:Destroy() end

local C = {
    panel = Color3.fromRGB(18, 19, 21), field = Color3.fromRGB(12, 13, 15),
    raised = Color3.fromRGB(27, 29, 32), line = Color3.fromRGB(43, 45, 50),
    white = Color3.fromRGB(235, 236, 238), muted = Color3.fromRGB(126, 130, 138),
    accent = Color3.fromRGB(91, 141, 239), ink = Color3.fromRGB(10, 17, 29),
}
local function make(class, props, owner)
    local object = Instance.new(class)
    for key, value in pairs(props) do object[key] = value end
    object.Parent = owner
    return object
end
local function corner(object, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end
local function border(object)
    return make("UIStroke", {Color = C.line, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, object)
end
local function animate(object, props, duration)
    local tween = TweenService:Create(object,
        TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end
local function text(owner, value, size, position, dimensions, color, bold)
    return make("TextLabel", {Text = value, TextSize = size,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        BackgroundTransparency = 1, TextColor3 = color or C.white,
        TextXAlignment = Enum.TextXAlignment.Left, Position = position, Size = dimensions}, owner)
end
local connections, alive = {}, true
local function on(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(connections, connection)
end
local gui = make("ScreenGui", {Name = "SentinelKeyUI", ResetOnSpawn = false,
    DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = false}, parent)
local root = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, gui)
local window = make("Frame", {Name = "Window", BackgroundColor3 = C.panel,
    BackgroundTransparency = 0.08, BorderSizePixel = 0, ClipsDescendants = true,
    Size = UDim2.fromOffset(420, 292)}, root)
corner(window, 8)
border(window)
local handle = make("TextButton", {Name = "DragHandle", Text = "",
    BackgroundTransparency = 1, Size = UDim2.new(1, -92, 0, 72),
    AutoButtonColor = false, Active = true}, window)
local mark = make("Frame", {BackgroundColor3 = C.raised, BorderSizePixel = 0,
    Position = UDim2.fromOffset(20, 22), Size = UDim2.fromOffset(28, 28)}, handle)
corner(mark, 6)
local markText = text(mark, "S", 15, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), C.ink, true)
markText.TextXAlignment = Enum.TextXAlignment.Center
markText.TextColor3 = C.accent
local logo = make("ImageLabel", {Name = "Logo", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4),
    ScaleType = Enum.ScaleType.Crop, Image = "", Visible = false}, mark)
corner(logo, 4)
task.spawn(function()
    local assetLoader = getcustomasset or getsynasset
    if type(assetLoader) ~= "function" or type(writefile) ~= "function" then return end
    local loaded, asset = pcall(function()
        local path = "sentinel-logo.webp"
        local hasFile = type(isfile) == "function" and isfile(path)
        if not hasFile then writefile(path, game:HttpGet(logoUrl)) end
        return assetLoader(path)
    end)
    if loaded and type(asset) == "string" and asset ~= "" and logo.Parent then
        logo.Image = asset
        logo.Visible = true
        markText.Visible = false
    end
end)
text(handle, "SENTINEL", 15, UDim2.fromOffset(60, 17), UDim2.fromOffset(150, 20), C.white, true)
text(handle, "KEY ACCESS", 10, UDim2.fromOffset(60, 38), UDim2.fromOffset(150, 16), C.muted, true)
local minimize = make("TextButton", {Name = "Minimize", Text = "-", BackgroundTransparency = 1,
    Position = UDim2.new(1, -82, 0, 20), Size = UDim2.fromOffset(28, 28),
    TextSize = 18, Font = Enum.Font.GothamMedium, TextColor3 = C.muted,
    BackgroundColor3 = C.line, BorderSizePixel = 0, AutoButtonColor = false}, window)
corner(minimize, 5)
on(minimize.MouseEnter, function() animate(minimize, {BackgroundTransparency = 0}) end)
on(minimize.MouseLeave, function() animate(minimize, {BackgroundTransparency = 1}) end)
local close = make("TextButton", {Name = "Close", Text = "", BackgroundTransparency = 1,
    Position = UDim2.new(1, -46, 0, 20), Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = C.line, BorderSizePixel = 0, AutoButtonColor = false}, window)
corner(close, 5)
for _, angle in ipairs({45, -45}) do
    make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(11, 1), Rotation = angle,
        BackgroundColor3 = C.muted, BorderSizePixel = 0}, close)
end
on(close.MouseEnter, function() animate(close, {BackgroundTransparency = 0}) end)
on(close.MouseLeave, function() animate(close, {BackgroundTransparency = 1}) end)
on(close.Activated, function() gui:Destroy() end)

make("Frame", {Position = UDim2.fromOffset(20, 71), Size = UDim2.new(1, -40, 0, 1),
    BackgroundColor3 = C.line, BorderSizePixel = 0}, window)
local description = text(window, "LICENSE KEY", 10,
    UDim2.fromOffset(20, 91), UDim2.new(1, -40, 0, 16), C.muted, true)
local field = make("Frame", {Name = "KeyField", Position = UDim2.fromOffset(20, 114),
    Size = UDim2.new(1, -40, 0, 50), BackgroundColor3 = C.field,
    BackgroundTransparency = 0.12, BorderSizePixel = 0}, window)
corner(field, 5)
local outline = border(field)
local input = make("TextBox", {Name = "KeyInput", Text = "", PlaceholderText = "Paste key",
    ClearTextOnFocus = false, MultiLine = false, TextSize = 15, Font = Enum.Font.Gotham,
    TextColor3 = C.white, PlaceholderColor3 = Color3.fromRGB(106, 109, 117),
    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15, 0), Size = UDim2.new(1, -30, 1, 0)}, field)
on(input.Focused, function() animate(outline, {Color = C.accent}) end)
on(input.FocusLost, function() animate(outline, {Color = C.line}) end)

local function button(value, primary, position, size)
    local base = primary and C.accent or C.raised
    local hover = primary and Color3.fromRGB(116, 160, 245) or Color3.fromRGB(35, 37, 41)
    local b = make("TextButton", {Text = value, Position = position, Size = size,
        Font = Enum.Font.GothamMedium, TextSize = 14, BorderSizePixel = 0,
        BackgroundColor3 = base, TextColor3 = primary and C.ink or C.white,
        AutoButtonColor = false}, window)
    corner(b, 5)
    if not primary then border(b) end
    local hovering, pressed = false, false
    local function update()
        animate(b, {BackgroundColor3 = pressed and (primary and C.white or C.line) or (hovering and hover or base)}, 0.14)
    end
    on(b.MouseEnter, function() hovering = true; update() end)
    on(b.MouseLeave, function() hovering = false; update() end)
    on(b.InputBegan, function(event)
        if event.UserInputType == Enum.UserInputType.Touch or event.UserInputType == Enum.UserInputType.MouseButton1 then
            pressed = true; update()
        end
    end)
    on(Input.InputEnded, function(event)
        if pressed and (event.UserInputType == Enum.UserInputType.Touch or event.UserInputType == Enum.UserInputType.MouseButton1) then
            pressed = false; update()
        end
    end)
    return b
end
local enter = button("CONTINUE", true, UDim2.fromOffset(20, 180), UDim2.new(1, -40, 0, 44))
local getKey = button("GET A KEY", false, UDim2.fromOffset(20, 234), UDim2.fromOffset(116, 34))
local feedback = text(window, "vampauth.com/sntl/flow", 11,
    UDim2.fromOffset(150, 242), UDim2.new(1, -170, 0, 18), C.muted)
feedback.TextXAlignment = Enum.TextXAlignment.Right
local function setStatus(message, highlighted)
    feedback.Text = message
    animate(feedback, {TextColor3 = highlighted and C.accent or C.muted})
end

local width, height, collapsed = 420, 292, false
local sizeTween
local content = {description, field, enter, getKey, feedback}
local position = Vector2.new()
local initialized, dragging = false, false
local touch, pointerStart, windowStart
local function clampPosition(p)
    local viewport = root.AbsoluteSize
    return Vector2.new(math.floor(math.clamp(p.X, 0, math.max(0, viewport.X - width)) + 0.5),
        math.floor(math.clamp(p.Y, 0, math.max(0, viewport.Y - (collapsed and 60 or height))) + 0.5))
end
local function place(p)
    position = clampPosition(p)
    window.Position = UDim2.fromOffset(position.X, position.Y)
end
local function fit()
    local viewport = root.AbsoluteSize
    if viewport.X < 1 or viewport.Y < 1 then return end
    width = math.min(420, math.max(1, viewport.X - 24))
    if sizeTween then sizeTween:Cancel() end
    window.Size = UDim2.fromOffset(width, collapsed and 60 or height)
    if not initialized then
        initialized = true
        place(Vector2.new((viewport.X - width) / 2, (viewport.Y - height) / 2))
    else
        dragging = false
        place(position)
    end
end
on(root:GetPropertyChangedSignal("AbsoluteSize"), fit)
fit()
local function beginDrag(event)
    local isTouch = event.UserInputType == Enum.UserInputType.Touch
    if dragging or (not isTouch and event.UserInputType ~= Enum.UserInputType.MouseButton1) then return end
    dragging = true
    touch = isTouch and event or nil
    pointerStart = isTouch and Vector2.new(event.Position.X, event.Position.Y) or Input:GetMouseLocation()
    windowStart = position
end
on(handle.InputBegan, beginDrag)
local edges = {}
for _, spec in ipairs({
    {"Bottom", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16)},
    {"Left", UDim2.fromOffset(0, 60), UDim2.new(0, 14, 1, -76)},
    {"Right", UDim2.new(1, -14, 0, 60), UDim2.new(0, 14, 1, -76)},
}) do
    local edge = make("TextButton", {Name = spec[1] .. "Drag", Text = "",
        BackgroundTransparency = 1, Position = spec[2], Size = spec[3],
        Active = true, AutoButtonColor = false}, window)
    table.insert(edges, edge)
    on(edge.InputBegan, beginDrag)
end
on(RunService.RenderStepped, function()
    if not dragging then return end
    local pointer = touch and Vector2.new(touch.Position.X, touch.Position.Y) or Input:GetMouseLocation()
    place(windowStart + (pointer - pointerStart))
end)
on(Input.InputEnded, function(event)
    if event == touch or (not touch and event.UserInputType == Enum.UserInputType.MouseButton1) then
        dragging = false
        touch = nil
    end
end)
on(Input.WindowFocusReleased, function() dragging = false; touch = nil end)
on(gui.Destroying, function()
    alive = false
    for _, connection in ipairs(connections) do connection:Disconnect() end
end)

local function revealText(owner)
    local objects = {owner}
    for _, child in ipairs(owner:GetDescendants()) do table.insert(objects, child) end
    for _, object in ipairs(objects) do
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            object.TextTransparency = 1
            animate(object, {TextTransparency = 0}, 0.32)
        end
    end
end
revealText(window)
on(minimize.Activated, function()
    collapsed = not collapsed
    minimize.Text = collapsed and "+" or "-"
    for _, object in ipairs(content) do object.Visible = not collapsed end
    for _, edge in ipairs(edges) do edge.Visible = not collapsed end
    if collapsed then input:ReleaseFocus() end
    if sizeTween then sizeTween:Cancel() end
    sizeTween = animate(window, {Size = UDim2.fromOffset(width, collapsed and 60 or height)}, 0.28)
    place(position)
    if not collapsed then
        for _, object in ipairs(content) do revealText(object) end
    end
end)

return {
    key = input,
    submit = enter,
    copy = getKey,
    connect = on,
    status = setStatus,
    exists = function() return alive end,
    loading = function(value)
        input.TextEditable = not value
        enter.Text = value and "LOADING..." or "CONTINUE"
    end,
}
end

local keyLink = "https://vampauth.com/sntl/flow"
local games = {
    [10258991999] = {101770480176177, "53b9be9121357bb73a0295e91d178357"},
    [10563114921] = {107778070777162, "4836c1b2793b60c954f44b523235378a"},
    [10629695169] = {72858262610964, "cd2b5a1858999ebe95a2ca847ebb62af"},
    [10155360168] = {126987974021910, "0cdb6f3516494459713f87747f1b7cc8"},
    [10764627709] = {107535308163741, "b92ef76518127fd7f7ee5173cf3b0ca9"},
    [10708913337] = {113290951185459, "6774f2ac818c872ba6cade68c0f72f15"},
    [10765288803] = {114326934417838, "60afde9ea5ca19a22d57c9421f145958"},
    [7468338447] = {81440632616906, "ae0e4359ac03cad856c83e5516c019a0"},
    [10764415267] = {140067658687251, "777402ee029f29d5349f25eca2185acb"},
    [10673920146] = {99409088950210, "c538c3c9846865f5544070282c530857"},
    [10766008884] = {76943966208523, "e9331de35c476acd84aa69872be51519"},
    [10766056678] = {99679692310083, "5f20847938331adde420ee401d23440b"},
    [10292064735] = {97927337336367, "60bb8ad8c4b6a37440f0a4bd0b895316"},
    [6931042565] = {73956553001240, "6c95c648da3b4cbc5a8a8c3833fef1ef"},
}

local function findLoader()
    local match = games[game.GameId]
    if match then return match[2] end
    for _, entry in pairs(games) do
        if entry[1] == game.PlaceId then return entry[2] end
    end
    return nil
end

local ui = createWindow()
local running, copying = false, false
local messageId = 0

local function notify(message, highlighted)
    messageId = messageId + 1
    ui.status(message, highlighted)
    return messageId
end

local function copyLink()
    if copying or running then return end
    copying = true
    local clipboard = setclipboard or toclipboard
    local copied = type(clipboard) == "function" and pcall(clipboard, keyLink)
    ui.copy.Text = copied and "COPIED" or "GET A KEY"
    local id = notify(copied and "Link copied to clipboard." or keyLink, copied)
    task.delay(2, function()
        if not ui.exists() then return end
        copying = false
        ui.copy.Text = "GET A KEY"
        if id == messageId then notify("vampauth.com/sntl/flow") end
    end)
end

local function submitKey()
    if running or not ui.exists() then return end
    local key = ui.key.Text:match("^%s*(.-)%s*$")
    if key == "" then
        notify("Enter a key first.")
        ui.key:CaptureFocus()
        return
    end

    local loader = findLoader()
    if not loader then
        notify("This game isn't supported.")
        return
    end

    running = true
    ui.key:ReleaseFocus()
    ui.loading(true)
    notify("Downloading loader...", true)

    task.spawn(function()
        local loaded = pcall(function()
            getgenv().script_key = key
            local source = game:HttpGet("https://vampauth.com/v1/loaders/" .. loader .. ".lua")
            if not ui.exists() then return end
            local run = loadstring(source)
            if type(run) ~= "function" then error("Loader could not compile", 0) end
            notify("Running loader...", true)
            run()
        end)
        key = nil
        if not ui.exists() then return end
        running = false
        ui.loading(false)
        notify(loaded and "Loader finished." or "Couldn't run the loader. Try again.")
    end)
end

ui.connect(ui.copy.Activated, copyLink)
ui.connect(ui.submit.Activated, submitKey)
ui.connect(ui.key.FocusLost, function(enterPressed)
    if enterPressed then submitKey() end
end)
