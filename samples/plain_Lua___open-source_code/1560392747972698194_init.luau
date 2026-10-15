
local Sealz = {};

local ClearDrawing = Drawing.clear or Drawing.Clear or cleardrawcache or cleardawcache or clear_draw_cache or function() end;
LICENSE_KEY = getgenv().script_key or script_key or getgenv().license or license or getgenv().LICENSE or LICENSE;

local SealzPDB = {
    [6739698191] = "ViolenceDistrict.luau",
	[994732206] = "BloxFruits.luau"
};

local FreeAccess = {
	[994732206] = true
};

local args = {...};
if args[1] then
    if not LICENSE_KEY and typeof(args[1]) == "string" then
        LICENSE_KEY = args[1];
    end;
end;

local ToHex = function(a)
    return a:gsub('.',function(d)
        return string.format("%02x",d:byte())
    end);
end;

ClearDrawing();

Sealz.cloneref = cloneref or function(f) return f end;
Sealz.get_service = function(name: string): ServiceProvider
	return Sealz.cloneref(game:GetService(name)) or Sealz.cloneref(game:FindFirstChild(name));
end;

local Players: Players = Sealz.get_service("Players");
local LocalPlayer: Player = Players.LocalPlayer;
local Mouse: Mouse = LocalPlayer:GetMouse();
local UserInputService: UserInputService = Sealz.get_service("UserInputService");
local Lighting: Lighting = Sealz.get_service("Lighting");
local RunService: RunService = Sealz.get_service("RunService");
local HttpService: HttpService = Sealz.get_service("HttpService");
local TweenService: TweenService = Sealz.get_service("TweenService");
local TextService: TextService = Sealz.get_service("TextService");
local CoreGui: PlayerGui = gethui and gethui() or Sealz.get_service("CoreGui") or LocalPlayer.PlayerGui;
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local CurrentCamera: Camera = Sealz.cloneref(workspace.CurrentCamera);
local Twnf = TweenInfo.new(0.45,Enum.EasingStyle.Quint);
local Smooth = TweenInfo.new(0.65,Enum.EasingStyle.Quint);

Sealz.MediumFont = Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Medium,Enum.FontStyle.Normal);
Sealz.BoldFont = Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal);

function Sealz:Tween(UI: Frame , Info: TweenInfo , Property: {[string]:any})
	local Tween = TweenService:Create(UI , Info or Twnf, Property);

	Tween:Play();

	return Tween;
end;

function Sealz:IsMouseOverFrame(UI: Frame)
	if not UI then
		return;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = UI.AbsolutePosition, UI.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

