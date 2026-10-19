if getgenv().BootStrap then
    pcall(function() getgenv().BootStrap:Destroy() end);
end;

local CloneRef = cloneref or function(Object) return Object end;
local TweenService = CloneRef(game:GetService('TweenService'));
local UserInputService = CloneRef(game:GetService('UserInputService'));
local HttpService = CloneRef(game:GetService('HttpService'));
local LogService = CloneRef(game:GetService('LogService'));
local StarterGui = CloneRef(game:GetService('StarterGui'));
local CoreGui = CloneRef(game:GetService('CoreGui'));

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end;
local GetHui = gethui or function() return CoreGui end;

local NotAllowed = identifyexecutor and string.find(identifyexecutor(), 'Real') or string.find(identifyexecutor(), 'Wave') or false;

local StallSeconds = 40;
local TraceLines = 12;

local function Create(ClassName, Properties)
    local Object = Instance.new(ClassName);
    for Property, Value in next, Properties do
        if Property ~= 'Parent' then
            Object[Property] = Value;
        end;
    end;
    if Properties.Parent then
        Object.Parent = Properties.Parent;
    end;
    return Object;
end;

local function Darken(Color, Amount)
    return Color3.new(
        math.clamp(Color.R - Amount, 0, 1),
        math.clamp(Color.G - Amount, 0, 1),
        math.clamp(Color.B - Amount, 0, 1)
    );
end;

local function ResolveTheme()
    local Theme = {
        Font       = Color3.fromHex('ffffff');
        Main       = Color3.fromHex('1c1c1c');
        Accent     = Color3.fromHex('0055ff');
        Background = Color3.fromHex('141414');
        Outline    = Color3.fromHex('323232');
    };

    local function Apply(Scheme)
        if not Scheme then return end;
        Theme.Font       = Color3.fromHex(Scheme.FontColor or 'ffffff');
        Theme.Main       = Color3.fromHex(Scheme.MainColor or '1c1c1c');
        Theme.Accent     = Color3.fromHex(Scheme.AccentColor or '0055ff');
        Theme.Background = Color3.fromHex(Scheme.BackgroundColor or '141414');
        Theme.Outline    = Color3.fromHex(Scheme.OutlineColor or '323232');
    end;

    pcall(function()
        local Name = isfile and isfile('ZekeHub/themes/default.txt') and readfile('ZekeHub/themes/default.txt');
        if not Name or Name == '' then return end;

        local CustomPath = 'ZekeHub/themes/' .. Name .. '.json';
        if isfile and isfile(CustomPath) then
            Apply(HttpService:JSONDecode(readfile(CustomPath)));
            return;
        end;

        local ThemeManager = loadstring(game:HttpGet('https://zekehub.com/scripts/UILib/ThemeManager.lua'))();
        if ThemeManager and ThemeManager.BuiltInThemes and ThemeManager.BuiltInThemes[Name] then
            Apply(ThemeManager.BuiltInThemes[Name][2]);
        end;
    end);

    return Theme;
end;

local BootStrap = {
    Finished = false;
    Minimized = false;
    Stalled = false;
    Progress = 0;
    StatusText = 'Starting...';
    Started = os.clock();
    LastStep = os.clock();
    Lines = {};
    Seen = {};
    Rows = {};
    Order = 0;
    RowStart = 0;
    Connections = {};
};

