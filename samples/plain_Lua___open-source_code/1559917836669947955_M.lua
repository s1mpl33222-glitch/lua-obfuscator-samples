------------- CREDITS -------------

--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.6.62  |  2025-12-09  |  Roblox UI Library for scripts
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Footagesus ( Footages, .ftgs, oftgs )
    Github: https://github.com/Footagesus/WindUI
    Discord: https://discord.gg/ftgs-development-hub-1300692552005189632
    License: MIT
    
    ████████╗████████╗░░░░░██╗██╗░░░██╗  ░██████╗████████╗██╗░░░██╗██████╗░██╗░█████╗░
    ╚══██╔══╝╚══██╔══╝░░░░░██║╚██╗░██╔╝  ██╔════╝╚══██╔══╝██║░░░██║██╔══██╗██║██╔══██╗
    ░░░██║░░░░░░██║░░░░░░░░██║░╚████╔╝░  ╚█████╗░░░░██║░░░██║░░░██║██║░░██║██║██║░░██║
    ░░░██║░░░░░░██║░░░██╗░░██║░░╚██╔╝░░  ░╚═══██╗░░░██║░░░██║░░░██║██║░░██║██║██║░░██║
    ░░░██║░░░░░░██║░░░╚█████╔╝░░░██║░░░  ██████╔╝░░░██║░░░╚██████╔╝██████╔╝██║╚█████╔╝
    ░░░╚═╝░░░░░░╚═╝░░░░╚════╝░░░░╚═╝░░░  ╚═════╝░░░░╚═╝░░░░╚═════╝░╚═════╝░╚═╝░╚════╝░

    v3.0.2  |  2026-07-16  |  Roblox Script
    
    Author: TTJY Studio
    Github: https://github.com/Yumiara/SSL-TTJY
    Discord: https://discord.gg/G7CX2rD9p2
    License: ND ( No Derivatives )
    
     _____ ____  
     |_   _|  _ \ 
       | | | |_) |
       | | |  _ < 
      _| |_| |_) |
     |_____|____/ 
              
    v1  |  2025-07-06  | Code Obfuscator & Optimizer
    
    Author: dr_breen
    Github: https://github.com/7Duser/ironbrew1
    License: ND ( No Derivatives )
    
     █████╗ ██╗   ██╗████████╗██╗  ██╗  ██████╗
    ██╔══██╗██║   ██║╚══██╔══╝██║  ██║  ╚════██╗
    ███████║██║   ██║   ██║   ███████║   █████╔╝
    ██╔══██║██║   ██║   ██║   ██╔══██║   ╚═══██╗
    ██║  ██║╚██████╔╝   ██║   ██║  ██║  ██████╔╝
    ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝  ╚═════╝

    v3.4.1  |  2025-XX-XX  | Private Whitelist Service

    Author: TTJY
    License: ND ( No Derivatives )
    
    ▒█▀▀█ ░█▀▀█ ▒█▄░▒█ ▒█▀▀▄ ░█▀▀█ 　 ▒█▀▀▄ ▒█▀▀▀ ▒█░░▒█ ▒█▀▀▀ ▒█░░░ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▄▀█ ▒█▀▀▀ ▒█▄░▒█ ▀▀█▀▀ 
    ▒█▄▄█ ▒█▄▄█ ▒█▒█▒█ ▒█░▒█ ▒█▄▄█ 　 ▒█░▒█ ▒█▀▀▀ ░▒█▒█░ ▒█▀▀▀ ▒█░░░ ▒█░░▒█ ▒█▄▄█ ▒█▒█▒█ ▒█▀▀▀ ▒█▒█▒█ ░▒█░░ 
    ▒█░░░ ▒█░▒█ ▒█░░▀█ ▒█▄▄▀ ▒█░▒█ 　 ▒█▄▄▀ ▒█▄▄▄ ░░▀▄▀░ ▒█▄▄▄ ▒█▄▄█ ▒█▄▄▄█ ▒█░░░ ▒█░░▒█ ▒█▄▄▄ ▒█░░▀█ ░▒█░░

    v3  |  2025-03-16  | Public Whitelist Service

    Author: Pelican Development
    Official Site: https://pandadevelopment.net/
]]

if not game:IsLoaded() then game.Loaded:Wait(); end;
-- debug.setmemorycategory("CoreMemory") --

local Kicks, KickReason, GG = {
    ["TTJY_IDAC"] = "[TTJY Studio] : Failed to bypass.\nPlease contact TTJY.",
    ["TTJY_IDGG"] = "[TTJY Studio] : Global variable not found.\nPlease change executor.",
    ["TTJY_IDFL"] = "[TTJY Studio] : File system not found.\nPlease change executor.",
    ["ID500:V"]   = "[TTJY Studio] : Please rejoin to take another step to our Authentication.",
    ["TTJY_ID7"]  = "[TTJY Studio] : Executor environment is not standard. Please try again or switch to a different executor.\n\n<font size=\"14\">Join our Discord server for recommendations or to report bugs.</font>",
    ["TTJY_IDVC"] = "[TTJY Studio] : VCache Failed.",
    ["TTJY_IDP"]  = "[TTJY Studio] : You are in public server but you set the script to auto leave public servers.";
    ["TTJY_SolD"] = "[TTJY Studio] : Compatibility with Solara has been removed.\n\n<font size=\"14\">( You can get a free executor at https://projectreal.gg/ )</font>",
    ["TTJY_INFO"] = "[TTJY Studio] : getinfo not found. Please change executor.",
    ["TTJY_IDXO"] = "Your executor is '<b>Xeno</b>'. Imagine using a virus.\n\nAnyway, This executor isn't supported.\n\n<font size=\"14\">Visit ttjy-studio.vercel.app to see the list of supported executors.</font>",
    ["TheMimicCOUNT9R1"] = "[TTJY Studio] : The Mimic Script has been temporary shutdown for Hall Of Fame update. \n\n<font size=\"14\">Visit our discord server for more info.</font>"
}, nil, (getgenv and getgenv()) or _G or shared;

game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(v)
	if v.Name == "ErrorPrompt" then
		Instance.new("UICorner", v);
		local MessageArea = v:WaitForChild("MessageArea");
		local ErrorFrame = MessageArea:WaitForChild("ErrorFrame");
        local ButtonArea = ErrorFrame:WaitForChild("ButtonArea");
        local LeaveButton = ButtonArea:FindFirstChildWhichIsA("ImageButton");
        if not LeaveButton then
            repeat
                LeaveButton = ButtonArea:FindFirstChildWhichIsA("ImageButton");
                task.wait(0.1);
            until LeaveButton;
        end;
        local ButtonLayout = ButtonArea:WaitForChild("ButtonLayout");
        local ErrorMessage = ErrorFrame:WaitForChild("ErrorMessage");
        local Cloned = LeaveButton:Clone();
		v.BackgroundTransparency = 0.2; v.BackgroundColor3 = Color3.fromRGB(0,0,0);
        Cloned.Name = "DiscordInvite"; Cloned.ButtonText.Text = "Discord Invite";
        ButtonLayout.CellSize = UDim2.new(0,150,0,36); Cloned.Parent = ButtonArea;
        Cloned.MouseButton1Click:Connect(function()
            return setclipboard and setclipboard("https://discord.gg/G7CX2rD9p2");
        end); task.delay(0.2, function()
            for i,v in pairs(Kicks) do
                if string.find(ErrorMessage.Text, i) then
                    ErrorMessage.RichText=true;
                    ErrorMessage.Text = v;
                end;
            end;
        end);
	end;
end);

if not GG then
    KickReason="TTJY_IDGG";
elseif not isfile or not makefolder or not readfile or not isfolder or not delfile then
    KickReason="TTJY_IDFL";
elseif getexecutorname and getexecutorname() == "Solara" then
    KickReason="TTJY_SolD";
elseif not getinfo and not debug.getinfo then
    KickReason="TTJY_INFO";
end; if KickReason then
    return game:GetService("Players").LocalPlayer:Kick(KickReason);
end; GG.GG = GG;

local GameId, PlaceId = game.GameId, game.PlaceId;

local LoaderSettings = GG.LoaderSettings or {
    UIKeybind = "V";

    ESPMode = "Box";
    FPSCap = 60;
    BadNetwork = false;
    AllowCache = true;
    ScaryAC = false;

    AllowClientTab = true; 
    AllowAddOn = false; 
    AllowThemesTab = false;
    AllowESPCustomization = true;

    SkipBypass = false;
    GAME_DEBUG_POSITION = "BottomLeft";
};

LoaderSettings.SensitivePackage = LoaderSettings.SensitivePackage or {
    AllowQueue = true;
    AllowEConsole = false;
    AllowHighlightESP = false;
};

if GameId == 2294168059 then
    LoaderSettings.TheMimicLoader = LoaderSettings.TheMimicLoader or {
        Load_Sections = true;
        Load_WithPlaceID_Check = false;
    };
elseif GameId == 1235188606 then
    LoaderSettings.DragonAdventure = LoaderSettings.DragonAdventure or {
        RoamInitOnStartUp = false;
    };
elseif GameId == 10200395747 then
    LoaderSettings.GAG2Loader = LoaderSettings.GAG2Loader or {
        Allow_TPBypass = true;
    };
elseif GameId == 1701518532 then
    LoaderSettings.BadNetwork = true;
    LoaderSettings.ScaryAC = true;
    LoaderSettings.SkipBypass = false;
elseif GameId == 5995470825 then
    LoaderSettings.BadNetwork = true;
    LoaderSettings.ScaryAC = true;
    LoaderSettings.ScaryAC2 = false;
elseif GameId == 1831550657 then
    LoaderSettings.CreatureOfSonaria = LoaderSettings.CreatureOfSonaria or {
        PlayersPersistent = false;
        FoodsPersistent = false;
        NPCsPersistent = false;
    };
end;

if GG.LSecureLoad then
    return GG.LSecureLoad();
elseif GG.InKey then
    return GG.InKey();
end;

local FOLBASE = "TTJYStudio";
local EULBASE = "TJYsEula.txt";
local GITBASE = "https://github.com/RealTTJY/Studio.Hub/raw/refs/heads/main";
local ASSETBASE = "https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/Assets/";

local versionstorage, AssetStorage = {}, {};
local emptyfunction = function() return; end;
local selffucntion = function(...) return ...; end;

GG.IB_NO_VIRTUALIZE = function(...) return ...; end;
GG.LPH_NO_VIRTUALIZE = function(...) return ...; end;

local _, HttpGet = pcall(function() return game.HttpGet; end);
local cloneref = cloneref or clonereference or selffucntion;
local getinfo = getinfo or debug.getinfo;
local Request = http_request or request;
local setc = setclipboard or toclipboard;

local str = string;
local strfind = str.find;
local strformat = str.format;
local tble = table;
local tblef = tble.find;
local tblein = tble.insert;
local tk = task;
local twait = tk.wait;
local tspawn = tk.spawn;
local Col3 = Color3;
local fromRGB = Col3.fromRGB;

local Dim = UDim.new;
local Fnew = Font.new;
local Dim2 = UDim2.new;
local Rectn = Rect.new;
local CFr = CFrame.new;
local Vec2 = Vector2.new;
local Vec3 = Vector3.new;
local TwInfo = TweenInfo.new;
local Instancen = Instance.new;
local NSnew = NumberSequence.new;
local NSKnew = NumberSequenceKeypoint.new;

local GetService = game.GetService;
local FindFirstChild = game.FindFirstChild;

local TweenService = GetService(game, "TweenService");
local HttpService = GetService(game, "HttpService");
local UIS = GetService(game, "UserInputService");
local Workspace = cloneref(GetService(game, "Workspace"));
local CoreGui = cloneref(GetService(game, "CoreGui"));
local Players = GetService(game, "Players");

local selff = Players.LocalPlayer;

local IsA = game.IsA;
local TwCreate = TweenService.Create;

local gethui = gethui or function() return CoreGui end;

local WHITE = fromRGB(255, 255, 255);
local BLACK = fromRGB(0, 0, 0);

local ScriptCache = {};
ScriptCache.userIdentify = {
    is_loaded_lc = false;
    device = nil;
    is_Internal = nil;
    is_executor_WhiteList = nil;
    gcF = false;
    unc_infos = false;
}; ScriptCache.gcF = {};
ScriptCache.AutoConfigPathCache = {};

ScriptCache.userIdentify.device = if UIS.TouchEnabled and not UIS.KeyboardEnabled then "Mobile"
elseif UIS.KeyboardEnabled and UIS.MouseEnabled then "PC"
elseif UIS.GamepadEnabled then "Console"
else "Unknown"

ScriptCache.userIdentify.unc_infos = {
    fireproximityprompt = (fireproximityprompt and getinfo(fireproximityprompt).what) or false;
    firetouchinterest = (firetouchinterest and getinfo(firetouchinterest).what) or false;
    isnetworkowner = (isnetworkowner and getinfo(isnetworkowner).what) or false;
    require = (require and getinfo(require).what) or false;
    request = (Request and getinfo(Request).what) or false;
    getgc = (getgc and getinfo(getgc).what) or false;
};

local LoadFromVControl = nil; LoadFromVControl = function(srcName, fileName, selectversion, check)
    local cacheFile = "TTJYStudio/" .. tostring(fileName);
    if LoaderSettings.AllowCache then
        if isfile(cacheFile) then
            local success, func = pcall(function()
                return loadstring(readfile(cacheFile))();
            end); if success then
                if func and typeof(func) == 'table' then
                    if func.Version == selectversion then
                        if check then return true; end;
                        return func.Function;
                    elseif versionstorage[selectversion] then
                        if check then return false; end;
                        return LoadFromVControl(unpack(versionstorage[selectversion]));
                    end;
                end;
            end;
        end;
    end;
    
    if check then return false; end;
    local source = HttpGet(game, srcName);    
    local loadc = loadstring(source)();

    if loadc and typeof(loadc) == 'table' then
        if loadc.Version == selectversion then
            if LoaderSettings.AllowCache then
                writefile(cacheFile, source);
            end; return loadc.Function;
        elseif versionstorage[selectversion] then
            return LoadFromVControl(unpack(versionstorage[selectversion]));
        end;
    end; return selff:Kick("TTJY_IDVC");
end;

if not Signal then
    local Signal = {}; Signal.__index = Signal;
    
    function Signal.new()
        return setmetatable({listeners = {}}, Signal);
    end;
    function Signal:Connect(callback)
        local connection = {
            callback = callback,
            signal = self,
            connected = true,
        }; function connection:Disconnect()
            if not self.connected then return; end;
            self.connected = false;
            local listeners = self.signal.listeners;
            local index = tblef(listeners, self);
            if index then
                tble.remove(listeners, index);
            end;
        end; tblein(self.listeners, connection);
        return connection;
    end;
    function Signal:Wait()
        local connection = nil;
        local runningThread = coroutine.running();
        connection = self:Connect(function(...)
            connection:Disconnect();
            tspawn(runningThread, ...);
        end); return coroutine.yield();
    end;
    function Signal:Once(callback)
        local connection = nil;
        connection = self:Connect(function(...)
            connection:Disconnect();
            callback(...);
        end); return connection;
    end;
    function Signal:Fire(...)
        local currentListeners = {unpack(self.listeners)};
        for _, listener in ipairs(currentListeners) do
            if listener.connected then
                tspawn(listener.callback, ...);
            end;
        end;
    end; GG.Signal = Signal;
end;

------------- New Loader -------------

if not LoaderSettings.BadNetwork then
    if not isfolder(FOLBASE) then makefolder(FOLBASE); end;
    if not isfile(FOLBASE.."/TTJYStudio.png") then
        local pngfile = Request({
            Url = GITBASE.."/Assets/TTJYStudio.png";
            Method = "GET";
        }); if pngfile.Success then
            writefile(FOLBASE.."/TTJYStudio.png", pngfile.Body);
        end;
    end;
end;

local TTJYLogo = if not LoaderSettings.BadNetwork and isfile(FOLBASE.."/TTJYStudio.png") then
    getcustomasset(FOLBASE.."/TTJYStudio.png")
else "";

do (function()
    local TWEENINFO = TwInfo(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local TWEENINFO2 = TwInfo(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
    local TWEENINFO3 = TwInfo(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local TWEENINFO4 = TwInfo(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
    local VEC05 = Vec2(0.5, 0.5);

    local ScreenGui = Instancen("ScreenGui");
    local MainFrame = Instancen("Frame", ScreenGui);
    local ContentContainer = Instancen("Frame", MainFrame);
    local Logo = Instancen("ImageLabel", ContentContainer);
    local Cross = Instancen("TextLabel", ContentContainer);
    local LeftText = Instancen("TextLabel", ContentContainer);
    local RightText = Instancen("TextLabel", ContentContainer);
    local Subtitle = Instancen("TextLabel", ContentContainer);
    local BarContainer = Instancen("Frame", ContentContainer);
    local Bar = Instancen("Frame", BarContainer);
    local BarGlow = Instancen("UIStroke", Bar);

    ScreenGui.Name = "TTJY_Startup";
    ScreenGui.DisplayOrder = 9999;
    ScreenGui.IgnoreGuiInset = true;
    MainFrame.Name = "MainFrame";
    MainFrame.Size = Dim2(1, 0, 1, 0);
    MainFrame.BackgroundColor3 = fromRGB(15, 15, 15);
    MainFrame.BackgroundTransparency = 1;
    MainFrame.BorderSizePixel = 0;
    ContentContainer.Name = "Content";
    ContentContainer.Size = Dim2(0, 400, 0, 300);
    ContentContainer.AnchorPoint = VEC05;
    ContentContainer.Position = Dim2(0.5, 0, 0.45, 0);
    ContentContainer.BackgroundTransparency = 1;
    Logo.Name = "Logo";
    Logo.Size = Dim2(0, 0, 0, 0);
    Logo.AnchorPoint = VEC05;
    Logo.Position = Dim2(0.5, 0, 0.7, 0);
    Logo.BackgroundTransparency = 1;
    Logo.Image = TTJYLogo;

    Cross.Name = "Cross";
    Cross.Size = Dim2(0, 50, 0, 50);
    Cross.AnchorPoint = VEC05;
    Cross.Position = Dim2(0.5, 0, 0.9, 0);
    Cross.BackgroundTransparency = 1;
    Cross.Font = Enum.Font.GothamBold;
    Cross.Text = "X";
    Cross.TextColor3 = WHITE;
    Cross.TextSize = 0;
    Cross.TextTransparency = 1;

    LeftText.Name = "LeftText";
    LeftText.Size = Dim2(0, 150, 0, 50);
    LeftText.AnchorPoint = VEC05;
    LeftText.Position = Dim2(0.5, 0, 0.7, 0);
    LeftText.BackgroundTransparency = 1;
    LeftText.Font = Enum.Font.GothamBold;
    LeftText.Text = "TTJY Studio";
    LeftText.TextColor3 = WHITE;
    LeftText.TextSize = 24;
    LeftText.TextTransparency = 1;

    RightText.Name = "RightText";
    RightText.Size = Dim2(0, 150, 0, 50);
    RightText.AnchorPoint = VEC05;
    RightText.Position = Dim2(0.5, 0, 0.7, 0);
    RightText.BackgroundTransparency = 1;
    RightText.Font = Enum.Font.GothamBold;
    RightText.Text = "JYRS T";
    RightText.TextColor3 = WHITE;
    RightText.TextSize = 24;
    RightText.TextTransparency = 1;

    Subtitle.Name = "Subtitle";
    Subtitle.Size = Dim2(1, 0, 0, 20);
    Subtitle.Position = Dim2(0, 0, 0.95, 0);
    Subtitle.BackgroundTransparency = 1;
    Subtitle.Font = Enum.Font.GothamMedium;
    Subtitle.Text = "Script Made By TTJY Studio";
    Subtitle.TextColor3 = fromRGB(150, 150, 150);
    Subtitle.TextSize = 14;
    Subtitle.TextTransparency = 1;
    BarContainer.Name = "BarContainer";
    BarContainer.Size = Dim2(0, 300, 0, 2);
    BarContainer.Position = Dim2(0.5, 0, 0.9, 0);
    BarContainer.AnchorPoint = VEC05;
    BarContainer.BackgroundColor3 = fromRGB(150, 150, 150);
    BarContainer.BackgroundTransparency = 0.8;
    BarContainer.BorderSizePixel = 0;
    Bar.Name = "Bar";
    Bar.Size = Dim2(0, 0, 1, 0);
    Bar.BackgroundColor3 = fromRGB(230, 30, 30);
    Bar.BorderSizePixel = 0;
    BarGlow.Color = fromRGB(230, 30, 30);
    BarGlow.Thickness = 2;
    BarGlow.Transparency = 0.5;
    ScreenGui.Parent = gethui();

    local FadeObjects, cProgress, VisTween = {
        {Logo, "ImageTransparency"},

        {Subtitle, "TextTransparency"},
        {BarContainer, "BackgroundTransparency"},
        {Bar, "BackgroundTransparency"},
        {BarGlow, "Transparency"},
    }, 0, {};
    
    local tween = function(obj, info, props)
        local T = TwCreate(TweenService, obj, info, props);
        return T, T:Play();
    end;

    local setVisibility, updateProgress = function(visible)
        for i = 1, #VisTween do VisTween[i]:Cancel(); end;
        local targetTransparency = if visible then 0 else 1;
        VisTween = {}; for i = 1, #FadeObjects do
            local obj, prop = unpack(FadeObjects[i]);
            local value; if obj == BarContainer then
                value = visible and 0.8 or 1;
            elseif obj == Bar then
                value = visible and 0 or 1;
            else
                value = targetTransparency;
            end; tblein(VisTween, tween(obj, TWEENINFO, {
                [prop] = value
            }));
        end;
    end, function(percent)
        cProgress = math.clamp(percent, 0, 100);
        tween(Bar, TWEENINFO, {Size = Dim2(cProgress / 100, 0, 1, 0)});
    end;

    GG.LoadingSignal = Signal.new();
    GG.LoadingSignal:Connect(function(data)
        if type(data) == "number" then
            updateProgress(data);
        elseif type(data) == "boolean" then
            setVisibility(not data);
        elseif type(data) == 'string' then
            Subtitle.Text = data;
        end;
    end);

    tspawn(function()
        twait(0.2);
        tween(BarContainer, TWEENINFO, {BackgroundTransparency = 0.8});
        tween(BarGlow, TWEENINFO, {Transparency = 0.5}); 
        
        tspawn(function()
            for i = 1, 30 do
                if cProgress >= i then continue; end;
                updateProgress(i); twait(0.05 + (i * 0.002));
            end;
        end);

        twait(0.6);
        tween(Cross, TwInfo(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = Dim2(0.5, 0, 0.7, 0),
            TextSize = 60,
            TextTransparency = 0,
            Rotation = 360
        }); twait(1.2);
        tween(LeftText, TwInfo(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = Dim2(0.25, 0, 0.7, 0),
            TextTransparency = 0
        });
        tween(RightText, TwInfo(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = Dim2(0.75, 0, 0.7, 0),
            TextTransparency = 0
        }); twait(1.5);
        tween(LeftText, TwInfo(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = Dim2(0.5, 0, 0.7, 0),
            TextTransparency = 1
        });
        tween(RightText, TwInfo(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = Dim2(0.5, 0, 0.7, 0),
            TextTransparency = 1
        }); twait(0.4);
        tween(Cross, TwInfo(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Rotation = 720,
            TextSize = 0,
            TextTransparency = 1
        }); twait(0.4);
        Logo.Position = Dim2(0.5, 0, 0.7, 0);
        tween(Logo, TWEENINFO2, {
            Size = Dim2(0, 150, 0, 150)
        }); twait(1.2); twait(0.3); 
        tween(Subtitle, TWEENINFO3, {TextTransparency = 0});
        twait(0.2);

        local pulse = tween(Logo, TWEENINFO4, {
            Size = Dim2(0, 160, 0, 160),
        }); 
        
        repeat twait(0.1) until cProgress >= 90;
        twait(0.5); pulse:Cancel(); setVisibility(false); twait(0.6); ScreenGui:Destroy();
    end);
end)(); end;

------------- MainPackage -------------

AssetStorage.CommonF = function()
    local DistanceFromCharacter = selff.DistanceFromCharacter;
    local OriginalTw, VIM = TwInfo(
        1,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    ), nil;

    return {
        Init = function(defineVIM)
            VIM = defineVIM;
        end;
        SKey = function(key)
            warn("SKEY HAS", tostring(getthreadidentity()));
            return VIM:SendKeyEvent(true, key, false, game);
        end;
        OKey = function(key)
            warn("OKEY HAS", tostring(getthreadidentity()));
            return VIM:SendKeyEvent(false, key, false, game);
        end;
        CKey = function(self, key, c)
            warn("CKEY HAS", tostring(getthreadidentity()));
            return self.SKey(key), twait(c or 0), self.OKey(key);
        end;
        Tp = function(HumRSelf, cf, t)
            if not HumRSelf then return; end;
            HumRSelf.CFrame = cf;
            return true, twait(t);
        end;
        Tween = function(arg)
            if not arg.primary then return false; end;
            local Tween = TwCreate(
                TweenService, arg.primary,
                arg.info or OriginalTw, arg.goal
            ); Tween:Play();
            return Tween, Tween.Completed:Wait();
        end;
        Anchored = function(HumRSelf, bool)
            if not HumRSelf.Parent then return; end;
            HumRSelf.Anchored = bool;
        end;
        GetSeat = function(HumSelf)
            return HumSelf and HumSelf.SeatPart;
        end;
        HumanoidEquip = function(HumSelf, tool)
            return HumSelf and HumSelf:EquipTool(tool);
        end;
        findPrompt = function(tbl, condition)
            for _, v in pairs(tbl) do
                if IsA(v, "ProximityPrompt") and condition(v) then
                    return v;
                end;
            end;
        end;
        dist = function(position)
            return DistanceFromCharacter(selff, position);
        end;
        distOf = function(part1, part2, distance)
            if part1 and IsA(part1, "BasePart") and part2 and IsA(part2, "BasePart") then
                local part1Position = part1.Position;
                local part2Position = part2.Position;
                local partDistance = (part1Position - part2Position).Magnitude;
                return partDistance <= distance;
            else
                return false;
            end;
        end;
    };
end;
AssetStorage.ClientPackage = function()
    local L = GetService(game, "Lighting");
    local ExposureCompensation = L.ExposureCompensation;
    local FloatResolvePos = CFr(0, -3.1, 0);
    local FloatPartParent = Workspace;
    local FloatPart = Instancen("Part");
    FloatPart.Name = "selcRootX";
    FloatPart.Anchored = true;
    FloatPart.Transparency = 1;
    FloatPart.Size = Vec3(2, 0.2, 1.5);
    FloatPart.Material = Enum.Material.Grass;

    local SavedHumSelf, WalkSpeed = nil, 16;
    local WalkSpeedConnection, savedHumanoid = nil, nil;

    return {
        ChangeFloatParent = function(instance)
            FloatPartParent = instance;
        end;
        UpdatePosition = function(config, isForce, HumRSelf)
            if not HumRSelf then return; end;
            if config or isForce == true then
                if FloatPart.Parent ~= FloatPartParent then FloatPart.Parent = FloatPartParent; end;
                FloatPart.CFrame = HumRSelf.CFrame * FloatResolvePos;
            elseif not config or isForce == false then
                if FloatPart.Parent ~= nil then FloatPart.Parent = nil; end;
            end;
        end;
        Noclip = function(config, childs)
            if not config or not childs or #childs == 0 then return; end;
            for i=1, #childs do
                local v = childs[i]; if IsA(v, "BasePart") and v.Name ~= "bobber" then
                    v.CanCollide = false;
                end;
            end;
        end;
        Brightness = function(config)
            if not config then
                if L.ExposureCompensation ~= ExposureCompensation then
                    L.ExposureCompensation = ExposureCompensation;
                end;
                return;
            end; if L.ExposureCompensation ~= 2 then
                L.ExposureCompensation = 2;
            end;
        end;
        WalkSpeedC = function(self, newHumanoid)
            if not newHumanoid then return; end;
            self.WalkSpeedDC();
            savedHumanoid = newHumanoid;
            WalkSpeedConnection = newHumanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if not EnabledWalkSpeed or newHumanoid.WalkSpeed == WalkSpeed then return; end;
                newHumanoid.WalkSpeed = WalkSpeed;
            end);
            if EnabledWalkSpeed and WalkSpeed then
                newHumanoid.WalkSpeed = WalkSpeed;
            end;
        end;
        SetWalkSpeed = function(number)
            WalkSpeed = number; if EnabledWalkSpeed and savedHumanoid then
                savedHumanoid.WalkSpeed = WalkSpeed;
            end;
        end;
        RunWalkSpeed = function(bool)
            EnabledWalkSpeed = bool; 
            if EnabledWalkSpeed and savedHumanoid and WalkSpeed then
                savedHumanoid.WalkSpeed = WalkSpeed; 
            end;
        end;
        WalkSpeedDC = function()
            if WalkSpeedConnection then
                WalkSpeedConnection:Disconnect();
                WalkSpeedConnection = nil;
            end;
        end;
        SetJumpPower = function(config, power, HumSelf)
            if not config or not HumSelf then
                if HumSelf and HumSelf.JumpPower ~= 50 then
                    HumSelf.JumpPower = 50;
                end; return;
            end; 
            if HumSelf.JumpPower ~= power then HumSelf.JumpPower = power; end;
            if not HumSelf.UseJumpPower then HumSelf.UseJumpPower = true; end;
        end;
    };
end;
AssetStorage.PromptPackage = function()
    local ProximityPromptService = GetService(game, "ProximityPromptService");
    local IsPause, originalUNC, prompts = false, fireproximityprompt, {};
    local Validationtbl, CFR004 = {}, CFr(0,0,-4);
    local Validator = selffucntion;
    local Validation = function(prompt)
        if Validationtbl[prompt] then
            return false;
        end; return Validator(prompt);
    end;

    local Prompts = {}; ProximityPromptService.PromptShown:Connect(function(v)
        if not Validation(v) or not GG.Configs then return; end;
        if not Prompts[v] then Prompts[v] = v.HoldDuration; end;
        if GG.Configs.Client.Client["InstantPrompt"] and not IsPause then
            v.HoldDuration = 0;
        else
            v.HoldDuration = Prompts[v];
        end;
    end);

    return {
        UpdateState = function(state) IsPause = state; end;
        ValidateRule = function(prompt, isblock)
            Validationtbl[prompt] = isblock;
        end;
        Validator = function(newf)
            Validator = newf or selfucntion;
        end;
    };
end;
AssetStorage.ESPPackage = function()
    local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
    local DIM1010 = Dim2(1, 0, 1, 0);
    local mmax = math.max;
    local mmin = math.min;

    local BoundingBoxOffsets = {
        Vec3(-1, -1, -1),
        Vec3(-1, -1,  1),
        Vec3(-1,  1, -1),
        Vec3(-1,  1,  1),
        Vec3( 1, -1, -1),
        Vec3( 1, -1,  1),
        Vec3( 1,  1, -1),
        Vec3( 1,  1,  1),
    };

    local Original, Classes = {
        Depth = Enum.HighlightDepthMode.AlwaysOnTop;
        WHITE = WHITE;
        RED = fromRGB(255, 0, 0);
        VEC5 = Vec3(5,5,5);
        Method = "Box";
    }, {}; GG.ESPObjects = Classes;

    local function ResolveParent(obj, isBasepartOnly)
        if not obj or not obj.Parent then return; end;

        local Resolved = nil;
        if IsA(obj, "Model") then
            if isBasepartOnly then
                Resolved = obj.PrimaryPart;
                Resolved = Resolved or FindFirstChildWhichIsA(obj, "BasePart");
            else
                Resolved = obj;
            end;
        elseif IsA(obj, "BasePart") then
            Resolved = obj;
        end; return Resolved;
    end;
    local function GetBound(obj, Cam)
        local ReadCF, ReadSi = nil, nil;
        if IsA(obj, "Model") then
            ReadCF, ReadSi = obj:GetBoundingBox();
        else
            ReadCF = obj.CFrame;
            ReadSi = obj.Size;
        end;

        if not ReadCF or not ReadSi then
            return nil,nil,false;
        end;

        local Half = ReadSi/2;
        local MinX, MinY = 1e5, 1e5;
        local MaxX, MaxY = -1e5, -1e5;
        local Visible = false;

        for i = 1, 8 do
            local ScreenPos, OnScreen = Cam:WorldToViewportPoint(ReadCF * (Half * BoundingBoxOffsets[i]));
            if OnScreen then
                Visible = true;

                MinX = mmin(MinX, ScreenPos.X);
                MinY = mmin(MinY, ScreenPos.Y);

                MaxX = mmax(MaxX, ScreenPos.X);
                MaxY = mmax(MaxY, ScreenPos.Y);
            end;
        end;

        if not Visible then
            return nil, nil, false;
        end;

        return Vec2(MaxX-MinX, MaxY-MinY), Vec2(MinX, MinY), Visible;
    end;
    local function CreateBox(parent, config, Data)
        local Box = Instancen("BoxHandleAdornment", if config.NoStart then nil else parent);
        Box.Color3 = config.Color;
        Box.AlwaysOnTop = true;
        Box.Size = config.Size;
        Box.Transparency = 0.5;
        Box.Adornee = parent;
        Box.ZIndex = 1;

        local Billboard = Instancen("BillboardGui");
        Billboard.StudsOffset = Vec3(0, config.Size.Y/2 + 1, 0);
        Billboard.Size = Dim2(0, 100, 0, 30);
        Billboard.AlwaysOnTop = true;
        Billboard.Adornee = parent;

        local Label = Instancen("TextLabel", Billboard);
        Label.Font = Enum.Font.SourceSansBold;
        Label.TextStrokeTransparency = 0.2;
        Label.BackgroundTransparency = 1;
        Label.TextColor3 = config.Color;
        Label.Size = DIM1010;
        Label.Text = config.Text;
        Label.TextScaled = true;

        if not config.BoxOnly and not config.NoStart then
            Billboard.Parent = parent;
        end;

        Data.Box = Box;
        Data.Billboard = Billboard;
        Data.Label = Label;
        Data.Destroy = function()
            Box:Destroy();
            Label:Destroy();
            Billboard:Destroy();
            Data.Box = nil;
            Data.Billboard = nil;
            Data.Label = nil;
        end;
        Data.SetVisibility = function(bool, allowBill)
            if not parent.Parent then pcall(Data.Destroy); return; end;
            
            local ShouldEmergencyClear = pcall(function()
                Box.Parent = if bool then parent else nil;
                Billboard.Parent = if bool and allowBill then parent else nil;
            end); 
            
            if not ShouldEmergencyClear then
                Data.Box = nil;
                Data.Billboard = nil;
                Data.Label = nil;
            end;
        end;
        Data.UpdateColor = function(color)
            Box.Color3 = color;
            Label.TextColor3 = color;
        end;
    end;
    local function CreateHighlight(parent, config, Data)
        local Highlight = Instancen("Highlight", if config.NoStart then nil else parent);
        Highlight.Adornee = parent;
        Highlight.FillColor = config.Color;
        Highlight.OutlineColor = config.OutlineColor or Original.WHITE;
        Highlight.DepthMode = config.Depth or Original.Depth;

        local Billboard = Instancen("BillboardGui");
        Billboard.StudsOffset = Vec3(0, config.Size.Y/2 + 1, 0);
        Billboard.Size = Dim2(0, 100, 0, 30);
        Billboard.AlwaysOnTop = true;
        Billboard.Adornee = parent;

        local Label = Instancen("TextLabel", Billboard);
        Label.Font = Enum.Font.SourceSansBold;
        Label.TextStrokeTransparency = 0.2;
        Label.BackgroundTransparency = 1;
        Label.TextColor3 = config.Color;
        Label.Size = DIM1010;
        Label.Text = config.Text;
        Label.TextScaled = true;

        if not config.BoxOnly and not config.NoStart then
            Billboard.Parent = parent;
        end;

        Data.Label = Label;
        Data.Billboard = Billboard;
        Data.Highlight = Highlight;
        Data.Destroy = function()
            Highlight:Destroy();
            Label:Destroy();
            Billboard:Destroy();
            Data.Billboard = nil;
            Data.Highlight = nil;
        end;
        Data.SetVisibility = function(bool, allowBill)
            if not parent.Parent then pcall(Data.Destroy); return; end;
            
            local ShouldEmergencyClear = pcall(function()
                Highlight.Parent = if bool then parent else nil;
                Billboard.Parent = if bool and allowBill then parent else nil;
                Highlight.Enabled = bool;
            end); 
            
            if not ShouldEmergencyClear then
                Data.Highlight = nil;
                Data.Billboard = nil;
                Data.Label = nil;
            end;
        end;
        Data.UpdateColor = function(color)
            Highlight.FillColor = color;
            Label.TextColor3 = color;
        end;
    end;
    local function Create2D(parent, config, Data)
        local Outline = Drawing.new("Square");
        Outline.Thickness = 3;
        Outline.Filled = false;
        Outline.Visible = false;
        Outline.Transparency = 1;
        Outline.Color = config.OutlineColor or config.Color or Original.WHITE;

        local Fill = Drawing.new("Square");
        Fill.Thickness = 1;
        Fill.Filled = false;
        Fill.Visible = false;
        Fill.Transparency = 1;
        Fill.Color = config.Color;

        local ForceInvis = false;

        Data.Fill = Fill;
        Data.Outline = Outline;
        Data.SetVisibility = function(bool)
            Outline.Visible = bool;
            Fill.Visible = bool;
            ForceInvis = if not bool then true else false;
        end;
        Data.Destroy = function()
            Outline:Remove();
            Fill:Remove();
            Data.Outline = nil;
            Data.Fill = nil;
        end;
        Data.Visualize = function(self, Camera)
            if not parent or not parent.Parent then
                return self.Destroy();
            end;

            local Size, Position, Visible = GetBound(parent, Camera);
            if ForceInvis or not Visible then
                Outline.Visible = false;
                Fill.Visible = false;
                return;
            end;

            Outline.Visible = true;
            Fill.Visible = true;

            Outline.Size = Size;
            Outline.Position = Position;

            Fill.Size = Size;
            Fill.Position = Position;
        end;
        Data.UpdateColor = function(color)
            Outline.Color = color;
            Fill.Color = color;
        end;
    end;

    local CachedUData = nil;
    local AttachedConfig = {};

    local AttachConfig = function(pt,rp)
        pt = (rp and rp ~= "") and (rp .. "/" .. pt) or pt;
        if AttachedConfig[pt] then
            return AttachedConfig[pt];
        end; local Splited = str.split(pt,"/");
        local FullPath = GG.Configs;
        for i,v in pairs(Splited) do
            FullPath = FullPath[v];
            if FullPath == nil then
                return nil;
            end;
        end; AttachedConfig[pt]=FullPath;
        return FullPath;
    end
    
    local UpdateConfig = function(pt, state, rp)
        pt = (rp and rp ~= "") and (rp .. "/" .. pt) or pt;
        AttachedConfig[pt] = state;
        local Splited = str.split(pt,"/");
        local lastKey = Splited[#Splited];
        local len = #Splited - 1;
        local t = GG.Configs;
        for i = 1, len do
            t = t[ Splited[i] ];
        end; t[lastKey] = state;
    end;

    return {
        ESP = function(Class, Object, config)
            if typeof(Object) ~= 'Instance' then return; end;
            if not Classes[Class] then Classes[Class] = setmetatable({}, { __mode = "k" }); end;

            local OldData = Classes[Class][Object]; if OldData then
                if OldData.Mode == (config.Method or Original.Method) then
                    return OldData;
                end; OldData.Destroy();
            end; OldData = nil;

            config = config or {};
            config.Color = config.Color or Original.WHITE;
            config.Size = config.Size or Original.VEC5;
            config.Text = config.Text or "-";
            config.NoStart = config.NoStart or false;

            local Method = config.Method or Original.Method;
            local NewData = {Object = Object, Mode=Method};
            local Parent = ResolveParent(
                Object,
                config.isBasepartOnly
            ); if not Parent then return; end;
            
            if Method == "Box" then
                CreateBox(Parent, config, NewData);
            elseif Method == "Highlight" then
                CreateHighlight(Parent, config, NewData);
            elseif Method == "2D" then
                Create2D(Parent, config, NewData);
            end;

            Classes[Class][Object] = NewData;
            
            return NewData;
        end;
        Visible = function(Class, bool, allowBill)
            local TargetClass = Classes[Class];
            if not TargetClass then return; end;
            for i,v in pairs(TargetClass) do
                if not i or not i.Parent then
                    v.Destroy();
                else
                    v.SetVisibility(bool, allowBill);
                end;
            end;
        end;
        Scale = function(Class, bool)
            local TargetClass = Classes[Class];
            if not TargetClass then return; end;
            for i,v in pairs(TargetClass) do
                if i and i.Parent then
                    if v.Label then
                        v.Label.TextScaled = bool;
                    end;
                end;
            end;
        end;
        Size = function(Class, size)
            local TargetClass = Classes[Class];
            if not TargetClass then return; end;
            for i,v in pairs(TargetClass) do
                if i and i.Parent then
                    if v.Label then
                        v.Label.TextSize = size;
                    end;
                end;
            end;
        end;
        Color = function(Class, color)
            local TargetClass = Classes[Class];
            if not TargetClass then return; end;
            for i,v in pairs(TargetClass) do
                if i and i.Parent then
                    if v.UpdateColor then
                        v.UpdateColor(color);
                    end;
                end;
            end;
        end;
        Method = function(new)
            Original.Method = new;
        end;
        DynamicU = function(self, Windy, tab, data)
            if not tab or not Windy then return; end;

            CachedUData = nil; if not CachedUData then
                CachedUData = {}; for i=1, #data do
                    local head=data[i]; if head.Title then
                        CachedUData[i] = {
                            {type="Group", dats={
                                {dat={
                                    {type="Toggle", EN="Show Text", EN2="Show object's text", TH1="แสดงข้อความ", TH2="แสดงข้อความบนวัตถุนั้นๆ", Bindable="+", Path=head.TextPath},
                                    {type="Slider", EN="Text Size", EN2="Change object's text size", TH1="ขนาดข้อความ", TH2="แก้ไขขนาดข้อความที่อยู่บนวัตถุ", Value={Min=1, Max=20}, Path=head.SizePath},
                                    {type="Toggle", EN="Text Scale", EN2="Automatic object's text size", TH1="สเกลข้อความ", TH2="อัพเดตขนาดข้อความอัตโนมัติ", Path=head.ScalePath},
                                    {type="Colorpicker", EN="Text Color", EN2="Change object's text color", TH1="สีข้อความ", TH2="แก้ไขสีข้อความที่อยู่บนวัตถุ", Path=head.ColorPath},
                                }, Title=head.Title};
                            }}; {type="Space"}; {type="Space"};
                        };

                        Windy:CreateComponent(tab, CachedUData[i], head.Pointer);
                    end;
                end;
            end;
        end;
    };
end;
AssetStorage.CirclePackage = function()
    local Dim2Off = UDim2.fromOffset;
    local Circle = {}; Circle.__index = Circle;
    local gui = Instancen("ScreenGui", gethui());
    gui.Name = "TTJY_Hub_Circle";
    gui.IgnoreGuiInset = true;
    function Circle:new(radius)
        local self = setmetatable({}, Circle)
        local frame = Instancen("Frame", gui);
        frame.Size = Dim2Off(radius * 2, radius * 2);
        frame.Position = Dim2Off(0, 0);
        frame.AnchorPoint = Vec2(0.5, 0.5);
        frame.BackgroundTransparency = 1;
        frame.Visible = true;
        frame.Parent = gui;
        local corner = Instancen("UICorner", frame);
        corner.CornerRadius = Dim(1, 0);
        local stroke = Instancen("UIStroke", frame);
        stroke.Thickness = 2;
        stroke.Color = Col3.new(1, 1, 1);
        stroke.Transparency = 0;
        stroke.Parent = frame;
        self._frame = frame;
        self._stroke = stroke;
        self.Radius = radius;
        self.Visible = true;
        return self
    end; function Circle:SetPosition(vec2:Vector2): nil
        self._frame.Position = Dim2Off(vec2.X, vec2.Y);
    end; function Circle:SetRadius(r)
        self.Radius = r;
        self._frame.Size = Dim2Off(r * 2, r * 2);
    end; function Circle:SetColor(col)
        self._stroke.Color = col;
    end; function Circle:SetThickness(t)
        self._stroke.Thickness = t;
    end;function Circle:SetVisible(v)
        self.Visible = v;
        self._frame.Visible = v;
    end; function Circle:Remove()
        self._frame:Destroy();
    end; return Circle;
end;
AssetStorage.CoruTask = function()
    local coru = coroutine;
    local corus = coru.status;
    local corur = coru.resume;
    local coruc = coru.create;
    local coruy = coru.yield;
    local suspendedRoute, Routines = {}, {};
    return {
        New = function(name, fn)
            if not Routines[name] then Routines[name] = coruc(fn); end;
        end;
        Handle = function(m)
            if not suspendedRoute[m] then return; end;
            if corus(Routines[m]) == 'suspended' then
                suspendedRoute[m] = nil;
                return corur(Routines[m]);
            end;
        end;
        Close = function(name)
            suspendedRoute[name] = true; return coruy(Routines[name]);
        end;
        APC = function(str, fn, pids, rfn)
            if str == "if not in" then
                if not tblef(pids, PlaceId) then
                    if fn[rfn] then
                        fn[rfn] = nil;
                    end;
                end;
            elseif tblef(pids, PlaceId) then
                if fn[rfn] then
                    fn[rfn] = nil;
                end;
            end;
        end;
        Init = function(WindUI)
            for name, v in pairs(Routines) do
                twait(0.2); if WindUI then
                    WindUI:Notify({
                        Title = "<font color='rgb(255, 0, 0)'>Thread</font>",
                        Content = "New thread has been added to Script Core: " .. name .. "\n" .. tostring(v),
                        Icon = "circle-alert",
                        Duration = 10,
                    });
                end; corur(v);
            end; coruc = nil; coru = nil;
        end;
    };
end;
AssetStorage.QueuePack = function()
    local queueonteleport = queue_on_teleport or queueonteleport;
    local serialize = nil; serialize = function(tbl, indent)
        indent = indent or ""
        local result = "{\n"
        for k,v in pairs(tbl) do
            local key = (type(k) == "string") and strformat("[%q]", k) or "["..tostring(k).."]";
            if type(v) == "table" then
                result ..= indent.."    "..key.." = "..serialize(v, indent.."    ")..";\n";
            elseif type(v) == "string" then
                result ..= indent.."    "..key.." = "..strformat("%q", v)..";\n";
            else
                result ..= indent.."    "..key.." = "..tostring(v)..";\n";
            end;
        end; result ..= indent.."}";
        return result;
    end;
    
    local QUEUE_INFO = {};
    local src = [[getgenv().QUEUE_INFO = {]];

    return {
        SetInfo = function(i,v)
            QUEUE_INFO[i] = v;
        end;
        Init = function()
            for k, v in pairs(QUEUE_INFO) do
                src ..= ("[%q] = %q;"):format(tostring(k), tostring(v));
            end; src ..= [[}]];

            src ..= "getgenv().Configs = " .. serialize(GG.Configs);
            src ..= "getgenv().LoaderSettings = " .. serialize(GG.LoaderSettings);

            src ..= 'loadstring(game:HttpGet("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/APIs/M.lua"))()';
            queueonteleport(src);
        end;
    };
end;

------------- KeyUI -------------

AssetStorage.KeyPackage = function()
    local NICEPARENT = gethui();

    local CROP = Enum.ScaleType.Crop;
    local SLICE = Enum.ScaleType.Slice;
    local AUTO_Y = Enum.AutomaticSize.Y;
    local AUTO_X = Enum.AutomaticSize.X;
    local AutoXY = Enum.AutomaticSize.XY;
    local ENUMSCREENONE = Enum.ScreenInsets.None;
    local LAYOUTORDER = Enum.SortOrder.LayoutOrder;
    local ENUMZISEBEHAVIOR = Enum.ZIndexBehavior.Sibling;
    local VERTICALCENTER = Enum.VerticalAlignment.Center;
    local FILL_HOR = Enum.FillDirection.Horizontal;
    local HOR_CENTER = Enum.HorizontalAlignment.Center;
    local HOR_RIGHT = Enum.HorizontalAlignment.Right;
    local TEXTX_LEFT = Enum.TextXAlignment.Left;
    local FONTW_MED = Enum.FontWeight.Medium;
    local FONTW_SEMI = Enum.FontWeight.SemiBold;
    local FONTS_NORM = Enum.FontStyle.Normal;
    local EASE_QUAD = Enum.EasingStyle.Quad;
    local EASE_OUT = Enum.EasingDirection.Out;
    local EASE_IN = Enum.EasingDirection.In;
    local AUTO_NONE = Enum.AutomaticSize.None;

    local RECTN521 = Rectn(512, 512, 512, 512);
    local RECTN256 = Rectn(256, 256, 256, 256);
    local DIM1010 = Dim2(1, 0, 1, 0);
    local DIM05 = Dim2(0.5, 0, 0.5, 0);
    local VEC05 = Vec2(0.5, 0.5);
    local COL_1 = fromRGB(25, 25, 28);
    
    local FONT121 = Fnew("rbxassetid://12187365364", FONTW_SEMI, FONTS_NORM);
    local IMG809 = "rbxassetid://80999662900595";
    local IMG117 = "rbxassetid://117788349049947";
    local IMGSHA = "rbxassetid://84825982946844";
    
    return {
        newCopy = function()
            local G2L = {};

            G2L["1"]                            = Instancen("ScreenGui", NICEPARENT);
                G2L["1"].IgnoreGuiInset         = true;
                G2L["1"].ScreenInsets           = ENUMSCREENONE;
                G2L["1"].Name                   = "MultiKey";
                G2L["1"].ZIndexBehavior         = ENUMZISEBEHAVIOR;
                G2L["1"].ResetOnSpawn           = false;
        
            G2L["2"]                            = Instancen("ImageLabel", G2L["1"]);
                G2L["2"].ZIndex                 = 9999;
                G2L["2"].BorderSizePixel        = 0;
                G2L["2"].SliceCenter            = RECTN256;
                G2L["2"].SliceScale             = 0.08594;
                G2L["2"].BackgroundColor3       = WHITE;
                G2L["2"].ScaleType              = SLICE;
                G2L["2"].AutomaticSize          = AutoXY;
                G2L["2"].ImageColor3            = COL_1;
                G2L["2"].AnchorPoint            = VEC05;
                G2L["2"].Image                  = IMG809;
                G2L["2"].BackgroundTransparency = 1;
                G2L["2"].Position               = DIM05;
        
            G2L["3"]                            = Instancen("Frame", G2L["2"]);
                G2L["3"].ZIndex                 = 99999;
                G2L["3"].BorderSizePixel        = 0;
                G2L["3"].BackgroundColor3       = COL_1;
                G2L["3"].AutomaticSize          = AUTO_Y;
                G2L["3"].Size                   = Dim2(0, 430, 0, 0);
                G2L["3"].BackgroundTransparency = 1;
        
            G2L["4"]                            = Instancen("UIPadding", G2L["3"]);
        
            G2L["5"]                            = Instancen("Frame", G2L["3"]);
                G2L["5"].BorderSizePixel        = 0;
                G2L["5"].BackgroundColor3       = WHITE;
                G2L["5"].Size                   = DIM1010;
                G2L["5"].BackgroundTransparency = 1;
        
            G2L["6"]                            = Instancen("Frame", G2L["5"]);
                G2L["6"].BorderSizePixel        = 0;
                G2L["6"].BackgroundColor3       = WHITE;
                G2L["6"].Size                   = DIM1010;
                G2L["6"].BackgroundTransparency = 1;
        
            G2L["7"]                            = Instancen("UIListLayout", G2L["6"]);
                G2L["7"].Padding                = Dim(0, 18);
                G2L["7"].SortOrder              = LAYOUTORDER;
        
            G2L["8"]                            = Instancen("Frame", G2L["6"]);
                G2L["8"].BorderSizePixel        = 0;
                G2L["8"].BackgroundColor3       = WHITE;
                G2L["8"].AutomaticSize          = AUTO_Y;
                G2L["8"].Size                   = Dim2(1, 0, 0, 0);
                G2L["8"].BackgroundTransparency = 1;
        
            G2L["9"]                            = Instancen("Frame", G2L["8"]);
                G2L["9"].BorderSizePixel        = 0;
                G2L["9"].BackgroundColor3       = WHITE;
                G2L["9"].AutomaticSize          = AutoXY;
                G2L["9"].BackgroundTransparency = 1;
        
            G2L.a                               = Instancen("UIListLayout", G2L["9"]);
                G2L.a.Padding                   = Dim(0, 14);
                G2L.a.VerticalAlignment         = VERTICALCENTER;
                G2L.a.SortOrder                 = LAYOUTORDER;
                G2L.a.FillDirection             = FILL_HOR;
        
            G2L.b                               = Instancen("Frame", G2L["9"]);
                G2L.b.BorderSizePixel           = 0;
                G2L.b.BackgroundColor3          = WHITE;
                G2L.b.Size                      = Dim2(0, 24, 0, 24);
                G2L.b.LayoutOrder               = -1;
                G2L.b.BackgroundTransparency    = 1;
        
            G2L.c                               = Instancen("ImageLabel", G2L.b);
                G2L.c.BorderSizePixel           = 0;
                G2L.c.BackgroundColor3          = WHITE;
                G2L.c.ScaleType                 = CROP;
                G2L.c.Image                     = "rbxassetid://77771201330939";
                G2L.c.ImageRectSize             = Vec2(96, 96);
                G2L.c.Size                      = DIM1010;
                G2L.c.BackgroundTransparency    = 1;
                G2L.c.ImageRectOffset           = Vec2(0, 768);
        
            G2L.d                               = Instancen("UICorner", G2L.c);
                G2L.d.CornerRadius              = Dim(0, 18);
        
            G2L.e                               = Instancen("TextLabel", G2L["9"]);
                G2L.e.BorderSizePixel           = 0;
                G2L.e.TextSize                  = 20;
                G2L.e.BackgroundColor3          = WHITE;
                G2L.e.FontFace                  = FONT121;
                G2L.e.TextColor3                = WHITE;
                G2L.e.BackgroundTransparency    = 1;
                G2L.e.RichText                  = true;
                G2L.e.Text                      = "Select Service";
                G2L.e.AutomaticSize             = AutoXY;
        
            G2L.f                               = Instancen("Frame", G2L["6"]);
                G2L.f.BorderSizePixel           = 0;
                G2L.f.BackgroundColor3          = WHITE;
                G2L.f.Size                      = Dim2(1, 0, 0, 42);
                G2L.f.BackgroundTransparency    = 1;
        
            G2L["10"]                           = Instancen("UIListLayout", G2L.f);
                G2L["10"].HorizontalAlignment   = HOR_CENTER;
                G2L["10"].Padding               = Dim(0, 9);
                G2L["10"].SortOrder             = LAYOUTORDER;
                G2L["10"].FillDirection         = FILL_HOR;

            G2L["11"]                           = Instancen("TextButton", G2L.f);
                G2L["11"].BorderSizePixel       = 0;
                G2L["11"].TextColor3            = WHITE;
                G2L["11"].AutoButtonColor       = false;
                G2L["11"].TextSize              = 14;
                G2L["11"].BackgroundColor3      = WHITE;
                G2L["11"].Size                  = Dim2(0.45, 0, 1, 0);
                G2L["11"].BackgroundTransparency= 1;
                G2L["11"].LayoutOrder           = 2;
                G2L["11"].Text                  = "";
                G2L["11"].Position              = Dim2(-0.00377, 0, 0, 0);
        
            G2L["12"]                           = Instancen("ImageLabel", G2L["11"]);
                G2L["12"].BorderSizePixel       = 0;
                G2L["12"].SliceCenter           = RECTN256;
                G2L["12"].SliceScale            = 0.03906;
                G2L["12"].BackgroundColor3      = WHITE;
                G2L["12"].ScaleType             = SLICE;
                G2L["12"].ImageTransparency     = 1;
                G2L["12"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["12"].Image                 = IMG809;
                G2L["12"].Size                  = DIM1010;
                G2L["12"].BackgroundTransparency= 1;
                G2L["12"].Name                  = "Squircle";
        
            G2L["13"]                           = Instancen("ImageLabel", G2L["11"]);
                G2L["13"].BorderSizePixel       = 0;
                G2L["13"].SliceCenter           = RECTN256;
                G2L["13"].SliceScale            = 0.03906;
                G2L["13"].BackgroundColor3      = WHITE;
                G2L["13"].ScaleType             = SLICE;
                G2L["13"].ImageTransparency     = 0.95;
                G2L["13"].Image                 = IMG809;
                G2L["13"].Size                  = DIM1010;
                G2L["13"].BackgroundTransparency= 1;
                G2L["13"].Name                  = "Special";
        
            G2L["14"]                           = Instancen("ImageLabel", G2L["11"]);
                G2L["14"].BorderSizePixel       = 0;
                G2L["14"].SliceCenter           = RECTN521;
                G2L["14"].SliceScale            = 0.01953;
                G2L["14"].BackgroundColor3      = WHITE;
                G2L["14"].ScaleType             = SLICE;
                G2L["14"].ImageColor3           = BLACK;
                G2L["14"].AnchorPoint           = VEC05;
                G2L["14"].Image                 = IMGSHA;
                G2L["14"].Size                  = Dim2(1, 3, 1, 3);
                G2L["14"].BackgroundTransparency= 1;
                G2L["14"].Name                  = "Shadow";
                G2L["14"].Position              = DIM05;
        
            G2L["15"]                           = Instancen("ImageLabel", G2L["11"]);
                G2L["15"].BorderSizePixel       = 0;
                G2L["15"].SliceCenter           = RECTN256;
                G2L["15"].SliceScale            = 0.03906;
                G2L["15"].BackgroundColor3      = WHITE;
                G2L["15"].ScaleType             = SLICE;
                G2L["15"].ImageTransparency     = 0.85;
                G2L["15"].Image                 = IMG117;
                G2L["15"].Size                  = DIM1010;
                G2L["15"].BackgroundTransparency= 1;
        
            G2L["16"]                           = Instancen("ImageLabel", G2L["11"]);
                G2L["16"].BorderSizePixel       = 0;
                G2L["16"].SliceCenter           = RECTN256;
                G2L["16"].SliceScale            = 0.03906;
                G2L["16"].BackgroundColor3      = WHITE;
                G2L["16"].ScaleType             = SLICE;
                G2L["16"].ImageTransparency     = 1;
                G2L["16"].Image                 = IMG809;
                G2L["16"].Size                  = DIM1010;
                G2L["16"].BackgroundTransparency= 1;
                G2L["16"].Name                  = "Frame";
        
            G2L["17"]                           = Instancen("UIPadding", G2L["16"]);
                G2L["17"].PaddingRight          = Dim(0, 12);
                G2L["17"].PaddingLeft           = Dim(0, 12);
        
            G2L["18"]                           = Instancen("UIListLayout", G2L["16"]);
                G2L["18"].HorizontalAlignment   = HOR_CENTER;
                G2L["18"].Padding               = Dim(0, 8);
                G2L["18"].VerticalAlignment     = VERTICALCENTER;
                G2L["18"].SortOrder             = LAYOUTORDER;
                G2L["18"].FillDirection         = FILL_HOR;
        
            G2L["19"]                           = Instancen("TextLabel", G2L["16"]);
                G2L["19"].BorderSizePixel       = 0;
                G2L["19"].TextSize              = 18;
                G2L["19"].BackgroundColor3      = WHITE;
                G2L["19"].FontFace              = FONT121;
                G2L["19"].TextColor3            = WHITE;
                G2L["19"].BackgroundTransparency= 1;
                G2L["19"].RichText              = true;
                G2L["19"].Text                  = "Linkvertise ( Key )";
                G2L["19"].AutomaticSize         = AutoXY;
        
            G2L["1a"]                           = Instancen("TextButton", G2L.f);
                G2L["1a"].BorderSizePixel       = 0;
                G2L["1a"].TextColor3            = WHITE;
                G2L["1a"].AutoButtonColor       = false;
                G2L["1a"].TextSize              = 14;
                G2L["1a"].BackgroundColor3      = WHITE;
                G2L["1a"].Size                  = Dim2(0.45, 0, 1, 0);
                G2L["1a"].BackgroundTransparency= 1;
                G2L["1a"].LayoutOrder           = 2;
                G2L["1a"].Text                  = "";
                G2L["1a"].Position              = Dim2(-0.00377, 0, 0, 0);
        
            G2L["1b"]                           = Instancen("ImageLabel", G2L["1a"]);
                G2L["1b"].BorderSizePixel       = 0;
                G2L["1b"].SliceCenter           = RECTN256;
                G2L["1b"].SliceScale            = 0.03906;
                G2L["1b"].BackgroundColor3      = WHITE;
                G2L["1b"].ScaleType             = SLICE;
                G2L["1b"].ImageTransparency     = 1;
                G2L["1b"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["1b"].Image                 = IMG809;
                G2L["1b"].Size                  = DIM1010;
                G2L["1b"].BackgroundTransparency= 1;
                G2L["1b"].Name                  = "Squircle";
        
            G2L["1c"]                           = Instancen("ImageLabel", G2L["1a"]);
                G2L["1c"].BorderSizePixel       = 0;
                G2L["1c"].SliceCenter           = RECTN256;
                G2L["1c"].SliceScale            = 0.03906;
                G2L["1c"].BackgroundColor3      = WHITE;
                G2L["1c"].ScaleType             = SLICE;
                G2L["1c"].ImageTransparency     = 0.95;
                G2L["1c"].Image                 = IMG809;
                G2L["1c"].Size                  = DIM1010;
                G2L["1c"].BackgroundTransparency = 1;
                G2L["1c"].Name                  = "Special";
        
            G2L["1d"]                           = Instancen("ImageLabel", G2L["1a"]);
                G2L["1d"].BorderSizePixel       = 0;
                G2L["1d"].SliceCenter           = RECTN521;
                G2L["1d"].SliceScale            = 0.01953;
                G2L["1d"].BackgroundColor3      = WHITE;
                G2L["1d"].ScaleType             = SLICE;
                G2L["1d"].ImageColor3           = BLACK;
                G2L["1d"].AnchorPoint           = VEC05;
                G2L["1d"].Image                 = IMGSHA;
                G2L["1d"].Size                  = Dim2(1, 3, 1, 3);
                G2L["1d"].BackgroundTransparency = 1;
                G2L["1d"].Name                  = "Shadow";
                G2L["1d"].Position              = DIM05;
        
            G2L["1e"]                           = Instancen("ImageLabel", G2L["1a"]);
                G2L["1e"].BorderSizePixel       = 0;
                G2L["1e"].SliceCenter           = RECTN256;
                G2L["1e"].SliceScale            = 0.03906;
                G2L["1e"].BackgroundColor3      = WHITE;
                G2L["1e"].ScaleType             = SLICE;
                G2L["1e"].ImageTransparency     = 0.85;
                G2L["1e"].Image                 = IMG117;
                G2L["1e"].Size                  = DIM1010;
                G2L["1e"].BackgroundTransparency = 1;
        
            G2L["1f"]                           = Instancen("ImageLabel", G2L["1a"]);
                G2L["1f"].BorderSizePixel       = 0;
                G2L["1f"].SliceCenter           = RECTN256;
                G2L["1f"].SliceScale            = 0.03906;
                G2L["1f"].BackgroundColor3      = WHITE;
                G2L["1f"].ScaleType             = SLICE;
                G2L["1f"].ImageTransparency     = 1;
                G2L["1f"].Image                 = IMG809;
                G2L["1f"].Size                  = DIM1010;
                G2L["1f"].BackgroundTransparency = 1;
                G2L["1f"].Name                  = "Frame";
        
            G2L["20"]                           = Instancen("UIPadding", G2L["1f"]);
                G2L["20"].PaddingRight          = Dim(0, 12);
                G2L["20"].PaddingLeft           = Dim(0, 12);
        
            G2L["21"]                           = Instancen("UIListLayout", G2L["1f"]);
                G2L["21"].HorizontalAlignment   = HOR_CENTER;
                G2L["21"].Padding               = Dim(0, 8);
                G2L["21"].VerticalAlignment     = VERTICALCENTER;
                G2L["21"].SortOrder             = LAYOUTORDER;
                G2L["21"].FillDirection         = FILL_HOR;
        
            G2L["22"]                           = Instancen("TextLabel", G2L["1f"]);
                G2L["22"].BorderSizePixel       = 0;
                G2L["22"].TextSize              = 18;
                G2L["22"].BackgroundColor3      = WHITE;
                G2L["22"].FontFace              = FONT121;
                G2L["22"].TextColor3            = WHITE;
                G2L["22"].BackgroundTransparency= 1;
                G2L["22"].RichText              = true;
                G2L["22"].Text                  = "Work.ink ( Key )";
                G2L["22"].AutomaticSize         = AutoXY;
        
            G2L["23"]                           = Instancen("UIPadding", G2L["6"]);
                G2L["23"].PaddingTop            = Dim(0, 16);
                G2L["23"].PaddingRight          = Dim(0, 16);
                G2L["23"].PaddingLeft           = Dim(0, 16);
                G2L["23"].PaddingBottom         = Dim(0, 16);
        
            G2L["24"]                           = Instancen("Frame", G2L["6"]);
                G2L["24"].BorderSizePixel       = 0;
                G2L["24"].BackgroundColor3      = WHITE;
                G2L["24"].Size                  = Dim2(1, 0, 0, 42);
                G2L["24"].LayoutOrder           = 100;
                G2L["24"].BackgroundTransparency= 1;
        
            G2L["25"]                           = Instancen("UIListLayout", G2L["24"]);
                G2L["25"].HorizontalAlignment   = HOR_RIGHT;
                G2L["25"].Padding               = Dim(0, 9);
                G2L["25"].SortOrder             = LAYOUTORDER;
                G2L["25"].FillDirection         = FILL_HOR;
        
            G2L["26"]                           = Instancen("TextButton", G2L["24"]);
                G2L["26"].BorderSizePixel       = 0;
                G2L["26"].TextColor3            = WHITE;
                G2L["26"].AutoButtonColor       = false;
                G2L["26"].TextSize              = 14;
                G2L["26"].BackgroundColor3      = WHITE;
                G2L["26"].AutomaticSize         = AUTO_X;
                G2L["26"].Size                  = Dim2(0, 0, 1, 0);
                G2L["26"].BackgroundTransparency= 1;
                G2L["26"].LayoutOrder           = 2;
                G2L["26"].Text                  = "";
        
            G2L["27"]                           = Instancen("ImageLabel", G2L["26"]);
                G2L["27"].BorderSizePixel       = 0;
                G2L["27"].SliceCenter           = RECTN256;
                G2L["27"].SliceScale            = 0.03906;
                G2L["27"].BackgroundColor3      = WHITE;
                G2L["27"].ScaleType             = SLICE;
                G2L["27"].ImageTransparency     = 1;
                G2L["27"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["27"].Image                 = IMG809;
                G2L["27"].Size                  = DIM1010;
                G2L["27"].BackgroundTransparency= 1;
                G2L["27"].Name                  = "Squircle";
        
            G2L["28"]                           = Instancen("ImageLabel", G2L["26"]);
                G2L["28"].BorderSizePixel       = 0;
                G2L["28"].SliceCenter           = RECTN256;
                G2L["28"].SliceScale            = 0.03906;
                G2L["28"].BackgroundColor3      = WHITE;
                G2L["28"].ScaleType             = SLICE;
                G2L["28"].ImageTransparency     = 0.95;
                G2L["28"].Image                 = IMG809;
                G2L["28"].Size                  = DIM1010;
                G2L["28"].BackgroundTransparency= 1;
                G2L["28"].Name                  = "Special";
        
            G2L["29"]                           = Instancen("ImageLabel", G2L["26"]);
                G2L["29"].BorderSizePixel       = 0;
                G2L["29"].SliceCenter           = RECTN521;
                G2L["29"].SliceScale            = 0.01953;
                G2L["29"].BackgroundColor3      = WHITE;
                G2L["29"].ScaleType             = SLICE;
                G2L["29"].ImageColor3           = BLACK;
                G2L["29"].AnchorPoint           = VEC05;
                G2L["29"].Image                 = IMGSHA;
                G2L["29"].Size                  = Dim2(1, 3, 1, 3);
                G2L["29"].BackgroundTransparency= 1;
                G2L["29"].Name                  = "Shadow";
                G2L["29"].Position              = DIM05;
        
            G2L["2a"]                           = Instancen("ImageLabel", G2L["26"]);
                G2L["2a"].BorderSizePixel       = 0;
                G2L["2a"].SliceCenter           = RECTN256;
                G2L["2a"].SliceScale            = 0.03906;
                G2L["2a"].BackgroundColor3      = WHITE;
                G2L["2a"].ScaleType             = SLICE;
                G2L["2a"].ImageTransparency     = 0.85;
                G2L["2a"].Image                 = IMG117;
                G2L["2a"].Size                  = DIM1010;
                G2L["2a"].BackgroundTransparency= 1;
        
            G2L["2b"]                           = Instancen("ImageLabel", G2L["26"]);
                G2L["2b"].BorderSizePixel       = 0;
                G2L["2b"].SliceCenter           = RECTN256;
                G2L["2b"].SliceScale            = 0.03906;
                G2L["2b"].BackgroundColor3      = WHITE;
                G2L["2b"].ScaleType             = SLICE;
                G2L["2b"].ImageTransparency     = 1;
                G2L["2b"].Image                 = IMG809;
                G2L["2b"].Size                  = DIM1010;
                G2L["2b"].BackgroundTransparency= 1;
                G2L["2b"].Name                  = "Frame";
        
            G2L["2c"]                           = Instancen("UIPadding", G2L["2b"]);
                G2L["2c"].PaddingRight          = Dim(0, 12);
                G2L["2c"].PaddingLeft           = Dim(0, 12);
        
            G2L["2d"]                           = Instancen("UIListLayout", G2L["2b"]);
                G2L["2d"].HorizontalAlignment   = HOR_CENTER;
                G2L["2d"].Padding               = Dim(0, 8);
                G2L["2d"].VerticalAlignment     = VERTICALCENTER;
                G2L["2d"].SortOrder             = LAYOUTORDER;
                G2L["2d"].FillDirection         = FILL_HOR;
        
            G2L["2e"]                           = Instancen("TextLabel", G2L["2b"]);
                G2L["2e"].BorderSizePixel       = 0;
                G2L["2e"].TextSize              = 18;
                G2L["2e"].BackgroundColor3      = WHITE;
                G2L["2e"].FontFace              = FONT121;
                G2L["2e"].TextColor3            = WHITE;
                G2L["2e"].BackgroundTransparency= 1;
                G2L["2e"].RichText              = true;
                G2L["2e"].Text                  = "Cancel";
                G2L["2e"].AutomaticSize         = AutoXY;
        
            G2L["2f"]                           = Instancen("Frame", G2L["6"]);
                G2L["2f"].BorderSizePixel       = 0;
                G2L["2f"].BackgroundColor3      = WHITE;
                G2L["2f"].Size                  = Dim2(1, 0, 0, 42);
                G2L["2f"].BackgroundTransparency= 1;
        
            G2L["30"]                           = Instancen("UIListLayout", G2L["2f"]);
                G2L["30"].HorizontalAlignment   = HOR_CENTER;
                G2L["30"].Padding               = Dim(0, 9);
                G2L["30"].SortOrder             = LAYOUTORDER;
                G2L["30"].FillDirection         = FILL_HOR;
        
            G2L["31"]                           = Instancen("TextButton", G2L["2f"]);
                G2L["31"].BorderSizePixel       = 0;
                G2L["31"].TextColor3            = WHITE;
                G2L["31"].AutoButtonColor       = false;
                G2L["31"].TextSize              = 14;
                G2L["31"].BackgroundColor3      = WHITE;
                G2L["31"].Size                  = Dim2(0.45, 0, 1, 0);
                G2L["31"].BackgroundTransparency= 1;
                G2L["31"].LayoutOrder           = 2;
                G2L["31"].Text                  = "";
                G2L["31"].Position              = Dim2(-0.00377, 0, 0, 0);
        
            G2L["32"]                           = Instancen("ImageLabel", G2L["31"]);
                G2L["32"].BorderSizePixel       = 0;
                G2L["32"].SliceCenter           = RECTN256;
                G2L["32"].SliceScale            = 0.03906;
                G2L["32"].BackgroundColor3      = WHITE;
                G2L["32"].ScaleType             = SLICE;
                G2L["32"].ImageTransparency     = 1;
                G2L["32"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["32"].Image                 = IMG809;
                G2L["32"].Size                  = DIM1010;
                G2L["32"].BackgroundTransparency= 1;
                G2L["32"].Name                  = "Squircle";
        
            G2L["33"]                           = Instancen("ImageLabel", G2L["31"]);
                G2L["33"].BorderSizePixel       = 0;
                G2L["33"].SliceCenter           = RECTN256;
                G2L["33"].SliceScale            = 0.03906;
                G2L["33"].BackgroundColor3      = WHITE;
                G2L["33"].ScaleType             = SLICE;
                G2L["33"].ImageTransparency     = 0.95;
                G2L["33"].Image                 = IMG809;
                G2L["33"].Size                  = DIM1010;
                G2L["33"].BackgroundTransparency= 1;
                G2L["33"].Name                  = "Special";
        
            G2L["34"]                           = Instancen("ImageLabel", G2L["31"]);
                G2L["34"].BorderSizePixel       = 0;
                G2L["34"].SliceCenter           = RECTN521;
                G2L["34"].SliceScale            = 0.01953;
                G2L["34"].BackgroundColor3      = WHITE;
                G2L["34"].ScaleType             = SLICE;
                G2L["34"].ImageColor3           = BLACK;
                G2L["34"].AnchorPoint           = VEC05;
                G2L["34"].Image                 = IMGSHA;
                G2L["34"].Size                  = Dim2(1, 3, 1, 3);
                G2L["34"].BackgroundTransparency= 1;
                G2L["34"].Name                  = "Shadow";
                G2L["34"].Position              = DIM05;
        
            G2L["35"]                           = Instancen("ImageLabel", G2L["31"]);
                G2L["35"].BorderSizePixel       = 0;
                G2L["35"].SliceCenter           = RECTN256;
                G2L["35"].SliceScale            = 0.03906;
                G2L["35"].BackgroundColor3      = WHITE;
                G2L["35"].ScaleType             = SLICE;
                G2L["35"].ImageTransparency     = 0.85;
                G2L["35"].Image                 = IMG117;
                G2L["35"].Size                  = DIM1010;
                G2L["35"].BackgroundTransparency= 1;
        
            G2L["36"]                           = Instancen("ImageLabel", G2L["31"]);
                G2L["36"].BorderSizePixel       = 0;
                G2L["36"].SliceCenter           = RECTN256;
                G2L["36"].SliceScale            = 0.03906;
                G2L["36"].BackgroundColor3      = WHITE;
                G2L["36"].ScaleType             = SLICE;
                G2L["36"].ImageTransparency     = 1;
                G2L["36"].Image                 = IMG809;
                G2L["36"].Size                  = DIM1010;
                G2L["36"].BackgroundTransparency= 1;
                G2L["36"].Name                  = "Frame";
        
            G2L["37"]                           = Instancen("UIPadding", G2L["36"]);
                G2L["37"].PaddingRight          = Dim(0, 12);
                G2L["37"].PaddingLeft           = Dim(0, 12);
        
            G2L["38"]                           = Instancen("UIListLayout", G2L["36"]);
                G2L["38"].HorizontalAlignment   = HOR_CENTER;
                G2L["38"].Padding               = Dim(0, 8);
                G2L["38"].VerticalAlignment     = VERTICALCENTER;
                G2L["38"].SortOrder             = LAYOUTORDER;
                G2L["38"].FillDirection         = FILL_HOR;
        
            G2L["39"]                           = Instancen("TextLabel", G2L["36"]);
                G2L["39"].BorderSizePixel       = 0;
                G2L["39"].TextSize              = 18;
                G2L["39"].BackgroundColor3      = WHITE;
                G2L["39"].FontFace              = FONT121;
                G2L["39"].TextColor3            = WHITE;
                G2L["39"].BackgroundTransparency= 1;
                G2L["39"].RichText              = true;
                G2L["39"].Text                  = "Common Fixes";
                G2L["39"].AutomaticSize         = AutoXY;
        
            G2L["3a"]                           = Instancen("TextButton", G2L["2f"]);
                G2L["3a"].BorderSizePixel       = 0;
                G2L["3a"].TextColor3            = WHITE;
                G2L["3a"].AutoButtonColor       = false;
                G2L["3a"].TextSize              = 14;
                G2L["3a"].BackgroundColor3      = WHITE;
                G2L["3a"].Size                  = Dim2(0.45, 0, 1, 0);
                G2L["3a"].BackgroundTransparency= 1;
                G2L["3a"].LayoutOrder           = 2;
                G2L["3a"].Text                  = "";
                G2L["3a"].Position              = Dim2(-0.00377, 0, 0, 0);
        
            G2L["3b"]                           = Instancen("ImageLabel", G2L["3a"]);
                G2L["3b"].BorderSizePixel       = 0;
                G2L["3b"].SliceCenter           = RECTN256;
                G2L["3b"].SliceScale            = 0.03906;
                G2L["3b"].BackgroundColor3      = WHITE;
                G2L["3b"].ScaleType             = SLICE;
                G2L["3b"].ImageTransparency     = 1;
                G2L["3b"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["3b"].Image                 = IMG809;
                G2L["3b"].Size                  = DIM1010;
                G2L["3b"].BackgroundTransparency= 1;
                G2L["3b"].Name                  = "Squircle";
        
            G2L["3c"]                           = Instancen("ImageLabel", G2L["3a"]);
                G2L["3c"].BorderSizePixel       = 0;
                G2L["3c"].SliceCenter           = RECTN256;
                G2L["3c"].SliceScale            = 0.03906;
                G2L["3c"].BackgroundColor3      = WHITE;
                G2L["3c"].ScaleType             = SLICE;
                G2L["3c"].ImageTransparency     = 0.95;
                G2L["3c"].Image                 = IMG809;
                G2L["3c"].Size                  = DIM1010;
                G2L["3c"].BackgroundTransparency= 1;
                G2L["3c"].Name                  = "Special";
        
            G2L["3d"]                           = Instancen("ImageLabel", G2L["3a"]);
                G2L["3d"].BorderSizePixel       = 0;
                G2L["3d"].SliceCenter           = RECTN521;
                G2L["3d"].SliceScale            = 0.01953;
                G2L["3d"].BackgroundColor3      = WHITE;
                G2L["3d"].ScaleType             = SLICE;
                G2L["3d"].ImageColor3           = BLACK;
                G2L["3d"].AnchorPoint           = VEC05;
                G2L["3d"].Image                 = IMGSHA;
                G2L["3d"].Size                  = Dim2(1, 3, 1, 3);
                G2L["3d"].BackgroundTransparency= 1;
                G2L["3d"].Name                  = "Shadow";
                G2L["3d"].Position              = DIM05;
        
            G2L["3e"]                           = Instancen("ImageLabel", G2L["3a"]);
                G2L["3e"].BorderSizePixel       = 0;
                G2L["3e"].SliceCenter           = RECTN256;
                G2L["3e"].SliceScale            = 0.03906;
                G2L["3e"].BackgroundColor3      = WHITE;
                G2L["3e"].ScaleType             = SLICE;
                G2L["3e"].ImageTransparency     = 0.85;
                G2L["3e"].Image                 = IMG117;
                G2L["3e"].Size                  = DIM1010;
                G2L["3e"].BackgroundTransparency= 1;
        
            G2L["3f"]                           = Instancen("ImageLabel", G2L["3a"]);
                G2L["3f"].BorderSizePixel       = 0;
                G2L["3f"].SliceCenter           = RECTN256;
                G2L["3f"].SliceScale            = 0.03906;
                G2L["3f"].BackgroundColor3      = WHITE;
                G2L["3f"].ScaleType             = SLICE;
                G2L["3f"].ImageTransparency     = 1;
                G2L["3f"].Image                 = IMG809;
                G2L["3f"].Size                  = DIM1010;
                G2L["3f"].BackgroundTransparency= 1;
                G2L["3f"].Name                  = "Frame";
        
            G2L["40"]                           = Instancen("UIPadding", G2L["3f"]);
                G2L["40"].PaddingRight          = Dim(0, 12);
                G2L["40"].PaddingLeft           = Dim(0, 12);
        
            G2L["41"]                           = Instancen("UIListLayout", G2L["3f"]);
                G2L["41"].HorizontalAlignment   = HOR_CENTER;
                G2L["41"].Padding               = Dim(0, 8);
                G2L["41"].VerticalAlignment     = VERTICALCENTER;
                G2L["41"].SortOrder             = LAYOUTORDER;
                G2L["41"].FillDirection         = FILL_HOR;
        
            G2L["42"]                           = Instancen("TextLabel", G2L["3f"]);
                G2L["42"].BorderSizePixel       = 0;
                G2L["42"].TextSize              = 18;
                G2L["42"].BackgroundColor3      = WHITE;
                G2L["42"].FontFace              = FONT121;
                G2L["42"].TextColor3            = WHITE;
                G2L["42"].BackgroundTransparency= 1;
                G2L["42"].RichText              = true;
                G2L["42"].Text                  = "Supported Executors";
                G2L["42"].AutomaticSize         = AutoXY;
        
            G2L["43"]                           = Instancen("UIScale", G2L["2"]);
        
            G2L["44"]                           = Instancen("ImageLabel", G2L["2"]);
                G2L["44"].BorderSizePixel       = 0;
                G2L["44"].SliceCenter           = RECTN256;
                G2L["44"].SliceScale            = 0.08594;
                G2L["44"].BackgroundColor3      = WHITE;
                G2L["44"].ScaleType             = SLICE;
                G2L["44"].ImageTransparency     = 0.9;
                G2L["44"].Image                 = IMG117;
                G2L["44"].Size                  = DIM1010;
                G2L["44"].BackgroundTransparency= 1;
        
            G2L["45"]                           = Instancen("UIGradient", G2L["44"]);
                G2L["45"].Rotation              = 90;
                G2L["45"].Transparency          = NSnew{NSKnew(0.000, 0),NSKnew(1.000, 1)};
        
            G2L["26"].Activated:Connect(function()
                G2L["1"]:Destroy(); G2L["1"] = nil;
                G2L = nil;
            end); G2L["11"].Activated:Connect(function()
                G2L["1"]:Destroy(); G2L["1"] = nil;
                G2L = nil;
                return setc("https://pandadevelopment.net/getkey/ttjyhub?hwid="..gethwid());
            end); G2L["1a"].Activated:Connect(function()
                G2L["1"]:Destroy(); G2L["1"] = nil;
                G2L = nil;
                return setc("https://pandadevelopment.net/getkey/ttjyhub?hwid="..gethwid());
            end); G2L["31"].Activated:Connect(function()
                G2L["1"]:Destroy(); G2L["1"] = nil;
                G2L = nil;
                return setc("https://ttjy-studio.vercel.app/bugs");
            end); G2L["3a"].Activated:Connect(function()
                G2L["1"]:Destroy(); G2L["1"] = nil;
                G2L = nil;
                return setc("https://ttjy-studio.vercel.app/scripts");
            end);
        
            return G2L;
        end;
        new = function(arg)
            local G2L = {};
            local tbl = {};
            local configu = {
                Auth = arg and arg.Auth or emptyfunction;
                GetKey = arg and arg.GetKey or emptyfunction;
            };
        
            local G2L = {};
        
            G2L["1"]                            = Instancen("ScreenGui", NICEPARENT);
                G2L["1"].IgnoreGuiInset         = true;
                G2L["1"].ScreenInsets           = ENUMSCREENONE;
                G2L["1"].Name                   = "FlowAuth";
                G2L["1"].ZIndexBehavior         = ENUMZISEBEHAVIOR;
                G2L["1"].ResetOnSpawn           = false;
            
            G2L["2"]                            = Instancen("ImageLabel", G2L["1"]);
                G2L["2"].ZIndex                 = 9999;
                G2L["2"].BorderSizePixel        = 0;
                G2L["2"].SliceCenter            = RECTN256;
                G2L["2"].SliceScale             = 0.08594;
                G2L["2"].BackgroundColor3       = WHITE;
                G2L["2"].ScaleType              = SLICE;
                G2L["2"].AutomaticSize          = AutoXY;
                G2L["2"].ImageColor3            = COL_1;
                G2L["2"].AnchorPoint            = VEC05;
                G2L["2"].Image                  = IMG809;
                G2L["2"].BackgroundTransparency = 1;
                G2L["2"].Position               = DIM05;
            
            G2L["3"]                            = Instancen("Frame", G2L["2"]);
                G2L["3"].ZIndex                 = 99999;
                G2L["3"].BorderSizePixel        = 0;
                G2L["3"].BackgroundColor3       = COL_1;
                G2L["3"].AutomaticSize          = AUTO_Y;
                G2L["3"].Size                   = Dim2(0, 430, 0, 0);
                G2L["3"].BackgroundTransparency = 1;
            
            G2L["4"]                            = Instancen("UIPadding", G2L["3"]);
            
            G2L["5"]                            = Instancen("Frame", G2L["3"]);
                G2L["5"].BorderSizePixel        = 0;
                G2L["5"].BackgroundColor3       = WHITE;
                G2L["5"].Size                   = DIM1010;
                G2L["5"].BackgroundTransparency = 1;
            
            G2L["6"]                            = Instancen("Frame", G2L["5"]);
                G2L["6"].BorderSizePixel        = 0;
                G2L["6"].BackgroundColor3       = WHITE;
                G2L["6"].Size                   = DIM1010;
                G2L["6"].BackgroundTransparency = 1;
            
            G2L["7"]                            = Instancen("UIListLayout", G2L["6"]);
                G2L["7"].Padding                = Dim(0, 18);
                G2L["7"].SortOrder              = LAYOUTORDER;
            
            G2L["8"]                            = Instancen("Frame", G2L["6"]);
                G2L["8"].BorderSizePixel        = 0;
                G2L["8"].BackgroundColor3       = WHITE;
                G2L["8"].AutomaticSize          = AUTO_Y;
                G2L["8"].Size                   = Dim2(1, 0, 0, 0);
                G2L["8"].BackgroundTransparency = 1;
        
            
            G2L["9"]                            = Instancen("Frame", G2L["8"]);
                G2L["9"].BorderSizePixel        = 0;
                G2L["9"].BackgroundColor3       = WHITE;
                G2L["9"].AutomaticSize          = AutoXY;
                G2L["9"].BackgroundTransparency = 1;
            
            G2L.a                               = Instancen("UIListLayout", G2L["9"]);
                G2L.a.Padding                   = Dim(0, 14);
                G2L.a.VerticalAlignment         = VERTICALCENTER;
                G2L.a.SortOrder                 = LAYOUTORDER;
                G2L.a.FillDirection             = FILL_HOR;
            
            G2L.b                               = Instancen("Frame", G2L["9"]);
                G2L.b.BorderSizePixel           = 0;
                G2L.b.BackgroundColor3          = WHITE;
                G2L.b.Size                      = Dim2(0, 24, 0, 24);
                G2L.b.LayoutOrder               = -1;
                G2L.b.BackgroundTransparency    = 1;
            
            G2L.c                               = Instancen("ImageLabel", G2L.b);
                G2L.c.BorderSizePixel           = 0;
                G2L.c.BackgroundColor3          = WHITE;
                G2L.c.ScaleType                 = CROP;
                G2L.c.Image                     = "rbxassetid://77771201330939";
                G2L.c.ImageRectSize             = Vec2(96, 96);
                G2L.c.Size                      = DIM1010;
                G2L.c.BackgroundTransparency    = 1;
                G2L.c.ImageRectOffset           = Vec2(0, 768);
            
            G2L.d                               = Instancen("UICorner", G2L.c);
                G2L.d.CornerRadius              = Dim(0, 18);
            
            G2L.e                               = Instancen("TextLabel", G2L["9"]);
                G2L.e.BorderSizePixel           = 0;
                G2L.e.TextSize                  = 20;
                G2L.e.BackgroundColor3          = WHITE;
                G2L.e.FontFace                  = FONT121;
                G2L.e.TextColor3                = WHITE;
                G2L.e.BackgroundTransparency    = 1;
                G2L.e.RichText                  = true;
                G2L.e.Text                      = "Authentication";
                G2L.e.AutomaticSize             = AutoXY;
            
            G2L.f                               = Instancen("TextLabel", G2L["6"]);
                G2L.f.TextWrapped               = true;
                G2L.f.BorderSizePixel           = 0;
                G2L.f.TextSize                  = 18;
                G2L.f.TextXAlignment            = TEXTX_LEFT;
                G2L.f.TextTransparency          = 0.2;
                G2L.f.BackgroundColor3          = WHITE;
                G2L.f.FontFace                  = Fnew("rbxassetid://12187365364", FONTW_MED, FONTS_NORM);
                G2L.f.TextColor3                = WHITE;
                G2L.f.BackgroundTransparency    = 1;
                G2L.f.RichText                  = true;
                G2L.f.Size                      = Dim2(1, 0, 0, 0);
                G2L.f.Text                      = 'We are very <font color="rgb(0, 255, 135)">s</font><font color="rgb(19, 251, 159)">o</font><font color="rgb(38, 248, 183)">r</font><font color="rgb(57, 245, 207)">r</font><font color="rgb(76, 242, 231)">y</font>, to have this auth or key system but this means a lot to us, this is where you support our project. Linkvertise has "no" 1H waiting time.';
                G2L.f.AutomaticSize             = AUTO_Y;
            
            G2L["10"]                           = Instancen("Frame", G2L["6"]);
                G2L["10"].BorderSizePixel       = 0;
                G2L["10"].BackgroundColor3      = WHITE;
                G2L["10"].Size                  = Dim2(1, 0, 0, 42);
                G2L["10"].BackgroundTransparency= 1;

            G2L["11"]                           = Instancen("UIListLayout", G2L["10"]);
                G2L["11"].HorizontalAlignment   = HOR_RIGHT;
                G2L["11"].Padding               = Dim(0, 9);
                G2L["11"].SortOrder             = LAYOUTORDER;
                G2L["11"].FillDirection         = FILL_HOR;

            G2L["12"]                           = Instancen("TextButton", G2L["10"]);
                G2L["12"].BorderSizePixel       = 0;
                G2L["12"].TextColor3            = WHITE;
                G2L["12"].AutoButtonColor       = false;
                G2L["12"].TextSize              = 14;
                G2L["12"].BackgroundColor3      = WHITE;
                G2L["12"].AutomaticSize         = AUTO_X;
                G2L["12"].Size                  = Dim2(0, 0, 1, 0);
                G2L["12"].BackgroundTransparency= 1;
                G2L["12"].LayoutOrder           = 2;
                G2L["12"].Text                  = "";

            G2L["13"]                           = Instancen("ImageLabel", G2L["12"]);
                G2L["13"].BorderSizePixel       = 0;
                G2L["13"].SliceCenter           = RECTN256;
                G2L["13"].SliceScale            = 0.03906;
                G2L["13"].BackgroundColor3      = WHITE;
                G2L["13"].ScaleType             = SLICE;
                G2L["13"].ImageTransparency     = 1;
                G2L["13"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["13"].Image                 = IMG809;
                G2L["13"].Size                  = DIM1010;
                G2L["13"].BackgroundTransparency= 1;
                G2L["13"].Name                  = "Squircle";

            G2L["14"]                           = Instancen("ImageLabel", G2L["12"]);
                G2L["14"].BorderSizePixel       = 0;
                G2L["14"].SliceCenter           = RECTN256;
                G2L["14"].SliceScale            = 0.03906;
                G2L["14"].BackgroundColor3      = WHITE;
                G2L["14"].ScaleType             = SLICE;
                G2L["14"].ImageTransparency     = 0.95;
                G2L["14"].Image                 = IMG809;
                G2L["14"].Size                  = DIM1010;
                G2L["14"].BackgroundTransparency= 1;
                G2L["14"].Name                  = "Special";

            G2L["15"]                           = Instancen("ImageLabel", G2L["12"]);
                G2L["15"].BorderSizePixel       = 0;
                G2L["15"].SliceCenter           = RECTN521;
                G2L["15"].SliceScale            = 0.01953;
                G2L["15"].BackgroundColor3      = WHITE;
                G2L["15"].ScaleType             = SLICE;
                G2L["15"].ImageColor3           = BLACK;
                G2L["15"].AnchorPoint           = VEC05;
                G2L["15"].Image                 = IMGSHA;
                G2L["15"].Size                  = Dim2(1, 3, 1, 3);
                G2L["15"].BackgroundTransparency= 1;
                G2L["15"].Name                  = "Shadow";
                G2L["15"].Position              = DIM05;

            G2L["16"]                           = Instancen("ImageLabel", G2L["12"]);
                G2L["16"].BorderSizePixel       = 0;
                G2L["16"].SliceCenter           = RECTN256;
                G2L["16"].SliceScale            = 0.03906;
                G2L["16"].BackgroundColor3      = WHITE;
                G2L["16"].ScaleType             = SLICE;
                G2L["16"].ImageTransparency     = 0.85;
                G2L["16"].Image                 = IMG117;
                G2L["16"].Size                  = DIM1010;
                G2L["16"].BackgroundTransparency= 1;

            G2L["17"]                           = Instancen("ImageLabel", G2L["12"]);
                G2L["17"].BorderSizePixel       = 0;
                G2L["17"].SliceCenter           = RECTN256;
                G2L["17"].SliceScale            = 0.03906;
                G2L["17"].BackgroundColor3      = WHITE;
                G2L["17"].ScaleType             = SLICE;
                G2L["17"].ImageTransparency     = 1;
                G2L["17"].Image                 = IMG809;
                G2L["17"].Size                  = DIM1010;
                G2L["17"].BackgroundTransparency= 1;
                G2L["17"].Name                  = "Frame";

            G2L["18"]                           = Instancen("UIPadding", G2L["17"]);
                G2L["18"].PaddingRight          = Dim(0, 12);
                G2L["18"].PaddingLeft           = Dim(0, 12);

            G2L["19"]                           = Instancen("UIListLayout", G2L["17"]);
                G2L["19"].HorizontalAlignment   = HOR_CENTER;
                G2L["19"].Padding               = Dim(0, 8);
                G2L["19"].VerticalAlignment     = VERTICALCENTER;
                G2L["19"].SortOrder             = LAYOUTORDER;
                G2L["19"].FillDirection         = FILL_HOR;

            G2L["1a"]                           = Instancen("TextLabel", G2L["17"]);
                G2L["1a"].BorderSizePixel       = 0;
                G2L["1a"].TextSize              = 18;
                G2L["1a"].BackgroundColor3      = WHITE;
                G2L["1a"].FontFace              = FONT121;
                G2L["1a"].TextColor3            = WHITE;
                G2L["1a"].BackgroundTransparency= 1;
                G2L["1a"].RichText              = true;
                G2L["1a"].Text                  = "Cancel";
                G2L["1a"].AutomaticSize         = AutoXY;

            G2L["1b"]                           = Instancen("TextButton", G2L["10"]);
                G2L["1b"].BorderSizePixel       = 0;
                G2L["1b"].TextColor3            = WHITE;
                G2L["1b"].AutoButtonColor       = false;
                G2L["1b"].TextSize              = 14;
                G2L["1b"].BackgroundColor3      = WHITE;
                G2L["1b"].AutomaticSize         = AUTO_X;
                G2L["1b"].Size                  = Dim2(0, 0, 1, 0);
                G2L["1b"].BackgroundTransparency= 1;
                G2L["1b"].LayoutOrder           = 3;
                G2L["1b"].Text                  = "";

            G2L["1c"]                           = Instancen("ImageLabel", G2L["1b"]);
                G2L["1c"].BorderSizePixel       = 0;
                G2L["1c"].SliceCenter           = RECTN256;
                G2L["1c"].SliceScale            = 0.03906;
                G2L["1c"].BackgroundColor3      = WHITE;
                G2L["1c"].ScaleType             = SLICE;
                G2L["1c"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["1c"].Image                 = IMG809;
                G2L["1c"].Size                  = DIM1010;
                G2L["1c"].BackgroundTransparency= 1;
                G2L["1c"].Name                  = "Squircle";

            G2L["1d"]                           = Instancen("ImageLabel", G2L["1b"]);
                G2L["1d"].BorderSizePixel       = 0;
                G2L["1d"].SliceCenter           = RECTN256;
                G2L["1d"].SliceScale            = 0.03906;
                G2L["1d"].BackgroundColor3      = WHITE;
                G2L["1d"].ScaleType             = SLICE;
                G2L["1d"].ImageTransparency     = 1;
                G2L["1d"].Image                 = IMG809;
                G2L["1d"].Size                  = DIM1010;
                G2L["1d"].BackgroundTransparency= 1;
                G2L["1d"].Name                  = "Special";

            G2L["1e"]                           = Instancen("ImageLabel", G2L["1b"]);
                G2L["1e"].BorderSizePixel       = 0;
                G2L["1e"].SliceCenter           = RECTN521;
                G2L["1e"].SliceScale            = 0.01953;
                G2L["1e"].BackgroundColor3      = WHITE;
                G2L["1e"].ScaleType             = SLICE;
                G2L["1e"].ImageTransparency     = 1;
                G2L["1e"].ImageColor3           = BLACK;
                G2L["1e"].AnchorPoint           = VEC05;
                G2L["1e"].Image                 = IMGSHA;
                G2L["1e"].Size                  = Dim2(1, 3, 1, 3);
                G2L["1e"].BackgroundTransparency= 1;
                G2L["1e"].Name                  = "Shadow";
                G2L["1e"].Position              = DIM05;

            G2L["1f"]                           = Instancen("ImageLabel", G2L["1b"]);
                G2L["1f"].BorderSizePixel       = 0;
                G2L["1f"].SliceCenter           = RECTN256;
                G2L["1f"].SliceScale            = 0.03906;
                G2L["1f"].BackgroundColor3      = WHITE;
                G2L["1f"].ScaleType             = SLICE;
                G2L["1f"].ImageTransparency     = 0.95;
                G2L["1f"].Image                 = IMG117;
                G2L["1f"].Size                  = DIM1010;
                G2L["1f"].BackgroundTransparency= 1;

            G2L["20"]                           = Instancen("ImageLabel", G2L["1b"]);
                G2L["20"].BorderSizePixel       = 0;
                G2L["20"].SliceCenter           = RECTN256;
                G2L["20"].SliceScale            = 0.03906;
                G2L["20"].BackgroundColor3      = WHITE;
                G2L["20"].ScaleType             = SLICE;
                G2L["20"].ImageTransparency     = 1;
                G2L["20"].Image                 = IMG809;
                G2L["20"].Size                  = DIM1010;
                G2L["20"].BackgroundTransparency= 1;
                G2L["20"].Name                  = "Frame";

            G2L["21"]                           = Instancen("UIPadding", G2L["20"]);
                G2L["21"].PaddingRight          = Dim(0, 12);
                G2L["21"].PaddingLeft           = Dim(0, 12);

            G2L["22"]                           = Instancen("UIListLayout", G2L["20"]);
                G2L["22"].HorizontalAlignment   = HOR_CENTER;
                G2L["22"].Padding               = Dim(0, 8);
                G2L["22"].VerticalAlignment     = VERTICALCENTER;
                G2L["22"].SortOrder             = LAYOUTORDER;
                G2L["22"].FillDirection         = FILL_HOR;

            G2L["23"]                           = Instancen("ImageLabel", G2L["20"]);
                G2L["23"].BorderSizePixel       = 0;
                G2L["23"].BackgroundColor3      = WHITE;
                G2L["23"].ImageColor3           = fromRGB(162, 162, 171);
                G2L["23"].Image                 = "rbxassetid://131526378523863";
                G2L["23"].ImageRectSize         = Vec2(96, 96);
                G2L["23"].Size                  = Dim2(0, 21, 0, 21);
                G2L["23"].BackgroundTransparency= 1;
                G2L["23"].ImageRectOffset       = Vec2(480, 768);

            G2L["24"]                           = Instancen("TextLabel", G2L["20"]);
                G2L["24"].BorderSizePixel       = 0;
                G2L["24"].TextSize              = 18;
                G2L["24"].BackgroundColor3      = WHITE;
                G2L["24"].FontFace              = FONT121;
                G2L["24"].TextColor3            = WHITE;
                G2L["24"].BackgroundTransparency= 1;
                G2L["24"].RichText              = true;
                G2L["24"].Text                  = "Continue";
                G2L["24"].AutomaticSize         = AutoXY;

            G2L["25"]                           = Instancen("TextBox", G2L["10"]);
                G2L["25"].BorderSizePixel       = 0;
                G2L["25"].TextSize              = 14;
                G2L["25"].TextColor3            = WHITE;
                G2L["25"].BackgroundColor3      = WHITE;
                G2L["25"].FontFace              = FONT121;
                G2L["25"].ClipsDescendants      = true;
                G2L["25"].PlaceholderText       = "Enter Key...";
                G2L["25"].Size                  = Dim2(0.17, 0, 1, 0);
                G2L["25"].BorderColor3          = BLACK;
                G2L["25"].Text                  = "";
                G2L["25"].BackgroundTransparency= 1;

            G2L["26"]                           = Instancen("ImageLabel", G2L["25"]);
                G2L["26"].BorderSizePixel       = 0;
                G2L["26"].SliceCenter           = RECTN256;
                G2L["26"].SliceScale            = 0.03906;
                G2L["26"].BackgroundColor3      = WHITE;
                G2L["26"].ScaleType             = SLICE;
                G2L["26"].ImageTransparency     = 1;
                G2L["26"].Image                 = IMG809;
                G2L["26"].Size                  = DIM1010;
                G2L["26"].BackgroundTransparency= 1;
                G2L["26"].Name                  = "Frame";

            G2L["27"]                           = Instancen("ImageLabel", G2L["25"]);
                G2L["27"].BorderSizePixel       = 0;
                G2L["27"].SliceCenter           = RECTN256;
                G2L["27"].SliceScale            = 0.03906;
                G2L["27"].BackgroundColor3      = WHITE;
                G2L["27"].ScaleType             = SLICE;
                G2L["27"].ImageTransparency     = 0.85;
                G2L["27"].Image                 = IMG117;
                G2L["27"].Size                  = DIM1010;
                G2L["27"].BackgroundTransparency= 1;

            G2L["28"]                           = Instancen("ImageLabel", G2L["25"]);
                G2L["28"].BorderSizePixel       = 0;
                G2L["28"].SliceCenter           = RECTN521;
                G2L["28"].SliceScale            = 0.01953;
                G2L["28"].BackgroundColor3      = WHITE;
                G2L["28"].ScaleType             = SLICE;
                G2L["28"].ImageColor3           = BLACK;
                G2L["28"].AnchorPoint           = VEC05;
                G2L["28"].Image                 = IMGSHA;
                G2L["28"].Size                  = Dim2(1, 3, 1, 3);
                G2L["28"].BackgroundTransparency= 1;
                G2L["28"].Name                  = "Shadow";
                G2L["28"].Position              = DIM05;

            G2L["29"]                           = Instancen("ImageLabel", G2L["25"]);
                G2L["29"].BorderSizePixel       = 0;
                G2L["29"].SliceCenter           = RECTN256;
                G2L["29"].SliceScale            = 0.03906;
                G2L["29"].BackgroundColor3      = WHITE;
                G2L["29"].ScaleType             = SLICE;
                G2L["29"].ImageTransparency     = 0.95;
                G2L["29"].Image                 = IMG809;
                G2L["29"].Size                  = DIM1010;
                G2L["29"].BackgroundTransparency= 1;
                G2L["29"].Name                  = "Special";

            G2L["2a"]                           = Instancen("ImageLabel", G2L["25"]);
                G2L["2a"].BorderSizePixel       = 0;
                G2L["2a"].SliceCenter           = RECTN256;
                G2L["2a"].SliceScale            = 0.03906;
                G2L["2a"].BackgroundColor3      = WHITE;
                G2L["2a"].ScaleType             = SLICE;
                G2L["2a"].ImageTransparency     = 1;
                G2L["2a"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["2a"].Image                 = IMG809;
                G2L["2a"].Size                  = DIM1010;
                G2L["2a"].BackgroundTransparency= 1;
                G2L["2a"].Name                  = "Squircle";

            G2L["2b"]                           = Instancen("TextButton", G2L["10"]);
                G2L["2b"].BorderSizePixel       = 0;
                G2L["2b"].TextColor3            = WHITE;
                G2L["2b"].AutoButtonColor       = false;
                G2L["2b"].TextSize              = 14;
                G2L["2b"].BackgroundColor3      = WHITE;
                G2L["2b"].AutomaticSize         = AUTO_X;
                G2L["2b"].Size                  = Dim2(0, 0, 1, 0);
                G2L["2b"].BackgroundTransparency= 1;
                G2L["2b"].LayoutOrder           = 1;
                G2L["2b"].Text                  = "";

            G2L["2c"]                           = Instancen("ImageLabel", G2L["2b"]);
                G2L["2c"].BorderSizePixel       = 0;
                G2L["2c"].SliceCenter           = RECTN256;
                G2L["2c"].SliceScale            = 0.03906;
                G2L["2c"].BackgroundColor3      = WHITE;
                G2L["2c"].ScaleType             = SLICE;
                G2L["2c"].ImageTransparency     = 1;
                G2L["2c"].ImageColor3           = fromRGB(83, 83, 92);
                G2L["2c"].Image                 = IMG809;
                G2L["2c"].Size                  = DIM1010;
                G2L["2c"].BackgroundTransparency= 1;
                G2L["2c"].Name                  = "Squircle";

            G2L["2d"]                           = Instancen("ImageLabel", G2L["2b"]);
                G2L["2d"].BorderSizePixel       = 0;
                G2L["2d"].SliceCenter           = RECTN256;
                G2L["2d"].SliceScale            = 0.03906;
                G2L["2d"].BackgroundColor3      = WHITE;
                G2L["2d"].ScaleType             = SLICE;
                G2L["2d"].ImageTransparency     = 0.95;
                G2L["2d"].Image                 = IMG809;
                G2L["2d"].Size                  = DIM1010;
                G2L["2d"].BackgroundTransparency= 1;
                G2L["2d"].Name                  = "Special";

            G2L["2e"]                           = Instancen("ImageLabel", G2L["2b"]);
                G2L["2e"].BorderSizePixel       = 0;
                G2L["2e"].SliceCenter           = RECTN521;
                G2L["2e"].SliceScale            = 0.01953;
                G2L["2e"].BackgroundColor3      = WHITE;
                G2L["2e"].ScaleType             = SLICE;
                G2L["2e"].ImageColor3           = BLACK;
                G2L["2e"].AnchorPoint           = VEC05;
                G2L["2e"].Image                 = IMGSHA;
                G2L["2e"].Size                  = Dim2(1, 3, 1, 3);
                G2L["2e"].BackgroundTransparency= 1;
                G2L["2e"].Name                  = "Shadow";
                G2L["2e"].Position              = DIM05;

            G2L["2f"]                           = Instancen("ImageLabel", G2L["2b"]);
                G2L["2f"].BorderSizePixel       = 0;
                G2L["2f"].SliceCenter           = RECTN256;
                G2L["2f"].SliceScale            = 0.03906;
                G2L["2f"].BackgroundColor3      = WHITE;
                G2L["2f"].ScaleType             = SLICE;
                G2L["2f"].ImageTransparency     = 0.85;
                G2L["2f"].Image                 = IMG117;
                G2L["2f"].Size                  = DIM1010;
                G2L["2f"].BackgroundTransparency= 1;

            G2L["30"]                           = Instancen("ImageLabel", G2L["2b"]);
                G2L["30"].BorderSizePixel       = 0;
                G2L["30"].SliceCenter           = RECTN256;
                G2L["30"].SliceScale            = 0.03906;
                G2L["30"].BackgroundColor3      = WHITE;
                G2L["30"].ScaleType             = SLICE;
                G2L["30"].ImageTransparency     = 1;
                G2L["30"].Image                 = IMG809;
                G2L["30"].Size                  = DIM1010;
                G2L["30"].BackgroundTransparency= 1;
                G2L["30"].Name                  = "Frame";

            G2L["31"]                           = Instancen("UIPadding", G2L["30"]);
                G2L["31"].PaddingRight          = Dim(0, 12);
                G2L["31"].PaddingLeft           = Dim(0, 12);

            G2L["32"]                           = Instancen("UIListLayout", G2L["30"]);
                G2L["32"].HorizontalAlignment   = HOR_CENTER;
                G2L["32"].Padding               = Dim(0, 8);
                G2L["32"].VerticalAlignment     = VERTICALCENTER;
                G2L["32"].SortOrder             = LAYOUTORDER;
                G2L["32"].FillDirection         = FILL_HOR;

            G2L["33"]                           = Instancen("TextLabel", G2L["30"]);
                G2L["33"].BorderSizePixel       = 0;
                G2L["33"].TextSize              = 18;
                G2L["33"].BackgroundColor3      = WHITE;
                G2L["33"].FontFace              = FONT121;
                G2L["33"].TextColor3            = WHITE;
                G2L["33"].BackgroundTransparency= 1;
                G2L["33"].RichText              = true;
                G2L["33"].Text                  = "Copy Link";
                G2L["33"].AutomaticSize         = AutoXY;

            G2L["34"]                           = Instancen("UIPadding", G2L["6"]);
                G2L["34"].PaddingTop            = Dim(0, 16);
                G2L["34"].PaddingRight          = Dim(0, 16);
                G2L["34"].PaddingLeft           = Dim(0, 16);
                G2L["34"].PaddingBottom         = Dim(0, 16);

            G2L["35"]                           = Instancen("UIScale", G2L["2"]);

            G2L["36"]                           = Instancen("ImageLabel", G2L["2"]);
                G2L["36"].BorderSizePixel       = 0;
                G2L["36"].SliceCenter           = RECTN256;
                G2L["36"].SliceScale            = 0.08594;
                G2L["36"].BackgroundColor3      = WHITE;
                G2L["36"].ScaleType             = SLICE;
                G2L["36"].ImageTransparency     = 0.9;
                G2L["36"].Image                 = IMG117;
                G2L["36"].Size                  = DIM1010;
                G2L["36"].BackgroundTransparency= 1;
            
            G2L["37"]                           = Instancen("UIGradient", G2L["36"]);
                G2L["37"].Rotation              = 90;
                G2L["37"].Transparency          = NSnew{NSKnew(0.000, 0),NSKnew(1.000, 1)};
        
            G2L["1b"].MouseButton1Click:Connect(function()
                return configu.Auth(G2L["25"].Text);
            end);
            G2L["2b"].MouseButton1Click:Connect(configu.GetKey);
            G2L["12"].MouseButton1Click:Connect(function(...)
                G2L["1"]:Destroy(); G2L = nil;
            end);
    
            function tbl:fadeAndTween(G2L, e)
                local tweenInfo = TwInfo(0.5, EASE_QUAD, EASE_OUT)
                for key, instance in pairs(G2L) do
                    tspawn(function()
                        if IsA(instance, "TextLabel") and instance.Text ~= "Authentication" then
                            local tween = TwCreate(TweenService, instance, tweenInfo, {TextTransparency = 1});
                            instance.AutomaticSize = AUTO_NONE; tween:Play();
                            tween.Completed:Once(function() instance.Visible = false; end);
                        elseif IsA(instance, "Frame") then
                            local size = instance.Size;
                            local tween = TwCreate(TweenService, instance, tweenInfo, {Size = Dim2(size.X.Scale, size.X.Offset, 0, 0)})
                            instance.AutomaticSize = AUTO_NONE; tween:Play()
                            tween.Completed:Once(function() instance:Destroy(); end);
                        end;
                    end);
                end;
                local function tweenText()
                    local textLabel = e;
                    local tweenInfoFadeOut = TwInfo(0.2, EASE_QUAD, EASE_OUT);
                    local tweenInfoFadeIn = TwInfo(0.2, EASE_QUAD, EASE_IN);
    
                    for _, msg in ipairs({
                        {Text = "TTJY Hub", Duration = 0.5},
                        {Text = "Script made by TTJY Studio", Duration = 0.5},
                        {Text = "Thank you!", Duration = 0.5}
                    }) do
                        local tweenOut = TwCreate(TweenService, textLabel, tweenInfoFadeOut, {TextTransparency = 1});
                        tweenOut:Play(); tweenOut.Completed:Wait(); textLabel.Text = msg.Text;
                        local tweenIn = TwCreate(TweenService, textLabel, tweenInfoFadeIn, {TextTransparency = 0});
                        tweenIn:Play(); twait(msg.Duration + 0.4);
                    end;
                end; tweenText();
            end; return G2L, tbl;
        end;
    };
end;

------------- WindUI -------------

AssetStorage.LoadUILib = function()
    local PropChangeSignal = game.GetPropertyChangedSignal;
    local CSKnew = ColorSequenceKeypoint.new;
    local fromMatrix = CFrame.fromMatrix;
    local GetChildren = game.GetChildren;
    local Dim2Scale = UDim2.fromScale;
    local CSnew = ColorSequence.new;
    local fromHex = Col3.fromHex;
    local fromHSV = Col3.fromHSV;
    local toHSV = Col3.toHSV;

    local LocalizationService = GetService(game, "LocalizationService");
    local RunService = GetService(game, "RunService");
    local Lighting = GetService(game, "Lighting");
    local Cam = Workspace.CurrentCamera;
    local cmdm = selff:GetMouse();

    local DIM05 = Dim2(0.5, 0, 0.5, 0);
    local DIM0010 = Dim2(0, 0, 1, 0);
    local DIM1010 = Dim2(1, 0, 1, 0);
    local DIM0000 = Dim2(0, 0, 0, 0);
    local VEC05 = Vec2(0.5, 0.5);

    local EASE_QUINT = Enum.EasingStyle.Quint;
    local EASE_OUT = Enum.EasingDirection.Out;
    local TWI_01 = TwInfo(0.1);
    local TWI_015 = TwInfo(0.15);
    local TWI_006 = TwInfo(0.06);
    local TWI_008 = TwInfo(0.08);
    local TWI_012 = TwInfo(0.12);
    local TWI_005 = TwInfo(0.05);
    local TWI_Q_01 = TwInfo(0.1, EASE_QUINT, EASE_OUT);
    local TWI_Q_02 = TwInfo(0.2, EASE_QUINT, EASE_OUT);
    local TWI_Q_045 = TwInfo(0.45, EASE_QUINT, EASE_OUT);
    local TWI_Q_025 = TwInfo(0.25, EASE_QUINT, EASE_OUT);

    local isFirstLoad = true;
    local GlobalBinds = {};

    local BindConfig = GG.BindConfigs or {};
    GG.BindConfigs = BindConfig;

    local a = nil; a = {cache = {}, load = function(b)
        if not a.cache[b] then
            a.cache[b] = {c = a[b]()};
        end; return a.cache[b].c;
    end}; do
        function a.a()
            return {
                Primary = fromHex"#0091FF",
                White = WHITE,
                Black = BLACK,
                Dialog = "Accent",
                Background = "Accent",
                BackgroundTransparency = 0,
                Hover = "Text",
                WindowBackground = "Background",
                WindowShadow = "Black",
                WindowTopbarTitle = "Text",
                WindowTopbarAuthor = "Text",
                WindowTopbarIcon = "Icon",
                WindowTopbarButtonIcon = "Icon",
                TabBackground = "Hover",
                TabTitle = "Text",
                TabIcon = "Icon",
                ElementBackground = "Text",
                GroupBackgroundTransparency = "Group",
                GroupBackground = "Group",
                ElementTitle = "Text",
                ElementDesc = "Text",
                ElementIcon = "Icon",
                PopupBackground = "Background",
                PopupBackgroundTransparency = "BackgroundTransparency",
                PopupTitle = "Text",
                PopupContent = "Text",
                PopupIcon = "Icon",
                DialogBackground = "Background",
                DialogBackgroundTransparency = "BackgroundTransparency",
                DialogTitle = "Text",
                DialogContent = "Text",
                DialogIcon = "Icon",
                Toggle = "Button",
                ToggleBar = "White",
                Checkbox = "Primary",
                CheckboxIcon = "White",
                Slider = "Primary",
                SliderThumb = "White",
                SliderIconFrom = fromHex"#908F95",
                SliderIconTo = fromHex"#908F95",
                Tooltip = fromHex"4C4C4C",
                TooltipText = "White",
                TooltipSecondary = "Primary",
                TooltipSecondaryText = "White"
            };
        end;
        function a.b()
            local l = (function()
                local IconModule = {  
                    IconsType = "lucide", New = nil, IconThemeTag = nil,
                    Icons = (LoaderSettings.BadNetwork and {}) or {  
                        ["lucide"] = LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/Assets/lucide.lua", "lucide.lua", "2")(),
                        --["solar"] = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))(),  
                        --["craft"] = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua"))(),  
                        --["geist"] = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua"))(),  
                        ["sfsymbols"] = LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/Assets/sfsymbols.lua", "sfsymbols.lua", "2")(),  
                    },
                };
                local function parseIconString(iconString)  
                    if type(iconString) == "string" then  
                        local splitIndex = iconString:find(":");
                        if splitIndex then  
                            local iconType = iconString:sub(1, splitIndex - 1);
                            local iconName = iconString:sub(splitIndex + 1);
                            return iconType, iconName;
                        end;
                    end; return nil, iconString;
                end; function IconModule.AddIcons(packName, iconsData)
                    if type(packName) ~= "string" or type(iconsData) ~= "table" then
                        return error("AddIcons: packName must be string, iconsData must be table");
                    end; if not IconModule.Icons[packName] then
                        IconModule.Icons[packName] = {
                            Icons = {},
                            Spritesheets = {}
                        };
                    end; for iconName, iconValue in pairs(iconsData) do
                        if type(iconValue) == "number" or (type(iconValue) == "string" and iconValue:match("^rbxassetid://")) then
                            local imageId = iconValue;
                            if type(iconValue) == "number" then
                                imageId = "rbxassetid://" .. tostring(iconValue)
                            end; IconModule.Icons[packName].Icons[iconName] = {
                                Image = imageId,
                                ImageRectSize = Vec2(0, 0),
                                ImageRectPosition = Vec2(0, 0),
                                Parts = nil
                            }; IconModule.Icons[packName].Spritesheets[imageId] = imageId;
                        elseif type(iconValue) == "table" then
                            if iconValue.Image and iconValue.ImageRectSize and iconValue.ImageRectPosition then
                                local imageId = iconValue.Image;
                                if type(imageId) == "number" then
                                    imageId = "rbxassetid://" .. tostring(imageId)
                                end; IconModule.Icons[packName].Icons[iconName] = {
                                    Image = imageId,
                                    ImageRectSize = iconValue.ImageRectSize,
                                    ImageRectPosition = iconValue.ImageRectPosition,
                                    Parts = iconValue.Parts
                                }; if not IconModule.Icons[packName].Spritesheets[imageId] then
                                    IconModule.Icons[packName].Spritesheets[imageId] = imageId;
                                end;
                            else
                                warn("[TTJY Studio] : Invalid spritesheet data format for icon '" .. iconName .. "'");
                            end;
                        else
                            warn("[TTJY Studio] : Unsupported data type for icon '" .. iconName .. "': " .. type(iconValue));
                        end;
                    end;
                end; function IconModule.SetIconsType(iconType)  
                    IconModule.IconsType = iconType  
                end; function IconModule.Init(New, IconThemeTag)  
                    IconModule.New = New;
                    IconModule.IconThemeTag = IconThemeTag;  
                    return IconModule;
                end; function IconModule.Icon(Icon, Type, DefaultFormat)  
                    local iconType, iconName = parseIconString(Icon);
                    local targetType = iconType or Type or IconModule.IconsType;
                    local targetName, iconSet = iconName, IconModule.Icons[targetType];
                    if iconSet and iconSet.Icons and iconSet.Icons[targetName] then  
                        return {   
                            iconSet.Spritesheets[tostring(iconSet.Icons[targetName].Image)],   
                            iconSet.Icons[targetName],  
                        };
                    elseif iconSet and iconSet[targetName] and str.find(iconSet[targetName], "rbxassetid://") then
                        return DefaultFormat and { 
                            iconSet[targetName], 
                            { ImageRectSize = Vec2(0,0), ImageRectPosition = Vec2(0,0) }
                        } or iconSet[targetName];
                    end;
                    return DefaultFormat and {
                        nil,
                        { ImageRectSize = Vec2(0,0), ImageRectPosition = Vec2(0,0) }
                    } or nil;
                end; function IconModule.Icon2(Icon, Type, DefaultFormat)  
                    return IconModule.Icon(Icon, Type, true);
                end; function IconModule.Image(IconConfig)  
                    local Icon = {  
                        Icon = IconConfig.Icon or nil,  
                        Type = IconConfig.Type,  
                        Colors = IconConfig.Colors or { ( IconModule.IconThemeTag or WHITE ), WHITE },  
                        Size = IconConfig.Size or Dim2(0,24,0,24),  
                        IconFrame = nil,
                    };
                    local Colors = {};
                    for _, color in next, Icon.Colors do  
                        Colors[_] = {  
                            ThemeTag = typeof(color) == "string" and color,  
                            Color = typeof(color) == "Color3" and color,  
                        };
                    end; 
                    local IconLabel = IconModule.Icon2(Icon.Icon, Icon.Type);
                    local isrbxassetid = typeof(IconLabel) == "string" and str.find(IconLabel, 'rbxassetid://');
                    if IconModule.New then  
                        local IconFrame = IconModule.New("ImageLabel", {  
                            Size = Icon.Size,  
                            BackgroundTransparency = 1,  
                            ImageColor3 = Colors[1].Color or nil,  
                            ThemeTag = Colors[1].ThemeTag and {  
                                ImageColor3 = Colors[1].ThemeTag  
                            },  
                            Image = isrbxassetid and IconLabel or IconLabel[1],  
                            ImageRectSize = isrbxassetid and nil or IconLabel[2].ImageRectSize,  
                            ImageRectOffset = isrbxassetid and nil or IconLabel[2].ImageRectPosition,  
                        }); if not isrbxassetid and IconLabel[2].Parts then  
                            for _, part in next, IconLabel[2].Parts do  
                                local IconPartLabel = IconModule.Icon(part, Icon.Type)  
                                    
                                local IconPart = IconModule.New("ImageLabel", {  
                                    Size = Dim2(1,0,1,0),  
                                    BackgroundTransparency = 1,  
                                    ImageColor3 = Colors[1 + _].Color or nil,  
                                    ThemeTag = Colors[1 + _].ThemeTag and {  
                                        ImageColor3 = Colors[1 + _].ThemeTag  
                                    },  
                                    Image = IconPartLabel[1],  
                                    ImageRectSize = IconPartLabel[2].ImageRectSize,  
                                    ImageRectOffset = IconPartLabel[2].ImageRectPosition,  
                                    Parent = IconFrame,  
                                });
                            end;
                        end; Icon.IconFrame = IconFrame;
                    else  
                        local IconFrame = Instancen("ImageLabel");
                        IconFrame.Size = Icon.Size;
                        IconFrame.BackgroundTransparency = 1;
                        IconFrame.ImageColor3 = Colors[1].Color;
                        IconFrame.Image = isrbxassetid and IconLabel or IconLabel[1];
                        IconFrame.ImageRectSize = isrbxassetid and nil or IconLabel[2].ImageRectSize;
                        IconFrame.ImageRectOffset = isrbxassetid and nil or IconLabel[2].ImageRectPosition;
                        if not isrbxassetid and IconLabel[2].Parts then  
                            for _, part in next, IconLabel[2].Parts do  
                                local IconPartLabel = IconModule.Icon(part, Icon.Type);
                                local IconPart = Instancen("ImageLabel"); 
                                IconPart.Size = Dim2(1,0,1,0);
                                IconPart.BackgroundTransparency = 1;
                                IconPart.ImageColor3 = Colors[1 + _].Color;
                                IconPart.Image = IconPartLabel[1];
                                IconPart.ImageRectSize = IconPartLabel[2].ImageRectSize;
                                IconPart.ImageRectOffset = IconPartLabel[2].ImageRectPosition; 
                                IconPart.Parent = IconFrame;
                            end;
                        end; Icon.IconFrame = IconFrame;
                    end; return Icon;
                end; return IconModule;
            end)(); l.SetIconsType "lucide"
            local m, p = nil, {
                Font = "rbxassetid://12187365364",
                Localization = nil,
                CanDraggable = true,
                Theme = nil,
                Themes = nil,
                Icons = l,
                Signals = {},
                Objects = setmetatable({}, {__mode = "k"}),
                LocalizationObjects = {},
                FontObjects = setmetatable({}, {__mode = "k"}),
                Language = str.match(LocalizationService.SystemLocaleId, "^[a-z]+"),
                DefaultProperties = {
                    ScreenGui = {
                        ResetOnSpawn = false,
                        ZIndexBehavior = "Sibling"
                    },
                    CanvasGroup = {
                        BorderSizePixel = 0,
                        BackgroundColor3 = WHITE
                    },
                    Frame = {
                        BorderSizePixel = 0,
                        BackgroundColor3 = WHITE
                    },
                    TextLabel = {
                        BackgroundColor3 = WHITE,
                        BorderSizePixel = 0,
                        Text = "",
                        RichText = true,
                        TextColor3 = WHITE,
                        TextSize = 14
                    },
                    TextButton = {
                        BackgroundColor3 = WHITE,
                        BorderSizePixel = 0,
                        Text = "",
                        AutoButtonColor = false,
                        TextColor3 = WHITE,
                        TextSize = 14
                    },
                    TextBox = {
                        BackgroundColor3 = WHITE,
                        BorderColor3 = BLACK,
                        ClearTextOnFocus = false,
                        Text = "",
                        TextColor3 = BLACK,
                        TextSize = 14
                    },
                    ImageLabel = {
                        BackgroundTransparency = 1,
                        BackgroundColor3 = WHITE,
                        BorderSizePixel = 0
                    },
                    ImageButton = {
                        BackgroundColor3 = WHITE,
                        BorderSizePixel = 0,
                        AutoButtonColor = false
                    },
                    UIListLayout = {
                        SortOrder = "LayoutOrder"
                    },
                    ScrollingFrame = {
                        ScrollBarImageTransparency = 1,
                        BorderSizePixel = 0
                    },
                    VideoFrame = {
                        BorderSizePixel = 0
                    }
                },
                Colors = {
                    Red = "#e53935",
                    Orange = "#f57c00",
                    Green = "#43a047",
                    Blue = "#039be5",
                    White = "#ffffff",
                    Grey = "#484848",
                    Yellow = "#FFFF00",
                },
                ThemeFallbacks = a.load "a",
                Shapes = {
                    Square = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://82909646051652",
                    ["Square-Outline"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://72946211851948",
                    Squircle = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://80999662900595",
                    SquircleOutline = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://117788349049947",
                    ["Squircle-Outline"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://117817408534198",
                    SquircleOutline2 = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://117817408534198",
                    ["Shadow-sm"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://84825982946844",
                    ["Squircle-TL-TR"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://73569156276236",
                    ["Squircle-BL-BR"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://93853842912264",
                    ["Squircle-TL-TR-Outline"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://136702870075563",
                    ["Squircle-BL-BR-Outline"] = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://75035847706564"
                };
            };
            function p.Init(r) m = r; end;
            function p.AddSignal(r, u)
                local v = r:Connect(u);
                tble.insert(p.Signals, v);
                return v;
            end; function p.DisconnectAll()
                for _, v in ipairs(p.Signals) do
                    if typeof(v) == "RBXScriptConnection" and v.Connected then
                        v:Disconnect();
                    end;
                end; tble.clear(p.Signals);
            end; function p.SafeCallback(r, ...)
                if not r then return; end;
                local u, v = pcall(r, ...);
                if not u then
                    if m and m.Window and m.Window.Debug then
                        local x, z = v:find":%d+: ";
                        return m:Notify {
                            Title = "DEBUG Mode: Error",
                            Content = not z and v or v:sub(z + 1),
                            Duration = 8
                        };
                    end;
                end;
            end; function p.Gradient(r, u)
                if m and m.Gradient then return m:Gradient(r, u); end;
                local v,x = {}, {}; for z, A in next, r do
                    local B = tonumber(z); if B then
                        B = math.clamp(B / 100, 0, 1);
                        tble.insert(v, CSKnew(B, A.Color));
                        tble.insert(x, NSKnew(B, A.Transparency or 0));
                    end;
                end;
                tble.sort(v, function(B, C) return B.Time < C.Time; end);
                tble.sort(x, function(B, C) return B.Time < C.Time; end);
                if #v < 2 then
                    error"ColorSequence requires at least 2 keypoints";
                end; local B = {
                    Color = CSnew(v),
                    Transparency = NSnew(x)
                }; if u then
                    for C, F in pairs(u) do
                        B[C] = F;
                    end;
                end; return B;
            end; function p.SetTheme(r)
                p.Theme = r;
                p.UpdateTheme(nil, false);
            end; function p.AddFontObject(r)
                tble.insert(p.FontObjects, r);
                p.UpdateFont(p.Font);
            end; function p.UpdateFont(r)
                p.Font = r; for u, v in next, p.FontObjects do
                    v.FontFace = Fnew(r, v.FontFace.Weight, v.FontFace.Style);
                end;
            end; function p.GetThemeProperty(r, u)
                local function getValue(v, x)
                    local z = x[v] if z == nil then
                        return nil;
                    end; if typeof(z) == "string" and str.sub(z, 1, 1) == "#" then
                        return fromHex(z);
                    end; if typeof(z) == "Color3" then
                        return z;
                    end; if typeof(z) == "number" then
                        return z;
                    end; if typeof(z) == "table" and z.Color and z.Transparency then
                        return z;
                    end; if typeof(z) == "function" then
                        return z();
                    end; return z;
                end; local v = getValue(r, u); if v ~= nil then
                    if typeof(v) == "string" and str.sub(v, 1, 1) ~= "#" then
                        local x = p.GetThemeProperty(v, u);
                        if x ~= nil then return x; end;
                    else
                        return v;
                    end;
                end; local x = p.ThemeFallbacks[r];
                if x ~= nil then
                    if typeof(x) == "string" and str.sub(x, 1, 1) ~= "#" then
                        return p.GetThemeProperty(x, u);
                    else
                        return getValue(r, {[r] = x});
                    end;
                end; v = getValue(r, p.Themes.Dark) if v ~= nil then
                    if typeof(v) == "string" and str.sub(v, 1, 1) ~= "#" then
                        local z = p.GetThemeProperty(v, p.Themes.Dark);
                        if z ~= nil then return z; end;
                    else
                        return v;
                    end;
                end; if x ~= nil then
                    if typeof(x) == "string" and str.sub(x, 1, 1) ~= "#" then
                        return p.GetThemeProperty(x, p.Themes.Dark);
                    else
                        return getValue(r, {[r] = x});
                    end;
                end; return nil;
            end; function p.AddThemeObject(r, u)
                p.Objects[r] = {Object = r, Properties = u};
                p.UpdateTheme(r, false);
                return r;
            end; function p.AddLangObject(r)
                local u = p.LocalizationObjects[r];
                local v = u.Object;
                local x = currentObjTranslationId;
                p.UpdateLang(v, x);
                return v;
            end; function p.UpdateTheme(r, u)
                local function ApplyTheme(v)
                    for x, z in pairs(v.Properties or {}) do
                        local A = p.GetThemeProperty(z, p.Theme)
                        if A ~= nil then
                            if typeof(A) == "Color3" then
                                local B = FindFirstChild(v.Object,"WindUIGradient");
                                if B then B:Destroy(); end;
                                if not u then v.Object[x] = A; else
                                    TwCreate(v.Object, TWI_008, {[x] = A}):Play();
                                end;
                            elseif typeof(A) == "table" and A.Color and A.Transparency then
                                v.Object[x] = WHITE;
                                local B = FindFirstChild(v.Object, "WindUIGradient");
                                if not B then
                                    B = Instancen"UIGradient";
                                    B.Name = "WindUIGradient";
                                    B.Parent = v.Object;
                                end; B.Color = A.Color;
                                B.Transparency = A.Transparency;
                                for C, F in pairs(A) do
                                    if C ~= "Color" and C ~= "Transparency" and B[C] ~= nil then
                                        B[C] = F;
                                    end;
                                end;
                            elseif typeof(A) == "number" then
                                if not u then v.Object[x] = A; else
                                    TwCreate(v.Object, TWI_008, {[x] = A}):Play();
                                end;
                            end;
                        else
                            local B = FindFirstChild(v.Object, "WindUIGradient");
                            if B then B:Destroy(); end;
                        end;
                    end;
                end; if r then
                    local v = p.Objects[r]; if v then
                        ApplyTheme(v);
                    end;
                else for v, x in pairs(p.Objects) do
                        ApplyTheme(x);
                    end;
                end;
            end; function p.SetLangForObject(r)
                if p.Localization and p.Localization.Enabled then
                    local u = p.LocalizationObjects[r];
                    if not u then return; end;
                    local v, x, z = u.Object, u.TranslationId, p.Localization.Translations[p.Language]
                    if z and z[x] then v.Text = z[x]; else
                        local A = p.Localization and p.Localization.Translations and p.Localization.Translations.en or nil
                        if A and A[x] then v.Text = A[x]; else
                            v.Text = "[" .. x .. "]";
                        end;
                    end;
                end;
            end; function p.ChangeTranslationKey(r, u, v)
                if p.Localization and p.Localization.Enabled then
                    local x = str.match(v, "^" .. p.Localization.Prefix .. "(.+)")
                    if x then for z, A in ipairs(p.LocalizationObjects) do
                            if A.Object == u then
                                A.TranslationId = x
                                p.SetLangForObject(z)
                                return;
                            end;
                        end; tble.insert(p.LocalizationObjects, { TranslationId = x, Object = u });
                        p.SetLangForObject(#p.LocalizationObjects);
                    end;
                end;
            end; function p.UpdateLang(r)
                if r then p.Language = r; end;
                for u = 1, #p.LocalizationObjects do
                    local v = p.LocalizationObjects[u]
                    if v.Object and v.Object.Parent ~= nil then
                        p.SetLangForObject(u);
                    else
                        p.LocalizationObjects[u] = nil;
                    end;
                end;
            end; function p.SetLanguage(r)
                p.Language = r;
                p.UpdateLang();
            end; function p.Icon(r, u)
                return l.Icon2(r, nil, u ~= false);
            end; function p.AddIcons(r, u)
                return l.AddIcons(r, u);
            end; function p.New(r, u, v)
                local x = Instancen(r) for z, A in next, p.DefaultProperties[r] or {} do
                    x[z] = A;
                end; local parentObj = nil; for B, C in next, u or {} do
                    if B == "Parent" then parentObj = C; continue; end;
                    if B ~= "ThemeTag" then x[B] = C; end;
                    if p.Localization and p.Localization.Enabled and B == "Text" then
                        local F = str.match(C, "^" .. p.Localization.Prefix .. "(.+)");
                        if F then
                            local G = #p.LocalizationObjects + 1;
                            p.LocalizationObjects[G] = {TranslationId = F, Object = x};
                            p.SetLangForObject(G);
                        end;
                    end;
                end; for F, G in next, v or {} do
                    G.Parent = x;
                end; if u and u.ThemeTag then
                    p.AddThemeObject(x, u.ThemeTag);
                end; if u and u.FontFace then
                    p.AddFontObject(x);
                end; if parentObj then x.Parent = parentObj; end; return x;
            end; function p.NewRoundFrame(r, u, v, x, B, C)
                local function getImageForType(F) return p.Shapes[F]; end;
                local function getSliceCenterForType(F) return F ~= "Shadow-sm" and Rectn(256, 256, 256, 256) or Rectn(512, 512, 512, 512); end;
                local F = p.New( B and "ImageButton" or "ImageLabel", {
                    Image = getImageForType(u),
                    ScaleType = "Slice",
                    SliceCenter = getSliceCenterForType(u),
                    SliceScale = 1,
                    BackgroundTransparency = 1,
                    ThemeTag = v.ThemeTag and v.ThemeTag
                }, x); local parentObj = nil; for G, H in pairs(v or {}) do
                    if G == "Parent" then parentObj = H; continue; end;
                    if G ~= "ThemeTag" then
                        F[G] = H;
                    end;
                end; if parentObj then F.Parent = parentObj; end; local function UpdateSliceScale(J)
                    local L = u ~= "Shadow-sm" and (J / (256)) or (J / 512);
                    F.SliceScale = math.max(L, 0.0001);
                end; local J = {}; function J.SetRadius(L, M)
                    UpdateSliceScale(M);
                end; function J.SetType(L, M)
                    u = M;
                    F.Image = getImageForType(M);
                    F.SliceCenter = getSliceCenterForType(M);
                    UpdateSliceScale(r);
                end; function J.UpdateShape(L, M, N)
                    if N then
                        u = N; F.Image = getImageForType(N);
                        F.SliceCenter = getSliceCenterForType(N);
                    end; if M then r = M; end;
                    UpdateSliceScale(r);
                end; function J.GetRadius(L)
                    return r;
                end; function J.GetType(L)
                    return u;
                end; UpdateSliceScale(r)
                return F, C and J or nil;
            end; local r = p.New;
            function p.SetDraggable(v)
                p.CanDraggable = v;
            end; function p.Drag(v, x, B)
                local C, F, G, H = nil, nil, nil, nil;
                local J = {CanDraggable = true};
                if not x or typeof(x) ~= "table" then
                    x = {v};
                end; local function update(L)
                    if not F or not J.CanDraggable then return; end;
                    local M = L.Position - G;
                    if not isFirstLoad then
                        TwCreate(TweenService, v, TwInfo(0.02), {
                            Position = Dim2(H.X.Scale, H.X.Offset + M.X, H.Y.Scale, H.Y.Offset + M.Y)
                        }):Play();
                    else
                        v.Position = Dim2(H.X.Scale, H.X.Offset + M.X, H.Y.Scale, H.Y.Offset + M.Y);
                    end;
                end; for L, M in pairs(x) do
                    M.InputBegan:Connect(function(N)
                        if (N.UserInputType == Enum.UserInputType.MouseButton1 or N.UserInputType == Enum.UserInputType.Touch) and J.CanDraggable then
                            if C == nil then
                                C = M; F = true; G = N.Position; H = v.Position;
                                if B and typeof(B) == "function" then B(true, C); end;
                                N.Changed:Connect(function()
                                    if N.UserInputState == Enum.UserInputState.End then
                                        F = false; C = nil; if B and typeof(B) == "function" then
                                            B(false, nil);
                                        end;
                                    end;
                                end);
                            end;
                        end;
                    end); M.InputChanged:Connect(function(N)
                        if F and C == M then
                            if N.UserInputType == Enum.UserInputType.MouseMovement or N.UserInputType == Enum.UserInputType.Touch then
                                return update(N);
                            end;
                        end;
                    end);
                end; UIS.InputChanged:Connect(function(N)
                    if F and C ~= nil then
                        if N.UserInputType == Enum.UserInputType.MouseMovement or N.UserInputType == Enum.UserInputType.Touch then
                            return update(N);
                        end;
                    end;
                end); function J.Set(N, O)
                    J.CanDraggable = O;
                end; return J;
            end; l.Init(r, "Icon") function p.SanitizeFilename(v)
                local x = v:match"([^/]+)$" or v;
                x = x:gsub("%.[^%.]+$", "");
                x = x:gsub("[^%w%-_]", "_");
                if #x > 50 then x = x:sub(1, 50); end;
                return x;
            end; function p.Image(v, x, B, C, F, G, H, J)
                C = C or "Temp"; x = p.SanitizeFilename(x);
                local L = r("Frame", { Size = DIM0000, BackgroundTransparency = 1},
                    {
                        r( "ImageLabel", {
                            Size = DIM1010,
                            BackgroundTransparency = 1,
                            ScaleType = "Crop",
                            ThemeTag = (p.Icon(v) or H) and { ImageColor3 = G and (J or "Icon") or nil } or nil
                        },
                        { r( "UICorner", {CornerRadius = Dim(0, B)});
                    }
                )}); if p.Icon(v) then
                    L.ImageLabel:Destroy();  local M = l.Image({
                        Icon = v,
                        Size = DIM1010,
                        Colors = {(G and (J or "Icon") or false), "Button"}
                    }).IconFrame; M.Parent = L;
                elseif str.find(v, "http") then
                    local M = "WindUI/" .. C .. "/assets/." .. F .. "-" .. x .. ".png";
                    local N, O = pcall(function()
                        tk.spawn(function()
                            local N = Request({Url = v, Method = "GET"}).Body; writefile(M, N);
                            local O, P = pcall(getcustomasset, M);
                            if O then L.ImageLabel.Image = P; else
                                return L:Destroy();
                            end;
                        end);
                    end); if not N then return L:Destroy(); end;
                elseif v == "" then
                    L.Visible = false;
                else
                    L.ImageLabel.Image = v;
                end; return L;
            end; function p.Color3ToHSB(v)
                local x, B, C = v.R, v.G, v.B;
                local F, G = math.max(x, B, C), math.min(x, B, C);
                local H, J = F - G, 0;
                if H ~= 0 then
                    if F == x then
                        J = (B - C) / H % 6;
                    elseif F == B then
                        J = (C - x) / H + 2;
                    else
                        J = (x - B) / H + 4;
                    end;
                    J = J * 60;
                else
                    J = 0;
                end; local L,M = (F == 0) and 0 or (H / F), F;
                return {h = math.floor(J + 0.5), s = L, b = M}
            end; function p.GetPerceivedBrightness(v)
                local x,B,C = v.R, v.G, v.B;
                return 0.299 * x + 0.587 * B + 0.114 * C;
            end; function p.GetTextColorForHSB(v)
                local x = p.Color3ToHSB(v); local B, C, F = x.h, x.s, x.b;
                if p.GetPerceivedBrightness(v) > 0.68 then
                    return fromHSV(B / 360, 0, 0.05);
                else
                    return fromHSV(B / 360, 0, 0.98);
                end;
            end; function p.GetAverageColor(v)
                local x, B, C = 0, 0, 0;
                local F = v.Color.Keypoints;
                for G, H in ipairs(F) do
                    x = x + H.Value.R
                    B = B + H.Value.G
                    C = C + H.Value.B
                end; local J = #F;
                return fromRGB(x / J * 255, B / J * 255, C / J * 255);
            end; return p;
        end;
        function a.c()
            local b = {}; function b.New(d, e, f)
                local g = {
                    Enabled = e.Enabled or false,
                    Translations = e.Translations or {},
                    Prefix = e.Prefix or "loc:",
                    DefaultLanguage = e.DefaultLanguage or "en"
                }; f.Localization = g; return g;
            end; return b;
        end;
        function a.d()
            local b = a.load"b"; local d = b.New;
            local f = {
                Size = Dim2(0, 300, 1, -156),
                SizeLower = Dim2(0, 300, 1, -56),
                UICorner = 13,
                UIPadding = 14,
                Holder = nil,
                NotificationIndex = 0,
                Notifications = {}
            }; function f.Init(g)
                local h = {Lower = false};
                function h.SetLower(j)
                    h.Lower = j
                    h.Frame.Size = j and f.SizeLower or f.Size
                end; h.Frame = d("Frame", {
                    Position = Dim2(1, -29, 0, 56),
                    AnchorPoint = Vec2(1, 0),
                    Size = f.Size,
                    Parent = g,
                    BackgroundTransparency = 1
                }, {
                    d("UIListLayout", {
                        HorizontalAlignment = "Center",
                        SortOrder = "LayoutOrder",
                        VerticalAlignment = "Bottom",
                        Padding = Dim(0, 8)
                    }), d("UIPadding", {
                        PaddingBottom = Dim(0, 29)
                    });
                }); return h;
            end; function f.New(g)
                local h = {
                    Title = g.Title or "Notification",
                    Content = g.Content or nil,
                    Icon = g.Icon or nil,
                    IconThemed = g.IconThemed,
                    Background = g.Background,
                    BackgroundImageTransparency = g.BackgroundImageTransparency,
                    Duration = g.Duration or 5,
                    Buttons = g.Buttons or {},
                    CanClose = true,
                    UIElements = {},
                    Closed = false
                }; if h.CanClose == nil then
                    h.CanClose = true;
                end; f.NotificationIndex = f.NotificationIndex + 1;
                f.Notifications[f.NotificationIndex] = h;
                local j, l = nil, nil; if h.Icon then
                    j = b.Image(h.Icon, h.Title .. ":" .. h.Icon, 0, g.Window, "Notification", h.IconThemed);
                    j.Size = Dim2(0, 26, 0, 26);
                    j.Position = Dim2(0, f.UIPadding, 0, f.UIPadding);
                end; if h.CanClose then
                    l = d("ImageButton", {
                        Image = b.Icon "x"[1],
                        ImageRectSize = b.Icon "x"[2].ImageRectSize,
                        ImageRectOffset = b.Icon "x"[2].ImageRectPosition,
                        BackgroundTransparency = 1,
                        Size = Dim2(0, 16, 0, 16),
                        Position = Dim2(1, -f.UIPadding, 0, f.UIPadding),
                        AnchorPoint = Vec2(1, 0),
                        ThemeTag = {
                            ImageColor3 = "Text"
                        },
                        ImageTransparency = .4
                    }, {
                        d("TextButton", {
                            Size = Dim2(1, 8, 1, 8),
                            BackgroundTransparency = 1,
                            AnchorPoint = VEC05,
                            Position = DIM05,
                            Text = ""
                        });
                    });
                end; local m = d("Frame", {
                    Size = DIM0010,
                    BackgroundTransparency = .95,
                    ThemeTag = {BackgroundColor3 = "Text"}
                }); local p = d("Frame", {
                    Size = Dim2(1, h.Icon and -28 - f.UIPadding or 0, 1, 0),
                    Position = Dim2(1, 0, 0, 0),
                    AnchorPoint = Vec2(1, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = "Y"
                }, {
                    d("UIPadding", {
                        PaddingTop = Dim(0, f.UIPadding),
                        PaddingLeft = Dim(0, f.UIPadding),
                        PaddingRight = Dim(0, f.UIPadding),
                        PaddingBottom = Dim(0, f.UIPadding)
                    }), d("TextLabel", {
                        AutomaticSize = "Y",
                        Size = Dim2(1, -30 - f.UIPadding, 0, 0),
                        TextWrapped = true,
                        TextXAlignment = "Left",
                        RichText = true,
                        BackgroundTransparency = 1,
                        TextSize = 16,
                        ThemeTag = {
                            TextColor3 = "Text"
                        },
                        Text = h.Title,
                        FontFace = Fnew(b.Font, Enum.FontWeight.Medium)
                    }), d("UIListLayout", {
                        Padding = Dim(0, f.UIPadding / 3)
                    });
                }); if h.Content then
                    d("TextLabel", {
                        AutomaticSize = "Y",
                        Size = Dim2(1, 0, 0, 0),
                        TextWrapped = true,
                        TextXAlignment = "Left",
                        RichText = true,
                        BackgroundTransparency = 1,
                        TextTransparency = .4,
                        TextSize = 15,
                        ThemeTag = {TextColor3 = "Text"},
                        Text = h.Content,
                        FontFace = Fnew(b.Font, Enum.FontWeight.Medium),
                        Parent = p
                    });
                end; local r = b.NewRoundFrame(f.UICorner, "Squircle", {
                    Size = Dim2(1, 0, 0, 0),
                    Position = Dim2(2, 0, 1, 0),
                    AnchorPoint = Vec2(0, 1),
                    AutomaticSize = "Y",
                    ImageTransparency = .05,
                    ThemeTag = {ImageColor3 = "Background"}
                }, {
                    d("CanvasGroup", {
                        Size = DIM1010,
                        BackgroundTransparency = 1
                    }, {
                        m, d("UICorner", {
                            CornerRadius = Dim(0, f.UICorner)
                        })
                    }), d("ImageLabel", {
                        Name = "Background",
                        Image = h.Background,
                        BackgroundTransparency = 1,
                        Size = DIM1010,
                        ScaleType = "Crop",
                        ImageTransparency = h.BackgroundImageTransparency
                    }, {
                        d("UICorner", {
                            CornerRadius = Dim(0, f.UICorner)
                        })
                    }), p, j, l
                }); local u = d("Frame", {
                    BackgroundTransparency = 1,
                    Size = Dim2(1, 0, 0, 0),
                    Parent = g.Holder
                }, {r}); function h.Close(v)
                    if not h.Closed then
                        h.Closed = true; TwCreate(TweenService, u, TWI_Q_045, {Size = Dim2(1, 0, 0, -8)}):Play();
                        TwCreate(TweenService, r, TwInfo(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = Dim2(2, 0, 1, 0)}):Play();
                        twait(0.45); u:Destroy();
                    end;
                end; tk.spawn(function()
                    twait(); TwCreate(TweenService, u, TWI_Q_045, {Size = Dim2(1, 0, 0, r.AbsoluteSize.Y)}):Play();
                    TwCreate(TweenService, r, TWI_Q_045, {Position = DIM0010}):Play();
                    if h.Duration then
                        TwCreate(TweenService, m, TwInfo(h.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = DIM1010}):Play();
                        twait(h.Duration); h:Close();
                    end;
                end); if l then
                    b.AddSignal(l.TextButton.MouseButton1Click, function()
                        h:Close();
                    end);
                end; return h;
            end; return f;
        end; function a.i()
            return [[
    {
        "name": "windui",
        "version": "1.6.62",
        "main": "./dist/main.lua",
        "repository": "https://github.com/Footagesus/WindUI",
        "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
        "author": "Footagesus",
        "description": "Roblox UI Library for scripts",
        "license": "MIT",
        "scripts": {
            "dev": "bash build/build.sh dev $INPUT_FILE",
            "build": "bash build/build.sh build $INPUT_FILE",
            "live": "python -m http.server 8642",
            "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
            "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
            "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
            "updater": "python updater/main.py"
        },
        "keywords": [
            "ui-library",
            "ui-design",
            "script",
            "script-hub",
            "exploiting"
        ],
        "devDependencies": {
            "chokidar-cli": "^3.0.0",
            "concurrently": "^9.2.0"
        }
    }]]
        end; function a.j()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.New(ae, af, ag, ah, ai, aj, ak, al)
                ah = ah or "Primary"; local am, an = al or (not ak and 10 or 99), nil;
                if af and af ~= "" then
                    an = ac("ImageLabel", {
                        Image = ab.Icon(af)[1],
                        ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                        ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                        Size = Dim2(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ImageColor3 = ah == "White" and BLACK or nil,
                        ImageTransparency = ah == "White" and .4 or 0,
                        ThemeTag = {ImageColor3 = ah ~= "White" and "Icon" or nil}
                    });
                end; local ao = ac("TextButton", {
                    Size = DIM0010,
                    AutomaticSize = "X",
                    Parent = ai,
                    BackgroundTransparency = 1
                }, {
                    ab.NewRoundFrame(am, "Squircle", {
                        ThemeTag = {ImageColor3 = ah ~= "White" and "Button" or nil},
                        ImageColor3 = ah == "White" and WHITE or nil,
                        Size = DIM1010,
                        Name = "Squircle",
                        ImageTransparency = ah == "Primary" and 0 or ah == "White" and 0 or 1
                    }), ab.NewRoundFrame(am, "Squircle", {
                        ImageColor3 = WHITE,
                        Size = DIM1010,
                        Name = "Special",
                        ImageTransparency = ah == "Secondary" and 0.95 or 1
                    }), ab.NewRoundFrame(am, "Shadow-sm", {
                        ImageColor3 = BLACK,
                        Size = Dim2(1, 3, 1, 3),
                        AnchorPoint = VEC05,
                        Position = DIM05,
                        Name = "Shadow",
                        ImageTransparency = 1,
                        Visible = not ak
                    }), ab.NewRoundFrame(am, not ak and "SquircleOutline" or "SquircleOutline2", {
                        ThemeTag = {ImageColor3 = ah ~= "White" and "Outline" or nil},
                        Size = DIM1010, ImageColor3 = ah == "White" and BLACK or nil,
                        ImageTransparency = ah == "Primary" and .95 or .85,
                        Name = "SquircleOutline"
                    }, {
                        ac("UIGradient", {
                            Rotation = 70,
                            Color = CSnew {
                                CSKnew(0.0, WHITE),
                                CSKnew(0.5, WHITE),
                                CSKnew(1.0, WHITE)
                            },
                            Transparency = NSnew {
                                NSKnew(0.0, 0.1),
                                NSKnew(0.5, 1),
                                NSKnew(1.0, 0.1)
                            };
                        });
                    }), ab.NewRoundFrame(am, "Squircle", {
                        Size = DIM1010, Name = "Frame",
                        ThemeTag = {ImageColor3 = ah ~= "White" and "Text" or nil},
                        ImageColor3 = ah == "White" and BLACK or nil,
                        ImageTransparency = 1
                    }, {
                        ac("UIPadding", {
                            PaddingLeft = Dim(0, 16),
                            PaddingRight = Dim(0, 16)
                        }), ac("UIListLayout", {
                            FillDirection = "Horizontal",
                            Padding = Dim(0, 8),
                            VerticalAlignment = "Center",
                            HorizontalAlignment = "Center"
                        }), an, ac("TextLabel", {
                            BackgroundTransparency = 1, FontFace = Fnew(ab.Font, Enum.FontWeight.SemiBold), Text = ae or "Button",
                            ThemeTag = {TextColor3 = (ah ~= "Primary" and ah ~= "White") and "Text"},
                            TextColor3 = ah == "Primary" and WHITE or ah == "White" and BLACK or nil,
                            AutomaticSize = "XY",
                            TextSize = 18
                        });
                    });
                }); ab.AddSignal(ao.MouseEnter, function()
                    TwCreate(TweenService, ao.Frame, TwInfo(0.047), {ImageTransparency = 0.95}):Play();
                end); ab.AddSignal(ao.MouseLeave, function()
                    TwCreate(TweenService, ao.Frame, TwInfo(0.047), {ImageTransparency = 1}):Play();
                end); ab.AddSignal(ao.MouseButton1Up, function()
                    if aj then aj:Close()(); end;
                    if ag then ab.SafeCallback(ag); end;
                end); return ao;
            end; return aa;
        end;
        function a.k()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.New(ae, af, ag, ah, ai, aj, ak, al)
                ah = ah or "Input"; local am, an = ak or 10, nil;
                if af and af ~= "" then
                    an = ac("ImageLabel", {
                        Image = ab.Icon(af)[1],
                        ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                        ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                        Size = Dim2(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ThemeTag = {ImageColor3 = "Icon"}
                    });
                end; local ao = ah ~= "Input";
                local ap = ac("TextBox", {
                    BackgroundTransparency = 1,
                    TextSize = 17,
                    FontFace = Fnew(ab.Font, Enum.FontWeight.Regular),
                    Size = Dim2(1, an and -29 or 0, 1, 0),
                    PlaceholderText = ae,
                    ClearTextOnFocus = al or false,
                    ClipsDescendants = true,
                    TextWrapped = ao,
                    MultiLine = ao,
                    TextXAlignment = "Left",
                    TextYAlignment = ah == "Input" and "Center" or "Top",
                    ThemeTag = {PlaceholderColor3 = "PlaceholderText", TextColor3 = "Text"}
                }); local aq = ac("Frame", {
                    Size = Dim2(1, 0, 0, 42),
                    Parent = ag,
                    BackgroundTransparency = 1
                }, {
                    ac("Frame", {
                        Size = DIM1010,
                        BackgroundTransparency = 1
                    }, {
                        ab.NewRoundFrame(am, "Squircle", {
                            ThemeTag = {
                                ImageColor3 = "Accent"
                            },
                            Size = DIM1010,
                            ImageTransparency = 0.97
                        }), ab.NewRoundFrame(am, "SquircleOutline", {
                            ThemeTag = {
                                ImageColor3 = "Outline"
                            },
                            Size = DIM1010,
                            ImageTransparency = 0.95
                        }, {}), ab.NewRoundFrame(am, "Squircle", {
                            Size = DIM1010,
                            Name = "Frame",
                            ImageColor3 = WHITE,
                            ImageTransparency = 0.95
                        }, {
                            ac("UIPadding", {
                                PaddingTop = Dim(0, ah == "Input" and 0 or 12),
                                PaddingLeft = Dim(0, 12),
                                PaddingRight = Dim(0, 12),
                                PaddingBottom = Dim(0, ah == "Input" and 0 or 12)
                            }), ac("UIListLayout", {
                                FillDirection = "Horizontal",
                                Padding = Dim(0, 8),
                                VerticalAlignment = ah == "Input" and "Center" or "Top",
                                HorizontalAlignment = "Left"
                            }), an, ap
                        });
                    });
                }); if aj then
                    ab.AddSignal(PropChangeSignal(ap, "Text"), function()
                        if ai then
                            ab.SafeCallback(ai, ap.Text);
                        end;
                    end);
                else
                    ab.AddSignal(ap.FocusLost, function()
                        if ai then
                            ab.SafeCallback(ai, ap.Text);
                        end;
                    end);
                end; return aq;
            end; return aa;
        end;
        function a.l()
            local aa = a.load"b"; local ab = aa.New; local ad = {
                Holder = nil,
                Parent = nil
            }; function ad.Init(ae, af)
                Window = ae; ad.Parent = af;
                return ad;
            end; function ad.Create(ae, af)
                local ag = {UICorner = 24, UIPadding = 15, UIElements = {}};
                if ae then ag.UIPadding = 0; end; if ae then ag.UICorner = 26; end;
                af = af or "Dialog"; if not ae then
                    ag.UIElements.FullScreen = ab("Frame", {
                        ZIndex = 999,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = fromHex "#000000",
                        Size = DIM1010,
                        Active = false,
                        Visible = false,
                        Parent = ad.Parent or (Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main)
                    }, {
                        ab("UICorner", {
                            CornerRadius = Dim(0, (Window and Window.UICorner) or Instancen("UICorner"))
                        });
                    });
                end; ag.UIElements.Main = ab("Frame", {
                    Size = Dim2(0, 280, 0, 0),
                    ThemeTag = {
                        BackgroundColor3 = af .. "Background"
                    },
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1,
                    Visible = false,
                    ZIndex = 99999
                }, {
                    ab("UIPadding", {
                        PaddingTop = Dim(0, ag.UIPadding),
                        PaddingLeft = Dim(0, ag.UIPadding),
                        PaddingRight = Dim(0, ag.UIPadding),
                        PaddingBottom = Dim(0, ag.UIPadding)
                    });
                }); ag.UIElements.MainContainer = aa.NewRoundFrame(ag.UICorner, "Squircle", {
                    Visible = false,
                    ImageTransparency = ae and 0.15 or 0,
                    Parent = ae and ad.Parent or ag.UIElements.FullScreen,
                    Position = DIM05,
                    AnchorPoint = VEC05,
                    AutomaticSize = "XY",
                    ThemeTag = {
                        ImageColor3 = af .. "Background",
                        ImageTransparency = af .. "BackgroundTransparency"
                    },
                    ZIndex = 9999
                }, {ag.UIElements.Main}); function ag.Open(ah)
                    if not ae then
                        ag.UIElements.FullScreen.Visible = true;
                        ag.UIElements.FullScreen.Active = true;
                    end; tk.spawn(function()
                        ag.UIElements.MainContainer.Visible = true; if not ae then
                            TwCreate(TweenService, ag.UIElements.FullScreen, TWI_01, {BackgroundTransparency = 0.3}):Play();
                        end; TwCreate(TweenService, ag.UIElements.MainContainer, TWI_01, {ImageTransparency = 0}):Play();
                        tk.spawn(function()
                            twait(0.05); ag.UIElements.Main.Visible = true;
                        end);
                    end);
                end; function ag.Close(ah)
                    if not ae then
                        TwCreate(TweenService, ag.UIElements.FullScreen, TWI_01, {BackgroundTransparency = 1}):Play();
                        ag.UIElements.FullScreen.Active = false; tk.spawn(function()
                            twait(0.1); ag.UIElements.FullScreen.Visible = false;
                        end);
                    end; ag.UIElements.Main.Visible = false;
                    TwCreate(TweenService, ag.UIElements.MainContainer, TWI_01, {ImageTransparency = 1}):Play();
                    tk.spawn(function()
                        twait(0.1) if not ae then
                            ag.UIElements.FullScreen:Destroy();
                        else
                            ag.UIElements.MainContainer:Destroy();
                        end;
                    end); return function() end;
                end; return ag;
            end; return ad;
        end;
        function a.n()
            local function map(ab, ac, ad, ae, af)
                return (ab - ac) * (af - ae) / (ad - ac) + ae;
            end; local function viewportPointToWorld(ab, ac)
                local ad = Cam:ScreenPointToRay(ab.X, ab.Y);
                return ad.Origin + ad.Direction * ac;
            end; local function getOffset()
                local ab = Cam.ViewportSize.Y;
                return map(ab, 0, 2560, 8, 56);
            end; return {viewportPointToWorld, getOffset};
        end;
        function a.o()
            local ab = a.load "b"; local ac = ab.New;
            
            local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
                local n = planeNormal
                local d = rayDirection
                local v = rayOrigin - planePos
                local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z)
                local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z)
                local a = -num / den
                return rayOrigin + (a * rayDirection), a
            end

            return function(ag)
                local ah = {};
                local ak = ac("Frame", {
                    BackgroundTransparency = 1,
                    Size = Dim2Scale(1, 1)
                });
                
                local Part = Instancen('Part', Workspace)
                Part.Name = "TTJY_AcrylicPart"
                local DepthOfField = Instancen('DepthOfFieldEffect', Lighting)
                local SurfaceGui = Instancen('SurfaceGui', Part)
                local BlockMesh = Instancen("BlockMesh")
                BlockMesh.Parent = Part;

                Part.Material = Enum.Material.Glass
                Part.Transparency = 0.99
                Part.Reflectance = 1
                Part.CastShadow = false
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.Size = Vec3(1, 1, 1) * 0.01
                Part.Color = BLACK

                DepthOfField.Enabled = true
                DepthOfField.FarIntensity = 1
                DepthOfField.FocusDistance = 0
                DepthOfField.InFocusRadius = 500
                DepthOfField.NearIntensity = 1

                SurfaceGui.AlwaysOnTop = true
                SurfaceGui.Adornee = Part
                SurfaceGui.Active = true
                SurfaceGui.Face = Enum.NormalId.Front
                SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

                local ScreenPointToRay = Cam.ScreenPointToRay;

                local render = function()
                    if not Cam then return; end;
                    DepthOfField.Enabled = true
                    local corner0 = ak.AbsolutePosition
                    local corner1 = corner0 + ak.AbsoluteSize
                    local ray0 = ScreenPointToRay(Cam, corner0.X, corner0.Y, 1)
                    local ray1 = ScreenPointToRay(Cam, corner1.X, corner1.Y, 1)
                    local planeOrigin = Cam.CFrame.Position + Cam.CFrame.LookVector * (0.05 - Cam.NearPlaneZ)
                    local planeNormal = Cam.CFrame.LookVector
                    local pos0, _ = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
                    local pos1, _ = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);
                    pos0 = Cam.CFrame:PointToObjectSpace(pos0);
                    pos1 = Cam.CFrame:PointToObjectSpace(pos1);
                    local size = pos1 - pos0;
                    local center = (pos0 + pos1) / 2;
                    BlockMesh.Offset = center;
                    BlockMesh.Scale = size / 0.0101;
                    Part.CFrame = Cam.CFrame;
                end;
                
                local conn = RunService.RenderStepped:Connect(render);
                
                Part.Destroying:Connect(function()
                    if conn then conn:Disconnect() end
                    pcall(function() DepthOfField:Destroy() end)
                    pcall(function() SurfaceGui:Destroy() end)
                end)
                
                ah.AddParent = function(al)
                    ab.AddSignal(PropChangeSignal(al, "Visible"), function()
                        ah.SetVisibility(al.Visible);
                    end);
                end;
                
                ah.SetVisibility = function(al)
                    Part.Transparency = al and 0.99 or 1;
                    DepthOfField.Enabled = al;
                end;
                
                ah.Frame = ak;
                ah.Model = Part;
                
                return ah;
            end;
        end;
        function a.p()
            local aa = a.load "b"; local ab = a.load "o";
            local ac = aa.New; return function(ad)
                local ae = {}; ae.Frame = ac("Frame", {
                    Size = Dim2Scale(1, 1),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = WHITE,
                    BorderSizePixel = 0
                }, {
                    ac("UICorner", {
                        CornerRadius = Dim(0, 8)
                    }), ac("Frame", {
                        BackgroundTransparency = 1,
                        Size = Dim2Scale(1, 1),
                        Name = "Background",
                        ThemeTag = {
                            BackgroundColor3 = "AcrylicMain"
                        }
                    }, {
                        ac("UICorner", {
                            CornerRadius = Dim(0, 8)
                        });
                    }), ac("Frame", {
                        BackgroundColor3 = WHITE,
                        BackgroundTransparency = 1,
                        Size = Dim2Scale(1, 1)
                    }, {}), ac("ImageLabel", {
                        Image = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://9968344105",
                        ImageTransparency = 0.98,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = Dim2(0, 128, 0, 128),
                        Size = Dim2Scale(1, 1),
                        BackgroundTransparency = 1
                    }, {
                        ac("UICorner", {
                            CornerRadius = Dim(0, 8)
                        });
                    }), ac("ImageLabel", {
                        Image = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://9968344227",
                        ImageTransparency = 0.9,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = Dim2(0, 128, 0, 128),
                        Size = Dim2Scale(1, 1),
                        BackgroundTransparency = 1,
                        ThemeTag = {ImageTransparency = "AcrylicNoise"}
                    }, {
                        ac("UICorner", {
                            CornerRadius = Dim(0, 8)
                        });
                    }), ac("Frame", {
                        BackgroundTransparency = 1,
                        Size = Dim2Scale(1, 1),
                        ZIndex = 2
                    }, {});
                }); local af=nil; twait()
                if ad.UseAcrylic then
                    af = ab(); af.Frame.Parent = ae.Frame;
                    ae.Model = af.Model ae.AddParent = af.AddParent;
                    ae.SetVisibility = af.SetVisibility;
                end; return ae, af;
            end;
        end;
        function a.q()
            local ab = {AcrylicBlur = a.load "o", AcrylicPaint = a.load "p"};
            function ab.init()
                function ab.Enable() end;
                function ab.Disable() end;
            end; return ab;
        end;
        function a.r()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.new(ae)
                local af = {
                    Title = ae.Title or "Dialog", Content = ae.Content, Icon = ae.Icon,
                    IconThemed = ae.IconThemed, Thumbnail = ae.Thumbnail, Buttons = ae.Buttons, IconSize = 22
                }; local ag = a.load("l").Init(nil, ae.WindUI.ScreenGui.Popups);
                local ah = ag.Create(true, "Popup"); local ai, ak = 200, nil; local aj = 430;
                if af.Thumbnail and af.Thumbnail.Image then
                    aj = 430 + (ai / 2);
                end; ah.UIElements.Main.AutomaticSize = "Y";
                ah.UIElements.Main.Size = Dim2(0, aj, 0, 0);
                if af.Icon then
                    ak = ab.Image(
                        af.Icon, af.Title .. ":" .. af.Icon, 0,
                        ae.WindUI.Window, "Popup", true,
                        ae.IconThemed, "PopupIcon"
                    ) ak.Size = Dim2(0, af.IconSize, 0, af.IconSize)
                    ak.LayoutOrder = -1;
                end; local al = ac("TextLabel", {
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1,
                    Text = af.Title,
                    TextXAlignment = "Left",
                    FontFace = Fnew(ab.Font, Enum.FontWeight.SemiBold),
                    ThemeTag = {TextColor3 = "PopupTitle"},
                    TextSize = 20,
                    TextWrapped = true,
                    Size = Dim2(1, ak and -af.IconSize - 14 or 0, 0, 0)
                }); local am = ac("Frame", {
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY"
                }, {
                    ac("UIListLayout", {
                        Padding = Dim(0, 14),
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center"
                    }), ak, al
                }); local an = ac("Frame", {
                    AutomaticSize = "Y",
                    Size = Dim2(1, 0, 0, 0),
                    BackgroundTransparency = 1
                },{am}); local ao=nil;
                if af.Content and af.Content ~= "" then
                    ao = ac("TextLabel", {
                        Size = Dim2(1, 0, 0, 0),
                        AutomaticSize = "Y",
                        FontFace = Fnew(ab.Font, Enum.FontWeight.Medium),
                        TextXAlignment = "Left",
                        Text = af.Content,
                        TextSize = 18,
                        TextTransparency = .2,
                        ThemeTag = {TextColor3 = "PopupContent"},
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextWrapped = true
                    });
                end; local ap = ac("Frame", {
                    Size = Dim2(1, 0, 0, 42),
                    BackgroundTransparency = 1
                }, {
                    ac("UIListLayout", {
                        Padding = Dim(0, 9),
                        FillDirection = "Horizontal",
                        HorizontalAlignment = "Right"
                    });
                }); local aq, ar=nil, nil;
                if af.Thumbnail and af.Thumbnail.Image then
                    if af.Thumbnail.Title then
                        ar = ac("TextLabel", {
                            Text = af.Thumbnail.Title,
                            ThemeTag = {TextColor3 = "Text"},
                            TextSize = 18,
                            FontFace = Fnew(ab.Font, Enum.FontWeight.Medium),
                            BackgroundTransparency = 1,
                            AutomaticSize = "XY",
                            AnchorPoint = VEC05,
                            Position = DIM05
                        });
                    end; aq = ac("ImageLabel", {
                        Image = af.Thumbnail.Image,
                        BackgroundTransparency = 1,
                        Size = Dim2(0, ai, 1, 0),
                        Parent = ah.UIElements.Main,
                        ScaleType = "Crop"
                    }, {
                        ar, ac("UICorner", {
                            CornerRadius = Dim(0, 0)
                        });
                    });
                end; ac("Frame", {
                    Size = Dim2(1, aq and -ai or 0, 1, 0),
                    Position = Dim2(0, aq and ai or 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ah.UIElements.Main
                }, {
                    ac("Frame", {
                        Size = DIM1010,
                        BackgroundTransparency = 1
                    }, {
                        ac("UIListLayout", {
                            Padding = Dim(0, 18),
                            FillDirection = "Vertical"
                        }), an, ao, ap, ac("UIPadding", {
                            PaddingTop = Dim(0, 16),
                            PaddingLeft = Dim(0, 16),
                            PaddingRight = Dim(0, 16),
                            PaddingBottom = Dim(0, 16)
                        });
                    });
                }); local ar = a.load("j").New;
                for as, at in next, af.Buttons do
                    ar(at.Title, at.Icon, at.Callback, at.Variant, ap, ah);
                end; ah:Open(); return af;
            end; return aa;
        end;
        function a.s()
            return function(aa)
                return {
                    Dark = {
                        Name = "Dark",
                        
                        Accent = aa:Gradient({
                            ["0"] = { Color = Color3.fromHex("#800000"), Transparency = 0 },   -- Deep Pulse
                            ["50"] = { Color = Color3.fromHex("#ff003c"), Transparency = 0 },  -- Cyber Neon (Shine)
                            ["100"] = { Color = Color3.fromHex("#800000"), Transparency = 0 }, -- Deep Pulse
                        }, { Rotation = 90 }),

                        Background = aa:Gradient({
                            ["0"] = { Color = Color3.fromHex("#08080c"), Transparency = 0.1 },
                            ["100"] = { Color = Color3.fromHex("#121220"), Transparency = 0.08 },
                        }, { Rotation = 45 }),
                        
                        BackgroundTransparency = 0.1,
                        Outline = Color3.fromHex("#ff003c"), 
                        Text = Color3.fromHex("#ffffff"),
                        Placeholder = Color3.fromHex("#73738c"),
                        
                        Button = Color3.fromHex("#ff003c"),
                        Icon = Color3.fromHex("#ffffff"),
                        
                        Hover = Color3.fromHex("#ffffff"),
                        
                        WindowBackground = Color3.fromHex("#000000"),
                        WindowShadow = Color3.fromHex("#000000"),
                        WindowTopbarButtonIcon = Color3.fromHex("#ff4d4d"),
                        WindowTopbarTitle = Color3.fromHex("#ffffff"),
                        WindowTopbarAuthor = Color3.fromHex("#ff003c"),
                        WindowTopbarIcon = Color3.fromHex("#ffffff"),
                        
                        DialogBackground = Color3.fromHex("#0f0f14"),
                        DialogBackgroundTransparency = 0.05,
                        DialogTitle = Color3.fromHex("#ffffff"),
                        DialogContent = Color3.fromHex("#d0d0d0"),
                        DialogIcon = Color3.fromHex("#ff003c"),
                        
                        PopupBackground = Color3.fromHex("#0f0f14"),
                        PopupBackgroundTransparency = 0.05,
                        PopupTitle = Color3.fromHex("#ffffff"),
                        PopupContent = Color3.fromHex("#d0d0d0"),
                        PopupIcon = Color3.fromHex("#ff003c"),
                        
                        TabBackground = Color3.fromHex("#ff003c"),
                        TabTitle = Color3.fromHex("#ffffff"),
                        TabIcon = Color3.fromHex("#ffffff"),
                        
                        ElementBackground = aa:Gradient({                                                      
                            ["0"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
                            ["80"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },         
                            ["100"]   = { Color = Color3.fromHex("#ffffff"), Transparency = 0.2 },      
                        }, {                                                                            
                            Rotation = 180,                                                               
                        }), 
                        ElementTitle = Color3.fromHex("#ffffff"),
                        ElementDesc = Color3.fromHex("#a0b0b0"),
                        ElementIcon = Color3.fromHex("#ff003c"),

                        PageBackgroundTransparency = 1,
                        GroupBackgroundTransparency = 0.93,
                        GroupBackground = Color3.fromRGB(117, 117, 117),
                        
                        Toggle = Color3.fromHex("#ff003c"),
                        ToggleBar = Color3.fromHex("#ffffff"),
                        
                        Checkbox = Color3.fromHex("#ff003c"),
                        CheckboxIcon = Color3.fromHex("#ffffff"),
                        
                        Slider = Color3.fromHex("#ff003c"),
                        SliderThumb = Color3.fromHex("#ffffff"),
                    }, Light = {
                        Name = "Light",
                        Accent = fromHex "#FFFFFF",
                        Dialog = fromHex "#f4f4f5",
                        Outline = fromHex "#09090b",
                        Text = fromHex "#000000",
                        Placeholder = fromHex "#555555",
                        Background = fromHex "#e4e4e7",
                        Button = fromHex "#18181b",
                        Icon = fromHex "#52525b"
                    }, Rose = {
                        Name = "Rose",
                        Accent = fromHex "#be185d",
                        Dialog = fromHex "#4c0519",
                        Outline = fromHex "#fecdd3",
                        Text = fromHex "#fdf2f8",
                        Placeholder = fromHex "#d67aa6",
                        Background = fromHex "#1f0308",
                        Button = fromHex "#e11d48",
                        Icon = fromHex "#fb7185"
                    }, Plant = {
                        Name = "Plant",
                        Accent = fromHex "#166534",
                        Dialog = fromHex "#052e16",
                        Outline = fromHex "#bbf7d0",
                        Text = fromHex "#f0fdf4",
                        Placeholder = fromHex "#4fbf7a",
                        Background = fromHex "#0a1b0f",
                        Button = fromHex "#16a34a",
                        Icon = fromHex "#4ade80"
                    }, Red = {
                        Name = "Red",
                        Accent = fromHex "#991b1b",
                        Dialog = fromHex "#450a0a",
                        Outline = fromHex "#fecaca",
                        Text = fromHex "#fef2f2",
                        Placeholder = fromHex "#d95353",
                        Background = fromHex "#1c0606",
                        Button = fromHex "#dc2626",
                        Icon = fromHex "#ef4444"
                    }, Indigo = {
                        Name = "Indigo",
                        Accent = fromHex "#3730a3",
                        Dialog = fromHex "#1e1b4b",
                        Outline = fromHex "#c7d2fe",
                        Text = fromHex "#f1f5f9",
                        Placeholder = fromHex "#7078d9",
                        Background = fromHex "#0f0a2e",
                        Button = fromHex "#4f46e5",
                        Icon = fromHex "#6366f1"
                    }, Sky = {
                        Name = "Sky",
                        Accent = fromHex "#0369a1",
                        Dialog = fromHex "#0c4a6e",
                        Outline = fromHex "#bae6fd",
                        Text = fromHex "#f0f9ff",
                        Placeholder = fromHex "#4fb6d9",
                        Background = fromHex "#041f2e",
                        Button = fromHex "#0284c7",
                        Icon = fromHex "#0ea5e9"
                    }, Violet = {
                        Name = "Violet",
                        Accent = fromHex "#6d28d9",
                        Dialog = fromHex "#3c1361",
                        Outline = fromHex "#ddd6fe",
                        Text = fromHex "#faf5ff",
                        Placeholder = fromHex "#8f7ee0",
                        Background = fromHex "#1e0a3e",
                        Button = fromHex "#7c3aed",
                        Icon = fromHex "#8b5cf6"
                    }, Amber = {
                        Name = "Amber",
                        Accent = fromHex "#b45309",
                        Dialog = fromHex "#451a03",
                        Outline = fromHex "#fde68a",
                        Text = fromHex "#fffbeb",
                        Placeholder = fromHex "#d1a326",
                        Background = fromHex "#1c1003",
                        Button = fromHex "#d97706",
                        Icon = fromHex "#f59e0b"
                    }, Emerald = {
                        Name = "Emerald",
                        Accent = fromHex "#047857",
                        Dialog = fromHex "#022c22",
                        Outline = fromHex "#a7f3d0",
                        Text = fromHex "#ecfdf5",
                        Placeholder = fromHex "#3fbf8f",
                        Background = fromHex "#011411",
                        Button = fromHex "#059669",
                        Icon = fromHex "#10b981"
                    }, Midnight = {
                        Name = "Midnight",
                        Accent = fromHex "#1e3a8a",
                        Dialog = fromHex "#0c1e42",
                        Outline = fromHex "#bfdbfe",
                        Text = fromHex "#dbeafe",
                        Placeholder = fromHex "#2f74d1",
                        Background = fromHex "#0a0f1e",
                        Button = fromHex "#2563eb",
                        Icon = fromHex "#3b82f6"
                    }, Crimson = {
                        Name = "Crimson",
                        Accent = fromHex "#b91c1c",
                        Dialog = fromHex "#450a0a",
                        Outline = fromHex "#fca5a5",
                        Text = fromHex "#fef2f2",
                        Placeholder = fromHex "#6f757b",
                        Background = fromHex "#0c0404",
                        Button = fromHex "#991b1b",
                        Icon = fromHex "#dc2626"
                    }, MonokaiPro = {
                        Name = "Monokai Pro",
                        Accent = fromHex "#fc9867",
                        Dialog = fromHex "#1e1e1e",
                        Outline = fromHex "#78dce8",
                        Text = fromHex "#fcfcfa",
                        Placeholder = fromHex "#6f6f6f",
                        Background = fromHex "#191622",
                        Button = fromHex "#ab9df2",
                        Icon = fromHex "#a9dc76"
                    }, CottonCandy = {
                        Name = "Cotton Candy",
                        Accent = fromHex "#ec4899",
                        Dialog = fromHex "#2d1b3d",
                        Outline = fromHex "#f9a8d4",
                        Text = fromHex "#fdf2f8",
                        Placeholder = fromHex "#8a5fd3",
                        Background = fromHex "#1a0b2e",
                        Button = fromHex "#d946ef",
                        Icon = fromHex "#06b6d4"
                    }, Rainbow = {
                        Name = "Rainbow", Accent = aa:Gradient({
                            ["0"] = {Color = fromHex "#00ff41", Transparency = 0},
                            ["33"] = {Color = fromHex "#00ffff", Transparency = 0},
                            ["66"] = {Color = fromHex "#0080ff", Transparency = 0},
                            ["100"] = {Color = fromHex "#8000ff", Transparency = 0}
                        }, {Rotation = 45}), Dialog = aa:Gradient({
                            ["0"] = {Color = fromHex "#ff0080", Transparency = 0},
                            ["25"] = {Color = fromHex "#8000ff", Transparency = 0},
                            ["50"] = {Color = fromHex "#0080ff", Transparency = 0},
                            ["75"] = {Color = fromHex "#00ff80", Transparency = 0},
                            ["100"] = {Color = fromHex "#ff8000", Transparency = 0}
                        }, {Rotation = 135}), Outline = fromHex "#ffffff", Text = fromHex "#ffffff",
                        Placeholder = fromHex "#00ff80", Background = aa:Gradient({
                            ["0"] = {Color = fromHex "#ff0040", Transparency = 0},
                            ["20"] = {Color = fromHex "#ff4000", Transparency = 0},
                            ["40"] = {Color = fromHex "#ffff00", Transparency = 0},
                            ["60"] = {Color = fromHex "#00ff40", Transparency = 0},
                            ["80"] = {Color = fromHex "#0040ff", Transparency = 0},
                            ["100"] = {Color = fromHex "#4000ff", Transparency = 0}
                        }, {Rotation = 90}), Button = aa:Gradient({
                            ["0"] = {Color = fromHex "#ff0080", Transparency = 0},
                            ["25"] = {Color = fromHex "#ff8000", Transparency = 0},
                            ["50"] = {Color = fromHex "#ffff00", Transparency = 0},
                            ["75"] = {Color = fromHex "#80ff00", Transparency = 0},
                            ["100"] = {Color = fromHex "#00ffff", Transparency = 0}
                        }, {Rotation = 60}), Icon = fromHex "#ffffff"
                    };
                };
            end;
        end;
        function a.t()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.New(ae, af, ag, ah, ai)
                local aj, ak = ai or 10, nil;
                if af and af ~= "" then
                    ak = ac("ImageLabel", {
                        Image = ab.Icon(af)[1],
                        ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                        ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                        Size = Dim2(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ThemeTag = {ImageColor3 = "Icon"}
                    });
                end; local al = ac("TextLabel", {
                    BackgroundTransparency = 1,
                    TextSize = 17,
                    FontFace = Fnew(ab.Font, Enum.FontWeight.Regular),
                    Size = Dim2(1, ak and -29 or 0, 1, 0),
                    TextXAlignment = "Left",
                    ThemeTag = {TextColor3 = ah and "Placeholder" or "Text"},
                    Text = ae
                }); local am = ac("TextButton", {
                    Size = Dim2(1, 0, 0, 42),
                    Parent = ag,
                    BackgroundTransparency = 1,
                    Text = ""
                }, {
                    ac("Frame", {
                        Size = DIM1010,
                        BackgroundTransparency = 1
                    }, {
                        ab.NewRoundFrame(aj, "Squircle", {
                            ThemeTag = {ImageColor3 = "Accent"},
                            Size = DIM1010,
                            ImageTransparency = .97
                        }), ab.NewRoundFrame(aj, "SquircleOutline", {
                            ThemeTag = {ImageColor3 = "Outline"},
                            Size = DIM1010,
                            ImageTransparency = .95
                        }, {
                            ac("UIGradient", {
                                Rotation = 70,
                                Color = CSnew {
                                    CSKnew(0.0, WHITE),
                                    CSKnew(0.5, WHITE),
                                    CSKnew(1.0, WHITE)
                                },
                                Transparency = NSnew {
                                    NSKnew(0.0, 0.1),
                                    NSKnew(0.5, 1),
                                    NSKnew(1.0, 0.1)
                                };
                            });
                        }), ab.NewRoundFrame(aj, "Squircle", {
                            Size = DIM1010,
                            Name = "Frame",
                            ImageColor3 = WHITE,
                            ImageTransparency = 0.95
                        }, {
                            ac("UIPadding", {
                                PaddingLeft = Dim(0, 12),
                                PaddingRight = Dim(0, 12)
                            }), ac("UIListLayout", {
                                FillDirection = "Horizontal",
                                Padding = Dim(0, 8),
                                VerticalAlignment = "Center",
                                HorizontalAlignment = "Left"
                            }), ak, al
                        });
                    });
                }); return am;
            end; return aa;
        end;
        function a.u()
            local aa = {}; local ad = a.load("b"); local ae = ad.New
            function aa.New(ag, ah, ai, aj)
                local ak = ae("Frame", {
                    Size = Dim2(0, aj, 1, 0),
                    BackgroundTransparency = 1,
                    Position = Dim2(1, 0, 0, 0),
                    AnchorPoint = Vec2(1, 0),
                    Parent = ah,
                    ZIndex = 999,
                    Active = true
                }); local al = ad.NewRoundFrame(aj / 2, "Squircle", {
                    Size = Dim2(1, 0, 0, 0),
                    ImageTransparency = 0.85,
                    Parent = ak
                });
                local am = ae("Frame", {
                    Size = Dim2(1, 12, 1, 12),
                    Position = DIM05,
                    AnchorPoint = VEC05,
                    BackgroundTransparency = 1,
                    Active = true,
                    ZIndex = 999,
                    Parent = al
                }); local an, ao = false, 0;
                local function updateSliderSize()
                    local ap = ag; local aq = ap.AbsoluteCanvasSize.Y;
                    local ar = ap.AbsoluteWindowSize.Y; if aq <= ar then
                        al.Visible = false;
                        return;
                    end; local as = math.clamp(ar / aq, 0.1, 1);
                    al.Size = Dim2(1, 0, as, 0); al.Visible = true;
                end; local function updateScrollingFramePosition()
                    local ap = al.Position.Y.Scale; local aq = ag.AbsoluteCanvasSize.Y;
                    local ar = ag.AbsoluteWindowSize.Y; local as = math.max(aq - ar, 0);
                    if as <= 0 then return; end;
                    local at = math.max(1 - al.Size.Y.Scale, 0);
                    if at <= 0 then return; end; local au = ap / at;
                    ag.CanvasPosition = Vec2(ag.CanvasPosition.X, au * as);
                end; local function updateThumbPosition()
                    if an then return; end; local ap = ag.CanvasPosition.Y;
                    local aq = ag.AbsoluteCanvasSize.Y; local ar = ag.AbsoluteWindowSize.Y;
                    local as = math.max(aq - ar, 0); if as <= 0 then
                        al.Position = DIM0000;
                        return;
                    end; local at = ap / as;
                    local au = math.max(1 - al.Size.Y.Scale, 0);
                    local av = math.clamp(at * au, 0, au);
                    al.Position = Dim2(0, 0, av, 0);
                end; ad.AddSignal(ak.InputBegan, function(ap)
                    if (ap.UserInputType == Enum.UserInputType.MouseButton1 or ap.UserInputType == Enum.UserInputType.Touch) then
                        local aq = al.AbsolutePosition.Y; local ar = aq + al.AbsoluteSize.Y;
                        if not (ap.Position.Y >= aq and ap.Position.Y <= ar) then
                            local as, at, au = ak.AbsolutePosition.Y, ak.AbsoluteSize.Y, al.AbsoluteSize.Y;
                            local av = ap.Position.Y - as - au / 2; local aw = at - au;
                            local ax = math.clamp(av / aw, 0, 1 - al.Size.Y.Scale);
                            al.Position = Dim2(0, 0, ax, 0); updateScrollingFramePosition();
                        end;
                    end;
                end); ad.AddSignal(am.InputBegan, function(ap)
                    if ap.UserInputType == Enum.UserInputType.MouseButton1 or ap.UserInputType == Enum.UserInputType.Touch then
                        local aq, ar = nil, nil; an = true; ao = ap.Position.Y - al.AbsolutePosition.Y;
                        ac.InputChanged:Connect(function(as)
                            if as.UserInputType == Enum.UserInputType.MouseMovement or as.UserInputType == Enum.UserInputType.Touch then
                                local at, au, av = ak.AbsolutePosition.Y, ak.AbsoluteSize.Y, al.AbsoluteSize.Y;
                                local aw = as.Position.Y - at - ao; local ax = au - av;
                                local ay = math.clamp(aw / ax, 0, 1 - al.Size.Y.Scale);
                                al.Position = Dim2(0, 0, ay, 0); updateScrollingFramePosition();
                            end;
                        end); ar = ac.InputEnded:Connect(function(as)
                            if as.UserInputType == Enum.UserInputType.MouseButton1 or as.UserInputType == Enum.UserInputType.Touch then
                                an = false; if aq then
                                    aq:Disconnect();
                                end; if ar then
                                    ar:Disconnect();
                                end;
                            end;
                        end);
                    end;
                end); ad.AddSignal(PropChangeSignal(ag, "AbsoluteWindowSize"), function()
                    updateSliderSize(); updateThumbPosition();
                end); ad.AddSignal(PropChangeSignal(ag, "AbsoluteCanvasSize"), function()
                    updateSliderSize(); updateThumbPosition();
                end); ad.AddSignal(PropChangeSignal(ag, "CanvasPosition"), function()
                    if not an then
                        updateThumbPosition();
                    end;
                end); updateSliderSize(); updateThumbPosition(); return ak;
            end; return aa;
        end;
        function a.v()
            local aa = {}; local ab = a.load"b"; local ac = ab.New;
            function aa.New(ae, af, ag)
                local ah, ai, ak = {
                    Title = af.Title or "Tag", Icon = af.Icon,
                    Color = af.Color or fromHex "#315dff",
                    Radius = af.Radius or 999,
                    TagFrame = nil, Height = 26, Padding = 10,
                    TextSize = 14, IconSize = 16
                }, nil, nil; if ah.Icon then
                    ai = ab.Image(ah.Icon, ah.Icon, 0, af.Window, "Tag", false); ai.Size = Dim2(0, ah.IconSize, 0, ah.IconSize);
                    ai.ImageLabel.ImageColor3 = typeof(ah.Color) == "Color3" and ab.GetTextColorForHSB(ah.Color) or nil;
                end; local aj = ac("TextLabel", {
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY",
                    TextSize = ah.TextSize,
                    FontFace = Fnew(ab.Font, Enum.FontWeight.SemiBold),
                    Text = ah.Title,
                    TextColor3 = typeof(ah.Color) == "Color3" and ab.GetTextColorForHSB(ah.Color) or nil
                }); if typeof(ah.Color) == "table" then
                    ak = ac "UIGradient"; for al, am in next, ah.Color do
                        ak[al] = am;
                    end; aj.TextColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak)); if ai then
                        ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak));
                    end;
                end; local al = ab.NewRoundFrame(ah.Radius, "Squircle", {
                    AutomaticSize = "X",
                    Size = Dim2(0, 0, 0, ah.Height),
                    Parent = ag,
                    ImageColor3 = typeof(ah.Color) == "Color3" and ah.Color or WHITE;
                }, {
                    ak, ac("UIPadding", {
                        PaddingLeft = Dim(0, ah.Padding),
                        PaddingRight = Dim(0, ah.Padding)
                    }), ai, aj, ac("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        Padding = Dim(0, ah.Padding / 1.5)
                    });
                }); function ah.SetTitle(am, an)
                    ah.Title = an; aj.Text = an;
                end; function ah.SetColor(am, an)
                    ah.Color = an if typeof(an) == "table" then
                        local ao = ab.GetAverageColor(an); TwCreate(TweenService, aj, TWI_006, {TextColor3 = ab.GetTextColorForHSB(ao)}):Play();
                        local ap = FindFirstChildOfClass(al, "UIGradient") or ac("UIGradient", {Parent = al});
                        for aq, ar in next, an do ap[aq] = ar; end; TwCreate(TweenService, al, TWI_006, {ImageColor3 = WHITE}):Play();
                    else
                        if ak then ak:Destroy(); end TwCreate(TweenService, aj, TWI_006, {TextColor3 = ab.GetTextColorForHSB(an)}):Play();
                        if ai then TwCreate(TweenService, ai.ImageLabel, TWI_006, {ImageColor3 = ab.GetTextColorForHSB(an)}):Play(); end;
                        TwCreate(TweenService, al, TWI_006, {ImageColor3 = an}):Play();
                    end;
                end; return ah;
            end; return aa;
        end;
        function a.w()
            local ac, ad = nil, {
                Folder = nil,
                Path = nil,
                Configs = {},
                Parser = {
                    Colorpicker = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Default:ToHex(),
                                transparency = ae.Transparency or nil
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Update then
                                ae:Update(fromHex(af.value), af.transparency or nil)
                            end
                        end
                    },
                    Dropdown = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Value
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Select then
                                ae:Select(af.value)
                            end
                        end
                    },
                    Input = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Value
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Set then
                                ae:Set(af.value)
                            end
                        end
                    },
                    Keybind = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Value
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Set then
                                ae:Set(af.value)
                            end
                        end
                    },
                    Slider = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Value.Default
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Set then
                                ae:Set(tonumber(af.value))
                            end
                        end
                    },
                    Toggle = {
                        Save = function(ae)
                            return {
                                __type = ae.__type,
                                value = ae.Value
                            }
                        end,
                        Load = function(ae, af)
                            if ae and ae.Set then
                                ae:Set(af.value)
                            end
                        end
                    }
                }
            }; function ad.Init(ae, af)
                if not af.Folder then warn"[ WindUI.ConfigManager ] Window.Folder is not specified."; return false; end;
                ac = af; ad.Folder = ac.Folder; ad.Path = "WindUI/" .. tostring(ad.Folder) .. "/config/"; if not isfolder("WindUI/" .. ad.Folder) then
                    makefolder("WindUI/" .. ad.Folder); if not isfolder("WindUI/" .. ad.Folder .. "/config/") then
                        makefolder("WindUI/" .. ad.Folder .. "/config/");
                    end;
                end; local ag = ad:AllConfigs(); for ah, ai in next, ag do
                    if isfile and readfile and isfile(ai .. ".json") then
                        ad.Configs[ai] = readfile(ai .. ".json");
                    end;
                end; return ad;
            end; function ad.CreateConfig(ae, af, ag)
                local ah = {
                    Path = ad.Path .. af .. ".json",
                    Elements = {}, CustomData = {},
                    AutoLoad = ag or false, Version = 1.2
                } if not af then
                    return false, "No config file is selected";
                end; function ah.SetAsCurrent(ai)
                    ac:SetCurrentConfig(ah);
                end; function ah.Register(ai, aj, ak)
                    ah.Elements[aj] = ak;
                end; function ah.Set(ai, aj, ak)
                    ah.CustomData[aj] = ak;
                end; function ah.Get(ai, aj)
                    return ah.CustomData[aj];
                end; function ah.SetAutoLoad(ai, aj)
                    ah.AutoLoad = aj;
                end; function ah.Save(ai)
                    if ac.PendingFlags then
                        for aj, ak in next, ac.PendingFlags do
                            ah:Register(aj, ak);
                        end;
                    end; local aj = {
                        __version = ah.Version, __elements = {},
                        __autoload = ah.AutoLoad, __custom = ah.CustomData
                    }; for ak, al in next, ah.Elements do
                        if ad.Parser[al.__type] then
                            aj.__elements[tostring(ak)] = ad.Parser[al.__type].Save(al);
                        end;
                    end; local am = EnCodeJ(HttpService, aj);
                    if writefile then
                        writefile(ah.Path, am);
                    end; return aj;
                end; function ah.Load(ai)
                    if isfile and not isfile(ah.Path) then
                        return false, "Config file does not exist";
                    end; local aj, ak = pcall(function()
                        local aj = readfile or function()
                            warn "[ WindUI.ConfigManager ] The config system doesn't work in the studio.";
                            return nil;
                        end; return DeCodeJ(ab, aj(ah.Path));
                    end); if not aj then
                        return false, "Failed to parse config file";
                    end; if not ak.__version then
                        local al = {__version = ah.Version, __elements = ak, __custom = {}};
                        ak = al;
                    end; if ac.PendingFlags then
                        for al, am in next, ac.PendingFlags do
                            ah:Register(al, am);
                        end;
                    end; for al, am in next, (ak.__elements or {}) do
                        if ah.Elements[al] and ad.Parser[am.__type] then
                            tk.spawn(function()
                                ad.Parser[am.__type].Load(ah.Elements[al], am);
                            end);
                        end;
                    end; ah.CustomData = ak.__custom or {};
                    return ah.CustomData;
                end; function ah.Delete(ai)
                    if not delfile then
                        return false, "delfile function is not available";
                    end; if not isfile(ah.Path) then
                        return false, "Config file does not exist";
                    end; local aj, ak = pcall(function()
                        delfile(ah.Path);
                    end); if not aj then
                        return false, "Failed to delete config file: " .. tostring(ak);
                    end; ad.Configs[af] = nil; if ac.CurrentConfig == ah then
                        ac.CurrentConfig = nil;
                    end; return true, "Config deleted successfully";
                end; function ah.GetData(ai)
                    return {elements = ah.Elements, custom = ah.CustomData, autoload = ah.AutoLoad};
                end; if isfile(ah.Path) then
                    local ai, aj = pcall(function()
                        return DeCodeJ(HttpService, readfile(ah.Path));
                    end); if ai and aj and aj.__autoload then
                        ah.AutoLoad = true; tk.spawn(function()
                            twait(0.5) local ak, al = pcall(function()
                                return ah:Load();
                            end); if ak then
                                if ac.Debug then
                                    print("[ WindUI.ConfigManager ] AutoLoaded config: " .. af);
                                end;
                            else
                                warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: " .. af .. " - " .. tostring(al));
                            end;
                        end);
                    end;
                end; ah:SetAsCurrent(); ad.Configs[af] = ah;
                return ah;
            end; function ad.Config(ae, af, ag)
                return ad:CreateConfig(af, ag);
            end; function ad.GetAutoLoadConfigs(ae)
                local af = {}; for ag, ah in pairs(ad.Configs) do
                    if ah.AutoLoad then
                        tble.insert(af, ag);
                    end;
                end; return af;
            end; function ad.DeleteConfig(ae, af)
                if not delfile then
                    return false, "delfile function is not available";
                end; local ag = ad.Path .. af .. ".json";
                if not isfile(ag) then
                    return false, "Config file does not exist";
                end; local ah, ai = pcall(function()
                    delfile(ag);
                end); if not ah then
                    return false, "Failed to delete config file: " .. tostring(ai);
                end; ad.Configs[af] = nil; if ac.CurrentConfig and ac.CurrentConfig.Path == ag then
                    ac.CurrentConfig = nil;
                end; return true, "Config deleted successfully";
            end; function ad.AllConfigs(ae)
                if not listfiles then
                    return {};
                end; local af = {};
                if not isfolder(ad.Path) then
                    makefolder(ad.Path);
                    return af;
                end; for ag, ah in next, listfiles(ad.Path) do
                    local ai = ah:match"([^\\/]+)%.json$";
                    if ai then
                        tble.insert(af, ai);
                    end;
                end; return af;
            end; function ad.GetConfig(ae, af)
                return ad.Configs[af];
            end; return ad;
        end;
        function a.x()
            local aa = {}; local ab = a.load"b"; local ac = ab.New;
            function aa.New(af)
                local ag, ah = {Button = nil}, nil; local ai = ac("TextLabel", {
                    Text = af.Title,
                    TextSize = 17,
                    FontFace = Fnew(ab.Font, Enum.FontWeight.Medium),
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY"
                }); local aj = ac("Frame", {
                    Size = Dim2(0, 36, 0, 36),
                    BackgroundTransparency = 1,
                    Name = "Drag"
                }, {
                    ac("ImageLabel", {
                        Image = ab.Icon "move"[1],
                        ImageRectOffset = ab.Icon "move"[2].ImageRectPosition,
                        ImageRectSize = ab.Icon "move"[2].ImageRectSize,
                        Size = Dim2(0, 18, 0, 18),
                        BackgroundTransparency = 1,
                        Position = DIM05,
                        AnchorPoint = VEC05,
                        ThemeTag = {
                            ImageColor3 = "Icon"
                        },
                        ImageTransparency = .3
                    });
                }); local ak = ac("Frame", {
                    Size = Dim2(0, 1, 1, 0),
                    Position = Dim2(0, 36, 0.5, 0),
                    AnchorPoint = Vec2(0, 0.5),
                    BackgroundColor3 = WHITE,
                    BackgroundTransparency = .9
                }); local al = ac("Frame", {
                    Size = DIM0000,
                    Position = Dim2(0.5, 0, 0, 28),
                    AnchorPoint = VEC05,
                    Parent = af.Parent,
                    BackgroundTransparency = 1,
                    Active = true,
                    Visible = false
                }); local am = ac("TextButton", {
                    Size = Dim2(0, 0, 0, 44),
                    AutomaticSize = "X",
                    Parent = al,
                    Active = false,
                    BackgroundTransparency = .25,
                    ZIndex = 99,
                    BackgroundColor3 = BLACK
                }, {
                    ac("UIScale", {
                        Scale = 1
                    }), ac("UICorner", {
                        CornerRadius = Dim(1, 0)
                    }), ac("UIStroke", {
                        Thickness = 1,
                        ApplyStrokeMode = "Border",
                        Color = WHITE,
                        Transparency = 0
                    }, {
                        ac("UIGradient", {
                            Color = CSnew(fromHex "40c9ff", fromHex "e81cff")
                        })
                    }), aj, ak, ac("UIListLayout", {
                        Padding = Dim(0, 4),
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center"
                    }), ac("TextButton", {
                        AutomaticSize = "XY",
                        Active = true,
                        BackgroundTransparency = 1,
                        Size = Dim2(0, 0, 0, 36),
                        BackgroundColor3 = WHITE
                    }, {
                        ac("UICorner", {
                            CornerRadius = Dim(1, -4)
                        }), ah, ac("UIListLayout", {
                            Padding = Dim(0, af.UIPadding),
                            FillDirection = "Horizontal",
                            VerticalAlignment = "Center"
                        }), ai, ac("UIPadding", {
                            PaddingLeft = Dim(0, 11),
                            PaddingRight = Dim(0, 11)
                        })
                    }), ac("UIPadding", {
                        PaddingLeft = Dim(0, 4),
                        PaddingRight = Dim(0, 4)
                    });
                }); ag.Button = am; function ag.SetIcon(an, ao)
                    if ah then ah:Destroy(); end; if ao then
                        ah = ab.Image(ao, af.Title, 0, af.Folder, "OpenButton", true, af.IconThemed);
                        ah.Size = Dim2(0, 22, 0, 22);
                        ah.LayoutOrder = -1;
                        ah.Parent = ag.Button.TextButton;
                    end;
                end; if af.Icon then
                    ag:SetIcon(af.Icon);
                end; ab.AddSignal(PropChangeSignal(am, "AbsoluteSize"), function()
                    al.Size = Dim2(0, am.AbsoluteSize.X, 0, am.AbsoluteSize.Y);
                end); ab.AddSignal(am.TextButton.MouseEnter, function()
                    TwCreate(TweenService, am.TextButton, TWI_01, {BackgroundTransparency = 0.93}):Play()
                end); ab.AddSignal(am.TextButton.MouseLeave, function()
                    TwCreate(TweenService, am.TextButton, TWI_01, {BackgroundTransparency = 1}):Play();
                end); local an = ab.Drag(al);
                function ag.Visible(ao, ap)
                    al.Visible = ap;
                end; function ag.Edit(ao, ap)
                    local aq = {
                        Title = ap.Title,
                        Icon = ap.Icon,
                        Enabled = ap.Enabled,
                        Position = ap.Position,
                        OnlyIcon = ap.OnlyIcon or false,
                        Draggable = ap.Draggable or nil,
                        OnlyMobile = ap.OnlyMobile,
                        CornerRadius = ap.CornerRadius or Dim(1, 0),
                        StrokeThickness = ap.StrokeThickness or 2,
                        Color = ap.Color or CSnew(fromHex "40c9ff", fromHex "e81cff")
                    }; if aq.Enabled == false then
                        af.IsOpenButtonEnabled = false;
                    end; if aq.OnlyMobile ~= false then
                        aq.OnlyMobile = true;
                    else
                        af.IsPC = false;
                    end; if aq.Draggable == false and aj and ak then
                        aj.Visible = aq.Draggable; ak.Visible = aq.Draggable;
                        if an then
                            an:Set(aq.Draggable);
                        end;
                    end; if aq.Position and al then
                        al.Position = aq.Position;
                    end; if aq.OnlyIcon == true and ai then
                        ai.Visible = false;
                        am.TextButton.UIPadding.PaddingLeft = Dim(0, 7);
                        am.TextButton.UIPadding.PaddingRight = Dim(0, 7);
                    elseif aq.OnlyIcon == false then
                        ai.Visible = true;
                        am.TextButton.UIPadding.PaddingLeft = Dim(0, 11);
                        am.TextButton.UIPadding.PaddingRight = Dim(0, 11);
                    end; if ai then
                        if aq.Title then
                            ai.Text = aq.Title;
                            ab:ChangeTranslationKey(ai, aq.Title);
                        elseif aq.Title == nil then end;
                    end; if aq.Icon then
                        ag:SetIcon(aq.Icon);
                    end; am.UIStroke.UIGradient.Color = aq.Color;
                    if Glow then Glow.UIGradient.Color = aq.Color; end;
                    am.UICorner.CornerRadius = aq.CornerRadius;
                    am.TextButton.UICorner.CornerRadius = Dim(aq.CornerRadius.Scale, aq.CornerRadius.Offset - 4);
                    am.UIStroke.Thickness = aq.StrokeThickness;
                end; return ag;
            end; return aa;
        end;
        function a.y()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.New(ae, af, ag, ah, ai, aj)
                local ak = {
                    Container = nil,
                    TooltipSize = 16,
                    TooltipArrowSizeX = ai == "Small" and 16 or 24,
                    TooltipArrowSizeY = ai == "Small" and 6 or 9,
                    PaddingX = ai == "Small" and 12 or 14,
                    PaddingY = ai == "Small" and 7 or 9,
                    Radius = 999,
                    TitleFrame = nil
                }; ah = ah or ""; aj = aj ~= false;
                local al = ac("TextLabel", {
                    AutomaticSize = "XY",
                    TextWrapped = aj,
                    BackgroundTransparency = 1,
                    FontFace = Fnew(ab.Font, Enum.FontWeight.Medium),
                    Text = ae,
                    TextSize = ai == "Small" and 15 or 17,
                    TextTransparency = 1,
                    ThemeTag = {TextColor3 = "Tooltip" .. ah .. "Text"}
                }); ak.TitleFrame = al; local am = ac("UIScale", {Scale = 0.9});
                local an = ac("Frame", {
                    AnchorPoint = Vec2(0.5, 0),
                    AutomaticSize = "XY",
                    BackgroundTransparency = 1,
                    Parent = af,
                    Visible = false
                }, {
                    ac("UISizeConstraint", {
                        MaxSize = Vec2(400, math.huge)
                    }), ac("Frame", {
                        AutomaticSize = "XY",
                        BackgroundTransparency = 1,
                        LayoutOrder = 99,
                        Visible = ag,
                        Name = "Arrow"
                    }, {
                        ac("ImageLabel", {
                            Size = Dim2(0, ak.TooltipArrowSizeX, 0, ak.TooltipArrowSizeY),
                            BackgroundTransparency = 1,
                            Image = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://105854070513330",
                            ThemeTag = {
                                ImageColor3 = "Tooltip" .. ah
                            }
                        }, {})
                    }), ab.NewRoundFrame(ak.Radius, "Squircle", {
                        AutomaticSize = "XY",
                        ThemeTag = {
                            ImageColor3 = "Tooltip" .. ah
                        },
                        ImageTransparency = 1,
                        Name = "Background"
                    }, {
                        ac("Frame", {
                            AutomaticSize = "XY",
                            BackgroundTransparency = 1
                        }, {
                            ac("UICorner", {
                                CornerRadius = Dim(0, 16)
                            }), ac( "UIListLayout", {
                                Padding = Dim(0, 12),
                                FillDirection = "Horizontal",
                                VerticalAlignment = "Center"
                            }), al, ac("UIPadding", {
                                PaddingTop = Dim(0, ak.PaddingY),
                                PaddingLeft = Dim(0, ak.PaddingX),
                                PaddingRight = Dim(0, ak.PaddingX),
                                PaddingBottom = Dim(0, ak.PaddingY)
                            });
                        });
                    }), am, ac("UIListLayout", {
                        Padding = Dim(0, 0),
                        FillDirection = "Vertical",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center"
                    });
                }); ak.Container = an; function ak.Open(ao)
                    an.Visible = true; TwCreate(TweenService, an.Background, TWI_Q_02, {ImageTransparency = 0}):Play();
                    TwCreate(TweenService, an.Arrow.ImageLabel, TWI_Q_02, {ImageTransparency = 0}):Play();
                    TwCreate(TweenService, al, TWI_Q_02, {TextTransparency = 0}):Play();
                    TwCreate(TweenService, am, TwInfo(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play();
                end; function ak.Close(ao, ap)
                    TwCreate(TweenService, an.Background, TwInfo(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
                    TwCreate(TweenService, an.Arrow.ImageLabel, TWI_Q_02, {ImageTransparency = 1}):Play();
                    TwCreate(TweenService, al, TwInfo(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play();
                    TwCreate(TweenService, am, TwInfo(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.9}):Play();
                    ap = ap ~= false; if ap then
                        twait(0.35); an.Visible = false; an:Destroy()
                    end;
                end; return ak;
            end; return aa;
        end;
        function a.z()
            local aa = a.load"b"; local ab, ac, ad = aa.New, aa.NewRoundFrame;
            local function Color3ToHSB(af)
                local ag, ah, ai = af.R, af.G, af.B
                local aj, ak = math.max(ag, ah, ai), math.min(ag, ah, ai);
                local al, am = aj - ak, 0;
                if al ~= 0 then
                    if aj == ag then
                        am = (ah - ai) / al % 6;
                    elseif aj == ah then
                        am = (ai - ag) / al + 2;
                    else
                        am = (ag - ah) / al + 4;
                    end;
                    am = am * 60;
                else
                    am = 0;
                end; local an, ao = (aj == 0) and 0 or (al / aj), aj;
                return {h = math.floor(am + 0.5), s = an, b = ao};
            end; local function GetPerceivedBrightness(af)
                local ag, ah, ai = af.R, af.G, af.B;
                return 0.299 * ag + 0.587 * ah + 0.114 * ai;
            end; local function GetTextColorForHSB(af)
                local ag = Color3ToHSB(af); local ah, ai, aj = ag.h, ag.s, ag.b;
                if GetPerceivedBrightness(af) > 0.5 then
                    return fromHSV(ah / 360, 0, 0.05);
                else
                    return fromHSV(ah / 360, 0, 0.98);
                end;
            end; local function getElementPosition(af, ag)
                if type(ag) ~= "number" or ag ~= math.floor(ag) then return nil, 1; end;
                local ah = #af; if ah == 0 or ag < 1 or ag > ah then
                    return nil, 2;
                end; local function isDelimiter(ai)
                    if ai == nil then return true; end; local aj = ai.__type;
                    return aj == "Divider" or aj == "Space" or aj == "Section" or aj == "Code";
                end; if isDelimiter(af[ag]) then
                    return nil, 3;
                end; local function calculate(ai, aj)
                    if aj == 1 then return "Squircle"; end;
                    if ai == 1 then return "Squircle-TL-TR"; end;
                    if ai == aj then return "Squircle-BL-BR"; end; return "Square";
                end; local ai, aj = 1, 0
                for ak = 1, ah do
                    local al = af[ak]; if isDelimiter(al) then
                        if ag >= ai and ag <= ak - 1 then
                            local am = ag - ai + 1;
                            return calculate(am, aj);
                        end; ai = ak + 1 aj = 0
                    else
                        aj = aj + 1;
                    end;
                end; if ag >= ai and ag <= ah then
                    local ak = ag - ai + 1;
                    return calculate(ak, aj);
                end; return nil, 4;
            end; return function(af)
                local ag = {
                    Title = af.Title,
                    Desc = af.Desc or nil,
                    Hover = af.Hover,
                    Thumbnail = af.Thumbnail,
                    ThumbnailSize = af.ThumbnailSize or 80,
                    Image = af.Image,
                    IconThemed = af.IconThemed or false,
                    ImageSize = af.ImageSize or 30,
                    Color = af.Color,
                    Scalable = af.Scalable,
                    Parent = af.Parent,
                    Justify = af.Justify or "Between",
                    UIPadding = af.Window.ElementConfig.UIPadding,
                    UICorner = af.Window.ElementConfig.UICorner,
                    UIElements = {},
                    Index = af.Index
                }; local ah, ai, aj, ak, al, am = ag.ImageSize, ag.ThumbnailSize, true, 0, nil, nil;
                if ag.Thumbnail then
                    al = aa.Image(
                        ag.Thumbnail, ag.Title,
                        af.Window.NewElements and ag.UICorner - 11 or (ag.UICorner - 4),
                        af.Window.Folder, "Thumbnail", false, ag.IconThemed
                    ); al.Size = Dim2(1, 0, 0, ai);
                end; if ag.Image then
                    am = aa.Image(
                        ag.Image, ag.Title, af.Window.NewElements and ag.UICorner - 11 or (ag.UICorner - 4),
                        af.Window.Folder, "Image", ag.IconThemed, not ag.Color and true or false, "ElementIcon"
                    ); if ag.Image == "TTJYStudio" then
                        am.ImageLabel.Image = TTJYLogo;
                    end; if typeof(ag.Color) == "string" then
                        am.ImageLabel.ImageColor3 = GetTextColorForHSB(fromHex(aa.Colors[ag.Color]));
                    elseif typeof(ag.Color) == "Color3" then
                        am.ImageLabel.ImageColor3 = GetTextColorForHSB(ag.Color);
                    end; am.Size = Dim2(0, ah, 0, ah); ak = ah;
                end; local function CreateText(an, ao)
                    local ap = typeof(ag.Color) == "string" and GetTextColorForHSB(fromHex(aa.Colors[ag.Color])) or typeof(ag.Color) == "Color3" and GetTextColorForHSB(ag.Color);
                    return ab("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = an or "",
                        TextSize = ao == "Desc" and 15 or 17,
                        TextXAlignment = "Left",
                        ThemeTag = {
                            TextColor3 = not ag.Color and ("Element" .. ao) or nil
                        },
                        TextColor3 = ag.Color and ap or nil,
                        TextTransparency = ao == "Desc" and .3 or 0,
                        TextWrapped = true,
                        Size = Dim2(ag.Justify == "Between" and 1 or 0, 0, 0, 0),
                        AutomaticSize = ag.Justify == "Between" and "Y" or "XY",
                        FontFace = Fnew(aa.Font, ao == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
                    });
                end; local an = CreateText(ag.Title, "Title"); local ao = CreateText(ag.Desc, "Desc");
                if not ag.Title or ag.Title == "" then ao.Visible = false; end;
                if not ag.Desc or ag.Desc == "" then ao.Visible = false; end;
                ag.UIElements.Title = an; ag.UIElements.Desc = ao;
                ag.UIElements.Container = ab("Frame", {
                    Size = DIM1010,
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1
                }, {
                    ab("UIListLayout", {
                        Padding = Dim(0, ag.UIPadding),
                        FillDirection = "Vertical",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = ag.Justify == "Between" and "Left" or "Center"
                    }), al, ab("Frame", {
                        Size = Dim2(
                            ag.Justify == "Between" and 1 or 0,
                            ag.Justify == "Between" and -af.TextOffset or 0,
                            0,
                            0
                        ),
                        AutomaticSize = ag.Justify == "Between" and "Y" or "XY",
                        BackgroundTransparency = 1,
                        Name = "TitleFrame"
                    }, {
                        ab("UIListLayout", {
                            Padding = Dim(0, ag.UIPadding),
                            FillDirection = "Horizontal",
                            VerticalAlignment = af.Window.NewElements and
                                (ag.Justify == "Between" and "Top" or "Center") or
                                "Center",
                            HorizontalAlignment = ag.Justify ~= "Between" and ag.Justify or "Center"
                        }), am, ab( "Frame", {
                            BackgroundTransparency = 1,
                            AutomaticSize = ag.Justify == "Between" and "Y" or "XY",
                            Size = Dim2(
                                ag.Justify == "Between" and 1 or 0,
                                ag.Justify == "Between" and (am and -ak - ag.UIPadding or -ak) or 0,
                                1,
                                0
                            ),
                            Name = "TitleFrame"
                        }, {
                            ab("UIPadding", {
                                PaddingTop = Dim(0, af.Window.NewElements and ag.UIPadding / 2 or 0),
                                PaddingLeft = Dim(0, af.Window.NewElements and ag.UIPadding / 2 or 0),
                                PaddingRight = Dim(0, af.Window.NewElements and ag.UIPadding / 2 or 0),
                                PaddingBottom = Dim(0, af.Window.NewElements and ag.UIPadding / 2 or 0)
                            }), ab("UIListLayout", {
                                Padding = Dim(0, 6),
                                FillDirection = "Vertical",
                                VerticalAlignment = "Center",
                                HorizontalAlignment = "Left"
                            }), an, ao
                        });
                    });
                }); local ap = aa.Image("lock", "lock", 0, af.Window.Folder, "Lock", false);
                ap.Size = Dim2(0, 20, 0, 20); ap.ImageLabel.ImageColor3 = WHITE;
                ap.ImageLabel.ImageTransparency = .4; local aq = ab("TextLabel", {
                    Text = "Locked",
                    TextSize = 18,
                    FontFace = Fnew(aa.Font, Enum.FontWeight.Medium),
                    AutomaticSize = "XY",
                    BackgroundTransparency = 1,
                    TextColor3 = WHITE,
                    TextTransparency = .05
                }); local ar = ab("Frame", {
                    Size = Dim2(1, ag.UIPadding * 2, 1, ag.UIPadding * 2),
                    BackgroundTransparency = 1,
                    AnchorPoint = VEC05,
                    Position = DIM05,
                    ZIndex = 9999999
                }); local as, at = ac(ag.UICorner, "Squircle", {
                    Size = DIM1010,
                    ImageTransparency = .25,
                    ImageColor3 = BLACK,
                    Visible = false,
                    Active = false,
                    Parent = ar
                }, {
                    ab("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center",
                        Padding = Dim(0, 8)
                    }), ap, aq
                }, nil, true); local au, av = ac(ag.UICorner, "Squircle-Outline", {
                    Size = DIM1010,
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    },
                    Parent = ar
                }, {
                    ab("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center",
                        Padding = Dim(0, 8)
                    })
                }, nil, true); local aw, ax = ac(ag.UICorner, "Squircle", {
                    Size = DIM1010,
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    },
                    Parent = ar
                }, {
                    ab("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center",
                        Padding = Dim(0, 8)
                    })
                }, nil, true); local ay, az = ac(ag.UICorner, "Squircle-Outline", {
                    Size = DIM1010,
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    },
                    Parent = ar
                }, {
                    ab("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center",
                        Padding = Dim(0, 8)
                    }), ab("UIGradient", {
                        Name = "HoverGradient",
                        Color = CSnew {
                            CSKnew(0, WHITE),
                            CSKnew(0.5, WHITE),
                            CSKnew(1, WHITE)
                        },
                        Transparency = NSnew {
                            NSKnew(0, 1),
                            NSKnew(0.25, 0.9),
                            NSKnew(0.5, 0.3),
                            NSKnew(0.75, 0.9),
                            NSKnew(1, 1)
                        };
                    })
                }, nil, true); local aA, aB = ac(ag.UICorner,  "Squircle", {
                    Size = DIM1010,
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    },
                    Parent = ar
                }, {
                    ab("UIGradient", {
                        Name = "HoverGradient", Color = CSnew {
                            CSKnew(0, WHITE),
                            CSKnew(0.5, WHITE),
                            CSKnew(1, WHITE)
                        }, Transparency = NSnew {
                            NSKnew(0, 1),
                            NSKnew(0.25, 0.9),
                            NSKnew(0.5, 0.3),
                            NSKnew(0.75, 0.9),
                            NSKnew(1, 1)
                        }
                    }
                ), ab("UIListLayout", {
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = "Center",
                        Padding = Dim(0, 8)
                    })
                }, nil, true); local aC, aD = ac(ag.UICorner, "Squircle", {
                    Size = Dim2(1, 0, 0, 0),
                    AutomaticSize = "Y",
                    ImageTransparency = ag.Color and .05 or .93,
                    Parent = af.Parent,
                    ThemeTag = {
                        ImageColor3 = not ag.Color and "ElementBackground" or nil
                    },
                    ImageColor3 = ag.Color and (typeof(ag.Color) == "string" and fromHex(aa.Colors[ag.Color]) or typeof(ag.Color) == "Color3" and ag.Color) or nil
                }, {
                    ag.UIElements.Container,
                    ar, ab("UIPadding", {
                        PaddingTop = Dim(0, ag.UIPadding),
                        PaddingLeft = Dim(0, ag.UIPadding),
                        PaddingRight = Dim(0, ag.UIPadding),
                        PaddingBottom = Dim(0, ag.UIPadding)
                    })
                }, true, true); ag.UIElements.Main = aC; ag.UIElements.Locked = as;
                if ag.Hover then
                    aa.AddSignal(aC.MouseEnter, function()
                        if aj then
                            TwCreate(TweenService, aC, TWI_012, {ImageTransparency = ag.Color and 0.15 or 0.9}):Play();
                            TwCreate(TweenService, aA, TWI_012, {ImageTransparency = 0.9}):Play();
                            TwCreate(TweenService, ay, TWI_012, {ImageTransparency = 0.8}):Play();
                            aa.AddSignal(aC.MouseMoved, function(aE, aF)
                                aA.HoverGradient.Offset = Vec2(((aE - aC.AbsolutePosition.X) / aC.AbsoluteSize.X) - 0.5, 0)
                                ay.HoverGradient.Offset = Vec2(((aE - aC.AbsolutePosition.X) / aC.AbsoluteSize.X) - 0.5, 0)
                            end);
                        end;
                    end); aa.AddSignal(aC.InputEnded, function()
                        if aj then
                            TwCreate(TweenService, aC, TWI_012, {ImageTransparency = ag.Color and 0.05 or 0.93}):Play();
                            TwCreate(TweenService, aA, TWI_012, {ImageTransparency = 1}):Play();
                            TwCreate(TweenService, ay, TWI_012, {ImageTransparency = 1}):Play();
                        end;
                    end);
                end; function ag.SetTitle(aE, aF)
                    ag.Title = aF; an.Text = aF;
                end; function ag.SetDesc(aE, aF)
                    ag.Desc = aF; ao.Text = aF or "";
                    if not aF then
                        ao.Visible = false;
                    elseif not ao.Visible then
                        ao.Visible = true;
                    end;
                end; function ag.Colorize(aE, aF, b)
                    if ag.Color then
                        aF[b] = typeof(ag.Color) == "string" and GetTextColorForHSB(fromHex(aa.Colors[ag.Color])) or typeof(ag.Color) == "Color3" and GetTextColorForHSB(ag.Color) or nil;
                    end;
                end; if af.ElementTable then
                    aa.AddSignal(PropChangeSignal(an, "Text"), function()
                        if ag.Title ~= an.Text then
                            ag:SetTitle(an.Text);
                            af.ElementTable.Title = an.Text;
                        end;
                    end); aa.AddSignal(PropChangeSignal(ao, "Text"), function()
                        if ag.Desc ~= ao.Text then
                            ag:SetDesc(ao.Text);
                            af.ElementTable.Desc = ao.Text;
                        end;
                    end);
                end; function ag.SetThumbnail(aE, aF, b)
                    ag.Thumbnail = aF if b then
                        ag.ThumbnailSize = b; ai = b;
                    end; if al then
                        if aF then
                            al:Destroy(); al = aa.Image(aF, ag.Title, ag.UICorner - 3, af.Window.Folder, "Thumbnail", false, ag.IconThemed);
                            al.Size = Dim2(1, 0, 0, ai); al.Parent = ag.UIElements.Container;
                            local d = FindFirstChild(ag.UIElements.Container, "UIListLayout");
                            if d then al.LayoutOrder = -1; end;
                        else
                            al.Visible = false;
                        end;
                    else
                        if aF then
                            al = aa.Image(aF, ag.Title, ag.UICorner - 3, af.Window.Folder, "Thumbnail", false, ag.IconThemed);
                            al.Size = Dim2(1, 0, 0, ai); al.Parent = ag.UIElements.Container;
                            local d = FindFirstChild(ag.UIElements.Container, "UIListLayout");
                            if d then al.LayoutOrder = -1; end;
                        end;
                    end;
                end; function ag.SetImage(aE, aF, b)
                    ag.Image = aF; if b then
                        ag.ImageSize = b; ah = b;
                    end; if aF then
                        am = aa.Image(
                            aF, ag.Title, ag.UICorner - 3,
                            af.Window.Folder, "Image",
                            not ag.Color and true or false
                        ); if typeof(ag.Color) == "string" then
                            am.ImageLabel.ImageColor3 = GetTextColorForHSB(fromHex(aa.Colors[ag.Color]));
                        elseif typeof(ag.Color) == "Color3" then
                            am.ImageLabel.ImageColor3 = GetTextColorForHSB(ag.Color);
                        end; am.Visible = true;
                        am.Size = Dim2(0, ah, 0, ah);
                        ak = ah;
                    else
                        if am then
                            am.Visible = true;
                        end; ak = 0;
                    end; ag.UIElements.Container.TitleFrame.TitleFrame.Size = Dim2(1, -ak, 1, 0);
                end; function ag.Destroy(aE)
                    aC:Destroy();
                end; function ag.Lock(aE)
                    aj = false; as.Active = true;
                    as.Visible = true;
                end; function ag.Unlock(aE)
                    aj = true; as.Active = false;
                    as.Visible = false;
                end; function ag.Highlight(aE)
                    if isFirstLoad then return; end;
                    local aF = ab("UIGradient", {
                        Color = CSnew {
                            CSKnew(0, WHITE),
                            CSKnew(0.5, WHITE),
                            CSKnew(1, WHITE)
                        }, Transparency = NSnew {
                            NSKnew(0, 1),
                            NSKnew(0.1, 0.9),
                            NSKnew(0.5, 0.3),
                            NSKnew(0.9, 0.9),
                            NSKnew(1, 1)
                        }, Rotation = 0,
                        Offset = Vec2(-1, 0), Parent = au
                    }); local b = ab("UIGradient", {
                        Color = CSnew {
                            CSKnew(0, WHITE),
                            CSKnew(0.5, WHITE),
                            CSKnew(1, WHITE)
                        }, Transparency = NSnew {
                            NSKnew(0, 1),
                            NSKnew(0.15, 0.8),
                            NSKnew(0.5, 0.1),
                            NSKnew(0.85, 0.8),
                            NSKnew(1, 1)
                        }, Rotation = 0,
                        Offset = Vec2(-1, 0), Parent = aw
                    }); au.ImageTransparency = 0.65; aw.ImageTransparency = 0.88;
                    TwCreate(TweenService, aF, TwInfo(0.75), {Offset = Vec2(1, 0)}):Play();
                    TwCreate(TweenService, b, TwInfo(0.75), {Offset = Vec2(1, 0)}):Play();
                    tk.spawn(function()
                        twait(0.75); au.ImageTransparency = 1; aw.ImageTransparency = 1;
                        aF:Destroy(); b:Destroy();
                    end);
                end; function ag.UpdateShape(aE)
                    if af.Window.NewElements then
                        local aF = nil; if af.ParentConfig.ParentType == "Group" then
                            aF = "Squircle";
                        else
                            aF = getElementPosition(aE.Elements, ag.Index);
                        end; if aF and aC then
                            aD:SetType(aF);
                            at:SetType(aF);
                            ax:SetType(aF);
                            av:SetType(aF .. "-Outline");
                            aB:SetType(aF);
                            az:SetType(aF .. "-Outline");
                        end;
                    end;
                end; return ag;
            end;
        end;
        function a.A()
            local ac = {}; local aa = a.load "b"; local ab = aa.New;
            local ad = a.load("j").New; function ac.New(ae, af)
                af.Hover = false; af.TextOffset = 0; af.ParentConfig = af;
                af.IsButtons = af.Buttons and #af.Buttons > 0 and true or false;
                local ag = {
                    __type = "Paragraph",
                    Title = af.Title or "Paragraph",
                    Desc = af.Desc or nil,
                    Locked = af.Locked or false
                }; local ah = a.load "z"(af);
                ag.ParagraphFrame = ah;
                if af.Buttons and #af.Buttons > 0 then
                    local ai = ab("Frame", {
                        Size = Dim2(1, 0, 0, 38),
                        BackgroundTransparency = 1,
                        AutomaticSize = "Y",
                        Parent = ah.UIElements.Container
                    }, {
                        ab("UIListLayout", {
                            Padding = Dim(0, 10),
                            FillDirection = "Vertical"
                        });
                    }); for aj, ak in next, af.Buttons do
                        local al = ad(ak.Title, ak.Icon, ak.Callback, "White", ai, nil, nil, af.Window.NewElements and 12 or 10);
                        al.Size = Dim2(1, 0, 0, 38);
                    end;
                end; return ag.__type, ag;
            end return ac;
        end;
        function a.B()
            local ac = {}; local aa = a.load "b"; local ab = aa.New;
            function ac.New(ad, ae)
                local af, ag = {
                    __type = "Button",
                    Title = ae.Title or "Button",
                    Desc = ae.Desc or nil,
                    Icon = ae.Icon or "mouse-pointer-click",
                    IconThemed = ae.IconThemed or false,
                    Color = ae.Color,
                    Justify = ae.Justify or "Between",
                    IconAlign = ae.IconAlign or "Right",
                    Locked = ae.Locked or false,
                    Callback = ae.Callback or emptyfunction,
                    UIElements = {}
                }, true; af.ButtonFrame = a.load "z" {
                    Title = af.Title,
                    Desc = af.Desc,
                    Parent = ae.Parent,
                    Window = ae.Window,
                    Color = af.Color,
                    Justify = af.Justify,
                    TextOffset = 20,
                    Hover = true,
                    Scalable = true,
                    Tab = ae.Tab,
                    Index = ae.Index,
                    ElementTable = af,
                    ParentConfig = ae
                }; af.UIElements.ButtonIcon = aa.Image(af.Icon, af.Icon, 0, ae.Window.Folder, "Button", not af.Color and true or nil, af.IconThemed);
                af.UIElements.ButtonIcon.Size = Dim2(0, 20, 0, 20);
                af.UIElements.ButtonIcon.Parent = af.Justify == "Between" and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame;
                af.UIElements.ButtonIcon.LayoutOrder = af.IconAlign == "Left" and -99999 or 99999;
                af.UIElements.ButtonIcon.AnchorPoint = Vec2(1, 0.5);
                af.UIElements.ButtonIcon.Position = Dim2(1, 0, 0.5, 0);
                af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel, "ImageColor3");
                function af.Lock(ah)
                    af.Locked = true; ag = false;
                    return af.ButtonFrame:Lock();
                end; function af.Unlock(ah)
                    af.Locked = false; ag = true;
                    return af.ButtonFrame:Unlock();
                end; if af.Locked then
                    af:Lock();
                end; aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click, function()
                    if ag then
                        --tk.spawn(function()
                            --aa.SafeCallback(af.Callback);
                            af.Callback();
                        --end);
                    end;
                end); return af.__type, af;
            end; return ac;
        end;
        function a.C()
            local aa = {}; local ab = a.load "b"; local ac = ab.New;
            function aa.New(af, ag, ah, ai, aj, ak, al)
                local am, an, ao = {}, 12, nil;
                if ag and ag ~= "" then
                    ao = ac("ImageLabel", {
                        Size = Dim2(0, 13, 0, 13),
                        BackgroundTransparency = 1,
                        AnchorPoint = VEC05,
                        Position = DIM05,
                        Image = ab.Icon(ag)[1],
                        ImageRectOffset = ab.Icon(ag)[2].ImageRectPosition,
                        ImageRectSize = ab.Icon(ag)[2].ImageRectSize,
                        ImageTransparency = 1,
                        ImageColor3 = BLACK
                    });
                end; local ap = ac("Frame", {
                    Size = Dim2(0, 2, 0, 26),
                    BackgroundTransparency = 1,
                    Parent = ai
                }); local aq = ab.NewRoundFrame(an, "Squircle", {
                    ImageTransparency = .85,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    },
                    Parent = ap,
                    Size = Dim2(0, ak and (52) or (40.8), 0, 24),
                    AnchorPoint = Vec2(1, 0.5),
                    Position = Dim2(0, 0, 0.5, 0)
                }, {
                    ab.NewRoundFrame(an, "Squircle", {
                        Size = DIM1010,
                        Name = "Layer",
                        ThemeTag = {
                            ImageColor3 = "Toggle"
                        },
                        ImageTransparency = 1
                    }), ab.NewRoundFrame(an, "SquircleOutline", {
                        Size = DIM1010,
                        Name = "Stroke",
                        ImageColor3 = WHITE,
                        ImageTransparency = 1
                    }, {
                        ac("UIGradient", {
                            Rotation = 90,
                            Transparency = NSnew {
                                NSKnew(0, 0),
                                NSKnew(1, 1)
                            }
                        })
                    }), ab.NewRoundFrame(an, "Squircle", {
                        Size = Dim2(0, ak and 30 or 20, 0, 20),
                        Position = Dim2(0, 2, 0.5, 0),
                        AnchorPoint = Vec2(0, 0.5),
                        ImageTransparency = 1,
                        Name = "Frame"
                    }, {
                        ab.NewRoundFrame(an,"Squircle", {
                            Size = DIM1010,
                            ImageTransparency = 0,
                            ThemeTag = {
                                ImageColor3 = "ToggleBar"
                            },
                            AnchorPoint = VEC05,
                            Position = DIM05,
                            Name = "Bar"
                        }, {
                            ab.NewRoundFrame(an, "SquircleOutline2", {
                                Size = DIM1010,
                                ImageColor3 = WHITE,
                                Name = "Highlight",
                                ImageTransparency = .45
                            }, {
                                ac("UIGradient", {
                                    Rotation = 60, Color = CSnew {
                                        CSKnew(0.0, WHITE),
                                        CSKnew(0.5, WHITE),
                                        CSKnew(1.0, WHITE)
                                    }, Transparency = NSnew {
                                        NSKnew(0.0, 0.1),
                                        NSKnew(0.5, 1),
                                        NSKnew(1.0, 0.1)
                                    }
                                })
                            }), ao, ac("UIScale", {
                                Scale = 1
                            });
                        });
                    });
                }); local ar, as = nil, nil;
                local at = ak and 30 or 20;
                local au = aq.Size.X.Offset;
                function am.Set(av, aw, ax, ay)
                    if not ay then
                        if not isFirstLoad then
                            if aw then
                                TwCreate(TweenService, aq.Frame, TwInfo(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = Dim2(0, au - at - 2, 0.5, 0)}):Play();
                            else
                                TwCreate(TweenService, aq.Frame, TwInfo(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = Dim2(0, 2, 0.5, 0)}):Play();
                            end;
                        else
                            if aw then
                                aq.Frame.Position = Dim2(0, au - at - 2, 0.5, 0);
                            else
                                aq.Frame.Position = Dim2(0, 2, 0.5, 0);
                            end;
                        end;
                    end; if not isFirstLoad then
                        if aw then
                            TwCreate(TweenService, aq.Layer, TWI_01, {ImageTransparency = 0}):Play();
                            if ao then
                                TwCreate(TweenService, ao, TWI_01, {ImageTransparency = 0}):Play();
                            end;
                        else
                            TwCreate(TweenService, aq.Layer, TWI_01,{ImageTransparency = 1}):Play();
                            if ao then
                                TwCreate(TweenService, ao, TWI_01,{ImageTransparency = 1}):Play();
                            end;
                        end;
                    else
                        if aw then
                            aq.Layer.ImageTransparency = 0;
                            if ao then
                                ao.ImageTransparency = 0;
                            end;
                        else
                            aq.Layer.ImageTransparency = 1;
                            if ao then
                                ao.ImageTransparency = 1;
                            end;
                        end;
                    end; ax = ax ~= false; tk.spawn(function()
                        if aj and ax then
                            ab.SafeCallback(aj, aw);
                        end;
                    end);
                end; function am.Animate(av, aw, ax)
                    if not al.Window.IsToggleDragging then
                        al.Window.IsToggleDragging = true;
                        local ay, az = aw.Position.X, aw.Position.Y;
                        local aA, aB = aq.Frame.Position.X.Offset, false;
                        if not isFirstLoad then
                            TwCreate(TweenService, aq.Frame.Bar.UIScale, TwInfo(0.28), {Scale = 1.5}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play();
                            TwCreate(TweenService, aq.Frame.Bar, TwInfo(0.28), {ImageTransparency = 0.85}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play();
                        else
                            aq.Frame.Bar.UIScale.Scale = 1.5;
                            aq.Frame.Bar.ImageTransparency = 0.85;
                        end;
                        if ar then ar:Disconnect(); end;
                        ar = UIS.InputChanged:Connect(function(aC)
                            if al.Window.IsToggleDragging and (aC.UserInputType == Enum.UserInputType.MouseMovement or aC.UserInputType == Enum.UserInputType.Touch) then
                                if aB then return; end; local aD, aE = math.abs(aC.Position.X - ay), math.abs(aC.Position.Y - az);
                                if aE > aD and aE > 10 then
                                    aB = true; al.Window.IsToggleDragging = false;
                                    if ar then ar:Disconnect(); ar = nil; end;
                                    if as then as:Disconnect(); as = nil; end;
                                    if not isFirstLoad then
                                        TwCreate(TweenService, aq.Frame, TwInfo(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                            {Position = Dim2(0, aA, 0.5, 0)}
                                        ):Play(); TwCreate(TweenService, aq.Frame.Bar.UIScale, TwInfo(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                            {Scale = 1}
                                        ):Play(); TwCreate(TweenService, aq.Frame.Bar, TwInfo(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                            {ImageTransparency = 0}
                                        ):Play();
                                    else
                                        aq.Frame.Position = Dim2(0, aA, 0.5, 0);
                                        aq.Frame.Bar.UIScale.Scale = 1;
                                        aq.Frame.Bar.ImageTransparency = 0;
                                    end; return;
                                end; local aF = aC.Position.X - ay;
                                local b = math.max(2, math.min(aA + aF, au - at - 2));
                                local d = (aq.Frame.Position.X.Offset - 2) / (au - at - 4);
                                if not isFirstLoad then
                                    TwCreate(TweenService, aq.Frame, TwInfo(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                                        {Position = Dim2(0, b, 0.5, 0)}
                                    ):Play();
                                else
                                    aq.Frame.Position = Dim2(0, b, 0.5, 0);
                                end;
                            end;
                        end); if as then
                            as:Disconnect();
                        end; as = UIS.InputEnded:Connect(function(aC)
                            if al.Window.IsToggleDragging and (aC.UserInputType == Enum.UserInputType.MouseButton1 or aC.UserInputType == Enum.UserInputType.Touch) then
                                al.Window.IsToggleDragging = false; if ar then
                                    ar:Disconnect(); ar = nil;
                                end; if as then
                                    as:Disconnect();
                                    as = nil;
                                end; if aB then return; end;
                                local aD, aE = aq.Frame.Position.X.Offset, math.abs(aC.Position.X - ay);
                                if aE < 10 then local aF = not ax.Value; ax:Set(aF, true, false) else
                                    local aF = aD + at / 2; local b = au / 2; local d = aF > b;
                                    ax:Set(d, true, false);
                                end; if not isFirstLoad then
                                    TwCreate(TweenService, aq.Frame.Bar.UIScale, TwInfo(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                        {Scale = 1}
                                    ):Play(); TwCreate(TweenService, aq.Frame.Bar, TwInfo(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                        {ImageTransparency = 0}
                                    ):Play();
                                else
                                    aq.Frame.Bar.UIScale.Scale = 1;
                                    aq.Frame.Bar.ImageTransparency = 0;
                                end;
                            end;
                        end);
                    end;
                end; return ap, am;
            end; return aa;
        end;
        function a.D()
            local aa = {}

            local ab = a.load "b"
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag, ah, ai, aj)
                local ak = {}

                af = af or "sfsymbols:checkmark"

                local al = 9

                local am = ab.Image(af, af, 0, (aj and aj.Window.Folder or "Temp"), "Checkbox", true, false, "CheckboxIcon")
                am.Size = Dim2(1, -26 + ag, 1, -26 + ag)
                am.AnchorPoint = VEC05
                am.Position = DIM05

                local an =
                    ab.NewRoundFrame(
                    al,
                    "Squircle",
                    {
                        ImageTransparency = .85,
                        ThemeTag = {
                            ImageColor3 = "Text"
                        },
                        Parent = ah,
                        Size = Dim2(0, 26, 0, 26)
                    },
                    {
                        ab.NewRoundFrame(
                            al,
                            "Squircle",
                            {
                                Size = DIM1010,
                                Name = "Layer",
                                ThemeTag = {
                                    ImageColor3 = "Checkbox"
                                },
                                ImageTransparency = 1
                            }
                        ),
                        ab.NewRoundFrame(
                            al,
                            "SquircleOutline",
                            {
                                Size = DIM1010,
                                Name = "Stroke",
                                ImageColor3 = WHITE,
                                ImageTransparency = 1
                            },
                            {
                                ac(
                                    "UIGradient",
                                    {
                                        Rotation = 90,
                                        Transparency = NumberSequence.new {
                                            NumberSequenceKeypoint.new(0, 0),
                                            NumberSequenceKeypoint.new(1, 1)
                                        }
                                    }
                                )
                            }
                        ),
                        am
                    }
                )

                function ak.Set(ao, ap)
                    if not isFirstLoad then
                        if ap then
                            TwCreate(TweenService, an.Layer, TWI_006,
                                {ImageTransparency = 0}
                            ):Play(); TwCreate(TweenService, am.ImageLabel, TWI_006,
                                {ImageTransparency = 0}
                            ):Play();
                        else
                            TwCreate(TweenService, an.Layer, TWI_005,
                                    {ImageTransparency = 1}
                            ):Play();
                            TwCreate(TweenService, am.ImageLabel, TWI_006,
                                {ImageTransparency = 1}
                            ):Play();
                        end;
                    else
                        if ap then
                            an.Layer.ImageTransparency = 0;
                            am.ImageLabel.ImageTransparency = 0;
                        else
                            an.Layer.ImageTransparency = 1;
                            am.ImageLabel.ImageTransparency = 1;
                        end;
                    end; tk.spawn(function()
                        if ai then
                            ab.SafeCallback(ai, ap);
                        end;
                    end);
                end; return an, ak;
            end; return aa;
        end;
        function a.E()
            local aa = a.load "b";
            local ab = aa.New;
            local ac = aa.Tween;

            local ad = a.load "C".New
            local ae = a.load "D".New

            local af = {}

            function af.New(ag, ah)
                local ai = {
                    __type = "Toggle",
                    Title = ah.Title or "Toggle",
                    Desc = ah.Desc or nil,
                    Locked = ah.Locked or false,
                    Value = ah.Value,
                    Icon = ah.Icon or nil,
                    IconSize = ah.IconSize or 23,
                    Type = ah.Type or "Toggle",
                    Bindable = ah.Bindable or nil,
                    BindToGlobal = ah.BindToGlobal or nil,
                    PathName = ah.PathName,
                    Callback = ah.Callback or function()
                        end,
                    UIElements = {}
                }
                ai.ToggleFrame =
                    a.load "z" {
                    Title = ai.Title,
                    Desc = ai.Desc,
                    Window = ah.Window,
                    Parent = ah.Parent,
                    TextOffset = (52),
                    Hover = false,
                    Tab = ah.Tab,
                    Index = ah.Index,
                    ElementTable = ai,
                    ParentConfig = ah
                }

                local aj = true

                if ai.Value == nil then
                    ai.Value = false
                end

                function ai.Lock(ak)
                    ai.Locked = true
                    aj = false
                    return ai.ToggleFrame:Lock()
                end
                function ai.Unlock(ak)
                    ai.Locked = false
                    aj = true
                    return ai.ToggleFrame:Unlock()
                end

                if ai.Locked then
                    ai:Lock()
                end

                local ak, ak2 = ai.Value, ai.Value;

                local al, am
                if ai.Type == "Toggle" then
                    al, am =
                        ad(ak, ai.Icon, ai.IconSize, ai.ToggleFrame.UIElements.Main, ai.Callback, ah.Window.NewElements, ah)
                elseif ai.Type == "Checkbox" then
                    al, am = ae(ak, ai.Icon, ai.IconSize, ai.ToggleFrame.UIElements.Main, ai.Callback, ah)
                else
                    error("Unknown Toggle Type: " .. tostring(ai.Type))
                end

                al.AnchorPoint = Vec2(1, ah.Window.NewElements and 0 or 0.5)
                al.Position = Dim2(1, 0, ah.Window.NewElements and 0 or 0.5, 0)
                
                if ai.Bindable then
                    local akb = a.load "t".New;
                    ai.UIElements.Keybind = akb(type(ai.Bindable) == "string" and ai.Bindable or "None", nil, ai.ToggleFrame.UIElements.Main);
                    ai.UIElements.Keybind.Size = Dim2(0, 24 + ai.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 28);
                    ai.UIElements.Keybind.AnchorPoint = Vec2(1, 0.5);
                    local offset = ai.Type == "Toggle" and (ah.Window.NewElements and 55 or 65) or 45;
                    ai.UIElements.Keybind.Position = Dim2(1, -offset, ah.Window.NewElements and 0 or 0.5, ah.Window.NewElements and -5 or 0);
                    ab("UIScale", {
                        Parent = ai.UIElements.Keybind,
                        Scale = 0.85
                    });
                    ai.UIElements.Keybind.Parent = al;
                    ai.UIElements.Keybind.LayoutOrder = -1;
                    local UILay = Instancen("UIListLayout", al);
                    UILay.Padding = Dim(0, 5);
                    UILay.SortOrder = Enum.SortOrder.LayoutOrder;
                    UILay.FillDirection = Enum.FillDirection.Horizontal;
                    UILay.HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    ai.UIElements.Keybind.Frame.Frame.TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
                    aa.AddSignal(ai.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal("TextBounds"), function()
                        ai.UIElements.Keybind.Size = Dim2(0, 24 + ai.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 28)
                    end);
                    local picking = false;
                    aa.AddSignal(ai.UIElements.Keybind.MouseButton1Click, function()
                        if ai.Bindable then
                            ai.Bindable = nil;
                            ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = if ai.BindToGlobal then "++" else "+";
                            if ai.PathName then BindConfig[ai.PathName] = nil; end;
                            return;
                        end;
                        if aj then
                            picking = true; ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = "...";
                            twait(0.2); local conn=nil; conn = UIS.InputBegan:Connect(function(an)
                                local ao = nil; if an.UserInputType == Enum.UserInputType.Keyboard then
                                    ao = an.KeyCode.Name;
                                elseif an.UserInputType == Enum.UserInputType.MouseButton1 then
                                    ao = "MouseButton1";
                                elseif an.UserInputType == Enum.UserInputType.MouseButton2 then
                                    ao = "MouseButton2";
                                end;
                                local conn2 = nil; conn2 = UIS.InputEnded:Connect(function(aq)
                                    if aq.KeyCode.Name == ao or (ao == "MouseButton1" and aq.UserInputType == Enum.UserInputType.MouseButton1) or (ao == "MouseButton2" and aq.UserInputType == Enum.UserInputType.MouseButton2) then
                                        picking = false; ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = ao;

                                        if ai.BindToGlobal then
                                            GlobalBinds[ai.BindToGlobal] = ao;
                                        else
                                            if ai.PathName then BindConfig[ai.PathName] = ao; end;
                                        end;

                                        ai.Bindable = ao; conn:Disconnect(); conn2:Disconnect();
                                    end;
                                end);
                            end);
                        end;
                    end);
                    aa.AddSignal(UIS.InputBegan, function(an, ap)
                        if ai.Bindable == "+" or ai.BindToGlobal or UIS:GetFocusedTextBox() then return; end;
                        if not aj or picking then return; end;
                        if an.UserInputType == Enum.UserInputType.Keyboard and an.KeyCode.Name == ai.Bindable then
                            ai:Set(not ai.Value);
                        elseif an.UserInputType == Enum.UserInputType.MouseButton1 and ai.Bindable == "MouseButton1" then
                            ai:Set(not ai.Value);
                        elseif an.UserInputType == Enum.UserInputType.MouseButton2 and ai.Bindable == "MouseButton2" then
                            ai:Set(not ai.Value);
                        end;
                    end);
                end

                function ai.Set(an, ao, ap, aq)
                    if aj then
                        am:Set(ao, ap, aq or false)
                        ak = ao
                        ai.Value = ao
                    end
                end

                ai:Set(ak, false, ah.Window.NewElements)

                if ah.Window.NewElements and am.Animate then
                    aa.AddSignal(
                        ai.ToggleFrame.UIElements.Main.InputBegan,
                        function(an)
                            if
                                not ah.Window.IsToggleDragging and an.UserInputType == Enum.UserInputType.MouseButton1 or
                                    an.UserInputType == Enum.UserInputType.Touch
                            then
                                am:Animate(an, ai)
                            end
                        end
                    )
                else
                    aa.AddSignal(
                        ai.ToggleFrame.UIElements.Main.MouseButton1Click,
                        function()
                            ai:Set(not ai.Value, nil, ah.Window.NewElements)
                        end
                    )
                end; local sig=nil; sig=GG.LoadingSignal:Connect(function(v)
                    if v == 100 then
                        if ak2 then
                            pcall(function()
                                if ai and ai.ToggleFrame and ai.ToggleFrame.Parent then
                                    ai:Set(ak2);
                                end;
                            end);
                        end;
                        if sig then
                            sig:Disconnect(); sig=nil;
                        end;
                    end;
                end);

                return ai.__type, ai
            end
            
            return af
        end
        function a.F()
            local ag, ah = {}, false; local ad = a.load"b"; local ae = ad.New;
            function ag.New(ai, aj)
                local ak = {
                    __type = "Slider",
                    Title = aj.Title or nil,
                    Desc = aj.Desc or nil,
                    Locked = aj.Locked or nil,
                    Value = aj.Value or {},
                    Icons = aj.Icons or nil,
                    IsTooltip = aj.IsTooltip or false,
                    IsTextbox = aj.IsTextbox,
                    Step = aj.Step or 1,
                    Callback = aj.Callback or function() end,
                    UIElements = {},
                    IsFocusing = false,
                    Width = aj.Width or 130,
                    TextBoxWidth = aj.Window.NewElements and 40 or 30,
                    ThumbSize = 13,
                    IconSize = 26,
                    allign = aj.allign or Enum.TextXAlignment.Right;
                }; if ak.Icons == {} then
                    ak.Icons = {
                        From = "sfsymbols:sunMinFill",
                        To = "sfsymbols:sunMaxFill"
                    };
                end; if ak.IsTextbox == nil and ak.Title == nil then
                    ak.IsTextbox = false;
                else
                    ak.IsTextbox = ak.IsTextbox ~= false;
                end; local al, am, an = nil, nil, nil;
                local ao = ak.Value.Default or ak.Value.Min or 0;
                local ap, aq = ao, (ao - (ak.Value.Min or 0)) / ((ak.Value.Max or 100) - (ak.Value.Min or 0));
                local ar, as = true, ak.Step % 1 ~= 0;
                local function FormatValue(at)
                    if as then return tonumber(str.format("%.2f", at)) else
                        return tonumber(math.floor(at + 0.5));
                    end;
                end; local function CalculateValue(at)
                    if as then return math.floor(at / ak.Step + 0.5) * ak.Step else
                        return math.floor(at / ak.Step + 0.5) * ak.Step;
                    end;
                end; local at, au, av = nil, nil, 32;
                if ak.Icons then
                    if ak.Icons.From then
                        at = ad.Image(
                            ak.Icons.From,
                            ak.Icons.From,
                            0,
                            aj.Window.Folder,
                            "SliderIconFrom",
                            true,
                            true,
                            "SliderIconFrom"
                        ); at.Size = Dim2(0, ak.IconSize, 0, ak.IconSize);
                        av = av + ak.IconSize - 2;
                    end; if ak.Icons.To then
                        au = ad.Image(
                            ak.Icons.To,
                            ak.Icons.To,
                            0,
                            aj.Window.Folder,
                            "SliderIconTo",
                            true,
                            true,
                            "SliderIconTo"
                        ); au.Size = Dim2(0, ak.IconSize, 0, ak.IconSize);
                        av = av + ak.IconSize - 2;
                    end;
                end; ak.SliderFrame = a.load "z" {
                        Title = ak.Title,
                        Desc = ak.Desc,
                        Parent = aj.Parent,
                        TextOffset = ak.Width,
                        Hover = false,
                        Tab = aj.Tab,
                        Index = aj.Index,
                        Window = aj.Window,
                        ElementTable = ak,
                        ParentConfig = aj
                    }; ak.UIElements.SliderIcon = ad.NewRoundFrame(99, "Squircle", {
                        ImageTransparency = .95,
                        Size = Dim2(1, not ak.IsTextbox and -av or (-ak.TextBoxWidth - 8), 0, 4),
                        AnchorPoint = VEC05,
                        Position = DIM05,
                        Name = "Frame",
                        ThemeTag = {ImageColor3 = "Text"}
                }, {
                    ad.NewRoundFrame(99, "Squircle", {
                        Name = "Frame",
                        Size = Dim2(aq, 0, 1, 0),
                        ImageTransparency = .1,
                        ThemeTag = {ImageColor3 = "Slider"}
                    }, {
                        ad.NewRoundFrame(99, "Squircle", {
                            Size = Dim2(0, aj.Window.NewElements and (ak.ThumbSize * 2) or (ak.ThumbSize + 2), 0, aj.Window.NewElements and (ak.ThumbSize + 4) or (ak.ThumbSize + 2)),
                            Position = Dim2(1, 0, 0.5, 0),
                            AnchorPoint = VEC05,
                            ThemeTag = {ImageColor3 = "SliderThumb"},
                            Name = "Thumb"
                        }, {
                            ad.NewRoundFrame(99, "SquircleOutline2", {
                                Size = DIM1010,
                                ImageColor3 = WHITE,
                                Name = "Highlight",
                                ImageTransparency = .45
                            }, {
                                ae("UIGradient", {
                                    Rotation = 60,
                                    Color = CSnew {
                                        CSKnew(0.0, WHITE),
                                        CSKnew(0.5, WHITE),
                                        CSKnew(1.0, WHITE)
                                    },
                                    Transparency = NSnew {
                                        NSKnew(0.0, 0.1),
                                        NSKnew(0.5, 1),
                                        NSKnew(1.0, 0.1)
                                    };
                                });
                            });
                        });
                    });
                }); ak.UIElements.SliderContainer = ae("Frame", {
                    Size = Dim2(ak.Title == nil and 1 or 0, ak.Title == nil and 0 or ak.Width, 0, 0),
                    AutomaticSize = "Y",
                    Position = Dim2(1, ak.IsTextbox and (aj.Window.NewElements and -16 or 0) or 0, 0.5, 0),
                    AnchorPoint = Vec2(1, 0.5),
                    BackgroundTransparency = 1,
                    Parent = ak.SliderFrame.UIElements.Main
                }, {
                    ae("UIListLayout", {
                        Padding = Dim(0, ak.Title ~= nil and 8 or 12),
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                        HorizontalAlignment = ak.Icons and (ak.Icons.From and (ak.Icons.To and "Center" or "Left") or ak.Icons.To and "Right") or "Center"
                    }), at, ak.UIElements.SliderIcon, au, ae("TextBox", {
                        Size = Dim2(0, ak.TextBoxWidth, 0, 0),
                        TextXAlignment = "Left",
                        Text = FormatValue(ao),
                        ThemeTag = {
                            TextColor3 = "Text"
                        },
                        TextTransparency = .4,
                        AutomaticSize = "Y",
                        TextSize = 15,
                        FontFace = Fnew(ad.Font, Enum.FontWeight.Medium),
                        BackgroundTransparency = 1,
                        LayoutOrder = -1,
                        Visible = ak.IsTextbox
                    });
                }); local aw=nil; if ak.IsTooltip then
                    aw = a.load("y").New(ao, ak.UIElements.SliderIcon.Frame.Thumb, true, "Secondary", "Small", false);
                    aw.Container.AnchorPoint = Vec2(0.5, 1); aw.Container.Position = Dim2(0.5, 0, 0, -8);
                end; function ak.Lock(ax)
                    ak.Locked = true; ar = false;
                    return ak.SliderFrame:Lock();
                end; function ak.Unlock(ax)
                    ak.Locked = false; ar = true;
                    return ak.SliderFrame:Unlock();
                end; if ak.Locked then
                    ak:Lock();
                end; local ax = aj.Tab.UIElements.ContainerFrame;
                function ak.Set(ay, az, aA)
                    if ar then
                        if not ak.IsFocusing and not ah and (not aA or (aA.UserInputType == Enum.UserInputType.MouseButton1 or aA.UserInputType == Enum.UserInputType.Touch)) then
                            if aA then
                                al = (aA.UserInputType == Enum.UserInputType.Touch);
                                ax.ScrollingEnabled = false; ah = true;
                                local aB = al and aA.Position.X or UIS:GetMouseLocation().X;
                                local aC = math.clamp((aB - ak.UIElements.SliderIcon.AbsolutePosition.X) / ak.UIElements.SliderIcon.AbsoluteSize.X, 0, 1);
                                az = CalculateValue(ak.Value.Min + aC * (ak.Value.Max - ak.Value.Min))
                                az = math.clamp(az, ak.Value.Min or 0, ak.Value.Max or 100);
                                if az ~= ap then
                                    if not isFirstLoad then
                                        TwCreate(TweenService, ak.UIElements.SliderIcon.Frame, TWI_005, {Size = Dim2(aC, 0, 1, 0)}):Play();
                                    else
                                        ak.UIElements.SliderIcon.Frame.Size = Dim2(aC, 0, 1, 0);
                                    end;
                                    ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az); if aw then
                                        aw.TitleFrame.Text = FormatValue(az);
                                    end; ak.Value.Default = FormatValue(az)
                                    ap = az; ad.SafeCallback(ak.Callback, FormatValue(az));
                                end; am = RunService.RenderStepped:Connect(function()
                                    local aD = al and aA.Position.X or UIS:GetMouseLocation().X;
                                    local aE = math.clamp((aD - ak.UIElements.SliderIcon.AbsolutePosition.X) / ak.UIElements.SliderIcon.AbsoluteSize.X, 0, 1);
                                    az = CalculateValue(ak.Value.Min + aE * (ak.Value.Max - ak.Value.Min)) if az ~= ap then
                                        if not isFirstLoad then
                                            TwCreate(TweenService, ak.UIElements.SliderIcon.Frame, TWI_005, {Size = Dim2(aE, 0, 1, 0)}):Play();
                                        else
                                            ak.UIElements.SliderIcon.Frame.Size = Dim2(aE, 0, 1, 0);
                                        end;
                                        ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az); if aw then
                                            aw.TitleFrame.Text = FormatValue(az);
                                        end; ak.Value.Default = FormatValue(az)
                                        ap = az; ad.SafeCallback(ak.Callback, FormatValue(az));
                                    end;
                                end); an = UIS.InputEnded:Connect(function(aD)
                                    if (aD.UserInputType == Enum.UserInputType.MouseButton1 or aD.UserInputType == Enum.UserInputType.Touch) and aA == aD then
                                        am:Disconnect(); an:Disconnect(); ah = false; ax.ScrollingEnabled = true;
                                        if aj.Window.NewElements then
                                            TwCreate(TweenService, ak.UIElements.SliderIcon.Frame.Thumb, TwInfo(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
                                                {ImageTransparency = 0, Size = Dim2(0, aj.Window.NewElements and (ak.ThumbSize * 2) or (ak.ThumbSize + 2), 0, aj.Window.NewElements and (ak.ThumbSize + 4) or (ak.ThumbSize + 2))}
                                            ):Play();
                                        end; if aw then
                                            aw:Close(false);
                                        end;
                                    end;
                                end);
                            else
                                az = math.clamp(az, ak.Value.Min or 0, ak.Value.Max or 100);
                                local aB = math.clamp((az - (ak.Value.Min or 0)) / ((ak.Value.Max or 100) - (ak.Value.Min or 0)), 0, 1);
                                az = CalculateValue(ak.Value.Min + aB * (ak.Value.Max - ak.Value.Min));
                                if az ~= ap then
                                    TwCreate(TweenService, ak.UIElements.SliderIcon.Frame, TWI_005, {Size = Dim2(aB, 0, 1, 0)}):Play();
                                    ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az);
                                    if aw then aw.TitleFrame.Text = FormatValue(az); end;
                                    ak.Value.Default = FormatValue(az); ap = az;
                                    ad.SafeCallback(ak.Callback, FormatValue(az));
                                end;
                            end;
                        end;
                    end;
                end; ak.UIElements.SliderContainer.TextBox.TextXAlignment = ak.allign;
                function ak.SetMax(ay, az)
                    ak.Value.Max = az; local aA = tonumber(ak.Value.Default) or ap;
                    if aA > az then ak:Set(az); else
                        local aB = math.clamp((aA - (ak.Value.Min or 0)) / (az - (ak.Value.Min or 0)), 0, 1)
                        TwCreate(TweenService, ak.UIElements.SliderIcon.Frame, TWI_01, {Size = Dim2(aB, 0, 1, 0)}):Play();
                    end;
                end; function ak.SetMin(ay, az)
                    ak.Value.Min = az; local aA = tonumber(ak.Value.Default) or ap;
                    if aA < az then ak:Set(az); else
                        local aB = math.clamp((aA - az) / ((ak.Value.Max or 100) - az), 0, 1);
                        TwCreate(TweenService, ak.UIElements.SliderIcon.Frame, TWI_01, {Size = Dim2(aB, 0, 1, 0)}):Play();
                    end;
                end; ad.AddSignal(ak.UIElements.SliderContainer.TextBox.FocusLost, function(ay)
                    if ay then
                        local az = tonumber(ak.UIElements.SliderContainer.TextBox.Text);
                        if az then ak:Set(az); else
                            ak.UIElements.SliderContainer.TextBox.Text = FormatValue(ap)
                            if aw then aw.TitleFrame.Text = FormatValue(ap); end;
                        end;
                    end;
                end); ad.AddSignal(ak.UIElements.SliderContainer.InputBegan, function(ay)
                    if ak.Locked or ah then return; end; ak:Set(ao, ay)
                    if ay.UserInputType == Enum.UserInputType.MouseButton1 or ay.UserInputType == Enum.UserInputType.Touch then
                        if aj.Window.NewElements then
                            TwCreate(TweenService, ak.UIElements.SliderIcon.Frame.Thumb, TwInfo(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                                ImageTransparency = 0.85,
                                Size = Dim2(0, (aj.Window.NewElements and (ak.ThumbSize * 2) or (ak.ThumbSize)) + 8, 0, ak.ThumbSize + 8)
                            }):Play();
                        end; if aw then aw:Open(); end;
                    end;
                end); 
                
                ad.SafeCallback(ak.Callback, FormatValue(tonumber(ak.UIElements.SliderContainer.TextBox.Text)));
                
                return ak.__type, ak;
            end; return ag;
        end;
        function a.G()
            local ad = a.load"b"; local ae = ad.New;
            local ag = {UICorner = 6,UIPadding = 8};
            local ah = a.load "t".New;
            function ag.New(ai, aj)
                local ak, al = {
                    __type = "Keybind",
                    Title = aj.Title or "Keybind",
                    Desc = aj.Desc or nil,
                    Locked = aj.Locked or false,
                    Value = aj.Value or nil,
                    Callback = aj.Callback or function()
                        end,
                    CanChange = aj.CanChange or true,
                    Picking = false,
                    UIElements = {}
                }, true; ak.KeybindFrame = a.load "z" {
                    Title = ak.Title,
                    Desc = ak.Desc,
                    Parent = aj.Parent,
                    TextOffset = 85,
                    Hover = ak.CanChange,
                    Tab = aj.Tab,
                    Index = aj.Index,
                    Window = aj.Window,
                    ElementTable = ak,
                    ParentConfig = aj
                }; ak.UIElements.Keybind = ah(ak.Value, nil, ak.KeybindFrame.UIElements.Main);
                ak.UIElements.Keybind.Size = Dim2(0, 24 + ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42);
                ak.UIElements.Keybind.AnchorPoint = Vec2(1, 0.5);
                ak.UIElements.Keybind.Position = Dim2(1, 0, 0.5, 0);
                ak.UIElements.Keybind.Frame.Frame.TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
                ae("UIScale", {
                    Parent = ak.UIElements.Keybind,
                    Scale = 0.85
                }); ad.AddSignal(ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal "TextBounds", function()
                    ak.UIElements.Keybind.Size = Dim2(0, 24 + ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
                end); function ak.Lock(am)
                    ak.Locked = true; al = false;
                    return ak.KeybindFrame:Lock();
                end; function ak.Unlock(am)
                    ak.Locked = false; al = true;
                    return ak.KeybindFrame:Unlock();
                end; function ak.Set(am, an)
                    ak.Value = an;
                    ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = an;
                    if ak.GBind then
                        GBind[ak.GBind] = an;
                    end;
                end; if ak.Locked then
                    ak:Lock();
                end; ad.AddSignal(ak.KeybindFrame.UIElements.Main.MouseButton1Click, function()
                    if al then
                        if ak.CanChange then
                            ak.Picking = true; ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = "...";
                            twait(0.2) local am=nil; am = UIS.InputBegan:Connect(function(an)
                                local ao, ap=nil, nil; if an.UserInputType == Enum.UserInputType.Keyboard then
                                    ao = an.KeyCode.Name;
                                elseif an.UserInputType == Enum.UserInputType.MouseButton1 then
                                    ao = "MouseButton1";
                                elseif an.UserInputType == Enum.UserInputType.MouseButton2 then
                                    ao = "MouseButton2";
                                end; ap = UIS.InputEnded:Connect(function(aq)
                                    if aq.KeyCode.Name == ao or ao == "MouseButton1" and aq.UserInputType == Enum.UserInputType.MouseButton1 or ao == "MouseButton2" and aq.UserInputType == Enum.UserInputType.MouseButton2 then
                                        ak.Picking = false; ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = ao;
                                        ak.Value = ao; am:Disconnect(); ap:Disconnect();
                                    end;
                                end); if ak.GBind then
                                    GBind[ak.GBind] = ao;
                                end;
                            end);
                        end;
                    end;
                end); ad.AddSignal(UIS.InputBegan, function(am, an)
                    if UIS:GetFocusedTextBox() then return; end;
                    if not al then return; end; if am.UserInputType == Enum.UserInputType.Keyboard then
                        if am.KeyCode.Name == ak.Value then
                            ad.SafeCallback(ak.Callback, am.KeyCode.Name);
                        end;
                    elseif am.UserInputType == Enum.UserInputType.MouseButton1 and ak.Value == "MouseButton1" then
                        ad.SafeCallback(ak.Callback, "MouseButton1");
                    elseif am.UserInputType == Enum.UserInputType.MouseButton2 and ak.Value == "MouseButton2" then
                        ad.SafeCallback(ak.Callback, "MouseButton2");
                    end;
                end);
                
                if ak.Value then
                    ak:Set(ak.Value);
                end;
                
                return ak.__type, ak;
            end; return ag;
        end;
        function a.H()
            local aa = a.load"b"; local ac = aa.New;
            local ae = {UICorner = 8,UIPadding = 8};
            local af = a.load"j".New;local ag = a.load"k".New;
            function ae.New(ah, ai)
                local aj, ak = {
                    __type = "Input",
                    Title = ai.Title or "Input",
                    Desc = ai.Desc or nil,
                    Type = ai.Type or "Input",
                    Locked = ai.Locked or false,
                    InputIcon = ai.InputIcon or false,
                    Placeholder = ai.Placeholder or "Enter Text...",
                    Value = ai.Value or "",
                    Callback = ai.Callback or function() end,
                    ClearTextOnFocus = ai.ClearTextOnFocus or false,
                    UIElements = {},
                    Width = 150
                }, true; aj.InputFrame = a.load "z" {
                    Title = aj.Title,
                    Desc = aj.Desc,
                    Parent = ai.Parent,
                    TextOffset = aj.Width,
                    Hover = false,
                    Tab = ai.Tab,
                    Index = ai.Index,
                    Window = ai.Window,
                    ElementTable = aj,
                    ParentConfig = ai
                }; local al = ag(aj.Placeholder, aj.InputIcon,
                    aj.Type == "Textarea" and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main, aj.Type, function(al) aj:Set(al, true) end, nil,
                    ai.Window.NewElements and 12 or 10,
                    aj.ClearTextOnFocus
                ); if aj.Type == "Input" then
                    al.Size = Dim2(0, aj.Width, 0, 36);
                    al.Position = Dim2(1, 0, ai.Window.NewElements and 0 or 0.5, 0);
                    al.AnchorPoint = Vec2(1, ai.Window.NewElements and 0 or 0.5);
                else
                    al.Size = Dim2(1, 0, 0, 148);
                end; ac("UIScale", {
                    Parent = al,
                    Scale = 1
                }); function aj.Lock(am)
                    aj.Locked = true; ak = false;
                    return aj.InputFrame:Lock();
                end; function aj.Unlock(am)
                    aj.Locked = false; ak = true;
                    return aj.InputFrame:Unlock();
                end; function aj.Set(am, an, ao)
                    if ak then
                        aj.Value = an; aa.SafeCallback(aj.Callback, an);
                        if not ao then
                            al.Frame.Frame.TextBox.Text = an;
                        end;
                    end;
                end; function aj.SetPlaceholder(am, an)
                    al.Frame.Frame.TextBox.PlaceholderText = an;
                    aj.Placeholder = an;
                end; aj:Set(aj.Value); if aj.Locked then
                    aj:Lock();
                end; return aj.__type, aj;
            end; return ae;
        end;
        function a.I()
            local ae = {}; local aa = a.load"b"; local ac = aa.New;
            function ae.New(af, ag)
                local ah = ac("Frame", {
                    Size = ag.ParentType ~= "Group" and Dim2(1, 0, 0, 1) or Dim2(0, 1, 1, 0),
                    Position = DIM05,
                    AnchorPoint = VEC05,
                    BackgroundTransparency = .9,
                    ThemeTag = {
                        BackgroundColor3 = "Text"
                    }
                }); local ai = ac("Frame", {
                    Parent = ag.Parent,
                    Size = ag.ParentType ~= "Group" and Dim2(1, -7, 0, 7) or Dim2(0, 7, 1, -7),
                    BackgroundTransparency = 1
                },{ah});
                return "Divider", {__type = "Divider", ElementFrame = ai};
            end; return ae;
        end;
        function a.J()
            local aa = {}; local ai = a.load "k".New;
            local aj = a.load "b"; local ak = aj.New;
            function aa.New(am, an, ao, ap, aq)
                local ar = {}; if not an.Callback then
                    aq = "Menu";
                end; an.UIElements.UIListLayout = ak("UIListLayout", {
                    Padding = Dim(0, ao.MenuPadding / 1.5),
                    FillDirection = "Vertical",
                    HorizontalAlignment = "Center"
                }); an.UIElements.Menu = aj.NewRoundFrame(ao.MenuCorner, "Squircle", {
                    ThemeTag = {ImageColor3 = "Background"},
                    ImageTransparency = 1,
                    Size = DIM1010,
                    AnchorPoint = Vec2(1, 0),
                    Position = Dim2(1, 0, 0, 0)
                }, {
                    ak("UIPadding", {
                        PaddingTop = Dim(0, ao.MenuPadding),
                        PaddingLeft = Dim(0, ao.MenuPadding),
                        PaddingRight = Dim(0, ao.MenuPadding),
                        PaddingBottom = Dim(0, ao.MenuPadding)
                    }), ak("UIListLayout", {
                        FillDirection = "Vertical",
                        Padding = Dim(0, ao.MenuPadding)
                    }), ak("Frame", {
                        BackgroundTransparency = 1,
                        Size = Dim2(1, 0, 1, an.SearchBarEnabled and -ao.MenuPadding - ao.SearchBarHeight),
                        ClipsDescendants = true,
                        LayoutOrder = 999
                    }, {
                        ak("UICorner",{
                            CornerRadius = Dim(0, ao.MenuCorner - ao.MenuPadding)
                        }), ak("ScrollingFrame", {
                            Size = DIM1010,
                            ScrollBarThickness = 0,
                            ScrollingDirection = "Y",
                            AutomaticCanvasSize = "Y",
                            CanvasSize = DIM0000,
                            BackgroundTransparency = 1,
                            ScrollBarImageTransparency = 1
                        }, {
                            an.UIElements.UIListLayout
                        });
                    });
                }); an.UIElements.MenuCanvas = ak("Frame", {
                    Size = Dim2(0, an.MenuWidth, 0, 300),
                    BackgroundTransparency = 1,
                    Position = Dim2(-10, 0, -10, 0),
                    Visible = false,
                    Active = false,
                    Parent = am.WindUI.DropdownGui,
                    AnchorPoint = Vec2(1, 0)
                }, {
                    an.UIElements.Menu,
                    ak("UISizeConstraint", {
                        MinSize = Vec2(170, 0),
                        MaxSize = Vec2(300, 400)
                    });
                });
                local function RecalculateCanvasSize()
                    an.UIElements.Menu.Frame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, an.UIElements.UIListLayout.AbsoluteContentSize.Y);
                end local function RecalculateListSize()
                    local as = Cam.ViewportSize.Y * 0.6;
                    local at = an.UIElements.UIListLayout.AbsoluteContentSize.Y;
                    local au = an.SearchBarEnabled and (ao.SearchBarHeight + (ao.MenuPadding * 3)) or (ao.MenuPadding * 2);
                    local av = (at) + au; if av > as then
                        an.UIElements.MenuCanvas.Size = UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X, as);
                    else
                        an.UIElements.MenuCanvas.Size = UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X, av);
                    end;
                end; function UpdatePosition()
                    local as = an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main;
                    local at = an.UIElements.MenuCanvas;
                    local au = Cam.ViewportSize.Y - (as.AbsolutePosition.Y + as.AbsoluteSize.Y) - ao.MenuPadding - 54;
                    local av = at.AbsoluteSize.Y + ao.MenuPadding;
                    local aw = -54; if au < av then
                        aw = av - au - 54;
                    end; at.Position = Dim2(0, as.AbsolutePosition.X + as.AbsoluteSize.X, 0, as.AbsolutePosition.Y + as.AbsoluteSize.Y - aw + (ao.MenuPadding * 2));
                end; local as = nil; function ar.Display(at)
                    local au,av = an.Values, "";
                    if an.Multi then
                        local aw = {}; if typeof(an.Value) == "table" then
                            for ax, ay in ipairs(an.Value) do
                                local az = typeof(ay) == "table" and ay.Title or ay;
                                aw[az] = true;
                            end;
                        end; for ax, ay in ipairs(au) do
                            local az = typeof(ay) == "table" and ay.Title or ay;
                            if aw[az] then
                                av = av .. az .. ", ";
                            end;
                        end; if #av > 0 then
                            av = av:sub(1, #av - 2);
                        end;
                    else
                        av = typeof(an.Value) == "table" and an.Value.Title or an.Value or "";
                    end; if an.UIElements.Dropdown then
                        an.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (av == "" and "--" or av);
                    end;
                end; local function Callback(at)
                    ar:Display(); if an.Callback then
                        tk.spawn(function()
                            aj.SafeCallback(an.Callback, an.Value);
                        end);
                    else
                        tk.spawn(function()
                            aj.SafeCallback(at);
                        end);
                    end;
                end; function ar.LockValues(at, au)
                    if not au then return; end;
                    for av, aw in next, an.Tabs do
                        if aw and aw.UIElements and aw.UIElements.TabItem then
                            local ax,ay = aw.Name, false;
                            for az, aA in next, au do
                                if ax == aA then
                                    ay = true;
                                    break;
                                end;
                            end; if ay then
                                TwCreate(TweenService, aw.UIElements.TabItem, TWI_01, {ImageTransparency = 1}):Play();
                                TwCreate(TweenService, aw.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 1}):Play();
                                TwCreate(TweenService, aw.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0.6}):Play();
                                if aw.UIElements.TabIcon then TwCreate(TweenService, aw.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0.6}):Play(); end; 
                                aw.UIElements.TabItem.Active = false; aw.Locked = true;
                            else
                                if aw.Selected then
                                    TwCreate(TweenService, aw.UIElements.TabItem, TWI_01, {ImageTransparency = 0.95}):Play();
                                    TwCreate(TweenService, aw.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 0.75}):Play();
                                    TwCreate(TweenService, aw.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0}):Play();
                                    if aw.UIElements.TabIcon then TwCreate(TweenService, aw.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0}):Play(); end;
                                else
                                    TwCreate(TweenService, aw.UIElements.TabItem, TWI_01, {ImageTransparency = 1}):Play()
                                    TwCreate(TweenService, aw.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 1}):Play()
                                    TwCreate(TweenService,  aw.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = aq == "Dropdown" and 0.4 or 0.05}):Play();
                                    if aw.UIElements.TabIcon then TwCreate(TweenService, aw.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = aq == "Dropdown" and 0.2 or 0}):Play(); end;
                                end; aw.UIElements.TabItem.Active = true; aw.Locked = false;
                            end;
                        end;
                    end;
                end; function ar.Refresh(at, au)
                    for av, aw in next, GetChildren(an.UIElements.Menu.Frame.ScrollingFrame) do
                        if not aw:IsA("UIListLayout") then
                            aw:Destroy();
                        end;
                    end; an.Tabs = {};
                    if an.SearchBarEnabled then
                        if not as then
                            as = ai("Search...", "search", an.UIElements.Menu, nil, function(ax)
                                for ay, az in next, an.Tabs do
                                    if str.find(string.lower(az.Name), string.lower(ax), 1, true) then
                                        az.UIElements.TabItem.Visible = true;
                                    else
                                        az.UIElements.TabItem.Visible = false;
                                    end RecalculateListSize(); RecalculateCanvasSize();
                                end
                            end, true);
                            as.Size = Dim2(1, 0, 0, ao.SearchBarHeight);
                            as.Position = DIM0000;
                            as.Name = "SearchBar";
                        end;
                    end; for ax, ay in next, au do
                        if (ay.Type ~= "Divider") then
                            local az = {
                                Name = typeof(ay) == "table" and ay.Title or ay,
                                Desc = typeof(ay) == "table" and ay.Desc or nil,
                                Icon = typeof(ay) == "table" and ay.Icon or nil,
                                Original = ay, Selected = false,
                                Locked = typeof(ay) == "table" and ay.Locked or false,
                                UIElements = {}
                            }; local aA = nil;
                            if az.Icon then
                                aA = aj.Image(az.Icon, az.Icon, 0, am.Window.Folder, "Dropdown", true);
                                aA.Size = Dim2(0, ao.TabIcon, 0, ao.TabIcon);
                                aA.ImageLabel.ImageTransparency = aq == "Dropdown" and 0.2 or 0;
                                az.UIElements.TabIcon = aA;
                            end; az.UIElements.TabItem = aj.NewRoundFrame(ao.MenuCorner - ao.MenuPadding, "Squircle", {
                                Size = Dim2(1, 0, 0, 36),
                                AutomaticSize = az.Desc and "Y",
                                ImageTransparency = 1,
                                Parent = an.UIElements.Menu.Frame.ScrollingFrame,
                                ImageColor3 = WHITE,
                                Active = not az.Locked
                            }, {
                                aj.NewRoundFrame(ao.MenuCorner - ao.MenuPadding, "SquircleOutline", {
                                    Size = DIM1010,
                                    ImageColor3 = WHITE,
                                    ImageTransparency = 1,
                                    Name = "Highlight"
                                }, {
                                    ak("UIGradient", {
                                        Rotation = 80,
                                        Color = CSnew {
                                            CSKnew(0.0, WHITE),
                                            CSKnew(0.5, WHITE),
                                            CSKnew(1.0, WHITE)
                                        },
                                        Transparency = NSnew {
                                            NSKnew(0.0, 0.1),
                                            NSKnew(0.5, 1),
                                            NSKnew(1.0, 0.1)
                                        }
                                    })
                                }), ak("Frame", {
                                    Size = DIM1010,
                                    BackgroundTransparency = 1
                                }, {
                                    ak("UIListLayout", {
                                        Padding = Dim(0, ao.TabPadding),
                                        FillDirection = "Horizontal",
                                        VerticalAlignment = "Center"
                                    }), ak("UIPadding", {
                                        PaddingTop = Dim(0, ao.TabPadding),
                                        PaddingLeft = Dim(0, ao.TabPadding),
                                        PaddingRight = Dim(0, ao.TabPadding),
                                        PaddingBottom = Dim(0, ao.TabPadding)
                                    }), ak("UICorner", {
                                        CornerRadius = Dim(0, ao.MenuCorner - ao.MenuPadding)
                                    }), aA, ak("Frame", {
                                        Size = Dim2(1, aA and -ao.TabPadding - ao.TabIcon or 0, 0, 0),
                                        BackgroundTransparency = 1,
                                        AutomaticSize = "Y",
                                        Name = "Title"
                                    }, {
                                        ak("TextLabel", {
                                            Text = az.Name,
                                            TextXAlignment = "Left",
                                            FontFace = Fnew(aj.Font, Enum.FontWeight.Medium),
                                            ThemeTag = {
                                                TextColor3 = "Text",
                                                BackgroundColor3 = "Text"
                                            },
                                            TextSize = 15,
                                            BackgroundTransparency = 1,
                                            TextTransparency = aq == "Dropdown" and .4 or .05,
                                            LayoutOrder = 999,
                                            AutomaticSize = "Y",
                                            Size = Dim2(1, 0, 0, 0)
                                        }), ak("TextLabel", {
                                            Text = az.Desc or "",
                                            TextXAlignment = "Left",
                                            FontFace = Fnew(aj.Font, Enum.FontWeight.Regular),
                                            ThemeTag = {
                                                TextColor3 = "Text",
                                                BackgroundColor3 = "Text"
                                            },
                                            TextSize = 15,
                                            BackgroundTransparency = 1,
                                            TextTransparency = aq == "Dropdown" and .6 or .35,
                                            LayoutOrder = 999,
                                            AutomaticSize = "Y",
                                            TextWrapped = true,
                                            Size = Dim2(1, 0, 0, 0),
                                            Visible = az.Desc and true or false,
                                            Name = "Desc"
                                        }), ak("UIListLayout", {
                                            Padding = Dim(0, ao.TabPadding / 3),
                                            FillDirection = "Vertical"
                                        });
                                    });
                                });
                            }, true); if az.Locked then
                                az.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0.9;
                                if az.UIElements.TabIcon then
                                    az.UIElements.TabIcon.ImageLabel.ImageTransparency = 0.9;
                                end;
                            end; if an.Multi and typeof(an.Value) == "string" then
                                for aB, aC in next, an.Values do
                                    if typeof(aC) == "table" then
                                        if aC.Title == an.Value then
                                            an.Value = {aC};
                                        end;
                                    else
                                        if aC == an.Value then
                                            an.Value = {an.Value};
                                        end;
                                    end;
                                end;
                            end; if an.Multi then
                                local aB = false; if typeof(an.Value) == "table" then
                                    for aC, aD in ipairs(an.Value) do
                                        local aE = typeof(aD) == "table" and aD.Title or aD;
                                        if aE == az.Name then
                                            aB = true;
                                            break;
                                        end;
                                    end;
                                end;
                                az.Selected = aB;
                            else
                                local aB = typeof(an.Value) == "table" and an.Value.Title or an.Value;
                                az.Selected = aB == az.Name;
                            end; if az.Selected and not az.Locked then
                                az.UIElements.TabItem.ImageTransparency = 0.95;
                                az.UIElements.TabItem.Highlight.ImageTransparency = 0.75;
                                az.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0;
                                if az.UIElements.TabIcon then
                                    az.UIElements.TabIcon.ImageLabel.ImageTransparency = 0;
                                end;
                            end; an.Tabs[ax] = az; ar:Display();
                            if aq == "Dropdown" then
                                aj.AddSignal(az.UIElements.TabItem.MouseButton1Click, function()
                                    if az.Locked then return; end;
                                    if an.Multi then
                                        if not az.Selected then
                                            az.Selected = true
                                            TwCreate(TweenService, az.UIElements.TabItem, TWI_01, {ImageTransparency = .95}):Play();
                                            TwCreate(TweenService, az.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = .75}):Play();
                                            TwCreate(TweenService, az.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0}):Play();
                                            if az.UIElements.TabIcon then TwCreate(TweenService, az.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0}):Play(); end; tble.insert(an.Value, az.Original);
                                        else
                                            if not an.AllowNone and #an.Value == 1 then return;end;
                                            az.Selected = false; TwCreate(TweenService, az.UIElements.TabItem, TWI_01, {ImageTransparency = 1}):Play();
                                            TwCreate(TweenService, az.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 1}):Play();
                                            TwCreate(TweenService, az.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0.4}):Play();
                                            if az.UIElements.TabIcon then TwCreate(TweenService, az.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0.2}):Play(); end
                                            for aB, aC in next, an.Value do
                                                if typeof(aC) == "table" and (aC.Title == az.Name) or (aC == az.Name) then
                                                    table.remove(an.Value, aB);
                                                    break;
                                                end;
                                            end;
                                        end;
                                    else
                                        for aB, aC in next, an.Tabs do
                                            TwCreate(TweenService, aC.UIElements.TabItem, TWI_01, {ImageTransparency = 1}):Play();
                                            TwCreate(TweenService, aC.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 1}):Play();
                                            TwCreate(TweenService, aC.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0.4}):Play();
                                            if aC.UIElements.TabIcon then TwCreate(TweenService, aC.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0.2}):Play(); end; aC.Selected = false;
                                        end
                                        az.Selected = true
                                        TwCreate(TweenService, az.UIElements.TabItem, TWI_01, {ImageTransparency = 0.95}):Play();
                                        TwCreate(TweenService, az.UIElements.TabItem.Highlight, TWI_01, {ImageTransparency = 0.75}):Play();
                                        TwCreate(TweenService, az.UIElements.TabItem.Frame.Title.TextLabel, TWI_01, {TextTransparency = 0}):Play();
                                        if az.UIElements.TabIcon then TwCreate(TweenService, az.UIElements.TabIcon.ImageLabel, TWI_01, {ImageTransparency = 0}):Play(); end; an.Value = az.Original;
                                    end; Callback();
                                end);
                            elseif aq == "Menu" then
                                if not az.Locked then
                                    aj.AddSignal(az.UIElements.TabItem.MouseEnter, function()
                                        TwCreate(TweenService, az.UIElements.TabItem, TWI_008, {ImageTransparency = 0.95}):Play();
                                    end); aj.AddSignal(az.UIElements.TabItem.InputEnded, function()
                                        TwCreate(TweenService, az.UIElements.TabItem, TWI_008, {ImageTransparency = 1}):Play();
                                    end);
                                end; aj.AddSignal(az.UIElements.TabItem.MouseButton1Click, function()
                                    if az.Locked then return; end;
                                    Callback(ay.Callback or function() end);
                                end);
                            end; RecalculateCanvasSize(); RecalculateListSize();
                        else
                            a.load("I"):New {Parent = an.UIElements.Menu.Frame.ScrollingFrame};
                        end;
                    end; local az = an.MenuWidth or 0; if az == 0 then
                        for aA, aB in next, an.Tabs do
                            if aB.UIElements.TabItem.Frame.UIListLayout then
                                az = math.max(az, aB.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X);
                            end;
                        end;
                    end; an.UIElements.MenuCanvas.Size = Dim2(0, az + 6 + 6 + 5 + 5 + 18 + 6 + 6, an.UIElements.MenuCanvas.Size.Y.Scale, an.UIElements.MenuCanvas.Size.Y.Offset)
                    Callback(); an.Values = au;
                end; ar:Refresh(an.Values);
                function ar.Select(at, au)
                    if au then
                        an.Value = au;
                    else
                        if an.Multi then
                            an.Value = {};
                        else
                            an.Value = nil;
                        end;
                    end; ar:Refresh(an.Values)
                end; RecalculateListSize(); RecalculateCanvasSize();
                function ar.Open(at)
                    if ap then
                        an.UIElements.Menu.Visible = true;
                        an.UIElements.MenuCanvas.Visible = true;
                        an.UIElements.MenuCanvas.Active = true;
                        an.UIElements.Menu.Size = Dim2(1, 0, 0, 0);
                        TwCreate(TweenService, an.UIElements.Menu, TwInfo(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                            {Size = DIM1010, ImageTransparency = 0.05}
                        ):Play(); tk.spawn(function()
                            twait(0.1); an.Opened = true;
                        end); UpdatePosition();
                    end;
                end; function ar.Close(at)
                    an.Opened = false; TwCreate(TweenService, an.UIElements.Menu, TwInfo(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {Size = Dim2(1, 0, 0, 0), ImageTransparency = 1}
                    ):Play(); tk.spawn(function()
                        twait(0.1); an.UIElements.Menu.Visible = false;
                    end); tk.spawn(function()
                        twait(0.25) an.UIElements.MenuCanvas.Visible = false;
                        an.UIElements.MenuCanvas.Active = false;
                    end);
                end; aj.AddSignal((an.UIElements.Dropdown and an.UIElements.Dropdown.MouseButton1Click or an.DropdownFrame.UIElements.Main.MouseButton1Click), function()
                    ar:Open();
                end); aj.AddSignal(UIS.InputBegan, function(at)
                    if at.UserInputType == Enum.UserInputType.MouseButton1 or at.UserInputType == Enum.UserInputType.Touch then
                        local au = an.UIElements.MenuCanvas;
                        local av, aw = au.AbsolutePosition, au.AbsoluteSize;
                        local ax = an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main;
                        local ay = ax.AbsolutePosition;
                        local az = ax.AbsoluteSize;
                        local aA = cmdm.X >= ay.X and cmdm.X <= ay.X + az.X and cmdm.Y >= ay.Y and cmdm.Y <= ay.Y + az.Y;
                        local aB = cmdm.X >= av.X and cmdm.X <= av.X + aw.X and cmdm.Y >= av.Y and cmdm.Y <= av.Y + aw.Y;
                        if am.Window.CanDropdown and an.Opened and not aA and not aB then
                            ar:Close();
                        end;
                    end;
                end); aj.AddSignal(an.UIElements.Dropdown and PropChangeSignal(an.UIElements.Dropdown, "AbsolutePosition") or PropChangeSignal(an.DropdownFrame.UIElements.Main, "AbsolutePosition"),UpdatePosition);
                return ar;
            end; return aa;
        end;
        function a.K()
            local ae = a.load "b"; local af = ae.New; local ah = a.load "t".New;
            local ai = a.load "k".New; local aj = a.load "J".New; local al = {
                UICorner = 10,
                UIPadding = 12,
                MenuCorner = 15,
                MenuPadding = 5,
                TabPadding = 10,
                SearchBarHeight = 39,
                TabIcon = 18
            }; function al.New(am, an)
                local ao, ap = {
                    __type = "Dropdown",
                    Title = an.Title or "Dropdown",
                    Desc = an.Desc or nil,
                    Locked = an.Locked or false,
                    Values = an.Values or {},
                    MenuWidth = an.MenuWidth,
                    Value = an.Value,
                    AllowNone = an.AllowNone,
                    SearchBarEnabled = an.SearchBarEnabled or false,
                    Multi = an.Multi,
                    Callback = an.Callback or nil,
                    UIElements = {},
                    Opened = false,
                    Tabs = {},
                    Width = 150
                }, true; if ao.Multi and not ao.Value then
                    ao.Value = {};
                end; ao.DropdownFrame = a.load "z" {
                    Title = ao.Title,
                    Desc = ao.Desc,
                    Parent = an.Parent,
                    TextOffset = ao.Callback and ao.Width or 20,
                    Hover = not ao.Callback and true or false,
                    Tab = an.Tab,
                    Index = an.Index,
                    Window = an.Window,
                    ElementTable = ao,
                    ParentConfig = an
                }; if ao.Callback then
                    ao.UIElements.Dropdown = ah("", nil, ao.DropdownFrame.UIElements.Main, nil, an.Window.NewElements and 12 or 10);
                    ao.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd";
                    ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size = Dim2(1, ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12, 0, 0);
                    ao.UIElements.Dropdown.Size = Dim2(0, ao.Width, 0, 36);
                    ao.UIElements.Dropdown.Position = Dim2(1, 0, an.Window.NewElements and 0 or 0.5, 0);
                    ao.UIElements.Dropdown.AnchorPoint = Vec2(1, an.Window.NewElements and 0 or 0.5);
                end; ao.DropdownMenu = aj(an, ao, al, ap, "Dropdown");
                ao.Display = ao.DropdownMenu.Display;
                ao.Refresh = ao.DropdownMenu.Refresh;
                ao.Select = ao.DropdownMenu.Select;
                ao.Open = ao.DropdownMenu.Open;
                ao.Close = ao.DropdownMenu.Close;
                af("ImageLabel", {
                    Image = ae.Icon "chevrons-up-down"[1],
                    ImageRectOffset = ae.Icon "chevrons-up-down"[2].ImageRectPosition,
                    ImageRectSize = ae.Icon "chevrons-up-down"[2].ImageRectSize,
                    Size = Dim2(0, 18, 0, 18),
                    Position = Dim2(1, ao.UIElements.Dropdown and -12 or 0, 0.5, 0),
                    ThemeTag = {ImageColor3 = "Icon"},
                    AnchorPoint = Vec2(1, 0.5),
                    Parent = ao.UIElements.Dropdown and ao.UIElements.Dropdown.Frame or ao.DropdownFrame.UIElements.Main
                }); function ao.Lock(aq)
                    ao.Locked = true; ap = false;
                    return ao.DropdownFrame:Lock();
                end; function ao.Unlock(aq)
                    ao.Locked = false; ap = true;
                    return ao.DropdownFrame:Unlock();
                end; if ao.Locked then
                    ao:Lock();
                end; return ao.__type, ao;
            end; return al;
        end;
        function a.L()
            local aa = {}; local ae = {
                lua = {
                    "and",
                    "break",
                    "or",
                    "else",
                    "elseif",
                    "if",
                    "then",
                    "until",
                    "repeat",
                    "while",
                    "do",
                    "for",
                    "in",
                    "end",
                    "local",
                    "return",
                    "function",
                    "export",
                },
                rbx = {
                    "game",
                    "workspace",
                    "script",
                    "math",
                    "string",
                    "table",
                    "task",
                    "wait",
                    "select",
                    "next",
                    "Enum",
                    "tick",
                    "assert",
                    "shared",
                    "loadstring",
                    "tonumber",
                    "tostring",
                    "type",
                    "typeof",
                    "unpack",
                    "Instance",
                    "CFrame",
                    "Vector3",
                    "Vector2",
                    "Color3",
                    "UDim",
                    "UDim2",
                    "Ray",
                    "BrickColor",
                    "OverlapParams",
                    "RaycastParams",
                    "Axes",
                    "Random",
                    "Region3",
                    "Rect",
                    "TweenInfo",
                    "collectgarbage",
                    "not",
                    "utf8",
                    "pcall",
                    "xpcall",
                    "_G",
                    "setmetatable",
                    "getmetatable",
                    "os",
                    "pairs",
                    "ipairs"
                },
                operators = {
                    "#",
                    "+",
                    "-",
                    "*",
                    "%",
                    "/",
                    "^",
                    "=",
                    "~",
                    "=",
                    "<",
                    ">"
                }
            }; local af = {
                numbers = fromHex "#FAB387",
                boolean = fromHex "#FAB387",
                operator = fromHex "#94E2D5",
                lua = fromHex "#CBA6F7",
                rbx = fromHex "#F38BA8",
                str = fromHex "#A6E3A1",
                comment = fromHex "#9399B2",
                null = fromHex "#F38BA8",
                call = fromHex "#89B4FA",
                self_call = fromHex "#89B4FA",
                local_property = fromHex "#CBA6F7"
            }; local function createKeywordSet(ah)
                local aj = {}; for ak, al in ipairs(ah) do
                    aj[al] = true;
                end; return aj;
            end; local ah = createKeywordSet(ae.lua);
            local aj = createKeywordSet(ae.rbx);
            local ak = createKeywordSet(ae.operators);
            local function getHighlight(al, am)
                local an = al[am]; if af[an .. "_color"] then
                    return af[an .. "_color"];
                end; if tonumber(an) then
                    return af.numbers;
                elseif an == "nil" then
                    return af.null;
                elseif an:sub(1, 2) == "--" then
                    return af.comment;
                elseif ak[an] then
                    return af.operator;
                elseif ah[an] then
                    return af.lua;
                elseif aj[an] then
                    return af.rbx;
                elseif an:sub(1, 1) == '"' or an:sub(1, 1) == "'" then
                    return af.str;
                elseif an == "true" or an == "false" then
                    return af.boolean;
                end; if al[am + 1] == "(" then
                    if al[am - 1] == ":" then
                        return af.self_call;
                    end; return af.call;
                end; if al[am - 1] == "." then
                    if al[am - 2] == "Enum" then
                        return af.rbx;
                    end; return af.local_property;
                end;
            end; function aa.run(al)
                local am = {}; local an = ""; local ao, ap, aq = false, false, false;
                for ar = 1, #al do
                    local as = al:sub(ar, ar); if ap then
                        if as == "\n" and not aq then
                            tble.insert(am, an); tble.insert(am, as); an = ""; ap = false;
                        elseif al:sub(ar - 1, ar) == "]]" and aq then
                            an = an .. "]"; tble.insert(am, an); an = "";
                            ap = false; aq = false;
                        else
                            an = an .. as;
                        end;
                    elseif ao then
                        if as == ao and al:sub(ar - 1, ar - 1) ~= "\\" or as == "\n" then
                            an = an .. as; ao = false;
                        else
                            an = an .. as;
                        end;
                    else
                        if al:sub(ar, ar + 1) == "--" then
                            tble.insert(am, an); an = "-";
                            ap = true; aq = al:sub(ar + 2, ar + 3) == "[[";
                        elseif as == '"' or as == "'" then
                            tble.insert(am, an); an = as; ao = as;
                        elseif ak[as] then
                            tble.insert(am, an); tble.insert(am, as); an = "";
                        elseif as:match "[%w_]" then
                            an = an .. as;
                        else
                            tble.insert(am, an); tble.insert(am, as); an = "";
                        end;
                    end;
                end; tble.insert(am, an); local ar = {};
                for as, at in ipairs(am) do
                    local au = getHighlight(am, as); if au then
                        local av = str.format('<font color = "#%s">%s</font>', au:ToHex(), at:gsub("<", "&lt;"):gsub(">", "&gt;"));
                        tble.insert(ar, av);
                    else
                        tble.insert(ar, at);
                    end;
                end; return tconcat(ar);
            end; return aa;
        end;
        function a.M()
            local aa = {}; local ae = a.load"b"; local af = ae.New;
            local aj = a.load "L"; function aa.New(ak, al, am, an, ao)
                local ap = {Radius = 12,Padding = 10}; local aq = af("TextLabel", {
                    Text = "",
                    TextColor3 = fromHex "#CDD6F4",
                    TextTransparency = 0,
                    TextSize = 14,
                    TextWrapped = false,
                    LineHeight = 1.15,
                    RichText = true,
                    TextXAlignment = "Left",
                    Size = DIM0000,
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY"
                }, {
                    af("UIPadding", {
                        PaddingTop = Dim(0, ap.Padding + 3),
                        PaddingLeft = Dim(0, ap.Padding + 3),
                        PaddingRight = Dim(0, ap.Padding + 3),
                        PaddingBottom = Dim(0, ap.Padding + 3)
                    });
                }); aq.Font = "Code"; local ar = af("ScrollingFrame", {
                    Size = Dim2(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticCanvasSize = "X",
                    ScrollingDirection = "X",
                    ElasticBehavior = "Never",
                    CanvasSize = DIM0000,
                    ScrollBarThickness = 0
                }, {aq}); local as = af("TextButton", {
                    BackgroundTransparency = 1,
                    Size = Dim2(0, 30, 0, 30),
                    Position = Dim2(1, -ap.Padding / 2, 0, ap.Padding / 2),
                    AnchorPoint = Vec2(1, 0),
                    Visible = an and true or false
                }, {
                    ae.NewRoundFrame(ap.Radius - 4, "Squircle", {
                        ImageColor3 = fromHex "#ffffff",
                        ImageTransparency = 1,
                        Size = DIM1010,
                        AnchorPoint = VEC05,
                        Position = DIM05,
                        Name = "Button"
                    }, {
                        af("UIScale", {
                            Scale = 1
                        }), af("ImageLabel", {
                            Image = ae.Icon "copy"[1],
                            ImageRectSize = ae.Icon "copy"[2].ImageRectSize,
                            ImageRectOffset = ae.Icon "copy"[2].ImageRectPosition,
                            BackgroundTransparency = 1,
                            AnchorPoint = VEC05,
                            Position = DIM05,
                            Size = Dim2(0, 12, 0, 12),
                            ImageColor3 = fromHex "#ffffff",
                            ImageTransparency = .1
                        });
                    });
                }); ae.AddSignal(as.MouseEnter, function()
                    TwCreate(TweenService, as.Button, TWI_005, {ImageTransparency = 0.95}):Play();
                    TwCreate(TweenService, as.Button.UIScale, TWI_005, {Scale = 0.9}):Play();
                end); ae.AddSignal(as.InputEnded, function()
                    TwCreate(TweenService, as.Button, TWI_008, {ImageTransparency = 1}):Play();
                    TwCreate(TweenService, as.Button.UIScale, TWI_008, {Scale = 1}):Play()
                end); local at = ae.NewRoundFrame(ap.Radius, "Squircle", {
                    ImageColor3 = fromHex "#212121",
                    ImageTransparency = .035,
                    Size = Dim2(1, 0, 0, 20 + (ap.Padding * 2)),
                    AutomaticSize = "Y",
                    Parent = am
                }, {
                    ae.NewRoundFrame(ap.Radius, "SquircleOutline", {
                        Size = DIM1010,
                        ImageColor3 = fromHex "#ffffff",
                        ImageTransparency = .955
                    }), af("Frame", {
                        BackgroundTransparency = 1,
                        Size = Dim2(1, 0, 0, 0),
                        AutomaticSize = "Y"
                    }, {
                        ae.NewRoundFrame(ap.Radius, "Squircle-TL-TR", {
                            ImageColor3 = fromHex "#ffffff",
                            ImageTransparency = .96,
                            Size = Dim2(1, 0, 0, 20 + (ap.Padding * 2)),
                            Visible = al and true or false
                        }, {
                            af("ImageLabel", {
                                Size = Dim2(0, 18, 0, 18),
                                BackgroundTransparency = 1,
                                Image = (LoaderSettings.ScaryAC and "") or "rbxassetid://132464694294269",
                                ImageColor3 = fromHex "#ffffff",
                                ImageTransparency = .2
                            }), af("TextLabel", {
                                Text = al,
                                TextColor3 = fromHex "#ffffff",
                                TextTransparency = .2,
                                TextSize = 16,
                                AutomaticSize = "Y",
                                FontFace = Fnew(ae.Font, Enum.FontWeight.Medium),
                                TextXAlignment = "Left",
                                BackgroundTransparency = 1,
                                TextTruncate = "AtEnd",
                                Size = Dim2(1, as and -20 - (ap.Padding * 2), 0, 0)
                            }), af("UIPadding", {
                                PaddingLeft = Dim(0, ap.Padding + 3),
                                PaddingRight = Dim(0, ap.Padding + 3)
                            }), af("UIListLayout", {
                                Padding = Dim(0, ap.Padding),
                                FillDirection = "Horizontal",
                                VerticalAlignment = "Center"
                            }),
                        }), ar, af("UIListLayout", {
                            Padding = Dim(0, 0),
                            FillDirection = "Vertical"
                        }),
                    }), as
                }); ap.CodeFrame = at; ae.AddSignal(PropChangeSignal(aq, "TextBounds"), function()
                    ar.Size = Dim2(1, 0, 0, (aq.TextBounds.Y / (ao or 1)) + ((ap.Padding + 3) * 2));
                end); function ap.Set(au)
                    aq.Text = aj.run(au);
                end; function ap.Destroy()
                    at:Destroy(); ap = nil;
                end; ap.Set(ak); ae.AddSignal(as.MouseButton1Click, function()
                    if an then
                        an(); local au = ae.Icon "check"; as.Button.ImageLabel.Image = au[1];
                        as.Button.ImageLabel.ImageRectSize = au[2].ImageRectSize;
                        as.Button.ImageLabel.ImageRectOffset = au[2].ImageRectPosition;
                        twait(1); local av = ae.Icon "copy";
                        as.Button.ImageLabel.Image = av[1];
                        as.Button.ImageLabel.ImageRectSize = av[2].ImageRectSize;
                        as.Button.ImageLabel.ImageRectOffset = av[2].ImageRectPosition;
                    end;
                end); return ap;
            end; return aa;
        end;
        function a.N()
            local aa = a.load"b"; local ae = aa.New;local af = a.load"M";
            local ah = {}; function ah.New(aj, ak)
                local al = {
                    __type = "Code",
                    Title = ak.Title,
                    Code = ak.Code,
                    OnCopy = ak.OnCopy
                }; local am = not al.Locked;
                local an = af.New(al.Code, al.Title, ak.Parent, function()
                    if am then
                        local an = al.Title or "code"
                        local ao, ap = pcall(function()
                            setc(al.Code); if al.OnCopy then
                                al.OnCopy();
                            end;
                        end); if not ao then
                            ak.WindUI:Notify {
                                Title = "Error",
                                Content = "The " .. an .. " is not copied. Error: " .. ap,
                                Icon = "x",
                                Duration = 5
                            }
                        end;
                    end;
                end, ak.WindUI.UIScale, al);
                function al.SetCode(ao, ap)
                    an.Set(ap); al.Code = ap;
                end; function al.Destroy(ao)
                    an.Destroy(); al = nil;
                end; al.ElementFrame = an.CodeFrame;
                return al.__type, al;
            end; return ah;
        end;
        function a.O()
            local aa = a.load "b"; local ae = aa.New;
            local ap = a.load "j".New; local aq = a.load "k".New;
            local ar = {UICorner = 9}; function ar.Colorpicker(as, at, au, av)
                local aw = {
                    __type = "Colorpicker",
                    Title = at.Title,
                    Desc = at.Desc,
                    Default = at.Default,
                    Callback = at.Callback,
                    Transparency = at.Transparency,
                    UIElements = at.UIElements,
                    TextPadding = 10
                }; function aw.SetHSVFromRGB(ax, ay)
                    local az, aA, aB = toHSV(ay);
                    aw.Hue = az; aw.Sat = aA; aw.Vib = aB;
                end; aw:SetHSVFromRGB(aw.Default);
                local ax = a.load "l".Init(au);
                local ay = ax.Create();
                aw.ColorpickerFrame = ay;
                ay.UIElements.Main.Size = Dim2(1, 0, 0, 0);
                local az, aA, aB = aw.Hue, aw.Sat, aw.Vib;
                aw.UIElements.Title = ae("TextLabel", {
                    Text = aw.Title,
                    TextSize = 20,
                    FontFace = Fnew(aa.Font, Enum.FontWeight.SemiBold),
                    TextXAlignment = "Left",
                    Size = Dim2(1, 0, 0, 0),
                    AutomaticSize = "Y",
                    ThemeTag = {TextColor3 = "Text"},
                    BackgroundTransparency = 1,
                    Parent = ay.UIElements.Main
                }, {
                    ae("UIPadding", {
                        PaddingTop = Dim(0, aw.TextPadding / 2),
                        PaddingLeft = Dim(0, aw.TextPadding / 2),
                        PaddingRight = Dim(0, aw.TextPadding / 2),
                        PaddingBottom = Dim(0, aw.TextPadding / 2)
                    });
                }); local aC = ae("Frame", {
                    Size = Dim2(0, 14, 0, 14),
                    AnchorPoint = VEC05,
                    Position = Dim2(0.5, 0, 0, 0),
                    Parent = HueDragHolder,
                    BackgroundColor3 = aw.Default
                }, {
                    ae("UIStroke", {
                        Thickness = 2,
                        Transparency = .1,
                        ThemeTag = {Color = "Text"}
                    }), ae("UICorner", {
                        CornerRadius = Dim(1, 0)
                    });
                }); aw.UIElements.SatVibMap = ae("ImageLabel", {
                    Size = UDim2.fromOffset(160, 158),
                    Position = UDim2.fromOffset(0, 40 + aw.TextPadding),
                    Image = (LoaderSettings.ScaryAC2 and "") or "rbxassetid://4155801252",
                    BackgroundColor3 = fromHSV(az, 1, 1),
                    BackgroundTransparency = 0,
                    Parent = ay.UIElements.Main
                }, {
                    ae("UICorner", {
                        CornerRadius = Dim(0, 8)
                    }), aa.NewRoundFrame(8, "SquircleOutline", {
                        ThemeTag = {
                            ImageColor3 = "Outline"
                        },
                        Size = DIM1010,
                        ImageTransparency = .85,
                        ZIndex = 99999
                    }, {
                        ae("UIGradient", {
                            Rotation = 45, Color = CSnew {
                                CSKnew(0.0, WHITE),
                                CSKnew(0.5, WHITE),
                                CSKnew(1.0, WHITE)
                            }, Transparency = NSnew {
                                NSKnew(0.0, 0.1),
                                NSKnew(0.5, 1),
                                NSKnew(1.0, 0.1)
                            }
                        })
                    }), aC
                }); aw.UIElements.Inputs = ae("Frame", {
                    AutomaticSize = "XY",
                    Size = DIM0000,
                    Position = UDim2.fromOffset(aw.Transparency and 240 or 210, 40 + aw.TextPadding),
                    BackgroundTransparency = 1,
                    Parent = ay.UIElements.Main
                }, {
                    ae("UIListLayout", {
                        Padding = Dim(0, 4),
                        FillDirection = "Vertical"
                    });
                }); local aD = ae("Frame", {
                    BackgroundColor3 = aw.Default,
                    Size = Dim2Scale(1, 1),
                    BackgroundTransparency = aw.Transparency
                }, {
                    ae("UICorner", {
                        CornerRadius = Dim(0, 8)
                    });
                }); ae("ImageLabel", {
                        Image = (LoaderSettings.ScaryAC and "") or "http://www.roblox.com/asset/?id=14204231522",
                        ImageTransparency = 0.45,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.fromOffset(40, 40),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(85, 208 + aw.TextPadding),
                        Size = UDim2.fromOffset(75, 24),
                        Parent = ay.UIElements.Main
                    },
                    {
                        ae(
                            "UICorner",
                            {
                                CornerRadius = Dim(0, 8)
                            }
                        ),
                        aa.NewRoundFrame(
                            8,
                            "SquircleOutline",
                            {
                                ThemeTag = {
                                    ImageColor3 = "Outline"
                                },
                                Size = DIM1010,
                                ImageTransparency = .85,
                                ZIndex = 99999
                            },
                            {
                                ae(
                                    "UIGradient",
                                    {
                                        Rotation = 60,
                                        Color = CSnew {
                                            CSKnew(0.0, WHITE),
                                            CSKnew(0.5, WHITE),
                                            CSKnew(1.0, WHITE)
                                        },
                                        Transparency = NSnew {
                                            NSKnew(0.0, 0.1),
                                            NSKnew(0.5, 1),
                                            NSKnew(1.0, 0.1)
                                        }
                                    }
                                )
                            }
                        ),
                        aD
                    }
                )

                local aE =
                    ae(
                    "Frame",
                    {
                        BackgroundColor3 = aw.Default,
                        Size = Dim2Scale(1, 1),
                        BackgroundTransparency = 0,
                        ZIndex = 9
                    },
                    {
                        ae(
                            "UICorner",
                            {
                                CornerRadius = Dim(0, 8)
                            }
                        )
                    }
                )

                ae(
                    "ImageLabel",
                    {
                        Image = (LoaderSettings.ScaryAC and "") or "http://www.roblox.com/asset/?id=14204231522",
                        ImageTransparency = 0.45,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.fromOffset(40, 40),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(0, 208 + aw.TextPadding),
                        Size = UDim2.fromOffset(75, 24),
                        Parent = ay.UIElements.Main
                    },
                    {
                        ae(
                            "UICorner",
                            {
                                CornerRadius = Dim(0, 8)
                            }
                        ),
                        aa.NewRoundFrame(
                            8,
                            "SquircleOutline",
                            {
                                ThemeTag = {
                                    ImageColor3 = "Outline"
                                },
                                Size = DIM1010,
                                ImageTransparency = .85,
                                ZIndex = 99999
                            },
                            {
                                ae(
                                    "UIGradient",
                                    {
                                        Rotation = 60,
                                        Color = CSnew {
                                            CSKnew(0.0, WHITE),
                                            CSKnew(0.5, WHITE),
                                            CSKnew(1.0, WHITE)
                                        },
                                        Transparency = NSnew {
                                            NSKnew(0.0, 0.1),
                                            NSKnew(0.5, 1),
                                            NSKnew(1.0, 0.1)
                                        }
                                    }
                                )
                            }
                        ),
                        aE
                    }
                )

                local aF = {}

                for b = 0, 1, 0.1 do
                    tble.insert(aF, CSKnew(b, fromHSV(b, 1, 1)))
                end

                local b =
                    ae(
                    "UIGradient",
                    {
                        Color = CSnew(aF),
                        Rotation = 90
                    }
                )

                local d =
                    ae(
                    "Frame",
                    {
                        Size = DIM1010,
                        Position = DIM0000,
                        BackgroundTransparency = 1
                    }
                )

                local f =
                    ae(
                    "Frame",
                    {
                        Size = Dim2(0, 14, 0, 14),
                        AnchorPoint = VEC05,
                        Position = Dim2(0.5, 0, 0, 0),
                        Parent = d,
                        BackgroundColor3 = aw.Default
                    },
                    {
                        ae(
                            "UIStroke",
                            {
                                Thickness = 2,
                                Transparency = .1,
                                ThemeTag = {
                                    Color = "Text"
                                }
                            }
                        ),
                        ae(
                            "UICorner",
                            {
                                CornerRadius = Dim(1, 0)
                            }
                        )
                    }
                )

                local g =
                    ae(
                    "Frame",
                    {
                        Size = UDim2.fromOffset(6, 192),
                        Position = UDim2.fromOffset(180, 40 + aw.TextPadding),
                        Parent = ay.UIElements.Main
                    },
                    {
                        ae(
                            "UICorner",
                            {
                                CornerRadius = Dim(1, 0)
                            }
                        ),
                        b,
                        d
                    }
                )

                function CreateNewInput(h, j)
                    local l = aq(h, nil, aw.UIElements.Inputs)

                    ae(
                        "TextLabel",
                        {
                            BackgroundTransparency = 1,
                            TextTransparency = .4,
                            TextSize = 17,
                            FontFace = Fnew(aa.Font, Enum.FontWeight.Regular),
                            AutomaticSize = "XY",
                            ThemeTag = {
                                TextColor3 = "Placeholder"
                            },
                            AnchorPoint = Vec2(1, 0.5),
                            Position = Dim2(1, -12, 0.5, 0),
                            Parent = l.Frame,
                            Text = h
                        }
                    )

                    ae(
                        "UIScale",
                        {
                            Parent = l,
                            Scale = .85
                        }
                    )

                    l.Frame.Frame.TextBox.Text = j
                    l.Size = Dim2(0, 150, 0, 42)

                    return l
                end

                local function ToRGB(h)
                    return {
                        R = math.floor(h.R * 255),
                        G = math.floor(h.G * 255),
                        B = math.floor(h.B * 255)
                    }
                end

                local h = CreateNewInput("Hex", "#" .. aw.Default:ToHex())

                local j = CreateNewInput("Red", ToRGB(aw.Default).R)
                local l = CreateNewInput("Green", ToRGB(aw.Default).G)
                local m = CreateNewInput("Blue", ToRGB(aw.Default).B)
                local p
                if aw.Transparency then
                    p = CreateNewInput("Alpha", ((1 - aw.Transparency) * 100) .. "%")
                end

                local r =
                    ae(
                    "Frame",
                    {
                        Size = Dim2(1, 0, 0, 40),
                        AutomaticSize = "Y",
                        Position = Dim2(0, 0, 0, 254 + aw.TextPadding),
                        BackgroundTransparency = 1,
                        Parent = ay.UIElements.Main,
                        LayoutOrder = 4
                    },
                    {
                        ae(
                            "UIListLayout",
                            {
                                Padding = Dim(0, 6),
                                FillDirection = "Horizontal",
                                HorizontalAlignment = "Right"
                            }
                        )
                    }
                )

                local u = {
                    {
                        Title = "Cancel",
                        Variant = "Secondary",
                        Callback = function()
                        end
                    },
                    {
                        Title = "Apply",
                        Icon = "chevron-right",
                        Variant = "Primary",
                        Callback = function()
                            av(fromHSV(aw.Hue, aw.Sat, aw.Vib), aw.Transparency)
                        end
                    }
                }

                for v, x in next, u do
                    local B = ap(x.Title, x.Icon, x.Callback, x.Variant, r, ay, false)
                    B.Size = Dim2(0.5, -3, 0, 40)
                    B.AutomaticSize = "None"
                end

                local B, C, F
                if aw.Transparency then
                    local G =
                        ae(
                        "Frame",
                        {
                            Size = DIM1010,
                            Position = UDim2.fromOffset(0, 0),
                            BackgroundTransparency = 1
                        }
                    )

                    C =
                        ae(
                        "ImageLabel",
                        {
                            Size = Dim2(0, 14, 0, 14),
                            AnchorPoint = VEC05,
                            Position = Dim2(0.5, 0, 0, 0),
                            ThemeTag = {
                                BackgroundColor3 = "Text"
                            },
                            Parent = G
                        },
                        {
                            ae(
                                "UIStroke",
                                {
                                    Thickness = 2,
                                    Transparency = .1,
                                    ThemeTag = {
                                        Color = "Text"
                                    }
                                }
                            ),
                            ae(
                                "UICorner",
                                {
                                    CornerRadius = Dim(1, 0)
                                }
                            )
                        }
                    )

                    F =
                        ae(
                        "Frame",
                        {
                            Size = Dim2Scale(1, 1)
                        },
                        {
                            ae(
                                "UIGradient",
                                {
                                    Transparency = NSnew {
                                        NSKnew(0, 0),
                                        NSKnew(1, 1)
                                    },
                                    Rotation = 270
                                }
                            ),
                            ae(
                                "UICorner",
                                {
                                    CornerRadius = Dim(0, 6)
                                }
                            )
                        }
                    )

                    B =
                        ae(
                        "Frame",
                        {
                            Size = UDim2.fromOffset(6, 192),
                            Position = UDim2.fromOffset(210, 40 + aw.TextPadding),
                            Parent = ay.UIElements.Main,
                            BackgroundTransparency = 1
                        },
                        {
                            ae(
                                "UICorner",
                                {
                                    CornerRadius = Dim(1, 0)
                                }
                            ),
                            ae(
                                "ImageLabel",
                                {
                                    Image = (LoaderSettings.ScaryAC and "") or "rbxassetid://14204231522",
                                    ImageTransparency = 0.45,
                                    ScaleType = Enum.ScaleType.Tile,
                                    TileSize = UDim2.fromOffset(40, 40),
                                    BackgroundTransparency = 1,
                                    Size = Dim2Scale(1, 1)
                                },
                                {
                                    ae(
                                        "UICorner",
                                        {
                                            CornerRadius = Dim(1, 0)
                                        }
                                    )
                                }
                            ),
                            F,
                            G
                        }
                    )
                end

                function aw.Round(G, H, J)
                    if J == 0 then
                        return math.floor(H)
                    end
                    H = tostring(H)
                    return H:find "%." and tonumber(H:sub(1, H:find "%." + J)) or H
                end

                function aw.Update(G, H, J)
                    if H then
                        az, aA, aB = toHSV(H)
                    else
                        az, aA, aB = aw.Hue, aw.Sat, aw.Vib
                    end

                    aw.UIElements.SatVibMap.BackgroundColor3 = fromHSV(az, 1, 1)
                    aC.Position = Dim2(aA, 0, 1 - aB, 0)
                    aC.BackgroundColor3 = fromHSV(az, aA, aB)
                    aE.BackgroundColor3 = fromHSV(az, aA, aB)
                    f.BackgroundColor3 = fromHSV(az, 1, 1)
                    f.Position = Dim2(0.5, 0, az, 0)

                    h.Frame.Frame.TextBox.Text = "#" .. fromHSV(az, aA, aB):ToHex()
                    j.Frame.Frame.TextBox.Text = ToRGB(fromHSV(az, aA, aB)).R
                    l.Frame.Frame.TextBox.Text = ToRGB(fromHSV(az, aA, aB)).G
                    m.Frame.Frame.TextBox.Text = ToRGB(fromHSV(az, aA, aB)).B

                    if J or aw.Transparency then
                        aE.BackgroundTransparency = aw.Transparency or J
                        F.BackgroundColor3 = fromHSV(az, aA, aB)
                        C.BackgroundColor3 = fromHSV(az, aA, aB)
                        C.BackgroundTransparency = aw.Transparency or J
                        C.Position = Dim2(0.5, 0, 1 - aw.Transparency or J, 0)
                        p.Frame.Frame.TextBox.Text = aw:Round((1 - aw.Transparency or J) * 100, 0) .. "%"
                    end
                end

                aw:Update(aw.Default, aw.Transparency)

                local function GetRGB()
                    local G = fromHSV(aw.Hue, aw.Sat, aw.Vib)
                    return {R = math.floor(G.r * 255), G = math.floor(G.g * 255), B = math.floor(G.b * 255)}
                end

                local function clamp(G, H, J)
                    return math.clamp(tonumber(G) or 0, H, J)
                end

                aa.AddSignal(
                    h.Frame.Frame.TextBox.FocusLost,
                    function(G)
                        if G then
                            local H = h.Frame.Frame.TextBox.Text:gsub("#", "")
                            local J, L = pcall(fromHex, H)
                            if J and typeof(L) == "Color3" then
                                aw.Hue, aw.Sat, aw.Vib = toHSV(L)
                                aw:Update()
                                aw.Default = L
                            end
                        end
                    end
                )

                local function updateColorFromInput(G, H)
                    aa.AddSignal(
                        G.Frame.Frame.TextBox.FocusLost,
                        function(J)
                            if J then
                                local L = G.Frame.Frame.TextBox
                                local M = GetRGB()
                                local N = clamp(L.Text, 0, 255)
                                L.Text = tostring(N)

                                M[H] = N
                                local O = fromRGB(M.R, M.G, M.B)
                                aw.Hue, aw.Sat, aw.Vib = toHSV(O)
                                aw:Update()
                            end
                        end
                    )
                end

                updateColorFromInput(j, "R")
                updateColorFromInput(l, "G")
                updateColorFromInput(m, "B")

                if aw.Transparency then
                    aa.AddSignal(
                        p.Frame.Frame.TextBox.FocusLost,
                        function(G)
                            if G then
                                local H = p.Frame.Frame.TextBox
                                local J = clamp(H.Text, 0, 100)
                                H.Text = tostring(J)

                                aw.Transparency = 1 - J * 0.01
                                aw:Update(nil, aw.Transparency)
                            end
                        end
                    )
                end

                local G = aw.UIElements.SatVibMap
                aa.AddSignal(
                    G.InputBegan,
                    function(H)
                        if H.UserInputType == Enum.UserInputType.MouseButton1 or H.UserInputType == Enum.UserInputType.Touch then
                            while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local J = G.AbsolutePosition.X
                                local L = J + G.AbsoluteSize.X
                                local M = math.clamp(cmdm.X, J, L)

                                local N = G.AbsolutePosition.Y
                                local O = N + G.AbsoluteSize.Y
                                local P = math.clamp(cmdm.Y, N, O)

                                aw.Sat = (M - J) / (L - J)
                                aw.Vib = 1 - ((P - N) / (O - N))
                                aw:Update()

                                RunService.RenderStepped:Wait()
                            end
                        end
                    end
                )

                aa.AddSignal(
                    g.InputBegan,
                    function(H)
                        if H.UserInputType == Enum.UserInputType.MouseButton1 or H.UserInputType == Enum.UserInputType.Touch then
                            while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local J = g.AbsolutePosition.Y
                                local L = J + g.AbsoluteSize.Y
                                local M = math.clamp(cmdm.Y, J, L)

                                aw.Hue = ((M - J) / (L - J))
                                aw:Update()

                                RunService.RenderStepped:Wait()
                            end
                        end
                    end
                )

                if aw.Transparency then
                    aa.AddSignal(
                        B.InputBegan,
                        function(H)
                            if
                                H.UserInputType == Enum.UserInputType.MouseButton1 or
                                    H.UserInputType == Enum.UserInputType.Touch
                            then
                                while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                    local J = B.AbsolutePosition.Y
                                    local L = J + B.AbsoluteSize.Y
                                    local M = math.clamp(cmdm.Y, J, L)

                                    aw.Transparency = 1 - ((M - J) / (L - J))
                                    aw:Update()

                                    RunService.RenderStepped:Wait()
                                end
                            end
                        end
                    )
                end

                return aw
            end

            function ar.New(as, at)
                local au = {
                    __type = "Colorpicker",
                    Title = at.Title or "Colorpicker",
                    Desc = at.Desc or nil,
                    Locked = at.Locked or false,
                    Default = at.Default or WHITE,
                    Callback = at.Callback or function()
                        end,
                    UIScale = at.UIScale,
                    Transparency = at.Transparency,
                    UIElements = {}
                }

                local av = true

                au.ColorpickerFrame =
                    a.load "z" {
                    Title = au.Title,
                    Desc = au.Desc,
                    Parent = at.Parent,
                    TextOffset = 40,
                    Hover = false,
                    Tab = at.Tab,
                    Index = at.Index,
                    Window = at.Window,
                    ElementTable = au,
                    ParentConfig = at
                }

                au.UIElements.Colorpicker =
                    aa.NewRoundFrame(
                    ar.UICorner,
                    "Squircle",
                    {
                        ImageTransparency = 0,
                        Active = true,
                        ImageColor3 = au.Default,
                        Parent = au.ColorpickerFrame.UIElements.Main,
                        Size = Dim2(0, 26, 0, 26),
                        AnchorPoint = Vec2(1, 0),
                        Position = Dim2(1, 0, 0, 0),
                        ZIndex = 2
                    },
                    nil,
                    true
                )

                function au.Lock(aw)
                    au.Locked = true
                    av = false
                    return au.ColorpickerFrame:Lock()
                end
                function au.Unlock(aw)
                    au.Locked = false
                    av = true
                    return au.ColorpickerFrame:Unlock()
                end

                if au.Locked then
                    au:Lock()
                end

                function au.Update(aw, ax, ay)
                    au.UIElements.Colorpicker.ImageTransparency = ay or 0
                    au.UIElements.Colorpicker.ImageColor3 = ax
                    au.Default = ax
                    if ay then
                        au.Transparency = ay
                    end
                end

                function au.Set(aw, ax, ay)
                    return au:Update(ax, ay)
                end

                aa.AddSignal(
                    au.UIElements.Colorpicker.MouseButton1Click,
                    function()
                        if av then
                            ar:Colorpicker(
                                au,
                                at.Window,
                                function(aw, ax)
                                    au:Update(aw, ax)
                                    au.Default = aw
                                    au.Transparency = ax
                                    aa.SafeCallback(au.Callback, aw, ax)
                                end
                            ).ColorpickerFrame:Open()
                        end
                    end
                )

                return au.__type, au
            end

            return ar
        end
        function a.P()
            local aa = a.load "b"
            local ae = aa.New
            local af = aa.Tween

            local ah = {}

            function ah.New(aj, ak)
                local al = {
                    __type = "Section",
                    Title = ak.Title or "Section",
                    Icon = ak.Icon,
                    TextXAlignment = ak.TextXAlignment or "Left",
                    TextSize = ak.TextSize or 19,
                    Box = ak.Box or false,
                    FontWeight = ak.FontWeight or Enum.FontWeight.SemiBold,
                    TextTransparency = ak.TextTransparency or 0.05,
                    Opened = ak.Opened or false,
                    UIElements = {},
                    HeaderSize = 42,
                    IconSize = 20,
                    Padding = 10,
                    Elements = {},
                    Expandable = false
                }

                local am

                function al.SetIcon(an, ao)
                    al.Icon = ao or nil
                    if am then
                        am:Destroy()
                    end
                    if ao then
                        am = aa.Image(ao, ao .. ":" .. al.Title, 0, ak.Window.Folder, al.__type, true)
                        am.Size = Dim2(0, al.IconSize, 0, al.IconSize)
                    end
                end

                local an =
                    ae(
                    "Frame",
                    {
                        Size = Dim2(0, al.IconSize, 0, al.IconSize),
                        BackgroundTransparency = 1,
                        Visible = false
                    },
                    {
                        ae(
                            "ImageLabel",
                            {
                                Size = DIM1010,
                                BackgroundTransparency = 1,
                                Image = aa.Icon "chevron-down"[1],
                                ImageRectSize = aa.Icon "chevron-down"[2].ImageRectSize,
                                ImageRectOffset = aa.Icon "chevron-down"[2].ImageRectPosition,
                                ThemeTag = {
                                    ImageColor3 = "Icon"
                                },
                                ImageTransparency = .7
                            }
                        )
                    }
                )

                if al.Icon then
                    al:SetIcon(al.Icon)
                end

                local ao =
                    ae(
                    "TextLabel",
                    {
                        BackgroundTransparency = 1,
                        TextXAlignment = al.TextXAlignment,
                        AutomaticSize = "Y",
                        TextSize = al.TextSize,
                        TextTransparency = al.TextTransparency,
                        ThemeTag = {
                            TextColor3 = "Text"
                        },
                        FontFace = Fnew(aa.Font, al.FontWeight),
                        Text = al.Title,
                        Size = Dim2(1, 0, 0, 0),
                        TextWrapped = true
                    }
                )

                local function UpdateTitleSize()
                    local ap = 0
                    if am then
                        ap = ap - (al.IconSize + 8)
                    end
                    if an.Visible then
                        ap = ap - (al.IconSize + 8)
                    end
                    ao.Size = Dim2(1, ap, 0, 0)
                end

                local ap =
                    aa.NewRoundFrame(
                    ak.Window.ElementConfig.UICorner,
                    "Squircle",
                    {
                        Size = Dim2(1, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Parent = ak.Parent,
                        ClipsDescendants = true,
                        AutomaticSize = "Y",
                        ImageTransparency = al.Box and .93 or 1,
                        ThemeTag = {
                            ImageTransparency = "GroupBackgroundTransparency",
                            ImageColor3 = "GroupBackground",
                        },
                    },
                    {
                        ae(
                            "TextButton",
                            {
                                Size = Dim2(1, 0, 0, Expandable and 0 or al.HeaderSize),
                                BackgroundTransparency = 1,
                                AutomaticSize = Expandable and nil or "Y",
                                Text = "",
                                Name = "Top"
                            },
                            {
                                al.Box and
                                    ae(
                                        "UIPadding",
                                        {
                                            PaddingLeft = Dim(
                                                0,
                                                ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)
                                            ),
                                            PaddingRight = Dim(
                                                0,
                                                ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)
                                            )
                                        }
                                    ) or
                                    nil,
                                am,
                                ao,
                                ae(
                                    "UIListLayout",
                                    {
                                        Padding = Dim(0, 8),
                                        FillDirection = "Horizontal",
                                        VerticalAlignment = "Center",
                                        HorizontalAlignment = "Left"
                                    }
                                ),
                                an
                            }
                        ),
                        ae(
                            "Frame",
                            {
                                BackgroundTransparency = 1,
                                Size = Dim2(1, 0, 0, 0),
                                AutomaticSize = "Y",
                                Name = "Content",
                                Visible = false,
                                Position = Dim2(0, 0, 0, al.HeaderSize)
                            },
                            {
                                al.Box and
                                    ae(
                                        "UIPadding",
                                        {
                                            PaddingLeft = Dim(0, ak.Window.ElementConfig.UIPadding),
                                            PaddingRight = Dim(0, ak.Window.ElementConfig.UIPadding),
                                            PaddingBottom = Dim(0, ak.Window.ElementConfig.UIPadding)
                                        }
                                    ) or
                                    nil,
                                ae(
                                    "UIListLayout",
                                    {
                                        FillDirection = "Vertical",
                                        Padding = Dim(0, ak.Tab.Gap),
                                        VerticalAlignment = "Top"
                                    }
                                )
                            }
                        )
                    }
                )

                al.ElementFrame = ap

                local aq = ak.ElementsModule; aq.Load(
                    al, ap.Content, aq.Elements, ak.Window,
                    ak.WindUI, function()
                        if not al.Expandable then
                            al.Expandable = true
                            an.Visible = true
                            UpdateTitleSize()
                        end
                    end, aq, ak.UIScale, ak.Tab
                ); UpdateTitleSize();
                function al.SetTitle(ar, as)
                    ao.Text = as;
                end; function al.Destroy(ar)
                    for as, at in next, al.Elements do
                        at:Destroy();
                    end; ap:Destroy();
                end; function al.Open(ar)
                    if al.Expandable then
                        al.Opened = true;
                        if not isFirstLoad then
                            TwCreate(TweenService, ap, TwInfo(0.33, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                { Size = Dim2( ap.Size.X.Scale, ap.Size.X.Offset, 0, al.HeaderSize + (ap.Content.AbsoluteSize.Y / ak.UIScale))}
                            ):Play(); TwCreate(TweenService, an.ImageLabel, TWI_Q_01, {Rotation = 180}):Play();
                        else
                            ap.Size = Dim2( ap.Size.X.Scale, ap.Size.X.Offset, 0, al.HeaderSize + (ap.Content.AbsoluteSize.Y / ak.UIScale));
                            an.ImageLabel.Rotation = 180;
                        end;
                        an.ImageLabel.Parent.Parent.Parent.Content.Visible = true;
                    end;
                end; function al.Close(ar)
                    if al.Expandable then
                        al.Opened = false;
                        if not isFirstLoad then
                            TwCreate(TweenService, ap, TwInfo(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = Dim2(ap.Size.X.Scale, ap.Size.X.Offset, 0, al.HeaderSize)}):Play();
                            TwCreate(TweenService, an.ImageLabel, TWI_Q_01, {Rotation = 0}):Play();
                        else
                            ap.Size = Dim2(ap.Size.X.Scale, ap.Size.X.Offset, 0, al.HeaderSize);
                            an.ImageLabel.Rotation = 0;
                        end;
                        an.ImageLabel.Parent.Parent.Parent.Content.Visible = false;
                    end;
                end; aa.AddSignal(ap.Top.MouseButton1Click,function()
                    if al.Expandable then
                        if al.Opened then
                            al:Close();
                        else
                            al:Open();
                        end;
                    end;
                end); aa.AddSignal(PropChangeSignal(ap.Content.UIListLayout, "AbsoluteContentSize"), function()
                    if al.Opened then
                        al:Open();
                    end;
                end); tk.spawn(function()
                    twait(0.02); if al.Expandable then
                        ap.Size = Dim2(ap.Size.X.Scale, ap.Size.X.Offset, 0, al.HeaderSize);
                        ap.AutomaticSize = "None";
                        ap.Top.Size = Dim2(1, 0, 0, al.HeaderSize);
                        ap.Top.AutomaticSize = "None";
                        ap.Content.Visible = true;
                        an.ImageLabel.Parent.Parent.Parent.Content.Visible = false;
                    end; if al.Opened then
                        al:Open();
                    end;
                end); return al.__type, al;
            end; return ah;
        end;
        function a.Q()
            local aa = a.load "b"
            local ae = aa.New

            local af = {}

            function af.New(ah, aj)
                local ak =
                    ae(
                    "Frame",
                    {
                        Parent = aj.Parent,
                        Size = aj.ParentType ~= "Group" and Dim2(1, -7, 0, 7 * (aj.Columns or 1)) or
                            Dim2(0, 7 * (aj.Columns or 1), 0, 0),
                        BackgroundTransparency = 1
                    }
                )

                return "Space", {__type = "Space", ElementFrame = ak}
            end

            return af
        end
        function a.R()
            local aa = a.load "b"
            local ae = aa.New

            local af = {}

            local function ParseAspectRatio(ah)
                if type(ah) == "string" then
                    local aj, ak = ah:match "(%d+):(%d+)"
                    if aj and ak then
                        return tonumber(aj) / tonumber(ak)
                    end
                elseif type(ah) == "number" then
                    return ah
                end
                return nil
            end

            function af.New(ah, aj)
                local ak = {
                    __type = "Image",
                    Image = aj.Image or "",
                    AspectRatio = aj.AspectRatio or "16:9",
                    Radius = aj.Radius or aj.Window.ElementConfig.UICorner
                }
                local al = aa.Image(ak.Image, ak.Image, ak.Radius, aj.Window.Folder, "Image", false)
                al.Parent = aj.Parent
                al.Size = Dim2(1, 0, 0, 0)
                al.BackgroundTransparency = 1

                local am = ParseAspectRatio(ak.AspectRatio)
                local an

                if am then
                    an =
                        ae(
                        "UIAspectRatioConstraint",
                        {
                            Parent = al,
                            AspectRatio = am,
                            AspectType = "ScaleWithParentSize",
                            DominantAxis = "Width"
                        }
                    )
                end

                function ak.Destroy(ao)
                    al:Destroy()
                end

                return ak.__type, ak
            end

            return af
        end
        function a.S()
            local aa = a.load "b"
            local ae = aa.New

            local af = {}

            function af.New(ah, aj)
                local ak = {
                    __type = "Group",
                    Elements = {}
                }

                local al =
                    ae(
                    "Frame",
                    {
                        Size = Dim2(1, 0, 0, 0),
                        BackgroundTransparency = 1,
                        AutomaticSize = "Y",
                        Parent = aj.Parent
                    },
                    {
                        ae(
                            "UIListLayout",
                            {
                                FillDirection = "Horizontal",
                                HorizontalAlignment = "Center",
                                Padding = Dim(0, aj.Tab and aj.Tab.Gap or (Window.NewElements and 1 or 6))
                            }
                        )
                    }
                )

                local am = aj.ElementsModule
                am.Load(
                    ak,
                    al,
                    am.Elements,
                    aj.Window,
                    aj.WindUI,
                    function(an, ao)
                        local ap = aj.Tab and aj.Tab.Gap or (aj.Window.NewElements and 1 or 6)

                        local aq = {}
                        local ar = 0

                        for as, at in next, ao do
                            if at.__type == "Space" then
                                ar = ar + (at.ElementFrame.Size.X.Offset or 6)
                            elseif at.__type == "Divider" then
                                ar = ar + (at.ElementFrame.Size.X.Offset or 1)
                            else
                                tble.insert(aq, at)
                            end
                        end

                        local au = #aq
                        if au == 0 then
                            return
                        end

                        local av = 1 / au

                        local aw = ap * (au - 1)

                        local ax = -(aw + ar)

                        local ay = math.floor(ax / au)
                        local az = ax - (ay * au)

                        for aA, aB in next, aq do
                            local aC = ay
                            if aA <= math.abs(az) then
                                aC = aC - 1
                            end

                            if aB.ElementFrame then
                                aB.ElementFrame.Size = Dim2(av, aC, 1, 0)
                            end
                        end
                    end,
                    am,
                    aj.UIScale,
                    aj.Tab
                )

                return ak.__type, ak
            end

            return af
        end
        function a.T()
            return {
                Elements = {
                    Paragraph = a.load "A",
                    Button = a.load "B",
                    Toggle = a.load "E",
                    Slider = a.load "F",
                    Keybind = a.load "G",
                    Input = a.load "H",
                    Dropdown = a.load "K",
                    Code = a.load "N",
                    Colorpicker = a.load "O",
                    Section = a.load "P",
                    Divider = a.load "I",
                    Space = a.load "Q",
                    Image = a.load "R",
                    Group = a.load "S"
                },
                Load = function(aa, ae, af, ah, aj, ak, al, am, an)
                    for ao, ap in next, af do
                        aa[ao] = function(aq, ar)
                            ar = ar or {}
                            ar.Tab = an or aa
                            ar.ParentType = aa.__type
                            ar.ParentTable = aa
                            ar.Index = #aa.Elements + 1
                            ar.GlobalIndex = #ah.AllElements + 1
                            ar.Parent = ae
                            ar.Window = ah
                            ar.WindUI = aj
                            ar.UIScale = am
                            ar.ElementsModule = al
                            local as, au = ap:New(ar)

                            if ar.Flag and typeof(ar.Flag) == "string" then
                                if ah.CurrentConfig then
                                    ah.CurrentConfig:Register(ar.Flag, au)

                                    if ah.PendingConfigData and ah.PendingConfigData[ar.Flag] then
                                        local av = ah.PendingConfigData[ar.Flag]

                                        local aw = ah.ConfigManager
                                        if aw.Parser[av.__type] then
                                            task.defer(
                                                function()
                                                    local ax, ay =
                                                        pcall(
                                                        function()
                                                            aw.Parser[av.__type].Load(au, av)
                                                        end
                                                    )

                                                    if ax then
                                                        ah.PendingConfigData[ar.Flag] = nil
                                                    else
                                                        warn(
                                                            "[ WindUI ] Failed to apply pending config for '" ..
                                                                ar.Flag .. "': " .. tostring(ay)
                                                        )
                                                    end
                                                end
                                            )
                                        end
                                    end
                                else
                                    ah.PendingFlags = ah.PendingFlags or {}
                                    ah.PendingFlags[ar.Flag] = au
                                end
                            end

                            local av
                            for aw, ax in next, au do
                                if typeof(ax) == "table" and aw ~= "ElementFrame" and aw:match "Frame$" then
                                    av = ax
                                    break
                                end
                            end

                            if av then
                                au.ElementFrame = av.UIElements.Main
                                function au.SetTitle(ay, az)
                                    av:SetTitle(az)
                                end
                                function au.SetDesc(ay, az)
                                    av:SetDesc(az)
                                end
                                function au.Highlight(ay)
                                    av:Highlight()
                                end
                                function au.Destroy(ay)
                                    av:Destroy()

                                    table.remove(ah.AllElements, ar.GlobalIndex)
                                    table.remove(aa.Elements, ar.Index)
                                    table.remove(an.Elements, ar.Index)
                                    aa:UpdateAllElementShapes(aa)
                                end
                            end

                            ah.AllElements[ar.Index] = au
                            aa.Elements[ar.Index] = au
                            if an then
                                an.Elements[ar.Index] = au
                            end

                            if ah.NewElements then
                                aa:UpdateAllElementShapes(aa)
                            end

                            if ak then
                                ak(au, aa.Elements)
                            end
                            return au
                        end
                    end
                    function aa.UpdateAllElementShapes(aq, ar)
                        for as, au in next, ar.Elements do
                            local av
                            for aw, ax in pairs(au) do
                                if typeof(ax) == "table" and aw:match "Frame$" then
                                    av = ax
                                    break
                                end
                            end

                            if av then
                                av.Index = as
                                if av.UpdateShape then
                                    av.UpdateShape(ar)
                                end
                            end
                        end
                    end
                end
            }
        end
        function a.U()
            local ae = cmdm

            local af = a.load "b"
            local ah = af.New
            local aj = af.Tween

            local ak = a.load "y".New
            local al = a.load "u".New

            local am = {
                Tabs = {},
                Containers = {},
                SelectedTab = nil,
                TabCount = 0,
                ToolTipParent = nil,
                TabHighlight = nil,
                OnChangeFunc = function(am)
                end
            }

            function am.Init(an, ao, ap, aq)
                Window = an
                WindUI = ao
                am.ToolTipParent = ap
                am.TabHighlight = aq
                return am
            end

            function am.New(an, ao)
                local ap = {
                    __type = "Tab",
                    Title = an.Title or "Tab",
                    Desc = an.Desc,
                    Icon = an.Icon,
                    IconColor = an.IconColor,
                    IconShape = an.IconShape,
                    IconThemed = an.IconThemed,
                    Locked = an.Locked,
                    ShowTabTitle = an.ShowTabTitle,
                    Selected = false,
                    Index = nil,
                    Parent = an.Parent,
                    UIElements = {},
                    Elements = {},
                    ContainerFrame = nil,
                    UICorner = Window.UICorner - (Window.UIPadding / 2),
                    Gap = Window.NewElements and 1 or 6,
                    TabPaddingX = 4 + (Window.UIPadding / 2),
                    TabPaddingY = 3 + (Window.UIPadding / 2),
                    TitlePaddingY = 0
                }

                if ap.IconShape then
                    ap.TabPaddingX = 2 + (Window.UIPadding / 4)
                    ap.TabPaddingY = 2 + (Window.UIPadding / 4)
                    ap.TitlePaddingY = 2 + (Window.UIPadding / 4)
                end

                am.TabCount = am.TabCount + 1

                local aq = am.TabCount
                ap.Index = aq

                ap.UIElements.Main =
                    af.NewRoundFrame(
                    ap.UICorner,
                    "Squircle",
                    {
                        BackgroundTransparency = 1,
                        Size = Dim2(1, -7, 0, 0),
                        AutomaticSize = "Y",
                        Parent = an.Parent,
                        ThemeTag = {
                            ImageColor3 = "TabBackground"
                        },
                        ImageTransparency = 1
                    },
                    {
                        af.NewRoundFrame(
                            ap.UICorner,
                            "SquircleOutline",
                            {
                                Size = DIM1010,
                                ThemeTag = {
                                    ImageColor3 = "Text"
                                },
                                ImageTransparency = 1,
                                Name = "Outline"
                            },
                            {
                                ah(
                                    "UIGradient",
                                    {
                                        Rotation = 80,
                                        Color = CSnew {
                                            CSKnew(0.0, WHITE),
                                            CSKnew(0.5, WHITE),
                                            CSKnew(1.0, WHITE)
                                        },
                                        Transparency = NSnew {
                                            NSKnew(0.0, 0.1),
                                            NSKnew(0.5, 1),
                                            NSKnew(1.0, 0.1)
                                        }
                                    }
                                )
                            }
                        ),
                        af.NewRoundFrame(
                            ap.UICorner,
                            "Squircle",
                            {
                                Size = Dim2(1, 0, 0, 0),
                                AutomaticSize = "Y",
                                ThemeTag = {
                                    ImageColor3 = "Text"
                                },
                                ImageTransparency = 1,
                                Name = "Frame"
                            },
                            {
                                ah(
                                    "UIListLayout",
                                    {
                                        SortOrder = "LayoutOrder",
                                        Padding = Dim(0, 2 + (Window.UIPadding / 2)),
                                        FillDirection = "Horizontal",
                                        VerticalAlignment = "Center"
                                    }
                                ),
                                ah(
                                    "TextLabel",
                                    {
                                        Text = ap.Title,
                                        ThemeTag = {
                                            TextColor3 = "TabTitle"
                                        },
                                        TextTransparency = not ap.Locked and 0.4 or .7,
                                        TextSize = 15,
                                        Size = Dim2(1, 0, 0, 0),
                                        FontFace = Fnew(af.Font, Enum.FontWeight.Medium),
                                        TextWrapped = true,
                                        RichText = true,
                                        AutomaticSize = "Y",
                                        LayoutOrder = 2,
                                        TextXAlignment = "Left",
                                        BackgroundTransparency = 1
                                    },
                                    {
                                        ah(
                                            "UIPadding",
                                            {
                                                PaddingTop = Dim(0, ap.TitlePaddingY),
                                                PaddingBottom = Dim(0, ap.TitlePaddingY)
                                            }
                                        )
                                    }
                                ),
                                ah(
                                    "UIPadding",
                                    {
                                        PaddingTop = Dim(0, ap.TabPaddingY),
                                        PaddingLeft = Dim(0, ap.TabPaddingX),
                                        PaddingRight = Dim(0, ap.TabPaddingX),
                                        PaddingBottom = Dim(0, ap.TabPaddingY)
                                    }
                                )
                            }
                        )
                    },
                    true
                )

                local ar = 0
                local as
                local au

                if ap.Icon then
                    as =
                        af.Image(
                        ap.Icon,
                        ap.Icon .. ":" .. ap.Title,
                        0,
                        Window.Folder,
                        ap.__type,
                        ap.IconColor and false or true,
                        ap.IconThemed,
                        "TabIcon"
                    )
                    as.Size = Dim2(0, 16, 0, 16)
                    if ap.IconColor then
                        as.ImageLabel.ImageColor3 = ap.IconColor
                    end
                    if not ap.IconShape then
                        as.Parent = ap.UIElements.Main.Frame
                        ap.UIElements.Icon = as
                        as.ImageLabel.ImageTransparency = not ap.Locked and 0 or .7
                        ar = -18 - (Window.UIPadding / 2)
                        ap.UIElements.Main.Frame.TextLabel.Size = Dim2(1, ar, 0, 0)
                    elseif ap.IconColor then
                        af.NewRoundFrame(
                            ap.IconShape ~= "Circle" and (ap.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
                            "Squircle",
                            {
                                Size = Dim2(0, 26, 0, 26),
                                ImageColor3 = ap.IconColor,
                                Parent = ap.UIElements.Main.Frame
                            },
                            {
                                as,
                                af.NewRoundFrame(
                                    ap.IconShape ~= "Circle" and (ap.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
                                    "SquircleOutline",
                                    {
                                        Size = DIM1010,
                                        ThemeTag = {
                                            ImageColor3 = "White"
                                        },
                                        ImageTransparency = .35,
                                        Name = "Outline"
                                    },
                                    {
                                        ah(
                                            "UIGradient",
                                            {
                                                Rotation = 45,
                                                Color = CSnew {
                                                    CSKnew(0.0, WHITE),
                                                    CSKnew(0.5, WHITE),
                                                    CSKnew(1.0, WHITE)
                                                },
                                                Transparency = NSnew {
                                                    NSKnew(0.0, 0.1),
                                                    NSKnew(0.5, 1),
                                                    NSKnew(1.0, 0.1)
                                                }
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        as.AnchorPoint = VEC05
                        as.Position = DIM05
                        as.ImageLabel.ImageTransparency = 0
                        as.ImageLabel.ImageColor3 = af.GetTextColorForHSB(ap.IconColor)
                        ar = -28 - (Window.UIPadding / 2)
                        ap.UIElements.Main.Frame.TextLabel.Size = Dim2(1, ar, 0, 0)
                    end

                    au = af.Image(ap.Icon, ap.Icon .. ":" .. ap.Title, 0, Window.Folder, ap.__type, true, ap.IconThemed)
                    au.Size = Dim2(0, 16, 0, 16)
                    au.ImageLabel.ImageTransparency = not ap.Locked and 0 or .7
                    ar = -30
                end

                ap.UIElements.ContainerFrame =
                    ah(
                    "ScrollingFrame",
                    {
                        Size = Dim2(1, 0, 1, ap.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
                        BackgroundTransparency = 1,
                        ScrollBarThickness = 0,
                        ElasticBehavior = "Never",
                        CanvasSize = DIM0000,
                        AnchorPoint = Vec2(0, 1),
                        Position = DIM0010,
                        AutomaticCanvasSize = "Y",
                        ScrollingDirection = "Y"
                    },
                    {
                        ah(
                            "UIPadding",
                            {
                                PaddingTop = Dim(0, not Window.HidePanelBackground and 20 or 10),
                                PaddingLeft = Dim(0, not Window.HidePanelBackground and 20 or 10),
                                PaddingRight = Dim(0, not Window.HidePanelBackground and 20 or 10),
                                PaddingBottom = Dim(0, not Window.HidePanelBackground and 20 or 10)
                            }
                        ),
                        ah(
                            "UIListLayout",
                            {
                                SortOrder = "LayoutOrder",
                                Padding = Dim(0, ap.Gap),
                                HorizontalAlignment = "Center"
                            }
                        )
                    }
                )

                ap.UIElements.ContainerFrameCanvas =
                    ah(
                    "Frame",
                    {
                        Size = DIM1010,
                        BackgroundTransparency = 1,
                        Visible = false,
                        Parent = Window.UIElements.MainBar,
                        ZIndex = 5
                    },
                    {
                        ap.UIElements.ContainerFrame,
                        ah(
                            "Frame",
                            {
                                Size = Dim2(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                                BackgroundTransparency = 1,
                                Visible = ap.ShowTabTitle or false,
                                Name = "TabTitle"
                            },
                            {
                                au,
                                ah(
                                    "TextLabel",
                                    {
                                        Text = ap.Title,
                                        ThemeTag = {
                                            TextColor3 = "Text"
                                        },
                                        TextSize = 20,
                                        TextTransparency = .1,
                                        Size = Dim2(1, -ar, 1, 0),
                                        FontFace = Fnew(af.Font, Enum.FontWeight.SemiBold),
                                        TextTruncate = "AtEnd",
                                        RichText = true,
                                        LayoutOrder = 2,
                                        TextXAlignment = "Left",
                                        BackgroundTransparency = 1
                                    }
                                ),
                                ah(
                                    "UIPadding",
                                    {
                                        PaddingTop = Dim(0, 20),
                                        PaddingLeft = Dim(0, 20),
                                        PaddingRight = Dim(0, 20),
                                        PaddingBottom = Dim(0, 20)
                                    }
                                ),
                                ah(
                                    "UIListLayout",
                                    {
                                        SortOrder = "LayoutOrder",
                                        Padding = Dim(0, 10),
                                        FillDirection = "Horizontal",
                                        VerticalAlignment = "Center"
                                    }
                                )
                            }
                        ),
                        ah(
                            "Frame",
                            {
                                Size = Dim2(1, 0, 0, 1),
                                BackgroundTransparency = .9,
                                ThemeTag = {
                                    BackgroundColor3 = "Text"
                                },
                                Position = Dim2(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                                Visible = ap.ShowTabTitle or false
                            }
                        )
                    }
                )

                am.Containers[aq] = ap.UIElements.ContainerFrameCanvas
                am.Tabs[aq] = ap

                ap.ContainerFrame = ContainerFrameCanvas

                af.AddSignal(
                    ap.UIElements.Main.MouseButton1Click,
                    function()
                        if not ap.Locked then
                            am:SelectTab(aq)
                        end
                    end
                )

                if Window.ScrollBarEnabled then
                    al(ap.UIElements.ContainerFrame, ap.UIElements.ContainerFrameCanvas, Window, 3)
                end

                local av
                local aw
                local ax
                local ay = false

                if ap.Desc then
                    af.AddSignal(
                        ap.UIElements.Main.InputBegan,
                        function()
                            ay = true
                            aw =
                                tk.spawn(
                                function()
                                    twait(0.35)
                                    if ay and not av then
                                        av = ak(ap.Desc, am.ToolTipParent, true)
                                        av.Container.AnchorPoint = VEC05

                                        local function updatePosition()
                                            if av then
                                                av.Container.Position = Dim2(0, ae.X, 0, ae.Y - 4)
                                            end
                                        end

                                        updatePosition()
                                        ax = ae.Move:Connect(updatePosition)
                                        av:Open()
                                    end
                                end
                            )
                        end
                    )
                end

                af.AddSignal(ap.UIElements.Main.MouseEnter, function()
                    if not ap.Locked then
                        TwCreate(TweenService, ap.UIElements.Main.Frame, TWI_008, {ImageTransparency = 0.97}):Play();
                    end;
                end);
                af.AddSignal(ap.UIElements.Main.InputEnded, function()
                    if ap.Desc then ay = false;
                        if aw then tk.cancel(aw) aw = nil; end;
                        if ax then ax:Disconnect(); ax = nil; end;
                        if av then av:Close(); av = nil; end;
                    end; if not ap.Locked then
                        TwCreate(TweenService, ap.UIElements.Main.Frame, TWI_008, {ImageTransparency = 1}):Play();
                    end;
                end); function ap.ScrollToTheElement(az, aA)
                    ap.UIElements.ContainerFrame.ScrollingEnabled = false;
                    TwCreate(ap.UIElements.ContainerFrame, TWI_Q_045,
                        {CanvasPosition = Vec2(0, ap.Elements[aA].ElementFrame.AbsolutePosition.Y - ap.UIElements.ContainerFrame.AbsolutePosition.Y - ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset)}
                    ):Play(); tk.spawn(function()
                        twait(.48) if ap.Elements[aA].Highlight then
                            ap.Elements[aA]:Highlight();
                            ap.UIElements.ContainerFrame.ScrollingEnabled = true;
                        end;
                    end); return ap;
                end; local az = a.load"T";
                az.Load(ap, ap.UIElements.ContainerFrame, az.Elements, Window, WindUI, nil, az, ao);
                function ap.LockAll(aA)
                    for aB, aC in next, Window.AllElements do
                        if aC.Tab and aC.Tab.Index and aC.Tab.Index == ap.Index and aC.Lock then
                            aC:Lock()
                        end;
                    end;
                end; function ap.UnlockAll(aA)
                    for aB, aC in next, Window.AllElements do
                        if aC.Tab and aC.Tab.Index and aC.Tab.Index == ap.Index and aC.Unlock then
                            aC:Unlock();
                        end;
                    end;
                end; function ap.GetLocked(aA)
                    local aB = {}; for aC, aD in next, Window.AllElements do
                        if aD.Tab and aD.Tab.Index and aD.Tab.Index == ap.Index and aD.Locked == true then
                            tble.insert(aB, aD);
                        end;
                    end; return aB;
                end; function ap.GetUnlocked(aA)
                    local aB = {}; for aC, aD in next, Window.AllElements do
                        if aD.Tab and aD.Tab.Index and aD.Tab.Index == ap.Index and aD.Locked == false then
                            tble.insert(aB, aD);
                        end;
                    end; return aB;
                end; function ap.Select(aA)
                    return am:SelectTab(ap.Index);
                end; tk.spawn(function()
                    local aA,aB = ah("Frame", {
                        BackgroundTransparency = 1,
                        Size = Dim2(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
                        Parent = ap.UIElements.ContainerFrame
                    }, {
                        ah("UIListLayout", {
                            Padding = Dim(0, 8),
                            SortOrder = "LayoutOrder",
                            VerticalAlignment = "Center",
                            HorizontalAlignment = "Center",
                            FillDirection = "Vertical"
                        }), ah("ImageLabel", {
                            Size = Dim2(0, 48, 0, 48),
                            Image = af.Icon "frown"[1],
                            ImageRectOffset = af.Icon "frown"[2].ImageRectPosition,
                            ImageRectSize = af.Icon "frown"[2].ImageRectSize,
                            ThemeTag = {
                                ImageColor3 = "Icon"
                            },
                            BackgroundTransparency = 1,
                            ImageTransparency = .6
                        }), ah("TextLabel", {
                            AutomaticSize = "XY",
                            Text = "This tab is empty",
                            ThemeTag = {
                                TextColor3 = "Text"
                            },
                            TextSize = 18,
                            TextTransparency = .5,
                            BackgroundTransparency = 1,
                            FontFace = Fnew(af.Font, Enum.FontWeight.Medium)
                        });
                    }), nil;
                    aB = af.AddSignal(ap.UIElements.ContainerFrame.ChildAdded, function()
                        aA.Visible = false;
                        aB:Disconnect();
                    end);
                end); return ap;
            end; function am.OnChange(an, ao)
                am.OnChangeFunc = ao;
            end; function am.SelectTab(an, ao)
                if not am.Tabs[ao].Locked then
                    am.SelectedTab = ao; for ap, aq in next, am.Tabs do
                        if not aq.Locked then
                            TwCreate(TweenService, aq.UIElements.Main, TWI_015, {ImageTransparency = 1}):Play();
                            TwCreate(TweenService, aq.UIElements.Main.Frame.TextLabel, TWI_015, {TextTransparency = 0.3}):Play();
                            if aq.UIElements.Icon and not aq.IconColor then
                                TwCreate(TweenService, aq.UIElements.Icon.ImageLabel, TWI_015, {ImageTransparency = 0.4}):Play();
                            end;
                            aq.Selected = false;
                        end;
                    end; if not isFirstLoad then
                        TwCreate(TweenService, am.Tabs[ao].UIElements.Main, TWI_015, {ImageTransparency = 0.93}):Play();
                        TwCreate(TweenService, am.Tabs[ao].UIElements.Main.Frame.TextLabel, TWI_015, {TextTransparency = 0}):Play();
                    else
                        am.Tabs[ao].UIElements.Main.ImageTransparency = 0.93;
                        am.Tabs[ao].UIElements.Main.Frame.TextLabel.TextTransparency = 0;
                    end;
                    if am.Tabs[ao].UIElements.Icon and not am.Tabs[ao].IconColor then
                        if isFirstLoad then
                            TwCreate(TweenService, am.Tabs[ao].UIElements.Icon.ImageLabel, TWI_015, {ImageTransparency = 0.1}):Play();
                        else
                            am.Tabs[ao].UIElements.Icon.ImageLabel.ImageTransparency = 0.1;
                        end;
                    end; am.Tabs[ao].Selected = true;
                    tk.spawn(function()
                        for ar, as in next, am.Containers do
                            as.AnchorPoint = Vec2(0, 0.05);
                            as.Visible = false;
                        end; am.Containers[ao].Visible = true
                        if not isFirstLoad then
                            TwCreate(TweenService, am.Containers[ao], TwInfo(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                                {AnchorPoint = Vec2(0, 0)}
                            ):Play();
                        else
                            am.Containers[ao].AnchorPoint = Vec2(0, 0);
                        end;
                    end); am.OnChangeFunc(ao);
                end;
            end; return am;
        end;
        function a.V()
            local aa = {}

            local ae = a.load "b"
            local af = ae.New
            local ah = ae.Tween

            local aj = a.load "U"

            function aa.New(ak, al, am, an, ao)
                local ap = {
                    Title = ak.Title or "Section",
                    Icon = ak.Icon,
                    IconThemed = ak.IconThemed,
                    Opened = ak.Opened or false,
                    HeaderSize = 42,
                    IconSize = 18,
                    Expandable = false
                }

                local aq
                if ap.Icon then
                    aq = ae.Image(ap.Icon, ap.Icon, 0, am, "Section", true, ap.IconThemed)

                    aq.Size = Dim2(0, ap.IconSize, 0, ap.IconSize)
                    aq.ImageLabel.ImageTransparency = .25
                end

                local ar =
                    af(
                    "Frame",
                    {
                        Size = Dim2(0, ap.IconSize, 0, ap.IconSize),
                        BackgroundTransparency = 1,
                        Visible = false
                    },
                    {
                        af(
                            "ImageLabel",
                            {
                                Size = DIM1010,
                                BackgroundTransparency = 1,
                                Image = ae.Icon "chevron-down"[1],
                                ImageRectSize = ae.Icon "chevron-down"[2].ImageRectSize,
                                ImageRectOffset = ae.Icon "chevron-down"[2].ImageRectPosition,
                                ThemeTag = {
                                    ImageColor3 = "Icon"
                                },
                                ImageTransparency = .7
                            }
                        )
                    }
                )

                local as =
                    af(
                    "Frame",
                    {
                        Size = Dim2(1, 0, 0, ap.HeaderSize),
                        BackgroundTransparency = 1,
                        Parent = al,
                        ClipsDescendants = true
                    },
                    {
                        af(
                            "TextButton",
                            {
                                Size = Dim2(1, 0, 0, ap.HeaderSize),
                                BackgroundTransparency = 1,
                                Text = ""
                            },
                            {
                                aq,
                                af(
                                    "TextLabel",
                                    {
                                        Text = ap.Title,
                                        TextXAlignment = "Left",
                                        Size = Dim2(1, aq and (-ap.IconSize - 10) * 2 or (-ap.IconSize - 10), 1, 0),
                                        ThemeTag = {
                                            TextColor3 = "Text"
                                        },
                                        FontFace = Fnew(ae.Font, Enum.FontWeight.SemiBold),
                                        TextSize = 14,
                                        BackgroundTransparency = 1,
                                        TextTransparency = .7,
                                        TextWrapped = true
                                    }
                                ),
                                af(
                                    "UIListLayout",
                                    {
                                        FillDirection = "Horizontal",
                                        VerticalAlignment = "Center",
                                        Padding = Dim(0, 10)
                                    }
                                ),
                                ar,
                                af(
                                    "UIPadding",
                                    {
                                        PaddingLeft = Dim(0, 11),
                                        PaddingRight = Dim(0, 11)
                                    }
                                )
                            }
                        ),
                        af(
                            "Frame",
                            {
                                BackgroundTransparency = 1,
                                Size = Dim2(1, 0, 0, 0),
                                AutomaticSize = "Y",
                                Name = "Content",
                                Visible = true,
                                Position = Dim2(0, 0, 0, ap.HeaderSize)
                            },
                            {
                                af(
                                    "UIListLayout",
                                    {
                                        FillDirection = "Vertical",
                                        Padding = Dim(0, ao.Gap),
                                        VerticalAlignment = "Bottom"
                                    }
                                )
                            }
                        )
                    }
                )

                function ap.Tab(au, av)
                    if not ap.Expandable then
                        ap.Expandable = true;
                        ar.Visible = true;
                    end av.Parent = as.Content;
                    return aj.New(av, an);
                end; function ap.Open(au)
                    if ap.Expandable then
                        ap.Opened = true
                        TwCreate(TweenService, as, TwInfo(0.33, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {Size = Dim2(1, 0, 0, ap.HeaderSize + (as.Content.AbsoluteSize.Y / an))}
                        ):Play(); TwCreate(TweenService, ar.ImageLabel, TWI_Q_01, {Rotation = 180}):Play();
                    end;
                end; function ap.Close(au)
                    if ap.Expandable then
                        ap.Opened = false
                        TwCreate(TweenService, as, TwInfo(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {Size = Dim2(1, 0, 0, ap.HeaderSize)}
                        ):Play() TwCreate(TweenService, ar.ImageLabel, TWI_Q_01, {Rotation = 0}):Play();
                    end;
                end; ae.AddSignal(as.TextButton.MouseButton1Click, function()
                    if ap.Expandable then
                        if ap.Opened then
                            ap:Close();
                        else
                            ap:Open();
                        end;
                    end;
                end); ae.AddSignal(PropChangeSignal(as.Content.UIListLayout, "AbsoluteContentSize"), function()
                    if ap.Opened then
                        ap:Open();
                    end;
                end); if ap.Opened then
                    tk.spawn(function()
                        twait();
                        ap:Open();
                    end);
                end; return ap;
            end; return aa;
        end;
        function a.W()
            return {
                Tab = "table-of-contents",
                Paragraph = "type",
                Button = "square-mouse-pointer",
                Toggle = "toggle-right",
                Slider = "sliders-horizontal",
                Keybind = "command",
                Input = "text-cursor-input",
                Dropdown = "chevrons-up-down",
                Code = "terminal",
                Colorpicker = "palette"
            }
        end
        function a.X()
            local ae = {
                Margin = 8,
                Padding = 9
            }

            local af = a.load "b"
            local ah = af.New

            function ae.new(ak, al, am)
                local an = {
                    IconSize = 18,
                    Padding = 14,
                    Radius = 22,
                    Width = 400,
                    MaxHeight = 380,
                    Icons = a.load "W"
                }

                local ao =
                    ah(
                    "TextBox",
                    {
                        Text = "",
                        PlaceholderText = "Search...",
                        ThemeTag = {
                            PlaceholderColor3 = "Placeholder",
                            TextColor3 = "Text"
                        },
                        Size = Dim2(1, -((an.IconSize * 2) + (an.Padding * 2)), 0, 0),
                        AutomaticSize = "Y",
                        ClipsDescendants = true,
                        ClearTextOnFocus = false,
                        BackgroundTransparency = 1,
                        TextXAlignment = "Left",
                        FontFace = Fnew(af.Font, Enum.FontWeight.Regular),
                        TextSize = 18
                    }
                )

                local ap =
                    ah(
                    "ImageLabel",
                    {
                        Image = af.Icon "x"[1],
                        ImageRectSize = af.Icon "x"[2].ImageRectSize,
                        ImageRectOffset = af.Icon "x"[2].ImageRectPosition,
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            ImageColor3 = "Icon"
                        },
                        ImageTransparency = .1,
                        Size = Dim2(0, an.IconSize, 0, an.IconSize)
                    },
                    {
                        ah(
                            "TextButton",
                            {
                                Size = Dim2(1, 8, 1, 8),
                                BackgroundTransparency = 1,
                                Active = true,
                                ZIndex = 999999999,
                                AnchorPoint = VEC05,
                                Position = DIM05,
                                Text = ""
                            }
                        )
                    }
                )

                local aq =
                    ah(
                    "ScrollingFrame",
                    {
                        Size = Dim2(1, 0, 0, 0),
                        AutomaticCanvasSize = "Y",
                        ScrollingDirection = "Y",
                        ElasticBehavior = "Never",
                        ScrollBarThickness = 0,
                        CanvasSize = DIM0000,
                        BackgroundTransparency = 1,
                        Visible = false
                    },
                    {
                        ah(
                            "UIListLayout",
                            {
                                Padding = Dim(0, 0),
                                FillDirection = "Vertical"
                            }
                        ),
                        ah(
                            "UIPadding",
                            {
                                PaddingTop = Dim(0, an.Padding),
                                PaddingLeft = Dim(0, an.Padding),
                                PaddingRight = Dim(0, an.Padding),
                                PaddingBottom = Dim(0, an.Padding)
                            }
                        )
                    }
                )

                local ar =
                    af.NewRoundFrame(
                    an.Radius,
                    "Squircle",
                    {
                        Size = DIM1010,
                        ThemeTag = {
                            ImageColor3 = "Background"
                        },
                        ImageTransparency = 0
                    },
                    {
                        af.NewRoundFrame(
                            an.Radius,
                            "Squircle",
                            {
                                Size = DIM1010,
                                BackgroundTransparency = 1,
                                Visible = false,
                                ImageColor3 = WHITE,
                                ImageTransparency = .98,
                                Name = "Frame"
                            },
                            {
                                ah(
                                    "Frame",
                                    {
                                        Size = Dim2(1, 0, 0, 46),
                                        BackgroundTransparency = 1
                                    },
                                    {
                                        ah(
                                            "Frame",
                                            {
                                                Size = DIM1010,
                                                BackgroundTransparency = 1
                                            },
                                            {
                                                ah(
                                                    "ImageLabel",
                                                    {
                                                        Image = af.Icon "search"[1],
                                                        ImageRectSize = af.Icon "search"[2].ImageRectSize,
                                                        ImageRectOffset = af.Icon "search"[2].ImageRectPosition,
                                                        BackgroundTransparency = 1,
                                                        ThemeTag = {
                                                            ImageColor3 = "Icon"
                                                        },
                                                        ImageTransparency = .1,
                                                        Size = Dim2(0, an.IconSize, 0, an.IconSize)
                                                    }
                                                ),
                                                ao,
                                                ap,
                                                ah(
                                                    "UIListLayout",
                                                    {
                                                        Padding = Dim(0, an.Padding),
                                                        FillDirection = "Horizontal",
                                                        VerticalAlignment = "Center"
                                                    }
                                                ),
                                                ah(
                                                    "UIPadding",
                                                    {
                                                        PaddingLeft = Dim(0, an.Padding),
                                                        PaddingRight = Dim(0, an.Padding)
                                                    }
                                                )
                                            }
                                        )
                                    }
                                ),
                                ah(
                                    "Frame",
                                    {
                                        BackgroundTransparency = 1,
                                        AutomaticSize = "Y",
                                        Size = Dim2(1, 0, 0, 0),
                                        Name = "Results"
                                    },
                                    {
                                        ah(
                                            "Frame",
                                            {
                                                Size = Dim2(1, 0, 0, 1),
                                                ThemeTag = {
                                                    BackgroundColor3 = "Outline"
                                                },
                                                BackgroundTransparency = .9,
                                                Visible = false
                                            }
                                        ),
                                        aq,
                                        ah(
                                            "UISizeConstraint",
                                            {
                                                MaxSize = Vec2(an.Width, an.MaxHeight)
                                            }
                                        )
                                    }
                                ),
                                ah(
                                    "UIListLayout",
                                    {
                                        Padding = Dim(0, 0),
                                        FillDirection = "Vertical"
                                    }
                                )
                            }
                        )
                    }
                )

                local as =
                    ah(
                    "Frame",
                    {
                        Size = Dim2(0, an.Width, 0, 0),
                        AutomaticSize = "Y",
                        Parent = al,
                        BackgroundTransparency = 1,
                        Position = DIM05,
                        AnchorPoint = VEC05,
                        Visible = false,
                        ZIndex = 99999999
                    },
                    {
                        ah(
                            "UIScale",
                            {
                                Scale = .9
                            }
                        ),
                        ar,
                        af.NewRoundFrame(
                            an.Radius,
                            "SquircleOutline2",
                            {
                                Size = DIM1010,
                                ThemeTag = {
                                    ImageColor3 = "Outline"
                                },
                                ImageTransparency = 1
                            },
                            {
                                ah(
                                    "UIGradient",
                                    {
                                        Rotation = 45,
                                        Transparency = NSnew {
                                            NSKnew(0, 0.55),
                                            NSKnew(0.5, 0.8),
                                            NSKnew(1, 0.6)
                                        }
                                    }
                                )
                            }
                        )
                    }
                )

                local function CreateSearchTab(au, av, aw, ax, ay, az)
                    local aA =
                        ah(
                        "TextButton",
                        {
                            Size = Dim2(1, 0, 0, 0),
                            AutomaticSize = "Y",
                            BackgroundTransparency = 1,
                            Parent = ax or nil
                        },
                        {
                            af.NewRoundFrame(
                                an.Radius - 11,
                                "Squircle",
                                {
                                    Size = Dim2(1, 0, 0, 0),
                                    Position = DIM05,
                                    AnchorPoint = VEC05,
                                    ThemeTag = {
                                        ImageColor3 = "Text"
                                    },
                                    ImageTransparency = 1,
                                    Name = "Main"
                                },
                                {
                                    af.NewRoundFrame(
                                        an.Radius - 11,
                                        "SquircleOutline2",
                                        {
                                            Size = DIM1010,
                                            Position = DIM05,
                                            AnchorPoint = VEC05,
                                            ThemeTag = {
                                                ImageColor3 = "Outline"
                                            },
                                            ImageTransparency = 1,
                                            Name = "Outline"
                                        },
                                        {
                                            ah(
                                                "UIGradient",
                                                {
                                                    Rotation = 65,
                                                    Transparency = NSnew {
                                                        NSKnew(0, 0.55),
                                                        NSKnew(0.5, 0.8),
                                                        NSKnew(1, 0.6)
                                                    }
                                                }
                                            ),
                                            ah(
                                                "UIPadding",
                                                {
                                                    PaddingTop = Dim(0, an.Padding - 2),
                                                    PaddingLeft = Dim(0, an.Padding),
                                                    PaddingRight = Dim(0, an.Padding),
                                                    PaddingBottom = Dim(0, an.Padding - 2)
                                                }
                                            ),
                                            ah(
                                                "ImageLabel",
                                                {
                                                    Image = af.Icon(aw)[1],
                                                    ImageRectSize = af.Icon(aw)[2].ImageRectSize,
                                                    ImageRectOffset = af.Icon(aw)[2].ImageRectPosition,
                                                    BackgroundTransparency = 1,
                                                    ThemeTag = {
                                                        ImageColor3 = "Icon"
                                                    },
                                                    ImageTransparency = .1,
                                                    Size = Dim2(0, an.IconSize, 0, an.IconSize)
                                                }
                                            ),
                                            ah(
                                                "Frame",
                                                {
                                                    Size = Dim2(1, -an.IconSize - an.Padding, 0, 0),
                                                    BackgroundTransparency = 1
                                                },
                                                {
                                                    ah(
                                                        "TextLabel",
                                                        {
                                                            Text = au,
                                                            ThemeTag = {
                                                                TextColor3 = "Text"
                                                            },
                                                            TextSize = 17,
                                                            BackgroundTransparency = 1,
                                                            TextXAlignment = "Left",
                                                            FontFace = Fnew(af.Font, Enum.FontWeight.Medium),
                                                            Size = Dim2(1, 0, 0, 0),
                                                            TextTruncate = "AtEnd",
                                                            AutomaticSize = "Y",
                                                            Name = "Title"
                                                        }
                                                    ),
                                                    ah(
                                                        "TextLabel",
                                                        {
                                                            Text = av or "",
                                                            Visible = av and true or false,
                                                            ThemeTag = {
                                                                TextColor3 = "Text"
                                                            },
                                                            TextSize = 15,
                                                            TextTransparency = .3,
                                                            BackgroundTransparency = 1,
                                                            TextXAlignment = "Left",
                                                            FontFace = Fnew(af.Font, Enum.FontWeight.Medium),
                                                            Size = Dim2(1, 0, 0, 0),
                                                            TextTruncate = "AtEnd",
                                                            AutomaticSize = "Y",
                                                            Name = "Desc"
                                                        }
                                                    ) or nil,
                                                    ah(
                                                        "UIListLayout",
                                                        {
                                                            Padding = Dim(0, 6),
                                                            FillDirection = "Vertical"
                                                        }
                                                    )
                                                }
                                            ),
                                            ah(
                                                "UIListLayout",
                                                {
                                                    Padding = Dim(0, an.Padding),
                                                    FillDirection = "Horizontal"
                                                }
                                            )
                                        }
                                    )
                                },
                                true
                            ),
                            ah(
                                "Frame",
                                {
                                    Name = "ParentContainer",
                                    Size = Dim2(1, -an.Padding, 0, 0),
                                    AutomaticSize = "Y",
                                    BackgroundTransparency = 1,
                                    Visible = ay
                                },
                                {
                                    af.NewRoundFrame(
                                        99,
                                        "Squircle",
                                        {
                                            Size = Dim2(0, 2, 1, 0),
                                            BackgroundTransparency = 1,
                                            ThemeTag = {
                                                ImageColor3 = "Text"
                                            },
                                            ImageTransparency = .9
                                        }
                                    ),
                                    ah(
                                        "Frame",
                                        {
                                            Size = Dim2(1, -an.Padding - 2, 0, 0),
                                            Position = Dim2(0, an.Padding + 2, 0, 0),
                                            BackgroundTransparency = 1
                                        },
                                        {
                                            ah(
                                                "UIListLayout",
                                                {
                                                    Padding = Dim(0, 0),
                                                    FillDirection = "Vertical"
                                                }
                                            )
                                        }
                                    )
                                }
                            ),
                            ah(
                                "UIListLayout",
                                {
                                    Padding = Dim(0, 0),
                                    FillDirection = "Vertical",
                                    HorizontalAlignment = "Right"
                                }
                            )
                        }
                    )

                    aA.Main.Size =
                        Dim2(
                        1,
                        0,
                        0,
                        aA.Main.Outline.Frame.Desc.Visible and
                            (((an.Padding - 2) * 2) + aA.Main.Outline.Frame.Title.TextBounds.Y + 6 +
                                aA.Main.Outline.Frame.Desc.TextBounds.Y) or
                            (((an.Padding - 2) * 2) + aA.Main.Outline.Frame.Title.TextBounds.Y)
                    )

                    af.AddSignal(
                        aA.Main.MouseEnter,
                        function()
                            aj(aA.Main, .04, {ImageTransparency = .95}):Play()
                            aj(aA.Main.Outline, .04, {ImageTransparency = .7}):Play()
                        end
                    )
                    af.AddSignal(
                        aA.Main.InputEnded,
                        function()
                            aj(aA.Main, .08, {ImageTransparency = 1}):Play()
                            aj(aA.Main.Outline, .08, {ImageTransparency = 1}):Play()
                        end
                    )
                    af.AddSignal(
                        aA.Main.MouseButton1Click,
                        function()
                            if az then
                                az()
                            end
                        end
                    )

                    return aA
                end

                local function ContainsText(au, av)
                    if not av or av == "" then
                        return false
                    end

                    if not au or au == "" then
                        return false
                    end

                    local aw = string.lower(au)
                    local ax = string.lower(av)

                    return str.find(aw, ax, 1, true) ~= nil
                end

                local function Search(au)
                    if not au or au == "" then
                        return {}
                    end

                    local av = {}
                    for aw, ax in next, ak.Tabs do
                        local ay = ContainsText(ax.Title or "", au)
                        local az = {}

                        for aA, aB in next, ax.Elements do
                            if aB.__type ~= "Section" then
                                local aC = ContainsText(aB.Title or "", au)
                                local aD = ContainsText(aB.Desc or "", au)

                                if aC or aD then
                                    az[aA] = {
                                        Title = aB.Title,
                                        Desc = aB.Desc,
                                        Original = aB,
                                        __type = aB.__type,
                                        Index = aA
                                    }
                                end
                            end
                        end

                        if ay or next(az) ~= nil then
                            av[aw] = {
                                Tab = ax,
                                Title = ax.Title,
                                Icon = ax.Icon,
                                Elements = az
                            }
                        end
                    end
                    return av
                end

                function an.Search(au, av)
                    av = av or ""

                    local aw = Search(av)

                    aq.Visible = true
                    ar.Frame.Results.Frame.Visible = true
                    for ax, ay in next, GetChildren(aq) do
                        if ay.ClassName ~= "UIListLayout" and ay.ClassName ~= "UIPadding" then
                            ay:Destroy()
                        end
                    end

                    if aw and next(aw) ~= nil then
                        for az, aA in next, aw do
                            local aB = an.Icons.Tab
                            local aC =
                                CreateSearchTab(
                                aA.Title,
                                nil,
                                aB,
                                aq,
                                true,
                                function()
                                    an:Close()
                                    ak:SelectTab(az)
                                end
                            )
                            if aA.Elements and next(aA.Elements) ~= nil then
                                for aD, aE in next, aA.Elements do
                                    local aF = an.Icons[aE.__type]
                                    CreateSearchTab(
                                        aE.Title,
                                        aE.Desc,
                                        aF,
                                        aC:FindFirstChild "ParentContainer" and aC.ParentContainer.Frame or nil,
                                        false,
                                        function()
                                            an:Close()
                                            ak:SelectTab(az)
                                            if aA.Tab.ScrollToTheElement then
                                                aA.Tab:ScrollToTheElement(aE.Index)
                                            end
                                        end
                                    )
                                end
                            end
                        end
                    elseif av ~= "" then
                        ah(
                            "TextLabel",
                            {
                                Size = Dim2(1, 0, 0, 70),
                                BackgroundTransparency = 1,
                                Text = "No results found",
                                TextSize = 16,
                                ThemeTag = {
                                    TextColor3 = "Text"
                                },
                                TextTransparency = .2,
                                BackgroundTransparency = 1,
                                FontFace = Fnew(af.Font, Enum.FontWeight.Medium),
                                Parent = aq,
                                Name = "NotFound"
                            }
                        )
                    else
                        aq.Visible = false
                        ar.Frame.Results.Frame.Visible = false
                    end
                end

                af.AddSignal(PropChangeSignal(ao, "Text"), function()
                    an:Search(ao.Text);
                end); af.AddSignal(PropChangeSignal(aq.UIListLayout, "AbsoluteContentSize"), function()
                    TwCreate(TweenService, aq, TwInfo(0.06, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
                        Size = Dim2(1, 0,  0, math.clamp(aq.UIListLayout.AbsoluteContentSize.Y + (an.Padding * 2), 0, an.MaxHeight))
                    }):Play();
                end); function an.Open(au)
                    tk.spawn(function()
                        ar.Frame.Visible = true; as.Visible = true;
                        TwCreate(TweenService, as.UIScale, TwInfo(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play();
                    end);
                end; function an.Close(au)
                    tk.spawn(function()
                        am(); ar.Frame.Visible = false;
                        TwCreate(TweenService, as.UIScale, TwInfo(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play();
                        twait(0.12); as.Visible = false;
                    end);
                end; af.AddSignal(ap.TextButton.MouseButton1Click, function()
                    an:Close()
                end); an:Open(); return an;
            end; return ae;
        end
        function a.Y()
            local af = workspace.CurrentCamera

            local ah = a.load "q"

            local aj = a.load "b"
            local ak = aj.New
            local al = aj.Tween

            local am = a.load "t".New
            local an = a.load "j".New
            local ao = a.load "u".New
            local ap = a.load "v"

            local aq = a.load "w"

            return function(ar)
                local as = {
                    Title = ar.Title or "TTJY Hub",
                    Author = ar.Author,
                    Icon = ar.Icon,
                    IconSize = ar.IconSize or 22,
                    IconThemed = ar.IconThemed,
                    Folder = ar.Folder,
                    Resizable = ar.Resizable ~= false,
                    Background = ar.Background,
                    BackgroundImageTransparency = ar.BackgroundImageTransparency or 0,
                    ShadowTransparency = ar.ShadowTransparency or 0.7,
                    User = ar.User or {},
                    Footer = ar.Footer or {},
                    Topbar = ar.Topbar or {Height = 52, ButtonsType = "Default"},
                    Size = ar.Size,
                    MinSize = ar.MinSize or Vec2(560, 350),
                    MaxSize = ar.MaxSize or Vec2(850, 560),
                    TopBarButtonIconSize = ar.TopBarButtonIconSize or 16,
                    ToggleKey = ar.ToggleKey,
                    ElementsRadius = ar.ElementsRadius,
                    Radius = ar.Radius or 16,
                    Transparent = ar.Transparent or false,
                    HideSearchBar = ar.HideSearchBar ~= false,
                    ScrollBarEnabled = ar.ScrollBarEnabled or false,
                    SideBarWidth = ar.SideBarWidth or 200,
                    Acrylic = ar.Acrylic or false,
                    NewElements = ar.NewElements or false,
                    IgnoreAlerts = ar.IgnoreAlerts or false,
                    HidePanelBackground = ar.HidePanelBackground or false,
                    AutoScale = ar.AutoScale ~= false,
                    OpenButton = ar.OpenButton,
                    Position = DIM05,
                    UICorner = nil,
                    UIPadding = 14,
                    UIElements = {},
                    CanDropdown = true,
                    Closed = false,
                    Parent = ar.Parent,
                    Destroyed = false,
                    IsFullscreen = false,
                    CanResize = ar.Resizable ~= false,
                    IsOpenButtonEnabled = true,
                    CurrentConfig = nil,
                    ConfigManager = nil,
                    AcrylicPaint = nil,
                    CurrentTab = nil,
                    TabModule = nil,
                    OnOpenCallback = nil,
                    OnCloseCallback = nil,
                    OnDestroyCallback = nil,
                    IsPC = false,
                    Gap = 5,
                    TopBarButtons = {},
                    AllElements = {},
                    ElementConfig = {},
                    PendingFlags = {},
                    IsToggleDragging = false
                }

                as.UICorner = as.Radius

                as.ElementConfig = {
                    UIPadding = (as.NewElements and 10 or 13),
                    UICorner = as.ElementsRadius or (as.NewElements and 23 or 12)
                }

                local au = as.Size or Dim2(0, 580, 0, 460)
                as.Size =
                    Dim2(
                    au.X.Scale,
                    math.clamp(au.X.Offset, as.MinSize.X, as.MaxSize.X),
                    au.Y.Scale,
                    math.clamp(au.Y.Offset, as.MinSize.Y, as.MaxSize.Y)
                )

                if as.Topbar == {} then
                    as.Topbar = {Height = 52, ButtonsType = "Default"}
                end

                if as.Folder then
                    if not isfolder("WindUI/" .. as.Folder) then
                        makefolder("WindUI/" .. as.Folder)
                    end
                    if not isfolder("WindUI/" .. as.Folder .. "/assets") then
                        makefolder("WindUI/" .. as.Folder .. "/assets")
                    end
                    if not isfolder(as.Folder) then
                        makefolder(as.Folder)
                    end
                    if not isfolder(as.Folder .. "/assets") then
                        makefolder(as.Folder .. "/assets")
                    end
                end

                local av =
                    ak(
                    "UICorner",
                    {
                        CornerRadius = Dim(0, as.UICorner)
                    }
                )

                if as.Folder then
                    as.ConfigManager = aq:Init(as)
                end

                if as.Acrylic then
                    local aw, ax = ah.AcrylicPaint {UseAcrylic = as.Acrylic}

                    as.AcrylicPaint = aw
                end

                local aw =
                    ak(
                    "Frame",
                    {
                        Size = Dim2(0, 32, 0, 32),
                        Position = DIM1010,
                        AnchorPoint = Vec2(.5, .5),
                        BackgroundTransparency = 1,
                        ZIndex = 99,
                        Active = true
                    },
                    {
                        ak(
                            "ImageLabel",
                            {
                                Size = Dim2(0, 96, 0, 96),
                                BackgroundTransparency = 1,
                                Image = (LoaderSettings.ScaryAC and "") or "rbxassetid://120997033468887",
                                Position = Dim2(0.5, -16, 0.5, -16),
                                AnchorPoint = VEC05,
                                ImageTransparency = 1
                            }
                        )
                    }
                )
                local ax =
                    aj.NewRoundFrame(
                    as.UICorner,
                    "Squircle",
                    {
                        Size = DIM1010,
                        ImageTransparency = 1,
                        ImageColor3 = BLACK,
                        ZIndex = 98,
                        Active = false
                    },
                    {
                        ak(
                            "ImageLabel",
                            {
                                Size = Dim2(0, 70, 0, 70),
                                Image = aj.Icon "expand"[1],
                                ImageRectOffset = aj.Icon "expand"[2].ImageRectPosition,
                                ImageRectSize = aj.Icon "expand"[2].ImageRectSize,
                                BackgroundTransparency = 1,
                                Position = DIM05,
                                AnchorPoint = VEC05,
                                ImageTransparency = 1
                            }
                        )
                    }
                )

                local ay =
                    aj.NewRoundFrame(
                    as.UICorner,
                    "Squircle",
                    {
                        Size = DIM1010,
                        ImageTransparency = 1,
                        ImageColor3 = BLACK,
                        ZIndex = 999,
                        Active = false
                    }
                )

                as.UIElements.SideBar =
                    ak(
                    "ScrollingFrame",
                    {
                        Size = Dim2(
                            1,
                            as.ScrollBarEnabled and -3 - (as.UIPadding / 2) or 0,
                            1,
                            not as.HideSearchBar and -45 or 0
                        ),
                        Position = DIM0010,
                        AnchorPoint = Vec2(0, 1),
                        BackgroundTransparency = 1,
                        ScrollBarThickness = 0,
                        ElasticBehavior = "Never",
                        CanvasSize = DIM0000,
                        AutomaticCanvasSize = "Y",
                        ScrollingDirection = "Y",
                        ClipsDescendants = true,
                        VerticalScrollBarPosition = "Left"
                    },
                    {
                        ak(
                            "Frame",
                            {
                                BackgroundTransparency = 1,
                                AutomaticSize = "Y",
                                Size = Dim2(1, 0, 0, 0),
                                Name = "Frame"
                            },
                            {
                                ak(
                                    "UIPadding",
                                    {
                                        PaddingBottom = Dim(0, as.UIPadding / 2)
                                    }
                                ),
                                ak(
                                    "UIListLayout",
                                    {
                                        SortOrder = "LayoutOrder",
                                        Padding = Dim(0, as.Gap)
                                    }
                                )
                            }
                        ),
                        ak(
                            "UIPadding",
                            {
                                PaddingLeft = Dim(0, as.UIPadding / 2),
                                PaddingRight = Dim(0, as.UIPadding / 2)
                            }
                        )
                    }
                )

                as.UIElements.SideBarContainer =
                    ak(
                    "Frame",
                    {
                        Size = Dim2(
                            0,
                            as.SideBarWidth,
                            1,
                            as.User.Enabled and -as.Topbar.Height - 42 - (as.UIPadding * 2) or -as.Topbar.Height
                        ),
                        Position = Dim2(0, 0, 0, as.Topbar.Height),
                        BackgroundTransparency = 1,
                        Visible = true
                    },
                    {
                        ak(
                            "Frame",
                            {
                                Name = "Content",
                                BackgroundTransparency = 1,
                                Size = Dim2(1, 0, 1, not as.HideSearchBar and -45 - as.UIPadding / 2 or 0),
                                Position = DIM0010,
                                AnchorPoint = Vec2(0, 1)
                            }
                        ),
                        as.UIElements.SideBar
                    }
                )

                if as.ScrollBarEnabled then
                    ao(as.UIElements.SideBar, as.UIElements.SideBarContainer.Content, as, 3)
                end

                as.UIElements.MainBar =
                    ak(
                    "Frame",
                    {
                        Size = Dim2(1, -as.UIElements.SideBarContainer.AbsoluteSize.X, 1, -as.Topbar.Height),
                        Position = DIM1010,
                        AnchorPoint = Vec2(1, 1),
                        BackgroundTransparency = 1
                    },
                    {
                        aj.NewRoundFrame(
                            as.UICorner - (as.UIPadding / 2),
                            "Squircle",
                            {
                                Size = DIM1010,
                                ImageColor3 = WHITE,
                                ZIndex = 3,
                                ImageTransparency = 1,
                                Name = "Background",
                                Visible = not as.HidePanelBackground
                            }
                        ),
                        ak(
                            "UIPadding",
                            {
                                PaddingLeft = Dim(0, as.UIPadding / 2),
                                PaddingRight = Dim(0, as.UIPadding / 2),
                                PaddingBottom = Dim(0, as.UIPadding / 2)
                            }
                        )
                    }
                )

                local az =
                    ak(
                    "ImageLabel",
                    {
                        Image = (LoaderSettings.ScaryAC and "") or "rbxassetid://8992230677",
                        ThemeTag = {
                            ImageColor3 = "WindowShadow"
                        },
                        ImageTransparency = 1,
                        Size = Dim2(1, 120, 1, 116),
                        Position = Dim2(0, -60, 0, -58),
                        ScaleType = "Slice",
                        SliceCenter = Rectn(99, 99, 99, 99),
                        BackgroundTransparency = 1,
                        ZIndex = -999999999999999,
                        Name = "Blur"
                    }
                )

                if UIS.TouchEnabled and not UIS.KeyboardEnabled then
                    as.IsPC = false
                elseif UIS.KeyboardEnabled then
                    as.IsPC = true
                else
                    as.IsPC = nil
                end

                local aA
                if as.User then
                    local function GetUserThumb()
                        local aB, aC = Players:GetUserThumbnailAsync(
                            as.User.Anonymous and 1 or selff.UserId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size420x420
                        )
                        return aB
                    end

                    aA =
                        ak(
                        "TextButton",
                        {
                            Size = Dim2(
                                0,
                                (as.UIElements.SideBarContainer.AbsoluteSize.X) - (as.UIPadding / 2),
                                0,
                                42 + (as.UIPadding)
                            ),
                            Position = Dim2(0, as.UIPadding / 2, 1, -(as.UIPadding / 2)),
                            AnchorPoint = Vec2(0, 1),
                            BackgroundTransparency = 1,
                            Visible = as.User.Enabled or false
                        },
                        {
                            aj.NewRoundFrame(
                                as.UICorner - (as.UIPadding / 2),
                                "SquircleOutline",
                                {
                                    Size = DIM1010,
                                    ThemeTag = {
                                        ImageColor3 = "Text"
                                    },
                                    ImageTransparency = 1,
                                    Name = "Outline"
                                },
                                {
                                    ak(
                                        "UIGradient",
                                        {
                                            Rotation = 78,
                                            Color = CSnew {
                                                CSKnew(0.0, WHITE),
                                                CSKnew(0.5, WHITE),
                                                CSKnew(1.0, WHITE)
                                            },
                                            Transparency = NSnew {
                                                NSKnew(0.0, 0.1),
                                                NSKnew(0.5, 1),
                                                NSKnew(1.0, 0.1)
                                            }
                                        }
                                    )
                                }
                            ),
                            aj.NewRoundFrame(
                                as.UICorner - (as.UIPadding / 2),
                                "Squircle",
                                {
                                    Size = DIM1010,
                                    ThemeTag = {
                                        ImageColor3 = "Text"
                                    },
                                    ImageTransparency = 1,
                                    Name = "UserIcon"
                                },
                                {
                                    ak(
                                        "ImageLabel",
                                        {
                                            Image = GetUserThumb(),
                                            BackgroundTransparency = 1,
                                            Size = Dim2(0, 42, 0, 42),
                                            ThemeTag = {
                                                BackgroundColor3 = "Text"
                                            },
                                            BackgroundTransparency = .93
                                        },
                                        {
                                            ak(
                                                "UICorner",
                                                {
                                                    CornerRadius = Dim(1, 0)
                                                }
                                            )
                                        }
                                    ),
                                    ak(
                                        "Frame",
                                        {
                                            AutomaticSize = "XY",
                                            BackgroundTransparency = 1
                                        },
                                        {
                                            ak(
                                                "TextLabel",
                                                {
                                                    Text = as.User.Anonymous and "Anonymous" or
                                                        game.Players.LocalPlayer.DisplayName,
                                                    TextSize = 17,
                                                    ThemeTag = {
                                                        TextColor3 = "Text"
                                                    },
                                                    FontFace = Fnew(aj.Font, Enum.FontWeight.SemiBold),
                                                    AutomaticSize = "Y",
                                                    BackgroundTransparency = 1,
                                                    Size = Dim2(1, -27, 0, 0),
                                                    TextTruncate = "AtEnd",
                                                    TextXAlignment = "Left",
                                                    Name = "DisplayName"
                                                }
                                            ),
                                            ak(
                                                "TextLabel",
                                                {
                                                    Text = as.User.Anonymous and "anonymous" or
                                                        game.Players.LocalPlayer.Name,
                                                    TextSize = 15,
                                                    TextTransparency = .6,
                                                    ThemeTag = {
                                                        TextColor3 = "Text"
                                                    },
                                                    FontFace = Fnew(aj.Font, Enum.FontWeight.Medium),
                                                    AutomaticSize = "Y",
                                                    BackgroundTransparency = 1,
                                                    Size = Dim2(1, -27, 0, 0),
                                                    TextTruncate = "AtEnd",
                                                    TextXAlignment = "Left",
                                                    Name = "UserName"
                                                }
                                            ),
                                            ak(
                                                "UIListLayout",
                                                {
                                                    Padding = Dim(0, 4),
                                                    HorizontalAlignment = "Left"
                                                }
                                            )
                                        }
                                    ),
                                    ak(
                                        "UIListLayout",
                                        {
                                            Padding = Dim(0, as.UIPadding),
                                            FillDirection = "Horizontal",
                                            VerticalAlignment = "Center"
                                        }
                                    ),
                                    ak(
                                        "UIPadding",
                                        {
                                            PaddingLeft = Dim(0, as.UIPadding / 2),
                                            PaddingRight = Dim(0, as.UIPadding / 2)
                                        }
                                    )
                                }
                            )
                        }
                    )

                    function as.User.Enable(aB)
                        as.User.Enabled = true
                        al(
                            as.UIElements.SideBarContainer,
                            .25,
                            {Size = Dim2(0, as.SideBarWidth, 1, -as.Topbar.Height - 42 - (as.UIPadding * 2))},
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        aA.Visible = true
                    end
                    function as.User.Disable(aB)
                        as.User.Enabled = false
                        TwCreate(TweenService, as.UIElements.SideBarContainer, TWI_Q_025,
                            {Size = Dim2(0, as.SideBarWidth, 1, -as.Topbar.Height)}
                        ):Play();
                        aA.Visible = false;
                    end;
                    function as.User.SetAnonymous(aB, aC)
                        if aC ~= false then
                            aC = true
                        end
                        as.User.Anonymous = aC
                        aA.UserIcon.ImageLabel.Image = GetUserThumb()
                        aA.UserIcon.Frame.DisplayName.Text = aC and "Anonymous" or selff.DisplayName
                        aA.UserIcon.Frame.UserName.Text = aC and "anonymous" or selff.Name
                    end

                    if as.User.Enabled then
                        as.User:Enable()
                    else
                        as.User:Disable()
                    end

                    if as.User.Callback then
                        aj.AddSignal(
                            aA.MouseButton1Click,
                            function()
                                as.User.Callback()
                            end
                        )
                        aj.AddSignal(
                            aA.MouseEnter,
                            function()
                                al(aA.UserIcon, 0.04, {ImageTransparency = .95}):Play()
                                al(aA.Outline, 0.04, {ImageTransparency = .85}):Play()
                            end
                        )
                        aj.AddSignal(
                            aA.InputEnded,
                            function()
                                al(aA.UserIcon, 0.04, {ImageTransparency = 1}):Play()
                                al(aA.Outline, 0.04, {ImageTransparency = 1}):Play()
                            end
                        )
                    end
                end

                local aB
                local aC

                local aD = false
                local aE

                local aF = typeof(as.Background) == "string" and str.match(as.Background, "^video:(.+)") or nil
                local b =
                    typeof(as.Background) == "string" and not aF and str.match(as.Background, "^https?://.+") or nil

                local function GetImageExtension(d)
                    local f = d:match "%.(%w+)$" or d:match "%.(%w+)%?"
                    if f then
                        f = f:lower()
                        if f == "jpg" or f == "jpeg" or f == "png" or f == "webp" then
                            return "." .. f
                        end
                    end
                    return ".png"
                end

                if typeof(as.Background) == "string" and aF then
                    aD = true

                    if str.find(aF, "http") then
                        local d = as.Folder .. "/assets/." .. aj.SanitizeFilename(aF) .. ".webm"
                        if not isfile(d) then
                            local f, g =
                                pcall(
                                function()
                                    local f = Request {Url = aF, Method = "GET", Headers = {["User-Agent"] = "Roblox/Exploit"}}
                                    writefile(d, f.Body)
                                end
                            )
                            if not f then
                                warn("[ WindUI.Window.Background ] Failed to download video: " .. tostring(g))
                                return
                            end
                        end

                        local f, g =
                            pcall(
                            function()
                                return getcustomasset(d)
                            end
                        )
                        if not f then
                            warn("[ WindUI.Window.Background ] Failed to load custom asset: " .. tostring(g))
                            return
                        end
                        warn "[ WindUI.Window.Background ] VideoFrame may not work with custom video"
                        aF = g
                    end

                    aE =
                        ak(
                        "VideoFrame",
                        {
                            BackgroundTransparency = 1,
                            Size = DIM1010,
                            Video = aF,
                            Looped = true,
                            Volume = 0
                        },
                        {
                            ak(
                                "UICorner",
                                {
                                    CornerRadius = Dim(0, as.UICorner)
                                }
                            )
                        }
                    )
                    aE:Play()
                elseif b then
                    local d = as.Folder .. "/assets/." .. aj.SanitizeFilename(b) .. GetImageExtension(b)
                    if not isfile(d) then
                        local f, g =
                            pcall(
                            function()
                                local f = Request {Url = b, Method = "GET", Headers = {["User-Agent"] = "Roblox/Exploit"}}
                                writefile(d, f.Body)
                            end
                        )
                        if not f then
                            warn("[ Window.Background ] Failed to download image: " .. tostring(g))
                            return
                        end
                    end

                    local f, g =
                        pcall(
                        function()
                            return getcustomasset(d)
                        end
                    )
                    if not f then
                        warn("[ Window.Background ] Failed to load custom asset: " .. tostring(g))
                        return
                    end

                    aE =
                        ak(
                        "ImageLabel",
                        {
                            BackgroundTransparency = 1,
                            Size = DIM1010,
                            Image = g,
                            ImageTransparency = 0,
                            ScaleType = "Crop"
                        },
                        {
                            ak(
                                "UICorner",
                                {
                                    CornerRadius = Dim(0, as.UICorner)
                                }
                            )
                        }
                    )
                elseif as.Background then
                    aE =
                        ak(
                        "ImageLabel",
                        {
                            BackgroundTransparency = 1,
                            Size = DIM1010,
                            Image = typeof(as.Background) == "string" and as.Background or "",
                            ImageTransparency = 1,
                            ScaleType = "Crop"
                        },
                        {
                            ak(
                                "UICorner",
                                {
                                    CornerRadius = Dim(0, as.UICorner)
                                }
                            )
                        }
                    )
                end

                local d =
                    aj.NewRoundFrame(
                    99,
                    "Squircle",
                    {
                        ImageTransparency = .8,
                        ImageColor3 = WHITE,
                        Size = Dim2(0, 0, 0, 4),
                        Position = Dim2(0.5, 0, 1, 4),
                        AnchorPoint = Vec2(0.5, 0)
                    },
                    {
                        ak(
                            "TextButton",
                            {
                                Size = Dim2(1, 12, 1, 12),
                                BackgroundTransparency = 1,
                                Position = DIM05,
                                AnchorPoint = VEC05,
                                Active = true,
                                ZIndex = 99,
                                Name = "Frame"
                            }
                        )
                    }
                )

                function createAuthor(f)
                    return ak(
                        "TextLabel",
                        {
                            Text = f,
                            FontFace = Fnew(aj.Font, Enum.FontWeight.Medium),
                            BackgroundTransparency = 1,
                            TextTransparency = 0.35,
                            AutomaticSize = "XY",
                            Parent = as.UIElements.Main and as.UIElements.Main.Main.Topbar.Left.Title,
                            TextXAlignment = "Left",
                            TextSize = 13,
                            LayoutOrder = 2,
                            ThemeTag = {
                                TextColor3 = "WindowTopbarAuthor"
                            },
                            Name = "Author"
                        }
                    )
                end

                local f
                local g

                if as.Author then
                    f = createAuthor(as.Author)
                end

                local h =
                    ak(
                    "TextLabel",
                    {
                        Text = as.Title,
                        FontFace = Fnew(aj.Font, Enum.FontWeight.SemiBold),
                        BackgroundTransparency = 1,
                        AutomaticSize = "X",
                        Name = "Title",
                        TextXAlignment = "Center",
                        Size = Dim2(1,0,1,0),
                        TextSize = 20,
                        ThemeTag = {
                            TextColor3 = "WindowTopbarTitle"
                        }
                    }
                )

                as.UIElements.Main =
                    ak(
                    "Frame",
                    {
                        Size = as.Size,
                        Position = as.Position,
                        BackgroundTransparency = 1,
                        Parent = ar.Parent,
                        AnchorPoint = VEC05,
                        Active = true
                    },
                    {
                        ar.WindUI.UIScaleObj,
                        as.AcrylicPaint and as.AcrylicPaint.Frame or nil,
                        az,
                        aj.NewRoundFrame(
                            as.UICorner,
                            "Squircle",
                            {
                                ImageTransparency = 1,
                                Size = Dim2(1, 0, 1, -240),
                                AnchorPoint = VEC05,
                                Position = DIM05,
                                Name = "Background",
                                ThemeTag = {
                                    ImageColor3 = "WindowBackground"
                                }
                            },
                            {
                                aE,
                                d,
                                aw
                            }
                        ),
                        UIStroke,
                        av,
                        ax,
                        ay,
                        ak(
                            "Frame",
                            {
                                Size = DIM1010,
                                BackgroundTransparency = 1,
                                Name = "Main",
                                Visible = false,
                                ZIndex = 97
                            },
                            {
                                ak(
                                    "UICorner",
                                    {
                                        CornerRadius = Dim(0, as.UICorner)
                                    }
                                ),
                                as.UIElements.SideBarContainer,
                                as.UIElements.MainBar,
                                aA,
                                aC,
                                ak(
                                    "Frame",
                                    {
                                        Size = Dim2(1, 0, 0, as.Topbar.Height),
                                        BackgroundTransparency = 1,
                                        BackgroundColor3 = fromRGB(50, 50, 50),
                                        Name = "Topbar"
                                    },
                                    {
                                        aB,
                                        ak(
                                            "Frame",
                                            {
                                                AutomaticSize = "X",
                                                Size = DIM0010,
                                                BackgroundTransparency = 1,
                                                Name = "Left"
                                            },
                                            {
                                                ak(
                                                    "UIListLayout",
                                                    {
                                                        Padding = Dim(0, as.UIPadding + 4),
                                                        SortOrder = "LayoutOrder",
                                                        FillDirection = "Horizontal",
                                                        VerticalAlignment = "Center"
                                                    }
                                                ),
                                                ak(
                                                    "Frame",
                                                    {
                                                        AutomaticSize = "XY",
                                                        BackgroundTransparency = 1,
                                                        Name = "Title",
                                                        Size = DIM0010,
                                                        LayoutOrder = 2
                                                    },
                                                    {
                                                        ak(
                                                            "UIListLayout",
                                                            {
                                                                Padding = Dim(0, 0),
                                                                SortOrder = "LayoutOrder",
                                                                FillDirection = "Vertical",
                                                                VerticalAlignment = "Center"
                                                            }
                                                        ),
                                                        h,
                                                        f
                                                    }
                                                ),
                                                ak(
                                                    "UIPadding",
                                                    {
                                                        PaddingLeft = Dim(0, 4)
                                                    }
                                                )
                                            }
                                        ),
                                        ak(
                                            "ScrollingFrame",
                                            {
                                                Name = "Center",
                                                BackgroundTransparency = 1,
                                                AutomaticSize = "Y",
                                                ScrollBarThickness = 0,
                                                ScrollingDirection = "X",
                                                AutomaticCanvasSize = "X",
                                                CanvasSize = DIM0000,
                                                Size = DIM0010,
                                                AnchorPoint = Vec2(0, 0.5),
                                                Position = Dim2(0, 0, 0.5, 0),
                                                Visible = false
                                            },
                                            {
                                                ak(
                                                    "UIListLayout",
                                                    {
                                                        FillDirection = "Horizontal",
                                                        VerticalAlignment = "Center",
                                                        HorizontalAlignment = "Left",
                                                        Padding = Dim(0, as.UIPadding / 2)
                                                    }
                                                )
                                            }
                                        ),
                                        ak(
                                            "Frame",
                                            {
                                                AutomaticSize = "XY",
                                                BackgroundTransparency = 1,
                                                Position = Dim2(
                                                    as.Topbar.ButtonsType == "Default" and 1 or 0,
                                                    0,
                                                    0.5,
                                                    0
                                                ),
                                                AnchorPoint = Vec2(
                                                    as.Topbar.ButtonsType == "Default" and 1 or 0,
                                                    0.5
                                                ),
                                                Name = "Right"
                                            },
                                            {
                                                ak(
                                                    "UIListLayout",
                                                    {
                                                        Padding = Dim(0, as.Topbar.ButtonsType == "Default" and 9 or 0),
                                                        FillDirection = "Horizontal",
                                                        SortOrder = "LayoutOrder"
                                                    }
                                                )
                                            }
                                        ),
                                        ak(
                                            "UIPadding",
                                            {
                                                PaddingTop = Dim(0, as.UIPadding),
                                                PaddingLeft = Dim(
                                                    0,
                                                    as.Topbar.ButtonsType == "Default" and as.UIPadding or as.UIPadding - 2
                                                ),
                                                PaddingRight = Dim(0, 8),
                                                PaddingBottom = Dim(0, as.UIPadding)
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
                
                as.UIElements.Main.Main.Topbar.UIPadding:Destroy()
                as.UIElements.Main.Main.Topbar.Left.Size = Dim2(1,0,1,0);
                as.UIElements.Main.Main.Topbar.Left.AnchorPoint = Vec2(0.5,0.5);
                as.UIElements.Main.Main.Topbar.Left.Position = Dim2(0.5,0,0.5,0);
                as.UIElements.Main.Main.Topbar.Left.UIListLayout:Destroy();
                as.UIElements.Main.Main.Topbar.Left.Title.Position = Dim2(0.5,0,0,0);
                as.UIElements.Main.Main.Topbar.Left.Title.AnchorPoint = Vec2(0.5,0);
                as.UIElements.Main.Main.Topbar.Right.Position = Dim2(1, -90, 0.5, 0);

                aj.AddSignal(
                    as.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal "AbsoluteSize",
                    function()
                        local j = 0
                        local l =
                            as.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X / ar.WindUI.UIScale

                        j = as.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / ar.WindUI.UIScale
                        if as.Topbar.ButtonsType ~= "Default" then
                            j = j + l + as.UIPadding - 4
                        end

                        as.UIElements.Main.Main.Topbar.Center.Position =
                            Dim2(0, j + (as.UIPadding / ar.WindUI.UIScale), 0.5, 0)
                        as.UIElements.Main.Main.Topbar.Center.Size =
                            Dim2(1, -j - l - ((as.UIPadding * 2) / ar.WindUI.UIScale), 1, 0)
                    end
                )

                --[[
                if as.Topbar.ButtonsType ~= "Default" then
                    aj.AddSignal(
                        as.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal "AbsoluteSize",
                        function()
                            as.UIElements.Main.Main.Topbar.Left.Position =
                                Dim2(
                                0,
                                (as.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X / ar.WindUI.UIScale) + as.UIPadding - 4,
                                0,
                                0
                            )
                        end
                    )
                end
                --]]

                function as.CreateTopbarButton(j, l, m, p, r, u, v)
                    local x =
                        aj.Image(
                        m,
                        m,
                        0,
                        as.Folder,
                        "WindowTopbarIcon",
                        as.Topbar.ButtonsType == "Default" and true or false,
                        u,
                        "WindowTopbarButtonIcon"
                    )
                    x.Size =
                        as.Topbar.ButtonsType == "Default" and
                        Dim2(0, as.TopBarButtonIconSize, 0, as.TopBarButtonIconSize) or
                        DIM0000
                    x.AnchorPoint = VEC05
                    x.Position = DIM05
                    x.ImageLabel.ImageTransparency = as.Topbar.ButtonsType == "Default" and 0 or 1
                    if as.Topbar.ButtonsType ~= "Default" then
                        x.ImageLabel.ImageColor3 = aj.GetTextColorForHSB(v)
                    end

                    local B =
                        aj.NewRoundFrame(
                        as.Topbar.ButtonsType == "Default" and as.UICorner - (as.UIPadding / 2) or 999,
                        "Squircle",
                        {
                            Size = as.Topbar.ButtonsType == "Default" and
                                Dim2(0, as.Topbar.Height - 16, 0, as.Topbar.Height - 16) or
                                Dim2(0, 14, 0, 14),
                            LayoutOrder = r or 999,
                            Parent = as.Topbar.ButtonsType == "Default" and as.UIElements.Main.Main.Topbar.Right or nil,
                            ZIndex = 9999,
                            AnchorPoint = VEC05,
                            Position = DIM05,
                            ImageColor3 = as.Topbar.ButtonsType ~= "Default" and (v or fromHex "#ff3030") or nil,
                            ThemeTag = as.Topbar.ButtonsType == "Default" and
                                {
                                    ImageColor3 = "Text"
                                } or
                                nil,
                            ImageTransparency = as.Topbar.ButtonsType == "Default" and 1 or 0
                        },
                        {
                            aj.NewRoundFrame(
                                as.Topbar.ButtonsType == "Default" and as.UICorner - (as.UIPadding / 2) or 999,
                                "SquircleOutline",
                                {
                                    Size = DIM1010,
                                    ThemeTag = {
                                        ImageColor3 = "Black"
                                    },
                                    ImageTransparency = as.Topbar.ButtonsType == "Default" and 1 or .8,
                                    Name = "Outline"
                                },
                                {
                                    as.Topbar.ButtonsType == "Default" and
                                        ak(
                                            "UIGradient",
                                            {
                                                Rotation = 45,
                                                Color = CSnew {
                                                    CSKnew(0.0, WHITE),
                                                    CSKnew(0.5, WHITE),
                                                    CSKnew(1.0, WHITE)
                                                },
                                                Transparency = NSnew {
                                                    NSKnew(0.0, 0.1),
                                                    NSKnew(0.5, 1),
                                                    NSKnew(1.0, 0.1)
                                                }
                                            }
                                        ) or
                                        nil
                                }
                            ),
                            x
                        },
                        true
                    )

                    ak(
                        "Frame",
                        {
                            Size = Dim2(0, 24, 0, 24),
                            BackgroundTransparency = 1,
                            Parent = as.Topbar.ButtonsType ~= "Default" and as.UIElements.Main.Main.Topbar.Right or nil,
                            LayoutOrder = r or 999
                        },
                        {
                            as.Topbar.ButtonsType ~= "Default" and B or nil
                        }
                    )

                    as.TopBarButtons[100 - r] = {
                        Name = l,
                        Object = B
                    }

                    aj.AddSignal(
                        B.MouseButton1Click,
                        function()
                            p()
                        end
                    )
                    aj.AddSignal(B.MouseEnter, function()
                        if as.Topbar.ButtonsType == "Default" then
                            TwCreate(TweenService, B, TWI_015, {ImageTransparency = 0.93}):Play();
                            TwCreate(TweenService, B.Outline, TWI_015, {ImageTransparency = 0.75}):Play();
                        else
                            TwCreate(TweenService, x.ImageLabel, TWI_Q_01,
                                {ImageTransparency = 0}
                            ):Play(); TwCreate(TweenService, x, TWI_Q_01,
                                {Size = Dim2(0, 11, 0, 11)}
                            ):Play();
                        end;
                    end); aj.AddSignal(B.MouseLeave, function()
                        if as.Topbar.ButtonsType == "Default" then
                            TwCreate(TweenService, B, TWI_01, {ImageTransparency = 1}):Play();
                            TwCreate(TweenService, B.Outline, TWI_01, {ImageTransparency = 1}):Play();
                        else
                            TwCreate(TweenService,  x.ImageLabel, TWI_Q_01,
                                {ImageTransparency = 1}
                            ):Play(); TwCreate(TweenService, x, TWI_Q_01, {Size = DIM0000}):Play();
                        end;
                    end); return B;
                end; local j = aj.Drag( as.UIElements.Main, {as.UIElements.Main.Main.Topbar, d.Frame}, function(j, l)
                    if not as.Closed then
                        if j and l == d.Frame then
                            TwCreate(TweenService, d, TWI_01, {ImageTransparency = 0.35}):Play();
                        else
                            TwCreate(TweenService, d, TwInfo(0.2), {ImageTransparency = 0.8}):Play();
                        end; as.Position = as.UIElements.Main.Position; as.Dragging = j;
                    end;
                end); if not aD and as.Background and typeof(as.Background) == "table" then
                    local l = ak("UIGradient"); for m, p in next, as.Background do l[m] = p; end;
                    as.UIElements.BackgroundGradient = aj.NewRoundFrame(as.UICorner, "Squircle", {Size = DIM1010, Parent = as.UIElements.Main.Background, ImageTransparency = as.Transparent and ar.WindUI.TransparencyValue or 0 }, {l})
                end; as.OpenButtonMain = a.load("x").New(as);
                tk.spawn(function()
                    if as.Icon then
                        local l = ak("Frame", {Size = Dim2(0, 22, 0, 22),BackgroundTransparency = 1, Parent = as.UIElements.Main.Main.Topbar.Left});
                        g = aj.Image(as.Icon, as.Title, 0, as.Folder, "Window", true, as.IconThemed, "WindowTopbarIcon")
                        g.Parent = l g.Size = Dim2(0, as.IconSize, 0, as.IconSize)
                        g.Position = DIM05 g.AnchorPoint = VEC05
                        as.OpenButtonMain:SetIcon(as.Icon);
                    else
                        as.OpenButtonMain:SetIcon(as.Icon);
                    end;
                end); function as.SetToggleKey(l, m) as.ToggleKey = m; end;
                function as.SetTitle(l, m) as.Title = m; h.Text = m; end;
                function as.SetAuthor(l, m)
                    as.Author = m; if not f then
                        f = createAuthor(as.Author);
                    end; f.Text = m;
                end; function as.SetBackgroundImage(l, m)
                    as.UIElements.Main.Background.ImageLabel.Image = m;
                end; function as.SetBackgroundImageTransparency(l, m)
                    if aE and aE:IsA("ImageLabel") then
                        aE.ImageTransparency = math.floor(m * 10 + 0.5) / 10;
                    end; as.BackgroundImageTransparency = math.floor(m * 10 + 0.5) / 10;
                end; function as.SetBackgroundTransparency(l, m)
                    local p = math.floor(tonumber(m) * 10 + 0.5) / 10;
                    ar.WindUI.TransparencyValue = p;
                    as:ToggleTransparency(p > 0);
                end; local l, m = nil, nil;
                aj.Icon "minimize"; aj.Icon "maximize";
                as:CreateTopbarButton( "Fullscreen", "maximize", function()
                        as:ToggleFullscreen()
                    end, (as.Topbar.ButtonsType == "Default" and 998 or 999),
                    nil, fromHex"#60C762"
                ); function as.ToggleFullscreen(p)
                    local r = as.IsFullscreen; j:Set(r);
                    if not r then
                        l = as.UIElements.Main.Position;
                        m = as.UIElements.Main.Size;
                        as.CanResize = false;
                    else
                        if as.Resizable then
                            as.CanResize = true;
                        end;
                    end; TwCreate(TweenService, as.UIElements.Main, TWI_Q_045,
                        {Size = r and m or Dim2(1, -20, 1, -72)}
                    ):Play(); TwCreate(TweenService, as.UIElements.Main, TWI_Q_045,
                        {Position = r and l or Dim2(0.5, 0, 0.5, 26)}
                    ):Play(); as.IsFullscreen = not r;
                end; as:CreateTopbarButton("Minimize", "minus", function()
                        as:Close()
                    end, (as.Topbar.ButtonsType == "Default" and 997 or 998),
                    nil, fromHex "#F4C948"
                ); local clo = as.UIElements.Main.Main.Topbar.Right:Clone();
                clo.Frame:Destroy(); clo.Position = Dim2(0,10,0.5,0)
                clo.Parent = as.UIElements.Main.Main.Topbar;
                clo.Frame.ImageButton.Image = TTJYLogo;
                clo.Frame.ImageButton.ImageColor3 = fromRGB(255,255,255);
                clo.Frame.ImageButton.Size = Dim2(1.5,0,1.5,0);
                as.UIElements.SideBar.Parent.Name = "Sidebar";
                clo.Frame.ImageButton.Outline.ImageColor3 = fromRGB(255,255,255);
                local targetobj, info = clo.Frame.ImageButton.Outline, TwInfo(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local t1 = TwCreate(TweenService, targetobj, info, { ImageTransparency = 1 });
                local t0 = TwCreate(TweenService, targetobj, info, { ImageTransparency = 0 });
                tk.spawn(function()
                    while true do
                        t1:Play(); t1.Completed:Wait();
                        t0:Play(); t0.Completed:Wait();
                    end
                end);
                clo.Frame.ImageButton.MouseButton1Click:Connect(function()
                    if as.UIElements.SideBar.Parent.Visible then
                        as.UIElements.SideBar.Parent.Visible = false;
                        as.UIElements.Main.Main.Frame.Size = Dim2(1,0,1,-44);
                    else
                        as.UIElements.SideBar.Parent.Visible = true;
                        as.UIElements.Main.Main.Frame.Size = Dim2(1, -200, 1, -44);
                    end;
                end);

                function as.OnOpen(p, r)
                    as.OnOpenCallback = r
                end
                function as.OnClose(p, r)
                    as.OnCloseCallback = r
                end
                function as.OnDestroy(p, r)
                    as.OnDestroyCallback = r
                end

                if ar.WindUI.UseAcrylic then
                    as.AcrylicPaint.AddParent(as.UIElements.Main)
                end

                function as.SetIconSize(p, r)
                    local u
                    if typeof(r) == "number" then
                        u = Dim2(0, r, 0, r)
                        as.IconSize = r
                    elseif typeof(r) == "UDim2" then
                        u = r
                        as.IconSize = r.X.Offset
                    end

                    if g then
                        g.Size = u
                    end
                end

                function as.Open(p)
                    tk.spawn(
                        function()
                            if as.OnOpenCallback then
                                tk.spawn(
                                    function()
                                        aj.SafeCallback(as.OnOpenCallback)
                                    end
                                )
                            end

                            twait(.06)
                            as.Closed = false

                            if not FindFirstChild(as.UIElements.Main, "Background") then
                                return aj.DisconnectAll();
                            end;

                            TwCreate(TweenService, as.UIElements.Main.Background, TWI_Q_02,
                                {ImageTransparency = as.Transparent and ar.WindUI.TransparencyValue or 0}
                            ):Play();

                            if as.UIElements.BackgroundGradient then
                                TwCreate(TweenService, as.UIElements.BackgroundGradient, TWI_Q_02,
                                    {ImageTransparency = 0
                                }):Play()
                            end;

                            TwCreate(TweenService, as.UIElements.Main.Background, TwInfo(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                                {Size = DIM1010
                            }):Play();

                            if aE then
                                if aE:IsA("VideoFrame") then
                                    aE.Visible = true;
                                else
                                    TwCreate(TweenService, aE, TWI_Q_02,
                                        {ImageTransparency = as.BackgroundImageTransparency}
                                    ):Play();
                                end;
                            end;

                            if as.OpenButtonMain and as.IsOpenButtonEnabled then as.OpenButtonMain:Visible(false); end;
                            TwCreate(TweenService, az, TWI_Q_025,
                                {ImageTransparency = as.ShadowTransparency}
                            ):Play(); if UIStroke then
                                TwCreate(TweenService, UIStroke, TWI_Q_025,
                                    {Transparency = 0.8}
                                ):Play();
                            end; tk.spawn(function()
                                twait(0.3)
                                TwCreate(TweenService, d, TwInfo(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                                    {Size = Dim2(0, 200, 0, 4), ImageTransparency = 0.8}
                                ):Play(); j:Set(true); twait(.45);
                                if as.Resizable then
                                    TwCreate(TweenService, aw.ImageLabel, TwInfo(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                                        {ImageTransparency = 0.8}
                                    ):Play(); as.CanResize = true;
                                end;
                            end);

                            as.CanDropdown = true

                            as.UIElements.Main.Visible = true
                            tk.spawn(
                                function()
                                    twait(.05)
                                    as.UIElements.Main:WaitForChild "Main".Visible = true

                                    ar.WindUI:ToggleAcrylic(true)
                                end
                            )
                        end
                    )
                end
                function as.Close(p)
                    local r = {}

                    if as.OnCloseCallback then
                        tk.spawn(
                            function()
                                aj.SafeCallback(as.OnCloseCallback)
                            end
                        )
                    end

                    ar.WindUI:ToggleAcrylic(false)

                    as.UIElements.Main:WaitForChild "Main".Visible = false

                    as.CanDropdown = false; as.Closed = true;
                    TwCreate(TweenService, as.UIElements.Main.Background, TwInfo(0.32, Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),
                        {ImageTransparency = 1}
                    ):Play(); if as.UIElements.BackgroundGradient then
                        TwCreate(TweenService, as.UIElements.BackgroundGradient, TwInfo(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
                            {ImageTransparency = 1}
                        ):Play();
                    end; TwCreate(TweenService, as.UIElements.Main.Background, TwInfo(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
                        {Size = Dim2(1, 0, 1, -240)}
                    ):Play(); if aE then
                        if aE:IsA("VideoFrame") then
                            aE.Visible = false;
                        else
                            TwCreate(TweenService, aE, TwInfo(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                {ImageTransparency = 1}
                            ):Play();
                        end;
                    end; TwCreate(TweenService, az, TWI_Q_025, {ImageTransparency = 1}):Play();
                    if UIStroke then al(UIStroke, TWI_Q_025, {Transparency = 1}):Play(); end;
                    TwCreate(TweenService, d, TwInfo(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
                        {Size = Dim2(0, 0, 0, 4), ImageTransparency = 1}
                    ):Play(); TwCreate(TweenService, aw.ImageLabel, TwInfo(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
                    j:Set(false); as.CanResize = false;
                    tk.spawn(function()
                        twait(0.4); as.UIElements.Main.Visible = false;
                        if as.OpenButtonMain and not as.Destroyed and not as.IsPC and as.IsOpenButtonEnabled then
                            as.OpenButtonMain:Visible(true);
                        end;
                    end); function r.Destroy(u)
                        tk.spawn(function()
                            if as.OnDestroyCallback then
                                tk.spawn(function()
                                    aj.SafeCallback(as.OnDestroyCallback);
                                end);
                            end; if as.AcrylicPaint and as.AcrylicPaint.Model then
                                as.AcrylicPaint.Model:Destroy();
                            end; as.Destroyed = true; twait(0.4);
                            ar.WindUI.ScreenGui:Destroy();
                            ar.WindUI.NotificationGui:Destroy();
                            ar.WindUI.DropdownGui:Destroy()
                            ar.WindUI.TooltipGui:Destroy();
                            aj.DisconnectAll();
                            return;
                        end);
                    end; return r;
                end; function as.Destroy(p)
                    return as:Close():Destroy();
                end; function as.Toggle(p)
                    if as.Closed then
                        as:Open();
                    else
                        as:Close();
                    end;
                end; function as.ToggleTransparency(p, r)
                    as.Transparent = r; ar.WindUI.Transparent = r;
                    as.UIElements.Main.Background.ImageTransparency = r and ar.WindUI.TransparencyValue or 0;
                    as.UIElements.MainBar.Background.ImageTransparency = r and 0.97 or 0.95;
                end; function as.LockAll(p)
                    for r, u in next, as.AllElements do
                        if u.Lock then
                            u:Lock();
                        end;
                    end;
                end; function as.UnlockAll(p)
                    for r, u in next, as.AllElements do
                        if u.Unlock then
                            u:Unlock();
                        end;
                    end;
                end; function as.GetLocked(p)
                    local r = {}; for u, v in next, as.AllElements do
                        if v.Locked then
                            tble.insert(r, v);
                        end;
                    end; return r
                end; function as.GetUnlocked(p)
                    local r = {}; for u, v in next, as.AllElements do
                        if v.Locked == false then
                            tble.insert(r, v);
                        end;
                    end; return r;
                end; function as.GetUIScale(p, r)
                    return ar.WindUI.UIScale;
                end; function as.SetUIScale(p, r)
                    ar.WindUI.UIScale = r;
                    TwCreate(TweenService, ar.WindUI.UIScaleObj, TWI_Q_02, {Scale = r}):Play();
                    return as;
                end; function as.SetToTheCenter(p)
                    TwCreate(TweenService, as.UIElements.Main, TWI_Q_045,
                        {Position = DIM05}
                    ):Play(); return as;
                end; function as.SetCurrentConfig(p, r)
                    as.CurrentConfig = r;
                end; do
                    local p, r, u = 40, af.ViewportSize, as.UIElements.Main.AbsoluteSize;
                    if not as.IsFullscreen and as.AutoScale then
                        local v,x = r.X - (p * 2), r.Y - (p * 2);
                        local B,C = v / u.X, x / u.Y;
                        local F, G, H = math.min(B, C), 0.3, 1.0;
                        local J = math.clamp(F, G, H);
                        local L, M = as:GetUIScale() or 1, 0.05;
                        if math.abs(J - L) > M then
                            as:SetUIScale(J);
                        end;
                    end;
                end; if as.OpenButtonMain and as.OpenButtonMain.Button then
                    aj.AddSignal(as.OpenButtonMain.Button.TextButton.MouseButton1Click,	function()
                        as:Open();
                    end);
                end; aj.AddSignal(UIS.InputBegan, function(p, r)
                    if r or as.Destroyed then return; end; if as.ToggleKey then
                        if p.KeyCode == as.ToggleKey then
                            as:Toggle();
                        end;
                    end;
                end); tk.spawn(function()
                    as:Open();
                end); function as.EditOpenButton(p, r)
                    return as.OpenButtonMain:Edit(r);
                end; if as.OpenButton and typeof(as.OpenButton) == "table" then
                    as:EditOpenButton(as.OpenButton);
                end; local p = a.load "U"; local r = a.load "V";
                local u = p.Init(as, ar.WindUI, ar.WindUI.TooltipGui);
                u:OnChange(function(v)
                    as.CurrentTab = v;
                end); as.TabModule = p
                function as.Tab(v, x)
                    x.Parent = as.UIElements.SideBar.Frame
                    return u.New(x, ar.WindUI.UIScale);
                end; function as.SelectTab(v, x)
                    u:SelectTab(x);
                end; function as.Section(v, x)
                    return r.New(x, as.UIElements.SideBar.Frame, as.Folder, ar.WindUI.UIScale, as);
                end; function as.IsResizable(v, x)
                    as.Resizable = x;
                    as.CanResize = x;
                end; function as.Divider(v)
                    local x = ak("Frame",{
                        Size = Dim2(1, 0, 0, 1),
                        Position = Dim2(0.5, 0, 0, 0),
                        AnchorPoint = Vec2(0.5, 0),
                        BackgroundTransparency = .9,
                        ThemeTag = {
                            BackgroundColor3 = "Text"
                        }
                    }); local B = ak("Frame", {
                        Parent = as.UIElements.SideBar.Frame,
                        Size = Dim2(1, -7, 0, 5),
                        BackgroundTransparency = 1
                    }, {x}); return B
                end; local v = a.load "l".Init(as, nil);
                function as.Dialog(x, B)
                    local C, F = {
                        Title = B.Title or "Dialog",
                        Width = B.Width or 320,
                        Content = B.Content,
                        Buttons = B.Buttons or {},
                        TextPadding = 10
                    }, v.Create(false);
                    F.UIElements.Main.Size = Dim2(0, C.Width, 0, 0)
                    local G = ak( "Frame", {
                        Size = Dim2(1, 0, 0, 0),
                        AutomaticSize = "Y",
                        BackgroundTransparency = 1,
                        Parent = F.UIElements.Main
                    },{
                        ak("UIListLayout", {
                            FillDirection = "Horizontal",
                            Padding = Dim(0, F.UIPadding),
                            VerticalAlignment = "Center"
                        }), ak("UIPadding", {
                            PaddingTop = Dim(0, C.TextPadding / 2),
                            PaddingLeft = Dim(0, C.TextPadding / 2),
                            PaddingRight = Dim(0, C.TextPadding / 2)
                        });
                    }); local H = nil; if B.Icon then
                        H = aj.Image(B.Icon, C.Title .. ":" .. B.Icon, 0, as, "Dialog", true, B.IconThemed);
                        H.Size = Dim2(0, 22, 0, 22);
                        H.Parent = G;
                    end; F.UIElements.UIListLayout = ak("UIListLayout", {
                        Padding = Dim(0, 12),
                        FillDirection = "Vertical",
                        HorizontalAlignment = "Left",
                        Parent = F.UIElements.Main
                    }); ak("UISizeConstraint", {
                        MinSize = Vec2(180, 20),
                        MaxSize = Vec2(400, math.huge),
                        Parent = F.UIElements.Main
                    }); F.UIElements.Title = ak("TextLabel", {
                        Text = C.Title, TextSize = 20,
                        FontFace = Fnew(aj.Font, Enum.FontWeight.SemiBold),
                        TextXAlignment = "Left", TextWrapped = true, RichText = true,
                        Size = Dim2(1, H and -26 - F.UIPadding or 0, 0, 0),
                        AutomaticSize = "Y",
                        ThemeTag = {TextColor3 = "Text"},
                        BackgroundTransparency = 1,
                        Parent = G
                    }); if C.Content then
                        ak("TextLabel", {
                            Text = C.Content,
                            TextSize = 18,
                            TextTransparency = .4,
                            TextWrapped = true,
                            RichText = true,
                            FontFace = Fnew(aj.Font, Enum.FontWeight.Medium),
                            TextXAlignment = "Left",
                            Size = Dim2(1, 0, 0, 0),
                            AutomaticSize = "Y",
                            LayoutOrder = 2,
                            ThemeTag = {
                                TextColor3 = "Text"
                            },
                            BackgroundTransparency = 1,
                            Parent = F.UIElements.Main
                        }, {
                            ak("UIPadding", {
                                PaddingLeft = Dim(0, C.TextPadding / 2),
                                PaddingRight = Dim(0, C.TextPadding / 2),
                                PaddingBottom = Dim(0, C.TextPadding / 2)
                            });
                        });
                    end; local J = ak("UIListLayout", {
                        Padding = Dim(0, 6),
                        FillDirection = "Horizontal",
                        HorizontalAlignment = "Right"
                    }) local L = ak("Frame", {
                        Size = Dim2(1, 0, 0, 40),
                        AutomaticSize = "None",
                        BackgroundTransparency = 1,
                        Parent = F.UIElements.Main,
                        LayoutOrder = 4
                    }, {J}); local M = {} for N, O in next, C.Buttons do
                        local P = an(O.Title, O.Icon, O.Callback, O.Variant, L, F, false);
                        tble.insert(M, P);
                    end; local function CheckButtonsOverflow()
                        J.FillDirection = Enum.FillDirection.Horizontal;
                        J.HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        J.VerticalAlignment = Enum.VerticalAlignment.Center;
                        L.AutomaticSize = Enum.AutomaticSize.None;
                        for P, Q in ipairs(M) do
                            Q.Size = DIM0010;
                            Q.AutomaticSize = Enum.AutomaticSize.X;
                        end; twait();
                        local R,S = J.AbsoluteContentSize.X / ar.WindUI.UIScale, L.AbsoluteSize.X / ar.WindUI.UIScale;
                        if R > S then
                            J.FillDirection = Enum.FillDirection.Vertical;
                            J.HorizontalAlignment = Enum.HorizontalAlignment.Right;
                            J.VerticalAlignment = Enum.VerticalAlignment.Bottom;
                            L.AutomaticSize = Enum.AutomaticSize.Y;
                            for T, U in ipairs(M) do
                                U.Size = Dim2(1, 0, 0, 40);
                                U.AutomaticSize = Enum.AutomaticSize.None;
                            end;
                        else
                            local T = S - R; if T > 0 then
                                local U,V = nil, math.huge;
                                for W, X in ipairs(M) do
                                    local Y = X.AbsoluteSize.X / ar.WindUI.UIScale;
                                    if Y < V then V = Y; U = X; end;
                                end; if U then
                                    U.Size = Dim2(0, V + T, 1, 0);
                                    U.AutomaticSize = Enum.AutomaticSize.None;
                                end;
                            end;
                        end;
                    end; aj.AddSignal(PropChangeSignal(F.UIElements.Main, "AbsoluteSize"), CheckButtonsOverflow);
                    CheckButtonsOverflow(); twait(); F:Open();
                    return F;
                end; as:CreateTopbarButton("Close", "x", function()
                    if not as.IgnoreAlerts then
                        as:SetToTheCenter(); as:Dialog {
                            Title = "Close Window",
                            Content = "Do you want to close this window? You will not be able to open it again.",
                            Buttons = {
                                {
                                    Title = "Cancel",
                                    Callback = function()
                                    end,
                                    Variant = "Secondary"
                                },
                                {
                                    Title = "Close Window",
                                    Callback = function()
                                        as:Destroy()
                                    end,
                                    Variant = "Primary"
                                }
                            }
                        }
                    else
                        as:Destroy();
                    end;
                end, (as.Topbar.ButtonsType == "Default" and 999 or 997), nil, fromHex "#F4695F");
                function as.Tag(x, B)
                    if as.UIElements.Main.Main.Topbar.Center.Visible == false then
                        as.UIElements.Main.Main.Topbar.Center.Visible = true;
                    end;
                    return ap:New(B, as.UIElements.Main.Main.Topbar.Center);
                end; local function startResizing(x)
                    if as.CanResize then
                        isResizing = true; ax.Active = true; initialSize = as.UIElements.Main.Size; initialInputPosition = x.Position;
                        TwCreate(TweenService, aw.ImageLabel, TWI_01, {ImageTransparency = .35}):Play();
                        aj.AddSignal(x.Changed, function()
                            if x.UserInputState == Enum.UserInputState.End then
                                isResizing = false; ax.Active = false;
                                TwCreate(TweenService, aw.ImageLabel, TwInfo(0.17), {ImageTransparency = .8}):Play();
                            end;
                        end);
                    end;
                end; aj.AddSignal(aw.InputBegan, function(x)
                    if x.UserInputType == Enum.UserInputType.MouseButton1 or x.UserInputType == Enum.UserInputType.Touch then
                        if as.CanResize then startResizing(x); end;
                    end;
                end); aj.AddSignal(UIS.InputChanged, function(x)
                    if x.UserInputType == Enum.UserInputType.MouseMovement or x.UserInputType == Enum.UserInputType.Touch then
                        if isResizing and as.CanResize then
                            local B = x.Position - initialInputPosition;
                            local C = Dim2(0, initialSize.X.Offset + B.X * 2, 0, initialSize.Y.Offset + B.Y * 2);
                            C = Dim2(C.X.Scale, math.clamp(C.X.Offset, as.MinSize.X, as.MaxSize.X), C.Y.Scale, math.clamp(C.Y.Offset, as.MinSize.Y, as.MaxSize.Y));
                            as.UIElements.Main.Size = C; as.Size = C;
                        end;
                    end;
                end); local x, B, C, F = 0, 0.4, nil, 0;
                function onDoubleClick() as:SetToTheCenter(); end;
                d.Frame.MouseButton1Up:Connect(function()
                    local G, H = tick(), as.Position;
                    F = F + 1; if F == 1 then
                        x = G; C = H; tk.spawn(function()
                            twait(B); if F == 1 then
                                F = 0; C = nil;
                            end;
                        end);
                    elseif F == 2 then
                        if G - x <= B and H == C then
                            onDoubleClick();
                        end; F = 0; C = nil; x = 0;
                    else
                        F = 1; x = G; C = H;
                    end;
                end); if not as.HideSearchBar then
                    local G, H = a.load"X", nil;
                    local J = am("Search", "search", as.UIElements.SideBarContainer, true);
                    J.Size = Dim2(1, -as.UIPadding / 2, 0, 39); J.Position = Dim2(0, as.UIPadding / 2, 0, 0);
                    aj.AddSignal(J.MouseButton1Click, function()
                        if H then return; end;
                        G.new(as.TabModule, as.UIElements.Main, function()
                            H = false; if as.Resizable then as.CanResize = true; end;
                            TwCreate(TweenService, ay, TWI_01, {ImageTransparency = 1}):Play();
                            ay.Active = false;
                        end) TwCreate(TweenService, ay, TWI_01, {ImageTransparency = 0.65}):Play();
                        ay.Active = true; H = true; as.CanResize = false;
                    end);
                end; function as.DisableTopbarButtons(G, H)
                    for J, L in next, H do
                        for M, N in next, as.TopBarButtons do
                            if N.Name == L then
                                N.Object.Visible = false;
                            end;
                        end;
                    end;
                end; return as;
            end;
        end;
    end; local aa = {
        Window = nil,
        Theme = nil,
        Creator = a.load "b",
        LocalizationModule = a.load "c",
        NotificationModule = a.load "d",
        Themes = nil,
        Transparent = false,
        TransparencyValue = .15,
        UIScale = 1,
        ConfigManager = nil,
        Version = "0.0.0",
        OnThemeChangeFunction = nil,
        UIScaleObj = nil
    }; local al = HttpService:JSONDecode(a.load "i");
    if al then aa.Version = al.version; end;
    local an = aa.Services; local ar = a.load "q";
    local as = protectgui or (syn and syn.protect_gui) or function() end;
    local ao = aa.Creator; local ap = ao.New;
    local au = gethui and gethui() or (aj or PSG);
    local av = ap("UIScale", {Scale = aa.Scale});
    aa.UIScaleObj = av; aa.ScreenGui = ap("ScreenGui", {
        Name = "WindUI",
        Parent = nil,
        IgnoreGuiInset = true,
        ScreenInsets = "None"
    },{ap("Folder",{
        Name = "Window"
    }),
        ap("Folder", {
            Name = "KeySystem"
        }), ap("Folder", {
            Name = "Popups"
        }), ap("Folder", {
            Name = "ToolTips"
        });
    }); aa.NotificationGui = ap("ScreenGui", {
        Name = "WindUI/Notifications",
        Parent = au,
        DisplayOrder = 100,
        IgnoreGuiInset = true
    }); aa.DropdownGui = ap("ScreenGui", {
        Name = "WindUI/Dropdowns",
        Parent = au,
        DisplayOrder = 101,
        IgnoreGuiInset = true
    }); aa.TooltipGui = ap("ScreenGui", {
        Name = "WindUI/Tooltips",
        Parent = au,
        DisplayOrder = 102,
        IgnoreGuiInset = true
    }); as(aa.ScreenGui); as(aa.NotificationGui);
    as(aa.DropdownGui); as(aa.TooltipGui); ao.Init(aa);
    function aa.SetParent(aw, ax)
        aa.ScreenGui.Parent = ax;
        aa.NotificationGui.Parent = ax;
        aa.DropdownGui.Parent = ax;
    end; math.clamp(aa.TransparencyValue, 0, 1);
    local aw = aa.NotificationModule.Init(aa.NotificationGui);
    function aa.Notify(ax, ay)
        ay.Holder = aw.Frame; ay.Window = aa.Window;
        return aa.NotificationModule.New(ay);
    end; function aa.SetNotificationLower(ax, ay)
        aw.SetLower(ay);
    end; function aa.SetFont(ax, ay)
        ao.UpdateFont(ay);
    end; function aa.OnThemeChange(ax, ay)
        aa.OnThemeChangeFunction = ay;
    end; function aa.AddTheme(ax, ay)
        aa.Themes[ay.Name] = ay;
        return ay;
    end; function aa.SetTheme(ax, ay)
        if aa.Themes[ay] then
            aa.Theme = aa.Themes[ay]; ao.SetTheme(aa.Themes[ay]);
            if aa.OnThemeChangeFunction then aa.OnThemeChangeFunction(ay); end; 
            return aa.Themes[ay];
        end; return nil;
    end; function aa.GetThemes(ax)
        return aa.Themes;
    end; function aa.GetCurrentTheme(ax)
        return aa.Theme.Name;
    end; function aa.GetTransparency(ax)
        return aa.Transparent or false;
    end; function aa.GetWindowSize(ax)
        return Window.UIElements.Main.Size;
    end; function aa.Localization(ax, ay)
        return aa.LocalizationModule:New(ay, ao);
    end; function aa.SetLanguage(ax, ay)
        if ao.Localization then
            return ao.SetLanguage(ay);
        end;
        return false;
    end; function aa.ToggleAcrylic(ax, ay)
        if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
            aa.Window.Acrylic = ay; aa.Window.AcrylicPaint.Model.Transparency = ay and 0.99 or 1;
            if ay then ar.Enable(); else ar.Disable(); end;
        end;
    end; function aa.Gradient(ax, ay, az)
        local aA, aB = {}, {}; for aC, aD in next, ay do
            local aE = tonumber(aC); if aE then
                aE = math.clamp(aE / 100, 0, 1);
                tble.insert(aA, CSKnew(aE, aD.Color));
                tble.insert(aB, NSKnew(aE, aD.Transparency or 0));
            end;
        end; tble.sort(aA, function(aE, aF)
            return aE.Time < aF.Time;
        end); tble.sort(aB, function(aE, aF)
            return aE.Time < aF.Time;
        end); if #aA < 2 then
            error"ColorSequence requires at least 2 keypoints";
        end; local aE = {Color = CSnew(aA), Transparency = NSnew(aB)};
        if az then
            for aF, b in pairs(az) do
                aE[aF] = b;
            end;
        end; return aE;
    end; function aa.Popup(ax, ay)
        ay.WindUI = aa; return a.load("r").new(ay);
    end; aa.Themes = a.load "s"(aa);
    ao.Themes = aa.Themes; aa:SetTheme"Dark"; aa:SetLanguage(ao.Language);
    function aa.CreateWindow(ax, ay)
        local az = a.load "Y"

        if not isfolder "WindUI" then
            makefolder "WindUI"
        end
        if ay.Folder then
            makefolder(ay.Folder)
        else
            makefolder(ay.Title)
        end

        GG.GlobalBinds = GlobalBinds;

        ay.WindUI = aa
        ay.Parent = aa.ScreenGui.Window

        if aa.Window then
            warn "You cannot create more than one window"
            return
        end

        local aA = true

        local aB = aa.Themes[ay.Theme or "Dark"]

        ao.SetTheme(aB)

        local aC = gethwid or function()
            return selff.UserId
        end

        local aD = aC()
        local aE = az(ay)

        aa.Transparent = ay.Transparent
        aa.Window = aE;

        if ay.Acrylic then
            ar.init()
        end

        aa.ScreenGui.Parent = au;

        return aE
    end
    function aa.FinishLoad()
        isFirstLoad = false;
    end;

    return aa
end;
AssetStorage.IntroLib = function()
    local TJYsEula = {TopLeftTUT = false}; if isfile(EULBASE) then
        local decoded = HttpService:JSONDecode(readfile(EULBASE));
        for k, v in pairs(decoded) do
            TJYsEula[k] = v;
        end;
    end; local function SaveEula()
        writefile(EULBASE, HttpService:JSONEncode(TJYsEula));
    end; local function StackPop(wind, tutorials, index)
        index = index or 1; if index > #tutorials then return; end;
        local tut = tutorials[index]; 
        if type(tut) ~= "table" or not tut.Key then
            return StackPop(wind, tutorials, index + 1);
        end; if not TJYsEula[tut.Key] then
            wind:Popup({
                Title = tut.Title,
                Icon = tut.Icon,
                Content = tut.Content,
                Buttons = {
                    {Title = "Okay", Variant = "Tertiary", Callback = function() 
                        StackPop(wind, tutorials, index + 1);
                    end},
                    {Title = "Don't show again", Variant = "Tertiary", Callback = function()
                        TJYsEula[tut.Key] = true;
                        SaveEula();
                        StackPop(wind, tutorials, index + 1);
                    end},
                };
            });
        else
            StackPop(wind, tutorials, index + 1);
        end;
    end; return {
        Tutorial = function(self, wind)
            local tutorialList = {
                {
                    Key = "TopLeftTUT",
                    Title = "<font color='rgb(255, 255, 0)'>WARNING</font>",
                    Icon = "circle-alert",
                    Content = "You can click the button on top, left of this Window to hide tabs."
                },
                (GameId == 1235188606 and {
                    Key = "DragonADVGuide",
                    Title = "<font color='rgb(255, 0, 0)'>Security</font>",
                    Icon = "circle-alert",
                    Content = "You are using a newer version of the script which mean there will no 'Auto Roaming' or alternative name is 'Auto Load in-game data model'. Which mean you must head to 'Core Settings' tab, scroll down, and click 'Roam Initilization' OR enable 'Auto Roam Initilization' in order to make the script working correctly. Thank you."
                }),
                (GameId == 2294168059 and {
                    Key = "TheMimicGuild",
                    Title = "<font color='rgb(255, 0, 0)'>Security</font>",
                    Icon = "circle-alert",
                    Content = "This game has multiple anti cheat, make sure to check tutorial video so you don't get kick or any further punishment form this game."
                }) or {},
                (PlaceId == 6243699076 and {
                    Key = "TheMimicLobbyGuild",
                    Title = "<font color='rgb(255, 255, 0)'>Tutorial</font>",
                    Icon = "circle-alert",
                    Content = "You are currently in lobby, join a chapter to see all features from this script."
                }) or {},
                (PlaceId == 128715637193371 and {
                    Key = "TheMimicHOF",
                    Title = "<font color='rgb(255, 0, 0)'>HALL OF FAME</font>",
                    Icon = "circle-alert",
                    Content = "Script passed RSA Simulation Test which mean it is undetected. So, do not use other script while in HOF except TTJY Studio. The punishment including <font color='rgb(255, 255, 0)'>bans, lantern removal</font> are after event ended so you won't know if you just got detected or not."
                }) or {},
            }; StackPop(wind, tutorialList, 1);
        end,
        Init = function(wind, tab)
            tab:Paragraph({Title="Announcement", Desc="Updated: [FPS] OneTap V3.03 is now out!", Color="Green"});
            tab:Paragraph({Title="Announcement", Desc="Updated: Streamer Mode is out! Check 'Core Settings'.", Color="Green"}); tab:Space();
            if not LoaderSettings.BadNetwork then
                local DiscordAPI = "https://discord.com/api/v10/invites/" .. "qeDJUKBX4K" .. "?with_counts=true&with_expiration=true";
                local Response = (function()
                    local res = nil; pcall(function()
                        res = HttpService:JSONDecode(Request({
                            Url = DiscordAPI,
                            Method = "GET",
                            Headers = { ["Accept"] = "application/json" }
                        }).Body);
                    end); return res or {};
                end)(); if Response and Response.guild then
                    local desc = ' <font color="#52525b">•</font> Member Count : ' .. tostring(Response.approximate_member_count) .. '\n <font color="#16a34a">•</font> Online Count : ' .. tostring(Response.approximate_presence_count);
                    local DiscordInfo = tab:Paragraph({Title = Response.guild.name, Desc = desc, Image = "TTJYStudio", ImageSize = 84}); tab:Button({
                        Title = "Update Info",
                        Callback = function()
                            if Response and Response.guild then
                                DiscordInfo:SetDesc(
                                    ' <font color="#52525b">•</font> Member Count : ' .. tostring(Response.approximate_member_count) ..
                                    '\n <font color="#16a34a">•</font> Online Count : ' .. tostring(Response.approximate_presence_count)
                                );
                            end;
                        end;
                    });
                else
                    tab:Paragraph({Title = "Error when receiving information about the Discord server", Desc = HttpService:JSONEncode(Response), Icon = "triangle-alert", Size = 26, Color = "Red"});
                end;
            end; tab:Space(); tab:Divider(); tab:Space();
            tab:Paragraph({Title="TTJY", Desc="The owner of TTJY Studio & Main Developer."});
            tab:Paragraph({Title="Wind UI", Desc="This script uses Wind UI Library created by Footagesus."});
            tab:Paragraph({Title="IB1", Desc="This script uses IB1 which is a private obfuscator made by dr_breen."});
            tab:Paragraph({Title="Auth3", Desc="This script uses Authentication3 as a private whitelist service."});
            tab:Paragraph({Title="Pelican Development", Desc="This script also use a public whitelist service made by Pelican Development."});
            tab:Paragraph({Title="Inject.today", Desc="This script is supported by Inject.today"});
        end,
    };
end;
AssetStorage.Windy = function()
    local NoConfigComponent, AttachedConfig = {
        "Divider", "Section", "Group", "Code",
        "Module", "Group", "Button"
    }, {}; return {
        AttachConfig = function(pt,rp)
            pt = rp .. "/" .. pt;
            if AttachedConfig[pt] then
                return AttachedConfig[pt];
            end; local Splited = str.split(pt,"/");
            local FullPath = GG.Configs;
            for i,v in pairs(Splited) do
                FullPath = FullPath[v];
                if FullPath == nil then
                    return nil;
                end;
            end; AttachedConfig[pt]=FullPath;
            return FullPath;
        end,
        CreateGroupComponent = function(self, tab, data, path)
            local maxdats, Group=#data, (tab.Group and tab:Group({}) or tab);
            for i,v in ipairs(data) do
                local modu = Group:Section({
                    Title = v.Title;
                    Opened = v.Open;
                    Box = true;
                }); if v.Global then
                    ScriptCache[v.Global] = modu;
                end; for _, v in ipairs(v.dat) do
                    if not tblef(NoConfigComponent, v.type) and v.Path ~= nil then
                        self.AttachConfig(v.Path, path);
                        local fullPath = path.."/"..v.Path;
                        local Splited = str.split(fullPath,"/");
                        local lastKey = Splited[#Splited];
                        local len = #Splited - 1;
                        v.Callback = v.Callback or function(state)
                            AttachedConfig[fullPath] = state;
                            local t = GG.Configs;
                            for i = 1, len do
                                t = t[ Splited[i] ];
                            end; t[lastKey] = state;
                        end;
                    end; if LoaderSettings.ThaiLanguage then
                        v.Title = v.TH1 or v.Title;
                        v.Desc = v.TH2 or v.Desc;
                    else
                        v.Title = v.EN or v.Title;
                        v.Desc = v.EN2 or v.Desc;
                    end; if v.type == "Group" then
                        self:CreateGroupComponent(modu, v.dats, path);
                    elseif v.type == "Toggle" then
                        local Bindable = v.Bindable;
                        v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or false);
                        v.PathName = v.Path and path.."/"..v.Path;
                        v.Bindable = (v.PathName and GG.BindConfigs[v.PathName] or nil) or v.Bindable;
                        ScriptCache[v.Global or "nil"] = modu:Toggle(v);
                        v.Bindable = Bindable;
                    elseif v.type == "Slider" then
                        v.Value.Default = v.Value.Default or (v.Path and AttachedConfig[path.."/"..v.Path] or 1);
                        ScriptCache[v.Global or "nil"] = modu:Slider(v);
                    elseif v.type == "Button" then
                        ScriptCache[v.Global or "nil"] = modu:Button(v);
                    elseif v.type == "Dropdown" then
                        v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                        if v.RECall then
                            local drp = modu:Dropdown(v);
                            v.RECall.Callback = function()
                                return drp:Refresh(v.RECall.RECall());
                            end; modu:Button(v.RECall);
                            ScriptCache[v.Global or "nil"] = drp;
                        else
                            ScriptCache[v.Global or "nil"] = modu:Dropdown(v);
                        end;
                    elseif v.type == "Keybind" then
                        v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                        ScriptCache[v.Global or "nil"] = modu:Keybind(v);
                    elseif v.type == "Input" then
                        v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                        ScriptCache[v.Global or "nil"] = modu:Input(v);
                    elseif v.type == "Colorpicker" then
                        v.Default = v.Default or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                        ScriptCache[v.Global or "nil"] = modu:Colorpicker(v);
                    else
                        modu[v.type](v);
                    end; if type(v.Value) ~= 'table' then
                        v.Value = nil;
                    else
                        v.Value.Default = nil;
                    end;
                end;
            end;
        end,
        CreateComponent = function(self, tab, data, path)
            if not tab then return; end;
            for i,v in ipairs(data) do
                if not tblef(NoConfigComponent, v.type) and v.Path ~= nil then
                    self.AttachConfig(v.Path, path);
                    local fullPath = path.."/"..v.Path;
                    local Splited = str.split(fullPath,"/");
                    local lastKey = Splited[#Splited];
                    local len = #Splited - 1;
                    v.Callback = v.Callback or function(state)
                        AttachedConfig[fullPath] = state;
                        local t = GG.Configs;
                        for i = 1, len do
                            t = t[ Splited[i] ];
                        end; t[lastKey] = state;
                    end;
                end; if LoaderSettings.ThaiLanguage then
                    v.Title = v.TH1 or v.Title;
                    v.Desc = v.TH2 or v.Desc;
                else
                    v.Title = v.EN or v.Title;
                    v.Desc = v.EN2 or v.Desc;
                end; if v.type == "Group" then
                    self:CreateGroupComponent(tab, v.dats, path);
                    continue;
                end; if v.type == "Toggle" then
                    local Bindable = v.Bindable;
                    v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or false);
                    v.PathName = v.Path and path.."/"..v.Path;
                    v.Bindable = (v.PathName and GG.BindConfigs[v.PathName] or nil) or v.Bindable;
                    ScriptCache[v.Global or "nil"] = tab:Toggle(v);
                    v.Bindable = Bindable;
                elseif v.type == "Slider" then
                    v.Value.Default = v.Value.Default or (v.Path and AttachedConfig[path.."/"..v.Path] or 1);
                    ScriptCache[v.Global or "nil"] = tab:Slider(v);
                elseif v.type == "Button" then
                    ScriptCache[v.Global or "nil"] = tab:Button(v);
                elseif v.type == "Dropdown" then
                    v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                    if v.RECall then
                        local drp = tab:Dropdown(v);
                        v.RECall.Callback = function()
                            return drp:Refresh(v.RECall.RECall());
                        end; tab:Button(v.RECall);
                        ScriptCache[v.Global or "nil"] = drp;
                    else
                        ScriptCache[v.Global or "nil"] = tab:Dropdown(v);
                    end;
                elseif v.type == "Keybind" then
                    v.Value = v.Value or (v.Path and AttachedConfig[path.."/"..v.Path] or nil);
                    ScriptCache[v.Global or "nil"] = tab:Keybind(v);
                else
                    ScriptCache[v.Global or "nil"] = tab[v.type](tab, v);
                end; if type(v.Value) == 'table' then
                    v.Value.Default = nil;
                else
                    v.Value = nil;
                end;
            end;
        end;
        CreateDynamic = function(self, wind, tabs, data)
            if not tabs or not data then return; end;
            local Tabs = data.Tabs or {}; for i=1, #Tabs do
                local TabInfo = Tabs[i]; if TabInfo.Tab then
                    local TComponent = TabInfo.Tab;
                    local Tab = wind:Tab(TComponent)
                    tabs[TComponent.at] = Tab;
                    self:CreateComponent(Tab, TabInfo.Data, TComponent.Path);
                end;
            end; return tabs;
        end;
    };
end;

------------- CorePackage -------------

local SCARYAC = {5995470825, 8795154789};
if tblef(SCARYAC, GameId) then
    LoaderSettings.ScaryAC = true;
end;

AssetStorage.CorePackage = function()
    local serialize = nil; serialize = function(tbl, indent)
        indent = indent or ""
        local result = "{\n"
        for k,v in pairs(tbl) do
            local key = (type(k) == "string") and strformat("[%q]", k) or "["..tostring(k).."]";
            if type(v) == "table" then
                result ..= indent.."    "..key.." = "..serialize(v, indent.."    ")..";\n";
            elseif type(v) == "string" then
                result ..= indent.."    "..key.." = "..strformat("%q", v)..";\n";
            else
                result ..= indent.."    "..key.." = "..tostring(v)..";\n";
            end;
        end; result ..= indent.."}";
        return result;
    end;

    local Version = {
        ["Paintings"] = {
            FileName = "Paintings.lua";
            Version = "TheMimicV3.Extra.Paintings";
            Target = "Paintings.lua";
        };
    };

    local WaitForChild = game.WaitForChild;
    local StreamerModeToggle = nil;
    local StreamerModeToggle2 = nil;
    local StreamerModeToggle3 = nil;

    tk.spawn(function()
        local PlayerList, TargetData = WaitForChild(CoreGui, "PlayerList", 9e9), {
            "OffsetFrame",
            "PlayerScrollList",
            "SizeOffsetFrame",
            "Column",
            "Body",
            "ScrollingFrameClippingFrame",
            "ScrollingFrame",
            "OffsetUndoFrame",
            "TeamList_Neutral"
        };

        local TARGETNAME = GG.MYDEVYES or "Protected";
        local STABLESIZE = Dim2(0, 30, 0, 30);
        local STABLESIZE2 = Dim(0, 7);
        local STABLESIZE3 = Dim(0, 5);

        local function SetUp(CHs)
            for _, name in ipairs(TargetData) do
                CHs = CHs and WaitForChild(CHs, name, 100);
                if not CHs then return; end;
            end

            CHs = WaitForChild(CHs, "PlayerEntry_" .. selff.UserId, 3);
            if not CHs then return; end;

            local NameFrame = WaitForChild(CHs, "PlayerEntryContentFrame", 3);
            NameFrame = NameFrame and WaitForChild(NameFrame, "OverlayFrame", 3);
            NameFrame = NameFrame and WaitForChild(NameFrame, "NameFrame", 3);

            local PlayerName = WaitForChild(NameFrame, "PlayerName", 3);
            PlayerName = PlayerName and WaitForChild(PlayerName, "PlayerName", 3);

            if PlayerName then
                local function UpdateName()
                    if LoaderSettings.StreamerMode then
                        if PlayerName.Text ~= TARGETNAME then
                            PlayerName.Text = TARGETNAME;
                        end;
                    end;
                end;

                PlayerName:GetPropertyChangedSignal("Text"):Connect(UpdateName);
                UpdateName();
            end; if not LoaderSettings.StreamerMode then return; end;

            local InitalPadding = WaitForChild(NameFrame, "InitalPadding", 3);
            local PlayerIcon = WaitForChild(NameFrame, "PlayerIcon", 3);
            local Layout = WaitForChild(NameFrame, "Layout", 3);

            if PlayerIcon and PlayerIcon.ClassName == "ImageLabel" then
                PlayerIcon.Image = TTJYLogo;
                PlayerIcon.Size = STABLESIZE;

                if InitalPadding then
                    InitalPadding.PaddingLeft = STABLESIZE2;
                end; if Layout then
                    Layout.Padding = STABLESIZE3;
                end;
            end;
        end;

        local function Refresh()
            local CHs = FindFirstChild(PlayerList, "Children")
            if CHs then SetUp(CHs); end;
        end; Refresh();

        PlayerList.ChildAdded:Connect(function(v)
            if v.Name == "Children" then
                task.defer(function()
                    SetUp(v);
                end);
            end;
        end); StreamerModeToggle = Refresh;
    end);
    tk.spawn(function()
        local PageView = CoreGui;
        for _, name in ipairs({
            "RobloxGui",
            "SettingsClippingShield",
            "SettingsShield",
            "MenuContainer",
            "Page",
            "PageViewClipper",
            "PageView",
            "PageViewInnerFrame"
        }) do
            PageView = PageView and WaitForChild(PageView, name, 9e9);
            if not PageView then return; end;
        end;

        local Page = PageView.Parent.Parent;
        local Players = WaitForChild(PageView, "Players", 9e9);
        if not Players then return; end;

        local function Refresh()
            if not LoaderSettings.StreamerMode then
                Page.Visible = true;
                return;
            end; if Players.Visible then
                Page.Visible = false;
            else
                Page.Visible = true;
            end;
        end;

        Players:GetPropertyChangedSignal("Visible"):Connect(Refresh);
        Refresh(); StreamerModeToggle3 = Refresh;
    end);
    tk.spawn(function()
        local PageView = CoreGui;
        local PageViewClipper = nil;

        for _, name in ipairs({
            "RobloxGui",
            "SettingsClippingShield",
            "SettingsShield",
            "MenuContainer",
            "Page",
            "PageViewClipper",
            "PageView",
            "PageViewInnerFrame"
        }) do
            PageView = PageView and WaitForChild(PageView, name, 9e9);
            if not PageView then return; end;
            if name == "PageViewClipper" then
                PageViewClipper = PageView;
            end;
        end;

        local peoplepage = WaitForChild(PageView, "peoplepage", 9e9)
        if not peoplepage then return; end;

        local function Refresh()
            if not LoaderSettings.StreamerMode then
                PageViewClipper.Visible = true;
                return;
            end; if peoplepage.Visible then
                PageViewClipper.Visible = false;
            end;
        end;

        peoplepage:GetPropertyChangedSignal("Visible"):Connect(Refresh);
        Refresh(); StreamerModeToggle2 = Refresh;
    end);

    local Data = {
        {type="Toggle", EN="Thai Language", EN2="ใช้ภาษาไทย (ต้องรันอีกรอบ แต่ปิดหน้านี้ก่อนนะ)", P="ThaiLanguage", Callback=function(state)
            LoaderSettings.ThaiLanguage = state;
        end}; {type = "Space"};
        {type="Toggle", EN="Streamer Mode", EN2="Hiding your name from CoreGuis", TH1="สตรีมเมอร์โหมด", TH2="ซ่อนชื่อจาก CoreGuis", P="StreamerMode", Callback=function(state)
            LoaderSettings.StreamerMode = state;
            if StreamerModeToggle then
                StreamerModeToggle();
            end; if StreamerModeToggle2 then
                StreamerModeToggle2();
            end; if StreamerModeToggle3 then
                StreamerModeToggle3();
            end;
        end};
        {type="Dropdown", EN="ESP Mode", EN2="Change the ESP mode globally.", TH1="โหมด ESP", TH2="เปลี่ยนโหมด ESP แบบglobal", P="ESPMode", Values={"Box", "Highlight", "2D"}, Callback=function(option)
            LoaderSettings.ESPMode = option; GG.ESPF_ChangeMode(option);
        end};
        {type="Slider", EN="FPS Cap", EN2="Change FPS capacity.", TH1="ปรับFPS", TH2="จำกัดจำนวน FPS", P="FPSCap", Value={Min=3, Max=250}, Callback=function(value)
            LoaderSettings.FPSCap = value; setfpscap(value);
        end};
        {type="Toggle", EN="Bad Network", EN2="Prevent UI Decorations from loading.", TH1="เน็ตไม่ดี", TH2="UI ไม่สวย", P="BadNetwork", Callback=function(state)
            LoaderSettings.BadNetwork = state;
        end};
        {type="Toggle", EN="Allow Cache", EN2="Allow script assets to be save in your workspace folder.", TH1="การใช้ข้อมูลเดิม", TH2="เซฟข้อมูลไว้ในworkspaceเพื่อการใช้งานครั้งถัดไป", P="AllowCache", Callback=function(state)
            LoaderSettings.AllowCache = state;
        end};
        {type="Toggle", EN="Skip Bypass", EN2="Skip the bypass process.", TH1="ไม่สนใจกันโปร", TH2="ข้ามการbypass", P="SkipBypass", Callback=function(state)
            LoaderSettings.SkipBypass = state;
        end};
        {type="Toggle", EN="Scary AntiCheat", EN2="Prevent UI Assets from loading, help bypass anti cheat.", TH1="กันโปรหนา", TH2="ปิดทรัพยากรทั้งหมดใน UI เพื่อไม่ให้โดนตรวจเจอ", P="ScaryAC", Callback=function(state)
            if tblef(SCARYAC, GameId) then return; end;
            LoaderSettings.ScaryAC = state;
        end}; {type = "Space"};
        {type="Keybind", EN="UI Toggle Key", EN2="Key to hide/show the menu.", TH1="ปุ่มเปิด/ปิดเมนู", TH2="ปุ่มสำหรับซ่อนหรือแสดงเมนู", P="UIKeybind", Callback=function(key)
            LoaderSettings.UIKeybind = key; if ScriptCache.Window and ScriptCache.Window.SetToggleKey then
                ScriptCache.Window:SetToggleKey(Enum.KeyCode[key] or Enum.KeyCode.RightShift);
            end
        end};
        {type="Toggle", EN="Allow Acrylic Blur", EN2="Allow Acrylic Blur to make the UI look better.", TH1="เปิดใช้งาน Acrylic Blur", TH2="ทำให้ UI ดูสวยขึ้น", P="AllowAcrylicBlur", Callback=function(state)
            LoaderSettings.AllowAcrylicBlur = state;
        end};
        {type="Toggle", EN="Allow Client Tab", EN2="Allow Client Tab in the UI.", TH1="เปิดใช้งานแท็บ: Client", TH2="แสดงแท็บ Client บน UI", P="AllowClientTab", Callback=function(state)
            LoaderSettings.AllowClientTab = state;
        end};
        {type="Toggle", EN="Allow AddOn Tab", EN2="Allow AddOn Tab in the UI.", TH1="เปิดใช้งานแท็บ: AddOn", TH2="แสดงแท็บ AddOn บน UI", P="AllowAddOn", Callback=function(state)
            LoaderSettings.AllowAddOn = state;
        end};
        {type="Toggle", EN="Allow Themes Tab", EN2="Allow Themes Tab in the UI.", TH1="เปิดใช้งานแท็บ: Themes", TH2="แสดงแท็บ Themes บน UI", P="AllowThemesTab", Callback=function(state)
            LoaderSettings.AllowThemesTab = state;
        end};
        {type="Toggle", EN="Allow ESP BHV", EN2="Allow ESP Customization Tab in the UI.", TH1="เปิดใช้งานแท็บ: ESP BHV", TH2="แสดงแท็บ ESP BHV", P="AllowESPCustomization", Callback=function(state)
            LoaderSettings.AllowESPCustomization = state;
        end}; {type="Space"};
        {type="Button", EN="Export Configs", EN2="Copy config to your clipboard", TH1="ส่งออก Config", TH2="คัดลอก Config", Callback=function()
            setc("getgenv().Configs = " .. serialize(GG.Configs));
        end};
        {type="Button", EN="Export Loader Settings", EN2="Copy loader settings to your clipboard", TH1="ส่งออก Loader Settings", TH2="คัดลอก Loader Settings", Callback=function()
            setc("getgenv().LoaderSettings = " .. serialize(GG.LoaderSettings));
        end};
        {type="Button", EN="Export Key-Binding", EN2="Copy Key-Binding to your clipboard", TH1="ส่งออก Key-Binding", TH2="คัดลอก Key-Binding", Callback=function()
            setc("getgenv().BindConfigs = " .. serialize(GG.BindConfigs));
        end};
    };

    if GameId == 2294168059 then
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Toggle", EN="Load Sections", EN2="Load all teleport locations instead of just an auto complete.", TH1="โหลดส่วนขยาย", TH2="จากปกติที่จะโหลดแค่ออโต้เล่น โหลดส่วนขยายจะโหลดจุดวาปด้วย", P="TheMimicLoader", P2="Load_Sections", Callback=function(state)
            LoaderSettings.TheMimicLoader.Load_Sections = state;
        end};
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Dropdown", EN="Installer", EN2="Select a package.", TH1="โหลดส่วนเสริม", TH2="เลือกสิ่งที่จะโหลด", Values={"Paintings", "MapComputing"}, P="TheMimicLoader", P2="Installer", Callback=function(value)
            LoaderSettings.TheMimicLoader.Installer = value;
        end};
        Data[#Data+1] = {type="Button", EN="Install", EN2="Download the package.", TH1="โหลด", TH2="โหลดส่วนเสริม", Callback=function(value)
            local DownloadHandler = GG.DownloadHandler; if DownloadHandler and not DownloadHandler.Download(true, LoaderSettings.TheMimicLoader.Installer) then
                ScriptCache.WindUI:Notify({
                    Title = "<font color='rgb(255,255,0)'>Installer [IMPORTANT]</font>",
                    Content = "Downloading assets.",
                    Icon = "circle-alert",
                    Duration = 11,
                }); DownloadHandler.Download(false, LoaderSettings.TheMimicLoader.Installer);
            else
                ScriptCache.WindUI:Notify({
                    Title = "<font color='rgb(0,255,0)'>Installer [IMPORTANT]</font>",
                    Content = "You already have the asset installed.",
                    Icon = "circle-alert",
                    Duration = 11,
                });
            end;
        end};
    elseif GameId == 1235188606 then
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Button", EN="Roam Initilization", EN2="This will teleport you to every chunk of the game and make it load all data.", TH1="โหลดข้อมูลเกม", TH2="จะวาปไปทุกๆส่วนของเกมและโหลดข้อมูลทั้งหมด", Callback=function()
            return GG.InitGameData();
        end};
        Data[#Data+1] = {type="Toggle", EN="Roam Init On StartUp", EN2="Automatically run Roam Initilization after execute.", TH1="ออโต้โหลดข้อมูลเกม", TH2="จะวาปไปทุกๆส่วนของเกมและโหลดข้อมูลทั้งหมดหลังรันสคริป", P="DragonAdventure", P2="RoamInitOnStartUp", Callback=function(state)
            LoaderSettings.DragonAdventure.RoamInitOnStartUp = state;
        end};
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Toggle", EN="Auto Join Private server", EN2="Give you free private server, this will auto join the private server after you teleport to other world that isn't lobby.", TH1="ออโต้เข้าPrivate server", TH2="จะวาปไป Private server ให้อัตโนมัติเมื่อไปยังแมพอื่นที่ไม่ใช่ล็อบบี้", P="DragonAdventure", P2="AutoJoinPrivateServer", Callback=function(state)
            LoaderSettings.DragonAdventure.AutoJoinPrivateServer = state;
        end};
        Data[#Data+1] = {type="Toggle", EN="Show All Features", EN2="Show multiple hidden feature on the UI that might be at risk or untested or it's not even detected but we just don't want anyone use.", TH1="แสดงทุกฟีเจอร์", TH2="จะแสดงฟีเจอร์ทั้งหมดบน UI อาจมีฟีเจอร์ที่ไม่เสี่ยงหรือยังไม่ทดสอบหรืออาจจะยังไม่ถูกตรวจจับแต่เราแค่ไม่ต้องการให้ใครใช้", P="DragonAdventure", P2="ShowAllFeatures", Callback=function(state)
            LoaderSettings.DragonAdventure.ShowAllFeatures = state;
            if state then
                if ScriptCache.InfBreath then
                    ScriptCache.InfBreath:Unlock();
                end;
            else
                if ScriptCache.InfBreath then
                    ScriptCache.InfBreath:Lock();
                end;
            end;
        end};
    elseif GameId == 10200395747 then
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Toggle", EN="Allow TP Bypass", EN2="Instant teleport; You need to have low ping or this won't work.", TH1="วาปทันที", TH2="เวลาฟาม เวลาขโมยจะวาปทันทีแต่ต้องเน็ตแรงๆ ปิงน้อยๆ", Callback=function(state)
            LoaderSettings.GAG2Loader.Allow_TPBypass = state;
        end};
    elseif GameId == 1831550657 then
        Data[#Data+1] = {type="Space"}; Data[#Data+1] = {type="Divider"}; Data[#Data+1] = {type="Space"};
        Data[#Data+1] = {type="Toggle", EN="Players Persistent", EN2="Keep all players loaded in memory, prevents them from unloading when you are far away.", TH1="โหลดข้อมูลผู้เล่นค้างไว้", TH2="โหลดข้อมูลผู้เล่นค้างไว้ ป้องกันไม่ให้มันหายไปเมื่อคุณอยู่ไกล", P="CreatureOfSonaria", P2="PlayersPersistent", Callback=function(state)
            LoaderSettings.CreatureOfSonaria.PlayersPersistent = state;
        end};
        Data[#Data+1] = {type="Toggle", EN="Foods Persistent", EN2="Keep all foods loaded in memory, prevents them from unloading when you are far away.", TH1="โหลดข้อมูลอาหารค้างไว้", TH2="โหลดข้อมูลอาหารค้างไว้ ป้องกันไม่ให้มันหายไปเมื่อคุณอยู่ไกล", P="CreatureOfSonaria", P2="FoodsPersistent", Callback=function(state)
            LoaderSettings.CreatureOfSonaria.FoodsPersistent = state;
        end};
        Data[#Data+1] = {type="Toggle", EN="NPCs Persistent", EN2="Keep all NPCs loaded in memory, prevents them from unloading when you are far away.", TH1="โหลดข้อมูล NPC ค้างไว้", TH2="โหลดข้อมูล NPC ค้างไว้ ป้องกันไม่ให้มันหายไปเมื่อคุณอยู่ไกล", P="CreatureOfSonaria", P2="NPCsPersistent", Callback=function(state)
            LoaderSettings.CreatureOfSonaria.NPCsPersistent = state;
        end};
    end;

    local Init = function()
        for i,v in pairs(Data) do
            if v.type == "Toggle" or v.type == "Keybind" or v.type == "Dropdown" then
                if v.P2 then
                    v.Value=LoaderSettings[v.P][v.P2];
                else
                    v.Value=LoaderSettings[v.P];
                end;
            elseif v.type == "Slider" then
                if v.P2 then
                    v.Value.Default = LoaderSettings[v.P][v.P2];
                else
                    v.Value.Default = LoaderSettings[v.P];
                end;
            end;
        end; return Data, Installer;
    end; return Init;
end;

AssetStorage.DownloadPackage = function()
    local Registry = {
        ["Paintings"] = {
            FileName = "Paintings.lua";
            Version = "TheMimicV3.Extra.Paintings";
            Target = "Paintings.lua";
        };
    };

    local DSignal = Signal.new();
    local Download = function(check, name)
        local TargetTBL = Registry[name]; if check then
            if not LoadFromVControl(
                ASSETBASE..TargetTBL.Target,
                TargetTBL.FileName,
                TargetTBL.Version,
                check
            ) then
                return false, WindUI:Notify({
                    Title = "<font color='rgb(255,255,0)'>Installer [IMPORTANT]</font>",
                    Content = name.."asset is missing. If you want to download it now, you can download it at 'Core Settings' tab.",
                    Icon = "circle-alert",
                    Duration = 11,
                });
            end; return true;
        end;
        
        DSignal:Fire(name, LoadFromVControl(
            ASSETBASE..TargetTBL.Target,
            TargetTBL.FileName,
            TargetTBL.Version
        )());
    end;

    return {
        Versions = Registry;
        Download = Download;
        Signal = DSignal;
    };
end;
AssetStorage.MacroFileSys = function()
    local MARCROBASE = FOLBASE.."/Macro";
    if not isfolder(FOLBASE) then
        makefolder(FOLBASE);
    end; if not isfolder(MARCROBASE) then
        makefolder(MARCROBASE);
    end;

    return {
        Init = function(self, where)
            if not isfolder(MARCROBASE.."/"..where) then
                makefolder(MARCROBASE.."/"..where);
            end; self.Branch = MARCROBASE.."/"..where.."/";
        end;
        Write = function(self, where, data)
            data = HttpService:JSONEncode(data);
            writefile(self.Branch .. where .. ".macro", data);
        end;
        List = function(self)
            local Files = listfiles(self.Branch);
            local Pures = {}; for i=1, #Files do
                tblein(Pures, str.sub(Files[i], #self.Branch+1));
            end; return Pures;
        end;
        Read = function(self, where)
            if not isfile(self.Branch..where) then
                return nil;
            end; return readfile(self.Branch..where);
        end;
    };
end;

------------- Source Loader -------------

local FreeLoad, KeyLoad = {
    [7597195391] = {
        File = "7597195391";
        Version = "RealUNISnapshot5";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "PromptPackage", "CoruTask"};
    };
    [9294074907] = {
        File = "9294074907";
        Version = "OneTapV3.03";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "PromptPackage", "DownloadPackage", "QueuePack", "CirclePackage"};
    };
    [5995470825] = {
        File = "5995470825";
        Version = "HyperSV3.06";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "PromptPackage", "DownloadPackage", "QueuePack", "CirclePackage"};
    };
    [6331902150] = {
        File = "6331902150";
        Version = "Forsaken_V3.01";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
}, {
    [1831550657] = {
        File = "1831550657";
        Version = "CoS_V3.06";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
    [1235188606] = {
        File = "1235188606";
        Version = "DA_V3.79";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
    [3647333358] = {
        File = "3647333358";
        Version = "Evade_V3.50";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
    [2294168059] = {
        File = "2294168059";
        Version = "TheMimicV3.D11";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "PromptPackage", "DownloadPackage", "QueuePack"};
    };
    [5527989791] = {
        File = "5527989791";
        Version = "TheMimicClassicV3.00";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "PromptPackage"};
    };
    [4760747038] = {
        File = "4760747038";
        Version = "WonderWhyV3.02";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "PromptPackage"};
    };
    [1176784616] = {
        File = "1176784616";
        Version = "TDS_V3.01";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage", "MacroFileSys"};
    };
    [6739698191] = {
        File = "6739698191";
        Version = "VD_V3.02";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
    [10512942223] = {
        File = "10512942223";
        Version = "AnimeZero_V3.01";
        Included = {"CorePackage", "LoadUILib", "IntroLib", "Windy", "ClientPackage", "CoruTask", "CommonF", "ESPPackage"};
    };
};

GG.LoadFromVControl = LoadFromVControl;
GG.LoaderSettings = LoaderSettings;
GG.ScriptCache = ScriptCache;

if (not LoaderSettings.SkipBypass) and not LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/APIs/MultiAC.cpp", "MultiAC.lua", "2023_ACI_2026_HyperNew")(selff, selc) then
    return selff:Kick("TTJY_IDAC");
end;

if GG.API_Only then return; end;

local Resolve = FreeLoad[GameId] and FreeLoad[GameId].File .. ".lua";
Resolve = Resolve or (KeyLoad[GameId] and KeyLoad[GameId].File .. ".lua");

local AutoInclude = function(Included)
    local tbl={}; for i, v in ipairs(Included) do
        if v == "LoadUILib" then
            tblein(tbl, i, AssetStorage[v]);
        else
            tblein(tbl, i, AssetStorage[v]());
            AssetStorage[v] = nil;
        end; continue;
    end; return unpack(tbl);
end;

if FreeLoad[GameId] then
    return LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/ListFile/" .. Resolve, Resolve, GG.CustomVersion or FreeLoad[GameId].Version)(AutoInclude(FreeLoad[GameId].Included))();
elseif KeyLoad[GameId] then
    return LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/APIs/K.oluac", "K.lua", "KAuth3.83")(GG.CustomVersion or KeyLoad[GameId].Version, AssetStorage.KeyPackage, AutoInclude(KeyLoad[GameId].Included))();
else
    return LoadFromVControl("https://raw.githubusercontent.com/RealTTJY/Studio.Hub/refs/heads/main/ListFile/7597195391.lua", "7597195391.lua", GG.CustomVersion or FreeLoad[7597195391].Version)(AutoInclude(FreeLoad[7597195391].Included))();
end;
