--!nolint UnknownGlobal
--!nocheck

local Loader = { }
do
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ContentProvider = game:GetService("ContentProvider")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    local FromRGB = Color3.fromRGB
    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new
    local InstanceNew = Instance.new
    local MathClamp = math.clamp
    local MathFloor = math.floor
    local StringFormat = string.format
    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local Theme = {
        ["Background"] = FromRGB(20, 20, 25),
        ["Inline"] = FromRGB(26, 26, 32),
        ["Border"] = FromRGB(12, 12, 16),
        ["Outline"] = FromRGB(38, 38, 45),
        ["Accent"] = FromRGB(185, 208, 250),
        ["Text"] = FromRGB(200, 200, 208),
        ["WindowTitle"] = FromRGB(215, 215, 215),
        ["Text Border"] = FromRGB(20, 20, 25),
        ["ConsoleStroke"] = FromRGB(80, 80, 88)
    }

    local Folders = {
        Directory = "loader",
        Assets = "loader/Assets"
    }

    if not isfolder(Folders.Directory) then
        makefolder(Folders.Directory)
    end
    if not isfolder(Folders.Assets) then
        makefolder(Folders.Assets)
    end

    local CustomFont = nil
    do
        local FontName = "Windows-XP-Tahoma"
        local FontUrl = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"

        local FontAsset
        if not isfile(Folders.Assets .. "/" .. FontName .. ".ttf") then
            writefile(Folders.Assets .. "/" .. FontName .. ".ttf", game:HttpGet(FontUrl))
        end

        if not isfile(Folders.Assets .. "/" .. FontName .. ".json") then
            FontAsset = getcustomasset(Folders.Assets .. "/" .. FontName .. ".ttf")
            local FontData = {
                name = FontName,
                faces = { {
                    name = "Regular",
                    weight = 200,
                    style = "Regular",
                    assetId = FontAsset
                } }
            }
            writefile(Folders.Assets .. "/" .. FontName .. ".json", HttpService:JSONEncode(FontData))
        end

        local JsonAsset = getcustomasset(Folders.Assets .. "/" .. FontName .. ".json")
        pcall(function()
            CustomFont = Font.new(JsonAsset)
        end)
    end

    local function ApplyFont(Label)
        if CustomFont then
            Label.FontFace = CustomFont
        else
            Label.Font = Enum.Font.SourceSans
        end
    end

    local ScreenGui = InstanceNew("ScreenGui")
    ScreenGui.Name = "\0"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui

    local AnimatedGradients = { }
    local function ApplyAnimatedGradient(StrokeInstance)
        if not StrokeInstance then return end

        local StrokeGradient = InstanceNew("UIGradient")
        StrokeGradient.Name = "\0"
        StrokeGradient.Rotation = 0
        StrokeGradient.Color = RGBSequence{
            RGBSequenceKeypoint(0, Theme.Accent),
            RGBSequenceKeypoint(0.5, Theme.Accent),
            RGBSequenceKeypoint(1, Theme.Accent)
        }
        StrokeGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.1, 1),
            NumberSequenceKeypoint.new(0.2, 0),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.4, 1),
            NumberSequenceKeypoint.new(0.6, 1),
            NumberSequenceKeypoint.new(0.7, 0),
            NumberSequenceKeypoint.new(0.8, 0),
            NumberSequenceKeypoint.new(0.9, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        StrokeGradient.Parent = StrokeInstance

        local GradientData = {
            Gradient = StrokeGradient,
            Angle = 0
        }
        table.insert(AnimatedGradients, GradientData)
        return StrokeGradient
    end

    task.spawn(function()
        while true do
            local Dt = 0.033
            local Increment = (Dt / 3) * 360
            for _, GradData in AnimatedGradients do
                GradData.Angle = (GradData.Angle + Increment) % 360
                GradData.Gradient.Rotation = GradData.Angle
            end
            task.wait(Dt)
        end
    end)

    local WindowWidth = 420
    local WindowHeight = 280
    local ConsoleWidth = 200
    local ConsoleHeight = 280
    local Gap = 10

    local MainFrame = InstanceNew("Frame")
    MainFrame.Name = "\0"
    MainFrame.AnchorPoint = Vector2New(0.5, 0.5)
    MainFrame.Position = UDim2New(0.5, -(ConsoleWidth + Gap) / 2, 0.5, 0)
    MainFrame.Size = UDim2New(0, WindowWidth, 0, WindowHeight)
    MainFrame.BackgroundColor3 = FromRGB(15, 15, 20)
    MainFrame.BorderColor3 = Theme.Border
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    local AccentStroke = InstanceNew("UIStroke")
    AccentStroke.Name = "\0"
    AccentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AccentStroke.LineJoinMode = Enum.LineJoinMode.Miter
    AccentStroke.Color = Theme.Accent
    AccentStroke.Thickness = 1.5
    AccentStroke.Parent = MainFrame

    ApplyAnimatedGradient(AccentStroke)

    local TitleLabel = InstanceNew("TextLabel")
    TitleLabel.Name = "\0"
    TitleLabel.Parent = MainFrame
    ApplyFont(TitleLabel)
    TitleLabel.Text = "neuro.net"
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = Theme.WindowTitle
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2New(1, -12, 0, 18)
    TitleLabel.Position = UDim2New(0, 6, 0, 2)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.BorderSizePixel = 0
    TitleLabel.TextSize = 13
    TitleLabel.BackgroundColor3 = FromRGB(255, 255, 255)

    local TitleStroke = InstanceNew("UIStroke")
    TitleStroke.Name = "\0"
    TitleStroke.Parent = TitleLabel
    TitleStroke.Color = Theme["Text Border"]
    TitleStroke.LineJoinMode = Enum.LineJoinMode.Miter

    local InlineFrame = InstanceNew("Frame")
    InlineFrame.Name = "\0"
    InlineFrame.Parent = MainFrame
    InlineFrame.Position = UDim2New(0, 7, 0, 22)
    InlineFrame.Size = UDim2New(1, -14, 1, -29)
    InlineFrame.BackgroundColor3 = Theme.Background
    InlineFrame.BorderColor3 = Theme.Outline
    InlineFrame.BorderSizePixel = 2

    local InlineStroke = InstanceNew("UIStroke")
    InlineStroke.Name = "\0"
    InlineStroke.Parent = InlineFrame
    InlineStroke.LineJoinMode = Enum.LineJoinMode.Miter
    InlineStroke.Color = Theme.Outline
    InlineStroke.Thickness = 1
    InlineStroke.Transparency = 0.5

    local UpdateLogsFrame = InstanceNew("Frame")
    UpdateLogsFrame.Name = "\0"
    UpdateLogsFrame.Parent = InlineFrame
    UpdateLogsFrame.Position = UDim2New(0, 6, 0, 6)
    UpdateLogsFrame.Size = UDim2New(1, -12, 1, -52)
    UpdateLogsFrame.BackgroundColor3 = Theme.Inline
    UpdateLogsFrame.BorderColor3 = Theme.Outline
    UpdateLogsFrame.BorderSizePixel = 1
    UpdateLogsFrame.BackgroundTransparency = 0.3

    local UpdateLogsStroke = InstanceNew("UIStroke")
    UpdateLogsStroke.Name = "\0"
    UpdateLogsStroke.Parent = UpdateLogsFrame
    UpdateLogsStroke.Color = Theme.Outline
    UpdateLogsStroke.LineJoinMode = Enum.LineJoinMode.Miter
    UpdateLogsStroke.Transparency = 0.5

    local UpdateLogsList = InstanceNew("UIListLayout")
    UpdateLogsList.Parent = UpdateLogsFrame
    UpdateLogsList.SortOrder = Enum.SortOrder.LayoutOrder
    UpdateLogsList.Padding = UDimNew(0, 2)

    local UpdateLogsPadding = InstanceNew("UIPadding")
    UpdateLogsPadding.Parent = UpdateLogsFrame
    UpdateLogsPadding.PaddingTop = UDimNew(0, 4)
    UpdateLogsPadding.PaddingLeft = UDimNew(0, 6)
    UpdateLogsPadding.PaddingRight = UDimNew(0, 6)
    UpdateLogsPadding.PaddingBottom = UDimNew(0, 4)

    local UpdateLogOrder = 0
    local UpdateLogColors = {
        ["+"] = FromRGB(100, 220, 100),
        ["-"] = FromRGB(220, 80, 80),
        ["!"] = FromRGB(220, 200, 80)
    }

    local function AddUpdateLog(Text, Prefix)
        local LogFrame = InstanceNew("Frame")
        LogFrame.Name = "\0"
        LogFrame.Size = UDim2New(1, 0, 0, 14)
        LogFrame.BackgroundTransparency = 1
        LogFrame.BorderSizePixel = 0
        LogFrame.LayoutOrder = UpdateLogOrder
        UpdateLogOrder = UpdateLogOrder + 1
        LogFrame.Parent = UpdateLogsFrame

        local LogLabel = InstanceNew("TextLabel")
        LogLabel.Name = "\0"
        LogLabel.Parent = LogFrame
        ApplyFont(LogLabel)
        LogLabel.BackgroundTransparency = 1
        LogLabel.Size = UDim2New(1, 0, 1, 0)
        LogLabel.TextXAlignment = Enum.TextXAlignment.Left
        LogLabel.TextYAlignment = Enum.TextYAlignment.Center
        LogLabel.BorderSizePixel = 0
        LogLabel.TextSize = 11
        LogLabel.RichText = true
        LogLabel.BackgroundColor3 = FromRGB(255, 255, 255)

        local LogStroke = InstanceNew("UIStroke")
        LogStroke.Name = "\0"
        LogStroke.Parent = LogLabel
        LogStroke.Color = Theme["Text Border"]
        LogStroke.LineJoinMode = Enum.LineJoinMode.Miter

        if Prefix and UpdateLogColors[Prefix] then
            local ColorHex = StringFormat("#%02X%02X%02X",
                MathFloor(UpdateLogColors[Prefix].R * 255),
                MathFloor(UpdateLogColors[Prefix].G * 255),
                MathFloor(UpdateLogColors[Prefix].B * 255)
            )
            LogLabel.Text = StringFormat('<font color="%s">[%s]</font> %s', ColorHex, Prefix, Text)
            LogLabel.TextColor3 = Theme.Text
        else
            LogLabel.Text = Text
            LogLabel.TextColor3 = FromRGB(140, 140, 148)
            LogLabel.TextTransparency = 0.3
        end
    end

    local StepLabel = InstanceNew("TextLabel")
    StepLabel.Name = "\0"
    StepLabel.Parent = InlineFrame
    ApplyFont(StepLabel)
    StepLabel.Text = "Initializing..."
    StepLabel.TextColor3 = Theme.Text
    StepLabel.BackgroundTransparency = 1
    StepLabel.Size = UDim2New(1, -12, 0, 14)
    StepLabel.Position = UDim2New(0, 6, 1, -34)
    StepLabel.TextXAlignment = Enum.TextXAlignment.Left
    StepLabel.BorderSizePixel = 0
    StepLabel.TextSize = 11
    StepLabel.BackgroundColor3 = FromRGB(255, 255, 255)

    local StepStroke = InstanceNew("UIStroke")
    StepStroke.Name = "\0"
    StepStroke.Parent = StepLabel
    StepStroke.Color = Theme["Text Border"]
    StepStroke.LineJoinMode = Enum.LineJoinMode.Miter

    local BarBackground = InstanceNew("Frame")
    BarBackground.Name = "\0"
    BarBackground.Parent = InlineFrame
    BarBackground.Position = UDim2New(0, 6, 1, -18)
    BarBackground.Size = UDim2New(1, -12, 0, 14)
    BarBackground.BackgroundColor3 = Theme.Inline
    BarBackground.BorderColor3 = Theme.Outline
    BarBackground.BorderSizePixel = 1

    local BarFill = InstanceNew("Frame")
    BarFill.Name = "\0"
    BarFill.Parent = BarBackground
    BarFill.Size = UDim2New(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Theme.Accent
    BarFill.BorderSizePixel = 0

    local BarPercentLabel = InstanceNew("TextLabel")
    BarPercentLabel.Name = "\0"
    BarPercentLabel.Parent = BarBackground
    ApplyFont(BarPercentLabel)
    BarPercentLabel.Text = "0%"
    BarPercentLabel.TextColor3 = FromRGB(255, 255, 255)
    BarPercentLabel.BackgroundTransparency = 1
    BarPercentLabel.Size = UDim2New(1, 0, 1, 0)
    BarPercentLabel.TextXAlignment = Enum.TextXAlignment.Center
    BarPercentLabel.TextYAlignment = Enum.TextYAlignment.Center
    BarPercentLabel.BorderSizePixel = 0
    BarPercentLabel.TextSize = 10
    BarPercentLabel.ZIndex = 2
    BarPercentLabel.BackgroundColor3 = FromRGB(255, 255, 255)

    local BarPercentStroke = InstanceNew("UIStroke")
    BarPercentStroke.Name = "\0"
    BarPercentStroke.Parent = BarPercentLabel
    BarPercentStroke.Color = FromRGB(0, 0, 0)
    BarPercentStroke.LineJoinMode = Enum.LineJoinMode.Miter
    BarPercentStroke.Thickness = 1

    local ConsoleFrame = InstanceNew("Frame")
    ConsoleFrame.Name = "\0"
    ConsoleFrame.AnchorPoint = Vector2New(0.5, 0.5)
    ConsoleFrame.Position = UDim2New(0.5, (WindowWidth + Gap) / 2, 0.5, 0)
    ConsoleFrame.Size = UDim2New(0, ConsoleWidth, 0, ConsoleHeight)
    ConsoleFrame.BackgroundColor3 = FromRGB(15, 15, 20)
    ConsoleFrame.BorderColor3 = Theme.Border
    ConsoleFrame.BorderSizePixel = 2
    ConsoleFrame.Parent = ScreenGui

    local ConsoleStroke = InstanceNew("UIStroke")
    ConsoleStroke.Name = "\0"
    ConsoleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ConsoleStroke.LineJoinMode = Enum.LineJoinMode.Miter
    ConsoleStroke.Color = Theme.ConsoleStroke
    ConsoleStroke.Thickness = 1
    ConsoleStroke.Parent = ConsoleFrame

    local ConsoleTitle = InstanceNew("TextLabel")
    ConsoleTitle.Name = "\0"
    ConsoleTitle.Parent = ConsoleFrame
    ApplyFont(ConsoleTitle)
    ConsoleTitle.Text = "Console"
    ConsoleTitle.TextColor3 = Theme.WindowTitle
    ConsoleTitle.BackgroundTransparency = 1
    ConsoleTitle.Size = UDim2New(1, -12, 0, 18)
    ConsoleTitle.Position = UDim2New(0, 6, 0, 2)
    ConsoleTitle.TextXAlignment = Enum.TextXAlignment.Center
    ConsoleTitle.BorderSizePixel = 0
    ConsoleTitle.TextSize = 12
    ConsoleTitle.BackgroundColor3 = FromRGB(255, 255, 255)

    local ConsoleTitleStroke = InstanceNew("UIStroke")
    ConsoleTitleStroke.Name = "\0"
    ConsoleTitleStroke.Parent = ConsoleTitle
    ConsoleTitleStroke.Color = Theme["Text Border"]
    ConsoleTitleStroke.LineJoinMode = Enum.LineJoinMode.Miter

    local ConsoleInline = InstanceNew("Frame")
    ConsoleInline.Name = "\0"
    ConsoleInline.Parent = ConsoleFrame
    ConsoleInline.Position = UDim2New(0, 7, 0, 22)
    ConsoleInline.Size = UDim2New(1, -14, 1, -29)
    ConsoleInline.BackgroundColor3 = Theme.Background
    ConsoleInline.BorderColor3 = Theme.Outline
    ConsoleInline.BorderSizePixel = 2

    local ConsoleInlineStroke = InstanceNew("UIStroke")
    ConsoleInlineStroke.Name = "\0"
    ConsoleInlineStroke.Parent = ConsoleInline
    ConsoleInlineStroke.LineJoinMode = Enum.LineJoinMode.Miter
    ConsoleInlineStroke.Color = Theme.Outline
    ConsoleInlineStroke.Thickness = 1
    ConsoleInlineStroke.Transparency = 0.5

    local ConsoleContent = InstanceNew("ScrollingFrame")
    ConsoleContent.Name = "\0"
    ConsoleContent.Parent = ConsoleInline
    ConsoleContent.Position = UDim2New(0, 4, 0, 4)
    ConsoleContent.Size = UDim2New(1, -8, 1, -8)
    ConsoleContent.BackgroundTransparency = 1
    ConsoleContent.BorderSizePixel = 0
    ConsoleContent.ScrollBarThickness = 0
    ConsoleContent.ScrollBarImageTransparency = 1
    ConsoleContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ConsoleContent.CanvasSize = UDim2New(0, 0, 0, 0)
    ConsoleContent.AutomaticSize = Enum.AutomaticSize.None

    local ConsoleList = InstanceNew("UIListLayout")
    ConsoleList.Parent = ConsoleContent
    ConsoleList.SortOrder = Enum.SortOrder.LayoutOrder
    ConsoleList.Padding = UDimNew(0, 2)

    ConsoleList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local ContentSize = ConsoleList.AbsoluteContentSize.Y
        local ViewportSize = ConsoleContent.AbsoluteSize.Y
        ConsoleContent.CanvasPosition = Vector2New(0, math.max(0, ContentSize - ViewportSize))
    end)

    local ConsoleSizeConstraint = InstanceNew("UITextSizeConstraint")
    ConsoleSizeConstraint.MaxTextSize = 10
    ConsoleSizeConstraint.Parent = ConsoleContent

    local ConsolePadding = InstanceNew("UIPadding")
    ConsolePadding.Parent = ConsoleContent
    ConsolePadding.PaddingTop = UDimNew(0, 2)
    ConsolePadding.PaddingLeft = UDimNew(0, 2)
    ConsolePadding.PaddingRight = UDimNew(0, 2)
    ConsolePadding.PaddingBottom = UDimNew(0, 2)

    local ConsoleLogOrder = 0
    local ConsoleLogColors = {
        ["Success"] = FromRGB(100, 220, 100),
        ["Error"] = FromRGB(220, 80, 80),
        ["Warning"] = FromRGB(220, 200, 80)
    }

    local function AddConsoleLog(Text, LogType)
        local EntryFrame = InstanceNew("Frame")
        EntryFrame.Name = "\0"
        EntryFrame.Size = UDim2New(1, 0, 0, 14)
        EntryFrame.BackgroundTransparency = 1
        EntryFrame.BorderSizePixel = 0
        EntryFrame.LayoutOrder = ConsoleLogOrder
        ConsoleLogOrder = ConsoleLogOrder + 1
        EntryFrame.Parent = ConsoleContent

        local EntryLabel = InstanceNew("TextLabel")
        EntryLabel.Name = "\0"
        EntryLabel.Parent = EntryFrame
        ApplyFont(EntryLabel)
        EntryLabel.BackgroundTransparency = 1
        EntryLabel.Size = UDim2New(1, 0, 1, 0)
        EntryLabel.AutomaticSize = Enum.AutomaticSize.XY
        EntryLabel.TextXAlignment = Enum.TextXAlignment.Left
        EntryLabel.TextYAlignment = Enum.TextYAlignment.Center
        EntryLabel.TextWrapped = false
        EntryLabel.BorderSizePixel = 0
        EntryLabel.TextSize = 10
        EntryLabel.RichText = true
        EntryLabel.TextTransparency = 1
        EntryLabel.BackgroundColor3 = FromRGB(255, 255, 255)

        local EntryStroke = InstanceNew("UIStroke")
        EntryStroke.Name = "\0"
        EntryStroke.Parent = EntryLabel
        EntryStroke.Color = Theme["Text Border"]
        EntryStroke.LineJoinMode = Enum.LineJoinMode.Miter
        EntryStroke.Transparency = 1

        if LogType and ConsoleLogColors[LogType] then
            local ColorHex = StringFormat("#%02X%02X%02X",
                MathFloor(ConsoleLogColors[LogType].R * 255),
                MathFloor(ConsoleLogColors[LogType].G * 255),
                MathFloor(ConsoleLogColors[LogType].B * 255)
            )
            EntryLabel.Text = StringFormat('<font color="%s">[%s]</font> %s', ColorHex, LogType, Text)
            EntryLabel.TextColor3 = Theme.Text
        else
            EntryLabel.Text = Text
            EntryLabel.TextColor3 = Theme.Text
        end

        TweenService:Create(EntryLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
        TweenService:Create(EntryStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0
        }):Play()

        task.spawn(function()
            local ContentSize = ConsoleList.AbsoluteContentSize.Y
            local ViewportSize = ConsoleContent.AbsoluteSize.Y
            ConsoleContent.CanvasPosition = Vector2New(0, math.max(0, ContentSize - ViewportSize))
        end)
    end

    local function SetStep(Text)
        StepLabel.Text = Text
    end

    local CurrentPercent = 0
    local BarTween = nil
    local function SetProgress(Percent)
        Percent = MathClamp(Percent, 0, 1)
        if Percent < CurrentPercent then
            if BarTween then BarTween:Cancel() end
            BarFill.Size = UDim2New(Percent, 0, 1, 0)
            CurrentPercent = Percent
        else
            if BarTween then BarTween:Cancel() end
            BarTween = TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2New(Percent, 0, 1, 0)
            })
            BarTween:Play()
            CurrentPercent = Percent
        end
        BarPercentLabel.Text = StringFormat("%d%%", MathFloor(Percent * 100))
    end

    local BaseProgress = 0
    local StepRange = 1
    local function SetSubProgress(Percent)
        SetProgress(BaseProgress + (MathClamp(Percent, 0, 1) * StepRange))
    end

    local function DownloadAsset(FileName, Url)
        if isfile(FileName) then
            AddConsoleLog(StringFormat(" %s already exists", FileName), "Warning")
            return
        end
        local Dir = FileName:match("^(.*)/[^/]+$")
        if Dir and not isfolder(Dir) then
            makefolder(Dir)
        end
        SetStep(StringFormat("Downloading %s (%s)", FileName, FileName))
        local Success, Result = pcall(function()
            writefile(FileName, game:HttpGet(Url))
        end)
        if Success then
            AddConsoleLog(StringFormat("Downloaded %s", FileName), "Success")
        else
            AddConsoleLog(StringFormat(" Failed to download %s: %s", FileName, tostring(Result)), "Error")
        end
    end

    local function WaitForGame()
        SetStep("Waiting for game to load...")
        AddConsoleLog(" Waiting for game assets", "Warning")
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        task.spawn(function()
            ContentProvider:PreloadAsync({ workspace, game:GetService("Players") })
        end)
        task.wait(3)
        AddConsoleLog(" Game loaded successfully", "Success")
    end

    local function ExecuteScript(Path, Delay)
        if Delay and type(Delay) == "number" and Delay > 0 then
            SetStep(StringFormat("Waiting %ds before loading %s", Delay, Path))
            task.wait(Delay)
        end
        SetStep(StringFormat("Loading %s", Path))
        if isfile(Path) then
            local Success, Result = pcall(function()
                loadfile(Path)()
            end)
            if Success then
                AddConsoleLog(StringFormat(" Loaded %s", Path), "Success")
            else
                AddConsoleLog(StringFormat(" Failed to load %s: %s", Path, tostring(Result)), "Error")
            end
        else
            AddConsoleLog(StringFormat(" File not found: %s", Path), "Error")
        end
    end

    local function LoadstringScript(Link)
        SetStep(StringFormat("Loading from %s", Link))
        local Success, Result = pcall(function()
            local Fn = loadstring(game:HttpGet(Link))
            if Fn then
                task.spawn(Fn)
            end
        end)
        if Success then
            AddConsoleLog(StringFormat(" Loaded %s", Link), "Success")
        else
            AddConsoleLog(StringFormat(" Failed to load %s: %s", Link, tostring(Result)), "Error")
        end
    end

    local function FadeOut()
        local AllObjects = ScreenGui:GetDescendants()
        local TweenInfos = { }
        for _, Obj in AllObjects do
            if Obj:IsA("GuiObject") then
                if Obj.BackgroundTransparency < 1 then
                    TweenService:Create(Obj, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                end
                if Obj:IsA("TextLabel") or Obj:IsA("TextButton") or Obj:IsA("TextBox") then
                    TweenService:Create(Obj, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1
                    }):Play()
                end
                if Obj:FindFirstChildWhichIsA("UIStroke") then
                    TweenService:Create(Obj:FindFirstChildWhichIsA("UIStroke"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1
                    }):Play()
                end
            end
        end
        task.wait(0.6)
        ScreenGui:Destroy()
    end

    function Loader:SetTitle(Text)
        TitleLabel.Text = Text
    end

    local AccentHex = StringFormat("#%02X%02X%02X",
        MathFloor(Theme.Accent.R * 255),
        MathFloor(Theme.Accent.G * 255),
        MathFloor(Theme.Accent.B * 255)
    )
    TitleLabel.Text = StringFormat('neuro<font color="%s">.net</font>', AccentHex)

    function Loader:SetUpdateLogs(Logs)
        for _, Log in Logs do
            AddUpdateLog(Log.Text or "", Log.Prefix)
        end
    end

    function Loader:AddConsoleLog(Text, LogType)
        AddConsoleLog(Text, LogType)
    end

    function Loader:SetStep(Text)
        SetStep(Text)
    end

    function Loader:SetProgress(Percent)
        SetProgress(Percent)
    end

    function Loader:DownloadAssets(Assets)
        local Total = #Assets
        for Index, Asset in Assets do
            DownloadAsset(Asset.Name, Asset.Url)
            SetSubProgress(Index / Total)
        end
    end

    function Loader:WaitForGame()
        WaitForGame()
    end

    function Loader:Execute(Path, Delay)
        ExecuteScript(Path, Delay)
    end

    function Loader:Loadstring(Link)
        LoadstringScript(Link)
    end

    function Loader:Run(Steps)
        local TotalWeight = 0
        for _, Step in Steps do
            TotalWeight = TotalWeight + (Step.Weight or 1)
        end
        local Accumulated = 0
        for Index, Step in Steps do
            local StepWeight = Step.Weight or 1
            BaseProgress = Accumulated / TotalWeight
            StepRange = StepWeight / TotalWeight
            SetProgress(BaseProgress)
            if Step.Type == "DownloadAssets" then
                self:DownloadAssets(Step.Assets or { })
            elseif Step.Type == "WaitForGame" then
                self:WaitForGame()
            elseif Step.Type == "Execute" then
                self:Execute(Step.Path, Step.Delay)
            elseif Step.Type == "Loadstring" then
                self:Loadstring(Step.Link)
            elseif Step.Type == "ConsoleLog" then
                AddConsoleLog(Step.Text or "", Step.LogType)
            elseif Step.Type == "Custom" and Step.Function then
                Step.Function(self)
            end
            Accumulated = Accumulated + StepWeight
            SetProgress(Accumulated / TotalWeight)
            task.wait(0.1)
        end
        SetProgress(1)
        SetStep("Loaded!")
        AddConsoleLog("Successfully loaded", "Success")
        task.wait(1.5)
        FadeOut()
    end

    function Loader:Destroy()
        FadeOut()
    end
end

return Loader
