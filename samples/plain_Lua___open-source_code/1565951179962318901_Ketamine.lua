-- [[ GENERATED WITH InfernoHub/Scriptify STUDIO PLUGIN ]] --
-- Scriptify Version: 1.0

--

-- Create objects
local parent = nil;
local objects = {
    ["Instance0"] = Instance.new("ScreenGui"); -- Ketamine
    ["Instance1"] = Instance.new("TextButton"); -- Window
    ["Instance2"] = Instance.new("LocalScript"); -- UIControl
    ["Instance3"] = Instance.new("ModuleScript"); -- Settings
    ["Instance4"] = Instance.new("ModuleScript"); -- Shared
    ["Instance5"] = Instance.new("ModuleScript"); -- CodeBox
    ["Instance6"] = Instance.new("ModuleScript"); -- ToString
    ["Instance7"] = Instance.new("ModuleScript"); -- HookFunction
    ["Instance8"] = Instance.new("ModuleScript"); -- Changelogs
    ["Instance9"] = Instance.new("Folder"); -- PageControls
    ["Instance10"] = Instance.new("ModuleScript"); -- Settings
    ["Instance11"] = Instance.new("ModuleScript"); -- RSpy
    ["Instance12"] = Instance.new("ModuleScript"); -- ESpy
    ["Instance13"] = Instance.new("ModuleScript"); -- HTTPSpy
    ["Instance14"] = Instance.new("ModuleScript"); -- ScriptScanner
    ["Instance15"] = Instance.new("ModuleScript"); -- MemoryScanner
    ["Instance16"] = Instance.new("ModuleScript"); -- Home
    ["Instance17"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance18"] = Instance.new("ImageLabel"); -- Shadow
    ["Instance19"] = Instance.new("Frame"); -- Main
    ["Instance20"] = Instance.new("Frame"); -- TopbarZone
    ["Instance21"] = Instance.new("ImageLabel"); -- Icon
    ["Instance22"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance23"] = Instance.new("ImageLabel"); -- Glow
    ["Instance24"] = Instance.new("TextLabel"); -- Title
    ["Instance25"] = Instance.new("Frame"); -- Separator
    ["Instance26"] = Instance.new("Frame"); -- Buttons
    ["Instance27"] = Instance.new("TextButton"); -- Minimize
    ["Instance28"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance29"] = Instance.new("ImageLabel"); -- Icon
    ["Instance30"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance31"] = Instance.new("TextButton"); -- Close
    ["Instance32"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance33"] = Instance.new("ImageLabel"); -- Icon
    ["Instance34"] = Instance.new("Frame"); -- Contents
    ["Instance35"] = Instance.new("Frame"); -- Buttons
    ["Instance36"] = Instance.new("Frame"); -- Separator
    ["Instance37"] = Instance.new("Frame"); -- Holder
    ["Instance38"] = Instance.new("ScrollingFrame"); -- List
    ["Instance39"] = Instance.new("TextButton"); -- Settings
    ["Instance40"] = Instance.new("Frame"); -- Cut
    ["Instance41"] = Instance.new("TextLabel"); -- Label
    ["Instance42"] = Instance.new("ImageLabel"); -- Icon
    ["Instance43"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance44"] = Instance.new("TextButton"); -- MemoryScanner
    ["Instance45"] = Instance.new("Frame"); -- Cut
    ["Instance46"] = Instance.new("ImageLabel"); -- Icon
    ["Instance47"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance48"] = Instance.new("TextLabel"); -- Label
    ["Instance49"] = Instance.new("TextButton"); -- ScriptScanner
    ["Instance50"] = Instance.new("Frame"); -- Cut
    ["Instance51"] = Instance.new("ImageLabel"); -- Icon
    ["Instance52"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance53"] = Instance.new("TextLabel"); -- Label
    ["Instance54"] = Instance.new("TextButton"); -- RSpy
    ["Instance55"] = Instance.new("Frame"); -- Cut
    ["Instance56"] = Instance.new("TextLabel"); -- Label
    ["Instance57"] = Instance.new("ImageLabel"); -- Icon
    ["Instance58"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance59"] = Instance.new("TextButton"); -- Home
    ["Instance60"] = Instance.new("Frame"); -- Cut
    ["Instance61"] = Instance.new("ImageLabel"); -- Icon
    ["Instance62"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance63"] = Instance.new("TextLabel"); -- Label
    ["Instance64"] = Instance.new("TextButton"); -- HTTPSpy
    ["Instance65"] = Instance.new("Frame"); -- Cut
    ["Instance66"] = Instance.new("ImageLabel"); -- Icon
    ["Instance67"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance68"] = Instance.new("TextLabel"); -- Label
    ["Instance69"] = Instance.new("TextButton"); -- ESpy
    ["Instance70"] = Instance.new("Frame"); -- Cut
    ["Instance71"] = Instance.new("TextLabel"); -- Label
    ["Instance72"] = Instance.new("ImageLabel"); -- Icon
    ["Instance73"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance74"] = Instance.new("Frame"); -- Separator
    ["Instance75"] = Instance.new("TextLabel"); -- Label
    ["Instance76"] = Instance.new("Frame"); -- SeparatorLeft
    ["Instance77"] = Instance.new("Frame"); -- SeparatorRight
    ["Instance78"] = Instance.new("Frame"); -- Separator
    ["Instance79"] = Instance.new("TextLabel"); -- Label
    ["Instance80"] = Instance.new("Frame"); -- SeparatorLeft
    ["Instance81"] = Instance.new("Frame"); -- SeparatorRight
    ["Instance82"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance83"] = Instance.new("Frame"); -- Pages
    ["Instance84"] = Instance.new("Frame"); -- NotFound
    ["Instance85"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance86"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance87"] = Instance.new("Frame"); -- RSpy
    ["Instance88"] = Instance.new("Frame"); -- Buttons
    ["Instance89"] = Instance.new("TextButton"); -- To
    ["Instance90"] = Instance.new("ImageLabel"); -- Icon
    ["Instance91"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance92"] = Instance.new("TextLabel"); -- Label
    ["Instance93"] = Instance.new("TextButton"); -- From
    ["Instance94"] = Instance.new("ImageLabel"); -- Icon
    ["Instance95"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance96"] = Instance.new("TextLabel"); -- Label
    ["Instance97"] = Instance.new("Frame"); -- Separator
    ["Instance98"] = Instance.new("Frame"); -- Separator
    ["Instance99"] = Instance.new("Frame"); -- Contents
    ["Instance100"] = Instance.new("Frame"); -- From
    ["Instance101"] = Instance.new("ScrollingFrame"); -- Logs
    ["Instance102"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance103"] = Instance.new("TextButton"); -- Log
    ["Instance104"] = Instance.new("Frame"); -- Contents
    ["Instance105"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance106"] = Instance.new("Frame"); -- Frame
    ["Instance107"] = Instance.new("TextLabel"); -- Label
    ["Instance108"] = Instance.new("Frame"); -- Selection
    ["Instance109"] = Instance.new("Frame"); -- Separator
    ["Instance110"] = Instance.new("Frame"); -- To
    ["Instance111"] = Instance.new("ScrollingFrame"); -- Logs
    ["Instance112"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance113"] = Instance.new("TextButton"); -- Log
    ["Instance114"] = Instance.new("Frame"); -- Contents
    ["Instance115"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance116"] = Instance.new("Frame"); -- Frame
    ["Instance117"] = Instance.new("TextLabel"); -- Label
    ["Instance118"] = Instance.new("Frame"); -- Selection
    ["Instance119"] = Instance.new("TextBox"); -- TextBox
    ["Instance120"] = Instance.new("Frame"); -- Separator
    ["Instance121"] = Instance.new("ScrollingFrame"); -- Buttons
    ["Instance122"] = Instance.new("UIGridLayout"); -- UIGridLayout
    ["Instance123"] = Instance.new("TextButton"); -- Button
    ["Instance124"] = Instance.new("Frame"); -- Contents
    ["Instance125"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance126"] = Instance.new("Frame"); -- Frame
    ["Instance127"] = Instance.new("TextLabel"); -- Label
    ["Instance128"] = Instance.new("Frame"); -- Selection
    ["Instance129"] = Instance.new("Frame"); -- Separator
    ["Instance130"] = Instance.new("ScrollingFrame"); -- Settings
    ["Instance131"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance132"] = Instance.new("TextButton"); -- boolean
    ["Instance133"] = Instance.new("Frame"); -- State
    ["Instance134"] = Instance.new("UICorner"); -- UICorner
    ["Instance135"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance136"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance137"] = Instance.new("Frame"); -- State
    ["Instance138"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance139"] = Instance.new("UICorner"); -- UICorner
    ["Instance140"] = Instance.new("TextLabel"); -- Label
    ["Instance141"] = Instance.new("Frame"); -- Frame
    ["Instance142"] = Instance.new("Frame"); -- table
    ["Instance143"] = Instance.new("Frame"); -- State
    ["Instance144"] = Instance.new("UICorner"); -- UICorner
    ["Instance145"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance146"] = Instance.new("Frame"); -- Pointer
    ["Instance147"] = Instance.new("UICorner"); -- UICorner
    ["Instance148"] = Instance.new("Frame"); -- Fill
    ["Instance149"] = Instance.new("UICorner"); -- UICorner
    ["Instance150"] = Instance.new("TextLabel"); -- Label
    ["Instance151"] = Instance.new("Frame"); -- Frame
    ["Instance152"] = Instance.new("TextButton"); -- Hitbox
    ["Instance153"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance154"] = Instance.new("Frame"); -- Separator
    ["Instance155"] = Instance.new("TextLabel"); -- Label
    ["Instance156"] = Instance.new("Frame"); -- FrameLeft
    ["Instance157"] = Instance.new("Frame"); -- FrameRight
    ["Instance158"] = Instance.new("Frame"); -- Home
    ["Instance159"] = Instance.new("TextLabel"); -- Title
    ["Instance160"] = Instance.new("Frame"); -- Separator
    ["Instance161"] = Instance.new("ScrollingFrame"); -- Changelogs
    ["Instance162"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance163"] = Instance.new("TextLabel"); -- Log
    ["Instance164"] = Instance.new("Frame"); -- ESpy
    ["Instance165"] = Instance.new("ScrollingFrame"); -- Buttons
    ["Instance166"] = Instance.new("UIGridLayout"); -- UIGridLayout
    ["Instance167"] = Instance.new("TextButton"); -- Button
    ["Instance168"] = Instance.new("Frame"); -- Contents
    ["Instance169"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance170"] = Instance.new("Frame"); -- Frame
    ["Instance171"] = Instance.new("TextLabel"); -- Label
    ["Instance172"] = Instance.new("Frame"); -- Selection
    ["Instance173"] = Instance.new("Frame"); -- Separator
    ["Instance174"] = Instance.new("Frame"); -- Separator
    ["Instance175"] = Instance.new("ScrollingFrame"); -- Logs
    ["Instance176"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance177"] = Instance.new("TextButton"); -- Log
    ["Instance178"] = Instance.new("Frame"); -- Contents
    ["Instance179"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance180"] = Instance.new("Frame"); -- Frame
    ["Instance181"] = Instance.new("TextLabel"); -- Label
    ["Instance182"] = Instance.new("Frame"); -- Selection
    ["Instance183"] = Instance.new("TextBox"); -- TextBox
    ["Instance184"] = Instance.new("Frame"); -- Separator
    ["Instance185"] = Instance.new("Frame"); -- HTTPSpy
    ["Instance186"] = Instance.new("TextLabel"); -- Unavailable
    ["Instance187"] = Instance.new("Frame"); -- Contents
    ["Instance188"] = Instance.new("TextBox"); -- TextBox
    ["Instance189"] = Instance.new("Frame"); -- Separator
    ["Instance190"] = Instance.new("Frame"); -- Separator
    ["Instance191"] = Instance.new("ScrollingFrame"); -- Logs
    ["Instance192"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance193"] = Instance.new("TextButton"); -- Log
    ["Instance194"] = Instance.new("Frame"); -- Contents
    ["Instance195"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance196"] = Instance.new("Frame"); -- Frame
    ["Instance197"] = Instance.new("TextLabel"); -- Label
    ["Instance198"] = Instance.new("Frame"); -- Selection
    ["Instance199"] = Instance.new("Frame"); -- Type
    ["Instance200"] = Instance.new("ScrollingFrame"); -- Buttons
    ["Instance201"] = Instance.new("UIGridLayout"); -- UIGridLayout
    ["Instance202"] = Instance.new("TextButton"); -- Button
    ["Instance203"] = Instance.new("Frame"); -- Contents
    ["Instance204"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance205"] = Instance.new("Frame"); -- Frame
    ["Instance206"] = Instance.new("TextLabel"); -- Label
    ["Instance207"] = Instance.new("Frame"); -- Selection
    ["Instance208"] = Instance.new("Frame"); -- Separator
    ["Instance209"] = Instance.new("Frame"); -- ScriptScanner
    ["Instance210"] = Instance.new("Frame"); -- Contents
    ["Instance211"] = Instance.new("TextButton"); -- SearchBar
    ["Instance212"] = Instance.new("UICorner"); -- UICorner
    ["Instance213"] = Instance.new("ImageLabel"); -- Icon
    ["Instance214"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance215"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance216"] = Instance.new("Frame"); -- Field
    ["Instance217"] = Instance.new("TextBox"); -- TextBox
    ["Instance218"] = Instance.new("Frame"); -- View
    ["Instance219"] = Instance.new("Frame"); -- Editor
    ["Instance220"] = Instance.new("TextBox"); -- TextBox
    ["Instance221"] = Instance.new("Frame"); -- Separator
    ["Instance222"] = Instance.new("TextButton"); -- CopyCode
    ["Instance223"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance224"] = Instance.new("Frame"); -- Frame
    ["Instance225"] = Instance.new("TextButton"); -- Back
    ["Instance226"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance227"] = Instance.new("Frame"); -- Frame
    ["Instance228"] = Instance.new("TextButton"); -- CopyPath
    ["Instance229"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance230"] = Instance.new("Frame"); -- Frame
    ["Instance231"] = Instance.new("TextButton"); -- Enchant
    ["Instance232"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance233"] = Instance.new("Frame"); -- ScanResults
    ["Instance234"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance235"] = Instance.new("ScrollingFrame"); -- List
    ["Instance236"] = Instance.new("TextButton"); -- Log
    ["Instance237"] = Instance.new("Frame"); -- Contents
    ["Instance238"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance239"] = Instance.new("UICorner"); -- UICorner
    ["Instance240"] = Instance.new("TextLabel"); -- ScriptName
    ["Instance241"] = Instance.new("TextLabel"); -- Matches
    ["Instance242"] = Instance.new("TextLabel"); -- ScriptPath
    ["Instance243"] = Instance.new("ImageLabel"); -- Icon
    ["Instance244"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance245"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance246"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance247"] = Instance.new("Frame"); -- Separator
    ["Instance248"] = Instance.new("Frame"); -- Loading
    ["Instance249"] = Instance.new("CanvasGroup"); -- CanvasGroup
    ["Instance250"] = Instance.new("UICorner"); -- UICorner
    ["Instance251"] = Instance.new("Frame"); -- Frame
    ["Instance252"] = Instance.new("Frame"); -- Gradient
    ["Instance253"] = Instance.new("UIGradient"); -- UIGradient
    ["Instance254"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance255"] = Instance.new("Frame"); -- Separator
    ["Instance256"] = Instance.new("TextButton"); -- Start
    ["Instance257"] = Instance.new("UICorner"); -- UICorner
    ["Instance258"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance259"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance260"] = Instance.new("Frame"); -- MemoryScanner
    ["Instance261"] = Instance.new("Frame"); -- Contents
    ["Instance262"] = Instance.new("TextButton"); -- SearchBar
    ["Instance263"] = Instance.new("UICorner"); -- UICorner
    ["Instance264"] = Instance.new("ImageLabel"); -- Icon
    ["Instance265"] = Instance.new("UIAspectRatioConstraint"); -- UIAspectRatioConstraint
    ["Instance266"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance267"] = Instance.new("Frame"); -- Field
    ["Instance268"] = Instance.new("TextBox"); -- TextBox
    ["Instance269"] = Instance.new("Frame"); -- View
    ["Instance270"] = Instance.new("Frame"); -- ScanResults
    ["Instance271"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance272"] = Instance.new("ScrollingFrame"); -- List
    ["Instance273"] = Instance.new("TextButton"); -- Log
    ["Instance274"] = Instance.new("Frame"); -- Contents
    ["Instance275"] = Instance.new("UIStroke"); -- UIStroke
    ["Instance276"] = Instance.new("UICorner"); -- UICorner
    ["Instance277"] = Instance.new("TextLabel"); -- Value
    ["Instance278"] = Instance.new("TextLabel"); -- Matches
    ["Instance279"] = Instance.new("UIListLayout"); -- UIListLayout
    ["Instance280"] = Instance.new("TextLabel"); -- TextLabel
    ["Instance281"] = Instance.new("Frame"); -- Separator
    ["Instance282"] = Instance.new("Frame"); -- Editor
    ["Instance283"] = Instance.new("TextBox"); -- TextBox
    ["Instance284"] = Instance.new("Frame"); -- Separator
    ["Instance285"] = Instance.new("TextButton"); -- CopyCode
    ["Instance286"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance287"] = Instance.new("Frame"); -- Frame
    ["Instance288"] = Instance.new("TextButton"); -- Back
    ["Instance289"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance290"] = Instance.new("Frame"); -- Frame
    ["Instance291"] = Instance.new("TextButton"); -- GenerateCode
    ["Instance292"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance293"] = Instance.new("Frame"); -- Frame
    ["Instance294"] = Instance.new("TextButton"); -- Parent
    ["Instance295"] = Instance.new("UIPadding"); -- UIPadding
    ["Instance296"] = Instance.new("Frame"); -- Frame
    ["Instance297"] = Instance.new("TextLabel"); -- Unavailable
    ["Instance298"] = Instance.new("TextButton"); -- Hover
    ["Instance299"] = Instance.new("UICorner"); -- UICorner
    ["Instance300"] = Instance.new("Frame"); -- Overlay
    ["Instance301"] = Instance.new("UICorner"); -- UICorner
};

do -- Set properties
    objects["Instance0"]["Enabled"] = true;
    objects["Instance0"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
    objects["Instance0"]["SafeAreaCompatibility"] = Enum.SafeAreaCompatibility.FullscreenExtension;
    objects["Instance0"]["ClipToDeviceSafeArea"] = true;
    objects["Instance0"]["Parent"] = parent;
    objects["Instance0"]["IgnoreGuiInset"] = true;
    objects["Instance0"]["Name"] = "Ketamine";
    objects["Instance0"]["DisplayOrder"] = 999999999;

    objects["Instance1"]["Visible"] = true;
    objects["Instance1"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance1"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance1"]["Active"] = true;
    objects["Instance1"]["TextStrokeTransparency"] = 1;
    objects["Instance1"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance1"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance1"]["ZIndex"] = 1;
    objects["Instance1"]["BorderSizePixel"] = 0;
    objects["Instance1"]["Draggable"] = false;
    objects["Instance1"]["RichText"] = false;
    objects["Instance1"]["Modal"] = false;
    objects["Instance1"]["AutoButtonColor"] = true;
    objects["Instance1"]["Transparency"] = 1;
    objects["Instance1"]["SelectionOrder"] = 0;
    objects["Instance1"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance1"]["TextScaled"] = false;
    objects["Instance1"]["TextWrap"] = false;
    objects["Instance1"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance1"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance1"]["Parent"] = objects["Instance0"];
    objects["Instance1"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance1"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance1"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance1"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance1"]["Selected"] = false;
    objects["Instance1"]["TextSize"] = 14;
    objects["Instance1"]["Size"] = UDim2.new(0.4000000059604645, 0, 0.4000000059604645, 0);
    objects["Instance1"]["BackgroundTransparency"] = 1;
    objects["Instance1"]["TextWrapped"] = false;
    objects["Instance1"]["ClipsDescendants"] = false;
    objects["Instance1"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance1"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance1"]["Text"] = "";
    objects["Instance1"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance1"]["LayoutOrder"] = 0;
    objects["Instance1"]["Rotation"] = 0;
    objects["Instance1"]["LineHeight"] = 1;
    objects["Instance1"]["Name"] = "Window";
    objects["Instance1"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance1"]["Selectable"] = true;
    objects["Instance1"]["MaxVisibleGraphemes"] = -1;
    objects["Instance1"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance1"]["TextTransparency"] = 0;

    objects["Instance2"]["Parent"] = objects["Instance1"];
    objects["Instance2"]["Name"] = "UIControl";
    objects["Instance2"]["Enabled"] = true;

    objects["Instance3"]["Parent"] = objects["Instance2"];
    objects["Instance3"]["Name"] = "Settings";

    objects["Instance4"]["Parent"] = objects["Instance2"];
    objects["Instance4"]["Name"] = "Shared";

    objects["Instance5"]["Parent"] = objects["Instance2"];
    objects["Instance5"]["Name"] = "CodeBox";

    objects["Instance6"]["Parent"] = objects["Instance2"];
    objects["Instance6"]["Name"] = "ToString";

    objects["Instance7"]["Parent"] = objects["Instance2"];
    objects["Instance7"]["Name"] = "HookFunction";

    objects["Instance8"]["Parent"] = objects["Instance2"];
    objects["Instance8"]["Name"] = "Changelogs";

    objects["Instance9"]["Name"] = "PageControls";
    objects["Instance9"]["Parent"] = objects["Instance2"];

    objects["Instance10"]["Parent"] = objects["Instance9"];
    objects["Instance10"]["Name"] = "Settings";

    objects["Instance11"]["Parent"] = objects["Instance9"];
    objects["Instance11"]["Name"] = "RSpy";

    objects["Instance12"]["Parent"] = objects["Instance9"];
    objects["Instance12"]["Name"] = "ESpy";

    objects["Instance13"]["Parent"] = objects["Instance9"];
    objects["Instance13"]["Name"] = "HTTPSpy";

    objects["Instance14"]["Parent"] = objects["Instance9"];
    objects["Instance14"]["Name"] = "ScriptScanner";

    objects["Instance15"]["Parent"] = objects["Instance9"];
    objects["Instance15"]["Name"] = "MemoryScanner";

    objects["Instance16"]["Parent"] = objects["Instance9"];
    objects["Instance16"]["Name"] = "Home";

    objects["Instance17"]["AspectRatio"] = 1.899999976158142;
    objects["Instance17"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance17"]["Parent"] = objects["Instance1"];
    objects["Instance17"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance17"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance18"]["Visible"] = true;
    objects["Instance18"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance18"]["Size"] = UDim2.new(1.100000023841858, 0, 1.149999976158142, 0);
    objects["Instance18"]["ImageTransparency"] = 0.20000000298023224;
    objects["Instance18"]["Parent"] = objects["Instance1"];
    objects["Instance18"]["Position"] = UDim2.new(0.512499988079071, 0, 0.5249999761581421, 0);
    objects["Instance18"]["BackgroundTransparency"] = 1;
    objects["Instance18"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance18"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance18"]["Image"] = "rbxassetid://8774493213";
    objects["Instance18"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance18"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance18"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance18"]["ZIndex"] = 0;
    objects["Instance18"]["BorderSizePixel"] = 0;
    objects["Instance18"]["SliceCenter"] = Rect.new(135, 135, 889, 512);
    objects["Instance18"]["Draggable"] = false;
    objects["Instance18"]["ScaleType"] = Enum.ScaleType.Slice;
    objects["Instance18"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance18"]["ClipsDescendants"] = false;
    objects["Instance18"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance18"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance18"]["LayoutOrder"] = 0;
    objects["Instance18"]["ImageColor3"] = Color3.new(0, 0, 0);
    objects["Instance18"]["Rotation"] = 0;
    objects["Instance18"]["Transparency"] = 1;
    objects["Instance18"]["Name"] = "Shadow";
    objects["Instance18"]["SelectionOrder"] = 0;
    objects["Instance18"]["SliceScale"] = 1;
    objects["Instance18"]["Selectable"] = false;
    objects["Instance18"]["Active"] = false;
    objects["Instance18"]["BackgroundColor3"] = Color3.new(0, 0, 0);

    objects["Instance19"]["LayoutOrder"] = 0;
    objects["Instance19"]["Active"] = false;
    objects["Instance19"]["Parent"] = objects["Instance1"];
    objects["Instance19"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance19"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance19"]["ZIndex"] = 1;
    objects["Instance19"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance19"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance19"]["Draggable"] = false;
    objects["Instance19"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance19"]["ClipsDescendants"] = false;
    objects["Instance19"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance19"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance19"]["BackgroundTransparency"] = 0.20000000298023224;
    objects["Instance19"]["BorderSizePixel"] = 0;
    objects["Instance19"]["Rotation"] = 0;
    objects["Instance19"]["Transparency"] = 0.20000000298023224;
    objects["Instance19"]["Name"] = "Main";
    objects["Instance19"]["SelectionOrder"] = 0;
    objects["Instance19"]["Visible"] = true;
    objects["Instance19"]["Selectable"] = false;
    objects["Instance19"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance19"]["BackgroundColor3"] = Color3.new(0.105882, 0.105882, 0.105882);

    objects["Instance20"]["LayoutOrder"] = 0;
    objects["Instance20"]["Active"] = false;
    objects["Instance20"]["Parent"] = objects["Instance19"];
    objects["Instance20"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance20"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance20"]["ZIndex"] = 1;
    objects["Instance20"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance20"]["Size"] = UDim2.new(1, 0, 0.10000000149011612, 0);
    objects["Instance20"]["Draggable"] = false;
    objects["Instance20"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance20"]["ClipsDescendants"] = false;
    objects["Instance20"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance20"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance20"]["BackgroundTransparency"] = 1;
    objects["Instance20"]["BorderSizePixel"] = 0;
    objects["Instance20"]["Rotation"] = 0;
    objects["Instance20"]["Transparency"] = 1;
    objects["Instance20"]["Name"] = "TopbarZone";
    objects["Instance20"]["SelectionOrder"] = 0;
    objects["Instance20"]["Visible"] = true;
    objects["Instance20"]["Selectable"] = false;
    objects["Instance20"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance20"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance21"]["Visible"] = true;
    objects["Instance21"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance21"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance21"]["ImageTransparency"] = 0;
    objects["Instance21"]["Parent"] = objects["Instance20"];
    objects["Instance21"]["Position"] = UDim2.new(0.009999999776482582, 0, 0.5, 0);
    objects["Instance21"]["BackgroundTransparency"] = 1;
    objects["Instance21"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance21"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance21"]["Image"] = "rbxassetid://116368608257813";
    objects["Instance21"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance21"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance21"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance21"]["ZIndex"] = 1;
    objects["Instance21"]["BorderSizePixel"] = 0;
    objects["Instance21"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance21"]["Draggable"] = false;
    objects["Instance21"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance21"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance21"]["ClipsDescendants"] = false;
    objects["Instance21"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance21"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance21"]["LayoutOrder"] = 0;
    objects["Instance21"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance21"]["Rotation"] = 0;
    objects["Instance21"]["Transparency"] = 1;
    objects["Instance21"]["Name"] = "Icon";
    objects["Instance21"]["SelectionOrder"] = 0;
    objects["Instance21"]["SliceScale"] = 1;
    objects["Instance21"]["Selectable"] = false;
    objects["Instance21"]["Active"] = false;
    objects["Instance21"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance22"]["AspectRatio"] = 1;
    objects["Instance22"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance22"]["Parent"] = objects["Instance21"];
    objects["Instance22"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance22"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance23"]["Visible"] = true;
    objects["Instance23"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance23"]["Size"] = UDim2.new(1.2000000476837158, 0, 1.2000000476837158, 0);
    objects["Instance23"]["ImageTransparency"] = 0.8849999904632568;
    objects["Instance23"]["Parent"] = objects["Instance21"];
    objects["Instance23"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance23"]["BackgroundTransparency"] = 1;
    objects["Instance23"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance23"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance23"]["Image"] = "rbxassetid://5538771868";
    objects["Instance23"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance23"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance23"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance23"]["ZIndex"] = 1;
    objects["Instance23"]["BorderSizePixel"] = 0;
    objects["Instance23"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance23"]["Draggable"] = false;
    objects["Instance23"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance23"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance23"]["ClipsDescendants"] = false;
    objects["Instance23"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance23"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance23"]["LayoutOrder"] = 0;
    objects["Instance23"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance23"]["Rotation"] = 0;
    objects["Instance23"]["Transparency"] = 1;
    objects["Instance23"]["Name"] = "Glow";
    objects["Instance23"]["SelectionOrder"] = 0;
    objects["Instance23"]["SliceScale"] = 1;
    objects["Instance23"]["Selectable"] = false;
    objects["Instance23"]["Active"] = false;
    objects["Instance23"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance24"]["Visible"] = true;
    objects["Instance24"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance24"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance24"]["Active"] = false;
    objects["Instance24"]["TextStrokeTransparency"] = 1;
    objects["Instance24"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance24"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance24"]["ZIndex"] = 1;
    objects["Instance24"]["BorderSizePixel"] = 0;
    objects["Instance24"]["Draggable"] = false;
    objects["Instance24"]["RichText"] = false;
    objects["Instance24"]["Transparency"] = 1;
    objects["Instance24"]["SelectionOrder"] = 0;
    objects["Instance24"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance24"]["TextScaled"] = true;
    objects["Instance24"]["TextWrap"] = true;
    objects["Instance24"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance24"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance24"]["Parent"] = objects["Instance20"];
    objects["Instance24"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance24"]["TextSize"] = 14;
    objects["Instance24"]["Position"] = UDim2.new(0.07000000029802322, 0, 0.5, 0);
    objects["Instance24"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance24"]["Size"] = UDim2.new(0.9300000071525574, 0, 0.6000000238418579, 0);
    objects["Instance24"]["BackgroundTransparency"] = 1;
    objects["Instance24"]["LineHeight"] = 1;
    objects["Instance24"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance24"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance24"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance24"]["Text"] = "Ketamine";
    objects["Instance24"]["LayoutOrder"] = 0;
    objects["Instance24"]["TextWrapped"] = true;
    objects["Instance24"]["Rotation"] = 0;
    objects["Instance24"]["TextTransparency"] = 0;
    objects["Instance24"]["Name"] = "Title";
    objects["Instance24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance24"]["ClipsDescendants"] = false;
    objects["Instance24"]["MaxVisibleGraphemes"] = -1;
    objects["Instance24"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance24"]["Selectable"] = false;

    objects["Instance25"]["LayoutOrder"] = 0;
    objects["Instance25"]["Active"] = false;
    objects["Instance25"]["Parent"] = objects["Instance20"];
    objects["Instance25"]["AnchorPoint"] = Vector2.new(0.5, 1);
    objects["Instance25"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance25"]["ZIndex"] = 1;
    objects["Instance25"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance25"]["Size"] = UDim2.new(0.9750000238418579, 0, 0, 1);
    objects["Instance25"]["Draggable"] = false;
    objects["Instance25"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance25"]["ClipsDescendants"] = false;
    objects["Instance25"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance25"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance25"]["BackgroundTransparency"] = 0;
    objects["Instance25"]["BorderSizePixel"] = 0;
    objects["Instance25"]["Rotation"] = 0;
    objects["Instance25"]["Transparency"] = 0;
    objects["Instance25"]["Name"] = "Separator";
    objects["Instance25"]["SelectionOrder"] = 0;
    objects["Instance25"]["Visible"] = true;
    objects["Instance25"]["Selectable"] = false;
    objects["Instance25"]["Position"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance25"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance26"]["LayoutOrder"] = 0;
    objects["Instance26"]["Active"] = false;
    objects["Instance26"]["Parent"] = objects["Instance20"];
    objects["Instance26"]["AnchorPoint"] = Vector2.new(1, 0);
    objects["Instance26"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance26"]["ZIndex"] = 1;
    objects["Instance26"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance26"]["Size"] = UDim2.new(0.5, 0, 1, -1);
    objects["Instance26"]["Draggable"] = false;
    objects["Instance26"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance26"]["ClipsDescendants"] = false;
    objects["Instance26"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance26"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance26"]["BackgroundTransparency"] = 1;
    objects["Instance26"]["BorderSizePixel"] = 0;
    objects["Instance26"]["Rotation"] = 0;
    objects["Instance26"]["Transparency"] = 1;
    objects["Instance26"]["Name"] = "Buttons";
    objects["Instance26"]["SelectionOrder"] = 0;
    objects["Instance26"]["Visible"] = true;
    objects["Instance26"]["Selectable"] = false;
    objects["Instance26"]["Position"] = UDim2.new(0.9950000047683716, 0, 0, 0);
    objects["Instance26"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance27"]["Visible"] = true;
    objects["Instance27"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance27"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance27"]["Active"] = true;
    objects["Instance27"]["TextStrokeTransparency"] = 1;
    objects["Instance27"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance27"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance27"]["ZIndex"] = 1;
    objects["Instance27"]["BorderSizePixel"] = 0;
    objects["Instance27"]["Draggable"] = false;
    objects["Instance27"]["RichText"] = false;
    objects["Instance27"]["Modal"] = false;
    objects["Instance27"]["AutoButtonColor"] = false;
    objects["Instance27"]["Transparency"] = 1;
    objects["Instance27"]["SelectionOrder"] = 0;
    objects["Instance27"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance27"]["TextScaled"] = false;
    objects["Instance27"]["TextWrap"] = false;
    objects["Instance27"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance27"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance27"]["Parent"] = objects["Instance26"];
    objects["Instance27"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance27"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance27"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance27"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance27"]["Selected"] = false;
    objects["Instance27"]["TextSize"] = 14;
    objects["Instance27"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance27"]["BackgroundTransparency"] = 1;
    objects["Instance27"]["TextWrapped"] = false;
    objects["Instance27"]["ClipsDescendants"] = false;
    objects["Instance27"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance27"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance27"]["Text"] = "";
    objects["Instance27"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance27"]["LayoutOrder"] = 0;
    objects["Instance27"]["Rotation"] = 0;
    objects["Instance27"]["LineHeight"] = 1;
    objects["Instance27"]["Name"] = "Minimize";
    objects["Instance27"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance27"]["Selectable"] = true;
    objects["Instance27"]["MaxVisibleGraphemes"] = -1;
    objects["Instance27"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance27"]["TextTransparency"] = 0;

    objects["Instance28"]["AspectRatio"] = 1;
    objects["Instance28"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance28"]["Parent"] = objects["Instance27"];
    objects["Instance28"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance28"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance29"]["Visible"] = true;
    objects["Instance29"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance29"]["Size"] = UDim2.new(0.3499999940395355, 0, 0.699999988079071, 0);
    objects["Instance29"]["ImageTransparency"] = 0;
    objects["Instance29"]["Parent"] = objects["Instance27"];
    objects["Instance29"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance29"]["BackgroundTransparency"] = 1;
    objects["Instance29"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance29"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance29"]["Image"] = "rbxassetid://16239957665";
    objects["Instance29"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance29"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance29"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance29"]["ZIndex"] = 1;
    objects["Instance29"]["BorderSizePixel"] = 0;
    objects["Instance29"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance29"]["Draggable"] = false;
    objects["Instance29"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance29"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance29"]["ClipsDescendants"] = false;
    objects["Instance29"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance29"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance29"]["LayoutOrder"] = 0;
    objects["Instance29"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance29"]["Rotation"] = 0;
    objects["Instance29"]["Transparency"] = 1;
    objects["Instance29"]["Name"] = "Icon";
    objects["Instance29"]["SelectionOrder"] = 0;
    objects["Instance29"]["SliceScale"] = 1;
    objects["Instance29"]["Selectable"] = false;
    objects["Instance29"]["Active"] = false;
    objects["Instance29"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance30"]["FillDirection"] = Enum.FillDirection.Horizontal;
    objects["Instance30"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
    objects["Instance30"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance30"]["Parent"] = objects["Instance26"];
    objects["Instance30"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance30"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance30"]["Name"] = "UIListLayout";
    objects["Instance30"]["Padding"] = UDim.new(0, 0);
    objects["Instance30"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance30"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance31"]["Visible"] = true;
    objects["Instance31"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance31"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance31"]["Active"] = true;
    objects["Instance31"]["TextStrokeTransparency"] = 1;
    objects["Instance31"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance31"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance31"]["ZIndex"] = 1;
    objects["Instance31"]["BorderSizePixel"] = 0;
    objects["Instance31"]["Draggable"] = false;
    objects["Instance31"]["RichText"] = false;
    objects["Instance31"]["Modal"] = false;
    objects["Instance31"]["AutoButtonColor"] = false;
    objects["Instance31"]["Transparency"] = 1;
    objects["Instance31"]["SelectionOrder"] = 0;
    objects["Instance31"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance31"]["TextScaled"] = false;
    objects["Instance31"]["TextWrap"] = false;
    objects["Instance31"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance31"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance31"]["Parent"] = objects["Instance26"];
    objects["Instance31"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance31"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance31"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance31"]["BackgroundColor3"] = Color3.new(1, 0, 0);
    objects["Instance31"]["Selected"] = false;
    objects["Instance31"]["TextSize"] = 14;
    objects["Instance31"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance31"]["BackgroundTransparency"] = 1;
    objects["Instance31"]["TextWrapped"] = false;
    objects["Instance31"]["ClipsDescendants"] = false;
    objects["Instance31"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance31"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance31"]["Text"] = "";
    objects["Instance31"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance31"]["LayoutOrder"] = 1;
    objects["Instance31"]["Rotation"] = 0;
    objects["Instance31"]["LineHeight"] = 1;
    objects["Instance31"]["Name"] = "Close";
    objects["Instance31"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance31"]["Selectable"] = true;
    objects["Instance31"]["MaxVisibleGraphemes"] = -1;
    objects["Instance31"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance31"]["TextTransparency"] = 0;

    objects["Instance32"]["AspectRatio"] = 1;
    objects["Instance32"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance32"]["Parent"] = objects["Instance31"];
    objects["Instance32"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance32"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance33"]["Visible"] = true;
    objects["Instance33"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance33"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance33"]["ImageTransparency"] = 0;
    objects["Instance33"]["Parent"] = objects["Instance31"];
    objects["Instance33"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance33"]["BackgroundTransparency"] = 1;
    objects["Instance33"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance33"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance33"]["Image"] = "rbxassetid://10152135063";
    objects["Instance33"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance33"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance33"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance33"]["ZIndex"] = 1;
    objects["Instance33"]["BorderSizePixel"] = 0;
    objects["Instance33"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance33"]["Draggable"] = false;
    objects["Instance33"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance33"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance33"]["ClipsDescendants"] = false;
    objects["Instance33"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance33"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance33"]["LayoutOrder"] = 0;
    objects["Instance33"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance33"]["Rotation"] = 0;
    objects["Instance33"]["Transparency"] = 1;
    objects["Instance33"]["Name"] = "Icon";
    objects["Instance33"]["SelectionOrder"] = 0;
    objects["Instance33"]["SliceScale"] = 1;
    objects["Instance33"]["Selectable"] = false;
    objects["Instance33"]["Active"] = false;
    objects["Instance33"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance34"]["LayoutOrder"] = 0;
    objects["Instance34"]["Active"] = false;
    objects["Instance34"]["Parent"] = objects["Instance19"];
    objects["Instance34"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance34"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance34"]["ZIndex"] = 1;
    objects["Instance34"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance34"]["Size"] = UDim2.new(1, 0, 0.8999999761581421, 0);
    objects["Instance34"]["Draggable"] = false;
    objects["Instance34"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance34"]["ClipsDescendants"] = false;
    objects["Instance34"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance34"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance34"]["BackgroundTransparency"] = 1;
    objects["Instance34"]["BorderSizePixel"] = 0;
    objects["Instance34"]["Rotation"] = 0;
    objects["Instance34"]["Transparency"] = 1;
    objects["Instance34"]["Name"] = "Contents";
    objects["Instance34"]["SelectionOrder"] = 0;
    objects["Instance34"]["Visible"] = true;
    objects["Instance34"]["Selectable"] = false;
    objects["Instance34"]["Position"] = UDim2.new(0, 0, 0.10000000149011612, 0);
    objects["Instance34"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance35"]["LayoutOrder"] = 0;
    objects["Instance35"]["Active"] = false;
    objects["Instance35"]["Parent"] = objects["Instance34"];
    objects["Instance35"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance35"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance35"]["ZIndex"] = 1;
    objects["Instance35"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance35"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.949999988079071, 0);
    objects["Instance35"]["Draggable"] = false;
    objects["Instance35"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance35"]["ClipsDescendants"] = false;
    objects["Instance35"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance35"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance35"]["BackgroundTransparency"] = 1;
    objects["Instance35"]["BorderSizePixel"] = 0;
    objects["Instance35"]["Rotation"] = 0;
    objects["Instance35"]["Transparency"] = 1;
    objects["Instance35"]["Name"] = "Buttons";
    objects["Instance35"]["SelectionOrder"] = 0;
    objects["Instance35"]["Visible"] = true;
    objects["Instance35"]["Selectable"] = false;
    objects["Instance35"]["Position"] = UDim2.new(0, 0, 0.02500000037252903, 0);
    objects["Instance35"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance36"]["LayoutOrder"] = 0;
    objects["Instance36"]["Active"] = false;
    objects["Instance36"]["Parent"] = objects["Instance35"];
    objects["Instance36"]["AnchorPoint"] = Vector2.new(1, 0);
    objects["Instance36"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance36"]["ZIndex"] = 1;
    objects["Instance36"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance36"]["Size"] = UDim2.new(0, 1, 1.024999976158142, 1);
    objects["Instance36"]["Draggable"] = false;
    objects["Instance36"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance36"]["ClipsDescendants"] = false;
    objects["Instance36"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance36"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance36"]["BackgroundTransparency"] = 0;
    objects["Instance36"]["BorderSizePixel"] = 0;
    objects["Instance36"]["Rotation"] = 0;
    objects["Instance36"]["Transparency"] = 0;
    objects["Instance36"]["Name"] = "Separator";
    objects["Instance36"]["SelectionOrder"] = 0;
    objects["Instance36"]["Visible"] = true;
    objects["Instance36"]["Selectable"] = false;
    objects["Instance36"]["Position"] = UDim2.new(1, 0, -0.02500000037252903, -1);
    objects["Instance36"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance37"]["LayoutOrder"] = 0;
    objects["Instance37"]["Active"] = false;
    objects["Instance37"]["Parent"] = objects["Instance35"];
    objects["Instance37"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance37"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance37"]["ZIndex"] = 1;
    objects["Instance37"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance37"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance37"]["Draggable"] = false;
    objects["Instance37"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance37"]["ClipsDescendants"] = true;
    objects["Instance37"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance37"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance37"]["BackgroundTransparency"] = 1;
    objects["Instance37"]["BorderSizePixel"] = 0;
    objects["Instance37"]["Rotation"] = 0;
    objects["Instance37"]["Transparency"] = 1;
    objects["Instance37"]["Name"] = "Holder";
    objects["Instance37"]["SelectionOrder"] = 0;
    objects["Instance37"]["Visible"] = true;
    objects["Instance37"]["Selectable"] = false;
    objects["Instance37"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance37"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance38"]["Visible"] = true;
    objects["Instance38"]["Active"] = true;
    objects["Instance38"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance38"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance38"]["ZIndex"] = 1;
    objects["Instance38"]["BorderSizePixel"] = 0;
    objects["Instance38"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance38"]["Draggable"] = false;
    objects["Instance38"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance38"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance38"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance38"]["Transparency"] = 1;
    objects["Instance38"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance38"]["SelectionOrder"] = 0;
    objects["Instance38"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance38"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance38"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance38"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance38"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance38"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance38"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance38"]["ScrollBarImageColor3"] = Color3.new(0, 0, 0);
    objects["Instance38"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance38"]["Selectable"] = true;
    objects["Instance38"]["ClipsDescendants"] = false;
    objects["Instance38"]["ScrollBarImageTransparency"] = 0;
    objects["Instance38"]["ScrollBarThickness"] = 0;
    objects["Instance38"]["Parent"] = objects["Instance37"];
    objects["Instance38"]["BackgroundTransparency"] = 1;
    objects["Instance38"]["Rotation"] = 0;
    objects["Instance38"]["LayoutOrder"] = 0;
    objects["Instance38"]["Name"] = "List";
    objects["Instance38"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance38"]["ScrollingEnabled"] = true;
    objects["Instance38"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance38"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance38"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance39"]["Visible"] = true;
    objects["Instance39"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance39"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance39"]["Active"] = true;
    objects["Instance39"]["TextStrokeTransparency"] = 1;
    objects["Instance39"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance39"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance39"]["ZIndex"] = 1;
    objects["Instance39"]["BorderSizePixel"] = 0;
    objects["Instance39"]["Draggable"] = false;
    objects["Instance39"]["RichText"] = false;
    objects["Instance39"]["Modal"] = false;
    objects["Instance39"]["AutoButtonColor"] = false;
    objects["Instance39"]["Transparency"] = 1;
    objects["Instance39"]["SelectionOrder"] = 0;
    objects["Instance39"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance39"]["TextScaled"] = false;
    objects["Instance39"]["TextWrap"] = false;
    objects["Instance39"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance39"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance39"]["Parent"] = objects["Instance38"];
    objects["Instance39"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance39"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance39"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance39"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance39"]["Selected"] = false;
    objects["Instance39"]["TextSize"] = 14;
    objects["Instance39"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance39"]["BackgroundTransparency"] = 1;
    objects["Instance39"]["TextWrapped"] = false;
    objects["Instance39"]["ClipsDescendants"] = false;
    objects["Instance39"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance39"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance39"]["Text"] = "";
    objects["Instance39"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance39"]["LayoutOrder"] = 1;
    objects["Instance39"]["Rotation"] = 0;
    objects["Instance39"]["LineHeight"] = 1;
    objects["Instance39"]["Name"] = "Settings";
    objects["Instance39"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance39"]["Selectable"] = true;
    objects["Instance39"]["MaxVisibleGraphemes"] = -1;
    objects["Instance39"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance39"]["TextTransparency"] = 0;

    objects["Instance40"]["LayoutOrder"] = 0;
    objects["Instance40"]["Active"] = false;
    objects["Instance40"]["Parent"] = objects["Instance39"];
    objects["Instance40"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance40"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance40"]["ZIndex"] = 1;
    objects["Instance40"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance40"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance40"]["Draggable"] = false;
    objects["Instance40"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance40"]["ClipsDescendants"] = false;
    objects["Instance40"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance40"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance40"]["BackgroundTransparency"] = 1;
    objects["Instance40"]["BorderSizePixel"] = 0;
    objects["Instance40"]["Rotation"] = 0;
    objects["Instance40"]["Transparency"] = 1;
    objects["Instance40"]["Name"] = "Cut";
    objects["Instance40"]["SelectionOrder"] = 0;
    objects["Instance40"]["Visible"] = true;
    objects["Instance40"]["Selectable"] = false;
    objects["Instance40"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance40"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance41"]["Visible"] = true;
    objects["Instance41"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance41"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance41"]["Active"] = false;
    objects["Instance41"]["TextStrokeTransparency"] = 1;
    objects["Instance41"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance41"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance41"]["ZIndex"] = 1;
    objects["Instance41"]["BorderSizePixel"] = 0;
    objects["Instance41"]["Draggable"] = false;
    objects["Instance41"]["RichText"] = false;
    objects["Instance41"]["Transparency"] = 1;
    objects["Instance41"]["SelectionOrder"] = 0;
    objects["Instance41"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance41"]["TextScaled"] = true;
    objects["Instance41"]["TextWrap"] = true;
    objects["Instance41"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance41"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance41"]["Parent"] = objects["Instance40"];
    objects["Instance41"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance41"]["TextSize"] = 14;
    objects["Instance41"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance41"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance41"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance41"]["BackgroundTransparency"] = 1;
    objects["Instance41"]["LineHeight"] = 1;
    objects["Instance41"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance41"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance41"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance41"]["Text"] = "UI Settings";
    objects["Instance41"]["LayoutOrder"] = 0;
    objects["Instance41"]["TextWrapped"] = true;
    objects["Instance41"]["Rotation"] = 0;
    objects["Instance41"]["TextTransparency"] = 0;
    objects["Instance41"]["Name"] = "Label";
    objects["Instance41"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance41"]["ClipsDescendants"] = false;
    objects["Instance41"]["MaxVisibleGraphemes"] = -1;
    objects["Instance41"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance41"]["Selectable"] = false;

    objects["Instance42"]["Visible"] = true;
    objects["Instance42"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance42"]["Size"] = UDim2.new(0.699999988079071, 0, 0.699999988079071, 0);
    objects["Instance42"]["ImageTransparency"] = 0;
    objects["Instance42"]["Parent"] = objects["Instance40"];
    objects["Instance42"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance42"]["BackgroundTransparency"] = 1;
    objects["Instance42"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance42"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance42"]["Image"] = "rbxassetid://17124529105";
    objects["Instance42"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance42"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance42"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance42"]["ZIndex"] = 1;
    objects["Instance42"]["BorderSizePixel"] = 0;
    objects["Instance42"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance42"]["Draggable"] = false;
    objects["Instance42"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance42"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance42"]["ClipsDescendants"] = false;
    objects["Instance42"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance42"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance42"]["LayoutOrder"] = 0;
    objects["Instance42"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance42"]["Rotation"] = 0;
    objects["Instance42"]["Transparency"] = 1;
    objects["Instance42"]["Name"] = "Icon";
    objects["Instance42"]["SelectionOrder"] = 0;
    objects["Instance42"]["SliceScale"] = 1;
    objects["Instance42"]["Selectable"] = false;
    objects["Instance42"]["Active"] = false;
    objects["Instance42"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance43"]["AspectRatio"] = 1;
    objects["Instance43"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance43"]["Parent"] = objects["Instance42"];
    objects["Instance43"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance43"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance44"]["Visible"] = true;
    objects["Instance44"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance44"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance44"]["Active"] = true;
    objects["Instance44"]["TextStrokeTransparency"] = 1;
    objects["Instance44"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance44"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance44"]["ZIndex"] = 1;
    objects["Instance44"]["BorderSizePixel"] = 0;
    objects["Instance44"]["Draggable"] = false;
    objects["Instance44"]["RichText"] = false;
    objects["Instance44"]["Modal"] = false;
    objects["Instance44"]["AutoButtonColor"] = false;
    objects["Instance44"]["Transparency"] = 0.949999988079071;
    objects["Instance44"]["SelectionOrder"] = 0;
    objects["Instance44"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance44"]["TextScaled"] = false;
    objects["Instance44"]["TextWrap"] = false;
    objects["Instance44"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance44"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance44"]["Parent"] = objects["Instance38"];
    objects["Instance44"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance44"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance44"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance44"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance44"]["Selected"] = false;
    objects["Instance44"]["TextSize"] = 14;
    objects["Instance44"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance44"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance44"]["TextWrapped"] = false;
    objects["Instance44"]["ClipsDescendants"] = false;
    objects["Instance44"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance44"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance44"]["Text"] = "";
    objects["Instance44"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance44"]["LayoutOrder"] = 8;
    objects["Instance44"]["Rotation"] = 0;
    objects["Instance44"]["LineHeight"] = 1;
    objects["Instance44"]["Name"] = "MemoryScanner";
    objects["Instance44"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance44"]["Selectable"] = true;
    objects["Instance44"]["MaxVisibleGraphemes"] = -1;
    objects["Instance44"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance44"]["TextTransparency"] = 0;

    objects["Instance45"]["LayoutOrder"] = 0;
    objects["Instance45"]["Active"] = false;
    objects["Instance45"]["Parent"] = objects["Instance44"];
    objects["Instance45"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance45"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance45"]["ZIndex"] = 1;
    objects["Instance45"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance45"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance45"]["Draggable"] = false;
    objects["Instance45"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance45"]["ClipsDescendants"] = false;
    objects["Instance45"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance45"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance45"]["BackgroundTransparency"] = 1;
    objects["Instance45"]["BorderSizePixel"] = 0;
    objects["Instance45"]["Rotation"] = 0;
    objects["Instance45"]["Transparency"] = 1;
    objects["Instance45"]["Name"] = "Cut";
    objects["Instance45"]["SelectionOrder"] = 0;
    objects["Instance45"]["Visible"] = true;
    objects["Instance45"]["Selectable"] = false;
    objects["Instance45"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance45"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance46"]["Visible"] = true;
    objects["Instance46"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance46"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance46"]["ImageTransparency"] = 0;
    objects["Instance46"]["Parent"] = objects["Instance45"];
    objects["Instance46"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance46"]["BackgroundTransparency"] = 1;
    objects["Instance46"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance46"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance46"]["Image"] = "rbxassetid://93748616033191";
    objects["Instance46"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance46"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance46"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance46"]["ZIndex"] = 1;
    objects["Instance46"]["BorderSizePixel"] = 0;
    objects["Instance46"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance46"]["Draggable"] = false;
    objects["Instance46"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance46"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance46"]["ClipsDescendants"] = false;
    objects["Instance46"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance46"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance46"]["LayoutOrder"] = 0;
    objects["Instance46"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance46"]["Rotation"] = 0;
    objects["Instance46"]["Transparency"] = 1;
    objects["Instance46"]["Name"] = "Icon";
    objects["Instance46"]["SelectionOrder"] = 0;
    objects["Instance46"]["SliceScale"] = 1;
    objects["Instance46"]["Selectable"] = false;
    objects["Instance46"]["Active"] = false;
    objects["Instance46"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance47"]["AspectRatio"] = 1;
    objects["Instance47"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance47"]["Parent"] = objects["Instance46"];
    objects["Instance47"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance47"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance48"]["Visible"] = true;
    objects["Instance48"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance48"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance48"]["Active"] = false;
    objects["Instance48"]["TextStrokeTransparency"] = 1;
    objects["Instance48"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance48"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance48"]["ZIndex"] = 1;
    objects["Instance48"]["BorderSizePixel"] = 0;
    objects["Instance48"]["Draggable"] = false;
    objects["Instance48"]["RichText"] = false;
    objects["Instance48"]["Transparency"] = 1;
    objects["Instance48"]["SelectionOrder"] = 0;
    objects["Instance48"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance48"]["TextScaled"] = true;
    objects["Instance48"]["TextWrap"] = true;
    objects["Instance48"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance48"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance48"]["Parent"] = objects["Instance45"];
    objects["Instance48"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance48"]["TextSize"] = 14;
    objects["Instance48"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance48"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance48"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance48"]["BackgroundTransparency"] = 1;
    objects["Instance48"]["LineHeight"] = 1;
    objects["Instance48"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance48"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance48"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance48"]["Text"] = "Memory scan";
    objects["Instance48"]["LayoutOrder"] = 0;
    objects["Instance48"]["TextWrapped"] = true;
    objects["Instance48"]["Rotation"] = 0;
    objects["Instance48"]["TextTransparency"] = 0;
    objects["Instance48"]["Name"] = "Label";
    objects["Instance48"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance48"]["ClipsDescendants"] = false;
    objects["Instance48"]["MaxVisibleGraphemes"] = -1;
    objects["Instance48"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance48"]["Selectable"] = false;

    objects["Instance49"]["Visible"] = true;
    objects["Instance49"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance49"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance49"]["Active"] = true;
    objects["Instance49"]["TextStrokeTransparency"] = 1;
    objects["Instance49"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance49"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance49"]["ZIndex"] = 1;
    objects["Instance49"]["BorderSizePixel"] = 0;
    objects["Instance49"]["Draggable"] = false;
    objects["Instance49"]["RichText"] = false;
    objects["Instance49"]["Modal"] = false;
    objects["Instance49"]["AutoButtonColor"] = false;
    objects["Instance49"]["Transparency"] = 1;
    objects["Instance49"]["SelectionOrder"] = 0;
    objects["Instance49"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance49"]["TextScaled"] = false;
    objects["Instance49"]["TextWrap"] = false;
    objects["Instance49"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance49"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance49"]["Parent"] = objects["Instance38"];
    objects["Instance49"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance49"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance49"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance49"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance49"]["Selected"] = false;
    objects["Instance49"]["TextSize"] = 14;
    objects["Instance49"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance49"]["BackgroundTransparency"] = 1;
    objects["Instance49"]["TextWrapped"] = false;
    objects["Instance49"]["ClipsDescendants"] = false;
    objects["Instance49"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance49"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance49"]["Text"] = "";
    objects["Instance49"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance49"]["LayoutOrder"] = 7;
    objects["Instance49"]["Rotation"] = 0;
    objects["Instance49"]["LineHeight"] = 1;
    objects["Instance49"]["Name"] = "ScriptScanner";
    objects["Instance49"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance49"]["Selectable"] = true;
    objects["Instance49"]["MaxVisibleGraphemes"] = -1;
    objects["Instance49"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance49"]["TextTransparency"] = 0;

    objects["Instance50"]["LayoutOrder"] = 0;
    objects["Instance50"]["Active"] = false;
    objects["Instance50"]["Parent"] = objects["Instance49"];
    objects["Instance50"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance50"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance50"]["ZIndex"] = 1;
    objects["Instance50"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance50"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance50"]["Draggable"] = false;
    objects["Instance50"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance50"]["ClipsDescendants"] = false;
    objects["Instance50"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance50"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance50"]["BackgroundTransparency"] = 1;
    objects["Instance50"]["BorderSizePixel"] = 0;
    objects["Instance50"]["Rotation"] = 0;
    objects["Instance50"]["Transparency"] = 1;
    objects["Instance50"]["Name"] = "Cut";
    objects["Instance50"]["SelectionOrder"] = 0;
    objects["Instance50"]["Visible"] = true;
    objects["Instance50"]["Selectable"] = false;
    objects["Instance50"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance50"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance51"]["Visible"] = true;
    objects["Instance51"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance51"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.6499999761581421, 0);
    objects["Instance51"]["ImageTransparency"] = 0;
    objects["Instance51"]["Parent"] = objects["Instance50"];
    objects["Instance51"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance51"]["BackgroundTransparency"] = 1;
    objects["Instance51"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance51"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance51"]["Image"] = "rbxassetid://81513493696931";
    objects["Instance51"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance51"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance51"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance51"]["ZIndex"] = 1;
    objects["Instance51"]["BorderSizePixel"] = 0;
    objects["Instance51"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance51"]["Draggable"] = false;
    objects["Instance51"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance51"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance51"]["ClipsDescendants"] = false;
    objects["Instance51"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance51"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance51"]["LayoutOrder"] = 0;
    objects["Instance51"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance51"]["Rotation"] = 0;
    objects["Instance51"]["Transparency"] = 1;
    objects["Instance51"]["Name"] = "Icon";
    objects["Instance51"]["SelectionOrder"] = 0;
    objects["Instance51"]["SliceScale"] = 1;
    objects["Instance51"]["Selectable"] = false;
    objects["Instance51"]["Active"] = false;
    objects["Instance51"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance52"]["AspectRatio"] = 1;
    objects["Instance52"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance52"]["Parent"] = objects["Instance51"];
    objects["Instance52"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance52"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance53"]["Visible"] = true;
    objects["Instance53"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance53"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance53"]["Active"] = false;
    objects["Instance53"]["TextStrokeTransparency"] = 1;
    objects["Instance53"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance53"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance53"]["ZIndex"] = 1;
    objects["Instance53"]["BorderSizePixel"] = 0;
    objects["Instance53"]["Draggable"] = false;
    objects["Instance53"]["RichText"] = false;
    objects["Instance53"]["Transparency"] = 1;
    objects["Instance53"]["SelectionOrder"] = 0;
    objects["Instance53"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance53"]["TextScaled"] = true;
    objects["Instance53"]["TextWrap"] = true;
    objects["Instance53"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance53"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance53"]["Parent"] = objects["Instance50"];
    objects["Instance53"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance53"]["TextSize"] = 14;
    objects["Instance53"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance53"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance53"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance53"]["BackgroundTransparency"] = 1;
    objects["Instance53"]["LineHeight"] = 1;
    objects["Instance53"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance53"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance53"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance53"]["Text"] = "Script scan";
    objects["Instance53"]["LayoutOrder"] = 0;
    objects["Instance53"]["TextWrapped"] = true;
    objects["Instance53"]["Rotation"] = 0;
    objects["Instance53"]["TextTransparency"] = 0;
    objects["Instance53"]["Name"] = "Label";
    objects["Instance53"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance53"]["ClipsDescendants"] = false;
    objects["Instance53"]["MaxVisibleGraphemes"] = -1;
    objects["Instance53"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance53"]["Selectable"] = false;

    objects["Instance54"]["Visible"] = true;
    objects["Instance54"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance54"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance54"]["Active"] = true;
    objects["Instance54"]["TextStrokeTransparency"] = 1;
    objects["Instance54"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance54"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance54"]["ZIndex"] = 1;
    objects["Instance54"]["BorderSizePixel"] = 0;
    objects["Instance54"]["Draggable"] = false;
    objects["Instance54"]["RichText"] = false;
    objects["Instance54"]["Modal"] = false;
    objects["Instance54"]["AutoButtonColor"] = false;
    objects["Instance54"]["Transparency"] = 1;
    objects["Instance54"]["SelectionOrder"] = 0;
    objects["Instance54"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance54"]["TextScaled"] = false;
    objects["Instance54"]["TextWrap"] = false;
    objects["Instance54"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance54"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance54"]["Parent"] = objects["Instance38"];
    objects["Instance54"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance54"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance54"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance54"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance54"]["Selected"] = false;
    objects["Instance54"]["TextSize"] = 14;
    objects["Instance54"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance54"]["BackgroundTransparency"] = 1;
    objects["Instance54"]["TextWrapped"] = false;
    objects["Instance54"]["ClipsDescendants"] = false;
    objects["Instance54"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance54"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance54"]["Text"] = "";
    objects["Instance54"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance54"]["LayoutOrder"] = 3;
    objects["Instance54"]["Rotation"] = 0;
    objects["Instance54"]["LineHeight"] = 1;
    objects["Instance54"]["Name"] = "RSpy";
    objects["Instance54"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance54"]["Selectable"] = true;
    objects["Instance54"]["MaxVisibleGraphemes"] = -1;
    objects["Instance54"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance54"]["TextTransparency"] = 0;

    objects["Instance55"]["LayoutOrder"] = 0;
    objects["Instance55"]["Active"] = false;
    objects["Instance55"]["Parent"] = objects["Instance54"];
    objects["Instance55"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance55"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance55"]["ZIndex"] = 1;
    objects["Instance55"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance55"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance55"]["Draggable"] = false;
    objects["Instance55"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance55"]["ClipsDescendants"] = false;
    objects["Instance55"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance55"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance55"]["BackgroundTransparency"] = 1;
    objects["Instance55"]["BorderSizePixel"] = 0;
    objects["Instance55"]["Rotation"] = 0;
    objects["Instance55"]["Transparency"] = 1;
    objects["Instance55"]["Name"] = "Cut";
    objects["Instance55"]["SelectionOrder"] = 0;
    objects["Instance55"]["Visible"] = true;
    objects["Instance55"]["Selectable"] = false;
    objects["Instance55"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance55"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance56"]["Visible"] = true;
    objects["Instance56"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance56"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance56"]["Active"] = false;
    objects["Instance56"]["TextStrokeTransparency"] = 1;
    objects["Instance56"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance56"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance56"]["ZIndex"] = 1;
    objects["Instance56"]["BorderSizePixel"] = 0;
    objects["Instance56"]["Draggable"] = false;
    objects["Instance56"]["RichText"] = false;
    objects["Instance56"]["Transparency"] = 1;
    objects["Instance56"]["SelectionOrder"] = 0;
    objects["Instance56"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance56"]["TextScaled"] = true;
    objects["Instance56"]["TextWrap"] = true;
    objects["Instance56"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance56"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance56"]["Parent"] = objects["Instance55"];
    objects["Instance56"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance56"]["TextSize"] = 14;
    objects["Instance56"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance56"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance56"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance56"]["BackgroundTransparency"] = 1;
    objects["Instance56"]["LineHeight"] = 1;
    objects["Instance56"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance56"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance56"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance56"]["Text"] = "Remotes";
    objects["Instance56"]["LayoutOrder"] = 0;
    objects["Instance56"]["TextWrapped"] = true;
    objects["Instance56"]["Rotation"] = 0;
    objects["Instance56"]["TextTransparency"] = 0;
    objects["Instance56"]["Name"] = "Label";
    objects["Instance56"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance56"]["ClipsDescendants"] = false;
    objects["Instance56"]["MaxVisibleGraphemes"] = -1;
    objects["Instance56"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance56"]["Selectable"] = false;

    objects["Instance57"]["Visible"] = true;
    objects["Instance57"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance57"]["Size"] = UDim2.new(0.699999988079071, 0, 0.699999988079071, 0);
    objects["Instance57"]["ImageTransparency"] = 0;
    objects["Instance57"]["Parent"] = objects["Instance55"];
    objects["Instance57"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance57"]["BackgroundTransparency"] = 1;
    objects["Instance57"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance57"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance57"]["Image"] = "rbxassetid://9940330919";
    objects["Instance57"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance57"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance57"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance57"]["ZIndex"] = 1;
    objects["Instance57"]["BorderSizePixel"] = 0;
    objects["Instance57"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance57"]["Draggable"] = false;
    objects["Instance57"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance57"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance57"]["ClipsDescendants"] = false;
    objects["Instance57"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance57"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance57"]["LayoutOrder"] = 0;
    objects["Instance57"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance57"]["Rotation"] = 0;
    objects["Instance57"]["Transparency"] = 1;
    objects["Instance57"]["Name"] = "Icon";
    objects["Instance57"]["SelectionOrder"] = 0;
    objects["Instance57"]["SliceScale"] = 1;
    objects["Instance57"]["Selectable"] = false;
    objects["Instance57"]["Active"] = false;
    objects["Instance57"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance58"]["AspectRatio"] = 1;
    objects["Instance58"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance58"]["Parent"] = objects["Instance57"];
    objects["Instance58"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance58"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance59"]["Visible"] = true;
    objects["Instance59"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance59"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance59"]["Active"] = true;
    objects["Instance59"]["TextStrokeTransparency"] = 1;
    objects["Instance59"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance59"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance59"]["ZIndex"] = 1;
    objects["Instance59"]["BorderSizePixel"] = 0;
    objects["Instance59"]["Draggable"] = false;
    objects["Instance59"]["RichText"] = false;
    objects["Instance59"]["Modal"] = false;
    objects["Instance59"]["AutoButtonColor"] = false;
    objects["Instance59"]["Transparency"] = 1;
    objects["Instance59"]["SelectionOrder"] = 0;
    objects["Instance59"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance59"]["TextScaled"] = false;
    objects["Instance59"]["TextWrap"] = false;
    objects["Instance59"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance59"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance59"]["Parent"] = objects["Instance38"];
    objects["Instance59"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance59"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance59"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance59"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance59"]["Selected"] = false;
    objects["Instance59"]["TextSize"] = 14;
    objects["Instance59"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance59"]["BackgroundTransparency"] = 1;
    objects["Instance59"]["TextWrapped"] = false;
    objects["Instance59"]["ClipsDescendants"] = false;
    objects["Instance59"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance59"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance59"]["Text"] = "";
    objects["Instance59"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance59"]["LayoutOrder"] = 0;
    objects["Instance59"]["Rotation"] = 0;
    objects["Instance59"]["LineHeight"] = 1;
    objects["Instance59"]["Name"] = "Home";
    objects["Instance59"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance59"]["Selectable"] = true;
    objects["Instance59"]["MaxVisibleGraphemes"] = -1;
    objects["Instance59"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance59"]["TextTransparency"] = 0;

    objects["Instance60"]["LayoutOrder"] = 0;
    objects["Instance60"]["Active"] = false;
    objects["Instance60"]["Parent"] = objects["Instance59"];
    objects["Instance60"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance60"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance60"]["ZIndex"] = 1;
    objects["Instance60"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance60"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance60"]["Draggable"] = false;
    objects["Instance60"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance60"]["ClipsDescendants"] = false;
    objects["Instance60"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance60"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance60"]["BackgroundTransparency"] = 1;
    objects["Instance60"]["BorderSizePixel"] = 0;
    objects["Instance60"]["Rotation"] = 0;
    objects["Instance60"]["Transparency"] = 1;
    objects["Instance60"]["Name"] = "Cut";
    objects["Instance60"]["SelectionOrder"] = 0;
    objects["Instance60"]["Visible"] = true;
    objects["Instance60"]["Selectable"] = false;
    objects["Instance60"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance60"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance61"]["Visible"] = true;
    objects["Instance61"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance61"]["Size"] = UDim2.new(0.6000000238418579, 0, 0.6000000238418579, 0);
    objects["Instance61"]["ImageTransparency"] = 0;
    objects["Instance61"]["Parent"] = objects["Instance60"];
    objects["Instance61"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance61"]["BackgroundTransparency"] = 1;
    objects["Instance61"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance61"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance61"]["Image"] = "rbxassetid://9920484374";
    objects["Instance61"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance61"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance61"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance61"]["ZIndex"] = 1;
    objects["Instance61"]["BorderSizePixel"] = 0;
    objects["Instance61"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance61"]["Draggable"] = false;
    objects["Instance61"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance61"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance61"]["ClipsDescendants"] = false;
    objects["Instance61"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance61"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance61"]["LayoutOrder"] = 0;
    objects["Instance61"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance61"]["Rotation"] = 0;
    objects["Instance61"]["Transparency"] = 1;
    objects["Instance61"]["Name"] = "Icon";
    objects["Instance61"]["SelectionOrder"] = 0;
    objects["Instance61"]["SliceScale"] = 1;
    objects["Instance61"]["Selectable"] = false;
    objects["Instance61"]["Active"] = false;
    objects["Instance61"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance62"]["AspectRatio"] = 1;
    objects["Instance62"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance62"]["Parent"] = objects["Instance61"];
    objects["Instance62"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance62"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance63"]["Visible"] = true;
    objects["Instance63"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance63"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance63"]["Active"] = false;
    objects["Instance63"]["TextStrokeTransparency"] = 1;
    objects["Instance63"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance63"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance63"]["ZIndex"] = 1;
    objects["Instance63"]["BorderSizePixel"] = 0;
    objects["Instance63"]["Draggable"] = false;
    objects["Instance63"]["RichText"] = false;
    objects["Instance63"]["Transparency"] = 1;
    objects["Instance63"]["SelectionOrder"] = 0;
    objects["Instance63"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance63"]["TextScaled"] = true;
    objects["Instance63"]["TextWrap"] = true;
    objects["Instance63"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance63"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance63"]["Parent"] = objects["Instance60"];
    objects["Instance63"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance63"]["TextSize"] = 14;
    objects["Instance63"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance63"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance63"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance63"]["BackgroundTransparency"] = 1;
    objects["Instance63"]["LineHeight"] = 1;
    objects["Instance63"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance63"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance63"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance63"]["Text"] = "Home";
    objects["Instance63"]["LayoutOrder"] = 0;
    objects["Instance63"]["TextWrapped"] = true;
    objects["Instance63"]["Rotation"] = 0;
    objects["Instance63"]["TextTransparency"] = 0;
    objects["Instance63"]["Name"] = "Label";
    objects["Instance63"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance63"]["ClipsDescendants"] = false;
    objects["Instance63"]["MaxVisibleGraphemes"] = -1;
    objects["Instance63"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance63"]["Selectable"] = false;

    objects["Instance64"]["Visible"] = true;
    objects["Instance64"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance64"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance64"]["Active"] = true;
    objects["Instance64"]["TextStrokeTransparency"] = 1;
    objects["Instance64"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance64"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance64"]["ZIndex"] = 1;
    objects["Instance64"]["BorderSizePixel"] = 0;
    objects["Instance64"]["Draggable"] = false;
    objects["Instance64"]["RichText"] = false;
    objects["Instance64"]["Modal"] = false;
    objects["Instance64"]["AutoButtonColor"] = false;
    objects["Instance64"]["Transparency"] = 1;
    objects["Instance64"]["SelectionOrder"] = 0;
    objects["Instance64"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance64"]["TextScaled"] = false;
    objects["Instance64"]["TextWrap"] = false;
    objects["Instance64"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance64"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance64"]["Parent"] = objects["Instance38"];
    objects["Instance64"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance64"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance64"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance64"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance64"]["Selected"] = false;
    objects["Instance64"]["TextSize"] = 14;
    objects["Instance64"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance64"]["BackgroundTransparency"] = 1;
    objects["Instance64"]["TextWrapped"] = false;
    objects["Instance64"]["ClipsDescendants"] = false;
    objects["Instance64"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance64"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance64"]["Text"] = "";
    objects["Instance64"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance64"]["LayoutOrder"] = 5;
    objects["Instance64"]["Rotation"] = 0;
    objects["Instance64"]["LineHeight"] = 1;
    objects["Instance64"]["Name"] = "HTTPSpy";
    objects["Instance64"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance64"]["Selectable"] = true;
    objects["Instance64"]["MaxVisibleGraphemes"] = -1;
    objects["Instance64"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance64"]["TextTransparency"] = 0;

    objects["Instance65"]["LayoutOrder"] = 0;
    objects["Instance65"]["Active"] = false;
    objects["Instance65"]["Parent"] = objects["Instance64"];
    objects["Instance65"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance65"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance65"]["ZIndex"] = 1;
    objects["Instance65"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance65"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance65"]["Draggable"] = false;
    objects["Instance65"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance65"]["ClipsDescendants"] = false;
    objects["Instance65"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance65"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance65"]["BackgroundTransparency"] = 1;
    objects["Instance65"]["BorderSizePixel"] = 0;
    objects["Instance65"]["Rotation"] = 0;
    objects["Instance65"]["Transparency"] = 1;
    objects["Instance65"]["Name"] = "Cut";
    objects["Instance65"]["SelectionOrder"] = 0;
    objects["Instance65"]["Visible"] = true;
    objects["Instance65"]["Selectable"] = false;
    objects["Instance65"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance65"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance66"]["Visible"] = true;
    objects["Instance66"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance66"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.6499999761581421, 0);
    objects["Instance66"]["ImageTransparency"] = 0;
    objects["Instance66"]["Parent"] = objects["Instance65"];
    objects["Instance66"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance66"]["BackgroundTransparency"] = 1;
    objects["Instance66"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance66"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance66"]["Image"] = "rbxassetid://9940320365";
    objects["Instance66"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance66"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance66"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance66"]["ZIndex"] = 1;
    objects["Instance66"]["BorderSizePixel"] = 0;
    objects["Instance66"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance66"]["Draggable"] = false;
    objects["Instance66"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance66"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance66"]["ClipsDescendants"] = false;
    objects["Instance66"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance66"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance66"]["LayoutOrder"] = 0;
    objects["Instance66"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance66"]["Rotation"] = 0;
    objects["Instance66"]["Transparency"] = 1;
    objects["Instance66"]["Name"] = "Icon";
    objects["Instance66"]["SelectionOrder"] = 0;
    objects["Instance66"]["SliceScale"] = 1;
    objects["Instance66"]["Selectable"] = false;
    objects["Instance66"]["Active"] = false;
    objects["Instance66"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance67"]["AspectRatio"] = 1;
    objects["Instance67"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance67"]["Parent"] = objects["Instance66"];
    objects["Instance67"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance67"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance68"]["Visible"] = true;
    objects["Instance68"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance68"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance68"]["Active"] = false;
    objects["Instance68"]["TextStrokeTransparency"] = 1;
    objects["Instance68"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance68"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance68"]["ZIndex"] = 1;
    objects["Instance68"]["BorderSizePixel"] = 0;
    objects["Instance68"]["Draggable"] = false;
    objects["Instance68"]["RichText"] = false;
    objects["Instance68"]["Transparency"] = 1;
    objects["Instance68"]["SelectionOrder"] = 0;
    objects["Instance68"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance68"]["TextScaled"] = true;
    objects["Instance68"]["TextWrap"] = true;
    objects["Instance68"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance68"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance68"]["Parent"] = objects["Instance65"];
    objects["Instance68"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance68"]["TextSize"] = 14;
    objects["Instance68"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance68"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance68"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance68"]["BackgroundTransparency"] = 1;
    objects["Instance68"]["LineHeight"] = 1;
    objects["Instance68"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance68"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance68"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance68"]["Text"] = "HTTP reqs";
    objects["Instance68"]["LayoutOrder"] = 0;
    objects["Instance68"]["TextWrapped"] = true;
    objects["Instance68"]["Rotation"] = 0;
    objects["Instance68"]["TextTransparency"] = 0;
    objects["Instance68"]["Name"] = "Label";
    objects["Instance68"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance68"]["ClipsDescendants"] = false;
    objects["Instance68"]["MaxVisibleGraphemes"] = -1;
    objects["Instance68"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance68"]["Selectable"] = false;

    objects["Instance69"]["Visible"] = true;
    objects["Instance69"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance69"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance69"]["Active"] = true;
    objects["Instance69"]["TextStrokeTransparency"] = 1;
    objects["Instance69"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance69"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance69"]["ZIndex"] = 1;
    objects["Instance69"]["BorderSizePixel"] = 0;
    objects["Instance69"]["Draggable"] = false;
    objects["Instance69"]["RichText"] = false;
    objects["Instance69"]["Modal"] = false;
    objects["Instance69"]["AutoButtonColor"] = false;
    objects["Instance69"]["Transparency"] = 1;
    objects["Instance69"]["SelectionOrder"] = 0;
    objects["Instance69"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance69"]["TextScaled"] = false;
    objects["Instance69"]["TextWrap"] = false;
    objects["Instance69"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance69"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance69"]["Parent"] = objects["Instance38"];
    objects["Instance69"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance69"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance69"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance69"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance69"]["Selected"] = false;
    objects["Instance69"]["TextSize"] = 14;
    objects["Instance69"]["Size"] = UDim2.new(2, 0, 0.12999999523162842, 0);
    objects["Instance69"]["BackgroundTransparency"] = 1;
    objects["Instance69"]["TextWrapped"] = false;
    objects["Instance69"]["ClipsDescendants"] = false;
    objects["Instance69"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance69"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance69"]["Text"] = "";
    objects["Instance69"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance69"]["LayoutOrder"] = 4;
    objects["Instance69"]["Rotation"] = 0;
    objects["Instance69"]["LineHeight"] = 1;
    objects["Instance69"]["Name"] = "ESpy";
    objects["Instance69"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance69"]["Selectable"] = true;
    objects["Instance69"]["MaxVisibleGraphemes"] = -1;
    objects["Instance69"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance69"]["TextTransparency"] = 0;

    objects["Instance70"]["LayoutOrder"] = 0;
    objects["Instance70"]["Active"] = false;
    objects["Instance70"]["Parent"] = objects["Instance69"];
    objects["Instance70"]["AnchorPoint"] = Vector2.new(0.5, 0);
    objects["Instance70"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance70"]["ZIndex"] = 1;
    objects["Instance70"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance70"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance70"]["Draggable"] = false;
    objects["Instance70"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance70"]["ClipsDescendants"] = false;
    objects["Instance70"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance70"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance70"]["BackgroundTransparency"] = 1;
    objects["Instance70"]["BorderSizePixel"] = 0;
    objects["Instance70"]["Rotation"] = 0;
    objects["Instance70"]["Transparency"] = 1;
    objects["Instance70"]["Name"] = "Cut";
    objects["Instance70"]["SelectionOrder"] = 0;
    objects["Instance70"]["Visible"] = true;
    objects["Instance70"]["Selectable"] = false;
    objects["Instance70"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance70"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance71"]["Visible"] = true;
    objects["Instance71"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance71"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance71"]["Active"] = false;
    objects["Instance71"]["TextStrokeTransparency"] = 1;
    objects["Instance71"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance71"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance71"]["ZIndex"] = 1;
    objects["Instance71"]["BorderSizePixel"] = 0;
    objects["Instance71"]["Draggable"] = false;
    objects["Instance71"]["RichText"] = false;
    objects["Instance71"]["Transparency"] = 1;
    objects["Instance71"]["SelectionOrder"] = 0;
    objects["Instance71"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance71"]["TextScaled"] = true;
    objects["Instance71"]["TextWrap"] = true;
    objects["Instance71"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance71"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance71"]["Parent"] = objects["Instance70"];
    objects["Instance71"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance71"]["TextSize"] = 14;
    objects["Instance71"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.5, 0);
    objects["Instance71"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance71"]["Size"] = UDim2.new(0.6499999761581421, 0, 0.4000000059604645, 0);
    objects["Instance71"]["BackgroundTransparency"] = 1;
    objects["Instance71"]["LineHeight"] = 1;
    objects["Instance71"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance71"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance71"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance71"]["Text"] = "Events";
    objects["Instance71"]["LayoutOrder"] = 0;
    objects["Instance71"]["TextWrapped"] = true;
    objects["Instance71"]["Rotation"] = 0;
    objects["Instance71"]["TextTransparency"] = 0;
    objects["Instance71"]["Name"] = "Label";
    objects["Instance71"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance71"]["ClipsDescendants"] = false;
    objects["Instance71"]["MaxVisibleGraphemes"] = -1;
    objects["Instance71"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance71"]["Selectable"] = false;

    objects["Instance72"]["Visible"] = true;
    objects["Instance72"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance72"]["Size"] = UDim2.new(0.6000000238418579, 0, 0.6000000238418579, 0);
    objects["Instance72"]["ImageTransparency"] = 0;
    objects["Instance72"]["Parent"] = objects["Instance70"];
    objects["Instance72"]["Position"] = UDim2.new(0.17499999701976776, 0, 0.5, 0);
    objects["Instance72"]["BackgroundTransparency"] = 1;
    objects["Instance72"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance72"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance72"]["Image"] = "rbxassetid://11448533494";
    objects["Instance72"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance72"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance72"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance72"]["ZIndex"] = 1;
    objects["Instance72"]["BorderSizePixel"] = 0;
    objects["Instance72"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance72"]["Draggable"] = false;
    objects["Instance72"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance72"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance72"]["ClipsDescendants"] = false;
    objects["Instance72"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance72"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance72"]["LayoutOrder"] = 0;
    objects["Instance72"]["ImageColor3"] = Color3.new(0.921569, 0.921569, 0.921569);
    objects["Instance72"]["Rotation"] = 0;
    objects["Instance72"]["Transparency"] = 1;
    objects["Instance72"]["Name"] = "Icon";
    objects["Instance72"]["SelectionOrder"] = 0;
    objects["Instance72"]["SliceScale"] = 1;
    objects["Instance72"]["Selectable"] = false;
    objects["Instance72"]["Active"] = false;
    objects["Instance72"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance73"]["AspectRatio"] = 1;
    objects["Instance73"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance73"]["Parent"] = objects["Instance72"];
    objects["Instance73"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance73"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance74"]["LayoutOrder"] = 6;
    objects["Instance74"]["Active"] = false;
    objects["Instance74"]["Parent"] = objects["Instance38"];
    objects["Instance74"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance74"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance74"]["ZIndex"] = 1;
    objects["Instance74"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance74"]["Size"] = UDim2.new(1, 0, 0.07500000298023224, 0);
    objects["Instance74"]["Draggable"] = false;
    objects["Instance74"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance74"]["ClipsDescendants"] = false;
    objects["Instance74"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance74"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance74"]["BackgroundTransparency"] = 1;
    objects["Instance74"]["BorderSizePixel"] = 0;
    objects["Instance74"]["Rotation"] = 0;
    objects["Instance74"]["Transparency"] = 1;
    objects["Instance74"]["Name"] = "Separator";
    objects["Instance74"]["SelectionOrder"] = 0;
    objects["Instance74"]["Visible"] = true;
    objects["Instance74"]["Selectable"] = false;
    objects["Instance74"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance74"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance75"]["Visible"] = true;
    objects["Instance75"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance75"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance75"]["Active"] = false;
    objects["Instance75"]["TextStrokeTransparency"] = 1;
    objects["Instance75"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance75"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance75"]["ZIndex"] = 2;
    objects["Instance75"]["BorderSizePixel"] = 0;
    objects["Instance75"]["Draggable"] = false;
    objects["Instance75"]["RichText"] = false;
    objects["Instance75"]["Transparency"] = 1;
    objects["Instance75"]["SelectionOrder"] = 0;
    objects["Instance75"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance75"]["TextScaled"] = true;
    objects["Instance75"]["TextWrap"] = true;
    objects["Instance75"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance75"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance75"]["Parent"] = objects["Instance74"];
    objects["Instance75"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance75"]["TextSize"] = 14;
    objects["Instance75"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance75"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance75"]["Size"] = UDim2.new(0.44999998807907104, 0, 0.75, 0);
    objects["Instance75"]["BackgroundTransparency"] = 1;
    objects["Instance75"]["LineHeight"] = 1;
    objects["Instance75"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance75"]["TextColor3"] = Color3.new(0.588235, 0.588235, 0.588235);
    objects["Instance75"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance75"]["Text"] = "Scanners";
    objects["Instance75"]["LayoutOrder"] = 0;
    objects["Instance75"]["TextWrapped"] = true;
    objects["Instance75"]["Rotation"] = 0;
    objects["Instance75"]["TextTransparency"] = 0;
    objects["Instance75"]["Name"] = "Label";
    objects["Instance75"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance75"]["ClipsDescendants"] = false;
    objects["Instance75"]["MaxVisibleGraphemes"] = -1;
    objects["Instance75"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance75"]["Selectable"] = false;

    objects["Instance76"]["LayoutOrder"] = 0;
    objects["Instance76"]["Active"] = false;
    objects["Instance76"]["Parent"] = objects["Instance74"];
    objects["Instance76"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance76"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance76"]["ZIndex"] = 1;
    objects["Instance76"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance76"]["Size"] = UDim2.new(0.17000000178813934, 0, 0, 1);
    objects["Instance76"]["Draggable"] = false;
    objects["Instance76"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance76"]["ClipsDescendants"] = false;
    objects["Instance76"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance76"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance76"]["BackgroundTransparency"] = 0;
    objects["Instance76"]["BorderSizePixel"] = 0;
    objects["Instance76"]["Rotation"] = 0;
    objects["Instance76"]["Transparency"] = 0;
    objects["Instance76"]["Name"] = "SeparatorLeft";
    objects["Instance76"]["SelectionOrder"] = 0;
    objects["Instance76"]["Visible"] = true;
    objects["Instance76"]["Selectable"] = false;
    objects["Instance76"]["Position"] = UDim2.new(0.05999975651502609, 0, 0.5000004768371582, 0);
    objects["Instance76"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance77"]["LayoutOrder"] = 0;
    objects["Instance77"]["Active"] = false;
    objects["Instance77"]["Parent"] = objects["Instance74"];
    objects["Instance77"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance77"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance77"]["ZIndex"] = 1;
    objects["Instance77"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance77"]["Size"] = UDim2.new(0.23000000417232513, 0, 0, 1);
    objects["Instance77"]["Draggable"] = false;
    objects["Instance77"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance77"]["ClipsDescendants"] = false;
    objects["Instance77"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance77"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance77"]["BackgroundTransparency"] = 0;
    objects["Instance77"]["BorderSizePixel"] = 0;
    objects["Instance77"]["Rotation"] = 0;
    objects["Instance77"]["Transparency"] = 0;
    objects["Instance77"]["Name"] = "SeparatorRight";
    objects["Instance77"]["SelectionOrder"] = 0;
    objects["Instance77"]["Visible"] = true;
    objects["Instance77"]["Selectable"] = false;
    objects["Instance77"]["Position"] = UDim2.new(1, 0, 0.5, 0);
    objects["Instance77"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance78"]["LayoutOrder"] = 2;
    objects["Instance78"]["Active"] = false;
    objects["Instance78"]["Parent"] = objects["Instance38"];
    objects["Instance78"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance78"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance78"]["ZIndex"] = 1;
    objects["Instance78"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance78"]["Size"] = UDim2.new(1, 0, 0.07500000298023224, 0);
    objects["Instance78"]["Draggable"] = false;
    objects["Instance78"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance78"]["ClipsDescendants"] = false;
    objects["Instance78"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance78"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance78"]["BackgroundTransparency"] = 1;
    objects["Instance78"]["BorderSizePixel"] = 0;
    objects["Instance78"]["Rotation"] = 0;
    objects["Instance78"]["Transparency"] = 1;
    objects["Instance78"]["Name"] = "Separator";
    objects["Instance78"]["SelectionOrder"] = 0;
    objects["Instance78"]["Visible"] = true;
    objects["Instance78"]["Selectable"] = false;
    objects["Instance78"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance78"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance79"]["Visible"] = true;
    objects["Instance79"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance79"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance79"]["Active"] = false;
    objects["Instance79"]["TextStrokeTransparency"] = 1;
    objects["Instance79"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance79"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance79"]["ZIndex"] = 2;
    objects["Instance79"]["BorderSizePixel"] = 0;
    objects["Instance79"]["Draggable"] = false;
    objects["Instance79"]["RichText"] = false;
    objects["Instance79"]["Transparency"] = 1;
    objects["Instance79"]["SelectionOrder"] = 0;
    objects["Instance79"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance79"]["TextScaled"] = true;
    objects["Instance79"]["TextWrap"] = true;
    objects["Instance79"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance79"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance79"]["Parent"] = objects["Instance78"];
    objects["Instance79"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance79"]["TextSize"] = 14;
    objects["Instance79"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance79"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance79"]["Size"] = UDim2.new(0.30000001192092896, 0, 0.75, 0);
    objects["Instance79"]["BackgroundTransparency"] = 1;
    objects["Instance79"]["LineHeight"] = 1;
    objects["Instance79"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance79"]["TextColor3"] = Color3.new(0.588235, 0.588235, 0.588235);
    objects["Instance79"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance79"]["Text"] = "Spy";
    objects["Instance79"]["LayoutOrder"] = 0;
    objects["Instance79"]["TextWrapped"] = true;
    objects["Instance79"]["Rotation"] = 0;
    objects["Instance79"]["TextTransparency"] = 0;
    objects["Instance79"]["Name"] = "Label";
    objects["Instance79"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance79"]["ClipsDescendants"] = false;
    objects["Instance79"]["MaxVisibleGraphemes"] = -1;
    objects["Instance79"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance79"]["Selectable"] = false;

    objects["Instance80"]["LayoutOrder"] = 0;
    objects["Instance80"]["Active"] = false;
    objects["Instance80"]["Parent"] = objects["Instance78"];
    objects["Instance80"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance80"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance80"]["ZIndex"] = 1;
    objects["Instance80"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance80"]["Size"] = UDim2.new(0.2800000011920929, 0, 0, 1);
    objects["Instance80"]["Draggable"] = false;
    objects["Instance80"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance80"]["ClipsDescendants"] = false;
    objects["Instance80"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance80"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance80"]["BackgroundTransparency"] = 0;
    objects["Instance80"]["BorderSizePixel"] = 0;
    objects["Instance80"]["Rotation"] = 0;
    objects["Instance80"]["Transparency"] = 0;
    objects["Instance80"]["Name"] = "SeparatorLeft";
    objects["Instance80"]["SelectionOrder"] = 0;
    objects["Instance80"]["Visible"] = true;
    objects["Instance80"]["Selectable"] = false;
    objects["Instance80"]["Position"] = UDim2.new(0.05999975651502609, 0, 0.5000004768371582, 0);
    objects["Instance80"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance81"]["LayoutOrder"] = 0;
    objects["Instance81"]["Active"] = false;
    objects["Instance81"]["Parent"] = objects["Instance78"];
    objects["Instance81"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance81"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance81"]["ZIndex"] = 1;
    objects["Instance81"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance81"]["Size"] = UDim2.new(0.3499999940395355, 0, 0, 1);
    objects["Instance81"]["Draggable"] = false;
    objects["Instance81"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance81"]["ClipsDescendants"] = false;
    objects["Instance81"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance81"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance81"]["BackgroundTransparency"] = 0;
    objects["Instance81"]["BorderSizePixel"] = 0;
    objects["Instance81"]["Rotation"] = 0;
    objects["Instance81"]["Transparency"] = 0;
    objects["Instance81"]["Name"] = "SeparatorRight";
    objects["Instance81"]["SelectionOrder"] = 0;
    objects["Instance81"]["Visible"] = true;
    objects["Instance81"]["Selectable"] = false;
    objects["Instance81"]["Position"] = UDim2.new(1, 0, 0.5, 0);
    objects["Instance81"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance82"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance82"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
    objects["Instance82"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance82"]["Parent"] = objects["Instance38"];
    objects["Instance82"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance82"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance82"]["Name"] = "UIListLayout";
    objects["Instance82"]["Padding"] = UDim.new(0, 0);
    objects["Instance82"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance82"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance83"]["LayoutOrder"] = 0;
    objects["Instance83"]["Active"] = false;
    objects["Instance83"]["Parent"] = objects["Instance34"];
    objects["Instance83"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance83"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance83"]["ZIndex"] = 1;
    objects["Instance83"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance83"]["Size"] = UDim2.new(0.800000011920929, 0, 1, 0);
    objects["Instance83"]["Draggable"] = false;
    objects["Instance83"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance83"]["ClipsDescendants"] = false;
    objects["Instance83"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance83"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance83"]["BackgroundTransparency"] = 1;
    objects["Instance83"]["BorderSizePixel"] = 0;
    objects["Instance83"]["Rotation"] = 0;
    objects["Instance83"]["Transparency"] = 1;
    objects["Instance83"]["Name"] = "Pages";
    objects["Instance83"]["SelectionOrder"] = 0;
    objects["Instance83"]["Visible"] = true;
    objects["Instance83"]["Selectable"] = false;
    objects["Instance83"]["Position"] = UDim2.new(0.20000000298023224, 0, 0, 0);
    objects["Instance83"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance84"]["LayoutOrder"] = 0;
    objects["Instance84"]["Active"] = false;
    objects["Instance84"]["Parent"] = objects["Instance83"];
    objects["Instance84"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance84"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance84"]["ZIndex"] = 1;
    objects["Instance84"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance84"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance84"]["Draggable"] = false;
    objects["Instance84"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance84"]["ClipsDescendants"] = false;
    objects["Instance84"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance84"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance84"]["BackgroundTransparency"] = 1;
    objects["Instance84"]["BorderSizePixel"] = 0;
    objects["Instance84"]["Rotation"] = 0;
    objects["Instance84"]["Transparency"] = 1;
    objects["Instance84"]["Name"] = "NotFound";
    objects["Instance84"]["SelectionOrder"] = 0;
    objects["Instance84"]["Visible"] = false;
    objects["Instance84"]["Selectable"] = false;
    objects["Instance84"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance84"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance85"]["Visible"] = true;
    objects["Instance85"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance85"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance85"]["Active"] = false;
    objects["Instance85"]["TextStrokeTransparency"] = 1;
    objects["Instance85"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance85"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance85"]["ZIndex"] = 1;
    objects["Instance85"]["BorderSizePixel"] = 0;
    objects["Instance85"]["Draggable"] = false;
    objects["Instance85"]["RichText"] = false;
    objects["Instance85"]["Transparency"] = 1;
    objects["Instance85"]["SelectionOrder"] = 0;
    objects["Instance85"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance85"]["TextScaled"] = true;
    objects["Instance85"]["TextWrap"] = true;
    objects["Instance85"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance85"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance85"]["Parent"] = objects["Instance84"];
    objects["Instance85"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance85"]["TextSize"] = 14;
    objects["Instance85"]["Position"] = UDim2.new(0, 0, 0.3144960403442383, 0);
    objects["Instance85"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance85"]["Size"] = UDim2.new(1, 0, 0.19169878959655762, 0);
    objects["Instance85"]["BackgroundTransparency"] = 1;
    objects["Instance85"]["LineHeight"] = 1;
    objects["Instance85"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance85"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance85"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance85"]["Text"] = "PAGE VIEW";
    objects["Instance85"]["LayoutOrder"] = 0;
    objects["Instance85"]["TextWrapped"] = true;
    objects["Instance85"]["Rotation"] = 0;
    objects["Instance85"]["TextTransparency"] = 0;
    objects["Instance85"]["Name"] = "TextLabel";
    objects["Instance85"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance85"]["ClipsDescendants"] = false;
    objects["Instance85"]["MaxVisibleGraphemes"] = -1;
    objects["Instance85"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance85"]["Selectable"] = false;

    objects["Instance86"]["Visible"] = true;
    objects["Instance86"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance86"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance86"]["Active"] = false;
    objects["Instance86"]["TextStrokeTransparency"] = 1;
    objects["Instance86"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance86"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance86"]["ZIndex"] = 1;
    objects["Instance86"]["BorderSizePixel"] = 0;
    objects["Instance86"]["Draggable"] = false;
    objects["Instance86"]["RichText"] = false;
    objects["Instance86"]["Transparency"] = 1;
    objects["Instance86"]["SelectionOrder"] = 0;
    objects["Instance86"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance86"]["TextScaled"] = true;
    objects["Instance86"]["TextWrap"] = true;
    objects["Instance86"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance86"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance86"]["Parent"] = objects["Instance84"];
    objects["Instance86"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance86"]["TextSize"] = 14;
    objects["Instance86"]["Position"] = UDim2.new(0, 0, 0.5061946511268616, 0);
    objects["Instance86"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance86"]["Size"] = UDim2.new(1, 0, 0.06389960646629333, 0);
    objects["Instance86"]["BackgroundTransparency"] = 1;
    objects["Instance86"]["LineHeight"] = 1;
    objects["Instance86"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance86"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance86"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance86"]["Text"] = "Contents will be added soon";
    objects["Instance86"]["LayoutOrder"] = 0;
    objects["Instance86"]["TextWrapped"] = true;
    objects["Instance86"]["Rotation"] = 0;
    objects["Instance86"]["TextTransparency"] = 0;
    objects["Instance86"]["Name"] = "TextLabel";
    objects["Instance86"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance86"]["ClipsDescendants"] = false;
    objects["Instance86"]["MaxVisibleGraphemes"] = -1;
    objects["Instance86"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance86"]["Selectable"] = false;

    objects["Instance87"]["LayoutOrder"] = 0;
    objects["Instance87"]["Active"] = false;
    objects["Instance87"]["Parent"] = objects["Instance83"];
    objects["Instance87"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance87"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance87"]["ZIndex"] = 1;
    objects["Instance87"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance87"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance87"]["Draggable"] = false;
    objects["Instance87"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance87"]["ClipsDescendants"] = false;
    objects["Instance87"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance87"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance87"]["BackgroundTransparency"] = 1;
    objects["Instance87"]["BorderSizePixel"] = 0;
    objects["Instance87"]["Rotation"] = 0;
    objects["Instance87"]["Transparency"] = 1;
    objects["Instance87"]["Name"] = "RSpy";
    objects["Instance87"]["SelectionOrder"] = 0;
    objects["Instance87"]["Visible"] = false;
    objects["Instance87"]["Selectable"] = false;
    objects["Instance87"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance87"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance88"]["LayoutOrder"] = 0;
    objects["Instance88"]["Active"] = false;
    objects["Instance88"]["Parent"] = objects["Instance87"];
    objects["Instance88"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance88"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance88"]["ZIndex"] = 1;
    objects["Instance88"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance88"]["Size"] = UDim2.new(1, 0, 0.07999999821186066, 0);
    objects["Instance88"]["Draggable"] = false;
    objects["Instance88"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance88"]["ClipsDescendants"] = false;
    objects["Instance88"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance88"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance88"]["BackgroundTransparency"] = 1;
    objects["Instance88"]["BorderSizePixel"] = 0;
    objects["Instance88"]["Rotation"] = 0;
    objects["Instance88"]["Transparency"] = 1;
    objects["Instance88"]["Name"] = "Buttons";
    objects["Instance88"]["SelectionOrder"] = 0;
    objects["Instance88"]["Visible"] = true;
    objects["Instance88"]["Selectable"] = false;
    objects["Instance88"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance88"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance89"]["Visible"] = true;
    objects["Instance89"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance89"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance89"]["Active"] = true;
    objects["Instance89"]["TextStrokeTransparency"] = 1;
    objects["Instance89"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance89"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance89"]["ZIndex"] = 1;
    objects["Instance89"]["BorderSizePixel"] = 0;
    objects["Instance89"]["Draggable"] = false;
    objects["Instance89"]["RichText"] = false;
    objects["Instance89"]["Modal"] = false;
    objects["Instance89"]["AutoButtonColor"] = false;
    objects["Instance89"]["Transparency"] = 0.949999988079071;
    objects["Instance89"]["SelectionOrder"] = 0;
    objects["Instance89"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance89"]["TextScaled"] = false;
    objects["Instance89"]["TextWrap"] = false;
    objects["Instance89"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance89"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance89"]["Parent"] = objects["Instance88"];
    objects["Instance89"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance89"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance89"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance89"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance89"]["Selected"] = false;
    objects["Instance89"]["TextSize"] = 14;
    objects["Instance89"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance89"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance89"]["TextWrapped"] = false;
    objects["Instance89"]["ClipsDescendants"] = false;
    objects["Instance89"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance89"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance89"]["Text"] = "";
    objects["Instance89"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance89"]["LayoutOrder"] = 3;
    objects["Instance89"]["Rotation"] = 0;
    objects["Instance89"]["LineHeight"] = 1;
    objects["Instance89"]["Name"] = "To";
    objects["Instance89"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance89"]["Selectable"] = true;
    objects["Instance89"]["MaxVisibleGraphemes"] = -1;
    objects["Instance89"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance89"]["TextTransparency"] = 0;

    objects["Instance90"]["Visible"] = true;
    objects["Instance90"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance90"]["Size"] = UDim2.new(0.800000011920929, 0, 0.800000011920929, 0);
    objects["Instance90"]["ImageTransparency"] = 0;
    objects["Instance90"]["Parent"] = objects["Instance89"];
    objects["Instance90"]["Position"] = UDim2.new(0.10000000149011612, 0, 0.5, 0);
    objects["Instance90"]["BackgroundTransparency"] = 1;
    objects["Instance90"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance90"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance90"]["Image"] = "rbxassetid://9692125126";
    objects["Instance90"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance90"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance90"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance90"]["ZIndex"] = 1;
    objects["Instance90"]["BorderSizePixel"] = 0;
    objects["Instance90"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance90"]["Draggable"] = false;
    objects["Instance90"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance90"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance90"]["ClipsDescendants"] = false;
    objects["Instance90"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance90"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance90"]["LayoutOrder"] = 0;
    objects["Instance90"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance90"]["Rotation"] = 0;
    objects["Instance90"]["Transparency"] = 1;
    objects["Instance90"]["Name"] = "Icon";
    objects["Instance90"]["SelectionOrder"] = 0;
    objects["Instance90"]["SliceScale"] = 1;
    objects["Instance90"]["Selectable"] = false;
    objects["Instance90"]["Active"] = false;
    objects["Instance90"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance91"]["AspectRatio"] = 1;
    objects["Instance91"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance91"]["Parent"] = objects["Instance90"];
    objects["Instance91"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance91"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance92"]["Visible"] = true;
    objects["Instance92"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance92"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance92"]["Active"] = false;
    objects["Instance92"]["TextStrokeTransparency"] = 1;
    objects["Instance92"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance92"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance92"]["ZIndex"] = 1;
    objects["Instance92"]["BorderSizePixel"] = 0;
    objects["Instance92"]["Draggable"] = false;
    objects["Instance92"]["RichText"] = false;
    objects["Instance92"]["Transparency"] = 1;
    objects["Instance92"]["SelectionOrder"] = 0;
    objects["Instance92"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance92"]["TextScaled"] = true;
    objects["Instance92"]["TextWrap"] = true;
    objects["Instance92"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance92"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance92"]["Parent"] = objects["Instance89"];
    objects["Instance92"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance92"]["TextSize"] = 14;
    objects["Instance92"]["Position"] = UDim2.new(0.20000006258487701, 0, 0.4999999701976776, 0);
    objects["Instance92"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance92"]["Size"] = UDim2.new(0.699999988079071, 0, 0.6499999761581421, 0);
    objects["Instance92"]["BackgroundTransparency"] = 1;
    objects["Instance92"]["LineHeight"] = 1;
    objects["Instance92"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance92"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance92"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance92"]["Text"] = "Outcoming";
    objects["Instance92"]["LayoutOrder"] = 0;
    objects["Instance92"]["TextWrapped"] = true;
    objects["Instance92"]["Rotation"] = 0;
    objects["Instance92"]["TextTransparency"] = 0;
    objects["Instance92"]["Name"] = "Label";
    objects["Instance92"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance92"]["ClipsDescendants"] = false;
    objects["Instance92"]["MaxVisibleGraphemes"] = -1;
    objects["Instance92"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance92"]["Selectable"] = false;

    objects["Instance93"]["Visible"] = true;
    objects["Instance93"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance93"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance93"]["Active"] = true;
    objects["Instance93"]["TextStrokeTransparency"] = 1;
    objects["Instance93"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance93"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance93"]["ZIndex"] = 1;
    objects["Instance93"]["BorderSizePixel"] = 0;
    objects["Instance93"]["Draggable"] = false;
    objects["Instance93"]["RichText"] = false;
    objects["Instance93"]["Modal"] = false;
    objects["Instance93"]["AutoButtonColor"] = false;
    objects["Instance93"]["Transparency"] = 1;
    objects["Instance93"]["SelectionOrder"] = 0;
    objects["Instance93"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance93"]["TextScaled"] = false;
    objects["Instance93"]["TextWrap"] = false;
    objects["Instance93"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance93"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance93"]["Parent"] = objects["Instance88"];
    objects["Instance93"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance93"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance93"]["Position"] = UDim2.new(0.5, 0, 0, 0);
    objects["Instance93"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance93"]["Selected"] = false;
    objects["Instance93"]["TextSize"] = 14;
    objects["Instance93"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance93"]["BackgroundTransparency"] = 1;
    objects["Instance93"]["TextWrapped"] = false;
    objects["Instance93"]["ClipsDescendants"] = false;
    objects["Instance93"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance93"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance93"]["Text"] = "";
    objects["Instance93"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance93"]["LayoutOrder"] = 3;
    objects["Instance93"]["Rotation"] = 0;
    objects["Instance93"]["LineHeight"] = 1;
    objects["Instance93"]["Name"] = "From";
    objects["Instance93"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance93"]["Selectable"] = true;
    objects["Instance93"]["MaxVisibleGraphemes"] = -1;
    objects["Instance93"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance93"]["TextTransparency"] = 0;

    objects["Instance94"]["Visible"] = true;
    objects["Instance94"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance94"]["Size"] = UDim2.new(0.800000011920929, 0, 0.800000011920929, 0);
    objects["Instance94"]["ImageTransparency"] = 0;
    objects["Instance94"]["Parent"] = objects["Instance93"];
    objects["Instance94"]["Position"] = UDim2.new(0.10000000149011612, 0, 0.5, 0);
    objects["Instance94"]["BackgroundTransparency"] = 1;
    objects["Instance94"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance94"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance94"]["Image"] = "rbxassetid://12684119225";
    objects["Instance94"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance94"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance94"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance94"]["ZIndex"] = 1;
    objects["Instance94"]["BorderSizePixel"] = 0;
    objects["Instance94"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance94"]["Draggable"] = false;
    objects["Instance94"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance94"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance94"]["ClipsDescendants"] = false;
    objects["Instance94"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance94"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance94"]["LayoutOrder"] = 0;
    objects["Instance94"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance94"]["Rotation"] = 0;
    objects["Instance94"]["Transparency"] = 1;
    objects["Instance94"]["Name"] = "Icon";
    objects["Instance94"]["SelectionOrder"] = 0;
    objects["Instance94"]["SliceScale"] = 1;
    objects["Instance94"]["Selectable"] = false;
    objects["Instance94"]["Active"] = false;
    objects["Instance94"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance95"]["AspectRatio"] = 1;
    objects["Instance95"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance95"]["Parent"] = objects["Instance94"];
    objects["Instance95"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance95"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance96"]["Visible"] = true;
    objects["Instance96"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance96"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance96"]["Active"] = false;
    objects["Instance96"]["TextStrokeTransparency"] = 1;
    objects["Instance96"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance96"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance96"]["ZIndex"] = 1;
    objects["Instance96"]["BorderSizePixel"] = 0;
    objects["Instance96"]["Draggable"] = false;
    objects["Instance96"]["RichText"] = false;
    objects["Instance96"]["Transparency"] = 1;
    objects["Instance96"]["SelectionOrder"] = 0;
    objects["Instance96"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance96"]["TextScaled"] = true;
    objects["Instance96"]["TextWrap"] = true;
    objects["Instance96"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance96"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance96"]["Parent"] = objects["Instance93"];
    objects["Instance96"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance96"]["TextSize"] = 14;
    objects["Instance96"]["Position"] = UDim2.new(0.20000006258487701, 0, 0.4999999701976776, 0);
    objects["Instance96"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance96"]["Size"] = UDim2.new(0.699999988079071, 0, 0.6499999761581421, 0);
    objects["Instance96"]["BackgroundTransparency"] = 1;
    objects["Instance96"]["LineHeight"] = 1;
    objects["Instance96"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance96"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance96"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance96"]["Text"] = "Incoming";
    objects["Instance96"]["LayoutOrder"] = 0;
    objects["Instance96"]["TextWrapped"] = true;
    objects["Instance96"]["Rotation"] = 0;
    objects["Instance96"]["TextTransparency"] = 0;
    objects["Instance96"]["Name"] = "Label";
    objects["Instance96"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance96"]["ClipsDescendants"] = false;
    objects["Instance96"]["MaxVisibleGraphemes"] = -1;
    objects["Instance96"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance96"]["Selectable"] = false;

    objects["Instance97"]["LayoutOrder"] = 0;
    objects["Instance97"]["Active"] = false;
    objects["Instance97"]["Parent"] = objects["Instance93"];
    objects["Instance97"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance97"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance97"]["ZIndex"] = 1;
    objects["Instance97"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance97"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance97"]["Draggable"] = false;
    objects["Instance97"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance97"]["ClipsDescendants"] = false;
    objects["Instance97"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance97"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance97"]["BackgroundTransparency"] = 0.5;
    objects["Instance97"]["BorderSizePixel"] = 0;
    objects["Instance97"]["Rotation"] = 0;
    objects["Instance97"]["Transparency"] = 0.5;
    objects["Instance97"]["Name"] = "Separator";
    objects["Instance97"]["SelectionOrder"] = 0;
    objects["Instance97"]["Visible"] = true;
    objects["Instance97"]["Selectable"] = false;
    objects["Instance97"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance97"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance98"]["LayoutOrder"] = 0;
    objects["Instance98"]["Active"] = false;
    objects["Instance98"]["Parent"] = objects["Instance88"];
    objects["Instance98"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance98"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance98"]["ZIndex"] = 1;
    objects["Instance98"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance98"]["Size"] = UDim2.new(0.9835000038146973, 0, 0, 1);
    objects["Instance98"]["Draggable"] = false;
    objects["Instance98"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance98"]["ClipsDescendants"] = false;
    objects["Instance98"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance98"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance98"]["BackgroundTransparency"] = 0.5;
    objects["Instance98"]["BorderSizePixel"] = 0;
    objects["Instance98"]["Rotation"] = 0;
    objects["Instance98"]["Transparency"] = 0.5;
    objects["Instance98"]["Name"] = "Separator";
    objects["Instance98"]["SelectionOrder"] = 0;
    objects["Instance98"]["Visible"] = true;
    objects["Instance98"]["Selectable"] = false;
    objects["Instance98"]["Position"] = UDim2.new(0, 0, 1.0000003576278687, 0);
    objects["Instance98"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance99"]["LayoutOrder"] = 0;
    objects["Instance99"]["Active"] = false;
    objects["Instance99"]["Parent"] = objects["Instance87"];
    objects["Instance99"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance99"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance99"]["ZIndex"] = 1;
    objects["Instance99"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance99"]["Size"] = UDim2.new(1, 0, 0.9200000166893005, -1);
    objects["Instance99"]["Draggable"] = false;
    objects["Instance99"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance99"]["ClipsDescendants"] = false;
    objects["Instance99"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance99"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance99"]["BackgroundTransparency"] = 1;
    objects["Instance99"]["BorderSizePixel"] = 0;
    objects["Instance99"]["Rotation"] = 0;
    objects["Instance99"]["Transparency"] = 1;
    objects["Instance99"]["Name"] = "Contents";
    objects["Instance99"]["SelectionOrder"] = 0;
    objects["Instance99"]["Visible"] = true;
    objects["Instance99"]["Selectable"] = false;
    objects["Instance99"]["Position"] = UDim2.new(0, 0, 0.07999999821186066, 1);
    objects["Instance99"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance100"]["LayoutOrder"] = 0;
    objects["Instance100"]["Active"] = false;
    objects["Instance100"]["Parent"] = objects["Instance99"];
    objects["Instance100"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance100"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance100"]["ZIndex"] = 1;
    objects["Instance100"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance100"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance100"]["Draggable"] = false;
    objects["Instance100"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance100"]["ClipsDescendants"] = false;
    objects["Instance100"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance100"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance100"]["BackgroundTransparency"] = 1;
    objects["Instance100"]["BorderSizePixel"] = 0;
    objects["Instance100"]["Rotation"] = 0;
    objects["Instance100"]["Transparency"] = 1;
    objects["Instance100"]["Name"] = "From";
    objects["Instance100"]["SelectionOrder"] = 0;
    objects["Instance100"]["Visible"] = false;
    objects["Instance100"]["Selectable"] = false;
    objects["Instance100"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance100"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance101"]["Visible"] = true;
    objects["Instance101"]["Active"] = false;
    objects["Instance101"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance101"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance101"]["ZIndex"] = 1;
    objects["Instance101"]["BorderSizePixel"] = 0;
    objects["Instance101"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance101"]["Draggable"] = false;
    objects["Instance101"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance101"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance101"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance101"]["Transparency"] = 1;
    objects["Instance101"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance101"]["SelectionOrder"] = 0;
    objects["Instance101"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance101"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance101"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance101"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance101"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance101"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance101"]["Size"] = UDim2.new(0.25, 0, 0.949999988079071, 1);
    objects["Instance101"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance101"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance101"]["Selectable"] = false;
    objects["Instance101"]["ClipsDescendants"] = true;
    objects["Instance101"]["ScrollBarImageTransparency"] = 0;
    objects["Instance101"]["ScrollBarThickness"] = 0;
    objects["Instance101"]["Parent"] = objects["Instance100"];
    objects["Instance101"]["BackgroundTransparency"] = 1;
    objects["Instance101"]["Rotation"] = 0;
    objects["Instance101"]["LayoutOrder"] = 0;
    objects["Instance101"]["Name"] = "Logs";
    objects["Instance101"]["Position"] = UDim2.new(0, 0, 0.012000000104308128, 0);
    objects["Instance101"]["ScrollingEnabled"] = true;
    objects["Instance101"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance101"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance101"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance102"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance102"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance102"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance102"]["Parent"] = objects["Instance101"];
    objects["Instance102"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance102"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance102"]["Name"] = "UIListLayout";
    objects["Instance102"]["Padding"] = UDim.new(0, 0);
    objects["Instance102"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance102"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance103"]["Visible"] = true;
    objects["Instance103"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance103"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance103"]["Active"] = false;
    objects["Instance103"]["TextStrokeTransparency"] = 1;
    objects["Instance103"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance103"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance103"]["ZIndex"] = 1;
    objects["Instance103"]["BorderSizePixel"] = 0;
    objects["Instance103"]["Draggable"] = false;
    objects["Instance103"]["RichText"] = false;
    objects["Instance103"]["Modal"] = false;
    objects["Instance103"]["AutoButtonColor"] = true;
    objects["Instance103"]["Transparency"] = 1;
    objects["Instance103"]["SelectionOrder"] = 0;
    objects["Instance103"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance103"]["TextScaled"] = false;
    objects["Instance103"]["TextWrap"] = false;
    objects["Instance103"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance103"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance103"]["Parent"] = objects["Instance101"];
    objects["Instance103"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance103"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance103"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance103"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance103"]["Selected"] = false;
    objects["Instance103"]["TextSize"] = 14;
    objects["Instance103"]["Size"] = UDim2.new(1, 0, 0.13249999284744263, 0);
    objects["Instance103"]["BackgroundTransparency"] = 1;
    objects["Instance103"]["TextWrapped"] = false;
    objects["Instance103"]["ClipsDescendants"] = false;
    objects["Instance103"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance103"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance103"]["Text"] = "";
    objects["Instance103"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance103"]["LayoutOrder"] = 0;
    objects["Instance103"]["Rotation"] = 0;
    objects["Instance103"]["LineHeight"] = 1;
    objects["Instance103"]["Name"] = "Log";
    objects["Instance103"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance103"]["Selectable"] = false;
    objects["Instance103"]["MaxVisibleGraphemes"] = -1;
    objects["Instance103"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance103"]["TextTransparency"] = 0;

    objects["Instance104"]["LayoutOrder"] = 0;
    objects["Instance104"]["Active"] = false;
    objects["Instance104"]["Parent"] = objects["Instance103"];
    objects["Instance104"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance104"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance104"]["ZIndex"] = 1;
    objects["Instance104"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance104"]["Size"] = UDim2.new(0.8500000238418579, 0, 0.699999988079071, 0);
    objects["Instance104"]["Draggable"] = false;
    objects["Instance104"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance104"]["ClipsDescendants"] = false;
    objects["Instance104"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance104"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance104"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance104"]["BorderSizePixel"] = 0;
    objects["Instance104"]["Rotation"] = 0;
    objects["Instance104"]["Transparency"] = 0.949999988079071;
    objects["Instance104"]["Name"] = "Contents";
    objects["Instance104"]["SelectionOrder"] = 0;
    objects["Instance104"]["Visible"] = true;
    objects["Instance104"]["Selectable"] = false;
    objects["Instance104"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance104"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance105"]["Enabled"] = true;
    objects["Instance105"]["Transparency"] = 0.5;
    objects["Instance105"]["Name"] = "UIStroke";
    objects["Instance105"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance105"]["Parent"] = objects["Instance104"];
    objects["Instance105"]["Thickness"] = 1;
    objects["Instance105"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance105"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance106"]["LayoutOrder"] = 0;
    objects["Instance106"]["Active"] = false;
    objects["Instance106"]["Parent"] = objects["Instance104"];
    objects["Instance106"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance106"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance106"]["ZIndex"] = 1;
    objects["Instance106"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance106"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance106"]["Draggable"] = false;
    objects["Instance106"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance106"]["ClipsDescendants"] = false;
    objects["Instance106"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance106"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance106"]["BackgroundTransparency"] = 0.25;
    objects["Instance106"]["BorderSizePixel"] = 0;
    objects["Instance106"]["Rotation"] = 0;
    objects["Instance106"]["Transparency"] = 0.25;
    objects["Instance106"]["Name"] = "Frame";
    objects["Instance106"]["SelectionOrder"] = 0;
    objects["Instance106"]["Visible"] = true;
    objects["Instance106"]["Selectable"] = false;
    objects["Instance106"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance106"]["BackgroundColor3"] = Color3.new(1, 0.666667, 0);

    objects["Instance107"]["Visible"] = true;
    objects["Instance107"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance107"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance107"]["Active"] = false;
    objects["Instance107"]["TextStrokeTransparency"] = 1;
    objects["Instance107"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance107"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance107"]["ZIndex"] = 1;
    objects["Instance107"]["BorderSizePixel"] = 0;
    objects["Instance107"]["Draggable"] = false;
    objects["Instance107"]["RichText"] = false;
    objects["Instance107"]["Transparency"] = 1;
    objects["Instance107"]["SelectionOrder"] = 0;
    objects["Instance107"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance107"]["TextScaled"] = true;
    objects["Instance107"]["TextWrap"] = true;
    objects["Instance107"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance107"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance107"]["Parent"] = objects["Instance104"];
    objects["Instance107"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance107"]["TextSize"] = 14;
    objects["Instance107"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance107"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance107"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance107"]["BackgroundTransparency"] = 1;
    objects["Instance107"]["LineHeight"] = 1;
    objects["Instance107"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance107"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance107"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance107"]["Text"] = "RemoteEvent";
    objects["Instance107"]["LayoutOrder"] = 0;
    objects["Instance107"]["TextWrapped"] = true;
    objects["Instance107"]["Rotation"] = 0;
    objects["Instance107"]["TextTransparency"] = 0;
    objects["Instance107"]["Name"] = "Label";
    objects["Instance107"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance107"]["ClipsDescendants"] = false;
    objects["Instance107"]["MaxVisibleGraphemes"] = -1;
    objects["Instance107"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance107"]["Selectable"] = false;

    objects["Instance108"]["LayoutOrder"] = 0;
    objects["Instance108"]["Active"] = false;
    objects["Instance108"]["Parent"] = objects["Instance104"];
    objects["Instance108"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance108"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance108"]["ZIndex"] = 1;
    objects["Instance108"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance108"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance108"]["Draggable"] = false;
    objects["Instance108"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance108"]["ClipsDescendants"] = false;
    objects["Instance108"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance108"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance108"]["BackgroundTransparency"] = 1;
    objects["Instance108"]["BorderSizePixel"] = 0;
    objects["Instance108"]["Rotation"] = 0;
    objects["Instance108"]["Transparency"] = 1;
    objects["Instance108"]["Name"] = "Selection";
    objects["Instance108"]["SelectionOrder"] = 0;
    objects["Instance108"]["Visible"] = true;
    objects["Instance108"]["Selectable"] = false;
    objects["Instance108"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance108"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance109"]["LayoutOrder"] = 0;
    objects["Instance109"]["Active"] = false;
    objects["Instance109"]["Parent"] = objects["Instance99"];
    objects["Instance109"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance109"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance109"]["ZIndex"] = 1;
    objects["Instance109"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance109"]["Size"] = UDim2.new(0, 1, 0.9729999899864197, 0);
    objects["Instance109"]["Draggable"] = false;
    objects["Instance109"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance109"]["ClipsDescendants"] = false;
    objects["Instance109"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance109"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance109"]["BackgroundTransparency"] = 0.5;
    objects["Instance109"]["BorderSizePixel"] = 0;
    objects["Instance109"]["Rotation"] = 0;
    objects["Instance109"]["Transparency"] = 0.5;
    objects["Instance109"]["Name"] = "Separator";
    objects["Instance109"]["SelectionOrder"] = 0;
    objects["Instance109"]["Visible"] = true;
    objects["Instance109"]["Selectable"] = false;
    objects["Instance109"]["Position"] = UDim2.new(0.2500000298023224, -1, 0, 0);
    objects["Instance109"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance110"]["LayoutOrder"] = 0;
    objects["Instance110"]["Active"] = false;
    objects["Instance110"]["Parent"] = objects["Instance99"];
    objects["Instance110"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance110"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance110"]["ZIndex"] = 1;
    objects["Instance110"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance110"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance110"]["Draggable"] = false;
    objects["Instance110"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance110"]["ClipsDescendants"] = false;
    objects["Instance110"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance110"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance110"]["BackgroundTransparency"] = 1;
    objects["Instance110"]["BorderSizePixel"] = 0;
    objects["Instance110"]["Rotation"] = 0;
    objects["Instance110"]["Transparency"] = 1;
    objects["Instance110"]["Name"] = "To";
    objects["Instance110"]["SelectionOrder"] = 0;
    objects["Instance110"]["Visible"] = true;
    objects["Instance110"]["Selectable"] = false;
    objects["Instance110"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance110"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance111"]["Visible"] = true;
    objects["Instance111"]["Active"] = false;
    objects["Instance111"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance111"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance111"]["ZIndex"] = 1;
    objects["Instance111"]["BorderSizePixel"] = 0;
    objects["Instance111"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance111"]["Draggable"] = false;
    objects["Instance111"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance111"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance111"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance111"]["Transparency"] = 1;
    objects["Instance111"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance111"]["SelectionOrder"] = 0;
    objects["Instance111"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance111"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance111"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance111"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance111"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance111"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance111"]["Size"] = UDim2.new(0.25, 0, 0.949999988079071, 1);
    objects["Instance111"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance111"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance111"]["Selectable"] = false;
    objects["Instance111"]["ClipsDescendants"] = true;
    objects["Instance111"]["ScrollBarImageTransparency"] = 0;
    objects["Instance111"]["ScrollBarThickness"] = 0;
    objects["Instance111"]["Parent"] = objects["Instance110"];
    objects["Instance111"]["BackgroundTransparency"] = 1;
    objects["Instance111"]["Rotation"] = 0;
    objects["Instance111"]["LayoutOrder"] = 0;
    objects["Instance111"]["Name"] = "Logs";
    objects["Instance111"]["Position"] = UDim2.new(0, 0, 0.012000000104308128, 0);
    objects["Instance111"]["ScrollingEnabled"] = true;
    objects["Instance111"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance111"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance111"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance112"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance112"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance112"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance112"]["Parent"] = objects["Instance111"];
    objects["Instance112"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance112"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance112"]["Name"] = "UIListLayout";
    objects["Instance112"]["Padding"] = UDim.new(0, 0);
    objects["Instance112"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance112"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance113"]["Visible"] = true;
    objects["Instance113"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance113"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance113"]["Active"] = false;
    objects["Instance113"]["TextStrokeTransparency"] = 1;
    objects["Instance113"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance113"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance113"]["ZIndex"] = 1;
    objects["Instance113"]["BorderSizePixel"] = 0;
    objects["Instance113"]["Draggable"] = false;
    objects["Instance113"]["RichText"] = false;
    objects["Instance113"]["Modal"] = false;
    objects["Instance113"]["AutoButtonColor"] = true;
    objects["Instance113"]["Transparency"] = 1;
    objects["Instance113"]["SelectionOrder"] = 0;
    objects["Instance113"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance113"]["TextScaled"] = false;
    objects["Instance113"]["TextWrap"] = false;
    objects["Instance113"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance113"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance113"]["Parent"] = objects["Instance111"];
    objects["Instance113"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance113"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance113"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance113"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance113"]["Selected"] = false;
    objects["Instance113"]["TextSize"] = 14;
    objects["Instance113"]["Size"] = UDim2.new(1, 0, 0.13249999284744263, 0);
    objects["Instance113"]["BackgroundTransparency"] = 1;
    objects["Instance113"]["TextWrapped"] = false;
    objects["Instance113"]["ClipsDescendants"] = false;
    objects["Instance113"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance113"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance113"]["Text"] = "";
    objects["Instance113"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance113"]["LayoutOrder"] = 0;
    objects["Instance113"]["Rotation"] = 0;
    objects["Instance113"]["LineHeight"] = 1;
    objects["Instance113"]["Name"] = "Log";
    objects["Instance113"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance113"]["Selectable"] = false;
    objects["Instance113"]["MaxVisibleGraphemes"] = -1;
    objects["Instance113"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance113"]["TextTransparency"] = 0;

    objects["Instance114"]["LayoutOrder"] = 0;
    objects["Instance114"]["Active"] = false;
    objects["Instance114"]["Parent"] = objects["Instance113"];
    objects["Instance114"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance114"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance114"]["ZIndex"] = 1;
    objects["Instance114"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance114"]["Size"] = UDim2.new(0.8500000238418579, 0, 0.699999988079071, 0);
    objects["Instance114"]["Draggable"] = false;
    objects["Instance114"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance114"]["ClipsDescendants"] = false;
    objects["Instance114"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance114"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance114"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance114"]["BorderSizePixel"] = 0;
    objects["Instance114"]["Rotation"] = 0;
    objects["Instance114"]["Transparency"] = 0.949999988079071;
    objects["Instance114"]["Name"] = "Contents";
    objects["Instance114"]["SelectionOrder"] = 0;
    objects["Instance114"]["Visible"] = true;
    objects["Instance114"]["Selectable"] = false;
    objects["Instance114"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance114"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance115"]["Enabled"] = true;
    objects["Instance115"]["Transparency"] = 0.5;
    objects["Instance115"]["Name"] = "UIStroke";
    objects["Instance115"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance115"]["Parent"] = objects["Instance114"];
    objects["Instance115"]["Thickness"] = 1;
    objects["Instance115"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance115"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance116"]["LayoutOrder"] = 0;
    objects["Instance116"]["Active"] = false;
    objects["Instance116"]["Parent"] = objects["Instance114"];
    objects["Instance116"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance116"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance116"]["ZIndex"] = 1;
    objects["Instance116"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance116"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance116"]["Draggable"] = false;
    objects["Instance116"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance116"]["ClipsDescendants"] = false;
    objects["Instance116"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance116"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance116"]["BackgroundTransparency"] = 0.25;
    objects["Instance116"]["BorderSizePixel"] = 0;
    objects["Instance116"]["Rotation"] = 0;
    objects["Instance116"]["Transparency"] = 0.25;
    objects["Instance116"]["Name"] = "Frame";
    objects["Instance116"]["SelectionOrder"] = 0;
    objects["Instance116"]["Visible"] = true;
    objects["Instance116"]["Selectable"] = false;
    objects["Instance116"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance116"]["BackgroundColor3"] = Color3.new(1, 0.666667, 0);

    objects["Instance117"]["Visible"] = true;
    objects["Instance117"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance117"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance117"]["Active"] = false;
    objects["Instance117"]["TextStrokeTransparency"] = 1;
    objects["Instance117"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance117"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance117"]["ZIndex"] = 1;
    objects["Instance117"]["BorderSizePixel"] = 0;
    objects["Instance117"]["Draggable"] = false;
    objects["Instance117"]["RichText"] = false;
    objects["Instance117"]["Transparency"] = 1;
    objects["Instance117"]["SelectionOrder"] = 0;
    objects["Instance117"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance117"]["TextScaled"] = true;
    objects["Instance117"]["TextWrap"] = true;
    objects["Instance117"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance117"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance117"]["Parent"] = objects["Instance114"];
    objects["Instance117"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance117"]["TextSize"] = 14;
    objects["Instance117"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance117"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance117"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance117"]["BackgroundTransparency"] = 1;
    objects["Instance117"]["LineHeight"] = 1;
    objects["Instance117"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance117"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance117"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance117"]["Text"] = "RemoteEventar";
    objects["Instance117"]["LayoutOrder"] = 0;
    objects["Instance117"]["TextWrapped"] = true;
    objects["Instance117"]["Rotation"] = 0;
    objects["Instance117"]["TextTransparency"] = 0;
    objects["Instance117"]["Name"] = "Label";
    objects["Instance117"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance117"]["ClipsDescendants"] = false;
    objects["Instance117"]["MaxVisibleGraphemes"] = -1;
    objects["Instance117"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance117"]["Selectable"] = false;

    objects["Instance118"]["LayoutOrder"] = 0;
    objects["Instance118"]["Active"] = false;
    objects["Instance118"]["Parent"] = objects["Instance114"];
    objects["Instance118"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance118"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance118"]["ZIndex"] = 1;
    objects["Instance118"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance118"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance118"]["Draggable"] = false;
    objects["Instance118"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance118"]["ClipsDescendants"] = false;
    objects["Instance118"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance118"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance118"]["BackgroundTransparency"] = 1;
    objects["Instance118"]["BorderSizePixel"] = 0;
    objects["Instance118"]["Rotation"] = 0;
    objects["Instance118"]["Transparency"] = 1;
    objects["Instance118"]["Name"] = "Selection";
    objects["Instance118"]["SelectionOrder"] = 0;
    objects["Instance118"]["Visible"] = true;
    objects["Instance118"]["Selectable"] = false;
    objects["Instance118"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance118"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance119"]["LayoutOrder"] = 0;
    objects["Instance119"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance119"]["LineHeight"] = 1;
    objects["Instance119"]["Active"] = true;
    objects["Instance119"]["TextStrokeTransparency"] = 1;
    objects["Instance119"]["SelectionStart"] = -1;
    objects["Instance119"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance119"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance119"]["ZIndex"] = 1;
    objects["Instance119"]["BorderSizePixel"] = 0;
    objects["Instance119"]["TextEditable"] = true;
    objects["Instance119"]["Draggable"] = false;
    objects["Instance119"]["RichText"] = false;
    objects["Instance119"]["Transparency"] = 0.9750000238418579;
    objects["Instance119"]["SelectionOrder"] = 0;
    objects["Instance119"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance119"]["TextScaled"] = false;
    objects["Instance119"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance119"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance119"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance119"]["Parent"] = objects["Instance110"];
    objects["Instance119"]["TextWrapped"] = false;
    objects["Instance119"]["MaxVisibleGraphemes"] = -1;
    objects["Instance119"]["Name"] = "TextBox";
    objects["Instance119"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance119"]["TextTransparency"] = 0;
    objects["Instance119"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance119"]["CursorPosition"] = 1;
    objects["Instance119"]["ClipsDescendants"] = false;
    objects["Instance119"]["PlaceholderText"] = "";
    objects["Instance119"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance119"]["Size"] = UDim2.new(0.75, 0, 0.6000000238418579, 0);
    objects["Instance119"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance119"]["Selectable"] = true;
    objects["Instance119"]["ShowNativeInput"] = true;
    objects["Instance119"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance119"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance119"]["Text"] = "";
    objects["Instance119"]["TextSize"] = 14;
    objects["Instance119"]["Visible"] = true;
    objects["Instance119"]["Rotation"] = 0;
    objects["Instance119"]["MultiLine"] = false;
    objects["Instance119"]["BackgroundTransparency"] = 0.9750000238418579;
    objects["Instance119"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance119"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance119"]["ClearTextOnFocus"] = true;
    objects["Instance119"]["Position"] = UDim2.new(0.25, 0, 0, 0);
    objects["Instance119"]["TextWrap"] = false;

    objects["Instance120"]["LayoutOrder"] = 0;
    objects["Instance120"]["Active"] = false;
    objects["Instance120"]["Parent"] = objects["Instance119"];
    objects["Instance120"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance120"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance120"]["ZIndex"] = 1;
    objects["Instance120"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance120"]["Size"] = UDim2.new(0.9789999723434448, 0, 0, 1);
    objects["Instance120"]["Draggable"] = false;
    objects["Instance120"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance120"]["ClipsDescendants"] = false;
    objects["Instance120"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance120"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance120"]["BackgroundTransparency"] = 0.5;
    objects["Instance120"]["BorderSizePixel"] = 0;
    objects["Instance120"]["Rotation"] = 0;
    objects["Instance120"]["Transparency"] = 0.5;
    objects["Instance120"]["Name"] = "Separator";
    objects["Instance120"]["SelectionOrder"] = 0;
    objects["Instance120"]["Visible"] = true;
    objects["Instance120"]["Selectable"] = false;
    objects["Instance120"]["Position"] = UDim2.new(0, 0, 1, 0);
    objects["Instance120"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance121"]["Visible"] = true;
    objects["Instance121"]["Active"] = false;
    objects["Instance121"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance121"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance121"]["ZIndex"] = 1;
    objects["Instance121"]["BorderSizePixel"] = 0;
    objects["Instance121"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance121"]["Draggable"] = false;
    objects["Instance121"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance121"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance121"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance121"]["Transparency"] = 1;
    objects["Instance121"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance121"]["SelectionOrder"] = 0;
    objects["Instance121"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance121"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance121"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance121"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance121"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance121"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance121"]["Size"] = UDim2.new(0.75, 0, 0.3477204740047455, 0);
    objects["Instance121"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance121"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance121"]["Selectable"] = false;
    objects["Instance121"]["ClipsDescendants"] = true;
    objects["Instance121"]["ScrollBarImageTransparency"] = 0;
    objects["Instance121"]["ScrollBarThickness"] = 0;
    objects["Instance121"]["Parent"] = objects["Instance99"];
    objects["Instance121"]["BackgroundTransparency"] = 1;
    objects["Instance121"]["Rotation"] = 0;
    objects["Instance121"]["LayoutOrder"] = 0;
    objects["Instance121"]["Name"] = "Buttons";
    objects["Instance121"]["Position"] = UDim2.new(0.2500000596046448, 0, 0.625, 0);
    objects["Instance121"]["ScrollingEnabled"] = true;
    objects["Instance121"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance121"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance121"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance122"]["FillDirectionMaxCells"] = 0;
    objects["Instance122"]["CellPadding"] = UDim2.new(0, 0, 0, 0);
    objects["Instance122"]["Parent"] = objects["Instance121"];
    objects["Instance122"]["CellSize"] = UDim2.new(0.3330000042915344, 0, 0.3499999940395355, 0);
    objects["Instance122"]["Name"] = "UIGridLayout";
    objects["Instance122"]["StartCorner"] = Enum.StartCorner.TopLeft;

    objects["Instance123"]["Visible"] = true;
    objects["Instance123"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance123"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance123"]["Active"] = false;
    objects["Instance123"]["TextStrokeTransparency"] = 1;
    objects["Instance123"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance123"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance123"]["ZIndex"] = 1;
    objects["Instance123"]["BorderSizePixel"] = 0;
    objects["Instance123"]["Draggable"] = false;
    objects["Instance123"]["RichText"] = false;
    objects["Instance123"]["Modal"] = false;
    objects["Instance123"]["AutoButtonColor"] = true;
    objects["Instance123"]["Transparency"] = 1;
    objects["Instance123"]["SelectionOrder"] = 0;
    objects["Instance123"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance123"]["TextScaled"] = false;
    objects["Instance123"]["TextWrap"] = false;
    objects["Instance123"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance123"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance123"]["Parent"] = objects["Instance121"];
    objects["Instance123"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance123"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance123"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance123"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance123"]["Selected"] = false;
    objects["Instance123"]["TextSize"] = 14;
    objects["Instance123"]["Size"] = UDim2.new(1, 0, 0.13249999284744263, 0);
    objects["Instance123"]["BackgroundTransparency"] = 1;
    objects["Instance123"]["TextWrapped"] = false;
    objects["Instance123"]["ClipsDescendants"] = false;
    objects["Instance123"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance123"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance123"]["Text"] = "";
    objects["Instance123"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance123"]["LayoutOrder"] = 0;
    objects["Instance123"]["Rotation"] = 0;
    objects["Instance123"]["LineHeight"] = 1;
    objects["Instance123"]["Name"] = "Button";
    objects["Instance123"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance123"]["Selectable"] = false;
    objects["Instance123"]["MaxVisibleGraphemes"] = -1;
    objects["Instance123"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance123"]["TextTransparency"] = 0;

    objects["Instance124"]["LayoutOrder"] = 0;
    objects["Instance124"]["Active"] = false;
    objects["Instance124"]["Parent"] = objects["Instance123"];
    objects["Instance124"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance124"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance124"]["ZIndex"] = 1;
    objects["Instance124"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance124"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.6499999761581421, 0);
    objects["Instance124"]["Draggable"] = false;
    objects["Instance124"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance124"]["ClipsDescendants"] = false;
    objects["Instance124"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance124"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance124"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance124"]["BorderSizePixel"] = 0;
    objects["Instance124"]["Rotation"] = 0;
    objects["Instance124"]["Transparency"] = 0.949999988079071;
    objects["Instance124"]["Name"] = "Contents";
    objects["Instance124"]["SelectionOrder"] = 0;
    objects["Instance124"]["Visible"] = true;
    objects["Instance124"]["Selectable"] = false;
    objects["Instance124"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance124"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance125"]["Enabled"] = true;
    objects["Instance125"]["Transparency"] = 0.5;
    objects["Instance125"]["Name"] = "UIStroke";
    objects["Instance125"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance125"]["Parent"] = objects["Instance124"];
    objects["Instance125"]["Thickness"] = 1;
    objects["Instance125"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance125"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance126"]["LayoutOrder"] = 0;
    objects["Instance126"]["Active"] = false;
    objects["Instance126"]["Parent"] = objects["Instance124"];
    objects["Instance126"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance126"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance126"]["ZIndex"] = 2;
    objects["Instance126"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance126"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance126"]["Draggable"] = false;
    objects["Instance126"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance126"]["ClipsDescendants"] = false;
    objects["Instance126"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance126"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance126"]["BackgroundTransparency"] = 0.25;
    objects["Instance126"]["BorderSizePixel"] = 0;
    objects["Instance126"]["Rotation"] = 0;
    objects["Instance126"]["Transparency"] = 0.25;
    objects["Instance126"]["Name"] = "Frame";
    objects["Instance126"]["SelectionOrder"] = 0;
    objects["Instance126"]["Visible"] = true;
    objects["Instance126"]["Selectable"] = false;
    objects["Instance126"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance126"]["BackgroundColor3"] = Color3.new(0, 0.333333, 0.498039);

    objects["Instance127"]["Visible"] = true;
    objects["Instance127"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance127"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance127"]["Active"] = false;
    objects["Instance127"]["TextStrokeTransparency"] = 1;
    objects["Instance127"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance127"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance127"]["ZIndex"] = 2;
    objects["Instance127"]["BorderSizePixel"] = 0;
    objects["Instance127"]["Draggable"] = false;
    objects["Instance127"]["RichText"] = false;
    objects["Instance127"]["Transparency"] = 1;
    objects["Instance127"]["SelectionOrder"] = 0;
    objects["Instance127"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance127"]["TextScaled"] = true;
    objects["Instance127"]["TextWrap"] = true;
    objects["Instance127"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance127"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance127"]["Parent"] = objects["Instance124"];
    objects["Instance127"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance127"]["TextSize"] = 14;
    objects["Instance127"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance127"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance127"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance127"]["BackgroundTransparency"] = 1;
    objects["Instance127"]["LineHeight"] = 1;
    objects["Instance127"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance127"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance127"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance127"]["Text"] = "Button";
    objects["Instance127"]["LayoutOrder"] = 0;
    objects["Instance127"]["TextWrapped"] = true;
    objects["Instance127"]["Rotation"] = 0;
    objects["Instance127"]["TextTransparency"] = 0;
    objects["Instance127"]["Name"] = "Label";
    objects["Instance127"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance127"]["ClipsDescendants"] = false;
    objects["Instance127"]["MaxVisibleGraphemes"] = -1;
    objects["Instance127"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance127"]["Selectable"] = false;

    objects["Instance128"]["LayoutOrder"] = 0;
    objects["Instance128"]["Active"] = false;
    objects["Instance128"]["Parent"] = objects["Instance124"];
    objects["Instance128"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance128"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance128"]["ZIndex"] = 1;
    objects["Instance128"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance128"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance128"]["Draggable"] = false;
    objects["Instance128"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance128"]["ClipsDescendants"] = false;
    objects["Instance128"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance128"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance128"]["BackgroundTransparency"] = 1;
    objects["Instance128"]["BorderSizePixel"] = 0;
    objects["Instance128"]["Rotation"] = 0;
    objects["Instance128"]["Transparency"] = 1;
    objects["Instance128"]["Name"] = "Selection";
    objects["Instance128"]["SelectionOrder"] = 0;
    objects["Instance128"]["Visible"] = true;
    objects["Instance128"]["Selectable"] = false;
    objects["Instance128"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance128"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance129"]["LayoutOrder"] = 0;
    objects["Instance129"]["Active"] = false;
    objects["Instance129"]["Parent"] = objects["Instance123"];
    objects["Instance129"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance129"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance129"]["ZIndex"] = 1;
    objects["Instance129"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance129"]["Size"] = UDim2.new(0.800000011920929, 0, 0, 1);
    objects["Instance129"]["Draggable"] = false;
    objects["Instance129"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance129"]["ClipsDescendants"] = false;
    objects["Instance129"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance129"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance129"]["BackgroundTransparency"] = 0.5;
    objects["Instance129"]["BorderSizePixel"] = 0;
    objects["Instance129"]["Rotation"] = 0;
    objects["Instance129"]["Transparency"] = 0.5;
    objects["Instance129"]["Name"] = "Separator";
    objects["Instance129"]["SelectionOrder"] = 0;
    objects["Instance129"]["Visible"] = false;
    objects["Instance129"]["Selectable"] = false;
    objects["Instance129"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance129"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance130"]["Visible"] = false;
    objects["Instance130"]["Active"] = true;
    objects["Instance130"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance130"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance130"]["ZIndex"] = 1;
    objects["Instance130"]["BorderSizePixel"] = 0;
    objects["Instance130"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance130"]["Draggable"] = false;
    objects["Instance130"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance130"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance130"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance130"]["Transparency"] = 1;
    objects["Instance130"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance130"]["SelectionOrder"] = 0;
    objects["Instance130"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance130"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance130"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance130"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance130"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance130"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance130"]["Size"] = UDim2.new(1, 0, 0.949999988079071, 0);
    objects["Instance130"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance130"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance130"]["Selectable"] = true;
    objects["Instance130"]["ClipsDescendants"] = true;
    objects["Instance130"]["ScrollBarImageTransparency"] = 0.6000000238418579;
    objects["Instance130"]["ScrollBarThickness"] = 6;
    objects["Instance130"]["Parent"] = objects["Instance83"];
    objects["Instance130"]["BackgroundTransparency"] = 1;
    objects["Instance130"]["Rotation"] = 0;
    objects["Instance130"]["LayoutOrder"] = 0;
    objects["Instance130"]["Name"] = "Settings";
    objects["Instance130"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance130"]["ScrollingEnabled"] = true;
    objects["Instance130"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance130"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance130"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance131"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance131"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance131"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance131"]["Parent"] = objects["Instance130"];
    objects["Instance131"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance131"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance131"]["Name"] = "UIListLayout";
    objects["Instance131"]["Padding"] = UDim.new(0, 0);
    objects["Instance131"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance131"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance132"]["Visible"] = true;
    objects["Instance132"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance132"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance132"]["Active"] = true;
    objects["Instance132"]["TextStrokeTransparency"] = 1;
    objects["Instance132"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance132"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance132"]["ZIndex"] = 1;
    objects["Instance132"]["BorderSizePixel"] = 0;
    objects["Instance132"]["Draggable"] = false;
    objects["Instance132"]["RichText"] = false;
    objects["Instance132"]["Modal"] = false;
    objects["Instance132"]["AutoButtonColor"] = false;
    objects["Instance132"]["Transparency"] = 1;
    objects["Instance132"]["SelectionOrder"] = 0;
    objects["Instance132"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance132"]["TextScaled"] = false;
    objects["Instance132"]["TextWrap"] = false;
    objects["Instance132"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance132"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance132"]["Parent"] = objects["Instance130"];
    objects["Instance132"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance132"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance132"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance132"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance132"]["Selected"] = false;
    objects["Instance132"]["TextSize"] = 14;
    objects["Instance132"]["Size"] = UDim2.new(1, 0, 0.10999999940395355, 0);
    objects["Instance132"]["BackgroundTransparency"] = 1;
    objects["Instance132"]["TextWrapped"] = false;
    objects["Instance132"]["ClipsDescendants"] = false;
    objects["Instance132"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance132"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance132"]["Text"] = "";
    objects["Instance132"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance132"]["LayoutOrder"] = 0;
    objects["Instance132"]["Rotation"] = 0;
    objects["Instance132"]["LineHeight"] = 1;
    objects["Instance132"]["Name"] = "boolean";
    objects["Instance132"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance132"]["Selectable"] = true;
    objects["Instance132"]["MaxVisibleGraphemes"] = -1;
    objects["Instance132"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance132"]["TextTransparency"] = 0;

    objects["Instance133"]["LayoutOrder"] = 0;
    objects["Instance133"]["Active"] = false;
    objects["Instance133"]["Parent"] = objects["Instance132"];
    objects["Instance133"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance133"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance133"]["ZIndex"] = 1;
    objects["Instance133"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance133"]["Size"] = UDim2.new(1, 0, 0.5, 0);
    objects["Instance133"]["Draggable"] = false;
    objects["Instance133"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance133"]["ClipsDescendants"] = false;
    objects["Instance133"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance133"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance133"]["BackgroundTransparency"] = 0;
    objects["Instance133"]["BorderSizePixel"] = 0;
    objects["Instance133"]["Rotation"] = 0;
    objects["Instance133"]["Transparency"] = 0;
    objects["Instance133"]["Name"] = "State";
    objects["Instance133"]["SelectionOrder"] = 0;
    objects["Instance133"]["Visible"] = true;
    objects["Instance133"]["Selectable"] = false;
    objects["Instance133"]["Position"] = UDim2.new(0.949999988079071, 0, 0.5, 0);
    objects["Instance133"]["BackgroundColor3"] = Color3.new(0.196078, 0.196078, 0.196078);

    objects["Instance134"]["Parent"] = objects["Instance133"];
    objects["Instance134"]["Name"] = "UICorner";
    objects["Instance134"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance135"]["AspectRatio"] = 2;
    objects["Instance135"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance135"]["Parent"] = objects["Instance133"];
    objects["Instance135"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance135"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance136"]["PaddingTop"] = UDim.new(0.150000006, 0);
    objects["Instance136"]["Name"] = "UIPadding";
    objects["Instance136"]["Parent"] = objects["Instance133"];
    objects["Instance136"]["PaddingBottom"] = UDim.new(0.150000006, 0);
    objects["Instance136"]["PaddingLeft"] = UDim.new(0.100000001, 0);
    objects["Instance136"]["PaddingRight"] = UDim.new(0.100000001, 0);

    objects["Instance137"]["LayoutOrder"] = 0;
    objects["Instance137"]["Active"] = false;
    objects["Instance137"]["Parent"] = objects["Instance133"];
    objects["Instance137"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance137"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance137"]["ZIndex"] = 1;
    objects["Instance137"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance137"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance137"]["Draggable"] = false;
    objects["Instance137"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance137"]["ClipsDescendants"] = false;
    objects["Instance137"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance137"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance137"]["BackgroundTransparency"] = 0;
    objects["Instance137"]["BorderSizePixel"] = 0;
    objects["Instance137"]["Rotation"] = 0;
    objects["Instance137"]["Transparency"] = 0;
    objects["Instance137"]["Name"] = "State";
    objects["Instance137"]["SelectionOrder"] = 0;
    objects["Instance137"]["Visible"] = true;
    objects["Instance137"]["Selectable"] = false;
    objects["Instance137"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance137"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance138"]["AspectRatio"] = 1;
    objects["Instance138"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance138"]["Parent"] = objects["Instance137"];
    objects["Instance138"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance138"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance139"]["Parent"] = objects["Instance137"];
    objects["Instance139"]["Name"] = "UICorner";
    objects["Instance139"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance140"]["Visible"] = true;
    objects["Instance140"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance140"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance140"]["Active"] = false;
    objects["Instance140"]["TextStrokeTransparency"] = 1;
    objects["Instance140"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance140"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance140"]["ZIndex"] = 1;
    objects["Instance140"]["BorderSizePixel"] = 0;
    objects["Instance140"]["Draggable"] = false;
    objects["Instance140"]["RichText"] = false;
    objects["Instance140"]["Transparency"] = 1;
    objects["Instance140"]["SelectionOrder"] = 0;
    objects["Instance140"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance140"]["TextScaled"] = true;
    objects["Instance140"]["TextWrap"] = true;
    objects["Instance140"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance140"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance140"]["Parent"] = objects["Instance132"];
    objects["Instance140"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance140"]["TextSize"] = 14;
    objects["Instance140"]["Position"] = UDim2.new(0.05000000074505806, 0, 0.5, 0);
    objects["Instance140"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance140"]["Size"] = UDim2.new(0.800000011920929, 0, 0.5, 0);
    objects["Instance140"]["BackgroundTransparency"] = 1;
    objects["Instance140"]["LineHeight"] = 1;
    objects["Instance140"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance140"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance140"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance140"]["Text"] = "Template";
    objects["Instance140"]["LayoutOrder"] = 0;
    objects["Instance140"]["TextWrapped"] = true;
    objects["Instance140"]["Rotation"] = 0;
    objects["Instance140"]["TextTransparency"] = 0;
    objects["Instance140"]["Name"] = "Label";
    objects["Instance140"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance140"]["ClipsDescendants"] = false;
    objects["Instance140"]["MaxVisibleGraphemes"] = -1;
    objects["Instance140"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance140"]["Selectable"] = false;

    objects["Instance141"]["LayoutOrder"] = 0;
    objects["Instance141"]["Active"] = false;
    objects["Instance141"]["Parent"] = objects["Instance132"];
    objects["Instance141"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance141"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance141"]["ZIndex"] = 1;
    objects["Instance141"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance141"]["Size"] = UDim2.new(0.9850000143051147, 0, -0, 1);
    objects["Instance141"]["Draggable"] = false;
    objects["Instance141"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance141"]["ClipsDescendants"] = false;
    objects["Instance141"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance141"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance141"]["BackgroundTransparency"] = 0.5;
    objects["Instance141"]["BorderSizePixel"] = 0;
    objects["Instance141"]["Rotation"] = 0;
    objects["Instance141"]["Transparency"] = 0.5;
    objects["Instance141"]["Name"] = "Frame";
    objects["Instance141"]["SelectionOrder"] = 0;
    objects["Instance141"]["Visible"] = true;
    objects["Instance141"]["Selectable"] = false;
    objects["Instance141"]["Position"] = UDim2.new(0, 0, 0, -1);
    objects["Instance141"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance142"]["LayoutOrder"] = 0;
    objects["Instance142"]["Active"] = true;
    objects["Instance142"]["Parent"] = objects["Instance130"];
    objects["Instance142"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance142"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance142"]["ZIndex"] = 1;
    objects["Instance142"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance142"]["Size"] = UDim2.new(1, 0, 0.10999999940395355, 0);
    objects["Instance142"]["Draggable"] = false;
    objects["Instance142"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance142"]["ClipsDescendants"] = false;
    objects["Instance142"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance142"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance142"]["BackgroundTransparency"] = 1;
    objects["Instance142"]["BorderSizePixel"] = 0;
    objects["Instance142"]["Rotation"] = 0;
    objects["Instance142"]["Transparency"] = 1;
    objects["Instance142"]["Name"] = "table";
    objects["Instance142"]["SelectionOrder"] = 0;
    objects["Instance142"]["Visible"] = true;
    objects["Instance142"]["Selectable"] = true;
    objects["Instance142"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance142"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);

    objects["Instance143"]["LayoutOrder"] = 0;
    objects["Instance143"]["Active"] = false;
    objects["Instance143"]["Parent"] = objects["Instance142"];
    objects["Instance143"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance143"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance143"]["ZIndex"] = 1;
    objects["Instance143"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance143"]["Size"] = UDim2.new(1, 0, 0.10000000149011612, 0);
    objects["Instance143"]["Draggable"] = false;
    objects["Instance143"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance143"]["ClipsDescendants"] = false;
    objects["Instance143"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance143"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance143"]["BackgroundTransparency"] = 0;
    objects["Instance143"]["BorderSizePixel"] = 0;
    objects["Instance143"]["Rotation"] = 0;
    objects["Instance143"]["Transparency"] = 0;
    objects["Instance143"]["Name"] = "State";
    objects["Instance143"]["SelectionOrder"] = 0;
    objects["Instance143"]["Visible"] = true;
    objects["Instance143"]["Selectable"] = false;
    objects["Instance143"]["Position"] = UDim2.new(0.949999988079071, 0, 0.5, 0);
    objects["Instance143"]["BackgroundColor3"] = Color3.new(0.196078, 0.196078, 0.196078);

    objects["Instance144"]["Parent"] = objects["Instance143"];
    objects["Instance144"]["Name"] = "UICorner";
    objects["Instance144"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance145"]["AspectRatio"] = 40;
    objects["Instance145"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance145"]["Parent"] = objects["Instance143"];
    objects["Instance145"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance145"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance146"]["LayoutOrder"] = 0;
    objects["Instance146"]["Active"] = false;
    objects["Instance146"]["Parent"] = objects["Instance143"];
    objects["Instance146"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance146"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance146"]["ZIndex"] = 2;
    objects["Instance146"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance146"]["Size"] = UDim2.new(0.05000000074505806, 0, 5, 0);
    objects["Instance146"]["Draggable"] = false;
    objects["Instance146"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance146"]["ClipsDescendants"] = false;
    objects["Instance146"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance146"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance146"]["BackgroundTransparency"] = 0;
    objects["Instance146"]["BorderSizePixel"] = 0;
    objects["Instance146"]["Rotation"] = 0;
    objects["Instance146"]["Transparency"] = 0;
    objects["Instance146"]["Name"] = "Pointer";
    objects["Instance146"]["SelectionOrder"] = 0;
    objects["Instance146"]["Visible"] = true;
    objects["Instance146"]["Selectable"] = false;
    objects["Instance146"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance146"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance147"]["Parent"] = objects["Instance146"];
    objects["Instance147"]["Name"] = "UICorner";
    objects["Instance147"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance148"]["LayoutOrder"] = 0;
    objects["Instance148"]["Active"] = false;
    objects["Instance148"]["Parent"] = objects["Instance143"];
    objects["Instance148"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance148"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance148"]["ZIndex"] = 1;
    objects["Instance148"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance148"]["Size"] = UDim2.new(0.5, 0, 1, 0);
    objects["Instance148"]["Draggable"] = false;
    objects["Instance148"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance148"]["ClipsDescendants"] = false;
    objects["Instance148"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance148"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance148"]["BackgroundTransparency"] = 0;
    objects["Instance148"]["BorderSizePixel"] = 0;
    objects["Instance148"]["Rotation"] = 0;
    objects["Instance148"]["Transparency"] = 0;
    objects["Instance148"]["Name"] = "Fill";
    objects["Instance148"]["SelectionOrder"] = 0;
    objects["Instance148"]["Visible"] = true;
    objects["Instance148"]["Selectable"] = false;
    objects["Instance148"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance148"]["BackgroundColor3"] = Color3.new(0.588235, 0.588235, 0.588235);

    objects["Instance149"]["Parent"] = objects["Instance148"];
    objects["Instance149"]["Name"] = "UICorner";
    objects["Instance149"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance150"]["Visible"] = true;
    objects["Instance150"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance150"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance150"]["Active"] = false;
    objects["Instance150"]["TextStrokeTransparency"] = 1;
    objects["Instance150"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance150"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance150"]["ZIndex"] = 1;
    objects["Instance150"]["BorderSizePixel"] = 0;
    objects["Instance150"]["Draggable"] = false;
    objects["Instance150"]["RichText"] = false;
    objects["Instance150"]["Transparency"] = 1;
    objects["Instance150"]["SelectionOrder"] = 0;
    objects["Instance150"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance150"]["TextScaled"] = true;
    objects["Instance150"]["TextWrap"] = true;
    objects["Instance150"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance150"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance150"]["Parent"] = objects["Instance142"];
    objects["Instance150"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance150"]["TextSize"] = 14;
    objects["Instance150"]["Position"] = UDim2.new(0.05000000074505806, 0, 0.5, 0);
    objects["Instance150"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance150"]["Size"] = UDim2.new(0.800000011920929, 0, 0.5, 0);
    objects["Instance150"]["BackgroundTransparency"] = 1;
    objects["Instance150"]["LineHeight"] = 1;
    objects["Instance150"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance150"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance150"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance150"]["Text"] = "Template";
    objects["Instance150"]["LayoutOrder"] = 0;
    objects["Instance150"]["TextWrapped"] = true;
    objects["Instance150"]["Rotation"] = 0;
    objects["Instance150"]["TextTransparency"] = 0;
    objects["Instance150"]["Name"] = "Label";
    objects["Instance150"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance150"]["ClipsDescendants"] = false;
    objects["Instance150"]["MaxVisibleGraphemes"] = -1;
    objects["Instance150"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance150"]["Selectable"] = false;

    objects["Instance151"]["LayoutOrder"] = 0;
    objects["Instance151"]["Active"] = false;
    objects["Instance151"]["Parent"] = objects["Instance142"];
    objects["Instance151"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance151"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance151"]["ZIndex"] = 1;
    objects["Instance151"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance151"]["Size"] = UDim2.new(0.9850000143051147, 0, -0, 1);
    objects["Instance151"]["Draggable"] = false;
    objects["Instance151"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance151"]["ClipsDescendants"] = false;
    objects["Instance151"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance151"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance151"]["BackgroundTransparency"] = 0.5;
    objects["Instance151"]["BorderSizePixel"] = 0;
    objects["Instance151"]["Rotation"] = 0;
    objects["Instance151"]["Transparency"] = 0.5;
    objects["Instance151"]["Name"] = "Frame";
    objects["Instance151"]["SelectionOrder"] = 0;
    objects["Instance151"]["Visible"] = true;
    objects["Instance151"]["Selectable"] = false;
    objects["Instance151"]["Position"] = UDim2.new(0, 0, 0, -1);
    objects["Instance151"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance152"]["Visible"] = true;
    objects["Instance152"]["FontSize"] = Enum.FontSize.Size8;
    objects["Instance152"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance152"]["Active"] = false;
    objects["Instance152"]["TextStrokeTransparency"] = 1;
    objects["Instance152"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance152"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance152"]["ZIndex"] = 1;
    objects["Instance152"]["BorderSizePixel"] = 0;
    objects["Instance152"]["Draggable"] = false;
    objects["Instance152"]["RichText"] = false;
    objects["Instance152"]["Modal"] = false;
    objects["Instance152"]["AutoButtonColor"] = false;
    objects["Instance152"]["Transparency"] = 1;
    objects["Instance152"]["SelectionOrder"] = 0;
    objects["Instance152"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance152"]["TextScaled"] = false;
    objects["Instance152"]["TextWrap"] = false;
    objects["Instance152"]["FontFace"] = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance152"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance152"]["Parent"] = objects["Instance142"];
    objects["Instance152"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance152"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance152"]["Position"] = UDim2.new(0.949999988079071, 0, 0.5, 0);
    objects["Instance152"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance152"]["Selected"] = false;
    objects["Instance152"]["TextSize"] = 8;
    objects["Instance152"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance152"]["BackgroundTransparency"] = 1;
    objects["Instance152"]["TextWrapped"] = false;
    objects["Instance152"]["ClipsDescendants"] = false;
    objects["Instance152"]["TextColor3"] = Color3.new(0.105882, 0.164706, 0.207843);
    objects["Instance152"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance152"]["Text"] = "";
    objects["Instance152"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance152"]["LayoutOrder"] = 0;
    objects["Instance152"]["Rotation"] = 0;
    objects["Instance152"]["LineHeight"] = 1;
    objects["Instance152"]["Name"] = "Hitbox";
    objects["Instance152"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance152"]["Selectable"] = false;
    objects["Instance152"]["MaxVisibleGraphemes"] = -1;
    objects["Instance152"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance152"]["TextTransparency"] = 0;

    objects["Instance153"]["AspectRatio"] = 8;
    objects["Instance153"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance153"]["Parent"] = objects["Instance152"];
    objects["Instance153"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance153"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance154"]["LayoutOrder"] = 0;
    objects["Instance154"]["Active"] = true;
    objects["Instance154"]["Parent"] = objects["Instance130"];
    objects["Instance154"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance154"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance154"]["ZIndex"] = 1;
    objects["Instance154"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance154"]["Size"] = UDim2.new(1, 0, 0.03999999910593033, 0);
    objects["Instance154"]["Draggable"] = false;
    objects["Instance154"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance154"]["ClipsDescendants"] = false;
    objects["Instance154"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance154"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance154"]["BackgroundTransparency"] = 1;
    objects["Instance154"]["BorderSizePixel"] = 0;
    objects["Instance154"]["Rotation"] = 0;
    objects["Instance154"]["Transparency"] = 1;
    objects["Instance154"]["Name"] = "Separator";
    objects["Instance154"]["SelectionOrder"] = 0;
    objects["Instance154"]["Visible"] = true;
    objects["Instance154"]["Selectable"] = true;
    objects["Instance154"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance154"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);

    objects["Instance155"]["Visible"] = true;
    objects["Instance155"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance155"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance155"]["Active"] = false;
    objects["Instance155"]["TextStrokeTransparency"] = 1;
    objects["Instance155"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance155"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance155"]["ZIndex"] = 1;
    objects["Instance155"]["BorderSizePixel"] = 0;
    objects["Instance155"]["Draggable"] = false;
    objects["Instance155"]["RichText"] = false;
    objects["Instance155"]["Transparency"] = 1;
    objects["Instance155"]["SelectionOrder"] = 0;
    objects["Instance155"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance155"]["TextScaled"] = true;
    objects["Instance155"]["TextWrap"] = true;
    objects["Instance155"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance155"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance155"]["Parent"] = objects["Instance154"];
    objects["Instance155"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance155"]["TextSize"] = 14;
    objects["Instance155"]["Position"] = UDim2.new(0.05000000074505806, 0, 0.5, 0);
    objects["Instance155"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance155"]["Size"] = UDim2.new(0.800000011920929, 0, 1, 0);
    objects["Instance155"]["BackgroundTransparency"] = 1;
    objects["Instance155"]["LineHeight"] = 1;
    objects["Instance155"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance155"]["TextColor3"] = Color3.new(0.392157, 0.392157, 0.392157);
    objects["Instance155"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance155"]["Text"] = "Template";
    objects["Instance155"]["LayoutOrder"] = 0;
    objects["Instance155"]["TextWrapped"] = true;
    objects["Instance155"]["Rotation"] = 0;
    objects["Instance155"]["TextTransparency"] = 0;
    objects["Instance155"]["Name"] = "Label";
    objects["Instance155"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance155"]["ClipsDescendants"] = false;
    objects["Instance155"]["MaxVisibleGraphemes"] = -1;
    objects["Instance155"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance155"]["Selectable"] = false;

    objects["Instance156"]["LayoutOrder"] = 0;
    objects["Instance156"]["Active"] = false;
    objects["Instance156"]["Parent"] = objects["Instance154"];
    objects["Instance156"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance156"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance156"]["ZIndex"] = 1;
    objects["Instance156"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance156"]["Size"] = UDim2.new(0.03500000014901161, 0, 0, 1);
    objects["Instance156"]["Draggable"] = false;
    objects["Instance156"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance156"]["ClipsDescendants"] = false;
    objects["Instance156"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance156"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance156"]["BackgroundTransparency"] = 0.5;
    objects["Instance156"]["BorderSizePixel"] = 0;
    objects["Instance156"]["Rotation"] = 0;
    objects["Instance156"]["Transparency"] = 0.5;
    objects["Instance156"]["Name"] = "FrameLeft";
    objects["Instance156"]["SelectionOrder"] = 0;
    objects["Instance156"]["Visible"] = true;
    objects["Instance156"]["Selectable"] = false;
    objects["Instance156"]["Position"] = UDim2.new(0, 0, 0.5, -1);
    objects["Instance156"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance157"]["LayoutOrder"] = 0;
    objects["Instance157"]["Active"] = false;
    objects["Instance157"]["Parent"] = objects["Instance154"];
    objects["Instance157"]["AnchorPoint"] = Vector2.new(1, 0.5);
    objects["Instance157"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance157"]["ZIndex"] = 1;
    objects["Instance157"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance157"]["Size"] = UDim2.new(0.9399999976158142, 0, 0, 1);
    objects["Instance157"]["Draggable"] = false;
    objects["Instance157"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance157"]["ClipsDescendants"] = false;
    objects["Instance157"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance157"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance157"]["BackgroundTransparency"] = 0.5;
    objects["Instance157"]["BorderSizePixel"] = 0;
    objects["Instance157"]["Rotation"] = 0;
    objects["Instance157"]["Transparency"] = 0.5;
    objects["Instance157"]["Name"] = "FrameRight";
    objects["Instance157"]["SelectionOrder"] = 0;
    objects["Instance157"]["Visible"] = false;
    objects["Instance157"]["Selectable"] = false;
    objects["Instance157"]["Position"] = UDim2.new(0.9850000143051147, 0, 0.5, -1);
    objects["Instance157"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance158"]["LayoutOrder"] = 0;
    objects["Instance158"]["Active"] = false;
    objects["Instance158"]["Parent"] = objects["Instance83"];
    objects["Instance158"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance158"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance158"]["ZIndex"] = 1;
    objects["Instance158"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance158"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance158"]["Draggable"] = false;
    objects["Instance158"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance158"]["ClipsDescendants"] = false;
    objects["Instance158"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance158"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance158"]["BackgroundTransparency"] = 1;
    objects["Instance158"]["BorderSizePixel"] = 0;
    objects["Instance158"]["Rotation"] = 0;
    objects["Instance158"]["Transparency"] = 1;
    objects["Instance158"]["Name"] = "Home";
    objects["Instance158"]["SelectionOrder"] = 0;
    objects["Instance158"]["Visible"] = false;
    objects["Instance158"]["Selectable"] = false;
    objects["Instance158"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance158"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance159"]["Visible"] = true;
    objects["Instance159"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance159"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance159"]["Active"] = false;
    objects["Instance159"]["TextStrokeTransparency"] = 1;
    objects["Instance159"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance159"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance159"]["ZIndex"] = 1;
    objects["Instance159"]["BorderSizePixel"] = 0;
    objects["Instance159"]["Draggable"] = false;
    objects["Instance159"]["RichText"] = false;
    objects["Instance159"]["Transparency"] = 1;
    objects["Instance159"]["SelectionOrder"] = 0;
    objects["Instance159"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance159"]["TextScaled"] = true;
    objects["Instance159"]["TextWrap"] = true;
    objects["Instance159"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance159"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance159"]["Parent"] = objects["Instance158"];
    objects["Instance159"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance159"]["TextSize"] = 14;
    objects["Instance159"]["Position"] = UDim2.new(0, 0, 0.012500000186264515, 0);
    objects["Instance159"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance159"]["Size"] = UDim2.new(1, 0, 0.15000000596046448, 0);
    objects["Instance159"]["BackgroundTransparency"] = 1;
    objects["Instance159"]["LineHeight"] = 1;
    objects["Instance159"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance159"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance159"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance159"]["Text"] = "CHANGELOGS";
    objects["Instance159"]["LayoutOrder"] = 0;
    objects["Instance159"]["TextWrapped"] = true;
    objects["Instance159"]["Rotation"] = 0;
    objects["Instance159"]["TextTransparency"] = 0;
    objects["Instance159"]["Name"] = "Title";
    objects["Instance159"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance159"]["ClipsDescendants"] = false;
    objects["Instance159"]["MaxVisibleGraphemes"] = -1;
    objects["Instance159"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance159"]["Selectable"] = false;

    objects["Instance160"]["LayoutOrder"] = 0;
    objects["Instance160"]["Active"] = false;
    objects["Instance160"]["Parent"] = objects["Instance159"];
    objects["Instance160"]["AnchorPoint"] = Vector2.new(0, 1);
    objects["Instance160"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance160"]["ZIndex"] = 1;
    objects["Instance160"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance160"]["Size"] = UDim2.new(0.9843750596046448, 0, 0, 1);
    objects["Instance160"]["Draggable"] = false;
    objects["Instance160"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance160"]["ClipsDescendants"] = false;
    objects["Instance160"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance160"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance160"]["BackgroundTransparency"] = 0.5;
    objects["Instance160"]["BorderSizePixel"] = 0;
    objects["Instance160"]["Rotation"] = 0;
    objects["Instance160"]["Transparency"] = 0.5;
    objects["Instance160"]["Name"] = "Separator";
    objects["Instance160"]["SelectionOrder"] = 0;
    objects["Instance160"]["Visible"] = true;
    objects["Instance160"]["Selectable"] = false;
    objects["Instance160"]["Position"] = UDim2.new(8.915343840953938e-08, 0, 1.100000023841858, 0);
    objects["Instance160"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance161"]["Visible"] = true;
    objects["Instance161"]["Active"] = true;
    objects["Instance161"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance161"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance161"]["ZIndex"] = 1;
    objects["Instance161"]["BorderSizePixel"] = 0;
    objects["Instance161"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance161"]["Draggable"] = false;
    objects["Instance161"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance161"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance161"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance161"]["Transparency"] = 1;
    objects["Instance161"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance161"]["SelectionOrder"] = 0;
    objects["Instance161"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance161"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance161"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance161"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance161"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance161"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance161"]["Size"] = UDim2.new(0.964375376701355, 0, 0.7900001406669617, 0);
    objects["Instance161"]["ScrollBarImageColor3"] = Color3.new(0, 0, 0);
    objects["Instance161"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance161"]["Selectable"] = true;
    objects["Instance161"]["ClipsDescendants"] = true;
    objects["Instance161"]["ScrollBarImageTransparency"] = 0;
    objects["Instance161"]["ScrollBarThickness"] = 0;
    objects["Instance161"]["Parent"] = objects["Instance158"];
    objects["Instance161"]["BackgroundTransparency"] = 1;
    objects["Instance161"]["Rotation"] = 0;
    objects["Instance161"]["LayoutOrder"] = 0;
    objects["Instance161"]["Name"] = "Changelogs";
    objects["Instance161"]["Position"] = UDim2.new(0.019999969750642776, 0, 0.1900000125169754, 0);
    objects["Instance161"]["ScrollingEnabled"] = true;
    objects["Instance161"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance161"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance161"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance162"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance162"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance162"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance162"]["Parent"] = objects["Instance161"];
    objects["Instance162"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance162"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance162"]["Name"] = "UIListLayout";
    objects["Instance162"]["Padding"] = UDim.new(0, 6);
    objects["Instance162"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance162"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance163"]["Visible"] = false;
    objects["Instance163"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance163"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance163"]["Active"] = false;
    objects["Instance163"]["TextStrokeTransparency"] = 1;
    objects["Instance163"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance163"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance163"]["ZIndex"] = 1;
    objects["Instance163"]["BorderSizePixel"] = 0;
    objects["Instance163"]["Draggable"] = false;
    objects["Instance163"]["RichText"] = true;
    objects["Instance163"]["Transparency"] = 1;
    objects["Instance163"]["SelectionOrder"] = 0;
    objects["Instance163"]["TextYAlignment"] = Enum.TextYAlignment.Top;
    objects["Instance163"]["TextScaled"] = false;
    objects["Instance163"]["TextWrap"] = true;
    objects["Instance163"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance163"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance163"]["Parent"] = objects["Instance161"];
    objects["Instance163"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance163"]["TextSize"] = 14;
    objects["Instance163"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance163"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance163"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance163"]["BackgroundTransparency"] = 1;
    objects["Instance163"]["LineHeight"] = 1;
    objects["Instance163"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance163"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance163"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance163"]["Text"] = "<b>UPDATE 1.3 --</b> Added changelogs & memory scanner";
    objects["Instance163"]["LayoutOrder"] = 0;
    objects["Instance163"]["TextWrapped"] = true;
    objects["Instance163"]["Rotation"] = 0;
    objects["Instance163"]["TextTransparency"] = 0;
    objects["Instance163"]["Name"] = "Log";
    objects["Instance163"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance163"]["ClipsDescendants"] = false;
    objects["Instance163"]["MaxVisibleGraphemes"] = -1;
    objects["Instance163"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance163"]["Selectable"] = false;

    objects["Instance164"]["LayoutOrder"] = 0;
    objects["Instance164"]["Active"] = false;
    objects["Instance164"]["Parent"] = objects["Instance83"];
    objects["Instance164"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance164"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance164"]["ZIndex"] = 1;
    objects["Instance164"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance164"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance164"]["Draggable"] = false;
    objects["Instance164"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance164"]["ClipsDescendants"] = false;
    objects["Instance164"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance164"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance164"]["BackgroundTransparency"] = 1;
    objects["Instance164"]["BorderSizePixel"] = 0;
    objects["Instance164"]["Rotation"] = 0;
    objects["Instance164"]["Transparency"] = 1;
    objects["Instance164"]["Name"] = "ESpy";
    objects["Instance164"]["SelectionOrder"] = 0;
    objects["Instance164"]["Visible"] = false;
    objects["Instance164"]["Selectable"] = false;
    objects["Instance164"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance164"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance165"]["Visible"] = true;
    objects["Instance165"]["Active"] = false;
    objects["Instance165"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance165"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance165"]["ZIndex"] = 1;
    objects["Instance165"]["BorderSizePixel"] = 0;
    objects["Instance165"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance165"]["Draggable"] = false;
    objects["Instance165"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance165"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance165"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance165"]["Transparency"] = 1;
    objects["Instance165"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance165"]["SelectionOrder"] = 0;
    objects["Instance165"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance165"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance165"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance165"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance165"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance165"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance165"]["Size"] = UDim2.new(0.75, 0, 0.3477204740047455, 0);
    objects["Instance165"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance165"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance165"]["Selectable"] = false;
    objects["Instance165"]["ClipsDescendants"] = true;
    objects["Instance165"]["ScrollBarImageTransparency"] = 0;
    objects["Instance165"]["ScrollBarThickness"] = 0;
    objects["Instance165"]["Parent"] = objects["Instance164"];
    objects["Instance165"]["BackgroundTransparency"] = 1;
    objects["Instance165"]["Rotation"] = 0;
    objects["Instance165"]["LayoutOrder"] = 0;
    objects["Instance165"]["Name"] = "Buttons";
    objects["Instance165"]["Position"] = UDim2.new(0.2500000596046448, 0, 0.625, 0);
    objects["Instance165"]["ScrollingEnabled"] = true;
    objects["Instance165"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance165"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance165"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance166"]["FillDirectionMaxCells"] = 0;
    objects["Instance166"]["CellPadding"] = UDim2.new(0, 0, 0, 0);
    objects["Instance166"]["Parent"] = objects["Instance165"];
    objects["Instance166"]["CellSize"] = UDim2.new(0.3330000042915344, 0, 0.33000001311302185, 0);
    objects["Instance166"]["Name"] = "UIGridLayout";
    objects["Instance166"]["StartCorner"] = Enum.StartCorner.TopLeft;

    objects["Instance167"]["Visible"] = true;
    objects["Instance167"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance167"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance167"]["Active"] = false;
    objects["Instance167"]["TextStrokeTransparency"] = 1;
    objects["Instance167"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance167"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance167"]["ZIndex"] = 1;
    objects["Instance167"]["BorderSizePixel"] = 0;
    objects["Instance167"]["Draggable"] = false;
    objects["Instance167"]["RichText"] = false;
    objects["Instance167"]["Modal"] = false;
    objects["Instance167"]["AutoButtonColor"] = true;
    objects["Instance167"]["Transparency"] = 1;
    objects["Instance167"]["SelectionOrder"] = 0;
    objects["Instance167"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance167"]["TextScaled"] = false;
    objects["Instance167"]["TextWrap"] = false;
    objects["Instance167"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance167"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance167"]["Parent"] = objects["Instance165"];
    objects["Instance167"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance167"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance167"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance167"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance167"]["Selected"] = false;
    objects["Instance167"]["TextSize"] = 14;
    objects["Instance167"]["Size"] = UDim2.new(1, 0, 0.13249999284744263, 0);
    objects["Instance167"]["BackgroundTransparency"] = 1;
    objects["Instance167"]["TextWrapped"] = false;
    objects["Instance167"]["ClipsDescendants"] = false;
    objects["Instance167"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance167"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance167"]["Text"] = "";
    objects["Instance167"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance167"]["LayoutOrder"] = 0;
    objects["Instance167"]["Rotation"] = 0;
    objects["Instance167"]["LineHeight"] = 1;
    objects["Instance167"]["Name"] = "Button";
    objects["Instance167"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance167"]["Selectable"] = false;
    objects["Instance167"]["MaxVisibleGraphemes"] = -1;
    objects["Instance167"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance167"]["TextTransparency"] = 0;

    objects["Instance168"]["LayoutOrder"] = 0;
    objects["Instance168"]["Active"] = false;
    objects["Instance168"]["Parent"] = objects["Instance167"];
    objects["Instance168"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance168"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance168"]["ZIndex"] = 1;
    objects["Instance168"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance168"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.6499999761581421, 0);
    objects["Instance168"]["Draggable"] = false;
    objects["Instance168"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance168"]["ClipsDescendants"] = false;
    objects["Instance168"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance168"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance168"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance168"]["BorderSizePixel"] = 0;
    objects["Instance168"]["Rotation"] = 0;
    objects["Instance168"]["Transparency"] = 0.949999988079071;
    objects["Instance168"]["Name"] = "Contents";
    objects["Instance168"]["SelectionOrder"] = 0;
    objects["Instance168"]["Visible"] = true;
    objects["Instance168"]["Selectable"] = false;
    objects["Instance168"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance168"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance169"]["Enabled"] = true;
    objects["Instance169"]["Transparency"] = 0.5;
    objects["Instance169"]["Name"] = "UIStroke";
    objects["Instance169"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance169"]["Parent"] = objects["Instance168"];
    objects["Instance169"]["Thickness"] = 1;
    objects["Instance169"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance169"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance170"]["LayoutOrder"] = 0;
    objects["Instance170"]["Active"] = false;
    objects["Instance170"]["Parent"] = objects["Instance168"];
    objects["Instance170"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance170"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance170"]["ZIndex"] = 2;
    objects["Instance170"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance170"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance170"]["Draggable"] = false;
    objects["Instance170"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance170"]["ClipsDescendants"] = false;
    objects["Instance170"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance170"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance170"]["BackgroundTransparency"] = 0.25;
    objects["Instance170"]["BorderSizePixel"] = 0;
    objects["Instance170"]["Rotation"] = 0;
    objects["Instance170"]["Transparency"] = 0.25;
    objects["Instance170"]["Name"] = "Frame";
    objects["Instance170"]["SelectionOrder"] = 0;
    objects["Instance170"]["Visible"] = true;
    objects["Instance170"]["Selectable"] = false;
    objects["Instance170"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance170"]["BackgroundColor3"] = Color3.new(0, 0.333333, 0.498039);

    objects["Instance171"]["Visible"] = true;
    objects["Instance171"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance171"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance171"]["Active"] = false;
    objects["Instance171"]["TextStrokeTransparency"] = 1;
    objects["Instance171"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance171"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance171"]["ZIndex"] = 2;
    objects["Instance171"]["BorderSizePixel"] = 0;
    objects["Instance171"]["Draggable"] = false;
    objects["Instance171"]["RichText"] = false;
    objects["Instance171"]["Transparency"] = 1;
    objects["Instance171"]["SelectionOrder"] = 0;
    objects["Instance171"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance171"]["TextScaled"] = true;
    objects["Instance171"]["TextWrap"] = true;
    objects["Instance171"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance171"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance171"]["Parent"] = objects["Instance168"];
    objects["Instance171"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance171"]["TextSize"] = 14;
    objects["Instance171"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance171"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance171"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance171"]["BackgroundTransparency"] = 1;
    objects["Instance171"]["LineHeight"] = 1;
    objects["Instance171"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance171"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance171"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance171"]["Text"] = "Button";
    objects["Instance171"]["LayoutOrder"] = 0;
    objects["Instance171"]["TextWrapped"] = true;
    objects["Instance171"]["Rotation"] = 0;
    objects["Instance171"]["TextTransparency"] = 0;
    objects["Instance171"]["Name"] = "Label";
    objects["Instance171"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance171"]["ClipsDescendants"] = false;
    objects["Instance171"]["MaxVisibleGraphemes"] = -1;
    objects["Instance171"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance171"]["Selectable"] = false;

    objects["Instance172"]["LayoutOrder"] = 0;
    objects["Instance172"]["Active"] = false;
    objects["Instance172"]["Parent"] = objects["Instance168"];
    objects["Instance172"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance172"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance172"]["ZIndex"] = 1;
    objects["Instance172"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance172"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance172"]["Draggable"] = false;
    objects["Instance172"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance172"]["ClipsDescendants"] = false;
    objects["Instance172"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance172"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance172"]["BackgroundTransparency"] = 1;
    objects["Instance172"]["BorderSizePixel"] = 0;
    objects["Instance172"]["Rotation"] = 0;
    objects["Instance172"]["Transparency"] = 1;
    objects["Instance172"]["Name"] = "Selection";
    objects["Instance172"]["SelectionOrder"] = 0;
    objects["Instance172"]["Visible"] = true;
    objects["Instance172"]["Selectable"] = false;
    objects["Instance172"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance172"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance173"]["LayoutOrder"] = 0;
    objects["Instance173"]["Active"] = false;
    objects["Instance173"]["Parent"] = objects["Instance167"];
    objects["Instance173"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance173"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance173"]["ZIndex"] = 1;
    objects["Instance173"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance173"]["Size"] = UDim2.new(0.800000011920929, 0, 0, 1);
    objects["Instance173"]["Draggable"] = false;
    objects["Instance173"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance173"]["ClipsDescendants"] = false;
    objects["Instance173"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance173"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance173"]["BackgroundTransparency"] = 0.5;
    objects["Instance173"]["BorderSizePixel"] = 0;
    objects["Instance173"]["Rotation"] = 0;
    objects["Instance173"]["Transparency"] = 0.5;
    objects["Instance173"]["Name"] = "Separator";
    objects["Instance173"]["SelectionOrder"] = 0;
    objects["Instance173"]["Visible"] = false;
    objects["Instance173"]["Selectable"] = false;
    objects["Instance173"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance173"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance174"]["LayoutOrder"] = 0;
    objects["Instance174"]["Active"] = false;
    objects["Instance174"]["Parent"] = objects["Instance164"];
    objects["Instance174"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance174"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance174"]["ZIndex"] = 1;
    objects["Instance174"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance174"]["Size"] = UDim2.new(0, 1, 0.9729999899864197, 0);
    objects["Instance174"]["Draggable"] = false;
    objects["Instance174"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance174"]["ClipsDescendants"] = false;
    objects["Instance174"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance174"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance174"]["BackgroundTransparency"] = 0.5;
    objects["Instance174"]["BorderSizePixel"] = 0;
    objects["Instance174"]["Rotation"] = 0;
    objects["Instance174"]["Transparency"] = 0.5;
    objects["Instance174"]["Name"] = "Separator";
    objects["Instance174"]["SelectionOrder"] = 0;
    objects["Instance174"]["Visible"] = true;
    objects["Instance174"]["Selectable"] = false;
    objects["Instance174"]["Position"] = UDim2.new(0.2500000298023224, -1, 0, 0);
    objects["Instance174"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance175"]["Visible"] = true;
    objects["Instance175"]["Active"] = false;
    objects["Instance175"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance175"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance175"]["ZIndex"] = 1;
    objects["Instance175"]["BorderSizePixel"] = 0;
    objects["Instance175"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance175"]["Draggable"] = false;
    objects["Instance175"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance175"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance175"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance175"]["Transparency"] = 1;
    objects["Instance175"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance175"]["SelectionOrder"] = 0;
    objects["Instance175"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance175"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance175"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance175"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance175"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance175"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance175"]["Size"] = UDim2.new(0.25, 0, 0.949999988079071, 1);
    objects["Instance175"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance175"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance175"]["Selectable"] = false;
    objects["Instance175"]["ClipsDescendants"] = true;
    objects["Instance175"]["ScrollBarImageTransparency"] = 0;
    objects["Instance175"]["ScrollBarThickness"] = 0;
    objects["Instance175"]["Parent"] = objects["Instance164"];
    objects["Instance175"]["BackgroundTransparency"] = 1;
    objects["Instance175"]["Rotation"] = 0;
    objects["Instance175"]["LayoutOrder"] = 0;
    objects["Instance175"]["Name"] = "Logs";
    objects["Instance175"]["Position"] = UDim2.new(0, 0, 0.012000000104308128, 0);
    objects["Instance175"]["ScrollingEnabled"] = true;
    objects["Instance175"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance175"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance175"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance176"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance176"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance176"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance176"]["Parent"] = objects["Instance175"];
    objects["Instance176"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance176"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance176"]["Name"] = "UIListLayout";
    objects["Instance176"]["Padding"] = UDim.new(0, 0);
    objects["Instance176"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance176"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance177"]["Visible"] = true;
    objects["Instance177"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance177"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance177"]["Active"] = false;
    objects["Instance177"]["TextStrokeTransparency"] = 1;
    objects["Instance177"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance177"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance177"]["ZIndex"] = 1;
    objects["Instance177"]["BorderSizePixel"] = 0;
    objects["Instance177"]["Draggable"] = false;
    objects["Instance177"]["RichText"] = false;
    objects["Instance177"]["Modal"] = false;
    objects["Instance177"]["AutoButtonColor"] = true;
    objects["Instance177"]["Transparency"] = 1;
    objects["Instance177"]["SelectionOrder"] = 0;
    objects["Instance177"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance177"]["TextScaled"] = false;
    objects["Instance177"]["TextWrap"] = false;
    objects["Instance177"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance177"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance177"]["Parent"] = objects["Instance175"];
    objects["Instance177"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance177"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance177"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance177"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance177"]["Selected"] = false;
    objects["Instance177"]["TextSize"] = 14;
    objects["Instance177"]["Size"] = UDim2.new(1, 0, 0.12200000137090683, 0);
    objects["Instance177"]["BackgroundTransparency"] = 1;
    objects["Instance177"]["TextWrapped"] = false;
    objects["Instance177"]["ClipsDescendants"] = false;
    objects["Instance177"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance177"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance177"]["Text"] = "";
    objects["Instance177"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance177"]["LayoutOrder"] = 0;
    objects["Instance177"]["Rotation"] = 0;
    objects["Instance177"]["LineHeight"] = 1;
    objects["Instance177"]["Name"] = "Log";
    objects["Instance177"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance177"]["Selectable"] = false;
    objects["Instance177"]["MaxVisibleGraphemes"] = -1;
    objects["Instance177"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance177"]["TextTransparency"] = 0;

    objects["Instance178"]["LayoutOrder"] = 0;
    objects["Instance178"]["Active"] = false;
    objects["Instance178"]["Parent"] = objects["Instance177"];
    objects["Instance178"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance178"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance178"]["ZIndex"] = 1;
    objects["Instance178"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance178"]["Size"] = UDim2.new(0.8500000238418579, 0, 0.699999988079071, 0);
    objects["Instance178"]["Draggable"] = false;
    objects["Instance178"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance178"]["ClipsDescendants"] = false;
    objects["Instance178"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance178"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance178"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance178"]["BorderSizePixel"] = 0;
    objects["Instance178"]["Rotation"] = 0;
    objects["Instance178"]["Transparency"] = 0.949999988079071;
    objects["Instance178"]["Name"] = "Contents";
    objects["Instance178"]["SelectionOrder"] = 0;
    objects["Instance178"]["Visible"] = true;
    objects["Instance178"]["Selectable"] = false;
    objects["Instance178"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance178"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance179"]["Enabled"] = true;
    objects["Instance179"]["Transparency"] = 0.5;
    objects["Instance179"]["Name"] = "UIStroke";
    objects["Instance179"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance179"]["Parent"] = objects["Instance178"];
    objects["Instance179"]["Thickness"] = 1;
    objects["Instance179"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance179"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance180"]["LayoutOrder"] = 0;
    objects["Instance180"]["Active"] = false;
    objects["Instance180"]["Parent"] = objects["Instance178"];
    objects["Instance180"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance180"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance180"]["ZIndex"] = 1;
    objects["Instance180"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance180"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance180"]["Draggable"] = false;
    objects["Instance180"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance180"]["ClipsDescendants"] = false;
    objects["Instance180"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance180"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance180"]["BackgroundTransparency"] = 0.25;
    objects["Instance180"]["BorderSizePixel"] = 0;
    objects["Instance180"]["Rotation"] = 0;
    objects["Instance180"]["Transparency"] = 0.25;
    objects["Instance180"]["Name"] = "Frame";
    objects["Instance180"]["SelectionOrder"] = 0;
    objects["Instance180"]["Visible"] = true;
    objects["Instance180"]["Selectable"] = false;
    objects["Instance180"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance180"]["BackgroundColor3"] = Color3.new(1, 0.666667, 0);

    objects["Instance181"]["Visible"] = true;
    objects["Instance181"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance181"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance181"]["Active"] = false;
    objects["Instance181"]["TextStrokeTransparency"] = 1;
    objects["Instance181"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance181"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance181"]["ZIndex"] = 1;
    objects["Instance181"]["BorderSizePixel"] = 0;
    objects["Instance181"]["Draggable"] = false;
    objects["Instance181"]["RichText"] = false;
    objects["Instance181"]["Transparency"] = 1;
    objects["Instance181"]["SelectionOrder"] = 0;
    objects["Instance181"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance181"]["TextScaled"] = true;
    objects["Instance181"]["TextWrap"] = true;
    objects["Instance181"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance181"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance181"]["Parent"] = objects["Instance178"];
    objects["Instance181"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance181"]["TextSize"] = 14;
    objects["Instance181"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance181"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance181"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance181"]["BackgroundTransparency"] = 1;
    objects["Instance181"]["LineHeight"] = 1;
    objects["Instance181"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance181"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance181"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance181"]["Text"] = "RemoteEventar";
    objects["Instance181"]["LayoutOrder"] = 0;
    objects["Instance181"]["TextWrapped"] = true;
    objects["Instance181"]["Rotation"] = 0;
    objects["Instance181"]["TextTransparency"] = 0;
    objects["Instance181"]["Name"] = "Label";
    objects["Instance181"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance181"]["ClipsDescendants"] = false;
    objects["Instance181"]["MaxVisibleGraphemes"] = -1;
    objects["Instance181"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance181"]["Selectable"] = false;

    objects["Instance182"]["LayoutOrder"] = 0;
    objects["Instance182"]["Active"] = false;
    objects["Instance182"]["Parent"] = objects["Instance178"];
    objects["Instance182"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance182"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance182"]["ZIndex"] = 1;
    objects["Instance182"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance182"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance182"]["Draggable"] = false;
    objects["Instance182"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance182"]["ClipsDescendants"] = false;
    objects["Instance182"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance182"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance182"]["BackgroundTransparency"] = 1;
    objects["Instance182"]["BorderSizePixel"] = 0;
    objects["Instance182"]["Rotation"] = 0;
    objects["Instance182"]["Transparency"] = 1;
    objects["Instance182"]["Name"] = "Selection";
    objects["Instance182"]["SelectionOrder"] = 0;
    objects["Instance182"]["Visible"] = true;
    objects["Instance182"]["Selectable"] = false;
    objects["Instance182"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance182"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance183"]["LayoutOrder"] = 0;
    objects["Instance183"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance183"]["LineHeight"] = 1;
    objects["Instance183"]["Active"] = true;
    objects["Instance183"]["TextStrokeTransparency"] = 1;
    objects["Instance183"]["SelectionStart"] = -1;
    objects["Instance183"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance183"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance183"]["ZIndex"] = 1;
    objects["Instance183"]["BorderSizePixel"] = 0;
    objects["Instance183"]["TextEditable"] = true;
    objects["Instance183"]["Draggable"] = false;
    objects["Instance183"]["RichText"] = false;
    objects["Instance183"]["Transparency"] = 0.9750000238418579;
    objects["Instance183"]["SelectionOrder"] = 0;
    objects["Instance183"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance183"]["TextScaled"] = false;
    objects["Instance183"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance183"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance183"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance183"]["Parent"] = objects["Instance164"];
    objects["Instance183"]["TextWrapped"] = false;
    objects["Instance183"]["MaxVisibleGraphemes"] = -1;
    objects["Instance183"]["Name"] = "TextBox";
    objects["Instance183"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance183"]["TextTransparency"] = 0;
    objects["Instance183"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance183"]["CursorPosition"] = 1;
    objects["Instance183"]["ClipsDescendants"] = false;
    objects["Instance183"]["PlaceholderText"] = "";
    objects["Instance183"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance183"]["Size"] = UDim2.new(0.75, 0, 0.6000000238418579, 0);
    objects["Instance183"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance183"]["Selectable"] = true;
    objects["Instance183"]["ShowNativeInput"] = true;
    objects["Instance183"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance183"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance183"]["Text"] = "";
    objects["Instance183"]["TextSize"] = 14;
    objects["Instance183"]["Visible"] = true;
    objects["Instance183"]["Rotation"] = 0;
    objects["Instance183"]["MultiLine"] = false;
    objects["Instance183"]["BackgroundTransparency"] = 0.9750000238418579;
    objects["Instance183"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance183"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance183"]["ClearTextOnFocus"] = true;
    objects["Instance183"]["Position"] = UDim2.new(0.25, 0, 0, 0);
    objects["Instance183"]["TextWrap"] = false;

    objects["Instance184"]["LayoutOrder"] = 0;
    objects["Instance184"]["Active"] = false;
    objects["Instance184"]["Parent"] = objects["Instance183"];
    objects["Instance184"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance184"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance184"]["ZIndex"] = 1;
    objects["Instance184"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance184"]["Size"] = UDim2.new(0.9789999723434448, 0, 0, 1);
    objects["Instance184"]["Draggable"] = false;
    objects["Instance184"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance184"]["ClipsDescendants"] = false;
    objects["Instance184"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance184"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance184"]["BackgroundTransparency"] = 0.5;
    objects["Instance184"]["BorderSizePixel"] = 0;
    objects["Instance184"]["Rotation"] = 0;
    objects["Instance184"]["Transparency"] = 0.5;
    objects["Instance184"]["Name"] = "Separator";
    objects["Instance184"]["SelectionOrder"] = 0;
    objects["Instance184"]["Visible"] = true;
    objects["Instance184"]["Selectable"] = false;
    objects["Instance184"]["Position"] = UDim2.new(0, 0, 1, 0);
    objects["Instance184"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance185"]["LayoutOrder"] = 0;
    objects["Instance185"]["Active"] = false;
    objects["Instance185"]["Parent"] = objects["Instance83"];
    objects["Instance185"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance185"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance185"]["ZIndex"] = 1;
    objects["Instance185"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance185"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance185"]["Draggable"] = false;
    objects["Instance185"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance185"]["ClipsDescendants"] = false;
    objects["Instance185"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance185"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance185"]["BackgroundTransparency"] = 1;
    objects["Instance185"]["BorderSizePixel"] = 0;
    objects["Instance185"]["Rotation"] = 0;
    objects["Instance185"]["Transparency"] = 1;
    objects["Instance185"]["Name"] = "HTTPSpy";
    objects["Instance185"]["SelectionOrder"] = 0;
    objects["Instance185"]["Visible"] = false;
    objects["Instance185"]["Selectable"] = false;
    objects["Instance185"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance185"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance186"]["Visible"] = false;
    objects["Instance186"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance186"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance186"]["Active"] = false;
    objects["Instance186"]["TextStrokeTransparency"] = 1;
    objects["Instance186"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance186"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance186"]["ZIndex"] = 1;
    objects["Instance186"]["BorderSizePixel"] = 0;
    objects["Instance186"]["Draggable"] = false;
    objects["Instance186"]["RichText"] = false;
    objects["Instance186"]["Transparency"] = 1;
    objects["Instance186"]["SelectionOrder"] = 0;
    objects["Instance186"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance186"]["TextScaled"] = true;
    objects["Instance186"]["TextWrap"] = true;
    objects["Instance186"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance186"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance186"]["Parent"] = objects["Instance185"];
    objects["Instance186"]["AnchorPoint"] = Vector2.new(0.5, 0.75);
    objects["Instance186"]["TextSize"] = 14;
    objects["Instance186"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance186"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance186"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.15000000596046448, 0);
    objects["Instance186"]["BackgroundTransparency"] = 1;
    objects["Instance186"]["LineHeight"] = 1;
    objects["Instance186"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance186"]["TextColor3"] = Color3.new(0.784314, 0.784314, 0.784314);
    objects["Instance186"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance186"]["Text"] = "THIS TOOL IS UNAVAILABLE IN YOUR EXECUTOR";
    objects["Instance186"]["LayoutOrder"] = 0;
    objects["Instance186"]["TextWrapped"] = true;
    objects["Instance186"]["Rotation"] = 0;
    objects["Instance186"]["TextTransparency"] = 0;
    objects["Instance186"]["Name"] = "Unavailable";
    objects["Instance186"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance186"]["ClipsDescendants"] = false;
    objects["Instance186"]["MaxVisibleGraphemes"] = -1;
    objects["Instance186"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance186"]["Selectable"] = false;

    objects["Instance187"]["LayoutOrder"] = 0;
    objects["Instance187"]["Active"] = false;
    objects["Instance187"]["Parent"] = objects["Instance185"];
    objects["Instance187"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance187"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance187"]["ZIndex"] = 1;
    objects["Instance187"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance187"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance187"]["Draggable"] = false;
    objects["Instance187"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance187"]["ClipsDescendants"] = false;
    objects["Instance187"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance187"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance187"]["BackgroundTransparency"] = 1;
    objects["Instance187"]["BorderSizePixel"] = 0;
    objects["Instance187"]["Rotation"] = 0;
    objects["Instance187"]["Transparency"] = 1;
    objects["Instance187"]["Name"] = "Contents";
    objects["Instance187"]["SelectionOrder"] = 0;
    objects["Instance187"]["Visible"] = true;
    objects["Instance187"]["Selectable"] = false;
    objects["Instance187"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance187"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance188"]["LayoutOrder"] = 0;
    objects["Instance188"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance188"]["LineHeight"] = 1;
    objects["Instance188"]["Active"] = true;
    objects["Instance188"]["TextStrokeTransparency"] = 1;
    objects["Instance188"]["SelectionStart"] = -1;
    objects["Instance188"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance188"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance188"]["ZIndex"] = 1;
    objects["Instance188"]["BorderSizePixel"] = 0;
    objects["Instance188"]["TextEditable"] = true;
    objects["Instance188"]["Draggable"] = false;
    objects["Instance188"]["RichText"] = false;
    objects["Instance188"]["Transparency"] = 0.9750000238418579;
    objects["Instance188"]["SelectionOrder"] = 0;
    objects["Instance188"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance188"]["TextScaled"] = false;
    objects["Instance188"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance188"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance188"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance188"]["Parent"] = objects["Instance187"];
    objects["Instance188"]["TextWrapped"] = false;
    objects["Instance188"]["MaxVisibleGraphemes"] = -1;
    objects["Instance188"]["Name"] = "TextBox";
    objects["Instance188"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance188"]["TextTransparency"] = 0;
    objects["Instance188"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance188"]["CursorPosition"] = 1;
    objects["Instance188"]["ClipsDescendants"] = false;
    objects["Instance188"]["PlaceholderText"] = "";
    objects["Instance188"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance188"]["Size"] = UDim2.new(0.75, 0, 0.6000000238418579, 0);
    objects["Instance188"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance188"]["Selectable"] = true;
    objects["Instance188"]["ShowNativeInput"] = true;
    objects["Instance188"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance188"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance188"]["Text"] = "";
    objects["Instance188"]["TextSize"] = 14;
    objects["Instance188"]["Visible"] = true;
    objects["Instance188"]["Rotation"] = 0;
    objects["Instance188"]["MultiLine"] = false;
    objects["Instance188"]["BackgroundTransparency"] = 0.9750000238418579;
    objects["Instance188"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance188"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance188"]["ClearTextOnFocus"] = true;
    objects["Instance188"]["Position"] = UDim2.new(0.25, 0, 0, 0);
    objects["Instance188"]["TextWrap"] = false;

    objects["Instance189"]["LayoutOrder"] = 0;
    objects["Instance189"]["Active"] = false;
    objects["Instance189"]["Parent"] = objects["Instance188"];
    objects["Instance189"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance189"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance189"]["ZIndex"] = 1;
    objects["Instance189"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance189"]["Size"] = UDim2.new(0.9789999723434448, 0, 0, 1);
    objects["Instance189"]["Draggable"] = false;
    objects["Instance189"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance189"]["ClipsDescendants"] = false;
    objects["Instance189"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance189"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance189"]["BackgroundTransparency"] = 0.5;
    objects["Instance189"]["BorderSizePixel"] = 0;
    objects["Instance189"]["Rotation"] = 0;
    objects["Instance189"]["Transparency"] = 0.5;
    objects["Instance189"]["Name"] = "Separator";
    objects["Instance189"]["SelectionOrder"] = 0;
    objects["Instance189"]["Visible"] = true;
    objects["Instance189"]["Selectable"] = false;
    objects["Instance189"]["Position"] = UDim2.new(0, 0, 1, 0);
    objects["Instance189"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance190"]["LayoutOrder"] = 0;
    objects["Instance190"]["Active"] = false;
    objects["Instance190"]["Parent"] = objects["Instance187"];
    objects["Instance190"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance190"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance190"]["ZIndex"] = 1;
    objects["Instance190"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance190"]["Size"] = UDim2.new(0, 1, 0.9729999899864197, 0);
    objects["Instance190"]["Draggable"] = false;
    objects["Instance190"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance190"]["ClipsDescendants"] = false;
    objects["Instance190"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance190"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance190"]["BackgroundTransparency"] = 0.5;
    objects["Instance190"]["BorderSizePixel"] = 0;
    objects["Instance190"]["Rotation"] = 0;
    objects["Instance190"]["Transparency"] = 0.5;
    objects["Instance190"]["Name"] = "Separator";
    objects["Instance190"]["SelectionOrder"] = 0;
    objects["Instance190"]["Visible"] = true;
    objects["Instance190"]["Selectable"] = false;
    objects["Instance190"]["Position"] = UDim2.new(0.2500000298023224, -1, 0, 0);
    objects["Instance190"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance191"]["Visible"] = true;
    objects["Instance191"]["Active"] = false;
    objects["Instance191"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance191"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance191"]["ZIndex"] = 1;
    objects["Instance191"]["BorderSizePixel"] = 0;
    objects["Instance191"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance191"]["Draggable"] = false;
    objects["Instance191"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance191"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance191"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance191"]["Transparency"] = 1;
    objects["Instance191"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance191"]["SelectionOrder"] = 0;
    objects["Instance191"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance191"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance191"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance191"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance191"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance191"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance191"]["Size"] = UDim2.new(0.25, 0, 0.949999988079071, 1);
    objects["Instance191"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance191"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance191"]["Selectable"] = false;
    objects["Instance191"]["ClipsDescendants"] = true;
    objects["Instance191"]["ScrollBarImageTransparency"] = 0;
    objects["Instance191"]["ScrollBarThickness"] = 0;
    objects["Instance191"]["Parent"] = objects["Instance187"];
    objects["Instance191"]["BackgroundTransparency"] = 1;
    objects["Instance191"]["Rotation"] = 0;
    objects["Instance191"]["LayoutOrder"] = 0;
    objects["Instance191"]["Name"] = "Logs";
    objects["Instance191"]["Position"] = UDim2.new(0, 0, 0.012000000104308128, 0);
    objects["Instance191"]["ScrollingEnabled"] = true;
    objects["Instance191"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance191"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance191"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance192"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance192"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance192"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance192"]["Parent"] = objects["Instance191"];
    objects["Instance192"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance192"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance192"]["Name"] = "UIListLayout";
    objects["Instance192"]["Padding"] = UDim.new(0, 0);
    objects["Instance192"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance192"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance193"]["Visible"] = true;
    objects["Instance193"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance193"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance193"]["Active"] = false;
    objects["Instance193"]["TextStrokeTransparency"] = 1;
    objects["Instance193"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance193"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance193"]["ZIndex"] = 1;
    objects["Instance193"]["BorderSizePixel"] = 0;
    objects["Instance193"]["Draggable"] = false;
    objects["Instance193"]["RichText"] = false;
    objects["Instance193"]["Modal"] = false;
    objects["Instance193"]["AutoButtonColor"] = true;
    objects["Instance193"]["Transparency"] = 1;
    objects["Instance193"]["SelectionOrder"] = 0;
    objects["Instance193"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance193"]["TextScaled"] = false;
    objects["Instance193"]["TextWrap"] = false;
    objects["Instance193"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance193"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance193"]["Parent"] = objects["Instance191"];
    objects["Instance193"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance193"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance193"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance193"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance193"]["Selected"] = false;
    objects["Instance193"]["TextSize"] = 14;
    objects["Instance193"]["Size"] = UDim2.new(1, 0, 0.12200000137090683, 0);
    objects["Instance193"]["BackgroundTransparency"] = 1;
    objects["Instance193"]["TextWrapped"] = false;
    objects["Instance193"]["ClipsDescendants"] = false;
    objects["Instance193"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance193"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance193"]["Text"] = "";
    objects["Instance193"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance193"]["LayoutOrder"] = 0;
    objects["Instance193"]["Rotation"] = 0;
    objects["Instance193"]["LineHeight"] = 1;
    objects["Instance193"]["Name"] = "Log";
    objects["Instance193"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance193"]["Selectable"] = false;
    objects["Instance193"]["MaxVisibleGraphemes"] = -1;
    objects["Instance193"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance193"]["TextTransparency"] = 0;

    objects["Instance194"]["LayoutOrder"] = 0;
    objects["Instance194"]["Active"] = false;
    objects["Instance194"]["Parent"] = objects["Instance193"];
    objects["Instance194"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance194"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance194"]["ZIndex"] = 1;
    objects["Instance194"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance194"]["Size"] = UDim2.new(0.8500000238418579, 0, 0.699999988079071, 0);
    objects["Instance194"]["Draggable"] = false;
    objects["Instance194"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance194"]["ClipsDescendants"] = false;
    objects["Instance194"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance194"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance194"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance194"]["BorderSizePixel"] = 0;
    objects["Instance194"]["Rotation"] = 0;
    objects["Instance194"]["Transparency"] = 0.949999988079071;
    objects["Instance194"]["Name"] = "Contents";
    objects["Instance194"]["SelectionOrder"] = 0;
    objects["Instance194"]["Visible"] = true;
    objects["Instance194"]["Selectable"] = false;
    objects["Instance194"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance194"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance195"]["Enabled"] = true;
    objects["Instance195"]["Transparency"] = 0.5;
    objects["Instance195"]["Name"] = "UIStroke";
    objects["Instance195"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance195"]["Parent"] = objects["Instance194"];
    objects["Instance195"]["Thickness"] = 1;
    objects["Instance195"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance195"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance196"]["LayoutOrder"] = 0;
    objects["Instance196"]["Active"] = false;
    objects["Instance196"]["Parent"] = objects["Instance194"];
    objects["Instance196"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance196"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance196"]["ZIndex"] = 1;
    objects["Instance196"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance196"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance196"]["Draggable"] = false;
    objects["Instance196"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance196"]["ClipsDescendants"] = false;
    objects["Instance196"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance196"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance196"]["BackgroundTransparency"] = 0.25;
    objects["Instance196"]["BorderSizePixel"] = 0;
    objects["Instance196"]["Rotation"] = 0;
    objects["Instance196"]["Transparency"] = 0.25;
    objects["Instance196"]["Name"] = "Frame";
    objects["Instance196"]["SelectionOrder"] = 0;
    objects["Instance196"]["Visible"] = true;
    objects["Instance196"]["Selectable"] = false;
    objects["Instance196"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance196"]["BackgroundColor3"] = Color3.new(0.333333, 1, 0.498039);

    objects["Instance197"]["Visible"] = true;
    objects["Instance197"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance197"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance197"]["Active"] = false;
    objects["Instance197"]["TextStrokeTransparency"] = 1;
    objects["Instance197"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance197"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance197"]["ZIndex"] = 1;
    objects["Instance197"]["BorderSizePixel"] = 0;
    objects["Instance197"]["Draggable"] = false;
    objects["Instance197"]["RichText"] = false;
    objects["Instance197"]["Transparency"] = 1;
    objects["Instance197"]["SelectionOrder"] = 0;
    objects["Instance197"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance197"]["TextScaled"] = true;
    objects["Instance197"]["TextWrap"] = true;
    objects["Instance197"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance197"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance197"]["Parent"] = objects["Instance194"];
    objects["Instance197"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance197"]["TextSize"] = 14;
    objects["Instance197"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance197"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance197"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance197"]["BackgroundTransparency"] = 1;
    objects["Instance197"]["LineHeight"] = 1;
    objects["Instance197"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance197"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance197"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance197"]["Text"] = "example.org";
    objects["Instance197"]["LayoutOrder"] = 0;
    objects["Instance197"]["TextWrapped"] = true;
    objects["Instance197"]["Rotation"] = 0;
    objects["Instance197"]["TextTransparency"] = 0;
    objects["Instance197"]["Name"] = "Label";
    objects["Instance197"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance197"]["ClipsDescendants"] = false;
    objects["Instance197"]["MaxVisibleGraphemes"] = -1;
    objects["Instance197"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance197"]["Selectable"] = false;

    objects["Instance198"]["LayoutOrder"] = 0;
    objects["Instance198"]["Active"] = false;
    objects["Instance198"]["Parent"] = objects["Instance194"];
    objects["Instance198"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance198"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance198"]["ZIndex"] = 1;
    objects["Instance198"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance198"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance198"]["Draggable"] = false;
    objects["Instance198"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance198"]["ClipsDescendants"] = false;
    objects["Instance198"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance198"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance198"]["BackgroundTransparency"] = 1;
    objects["Instance198"]["BorderSizePixel"] = 0;
    objects["Instance198"]["Rotation"] = 0;
    objects["Instance198"]["Transparency"] = 1;
    objects["Instance198"]["Name"] = "Selection";
    objects["Instance198"]["SelectionOrder"] = 0;
    objects["Instance198"]["Visible"] = true;
    objects["Instance198"]["Selectable"] = false;
    objects["Instance198"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance198"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance199"]["LayoutOrder"] = 0;
    objects["Instance199"]["Active"] = false;
    objects["Instance199"]["Parent"] = objects["Instance194"];
    objects["Instance199"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance199"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance199"]["ZIndex"] = 1;
    objects["Instance199"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance199"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance199"]["Draggable"] = false;
    objects["Instance199"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance199"]["ClipsDescendants"] = false;
    objects["Instance199"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance199"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance199"]["BackgroundTransparency"] = 0.25;
    objects["Instance199"]["BorderSizePixel"] = 0;
    objects["Instance199"]["Rotation"] = 0;
    objects["Instance199"]["Transparency"] = 0.25;
    objects["Instance199"]["Name"] = "Type";
    objects["Instance199"]["SelectionOrder"] = 0;
    objects["Instance199"]["Visible"] = false;
    objects["Instance199"]["Selectable"] = false;
    objects["Instance199"]["Position"] = UDim2.new(0.05000000074505806, 0, 0, 0);
    objects["Instance199"]["BackgroundColor3"] = Color3.new(1, 0.333333, 0.498039);

    objects["Instance200"]["Visible"] = true;
    objects["Instance200"]["Active"] = false;
    objects["Instance200"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance200"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance200"]["ZIndex"] = 1;
    objects["Instance200"]["BorderSizePixel"] = 0;
    objects["Instance200"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance200"]["Draggable"] = false;
    objects["Instance200"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance200"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance200"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance200"]["Transparency"] = 1;
    objects["Instance200"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance200"]["SelectionOrder"] = 0;
    objects["Instance200"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance200"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance200"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance200"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance200"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance200"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance200"]["Size"] = UDim2.new(0.75, 0, 0.3477204740047455, 0);
    objects["Instance200"]["ScrollBarImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance200"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);
    objects["Instance200"]["Selectable"] = false;
    objects["Instance200"]["ClipsDescendants"] = true;
    objects["Instance200"]["ScrollBarImageTransparency"] = 0;
    objects["Instance200"]["ScrollBarThickness"] = 0;
    objects["Instance200"]["Parent"] = objects["Instance187"];
    objects["Instance200"]["BackgroundTransparency"] = 1;
    objects["Instance200"]["Rotation"] = 0;
    objects["Instance200"]["LayoutOrder"] = 0;
    objects["Instance200"]["Name"] = "Buttons";
    objects["Instance200"]["Position"] = UDim2.new(0.2500000596046448, 0, 0.625, 0);
    objects["Instance200"]["ScrollingEnabled"] = true;
    objects["Instance200"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance200"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance200"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance201"]["FillDirectionMaxCells"] = 0;
    objects["Instance201"]["CellPadding"] = UDim2.new(0, 0, 0, 0);
    objects["Instance201"]["Parent"] = objects["Instance200"];
    objects["Instance201"]["CellSize"] = UDim2.new(0.3330000042915344, 0, 0.33000001311302185, 0);
    objects["Instance201"]["Name"] = "UIGridLayout";
    objects["Instance201"]["StartCorner"] = Enum.StartCorner.TopLeft;

    objects["Instance202"]["Visible"] = true;
    objects["Instance202"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance202"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance202"]["Active"] = false;
    objects["Instance202"]["TextStrokeTransparency"] = 1;
    objects["Instance202"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance202"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance202"]["ZIndex"] = 1;
    objects["Instance202"]["BorderSizePixel"] = 0;
    objects["Instance202"]["Draggable"] = false;
    objects["Instance202"]["RichText"] = false;
    objects["Instance202"]["Modal"] = false;
    objects["Instance202"]["AutoButtonColor"] = true;
    objects["Instance202"]["Transparency"] = 1;
    objects["Instance202"]["SelectionOrder"] = 0;
    objects["Instance202"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance202"]["TextScaled"] = false;
    objects["Instance202"]["TextWrap"] = false;
    objects["Instance202"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance202"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance202"]["Parent"] = objects["Instance200"];
    objects["Instance202"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance202"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance202"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance202"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance202"]["Selected"] = false;
    objects["Instance202"]["TextSize"] = 14;
    objects["Instance202"]["Size"] = UDim2.new(1, 0, 0.13249999284744263, 0);
    objects["Instance202"]["BackgroundTransparency"] = 1;
    objects["Instance202"]["TextWrapped"] = false;
    objects["Instance202"]["ClipsDescendants"] = false;
    objects["Instance202"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance202"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance202"]["Text"] = "";
    objects["Instance202"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance202"]["LayoutOrder"] = 0;
    objects["Instance202"]["Rotation"] = 0;
    objects["Instance202"]["LineHeight"] = 1;
    objects["Instance202"]["Name"] = "Button";
    objects["Instance202"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance202"]["Selectable"] = false;
    objects["Instance202"]["MaxVisibleGraphemes"] = -1;
    objects["Instance202"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance202"]["TextTransparency"] = 0;

    objects["Instance203"]["LayoutOrder"] = 0;
    objects["Instance203"]["Active"] = false;
    objects["Instance203"]["Parent"] = objects["Instance202"];
    objects["Instance203"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance203"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance203"]["ZIndex"] = 1;
    objects["Instance203"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance203"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.6499999761581421, 0);
    objects["Instance203"]["Draggable"] = false;
    objects["Instance203"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance203"]["ClipsDescendants"] = false;
    objects["Instance203"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance203"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance203"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance203"]["BorderSizePixel"] = 0;
    objects["Instance203"]["Rotation"] = 0;
    objects["Instance203"]["Transparency"] = 0.949999988079071;
    objects["Instance203"]["Name"] = "Contents";
    objects["Instance203"]["SelectionOrder"] = 0;
    objects["Instance203"]["Visible"] = true;
    objects["Instance203"]["Selectable"] = false;
    objects["Instance203"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance203"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance204"]["Enabled"] = true;
    objects["Instance204"]["Transparency"] = 0.5;
    objects["Instance204"]["Name"] = "UIStroke";
    objects["Instance204"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
    objects["Instance204"]["Parent"] = objects["Instance203"];
    objects["Instance204"]["Thickness"] = 1;
    objects["Instance204"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance204"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual;

    objects["Instance205"]["LayoutOrder"] = 0;
    objects["Instance205"]["Active"] = false;
    objects["Instance205"]["Parent"] = objects["Instance203"];
    objects["Instance205"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance205"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance205"]["ZIndex"] = 2;
    objects["Instance205"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance205"]["Size"] = UDim2.new(0.05000000074505806, 0, 1, 0);
    objects["Instance205"]["Draggable"] = false;
    objects["Instance205"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance205"]["ClipsDescendants"] = false;
    objects["Instance205"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance205"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance205"]["BackgroundTransparency"] = 0.25;
    objects["Instance205"]["BorderSizePixel"] = 0;
    objects["Instance205"]["Rotation"] = 0;
    objects["Instance205"]["Transparency"] = 0.25;
    objects["Instance205"]["Name"] = "Frame";
    objects["Instance205"]["SelectionOrder"] = 0;
    objects["Instance205"]["Visible"] = true;
    objects["Instance205"]["Selectable"] = false;
    objects["Instance205"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance205"]["BackgroundColor3"] = Color3.new(0, 0.333333, 0.498039);

    objects["Instance206"]["Visible"] = true;
    objects["Instance206"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance206"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance206"]["Active"] = false;
    objects["Instance206"]["TextStrokeTransparency"] = 1;
    objects["Instance206"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance206"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance206"]["ZIndex"] = 2;
    objects["Instance206"]["BorderSizePixel"] = 0;
    objects["Instance206"]["Draggable"] = false;
    objects["Instance206"]["RichText"] = false;
    objects["Instance206"]["Transparency"] = 1;
    objects["Instance206"]["SelectionOrder"] = 0;
    objects["Instance206"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance206"]["TextScaled"] = true;
    objects["Instance206"]["TextWrap"] = true;
    objects["Instance206"]["FontFace"] = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance206"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance206"]["Parent"] = objects["Instance203"];
    objects["Instance206"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance206"]["TextSize"] = 14;
    objects["Instance206"]["Position"] = UDim2.new(0.125, 0, 0.5, 0);
    objects["Instance206"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance206"]["Size"] = UDim2.new(0.800000011920929, 0, 0.6499999761581421, 0);
    objects["Instance206"]["BackgroundTransparency"] = 1;
    objects["Instance206"]["LineHeight"] = 1;
    objects["Instance206"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance206"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance206"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance206"]["Text"] = "Button";
    objects["Instance206"]["LayoutOrder"] = 0;
    objects["Instance206"]["TextWrapped"] = true;
    objects["Instance206"]["Rotation"] = 0;
    objects["Instance206"]["TextTransparency"] = 0;
    objects["Instance206"]["Name"] = "Label";
    objects["Instance206"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance206"]["ClipsDescendants"] = false;
    objects["Instance206"]["MaxVisibleGraphemes"] = -1;
    objects["Instance206"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance206"]["Selectable"] = false;

    objects["Instance207"]["LayoutOrder"] = 0;
    objects["Instance207"]["Active"] = false;
    objects["Instance207"]["Parent"] = objects["Instance203"];
    objects["Instance207"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance207"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance207"]["ZIndex"] = 1;
    objects["Instance207"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance207"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance207"]["Draggable"] = false;
    objects["Instance207"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance207"]["ClipsDescendants"] = false;
    objects["Instance207"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance207"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance207"]["BackgroundTransparency"] = 1;
    objects["Instance207"]["BorderSizePixel"] = 0;
    objects["Instance207"]["Rotation"] = 0;
    objects["Instance207"]["Transparency"] = 1;
    objects["Instance207"]["Name"] = "Selection";
    objects["Instance207"]["SelectionOrder"] = 0;
    objects["Instance207"]["Visible"] = true;
    objects["Instance207"]["Selectable"] = false;
    objects["Instance207"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance207"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance208"]["LayoutOrder"] = 0;
    objects["Instance208"]["Active"] = false;
    objects["Instance208"]["Parent"] = objects["Instance202"];
    objects["Instance208"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance208"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance208"]["ZIndex"] = 1;
    objects["Instance208"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance208"]["Size"] = UDim2.new(0.800000011920929, 0, 0, 1);
    objects["Instance208"]["Draggable"] = false;
    objects["Instance208"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance208"]["ClipsDescendants"] = false;
    objects["Instance208"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance208"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance208"]["BackgroundTransparency"] = 0.5;
    objects["Instance208"]["BorderSizePixel"] = 0;
    objects["Instance208"]["Rotation"] = 0;
    objects["Instance208"]["Transparency"] = 0.5;
    objects["Instance208"]["Name"] = "Separator";
    objects["Instance208"]["SelectionOrder"] = 0;
    objects["Instance208"]["Visible"] = false;
    objects["Instance208"]["Selectable"] = false;
    objects["Instance208"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance208"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance209"]["LayoutOrder"] = 0;
    objects["Instance209"]["Active"] = false;
    objects["Instance209"]["Parent"] = objects["Instance83"];
    objects["Instance209"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance209"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance209"]["ZIndex"] = 1;
    objects["Instance209"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance209"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance209"]["Draggable"] = false;
    objects["Instance209"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance209"]["ClipsDescendants"] = true;
    objects["Instance209"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance209"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance209"]["BackgroundTransparency"] = 1;
    objects["Instance209"]["BorderSizePixel"] = 0;
    objects["Instance209"]["Rotation"] = 0;
    objects["Instance209"]["Transparency"] = 1;
    objects["Instance209"]["Name"] = "ScriptScanner";
    objects["Instance209"]["SelectionOrder"] = 0;
    objects["Instance209"]["Visible"] = true;
    objects["Instance209"]["Selectable"] = false;
    objects["Instance209"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance209"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance210"]["LayoutOrder"] = 0;
    objects["Instance210"]["Active"] = false;
    objects["Instance210"]["Parent"] = objects["Instance209"];
    objects["Instance210"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance210"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance210"]["ZIndex"] = 1;
    objects["Instance210"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance210"]["Size"] = UDim2.new(1, 0, 0.8500000238418579, 0);
    objects["Instance210"]["Draggable"] = false;
    objects["Instance210"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance210"]["ClipsDescendants"] = false;
    objects["Instance210"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance210"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance210"]["BackgroundTransparency"] = 1;
    objects["Instance210"]["BorderSizePixel"] = 0;
    objects["Instance210"]["Rotation"] = 0;
    objects["Instance210"]["Transparency"] = 1;
    objects["Instance210"]["Name"] = "Contents";
    objects["Instance210"]["SelectionOrder"] = 0;
    objects["Instance210"]["Visible"] = true;
    objects["Instance210"]["Selectable"] = false;
    objects["Instance210"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance210"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance211"]["Visible"] = true;
    objects["Instance211"]["FontSize"] = Enum.FontSize.Size8;
    objects["Instance211"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance211"]["Active"] = false;
    objects["Instance211"]["TextStrokeTransparency"] = 1;
    objects["Instance211"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance211"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance211"]["ZIndex"] = 1;
    objects["Instance211"]["BorderSizePixel"] = 0;
    objects["Instance211"]["Draggable"] = false;
    objects["Instance211"]["RichText"] = false;
    objects["Instance211"]["Modal"] = false;
    objects["Instance211"]["AutoButtonColor"] = false;
    objects["Instance211"]["Transparency"] = 0.5;
    objects["Instance211"]["SelectionOrder"] = 0;
    objects["Instance211"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance211"]["TextScaled"] = false;
    objects["Instance211"]["TextWrap"] = false;
    objects["Instance211"]["FontFace"] = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance211"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance211"]["Parent"] = objects["Instance210"];
    objects["Instance211"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance211"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance211"]["Position"] = UDim2.new(0.015999961644411087, 0, 0.024999942630529404, 0);
    objects["Instance211"]["BackgroundColor3"] = Color3.new(0, 0, 0);
    objects["Instance211"]["Selected"] = false;
    objects["Instance211"]["TextSize"] = 8;
    objects["Instance211"]["Size"] = UDim2.new(0.9683749675750732, 0, 0.10000000149011612, 0);
    objects["Instance211"]["BackgroundTransparency"] = 0.5;
    objects["Instance211"]["TextWrapped"] = false;
    objects["Instance211"]["ClipsDescendants"] = false;
    objects["Instance211"]["TextColor3"] = Color3.new(0.105882, 0.164706, 0.207843);
    objects["Instance211"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance211"]["Text"] = "";
    objects["Instance211"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance211"]["LayoutOrder"] = 0;
    objects["Instance211"]["Rotation"] = 0;
    objects["Instance211"]["LineHeight"] = 1;
    objects["Instance211"]["Name"] = "SearchBar";
    objects["Instance211"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance211"]["Selectable"] = false;
    objects["Instance211"]["MaxVisibleGraphemes"] = -1;
    objects["Instance211"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance211"]["TextTransparency"] = 0.25;

    objects["Instance212"]["Parent"] = objects["Instance211"];
    objects["Instance212"]["Name"] = "UICorner";
    objects["Instance212"]["CornerRadius"] = UDim.new(0.200000003, 0);

    objects["Instance213"]["Visible"] = true;
    objects["Instance213"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance213"]["Size"] = UDim2.new(0.6000000238418579, 0, 0.6000000238418579, 0);
    objects["Instance213"]["ImageTransparency"] = 0;
    objects["Instance213"]["Parent"] = objects["Instance211"];
    objects["Instance213"]["Position"] = UDim2.new(0.012500000186264515, 0, 0.5, 0);
    objects["Instance213"]["BackgroundTransparency"] = 1;
    objects["Instance213"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance213"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance213"]["Image"] = "rbxassetid://93748616033191";
    objects["Instance213"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance213"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance213"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance213"]["ZIndex"] = 1;
    objects["Instance213"]["BorderSizePixel"] = 0;
    objects["Instance213"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance213"]["Draggable"] = false;
    objects["Instance213"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance213"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance213"]["ClipsDescendants"] = false;
    objects["Instance213"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance213"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance213"]["LayoutOrder"] = 0;
    objects["Instance213"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance213"]["Rotation"] = 0;
    objects["Instance213"]["Transparency"] = 1;
    objects["Instance213"]["Name"] = "Icon";
    objects["Instance213"]["SelectionOrder"] = 0;
    objects["Instance213"]["SliceScale"] = 1;
    objects["Instance213"]["Selectable"] = false;
    objects["Instance213"]["Active"] = false;
    objects["Instance213"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance214"]["AspectRatio"] = 1;
    objects["Instance214"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance214"]["Parent"] = objects["Instance213"];
    objects["Instance214"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance214"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance215"]["Enabled"] = true;
    objects["Instance215"]["Transparency"] = 0.5;
    objects["Instance215"]["Name"] = "UIStroke";
    objects["Instance215"]["LineJoinMode"] = Enum.LineJoinMode.Round;
    objects["Instance215"]["Parent"] = objects["Instance211"];
    objects["Instance215"]["Thickness"] = 1;
    objects["Instance215"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance215"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

    objects["Instance216"]["LayoutOrder"] = 0;
    objects["Instance216"]["Active"] = true;
    objects["Instance216"]["Parent"] = objects["Instance211"];
    objects["Instance216"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance216"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance216"]["ZIndex"] = 1;
    objects["Instance216"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance216"]["Size"] = UDim2.new(0.9200000166893005, 0, 0.6000000238418579, 0);
    objects["Instance216"]["Draggable"] = false;
    objects["Instance216"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance216"]["ClipsDescendants"] = true;
    objects["Instance216"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance216"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance216"]["BackgroundTransparency"] = 1;
    objects["Instance216"]["BorderSizePixel"] = 0;
    objects["Instance216"]["Rotation"] = 0;
    objects["Instance216"]["Transparency"] = 1;
    objects["Instance216"]["Name"] = "Field";
    objects["Instance216"]["SelectionOrder"] = 0;
    objects["Instance216"]["Visible"] = true;
    objects["Instance216"]["Selectable"] = true;
    objects["Instance216"]["Position"] = UDim2.new(0.05999999865889549, 0, 0.5, 0);
    objects["Instance216"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);

    objects["Instance217"]["LayoutOrder"] = 0;
    objects["Instance217"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance217"]["LineHeight"] = 1;
    objects["Instance217"]["Active"] = true;
    objects["Instance217"]["TextStrokeTransparency"] = 1;
    objects["Instance217"]["SelectionStart"] = -1;
    objects["Instance217"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance217"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance217"]["ZIndex"] = 1;
    objects["Instance217"]["BorderSizePixel"] = 0;
    objects["Instance217"]["TextEditable"] = true;
    objects["Instance217"]["Draggable"] = false;
    objects["Instance217"]["RichText"] = false;
    objects["Instance217"]["Transparency"] = 1;
    objects["Instance217"]["SelectionOrder"] = 0;
    objects["Instance217"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance217"]["TextScaled"] = true;
    objects["Instance217"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance217"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance217"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance217"]["Parent"] = objects["Instance216"];
    objects["Instance217"]["TextWrapped"] = true;
    objects["Instance217"]["MaxVisibleGraphemes"] = -1;
    objects["Instance217"]["Name"] = "TextBox";
    objects["Instance217"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance217"]["TextTransparency"] = 0;
    objects["Instance217"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance217"]["CursorPosition"] = 1;
    objects["Instance217"]["ClipsDescendants"] = false;
    objects["Instance217"]["PlaceholderText"] = "Type here keywords to find in game scripts. \";\" to separate keywords";
    objects["Instance217"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance217"]["Size"] = UDim2.new(999, 0, 1, 0);
    objects["Instance217"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance217"]["Selectable"] = true;
    objects["Instance217"]["ShowNativeInput"] = true;
    objects["Instance217"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance217"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance217"]["Text"] = "";
    objects["Instance217"]["TextSize"] = 14;
    objects["Instance217"]["Visible"] = true;
    objects["Instance217"]["Rotation"] = 0;
    objects["Instance217"]["MultiLine"] = false;
    objects["Instance217"]["BackgroundTransparency"] = 1;
    objects["Instance217"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance217"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance217"]["ClearTextOnFocus"] = false;
    objects["Instance217"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance217"]["TextWrap"] = true;

    objects["Instance218"]["LayoutOrder"] = 0;
    objects["Instance218"]["Active"] = false;
    objects["Instance218"]["Parent"] = objects["Instance210"];
    objects["Instance218"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance218"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance218"]["ZIndex"] = 1;
    objects["Instance218"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance218"]["Size"] = UDim2.new(1, 0, 0.8500000238418579, 0);
    objects["Instance218"]["Draggable"] = false;
    objects["Instance218"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance218"]["ClipsDescendants"] = false;
    objects["Instance218"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance218"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance218"]["BackgroundTransparency"] = 1;
    objects["Instance218"]["BorderSizePixel"] = 0;
    objects["Instance218"]["Rotation"] = 0;
    objects["Instance218"]["Transparency"] = 1;
    objects["Instance218"]["Name"] = "View";
    objects["Instance218"]["SelectionOrder"] = 0;
    objects["Instance218"]["Visible"] = true;
    objects["Instance218"]["Selectable"] = false;
    objects["Instance218"]["Position"] = UDim2.new(0, 0, 0.15000002086162567, 0);
    objects["Instance218"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance219"]["LayoutOrder"] = 0;
    objects["Instance219"]["Active"] = false;
    objects["Instance219"]["Parent"] = objects["Instance218"];
    objects["Instance219"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance219"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance219"]["ZIndex"] = 1;
    objects["Instance219"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance219"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance219"]["Draggable"] = false;
    objects["Instance219"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance219"]["ClipsDescendants"] = false;
    objects["Instance219"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance219"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance219"]["BackgroundTransparency"] = 1;
    objects["Instance219"]["BorderSizePixel"] = 0;
    objects["Instance219"]["Rotation"] = 0;
    objects["Instance219"]["Transparency"] = 1;
    objects["Instance219"]["Name"] = "Editor";
    objects["Instance219"]["SelectionOrder"] = 0;
    objects["Instance219"]["Visible"] = false;
    objects["Instance219"]["Selectable"] = false;
    objects["Instance219"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance219"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance220"]["LayoutOrder"] = 0;
    objects["Instance220"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance220"]["LineHeight"] = 1;
    objects["Instance220"]["Active"] = true;
    objects["Instance220"]["TextStrokeTransparency"] = 1;
    objects["Instance220"]["SelectionStart"] = -1;
    objects["Instance220"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance220"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance220"]["ZIndex"] = 1;
    objects["Instance220"]["BorderSizePixel"] = 0;
    objects["Instance220"]["TextEditable"] = true;
    objects["Instance220"]["Draggable"] = false;
    objects["Instance220"]["RichText"] = false;
    objects["Instance220"]["Transparency"] = 0.9750000238418579;
    objects["Instance220"]["SelectionOrder"] = 0;
    objects["Instance220"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance220"]["TextScaled"] = false;
    objects["Instance220"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance220"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance220"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance220"]["Parent"] = objects["Instance219"];
    objects["Instance220"]["TextWrapped"] = false;
    objects["Instance220"]["MaxVisibleGraphemes"] = -1;
    objects["Instance220"]["Name"] = "TextBox";
    objects["Instance220"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance220"]["TextTransparency"] = 0;
    objects["Instance220"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance220"]["CursorPosition"] = 1;
    objects["Instance220"]["ClipsDescendants"] = false;
    objects["Instance220"]["PlaceholderText"] = "";
    objects["Instance220"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance220"]["Size"] = UDim2.new(1, 0, 0.8999999761581421, 0);
    objects["Instance220"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance220"]["Selectable"] = true;
    objects["Instance220"]["ShowNativeInput"] = true;
    objects["Instance220"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance220"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance220"]["Text"] = "cod editor zon :)))";
    objects["Instance220"]["TextSize"] = 14;
    objects["Instance220"]["Visible"] = true;
    objects["Instance220"]["Rotation"] = 0;
    objects["Instance220"]["MultiLine"] = false;
    objects["Instance220"]["BackgroundTransparency"] = 0.9750000238418579;
    objects["Instance220"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance220"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance220"]["ClearTextOnFocus"] = true;
    objects["Instance220"]["Position"] = UDim2.new(0, 0, 0.10000000149011612, 0);
    objects["Instance220"]["TextWrap"] = false;

    objects["Instance221"]["LayoutOrder"] = 0;
    objects["Instance221"]["Active"] = false;
    objects["Instance221"]["Parent"] = objects["Instance220"];
    objects["Instance221"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance221"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance221"]["ZIndex"] = 1;
    objects["Instance221"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance221"]["Size"] = UDim2.new(0.984000027179718, 0, 0, 1);
    objects["Instance221"]["Draggable"] = false;
    objects["Instance221"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance221"]["ClipsDescendants"] = false;
    objects["Instance221"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance221"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance221"]["BackgroundTransparency"] = 0.5;
    objects["Instance221"]["BorderSizePixel"] = 0;
    objects["Instance221"]["Rotation"] = 0;
    objects["Instance221"]["Transparency"] = 0.5;
    objects["Instance221"]["Name"] = "Separator";
    objects["Instance221"]["SelectionOrder"] = 0;
    objects["Instance221"]["Visible"] = true;
    objects["Instance221"]["Selectable"] = false;
    objects["Instance221"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance221"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance222"]["Visible"] = true;
    objects["Instance222"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance222"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance222"]["Active"] = true;
    objects["Instance222"]["TextStrokeTransparency"] = 1;
    objects["Instance222"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance222"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance222"]["ZIndex"] = 1;
    objects["Instance222"]["BorderSizePixel"] = 0;
    objects["Instance222"]["Draggable"] = false;
    objects["Instance222"]["RichText"] = false;
    objects["Instance222"]["Modal"] = false;
    objects["Instance222"]["AutoButtonColor"] = true;
    objects["Instance222"]["Transparency"] = 0.8999999761581421;
    objects["Instance222"]["SelectionOrder"] = 0;
    objects["Instance222"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance222"]["TextScaled"] = true;
    objects["Instance222"]["TextWrap"] = true;
    objects["Instance222"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance222"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance222"]["Parent"] = objects["Instance219"];
    objects["Instance222"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance222"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance222"]["Position"] = UDim2.new(0.15000000596046448, 0, 0, 0);
    objects["Instance222"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance222"]["Selected"] = false;
    objects["Instance222"]["TextSize"] = 14;
    objects["Instance222"]["Size"] = UDim2.new(0.42500001192092896, 0, 0.10000000149011612, 0);
    objects["Instance222"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance222"]["TextWrapped"] = true;
    objects["Instance222"]["ClipsDescendants"] = false;
    objects["Instance222"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance222"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance222"]["Text"] = "Copy text to clipboard";
    objects["Instance222"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance222"]["LayoutOrder"] = 0;
    objects["Instance222"]["Rotation"] = 0;
    objects["Instance222"]["LineHeight"] = 1;
    objects["Instance222"]["Name"] = "CopyCode";
    objects["Instance222"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance222"]["Selectable"] = true;
    objects["Instance222"]["MaxVisibleGraphemes"] = -1;
    objects["Instance222"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance222"]["TextTransparency"] = 0;

    objects["Instance223"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance223"]["Name"] = "UIPadding";
    objects["Instance223"]["Parent"] = objects["Instance222"];
    objects["Instance223"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance223"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance223"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance224"]["LayoutOrder"] = 0;
    objects["Instance224"]["Active"] = false;
    objects["Instance224"]["Parent"] = objects["Instance222"];
    objects["Instance224"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance224"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance224"]["ZIndex"] = 1;
    objects["Instance224"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance224"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance224"]["Draggable"] = false;
    objects["Instance224"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance224"]["ClipsDescendants"] = false;
    objects["Instance224"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance224"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance224"]["BackgroundTransparency"] = 0.5;
    objects["Instance224"]["BorderSizePixel"] = 0;
    objects["Instance224"]["Rotation"] = 0;
    objects["Instance224"]["Transparency"] = 0.5;
    objects["Instance224"]["Name"] = "Frame";
    objects["Instance224"]["SelectionOrder"] = 0;
    objects["Instance224"]["Visible"] = true;
    objects["Instance224"]["Selectable"] = false;
    objects["Instance224"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance224"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance225"]["Visible"] = true;
    objects["Instance225"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance225"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance225"]["Active"] = true;
    objects["Instance225"]["TextStrokeTransparency"] = 1;
    objects["Instance225"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance225"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance225"]["ZIndex"] = 1;
    objects["Instance225"]["BorderSizePixel"] = 0;
    objects["Instance225"]["Draggable"] = false;
    objects["Instance225"]["RichText"] = false;
    objects["Instance225"]["Modal"] = false;
    objects["Instance225"]["AutoButtonColor"] = true;
    objects["Instance225"]["Transparency"] = 0.8999999761581421;
    objects["Instance225"]["SelectionOrder"] = 0;
    objects["Instance225"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance225"]["TextScaled"] = true;
    objects["Instance225"]["TextWrap"] = true;
    objects["Instance225"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance225"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance225"]["Parent"] = objects["Instance219"];
    objects["Instance225"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance225"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance225"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance225"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance225"]["Selected"] = false;
    objects["Instance225"]["TextSize"] = 14;
    objects["Instance225"]["Size"] = UDim2.new(0.15000000596046448, 0, 0.10000000149011612, 0);
    objects["Instance225"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance225"]["TextWrapped"] = true;
    objects["Instance225"]["ClipsDescendants"] = false;
    objects["Instance225"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance225"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance225"]["Text"] = "< Back";
    objects["Instance225"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance225"]["LayoutOrder"] = 0;
    objects["Instance225"]["Rotation"] = 0;
    objects["Instance225"]["LineHeight"] = 1;
    objects["Instance225"]["Name"] = "Back";
    objects["Instance225"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance225"]["Selectable"] = true;
    objects["Instance225"]["MaxVisibleGraphemes"] = -1;
    objects["Instance225"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance225"]["TextTransparency"] = 0;

    objects["Instance226"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance226"]["Name"] = "UIPadding";
    objects["Instance226"]["Parent"] = objects["Instance225"];
    objects["Instance226"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance226"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance226"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance227"]["LayoutOrder"] = 0;
    objects["Instance227"]["Active"] = false;
    objects["Instance227"]["Parent"] = objects["Instance225"];
    objects["Instance227"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance227"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance227"]["ZIndex"] = 1;
    objects["Instance227"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance227"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance227"]["Draggable"] = false;
    objects["Instance227"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance227"]["ClipsDescendants"] = false;
    objects["Instance227"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance227"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance227"]["BackgroundTransparency"] = 0.5;
    objects["Instance227"]["BorderSizePixel"] = 0;
    objects["Instance227"]["Rotation"] = 0;
    objects["Instance227"]["Transparency"] = 0.5;
    objects["Instance227"]["Name"] = "Frame";
    objects["Instance227"]["SelectionOrder"] = 0;
    objects["Instance227"]["Visible"] = true;
    objects["Instance227"]["Selectable"] = false;
    objects["Instance227"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance227"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance228"]["Visible"] = true;
    objects["Instance228"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance228"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance228"]["Active"] = true;
    objects["Instance228"]["TextStrokeTransparency"] = 1;
    objects["Instance228"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance228"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance228"]["ZIndex"] = 1;
    objects["Instance228"]["BorderSizePixel"] = 0;
    objects["Instance228"]["Draggable"] = false;
    objects["Instance228"]["RichText"] = false;
    objects["Instance228"]["Modal"] = false;
    objects["Instance228"]["AutoButtonColor"] = true;
    objects["Instance228"]["Transparency"] = 0.8999999761581421;
    objects["Instance228"]["SelectionOrder"] = 0;
    objects["Instance228"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance228"]["TextScaled"] = true;
    objects["Instance228"]["TextWrap"] = true;
    objects["Instance228"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance228"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance228"]["Parent"] = objects["Instance219"];
    objects["Instance228"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance228"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance228"]["Position"] = UDim2.new(0.574999988079071, 0, 0, 0);
    objects["Instance228"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance228"]["Selected"] = false;
    objects["Instance228"]["TextSize"] = 14;
    objects["Instance228"]["Size"] = UDim2.new(0.42500001192092896, 0, 0.10000000149011612, 0);
    objects["Instance228"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance228"]["TextWrapped"] = true;
    objects["Instance228"]["ClipsDescendants"] = false;
    objects["Instance228"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance228"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance228"]["Text"] = "Copy path to clipboard";
    objects["Instance228"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance228"]["LayoutOrder"] = 0;
    objects["Instance228"]["Rotation"] = 0;
    objects["Instance228"]["LineHeight"] = 1;
    objects["Instance228"]["Name"] = "CopyPath";
    objects["Instance228"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance228"]["Selectable"] = true;
    objects["Instance228"]["MaxVisibleGraphemes"] = -1;
    objects["Instance228"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance228"]["TextTransparency"] = 0;

    objects["Instance229"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance229"]["Name"] = "UIPadding";
    objects["Instance229"]["Parent"] = objects["Instance228"];
    objects["Instance229"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance229"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance229"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance230"]["LayoutOrder"] = 0;
    objects["Instance230"]["Active"] = false;
    objects["Instance230"]["Parent"] = objects["Instance228"];
    objects["Instance230"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance230"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance230"]["ZIndex"] = 1;
    objects["Instance230"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance230"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance230"]["Draggable"] = false;
    objects["Instance230"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance230"]["ClipsDescendants"] = false;
    objects["Instance230"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance230"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance230"]["BackgroundTransparency"] = 0.5;
    objects["Instance230"]["BorderSizePixel"] = 0;
    objects["Instance230"]["Rotation"] = 0;
    objects["Instance230"]["Transparency"] = 0.5;
    objects["Instance230"]["Name"] = "Frame";
    objects["Instance230"]["SelectionOrder"] = 0;
    objects["Instance230"]["Visible"] = true;
    objects["Instance230"]["Selectable"] = false;
    objects["Instance230"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance230"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance231"]["Visible"] = false;
    objects["Instance231"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance231"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance231"]["Active"] = true;
    objects["Instance231"]["TextStrokeTransparency"] = 1;
    objects["Instance231"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance231"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance231"]["ZIndex"] = 1;
    objects["Instance231"]["BorderSizePixel"] = 0;
    objects["Instance231"]["Draggable"] = false;
    objects["Instance231"]["RichText"] = false;
    objects["Instance231"]["Modal"] = false;
    objects["Instance231"]["AutoButtonColor"] = true;
    objects["Instance231"]["Transparency"] = 0.8999999761581421;
    objects["Instance231"]["SelectionOrder"] = 0;
    objects["Instance231"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance231"]["TextScaled"] = true;
    objects["Instance231"]["TextWrap"] = true;
    objects["Instance231"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance231"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance231"]["Parent"] = objects["Instance219"];
    objects["Instance231"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance231"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance231"]["Position"] = UDim2.new(0.7500002384185791, 0, 0, 0);
    objects["Instance231"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance231"]["Selected"] = false;
    objects["Instance231"]["TextSize"] = 14;
    objects["Instance231"]["Size"] = UDim2.new(0.24999991059303284, 0, 0.10000001639127731, 0);
    objects["Instance231"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance231"]["TextWrapped"] = true;
    objects["Instance231"]["ClipsDescendants"] = false;
    objects["Instance231"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance231"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance231"]["Text"] = "Enchant code";
    objects["Instance231"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance231"]["LayoutOrder"] = 0;
    objects["Instance231"]["Rotation"] = 0;
    objects["Instance231"]["LineHeight"] = 1;
    objects["Instance231"]["Name"] = "Enchant";
    objects["Instance231"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance231"]["Selectable"] = true;
    objects["Instance231"]["MaxVisibleGraphemes"] = -1;
    objects["Instance231"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance231"]["TextTransparency"] = 0;

    objects["Instance232"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance232"]["Name"] = "UIPadding";
    objects["Instance232"]["Parent"] = objects["Instance231"];
    objects["Instance232"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance232"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance232"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance233"]["LayoutOrder"] = 0;
    objects["Instance233"]["Active"] = false;
    objects["Instance233"]["Parent"] = objects["Instance218"];
    objects["Instance233"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance233"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance233"]["ZIndex"] = 1;
    objects["Instance233"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance233"]["Size"] = UDim2.new(0.9843750596046448, 0, 1, 0);
    objects["Instance233"]["Draggable"] = false;
    objects["Instance233"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance233"]["ClipsDescendants"] = false;
    objects["Instance233"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance233"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance233"]["BackgroundTransparency"] = 1;
    objects["Instance233"]["BorderSizePixel"] = 0;
    objects["Instance233"]["Rotation"] = 0;
    objects["Instance233"]["Transparency"] = 1;
    objects["Instance233"]["Name"] = "ScanResults";
    objects["Instance233"]["SelectionOrder"] = 0;
    objects["Instance233"]["Visible"] = true;
    objects["Instance233"]["Selectable"] = false;
    objects["Instance233"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance233"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance234"]["Visible"] = true;
    objects["Instance234"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance234"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance234"]["Active"] = false;
    objects["Instance234"]["TextStrokeTransparency"] = 1;
    objects["Instance234"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance234"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance234"]["ZIndex"] = 1;
    objects["Instance234"]["BorderSizePixel"] = 0;
    objects["Instance234"]["Draggable"] = false;
    objects["Instance234"]["RichText"] = false;
    objects["Instance234"]["Transparency"] = 1;
    objects["Instance234"]["SelectionOrder"] = 0;
    objects["Instance234"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance234"]["TextScaled"] = true;
    objects["Instance234"]["TextWrap"] = true;
    objects["Instance234"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance234"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance234"]["Parent"] = objects["Instance233"];
    objects["Instance234"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance234"]["TextSize"] = 14;
    objects["Instance234"]["Position"] = UDim2.new(0.7749999761581421, 0, 0, 0);
    objects["Instance234"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance234"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.05999999865889549, 0);
    objects["Instance234"]["BackgroundTransparency"] = 1;
    objects["Instance234"]["LineHeight"] = 1;
    objects["Instance234"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance234"]["TextColor3"] = Color3.new(0.392157, 0.392157, 0.392157);
    objects["Instance234"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance234"]["Text"] = "Matches";
    objects["Instance234"]["LayoutOrder"] = 0;
    objects["Instance234"]["TextWrapped"] = true;
    objects["Instance234"]["Rotation"] = 0;
    objects["Instance234"]["TextTransparency"] = 0;
    objects["Instance234"]["Name"] = "TextLabel";
    objects["Instance234"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance234"]["ClipsDescendants"] = false;
    objects["Instance234"]["MaxVisibleGraphemes"] = -1;
    objects["Instance234"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance234"]["Selectable"] = false;

    objects["Instance235"]["Visible"] = true;
    objects["Instance235"]["Active"] = true;
    objects["Instance235"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance235"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance235"]["ZIndex"] = 1;
    objects["Instance235"]["BorderSizePixel"] = 0;
    objects["Instance235"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance235"]["Draggable"] = false;
    objects["Instance235"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance235"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance235"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance235"]["Transparency"] = 1;
    objects["Instance235"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance235"]["SelectionOrder"] = 0;
    objects["Instance235"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance235"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance235"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance235"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance235"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance235"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance235"]["Size"] = UDim2.new(0.984000027179718, 0, 0.9399999976158142, 0);
    objects["Instance235"]["ScrollBarImageColor3"] = Color3.new(0, 0, 0);
    objects["Instance235"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance235"]["Selectable"] = true;
    objects["Instance235"]["ClipsDescendants"] = true;
    objects["Instance235"]["ScrollBarImageTransparency"] = 0;
    objects["Instance235"]["ScrollBarThickness"] = 0;
    objects["Instance235"]["Parent"] = objects["Instance233"];
    objects["Instance235"]["BackgroundTransparency"] = 1;
    objects["Instance235"]["Rotation"] = 0;
    objects["Instance235"]["LayoutOrder"] = 0;
    objects["Instance235"]["Name"] = "List";
    objects["Instance235"]["Position"] = UDim2.new(0.01600000075995922, 0, 0.05999999865889549, 0);
    objects["Instance235"]["ScrollingEnabled"] = true;
    objects["Instance235"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance235"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance235"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance236"]["Visible"] = false;
    objects["Instance236"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance236"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance236"]["Active"] = false;
    objects["Instance236"]["TextStrokeTransparency"] = 1;
    objects["Instance236"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance236"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance236"]["ZIndex"] = 1;
    objects["Instance236"]["BorderSizePixel"] = 0;
    objects["Instance236"]["Draggable"] = false;
    objects["Instance236"]["RichText"] = false;
    objects["Instance236"]["Modal"] = false;
    objects["Instance236"]["AutoButtonColor"] = true;
    objects["Instance236"]["Transparency"] = 1;
    objects["Instance236"]["SelectionOrder"] = 0;
    objects["Instance236"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance236"]["TextScaled"] = false;
    objects["Instance236"]["TextWrap"] = false;
    objects["Instance236"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance236"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance236"]["Parent"] = objects["Instance235"];
    objects["Instance236"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance236"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance236"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance236"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance236"]["Selected"] = false;
    objects["Instance236"]["TextSize"] = 14;
    objects["Instance236"]["Size"] = UDim2.new(1, 0, 0.20000000298023224, 0);
    objects["Instance236"]["BackgroundTransparency"] = 1;
    objects["Instance236"]["TextWrapped"] = false;
    objects["Instance236"]["ClipsDescendants"] = false;
    objects["Instance236"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance236"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance236"]["Text"] = "";
    objects["Instance236"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance236"]["LayoutOrder"] = 0;
    objects["Instance236"]["Rotation"] = 0;
    objects["Instance236"]["LineHeight"] = 1;
    objects["Instance236"]["Name"] = "Log";
    objects["Instance236"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance236"]["Selectable"] = false;
    objects["Instance236"]["MaxVisibleGraphemes"] = -1;
    objects["Instance236"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance236"]["TextTransparency"] = 0;

    objects["Instance237"]["LayoutOrder"] = 0;
    objects["Instance237"]["Active"] = false;
    objects["Instance237"]["Parent"] = objects["Instance236"];
    objects["Instance237"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance237"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance237"]["ZIndex"] = 1;
    objects["Instance237"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance237"]["Size"] = UDim2.new(1, -2, 0.699999988079071, 0);
    objects["Instance237"]["Draggable"] = false;
    objects["Instance237"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance237"]["ClipsDescendants"] = false;
    objects["Instance237"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance237"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance237"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance237"]["BorderSizePixel"] = 0;
    objects["Instance237"]["Rotation"] = 0;
    objects["Instance237"]["Transparency"] = 0.949999988079071;
    objects["Instance237"]["Name"] = "Contents";
    objects["Instance237"]["SelectionOrder"] = 0;
    objects["Instance237"]["Visible"] = true;
    objects["Instance237"]["Selectable"] = false;
    objects["Instance237"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance237"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance238"]["Enabled"] = true;
    objects["Instance238"]["Transparency"] = 0.5;
    objects["Instance238"]["Name"] = "UIStroke";
    objects["Instance238"]["LineJoinMode"] = Enum.LineJoinMode.Round;
    objects["Instance238"]["Parent"] = objects["Instance237"];
    objects["Instance238"]["Thickness"] = 1;
    objects["Instance238"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance238"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

    objects["Instance239"]["Parent"] = objects["Instance237"];
    objects["Instance239"]["Name"] = "UICorner";
    objects["Instance239"]["CornerRadius"] = UDim.new(0.200000003, 0);

    objects["Instance240"]["Visible"] = true;
    objects["Instance240"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance240"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance240"]["Active"] = false;
    objects["Instance240"]["TextStrokeTransparency"] = 1;
    objects["Instance240"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance240"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance240"]["ZIndex"] = 1;
    objects["Instance240"]["BorderSizePixel"] = 0;
    objects["Instance240"]["Draggable"] = false;
    objects["Instance240"]["RichText"] = false;
    objects["Instance240"]["Transparency"] = 1;
    objects["Instance240"]["SelectionOrder"] = 0;
    objects["Instance240"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance240"]["TextScaled"] = true;
    objects["Instance240"]["TextWrap"] = true;
    objects["Instance240"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance240"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance240"]["Parent"] = objects["Instance237"];
    objects["Instance240"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance240"]["TextSize"] = 14;
    objects["Instance240"]["Position"] = UDim2.new(0.10000000149011612, 0, 0.3499999940395355, 0);
    objects["Instance240"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance240"]["Size"] = UDim2.new(0.699999988079071, 0, 0.75, 0);
    objects["Instance240"]["BackgroundTransparency"] = 1;
    objects["Instance240"]["LineHeight"] = 1;
    objects["Instance240"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance240"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance240"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance240"]["Text"] = "LocalScript";
    objects["Instance240"]["LayoutOrder"] = 0;
    objects["Instance240"]["TextWrapped"] = true;
    objects["Instance240"]["Rotation"] = 0;
    objects["Instance240"]["TextTransparency"] = 0;
    objects["Instance240"]["Name"] = "ScriptName";
    objects["Instance240"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance240"]["ClipsDescendants"] = false;
    objects["Instance240"]["MaxVisibleGraphemes"] = -1;
    objects["Instance240"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance240"]["Selectable"] = false;

    objects["Instance241"]["Visible"] = true;
    objects["Instance241"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance241"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance241"]["Active"] = false;
    objects["Instance241"]["TextStrokeTransparency"] = 1;
    objects["Instance241"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance241"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance241"]["ZIndex"] = 1;
    objects["Instance241"]["BorderSizePixel"] = 0;
    objects["Instance241"]["Draggable"] = false;
    objects["Instance241"]["RichText"] = false;
    objects["Instance241"]["Transparency"] = 1;
    objects["Instance241"]["SelectionOrder"] = 0;
    objects["Instance241"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance241"]["TextScaled"] = true;
    objects["Instance241"]["TextWrap"] = true;
    objects["Instance241"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance241"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance241"]["Parent"] = objects["Instance237"];
    objects["Instance241"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance241"]["TextSize"] = 14;
    objects["Instance241"]["Position"] = UDim2.new(0.7749999761581421, 0, 0.5, 0);
    objects["Instance241"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance241"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.6499999761581421, 0);
    objects["Instance241"]["BackgroundTransparency"] = 1;
    objects["Instance241"]["LineHeight"] = 1;
    objects["Instance241"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance241"]["TextColor3"] = Color3.new(0.168627, 0.694118, 1);
    objects["Instance241"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance241"]["Text"] = "6";
    objects["Instance241"]["LayoutOrder"] = 0;
    objects["Instance241"]["TextWrapped"] = true;
    objects["Instance241"]["Rotation"] = 0;
    objects["Instance241"]["TextTransparency"] = 0;
    objects["Instance241"]["Name"] = "Matches";
    objects["Instance241"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance241"]["ClipsDescendants"] = false;
    objects["Instance241"]["MaxVisibleGraphemes"] = -1;
    objects["Instance241"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance241"]["Selectable"] = false;

    objects["Instance242"]["Visible"] = true;
    objects["Instance242"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance242"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance242"]["Active"] = false;
    objects["Instance242"]["TextStrokeTransparency"] = 1;
    objects["Instance242"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance242"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance242"]["ZIndex"] = 1;
    objects["Instance242"]["BorderSizePixel"] = 0;
    objects["Instance242"]["Draggable"] = false;
    objects["Instance242"]["RichText"] = false;
    objects["Instance242"]["Transparency"] = 1;
    objects["Instance242"]["SelectionOrder"] = 0;
    objects["Instance242"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance242"]["TextScaled"] = true;
    objects["Instance242"]["TextWrap"] = true;
    objects["Instance242"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance242"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance242"]["Parent"] = objects["Instance237"];
    objects["Instance242"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance242"]["TextSize"] = 14;
    objects["Instance242"]["Position"] = UDim2.new(0.10000000149011612, 0, 0.75, 0);
    objects["Instance242"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance242"]["Size"] = UDim2.new(0.699999988079071, 0, 0.4000000059604645, 0);
    objects["Instance242"]["BackgroundTransparency"] = 1;
    objects["Instance242"]["LineHeight"] = 1;
    objects["Instance242"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance242"]["TextColor3"] = Color3.new(0.784314, 0.784314, 0.784314);
    objects["Instance242"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance242"]["Text"] = "workspace.LocalScript";
    objects["Instance242"]["LayoutOrder"] = 0;
    objects["Instance242"]["TextWrapped"] = true;
    objects["Instance242"]["Rotation"] = 0;
    objects["Instance242"]["TextTransparency"] = 0;
    objects["Instance242"]["Name"] = "ScriptPath";
    objects["Instance242"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance242"]["ClipsDescendants"] = false;
    objects["Instance242"]["MaxVisibleGraphemes"] = -1;
    objects["Instance242"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance242"]["Selectable"] = false;

    objects["Instance243"]["Visible"] = true;
    objects["Instance243"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance243"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.8999999761581421, 0);
    objects["Instance243"]["ImageTransparency"] = 0;
    objects["Instance243"]["Parent"] = objects["Instance237"];
    objects["Instance243"]["Position"] = UDim2.new(0.02500000037252903, 0, 0.5, 0);
    objects["Instance243"]["BackgroundTransparency"] = 1;
    objects["Instance243"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance243"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance243"]["Image"] = "rbxassetid://120549633847891";
    objects["Instance243"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance243"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance243"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance243"]["ZIndex"] = 1;
    objects["Instance243"]["BorderSizePixel"] = 0;
    objects["Instance243"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance243"]["Draggable"] = false;
    objects["Instance243"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance243"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance243"]["ClipsDescendants"] = false;
    objects["Instance243"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance243"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance243"]["LayoutOrder"] = 0;
    objects["Instance243"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance243"]["Rotation"] = 0;
    objects["Instance243"]["Transparency"] = 1;
    objects["Instance243"]["Name"] = "Icon";
    objects["Instance243"]["SelectionOrder"] = 0;
    objects["Instance243"]["SliceScale"] = 1;
    objects["Instance243"]["Selectable"] = false;
    objects["Instance243"]["Active"] = false;
    objects["Instance243"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance244"]["AspectRatio"] = 1;
    objects["Instance244"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance244"]["Parent"] = objects["Instance243"];
    objects["Instance244"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance244"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance245"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance245"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance245"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance245"]["Parent"] = objects["Instance235"];
    objects["Instance245"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance245"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance245"]["Name"] = "UIListLayout";
    objects["Instance245"]["Padding"] = UDim.new(-0.0350000001, 0);
    objects["Instance245"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance245"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance246"]["Visible"] = true;
    objects["Instance246"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance246"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance246"]["Active"] = false;
    objects["Instance246"]["TextStrokeTransparency"] = 1;
    objects["Instance246"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance246"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance246"]["ZIndex"] = 1;
    objects["Instance246"]["BorderSizePixel"] = 0;
    objects["Instance246"]["Draggable"] = false;
    objects["Instance246"]["RichText"] = false;
    objects["Instance246"]["Transparency"] = 1;
    objects["Instance246"]["SelectionOrder"] = 0;
    objects["Instance246"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance246"]["TextScaled"] = true;
    objects["Instance246"]["TextWrap"] = true;
    objects["Instance246"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance246"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance246"]["Parent"] = objects["Instance233"];
    objects["Instance246"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance246"]["TextSize"] = 14;
    objects["Instance246"]["Position"] = UDim2.new(0.02500000037252903, 0, 0, 0);
    objects["Instance246"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance246"]["Size"] = UDim2.new(0.4000000059604645, 0, 0.05999999865889549, 0);
    objects["Instance246"]["BackgroundTransparency"] = 1;
    objects["Instance246"]["LineHeight"] = 1;
    objects["Instance246"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance246"]["TextColor3"] = Color3.new(0.392157, 0.392157, 0.392157);
    objects["Instance246"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance246"]["Text"] = "Script name";
    objects["Instance246"]["LayoutOrder"] = 0;
    objects["Instance246"]["TextWrapped"] = true;
    objects["Instance246"]["Rotation"] = 0;
    objects["Instance246"]["TextTransparency"] = 0;
    objects["Instance246"]["Name"] = "TextLabel";
    objects["Instance246"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance246"]["ClipsDescendants"] = false;
    objects["Instance246"]["MaxVisibleGraphemes"] = -1;
    objects["Instance246"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance246"]["Selectable"] = false;

    objects["Instance247"]["LayoutOrder"] = 0;
    objects["Instance247"]["Active"] = false;
    objects["Instance247"]["Parent"] = objects["Instance218"];
    objects["Instance247"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance247"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance247"]["ZIndex"] = 1;
    objects["Instance247"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance247"]["Size"] = UDim2.new(0.984000027179718, 0, 0, 1);
    objects["Instance247"]["Draggable"] = false;
    objects["Instance247"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance247"]["ClipsDescendants"] = false;
    objects["Instance247"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance247"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance247"]["BackgroundTransparency"] = 0.5;
    objects["Instance247"]["BorderSizePixel"] = 0;
    objects["Instance247"]["Rotation"] = 0;
    objects["Instance247"]["Transparency"] = 0.5;
    objects["Instance247"]["Name"] = "Separator";
    objects["Instance247"]["SelectionOrder"] = 0;
    objects["Instance247"]["Visible"] = true;
    objects["Instance247"]["Selectable"] = false;
    objects["Instance247"]["Position"] = UDim2.new(0, 0, 0, -1);
    objects["Instance247"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance248"]["LayoutOrder"] = 0;
    objects["Instance248"]["Active"] = false;
    objects["Instance248"]["Parent"] = objects["Instance209"];
    objects["Instance248"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance248"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance248"]["ZIndex"] = 1;
    objects["Instance248"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance248"]["Size"] = UDim2.new(1, 0, 0.125, 0);
    objects["Instance248"]["Draggable"] = false;
    objects["Instance248"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance248"]["ClipsDescendants"] = false;
    objects["Instance248"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance248"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance248"]["BackgroundTransparency"] = 1;
    objects["Instance248"]["BorderSizePixel"] = 0;
    objects["Instance248"]["Rotation"] = 0;
    objects["Instance248"]["Transparency"] = 1;
    objects["Instance248"]["Name"] = "Loading";
    objects["Instance248"]["SelectionOrder"] = 0;
    objects["Instance248"]["Visible"] = true;
    objects["Instance248"]["Selectable"] = false;
    objects["Instance248"]["Position"] = UDim2.new(0, 0, 0.8500000238418579, 0);
    objects["Instance248"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance249"]["GroupColor3"] = Color3.new(1, 1, 1);
    objects["Instance249"]["Name"] = "CanvasGroup";
    objects["Instance249"]["GroupTransparency"] = 0;
    objects["Instance249"]["Parent"] = objects["Instance248"];

    objects["Instance250"]["Parent"] = objects["Instance249"];
    objects["Instance250"]["Name"] = "UICorner";
    objects["Instance250"]["CornerRadius"] = UDim.new(1, 0);

    objects["Instance251"]["LayoutOrder"] = 0;
    objects["Instance251"]["Active"] = false;
    objects["Instance251"]["Parent"] = objects["Instance249"];
    objects["Instance251"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance251"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance251"]["ZIndex"] = 1;
    objects["Instance251"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance251"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance251"]["Draggable"] = false;
    objects["Instance251"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance251"]["ClipsDescendants"] = false;
    objects["Instance251"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance251"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance251"]["BackgroundTransparency"] = 0;
    objects["Instance251"]["BorderSizePixel"] = 0;
    objects["Instance251"]["Rotation"] = 0;
    objects["Instance251"]["Transparency"] = 0;
    objects["Instance251"]["Name"] = "Frame";
    objects["Instance251"]["SelectionOrder"] = 0;
    objects["Instance251"]["Visible"] = true;
    objects["Instance251"]["Selectable"] = false;
    objects["Instance251"]["Position"] = UDim2.new(-0.5, 0, 0, 0);
    objects["Instance251"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance252"]["LayoutOrder"] = 0;
    objects["Instance252"]["Active"] = false;
    objects["Instance252"]["Parent"] = objects["Instance251"];
    objects["Instance252"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance252"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance252"]["ZIndex"] = 1;
    objects["Instance252"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance252"]["Size"] = UDim2.new(0.10000000149011612, 0, 1, 0);
    objects["Instance252"]["Draggable"] = false;
    objects["Instance252"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance252"]["ClipsDescendants"] = false;
    objects["Instance252"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance252"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance252"]["BackgroundTransparency"] = 0;
    objects["Instance252"]["BorderSizePixel"] = 0;
    objects["Instance252"]["Rotation"] = 0;
    objects["Instance252"]["Transparency"] = 0;
    objects["Instance252"]["Name"] = "Gradient";
    objects["Instance252"]["SelectionOrder"] = 0;
    objects["Instance252"]["Visible"] = true;
    objects["Instance252"]["Selectable"] = false;
    objects["Instance252"]["Position"] = UDim2.new(1, 0, 0.5, 0);
    objects["Instance252"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance253"]["Offset"] = Vector2.new(0, 0);
    objects["Instance253"]["Transparency"] = NumberSequence.new({
    [1] = NumberSequenceKeypoint.new(0, 0.5, 0),
    [2] = NumberSequenceKeypoint.new(1, 1, 0)
});
    objects["Instance253"]["Name"] = "UIGradient";
    objects["Instance253"]["Parent"] = objects["Instance252"];
    objects["Instance253"]["Enabled"] = true;
    objects["Instance253"]["Color"] = ColorSequence.new({
    [1] = ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    [2] = ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
});
    objects["Instance253"]["Rotation"] = 0;

    objects["Instance254"]["Visible"] = false;
    objects["Instance254"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance254"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance254"]["Active"] = false;
    objects["Instance254"]["TextStrokeTransparency"] = 1;
    objects["Instance254"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance254"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance254"]["ZIndex"] = 1;
    objects["Instance254"]["BorderSizePixel"] = 0;
    objects["Instance254"]["Draggable"] = false;
    objects["Instance254"]["RichText"] = false;
    objects["Instance254"]["Transparency"] = 1;
    objects["Instance254"]["SelectionOrder"] = 0;
    objects["Instance254"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance254"]["TextScaled"] = true;
    objects["Instance254"]["TextWrap"] = true;
    objects["Instance254"]["FontFace"] = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance254"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance254"]["Parent"] = objects["Instance248"];
    objects["Instance254"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance254"]["TextSize"] = 14;
    objects["Instance254"]["Position"] = UDim2.new(0, 0, 0.25, 0);
    objects["Instance254"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance254"]["Size"] = UDim2.new(1, 0, 0.3499999940395355, 0);
    objects["Instance254"]["BackgroundTransparency"] = 1;
    objects["Instance254"]["LineHeight"] = 1;
    objects["Instance254"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance254"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance254"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance254"]["Text"] = "The tool is loading...";
    objects["Instance254"]["LayoutOrder"] = 0;
    objects["Instance254"]["TextWrapped"] = true;
    objects["Instance254"]["Rotation"] = 0;
    objects["Instance254"]["TextTransparency"] = 0;
    objects["Instance254"]["Name"] = "TextLabel";
    objects["Instance254"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance254"]["ClipsDescendants"] = false;
    objects["Instance254"]["MaxVisibleGraphemes"] = -1;
    objects["Instance254"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance254"]["Selectable"] = false;

    objects["Instance255"]["LayoutOrder"] = 0;
    objects["Instance255"]["Active"] = false;
    objects["Instance255"]["Parent"] = objects["Instance248"];
    objects["Instance255"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance255"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance255"]["ZIndex"] = 1;
    objects["Instance255"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance255"]["Size"] = UDim2.new(0.984000027179718, 0, 0, 1);
    objects["Instance255"]["Draggable"] = false;
    objects["Instance255"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance255"]["ClipsDescendants"] = false;
    objects["Instance255"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance255"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance255"]["BackgroundTransparency"] = 0.5;
    objects["Instance255"]["BorderSizePixel"] = 0;
    objects["Instance255"]["Rotation"] = 0;
    objects["Instance255"]["Transparency"] = 0.5;
    objects["Instance255"]["Name"] = "Separator";
    objects["Instance255"]["SelectionOrder"] = 0;
    objects["Instance255"]["Visible"] = true;
    objects["Instance255"]["Selectable"] = false;
    objects["Instance255"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance255"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance256"]["Visible"] = true;
    objects["Instance256"]["FontSize"] = Enum.FontSize.Size8;
    objects["Instance256"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance256"]["Active"] = false;
    objects["Instance256"]["TextStrokeTransparency"] = 1;
    objects["Instance256"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance256"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance256"]["ZIndex"] = 1;
    objects["Instance256"]["BorderSizePixel"] = 0;
    objects["Instance256"]["Draggable"] = false;
    objects["Instance256"]["RichText"] = false;
    objects["Instance256"]["Modal"] = false;
    objects["Instance256"]["AutoButtonColor"] = true;
    objects["Instance256"]["Transparency"] = 0.949999988079071;
    objects["Instance256"]["SelectionOrder"] = 0;
    objects["Instance256"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance256"]["TextScaled"] = true;
    objects["Instance256"]["TextWrap"] = true;
    objects["Instance256"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance256"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance256"]["Parent"] = objects["Instance248"];
    objects["Instance256"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance256"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance256"]["Position"] = UDim2.new(0.01600000075995922, 0, 0.574999988079071, 0);
    objects["Instance256"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance256"]["Selected"] = false;
    objects["Instance256"]["TextSize"] = 8;
    objects["Instance256"]["Size"] = UDim2.new(0.9679999947547913, 0, 0.800000011920929, 0);
    objects["Instance256"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance256"]["TextWrapped"] = true;
    objects["Instance256"]["ClipsDescendants"] = true;
    objects["Instance256"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance256"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance256"]["Text"] = "Start Scanning";
    objects["Instance256"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance256"]["LayoutOrder"] = 0;
    objects["Instance256"]["Rotation"] = 0;
    objects["Instance256"]["LineHeight"] = 1;
    objects["Instance256"]["Name"] = "Start";
    objects["Instance256"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance256"]["Selectable"] = false;
    objects["Instance256"]["MaxVisibleGraphemes"] = -1;
    objects["Instance256"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance256"]["TextTransparency"] = 0;

    objects["Instance257"]["Parent"] = objects["Instance256"];
    objects["Instance257"]["Name"] = "UICorner";
    objects["Instance257"]["CornerRadius"] = UDim.new(0.200000003, 0);

    objects["Instance258"]["Enabled"] = true;
    objects["Instance258"]["Transparency"] = 0.5;
    objects["Instance258"]["Name"] = "UIStroke";
    objects["Instance258"]["LineJoinMode"] = Enum.LineJoinMode.Round;
    objects["Instance258"]["Parent"] = objects["Instance256"];
    objects["Instance258"]["Thickness"] = 1;
    objects["Instance258"]["Color"] = Color3.new(0, 0, 0);
    objects["Instance258"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

    objects["Instance259"]["PaddingTop"] = UDim.new(0.100000001, 0);
    objects["Instance259"]["Name"] = "UIPadding";
    objects["Instance259"]["Parent"] = objects["Instance256"];
    objects["Instance259"]["PaddingBottom"] = UDim.new(0.100000001, 0);
    objects["Instance259"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance259"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance260"]["LayoutOrder"] = 0;
    objects["Instance260"]["Active"] = false;
    objects["Instance260"]["Parent"] = objects["Instance83"];
    objects["Instance260"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance260"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance260"]["ZIndex"] = 1;
    objects["Instance260"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance260"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance260"]["Draggable"] = false;
    objects["Instance260"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance260"]["ClipsDescendants"] = true;
    objects["Instance260"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance260"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance260"]["BackgroundTransparency"] = 1;
    objects["Instance260"]["BorderSizePixel"] = 0;
    objects["Instance260"]["Rotation"] = 0;
    objects["Instance260"]["Transparency"] = 1;
    objects["Instance260"]["Name"] = "MemoryScanner";
    objects["Instance260"]["SelectionOrder"] = 0;
    objects["Instance260"]["Visible"] = false;
    objects["Instance260"]["Selectable"] = false;
    objects["Instance260"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance260"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance261"]["LayoutOrder"] = 0;
    objects["Instance261"]["Active"] = false;
    objects["Instance261"]["Parent"] = objects["Instance260"];
    objects["Instance261"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance261"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance261"]["ZIndex"] = 1;
    objects["Instance261"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance261"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance261"]["Draggable"] = false;
    objects["Instance261"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance261"]["ClipsDescendants"] = false;
    objects["Instance261"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance261"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance261"]["BackgroundTransparency"] = 1;
    objects["Instance261"]["BorderSizePixel"] = 0;
    objects["Instance261"]["Rotation"] = 0;
    objects["Instance261"]["Transparency"] = 1;
    objects["Instance261"]["Name"] = "Contents";
    objects["Instance261"]["SelectionOrder"] = 0;
    objects["Instance261"]["Visible"] = true;
    objects["Instance261"]["Selectable"] = false;
    objects["Instance261"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance261"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance262"]["Visible"] = true;
    objects["Instance262"]["FontSize"] = Enum.FontSize.Size8;
    objects["Instance262"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance262"]["Active"] = false;
    objects["Instance262"]["TextStrokeTransparency"] = 1;
    objects["Instance262"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance262"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance262"]["ZIndex"] = 1;
    objects["Instance262"]["BorderSizePixel"] = 0;
    objects["Instance262"]["Draggable"] = false;
    objects["Instance262"]["RichText"] = false;
    objects["Instance262"]["Modal"] = false;
    objects["Instance262"]["AutoButtonColor"] = false;
    objects["Instance262"]["Transparency"] = 0.5;
    objects["Instance262"]["SelectionOrder"] = 0;
    objects["Instance262"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance262"]["TextScaled"] = false;
    objects["Instance262"]["TextWrap"] = false;
    objects["Instance262"]["FontFace"] = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance262"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance262"]["Parent"] = objects["Instance261"];
    objects["Instance262"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance262"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance262"]["Position"] = UDim2.new(0.015999961644411087, 0, 0.024999942630529404, 0);
    objects["Instance262"]["BackgroundColor3"] = Color3.new(0, 0, 0);
    objects["Instance262"]["Selected"] = false;
    objects["Instance262"]["TextSize"] = 8;
    objects["Instance262"]["Size"] = UDim2.new(0.9683749675750732, 0, 0.10000000149011612, 0);
    objects["Instance262"]["BackgroundTransparency"] = 0.5;
    objects["Instance262"]["TextWrapped"] = false;
    objects["Instance262"]["ClipsDescendants"] = false;
    objects["Instance262"]["TextColor3"] = Color3.new(0.105882, 0.164706, 0.207843);
    objects["Instance262"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance262"]["Text"] = "";
    objects["Instance262"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance262"]["LayoutOrder"] = 0;
    objects["Instance262"]["Rotation"] = 0;
    objects["Instance262"]["LineHeight"] = 1;
    objects["Instance262"]["Name"] = "SearchBar";
    objects["Instance262"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance262"]["Selectable"] = false;
    objects["Instance262"]["MaxVisibleGraphemes"] = -1;
    objects["Instance262"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance262"]["TextTransparency"] = 0.25;

    objects["Instance263"]["Parent"] = objects["Instance262"];
    objects["Instance263"]["Name"] = "UICorner";
    objects["Instance263"]["CornerRadius"] = UDim.new(0.200000003, 0);

    objects["Instance264"]["Visible"] = true;
    objects["Instance264"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance264"]["Size"] = UDim2.new(0.6000000238418579, 0, 0.6000000238418579, 0);
    objects["Instance264"]["ImageTransparency"] = 0;
    objects["Instance264"]["Parent"] = objects["Instance262"];
    objects["Instance264"]["Position"] = UDim2.new(0.012500000186264515, 0, 0.5, 0);
    objects["Instance264"]["BackgroundTransparency"] = 1;
    objects["Instance264"]["ImageRectOffset"] = Vector2.new(0, 0);
    objects["Instance264"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance264"]["Image"] = "rbxassetid://93748616033191";
    objects["Instance264"]["TileSize"] = UDim2.new(1, 0, 1, 0);
    objects["Instance264"]["ImageRectSize"] = Vector2.new(0, 0);
    objects["Instance264"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance264"]["ZIndex"] = 1;
    objects["Instance264"]["BorderSizePixel"] = 0;
    objects["Instance264"]["SliceCenter"] = Rect.new(0, 0, 0, 0);
    objects["Instance264"]["Draggable"] = false;
    objects["Instance264"]["ScaleType"] = Enum.ScaleType.Stretch;
    objects["Instance264"]["ResampleMode"] = Enum.ResamplerMode.Default;
    objects["Instance264"]["ClipsDescendants"] = false;
    objects["Instance264"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance264"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance264"]["LayoutOrder"] = 0;
    objects["Instance264"]["ImageColor3"] = Color3.new(1, 1, 1);
    objects["Instance264"]["Rotation"] = 0;
    objects["Instance264"]["Transparency"] = 1;
    objects["Instance264"]["Name"] = "Icon";
    objects["Instance264"]["SelectionOrder"] = 0;
    objects["Instance264"]["SliceScale"] = 1;
    objects["Instance264"]["Selectable"] = false;
    objects["Instance264"]["Active"] = false;
    objects["Instance264"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance265"]["AspectRatio"] = 1;
    objects["Instance265"]["Name"] = "UIAspectRatioConstraint";
    objects["Instance265"]["Parent"] = objects["Instance264"];
    objects["Instance265"]["AspectType"] = Enum.AspectType.FitWithinMaxSize;
    objects["Instance265"]["DominantAxis"] = Enum.DominantAxis.Width;

    objects["Instance266"]["Enabled"] = true;
    objects["Instance266"]["Transparency"] = 0.5;
    objects["Instance266"]["Name"] = "UIStroke";
    objects["Instance266"]["LineJoinMode"] = Enum.LineJoinMode.Round;
    objects["Instance266"]["Parent"] = objects["Instance262"];
    objects["Instance266"]["Thickness"] = 1;
    objects["Instance266"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance266"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

    objects["Instance267"]["LayoutOrder"] = 0;
    objects["Instance267"]["Active"] = true;
    objects["Instance267"]["Parent"] = objects["Instance262"];
    objects["Instance267"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance267"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance267"]["ZIndex"] = 1;
    objects["Instance267"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance267"]["Size"] = UDim2.new(0.9200000166893005, 0, 0.6000000238418579, 0);
    objects["Instance267"]["Draggable"] = false;
    objects["Instance267"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance267"]["ClipsDescendants"] = true;
    objects["Instance267"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance267"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance267"]["BackgroundTransparency"] = 1;
    objects["Instance267"]["BorderSizePixel"] = 0;
    objects["Instance267"]["Rotation"] = 0;
    objects["Instance267"]["Transparency"] = 1;
    objects["Instance267"]["Name"] = "Field";
    objects["Instance267"]["SelectionOrder"] = 0;
    objects["Instance267"]["Visible"] = true;
    objects["Instance267"]["Selectable"] = true;
    objects["Instance267"]["Position"] = UDim2.new(0.05999999865889549, 0, 0.5, 0);
    objects["Instance267"]["BackgroundColor3"] = Color3.new(0.972549, 0.972549, 0.972549);

    objects["Instance268"]["LayoutOrder"] = 0;
    objects["Instance268"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance268"]["LineHeight"] = 1;
    objects["Instance268"]["Active"] = true;
    objects["Instance268"]["TextStrokeTransparency"] = 1;
    objects["Instance268"]["SelectionStart"] = -1;
    objects["Instance268"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance268"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance268"]["ZIndex"] = 1;
    objects["Instance268"]["BorderSizePixel"] = 0;
    objects["Instance268"]["TextEditable"] = true;
    objects["Instance268"]["Draggable"] = false;
    objects["Instance268"]["RichText"] = false;
    objects["Instance268"]["Transparency"] = 1;
    objects["Instance268"]["SelectionOrder"] = 0;
    objects["Instance268"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance268"]["TextScaled"] = true;
    objects["Instance268"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance268"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance268"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance268"]["Parent"] = objects["Instance267"];
    objects["Instance268"]["TextWrapped"] = true;
    objects["Instance268"]["MaxVisibleGraphemes"] = -1;
    objects["Instance268"]["Name"] = "TextBox";
    objects["Instance268"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance268"]["TextTransparency"] = 0;
    objects["Instance268"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance268"]["CursorPosition"] = 1;
    objects["Instance268"]["ClipsDescendants"] = false;
    objects["Instance268"]["PlaceholderText"] = "Address (0x1234567890) or string to search";
    objects["Instance268"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance268"]["Size"] = UDim2.new(999, 0, 1, 0);
    objects["Instance268"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance268"]["Selectable"] = true;
    objects["Instance268"]["ShowNativeInput"] = true;
    objects["Instance268"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance268"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance268"]["Text"] = "";
    objects["Instance268"]["TextSize"] = 14;
    objects["Instance268"]["Visible"] = true;
    objects["Instance268"]["Rotation"] = 0;
    objects["Instance268"]["MultiLine"] = false;
    objects["Instance268"]["BackgroundTransparency"] = 1;
    objects["Instance268"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance268"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance268"]["ClearTextOnFocus"] = false;
    objects["Instance268"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance268"]["TextWrap"] = true;

    objects["Instance269"]["LayoutOrder"] = 0;
    objects["Instance269"]["Active"] = false;
    objects["Instance269"]["Parent"] = objects["Instance261"];
    objects["Instance269"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance269"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance269"]["ZIndex"] = 1;
    objects["Instance269"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance269"]["Size"] = UDim2.new(1, 0, 0.8500000238418579, 0);
    objects["Instance269"]["Draggable"] = false;
    objects["Instance269"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance269"]["ClipsDescendants"] = false;
    objects["Instance269"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance269"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance269"]["BackgroundTransparency"] = 1;
    objects["Instance269"]["BorderSizePixel"] = 0;
    objects["Instance269"]["Rotation"] = 0;
    objects["Instance269"]["Transparency"] = 1;
    objects["Instance269"]["Name"] = "View";
    objects["Instance269"]["SelectionOrder"] = 0;
    objects["Instance269"]["Visible"] = true;
    objects["Instance269"]["Selectable"] = false;
    objects["Instance269"]["Position"] = UDim2.new(0, 0, 0.15000002086162567, 0);
    objects["Instance269"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance270"]["LayoutOrder"] = 0;
    objects["Instance270"]["Active"] = false;
    objects["Instance270"]["Parent"] = objects["Instance269"];
    objects["Instance270"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance270"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance270"]["ZIndex"] = 1;
    objects["Instance270"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance270"]["Size"] = UDim2.new(0.9843750596046448, 0, 1, 0);
    objects["Instance270"]["Draggable"] = false;
    objects["Instance270"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance270"]["ClipsDescendants"] = false;
    objects["Instance270"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance270"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance270"]["BackgroundTransparency"] = 1;
    objects["Instance270"]["BorderSizePixel"] = 0;
    objects["Instance270"]["Rotation"] = 0;
    objects["Instance270"]["Transparency"] = 1;
    objects["Instance270"]["Name"] = "ScanResults";
    objects["Instance270"]["SelectionOrder"] = 0;
    objects["Instance270"]["Visible"] = true;
    objects["Instance270"]["Selectable"] = false;
    objects["Instance270"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance270"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance271"]["Visible"] = true;
    objects["Instance271"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance271"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance271"]["Active"] = false;
    objects["Instance271"]["TextStrokeTransparency"] = 1;
    objects["Instance271"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance271"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance271"]["ZIndex"] = 1;
    objects["Instance271"]["BorderSizePixel"] = 0;
    objects["Instance271"]["Draggable"] = false;
    objects["Instance271"]["RichText"] = false;
    objects["Instance271"]["Transparency"] = 1;
    objects["Instance271"]["SelectionOrder"] = 0;
    objects["Instance271"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance271"]["TextScaled"] = true;
    objects["Instance271"]["TextWrap"] = true;
    objects["Instance271"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance271"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance271"]["Parent"] = objects["Instance270"];
    objects["Instance271"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance271"]["TextSize"] = 14;
    objects["Instance271"]["Position"] = UDim2.new(0.7749999761581421, 0, 0, 0);
    objects["Instance271"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance271"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.05999999865889549, 0);
    objects["Instance271"]["BackgroundTransparency"] = 1;
    objects["Instance271"]["LineHeight"] = 1;
    objects["Instance271"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance271"]["TextColor3"] = Color3.new(0.392157, 0.392157, 0.392157);
    objects["Instance271"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance271"]["Text"] = "Matches";
    objects["Instance271"]["LayoutOrder"] = 0;
    objects["Instance271"]["TextWrapped"] = true;
    objects["Instance271"]["Rotation"] = 0;
    objects["Instance271"]["TextTransparency"] = 0;
    objects["Instance271"]["Name"] = "TextLabel";
    objects["Instance271"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance271"]["ClipsDescendants"] = false;
    objects["Instance271"]["MaxVisibleGraphemes"] = -1;
    objects["Instance271"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance271"]["Selectable"] = false;

    objects["Instance272"]["Visible"] = true;
    objects["Instance272"]["Active"] = true;
    objects["Instance272"]["ScrollingDirection"] = Enum.ScrollingDirection.XY;
    objects["Instance272"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance272"]["ZIndex"] = 1;
    objects["Instance272"]["BorderSizePixel"] = 0;
    objects["Instance272"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
    objects["Instance272"]["Draggable"] = false;
    objects["Instance272"]["MidImage"] = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    objects["Instance272"]["CanvasPosition"] = Vector2.new(0, 0);
    objects["Instance272"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance272"]["Transparency"] = 1;
    objects["Instance272"]["TopImage"] = "rbxasset://textures/ui/Scroll/scroll-top.png";
    objects["Instance272"]["SelectionOrder"] = 0;
    objects["Instance272"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.None;
    objects["Instance272"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance272"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
    objects["Instance272"]["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Right;
    objects["Instance272"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance272"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance272"]["Size"] = UDim2.new(0.984000027179718, 0, 0.9399999976158142, 0);
    objects["Instance272"]["ScrollBarImageColor3"] = Color3.new(0, 0, 0);
    objects["Instance272"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance272"]["Selectable"] = true;
    objects["Instance272"]["ClipsDescendants"] = true;
    objects["Instance272"]["ScrollBarImageTransparency"] = 0;
    objects["Instance272"]["ScrollBarThickness"] = 0;
    objects["Instance272"]["Parent"] = objects["Instance270"];
    objects["Instance272"]["BackgroundTransparency"] = 1;
    objects["Instance272"]["Rotation"] = 0;
    objects["Instance272"]["LayoutOrder"] = 0;
    objects["Instance272"]["Name"] = "List";
    objects["Instance272"]["Position"] = UDim2.new(0.01600000075995922, 0, 0.05999999865889549, 0);
    objects["Instance272"]["ScrollingEnabled"] = true;
    objects["Instance272"]["BottomImage"] = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
    objects["Instance272"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance272"]["ElasticBehavior"] = Enum.ElasticBehavior.WhenScrollable;

    objects["Instance273"]["Visible"] = true;
    objects["Instance273"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance273"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance273"]["Active"] = false;
    objects["Instance273"]["TextStrokeTransparency"] = 1;
    objects["Instance273"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance273"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance273"]["ZIndex"] = 1;
    objects["Instance273"]["BorderSizePixel"] = 0;
    objects["Instance273"]["Draggable"] = false;
    objects["Instance273"]["RichText"] = false;
    objects["Instance273"]["Modal"] = false;
    objects["Instance273"]["AutoButtonColor"] = true;
    objects["Instance273"]["Transparency"] = 1;
    objects["Instance273"]["SelectionOrder"] = 0;
    objects["Instance273"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance273"]["TextScaled"] = false;
    objects["Instance273"]["TextWrap"] = false;
    objects["Instance273"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance273"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance273"]["Parent"] = objects["Instance272"];
    objects["Instance273"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance273"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance273"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance273"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance273"]["Selected"] = false;
    objects["Instance273"]["TextSize"] = 14;
    objects["Instance273"]["Size"] = UDim2.new(1, 0, 0.20000000298023224, 0);
    objects["Instance273"]["BackgroundTransparency"] = 1;
    objects["Instance273"]["TextWrapped"] = false;
    objects["Instance273"]["ClipsDescendants"] = false;
    objects["Instance273"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance273"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance273"]["Text"] = "";
    objects["Instance273"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance273"]["LayoutOrder"] = 0;
    objects["Instance273"]["Rotation"] = 0;
    objects["Instance273"]["LineHeight"] = 1;
    objects["Instance273"]["Name"] = "Log";
    objects["Instance273"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance273"]["Selectable"] = false;
    objects["Instance273"]["MaxVisibleGraphemes"] = -1;
    objects["Instance273"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance273"]["TextTransparency"] = 0;

    objects["Instance274"]["LayoutOrder"] = 0;
    objects["Instance274"]["Active"] = false;
    objects["Instance274"]["Parent"] = objects["Instance273"];
    objects["Instance274"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    objects["Instance274"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance274"]["ZIndex"] = 1;
    objects["Instance274"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance274"]["Size"] = UDim2.new(1, -2, 0.699999988079071, 0);
    objects["Instance274"]["Draggable"] = false;
    objects["Instance274"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance274"]["ClipsDescendants"] = false;
    objects["Instance274"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance274"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance274"]["BackgroundTransparency"] = 0.949999988079071;
    objects["Instance274"]["BorderSizePixel"] = 0;
    objects["Instance274"]["Rotation"] = 0;
    objects["Instance274"]["Transparency"] = 0.949999988079071;
    objects["Instance274"]["Name"] = "Contents";
    objects["Instance274"]["SelectionOrder"] = 0;
    objects["Instance274"]["Visible"] = true;
    objects["Instance274"]["Selectable"] = false;
    objects["Instance274"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance274"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance275"]["Enabled"] = true;
    objects["Instance275"]["Transparency"] = 0.5;
    objects["Instance275"]["Name"] = "UIStroke";
    objects["Instance275"]["LineJoinMode"] = Enum.LineJoinMode.Round;
    objects["Instance275"]["Parent"] = objects["Instance274"];
    objects["Instance275"]["Thickness"] = 1;
    objects["Instance275"]["Color"] = Color3.new(0.294118, 0.294118, 0.294118);
    objects["Instance275"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

    objects["Instance276"]["Parent"] = objects["Instance274"];
    objects["Instance276"]["Name"] = "UICorner";
    objects["Instance276"]["CornerRadius"] = UDim.new(0.200000003, 0);

    objects["Instance277"]["Visible"] = true;
    objects["Instance277"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance277"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance277"]["Active"] = false;
    objects["Instance277"]["TextStrokeTransparency"] = 1;
    objects["Instance277"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance277"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance277"]["ZIndex"] = 1;
    objects["Instance277"]["BorderSizePixel"] = 0;
    objects["Instance277"]["Draggable"] = false;
    objects["Instance277"]["RichText"] = false;
    objects["Instance277"]["Transparency"] = 1;
    objects["Instance277"]["SelectionOrder"] = 0;
    objects["Instance277"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance277"]["TextScaled"] = true;
    objects["Instance277"]["TextWrap"] = true;
    objects["Instance277"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance277"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance277"]["Parent"] = objects["Instance274"];
    objects["Instance277"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance277"]["TextSize"] = 14;
    objects["Instance277"]["Position"] = UDim2.new(0.05000000074505806, 0, 0.5, 0);
    objects["Instance277"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance277"]["Size"] = UDim2.new(0.699999988079071, 0, 0.6499999761581421, 0);
    objects["Instance277"]["BackgroundTransparency"] = 1;
    objects["Instance277"]["LineHeight"] = 1;
    objects["Instance277"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance277"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance277"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance277"]["Text"] = "table: 0x1234567890";
    objects["Instance277"]["LayoutOrder"] = 0;
    objects["Instance277"]["TextWrapped"] = true;
    objects["Instance277"]["Rotation"] = 0;
    objects["Instance277"]["TextTransparency"] = 0;
    objects["Instance277"]["Name"] = "Value";
    objects["Instance277"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    objects["Instance277"]["ClipsDescendants"] = false;
    objects["Instance277"]["MaxVisibleGraphemes"] = -1;
    objects["Instance277"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance277"]["Selectable"] = false;

    objects["Instance278"]["Visible"] = true;
    objects["Instance278"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance278"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance278"]["Active"] = false;
    objects["Instance278"]["TextStrokeTransparency"] = 1;
    objects["Instance278"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance278"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance278"]["ZIndex"] = 1;
    objects["Instance278"]["BorderSizePixel"] = 0;
    objects["Instance278"]["Draggable"] = false;
    objects["Instance278"]["RichText"] = false;
    objects["Instance278"]["Transparency"] = 1;
    objects["Instance278"]["SelectionOrder"] = 0;
    objects["Instance278"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance278"]["TextScaled"] = true;
    objects["Instance278"]["TextWrap"] = true;
    objects["Instance278"]["FontFace"] = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance278"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance278"]["Parent"] = objects["Instance274"];
    objects["Instance278"]["AnchorPoint"] = Vector2.new(0, 0.5);
    objects["Instance278"]["TextSize"] = 14;
    objects["Instance278"]["Position"] = UDim2.new(0.7749999761581421, 0, 0.5, 0);
    objects["Instance278"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance278"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.6499999761581421, 0);
    objects["Instance278"]["BackgroundTransparency"] = 1;
    objects["Instance278"]["LineHeight"] = 1;
    objects["Instance278"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance278"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance278"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance278"]["Text"] = "6";
    objects["Instance278"]["LayoutOrder"] = 0;
    objects["Instance278"]["TextWrapped"] = true;
    objects["Instance278"]["Rotation"] = 0;
    objects["Instance278"]["TextTransparency"] = 0;
    objects["Instance278"]["Name"] = "Matches";
    objects["Instance278"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance278"]["ClipsDescendants"] = false;
    objects["Instance278"]["MaxVisibleGraphemes"] = -1;
    objects["Instance278"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance278"]["Selectable"] = false;

    objects["Instance279"]["FillDirection"] = Enum.FillDirection.Vertical;
    objects["Instance279"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Left;
    objects["Instance279"]["VerticalFlex"] = Enum.UIFlexAlignment.None;
    objects["Instance279"]["Parent"] = objects["Instance272"];
    objects["Instance279"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
    objects["Instance279"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
    objects["Instance279"]["Name"] = "UIListLayout";
    objects["Instance279"]["Padding"] = UDim.new(-0.0350000001, 0);
    objects["Instance279"]["ItemLineAlignment"] = Enum.ItemLineAlignment.Automatic;
    objects["Instance279"]["HorizontalFlex"] = Enum.UIFlexAlignment.None;

    objects["Instance280"]["Visible"] = true;
    objects["Instance280"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance280"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance280"]["Active"] = false;
    objects["Instance280"]["TextStrokeTransparency"] = 1;
    objects["Instance280"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance280"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance280"]["ZIndex"] = 1;
    objects["Instance280"]["BorderSizePixel"] = 0;
    objects["Instance280"]["Draggable"] = false;
    objects["Instance280"]["RichText"] = false;
    objects["Instance280"]["Transparency"] = 1;
    objects["Instance280"]["SelectionOrder"] = 0;
    objects["Instance280"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance280"]["TextScaled"] = true;
    objects["Instance280"]["TextWrap"] = true;
    objects["Instance280"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance280"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance280"]["Parent"] = objects["Instance270"];
    objects["Instance280"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance280"]["TextSize"] = 14;
    objects["Instance280"]["Position"] = UDim2.new(0.02500000037252903, 0, 0, 0);
    objects["Instance280"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance280"]["Size"] = UDim2.new(0.3499999940395355, 0, 0.05999999865889549, 0);
    objects["Instance280"]["BackgroundTransparency"] = 1;
    objects["Instance280"]["LineHeight"] = 1;
    objects["Instance280"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance280"]["TextColor3"] = Color3.new(0.392157, 0.392157, 0.392157);
    objects["Instance280"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance280"]["Text"] = "Address / name";
    objects["Instance280"]["LayoutOrder"] = 0;
    objects["Instance280"]["TextWrapped"] = true;
    objects["Instance280"]["Rotation"] = 0;
    objects["Instance280"]["TextTransparency"] = 0;
    objects["Instance280"]["Name"] = "TextLabel";
    objects["Instance280"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance280"]["ClipsDescendants"] = false;
    objects["Instance280"]["MaxVisibleGraphemes"] = -1;
    objects["Instance280"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance280"]["Selectable"] = false;

    objects["Instance281"]["LayoutOrder"] = 0;
    objects["Instance281"]["Active"] = false;
    objects["Instance281"]["Parent"] = objects["Instance269"];
    objects["Instance281"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance281"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance281"]["ZIndex"] = 1;
    objects["Instance281"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance281"]["Size"] = UDim2.new(0.984000027179718, 0, 0, 1);
    objects["Instance281"]["Draggable"] = false;
    objects["Instance281"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance281"]["ClipsDescendants"] = false;
    objects["Instance281"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance281"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance281"]["BackgroundTransparency"] = 0.5;
    objects["Instance281"]["BorderSizePixel"] = 0;
    objects["Instance281"]["Rotation"] = 0;
    objects["Instance281"]["Transparency"] = 0.5;
    objects["Instance281"]["Name"] = "Separator";
    objects["Instance281"]["SelectionOrder"] = 0;
    objects["Instance281"]["Visible"] = true;
    objects["Instance281"]["Selectable"] = false;
    objects["Instance281"]["Position"] = UDim2.new(0, 0, 0, -1);
    objects["Instance281"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance282"]["LayoutOrder"] = 0;
    objects["Instance282"]["Active"] = false;
    objects["Instance282"]["Parent"] = objects["Instance269"];
    objects["Instance282"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance282"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance282"]["ZIndex"] = 1;
    objects["Instance282"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance282"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance282"]["Draggable"] = false;
    objects["Instance282"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance282"]["ClipsDescendants"] = false;
    objects["Instance282"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance282"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance282"]["BackgroundTransparency"] = 1;
    objects["Instance282"]["BorderSizePixel"] = 0;
    objects["Instance282"]["Rotation"] = 0;
    objects["Instance282"]["Transparency"] = 1;
    objects["Instance282"]["Name"] = "Editor";
    objects["Instance282"]["SelectionOrder"] = 0;
    objects["Instance282"]["Visible"] = false;
    objects["Instance282"]["Selectable"] = false;
    objects["Instance282"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance282"]["BackgroundColor3"] = Color3.new(1, 1, 1);

    objects["Instance283"]["LayoutOrder"] = 0;
    objects["Instance283"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance283"]["LineHeight"] = 1;
    objects["Instance283"]["Active"] = true;
    objects["Instance283"]["TextStrokeTransparency"] = 1;
    objects["Instance283"]["SelectionStart"] = -1;
    objects["Instance283"]["PlaceholderColor3"] = Color3.new(0.7, 0.7, 0.7);
    objects["Instance283"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance283"]["ZIndex"] = 1;
    objects["Instance283"]["BorderSizePixel"] = 0;
    objects["Instance283"]["TextEditable"] = true;
    objects["Instance283"]["Draggable"] = false;
    objects["Instance283"]["RichText"] = false;
    objects["Instance283"]["Transparency"] = 0.9750000238418579;
    objects["Instance283"]["SelectionOrder"] = 0;
    objects["Instance283"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance283"]["TextScaled"] = false;
    objects["Instance283"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance283"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance283"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance283"]["Parent"] = objects["Instance282"];
    objects["Instance283"]["TextWrapped"] = false;
    objects["Instance283"]["MaxVisibleGraphemes"] = -1;
    objects["Instance283"]["Name"] = "TextBox";
    objects["Instance283"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance283"]["TextTransparency"] = 0;
    objects["Instance283"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance283"]["CursorPosition"] = 1;
    objects["Instance283"]["ClipsDescendants"] = false;
    objects["Instance283"]["PlaceholderText"] = "";
    objects["Instance283"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance283"]["Size"] = UDim2.new(1, 0, 0.8999999761581421, 0);
    objects["Instance283"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance283"]["Selectable"] = true;
    objects["Instance283"]["ShowNativeInput"] = true;
    objects["Instance283"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance283"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance283"]["Text"] = "cod editor zon :)))";
    objects["Instance283"]["TextSize"] = 14;
    objects["Instance283"]["Visible"] = true;
    objects["Instance283"]["Rotation"] = 0;
    objects["Instance283"]["MultiLine"] = false;
    objects["Instance283"]["BackgroundTransparency"] = 0.9750000238418579;
    objects["Instance283"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance283"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance283"]["ClearTextOnFocus"] = true;
    objects["Instance283"]["Position"] = UDim2.new(0, 0, 0.10000000149011612, 0);
    objects["Instance283"]["TextWrap"] = false;

    objects["Instance284"]["LayoutOrder"] = 0;
    objects["Instance284"]["Active"] = false;
    objects["Instance284"]["Parent"] = objects["Instance283"];
    objects["Instance284"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance284"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance284"]["ZIndex"] = 1;
    objects["Instance284"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance284"]["Size"] = UDim2.new(0.984000027179718, 0, 0, 1);
    objects["Instance284"]["Draggable"] = false;
    objects["Instance284"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance284"]["ClipsDescendants"] = false;
    objects["Instance284"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance284"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance284"]["BackgroundTransparency"] = 0.5;
    objects["Instance284"]["BorderSizePixel"] = 0;
    objects["Instance284"]["Rotation"] = 0;
    objects["Instance284"]["Transparency"] = 0.5;
    objects["Instance284"]["Name"] = "Separator";
    objects["Instance284"]["SelectionOrder"] = 0;
    objects["Instance284"]["Visible"] = true;
    objects["Instance284"]["Selectable"] = false;
    objects["Instance284"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance284"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance285"]["Visible"] = true;
    objects["Instance285"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance285"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance285"]["Active"] = true;
    objects["Instance285"]["TextStrokeTransparency"] = 1;
    objects["Instance285"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance285"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance285"]["ZIndex"] = 1;
    objects["Instance285"]["BorderSizePixel"] = 0;
    objects["Instance285"]["Draggable"] = false;
    objects["Instance285"]["RichText"] = false;
    objects["Instance285"]["Modal"] = false;
    objects["Instance285"]["AutoButtonColor"] = true;
    objects["Instance285"]["Transparency"] = 0.8999999761581421;
    objects["Instance285"]["SelectionOrder"] = 0;
    objects["Instance285"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance285"]["TextScaled"] = true;
    objects["Instance285"]["TextWrap"] = true;
    objects["Instance285"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance285"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance285"]["Parent"] = objects["Instance282"];
    objects["Instance285"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance285"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance285"]["Position"] = UDim2.new(0.15000000596046448, 0, 0, 0);
    objects["Instance285"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance285"]["Selected"] = false;
    objects["Instance285"]["TextSize"] = 14;
    objects["Instance285"]["Size"] = UDim2.new(0.32499998807907104, 0, 0.10000000149011612, 0);
    objects["Instance285"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance285"]["TextWrapped"] = true;
    objects["Instance285"]["ClipsDescendants"] = false;
    objects["Instance285"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance285"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance285"]["Text"] = "Copy text to clipboard";
    objects["Instance285"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance285"]["LayoutOrder"] = 0;
    objects["Instance285"]["Rotation"] = 0;
    objects["Instance285"]["LineHeight"] = 1;
    objects["Instance285"]["Name"] = "CopyCode";
    objects["Instance285"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance285"]["Selectable"] = true;
    objects["Instance285"]["MaxVisibleGraphemes"] = -1;
    objects["Instance285"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance285"]["TextTransparency"] = 0;

    objects["Instance286"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance286"]["Name"] = "UIPadding";
    objects["Instance286"]["Parent"] = objects["Instance285"];
    objects["Instance286"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance286"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance286"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance287"]["LayoutOrder"] = 0;
    objects["Instance287"]["Active"] = false;
    objects["Instance287"]["Parent"] = objects["Instance285"];
    objects["Instance287"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance287"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance287"]["ZIndex"] = 1;
    objects["Instance287"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance287"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance287"]["Draggable"] = false;
    objects["Instance287"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance287"]["ClipsDescendants"] = false;
    objects["Instance287"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance287"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance287"]["BackgroundTransparency"] = 0.5;
    objects["Instance287"]["BorderSizePixel"] = 0;
    objects["Instance287"]["Rotation"] = 0;
    objects["Instance287"]["Transparency"] = 0.5;
    objects["Instance287"]["Name"] = "Frame";
    objects["Instance287"]["SelectionOrder"] = 0;
    objects["Instance287"]["Visible"] = true;
    objects["Instance287"]["Selectable"] = false;
    objects["Instance287"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance287"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance288"]["Visible"] = true;
    objects["Instance288"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance288"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance288"]["Active"] = true;
    objects["Instance288"]["TextStrokeTransparency"] = 1;
    objects["Instance288"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance288"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance288"]["ZIndex"] = 1;
    objects["Instance288"]["BorderSizePixel"] = 0;
    objects["Instance288"]["Draggable"] = false;
    objects["Instance288"]["RichText"] = false;
    objects["Instance288"]["Modal"] = false;
    objects["Instance288"]["AutoButtonColor"] = true;
    objects["Instance288"]["Transparency"] = 0.8999999761581421;
    objects["Instance288"]["SelectionOrder"] = 0;
    objects["Instance288"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance288"]["TextScaled"] = true;
    objects["Instance288"]["TextWrap"] = true;
    objects["Instance288"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance288"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance288"]["Parent"] = objects["Instance282"];
    objects["Instance288"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance288"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance288"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance288"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance288"]["Selected"] = false;
    objects["Instance288"]["TextSize"] = 14;
    objects["Instance288"]["Size"] = UDim2.new(0.15000000596046448, 0, 0.10000000149011612, 0);
    objects["Instance288"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance288"]["TextWrapped"] = true;
    objects["Instance288"]["ClipsDescendants"] = false;
    objects["Instance288"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance288"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance288"]["Text"] = "< Back";
    objects["Instance288"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance288"]["LayoutOrder"] = 0;
    objects["Instance288"]["Rotation"] = 0;
    objects["Instance288"]["LineHeight"] = 1;
    objects["Instance288"]["Name"] = "Back";
    objects["Instance288"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance288"]["Selectable"] = true;
    objects["Instance288"]["MaxVisibleGraphemes"] = -1;
    objects["Instance288"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance288"]["TextTransparency"] = 0;

    objects["Instance289"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance289"]["Name"] = "UIPadding";
    objects["Instance289"]["Parent"] = objects["Instance288"];
    objects["Instance289"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance289"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance289"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance290"]["LayoutOrder"] = 0;
    objects["Instance290"]["Active"] = false;
    objects["Instance290"]["Parent"] = objects["Instance288"];
    objects["Instance290"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance290"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance290"]["ZIndex"] = 1;
    objects["Instance290"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance290"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance290"]["Draggable"] = false;
    objects["Instance290"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance290"]["ClipsDescendants"] = false;
    objects["Instance290"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance290"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance290"]["BackgroundTransparency"] = 0.5;
    objects["Instance290"]["BorderSizePixel"] = 0;
    objects["Instance290"]["Rotation"] = 0;
    objects["Instance290"]["Transparency"] = 0.5;
    objects["Instance290"]["Name"] = "Frame";
    objects["Instance290"]["SelectionOrder"] = 0;
    objects["Instance290"]["Visible"] = true;
    objects["Instance290"]["Selectable"] = false;
    objects["Instance290"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance290"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance291"]["Visible"] = true;
    objects["Instance291"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance291"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance291"]["Active"] = true;
    objects["Instance291"]["TextStrokeTransparency"] = 1;
    objects["Instance291"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance291"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance291"]["ZIndex"] = 1;
    objects["Instance291"]["BorderSizePixel"] = 0;
    objects["Instance291"]["Draggable"] = false;
    objects["Instance291"]["RichText"] = false;
    objects["Instance291"]["Modal"] = false;
    objects["Instance291"]["AutoButtonColor"] = true;
    objects["Instance291"]["Transparency"] = 0.8999999761581421;
    objects["Instance291"]["SelectionOrder"] = 0;
    objects["Instance291"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance291"]["TextScaled"] = true;
    objects["Instance291"]["TextWrap"] = true;
    objects["Instance291"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance291"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance291"]["Parent"] = objects["Instance282"];
    objects["Instance291"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance291"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance291"]["Position"] = UDim2.new(0.4749999940395355, 0, 0, 0);
    objects["Instance291"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance291"]["Selected"] = false;
    objects["Instance291"]["TextSize"] = 14;
    objects["Instance291"]["Size"] = UDim2.new(0.32499998807907104, 0, 0.10000000149011612, 0);
    objects["Instance291"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance291"]["TextWrapped"] = true;
    objects["Instance291"]["ClipsDescendants"] = false;
    objects["Instance291"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance291"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance291"]["Text"] = "Generate search code";
    objects["Instance291"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance291"]["LayoutOrder"] = 0;
    objects["Instance291"]["Rotation"] = 0;
    objects["Instance291"]["LineHeight"] = 1;
    objects["Instance291"]["Name"] = "GenerateCode";
    objects["Instance291"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance291"]["Selectable"] = true;
    objects["Instance291"]["MaxVisibleGraphemes"] = -1;
    objects["Instance291"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance291"]["TextTransparency"] = 0;

    objects["Instance292"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance292"]["Name"] = "UIPadding";
    objects["Instance292"]["Parent"] = objects["Instance291"];
    objects["Instance292"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance292"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance292"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance293"]["LayoutOrder"] = 0;
    objects["Instance293"]["Active"] = false;
    objects["Instance293"]["Parent"] = objects["Instance291"];
    objects["Instance293"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance293"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance293"]["ZIndex"] = 1;
    objects["Instance293"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance293"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance293"]["Draggable"] = false;
    objects["Instance293"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance293"]["ClipsDescendants"] = false;
    objects["Instance293"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance293"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance293"]["BackgroundTransparency"] = 0.5;
    objects["Instance293"]["BorderSizePixel"] = 0;
    objects["Instance293"]["Rotation"] = 0;
    objects["Instance293"]["Transparency"] = 0.5;
    objects["Instance293"]["Name"] = "Frame";
    objects["Instance293"]["SelectionOrder"] = 0;
    objects["Instance293"]["Visible"] = true;
    objects["Instance293"]["Selectable"] = false;
    objects["Instance293"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance293"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance294"]["Visible"] = true;
    objects["Instance294"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance294"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance294"]["Active"] = true;
    objects["Instance294"]["TextStrokeTransparency"] = 1;
    objects["Instance294"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance294"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance294"]["ZIndex"] = 1;
    objects["Instance294"]["BorderSizePixel"] = 0;
    objects["Instance294"]["Draggable"] = false;
    objects["Instance294"]["RichText"] = false;
    objects["Instance294"]["Modal"] = false;
    objects["Instance294"]["AutoButtonColor"] = true;
    objects["Instance294"]["Transparency"] = 0.8999999761581421;
    objects["Instance294"]["SelectionOrder"] = 0;
    objects["Instance294"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance294"]["TextScaled"] = true;
    objects["Instance294"]["TextWrap"] = true;
    objects["Instance294"]["FontFace"] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance294"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance294"]["Parent"] = objects["Instance282"];
    objects["Instance294"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance294"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance294"]["Position"] = UDim2.new(0.800000011920929, 0, 0, 0);
    objects["Instance294"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance294"]["Selected"] = false;
    objects["Instance294"]["TextSize"] = 14;
    objects["Instance294"]["Size"] = UDim2.new(0.20000000298023224, 0, 0.10000000149011612, 0);
    objects["Instance294"]["BackgroundTransparency"] = 0.8999999761581421;
    objects["Instance294"]["TextWrapped"] = true;
    objects["Instance294"]["ClipsDescendants"] = false;
    objects["Instance294"]["TextColor3"] = Color3.new(1, 1, 1);
    objects["Instance294"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance294"]["Text"] = "Get parent";
    objects["Instance294"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance294"]["LayoutOrder"] = 0;
    objects["Instance294"]["Rotation"] = 0;
    objects["Instance294"]["LineHeight"] = 1;
    objects["Instance294"]["Name"] = "Parent";
    objects["Instance294"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance294"]["Selectable"] = true;
    objects["Instance294"]["MaxVisibleGraphemes"] = -1;
    objects["Instance294"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance294"]["TextTransparency"] = 0;

    objects["Instance295"]["PaddingTop"] = UDim.new(0.200000003, 0);
    objects["Instance295"]["Name"] = "UIPadding";
    objects["Instance295"]["Parent"] = objects["Instance294"];
    objects["Instance295"]["PaddingBottom"] = UDim.new(0.200000003, 0);
    objects["Instance295"]["PaddingLeft"] = UDim.new(0, 0);
    objects["Instance295"]["PaddingRight"] = UDim.new(0, 0);

    objects["Instance296"]["LayoutOrder"] = 0;
    objects["Instance296"]["Active"] = false;
    objects["Instance296"]["Parent"] = objects["Instance294"];
    objects["Instance296"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance296"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance296"]["ZIndex"] = 1;
    objects["Instance296"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance296"]["Size"] = UDim2.new(0, 1, 1, 0);
    objects["Instance296"]["Draggable"] = false;
    objects["Instance296"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance296"]["ClipsDescendants"] = false;
    objects["Instance296"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance296"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance296"]["BackgroundTransparency"] = 0.5;
    objects["Instance296"]["BorderSizePixel"] = 0;
    objects["Instance296"]["Rotation"] = 0;
    objects["Instance296"]["Transparency"] = 0.5;
    objects["Instance296"]["Name"] = "Frame";
    objects["Instance296"]["SelectionOrder"] = 0;
    objects["Instance296"]["Visible"] = true;
    objects["Instance296"]["Selectable"] = false;
    objects["Instance296"]["Position"] = UDim2.new(1, -1, 0, 0);
    objects["Instance296"]["BackgroundColor3"] = Color3.new(0.294118, 0.294118, 0.294118);

    objects["Instance297"]["Visible"] = false;
    objects["Instance297"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance297"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance297"]["Active"] = false;
    objects["Instance297"]["TextStrokeTransparency"] = 1;
    objects["Instance297"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance297"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance297"]["ZIndex"] = 1;
    objects["Instance297"]["BorderSizePixel"] = 0;
    objects["Instance297"]["Draggable"] = false;
    objects["Instance297"]["RichText"] = false;
    objects["Instance297"]["Transparency"] = 1;
    objects["Instance297"]["SelectionOrder"] = 0;
    objects["Instance297"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance297"]["TextScaled"] = true;
    objects["Instance297"]["TextWrap"] = true;
    objects["Instance297"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal, true);
    objects["Instance297"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance297"]["Parent"] = objects["Instance260"];
    objects["Instance297"]["AnchorPoint"] = Vector2.new(0.5, 0.75);
    objects["Instance297"]["TextSize"] = 14;
    objects["Instance297"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    objects["Instance297"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance297"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.15000000596046448, 0);
    objects["Instance297"]["BackgroundTransparency"] = 1;
    objects["Instance297"]["LineHeight"] = 1;
    objects["Instance297"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance297"]["TextColor3"] = Color3.new(0.784314, 0.784314, 0.784314);
    objects["Instance297"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance297"]["Text"] = "THIS TOOL IS UNAVAILABLE IN YOUR EXECUTOR";
    objects["Instance297"]["LayoutOrder"] = 0;
    objects["Instance297"]["TextWrapped"] = true;
    objects["Instance297"]["Rotation"] = 0;
    objects["Instance297"]["TextTransparency"] = 0;
    objects["Instance297"]["Name"] = "Unavailable";
    objects["Instance297"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance297"]["ClipsDescendants"] = false;
    objects["Instance297"]["MaxVisibleGraphemes"] = -1;
    objects["Instance297"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance297"]["Selectable"] = false;

    objects["Instance298"]["Visible"] = true;
    objects["Instance298"]["FontSize"] = Enum.FontSize.Size14;
    objects["Instance298"]["TextDirection"] = Enum.TextDirection.Auto;
    objects["Instance298"]["Active"] = true;
    objects["Instance298"]["TextStrokeTransparency"] = 1;
    objects["Instance298"]["TextTruncate"] = Enum.TextTruncate.None;
    objects["Instance298"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance298"]["ZIndex"] = 1;
    objects["Instance298"]["BorderSizePixel"] = 0;
    objects["Instance298"]["Draggable"] = false;
    objects["Instance298"]["RichText"] = false;
    objects["Instance298"]["Modal"] = false;
    objects["Instance298"]["AutoButtonColor"] = false;
    objects["Instance298"]["Transparency"] = 1;
    objects["Instance298"]["SelectionOrder"] = 0;
    objects["Instance298"]["TextYAlignment"] = Enum.TextYAlignment.Center;
    objects["Instance298"]["TextScaled"] = false;
    objects["Instance298"]["TextWrap"] = false;
    objects["Instance298"]["FontFace"] = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal, false);
    objects["Instance298"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance298"]["Parent"] = objects["Instance34"];
    objects["Instance298"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance298"]["Style"] = Enum.ButtonStyle.Custom;
    objects["Instance298"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance298"]["BackgroundColor3"] = Color3.new(1, 1, 1);
    objects["Instance298"]["Selected"] = false;
    objects["Instance298"]["TextSize"] = 14;
    objects["Instance298"]["Size"] = UDim2.new(0.07500000298023224, 0, 1, 0);
    objects["Instance298"]["BackgroundTransparency"] = 1;
    objects["Instance298"]["TextWrapped"] = false;
    objects["Instance298"]["ClipsDescendants"] = false;
    objects["Instance298"]["TextColor3"] = Color3.new(0, 0, 0);
    objects["Instance298"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance298"]["Text"] = "";
    objects["Instance298"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance298"]["LayoutOrder"] = 0;
    objects["Instance298"]["Rotation"] = 0;
    objects["Instance298"]["LineHeight"] = 1;
    objects["Instance298"]["Name"] = "Hover";
    objects["Instance298"]["TextXAlignment"] = Enum.TextXAlignment.Center;
    objects["Instance298"]["Selectable"] = true;
    objects["Instance298"]["MaxVisibleGraphemes"] = -1;
    objects["Instance298"]["TextStrokeColor3"] = Color3.new(0, 0, 0);
    objects["Instance298"]["TextTransparency"] = 0;

    objects["Instance299"]["Parent"] = objects["Instance19"];
    objects["Instance299"]["Name"] = "UICorner";
    objects["Instance299"]["CornerRadius"] = UDim.new(0.00999999978, 0);

    objects["Instance300"]["LayoutOrder"] = 0;
    objects["Instance300"]["Active"] = false;
    objects["Instance300"]["Parent"] = objects["Instance19"];
    objects["Instance300"]["AnchorPoint"] = Vector2.new(0, 0);
    objects["Instance300"]["SizeConstraint"] = Enum.SizeConstraint.RelativeXY;
    objects["Instance300"]["ZIndex"] = 999999999;
    objects["Instance300"]["AutomaticSize"] = Enum.AutomaticSize.None;
    objects["Instance300"]["Size"] = UDim2.new(1, 0, 1, 0);
    objects["Instance300"]["Draggable"] = false;
    objects["Instance300"]["Style"] = Enum.FrameStyle.Custom;
    objects["Instance300"]["ClipsDescendants"] = false;
    objects["Instance300"]["BorderColor3"] = Color3.new(0, 0, 0);
    objects["Instance300"]["BorderMode"] = Enum.BorderMode.Outline;
    objects["Instance300"]["BackgroundTransparency"] = 0;
    objects["Instance300"]["BorderSizePixel"] = 0;
    objects["Instance300"]["Rotation"] = 0;
    objects["Instance300"]["Transparency"] = 0;
    objects["Instance300"]["Name"] = "Overlay";
    objects["Instance300"]["SelectionOrder"] = 0;
    objects["Instance300"]["Visible"] = false;
    objects["Instance300"]["Selectable"] = false;
    objects["Instance300"]["Position"] = UDim2.new(0, 0, 0, 0);
    objects["Instance300"]["BackgroundColor3"] = Color3.new(0.105882, 0.105882, 0.105882);

    objects["Instance301"]["Parent"] = objects["Instance300"];
    objects["Instance301"]["Name"] = "UICorner";
    objects["Instance301"]["CornerRadius"] = UDim.new(0.0149999997, 0);
end;

-- Set modules
local o_require = require; local require;
local modules do
    modules = {};
    require = function(object)
        if modules[object] then
            return modules[object]();
        end
        return o_require(object);
    end;

    getfenv().require = require;

    modules[objects["Instance8"]] = function()
        local script = objects["Instance8"];
return {
    { "1.0", "Ketamine was released as CSpy (Cherry's Spy), having simple settings, remote & event spy." },
    { "1.1", "CSpy been renamed to Ketamine, added Script scanner & http spy." },
    { "1.2", "Fixed lags who been caused by Script scanner & improved it's speed, added ability to hook arguments in remote & event spies." },
    { "1.3", "Added changelogs, fixed http spy error (not fatal) on bad executors, added memory scanner. <b>Now unavailable pages such as memory scanner not visible on unsupported executors.</b>" }
}
    end;

    modules[objects["Instance12"]] = function()
        local script = objects["Instance12"];
return function(shared, page)
    local ui = page:FindFirstAncestorOfClass("ScreenGui")
    local cons = shared.Connections
    local hooks = shared.HookFunction -- custom safe hooks
    local settings = shared.Settings
    
    local codeBox = shared.CodeBox(page.TextBox, shared.UseEnv)
    codeBox.Text = "Welcome to Ketamine - Event Spy!\n-- Waiting for Bindables --"

    local logExample = page.Logs.Log
    logExample.Parent = page
    logExample.Visible = false


    local hooksAvailable = type(getfenv().hookmetamethod) == "function"
        and type(getfenv().hookfunction) == "function"
        and type(getfenv().getnamecallmethod) == "function"

    local logStack = shared:AddObject({ })
    local function append(list, ...)
        for i = 1, select("#", ...) do
            list[i] = select(i, ...) or false
        end
    end

    local stack = shared:AddObject({ })
    local function pop()
        table.clear(stack)

        for i = 1, 5 do
            table.insert(stack, logStack[1])
            table.remove(logStack, 1)
        end

        return unpack(stack)
    end

    local order = ((2 ^ 31) - 1)
    local selection = shared:AddObject({ })
    local ignore = shared:AddObject({ })
    local block = shared:AddObject({ })
    local hookArgs = shared:AddObject({ })
    local logSpeed = shared:AddObject({ })
    local logs = shared:AddObject({ })
    local limit = 4
    
    local function appendLog() -- never call that function inside the hooked function, because it will lack capabilities and cause an error
        if #logStack == 0 then return end

        local success, name, event, args, caller, got = pcall(pop)
        if not success or ignore[event.Name] or ignore[event] or settings.Ignore_spammy_logs and ((tonumber(logSpeed[event]) or 0) > limit or (tonumber(logSpeed[event.Name]) or 0) > limit) then return end
        local n = event.Name

        logSpeed[event] = (tonumber(logSpeed[event]) or 0) + 1
        logSpeed[n] = (tonumber(logSpeed[event]) or 0) + 1

        local log = shared:AddButton(logExample:Clone())

        table.insert(logs, 1, log)
        while #logs > math.max(settings.Maximum_log_amount * 5, 1) do
            local log = table.remove(logs, #logs)
            log:Destroy()
        end
        
        local sArgs = "-- Failed to convert arguments to string (somehow)"
        local path = shared.ToString.ToString(event)
        
        if not settings.Create_arguments_as_variable then
            sArgs = "-- " .. event.ClassName .. "\n\n" .. (event:IsA("BindableFunction") and "local result = " .. path .. ":Invoke" or path .. ":Fire") .. shared.ToString.CreateArguments(args)
        else
            sArgs = "-- " .. event.ClassName .. "\n\nlocal args = " .. shared.ToString.ToString(args, -1) .. "\n\n" .. (event:IsA("BindableFunction") and "local result = " .. path .. ":Invoke" or path .. ":Fire") .. "(unpack(args))"
        end
        
        local eArgs, changes = sArgs:gsub(shared.ToString.EscapePattern("game:GetService(\"HttpService\")"), "http")
        if changes >= 2 then
            local split = eArgs:split("\n")
            table.insert(split, 3, "local http = game:GetService(\"HttpService\")")
            
            sArgs = table.concat(split, "\n")
        end
        
        if settings.Create_event_as_variable then
            local split = sArgs:gsub(shared.ToString.EscapePattern(path), "object"):split("\n")
            table.insert(split, 3, "local object = " .. path)

            sArgs = table.concat(split, "\n")
        end

        log.Parent = page.Logs
        log.Visible = true
        log.LayoutOrder = order
        log.Contents.Frame.BackgroundColor3 = event:IsA("BindalbeFunction") and Color3.fromRGB(170, 85, 255) or Color3.fromRGB(255, 200)
        log.Contents.Label.Text = name
        log.Contents.Label.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.new(0.8), (block[event] or block[event.Name]) and event:IsA("BindableFunction") and 0.2 or 0):Lerp(Color3.new(0, 0.8, 0.4), hookArgs[event] or hookArgs[event.Name] and 0.2 or 0)
        cons[#cons + 1] = log.MouseButton1Click:Connect(function()
            for _, log in logs do
                if log and log.Parent then
                    log.Contents.Selection.BackgroundTransparency = 1
                end
            end
            
            log.Contents.Selection.BackgroundTransparency = 0.9
            
            selection[1] = event
            selection[2] = args
            selection[3] = got
            selection[4] = caller
            
            print(selection[4])
            
            codeBox.Text = sArgs
        end)
        
        order -= 1
        
        if event:IsA("BindableFunction") then
            while log.Parent and got and not got[1] do task.wait() end
            if got and got[1] then
                sArgs ..= "\n-- Got:\n--[[" .. shared.ToString.ToString(got[1]) .. "]]--" or ""
            end
        end
    end
    
    task.spawn(function()
        while task.wait(5) do
            for i in logSpeed do
                logSpeed[i] = 0
            end
        end
    end)

    cons[#cons + 1] = game:GetService("RunService").RenderStepped:Connect(function()
        while #logStack > 0 do
            task.spawn(appendLog)
        end
    end)

    local function addLogToStack(event, args, caller, got)
        local name = event.Name or tostring(event)
        if #name > 13 then
            name = name:sub(1, 11) .. "..."
        end

        append(logStack, name, event, args, caller or false, got or false)
    end
    
    local checkcaller = getfenv().checkcaller or function()
        return true
    end

    local caller
    local getcaller = getfenv().getcallingscript
    
    local function callcheck()
        local caller = checkcaller()
        if settings.Log_executor_function_calls == 1 and not caller or settings.Log_executor_function_calls == 2 or settings.Log_executor_function_calls == 3 and caller then
            return true
        end

        return false
    end

    if hooksAvailable then
        task.spawn(function()
            local fire = hooks.HookFunction(Instance.new("BindableEvent").Fire, function(old, self, ...)
                local cllr = caller
                caller = nil
                
                if typeof(self) ~= "Instance" or self.ClassName ~= "BindableEvent" then
                    return old(self, ...)
                end
                
                local args = shared:AddObject({ ... })
                local newArgs = hookArgs[self] or hookArgs[self.Name]
                if newArgs then
                    local max = 0
                    for idx, val in newArgs do
                        args[idx] = val
                    end
                end

                if callcheck() then
                    addLogToStack(self, args, cllr or getcaller(), nil)
                end; if block[self] or block[self.Name] then return end

                return old(self, unpack(args))
            end)

            local invoke = hooks.HookFunction(Instance.new("BindableFunction").Invoke, function(old, self, ...)
                local cllr = caller
                caller = nil

                if typeof(self) ~= "Instance" or self.ClassName ~= "BindableFunction" then
                    return old(self, ...)
                end

                local args = shared:AddObject({ ... })
                local newArgs = hookArgs[self] or hookArgs[self.Name]
                if newArgs then
                    local max = 0
                    for idx, val in newArgs do
                        args[idx] = val
                    end
                end

                if not block[self] and not block[self.Name] then
                    local got = shared:AddObject({ })
                    if callcheck() then
                        addLogToStack(self, cllr or getcaller(), args, got)
                    end

                    append(got, { old(self, unpack(args)) })
                    
                    return unpack(got[1])
                else
                    if callcheck() then
                        addLogToStack(self, cllr or getcaller(), args, nil)
                    end
                end
            end)
            
            local getnamecall = getfenv().getnamecallmethod
            hooks.HookMetaMethod("__namecall", function(old, self, ...)
                if typeof(self) ~= "Instance" then
                    return old(self, ...)
                end
                
                local method = getnamecall():gsub("\0", "")
                method = method:sub(1, 1):upper() .. method:sub(2)
                
                if getcaller then
                    caller = getcaller()
                end
                
                if method == "Fire" and self.ClassName == "BindableEvent" then
                    return fire(self, ...)
                elseif method == "Invoke" and self.ClassName == "BindableFunction" then
                    return invoke(self, ...)
                end
                
                return old(self, ...)
            end)
        end)
    else
        task.spawn(function()
            local setUp = shared:AddObject({ })
            local getcb = getfenv().getcallbackvalue

            local function setup(instance: Instance)
                if not instance or setUp[instance] then return end
                setUp[instance] = true

                if instance:IsA("BindableEvent") then
                    cons[#cons + 1] = instance.Event:Connect(function(...)
                        if settings.Log_executor_function_calls == 2 or instance:IsDescendantOf(ui) and settings.Log_executor_function_calls == 3 or not instance:IsDescendantOf(ui) and settings.Log_executor_function_calls == 1 then
                            addLogToStack(instance, shared:AddObject({ ... }), nil, nil)
                        end
                    end)
                elseif instance:IsA("BindableFunction") and getcb then
                    local success, value = pcall(getcb, instance, "OnInvoke")
                    if success and typeof(value) == "function" then
                        hooks.HookFunction(value, function(old, ...)
                            if settings.Log_executor_function_calls <= 2 then
                                local got = shared:AddObject({ })

                                addLogToStack(instance, shared:AddObject({ ... }), nil, got)
                                append(got, { old(...) })

                                return unpack(got[1])
                            else
                                return old(...)
                            end
                        end)
                    end
                end
            end

            if getfenv().getinstances then
                for _, v in getfenv().getinstances() do
                    task.spawn(setup, v)
                end
            end
            if getfenv().getnilinstances then
                for _, v in getfenv().getnilinstances() do
                    task.spawn(setup, v)
                end
            end

            for _, v in game:GetDescendants() do
                task.spawn(setup, v)
            end
            cons[#cons + 1] = game.DescendantAdded:Connect(setup)
        end)
    end
    
    local button = page.Buttons.Button
    button.Visible = false
    
    local function addButton(text, callback)
        local button = button:Clone()
        button.Parent = page.Buttons
        button.Visible = true
        button.Name = text
        
        if typeof(text) == "string" and text ~= "" then
            shared:AddButton(button)

            button.Separator:Destroy()
            button.Contents.Label.Text = text
            cons[#cons + 1] = button.MouseButton1Click:Connect(function()
                callback(button)
            end)
        else
            button.Contents:Destroy()
            button.Separator.Visible = true
        end
        
        return button
    end
    
    local clipboard = shared.Clipboard
    addButton("Copy code to clipboard", function()
        clipboard(codeBox.Text)
    end)
    addButton("Copy path to clipboard", function()
        if selection[1] then
            clipboard(shared.ToString.ToString(selection[1]))
        end
    end)
    addButton("Copy args to clipboard", function()
        if selection[1] then
            clipboard(shared.ToString.ToString(selection[2]))
        end
    end)
    addButton("Copy result to clipboard", function()
        if selection[3] and selection[3][1] then
            clipboard(shared.ToString.ToString(selection[3][1]))
        end
    end)
    addButton("Copy caller to clipboard", function()
        if selection[4] then
            clipboard(shared.ToString.ToString(selection[4]))
        end
    end)
    addButton("Run code", function()
        if selection[1] then
            if selection[1]:IsA("BindableFunction") then
                selection[1]:Invoke(unpack(selection[2]))
            else
                selection[1]:Fire(unpack(selection[2]))
            end
        end
    end)

    addButton("Block remote [Object]", function()
        if selection[1] then
            block[selection[1]] = true
        end
    end)
    addButton("Block remote [Name]", function()
        if selection[1] then
            block[selection[1].Name] = true
        end
    end)
    
    addButton("Clear logs", function()
        for _, log in logs do
            log:Destroy()
        end

        table.clear(logs)
    end)

    addButton("Ignore remote [Object]", function()
        if selection[1] then
            ignore[selection[1]] = true
        end
    end)
    addButton("Ignore remote [Name]", function()
        if selection[1] then
            ignore[selection[1].Name] = true
        end
    end)

    addButton("Decompile", function()
        if selection[4] then
            codeBox.Text = "local script = " .. shared.ToString.ToString(selection[4]) .. "\n" .. getfenv().decompile(selection[4])
        end
    end)
    
    local hooking = shared:AddObject({ false })
    addButton("Hook args [Object]", function(button)
        if hooking[1] and hooking[1] ~= button.Name then return end

        if not hooking[1] and selection[1] then
            hooking[1] = button.Name
            hooking[2] = selection[1]
            hooking[3] = codeBox.Text

            button.Contents.Label.Text = "HOOK"
            codeBox.Text = "return " .. shared.ToString.ToString(selection[2], -1)
        elseif hooking[1] then
            button.Contents.Label.Text = button.Name

            local su, func = pcall(loadstring, codeBox.Text)
            if su then
                local s, hookedResult = pcall(func)
                if typeof(hookedResult) == "table" then
                    hookArgs[hooking[2]] = hookedResult
                else
                    hookArgs[hooking[2]] = nil
                end
            else
                hookArgs[hooking[2]] = nil
            end

            codeBox.Text = hooking[3]

            hooking[1] = false
            hooking[2] = nil
            hooking[3] = nil
        end
    end)
    
    addButton("Hook args [Name]", function(button)
        if hooking[1] and hooking[1] ~= button.Name then return end
        
        if not hooking[1] and selection[1] then
            hooking[1] = button.Name
            hooking[2] = selection[1]
            hooking[3] = codeBox.Text
            
            button.Contents.Label.Text = "HOOK"
            codeBox.Text = "return " .. shared.ToString.ToString(selection[2], -1)
        elseif hooking[1] then
            button.Contents.Label.Text = button.Name
            
            local su, func = pcall(loadstring, codeBox.Text)
            if su then
                local s, hookedResult = pcall(func)
                if typeof(hookedResult) == "table" then
                    hookArgs[hooking[2].Name] = hookedResult
                else
                    hookArgs[hooking[2].Name] = nil
                end
            else
                hookArgs[hooking[2].Name] = nil
            end
            
            codeBox.Text = hooking[3]

            hooking[1] = false
            hooking[2] = nil
            hooking[3] = nil
        end
    end)

    addButton("return nil = unhook", pcall)
end
    end;

    modules[objects["Instance14"]] = function()
        local script = objects["Instance14"];
return function(shared, page)
    local cons = shared.Connections
    local hooks = shared.HookFunction -- custom safe hooks
    local settings = shared.Settings

    local codeBox = shared.CodeBox(page.Contents.View.Editor.TextBox, shared.UseEnv)
    codeBox.Text = ""

    local gsbc = getfenv().getscriptbytecode or function(scr)
        return "\0"
    end

    local badDecompile = function(scr)
        return-- scr.Name .. " " ..
            "-- \"decompile\" does not exist or failed"
    end

    local _decompile = getfenv().decompile or badDecompile
    local decompiling = 0
    
    local decompile = function(scr)
        while task.wait() do
            if decompiling <= settings.Decompile_limit then
                decompiling += 1
                local decompiled = _decompile(scr)
                decompiling -= 1
                
                return decompiled
            end
        end
    end

    local decompiled = { }
    local scripts, decompil = 1, 0

    local stuff = {
        ModuleScript = {
            Color3.fromRGB(165, 105, 255),
            "rbxassetid://72574623675660"
        },

        LocalScript = {
            Color3.fromRGB(43, 177, 255),
            "rbxassetid://120549633847891"
        }
    }

    local logg = page.Contents.View.ScanResults.List.Log
    logg.Visible = false

    local path
    local logs = { }

    local function keywordScan(scr, keywords)
        local _path = scr:IsDescendantOf(game) and "game." .. scr:GetFullName() or "(nil)[\"" .. scr.Name:gsub("\"", "\\\"") .. "\")"
        local src = _path .. "\n" .. decompiled[scr]:lower()
        local matches = 0

        for _, keyword in keywords do
            matches += (#src:split(keyword)) - 1
        end

        if matches > 0 then
            local tbl = (stuff[scr.ClassName] or stuff.LocalScript)
            local log = shared:AddButton(logg:Clone())
            log.Parent = logg.Parent
            log.Visible = true
            log.Contents.ScriptName.Text = scr.Name
            log.Contents.ScriptPath.Text = _path
            log.Contents.Matches.Text = matches
            log.LayoutOrder = matches
            log.Contents.Matches.TextColor3 = tbl[1]
            log.Contents.Icon.Image = tbl[2]
            logs[#logs + 1] = log

            cons[#cons + 1] = log.MouseButton1Click:Connect(function()
                page.Contents.View.ScanResults.Visible = false
                page.Contents.View.Editor.Visible = true

                codeBox.Text = decompiled[scr]
                path = _path
            end)

            --[[cons[#cons + 1] = scr.Destroying:Connect(function()
                table.remove(logs, table.find(logs, log))
                log:Destroy()
            end)]]
        end
    end

    task.spawn(function()
        local function dec(scr)
            if (game:GetService("CoreGui") and not scr:IsDescendantOf(game:GetService("CoreGui")) and not scr:IsDescendantOf(game:GetService("CorePackages")) or not game:GetService("CoreGui")) and (scr:IsA("LocalScript") or scr:IsA("ModuleScript") or scr:IsA("Script") and scr.RunContext == Enum.RunContext.Client) and not decompiled[scr] and #(gsbc and gsbc(scr) or "") ~= 0 then
                scripts += 1
                local decompi = decompile(scr)
                decompiled[scr] = decompi
                decompil += 1

                local text = page.Contents.SearchBar.Field.TextBox.Text:lower()

                if text:gsub(" ", ""):gsub("\t", ""):gsub("\r", ""):gsub("\n", "") ~= "" then
                    keywordScan(scr, text:gsub("; ", ";"):split(";"))
                end
            end
        end

        local started = false
        local function start()
            if started then return end
            started = true
            
            task.spawn(function()
                while scripts ~= decompil do
                    local max = math.max(#tostring(scripts), #tostring(decompil))
                    page.Loading.TextLabel.Text = "[ " .. string.format("%0" .. max .. "d", scripts) .. " / " .. string.format("%0" .. max .. "d", decompil) .. " ] The tool is loading..."
                    page.Loading.CanvasGroup.Frame.Position = UDim2.fromScale((decompil / scripts) - 1, 0)

                    task.wait()
                end

                page.Loading:TweenPosition(UDim2.fromScale(0, 1), nil, nil, 1, true)
                page.Contents:TweenSize(UDim2.fromScale(1, 1), nil, nil, 1, true)

                task.wait(1)

                page.Loading:Destroy()
            end)

            page.Loading.Start.Visible = false
            page.Loading.TextLabel.Visible = true
            page.Loading.CanvasGroup.Visible = true
            
            for i, v in (getfenv().getnilinstances and getfenv().getnilinstances() or { }) do
                task.spawn(dec, v)

                if i % 350 == 0 then
                    task.wait()
                end
            end

            for i, v in (getfenv().getinstances and getfenv().getinstances() or { }) do
                task.spawn(dec, v)

                if i % 350 == 0 then
                    task.wait()
                end
            end

            for i, v in game:GetDescendants() do
                task.spawn(dec, v)

                if i % 350 == 0 then
                    task.wait()
                end
            end

            cons[#cons + 1] = game.DescendantAdded:Connect(dec)

            task.wait(2.5)

            decompil += 1
        end
        
        page.Loading.Start.MouseButton1Click:Connect(start)
    end)

    local clipboard = shared.Clipboard

    cons[#cons + 1] = page.Contents.View.Editor.Back.MouseButton1Click:Connect(function()
        page.Contents.View.ScanResults.Visible = true
        page.Contents.View.Editor.Visible = false
    end)

    cons[#cons + 1] = page.Contents.View.Editor.CopyPath.MouseButton1Click:Connect(function()
        clipboard(path)
    end)

    cons[#cons + 1] = page.Contents.View.Editor.CopyCode.MouseButton1Click:Connect(function()
        clipboard(codeBox.Text)
    end)

    cons[#cons + 1] = page.Contents.SearchBar.Field.TextBox.FocusLost:Connect(function()
        local text = page.Contents.SearchBar.Field.TextBox.Text:lower()

        for _, v in logs do
            v:Destroy()
        end

        table.clear(logs)

        if text:gsub(" ", ""):gsub("\t", ""):gsub("\r", ""):gsub("\n", "") ~= "" then
            local keywords = text:gsub("; ", ";"):split(";")
            for scr in decompiled do
                keywordScan(scr, keywords)
            end
        end
    end)
end
    end;

    modules[objects["Instance6"]] = function()
        local script = objects["Instance6"];
local function normalize(str)
    return (str:gsub("\n", "\\n"):gsub("\t", "\\t"):gsub("\r", "\\r"):gsub("\"", "\\\""):gsub("\0", "\\0"))
end

local function escapePattern(str)
    return str:gsub("%%", "%%%%")
        :gsub("%.", "%%.")
        :gsub("%?", "%%?")
        :gsub("%!", "%%!")
        :gsub("%,", "%%,")
        :gsub("%[", "%%[")
        :gsub("%]", "%%]")
        :gsub("%(", "%%(")
        :gsub("%)", "%%)")
        :gsub("%{", "%%{")
        :gsub("%}", "%%}")
end

local alphabet = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm_1234567890"
local function isValidSymbol(s)
    return alphabet:find(escapePattern(s)) ~= nil
end

local function isValidVariableName(var)
    var = tostring(var)
    if not var or tonumber(var:sub(1,1)) then
        return false
    end

    for char in var:gmatch(".") do
        if not isValidSymbol(char) then
            return false
        end
    end

    return true
end

local function getPath(obj, normalNil, dontGetService)
    if not obj then
        return "nil"
    elseif obj == workspace.Parent or obj == game then
        return "game"
    elseif obj and not obj.Parent then
        local env = getfenv()
        local name = env.getnilinstances and "getnilinstances" or env.getnils and "getnils"
        if not normalNil and name then
            return ("(function()\n  local function getNil(objType, objName)\n    for _, v in %s() do\n      if v.ClassName == objType and v.Name == objName then\n        return v\n      end\n    end\n  end\n  return getNil(\"%s\", \"%s\")\nend)()")
                :format(name, obj.ClassName, normalize(obj.Name))
        elseif normalNil then
            return "(nil)[\"" .. normalize(obj.Name) .. "\"]"
        else
            return "(nil)[\"" .. normalize(obj.Name) .. "\"] --[[ Object is parented to nil; getnilinstances does not exist ]]"
        end
    end

    local path = ""
    while obj.Parent do
        if (obj.Parent == game or obj.Parent == workspace.Parent) and not dontGetService and pcall(game.GetService, game, obj.ClassName) and game:GetService(obj.ClassName) then
            path = "game:GetService(\"" .. obj.ClassName:gsub(" ", "") .. "\")" .. path
            break
        elseif (obj.Parent == game or obj.Parent == workspace.Parent) and obj == workspace or obj == game:GetService("Workspace") then
            path = "workspace" .. path
            break
        end

        local siblings = obj.Parent:GetChildren()
        local sameNameCount = 0
        local index = nil

        for i, v in siblings do
            if v.Name == obj.Name then
                sameNameCount = sameNameCount + 1
                if v == obj then
                    index = i
                end
            end
        end

        if sameNameCount > 1 and index and index ~= 1 and not dontGetService then
            path = ":GetChildren()[" .. index .. "]" .. path
        else
            local notInstance = typeof(obj.Parent[obj.Name]) ~= "Instance"
            if not isValidVariableName(obj.Name) or notInstance then
                if notInstance then
                    path = ":FindFirstChild(\"" .. normalize(obj.Name) .. "\")" .. path
                else
                    path = "[\"" .. normalize(obj.Name) .. "\"]"
                end
            else
                path = "." .. obj.Name .. path
            end
        end

        obj = obj.Parent
    end

    if not obj.Parent then
        path = "game" .. path
    end

    return (path:gsub("game:GetService%(\"Workspace\"%)", "workspace"))
end

local http = game:GetService("HttpService")
local tostr
local function convertArg(arg, indent)
    local t = typeof(arg)
    if t == "string" then
        local success, decoded = pcall(http.JSONDecode, http, arg)
        if success and not tonumber(arg) then
            return "game:GetService(\"HttpService\"):JSONEncode(" .. tostr(decoded) .. ")"
        else
            if #arg == 38 and arg:sub(1, 1) == "{" and arg:sub(-1) == "}" and arg:sub(10, 10) == "-" and arg:sub(15, 15) == "-" and arg:sub(20, 20) == "-" and arg:sub(25, 25) == "-" then
                return "game:GetService(\"HttpService\"):GenerateGUID(true) --[[" .. arg .. "]]"
            elseif #arg == 36 and arg:sub(9, 9) == "-" and arg:sub(14, 14) == "-" and arg:sub(19, 19) == "-" and arg:sub(24, 24) == "-" then
                return "game:GetService(\"HttpService\"):GenerateGUID(false) --[[" .. arg .. "]]"
            end
            
            return "\"" .. normalize(arg) .. "\""
        end
    elseif t == "number" then
        if arg == math.huge then
            return "math.huge"
        elseif arg == -math.huge then
            return "-math.huge"
        elseif arg ~= arg then
            return "(0 / 0) -- [[ nan ]]"
        elseif math.abs(tick() - arg) <= 2.5 then
            if math.floor(arg) == arg then
                return "os.time() --[[" .. arg .. "]]"
            else
                return "tick() --[[" .. arg .. "]]"
            end
        elseif math.abs(workspace:GetServerTimeNow() - arg) <= 2.5 then
            return "workspace:GetServerTimeNow() --[[" .. arg .. "]]"
        elseif math.abs(os.clock() - arg) <= 2.5 then
            return "os.clock() --[[" .. arg .. "]]"
        elseif math.abs(time() - arg) <= 2.5 and math.floor(arg) ~= arg then
            return "time() --[[" .. arg .. "]]"
        end
        
        return tostring(arg)
    elseif t == "boolean" or t == "nil" then
        return tostring(arg)
    elseif t == "Color3" then
        local r255 = arg.R * 255
        local g255 = arg.G * 255
        local b255 = arg.B * 255

        if math.abs(r255 - math.floor(r255 + 0.5)) < 1e-6 and math.abs(g255 - math.floor(g255 + 0.5)) < 1e-6 and math.abs(b255 - math.floor(b255 + 0.5)) < 1e-6 then
            return string.format("Color3.fromRGB(%d, %d, %d)", math.round(r255), math.round(g255), math.round(b255))
        else
            return string.format("Color3.new(%f, %f, %f)", arg.R, arg.G, arg.B)
        end
    elseif t == "BrickColor" then
        return "BrickColor.new(\"" .. arg.Name .. "\")"
    elseif t == "UDim" then
        if arg.Scale == 0 and arg.Offset == 0 then
            return "UDim.new()"
        end
        return string.format("UDim.new(%f, %d)", arg.Scale, arg.Offset)
    elseif t == "UDim2" then
        if arg.X.Scale == 0 and arg.X.Offset == 0 and arg.Y.Scale == 0 and arg.Y.Offset == 0 then
            return "UDim2.new()"
        elseif arg.X.Scale == 0 and arg.Y.Scale == 0 then
            return string.format("UDim2.fromOffset(%d, %d)", arg.X.Offset, arg.Y.Offset)
        elseif arg.X.Offset == 0 and arg.Y.Offset == 0 then
            return string.format("UDim2.fromScale(%f, %f)", arg.X.Scale, arg.Y.Scale)
        else
            return string.format("UDim2.new(%f, %d, %f, %d)", arg.X.Scale, arg.X.Offset, arg.Y.Scale, arg.Y.Offset)
        end
    elseif t == "Ray" then
        return "Ray.new(" .. convertArg(arg.Origin, indent) .. ", " .. convertArg(arg.Direction, indent) .. ")"
    elseif t == "EnumItem" then
        return "Enum." .. arg.EnumType.Name .. "." .. arg.Name
    elseif t == "Enum" then
        return "Enum." .. arg.Name
    elseif t == "NumberRange" then
        return string.format("NumberRange.new(%f, %f)", arg.Min, arg.Max)
    elseif t == "NumberSequenceKeypoint" then
        return string.format("NumberSequenceKeypoint.new(%f, %f, %f)", arg.Time, arg.Value, arg.Envelope)
    elseif t == "ColorSequenceKeypoint" then
        return string.format("ColorSequenceKeypoint.new(%f, Color3.new(%f, %f, %f))", arg.Time, arg.Value.R, arg.Value.G, arg.Value.B)
    elseif t == "PhysicalProperties" then
        return string.format("PhysicalProperties.new(%f, %f, %f, %f, %f)", arg.Density, arg.Friction, arg.Elasticity, arg.FrictionWeight, arg.ElasticityWeight)
    elseif t == "Rect" then
        return string.format("Rect.new(Vector2.new(%f, %f), Vector2.new(%f, %f))", arg.Min.X, arg.Min.Y, arg.Max.X, arg.Max.Y)
    elseif t == "Region3" then
        return string.format("Region3.new(Vector3.new(%f, %f, %f), Vector3.new(%f, %f, %f))", arg.CFrame.Position.X, arg.CFrame.Position.Y, arg.CFrame.Position.Z, arg.CFrame.Position.X, arg.CFrame.Position.Y, arg.CFrame.Position.Z)
    elseif t == "Region3int16" then
        return string.format("Region3int16.new(Vector3int16.new(%d, %d, %d), Vector3int16.new(%d, %d, %d))", arg.Min.X, arg.Min.Y, arg.Min.Z, arg.Max.X, arg.Max.Y, arg.Max.Z)
    elseif t == "TweenInfo" then
        return string.format("TweenInfo.new(%f, Enum.EasingStyle.%s, Enum.EasingDirection.%s, %d, %s, %f)", arg.Time, arg.EasingStyle.Name, arg.EasingDirection.Name, arg.RepeatCount, tostring(arg.Reverses), arg.DelayTime)
    elseif t == "function" then
        local n = debug.info(arg, "n")
        if not n or n == "" or not getfenv()[n] then
            return "function() end"
        else
            return n
        end
    elseif t == "thread" then
        return "coroutine.create(function() --[[ Unable to get content ]] end)"
    elseif t == "userdata" then
        return "newproxy()"
    elseif t == "buffer" then
        local s1 = buffer.tostring(arg)
        local s2 = ""
        local allZeros = true
        
        for i = 1, #s1 do
            local v = s1:sub(i, i)
            local byte = string.byte(v)
            
            if byte ~= 0 then
                allZeros = false
            end
            
            if byte <= 31 or byte >= 127 then
                if byte == 10 then
                    s2 ..= "\\n"
                elseif byte == 13 then
                    s2 ..= "\\r"
                elseif byte == 9 then
                    s2 ..= "\\t"
                else
                    s2 ..= "\\" .. byte
                end
            else
                s2 ..= v:gsub("\"", "\\\"")
            end
        end
        
        if allZeros then
            return "buffer.create(" .. #s1 .. ")"
        end
        
        return "buffer.fromstring(\"" .. s2 .. "\")"
    elseif t == "Instance" then
        return getPath(arg)
    elseif t == "table" then
        return tostr(arg, indent)
    else
        local obj = getfenv()[t]

        if typeof(obj) == "table" and obj.new then
            if pcall(obj.new) and tostring(obj.new()) == tostring(arg) then
                return t .. ".new()"
            end

            return t .. ".new(" .. tostring(arg) .. ")"
        else
            return "--[[ unknown type: " .. t .. "; values: " .. tostring(arg):gsub("%]%]", "] ]") .. " ]]"
        end
    end
end

local function isArray(tbl)
    if typeof(tbl) ~= "table" then
        return false
    end
    
    local isArray = true
    local allValid = true
    local count = 0

    for k in tbl do
        if typeof(k) ~= "number" or math.floor(k) ~= k then
            isArray = false
            break
        end

        count = math.max(count, k)
    end

    if isArray then
        isArray = #tbl == count
        allValid = false

        if isArray then
            for i = 1, count do
                if tbl[i] == nil then
                    isArray = false
                    break
                end
            end
        end
    else
        for k in tbl do
            if typeof(k) ~= "string" or not isValidVariableName(k) then
                allValid = false
                break
            end
        end
    end
    
    return isArray, allValid, count
end

local parsed = { }
function tostr(tbl, indent)
    indent = tonumber(indent) or 0
    
    local indentStr = string.rep("    ", math.max(indent, 0))
    local indentStrNext = string.rep("    ", math.max(indent, 0) + 1)

    if typeof(tbl) ~= "table" then
        return convertArg(tbl, math.max(indent, 0))
    elseif table.find(parsed, tbl) then
        return "{ --[[ recursive ]] }"
    end
    
    table.insert(parsed, tbl)

    local isArray, allValid, count = isArray(tbl)

    if isArray then
        if count == 0 then
            return "{ }"
        end

        local result = "{" .. (indent == -1 and "" or " ")
        for i = 1, count do
            result ..= (indent == -1 and "\n" .. indentStrNext or "") .. tostr(tbl[i], math.max(indent, 0) + 1)
            if i < count then
                result ..= ","
            end
            result ..= indent == -1 and "" or " "
        end

        return result .. (indent == -1 and "\n" or "") .. "}"
    else
        local result = "{\n"
        local first = true

        for k, v in tbl do
            if not first then
                result ..= ",\n"
            end

            first = false
            result ..= indentStrNext .. (allValid and k or "[" .. tostr(k, math.max(indent, 0) + 1) .. "]") .. " = " .. tostr(v, math.max(indent, 0) + 1)
        end

        return result .. "\n" .. indentStr .. "}"
    end
end

return {
    ToString = function(...)
        return tostr(...), table.clear(parsed)
    end,
    CreateArguments = function(tbl)
        local isArray = isArray(tbl)
        local str = tostr(tbl)
        
        table.clear(parsed)

        if isArray then
            if #tbl == 0 then
                return "()"
            end

            return "(" .. str:sub(3):sub(1, #str - 4) .. ")"
        else
            return (("(" .. str .. ")"):gsub("%(nil%)", "()"))
        end
    end,
    EscapePattern = escapePattern,
    GetPath = getPath
}
    end;

    modules[objects["Instance3"]] = function()
        local script = objects["Instance3"];
local tweenService = game:GetService("TweenService")
local http = game:GetService("HttpService")

local event = Instance.new("BindableEvent", script)
event.Name = "SettingChange"

local metatable

local settings = {
    {"SEPARATOR", "UI Settings"},
    {"Transparent", false, function(state)
        tweenService:Create(script.Parent.Parent.Main, TweenInfo.new(1), {BackgroundTransparency = not state and 0 or metatable.Has_shadow and 0.2 or 0.05}):Play()
    end},
    {"Rounded_corners", false, function(state)
        tweenService:Create(script.Parent.Parent.Main.UICorner, TweenInfo.new(1), {CornerRadius = UDim.new(state and 0.025 or 0.01)}):Play()
    end},
    {"Always_show_side_panel", {1, 1, 3}, function(state, instance)
        if instance then
            instance.Label.Text = state == 1 and "Dynamic side panel" or state == 2 and "Never show side panel" or "Always show side panel"
        end
    end},
    {"Window_scale", {100, 75, 155}},
    {"SEPARATOR", "UI Shadow Settings"},
    {"Has_shadow", true, function(state)
        metatable.Transparent = metatable.Transparent
        tweenService:Create(script.Parent.Parent.Shadow, TweenInfo.new(state and 0.75 or 1.25), {ImageTransparency = state and 0.2 or 1}):Play()
    end},
    {"Shadow_centered", false, function(state)
        script.Parent.Parent.Shadow:TweenPosition(state and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.515, 0.525), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    end},
    {"SEPARATOR", "Log Settings"},
    {"Log_executor_function_calls", {1, 1, 3}, function(state, instance)
        if instance then
            instance.Label.Text = state == 1 and "Log calls called only by game scripts" or state == 2 and "Log calls called by game & executor scripts" or "Log calls called only by executor scripts"
        end
    end},
    {"Create_arguments_as_variable", false},
    {"Create_event_as_variable", false},
    {"Maximum_log_amount", {10, 0, 20}, function(state, instance)
        if instance then
            instance.Label.Text = "Maximum log amount [ " .. math.max(1, state * 5) .. " ]"
        end
    end},
    {"Decompile_limit", {1, 1, 50}, function(state, instance)
        if instance then
            instance.Label.Text = "Decompile limit [ " .. state .. " / 50 scripts at the same time ]"
        end
    end},
    {"Ignore_spammy_logs", true}
}

local function find(index)
    for _, v in settings do
        if v[1] == index then
            return v
        end
    end
    return nil
end

local files = getfenv().writefile and getfenv().readfile and getfenv().makefolder
metatable = setmetatable({ }, {
    __index = function(self, index)
        index = index:sub(1,1):upper() .. index:sub(2)

        if index == "Values" then
            local vals = { }
            
            for _, v in settings do
                vals[#vals+1] = { v[1], v[2] }
            end
            
            return vals
        elseif index == "Event" or index == "Signal" or index == "Changed" then
            return event.Event
        elseif index == "Find" then
            return find
        else
            local setting = find(index)
            if setting then
                return typeof(setting[2]) == "table" and setting[2][1] or setting[2]
            else
                error("Unable to get value for setting: " .. tostring(index), 0)
            end
        end
    end,
    __newindex = function(self, index, value)
        index = index:sub(1, 1):upper() .. index:sub(2)
        local setting = find(index)
        assert(setting, "Setting not found: " .. tostring(index))
        assert(typeof(value) == typeof(setting[2]) or typeof(value) == "number" and typeof(setting[2]) == "table", ("Type mismatch for setting %s: expected %s got %s"):format(index, typeof(setting[2]), typeof(value)))

        local val = typeof(value) == "table" and value[1] or value

        setting[2] = value
        event:Fire(index, val)

        if setting[3] then
            task.spawn(setting[3], val, setting[4])
        end
        
        local auto = find("Auto_load_settings")
        if auto and auto[2] then
            if files then
                local saveFile = { }
                for _, v in self.Values do
                    local i = v[1]
                    local v = v[2]

                    if i ~= "SEPARATOR" then
                        saveFile[i] = v
                    end
                end

                task.spawn(getfenv().writefile, "Ketamine/Settings.json", http:JSONEncode(saveFile))
            end
        end
    end
})

if files then
    getfenv().makefolder("Ketamine")

    table.insert(settings, 1, {"Auto_load_settings", false, function(state)
        task.spawn(getfenv().writefile, "Ketamine/Settings.bool", state and "1" or "0")

        if state then
            local success, json = pcall(getfenv().readfile, "Ketamine/Settings.json")
            if success then
                for index, value in http:JSONDecode(json) do
                    if index ~= "Auto_load_settings" then
                        metatable[index] = typeof(value) == "table" and value[1] or value
                    end
                end
            end
        end
    end})
    
    table.insert(settings, 1, {"SEPARATOR", "Saves"})
    
    local success, value = pcall(getfenv().readfile, "Ketamine/Settings.bool")
    if success then
        task.delay(5, function()
            metatable.Auto_load_settings = value == "1"
        end)
    end
end

return metatable
    end;

    modules[objects["Instance4"]] = function()
        local script = objects["Instance4"];
local global = typeof(getfenv().getgenv) == "function" and typeof(getfenv().getgenv()) == "table" and getfenv().getgenv() or _G -- I never made normal require in my plugin, so thats a reason why I made that
local idx = "__KetamineShared"

if global[idx] then
    return global[idx]
end

local useEnv = getfenv().getgenv ~= nil
if useEnv then
    local found = {
        ["print"] = false,
        ["getgenv"] = false,
        ["vector"] = false,
        ["error"] = false,
        ["loadstring"] = false
    }

    for i, _ in getfenv().getgenv() do
        if typeof(found[i]) ~= "nil" then
            found[i] = true
        end
    end

    for _, v in found do
        if not v then
            useEnv = false
            break
        end
    end
end

local function pressKey(isDown, key)
    game:GetService("VirtualInputManager"):SendKeyEvent(isDown, Enum.KeyCode[key], false, game)
    for i=1, 2 do game:GetService("RunService").RenderStepped:Wait() end
end

local shared = {
    Version = "BETA",
    Connections = { },
    SidePanelEvent = Instance.new("BindableEvent", script),
    Settings = require(script.Parent.Settings),
    CodeBox = require(script.Parent.CodeBox),
    Global = global,
    _idx = idx,
    UseEnv = useEnv and getfenv().getgenv,
    OnCloseEvent = Instance.new("BindableEvent", script),
    ToString = require(script.Parent.ToString),
    CSpyObjects = setmetatable({ }, { __mode = "kv" }),
    Changelogs = require(script.Parent.Changelogs),
    AddObject = function(self, tbl)
        if (typeof(tbl) == "table" or typeof(tbl) == "function") and not self:IsCSpy(tbl) then
            table.insert(self.CSpyObjects, tbl)
            if typeof(tbl) == "table" then
                for i, v in tbl do
                    self:AddObject(i) -- who knows, mb "i" is not a number or string
                    self:AddObject(v)
                end
            end
        end
        
        return tbl
    end,
    Clipboard = getfenv().toclipboard or getfenv().setclipboard or function(text)
        local ui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        task.delay(1, ui.Destroy, ui)
        
        local tb = Instance.new("TextBox", ui)
        tb.Size = UDim2.fromOffset(1, 1)
        tb.BackgroundTransparency = 1
        tb.TextTransparency = 1
        tb.Text = text
        
        tb:CaptureFocus()

        for i=1, 2 do game:GetService("RunService").RenderStepped:Wait() end
        pressKey(true, "LeftControl")
        pressKey(true, "A")
        pressKey(false, "A")
        pressKey(true, "C")
        pressKey(false, "C")
        pressKey(false, "LeftControl")
        
        tb:ReleaseFocus()
    end,
    IsCSpy = function(self, obj)
        return table.find(self.CSpyObjects, obj)
    end,
    AddButton = function(self, button)
        local cont = button.Contents
        local source = cont.BackgroundTransparency
        local In = false

        button.MouseEnter:Connect(function()
            In = true
            cont.BackgroundTransparency = source + 0.025
        end)
        button.MouseLeave:Connect(function()
            In = false
            cont.BackgroundTransparency = source
        end)
        button.MouseButton1Down:Connect(function()
            cont.BackgroundTransparency = source - 0.05
        end)
        button.MouseButton1Up:Connect(function()
            cont.BackgroundTransparency = source + (In and 0.025 or 0)
        end)
        
        return button
    end
}

shared:AddObject(shared.Connections)
shared:AddObject(shared.Settings)
shared:AddObject(shared.ToString)
shared:AddObject(shared.CodeBox)
shared:AddObject(shared.CSpyObjects)
shared:AddObject(shared.Changelogs)

shared.HookFunction = require(script.Parent.HookFunction)(shared)
shared.SidePanelEvent.Name = "SidePanel"
shared.OnCloseEvent.Name = "OnClose"

global[idx] = shared

return shared
    end;

    modules[objects["Instance10"]] = function()
        local script = objects["Instance10"];
return function(shared, page)
    local settings = shared.Settings
    local cons = shared.Connections
    local TweenService = game:GetService("TweenService")

    local settingTypes = shared:AddObject({
        boolean = function(instance, setting)
            local function updateState()
                local state = settings[setting]
                TweenService:Create(instance.State, TweenInfo.new(0.35), shared:AddObject({BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(50, 50, 50)})):Play()
                TweenService:Create(instance.State.State, TweenInfo.new(0.35), shared:AddObject({
                    BackgroundColor3 = state and Color3.fromRGB(50, 50, 50) or Color3.new(1, 1, 1),
                    AnchorPoint = Vector2.new(state and 1 or 0, 0),
                    Position = UDim2.fromScale(state and 1 or 0, 0)
                })):Play()
            end

            updateState()
            cons[#cons+1] = instance.MouseButton1Click:Connect(function()
                settings[setting] = not settings[setting]
            end)
            
            shared.Settings.Event:Connect(updateState)
        end,
        
        table = function(instance, setting)
            local data = settings.Find(setting)[2]
            local val = data[1]
            local min = data[2]
            local max = data[3]

            local dragDetector = instance.Hitbox
            local stateFrame = instance.State
            local fill = stateFrame.Fill
            local pointer = stateFrame.Pointer

            local prevVal = val
            local sliderDrag = instance.Hitbox
            local sliderBar = instance.State.Fill
            local pointer = instance.State.Pointer
            local dragging = false

            cons[#cons+1] = sliderDrag.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = true 
                end 
            end)
            cons[#cons+1] = sliderDrag.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = false 
                end 
            end)

            local newVal
            local function set(num)
                newVal = math.round((math.clamp(math.max(math.floor(num + (math.sign(num) * 0.5)), 0), min, max)) * 1000) / 1000
                sliderBar:TweenSize(UDim2.fromScale((newVal - min) / (max - min), 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                pointer:TweenPosition(UDim2.fromScale((newVal - min) / (max - min), 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                val = newVal
                if newVal ~= prevVal then
                    prevVal = newVal
                    settings[setting] = newVal
                end
            end

            cons[#cons+1] = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then 
                    local sizeScale = math.clamp((input.Position.X - sliderBar.Parent.AbsolutePosition.X) / sliderBar.Parent.AbsoluteSize.X, 0, 1)
                    local pval = prevVal
                    set(min + ((max - min) * sizeScale))
                end
            end)

            task.spawn(set, val)

            shared.Settings.Event:Connect(function()
                set(settings[setting])
            end)
        end,
    })

    for i, v in page:GetChildren() do
        if not v:IsA("UIListLayout") then
            v.Visible = false
        end
    end

    local prevSeparator = false
    local separators = shared:AddObject({ })
    
    for _, v in settings.Values do
        local i = v[1]
        local v = v[2]
        
        if i ~= "SEPARATOR" then
            if settingTypes[typeof(v)] and page:FindFirstChild(typeof(v)) then
                local obj = page:FindFirstChild(typeof(v)):Clone()
                obj.Parent = page
                obj.Name = i
                obj.Label.Text = i:gsub("_", " ")
                obj.Visible = true
                
                if prevSeparator then
                    obj.Frame:Destroy()
                    prevSeparator = false
                end

                settings.Find(i)[4] = obj
                task.spawn(settingTypes[typeof(v)], obj, i)
            end
        else
            prevSeparator = true
            
            local obj = page.Separator:Clone()
            obj.Parent = page
            obj.Name = v
            obj.Label.Text = v
            obj.Visible = true
            obj.FrameRight.Size = UDim2.new(0.94 - (#v * 0.01), 0, 0, 1)
            
            table.insert(separators, obj)
        end
    end
    
    shared.SidePanelEvent.Event:Connect(function(visible)
        for _, obj in separators do
            obj.FrameRight:TweenSize(UDim2.new(0.96 - (#obj.Name * (visible and 0.01 or 0.0125)), 0, 0, 1), nil, nil, 0.15, true)
        end
    end)
end
    end;

    modules[objects["Instance16"]] = function()
        local script = objects["Instance16"];
return function(shared, page)
    local cons = shared.Connections
    
    local log = page.Changelogs.Log
    log.Visible = false

    local maxBit32 = (2 ^ 31) - 1
    local function addLog(version, text)
        local log = log:Clone()
        log.Parent = page.Changelogs
        log.Text = "<b>" .. version .. "</b> - " .. text
        log.Visible = true
        log.Name = version
        
        cons[#cons + 1] = log:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            log.Size = UDim2.new(1, 0, 0, log.TextBounds.Y)
        end)
        
        log.Size = UDim2.new(1, 0, 0, log.TextBounds.Y)
        log.LayoutOrder = maxBit32 - ((tonumber(version) - 1) * 100)
        
        return log
    end
    
    for _, log in shared.Changelogs do
        addLog(unpack(log))
    end
    
    log:Destroy()
end
    end;

    modules[objects["Instance5"]] = function()
        local script = objects["Instance5"];
local Lib = {}
local function getFunc(name)
    return getfenv()[name]
end
local ENV = {
    game=game,
    Instance=Instance,
    type=type,
    typeof=typeof,
    wait=wait,
    workspace=workspace,
    Wait=wait,
    Workspace=workspace,
    Enum=Enum,
    ElapsedTime=getFunc("elapsedTime"),
    elapsedTime=getFunc("elapsedTime"),
    require=require,
    Random=Random,
    RaycastParams=RaycastParams,
    Region3=Region3,
    Ray=Ray,
    Rect=Rect,
    RotationCurveKey=RotationCurveKey,
    Region3int16=Region3int16,
    rawget=rawget,
    rawlen=rawlen,
    rawset=rawset,
    rawequal=rawequal,
    task=task,
    TweenInfo=TweenInfo,
    tostring=tostring,
    tonumber=tonumber,
    table=table,
    time=time,
    tick=tick,
    ypcall=pcall,
    UDim2=UDim2,
    utf8=utf8,
    unpack=unpack,
    UDim=UDim,
    UserSettings=UserSettings,
    ipairs=ipairs,
    os=os,
    OverlapParams=OverlapParams,
    pairs=pairs,
    pcall=pcall,
    plugin=plugin,
    PhysicalProperties=PhysicalProperties,
    PathWaypoint=PathWaypoint,
    printidentity=getFunc("printidentity"),
    Axes=Axes,
    assert=assert,
    script=nil,
    string=string,
    select=select,
    settings=settings,
    spawn=spawn,
    Secret=Secret,
    shared=shared,
    setfenv=setfenv,
    SharedTable=SharedTable,
    setmetatable=setmetatable,
    Spawn=spawn,
    Stats=getFunc("stats"),
    stats=getFunc("stats"),
    DateTime=DateTime,
    debug=debug,
    DockWidgetPluginGuiInfo=DockWidgetPluginGuiInfo,
    delay=delay,
    Delay=delay,
    Font=Font,
    Faces=Faces,
    File=File,
    FloatCurveKey=FloatCurveKey,
    getfenv=getfenv,
    getmetatable=getmetatable,
    gcinfo=gcinfo,
    Game=getFunc("Game"),
    loadstring=loadstring,
    xpcall=xpcall,
    CFrame=CFrame,
    Color3=Color3,
    coroutine=coroutine,
    ColorSequenceKeypoint=ColorSequenceKeypoint,
    ColorSequence=ColorSequence,
    CatalogSearchParams=CatalogSearchParams,
    collectgarbage=getFunc("collectgarbage"),
    Vector3=Vector3,
    Vector2=Vector2,
    Vector2int16=Vector2int16,
    Vector3int16=Vector3int16,
    Version=getFunc("version"),
    version=getFunc("version"),
    BrickColor=BrickColor,
    bit32=bit32,
    buffer=buffer,
    newproxy=newproxy,
    NumberSequence=NumberSequence,
    NumberSequenceKeypoint=NumberSequenceKeypoint,
    NumberRange=NumberRange,
    next=next,
    math=math,
    _G={},
    _VERSION=_VERSION,
    print=print,
    warn=warn,
    error=error,
    vector=vector
}
local Main = {}
local plr = game:GetService("Players").LocalPlayer
Main.Mouse = plr and plr:GetMouse()
local service = setmetatable({},{
    __index = function(self,name)
        return game:FindFirstChild(name) or game:GetService(name)
    end,
})
local cloneref = function(...)return...end
local clonerefs = cloneref
local create = function(data)
    local insts = {}
    for i,v in pairs(data) do insts[v[1]] = Instance.new(v[2]) end
    for _,v in pairs(data) do
        for prop,val in pairs(v[3]) do
            if type(val) == "table" then
                insts[v[1]][prop] = insts[val[1]]
            else
                insts[v[1]][prop] = val
            end
        end
    end
    return insts[1]
end
local createSimple = function(class,props)
    local inst = Instance.new(class)
    for i,v in next,props do
        inst[i] = v
    end
    return inst
end
local Settings = {
    Explorer = {
        _Recurse = true,
        Sorting = true,
        TeleportToOffset = Vector3.new(0,0,0),
        ClickToRename = true,
        AutoUpdateSearch = true,
        AutoUpdateMode = 0, -- 0 Default, 1 no tree update, 2 no descendant events, 3 frozen
        PartSelectionBox = true,
        GuiSelectionBox = true,
        CopyPathUseGetChildren = true
    },
    Properties = {
        _Recurse = true,
        MaxConflictCheck = 50,
        ShowDeprecated = false,
        ShowHidden = false,
        ClearOnFocus = false,
        LoadstringInput = true,
        NumberRounding = 3,
        ShowAttributes = false,
        MaxAttributes = 50,
        ScaleType = 1 -- 0 Full Name Shown, 1 Equal Halves
    },
    Theme = {
        _Recurse = true,
        Main1 = Color3.fromRGB(52,52,52),
        Main2 = Color3.fromRGB(45,45,45),
        Outline1 = Color3.fromRGB(33,33,33), -- Mainly frames
        Outline2 = Color3.fromRGB(55,55,55), -- Mainly button
        Outline3 = Color3.fromRGB(30,30,30), -- Mainly textbox
        TextBox = Color3.fromRGB(38,38,38),
        Menu = Color3.fromRGB(32,32,32),
        ListSelection = Color3.fromRGB(199,154,40),
        Button = Color3.fromRGB(60,60,60),
        ButtonHover = Color3.fromRGB(68,68,68),
        ButtonPress = Color3.fromRGB(40,40,40),
        Highlight = Color3.fromRGB(75,75,75),
        Text = Color3.fromRGB(255,255,255),
        PlaceholderText = Color3.fromRGB(100,100,100),
        Important = Color3.fromRGB(255,0,0),
        ExplorerIconMap = "",
        MiscIconMap = "",
        Syntax = {
            Text = Color3.fromRGB(230, 230, 230), -- Light Gray
            Background = Color3.fromRGB(255, 255, 255), -- Darker background for contrast
            Selection = Color3.fromRGB(200, 200, 255), -- Light blue for selection
            SelectionBack = Color3.fromRGB(40, 40, 60), -- Darker blue for selection background
            Operator = Color3.fromRGB(180, 180, 255), -- Light blue for operators
            Number = Color3.fromRGB(150, 200, 255), -- Pastel Blue
            String = Color3.fromRGB(150, 120, 180), -- Purple-Gray for strings
            Comment = Color3.fromRGB(100, 100, 130), -- Muted Purple for comments
            Keyword = Color3.fromRGB(180, 120, 200), -- Purple for keywords
            Error = Color3.fromRGB(255, 50, 100), -- Pink-Red for errors (still avoiding pure red)
            FindBackground = Color3.fromRGB(150, 255, 150), -- Light Green for FindBackground
            MatchingWord = Color3.fromRGB(70, 70, 100), -- Darker Purple-Gray for matching words
            BuiltIn = Color3.fromRGB(160, 160, 220), -- Light Blue for built-in functions
            CurrentLine = Color3.fromRGB(40, 40, 50), -- Darker shade for current line
            LocalMethod = Color3.fromRGB(200, 180, 220), -- Light Purple for local methods
            LocalProperty = Color3.fromRGB(220, 200, 240), -- Pastel Purple for local properties
            Nil = Color3.fromRGB(255, 255, 255), -- White for nil
            Bool = Color3.fromRGB(180, 255, 180), -- Light Green for booleans
            Function = Color3.fromRGB(150, 200, 150), -- Green for functions
            Local = Color3.fromRGB(160, 160, 220), -- Light Blue for locals
            Self = Color3.fromRGB(200, 200, 200),  -- Light Gray for self
            FunctionName = Color3.fromRGB(255, 255, 255), -- White for function name
            Bracket = Color3.fromRGB(180, 180, 220) -- Light Blue for brackets
        },
    }
}
local function signalWait(s)return s:Wait()end
local renderStepped = game:GetService("RunService").RenderStepped
Lib.FastWait = function(s)
    if not s then return signalWait(renderStepped) end
    local start = tick()
    while tick() - start < s do signalWait(renderStepped) end
end
Lib.CheckMouseInGui = function(gui)
    if gui == nil then return false end
    Main.Mouse = Main.Mouse or plr and plr:GetMouse()
    local mouse = Main.Mouse
    local guiPosition = gui.AbsolutePosition
    local guiSize = gui.AbsoluteSize    

    return mouse.X >= guiPosition.X and mouse.X < guiPosition.X + guiSize.X and mouse.Y >= guiPosition.Y and mouse.Y < guiPosition.Y + guiSize.Y
end
Lib.CreateArrow = function(size,num,dir)
    local max = num
    local arrowFrame = createSimple("Frame",{
        BackgroundTransparency = 1,
        Name = "Arrow",
        Size = UDim2.new(0,size,0,size)
    })
    if dir == "up" then
        for i = 1,num do
            local newLine = createSimple("TextButton",{
                BackgroundColor3 = Color3.new(220/255,220/255,220/255),
                BorderSizePixel = 0,
                Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)+i-math.floor(max/2)-1),
                Size = UDim2.new(0,i+(i-1),0,1),
                Parent = arrowFrame,
                Text = "",
                AutoButtonColor = false
            })
        end
        return arrowFrame
    elseif dir == "down" then
        for i = 1,num do
            local newLine = createSimple("TextButton",{
                BackgroundColor3 = Color3.new(220/255,220/255,220/255),
                BorderSizePixel = 0,
                Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)-i+math.floor(max/2)+1),
                Size = UDim2.new(0,i+(i-1),0,1),
                Parent = arrowFrame,
                Text = "",
                AutoButtonColor = false
            })
        end
        return arrowFrame
    elseif dir == "left" then
        for i = 1,num do
            local newLine = createSimple("TextButton",{
                BackgroundColor3 = Color3.new(220/255,220/255,220/255),
                BorderSizePixel = 0,
                Position = UDim2.new(0,math.floor(size/2)+i-math.floor(max/2)-1,0,math.floor(size/2)-(i-1)),
                Size = UDim2.new(0,1,0,i+(i-1)),
                Parent = arrowFrame,
                Text = "",
                AutoButtonColor = false
            })
        end
        return arrowFrame
    elseif dir == "right" then
        for i = 1,num do
            local newLine = createSimple("TextButton",{
                BackgroundColor3 = Color3.new(220/255,220/255,220/255),
                BorderSizePixel = 0,
                Position = UDim2.new(0,math.floor(size/2)-i+math.floor(max/2)+1,0,math.floor(size/2)-(i-1)),
                Size = UDim2.new(0,1,0,i+(i-1)),
                Parent = arrowFrame,
                Text = "",
                AutoButtonColor = false
            })
        end
        return arrowFrame
    end
    error("r u ok")
end
Lib.Signal = (function()
    local funcs = {}

    local disconnect = function(con)
        local pos = table.find(con.Signal.Connections,con)
        if pos then table.remove(con.Signal.Connections,pos) end
    end

    funcs.Connect = function(self,func)
        if type(func) ~= "function" then error("Attempt to connect a non-function") end        
        local con = {
            Signal = self,
            Func = func,
            Disconnect = disconnect
        }
        self.Connections[#self.Connections+1] = con
        return con
    end

    funcs.Fire = function(self,...)
        for i,v in next,self.Connections do
            xpcall(coroutine.wrap(v.Func),function(e) warn(e.."\n"..debug.traceback()) end,...)
        end
    end

    local mt = {
        __index = funcs,
        __tostring = function(self)
            return "Signal: " .. tostring(#self.Connections) .. " Connections"
        end
    }

    local function new()
        local obj = {}
        obj.Connections = {}

        return setmetatable(obj,mt)
    end

    return {new = new}
end)()
Lib.ScrollBar = (function()
    local funcs = {}
    local user = service.UserInputService
    local mouse = Main.Mouse or plr and plr:GetMouse()
    local checkMouseInGui = Lib.CheckMouseInGui
    local createArrow = Lib.CreateArrow

    local function drawThumb(self)
        local total = self.TotalSpace
        local visible = self.VisibleSpace
        local index = self.Index
        local scrollThumb = self.GuiElems.ScrollThumb
        local scrollThumbFrame = self.GuiElems.ScrollThumbFrame

        if not (self:CanScrollUp()    or self:CanScrollDown()) then
            scrollThumb.Visible = false
        else
            scrollThumb.Visible = true
        end

        if self.Horizontal then
            scrollThumb.Size = UDim2.new(visible/total,0,1,0)
            if scrollThumb.AbsoluteSize.X < 16 then
                scrollThumb.Size = UDim2.new(0,16,1,0)
            end
            local fs = scrollThumbFrame.AbsoluteSize.X
            local bs = scrollThumb.AbsoluteSize.X
            scrollThumb.Position = UDim2.new(self:GetScrollPercent()*(fs-bs)/fs,0,0,0)
        else
            scrollThumb.Size = UDim2.new(1,0,visible/total,0)
            if scrollThumb.AbsoluteSize.Y < 16 then
                scrollThumb.Size = UDim2.new(1,0,0,16)
            end
            local fs = scrollThumbFrame.AbsoluteSize.Y
            local bs = scrollThumb.AbsoluteSize.Y
            scrollThumb.Position = UDim2.new(0,0,self:GetScrollPercent()*(fs-bs)/fs,0)
        end
    end

    local function createFrame(self)
        local newFrame = createSimple("Frame",{Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.35294118523598,0.35294118523598,0.35294118523598),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-16,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ScrollBar",})
        local button1 = nil
        local button2 = nil

        if self.Horizontal then
            newFrame.Size = UDim2.new(1,0,0,16)
            button1 = createSimple("ImageButton",{
                Parent = newFrame,
                Name = "Left",
                Size = UDim2.new(0,16,0,16),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            createArrow(16,4,"left").Parent = button1
            button2 = createSimple("ImageButton",{
                Parent = newFrame,
                Name = "Right",
                Position = UDim2.new(1,-16,0,0),
                Size = UDim2.new(0,16,0,16),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            createArrow(16,4,"right").Parent = button2
        else
            newFrame.Size = UDim2.new(0,16,1,0)
            button1 = createSimple("ImageButton",{
                Parent = newFrame,
                Name = "Up",
                Size = UDim2.new(0,16,0,16),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            createArrow(16,4,"up").Parent = button1
            button2 = createSimple("ImageButton",{
                Parent = newFrame,
                Name = "Down",
                Position = UDim2.new(0,0,1,-16),
                Size = UDim2.new(0,16,0,16),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            createArrow(16,4,"down").Parent = button2
        end

        local scrollThumbFrame = createSimple("Frame",{
            BackgroundTransparency = 1,
            Parent = newFrame,
        })
        if self.Horizontal then
            scrollThumbFrame.Position = UDim2.new(0,16,0,0)
            scrollThumbFrame.Size = UDim2.new(1,-32,1,0)
        else
            scrollThumbFrame.Position = UDim2.new(0,0,0,16)
            scrollThumbFrame.Size = UDim2.new(1,0,1,-32)
        end

        local scrollThumb = createSimple("TextButton",{
            BackgroundColor3 = Color3.new(120/255,120/255,120/255),
            BorderSizePixel = 0,
            Parent = scrollThumbFrame,
            Text = "",
            AutoButtonColor = false,
        })

        local markerFrame = createSimple("Frame",{
            BackgroundTransparency = 1,
            Name = "Markers",
            Size = UDim2.new(1,0,1,0),
            Parent = scrollThumbFrame
        })

        local buttonPress = false
        local thumbPress = false
        local thumbFramePress = false

        --local thumbColor = Color3.new(120/255,120/255,120/255)
        --local thumbSelectColor = Color3.new(140/255,140/255,140/255)
        button1.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and self:CanScrollUp() then button1.BackgroundTransparency = 0.8 end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or not self:CanScrollUp() then return end
            buttonPress = true
            button1.BackgroundTransparency = 0.5
            if self:CanScrollUp() then self:ScrollUp() self.Scrolled:Fire() end
            local buttonTick = tick()
            local releaseEvent
            releaseEvent = user.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                releaseEvent:Disconnect()
                if checkMouseInGui(button1) and self:CanScrollUp() then button1.BackgroundTransparency = 0.8 else button1.BackgroundTransparency = 1 end
                buttonPress = false
            end)
            while buttonPress do
                if tick() - buttonTick >= 0.3 and self:CanScrollUp() then
                    self:ScrollUp()
                    self.Scrolled:Fire()
                end
                wait()
            end
        end)
        button1.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then button1.BackgroundTransparency = 1 end
        end)
        button2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and self:CanScrollDown() then button2.BackgroundTransparency = 0.8 end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or not self:CanScrollDown() then return end
            buttonPress = true
            button2.BackgroundTransparency = 0.5
            if self:CanScrollDown() then self:ScrollDown() self.Scrolled:Fire() end
            local buttonTick = tick()
            local releaseEvent
            releaseEvent = user.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                releaseEvent:Disconnect()
                if checkMouseInGui(button2) and self:CanScrollDown() then button2.BackgroundTransparency = 0.8 else button2.BackgroundTransparency = 1 end
                buttonPress = false
            end)
            while buttonPress do
                if tick() - buttonTick >= 0.3 and self:CanScrollDown() then
                    self:ScrollDown()
                    self.Scrolled:Fire()
                end
                wait()
            end
        end)
        button2.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then button2.BackgroundTransparency = 1 end
        end)

        scrollThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then scrollThumb.BackgroundTransparency = 0.2 scrollThumb.BackgroundColor3 = self.ThumbSelectColor end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local dir = self.Horizontal and "X" or "Y"
            local lastThumbPos = nil

            buttonPress = false
            thumbFramePress = false            
            thumbPress = true
            scrollThumb.BackgroundTransparency = 0
            local mouseOffset = mouse[dir] - scrollThumb.AbsolutePosition[dir]
            local mouseStart = mouse[dir]
            local releaseEvent
            local mouseEvent
            releaseEvent = user.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                releaseEvent:Disconnect()
                if mouseEvent then mouseEvent:Disconnect() end
                if checkMouseInGui(scrollThumb) then scrollThumb.BackgroundTransparency = 0.2 else scrollThumb.BackgroundTransparency = 0 scrollThumb.BackgroundColor3 = self.ThumbColor end
                thumbPress = false
            end)
            self:Update()

            mouseEvent = user.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and thumbPress and releaseEvent.Connected then
                    local thumbFrameSize = scrollThumbFrame.AbsoluteSize[dir]-scrollThumb.AbsoluteSize[dir]
                    local pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - mouseOffset
                    if pos > thumbFrameSize then
                        pos = thumbFrameSize
                    elseif pos < 0 then
                        pos = 0
                    end
                    if lastThumbPos ~= pos then
                        lastThumbPos = pos
                        self:ScrollTo(math.floor(0.5+pos/thumbFrameSize*(self.TotalSpace-self.VisibleSpace)))
                    end
                    wait()
                end
            end)
        end)
        scrollThumb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then scrollThumb.BackgroundTransparency = 0 scrollThumb.BackgroundColor3 = self.ThumbColor end
        end)
        scrollThumbFrame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or checkMouseInGui(scrollThumb) then return end

            local dir = self.Horizontal and "X" or "Y"
            local scrollDir = 0
            if mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir] then
                scrollDir = 1
            end

            local function doTick()
                local scrollSize = self.VisibleSpace - 1
                if scrollDir == 0 and mouse[dir] < scrollThumb.AbsolutePosition[dir] then
                    self:ScrollTo(self.Index - scrollSize)
                elseif scrollDir == 1 and mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir] then
                    self:ScrollTo(self.Index + scrollSize)
                end
            end

            thumbPress = false            
            thumbFramePress = true
            doTick()
            local thumbFrameTick = tick()
            local releaseEvent
            releaseEvent = user.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                releaseEvent:Disconnect()
                thumbFramePress = false
            end)
            while thumbFramePress do
                if tick() - thumbFrameTick >= 0.3 and checkMouseInGui(scrollThumbFrame) then
                    doTick()
                end
                wait()
            end
        end)

        newFrame.MouseWheelForward:Connect(function()
            self:ScrollTo(self.Index - self.WheelIncrement)
        end)

        newFrame.MouseWheelBackward:Connect(function()
            self:ScrollTo(self.Index + self.WheelIncrement)
        end)

        self.GuiElems.ScrollThumb = scrollThumb
        self.GuiElems.ScrollThumbFrame = scrollThumbFrame
        self.GuiElems.Button1 = button1
        self.GuiElems.Button2 = button2
        self.GuiElems.MarkerFrame = markerFrame

        return newFrame
    end

    funcs.Update = function(self,nocallback)
        local total = self.TotalSpace
        local visible = self.VisibleSpace
        local index = self.Index
        local button1 = self.GuiElems.Button1
        local button2 = self.GuiElems.Button2

        self.Index = math.clamp(self.Index,0,math.max(0,total-visible))

        if self.LastTotalSpace ~= self.TotalSpace then
            self.LastTotalSpace = self.TotalSpace
            self:UpdateMarkers()
        end

        if self:CanScrollUp() then
            for i,v in pairs(button1.Arrow:GetChildren()) do
                v.BackgroundTransparency = 0
            end
        else
            button1.BackgroundTransparency = 1
            for i,v in pairs(button1.Arrow:GetChildren()) do
                v.BackgroundTransparency = 0.5
            end
        end
        if self:CanScrollDown() then
            for i,v in pairs(button2.Arrow:GetChildren()) do
                v.BackgroundTransparency = 0
            end
        else
            button2.BackgroundTransparency = 1
            for i,v in pairs(button2.Arrow:GetChildren()) do
                v.BackgroundTransparency = 0.5
            end
        end

        drawThumb(self)
    end

    funcs.UpdateMarkers = function(self)
        local markerFrame = self.GuiElems.MarkerFrame
        markerFrame:ClearAllChildren()

        for i,v in pairs(self.Markers) do
            if i < self.TotalSpace then
                createSimple("TextButton",{
                    BackgroundTransparency = 0,
                    BackgroundColor3 = v,
                    BorderSizePixel = 0,
                    Position = self.Horizontal and UDim2.new(i/self.TotalSpace,0,1,-6) or UDim2.new(1,-6,i/self.TotalSpace,0),
                    Size = self.Horizontal and UDim2.new(0,1,0,6) or UDim2.new(0,6,0,1),
                    Name = "Marker"..tostring(i),
                    Parent = markerFrame,
                    Text = "",
                    AutoButtonColor = false,
                })
            end
        end
    end

    funcs.AddMarker = function(self,ind,color)
        self.Markers[ind] = color or Color3.new(0,0,0)
    end
    funcs.ScrollTo = function(self,ind,nocallback)
        self.Index = ind
        self:Update()
        if not nocallback then
            self.Scrolled:Fire()
        end
    end
    funcs.ScrollUp = function(self)
        self.Index = self.Index - self.Increment
        self:Update()
    end
    funcs.ScrollDown = function(self)
        self.Index = self.Index + self.Increment
        self:Update()
    end
    funcs.CanScrollUp = function(self)
        return self.Index > 0
    end
    funcs.CanScrollDown = function(self)
        return self.Index + self.VisibleSpace < self.TotalSpace
    end
    funcs.GetScrollPercent = function(self)
        return self.Index/(self.TotalSpace-self.VisibleSpace)
    end
    funcs.SetScrollPercent = function(self,perc)
        self.Index = math.floor(perc*(self.TotalSpace-self.VisibleSpace))
        self:Update()
    end

    funcs.Texture = function(self,data)
        self.ThumbColor = data.ThumbColor or Color3.new(0,0,0)
        self.ThumbSelectColor = data.ThumbSelectColor or Color3.new(0,0,0)
        self.GuiElems.ScrollThumb.BackgroundColor3 = data.ThumbColor or Color3.new(0,0,0)
        self.Gui.BackgroundColor3 = data.FrameColor or Color3.new(0,0,0)
        self.GuiElems.Button1.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
        self.GuiElems.Button2.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
        for i,v in pairs(self.GuiElems.Button1.Arrow:GetChildren()) do
            v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
        end
        for i,v in pairs(self.GuiElems.Button2.Arrow:GetChildren()) do
            v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
        end
    end

    funcs.SetScrollFrame = function(self,frame)
        if self.ScrollUpEvent then self.ScrollUpEvent:Disconnect() self.ScrollUpEvent = nil end
        if self.ScrollDownEvent then self.ScrollDownEvent:Disconnect() self.ScrollDownEvent = nil end
        self.ScrollUpEvent = frame.MouseWheelForward:Connect(function() self:ScrollTo(self.Index - self.WheelIncrement) end)
        self.ScrollDownEvent = frame.MouseWheelBackward:Connect(function() self:ScrollTo(self.Index + self.WheelIncrement) end)
    end

    local mt = {}
    mt.__index = funcs

    local function new(hor)
        local obj = setmetatable({
            Index = 0,
            VisibleSpace = 0,
            TotalSpace = 0,
            Increment = 1,
            WheelIncrement = 1,
            Markers = {},
            GuiElems = {},
            Horizontal = hor,
            LastTotalSpace = 0,
            Scrolled = Lib.Signal.new()
        },mt)
        obj.Gui = createFrame(obj)
        obj:Texture({
            ThumbColor = Color3.fromRGB(60,60,60),
            ThumbSelectColor = Color3.fromRGB(75,75,75),
            ArrowColor = Color3.new(1,1,1),
            FrameColor = Color3.fromRGB(40,40,40),
            ButtonColor = Color3.fromRGB(75,75,75)
        })
        return obj
    end

    return {new = new}
end)()
Lib.CodeFrame = (function()
    local funcs = {}

    local typeMap = {
        [0] = "String",
        [1] = "String",
        [2] = "String",
        [3] = "String",
        [4] = "Comment",
        [5] = "Operator",
        [6] = "Number",
        [7] = "Keyword",
        [8] = "BuiltIn",
        [9] = "LocalMethod",
        [10] = "LocalProperty",
        [11] = "Nil",
        [12] = "Bool",
        [13] = "Function",
        [14] = "Local",
        [15] = "Self",
        [16] = "FunctionName",
        [17] = "Bracket"
    }

    local specialKeywordsTypes = {
        ["nil"] = 11,
        ["true"] = 12,
        ["false"] = 12,
        ["function"] = 13,
        ["local"] = 14
    }

    local keywords = {
        ["and"] = true,
        ["break"] = true, 
        ["do"] = true,
        ["else"] = true,
        ["elseif"] = true,
        ["end"] = true,
        ["false"] = true,
        ["for"] = true,
        ["function"] = true,
        ["if"] = true,
        ["in"] = true,
        ["local"] = true,
        ["nil"] = true,
        ["not"] = true,
        ["or"] = true,
        ["repeat"] = true,
        ["return"] = true,
        ["then"] = true,
        ["true"] = true,
        ["until"] = true,
        ["while"] = true,
        ["type"] = true,
        ["typeof"] = true,
        ["self"] = true,
        ["export"] = true,
        ["continue"] = true,
        ["CSpy"] = true,
        ["Spy"] = true
    }

    local builtIns = {}
    for i,_ in pairs(ENV) do
        builtIns[i] = true
    end

    local builtInInited = false

    local richReplace = {
        ["'"] = "&apos;",
        ["\""] = "&quot;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ["&"] = "&amp;"
    }

    local tabSub = "\205"
    local tabReplacement = (" %s%s "):format(tabSub,tabSub)

    local tabJumps = {
        [("[^%s] %s"):format(tabSub,tabSub)] = 0,
        [(" %s%s"):format(tabSub,tabSub)] = -1,
        [("%s%s "):format(tabSub,tabSub)] = 2,
        [("%s [^%s]"):format(tabSub,tabSub)] = 1,
    }

    local tweenService = service.TweenService
    local lineTweens = {}

    local function initBuiltIn()
        local env = getfenv()
        local type = type
        local tostring = tostring
        for name,_ in next,builtIns do
            local envVal = env[name]
            if type(envVal) == "table" and name ~= "_G" then
                local items = {}
                for i,v in next,envVal do
                    items[i] = true
                end
                builtIns[name] = items
            end
        end

        local enumEntries = {}
        local enums = Enum:GetEnums()
        for i = 1,#enums do
            enumEntries[tostring(enums[i])] = true
        end
        builtIns["Enum"] = enumEntries

        builtInInited = true
    end

    local function setupEditBox(obj)
        local editBox = obj.GuiElems.EditBox

        editBox.Focused:Connect(function()
            obj:ConnectEditBoxEvent()
            obj.Editing = true
        end)

        editBox.FocusLost:Connect(function()
            obj:DisconnectEditBoxEvent()
            obj.Editing = false
        end)

        editBox:GetPropertyChangedSignal("Text"):Connect(function()
            local text:string = editBox.Text
            if #text == 0 or obj.EditBoxCopying then return end
            editBox.Text = ""
            obj:AppendText(text:gsub("    ","    ").."")
        end)
    end

    local function setupMouseSelection(obj)
        local mouse = plr and plr:GetMouse()
        local codeFrame = obj.GuiElems.LinesFrame
        local lines = obj.Lines

        codeFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local fontSizeX,fontSizeY = math.ceil(obj.FontSize/2),obj.FontSize

                local relX = mouse.X - codeFrame.AbsolutePosition.X
                local relY = mouse.Y - codeFrame.AbsolutePosition.Y
                local selX = math.round(relX / fontSizeX) + obj.ViewX
                local selY = math.floor(relY / fontSizeY) + obj.ViewY
                local releaseEvent,mouseEvent,scrollEvent
                local scrollPowerV,scrollPowerH = 0,0
                selY = math.min(#lines-1,selY)
                local relativeLine = lines[selY+1] or ""
                selX = math.min(#relativeLine, selX + obj:TabAdjust(selX,selY))

                obj.SelectionRange = {{-1,-1},{-1,-1}}
                obj:MoveCursor(selX,selY)
                obj.FloatCursorX = selX

                local function updateSelection()
                    local relX = mouse.X - codeFrame.AbsolutePosition.X
                    local relY = mouse.Y - codeFrame.AbsolutePosition.Y
                    local sel2X = math.max(0,math.round(relX / fontSizeX) + obj.ViewX)
                    local sel2Y = math.max(0,math.floor(relY / fontSizeY) + obj.ViewY)

                    sel2Y = math.min(#lines-1,sel2Y)
                    local relativeLine = lines[sel2Y+1] or ""
                    sel2X = math.min(#relativeLine, sel2X + obj:TabAdjust(sel2X,sel2Y))

                    if sel2Y < selY or (sel2Y == selY and sel2X < selX) then
                        obj.SelectionRange = {{sel2X,sel2Y},{selX,selY}}
                    else                        
                        obj.SelectionRange = {{selX,selY},{sel2X,sel2Y}}
                    end

                    obj:MoveCursor(sel2X,sel2Y)
                    obj.FloatCursorX = sel2X
                    obj:Refresh()
                end

                releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        releaseEvent:Disconnect()
                        mouseEvent:Disconnect()
                        scrollEvent:Disconnect()
                        obj:SetCopyableSelection()
                        --updateSelection()
                    end
                end)

                mouseEvent = service.UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local upDelta = mouse.Y - codeFrame.AbsolutePosition.Y
                        local downDelta = mouse.Y - codeFrame.AbsolutePosition.Y - codeFrame.AbsoluteSize.Y
                        local leftDelta = mouse.X - codeFrame.AbsolutePosition.X
                        local rightDelta = mouse.X - codeFrame.AbsolutePosition.X - codeFrame.AbsoluteSize.X
                        scrollPowerV = 0
                        scrollPowerH = 0
                        if downDelta > 0 then
                            scrollPowerV = math.floor(downDelta*0.05) + 1
                        elseif upDelta < 0 then
                            scrollPowerV = math.ceil(upDelta*0.05) - 1
                        end
                        if rightDelta > 0 then
                            scrollPowerH = math.floor(rightDelta*0.05) + 1
                        elseif leftDelta < 0 then
                            scrollPowerH = math.ceil(leftDelta*0.05) - 1
                        end
                        updateSelection()
                    end
                end)

                scrollEvent = clonerefs(game:GetService("RunService")).RenderStepped:Connect(function()
                    if scrollPowerV ~= 0 or scrollPowerH ~= 0 then
                        obj:ScrollDelta(scrollPowerH,scrollPowerV)
                        updateSelection()
                    end
                end)

                obj:Refresh()
            end
        end)
    end

    local function makeFrame(obj)
        local frame = create({
            {1,"TextButton",{AutoButtonColor=false,Text="",BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel = 0,Position=UDim2.new(0.5,-300,0.5,-200),Size=UDim2.new(0,600,0,400)}},
        })
        local elems = {}

        local linesFrame = Instance.new("Frame")
        linesFrame.Name = "Lines"
        linesFrame.BackgroundTransparency = 1
        linesFrame.Size = UDim2.new(1,0,1,0)
        linesFrame.ClipsDescendants = true
        linesFrame.Parent = frame

        local lineNumbersLabel = Instance.new("TextLabel")
        lineNumbersLabel.Name = "LineNumbers"
        lineNumbersLabel.BackgroundTransparency = 1
        lineNumbersLabel.Font = Enum.Font.Code
        lineNumbersLabel.TextXAlignment = Enum.TextXAlignment.Right
        lineNumbersLabel.TextYAlignment = Enum.TextYAlignment.Top
        lineNumbersLabel.ClipsDescendants = true
        lineNumbersLabel.RichText = true
        lineNumbersLabel.Parent = frame

        local cursor = Instance.new("TextButton")
        cursor.Name = "Cursor"
        cursor.BackgroundColor3 = Color3.fromRGB(220,220,220)
        cursor.BorderSizePixel = 0
        cursor.Parent = frame
        cursor.Text = ""
        cursor.AutoButtonColor = false

        local editBox = Instance.new("TextBox")
        editBox.Name = "EditBox"
        editBox.MultiLine = true
        editBox.Visible = false
        editBox.Parent = frame

        lineTweens.Invis = tweenService:Create(cursor,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency = 1})
        lineTweens.Vis = tweenService:Create(cursor,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency = 0})

        elems.LinesFrame = linesFrame
        elems.LineNumbersLabel = lineNumbersLabel
        elems.Cursor = cursor
        elems.EditBox = editBox
        elems.ScrollCorner = create({{1,"TextButton",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="ScrollCorner",Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,16,0,16),Visible=false,Text="",AutoButtonColor=false}}})

        elems.ScrollCorner.Parent = frame
        linesFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                obj:SetEditing(true,input)
            end
        end)

        obj.Frame = frame
        obj.Gui = frame
        obj.GuiElems = elems
        setupEditBox(obj)
        setupMouseSelection(obj)

        return frame
    end

    funcs.GetSelectionText = function(self)
        if not self:IsValidRange() then return "" end

        local selectionRange = self.SelectionRange
        local selX,selY = selectionRange[1][1], selectionRange[1][2]
        local sel2X,sel2Y = selectionRange[2][1], selectionRange[2][2]
        local deltaLines = sel2Y-selY
        local lines = self.Lines

        if not lines[selY+1] or not lines[sel2Y+1] then return "" end

        if deltaLines == 0 then
            return self:ConvertText(lines[selY+1]:sub(selX+1,sel2X), false)
        end

        local leftSub = lines[selY+1]:sub(selX+1)
        local rightSub = lines[sel2Y+1]:sub(1,sel2X)

        local result = leftSub.."\n" 
        for i = selY+1,sel2Y-1 do
            result = result..lines[i+1].."\n"
        end
        result = result..rightSub

        return self:ConvertText(result,false)
    end

    funcs.SetCopyableSelection = function(self)
        local text = self:GetSelectionText()
        local editBox = self.GuiElems.EditBox

        self.EditBoxCopying = true
        editBox.Text = text
        editBox.SelectionStart = 1
        editBox.CursorPosition = #editBox.Text + 1
        self.EditBoxCopying = false
    end

    funcs.ConnectEditBoxEvent = function(self)
        if self.EditBoxEvent then
            self.EditBoxEvent:Disconnect()
        end

        self.EditBoxEvent = service.UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            local keycodes = Enum.KeyCode
            local keycode = input.KeyCode

            local function setupMove(key,func)
                local endCon,finished
                endCon = service.UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode ~= key then return end
                    endCon:Disconnect()
                    finished = true
                end)
                func()
                Lib.FastWait(0.5)
                while not finished do func() Lib.FastWait(0.03) end
            end

            if keycode == keycodes.Down then
                setupMove(keycodes.Down,function()
                    self.CursorX = self.FloatCursorX
                    self.CursorY = self.CursorY + 1
                    self:UpdateCursor()
                    self:JumpToCursor()
                end)
            elseif keycode == keycodes.Up then
                setupMove(keycodes.Up,function()
                    self.CursorX = self.FloatCursorX
                    self.CursorY = self.CursorY - 1
                    self:UpdateCursor()
                    self:JumpToCursor()
                end)
            elseif keycode == keycodes.Left then
                setupMove(keycodes.Left,function()
                    local line = self.Lines[self.CursorY+1] or ""
                    self.CursorX = self.CursorX - 1 - (line:sub(self.CursorX-3,self.CursorX) == tabReplacement and 3 or 0)
                    if self.CursorX < 0 then
                        self.CursorY = self.CursorY - 1
                        local line2 = self.Lines[self.CursorY+1] or ""
                        self.CursorX = #line2
                    end
                    self.FloatCursorX = self.CursorX
                    self:UpdateCursor()
                    self:JumpToCursor()
                end)
            elseif keycode == keycodes.Right then
                setupMove(keycodes.Right,function()
                    local line = self.Lines[self.CursorY+1] or ""
                    self.CursorX = self.CursorX + 1 + (line:sub(self.CursorX+1,self.CursorX+4) == tabReplacement and 3 or 0)
                    if self.CursorX > #line then
                        self.CursorY = self.CursorY + 1
                        self.CursorX = 0
                    end
                    self.FloatCursorX = self.CursorX
                    self:UpdateCursor()
                    self:JumpToCursor()
                end)
            elseif keycode == keycodes.Backspace then
                setupMove(keycodes.Backspace,function()
                    local startRange,endRange
                    if self:IsValidRange() then
                        startRange = self.SelectionRange[1]
                        endRange = self.SelectionRange[2]
                    else
                        endRange = {self.CursorX,self.CursorY}
                    end

                    if not startRange then
                        local line = self.Lines[self.CursorY+1] or ""
                        self.CursorX = self.CursorX - 1 - (line:sub(self.CursorX-3,self.CursorX) == tabReplacement and 3 or 0)
                        if self.CursorX < 0 then
                            self.CursorY = self.CursorY - 1
                            local line2 = self.Lines[self.CursorY+1] or ""
                            self.CursorX = #line2
                        end
                        self.FloatCursorX = self.CursorX
                        self:UpdateCursor()

                        startRange = startRange or {self.CursorX,self.CursorY}
                    end

                    self:DeleteRange({startRange,endRange},false,true)
                    self:ResetSelection(true)
                    self:JumpToCursor()
                end)
            elseif keycode == keycodes.Delete then
                setupMove(keycodes.Delete,function()
                    local startRange,endRange
                    if self:IsValidRange() then
                        startRange = self.SelectionRange[1]
                        endRange = self.SelectionRange[2]
                    else
                        startRange = {self.CursorX,self.CursorY}
                    end

                    if not endRange then
                        local line = self.Lines[self.CursorY+1] or ""
                        local endCursorX = self.CursorX + 1 + (line:sub(self.CursorX+1,self.CursorX+4) == tabReplacement and 3 or 0)
                        local endCursorY = self.CursorY
                        if endCursorX > #line then
                            endCursorY = endCursorY + 1
                            endCursorX = 0
                        end
                        self:UpdateCursor()

                        endRange = endRange or {endCursorX,endCursorY}
                    end

                    self:DeleteRange({startRange,endRange},false,true)
                    self:ResetSelection(true)
                    self:JumpToCursor()
                end)
            elseif service.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                if keycode == keycodes.A then
                    self.SelectionRange = {{0,0},{#self.Lines[#self.Lines],#self.Lines-1}}
                    self:SetCopyableSelection()
                    self:Refresh()
                end
            end
        end)
    end

    funcs.DisconnectEditBoxEvent = function(self)
        if self.EditBoxEvent then
            self.EditBoxEvent:Disconnect()
        end
    end

    funcs.ResetSelection = function(self,norefresh)
        self.SelectionRange = {{-1,-1},{-1,-1}}
        if not norefresh then self:Refresh() end
    end

    funcs.IsValidRange = function(self,range)
        local selectionRange = range or self.SelectionRange
        local selX,selY = selectionRange[1][1], selectionRange[1][2]
        local sel2X,sel2Y = selectionRange[2][1], selectionRange[2][2]

        if selX == -1 or (selX == sel2X and selY == sel2Y) then return false end

        return true
    end

    funcs.DeleteRange = function(self,range,noprocess,updatemouse)
        range = range or self.SelectionRange
        if not self:IsValidRange(range) then return end

        local lines = self.Lines
        local selX,selY = range[1][1], range[1][2]
        local sel2X,sel2Y = range[2][1], range[2][2]
        local deltaLines = sel2Y-selY

        if not lines[selY+1] or not lines[sel2Y+1] then return end

        local leftSub = lines[selY+1]:sub(1,selX)
        local rightSub = lines[sel2Y+1]:sub(sel2X+1)
        lines[selY+1] = leftSub..rightSub

        local remove = table.remove
        for i = 1,deltaLines do
            remove(lines,selY+2)
        end

        if range == self.SelectionRange then self.SelectionRange = {{-1,-1},{-1,-1}} end
        if updatemouse then
            self.CursorX = selX
            self.CursorY = selY
            self:UpdateCursor()
        end

        if not noprocess then
            self:ProcessTextChange()
        end
    end

    funcs.AppendText = function(self,text)
        self:DeleteRange(nil,true,true)
        local lines,cursorX,cursorY = self.Lines,self.CursorX,self.CursorY
        local line = lines[cursorY+1]
        local before = line:sub(1,cursorX)
        local after = line:sub(cursorX+1)

        text = text:gsub("\r\n","\n")
        text = self:ConvertText(text,true) -- Tab Convert

        local textLines = text:split("\n")
        local insert = table.insert

        for i = 1,#textLines do
            local linePos = cursorY+i
            if i > 1 then insert(lines,linePos,"") end

            local textLine = textLines[i]
            local newBefore = (i == 1 and before or "")
            local newAfter = (i == #textLines and after or "")

            lines[linePos] = newBefore..textLine..newAfter
        end

        if #textLines > 1 then cursorX = 0 end

        self:ProcessTextChange()
        self.CursorX = cursorX + #textLines[#textLines]
        self.CursorY = cursorY + #textLines-1
        self:UpdateCursor()
    end

    funcs.ScrollDelta = function(self,x,y)
        self.ScrollV:ScrollTo(self.ScrollV.Index + y)
        self.ScrollH:ScrollTo(self.ScrollH.Index + x)
    end

    -- x and y starts at 0
    funcs.TabAdjust = function(self,x,y)
        local lines = self.Lines
        local line = lines[y+1]
        x=x+1

        if line then
            local left = line:sub(x-1,x-1)
            local middle = line:sub(x,x)
            local right = line:sub(x+1,x+1)
            local selRange = (#left > 0 and left or " ") .. (#middle > 0 and middle or " ") .. (#right > 0 and right or " ")

            for i,v in pairs(tabJumps) do
                if selRange:find(i) then
                    return v
                end
            end
        end
        return 0
    end

    funcs.SetEditing = function(self,on,input)            
        self:UpdateCursor(input)

        if on then
            if self.Editable then
                self.GuiElems.EditBox.Text = ""
                self.GuiElems.EditBox:CaptureFocus()
            end
        else
            self.GuiElems.EditBox:ReleaseFocus()
        end
    end

    funcs.CursorAnim = function(self,on)
        local cursor = self.GuiElems.Cursor
        local animTime = tick()
        self.LastAnimTime = animTime

        if not on then return end

        lineTweens.Invis:Cancel()
        lineTweens.Vis:Cancel()
        cursor.BackgroundTransparency = 0

        coroutine.wrap(function()
            while self.Editable do
                Lib.FastWait(0.5)
                if self.LastAnimTime ~= animTime then return end
                lineTweens.Invis:Play()
                Lib.FastWait(0.4)
                if self.LastAnimTime ~= animTime then return end
                lineTweens.Vis:Play()
                Lib.FastWait(0.2)
            end
        end)()
    end

    funcs.MoveCursor = function(self,x,y)
        self.CursorX = x
        self.CursorY = y
        self:UpdateCursor()
        self:JumpToCursor()
    end

    funcs.JumpToCursor = function(self)
        self:Refresh()
    end

    funcs.UpdateCursor = function(self,input)
        local linesFrame = self.GuiElems.LinesFrame
        local cursor = self.GuiElems.Cursor            
        local hSize = math.max(0,linesFrame.AbsoluteSize.X)
        local vSize = math.max(0,linesFrame.AbsoluteSize.Y)
        local maxLines = math.ceil(vSize / self.FontSize)
        local maxCols = math.ceil(hSize / math.ceil(self.FontSize/2))
        local viewX,viewY = self.ViewX,self.ViewY
        local totalLinesStr = tostring(#self.Lines)
        local fontWidth = math.ceil(self.FontSize / 2)
        local linesOffset = #totalLinesStr*fontWidth + 4*fontWidth

        if input then
            local linesFrame = self.GuiElems.LinesFrame
            local frameX,frameY = linesFrame.AbsolutePosition.X,linesFrame.AbsolutePosition.Y
            local mouseX,mouseY = input.Position.X,input.Position.Y
            local fontSizeX,fontSizeY = math.ceil(self.FontSize/2),self.FontSize

            self.CursorX = self.ViewX + math.round((mouseX - frameX) / fontSizeX)
            self.CursorY = self.ViewY + math.floor((mouseY - frameY) / fontSizeY)
        end

        local cursorX,cursorY = self.CursorX,self.CursorY

        local line = self.Lines[cursorY+1] or ""
        if cursorX > #line then cursorX = #line
        elseif cursorX < 0 then cursorX = 0 end

        if cursorY >= #self.Lines then
            cursorY = math.max(0,#self.Lines-1)
        elseif cursorY < 0 then
            cursorY = 0
        end

        cursorX = cursorX + self:TabAdjust(cursorX,cursorY)

        -- Update modified
        self.CursorX = cursorX
        self.CursorY = cursorY

        local cursorVisible = (cursorX >= viewX) and (cursorY >= viewY) and (cursorX <= viewX + maxCols) and (cursorY <= viewY + maxLines)
        if cursorVisible then
            local offX = (cursorX - viewX)
            local offY = (cursorY - viewY)
            cursor.Position = UDim2.new(0,linesOffset + offX*math.ceil(self.FontSize/2) - 1,0,offY*self.FontSize)
            cursor.Size = UDim2.new(0,1,0,self.FontSize+2)
            cursor.Visible = true
            self:CursorAnim(true)
        else
            cursor.Visible = false
        end
    end

    funcs.MapNewLines = function(self)
        local newLines = {}
        local count = 1
        local text = self.Text
        local find = string.find
        local init = 1

        local pos = find(text,"\n",init,true)
        while pos do
            newLines[count] = pos
            count = count + 1
            init = pos + 1
            pos = find(text,"\n",init,true)
        end

        self.NewLines = newLines
    end

    funcs.PreHighlight = function(self)
        local start = tick()
        local text = self.Text:gsub("\\\\","  ")
        --print("BACKSLASH SUB",tick()-start)
        local textLen = #text
        local found = {}
        local foundMap = {}
        local extras = {}
        local find = string.find
        local sub = string.sub
        self.ColoredLines = {}

        local function findAll(str,pattern,typ,raw)
            local count = #found+1
            local init = 1
            local x,y,extra = find(str,pattern,init,raw)
            while x do
                found[count] = x
                foundMap[x] = typ
                if extra then
                    extras[x] = extra
                end

                count = count+1
                init = y+1
                x,y,extra = find(str,pattern,init,raw)
            end
        end
        local start = tick()
        findAll(text,"`",0,true)
        findAll(text,'"',1,true)
        findAll(text,"'",2,true)
        findAll(text,"%[(=*)%[",3)
        findAll(text,"--",4,true)
        table.sort(found)

        local newLines = self.NewLines
        local curLine = 0
        local lineTableCount = 1
        local lineStart = 0
        local lineEnd = 0
        local lastEnding = 0
        local foundHighlights = {}

        for i = 1,#found do
            local pos = found[i]
            if pos <= lastEnding then continue end

            local ending = pos
            local typ = foundMap[pos]
            if typ == 0 then
                ending = find(text,"`",pos+1,true)
                while ending and sub(text,ending-1,ending-1) == "\\" do
                    ending = find(text,"`",ending+1,true)
                end
                if not ending then ending = textLen end
            elseif typ == 1 then
                ending = find(text,'"',pos+1,true)
                while ending and sub(text,ending-1,ending-1) == "\\" do
                    ending = find(text,'"',ending+1,true)
                end
                if not ending then ending = textLen end
            elseif typ == 2 then
                ending = find(text,"'",pos+1,true)
                while ending and sub(text,ending-1,ending-1) == "\\" do
                    ending = find(text,"'",ending+1,true)
                end
                if not ending then ending = textLen end
            elseif typ == 3 then
                _,ending = find(text,"]"..extras[pos].."]",pos+1,true)
                if not ending then ending = textLen end
            elseif typ == 4 then
                local ahead = foundMap[pos+2]

                if ahead == 3 then
                    _,ending = find(text,"]"..extras[pos+2].."]",pos+1,true)
                    if not ending then ending = textLen end
                else
                    ending = find(text,"\n",pos+1,true) or textLen
                end
            end

            while pos > lineEnd do
                curLine = curLine + 1
                --lineTableCount = 1
                lineEnd = newLines[curLine] or textLen+1
            end
            while true do
                local lineTable = foundHighlights[curLine]
                if not lineTable then lineTable = {} foundHighlights[curLine] = lineTable end
                lineTable[pos] = {typ,ending}
                --lineTableCount = lineTableCount + 1

                if ending > lineEnd then
                    curLine = curLine + 1
                    lineEnd = newLines[curLine] or textLen+1
                else
                    break
                end
            end

            lastEnding = ending
            --if i < 200 then print(curLine) end
        end
        self.PreHighlights = foundHighlights
        --print(tick()-start)
        --print(#found,curLine)
    end

    funcs.HighlightLine = function(self,line)
        local cached = self.ColoredLines[line]
        if cached then return cached end

        local sub = string.sub
        local find = string.find
        local match = string.match
        local highlights = {}
        local preHighlights = self.PreHighlights[line] or {}
        local lineText = self.Lines[line] or ""
        local lineLen = #lineText
        local lastEnding = 0
        local currentType = 0
        local lastWord = nil
        local wordBeginsDotted = false
        local funcStatus = 0
        local lineStart = self.NewLines[line-1] or 0

        local preHighlightMap = {}
        for pos,data in next,preHighlights do
            local relativePos = pos-lineStart
            if relativePos < 1 then
                currentType = data[1]
                lastEnding = data[2] - lineStart
                --warn(pos,data[2])
            else
                preHighlightMap[relativePos] = {data[1],data[2]-lineStart}
            end
        end

        for col = 1,#lineText do
            if col <= lastEnding then highlights[col] = currentType continue end

            local pre = preHighlightMap[col]
            if pre then
                currentType = pre[1]
                lastEnding = pre[2]
                highlights[col] = currentType
                wordBeginsDotted = false
                lastWord = nil
                funcStatus = 0
            else
                local char = sub(lineText,col,col)
                if find(char,"[%a_]") then
                    local word = match(lineText,"[%a%d_]+",col)
                    local wordType = (keywords[word] and 7) or (builtIns[word] and 8)

                    lastEnding = col+#word-1

                    if wordType ~= 7 then
                        if wordBeginsDotted then
                            local prevBuiltIn = lastWord and builtIns[lastWord]
                            wordType = (prevBuiltIn and type(prevBuiltIn) == "table" and prevBuiltIn[word] and 8) or 10
                        end

                        if wordType ~= 8 then
                            local x,y,br = find(lineText,"^%s*([%({\"'])",lastEnding+1)
                            if x then
                                wordType = (funcStatus > 0 and br == "(" and 16) or 9
                                funcStatus = 0
                            end
                        end
                    else
                        wordType = specialKeywordsTypes[word] or wordType
                        funcStatus = (word == "function" and 1 or 0)
                    end

                    lastWord = word
                    wordBeginsDotted = false
                    if funcStatus > 0 then funcStatus = 1 end

                    if wordType then
                        currentType = wordType
                        highlights[col] = currentType
                    else
                        currentType = nil
                    end
                elseif find(char,"%p") then
                    local isDot = (char == ".")
                    local isNum = isDot and find(sub(lineText,col+1,col+1),"%d")
                    highlights[col] = (isNum and 6 or 5)

                    if not isNum then
                        local dotStr = isDot and match(lineText,"%.%.?%.?",col)
                        if dotStr and #dotStr > 1 then
                            currentType = 5
                            lastEnding = col+#dotStr-1
                            wordBeginsDotted = false
                            lastWord = nil
                            funcStatus = 0
                        else
                            if isDot then
                                if wordBeginsDotted then
                                    lastWord = nil
                                else
                                    wordBeginsDotted = true
                                end
                            else
                                wordBeginsDotted = false
                                lastWord = nil
                            end

                            funcStatus = ((isDot or char == ":") and funcStatus == 1 and 2) or 0
                        end
                    end
                elseif find(char,"%d") then
                    local _,endPos = find(lineText,"%x+",col)
                    local endPart = sub(lineText,endPos,endPos+1)
                    if (endPart == "e+" or endPart == "e-") and find(sub(lineText,endPos+2,endPos+2),"%d") then
                        endPos = endPos + 1
                    end
                    currentType = 6
                    lastEnding = endPos
                    highlights[col] = 6
                    wordBeginsDotted = false
                    lastWord = nil
                    funcStatus = 0
                else
                    highlights[col] = currentType
                    local _,endPos = find(lineText,"%s+",col)
                    if endPos then
                        lastEnding = endPos
                    end
                end
            end
        end

        self.ColoredLines[line] = highlights
        return highlights
    end

    funcs.Refresh = function(self)
        local start = tick()

        local linesFrame = self.Frame.Lines
        local hSize = math.max(0,linesFrame.AbsoluteSize.X)
        local vSize = math.max(0,linesFrame.AbsoluteSize.Y)
        local maxLines = math.ceil(vSize / self.FontSize)
        local maxCols = math.ceil(hSize / math.ceil(self.FontSize/2))
        local gsub = string.gsub
        local sub = string.sub

        local viewX,viewY = self.ViewX,self.ViewY

        local lineNumberStr = ""

        for row = 1,maxLines do
            local lineFrame = self.LineFrames[row]
            if not lineFrame then
                lineFrame = Instance.new("Frame")
                lineFrame.Name = "Line"
                lineFrame.Position = UDim2.new(0,0,0,(row-1)*self.FontSize)
                lineFrame.Size = UDim2.new(1,0,0,self.FontSize)
                lineFrame.BorderSizePixel = 0
                lineFrame.BackgroundTransparency = 1

                local selectionHighlight = Instance.new("Frame")
                selectionHighlight.Name = "SelectionHighlight"
                selectionHighlight.BorderSizePixel = 0
                selectionHighlight.BackgroundColor3 = Settings.Theme.Syntax.SelectionBack
                selectionHighlight.Parent = lineFrame

                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Code
                label.TextSize = self.FontSize
                label.Size = UDim2.new(1,0,0,self.FontSize)
                label.RichText = true
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextColor3 = self.Colors.Text
                label.ZIndex = 2
                label.Parent = lineFrame

                lineFrame.Parent = linesFrame
                self.LineFrames[row] = lineFrame
            end

            local relaY = viewY + row
            local lineText = self.Lines[relaY] or ""
            local resText = ""
            local highlights = self:HighlightLine(relaY)
            local colStart = viewX + 1

            local richTemplates = self.RichTemplates
            local textTemplate = richTemplates.Text
            local selectionTemplate = richTemplates.Selection
            local curType = highlights[colStart]
            local curTemplate = richTemplates[typeMap[curType]] or textTemplate

            -- Selection Highlight
            local selectionRange = self.SelectionRange
            local selPos1 = selectionRange[1]
            local selPos2 = selectionRange[2]
            local selRow,selColumn = selPos1[2],selPos1[1]
            local sel2Row,sel2Column = selPos2[2],selPos2[1]
            local selRelaX,selRelaY = viewX,relaY-1

            if selRelaY >= selPos1[2] and selRelaY <= selPos2[2] then
                local fontSizeX = math.ceil(self.FontSize/2)
                local posX = (selRelaY == selPos1[2] and selPos1[1] or 0) - viewX
                local sizeX = (selRelaY == selPos2[2] and selPos2[1]-posX-viewX or maxCols+viewX)

                lineFrame.SelectionHighlight.Position = UDim2.new(0,posX*fontSizeX,0,0)
                lineFrame.SelectionHighlight.Size = UDim2.new(0,sizeX*fontSizeX,1,0)
                lineFrame.SelectionHighlight.Visible = true
            else
                lineFrame.SelectionHighlight.Visible = false
            end

            -- Selection Text Color for first char
            local inSelection = selRelaY >= selRow and selRelaY <= sel2Row and (selRelaY == selRow and viewX >= selColumn or selRelaY ~= selRow) and (selRelaY == sel2Row and viewX < sel2Column or selRelaY ~= sel2Row)
            if inSelection then
                curType = -999
                curTemplate = selectionTemplate
            end

            for col = 2,maxCols do
                local relaX = viewX + col
                local selRelaX = relaX-1
                local posType = highlights[relaX]

                -- Selection Text Color
                local inSelection = selRelaY >= selRow and selRelaY <= sel2Row and (selRelaY == selRow and selRelaX >= selColumn or selRelaY ~= selRow) and (selRelaY == sel2Row and selRelaX < sel2Column or selRelaY ~= sel2Row)
                if inSelection then
                    posType = -999
                end

                if posType ~= curType then
                    local template = (inSelection and selectionTemplate) or richTemplates[typeMap[posType]] or textTemplate

                    if template ~= curTemplate then
                        local nextText = gsub(sub(lineText,colStart,relaX-1),"['\"<>&]",richReplace)
                        resText = resText .. (curTemplate ~= textTemplate and (curTemplate .. nextText .. "</font>") or nextText)
                        colStart = relaX
                        curTemplate = template
                    end
                    curType = posType
                end
            end

            local lastText = gsub(sub(lineText,colStart,viewX+maxCols),"['\"<>&]",richReplace)
            --warn("SUB",colStart,viewX+maxCols-1)
            if #lastText > 0 then
                resText = resText .. (curTemplate ~= textTemplate and (curTemplate .. lastText .. "</font>") or lastText)
            end

            if self.Lines[relaY] then
                lineNumberStr = lineNumberStr .. (relaY-1 == self.CursorY and ("<b>"..relaY.."</b>\n") or relaY .. "\n")
            end

            lineFrame.Label.Text = resText
        end

        for i = maxLines+1,#self.LineFrames do
            self.LineFrames[i]:Destroy()
            self.LineFrames[i] = nil
        end

        self.Frame.LineNumbers.Text = lineNumberStr
        self:UpdateCursor()

        --print("REFRESH TIME",tick()-start)
    end

    funcs.UpdateView = function(self)
        local totalLinesStr = tostring(#self.Lines)
        local fontWidth = math.ceil(self.FontSize / 2)
        local linesOffset = #totalLinesStr*fontWidth + 4*fontWidth

        local linesFrame = self.Frame.Lines
        local hSize = linesFrame.AbsoluteSize.X
        local vSize = linesFrame.AbsoluteSize.Y
        local maxLines = math.ceil(vSize / self.FontSize)
        local totalWidth = self.MaxTextCols*fontWidth
        local scrollV = self.ScrollV
        local scrollH = self.ScrollH

        scrollV.VisibleSpace = maxLines
        scrollV.TotalSpace = #self.Lines + 1
        scrollH.VisibleSpace = math.ceil(hSize/fontWidth)
        scrollH.TotalSpace = self.MaxTextCols + 1

        scrollV.Gui.Visible = #self.Lines + 1 > maxLines
        scrollH.Gui.Visible = totalWidth > hSize

        local oldOffsets = self.FrameOffsets
        self.FrameOffsets = Vector2.new(scrollV.Gui.Visible and -16 or 0, scrollH.Gui.Visible and -16 or 0)
        if oldOffsets ~= self.FrameOffsets then
            self:UpdateView()
        else
            scrollV:ScrollTo(self.ViewY,true)
            scrollH:ScrollTo(self.ViewX,true)

            if scrollV.Gui.Visible and scrollH.Gui.Visible then
                scrollV.Gui.Size = UDim2.new(0,16,1,-16)
                scrollH.Gui.Size = UDim2.new(1,-16,0,16)
                self.GuiElems.ScrollCorner.Visible = true
            else
                scrollV.Gui.Size = UDim2.new(0,16,1,0)
                scrollH.Gui.Size = UDim2.new(1,0,0,16)
                self.GuiElems.ScrollCorner.Visible = false
            end

            self.ViewY = scrollV.Index
            self.ViewX = scrollH.Index
            self.Frame.Lines.Position = UDim2.new(0,linesOffset,0,0)
            self.Frame.Lines.Size = UDim2.new(1,-linesOffset+oldOffsets.X,1,oldOffsets.Y)
            self.Frame.LineNumbers.Position = UDim2.new(0,fontWidth,0,0)
            self.Frame.LineNumbers.Size = UDim2.new(0,#totalLinesStr*fontWidth,1,oldOffsets.Y)
            self.Frame.LineNumbers.TextSize = self.FontSize
        end
    end

    funcs.ProcessTextChange = function(self)
        local maxCols = 0
        local lines = self.Lines

        for i = 1,#lines do
            local lineLen = #lines[i]
            if lineLen > maxCols then
                maxCols = lineLen
            end
        end

        self.MaxTextCols = maxCols
        self:UpdateView()    
        self.Text = table.concat(self.Lines,"\n")
        self:MapNewLines()
        self:PreHighlight()
        self:Refresh()
        --self.TextChanged:Fire()
    end

    funcs.ConvertText = function(self,text,toEditor)
        if toEditor then
            return text:gsub("\t",(" %s%s "):format(tabSub,tabSub))
        else
            return text:gsub((" %s%s "):format(tabSub,tabSub),"\t")
        end
    end

    funcs.GetText = function(self) -- TODO: better (use new tab format)
        local source = table.concat(self.Lines,"\n")
        return self:ConvertText(source,false) -- Tab Convert
    end

    funcs.SetText = function(self,txt)
        txt = self:ConvertText(txt,true) -- Tab Convert
        local lines = self.Lines
        table.clear(lines)
        local count = 1

        for line in txt:gmatch("([^\n\r]*)[\n\r]?") do
            local len = #line
            lines[count] = line
            count = count + 1
        end

        self:ProcessTextChange()
    end

    funcs.MakeRichTemplates = function(self)
        local floor = math.floor
        local templates = {}

        for name,color in pairs(self.Colors) do
            templates[name] = ('<font color="rgb(%s,%s,%s)">'):format(floor(color.r*255),floor(color.g*255),floor(color.b*255))
        end

        self.RichTemplates = templates
    end

    funcs.ApplyTheme = function(self)
        local colors = Settings.Theme.Syntax
        self.Colors = colors
        self.Frame.LineNumbers.TextColor3 = colors.Text
        self.Frame.BackgroundTransparency = 0.975
        self.Frame.BackgroundColor3 = colors.Background
    end

    local mt = {__index = funcs}

    local function new()
        if not builtInInited then initBuiltIn() end

        local scrollV = Lib.ScrollBar.new()
        local scrollH = Lib.ScrollBar.new(true)
        scrollH.Gui.Position = UDim2.new(0,0,1,-16)
        local obj = setmetatable({
            FontSize = 15,
            ViewX = 0,
            ViewY = 0,
            Colors = Settings.Theme.Syntax,
            ColoredLines = {},
            Lines = {""},
            LineFrames = {},
            Editable = true,
            Editing = false,
            CursorX = 0,
            CursorY = 0,
            FloatCursorX = 0,
            Text = "",
            PreHighlights = {},
            SelectionRange = {{-1,-1},{-1,-1}},
            NewLines = {},
            FrameOffsets = Vector2.new(0,0),
            MaxTextCols = 0,
            ScrollV = scrollV,
            ScrollH = scrollH
        },mt)

        scrollV.WheelIncrement = 3
        scrollH.Increment = 2
        scrollH.WheelIncrement = 7

        scrollV.Scrolled:Connect(function()
            obj.ViewY = scrollV.Index
            obj:Refresh()
        end)

        scrollH.Scrolled:Connect(function()
            obj.ViewX = scrollH.Index
            obj:Refresh()
        end)

        makeFrame(obj)
        obj:MakeRichTemplates()
        obj:ApplyTheme()
        scrollV:SetScrollFrame(obj.Frame.Lines)
        scrollV.Gui.Parent = obj.Frame
        scrollH.Gui.Parent = obj.Frame

        obj:UpdateView()
        obj.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            obj:UpdateView()
            obj:Refresh()
        end)

        return obj
    end

    return {new = new}
end)()

return function(textbox,env)
    ENV = env or ENV
    local par = textbox.Parent
    local new = Lib.CodeFrame.new()
    new.Gui.Parent = par
    for i,v in pairs(textbox:GetChildren()) do
        if v then
            v.Parent = new.Gui
        end
    end
    new.Gui.Size = textbox.Size
    new.Gui.Position = textbox.Position
    new.Gui.AnchorPoint = textbox.AnchorPoint
    new.Gui.Visible = textbox.Visible
    textbox:Destroy()
    return setmetatable({},{
        __index = function(self,name)
            if name == "Text" then
                return new:GetText()
            else
                return new.Gui[name]
            end
        end,
        __newindex = function(self,name,val)
            if name == "Text" then
                new:SetText(val:gsub("\t", "    "))
            else
                new.Gui[name] = val
            end
        end,
    })
end
    end;

    modules[objects["Instance13"]] = function()
        local script = objects["Instance13"];
return function(shared, page)
    if not getfenv().request then
        page.Contents.Visible = false
        page.Unavailable.Visible = true
        page.Parent.Parent.Buttons.Holder.List[page.Name].Visible = false
        return
    end
    
    local cons = shared.Connections
    local hooks = shared.HookFunction -- custom safe hooks
    local settings = shared.Settings

    local logExample = page.Contents.Logs.Log
    logExample.Visible = false

    local methodColors = {
        ["GET"] = Color3.fromRGB(85, 255, 127),
        ["POST"] = Color3.fromRGB(85, 255, 255),
        ["PUT"] = Color3.fromRGB(200, 200, 200),
        ["DELETE"] = Color3.fromRGB(255, 0, 0),
        ["HEADERS"] = Color3.fromRGB(255, 170, 127),
        ["TRACE"] = Color3.fromRGB(255, 0, 127),
        ["OPTIONS"] = Color3.fromRGB(100, 100, 100),
        ["PATCH"] = Color3.fromRGB(170, 170, 0),
        ["HEAD"] = Color3.fromRGB(85, 85, 127),
        ["Unknown"] = Color3.fromRGB(85, 0, 255),
    }

    local function surl(url)
        local s1 = url:split("://")
        local protocol = s1[1]
        local page = (s1[2] or "unknown"):split("/")[1]:split(".")
        local shortUrl = ""

        if #page > 1 then
            shortUrl = page[#page - 1] .. "." .. page[#page]
        else
            shortUrl = page[1] or "unknown"
        end

        return protocol, shortUrl
    end

    local order = ((2 ^ 31) - 1)
    local selection = shared:AddObject({ })
    local ignore = shared:AddObject({ })
    local logSpeed = shared:AddObject({ })
    local logs = shared:AddObject({ })
    local limit = 4

    local codeBox = shared.CodeBox(page.Contents.TextBox, shared.UseEnv)
    codeBox.Text = "Welcome to Ketamine - HTTP Spy!\n-- Waiting for HTTP requests --"

    local function addLog(realUrl, method, func, headers, body, result)
        realUrl = realUrl:gsub("\\", "/")

        local success, protocol, url = pcall(surl, realUrl)
        if not success then
            protocol = "unknown"
            url = realUrl
        end
        
        if ignore[url] or settings.Ignore_spammy_logs and (tonumber(logSpeed[url]) or 0) > limit then return end

        local log = shared:AddButton(logExample:Clone())
        log.Parent = page.Contents.Logs
        log.Visible = true

        table.insert(logs, 1, log)
        while #logs > math.max(settings.Maximum_log_amount * 5, 1) do
            local log = table.remove(logs, #logs)
            log:Destroy()
        end

        local shortUrl = url
        if #shortUrl > 13 then
            shortUrl = shortUrl:sub(1, 11) .. "..."
        end

        log.Contents.Label.Text = shortUrl
        log.LayoutOrder = order
        log.Contents.Frame.BackgroundColor3 = methodColors[method] or methodColors.Unknown
        log.Contents.Type.BackgroundColor3 = protocol == "http" and Color3.fromRGB(255, 85, 127) or protocol ~= "https" and Color3.fromRGB(85, 85, 255) or Color3.new()
        if protocol ~= "https" then
            log.Contents.Type.Visible = true
        end

        cons[#cons + 1] = log.MouseButton1Click:Connect(function()
            for _, log in logs do
                if log and log.Parent then
                    log.Contents.Selection.BackgroundTransparency = 1
                end
            end

            log.Contents.Selection.BackgroundTransparency = 0.9

            selection[1] = realUrl
            selection[2] = url
            selection[3] = protocol
            selection[4] = func
            selection[5] = method
            selection[6] = headers
            selection[7] = body
            selection[8] = result

            local s = url:split("/")

            codeBox.Text = "Method: " .. (method or "Unknown") .. "\nProtocol: " .. (protocol or "Unknown") .. "\nUrl: \"" .. s[1] .. "\"\n" .. (s[2] and "Path: \"" .. table.concat(s, "/", 2) .. "\"\n" or "") .. "Function: " .. func .. "\n\n-- Click buttons under to get more info --"
        end)

        order -= 1
    end

    local hooksAvailable = type(getfenv().hookmetamethod) == "function"
        and type(getfenv().hookfunction) == "function"
        and type(getfenv().getnamecallmethod) == "function"

    local http = game:GetService("HttpService")

    local genv = (getfenv().getgenv or getfenv)()
    if hooksAvailable then
        task.spawn(function()
            if genv.request then
                hooks.HookFunction(genv.request, function(old, options)
                    local result = shared:AddObject({ })
                    task.spawn(addLog, options.Url, options.Method or "GET", "request", options.Headers, options.Body, result)

                    result[1] = old(options)
                    return result[1]
                end)
            end

            local getnamecall = getfenv().getnamecallmethod

            hooks.HookMetaMethod("__namecall", function(old, self, ...)
                if typeof(self) ~= "Instance" then
                    return old(self, ...)
                end

                local method = getnamecall()
                method = method:sub(1, 1):upper() .. method:sub(2)

                if self == game and (method == "HttpGet" or method == "HttpGetAsync") then -- I've planned to add support for RequestInternal and requests from HttpService, but nah
                    local result = shared:AddObject({ })
                    task.spawn(addLog, select(1, ...), "GET", "game:HttpGet", select(3, ...), nil, result)

                    result[1] = old(self, ...)
                    return result[1]
                elseif self == game and (method == "HttpPost" or method == "HttpPostAsync") then
                    local result = shared:AddObject({ })
                    task.spawn(addLog, select(1, ...), "POST", "game:HttpPost", select(5, ...), select(2, ...), result)

                    result[1] = old(self, ...)
                    return result[1]
                end

                return old(self, ...)
            end)
        end)
    else
        local originalReq = genv.request
        if originalReq then
            genv.request = function(options)
                local result = shared:AddObject({ })
                task.spawn(addLog, options.Url, options.Method, "request", options.Headers, options.Body, result)

                result[1] = originalReq(options)
                return result[1]
            end

            shared.OnCloseEvent.Event:Connect(function()
                genv.request = originalReq
            end)
        end
    end

    local button = page.Contents.Buttons.Button
    button.Visible = false

    local function addButton(text, callback)
        local button = button:Clone()
        button.Parent = page.Contents.Buttons
        button.Visible = true
        button.Name = text

        if typeof(text) == "string" and text ~= "" then
            shared:AddButton(button)

            button.Separator:Destroy()
            button.Contents.Label.Text = text
            cons[#cons + 1] = button.MouseButton1Click:Connect(function()
                callback(button)
            end)
        else
            button.Contents:Destroy()
            button.Separator.Visible = true
        end

        return button
    end

    local clipboard = shared.Clipboard
    addButton("Copy text to clipboard", function()
        clipboard(codeBox.Text)
    end)

    addButton("Copy url to clipboard", function()
        if selection[1] then
            clipboard(selection[1])
        end
    end)

    addButton("Clear logs", function()
        for _, log in logs do
            log:Destroy()
        end

        table.clear(logs)
    end)

    addButton("Get request headers", function()
        if selection[6] then
            codeBox.Text = shared.ToString.ToString(selection[6])
        end
    end)
    addButton("Get request body", function()
        if selection[7] then
            codeBox.Text = shared.ToString.ToString(selection[7])
        end
    end)
    addButton("Get request result", function()
        if selection[8] and selection[8][1] then
            codeBox.Text = typeof(selection[8][1]) ~= "string" and shared.ToString.ToString(selection[8][1]) or selection[8][1]
        end
    end)
    addButton("Get body as lua table", function()
        if selection[7] then
            codeBox.Text = shared.ToString.ToString(http:JSONDecode(selection[7]))
        end
    end)

    addButton("Generate code", function()
        codeBox.Text = "local result = request({ -- " .. selection[4] .. "\n\t[\"Url\"] = \"" .. selection[1] .. "\",\n\t[\"Method\"] = \"" .. selection[5] .. "\",\n\t[\"Headers\"] = " .. shared.ToString.ToString(selection[6], 1) .. "\",\n\t[\"Body\"] = " .. shared.ToString.ToString(selection[7], 1) .. "\n})"
    end)
end
    end;

    modules[objects["Instance11"]] = function()
        local script = objects["Instance11"];
return function(shared, page)
    local cons = shared.Connections
    local hooks = shared.HookFunction -- custom safe hooks
    local settings = shared.Settings
    
    local codeBox = shared.CodeBox(page.Contents.To.TextBox, shared.UseEnv)
    codeBox.Text = "Welcome to Ketamine - Remote Spy!\n-- Waiting for Remotes --"

    local logExample = page.Contents.To.Logs.Log
    logExample.Parent = page
    logExample.Visible = false

    page.Contents.From.Logs.Log:Destroy()

    local hooksAvailable = type(getfenv().hookmetamethod) == "function"
        and type(getfenv().hookfunction) == "function"
        and type(getfenv().getnamecallmethod) == "function"
    
    if not hooksAvailable then
        codeBox.Text = "Welcome to CSpy - Remote Spy!\n-- Waiting for Remotes --\n\n--[[\n    Why Outcoming mode is unavailable?\n\n    -- -- -- -- --\n\n    Your executor is missing one or more of these functions:\n    hookmetamethod, hookfunction, getnamecallmethod\n]]--"
    end

    local ptype = hooksAvailable -- true
    local function update()
        page.Contents.From.Visible = not ptype
        page.Contents.To.Visible = ptype
        page.Buttons.From.BackgroundTransparency = ptype and 1 or 0.95
        page.Buttons.To.BackgroundTransparency = ptype and 0.95 or 1
        codeBox.Parent = page.Contents[ptype and "To" or "From"]
    end

    update()

    local logStack = shared:AddObject({ })
    local logs = shared:AddObject({
        From = shared:AddObject({ }),
        To = shared:AddObject({ })
    })

    local function append(list, ...)
        for i = 1, select("#", ...) do
            list[i] = select(i, ...) or false
        end
    end

    local stack = shared:AddObject({ })
    local function pop()
        table.clear(stack)

        for i = 1, 6 do
            table.insert(stack, logStack[1])
            table.remove(logStack, 1)
        end

        return unpack(stack)
    end

    local order = ((2 ^ 31) - 1)
    local selection = shared:AddObject({ })
    local ignore = shared:AddObject({ })
    local block = shared:AddObject({ })
    local hookArgs = shared:AddObject({ })
    local logSpeed = shared:AddObject({ })
    local limit = 4
    
    local function appendLog() -- never call that function inside the hooked function, because it will lack capabilities and cause an error
        if #logStack == 0 then return end

        local success, name, event, from, args, caller, got = pcall(pop)
        if not success or ignore[event.Name] or ignore[event] or settings.Ignore_spammy_logs and ((tonumber(logSpeed[event]) or 0) > limit or (tonumber(logSpeed[event.Name]) or 0) > limit) then return end
        local n = event.Name

        logSpeed[event] = (tonumber(logSpeed[event]) or 0) + 1
        logSpeed[n] = (tonumber(logSpeed[event]) or 0) + 1

        local log = shared:AddButton(logExample:Clone())
        local s = from and "From" or "To"

        table.insert(logs[s], 1, log)
        while #logs[s] > math.max(settings.Maximum_log_amount * 5, 1) do
            local log = table.remove(logs[s], #logs[s])
            log:Destroy()
        end
        
        local sArgs = "-- Failed to convert arguments to string (somehow)"
        local path = shared.ToString.ToString(event)
        
        if not settings.Create_arguments_as_variable then
            if not from then
                sArgs = "-- " .. event.ClassName .. "\n\n" .. (event:IsA("RemoteFunction") and "local result = " .. path .. ":InvokeServer" or path .. ":FireServer") .. shared.ToString.CreateArguments(args)
            else
                local createdArgs = shared.ToString.CreateArguments(args)
                sArgs = "-- " .. event.ClassName .. "\n\n" .. (event:IsA("RemoteFunction") and "getcallbackvalue(" .. path .. ", \"OnClientInvoke\")" .. shared.ToString.CreateArguments(args) or "firesignal(" .. path .. ".OnClientEvent, "  .. (createdArgs ~= "()" and createdArgs:sub(2) or "nil)"))
            end
        else
            if not from then
                sArgs = "-- " .. event.ClassName .. "\n\nlocal args = " .. shared.ToString.ToString(args, -1) .. "\n\n" .. (event:IsA("RemoteFunction") and "local result = " .. path .. ":InvokeServer" or path .. ":FireServer") .. "(unpack(args))"
            else
                sArgs = "-- " .. event.ClassName .. "\n\nlocal args = " .. shared.ToString.ToString(args, -1) .. "\n\n" .. (event:IsA("RemoteFunction") and "getcallbackvalue(" .. path .. ", \"OnClientInvoke\")(unpack(args))" or "firesignal(" .. path .. ".OnClientEvent, unpack(args))")
            end
        end
        
        local eArgs, changes = sArgs:gsub(shared.ToString.EscapePattern("game:GetService(\"HttpService\")"), "http")
        if changes >= 2 then
            local split = eArgs:split("\n")
            table.insert(split, 3, "local http = game:GetService(\"HttpService\")")
            
            sArgs = table.concat(split, "\n")
        end
        
        if settings.Create_event_as_variable then
            local split = sArgs:gsub(shared.ToString.EscapePattern(path), "object"):split("\n")
            table.insert(split, 3, "local object = " .. path)

            sArgs = table.concat(split, "\n")
        end

        log.Parent = page.Contents[s].Logs
        log.Visible = true
        log.LayoutOrder = order
        log.Contents.Frame.BackgroundColor3 = event:IsA("RemoteFunction") and Color3.fromRGB(170, 85, 255) or event:IsA("UnreliableRemoteEvent") and Color3.fromRGB(255, 85) or Color3.fromRGB(255, 170)
        log.Contents.Label.Text = name
        log.Contents.Label.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.new(0.8), (block[event] or block[event.Name]) and (not from or event:IsA("RemoteFunction")) and 0.2 or 0):Lerp(Color3.new(0, 0.8, 0.4), hookArgs[event] or hookArgs[event.Name] and 0.2 or 0)
        cons[#cons + 1] = log.MouseButton1Click:Connect(function()
            for _, log in logs[s] do
                if log and log.Parent then
                    log.Contents.Selection.BackgroundTransparency = 1
                end
            end
            
            log.Contents.Selection.BackgroundTransparency = 0.9
            
            selection[1] = event
            selection[2] = from
            selection[3] = args
            selection[4] = got
            selection[5] = caller

            print(selection[5])
            
            codeBox.Text = sArgs
        end)
        
        order -= 1

        if event:IsA("RemoteFunction") then
            while log.Parent and got and not got[1] do task.wait() end
            if got and got[1] then
                sArgs ..= "\n-- Got:\n--[[" .. shared.ToString.ToString(got[1]) .. "]]--" or ""
            end
        end
    end
    
    task.spawn(function()
        while task.wait(5) do
            for i in logSpeed do
                logSpeed[i] = 0
            end
        end
    end)

    cons[#cons + 1] = game:GetService("RunService").RenderStepped:Connect(function()
        while #logStack > 0 do
            task.spawn(appendLog)
        end
    end)

    local function addLogToStack(event, from, args, caller, got)
        local name = event.Name or tostring(event)
        if #name > 13 then
            name = name:sub(1, 11) .. "..."
        end

        append(logStack, name, event, from, args, caller or false, got or false)
    end
    
    local checkcaller = getfenv().checkcaller or function()
        return true
    end

    local caller
    local getcaller = getfenv().getcallingscript
    
    local function callcheck()
        local caller = checkcaller()
        if settings.Log_executor_function_calls == 1 and not caller or settings.Log_executor_function_calls == 2 or settings.Log_executor_function_calls == 3 and caller then
            return true
        end

        return false
    end
    
    task.spawn(function()
        local setUp = shared:AddObject({ })
        local getcb = getfenv().getcallbackvalue

        local function setup(instance: Instance)
            if not instance or setUp[instance] then return end
            setUp[instance] = true
            
            if instance:IsA("RemoteEvent") or instance:IsA("UnreliableRemoteEvent") then
                cons[#cons + 1] = instance.OnClientEvent:Connect(function(...)
                    if settings.Log_executor_function_calls <= 2 then
                        addLogToStack(instance, true, shared:AddObject({ ... }), nil, nil)
                    end
                end)
            elseif instance:IsA("RemoteFunction") and getcb then
                local success, value = pcall(getcb, instance, "OnClientInvoke")
                if success and typeof(value) == "function" then
                    hooks.HookFunction(value, function(old, ...)
                        if settings.Log_executor_function_calls <= 2 then
                            local got = shared:AddObject({ })
                            
                            addLogToStack(instance, true, shared:AddObject({ ... }), nil, got)
                            append(got, { old(...) })

                            return unpack(got[1])
                        else
                            return old(...)
                        end
                    end)
                end
            end
        end

        if getfenv().getinstances then
            for _, v in getfenv().getinstances() do
                task.spawn(setup, v)
            end
        end
        if getfenv().getnilinstances then
            for _, v in getfenv().getnilinstances() do
                task.spawn(setup, v)
            end
        end
        
        for _, v in game:GetDescendants() do
            task.spawn(setup, v)
        end
        cons[#cons + 1] = game.DescendantAdded:Connect(setup)
    end)

    if hooksAvailable then
        cons[#cons + 1] = page.Buttons.From.MouseButton1Click:Connect(function()
            ptype = false
            update()
        end)
        cons[#cons + 1] = page.Buttons.To.MouseButton1Click:Connect(function()
            ptype = true
            update()
        end)

        task.spawn(function()
            local fireServer = hooks.HookFunction(Instance.new("RemoteEvent").FireServer, function(old, self, ...)
                local cllr = caller
                caller = nil
                
                if typeof(self) ~= "Instance" or self.ClassName ~= "RemoteEvent" then
                    return old(self, ...)
                end
                
                local args = shared:AddObject({ ... })
                local newArgs = hookArgs[self] or hookArgs[self.Name]
                if newArgs then
                    local max = 0
                    for idx, val in newArgs do
                        args[idx] = val
                    end
                end

                if callcheck() then
                    addLogToStack(self, false, args, cllr or getcaller(), nil)
                end; if block[self] or block[self.Name] then return end

                return old(self, unpack(args))
            end)

            local fireServer2 = hooks.HookFunction(Instance.new("UnreliableRemoteEvent").FireServer, function(old, self, ...)
                local cllr = caller
                caller = nil

                if typeof(self) ~= "Instance" or self.ClassName ~= "UnreliableRemoteEvent" then
                    return old(self, ...)
                end
                
                local args = shared:AddObject({ ... })
                local newArgs = hookArgs[self] or hookArgs[self.Name]
                if newArgs then
                    local max = 0
                    for idx, val in newArgs do
                        args[idx] = val
                    end
                end

                if callcheck() then
                    addLogToStack(self, false, cllr or getcaller(), args, nil)
                end; if block[self] or block[self.Name] then return end

                return old(self, unpack(args))
            end)

            local invokeServer = hooks.HookFunction(Instance.new("RemoteFunction").InvokeServer, function(old, self, ...)
                local cllr = caller
                caller = nil

                if typeof(self) ~= "Instance" or self.ClassName ~= "RemoteFunction" then
                    return old(self, ...)
                end

                local args = shared:AddObject({ ... })
                local newArgs = hookArgs[self] or hookArgs[self.Name]
                if newArgs then
                    local max = 0
                    for idx, val in newArgs do
                        args[idx] = val
                    end
                end

                if not block[self] and not block[self.Name] then
                    local got = shared:AddObject({ })
                    if callcheck() then
                        addLogToStack(self, false, cllr or getcaller(), args, got)
                    end

                    append(got, { old(self, unpack(args)) })
                    
                    return unpack(got[1])
                else
                    if callcheck() then
                        addLogToStack(self, false, cllr or getcaller(), args, nil)
                    end
                end
            end)
            
            local getnamecall = getfenv().getnamecallmethod
            hooks.HookMetaMethod("__namecall", function(old, self, ...)
                if typeof(self) ~= "Instance" then
                    return old(self, ...)
                end
                
                local method = getnamecall()
                method = method:sub(1, 1):upper() .. method:sub(2)
                
                if getcaller then
                    caller = getcaller()
                end
                
                if method == "FireServer" and self.ClassName == "RemoteEvent" then
                    return fireServer(self, ...)
                elseif method == "FireServer" and self.ClassName == "UnreliableRemoteEvent" then
                    return fireServer2(self, ...)
                elseif method == "InvokeServer" and self.ClassName == "RemoteFunction" then
                    return invokeServer(self, ...)
                end
                
                return old(self, ...)
            end)
        end)
    else
        page.Buttons.To.Label.Text = "Outcoming [Unavailable]"
    end
    
    local button = page.Contents.Buttons.Button
    button.Visible = false
    
    local function addButton(text, callback)
        local button = button:Clone()
        button.Parent = page.Contents.Buttons
        button.Visible = true
        button.Name = text
        
        if typeof(text) == "string" and text ~= "" then
            shared:AddButton(button)

            button.Separator:Destroy()
            button.Contents.Label.Text = text
            cons[#cons + 1] = button.MouseButton1Click:Connect(function()
                callback(button)
            end)
        else
            button.Contents:Destroy()
            button.Separator.Visible = true
        end
        
        return button
    end
    
    local clipboard = shared.Clipboard
    addButton("Copy code to clipboard", function()
        clipboard(codeBox.Text)
    end)
    addButton("Copy path to clipboard", function()
        if selection[1] then
            clipboard(shared.ToString.ToString(selection[1]))
        end
    end)
    addButton("Copy args to clipboard", function()
        if selection[1] then
            clipboard(shared.ToString.ToString(selection[3]))
        end
    end)
    addButton("Copy result to clipboard", function()
        if selection[4] and selection[4][1] then
            clipboard(shared.ToString.ToString(selection[4][1]))
        end
    end)
    addButton("Copy caller to clipboard", function()
        if selection[5] then
            clipboard(shared.ToString.ToString(selection[5]))
        end
    end)
    addButton("Run code", function()
        if selection[1] then
            if not selection[2] then
                if selection[1]:IsA("RemoteFunction") then
                    selection[1]:InvokeServer(unpack(selection[3]))
                else
                    selection[1]:FireServer(unpack(selection[3]))
                end
            else
                if selection[1]:IsA("RemoteFunction") then
                    getfenv().getcallbackvalue(selection[1], "OnClientInvoke")(unpack(selection[3]))
                else
                    getfenv().firesignal(selection[1].OnClientEvent, unpack(selection[3]))
                end
            end
        end
    end)

    addButton("Block remote [Object]", function()
        if selection[1] then
            block[selection[1]] = true
        end
    end)
    addButton("Block remote [Name]", function()
        if selection[1] then
            block[selection[1].Name] = true
        end
    end)
    
    addButton("Clear logs", function()
        for _, log in logs.From do
            log:Destroy()
        end

        for _, log in logs.To do
            log:Destroy()
        end

        table.clear(logs.From)        
        table.clear(logs.To)
    end)

    addButton("Ignore remote [Object]", function()
        if selection[1] then
            ignore[selection[1]] = true
        end
    end)
    addButton("Ignore remote [Name]", function()
        if selection[1] then
            ignore[selection[1].Name] = true
        end
    end)

    addButton("Decompile", function()
        if selection[5] then
            codeBox.Text = "local script = " .. shared.ToString.ToString(selection[5]) .. "\n" .. getfenv().decompile(selection[5])
        end
    end)
    
    local hooking = shared:AddObject({ false })
    addButton("Hook args [Object]", function(button)
        if hooking[1] and hooking[1] ~= button.Name then return end

        if not hooking[1] and selection[1] then
            hooking[1] = button.Name
            hooking[2] = selection[1]
            hooking[3] = codeBox.Text

            button.Contents.Label.Text = "HOOK"
            codeBox.Text = "return " .. shared.ToString.ToString(selection[3], -1)
        elseif hooking[1] then
            button.Contents.Label.Text = button.Name

            local su, func = pcall(loadstring, codeBox.Text)
            if su then
                local s, hookedResult = pcall(func)
                if typeof(hookedResult) == "table" then
                    hookArgs[hooking[2]] = hookedResult
                else
                    hookArgs[hooking[2]] = nil
                end
            else
                hookArgs[hooking[2]] = nil
            end

            codeBox.Text = hooking[3]

            hooking[1] = false
            hooking[2] = nil
            hooking[3] = nil
        end
    end)
    
    addButton("Hook args [Name]", function(button)
        if hooking[1] and hooking[1] ~= button.Name then return end
        
        if not hooking[1] and selection[1] then
            hooking[1] = button.Name
            hooking[2] = selection[1]
            hooking[3] = codeBox.Text
            
            button.Contents.Label.Text = "HOOK"
            codeBox.Text = "return " .. shared.ToString.ToString(selection[3], -1)
        elseif hooking[1] then
            button.Contents.Label.Text = button.Name
            
            local su, func = pcall(loadstring, codeBox.Text)
            if su then
                local s, hookedResult = pcall(func)
                if typeof(hookedResult) == "table" then
                    hookArgs[hooking[2].Name] = hookedResult
                else
                    hookArgs[hooking[2].Name] = nil
                end
            else
                hookArgs[hooking[2].Name] = nil
            end
            
            codeBox.Text = hooking[3]

            hooking[1] = false
            hooking[2] = nil
            hooking[3] = nil
        end
    end)

    addButton("return nil = unhook", pcall)
end
    end;

    modules[objects["Instance7"]] = function()
        local script = objects["Instance7"];
return function(shared)
    local onClose = shared.OnCloseEvent.Event
    local hooks = shared:AddObject({ })

    onClose:Connect(function()
        for _, v in hooks do
            if v[1] == "F" then
                getfenv().hookfunction(v[2], v[3])
            else
                getfenv().hookmetamethod(game, v[2], v[3])
            end
        end
    end)

    local function isc(f)
        return (getfenv().iscclosure and getfenv().iscclosure(f) or not getfenv().iscclosure) and debug.info(f, "s") == "[C]" and (debug.getinfo and debug.getinfo(f).what == "C" and debug.getinfo(f).source:match("%[C%]") or not debug.getinfo)
    end

    local function newc(closure)
        return getfenv().newcclosure and getfenv().newcclosure(closure) or getfenv().clonefunction and getfenv().clonefunction(closure) or function(...) return closure(...) end
    end
    local function newl(closure)
        local cloned = getfenv().clonefunction and getfenv().clonefunction(function(...) return closure(...) end) or function(...) return closure(...) end
        return function(...) return cloned(...) end
    end

    local function safeClosure(original, hooked)
        if isc(original) then
            return newc(newl(hooked))
        else
            return newl(newc(hooked))
        end
    end
    
    local loggedMetaMethod = false
    return shared:AddObject({
        HookFunction = function(target, new)
            local old
            local function hooked(...)
                return new(old, ...)
            end

            old = getfenv().hookfunction(target, safeClosure(target, hooked))
            table.insert(hooks, shared:AddObject({ "F", target, old }))

            return target -- we don't need to slide the old function
        end,
        UnHookFunction = function(target)
            while true do
                local found = false
                for idx, hook in hooks do
                    if hook[1] == "F" and hook[2] == target then
                        found = idx
                        break
                    end
                end
                
                if found then
                    local found = table.remove(hooks, found)
                    getfenv().hookfunction(found[2], found[3])
                else
                    break
                end
            end
        end,
        HookMetaMethod = function(method, new)
            local old
            local function hooked(...)
                return new(old, ...)
            end
            
            old = getfenv().hookmetamethod(game, method, safeClosure(pcall, hooked)) -- used pcall as random C closure; pcall was not affected
            if not loggedMetaMethod then
                loggedMetaMethod = true
                table.insert(hooks, shared:AddObject({ "MM", method, old }))
            end
            
            -- we don't need to return function
        end
    })
end
    end;

    modules[objects["Instance15"]] = function()
        local script = objects["Instance15"];
return function(shared, page)
    local enumerate = --[[getfenv().getreg or]] getfenv().getgc
    if not enumerate or typeof(enumerate(true)) ~= "table" then
        page.Contents.Visible = false
        page.Unavailable.Visible = true
        page.Parent.Parent.Buttons.Holder.List[page.Name].Visible = false
        return
    end
    
    local enumName = enumerate == getfenv().getreg and "getreg" or "getgc"
    
    local cons = shared.Connections
    local settings = shared.Settings

    local codeBox = shared.CodeBox(page.Contents.View.Editor.TextBox, shared.UseEnv)
    codeBox.Text = ""

    local function cleanup(text)
        return (text:lower():gsub("[\0\n\t\r\f ]", ""))
    end

    local logg = page.Contents.View.ScanResults.List.Log
    logg.Visible = false
    
    local path, object
    local logs = { }
    
    local getResults, enumObj
    
    function enumObj(text, v, enumerated, res, depth)
        depth = depth or 0
        if depth > 5 then return end

        local vStr = tostring(v)
        if enumerated[vStr] then return end
        enumerated[vStr] = true

        local matches = 0

        local str = vStr
        local len = #str
        local searchLen = #text
        if searchLen > 0 then
            local pos = 1
            while pos <= len do
                local found = str:find(text, pos, true)
                if not found then break end
                
                matches = matches + 1
                pos = found + searchLen
            end
        end

        if typeof(v) == "table" then
            for k, val in pairs(v) do
                task.spawn(enumObj, text, k, enumerated, res, depth + 1)
                task.spawn(enumObj, text, val, enumerated, res, depth + 1)
            end
            
            --task.wait()
        elseif typeof(v) == "function" then
            local funcName = debug.info(v, "n") or ""
            
            local pos = 1
            while pos <= #funcName do
                local found = funcName:find(text, pos, true)
                if not found then break end
                matches = matches + 1
                pos = found + #text
            end
        end

        if matches > 0 then
            table.insert(res, { v, matches })
        end
    end

    function getResults(text, tbl, enumerated)
        local res = {}
        enumerated = enumerated or { }

        if typeof(tbl) == "table" then
            for _, v in ipairs(tbl) do
                pcall(enumObj, text, v, enumerated, res, 0)
            end
        else
            pcall(enumObj, text, tbl, enumerated, res, 0)
        end

        return res
    end

    
    local function updateView(obj)
        path = tostring(obj)
        object = obj
        
        if typeof(obj) == "function" then
            local name = debug.info(obj, "n") or ""
            if name == "" then
                name = "No name"
            end
            
            local s, source = pcall(getfenv, obj)
            if typeof(source) == "table" then
                source = source.script
            end
            
            if typeof(source) == "Instance" then
                source = shared.ToString.GetPath(source)
            else
                source = "No source"
            end
            
            local closureType = debug.info(obj, "s") == "[C]" and "C closure" or "Lua closure"
            codeBox.Text = "--[[\n\tObject: " .. path .. "\n\tType: function\n\tName: " .. name .. "\n\tClosure type: "
                .. closureType .. "\n\tSource: " .. source .. (debug.getconstants and "\n\tFunction constants: "
                .. shared.ToString.ToString(debug.getconstants(obj), 1) or "") .. "\n]]--"
        else
            codeBox.Text = "--[[\n\tObject: " .. path .. "\n\tType: " .. typeof(obj) .. "\n\tContents: " .. shared.ToString.ToString(obj) .. "\n]]--"
        end
    end
    
    local function scan(text)
        local res = getResults(text, enumerate(true), { })
        for _, v in res do
            table.insert(shared.CSpyObjects, v)
        end
        
        for _, v in res do
            local log = shared:AddButton(logg:Clone())
            log.Parent = logg.Parent
            log.Visible = true
            log.Matches.Text = v[2]
            log.Value.Text = tostring(v[1])
            logs[#logs + 1] = log
            cons[#cons + 1] = log.MouseButton1Click:Connect(function()
                updateView(v[1])
            end)
        end
    end

    local clipboard = shared.Clipboard

    cons[#cons + 1] = page.Contents.View.Editor.Back.MouseButton1Click:Connect(function()
        page.Contents.View.ScanResults.Visible = true
        page.Contents.View.Editor.Visible = false
    end)

    cons[#cons + 1] = page.Contents.View.Editor.CopyCode.MouseButton1Click:Connect(function()
        clipboard(codeBox.Text)
    end)

    cons[#cons + 1] = page.Contents.View.Editor.GenerateCode.MouseButton1Click:Connect(function()
        if typeof(object) == "table" then
            local placeholder = [[local got
for _, v in %s() do
    if typeof(v) == "table" then
        if typeof(v[%s]) == "%s" then
            got = v
            break
        end
    end
end]]

            for i, v in object do
                if typeof(i) == "string" then
                    local gen = placeholder:format(enumName, shared.ToString.ToString(i), typeof(v))
                    local s = loadstring(gen .. "\nreturn got")

                    if s() == object then
                        codeBox.Text = gen
                        return
                    end
                end
            end

            local placeholder = [[local got
for _, v in %s() do
    if typeof(v) == "table" then
        if table.find(v, %s) then
            got = v
            break
        end
    end
end]]

            for _, v in object do
                local t = typeof(v)

                if t == "string" or t == "number" or t == "Color3" or t == "Vector3" or t == "Vector2" or t == "Instance" or t == "function" then
                    local gen = placeholder:format(enumName, shared.ToString.ToString(v))
                    local s = loadstring(gen .. "\nreturn got")

                    if s() == object then
                        codeBox.Text = gen
                        return
                    end
                end
            end

            local placeholder = [[local got
for _, v in %s() do
    if typeof(v) == "table" then
        if v[%s] == %s then
            got = v
            break
        end
    end
end]]

            for i, v in object do
                local t = typeof(v)
                if t == "string" or t == "number" or t == "Color3" or t == "Vector3" or t == "Vector2" or t == "Instance" or t == "function" then
                    local gen = placeholder:format(enumName, shared.ToString.ToString(i), shared.ToString.ToString(v))
                    local s = loadstring(gen .. "\nreturn got")

                    if s() == object then
                        codeBox.Text = gen
                        return
                    end
                end
            end

            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Ketamine", Text = "Unable to generate table\nDo it yourself :trolling:" })
        end
    end)

    cons[#cons + 1] = page.Contents.View.Editor:FindFirstChild("Parent").MouseButton1Click:Connect(function()
        for _, v in enumerate(true) do
            if typeof(v) == "table" then
                for k, val in v do
                    if k == object or val == object then
                        updateView(v)
                        return
                    end
                end
            end
        end

        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Ketamine", Text = "Parent table not found" })
    end)

    cons[#cons + 1] = page.Contents.SearchBar.Field.TextBox.FocusLost:Connect(function()
        local text = cleanup(page.Contents.SearchBar.Field.TextBox.Text)

        for _, v in logs do
            v:Destroy()
        end

        table.clear(logs)

        if text ~= "" then
            scan(text)
        end
    end)
end
    end;
end;

-- Set scripts
do
    task.spawn(function() -- Instance2
if not game:GetService("RunService"):IsClient() then return end
local script = objects["Instance2"];
script:FindFirstAncestorOfClass("ScreenGui").Parent = getfenv().gethui and getfenv().gethui() or pcall(game.GetFullName, game:GetService("CoreGui")) and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 9e9)
script:FindFirstAncestorOfClass("ScreenGui").Enabled = true

pcall(function()
    script.Parent.Parent.OnTopOfCoreBlur = true
end)

local shared = require(script.Shared)
local settings = shared.Settings
local cons = shared.Connections

script.Parent.Main.TopbarZone.Title.Text ..= " | v" .. shared.Changelogs[#shared.Changelogs][1]

local tweens = { }
local tweenService = game:GetService("TweenService")
local switchPage

for i, v in script.Parent.Main.Contents.Buttons.Holder.List:GetChildren() do
    if v and v:IsA("TextButton") then
        tweens[v.Name] = {
            tweenService:Create(v, TweenInfo.new(0.35), {BackgroundTransparency = 0.95}),
            tweenService:Create(v, TweenInfo.new(0.35), {BackgroundTransparency = 1})
        }
        
        cons[#cons+1] = v.MouseButton1Click:Connect(function()
            switchPage(v.Name)
        end)
    end
end

local delta, dragInput
local function makeDraggable(gui)
    local dragging, dragStart, startPos, delta

    cons[#cons+1] = gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            cons[#cons+1] = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    cons[#cons+1] = gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    cons[#cons+1] = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            delta = input.Position - dragStart
            gui:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), nil, nil, 0.3, true)
            delta = nil
        end
    end)
end

local currentPage
function switchPage(name)
    currentPage = name
    script.Parent.Main.Contents.Pages.NotFound.Visible = not name or script.Parent.Main.Contents.Pages:FindFirstChild(name) == nil

    for i, v in tweens do
        v[i == name and 1 or 2]:Play()
        
        if script.Parent.Main.Contents.Pages:FindFirstChild(i) then
            script.Parent.Main.Contents.Pages[i].Visible = i == name
        end
    end
end

switchPage("Home")
makeDraggable(script.Parent)

for i, v in script.PageControls:GetChildren() do
    local page = script.Parent.Main.Contents.Pages:FindFirstChild(v.Name)
    if page then
        task.spawn(require(v), shared, page)
    end
end

local visible = true
local function show()
    visible = true
    
    shared.SidePanelEvent:Fire(true)
    
    script.Parent.Main.Contents.Buttons:TweenSize(UDim2.fromScale(0.2, 0.95), nil, nil, 0.5, true)
    script.Parent.Main.Contents.Buttons.Holder.List:TweenPosition(UDim2.fromScale(0, 0), nil, nil, 0.5, true)
    script.Parent.Main.Contents.Pages:TweenSizeAndPosition(UDim2.fromScale(0.8, 1), UDim2.fromScale(0.2, 0), nil, nil, 0.5, true)
    
    task.wait(0.3)
    
    if visible then
        for i, v in script.Parent.Main.Contents.Buttons.Holder.List:GetChildren() do
            if v then
                if v:IsA("TextButton") then
                    v.Cut.Label.Visible = true
                elseif v:IsA("Frame") then
                    v.Visible = true
                end
            end
        end
    end
end

local function hide()
    visible = false
    
    script.Parent.Main.Contents.Buttons:TweenSize(UDim2.fromScale(0.075, 0.95), nil, nil, 0.5, true)
    script.Parent.Main.Contents.Buttons.Holder.List:TweenPosition(UDim2.fromScale(0.325, 0), nil, nil, 0.5, true)
    script.Parent.Main.Contents.Pages:TweenSizeAndPosition(UDim2.fromScale(0.925, 1), UDim2.fromScale(0.075, 0), nil, nil, 0.5, true)
    
    shared.SidePanelEvent:Fire(false)
    
    for i, v in script.Parent.Main.Contents.Buttons.Holder.List:GetChildren() do
        if v then
            if v:IsA("TextButton") then
                v.Cut.Label.Visible = false
            elseif v:IsA("Frame") then
                v.Visible = false
            end
        end
    end
end

task.spawn(hide)

local hover = script.Parent.Main.Contents.Hover
local con
local hoverFunc, leaveFunc

leaveFunc = function()
    hover.Position = UDim2.fromScale(0, 0)
    hover.Size = UDim2.fromScale(0.075, 1)
    con:Disconnect()
    con = hover.MouseEnter:Connect(hoverFunc)
    cons[#cons+1] = con
    hide()
end

hoverFunc = function()
    hover.Position = UDim2.fromScale(0.2, 0)
    hover.Size = UDim2.fromScale(0.8, 1)
    con:Disconnect()
    con = hover.MouseEnter:Connect(leaveFunc)
    cons[#cons+1] = con
    show()
end

con = hover.MouseEnter:Connect(hoverFunc)
cons[#cons+1] = con

cons[#cons+1] = settings.Event:Connect(function(idx, val)
    if idx == "Always_show_side_panel" then
        if val == 2 then
            con:Disconnect()
            task.spawn(leaveFunc)
            hover.Visible = false
        elseif val == 3 then
            con:Disconnect()
            task.spawn(hoverFunc)
            hover.Visible = false
        else
            con:Disconnect()
            task.spawn(leaveFunc)
            hover.Visible = true
        end
    end
end)

local uis = game:GetService("UserInputService")

if uis.TouchEnabled and not uis.KeyboardEnabled then
    script.Parent.Size = UDim2.fromScale(0.65, 0.65)
    script.Parent.Main.TopbarZone.Buttons.Minimize.Visible = false
end

local oldRatio = script.Parent.UIAspectRatioConstraint.AspectRatio
local oldSize = script.Parent.Size

local isMinimized = true
local cooldown = false

local function minimize()
    if cooldown or isMinimized then return end
    
    isMinimized = true
    cooldown = true
    
    tweenService:Create(script.Parent.Main.Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    
    task.wait(0.5)

    script.Parent.Main.Contents.Visible = false
    script.Parent.Main.TopbarZone.Visible = false
    
    tweenService:Create(script.Parent.UIAspectRatioConstraint, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AspectRatio = 1}):Play()
    script.Parent:TweenSize(UDim2.fromScale(0.01, 0.01), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1, true)
    
    task.wait(1)
    
    script.Parent.Visible = false

    isMinimized = true
    cooldown = false
end

cons[#cons + 1] = settings.Event:Connect(function(setting, value)
    if setting == "Window_scale" then
        script.Parent:TweenSize(UDim2.fromScale(oldSize.X.Scale * (value / 100), oldSize.Y.Scale * (value / 100)), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
    end
end)

local function maximize()
    if cooldown or not isMinimized then return end

    isMinimized = false
    cooldown = true
    
    script.Parent.Visible = true
    script.Parent.Main.Overlay.Visible = false
    script.Parent.Main.Contents.Visible = false
    script.Parent.Main.TopbarZone.Visible = false

    script.Parent:TweenSize(UDim2.fromScale(oldSize.X.Scale * (settings.Window_scale / 100), oldSize.Y.Scale * (settings.Window_scale / 100)), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
    tweenService:Create(script.Parent.Main, TweenInfo.new(0.75), {BackgroundTransparency = 0}):Play()

    task.wait(1)

    tweenService:Create(script.Parent.UIAspectRatioConstraint, TweenInfo.new(1.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AspectRatio = oldRatio}):Play()

    task.wait(0.35)

    script.Parent.Main.Contents.Visible = true
    script.Parent.Main.TopbarZone.Visible = true
    script.Parent.Main.Overlay.Visible = true

    tweenService:Create(script.Parent.Main.Overlay, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()

    isMinimized = false
    cooldown = false

    for _, v in settings.Values do
        local i = v[1]
        local v = v[2]

        if i ~= "SEPARATOR" then
            settings[i] = v
        end
    end
end

local files = getfenv().writefile and getfenv().readfile and getfenv().makefolder
local http = game:GetService("HttpService")

cons[#cons+1] = script.Parent.Main.TopbarZone.Buttons.Minimize.MouseButton1Click:Connect(minimize)
cons[#cons+1] = script.Parent.Main.TopbarZone.Buttons.Close.MouseButton1Click:Connect(function()
    if files then
        local saveFile = { }
        for _, v in settings.Values do
            local i = v[1]
            local v = v[2]

            if i ~= "SEPARATOR" then
                saveFile[i] = v
            end
        end

        task.spawn(getfenv().writefile, "Ketamine/Settings.json", http:JSONEncode(saveFile))
    end
    
    shared.OnCloseEvent:Fire()
    shared.Global[shared._idx] = nil
    
    minimize()
    script.Parent:Destroy()
    for i, v in cons do
        if v and v.Connected then
            v:Disconnect()
        end
    end
end)

cons[#cons + 1] = game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == game:GetService("Players").LocalPlayer then
        if files then
            local saveFile = { }
            for _, v in settings.Values do
                local i = v[1]
                local v = v[2]

                if i ~= "SEPARATOR" then
                    saveFile[i] = v
                end
            end

            task.spawn(getfenv().writefile, "Ketamine/Settings.json", http:JSONEncode(saveFile))
        end
    end
end)

cons[#cons+1] = game:GetService("UserInputService").InputBegan:Connect(function(input, buzy)
    if buzy or input.KeyCode ~= Enum.KeyCode.LeftControl and input.KeyCode ~= Enum.KeyCode.RightControl then return end
    maximize()
end)

task.spawn(function()
    script.Parent.Shadow.ImageTransparency = 1
    script.Parent.UIAspectRatioConstraint.AspectRatio = 1
    script.Parent.Size = UDim2.fromScale(0.05, 0.05)
    script.Parent.Main.BackgroundTransparency = 1
    script.Parent.Main.Contents.Visible = false
    script.Parent.Main.Overlay.Visible = false
    script.Parent.Main.TopbarZone.Visible = false
    script.Parent.Visible = false

    repeat task.wait() until game:IsLoaded() and workspace.CurrentCamera and task.wait(1)

    script.Parent.Visible = true

    maximize()
end)
    end);
end;