do
    local Theme = ResolveTheme();

    local Viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080);
    local Scale = math.clamp(math.min(Viewport.X / 1280, Viewport.Y / 720), 0.75, 1);
    local Mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;

    local Width, Height = 300, 140;

    BootStrap.Colors = {
        Info = Darken(Theme.Font, 0.4);
        Good = Theme.Font;
        Warn = Color3.fromRGB(255, 200, 80);
        Error = Color3.fromRGB(255, 80, 80);
        Accent = Theme.Accent;
    };

    local ScreenGui = Create('ScreenGui', {
        Name = HttpService:GenerateGUID(false):gsub('-', '');
        ResetOnSpawn = false;
        IgnoreGuiInset = true;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        DisplayOrder = 1000000;
    });
    ProtectGui(ScreenGui);
    ScreenGui.Parent = GetHui();

    local Outer = Create('Frame', {
        AnchorPoint = Mobile and Vector2.new(0.5, 0) or Vector2.new(0, 1);
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderSizePixel = 0;
        Position = Mobile and UDim2.new(0.5, 0, 0, 64) or UDim2.new(0, 20, 1, -20);
        Size = UDim2.fromOffset(Width, Height);
        Parent = ScreenGui;
    });
    Create('UICorner', { CornerRadius = UDim.new(0, 12); Parent = Outer; });
    Create('UIScale', { Scale = Scale; Parent = Outer; });

    local Inner = Create('Frame', {
        BackgroundColor3 = Theme.Main;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        Parent = Outer;
    });
    Create('UICorner', { CornerRadius = UDim.new(0, 11); Parent = Inner; });
    Create('UIStroke', {
        Color = Theme.Accent;
        Thickness = 1;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Parent = Inner;
    });

    local Title = Create('TextLabel', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 14, 0, 6);
        Size = UDim2.new(1, -60, 0, 20);
        Font = Enum.Font.Code;
        Text = 'ZekeHub';
        TextColor3 = Theme.Font;
        TextSize = 15;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = Inner;
    });

    local function MakeButton(Symbol, OffsetX, TextSize, ButtonWidth)
        local Button = Create('TextButton', {
            AnchorPoint = Vector2.new(1, 0);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, OffsetX, 0, 7);
            Size = UDim2.fromOffset(ButtonWidth or 18, 18);
            Font = Enum.Font.Code;
            Text = Symbol;
            TextColor3 = Darken(Theme.Font, 0.45);
            TextSize = TextSize;
            TextStrokeTransparency = 0;
            Parent = Inner;
        });
        Button.MouseEnter:Connect(function() Button.TextColor3 = Theme.Accent; end);
        Button.MouseLeave:Connect(function() Button.TextColor3 = Darken(Theme.Font, 0.45); end);
        return Button;
    end;

    local CloseButton = MakeButton('X', -10, 13);
    local MinimizeButton = MakeButton('-', -32, 18);
    local CopyButton = MakeButton('Copy log', -54, 12, 64);
    CopyButton.Visible = false;

    local Section = Create('Frame', {
        BackgroundColor3 = Theme.Background;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 8, 0, 30);
        Size = UDim2.new(1, -16, 1, -38);
        Parent = Inner;
    });
    Create('UICorner', { CornerRadius = UDim.new(0, 4); Parent = Section; });
    Create('UIStroke', { Color = Theme.Outline; Thickness = 1; Parent = Section; });

    local Status = Create('TextLabel', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 10, 0, 6);
        Size = UDim2.new(1, -20, 0, 15);
        Font = Enum.Font.Code;
        Text = 'Starting...';
        TextColor3 = Theme.Accent;
        TextSize = 13;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Section;
    });

    local Log = Create('ScrollingFrame', {
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 10, 0, 24);
        Size = UDim2.new(1, -14, 1, -46);
        CanvasSize = UDim2.new();
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollBarThickness = 2;
        ScrollBarImageColor3 = Theme.Accent;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        Parent = Section;
    });
    Create('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 1);
        Parent = Log;
    });

    local Percent = Create('TextLabel', {
        AnchorPoint = Vector2.new(1, 1);
        BackgroundTransparency = 1;
        Position = UDim2.new(1, -10, 1, -12);
        Size = UDim2.fromOffset(40, 14);
        Font = Enum.Font.Code;
        Text = '0%';
        TextColor3 = Theme.Accent;
        TextSize = 12;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Right;
        Parent = Section;
    });

    local BarTrack = Create('Frame', {
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Darken(Theme.Main, 0.03);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 10, 1, -11);
        Size = UDim2.new(1, -58, 0, 5);
        Parent = Section;
    });
    Create('UICorner', { CornerRadius = UDim.new(1, 0); Parent = BarTrack; });

    local BarFill = Create('Frame', {
        BackgroundColor3 = Theme.Accent;
        BorderSizePixel = 0;
        Size = UDim2.fromScale(0, 1);
        Parent = BarTrack;
    });
    Create('UICorner', { CornerRadius = UDim.new(1, 0); Parent = BarFill; });

    BootStrap.ScreenGui = ScreenGui;
    BootStrap.Outer = Outer;
    BootStrap.Section = Section;
    BootStrap.Title = Title;
    BootStrap.Status = Status;
    BootStrap.LogFrame = Log;
    BootStrap.Percent = Percent;
    BootStrap.BarFill = BarFill;
    BootStrap.CopyButton = CopyButton;
    BootStrap.Width = Width;
    BootStrap.FullHeight = Height;

    do
        local Dragging, DragStart, StartPosition;
        Outer.Active = true;
        Outer.InputBegan:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
                and Input.Position.Y - Outer.AbsolutePosition.Y <= 28 * Scale then
                Dragging = true;
                DragStart = Input.Position;
                StartPosition = Outer.Position;
            end;
        end);
        table.insert(BootStrap.Connections, UserInputService.InputChanged:Connect(function(Input)
            if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                local Delta = Input.Position - DragStart;
                Outer.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
            end;
        end));
        table.insert(BootStrap.Connections, UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false;
            end;
        end));
    end;

    CloseButton.MouseButton1Click:Connect(function() BootStrap:Destroy(); end);
    MinimizeButton.MouseButton1Click:Connect(function() BootStrap:ToggleMinimize(); end);
    CopyButton.MouseButton1Click:Connect(function() BootStrap:CopyReport(); end);
