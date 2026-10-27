-- made by dnezero
-- give credits if you are going to take code from here
-- https://join.zerohub.cc/

--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

-- Instances: 591 | Scripts: 78 | Modules: 0 | Tags: 0
local G2L = {};

-- StarterGui.zerohub
G2L["1"] = Instance.new("ScreenGui", game.CoreGui);
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
G2L["1"]["Name"] = [[zerohub]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;


-- StarterGui.zerohub.init
G2L["2"] = Instance.new("Folder", G2L["1"]);
G2L["2"]["Name"] = [[init]];


-- StarterGui.zerohub.init.overlay
G2L["3"] = Instance.new("LocalScript", G2L["2"]);
G2L["3"]["Name"] = [[overlay]];


-- StarterGui.zerohub.init.scriptbloxanalytics
G2L["4"] = Instance.new("LocalScript", G2L["2"]);
G2L["4"]["Name"] = [[scriptbloxanalytics]];


-- StarterGui.zerohub.init.notifications
G2L["5"] = Instance.new("LocalScript", G2L["2"]);
G2L["5"]["Name"] = [[notifications]];


-- StarterGui.zerohub.init.clicksound
G2L["6"] = Instance.new("LocalScript", G2L["2"]);
G2L["6"]["Name"] = [[clicksound]];


-- StarterGui.zerohub.init.sidebarcontroller
G2L["7"] = Instance.new("LocalScript", G2L["2"]);
G2L["7"]["Name"] = [[sidebarcontroller]];


-- StarterGui.zerohub.init.apikeymanager
G2L["8"] = Instance.new("LocalScript", G2L["2"]);
G2L["8"]["Name"] = [[apikeymanager]];


-- StarterGui.zerohub.init.themesystem
G2L["9"] = Instance.new("LocalScript", G2L["2"]);
G2L["9"]["Name"] = [[themesystem]];


-- StarterGui.zerohub.interface
G2L["a"] = Instance.new("Folder", G2L["1"]);
G2L["a"]["Name"] = [[interface]];


-- StarterGui.zerohub.interface.loader
G2L["b"] = Instance.new("Frame", G2L["a"]);
G2L["b"]["Visible"] = false;
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["b"]["Size"] = UDim2.new(0, 339, 0, 194);
G2L["b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["Name"] = [[loader]];
-- Attributes
G2L["b"]:SetAttribute([[OriginalColor]], Color3.fromRGB(21, 21, 21));


-- StarterGui.zerohub.interface.loader.UICorner
G2L["c"] = Instance.new("UICorner", G2L["b"]);



-- StarterGui.zerohub.interface.loader.loadingbar
G2L["d"] = Instance.new("Frame", G2L["b"]);
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
G2L["d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["d"]["Size"] = UDim2.new(0, 312, 0, 1);
G2L["d"]["Position"] = UDim2.new(0.5, 0, 0.94267, 0);
G2L["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["Name"] = [[loadingbar]];


-- StarterGui.zerohub.interface.loader.loadingbar.ineedajob
G2L["e"] = Instance.new("LocalScript", G2L["d"]);
G2L["e"]["Name"] = [[ineedajob]];


-- StarterGui.zerohub.interface.loader.loadingbar.UICorner
G2L["f"] = Instance.new("UICorner", G2L["d"]);
G2L["f"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.loader.loadingbar.loadingbarprogress
G2L["10"] = Instance.new("Frame", G2L["d"]);
G2L["10"]["BorderSizePixel"] = 0;
G2L["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["Name"] = [[loadingbarprogress]];
-- Attributes
G2L["10"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.loader.TextLabel
G2L["11"] = Instance.new("TextLabel", G2L["b"]);
G2L["11"]["BorderSizePixel"] = 0;
G2L["11"]["TextSize"] = 20;
G2L["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["11"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11"]["BackgroundTransparency"] = 1;
G2L["11"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["11"]["Size"] = UDim2.new(0, 200, 0, 50);
G2L["11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11"]["Text"] = [[zerohub.cc]];
G2L["11"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main
G2L["12"] = Instance.new("Frame", G2L["a"]);
G2L["12"]["BorderSizePixel"] = 0;
G2L["12"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["12"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["12"]["ClipsDescendants"] = true;
G2L["12"]["Size"] = UDim2.new(0, 480, 0, 309);
G2L["12"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["Name"] = [[main]];
-- Attributes
G2L["12"]:SetAttribute([[OriginalColor]], Color3.fromRGB(21, 21, 21));


-- StarterGui.zerohub.interface.main.UICorner
G2L["13"] = Instance.new("UICorner", G2L["12"]);



-- StarterGui.zerohub.interface.main.UIShadow
G2L["14"] = Instance.new("UIShadow", G2L["12"]);



-- StarterGui.zerohub.interface.main.titlebar
G2L["15"] = Instance.new("Frame", G2L["12"]);
G2L["15"]["ZIndex"] = 5;
G2L["15"]["BorderSizePixel"] = 0;
G2L["15"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
G2L["15"]["Size"] = UDim2.new(0, 480, 0, 35);
G2L["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15"]["Name"] = [[titlebar]];
G2L["15"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.titlebar.menu
G2L["16"] = Instance.new("ImageButton", G2L["15"]);
G2L["16"]["BorderSizePixel"] = 0;
G2L["16"]["BackgroundTransparency"] = 1;
G2L["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["16"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["16"]["Image"] = [[rbxassetid://10723345990]];
G2L["16"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["16"]["Name"] = [[menu]];
G2L["16"]["Position"] = UDim2.new(0.02083, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.titlebar.windowtitle
G2L["17"] = Instance.new("TextLabel", G2L["15"]);
G2L["17"]["BorderSizePixel"] = 0;
G2L["17"]["TextSize"] = 16;
G2L["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["17"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["17"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17"]["BackgroundTransparency"] = 1;
G2L["17"]["Size"] = UDim2.new(0, 200, 0, 14);
G2L["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17"]["Text"] = [[zerohub.cc]];
G2L["17"]["Name"] = [[windowtitle]];
G2L["17"]["Position"] = UDim2.new(0.08333, 0, 0.25, 0);


-- StarterGui.zerohub.interface.main.titlebar.close
G2L["18"] = Instance.new("ImageButton", G2L["15"]);
G2L["18"]["BorderSizePixel"] = 0;
G2L["18"]["BackgroundTransparency"] = 1;
G2L["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["18"]["Image"] = [[rbxassetid://10747384394]];
G2L["18"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18"]["Name"] = [[close]];
G2L["18"]["Position"] = UDim2.new(0.93958, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.titlebar.close.LocalScript
G2L["19"] = Instance.new("LocalScript", G2L["18"]);



-- StarterGui.zerohub.interface.main.titlebar.minimize
G2L["1a"] = Instance.new("ImageButton", G2L["15"]);
G2L["1a"]["BorderSizePixel"] = 0;
G2L["1a"]["BackgroundTransparency"] = 1;
G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1a"]["Image"] = [[rbxassetid://10734896206]];
G2L["1a"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["Name"] = [[minimize]];
G2L["1a"]["Position"] = UDim2.new(0.87083, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.titlebar.minimize.LocalScript
G2L["1b"] = Instance.new("LocalScript", G2L["1a"]);



-- StarterGui.zerohub.interface.main.tabs
G2L["1c"] = Instance.new("Folder", G2L["12"]);
G2L["1c"]["Name"] = [[tabs]];


-- StarterGui.zerohub.interface.main.tabs.home
G2L["1d"] = Instance.new("Frame", G2L["1c"]);
G2L["1d"]["BorderSizePixel"] = 0;
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d"]["Name"] = [[home]];
G2L["1d"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget1
G2L["1e"] = Instance.new("Frame", G2L["1d"]);
G2L["1e"]["BorderSizePixel"] = 0;
G2L["1e"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1e"]["Size"] = UDim2.new(0, 185, 0, 265);
G2L["1e"]["Position"] = UDim2.new(0.02083, 0, 0.11003, 0);
G2L["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e"]["Name"] = [[widget1]];
-- Attributes
G2L["1e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.UICorner
G2L["1f"] = Instance.new("UICorner", G2L["1e"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.separator
G2L["20"] = Instance.new("Frame", G2L["1e"]);
G2L["20"]["BorderSizePixel"] = 0;
G2L["20"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["20"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["20"]["Size"] = UDim2.new(0, 170, 0, 1);
G2L["20"]["Position"] = UDim2.new(0.5, 0, 0.26792, 0);
G2L["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20"]["Name"] = [[separator]];
G2L["20"]["BackgroundTransparency"] = 0.5;
-- Attributes
G2L["20"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.pfp
G2L["21"] = Instance.new("ImageLabel", G2L["1e"]);
G2L["21"]["BorderSizePixel"] = 0;
G2L["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21"]["Image"] = [[rbxassetid://10747373176]];
G2L["21"]["Size"] = UDim2.new(0, 50, 0, 50);
G2L["21"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21"]["BackgroundTransparency"] = 1;
G2L["21"]["Name"] = [[pfp]];
G2L["21"]["Position"] = UDim2.new(0.03784, 0, 0.05, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.pfp.LocalScript
G2L["22"] = Instance.new("LocalScript", G2L["21"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.pfp.UICorner
G2L["23"] = Instance.new("UICorner", G2L["21"]);
G2L["23"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.displayname
G2L["24"] = Instance.new("TextLabel", G2L["1e"]);
G2L["24"]["TextWrapped"] = true;
G2L["24"]["BorderSizePixel"] = 0;
G2L["24"]["TextSize"] = 20;
G2L["24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["24"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["24"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["24"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["24"]["BackgroundTransparency"] = 1;
G2L["24"]["Size"] = UDim2.new(0, 111, 0, 23);
G2L["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["24"]["Name"] = [[displayname]];
G2L["24"]["Position"] = UDim2.new(0.35676, 0, 0.07547, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.displayname.LocalScript
G2L["25"] = Instance.new("LocalScript", G2L["24"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.userid
G2L["26"] = Instance.new("TextLabel", G2L["1e"]);
G2L["26"]["TextWrapped"] = true;
G2L["26"]["BorderSizePixel"] = 0;
G2L["26"]["TextSize"] = 14;
G2L["26"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["26"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["26"]["BackgroundColor3"] = Color3.fromRGB(101, 101, 101);
G2L["26"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["26"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["26"]["BackgroundTransparency"] = 1;
G2L["26"]["Size"] = UDim2.new(0, 111, 0, 16);
G2L["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["26"]["Text"] = [[1234567890]];
G2L["26"]["Name"] = [[userid]];
G2L["26"]["Position"] = UDim2.new(0.35676, 0, 0.15094, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.userid.LocalScript
G2L["27"] = Instance.new("LocalScript", G2L["26"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement
G2L["28"] = Instance.new("Frame", G2L["1e"]);
G2L["28"]["BorderSizePixel"] = 0;
G2L["28"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["28"]["Size"] = UDim2.new(0, 177, 0, 149);
G2L["28"]["Position"] = UDim2.new(0, 0, 0.3, 0);
G2L["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["28"]["Name"] = [[movement]];
-- Attributes
G2L["28"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.LocalScript
G2L["29"] = Instance.new("LocalScript", G2L["28"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.UICorner
G2L["2a"] = Instance.new("UICorner", G2L["28"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons
G2L["2b"] = Instance.new("Frame", G2L["28"]);
G2L["2b"]["BorderSizePixel"] = 0;
G2L["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2b"]["Size"] = UDim2.new(0, 172, 0, 22);
G2L["2b"]["Position"] = UDim2.new(0.02752, 0, 0, 0);
G2L["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2b"]["Name"] = [[buttons]];
G2L["2b"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.UIListLayout
G2L["2c"] = Instance.new("UIListLayout", G2L["2b"]);
G2L["2c"]["Padding"] = UDim.new(0, 5);
G2L["2c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["2c"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.fly
G2L["2d"] = Instance.new("TextButton", G2L["2b"]);
G2L["2d"]["BorderSizePixel"] = 0;
G2L["2d"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["2d"]["TextSize"] = 14;
G2L["2d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2d"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["2d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["2d"]["Size"] = UDim2.new(0, 25, 0, 25);
G2L["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2d"]["Text"] = [[]];
G2L["2d"]["Name"] = [[fly]];
-- Attributes
G2L["2d"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.fly.ImageLabel
G2L["2e"] = Instance.new("ImageLabel", G2L["2d"]);
G2L["2e"]["BorderSizePixel"] = 0;
G2L["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["2e"]["Image"] = [[rbxassetid://10734922971]];
G2L["2e"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2e"]["BackgroundTransparency"] = 1;
G2L["2e"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.fly.UICorner
G2L["2f"] = Instance.new("UICorner", G2L["2d"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.noclip
G2L["30"] = Instance.new("TextButton", G2L["2b"]);
G2L["30"]["BorderSizePixel"] = 0;
G2L["30"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["30"]["TextSize"] = 14;
G2L["30"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["30"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["30"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["30"]["Size"] = UDim2.new(0, 25, 0, 25);
G2L["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["30"]["Text"] = [[]];
G2L["30"]["Name"] = [[noclip]];
G2L["30"]["Position"] = UDim2.new(0.58788, 0, 0, 0);
-- Attributes
G2L["30"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.noclip.ImageLabel
G2L["31"] = Instance.new("ImageLabel", G2L["30"]);
G2L["31"]["BorderSizePixel"] = 0;
G2L["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["31"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["31"]["Image"] = [[rbxassetid://10723376884]];
G2L["31"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["31"]["BackgroundTransparency"] = 1;
G2L["31"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.noclip.UICorner
G2L["32"] = Instance.new("UICorner", G2L["30"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.infjump
G2L["33"] = Instance.new("TextButton", G2L["2b"]);
G2L["33"]["BorderSizePixel"] = 0;
G2L["33"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["33"]["TextSize"] = 14;
G2L["33"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["33"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["33"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["33"]["Size"] = UDim2.new(0, 25, 0, 25);
G2L["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["33"]["Text"] = [[]];
G2L["33"]["Name"] = [[infjump]];
G2L["33"]["Position"] = UDim2.new(0.52121, 0, 0, 0);
-- Attributes
G2L["33"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.infjump.ImageLabel
G2L["34"] = Instance.new("ImageLabel", G2L["33"]);
G2L["34"]["BorderSizePixel"] = 0;
G2L["34"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["34"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["34"]["Image"] = [[rbxassetid://10709768939]];
G2L["34"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["34"]["BackgroundTransparency"] = 1;
G2L["34"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.buttons.infjump.UICorner
G2L["35"] = Instance.new("UICorner", G2L["33"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders
G2L["36"] = Instance.new("Frame", G2L["28"]);
G2L["36"]["BorderSizePixel"] = 0;
G2L["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["36"]["Size"] = UDim2.new(0, 172, 0, 107);
G2L["36"]["Position"] = UDim2.new(0.02752, 0, 0.22667, 0);
G2L["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["36"]["Name"] = [[sliders]];
G2L["36"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed
G2L["37"] = Instance.new("Frame", G2L["36"]);
G2L["37"]["Active"] = true;
G2L["37"]["BorderSizePixel"] = 0;
G2L["37"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["37"]["ClipsDescendants"] = true;
G2L["37"]["Size"] = UDim2.new(0, 243, 0, 32);
G2L["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["37"]["Name"] = [[walkspeed]];
-- Attributes
G2L["37"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed.UICorner
G2L["38"] = Instance.new("UICorner", G2L["37"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed.filler
G2L["39"] = Instance.new("Frame", G2L["37"]);
G2L["39"]["BorderSizePixel"] = 0;
G2L["39"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["39"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["39"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["39"]["Name"] = [[filler]];
-- Attributes
G2L["39"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed.filler.UICorner
G2L["3a"] = Instance.new("UICorner", G2L["39"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed.value
G2L["3b"] = Instance.new("TextLabel", G2L["37"]);
G2L["3b"]["ZIndex"] = 2;
G2L["3b"]["BorderSizePixel"] = 0;
G2L["3b"]["TextSize"] = 14;
G2L["3b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["3b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["3b"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["3b"]["BackgroundTransparency"] = 1;
G2L["3b"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["3b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3b"]["Text"] = [[16]];
G2L["3b"]["Name"] = [[value]];
G2L["3b"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.walkspeed.icon
G2L["3c"] = Instance.new("ImageLabel", G2L["37"]);
G2L["3c"]["ZIndex"] = 2;
G2L["3c"]["BorderSizePixel"] = 0;
G2L["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3c"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["3c"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["3c"]["Image"] = [[rbxassetid://12975608939]];
G2L["3c"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["3c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3c"]["BackgroundTransparency"] = 1;
G2L["3c"]["Name"] = [[icon]];
G2L["3c"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.UIGridLayout
G2L["3d"] = Instance.new("UIGridLayout", G2L["36"]);
G2L["3d"]["CellSize"] = UDim2.new(1, 0, 0, 32);
G2L["3d"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower
G2L["3e"] = Instance.new("Frame", G2L["36"]);
G2L["3e"]["Active"] = true;
G2L["3e"]["BorderSizePixel"] = 0;
G2L["3e"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["3e"]["ClipsDescendants"] = true;
G2L["3e"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3e"]["Name"] = [[jumppower]];
-- Attributes
G2L["3e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower.UICorner
G2L["3f"] = Instance.new("UICorner", G2L["3e"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower.filler
G2L["40"] = Instance.new("Frame", G2L["3e"]);
G2L["40"]["BorderSizePixel"] = 0;
G2L["40"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["40"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["40"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["40"]["Name"] = [[filler]];
-- Attributes
G2L["40"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower.filler.UICorner
G2L["41"] = Instance.new("UICorner", G2L["40"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower.value
G2L["42"] = Instance.new("TextLabel", G2L["3e"]);
G2L["42"]["ZIndex"] = 2;
G2L["42"]["BorderSizePixel"] = 0;
G2L["42"]["TextSize"] = 14;
G2L["42"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["42"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["42"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["42"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["42"]["BackgroundTransparency"] = 1;
G2L["42"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["42"]["Text"] = [[50]];
G2L["42"]["Name"] = [[value]];
G2L["42"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.jumppower.icon
G2L["43"] = Instance.new("ImageLabel", G2L["3e"]);
G2L["43"]["ZIndex"] = 2;
G2L["43"]["BorderSizePixel"] = 0;
G2L["43"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["43"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["43"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["43"]["Image"] = [[rbxassetid://10709768939]];
G2L["43"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["43"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["43"]["BackgroundTransparency"] = 1;
G2L["43"]["Name"] = [[icon]];
G2L["43"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed
G2L["44"] = Instance.new("Frame", G2L["36"]);
G2L["44"]["Active"] = true;
G2L["44"]["BorderSizePixel"] = 0;
G2L["44"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["44"]["ClipsDescendants"] = true;
G2L["44"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["44"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["44"]["Name"] = [[flyspeed]];
-- Attributes
G2L["44"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed.UICorner
G2L["45"] = Instance.new("UICorner", G2L["44"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed.filler
G2L["46"] = Instance.new("Frame", G2L["44"]);
G2L["46"]["BorderSizePixel"] = 0;
G2L["46"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["46"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["46"]["Name"] = [[filler]];
-- Attributes
G2L["46"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed.filler.UICorner
G2L["47"] = Instance.new("UICorner", G2L["46"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed.value
G2L["48"] = Instance.new("TextLabel", G2L["44"]);
G2L["48"]["ZIndex"] = 2;
G2L["48"]["BorderSizePixel"] = 0;
G2L["48"]["TextSize"] = 14;
G2L["48"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["48"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["48"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["48"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["48"]["BackgroundTransparency"] = 1;
G2L["48"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["48"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["48"]["Text"] = [[1]];
G2L["48"]["Name"] = [[value]];
G2L["48"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.sliders.flyspeed.icon
G2L["49"] = Instance.new("ImageLabel", G2L["44"]);
G2L["49"]["ZIndex"] = 2;
G2L["49"]["BorderSizePixel"] = 0;
G2L["49"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["49"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["49"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["49"]["Image"] = [[rbxassetid://10734922971]];
G2L["49"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["49"]["BackgroundTransparency"] = 1;
G2L["49"]["Name"] = [[icon]];
G2L["49"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget1.separator
G2L["4a"] = Instance.new("Frame", G2L["1e"]);
G2L["4a"]["BorderSizePixel"] = 0;
G2L["4a"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["4a"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["4a"]["Size"] = UDim2.new(0, 170, 0, 1);
G2L["4a"]["Position"] = UDim2.new(0.5, 0, 0.86038, 0);
G2L["4a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4a"]["Name"] = [[separator]];
G2L["4a"]["BackgroundTransparency"] = 0.5;
-- Attributes
G2L["4a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.copydiscord
G2L["4b"] = Instance.new("TextButton", G2L["1e"]);
G2L["4b"]["BorderSizePixel"] = 0;
G2L["4b"]["TextSize"] = 14;
G2L["4b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4b"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["4b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["4b"]["Size"] = UDim2.new(0, 170, 0, 24);
G2L["4b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4b"]["Text"] = [[Join Discord]];
G2L["4b"]["Name"] = [[copydiscord]];
G2L["4b"]["Position"] = UDim2.new(0.04054, 0, 0.885, 0);
-- Attributes
G2L["4b"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.home.widget1.copydiscord.UICorner
G2L["4c"] = Instance.new("UICorner", G2L["4b"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget1.copydiscord.LocalScript
G2L["4d"] = Instance.new("LocalScript", G2L["4b"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget2
G2L["4e"] = Instance.new("Frame", G2L["1d"]);
G2L["4e"]["BorderSizePixel"] = 0;
G2L["4e"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["4e"]["Size"] = UDim2.new(0, 267, 0, 72);
G2L["4e"]["Position"] = UDim2.new(0.425, 0, 0.11003, 0);
G2L["4e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4e"]["Name"] = [[widget2]];
-- Attributes
G2L["4e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.home.widget2.UICorner
G2L["4f"] = Instance.new("UICorner", G2L["4e"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget2.UIGridLayout
G2L["50"] = Instance.new("UIGridLayout", G2L["4e"]);
G2L["50"]["CellSize"] = UDim2.new(0, 89, 1, 0);
G2L["50"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["50"]["CellPadding"] = UDim2.new(0, 0, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame
G2L["51"] = Instance.new("Frame", G2L["4e"]);
G2L["51"]["BorderSizePixel"] = 0;
G2L["51"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["51"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["51"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["51"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["52"] = Instance.new("TextLabel", G2L["51"]);
G2L["52"]["BorderSizePixel"] = 0;
G2L["52"]["TextSize"] = 20;
G2L["52"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["52"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["52"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["52"]["BackgroundTransparency"] = 1;
G2L["52"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["52"]["Size"] = UDim2.new(1, 0, 0, 50);
G2L["52"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["52"]["Text"] = [[240]];
G2L["52"]["Position"] = UDim2.new(0.5, 0, 0.43056, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
G2L["53"] = Instance.new("LocalScript", G2L["52"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["54"] = Instance.new("TextLabel", G2L["51"]);
G2L["54"]["BorderSizePixel"] = 0;
G2L["54"]["TextSize"] = 14;
G2L["54"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["54"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["54"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["54"]["BackgroundTransparency"] = 1;
G2L["54"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["54"]["Size"] = UDim2.new(1, 0, -0.48611, 50);
G2L["54"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["54"]["Text"] = [[FPS]];
G2L["54"]["Position"] = UDim2.new(0.5, 0, 0.65972, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame
G2L["55"] = Instance.new("Frame", G2L["4e"]);
G2L["55"]["BorderSizePixel"] = 0;
G2L["55"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["55"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["55"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["55"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["56"] = Instance.new("TextLabel", G2L["55"]);
G2L["56"]["BorderSizePixel"] = 0;
G2L["56"]["TextSize"] = 20;
G2L["56"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["56"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["56"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["56"]["BackgroundTransparency"] = 1;
G2L["56"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["56"]["Size"] = UDim2.new(1, 0, 0, 50);
G2L["56"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["56"]["Text"] = [[50]];
G2L["56"]["Position"] = UDim2.new(0.5, 0, 0.43056, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
G2L["57"] = Instance.new("LocalScript", G2L["56"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["58"] = Instance.new("TextLabel", G2L["55"]);
G2L["58"]["BorderSizePixel"] = 0;
G2L["58"]["TextSize"] = 14;
G2L["58"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["58"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["58"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["58"]["BackgroundTransparency"] = 1;
G2L["58"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["58"]["Size"] = UDim2.new(1, 0, -0.48611, 50);
G2L["58"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["58"]["Text"] = [[ms]];
G2L["58"]["Position"] = UDim2.new(0.5, 0, 0.65972, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame
G2L["59"] = Instance.new("Frame", G2L["4e"]);
G2L["59"]["BorderSizePixel"] = 0;
G2L["59"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["59"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["59"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["59"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["5a"] = Instance.new("TextLabel", G2L["59"]);
G2L["5a"]["BorderSizePixel"] = 0;
G2L["5a"]["TextSize"] = 20;
G2L["5a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5a"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5a"]["BackgroundTransparency"] = 1;
G2L["5a"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["5a"]["Size"] = UDim2.new(1, 0, 0, 50);
G2L["5a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5a"]["Text"] = [[1750]];
G2L["5a"]["Position"] = UDim2.new(0.5, 0, 0.43056, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
G2L["5b"] = Instance.new("LocalScript", G2L["5a"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel
G2L["5c"] = Instance.new("TextLabel", G2L["59"]);
G2L["5c"]["BorderSizePixel"] = 0;
G2L["5c"]["TextSize"] = 14;
G2L["5c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5c"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5c"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["5c"]["BackgroundTransparency"] = 1;
G2L["5c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["5c"]["Size"] = UDim2.new(1, 0, -0.48611, 50);
G2L["5c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5c"]["Text"] = [[MB]];
G2L["5c"]["Position"] = UDim2.new(0.5, 0, 0.65972, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget3
G2L["5d"] = Instance.new("Frame", G2L["1d"]);
G2L["5d"]["BorderSizePixel"] = 0;
G2L["5d"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["5d"]["Size"] = UDim2.new(0, 267, 0, 185);
G2L["5d"]["Position"] = UDim2.new(0.425, 0, 0.36893, 0);
G2L["5d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5d"]["Name"] = [[widget3]];
-- Attributes
G2L["5d"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.home.widget3.UICorner
G2L["5e"] = Instance.new("UICorner", G2L["5d"]);



-- StarterGui.zerohub.interface.main.tabs.home.widget3.TextLabel
G2L["5f"] = Instance.new("TextLabel", G2L["5d"]);
G2L["5f"]["BorderSizePixel"] = 0;
G2L["5f"]["TextSize"] = 20;
G2L["5f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["5f"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["5f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5f"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5f"]["BackgroundTransparency"] = 1;
G2L["5f"]["Size"] = UDim2.new(0, 200, 0, 25);
G2L["5f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5f"]["Text"] = [[26 october 2026]];
G2L["5f"]["Position"] = UDim2.new(0.02996, 0, 0.04865, 0);


-- StarterGui.zerohub.interface.main.tabs.home.widget3.TextLabel
G2L["60"] = Instance.new("TextLabel", G2L["5d"]);
G2L["60"]["TextWrapped"] = true;
G2L["60"]["BorderSizePixel"] = 0;
G2L["60"]["TextSize"] = 14;
G2L["60"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["60"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["60"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["60"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["60"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["60"]["BackgroundTransparency"] = 1;
G2L["60"]["Size"] = UDim2.new(0.93191, 0, 0.78108, 0);
G2L["60"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["60"]["Text"] = [[1. remade whole ui
2. made home better
3. added tags in scripthub (verified & key system)
4. added right-click menu in ai and /clear command
5. added notification system
6. added white theme
7. added more animations
8. added sounds to the ui]];
G2L["60"]["Position"] = UDim2.new(0.02996, 0, 0.18378, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub
G2L["61"] = Instance.new("Frame", G2L["1c"]);
G2L["61"]["Visible"] = false;
G2L["61"]["BorderSizePixel"] = 0;
G2L["61"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["61"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["61"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["61"]["Name"] = [[scripthub]];
G2L["61"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.scripthub.zshs
G2L["62"] = Instance.new("LocalScript", G2L["61"]);
G2L["62"]["Name"] = [[zshs]];


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame
G2L["63"] = Instance.new("ScrollingFrame", G2L["61"]);
G2L["63"]["Active"] = true;
G2L["63"]["BorderSizePixel"] = 0;
G2L["63"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["63"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["63"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["63"]["Size"] = UDim2.new(0, 460, 0, 244);
G2L["63"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["63"]["Position"] = UDim2.new(0.02083, 0, 0.21, 0);
G2L["63"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["63"]["ScrollBarThickness"] = 0;
G2L["63"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.UIGridLayout
G2L["64"] = Instance.new("UIGridLayout", G2L["63"]);
G2L["64"]["CellSize"] = UDim2.new(1, 0, 0, 150);
G2L["64"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example
G2L["65"] = Instance.new("Frame", G2L["63"]);
G2L["65"]["BorderSizePixel"] = 0;
G2L["65"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["65"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["65"]["Position"] = UDim2.new(-0.01484, 0, 0.10425, 0);
G2L["65"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["65"]["Name"] = [[example]];
-- Attributes
G2L["65"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.UICorner
G2L["66"] = Instance.new("UICorner", G2L["65"]);



-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.scriptimage
G2L["67"] = Instance.new("ImageLabel", G2L["65"]);
G2L["67"]["BorderSizePixel"] = 0;
G2L["67"]["ScaleType"] = Enum.ScaleType.Crop;
G2L["67"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
G2L["67"]["Size"] = UDim2.new(0, 236, 0, 138);
G2L["67"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["67"]["Name"] = [[scriptimage]];
G2L["67"]["Position"] = UDim2.new(0.01129, 0, 0.04, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.scriptimage.UICorner
G2L["68"] = Instance.new("UICorner", G2L["67"]);



-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.scripttitle
G2L["69"] = Instance.new("TextLabel", G2L["65"]);
G2L["69"]["TextWrapped"] = true;
G2L["69"]["BorderSizePixel"] = 0;
G2L["69"]["TextSize"] = 20;
G2L["69"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["69"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["69"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["69"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["69"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["69"]["BackgroundTransparency"] = 1;
G2L["69"]["Size"] = UDim2.new(0, 201, 0, 71);
G2L["69"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["69"]["Text"] = [[zerohub universal: AI and more]];
G2L["69"]["Name"] = [[scripttitle]];
G2L["69"]["Position"] = UDim2.new(0.5439, 0, 0.19333, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.likesicon
G2L["6a"] = Instance.new("ImageLabel", G2L["65"]);
G2L["6a"]["BorderSizePixel"] = 0;
G2L["6a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["6a"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["6a"]["Image"] = [[rbxassetid://10723346959]];
G2L["6a"]["Size"] = UDim2.new(0, 10, 0, 10);
G2L["6a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6a"]["BackgroundTransparency"] = 1;
G2L["6a"]["Name"] = [[likesicon]];
G2L["6a"]["Position"] = UDim2.new(0.5439, 0, 0.72, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.likescount
G2L["6b"] = Instance.new("TextLabel", G2L["65"]);
G2L["6b"]["BorderSizePixel"] = 0;
G2L["6b"]["TextSize"] = 12;
G2L["6b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["6b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["6b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["6b"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["6b"]["BackgroundTransparency"] = 1;
G2L["6b"]["Size"] = UDim2.new(0, 184, 0, 10);
G2L["6b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6b"]["Text"] = [[67]];
G2L["6b"]["Name"] = [[likescount]];
G2L["6b"]["Position"] = UDim2.new(0.58, 0, 0.72, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.execute
G2L["6c"] = Instance.new("TextButton", G2L["65"]);
G2L["6c"]["BorderSizePixel"] = 0;
G2L["6c"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["6c"]["TextSize"] = 14;
G2L["6c"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["6c"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["6c"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["6c"]["Size"] = UDim2.new(0, 79, 0, 22);
G2L["6c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6c"]["Text"] = [[Execute  ]];
G2L["6c"]["Name"] = [[execute]];
G2L["6c"]["Position"] = UDim2.new(0.82134, 0, 0.82, 0);
-- Attributes
G2L["6c"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.execute.anim
G2L["6d"] = Instance.new("LocalScript", G2L["6c"]);
G2L["6d"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.execute.UICorner
G2L["6e"] = Instance.new("UICorner", G2L["6c"]);



-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.execute.ImageLabel
G2L["6f"] = Instance.new("ImageLabel", G2L["6c"]);
G2L["6f"]["BorderSizePixel"] = 0;
G2L["6f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["6f"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["6f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["6f"]["Image"] = [[rbxassetid://10734923549]];
G2L["6f"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["6f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6f"]["BackgroundTransparency"] = 1;
G2L["6f"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.copy
G2L["70"] = Instance.new("TextButton", G2L["65"]);
G2L["70"]["BorderSizePixel"] = 0;
G2L["70"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["70"]["TextSize"] = 14;
G2L["70"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["70"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["70"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["70"]["Size"] = UDim2.new(0, 63, 0, 22);
G2L["70"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["70"]["Text"] = [[Copy  ]];
G2L["70"]["Name"] = [[copy]];
G2L["70"]["Position"] = UDim2.new(0.675, 0, 0.82, 0);
-- Attributes
G2L["70"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.copy.anim
G2L["71"] = Instance.new("LocalScript", G2L["70"]);
G2L["71"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.copy.UICorner
G2L["72"] = Instance.new("UICorner", G2L["70"]);



-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.copy.ImageLabel
G2L["73"] = Instance.new("ImageLabel", G2L["70"]);
G2L["73"]["BorderSizePixel"] = 0;
G2L["73"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["73"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["73"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["73"]["Image"] = [[rbxassetid://10709812159]];
G2L["73"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["73"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["73"]["BackgroundTransparency"] = 1;
G2L["73"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags
G2L["74"] = Instance.new("Frame", G2L["65"]);
G2L["74"]["BorderSizePixel"] = 0;
G2L["74"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["74"]["Size"] = UDim2.new(0, 148, 0, 17);
G2L["74"]["Position"] = UDim2.new(0.54522, 0, 0.05667, 0);
G2L["74"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["74"]["Name"] = [[tags]];
G2L["74"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags.UIListLayout
G2L["75"] = Instance.new("UIListLayout", G2L["74"]);
G2L["75"]["Padding"] = UDim.new(0, 3);
G2L["75"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["75"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags.haskeysystem
G2L["76"] = Instance.new("TextLabel", G2L["74"]);
G2L["76"]["BorderSizePixel"] = 0;
G2L["76"]["TextSize"] = 12;
G2L["76"]["BackgroundColor3"] = Color3.fromRGB(241, 178, 0);
G2L["76"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["76"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["76"]["Size"] = UDim2.new(0, 70, 0, 17);
G2L["76"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["76"]["Text"] = [[Key system]];
G2L["76"]["Name"] = [[haskeysystem]];


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags.haskeysystem.UICorner
G2L["77"] = Instance.new("UICorner", G2L["76"]);
G2L["77"]["CornerRadius"] = UDim.new(0, 5);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags.isverified
G2L["78"] = Instance.new("TextLabel", G2L["74"]);
G2L["78"]["BorderSizePixel"] = 0;
G2L["78"]["TextSize"] = 12;
G2L["78"]["BackgroundColor3"] = Color3.fromRGB(0, 146, 218);
G2L["78"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["78"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["78"]["Size"] = UDim2.new(0, 46, 0, 17);
G2L["78"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["78"]["Text"] = [[Verified]];
G2L["78"]["Name"] = [[isverified]];
G2L["78"]["Position"] = UDim2.new(0, 0, 1, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.tags.isverified.UICorner
G2L["79"] = Instance.new("UICorner", G2L["78"]);
G2L["79"]["CornerRadius"] = UDim.new(0, 5);


-- StarterGui.zerohub.interface.main.tabs.scripthub.searchbar
G2L["7a"] = Instance.new("Frame", G2L["61"]);
G2L["7a"]["BorderSizePixel"] = 0;
G2L["7a"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["7a"]["Size"] = UDim2.new(0, 460, 0, 25);
G2L["7a"]["Position"] = UDim2.new(0.02083, 0, 0.11091, 0);
G2L["7a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7a"]["Name"] = [[searchbar]];
-- Attributes
G2L["7a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.scripthub.searchbar.UICorner
G2L["7b"] = Instance.new("UICorner", G2L["7a"]);



-- StarterGui.zerohub.interface.main.tabs.scripthub.searchbar.ImageLabel
G2L["7c"] = Instance.new("ImageLabel", G2L["7a"]);
G2L["7c"]["BorderSizePixel"] = 0;
G2L["7c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7c"]["Image"] = [[rbxassetid://10734943674]];
G2L["7c"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["7c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7c"]["BackgroundTransparency"] = 1;
G2L["7c"]["Position"] = UDim2.new(0.95, 0, 0.2, 0);


-- StarterGui.zerohub.interface.main.tabs.scripthub.searchbar.TextBox
G2L["7d"] = Instance.new("TextBox", G2L["7a"]);
G2L["7d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["7d"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["7d"]["BorderSizePixel"] = 0;
G2L["7d"]["TextWrapped"] = true;
G2L["7d"]["TextSize"] = 14;
G2L["7d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["7d"]["ClearTextOnFocus"] = false;
G2L["7d"]["PlaceholderText"] = [[Search]];
G2L["7d"]["Size"] = UDim2.new(0, 417, 0, 25);
G2L["7d"]["Position"] = UDim2.new(0.02374, 0, 0, 0);
G2L["7d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7d"]["Text"] = [[]];
G2L["7d"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.scripthub.searchbar.UIShadow
G2L["7e"] = Instance.new("UIShadow", G2L["7a"]);



-- StarterGui.zerohub.interface.main.tabs.ai
G2L["7f"] = Instance.new("Frame", G2L["1c"]);
G2L["7f"]["Visible"] = false;
G2L["7f"]["BorderSizePixel"] = 0;
G2L["7f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7f"]["Size"] = UDim2.new(0, 480, 0, 308);
G2L["7f"]["Position"] = UDim2.new(0, 0, 0, 0);
G2L["7f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7f"]["Name"] = [[ai]];
G2L["7f"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.ai.aicore
G2L["80"] = Instance.new("LocalScript", G2L["7f"]);
G2L["80"]["Name"] = [[aicore]];


-- StarterGui.zerohub.interface.main.tabs.ai.promptbox
G2L["81"] = Instance.new("Frame", G2L["7f"]);
G2L["81"]["BorderSizePixel"] = 0;
G2L["81"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["81"]["ClipsDescendants"] = true;
G2L["81"]["Size"] = UDim2.new(0, 449, 0, 42);
G2L["81"]["Position"] = UDim2.new(0.03073, 0, 0.82667, 0);
G2L["81"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["81"]["Name"] = [[promptbox]];
-- Attributes
G2L["81"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.ai.promptbox.UICorner
G2L["82"] = Instance.new("UICorner", G2L["81"]);



-- StarterGui.zerohub.interface.main.tabs.ai.promptbox.InputScroll
G2L["83"] = Instance.new("ScrollingFrame", G2L["81"]);
G2L["83"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
G2L["83"]["BorderSizePixel"] = 0;
G2L["83"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["83"]["Name"] = [[InputScroll]];
G2L["83"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["83"]["Size"] = UDim2.new(0.91369, -16, 1, -2);
G2L["83"]["ScrollBarImageColor3"] = Color3.fromRGB(81, 81, 81);
G2L["83"]["Position"] = UDim2.new(0, 8, 0, 1);
G2L["83"]["ScrollBarThickness"] = 2;
G2L["83"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.ai.promptbox.InputScroll.TextBox
G2L["84"] = Instance.new("TextBox", G2L["83"]);
G2L["84"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["84"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["84"]["BorderSizePixel"] = 0;
G2L["84"]["TextWrapped"] = true;
G2L["84"]["TextSize"] = 14;
G2L["84"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["84"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["84"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["84"]["RichText"] = true;
G2L["84"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["84"]["AutomaticSize"] = Enum.AutomaticSize.Y;
G2L["84"]["MultiLine"] = true;
G2L["84"]["ClearTextOnFocus"] = false;
G2L["84"]["PlaceholderText"] = [[Ask zerohub intelligence]];
G2L["84"]["Size"] = UDim2.new(1, 0, 0, 0);
G2L["84"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["84"]["Text"] = [[]];
G2L["84"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.ai.promptbox.InputScroll.UIPadding
G2L["85"] = Instance.new("UIPadding", G2L["83"]);
G2L["85"]["PaddingTop"] = UDim.new(0, 8);
G2L["85"]["PaddingRight"] = UDim.new(0, 4);
G2L["85"]["PaddingLeft"] = UDim.new(0, 4);
G2L["85"]["PaddingBottom"] = UDim.new(0, 8);


-- StarterGui.zerohub.interface.main.tabs.ai.promptbox.UIShadow
G2L["86"] = Instance.new("UIShadow", G2L["81"]);



-- StarterGui.zerohub.interface.main.tabs.ai.chatbox
G2L["87"] = Instance.new("Frame", G2L["7f"]);
G2L["87"]["BorderSizePixel"] = 0;
G2L["87"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["87"]["Size"] = UDim2.new(0, 449, 0, 220);
G2L["87"]["Position"] = UDim2.new(0.03073, 0, 0.10877, 0);
G2L["87"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["87"]["Name"] = [[chatbox]];
G2L["87"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.ai.chatbox.scroller
G2L["88"] = Instance.new("ScrollingFrame", G2L["87"]);
G2L["88"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
G2L["88"]["BorderSizePixel"] = 0;
G2L["88"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["88"]["Name"] = [[scroller]];
G2L["88"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["88"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["88"]["ScrollBarImageColor3"] = Color3.fromRGB(81, 81, 81);
G2L["88"]["ScrollBarThickness"] = 3;
G2L["88"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.ai.chatbox.scroller.UIListLayout
G2L["89"] = Instance.new("UIListLayout", G2L["88"]);
G2L["89"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
G2L["89"]["Padding"] = UDim.new(0, 6);
G2L["89"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.ai.chatbox.scroller.UIPadding
G2L["8a"] = Instance.new("UIPadding", G2L["88"]);
G2L["8a"]["PaddingTop"] = UDim.new(0, 6);
G2L["8a"]["PaddingRight"] = UDim.new(0, 6);
G2L["8a"]["PaddingLeft"] = UDim.new(0, 6);
G2L["8a"]["PaddingBottom"] = UDim.new(0, 6);


-- StarterGui.zerohub.interface.main.tabs.ai.ImageButton
G2L["8b"] = Instance.new("ImageButton", G2L["7f"]);
G2L["8b"]["BorderSizePixel"] = 0;
G2L["8b"]["BackgroundTransparency"] = 1;
G2L["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8b"]["Image"] = [[rbxassetid://10709768939]];
G2L["8b"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["8b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8b"]["Position"] = UDim2.new(0.89385, 0, 0.86333, 0);


-- StarterGui.zerohub.interface.main.tabs.ai.ImageButton.UICorner
G2L["8c"] = Instance.new("UICorner", G2L["8b"]);



-- StarterGui.zerohub.interface.main.tabs.teleport
G2L["8d"] = Instance.new("Frame", G2L["1c"]);
G2L["8d"]["Visible"] = false;
G2L["8d"]["BorderSizePixel"] = 0;
G2L["8d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8d"]["Size"] = UDim2.new(0, 480, 0, 276);
G2L["8d"]["Position"] = UDim2.new(-0, 0, 0.1068, 0);
G2L["8d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8d"]["Name"] = [[teleport]];
G2L["8d"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs
G2L["8e"] = Instance.new("Folder", G2L["8d"]);
G2L["8e"]["Name"] = [[teleporttabs]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server
G2L["8f"] = Instance.new("Frame", G2L["8e"]);
G2L["8f"]["BorderSizePixel"] = 0;
G2L["8f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8f"]["Size"] = UDim2.new(0, 462, 0, 246);
G2L["8f"]["Position"] = UDim2.new(0.01875, 0, 0.10768, 0);
G2L["8f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8f"]["Name"] = [[server]];
G2L["8f"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame
G2L["90"] = Instance.new("ScrollingFrame", G2L["8f"]);
G2L["90"]["Active"] = true;
G2L["90"]["BorderSizePixel"] = 0;
G2L["90"]["CanvasSize"] = UDim2.new(0, 0, 1.55, 0);
G2L["90"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["90"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["90"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["90"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["90"]["ScrollBarThickness"] = 0;
G2L["90"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.UIListLayout
G2L["91"] = Instance.new("UIListLayout", G2L["90"]);
G2L["91"]["Padding"] = UDim.new(0, 8);
G2L["91"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid
G2L["92"] = Instance.new("Frame", G2L["90"]);
G2L["92"]["BorderSizePixel"] = 0;
G2L["92"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["92"]["Size"] = UDim2.new(0, 462, 0, 87);
G2L["92"]["Position"] = UDim2.new(-0, 0, 0, 0);
G2L["92"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["92"]["Name"] = [[jobid]];
-- Attributes
G2L["92"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.UICorner
G2L["93"] = Instance.new("UICorner", G2L["92"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextLabel
G2L["94"] = Instance.new("TextLabel", G2L["92"]);
G2L["94"]["TextWrapped"] = true;
G2L["94"]["BorderSizePixel"] = 0;
G2L["94"]["TextSize"] = 20;
G2L["94"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["94"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["94"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["94"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["94"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["94"]["BackgroundTransparency"] = 1;
G2L["94"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["94"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["94"]["Text"] = [[Custom J*b ID]];
G2L["94"]["Position"] = UDim2.new(0.02485, 0, 0.09102, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextLabel
G2L["95"] = Instance.new("TextLabel", G2L["92"]);
G2L["95"]["TextWrapped"] = true;
G2L["95"]["BorderSizePixel"] = 0;
G2L["95"]["TextSize"] = 14;
G2L["95"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["95"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["95"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["95"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["95"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["95"]["BackgroundTransparency"] = 1;
G2L["95"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["95"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["95"]["Text"] = [[Teleport to a specific instance given J*bID.]];
G2L["95"]["Position"] = UDim2.new(0.02485, 0, 0.29354, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextBox
G2L["96"] = Instance.new("TextBox", G2L["92"]);
G2L["96"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["96"]["BorderSizePixel"] = 0;
G2L["96"]["TextSize"] = 12;
G2L["96"]["TextColor3"] = Color3.fromRGB(41, 41, 41);
G2L["96"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["96"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["96"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["96"]["PlaceholderText"] = [[insert j*b id here, enter to teleport, will be hidden]];
G2L["96"]["Size"] = UDim2.new(0, 447, 0, 24);
G2L["96"]["Position"] = UDim2.new(0.5, 0, 0.615, 0);
G2L["96"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["96"]["Text"] = [[]];
-- Attributes
G2L["96"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextBox.LocalScript
G2L["97"] = Instance.new("LocalScript", G2L["96"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextBox.UICorner
G2L["98"] = Instance.new("UICorner", G2L["96"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin
G2L["99"] = Instance.new("Frame", G2L["90"]);
G2L["99"]["BorderSizePixel"] = 0;
G2L["99"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["99"]["Size"] = UDim2.new(0, 461, 0, 87);
G2L["99"]["Position"] = UDim2.new(0, 0, 0.24136, 0);
G2L["99"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["99"]["Name"] = [[rejoin]];
-- Attributes
G2L["99"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.UICorner
G2L["9a"] = Instance.new("UICorner", G2L["99"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextLabel
G2L["9b"] = Instance.new("TextLabel", G2L["99"]);
G2L["9b"]["TextWrapped"] = true;
G2L["9b"]["BorderSizePixel"] = 0;
G2L["9b"]["TextSize"] = 20;
G2L["9b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["9b"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["9b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["9b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9b"]["BackgroundTransparency"] = 1;
G2L["9b"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["9b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9b"]["Text"] = [[Rejoin]];
G2L["9b"]["Position"] = UDim2.new(0.01608, 0, 0.08, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextLabel
G2L["9c"] = Instance.new("TextLabel", G2L["99"]);
G2L["9c"]["TextWrapped"] = true;
G2L["9c"]["BorderSizePixel"] = 0;
G2L["9c"]["TextSize"] = 14;
G2L["9c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["9c"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["9c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9c"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["9c"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["9c"]["BackgroundTransparency"] = 1;
G2L["9c"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["9c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9c"]["Text"] = [[Rejoin the current server.]];
G2L["9c"]["Position"] = UDim2.new(0.01608, 0, 0.31668, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton
G2L["9d"] = Instance.new("TextButton", G2L["99"]);
G2L["9d"]["BorderSizePixel"] = 0;
G2L["9d"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["9d"]["TextSize"] = 14;
G2L["9d"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["9d"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["9d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["9d"]["Size"] = UDim2.new(0, 72, 0, 24);
G2L["9d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9d"]["Text"] = [[Rejoin  ]];
G2L["9d"]["Position"] = UDim2.new(0.82898, 0, 0.63749, 0);
-- Attributes
G2L["9d"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.anim
G2L["9e"] = Instance.new("LocalScript", G2L["9d"]);
G2L["9e"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.LocalScript
G2L["9f"] = Instance.new("LocalScript", G2L["9d"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.UICorner
G2L["a0"] = Instance.new("UICorner", G2L["9d"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.ImageLabel
G2L["a1"] = Instance.new("ImageLabel", G2L["9d"]);
G2L["a1"]["BorderSizePixel"] = 0;
G2L["a1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a1"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["a1"]["Image"] = [[rbxassetid://10734933966]];
G2L["a1"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["a1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a1"]["BackgroundTransparency"] = 1;
G2L["a1"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop
G2L["a2"] = Instance.new("Frame", G2L["90"]);
G2L["a2"]["BorderSizePixel"] = 0;
G2L["a2"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["a2"]["Size"] = UDim2.new(0, 461, 0, 87);
G2L["a2"]["Position"] = UDim2.new(0, 0, 0.48272, 0);
G2L["a2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a2"]["Name"] = [[serverhop]];
-- Attributes
G2L["a2"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.UICorner
G2L["a3"] = Instance.new("UICorner", G2L["a2"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextLabel
G2L["a4"] = Instance.new("TextLabel", G2L["a2"]);
G2L["a4"]["TextWrapped"] = true;
G2L["a4"]["BorderSizePixel"] = 0;
G2L["a4"]["TextSize"] = 20;
G2L["a4"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["a4"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["a4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a4"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["a4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a4"]["BackgroundTransparency"] = 1;
G2L["a4"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["a4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a4"]["Text"] = [[Server hop]];
G2L["a4"]["Position"] = UDim2.new(0.01397, 0, 0.11401, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextLabel
G2L["a5"] = Instance.new("TextLabel", G2L["a2"]);
G2L["a5"]["TextWrapped"] = true;
G2L["a5"]["BorderSizePixel"] = 0;
G2L["a5"]["TextSize"] = 14;
G2L["a5"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["a5"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["a5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a5"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["a5"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["a5"]["BackgroundTransparency"] = 1;
G2L["a5"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["a5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a5"]["Text"] = [[Quickly switch servers.]];
G2L["a5"]["Position"] = UDim2.new(0.01614, 0, 0.31653, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton
G2L["a6"] = Instance.new("TextButton", G2L["a2"]);
G2L["a6"]["BorderSizePixel"] = 0;
G2L["a6"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["a6"]["TextSize"] = 14;
G2L["a6"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["a6"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["a6"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["a6"]["Size"] = UDim2.new(0, 102, 0, 24);
G2L["a6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a6"]["Text"] = [[Server hop  ]];
G2L["a6"]["Position"] = UDim2.new(0.76369, 0, 0.62649, 0);
-- Attributes
G2L["a6"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.anim
G2L["a7"] = Instance.new("LocalScript", G2L["a6"]);
G2L["a7"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.LocalScript
G2L["a8"] = Instance.new("LocalScript", G2L["a6"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.UICorner
G2L["a9"] = Instance.new("UICorner", G2L["a6"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.ImageLabel
G2L["aa"] = Instance.new("ImageLabel", G2L["a6"]);
G2L["aa"]["BorderSizePixel"] = 0;
G2L["aa"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["aa"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["aa"]["Image"] = [[rbxassetid://10709768019]];
G2L["aa"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["aa"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["aa"]["BackgroundTransparency"] = 1;
G2L["aa"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver
G2L["ab"] = Instance.new("Frame", G2L["90"]);
G2L["ab"]["BorderSizePixel"] = 0;
G2L["ab"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["ab"]["Size"] = UDim2.new(0, 461, 0, 87);
G2L["ab"]["Position"] = UDim2.new(0, 0, 0.72307, 0);
G2L["ab"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["ab"]["Name"] = [[smallserver]];
-- Attributes
G2L["ab"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.UICorner
G2L["ac"] = Instance.new("UICorner", G2L["ab"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextLabel
G2L["ad"] = Instance.new("TextLabel", G2L["ab"]);
G2L["ad"]["TextWrapped"] = true;
G2L["ad"]["BorderSizePixel"] = 0;
G2L["ad"]["TextSize"] = 20;
G2L["ad"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["ad"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["ad"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ad"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["ad"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ad"]["BackgroundTransparency"] = 1;
G2L["ad"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["ad"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["ad"]["Text"] = [[Small server]];
G2L["ad"]["Position"] = UDim2.new(0.01614, 0, 0.10252, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextLabel
G2L["ae"] = Instance.new("TextLabel", G2L["ab"]);
G2L["ae"]["TextWrapped"] = true;
G2L["ae"]["BorderSizePixel"] = 0;
G2L["ae"]["TextSize"] = 14;
G2L["ae"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["ae"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["ae"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ae"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["ae"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["ae"]["BackgroundTransparency"] = 1;
G2L["ae"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["ae"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["ae"]["Text"] = [[Teleport to the smallest server.]];
G2L["ae"]["Position"] = UDim2.new(0.01614, 0, 0.30503, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton
G2L["af"] = Instance.new("TextButton", G2L["ab"]);
G2L["af"]["BorderSizePixel"] = 0;
G2L["af"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["af"]["TextSize"] = 14;
G2L["af"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["af"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["af"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["af"]["Size"] = UDim2.new(0, 86, 0, 24);
G2L["af"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["af"]["Text"] = [[Teleport  ]];
G2L["af"]["Position"] = UDim2.new(0.79801, 0, 0.615, 0);
-- Attributes
G2L["af"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.anim
G2L["b0"] = Instance.new("LocalScript", G2L["af"]);
G2L["b0"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.LocalScript
G2L["b1"] = Instance.new("LocalScript", G2L["af"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.UICorner
G2L["b2"] = Instance.new("UICorner", G2L["af"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.ImageLabel
G2L["b3"] = Instance.new("ImageLabel", G2L["af"]);
G2L["b3"]["BorderSizePixel"] = 0;
G2L["b3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b3"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["b3"]["Image"] = [[rbxassetid://10709768787]];
G2L["b3"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["b3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b3"]["BackgroundTransparency"] = 1;
G2L["b3"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information
G2L["b4"] = Instance.new("Frame", G2L["8e"]);
G2L["b4"]["Visible"] = false;
G2L["b4"]["BorderSizePixel"] = 0;
G2L["b4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b4"]["Size"] = UDim2.new(0, 461, 0, 191);
G2L["b4"]["Position"] = UDim2.new(0.01875, 0, 0.1113, 0);
G2L["b4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b4"]["Name"] = [[information]];
G2L["b4"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid
G2L["b5"] = Instance.new("Frame", G2L["b4"]);
G2L["b5"]["BorderSizePixel"] = 0;
G2L["b5"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["b5"]["Size"] = UDim2.new(0, 458, 0, 87);
G2L["b5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b5"]["Name"] = [[placeid]];
-- Attributes
G2L["b5"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.UICorner
G2L["b6"] = Instance.new("UICorner", G2L["b5"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextLabel
G2L["b7"] = Instance.new("TextLabel", G2L["b5"]);
G2L["b7"]["TextWrapped"] = true;
G2L["b7"]["BorderSizePixel"] = 0;
G2L["b7"]["TextSize"] = 20;
G2L["b7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b7"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["b7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b7"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b7"]["BackgroundTransparency"] = 1;
G2L["b7"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["b7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b7"]["Text"] = [[Place ID]];
G2L["b7"]["Position"] = UDim2.new(0.02466, 0, 0.09149, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextLabel
G2L["b8"] = Instance.new("TextLabel", G2L["b5"]);
G2L["b8"]["TextWrapped"] = true;
G2L["b8"]["BorderSizePixel"] = 0;
G2L["b8"]["TextSize"] = 14;
G2L["b8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b8"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["b8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b8"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b8"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["b8"]["BackgroundTransparency"] = 1;
G2L["b8"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["b8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b8"]["Text"] = [[AKA the game ID, won't be shown here for privacy.]];
G2L["b8"]["Position"] = UDim2.new(0.02466, 0, 0.30519, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton
G2L["b9"] = Instance.new("TextButton", G2L["b5"]);
G2L["b9"]["BorderSizePixel"] = 0;
G2L["b9"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["b9"]["TextSize"] = 14;
G2L["b9"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["b9"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["b9"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b9"]["Size"] = UDim2.new(0, 65, 0, 24);
G2L["b9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b9"]["Text"] = [[Copy  ]];
G2L["b9"]["Position"] = UDim2.new(0.83664, 0, 0.6145, 0);
-- Attributes
G2L["b9"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.anim
G2L["ba"] = Instance.new("LocalScript", G2L["b9"]);
G2L["ba"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.LocalScript
G2L["bb"] = Instance.new("LocalScript", G2L["b9"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.UICorner
G2L["bc"] = Instance.new("UICorner", G2L["b9"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.ImageLabel
G2L["bd"] = Instance.new("ImageLabel", G2L["b9"]);
G2L["bd"]["BorderSizePixel"] = 0;
G2L["bd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["bd"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["bd"]["Image"] = [[rbxassetid://10709812159]];
G2L["bd"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["bd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["bd"]["BackgroundTransparency"] = 1;
G2L["bd"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid
G2L["be"] = Instance.new("Frame", G2L["b4"]);
G2L["be"]["BorderSizePixel"] = 0;
G2L["be"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["be"]["Size"] = UDim2.new(0, 458, 0, 87);
G2L["be"]["Position"] = UDim2.new(0, 0, 0.38153, 0);
G2L["be"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["be"]["Name"] = [[jobid]];
-- Attributes
G2L["be"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.UICorner
G2L["bf"] = Instance.new("UICorner", G2L["be"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextLabel
G2L["c0"] = Instance.new("TextLabel", G2L["be"]);
G2L["c0"]["TextWrapped"] = true;
G2L["c0"]["BorderSizePixel"] = 0;
G2L["c0"]["TextSize"] = 20;
G2L["c0"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["c0"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["c0"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c0"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["c0"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c0"]["BackgroundTransparency"] = 1;
G2L["c0"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["c0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c0"]["Text"] = [[J*b ID]];
G2L["c0"]["Position"] = UDim2.new(0.02466, 0, 0.10299, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextLabel
G2L["c1"] = Instance.new("TextLabel", G2L["be"]);
G2L["c1"]["TextWrapped"] = true;
G2L["c1"]["BorderSizePixel"] = 0;
G2L["c1"]["TextSize"] = 14;
G2L["c1"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["c1"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["c1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c1"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["c1"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["c1"]["BackgroundTransparency"] = 1;
G2L["c1"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["c1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c1"]["Text"] = [[The current instance. Hidden for privacy.]];
G2L["c1"]["Position"] = UDim2.new(0.02466, 0, 0.33967, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton
G2L["c2"] = Instance.new("TextButton", G2L["be"]);
G2L["c2"]["BorderSizePixel"] = 0;
G2L["c2"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["c2"]["TextSize"] = 14;
G2L["c2"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["c2"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["c2"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["c2"]["Size"] = UDim2.new(0, 65, 0, 24);
G2L["c2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c2"]["Text"] = [[Copy  ]];
G2L["c2"]["Position"] = UDim2.new(0.83664, 0, 0.58002, 0);
-- Attributes
G2L["c2"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.anim
G2L["c3"] = Instance.new("LocalScript", G2L["c2"]);
G2L["c3"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.LocalScript
G2L["c4"] = Instance.new("LocalScript", G2L["c2"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.UICorner
G2L["c5"] = Instance.new("UICorner", G2L["c2"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.ImageLabel
G2L["c6"] = Instance.new("ImageLabel", G2L["c2"]);
G2L["c6"]["BorderSizePixel"] = 0;
G2L["c6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c6"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["c6"]["Image"] = [[rbxassetid://10709812159]];
G2L["c6"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["c6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c6"]["BackgroundTransparency"] = 1;
G2L["c6"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.UIListLayout
G2L["c7"] = Instance.new("UIListLayout", G2L["b4"]);
G2L["c7"]["Padding"] = UDim.new(0, 8);
G2L["c7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.teleport.tabsw
G2L["c8"] = Instance.new("LocalScript", G2L["8d"]);
G2L["c8"]["Name"] = [[tabsw]];


-- StarterGui.zerohub.interface.main.tabs.teleport.top
G2L["c9"] = Instance.new("Frame", G2L["8d"]);
G2L["c9"]["BorderSizePixel"] = 0;
G2L["c9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c9"]["Size"] = UDim2.new(0, 409, 0, 33);
G2L["c9"]["Position"] = UDim2.new(0.01875, 0, -0.02174, 0);
G2L["c9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c9"]["Name"] = [[top]];
G2L["c9"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.teleport.top.UIListLayout
G2L["ca"] = Instance.new("UIListLayout", G2L["c9"]);
G2L["ca"]["Padding"] = UDim.new(0, 5);
G2L["ca"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
G2L["ca"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["ca"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.teleport.top.server
G2L["cb"] = Instance.new("TextButton", G2L["c9"]);
G2L["cb"]["BorderSizePixel"] = 0;
G2L["cb"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["cb"]["TextSize"] = 14;
G2L["cb"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["cb"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["cb"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["cb"]["Size"] = UDim2.new(0, 75, 0, 23);
G2L["cb"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["cb"]["Text"] = [[Server  ]];
G2L["cb"]["Name"] = [[server]];
G2L["cb"]["Position"] = UDim2.new(0, 0, 0.26042, 0);
-- Attributes
G2L["cb"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.tabs.teleport.top.server.UICorner
G2L["cc"] = Instance.new("UICorner", G2L["cb"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.top.server.ImageLabel
G2L["cd"] = Instance.new("ImageLabel", G2L["cb"]);
G2L["cd"]["BorderSizePixel"] = 0;
G2L["cd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["cd"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["cd"]["Image"] = [[rbxassetid://10734949856]];
G2L["cd"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["cd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["cd"]["BackgroundTransparency"] = 1;
G2L["cd"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.teleport.top.information
G2L["ce"] = Instance.new("TextButton", G2L["c9"]);
G2L["ce"]["BorderSizePixel"] = 0;
G2L["ce"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["ce"]["TextSize"] = 14;
G2L["ce"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["ce"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["ce"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["ce"]["Size"] = UDim2.new(0, 104, 0, 23);
G2L["ce"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["ce"]["Text"] = [[Information  ]];
G2L["ce"]["Name"] = [[information]];
G2L["ce"]["Position"] = UDim2.new(0.22923, 0, 0.26042, 0);
-- Attributes
G2L["ce"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.teleport.top.information.UICorner
G2L["cf"] = Instance.new("UICorner", G2L["ce"]);



-- StarterGui.zerohub.interface.main.tabs.teleport.top.information.ImageLabel
G2L["d0"] = Instance.new("ImageLabel", G2L["ce"]);
G2L["d0"]["BorderSizePixel"] = 0;
G2L["d0"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d0"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["d0"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["d0"]["Image"] = [[rbxassetid://10723415903]];
G2L["d0"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["d0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d0"]["BackgroundTransparency"] = 1;
G2L["d0"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.musicplayer
G2L["d1"] = Instance.new("Frame", G2L["1c"]);
G2L["d1"]["Visible"] = false;
G2L["d1"]["BorderSizePixel"] = 0;
G2L["d1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d1"]["Size"] = UDim2.new(0, 480, 0, 275);
G2L["d1"]["Position"] = UDim2.new(0, 0, 0.10841, 0);
G2L["d1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d1"]["Name"] = [[musicplayer]];
G2L["d1"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.musicplayer.maybachmusiclol
G2L["d2"] = Instance.new("Sound", G2L["d1"]);
G2L["d2"]["RollOffMode"] = Enum.RollOffMode.InverseTapered;
G2L["d2"]["Name"] = [[maybachmusiclol]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.pp
G2L["d3"] = Instance.new("Frame", G2L["d1"]);
G2L["d3"]["BorderSizePixel"] = 0;
G2L["d3"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["d3"]["Size"] = UDim2.new(0, 30, 0, 30);
G2L["d3"]["Position"] = UDim2.new(0.01906, 0, 0.87894, 0);
G2L["d3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d3"]["Name"] = [[pp]];
-- Attributes
G2L["d3"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.musicplayer.pp.UICorner
G2L["d4"] = Instance.new("UICorner", G2L["d3"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.pp.ImageButton
G2L["d5"] = Instance.new("ImageButton", G2L["d3"]);
G2L["d5"]["BorderSizePixel"] = 0;
G2L["d5"]["BackgroundTransparency"] = 1;
G2L["d5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["d5"]["Image"] = [[rbxassetid://10734923549]];
G2L["d5"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["d5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.musicplayer.pp.ImageButton.LocalScript
G2L["d6"] = Instance.new("LocalScript", G2L["d5"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.url
G2L["d7"] = Instance.new("Frame", G2L["d1"]);
G2L["d7"]["BorderSizePixel"] = 0;
G2L["d7"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["d7"]["Size"] = UDim2.new(0, 461, 0, 30);
G2L["d7"]["Position"] = UDim2.new(0.01962, 0, 0.74924, 0);
G2L["d7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d7"]["Name"] = [[url]];
-- Attributes
G2L["d7"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.musicplayer.url.UICorner
G2L["d8"] = Instance.new("UICorner", G2L["d7"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.url.ImageLabel
G2L["d9"] = Instance.new("ImageLabel", G2L["d7"]);
G2L["d9"]["BorderSizePixel"] = 0;
G2L["d9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d9"]["Image"] = [[rbxassetid://10723404337]];
G2L["d9"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["d9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d9"]["BackgroundTransparency"] = 1;
G2L["d9"]["Position"] = UDim2.new(0.01371, 0, 0.233, 0);


-- StarterGui.zerohub.interface.main.tabs.musicplayer.url.t
G2L["da"] = Instance.new("TextBox", G2L["d7"]);
G2L["da"]["Name"] = [[t]];
G2L["da"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["da"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["da"]["BorderSizePixel"] = 0;
G2L["da"]["TextWrapped"] = true;
G2L["da"]["TextSize"] = 14;
G2L["da"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["da"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["da"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["da"]["ClearTextOnFocus"] = false;
G2L["da"]["PlaceholderText"] = [[mp3 url or roblox id to play (enter to play)]];
G2L["da"]["Size"] = UDim2.new(0, 431, 0, 27);
G2L["da"]["Position"] = UDim2.new(0.0645, 0, 0, 0);
G2L["da"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["da"]["Text"] = [[]];
G2L["da"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.musicplayer.url.t.LocalScript
G2L["db"] = Instance.new("LocalScript", G2L["da"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.av
G2L["dc"] = Instance.new("TextLabel", G2L["d1"]);
G2L["dc"]["BorderSizePixel"] = 0;
G2L["dc"]["TextSize"] = 14;
G2L["dc"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["dc"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["dc"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["dc"]["BackgroundTransparency"] = 1;
G2L["dc"]["Size"] = UDim2.new(0, 461, 0, 201);
G2L["dc"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["dc"]["Text"] = [[]];
G2L["dc"]["Name"] = [[av]];
G2L["dc"]["Position"] = UDim2.new(0.01906, 0, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.LocalScript
G2L["dd"] = Instance.new("LocalScript", G2L["dc"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["de"] = Instance.new("Frame", G2L["dc"]);
G2L["de"]["BorderSizePixel"] = 0;
G2L["de"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["de"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["de"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["de"]["Position"] = UDim2.new(0, 0, 1, 0);
G2L["de"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["df"] = Instance.new("Frame", G2L["dc"]);
G2L["df"]["BorderSizePixel"] = 0;
G2L["df"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["df"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["df"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["df"]["Position"] = UDim2.new(0.03137, 0, 1, 0);
G2L["df"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e0"] = Instance.new("Frame", G2L["dc"]);
G2L["e0"]["BorderSizePixel"] = 0;
G2L["e0"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e0"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e0"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e0"]["Position"] = UDim2.new(0.06275, 0, 1, 0);
G2L["e0"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e1"] = Instance.new("Frame", G2L["dc"]);
G2L["e1"]["BorderSizePixel"] = 0;
G2L["e1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e1"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e1"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e1"]["Position"] = UDim2.new(0.09413, 0, 1, 0);
G2L["e1"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e2"] = Instance.new("Frame", G2L["dc"]);
G2L["e2"]["BorderSizePixel"] = 0;
G2L["e2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e2"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e2"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e2"]["Position"] = UDim2.new(0.1255, 0, 1, 0);
G2L["e2"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e3"] = Instance.new("Frame", G2L["dc"]);
G2L["e3"]["BorderSizePixel"] = 0;
G2L["e3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e3"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e3"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e3"]["Position"] = UDim2.new(0.15687, 0, 1, 0);
G2L["e3"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e4"] = Instance.new("Frame", G2L["dc"]);
G2L["e4"]["BorderSizePixel"] = 0;
G2L["e4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e4"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e4"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e4"]["Position"] = UDim2.new(0.18825, 0, 1, 0);
G2L["e4"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e5"] = Instance.new("Frame", G2L["dc"]);
G2L["e5"]["BorderSizePixel"] = 0;
G2L["e5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e5"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e5"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e5"]["Position"] = UDim2.new(0.21962, 0, 1, 0);
G2L["e5"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e6"] = Instance.new("Frame", G2L["dc"]);
G2L["e6"]["BorderSizePixel"] = 0;
G2L["e6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e6"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e6"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e6"]["Position"] = UDim2.new(0.251, 0, 1, 0);
G2L["e6"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e7"] = Instance.new("Frame", G2L["dc"]);
G2L["e7"]["BorderSizePixel"] = 0;
G2L["e7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e7"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e7"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e7"]["Position"] = UDim2.new(0.28238, 0, 1, 0);
G2L["e7"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e8"] = Instance.new("Frame", G2L["dc"]);
G2L["e8"]["BorderSizePixel"] = 0;
G2L["e8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e8"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e8"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e8"]["Position"] = UDim2.new(0.31375, 0, 1, 0);
G2L["e8"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["e9"] = Instance.new("Frame", G2L["dc"]);
G2L["e9"]["BorderSizePixel"] = 0;
G2L["e9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e9"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["e9"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["e9"]["Position"] = UDim2.new(0.34512, 0, 1, 0);
G2L["e9"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["ea"] = Instance.new("Frame", G2L["dc"]);
G2L["ea"]["BorderSizePixel"] = 0;
G2L["ea"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ea"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["ea"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["ea"]["Position"] = UDim2.new(0.3765, 0, 1, 0);
G2L["ea"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["eb"] = Instance.new("Frame", G2L["dc"]);
G2L["eb"]["BorderSizePixel"] = 0;
G2L["eb"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["eb"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["eb"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["eb"]["Position"] = UDim2.new(0.40788, 0, 1, 0);
G2L["eb"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["ec"] = Instance.new("Frame", G2L["dc"]);
G2L["ec"]["BorderSizePixel"] = 0;
G2L["ec"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ec"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["ec"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["ec"]["Position"] = UDim2.new(0.43925, 0, 1, 0);
G2L["ec"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["ed"] = Instance.new("Frame", G2L["dc"]);
G2L["ed"]["BorderSizePixel"] = 0;
G2L["ed"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ed"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["ed"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["ed"]["Position"] = UDim2.new(0.47063, 0, 1, 0);
G2L["ed"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["ee"] = Instance.new("Frame", G2L["dc"]);
G2L["ee"]["BorderSizePixel"] = 0;
G2L["ee"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ee"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["ee"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["ee"]["Position"] = UDim2.new(0.502, 0, 1, 0);
G2L["ee"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["ef"] = Instance.new("Frame", G2L["dc"]);
G2L["ef"]["BorderSizePixel"] = 0;
G2L["ef"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ef"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["ef"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["ef"]["Position"] = UDim2.new(0.53338, 0, 1, 0);
G2L["ef"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f0"] = Instance.new("Frame", G2L["dc"]);
G2L["f0"]["BorderSizePixel"] = 0;
G2L["f0"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f0"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f0"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f0"]["Position"] = UDim2.new(0.56475, 0, 1, 0);
G2L["f0"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f1"] = Instance.new("Frame", G2L["dc"]);
G2L["f1"]["BorderSizePixel"] = 0;
G2L["f1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f1"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f1"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f1"]["Position"] = UDim2.new(0.59613, 0, 1, 0);
G2L["f1"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f2"] = Instance.new("Frame", G2L["dc"]);
G2L["f2"]["BorderSizePixel"] = 0;
G2L["f2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f2"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f2"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f2"]["Position"] = UDim2.new(0.6275, 0, 1, 0);
G2L["f2"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f3"] = Instance.new("Frame", G2L["dc"]);
G2L["f3"]["BorderSizePixel"] = 0;
G2L["f3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f3"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f3"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f3"]["Position"] = UDim2.new(0.65887, 0, 1, 0);
G2L["f3"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f4"] = Instance.new("Frame", G2L["dc"]);
G2L["f4"]["BorderSizePixel"] = 0;
G2L["f4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f4"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f4"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f4"]["Position"] = UDim2.new(0.69025, 0, 1, 0);
G2L["f4"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f5"] = Instance.new("Frame", G2L["dc"]);
G2L["f5"]["BorderSizePixel"] = 0;
G2L["f5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f5"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f5"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f5"]["Position"] = UDim2.new(0.72162, 0, 1, 0);
G2L["f5"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f6"] = Instance.new("Frame", G2L["dc"]);
G2L["f6"]["BorderSizePixel"] = 0;
G2L["f6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f6"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f6"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f6"]["Position"] = UDim2.new(0.753, 0, 1, 0);
G2L["f6"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f7"] = Instance.new("Frame", G2L["dc"]);
G2L["f7"]["BorderSizePixel"] = 0;
G2L["f7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f7"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f7"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f7"]["Position"] = UDim2.new(0.78438, 0, 1, 0);
G2L["f7"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f8"] = Instance.new("Frame", G2L["dc"]);
G2L["f8"]["BorderSizePixel"] = 0;
G2L["f8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f8"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f8"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f8"]["Position"] = UDim2.new(0.81575, 0, 1, 0);
G2L["f8"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["f9"] = Instance.new("Frame", G2L["dc"]);
G2L["f9"]["BorderSizePixel"] = 0;
G2L["f9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f9"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["f9"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["f9"]["Position"] = UDim2.new(0.84712, 0, 1, 0);
G2L["f9"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["fa"] = Instance.new("Frame", G2L["dc"]);
G2L["fa"]["BorderSizePixel"] = 0;
G2L["fa"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["fa"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["fa"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["fa"]["Position"] = UDim2.new(0.8785, 0, 1, 0);
G2L["fa"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["fb"] = Instance.new("Frame", G2L["dc"]);
G2L["fb"]["BorderSizePixel"] = 0;
G2L["fb"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["fb"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["fb"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["fb"]["Position"] = UDim2.new(0.90987, 0, 1, 0);
G2L["fb"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["fc"] = Instance.new("Frame", G2L["dc"]);
G2L["fc"]["BorderSizePixel"] = 0;
G2L["fc"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["fc"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["fc"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["fc"]["Position"] = UDim2.new(0.94125, 0, 1, 0);
G2L["fc"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.CavaBar
G2L["fd"] = Instance.new("Frame", G2L["dc"]);
G2L["fd"]["BorderSizePixel"] = 0;
G2L["fd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["fd"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["fd"]["Size"] = UDim2.new(0.02737, 0, 0.05, 0);
G2L["fd"]["Position"] = UDim2.new(0.97263, 0, 1, 0);
G2L["fd"]["Name"] = [[CavaBar]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar
G2L["fe"] = Instance.new("Frame", G2L["d1"]);
G2L["fe"]["BorderSizePixel"] = 0;
G2L["fe"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["fe"]["ClipsDescendants"] = true;
G2L["fe"]["Size"] = UDim2.new(0, 343, 0, 29);
G2L["fe"]["Position"] = UDim2.new(0.265, 0, 0.879, 0);
G2L["fe"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["fe"]["Name"] = [[progressbar]];
-- Attributes
G2L["fe"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar.ProgressScript
G2L["ff"] = Instance.new("LocalScript", G2L["fe"]);
G2L["ff"]["Name"] = [[ProgressScript]];


-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar.UICorner
G2L["100"] = Instance.new("UICorner", G2L["fe"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar.Frame
G2L["101"] = Instance.new("Frame", G2L["fe"]);
G2L["101"]["BorderSizePixel"] = 0;
G2L["101"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["101"]["Size"] = UDim2.new(0, 199, 0, 29);
G2L["101"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
-- Attributes
G2L["101"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar.Frame.UICorner
G2L["102"] = Instance.new("UICorner", G2L["101"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressok
G2L["103"] = Instance.new("Frame", G2L["d1"]);
G2L["103"]["BorderSizePixel"] = 0;
G2L["103"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["103"]["Size"] = UDim2.new(0, 78, 0, 29);
G2L["103"]["Position"] = UDim2.new(0.09, 0, 0.883, 0);
G2L["103"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["103"]["Name"] = [[progressok]];
-- Attributes
G2L["103"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressok.UICorner
G2L["104"] = Instance.new("UICorner", G2L["103"]);



-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressok.TextLabel
G2L["105"] = Instance.new("TextLabel", G2L["103"]);
G2L["105"]["TextWrapped"] = true;
G2L["105"]["BorderSizePixel"] = 0;
G2L["105"]["TextSize"] = 14;
G2L["105"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["105"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["105"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["105"]["BackgroundTransparency"] = 1;
G2L["105"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["105"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["105"]["Text"] = [[1:28]];


-- StarterGui.zerohub.interface.main.tabs.console
G2L["106"] = Instance.new("Frame", G2L["1c"]);
G2L["106"]["Visible"] = false;
G2L["106"]["BorderSizePixel"] = 0;
G2L["106"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["106"]["Size"] = UDim2.new(0, 480, 0, 276);
G2L["106"]["Position"] = UDim2.new(-0, 0, 0.1068, 0);
G2L["106"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["106"]["Name"] = [[console]];
G2L["106"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder
G2L["107"] = Instance.new("Frame", G2L["106"]);
G2L["107"]["BorderSizePixel"] = 0;
G2L["107"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["107"]["Size"] = UDim2.new(0, 341, 0, 37);
G2L["107"]["Position"] = UDim2.new(0.27026, 0, 0.87333, 0);
G2L["107"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["107"]["Name"] = [[buttonsholder]];
G2L["107"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear
G2L["108"] = Instance.new("TextButton", G2L["107"]);
G2L["108"]["BorderSizePixel"] = 0;
G2L["108"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["108"]["TextSize"] = 14;
G2L["108"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["108"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["108"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["108"]["Size"] = UDim2.new(0, 62, 0, 24);
G2L["108"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["108"]["Text"] = [[Clear  ]];
G2L["108"]["Name"] = [[clear]];
G2L["108"]["Position"] = UDim2.new(0.41935, 0, 0.17568, 0);
-- Attributes
G2L["108"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.anim
G2L["109"] = Instance.new("LocalScript", G2L["108"]);
G2L["109"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.LocalScript
G2L["10a"] = Instance.new("LocalScript", G2L["108"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.UICorner
G2L["10b"] = Instance.new("UICorner", G2L["108"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.ImageLabel
G2L["10c"] = Instance.new("ImageLabel", G2L["108"]);
G2L["10c"]["BorderSizePixel"] = 0;
G2L["10c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10c"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["10c"]["Image"] = [[rbxassetid://10709819059]];
G2L["10c"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["10c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10c"]["BackgroundTransparency"] = 1;
G2L["10c"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.UIListLayout
G2L["10d"] = Instance.new("UIListLayout", G2L["107"]);
G2L["10d"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
G2L["10d"]["Padding"] = UDim.new(0, 5);
G2L["10d"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
G2L["10d"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["10d"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save
G2L["10e"] = Instance.new("TextButton", G2L["107"]);
G2L["10e"]["BorderSizePixel"] = 0;
G2L["10e"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["10e"]["TextSize"] = 14;
G2L["10e"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["10e"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["10e"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["10e"]["Size"] = UDim2.new(0, 62, 0, 24);
G2L["10e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10e"]["Text"] = [[Save  ]];
G2L["10e"]["Name"] = [[save]];
G2L["10e"]["Position"] = UDim2.new(0.60704, 0, 0.17568, 0);
-- Attributes
G2L["10e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.anim
G2L["10f"] = Instance.new("LocalScript", G2L["10e"]);
G2L["10f"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.LocalScript
G2L["110"] = Instance.new("LocalScript", G2L["10e"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.UICorner
G2L["111"] = Instance.new("UICorner", G2L["10e"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.ImageLabel
G2L["112"] = Instance.new("ImageLabel", G2L["10e"]);
G2L["112"]["BorderSizePixel"] = 0;
G2L["112"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["112"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["112"]["Image"] = [[rbxassetid://10734941499]];
G2L["112"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["112"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["112"]["BackgroundTransparency"] = 1;
G2L["112"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy
G2L["113"] = Instance.new("TextButton", G2L["107"]);
G2L["113"]["BorderSizePixel"] = 0;
G2L["113"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["113"]["TextSize"] = 14;
G2L["113"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["113"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["113"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["113"]["Size"] = UDim2.new(0, 64, 0, 24);
G2L["113"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["113"]["Text"] = [[Copy  ]];
G2L["113"]["Name"] = [[copy]];
G2L["113"]["Position"] = UDim2.new(0.81232, 0, 0.17568, 0);
-- Attributes
G2L["113"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.anim
G2L["114"] = Instance.new("LocalScript", G2L["113"]);
G2L["114"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.LocalScript
G2L["115"] = Instance.new("LocalScript", G2L["113"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.UICorner
G2L["116"] = Instance.new("UICorner", G2L["113"]);



-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.ImageLabel
G2L["117"] = Instance.new("ImageLabel", G2L["113"]);
G2L["117"]["BorderSizePixel"] = 0;
G2L["117"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["117"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["117"]["Image"] = [[rbxassetid://10709812159]];
G2L["117"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["117"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["117"]["BackgroundTransparency"] = 1;
G2L["117"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.console.consoleholder
G2L["118"] = Instance.new("Frame", G2L["106"]);
G2L["118"]["BorderSizePixel"] = 0;
G2L["118"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["118"]["Size"] = UDim2.new(0, 461, 0, 241);
G2L["118"]["Position"] = UDim2.new(0.02083, 0, 0.00181, 0);
G2L["118"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["118"]["Name"] = [[consoleholder]];
-- Attributes
G2L["118"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.consoleholder.UICorner
G2L["119"] = Instance.new("UICorner", G2L["118"]);



-- StarterGui.zerohub.interface.main.tabs.console.consoleholder.c
G2L["11a"] = Instance.new("ScrollingFrame", G2L["118"]);
G2L["11a"]["Active"] = true;
G2L["11a"]["BorderSizePixel"] = 0;
G2L["11a"]["CanvasSize"] = UDim2.new(0, 0, 0, 910);
G2L["11a"]["CanvasPosition"] = Vector2.new(0, 685.87);
G2L["11a"]["Name"] = [[c]];
G2L["11a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11a"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["11a"]["Size"] = UDim2.new(0.97121, 0, 0.93, 0);
G2L["11a"]["Position"] = UDim2.new(0.50108, 0, 0.5, 0);
G2L["11a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11a"]["ScrollBarThickness"] = 0;
G2L["11a"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.console.consoleholder.c.yesc
G2L["11b"] = Instance.new("TextBox", G2L["11a"]);
G2L["11b"]["Name"] = [[yesc]];
G2L["11b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["11b"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["11b"]["BorderSizePixel"] = 0;
G2L["11b"]["TextEditable"] = false;
G2L["11b"]["TextWrapped"] = true;
G2L["11b"]["TextSize"] = 13;
G2L["11b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11b"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["11b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11b"]["RichText"] = true;
G2L["11b"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["11b"]["MultiLine"] = true;
G2L["11b"]["ClearTextOnFocus"] = false;
G2L["11b"]["PlaceholderText"] = [[No console logs yet.]];
G2L["11b"]["Size"] = UDim2.new(1, 0, 0, 910);
G2L["11b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11b"]["Text"] = [[<font color="#FFFFFF">[15:06:55.255] notifications (Folder)</font>
<font color="#FFFFFF">[15:06:55.257]   examplesuccess (Frame) [Bg: 0.117647, 0.117647, 0.117647, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.258]     UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.258]     UIShadow (UIShadow)</font>
<font color="#FFFFFF">[15:06:55.258]     icon (ImageLabel) [Bg: 1, 1, 1, Trans: 1.00] [ImgColor: 1, 1, 1]</font>
<font color="#FFFFFF">[15:06:55.258]     title (TextLabel) [Bg: 1, 1, 1, Trans: 1.00] [Text: 'Success', TextColor: 1, 1, 1]</font>
<font color="#FFFFFF">[15:06:55.258]     desc (TextLabel) [Bg: 1, 1, 1, Trans: 1.00] [Text: 'fake it till you make it', TextColor: 0.392157, 0.392157, 0.392157]</font>
<font color="#FFFFFF">[15:06:55.259]     bar (Frame) [Bg: 0.392157, 0.392157, 0.392157, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.259]       UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.259]       fill (Frame) [Bg: 1, 1, 1, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.259]         UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.260]   examplewarning (Frame) [Bg: 0.117647, 0.117647, 0.117647, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.260]     UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.260]     UIShadow (UIShadow)</font>
<font color="#FFFFFF">[15:06:55.261]     icon (ImageLabel) [Bg: 1, 1, 1, Trans: 1.00] [ImgColor: 1, 1, 1]</font>
<font color="#FFFFFF">[15:06:55.261]     title (TextLabel) [Bg: 1, 1, 1, Trans: 1.00] [Text: 'Warning', TextColor: 1, 1, 1]</font>
<font color="#FFFFFF">[15:06:55.261]     desc (TextLabel) [Bg: 1, 1, 1, Trans: 1.00] [Text: 'im warnin' u boy', TextColor: 0.392157, 0.392157, 0.392157]</font>
<font color="#FFFFFF">[15:06:55.262]     bar (Frame) [Bg: 0.392157, 0.392157, 0.392157, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.262]       UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.263]       fill (Frame) [Bg: 1, 1, 1, Trans: 0.00]</font>
<font color="#FFFFFF">[15:06:55.263]         UICorner (UICorner)</font>
<font color="#FFFFFF">[15:06:55.264]   notificationsystem (LocalScript)</font>
<font color="#FF0000">[15:07:21.908] GetPath is not a valid member of LocalScript "StarterGui.zerohub.init.notifications"</font>
<font color="#84D6F7">[15:07:21.909] Stack Begin</font>
<font color="#84D6F7">[15:07:21.910] Script 'AssistantCommand', Line 5</font>
<font color="#84D6F7">[15:07:21.911] Stack End</font>
<font color="#FFFF00">[15:30:29.090] Unable to retrieve properties for class 'UIShadow'.
Please ensure you are using the latest version of the GuiToLua plugin. If the issue persists, open a new issue on GitHub and include the class name and plugin version to help update the API.</font>
<font color="#FFFF00">[15:30:29.090] Unable to retrieve properties for class 'UIShadow'.
Please ensure you are using the latest version of the GuiToLua plugin. If the issue persists, open a new issue on GitHub and include the class name and plugin version to help update the API.</font>
<font color="#FFFF00">[15:30:29.091] Unable to retrieve properties for class 'UIShadow'.
Please ensure you are using the latest version of the GuiToLua plugin. If the issue persists, open a new issue on GitHub and include the class name and plugin version to help update the API.</font>
<font color="#FFFF00">[15:30:29.092] Unable to retrieve properties for class 'UIShadow'.
Please ensure you are using the latest version of the GuiToLua plugin. If the issue persists, open a new issue on GitHub and include the class name and plugin version to help update the API.</font>
<font color="#FFFF00">[15:30:29.093] Unable to retrieve properties for class 'UIShadow'.
Please ensure you are using the latest version of the GuiToLua plugin. If the issue persists, open a new issue on GitHub and include the class name and plugin version to help update the API.</font>
]];
G2L["11b"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.console.consoleholder.c.yesc.LocalScript
G2L["11c"] = Instance.new("LocalScript", G2L["11b"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog
G2L["11d"] = Instance.new("Frame", G2L["106"]);
G2L["11d"]["Visible"] = false;
G2L["11d"]["BorderSizePixel"] = 0;
G2L["11d"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11d"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["11d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11d"]["Name"] = [[savedialog]];
G2L["11d"]["BackgroundTransparency"] = 0.2;


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main
G2L["11e"] = Instance.new("Frame", G2L["11d"]);
G2L["11e"]["BorderSizePixel"] = 0;
G2L["11e"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["11e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["11e"]["Size"] = UDim2.new(0, 274, 0, 126);
G2L["11e"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["11e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11e"]["Name"] = [[main]];
-- Attributes
G2L["11e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(21, 21, 21));


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.UICorner
G2L["11f"] = Instance.new("UICorner", G2L["11e"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.tit(s)
G2L["120"] = Instance.new("TextLabel", G2L["11e"]);
G2L["120"]["BorderSizePixel"] = 0;
G2L["120"]["TextSize"] = 20;
G2L["120"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["120"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["120"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["120"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["120"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["120"]["BackgroundTransparency"] = 1;
G2L["120"]["Size"] = UDim2.new(0, 200, 0, 30);
G2L["120"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["120"]["Text"] = [[Save in workspace]];
G2L["120"]["Name"] = [[tit(s)]];
G2L["120"]["Position"] = UDim2.new(0.03285, 0, 0.07143, 0);


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.desc
G2L["121"] = Instance.new("TextLabel", G2L["11e"]);
G2L["121"]["TextWrapped"] = true;
G2L["121"]["BorderSizePixel"] = 0;
G2L["121"]["TextSize"] = 14;
G2L["121"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["121"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["121"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["121"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["121"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["121"]["BackgroundTransparency"] = 1;
G2L["121"]["Size"] = UDim2.new(0, 258, 0, 30);
G2L["121"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["121"]["Text"] = [[This will save a file in your exploit workspace folder.]];
G2L["121"]["Name"] = [[desc]];
G2L["121"]["Position"] = UDim2.new(0.03285, 0, 0.21429, 0);


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.close
G2L["122"] = Instance.new("ImageButton", G2L["11e"]);
G2L["122"]["BorderSizePixel"] = 0;
G2L["122"]["BackgroundTransparency"] = 1;
G2L["122"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["122"]["Image"] = [[rbxassetid://10747384394]];
G2L["122"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["122"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["122"]["Name"] = [[close]];
G2L["122"]["Position"] = UDim2.new(0.88321, 0, 0.11111, 0);


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.close.LocalScript
G2L["123"] = Instance.new("LocalScript", G2L["122"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.TextBox
G2L["124"] = Instance.new("TextBox", G2L["11e"]);
G2L["124"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["124"]["BorderSizePixel"] = 0;
G2L["124"]["TextWrapped"] = true;
G2L["124"]["TextSize"] = 14;
G2L["124"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["124"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["124"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["124"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["124"]["PlaceholderText"] = [[example.txt]];
G2L["124"]["Size"] = UDim2.new(0, 253, 0, 25);
G2L["124"]["Position"] = UDim2.new(0.5, 0, 0.51587, 0);
G2L["124"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["124"]["Text"] = [[]];
-- Attributes
G2L["124"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.TextBox.UICorner
G2L["125"] = Instance.new("UICorner", G2L["124"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save
G2L["126"] = Instance.new("TextButton", G2L["11e"]);
G2L["126"]["BorderSizePixel"] = 0;
G2L["126"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["126"]["TextSize"] = 14;
G2L["126"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["126"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["126"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["126"]["Size"] = UDim2.new(0, 62, 0, 24);
G2L["126"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["126"]["Text"] = [[Done  ]];
G2L["126"]["Name"] = [[save]];
G2L["126"]["Position"] = UDim2.new(0.73091, 0, 0.76, 0);
-- Attributes
G2L["126"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.anim
G2L["127"] = Instance.new("LocalScript", G2L["126"]);
G2L["127"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.LocalScript
G2L["128"] = Instance.new("LocalScript", G2L["126"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.UICorner
G2L["129"] = Instance.new("UICorner", G2L["126"]);



-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.ImageLabel
G2L["12a"] = Instance.new("ImageLabel", G2L["126"]);
G2L["12a"]["BorderSizePixel"] = 0;
G2L["12a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12a"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["12a"]["Image"] = [[rbxassetid://10709790644]];
G2L["12a"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["12a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12a"]["BackgroundTransparency"] = 1;
G2L["12a"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.console.savedialog.UICorner
G2L["12b"] = Instance.new("UICorner", G2L["11d"]);
G2L["12b"]["CornerRadius"] = UDim.new(0, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun
G2L["12c"] = Instance.new("Frame", G2L["1c"]);
G2L["12c"]["Visible"] = false;
G2L["12c"]["BorderSizePixel"] = 0;
G2L["12c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12c"]["Size"] = UDim2.new(0, 460, 0, 271);
G2L["12c"]["Position"] = UDim2.new(0.02083, 0, 0.10841, 0);
G2L["12c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12c"]["Name"] = [[quickrun]];
G2L["12c"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.quickrun.tabmanager
G2L["12d"] = Instance.new("LocalScript", G2L["12c"]);
G2L["12d"]["Name"] = [[tabmanager]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor
G2L["12e"] = Instance.new("ScrollingFrame", G2L["12c"]);
G2L["12e"]["Active"] = true;
G2L["12e"]["BorderSizePixel"] = 0;
G2L["12e"]["Name"] = [[editor]];
G2L["12e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12e"]["Size"] = UDim2.new(0, 460, 0, 211);
G2L["12e"]["ScrollBarImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["12e"]["Position"] = UDim2.new(-0, 0, 0.11084, 0);
G2L["12e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12e"]["ScrollBarThickness"] = 2;
G2L["12e"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.linesandshit
G2L["12f"] = Instance.new("LocalScript", G2L["12e"]);
G2L["12f"]["Name"] = [[linesandshit]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.autoadjust
G2L["130"] = Instance.new("LocalScript", G2L["12e"]);
G2L["130"]["Name"] = [[autoadjust]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox
G2L["131"] = Instance.new("TextBox", G2L["12e"]);
G2L["131"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["131"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["131"]["BorderSizePixel"] = 0;
G2L["131"]["TextSize"] = 14;
G2L["131"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["131"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["131"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["131"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["131"]["MultiLine"] = true;
G2L["131"]["ClearTextOnFocus"] = false;
G2L["131"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["131"]["Position"] = UDim2.new(0, 25, 0, 0);
G2L["131"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["131"]["Text"] = [[]];
G2L["131"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Comments_
G2L["132"] = Instance.new("TextLabel", G2L["131"]);
G2L["132"]["ZIndex"] = 5;
G2L["132"]["TextSize"] = 14;
G2L["132"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["132"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["132"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["132"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["132"]["TextColor3"] = Color3.fromRGB(60, 201, 60);
G2L["132"]["BackgroundTransparency"] = 1;
G2L["132"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["132"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["132"]["Text"] = [[]];
G2L["132"]["Name"] = [[Comments_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Globals_
G2L["133"] = Instance.new("TextLabel", G2L["131"]);
G2L["133"]["ZIndex"] = 5;
G2L["133"]["TextSize"] = 14;
G2L["133"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["133"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["133"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["133"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["133"]["TextColor3"] = Color3.fromRGB(133, 215, 248);
G2L["133"]["BackgroundTransparency"] = 1;
G2L["133"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["133"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["133"]["Text"] = [[]];
G2L["133"]["Name"] = [[Globals_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Keywords_
G2L["134"] = Instance.new("TextLabel", G2L["131"]);
G2L["134"]["ZIndex"] = 5;
G2L["134"]["TextSize"] = 14;
G2L["134"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["134"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["134"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["134"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["134"]["TextColor3"] = Color3.fromRGB(249, 110, 125);
G2L["134"]["BackgroundTransparency"] = 1;
G2L["134"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["134"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["134"]["Text"] = [[]];
G2L["134"]["Name"] = [[Keywords_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Numbers_
G2L["135"] = Instance.new("TextLabel", G2L["131"]);
G2L["135"]["ZIndex"] = 4;
G2L["135"]["TextSize"] = 14;
G2L["135"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["135"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["135"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["135"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["135"]["TextColor3"] = Color3.fromRGB(255, 199, 0);
G2L["135"]["BackgroundTransparency"] = 1;
G2L["135"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["135"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["135"]["Text"] = [[]];
G2L["135"]["Name"] = [[Numbers_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.RemoteHighlight_
G2L["136"] = Instance.new("TextLabel", G2L["131"]);
G2L["136"]["ZIndex"] = 5;
G2L["136"]["TextSize"] = 14;
G2L["136"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["136"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["136"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["136"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["136"]["TextColor3"] = Color3.fromRGB(0, 145, 255);
G2L["136"]["BackgroundTransparency"] = 1;
G2L["136"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["136"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["136"]["Text"] = [[]];
G2L["136"]["Name"] = [[RemoteHighlight_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Strings_
G2L["137"] = Instance.new("TextLabel", G2L["131"]);
G2L["137"]["ZIndex"] = 5;
G2L["137"]["TextSize"] = 14;
G2L["137"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["137"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["137"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["137"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["137"]["TextColor3"] = Color3.fromRGB(174, 242, 150);
G2L["137"]["BackgroundTransparency"] = 1;
G2L["137"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["137"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["137"]["Text"] = [[]];
G2L["137"]["Name"] = [[Strings_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.TextBox.Tokens_
G2L["138"] = Instance.new("TextLabel", G2L["131"]);
G2L["138"]["ZIndex"] = 5;
G2L["138"]["TextSize"] = 14;
G2L["138"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["138"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["138"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["138"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["138"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["138"]["BackgroundTransparency"] = 1;
G2L["138"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["138"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
G2L["138"]["Text"] = [[]];
G2L["138"]["Name"] = [[Tokens_]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.Lines
G2L["139"] = Instance.new("TextLabel", G2L["12e"]);
G2L["139"]["ZIndex"] = 4;
G2L["139"]["BorderSizePixel"] = 3;
G2L["139"]["TextSize"] = 14;
G2L["139"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["139"]["BackgroundColor3"] = Color3.fromRGB(24, 24, 24);
G2L["139"]["FontFace"] = Font.new([[rbxassetid://16658246179]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["139"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["139"]["BackgroundTransparency"] = 1;
G2L["139"]["Size"] = UDim2.new(0, 21, 1, 0);
G2L["139"]["ClipsDescendants"] = true;
G2L["139"]["BorderColor3"] = Color3.fromRGB(24, 24, 24);
G2L["139"]["Text"] = [[1]];
G2L["139"]["Name"] = [[Lines]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.LineHighlight
G2L["13a"] = Instance.new("Frame", G2L["12e"]);
G2L["13a"]["Visible"] = false;
G2L["13a"]["ZIndex"] = 0;
G2L["13a"]["BorderSizePixel"] = 0;
G2L["13a"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["13a"]["Size"] = UDim2.new(1, 0, 0, 14);
G2L["13a"]["Name"] = [[LineHighlight]];
-- Attributes
G2L["13a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.quickrun.tabs
G2L["13b"] = Instance.new("ScrollingFrame", G2L["12c"]);
G2L["13b"]["Active"] = true;
G2L["13b"]["BorderSizePixel"] = 0;
G2L["13b"]["CanvasSize"] = UDim2.new(1, 0, 0, 0);
G2L["13b"]["Name"] = [[tabs]];
G2L["13b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13b"]["AutomaticCanvasSize"] = Enum.AutomaticSize.X;
G2L["13b"]["Size"] = UDim2.new(0, 459, 0, 25);
G2L["13b"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13b"]["Position"] = UDim2.new(-0, 0, 0, 0);
G2L["13b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13b"]["ScrollBarThickness"] = 0;
G2L["13b"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.quickrun.tabs.UIListLayout
G2L["13c"] = Instance.new("UIListLayout", G2L["13b"]);
G2L["13c"]["Padding"] = UDim.new(0, 5);
G2L["13c"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
G2L["13c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["13c"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.quickrun.tabs.addtab
G2L["13d"] = Instance.new("ImageButton", G2L["13b"]);
G2L["13d"]["BorderSizePixel"] = 0;
G2L["13d"]["BackgroundTransparency"] = 1;
G2L["13d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13d"]["Image"] = [[rbxassetid://10734924532]];
G2L["13d"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["13d"]["LayoutOrder"] = 9999;
G2L["13d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13d"]["Name"] = [[addtab]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.activetabexample
G2L["13e"] = Instance.new("Frame", G2L["12c"]);
G2L["13e"]["Visible"] = false;
G2L["13e"]["BorderSizePixel"] = 0;
G2L["13e"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["13e"]["Size"] = UDim2.new(0, 90, 0, 25);
G2L["13e"]["Position"] = UDim2.new(0, 0, 0.13235, 0);
G2L["13e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13e"]["Name"] = [[activetabexample]];
-- Attributes
G2L["13e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.quickrun.activetabexample.UICorner
G2L["13f"] = Instance.new("UICorner", G2L["13e"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.activetabexample.tabtitle
G2L["140"] = Instance.new("TextLabel", G2L["13e"]);
G2L["140"]["BorderSizePixel"] = 0;
G2L["140"]["TextSize"] = 14;
G2L["140"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["140"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["140"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["140"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["140"]["BackgroundTransparency"] = 1;
G2L["140"]["Size"] = UDim2.new(0, 47, 0, 25);
G2L["140"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["140"]["Text"] = [[Tab 1]];
G2L["140"]["Name"] = [[tabtitle]];
G2L["140"]["Position"] = UDim2.new(0, 10, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.activetabexample.close
G2L["141"] = Instance.new("ImageButton", G2L["13e"]);
G2L["141"]["BorderSizePixel"] = 0;
G2L["141"]["BackgroundTransparency"] = 1;
G2L["141"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["141"]["Image"] = [[rbxassetid://10747384394]];
G2L["141"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["141"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["141"]["Name"] = [[close]];
G2L["141"]["Position"] = UDim2.new(0.76667, 0, 0.2, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.inactivetabexample
G2L["142"] = Instance.new("Frame", G2L["12c"]);
G2L["142"]["Visible"] = false;
G2L["142"]["BorderSizePixel"] = 0;
G2L["142"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["142"]["Size"] = UDim2.new(0, 90, 0, 25);
G2L["142"]["Position"] = UDim2.new(0, 0, 0.13235, 0);
G2L["142"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["142"]["Name"] = [[inactivetabexample]];
-- Attributes
G2L["142"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.quickrun.inactivetabexample.UICorner
G2L["143"] = Instance.new("UICorner", G2L["142"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.inactivetabexample.tabtitle
G2L["144"] = Instance.new("TextLabel", G2L["142"]);
G2L["144"]["BorderSizePixel"] = 0;
G2L["144"]["TextSize"] = 14;
G2L["144"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["144"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["144"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["144"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["144"]["BackgroundTransparency"] = 1;
G2L["144"]["Size"] = UDim2.new(0, 47, 0, 25);
G2L["144"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["144"]["Text"] = [[Tab 2]];
G2L["144"]["Name"] = [[tabtitle]];
G2L["144"]["Position"] = UDim2.new(0, 10, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.inactivetabexample.close
G2L["145"] = Instance.new("ImageButton", G2L["142"]);
G2L["145"]["BorderSizePixel"] = 0;
G2L["145"]["BackgroundTransparency"] = 1;
G2L["145"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["145"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["145"]["Image"] = [[rbxassetid://10747384394]];
G2L["145"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["145"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["145"]["Name"] = [[close]];
G2L["145"]["Position"] = UDim2.new(0.76667, 0, 0.2, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder
G2L["146"] = Instance.new("Frame", G2L["12c"]);
G2L["146"]["BorderSizePixel"] = 0;
G2L["146"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["146"]["Size"] = UDim2.new(0, 341, 0, 37);
G2L["146"]["Position"] = UDim2.new(0.2593, 0, 0.88, 0);
G2L["146"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["146"]["Name"] = [[buttonsholder]];
G2L["146"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy
G2L["147"] = Instance.new("TextButton", G2L["146"]);
G2L["147"]["BorderSizePixel"] = 0;
G2L["147"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["147"]["TextSize"] = 14;
G2L["147"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["147"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["147"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["147"]["Size"] = UDim2.new(0, 67, 0, 24);
G2L["147"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["147"]["Text"] = [[Copy  ]];
G2L["147"]["Name"] = [[copy]];
G2L["147"]["Position"] = UDim2.new(0.34897, 0, 0.17568, 0);
-- Attributes
G2L["147"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.anim
G2L["148"] = Instance.new("LocalScript", G2L["147"]);
G2L["148"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.LocalScript
G2L["149"] = Instance.new("LocalScript", G2L["147"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.UICorner
G2L["14a"] = Instance.new("UICorner", G2L["147"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.ImageLabel
G2L["14b"] = Instance.new("ImageLabel", G2L["147"]);
G2L["14b"]["BorderSizePixel"] = 0;
G2L["14b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["14b"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["14b"]["Image"] = [[rbxassetid://10709812159]];
G2L["14b"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["14b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["14b"]["BackgroundTransparency"] = 1;
G2L["14b"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.UIListLayout
G2L["14c"] = Instance.new("UIListLayout", G2L["146"]);
G2L["14c"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
G2L["14c"]["Padding"] = UDim.new(0, 5);
G2L["14c"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
G2L["14c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["14c"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear
G2L["14d"] = Instance.new("TextButton", G2L["146"]);
G2L["14d"]["BorderSizePixel"] = 0;
G2L["14d"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["14d"]["TextSize"] = 14;
G2L["14d"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["14d"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["14d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["14d"]["Size"] = UDim2.new(0, 62, 0, 24);
G2L["14d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["14d"]["Text"] = [[Clear  ]];
G2L["14d"]["Name"] = [[clear]];
G2L["14d"]["Position"] = UDim2.new(0.60704, 0, 0.17568, 0);
-- Attributes
G2L["14d"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.anim
G2L["14e"] = Instance.new("LocalScript", G2L["14d"]);
G2L["14e"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.LocalScript
G2L["14f"] = Instance.new("LocalScript", G2L["14d"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.UICorner
G2L["150"] = Instance.new("UICorner", G2L["14d"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.ImageLabel
G2L["151"] = Instance.new("ImageLabel", G2L["14d"]);
G2L["151"]["BorderSizePixel"] = 0;
G2L["151"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["151"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["151"]["Image"] = [[rbxassetid://10709819059]];
G2L["151"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["151"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["151"]["BackgroundTransparency"] = 1;
G2L["151"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute
G2L["152"] = Instance.new("TextButton", G2L["146"]);
G2L["152"]["BorderSizePixel"] = 0;
G2L["152"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["152"]["TextSize"] = 14;
G2L["152"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["152"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["152"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["152"]["Size"] = UDim2.new(0, 83, 0, 24);
G2L["152"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["152"]["Text"] = [[Execute  ]];
G2L["152"]["Name"] = [[execute]];
G2L["152"]["Position"] = UDim2.new(0.7566, 0, 0.17568, 0);
-- Attributes
G2L["152"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.anim
G2L["153"] = Instance.new("LocalScript", G2L["152"]);
G2L["153"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.LocalScript
G2L["154"] = Instance.new("LocalScript", G2L["152"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.UICorner
G2L["155"] = Instance.new("UICorner", G2L["152"]);



-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.ImageLabel
G2L["156"] = Instance.new("ImageLabel", G2L["152"]);
G2L["156"]["BorderSizePixel"] = 0;
G2L["156"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["156"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["156"]["Image"] = [[rbxassetid://10734923549]];
G2L["156"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["156"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["156"]["BackgroundTransparency"] = 1;
G2L["156"]["Position"] = UDim2.new(0.085, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.universal
G2L["157"] = Instance.new("Frame", G2L["1c"]);
G2L["157"]["Visible"] = false;
G2L["157"]["BorderSizePixel"] = 0;
G2L["157"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["157"]["ClipsDescendants"] = true;
G2L["157"]["Size"] = UDim2.new(0, 480, 0, 275);
G2L["157"]["Position"] = UDim2.new(0, 0, 0.10841, 0);
G2L["157"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["157"]["Name"] = [[universal]];
G2L["157"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame
G2L["158"] = Instance.new("ScrollingFrame", G2L["157"]);
G2L["158"]["Active"] = true;
G2L["158"]["BorderSizePixel"] = 0;
G2L["158"]["CanvasSize"] = UDim2.new(0, 0, 1.15, 0);
G2L["158"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["158"]["Size"] = UDim2.new(0, 461, 0, 275);
G2L["158"]["ScrollBarImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["158"]["Position"] = UDim2.new(0.02083, 0, 0, 0);
G2L["158"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["158"]["ScrollBarThickness"] = 5;
G2L["158"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.UIGridLayout
G2L["159"] = Instance.new("UIGridLayout", G2L["158"]);
G2L["159"]["CellSize"] = UDim2.new(0, 220, 0, 150);
G2L["159"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["159"]["CellPadding"] = UDim2.new(0, 8, 0, 8);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement
G2L["15a"] = Instance.new("Frame", G2L["158"]);
G2L["15a"]["BorderSizePixel"] = 0;
G2L["15a"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["15a"]["Size"] = UDim2.new(0, 377, 0, 150);
G2L["15a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15a"]["Name"] = [[movement]];
-- Attributes
G2L["15a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.LocalScript
G2L["15b"] = Instance.new("LocalScript", G2L["15a"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.UICorner
G2L["15c"] = Instance.new("UICorner", G2L["15a"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons
G2L["15d"] = Instance.new("Frame", G2L["15a"]);
G2L["15d"]["BorderSizePixel"] = 0;
G2L["15d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15d"]["Size"] = UDim2.new(0, 165, 0, 22);
G2L["15d"]["Position"] = UDim2.new(0.02541, 0, 0.03333, 0);
G2L["15d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15d"]["Name"] = [[buttons]];
G2L["15d"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.UIListLayout
G2L["15e"] = Instance.new("UIListLayout", G2L["15d"]);
G2L["15e"]["Padding"] = UDim.new(0, 5);
G2L["15e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["15e"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.fly
G2L["15f"] = Instance.new("TextButton", G2L["15d"]);
G2L["15f"]["BorderSizePixel"] = 0;
G2L["15f"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["15f"]["TextSize"] = 14;
G2L["15f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15f"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["15f"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["15f"]["Size"] = UDim2.new(-0.92121, 200, 1, 0);
G2L["15f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15f"]["Text"] = [[Fly  ]];
G2L["15f"]["Name"] = [[fly]];
-- Attributes
G2L["15f"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.fly.ImageLabel
G2L["160"] = Instance.new("ImageLabel", G2L["15f"]);
G2L["160"]["BorderSizePixel"] = 0;
G2L["160"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["160"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["160"]["Image"] = [[rbxassetid://10734922971]];
G2L["160"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["160"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["160"]["BackgroundTransparency"] = 1;
G2L["160"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.fly.UICorner
G2L["161"] = Instance.new("UICorner", G2L["15f"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.noclip
G2L["162"] = Instance.new("TextButton", G2L["15d"]);
G2L["162"]["BorderSizePixel"] = 0;
G2L["162"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["162"]["TextSize"] = 14;
G2L["162"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["162"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["162"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["162"]["Size"] = UDim2.new(-0.8, 200, 1, 0);
G2L["162"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["162"]["Text"] = [[Noclip  ]];
G2L["162"]["Name"] = [[noclip]];
G2L["162"]["Position"] = UDim2.new(0.58788, 0, 0, 0);
-- Attributes
G2L["162"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.noclip.ImageLabel
G2L["163"] = Instance.new("ImageLabel", G2L["162"]);
G2L["163"]["BorderSizePixel"] = 0;
G2L["163"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["163"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["163"]["Image"] = [[rbxassetid://10723376884]];
G2L["163"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["163"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["163"]["BackgroundTransparency"] = 1;
G2L["163"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.noclip.UICorner
G2L["164"] = Instance.new("UICorner", G2L["162"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.infjump
G2L["165"] = Instance.new("TextButton", G2L["15d"]);
G2L["165"]["BorderSizePixel"] = 0;
G2L["165"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["165"]["TextSize"] = 14;
G2L["165"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["165"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["165"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["165"]["Size"] = UDim2.new(-0.73333, 200, 1, 0);
G2L["165"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["165"]["Text"] = [[Inf jump  ]];
G2L["165"]["Name"] = [[infjump]];
G2L["165"]["Position"] = UDim2.new(0.52121, 0, 0, 0);
-- Attributes
G2L["165"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.infjump.ImageLabel
G2L["166"] = Instance.new("ImageLabel", G2L["165"]);
G2L["166"]["BorderSizePixel"] = 0;
G2L["166"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["166"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["166"]["Image"] = [[rbxassetid://10709768939]];
G2L["166"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["166"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["166"]["BackgroundTransparency"] = 1;
G2L["166"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.buttons.infjump.UICorner
G2L["167"] = Instance.new("UICorner", G2L["165"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders
G2L["168"] = Instance.new("Frame", G2L["15a"]);
G2L["168"]["BorderSizePixel"] = 0;
G2L["168"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["168"]["Size"] = UDim2.new(0, 206, 0, 107);
G2L["168"]["Position"] = UDim2.new(0.02752, 0, 0.22667, 0);
G2L["168"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["168"]["Name"] = [[sliders]];
G2L["168"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed
G2L["169"] = Instance.new("Frame", G2L["168"]);
G2L["169"]["Active"] = true;
G2L["169"]["BorderSizePixel"] = 0;
G2L["169"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["169"]["ClipsDescendants"] = true;
G2L["169"]["Size"] = UDim2.new(0, 213, 0, 32);
G2L["169"]["Position"] = UDim2.new(-0, 0, 0, 0);
G2L["169"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["169"]["Name"] = [[walkspeed]];
-- Attributes
G2L["169"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed.UICorner
G2L["16a"] = Instance.new("UICorner", G2L["169"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed.filler
G2L["16b"] = Instance.new("Frame", G2L["169"]);
G2L["16b"]["BorderSizePixel"] = 0;
G2L["16b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["16b"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["16b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["16b"]["Name"] = [[filler]];
-- Attributes
G2L["16b"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed.filler.UICorner
G2L["16c"] = Instance.new("UICorner", G2L["16b"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed.value
G2L["16d"] = Instance.new("TextLabel", G2L["169"]);
G2L["16d"]["ZIndex"] = 2;
G2L["16d"]["BorderSizePixel"] = 0;
G2L["16d"]["TextSize"] = 14;
G2L["16d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["16d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["16d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["16d"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["16d"]["BackgroundTransparency"] = 1;
G2L["16d"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["16d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["16d"]["Text"] = [[16]];
G2L["16d"]["Name"] = [[value]];
G2L["16d"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.walkspeed.icon
G2L["16e"] = Instance.new("ImageLabel", G2L["169"]);
G2L["16e"]["ZIndex"] = 2;
G2L["16e"]["BorderSizePixel"] = 0;
G2L["16e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["16e"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["16e"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["16e"]["Image"] = [[rbxassetid://12975608939]];
G2L["16e"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["16e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["16e"]["BackgroundTransparency"] = 1;
G2L["16e"]["Name"] = [[icon]];
G2L["16e"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.UIGridLayout
G2L["16f"] = Instance.new("UIGridLayout", G2L["168"]);
G2L["16f"]["CellSize"] = UDim2.new(1, 0, 0, 32);
G2L["16f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower
G2L["170"] = Instance.new("Frame", G2L["168"]);
G2L["170"]["Active"] = true;
G2L["170"]["BorderSizePixel"] = 0;
G2L["170"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["170"]["ClipsDescendants"] = true;
G2L["170"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["170"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["170"]["Name"] = [[jumppower]];
-- Attributes
G2L["170"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower.UICorner
G2L["171"] = Instance.new("UICorner", G2L["170"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower.filler
G2L["172"] = Instance.new("Frame", G2L["170"]);
G2L["172"]["BorderSizePixel"] = 0;
G2L["172"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["172"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["172"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["172"]["Name"] = [[filler]];
-- Attributes
G2L["172"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower.filler.UICorner
G2L["173"] = Instance.new("UICorner", G2L["172"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower.value
G2L["174"] = Instance.new("TextLabel", G2L["170"]);
G2L["174"]["ZIndex"] = 2;
G2L["174"]["BorderSizePixel"] = 0;
G2L["174"]["TextSize"] = 14;
G2L["174"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["174"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["174"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["174"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["174"]["BackgroundTransparency"] = 1;
G2L["174"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["174"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["174"]["Text"] = [[50]];
G2L["174"]["Name"] = [[value]];
G2L["174"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.jumppower.icon
G2L["175"] = Instance.new("ImageLabel", G2L["170"]);
G2L["175"]["ZIndex"] = 2;
G2L["175"]["BorderSizePixel"] = 0;
G2L["175"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["175"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["175"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["175"]["Image"] = [[rbxassetid://10709768939]];
G2L["175"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["175"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["175"]["BackgroundTransparency"] = 1;
G2L["175"]["Name"] = [[icon]];
G2L["175"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed
G2L["176"] = Instance.new("Frame", G2L["168"]);
G2L["176"]["Active"] = true;
G2L["176"]["BorderSizePixel"] = 0;
G2L["176"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["176"]["ClipsDescendants"] = true;
G2L["176"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["176"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["176"]["Name"] = [[flyspeed]];
-- Attributes
G2L["176"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed.UICorner
G2L["177"] = Instance.new("UICorner", G2L["176"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed.filler
G2L["178"] = Instance.new("Frame", G2L["176"]);
G2L["178"]["BorderSizePixel"] = 0;
G2L["178"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["178"]["Size"] = UDim2.new(0, 100, 1, 0);
G2L["178"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["178"]["Name"] = [[filler]];
-- Attributes
G2L["178"]:SetAttribute([[OriginalColor]], Color3.fromRGB(255, 255, 255));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed.filler.UICorner
G2L["179"] = Instance.new("UICorner", G2L["178"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed.value
G2L["17a"] = Instance.new("TextLabel", G2L["176"]);
G2L["17a"]["ZIndex"] = 2;
G2L["17a"]["BorderSizePixel"] = 0;
G2L["17a"]["TextSize"] = 14;
G2L["17a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["17a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17a"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["17a"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["17a"]["BackgroundTransparency"] = 1;
G2L["17a"]["Size"] = UDim2.new(0, 41, 0, 32);
G2L["17a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17a"]["Text"] = [[1]];
G2L["17a"]["Name"] = [[value]];
G2L["17a"]["Position"] = UDim2.new(0, 30, 0, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.sliders.flyspeed.icon
G2L["17b"] = Instance.new("ImageLabel", G2L["176"]);
G2L["17b"]["ZIndex"] = 2;
G2L["17b"]["BorderSizePixel"] = 0;
G2L["17b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17b"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["17b"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["17b"]["Image"] = [[rbxassetid://10734922971]];
G2L["17b"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["17b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17b"]["BackgroundTransparency"] = 1;
G2L["17b"]["Name"] = [[icon]];
G2L["17b"]["Position"] = UDim2.new(0, 4, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation
G2L["17c"] = Instance.new("Frame", G2L["158"]);
G2L["17c"]["BorderSizePixel"] = 0;
G2L["17c"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["17c"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["17c"]["Position"] = UDim2.new(0.20183, 0, 0.26167, 0);
G2L["17c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17c"]["Name"] = [[teleportation]];
-- Attributes
G2L["17c"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.LocalScript
G2L["17d"] = Instance.new("LocalScript", G2L["17c"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.UICorner
G2L["17e"] = Instance.new("UICorner", G2L["17c"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons
G2L["17f"] = Instance.new("Frame", G2L["17c"]);
G2L["17f"]["BorderSizePixel"] = 0;
G2L["17f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17f"]["Size"] = UDim2.new(0, 165, 0, 22);
G2L["17f"]["Position"] = UDim2.new(0.02541, 0, 0.03333, 0);
G2L["17f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17f"]["Name"] = [[buttons]];
G2L["17f"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.UIListLayout
G2L["180"] = Instance.new("UIListLayout", G2L["17f"]);
G2L["180"]["Padding"] = UDim.new(0, 5);
G2L["180"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["180"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.clicktp
G2L["181"] = Instance.new("TextButton", G2L["17f"]);
G2L["181"]["BorderSizePixel"] = 0;
G2L["181"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["181"]["TextSize"] = 14;
G2L["181"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["181"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["181"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["181"]["Size"] = UDim2.new(-0.56364, 200, 1, 0);
G2L["181"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["181"]["Text"] = [[Click TP tool  ]];
G2L["181"]["Name"] = [[clicktp]];
G2L["181"]["Position"] = UDim2.new(0.35152, 0, 0, 0);
-- Attributes
G2L["181"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.clicktp.ImageLabel
G2L["182"] = Instance.new("ImageLabel", G2L["181"]);
G2L["182"]["BorderSizePixel"] = 0;
G2L["182"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["182"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["182"]["Image"] = [[rbxassetid://10734898194]];
G2L["182"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["182"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["182"]["BackgroundTransparency"] = 1;
G2L["182"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.clicktp.UICorner
G2L["183"] = Instance.new("UICorner", G2L["181"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.tpplayer
G2L["184"] = Instance.new("TextButton", G2L["17f"]);
G2L["184"]["BorderSizePixel"] = 0;
G2L["184"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["184"]["TextSize"] = 14;
G2L["184"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["184"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["184"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["184"]["Size"] = UDim2.new(-0.71267, 200, 1, 0);
G2L["184"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["184"]["Text"] = [[TP to plr  ]];
G2L["184"]["Name"] = [[tpplayer]];
G2L["184"]["Position"] = UDim2.new(0.67879, 0, 0, 0);
-- Attributes
G2L["184"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.tpplayer.ImageLabel
G2L["185"] = Instance.new("ImageLabel", G2L["184"]);
G2L["185"]["BorderSizePixel"] = 0;
G2L["185"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["185"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["185"]["Image"] = [[rbxassetid://10747373176]];
G2L["185"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["185"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["185"]["BackgroundTransparency"] = 1;
G2L["185"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.buttons.tpplayer.UICorner
G2L["186"] = Instance.new("UICorner", G2L["184"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist
G2L["187"] = Instance.new("Frame", G2L["17c"]);
G2L["187"]["BorderSizePixel"] = 0;
G2L["187"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["187"]["Size"] = UDim2.new(0, 206, 0, 109);
G2L["187"]["Position"] = UDim2.new(0.02752, 0, 0.22667, 0);
G2L["187"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["187"]["Name"] = [[playerlist]];
-- Attributes
G2L["187"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.UICorner
G2L["188"] = Instance.new("UICorner", G2L["187"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame
G2L["189"] = Instance.new("ScrollingFrame", G2L["187"]);
G2L["189"]["Active"] = true;
G2L["189"]["BorderSizePixel"] = 0;
G2L["189"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["189"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["189"]["Size"] = UDim2.new(0.95, 0, 0.9, 0);
G2L["189"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["189"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["189"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["189"]["ScrollBarThickness"] = 0;
G2L["189"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.UIGridLayout
G2L["18a"] = Instance.new("UIGridLayout", G2L["189"]);
G2L["18a"]["CellSize"] = UDim2.new(1, 0, 0, 30);
G2L["18a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.selectedexample
G2L["18b"] = Instance.new("Frame", G2L["189"]);
G2L["18b"]["Visible"] = false;
G2L["18b"]["BorderSizePixel"] = 0;
G2L["18b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18b"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["18b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18b"]["Name"] = [[selectedexample]];


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.selectedexample.UICorner
G2L["18c"] = Instance.new("UICorner", G2L["18b"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.selectedexample.userprofileicon-avatar
G2L["18d"] = Instance.new("ImageLabel", G2L["18b"]);
G2L["18d"]["BorderSizePixel"] = 0;
G2L["18d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18d"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18d"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["18d"]["Image"] = [[rbxassetid://10747373176]];
G2L["18d"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["18d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18d"]["BackgroundTransparency"] = 1;
G2L["18d"]["Name"] = [[userprofileicon-avatar]];
G2L["18d"]["Position"] = UDim2.new(0, 10, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.selectedexample.userprofileicon-avatar.UICorner
G2L["18e"] = Instance.new("UICorner", G2L["18d"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.selectedexample.displayname
G2L["18f"] = Instance.new("TextLabel", G2L["18b"]);
G2L["18f"]["TextWrapped"] = true;
G2L["18f"]["BorderSizePixel"] = 0;
G2L["18f"]["TextSize"] = 14;
G2L["18f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["18f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18f"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["18f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18f"]["BackgroundTransparency"] = 1;
G2L["18f"]["Size"] = UDim2.new(0, 157, 0, 16);
G2L["18f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18f"]["Text"] = [[DisplayName]];
G2L["18f"]["Name"] = [[displayname]];
G2L["18f"]["Position"] = UDim2.new(0.159, 0, 0.202, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.example
G2L["190"] = Instance.new("Frame", G2L["189"]);
G2L["190"]["Visible"] = false;
G2L["190"]["BorderSizePixel"] = 0;
G2L["190"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
G2L["190"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["190"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["190"]["Name"] = [[example]];


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.example.UICorner
G2L["191"] = Instance.new("UICorner", G2L["190"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.example.userprofileicon-avatar
G2L["192"] = Instance.new("ImageLabel", G2L["190"]);
G2L["192"]["BorderSizePixel"] = 0;
G2L["192"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["192"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["192"]["Image"] = [[rbxassetid://10747373176]];
G2L["192"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["192"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["192"]["BackgroundTransparency"] = 1;
G2L["192"]["Name"] = [[userprofileicon-avatar]];
G2L["192"]["Position"] = UDim2.new(0, 10, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.example.userprofileicon-avatar.UICorner
G2L["193"] = Instance.new("UICorner", G2L["192"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist.ScrollingFrame.example.displayname
G2L["194"] = Instance.new("TextLabel", G2L["190"]);
G2L["194"]["TextWrapped"] = true;
G2L["194"]["BorderSizePixel"] = 0;
G2L["194"]["TextSize"] = 14;
G2L["194"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["194"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["194"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["194"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["194"]["BackgroundTransparency"] = 1;
G2L["194"]["Size"] = UDim2.new(0, 157, 0, 16);
G2L["194"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["194"]["Text"] = [[DisplayName]];
G2L["194"]["Name"] = [[displayname]];
G2L["194"]["Position"] = UDim2.new(0.15901, 0, 0.20167, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual
G2L["195"] = Instance.new("Frame", G2L["158"]);
G2L["195"]["Visible"] = false;
G2L["195"]["BorderSizePixel"] = 0;
G2L["195"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["195"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["195"]["Position"] = UDim2.new(0.20183, 0, 0.26167, 0);
G2L["195"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["195"]["Name"] = [[visual]];
-- Attributes
G2L["195"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.LocalScript
G2L["196"] = Instance.new("LocalScript", G2L["195"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.UICorner
G2L["197"] = Instance.new("UICorner", G2L["195"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.title
G2L["198"] = Instance.new("TextLabel", G2L["195"]);
G2L["198"]["BorderSizePixel"] = 0;
G2L["198"]["TextSize"] = 20;
G2L["198"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["198"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["198"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["198"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["198"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["198"]["BackgroundTransparency"] = 1;
G2L["198"]["Size"] = UDim2.new(0, 200, 0, 26);
G2L["198"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["198"]["Text"] = [[Visual (broken and wont fix lol)]];
G2L["198"]["Name"] = [[title]];
G2L["198"]["Position"] = UDim2.new(0.02752, 0, 0.04, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons
G2L["199"] = Instance.new("Frame", G2L["195"]);
G2L["199"]["BorderSizePixel"] = 0;
G2L["199"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["199"]["Size"] = UDim2.new(0, 307, 0, 105);
G2L["199"]["Position"] = UDim2.new(0.02752, 0, 0.21333, 0);
G2L["199"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["199"]["Name"] = [[buttons]];
G2L["199"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.UIListLayout
G2L["19a"] = Instance.new("UIListLayout", G2L["199"]);
G2L["19a"]["Wraps"] = true;
G2L["19a"]["Padding"] = UDim.new(0, 5);
G2L["19a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["19a"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.esp
G2L["19b"] = Instance.new("TextButton", G2L["199"]);
G2L["19b"]["BorderSizePixel"] = 0;
G2L["19b"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["19b"]["TextSize"] = 14;
G2L["19b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19b"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["19b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["19b"]["Size"] = UDim2.new(0, 56, 0, 20);
G2L["19b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19b"]["Text"] = [[ESP  ]];
G2L["19b"]["Name"] = [[esp]];
-- Attributes
G2L["19b"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.esp.ImageLabel
G2L["19c"] = Instance.new("ImageLabel", G2L["19b"]);
G2L["19c"]["BorderSizePixel"] = 0;
G2L["19c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19c"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["19c"]["Image"] = [[rbxassetid://10723346959]];
G2L["19c"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["19c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19c"]["BackgroundTransparency"] = 1;
G2L["19c"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.esp.UICorner
G2L["19d"] = Instance.new("UICorner", G2L["19b"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fullbright
G2L["19e"] = Instance.new("TextButton", G2L["199"]);
G2L["19e"]["BorderSizePixel"] = 0;
G2L["19e"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["19e"]["TextSize"] = 14;
G2L["19e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19e"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["19e"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["19e"]["Size"] = UDim2.new(0, 88, 0, 20);
G2L["19e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19e"]["Text"] = [[Fullbright  ]];
G2L["19e"]["Name"] = [[fullbright]];
G2L["19e"]["Position"] = UDim2.new(0.26384, 0, 0, 0);
-- Attributes
G2L["19e"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fullbright.ImageLabel
G2L["19f"] = Instance.new("ImageLabel", G2L["19e"]);
G2L["19f"]["BorderSizePixel"] = 0;
G2L["19f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19f"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["19f"]["Image"] = [[rbxassetid://10723425852]];
G2L["19f"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["19f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19f"]["BackgroundTransparency"] = 1;
G2L["19f"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fullbright.UICorner
G2L["1a0"] = Instance.new("UICorner", G2L["19e"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.chams
G2L["1a1"] = Instance.new("TextButton", G2L["199"]);
G2L["1a1"]["BorderSizePixel"] = 0;
G2L["1a1"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1a1"]["TextSize"] = 14;
G2L["1a1"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a1"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1a1"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1a1"]["Size"] = UDim2.new(0, 69, 0, 20);
G2L["1a1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a1"]["Text"] = [[Chams  ]];
G2L["1a1"]["Name"] = [[chams]];
G2L["1a1"]["Position"] = UDim2.new(0.50163, 0, 0, 0);
-- Attributes
G2L["1a1"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.chams.ImageLabel
G2L["1a2"] = Instance.new("ImageLabel", G2L["1a1"]);
G2L["1a2"]["BorderSizePixel"] = 0;
G2L["1a2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a2"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1a2"]["Image"] = [[rbxassetid://10709782342]];
G2L["1a2"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1a2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a2"]["BackgroundTransparency"] = 1;
G2L["1a2"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.chams.UICorner
G2L["1a3"] = Instance.new("UICorner", G2L["1a1"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.skeleton
G2L["1a4"] = Instance.new("TextButton", G2L["199"]);
G2L["1a4"]["BorderSizePixel"] = 0;
G2L["1a4"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1a4"]["TextSize"] = 14;
G2L["1a4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a4"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1a4"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1a4"]["Size"] = UDim2.new(0, 81, 0, 20);
G2L["1a4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a4"]["Text"] = [[Skeleton  ]];
G2L["1a4"]["Name"] = [[skeleton]];
G2L["1a4"]["Position"] = UDim2.new(0, 0, 0.2381, 0);
-- Attributes
G2L["1a4"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.skeleton.ImageLabel
G2L["1a5"] = Instance.new("ImageLabel", G2L["1a4"]);
G2L["1a5"]["BorderSizePixel"] = 0;
G2L["1a5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a5"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1a5"]["Image"] = [[rbxassetid://10709781605]];
G2L["1a5"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1a5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a5"]["BackgroundTransparency"] = 1;
G2L["1a5"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.skeleton.UICorner
G2L["1a6"] = Instance.new("UICorner", G2L["1a4"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.nametags
G2L["1a7"] = Instance.new("TextButton", G2L["199"]);
G2L["1a7"]["BorderSizePixel"] = 0;
G2L["1a7"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1a7"]["TextSize"] = 14;
G2L["1a7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a7"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1a7"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1a7"]["Size"] = UDim2.new(0, 96, 0, 20);
G2L["1a7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a7"]["Text"] = [[Name tags  ]];
G2L["1a7"]["Name"] = [[nametags]];
G2L["1a7"]["Position"] = UDim2.new(0.28013, 0, 0.2381, 0);
-- Attributes
G2L["1a7"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.nametags.ImageLabel
G2L["1a8"] = Instance.new("ImageLabel", G2L["1a7"]);
G2L["1a8"]["BorderSizePixel"] = 0;
G2L["1a8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a8"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1a8"]["Image"] = [[rbxassetid://10734976528]];
G2L["1a8"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1a8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a8"]["BackgroundTransparency"] = 1;
G2L["1a8"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.nametags.UICorner
G2L["1a9"] = Instance.new("UICorner", G2L["1a7"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fovcircle
G2L["1aa"] = Instance.new("TextButton", G2L["199"]);
G2L["1aa"]["BorderSizePixel"] = 0;
G2L["1aa"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1aa"]["TextSize"] = 14;
G2L["1aa"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1aa"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1aa"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1aa"]["Size"] = UDim2.new(0, 92, 0, 20);
G2L["1aa"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1aa"]["Text"] = [[FOV circle  ]];
G2L["1aa"]["Name"] = [[fovcircle]];
G2L["1aa"]["Position"] = UDim2.new(0.60912, 0, 0.2381, 0);
-- Attributes
G2L["1aa"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fovcircle.ImageLabel
G2L["1ab"] = Instance.new("ImageLabel", G2L["1aa"]);
G2L["1ab"]["BorderSizePixel"] = 0;
G2L["1ab"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ab"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1ab"]["Image"] = [[rbxassetid://10709797837]];
G2L["1ab"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1ab"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ab"]["BackgroundTransparency"] = 1;
G2L["1ab"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.fovcircle.UICorner
G2L["1ac"] = Instance.new("UICorner", G2L["1aa"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.health
G2L["1ad"] = Instance.new("TextButton", G2L["199"]);
G2L["1ad"]["BorderSizePixel"] = 0;
G2L["1ad"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1ad"]["TextSize"] = 14;
G2L["1ad"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ad"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1ad"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1ad"]["Size"] = UDim2.new(0, 71, 0, 20);
G2L["1ad"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ad"]["Text"] = [[Health  ]];
G2L["1ad"]["Name"] = [[health]];
G2L["1ad"]["Position"] = UDim2.new(0, 0, 0.47619, 0);
-- Attributes
G2L["1ad"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.health.ImageLabel
G2L["1ae"] = Instance.new("ImageLabel", G2L["1ad"]);
G2L["1ae"]["BorderSizePixel"] = 0;
G2L["1ae"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ae"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1ae"]["Image"] = [[rbxassetid://10723406885]];
G2L["1ae"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1ae"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ae"]["BackgroundTransparency"] = 1;
G2L["1ae"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.health.UICorner
G2L["1af"] = Instance.new("UICorner", G2L["1ad"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.distance
G2L["1b0"] = Instance.new("TextButton", G2L["199"]);
G2L["1b0"]["BorderSizePixel"] = 0;
G2L["1b0"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1b0"]["TextSize"] = 14;
G2L["1b0"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b0"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1b0"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1b0"]["Size"] = UDim2.new(0, 83, 0, 20);
G2L["1b0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b0"]["Text"] = [[Distance  ]];
G2L["1b0"]["Name"] = [[distance]];
G2L["1b0"]["Position"] = UDim2.new(0.24756, 0, 0.47619, 0);
-- Attributes
G2L["1b0"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.distance.ImageLabel
G2L["1b1"] = Instance.new("ImageLabel", G2L["1b0"]);
G2L["1b1"]["BorderSizePixel"] = 0;
G2L["1b1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b1"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1b1"]["Image"] = [[rbxassetid://10734886004]];
G2L["1b1"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1b1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b1"]["BackgroundTransparency"] = 1;
G2L["1b1"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.distance.UICorner
G2L["1b2"] = Instance.new("UICorner", G2L["1b0"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.boxes
G2L["1b3"] = Instance.new("TextButton", G2L["199"]);
G2L["1b3"]["BorderSizePixel"] = 0;
G2L["1b3"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1b3"]["TextSize"] = 14;
G2L["1b3"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b3"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1b3"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1b3"]["Size"] = UDim2.new(0, 69, 0, 20);
G2L["1b3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b3"]["Text"] = [[Boxes  ]];
G2L["1b3"]["Name"] = [[boxes]];
G2L["1b3"]["Position"] = UDim2.new(0.5342, 0, 0.47619, 0);
-- Attributes
G2L["1b3"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.boxes.ImageLabel
G2L["1b4"] = Instance.new("ImageLabel", G2L["1b3"]);
G2L["1b4"]["BorderSizePixel"] = 0;
G2L["1b4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b4"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1b4"]["Image"] = [[rbxassetid://10709782497]];
G2L["1b4"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1b4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b4"]["BackgroundTransparency"] = 1;
G2L["1b4"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.boxes.UICorner
G2L["1b5"] = Instance.new("UICorner", G2L["1b3"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.tracers
G2L["1b6"] = Instance.new("TextButton", G2L["199"]);
G2L["1b6"]["BorderSizePixel"] = 0;
G2L["1b6"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1b6"]["TextSize"] = 14;
G2L["1b6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b6"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1b6"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1b6"]["Size"] = UDim2.new(0, 75, 0, 20);
G2L["1b6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b6"]["Text"] = [[Tracers  ]];
G2L["1b6"]["Name"] = [[tracers]];
G2L["1b6"]["Position"] = UDim2.new(0.77524, 0, 0.47619, 0);
-- Attributes
G2L["1b6"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.tracers.ImageLabel
G2L["1b7"] = Instance.new("ImageLabel", G2L["1b6"]);
G2L["1b7"]["BorderSizePixel"] = 0;
G2L["1b7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b7"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1b7"]["Image"] = [[rbxassetid://10709768787]];
G2L["1b7"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1b7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b7"]["BackgroundTransparency"] = 1;
G2L["1b7"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.buttons.tracers.UICorner
G2L["1b8"] = Instance.new("UICorner", G2L["1b6"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc
G2L["1b9"] = Instance.new("Frame", G2L["158"]);
G2L["1b9"]["BorderSizePixel"] = 0;
G2L["1b9"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1b9"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["1b9"]["Position"] = UDim2.new(0.20183, 0, 0.26167, 0);
G2L["1b9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b9"]["Name"] = [[misc]];
-- Attributes
G2L["1b9"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.LocalScript
G2L["1ba"] = Instance.new("LocalScript", G2L["1b9"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.UICorner
G2L["1bb"] = Instance.new("UICorner", G2L["1b9"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.title
G2L["1bc"] = Instance.new("TextLabel", G2L["1b9"]);
G2L["1bc"]["BorderSizePixel"] = 0;
G2L["1bc"]["TextSize"] = 20;
G2L["1bc"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1bc"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1bc"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1bc"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1bc"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1bc"]["BackgroundTransparency"] = 1;
G2L["1bc"]["Size"] = UDim2.new(0, 200, 0, 26);
G2L["1bc"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1bc"]["Text"] = [[Miscellanous]];
G2L["1bc"]["Name"] = [[title]];
G2L["1bc"]["Position"] = UDim2.new(0.02752, 0, 0.04, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons
G2L["1bd"] = Instance.new("Frame", G2L["1b9"]);
G2L["1bd"]["BorderSizePixel"] = 0;
G2L["1bd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1bd"]["Size"] = UDim2.new(0, 204, 0, 105);
G2L["1bd"]["Position"] = UDim2.new(0.02752, 0, 0.21333, 0);
G2L["1bd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1bd"]["Name"] = [[buttons]];
G2L["1bd"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.LocalScript
G2L["1be"] = Instance.new("LocalScript", G2L["1bd"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.UIListLayout
G2L["1bf"] = Instance.new("UIListLayout", G2L["1bd"]);
G2L["1bf"]["Wraps"] = true;
G2L["1bf"]["Padding"] = UDim.new(0, 5);
G2L["1bf"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["1bf"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antiafk
G2L["1c0"] = Instance.new("TextButton", G2L["1bd"]);
G2L["1c0"]["BorderSizePixel"] = 0;
G2L["1c0"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1c0"]["TextSize"] = 14;
G2L["1c0"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c0"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1c0"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1c0"]["Size"] = UDim2.new(0, 84, 0, 20);
G2L["1c0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c0"]["Text"] = [[Anti AFK  ]];
G2L["1c0"]["Name"] = [[antiafk]];
-- Attributes
G2L["1c0"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antiafk.ImageLabel
G2L["1c1"] = Instance.new("ImageLabel", G2L["1c0"]);
G2L["1c1"]["BorderSizePixel"] = 0;
G2L["1c1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c1"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1c1"]["Image"] = [[rbxassetid://10709782497]];
G2L["1c1"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1c1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c1"]["BackgroundTransparency"] = 1;
G2L["1c1"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antiafk.UICorner
G2L["1c2"] = Instance.new("UICorner", G2L["1c0"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.esp
G2L["1c3"] = Instance.new("TextButton", G2L["1bd"]);
G2L["1c3"]["BorderSizePixel"] = 0;
G2L["1c3"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1c3"]["TextSize"] = 14;
G2L["1c3"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c3"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1c3"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1c3"]["Size"] = UDim2.new(0, 54, 0, 20);
G2L["1c3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c3"]["Text"] = [[ESP  ]];
G2L["1c3"]["Name"] = [[esp]];
G2L["1c3"]["Position"] = UDim2.new(0.2899, 0, 0, 0);
-- Attributes
G2L["1c3"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.esp.ImageLabel
G2L["1c4"] = Instance.new("ImageLabel", G2L["1c3"]);
G2L["1c4"]["BorderSizePixel"] = 0;
G2L["1c4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c4"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1c4"]["Image"] = [[rbxassetid://10723346959]];
G2L["1c4"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1c4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c4"]["BackgroundTransparency"] = 1;
G2L["1c4"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.esp.UICorner
G2L["1c5"] = Instance.new("UICorner", G2L["1c3"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.instantpp
G2L["1c6"] = Instance.new("TextButton", G2L["1bd"]);
G2L["1c6"]["BorderSizePixel"] = 0;
G2L["1c6"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1c6"]["TextSize"] = 14;
G2L["1c6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c6"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1c6"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1c6"]["Size"] = UDim2.new(0, 181, 0, 20);
G2L["1c6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c6"]["Text"] = [[Instant proximity prompt  ]];
G2L["1c6"]["Name"] = [[instantpp]];
G2L["1c6"]["Position"] = UDim2.new(0.48208, 0, 0, 0);
-- Attributes
G2L["1c6"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.instantpp.ImageLabel
G2L["1c7"] = Instance.new("ImageLabel", G2L["1c6"]);
G2L["1c7"]["BorderSizePixel"] = 0;
G2L["1c7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c7"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1c7"]["Image"] = [[rbxassetid://10723345749]];
G2L["1c7"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1c7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c7"]["BackgroundTransparency"] = 1;
G2L["1c7"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.instantpp.UICorner
G2L["1c8"] = Instance.new("UICorner", G2L["1c6"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antifling
G2L["1c9"] = Instance.new("TextButton", G2L["1bd"]);
G2L["1c9"]["BorderSizePixel"] = 0;
G2L["1c9"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1c9"]["TextSize"] = 14;
G2L["1c9"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c9"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1c9"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1c9"]["Size"] = UDim2.new(0, 84, 0, 20);
G2L["1c9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c9"]["Text"] = [[Anti fling  ]];
G2L["1c9"]["Name"] = [[antifling]];
G2L["1c9"]["Position"] = UDim2.new(0, 0, 0.47619, 0);
-- Attributes
G2L["1c9"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antifling.ImageLabel
G2L["1ca"] = Instance.new("ImageLabel", G2L["1c9"]);
G2L["1ca"]["BorderSizePixel"] = 0;
G2L["1ca"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ca"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1ca"]["Image"] = [[rbxassetid://10734951847]];
G2L["1ca"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1ca"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ca"]["BackgroundTransparency"] = 1;
G2L["1ca"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.antifling.UICorner
G2L["1cb"] = Instance.new("UICorner", G2L["1c9"]);



-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.fullbright
G2L["1cc"] = Instance.new("TextButton", G2L["1bd"]);
G2L["1cc"]["BorderSizePixel"] = 0;
G2L["1cc"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1cc"]["TextSize"] = 14;
G2L["1cc"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1cc"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1cc"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1cc"]["Size"] = UDim2.new(0, 89, 0, 20);
G2L["1cc"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1cc"]["Text"] = [[Fullbright  ]];
G2L["1cc"]["Name"] = [[fullbright]];
G2L["1cc"]["Position"] = UDim2.new(0, 0, 0.47619, 0);
-- Attributes
G2L["1cc"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.fullbright.ImageLabel
G2L["1cd"] = Instance.new("ImageLabel", G2L["1cc"]);
G2L["1cd"]["BorderSizePixel"] = 0;
G2L["1cd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1cd"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1cd"]["Image"] = [[rbxassetid://10723425852]];
G2L["1cd"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1cd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1cd"]["BackgroundTransparency"] = 1;
G2L["1cd"]["Position"] = UDim2.new(0, 5, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.fullbright.UICorner
G2L["1ce"] = Instance.new("UICorner", G2L["1cc"]);



-- StarterGui.zerohub.interface.main.tabs.settings
G2L["1cf"] = Instance.new("Frame", G2L["1c"]);
G2L["1cf"]["Visible"] = false;
G2L["1cf"]["BorderSizePixel"] = 0;
G2L["1cf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1cf"]["Size"] = UDim2.new(0, 480, 0, 276);
G2L["1cf"]["Position"] = UDim2.new(-0, 0, 0.1068, 0);
G2L["1cf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1cf"]["Name"] = [[settings]];
G2L["1cf"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs
G2L["1d0"] = Instance.new("Folder", G2L["1cf"]);
G2L["1d0"]["Name"] = [[teleporttabs]];


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai
G2L["1d1"] = Instance.new("Frame", G2L["1d0"]);
G2L["1d1"]["BorderSizePixel"] = 0;
G2L["1d1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d1"]["Size"] = UDim2.new(0, 462, 0, 246);
G2L["1d1"]["Position"] = UDim2.new(0.01875, 0, 0.10768, 0);
G2L["1d1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d1"]["Name"] = [[ai]];
G2L["1d1"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame
G2L["1d2"] = Instance.new("ScrollingFrame", G2L["1d1"]);
G2L["1d2"]["Active"] = true;
G2L["1d2"]["BorderSizePixel"] = 0;
G2L["1d2"]["CanvasSize"] = UDim2.new(0, 0, 1.55, 0);
G2L["1d2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d2"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1d2"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d2"]["ScrollBarThickness"] = 0;
G2L["1d2"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.UIListLayout
G2L["1d3"] = Instance.new("UIListLayout", G2L["1d2"]);
G2L["1d3"]["Padding"] = UDim.new(0, 8);
G2L["1d3"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey
G2L["1d4"] = Instance.new("Frame", G2L["1d2"]);
G2L["1d4"]["BorderSizePixel"] = 0;
G2L["1d4"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1d4"]["Size"] = UDim2.new(0, 462, 0, 100);
G2L["1d4"]["Position"] = UDim2.new(0, 0, -0, 0);
G2L["1d4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d4"]["Name"] = [[setapikey]];
-- Attributes
G2L["1d4"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.UICorner
G2L["1d5"] = Instance.new("UICorner", G2L["1d4"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextLabel
G2L["1d6"] = Instance.new("TextLabel", G2L["1d4"]);
G2L["1d6"]["TextWrapped"] = true;
G2L["1d6"]["BorderSizePixel"] = 0;
G2L["1d6"]["TextSize"] = 20;
G2L["1d6"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1d6"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1d6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d6"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1d6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d6"]["BackgroundTransparency"] = 1;
G2L["1d6"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["1d6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d6"]["Text"] = [[Set Gemini API key]];
G2L["1d6"]["Position"] = UDim2.new(0.02485, 0, 0.075, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextLabel
G2L["1d7"] = Instance.new("TextLabel", G2L["1d4"]);
G2L["1d7"]["TextWrapped"] = true;
G2L["1d7"]["BorderSizePixel"] = 0;
G2L["1d7"]["TextSize"] = 14;
G2L["1d7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1d7"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1d7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d7"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1d7"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1d7"]["BackgroundTransparency"] = 1;
G2L["1d7"]["Size"] = UDim2.new(0, 441, 0, 42);
G2L["1d7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d7"]["Text"] = [[Strictly required to make zerohub intelligence work. Insert it and then press enter to set it.]];
G2L["1d7"]["Position"] = UDim2.new(0.02485, 0, 0.26, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextBox
G2L["1d8"] = Instance.new("TextBox", G2L["1d4"]);
G2L["1d8"]["CursorPosition"] = -1;
G2L["1d8"]["PlaceholderColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1d8"]["BorderSizePixel"] = 0;
G2L["1d8"]["TextSize"] = 12;
G2L["1d8"]["TextColor3"] = Color3.fromRGB(41, 41, 41);
G2L["1d8"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1d8"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1d8"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["1d8"]["PlaceholderText"] = [[Gemini API key (will be invisible)]];
G2L["1d8"]["Size"] = UDim2.new(0, 441, 0, 24);
G2L["1d8"]["Position"] = UDim2.new(0.50214, 0, 0.615, 0);
G2L["1d8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d8"]["Text"] = [[]];
-- Attributes
G2L["1d8"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextBox.LocalScript
G2L["1d9"] = Instance.new("LocalScript", G2L["1d8"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextBox.UICorner
G2L["1da"] = Instance.new("UICorner", G2L["1d8"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.info
G2L["1db"] = Instance.new("Frame", G2L["1d2"]);
G2L["1db"]["BorderSizePixel"] = 0;
G2L["1db"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1db"]["Size"] = UDim2.new(1, 0, -0.0639, 100);
G2L["1db"]["Position"] = UDim2.new(0, 0, 0.28324, 0);
G2L["1db"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1db"]["Name"] = [[info]];
-- Attributes
G2L["1db"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.info.UICorner
G2L["1dc"] = Instance.new("UICorner", G2L["1db"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.info.ImageLabel
G2L["1dd"] = Instance.new("ImageLabel", G2L["1db"]);
G2L["1dd"]["BorderSizePixel"] = 0;
G2L["1dd"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1dd"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1dd"]["Image"] = [[rbxassetid://10723415903]];
G2L["1dd"]["Size"] = UDim2.new(0, 30, 0, 30);
G2L["1dd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1dd"]["BackgroundTransparency"] = 1;
G2L["1dd"]["Position"] = UDim2.new(0.01948, 0, 0.12481, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.info.TextLabel
G2L["1de"] = Instance.new("TextLabel", G2L["1db"]);
G2L["1de"]["TextWrapped"] = true;
G2L["1de"]["BorderSizePixel"] = 0;
G2L["1de"]["TextSize"] = 14;
G2L["1de"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1de"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1de"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1de"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1de"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1de"]["BackgroundTransparency"] = 1;
G2L["1de"]["Size"] = UDim2.new(0, 403, 0, 64);
G2L["1de"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1de"]["Text"] = [[We do not collect your Gemini API key. It will be only saved in the workspace folder of your exploit. This script is fully open source and you can check for yourself. If you need help, please join the Discord server at https://join.zerohub.cc/ and contact dnezero.]];
G2L["1de"]["Position"] = UDim2.new(0.1039, 0, 0.10048, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize
G2L["1df"] = Instance.new("Frame", G2L["1d0"]);
G2L["1df"]["Visible"] = false;
G2L["1df"]["BorderSizePixel"] = 0;
G2L["1df"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1df"]["Size"] = UDim2.new(0, 461, 0, 191);
G2L["1df"]["Position"] = UDim2.new(0.01875, 0, 0.1113, 0);
G2L["1df"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1df"]["Name"] = [[customize]];
G2L["1df"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIListLayout
G2L["1e0"] = Instance.new("UIListLayout", G2L["1df"]);
G2L["1e0"]["Padding"] = UDim.new(0, 8);
G2L["1e0"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme
G2L["1e1"] = Instance.new("Frame", G2L["1df"]);
G2L["1e1"]["BorderSizePixel"] = 0;
G2L["1e1"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1e1"]["Size"] = UDim2.new(0, 458, 0, 87);
G2L["1e1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e1"]["Name"] = [[lighttheme]];
-- Attributes
G2L["1e1"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.UICorner
G2L["1e2"] = Instance.new("UICorner", G2L["1e1"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextLabel
G2L["1e3"] = Instance.new("TextLabel", G2L["1e1"]);
G2L["1e3"]["TextWrapped"] = true;
G2L["1e3"]["BorderSizePixel"] = 0;
G2L["1e3"]["TextSize"] = 20;
G2L["1e3"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1e3"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1e3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e3"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1e3"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e3"]["BackgroundTransparency"] = 1;
G2L["1e3"]["Size"] = UDim2.new(0, 315, 0, 42);
G2L["1e3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e3"]["Text"] = [[Switch theme]];
G2L["1e3"]["Position"] = UDim2.new(0.02466, 0, 0.09149, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextLabel
G2L["1e4"] = Instance.new("TextLabel", G2L["1e1"]);
G2L["1e4"]["TextWrapped"] = true;
G2L["1e4"]["BorderSizePixel"] = 0;
G2L["1e4"]["TextSize"] = 14;
G2L["1e4"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1e4"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["1e4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e4"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1e4"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1e4"]["BackgroundTransparency"] = 1;
G2L["1e4"]["Size"] = UDim2.new(0, 436, 0, 23);
G2L["1e4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e4"]["Text"] = [[Switch from dark to light and viceversa.]];
G2L["1e4"]["Position"] = UDim2.new(0.02466, 0, 0.30519, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton
G2L["1e5"] = Instance.new("TextButton", G2L["1e1"]);
G2L["1e5"]["BorderSizePixel"] = 0;
G2L["1e5"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1e5"]["TextSize"] = 14;
G2L["1e5"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1e5"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["1e5"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1e5"]["Size"] = UDim2.new(0, 121, 0, 24);
G2L["1e5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e5"]["Text"] = [[Switch themes  ]];
G2L["1e5"]["Position"] = UDim2.new(0.71243, 0, 0.6145, 0);
-- Attributes
G2L["1e5"]:SetAttribute([[OriginalColor]], Color3.fromRGB(41, 41, 41));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.anim
G2L["1e6"] = Instance.new("LocalScript", G2L["1e5"]);
G2L["1e6"]["Name"] = [[anim]];


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.LocalScript
G2L["1e7"] = Instance.new("LocalScript", G2L["1e5"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.UICorner
G2L["1e8"] = Instance.new("UICorner", G2L["1e5"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.ImageLabel
G2L["1e9"] = Instance.new("ImageLabel", G2L["1e5"]);
G2L["1e9"]["BorderSizePixel"] = 0;
G2L["1e9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e9"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1e9"]["Image"] = [[rbxassetid://10734910187]];
G2L["1e9"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1e9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e9"]["BackgroundTransparency"] = 1;
G2L["1e9"]["Position"] = UDim2.new(0.058, 0, 0.22, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN
G2L["1ea"] = Instance.new("Frame", G2L["1df"]);
G2L["1ea"]["BorderSizePixel"] = 0;
G2L["1ea"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ea"]["Size"] = UDim2.new(0, 230, 0, 37);
G2L["1ea"]["Position"] = UDim2.new(0.07831, 0, 0.2688, 0);
G2L["1ea"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ea"]["Name"] = [[UIEFFECTSPLEASEBURNMEDOWN]];
G2L["1ea"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.rain
G2L["1eb"] = Instance.new("TextButton", G2L["1ea"]);
G2L["1eb"]["BorderSizePixel"] = 0;
G2L["1eb"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1eb"]["TextSize"] = 14;
G2L["1eb"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1eb"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1eb"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1eb"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1eb"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["1eb"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1eb"]["Text"] = [[]];
G2L["1eb"]["Name"] = [[rain]];
G2L["1eb"]["Position"] = UDim2.new(0.03374, 0, 0.69856, 0);
-- Attributes
G2L["1eb"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.rain.LocalScript
G2L["1ec"] = Instance.new("LocalScript", G2L["1eb"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.rain.UICorner
G2L["1ed"] = Instance.new("UICorner", G2L["1eb"]);
G2L["1ed"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.rain.ImageLabel
G2L["1ee"] = Instance.new("ImageLabel", G2L["1eb"]);
G2L["1ee"]["BorderSizePixel"] = 0;
G2L["1ee"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ee"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1ee"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1ee"]["Image"] = [[rbxassetid://10723344432]];
G2L["1ee"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1ee"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ee"]["BackgroundTransparency"] = 1;
G2L["1ee"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.sakura
G2L["1ef"] = Instance.new("TextButton", G2L["1ea"]);
G2L["1ef"]["BorderSizePixel"] = 0;
G2L["1ef"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1ef"]["TextSize"] = 14;
G2L["1ef"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1ef"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1ef"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1ef"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1ef"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["1ef"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ef"]["Text"] = [[]];
G2L["1ef"]["Name"] = [[sakura]];
G2L["1ef"]["Position"] = UDim2.new(0.51385, 0, 0.70232, 0);
-- Attributes
G2L["1ef"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.sakura.LocalScript
G2L["1f0"] = Instance.new("LocalScript", G2L["1ef"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.sakura.UICorner
G2L["1f1"] = Instance.new("UICorner", G2L["1ef"]);
G2L["1f1"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.sakura.ImageLabel
G2L["1f2"] = Instance.new("ImageLabel", G2L["1ef"]);
G2L["1f2"]["BorderSizePixel"] = 0;
G2L["1f2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1f2"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1f2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1f2"]["Image"] = [[rbxassetid://10723425539]];
G2L["1f2"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1f2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f2"]["BackgroundTransparency"] = 1;
G2L["1f2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.stars
G2L["1f3"] = Instance.new("TextButton", G2L["1ea"]);
G2L["1f3"]["BorderSizePixel"] = 0;
G2L["1f3"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1f3"]["TextSize"] = 14;
G2L["1f3"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1f3"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1f3"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1f3"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1f3"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["1f3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f3"]["Text"] = [[]];
G2L["1f3"]["Name"] = [[stars]];
G2L["1f3"]["Position"] = UDim2.new(0.27104, 0, 0.84776, 0);
-- Attributes
G2L["1f3"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.stars.LocalScript
G2L["1f4"] = Instance.new("LocalScript", G2L["1f3"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.stars.UICorner
G2L["1f5"] = Instance.new("UICorner", G2L["1f3"]);
G2L["1f5"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.stars.ImageLabel
G2L["1f6"] = Instance.new("ImageLabel", G2L["1f3"]);
G2L["1f6"]["BorderSizePixel"] = 0;
G2L["1f6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1f6"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1f6"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1f6"]["Image"] = [[rbxassetid://10734966248]];
G2L["1f6"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1f6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f6"]["BackgroundTransparency"] = 1;
G2L["1f6"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.snow
G2L["1f7"] = Instance.new("TextButton", G2L["1ea"]);
G2L["1f7"]["BorderSizePixel"] = 0;
G2L["1f7"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1f7"]["TextSize"] = 14;
G2L["1f7"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1f7"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1f7"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1f7"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1f7"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["1f7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f7"]["Text"] = [[]];
G2L["1f7"]["Name"] = [[snow]];
G2L["1f7"]["Position"] = UDim2.new(0.2716, 0, 0.70232, 0);
-- Attributes
G2L["1f7"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.snow.LocalScript
G2L["1f8"] = Instance.new("LocalScript", G2L["1f7"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.snow.UICorner
G2L["1f9"] = Instance.new("UICorner", G2L["1f7"]);
G2L["1f9"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.snow.ImageLabel
G2L["1fa"] = Instance.new("ImageLabel", G2L["1f7"]);
G2L["1fa"]["BorderSizePixel"] = 0;
G2L["1fa"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1fa"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1fa"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1fa"]["Image"] = [[rbxassetid://10734964600]];
G2L["1fa"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1fa"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1fa"]["BackgroundTransparency"] = 1;
G2L["1fa"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.UIGridLayout
G2L["1fb"] = Instance.new("UIGridLayout", G2L["1ea"]);
G2L["1fb"]["CellSize"] = UDim2.new(0, 30, 0, 30);
G2L["1fb"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.glitch
G2L["1fc"] = Instance.new("TextButton", G2L["1ea"]);
G2L["1fc"]["BorderSizePixel"] = 0;
G2L["1fc"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["1fc"]["TextSize"] = 14;
G2L["1fc"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1fc"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["1fc"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1fc"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["1fc"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["1fc"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1fc"]["Text"] = [[]];
G2L["1fc"]["Name"] = [[glitch]];
G2L["1fc"]["Position"] = UDim2.new(0.51385, 0, 0.84776, 0);
-- Attributes
G2L["1fc"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.glitch.LocalScript
G2L["1fd"] = Instance.new("LocalScript", G2L["1fc"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.glitch.UICorner
G2L["1fe"] = Instance.new("UICorner", G2L["1fc"]);
G2L["1fe"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.glitch.ImageLabel
G2L["1ff"] = Instance.new("ImageLabel", G2L["1fc"]);
G2L["1ff"]["BorderSizePixel"] = 0;
G2L["1ff"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1ff"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["1ff"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1ff"]["Image"] = [[rbxassetid://10734887784]];
G2L["1ff"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["1ff"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1ff"]["BackgroundTransparency"] = 1;
G2L["1ff"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.matrix
G2L["200"] = Instance.new("TextButton", G2L["1ea"]);
G2L["200"]["BorderSizePixel"] = 0;
G2L["200"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["200"]["TextSize"] = 14;
G2L["200"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["200"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["200"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["200"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["200"]["Size"] = UDim2.new(0, 79, 0, 30);
G2L["200"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["200"]["Text"] = [[]];
G2L["200"]["Name"] = [[matrix]];
G2L["200"]["Position"] = UDim2.new(0.03626, 0, 0.84776, 0);
-- Attributes
G2L["200"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.matrix.LocalScript
G2L["201"] = Instance.new("LocalScript", G2L["200"]);



-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.matrix.UICorner
G2L["202"] = Instance.new("UICorner", G2L["200"]);
G2L["202"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.matrix.ImageLabel
G2L["203"] = Instance.new("ImageLabel", G2L["200"]);
G2L["203"]["BorderSizePixel"] = 0;
G2L["203"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["203"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["203"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["203"]["Image"] = [[rbxassetid://10709810463]];
G2L["203"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["203"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["203"]["BackgroundTransparency"] = 1;
G2L["203"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.tabsw
G2L["204"] = Instance.new("LocalScript", G2L["1cf"]);
G2L["204"]["Name"] = [[tabsw]];


-- StarterGui.zerohub.interface.main.tabs.settings.top
G2L["205"] = Instance.new("Frame", G2L["1cf"]);
G2L["205"]["BorderSizePixel"] = 0;
G2L["205"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["205"]["Size"] = UDim2.new(0, 409, 0, 33);
G2L["205"]["Position"] = UDim2.new(0.01875, 0, -0.02174, 0);
G2L["205"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["205"]["Name"] = [[top]];
G2L["205"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.tabs.settings.top.UIListLayout
G2L["206"] = Instance.new("UIListLayout", G2L["205"]);
G2L["206"]["Padding"] = UDim.new(0, 5);
G2L["206"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
G2L["206"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["206"]["FillDirection"] = Enum.FillDirection.Horizontal;


-- StarterGui.zerohub.interface.main.tabs.settings.top.ai
G2L["207"] = Instance.new("TextButton", G2L["205"]);
G2L["207"]["BorderSizePixel"] = 0;
G2L["207"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["207"]["TextSize"] = 14;
G2L["207"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["207"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["207"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["207"]["Size"] = UDim2.new(0, 48, 0, 23);
G2L["207"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["207"]["Text"] = [[AI  ]];
G2L["207"]["Name"] = [[ai]];
G2L["207"]["Position"] = UDim2.new(0, 0, 0.15152, 0);
-- Attributes
G2L["207"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.tabs.settings.top.ai.UICorner
G2L["208"] = Instance.new("UICorner", G2L["207"]);



-- StarterGui.zerohub.interface.main.tabs.settings.top.ai.ImageLabel
G2L["209"] = Instance.new("ImageLabel", G2L["207"]);
G2L["209"]["BorderSizePixel"] = 0;
G2L["209"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["209"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["209"]["Image"] = [[rbxassetid://10709782230]];
G2L["209"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["209"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["209"]["BackgroundTransparency"] = 1;
G2L["209"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.tabs.settings.top.customize
G2L["20a"] = Instance.new("TextButton", G2L["205"]);
G2L["20a"]["BorderSizePixel"] = 0;
G2L["20a"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["20a"]["TextSize"] = 14;
G2L["20a"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["20a"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["20a"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["20a"]["Size"] = UDim2.new(0, 95, 0, 23);
G2L["20a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20a"]["Text"] = [[Customize  ]];
G2L["20a"]["Name"] = [[customize]];
G2L["20a"]["Position"] = UDim2.new(0.12958, 0, 0.15152, 0);
-- Attributes
G2L["20a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.tabs.settings.top.customize.UICorner
G2L["20b"] = Instance.new("UICorner", G2L["20a"]);



-- StarterGui.zerohub.interface.main.tabs.settings.top.customize.ImageLabel
G2L["20c"] = Instance.new("ImageLabel", G2L["20a"]);
G2L["20c"]["BorderSizePixel"] = 0;
G2L["20c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["20c"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["20c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["20c"]["Image"] = [[rbxassetid://10734919691]];
G2L["20c"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["20c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20c"]["BackgroundTransparency"] = 1;
G2L["20c"]["Position"] = UDim2.new(0, 15, 0.5, 0);


-- StarterGui.zerohub.interface.main.drag
G2L["20d"] = Instance.new("LocalScript", G2L["12"]);
G2L["20d"]["Name"] = [[drag]];


-- StarterGui.zerohub.interface.main.notifications
G2L["20e"] = Instance.new("Folder", G2L["12"]);
G2L["20e"]["Name"] = [[notifications]];


-- StarterGui.zerohub.interface.main.notifications.examplesuccess
G2L["20f"] = Instance.new("Frame", G2L["20e"]);
G2L["20f"]["Visible"] = false;
G2L["20f"]["BorderSizePixel"] = 0;
G2L["20f"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["20f"]["Size"] = UDim2.new(0, 170, 0, 45);
G2L["20f"]["Position"] = UDim2.new(0.625, 0, 0.81965, 0);
G2L["20f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20f"]["Name"] = [[examplesuccess]];
-- Attributes
G2L["20f"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.UICorner
G2L["210"] = Instance.new("UICorner", G2L["20f"]);



-- StarterGui.zerohub.interface.main.notifications.examplesuccess.UIShadow
G2L["211"] = Instance.new("UIShadow", G2L["20f"]);



-- StarterGui.zerohub.interface.main.notifications.examplesuccess.icon
G2L["212"] = Instance.new("ImageLabel", G2L["20f"]);
G2L["212"]["BorderSizePixel"] = 0;
G2L["212"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["212"]["Image"] = [[rbxassetid://10709790644]];
G2L["212"]["Size"] = UDim2.new(0, 25, 0, 25);
G2L["212"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["212"]["BackgroundTransparency"] = 1;
G2L["212"]["Name"] = [[icon]];
G2L["212"]["Position"] = UDim2.new(0.06471, 0, 0.22222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.title
G2L["213"] = Instance.new("TextLabel", G2L["20f"]);
G2L["213"]["BorderSizePixel"] = 0;
G2L["213"]["TextSize"] = 14;
G2L["213"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["213"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["213"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["213"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["213"]["BackgroundTransparency"] = 1;
G2L["213"]["Size"] = UDim2.new(0, 123, 0, 15);
G2L["213"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["213"]["Text"] = [[Success]];
G2L["213"]["Name"] = [[title]];
G2L["213"]["Position"] = UDim2.new(0.24118, 0, 0.22222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.desc
G2L["214"] = Instance.new("TextLabel", G2L["20f"]);
G2L["214"]["TextWrapped"] = true;
G2L["214"]["BorderSizePixel"] = 0;
G2L["214"]["TextSize"] = 12;
G2L["214"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["214"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["214"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["214"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["214"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["214"]["BackgroundTransparency"] = 1;
G2L["214"]["Size"] = UDim2.new(0, 123, 0, 12);
G2L["214"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["214"]["Text"] = [[fake it till you make it]];
G2L["214"]["Name"] = [[desc]];
G2L["214"]["Position"] = UDim2.new(0.24082, 0, 0.50222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.bar
G2L["215"] = Instance.new("Frame", G2L["20f"]);
G2L["215"]["BorderSizePixel"] = 0;
G2L["215"]["BackgroundColor3"] = Color3.fromRGB(101, 101, 101);
G2L["215"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["215"]["Size"] = UDim2.new(0, 150, 0, 3);
G2L["215"]["Position"] = UDim2.new(0.5, 0, 0.92726, 0);
G2L["215"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["215"]["Name"] = [[bar]];


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.bar.UICorner
G2L["216"] = Instance.new("UICorner", G2L["215"]);
G2L["216"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.bar.fill
G2L["217"] = Instance.new("Frame", G2L["215"]);
G2L["217"]["BorderSizePixel"] = 0;
G2L["217"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["217"]["Size"] = UDim2.new(0, 100, 0, 3);
G2L["217"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["217"]["Name"] = [[fill]];


-- StarterGui.zerohub.interface.main.notifications.examplesuccess.bar.fill.UICorner
G2L["218"] = Instance.new("UICorner", G2L["217"]);
G2L["218"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.main.notifications.examplewarning
G2L["219"] = Instance.new("Frame", G2L["20e"]);
G2L["219"]["Visible"] = false;
G2L["219"]["BorderSizePixel"] = 0;
G2L["219"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
G2L["219"]["Size"] = UDim2.new(0, 170, 0, 45);
G2L["219"]["Position"] = UDim2.new(0.625, 0, 0.65137, 0);
G2L["219"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["219"]["Name"] = [[examplewarning]];
-- Attributes
G2L["219"]:SetAttribute([[OriginalColor]], Color3.fromRGB(31, 31, 31));


-- StarterGui.zerohub.interface.main.notifications.examplewarning.UICorner
G2L["21a"] = Instance.new("UICorner", G2L["219"]);



-- StarterGui.zerohub.interface.main.notifications.examplewarning.UIShadow
G2L["21b"] = Instance.new("UIShadow", G2L["219"]);



-- StarterGui.zerohub.interface.main.notifications.examplewarning.icon
G2L["21c"] = Instance.new("ImageLabel", G2L["219"]);
G2L["21c"]["BorderSizePixel"] = 0;
G2L["21c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21c"]["Image"] = [[rbxassetid://10709753149]];
G2L["21c"]["Size"] = UDim2.new(0, 25, 0, 25);
G2L["21c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21c"]["BackgroundTransparency"] = 1;
G2L["21c"]["Name"] = [[icon]];
G2L["21c"]["Position"] = UDim2.new(0.06471, 0, 0.22222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplewarning.title
G2L["21d"] = Instance.new("TextLabel", G2L["219"]);
G2L["21d"]["BorderSizePixel"] = 0;
G2L["21d"]["TextSize"] = 14;
G2L["21d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["21d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["21d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21d"]["BackgroundTransparency"] = 1;
G2L["21d"]["Size"] = UDim2.new(0, 123, 0, 15);
G2L["21d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21d"]["Text"] = [[Warning]];
G2L["21d"]["Name"] = [[title]];
G2L["21d"]["Position"] = UDim2.new(0.24118, 0, 0.22222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplewarning.desc
G2L["21e"] = Instance.new("TextLabel", G2L["219"]);
G2L["21e"]["TextWrapped"] = true;
G2L["21e"]["BorderSizePixel"] = 0;
G2L["21e"]["TextSize"] = 12;
G2L["21e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["21e"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["21e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21e"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["21e"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["21e"]["BackgroundTransparency"] = 1;
G2L["21e"]["Size"] = UDim2.new(0, 123, 0, 12);
G2L["21e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21e"]["Text"] = [[im warnin' u boy]];
G2L["21e"]["Name"] = [[desc]];
G2L["21e"]["Position"] = UDim2.new(0.24082, 0, 0.50222, 0);


-- StarterGui.zerohub.interface.main.notifications.examplewarning.bar
G2L["21f"] = Instance.new("Frame", G2L["219"]);
G2L["21f"]["BorderSizePixel"] = 0;
G2L["21f"]["BackgroundColor3"] = Color3.fromRGB(101, 101, 101);
G2L["21f"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["21f"]["Size"] = UDim2.new(0, 150, 0, 3);
G2L["21f"]["Position"] = UDim2.new(0.5, 0, 0.92726, 0);
G2L["21f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21f"]["Name"] = [[bar]];


-- StarterGui.zerohub.interface.main.notifications.examplewarning.bar.UICorner
G2L["220"] = Instance.new("UICorner", G2L["21f"]);
G2L["220"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.main.notifications.examplewarning.bar.fill
G2L["221"] = Instance.new("Frame", G2L["21f"]);
G2L["221"]["BorderSizePixel"] = 0;
G2L["221"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["221"]["Size"] = UDim2.new(0, 100, 0, 3);
G2L["221"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["221"]["Name"] = [[fill]];


-- StarterGui.zerohub.interface.main.notifications.examplewarning.bar.fill.UICorner
G2L["222"] = Instance.new("UICorner", G2L["221"]);
G2L["222"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.zerohub.interface.main.notifications.notificationsystem
G2L["223"] = Instance.new("LocalScript", G2L["20e"]);
G2L["223"]["Name"] = [[notificationsystem]];


-- StarterGui.zerohub.interface.main.sidebar
G2L["224"] = Instance.new("Frame", G2L["12"]);
G2L["224"]["Visible"] = false;
G2L["224"]["ZIndex"] = 10;
G2L["224"]["BorderSizePixel"] = 0;
G2L["224"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["224"]["Size"] = UDim2.new(0, 480, 0, 309);
G2L["224"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["224"]["Name"] = [[sidebar]];
G2L["224"]["BackgroundTransparency"] = 0.2;


-- StarterGui.zerohub.interface.main.sidebar.UICorner
G2L["225"] = Instance.new("UICorner", G2L["224"]);



-- StarterGui.zerohub.interface.main.sidebar.main
G2L["226"] = Instance.new("Frame", G2L["224"]);
G2L["226"]["BorderSizePixel"] = 0;
G2L["226"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["226"]["Size"] = UDim2.new(0, 186, 0, 309);
G2L["226"]["Position"] = UDim2.new(0, 0, 0, 0);
G2L["226"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["226"]["Name"] = [[main]];
-- Attributes
G2L["226"]:SetAttribute([[OriginalColor]], Color3.fromRGB(21, 21, 21));


-- StarterGui.zerohub.interface.main.sidebar.main.UICorner
G2L["227"] = Instance.new("UICorner", G2L["226"]);



-- StarterGui.zerohub.interface.main.sidebar.main.close
G2L["228"] = Instance.new("ImageButton", G2L["226"]);
G2L["228"]["BorderSizePixel"] = 0;
G2L["228"]["BackgroundTransparency"] = 1;
G2L["228"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["228"]["AnchorPoint"] = Vector2.new(0, 0.5);
G2L["228"]["Image"] = [[rbxassetid://10747384394]];
G2L["228"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["228"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["228"]["Name"] = [[close]];
G2L["228"]["Position"] = UDim2.new(0.05309, 0, 0.05987, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.sidebartitle
G2L["229"] = Instance.new("TextLabel", G2L["226"]);
G2L["229"]["BorderSizePixel"] = 0;
G2L["229"]["TextSize"] = 16;
G2L["229"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["229"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["229"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["229"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["229"]["BackgroundTransparency"] = 1;
G2L["229"]["Size"] = UDim2.new(0, 131, 0, 26);
G2L["229"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["229"]["Text"] = [[Menu]];
G2L["229"]["Name"] = [[sidebartitle]];
G2L["229"]["Position"] = UDim2.new(0.2043, 0, 0.01618, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.separator
G2L["22a"] = Instance.new("Frame", G2L["226"]);
G2L["22a"]["BorderSizePixel"] = 0;
G2L["22a"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["22a"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["22a"]["Size"] = UDim2.new(0, 170, 0, 1);
G2L["22a"]["Position"] = UDim2.new(0.5, 0, 0.8, 0);
G2L["22a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22a"]["Name"] = [[separator]];
G2L["22a"]["BackgroundTransparency"] = 0.5;
-- Attributes
G2L["22a"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.sidebar.main.bottom
G2L["22b"] = Instance.new("Frame", G2L["226"]);
G2L["22b"]["BorderSizePixel"] = 0;
G2L["22b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22b"]["Size"] = UDim2.new(0, 168, 0, 51);
G2L["22b"]["Position"] = UDim2.new(0.05376, 0, 0.81965, 0);
G2L["22b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22b"]["Name"] = [[bottom]];
G2L["22b"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.sidebar.main.bottom.UIListLayout
G2L["22c"] = Instance.new("UIListLayout", G2L["22b"]);
G2L["22c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.sidebar.main.bottom.infiniteyield
G2L["22d"] = Instance.new("TextButton", G2L["22b"]);
G2L["22d"]["BorderSizePixel"] = 0;
G2L["22d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["22d"]["TextSize"] = 14;
G2L["22d"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["22d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["22d"]["BackgroundTransparency"] = 1;
G2L["22d"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["22d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22d"]["Text"] = [[       Infinite Yield]];
G2L["22d"]["Name"] = [[infiniteyield]];


-- StarterGui.zerohub.interface.main.sidebar.main.bottom.infiniteyield.ImageLabel
G2L["22e"] = Instance.new("ImageLabel", G2L["22d"]);
G2L["22e"]["BorderSizePixel"] = 0;
G2L["22e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22e"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["22e"]["Image"] = [[rbxassetid://10709810463]];
G2L["22e"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["22e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22e"]["BackgroundTransparency"] = 1;
G2L["22e"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.bottom.respawn
G2L["22f"] = Instance.new("TextButton", G2L["22b"]);
G2L["22f"]["BorderSizePixel"] = 0;
G2L["22f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["22f"]["TextSize"] = 14;
G2L["22f"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["22f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22f"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["22f"]["BackgroundTransparency"] = 1;
G2L["22f"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["22f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22f"]["Text"] = [[       Respawn]];
G2L["22f"]["Name"] = [[respawn]];


-- StarterGui.zerohub.interface.main.sidebar.main.bottom.respawn.ImageLabel
G2L["230"] = Instance.new("ImageLabel", G2L["22f"]);
G2L["230"]["BorderSizePixel"] = 0;
G2L["230"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["230"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["230"]["Image"] = [[rbxassetid://10734933966]];
G2L["230"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["230"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["230"]["BackgroundTransparency"] = 1;
G2L["230"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder
G2L["231"] = Instance.new("Frame", G2L["226"]);
G2L["231"]["BorderSizePixel"] = 0;
G2L["231"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["231"]["Size"] = UDim2.new(0, 168, 0, 203);
G2L["231"]["Position"] = UDim2.new(0.05376, 0, 0.135, 0);
G2L["231"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["231"]["Name"] = [[tabsholder]];
G2L["231"]["BackgroundTransparency"] = 1;


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.UIListLayout
G2L["232"] = Instance.new("UIListLayout", G2L["231"]);
G2L["232"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.home
G2L["233"] = Instance.new("TextButton", G2L["231"]);
G2L["233"]["BorderSizePixel"] = 0;
G2L["233"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["233"]["TextSize"] = 14;
G2L["233"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["233"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["233"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["233"]["BackgroundTransparency"] = 1;
G2L["233"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["233"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["233"]["Text"] = [[       Home]];
G2L["233"]["Name"] = [[home]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.home.ImageLabel
G2L["234"] = Instance.new("ImageLabel", G2L["233"]);
G2L["234"]["BorderSizePixel"] = 0;
G2L["234"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["234"]["Image"] = [[rbxassetid://10723407389]];
G2L["234"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["234"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["234"]["BackgroundTransparency"] = 1;
G2L["234"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.scripthub
G2L["235"] = Instance.new("TextButton", G2L["231"]);
G2L["235"]["BorderSizePixel"] = 0;
G2L["235"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["235"]["TextSize"] = 14;
G2L["235"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["235"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["235"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["235"]["BackgroundTransparency"] = 1;
G2L["235"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["235"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["235"]["Text"] = [[       Script hub]];
G2L["235"]["Name"] = [[scripthub]];
G2L["235"]["Position"] = UDim2.new(0, 0, -0.62745, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.scripthub.ImageLabel
G2L["236"] = Instance.new("ImageLabel", G2L["235"]);
G2L["236"]["BorderSizePixel"] = 0;
G2L["236"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["236"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["236"]["Image"] = [[rbxassetid://10709806740]];
G2L["236"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["236"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["236"]["BackgroundTransparency"] = 1;
G2L["236"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.ai
G2L["237"] = Instance.new("TextButton", G2L["231"]);
G2L["237"]["BorderSizePixel"] = 0;
G2L["237"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["237"]["TextSize"] = 14;
G2L["237"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["237"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["237"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["237"]["BackgroundTransparency"] = 1;
G2L["237"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["237"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["237"]["Text"] = [[       AI]];
G2L["237"]["Name"] = [[ai]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.ai.ImageLabel
G2L["238"] = Instance.new("ImageLabel", G2L["237"]);
G2L["238"]["BorderSizePixel"] = 0;
G2L["238"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["238"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["238"]["Image"] = [[rbxassetid://12974219084]];
G2L["238"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["238"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["238"]["BackgroundTransparency"] = 1;
G2L["238"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.teleport
G2L["239"] = Instance.new("TextButton", G2L["231"]);
G2L["239"]["BorderSizePixel"] = 0;
G2L["239"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["239"]["TextSize"] = 14;
G2L["239"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["239"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["239"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["239"]["BackgroundTransparency"] = 1;
G2L["239"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["239"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["239"]["Text"] = [[       Teleport]];
G2L["239"]["Name"] = [[teleport]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.teleport.ImageLabel
G2L["23a"] = Instance.new("ImageLabel", G2L["239"]);
G2L["23a"]["BorderSizePixel"] = 0;
G2L["23a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23a"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23a"]["Image"] = [[rbxassetid://10709768787]];
G2L["23a"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["23a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23a"]["BackgroundTransparency"] = 1;
G2L["23a"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.music
G2L["23b"] = Instance.new("TextButton", G2L["231"]);
G2L["23b"]["BorderSizePixel"] = 0;
G2L["23b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["23b"]["TextSize"] = 14;
G2L["23b"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23b"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["23b"]["BackgroundTransparency"] = 1;
G2L["23b"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["23b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23b"]["Text"] = [[       Music]];
G2L["23b"]["Name"] = [[music]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.music.ImageLabel
G2L["23c"] = Instance.new("ImageLabel", G2L["23b"]);
G2L["23c"]["BorderSizePixel"] = 0;
G2L["23c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23c"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23c"]["Image"] = [[rbxassetid://10734905958]];
G2L["23c"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["23c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23c"]["BackgroundTransparency"] = 1;
G2L["23c"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.console
G2L["23d"] = Instance.new("TextButton", G2L["231"]);
G2L["23d"]["BorderSizePixel"] = 0;
G2L["23d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["23d"]["TextSize"] = 14;
G2L["23d"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23d"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["23d"]["BackgroundTransparency"] = 1;
G2L["23d"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["23d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23d"]["Text"] = [[       Console]];
G2L["23d"]["Name"] = [[console]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.console.ImageLabel
G2L["23e"] = Instance.new("ImageLabel", G2L["23d"]);
G2L["23e"]["BorderSizePixel"] = 0;
G2L["23e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23e"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23e"]["Image"] = [[rbxassetid://10734982144]];
G2L["23e"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["23e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23e"]["BackgroundTransparency"] = 1;
G2L["23e"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.quickrun
G2L["23f"] = Instance.new("TextButton", G2L["231"]);
G2L["23f"]["BorderSizePixel"] = 0;
G2L["23f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["23f"]["TextSize"] = 14;
G2L["23f"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["23f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23f"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["23f"]["BackgroundTransparency"] = 1;
G2L["23f"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["23f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23f"]["Text"] = [[       Quick run]];
G2L["23f"]["Name"] = [[quickrun]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.quickrun.ImageLabel
G2L["240"] = Instance.new("ImageLabel", G2L["23f"]);
G2L["240"]["BorderSizePixel"] = 0;
G2L["240"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["240"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["240"]["Image"] = [[rbxassetid://10723345749]];
G2L["240"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["240"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["240"]["BackgroundTransparency"] = 1;
G2L["240"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.universal
G2L["241"] = Instance.new("TextButton", G2L["231"]);
G2L["241"]["BorderSizePixel"] = 0;
G2L["241"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["241"]["TextSize"] = 14;
G2L["241"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["241"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["241"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["241"]["BackgroundTransparency"] = 1;
G2L["241"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["241"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["241"]["Text"] = [[       Universal]];
G2L["241"]["Name"] = [[universal]];


-- StarterGui.zerohub.interface.main.sidebar.main.tabsholder.universal.ImageLabel
G2L["242"] = Instance.new("ImageLabel", G2L["241"]);
G2L["242"]["BorderSizePixel"] = 0;
G2L["242"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["242"]["ImageColor3"] = Color3.fromRGB(101, 101, 101);
G2L["242"]["Image"] = [[rbxassetid://10723404337]];
G2L["242"]["Size"] = UDim2.new(0, 15, 0, 15);
G2L["242"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["242"]["BackgroundTransparency"] = 1;
G2L["242"]["Position"] = UDim2.new(0, 0, 0.24, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.settings
G2L["243"] = Instance.new("ImageButton", G2L["226"]);
G2L["243"]["BorderSizePixel"] = 0;
G2L["243"]["BackgroundTransparency"] = 1;
G2L["243"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["243"]["Image"] = [[rbxassetid://10734950309]];
G2L["243"]["Size"] = UDim2.new(0, 17, 0, 17);
G2L["243"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["243"]["Name"] = [[settings]];
G2L["243"]["Position"] = UDim2.new(0.86559, 0, 0.03236, 0);


-- StarterGui.zerohub.interface.main.sidebar.main.separator
G2L["244"] = Instance.new("Frame", G2L["226"]);
G2L["244"]["BorderSizePixel"] = 0;
G2L["244"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60);
G2L["244"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["244"]["Size"] = UDim2.new(0, 170, 0, 1);
G2L["244"]["Position"] = UDim2.new(0.5, 0, 0.115, 0);
G2L["244"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["244"]["Name"] = [[separator]];
G2L["244"]["BackgroundTransparency"] = 0.5;
-- Attributes
G2L["244"]:SetAttribute([[OriginalColor]], Color3.fromRGB(61, 61, 61));


-- StarterGui.zerohub.interface.main.sidebar.clock
G2L["245"] = Instance.new("TextLabel", G2L["224"]);
G2L["245"]["BorderSizePixel"] = 0;
G2L["245"]["TextSize"] = 25;
G2L["245"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["245"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
G2L["245"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["245"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["245"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["245"]["BackgroundTransparency"] = 1;
G2L["245"]["Size"] = UDim2.new(0, 200, 0, 50);
G2L["245"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["245"]["Text"] = [[12:35]];
G2L["245"]["Name"] = [[clock]];
G2L["245"]["Position"] = UDim2.new(0.54167, 0, 0.74757, 0);


-- StarterGui.zerohub.interface.main.sidebar.clock.LocalScript
G2L["246"] = Instance.new("LocalScript", G2L["245"]);



-- StarterGui.zerohub.interface.main.sidebar.date
G2L["247"] = Instance.new("TextLabel", G2L["224"]);
G2L["247"]["BorderSizePixel"] = 0;
G2L["247"]["TextSize"] = 16;
G2L["247"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["247"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
G2L["247"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["247"]["FontFace"] = Font.new([[rbxassetid://16658237174]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["247"]["TextColor3"] = Color3.fromRGB(101, 101, 101);
G2L["247"]["BackgroundTransparency"] = 1;
G2L["247"]["Size"] = UDim2.new(0, 200, 0, 50);
G2L["247"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["247"]["Text"] = [[15 october 2026]];
G2L["247"]["Name"] = [[date]];
G2L["247"]["Position"] = UDim2.new(0.54167, 0, 0.78317, 0);


-- StarterGui.zerohub.interface.main.sidebar.date.LocalScript
G2L["248"] = Instance.new("LocalScript", G2L["247"]);



-- StarterGui.zerohub.interface.main.sidebar.close
G2L["249"] = Instance.new("TextButton", G2L["224"]);
G2L["249"]["BorderSizePixel"] = 0;
G2L["249"]["TextSize"] = 14;
G2L["249"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["249"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["249"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["249"]["BackgroundTransparency"] = 1;
G2L["249"]["Size"] = UDim2.new(0, 293, 0, 308);
G2L["249"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["249"]["Text"] = [[]];
G2L["249"]["Name"] = [[close]];
G2L["249"]["Position"] = UDim2.new(0.38958, 0, 0.00324, 0);


-- StarterGui.zerohub.interface.open
G2L["24a"] = Instance.new("ImageButton", G2L["a"]);
G2L["24a"]["BorderSizePixel"] = 0;
G2L["24a"]["Visible"] = false;
G2L["24a"]["BackgroundTransparency"] = 1;
G2L["24a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["24a"]["AnchorPoint"] = Vector2.new(0, 1);
G2L["24a"]["Image"] = [[rbxassetid://10723345990]];
G2L["24a"]["Size"] = UDim2.new(0, 50, 0, 50);
G2L["24a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["24a"]["Name"] = [[open]];
G2L["24a"]["Position"] = UDim2.new(0, 0, 1, 0);


-- StarterGui.zerohub.interface.open.drag
G2L["24b"] = Instance.new("LocalScript", G2L["24a"]);
G2L["24b"]["Name"] = [[drag]];


-- StarterGui.zerohub.interface.open.LocalScript
G2L["24c"] = Instance.new("LocalScript", G2L["24a"]);



-- StarterGui.zerohub.storage
G2L["24d"] = Instance.new("Folder", G2L["1"]);
G2L["24d"]["Name"] = [[storage]];


-- StarterGui.zerohub.storage.darktheme
G2L["24e"] = Instance.new("BoolValue", G2L["24d"]);
G2L["24e"]["Name"] = [[darktheme]];
G2L["24e"]["Value"] = true;


-- StarterGui.zerohub.storage.geminiapikey
G2L["24f"] = Instance.new("StringValue", G2L["24d"]);
G2L["24f"]["Name"] = [[geminiapikey]];


-- StarterGui.zerohub.init.overlay
local function C_3()
local script = G2L["3"];
	script.Parent.Parent.DisplayOrder = 10000000
end;
task.spawn(C_3);
-- StarterGui.zerohub.init.scriptbloxanalytics
local function C_4()
local script = G2L["4"];
	pcall(function() loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))("proj_879959c742fe", "1.0.0", false) end)
end;
task.spawn(C_4);
-- StarterGui.zerohub.init.notifications
local function C_5()
local script = G2L["5"];
	-- Global fallback queue
	local function enqueue(typename, title, description)
		if not _G.__zerohub_notification_queue then
			_G.__zerohub_notification_queue = {}
		end
		table.insert(_G.__zerohub_notification_queue, {
			typename = typename,
			title = title,
			description = description
		})
	end
	
	local function safeexpose(name, typename)
		local handler = function(title, description)
			local realfunc = _G[name .. "_real"] or (type(getgenv) == "function" and getgenv()[name .. "_real"])
			if realfunc then
				realfunc(title, description)
			else
				enqueue(typename, title, description)
			end
		end
	
		_G[name] = handler
		if type(getgenv) == "function" then
			pcall(function()
				getgenv()[name] = handler
			end)
		end
		if type(shared) == "table" then
			pcall(function()
				shared[name] = handler
			end)
		end
	end
	
	safeexpose("zerohubnotificationsystem_success", "success")
	safeexpose("zerohubnotificationsystem_warning", "warning")
	safeexpose("zerohubnotificationsystem_info", "info")
	
	-- Welcome notification dispatch
	task.spawn(function()
		local deadline = tick() + 6
		while tick() < deadline do
			local notifyfunc = _G.zerohubnotificationsystem_success
			if notifyfunc then
				notifyfunc("Loaded", "Join our Discord")
				break
			end
			task.wait(0.1)
		end
	end)
	
end;
task.spawn(C_5);
-- StarterGui.zerohub.init.clicksound
local function C_6()
local script = G2L["6"];
	local gui = script:FindFirstAncestorOfClass("ScreenGui")
	if not gui then return end
	
	local SOUND_ID = "rbxassetid://135366639238389"
	
	local clickSound = Instance.new("Sound")
	clickSound.Name = "UIClickSound"
	clickSound.SoundId = SOUND_ID
	clickSound.Volume = 1
	clickSound.Parent = gui
	
	local connected = {}
	
	local function hookup(button)
		if not button:IsA("GuiButton") then return end
		if connected[button] then return end
		connected[button] = true
		button.Activated:Connect(function()
			clickSound:Play()
		end)
	end
	
	for _, descendant in gui:GetDescendants() do
		hookup(descendant)
	end
	
	gui.DescendantAdded:Connect(hookup)
	
	gui.DescendantRemoving:Connect(function(instance)
		connected[instance] = nil
	end)
	
end;
task.spawn(C_6);
-- StarterGui.zerohub.init.sidebarcontroller
local function C_7()
local script = G2L["7"];
	-- Services
	local tweenservice = game:GetService("TweenService")
	local playerservice = game:GetService("Players")
	
	-- UI references
	local screengui = script.Parent.Parent
	local interface = screengui:WaitForChild("interface")
	local main = interface:WaitForChild("main")
	local titlebar = main:WaitForChild("titlebar")
	local menubutton = titlebar:WaitForChild("menu")
	local tabsfolder = main:WaitForChild("tabs")
	local sidebar = main:WaitForChild("sidebar")
	local sidebarmain = sidebar:WaitForChild("main")
	local sidebartabsholder = sidebarmain:WaitForChild("tabsholder")
	local sidebarbottom = sidebarmain:WaitForChild("bottom")
	local sidebartitleclose = sidebarmain:WaitForChild("close")
	local sidebarbackdropclose = sidebar:WaitForChild("close")
	local clocklabel = sidebar:WaitForChild("clock")
	local datelabel = sidebar:WaitForChild("date")
	local settingsbutton = sidebarmain:WaitForChild("settings")
	
	-- Constants & theme
	local storage = screengui:WaitForChild("storage")
	local darktheme = storage:WaitForChild("darktheme")
	
	local activecolor = Color3.fromRGB(255, 255, 255)
	local inactivecolor = Color3.fromRGB(100, 100, 100)
	local drawerwidth = 186
	local mainheight = 309
	
	local taborder = {
		"home",
		"scripthub",
		"ai",
		"teleport",
		"musicplayer",
		"console",
		"quickrun",
		"universal",
		"settings"
	}
	
	local tabbuttons = {
		home = sidebartabsholder:WaitForChild("home"),
		scripthub = sidebartabsholder:WaitForChild("scripthub"),
		ai = sidebartabsholder:WaitForChild("ai"),
		teleport = sidebartabsholder:WaitForChild("teleport"),
		musicplayer = sidebartabsholder:WaitForChild("music"),
		console = sidebartabsholder:WaitForChild("console"),
		quickrun = sidebartabsholder:WaitForChild("quickrun"),
		universal = sidebartabsholder:WaitForChild("universal"),
		settings = settingsbutton
	}
	
	-- Baseline tab positions
	local basepositions = {}
	for _, tabname in ipairs(taborder) do
		local tabframe = tabsfolder:FindFirstChild(tabname)
		if tabframe then
			basepositions[tabname] = tabframe.Position
		end
	end
	
	-- State
	local currenttab = "home"
	local currenttabindex = 1
	local istransitioning = false
	local issidebaropen = false
	local issidebaranimating = false
	
	-- Color tweens
	local function applybuttoncolor(button, targetcolor)
		if button:IsA("TextButton") then
			tweenservice:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextColor3 = targetcolor
			}):Play()
			local icon = button:FindFirstChildOfClass("ImageLabel")
			if icon then
				tweenservice:Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageColor3 = targetcolor
				}):Play()
			end
		elseif button:IsA("ImageButton") then
			tweenservice:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageColor3 = targetcolor
			}):Play()
		end
	end
	
	local function updatetabhighlights(activetabname)
		for tabname, button in pairs(tabbuttons) do
			local isactive = (tabname == activetabname)
			local targetcolor = isactive and activecolor or inactivecolor
			applybuttoncolor(button, targetcolor)
		end
	end
	
	-- Button hover bindings
	for tabname, button in pairs(tabbuttons) do
		button.MouseEnter:Connect(function()
			if tabname ~= currenttab then
				applybuttoncolor(button, activecolor)
			end
		end)
		button.MouseLeave:Connect(function()
			if tabname ~= currenttab then
				applybuttoncolor(button, inactivecolor)
			end
		end)
	end
	
	-- Tab carousel scrolling
	local function switchtab(targettabname)
		local targetindex = table.find(taborder, targettabname)
		if not targetindex or targetindex == currenttabindex or istransitioning then
			return
		end
	
		istransitioning = true
		local startindex = currenttabindex
		currenttab = targettabname
		currenttabindex = targetindex
		updatetabhighlights(targettabname)
	
		local minindex = math.min(startindex, targetindex)
		local maxindex = math.max(startindex, targetindex)
		local height = main.AbsoluteSize.Y > 0 and main.AbsoluteSize.Y or mainheight
		local duration = math.clamp(0.35 + (math.abs(targetindex - startindex) - 1) * 0.05, 0.35, 0.55)
		local tweeninfo = TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	
		for index = minindex, maxindex do
			local tabname = taborder[index]
			local tabframe = tabsfolder:FindFirstChild(tabname)
			local basepos = basepositions[tabname]
			if tabframe and basepos then
				local startoffset = (index - startindex) * height
				local targetoffset = (index - targetindex) * height
				tabframe.Position = UDim2.new(basepos.X.Scale, basepos.X.Offset, basepos.Y.Scale, basepos.Y.Offset + startoffset)
				tabframe.Visible = true
				tweenservice:Create(tabframe, tweeninfo, {
					Position = UDim2.new(basepos.X.Scale, basepos.X.Offset, basepos.Y.Scale, basepos.Y.Offset + targetoffset)
				}):Play()
			end
		end
	
		task.delay(duration, function()
			for index = minindex, maxindex do
				local tabname = taborder[index]
				local tabframe = tabsfolder:FindFirstChild(tabname)
				local basepos = basepositions[tabname]
				if tabframe and basepos then
					if index ~= targetindex then
						tabframe.Visible = false
					end
					tabframe.Position = basepos
				end
			end
			istransitioning = false
		end)
	end
	
	-- Sidebar drawer animations
	local function opensidebar()
		if issidebaropen or issidebaranimating then return end
		issidebaranimating = true
		issidebaropen = true
	
		local width = sidebarmain.AbsoluteSize.X > 0 and sidebarmain.AbsoluteSize.X or drawerwidth
		sidebar.Visible = true
		sidebar.BackgroundTransparency = 1
		sidebarmain.Position = UDim2.new(0, -width, 0, 0)
		clocklabel.TextTransparency = 1
		datelabel.TextTransparency = 1
	
		local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
		tweenservice:Create(sidebarmain, tweeninfo, { Position = UDim2.new(0, 0, 0, 0) }):Play()
		tweenservice:Create(sidebar, tweeninfo, { BackgroundTransparency = 0.2 }):Play()
		tweenservice:Create(clocklabel, tweeninfo, { TextTransparency = 0 }):Play()
		tweenservice:Create(datelabel, tweeninfo, { TextTransparency = 0 }):Play()
	
		task.delay(0.3, function()
			issidebaranimating = false
		end)
	end
	
	local function closesidebar()
		if not issidebaropen or issidebaranimating then return end
		issidebaranimating = true
		issidebaropen = false
	
		local width = sidebarmain.AbsoluteSize.X > 0 and sidebarmain.AbsoluteSize.X or drawerwidth
		local tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
		tweenservice:Create(sidebarmain, tweeninfo, { Position = UDim2.new(0, -width, 0, 0) }):Play()
		tweenservice:Create(sidebar, tweeninfo, { BackgroundTransparency = 1 }):Play()
		tweenservice:Create(clocklabel, tweeninfo, { TextTransparency = 1 }):Play()
		tweenservice:Create(datelabel, tweeninfo, { TextTransparency = 1 }):Play()
	
		task.delay(0.25, function()
			if not issidebaropen then
				sidebar.Visible = false
			end
			issidebaranimating = false
		end)
	end
	
	-- Toggle and close bindings
	menubutton.MouseButton1Click:Connect(function()
		if issidebaropen then
			closesidebar()
		else
			opensidebar()
		end
	end)
	
	sidebartitleclose.MouseButton1Click:Connect(closesidebar)
	sidebarbackdropclose.MouseButton1Click:Connect(closesidebar)
	
	for tabname, button in pairs(tabbuttons) do
		button.MouseButton1Click:Connect(function()
			closesidebar()
			switchtab(tabname)
		end)
	end
	
	-- Quick action buttons
	local infiniteyieldbutton = sidebarbottom:FindFirstChild("infiniteyield")
	if infiniteyieldbutton then
		infiniteyieldbutton.MouseButton1Click:Connect(function()
			closesidebar()
			_G.zerohubnotificationsystem_info("Loading", "Running Infinite Yield")
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
			_G.zerohubnotificationsystem_success("Success", "Loaded Infinite Yield")
		end)
	end
	
	local respawnbutton = sidebarbottom:FindFirstChild("respawn")
	if respawnbutton then
		respawnbutton.MouseButton1Click:Connect(function()
			closesidebar()
			local character = playerservice.LocalPlayer.Character
			if character then
				character:BreakJoints()
				_G.zerohubnotificationsystem_success("Success", "Respawned character")
			end
		end)
	end
	
	for _, button in ipairs({ infiniteyieldbutton, respawnbutton }) do
		if button then
			button.MouseEnter:Connect(function()
				applybuttoncolor(button, activecolor)
			end)
			button.MouseLeave:Connect(function()
				applybuttoncolor(button, inactivecolor)
			end)
		end
	end
	
	-- Initialization
	sidebar.Visible = false
	sidebar.BackgroundTransparency = 1
	sidebarmain.Position = UDim2.new(0, -drawerwidth, 0, 0)
	clocklabel.TextTransparency = 1
	datelabel.TextTransparency = 1
	
	local function refreshthemecolors()
		local isdark = not darktheme or darktheme.Value
		if isdark then
			activecolor = Color3.fromRGB(255, 255, 255)
			inactivecolor = Color3.fromRGB(100, 100, 100)
		else
			activecolor = Color3.fromRGB(17, 24, 39)
			inactivecolor = Color3.fromRGB(107, 114, 128)
		end
		updatetabhighlights(currenttab)
	end
	
	if darktheme then
		darktheme.Changed:Connect(refreshthemecolors)
	end
	refreshthemecolors()
	
	for _, tabname in ipairs(taborder) do
		local tabframe = tabsfolder:FindFirstChild(tabname)
		if tabframe then
			tabframe.Visible = (tabname == "home")
			if basepositions[tabname] then
				tabframe.Position = basepositions[tabname]
			end
		end
	end
	
end;
task.spawn(C_7);
-- StarterGui.zerohub.init.apikeymanager
local function C_8()
local script = G2L["8"];
	-- Services
	local screengui = script.Parent.Parent
	local storage = screengui:WaitForChild("storage")
	local geminiapikey = storage:WaitForChild("geminiapikey")
	
	-- Exploit file system bridges
	local isfilefn = isfile or (syn and syn.isfile)
	local readfilefn = readfile or (syn and syn.readfile)
	local writefilefn = writefile or (syn and syn.writefile)
	local filename = "zerohub_gemini_api_key.txt"
	
	-- Load key on initialization
	if isfilefn and readfilefn and isfilefn(filename) then
		local success, content = pcall(readfilefn, filename)
		if success and type(content) == "string" then
			local trimmed = content:match("^%s*(.-)%s*$")
			if trimmed and trimmed ~= "" then
				geminiapikey.Value = trimmed
			end
		end
	end
	
	-- Save key on change without polling
	geminiapikey.Changed:Connect(function(newkey)
		if writefilefn and type(newkey) == "string" then
			local trimmed = newkey:match("^%s*(.-)%s*$") or ""
			pcall(writefilefn, filename, trimmed)
		end
	end)
	
end;
task.spawn(C_8);
-- StarterGui.zerohub.init.themesystem
local function C_9()
local script = G2L["9"];
	-- Services
	local tweenservice = game:GetService("TweenService")
	
	-- References
	local screengui = script.Parent.Parent
	local storage = screengui:WaitForChild("storage")
	local darktheme = storage:WaitForChild("darktheme")
	local customize = screengui:WaitForChild("interface"):WaitForChild("main"):WaitForChild("tabs"):WaitForChild("settings"):WaitForChild("teleporttabs"):WaitForChild("customize")
	local themeButton = customize:WaitForChild("lighttheme"):WaitForChild("TextButton")
	
	-- Exploit filesystem persistence
	local isfilefn = isfile or (syn and syn.isfile)
	local readfilefn = readfile or (syn and syn.readfile)
	local writefilefn = writefile or (syn and syn.writefile)
	local themefilename = "zerohub_theme.txt"
	
	-- Design tokens
	local palettes = {
		dark = {
			windowBg = Color3.fromRGB(20, 20, 20),
			cardBg = Color3.fromRGB(30, 30, 30),
			controlBg = Color3.fromRGB(40, 40, 40),
			separator = Color3.fromRGB(60, 60, 60),
			primaryText = Color3.fromRGB(255, 255, 255),
			secondaryText = Color3.fromRGB(100, 100, 100),
			primaryIcon = Color3.fromRGB(255, 255, 255),
			secondaryIcon = Color3.fromRGB(100, 100, 100),
			sliderFill = Color3.fromRGB(255, 255, 255),
			inputBg = Color3.fromRGB(40, 40, 40),
			lineNumbers = Color3.fromRGB(100, 100, 100),
			trackBg = Color3.fromRGB(100, 100, 100)
		},
		light = {
			windowBg = Color3.fromRGB(244, 245, 248),
			cardBg = Color3.fromRGB(255, 255, 255),
			controlBg = Color3.fromRGB(228, 231, 235),
			separator = Color3.fromRGB(218, 222, 229),
			primaryText = Color3.fromRGB(17, 24, 39),
			secondaryText = Color3.fromRGB(107, 114, 128),
			primaryIcon = Color3.fromRGB(17, 24, 39),
			secondaryIcon = Color3.fromRGB(107, 114, 128),
			sliderFill = Color3.fromRGB(17, 24, 39),
			inputBg = Color3.fromRGB(243, 244, 246),
			lineNumbers = Color3.fromRGB(156, 163, 175),
			trackBg = Color3.fromRGB(228, 231, 235)
		}
	}
	
	-- Classification Registry
	local trackedObjects = {}
	
	local function toHex(color)
		if not color then return "" end
		return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end
	
	local function classifyElement(inst)
		if not inst:IsA("GuiObject") then return nil end
		local name = inst.Name
	
		-- Ignore assets, syntax highlights and badges
		if name == "pfp" or name == "scriptimage" or name == "userprofileicon-avatar" or name == "clock" or name == "date" then
			return nil
		end
		if name == "haskeysystem" or name == "isverified" then
			return nil
		end
		if inst.Parent and inst.Parent.Name == "TextBox" and inst.Parent.Parent and inst.Parent.Parent.Name == "editor" then
			return nil
		end
	
		-- Ignore dynamic quickrun tabs (managed by tabmanager)
		local qtabs = screengui:FindFirstChild("interface")
			and screengui.interface:FindFirstChild("main")
			and screengui.interface.main:FindFirstChild("tabs")
			and screengui.interface.main.tabs:FindFirstChild("quickrun")
			and screengui.interface.main.tabs.quickrun:FindFirstChild("tabs")
		if qtabs and inst:IsDescendantOf(qtabs) then
			return nil
		end
	
		-- Ignore dynamic playerlist cards (managed by teleportation script)
		local plist = screengui:FindFirstChild("interface")
			and screengui.interface:FindFirstChild("main")
			and screengui.interface.main:FindFirstChild("tabs")
			and screengui.interface.main.tabs:FindFirstChild("universal")
			and screengui.interface.main.tabs.universal:FindFirstChild("ScrollingFrame")
			and screengui.interface.main.tabs.universal.ScrollingFrame:FindFirstChild("teleportation")
			and screengui.interface.main.tabs.universal.ScrollingFrame.teleportation:FindFirstChild("playerlist")
			and screengui.interface.main.tabs.universal.ScrollingFrame.teleportation.playerlist:FindFirstChild("ScrollingFrame")
		if plist and inst:IsDescendantOf(plist) then
			return nil
		end
	
		local info = {}
	
		if inst.BackgroundTransparency < 1 then
			local hex = toHex(inst.BackgroundColor3)
			if hex == "#141414" then
				info.bgRole = "windowBg"
			elseif hex == "#1E1E1E" then
				info.bgRole = "cardBg"
			elseif hex == "#282828" then
				info.bgRole = "controlBg"
			elseif hex == "#3C3C3C" then
				info.bgRole = "separator"
			elseif (inst.Name == "fill" and inst.Parent and inst.Parent.Name == "bar") or ((hex == "#FFFFFF" or hex == "#111827") and (inst.Name == "filler" or inst.Name == "loadingbarprogress" or (inst.Parent and inst.Parent.Name == "progressbar"))) then
				info.bgRole = "sliderFill"
			elseif inst.Name == "bar" and (inst.Parent and (inst.Parent.Name == "examplesuccess" or inst.Parent.Name == "examplewarning" or string.find(inst.Parent.Name, "notification"))) then
				info.bgRole = "trackBg"
			end
		end
	
		if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
			local tc = toHex(inst.TextColor3)
			if name == "Lines" then
				info.textRole = "lineNumbers"
			elseif tc == "#FFFFFF" then
				info.textRole = "primaryText"
			elseif tc == "#646464" then
				info.textRole = "secondaryText"
			end
		end
	
		if (inst:IsA("ImageLabel") or inst:IsA("ImageButton")) and inst.Image ~= "" then
			local ic = toHex(inst.ImageColor3)
			if ic == "#FFFFFF" then
				info.iconRole = "primaryIcon"
			elseif ic == "#646464" then
				info.iconRole = "secondaryIcon"
			end
		end
	
		if info.bgRole or info.textRole or info.iconRole then
			return info
		end
		return nil
	end
	
	local function registerElement(inst)
		if trackedObjects[inst] then return end
		local classification = classifyElement(inst)
		if classification then
			trackedObjects[inst] = classification
		end
	end
	
	for _, desc in ipairs(screengui:GetDescendants()) do
		registerElement(desc)
	end
	
	local function applyThemeToSingle(inst, classification, palette, tweenInfo)
		local goals = {}
	
		if classification.bgRole and palette[classification.bgRole] then
			goals.BackgroundColor3 = palette[classification.bgRole]
			inst:SetAttribute("OriginalColor", palette[classification.bgRole])
		end
	
		if classification.textRole and palette[classification.textRole] then
			goals.TextColor3 = palette[classification.textRole]
		end
	
		if classification.iconRole and palette[classification.iconRole] then
			goals.ImageColor3 = palette[classification.iconRole]
		end
	
		if next(goals) then
			if tweenInfo then
				tweenservice:Create(inst, tweenInfo, goals):Play()
			else
				for prop, val in pairs(goals) do
					inst[prop] = val
				end
			end
		end
	end
	
	local function applyTheme(isDark, animate)
		local palette = isDark and palettes.dark or palettes.light
		local tweenInfo = animate and TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil
	
		for inst, classification in pairs(trackedObjects) do
			if inst.Parent then
				applyThemeToSingle(inst, classification, palette, tweenInfo)
			else
				trackedObjects[inst] = nil
			end
		end
	end
	
	screengui.DescendantAdded:Connect(function(desc)
		task.defer(function()
			registerElement(desc)
			local classification = trackedObjects[desc]
			if classification then
				local palette = darktheme.Value and palettes.dark or palettes.light
				applyThemeToSingle(desc, classification, palette, nil)
			end
		end)
	end)
	
	screengui.DescendantRemoving:Connect(function(desc)
		trackedObjects[desc] = nil
	end)
	
	-- File persistence
	if isfilefn and readfilefn and isfilefn(themefilename) then
		local success, saved = pcall(readfilefn, themefilename)
		if success and type(saved) == "string" then
			saved = saved:match("^%s*(.-)%s*$")
			if saved == "light" then
				darktheme.Value = false
			end
		end
	end
	
	darktheme.Changed:Connect(function(isDark)
		applyTheme(isDark, true)
		if writefilefn then
			pcall(writefilefn, themefilename, isDark and "dark" or "light")
		end
		if _G.zerohubnotificationsystem_info then
			_G.zerohubnotificationsystem_info("Theme Changed", isDark and "Dark theme enabled" or "Light theme enabled")
		end
	end)
	
	-- Initialize theme
	applyTheme(darktheme.Value, false)
	
end;
task.spawn(C_9);
-- StarterGui.zerohub.interface.loader.loadingbar.ineedajob
local function C_e()
local script = G2L["e"];
	local tweenService = game:GetService("TweenService")
	
	local loadingBar = script.Parent
	local progressBar = loadingBar:FindFirstChild("loadingbarprogress")
	local barWidth = loadingBar.Size.X.Offset
	
	local function playTween(obj, duration, style, direction, properties)
		local tween = tweenService:Create(obj, TweenInfo.new(duration, style, direction), properties)
		tween:Play()
		tween.Completed:Wait()
	end
	
	local function runLoadingCycle(duration)
		-- Fill bar completely
		playTween(progressBar, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
			Size = UDim2.new(0, barWidth, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		})
		-- Unfill from left to right
		playTween(progressBar, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(0, barWidth, 0, 0)
		})
		progressBar.Position = UDim2.new(0, 0, 0, 0)
	end
	
	-- Initialize progress bar state
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.Position = UDim2.new(0, 0, 0, 0)
	
	-- Loop alternating between 0.5s and 0.3s cycles
	while true do
		runLoadingCycle(0.5)
		runLoadingCycle(0.3)
	end
end;
task.spawn(C_e);
-- StarterGui.zerohub.interface.main.titlebar.close.LocalScript
local function C_19()
local script = G2L["19"];
	script.Parent.MouseButton1Click:Connect(function() 
		script.Parent.Parent.Parent.Parent.Parent:Destroy()	
	end)
end;
task.spawn(C_19);
-- StarterGui.zerohub.interface.main.titlebar.minimize.LocalScript
local function C_1b()
local script = G2L["1b"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.Visible = false
		script.Parent.Parent.Parent.Parent.open.Visible = true
	end)
end;
task.spawn(C_1b);
-- StarterGui.zerohub.interface.main.tabs.home.widget1.pfp.LocalScript
local function C_22()
local script = G2L["22"];
	local players = game:GetService("Players")
	local localPlayer = players.LocalPlayer
	
	-- Load and set local player's profile icon
	local success, content = pcall(function()
		return players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end)
	
	if success then
		script.Parent.Image = content
	else
		warn("[zerohub] Failed to load profile icon.")
	end
end;
task.spawn(C_22);
-- StarterGui.zerohub.interface.main.tabs.home.widget1.displayname.LocalScript
local function C_25()
local script = G2L["25"];
	script.Parent.Text = game.Players.LocalPlayer.DisplayName
end;
task.spawn(C_25);
-- StarterGui.zerohub.interface.main.tabs.home.widget1.userid.LocalScript
local function C_27()
local script = G2L["27"];
	script.Parent.Text = game.Players.LocalPlayer.UserId
end;
task.spawn(C_27);
-- StarterGui.zerohub.interface.main.tabs.home.widget1.movement.LocalScript
local function C_29()
local script = G2L["29"];
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local player = Players.LocalPlayer
	local movement = script.Parent
	local buttons = movement:FindFirstChild("buttons")
	local sliders = movement:FindFirstChild("sliders")
	
	-- Button references
	local flyBtn = buttons:FindFirstChild("fly")
	local noclipBtn = buttons:FindFirstChild("noclip")
	local infjumpBtn = buttons:FindFirstChild("infjump")
	
	-- Slider references
	local wsFrame = sliders:FindFirstChild("walkspeed")
	local jpFrame = sliders:FindFirstChild("jumppower")
	local fsFrame = sliders:FindFirstChild("flyspeed")
	
	local wsFiller = wsFrame:FindFirstChild("filler")
	local wsLabel = wsFrame:FindFirstChild("value")
	local jpFiller = jpFrame:FindFirstChild("filler")
	local jpLabel = jpFrame:FindFirstChild("value")
	local fsFiller = fsFrame:FindFirstChild("filler")
	local fsLabel = fsFrame:FindFirstChild("value")
	
	-- Slider value state: target = what user drags to, display = smoothly animated visual
	local wsTarget, wsDisplay = 16, 16
	local jpTarget, jpDisplay = 50, 50
	local fsTarget, fsDisplay = 1, 1
	
	-- Toggle states
	local flyOn = false
	local noclipOn = false
	local infjumpOn = false
	
	-- References & Theme
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local function isdark()
		if darktheme then return darktheme.Value end
		return true
	end
	
	-- Connections for toggles
	local noclipConn
	local infjumpConn
	
	-- Read current character walkspeed/jumppower to initialize sliders
	local function readCharacterValues()
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			wsTarget = hum.WalkSpeed
			wsDisplay = hum.WalkSpeed
			jpTarget = hum.JumpPower
			jpDisplay = hum.JumpPower
		end
	end
	
	readCharacterValues()
	player.CharacterAdded:Connect(function()
		readCharacterValues()
		task.wait(0.3)
		-- Re-apply slider values to new character
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = wsTarget
				hum.JumpPower = jpTarget
			end
		end
	end)
	
	-- ---- Slider system ----
	local function makeSlider(frame, maxValue, getTarget, setTarget, onTargetChange)
		local dragging = false
		local mainFrame = movement.Parent.Parent -- game.StarterGui.zerohub.main
	
		local function setDraggingState(state)
			mainFrame:SetAttribute("IsDraggingSlider", state)
		end
	
		local function updateFromMouse(input)
			local absPos = frame.AbsolutePosition.X
			local absSize = frame.AbsoluteSize.X
			if absSize <= 0 then return end
			local rel = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
			local newVal = math.floor(rel * maxValue + 0.5)
			if newVal ~= getTarget() then
				setTarget(newVal)
				if onTargetChange then onTargetChange(newVal) end
			end
		end
	
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setDraggingState(true)
				updateFromMouse(input)
			end
		end)
	
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				updateFromMouse(input)
			end
		end)
	
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				if dragging then
					dragging = false
					setDraggingState(false)
				end
			end
		end)
	end
	
	local function applyWalkspeed(val)
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = val end
		end
	end
	
	local function applyJumppower(val)
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.JumpPower = val end
		end
	end
	
	makeSlider(wsFrame, 500, function() return wsTarget end, function(v) wsTarget = v end, applyWalkspeed)
	makeSlider(jpFrame, 500, function() return jpTarget end, function(v) jpTarget = v end, applyJumppower)
	makeSlider(fsFrame, 10, function() return fsTarget end, function(v) fsTarget = v end, nil)
	
	local lastTime = os.clock()
	
	RunService.RenderStepped:Connect(function()
		local now = os.clock()
		local dt = now - lastTime
		lastTime = now
	
		-- Frame-rate independent smoothing factor (higher = snappier)
		local lerpFactor = 1 - math.exp(-dt * 22)
	
		-- Walkspeed slider visual
		local wsWidth = wsFrame.AbsoluteSize.X
		if wsWidth > 0 then
			wsDisplay = wsDisplay + (wsTarget - wsDisplay) * lerpFactor
			wsFiller.Size = UDim2.new(0, (wsDisplay / 500) * wsWidth, 1, 0)
			wsLabel.Text = tostring(math.round(wsDisplay))
		end
	
		-- Jumppower slider visual
		local jpWidth = jpFrame.AbsoluteSize.X
		if jpWidth > 0 then
			jpDisplay = jpDisplay + (jpTarget - jpDisplay) * lerpFactor
			jpFiller.Size = UDim2.new(0, (jpDisplay / 500) * jpWidth, 1, 0)
			jpLabel.Text = tostring(math.round(jpDisplay))
		end
	
		-- Flyspeed slider visual
		local fsWidth = fsFrame.AbsoluteSize.X
		if fsWidth > 0 then
			fsDisplay = fsDisplay + (fsTarget - fsDisplay) * lerpFactor
			fsFiller.Size = UDim2.new(0, (fsDisplay / 10) * fsWidth, 1, 0)
			fsLabel.Text = tostring(math.round(fsDisplay))
		end
	
		-- Fly movement
		if flyOn then
			local char = player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hrp and hum then
					hum.PlatformStand = true
					local camera = Workspace.CurrentCamera
					if camera then
						local speed = fsTarget * 20
						local move = Vector3.zero
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.yAxis end
						if move.Magnitude > 0 then
							move = move.Unit * speed
						end
						hrp.AssemblyLinearVelocity = move
					end
				end
			end
		end
	end)
	
	-- ---- Button toggles ----
	local function setBtnActive(btn, on)
		if not btn then return end
		local icon = btn:FindFirstChildOfClass("ImageLabel")
		local dark = isdark()
		if on then
			local activeBg = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			local activeText = dark and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = activeBg
			btn.TextColor3 = activeText
			if icon then icon.ImageColor3 = activeText end
		else
			local inactiveBg = dark and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(228, 231, 235)
			local inactiveText = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			btn.BackgroundColor3 = inactiveBg
			btn.TextColor3 = inactiveText
			if icon then icon.ImageColor3 = inactiveText end
		end
	end
	
	local function refreshTheme()
		setBtnActive(flyBtn, flyOn)
		setBtnActive(noclipBtn, noclipOn)
		setBtnActive(infjumpBtn, infjumpOn)
	end
	
	if darktheme then
		darktheme.Changed:Connect(refreshTheme)
	end
	
	local function toggleFly(on)
		flyOn = on
		setBtnActive(flyBtn, on)
		if not on then
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.PlatformStand = false end
			end
		end
	end
	
	local function toggleNoclip(on)
		noclipOn = on
		setBtnActive(noclipBtn, on)
		if on then
			noclipConn = RunService.Stepped:Connect(function()
				local char = player.Character
				if char then
					for _, part in char:GetDescendants() do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConn then
				noclipConn:Disconnect()
				noclipConn = nil
			end
			local char = player.Character
			if char then
				for _, part in char:GetDescendants() do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = true
					end
				end
			end
		end
	end
	
	local function toggleInfjump(on)
		infjumpOn = on
		setBtnActive(infjumpBtn, on)
		if on then
			infjumpConn = UserInputService.JumpRequest:Connect(function()
				local char = player.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then
						hum:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		else
			if infjumpConn then
				infjumpConn:Disconnect()
				infjumpConn = nil
			end
		end
	end
	
	flyBtn.MouseButton1Click:Connect(function() toggleFly(not flyOn) end)
	noclipBtn.MouseButton1Click:Connect(function() toggleNoclip(not noclipOn) end)
	infjumpBtn.MouseButton1Click:Connect(function() toggleInfjump(not infjumpOn) end)
	
	-- Initialize button colors
	setBtnActive(flyBtn, false)
	setBtnActive(noclipBtn, false)
	setBtnActive(infjumpBtn, false)
end;
task.spawn(C_29);
-- StarterGui.zerohub.interface.main.tabs.home.widget1.copydiscord.LocalScript
local function C_4d()
local script = G2L["4d"];
	script.Parent.MouseButton1Click:Connect(function()
		setclipboard("https://join.zerohub.cc/")
		_G.zerohubnotificationsystem_success("Copied invite", "Paste in your browser")
	end)
end;
task.spawn(C_4d);
-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
local function C_53()
local script = G2L["53"];
	local runService = game:GetService("RunService")
	local textLabel = script.Parent
	
	while true do
		textLabel.Text = math.round(1 / runService.RenderStepped:Wait())
		task.wait(1)
	end
end;
task.spawn(C_53);
-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
local function C_57()
local script = G2L["57"];
	local players = game:GetService("Players")
	local textLabel = script.Parent
	local localPlayer = players.LocalPlayer
	
	task.spawn(function()
		while true do
			textLabel.Text = math.round(localPlayer:GetNetworkPing() * 1000)
			task.wait(1)
		end
	end)
end;
task.spawn(C_57);
-- StarterGui.zerohub.interface.main.tabs.home.widget2.Frame.TextLabel.LocalScript
local function C_5b()
local script = G2L["5b"];
	local statsService = game:GetService("Stats")
	local textLabel = script.Parent
	
	task.spawn(function()
		while true do
			textLabel.Text = math.round(statsService:GetTotalMemoryUsageMb())
			task.wait(1)
		end
	end)
end;
task.spawn(C_5b);
-- StarterGui.zerohub.interface.main.tabs.scripthub.zshs
local function C_62()
local script = G2L["62"];
	-- Services & UI references
	local httpService = game:GetService("HttpService")
	local scriptHub = script.Parent
	local searchBox = scriptHub.searchbar.TextBox
	local resultsFrame = scriptHub.ScrollingFrame
	local cardTemplate = resultsFrame:FindFirstChild("example")
	cardTemplate.Visible = false
	
	-- State variables
	local currentQuery = ""
	local scriptBloxPage, rScriptsPage = 1, 1
	local hasMoreScriptBlox, hasMoreRScripts = true, true
	local isLoading = false
	local searchDebounce = nil
	
	-- Format numbers (1K, 1M)
	local function formatNumber(value)
		local number = tonumber(value) or 0
		if number >= 1000000 then
			return string.format("%.1fM", number / 1000000):gsub("%.0", "")
		elseif number >= 1000 then
			return string.format("%.1fK", number / 1000):gsub("%.0", "")
		end
		return tostring(number)
	end
	
	-- Check if a tag value is truthy
	local function isTruthy(value)
		return value == true or value == "true" or value == 1 or value == "1"
	end
	
	-- Load and cache thumbnail
	local function loadImage(imageUrl, imageLabel)
		if type(imageUrl) ~= "string" or imageUrl == "" then return end
		if imageUrl:sub(1, 1) == "/" then imageUrl = "https://scriptblox.com" .. imageUrl end
	
		local fileName = "sbx_" .. imageUrl:gsub("https?://", ""):gsub("[^%w]", "_"):sub(1, 100) .. ".png"
		local success, responseData = pcall(game.HttpGet, game, imageUrl)
		if not success or not responseData then return end
	
		if writefile then pcall(writefile, fileName, responseData) end
		if getcustomasset then
			local assetSuccess, assetUrl = pcall(getcustomasset, fileName)
			if assetSuccess and assetUrl then imageLabel.Image = assetUrl end
		end
		return fileName
	end
	
	-- Create script card UI
	local function createCard(title, views, scriptCode, imageUrl, hasKeySystem, isVerified)
		local card = cardTemplate:Clone()
		card.Name = "R_" .. httpService:GenerateGUID(false)
		card.Visible = true
	
		-- Check both inside 'tags' folder and directly on the card
		local tagsFolder = card:FindFirstChild("tags") or card
		local keyTag = tagsFolder:FindFirstChild("haskeysystem") or card:FindFirstChild("haskeysystem", true)
		local verifiedTag = tagsFolder:FindFirstChild("isverified") or card:FindFirstChild("isverified", true)
	
		if keyTag then keyTag.Visible = isTruthy(hasKeySystem) end
		if verifiedTag then verifiedTag.Visible = isTruthy(isVerified) end
	
		local titleLabel = card:FindFirstChild("scripttitle")
		if titleLabel then titleLabel.Text = title or "Untitled" end
	
		local viewsLabel = card:FindFirstChild("likescount")
		if viewsLabel then viewsLabel.Text = formatNumber(views) end
	
		local imageLabel = card:FindFirstChild("scriptimage")
		if imageLabel then
			imageLabel.Image = ""
			if imageUrl and imageUrl ~= "" then
				task.spawn(function()
					local fileName = loadImage(imageUrl, imageLabel)
					if fileName then card:SetAttribute("imgFile", fileName) end
				end)
			end
		end
	
		local executeButton = card:FindFirstChild("execute")
		if executeButton then
			executeButton.MouseButton1Click:Connect(function()
				if scriptCode and scriptCode ~= "" then
					local executable = loadstring(scriptCode)
					if executable then pcall(executable) end
				end
			end)
		end
	
		local copyButton = card:FindFirstChild("copy")
		if copyButton then
			copyButton.MouseButton1Click:Connect(function()
				if scriptCode and scriptCode ~= "" and setclipboard then
					setclipboard(scriptCode)
				end
			end)
		end
	
		card.AncestryChanged:Connect(function(_, parent)
			if not parent then
				local fileName = card:GetAttribute("imgFile")
				if fileName and delfile then pcall(delfile, fileName) end
			end
		end)
	
		card.Parent = resultsFrame
	end
	
	-- Reset results and pagination
	local function resetState(queryText)
		for _, child in ipairs(resultsFrame:GetChildren()) do
			if child ~= cardTemplate and child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		currentQuery = queryText
		scriptBloxPage, rScriptsPage = 1, 1
		hasMoreScriptBlox, hasMoreRScripts = true, true
	end
	
	-- Fetch scripts from APIs
	local function fetchScripts(queryText)
		if isLoading then return end
		isLoading = true
		local encodedQuery = httpService:UrlEncode(queryText)
	
		-- ScriptBlox API
		if hasMoreScriptBlox then
			task.spawn(function()
				local url = "https://scriptblox.com/api/script/search?q=" .. encodedQuery .. "&page=" .. scriptBloxPage
				local success, response = pcall(game.HttpGet, game, url)
				if not success then return end
	
				local parseSuccess, data = pcall(httpService.JSONDecode, httpService, response)
				local scriptList = parseSuccess and data and data.result and data.result.scripts
				if not scriptList or #scriptList == 0 then
					hasMoreScriptBlox = false
					return
				end
	
				for _, scriptData in ipairs(scriptList) do
					local hasKeySystem = scriptData.key or scriptData.keySystem or scriptData.hasKeySystem
					local isVerified = scriptData.isVerified or scriptData.verified or (scriptData.owner and scriptData.owner.verified)
					local imageUrl = scriptData.image or (scriptData.game and scriptData.game.imageUrl)
	
					createCard(
						scriptData.title,
						scriptData.views,
						scriptData.script,
						imageUrl,
						hasKeySystem,
						isVerified
					)
				end
				scriptBloxPage += 1
			end)
		end
	
		-- RScripts API
		if queryText ~= "" and hasMoreRScripts then
			task.spawn(function()
				local url = "https://api.rscripts.net/v1/scripts?q=" .. encodedQuery .. "&page=" .. rScriptsPage .. "&includeScript=true"
				local success, response = pcall(game.HttpGet, game, url)
				if not success then return end
	
				local parseSuccess, data = pcall(httpService.JSONDecode, httpService, response)
				local scriptList = parseSuccess and data and data.data
				if not scriptList or #scriptList == 0 then
					hasMoreRScripts = false
					return
				end
	
				for _, scriptData in ipairs(scriptList) do
					local scriptCode = scriptData.script or scriptData.rawScript or ""
					if scriptCode:match("^https?://") and not scriptCode:match("\n") then
						scriptCode = 'loadstring(game:HttpGet("' .. scriptCode .. '"))()'
					end
	
					local hasKeySystem = scriptData.keySystem or scriptData.key or scriptData.hasKeySystem
					local isVerified = scriptData.verified or scriptData.isVerified or (scriptData.user and scriptData.user.verified)
					local imageUrl = scriptData.image or (scriptData.game and scriptData.game.image)
	
					createCard(
						scriptData.title,
						scriptData.views,
						scriptCode,
						imageUrl,
						hasKeySystem,
						isVerified
					)
				end
				rScriptsPage += 1
			end)
		end
	
		task.delay(1, function() isLoading = false end)
	end
	
	-- Infinite scrolling
	resultsFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if isLoading or (not hasMoreScriptBlox and not hasMoreRScripts) then return end
		if resultsFrame.CanvasPosition.Y + resultsFrame.AbsoluteWindowSize.Y >= resultsFrame.AbsoluteCanvasSize.Y - 150 then
			fetchScripts(currentQuery)
		end
	end)
	
	-- Search input handlers
	local function triggerSearch(queryText, useDebounce)
		if searchDebounce then task.cancel(searchDebounce) end
		local cleanQuery = queryText:match("^%s*$") and "" or queryText
	
		if useDebounce and cleanQuery ~= "" then
			searchDebounce = task.delay(1.5, function()
				resetState(cleanQuery)
				fetchScripts(cleanQuery)
			end)
		else
			resetState(cleanQuery)
			fetchScripts(cleanQuery)
		end
	end
	
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		triggerSearch(searchBox.Text, true)
	end)
	
	searchBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then triggerSearch(searchBox.Text, false) end
	end)
	
	-- Initial load
	fetchScripts("")
end;
task.spawn(C_62);
-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.execute.anim
local function C_6d()
local script = G2L["6d"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_6d);
-- StarterGui.zerohub.interface.main.tabs.scripthub.ScrollingFrame.example.copy.anim
local function C_71()
local script = G2L["71"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_71);
-- StarterGui.zerohub.interface.main.tabs.ai.aicore
local function C_80()
local script = G2L["80"];
	-- Services & References
	local httpService = game:GetService("HttpService")
	local playersService = game:GetService("Players")
	local userInputService = game:GetService("UserInputService")
	local runService = game:GetService("RunService")
	
	local localPlayer = playersService.LocalPlayer
	local aiWidget = script.Parent
	local promptBox = aiWidget:WaitForChild("promptbox")
	local chatBox = aiWidget:WaitForChild("chatbox")
	local chatScroller = chatBox:WaitForChild("scroller")
	local sendButton = aiWidget:FindFirstChild("ImageButton")
	
	local inputScroll = promptBox:FindFirstChild("InputScroll")
	local promptTextBox = inputScroll and inputScroll:FindFirstChild("TextBox") or promptBox:FindFirstChild("TextBox")
	
	if not inputScroll then
		inputScroll = Instance.new("ScrollingFrame", promptBox)
		inputScroll.Name = "InputScroll"
		inputScroll.BackgroundTransparency = 1
		inputScroll.BorderSizePixel = 0
		promptTextBox.Parent = inputScroll
	end
	
	inputScroll.Size = UDim2.new(1, 0, 1, 0)
	inputScroll.ScrollingEnabled = true
	inputScroll.ScrollBarThickness = 3
	inputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	promptTextBox.MultiLine = true
	promptTextBox.TextWrapped = true
	promptTextBox.ClearTextOnFocus = false
	promptTextBox.TextYAlignment = Enum.TextYAlignment.Top
	
	-- Configuration & State
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local geminiApiKeyInstance = storage and storage:WaitForChild("geminiapikey")
	
	local function getApiKey()
		if geminiApiKeyInstance and type(geminiApiKeyInstance.Value) == "string" and geminiApiKeyInstance.Value ~= "" then
			local trimmed = geminiApiKeyInstance.Value:match("^%s*(.-)%s*$")
			if trimmed and trimmed ~= "" then return trimmed end
		end
		local isfilefn = isfile or (syn and syn.isfile)
		local readfilefn = readfile or (syn and syn.readfile)
		if isfilefn and readfilefn and isfilefn("zerohub_gemini_api_key.txt") then
			local ok, content = pcall(readfilefn, "zerohub_gemini_api_key.txt")
			if ok and type(content) == "string" then
				local trimmed = content:match("^%s*(.-)%s*$")
				if trimmed and trimmed ~= "" then
					if geminiApiKeyInstance then geminiApiKeyInstance.Value = trimmed end
					return trimmed
				end
			end
		end
		return ""
	end
	
	local apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key="
	local httpRequest = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
	
	local mainFont = Font.new("rbxassetid://16658237174", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	local codeFont = Font.new("rbxasset://fonts/families/Consolata.json")
	local maxBubbleWidth = 320
	local bubblePadding = 10
	
	local conversationHistory = {}
	local messageEntries = {}
	local isGenerating = false
	local isScrolling = false
	local isTextBoxFocused = false
	
	local systemPrompt = [[You are zerohub intelligence, an AI assistant built into a Roblox exploit hub called zerohub. You are talking directly to the user through a chat interface.
	
	Here is what you can do - these are REAL exploit functions available in this environment:
	1. loadstring(code)() - Execute Luau code directly
	2. game:HttpGet(url) - Fetch text from a URL
	3. writefile(name, content) - Write a file to the workspace
	4. readfile(name) - Read a file from the workspace
	5. setclipboard(text) - Copy text to clipboard
	6. getcustomasset(path) - Get a custom asset path
	7. getgenv() - Get the global environment table
	
	IMPORTANT RULES:
	- When you want to execute code, wrap it in a lua code block with ```lua
	- When you want to search for scripts, wrap the search query in a code block with ```search
	- Keep responses concise and helpful
	- Use markdown formatting: **bold**, *italic*, `code`, and code blocks with ```
	- Always be helpful and direct]]
	
	-- API key is resolved on demand per request via getApiKey()
	
	-- Markdown & Text Formatting
	local function escapeRichText(rawText)
		return rawText:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	end
	
	local function markdownToRichText(markdownText)
		local codePlaceholders = {}
		local formattedText = markdownText:gsub("`([^`\n]+)`", function(codeText)
			table.insert(codePlaceholders, '<font color="#FFD700"><b>' .. escapeRichText(codeText) .. "</b></font>")
			return "\0CODE" .. #codePlaceholders .. "\0"
		end)
	
		formattedText = escapeRichText(formattedText)
		formattedText = formattedText:gsub("%[([^%]]+)%]%(([^%)]+)%)", '<font color="#66B2FF"><u>%1</u></font>')
		formattedText = formattedText:gsub("\n(#+)%s+([^\n]+)", '\n<font size="15"><b>%2</b></font>')
		formattedText = formattedText:gsub("^(#+)%s+([^\n]+)", '<font size="15"><b>%2</b></font>')
		formattedText = formattedText:gsub("\n&gt;%s+", "\n┃ ")
		formattedText = formattedText:gsub("^&gt;%s+", "┃ ")
		formattedText = formattedText:gsub("\n[%*%-]%s+", "\n• ")
		formattedText = formattedText:gsub("^[%*%-]%s+", "• ")
		formattedText = formattedText:gsub("~~(.-)~~", '<font color="#888888"><s>%1</s></font>')
		formattedText = formattedText:gsub("%*%*%*(.-)%*%*%*", "<b><i>%1</i></b>")
		formattedText = formattedText:gsub("%*%*(.-)%*%*", "<b>%1</b>")
		formattedText = formattedText:gsub("%*([^\n%*]+)%*", "<i>%1</i>")
	
		return formattedText:gsub("\0CODE(%d+)\0", function(index)
			return codePlaceholders[tonumber(index)] or ""
		end)
	end
	
	-- Prompt & Chat Scrolling
	local function updatePromptHeight()
		local textHeight = promptTextBox.TextBounds.Y + 16
		local clampedHeight = math.clamp(textHeight, 42, 150)
		promptBox.Size = UDim2.new(0, 449, 0, clampedHeight)
		inputScroll.CanvasSize = UDim2.new(0, 0, 0, textHeight)
		promptTextBox.Size = UDim2.new(1, -8, 0, math.max(textHeight, clampedHeight))
	
		if textHeight > 150 and isTextBoxFocused then
			inputScroll.CanvasPosition = Vector2.new(0, math.max(0, textHeight - inputScroll.AbsoluteWindowSize.Y))
		end
	end
	
	promptTextBox:GetPropertyChangedSignal("TextBounds"):Connect(updatePromptHeight)
	promptTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		task.defer(updatePromptHeight)
	end)
	
	local function smoothScrollToBottom()
		if isScrolling then return end
		isScrolling = true
		local targetScroll = math.max(0, chatScroller.AbsoluteCanvasSize.Y - chatScroller.AbsoluteWindowSize.Y)
		local startScroll = chatScroller.CanvasPosition.Y
		local scrollDifference = targetScroll - startScroll
		if math.abs(scrollDifference) < 1 then
			isScrolling = false
			return
		end
	
		local elapsedTime = 0
		local scrollConnection
		scrollConnection = runService.RenderStepped:Connect(function(deltaTime)
			elapsedTime += deltaTime
			local progress = math.min(elapsedTime / 0.3, 1)
			local easedProgress = 1 - (1 - progress) ^ 3
			chatScroller.CanvasPosition = Vector2.new(0, startScroll + scrollDifference * easedProgress)
			if progress >= 1 then
				isScrolling = false
				scrollConnection:Disconnect()
			end
		end)
	end
	
	chatScroller:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(smoothScrollToBottom)
	
	-- Right-Click Context Menu
	local contextMenu = Instance.new("Frame", aiWidget)
	contextMenu.Name = "ContextMenu"
	contextMenu.Size = UDim2.new(0, 130, 0, 86)
	contextMenu.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	contextMenu.BorderSizePixel = 0
	contextMenu.Visible = false
	contextMenu.ZIndex = 50
	Instance.new("UICorner", contextMenu).CornerRadius = UDim.new(0, 6)
	
	local menuStroke = Instance.new("UIStroke", contextMenu)
	menuStroke.Color = Color3.fromRGB(55, 55, 55)
	menuStroke.Thickness = 1
	
	local menuLayout = Instance.new("UIListLayout", contextMenu)
	menuLayout.Padding = UDim.new(0, 2)
	menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local menuPadding = Instance.new("UIPadding", contextMenu)
	menuPadding.PaddingTop = UDim.new(0, 4)
	menuPadding.PaddingBottom = UDim.new(0, 4)
	menuPadding.PaddingLeft = UDim.new(0, 4)
	menuPadding.PaddingRight = UDim.new(0, 4)
	
	local selectedMessageEntry = nil
	local sendPromptToGemini
	
	local function createMenuButton(buttonText, layoutOrder, onClickCallback)
		local menuButton = Instance.new("TextButton", contextMenu)
		menuButton.Size = UDim2.new(1, 0, 0, 24)
		menuButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		menuButton.BackgroundTransparency = 1
		menuButton.BorderSizePixel = 0
		menuButton.FontFace = mainFont
		menuButton.TextSize = 12
		menuButton.TextColor3 = Color3.fromRGB(235, 235, 235)
		menuButton.TextXAlignment = Enum.TextXAlignment.Left
		menuButton.Text = "  " .. buttonText
		menuButton.LayoutOrder = layoutOrder
		menuButton.ZIndex = 51
		Instance.new("UICorner", menuButton).CornerRadius = UDim.new(0, 4)
	
		menuButton.MouseEnter:Connect(function() menuButton.BackgroundTransparency = 0 end)
		menuButton.MouseLeave:Connect(function() menuButton.BackgroundTransparency = 1 end)
		menuButton.MouseButton1Click:Connect(function()
			contextMenu.Visible = false
			if selectedMessageEntry then onClickCallback(selectedMessageEntry) end
		end)
	end
	
	local function truncateConversationFromEntry(startEntryIndex, startHistoryIndex)
		for entryIndex = #messageEntries, startEntryIndex, -1 do
			if messageEntries[entryIndex].frame then
				messageEntries[entryIndex].frame:Destroy()
			end
			table.remove(messageEntries, entryIndex)
		end
		for historyIndex = #conversationHistory, startHistoryIndex, -1 do
			table.remove(conversationHistory, historyIndex)
		end
	end
	
	createMenuButton("Copy", 1, function(messageEntry)
		if setclipboard then setclipboard(messageEntry.rawText or "") end
	end)
	
	createMenuButton("Regenerate", 2, function(messageEntry)
		if isGenerating or messageEntry.historyIndex == 0 then return end
		local targetHistoryIndex = messageEntry.role == "user" and messageEntry.historyIndex or (messageEntry.historyIndex - 1)
		if targetHistoryIndex < 1 or not conversationHistory[targetHistoryIndex] then return end
	
		local userPromptText = conversationHistory[targetHistoryIndex].parts[1].text
		local firstEntryIndex = #messageEntries + 1
		for index, entry in ipairs(messageEntries) do
			if entry.historyIndex >= targetHistoryIndex and entry.historyIndex > 0 then
				firstEntryIndex = index
				break
			end
		end
	
		truncateConversationFromEntry(firstEntryIndex, targetHistoryIndex)
		sendPromptToGemini(userPromptText)
	end)
	
	createMenuButton("Undo to here", 3, function(messageEntry)
		if isGenerating then return end
		local entryIndex = table.find(messageEntries, messageEntry)
		if not entryIndex then return end
	
		if messageEntry.historyIndex == 0 then
			truncateConversationFromEntry(2, 1)
		elseif messageEntry.role == "user" then
			promptTextBox.Text = messageEntry.rawText
			updatePromptHeight()
			truncateConversationFromEntry(entryIndex, messageEntry.historyIndex)
		else
			truncateConversationFromEntry(entryIndex + 1, messageEntry.historyIndex + 1)
		end
	end)
	
	local function bindContextMenu(targetFrame, messageEntry)
		targetFrame.Active = true
		targetFrame.InputBegan:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
				selectedMessageEntry = messageEntry
				local mousePosition = userInputService:GetMouseLocation()
				local relativeX = math.clamp(mousePosition.X - aiWidget.AbsolutePosition.X, 4, math.max(4, aiWidget.AbsoluteSize.X - 134))
				local relativeY = math.clamp(mousePosition.Y - aiWidget.AbsolutePosition.Y - 36, 4, math.max(4, aiWidget.AbsoluteSize.Y - 90))
				contextMenu.Position = UDim2.new(0, relativeX, 0, relativeY)
				contextMenu.Visible = true
			end
		end)
	end
	
	userInputService.InputBegan:Connect(function(inputObject)
		if contextMenu.Visible and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePosition = userInputService:GetMouseLocation()
			local menuPos, menuSize = contextMenu.AbsolutePosition, contextMenu.AbsoluteSize
			local isInsideX = mousePosition.X >= menuPos.X and mousePosition.X <= menuPos.X + menuSize.X
			local isInsideY = (mousePosition.Y - 36) >= menuPos.Y and (mousePosition.Y - 36) <= menuPos.Y + menuSize.Y
			if not (isInsideX and isInsideY) then
				contextMenu.Visible = false
			end
		end
	end)
	
	-- UI Bubble Builders
	local function applyPadding(parentInstance, paddingAmount)
		local uiPadding = Instance.new("UIPadding", parentInstance)
		uiPadding.PaddingLeft = UDim.new(0, paddingAmount)
		uiPadding.PaddingRight = UDim.new(0, paddingAmount)
		uiPadding.PaddingTop = UDim.new(0, paddingAmount)
		uiPadding.PaddingBottom = UDim.new(0, paddingAmount)
	end
	
	local function createUserBubble(messageText, historyIndex)
		local wrapperFrame = Instance.new("Frame", chatScroller)
		wrapperFrame.Name = "UserMessageWrapper"
		wrapperFrame.BackgroundTransparency = 1
		wrapperFrame.LayoutOrder = #chatScroller:GetChildren()
		wrapperFrame.Size = UDim2.new(1, 0, 0, 0)
		wrapperFrame.AutomaticSize = Enum.AutomaticSize.Y
	
		local bubbleContainer = Instance.new("Frame", wrapperFrame)
		bubbleContainer.Name = "UserMessage"
		bubbleContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		bubbleContainer.BorderSizePixel = 0
		bubbleContainer.AnchorPoint = Vector2.new(1, 0)
		bubbleContainer.Position = UDim2.new(1, 0, 0, 0)
		Instance.new("UICorner", bubbleContainer).CornerRadius = UDim.new(0, 8)
		applyPadding(bubbleContainer, bubblePadding)
	
		local messageLabel = Instance.new("TextLabel", bubbleContainer)
		messageLabel.BackgroundTransparency = 1
		messageLabel.RichText = true
		messageLabel.FontFace = mainFont
		messageLabel.TextSize = 13
		messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		messageLabel.TextXAlignment = Enum.TextXAlignment.Left
		messageLabel.TextYAlignment = Enum.TextYAlignment.Top
		messageLabel.TextWrapped = true
		messageLabel.AutomaticSize = Enum.AutomaticSize.Y
		messageLabel.Size = UDim2.new(0, maxBubbleWidth - bubblePadding * 2, 0, 0)
		messageLabel.Text = markdownToRichText(messageText)
	
		task.defer(function()
			local textBounds = messageLabel.TextBounds
			bubbleContainer.Size = UDim2.new(0, math.min(textBounds.X + bubblePadding * 2, maxBubbleWidth), 0, textBounds.Y + bubblePadding * 2)
			messageLabel.Size = UDim2.new(1, 0, 1, 0)
		end)
	
		local messageEntry = { frame = wrapperFrame, role = "user", rawText = messageText, historyIndex = historyIndex }
		table.insert(messageEntries, messageEntry)
		bindContextMenu(bubbleContainer, messageEntry)
	end
	
	local function createCodeBlock(codeContent, codeLanguage)
		local codeFrame = Instance.new("Frame")
		codeFrame.Name = "CodeBlock"
		codeFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		codeFrame.BorderSizePixel = 0
		codeFrame.Size = UDim2.new(1, 0, 0, 0)
		codeFrame.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 6)
		applyPadding(codeFrame, 8)
	
		local blockLayout = Instance.new("UIListLayout", codeFrame)
		blockLayout.Padding = UDim.new(0, 6)
		blockLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
		local headerBar = Instance.new("Frame", codeFrame)
		headerBar.BackgroundTransparency = 1
		headerBar.Size = UDim2.new(1, 0, 0, 22)
		headerBar.LayoutOrder = 1
	
		local languageLabel = Instance.new("TextLabel", headerBar)
		languageLabel.BackgroundTransparency = 1
		languageLabel.Size = UDim2.new(0.5, 0, 1, 0)
		languageLabel.FontFace = mainFont
		languageLabel.TextSize = 11
		languageLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
		languageLabel.TextXAlignment = Enum.TextXAlignment.Left
		languageLabel.Text = (codeLanguage and codeLanguage ~= "") and codeLanguage:upper() or "CODE"
	
		local copyButton = Instance.new("TextButton", headerBar)
		copyButton.Size = UDim2.new(0, 50, 0, 22)
		copyButton.Position = UDim2.new(1, -50, 0, 0)
		copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		copyButton.Text = "Copy"
		copyButton.FontFace = mainFont
		copyButton.TextSize = 12
		copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		copyButton.BorderSizePixel = 0
		Instance.new("UICorner", copyButton).CornerRadius = UDim.new(0, 4)
	
		copyButton.MouseButton1Click:Connect(function()
			if setclipboard then setclipboard(codeContent) end
			copyButton.Text = "Copied!"
			task.delay(1.5, function() copyButton.Text = "Copy" end)
		end)
	
		if codeLanguage and codeLanguage:lower():match("lua") then
			copyButton.Position = UDim2.new(1, -124, 0, 0)
			local executeButton = Instance.new("TextButton", headerBar)
			executeButton.Size = UDim2.new(0, 70, 0, 22)
			executeButton.Position = UDim2.new(1, -70, 0, 0)
			executeButton.BackgroundColor3 = Color3.fromRGB(45, 140, 90)
			executeButton.Text = "Execute"
			executeButton.FontFace = mainFont
			executeButton.TextSize = 12
			executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			executeButton.BorderSizePixel = 0
			Instance.new("UICorner", executeButton).CornerRadius = UDim.new(0, 4)
	
			executeButton.MouseButton1Click:Connect(function()
				local executableFunction = loadstring(codeContent)
				if executableFunction then
					task.spawn(executableFunction)
					executeButton.Text, executeButton.BackgroundColor3 = "Executed!", Color3.fromRGB(60, 60, 60)
				else
					executeButton.Text, executeButton.BackgroundColor3 = "Error!", Color3.fromRGB(140, 45, 45)
				end
				task.delay(2, function()
					executeButton.Text, executeButton.BackgroundColor3 = "Execute", Color3.fromRGB(45, 140, 90)
				end)
			end)
		end
	
		local codeLabel = Instance.new("TextLabel", codeFrame)
		codeLabel.BackgroundTransparency = 1
		codeLabel.RichText = false
		codeLabel.FontFace = codeFont
		codeLabel.TextSize = 12
		codeLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
		codeLabel.TextXAlignment = Enum.TextXAlignment.Left
		codeLabel.TextYAlignment = Enum.TextYAlignment.Top
		codeLabel.TextWrapped = true
		codeLabel.AutomaticSize = Enum.AutomaticSize.Y
		codeLabel.Size = UDim2.new(1, 0, 0, 0)
		codeLabel.LayoutOrder = 2
		codeLabel.Text = codeContent
	
		return codeFrame
	end
	
	local function createAIBubble(historyIndex)
		local bubbleContainer = Instance.new("Frame", chatScroller)
		bubbleContainer.Name = "AIMessage"
		bubbleContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		bubbleContainer.BackgroundTransparency = 1
		bubbleContainer.BorderSizePixel = 0
		bubbleContainer.Size = UDim2.new(1, -8, 0, 0)
		bubbleContainer.AutomaticSize = Enum.AutomaticSize.Y
		bubbleContainer.LayoutOrder = #chatScroller:GetChildren()
		Instance.new("UICorner", bubbleContainer).CornerRadius = UDim.new(0, 8)
		applyPadding(bubbleContainer, bubblePadding)
	
		local innerContainer = Instance.new("Frame", bubbleContainer)
		innerContainer.Name = "Inner"
		innerContainer.BackgroundTransparency = 1
		innerContainer.Size = UDim2.new(1, 0, 0, 0)
		innerContainer.AutomaticSize = Enum.AutomaticSize.Y
	
		local innerLayout = Instance.new("UIListLayout", innerContainer)
		innerLayout.Padding = UDim.new(0, 6)
		innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
		local initialLabel = Instance.new("TextLabel", innerContainer)
		initialLabel.BackgroundTransparency = 1
		initialLabel.RichText = true
		initialLabel.FontFace = mainFont
		initialLabel.TextSize = 13
		initialLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		initialLabel.TextXAlignment = Enum.TextXAlignment.Left
		initialLabel.TextYAlignment = Enum.TextYAlignment.Top
		initialLabel.TextWrapped = true
		initialLabel.AutomaticSize = Enum.AutomaticSize.Y
		initialLabel.Size = UDim2.new(1, 0, 0, 0)
	
		local messageEntry = { frame = bubbleContainer, role = "model", rawText = "", historyIndex = historyIndex or 0 }
		table.insert(messageEntries, messageEntry)
		bindContextMenu(bubbleContainer, messageEntry)
	
		return innerContainer, initialLabel, messageEntry
	end
	
	local function renderAIText(innerContainer, initialLabel, fullText, messageEntry)
		messageEntry.rawText = fullText
		for _, childElement in ipairs(innerContainer:GetChildren()) do
			if childElement:IsA("TextLabel") or childElement.Name == "CodeBlock" then
				childElement:Destroy()
			end
		end
	
		local parsedSegments = {}
		local currentPosition = 1
		for blockStart, languageTag, codeBody, blockEnd in fullText:gmatch("()```([%w_%-]*)%s*\n(.-)```()") do
			if blockStart > currentPosition then
				local textBefore = fullText:sub(currentPosition, blockStart - 1):gsub("^%s+", ""):gsub("%s+$", "")
				if textBefore ~= "" then
					table.insert(parsedSegments, { segmentType = "text", content = textBefore })
				end
			end
			table.insert(parsedSegments, { segmentType = "code", content = codeBody:gsub("%s+$", ""), language = languageTag })
			currentPosition = blockEnd
		end
	
		if currentPosition <= #fullText then
			local remainingText = fullText:sub(currentPosition):gsub("^%s+", ""):gsub("%s+$", "")
			if remainingText ~= "" then
				table.insert(parsedSegments, { segmentType = "text", content = remainingText })
			end
		end
	
		if #parsedSegments == 0 then
			initialLabel.Parent = innerContainer
			initialLabel.Text = markdownToRichText(fullText)
			return
		end
	
		for segmentIndex, segment in ipairs(parsedSegments) do
			if segment.segmentType == "text" then
				local textSegmentLabel = Instance.new("TextLabel", innerContainer)
				textSegmentLabel.BackgroundTransparency = 1
				textSegmentLabel.RichText = true
				textSegmentLabel.FontFace = mainFont
				textSegmentLabel.TextSize = 13
				textSegmentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				textSegmentLabel.TextXAlignment = Enum.TextXAlignment.Left
				textSegmentLabel.TextYAlignment = Enum.TextYAlignment.Top
				textSegmentLabel.TextWrapped = true
				textSegmentLabel.AutomaticSize = Enum.AutomaticSize.Y
				textSegmentLabel.Size = UDim2.new(1, 0, 0, 0)
				textSegmentLabel.LayoutOrder = segmentIndex
				textSegmentLabel.Text = markdownToRichText(segment.content)
			else
				local codeBlockFrame = createCodeBlock(segment.content, segment.language)
				codeBlockFrame.LayoutOrder = segmentIndex
				codeBlockFrame.Parent = innerContainer
			end
		end
	end
	
	-- Conversation & API
	local function showWelcomeMessage()
		local innerContainer, initialLabel, messageEntry = createAIBubble(0)
		local playerName = localPlayer.DisplayName or localPlayer.Name
		local welcomeText = string.format("Hey there, **%s**! I am zerohub intelligence, powered by **Google Gemini**. Type `/clear` anytime to reset, or right-click a message for options.", playerName)
		renderAIText(innerContainer, initialLabel, welcomeText, messageEntry)
		smoothScrollToBottom()
	end
	
	local function clearConversation()
		contextMenu.Visible = false
		truncateConversationFromEntry(1, 1)
		showWelcomeMessage()
	end
	
	local function requestGeminiCompletion(requestPayload)
		if not httpRequest then return nil end
		local currentKey = getApiKey()
		return httpRequest({
			Url = apiUrl .. currentKey,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["x-goog-api-key"] = currentKey
			},
			Body = httpService:JSONEncode(requestPayload)
		})
	end
	
	sendPromptToGemini = function(promptText)
		local currentKey = getApiKey()
		if currentKey == "" then
			local innerContainer, initialLabel, aiMessageEntry = createAIBubble(#conversationHistory + 1)
			initialLabel.Text = '<font color="rgb(255, 100, 100)"><b>API Key Missing!</b>\nPlease set your Gemini API key in <b>Settings &gt; AI</b> before chatting with zerohub intelligence.</font>'
			smoothScrollToBottom()
			if _G.zerohubnotificationsystem_warning then
				_G.zerohubnotificationsystem_warning("API Key Required", "Set your Gemini API key in Settings > AI")
			end
			return
		end
	
		isGenerating = true
		table.insert(conversationHistory, { role = "user", parts = {{ text = promptText }} })
		createUserBubble(promptText, #conversationHistory)
	
		local innerContainer, initialLabel, aiMessageEntry = createAIBubble(#conversationHistory + 1)
		initialLabel.Text = '<font color="#888888">Thinking...</font>'
		smoothScrollToBottom()
	
		local requestPayload = {
			systemInstruction = { parts = {{ text = systemPrompt }} },
			contents = conversationHistory
		}
	
		task.spawn(function()
			local response = requestGeminiCompletion(requestPayload)
			local statusCode = response and (response.StatusCode or response.status_code) or 0
			local responseBody = response and (response.Body or response.body) or ""
	
			if response and statusCode == 200 then
				local isSuccess, decodedData = pcall(function()
					return httpService:JSONDecode(responseBody)
				end)
	
				if not isSuccess or not decodedData then
					initialLabel.Text = '<font color="rgb(255, 50, 50)">Failed to decode JSON response!</font>'
					table.remove(conversationHistory, #conversationHistory)
					isGenerating = false
					return
				end
	
				local generatedResponseText = ""
				local firstCandidate = decodedData.candidates and decodedData.candidates[1]
				if firstCandidate and firstCandidate.content and firstCandidate.content.parts then
					for _, contentPart in ipairs(firstCandidate.content.parts) do
						if contentPart.text then
							generatedResponseText ..= contentPart.text
						end
					end
				end
	
				if generatedResponseText == "" then
					generatedResponseText = "Empty response from API"
				end
	
				table.insert(conversationHistory, { role = "model", parts = {{ text = generatedResponseText }} })
				aiMessageEntry.historyIndex = #conversationHistory
				renderAIText(innerContainer, initialLabel, generatedResponseText, aiMessageEntry)
				smoothScrollToBottom()
			else
				initialLabel.Text = string.format('<font color="rgb(255, 50, 50)">Error Code: %s\nDetails: %s</font>', tostring(statusCode), escapeRichText(tostring(responseBody)))
				table.remove(conversationHistory, #conversationHistory)
			end
	
			isGenerating = false
		end)
	end
	
	local function handleSendAction()
		if isGenerating then return end
		local rawInputText = promptTextBox.Text
		local trimmedText = rawInputText:match("^%s*(.-)%s*$")
	
		promptTextBox.Text = ""
		updatePromptHeight()
		task.defer(function()
			promptTextBox.Text = ""
			updatePromptHeight()
		end)
	
		if trimmedText == "" then return end
		if trimmedText:lower() == "/clear" then
			clearConversation()
			return
		end
	
		sendPromptToGemini(trimmedText)
	end
	
	-- Input & Initialization
	if sendButton then
		sendButton.MouseButton1Click:Connect(handleSendAction)
	end
	
	promptTextBox.Focused:Connect(function() isTextBoxFocused = true end)
	promptTextBox.FocusLost:Connect(function() isTextBoxFocused = false end)
	
	userInputService.InputBegan:Connect(function(inputObject)
		if inputObject.KeyCode ~= Enum.KeyCode.Return or not isTextBoxFocused or isGenerating then return end
		if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.RightShift) then return end
		handleSendAction()
	end)
	
	task.defer(function()
		task.wait(0.1)
		showWelcomeMessage()
	end)
end;
task.spawn(C_80);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.jobid.TextBox.LocalScript
local function C_97()
local script = G2L["97"];
	local TS = game:GetService("TeleportService")
	local textBox = script.Parent
	
	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local jobId = string.match(textBox.Text, "^%s*(.-)%s*$")
			if jobId and jobId ~= "" then
				print("[zerohub] Teleporting to custom J*b ID...")
				local success, err = pcall(function()
					TS:TeleportToPlaceInstance(game.PlaceId, jobId)
				end)
				if not success then
					warn("[zerohub] j*bid teleport failed: " .. tostring(err))
				end
			end
		end
	end)
end;
task.spawn(C_97);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.anim
local function C_9e()
local script = G2L["9e"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_9e);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.rejoin.TextButton.LocalScript
local function C_9f()
local script = G2L["9f"];
	local TS = game:GetService("TeleportService")
	local button = script.Parent
	
	button.MouseButton1Click:Connect(function()
		print("[zerohub] Rejoining server: " .. game.JobId)
		local success, err = pcall(function()
			TS:TeleportToPlaceInstance(game.PlaceId, game.JobId)
		end)
		if not success then
			warn("[zerohub] rejoin failed: " .. tostring(err))
		end
	end)
end;
task.spawn(C_9f);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.anim
local function C_a7()
local script = G2L["a7"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_a7);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.serverhop.TextButton.LocalScript
local function C_a8()
local script = G2L["a8"];
	local TS = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local button = script.Parent
	
	local function httpRequest(url)
		if type(request) == "function" then
			local response = request({ Url = url, Method = "GET" })
			return response.Body
		elseif type(http_request) == "function" then
			local response = http_request({ Url = url, Method = "GET" })
			return response.Body
		else
			return HttpService:GetAsync(url)
		end
	end
	
	button.MouseButton1Click:Connect(function()
		print("[zerohub] Server hopping...")
		local cursor = nil
	
		while true do
			local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			if cursor then
				url = url .. "&cursor=" .. cursor
			end
	
			local success, body = pcall(function()
				return httpRequest(url)
			end)
	
			if not success then
				warn("[zerohub] serverhop: Failed to fetch server list: " .. tostring(body))
				break
			end
	
			local decodeSuccess, data = pcall(function()
				return HttpService:JSONDecode(body)
			end)
	
			if not decodeSuccess or not data or not data.data then
				warn("[zerohub] serverhop: Failed to parse server list.")
				break
			end
	
			for _, server in ipairs(data.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					print("[zerohub] serverhop: Found server " .. server.id .. " (" .. server.playing .. "/" .. server.maxPlayers .. ")")
					local tSuccess, tErr = pcall(function()
						TS:TeleportToPlaceInstance(game.PlaceId, server.id)
					end)
					if not tSuccess then
						warn("[zerohub] serverhop: Teleport failed: " .. tostring(tErr))
					end
					return
				end
			end
	
			cursor = data.nextPageCursor
			if not cursor then
				warn("[zerohub] serverhop: No available servers found.")
				break
			end
		end
	end)
end;
task.spawn(C_a8);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.anim
local function C_b0()
local script = G2L["b0"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_b0);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.server.ScrollingFrame.smallserver.TextButton.LocalScript
local function C_b1()
local script = G2L["b1"];
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local button = script.Parent
	
	local function httpRequest(url)
		if type(request) == "function" then
			return request({Url = url, Method = "GET"}).Body
		elseif type(http_request) == "function" then
			return http_request({Url = url, Method = "GET"}).Body
		end
		return HttpService:GetAsync(url)
	end
	
	button.MouseButton1Click:Connect(function()
		print("[zerohub] teleport: small server: Searching for the smallest server...")
		button.Text = "Searching"
		local cursor, smallestServer, minPlayers = nil, nil, math.huge
	
		repeat
			local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			if cursor then url = url .. "&cursor=" .. cursor end
	
			local success, body = pcall(httpRequest, url)
			if not success then break end
	
			local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
			if not ok or not data or not data.data then break end
	
			-- Find the server with the lowest player count
			for _, server in ipairs(data.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId and server.playing < minPlayers then
					minPlayers = server.playing
					smallestServer = server
				end
			end
	
			cursor = data.nextPageCursor
		until not cursor
	
		if smallestServer then
			print("[zerohub] teleport: small server: Teleporting to server " .. smallestServer.id .. " with " .. smallestServer.playing .. " players...")
			TeleportService:TeleportToPlaceInstance(game.PlaceId, smallestServer.id)
		else
			warn("[zerohub] teleport: small server: No suitable servers found.")
		end
	end)
end;
task.spawn(C_b1);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.anim
local function C_ba()
local script = G2L["ba"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_ba);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.placeid.TextButton.LocalScript
local function C_bb()
local script = G2L["bb"];
	script.Parent.MouseButton1Click:Connect(function()
		setclipboard(game.PlaceId)
	end)
end;
task.spawn(C_bb);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.anim
local function C_c3()
local script = G2L["c3"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_c3);
-- StarterGui.zerohub.interface.main.tabs.teleport.teleporttabs.information.jobid.TextButton.LocalScript
local function C_c4()
local script = G2L["c4"];
	script.Parent.MouseButton1Click:Connect(function()
		setclipboard(game.JobId)
	end)
end;
task.spawn(C_c4);
-- StarterGui.zerohub.interface.main.tabs.teleport.tabsw
local function C_c8()
local script = G2L["c8"];
	local TweenService = game:GetService("TweenService")
	
	local home = script.Parent
	local topButtons = home:WaitForChild("top")
	local hometabs = home:WaitForChild("teleporttabs")
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local TWEEN_TIME = 0.35
	local SLIDE_EASE = Enum.EasingStyle.Back
	local COLOR_EASE = Enum.EasingStyle.Quad
	local EASE_DIR = Enum.EasingDirection.Out
	
	local ACTIVE_BG = Color3.fromRGB(60, 60, 60)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local ACTIVE_ICON = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	local INACTIVE_ICON = Color3.fromRGB(100, 100, 100)
	
	local tabNames = {"server", "information"}
	local currentTab = tabNames[1]
	
	local function updateColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			ACTIVE_BG = Color3.fromRGB(60, 60, 60)
			ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
			ACTIVE_ICON = Color3.fromRGB(255, 255, 255)
			INACTIVE_BG = Color3.fromRGB(30, 30, 30)
			INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
			INACTIVE_ICON = Color3.fromRGB(100, 100, 100)
		else
			ACTIVE_BG = Color3.fromRGB(209, 213, 219)
			ACTIVE_TEXT = Color3.fromRGB(17, 24, 39)
			ACTIVE_ICON = Color3.fromRGB(17, 24, 39)
			INACTIVE_BG = Color3.fromRGB(228, 231, 235)
			INACTIVE_TEXT = Color3.fromRGB(107, 114, 128)
			INACTIVE_ICON = Color3.fromRGB(107, 114, 128)
		end
		for _, name in ipairs(tabNames) do
			local button = topButtons:FindFirstChild(name)
			if button then
				local isActive = (name == currentTab)
				local icon = button:FindFirstChild("ImageLabel")
				local info = TweenInfo.new(TWEEN_TIME, COLOR_EASE, EASE_DIR)
				TweenService:Create(button, info, {
					BackgroundColor3 = isActive and ACTIVE_BG or INACTIVE_BG,
					TextColor3 = isActive and ACTIVE_TEXT or INACTIVE_TEXT
				}):Play()
				if icon then
					TweenService:Create(icon, info, {
						ImageColor3 = isActive and ACTIVE_ICON or INACTIVE_ICON
					}):Play()
				end
			end
		end
	end
	
	local function tweenColor(obj, prop, targetColor)
	    if not obj then return end
	    local info = TweenInfo.new(TWEEN_TIME, COLOR_EASE, EASE_DIR)
	    TweenService:Create(obj, info, {[prop] = targetColor}):Play()
	end
	
	local function getOriginalPos(panel)
	    local stored = panel:GetAttribute("OriginalPos")
	    if stored then
	        return stored
	    end
	    local pos = panel.Position
	    local ud2 = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
	    panel:SetAttribute("OriginalPos", ud2)
	    return ud2
	end
	
	local function offsetPos(originalPos, dx)
	    return UDim2.new(originalPos.X.Scale, originalPos.X.Offset + dx, originalPos.Y.Scale, originalPos.Y.Offset)
	end
	
	local function getSlideDistance()
	    return home.Size.X.Offset
	end
	
	local function tweenPanel(panel, show)
	    if not panel then return end
	    local originalPos = getOriginalPos(panel)
	    local slideDist = getSlideDistance()
	    local info = TweenInfo.new(TWEEN_TIME, SLIDE_EASE, show and Enum.EasingDirection.Out or Enum.EasingDirection.In)
	    if show then
	        panel.Visible = true
	        panel.Position = offsetPos(originalPos, slideDist)
	        TweenService:Create(panel, info, {Position = originalPos}):Play()
	    else
	        local tween = TweenService:Create(panel, info, {Position = offsetPos(originalPos, -slideDist)})
	        tween:Play()
	        tween.Completed:Connect(function()
	            panel.Visible = false
	            panel.Position = originalPos
	        end)
	    end
	end
	
	local function setActive(tabName)
	    currentTab = tabName
	    for _, name in ipairs(tabNames) do
	        local button = topButtons:FindFirstChild(name)
	        local panel = hometabs:FindFirstChild(name)
	        local isActive = (name == tabName)
	
	        if button then
	            local icon = button:FindFirstChild("ImageLabel")
	            tweenColor(button, "BackgroundColor3", isActive and ACTIVE_BG or INACTIVE_BG)
	            tweenColor(button, "TextColor3", isActive and ACTIVE_TEXT or INACTIVE_TEXT)
	            if icon then tweenColor(icon, "ImageColor3", isActive and ACTIVE_ICON or INACTIVE_ICON) end
	        end
	
	        tweenPanel(panel, isActive)
	    end
	end
	
	for _, name in ipairs(tabNames) do
	    local button = topButtons:FindFirstChild(name)
	    if button then
	        button.Activated:Connect(function()
	            setActive(name)
	        end)
	    end
	end
	
	if darktheme then
	    darktheme.Changed:Connect(updateColors)
	end
	
	updateColors()
	setActive(tabNames[1])
	
end;
task.spawn(C_c8);
-- StarterGui.zerohub.interface.main.tabs.musicplayer.pp.ImageButton.LocalScript
local function C_d6()
local script = G2L["d6"];
	local RunService = game:GetService("RunService")
	
	local button = script.Parent
	local sound = button.Parent.Parent.maybachmusiclol
	
	local PLAY_ICON = "rbxassetid://10734919336"
	local PAUSE_ICON = "rbxassetid://10734923549"
	
	-- Toggle play/pause properly when clicked
	button.MouseButton1Click:Connect(function()
		if sound.IsPlaying then
			sound:Pause()
		else
			if sound.TimePosition > 0 and sound.TimePosition < sound.TimeLength then
				sound:Resume()
			else
				sound:Play()
			end
		end
	end)
	
	-- Checks every single frame if the sound is playing or paused, meow!
	RunService.RenderStepped:Connect(function()
		if sound.IsPlaying then
			if button.Image ~= PLAY_ICON then
				button.Image = PLAY_ICON
			end
		else
			if button.Image ~= PAUSE_ICON then
				button.Image = PAUSE_ICON
			end
		end
	end)
end;
task.spawn(C_d6);
-- StarterGui.zerohub.interface.main.tabs.musicplayer.url.t.LocalScript
local function C_db()
local script = G2L["db"];
	local textBox = script.Parent
	local root = textBox.Parent and textBox.Parent.Parent and textBox.Parent.Parent.Parent
	if not root then
		return
	end
	
	local sound = root:FindFirstChild("maybachmusiclol", true)
	local titleLabel = root:FindFirstChild("AAAAAAAAAAAAAPLEASEREMOVETHISAAAAAAAAAAAAA", true)
	
	if not sound then --[[hi]] end
	if not titleLabel then --[[dont panic lol]] end
	
	textBox.FocusLost:Connect(function(enterPressed)
		_G.zerohubnotificationsystem_info("Music", "Downloading song")
		if not enterPressed then return end
	
		local input = textBox.Text
		if input == "" then return end
	
		task.spawn(function()
			if input:match("^%d+$") or input:match("rbxassetid://") then
				local id = input:match("%d+")
				local fullAssetId = "rbxassetid://" .. id
	
	
				if sound then
					sound.SoundId = fullAssetId
					sound:Play()
				end
				if titleLabel then titleLabel.Text = "ID: " .. id end
				return
			end
	
			local httpSuccess, mp3Data = pcall(function()
				return game:HttpGet(input)
			end)
	
			if not httpSuccess then
				_G.zerohubnotificationsystem_warning("Music", "Failed to download song")
				return
			end
	
			if writefile and getcustomasset then
				local fileName = "temp_audio_" .. tick() .. ".mp3"
				writefile(fileName, mp3Data)
	
				local customAsset = getcustomasset(fileName)
	
				if sound then
					sound.SoundId = customAsset
					sound:Play()
					_G.zerohubnotificationsystem_success("Music", "Now playing song")
				end
	
				if titleLabel then
					local cleanName = input:match("([^/]+)%.mp3") or input:match("[^/]+$") or input
					titleLabel.Text = cleanName
				end
			else
				_G.zerohubnotificationsystem_warning("Music", "Unsupported input")
			end
		end)
	end)
end;
task.spawn(C_db);
-- StarterGui.zerohub.interface.main.tabs.musicplayer.av.LocalScript
local function C_dd()
local script = G2L["dd"];
	-- References
	local runService = game:GetService("RunService")
	local container = script.Parent
	local sound = container.Parent:WaitForChild("maybachmusiclol")
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local function getBarColor()
		local isDark = not darktheme or darktheme.Value
		return isDark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
	end
	
	-- Settings
	local barCount = 32
	local barSpacing = 0.004
	local attackSpeed = 50
	local gravity = 4.0
	local minimumHeight = 0.05
	local sensitivity = 0.002
	
	-- Cleanup
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("Frame") and child.Name == "CavaBar" then
			child:Destroy()
		end
	end
	
	-- Initialization
	local bars = {}
	local currentHeights = table.create(barCount, minimumHeight)
	local fallSpeeds = table.create(barCount, 0)
	local barWidth = (1 - (barSpacing * (barCount - 1))) / barCount
	local centerIndex = (barCount + 1) / 2
	
	for barIndex = 1, barCount do
		local bar = Instance.new("Frame")
		local positionX = (barIndex - 1) * (barWidth + barSpacing)
	
		bar.Name = "CavaBar"
		bar.BackgroundColor3 = getBarColor()
		bar.BorderSizePixel = 0
		bar.AnchorPoint = Vector2.new(0, 1)
		bar.Position = UDim2.fromScale(positionX, 1)
		bar.Size = UDim2.fromScale(barWidth, minimumHeight)
		bar.Parent = container
		bars[barIndex] = bar
	end
	
	local function updateBarColors()
		local color = getBarColor()
		for _, bar in ipairs(bars) do
			bar.BackgroundColor3 = color
		end
	end
	
	if darktheme then
		darktheme.Changed:Connect(updateBarColors)
	end
	
	-- Visualizer
	runService.RenderStepped:Connect(function(deltaTime)
		local loudness = sound.PlaybackLoudness
		local playbackTime = sound.TimePosition
	
		for barIndex = 1, barCount do
			local targetHeight = minimumHeight
	
			if sound.IsPlaying and loudness > 10 then
				local centerDistance = math.abs(barIndex - centerIndex) / centerIndex
				local stereoChannel = if barIndex <= centerIndex then 1 else -1
				local frequencyWeight = math.clamp(2.0 - (centerDistance * 1.6), 0.35, 2.0)
				local wave = math.noise(centerDistance * 4, playbackTime * 4, centerDistance * stereoChannel)
				local modulation = math.clamp(wave + 0.75, 0.25, 1.25)
	
				targetHeight = math.clamp(loudness * sensitivity * frequencyWeight * modulation, minimumHeight, 1)
			end
	
			if targetHeight > currentHeights[barIndex] then
				currentHeights[barIndex] += (targetHeight - currentHeights[barIndex]) * math.min(deltaTime * attackSpeed, 1)
				fallSpeeds[barIndex] = 0
			else
				fallSpeeds[barIndex] += gravity * deltaTime
				currentHeights[barIndex] = math.max(minimumHeight, currentHeights[barIndex] - fallSpeeds[barIndex] * deltaTime)
			end
	
			bars[barIndex].Size = UDim2.fromScale(barWidth, currentHeights[barIndex])
		end
	end)
end;
task.spawn(C_dd);
-- StarterGui.zerohub.interface.main.tabs.musicplayer.progressbar.ProgressScript
local function C_ff()
local script = G2L["ff"];
	-- services
	local runservice = game:GetService("RunService")
	local userinputservice = game:GetService("UserInputService")
	
	-- references
	local progressbar = script.Parent
	local fillframe = progressbar:FindFirstChildOfClass("Frame")
	local musicplayer = progressbar.Parent
	local sound = musicplayer:FindFirstChild("maybachmusiclol")
	local progresscontainer = musicplayer:FindFirstChild("progressok")
	local timelabel = progresscontainer and progresscontainer:FindFirstChildOfClass("TextLabel")
	
	-- configuration
	progressbar.Active = true
	local barwidth = 343
	local smoothspeed = 12
	local displayedprogress = 0
	local targetprogress = 0
	local isdragging = false
	
	-- helper functions
	local function formattime(seconds)
		if seconds <= 0 then return "0:00" end
		return string.format("%d:%02d", math.floor(seconds / 60), math.floor(seconds % 60))
	end
	
	local function updateseek(input)
		if not sound or sound.TimeLength <= 0 then return end
		local relativeposition = input.Position.X - progressbar.AbsolutePosition.X
		targetprogress = math.clamp(relativeposition / progressbar.AbsoluteSize.X, 0, 1)
		sound.TimePosition = targetprogress * sound.TimeLength
	end
	
	-- input handling
	progressbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isdragging = true
			updateseek(input)
		end
	end)
	
	userinputservice.InputChanged:Connect(function(input)
		if isdragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateseek(input)
		end
	end)
	
	userinputservice.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isdragging = false
		end
	end)
	
	-- update loop
	runservice.RenderStepped:Connect(function(deltatime)
		if not sound or not fillframe then return end
	
		local timelength = sound.TimeLength
		if timelength > 0 and not isdragging then
			targetprogress = sound.TimePosition / timelength
		elseif timelength <= 0 then
			targetprogress = 0
		end
	
		displayedprogress += (targetprogress - displayedprogress) * math.clamp(smoothspeed * deltatime, 0, 1)
		fillframe.Size = UDim2.new(0, math.max(1, barwidth * displayedprogress), 0, 29)
	
		if timelabel then
			local currenttime = timelength > 0 and (targetprogress * timelength) or 0
			timelabel.Text = string.format("%s / %s", formattime(currenttime), formattime(timelength))
		end
	end)
end;
task.spawn(C_ff);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.anim
local function C_109()
local script = G2L["109"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_109);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.clear.LocalScript
local function C_10a()
local script = G2L["10a"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.consoleholder.c.yesc.Text = ""
		_G.zerohubnotificationsystem_success("Console", "Cleared console")
	end)
end;
task.spawn(C_10a);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.anim
local function C_10f()
local script = G2L["10f"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_10f);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.save.LocalScript
local function C_110()
local script = G2L["110"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.savedialog.Visible = true
	end)
end;
task.spawn(C_110);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.anim
local function C_114()
local script = G2L["114"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_114);
-- StarterGui.zerohub.interface.main.tabs.console.buttonsholder.copy.LocalScript
local function C_115()
local script = G2L["115"];
	local button = script.Parent
	local logLabel = button.Parent.Parent.consoleholder.c.yesc
	
	button.Activated:Connect(function()
		local rawText = logLabel.Text
		if rawText == "" then return end
	
		local cleanText = rawText
			:gsub("<[^>]->", "")
			:gsub("&lt;", "<")
			:gsub("&gt;", ">")
			:gsub("&amp;", "&")
	
		if setclipboard then
			setclipboard(cleanText)
			_G.zerohubnotificationsystem_success("Console", "Copied console to clipboard")
		end
	end)
end;
task.spawn(C_115);
-- StarterGui.zerohub.interface.main.tabs.console.consoleholder.c.yesc.LocalScript
local function C_11c()
local script = G2L["11c"];
	local Log = game:GetService("LogService")
	local Tween = game:GetService("TweenService")
	
	local box = script.Parent
	local scroll = box.Parent
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	box.RichText = true
	
	local autoScroll = true
	local isTweening = false
	local currentTween = nil
	local isRendering = false
	local logBuffer = {}
	
	local function getThemePalette()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return {
				[Enum.MessageType.MessageOutput] = "FFFFFF",
				[Enum.MessageType.MessageInfo] = "84D6F7",
				[Enum.MessageType.MessageWarning] = "FFFF00",
				[Enum.MessageType.MessageError] = "FF0000"
			}
		else
			return {
				[Enum.MessageType.MessageOutput] = "111827",
				[Enum.MessageType.MessageInfo] = "0284C7",
				[Enum.MessageType.MessageWarning] = "D97706",
				[Enum.MessageType.MessageError] = "DC2626"
			}
		end
	end
	
	local function renderAllLogs()
		isRendering = true
		local palette = getThemePalette()
		local defaultColor = (not darktheme or darktheme.Value) and "FFFFFF" or "111827"
		local lines = {}
		for _, entry in ipairs(logBuffer) do
			local hex = palette[entry.msgType] or defaultColor
			table.insert(lines, string.format('<font color="#%s">%s %s</font>', hex, entry.stamp, entry.msg))
		end
		box.Text = table.concat(lines, "\n") .. (#lines > 0 and "\n" or "")
		isRendering = false
	end
	
	if darktheme then
		darktheme.Changed:Connect(renderAllLogs)
	end
	
	-- Detect if the user manually scrolled up
	scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if isTweening then return end
		local max = scroll.CanvasSize.Y.Offset - scroll.AbsoluteWindowSize.Y
		if max > 0 then
			autoScroll = (scroll.CanvasPosition.Y >= max - 15)
		end
	end)
	
	-- Detect if box was cleared externally
	box:GetPropertyChangedSignal("Text"):Connect(function()
		if not isRendering and box.Text == "" and #logBuffer > 0 then
			table.clear(logBuffer)
		end
	end)
	
	-- Adapt sizes & smoothly scroll down when text changes
	box:GetPropertyChangedSignal("TextBounds"):Connect(function()
		local maxY = box.TextBounds.Y
		scroll.CanvasSize = UDim2.new(0, 0, 0, maxY)
		box.Size = UDim2.new(1, 0, 0, maxY)
	
		if autoScroll then
			local targetY = math.max(0, maxY - scroll.AbsoluteWindowSize.Y)
			if currentTween then currentTween:Cancel() end
	
			isTweening = true
			currentTween = Tween:Create(scroll, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
				CanvasPosition = Vector2.new(0, targetY)
			})
	
			local tween = currentTween
			tween.Completed:Once(function()
				if currentTween == tween then isTweening = false end
			end)
			tween:Play()
		end
	end)
	
	-- Listen to the console and inject logs
	Log.MessageOut:Connect(function(msg, msgType)
		local palette = getThemePalette()
		local defaultColor = (not darktheme or darktheme.Value) and "FFFFFF" or "111827"
		local hex = palette[msgType] or defaultColor
		local t = tick()
		local stamp = string.format("[%s.%03d]", os.date("%H:%M:%S", t), math.floor((t % 1) * 1000))
	
		local sanitizedMsg = msg:gsub("<", "&lt;"):gsub(">", "&gt;")
	
		table.insert(logBuffer, {
			stamp = stamp,
			msg = sanitizedMsg,
			msgType = msgType
		})
	
		isRendering = true
		box.Text ..= string.format('<font color="#%s">%s %s</font>\n', hex, stamp, sanitizedMsg)
		isRendering = false
	end)
	
end;
task.spawn(C_11c);
-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.close.LocalScript
local function C_123()
local script = G2L["123"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.Visible = false
	end)
end;
task.spawn(C_123);
-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.anim
local function C_127()
local script = G2L["127"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_127);
-- StarterGui.zerohub.interface.main.tabs.console.savedialog.main.save.LocalScript
local function C_128()
local script = G2L["128"];
	local button = script.Parent
	local logLabel = button.Parent.Parent.Parent.consoleholder.c.yesc
	
	button.Activated:Connect(function()
		local rawText = logLabel.Text
		if rawText == "" then return end
	
		local cleanText = rawText
			:gsub("<[^>]->", "")
			:gsub("&lt;", "<")
			:gsub("&gt;", ">")
			:gsub("&amp;", "&")
	
		if writefile then
			writefile(script.Parent.Parent.TextBox.Text, cleanText)
			_G.zerohubnotificationsystem_success("Console", "Saved console to file")
		end
		
		script.Parent.Parent.TextBox.Text = ""
	end)
end;
task.spawn(C_128);
-- StarterGui.zerohub.interface.main.tabs.quickrun.tabmanager
local function C_12d()
local script = G2L["12d"];
	-- Services & References
	local quickrun = script.Parent
	local tabsFrame = quickrun:FindFirstChild("tabs")
	local editor = quickrun:FindFirstChild("editor")
	local textBox = editor and editor:FindFirstChild("TextBox")
	local addtabBtn = tabsFrame and tabsFrame:FindFirstChild("addtab")
	local template = quickrun:FindFirstChild("activetabexample")
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	-- Tab state
	local tabs = {}
	local activeTab = nil
	
	-- Theme colors
	local function isdark()
		if darktheme then return darktheme.Value end
		return true
	end
	
	local function gettabcolors()
		local dark = isdark()
		return {
			activeBg = dark and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(255, 255, 255),
			inactiveBg = dark and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(228, 231, 235),
			activeText = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39),
			inactiveText = dark and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(107, 114, 128),
			activeIcon = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39),
			inactiveIcon = dark and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(107, 114, 128),
			addtabIcon = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
		}
	end
	
	-- Visual styling
	local function setTabActiveStyle(tabData, isActive)
		local btn = tabData.button
		if not btn then return end
		local colors = gettabcolors()
	
		btn.BackgroundColor3 = isActive and colors.activeBg or colors.inactiveBg
		local tabtitle = btn:FindFirstChild("tabtitle")
		local closeBtn = btn:FindFirstChild("close")
	
		if tabtitle then
			tabtitle.TextColor3 = isActive and colors.activeText or colors.inactiveText
		end
		if closeBtn then
			closeBtn.ImageColor3 = isActive and colors.activeIcon or colors.inactiveIcon
		end
	end
	
	local function refreshTheme()
		local colors = gettabcolors()
		if addtabBtn then
			addtabBtn.ImageColor3 = colors.addtabIcon
		end
		for _, t in ipairs(tabs) do
			setTabActiveStyle(t, t == activeTab)
		end
	end
	
	-- Tab numbering
	local function renumberTabs()
		for i, t in ipairs(tabs) do
			t.title = "Tab " .. i
			if t.button then
				local tabtitle = t.button:FindFirstChild("tabtitle")
				if tabtitle then tabtitle.Text = t.title end
			end
		end
	end
	
	-- Create tab button
	local function createTabButton(tabData)
		local btn = template:Clone()
		btn.Name = "tab" .. #tabs + 1
		btn.Visible = true
		btn.Active = true
		btn.Parent = tabsFrame
	
		local tabtitle = btn:FindFirstChild("tabtitle")
		local closeBtn = btn:FindFirstChild("close")
		if tabtitle then tabtitle.Text = tabData.title end
	
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				activateTab(tabData)
			end
		end)
	
		if closeBtn then
			closeBtn.MouseButton1Click:Connect(function()
				closeTab(tabData)
			end)
		end
	
		return btn
	end
	
	-- Activate tab
	function activateTab(tabData)
		if activeTab == tabData then return end
		if activeTab and textBox then
			activeTab.text = textBox.Text
		end
	
		for _, t in ipairs(tabs) do
			setTabActiveStyle(t, false)
		end
	
		activeTab = tabData
		setTabActiveStyle(tabData, true)
	
		if textBox then
			textBox.Text = tabData.text or ""
		end
	end
	
	-- Close tab
	function closeTab(tabData)
		local idx = table.find(tabs, tabData)
		if not idx then return end
	
		if activeTab == tabData and textBox then
			tabData.text = textBox.Text
		end
	
		if tabData.button then
			tabData.button:Destroy()
		end
		table.remove(tabs, idx)
	
		if #tabs == 0 then
			activeTab = nil
			createTab()
			return
		end
	
		renumberTabs()
	
		if activeTab == tabData then
			activeTab = nil
			local newIdx = math.min(idx, #tabs)
			activateTab(tabs[newIdx])
		end
	end
	
	-- Create tab
	function createTab()
		local tabData = {
			title = "Tab " .. (#tabs + 1),
			text = ""
		}
		tabData.button = createTabButton(tabData)
		table.insert(tabs, tabData)
		activateTab(tabData)
		return tabData
	end
	
	-- Event connections
	if addtabBtn then
		addtabBtn.MouseButton1Click:Connect(function()
			createTab()
		end)
	end
	
	if darktheme then
		darktheme.Changed:Connect(refreshTheme)
	end
	
	-- Initialize
	createTab()
	refreshTheme()
	
end;
task.spawn(C_12d);
-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.linesandshit
local function C_12f()
local script = G2L["12f"];
	local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}
	local global_env = {"getrawmetatable", "game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16"}
	
	local Source = script.Parent.TextBox
	local Lines = script.Parent.Lines
	local LineHighlight = script.Parent:FindFirstChild("LineHighlight")
	local TweenService = game:GetService("TweenService")
	
	local currentHighlightTween = nil
	local currentHighlightLine = -1
	
	local function updateLineHighlight()
		if not LineHighlight then return end
	
		local cursorPos = Source.CursorPosition
		if cursorPos < 0 then
			LineHighlight.Visible = false
			return
		end
	
		local text = Source.Text
		local textUpToCursor = text:sub(1, cursorPos)
		local lineNum = 1
		for _ in textUpToCursor:gmatch("\n") do
			lineNum = lineNum + 1
		end
	
		if lineNum == currentHighlightLine then return end
		currentHighlightLine = lineNum
	
		-- Calculate line height dynamically from TextBounds and line count
		local totalLines = 1
		for _ in text:gmatch("\n") do
			totalLines = totalLines + 1
		end
		local lineHeight = 14
		if totalLines > 0 and Source.TextBounds.Y > 0 then
			lineHeight = Source.TextBounds.Y / totalLines
			if lineHeight < 1 then lineHeight = 14 end
		end
	
		local targetY = (lineNum - 1) * lineHeight
	
		if currentHighlightTween then
			currentHighlightTween:Cancel()
		end
	
		LineHighlight.Visible = true
		local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		currentHighlightTween = TweenService:Create(LineHighlight, tweenInfo, {
			Position = UDim2.new(0, 0, 0, targetY),
			Size = UDim2.new(1, 0, 0, lineHeight),
		})
		currentHighlightTween:Play()
	end
	
	local Highlight = function(string, keywords)
	    local K = {}
	    local S = string
	    local Token =
	    {
	        ["="] = true,
	        ["."] = true,
	        [","] = true,
	        ["("] = true,
	        [")"] = true,
	        ["["] = true,
	        ["]"] = true,
	        ["{"] = true,
	        ["}"] = true,
	        [":"] = true,
	        ["*"] = true,
	        ["/"] = true,
	        ["+"] = true,
	        ["-"] = true,
	        ["%"] = true,
			[";"] = true,
			["~"] = true
	    }
	    for i, v in pairs(keywords) do
	        K[v] = true
	    end
	    S = S:gsub(".", function(c)
	        if Token[c] ~= nil then
	            return "\32"
	        else
	            return c
	        end
	    end)
	    S = S:gsub("%S+", function(c)
	        if K[c] ~= nil then
	            return c
	        else
	            return (" "):rep(#c)
	        end
	    end)
	  
	    return S
	end
	
	local hTokens = function(string)
	    local Token =
	    {
	        ["="] = true,
	        ["."] = true,
	        [","] = true,
	        ["("] = true,
	        [")"] = true,
	        ["["] = true,
	        ["]"] = true,
	        ["{"] = true,
	        ["}"] = true,
	        [":"] = true,
	        ["*"] = true,
	        ["/"] = true,
	        ["+"] = true,
	        ["-"] = true,
	        ["%"] = true,
			[";"] = true,
			["~"] = true
	    }
	    local A = ""
	    string:gsub(".", function(c)
	        if Token[c] ~= nil then
	            A = A .. c
	        elseif c == "\n" then
	            A = A .. "\n"
			elseif c == "\t" then
				A = A .. "\t"
	        else
	            A = A .. "\32"
	        end
	    end)
	  
	    return A
	end
	
	
	local strings = function(string)
	    local highlight = ""
	    local quote = false
	    string:gsub(".", function(c)
	        if quote == false and c == "\"" then
	            quote = true
	        elseif quote == true and c == "\"" then
	            quote = false
	        end
	        if quote == false and c == "\"" then
	            highlight = highlight .. "\""
	        elseif c == "\n" then
	            highlight = highlight .. "\n"
			elseif c == "\t" then
			    highlight = highlight .. "\t"
	        elseif quote == true then
	            highlight = highlight .. c
	        elseif quote == false then
	            highlight = highlight .. "\32"
	        end
	    end)
	  
	    return highlight
	end
	
	local comments = function(string)
	    local ret = ""
	    string:gsub("[^\r\n]+", function(c)
	        local comm = false
	        local i = 0
	        c:gsub(".", function(n)
	            i = i + 1
	            if c:sub(i, i + 1) == "--" then
	                comm = true
	            end
	            if comm == true then
	                ret = ret .. n
	            else
	                ret = ret .. "\32"
	            end
	        end)
	        ret = ret
	    end)
	    
	    return ret
	end
	
	local numbers = function(string)
	    local A = ""
	    string:gsub(".", function(c)
	        if tonumber(c) ~= nil then
	            A = A .. c
	        elseif c == "\n" then
	            A = A .. "\n"
			elseif c == "\t" then
				A = A .. "\t"
	        else
	            A = A .. "\32"
	        end
	    end)
	  
	    return A
	end
	
	local highlight_source = function(type)
		if type == "Text" then
			Source.Text = Source.Text:gsub("\13", "")
			Source.Text = Source.Text:gsub("\t", "      ")
			local s = Source.Text
			Source.Keywords_.Text = Highlight(s, lua_keywords)
			Source.Globals_.Text = Highlight(s, global_env)
			Source.RemoteHighlight_.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer"})
			Source.Tokens_.Text = hTokens(s)
			Source.Numbers_.Text = numbers(s)
			Source.Strings_.Text = strings(s)
			local lin = 1
			s:gsub("\n", function()
				lin = lin + 1
			end)
			Lines.Text = ""
			for i = 1, lin do
				Lines.Text = Lines.Text .. i .. "\n"
			end
		end
	end
	
	highlight_source("Text")
	updateLineHighlight()
	
	Source.Changed:Connect(function(prop)
		highlight_source(prop)
		if prop == "CursorPosition" or prop == "Text" then
			updateLineHighlight()
		end
	end)
	
	
end;
task.spawn(C_12f);
-- StarterGui.zerohub.interface.main.tabs.quickrun.editor.autoadjust
local function C_130()
local script = G2L["130"];
	local scrollingFrame = script.Parent
	local frame = scrollingFrame:FindFirstChild("TextBox")
	if not frame then
		return
	end
	local TweenService = game:GetService("TweenService")
	
	-- Ensure the TextBox is editable and multi-line, but NOT wrapped (horizontal scrolling)
	frame.TextEditable = true
	frame.MultiLine = true
	frame.TextWrapped = false
	
	-- Initial layout settings
	scrollingFrame.CanvasSize = UDim2.new(1, 0, 1, 0)
	frame.Size = UDim2.new(1, 0, 1, 0)
	
	local autoScrollV = true
	local autoScrollH = true
	local threshold = 25
	local currentTween = nil
	
	-- Track whether the user has manually scrolled up or left
	scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		local maxScrollY = scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteSize.Y
		local maxScrollX = scrollingFrame.AbsoluteCanvasSize.X - scrollingFrame.AbsoluteSize.X
		if maxScrollY > 0 then
			autoScrollV = (scrollingFrame.CanvasPosition.Y >= maxScrollY - threshold)
		end
		if maxScrollX > 0 then
			autoScrollH = (scrollingFrame.CanvasPosition.X >= maxScrollX - threshold)
		end
	end)
	
	local function updateScrollAndSize()
		-- Force UI frame deferral so TextBounds updates accurately
		task.defer(function()
			local containerWidth = scrollingFrame.AbsoluteSize.X
			local containerHeight = scrollingFrame.AbsoluteSize.Y
	
			local textWidth = frame.TextBounds.X
			local textHeight = frame.TextBounds.Y
			local neededWidth = math.max(containerWidth, textWidth + 20)
			local neededHeight = math.max(containerHeight, textHeight + 20)
	
			-- Update sizes dynamically
			frame.Size = UDim2.new(0, neededWidth, 0, neededHeight)
			scrollingFrame.CanvasSize = UDim2.new(0, neededWidth, 0, neededHeight)
	
			-- Determine target scroll position for both axes
			local targetX = nil
			local targetY = nil
	
			if autoScrollH and textWidth > containerWidth then
				targetX = math.max(0, neededWidth - containerWidth)
			end
	
			if autoScrollV and textHeight > containerHeight then
				targetY = math.max(0, neededHeight - containerHeight)
			end
	
			if targetX or targetY then
				local newX = targetX or scrollingFrame.CanvasPosition.X
				local newY = targetY or scrollingFrame.CanvasPosition.Y
	
				if currentTween then
					currentTween:Cancel()
				end
	
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				currentTween = TweenService:Create(scrollingFrame, tweenInfo, {
					CanvasPosition = Vector2.new(newX, newY)
				})
				currentTween:Play()
			end
		end)
	end
	
	-- Listen for both text changes and property updates
	frame:GetPropertyChangedSignal("Text"):Connect(updateScrollAndSize)
	frame:GetPropertyChangedSignal("TextBounds"):Connect(updateScrollAndSize)
end;
task.spawn(C_130);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.anim
local function C_148()
local script = G2L["148"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_148);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.copy.LocalScript
local function C_149()
local script = G2L["149"];
	script.Parent.MouseButton1Click:Connect(function()
		setclipboard(script.Parent.Parent.Parent.editor.TextBox.Text)
		_G.zerohubnotificationsystem_success("Editor", "Copied to clipboard")
	end)
end;
task.spawn(C_149);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.anim
local function C_14e()
local script = G2L["14e"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_14e);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.clear.LocalScript
local function C_14f()
local script = G2L["14f"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.editor.TextBox.Text = ""
		_G.zerohubnotificationsystem_success("Editor", "Cleared editor")
	end)
end;
task.spawn(C_14f);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.anim
local function C_153()
local script = G2L["153"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_153);
-- StarterGui.zerohub.interface.main.tabs.quickrun.buttonsholder.execute.LocalScript
local function C_154()
local script = G2L["154"];
	script.Parent.MouseButton1Click:Connect(function()
		loadstring(script.Parent.Parent.Parent.editor.TextBox.Text)()
		_G.zerohubnotificationsystem_success("Editor", "Executed code")
	end)
end;
task.spawn(C_154);
-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.movement.LocalScript
local function C_15b()
local script = G2L["15b"];
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local player = Players.LocalPlayer
	local movement = script.Parent
	local buttons = movement:FindFirstChild("buttons")
	local sliders = movement:FindFirstChild("sliders")
	
	-- Button references
	local flyBtn = buttons:FindFirstChild("fly")
	local noclipBtn = buttons:FindFirstChild("noclip")
	local infjumpBtn = buttons:FindFirstChild("infjump")
	
	-- Slider references
	local wsFrame = sliders:FindFirstChild("walkspeed")
	local jpFrame = sliders:FindFirstChild("jumppower")
	local fsFrame = sliders:FindFirstChild("flyspeed")
	
	local wsFiller = wsFrame:FindFirstChild("filler")
	local wsLabel = wsFrame:FindFirstChild("value")
	local jpFiller = jpFrame:FindFirstChild("filler")
	local jpLabel = jpFrame:FindFirstChild("value")
	local fsFiller = fsFrame:FindFirstChild("filler")
	local fsLabel = fsFrame:FindFirstChild("value")
	
	-- Slider value state: target = what user drags to, display = smoothly animated visual
	local wsTarget, wsDisplay = 16, 16
	local jpTarget, jpDisplay = 50, 50
	local fsTarget, fsDisplay = 1, 1
	
	-- Toggle states
	local flyOn = false
	local noclipOn = false
	local infjumpOn = false
	
	-- References & Theme
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local function isdark()
		if darktheme then return darktheme.Value end
		return true
	end
	
	-- Connections for toggles
	local noclipConn
	local infjumpConn
	
	-- Read current character walkspeed/jumppower to initialize sliders
	local function readCharacterValues()
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			wsTarget = hum.WalkSpeed
			wsDisplay = hum.WalkSpeed
			jpTarget = hum.JumpPower
			jpDisplay = hum.JumpPower
		end
	end
	
	readCharacterValues()
	player.CharacterAdded:Connect(function()
		readCharacterValues()
		task.wait(0.3)
		-- Re-apply slider values to new character
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = wsTarget
				hum.JumpPower = jpTarget
			end
		end
	end)
	
	-- ---- Slider system ----
	local function makeSlider(frame, maxValue, getTarget, setTarget, onTargetChange)
		local dragging = false
		local mainFrame = movement.Parent.Parent -- game.StarterGui.zerohub.main
	
		local function setDraggingState(state)
			mainFrame:SetAttribute("IsDraggingSlider", state)
		end
	
		local function updateFromMouse(input)
			local absPos = frame.AbsolutePosition.X
			local absSize = frame.AbsoluteSize.X
			if absSize <= 0 then return end
			local rel = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
			local newVal = math.floor(rel * maxValue + 0.5)
			if newVal ~= getTarget() then
				setTarget(newVal)
				if onTargetChange then onTargetChange(newVal) end
			end
		end
	
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setDraggingState(true)
				updateFromMouse(input)
			end
		end)
	
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				updateFromMouse(input)
			end
		end)
	
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				if dragging then
					dragging = false
					setDraggingState(false)
				end
			end
		end)
	end
	
	local function applyWalkspeed(val)
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = val end
		end
	end
	
	local function applyJumppower(val)
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.JumpPower = val end
		end
	end
	
	makeSlider(wsFrame, 500, function() return wsTarget end, function(v) wsTarget = v end, applyWalkspeed)
	makeSlider(jpFrame, 500, function() return jpTarget end, function(v) jpTarget = v end, applyJumppower)
	makeSlider(fsFrame, 10, function() return fsTarget end, function(v) fsTarget = v end, nil)
	
	-- ---- Smooth animation + fly loop ----
	local lastTime = os.clock()
	
	RunService.RenderStepped:Connect(function()
		local now = os.clock()
		local dt = now - lastTime
		lastTime = now
	
		-- Frame-rate independent smoothing factor (higher = snappier)
		local lerpFactor = 1 - math.exp(-dt * 22)
	
		-- Walkspeed slider visual
		local wsWidth = wsFrame.AbsoluteSize.X
		if wsWidth > 0 then
			wsDisplay = wsDisplay + (wsTarget - wsDisplay) * lerpFactor
			wsFiller.Size = UDim2.new(0, (wsDisplay / 500) * wsWidth, 1, 0)
			wsLabel.Text = tostring(math.round(wsDisplay))
		end
	
		-- Jumppower slider visual
		local jpWidth = jpFrame.AbsoluteSize.X
		if jpWidth > 0 then
			jpDisplay = jpDisplay + (jpTarget - jpDisplay) * lerpFactor
			jpFiller.Size = UDim2.new(0, (jpDisplay / 500) * jpWidth, 1, 0)
			jpLabel.Text = tostring(math.round(jpDisplay))
		end
	
		-- Flyspeed slider visual
		local fsWidth = fsFrame.AbsoluteSize.X
		if fsWidth > 0 then
			fsDisplay = fsDisplay + (fsTarget - fsDisplay) * lerpFactor
			fsFiller.Size = UDim2.new(0, (fsDisplay / 10) * fsWidth, 1, 0)
			fsLabel.Text = tostring(math.round(fsDisplay))
		end
	
		-- Fly movement
		if flyOn then
			local char = player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hrp and hum then
					hum.PlatformStand = true
					local camera = Workspace.CurrentCamera
					if camera then
						local speed = fsTarget * 20
						local move = Vector3.zero
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.yAxis end
						if move.Magnitude > 0 then
							move = move.Unit * speed
						end
						hrp.AssemblyLinearVelocity = move
					end
				end
			end
		end
	end)
	
	-- ---- Button toggles ----
	local function setBtnActive(btn, on)
		if not btn then return end
		local icon = btn:FindFirstChildOfClass("ImageLabel")
		local dark = isdark()
		if on then
			local activeBg = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			local activeText = dark and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = activeBg
			btn.TextColor3 = activeText
			if icon then icon.ImageColor3 = activeText end
		else
			local inactiveBg = dark and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(228, 231, 235)
			local inactiveText = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			btn.BackgroundColor3 = inactiveBg
			btn.TextColor3 = inactiveText
			if icon then icon.ImageColor3 = inactiveText end
		end
	end
	
	local function refreshTheme()
		setBtnActive(flyBtn, flyOn)
		setBtnActive(noclipBtn, noclipOn)
		setBtnActive(infjumpBtn, infjumpOn)
	end
	
	if darktheme then
		darktheme.Changed:Connect(refreshTheme)
	end
	
	local function toggleFly(on)
		flyOn = on
		setBtnActive(flyBtn, on)
		if not on then
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.PlatformStand = false end
			end
		end
	end
	
	local function toggleNoclip(on)
		noclipOn = on
		setBtnActive(noclipBtn, on)
		if on then
			noclipConn = RunService.Stepped:Connect(function()
				local char = player.Character
				if char then
					for _, part in char:GetDescendants() do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConn then
				noclipConn:Disconnect()
				noclipConn = nil
			end
			local char = player.Character
			if char then
				for _, part in char:GetDescendants() do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = true
					end
				end
			end
		end
	end
	
	local function toggleInfjump(on)
		infjumpOn = on
		setBtnActive(infjumpBtn, on)
		if on then
			infjumpConn = UserInputService.JumpRequest:Connect(function()
				local char = player.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then
						hum:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		else
			if infjumpConn then
				infjumpConn:Disconnect()
				infjumpConn = nil
			end
		end
	end
	
	flyBtn.MouseButton1Click:Connect(function() toggleFly(not flyOn) end)
	noclipBtn.MouseButton1Click:Connect(function() toggleNoclip(not noclipOn) end)
	infjumpBtn.MouseButton1Click:Connect(function() toggleInfjump(not infjumpOn) end)
	
	-- Initialize button colors
	setBtnActive(flyBtn, false)
	setBtnActive(noclipBtn, false)
	setBtnActive(infjumpBtn, false)
end;
task.spawn(C_15b);
-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.teleportation.LocalScript
local function C_17d()
local script = G2L["17d"];
	-- Services & References
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local player = Players.LocalPlayer
	local teleportation = script.Parent
	local buttons = teleportation:FindFirstChild("buttons")
	local playerlist = teleportation:FindFirstChild("playerlist")
	local scrollFrame = playerlist:FindFirstChild("ScrollingFrame")
	local exampleTemplate = scrollFrame:FindFirstChild("example")
	local selectedTemplate = scrollFrame:FindFirstChild("selectedexample")
	
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	-- Button references
	local clicktpBtn = buttons:FindFirstChild("clicktp")
	local tpplayerBtn = buttons:FindFirstChild("tpplayer")
	
	-- State
	local selectedPlayer = nil
	local clicktpOn = false
	local clicktpTool = nil
	local entryMap = {}
	
	local function isdark()
		if darktheme then return darktheme.Value end
		return true
	end
	
	-- Button visual helper
	local function setBtnActive(btn, on)
		if not btn then return end
		local icon = btn:FindFirstChildOfClass("ImageLabel")
		local dark = isdark()
	
		if on then
			local activeBg = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			local activeText = dark and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = activeBg
			btn.TextColor3 = activeText
			if icon then icon.ImageColor3 = activeText end
		else
			local inactiveBg = dark and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(228, 231, 235)
			local inactiveText = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
			btn.BackgroundColor3 = inactiveBg
			btn.TextColor3 = inactiveText
			if icon then icon.ImageColor3 = inactiveText end
		end
	end
	
	-- Playerlist entry visual helper
	local function setEntrySelected(entry, selected)
		if not entry then return end
		local label = entry:FindFirstChild("displayname")
		local avatar = entry:FindFirstChild("userprofileicon-avatar")
		local dark = isdark()
	
		if dark then
			if selected then
				entry.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				if label then label.TextColor3 = Color3.fromRGB(17, 24, 39) end
			else
				entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
			end
		else
			if selected then
				entry.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
				if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
			else
				entry.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				if label then label.TextColor3 = Color3.fromRGB(17, 24, 39) end
			end
		end
		if avatar then
			avatar.ImageColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
	
	local function refreshTheme()
		setBtnActive(clicktpBtn, clicktpOn)
		setBtnActive(tpplayerBtn, false)
		for p, entry in pairs(entryMap) do
			setEntrySelected(entry, selectedPlayer == p)
		end
	end
	
	-- Layout updater
	local function updateCanvasSize()
		local count = 0
		for _ in pairs(entryMap) do count += 1 end
		local cellSizeY = 30
		local padding = 5
		local contentHeight = math.max(0, count * (cellSizeY + padding) - padding)
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	end
	
	-- Create player entry
	local function createEntry(p)
		if entryMap[p] then return end
		local entry = exampleTemplate:Clone()
		entry.Name = p.Name
		entry.Visible = true
		entry.Parent = scrollFrame
		entryMap[p] = entry
	
		updateCanvasSize()
	
		local label = entry:FindFirstChild("displayname")
		if label then
			label.Text = p.DisplayName
		end
	
		local icon = entry:FindFirstChild("userprofileicon-avatar")
		if icon then
			icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			task.spawn(function()
				local ok, thumb = pcall(function()
					return Players:GetUserThumbnailAsync(
						p.UserId,
						Enum.ThumbnailType.HeadShot,
						Enum.ThumbnailSize.Size48x48
					)
				end)
				if ok and thumb and entry.Parent then
					icon.Image = thumb
				end
			end)
		end
	
		entry.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				if selectedPlayer and entryMap[selectedPlayer] then
					setEntrySelected(entryMap[selectedPlayer], false)
				end
				selectedPlayer = p
				setEntrySelected(entry, true)
			end
		end)
	
		setEntrySelected(entry, selectedPlayer == p)
	end
	
	local function removeEntry(p)
		local entry = entryMap[p]
		if entry then
			entry:Destroy()
			entryMap[p] = nil
		end
		if selectedPlayer == p then
			selectedPlayer = nil
		end
		updateCanvasSize()
	end
	
	for _, p in ipairs(Players:GetPlayers()) do
		createEntry(p)
	end
	
	Players.PlayerAdded:Connect(createEntry)
	Players.PlayerRemoving:Connect(removeEntry)
	
	-- Click TP Tool
	local coordTooltipGui = nil
	local coordTooltipLabel = nil
	local coordTooltipConn = nil
	
	local function createCoordTooltip()
		local dark = isdark()
		local gui = Instance.new("ScreenGui")
		gui.Name = "ClickTPCoordTooltip"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 9999
		gui.Parent = player:WaitForChild("PlayerGui")
	
		local frame = Instance.new("Frame")
		frame.Name = "TooltipBox"
		frame.Size = UDim2.new(0, 110, 0, 56)
		frame.BackgroundColor3 = dark and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0.15
		frame.BorderSizePixel = 0
		frame.Visible = false
		frame.Parent = gui
	
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame
	
		local stroke = Instance.new("UIStroke")
		stroke.Color = dark and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(218, 222, 229)
		stroke.Thickness = 1
		stroke.Transparency = 0.3
		stroke.Parent = frame
	
		local label = Instance.new("TextLabel")
		label.Name = "Coords"
		label.Size = UDim2.new(1, -10, 1, -8)
		label.Position = UDim2.new(0, 5, 0, 4)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 14
		label.TextColor3 = dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Text = "X: 0.000\nY: 0.000\nZ: 0.000"
		label.Parent = frame
	
		return gui, frame, label
	end
	
	local function toggleClickTP(on)
		clicktpOn = on
		setBtnActive(clicktpBtn, on)
	
		if on then
			if clicktpTool then
				clicktpTool:Destroy()
				clicktpTool = nil
			end
	
			clicktpTool = Instance.new("Tool")
			clicktpTool.Name = "Click TP"
			clicktpTool.RequiresHandle = false
			clicktpTool.ToolTip = "Click anywhere to teleport"
			clicktpTool.Parent = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack")
	
			local mouse = player:GetMouse()
			local equipped = false
	
			coordTooltipGui, coordTooltipLabel, _ = createCoordTooltip()
			local tooltipFrame = coordTooltipGui:FindFirstChild("TooltipBox")
			local tooltipText = tooltipFrame:FindFirstChild("Coords")
	
			coordTooltipConn = RunService.RenderStepped:Connect(function()
				if not equipped then
					tooltipFrame.Visible = false
					return
				end
				local hitPos = mouse.Hit.Position
				tooltipText.Text = string.format("X: %.3f\nY: %.3f\nZ: %.3f", hitPos.X, hitPos.Y, hitPos.Z)
	
				local mousePos = UserInputService:GetMouseLocation()
				tooltipFrame.Position = UDim2.new(0, mousePos.X + 16, 0, mousePos.Y + 18)
				tooltipFrame.Visible = true
			end)
	
			clicktpTool.Equipped:Connect(function()
				equipped = true
			end)
			clicktpTool.Unequipped:Connect(function()
				equipped = false
				tooltipFrame.Visible = false
			end)
	
			clicktpTool.Activated:Connect(function()
				if not equipped then return end
				local char = player.Character
				if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
	
				local targetPos = mouse.Hit.Position
				hrp:PivotTo(CFrame.new(targetPos + Vector3.new(0, 3, 0)))
			end)
		else
			if clicktpTool then
				clicktpTool:Destroy()
				clicktpTool = nil
			end
			if coordTooltipConn then
				coordTooltipConn:Disconnect()
				coordTooltipConn = nil
			end
			if coordTooltipGui then
				coordTooltipGui:Destroy()
				coordTooltipGui = nil
			end
		end
	end
	
	-- TP to selected player
	local function tpToPlayer()
		if not selectedPlayer then return end
		local targetChar = selectedPlayer.Character
		if not targetChar then return end
		local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
		if not targetHrp then return end
	
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
	
		hrp:PivotTo(targetHrp.CFrame * CFrame.new(0, 0, 4))
	end
	
	-- Button events
	clicktpBtn.MouseButton1Click:Connect(function()
		toggleClickTP(not clicktpOn)
	end)
	
	tpplayerBtn.MouseButton1Click:Connect(tpToPlayer)
	
	if darktheme then
		darktheme.Changed:Connect(refreshTheme)
	end
	
	-- Initialize
	refreshTheme()
	
	script.Destroying:Connect(function()
		if clicktpTool then clicktpTool:Destroy() end
		if coordTooltipConn then coordTooltipConn:Disconnect() end
		if coordTooltipGui then coordTooltipGui:Destroy() end
	end)
	
end;
task.spawn(C_17d);
-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.visual.LocalScript
local function C_196()
local script = G2L["196"];
	-- Services
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	
	-- References
	local localPlayer = Players.LocalPlayer
	local visualMenu = script.Parent
	local buttonsFolder = visualMenu:FindFirstChild("buttons")
	
	-- Toggle Buttons
	local espBtn = buttonsFolder:FindFirstChild("esp")
	local fullbrightBtn = buttonsFolder:FindFirstChild("fullbright")
	local chamsBtn = buttonsFolder:FindFirstChild("chams")
	local skeletonBtn = buttonsFolder:FindFirstChild("skeleton")
	local nametagsBtn = buttonsFolder:FindFirstChild("nametags")
	local fovCircleBtn = buttonsFolder:FindFirstChild("fovcircle")
	local healthBtn = buttonsFolder:FindFirstChild("health")
	local distanceBtn = buttonsFolder:FindFirstChild("distance")
	local boxesBtn = buttonsFolder:FindFirstChild("boxes")
	local tracersBtn = buttonsFolder:FindFirstChild("tracers")
	
	-- States
	local espOn, fullbrightOn, chamsOn, skeletonOn, nametagsOn = false, false, false, false, false
	local fovCircleOn, healthOn, distanceOn, boxesOn, tracersOn = false, false, false, false, false
	
	-- Theme Colors
	local activeColor = Color3.fromRGB(255, 255, 255)
	local inactiveColor = Color3.fromRGB(40, 40, 40)
	local activeTextColor = Color3.fromRGB(30, 30, 30)
	local inactiveTextColor = Color3.fromRGB(255, 255, 255)
	
	-- Storage
	local espObjects = {}
	local chamsObjects = {}
	local skeletonObjects = {}
	local nametagObjects = {}
	local healthObjects = {}
	local distanceObjects = {}
	local boxesObjects = {}
	local tracersObjects = {}
	
	-- Overlay GUI & Folders
	local overlayGui = Instance.new("ScreenGui")
	overlayGui.Name = "VisualOverlay"
	overlayGui.IgnoreGuiInset = true
	overlayGui.ResetOnSpawn = false
	overlayGui.Parent = localPlayer:WaitForChild("PlayerGui")
	
	local highlightFolder = Instance.new("Folder")
	highlightFolder.Name = "VisualHighlights"
	highlightFolder.Parent = Workspace
	
	-- Saved Lighting State
	local savedLighting = {}
	local fovCircleGui
	
	-- Bones
	local skeletonBonesR15 = {
		{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
		{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
		{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
		{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
		{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
	}
	
	local skeletonBonesR6 = {
		{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
	}
	
	local function detectRigType(char)
		if char:FindFirstChild("UpperTorso") then return "R15"
		elseif char:FindFirstChild("Torso") then return "R6" end
		return nil
	end
	
	local function setButtonState(btn, active)
		if not btn then return end
		local icon = btn:FindFirstChildOfClass("ImageLabel")
		btn.BackgroundColor3 = active and activeColor or inactiveColor
		btn.TextColor3 = active and activeTextColor or inactiveTextColor
		if icon then icon.ImageColor3 = active and activeTextColor or inactiveTextColor end
	end
	
	local function getValidCharacter(p)
		if not p or not p.Character or not p.Character:IsDescendantOf(Workspace) then return nil end
		return p.Character
	end
	
	-- ESP
	local function createESP(target)
		if target == localPlayer or espObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local hl = Instance.new("Highlight")
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(255, 0, 0)
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
		hl.FillTransparency = 0.7
		hl.DepthScale = 0
		hl.Parent = highlightFolder
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 50)
		bb.StudsOffset = Vector3.new(0, 2, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = target.DisplayName
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		espObjects[target] = {highlight = hl, billboard = bb}
	end
	
	local function removeESP(target)
		if espObjects[target] then
			if espObjects[target].highlight then espObjects[target].highlight:Destroy() end
			if espObjects[target].billboard then espObjects[target].billboard:Destroy() end
			espObjects[target] = nil
		end
	end
	
	local function toggleESP(active)
		espOn = active
		setButtonState(espBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createESP(p) else removeESP(p) end
		end
	end
	
	-- Fullbright
	local function toggleFullbright(active)
		fullbrightOn = active
		setButtonState(fullbrightBtn, active)
		if active then
			savedLighting = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				GlobalShadows = Lighting.GlobalShadows,
				Ambient = Lighting.Ambient,
				OutdoorAmbient = Lighting.OutdoorAmbient
			}
			Lighting.Brightness = 2
			Lighting.ClockTime = 12
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
		else
			Lighting.Brightness = savedLighting.Brightness or 1
			Lighting.ClockTime = savedLighting.ClockTime or 14
			Lighting.GlobalShadows = savedLighting.GlobalShadows ~= false
			Lighting.Ambient = savedLighting.Ambient or Color3.new(0,0,0)
			Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient or Color3.new(0,0,0)
		end
	end
	
	-- Chams
	local function createChams(target)
		if target == localPlayer or chamsObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local hl = Instance.new("Highlight")
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(0, 255, 0)
		hl.OutlineColor = Color3.fromRGB(0, 0, 0)
		hl.FillTransparency = 0.5
		hl.DepthScale = 1
		hl.Parent = highlightFolder
	
		chamsObjects[target] = hl
	end
	
	local function removeChams(target)
		if chamsObjects[target] then
			chamsObjects[target]:Destroy()
			chamsObjects[target] = nil
		end
	end
	
	local function toggleChams(active)
		chamsOn = active
		setButtonState(chamsBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createChams(p) else removeChams(p) end
		end
	end
	
	-- Skeleton
	local function createSkeleton(target)
		if target == localPlayer or skeletonObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local rig = detectRigType(char)
		if not rig then return end
		local bones = rig == "R15" and skeletonBonesR15 or skeletonBonesR6
	
		local folder = Instance.new("Folder")
		folder.Name = "Skeleton_" .. target.Name
		folder.Parent = overlayGui
	
		local lines = {}
		for _, bone in ipairs(bones) do
			local frame = Instance.new("Frame")
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Size = UDim2.new(0, 0, 0, 2)
			frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame.BorderSizePixel = 0
			frame.ZIndex = 999
			frame.Visible = false
			frame.Parent = folder
			table.insert(lines, {frame = frame, bone = bone})
		end
	
		skeletonObjects[target] = {folder = folder, lines = lines}
	end
	
	local function removeSkeleton(target)
		if skeletonObjects[target] then
			if skeletonObjects[target].folder then skeletonObjects[target].folder:Destroy() end
			skeletonObjects[target] = nil
		end
	end
	
	local function toggleSkeleton(active)
		skeletonOn = active
		setButtonState(skeletonBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createSkeleton(p) else removeSkeleton(p) end
		end
	end
	
	-- Nametags
	local function createNametag(target)
		if target == localPlayer or nametagObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 30)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = target.DisplayName
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		nametagObjects[target] = bb
	end
	
	local function removeNametag(target)
		if nametagObjects[target] then
			nametagObjects[target]:Destroy()
			nametagObjects[target] = nil
		end
	end
	
	local function toggleNametags(active)
		nametagsOn = active
		setButtonState(nametagsBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createNametag(p) else removeNametag(p) end
		end
	end
	
	-- FOV Circle
	local function toggleFOVCircle(active)
		fovCircleOn = active
		setButtonState(fovCircleBtn, active)
		if active then
			fovCircleGui = Instance.new("ScreenGui")
			fovCircleGui.IgnoreGuiInset = true
			fovCircleGui.ResetOnSpawn = false
			fovCircleGui.Parent = localPlayer:WaitForChild("PlayerGui")
	
			local circle = Instance.new("Frame")
			circle.AnchorPoint = Vector2.new(0.5, 0.5)
			circle.Size = UDim2.new(0, 200, 0, 200)
			circle.Position = UDim2.new(0.5, 0, 0.5, 0)
			circle.BackgroundTransparency = 1
			circle.Parent = fovCircleGui
	
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = circle
	
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(255, 255, 255)
			stroke.Thickness = 1.5
			stroke.Transparency = 0.3
			stroke.Parent = circle
		else
			if fovCircleGui then fovCircleGui:Destroy() end
		end
	end
	
	-- Health
	local function createHealth(target)
		if target == localPlayer or healthObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 100, 0, 30)
		bb.StudsOffset = Vector3.new(0, 3, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 0, 12)
		bg.Position = UDim2.new(0, 0, 0.5, 0)
		bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		bg.BorderSizePixel = 0
		bg.Parent = bb
	
		local bgCorner = Instance.new("UICorner")
		bgCorner.CornerRadius = UDim.new(0, 3)
		bgCorner.Parent = bg
	
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(1, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		fill.BorderSizePixel = 0
		fill.Parent = bg
	
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(0, 3)
		fillCorner.Parent = fill
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 14)
		label.Position = UDim2.new(0, 0, 0, -2)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		healthObjects[target] = {billboard = bb, fill = fill, label = label}
	end
	
	local function removeHealth(target)
		if healthObjects[target] then
			if healthObjects[target].billboard then healthObjects[target].billboard:Destroy() end
			healthObjects[target] = nil
		end
	end
	
	local function toggleHealth(active)
		healthOn = active
		setButtonState(healthBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createHealth(p) else removeHealth(p) end
		end
	end
	
	-- Distance
	local function createDistance(target)
		if target == localPlayer or distanceObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 30)
		bb.StudsOffset = Vector3.new(0, -3, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		distanceObjects[target] = {billboard = bb, label = label}
	end
	
	local function removeDistance(target)
		if distanceObjects[target] then
			if distanceObjects[target].billboard then distanceObjects[target].billboard:Destroy() end
			distanceObjects[target] = nil
		end
	end
	
	local function toggleDistance(active)
		distanceOn = active
		setButtonState(distanceBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createDistance(p) else removeDistance(p) end
		end
	end
	
	-- Boxes
	local function createBox(target)
		if target == localPlayer or boxesObjects[target] then return end
		local box = Instance.new("Frame")
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Visible = false
		box.ZIndex = 998
		box.Parent = overlayGui
	
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 1.5
		stroke.Parent = box
	
		boxesObjects[target] = box
	end
	
	local function removeBox(target)
		if boxesObjects[target] then
			boxesObjects[target]:Destroy()
			boxesObjects[target] = nil
		end
	end
	
	local function toggleBoxes(active)
		boxesOn = active
		setButtonState(boxesBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createBox(p) else removeBox(p) end
		end
	end
	
	-- Tracers
	local function createTracer(target)
		if target == localPlayer or tracersObjects[target] then return end
		local tracer = Instance.new("Frame")
		tracer.AnchorPoint = Vector2.new(0.5, 0.5)
		tracer.Size = UDim2.new(0, 0, 0, 1)
		tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tracer.BorderSizePixel = 0
		tracer.Visible = false
		tracer.ZIndex = 997
		tracer.Parent = overlayGui
		tracersObjects[target] = tracer
	end
	
	local function removeTracer(target)
		if tracersObjects[target] then
			tracersObjects[target]:Destroy()
			tracersObjects[target] = nil
		end
	end
	
	local function toggleTracers(active)
		tracersOn = active
		setButtonState(tracersBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createTracer(p) else removeTracer(p) end
		end
	end
	
	-- Helper for 2D Box bounds
	local function getScreenBox(char, cam)
		local cf, size = char:GetBoundingBox()
		local hx, hy, hz = size.X / 2, size.Y / 2, size.Z / 2
		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		local inFront = false
	
		for sx = -1, 1, 2 do
			for sy = -1, 1, 2 do
				for sz = -1, 1, 2 do
					local pos = cam:WorldToViewportPoint((cf * CFrame.new(sx * hx, sy * hy, sz * hz)).Position)
					if pos.Z > 0 then
						inFront = true
						minX = math.min(minX, pos.X)
						minY = math.min(minY, pos.Y)
						maxX = math.max(maxX, pos.X)
						maxY = math.max(maxY, pos.Y)
					end
				end
			end
		end
		if not inFront then return nil end
		return minX, minY, maxX, maxY
	end
	
	-- Button Connections
	if espBtn then espBtn.MouseButton1Click:Connect(function() toggleESP(not espOn) end) end
	if fullbrightBtn then fullbrightBtn.MouseButton1Click:Connect(function() toggleFullbright(not fullbrightOn) end) end
	if chamsBtn then chamsBtn.MouseButton1Click:Connect(function() toggleChams(not chamsOn) end) end
	if skeletonBtn then skeletonBtn.MouseButton1Click:Connect(function() toggleSkeleton(not skeletonOn) end) end
	if nametagsBtn then nametagsBtn.MouseButton1Click:Connect(function() toggleNametags(not nametagsOn) end) end
	if fovCircleBtn then fovCircleBtn.MouseButton1Click:Connect(function() toggleFOVCircle(not fovCircleOn) end) end
	if healthBtn then healthBtn.MouseButton1Click:Connect(function() toggleHealth(not healthOn) end) end
	if distanceBtn then distanceBtn.MouseButton1Click:Connect(function() toggleDistance(not distanceOn) end) end
	if boxesBtn then boxesBtn.MouseButton1Click:Connect(function() toggleBoxes(not boxesOn) end) end
	if tracersBtn then tracersBtn.MouseButton1Click:Connect(function() toggleTracers(not tracersOn) end) end
	
	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			removeESP(p); removeChams(p); removeSkeleton(p); removeNametag(p); removeHealth(p); removeDistance(p); removeBox(p); removeTracer(p)
			if espOn then createESP(p) end
			if chamsOn then createChams(p) end
			if skeletonOn then createSkeleton(p) end
			if nametagsOn then createNametag(p) end
			if healthOn then createHealth(p) end
			if distanceOn then createDistance(p) end
			if boxesOn then createBox(p) end
			if tracersOn then createTracer(p) end
		end)
	end)
	
	Players.PlayerRemoving:Connect(function(p)
		removeESP(p); removeChams(p); removeSkeleton(p); removeNametag(p); removeHealth(p); removeDistance(p); removeBox(p); removeTracer(p)
	end)
	
	-- Render Loop
	RunService.RenderStepped:Connect(function()
		local cam = Workspace.CurrentCamera
		if not cam then return end
	
		-- Skeletons
		if skeletonOn then
			for target, objs in pairs(skeletonObjects) do
				local char = getValidCharacter(target)
				if char then
					for _, ld in ipairs(objs.lines) do
						local pA, pB = char:FindFirstChild(ld.bone[1]), char:FindFirstChild(ld.bone[2])
						if pA and pB then
							local posA, posB = cam:WorldToViewportPoint(pA.Position), cam:WorldToViewportPoint(pB.Position)
							if posA.Z > 0 and posB.Z > 0 then
								ld.frame.Visible = true
								local dx, dy = posB.X - posA.X, posB.Y - posA.Y
								ld.frame.Position = UDim2.new(0, posA.X, 0, posA.Y)
								ld.frame.Size = UDim2.new(0, math.sqrt(dx*dx + dy*dy), 0, 2)
								ld.frame.Rotation = math.deg(math.atan2(dy, dx))
							else ld.frame.Visible = false end
						else ld.frame.Visible = false end
					end
				else
					for _, ld in ipairs(objs.lines) do ld.frame.Visible = false end
				end
			end
		end
	
		-- Boxes
		if boxesOn then
			for target, box in pairs(boxesObjects) do
				local char = getValidCharacter(target)
				if char then
					local minX, minY, maxX, maxY = getScreenBox(char, cam)
					if minX then
						box.Visible = true
						box.Position = UDim2.new(0, minX, 0, minY)
						box.Size = UDim2.new(0, maxX - minX, 0, maxY - minY)
					else box.Visible = false end
				else box.Visible = false end
			end
		end
	
		-- Tracers
		if tracersOn then
			local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
			for target, tracer in pairs(tracersObjects) do
				local char = getValidCharacter(target)
				if char then
					local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
					if hrp then
						local pos = cam:WorldToViewportPoint(hrp.Position)
						if pos.Z > 0 then
							tracer.Visible = true
							local targetPos = Vector2.new(pos.X, pos.Y)
							local dx, dy = targetPos.X - screenCenter.X, targetPos.Y - screenCenter.Y
							tracer.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
							tracer.Size = UDim2.new(0, math.sqrt(dx*dx + dy*dy), 0, 1)
							tracer.Rotation = math.deg(math.atan2(dy, dx))
						else tracer.Visible = false end
					else tracer.Visible = false end
				else tracer.Visible = false end
			end
		end
	
		-- Health
		if healthOn then
			for target, objs in pairs(healthObjects) do
				local char = getValidCharacter(target)
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then
						local r = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
						objs.fill.Size = UDim2.new(r, 0, 1, 0)
						objs.fill.BackgroundColor3 = r > 0.5 and Color3.fromRGB(0,255,0) or (r > 0.25 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0))
						objs.label.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
					end
				end
			end
		end
	
		-- Distance
		if distanceOn then
			local localChar = localPlayer.Character
			local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
			if localHrp then
				for target, objs in pairs(distanceObjects) do
					local char = getValidCharacter(target)
					if char then
						local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
						if hrp then
							objs.label.Text = string.format("%.0f studs", (localHrp.Position - hrp.Position).Magnitude)
						end
					end
				end
			end
		end
	end)
	
	script.Destroying:Connect(function()
		for p in pairs(espObjects) do removeESP(p) end
		for p in pairs(chamsObjects) do removeChams(p) end
		for p in pairs(skeletonObjects) do removeSkeleton(p) end
		for p in pairs(nametagObjects) do removeNametag(p) end
		for p in pairs(healthObjects) do removeHealth(p) end
		for p in pairs(distanceObjects) do removeDistance(p) end
		for p in pairs(boxesObjects) do removeBox(p) end
		for p in pairs(tracersObjects) do removeTracer(p) end
		if overlayGui then overlayGui:Destroy() end
		if highlightFolder then highlightFolder:Destroy() end
		if fovCircleGui then fovCircleGui:Destroy() end
		if fullbrightOn then toggleFullbright(false) end
	end)
end;
task.spawn(C_196);
-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.LocalScript
local function C_1ba()
local script = G2L["1ba"];
	-- Services
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	
	-- References
	local localPlayer = Players.LocalPlayer
	local visualMenu = script.Parent
	local buttonsFolder = visualMenu:FindFirstChild("buttons")
	
	-- Toggle Buttons
	local espBtn = buttonsFolder:FindFirstChild("esp")
	local fullbrightBtn = buttonsFolder:FindFirstChild("fullbright")
	local chamsBtn = buttonsFolder:FindFirstChild("chams")
	local skeletonBtn = buttonsFolder:FindFirstChild("skeleton")
	local nametagsBtn = buttonsFolder:FindFirstChild("nametags")
	local fovCircleBtn = buttonsFolder:FindFirstChild("fovcircle")
	local healthBtn = buttonsFolder:FindFirstChild("health")
	local distanceBtn = buttonsFolder:FindFirstChild("distance")
	local boxesBtn = buttonsFolder:FindFirstChild("boxes")
	local tracersBtn = buttonsFolder:FindFirstChild("tracers")
	
	-- States
	local espOn, fullbrightOn, chamsOn, skeletonOn, nametagsOn = false, false, false, false, false
	local fovCircleOn, healthOn, distanceOn, boxesOn, tracersOn = false, false, false, false, false
	
	-- Theme Colors
	local activeColor = Color3.fromRGB(255, 255, 255)
	local inactiveColor = Color3.fromRGB(40, 40, 40)
	local activeTextColor = Color3.fromRGB(30, 30, 30)
	local inactiveTextColor = Color3.fromRGB(255, 255, 255)
	
	-- Storage
	local espObjects = {}
	local chamsObjects = {}
	local skeletonObjects = {}
	local nametagObjects = {}
	local healthObjects = {}
	local distanceObjects = {}
	local boxesObjects = {}
	local tracersObjects = {}
	
	-- Overlay GUI & Folders
	local overlayGui = Instance.new("ScreenGui")
	overlayGui.Name = "VisualOverlay"
	overlayGui.IgnoreGuiInset = true
	overlayGui.ResetOnSpawn = false
	overlayGui.Parent = localPlayer:WaitForChild("PlayerGui")
	
	local highlightFolder = Instance.new("Folder")
	highlightFolder.Name = "VisualHighlights"
	highlightFolder.Parent = Workspace
	
	-- Saved Lighting State
	local savedLighting = {}
	local fovCircleGui
	
	-- Bones
	local skeletonBonesR15 = {
		{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
		{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
		{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
		{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
		{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
	}
	
	local skeletonBonesR6 = {
		{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
	}
	
	local function detectRigType(char)
		if char:FindFirstChild("UpperTorso") then return "R15"
		elseif char:FindFirstChild("Torso") then return "R6" end
		return nil
	end
	
	local function setButtonState(btn, active)
		if not btn then return end
		local icon = btn:FindFirstChildOfClass("ImageLabel")
		btn.BackgroundColor3 = active and activeColor or inactiveColor
		btn.TextColor3 = active and activeTextColor or inactiveTextColor
		if icon then icon.ImageColor3 = active and activeTextColor or inactiveTextColor end
	end
	
	local function getValidCharacter(p)
		if not p or not p.Character or not p.Character:IsDescendantOf(Workspace) then return nil end
		return p.Character
	end
	
	-- ESP
	local function createESP(target)
		if target == localPlayer or espObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local hl = Instance.new("Highlight")
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(255, 0, 0)
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
		hl.FillTransparency = 0.7
		hl.DepthScale = 0
		hl.Parent = highlightFolder
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 50)
		bb.StudsOffset = Vector3.new(0, 2, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = target.DisplayName
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		espObjects[target] = {highlight = hl, billboard = bb}
	end
	
	local function removeESP(target)
		if espObjects[target] then
			if espObjects[target].highlight then espObjects[target].highlight:Destroy() end
			if espObjects[target].billboard then espObjects[target].billboard:Destroy() end
			espObjects[target] = nil
		end
	end
	
	local function toggleESP(active)
		espOn = active
		setButtonState(espBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createESP(p) else removeESP(p) end
		end
	end
	
	-- Fullbright
	local function toggleFullbright(active)
		fullbrightOn = active
		setButtonState(fullbrightBtn, active)
		if active then
			savedLighting = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				GlobalShadows = Lighting.GlobalShadows,
				Ambient = Lighting.Ambient,
				OutdoorAmbient = Lighting.OutdoorAmbient
			}
			Lighting.Brightness = 2
			Lighting.ClockTime = 12
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
		else
			Lighting.Brightness = savedLighting.Brightness or 1
			Lighting.ClockTime = savedLighting.ClockTime or 14
			Lighting.GlobalShadows = savedLighting.GlobalShadows ~= false
			Lighting.Ambient = savedLighting.Ambient or Color3.new(0,0,0)
			Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient or Color3.new(0,0,0)
		end
	end
	
	-- Chams
	local function createChams(target)
		if target == localPlayer or chamsObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local hl = Instance.new("Highlight")
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(0, 255, 0)
		hl.OutlineColor = Color3.fromRGB(0, 0, 0)
		hl.FillTransparency = 0.5
		hl.DepthScale = 1
		hl.Parent = highlightFolder
	
		chamsObjects[target] = hl
	end
	
	local function removeChams(target)
		if chamsObjects[target] then
			chamsObjects[target]:Destroy()
			chamsObjects[target] = nil
		end
	end
	
	local function toggleChams(active)
		chamsOn = active
		setButtonState(chamsBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createChams(p) else removeChams(p) end
		end
	end
	
	-- Skeleton
	local function createSkeleton(target)
		if target == localPlayer or skeletonObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local rig = detectRigType(char)
		if not rig then return end
		local bones = rig == "R15" and skeletonBonesR15 or skeletonBonesR6
	
		local folder = Instance.new("Folder")
		folder.Name = "Skeleton_" .. target.Name
		folder.Parent = overlayGui
	
		local lines = {}
		for _, bone in ipairs(bones) do
			local frame = Instance.new("Frame")
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Size = UDim2.new(0, 0, 0, 2)
			frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame.BorderSizePixel = 0
			frame.ZIndex = 999
			frame.Visible = false
			frame.Parent = folder
			table.insert(lines, {frame = frame, bone = bone})
		end
	
		skeletonObjects[target] = {folder = folder, lines = lines}
	end
	
	local function removeSkeleton(target)
		if skeletonObjects[target] then
			if skeletonObjects[target].folder then skeletonObjects[target].folder:Destroy() end
			skeletonObjects[target] = nil
		end
	end
	
	local function toggleSkeleton(active)
		skeletonOn = active
		setButtonState(skeletonBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createSkeleton(p) else removeSkeleton(p) end
		end
	end
	
	-- Nametags
	local function createNametag(target)
		if target == localPlayer or nametagObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 30)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = target.DisplayName
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		nametagObjects[target] = bb
	end
	
	local function removeNametag(target)
		if nametagObjects[target] then
			nametagObjects[target]:Destroy()
			nametagObjects[target] = nil
		end
	end
	
	local function toggleNametags(active)
		nametagsOn = active
		setButtonState(nametagsBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createNametag(p) else removeNametag(p) end
		end
	end
	
	-- FOV Circle
	local function toggleFOVCircle(active)
		fovCircleOn = active
		setButtonState(fovCircleBtn, active)
		if active then
			fovCircleGui = Instance.new("ScreenGui")
			fovCircleGui.IgnoreGuiInset = true
			fovCircleGui.ResetOnSpawn = false
			fovCircleGui.Parent = localPlayer:WaitForChild("PlayerGui")
	
			local circle = Instance.new("Frame")
			circle.AnchorPoint = Vector2.new(0.5, 0.5)
			circle.Size = UDim2.new(0, 200, 0, 200)
			circle.Position = UDim2.new(0.5, 0, 0.5, 0)
			circle.BackgroundTransparency = 1
			circle.Parent = fovCircleGui
	
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = circle
	
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(255, 255, 255)
			stroke.Thickness = 1.5
			stroke.Transparency = 0.3
			stroke.Parent = circle
		else
			if fovCircleGui then fovCircleGui:Destroy() end
		end
	end
	
	-- Health
	local function createHealth(target)
		if target == localPlayer or healthObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 100, 0, 30)
		bb.StudsOffset = Vector3.new(0, 3, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 0, 12)
		bg.Position = UDim2.new(0, 0, 0.5, 0)
		bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		bg.BorderSizePixel = 0
		bg.Parent = bb
	
		local bgCorner = Instance.new("UICorner")
		bgCorner.CornerRadius = UDim.new(0, 3)
		bgCorner.Parent = bg
	
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(1, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		fill.BorderSizePixel = 0
		fill.Parent = bg
	
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(0, 3)
		fillCorner.Parent = fill
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 14)
		label.Position = UDim2.new(0, 0, 0, -2)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		healthObjects[target] = {billboard = bb, fill = fill, label = label}
	end
	
	local function removeHealth(target)
		if healthObjects[target] then
			if healthObjects[target].billboard then healthObjects[target].billboard:Destroy() end
			healthObjects[target] = nil
		end
	end
	
	local function toggleHealth(active)
		healthOn = active
		setButtonState(healthBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createHealth(p) else removeHealth(p) end
		end
	end
	
	-- Distance
	local function createDistance(target)
		if target == localPlayer or distanceObjects[target] then return end
		local char = getValidCharacter(target)
		if not char then return end
	
		local bb = Instance.new("BillboardGui")
		bb.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
		bb.Size = UDim2.new(0, 200, 0, 30)
		bb.StudsOffset = Vector3.new(0, -3, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = bb
	
		distanceObjects[target] = {billboard = bb, label = label}
	end
	
	local function removeDistance(target)
		if distanceObjects[target] then
			if distanceObjects[target].billboard then distanceObjects[target].billboard:Destroy() end
			distanceObjects[target] = nil
		end
	end
	
	local function toggleDistance(active)
		distanceOn = active
		setButtonState(distanceBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createDistance(p) else removeDistance(p) end
		end
	end
	
	-- Boxes
	local function createBox(target)
		if target == localPlayer or boxesObjects[target] then return end
		local box = Instance.new("Frame")
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Visible = false
		box.ZIndex = 998
		box.Parent = overlayGui
	
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 1.5
		stroke.Parent = box
	
		boxesObjects[target] = box
	end
	
	local function removeBox(target)
		if boxesObjects[target] then
			boxesObjects[target]:Destroy()
			boxesObjects[target] = nil
		end
	end
	
	local function toggleBoxes(active)
		boxesOn = active
		setButtonState(boxesBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createBox(p) else removeBox(p) end
		end
	end
	
	-- Tracers
	local function createTracer(target)
		if target == localPlayer or tracersObjects[target] then return end
		local tracer = Instance.new("Frame")
		tracer.AnchorPoint = Vector2.new(0.5, 0.5)
		tracer.Size = UDim2.new(0, 0, 0, 1)
		tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tracer.BorderSizePixel = 0
		tracer.Visible = false
		tracer.ZIndex = 997
		tracer.Parent = overlayGui
		tracersObjects[target] = tracer
	end
	
	local function removeTracer(target)
		if tracersObjects[target] then
			tracersObjects[target]:Destroy()
			tracersObjects[target] = nil
		end
	end
	
	local function toggleTracers(active)
		tracersOn = active
		setButtonState(tracersBtn, active)
		for _, p in Players:GetPlayers() do
			if active then createTracer(p) else removeTracer(p) end
		end
	end
	
	-- Helper for 2D Box bounds
	local function getScreenBox(char, cam)
		local cf, size = char:GetBoundingBox()
		local hx, hy, hz = size.X / 2, size.Y / 2, size.Z / 2
		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		local inFront = false
	
		for sx = -1, 1, 2 do
			for sy = -1, 1, 2 do
				for sz = -1, 1, 2 do
					local pos = cam:WorldToViewportPoint((cf * CFrame.new(sx * hx, sy * hy, sz * hz)).Position)
					if pos.Z > 0 then
						inFront = true
						minX = math.min(minX, pos.X)
						minY = math.min(minY, pos.Y)
						maxX = math.max(maxX, pos.X)
						maxY = math.max(maxY, pos.Y)
					end
				end
			end
		end
		if not inFront then return nil end
		return minX, minY, maxX, maxY
	end
	
	-- Button Connections
	if espBtn then espBtn.MouseButton1Click:Connect(function() toggleESP(not espOn) end) end
	if fullbrightBtn then fullbrightBtn.MouseButton1Click:Connect(function() toggleFullbright(not fullbrightOn) end) end
	if chamsBtn then chamsBtn.MouseButton1Click:Connect(function() toggleChams(not chamsOn) end) end
	if skeletonBtn then skeletonBtn.MouseButton1Click:Connect(function() toggleSkeleton(not skeletonOn) end) end
	if nametagsBtn then nametagsBtn.MouseButton1Click:Connect(function() toggleNametags(not nametagsOn) end) end
	if fovCircleBtn then fovCircleBtn.MouseButton1Click:Connect(function() toggleFOVCircle(not fovCircleOn) end) end
	if healthBtn then healthBtn.MouseButton1Click:Connect(function() toggleHealth(not healthOn) end) end
	if distanceBtn then distanceBtn.MouseButton1Click:Connect(function() toggleDistance(not distanceOn) end) end
	if boxesBtn then boxesBtn.MouseButton1Click:Connect(function() toggleBoxes(not boxesOn) end) end
	if tracersBtn then tracersBtn.MouseButton1Click:Connect(function() toggleTracers(not tracersOn) end) end
	
	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			removeESP(p); removeChams(p); removeSkeleton(p); removeNametag(p); removeHealth(p); removeDistance(p); removeBox(p); removeTracer(p)
			if espOn then createESP(p) end
			if chamsOn then createChams(p) end
			if skeletonOn then createSkeleton(p) end
			if nametagsOn then createNametag(p) end
			if healthOn then createHealth(p) end
			if distanceOn then createDistance(p) end
			if boxesOn then createBox(p) end
			if tracersOn then createTracer(p) end
		end)
	end)
	
	Players.PlayerRemoving:Connect(function(p)
		removeESP(p); removeChams(p); removeSkeleton(p); removeNametag(p); removeHealth(p); removeDistance(p); removeBox(p); removeTracer(p)
	end)
	
	-- Render Loop
	RunService.RenderStepped:Connect(function()
		local cam = Workspace.CurrentCamera
		if not cam then return end
	
		-- Skeletons
		if skeletonOn then
			for target, objs in pairs(skeletonObjects) do
				local char = getValidCharacter(target)
				if char then
					for _, ld in ipairs(objs.lines) do
						local pA, pB = char:FindFirstChild(ld.bone[1]), char:FindFirstChild(ld.bone[2])
						if pA and pB then
							local posA, posB = cam:WorldToViewportPoint(pA.Position), cam:WorldToViewportPoint(pB.Position)
							if posA.Z > 0 and posB.Z > 0 then
								ld.frame.Visible = true
								local dx, dy = posB.X - posA.X, posB.Y - posA.Y
								ld.frame.Position = UDim2.new(0, posA.X, 0, posA.Y)
								ld.frame.Size = UDim2.new(0, math.sqrt(dx*dx + dy*dy), 0, 2)
								ld.frame.Rotation = math.deg(math.atan2(dy, dx))
							else ld.frame.Visible = false end
						else ld.frame.Visible = false end
					end
				else
					for _, ld in ipairs(objs.lines) do ld.frame.Visible = false end
				end
			end
		end
	
		-- Boxes
		if boxesOn then
			for target, box in pairs(boxesObjects) do
				local char = getValidCharacter(target)
				if char then
					local minX, minY, maxX, maxY = getScreenBox(char, cam)
					if minX then
						box.Visible = true
						box.Position = UDim2.new(0, minX, 0, minY)
						box.Size = UDim2.new(0, maxX - minX, 0, maxY - minY)
					else box.Visible = false end
				else box.Visible = false end
			end
		end
	
		-- Tracers
		if tracersOn then
			local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
			for target, tracer in pairs(tracersObjects) do
				local char = getValidCharacter(target)
				if char then
					local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
					if hrp then
						local pos = cam:WorldToViewportPoint(hrp.Position)
						if pos.Z > 0 then
							tracer.Visible = true
							local targetPos = Vector2.new(pos.X, pos.Y)
							local dx, dy = targetPos.X - screenCenter.X, targetPos.Y - screenCenter.Y
							tracer.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
							tracer.Size = UDim2.new(0, math.sqrt(dx*dx + dy*dy), 0, 1)
							tracer.Rotation = math.deg(math.atan2(dy, dx))
						else tracer.Visible = false end
					else tracer.Visible = false end
				else tracer.Visible = false end
			end
		end
	
		-- Health
		if healthOn then
			for target, objs in pairs(healthObjects) do
				local char = getValidCharacter(target)
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then
						local r = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
						objs.fill.Size = UDim2.new(r, 0, 1, 0)
						objs.fill.BackgroundColor3 = r > 0.5 and Color3.fromRGB(0,255,0) or (r > 0.25 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0))
						objs.label.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
					end
				end
			end
		end
	
		-- Distance
		if distanceOn then
			local localChar = localPlayer.Character
			local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
			if localHrp then
				for target, objs in pairs(distanceObjects) do
					local char = getValidCharacter(target)
					if char then
						local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
						if hrp then
							objs.label.Text = string.format("%.0f studs", (localHrp.Position - hrp.Position).Magnitude)
						end
					end
				end
			end
		end
	end)
	
	script.Destroying:Connect(function()
		for p in pairs(espObjects) do removeESP(p) end
		for p in pairs(chamsObjects) do removeChams(p) end
		for p in pairs(skeletonObjects) do removeSkeleton(p) end
		for p in pairs(nametagObjects) do removeNametag(p) end
		for p in pairs(healthObjects) do removeHealth(p) end
		for p in pairs(distanceObjects) do removeDistance(p) end
		for p in pairs(boxesObjects) do removeBox(p) end
		for p in pairs(tracersObjects) do removeTracer(p) end
		if overlayGui then overlayGui:Destroy() end
		if highlightFolder then highlightFolder:Destroy() end
		if fovCircleGui then fovCircleGui:Destroy() end
		if fullbrightOn then toggleFullbright(false) end
	end)
end;
task.spawn(C_1ba);
-- StarterGui.zerohub.interface.main.tabs.universal.ScrollingFrame.misc.buttons.LocalScript
local function C_1be()
local script = G2L["1be"];
	-- Misc tab toggle buttons (antiafk, esp, instantpp, antifling, fullbright)
	-- Visual states:
	--   Enabled:  BackgroundColor3 = 255,255,255 | icon ImageColor3 = 0,0,0 | TextColor3 = 0,0,0
	--   Disabled: BackgroundColor3 = original      | icon ImageColor3 = 255,255,255 | TextColor3 = 255,255,255
	
	local Players = game:GetService("Players")
	local Lighting = game:GetService("Lighting")
	local RunService = game:GetService("RunService")
	
	local LocalPlayer = Players.LocalPlayer
	
	local buttonsFolder = script.Parent
	
	-- ============ MODULE LOGIC ============
	
	local Modules = {}
	
	-- ANTI AFK: cancels the 20 minute idle kick
	local antiAfkConnection
	Modules.antiafk = {
		enable = function()
			local VirtualUser = game:GetService("VirtualUser")
			antiAfkConnection = LocalPlayer.Idled:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end,
		disable = function()
			if antiAfkConnection then
				antiAfkConnection:Disconnect()
				antiAfkConnection = nil
			end
		end,
	}
	
	-- ESP: puts a Highlight box around every other player
	local espFolder = Instance.new("Folder")
	espFolder.Name = "ZerohubESP"
	espFolder.Parent = workspace
	
	local espConnections = {}
	
	local function addEsp(player)
		if player == LocalPlayer then return end
		local function onCharacterAdded(character)
			if not character:FindFirstChild("ZerohubESP") then
				local highlight = Instance.new("Highlight")
				highlight.Name = "ZerohubESP"
				highlight.FillColor = Color3.fromRGB(255, 255, 255)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.5
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Adornee = character
				highlight.Parent = espFolder
			end
		end
		if player.Character then onCharacterAdded(player.Character) end
		table.insert(espConnections, player.CharacterAdded:Connect(onCharacterAdded))
	end
	
	Modules.esp = {
		enable = function()
			for _, player in Players:GetPlayers() do
				addEsp(player)
			end
			table.insert(espConnections, Players.PlayerAdded:Connect(addEsp))
		end,
		disable = function()
			for _, connection in espConnections do
				connection:Disconnect()
			end
			table.clear(espConnections)
			espFolder:ClearAllChildren()
		end,
	}
	
	-- INSTANTPP: sets all ProximityPrompts to trigger instantly (no hold time)
	local instantPpConnection
	local instantPpPrompts = {}
	
	local function makePromptInstant(prompt)
		if prompt:IsA("ProximityPrompt") then
			if not instantPpPrompts[prompt] then
				instantPpPrompts[prompt] = prompt.HoldDuration
			end
			prompt.HoldDuration = 0
		end
	end
	
	Modules.instantpp = {
		enable = function()
			for _, descendant in workspace:GetDescendants() do
				makePromptInstant(descendant)
			end
			instantPpConnection = workspace.DescendantAdded:Connect(makePromptInstant)
		end,
		disable = function()
			if instantPpConnection then
				instantPpConnection:Disconnect()
				instantPpConnection = nil
			end
			-- Restore the original hold duration for every prompt we changed
			for prompt, originalDuration in instantPpPrompts do
				if prompt then
					prompt.HoldDuration = originalDuration
				end
			end
			table.clear(instantPpPrompts)
		end,
	}
	
	-- ANTI FLING: zeroes out abnormal velocity on your character
	local antiFlingConnection
	Modules.antifling = {
		enable = function()
			antiFlingConnection = RunService.Heartbeat:Connect(function()
				local character = LocalPlayer.Character
				local hrp = character and character:FindFirstChild("HumanoidRootPart")
				if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
					hrp.AssemblyLinearVelocity = Vector3.zero
				end
			end)
		end,
		disable = function()
			if antiFlingConnection then
				antiFlingConnection:Disconnect()
				antiFlingConnection = nil
			end
		end,
	}
	
	-- FULLBRIGHT: max brightness, no shadows/fog
	local savedLighting = {}
	Modules.fullbright = {
		enable = function()
			savedLighting.Brightness = Lighting.Brightness
			savedLighting.Ambient = Lighting.Ambient
			savedLighting.OutdoorAmbient = Lighting.OutdoorAmbient
			savedLighting.ClockTime = Lighting.ClockTime
			savedLighting.FogEnd = Lighting.FogEnd
			savedLighting.GlobalShadows = Lighting.GlobalShadows
	
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
		end,
		disable = function()
			Lighting.Brightness = savedLighting.Brightness
			Lighting.Ambient = savedLighting.Ambient
			Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
			Lighting.ClockTime = savedLighting.ClockTime
			Lighting.FogEnd = savedLighting.FogEnd
			Lighting.GlobalShadows = savedLighting.GlobalShadows
		end,
	}
	
	-- ============ TOGGLE VISUALS ============
	
	local WHITE = Color3.fromRGB(255, 255, 255)
	local BLACK = Color3.fromRGB(0, 0, 0)
	
	local function setButtonState(button, enabled)
		local icon = button:FindFirstChildOfClass("ImageLabel")
		if enabled then
			button.BackgroundColor3 = WHITE
			button.TextColor3 = BLACK
			if icon then icon.ImageColor3 = BLACK end
		else
			button.BackgroundColor3 = button:GetAttribute("OriginalColor") or Color3.fromRGB(40, 40, 40)
			button.TextColor3 = WHITE
			if icon then icon.ImageColor3 = WHITE end
		end
	end
	
	local function setupButton(button)
		local moduleName = string.lower(button.Name)
		local module = Modules[moduleName]
		if not module then return end
	
		-- Remember the original background color so we can restore it on disable
		button:SetAttribute("OriginalColor", button.BackgroundColor3)
		button:SetAttribute("Enabled", false)
		button.AutoButtonColor = false -- stops Roblox from tinting the background on hover
	
		setButtonState(button, false) -- start in the disabled look
	
		button.MouseButton1Click:Connect(function()
			local enabled = not button:GetAttribute("Enabled")
			button:SetAttribute("Enabled", enabled)
			setButtonState(button, enabled)
	
			local ok, err
			if enabled then
				ok, err = pcall(module.enable)
			else
				ok, err = pcall(module.disable)
			end
			if not ok then
				warn("[zerohub] " .. moduleName .. " error: " .. tostring(err))
			end
		end)
	end
	
	for _, child in buttonsFolder:GetChildren() do
		if child:IsA("TextButton") then
			setupButton(child)
		end
	end
	
end;
task.spawn(C_1be);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.ai.ScrollingFrame.setapikey.TextBox.LocalScript
local function C_1d9()
local script = G2L["1d9"];
	-- References
	local textbox = script.Parent
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local geminiapikey = storage and storage:WaitForChild("geminiapikey")
	
	-- Display existing key
	if geminiapikey and geminiapikey.Value ~= "" then
		textbox.Text = geminiapikey.Value
	end
	
	if geminiapikey then
		geminiapikey.Changed:Connect(function(newval)
			if textbox.Text ~= newval then
				textbox.Text = newval
			end
		end)
	end
	
	-- Save key on enter or focus lost
	textbox.FocusLost:Connect(function(enterpressed)
		local cleanedkey = textbox.Text:match("^%s*(.-)%s*$") or ""
		if geminiapikey then
			geminiapikey.Value = cleanedkey
		end
		if cleanedkey ~= "" then
			if _G.zerohubnotificationsystem_success then
				_G.zerohubnotificationsystem_success("API Key Saved", "Gemini API key updated successfully")
			end
		end
	end)
	
end;
task.spawn(C_1d9);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.anim
local function C_1e6()
local script = G2L["1e6"];
	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local imageLabel = button:WaitForChild("ImageLabel", 3)
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function getColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			return Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255)
		else
			return Color3.fromRGB(228, 231, 235), Color3.fromRGB(216, 220, 226), Color3.fromRGB(107, 114, 128), Color3.fromRGB(17, 24, 39)
		end
	end
	
	local isHovered = false
	
	local function applyHoverState()
		local normalBg, hoverBg, normalText, hoverText = getColors()
		local targetBg = isHovered and hoverBg or normalBg
		local targetText = isHovered and hoverText or normalText
	
		TweenService:Create(button, info, {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if imageLabel then
			TweenService:Create(imageLabel, info, {
				ImageColor3 = targetText
			}):Play()
		end
	end
	
	button.MouseEnter:Connect(function()
		isHovered = true
		applyHoverState()
	end)
	
	button.MouseLeave:Connect(function()
		isHovered = false
		applyHoverState()
	end)
	
	if darktheme then
		darktheme.Changed:Connect(function()
			applyHoverState()
		end)
	end
	
end;
task.spawn(C_1e6);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.lighttheme.TextButton.LocalScript
local function C_1e7()
local script = G2L["1e7"];
	-- Theme toggle button trigger
	local button = script.Parent
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	button.MouseButton1Click:Connect(function()
		if darktheme then
			darktheme.Value = not darktheme.Value
		end
	end)
	
end;
task.spawn(C_1e7);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.rain.LocalScript
local function C_1ec()
local script = G2L["1ec"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40, 40, 40)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UIRainEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 100
		container.Parent = mainFrame
	end
	
	local function spawnDrop()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local drop = Instance.new("Frame")
		drop.Size = UDim2.new(0, 1, 0, math.random(12, 22))
		drop.BackgroundColor3 = Color3.fromRGB(200, 225, 255)
		drop.BackgroundTransparency = math.random(35, 65) / 100
		drop.BorderSizePixel = 0
		drop.Rotation = -25
		drop.ZIndex = 100
	
		local startX = math.random(-50, size.X)
		drop.Position = UDim2.new(0, startX, 0, -20)
		drop.Parent = container
	
		local travelTime = math.random(30, 50) / 100
		local tween = tweenService:Create(drop, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, startX + (size.Y * 0.45), 0, size.Y + 30),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() drop:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			connection = runService.RenderStepped:Connect(function()
				spawnDrop()
				spawnDrop()
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_1ec);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.sakura.LocalScript
local function C_1f0()
local script = G2L["1f0"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40, 40, 40)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	
	local PETAL_COLORS = {
		Color3.fromRGB(255, 183, 197),
		Color3.fromRGB(255, 192, 203),
		Color3.fromRGB(255, 209, 220),
		Color3.fromRGB(248, 200, 220),
		Color3.fromRGB(255, 105, 180)
	}
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UISakuraEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 100
		container.Parent = mainFrame
	end
	
	local function spawnPetal()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local petal = Instance.new("Frame")
		petal.Size = UDim2.new(0, math.random(8, 14), 0, math.random(12, 18))
		petal.BackgroundColor3 = PETAL_COLORS[math.random(#PETAL_COLORS)]
		petal.BackgroundTransparency = math.random(10, 35) / 100
		petal.BorderSizePixel = 0
		petal.Rotation = math.random(0, 360)
		petal.ZIndex = 100
	
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0.6, 0)
		corner.Parent = petal
	
		local startX = math.random(-30, size.X + 30)
		petal.Position = UDim2.new(0, startX, 0, -20)
		petal.Parent = container
	
		local fallTime = math.random(350, 600) / 100
		local spin = (math.random() > 0.5 and 1 or -1) * math.random(180, 540)
	
		local tween = tweenService:Create(petal, TweenInfo.new(fallTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = UDim2.new(0, startX + math.random(-80, 100), 0, size.Y + 25),
			Rotation = petal.Rotation + spin,
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() petal:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			local timer = 0
			connection = runService.RenderStepped:Connect(function(dt)
				timer += dt
				if timer >= 0.12 then
					timer = 0
					spawnPetal()
				end
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_1f0);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.stars.LocalScript
local function C_1f4()
local script = G2L["1f4"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40,40,40)
	local ACTIVE_TEXT = Color3.fromRGB(255,255,255)
	local INACTIVE_BG = Color3.fromRGB(30,30,30)
	local INACTIVE_TEXT = Color3.fromRGB(100,100,100)
	
	local SPARKLE_ICONS = { "✦", "✧", "★", "✨", "✺", "✶" }
	
	local SPARKLE_COLORS = {
		Color3.fromRGB(255, 223, 128),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(200, 230, 255),
		Color3.fromRGB(255, 192, 230),
		Color3.fromRGB(220, 180, 255)
	}
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UISparkleEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 80
		container.Parent = mainFrame
	end
	
	local function spawnSparkle()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local baseSize = math.random(10, 18)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, baseSize, 0, baseSize)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.SourceSansBold
		label.TextSize = baseSize
		label.Text = SPARKLE_ICONS[math.random(#SPARKLE_ICONS)]
		label.TextColor3 = SPARKLE_COLORS[math.random(#SPARKLE_COLORS)]
		label.TextTransparency = 1
		label.Rotation = math.random(-30, 30)
		label.ZIndex = 80
	
		local startX = math.random(10, math.max(10, size.X - 20))
		local startY = math.random(10, math.max(10, size.Y - 20))
		label.Position = UDim2.new(0, startX, 0, startY)
		label.Parent = container
	
		local lifetime = math.random(120, 220) / 100
		local floatDist = math.random(15, 35)
	
		local fadeIn = tweenService:Create(label, TweenInfo.new(lifetime * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = math.random(0, 20) / 100,
			Position = UDim2.new(0, startX, 0, startY - floatDist * 0.4),
			Rotation = label.Rotation + 15,
			Size = UDim2.new(0, baseSize + 4, 0, baseSize + 4)
		})
	
		local fadeOut = tweenService:Create(label, TweenInfo.new(lifetime * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1,
			Position = UDim2.new(0, startX + math.random(-10, 10), 0, startY - floatDist),
			Rotation = label.Rotation + math.random(-45, 45),
			Size = UDim2.new(0, baseSize - 2, 0, baseSize - 2)
		})
	
		fadeIn:Play()
		fadeIn.Completed:Connect(function() fadeOut:Play() end)
		fadeOut.Completed:Connect(function() label:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			local timer = 0
			connection = runService.RenderStepped:Connect(function(dt)
				timer += dt
				if timer >= 0.08 then
					timer = 0
					spawnSparkle()
				end
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_1f4);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.snow.LocalScript
local function C_1f8()
local script = G2L["1f8"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40,40,40)
	local ACTIVE_TEXT = Color3.fromRGB(255,255,255)
	local INACTIVE_BG = Color3.fromRGB(30,30,30)
	local INACTIVE_TEXT = Color3.fromRGB(100,100,100)
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UISnowEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 100
		container.Parent = mainFrame
	end
	
	local function spawnFlake()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local flakeSize = math.random(3, 6)
		local flake = Instance.new("Frame")
		flake.Size = UDim2.new(0, flakeSize, 0, flakeSize)
		flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		flake.BackgroundTransparency = math.random(10, 40) / 100
		flake.BorderSizePixel = 0
		flake.ZIndex = 100
	
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = flake
	
		local startX = math.random(-20, size.X + 20)
		flake.Position = UDim2.new(0, startX, 0, -10)
		flake.Parent = container
	
		local fallTime = math.random(250, 450) / 100
	
		local tween = tweenService:Create(flake, TweenInfo.new(fallTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, startX + math.random(-40, 60), 0, size.Y + 15),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() flake:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			local timer = 0
			connection = runService.RenderStepped:Connect(function(dt)
				timer += dt
				if timer >= 0.08 then
					timer = 0
					spawnFlake()
				end
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_1f8);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.glitch.LocalScript
local function C_1fd()
local script = G2L["1fd"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40, 40, 40)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	
	local GLITCH_COLORS = {
		Color3.fromRGB(0, 255, 240),
		Color3.fromRGB(255, 0, 115),
		Color3.fromRGB(255, 230, 0),
		Color3.fromRGB(0, 150, 255),
		Color3.fromRGB(255, 255, 255)
	}
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UIGlitchEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 90
		container.Parent = mainFrame
	end
	
	local function spawnGlitchLine()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local thickness = math.random(1, 4)
		local width = size.X * (math.random(20, 95) / 100)
	
		local line = Instance.new("Frame")
		line.Size = UDim2.new(0, width, 0, thickness)
		line.BackgroundColor3 = GLITCH_COLORS[math.random(#GLITCH_COLORS)]
		line.BackgroundTransparency = math.random(10, 30) / 100
		line.BorderSizePixel = 0
		line.ZIndex = 90
	
		local startX = math.random(-10, math.floor(size.X - width + 10))
		local startY = math.random(5, math.floor(size.Y - thickness))
		line.Position = UDim2.new(0, startX, 0, startY)
		line.Parent = container
	
		local duration = math.random(4, 12) / 100
		local tween = tweenService:Create(line, TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, startX + math.random(-25, 25), 0, startY),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() line:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			local timer = 0
			connection = runService.RenderStepped:Connect(function(dt)
				timer += dt
				if timer >= math.random(3, 8) / 100 then
					timer = 0
					for _ = 1, math.random(1, 3) do
						spawnGlitchLine()
					end
				end
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_1fd);
-- StarterGui.zerohub.interface.main.tabs.settings.teleporttabs.customize.UIEFFECTSPLEASEBURNMEDOWN.matrix.LocalScript
local function C_201()
local script = G2L["201"];
	local button = script.Parent
	local imageLabel = button:FindFirstChild("ImageLabel")
	local runService = game:GetService("RunService")
	local tweenService = game:GetService("TweenService")
	
	local mainFrame = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.main
	
	local active = false
	local connection
	local container
	
	local ACTIVE_BG = Color3.fromRGB(40, 40, 40)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	
	local GLYPHS = {
		"ア","イ","ウ","エ","オ","カ","キ","ク","ケ","コ",
		"サ","シ","ス","セ","ソ","タ","チ","ツ","テ","ト",
		"ナ","ニ","ヌ","ネ","ノ","ハ","ヒ","フ","ヘ","ホ",
		"0","1","2","3","4","5","6","7","8","9","X","Z","#","%","*","&"
	}
	
	local function refreshVisuals()
		local bgColor = active and ACTIVE_BG or INACTIVE_BG
		local textColor = active and ACTIVE_TEXT or INACTIVE_TEXT
		button.BackgroundColor3 = bgColor
		button.TextColor3 = textColor
		if imageLabel then imageLabel.ImageColor3 = textColor end
	end
	
	local function createContainer()
		container = Instance.new("Frame")
		container.Name = "UIMatrixEffect"
		container.BackgroundTransparency = 1
		container.Size = UDim2.new(1, 0, 1, 0)
		container.ClipsDescendants = true
		container.ZIndex = 50
		container.Parent = mainFrame
	end
	
	local function spawnGlyph()
		if not container or not mainFrame then return end
		local size = mainFrame.AbsoluteSize
		if size.X == 0 or size.Y == 0 then return end
	
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 14, 0, 14)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 12
		label.Text = GLYPHS[math.random(#GLYPHS)]
		label.ZIndex = 50
	
		if math.random() < 0.20 then
			label.TextColor3 = Color3.fromRGB(220, 255, 220)
			label.TextTransparency = 0.05
		else
			label.TextColor3 = Color3.fromRGB(0, 255, 100)
			label.TextTransparency = math.random(15, 35) / 100
		end
	
		local colStep = 14
		local colIndex = math.random(0, math.max(1, math.floor(size.X / colStep) - 1))
		local startX = colIndex * colStep + 2
	
		label.Position = UDim2.new(0, startX, 0, -15)
		label.Parent = container
	
		local fallTime = math.random(140, 250) / 100
		local tween = tweenService:Create(label, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, startX, 0, size.Y + 15),
			TextTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() label:Destroy() end)
	end
	
	local function toggle()
		active = not active
	
		if active then
			createContainer()
			local timer = 0
			connection = runService.RenderStepped:Connect(function(dt)
				timer += dt
				if timer >= 0.04 then
					timer = 0
					spawnGlyph()
					spawnGlyph()
				end
			end)
		else
			if connection then connection:Disconnect() connection = nil end
			if container then container:Destroy() container = nil end
		end
	
		refreshVisuals()
	end
	
	refreshVisuals()
	button.Activated:Connect(toggle)
end;
task.spawn(C_201);
-- StarterGui.zerohub.interface.main.tabs.settings.tabsw
local function C_204()
local script = G2L["204"];
	local TweenService = game:GetService("TweenService")
	
	local home = script.Parent
	local topButtons = home:WaitForChild("top")
	local hometabs = home:WaitForChild("teleporttabs")
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	local TWEEN_TIME = 0.35
	local SLIDE_EASE = Enum.EasingStyle.Back
	local COLOR_EASE = Enum.EasingStyle.Quad
	local EASE_DIR = Enum.EasingDirection.Out
	
	local ACTIVE_BG = Color3.fromRGB(60, 60, 60)
	local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
	local ACTIVE_ICON = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(30, 30, 30)
	local INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
	local INACTIVE_ICON = Color3.fromRGB(100, 100, 100)
	
	local tabNames = {"ai", "customize"}
	local currentTab = tabNames[1]
	
	local function updateColors()
		local isDark = not darktheme or darktheme.Value
		if isDark then
			ACTIVE_BG = Color3.fromRGB(60, 60, 60)
			ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
			ACTIVE_ICON = Color3.fromRGB(255, 255, 255)
			INACTIVE_BG = Color3.fromRGB(30, 30, 30)
			INACTIVE_TEXT = Color3.fromRGB(100, 100, 100)
			INACTIVE_ICON = Color3.fromRGB(100, 100, 100)
		else
			ACTIVE_BG = Color3.fromRGB(209, 213, 219)
			ACTIVE_TEXT = Color3.fromRGB(17, 24, 39)
			ACTIVE_ICON = Color3.fromRGB(17, 24, 39)
			INACTIVE_BG = Color3.fromRGB(228, 231, 235)
			INACTIVE_TEXT = Color3.fromRGB(107, 114, 128)
			INACTIVE_ICON = Color3.fromRGB(107, 114, 128)
		end
		for _, name in ipairs(tabNames) do
			local button = topButtons:FindFirstChild(name)
			if button then
				local isActive = (name == currentTab)
				local icon = button:FindFirstChild("ImageLabel")
				local info = TweenInfo.new(TWEEN_TIME, COLOR_EASE, EASE_DIR)
				TweenService:Create(button, info, {
					BackgroundColor3 = isActive and ACTIVE_BG or INACTIVE_BG,
					TextColor3 = isActive and ACTIVE_TEXT or INACTIVE_TEXT
				}):Play()
				if icon then
					TweenService:Create(icon, info, {
						ImageColor3 = isActive and ACTIVE_ICON or INACTIVE_ICON
					}):Play()
				end
			end
		end
	end
	
	local function tweenColor(obj, prop, targetColor)
	    if not obj then return end
	    local info = TweenInfo.new(TWEEN_TIME, COLOR_EASE, EASE_DIR)
	    TweenService:Create(obj, info, {[prop] = targetColor}):Play()
	end
	
	local function getOriginalPos(panel)
	    local stored = panel:GetAttribute("OriginalPos")
	    if stored then
	        return stored
	    end
	    local pos = panel.Position
	    local ud2 = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
	    panel:SetAttribute("OriginalPos", ud2)
	    return ud2
	end
	
	local function offsetPos(originalPos, dx)
	    return UDim2.new(originalPos.X.Scale, originalPos.X.Offset + dx, originalPos.Y.Scale, originalPos.Y.Offset)
	end
	
	local function getSlideDistance()
	    return home.Size.X.Offset
	end
	
	local function tweenPanel(panel, show)
	    if not panel then return end
	    local originalPos = getOriginalPos(panel)
	    local slideDist = getSlideDistance()
	    local info = TweenInfo.new(TWEEN_TIME, SLIDE_EASE, show and Enum.EasingDirection.Out or Enum.EasingDirection.In)
	    if show then
	        panel.Visible = true
	        panel.Position = offsetPos(originalPos, slideDist)
	        TweenService:Create(panel, info, {Position = originalPos}):Play()
	    else
	        local tween = TweenService:Create(panel, info, {Position = offsetPos(originalPos, -slideDist)})
	        tween:Play()
	        tween.Completed:Connect(function()
	            panel.Visible = false
	            panel.Position = originalPos
	        end)
	    end
	end
	
	local function setActive(tabName)
	    currentTab = tabName
	    for _, name in ipairs(tabNames) do
	        local button = topButtons:FindFirstChild(name)
	        local panel = hometabs:FindFirstChild(name)
	        local isActive = (name == tabName)
	
	        if button then
	            local icon = button:FindFirstChild("ImageLabel")
	            tweenColor(button, "BackgroundColor3", isActive and ACTIVE_BG or INACTIVE_BG)
	            tweenColor(button, "TextColor3", isActive and ACTIVE_TEXT or INACTIVE_TEXT)
	            if icon then tweenColor(icon, "ImageColor3", isActive and ACTIVE_ICON or INACTIVE_ICON) end
	        end
	
	        tweenPanel(panel, isActive)
	    end
	end
	
	for _, name in ipairs(tabNames) do
	    local button = topButtons:FindFirstChild(name)
	    if button then
	        button.Activated:Connect(function()
	            setActive(name)
	        end)
	    end
	end
	
	if darktheme then
	    darktheme.Changed:Connect(updateColors)
	end
	
	updateColors()
	setActive(tabNames[1])
	
end;
task.spawn(C_204);
-- StarterGui.zerohub.interface.main.drag
local function C_20d()
local script = G2L["20d"];
	--Not made by me, check out this video: https://www.youtube.com/watch?v=z25nyNBG7Js&t=22s
	--Put this inside of your Frame and configure the speed if you would like.
	--Enjoy! Credits go to: https://www.youtube.com/watch?v=z25nyNBG7Js&t=22s
	
	local UIS = game:GetService('UserInputService')
	local frame = script.Parent
	local dragToggle = nil
	local dragSpeed = 0
	local dragStart = nil
	local startPos = nil
	
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end
	
	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			if frame:GetAttribute("IsDraggingSlider") then return end
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
	
end;
task.spawn(C_20d);
-- StarterGui.zerohub.interface.main.notifications.notificationsystem
local function C_223()
local script = G2L["223"];
	-- Services
	local tweenservice = game:GetService("TweenService")
	local runservice = game:GetService("RunService")
	
	-- References
	local folder = script.Parent
	local main = folder.Parent
	local screengui = script:FindFirstAncestorOfClass("ScreenGui")
	local storage = screengui and screengui:WaitForChild("storage")
	local darktheme = storage and storage:WaitForChild("darktheme")
	
	-- Configuration
	local toastduration = 5
	local toastwidth, toastheight = 170, 45
	local verticalgap = 7
	local marginbottom = 10
	local offsetx = 300
	local maxnotifications = 5
	local activenotifications = {}
	
	-- Audio feedback
	local notifysound = Instance.new("Sound")
	notifysound.Name = "NotificationSound"
	notifysound.SoundId = "rbxassetid://117409737658405"
	notifysound.Volume = 1
	notifysound.Parent = screengui or folder
	
	-- Template discovery
	local basetemplate = folder:WaitForChild("examplesuccess", 5)
	if not basetemplate then
		for _, child in ipairs(folder:GetChildren()) do
			if child:IsA("GuiObject") and string.find(string.lower(child.Name), "example") then
				basetemplate = child
				break
			end
		end
	end
	
	if basetemplate then
		basetemplate.Visible = false
	end
	
	-- Notification icons
	local notificationtypes = {
		success = { icon = "rbxassetid://10709790644" },
		warning = { icon = "rbxassetid://10709753149" },
		info = { icon = "rbxassetid://10723415903" }
	}
	
	-- Theme helpers
	local function getthemecolors(dark)
		local isdark = dark
		if isdark == nil then
			isdark = darktheme and darktheme.Value
			if isdark == nil then isdark = true end
		end
		return {
			card = isdark and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(255, 255, 255),
			primary = isdark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39),
			secondary = isdark and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(107, 114, 128),
			track = isdark and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(228, 231, 235),
			fill = isdark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(17, 24, 39)
		}
	end
	
	-- Layout calculations
	local function getmainheight()
		return main.AbsoluteSize.Y > 0 and main.AbsoluteSize.Y or 309
	end
	
	local function calculatetargetposition(index)
		local yoffset = getmainheight() - marginbottom - toastheight - (index - 1) * (toastheight + verticalgap)
		return UDim2.fromOffset(offsetx, yoffset)
	end
	
	local function reflowpositions()
		for index, notif in ipairs(activenotifications) do
			notif.frame:TweenPosition(calculatetargetposition(index), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true)
		end
	end
	
	-- Close notification
	local function closenotification(notif, isimmediate)
		if notif.isclosing then return end
		notif.isclosing = true
	
		local foundindex = table.find(activenotifications, notif)
		if foundindex then
			table.remove(activenotifications, foundindex)
		end
		reflowpositions()
	
		local frame = notif.frame
		if isimmediate then
			frame:Destroy()
		else
			local tween = tweenservice:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = frame.Position + UDim2.fromOffset(toastwidth + 60, 0),
				BackgroundTransparency = 1
			})
			tween:Play()
			tween.Completed:Once(function()
				frame:Destroy()
			end)
		end
	end
	
	-- Spawn notification
	local function spawnnotification(typename, title, description)
		if not basetemplate then return end
		local typeinfo = notificationtypes[typename]
		if not typeinfo then return end
	
		pcall(function()
			notifysound:Play()
		end)
	
		if #activenotifications >= maxnotifications then
			closenotification(activenotifications[#activenotifications], true)
		end
	
		local colors = getthemecolors()
		local frame = basetemplate:Clone()
		frame.Name = typename .. "notification"
		frame.BackgroundColor3 = colors.card
		frame.Visible = true
	
		local startx = main.AbsoluteSize.X > 0 and main.AbsoluteSize.X or 480
		frame.Position = UDim2.fromOffset(startx + 10, calculatetargetposition(1).Y.Offset)
		frame.Parent = folder
	
		local icon = frame:FindFirstChild("icon")
		if icon then
			icon.Image = typeinfo.icon
			icon.ImageColor3 = colors.primary
		end
	
		local bar = frame:FindFirstChild("bar")
		local fill = bar and bar:FindFirstChild("fill")
		if bar then
			bar.BackgroundColor3 = colors.track
		end
		if fill then
			fill.BackgroundColor3 = colors.fill
			fill.Size = UDim2.fromScale(1, 1)
		end
	
		local titlelabel = frame:FindFirstChild("title")
		if titlelabel then
			titlelabel.TextColor3 = colors.primary
			titlelabel.Text = title or ""
		end
	
		local descriptionlabel = frame:FindFirstChild("desc")
		if descriptionlabel then
			descriptionlabel.TextColor3 = colors.secondary
			descriptionlabel.Text = description or ""
		end
	
		local notifentry = {
			frame = frame,
			ispaused = false,
			elapsed = 0,
			isclosing = false
		}
	
		frame.MouseEnter:Connect(function()
			notifentry.ispaused = true
		end)
		frame.MouseLeave:Connect(function()
			notifentry.ispaused = false
		end)
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				closenotification(notifentry, false)
			end
		end)
	
		table.insert(activenotifications, 1, notifentry)
		for i = 2, #activenotifications do
			activenotifications[i].frame:TweenPosition(calculatetargetposition(i), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true)
		end
		frame:TweenPosition(calculatetargetposition(1), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.35, true)
	
		task.spawn(function()
			while frame.Parent and not notifentry.isclosing do
				local deltatime = runservice.RenderStepped:Wait()
				if not notifentry.ispaused then
					notifentry.elapsed += deltatime
					if fill then
						local progress = math.clamp(1 - notifentry.elapsed / toastduration, 0, 1)
						fill.Size = UDim2.fromScale(progress, 1)
					end
					if notifentry.elapsed >= toastduration then
						closenotification(notifentry, false)
						break
					end
				end
			end
		end)
	end
	
	-- Theme reaction for active toasts
	if darktheme then
		darktheme.Changed:Connect(function(isdark)
			local colors = getthemecolors(isdark)
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
			for _, notif in ipairs(activenotifications) do
				if notif.frame and notif.frame.Parent and not notif.isclosing then
					tweenservice:Create(notif.frame, tweenInfo, { BackgroundColor3 = colors.card }):Play()
					local icon = notif.frame:FindFirstChild("icon")
					if icon then
						tweenservice:Create(icon, tweenInfo, { ImageColor3 = colors.primary }):Play()
					end
					local bar = notif.frame:FindFirstChild("bar")
					if bar then
						tweenservice:Create(bar, tweenInfo, { BackgroundColor3 = colors.track }):Play()
						local fill = bar:FindFirstChild("fill")
						if fill then
							tweenservice:Create(fill, tweenInfo, { BackgroundColor3 = colors.fill }):Play()
						end
					end
					local title = notif.frame:FindFirstChild("title")
					if title then
						tweenservice:Create(title, tweenInfo, { TextColor3 = colors.primary }):Play()
					end
					local desc = notif.frame:FindFirstChild("desc")
					if desc then
						tweenservice:Create(desc, tweenInfo, { TextColor3 = colors.secondary }):Play()
					end
				end
			end
		end)
	end
	
	-- Global dispatch handlers
	local function notify(typename, title, description)
		spawnnotification(typename, title, description)
	end
	
	local function exposesystem(name, func)
		_G[name] = func
		_G[name .. "_real"] = func
		if type(getgenv) == "function" then
			pcall(function()
				getgenv()[name] = func
				getgenv()[name .. "_real"] = func
			end)
		end
		if type(shared) == "table" then
			pcall(function()
				shared[name] = func
				shared[name .. "_real"] = func
			end)
		end
	end
	
	exposesystem("zerohubnotificationsystem_success", function(title, description)
		notify("success", title, description)
	end)
	exposesystem("zerohubnotificationsystem_warning", function(title, description)
		notify("warning", title, description)
	end)
	exposesystem("zerohubnotificationsystem_info", function(title, description)
		notify("info", title, description)
	end)
	
	-- Process pending early queue
	if _G.__zerohub_notification_queue then
		for _, item in ipairs(_G.__zerohub_notification_queue) do
			notify(item.typename, item.title, item.description)
		end
		_G.__zerohub_notification_queue = nil
	end
	
end;
task.spawn(C_223);
-- StarterGui.zerohub.interface.main.sidebar.clock.LocalScript
local function C_246()
local script = G2L["246"];
	local textLabel = script.Parent
	
	local function updateClock()
		textLabel.Text = os.date("%H:%M")
	end
	
	updateClock()
	
	while task.wait(1) do
		updateClock()
	end
end;
task.spawn(C_246);
-- StarterGui.zerohub.interface.main.sidebar.date.LocalScript
local function C_248()
local script = G2L["248"];
	local textLabel = script.Parent
	
	local function updateDate()
		textLabel.Text = string.lower(os.date("%d %B %Y"))
	end
	
	updateDate()
	
	while task.wait(1) do
		updateDate()
	end
end;
task.spawn(C_248);
-- StarterGui.zerohub.interface.open.drag
local function C_24b()
local script = G2L["24b"];
	--Not made by me, check out this video: https://www.youtube.com/watch?v=z25nyNBG7Js&t=22s
	--Put this inside of your Frame and configure the speed if you would like.
	--Enjoy! Credits go to: https://www.youtube.com/watch?v=z25nyNBG7Js&t=22s
	
	local UIS = game:GetService('UserInputService')
	local frame = script.Parent
	local dragToggle = nil
	local dragSpeed = 0
	local dragStart = nil
	local startPos = nil
	
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end
	
	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			if frame:GetAttribute("IsDraggingSlider") then return end
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
	
end;
task.spawn(C_24b);
-- StarterGui.zerohub.interface.open.LocalScript
local function C_24c()
local script = G2L["24c"];
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.main.Visible = true
		script.Parent.Visible = false
	end)
end;
task.spawn(C_24c);

return G2L["1"], require;
