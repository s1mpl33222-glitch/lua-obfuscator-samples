local Config = {
    service = "ExFTF v2",
    provider = "v2",
    identifier = "1000255",
}
local JunkieKeySystem = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
JunkieKeySystem.service = Config.service
JunkieKeySystem.provider = Config.provider
JunkieKeySystem.identifier = Config.identifier

local function CreateObject(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local isChecking = false

local function SmoothTween(obj, time, properties)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local KeySystemData = {
    Name = "Extended Flee The Facility",
    Colors = {
        Background = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(255, 70, 90),
        Title = Color3.fromRGB(255, 90, 100),
        InputField = Color3.fromRGB(18, 18, 24),
        InputFieldBorder = Color3.fromRGB(255, 70, 90),
        Button = Color3.fromRGB(255, 70, 90),
        ButtonHover = Color3.fromRGB(30, 30, 38),
        Error = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 220, 160),
        Discord = Color3.fromRGB(88, 101, 242)
    },
    Service = "redexecutor",
    DiscordInvite = "hMVyXBx8tF",
    FileName = "redexecutor/key.txt"
}

local function saveKey(key)
    if writefile then
        writefile(KeySystemData.FileName, key)
    end
end

local function loadSavedKey()
    if readfile and isfile and isfile(KeySystemData.FileName) then
        return readfile(KeySystemData.FileName)
    end
    return nil
end

local Blur = Instance.new("BlurEffect")
Blur.Name = "KeySystemBlur"
Blur.Size = 0
Blur.Parent = Lighting
SmoothTween(Blur, 0.4, { Size = 18 })

local ScreenGui = CreateObject("ScreenGui", {
    Name = "RedExecutorKeySystem", 
    Parent = CoreGui, 
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
})

local function ButtonBurst(button)
    local burstCount = math.random(8, 12)
    local centerX = button.AbsolutePosition.X + button.AbsoluteSize.X / 2
    local centerY = button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2

    for i = 1, burstCount do
        local ray = Instance.new("Frame")
        ray.Size = UDim2.new(0, 6, 0, math.random(14, 20))
        ray.AnchorPoint = Vector2.new(0.5, 1)
        ray.BackgroundColor3 = button.BackgroundColor3
        ray.BackgroundTransparency = 0
        ray.Rotation = math.random(0, 360)
        ray.Position = UDim2.fromOffset(centerX, centerY)
        ray.ZIndex = 50
        ray.Parent = ScreenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ray

        local angle = math.rad(ray.Rotation)
        local distance = math.random(30, 50)
        local targetPos = UDim2.fromOffset(centerX + math.cos(angle) * distance, centerY + math.sin(angle) * distance)

        TweenService:Create(ray, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos, BackgroundTransparency = 1, Size = UDim2.new(0, 2, 0, 8)
        }):Play()

        task.delay(0.5, function() if ray then ray:Destroy() end end)
    end
end

local function AddClickImpact(button)
    local originalSize = button.Size
    local pressing = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pressing = true
            SmoothTween(button, 0.08, { Size = originalSize - UDim2.fromOffset(4,4) })
        end
    end)

    button.InputEnded:Connect(function(input)
        if pressing and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            pressing = false
            SmoothTween(button, 0.12, { Size = originalSize })
            ButtonBurst(button)
        end
    end)
end

local MainFrame = CreateObject("Frame", {
    Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = KeySystemData.Colors.Background,
    BorderColor3 = KeySystemData.Colors.InputFieldBorder, BorderSizePixel = 2,
    Position = UDim2.new(0.5, 0, 0.4, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 0, 0, 0), ClipsDescendants = true, BackgroundTransparency = 1
})

local Glass = Instance.new("Frame")
Glass.Name = "Glass"; Glass.Parent = MainFrame; Glass.Size = UDim2.fromScale(1, 1)
Glass.Position = UDim2.new(0, 0, 0, 0); Glass.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Glass.BackgroundTransparency = 0.25; Glass.BorderSizePixel = 0; Glass.ZIndex = 0
CreateObject("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Glass })

local glassGrad = Instance.new("UIGradient")
glassGrad.Parent = Glass; glassGrad.Rotation = 90
glassGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))}

