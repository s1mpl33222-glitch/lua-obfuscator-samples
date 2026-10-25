--[[
    Made by samet
    Example is at the bottom.

    Date:
    7/30/2026 11:53 PM

    If you find any bugs or anything that needs to be changed, please let me know in the ticket or dms
    ^^^ if you find anything that I forgot to do aswell.
]]

if getgenv().Library then
    if getgenv().Library.Exit then
        getgenv().Library:Exit()
    elseif getgenv().Library.Unload then
        getgenv().Library:Unload()
    end
end

cloneref = cloneref or function(Object) return Object end 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())

local Library = { 
    Flags = { },

    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "vaping it",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 14,

    Animation = {
        Time = 0.35,
        Style = "Quart",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 5,
        ["KeybindWindow"] = 5,
        ["ColorpickerWindow"] = 6
    },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },
    OpenFrameTriggers = { },
    OpenFrameInteracting = false,

    Notifications = { },

    Holder = nil,
    UnusedHolder = nil,

    Theme = nil,

    Font = nil,
} do 
    Library.__index = Library

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    local function SafeLibraryMakeFolder(Path)
        if isfolder and isfolder(Path) then
            return true
        end

        return pcall(function()
            makefolder(Path)
        end)
    end

    local function SafeLibraryWriteFile(Path, Content)
        return pcall(function()
            writefile(Path, Content)
        end)
    end

    SafeLibraryMakeFolder(Library.Directory)

    for _, Folder in Library.Folders do
        SafeLibraryMakeFolder(Library.Directory .. Folder)
    end

    if not isfile(Library.Directory .. "/autoload.json") then
        SafeLibraryWriteFile(Library.Directory .. "/autoload.json", "")
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(20, 22, 24),
            ["Inline"] = Color3.fromRGB(24, 27, 29),
            ["Tab"] = Color3.fromRGB(28, 32, 34),
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(179, 165, 255),
            ["Outline"] = Color3.fromRGB(29, 31, 34),
            ["Hovered Element"] = Color3.fromRGB(29, 31, 34),
        },
        ["Sky"] = {
            ["Background"] = Color3.fromRGB(20, 23, 24),
            ["Inline"] = Color3.fromRGB(31, 35, 36),
            ["Tab"] = Color3.fromRGB(36, 41, 43),
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(134, 134, 134),
            ["Accent"] = Color3.fromRGB(147, 238, 255),
            ["Outline"] = Color3.fromRGB(41, 45, 46),
            ["Hovered Element"] = Color3.fromRGB(68, 73, 73),
        },
        ["Magma"] = {
            ["Background"] = Color3.fromRGB(34, 28, 28),
            ["Inline"] = Color3.fromRGB(31, 23, 23),
            ["Tab"] = Color3.fromRGB(41, 33, 33),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(134, 121, 121),
            ["Accent"] = Color3.fromRGB(233, 43, 26),
            ["Outline"] = Color3.fromRGB(41, 29, 29),
            ["Hovered Element"] = Color3.fromRGB(54, 42, 42),
        },
        ["Sand"] = {
            ["Background"] = Color3.fromRGB(45, 46, 37),
            ["Inline"] = Color3.fromRGB(63, 65, 55),
            ["Tab"] = Color3.fromRGB(54, 56, 44),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(136, 135, 132),
            ["Accent"] = Color3.fromRGB(255, 229, 147),
            ["Outline"] = Color3.fromRGB(88, 83, 68),
            ["Hovered Element"] = Color3.fromRGB(71, 71, 59),
        },
        ["Navy"] = {
            ["Background"] = Color3.fromRGB(28, 30, 36),
            ["Inline"] = Color3.fromRGB(32, 34, 41),
            ["Tab"] = Color3.fromRGB(40, 43, 49),
            ["Text"] = Color3.fromRGB(165, 164, 187),
            ["Inactive Text"] = Color3.fromRGB(101, 105, 126),
            ["Accent"] = Color3.fromRGB(0, 102, 255),
            ["Outline"] = Color3.fromRGB(37, 42, 54),
            ["Hovered Element"] = Color3.fromRGB(40, 43, 49),
        },
        ["Emerald"] = {
            ["Background"] = Color3.fromRGB(18, 24, 21),
            ["Inline"] = Color3.fromRGB(24, 32, 28),
            ["Tab"] = Color3.fromRGB(30, 40, 34),
            ["Text"] = Color3.fromRGB(230, 245, 235),
            ["Inactive Text"] = Color3.fromRGB(110, 135, 120),
            ["Accent"] = Color3.fromRGB(52, 211, 153),
            ["Outline"] = Color3.fromRGB(36, 48, 41),
            ["Hovered Element"] = Color3.fromRGB(42, 58, 48),
        },
        ["Rose"] = {
            ["Background"] = Color3.fromRGB(28, 20, 24),
            ["Inline"] = Color3.fromRGB(36, 26, 31),
            ["Tab"] = Color3.fromRGB(44, 32, 38),
            ["Text"] = Color3.fromRGB(255, 240, 245),
            ["Inactive Text"] = Color3.fromRGB(150, 120, 130),
            ["Accent"] = Color3.fromRGB(244, 114, 182),
            ["Outline"] = Color3.fromRGB(52, 36, 44),
            ["Hovered Element"] = Color3.fromRGB(58, 40, 48),
        },
        ["Midnight"] = {
            ["Background"] = Color3.fromRGB(12, 12, 18),
            ["Inline"] = Color3.fromRGB(18, 18, 28),
            ["Tab"] = Color3.fromRGB(24, 24, 38),
            ["Text"] = Color3.fromRGB(230, 230, 245),
            ["Inactive Text"] = Color3.fromRGB(110, 110, 140),
            ["Accent"] = Color3.fromRGB(129, 140, 248),
            ["Outline"] = Color3.fromRGB(32, 32, 48),
            ["Hovered Element"] = Color3.fromRGB(40, 40, 60),
        },
        ["Coral"] = {
            ["Background"] = Color3.fromRGB(28, 22, 20),
            ["Inline"] = Color3.fromRGB(36, 28, 25),
            ["Tab"] = Color3.fromRGB(44, 34, 30),
            ["Text"] = Color3.fromRGB(255, 245, 240),
            ["Inactive Text"] = Color3.fromRGB(150, 125, 115),
            ["Accent"] = Color3.fromRGB(255, 112, 67),
            ["Outline"] = Color3.fromRGB(52, 40, 35),
            ["Hovered Element"] = Color3.fromRGB(58, 44, 38),
        },
        ["Mono"] = {
            ["Background"] = Color3.fromRGB(14, 14, 14),
            ["Inline"] = Color3.fromRGB(22, 22, 22),
            ["Tab"] = Color3.fromRGB(30, 30, 30),
            ["Text"] = Color3.fromRGB(245, 245, 245),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(220, 220, 220),
            ["Outline"] = Color3.fromRGB(40, 40, 40),
            ["Hovered Element"] = Color3.fromRGB(48, 48, 48),
        },
    }

    local ThemeOrder = { "Preset", "Sky", "Magma", "Sand", "Navy", "Emerald", "Rose", "Midnight", "Coral", "Mono" }

    Library.Themes = Themes
    Library.ThemeOrder = ThemeOrder
    Library.Theme = table.clone(Themes["Preset"])

    Library.ApplyTheme = function(Self, Name)
        local ThemeData = Themes[Name]

        if not ThemeData then
            return false
        end

        for Index, Color in ThemeData do
            Library:ChangeTheme(Index, Color)

            local SetFunction = SetFlags[Index .. "Theming"]
            if SetFunction then
                SetFunction(Color, 0)
            end
        end

        return true
    end

    Library.AnimatedColorpickers = { }
    Library.RainbowTime = 0

    Library.LerpColor = function(Self, A, B, T)
        return A:Lerp(B, math.clamp(T, 0, 1))
    end

    Library.EnsureColorpickerAnimations = function(Self)
        if Library.ColorpickerAnimationConnection then
            return
        end

        Library.ColorpickerAnimationConnection = Library:Connect(RunService.RenderStepped, function(DeltaTime)
            local RainbowSpeedSum = 0
            local RainbowCount = 0

            for Colorpicker in Library.AnimatedColorpickers do
                if Colorpicker.AnimationEnabled and Colorpicker.AnimationMode == "Rainbow" then
                    local Speed = Colorpicker.AnimationSpeed
                    RainbowSpeedSum += Speed * Speed
                    RainbowCount += 1
                end
            end

            if RainbowCount > 0 then
                Library.RainbowTime += DeltaTime * (RainbowSpeedSum / RainbowCount)
            end

            for Colorpicker in Library.AnimatedColorpickers do
                if not Colorpicker.AnimationEnabled then
                    continue
                end

                local Mode = Colorpicker.AnimationMode
                if not Mode then
                    continue
                end

                local Speed = Colorpicker.AnimationSpeed
                Speed = Speed * Speed

                local Color
                local Alpha = Colorpicker.Alpha

                if Mode == "Rainbow" then
                    Color = Color3.fromHSV((Library.RainbowTime * 0.2) % 1, Colorpicker.Saturation, Colorpicker.Value)
                else
                    Colorpicker.AnimationTime += DeltaTime * Speed

                    local Time = Colorpicker.AnimationTime
                    local Primary = Colorpicker.KeyframeOne
                    local Secondary = Colorpicker.KeyframeTwo
                    if not Primary or not Secondary then
                        continue
                    end

                    local T = 0

                    if Mode == "Linear" then
                        T = Time % 1
                    elseif Mode == "Strobe" then
                        T = math.floor(Time * 4) % 2
                    elseif Mode == "Ping Pong" then
                        T = math.abs((Time % 2) - 1)
                    elseif Mode == "Pulse" then
                        T = math.abs(math.sin(Time * 2))
                    elseif Mode == "Oscillation" then
                        T = (math.sin(Time) + 1) * 0.5
                    end

                    Color = Library:LerpColor(Primary.Color, Secondary.Color, T)
                    Alpha = Primary.Alpha + (Secondary.Alpha - Primary.Alpha) * T
                end

                Colorpicker:Set(Color, Alpha, true)
            end
        end)
    end

    Library.SetColorpickerAnimating = function(Self, Colorpicker, Enabled)
        if Enabled then
            Library.AnimatedColorpickers[Colorpicker] = true
            Library:EnsureColorpickerAnimations()
        else
            Library.AnimatedColorpickers[Colorpicker] = nil
        end
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            local Success, Result = pcall(function()
                if not isfile(Data.Id) then
                    writefile(Data.Id, game:HttpGet(Data.Url))
                end

                local FontData = {
                    name = Name,
                    faces = {
                        {
                            name = Name,
                            weight = Weight,
                            style = Style,
                            assetId = getcustomasset(Data.Id)
                        }
                    }
                }

                local AssetsFolder = Library.Directory .. Library.Folders.Assets
                if SafeLibraryMakeFolder then
                    SafeLibraryMakeFolder(AssetsFolder)
                end

                writefile(`{AssetsFolder}/{Name}.font`, HttpService:JSONEncode(FontData))
                return Font.new(getcustomasset(`{AssetsFolder}/{Name}.font`))
            end)

            return Success and Result or Font.fromEnum(Enum.Font.Code)
        end
        Library.Font = CustomFont:New("Figtree", 400, "Regular", {
            Id = "Figtree",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Figtree-SemiBold.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do 
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do 
            coroutine.close(Thread)
        end

        if Self.Holder then 
            Self.Holder.Instance:Destroy()
        end

        if Self.NotifHolder then 
            Self.NotifHolder.Instance:Destroy()
        end

        if Self.UnusedHolder then 
            Self.UnusedHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do 
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then 
                if IsMobile and Signal == "MouseButton1Down" then 
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)

                    return
                end
                
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return 
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return 
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then 
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then 
            Self.Instance.Visible = true 
        end

        local NewTween 

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do 
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then 
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if not NewTween then
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Self.Instance.Visible = Visibility
            return
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self, Handle)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local HandleInstance = (Handle and Handle.Instance) or Gui
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Library:Connect(HandleInstance.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.ConvertAnchor = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local AbsPos = Gui.AbsolutePosition

        Gui.AnchorPoint = Vector2.new(0, 0)
        task.wait()
        Gui.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then 
            return
        end

        local Gui = Self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then 
            return 
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X 
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value 
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.IsMouseOverItems = function(Self, Items)
        for _, Item in Items do
            if Item and Item:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.RegisterOpenFrameTrigger = function(Self, Trigger)
        Library.OpenFrameTriggers[Trigger] = true
    end

    Library.IsMouseOverAnyOpenFrameTrigger = function(Self)
        for Trigger in Library.OpenFrameTriggers do
            if Trigger:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.IsMouseOverOpenFrameData = function(Self, Data)
        if Self:IsMouseOverItems(Data.HoverItems) then
            return true
        end

        if Data.GetHoverItems then
            return Self:IsMouseOverItems(Data.GetHoverItems())
        end

        return false
    end

    Library.ShouldKeepOpenFrame = function(Self, Frame)
        local Data = Library.OpenFrames[Frame]

        if not Data then
            return false
        end

        if Self:IsMouseOverOpenFrameData(Data) then
            return true
        end

        for ChildFrame, ChildData in Library.OpenFrames do
            if ChildData.Owner == Frame and ChildFrame.IsOpen and Self:ShouldKeepOpenFrame(ChildFrame) then
                return true
            end
        end

        return false
    end

    Library.RegisterOpenFrame = function(Self, Frame, Data)
        local Owner = Data.Owner

        if Owner == nil and Data.AnchorInstance then
            Owner = Self:FindOpenFrameOwner(Data.AnchorInstance)
        end

        Data.Owner = Owner

        if Owner then
            Self:CloseOpenFramesExcept(Frame, Owner)
        else
            Self:CloseOpenFramesExcept(Frame)
        end

        Library.OpenFrames[Frame] = Data
        Library:EnsureOpenFramesConnection()
    end

    Library.UnregisterOpenFrame = function(Self, Frame)
        Library.OpenFrames[Frame] = nil
    end

    Library.FindOpenFrameOwner = function(Self, Instance)
        if not Instance then
            return nil
        end

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and Data.PopupInstance then
                if Instance:IsDescendantOf(Data.PopupInstance) or Instance == Data.PopupInstance then
                    return Frame
                end
            end
        end

        return nil
    end

    Library.CloseOpenFramesExcept = function(Self, KeepFrame, KeepOwner)
        for Frame, Data in Library.OpenFrames do
            if Frame == KeepFrame or Frame == KeepOwner then
                continue
            end

            if Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.CloseOpenFrameChildren = function(Self, Parent)
        for Frame, Data in Library.OpenFrames do
            if Data.Owner == Parent and Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.SetOpenFrameInteracting = function(Self, Bool)
        Library.OpenFrameInteracting = Bool
    end

    Library.ProcessOpenFrames = function(Self)
        if Library.OpenFrameInteracting then
            return
        end

        if Self:IsMouseOverAnyOpenFrameTrigger() then
            return
        end

        local ToClose = { }

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and not Frame.Picking and not Self:ShouldKeepOpenFrame(Frame) then
                table.insert(ToClose, Frame)
            end
        end

        for _, Frame in ToClose do
            Frame:SetOpen(false)
        end
    end

    Library.EnsureOpenFramesConnection = function(Self)
        if Library.OpenFramesInputConnection then
            return
        end

        Library.OpenFramesInputConnection = Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            task.defer(function()
                Library:ProcessOpenFrames()
            end)
        end)
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1
    
        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end
    
        return Scale
    end
    
    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
    
        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale
    
        return UDim2.fromOffset(X, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance 

        if not Object then 
            return 
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
        end)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        DisplayOrder = 999999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    Library:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,
                Mini = Data.Mini == true,

                AnimationEnabled = false,
                AnimationMode = "Linear",
                AnimationSpeed = 1,
                AnimationTime = 0,

                Pages = { },
                Current = nil,

                Items = { }
            }

            local Items = { } do
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })
                
                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 996, 0, 92),
                    Size = UDim2.new(0, 250, 0, 250),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingRight = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 56),
                    Size = UDim2.new(1, 0, 1, -56),
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance
                })                

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})                

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
        
                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})

                if Items["Palette"] then
                    Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})
                end

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }
    
                if not IsFromAlpha and Items["Alpha"] then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.IsSettings or Data.Mini or (Data.Section and Data.Section.IsSettings)

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    Library:RegisterOpenFrame(Colorpicker, {
                        HoverItems = { Items["ColorpickerWindow"], Items["ColorpickerButton"] },
                        AnchorInstance = ColorpickerButton,
                        PopupInstance = ColorpickerWindow,
                    })
                else
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Colorpicker)
                    Library:UnregisterOpenFrame(Colorpicker)
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items["ColorpickerWindow"]:VisibleCheck()
    
            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.935)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.92)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.915)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
    
                Colorpicker.Alpha = ValueX
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.915)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha, FromAnimation)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.935)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.92)
    
                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.915)
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.915)

                local DraggerInfo = FromAnimation and TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out) or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                if FromAnimation then
                    Colorpicker.Color = Color
                    Colorpicker.HexValue = Colorpicker.Color:ToHex()
                    Items["ColorpickerButton"].Instance.BackgroundColor3 = Colorpicker.Color

                    if Items["Palette"] then
                        Items["Palette"].Instance.BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1)
                    end

                    if Items["Alpha"] then
                        Items["Alpha"].Instance.BackgroundColor3 = Colorpicker.Color
                    end

                    if Items["PaletteDragger"] then
                        Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo)
                    end

                    if Items["HueDragger"] then
                        Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo)
                    end

                    if Items["AlphaDragger"] then
                        Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo)
                    end

                    Flags[Colorpicker.Flag] = {
                        Alpha = Colorpicker.Alpha,
                        Color = Colorpicker.Color,
                        HexValue = Colorpicker.HexValue,
                        Transparency = 1 - Colorpicker.Alpha
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                    end

                    return
                end
    
                if Items["PaletteDragger"] then
                    Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo)
                end

                if Items["HueDragger"] then
                    Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo)
                end

                if Items["AlphaDragger"] then
                    Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo)
                end

                Colorpicker:Update()
            end

            function Colorpicker:Page(Params)
                Params = Params or { }

                local Page = {
                    Name = Params.Name or Params.name or "Page",
                    Icon = Params.Icon or Params.icon or "",

                    Colorpicker = Colorpicker,
                    Items = { },
                    Active = false,
                    Debounce = false
                }

                local PageItems = { } do
                    PageItems["Inactive"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Colorpicker.Items["Pages"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 35, 0, 35),
                        BorderSizePixel = 0,
                        ClipsDescendants = true,
                        LayoutOrder = #Colorpicker.Pages + 1,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }):AddToTheme({BackgroundColor3 = 'Tab'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance
                    })
                    
                    PageItems["Icon"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance,
                        ImageColor3 = Library.Theme["Inactive Text"],
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = Page.Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0.5, 1),
                        Size = UDim2.new(0, 20, 0, 20),
                        BorderSizePixel = 0
                    }):AddToTheme({ImageColor3 = 'Inactive Text'})
                    
PageItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize + 2, 
                        Parent = PageItems["Inactive"].Instance,
                        Visible = true,
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5),
                        TextColor3 = Library.Theme["Text"],
                        Text = Page.Name,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 30, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})
                    
                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance,
                        PaddingRight = UDim.new(0, 8),
                        PaddingLeft = UDim.new(0, 8)
                    })                

                    PageItems["Page"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Library.UnusedHolder.Instance,
                        BackgroundTransparency = 1,
                        Visible = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    })

                    Page.Items = PageItems
                end

local GetSize = function()
    PageItems["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
    PageItems["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

    local TextWidth = PageItems["Text"].Instance.TextBounds.X
    if TextWidth <= 0 then
        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.55)
    end

    return Vector2.new(math.max(35, math.ceil(65 + TextWidth)), 35)
end

                PageItems["Inactive"]:OnHover(function()
                    if Page.Active then return end 

                    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                    PageItems["Inactive"]:Tween({BackgroundTransparency = 0})
                end, function()
                    if Page.Active then return end 

                    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                    PageItems["Inactive"]:Tween({BackgroundTransparency = 1})
                end)

                local Size = GetSize()
                local X = Size.X

function Page:Turn()
    local Old = Colorpicker.Current 

    if Old == Page then 
        return 
    end

    if Page.Debounce then 
        return
    end

    if Old and Old.Debounce then 
        return 
    end

    Page.Debounce = true 
    
    if Old then 
        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

        Old.Items["Inactive"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)})
        Old.Items["Text"]:Tween({TextTransparency = 1})

        Old.Items["Page"].Instance.Visible = false
        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
        Old.Active = false
        Old.Debounce = false
    end

    PageItems["Page"].Instance.Parent = Colorpicker.Items["Content"].Instance
    PageItems["Page"].Instance.Visible = true

    local PageZIndex = Colorpicker.IsOpen and (IsSettings and Library.ZIndexOrder.ColorpickerWindow + 4 or Library.ZIndexOrder.ColorpickerWindow) or 1
    local PageDescendants = PageItems["Page"].Instance:GetDescendants()
    table.insert(PageDescendants, PageItems["Page"].Instance)

    for _, Value in PageDescendants do
        if Value.ClassName:find("UI") then
            continue
        end

        Value.ZIndex = PageZIndex
    end

    PageItems["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

    PageItems["Inactive"].Instance.BackgroundTransparency = 0
    PageItems["Text"].Instance.TextTransparency = 0
    
    local Size = GetSize()
    
    PageItems["Inactive"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, Size.X, 0, 35)})
    PageItems["Text"]:Tween({TextTransparency = 0})

    Colorpicker.Current = Page
    Page.Active = true
    Page.Debounce = false
