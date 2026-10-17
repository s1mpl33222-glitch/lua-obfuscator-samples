if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"6b6511a9e396ca32224b1ac3ec89aa18e5e17852ac3736475884b7a04ddfbd17","0f2f7c79004998f57d2d16fec826169f085e842df04ee070cf0bffb2919a5c99","fe1a6cb2ed15e5bba4d1c703f05c3c5c3dbd86091b60f95ef4ebda27afd1f1ca","4a7fd78f6c5fbb22d7150d01adc7851ee11591b41407e5cbb1ccf17c4cf825b6","eaacd295743c6012c90a109e057583b489379629d2f415013d93ee93d8968a4b","09cc44d687001f6e8ac94e7ee86283b5f3899ce0513453048bdbb02cfe9a0d71"},{[72858262610964]=1,[96510596525082]=2,[107535308163741]=3,[107778070777162]=4,[114234929420007]=5,[118805555015549]=6},{};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game [LDR-NOMAP]";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;local CONFIG = {
	Service = "Vyral",
	Identifier = "1197819",
	Provider = "Vyral",
	Title = "Vyral",
	Subtitle = "Enter your key to continue",
	Icon = "rbxassetid://129146761156837",
	DiscordLink = "https://discord.com/invite/RN9pxRE4f8",
	ShopLink = "https://vyralshop.mysellauth.com/",
	ShopText = "Buy",
	KeyFile = "Vyral/key.txt",
	MaxAttempts = 5,
}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end
local Junkie
do
	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	end)
	if not ok or type(result) ~= "table" then
		LocalPlayer:Kick("Vyral: couldn't reach the key server. Try again in a moment.")
		return
	end
	Junkie = result
	Junkie.service = CONFIG.Service
	Junkie.identifier = CONFIG.Identifier
	Junkie.provider = CONFIG.Provider
end
getgenv().SCRIPT_KEY = nil
local State = {
	Closed = false,
	Busy = false,
	Attempts = 0,
}
local function passed(result)
	if type(result) ~= "table" then
		return false
	end
	return result.valid == true or result.success == true
end
local MESSAGES = {
	KEY_INVALID = "That key isn't recognised",
	KEY_EXPIRED = "That key has expired \u{2014} grab a new one",
	KEY_INVALIDATED = "That key was disabled",
	ALREADY_USED = "That key has already been used",
	HWID_MISMATCH = "Key is locked to another device",
	HWID_BANNED = "This device is banned",
	SERVICE_NOT_FOUND = "Service not found \u{2014} contact support",
	SERVICE_MISMATCH = "That key is for a different script",
	PREMIUM_REQUIRED = "This build needs a premium key",
	ERROR = "Network error \u{2014} try again",
	RATE_LIMITED = "Too soon \u{2014} wait 5 minutes for a new link",
}
local function explain(code)
	if type(code) ~= "string" then
		return "Something went wrong"
	end
	if MESSAGES[code] then
		return MESSAGES[code]
	end
	if code:match("^http %d+") then
		return "Key server error (" .. code .. ")"
	end
	return code
end
local Store = {}
function Store.read()
	local value
	pcall(function()
		if isfile and isfile(CONFIG.KeyFile) then
			value = readfile(CONFIG.KeyFile)
		end
	end)
	if type(value) == "string" then
		value = value:gsub("^%s+", ""):gsub("%s+$", "")
		if #value > 0 then
			return value
		end
	end
	return nil
end
function Store.write(key)
	pcall(function()
		local folder = CONFIG.KeyFile:match("^(.*)/[^/]+$")
		if folder and makefolder and isfolder and not isfolder(folder) then
			makefolder(folder)
		end
		if writefile then
			writefile(CONFIG.KeyFile, key)
		end
	end)
end
function Store.clear()
	pcall(function()
		if delfile and isfile and isfile(CONFIG.KeyFile) then
			delfile(CONFIG.KeyFile)
		end
	end)