local SnowLayer = Instance.new("Frame")
SnowLayer.Name = "SnowLayer"; SnowLayer.Parent = MainFrame; SnowLayer.BackgroundTransparency = 1
SnowLayer.Size = UDim2.fromScale(1, 1); SnowLayer.Position = UDim2.new(0, 0, 0, 0); SnowLayer.ZIndex = 1

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame; MainStroke.Color = Color3.fromRGB(180, 60, 70)
MainStroke.Thickness = 1; MainStroke.Transparency = 0.25

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Parent = MainFrame; GlowStroke.Color = Color3.fromRGB(255, 70, 90)
GlowStroke.Thickness = 5; GlowStroke.Transparency = 0.85
task.spawn(function()
    while GlowStroke.Parent do
        SmoothTween(GlowStroke, 1.2, { Transparency = 0.9 })
        task.wait(1.2)
        SmoothTween(GlowStroke, 1.2, { Transparency = 0.7 })
        task.wait(1.2)
    end
end)

local TitleBar = CreateObject("Frame", {
    Name = "TitleBar", Parent = MainFrame, BackgroundColor3 = KeySystemData.Colors.Background,
    Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0)
})
CreateObject("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TitleBar })

local CloseButton = CreateObject("TextButton", {
    Name = "CloseButton", Parent = TitleBar, BackgroundTransparency = 1,
    Position = UDim2.new(1, -28, 0.5, 0), Size = UDim2.new(0, 20, 0, 20), Text = "X",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = KeySystemData.Colors.Title,
    AnchorPoint = Vector2.new(0.5, 0.5), AutoButtonColor = false
})

local Title = CreateObject("TextLabel", {
    Name = "Title", Parent = TitleBar, BackgroundTransparency = 1, Text = KeySystemData.Name .. " Key System",
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 200, 0, 20), Font = Enum.Font.GothamBold,
    TextColor3 = KeySystemData.Colors.Title, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center, AnchorPoint = Vector2.new(0.5, 0.5)
})
local TitleStroke = Instance.new("UIStroke"); TitleStroke.Parent = Title
TitleStroke.Color = Color3.fromRGB(255, 60, 80); TitleStroke.Thickness = 1.5; TitleStroke.Transparency = 0.6

local KeyInput = CreateObject("TextBox", {
    Name = "KeyInput", Parent = MainFrame, BackgroundColor3 = KeySystemData.Colors.InputField,
    Text = "", PlaceholderText = "ENTER ACCESS KEY", Font = Enum.Font.GothamMedium,
    TextSize = 14, TextColor3 = Color3.fromRGB(230, 230, 235), PlaceholderColor3 = Color3.fromRGB(140, 145, 160),
    TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0.5, 0, 0.3, 0),
    Size = UDim2.new(0, 280, 0, 36), AnchorPoint = Vector2.new(0.5, 0), ClipsDescendants = true, ClearTextOnFocus = false
})
CreateObject("UICorner", { Parent = KeyInput, CornerRadius = UDim.new(0, 6) })
local KeyStroke = CreateObject("UIStroke", { Parent = KeyInput, Color = KeySystemData.Colors.Accent, Thickness = 1, Transparency = 0.6 })
CreateObject("UIPadding", { Parent = KeyInput, PaddingLeft = UDim.new(0, 12) })

KeyInput.Focused:Connect(function() SmoothTween(KeyStroke, 0.2, { Transparency = 0.25 }) end)
KeyInput.FocusLost:Connect(function() SmoothTween(KeyStroke, 0.2, { Transparency = 0.6 }) end)

local SubmitButton = CreateObject("TextButton", {
    Name = "ValidateButton", Parent = MainFrame, BackgroundColor3 = KeySystemData.Colors.Accent,
    BorderSizePixel = 0, Position = UDim2.new(0.3, 0, 0.55, 0), Size = UDim2.new(0, 110, 0, 32),
    Text = "Check Key", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false, AnchorPoint = Vector2.new(0.5, 0)
})
CreateObject("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SubmitButton})

local GetKeyButton = CreateObject("TextButton", {
    Name = "GetKeyButton", Parent = MainFrame, BackgroundColor3 = KeySystemData.Colors.Button,
    BorderColor3 = KeySystemData.Colors.Accent, BorderSizePixel = 1, Position = UDim2.new(0.7, 0, 0.55, 0),
    Size = UDim2.new(0, 110, 0, 32), Text = "Get Key", Font = Enum.Font.GothamBold, TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255), AutoButtonColor = false, AnchorPoint = Vector2.new(0.5, 0)
})
CreateObject("UICorner", {CornerRadius = UDim.new(0, 6), Parent = GetKeyButton})

