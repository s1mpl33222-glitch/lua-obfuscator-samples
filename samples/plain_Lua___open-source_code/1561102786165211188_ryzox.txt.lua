--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

-- Instances: 415 | Scripts: 13 | Modules: 0 | Tags: 0
local G2L = {};

-- StarterGui.RyzoxClient
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["DisplayOrder"] = 999;
G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
G2L["1"]["Name"] = [[RyzoxClient]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;


-- StarterGui.RyzoxClient.Assets
G2L["2"] = Instance.new("Folder", G2L["1"]);
G2L["2"]["Name"] = [[Assets]];


-- StarterGui.RyzoxClient.Components
G2L["3"] = Instance.new("Folder", G2L["1"]);
G2L["3"]["Name"] = [[Components]];


-- StarterGui.RyzoxClient.Pages
G2L["4"] = Instance.new("Folder", G2L["1"]);
G2L["4"]["Name"] = [[Pages]];


-- StarterGui.RyzoxClient.Pages.Camera
G2L["5"] = Instance.new("ScrollingFrame", G2L["4"]);
G2L["5"]["Visible"] = false;
G2L["5"]["Active"] = true;
G2L["5"]["ZIndex"] = 3;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["5"]["Name"] = [[Camera]];
G2L["5"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["5"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["5"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["5"]["ScrollBarThickness"] = 3;
G2L["5"]["BackgroundTransparency"] = 1;
-- Attributes
G2L["5"]:SetAttribute([[RuntimePage]], true);


-- StarterGui.RyzoxClient.Pages.Movement
G2L["6"] = Instance.new("ScrollingFrame", G2L["4"]);
G2L["6"]["Visible"] = false;
G2L["6"]["Active"] = true;
G2L["6"]["ZIndex"] = 3;
G2L["6"]["BorderSizePixel"] = 0;
G2L["6"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["6"]["Name"] = [[Movement]];
G2L["6"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["6"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["6"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["6"]["ScrollBarThickness"] = 3;
G2L["6"]["BackgroundTransparency"] = 1;
-- Attributes
G2L["6"]:SetAttribute([[RuntimePage]], true);


-- StarterGui.RyzoxClient.Pages.Character
G2L["7"] = Instance.new("ScrollingFrame", G2L["4"]);
G2L["7"]["Visible"] = false;
G2L["7"]["Active"] = true;
G2L["7"]["ZIndex"] = 3;
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["7"]["Name"] = [[Character]];
G2L["7"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["7"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["7"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["7"]["ScrollBarThickness"] = 3;
G2L["7"]["BackgroundTransparency"] = 1;
-- Attributes
G2L["7"]:SetAttribute([[RuntimePage]], true);


-- StarterGui.RyzoxClient.Pages.Settings
G2L["8"] = Instance.new("ScrollingFrame", G2L["4"]);
G2L["8"]["Visible"] = false;
G2L["8"]["Active"] = true;
G2L["8"]["ZIndex"] = 3;
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["8"]["Name"] = [[Settings]];
G2L["8"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["8"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["8"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["8"]["ScrollBarThickness"] = 3;
G2L["8"]["BackgroundTransparency"] = 1;
-- Attributes
G2L["8"]:SetAttribute([[RuntimePage]], true);


-- StarterGui.RyzoxClient.Pages.Visual
G2L["9"] = Instance.new("ScrollingFrame", G2L["4"]);
G2L["9"]["Visible"] = false;
G2L["9"]["Active"] = true;
G2L["9"]["BorderSizePixel"] = 0;
G2L["9"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["9"]["Name"] = [[Visual]];
G2L["9"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["9"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["9"]["ScrollBarImageColor3"] = Color3.fromRGB(155, 106, 255);
G2L["9"]["ScrollBarThickness"] = 3;
G2L["9"]["BackgroundTransparency"] = 1;
-- Attributes
G2L["9"]:SetAttribute([[RuntimePage]], true);


-- StarterGui.RyzoxClient.Scripts
G2L["a"] = Instance.new("Folder", G2L["1"]);
G2L["a"]["Name"] = [[Scripts]];


-- StarterGui.RyzoxClient.Scripts.NotificationController
G2L["b"] = Instance.new("LocalScript", G2L["a"]);
G2L["b"]["Name"] = [[NotificationController]];


-- StarterGui.RyzoxClient.Scripts.MenuController
G2L["c"] = Instance.new("LocalScript", G2L["a"]);
G2L["c"]["Name"] = [[MenuController]];


-- StarterGui.RyzoxClient.Scripts.KeybindController
G2L["d"] = Instance.new("LocalScript", G2L["a"]);
G2L["d"]["Name"] = [[KeybindController]];


-- StarterGui.RyzoxClient.Scripts.FeatureController
G2L["e"] = Instance.new("LocalScript", G2L["a"]);
G2L["e"]["Name"] = [[FeatureController]];


-- StarterGui.RyzoxClient.Scripts.ExactTracerController
G2L["f"] = Instance.new("LocalScript", G2L["a"]);
G2L["f"]["Name"] = [[ExactTracerController]];


-- StarterGui.RyzoxClient.Scripts.UsernameController
G2L["10"] = Instance.new("LocalScript", G2L["a"]);
G2L["10"]["Name"] = [[UsernameController]];


-- StarterGui.RyzoxClient.Scripts.ESPController
G2L["11"] = Instance.new("LocalScript", G2L["a"]);
G2L["11"]["Name"] = [[ESPController]];


-- StarterGui.RyzoxClient.Scripts.CFrameBoostController
G2L["12"] = Instance.new("LocalScript", G2L["a"]);
G2L["12"]["Name"] = [[CFrameBoostController]];


-- StarterGui.RyzoxClient.Scripts.TransparencyFixController
G2L["13"] = Instance.new("LocalScript", G2L["a"]);
G2L["13"]["Name"] = [[TransparencyFixController]];


-- StarterGui.RyzoxClient.Scripts.CameraLockController
G2L["14"] = Instance.new("LocalScript", G2L["a"]);
G2L["14"]["Name"] = [[CameraLockController]];


-- StarterGui.RyzoxClient.Scripts.CameraLockBindController
G2L["15"] = Instance.new("LocalScript", G2L["a"]);
G2L["15"]["Name"] = [[CameraLockBindController]];


-- StarterGui.RyzoxClient.Scripts.MobileDynamicIslandController
G2L["16"] = Instance.new("LocalScript", G2L["a"]);
G2L["16"]["Name"] = [[MobileDynamicIslandController]];


-- StarterGui.RyzoxClient.Scripts.ResponsiveLayoutController
G2L["17"] = Instance.new("LocalScript", G2L["a"]);
G2L["17"]["Name"] = [[ResponsiveLayoutController]];


-- StarterGui.RyzoxClient.Remotes
G2L["18"] = Instance.new("Folder", G2L["1"]);
G2L["18"]["Name"] = [[Remotes]];


-- StarterGui.RyzoxClient.Remotes.Notify
G2L["19"] = Instance.new("BindableEvent", G2L["18"]);
G2L["19"]["Name"] = [[Notify]];


-- StarterGui.RyzoxClient.Overlay
G2L["1a"] = Instance.new("Frame", G2L["1"]);
G2L["1a"]["BorderSizePixel"] = 0;
G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1a"]["Name"] = [[Overlay]];
G2L["1a"]["BackgroundTransparency"] = 0.35;


-- StarterGui.RyzoxClient.Notifications
G2L["1b"] = Instance.new("Frame", G2L["1"]);
G2L["1b"]["ZIndex"] = 20;
G2L["1b"]["AnchorPoint"] = Vector2.new(1, 0);
G2L["1b"]["Size"] = UDim2.new(0, 335, 0, 500);
G2L["1b"]["Position"] = UDim2.new(1, -24, 0, 24);
G2L["1b"]["Name"] = [[Notifications]];
G2L["1b"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Notifications.UIListLayout
G2L["1c"] = Instance.new("UIListLayout", G2L["1b"]);
G2L["1c"]["Padding"] = UDim.new(0, 10);
G2L["1c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main
G2L["1d"] = Instance.new("Frame", G2L["1"]);
G2L["1d"]["Active"] = true;
G2L["1d"]["ZIndex"] = 2;
G2L["1d"]["BorderSizePixel"] = 0;
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(13, 15, 21);
G2L["1d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1d"]["ClipsDescendants"] = true;
G2L["1d"]["Size"] = UDim2.new(0.72, 0, 0.78, 0);
G2L["1d"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["1d"]["Name"] = [[Main]];
G2L["1d"]["BackgroundTransparency"] = 0.43;
-- Attributes
G2L["1d"]:SetAttribute([[RyzoxBaseTransparency]], 0.43);
G2L["1d"]:SetAttribute([[RyzoxFixedTransparency]], 0.43);


-- StarterGui.RyzoxClient.Main.UISizeConstraint
G2L["1e"] = Instance.new("UISizeConstraint", G2L["1d"]);
G2L["1e"]["MinSize"] = Vector2.new(640, 460);
G2L["1e"]["MaxSize"] = Vector2.new(1120, 740);


-- StarterGui.RyzoxClient.Main.UICorner
G2L["1f"] = Instance.new("UICorner", G2L["1d"]);
G2L["1f"]["CornerRadius"] = UDim.new(0, 18);


-- StarterGui.RyzoxClient.Main.UIStroke
G2L["20"] = Instance.new("UIStroke", G2L["1d"]);
G2L["20"]["Transparency"] = 0.45;
G2L["20"]["Color"] = Color3.fromRGB(79, 153, 255);
G2L["20"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.UIGradient
G2L["21"] = Instance.new("UIGradient", G2L["1d"]);
G2L["21"]["Rotation"] = 105;
G2L["21"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(32, 41, 59)),ColorSequenceKeypoint.new(0.500, Color3.fromRGB(14, 17, 24)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(35, 22, 43))};


-- StarterGui.RyzoxClient.Main.Header
G2L["22"] = Instance.new("Frame", G2L["1d"]);
G2L["22"]["Active"] = true;
G2L["22"]["ZIndex"] = 3;
G2L["22"]["Size"] = UDim2.new(1, -56, 0, 64);
G2L["22"]["Position"] = UDim2.new(0, 28, 0, 18);
G2L["22"]["Name"] = [[Header]];
G2L["22"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.Header.Title
G2L["23"] = Instance.new("TextLabel", G2L["22"]);
G2L["23"]["TextSize"] = 22;
G2L["23"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["23"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["23"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["23"]["BackgroundTransparency"] = 1;
G2L["23"]["Size"] = UDim2.new(0, 280, 0, 28);
G2L["23"]["Text"] = [[Ryzox Client]];
G2L["23"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.Header.Subtitle
G2L["24"] = Instance.new("TextLabel", G2L["22"]);
G2L["24"]["TextSize"] = 12;
G2L["24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["24"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["24"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["24"]["BackgroundTransparency"] = 1;
G2L["24"]["Size"] = UDim2.new(0, 280, 0, 18);
G2L["24"]["Text"] = [[Local control panel]];
G2L["24"]["Name"] = [[Subtitle]];
G2L["24"]["Position"] = UDim2.new(0, 0, 0, 30);


-- StarterGui.RyzoxClient.Main.Header.Close
G2L["25"] = Instance.new("TextButton", G2L["22"]);
G2L["25"]["TextSize"] = 30;
G2L["25"]["AutoButtonColor"] = false;
G2L["25"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["25"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["25"]["ZIndex"] = 3;
G2L["25"]["BackgroundTransparency"] = 1;
G2L["25"]["Size"] = UDim2.new(0, 42, 0, 42);
G2L["25"]["Text"] = [[×]];
G2L["25"]["Name"] = [[Close]];
G2L["25"]["Position"] = UDim2.new(1, -42, 0, -2);


-- StarterGui.RyzoxClient.Main.HeaderLine
G2L["26"] = Instance.new("Frame", G2L["1d"]);
G2L["26"]["ZIndex"] = 3;
G2L["26"]["BorderSizePixel"] = 0;
G2L["26"]["BackgroundColor3"] = Color3.fromRGB(82, 92, 117);
G2L["26"]["Size"] = UDim2.new(1, -56, 0, 1);
G2L["26"]["Position"] = UDim2.new(0, 28, 0, 84);
G2L["26"]["Name"] = [[HeaderLine]];
G2L["26"]["BackgroundTransparency"] = 0.55;


-- StarterGui.RyzoxClient.Main.Sidebar
G2L["27"] = Instance.new("Frame", G2L["1d"]);
G2L["27"]["ZIndex"] = 3;
G2L["27"]["Size"] = UDim2.new(0, 190, 0, 330);
G2L["27"]["Position"] = UDim2.new(0, 28, 0, 102);
G2L["27"]["Name"] = [[Sidebar]];
G2L["27"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.Sidebar.UIListLayout
G2L["28"] = Instance.new("UIListLayout", G2L["27"]);
G2L["28"]["Padding"] = UDim.new(0, 8);
G2L["28"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.Sidebar.Camera
G2L["29"] = Instance.new("TextButton", G2L["27"]);
G2L["29"]["BorderSizePixel"] = 0;
G2L["29"]["AutoButtonColor"] = false;
G2L["29"]["BackgroundColor3"] = Color3.fromRGB(79, 153, 255);
G2L["29"]["ZIndex"] = 3;
G2L["29"]["BackgroundTransparency"] = 1;
G2L["29"]["Size"] = UDim2.new(1, -10, 0, 42);
G2L["29"]["LayoutOrder"] = 2;
G2L["29"]["Text"] = [[]];
G2L["29"]["Name"] = [[Camera]];


-- StarterGui.RyzoxClient.Main.Sidebar.Camera.UICorner
G2L["2a"] = Instance.new("UICorner", G2L["29"]);
G2L["2a"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.Camera.Text
G2L["2b"] = Instance.new("TextLabel", G2L["29"]);
G2L["2b"]["TextSize"] = 14;
G2L["2b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["2b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["2b"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["2b"]["BackgroundTransparency"] = 1;
G2L["2b"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["2b"]["Text"] = [[Camera]];
G2L["2b"]["Name"] = [[Text]];
G2L["2b"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Camera.Icon
G2L["2c"] = Instance.new("Frame", G2L["29"]);
G2L["2c"]["BorderSizePixel"] = 0;
G2L["2c"]["BackgroundColor3"] = Color3.fromRGB(98, 181, 255);
G2L["2c"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["2c"]["Position"] = UDim2.new(0, 12, 0, 9);
G2L["2c"]["Name"] = [[Icon]];
G2L["2c"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.Camera.Icon.UICorner
G2L["2d"] = Instance.new("UICorner", G2L["2c"]);
G2L["2d"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Camera.Icon.Letter
G2L["2e"] = Instance.new("TextLabel", G2L["2c"]);
G2L["2e"]["TextSize"] = 12;
G2L["2e"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["2e"]["TextColor3"] = Color3.fromRGB(98, 181, 255);
G2L["2e"]["BackgroundTransparency"] = 1;
G2L["2e"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["2e"]["Text"] = [[C]];
G2L["2e"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.Movement
G2L["2f"] = Instance.new("TextButton", G2L["27"]);
G2L["2f"]["BorderSizePixel"] = 0;
G2L["2f"]["AutoButtonColor"] = false;
G2L["2f"]["BackgroundColor3"] = Color3.fromRGB(79, 153, 255);
G2L["2f"]["ZIndex"] = 3;
G2L["2f"]["BackgroundTransparency"] = 1;
G2L["2f"]["Size"] = UDim2.new(1, -10, 0, 42);
G2L["2f"]["LayoutOrder"] = 3;
G2L["2f"]["Text"] = [[]];
G2L["2f"]["Name"] = [[Movement]];


-- StarterGui.RyzoxClient.Main.Sidebar.Movement.UICorner
G2L["30"] = Instance.new("UICorner", G2L["2f"]);
G2L["30"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.Movement.Text
G2L["31"] = Instance.new("TextLabel", G2L["2f"]);
G2L["31"]["TextSize"] = 14;
G2L["31"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["31"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["31"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["31"]["BackgroundTransparency"] = 1;
G2L["31"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["31"]["Text"] = [[Movement]];
G2L["31"]["Name"] = [[Text]];
G2L["31"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Movement.Icon
G2L["32"] = Instance.new("Frame", G2L["2f"]);
G2L["32"]["BorderSizePixel"] = 0;
G2L["32"]["BackgroundColor3"] = Color3.fromRGB(53, 207, 138);
G2L["32"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["32"]["Position"] = UDim2.new(0, 12, 0, 9);
G2L["32"]["Name"] = [[Icon]];
G2L["32"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.Movement.Icon.UICorner
G2L["33"] = Instance.new("UICorner", G2L["32"]);
G2L["33"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Movement.Icon.Letter
G2L["34"] = Instance.new("TextLabel", G2L["32"]);
G2L["34"]["TextSize"] = 12;
G2L["34"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["34"]["TextColor3"] = Color3.fromRGB(53, 207, 138);
G2L["34"]["BackgroundTransparency"] = 1;
G2L["34"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["34"]["Text"] = [[M]];
G2L["34"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.Character
G2L["35"] = Instance.new("TextButton", G2L["27"]);
G2L["35"]["BorderSizePixel"] = 0;
G2L["35"]["AutoButtonColor"] = false;
G2L["35"]["BackgroundColor3"] = Color3.fromRGB(79, 153, 255);
G2L["35"]["ZIndex"] = 3;
G2L["35"]["BackgroundTransparency"] = 1;
G2L["35"]["Size"] = UDim2.new(1, -10, 0, 42);
G2L["35"]["LayoutOrder"] = 4;
G2L["35"]["Text"] = [[]];
G2L["35"]["Name"] = [[Character]];


-- StarterGui.RyzoxClient.Main.Sidebar.Character.UICorner
G2L["36"] = Instance.new("UICorner", G2L["35"]);
G2L["36"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.Character.Text
G2L["37"] = Instance.new("TextLabel", G2L["35"]);
G2L["37"]["TextSize"] = 14;
G2L["37"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["37"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["37"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["37"]["BackgroundTransparency"] = 1;
G2L["37"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["37"]["Text"] = [[Character]];
G2L["37"]["Name"] = [[Text]];
G2L["37"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Character.Icon
G2L["38"] = Instance.new("Frame", G2L["35"]);
G2L["38"]["BorderSizePixel"] = 0;
G2L["38"]["BackgroundColor3"] = Color3.fromRGB(239, 89, 101);
G2L["38"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["38"]["Position"] = UDim2.new(0, 12, 0, 9);
G2L["38"]["Name"] = [[Icon]];
G2L["38"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.Character.Icon.UICorner
G2L["39"] = Instance.new("UICorner", G2L["38"]);
G2L["39"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Character.Icon.Letter
G2L["3a"] = Instance.new("TextLabel", G2L["38"]);
G2L["3a"]["TextSize"] = 12;
G2L["3a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["3a"]["TextColor3"] = Color3.fromRGB(239, 89, 101);
G2L["3a"]["BackgroundTransparency"] = 1;
G2L["3a"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["3a"]["Text"] = [[P]];
G2L["3a"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.Settings
G2L["3b"] = Instance.new("TextButton", G2L["27"]);
G2L["3b"]["BorderSizePixel"] = 0;
G2L["3b"]["AutoButtonColor"] = false;
G2L["3b"]["BackgroundColor3"] = Color3.fromRGB(79, 153, 255);
G2L["3b"]["ZIndex"] = 3;
G2L["3b"]["BackgroundTransparency"] = 1;
G2L["3b"]["Size"] = UDim2.new(1, -10, 0, 42);
G2L["3b"]["LayoutOrder"] = 999;
G2L["3b"]["Text"] = [[]];
G2L["3b"]["Name"] = [[Settings]];


-- StarterGui.RyzoxClient.Main.Sidebar.Settings.UICorner
G2L["3c"] = Instance.new("UICorner", G2L["3b"]);
G2L["3c"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.Settings.Text
G2L["3d"] = Instance.new("TextLabel", G2L["3b"]);
G2L["3d"]["TextSize"] = 14;
G2L["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["3d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["3d"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["3d"]["BackgroundTransparency"] = 1;
G2L["3d"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["3d"]["Text"] = [[Settings]];
G2L["3d"]["Name"] = [[Text]];
G2L["3d"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Settings.Icon
G2L["3e"] = Instance.new("Frame", G2L["3b"]);
G2L["3e"]["BorderSizePixel"] = 0;
G2L["3e"]["BackgroundColor3"] = Color3.fromRGB(233, 91, 191);
G2L["3e"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["3e"]["Position"] = UDim2.new(0, 12, 0, 9);
G2L["3e"]["Name"] = [[Icon]];
G2L["3e"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.Settings.Icon.UICorner
G2L["3f"] = Instance.new("UICorner", G2L["3e"]);
G2L["3f"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Settings.Icon.Letter
G2L["40"] = Instance.new("TextLabel", G2L["3e"]);
G2L["40"]["TextSize"] = 12;
G2L["40"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["40"]["TextColor3"] = Color3.fromRGB(233, 91, 191);
G2L["40"]["BackgroundTransparency"] = 1;
G2L["40"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["40"]["Text"] = [[S]];
G2L["40"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.Visual
G2L["41"] = Instance.new("TextButton", G2L["27"]);
G2L["41"]["BorderSizePixel"] = 0;
G2L["41"]["AutoButtonColor"] = false;
G2L["41"]["BackgroundColor3"] = Color3.fromRGB(79, 153, 255);
G2L["41"]["BackgroundTransparency"] = 1;
G2L["41"]["Size"] = UDim2.new(1, -10, 0, 42);
G2L["41"]["LayoutOrder"] = 5;
G2L["41"]["Text"] = [[]];
G2L["41"]["Name"] = [[Visual]];


-- StarterGui.RyzoxClient.Main.Sidebar.Visual.UICorner
G2L["42"] = Instance.new("UICorner", G2L["41"]);
G2L["42"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.Visual.Text
G2L["43"] = Instance.new("TextLabel", G2L["41"]);
G2L["43"]["TextSize"] = 14;
G2L["43"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["43"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["43"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["43"]["BackgroundTransparency"] = 1;
G2L["43"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["43"]["Text"] = [[Visual]];
G2L["43"]["Name"] = [[Text]];
G2L["43"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Visual.Icon
G2L["44"] = Instance.new("Frame", G2L["41"]);
G2L["44"]["BorderSizePixel"] = 0;
G2L["44"]["BackgroundColor3"] = Color3.fromRGB(155, 106, 255);
G2L["44"]["Size"] = UDim2.new(0.13333, 0, 0.57143, 0);
G2L["44"]["Position"] = UDim2.new(0.06667, 0, 0.21429, 0);
G2L["44"]["Name"] = [[Icon]];
G2L["44"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.Visual.Icon.UICorner
G2L["45"] = Instance.new("UICorner", G2L["44"]);
G2L["45"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.RyzoxClient.Main.Sidebar.Visual.Icon.Letter
G2L["46"] = Instance.new("TextLabel", G2L["44"]);
G2L["46"]["TextSize"] = 12;
G2L["46"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["46"]["TextColor3"] = Color3.fromRGB(155, 106, 255);
G2L["46"]["BackgroundTransparency"] = 1;
G2L["46"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["46"]["Text"] = [[V]];
G2L["46"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock
G2L["47"] = Instance.new("TextButton", G2L["27"]);
G2L["47"]["BorderSizePixel"] = 0;
G2L["47"]["AutoButtonColor"] = false;
G2L["47"]["BackgroundColor3"] = Color3.fromRGB(80, 154, 255);
G2L["47"]["BackgroundTransparency"] = 1;
G2L["47"]["Size"] = UDim2.new(0.94737, 0, 0.12727, 0);
G2L["47"]["LayoutOrder"] = 7;
G2L["47"]["Text"] = [[]];
G2L["47"]["Name"] = [[CameraLock]];


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock.UICorner
G2L["48"] = Instance.new("UICorner", G2L["47"]);
G2L["48"]["CornerRadius"] = UDim.new(0, 10);


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock.Icon
G2L["49"] = Instance.new("Frame", G2L["47"]);
G2L["49"]["BorderSizePixel"] = 0;
G2L["49"]["BackgroundColor3"] = Color3.fromRGB(80, 154, 255);
G2L["49"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["49"]["Position"] = UDim2.new(0, 12, 0, 9);
G2L["49"]["Name"] = [[Icon]];
G2L["49"]["BackgroundTransparency"] = 0.78;


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock.Icon.UICorner
G2L["4a"] = Instance.new("UICorner", G2L["49"]);
G2L["4a"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock.Icon.Letter
G2L["4b"] = Instance.new("TextLabel", G2L["49"]);
G2L["4b"]["TextSize"] = 12;
G2L["4b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["4b"]["TextColor3"] = Color3.fromRGB(99, 182, 255);
G2L["4b"]["BackgroundTransparency"] = 1;
G2L["4b"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["4b"]["Text"] = [[L]];
G2L["4b"]["Name"] = [[Letter]];


-- StarterGui.RyzoxClient.Main.Sidebar.CameraLock.Text
G2L["4c"] = Instance.new("TextLabel", G2L["47"]);
G2L["4c"]["TextSize"] = 14;
G2L["4c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["4c"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["4c"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["4c"]["BackgroundTransparency"] = 1;
G2L["4c"]["Size"] = UDim2.new(1, -56, 0, 42);
G2L["4c"]["Text"] = [[Camera Lock]];
G2L["4c"]["Name"] = [[Text]];
G2L["4c"]["Position"] = UDim2.new(0, 46, 0, 0);


-- StarterGui.RyzoxClient.Main.SidebarLine
G2L["4d"] = Instance.new("Frame", G2L["1d"]);
G2L["4d"]["ZIndex"] = 3;
G2L["4d"]["BorderSizePixel"] = 0;
G2L["4d"]["BackgroundColor3"] = Color3.fromRGB(82, 92, 117);
G2L["4d"]["Size"] = UDim2.new(0, 1, 1, -130);
G2L["4d"]["Position"] = UDim2.new(0, 222, 0, 101);
G2L["4d"]["Name"] = [[SidebarLine]];
G2L["4d"]["BackgroundTransparency"] = 0.65;


-- StarterGui.RyzoxClient.Main.PageContainer
G2L["4e"] = Instance.new("Frame", G2L["1d"]);
G2L["4e"]["ZIndex"] = 3;
G2L["4e"]["Size"] = UDim2.new(1, -276, 1, -130);
G2L["4e"]["Position"] = UDim2.new(0, 248, 0, 102);
G2L["4e"]["Name"] = [[PageContainer]];
G2L["4e"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera
G2L["4f"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["4f"]["Visible"] = false;
G2L["4f"]["Active"] = true;
G2L["4f"]["ZIndex"] = 3;
G2L["4f"]["BorderSizePixel"] = 0;
G2L["4f"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["4f"]["Name"] = [[Camera]];
G2L["4f"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["4f"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["4f"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["4f"]["ScrollBarThickness"] = 3;
G2L["4f"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.UIListLayout
G2L["50"] = Instance.new("UIListLayout", G2L["4f"]);
G2L["50"]["Padding"] = UDim.new(0, 10);
G2L["50"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.UIPadding
G2L["51"] = Instance.new("UIPadding", G2L["4f"]);
G2L["51"]["PaddingRight"] = UDim.new(0, 8);
G2L["51"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.Heading
G2L["52"] = Instance.new("Frame", G2L["4f"]);
G2L["52"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["52"]["Name"] = [[Heading]];
G2L["52"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.Heading.Title
G2L["53"] = Instance.new("TextLabel", G2L["52"]);
G2L["53"]["TextSize"] = 20;
G2L["53"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["53"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["53"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["53"]["BackgroundTransparency"] = 1;
G2L["53"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["53"]["Text"] = [[Camera]];
G2L["53"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.Heading.Subtitle
G2L["54"] = Instance.new("TextLabel", G2L["52"]);
G2L["54"]["TextSize"] = 11;
G2L["54"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["54"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["54"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["54"]["BackgroundTransparency"] = 1;
G2L["54"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["54"]["Text"] = [[Configure mouse and camera behavior.]];
G2L["54"]["Name"] = [[Subtitle]];
G2L["54"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock
G2L["55"] = Instance.new("Frame", G2L["4f"]);
G2L["55"]["BorderSizePixel"] = 0;
G2L["55"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["55"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["55"]["Name"] = [[CameraUnlock]];
G2L["55"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["55"]:SetAttribute([[Enabled]], false);
G2L["55"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["55"]:SetAttribute([[Accent]], Color3.fromRGB(79, 153, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.UICorner
G2L["56"] = Instance.new("UICorner", G2L["55"]);
G2L["56"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.UIStroke
G2L["57"] = Instance.new("UIStroke", G2L["55"]);
G2L["57"]["Transparency"] = 0.48;
G2L["57"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["57"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Title
G2L["58"] = Instance.new("TextLabel", G2L["55"]);
G2L["58"]["TextSize"] = 14;
G2L["58"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["58"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["58"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["58"]["BackgroundTransparency"] = 1;
G2L["58"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["58"]["Text"] = [[Camera Unlock]];
G2L["58"]["Name"] = [[Title]];
G2L["58"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Description
G2L["59"] = Instance.new("TextLabel", G2L["55"]);
G2L["59"]["TextSize"] = 10;
G2L["59"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["59"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["59"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["59"]["BackgroundTransparency"] = 1;
G2L["59"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["59"]["Text"] = [[Unlock mouse and restore standard camera behavior]];
G2L["59"]["Name"] = [[Description]];
G2L["59"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Switch
G2L["5a"] = Instance.new("TextButton", G2L["55"]);
G2L["5a"]["BorderSizePixel"] = 0;
G2L["5a"]["AutoButtonColor"] = false;
G2L["5a"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["5a"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["5a"]["Text"] = [[]];
G2L["5a"]["Name"] = [[Switch]];
G2L["5a"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Switch.UICorner
G2L["5b"] = Instance.new("UICorner", G2L["5a"]);
G2L["5b"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Switch.Dot
G2L["5c"] = Instance.new("Frame", G2L["5a"]);
G2L["5c"]["BorderSizePixel"] = 0;
G2L["5c"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["5c"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["5c"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["5c"]["Name"] = [[Dot]];
G2L["5c"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Camera.CameraUnlock.Switch.Dot.UICorner
G2L["5d"] = Instance.new("UICorner", G2L["5c"]);
G2L["5d"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement
G2L["5e"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["5e"]["Visible"] = false;
G2L["5e"]["Active"] = true;
G2L["5e"]["ZIndex"] = 3;
G2L["5e"]["BorderSizePixel"] = 0;
G2L["5e"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["5e"]["Name"] = [[Movement]];
G2L["5e"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["5e"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["5e"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["5e"]["ScrollBarThickness"] = 3;
G2L["5e"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.UIListLayout
G2L["5f"] = Instance.new("UIListLayout", G2L["5e"]);
G2L["5f"]["Padding"] = UDim.new(0, 10);
G2L["5f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.UIPadding
G2L["60"] = Instance.new("UIPadding", G2L["5e"]);
G2L["60"]["PaddingRight"] = UDim.new(0, 8);
G2L["60"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.Heading
G2L["61"] = Instance.new("Frame", G2L["5e"]);
G2L["61"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["61"]["Name"] = [[Heading]];
G2L["61"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.Heading.Title
G2L["62"] = Instance.new("TextLabel", G2L["61"]);
G2L["62"]["TextSize"] = 20;
G2L["62"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["62"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["62"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["62"]["BackgroundTransparency"] = 1;
G2L["62"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["62"]["Text"] = [[Movement]];
G2L["62"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.Heading.Subtitle
G2L["63"] = Instance.new("TextLabel", G2L["61"]);
G2L["63"]["TextSize"] = 11;
G2L["63"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["63"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["63"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["63"]["BackgroundTransparency"] = 1;
G2L["63"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["63"]["Text"] = [[Configure local movement settings.]];
G2L["63"]["Name"] = [[Subtitle]];
G2L["63"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost
G2L["64"] = Instance.new("Frame", G2L["5e"]);
G2L["64"]["BorderSizePixel"] = 0;
G2L["64"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["64"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["64"]["Name"] = [[SpeedBoost]];
G2L["64"]["LayoutOrder"] = 1;
G2L["64"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["64"]:SetAttribute([[Enabled]], false);
G2L["64"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["64"]:SetAttribute([[Accent]], Color3.fromRGB(53, 207, 138));


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.UICorner
G2L["65"] = Instance.new("UICorner", G2L["64"]);
G2L["65"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.UIStroke
G2L["66"] = Instance.new("UIStroke", G2L["64"]);
G2L["66"]["Transparency"] = 0.48;
G2L["66"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["66"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Title
G2L["67"] = Instance.new("TextLabel", G2L["64"]);
G2L["67"]["TextSize"] = 14;
G2L["67"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["67"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["67"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["67"]["BackgroundTransparency"] = 1;
G2L["67"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["67"]["Text"] = [[Speed Boost]];
G2L["67"]["Name"] = [[Title]];
G2L["67"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Description
G2L["68"] = Instance.new("TextLabel", G2L["64"]);
G2L["68"]["TextSize"] = 10;
G2L["68"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["68"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["68"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["68"]["BackgroundTransparency"] = 1;
G2L["68"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["68"]["Text"] = [[Enable custom WalkSpeed]];
G2L["68"]["Name"] = [[Description]];
G2L["68"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Switch
G2L["69"] = Instance.new("TextButton", G2L["64"]);
G2L["69"]["BorderSizePixel"] = 0;
G2L["69"]["AutoButtonColor"] = false;
G2L["69"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["69"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["69"]["Text"] = [[]];
G2L["69"]["Name"] = [[Switch]];
G2L["69"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Switch.UICorner
G2L["6a"] = Instance.new("UICorner", G2L["69"]);
G2L["6a"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Switch.Dot
G2L["6b"] = Instance.new("Frame", G2L["69"]);
G2L["6b"]["BorderSizePixel"] = 0;
G2L["6b"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["6b"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["6b"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["6b"]["Name"] = [[Dot]];
G2L["6b"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.SpeedBoost.Switch.Dot.UICorner
G2L["6c"] = Instance.new("UICorner", G2L["6b"]);
G2L["6c"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed
G2L["6d"] = Instance.new("Frame", G2L["5e"]);
G2L["6d"]["BorderSizePixel"] = 0;
G2L["6d"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["6d"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["6d"]["Name"] = [[WalkSpeed]];
G2L["6d"]["LayoutOrder"] = 2;
G2L["6d"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["6d"]:SetAttribute([[Minimum]], 1);
G2L["6d"]:SetAttribute([[ControlType]], [[Input]]);
G2L["6d"]:SetAttribute([[Maximum]], 1000000);
G2L["6d"]:SetAttribute([[Accent]], Color3.fromRGB(53, 207, 138));


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.UICorner
G2L["6e"] = Instance.new("UICorner", G2L["6d"]);
G2L["6e"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.UIStroke
G2L["6f"] = Instance.new("UIStroke", G2L["6d"]);
G2L["6f"]["Transparency"] = 0.48;
G2L["6f"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["6f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.Title
G2L["70"] = Instance.new("TextLabel", G2L["6d"]);
G2L["70"]["TextSize"] = 14;
G2L["70"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["70"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["70"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["70"]["BackgroundTransparency"] = 1;
G2L["70"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["70"]["Text"] = [[WalkSpeed]];
G2L["70"]["Name"] = [[Title]];
G2L["70"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.Description
G2L["71"] = Instance.new("TextLabel", G2L["6d"]);
G2L["71"]["TextSize"] = 10;
G2L["71"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["71"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["71"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["71"]["BackgroundTransparency"] = 1;
G2L["71"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["71"]["Text"] = [[Value from 1 to 1000000]];
G2L["71"]["Name"] = [[Description]];
G2L["71"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.Input
G2L["72"] = Instance.new("TextBox", G2L["6d"]);
G2L["72"]["Name"] = [[Input]];
G2L["72"]["BorderSizePixel"] = 0;
G2L["72"]["TextSize"] = 12;
G2L["72"]["TextColor3"] = Color3.fromRGB(53, 207, 138);
G2L["72"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["72"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["72"]["ClearTextOnFocus"] = false;
G2L["72"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["72"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["72"]["Text"] = [[32]];


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.Input.UICorner
G2L["73"] = Instance.new("UICorner", G2L["72"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Movement.WalkSpeed.Input.UIStroke
G2L["74"] = Instance.new("UIStroke", G2L["72"]);
G2L["74"]["Transparency"] = 0.55;
G2L["74"]["Color"] = Color3.fromRGB(53, 207, 138);
G2L["74"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost
G2L["75"] = Instance.new("Frame", G2L["5e"]);
G2L["75"]["BorderSizePixel"] = 0;
G2L["75"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["75"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["75"]["Name"] = [[JumpBoost]];
G2L["75"]["LayoutOrder"] = 4;
G2L["75"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["75"]:SetAttribute([[Enabled]], false);
G2L["75"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["75"]:SetAttribute([[Accent]], Color3.fromRGB(249, 157, 85));


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.UICorner
G2L["76"] = Instance.new("UICorner", G2L["75"]);
G2L["76"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.UIStroke
G2L["77"] = Instance.new("UIStroke", G2L["75"]);
G2L["77"]["Transparency"] = 0.48;
G2L["77"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["77"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Title
G2L["78"] = Instance.new("TextLabel", G2L["75"]);
G2L["78"]["TextSize"] = 14;
G2L["78"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["78"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["78"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["78"]["BackgroundTransparency"] = 1;
G2L["78"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["78"]["Text"] = [[Jump Boost]];
G2L["78"]["Name"] = [[Title]];
G2L["78"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Description
G2L["79"] = Instance.new("TextLabel", G2L["75"]);
G2L["79"]["TextSize"] = 10;
G2L["79"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["79"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["79"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["79"]["BackgroundTransparency"] = 1;
G2L["79"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["79"]["Text"] = [[Enable custom JumpPower]];
G2L["79"]["Name"] = [[Description]];
G2L["79"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Switch
G2L["7a"] = Instance.new("TextButton", G2L["75"]);
G2L["7a"]["BorderSizePixel"] = 0;
G2L["7a"]["AutoButtonColor"] = false;
G2L["7a"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["7a"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["7a"]["Text"] = [[]];
G2L["7a"]["Name"] = [[Switch]];
G2L["7a"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Switch.UICorner
G2L["7b"] = Instance.new("UICorner", G2L["7a"]);
G2L["7b"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Switch.Dot
G2L["7c"] = Instance.new("Frame", G2L["7a"]);
G2L["7c"]["BorderSizePixel"] = 0;
G2L["7c"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["7c"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["7c"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["7c"]["Name"] = [[Dot]];
G2L["7c"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpBoost.Switch.Dot.UICorner
G2L["7d"] = Instance.new("UICorner", G2L["7c"]);
G2L["7d"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower
G2L["7e"] = Instance.new("Frame", G2L["5e"]);
G2L["7e"]["BorderSizePixel"] = 0;
G2L["7e"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["7e"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["7e"]["Name"] = [[JumpPower]];
G2L["7e"]["LayoutOrder"] = 5;
G2L["7e"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["7e"]:SetAttribute([[Minimum]], 1);
G2L["7e"]:SetAttribute([[ControlType]], [[Input]]);
G2L["7e"]:SetAttribute([[Maximum]], 1000000);
G2L["7e"]:SetAttribute([[Accent]], Color3.fromRGB(249, 157, 85));


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.UICorner
G2L["7f"] = Instance.new("UICorner", G2L["7e"]);
G2L["7f"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.UIStroke
G2L["80"] = Instance.new("UIStroke", G2L["7e"]);
G2L["80"]["Transparency"] = 0.48;
G2L["80"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["80"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.Title
G2L["81"] = Instance.new("TextLabel", G2L["7e"]);
G2L["81"]["TextSize"] = 14;
G2L["81"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["81"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["81"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["81"]["BackgroundTransparency"] = 1;
G2L["81"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["81"]["Text"] = [[JumpPower]];
G2L["81"]["Name"] = [[Title]];
G2L["81"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.Description
G2L["82"] = Instance.new("TextLabel", G2L["7e"]);
G2L["82"]["TextSize"] = 10;
G2L["82"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["82"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["82"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["82"]["BackgroundTransparency"] = 1;
G2L["82"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["82"]["Text"] = [[Value from 1 to 1000000]];
G2L["82"]["Name"] = [[Description]];
G2L["82"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.Input
G2L["83"] = Instance.new("TextBox", G2L["7e"]);
G2L["83"]["Name"] = [[Input]];
G2L["83"]["BorderSizePixel"] = 0;
G2L["83"]["TextSize"] = 12;
G2L["83"]["TextColor3"] = Color3.fromRGB(249, 157, 85);
G2L["83"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["83"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["83"]["ClearTextOnFocus"] = false;
G2L["83"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["83"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["83"]["Text"] = [[75]];


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.Input.UICorner
G2L["84"] = Instance.new("UICorner", G2L["83"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Movement.JumpPower.Input.UIStroke
G2L["85"] = Instance.new("UIStroke", G2L["83"]);
G2L["85"]["Transparency"] = 0.55;
G2L["85"]["Color"] = Color3.fromRGB(249, 157, 85);
G2L["85"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost
G2L["86"] = Instance.new("Frame", G2L["5e"]);
G2L["86"]["BorderSizePixel"] = 0;
G2L["86"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["86"]["Size"] = UDim2.new(0.98586, 0, 0.14884, 0);
G2L["86"]["Name"] = [[CFrameBoost]];
G2L["86"]["LayoutOrder"] = 3;
-- Attributes
G2L["86"]:SetAttribute([[Enabled]], false);
G2L["86"]:SetAttribute([[ControlType]], [[CFrameToggle]]);
G2L["86"]:SetAttribute([[Accent]], Color3.fromRGB(155, 106, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.UICorner
G2L["87"] = Instance.new("UICorner", G2L["86"]);
G2L["87"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.UIStroke
G2L["88"] = Instance.new("UIStroke", G2L["86"]);
G2L["88"]["Transparency"] = 0.48;
G2L["88"]["Color"] = Color3.fromRGB(82, 92, 117);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Title
G2L["89"] = Instance.new("TextLabel", G2L["86"]);
G2L["89"]["TextSize"] = 14;
G2L["89"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["89"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["89"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["89"]["BackgroundTransparency"] = 1;
G2L["89"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["89"]["Text"] = [[CFrame Boost]];
G2L["89"]["Name"] = [[Title]];
G2L["89"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Description
G2L["8a"] = Instance.new("TextLabel", G2L["86"]);
G2L["8a"]["TextSize"] = 10;
G2L["8a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["8a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["8a"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["8a"]["BackgroundTransparency"] = 1;
G2L["8a"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["8a"]["Text"] = [[Uses CFrame instead of normal WalkSpeed]];
G2L["8a"]["Name"] = [[Description]];
G2L["8a"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Switch
G2L["8b"] = Instance.new("TextButton", G2L["86"]);
G2L["8b"]["BorderSizePixel"] = 0;
G2L["8b"]["AutoButtonColor"] = false;
G2L["8b"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["8b"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["8b"]["Text"] = [[]];
G2L["8b"]["Name"] = [[Switch]];
G2L["8b"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Switch.UICorner
G2L["8c"] = Instance.new("UICorner", G2L["8b"]);
G2L["8c"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Switch.Dot
G2L["8d"] = Instance.new("Frame", G2L["8b"]);
G2L["8d"]["BorderSizePixel"] = 0;
G2L["8d"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["8d"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["8d"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["8d"]["Name"] = [[Dot]];


-- StarterGui.RyzoxClient.Main.PageContainer.Movement.CFrameBoost.Switch.Dot.UICorner
G2L["8e"] = Instance.new("UICorner", G2L["8d"]);
G2L["8e"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Character
G2L["8f"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["8f"]["Visible"] = false;
G2L["8f"]["Active"] = true;
G2L["8f"]["ZIndex"] = 3;
G2L["8f"]["BorderSizePixel"] = 0;
G2L["8f"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["8f"]["Name"] = [[Character]];
G2L["8f"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["8f"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["8f"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["8f"]["ScrollBarThickness"] = 3;
G2L["8f"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.UIListLayout
G2L["90"] = Instance.new("UIListLayout", G2L["8f"]);
G2L["90"]["Padding"] = UDim.new(0, 10);
G2L["90"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.UIPadding
G2L["91"] = Instance.new("UIPadding", G2L["8f"]);
G2L["91"]["PaddingRight"] = UDim.new(0, 8);
G2L["91"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.Heading
G2L["92"] = Instance.new("Frame", G2L["8f"]);
G2L["92"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["92"]["Name"] = [[Heading]];
G2L["92"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.Heading.Title
G2L["93"] = Instance.new("TextLabel", G2L["92"]);
G2L["93"]["TextSize"] = 20;
G2L["93"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["93"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["93"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["93"]["BackgroundTransparency"] = 1;
G2L["93"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["93"]["Text"] = [[Character]];
G2L["93"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.Character.Heading.Subtitle
G2L["94"] = Instance.new("TextLabel", G2L["92"]);
G2L["94"]["TextSize"] = 11;
G2L["94"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["94"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["94"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["94"]["BackgroundTransparency"] = 1;
G2L["94"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["94"]["Text"] = [[Configure local character behavior.]];
G2L["94"]["Name"] = [[Subtitle]];
G2L["94"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter
G2L["95"] = Instance.new("Frame", G2L["8f"]);
G2L["95"]["BorderSizePixel"] = 0;
G2L["95"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["95"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["95"]["Name"] = [[SpinCharacter]];
G2L["95"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["95"]:SetAttribute([[Enabled]], false);
G2L["95"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["95"]:SetAttribute([[Accent]], Color3.fromRGB(239, 89, 101));


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.UICorner
G2L["96"] = Instance.new("UICorner", G2L["95"]);
G2L["96"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.UIStroke
G2L["97"] = Instance.new("UIStroke", G2L["95"]);
G2L["97"]["Transparency"] = 0.48;
G2L["97"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["97"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Title
G2L["98"] = Instance.new("TextLabel", G2L["95"]);
G2L["98"]["TextSize"] = 14;
G2L["98"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["98"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["98"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["98"]["BackgroundTransparency"] = 1;
G2L["98"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["98"]["Text"] = [[Spin Character]];
G2L["98"]["Name"] = [[Title]];
G2L["98"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Description
G2L["99"] = Instance.new("TextLabel", G2L["95"]);
G2L["99"]["TextSize"] = 10;
G2L["99"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["99"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["99"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["99"]["BackgroundTransparency"] = 1;
G2L["99"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["99"]["Text"] = [[Spin while keeping camera direction stable]];
G2L["99"]["Name"] = [[Description]];
G2L["99"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Switch
G2L["9a"] = Instance.new("TextButton", G2L["95"]);
G2L["9a"]["BorderSizePixel"] = 0;
G2L["9a"]["AutoButtonColor"] = false;
G2L["9a"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["9a"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["9a"]["Text"] = [[]];
G2L["9a"]["Name"] = [[Switch]];
G2L["9a"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Switch.UICorner
G2L["9b"] = Instance.new("UICorner", G2L["9a"]);
G2L["9b"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Switch.Dot
G2L["9c"] = Instance.new("Frame", G2L["9a"]);
G2L["9c"]["BorderSizePixel"] = 0;
G2L["9c"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["9c"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["9c"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["9c"]["Name"] = [[Dot]];
G2L["9c"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinCharacter.Switch.Dot.UICorner
G2L["9d"] = Instance.new("UICorner", G2L["9c"]);
G2L["9d"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed
G2L["9e"] = Instance.new("Frame", G2L["8f"]);
G2L["9e"]["BorderSizePixel"] = 0;
G2L["9e"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["9e"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["9e"]["Name"] = [[SpinSpeed]];
G2L["9e"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["9e"]:SetAttribute([[Minimum]], 1);
G2L["9e"]:SetAttribute([[ControlType]], [[Input]]);
G2L["9e"]:SetAttribute([[Maximum]], 250);
G2L["9e"]:SetAttribute([[Accent]], Color3.fromRGB(239, 89, 101));


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.UICorner
G2L["9f"] = Instance.new("UICorner", G2L["9e"]);
G2L["9f"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.UIStroke
G2L["a0"] = Instance.new("UIStroke", G2L["9e"]);
G2L["a0"]["Transparency"] = 0.48;
G2L["a0"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["a0"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.Title
G2L["a1"] = Instance.new("TextLabel", G2L["9e"]);
G2L["a1"]["TextSize"] = 14;
G2L["a1"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["a1"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["a1"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["a1"]["BackgroundTransparency"] = 1;
G2L["a1"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["a1"]["Text"] = [[Spin Speed]];
G2L["a1"]["Name"] = [[Title]];
G2L["a1"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.Description
G2L["a2"] = Instance.new("TextLabel", G2L["9e"]);
G2L["a2"]["TextSize"] = 10;
G2L["a2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["a2"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["a2"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["a2"]["BackgroundTransparency"] = 1;
G2L["a2"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["a2"]["Text"] = [[Value from 1 to 250]];
G2L["a2"]["Name"] = [[Description]];
G2L["a2"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.Input
G2L["a3"] = Instance.new("TextBox", G2L["9e"]);
G2L["a3"]["Name"] = [[Input]];
G2L["a3"]["BorderSizePixel"] = 0;
G2L["a3"]["TextSize"] = 12;
G2L["a3"]["TextColor3"] = Color3.fromRGB(239, 89, 101);
G2L["a3"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["a3"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["a3"]["ClearTextOnFocus"] = false;
G2L["a3"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["a3"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["a3"]["Text"] = [[25]];


-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.Input.UICorner
G2L["a4"] = Instance.new("UICorner", G2L["a3"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Character.SpinSpeed.Input.UIStroke
G2L["a5"] = Instance.new("UIStroke", G2L["a3"]);
G2L["a5"]["Transparency"] = 0.55;
G2L["a5"]["Color"] = Color3.fromRGB(239, 89, 101);
G2L["a5"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings
G2L["a6"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["a6"]["Visible"] = false;
G2L["a6"]["Active"] = true;
G2L["a6"]["ZIndex"] = 3;
G2L["a6"]["BorderSizePixel"] = 0;
G2L["a6"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["a6"]["Name"] = [[Settings]];
G2L["a6"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["a6"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["a6"]["ScrollBarImageColor3"] = Color3.fromRGB(79, 153, 255);
G2L["a6"]["ScrollBarThickness"] = 3;
G2L["a6"]["LayoutOrder"] = 7;
G2L["a6"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIListLayout
G2L["a7"] = Instance.new("UIListLayout", G2L["a6"]);
G2L["a7"]["Padding"] = UDim.new(0, 10);
G2L["a7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIPadding
G2L["a8"] = Instance.new("UIPadding", G2L["a6"]);
G2L["a8"]["PaddingRight"] = UDim.new(0, 8);
G2L["a8"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.Heading
G2L["a9"] = Instance.new("Frame", G2L["a6"]);
G2L["a9"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["a9"]["Name"] = [[Heading]];
G2L["a9"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.Heading.Title
G2L["aa"] = Instance.new("TextLabel", G2L["a9"]);
G2L["aa"]["TextSize"] = 20;
G2L["aa"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["aa"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["aa"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["aa"]["BackgroundTransparency"] = 1;
G2L["aa"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["aa"]["Text"] = [[Settings]];
G2L["aa"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.Heading.Subtitle
G2L["ab"] = Instance.new("TextLabel", G2L["a9"]);
G2L["ab"]["TextSize"] = 11;
G2L["ab"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["ab"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["ab"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["ab"]["BackgroundTransparency"] = 1;
G2L["ab"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["ab"]["Text"] = [[Personalize the interface and keyboard controls.]];
G2L["ab"]["Name"] = [[Subtitle]];
G2L["ab"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur
G2L["ac"] = Instance.new("Frame", G2L["a6"]);
G2L["ac"]["BorderSizePixel"] = 0;
G2L["ac"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["ac"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["ac"]["Name"] = [[InterfaceBlur]];
G2L["ac"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["ac"]:SetAttribute([[Enabled]], false);
G2L["ac"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["ac"]:SetAttribute([[Accent]], Color3.fromRGB(79, 153, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.UICorner
G2L["ad"] = Instance.new("UICorner", G2L["ac"]);
G2L["ad"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.UIStroke
G2L["ae"] = Instance.new("UIStroke", G2L["ac"]);
G2L["ae"]["Transparency"] = 0.48;
G2L["ae"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["ae"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Title
G2L["af"] = Instance.new("TextLabel", G2L["ac"]);
G2L["af"]["TextSize"] = 14;
G2L["af"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["af"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["af"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["af"]["BackgroundTransparency"] = 1;
G2L["af"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["af"]["Text"] = [[Interface Blur]];
G2L["af"]["Name"] = [[Title]];
G2L["af"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Description
G2L["b0"] = Instance.new("TextLabel", G2L["ac"]);
G2L["b0"]["TextSize"] = 10;
G2L["b0"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b0"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["b0"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["b0"]["BackgroundTransparency"] = 1;
G2L["b0"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["b0"]["Text"] = [[Blur the game while the menu is open]];
G2L["b0"]["Name"] = [[Description]];
G2L["b0"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Switch
G2L["b1"] = Instance.new("TextButton", G2L["ac"]);
G2L["b1"]["BorderSizePixel"] = 0;
G2L["b1"]["AutoButtonColor"] = false;
G2L["b1"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["b1"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["b1"]["Text"] = [[]];
G2L["b1"]["Name"] = [[Switch]];
G2L["b1"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Switch.UICorner
G2L["b2"] = Instance.new("UICorner", G2L["b1"]);
G2L["b2"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Switch.Dot
G2L["b3"] = Instance.new("Frame", G2L["b1"]);
G2L["b3"]["BorderSizePixel"] = 0;
G2L["b3"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["b3"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["b3"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["b3"]["Name"] = [[Dot]];
G2L["b3"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.InterfaceBlur.Switch.Dot.UICorner
G2L["b4"] = Instance.new("UICorner", G2L["b3"]);
G2L["b4"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations
G2L["b5"] = Instance.new("Frame", G2L["a6"]);
G2L["b5"]["BorderSizePixel"] = 0;
G2L["b5"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["b5"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["b5"]["Name"] = [[UIAnimations]];
G2L["b5"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["b5"]:SetAttribute([[Enabled]], false);
G2L["b5"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["b5"]:SetAttribute([[Accent]], Color3.fromRGB(233, 91, 191));


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.UICorner
G2L["b6"] = Instance.new("UICorner", G2L["b5"]);
G2L["b6"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.UIStroke
G2L["b7"] = Instance.new("UIStroke", G2L["b5"]);
G2L["b7"]["Transparency"] = 0.48;
G2L["b7"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["b7"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Title
G2L["b8"] = Instance.new("TextLabel", G2L["b5"]);
G2L["b8"]["TextSize"] = 14;
G2L["b8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b8"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["b8"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["b8"]["BackgroundTransparency"] = 1;
G2L["b8"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["b8"]["Text"] = [[UI Animations]];
G2L["b8"]["Name"] = [[Title]];
G2L["b8"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Description
G2L["b9"] = Instance.new("TextLabel", G2L["b5"]);
G2L["b9"]["TextSize"] = 10;
G2L["b9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b9"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["b9"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["b9"]["BackgroundTransparency"] = 1;
G2L["b9"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["b9"]["Text"] = [[Enable interface transitions]];
G2L["b9"]["Name"] = [[Description]];
G2L["b9"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Switch
G2L["ba"] = Instance.new("TextButton", G2L["b5"]);
G2L["ba"]["BorderSizePixel"] = 0;
G2L["ba"]["AutoButtonColor"] = false;
G2L["ba"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["ba"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["ba"]["Text"] = [[]];
G2L["ba"]["Name"] = [[Switch]];
G2L["ba"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Switch.UICorner
G2L["bb"] = Instance.new("UICorner", G2L["ba"]);
G2L["bb"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Switch.Dot
G2L["bc"] = Instance.new("Frame", G2L["ba"]);
G2L["bc"]["BorderSizePixel"] = 0;
G2L["bc"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["bc"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["bc"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["bc"]["Name"] = [[Dot]];
G2L["bc"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.UIAnimations.Switch.Dot.UICorner
G2L["bd"] = Instance.new("UICorner", G2L["bc"]);
G2L["bd"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind
G2L["be"] = Instance.new("Frame", G2L["a6"]);
G2L["be"]["BorderSizePixel"] = 0;
G2L["be"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["be"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["be"]["Name"] = [[MenuBind]];
G2L["be"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["be"]:SetAttribute([[Key]], [[LeftShift]]);
G2L["be"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.UICorner
G2L["bf"] = Instance.new("UICorner", G2L["be"]);
G2L["bf"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.UIStroke
G2L["c0"] = Instance.new("UIStroke", G2L["be"]);
G2L["c0"]["Transparency"] = 0.48;
G2L["c0"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["c0"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.Title
G2L["c1"] = Instance.new("TextLabel", G2L["be"]);
G2L["c1"]["TextSize"] = 14;
G2L["c1"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["c1"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["c1"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["c1"]["BackgroundTransparency"] = 1;
G2L["c1"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["c1"]["Text"] = [[Menu Keybind]];
G2L["c1"]["Name"] = [[Title]];
G2L["c1"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.Description
G2L["c2"] = Instance.new("TextLabel", G2L["be"]);
G2L["c2"]["TextSize"] = 10;
G2L["c2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["c2"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["c2"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["c2"]["BackgroundTransparency"] = 1;
G2L["c2"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["c2"]["Text"] = [[Open or close Ryzox Client]];
G2L["c2"]["Name"] = [[Description]];
G2L["c2"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.BindButton
G2L["c3"] = Instance.new("TextButton", G2L["be"]);
G2L["c3"]["BorderSizePixel"] = 0;
G2L["c3"]["TextSize"] = 11;
G2L["c3"]["AutoButtonColor"] = false;
G2L["c3"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["c3"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["c3"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["c3"]["Size"] = UDim2.new(0, 72, 0, 30);
G2L["c3"]["Text"] = [[LeftShift]];
G2L["c3"]["Name"] = [[BindButton]];
G2L["c3"]["Position"] = UDim2.new(1, -136, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.BindButton.UICorner
G2L["c4"] = Instance.new("UICorner", G2L["c3"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.BindButton.UIStroke
G2L["c5"] = Instance.new("UIStroke", G2L["c3"]);
G2L["c5"]["Transparency"] = 0.42;
G2L["c5"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["c5"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.Reset
G2L["c6"] = Instance.new("TextButton", G2L["be"]);
G2L["c6"]["BorderSizePixel"] = 0;
G2L["c6"]["TextSize"] = 10;
G2L["c6"]["AutoButtonColor"] = false;
G2L["c6"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["c6"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["c6"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["c6"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["c6"]["Text"] = [[Reset]];
G2L["c6"]["Name"] = [[Reset]];
G2L["c6"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.Reset.UICorner
G2L["c7"] = Instance.new("UICorner", G2L["c6"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.MenuBind.Reset.UIStroke
G2L["c8"] = Instance.new("UIStroke", G2L["c6"]);
G2L["c8"]["Transparency"] = 0.5;
G2L["c8"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["c8"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind
G2L["c9"] = Instance.new("Frame", G2L["a6"]);
G2L["c9"]["BorderSizePixel"] = 0;
G2L["c9"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["c9"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["c9"]["Name"] = [[CameraBind]];
G2L["c9"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["c9"]:SetAttribute([[Key]], [[E]]);
G2L["c9"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.UICorner
G2L["ca"] = Instance.new("UICorner", G2L["c9"]);
G2L["ca"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.UIStroke
G2L["cb"] = Instance.new("UIStroke", G2L["c9"]);
G2L["cb"]["Transparency"] = 0.48;
G2L["cb"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["cb"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.Title
G2L["cc"] = Instance.new("TextLabel", G2L["c9"]);
G2L["cc"]["TextSize"] = 14;
G2L["cc"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["cc"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["cc"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["cc"]["BackgroundTransparency"] = 1;
G2L["cc"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["cc"]["Text"] = [[Camera Keybind]];
G2L["cc"]["Name"] = [[Title]];
G2L["cc"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.Description
G2L["cd"] = Instance.new("TextLabel", G2L["c9"]);
G2L["cd"]["TextSize"] = 10;
G2L["cd"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["cd"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["cd"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["cd"]["BackgroundTransparency"] = 1;
G2L["cd"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["cd"]["Text"] = [[Toggle Camera Unlock]];
G2L["cd"]["Name"] = [[Description]];
G2L["cd"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.BindButton
G2L["ce"] = Instance.new("TextButton", G2L["c9"]);
G2L["ce"]["BorderSizePixel"] = 0;
G2L["ce"]["TextSize"] = 11;
G2L["ce"]["AutoButtonColor"] = false;
G2L["ce"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["ce"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["ce"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["ce"]["Size"] = UDim2.new(0, 72, 0, 30);
G2L["ce"]["Text"] = [[E]];
G2L["ce"]["Name"] = [[BindButton]];
G2L["ce"]["Position"] = UDim2.new(1, -136, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.BindButton.UICorner
G2L["cf"] = Instance.new("UICorner", G2L["ce"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.BindButton.UIStroke
G2L["d0"] = Instance.new("UIStroke", G2L["ce"]);
G2L["d0"]["Transparency"] = 0.42;
G2L["d0"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["d0"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.Reset
G2L["d1"] = Instance.new("TextButton", G2L["c9"]);
G2L["d1"]["BorderSizePixel"] = 0;
G2L["d1"]["TextSize"] = 10;
G2L["d1"]["AutoButtonColor"] = false;
G2L["d1"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["d1"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["d1"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["d1"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["d1"]["Text"] = [[Reset]];
G2L["d1"]["Name"] = [[Reset]];
G2L["d1"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.Reset.UICorner
G2L["d2"] = Instance.new("UICorner", G2L["d1"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraBind.Reset.UIStroke
G2L["d3"] = Instance.new("UIStroke", G2L["d1"]);
G2L["d3"]["Transparency"] = 0.5;
G2L["d3"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["d3"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind
G2L["d4"] = Instance.new("Frame", G2L["a6"]);
G2L["d4"]["BorderSizePixel"] = 0;
G2L["d4"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["d4"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["d4"]["Name"] = [[SpeedBind]];
G2L["d4"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["d4"]:SetAttribute([[Key]], [[V]]);
G2L["d4"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.UICorner
G2L["d5"] = Instance.new("UICorner", G2L["d4"]);
G2L["d5"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.UIStroke
G2L["d6"] = Instance.new("UIStroke", G2L["d4"]);
G2L["d6"]["Transparency"] = 0.48;
G2L["d6"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["d6"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.Title
G2L["d7"] = Instance.new("TextLabel", G2L["d4"]);
G2L["d7"]["TextSize"] = 14;
G2L["d7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["d7"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["d7"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["d7"]["BackgroundTransparency"] = 1;
G2L["d7"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["d7"]["Text"] = [[Speed Keybind]];
G2L["d7"]["Name"] = [[Title]];
G2L["d7"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.Description
G2L["d8"] = Instance.new("TextLabel", G2L["d4"]);
G2L["d8"]["TextSize"] = 10;
G2L["d8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["d8"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["d8"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["d8"]["BackgroundTransparency"] = 1;
G2L["d8"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["d8"]["Text"] = [[Toggle Speed Boost]];
G2L["d8"]["Name"] = [[Description]];
G2L["d8"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.BindButton
G2L["d9"] = Instance.new("TextButton", G2L["d4"]);
G2L["d9"]["BorderSizePixel"] = 0;
G2L["d9"]["TextSize"] = 11;
G2L["d9"]["AutoButtonColor"] = false;
G2L["d9"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["d9"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["d9"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["d9"]["Size"] = UDim2.new(0, 72, 0, 30);
G2L["d9"]["Text"] = [[V]];
G2L["d9"]["Name"] = [[BindButton]];
G2L["d9"]["Position"] = UDim2.new(1, -136, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.BindButton.UICorner
G2L["da"] = Instance.new("UICorner", G2L["d9"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.BindButton.UIStroke
G2L["db"] = Instance.new("UIStroke", G2L["d9"]);
G2L["db"]["Transparency"] = 0.42;
G2L["db"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["db"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.Reset
G2L["dc"] = Instance.new("TextButton", G2L["d4"]);
G2L["dc"]["BorderSizePixel"] = 0;
G2L["dc"]["TextSize"] = 10;
G2L["dc"]["AutoButtonColor"] = false;
G2L["dc"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["dc"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["dc"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["dc"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["dc"]["Text"] = [[Reset]];
G2L["dc"]["Name"] = [[Reset]];
G2L["dc"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.Reset.UICorner
G2L["dd"] = Instance.new("UICorner", G2L["dc"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpeedBind.Reset.UIStroke
G2L["de"] = Instance.new("UIStroke", G2L["dc"]);
G2L["de"]["Transparency"] = 0.5;
G2L["de"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["de"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind
G2L["df"] = Instance.new("Frame", G2L["a6"]);
G2L["df"]["BorderSizePixel"] = 0;
G2L["df"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["df"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["df"]["Name"] = [[JumpBind]];
G2L["df"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["df"]:SetAttribute([[Key]], [[B]]);
G2L["df"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.UICorner
G2L["e0"] = Instance.new("UICorner", G2L["df"]);
G2L["e0"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.UIStroke
G2L["e1"] = Instance.new("UIStroke", G2L["df"]);
G2L["e1"]["Transparency"] = 0.48;
G2L["e1"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["e1"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.Title
G2L["e2"] = Instance.new("TextLabel", G2L["df"]);
G2L["e2"]["TextSize"] = 14;
G2L["e2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["e2"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["e2"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["e2"]["BackgroundTransparency"] = 1;
G2L["e2"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["e2"]["Text"] = [[Jump Keybind]];
G2L["e2"]["Name"] = [[Title]];
G2L["e2"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.Description
G2L["e3"] = Instance.new("TextLabel", G2L["df"]);
G2L["e3"]["TextSize"] = 10;
G2L["e3"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["e3"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["e3"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["e3"]["BackgroundTransparency"] = 1;
G2L["e3"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["e3"]["Text"] = [[Toggle Jump Boost]];
G2L["e3"]["Name"] = [[Description]];
G2L["e3"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.BindButton
G2L["e4"] = Instance.new("TextButton", G2L["df"]);
G2L["e4"]["BorderSizePixel"] = 0;
G2L["e4"]["TextSize"] = 11;
G2L["e4"]["AutoButtonColor"] = false;
G2L["e4"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["e4"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["e4"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["e4"]["Size"] = UDim2.new(0, 72, 0, 30);
G2L["e4"]["Text"] = [[B]];
G2L["e4"]["Name"] = [[BindButton]];
G2L["e4"]["Position"] = UDim2.new(1, -136, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.BindButton.UICorner
G2L["e5"] = Instance.new("UICorner", G2L["e4"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.BindButton.UIStroke
G2L["e6"] = Instance.new("UIStroke", G2L["e4"]);
G2L["e6"]["Transparency"] = 0.42;
G2L["e6"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["e6"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.Reset
G2L["e7"] = Instance.new("TextButton", G2L["df"]);
G2L["e7"]["BorderSizePixel"] = 0;
G2L["e7"]["TextSize"] = 10;
G2L["e7"]["AutoButtonColor"] = false;
G2L["e7"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["e7"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["e7"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["e7"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["e7"]["Text"] = [[Reset]];
G2L["e7"]["Name"] = [[Reset]];
G2L["e7"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.Reset.UICorner
G2L["e8"] = Instance.new("UICorner", G2L["e7"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.JumpBind.Reset.UIStroke
G2L["e9"] = Instance.new("UIStroke", G2L["e7"]);
G2L["e9"]["Transparency"] = 0.5;
G2L["e9"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["e9"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind
G2L["ea"] = Instance.new("Frame", G2L["a6"]);
G2L["ea"]["BorderSizePixel"] = 0;
G2L["ea"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["ea"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["ea"]["Name"] = [[SpinBind]];
G2L["ea"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["ea"]:SetAttribute([[Key]], [[N]]);
G2L["ea"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.UICorner
G2L["eb"] = Instance.new("UICorner", G2L["ea"]);
G2L["eb"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.UIStroke
G2L["ec"] = Instance.new("UIStroke", G2L["ea"]);
G2L["ec"]["Transparency"] = 0.48;
G2L["ec"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["ec"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.Title
G2L["ed"] = Instance.new("TextLabel", G2L["ea"]);
G2L["ed"]["TextSize"] = 14;
G2L["ed"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["ed"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["ed"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["ed"]["BackgroundTransparency"] = 1;
G2L["ed"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["ed"]["Text"] = [[Spin Keybind]];
G2L["ed"]["Name"] = [[Title]];
G2L["ed"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.Description
G2L["ee"] = Instance.new("TextLabel", G2L["ea"]);
G2L["ee"]["TextSize"] = 10;
G2L["ee"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["ee"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["ee"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["ee"]["BackgroundTransparency"] = 1;
G2L["ee"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["ee"]["Text"] = [[Toggle Character Spin]];
G2L["ee"]["Name"] = [[Description]];
G2L["ee"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.BindButton
G2L["ef"] = Instance.new("TextButton", G2L["ea"]);
G2L["ef"]["BorderSizePixel"] = 0;
G2L["ef"]["TextSize"] = 11;
G2L["ef"]["AutoButtonColor"] = false;
G2L["ef"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["ef"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["ef"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["ef"]["Size"] = UDim2.new(0, 72, 0, 30);
G2L["ef"]["Text"] = [[N]];
G2L["ef"]["Name"] = [[BindButton]];
G2L["ef"]["Position"] = UDim2.new(1, -136, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.BindButton.UICorner
G2L["f0"] = Instance.new("UICorner", G2L["ef"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.BindButton.UIStroke
G2L["f1"] = Instance.new("UIStroke", G2L["ef"]);
G2L["f1"]["Transparency"] = 0.42;
G2L["f1"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["f1"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.Reset
G2L["f2"] = Instance.new("TextButton", G2L["ea"]);
G2L["f2"]["BorderSizePixel"] = 0;
G2L["f2"]["TextSize"] = 10;
G2L["f2"]["AutoButtonColor"] = false;
G2L["f2"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["f2"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["f2"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["f2"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["f2"]["Text"] = [[Reset]];
G2L["f2"]["Name"] = [[Reset]];
G2L["f2"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.Reset.UICorner
G2L["f3"] = Instance.new("UICorner", G2L["f2"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.SpinBind.Reset.UIStroke
G2L["f4"] = Instance.new("UIStroke", G2L["f2"]);
G2L["f4"]["Transparency"] = 0.5;
G2L["f4"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["f4"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind
G2L["f5"] = Instance.new("Frame", G2L["a6"]);
G2L["f5"]["BorderSizePixel"] = 0;
G2L["f5"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["f5"]["Size"] = UDim2.new(1, 0, 0, 74);
G2L["f5"]["Name"] = [[CameraLockBind]];
G2L["f5"]["LayoutOrder"] = 99;
G2L["f5"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["f5"]:SetAttribute([[Key]], [[]]);
G2L["f5"]:SetAttribute([[ControlType]], [[Bind]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.UICorner
G2L["f6"] = Instance.new("UICorner", G2L["f5"]);
G2L["f6"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.UIStroke
G2L["f7"] = Instance.new("UIStroke", G2L["f5"]);
G2L["f7"]["Transparency"] = 0.48;
G2L["f7"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["f7"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.Title
G2L["f8"] = Instance.new("TextLabel", G2L["f5"]);
G2L["f8"]["TextSize"] = 14;
G2L["f8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["f8"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["f8"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["f8"]["BackgroundTransparency"] = 1;
G2L["f8"]["Size"] = UDim2.new(1, -188, 0, 20);
G2L["f8"]["Text"] = [[Camera Lock Keybind]];
G2L["f8"]["Name"] = [[Title]];
G2L["f8"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.Description
G2L["f9"] = Instance.new("TextLabel", G2L["f5"]);
G2L["f9"]["TextSize"] = 10;
G2L["f9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["f9"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["f9"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["f9"]["BackgroundTransparency"] = 1;
G2L["f9"]["Size"] = UDim2.new(1, -188, 0, 18);
G2L["f9"]["Text"] = [[Toggle Camera Lock]];
G2L["f9"]["Name"] = [[Description]];
G2L["f9"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.BindButton
G2L["fa"] = Instance.new("TextButton", G2L["f5"]);
G2L["fa"]["BorderSizePixel"] = 0;
G2L["fa"]["TextSize"] = 10;
G2L["fa"]["AutoButtonColor"] = false;
G2L["fa"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["fa"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["fa"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["fa"]["Size"] = UDim2.new(0, 96, 0, 30);
G2L["fa"]["Text"] = [[None]];
G2L["fa"]["Name"] = [[BindButton]];
G2L["fa"]["Position"] = UDim2.new(1, -160, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.BindButton.UICorner
G2L["fb"] = Instance.new("UICorner", G2L["fa"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.BindButton.UIStroke
G2L["fc"] = Instance.new("UIStroke", G2L["fa"]);
G2L["fc"]["Transparency"] = 0.42;
G2L["fc"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["fc"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.Reset
G2L["fd"] = Instance.new("TextButton", G2L["f5"]);
G2L["fd"]["BorderSizePixel"] = 0;
G2L["fd"]["TextSize"] = 10;
G2L["fd"]["AutoButtonColor"] = false;
G2L["fd"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["fd"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["fd"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["fd"]["Size"] = UDim2.new(0, 52, 0, 30);
G2L["fd"]["Text"] = [[Reset]];
G2L["fd"]["Name"] = [[Reset]];
G2L["fd"]["Position"] = UDim2.new(1, -58, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.Reset.UICorner
G2L["fe"] = Instance.new("UICorner", G2L["fd"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Settings.CameraLockBind.Reset.UIStroke
G2L["ff"] = Instance.new("UIStroke", G2L["fd"]);
G2L["ff"]["Transparency"] = 0.5;
G2L["ff"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["ff"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual
G2L["100"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["100"]["Visible"] = false;
G2L["100"]["Active"] = true;
G2L["100"]["BorderSizePixel"] = 0;
G2L["100"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["100"]["Name"] = [[Visual]];
G2L["100"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["100"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["100"]["ScrollBarImageColor3"] = Color3.fromRGB(155, 106, 255);
G2L["100"]["ScrollBarThickness"] = 3;
G2L["100"]["LayoutOrder"] = 6;
G2L["100"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.UIListLayout
G2L["101"] = Instance.new("UIListLayout", G2L["100"]);
G2L["101"]["Padding"] = UDim.new(0, 10);
G2L["101"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.UIPadding
G2L["102"] = Instance.new("UIPadding", G2L["100"]);
G2L["102"]["PaddingRight"] = UDim.new(0, 8);
G2L["102"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Heading
G2L["103"] = Instance.new("Frame", G2L["100"]);
G2L["103"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["103"]["Name"] = [[Heading]];
G2L["103"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Heading.Title
G2L["104"] = Instance.new("TextLabel", G2L["103"]);
G2L["104"]["TextSize"] = 20;
G2L["104"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["104"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["104"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["104"]["BackgroundTransparency"] = 1;
G2L["104"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["104"]["Text"] = [[Visual]];
G2L["104"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Heading.Subtitle
G2L["105"] = Instance.new("TextLabel", G2L["103"]);
G2L["105"]["TextSize"] = 11;
G2L["105"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["105"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["105"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["105"]["BackgroundTransparency"] = 1;
G2L["105"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["105"]["Text"] = [[Configure ESP and tracer visuals.]];
G2L["105"]["Name"] = [[Subtitle]];
G2L["105"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP
G2L["106"] = Instance.new("Frame", G2L["100"]);
G2L["106"]["BorderSizePixel"] = 0;
G2L["106"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["106"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["106"]["Name"] = [[ESP]];
G2L["106"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["106"]:SetAttribute([[Enabled]], false);
G2L["106"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["106"]:SetAttribute([[Accent]], Color3.fromRGB(155, 106, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.UICorner
G2L["107"] = Instance.new("UICorner", G2L["106"]);
G2L["107"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.UIStroke
G2L["108"] = Instance.new("UIStroke", G2L["106"]);
G2L["108"]["Transparency"] = 0.48;
G2L["108"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["108"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Title
G2L["109"] = Instance.new("TextLabel", G2L["106"]);
G2L["109"]["TextSize"] = 14;
G2L["109"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["109"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["109"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["109"]["BackgroundTransparency"] = 1;
G2L["109"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["109"]["Text"] = [[ESP]];
G2L["109"]["Name"] = [[Title]];
G2L["109"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Description
G2L["10a"] = Instance.new("TextLabel", G2L["106"]);
G2L["10a"]["TextSize"] = 10;
G2L["10a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["10a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["10a"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["10a"]["BackgroundTransparency"] = 1;
G2L["10a"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["10a"]["Text"] = [[Highlight targets and display names]];
G2L["10a"]["Name"] = [[Description]];
G2L["10a"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Switch
G2L["10b"] = Instance.new("TextButton", G2L["106"]);
G2L["10b"]["BorderSizePixel"] = 0;
G2L["10b"]["AutoButtonColor"] = false;
G2L["10b"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["10b"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["10b"]["Text"] = [[]];
G2L["10b"]["Name"] = [[Switch]];
G2L["10b"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Switch.UICorner
G2L["10c"] = Instance.new("UICorner", G2L["10b"]);
G2L["10c"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Switch.Dot
G2L["10d"] = Instance.new("Frame", G2L["10b"]);
G2L["10d"]["BorderSizePixel"] = 0;
G2L["10d"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["10d"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["10d"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["10d"]["Name"] = [[Dot]];
G2L["10d"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESP.Switch.Dot.UICorner
G2L["10e"] = Instance.new("UICorner", G2L["10d"]);
G2L["10e"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize
G2L["10f"] = Instance.new("Frame", G2L["100"]);
G2L["10f"]["BorderSizePixel"] = 0;
G2L["10f"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["10f"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["10f"]["Name"] = [[ESPSize]];
G2L["10f"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["10f"]:SetAttribute([[Minimum]], 10);
G2L["10f"]:SetAttribute([[ControlType]], [[Input]]);
G2L["10f"]:SetAttribute([[Maximum]], 50);
G2L["10f"]:SetAttribute([[Accent]], Color3.fromRGB(155, 106, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.UICorner
G2L["110"] = Instance.new("UICorner", G2L["10f"]);
G2L["110"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.UIStroke
G2L["111"] = Instance.new("UIStroke", G2L["10f"]);
G2L["111"]["Transparency"] = 0.48;
G2L["111"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["111"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.Title
G2L["112"] = Instance.new("TextLabel", G2L["10f"]);
G2L["112"]["TextSize"] = 14;
G2L["112"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["112"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["112"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["112"]["BackgroundTransparency"] = 1;
G2L["112"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["112"]["Text"] = [[ESP Size]];
G2L["112"]["Name"] = [[Title]];
G2L["112"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.Description
G2L["113"] = Instance.new("TextLabel", G2L["10f"]);
G2L["113"]["TextSize"] = 10;
G2L["113"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["113"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["113"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["113"]["BackgroundTransparency"] = 1;
G2L["113"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["113"]["Text"] = [[Username label size from 10 to 50]];
G2L["113"]["Name"] = [[Description]];
G2L["113"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.Input
G2L["114"] = Instance.new("TextBox", G2L["10f"]);
G2L["114"]["Name"] = [[Input]];
G2L["114"]["BorderSizePixel"] = 0;
G2L["114"]["TextSize"] = 12;
G2L["114"]["TextColor3"] = Color3.fromRGB(155, 106, 255);
G2L["114"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["114"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["114"]["ClearTextOnFocus"] = false;
G2L["114"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["114"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["114"]["Text"] = [[16]];


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.Input.UICorner
G2L["115"] = Instance.new("UICorner", G2L["114"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPSize.Input.UIStroke
G2L["116"] = Instance.new("UIStroke", G2L["114"]);
G2L["116"]["Transparency"] = 0.55;
G2L["116"]["Color"] = Color3.fromRGB(155, 106, 255);
G2L["116"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor
G2L["117"] = Instance.new("Frame", G2L["100"]);
G2L["117"]["BorderSizePixel"] = 0;
G2L["117"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["117"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["117"]["Name"] = [[ESPColor]];
G2L["117"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["117"]:SetAttribute([[DefaultColor]], [[#9A69FF]]);
G2L["117"]:SetAttribute([[ControlType]], [[Color]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.UICorner
G2L["118"] = Instance.new("UICorner", G2L["117"]);
G2L["118"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.UIStroke
G2L["119"] = Instance.new("UIStroke", G2L["117"]);
G2L["119"]["Transparency"] = 0.48;
G2L["119"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["119"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.Title
G2L["11a"] = Instance.new("TextLabel", G2L["117"]);
G2L["11a"]["TextSize"] = 14;
G2L["11a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["11a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["11a"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["11a"]["BackgroundTransparency"] = 1;
G2L["11a"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["11a"]["Text"] = [[ESP Color]];
G2L["11a"]["Name"] = [[Title]];
G2L["11a"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.Description
G2L["11b"] = Instance.new("TextLabel", G2L["117"]);
G2L["11b"]["TextSize"] = 10;
G2L["11b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["11b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["11b"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["11b"]["BackgroundTransparency"] = 1;
G2L["11b"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["11b"]["Text"] = [[Hex color, for example: #9A69FF]];
G2L["11b"]["Name"] = [[Description]];
G2L["11b"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.Input
G2L["11c"] = Instance.new("TextBox", G2L["117"]);
G2L["11c"]["Name"] = [[Input]];
G2L["11c"]["BorderSizePixel"] = 0;
G2L["11c"]["TextSize"] = 11;
G2L["11c"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["11c"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["11c"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["11c"]["ClearTextOnFocus"] = false;
G2L["11c"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["11c"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["11c"]["Text"] = [[#9A69FF]];


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.Input.UICorner
G2L["11d"] = Instance.new("UICorner", G2L["11c"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ESPColor.Input.UIStroke
G2L["11e"] = Instance.new("UIStroke", G2L["11c"]);
G2L["11e"]["Transparency"] = 0.4;
G2L["11e"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["11e"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers
G2L["11f"] = Instance.new("Frame", G2L["100"]);
G2L["11f"]["BorderSizePixel"] = 0;
G2L["11f"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["11f"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["11f"]["Name"] = [[Tracers]];
G2L["11f"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["11f"]:SetAttribute([[Enabled]], false);
G2L["11f"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["11f"]:SetAttribute([[Accent]], Color3.fromRGB(79, 153, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.UICorner
G2L["120"] = Instance.new("UICorner", G2L["11f"]);
G2L["120"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.UIStroke
G2L["121"] = Instance.new("UIStroke", G2L["11f"]);
G2L["121"]["Transparency"] = 0.48;
G2L["121"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["121"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Title
G2L["122"] = Instance.new("TextLabel", G2L["11f"]);
G2L["122"]["TextSize"] = 14;
G2L["122"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["122"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["122"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["122"]["BackgroundTransparency"] = 1;
G2L["122"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["122"]["Text"] = [[Tracers]];
G2L["122"]["Name"] = [[Title]];
G2L["122"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Description
G2L["123"] = Instance.new("TextLabel", G2L["11f"]);
G2L["123"]["TextSize"] = 10;
G2L["123"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["123"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["123"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["123"]["BackgroundTransparency"] = 1;
G2L["123"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["123"]["Text"] = [[Draw lines from the bottom of your screen]];
G2L["123"]["Name"] = [[Description]];
G2L["123"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Switch
G2L["124"] = Instance.new("TextButton", G2L["11f"]);
G2L["124"]["BorderSizePixel"] = 0;
G2L["124"]["AutoButtonColor"] = false;
G2L["124"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["124"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["124"]["Text"] = [[]];
G2L["124"]["Name"] = [[Switch]];
G2L["124"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Switch.UICorner
G2L["125"] = Instance.new("UICorner", G2L["124"]);
G2L["125"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Switch.Dot
G2L["126"] = Instance.new("Frame", G2L["124"]);
G2L["126"]["BorderSizePixel"] = 0;
G2L["126"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["126"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["126"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["126"]["Name"] = [[Dot]];
G2L["126"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.Tracers.Switch.Dot.UICorner
G2L["127"] = Instance.new("UICorner", G2L["126"]);
G2L["127"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance
G2L["128"] = Instance.new("Frame", G2L["100"]);
G2L["128"]["BorderSizePixel"] = 0;
G2L["128"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["128"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["128"]["Name"] = [[TracerDistance]];
G2L["128"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["128"]:SetAttribute([[Minimum]], 50);
G2L["128"]:SetAttribute([[ControlType]], [[Input]]);
G2L["128"]:SetAttribute([[Maximum]], 5000);
G2L["128"]:SetAttribute([[Accent]], Color3.fromRGB(79, 153, 255));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.UICorner
G2L["129"] = Instance.new("UICorner", G2L["128"]);
G2L["129"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.UIStroke
G2L["12a"] = Instance.new("UIStroke", G2L["128"]);
G2L["12a"]["Transparency"] = 0.48;
G2L["12a"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["12a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.Title
G2L["12b"] = Instance.new("TextLabel", G2L["128"]);
G2L["12b"]["TextSize"] = 14;
G2L["12b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["12b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["12b"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["12b"]["BackgroundTransparency"] = 1;
G2L["12b"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["12b"]["Text"] = [[Tracer Distance]];
G2L["12b"]["Name"] = [[Title]];
G2L["12b"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.Description
G2L["12c"] = Instance.new("TextLabel", G2L["128"]);
G2L["12c"]["TextSize"] = 10;
G2L["12c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["12c"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["12c"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["12c"]["BackgroundTransparency"] = 1;
G2L["12c"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["12c"]["Text"] = [[Maximum tracer distance from 50 to 5000]];
G2L["12c"]["Name"] = [[Description]];
G2L["12c"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.Input
G2L["12d"] = Instance.new("TextBox", G2L["128"]);
G2L["12d"]["Name"] = [[Input]];
G2L["12d"]["BorderSizePixel"] = 0;
G2L["12d"]["TextSize"] = 12;
G2L["12d"]["TextColor3"] = Color3.fromRGB(79, 153, 255);
G2L["12d"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["12d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["12d"]["ClearTextOnFocus"] = false;
G2L["12d"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["12d"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["12d"]["Text"] = [[1500]];


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.Input.UICorner
G2L["12e"] = Instance.new("UICorner", G2L["12d"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerDistance.Input.UIStroke
G2L["12f"] = Instance.new("UIStroke", G2L["12d"]);
G2L["12f"]["Transparency"] = 0.55;
G2L["12f"]["Color"] = Color3.fromRGB(79, 153, 255);
G2L["12f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor
G2L["130"] = Instance.new("Frame", G2L["100"]);
G2L["130"]["BorderSizePixel"] = 0;
G2L["130"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["130"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["130"]["Name"] = [[TracerColor]];
G2L["130"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["130"]:SetAttribute([[DefaultColor]], [[#4E98FF]]);
G2L["130"]:SetAttribute([[ControlType]], [[Color]]);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.UICorner
G2L["131"] = Instance.new("UICorner", G2L["130"]);
G2L["131"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.UIStroke
G2L["132"] = Instance.new("UIStroke", G2L["130"]);
G2L["132"]["Transparency"] = 0.48;
G2L["132"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["132"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.Title
G2L["133"] = Instance.new("TextLabel", G2L["130"]);
G2L["133"]["TextSize"] = 14;
G2L["133"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["133"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["133"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["133"]["BackgroundTransparency"] = 1;
G2L["133"]["Size"] = UDim2.new(1, -140, 0, 20);
G2L["133"]["Text"] = [[Tracer Color]];
G2L["133"]["Name"] = [[Title]];
G2L["133"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.Description
G2L["134"] = Instance.new("TextLabel", G2L["130"]);
G2L["134"]["TextSize"] = 10;
G2L["134"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["134"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["134"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["134"]["BackgroundTransparency"] = 1;
G2L["134"]["Size"] = UDim2.new(1, -140, 0, 18);
G2L["134"]["Text"] = [[Hex color, for example: #4E98FF]];
G2L["134"]["Name"] = [[Description]];
G2L["134"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.Input
G2L["135"] = Instance.new("TextBox", G2L["130"]);
G2L["135"]["Name"] = [[Input]];
G2L["135"]["BorderSizePixel"] = 0;
G2L["135"]["TextSize"] = 11;
G2L["135"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["135"]["BackgroundColor3"] = Color3.fromRGB(19, 22, 30);
G2L["135"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["135"]["ClearTextOnFocus"] = false;
G2L["135"]["Size"] = UDim2.new(0, 98, 0, 30);
G2L["135"]["Position"] = UDim2.new(1, -117, 0.5, -15);
G2L["135"]["Text"] = [[#4E98FF]];


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.Input.UICorner
G2L["136"] = Instance.new("UICorner", G2L["135"]);



-- StarterGui.RyzoxClient.Main.PageContainer.Visual.TracerColor.Input.UIStroke
G2L["137"] = Instance.new("UIStroke", G2L["135"]);
G2L["137"]["Transparency"] = 0.4;
G2L["137"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["137"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals
G2L["138"] = Instance.new("Frame", G2L["100"]);
G2L["138"]["BorderSizePixel"] = 0;
G2L["138"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["138"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["138"]["Name"] = [[RainbowVisuals]];
G2L["138"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["138"]:SetAttribute([[Enabled]], false);
G2L["138"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["138"]:SetAttribute([[Accent]], Color3.fromRGB(233, 91, 191));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.UICorner
G2L["139"] = Instance.new("UICorner", G2L["138"]);
G2L["139"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.UIStroke
G2L["13a"] = Instance.new("UIStroke", G2L["138"]);
G2L["13a"]["Transparency"] = 0.48;
G2L["13a"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["13a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Title
G2L["13b"] = Instance.new("TextLabel", G2L["138"]);
G2L["13b"]["TextSize"] = 14;
G2L["13b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["13b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["13b"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["13b"]["BackgroundTransparency"] = 1;
G2L["13b"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["13b"]["Text"] = [[Rainbow Colors]];
G2L["13b"]["Name"] = [[Title]];
G2L["13b"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Description
G2L["13c"] = Instance.new("TextLabel", G2L["138"]);
G2L["13c"]["TextSize"] = 10;
G2L["13c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["13c"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["13c"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["13c"]["BackgroundTransparency"] = 1;
G2L["13c"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["13c"]["Text"] = [[Continuously cycle ESP and tracer colors]];
G2L["13c"]["Name"] = [[Description]];
G2L["13c"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Switch
G2L["13d"] = Instance.new("TextButton", G2L["138"]);
G2L["13d"]["BorderSizePixel"] = 0;
G2L["13d"]["AutoButtonColor"] = false;
G2L["13d"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["13d"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["13d"]["Text"] = [[]];
G2L["13d"]["Name"] = [[Switch]];
G2L["13d"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Switch.UICorner
G2L["13e"] = Instance.new("UICorner", G2L["13d"]);
G2L["13e"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Switch.Dot
G2L["13f"] = Instance.new("Frame", G2L["13d"]);
G2L["13f"]["BorderSizePixel"] = 0;
G2L["13f"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["13f"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["13f"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["13f"]["Name"] = [[Dot]];
G2L["13f"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.RainbowVisuals.Switch.Dot.UICorner
G2L["140"] = Instance.new("UICorner", G2L["13f"]);
G2L["140"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername
G2L["141"] = Instance.new("Frame", G2L["100"]);
G2L["141"]["BorderSizePixel"] = 0;
G2L["141"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["141"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["141"]["Name"] = [[ShowUsername]];
G2L["141"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["141"]:SetAttribute([[Enabled]], false);
G2L["141"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["141"]:SetAttribute([[Accent]], Color3.fromRGB(53, 207, 138));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.UICorner
G2L["142"] = Instance.new("UICorner", G2L["141"]);
G2L["142"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.UIStroke
G2L["143"] = Instance.new("UIStroke", G2L["141"]);
G2L["143"]["Transparency"] = 0.48;
G2L["143"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["143"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Title
G2L["144"] = Instance.new("TextLabel", G2L["141"]);
G2L["144"]["TextSize"] = 14;
G2L["144"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["144"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["144"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["144"]["BackgroundTransparency"] = 1;
G2L["144"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["144"]["Text"] = [[Show Username]];
G2L["144"]["Name"] = [[Title]];
G2L["144"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Description
G2L["145"] = Instance.new("TextLabel", G2L["141"]);
G2L["145"]["TextSize"] = 10;
G2L["145"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["145"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["145"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["145"]["BackgroundTransparency"] = 1;
G2L["145"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["145"]["Text"] = [[Display player usernames above targets]];
G2L["145"]["Name"] = [[Description]];
G2L["145"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Switch
G2L["146"] = Instance.new("TextButton", G2L["141"]);
G2L["146"]["BorderSizePixel"] = 0;
G2L["146"]["AutoButtonColor"] = false;
G2L["146"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["146"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["146"]["Text"] = [[]];
G2L["146"]["Name"] = [[Switch]];
G2L["146"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Switch.UICorner
G2L["147"] = Instance.new("UICorner", G2L["146"]);
G2L["147"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Switch.Dot
G2L["148"] = Instance.new("Frame", G2L["146"]);
G2L["148"]["BorderSizePixel"] = 0;
G2L["148"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["148"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["148"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["148"]["Name"] = [[Dot]];
G2L["148"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.ShowUsername.Switch.Dot.UICorner
G2L["149"] = Instance.new("UICorner", G2L["148"]);
G2L["149"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers
G2L["14a"] = Instance.new("Frame", G2L["100"]);
G2L["14a"]["BorderSizePixel"] = 0;
G2L["14a"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["14a"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["14a"]["Name"] = [[IgnorePlayers]];
G2L["14a"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["14a"]:SetAttribute([[Enabled]], false);
G2L["14a"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["14a"]:SetAttribute([[Accent]], Color3.fromRGB(239, 89, 101));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.UICorner
G2L["14b"] = Instance.new("UICorner", G2L["14a"]);
G2L["14b"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.UIStroke
G2L["14c"] = Instance.new("UIStroke", G2L["14a"]);
G2L["14c"]["Transparency"] = 0.48;
G2L["14c"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["14c"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Title
G2L["14d"] = Instance.new("TextLabel", G2L["14a"]);
G2L["14d"]["TextSize"] = 14;
G2L["14d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["14d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["14d"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["14d"]["BackgroundTransparency"] = 1;
G2L["14d"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["14d"]["Text"] = [[Ignore Players]];
G2L["14d"]["Name"] = [[Title]];
G2L["14d"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Description
G2L["14e"] = Instance.new("TextLabel", G2L["14a"]);
G2L["14e"]["TextSize"] = 10;
G2L["14e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["14e"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["14e"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["14e"]["BackgroundTransparency"] = 1;
G2L["14e"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["14e"]["Text"] = [[Do not show other players]];
G2L["14e"]["Name"] = [[Description]];
G2L["14e"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Switch
G2L["14f"] = Instance.new("TextButton", G2L["14a"]);
G2L["14f"]["BorderSizePixel"] = 0;
G2L["14f"]["AutoButtonColor"] = false;
G2L["14f"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["14f"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["14f"]["Text"] = [[]];
G2L["14f"]["Name"] = [[Switch]];
G2L["14f"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Switch.UICorner
G2L["150"] = Instance.new("UICorner", G2L["14f"]);
G2L["150"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Switch.Dot
G2L["151"] = Instance.new("Frame", G2L["14f"]);
G2L["151"]["BorderSizePixel"] = 0;
G2L["151"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["151"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["151"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["151"]["Name"] = [[Dot]];
G2L["151"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnorePlayers.Switch.Dot.UICorner
G2L["152"] = Instance.new("UICorner", G2L["151"]);
G2L["152"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs
G2L["153"] = Instance.new("Frame", G2L["100"]);
G2L["153"]["BorderSizePixel"] = 0;
G2L["153"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["153"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["153"]["Name"] = [[IgnoreNPCs]];
G2L["153"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["153"]:SetAttribute([[Enabled]], false);
G2L["153"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["153"]:SetAttribute([[Accent]], Color3.fromRGB(239, 89, 101));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.UICorner
G2L["154"] = Instance.new("UICorner", G2L["153"]);
G2L["154"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.UIStroke
G2L["155"] = Instance.new("UIStroke", G2L["153"]);
G2L["155"]["Transparency"] = 0.48;
G2L["155"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["155"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Title
G2L["156"] = Instance.new("TextLabel", G2L["153"]);
G2L["156"]["TextSize"] = 14;
G2L["156"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["156"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["156"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["156"]["BackgroundTransparency"] = 1;
G2L["156"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["156"]["Text"] = [[Ignore NPCs]];
G2L["156"]["Name"] = [[Title]];
G2L["156"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Description
G2L["157"] = Instance.new("TextLabel", G2L["153"]);
G2L["157"]["TextSize"] = 10;
G2L["157"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["157"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["157"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["157"]["BackgroundTransparency"] = 1;
G2L["157"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["157"]["Text"] = [[Do not show humanoid NPC models]];
G2L["157"]["Name"] = [[Description]];
G2L["157"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Switch
G2L["158"] = Instance.new("TextButton", G2L["153"]);
G2L["158"]["BorderSizePixel"] = 0;
G2L["158"]["AutoButtonColor"] = false;
G2L["158"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["158"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["158"]["Text"] = [[]];
G2L["158"]["Name"] = [[Switch]];
G2L["158"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Switch.UICorner
G2L["159"] = Instance.new("UICorner", G2L["158"]);
G2L["159"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Switch.Dot
G2L["15a"] = Instance.new("Frame", G2L["158"]);
G2L["15a"]["BorderSizePixel"] = 0;
G2L["15a"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["15a"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["15a"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["15a"]["Name"] = [[Dot]];
G2L["15a"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreNPCs.Switch.Dot.UICorner
G2L["15b"] = Instance.new("UICorner", G2L["15a"]);
G2L["15b"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam
G2L["15c"] = Instance.new("Frame", G2L["100"]);
G2L["15c"]["BorderSizePixel"] = 0;
G2L["15c"]["BackgroundColor3"] = Color3.fromRGB(28, 32, 43);
G2L["15c"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["15c"]["Name"] = [[IgnoreTeam]];
G2L["15c"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["15c"]:SetAttribute([[Enabled]], false);
G2L["15c"]:SetAttribute([[ControlType]], [[Toggle]]);
G2L["15c"]:SetAttribute([[Accent]], Color3.fromRGB(249, 157, 85));


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.UICorner
G2L["15d"] = Instance.new("UICorner", G2L["15c"]);
G2L["15d"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.UIStroke
G2L["15e"] = Instance.new("UIStroke", G2L["15c"]);
G2L["15e"]["Transparency"] = 0.48;
G2L["15e"]["Color"] = Color3.fromRGB(82, 92, 117);
G2L["15e"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Title
G2L["15f"] = Instance.new("TextLabel", G2L["15c"]);
G2L["15f"]["TextSize"] = 14;
G2L["15f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["15f"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["15f"]["TextColor3"] = Color3.fromRGB(246, 248, 254);
G2L["15f"]["BackgroundTransparency"] = 1;
G2L["15f"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["15f"]["Text"] = [[Ignore Same Team]];
G2L["15f"]["Name"] = [[Title]];
G2L["15f"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Description
G2L["160"] = Instance.new("TextLabel", G2L["15c"]);
G2L["160"]["TextSize"] = 10;
G2L["160"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["160"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["160"]["TextColor3"] = Color3.fromRGB(167, 176, 195);
G2L["160"]["BackgroundTransparency"] = 1;
G2L["160"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["160"]["Text"] = [[Do not show players on your current team]];
G2L["160"]["Name"] = [[Description]];
G2L["160"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Switch
G2L["161"] = Instance.new("TextButton", G2L["15c"]);
G2L["161"]["BorderSizePixel"] = 0;
G2L["161"]["AutoButtonColor"] = false;
G2L["161"]["BackgroundColor3"] = Color3.fromRGB(44, 50, 64);
G2L["161"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["161"]["Text"] = [[]];
G2L["161"]["Name"] = [[Switch]];
G2L["161"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Switch.UICorner
G2L["162"] = Instance.new("UICorner", G2L["161"]);
G2L["162"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Switch.Dot
G2L["163"] = Instance.new("Frame", G2L["161"]);
G2L["163"]["BorderSizePixel"] = 0;
G2L["163"]["BackgroundColor3"] = Color3.fromRGB(246, 248, 254);
G2L["163"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["163"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["163"]["Name"] = [[Dot]];
G2L["163"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.Visual.IgnoreTeam.Switch.Dot.UICorner
G2L["164"] = Instance.new("UICorner", G2L["163"]);
G2L["164"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock
G2L["165"] = Instance.new("ScrollingFrame", G2L["4e"]);
G2L["165"]["Visible"] = false;
G2L["165"]["Active"] = true;
G2L["165"]["BorderSizePixel"] = 0;
G2L["165"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["165"]["Name"] = [[CameraLock]];
G2L["165"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["165"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["165"]["ScrollBarImageColor3"] = Color3.fromRGB(80, 154, 255);
G2L["165"]["ScrollBarThickness"] = 3;
G2L["165"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.UIListLayout
G2L["166"] = Instance.new("UIListLayout", G2L["165"]);
G2L["166"]["Padding"] = UDim.new(0, 10);
G2L["166"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.UIPadding
G2L["167"] = Instance.new("UIPadding", G2L["165"]);
G2L["167"]["PaddingRight"] = UDim.new(0, 8);
G2L["167"]["PaddingBottom"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Heading
G2L["168"] = Instance.new("Frame", G2L["165"]);
G2L["168"]["Size"] = UDim2.new(1, 0, 0, 48);
G2L["168"]["Name"] = [[Heading]];
G2L["168"]["BackgroundTransparency"] = 1;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Heading.Title
G2L["169"] = Instance.new("TextLabel", G2L["168"]);
G2L["169"]["TextSize"] = 20;
G2L["169"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["169"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["169"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["169"]["BackgroundTransparency"] = 1;
G2L["169"]["Size"] = UDim2.new(1, 0, 0, 25);
G2L["169"]["Text"] = [[Camera Lock]];
G2L["169"]["Name"] = [[Title]];


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Heading.Subtitle
G2L["16a"] = Instance.new("TextLabel", G2L["168"]);
G2L["16a"]["TextSize"] = 11;
G2L["16a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["16a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["16a"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["16a"]["BackgroundTransparency"] = 1;
G2L["16a"]["Size"] = UDim2.new(1, 0, 0, 18);
G2L["16a"]["Text"] = [[Choose and follow a target with your local camera.]];
G2L["16a"]["Name"] = [[Subtitle]];
G2L["16a"]["Position"] = UDim2.new(0, 0, 0, 27);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled
G2L["16b"] = Instance.new("Frame", G2L["165"]);
G2L["16b"]["BorderSizePixel"] = 0;
G2L["16b"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["16b"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["16b"]["Name"] = [[Enabled]];
G2L["16b"]["LayoutOrder"] = 1;
G2L["16b"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["16b"]:SetAttribute([[Enabled]], false);
G2L["16b"]:SetAttribute([[ControlType]], [[CameraLockToggle]]);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.UICorner
G2L["16c"] = Instance.new("UICorner", G2L["16b"]);
G2L["16c"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.UIStroke
G2L["16d"] = Instance.new("UIStroke", G2L["16b"]);
G2L["16d"]["Transparency"] = 0.48;
G2L["16d"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["16d"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Title
G2L["16e"] = Instance.new("TextLabel", G2L["16b"]);
G2L["16e"]["TextSize"] = 14;
G2L["16e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["16e"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["16e"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["16e"]["BackgroundTransparency"] = 1;
G2L["16e"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["16e"]["Text"] = [[Enable Camera Lock]];
G2L["16e"]["Name"] = [[Title]];
G2L["16e"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Description
G2L["16f"] = Instance.new("TextLabel", G2L["16b"]);
G2L["16f"]["TextSize"] = 10;
G2L["16f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["16f"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["16f"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["16f"]["BackgroundTransparency"] = 1;
G2L["16f"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["16f"]["Text"] = [[Stays enabled and waits if no valid target exists.]];
G2L["16f"]["Name"] = [[Description]];
G2L["16f"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Switch
G2L["170"] = Instance.new("TextButton", G2L["16b"]);
G2L["170"]["BorderSizePixel"] = 0;
G2L["170"]["AutoButtonColor"] = false;
G2L["170"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["170"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["170"]["Text"] = [[]];
G2L["170"]["Name"] = [[Switch]];
G2L["170"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Switch.UICorner
G2L["171"] = Instance.new("UICorner", G2L["170"]);
G2L["171"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Switch.Dot
G2L["172"] = Instance.new("Frame", G2L["170"]);
G2L["172"]["BorderSizePixel"] = 0;
G2L["172"]["BackgroundColor3"] = Color3.fromRGB(247, 249, 255);
G2L["172"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["172"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["172"]["Name"] = [[Dot]];


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Enabled.Switch.Dot.UICorner
G2L["173"] = Instance.new("UICorner", G2L["172"]);
G2L["173"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target
G2L["174"] = Instance.new("Frame", G2L["165"]);
G2L["174"]["BorderSizePixel"] = 0;
G2L["174"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["174"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["174"]["Name"] = [[Target]];
G2L["174"]["LayoutOrder"] = 2;
G2L["174"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.UICorner
G2L["175"] = Instance.new("UICorner", G2L["174"]);
G2L["175"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.UIStroke
G2L["176"] = Instance.new("UIStroke", G2L["174"]);
G2L["176"]["Transparency"] = 0.48;
G2L["176"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["176"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.Title
G2L["177"] = Instance.new("TextLabel", G2L["174"]);
G2L["177"]["TextSize"] = 14;
G2L["177"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["177"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["177"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["177"]["BackgroundTransparency"] = 1;
G2L["177"]["Size"] = UDim2.new(1, -160, 0, 20);
G2L["177"]["Text"] = [[Lock Target]];
G2L["177"]["Name"] = [[Title]];
G2L["177"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.Description
G2L["178"] = Instance.new("TextLabel", G2L["174"]);
G2L["178"]["TextSize"] = 10;
G2L["178"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["178"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["178"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["178"]["BackgroundTransparency"] = 1;
G2L["178"]["Size"] = UDim2.new(1, -160, 0, 18);
G2L["178"]["Text"] = [[Choose a player or NPC. Clear it for automatic mode.]];
G2L["178"]["Name"] = [[Description]];
G2L["178"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.Button
G2L["179"] = Instance.new("TextButton", G2L["174"]);
G2L["179"]["BorderSizePixel"] = 0;
G2L["179"]["TextSize"] = 11;
G2L["179"]["AutoButtonColor"] = false;
G2L["179"]["TextColor3"] = Color3.fromRGB(80, 154, 255);
G2L["179"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["179"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["179"]["Size"] = UDim2.new(0, 118, 0, 30);
G2L["179"]["Text"] = [[Auto target]];
G2L["179"]["Name"] = [[Button]];
G2L["179"]["Position"] = UDim2.new(1, -137, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.Button.UICorner
G2L["17a"] = Instance.new("UICorner", G2L["179"]);
G2L["17a"]["CornerRadius"] = UDim.new(0, 7);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Target.Button.UIStroke
G2L["17b"] = Instance.new("UIStroke", G2L["179"]);
G2L["17b"]["Transparency"] = 0.55;
G2L["17b"]["Color"] = Color3.fromRGB(80, 154, 255);
G2L["17b"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto
G2L["17c"] = Instance.new("Frame", G2L["165"]);
G2L["17c"]["BorderSizePixel"] = 0;
G2L["17c"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["17c"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["17c"]["Name"] = [[Auto]];
G2L["17c"]["LayoutOrder"] = 3;
G2L["17c"]["BackgroundTransparency"] = 0.12;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.UICorner
G2L["17d"] = Instance.new("UICorner", G2L["17c"]);
G2L["17d"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.UIStroke
G2L["17e"] = Instance.new("UIStroke", G2L["17c"]);
G2L["17e"]["Transparency"] = 0.48;
G2L["17e"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["17e"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.Title
G2L["17f"] = Instance.new("TextLabel", G2L["17c"]);
G2L["17f"]["TextSize"] = 14;
G2L["17f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["17f"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["17f"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["17f"]["BackgroundTransparency"] = 1;
G2L["17f"]["Size"] = UDim2.new(1, -160, 0, 20);
G2L["17f"]["Text"] = [[Automatic Target]];
G2L["17f"]["Name"] = [[Title]];
G2L["17f"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.Description
G2L["180"] = Instance.new("TextLabel", G2L["17c"]);
G2L["180"]["TextSize"] = 10;
G2L["180"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["180"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["180"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["180"]["BackgroundTransparency"] = 1;
G2L["180"]["Size"] = UDim2.new(1, -160, 0, 18);
G2L["180"]["Text"] = [[Uses the closest valid living player to your character.]];
G2L["180"]["Name"] = [[Description]];
G2L["180"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.Button
G2L["181"] = Instance.new("TextButton", G2L["17c"]);
G2L["181"]["BorderSizePixel"] = 0;
G2L["181"]["TextSize"] = 11;
G2L["181"]["AutoButtonColor"] = false;
G2L["181"]["TextColor3"] = Color3.fromRGB(80, 154, 255);
G2L["181"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["181"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["181"]["Size"] = UDim2.new(0, 118, 0, 30);
G2L["181"]["Text"] = [[Closest player]];
G2L["181"]["Name"] = [[Button]];
G2L["181"]["Position"] = UDim2.new(1, -137, 0.5, -15);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.Button.UICorner
G2L["182"] = Instance.new("UICorner", G2L["181"]);
G2L["182"]["CornerRadius"] = UDim.new(0, 7);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.Auto.Button.UIStroke
G2L["183"] = Instance.new("UIStroke", G2L["181"]);
G2L["183"]["Transparency"] = 0.55;
G2L["183"]["Color"] = Color3.fromRGB(80, 154, 255);
G2L["183"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers
G2L["184"] = Instance.new("Frame", G2L["165"]);
G2L["184"]["BorderSizePixel"] = 0;
G2L["184"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["184"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["184"]["Name"] = [[IgnorePlayers]];
G2L["184"]["LayoutOrder"] = 4;
G2L["184"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["184"]:SetAttribute([[Enabled]], false);
G2L["184"]:SetAttribute([[ControlType]], [[CameraLockToggle]]);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.UICorner
G2L["185"] = Instance.new("UICorner", G2L["184"]);
G2L["185"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.UIStroke
G2L["186"] = Instance.new("UIStroke", G2L["184"]);
G2L["186"]["Transparency"] = 0.48;
G2L["186"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["186"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Title
G2L["187"] = Instance.new("TextLabel", G2L["184"]);
G2L["187"]["TextSize"] = 14;
G2L["187"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["187"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["187"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["187"]["BackgroundTransparency"] = 1;
G2L["187"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["187"]["Text"] = [[Ignore Players]];
G2L["187"]["Name"] = [[Title]];
G2L["187"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Description
G2L["188"] = Instance.new("TextLabel", G2L["184"]);
G2L["188"]["TextSize"] = 10;
G2L["188"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["188"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["188"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["188"]["BackgroundTransparency"] = 1;
G2L["188"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["188"]["Text"] = [[Do not show or lock onto player characters.]];
G2L["188"]["Name"] = [[Description]];
G2L["188"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Switch
G2L["189"] = Instance.new("TextButton", G2L["184"]);
G2L["189"]["BorderSizePixel"] = 0;
G2L["189"]["AutoButtonColor"] = false;
G2L["189"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["189"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["189"]["Text"] = [[]];
G2L["189"]["Name"] = [[Switch]];
G2L["189"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Switch.UICorner
G2L["18a"] = Instance.new("UICorner", G2L["189"]);
G2L["18a"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Switch.Dot
G2L["18b"] = Instance.new("Frame", G2L["189"]);
G2L["18b"]["BorderSizePixel"] = 0;
G2L["18b"]["BackgroundColor3"] = Color3.fromRGB(247, 249, 255);
G2L["18b"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["18b"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["18b"]["Name"] = [[Dot]];


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnorePlayers.Switch.Dot.UICorner
G2L["18c"] = Instance.new("UICorner", G2L["18b"]);
G2L["18c"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs
G2L["18d"] = Instance.new("Frame", G2L["165"]);
G2L["18d"]["BorderSizePixel"] = 0;
G2L["18d"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["18d"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["18d"]["Name"] = [[IgnoreNPCs]];
G2L["18d"]["LayoutOrder"] = 5;
G2L["18d"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["18d"]:SetAttribute([[Enabled]], false);
G2L["18d"]:SetAttribute([[ControlType]], [[CameraLockToggle]]);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.UICorner
G2L["18e"] = Instance.new("UICorner", G2L["18d"]);
G2L["18e"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.UIStroke
G2L["18f"] = Instance.new("UIStroke", G2L["18d"]);
G2L["18f"]["Transparency"] = 0.48;
G2L["18f"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["18f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Title
G2L["190"] = Instance.new("TextLabel", G2L["18d"]);
G2L["190"]["TextSize"] = 14;
G2L["190"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["190"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["190"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["190"]["BackgroundTransparency"] = 1;
G2L["190"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["190"]["Text"] = [[Ignore NPCs]];
G2L["190"]["Name"] = [[Title]];
G2L["190"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Description
G2L["191"] = Instance.new("TextLabel", G2L["18d"]);
G2L["191"]["TextSize"] = 10;
G2L["191"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["191"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["191"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["191"]["BackgroundTransparency"] = 1;
G2L["191"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["191"]["Text"] = [[Do not show or lock onto humanoid NPC models.]];
G2L["191"]["Name"] = [[Description]];
G2L["191"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Switch
G2L["192"] = Instance.new("TextButton", G2L["18d"]);
G2L["192"]["BorderSizePixel"] = 0;
G2L["192"]["AutoButtonColor"] = false;
G2L["192"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["192"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["192"]["Text"] = [[]];
G2L["192"]["Name"] = [[Switch]];
G2L["192"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Switch.UICorner
G2L["193"] = Instance.new("UICorner", G2L["192"]);
G2L["193"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Switch.Dot
G2L["194"] = Instance.new("Frame", G2L["192"]);
G2L["194"]["BorderSizePixel"] = 0;
G2L["194"]["BackgroundColor3"] = Color3.fromRGB(247, 249, 255);
G2L["194"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["194"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["194"]["Name"] = [[Dot]];


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreNPCs.Switch.Dot.UICorner
G2L["195"] = Instance.new("UICorner", G2L["194"]);
G2L["195"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam
G2L["196"] = Instance.new("Frame", G2L["165"]);
G2L["196"]["BorderSizePixel"] = 0;
G2L["196"]["BackgroundColor3"] = Color3.fromRGB(29, 33, 44);
G2L["196"]["Size"] = UDim2.new(1, 0, 0, 64);
G2L["196"]["Name"] = [[IgnoreTeam]];
G2L["196"]["LayoutOrder"] = 6;
G2L["196"]["BackgroundTransparency"] = 0.12;
-- Attributes
G2L["196"]:SetAttribute([[Enabled]], false);
G2L["196"]:SetAttribute([[ControlType]], [[CameraLockToggle]]);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.UICorner
G2L["197"] = Instance.new("UICorner", G2L["196"]);
G2L["197"]["CornerRadius"] = UDim.new(0, 12);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.UIStroke
G2L["198"] = Instance.new("UIStroke", G2L["196"]);
G2L["198"]["Transparency"] = 0.48;
G2L["198"]["Color"] = Color3.fromRGB(83, 93, 118);
G2L["198"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Title
G2L["199"] = Instance.new("TextLabel", G2L["196"]);
G2L["199"]["TextSize"] = 14;
G2L["199"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["199"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["199"]["TextColor3"] = Color3.fromRGB(247, 249, 255);
G2L["199"]["BackgroundTransparency"] = 1;
G2L["199"]["Size"] = UDim2.new(1, -105, 0, 20);
G2L["199"]["Text"] = [[Ignore Same Team]];
G2L["199"]["Name"] = [[Title]];
G2L["199"]["Position"] = UDim2.new(0, 17, 0, 8);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Description
G2L["19a"] = Instance.new("TextLabel", G2L["196"]);
G2L["19a"]["TextSize"] = 10;
G2L["19a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["19a"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["19a"]["TextColor3"] = Color3.fromRGB(168, 177, 196);
G2L["19a"]["BackgroundTransparency"] = 1;
G2L["19a"]["Size"] = UDim2.new(1, -105, 0, 18);
G2L["19a"]["Text"] = [[Do not show or lock onto teammates.]];
G2L["19a"]["Name"] = [[Description]];
G2L["19a"]["Position"] = UDim2.new(0, 17, 0, 31);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Switch
G2L["19b"] = Instance.new("TextButton", G2L["196"]);
G2L["19b"]["BorderSizePixel"] = 0;
G2L["19b"]["AutoButtonColor"] = false;
G2L["19b"]["BackgroundColor3"] = Color3.fromRGB(45, 51, 65);
G2L["19b"]["Size"] = UDim2.new(0, 50, 0, 28);
G2L["19b"]["Text"] = [[]];
G2L["19b"]["Name"] = [[Switch]];
G2L["19b"]["Position"] = UDim2.new(1, -69, 0.5, -14);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Switch.UICorner
G2L["19c"] = Instance.new("UICorner", G2L["19b"]);
G2L["19c"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Switch.Dot
G2L["19d"] = Instance.new("Frame", G2L["19b"]);
G2L["19d"]["BorderSizePixel"] = 0;
G2L["19d"]["BackgroundColor3"] = Color3.fromRGB(247, 249, 255);
G2L["19d"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["19d"]["Position"] = UDim2.new(0, 4, 0, 4);
G2L["19d"]["Name"] = [[Dot]];


-- StarterGui.RyzoxClient.Main.PageContainer.CameraLock.IgnoreTeam.Switch.Dot.UICorner
G2L["19e"] = Instance.new("UICorner", G2L["19d"]);
G2L["19e"]["CornerRadius"] = UDim.new(0, 20);


-- StarterGui.RyzoxClient.Main.RyzoxResponsiveScale
G2L["19f"] = Instance.new("UIScale", G2L["1d"]);
G2L["19f"]["Name"] = [[RyzoxResponsiveScale]];


-- StarterGui.RyzoxClient.Scripts.NotificationController
local function C_b()
local script = G2L["b"];
	local TweenService = game:GetService("TweenService")
	
	local Gui = script.Parent.Parent
	local Holder = Gui:WaitForChild("Notifications")
	local Notify = Gui:WaitForChild("Remotes"):WaitForChild("Notify")
	
	local Theme = {
		Panel = Color3.fromRGB(27, 31, 42),
		Stroke = Color3.fromRGB(81, 91, 116),
		Text = Color3.fromRGB(245, 247, 253),
		SubText = Color3.fromRGB(166, 175, 194),
		Blue = Color3.fromRGB(78, 152, 255),
	}
	
	local function tween(Object, Properties, Duration)
		TweenService:Create(Object, TweenInfo.new(Duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Properties):Play()
	end
	
	local function make(ClassName, Properties)
		local Object = Instance.new(ClassName)
	
		for Property, Value in pairs(Properties) do
			Object[Property] = Value
		end
	
		return Object
	end
	
	Notify.Event:Connect(function(Title, Description, Accent)
		local Card = make("Frame", {
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(24, 0),
			Size = UDim2.new(1, 0, 0, 68),
			ZIndex = 21,
			Parent = Holder,
		})
	
		make("UICorner", {
			CornerRadius = UDim.new(0, 12),
			Parent = Card,
		})
	
		make("UIStroke", {
			Color = Accent or Theme.Blue,
			Transparency = 0.38,
			Parent = Card,
		})
	
		make("Frame", {
			BackgroundColor3 = Accent or Theme.Blue,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 12),
			Size = UDim2.fromOffset(3, 44),
			ZIndex = 22,
			Parent = Card,
		})
	
		make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = tostring(Title),
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.fromOffset(17, 10),
			Size = UDim2.new(1, -34, 0, 18),
			ZIndex = 22,
			Parent = Card,
		})
	
		make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = tostring(Description),
			TextColor3 = Theme.SubText,
			TextSize = 11,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.fromOffset(17, 30),
			Size = UDim2.new(1, -34, 0, 27),
			ZIndex = 22,
			Parent = Card,
		})
	
		tween(Card, {
			BackgroundTransparency = 0.02,
			Position = UDim2.fromOffset(0, 0),
		}, 0.22)
	
		task.delay(3.25, function()
			if not Card.Parent then
				return
			end
	
			tween(Card, {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(24, 0),
			}, 0.2)
	
			task.wait(0.22)
	
			if Card then
				Card:Destroy()
			end
		end)
	end)
	
end;
task.spawn(C_b);
-- StarterGui.RyzoxClient.Scripts.MenuController
local function C_c()
local script = G2L["c"];
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Lighting = game:GetService("Lighting")
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Overlay = Gui:WaitForChild("Overlay")
	local Sidebar = Main:WaitForChild("Sidebar")
	local Header = Main:WaitForChild("Header")
	local Close = Header:WaitForChild("Close")
	local Container = Main:WaitForChild("PageContainer")
	local Settings = Container:WaitForChild("Settings")
	local Notify = Gui:WaitForChild("Remotes"):WaitForChild("Notify")
	
	local State = {
		MenuOpen = true,
		Blur = true,
		Animations = true,
		CurrentPage = "General",
	}
	
	local Theme = {
		Blue = Color3.fromRGB(78, 152, 255),
		PanelLight = Color3.fromRGB(43, 49, 63),
		Text = Color3.fromRGB(245, 247, 253),
		SubText = Color3.fromRGB(166, 175, 194),
	}
	
	local Blur = Lighting:FindFirstChild("RyzoxClientBlur")
	
	if Blur then
		Blur:Destroy()
	end
	
	Blur = Instance.new("BlurEffect")
	Blur.Name = "RyzoxClientBlur"
	Blur.Size = 16
	Blur.Enabled = true
	Blur.Parent = Lighting
	
	local function tween(Object, Properties, Duration)
		if not State.Animations then
			for Property, Value in pairs(Properties) do
				Object[Property] = Value
			end
			return
		end
	
		TweenService:Create(
			Object,
			TweenInfo.new(Duration or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			Properties
		):Play()
	end
	
	local function renderToggle(Card)
		local Switch = Card:WaitForChild("Switch")
		local Dot = Switch:WaitForChild("Dot")
		local Enabled = Card:GetAttribute("Enabled")
		local Accent = Card:GetAttribute("Accent")
	
		tween(Switch, {
			BackgroundColor3 = Enabled and Accent or Theme.PanelLight,
		}, 0.16)
	
		tween(Dot, {
			Position = Enabled and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4),
		}, 0.16)
	end
	
	local function showPage(Name)
		State.CurrentPage = Name
	
		for _, Page in ipairs(Container:GetChildren()) do
			if Page:IsA("ScrollingFrame") then
				Page.Visible = Page.Name == Name
	
				if Page.Name == Name then
					Page.CanvasPosition = Vector2.zero
				end
			end
		end
	
		for _, Button in ipairs(Sidebar:GetChildren()) do
			if Button:IsA("TextButton") then
				local Selected = Button.Name == Name
	
				tween(Button, {
					BackgroundTransparency = Selected and 0 or 1,
					BackgroundColor3 = Theme.Blue,
				}, 0.16)
	
				for _, Child in ipairs(Button:GetChildren()) do
					if Child:IsA("TextLabel") then
						tween(Child, {
							TextColor3 = Selected and Theme.Text or Theme.SubText,
						}, 0.16)
					end
				end
			end
		end
	end
	
	local function setMenuOpen(Open)
		State.MenuOpen = Open
		Blur.Enabled = State.Blur and Open
	
		if Open then
			Main.Visible = true
			Overlay.Visible = true
			Main.BackgroundTransparency = 1
			Main.Size = UDim2.new(0.68, 0, 0.72, 0)
			Overlay.BackgroundTransparency = 1
	
			tween(Main, {
				BackgroundTransparency = 0.43,
				Size = UDim2.new(0.72, 0, 0.78, 0),
			}, 0.22)
	
			tween(Overlay, {
				BackgroundTransparency = 0.35,
			}, 0.22)
		else
			tween(Main, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.68, 0, 0.72, 0),
			}, 0.18)
	
			tween(Overlay, {
				BackgroundTransparency = 1,
			}, 0.18)
	
			task.delay(State.Animations and 0.2 or 0, function()
				if not State.MenuOpen then
					Main.Visible = false
					Overlay.Visible = false
				end
			end)
		end
	end
	
	for _, Button in ipairs(Sidebar:GetChildren()) do
		if Button:IsA("TextButton") then
			Button.MouseButton1Click:Connect(function()
				showPage(Button.Name)
			end)
		end
	end
	
	for _, Page in ipairs(Container:GetChildren()) do
		if Page:IsA("ScrollingFrame") then
			for _, Card in ipairs(Page:GetChildren()) do
				if Card:IsA("Frame") and Card:GetAttribute("ControlType") == "Toggle" then
					local Switch = Card:WaitForChild("Switch")
	
					Switch.MouseButton1Click:Connect(function()
						local Enabled = not Card:GetAttribute("Enabled")
						Card:SetAttribute("Enabled", Enabled)
						renderToggle(Card)
	
						if Card.Name == "InterfaceBlur" then
							State.Blur = Enabled
							Blur.Enabled = Enabled and State.MenuOpen
							Notify:Fire("Interface Blur", Enabled and "Background blur enabled." or "Background blur disabled.", Theme.Blue)
						elseif Card.Name == "UIAnimations" then
							State.Animations = Enabled
							Notify:Fire("UI Animations", Enabled and "Animations enabled." or "Animations disabled.", Color3.fromRGB(232, 90, 190))
						end
					end)
	
					renderToggle(Card)
				end
			end
		end
	end
	
	Close.MouseButton1Click:Connect(function()
		setMenuOpen(false)
	end)
	
	local Dragging = false
	local DragStart
	local StartPosition
	
	Header.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Main.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then
			return
		end
	
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			local Delta = Input.Position - DragStart
	
			Main.Position = UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)
	
	Gui:SetAttribute("MenuOpen", true)
	Gui:SetAttribute("MenuKey", "LeftShift")
	Gui:SetAttribute("CameraKey", "E")
	Gui:SetAttribute("SpeedKey", "V")
	Gui:SetAttribute("JumpKey", "B")
	Gui:SetAttribute("SpinKey", "N")
	
	Gui:GetAttributeChangedSignal("RequestedMenuOpen"):Connect(function()
		setMenuOpen(Gui:GetAttribute("RequestedMenuOpen"))
		Gui:SetAttribute("MenuOpen", Gui:GetAttribute("RequestedMenuOpen"))
	end)
	
	showPage("General")
	
end;
task.spawn(C_c);
-- StarterGui.RyzoxClient.Scripts.KeybindController
local function C_d()
local script = G2L["d"];
	local UserInputService = game:GetService("UserInputService")
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Settings = Main:WaitForChild("PageContainer"):WaitForChild("Settings")
	local Notify = Gui:WaitForChild("Remotes"):WaitForChild("Notify")
	
	local DefaultBinds = {
		MenuBind = "RightShift",
		CameraBind = "",
		SpeedBind = "",
		JumpBind = "",
		SpinBind = ""
	}
	
	local AttributeBinds = {
		MenuBind = "MenuKey",
		CameraBind = "CameraKey",
		SpeedBind = "SpeedKey",
		JumpBind = "JumpKey",
		SpinBind = "SpinKey"
	}
	
	local Waiting = nil
	
	local function displayKey(keyName)
		if not keyName or keyName == "" then
			return "None"
		end
	
		return keyName
	end
	
	local function assign(cardName, keyName)
		local card = Settings:WaitForChild(cardName)
		local button = card:WaitForChild("BindButton")
		local attributeName = AttributeBinds[cardName]
	
		keyName = keyName or ""
	
		card:SetAttribute("Key", keyName)
		button.Text = displayKey(keyName)
		button.TextColor3 = keyName == ""
			and Color3.fromRGB(167, 176, 195)
			or Color3.fromRGB(78, 152, 255)
	
		Gui:SetAttribute(attributeName, keyName)
	end
	
	for cardName, defaultKey in pairs(DefaultBinds) do
		local card = Settings:WaitForChild(cardName)
		local button = card:WaitForChild("BindButton")
		local reset = card:WaitForChild("Reset")
	
		button.MouseButton1Click:Connect(function()
			if Waiting then
				return
			end
	
			Waiting = {
				CardName = cardName,
				Button = button
			}
	
			button.Text = "Press key..."
			button.TextColor3 = Color3.fromRGB(78, 152, 255)
	
			Notify:Fire(
				"Keybind",
				"Press a key. Press Escape to cancel.",
				Color3.fromRGB(78, 152, 255)
			)
		end)
	
		reset.MouseButton1Click:Connect(function()
			if Waiting and Waiting.CardName == cardName then
				Waiting = nil
			end
	
			assign(cardName, defaultKey)
	
			Notify:Fire(
				"Keybind Reset",
				cardName:gsub("Bind", "") .. " reset to " .. displayKey(defaultKey) .. ".",
				Color3.fromRGB(78, 152, 255)
			)
		end)
	
		assign(cardName, defaultKey)
	end
	
	UserInputService.InputBegan:Connect(function(input, processed)
		if Waiting then
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
	
			if input.KeyCode == Enum.KeyCode.Escape then
				local oldKey = Gui:GetAttribute(AttributeBinds[Waiting.CardName]) or ""
	
				Waiting.Button.Text = displayKey(oldKey)
				Waiting.Button.TextColor3 = oldKey == ""
					and Color3.fromRGB(167, 176, 195)
					or Color3.fromRGB(78, 152, 255)
	
				Waiting = nil
	
				Notify:Fire(
					"Keybind",
					"Keybind change cancelled.",
					Color3.fromRGB(167, 176, 195)
				)
	
				return
			end
	
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				assign(Waiting.CardName, input.KeyCode.Name)
	
				Notify:Fire(
					"Keybind Updated",
					"Assigned " .. input.KeyCode.Name .. ".",
					Color3.fromRGB(78, 152, 255)
				)
	
				Waiting = nil
			end
	
			return
		end
	
		if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
	
		if UserInputService:GetFocusedTextBox() then
			return
		end
	
		local key = input.KeyCode.Name
		local menuKey = Gui:GetAttribute("MenuKey") or ""
	
		if menuKey ~= "" and key == menuKey then
			Gui:SetAttribute(
				"RequestedMenuOpen",
				not Gui:GetAttribute("MenuOpen")
			)
	
			return
		end
	
		if key ~= "" and key == (Gui:GetAttribute("CameraKey") or "") then
			Gui:SetAttribute("FeatureAction", "Camera")
		elseif key ~= "" and key == (Gui:GetAttribute("SpeedKey") or "") then
			Gui:SetAttribute("FeatureAction", "Speed")
		elseif key ~= "" and key == (Gui:GetAttribute("JumpKey") or "") then
			Gui:SetAttribute("FeatureAction", "Jump")
		elseif key ~= "" and key == (Gui:GetAttribute("SpinKey") or "") then
			Gui:SetAttribute("FeatureAction", "Spin")
		end
	end)
	
	Gui:SetAttribute("MenuKey", "RightShift")
	Gui:SetAttribute("CameraKey", "")
	Gui:SetAttribute("SpeedKey", "")
	Gui:SetAttribute("JumpKey", "")
	Gui:SetAttribute("SpinKey", "")
	Gui:SetAttribute("FeatureAction", "")
	
end;
task.spawn(C_d);
-- StarterGui.RyzoxClient.Scripts.FeatureController
local function C_e()
local script = G2L["e"];
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local Player = Players.LocalPlayer
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Pages = Main:WaitForChild("PageContainer")
	local Notify = Gui:WaitForChild("Remotes"):WaitForChild("Notify")
	
	local Movement = Pages:WaitForChild("Movement")
	local CameraPage = Pages:WaitForChild("Camera")
	local CharacterPage = Pages:WaitForChild("Character")
	
	local SpeedToggle = Movement:WaitForChild("SpeedBoost")
	local WalkSpeedInput = Movement:WaitForChild("WalkSpeed"):WaitForChild("Input")
	local JumpToggle = Movement:WaitForChild("JumpBoost")
	local JumpPowerInput = Movement:WaitForChild("JumpPower"):WaitForChild("Input")
	
	local CameraToggle = CameraPage:WaitForChild("CameraUnlock")
	
	local SpinToggle = CharacterPage:WaitForChild("SpinCharacter")
	local SpinSpeedInput = CharacterPage:WaitForChild("SpinSpeed"):WaitForChild("Input")
	
	local State = {
		Speed = false,
		Jump = false,
		Camera = false,
		Spin = false,
		WalkSpeed = 32,
		JumpPower = 75,
		SpinSpeed = 25,
	}
	
	local CameraState = {
		Saved = false,
		CameraMode = nil,
		MinimumZoom = nil,
		MaximumZoom = nil,
		CameraType = nil,
	}
	
	local function getCharacter()
		return Player.Character or Player.CharacterAdded:Wait()
	end
	
	local function getHumanoid()
		local CharacterModel = getCharacter()
	
		return CharacterModel:FindFirstChildOfClass("Humanoid")
			or CharacterModel:WaitForChild("Humanoid")
	end
	
	local function getRoot()
		local CharacterModel = getCharacter()
	
		return CharacterModel:FindFirstChild("HumanoidRootPart")
			or CharacterModel:WaitForChild("HumanoidRootPart")
	end
	
	local function getNumber(Input, Minimum, Maximum, Default)
		local Number = tonumber(Input.Text)
	
		if not Number then
			Input.Text = tostring(Default)
			return Default
		end
	
		Number = math.clamp(math.floor(Number + 0.5), Minimum, Maximum)
		Input.Text = tostring(Number)
	
		return Number
	end
	
	local function applyMovement()
		local Humanoid = getHumanoid()
	
		Humanoid.UseJumpPower = true
		Humanoid.WalkSpeed = State.Speed and State.WalkSpeed or 16
		Humanoid.JumpPower = State.Jump and State.JumpPower or 50
	end
	
	local function saveCameraState()
		if CameraState.Saved then
			return
		end
	
		local Camera = Workspace.CurrentCamera
	
		CameraState.Saved = true
		CameraState.CameraMode = Player.CameraMode
		CameraState.MinimumZoom = Player.CameraMinZoomDistance
		CameraState.MaximumZoom = Player.CameraMaxZoomDistance
		CameraState.CameraType = Camera and Camera.CameraType or Enum.CameraType.Custom
	end
	
	local function setCameraPosition()
		local Camera = Workspace.CurrentCamera
		local Root = getRoot()
	
		if not Camera or not Root then
			return
		end
	
		local FocusPosition = Root.Position + Vector3.new(0, 2.25, 0)
		local CameraPosition = FocusPosition + Vector3.new(0, 2.4, 11)
	
		Camera.Focus = CFrame.new(FocusPosition)
		Camera.CFrame = CFrame.new(CameraPosition, FocusPosition)
	end
	
	local function enableCameraUnlock()
		saveCameraState()
	
		local Camera = Workspace.CurrentCamera
	
		Player.CameraMode = Enum.CameraMode.Classic
		Player.CameraMinZoomDistance = 8
		Player.CameraMaxZoomDistance = 128
	
		if Camera then
			Camera.CameraType = Enum.CameraType.Custom
		end
	
		setCameraPosition()
	
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
	
	local function disableCameraUnlock()
		if not CameraState.Saved then
			return
		end
	
		local Camera = Workspace.CurrentCamera
	
		Player.CameraMode = CameraState.CameraMode or Enum.CameraMode.Classic
		Player.CameraMinZoomDistance = CameraState.MinimumZoom or 0.5
		Player.CameraMaxZoomDistance = CameraState.MaximumZoom or 128
	
		if Camera then
			Camera.CameraType = CameraState.CameraType or Enum.CameraType.Custom
		end
	
		CameraState.Saved = false
	end
	
	local function applySpinState()
		local Humanoid = getHumanoid()
	
		Humanoid.AutoRotate = not State.Spin
	end
	
	local function updateState()
		State.Speed = SpeedToggle:GetAttribute("Enabled")
		State.Jump = JumpToggle:GetAttribute("Enabled")
		State.Camera = CameraToggle:GetAttribute("Enabled")
		State.Spin = SpinToggle:GetAttribute("Enabled")
	
		State.WalkSpeed = getNumber(WalkSpeedInput, 1, 1000000, State.WalkSpeed)
		State.JumpPower = getNumber(JumpPowerInput, 1, 1000000, State.JumpPower)
		State.SpinSpeed = getNumber(SpinSpeedInput, 1, 250, State.SpinSpeed)
	
		applyMovement()
		applySpinState()
	
		if State.Camera then
			enableCameraUnlock()
		else
			disableCameraUnlock()
		end
	end
	
	SpeedToggle:GetAttributeChangedSignal("Enabled"):Connect(function()
		updateState()
		Notify:Fire("Speed Boost", State.Speed and "Speed boost enabled." or "Speed boost disabled.", Color3.fromRGB(52, 206, 137))
	end)
	
	JumpToggle:GetAttributeChangedSignal("Enabled"):Connect(function()
		updateState()
		Notify:Fire("Jump Boost", State.Jump and "Jump boost enabled." or "Jump boost disabled.", Color3.fromRGB(248, 156, 84))
	end)
	
	CameraToggle:GetAttributeChangedSignal("Enabled"):Connect(function()
		updateState()
		Notify:Fire("Camera Unlock", State.Camera and "Classic camera enabled." or "Previous camera restored.", Color3.fromRGB(78, 152, 255))
	end)
	
	SpinToggle:GetAttributeChangedSignal("Enabled"):Connect(function()
		updateState()
		Notify:Fire("Character Spin", State.Spin and "Character spin enabled." or "Character spin disabled.", Color3.fromRGB(238, 88, 100))
	end)
	
	for _, Input in ipairs({
		WalkSpeedInput,
		JumpPowerInput,
		SpinSpeedInput,
	}) do
		Input.FocusLost:Connect(function()
			updateState()
		end)
	end
	
	Player.CharacterAdded:Connect(function()
		task.wait(0.45)
	
		CameraState.Saved = false
	
		if State.Camera then
			enableCameraUnlock()
		end
	
		applyMovement()
		applySpinState()
	end)
	
	RunService.Heartbeat:Connect(function()
		local CharacterModel = Player.Character
		local Humanoid = CharacterModel and CharacterModel:FindFirstChildOfClass("Humanoid")
	
		if Humanoid then
			Humanoid.UseJumpPower = true
	
			if State.Speed then
				Humanoid.WalkSpeed = State.WalkSpeed
			end
	
			if State.Jump then
				Humanoid.JumpPower = State.JumpPower
			end
		end
	
		if State.Spin then
			local Root = CharacterModel and CharacterModel:FindFirstChild("HumanoidRootPart")
	
			if Root and Humanoid and Humanoid.Health > 0 then
				Humanoid.AutoRotate = false
	
				local DegreesPerSecond = math.clamp(State.SpinSpeed * 2.5, 5, 625)
	
				Root.CFrame = Root.CFrame * CFrame.Angles(
					0,
					math.rad(DegreesPerSecond / 60),
					0
				)
			end
		end
	end)
	
	RunService.RenderStepped:Connect(function()
		if Gui:GetAttribute("MenuOpen") then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			UserInputService.MouseIconEnabled = true
		end
	end)
	
	Gui:GetAttributeChangedSignal("FeatureAction"):Connect(function()
		local Action = Gui:GetAttribute("FeatureAction")
	
		if Action == "Camera" then
			CameraToggle:SetAttribute("Enabled", not CameraToggle:GetAttribute("Enabled"))
		elseif Action == "Speed" then
			SpeedToggle:SetAttribute("Enabled", not SpeedToggle:GetAttribute("Enabled"))
		elseif Action == "Jump" then
			JumpToggle:SetAttribute("Enabled", not JumpToggle:GetAttribute("Enabled"))
		elseif Action == "Spin" then
			SpinToggle:SetAttribute("Enabled", not SpinToggle:GetAttribute("Enabled"))
		end
	
		Gui:SetAttribute("FeatureAction", "")
	end)
	
	updateState()
	
end;
task.spawn(C_e);
-- StarterGui.RyzoxClient.Scripts.ExactTracerController
local function C_f()
local script = G2L["f"];
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local Player = Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Visual = Main:WaitForChild("PageContainer"):WaitForChild("Visual")
	
	for _, Object in ipairs(PlayerGui:GetChildren()) do
		if Object.Name == "RyzoxTracerOverlay"
			or Object.Name == "RyzoxExactTracerOverlay" then
			Object:Destroy()
		end
	end
	
	local Overlay = Instance.new("ScreenGui")
	Overlay.Name = "RyzoxExactTracerOverlay"
	Overlay.IgnoreGuiInset = true
	Overlay.ResetOnSpawn = false
	Overlay.DisplayOrder = 999999
	Overlay.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Overlay.Parent = PlayerGui
	
	local Holder = Instance.new("Frame")
	Holder.Name = "Holder"
	Holder.Active = false
	Holder.BackgroundTransparency = 1
	Holder.BorderSizePixel = 0
	Holder.ClipsDescendants = true
	Holder.Size = UDim2.fromScale(1, 1)
	Holder.ZIndex = 999999
	Holder.Parent = Overlay
	
	local Controls = {
		Tracers = Visual:WaitForChild("Tracers"),
		Distance = Visual:WaitForChild("TracerDistance"):WaitForChild("Input"),
		Color = Visual:WaitForChild("TracerColor"):WaitForChild("Input"),
		Rainbow = Visual:WaitForChild("RainbowVisuals"),
		IgnorePlayers = Visual:WaitForChild("IgnorePlayers"),
		IgnoreNPCs = Visual:WaitForChild("IgnoreNPCs"),
		IgnoreTeam = Visual:WaitForChild("IgnoreTeam"),
	}
	
	local Lines = {}
	
	local function getNumber(Input, Minimum, Maximum, Default)
		local Number = tonumber(Input.Text)
	
		if not Number then
			return Default
		end
	
		return math.clamp(Number, Minimum, Maximum)
	end
	
	local function getColor()
		if Controls.Rainbow:GetAttribute("Enabled") then
			return Color3.fromHSV((time() * 0.12) % 1, 0.78, 1)
		end
	
		local Hex = tostring(Controls.Color.Text or ""):gsub("#", "")
	
		if #Hex ~= 6 then
			return Color3.fromRGB(78, 152, 255)
		end
	
		local Red = tonumber(Hex:sub(1, 2), 16)
		local Green = tonumber(Hex:sub(3, 4), 16)
		local Blue = tonumber(Hex:sub(5, 6), 16)
	
		if not Red or not Green or not Blue then
			return Color3.fromRGB(78, 152, 255)
		end
	
		return Color3.fromRGB(Red, Green, Blue)
	end
	
	local function getRoot(Model)
		return Model:FindFirstChild("HumanoidRootPart")
			or Model:FindFirstChild("UpperTorso")
			or Model:FindFirstChild("Torso")
			or Model:FindFirstChild("Head")
	end
	
	local function isValidTarget(Model)
		if not Model or not Model:IsA("Model") or Model == Player.Character then
			return false
		end
	
		local Humanoid = Model:FindFirstChildOfClass("Humanoid")
		local Root = getRoot(Model)
	
		if not Humanoid or Humanoid.Health <= 0 or not Root then
			return false
		end
	
		local TargetPlayer = Players:GetPlayerFromCharacter(Model)
	
		if TargetPlayer then
			if Controls.IgnorePlayers:GetAttribute("Enabled") then
				return false
			end
	
			if Controls.IgnoreTeam:GetAttribute("Enabled")
				and Player.Team
				and TargetPlayer.Team == Player.Team then
				return false
			end
		elseif Controls.IgnoreNPCs:GetAttribute("Enabled") then
			return false
		end
	
		return true
	end
	
	local function getTargets()
		local Targets = {}
		local Added = {}
	
		for _, OtherPlayer in ipairs(Players:GetPlayers()) do
			if OtherPlayer ~= Player and OtherPlayer.Character then
				Added[OtherPlayer.Character] = true
				table.insert(Targets, OtherPlayer.Character)
			end
		end
	
		for _, Object in ipairs(Workspace:GetDescendants()) do
			if Object:IsA("Model")
				and not Added[Object]
				and not Players:GetPlayerFromCharacter(Object)
				and Object:FindFirstChildOfClass("Humanoid")
				and getRoot(Object) then
	
				Added[Object] = true
				table.insert(Targets, Object)
			end
		end
	
		return Targets
	end
	
	local function getLine(Model)
		local Line = Lines[Model]
	
		if Line and Line.Parent then
			return Line
		end
	
		Line = Instance.new("Frame")
		Line.Name = "ExactTracer"
		Line.AnchorPoint = Vector2.new(0.5, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(78, 152, 255)
		Line.BorderSizePixel = 0
		Line.Size = UDim2.fromOffset(0, 2)
		Line.Visible = false
		Line.ZIndex = 1000000
		Line.Parent = Holder
	
		local Gradient = Instance.new("UIGradient")
		Gradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(1, 0.35),
		})
		Gradient.Parent = Line
	
		Lines[Model] = Line
	
		return Line
	end
	
	local function removeLine(Model)
		local Line = Lines[Model]
	
		if Line then
			Line:Destroy()
			Lines[Model] = nil
		end
	end
	
	local function getCanvasPosition(Camera, ViewportPosition)
		local CameraViewport = Camera.ViewportSize
		local Canvas = Holder.AbsoluteSize
	
		if CameraViewport.X <= 0
			or CameraViewport.Y <= 0
			or Canvas.X <= 0
			or Canvas.Y <= 0 then
			return Vector2.zero
		end
	
		return Vector2.new(
			(ViewportPosition.X / CameraViewport.X) * Canvas.X,
			(ViewportPosition.Y / CameraViewport.Y) * Canvas.Y
		)
	end
	
	local function getTargetPosition(Camera, WorldPosition)
		local ViewportPosition = Camera:WorldToViewportPoint(WorldPosition)
		local Canvas = Holder.AbsoluteSize
		local Position = getCanvasPosition(Camera, ViewportPosition)
	
		if ViewportPosition.Z < 0 then
			Position = Vector2.new(
				Canvas.X - Position.X,
				Canvas.Y - Position.Y
			)
		end
	
		return Vector2.new(
			math.clamp(Position.X, 6, Canvas.X - 6),
			math.clamp(Position.Y, 6, Canvas.Y - 6)
		)
	end
	
	RunService.RenderStepped:Connect(function()
		local Camera = Workspace.CurrentCamera
		local Character = Player.Character
		local LocalRoot = Character and Character:FindFirstChild("HumanoidRootPart")
	
		if not Camera or not LocalRoot then
			return
		end
	
		local TracersEnabled = Controls.Tracers:GetAttribute("Enabled")
		Overlay.Enabled = TracersEnabled
	
		if not TracersEnabled then
			for _, Line in pairs(Lines) do
				Line.Visible = false
			end
	
			return
		end
	
		local Canvas = Holder.AbsoluteSize
	
		if Canvas.X <= 0 or Canvas.Y <= 0 then
			return
		end
	
		local MaximumDistance = getNumber(Controls.Distance, 50, 5000, 1500)
		local TracerColor = getColor()
		local StartPoint = Vector2.new(Canvas.X * 0.5, Canvas.Y - 6)
		local ActiveTargets = {}
	
		for _, Model in ipairs(getTargets()) do
			if isValidTarget(Model) then
				local Root = getRoot(Model)
	
				if Root then
					local Distance = (LocalRoot.Position - Root.Position).Magnitude
	
					if Distance <= MaximumDistance then
						ActiveTargets[Model] = true
	
						local EndPoint = getTargetPosition(Camera, Root.Position)
						local Difference = EndPoint - StartPoint
						local Length = Difference.Magnitude
						local Midpoint = (StartPoint + EndPoint) * 0.5
						local Line = getLine(Model)
	
						Line.Visible = Length > 1
						Line.BackgroundColor3 = TracerColor
						Line.Size = UDim2.fromOffset(Length, 2)
	
						-- Correct rotation pivot:
						-- a rotated GUI Frame must sit at the line's midpoint.
						Line.Position = UDim2.fromOffset(Midpoint.X, Midpoint.Y)
						Line.Rotation = math.deg(math.atan2(Difference.Y, Difference.X))
					end
				end
			end
		end
	
		for Model in pairs(Lines) do
			if not ActiveTargets[Model] then
				removeLine(Model)
			end
		end
	end)
	
end;
task.spawn(C_f);
-- StarterGui.RyzoxClient.Scripts.UsernameController
local function C_10()
local script = G2L["10"];
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local Player = Players.LocalPlayer
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Visual = Main:WaitForChild("PageContainer"):WaitForChild("Visual")
	
	local ShowUsername = Visual:WaitForChild("ShowUsername")
	local ESPSizeInput = Visual:WaitForChild("ESPSize"):WaitForChild("Input")
	local ESPColorInput = Visual:WaitForChild("ESPColor"):WaitForChild("Input")
	local RainbowToggle = Visual:WaitForChild("RainbowVisuals")
	local IgnorePlayersToggle = Visual:WaitForChild("IgnorePlayers")
	local IgnoreNPCsToggle = Visual:WaitForChild("IgnoreNPCs")
	local IgnoreTeamToggle = Visual:WaitForChild("IgnoreTeam")
	
	local Labels = {}
	
	local function getNumber(Input, Minimum, Maximum, Default)
		local Number = tonumber(Input.Text)
	
		if not Number then
			return Default
		end
	
		return math.clamp(Number, Minimum, Maximum)
	end
	
	local function getHexColor(Value)
		Value = tostring(Value or ""):gsub("#", "")
	
		if #Value ~= 6 then
			return Color3.fromRGB(154, 105, 255)
		end
	
		local Red = tonumber(Value:sub(1, 2), 16)
		local Green = tonumber(Value:sub(3, 4), 16)
		local Blue = tonumber(Value:sub(5, 6), 16)
	
		if not Red or not Green or not Blue then
			return Color3.fromRGB(154, 105, 255)
		end
	
		return Color3.fromRGB(Red, Green, Blue)
	end
	
	local function getColor()
		if RainbowToggle:GetAttribute("Enabled") then
			return Color3.fromHSV((time() * 0.12) % 1, 0.78, 1)
		end
	
		return getHexColor(ESPColorInput.Text)
	end
	
	local function getRoot(Model)
		return Model:FindFirstChild("HumanoidRootPart")
			or Model:FindFirstChild("UpperTorso")
			or Model:FindFirstChild("Torso")
			or Model:FindFirstChild("Head")
	end
	
	local function isValidTarget(Model)
		if not Model or not Model:IsA("Model") or Model == Player.Character then
			return false
		end
	
		local Humanoid = Model:FindFirstChildOfClass("Humanoid")
		local Root = getRoot(Model)
	
		if not Humanoid or Humanoid.Health <= 0 or not Root then
			return false
		end
	
		local TargetPlayer = Players:GetPlayerFromCharacter(Model)
	
		if TargetPlayer then
			if IgnorePlayersToggle:GetAttribute("Enabled") then
				return false
			end
	
			if IgnoreTeamToggle:GetAttribute("Enabled")
				and Player.Team
				and TargetPlayer.Team == Player.Team then
				return false
			end
		elseif IgnoreNPCsToggle:GetAttribute("Enabled") then
			return false
		end
	
		return true
	end
	
	local function getTargets()
		local Targets = {}
		local Added = {}
	
		for _, OtherPlayer in ipairs(Players:GetPlayers()) do
			if OtherPlayer ~= Player and OtherPlayer.Character then
				Added[OtherPlayer.Character] = true
				table.insert(Targets, OtherPlayer.Character)
			end
		end
	
		for _, Object in ipairs(Workspace:GetDescendants()) do
			if Object:IsA("Model")
				and not Added[Object]
				and not Players:GetPlayerFromCharacter(Object)
				and Object:FindFirstChildOfClass("Humanoid")
				and getRoot(Object) then
	
				Added[Object] = true
				table.insert(Targets, Object)
			end
		end
	
		return Targets
	end
	
	local function createLabel(Model)
		local Root = getRoot(Model)
	
		if not Root then
			return nil
		end
	
		local Existing = Root:FindFirstChild("RyzoxIndependentUsername")
	
		if Existing then
			Existing:Destroy()
		end
	
		local Billboard = Instance.new("BillboardGui")
		Billboard.Name = "RyzoxIndependentUsername"
		Billboard.Adornee = Root
		Billboard.AlwaysOnTop = true
		Billboard.ExtentsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
		Billboard.Size = UDim2.fromOffset(180, 30)
		Billboard.Parent = Root
	
		local NameLabel = Instance.new("TextLabel")
		NameLabel.Name = "Name"
		NameLabel.BackgroundTransparency = 1
		NameLabel.Font = Enum.Font.GothamBold
		NameLabel.TextColor3 = Color3.fromRGB(245, 247, 253)
		NameLabel.TextSize = 16
		NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		NameLabel.TextStrokeTransparency = 0.2
		NameLabel.Size = UDim2.fromScale(1, 1)
		NameLabel.Parent = Billboard
	
		Labels[Model] = Billboard
	
		return Billboard
	end
	
	local function getLabel(Model)
		local Billboard = Labels[Model]
	
		if Billboard and Billboard.Parent then
			return Billboard
		end
	
		return createLabel(Model)
	end
	
	local function removeLabel(Model)
		local Billboard = Labels[Model]
	
		if Billboard then
			Billboard:Destroy()
			Labels[Model] = nil
		end
	end
	
	RunService.RenderStepped:Connect(function()
		local Enabled = ShowUsername:GetAttribute("Enabled")
	
		if not Enabled then
			for Model in pairs(Labels) do
				removeLabel(Model)
			end
	
			return
		end
	
		local ActiveTargets = {}
		local Color = getColor()
		local TextSize = getNumber(ESPSizeInput, 10, 50, 16)
	
		for _, Model in ipairs(getTargets()) do
			if isValidTarget(Model) then
				ActiveTargets[Model] = true
	
				local Billboard = getLabel(Model)
	
				if Billboard then
					local NameLabel = Billboard:FindFirstChild("Name")
					local TargetPlayer = Players:GetPlayerFromCharacter(Model)
	
					if NameLabel then
						NameLabel.Text = TargetPlayer and TargetPlayer.Name or Model.Name
						NameLabel.TextColor3 = Color
						NameLabel.TextSize = TextSize
					end
				end
			end
		end
	
		for Model in pairs(Labels) do
			if not ActiveTargets[Model] then
				removeLabel(Model)
			end
		end
	end)
	
end;
task.spawn(C_10);
-- StarterGui.RyzoxClient.Scripts.ESPController
local function C_11()
local script = G2L["11"];
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local Player = Players.LocalPlayer
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Visual = Main:WaitForChild("PageContainer"):WaitForChild("Visual")
	
	local ESPToggle = Visual:WaitForChild("ESP")
	local ESPColorInput = Visual:WaitForChild("ESPColor"):WaitForChild("Input")
	local RainbowToggle = Visual:WaitForChild("RainbowVisuals")
	local IgnorePlayersToggle = Visual:WaitForChild("IgnorePlayers")
	local IgnoreNPCsToggle = Visual:WaitForChild("IgnoreNPCs")
	local IgnoreTeamToggle = Visual:WaitForChild("IgnoreTeam")
	
	local Highlights = {}
	
	local function getHexColor(Value)
		Value = tostring(Value or ""):gsub("#", "")
	
		if #Value ~= 6 then
			return Color3.fromRGB(154, 105, 255)
		end
	
		local Red = tonumber(Value:sub(1, 2), 16)
		local Green = tonumber(Value:sub(3, 4), 16)
		local Blue = tonumber(Value:sub(5, 6), 16)
	
		if not Red or not Green or not Blue then
			return Color3.fromRGB(154, 105, 255)
		end
	
		return Color3.fromRGB(Red, Green, Blue)
	end
	
	local function getESPColor()
		if RainbowToggle:GetAttribute("Enabled") then
			return Color3.fromHSV((time() * 0.12) % 1, 0.78, 1)
		end
	
		return getHexColor(ESPColorInput.Text)
	end
	
	local function getRoot(Model)
		return Model:FindFirstChild("HumanoidRootPart")
			or Model:FindFirstChild("UpperTorso")
			or Model:FindFirstChild("Torso")
			or Model:FindFirstChild("Head")
	end
	
	local function isValidTarget(Model)
		if not Model or not Model:IsA("Model") or Model == Player.Character then
			return false
		end
	
		local Humanoid = Model:FindFirstChildOfClass("Humanoid")
		local Root = getRoot(Model)
	
		if not Humanoid or Humanoid.Health <= 0 or not Root then
			return false
		end
	
		local TargetPlayer = Players:GetPlayerFromCharacter(Model)
	
		if TargetPlayer then
			if IgnorePlayersToggle:GetAttribute("Enabled") then
				return false
			end
	
			if IgnoreTeamToggle:GetAttribute("Enabled")
				and Player.Team
				and TargetPlayer.Team == Player.Team then
				return false
			end
		elseif IgnoreNPCsToggle:GetAttribute("Enabled") then
			return false
		end
	
		return true
	end
	
	local function getTargets()
		local Targets = {}
		local Added = {}
	
		for _, OtherPlayer in ipairs(Players:GetPlayers()) do
			if OtherPlayer ~= Player and OtherPlayer.Character then
				Added[OtherPlayer.Character] = true
				table.insert(Targets, OtherPlayer.Character)
			end
		end
	
		for _, Object in ipairs(Workspace:GetDescendants()) do
			if Object:IsA("Model")
				and not Added[Object]
				and not Players:GetPlayerFromCharacter(Object)
				and Object:FindFirstChildOfClass("Humanoid")
				and getRoot(Object) then
	
				Added[Object] = true
				table.insert(Targets, Object)
			end
		end
	
		return Targets
	end
	
	local function getHighlight(Model)
		local Highlight = Highlights[Model]
	
		if Highlight and Highlight.Parent then
			return Highlight
		end
	
		local Existing = Model:FindFirstChild("RyzoxStandaloneESP")
	
		if Existing then
			Existing:Destroy()
		end
	
		Highlight = Instance.new("Highlight")
		Highlight.Name = "RyzoxStandaloneESP"
		Highlight.Adornee = Model
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.FillTransparency = 0.76
		Highlight.OutlineTransparency = 0
		Highlight.Parent = Model
	
		Highlights[Model] = Highlight
	
		return Highlight
	end
	
	local function removeHighlight(Model)
		local Highlight = Highlights[Model]
	
		if Highlight then
			Highlight:Destroy()
			Highlights[Model] = nil
		end
	end
	
	RunService.RenderStepped:Connect(function()
		local Enabled = ESPToggle:GetAttribute("Enabled")
	
		if not Enabled then
			for Model in pairs(Highlights) do
				removeHighlight(Model)
			end
	
			return
		end
	
		local ActiveTargets = {}
		local Color = getESPColor()
	
		for _, Model in ipairs(getTargets()) do
			if isValidTarget(Model) then
				ActiveTargets[Model] = true
	
				local Highlight = getHighlight(Model)
	
				Highlight.FillColor = Color
				Highlight.OutlineColor = Color
			end
		end
	
		for Model in pairs(Highlights) do
			if not ActiveTargets[Model] then
				removeHighlight(Model)
			end
		end
	end)
	
end;
task.spawn(C_11);
-- StarterGui.RyzoxClient.Scripts.CFrameBoostController
local function C_12()
local script = G2L["12"];
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	
	local Player = Players.LocalPlayer
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Movement = Main:WaitForChild("PageContainer"):WaitForChild("Movement")
	local Notify = Gui:WaitForChild("Remotes"):WaitForChild("Notify")
	
	local SpeedBoost = Movement:WaitForChild("SpeedBoost")
	local WalkSpeedInput = Movement:WaitForChild("WalkSpeed"):WaitForChild("Input")
	
	local JumpBoost = Movement:WaitForChild("JumpBoost")
	local JumpPowerInput = Movement:WaitForChild("JumpPower"):WaitForChild("Input")
	
	local CFrameBoost = Movement:WaitForChild("CFrameBoost")
	local Switch = CFrameBoost:WaitForChild("Switch")
	local Dot = Switch:WaitForChild("Dot")
	
	local Theme = {
		PanelLight = Color3.fromRGB(43, 49, 63),
		Purple = Color3.fromRGB(154, 105, 255),
	}
	
	local ActiveJump = nil
	local LastJumpTime = 0
	
	local function tween(Object, Properties)
		TweenService:Create(
			Object,
			TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			Properties
		):Play()
	end
	
	local function render()
		local Enabled = CFrameBoost:GetAttribute("Enabled")
	
		tween(Switch, {
			BackgroundColor3 = Enabled and Theme.Purple or Theme.PanelLight,
		})
	
		tween(Dot, {
			Position = Enabled and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4),
		})
	end
	
	local function getNumber(Input, Default)
		local Number = tonumber(Input.Text)
	
		if not Number then
			Input.Text = tostring(Default)
			return Default
		end
	
		Number = math.clamp(math.floor(Number + 0.5), 1, 1000000)
		Input.Text = tostring(Number)
	
		return Number
	end
	
	local function getCharacterData()
		local Character = Player.Character
	
		if not Character then
			return nil, nil
		end
	
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local Root = Character:FindFirstChild("HumanoidRootPart")
	
		return Humanoid, Root
	end
	
	local function cframeModeEnabled()
		return CFrameBoost:GetAttribute("Enabled")
	end
	
	Switch.MouseButton1Click:Connect(function()
		local Enabled = not CFrameBoost:GetAttribute("Enabled")
	
		CFrameBoost:SetAttribute("Enabled", Enabled)
		render()
	
		if Enabled then
			Notify:Fire(
				"CFrame Boost",
				"CFrame movement mode enabled.",
				Color3.fromRGB(154, 105, 255)
			)
		else
			ActiveJump = nil
	
			Notify:Fire(
				"CFrame Boost",
				"CFrame movement mode disabled.",
				Color3.fromRGB(154, 105, 255)
			)
		end
	end)
	
	UserInputService.JumpRequest:Connect(function()
		if not cframeModeEnabled() then
			return
		end
	
		if not JumpBoost:GetAttribute("Enabled") then
			return
		end
	
		if time() - LastJumpTime < 0.28 then
			return
		end
	
		local Humanoid, Root = getCharacterData()
	
		if not Humanoid or not Root or Humanoid.Health <= 0 then
			return
		end
	
		if Humanoid.FloorMaterial == Enum.Material.Air then
			return
		end
	
		LastJumpTime = time()
	
		local JumpValue = getNumber(JumpPowerInput, 75)
	
		-- CFrame height is capped for stable movement.
		-- The movement is spread over time rather than happening in one frame.
		local Height = math.clamp(JumpValue * 0.10, 3, 180)
	
		-- Larger jump values take slightly longer to accelerate upward.
		local Duration = math.clamp(0.16 + (Height / 900), 0.16, 0.36)
	
		ActiveJump = {
			Elapsed = 0,
			Duration = Duration,
			Height = Height,
			AppliedHeight = 0,
		}
	
		-- Keeps Roblox jump state and animation active.
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = 50
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
	
	RunService:BindToRenderStep(
		"RyzoxCFrameMovement",
		Enum.RenderPriority.Last.Value,
		function(DeltaTime)
			local Humanoid, Root = getCharacterData()
	
			if not Humanoid or not Root or Humanoid.Health <= 0 then
				ActiveJump = nil
				return
			end
	
			if cframeModeEnabled() and SpeedBoost:GetAttribute("Enabled") then
				-- CFrame mode replaces normal horizontal WalkSpeed movement.
				Humanoid.WalkSpeed = 16
	
				local Direction = Humanoid.MoveDirection
				local HorizontalDirection = Vector3.new(Direction.X, 0, Direction.Z)
	
				if HorizontalDirection.Magnitude > 0 then
					local Speed = getNumber(WalkSpeedInput, 32)
					local Distance = math.clamp(Speed * DeltaTime, 0, 10000)
	
					Root.CFrame = Root.CFrame + (HorizontalDirection.Unit * Distance)
				end
			end
	
			if cframeModeEnabled() and JumpBoost:GetAttribute("Enabled") then
				-- Prevents the normal huge JumpPower from fighting the smooth CFrame lift.
				Humanoid.UseJumpPower = true
				Humanoid.JumpPower = 50
			end
	
			if not ActiveJump then
				return
			end
	
			if not cframeModeEnabled() or not JumpBoost:GetAttribute("Enabled") then
				ActiveJump = nil
				return
			end
	
			ActiveJump.Elapsed += DeltaTime
	
			local Progress = math.clamp(
				ActiveJump.Elapsed / ActiveJump.Duration,
				0,
				1
			)
	
			-- Ease-out movement:
			-- fast initial lift, gradually slowing before gravity takes over.
			local EasedProgress = 1 - ((1 - Progress) * (1 - Progress))
			local WantedHeight = ActiveJump.Height * EasedProgress
			local StepHeight = WantedHeight - ActiveJump.AppliedHeight
	
			ActiveJump.AppliedHeight = WantedHeight
	
			if StepHeight > 0 then
				Root.CFrame = Root.CFrame + Vector3.new(0, StepHeight, 0)
			end
	
			if Progress >= 1 then
				ActiveJump = nil
	
				-- Gives control back to Roblox physics for normal falling and landing.
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end
		end
	)
	
	Player.CharacterAdded:Connect(function()
		ActiveJump = nil
	
		task.wait(0.4)
		render()
	end)
	
	render()
	
end;
task.spawn(C_12);
-- StarterGui.RyzoxClient.Scripts.TransparencyFixController
local function C_13()
local script = G2L["13"];
	local RunService = game:GetService("RunService")
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	
	local FixedTransparency = 0.43
	
	Main:SetAttribute("RyzoxFixedTransparency", FixedTransparency)
	
	RunService.RenderStepped:Connect(function()
		if Gui:GetAttribute("MenuOpen") and Main.Visible then
			-- Keeps the fixed transparency after every menu reopen.
			-- The MenuController cannot overwrite it with 0 anymore.
			if Main.BackgroundTransparency < FixedTransparency then
				Main.BackgroundTransparency = FixedTransparency
			end
		end
	end)
	
end;
task.spawn(C_13);
-- StarterGui.RyzoxClient.Scripts.CameraLockController
local function C_14()
local script = G2L["14"];
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	
	local Player = Players.LocalPlayer
	local Gui = script.Parent.Parent
	local Page = Gui.Main.PageContainer.CameraLock
	
	local Enabled = Page.Enabled
	local TargetButton = Page.Target.Button
	local AutoButton = Page.Auto.Button
	local IgnorePlayers = Page.IgnorePlayers
	local IgnoreNPCs = Page.IgnoreNPCs
	local IgnoreTeam = Page.IgnoreTeam
	
	local Selected = nil
	local CurrentTarget = nil
	local LastSearch = 0
	
	local NPCIds = setmetatable({}, {__mode = "k"})
	local UsedNPCIds = {}
	
	local MAX_DISTANCE = 350
	local SMOOTHNESS = 0.18
	local AUTO_REFRESH = 0.15
	
	local function renderToggle(card)
		local enabled = card:GetAttribute("Enabled")
		local switch = card.Switch
	
		switch.BackgroundColor3 = enabled
			and Color3.fromRGB(79, 153, 255)
			or Color3.fromRGB(44, 50, 64)
	
		switch.Dot.Position = enabled
			and UDim2.fromOffset(26, 4)
			or UDim2.fromOffset(4, 4)
	end
	
	for _, card in ipairs({
		Enabled,
		IgnorePlayers,
		IgnoreNPCs,
		IgnoreTeam
	}) do
		renderToggle(card)
	
		card.Switch.MouseButton1Click:Connect(function()
			card:SetAttribute("Enabled", not card:GetAttribute("Enabled"))
		end)
	
		card:GetAttributeChangedSignal("Enabled"):Connect(function()
			renderToggle(card)
		end)
	end
	
	local function getRoot(model)
		if not model then
			return nil
		end
	
		return model:FindFirstChild("HumanoidRootPart")
			or model:FindFirstChild("UpperTorso")
			or model:FindFirstChild("Torso")
	end
	
	local function getHead(model)
		local humanoid = model and model:FindFirstChildOfClass("Humanoid")
		local part = model and model:FindFirstChild("Head")
	
		if humanoid and humanoid.Health > 0 and part and part:IsA("BasePart") then
			return part
		end
	end
	
	local function getNPCId(model)
		if NPCIds[model] then
			return NPCIds[model]
		end
	
		local id
	
		repeat
			id = math.random(1, 1000000)
		until not UsedNPCIds[id]
	
		NPCIds[model] = id
		UsedNPCIds[id] = true
	
		return id
	end
	
	local function isValidTarget(model)
		if not model or model == Player.Character then
			return false
		end
	
		local localRoot = getRoot(Player.Character)
		local targetHead = getHead(model)
	
		if not localRoot or not targetHead then
			return false
		end
	
		local targetPlayer = Players:GetPlayerFromCharacter(model)
	
		if targetPlayer then
			if IgnorePlayers:GetAttribute("Enabled") then
				return false
			end
	
			if IgnoreTeam:GetAttribute("Enabled")
				and Player.Team
				and targetPlayer.Team
				and Player.Team == targetPlayer.Team then
				return false
			end
		elseif IgnoreNPCs:GetAttribute("Enabled") then
			return false
		end
	
		return (targetHead.Position - localRoot.Position).Magnitude <= MAX_DISTANCE
	end
	
	local function getClosestPlayer()
		local localRoot = getRoot(Player.Character)
	
		if not localRoot then
			return nil
		end
	
		local closest = nil
		local shortestDistance = math.huge
		local checked = {}
	
		local function checkTarget(model)
			if not model or checked[model] or not isValidTarget(model) then
				return
			end
	
			checked[model] = true
	
			local targetRoot = getRoot(model)
	
			if not targetRoot then
				return
			end
	
			local distance = (targetRoot.Position - localRoot.Position).Magnitude
	
			if distance < shortestDistance then
				shortestDistance = distance
				closest = model
			end
		end
	
		for _, otherPlayer in ipairs(Players:GetPlayers()) do
			if otherPlayer ~= Player then
				checkTarget(otherPlayer.Character)
			end
		end
	
		for _, object in ipairs(Workspace:GetDescendants()) do
			if object:IsA("Model") and not Players:GetPlayerFromCharacter(object) then
				checkTarget(object)
			end
		end
	
		return closest
	end
	
	local function resolveManualTarget()
		if not Selected then
			return nil
		end
	
		if Selected.Type == "Player" then
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer.UserId == Selected.UserId then
					return otherPlayer.Character
				end
			end
	
			return nil
		end
	
		for model, id in pairs(NPCIds) do
			if id == Selected.NPCId and model and model.Parent then
				return model
			end
		end
	
		return nil
	end
	
	local function getTargetDisplayName(model)
		local targetPlayer = Players:GetPlayerFromCharacter(model)
	
		if targetPlayer then
			return targetPlayer.Name
		end
	
		return model.Name .. " #" .. tostring(getNPCId(model))
	end
	
	local function updateTargetButton()
		if Selected then
			TargetButton.Text = Selected.Name
		else
			TargetButton.Text = "Auto target"
		end
	end
	
	local Selection = Instance.new("Frame")
	Selection.Name = "Selection"
	Selection.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	Selection.BackgroundTransparency = 0.05
	Selection.BorderSizePixel = 0
	Selection.LayoutOrder = 2.5
	Selection.Size = UDim2.new(1, 0, 0, 0)
	Selection.Visible = false
	Selection.ClipsDescendants = true
	Selection.Parent = Page
	
	local selectionCorner = Instance.new("UICorner")
	selectionCorner.CornerRadius = UDim.new(0, 12)
	selectionCorner.Parent = Selection
	
	local selectionStroke = Instance.new("UIStroke")
	selectionStroke.Color = Color3.fromRGB(79, 153, 255)
	selectionStroke.Transparency = 0.55
	selectionStroke.Parent = Selection
	
	local selectionTitle = Instance.new("TextLabel")
	selectionTitle.Name = "Title"
	selectionTitle.BackgroundTransparency = 1
	selectionTitle.Position = UDim2.fromOffset(16, 12)
	selectionTitle.Size = UDim2.new(1, -70, 0, 20)
	selectionTitle.Font = Enum.Font.GothamBold
	selectionTitle.Text = "Select Target"
	selectionTitle.TextColor3 = Color3.fromRGB(246, 248, 254)
	selectionTitle.TextSize = 14
	selectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	selectionTitle.Parent = Selection
	
	local selectionDescription = Instance.new("TextLabel")
	selectionDescription.Name = "Description"
	selectionDescription.BackgroundTransparency = 1
	selectionDescription.Position = UDim2.fromOffset(16, 33)
	selectionDescription.Size = UDim2.new(1, -70, 0, 16)
	selectionDescription.Font = Enum.Font.GothamMedium
	selectionDescription.Text = "Select a player or NPC to follow."
	selectionDescription.TextColor3 = Color3.fromRGB(167, 176, 195)
	selectionDescription.TextSize = 10
	selectionDescription.TextXAlignment = Enum.TextXAlignment.Left
	selectionDescription.Parent = Selection
	
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "Close"
	closeButton.AutoButtonColor = false
	closeButton.BackgroundTransparency = 1
	closeButton.Position = UDim2.new(1, -48, 0, 4)
	closeButton.Size = UDim2.fromOffset(40, 40)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(167, 176, 195)
	closeButton.TextSize = 25
	closeButton.Parent = Selection
	
	local autoSelect = Instance.new("TextButton")
	autoSelect.Name = "AutoTarget"
	autoSelect.AutoButtonColor = false
	autoSelect.BackgroundColor3 = Color3.fromRGB(44, 50, 64)
	autoSelect.BorderSizePixel = 0
	autoSelect.Position = UDim2.fromOffset(16, 62)
	autoSelect.Size = UDim2.new(1, -32, 0, 42)
	autoSelect.Font = Enum.Font.GothamBold
	autoSelect.Text = "Automatic Target\nClosest valid player to your character"
	autoSelect.TextColor3 = Color3.fromRGB(79, 153, 255)
	autoSelect.TextSize = 11
	autoSelect.TextWrapped = true
	autoSelect.Parent = Selection
	
	local autoCorner = Instance.new("UICorner")
	autoCorner.CornerRadius = UDim.new(0, 8)
	autoCorner.Parent = autoSelect
	
	local list = Instance.new("ScrollingFrame")
	list.Name = "TargetList"
	list.Active = true
	list.BackgroundColor3 = Color3.fromRGB(17, 20, 28)
	list.BorderSizePixel = 0
	list.CanvasSize = UDim2.new()
	list.Position = UDim2.fromOffset(16, 114)
	list.Size = UDim2.new(1, -32, 1, -130)
	list.ScrollBarImageColor3 = Color3.fromRGB(79, 153, 255)
	list.ScrollBarThickness = 3
	list.Parent = Selection
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 8)
	listCorner.Parent = list
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = list
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingRight = UDim.new(0, 6)
	padding.Parent = list
	
	local function setSelectorOpen(open)
		Selection.Visible = open
		Selection.Size = open
			and UDim2.new(1, 0, 0, 330)
			or UDim2.new(1, 0, 0, 0)
	end
	
	local function clearSelection()
		Selected = nil
		CurrentTarget = nil
		updateTargetButton()
		setSelectorOpen(false)
	end
	
	local function addEntry(model)
		local localRoot = getRoot(Player.Character)
		local targetRoot = getRoot(model)
		local targetPlayer = Players:GetPlayerFromCharacter(model)
	
		local distance = 0
	
		if localRoot and targetRoot then
			distance = math.floor((targetRoot.Position - localRoot.Position).Magnitude)
		end
	
		local entry = Instance.new("TextButton")
		entry.AutoButtonColor = false
		entry.BackgroundColor3 = Color3.fromRGB(44, 50, 64)
		entry.BorderSizePixel = 0
		entry.Size = UDim2.new(1, 0, 0, 44)
		entry.Font = Enum.Font.GothamBold
		entry.Text = ""
		entry.Parent = list
	
		local entryCorner = Instance.new("UICorner")
		entryCorner.CornerRadius = UDim.new(0, 7)
		entryCorner.Parent = entry
	
		local typeLabel = Instance.new("TextLabel")
		typeLabel.BackgroundTransparency = 1
		typeLabel.Position = UDim2.fromOffset(12, 6)
		typeLabel.Size = UDim2.fromOffset(58, 14)
		typeLabel.Font = Enum.Font.GothamBold
		typeLabel.Text = targetPlayer and "PLAYER" or "NPC"
		typeLabel.TextColor3 = targetPlayer
			and Color3.fromRGB(98, 181, 255)
			or Color3.fromRGB(249, 157, 85)
		typeLabel.TextSize = 9
		typeLabel.TextXAlignment = Enum.TextXAlignment.Left
		typeLabel.Parent = entry
	
		local nameLabel = Instance.new("TextLabel")
		nameLabel.BackgroundTransparency = 1
		nameLabel.Position = UDim2.fromOffset(12, 21)
		nameLabel.Size = UDim2.new(1, -92, 0, 16)
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.Text = getTargetDisplayName(model)
		nameLabel.TextColor3 = Color3.fromRGB(246, 248, 254)
		nameLabel.TextSize = 12
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = entry
	
		local distanceLabel = Instance.new("TextLabel")
		distanceLabel.BackgroundTransparency = 1
		distanceLabel.Position = UDim2.new(1, -76, 0, 14)
		distanceLabel.Size = UDim2.fromOffset(64, 16)
		distanceLabel.Font = Enum.Font.GothamMedium
		distanceLabel.Text = tostring(distance) .. " studs"
		distanceLabel.TextColor3 = Color3.fromRGB(167, 176, 195)
		distanceLabel.TextSize = 10
		distanceLabel.TextXAlignment = Enum.TextXAlignment.Right
		distanceLabel.Parent = entry
	
		entry.MouseButton1Click:Connect(function()
			if targetPlayer then
				Selected = {
					Type = "Player",
					UserId = targetPlayer.UserId,
					Name = targetPlayer.Name
				}
			else
				Selected = {
					Type = "NPC",
					NPCId = getNPCId(model),
					Name = getTargetDisplayName(model)
				}
			end
	
			CurrentTarget = model
			updateTargetButton()
			setSelectorOpen(false)
		end)
	end
	
	local function refreshSelector()
		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
	
		local targets = {}
		local added = {}
	
		if not IgnorePlayers:GetAttribute("Enabled") then
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer ~= Player and isValidTarget(otherPlayer.Character) then
					added[otherPlayer.Character] = true
					table.insert(targets, otherPlayer.Character)
				end
			end
		end
	
		if not IgnoreNPCs:GetAttribute("Enabled") then
			for _, object in ipairs(Workspace:GetDescendants()) do
				if object:IsA("Model")
					and not added[object]
					and not Players:GetPlayerFromCharacter(object)
					and isValidTarget(object) then
					getNPCId(object)
					table.insert(targets, object)
				end
			end
		end
	
		table.sort(targets, function(a, b)
			return getTargetDisplayName(a):lower() < getTargetDisplayName(b):lower()
		end)
	
		for _, model in ipairs(targets) do
			addEntry(model)
		end
	
		task.wait()
		list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 12)
	end
	
	TargetButton.MouseButton1Click:Connect(function()
		if Selection.Visible then
			setSelectorOpen(false)
			return
		end
	
		refreshSelector()
		setSelectorOpen(true)
	end)
	
	closeButton.MouseButton1Click:Connect(function()
		setSelectorOpen(false)
	end)
	
	autoSelect.MouseButton1Click:Connect(clearSelection)
	AutoButton.MouseButton1Click:Connect(clearSelection)
	
	RunService:BindToRenderStep("CameraLockUpdate", Enum.RenderPriority.Camera.Value + 1, function()
		if not Enabled:GetAttribute("Enabled") then
			return
		end
	
		if Selected then
			CurrentTarget = resolveManualTarget()
		elseif time() - LastSearch >= AUTO_REFRESH then
			CurrentTarget = getClosestPlayer()
			LastSearch = time()
		end
	
		if not isValidTarget(CurrentTarget) then
			return
		end
	
		local camera = Workspace.CurrentCamera
		local targetHead = getHead(CurrentTarget)
	
		if camera and targetHead then
			camera.CFrame = camera.CFrame:Lerp(
				CFrame.lookAt(camera.CFrame.Position, targetHead.Position),
				SMOOTHNESS
			)
		end
	end)
	
	updateTargetButton()
	
end;
task.spawn(C_14);
-- StarterGui.RyzoxClient.Scripts.CameraLockBindController
local function C_15()
local script = G2L["15"];
	local UserInputService = game:GetService("UserInputService")
	
	local Gui = script.Parent.Parent
	local Settings = Gui.Main.PageContainer.Settings
	local CameraLockPage = Gui.Main.PageContainer.CameraLock
	
	local Card = Settings:WaitForChild("CameraLockBind")
	local BindButton = Card:WaitForChild("BindButton")
	local ResetButton = Card:WaitForChild("Reset")
	local CameraLockToggle = CameraLockPage:WaitForChild("Enabled")
	
	local WaitingForKey = false
	local CurrentKey = ""
	
	local function setKey(keyName)
		CurrentKey = keyName or ""
	
		Card:SetAttribute("Key", CurrentKey)
		Gui:SetAttribute("CameraLockKey", CurrentKey)
	
		if CurrentKey == "" then
			BindButton.Text = "None"
			BindButton.TextColor3 = Color3.fromRGB(167, 176, 195)
		else
			BindButton.Text = CurrentKey
			BindButton.TextColor3 = Color3.fromRGB(78, 152, 255)
		end
	end
	
	BindButton.MouseButton1Click:Connect(function()
		if WaitingForKey then
			return
		end
	
		WaitingForKey = true
		BindButton.Text = "Press key..."
		BindButton.TextColor3 = Color3.fromRGB(78, 152, 255)
	end)
	
	ResetButton.MouseButton1Click:Connect(function()
		WaitingForKey = false
		setKey("")
	end)
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if WaitingForKey then
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
	
			if input.KeyCode == Enum.KeyCode.Escape then
				WaitingForKey = false
				setKey(CurrentKey)
				return
			end
	
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				WaitingForKey = false
				setKey(input.KeyCode.Name)
			end
	
			return
		end
	
		if gameProcessed then
			return
		end
	
		if UserInputService:GetFocusedTextBox() then
			return
		end
	
		if CurrentKey ~= ""
			and input.UserInputType == Enum.UserInputType.Keyboard
			and input.KeyCode.Name == CurrentKey then
			CameraLockToggle:SetAttribute(
				"Enabled",
				not CameraLockToggle:GetAttribute("Enabled")
			)
		end
	end)
	
	setKey("")
	
end;
task.spawn(C_15);
-- StarterGui.RyzoxClient.Scripts.MobileDynamicIslandController
local function C_16()
local script = G2L["16"];
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	
	if not UserInputService.TouchEnabled then
		return
	end
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Header = Main:WaitForChild("Header")
	local Title = Header:WaitForChild("Title")
	
	local existing = Gui:FindFirstChild("MobileDynamicIsland")
	
	if existing then
		return
	end
	
	local island = Instance.new("TextButton")
	island.Name = "MobileDynamicIsland"
	island.AnchorPoint = Vector2.new(0.5, 0)
	island.AutoButtonColor = false
	island.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
	island.BorderSizePixel = 0
	island.Position = UDim2.new(0.5, 0, 0, 14)
	island.Size = UDim2.fromOffset(190, 42)
	island.Font = Enum.Font.GothamBold
	island.Text = Title.Text
	island.TextColor3 = Color3.fromRGB(246, 248, 254)
	island.TextSize = 13
	island.ZIndex = 1000
	island.Parent = Gui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = island
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(79, 153, 255)
	stroke.Transparency = 0.45
	stroke.Thickness = 1
	stroke.Parent = island
	
	local dot = Instance.new("Frame")
	dot.Name = "StatusDot"
	dot.AnchorPoint = Vector2.new(0, 0.5)
	dot.BackgroundColor3 = Color3.fromRGB(79, 153, 255)
	dot.BorderSizePixel = 0
	dot.Position = UDim2.fromOffset(14, 21)
	dot.Size = UDim2.fromOffset(7, 7)
	dot.ZIndex = 1001
	dot.Parent = island
	
	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot
	
	local dragging = false
	local dragStart = nil
	local startPosition = nil
	local moved = false
	
	local function clampPosition(position)
		local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
	
		if not viewport then
			return position
		end
	
		local width = island.AbsoluteSize.X
		local height = island.AbsoluteSize.Y
	
		local x = math.clamp(position.X.Offset, width / 2 + 8, viewport.X - width / 2 - 8)
		local y = math.clamp(position.Y.Offset, 8, viewport.Y - height - 8)
	
		return UDim2.new(0, x, 0, y)
	end
	
	island.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
	
		dragging = true
		moved = false
		dragStart = input.Position
		startPosition = island.Position
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if not dragging or input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
	
		local delta = input.Position - dragStart
	
		if delta.Magnitude > 8 then
			moved = true
		end
	
		island.Position = clampPosition(
			UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		)
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if not dragging or input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
	
		dragging = false
	
		if not moved then
			Gui:SetAttribute(
				"RequestedMenuOpen",
				not Gui:GetAttribute("MenuOpen")
			)
		end
	end)
	
	Gui:GetAttributeChangedSignal("MenuOpen"):Connect(function()
		local open = Gui:GetAttribute("MenuOpen")
	
		dot.BackgroundColor3 = open
			and Color3.fromRGB(53, 207, 138)
			or Color3.fromRGB(79, 153, 255)
	end)
	
end;
task.spawn(C_16);
-- StarterGui.RyzoxClient.Scripts.ResponsiveLayoutController
local function C_17()
local script = G2L["17"];
	local Workspace = game:GetService("Workspace")
	
	local Gui = script.Parent.Parent
	local Main = Gui:WaitForChild("Main")
	local Scale = Main:WaitForChild("RyzoxResponsiveScale")
	
	local function updateLayout()
		local camera = Workspace.CurrentCamera
	
		if not camera then
			return
		end
	
		local viewport = camera.ViewportSize
	
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
	
		local oldScale = math.max(Scale.Scale, 0.01)
		local currentSize = Main.AbsoluteSize
		local baseWidth = currentSize.X / oldScale
		local baseHeight = currentSize.Y / oldScale
	
		if baseWidth <= 0 or baseHeight <= 0 then
			return
		end
	
		local horizontalMargin = viewport.X < 700 and 18 or 48
		local verticalMargin = viewport.Y < 700 and 18 or 48
	
		local availableWidth = viewport.X - horizontalMargin
		local availableHeight = viewport.Y - verticalMargin
	
		local widthScale = availableWidth / baseWidth
		local heightScale = availableHeight / baseHeight
	
		local wantedScale = math.min(widthScale, heightScale, 1)
		wantedScale = math.clamp(wantedScale, 0.52, 1)
	
		Scale.Scale = wantedScale
	
		if viewport.X < 700 then
			Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end
	
	local function connectCamera()
		local camera = Workspace.CurrentCamera
	
		if not camera then
			return
		end
	
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
		updateLayout()
	end
	
	Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(connectCamera)
	
	task.defer(connectCamera)
	
end;
task.spawn(C_17);

return G2L["1"], require;