-- ref: https://reactbits.dev/components/border-glow
Sealz.BorderGlow = function(Frame: Frame , size: number)
	local EdgeGlowFrame = Instance.new("Frame")
	local UIShadow = Instance.new("UIShadow")
	local UIShadow_2 = Instance.new("UIShadow")
	local UIShadow_3 = Instance.new("UIShadow")
	local UIShadow_4 = Instance.new("UIShadow")

	EdgeGlowFrame.Name = "EdgeGlowFrame"
	EdgeGlowFrame.Parent = Frame
	EdgeGlowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	EdgeGlowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	EdgeGlowFrame.BackgroundTransparency = 1.000
	EdgeGlowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	EdgeGlowFrame.BorderSizePixel = 0
	EdgeGlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	EdgeGlowFrame.Size = UDim2.new(0, 0, 0, 0)
	EdgeGlowFrame.ZIndex = Frame.ZIndex

	UIShadow.BlurRadius = UDim.new(1, 0)
	UIShadow.Color = Color3.fromRGB(132, 252, 214)
	UIShadow.Offset = UDim2.new(0, 25, 0, 25)
	UIShadow.ZIndex = 1
	UIShadow.Transparency = 1
	UIShadow.Parent = EdgeGlowFrame

	UIShadow_2.BlurRadius = UDim.new(1, 0)
	UIShadow_2.Color = Color3.fromRGB(114, 207, 244)
	UIShadow_2.Offset = UDim2.new(0, 25, 0, -25)
	UIShadow_2.ZIndex = 1
	UIShadow_2.Transparency = 1
	UIShadow_2.Parent = EdgeGlowFrame

	UIShadow_3.BlurRadius = UDim.new(1, 0)
	UIShadow_3.Color = Color3.fromRGB(56, 78, 248)
	UIShadow_3.Offset = UDim2.new(0, -25, 0, -25)
	UIShadow_3.ZIndex = 1
	UIShadow_3.Transparency = 1
	UIShadow_3.Parent = EdgeGlowFrame

	UIShadow_4.BlurRadius = UDim.new(1, 0)
	UIShadow_4.Color = Color3.fromRGB(248, 248, 248)
	UIShadow_4.ZIndex = 2
	UIShadow_4.Transparency = 1
	UIShadow_4.Parent = EdgeGlowFrame
	
	local API = {};
	
	API.Runtime = task.spawn(function()
		local Outtime = tick();
		
		while true do task.wait()
			local Target = UDim2.fromOffset(Mouse.X - Frame.AbsolutePosition.X,Mouse.Y - Frame.AbsolutePosition.Y);
			
			if Sealz:IsMouseOverFrame(Frame) then
				API.set(true)
				EdgeGlowFrame.Rotation = Vector2.new(Mouse.X - Frame.AbsolutePosition.X,Mouse.Y - Frame.AbsolutePosition.Y).Magnitude;
				
				Sealz:Tween(EdgeGlowFrame,Twnf,{
					Position = Frame.Position:Lerp(Target,.9)
				});
				
				Outtime = tick()
			else
				if (tick() - Outtime) > 0.1 then
					API.set(false)
				end
			end
		end		
	end)
	
	function API.set(v)
		Sealz:Tween(EdgeGlowFrame,Smooth,{
			Size = v and UDim2.fromOffset(size,size) or UDim2.fromOffset(0,0)
		})
		
		Sealz:Tween(UIShadow,Smooth,{
			Transparency = v and 0 or 1
		})
		
		Sealz:Tween(UIShadow_2,Smooth,{
			Transparency = v and 0 or 1
		})
		
		Sealz:Tween(UIShadow_3,Smooth,{
			Transparency = v and 0 or 1
		})
		
		Sealz:Tween(UIShadow_4,Smooth,{
			Transparency = v and 0 or 1
		})
	end;
	
	function API:Destroy()
		task.cancel(API.Runtime);
		API.set(false);
		task.delay(0.2,function()
			EdgeGlowFrame:Destroy();
		end)
	end;
	
	return API;
end;

