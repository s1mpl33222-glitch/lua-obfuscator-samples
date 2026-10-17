-- MetaScripts Custom JNkie Key System
-- This version intentionally DOES NOT auto-load or save keys.
-- Every execution asks for the key again, preventing cross-script saved-key reuse.

getgenv().SCRIPT_KEY = nil
getgenv().UI_CLOSED = false

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

Junkie.service = "صيد الضبان"
Junkie.identifier = "1190699"
Junkie.provider = "MetaScripts KeySystem"

local result = (function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local Player = Players.LocalPlayer
    local verifiedKey = nil
    local busy = false
    local closed = false

    local function New(className, props)
        local obj = Instance.new(className)
        for k, v in pairs(props or {}) do
            if k ~= "Parent" then
                pcall(function()
                    obj[k] = v
                end)
            end
        end
        if props and props.Parent then
            obj.Parent = props.Parent
        end
        return obj
    end

    local function Corner(parent, radius)
        return New("UICorner", {
            CornerRadius = UDim.new(0, radius or 8),
            Parent = parent
        })
    end

    local function Stroke(parent, color, transparency, thickness)
        return New("UIStroke", {
            Color = color,
            Transparency = transparency or 0,
            Thickness = thickness or 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent = parent
        })
    end

    local function safeDestroy(obj)
        if obj then
            pcall(function()
                obj:Destroy()
            end)
        end
    end

    -- Remove only an older copy of THIS custom UI.
    local guiParent
    if type(gethui) == "function" then
        local ok, value = pcall(gethui)
        if ok and value then
            guiParent = value
        end
    end
    guiParent = guiParent or CoreGui

    local old = guiParent:FindFirstChild("MetaScripts_JNkie_KeyUI")
    if old then
        old:Destroy()
    end

    local Gui = New("ScreenGui", {
        Name = "MetaScripts_JNkie_KeyUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = guiParent
    })

    local Backdrop = New("Frame", {
        Name = "Backdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.34,
        BorderSizePixel = 0,
        Parent = Gui
    })

    local Main = New("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(560, 300),
        BackgroundColor3 = Color3.fromRGB(10, 10, 12),
        BorderSizePixel = 0,
        Parent = Backdrop
    })
    Corner(Main, 12)
    Stroke(Main, Color3.fromRGB(70, 70, 82), 0.30, 1)

    local SizeConstraint = New("UISizeConstraint", {
        MinSize = Vector2.new(300, 260),
        MaxSize = Vector2.new(560, 300),
        Parent = Main
    })

    local function updateSize()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local v = cam.ViewportSize

        if v.X < 700 or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
            Main.Size = UDim2.new(
                1, -math.max(26, math.floor(v.X * 0.08)),
                0, math.min(300, math.max(260, v.Y - 80))
            )
        else
            Main.Size = UDim2.fromOffset(560, 300)
        end
    end

    updateSize()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
    end

    local TopBar = New("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Color3.fromRGB(14, 14, 17),
        BorderSizePixel = 0,
        Parent = Main
    })
    Corner(TopBar, 12)

    local TopFix = New("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Color3.fromRGB(14, 14, 17),
        BorderSizePixel = 0,
        Parent = TopBar
    })

    local Accent = New("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Color3.fromRGB(122, 82, 255),
        BorderSizePixel = 0,
        Parent = TopBar
    })

    local Title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 8),
        Size = UDim2.new(1, -70, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = "صيد الضبان",
        TextSize = 17,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    local Credit = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 30),
        Size = UDim2.new(1, -70, 0, 18),
        Font = Enum.Font.Gotham,
        Text = "Made By MetaScripts",
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    local Close = New("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Color3.fromRGB(27, 27, 32),
        BorderSizePixel = 0,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Color3.fromRGB(235, 235, 240),
        AutoButtonColor = false,
        Parent = TopBar
    })
    Corner(Close, 8)
    Stroke(Close, Color3.fromRGB(70, 70, 82), 0.35, 1)

    local Heading = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 78),
        Size = UDim2.new(1, -48, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "Key Verification",
        TextSize = 20,
        TextColor3 = Color3.fromRGB(245, 245, 248),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Main
    })

    local Sub = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 106),
        Size = UDim2.new(1, -48, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "Enter your key to continue",
        TextSize = 13,
        TextColor3 = Color3.fromRGB(155, 155, 168),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Main
    })

    local InputHolder = New("Frame", {
        Position = UDim2.fromOffset(24, 140),
        Size = UDim2.new(1, -48, 0, 48),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        BorderSizePixel = 0,
        Parent = Main
    })
    Corner(InputHolder, 9)
    local InputStroke = Stroke(InputHolder, Color3.fromRGB(65, 65, 76), 0.18, 1)

    local KeyBox = New("TextBox", {
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -28, 1, 0),
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter key...",
        PlaceholderColor3 = Color3.fromRGB(105, 105, 118),
        Text = "",
        TextSize = 14,
        TextColor3 = Color3.fromRGB(240, 240, 244),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = InputHolder
    })

    local Buttons = New("Frame", {
        Position = UDim2.fromOffset(24, 202),
        Size = UDim2.new(1, -48, 0, 44),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local GetKey = New("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(28, 28, 34),
        BorderSizePixel = 0,
        Text = "Get Key",
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(235, 235, 240),
        AutoButtonColor = false,
        Parent = Buttons
    })
    Corner(GetKey, 9)
    Stroke(GetKey, Color3.fromRGB(72, 72, 84), 0.25, 1)

    local Verify = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0.48, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(112, 72, 235),
        BorderSizePixel = 0,
        Text = "Verify Key",
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = Buttons
    })
    Corner(Verify, 9)

    local Status = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 24, 1, -42),
        Size = UDim2.new(1, -48, 0, 22),
        Font = Enum.Font.Gotham,
        Text = "Keys are not saved. Each run requires verification.",
        TextSize = 11,
        TextColor3 = Color3.fromRGB(120, 120, 132),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Main
    })

    local function setStatus(text, color)
        Status.Text = text
        Status.TextColor3 = color or Color3.fromRGB(150, 150, 162)
    end

    local function setBusy(value)
        busy = value
        KeyBox.TextEditable = not value
        Verify.Active = not value
        GetKey.Active = not value
        Verify.Text = value and "Checking..." or "Verify Key"
    end

    local function closeUI()
        if closed then return end
        closed = true
        getgenv().UI_CLOSED = true

        pcall(function()
            TweenService:Create(Main, TweenInfo.new(0.16), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(Backdrop, TweenInfo.new(0.16), {
                BackgroundTransparency = 1
            }):Play()
        end)

        task.wait(0.17)
        safeDestroy(Gui)
    end

    Close.MouseButton1Click:Connect(function()
        if busy then return end
        getgenv().SCRIPT_KEY = nil
        closeUI()
    end)

    GetKey.MouseButton1Click:Connect(function()
        if busy then return end

        setStatus("Getting key link...", Color3.fromRGB(170, 150, 255))

        local ok, link = pcall(function()
            return Junkie.get_key_link()
        end)

        if ok and link then
            if type(setclipboard) == "function" then
                pcall(setclipboard, link)
                setStatus("Key link copied to clipboard.", Color3.fromRGB(105, 225, 175))
            else
                setStatus("Clipboard is unavailable in this executor.", Color3.fromRGB(240, 190, 95))
            end
        else
            setStatus("Failed to get key link.", Color3.fromRGB(245, 95, 105))
        end
    end)

    local function verifyKey()
        if busy then return end

        local key = tostring(KeyBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if key == "" then
            setStatus("Enter a key first.", Color3.fromRGB(245, 95, 105))
            return
        end

        setBusy(true)
        setStatus("Verifying key...", Color3.fromRGB(170, 150, 255))

        local ok, checkResult = pcall(function()
            return Junkie.check_key(key)
        end)

        if ok and type(checkResult) == "table" and checkResult.valid then
            verifiedKey = key

            -- SCRIPT_KEY is set ONLY after this service verifies the typed key.
            getgenv().SCRIPT_KEY = key

            setStatus("Key verified. Starting script...", Color3.fromRGB(105, 225, 175))
            Verify.Text = "Verified ✓"

            task.wait(0.75)
            closeUI()
            return
        end

        getgenv().SCRIPT_KEY = nil

        local message = "Invalid key."
        if ok and type(checkResult) == "table" then
            if checkResult.message == "SERVICE_MISMATCH" then
                message = "This key belongs to another script."
            elseif checkResult.message == "KEY_EXPIRED" then
                message = "This key has expired."
            elseif checkResult.message == "HWID_MISMATCH" then
                message = "Key is linked to another device."
            end
        end

        setStatus(message, Color3.fromRGB(245, 95, 105))
        setBusy(false)
    end

    Verify.MouseButton1Click:Connect(verifyKey)

    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verifyKey()
        end
    end)

    KeyBox.Focused:Connect(function()
        InputStroke.Color = Color3.fromRGB(122, 82, 255)
        InputStroke.Thickness = 1.5
    end)

    KeyBox.FocusLost:Connect(function()
        InputStroke.Color = Color3.fromRGB(65, 65, 76)
        InputStroke.Thickness = 1
    end)

    -- Dragging works with mouse and touch.
    do
        local dragging = false
        local dragStart
        local startPos
        local dragInput

        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                dragging = true
                dragStart = input.Position
                startPos = Main.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput and dragStart and startPos then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    while not closed and verifiedKey == nil do
        task.wait(0.05)
    end

    return verifiedKey
end)()

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Failed to load script, please try later again!";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("Key verification failed");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/d06f112a5c1137216759cc2879982d1bcd66d74a24b2b8fa515ff5694ff100bb?v=2",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h and(h=="LDR-DENIED" or h:match("^LDR%-DENIED:[A-Z_]+$"))then v("Key verification failed ("..h..")");return end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and string.sub(x.Body,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and string.sub(l,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end