end

                PageItems["Inactive"]:Connect("MouseButton1Down", function()
                    Page:Turn()
                end)

                table.insert(Colorpicker.Pages, Page)
                return Page
            end

            do -- Pages
                local ColorTab
                local AnimationsTab

                if Colorpicker.Mini then
                    Items["Top"].Instance.Visible = false
                    Items["Content"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    Items["Content"].Instance.Size = UDim2.new(1, 0, 1, 0)

                    Items["Color"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Content"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    })
                else
                    ColorTab = Colorpicker:Page({Name = "Color", Icon = "rbxassetid://78658715450812"})
                    AnimationsTab = Colorpicker:Page({Name = "Animations", Icon = "rbxassetid://102653368798088"})
                    Items["Color"] = ColorTab.Items.Page
                end

                do -- Color tab
                    Items["Palette"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        Position = UDim2.new(0, 10, 0, 10),
                        Size = UDim2.new(1, -45, 1, -45),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["Saturation"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = Items["Saturation"].Instance,
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Saturation"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["Value"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = Items["Value"].Instance,
                        Rotation = 90,
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Value"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["PaletteDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["PaletteDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["PaletteDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                    
                    Items["Hue"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, -10, 0, 10),
                        Size = UDim2.new(0, 15, 1, -20),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Hue"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = Items["Hue"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }
                    })
                    
                    Items["HueDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Hue"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 15, 0, 15),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["HueDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["HueDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                    
                    Items["Alpha"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 10, 1, -10),
                        Size = UDim2.new(1, -45, 0, 15),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Alpha"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["Checkers"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["Alpha"].Instance,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.new(0, 6, 0, 6),
                        Image = "http://www.roblox.com/asset/?id=18274452449",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        ZIndex = 2,
                        ImageColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = Items["Checkers"].Instance,
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.37, 0.5),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Checkers"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["AlphaDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Alpha"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 15, 0, 15),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["AlphaDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["AlphaDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                end

                if ColorTab then
                    ColorTab:Turn()
                end

                if not Colorpicker.Mini then
                    do -- Animations tab
                        Items["Animations"] = AnimationsTab.Items.Page
                        
                        Library:Create("UIPadding", {
                            Name = "\0",
                            Parent = Items["Animations"].Instance,
                            PaddingTop = UDim.new(0, 10),
                            PaddingBottom = UDim.new(0, 10),
                            PaddingRight = UDim.new(0, 10),
                            PaddingLeft = UDim.new(0, 10)
                        })
                        
                        Library:Create("UIListLayout", {
                            Name = "\0",
                            Parent = Items["Animations"].Instance,
                            Padding = UDim.new(0, 8),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })

                        local KeyframeOneLabel
                        local KeyframeTwoLabel

                        local SyncAnimationControls = function(Mode)
                            local IsRainbow = Mode == "Rainbow"

                            if KeyframeOneLabel then
                                KeyframeOneLabel:SetVisibility(not IsRainbow)
                            end

                            if KeyframeTwoLabel then
                                KeyframeTwoLabel:SetVisibility(not IsRainbow)
                            end
                        end

                        local UpdateAnimating = function()
                            Library:SetColorpickerAnimating(Colorpicker, Colorpicker.AnimationEnabled)
                        end

                        Library:Toggle({
                            Name = "Enabled",
                            Flag = Colorpicker.Flag .. "_Enabled",
                            Default = false,
                            Parent = Items["Animations"],
                            Callback = function(Value)
                                Colorpicker.AnimationEnabled = Value
                                UpdateAnimating()
                            end
                        })

                        Library:Dropdown({
                            Name = "Animations",
                            Flag = Colorpicker.Flag .. "_Animation",
                            Items = {"Linear", "Oscillation", "Pulse", "Strobe", "Ping Pong", "Rainbow"},
                            Default = "Linear",
                            Parent = Items["Animations"],
                            Callback = function(Value)
                                Colorpicker.AnimationMode = Value
                                SyncAnimationControls(Value)
                                UpdateAnimating()
                            end
                        })

                        Library:Slider({
                            Name = "Speed",
                            Flag = Colorpicker.Flag .. "_Speed",
                            Min = 0,
                            Max = 3,
                            Default = 1,
                            Decimals = 0.01,
                            Suffix = "x",
                            Parent = Items["Animations"],
                            Callback = function(Value)
                                Colorpicker.AnimationSpeed = Value
                            end
                        })

                        KeyframeOneLabel = Library:Label({Name = "Keyframe 1", Parent = Items["Animations"]})
                        Colorpicker.KeyframeOne = Library:CreateColorpicker({
                            Parent = KeyframeOneLabel.Items.SubElements,
                            Flag = Colorpicker.Flag .. "_Keyframe1",
                            Default = Color3.fromRGB(255, 0, 0),
                            Mini = true,
                            IsSettings = true,
                        })

                        KeyframeTwoLabel = Library:Label({Name = "Keyframe 2", Parent = Items["Animations"]})
                        Colorpicker.KeyframeTwo = Library:CreateColorpicker({
                            Parent = KeyframeTwoLabel.Items.SubElements,
                            Flag = Colorpicker.Flag .. "_Keyframe2",
                            Default = Color3.fromRGB(255, 255, 255),
                            Mini = true,
                            IsSettings = true,
                        })

                        Colorpicker.AnimationEnabled = Flags[Colorpicker.Flag .. "_Enabled"] or false
                        Colorpicker.AnimationMode = Flags[Colorpicker.Flag .. "_Animation"] or "Linear"
                        Colorpicker.AnimationSpeed = Flags[Colorpicker.Flag .. "_Speed"] or 1

                        SyncAnimationControls(Colorpicker.AnimationMode)
                        UpdateAnimating()
                    end
                end
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Library:RegisterOpenFrameTrigger(Items["ColorpickerButton"])
    
            if Items["Palette"] then
                Items["Palette"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Library:SetOpenFrameInteracting(true)
                        SlidingPalette = true 
    
                        Colorpicker:SlidePalette(Input)
    
                        if PaletteChanged then
                            return
                        end
    
                        PaletteChanged = Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                SlidingPalette = false
                                Library:SetOpenFrameInteracting(false)
    
                                PaletteChanged:Disconnect()
                                PaletteChanged = nil
                            end
                        end)
                    end
                end)
            end
    
            if Items["Hue"] then
                Items["Hue"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Library:SetOpenFrameInteracting(true)
                        SlidingHue = true 
    
                        Colorpicker:SlideHue(Input)
    
                        if HueChanged then
                            return
                        end
    
                        HueChanged = Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                SlidingHue = false
                                Library:SetOpenFrameInteracting(false)
    
                                HueChanged:Disconnect()
                                HueChanged = nil
                            end
                        end)
                    end
                end)
            end
    
            if Items["Alpha"] then
                Items["Alpha"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Library:SetOpenFrameInteracting(true)
                        SlidingAlpha = true 
    
                        Colorpicker:SlideAlpha(Input)
    
                        if AlphaChanged then
                            return
                        end
    
                        AlphaChanged = Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                SlidingAlpha = false
                                Library:SetOpenFrameInteracting(false)
    
                                AlphaChanged:Disconnect()
                                AlphaChanged = nil
                            end
                        end)
                    end
                end)
            end

            if Items["Alpha"] and Items["Palette"] and Items["Hue"] then 
                Library:Connect(UserInputService.InputChanged, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if SlidingPalette then
                            Colorpicker:SlidePalette(Input)
                        elseif SlidingHue then
                            Colorpicker:SlideHue(Input)
                        elseif SlidingAlpha then
                            Colorpicker:SlideAlpha(Input)
                        end
                    end
                end)
            end

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end
    
            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Name = Data.Name or "Keybind",
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "MOUSE2",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 240, 0, 0),
                    Position = UDim2.new(0, 1004, 0, 121),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
                
                Keybind.Items = Items
            end

            local ListItem 

            if Library.KeyList then
                ListItem = Library.KeyList:Add(Keybind.Name, "None")
            end

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    Library:RegisterOpenFrame(Keybind, {
                        HoverItems = { Items["KeybindWindow"], Items["SettingsButton"] },
                        AnchorInstance = KeyButton,
                        PopupInstance = KeybindWindow,
                    })
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Keybind)
                    Library:UnregisterOpenFrame(Keybind)
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value

                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end
                end
            })

            local ResetButton = Library:Button({
                Name = "Reset",
                Parent  = Items["KeybindWindow"],
                Callback = function()
                    if Data.Default then
                        Keybind:Set(Data.Default)
                    end
                end
            })
    
            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end
    
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end
    
            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name == "Backspace" and "None" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end
    
                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)
    
            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end
    
                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    end
                end
            end)
    
            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Library:RegisterOpenFrameTrigger(Items["KeyButton"])
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = { 
                Name = Params.Name or Params.name or Self.Name or "Watermark",
                Logo = Params.Logo or Params.logo or Self.Logo,

                Window = Self,
                Items = { }
            }

            local Items = { } do 
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, -10),
                    Size = UDim2.new(0, 0, 0, 45),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Watermark"]:MakeDraggable()
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["Main"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 4,
                    Parent = Items["Main"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Watermark.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 38, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Main"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Watermark.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["NewHolder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Items["FPSText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["NewHolder"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = 'FPS: <font color="rgb(120, 120, 120)">0</font>',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["NewHolder"].Instance,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["NewHolder"].Instance,
                    PaddingTop = UDim.new(0, 6)
                })
                
                Items["PingText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["NewHolder"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = 'PING: <font color="rgb(120, 120, 120)">0MS</font>',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Watermark.Items = Items
            end

            local GetInactiveRGB = function()
                local Color = Library.Theme["Inactive Text"]
                return string.format(
                    "rgb(%d, %d, %d)",
                    math.floor(Color.R * 255 + 0.5),
                    math.floor(Color.G * 255 + 0.5),
                    math.floor(Color.B * 255 + 0.5)
                )
            end

            local GetPing = function()
                local Ok, Value = pcall(function()
                    return math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end)

                if Ok and Value then
                    return Value
                end

                Ok, Value = pcall(function()
                    return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                end)

                return (Ok and Value) or 0
            end

            local FrameCount = 0
            local LastUpdate = os.clock()

            Library:Connect(RunService.RenderStepped, function()
                FrameCount += 1

                local Now = os.clock()
                if Now - LastUpdate < 1 then
                    return
                end

                local FPS = FrameCount
                FrameCount = 0
                LastUpdate = Now

                local Color = GetInactiveRGB()
                Items["FPSText"].Instance.Text = string.format('FPS: <font color="%s">%d</font>', Color, FPS)
                Items["PingText"].Instance.Text = string.format('PING: <font color="%s">%ms</font>', Color, GetPing())
            end)

            function Watermark:Center()
                Items["Watermark"]:ConvertAnchor()
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Watermark.Name = tostring(Text)
                Items["Title"].Instance.Text = Watermark.Name
            end

            Watermark:Center()
            Self.Watermark = Watermark

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or { }
            
            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List",
                Keys = { },
                Window = Self,
                Items = { }
            }

            local Items = { } do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Size = UDim2.new(0, 220, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = KeybindList.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 12, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    TopRightRadius = UDim.new(0, 0),
                    TopLeftRadius = UDim.new(0, 0)
                })

                Items["KeybindList"]:MakeDraggable(Items["Top"])
                Items["KeybindList"]:MakeDraggable(Items["Content"])

                KeybindList.Items = Items 
            end

            local KeybindTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            local RowHeight = 16
            local RowGap = 6
            local RowSlot = RowHeight + RowGap
            local SlideOffset = 14

            function KeybindList:Add(Name, Key)
                local RowItems = { } do
                    RowItems["NewKey"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Content"].Instance,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, 0),
                        Visible = false,
                        BorderSizePixel = 0
                    })
                    
                    RowItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = RowItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Name or "Keybind",
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})
                    
                    RowItems["Key"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = RowItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = string.upper(tostring(Key or "None")),
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Inactive Text'})
                end

                local NewKey = {
                    Name = Name or "Keybind",
                    Key = Key or "None",
                    Active = false,
                    Items = RowItems
                }

                function NewKey:Set(NewName, NewKeyValue)
                    if NewName ~= nil then
                        NewKey.Name = tostring(NewName)
                        RowItems["Text"].Instance.Text = NewKey.Name
                    end

                    if NewKeyValue ~= nil then
                        NewKey.Key = tostring(NewKeyValue)
                        RowItems["Key"].Instance.Text = string.upper(NewKey.Key)
                    end
                end

                function NewKey:SetStatus(Bool)
                    if NewKey.Active == Bool then
                        return
                    end

                    NewKey.Active = Bool

                    if Bool then
                        RowItems["NewKey"].Instance.Visible = true
                        RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)

                        RowItems["Text"]:Tween({TextTransparency = 0, Position = UDim2.new(0, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                        RowItems["Key"]:Tween({TextTransparency = 0, Position = UDim2.new(1, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                    else
                        RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, 0)}, KeybindTweenInfo)
                        RowItems["Text"]:Tween({TextTransparency = 1, Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2)}, KeybindTweenInfo)
                        RowItems["Key"]:Tween({TextTransparency = 1, Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2)}, KeybindTweenInfo)

                        task.delay(Library.Animation.Time, function()
                            if not NewKey.Active and RowItems["NewKey"].Instance.Parent then
                                RowItems["NewKey"].Instance.Visible = false
                            end
                        end)
                    end
                end

                function NewKey:Remove()
                    local Index = table.find(KeybindList.Keys, NewKey)

                    if Index then
                        table.remove(KeybindList.Keys, Index)
                    end

                    RowItems["NewKey"].Instance:Destroy()
                end

                table.insert(KeybindList.Keys, NewKey)
                return NewKey
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:SetText(Text)
                KeybindList.Name = tostring(Text)
                Items["Title"].Instance.Text = KeybindList.Name
            end

            function KeybindList:Center()
                Items["KeybindList"]:ConvertAnchor()
            end

            KeybindList:Center()

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList

            return setmetatable(KeybindList, Library)
        end

        Library.Notification = function(Self, Params)
            Params = Params or { }

            local Name = Params.Name or Params.name or "Notification"
            local Description = Params.Description or Params.description or ""
            local Duration = Params.Duration or Params.duration or 5
            local Color = Params.Color or Params.color or Library.Theme.Accent

            local Notification = {
                Removing = false,
                Items = { }
            }

            local Items = { } do 
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Inline"],
                    ZIndex = 100
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 25),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Description"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Description,
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 15),
                    Size = UDim2.new(1, 0, 0, 5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color,
                    ZIndex = 101
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Duration"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = string.format("%.1fs", Duration),
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Inactive Text'})                
            end

            Notification.Items = Items
            table.insert(Library.Notifications, 1, Notification)

            for Index, Notif in Library.Notifications do
                Notif.Items["Notification"].Instance.LayoutOrder = Index
            end

            task.wait()

            local FullSize = Items["Notification"].Instance.AbsoluteSize
            local TweenInfoIn = TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, 0)
            Items["Notification"].Instance.BackgroundTransparency = 1
            Items["Stroke"].Instance.Transparency = 1
            Items["Text"].Instance.TextTransparency = 1
            Items["Description"].Instance.TextTransparency = 1
            Items["Duration"].Instance.TextTransparency = 1
            Items["Liner"].Instance.BackgroundTransparency = 1
            Items["Liner"].Instance.Size = UDim2.new(1, 0, 0, 5)

            local Fade = function(Transparency)
                Items["Notification"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
                Items["Stroke"]:Tween({Transparency = Transparency}, TweenInfoIn)
                Items["Text"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Description"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Duration"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Liner"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
            end

            Library:Thread(function()
                Fade(0)
                Items["Notification"]:Tween({Size = UDim2.new(0, FullSize.X, 0, FullSize.Y)}, TweenInfoIn)

                Items["Liner"]:Tween({Size = UDim2.new(0, 0, 0, 5)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

                local Start = tick()
                while tick() - Start < Duration and not Notification.Removing do
                    local Remaining = math.max(0, Duration - (tick() - Start))
                    Items["Duration"].Instance.Text = string.format("%.1fs", Remaining)
                    task.wait(0.05)
                end

                if Notification.Removing then
                    return
                end

                Notification.Removing = true

                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end

                Fade(1)
                Items["Notification"]:Tween({Size = UDim2.new(0, 0, 0, 0)}, TweenInfoIn)

                task.wait(Library.Animation.Time)
                Items["Notification"].Instance:Destroy()
            end)

            return Notification
        end

        Library.ESPPreview = function(Self, Params)
            Params = Params or { }

            local ESPPreview = {
                Name = Params.Name or Params.name or "ESP Preview",

                Window = Self,
                Player = nil,
                Spinning = false,
                Items = { }
            }

            local BottomHeight = 32

            local Items = { } do
                Items["ESPPreview"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ESPPreview.Window.Items.MainFrame.Instance,
                    Position = UDim2.new(1, 10, 0, 0),
                    Size = UDim2.new(0, 200, 0, 260),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = ESPPreview.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 12, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["ViewportBackground"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ESPPreview"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 1, -(40 + BottomHeight)),
                    BorderSizePixel = 0
                })
                
                Items["Viewport"] = Library:Create("ViewportFrame", {
                    Name = "\0",
                    Parent = Items["ViewportBackground"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Ambient = Color3.fromRGB(200, 200, 200),
                    LightColor = Color3.fromRGB(255, 255, 255)
                })

                Items["Bottom"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, BottomHeight),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Bottom"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Bottom"].Instance,
                    PaddingTop = UDim.new(0, 7),
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                })

                ESPPreview.Items = Items 
            end

            local ClampPitch = function(PitchValue)
                return math.clamp(PitchValue, math.rad(-80), math.rad(80))
            end

            local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Viewport = Items["Viewport"]

            local ViewportCamera = Instance.new("Camera")
            Viewport.Instance.CurrentCamera = ViewportCamera
            ViewportCamera.CameraType = Enum.CameraType.Track
            ViewportCamera.Parent = Viewport.Instance

            local ViewportModel
            local Zoom = 6
            local MinZoom = 2
            local MaxZoom = 20

            local LastPosition
            local IsRotating = false
            local Sensitivity = 0.7

            local Yaw = math.rad(180)
            local Roll = 0
            local Pitch = 0

            local YawVelocity = 0
            local PitchVelocity = 0

            local Damping = 0.975
            local VelocityPower = 0.01
            local SpinSpeed = math.rad(35)

            local UpdateCamera = function()
                Library:Tween({CFrame = CFrame.new(Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0))}, nil, ViewportCamera)
            end

            local SetupModel = function(Character)
                if ViewportModel then
                    ViewportModel:Destroy()
                    ViewportModel = nil
                end

                if not Character then
                    return
                end

                Character.Archivable = true
                ViewportModel = Character:Clone()
                Character.Archivable = false

                if ViewportModel.PrimaryPart then
                    ViewportModel.PrimaryPart.Anchored = true
                end

                ViewportModel.Parent = Viewport.Instance

                for _, Value in ViewportModel:GetDescendants() do
                    if Value:IsA("LocalScript") or Value:IsA("Script") then
                        Value:Destroy()
                    elseif Value:IsA("BasePart") then
                        Value.Anchored = true
                        Value.CanCollide = false
                    end
                end

                local HumanoidRootPart = ViewportModel:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    if not ViewportModel.PrimaryPart then
                        ViewportModel.PrimaryPart = HumanoidRootPart
                    end

                    ViewportModel:SetPrimaryPartCFrame(CFrame.Angles(0, math.rad(180), 0) + Vector3.new(0, 2, 0))
                    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0))
                end

                ViewportCamera.CameraSubject = ViewportModel
                ESPPreview.Player = ViewportModel
            end

            if LocalCharacter then
                SetupModel(LocalCharacter)
            end

            Library:Connect(LocalPlayer.CharacterAdded, function(Character)
                task.wait(0.25)
                SetupModel(Character)
            end)

            local ViewportInputChanged
            Items["ViewportBackground"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsRotating = true
                    LastPosition = Input.Position

                    if ViewportInputChanged then
                        return
                    end

                    ViewportInputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            IsRotating = false
                            ViewportInputChanged:Disconnect()
                            ViewportInputChanged = nil
                        end
                    end)
                end
            end)

            Items["ViewportBackground"]:Connect("InputChanged", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if not LastPosition or not IsRotating then
                        return
                    end

                    local RotationDelta = Input.Position - LastPosition
                    local DeltaX = RotationDelta.X
                    local DeltaY = RotationDelta.Y

                    Yaw = Yaw - math.rad(DeltaX * Sensitivity)
                    Pitch = ClampPitch(Pitch - math.rad(DeltaY * Sensitivity))

                    YawVelocity = -DeltaX * VelocityPower
                    PitchVelocity = -DeltaY * VelocityPower

                    LastPosition = Input.Position
                end

                if Input.UserInputType == Enum.UserInputType.MouseWheel then
                    Zoom = math.clamp(Zoom - Input.Position.Z, MinZoom, MaxZoom)
                    UpdateCamera()
                end
            end)

            Library:Connect(RunService.RenderStepped, function(DeltaTime)
                if not IsRotating then
                    if ESPPreview.Spinning then
                        Yaw = Yaw + SpinSpeed * DeltaTime
                        YawVelocity = 0
                    else
                        Yaw = Yaw + YawVelocity
                        YawVelocity = YawVelocity * Damping

                        if math.abs(YawVelocity) < 0.0001 then
                            YawVelocity = 0
                        end
                    end

                    Pitch = ClampPitch(Pitch + PitchVelocity)
                    PitchVelocity = PitchVelocity * Damping

                    if math.abs(PitchVelocity) < 0.0001 then
                        PitchVelocity = 0
                    end
                end

                if ViewportModel and ViewportModel.PrimaryPart then
                    local Rotation = CFrame.Angles(Pitch, Yaw, Roll)
                    ViewportModel:SetPrimaryPartCFrame(Rotation + Vector3.new(0, 2, 0))
                end
            end)

            UpdateCamera()

            setmetatable(ESPPreview, Library)

            ESPPreview:Toggle({
                Name = "Spin",
                Flag = "ESPPreview/Spin",
                Parent = Items["Bottom"],
                Default = false,
                Callback = function(Value)
                    ESPPreview.Spinning = Value
                end
            })

            function ESPPreview:SetVisibility(Bool)
                Items["ESPPreview"].Instance.Visible = Bool
            end

            function ESPPreview:SetText(Text)
                ESPPreview.Name = tostring(Text)
                Items["Text"].Instance.Text = ESPPreview.Name
            end

            Self.ESPPreview = ESPPreview

            return ESPPreview
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
                Name = Params.Name or Params.name or "Window",
                SubName = Params.SubName or Params.subname or "",
                Logo = Params.Logo or Params.logo or "rbxassetid://87164893498141",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.65
                    })
                end

                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 560, 0, 560),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 4,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Window.Name,
                    Position = UDim2.new(0, 52, 0, 10),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubTitle"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Window.SubName,
                    Position = UDim2.new(0, 52, 0, 30),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Text"]
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingRight = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })        
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 56),
                    Size = UDim2.new(1, 0, 1, -56),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({BackgroundColor3 = 'Text'})                

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Debounce = true 

                Window.IsOpen = Bool
                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do 
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                Items["MainFrame"]:ConvertAnchor()
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Icon = Params.Icon or Params.icon or "",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 35, 0, 35),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 1),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 2, 
                    Parent = Items["Inactive"].Instance,
                    Visible = true,
                    TextTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 30, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })                

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            local GetSize = function()
                local AbsSize = Items["Inactive"].Instance.AbsoluteSize
                Items["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
                task.wait()
                Items["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

                return AbsSize
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end 

                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                Items["Inactive"]:Tween({BackgroundTransparency = 0})
            end, function()
                if Page.Active then return end 

                Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                Items["Inactive"]:Tween({BackgroundTransparency = 1})
            end)

            local Size = GetSize()
            local X = Size.X

function Page:Turn()
    local Old = Page.Window.Current 

    if Old == Page then return end
    if Page.Debounce then return end
    if Old and Old.Debounce then return end

    Page.Debounce = true 
    
    if Old then 
        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

        Old.Items["Inactive"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)})
        Old.Items["Text"]:Tween({TextTransparency = 1})

        Old.Items["Page"]:FadeDescendants(false, function()
            Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
        end)

        Old.Active = false
    end

    Items["Text"].Instance.Visible = true

    local TextWidth = Items["Text"].Instance.TextBounds.X
    if TextWidth <= 0 then
        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.65)
    end

    local TabWidth = math.max(35, math.ceil(58 + TextWidth))

    Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
    Items["Page"].Instance.Visible = true
    Items["Page"]:FadeDescendants(true, function()
        Page.Debounce = false
    end)

    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
    Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

    Items["Inactive"]:Tween({
        BackgroundTransparency = 0,
        Size = UDim2.new(0, TabWidth, 0, 35)
    })
    Items["Text"]:Tween({TextTransparency = 0})

    Page.Window.Current = Page
    Page.Active = true