local DiscordButton = CreateObject("TextButton", {
    Name = "DiscordButton", Parent = MainFrame, BackgroundColor3 = KeySystemData.Colors.Discord,
    Position = UDim2.new(0.5, 0, 0.75, 0), Size = UDim2.new(0, 220, 0, 32), Text = "Join Discord",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255, 255, 255),
    AutoButtonColor = false, AnchorPoint = Vector2.new(0.5, 0)
})
CreateObject("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DiscordButton})

AddClickImpact(SubmitButton); AddClickImpact(GetKeyButton); AddClickImpact(DiscordButton)

local StatusLabel = CreateObject("TextLabel", {
    Name = "StatusLabel", Parent = MainFrame, BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 0.9, 0), Size = UDim2.new(0, 280, 0, 20),
    Font = Enum.Font.Gotham, Text = "", TextColor3 = KeySystemData.Colors.Error, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center, AnchorPoint = Vector2.new(0.5, 0), TextTransparency = 1
})

local function ShowStatusMessage(text, color)
    StatusLabel.Text = text; StatusLabel.TextColor3 = color; StatusLabel.TextTransparency = 0
    SmoothTween(StatusLabel, 0.3, {TextTransparency = 0})
    task.spawn(function()
        task.wait(3)
        if StatusLabel.Text == text then SmoothTween(StatusLabel, 0.5, {TextTransparency = 1}) end
    end)
end

local function closeGUI()
    local closeTween = SmoothTween(MainFrame, 0.4, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.55, 0, 0.45, 0), BackgroundTransparency = 1 })
    for _, child in pairs(MainFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then SmoothTween(child, 0.25, { TextTransparency = 1 }) end
        if child:IsA("GuiObject") and child.BackgroundTransparency < 1 then SmoothTween(child, 0.25, { BackgroundTransparency = 1 }) end
        if child:IsA("UIStroke") then SmoothTween(child, 0.25, { Transparency = 1 }) end
    end
    if Blur then SmoothTween(Blur, 0.3, { Size = 0 }) end
    closeTween.Completed:Connect(function()
        if Blur then Blur:Destroy() end
        ScreenGui:Destroy()
    end)
end

CloseButton.MouseButton1Click:Connect(function() closeGUI() end)

local function AddHoverEffect(button)
    local isDiscord = button.Name == "DiscordButton"
    button.MouseEnter:Connect(function() SmoothTween(button, 0.2, { BackgroundColor3 = KeySystemData.Colors.ButtonHover }) end)
    button.MouseLeave:Connect(function() SmoothTween(button, 0.2, { BackgroundColor3 = isDiscord and KeySystemData.Colors.Discord or KeySystemData.Colors.Button }) end)
end
AddHoverEffect(DiscordButton); AddHoverEffect(SubmitButton); AddHoverEffect(GetKeyButton)

local function openGetKey()
    local link = JunkieKeySystem.get_key_link() 
    if link then
        if setclipboard then setclipboard(link) ShowStatusMessage("Verification link copied!", KeySystemData.Colors.Success)
        else ShowStatusMessage("Link: " .. link, KeySystemData.Colors.Success) end
    else
        ShowStatusMessage("Failed to generate link", KeySystemData.Colors.Error)
    end
end

local function ShakeFrame(frame)
    local originalPos = frame.Position
    SmoothTween(frame, 0.05, { Position = originalPos + UDim2.fromOffset(6, 0) }); task.wait(0.05)
    SmoothTween(frame, 0.05, { Position = originalPos - UDim2.fromOffset(6, 0) }); task.wait(0.05)
    SmoothTween(frame, 0.05, { Position = originalPos })
end

local function validateKey()
    if isChecking then return end
    isChecking = true
    local userKey = KeyInput.Text:gsub("%s+", "")
    if userKey == "" then ShowStatusMessage("Please enter a key.", KeySystemData.Colors.Error) isChecking = false return end

    SubmitButton.BackgroundColor3 = KeySystemData.Colors.Accent
    local isValid = JunkieKeySystem.check_key(userKey)

    if isValid and isValid.valid then
        saveKey(userKey)
        ShowStatusMessage("Key valid! Loading...", KeySystemData.Colors.Success)
        task.wait(1)
        closeGUI()
        getgenv().SCRIPT_KEY = tostring(userKey)
    else
        ShowStatusMessage("Invalid key!", KeySystemData.Colors.Error)
        ShakeFrame(MainFrame)
        SmoothTween(SubmitButton, 0.25, { BackgroundColor3 = KeySystemData.Colors.Button })
    end
    isChecking = false
end

SubmitButton.MouseButton1Click:Connect(validateKey)
GetKeyButton.MouseButton1Click:Connect(openGetKey)

local dragging = false; local dragInput; local dragStart; local startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then if dragging then updateDrag(input) end end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateDrag(input) end end)