end;

function BootStrap:Time()
    return os.clock() - self.Started;
end;

function BootStrap:Record(Text, Kind)
    local Prefix = (Kind == 'Warn' or Kind == 'Error') and (Kind:upper() .. ': ') or '';
    for Line in tostring(Text or ''):gmatch('[^\n]+') do
        table.insert(self.Lines, string.format('[%5.1fs] %s%s', self:Time(), Prefix, Line));
    end;
end;

function BootStrap:AddLine(Text, Kind)
    self.Order = self.Order + 1;
    local Label = Create('TextLabel', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, -4, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        Font = Enum.Font.Code;
        Text = Text;
        TextColor3 = self.Colors[Kind or 'Info'];
        TextSize = 12;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextWrapped = true;
        LayoutOrder = self.Order;
        Parent = self.LogFrame;
    });

    task.defer(function()
        if self.LogFrame and self.LogFrame.Parent then
            self.LogFrame.CanvasPosition = Vector2.new(0, math.max(0, self.LogFrame.AbsoluteCanvasSize.Y - self.LogFrame.AbsoluteSize.Y));
        end;
    end);

    return Label;
end;

function BootStrap:Log(Text, Kind)
    if self.Finished then return end;
    self:Record(Text, Kind);

    for Line in tostring(Text or ''):gmatch('[^\n]+') do
        self:AddLine(Line, Kind);
    end;
end;

function BootStrap:UpdateRow(Index, Row)
    if self.Finished then return end;

    local Line = self.Rows[Index];
    if not Line then
        Line = { Label = self:AddLine(Row.Text, Row.Kind) };
        self.Rows[Index] = Line;
    else
        Line.Label.Text = Row.Text;
        Line.Label.TextColor3 = self.Colors[Row.Kind];
    end;

    if Line.Phase ~= Row.Phase then
        Line.Phase = Row.Phase;
        self:Record(Row.Report, Row.Kind == 'Error' and 'Error' or nil);
        self:Step();
    end;
end;

local function ReadRow(Raw)
    local Name, Body = Raw:match('%-%- %[([^%]]+)%]: (%[.*)$');
    if not Name then return end;

    local Bar, Rest = Body:match('^%[(.-)%]%s*(.*)$');
    if not Bar then return end;

    local Word = Bar:find('%a') and Bar:match('^%s*(.-)%s*$');
    local Percent = Rest:match('^%((%d+)%%%)');
    local Message = Rest:gsub('^%(%d+%%%)', ''):gsub('^[%s%-]+', ''):gsub('(%d+%.%d%d)%d*s', '%1s');
    local Detail = Percent and (Message .. ' (' .. Percent .. '%)') or Message;

    local Kind = 'Info';
    if Word == 'SUCCESS' then
        Kind = 'Good';
    elseif Word and (Word:find('ERR') or Word:find('FAIL')) then
        Kind = 'Error';
    end;

    local Label = Name;
    if Name == 'Main Loader' then
        Label = 'Loader';
    elseif Name:match('^games%d+$') then
        Label = 'Game script';
    end;

    return {
        Text = Label .. ': ' .. Detail;
        Report = 'Luarmor ' .. Name .. ': ' .. Detail;
        Phase = (Word or '') .. (Percent or '') .. Message:gsub('%.+$', '');
        Kind = Kind;
    };
end;