end
local Theme = {
    Card = Color3.fromRGB(16, 15, 21), Panel = Color3.fromRGB(23, 22, 30),
    Field = Color3.fromRGB(29, 28, 37), Line = Color3.fromRGB(41, 38, 51),
    Accent = Color3.fromRGB(245, 125, 170), AccentDim = Color3.fromRGB(61, 32, 47),
    Text = Color3.fromRGB(240, 237, 244), Muted = Color3.fromRGB(144, 138, 157),
    Good = Color3.fromRGB(94, 210, 156), Bad = Color3.fromRGB(241, 110, 130),
    OnAccent = Color3.fromRGB(32, 14, 24),
}
local Games = {
    {Name = "Steal An Egg", Place = 107778070777162, Universe=10563114921, Icon = "136278882107626"},
    {Name = "Tap Simulator: Reborn", Place = 72858262610964, Universe=10629695169, Icon = "78458771462965"},
    {Name = "Ball VS Ball", Place = 96510596525082, Universe=10685282333, Icon = "89332157297710"},
    {Name = "Huss Valley", Place = 107535308163741, Universe=10764627709, Icon = "85780504196503"},
    {Name = "+1 Loot To Forge", Place = 118805555015549, Universe=10684750879, Icon = "76133545612388"},
    {Name = "BloxStrike BETA", Place = 114234929420007, Universe=7633926880, Icon = "130048363039081"},
}
local CurrentGame = {Name = "Current game", Place = game.PlaceId}
for _, item in ipairs(Games) do if item.Place == game.PlaceId then CurrentGame = item end end
local Fonts={
    Medium=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Medium),
    SemiBold=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.SemiBold),
    Bold=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Bold),
}
local UI = {Connections = {}, Pages = {}, PageGroups = {}, Tabs = {}, Motion = true, Intro = true, AutoLoad = false, Remember = true, GameTiles = {}}
local DiscordAsset
pcall(function()
    local loader=getcustomasset or getsynasset
    if not loader or not writefile then return end
    local encoded="iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAMAAABrrFhUAAAAY1BMVEVYZfJib/OMlfahqPeWn/eBi/XLz/vq6/7////19f5tePTq7P22vPnV2Pyrsvirsvl3gvT09f7Axfp3gfRtePNsePPg4v22vPq2u/qCi/WhqPjf4/zf4v2Xn/essvjLzvuXnvdbidFTAAAETElEQVR4AezBgQAAAACAoP2pF6kCAAAAAAAAAAAAAAAAAAAAAIDZudMtV1UlDuCFRKlWIEJ6uOwbzXn/lzzzYc/GWiT6zya/79WrLeYSc5Vq9IFWa3Sr6JehWt0ZZn5RtFJvmHnodPsrPLx1/B9PKx1ziLOPnIRRO84EXaAP/CWnR3pArTWcybpA5G8NsX20pw+cSbpAngEeOQenY+Cf8KIZ4FuDfSV4Ko/7hS7wNjYH7W3MvNeHtn2jvxn+OXcgaP0x8KJo43vgnwqu85EXDfGVULWON9G1BOmDN/M/AnTgDSWC0xve0KAITeSsykFw4qzOQWB4YwNBOfLmPAHpeXsvr5XOgJkjGA3vIlU6A2bvOHvAnXwiCMrwTl5UpUtg5us7BAB2gcg78nXugaC6QORd+bo7AEAXiLwzX+8SANEFNHPdXcAwV90FDgxA037+zwAc7aZlCKnSNTDrADZBdU6DBwbha5wCAabBkWGkSqfAzFa6C8xeADYB9Y2ByEBsbSMAYAy0zHWPActQLPQuKBh3DiwiDRlwzwFOv9JfTpORh5x5rVfQc8CQiLLJiEMaA1oW6XgVq+grVh4yY56JA68x07fm8hCIhXCUPn823zgkG/HK4Rf6kYv8YBt5BQ03BQyv9CMq8M/JQ7IItw+e6cd8QQjKTqCX3OMTtOdCCNZOoCnqkrYgZEFD2/FF/08qDAE4Dji+TtHPKHknVmBboVB2i9HI9zIGahZUhaVqVxCyQEEVQ7rSBMj3QiPUUTCWJkC+8zrQVjzmELBYG2H5jDYUFqAiQDlMtAwKQgjr+nwoq9O2BSEQJQFVWKeNBSEQ6+BYeG3BFIUAHIfasmsLh7IQgLcjDZd0AWXEIZRDMDYCuuj73g95yJGxEuBLPmr6VBSyzMO9Fpzko3kqeA1r8W4GHOWNKQ/JIl4COL4SZf2lPAQhAY4lYrv860rlIVmHlYAsuBhjFwpCwO4LOkb0TMAzAc8EPBPwTMAGngl4JuCZgMig4jMB27AMykJUhCr4ekwzKI10T9hpwzcz6DNSUbRdORzThW/CJSKagd4LjKurof1suFCYVR54MDckpsBXDLk3pliQgxBTHneBrwiaNtOfeUUKCnMQYlKC32x2r7SlmSUpoOQdi5xtoqx1DNP8WW9kKSCVvAu8QnC2USR4/I2bP5vDmhS80pdOjXULw8dc7HSiL6ljYLTmz/ooKvJTdkqTt9G5s/mHczH6qXlV9I32Ehi0+QVfQbn7HryHhvY033V1Tuu3CRncOIj3rL3EV9pf7+53ced0bY+MIZm7ndEt9uNnkxN8OSWhAvjjZ8ktnIoKaMDHF0yH8S416C4Rpv7bU094pWJ9QFv4BJOBvnkFzjWKMvhu4G78IibMIz2EFM3KFUAwCEI+ID9MDia6kd/+enpFj+YE+af+aA8OZAAAAAAG+Vvf46sAAAAAAAAAAAAAAAAAAAAAAFYCeHSjWah9hFcAAAAASUVORK5CYII="
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local map={}for i=1,#alphabet do map[alphabet:sub(i,i)]=i-1 end
    local bytes={}
    for i=1,#encoded,4 do
        local a,b,c,d=encoded:sub(i,i),encoded:sub(i+1,i+1),encoded:sub(i+2,i+2),encoded:sub(i+3,i+3)
        local n=map[a]*262144+map[b]*4096+(map[c] or 0)*64+(map[d] or 0)
        bytes[#bytes+1]=string.char(math.floor(n/65536)%256)
        if c~="="then bytes[#bytes+1]=string.char(math.floor(n/256)%256)end
        if d~="="then bytes[#bytes+1]=string.char(n%256)end
    end
    local png=table.concat(bytes)
    for _,folder in ipairs({"Vyral","Vyral/assets"})do if makefolder and (not isfolder or not isfolder(folder))then pcall(makefolder,folder)end end
    local file="Vyral/assets/discord-official-v1.png"
    if not isfile or not isfile(file) or not readfile or readfile(file)~=png then writefile(file,png)end
    DiscordAsset=loader(file)
end)
local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("VyralKey")
if old then old:Destroy() end
local function connect(signal, fn)
    local c = signal:Connect(fn)
    UI.Connections[#UI.Connections + 1] = c
    return c
end
local function make(class, parent, props)
    local v = Instance.new(class)
    for key, value in pairs(props or {}) do v[key] = value end
    if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
        v.FontFace=(props.Font==Enum.Font.GothamBold or props.Font==Enum.Font.GothamMedium) and Fonts.SemiBold or Fonts.Medium
    end
    v.Parent = parent
    return v
end
local function corner(parent, radius)
    local c=parent:FindFirstChildOfClass("UICorner") or make("UICorner",parent,{})
    c.CornerRadius=UDim.new(0,radius or 12)
    return c
end
local function stroke(parent, color)
    return make("UIStroke", parent, {Color = color or Theme.Line, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function tween(object, duration, goal)
    if not object.Parent then return end
    if not UI.Motion then for k, v in pairs(goal) do object[k] = v end return end
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end
local function frame(parent, name, color)
    return make("Frame", parent, {Name = name, BorderSizePixel = 0, BackgroundColor3 = color or Theme.Panel})
end
local function label(parent, text, size, color, bold)
    return make("TextLabel", parent, {BackgroundTransparency = 1, Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        Text = text, TextSize = size or 13, TextColor3 = color or Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.new(1, 0, 0, 22)})
end
local function button(parent, text, accent,custom)
    local base=custom or (accent and Theme.Accent or Theme.Field)
    local b = make("TextButton", parent, {Name = text, BackgroundColor3 = base,
        BorderSizePixel = 0, AutoButtonColor = false, Text = text, Font = Enum.Font.GothamMedium,
        TextSize = 13, TextColor3 = accent and Theme.OnAccent or Theme.Text, Size = UDim2.fromOffset(120, 42)})
    corner(b, 10)
    connect(b.MouseEnter, function() if b:GetAttribute("Stateful")then return end tween(b, .12, {BackgroundColor3 = (accent or custom) and base:Lerp(Color3.new(1,1,1),.12) or Theme.Line}) end)
    connect(b.MouseLeave, function() if b:GetAttribute("Stateful")then return end tween(b, .12, {BackgroundColor3 = base}) end)
    return b
end
local function image(parent, asset, x, y, w, h)
    return make("ImageLabel", parent, {BackgroundTransparency = 1, Image = asset or "", ScaleType = Enum.ScaleType.Fit,
        Position = UDim2.fromOffset(x,y), Size = UDim2.fromOffset(w,h)})
end
local function icon(parent,kind,color,size)
    local holder=frame(parent,"Icon",color) holder.BackgroundTransparency=1 holder.Size=UDim2.fromOffset(size or 18,size or 18)
    if kind=="discord" and DiscordAsset then
        local logo=make("ImageLabel",holder,{Name="DiscordLogo",BackgroundTransparency=1,Image=DiscordAsset,Size=UDim2.fromScale(1,1),ScaleType=Enum.ScaleType.Fit})corner(logo,0).CornerRadius=UDim.new(1,0)
        return holder
    end
    if kind=="verified"then
        make("ImageLabel",holder,{Name="Verified",BackgroundTransparency=1,Image="rbxassetid://16898612629",ImageRectOffset=Vector2.new(967,147),ImageRectSize=Vector2.new(48,48),ImageColor3=color,Size=UDim2.fromScale(1,1)})
        return holder
    end
    local paths={
        bolt={{{.58,.04},{.12,.55},{.47,.55},{.40,.96},{.88,.40},{.55,.40},{.58,.04}}},
        key={{{.47,.50},{.12,.85},{.12,.96},{.24,.96},{.24,.84},{.36,.84},{.36,.72},{.58,.50}}},
        external={{{.55,.14},{.88,.14},{.88,.47}},{{.87,.15},{.45,.58}},{{.40,.22},{.14,.22},{.14,.86},{.78,.86},{.78,.62}}},
        users={{{.12,.90},{.12,.73},{.28,.64},{.48,.64},{.64,.73},{.64,.90}},{{.73,.66},{.90,.74},{.90,.90}}},
        reset={{{.12,.40},{.12,.14},{.38,.14}},{{.14,.25},{.40,.10},{.72,.20},{.90,.47},{.82,.77},{.57,.92},{.28,.85},{.12,.66}}},
        save={{{.15,.12},{.70,.12},{.88,.30},{.88,.88},{.15,.88},{.15,.12}},{{.32,.12},{.32,.40},{.67,.40},{.67,.12}},{{.32,.88},{.32,.61},{.70,.61},{.70,.88}}},
        film={{{.12,.30},{.88,.30},{.88,.88},{.12,.88},{.12,.30}},{{.12,.30},{.06,.12},{.82,.04},{.88,.23},{.12,.30}},{{.31,.10},{.39,.28}},{{.56,.07},{.64,.26}}},
        keyboard={{{.06,.20},{.94,.20},{.94,.80},{.06,.80},{.06,.20}},{{.25,.64},{.75,.64}}},
        discord={{{.25,.24},{.38,.20},{.41,.28},{.59,.28},{.62,.20},{.75,.24},{.87,.47},{.90,.73},{.72,.84},{.65,.73},{.35,.73},{.28,.84},{.10,.73},{.13,.47},{.25,.24}}},
        eye={{{.04,.50},{.23,.27},{.50,.17},{.77,.27},{.96,.50},{.77,.73},{.50,.83},{.23,.73},{.04,.50}}},
        lock={{{.28,.43},{.28,.24},{.38,.12},{.62,.12},{.72,.24},{.72,.43}},{{.18,.43},{.82,.43},{.82,.90},{.18,.90},{.18,.43}}},
        search={{{.65,.65},{.95,.95}}},
        flame={{{.55,.06},{.66,.36},{.81,.27},{.90,.53},{.82,.80},{.62,.94},{.36,.90},{.16,.73},{.13,.48},{.32,.25},{.32,.51},{.51,.35},{.55,.06}}},
        shield={{{.50,.06},{.88,.22},{.84,.62},{.68,.83},{.50,.95},{.32,.83},{.16,.62},{.12,.22},{.50,.06}},{{.31,.48},{.46,.63},{.70,.35}}},
        server={{{.16,.12},{.84,.12},{.90,.20},{.90,.38},{.84,.44},{.16,.44},{.10,.38},{.10,.20},{.16,.12}},{{.16,.56},{.84,.56},{.90,.64},{.90,.82},{.84,.88},{.16,.88},{.10,.82},{.10,.64},{.16,.56}}},
    }
    local function ring(x,y,w,h)
        local c=frame(holder,"Glyph",color) c.Position=UDim2.fromScale(x,y) c.Size=UDim2.fromScale(w,h) c.BackgroundTransparency=1 corner(c,99) stroke(c,color)
    end
    if kind=="key" then ring(.45,.06,.46,.46) end
    if kind=="eye" then ring(.36,.36,.28,.28) end
    if kind=="search" then ring(.06,.06,.65,.65) end
    if kind=="users" then ring(.23,.12,.30,.30) ring(.64,.18,.22,.22) end
    if kind=="discord" then
        for _,x in ipairs({.33,.61})do local e=frame(holder,"Glyph",color)e.Position=UDim2.fromScale(x,.46)e.Size=UDim2.fromScale(.10,.13)corner(e,99)end
    end
    for _,path in ipairs(paths[kind] or {})do for i=2,#path do
        local a,b=path[i-1],path[i] local dx,dy=b[1]-a[1],b[2]-a[2]
        local line=frame(holder,"Glyph",color)line.AnchorPoint=Vector2.new(.5,.5)
        line.Position=UDim2.fromScale((a[1]+b[1])/2,(a[2]+b[2])/2)
        line.Size=UDim2.new(math.sqrt(dx*dx+dy*dy),0,0,1.5)line.Rotation=math.deg(math.atan2(dy,dx))corner(line,2)
    end end
    return holder
end
local function decorateButton(b,kind,trailing)
    b.TextTransparency=1
    local group=frame(b,"Content") group.BackgroundTransparency=1 group.AnchorPoint=Vector2.new(.5,.5) group.Position=UDim2.fromScale(.5,.5)
    group.Size=UDim2.fromOffset(0,20)group.AutomaticSize=Enum.AutomaticSize.X
    make("UIListLayout",group,{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
    local glyph=icon(group,kind,b.TextColor3,16)glyph.LayoutOrder=1
    if kind=="discord"then glyph.Size=UDim2.fromOffset(20,20)end
    local text=label(group,b.Text,b.TextSize,b.TextColor3,true)text.Size=UDim2.fromOffset(0,20)text.AutomaticSize=Enum.AutomaticSize.X text.LayoutOrder=2
    local tail=trailing and icon(group,trailing,b.TextColor3,14) or nil if tail then tail.LayoutOrder=3 end
    local function update()
        text.Text=b.Text text.TextColor3=b.TextColor3
        for _,holder in ipairs(tail and {glyph,tail} or {glyph})do for _,v in ipairs(holder:GetDescendants())do if v:IsA("Frame")then v.BackgroundColor3=b.TextColor3 elseif v:IsA("UIStroke")then v.Color=b.TextColor3 end end end
    end
    connect(b:GetPropertyChangedSignal("Text"),update)connect(b:GetPropertyChangedSignal("TextColor3"),update)update()
end
local gui = make("ScreenGui", LocalPlayer.PlayerGui, {Name = "VyralKey", IgnoreGuiInset = true, ResetOnSpawn = false,
    DisplayOrder = 1001, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
local backdrop = frame(gui, "Backdrop", Color3.new(0,0,0))
backdrop.Size = UDim2.fromScale(1,1)
backdrop.BackgroundTransparency = 1
local card = frame(gui, "Loader", Theme.Card)
card.AnchorPoint = Vector2.new(.5,.5)
card.Position = UDim2.fromScale(.5,.5)
card.ClipsDescendants = true
corner(card, 16)
local cardStroke = stroke(card)
cardStroke.Thickness=1.5 cardStroke.Color=Color3.new(1,1,1)cardStroke.Transparency=.25
local borderRing=make("UIGradient",cardStroke,{
    Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,160,182)),ColorSequenceKeypoint.new(.5,Color3.fromRGB(168,120,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,160,182))}),
    Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.5,.55),NumberSequenceKeypoint.new(1,0)}),
})
local header = frame(card, "Header", Theme.Card)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1,0,0,72)
header.Active = true
image(header, CONFIG.Icon, 22,18,36,36)
local brand = label(header, "VYRAL", 18, Theme.Text, true)
brand.Position = UDim2.fromOffset(70,25)
brand.Size = UDim2.fromOffset(80,22)
local descriptor = label(header, "|   Loader", 12, Theme.Muted)
descriptor.Position = UDim2.fromOffset(152,26)
descriptor.Size = UDim2.fromOffset(110,20)
local close = button(header, "×")
close.BackgroundTransparency = 1
close.Size = UDim2.fromOffset(42,42)
close.AnchorPoint = Vector2.new(1,0)
close.Position = UDim2.new(1,-12,0,15)
close.TextSize = 24
local divider = frame(card, "HeaderRule", Theme.Line)
divider.Position = UDim2.fromOffset(0,72)
divider.Size = UDim2.new(1,0,0,1)
local nav = frame(card, "Navigation", Theme.Card)
nav.BackgroundTransparency = 1
nav.Position = UDim2.fromOffset(18,73)
nav.Size = UDim2.new(1,-36,0,48)
local navLayout = make("UIListLayout", nav, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,14), SortOrder = Enum.SortOrder.LayoutOrder})
for index, name in ipairs({"Home", "Supported games", "Settings"}) do
    local tab = button(nav, name == "Supported games" and "Supported games   "..#Games or name)
    tab.Name = name
    tab.BackgroundTransparency = 1
    tab.LayoutOrder = index
    tab.Size = UDim2.fromOffset(name == "Supported games" and 168 or 80,48)
    tab.TextColor3 = Theme.Muted tab.TextSize=14
    local underline = frame(tab, "Underline", Theme.Accent)
    underline.Position = UDim2.new(0,0,1,-2)
    underline.Size = UDim2.new(1,0,0,2)
    underline.Visible = false
    UI.Tabs[name] = tab
end
local navRule = frame(card, "NavigationRule", Theme.Line)
navRule.Position = UDim2.fromOffset(0,121)
navRule.Size = UDim2.new(1,0,0,1)
for _, name in ipairs({"Home", "Supported games", "Settings"}) do
    local group=make("CanvasGroup",card,{Name=name.."Transition",BackgroundTransparency=1,Position=UDim2.fromOffset(18,134),Size=UDim2.new(1,-36,1,-184),Visible=false,GroupTransparency=0})
    UI.PageGroups[name]=group
    local page = make("ScrollingFrame", group, {Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(0,0), Size = UDim2.fromScale(1,1), ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.fromOffset(0,0), ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false})
    UI.Pages[name] = page
end
local function selectPage(name)
    if UI.ActivePage==name then return end
    for key, page in pairs(UI.Pages) do
        page.Visible = key == name
        UI.PageGroups[key].Visible=key==name
        UI.Tabs[key].TextColor3 = key == name and Theme.Text or Theme.Muted
        UI.Tabs[key].Underline.Visible = key == name
    end
    UI.ActivePage = name
    local group=UI.PageGroups[name]
    group.GroupTransparency=UI.Motion and 1 or 0
    group.Position=UDim2.fromOffset(UI.PageInset or 18,(UI.PageTop or 134)+(UI.Motion and 10 or 0))
    tween(group,.20,{GroupTransparency=0,Position=UDim2.fromOffset(UI.PageInset or 18,UI.PageTop or 134)})
    local underline=UI.Tabs[name].Underline
    underline.Size=UI.Motion and UDim2.new(0,0,0,2) or UDim2.new(1,0,0,2)
    tween(underline,.20,{Size=UDim2.new(1,0,0,2)})
end
for name, tab in pairs(UI.Tabs) do connect(tab.Activated, function() selectPage(name) end) end
local home = UI.Pages.Home
local summary = frame(home, "CurrentGame") corner(summary) stroke(summary)
local thumb = image(summary, CurrentGame.Icon and ("rbxassetid://"..CurrentGame.Icon) or CONFIG.Icon,16,16,64,64) corner(thumb,12)
local gameName = label(summary, CurrentGame.Name,20,nil,true)gameName.FontFace=Fonts.Bold
gameName.Position = UDim2.fromOffset(96,20)
gameName.Size = UDim2.new(1,-112,0,26)
local badgeRow=frame(summary,"Badges")badgeRow.BackgroundTransparency=1 badgeRow.Position=UDim2.fromOffset(96,52)badgeRow.Size=UDim2.new(1,-112,0,22)
make("UIListLayout",badgeRow,{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
for i,data in ipairs({{"Game script","verified",Color3.fromRGB(72,205,141),Color3.fromRGB(23,53,42),100},{"jnkie.com","server",Color3.fromRGB(150,147,166),Color3.fromRGB(39,37,50),92}})do
    local pill=frame(badgeRow,data[1],data[4])pill.LayoutOrder=i pill.Size=UDim2.fromOffset(data[5],22)corner(pill,6)
    local glyph=icon(pill,data[2],data[3],13)glyph.Position=UDim2.fromOffset(7,4)
    local text=label(pill,data[1],11,data[3],true)text.Position=UDim2.fromOffset(26,0)text.Size=UDim2.new(1,-30,1,0)
end
local keyPanel = frame(home, "AccessKey") corner(keyPanel) stroke(keyPanel)
local keyTitle = label(keyPanel, "Access key",13,nil,true)
keyTitle.Position = UDim2.fromOffset(16,16)
keyTitle.Size = UDim2.new(1,-150,0,24)
local keyIcon=icon(keyPanel,"key",Theme.Accent,16) keyIcon.Position=UDim2.fromOffset(16,20)
keyTitle.Position=UDim2.fromOffset(40,16)
local keyState = label(keyPanel, "Enter key",11,Theme.Muted)
keyState.Position = UDim2.new(1,-132,0,18)
keyState.Size = UDim2.fromOffset(116,20)
keyState.TextXAlignment = Enum.TextXAlignment.Right
local hint = label(keyPanel, "Paste your key to load " .. CurrentGame.Name .. ".",12,Theme.Muted)
hint.Position = UDim2.fromOffset(16,46)
hint.Size = UDim2.new(1,-32,0,24)
local field = frame(keyPanel, "KeyField", Theme.Field)
field.Position = UDim2.fromOffset(16,68)
field.Size = UDim2.new(1,-32,0,48)
corner(field,9)
local fieldStroke = stroke(field)
local lockIcon=icon(field,"lock",Theme.Muted,16)lockIcon.Position=UDim2.new(0,12,.5,-8)
local input = make("TextBox", field, {Name = "KeyInput", BackgroundTransparency = 1, Position = UDim2.fromOffset(40,0),
    Size = UDim2.new(1,-148,1,0), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.Text,
    PlaceholderColor3 = Theme.Muted, PlaceholderText = "Paste your key", Text = "", ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true})
local paste = button(field,"")paste.Name="RevealKey"paste.BackgroundTransparency=1
paste.Position = UDim2.new(1,-36,0,7)
paste.Size = UDim2.fromOffset(30,34)
local revealIcon=icon(paste,"eye",Theme.Muted,16)revealIcon.Position=UDim2.new(.5,-8,.5,-8)
local charCount=label(field,"0 chars",10,Theme.Muted)charCount.Name="CharacterCount"charCount.Position=UDim2.new(1,-108,0,0)charCount.Size=UDim2.new(0,64,1,0)charCount.TextXAlignment=Enum.TextXAlignment.Right
local masked = label(field,"",14,Theme.Text)
masked.Position=UDim2.fromOffset(40,0) masked.Size=UDim2.new(1,-148,1,0)
local function maskKey()
    local text=input.Text
    masked.Text=#text>0 and (string.rep("•",math.min(math.max(#text-4,0),16))..text:sub(-4)) or ""
    masked.Visible=#text>0 and not input:IsFocused() and not UI.Reveal
    input.TextTransparency=masked.Visible and 1 or 0
    charCount.Text=tostring(#text).." chars"
end
local verify = button(keyPanel,"Load script",true)verify.TextSize=14
verify.Position = UDim2.fromOffset(16,128)
verify.Size = UDim2.new(.65,-20,0,44)
local getKey = button(keyPanel,"Get a key")
getKey.Position = UDim2.new(.65,4,0,128)
getKey.Size = UDim2.new(.35,-20,0,44)
decorateButton(verify,"bolt") decorateButton(getKey,"key")
local status = label(keyPanel,"Ready",12,Theme.Muted)
status.Position = UDim2.fromOffset(16,182)
status.Size = UDim2.new(1,-32,0,36)
status.TextWrapped = true
status.TextTruncate = Enum.TextTruncate.None
status.TextYAlignment = Enum.TextYAlignment.Top
local community = frame(home,"Community") corner(community) stroke(community)
local communityAvatar=frame(community,"ServerAvatar",Theme.Field)communityAvatar.Position=UDim2.fromOffset(16,16)communityAvatar.Size=UDim2.fromOffset(40,40)corner(communityAvatar,20)
image(community,CONFIG.Icon,20,20,32,32)
local communityTitle = label(community,"Vyral",14,nil,true)
communityTitle.Position = UDim2.fromOffset(66,16)
communityTitle.Size = UDim2.new(1,-82,0,22)
local inviteCode=CONFIG.DiscordLink:match("/invite/([%w%-]+)") or CONFIG.DiscordLink:match("discord%.gg/([%w%-]+)")
local communityInfo = label(community,inviteCode and ("discord.gg/"..inviteCode) or "Discord community",12,Theme.Muted)
communityInfo.Position = UDim2.fromOffset(66,38)
communityInfo.Size = UDim2.new(1,-82,0,20)
local discord = button(community,"Join the Discord",false,Color3.fromRGB(88,101,242))discord.TextColor3=Color3.new(1,1,1)
discord.Position = UDim2.fromOffset(16,94)
discord.Size = UDim2.new(1,-32,0,40)
decorateButton(discord,"discord","external")
local discordBadge=frame(community,"DiscordBadge",Color3.fromRGB(88,101,242))discordBadge.Position=UDim2.fromOffset(43,43)discordBadge.Size=UDim2.fromOffset(17,17)corner(discordBadge,0).CornerRadius=UDim.new(1,0)
discordBadge.ClipsDescendants=true
local badgeGlyph=icon(discordBadge,"discord",Color3.new(1,1,1),17)badgeGlyph.Position=UDim2.fromOffset(0,0)
local onlineDot=frame(community,"OnlineDot",Theme.Good)onlineDot.Position=UDim2.fromOffset(16,75)onlineDot.Size=UDim2.fromOffset(6,6)corner(onlineDot,3)
local onlineCount=label(community,"Online unavailable",12,Theme.Muted)onlineCount.Name="OnlineCount"onlineCount.Position=UDim2.fromOffset(29,67)onlineCount.Size=UDim2.new(.44,-12,0,22)
local membersIcon=icon(community,"users",Theme.Muted,14)membersIcon.Position=UDim2.new(.46,0,0,71)
local memberCount=label(community,"Members unavailable",12,Theme.Muted)memberCount.Name="MemberCount"memberCount.Position=UDim2.new(.46,22,0,67)memberCount.Size=UDim2.new(.54,-30,0,22)
local function countText(n)
    if type(n)~="number" or n<0 then return nil end
    local s=tostring(math.floor(n))while true do local changed;s,changed=s:gsub("^(%-?%d+)(%d%d%d)","%1,%2")if changed==0 then break end end return s
end
local function updateCommunity(data)
    if State.Closed or not gui.Parent or type(data)~="table" then return end
    local online=countText(data.approximate_presence_count)local members=countText(data.approximate_member_count)
    if online then onlineCount.Text=online.." online"end
    if members then memberCount.Text=members.." members"end
    if type(data.guild)=="table" and type(data.guild.name)=="string" then communityTitle.Text=data.guild.name end
end
local function fetchCommunity()
    local retryAfter
    local ok,data=pcall(function()
        local url="https://discord.com/api/v10/invites/"..inviteCode.."?with_counts=true"
        local req=request or http_request or (syn and syn.request)
        local body
        if req then
            local response=req({Url=url,Method="GET",Headers={Accept="application/json",["User-Agent"]="Mozilla/5.0"}})
            if response.StatusCode==429 then
                local parsedOk,details=pcall(function()return game:GetService("HttpService"):JSONDecode(response.Body)end)
                retryAfter=parsedOk and tonumber(details.retry_after) or nil
                return nil
            end
            if response.StatusCode~=200 then return nil end body=response.Body
        else body=game:HttpGet(url)end
        return game:GetService("HttpService"):JSONDecode(body)
    end)
    if ok and type(data)=="table"then updateCommunity(data) UI.CommunityFailures=0 return 60 end
    UI.CommunityFailures=math.min((UI.CommunityFailures or 0)+1,4)
    return math.max(60,tonumber(retryAfter) or math.min(300,60*2^UI.CommunityFailures))
end
task.spawn(function()
    if not inviteCode then return end
    UI.CommunityNext=0
    while not State.Closed and gui.Parent do
        if card.Visible and UI.ActivePage=="Home" and os.clock()>=UI.CommunityNext then
            local delay=fetchCommunity()
            UI.CommunityNext=os.clock()+delay
        end
        task.wait(1)
    end
end)
local session = frame(home,"Session") corner(session) stroke(session)
local sessionTitle = label(session,"Session",12,Theme.Text,true)
sessionTitle.Position = UDim2.fromOffset(16,12)
local avatar = image(session,"",16,44,36,36) corner(avatar,18)
local displayName = label(session,LocalPlayer.DisplayName,13,nil,true)
displayName.Position = UDim2.fromOffset(64,43)
displayName.Size = UDim2.new(1,-80,0,20)
local username = label(session,"@" .. LocalPlayer.Name,11,Theme.Muted)
username.Position = UDim2.fromOffset(64,65)
username.Size = UDim2.new(1,-80,0,20)
local executorName = "Unknown"
if identifyexecutor then local ok, n, v = pcall(identifyexecutor); if ok then executorName = tostring(n) .. (v and (" " .. tostring(v)) or "") end end
for i, row in ipairs({{"Executor",executorName},{"Place ID",tostring(game.PlaceId)},{"Provider","Jnkie"}}) do
    local key = label(session,row[1],11,Theme.Muted)
    key.Position = UDim2.fromOffset(16,92+(i-1)*30)
    key.Size = UDim2.new(.35,0,0,22)
    local value = label(session,row[2],11)
    value.Position = UDim2.new(.35,0,0,92+(i-1)*30)
    value.Size = UDim2.new(.65,-16,0,22)
    value.TextXAlignment = Enum.TextXAlignment.Right
end
local hotkeys = label(home,"ENTER  Load script     •     RIGHT SHIFT  Show / hide",11,Theme.Muted)
local library = UI.Pages["Supported games"]
local libraryTitle = label(library,"Game library",14,nil,true)libraryTitle.Size=UDim2.fromOffset(240,22)
local libraryHint = label(library,#Games.." games",12,Theme.Muted)
libraryHint.Position = UDim2.fromOffset(0,24)
libraryHint.Size = UDim2.fromOffset(300,22)
local search = make("TextBox",library,{Name="Search",Position=UDim2.new(1,-384,0,0),Size=UDim2.fromOffset(240,38),
    BackgroundColor3=Theme.Field,BorderSizePixel=0,Text="",PlaceholderText="Search games",ClearTextOnFocus=false,
    TextColor3=Theme.Text,PlaceholderColor3=Theme.Muted,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})
corner(search) make("UIPadding",search,{PaddingLeft=UDim.new(0,34),PaddingRight=UDim.new(0,10)})
local searchGlyph=icon(search,"search",Theme.Muted,14)searchGlyph.Position=UDim2.fromOffset(-22,12)
local filter=frame(library,"Sort",Theme.Field)filter.Position=UDim2.new(1,-132,0,0)filter.Size=UDim2.fromOffset(132,38)corner(filter,9)
local popular=button(filter,"Popular")popular.Name="Popular"popular.Position=UDim2.fromOffset(4,4)popular.Size=UDim2.fromOffset(80,30)popular.TextSize=11
decorateButton(popular,"flame")for _,v in ipairs(popular.Content.Icon:GetDescendants())do if v:IsA("Frame")then v.BackgroundColor3=Color3.fromRGB(224,169,77)elseif v:IsA("UIStroke")then v.Color=Color3.fromRGB(224,169,77)end end
local alphabetical=button(filter,"A–Z")alphabetical.Name="Alphabetical"alphabetical.Position=UDim2.fromOffset(86,4)alphabetical.Size=UDim2.fromOffset(42,30)alphabetical.TextSize=11
UI.LibrarySort="Popular"
local libraryMessage=libraryHint libraryMessage.Name="TeleportStatus"
local grid = frame(library,"Games") grid.BackgroundTransparency=1 grid.Position=UDim2.fromOffset(0,58)
local gridLayout = make("UIGridLayout",grid,{CellPadding=UDim2.fromOffset(12,12),SortOrder=Enum.SortOrder.LayoutOrder})
local TeleportService=game:GetService("TeleportService")
local transferFile="Vyral/loader-transfer.json"
local function clearQueuedLoader()
    local token=UI.QueuedLoaderToken
    UI.QueuedLoaderToken=nil
    if not token then return end
    pcall(function()
        local data=game:GetService("HttpService"):JSONDecode(readfile(transferFile))
        if data.token==token then writefile(transferFile,"{}")end
    end)
end
local function queueLoader(place)
    local queue=queue_on_teleport or queueonteleport or (type(syn)=="table" and syn.queue_on_teleport) or (type(fluxus)=="table" and fluxus.queue_on_teleport)
    if type(queue)~="function" or type(readfile)~="function" or type(writefile)~="function"then return false end
    local http=game:GetService("HttpService")
    local token=http:GenerateGUID(false)
    local expires=os.time()+300
    local stored=pcall(function()
        if makefolder and (not isfolder or not isfolder("Vyral"))then pcall(makefolder,"Vyral")end
        writefile(transferFile,http:JSONEncode({token=token,place=place,expires=expires}))
    end)
    if not stored then return false end
    UI.QueuedLoaderToken=token
    local queued=([=[
if not game:IsLoaded()then game.Loaded:Wait()end
if game.PlaceId~=%s or os.time()>%s then return end
local ok,data=pcall(function()return game:GetService("HttpService"):JSONDecode(readfile("Vyral/loader-transfer.json"))end)
if not ok or type(data)~="table" or data.token~=%q then return end
local consumed=pcall(function()writefile("Vyral/loader-transfer.json","{}")end)
if not consumed then return end
if getgenv().__VyralLoaderTransfer==%q then return end
getgenv().__VyralLoaderTransfer=%q
local loaded,err=pcall(function()
    local fn,why=loadstring(game:HttpGet("https://jnkie.com/loaders/vyral"))
    assert(fn,why)
    fn()
end)
if not loaded then warn("Vyral loader could not reopen: "..tostring(err))end
]=]):format(string.format("%.0f",place),tostring(expires),token,token,token)
    local ok=pcall(queue,queued)
    if not ok then clearQueuedLoader()end
    return ok
end
local function teleportFailed(message)
    clearQueuedLoader()
    UI.TeleportStarted=false
    UI.TeleportPending=nil
    UI.TeleportSequence=(UI.TeleportSequence or 0)+1
    if State.Closed or not gui.Parent then return end
    libraryMessage.Text=message libraryMessage.TextColor3=Theme.Bad
    for _,tile in ipairs(UI.GameTiles) do tile.Teleport.Text=tile.Game.Place==game.PlaceId and "Open" or "Teleport" end
end
local function teleportTo(item)
    if State.Closed or UI.TeleportPending or State.Busy then return end
    if item.Place==game.PlaceId then selectPage("Home") return end
    UI.TeleportPending=item.Place
    UI.TeleportStarted=false
    UI.TeleportSequence=(UI.TeleportSequence or 0)+1
    local sequence=UI.TeleportSequence
    local queued=queueLoader(item.Place)
    libraryMessage.Text="Joining "..item.Name..(queued and "…" or "… Reopen Vyral after joining.") libraryMessage.TextColor3=Theme.Accent
    for _,tile in ipairs(UI.GameTiles) do if tile.Game==item then tile.Teleport.Text="Joining…" end end
    task.spawn(function()
        if State.Closed or not gui.Parent then return end
        local ok=pcall(function() TeleportService:Teleport(item.Place,LocalPlayer) end)
        if not ok then teleportFailed("Could not join. Try again.") end
    end)
    task.delay(20,function()
        if State.Closed or not gui.Parent or UI.TeleportStarted or UI.TeleportSequence~=sequence or UI.TeleportPending~=item.Place then return end
        teleportFailed("Teleport did not start. Check your executor settings and try again.")
    end)
end
connect(LocalPlayer.OnTeleport,function(state,place)
    if UI.TeleportPending~=place then return end
    if state==Enum.TeleportState.Started or state==Enum.TeleportState.WaitingForServer or state==Enum.TeleportState.InProgress then UI.TeleportStarted=true end
end)
connect(TeleportService.TeleportInitFailed,function(player,result,message,placeId)
    if player==LocalPlayer and UI.TeleportPending and placeId==UI.TeleportPending then teleportFailed("Teleport failed. Try again.") end
end)
connect(game:GetService("LogService").MessageOut,function(message)
    if not UI.TeleportPending or State.Closed then return end
    local text=tostring(message):lower()
    if text:find("restricted place",1,true) and text:find("verify teleports",1,true)then
        teleportFailed("Delta blocked this. Rejoin, then disable Verify Teleports.")
    end
end)
for i, item in ipairs(Games) do
    local tile = button(grid,"")
    tile.Name = item.Name tile.LayoutOrder = item.Place == game.PlaceId and 0 or i
    tile.BackgroundColor3 = Theme.Panel
    local border = stroke(tile,item.Place==game.PlaceId and Theme.Accent or Theme.Line)
    local art = image(tile,"rbxassetid://"..item.Icon,8,8,143,143) art.Name="Artwork" art.Size=UDim2.new(1,-16,0,143)art.ScaleType=Enum.ScaleType.Crop corner(art,12)
    local current=label(tile,"✓  Current",11,Theme.OnAccent,true)current.Name="CurrentBadge"current.BackgroundTransparency=0 current.BackgroundColor3=Theme.Accent current.Position=UDim2.fromOffset(14,14)current.Size=UDim2.fromOffset(70,22)current.TextXAlignment=Enum.TextXAlignment.Center current.ZIndex=3 current.Visible=item.Place==game.PlaceId corner(current,6)
    local teleport=button(tile,item.Place==game.PlaceId and "Open" or "Teleport")
    teleport.Name="Teleport" teleport.AnchorPoint=Vector2.new(.5,0) teleport.Position=UDim2.new(.5,0,0,72)
    teleport.Size=UDim2.fromOffset(96,30) teleport.TextSize=11 teleport.ZIndex=2 teleport.Visible=UserInputService.TouchEnabled
    connect(tile.MouseEnter,function() teleport.Visible=true end)
    connect(tile.MouseLeave,function() teleport.Visible=UserInputService.TouchEnabled end)
    connect(teleport.Activated,function() teleportTo(item) end)
    local name = label(tile,item.Name,13,nil,true)name.Name="GameName"name.Position=UDim2.fromOffset(10,158)name.Size=UDim2.new(1,-20,0,20)
    local dot=frame(tile,"PlayingDot",Theme.Good)dot.Position=UDim2.fromOffset(11,190)dot.Size=UDim2.fromOffset(6,6)corner(dot,3)
    local playing=label(tile,"Players unavailable",11,Theme.Muted)playing.Name="Playing"playing.Position=UDim2.fromOffset(24,182)playing.Size=UDim2.new(1,-34,0,22)
    UI.GameTiles[#UI.GameTiles+1]={Frame=tile,Image=art,Game=item,Teleport=teleport,Playing=playing}
    connect(tile.Activated,function()
        teleportTo(item)
    end)
end
local function refreshLibrary()
    local ordered={}for _,t in ipairs(UI.GameTiles)do ordered[#ordered+1]=t end
    table.sort(ordered,function(a,b)
        if UI.LibrarySort=="Popular" then
            if (a.Game.Place==game.PlaceId)~=(b.Game.Place==game.PlaceId)then return a.Game.Place==game.PlaceId end
            local ac,bc=a.Game.Playing or -1,b.Game.Playing or -1
            if ac~=bc then return ac>bc end
        end
        return a.Game.Name:lower()<b.Game.Name:lower()
    end)
    local query=search.Text:lower()
    for i,t in ipairs(ordered)do t.Frame.LayoutOrder=i;t.Frame.Visible=t.Game.Name:lower():find(query,1,true)~=nil end
    popular.BackgroundColor3=UI.LibrarySort=="Popular" and Theme.Line or Theme.Field
    alphabetical.BackgroundColor3=UI.LibrarySort=="A–Z" and Theme.Line or Theme.Field
    popular.TextColor3=UI.LibrarySort=="Popular" and Theme.Text or Theme.Muted
    alphabetical.TextColor3=UI.LibrarySort=="A–Z" and Theme.Text or Theme.Muted
    if UI.Resize then UI.Resize()end
end
local function shortPlayers(n)
    local value,suffix=n,""
    if n>=1000000 then value=n/1000000 suffix="M"elseif n>=1000 then value=n/1000 suffix="k"end
    if suffix==""then return tostring(math.floor(n))end
    return (string.format("%.1f",value):gsub("%.0$",""))..suffix
end
connect(popular.Activated,function()UI.LibrarySort="Popular"refreshLibrary()end)
connect(alphabetical.Activated,function()UI.LibrarySort="A–Z"refreshLibrary()end)
task.spawn(function()
    local ids={}for _,g in ipairs(Games)do ids[#ids+1]=tostring(g.Universe)end
    local ok,data=pcall(function()
        local url="https://games.roblox.com/v1/games?universeIds="..table.concat(ids,",")
        local req=request or http_request or (syn and syn.request)local body
        if req then local r=req({Url=url,Method="GET"})if r.StatusCode~=200 then return nil end body=r.Body else body=game:HttpGet(url)end
        return game:GetService("HttpService"):JSONDecode(body)
    end)
    if not ok or type(data)~="table" or type(data.data)~="table" or not gui.Parent then return end
    local total=0 local found=0
    for _,row in ipairs(data.data)do for _,tile in ipairs(UI.GameTiles)do if row.id==tile.Game.Universe and type(row.playing)=="number" then
        tile.Game.Playing=math.max(0,math.floor(row.playing))total=total+tile.Game.Playing found=found+1
        tile.Playing.Text=shortPlayers(tile.Game.Playing).." playing"
    end end end
    if not UI.TeleportPending and found==#Games then libraryHint.Text=#Games.." games · "..shortPlayers(total).." playing now"end
    refreshLibrary()
end)
local settings = UI.Pages.Settings
local preferences=frame(settings,"Preferences")preferences.Size=UDim2.new(1,0,0,242)corner(preferences,12)stroke(preferences)
local preferencesTitle=label(preferences,"Preferences",13,nil,true)preferencesTitle.Position=UDim2.fromOffset(16,14)
local settingsHint=label(preferences,"Saved on this device and used every time the loader opens.",11,Theme.Muted)settingsHint.Position=UDim2.fromOffset(16,35)settingsHint.Size=UDim2.new(1,-32,0,32)settingsHint.TextWrapped=true
local resetPrefs=button(preferences,"Reset")resetPrefs.Name="Reset"resetPrefs.AnchorPoint=Vector2.new(1,0)resetPrefs.Position=UDim2.new(1,-12,0,8)resetPrefs.Size=UDim2.fromOffset(76,30)resetPrefs.BackgroundTransparency=1 resetPrefs.TextSize=11 decorateButton(resetPrefs,"reset")
local function setting(y,title,desc,kind)
    local row=frame(preferences,title)row.BackgroundTransparency=1 row.Position=UDim2.fromOffset(16,y)row.Size=UDim2.new(1,-32,0,55)
    local line=frame(row,"Rule",Theme.Line)line.Size=UDim2.new(1,0,0,1)line.BackgroundTransparency=.5
    local glyph=icon(row,kind,Theme.Muted,18)glyph.Position=UDim2.fromOffset(6,19)
    local t=label(row,title,13,nil,true)t.Position=UDim2.fromOffset(44,8)t.Size=UDim2.new(1,-108,0,20)
    local d=label(row,desc,12,Theme.Muted)d.Name="Description"d.Position=UDim2.fromOffset(44,27)d.Size=UDim2.new(1,-108,0,26)d.TextWrapped=true d.TextTruncate=Enum.TextTruncate.None
    local b=button(row,"")b.Name="Toggle"b.AnchorPoint=Vector2.new(1,.5)b.Position=UDim2.new(1,0,.5,0)b.Size=UDim2.fromOffset(56,44)b.BackgroundTransparency=1
    b:SetAttribute("Stateful",true)
    local track=frame(b,"Track",Theme.Field)track.AnchorPoint=Vector2.new(1,.5)track.Position=UDim2.fromScale(1,.5)track.Size=UDim2.fromOffset(38,22)corner(track,11)
    connect(b:GetPropertyChangedSignal("BackgroundColor3"),function()track.BackgroundColor3=b.BackgroundColor3 end)
    local knob=frame(track,"Knob",Theme.Text)knob.Position=UDim2.fromOffset(18,3)knob.Size=UDim2.fromOffset(16,16)corner(knob,8)
    return b
end
local introSwitch=setting(69,"Intro animation","Play the Vyral intro each time the loader opens.","film")
local remember=setting(124,"Remember key","Keep your key on this device so you only paste it once.","save")
local autoLoad=setting(179,"Auto-load","Start loading as soon as a saved key is found.","bolt")
local shortcuts=frame(settings,"Shortcuts")shortcuts.Position=UDim2.fromOffset(0,254)shortcuts.Size=UDim2.new(1,0,0,126)corner(shortcuts,12)stroke(shortcuts)
local shortcutsTitle=label(shortcuts,"Shortcuts",12,nil,true)shortcutsTitle.Position=UDim2.fromOffset(16,12)
for i,row in ipairs({{"Load the script","ENTER","bolt"},{"Show / hide the loader","RIGHT SHIFT","keyboard"}})do
    local glyph=icon(shortcuts,row[3],Theme.Muted,16)glyph.Position=UDim2.fromOffset(18,42+(i-1)*40)
    local text=label(shortcuts,row[1],11,Theme.Muted)text.Position=UDim2.fromOffset(44,38+(i-1)*40)text.Size=UDim2.new(1,-164,0,24)
    local chip=button(shortcuts,row[2])chip.AnchorPoint=Vector2.new(1,0)chip.Position=UDim2.new(1,-16,0,38+(i-1)*40)chip.Size=UDim2.fromOffset(i==1 and 56 or 92,24)chip.TextSize=9
end
settings.CanvasSize=UDim2.fromOffset(0,384)
local footer=frame(card,"Footer",Theme.Card)footer.BackgroundTransparency=1 footer.Size=UDim2.new(1,0,0,44) footer.Position=UDim2.new(0,0,1,-44)
local footerRule=frame(footer,"Rule",Theme.Line) footerRule.Size=UDim2.new(1,0,0,1)
local footerText=label(footer,"Vyral  /  Loader",11,Theme.Muted) footerText.Position=UDim2.fromOffset(18,12) footerText.Size=UDim2.new(.5,-18,0,20)
local shop=button(footer,"Vyral Shop  ↗") shop.AnchorPoint=Vector2.new(1,.5) shop.Position=UDim2.new(1,-16,.5,0) shop.Size=UDim2.fromOffset(124,30) shop.TextSize=11
local launch=frame(gui,"Launch",Theme.Card) launch.Size=UDim2.fromScale(1,1) launch.BackgroundTransparency=.08 launch.Visible=false launch.ZIndex=5
local launchMark=image(launch,CONFIG.Icon,-100,-60,64,64) launchMark.Position=UDim2.new(.5,-120,.5,-65) launchMark.ZIndex=6
local launchTitle=label(launch,"VYRAL",30,nil,true) launchTitle.Position=UDim2.new(.5,-40,.5,-48) launchTitle.Size=UDim2.fromOffset(170,40) launchTitle.ZIndex=6
local launchText=label(launch,"Key verified. Loading "..CurrentGame.Name..".",12,Theme.Muted) launchText.AnchorPoint=Vector2.new(.5,0) launchText.Position=UDim2.new(.5,0,.5,36) launchText.Size=UDim2.fromOffset(320,50) launchText.TextXAlignment=Enum.TextXAlignment.Center launchText.TextWrapped=true launchText.ZIndex=6
local launchLine=frame(launch,"Progress",Theme.Accent) launchLine.AnchorPoint=Vector2.new(.5,0) launchLine.Position=UDim2.new(.5,0,.5,18) launchLine.Size=UDim2.fromOffset(240,2) launchLine.ZIndex=6
local function setStatus(text,color)
    if State.Closed or not gui.Parent then return end
    status.Text=text or "" status.TextColor3=color or Theme.Muted
end
local function flash(color)
    tween(fieldStroke,.15,{Color=color})
    task.delay(1.4,function() if gui.Parent and not State.Closed then tween(fieldStroke,.3,{Color=Theme.Line}) end end)
end
local function copyLink(link)
    local setter=setclipboard or toclipboard
    if type(setter)~="function" then return false end
    return pcall(setter,link)
end
local function readPrefs()
    pcall(function()
        if isfile and isfile("Vyral/loader.json") then
            local prefs=game:GetService("HttpService"):JSONDecode(readfile("Vyral/loader.json"))
            UI.Remember=prefs.Remember~=false UI.Motion=prefs.Motion~=false UI.Intro=prefs.Intro~=false UI.AutoLoad=prefs.AutoLoad==true
        end
    end)
end
local function savePrefs()
    pcall(function()
        if makefolder and isfolder and not isfolder("Vyral") then makefolder("Vyral") end
        if writefile then writefile("Vyral/loader.json",game:GetService("HttpService"):JSONEncode({Remember=UI.Remember,Motion=UI.Motion,Intro=UI.Intro,AutoLoad=UI.AutoLoad})) end
    end)
end
local function prefLabels()
    for _,pair in ipairs({{remember,UI.Remember},{introSwitch,UI.Intro},{autoLoad,UI.AutoLoad}})do
        pair[1].BackgroundColor3=pair[2] and Theme.Accent or Theme.Field
        pair[1].Track.BackgroundColor3=pair[1].BackgroundColor3
        pair[1].Track.Knob.Position=UDim2.fromOffset(pair[2] and 19 or 3,3)
        pair[1].Track.Knob.BackgroundColor3=pair[2] and Theme.Text or Theme.Muted
    end
end
readPrefs() prefLabels()
if UI.Motion then
    UI.BorderTween=TweenService:Create(borderRing,TweenInfo.new(5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Rotation=360})UI.BorderTween:Play()
end
connect(remember.Activated,function()
    if State.Busy then return end
    UI.Remember=not UI.Remember if not UI.Remember then Store.clear() end savePrefs() prefLabels()
end)
connect(introSwitch.Activated,function() UI.Intro=not UI.Intro savePrefs() prefLabels() end)
connect(autoLoad.Activated,function() if State.Busy then return end UI.AutoLoad=not UI.AutoLoad savePrefs() prefLabels() end)
connect(resetPrefs.Activated,function()
    if State.Busy then return end
    UI.Intro=true UI.Remember=true UI.AutoLoad=false UI.Motion=true savePrefs()prefLabels()
end)
local function resize()
    local viewport=gui.AbsoluteSize
    if UI.LastViewport and UI.LastViewport~=viewport then card.Position=UDim2.fromScale(.5,.5)end
    UI.LastViewport=viewport
    local compact=viewport.X<700
    local landscapePhone=viewport.Y<520 and viewport.X<1000
    local mobile=compact or landscapePhone
    local width=math.min(compact and 420 or (landscapePhone and 720 or 880),math.max(260,viewport.X-(mobile and 24 or 32)))
    local height=math.min(mobile and 640 or 580,math.max(220,viewport.Y-(mobile and 24 or 32)))
    card.Size=UDim2.fromOffset(width,height)
    local inset=mobile and 12 or 18
    local body=width-inset*2
    local headerHeight=mobile and 56 or 72
    local navHeight=mobile and 44 or 48
    local footerHeight=mobile and 40 or 44
    UI.PageTop=headerHeight+navHeight+14 UI.PageInset=inset
    header.Size=UDim2.new(1,0,0,headerHeight)
    divider.Position=UDim2.fromOffset(0,headerHeight)
    nav.Position=UDim2.fromOffset(inset,headerHeight+1)nav.Size=UDim2.new(1,-inset*2,0,navHeight)
    navRule.Position=UDim2.fromOffset(0,headerHeight+navHeight+1)
    footer.Size=UDim2.new(1,0,0,footerHeight)footer.Position=UDim2.new(0,0,1,-footerHeight)
    for _,group in pairs(UI.PageGroups)do group.Position=UDim2.fromOffset(inset,UI.PageTop)group.Size=UDim2.new(1,-inset*2,1,-UI.PageTop-footerHeight-10)end
    close.Position=UDim2.new(1,-12,0,mobile and 7 or 15)
    brand.Position=UDim2.fromOffset(70,mobile and 17 or 25)
    descriptor.Position=UDim2.fromOffset(152,mobile and 18 or 26)
    header.ImageLabel.Position=UDim2.fromOffset(22,mobile and 10 or 18)
    navLayout.Padding=UDim.new(0,compact and 8 or 14)
    if compact then
        UI.Tabs.Home.Size=UDim2.fromOffset(math.floor((body-16)*.25),navHeight)
        UI.Tabs["Supported games"].Size=UDim2.fromOffset(math.floor((body-16)*.40),navHeight)
        UI.Tabs.Settings.Size=UDim2.fromOffset(math.floor((body-16)*.35),navHeight)
        UI.Tabs["Supported games"].Text="Games   "..#Games
    else
        UI.Tabs.Home.Size=UDim2.fromOffset(80,navHeight)
        UI.Tabs["Supported games"].Size=UDim2.fromOffset(168,navHeight)
        UI.Tabs.Settings.Size=UDim2.fromOffset(80,navHeight)
        UI.Tabs["Supported games"].Text="Supported games   "..#Games
    end
    local left=compact and body or math.floor(body*.60)-6
    badgeRow["Game script"].Size=UDim2.fromOffset(body<300 and 92 or 100,22)
    badgeRow["jnkie.com"].Size=UDim2.fromOffset(body<300 and 74 or 92,22)
    for _,entry in ipairs({{"Intro animation","Play the intro when opening.","Play the Vyral intro each time the loader opens."},{"Remember key","Keep your key on this device.","Keep your key on this device so you only paste it once."},{"Auto-load","Load a saved key automatically.","Start loading as soon as a saved key is found."}})do
        preferences[entry[1]].Description.Text=compact and entry[2] or entry[3]
    end
    summary.Position=UDim2.fromOffset(0,0) summary.Size=UDim2.fromOffset(left,98)
    keyPanel.Position=UDim2.fromOffset(0,110) keyPanel.Size=UDim2.fromOffset(left,228)
    if compact then
        community.Position=UDim2.fromOffset(0,406) community.Size=UDim2.fromOffset(body,150)
        session.Position=UDim2.fromOffset(0,568) session.Size=UDim2.fromOffset(body,194)
        hotkeys.Position=UDim2.fromOffset(0,346) hotkeys.Size=UDim2.fromOffset(body,20)
        home.CanvasSize=UDim2.fromOffset(0,774)
    else
        local right=body-left-12
        community.Position=UDim2.fromOffset(left+12,0) community.Size=UDim2.fromOffset(right,150)
        session.Position=UDim2.fromOffset(left+12,162) session.Size=UDim2.fromOffset(right,206)
        hotkeys.Position=UDim2.fromOffset(0,346) hotkeys.Size=UDim2.fromOffset(body,18)
        home.CanvasSize=UDim2.fromOffset(0,392)
    end
    hotkeys.Text=UserInputService.TouchEnabled and "Tap Load script to continue." or "ENTER  Load script     •     RIGHT SHIFT  Show / hide"
    local cols=compact and 2 or 5
    local cellWidth=math.floor((body-(cols-1)*12)/cols)
    search.Position=compact and UDim2.fromOffset(0,60) or UDim2.new(1,-384,0,0)
    search.Size=compact and UDim2.new(1,-144,0,38) or UDim2.fromOffset(240,38)
    filter.Position=UDim2.new(1,-132,0,compact and 60 or 0)
    local top=compact and 112 or 58
    grid.Position=UDim2.fromOffset(0,top)
    local visible=0
    for _,tile in ipairs(UI.GameTiles)do
        if tile.Frame.Visible then visible=visible+1 end
        tile.Image.Size=UDim2.new(1,-16,0,cellWidth-16)
        tile.Frame.GameName.Position=UDim2.fromOffset(10,cellWidth-1)
        tile.Playing.Position=UDim2.fromOffset(24,cellWidth+23)
        tile.Frame.PlayingDot.Position=UDim2.fromOffset(11,cellWidth+31)
        tile.Teleport.Position=UDim2.new(.5,0,0,cellWidth-50)
    end
    gridLayout.CellSize=UDim2.fromOffset(cellWidth,cellWidth+48)
    local height=math.ceil(visible/cols)*(cellWidth+60)
    grid.Size=UDim2.fromOffset(body,height)
    library.CanvasSize=UDim2.fromOffset(0,top+height+12)
end
UI.Resize=resize
connect(gui:GetPropertyChangedSignal("AbsoluteSize"),resize)
resize() selectPage("Home")
connect(search:GetPropertyChangedSignal("Text"),function()
    refreshLibrary()
end)
refreshLibrary()
task.spawn(function()
    local ok,content=pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
    if ok and gui.Parent then avatar.Image=content end
end)
for _,tile in ipairs(UI.GameTiles) do
    task.spawn(function()
        local ok,info=pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(tile.Game.Place) end)
        if ok and gui.Parent and tonumber(info.IconImageAssetId) and tonumber(info.IconImageAssetId)>0 then
            tile.Image.Image="rbxassetid://"..string.format("%.0f",tonumber(info.IconImageAssetId))
            if tile.Game.Place==game.PlaceId then thumb.Image=tile.Image.Image end
        end
    end)
end
local function cleanup()
    if not UI.TeleportStarted then clearQueuedLoader()end
    if UI.BorderTween then UI.BorderTween:Cancel()end
    for _,c in ipairs(UI.Connections) do c:Disconnect() end
    UI.Connections={}
    if gui.Parent then gui:Destroy() end
end
local function dismiss()
    tween(backdrop,.2,{BackgroundTransparency=1})
    task.delay(.22,cleanup)
end
local function cancel()
    if State.Closed then return end
    State.Closed=true
    dismiss()
end
connect(close.Activated,cancel)
connect(gui.Destroying,function()
    if not State.Success then State.Closed=true end
    for _,c in ipairs(UI.Connections) do c:Disconnect() end UI.Connections={}
end)
local function setBusy(busy)
    State.Busy=busy input.TextEditable=not busy
    verify.Text=busy and "Checking key…" or "Load script"
    keyState.Text=busy and "Checking" or "Enter key"
    keyState.TextColor3=Theme.Muted
end
local function finish(key)
    if State.Closed or not gui.Parent then return end
    if UI.Remember and key~="KEYLESS" then Store.write(key) end
    keyState.Text="Verified" keyState.TextColor3=Theme.Good
    card.Visible=false launch.Visible=true
    if UI.Motion then
        launchLine.Size=UDim2.fromOffset(0,2)
        tween(launchLine,.3,{Size=UDim2.fromOffset(240,2)})
        task.wait(.35)
    end
    if State.Closed or not gui.Parent then return end
    State.Success=true
    cleanup()
    getgenv().SCRIPT_KEY=key
end
local function attempt(key,fromSaved)
    if State.Busy or State.Closed or UI.TeleportPending then return end
    key=(key or ""):gsub("^%s+",""):gsub("%s+$","")
    if #key==0 then setStatus("Enter a key first.",Theme.Bad) flash(Theme.Bad) return end
    setBusy(true) setStatus(fromSaved and "Checking saved key." or "Checking your key.")
    task.spawn(function()
        local ok,result=pcall(Junkie.check_key,key)
        if State.Closed or not gui.Parent then return end
        if not ok then setBusy(false) setStatus(MESSAGES.ERROR,Theme.Bad) flash(Theme.Bad) return end
        if passed(result) then finish(key) return end
        local code=type(result)=="table" and (result.error or result.message) or "ERROR"
        if code=="HWID_BANNED" then Store.clear() State.Closed=true cleanup() LocalPlayer:Kick("Vyral: "..MESSAGES.HWID_BANNED) return end
        if code=="ERROR" or code=="RATE_LIMITED" or tostring(code):match("^http %d+") then
            setBusy(false) setStatus(explain(code),Theme.Bad) return
        end
        if fromSaved then Store.clear() end
        State.Attempts=State.Attempts+1 setBusy(false) flash(Theme.Bad)
        if State.Attempts>=CONFIG.MaxAttempts then
            State.Closed=true input.TextEditable=false verify.Text="Locked"
            status.Text="Too many attempts. Reopen the loader to retry." status.TextColor3=Theme.Bad
            task.delay(2,dismiss) return
        end
        setStatus(string.format("%s (%d/%d)",explain(code),State.Attempts,CONFIG.MaxAttempts),Theme.Bad)
    end)
end
connect(verify.Activated,function() attempt(input.Text,false) end)
connect(input.FocusLost,function(enter) maskKey() tween(fieldStroke,.2,{Color=Theme.Line}) if enter then attempt(input.Text,false) end end)
connect(input.Focused,function() masked.Visible=false input.TextTransparency=0 tween(fieldStroke,.15,{Color=Theme.Accent}) end)
connect(input:GetPropertyChangedSignal("Text"),function() maskKey() if not State.Busy then keyState.Text=#input.Text>0 and "Ready to check" or "Enter key" end end)
connect(paste.Activated,function()
    if State.Busy or State.Closed then return end
    UI.Reveal=not UI.Reveal maskKey()
end)
connect(discord.Activated,function() setStatus(copyLink(CONFIG.DiscordLink) and "Discord link copied. Open it in your browser." or CONFIG.DiscordLink) end)
connect(shop.Activated,function() selectPage("Home") setStatus(copyLink(CONFIG.ShopLink) and "Shop link copied. Open it in your browser." or CONFIG.ShopLink) end)
connect(getKey.Activated,function()
    if State.LinkBusy or State.Closed then return end
    State.LinkBusy=true getKey.Text="Getting link…" setStatus("Requesting a key link.")
    task.spawn(function()
        local ok,link,err=pcall(Junkie.get_key_link)
        if State.Closed or not gui.Parent then return end
        State.LinkBusy=false getKey.Text="Get a key"
        if not ok or type(link)~="string" or link=="" then setStatus(explain(err or "ERROR"),Theme.Bad) return end
        if copyLink(link) then setStatus("Key link copied. Open it in your browser.",Theme.Good) else setStatus(link) end
    end)
end)
connect(UserInputService.InputBegan,function(io,processed)
    if State.Closed or processed or UserInputService:GetFocusedTextBox() then return end
    if io.KeyCode==Enum.KeyCode.RightShift then
        card.Visible=not card.Visible backdrop.Visible=card.Visible
    elseif io.KeyCode==Enum.KeyCode.Return and card.Visible and UI.ActivePage=="Home" then attempt(input.Text,false) end
end)
do
    local dragging,startPos,startInput,dragTouch
    connect(header.InputBegan,function(io)
        if io.UserInputType==Enum.UserInputType.MouseButton1 or io.UserInputType==Enum.UserInputType.Touch then dragging=true startPos=card.Position startInput=io.Position dragTouch=io end
    end)
    connect(UserInputService.InputEnded,function(io)
        if io==dragTouch or io.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    connect(UserInputService.InputChanged,function(io)
        if not dragging or not card.Visible then return end
        if io.UserInputType~=Enum.UserInputType.MouseMovement and io~=dragTouch then return end
        local delta=io.Position-startInput
        local view=gui.AbsoluteSize local half=card.AbsoluteSize*.5
        local x=math.clamp(startPos.X.Scale*view.X+startPos.X.Offset+delta.X,half.X,math.max(half.X,view.X-half.X))
        local y=math.clamp(startPos.Y.Scale*view.Y+startPos.Y.Offset+delta.Y,half.Y,math.max(half.Y,view.Y-half.Y))
        card.Position=UDim2.fromOffset(x,y)
    end)
end
tween(backdrop,.25,{BackgroundTransparency=.40})
task.spawn(function()
    if UI.Intro and UI.Motion then
        card.Visible=false launch.Visible=true launchText.Text="Opening "..CurrentGame.Name.." loader."
        launchLine.Size=UDim2.fromOffset(0,2)tween(launchLine,.35,{Size=UDim2.fromOffset(240,2)})task.wait(.4)
        if State.Closed or not gui.Parent then return end
        launch.Visible=false card.Visible=true launchText.Text="Key verified. Loading "..CurrentGame.Name.."."
    end
    setBusy(true) setStatus("Connecting to the key server.")
    local ok,probe=pcall(Junkie.check_key,"KEYLESS")
    if State.Closed or not gui.Parent then return end
    if ok and passed(probe) and tostring(probe.message or "")=="KEYLESS" then finish("KEYLESS") return end
    setBusy(false)
    local saved=UI.Remember and Store.read() or nil
    if saved then input.Text=saved if UI.AutoLoad then attempt(saved,true)else setStatus("Saved key loaded. Press Enter or Load script.")end else setStatus("Enter your key or select Get a key.") end
end)
while not getgenv().SCRIPT_KEY and not State.Closed do task.wait(.1) end
if not getgenv().SCRIPT_KEY then return end
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end