end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

Library.Section = function(Self, Params)
    Params = Params or { } 

    local Section = {
        Name = Params.Name or Params.name or "Section",
        Side = Params.Side or Params.side or 1,

        Window = Self.Window,
        Page = Self,
        Items = { },
    }

    local Items = { } do 
        Items["Section"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Section.Page.ColumnsData[Section.Side].Instance,
            Size = UDim2.new(1, 0, 0, 75),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Library.Theme["Inline"]
        }):AddToTheme({BackgroundColor3 = 'Inline'})
        
        Library:Create("UICorner", {
            Name = "\0",
            Parent = Items["Section"].Instance
        })
        
        Items["Top"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            Size = UDim2.new(1, 0, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme["Tab"]
        }):AddToTheme({BackgroundColor3 = 'Tab'})
        
        Library:Create("UICorner", {
            Name = "\0",
            Parent = Items["Top"].Instance,
            BottomRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, 0)
        })
        
        Items["Text"] = Library:Create("TextLabel", {
            Name = "\0",
            FontFace = Library.Font,
            TextSize = Library.FontSize + 2,
            Parent = Items["Top"].Instance,
            TextColor3 = Library.Theme["Text"],
            Text = Section.Name,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY
        }):AddToTheme({TextColor3 = 'Text'})
        
        Library:Create("UIPadding", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            PaddingBottom = UDim.new(0, 12)
        })
        
        Items["Content"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 52),
            Size = UDim2.new(1, -24, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        Library:Create("UIListLayout", {
            Name = "\0",
            Parent = Items["Content"].Instance,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Library:Create("UIPadding", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            PaddingBottom = UDim.new(0, 12)
        })                

        Section.Items = Items
    end 

    return setmetatable(Section, Library)
end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["IndicatorOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Check"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "rbxassetid://133055463536692",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -26, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            
                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})

                    Items["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                    Items["Check"]:Tween({ImageTransparency = 0})
                else
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                    Items["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                    Items["Check"]:Tween({ImageTransparency = 1})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    ZIndex = 2 ,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})       
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Button:Press()
                Items["Accent"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                task.wait(0.18)
                Items["Accent"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 1,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSliderOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSliderOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 2),
                    TopRightRadius = UDim.new(0, 2),
                    BottomRightRadius = UDim.new(0, 2),
                    BottomLeftRadius = UDim.new(0, 2)
                })
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSliderOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.8999999761581421, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })
                
                Items["DraggerOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["DraggerOutline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["DraggerInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["DraggerOutline"].Instance,
                    Position = UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["DraggerInline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["DraggerInline"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "%90 gay",
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})                

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            Slider.DisplayValue = Slider.Default

            function Slider:AnimateValue(NewValue)
                if Slider.ValueTween then
                    Slider.ValueTween:Disconnect()
                end

                local Start = Slider.DisplayValue
                local Goal = NewValue
                local Duration = 0.18

                local Clock = tick()

                Slider.ValueTween = RunService.RenderStepped:Connect(function()
                    local Alpha = math.clamp((tick() - Clock) / Duration, 0, 1)
                    Alpha = TweenService:GetValue(Alpha, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                    local Current = Start + (Goal - Start) * Alpha

                    local Rounded = Library:Round(Current, Slider.Decimals)

                    Items["Value"].Instance.Text = string.format("%s%s", Rounded, Slider.Suffix)

                    if Alpha >= 1 then
                        Slider.DisplayValue = Goal
                        Items["Value"].Instance.Text = string.format("%s%s", Goal, Slider.Suffix)

                        Slider.ValueTween:Disconnect()
                        Slider.ValueTween = nil
                    end
                end)
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween({Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Slider:AnimateValue(Slider.Value)

                local Percent = math.clamp((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1)      
                Items["DraggerOutline"]:Tween({Position = UDim2.new(Percent, (12 / 2) - (Percent * 12), 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

                if Slider.Value == Slider.Min then 
                    Items["Accent"]:Tween({BackgroundTransparency = 1})
                else
                    Items["Accent"]:Tween({BackgroundTransparency = 0})
                end

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        local OptionSearchInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        local OptionHeight = 18
        local OptionGap = 6
        local OptionSlot = OptionHeight + OptionGap

        local SetOptionSearchVisible = function(OptionData, OptionItems, Visible) -- sorry i have to do this brto 
            if OptionData.SearchVisible == Visible then
                return
            end

            OptionData.SearchVisible = Visible

            local Button = OptionItems["Toggle"]
            local ButtonInstance = Button.Instance

            if Visible then
                ButtonInstance.Visible = true
                Button:Tween({Size = UDim2.new(1, 0, 0, OptionSlot)}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween({BackgroundTransparency = 0}, OptionSearchInfo)
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 0}, OptionSearchInfo)

                if OptionData.IsSelected then
                    OptionItems["Text"]:Tween({TextTransparency = 0, TextColor3 = Library.Theme.Text}, OptionSearchInfo)
                    OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}, OptionSearchInfo)
                    OptionItems["Check"]:Tween({ImageTransparency = 0}, OptionSearchInfo)
                else
                    OptionItems["Text"]:Tween({TextTransparency = 0, TextColor3 = Library.Theme["Inactive Text"]}, OptionSearchInfo)
                    OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, OptionSearchInfo)
                    OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
                end
            else
                Button:Tween({Size = UDim2.new(1, 0, 0, 0)}, OptionSearchInfo)
                OptionItems["Text"]:Tween({TextTransparency = 1}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Inline"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
            end
        end

        local SearchOptions = function(Options, Query, Holder)
            Query = string.lower(tostring(Query or ""))

            for _, OptionData in Options do
                local Matches = Query == "" or string.find(string.lower(OptionData.Name), Query, 1, true) ~= nil
                OptionData:SetSearchVisible(Matches)
            end

            if Holder then
                Holder:Tween({CanvasPosition = Vector2.new(0, 0)}, OptionSearchInfo)
            end
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                MaxSize = Params.MaxSize or Params.maxsize or 120,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 51),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdownOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdownOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdownOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://73883327119089",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})          
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Position = UDim2.new(0.719742476940155, 0, 0.1462799459695816, 0),
                    Size = UDim2.new(0, 241, 0, 175),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Search"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionHolder"].Instance,
                    TextWrapped = true,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search..",
                    Size = UDim2.new(1, -20, 0, 20),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0, 7),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://103256802537537",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -20, 1, -45),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 35),
                    BottomImage = "rbxassetid://103256802537537",
                    TopImage = "rbxassetid://103256802537537"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Dropdown.Items = Items 
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionItems = { } do 
                    OptionItems["Toggle"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, OptionSlot),
                        BorderSizePixel = 0
                    })
                    
                    OptionItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = OptionItems["Toggle"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Value,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})
                    
                    OptionItems["IndicatorOutline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Toggle"].Instance,
                        Size = UDim2.new(0, 18, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({BackgroundColor3 = 'Outline'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Indicator"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1),
                        Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({BackgroundColor3 = 'Background'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Inline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = 'Accent'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Check"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        ImageColor3 = Color3.fromRGB(0, 0, 0),
                        ImageTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "rbxassetid://133055463536692",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                    }
                    })                    
                end

                local OptionData = {
                    Button = OptionItems["Toggle"],
                    Text = OptionItems["Text"],
                    Name = Value,
                    IsSelected = false,
                    SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(function()
                    if OptionData.IsSelected or not Dropdown.IsOpen then return end 
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if OptionData.IsSelected or not Dropdown.IsOpen then return end 
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then 
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    if not Dropdown.IsOpen then return end 

                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then 
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then 
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then 
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Search(Query)
                SearchOptions(Dropdown.Options, Query, Items["Holder"])

                if not Dropdown.IsOpen then
                    return
                end

                Query = string.lower(tostring(Query or ""))
                local Width = Items["RealDropdown"].Instance.AbsoluteSize.X
                local TargetHeight = Dropdown.MaxSize

                if Query ~= "" then
                    local VisibleCount = 0

                    for _, OptionData in Dropdown.Options do
                        if OptionData.SearchVisible then
                            VisibleCount += 1
                        end
                    end

                    local HeaderHeight = 40
                    TargetHeight = math.clamp(HeaderHeight + VisibleCount * OptionSlot, HeaderHeight, Dropdown.MaxSize)
                end

                Items["Holder"]:Tween({ScrollBarImageTransparency = Query ~= "" and 1 or 0}, OptionSearchInfo)
                Items["OptionHolder"]:Tween({Size = UDim2.new(0, Width, 0, TargetHeight)}, OptionSearchInfo)
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end

                Dropdown:Search(Items["Search"].Instance.Text)
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local Debounce = false 
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)
                    
                    OptionHolder.Parent = Library.Holder.Instance
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    Library:RegisterOpenFrame(Dropdown, {
                        HoverItems = { Items["OptionHolder"], Items["RealDropdown"] },
                        AnchorInstance = RealDropdown,
                        PopupInstance = OptionHolder,
                    })
                else
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Items["Search"].Instance.Text = ""
                        Dropdown:Search("")
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Dropdown)
                    Library:UnregisterOpenFrame(Dropdown)
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

            Library:RegisterOpenFrameTrigger(Items["RealDropdown"])

            Library:Connect(Items["Search"].Instance:GetPropertyChangedSignal("Text"), function()
                Dropdown:Search(Items["Search"].Instance.Text)
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do 
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })          

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 51),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["BackgroundOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    Size = UDim2.new(1, -2, 1, -2),
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -16, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 8, 0.5, 0),
                    CursorPosition = -1,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text'})                

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            Items["Input"]:Connect("Focused", function()
                Items["BackgroundOutline"]:ChangeItemTheme({BackgroundColor3 = Library.Theme["Accent"]})
                Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
            end)

            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                if Textbox.Finished then
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end

                Items["BackgroundOutline"]:ChangeItemTheme({BackgroundColor3 = Library.Theme["Outline"]})
                Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Outline"]})
            end)

            if not Textbox.Finished then
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            return setmetatable(Textbox, Library)
        end

        Library.Divider = function(Self)
            local Items = { } do 
                Items["Divider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Self.Items.Content.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 7),
                    BorderSizePixel = 0
                })
                
                Items["RealDivider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Divider"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDivider"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
            end
            
            return Items
        end

        Library.ListBox = function(Self, Params)
            Params = Params or { }

            local List = {
                Name = Params.Name or Params.name or "ListBox",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                Height = Params.Height or Params.height or Params.MaxSize or Params.maxsize or 225,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = List.Section.Items["Content"]
            end

            local Items = { } do 
                Items["List"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, List.Height),
                    BorderSizePixel = 0
                })
                
                Items["TopOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Size = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })
                
                Items["TopInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://132783180980031",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 2),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["TopInline"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search...",
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 24, 0.5, 1),
                    Size = UDim2.new(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    ClipsDescendants = true
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SearchMeasure"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Search...",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Visible = false,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    Size = UDim2.new(1, 16, 0, 2),
                    Position = UDim2.new(0, -8, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["InlineOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 1, -30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InlineOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://103256802537537",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://103256802537537",
                    TopImage = "rbxassetid://103256802537537"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                List.Items = Items 
            end

            local SearchBarExtra = 48

            local UpdateSearchBarSize = function(Instant)
                local Input = Items["Input"].Instance
                local Measure = Items["SearchMeasure"].Instance
                local Text = Input.Text ~= "" and Input.Text or Input.PlaceholderText

                Measure.Text = Text

                local TextWidth = math.ceil(math.max(Measure.TextBounds.X, Measure.AbsoluteSize.X))
                local TargetWidth = TextWidth + SearchBarExtra
                local MaxWidth = Items["List"].Instance.AbsoluteSize.X

                if MaxWidth > 0 then
                    TargetWidth = math.min(TargetWidth, MaxWidth)
                end

                local InputWidth = math.max(TextWidth + 6, 0)

                if Instant then
                    Items["TopOutline"].Instance.Size = UDim2.new(0, TargetWidth, 0, 30)
                    Input.Size = UDim2.new(0, InputWidth, 0, 16)
                else
                    Items["TopOutline"]:Tween({Size = UDim2.new(0, TargetWidth, 0, 30)}, OptionSearchInfo)
                    Items["Input"]:Tween({Size = UDim2.new(0, InputWidth, 0, 16)}, OptionSearchInfo)
                end
            end

            UpdateSearchBarSize(true)

            function List:Set(Value)
                if List.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    List.Value = Value

                    for Index, Value in Value do
                        local OptionData = List.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Value in List.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionItems = { } do 
                    OptionItems["Toggle"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, OptionSlot),
                        BorderSizePixel = 0
                    })
                    
                    OptionItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = OptionItems["Toggle"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Value,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})
                    
                    OptionItems["IndicatorOutline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Toggle"].Instance,
                        Size = UDim2.new(0, 18, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({BackgroundColor3 = 'Outline'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Indicator"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1),
                        Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({BackgroundColor3 = 'Background'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Inline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = 'Accent'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })
                    
                    OptionItems["Check"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        ImageColor3 = Color3.fromRGB(0, 0, 0),
                        ImageTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "rbxassetid://133055463536692",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                    }
                    })                    
                end

                local OptionData = {
                    Button = OptionItems["Toggle"],
                    Text = OptionItems["Text"],
                    Name = Value,
                    IsSelected = false,
                    SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(function()
                    if OptionData.IsSelected then return end 
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if OptionData.IsSelected then return end 
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then 
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if List.Multi then 
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then 
                            table.remove(List.Value, Index)
                        else
                            table.insert(List.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then 
                            List.Value = OptionData.Name
                            Flags[List.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in List.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            List.Value = nil
                            Flags[List.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Search(Query)
                SearchOptions(List.Options, Query, Items["Holder"])
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(ListItems)
                for Index, Value in List.Options do 
                    List:Remove(Value.Name)
                end

                for Index, Value in ListItems do 
                    List:Add(Value)
                end

                List:Search(Items["Input"].Instance.Text)
            end

            function List:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool 
            end

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                UpdateSearchBarSize(false)
                List:Search(Items["Input"].Instance.Text)
            end)

            for Index, Value in List.OptionItems do 
                List:Add(Value)
            end

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        Library.Init = function(Self)
            local SettingsPage = Self:Page({Name = "Settings", Icon = "rbxassetid://71354798783833"})

            local ConfigName
            local ConfigSelected
            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

            local Notify = function(Name, Description, Color)
                Library:Notification({
                    Name = Name,
                    Description = Description or "",
                    Duration = 3,
                    Color = Color or Library.Theme.Accent
                })
            end

            local SuccessColor = Color3.fromRGB(52, 255, 126)
            local ErrorColor = Color3.fromRGB(255, 80, 80)

            do -- Profiles
                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Side = 1})

                local ConfigsList = ConfigsSection:ListBox({
                    Flag = "Configs",
                    Items = { },
                    Multi = false,
                    Height = 200,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if not ConfigName or ConfigName == "" then
                            Notify("Error", "Config name can't be empty.", ErrorColor)
                            return
                        end

                        if isfile(ConfigsFolder .. ConfigName .. ".json") then
                            Notify("Error", 'Config "' .. ConfigName .. '" already exists.', ErrorColor)
                            return
                        end

                        writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                        Library:GetConfigsList(ConfigsList)
                        Notify("Success", 'Created config "' .. ConfigName .. '".', SuccessColor)
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        local Success, Error = Library:LoadConfig(readfile(ConfigsFolder .. ConfigSelected .. ".json"))

                        if Success then
                            Notify("Success", 'Loaded config "' .. ConfigSelected .. '".', SuccessColor)
                        else
                            Notify("Error", "Failed to load config:\n" .. tostring(Error), ErrorColor)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        delfile(ConfigsFolder .. ConfigSelected .. ".json")
                        ConfigSelected = nil
                        Library:GetConfigsList(ConfigsList)
                        Notify("Success", "Deleted config.", SuccessColor)
                    end
                })

                ConfigsSection:Button({
                    Name = "Overwrite",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                        Notify("Success", 'Overwrote config "' .. ConfigSelected .. '".', SuccessColor)
                    end
                })

                Library:GetConfigsList(ConfigsList)
            end

            do -- Autoload
                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Side = 1})

                AutoloadSection:Button({
                    Name = "Set selected as autoload",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        writefile(Library.Directory .. "/autoload.json", readfile(ConfigsFolder .. ConfigSelected .. ".json"))
                        Notify("Success", 'Set "' .. ConfigSelected .. '" as autoload.', SuccessColor)
                    end
                })

                AutoloadSection:Button({
                    Name = "Clear autoload",
                    Callback = function()
                        writefile(Library.Directory .. "/autoload.json", "")
                        Notify("Success", "Cleared autoload.", SuccessColor)
                    end
                })
            end

            do -- Theming
                local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2})
                local ThemeReady = false

                ThemingSection:Dropdown({
                    Name = "Theme",
                    Flag = "SelectedTheme",
                    Items = Library.ThemeOrder,
                    Default = "Preset",
                    Callback = function(Value)
                        if not Library:ApplyTheme(Value) then
                            return
                        end

                        if ThemeReady then
                            Notify("Theme", 'Applied "' .. Value .. '" theme.', SuccessColor)
                        end
                    end
                })

                ThemeReady = true
                ThemingSection:Divider()

                for Index, Value in Library.Theme do
                    ThemingSection:Label({Name = Index}):Colorpicker({
                        Name = Index,
                        Flag = Index .. "Theming",
                        Default = Value,
                        Callback = function(Color)
                            Library.Theme[Index] = Color
                            Library:ChangeTheme(Index, Color)
                        end
                    })
                end
            end

            do -- Menu
                local MenuSection = SettingsPage:Section({Name = "Menu", Side = 2})

                MenuSection:Label({Name = "Menu Keybind"}):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Enum.KeyCode.X,
                    Mode = "Toggle",
                    Callback = function()
                        if Library.Flags["MenuKeybind"] and Library.Flags["MenuKeybind"].Key then
                            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                        end
                    end
                })

                if Self.Watermark then
                    MenuSection:Toggle({
                        Name = "Watermark",
                        Flag = "Watermark",
                        Default = true,
                        Callback = function(Value)
                            Self.Watermark:SetVisibility(Value)
                        end
                    })
                end

                if Self.KeybindList then
                    MenuSection:Toggle({
                        Name = "Keybind List",
                        Flag = "KeybindList",
                        Default = true,
                        Callback = function(Value)
                            Self.KeybindList:SetVisibility(Value)
                        end
                    })
                end

                if Self.ESPPreview then
                    MenuSection:Toggle({
                        Name = "ESP Preview",
                        Flag = "ESPPreview",
                        Default = true,
                        Callback = function(Value)
                            Self.ESPPreview:SetVisibility(Value)
                        end
                    })
                end

                MenuSection:Divider()

                MenuSection:Button({
                    Name = "Unload",
                    Callback = function()
                        Notify("Unloading", "Library is being unloaded.", Library.Theme.Accent)
                        task.delay(0.35, function()
                            Library:Exit()
                        end)
                    end
                })
            end

            local AutoloadContent = readfile(Library.Directory .. "/autoload.json")

            if AutoloadContent ~= "" then
                local Success, Error = Library:LoadConfig(AutoloadContent)

                if Success then
                    Notify("Autoload", "Loaded autoload config.", SuccessColor)
                else
                    Notify("Autoload", "Failed to load autoload:\n" .. tostring(Error), ErrorColor)
                end
            end
        end
    end
end

getgenv().Library = Library
return Library