function BootStrap:OpenConsole()
    local Ok, Visible = pcall(StarterGui.GetCore, StarterGui, 'DevConsoleVisible');
    if not Ok then return end;

    local DevConsole = CoreGui:FindFirstChild('DevConsoleMaster');
    if not Visible then
        local Hider;
        if DevConsole then
            DevConsole.Enabled = false;
        else
            Hider = CoreGui.ChildAdded:Connect(function(Child)
                if Child.Name == 'DevConsoleMaster' and Child:IsA('ScreenGui') then
                    Child.Enabled = false;
                end;
            end);
        end;

        local Opened = pcall(StarterGui.SetCore, StarterGui, 'DevConsoleVisible', true);
        DevConsole = Opened and (DevConsole or CoreGui:WaitForChild('DevConsoleMaster', 2)) or DevConsole;
        if Hider then Hider:Disconnect() end;

        if not Opened or not DevConsole then
            if Opened then pcall(StarterGui.SetCore, StarterGui, 'DevConsoleVisible', false) end;
            if DevConsole then DevConsole.Enabled = true end;
            return;
        end;

        DevConsole.Enabled = false;
        self.HidingConsole = true;
    elseif not DevConsole then
        return;
    end;
    self.DevConsole = DevConsole;

    local ClientLog;
    local Deadline = os.clock() + 1;
    repeat
        ClientLog = DevConsole:FindFirstChild('ClientLog', true);
        if not ClientLog then task.wait(0.05) end;
    until ClientLog or os.clock() > Deadline;
    if not ClientLog then return end;

    for _, Child in next, ClientLog:GetChildren() do
        self.RowStart = math.max(self.RowStart, tonumber(Child.Name) or 0);
    end;
end;

function BootStrap:CloseConsole()
    if not self.HidingConsole then return end;
    self.HidingConsole = false;
    pcall(StarterGui.SetCore, StarterGui, 'DevConsoleVisible', false);
    self.DevConsole.Enabled = true;
end;

function BootStrap:ReadConsole()
    if not self.DevConsole then return end;

    if self.HidingConsole then
        local Ok, Visible = pcall(StarterGui.GetCore, StarterGui, 'DevConsoleVisible');
        if Ok and not Visible then
            self.HidingConsole = false;
            self.DevConsole.Enabled = true;
            return;
        end;
    end;

    local ClientLog = self.DevConsole:FindFirstChild('ClientLog', true);
    if not ClientLog then return end;

    local Newest = 0;
    for _, Child in next, ClientLog:GetChildren() do
        local Index = tonumber(Child.Name);
        local Message = Index and Index > self.RowStart and Child:FindFirstChild('msg');
        local Row = Message and ReadRow(Message.Text);
        if Row then
            self:UpdateRow(Index, Row);
            if Index > Newest then
                Newest = Index;
                self.Pending = Row.Kind == 'Info' and Row.Text or nil;
            end;
        end;
    end;
end;

function BootStrap:Step()
    self.LastStep = os.clock();
    if self.Stalled then
        self.Stalled = false;
        self.Status.TextColor3 = self.Colors.Accent;
        self.Status.Text = self.StatusText;
    end;
end;

function BootStrap:SetStatus(Text)
    if self.Finished then return end;
    Text = tostring(Text or '');
    self:Step();
    if Text == self.StatusText then return end;
    self.StatusText = Text;
    self.Status.Text = Text;
    self:Log(Text);
end;

function BootStrap:SetDetails(Text)
    self:Log(Text);
end;

function BootStrap:SetProgress(Value)
    if self.Finished then return end;
    Value = math.clamp(tonumber(Value) or 0, 0, 100);
    self.Progress = Value;
    self:Step();
    TweenService:Create(self.BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(Value / 100, 1);
    }):Play();
    self.Percent.Text = string.format('%d%%', math.floor(Value + 0.5));
end;

function BootStrap:CopyReport()
    local Executor = 'Unknown';
    pcall(function() Executor = identifyexecutor(); end);

    local Report = {
        'ZekeHub loader report';
        'Time: ' .. os.date('!%Y-%m-%d %H:%M:%S UTC');
        'PlaceId: ' .. tostring(game.PlaceId) .. ' | GameId: ' .. tostring(game.GameId) .. ' | JobId: ' .. tostring(game.JobId);
        'Executor: ' .. tostring(Executor);
        'Status: ' .. self.StatusText .. ' (' .. math.floor(self.Progress) .. '%)';
        '';
    };
    for _, Line in next, self.Lines do
        table.insert(Report, Line);
    end;

    if pcall(setclipboard, table.concat(Report, '\n')) then
        self.CopyButton.Text = 'Copied';
        task.delay(1.5, function() self.CopyButton.Text = 'Copy log'; end);
    end;
end;

function BootStrap:ShowCopy(Color)
    self.CopyButton.Visible = true;
    self.CopyButton.TextColor3 = Color;
end;

function BootStrap:ToggleMinimize()
    if self.Finished then return end;
    self.Minimized = not self.Minimized;
    self.Section.Visible = not self.Minimized;
    TweenService:Create(self.Outer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(self.Width, self.Minimized and 30 or self.FullHeight);
    }):Play();
end;