DiscordButton.MouseButton1Click:Connect(function()
    local discordUrl = "https://discord.gg/" .. KeySystemData.DiscordInvite
    if setclipboard then setclipboard(discordUrl) ShowStatusMessage("Copied Discord invite!", Color3.fromRGB(123, 48, 220))
    else ShowStatusMessage("Join: " .. discordUrl, Color3.fromRGB(123, 48, 220)) end
end)

local SnowFolder = Instance.new("Folder"); SnowFolder.Name = "Snowflakes"; SnowFolder.Parent = SnowLayer
local snowAssets = { Snow = "rbxassetid://73982236676952", Star = "rbxassetid://76247511279897", Gift = "rbxassetid://122427828955075", Tree = "rbxassetid://73234983261495" }

local function spawnSnowflake()
    local size = math.random(18, 32)
    local flake = Instance.new("ImageLabel")
    flake.BackgroundTransparency = 1; flake.ImageTransparency = 0; flake.AnchorPoint = Vector2.new(0.5, 0.5)
    flake.ScaleType = Enum.ScaleType.Fit; flake.ZIndex = 1; flake.Parent = SnowFolder

    local roll = math.random(1, 100)
    if roll <= 85 then flake.Image = snowAssets.Snow elseif roll <= 90 then flake.Image = snowAssets.Star elseif roll <= 95 then flake.Image = snowAssets.Gift else flake.Image = snowAssets.Tree end
    flake.Size = UDim2.new(0, size, 0, size)

    local xPos = math.random(5, 95) / 100
    flake.Position = UDim2.new(xPos, 0, 0.02, 0)
    local drift = math.random(-10, 10) / 100
    local targetX = math.clamp(xPos + drift, 0.05, 0.95)

    local totalTime = math.random(5, 9)
    if flake.Image == snowAssets.Tree then totalTime = totalTime + 3 elseif flake.Image == snowAssets.Gift then totalTime = totalTime + 2 elseif flake.Image == snowAssets.Star then totalTime = totalTime + 1 end

    local fallTween = TweenService:Create(flake, TweenInfo.new(totalTime * 0.8, Enum.EasingStyle.Linear), { Position = UDim2.new(targetX, 0, 0.85, 0) })
    fallTween:Play()

    fallTween.Completed:Connect(function()
        if not flake.Parent then return end
        local fadeTween = TweenService:Create(flake, TweenInfo.new(totalTime * 0.2, Enum.EasingStyle.Linear), { Position = UDim2.new(targetX, 0, 0.95, 0), ImageTransparency = 1 })
        fadeTween:Play()
        fadeTween.Completed:Connect(function() if flake.Parent then flake:Destroy() end end)
    end)

    if flake.Image == snowAssets.Star then
        task.spawn(function()
            while flake.Parent do
                TweenService:Create(flake, TweenInfo.new(0.7), { ImageTransparency = 0.2 }):Play(); task.wait(0.7)
                TweenService:Create(flake, TweenInfo.new(0.7), { ImageTransparency = 0 }):Play(); task.wait(0.7)
            end
        end)
    end

    if flake.Image == snowAssets.Tree then
        task.spawn(function() while flake.Parent do flake.Rotation = flake.Rotation + 0.3 task.wait(0.03) end end)
    else
        local rotationSpeed = math.random(-15, 15) * 0.6
        task.spawn(function() while flake.Parent do flake.Rotation = flake.Rotation + rotationSpeed task.wait(0.05) end end)
    end
end

task.spawn(function() while MainFrame.Parent do spawnSnowflake() task.wait(0.45) end end)

KeyInput.FocusLost:Connect(function(enterPressed) if enterPressed then validateKey() end end)

SmoothTween(MainFrame, 0.5, { Size = UDim2.new(0, 350, 0, 250), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 })

task.delay(0.3, function()
    local savedKey = loadSavedKey()
    if savedKey and savedKey ~= "" then
        KeyInput.Text = savedKey
        validateKey()
    end
end)
while (getgenv().SCRIPT_KEY == nil or getgenv().SCRIPT_KEY == "") do task.wait(0.1) end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/232e9e2c58ee5a4f7eb4decbae0e54d9b5c5ce3142d5ad6da74c192f83c5bcf4?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end