Sealz.Menu = function()
	local Window = {};
	Window.BorderGlow = {};
	
	local SealzUI = Instance.new("ScreenGui")

	SealzUI.Name = "Loader";
	SealzUI.Parent = CoreGui;
	SealzUI.ResetOnSpawn = false;
	SealzUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	SealzUI.IgnoreGuiInset = true;
    ProtectGui(SealzUI);

	Sealz.LoaderScreen = SealzUI;

	local OutlineFrame = Instance.new("Frame")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIShadow = Instance.new("UIShadow")
	local UIStroke = Instance.new("UIStroke")
	local HeaderFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UIShadow_2 = Instance.new("UIShadow")
	local LineFrame = Instance.new("Frame")
	local WindowLabel = Instance.new("TextLabel")
	local WindowSecondLabel = Instance.new("TextLabel")
	local InputFrame = Instance.new("Frame")
	local UIShadow_3 = Instance.new("UIShadow")
	local UICorner_3 = Instance.new("UICorner")
	local Frame = Instance.new("Frame")
	local TextBox = Instance.new("TextBox")
	local GetKeyFrame = Instance.new("Frame")
	local UIShadow_4 = Instance.new("UIShadow")
	local UICorner_4 = Instance.new("UICorner")
	local Frame_2 = Instance.new("Frame")
	local GetKeyButton = Instance.new("TextButton")
	local LoginFrame = Instance.new("Frame")
	local UIShadow_5 = Instance.new("UIShadow")
	local UICorner_5 = Instance.new("UICorner")
	local Frame_3 = Instance.new("Frame")
	local LoginButton = Instance.new("TextButton")
	local crLabel = Instance.new("TextLabel")
	local noteLabel = Instance.new("TextLabel")

	OutlineFrame.Name = "OutlineFrame"
	OutlineFrame.Parent = SealzUI
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	OutlineFrame.BackgroundTransparency = 1.000
	OutlineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OutlineFrame.BorderSizePixel = 0
	OutlineFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
	OutlineFrame.Size = UDim2.new(0, 0, 0, 0)
	
	Sealz:Tween(OutlineFrame,TweenInfo.new(1.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
		Size = UDim2.new(0, 300, 0, 170),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = OutlineFrame
	MainFrame.AnchorPoint = Vector2.new(1, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(1, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.ZIndex = 3

	UICorner.Parent = MainFrame

	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.500
	UIShadow.Parent = MainFrame

	UIStroke.Color = Color3.fromRGB(47, 47, 47)
	UIStroke.Parent = MainFrame

	HeaderFrame.Name = "HeaderFrame"
	HeaderFrame.Parent = MainFrame
	HeaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	HeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderFrame.BorderSizePixel = 0
	HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
	HeaderFrame.ZIndex = 4

	UICorner_2.BottomLeftRadius = UDim.new(0, 0)
	UICorner_2.BottomRightRadius = UDim.new(0, 0)
	UICorner_2.Parent = HeaderFrame

	UIShadow_2.BlurRadius = UDim.new(0, 20)
	UIShadow_2.Transparency = 0.750
	UIShadow_2.Parent = HeaderFrame

	LineFrame.Name = "LineFrame"
	LineFrame.Parent = HeaderFrame
	LineFrame.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, 0, 0, 1)
	LineFrame.ZIndex = 5

	WindowLabel.Name = "WindowLabel"
	WindowLabel.Parent = HeaderFrame
	WindowLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowLabel.BackgroundTransparency = 1.000
	WindowLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowLabel.BorderSizePixel = 0
	WindowLabel.Position = UDim2.new(0, 10, 0, 7)
	WindowLabel.Size = UDim2.new(0, 200, 0, 15)
	WindowLabel.ZIndex = 5
	WindowLabel.FontFace = Sealz.MediumFont
	WindowLabel.Text = "Sealz.lua"
	WindowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowLabel.TextSize = 14.000
	WindowLabel.TextXAlignment = Enum.TextXAlignment.Left

	WindowSecondLabel.Name = "WindowSecondLabel"
	WindowSecondLabel.Parent = HeaderFrame
	WindowSecondLabel.AnchorPoint = Vector2.new(0, 1)
	WindowSecondLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowSecondLabel.BackgroundTransparency = 1.000
	WindowSecondLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowSecondLabel.BorderSizePixel = 0
	WindowSecondLabel.Position = UDim2.new(0, 10, 1, -7)
	WindowSecondLabel.Size = UDim2.new(0, 200, 0, 11)
	WindowSecondLabel.ZIndex = 5
	WindowSecondLabel.FontFace = Sealz.MediumFont
	WindowSecondLabel.Text = "Loader"
	WindowSecondLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowSecondLabel.TextSize = 11.000
	WindowSecondLabel.TextTransparency = 0.200
	WindowSecondLabel.TextXAlignment = Enum.TextXAlignment.Left

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = MainFrame
	InputFrame.AnchorPoint = Vector2.new(0.5, 0)
	InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InputFrame.BorderSizePixel = 0
	InputFrame.ClipsDescendants = true
	InputFrame.Position = UDim2.new(0.5, 0, 0, 55)
	InputFrame.Size = UDim2.new(1, -25, 0, 35)
	InputFrame.ZIndex = 8
	
	table.insert(Window.BorderGlow , Sealz.BorderGlow(InputFrame,95))
	
	UIShadow_3.BlurRadius = UDim.new(0, 20)
	UIShadow_3.Transparency = 0.500
	UIShadow_3.Parent = InputFrame

	UICorner_3.TopLeftRadius = UDim.new(0, 6)
	UICorner_3.TopRightRadius = UDim.new(0, 6)
	UICorner_3.BottomLeftRadius = UDim.new(0, 6)
	UICorner_3.BottomRightRadius = UDim.new(0, 6)
	UICorner_3.Parent = InputFrame

	Frame.Parent = InputFrame
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(1, -2, 1, -2)
	Frame.ZIndex = 10

	TextBox.Parent = InputFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, -15, 1, -5)
	TextBox.ZIndex = 11
	TextBox.ClearTextOnFocus = false
	TextBox.FontFace = Sealz.BoldFont
	TextBox.PlaceholderText = "License Key"
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 11.000
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	GetKeyFrame.Name = "GetKeyFrame"
	GetKeyFrame.Parent = MainFrame
	GetKeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	GetKeyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetKeyFrame.BorderSizePixel = 0
	GetKeyFrame.ClipsDescendants = true
	GetKeyFrame.Position = UDim2.new(0, 13, 0, 95)
	GetKeyFrame.Size = UDim2.new(0, 135, 0, 35)
	GetKeyFrame.ZIndex = 8
	table.insert(Window.BorderGlow , Sealz.BorderGlow(GetKeyFrame,75))

	UIShadow_4.BlurRadius = UDim.new(0, 20)
	UIShadow_4.Transparency = 0.500
	UIShadow_4.Parent = GetKeyFrame

	UICorner_4.TopLeftRadius = UDim.new(0, 6)
	UICorner_4.TopRightRadius = UDim.new(0, 6)
	UICorner_4.BottomLeftRadius = UDim.new(0, 6)
	UICorner_4.BottomRightRadius = UDim.new(0, 6)
	UICorner_4.Parent = GetKeyFrame

	Frame_2.Parent = GetKeyFrame
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame_2.Size = UDim2.new(1, -2, 1, -2)
	Frame_2.ZIndex = 10

	GetKeyButton.Name = "GetKeyButton"
	GetKeyButton.Parent = GetKeyFrame
	GetKeyButton.AnchorPoint = Vector2.new(0.5, 0.5)
	GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GetKeyButton.BackgroundTransparency = 1.000
	GetKeyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetKeyButton.BorderSizePixel = 0
	GetKeyButton.ClipsDescendants = true
	GetKeyButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	GetKeyButton.Size = UDim2.new(1, -5, 1, -5)
	GetKeyButton.ZIndex = 11
	GetKeyButton.FontFace = Sealz.BoldFont
	GetKeyButton.Text = "Get Key"
	GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	GetKeyButton.TextSize = 14.000
	
	LoginFrame.Name = "LoginFrame"
	LoginFrame.Parent = MainFrame
	LoginFrame.AnchorPoint = Vector2.new(1, 0)
	LoginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	LoginFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LoginFrame.BorderSizePixel = 0
	LoginFrame.ClipsDescendants = true
	LoginFrame.Position = UDim2.new(1, -13, 0, 95)
	LoginFrame.Size = UDim2.new(0, 135, 0, 35)
	LoginFrame.ZIndex = 8
	table.insert(Window.BorderGlow , Sealz.BorderGlow(LoginFrame,75))

	UIShadow_5.BlurRadius = UDim.new(0, 20)
	UIShadow_5.Transparency = 0.500
	UIShadow_5.Parent = LoginFrame

	UICorner_5.TopLeftRadius = UDim.new(0, 6)
	UICorner_5.TopRightRadius = UDim.new(0, 6)
	UICorner_5.BottomLeftRadius = UDim.new(0, 6)
	UICorner_5.BottomRightRadius = UDim.new(0, 6)
	UICorner_5.Parent = LoginFrame

	Frame_3.Parent = LoginFrame
	Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_3.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_3.BorderSizePixel = 0
	Frame_3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame_3.Size = UDim2.new(1, -2, 1, -2)
	Frame_3.ZIndex = 10

	LoginButton.Name = "LoginButton"
	LoginButton.Parent = LoginFrame
	LoginButton.AnchorPoint = Vector2.new(0.5, 0.5)
	LoginButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoginButton.BackgroundTransparency = 1.000
	LoginButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LoginButton.BorderSizePixel = 0
	LoginButton.ClipsDescendants = true
	LoginButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoginButton.Size = UDim2.new(1, -5, 1, -5)
	LoginButton.ZIndex = 11
	LoginButton.FontFace = Sealz.BoldFont
	LoginButton.Text = "Login"
	LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	LoginButton.TextSize = 14.000

	crLabel.Name = "crLabel"
	crLabel.Parent = MainFrame
	crLabel.AnchorPoint = Vector2.new(0, 1)
	crLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	crLabel.BackgroundTransparency = 1.000
	crLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	crLabel.BorderSizePixel = 0
	crLabel.Position = UDim2.new(0, 10, 1, -7)
	crLabel.Size = UDim2.new(0, 200, 0, 11)
	crLabel.ZIndex = 5
	crLabel.FontFace = Sealz.MediumFont
	crLabel.Text = "Powered by Nexora.im"
	crLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	crLabel.TextSize = 11.000
	crLabel.TextTransparency = 0.200
	crLabel.TextXAlignment = Enum.TextXAlignment.Left

	noteLabel.Name = "noteLabel"
	noteLabel.Parent = MainFrame
	noteLabel.AnchorPoint = Vector2.new(0, 1)
	noteLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	noteLabel.BackgroundTransparency = 1.000
	noteLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	noteLabel.BorderSizePixel = 0
	noteLabel.Position = UDim2.new(0, 10, 1, -18)
	noteLabel.Size = UDim2.new(0, 200, 0, 11)
	noteLabel.ZIndex = 5
	noteLabel.FontFace = Sealz.MediumFont
	noteLabel.Text = tostring(SealzPDB[game.GameId])
	noteLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	noteLabel.TextSize = 11.000
	noteLabel.TextTransparency = 0.400
	noteLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	function Window:Destroy()
		for i,v in next , Window.BorderGlow do
			v:Destroy();
		end;
		
		Sealz:Tween(OutlineFrame,TweenInfo.new(2,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0.5,0,1.5,0)
		})
		
		task.delay(2,function()
			SealzUI:Destroy();
		end)
	end;
	
	Window.Input = TextBox;
	Window.GetKey = GetKeyButton;
	Window.Login = LoginButton;
	
	return Window;
end

local RbxAnalyticsService: RbxAnalyticsService = cloneref(game:GetService("RbxAnalyticsService"));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local EncodingService: EncodingService = cloneref(game:GetService('EncodingService'));
local StaticHWID = (gethwid and gethwid()) or RbxAnalyticsService:GetClientId();
local HWID = ToHex(EncodingService:ComputeStringHash(StaticHWID.."HWID_SEALZ", Enum.HashAlgorithm.Sha256));
local Directory = "Sealz";

if not isfolder(Directory) then
    makefolder(Directory);
end;

local LoaderConfig = {
    Legacy = false,
    License = "",
};

if isfile(Directory..'/Loader.json') then
    pcall(function()
        local js = HttpService:JSONDecode(readfile(Directory..'/Loader.json'));

        LoaderConfig.Legacy = js.Legacy;
        LoaderConfig.License = js.License;
    end);
end;

if not LICENSE_KEY then
    LICENSE_KEY = LoaderConfig.License
end;

local NexoraAPI = function(license: string)
	if FreeAccess[game.GameId] then
		return true;
	end;

    if not license or not license:byte() then
        return false;
    end;

    local response = (request or http_request)({
        Url = "https://api.nexora.im/auth/verify",
        Method = "POST",
        Headers = {
            ['Content-Type'] = "application/json"
        },
        Body = HttpService:JSONEncode({
            project_id = "6a81a219dde24d118a4dc072",
            license = license,
            identifier = HWID,
        });
    });

    return response.Body == "yes";
end;

local Load = function()
    writefile(Directory..'/Loader.json',HttpService:JSONEncode(LoaderConfig));

    local Loader = "https://gitlab.com/not4lpaca/noname/-/raw/main/core/"..SealzPDB[game.GameId];

    local Fn = loadstring(
        game:HttpGet(Loader)
    );

    local AuthGateway = {
        LICENSE = LoaderConfig.License or LICENSE_KEY,
        HWID = HWID,
		FREE = FreeAccess[game.GameId] or false,
        TIME = tick(),
        LOADER_HASH = ToHex(EncodingService:ComputeStringHash(Loader, Enum.HashAlgorithm.Sha256))
    };

    getgenv().SEALZ_AUTH = AuthGateway;

    return Fn(LoaderConfig.License or LICENSE_KEY, AuthGateway);
end;

if not SealzPDB[game.GameId] then
    return
end;


if (LICENSE_KEY and LICENSE_KEY:byte() and not LoaderConfig.Legacy and NexoraAPI(LICENSE_KEY or LoaderConfig.License)) or FreeAccess[game.GameId] then
    -- load
    LoaderConfig.License = LICENSE_KEY;

    return Load();
else
    local KeySystem = Sealz.Menu();
    local Bind = Instance.new('BindableEvent');

    local Auth = false;

    if LoaderConfig.License or LICENSE_KEY then
        KeySystem.Input.Text = tostring(LICENSE_KEY or LoaderConfig.License);
    end;

    local signal1 = KeySystem.Login.Activated:Connect(function()
        if Auth then
            return
        end;
        Auth = true;
        local Active = KeySystem.Input.Text:gsub(" ", "");

        if NexoraAPI(Active) then
            Bind:Fire();
            LICENSE_KEY = Active;
            LoaderConfig.License = Active;
        else
            KeySystem.Input.Text = ""
        end;
        Auth = false;
    end)

    local signal2 = KeySystem.GetKey.Activated:Connect(function()
        (setclipboard or toclipboard)("https://sealz.cc/getkey?i="..HttpService:UrlEncode(HWID));
    end)

    Bind.Event:Wait();

    signal1:Disconnect();
    signal2:Disconnect()

    Bind:Destroy();
    KeySystem:Destroy();
    
    Load();
end;