function BootStrap:Finish(Text)
    if self.Finished then return end;
    self:SetProgress(100);
    self:SetStatus(Text or 'Loaded');
    task.delay(0.5, function() self:Destroy(); end);
end;

function BootStrap:Fail(Title, Body)
    if self.Finished then return end;
    self.Failed = true;
    local Red = self.Colors.Error;
    self.Status.TextColor3 = Red;
    self.Percent.TextColor3 = Red;
    self.BarFill.BackgroundColor3 = Red;
    self.StatusText = Title or 'Failed';
    self.Status.Text = self.StatusText;
    self:Record(self.StatusText, 'Error');
    if Body then self:Log(Body, 'Error'); end;
    self:ShowCopy(Red);
    self:CloseConsole();
end;

function BootStrap:Destroy()
    if self.Finished then return end;
    self.Finished = true;
    getgenv().BootStrap = nil;
    self:CloseConsole();

    for _, Connection in next, self.Connections do
        Connection:Disconnect();
    end;

    local Outer = self.Outer;
    if not Outer then return end;

    TweenService:Create(Outer, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play();
    for _, Child in next, Outer:GetDescendants() do
        if Child:IsA('TextLabel') or Child:IsA('TextButton') then
            TweenService:Create(Child, TweenInfo.new(0.2), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play();
        elseif Child:IsA('ScrollingFrame') then
            Child.ScrollBarImageTransparency = 1;
        elseif Child:IsA('Frame') then
            TweenService:Create(Child, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play();
        elseif Child:IsA('UIStroke') then
            TweenService:Create(Child, TweenInfo.new(0.2), { Transparency = 1 }):Play();
        end;
    end;

    task.delay(0.3, function()
        if self.ScreenGui then self.ScreenGui:Destroy(); end;
    end);
end;

function BootStrap:Trace(Line)
    Line = Line:match('^%s*(.-)%s*$');
    if Line == '' or Line == 'Stack Begin' or Line == 'Stack End' or self.TraceCount >= TraceLines then return end;
    self.TraceCount = self.TraceCount + 1;
    self:Record('    ' .. Line:sub(1, 160));
end;

table.insert(BootStrap.Connections, LogService.MessageOut:Connect(function(Message, Type)
    if BootStrap.Finished then return end;

    if Type == Enum.MessageType.MessageInfo and BootStrap.Tracing then
        if Message:find('Stack End', 1, true) then
            BootStrap.Tracing = false;
        else
            BootStrap:Trace(Message);
        end;
        return;
    end;

    if BootStrap.Seen[Message] then return end;

    local Kind;
    if Type == Enum.MessageType.MessageError then
        Kind = 'Error';
    elseif Type == Enum.MessageType.MessageWarning and Message:find('Infinite yield possible', 1, true) then
        Kind = 'Warn';
    end;
    if not Kind then
        BootStrap.Tracing = false;
        return;
    end;

    BootStrap.Seen[Message] = true;
    BootStrap.Tracing = true;
    BootStrap.TraceCount = 0;

    local First = true;
    for Line in Message:gmatch('[^\n]+') do
        if First then
            BootStrap:Record(Line:sub(1, 160), Kind);
            First = false;
        else
            BootStrap:Trace(Line);
        end;
    end;
end));

task.spawn(function()
    if NotAllowed then 
        BootStrap:Log('Skipping this step because you are using a Real/Wave executor. It causes a crash when loading.', 'Warn');
    else
        pcall(BootStrap.OpenConsole, BootStrap);
    end;

    while not BootStrap.Finished do
        task.wait(0.2);
        if BootStrap.Finished then break end;

        if BootStrap.Progress >= 60 then
            BootStrap:CloseConsole();
        end;
        pcall(BootStrap.ReadConsole, BootStrap);

        if not BootStrap.Failed and not BootStrap.Stalled and os.clock() - BootStrap.LastStep >= StallSeconds then
            if BootStrap.Progress >= 60 then
                BootStrap:Finish('Loaded');
                break;
            end;

            local Where = BootStrap.Pending or BootStrap.StatusText;
            BootStrap.Stalled = true;
            BootStrap.Status.TextColor3 = BootStrap.Colors.Warn;
            BootStrap.Status.Text = 'Stuck: ' .. Where;
            BootStrap:Record(string.format('No progress for %ds at "%s"', StallSeconds, Where), 'Warn');
            BootStrap:Log('Press Copy log and send it in a ticket.', 'Warn');
            BootStrap:ShowCopy(BootStrap.Colors.Warn);
            BootStrap:CloseConsole();
        end;
    end;
end);

getgenv().BootStrap = BootStrap;
return BootStrap;
