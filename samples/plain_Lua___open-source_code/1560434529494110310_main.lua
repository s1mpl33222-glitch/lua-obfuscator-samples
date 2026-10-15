-- MAXLEGENDS SCRIPTS MASTER LOADER
-- One public loader for every supported game.
-- Actual game scripts stay private in Cloudflare KV and are returned only after key validation.

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(math.random())

local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local TweenService=game:GetService("TweenService")
local StarterGui=game:GetService("StarterGui")
local GuiService=game:GetService("GuiService")

local LP=Players.LocalPlayer
local ENV=(getgenv and getgenv()) or _G

local BASE="https://keyforge-owner-gated.pages.dev"

-- This table is injected automatically by the backend from the owner dashboard.
local routes = {
  [105224102909354] = { Name = "SPG HUB ULTIMATE", Slug = "spg-hub" },
  [10765463584] = { Name = "SPG HUB ULTIMATE", Slug = "spg-hub" },
  [107778070777162] = { Name = "Legends Hub | Steal An Egg", Slug = "legends-hub" },
  [10563114921] = { Name = "Legends Hub | Steal An Egg", Slug = "legends-hub" },
  [114326934417838] = { Name = "Legends Hub | Steal an Egg", Slug = "awss" },
  [10765288803] = { Name = "Legends Hub | Steal an Egg", Slug = "awss" },
  [107535308163741] = { Name = "Huss Ultimate Hub", Slug = "huss-ultimate-hub" },
  [10764627709] = { Name = "Huss Ultimate Hub", Slug = "huss-ultimate-hub" },
  [94009908234110] = { Name = "Unlock All Items | Inf Health | AimBot | + More", Slug = "dogs-ultimate" },
  [10765582175] = { Name = "Unlock All Items | Inf Health | AimBot | + More", Slug = "dogs-ultimate" },
  [111543903102439] = { Name = "Inf Skill | Auto Complete", Slug = "stone-hub" },
  [10765298801] = { Name = "Inf Skill | Auto Complete", Slug = "stone-hub" },
  [95082159892680] = { Name = "Auto Complete | Auto Farm Speed | + More", Slug = "1-speed-hub" },
  [9584852943] = { Name = "Auto Complete | Auto Farm Speed | + More", Slug = "1-speed-hub" },
  [82081400078378] = { Name = "SA Hub", Slug = "sa-hub" },
  [10765686447] = { Name = "SA Hub", Slug = "sa-hub" },
  [99679692310083] = { Name = "SAE Ultimate Hub", Slug = "sae-ultimate-hub" },
  [10766056678] = { Name = "SAE Ultimate Hub", Slug = "sae-ultimate-hub" },
  [118805555015549] = { Name = "Loot Forge Ultimate Hub", Slug = "loot-forge-ultimate-hub" },
  [10684750879] = { Name = "Loot Forge Ultimate Hub", Slug = "loot-forge-ultimate-hub" },
  [96510596525082] = { Name = "Ball HUB", Slug = "ball-hub" },
  [10685282333] = { Name = "Ball HUB", Slug = "ball-hub" },
  [114574503491412] = { Name = "Zero Hub", Slug = "anime-hub" },
  [10512942223] = { Name = "Zero Hub", Slug = "anime-hub" },
  [102476635575386] = { Name = "Fire Ultimate", Slug = "fire-hub" },
  [10767634248] = { Name = "Fire Ultimate", Slug = "fire-hub" },
  [131234943387594] = { Name = "Rocket Hub", Slug = "rocket-hub" },
  [10766687030] = { Name = "Rocket Hub", Slug = "rocket-hub" },
  [16205713724] = { Name = "S2 Hub", Slug = "s2-hub" },
  [5595353122] = { Name = "S2 Hub", Slug = "s2-hub" },
  [1730877806] = { Name = "[≡ƒì¼HALLOWEEN PT 1] Grand Piece Online Hub", Slug = "halloween-pt-1-grand-piece-online-hub" },
  [648454481] = { Name = "[≡ƒì¼HALLOWEEN PT 1] Grand Piece Online Hub", Slug = "halloween-pt-1-grand-piece-online-hub" },
  [78515283254292] = { Name = "Animal Hospital (Anomaly) ≡ƒº¬ Hub", Slug = "animal-hospital-anomaly-hub" },
  [10148749921] = { Name = "Animal Hospital (Anomaly) ≡ƒº¬ Hub", Slug = "animal-hospital-anomaly-hub" },
  [98800969324557] = { Name = "[≡ƒÜé UPD] Storage Hunters: Open World Hub", Slug = "upd-storage-hunters-open-world-hub" },
  [10261267004] = { Name = "[≡ƒÜé UPD] Storage Hunters: Open World Hub", Slug = "upd-storage-hunters-open-world-hub" },
  [120656419209274] = { Name = "(≡ƒîÇ) Drill for Eggs Hub", Slug = "drill-for-eggs-hub" },
  [10766721625] = { Name = "(≡ƒîÇ) Drill for Eggs Hub", Slug = "drill-for-eggs-hub" },
  [13822889] = { Name = "≡ƒî│ Lumber Tycoon 2 Hub", Slug = "lumber-tycoon-2-hub" },
  [2471084] = { Name = "≡ƒî│ Lumber Tycoon 2 Hub", Slug = "lumber-tycoon-2-hub" },
  [16116270224] = { Name = "≡ƒÄâ Dandy's World [ALPHA] Hub", Slug = "dandy-s-world-alpha-hub" },
  [5569032992] = { Name = "≡ƒÄâ Dandy's World [ALPHA] Hub", Slug = "dandy-s-world-alpha-hub" },
  [126987974021910] = { Name = "Illegal Soccer Hub", Slug = "illegal-soccer-hub" },
  [10155360168] = { Name = "Illegal Soccer Hub", Slug = "illegal-soccer-hub" },
  [93539470484676] = { Name = "[Γ¥ô] Scam With Your Friends Hub", Slug = "scam-with-your-friends-hub" },
  [10766502612] = { Name = "[Γ¥ô] Scam With Your Friends Hub", Slug = "scam-with-your-friends-hub" },
  [93978595733734] = { Name = "[CURE] Violence District Hub", Slug = "cure-violence-district-hub" },
  [6739698191] = { Name = "[CURE] Violence District Hub", Slug = "cure-violence-district-hub" },
  [6872265039] = { Name = "BedWars [≡ƒÄúRERELEASE≡ƒ¬ñ] Hub", Slug = "bedwars-rerelease-hub" },
  [2619619496] = { Name = "BedWars [≡ƒÄúRERELEASE≡ƒ¬ñ] Hub", Slug = "bedwars-rerelease-hub" },
  [122446657157717] = { Name = "[≡ƒöÑNEW SNIPER] Sniper Arena Hub", Slug = "new-sniper-sniper-arena-hub" },
  [9534705677] = { Name = "[≡ƒöÑNEW SNIPER] Sniper Arena Hub", Slug = "new-sniper-sniper-arena-hub" },
  [124216119978534] = { Name = "[ΓÜí] Ride A Pet Hub", Slug = "ride-a-pet-hub" },
  [10035204815] = { Name = "[ΓÜí] Ride A Pet Hub", Slug = "ride-a-pet-hub" },
  [72169370437173] = { Name = "Tribes 3v3 Hub", Slug = "tribes-3v3-hub" },
  [10768498581] = { Name = "Tribes 3v3 Hub", Slug = "tribes-3v3-hub" },
  [103363457515322] = { Name = "Chop A Forest Hub", Slug = "chop-a-forest-hub" },
  [10767386157] = { Name = "Chop A Forest Hub", Slug = "chop-a-forest-hub" },
  [94891079210424] = { Name = "Sell Fries! [Anomaly] ≡ƒìƒ Hub", Slug = "sell-fries-anomaly-hub" },
  [10767380385] = { Name = "Sell Fries! [Anomaly] ≡ƒìƒ Hub", Slug = "sell-fries-anomaly-hub" }
}

local route = routes[game.PlaceId] or routes[game.GameId]
if not route then
    warn("[MaxLegends] Unsupported game. PlaceId:", game.PlaceId, "GameId:", game.GameId)
    return
end

local SLUG=tostring(route.Slug)
local ROUTE_NAME=tostring(route.Name or SLUG)
local GET_KEY_URL="https://bloxscripts.fun/get-key?script="..SLUG
local GET_KEY_QUICK_URL="https://bloxscripts.fun/permanent-access-a8f26d91c4e73b05/signin"
local DISCORD_INSTANT_URL=BASE.."/discord/instant?script="..SLUG
local DISCORD_INVITE_URL="https://discord.gg/pFmwdebSe3"
local KEY_FILE="KEYFORGE_"..SLUG:gsub("[^%w_%-]","_").."_key.txt"

local LoaderState=ENV.__KEYFORGE_MASTER_LOADER_STATE
if type(LoaderState)~="table" then
    LoaderState={loaded={}}
    ENV.__KEYFORGE_MASTER_LOADER_STATE=LoaderState
end
LoaderState.loaded=LoaderState.loaded or {}
if LoaderState.loaded[SLUG] then
    return
end

local function requestFn()
    local list={
        rawget(ENV,"request"),
        rawget(ENV,"http_request"),
        rawget(_G,"request"),
        rawget(_G,"http_request")
    }
    pcall(function() if syn and type(syn.request)=="function" then table.insert(list,syn.request) end end)
    pcall(function() if http and type(http.request)=="function" then table.insert(list,http.request) end end)
    pcall(function() if fluxus and type(fluxus.request)=="function" then table.insert(list,fluxus.request) end end)
    for _,fn in ipairs(list) do
        if type(fn)=="function" then return fn end
    end
end

local REQUEST=requestFn()

local function post(path,data)
    if not REQUEST then return nil,"request/http_request is not available" end
    local ok,res=pcall(REQUEST,{
        Url=BASE..path,
        Method="POST",
        Headers={["Content-Type"]="application/json",["Accept"]="application/json"},
        Body=HttpService:JSONEncode(data)
    })
    if not ok then return nil,tostring(res) end
    if type(res)~="table" then return nil,"Invalid HTTP response" end
    return {
        StatusCode=tonumber(res.StatusCode or res.Status or 0) or 0,
        Body=tostring(res.Body or res.body or "")
    }
end

local function decode(raw)
    local ok,data=pcall(function() return HttpService:JSONDecode(raw) end)
    return ok and data or nil
end

local function saveKey(key)
    if type(writefile)=="function" then pcall(writefile,KEY_FILE,tostring(key or "")) end
end

local function readKey()
    if type(readfile)~="function" then return nil end
    if type(isfile)=="function" then
        local ok,yes=pcall(isfile,KEY_FILE)
        if not ok or not yes then return nil end
    end
    local ok,v=pcall(readfile,KEY_FILE)
    if ok and type(v)=="string" then
        v=v:match("^%s*(.-)%s*$") or ""
        if v~="" then return v end
    end
end

local function openKeyPage(targetUrl)
    local target=tostring(targetUrl or GET_KEY_URL)
    local candidates={
        rawget(ENV,"openurl"),
        rawget(ENV,"open_url"),
        rawget(ENV,"openbrowser"),
        rawget(ENV,"browse")
    }
    for _,fn in ipairs(candidates) do
        if type(fn)=="function" and pcall(fn,target) then return true,"Opened key page" end
    end

    if pcall(function() GuiService:OpenBrowserWindow(target) end) then
        return true,"Opened key page"
    end

    local clip=rawget(ENV,"setclipboard") or rawget(_G,"setclipboard")
    if type(clip)=="function" and pcall(clip,target) then
        return false,"Key-page link copied to clipboard"
    end

    return false,"Open manually: "..target
end

local function copyQuickKeyLink()
    local candidates={}
    local function add(fn)
        if type(fn)=="function" then table.insert(candidates,fn) end
    end
    for _,scope in ipairs({ENV,_G}) do
        for _,name in ipairs({"setclipboard","toclipboard","set_clipboard"}) do
            add(rawget(scope,name))
        end
        local clipboardApi=rawget(scope,"clipboard")
        if type(clipboardApi)=="table" then add(clipboardApi.set) end
    end
    add(setclipboard)
    add(toclipboard)
    add(set_clipboard)
    for _,fn in ipairs(candidates) do
        local ok,result=pcall(fn,GET_KEY_QUICK_URL)
        if ok and result~=false then return true end
    end
    return false
end

local function resolveKey(key)
    local res,err=post("/api/resolve-key",{key=key})
    if not res then return false,err end
    local data=decode(res.Body)
    if res.StatusCode==200 and data and data.valid==true then
        return true,data
    end
    local code=data and data.error or ("HTTP "..tostring(res.StatusCode))
    local map={
        invalid_key="Invalid key.",
        expired="Key expired. Get a new one.",
        revoked="Key revoked.",
        missing_key="Enter a key first."
    }
    return false,map[code] or ("Key rejected: "..tostring(code))
end

local function loadProtected(key,slug)
    local res,err=post("/api/script/"..tostring(slug),{key=key})
    if not res then return false,err end
    if res.StatusCode~=200 then
        local data=decode(res.Body)
        return false,(data and data.error) or ("HTTP "..tostring(res.StatusCode))
    end
    local fn,compileErr=loadstring(res.Body)
    if not fn then return false,"Compile error: "..tostring(compileErr) end
    local ok,runErr=pcall(fn)
    if not ok then return false,"Script error: "..tostring(runErr) end
    return true
end

local GUI_STATE_KEY="__KEYFORGE_KEY_GUI_"..SLUG:gsub("[^%w_]","_")
local old=ENV[GUI_STATE_KEY]
if old and type(old.Destroy)=="function" then pcall(old.Destroy) end

local parent=LP:WaitForChild("PlayerGui")
if type(gethui)=="function" then
    local ok,v=pcall(gethui)
    if ok and v then parent=v end
end

local Gui=Instance.new("ScreenGui")
Gui.Name="MAXLEGENDS_KEY_SYSTEM_"..SLUG:gsub("[^%w_]","_")
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=false
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=parent

local shade=Instance.new("Frame")
shade.Size=UDim2.fromScale(1,1)
shade.BackgroundColor3=Color3.fromRGB(1,6,14)
shade.BackgroundTransparency=.34
shade.BorderSizePixel=0
shade.Parent=Gui

local shadeGradient=Instance.new("UIGradient",shade)
shadeGradient.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(1,7,17)),
    ColorSequenceKeypoint.new(.52,Color3.fromRGB(3,14,29)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(1,5,12))
})
shadeGradient.Rotation=120

local card=Instance.new("Frame")
card.AnchorPoint=Vector2.new(.5,.5)
card.Position=UDim2.fromScale(.5,.5)
card.Size=UDim2.fromOffset(680,596)
card.BackgroundColor3=Color3.fromRGB(4,12,25)
card.BackgroundTransparency=.02
card.BorderSizePixel=0
card.ClipsDescendants=true
card.Parent=Gui
Instance.new("UICorner",card).CornerRadius=UDim.new(0,22)

local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
local targetScale=math.min(1,math.min((viewport.X-36)/700,(viewport.Y-36)/616))
local uiScale=Instance.new("UIScale")
uiScale.Scale=math.max(.7,targetScale*.94)
uiScale.Parent=card

local outerStroke=Instance.new("UIStroke",card)
outerStroke.Color=Color3.fromRGB(30,158,255)
outerStroke.Transparency=.18
outerStroke.Thickness=1.8

local cardGrad=Instance.new("UIGradient",card)
cardGrad.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(7,24,46)),
    ColorSequenceKeypoint.new(.36,Color3.fromRGB(4,14,29)),
    ColorSequenceKeypoint.new(.72,Color3.fromRGB(4,12,25)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(2,9,20))
})
cardGrad.Rotation=122

local headerGlow=Instance.new("Frame")
headerGlow.Size=UDim2.new(1,-32,0,4)
headerGlow.Position=UDim2.fromOffset(16,0)
headerGlow.BackgroundColor3=Color3.fromRGB(38,205,255)
headerGlow.BorderSizePixel=0
headerGlow.Parent=card
Instance.new("UICorner",headerGlow).CornerRadius=UDim.new(1,0)

local topGradient=Instance.new("UIGradient",headerGlow)
topGradient.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(37,100,255)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(77,232,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(47,117,255))
})

local sweep=Instance.new("Frame")
sweep.Size=UDim2.fromOffset(150,4)
sweep.Position=UDim2.fromOffset(-160,0)
sweep.BorderSizePixel=0
sweep.BackgroundColor3=Color3.fromRGB(200,249,255)
sweep.Parent=card
Instance.new("UICorner",sweep).CornerRadius=UDim.new(1,0)
local sweepGrad=Instance.new("UIGradient",sweep)
sweepGrad.Transparency=NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(.5,.05),
    NumberSequenceKeypoint.new(1,1)
})

local diagonalLight=Instance.new("Frame")
diagonalLight.Size=UDim2.fromOffset(260,3)
diagonalLight.Position=UDim2.new(-.35,0,.28,0)
diagonalLight.Rotation=-22
diagonalLight.BorderSizePixel=0
diagonalLight.BackgroundColor3=Color3.fromRGB(64,193,255)
diagonalLight.BackgroundTransparency=.28
diagonalLight.Parent=card
local diagonalGrad=Instance.new("UIGradient",diagonalLight)
diagonalGrad.Transparency=NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(.5,.18),
    NumberSequenceKeypoint.new(1,1)
})

local brand=Instance.new("Frame")
brand.Position=UDim2.fromOffset(24,22)
brand.Size=UDim2.fromOffset(145,30)
brand.BackgroundColor3=Color3.fromRGB(6,28,50)
brand.BorderSizePixel=0
brand.Parent=card
Instance.new("UICorner",brand).CornerRadius=UDim.new(1,0)
local brandStroke=Instance.new("UIStroke",brand)
brandStroke.Color=Color3.fromRGB(48,183,255)
brandStroke.Transparency=.18

local brandMark=Instance.new("TextLabel")
brandMark.BackgroundTransparency=1
brandMark.Position=UDim2.fromOffset(10,0)
brandMark.Size=UDim2.fromOffset(24,30)
brandMark.Font=Enum.Font.GothamBold
brandMark.TextSize=14
brandMark.TextColor3=Color3.fromRGB(91,224,255)
brandMark.Text="M"
brandMark.Parent=brand

local brandText=Instance.new("TextLabel")
brandText.BackgroundTransparency=1
brandText.Position=UDim2.fromOffset(37,0)
brandText.Size=UDim2.new(1,-45,1,0)
brandText.Font=Enum.Font.GothamBold
brandText.TextSize=10
brandText.TextXAlignment=Enum.TextXAlignment.Left
brandText.TextColor3=Color3.fromRGB(205,237,255)
brandText.Text="MAXLEGENDS"
brandText.Parent=brand

local title=Instance.new("TextLabel")
title.BackgroundTransparency=1
title.Position=UDim2.fromOffset(24,65)
title.Size=UDim2.new(1,-240,0,43)
title.Font=Enum.Font.GothamBold
title.TextSize=31
title.TextXAlignment=Enum.TextXAlignment.Left
title.TextColor3=Color3.fromRGB(247,251,255)
title.Text="MaxLegends Key System"
title.Parent=card

local sub=Instance.new("TextLabel")
sub.BackgroundTransparency=1
sub.Position=UDim2.fromOffset(25,108)
sub.Size=UDim2.new(1,-230,0,22)
sub.Font=Enum.Font.GothamMedium
sub.TextSize=12
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.TextColor3=Color3.fromRGB(119,158,199)
sub.Text="Protected access  |  7-hour key"
sub.Parent=card

local emblem=Instance.new("Frame")
emblem.Position=UDim2.new(1,-160,0,20)
emblem.Size=UDim2.fromOffset(130,110)
emblem.BackgroundTransparency=1
emblem.Parent=card

local emblemGlow=Instance.new("Frame")
emblemGlow.AnchorPoint=Vector2.new(.5,.5)
emblemGlow.Position=UDim2.fromScale(.5,.56)
emblemGlow.Size=UDim2.fromOffset(92,92)
emblemGlow.BackgroundColor3=Color3.fromRGB(27,107,255)
emblemGlow.BackgroundTransparency=.82
emblemGlow.BorderSizePixel=0
emblemGlow.Parent=emblem
Instance.new("UICorner",emblemGlow).CornerRadius=UDim.new(1,0)

local function crystal(x,y,w,h,rot,col)
    local f=Instance.new("Frame")
    f.AnchorPoint=Vector2.new(.5,.5)
    f.Position=UDim2.fromOffset(x,y)
    f.Size=UDim2.fromOffset(w,h)
    f.Rotation=rot
    f.BackgroundColor3=col
    f.BackgroundTransparency=.08
    f.BorderSizePixel=0
    f.Parent=emblem
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
    local st=Instance.new("UIStroke",f)
    st.Color=Color3.fromRGB(168,240,255)
    st.Transparency=.24
    return f
end
local c1=crystal(65,37,25,54,45,Color3.fromRGB(44,190,255))
local c2=crystal(35,58,21,43,45,Color3.fromRGB(40,121,255))
local c3=crystal(95,58,21,43,45,Color3.fromRGB(70,215,255))

local crownBase=Instance.new("Frame")
crownBase.Position=UDim2.fromOffset(27,83)
crownBase.Size=UDim2.fromOffset(76,8)
crownBase.BackgroundColor3=Color3.fromRGB(56,197,255)
crownBase.BorderSizePixel=0
crownBase.Parent=emblem
Instance.new("UICorner",crownBase).CornerRadius=UDim.new(1,0)

local accessPanel=Instance.new("Frame")
accessPanel.Position=UDim2.fromOffset(20,145)
accessPanel.Size=UDim2.new(1,-40,0,270)
accessPanel.BackgroundColor3=Color3.fromRGB(3,14,29)
accessPanel.BackgroundTransparency=.08
accessPanel.BorderSizePixel=0
accessPanel.Parent=card
Instance.new("UICorner",accessPanel).CornerRadius=UDim.new(0,17)
local accessStroke=Instance.new("UIStroke",accessPanel)
accessStroke.Color=Color3.fromRGB(23,96,166)
accessStroke.Transparency=.3

local sectionLabel=Instance.new("TextLabel")
sectionLabel.BackgroundTransparency=1
sectionLabel.Position=UDim2.fromOffset(24,13)
sectionLabel.Size=UDim2.new(1,-48,0,22)
sectionLabel.Font=Enum.Font.GothamBold
sectionLabel.TextSize=11
sectionLabel.TextXAlignment=Enum.TextXAlignment.Left
sectionLabel.TextColor3=Color3.fromRGB(97,220,255)
sectionLabel.Text="ACCESS KEY"
sectionLabel.Parent=accessPanel

local inputHolder=Instance.new("Frame")
inputHolder.Position=UDim2.fromOffset(24,43)
inputHolder.Size=UDim2.new(1,-48,0,58)
inputHolder.BackgroundColor3=Color3.fromRGB(5,22,41)
inputHolder.BorderSizePixel=0
inputHolder.Parent=accessPanel
Instance.new("UICorner",inputHolder).CornerRadius=UDim.new(0,12)
local ins=Instance.new("UIStroke",inputHolder)
ins.Color=Color3.fromRGB(45,180,255)
ins.Transparency=.18
ins.Thickness=1.2

local keyBadge=Instance.new("Frame")
keyBadge.AnchorPoint=Vector2.new(0,.5)
keyBadge.Position=UDim2.new(0,12,.5,0)
keyBadge.Size=UDim2.fromOffset(42,34)
keyBadge.BackgroundColor3=Color3.fromRGB(7,38,63)
keyBadge.BorderSizePixel=0
keyBadge.Parent=inputHolder
Instance.new("UICorner",keyBadge).CornerRadius=UDim.new(0,9)

local keyBadgeText=Instance.new("TextLabel")
keyBadgeText.BackgroundTransparency=1
keyBadgeText.Size=UDim2.fromScale(1,1)
keyBadgeText.Font=Enum.Font.GothamBold
keyBadgeText.TextSize=10
keyBadgeText.TextColor3=Color3.fromRGB(92,222,255)
keyBadgeText.Text="KEY"
keyBadgeText.Parent=keyBadge

local divider=Instance.new("Frame")
divider.Position=UDim2.fromOffset(66,12)
divider.Size=UDim2.fromOffset(1,34)
divider.BorderSizePixel=0
divider.BackgroundColor3=Color3.fromRGB(43,107,165)
divider.BackgroundTransparency=.2
divider.Parent=inputHolder

local input=Instance.new("TextBox")
input.BackgroundTransparency=1
input.Position=UDim2.fromOffset(82,0)
input.Size=UDim2.new(1,-96,1,0)
input.Font=Enum.Font.GothamMedium
input.TextSize=14
input.TextColor3=Color3.fromRGB(235,247,255)
input.PlaceholderText="ML-XXXX-XXXX-XXXX-XXXX"
input.PlaceholderColor3=Color3.fromRGB(83,118,154)
input.ClearTextOnFocus=false
input.TextXAlignment=Enum.TextXAlignment.Left
input.Parent=inputHolder

local statusHolder=Instance.new("Frame")
statusHolder.Position=UDim2.fromOffset(24,111)
statusHolder.Size=UDim2.new(1,-48,0,44)
statusHolder.BackgroundColor3=Color3.fromRGB(5,27,51)
statusHolder.BackgroundTransparency=.08
statusHolder.BorderSizePixel=0
statusHolder.Parent=accessPanel
Instance.new("UICorner",statusHolder).CornerRadius=UDim.new(0,11)
local statusStroke=Instance.new("UIStroke",statusHolder)
statusStroke.Color=Color3.fromRGB(26,92,168)
statusStroke.Transparency=.35

local statusIconCircle=Instance.new("Frame")
statusIconCircle.AnchorPoint=Vector2.new(0,.5)
statusIconCircle.Position=UDim2.new(0,12,.5,0)
statusIconCircle.Size=UDim2.fromOffset(28,28)
statusIconCircle.BackgroundColor3=Color3.fromRGB(8,56,86)
statusIconCircle.BorderSizePixel=0
statusIconCircle.Parent=statusHolder
Instance.new("UICorner",statusIconCircle).CornerRadius=UDim.new(1,0)
local statusIconStroke=Instance.new("UIStroke",statusIconCircle)
statusIconStroke.Color=Color3.fromRGB(68,213,255)
statusIconStroke.Transparency=.12

local statusIcon=Instance.new("TextLabel")
statusIcon.BackgroundTransparency=1
statusIcon.Size=UDim2.fromScale(1,1)
statusIcon.Font=Enum.Font.GothamBold
statusIcon.TextSize=15
statusIcon.TextColor3=Color3.fromRGB(123,235,255)
statusIcon.Text="OK"
statusIcon.Parent=statusIconCircle

local status=Instance.new("TextLabel")
status.BackgroundTransparency=1
status.Position=UDim2.fromOffset(51,0)
status.Size=UDim2.new(1,-62,1,0)
status.Font=Enum.Font.GothamMedium
status.TextSize=11
status.TextXAlignment=Enum.TextXAlignment.Left
status.TextColor3=Color3.fromRGB(184,211,237)
status.Text="Ready - enter your access key."
status.Parent=statusHolder

local function makeButton(text,pos,size,mode,parentObj)
    local host=parentObj or accessPanel
    local b=Instance.new("TextButton")
    b.AutoButtonColor=false
    b.Position=pos
    b.Size=size
    b.BorderSizePixel=0
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    b.Text=text
    b.Parent=host
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
    local st=Instance.new("UIStroke",b)
    st.Thickness=1.1
    if mode=="primary" then
        b.BackgroundColor3=Color3.fromRGB(69,207,252)
        b.TextColor3=Color3.fromRGB(2,24,43)
        st.Color=Color3.fromRGB(177,244,255)
        st.Transparency=.18
        local g=Instance.new("UIGradient",b)
        g.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(87,184,255)),
            ColorSequenceKeypoint.new(.52,Color3.fromRGB(79,229,255)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(64,172,255))
        })
    elseif mode=="discord" then
        b.BackgroundColor3=Color3.fromRGB(35,74,194)
        b.TextColor3=Color3.fromRGB(238,246,255)
        st.Color=Color3.fromRGB(96,142,255)
        st.Transparency=.15
        local g=Instance.new("UIGradient",b)
        g.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(57,84,221)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(35,157,235))
        })
    elseif mode=="accent" then
        b.BackgroundColor3=Color3.fromRGB(13,55,104)
        b.TextColor3=Color3.fromRGB(225,242,255)
        st.Color=Color3.fromRGB(52,147,232)
        st.Transparency=.22
    else
        b.BackgroundColor3=Color3.fromRGB(7,27,51)
        b.TextColor3=Color3.fromRGB(205,227,247)
        st.Color=Color3.fromRGB(34,78,125)
        st.Transparency=.28
    end
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(.12),{BackgroundTransparency=.08}):Play()
        TweenService:Create(st,TweenInfo.new(.12),{Transparency=.02}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(.12),{BackgroundTransparency=0}):Play()
        TweenService:Create(st,TweenInfo.new(.12),{Transparency=mode=="primary" and .18 or .22}):Play()
    end)
    return b
end

local check=makeButton("CHECK ACCESS KEY",UDim2.fromOffset(24,167),UDim2.new(1,-48,0,48),"primary")
local getKey=makeButton("GET KEY",UDim2.fromOffset(24,225),UDim2.new(.26,-12,0,42),"accent")
local premium=makeButton("PREMIUM",UDim2.new(.26,22,0,225),UDim2.new(.22,-12,0,42),"dark")
local quickKey=makeButton("Get Key Quick",UDim2.new(.48,20,0,225),UDim2.new(.52,-44,0,42),"primary")
quickKey.Name="GetKeyQuick"
quickKey.TextSize=12
quickKey.TextWrapped=true

local discordBanner=Instance.new("Frame")
discordBanner.Position=UDim2.fromOffset(20,426)
discordBanner.Size=UDim2.new(1,-40,0,72)
discordBanner.BackgroundColor3=Color3.fromRGB(6,20,44)
discordBanner.BackgroundTransparency=.02
discordBanner.BorderSizePixel=0
discordBanner.Parent=card
Instance.new("UICorner",discordBanner).CornerRadius=UDim.new(0,15)
local discordStroke=Instance.new("UIStroke",discordBanner)
discordStroke.Color=Color3.fromRGB(67,96,255)
discordStroke.Transparency=.18

local discordBadge=Instance.new("Frame")
discordBadge.AnchorPoint=Vector2.new(0,.5)
discordBadge.Position=UDim2.new(0,14,.5,0)
discordBadge.Size=UDim2.fromOffset(44,44)
discordBadge.BackgroundColor3=Color3.fromRGB(48,75,215)
discordBadge.BorderSizePixel=0
discordBadge.Parent=discordBanner
Instance.new("UICorner",discordBadge).CornerRadius=UDim.new(1,0)

local discordLogo=Instance.new("ImageLabel")
discordLogo.BackgroundTransparency=1
discordLogo.Position=UDim2.fromOffset(4,4)
discordLogo.Size=UDim2.new(1,-8,1,-8)
discordLogo.ScaleType=Enum.ScaleType.Fit
discordLogo.Image=""
discordLogo.ZIndex=2
discordLogo.Parent=discordBadge
Instance.new("UICorner",discordLogo).CornerRadius=UDim.new(1,0)

local discordFallback=Instance.new("TextLabel")
discordFallback.BackgroundTransparency=1
discordFallback.Size=UDim2.fromScale(1,1)
discordFallback.Font=Enum.Font.GothamBold
discordFallback.TextSize=12
discordFallback.TextColor3=Color3.fromRGB(244,247,255)
discordFallback.Text="LH"
discordFallback.ZIndex=1
discordFallback.Parent=discordBadge

task.spawn(function()
    if not REQUEST or type(writefile)~="function" then return end
    local ok,res=pcall(REQUEST,{Url=BASE.."/assets/legends-hub.jpg",Method="GET"})
    if not ok or type(res)~="table" or tonumber(res.StatusCode or res.Status or 0)~=200 then return end
    local body=res.Body or res.body
    if type(body)~="string" or body=="" then return end
    local logoFile="legends_hub_icon.jpg"
    if not pcall(writefile,logoFile,body) then return end
    local assetFn=rawget(ENV,"getcustomasset") or rawget(_G,"getcustomasset") or rawget(ENV,"getsynasset") or rawget(_G,"getsynasset")
    if type(assetFn)~="function" then return end
    local okAsset,asset=pcall(assetFn,logoFile)
    if okAsset and asset then
        discordLogo.Image=tostring(asset)
        discordFallback.Visible=false
    end
end)

local discordTitle=Instance.new("TextLabel")
discordTitle.BackgroundTransparency=1
discordTitle.Position=UDim2.fromOffset(70,12)
discordTitle.Size=UDim2.new(1,-240,0,20)
discordTitle.Font=Enum.Font.GothamBold
discordTitle.TextSize=12
discordTitle.TextXAlignment=Enum.TextXAlignment.Left
discordTitle.TextColor3=Color3.fromRGB(240,247,255)
discordTitle.Text="Join the Legends Hub Discord server"
discordTitle.Parent=discordBanner

local discordInfo=Instance.new("TextLabel")
discordInfo.BackgroundTransparency=1
discordInfo.Position=UDim2.fromOffset(70,32)
discordInfo.Size=UDim2.new(1,-235,0,28)
discordInfo.Font=Enum.Font.GothamMedium
discordInfo.TextSize=9
discordInfo.TextWrapped=true
discordInfo.TextXAlignment=Enum.TextXAlignment.Left
discordInfo.TextYAlignment=Enum.TextYAlignment.Top
discordInfo.TextColor3=Color3.fromRGB(135,164,199)
discordInfo.Text="Open-source scripts, updates, and support whenever you need help."
discordInfo.Parent=discordBanner

local discordBtn=makeButton("JOIN DISCORD",UDim2.new(1,-150,.5,-20),UDim2.fromOffset(132,40),"discord",discordBanner)

local bottomBar=Instance.new("Frame")
bottomBar.Position=UDim2.fromOffset(20,510)
bottomBar.Size=UDim2.new(1,-40,0,66)
bottomBar.BackgroundColor3=Color3.fromRGB(3,13,27)
bottomBar.BackgroundTransparency=.05
bottomBar.BorderSizePixel=0
bottomBar.Parent=card
Instance.new("UICorner",bottomBar).CornerRadius=UDim.new(0,15)
local bottomStroke=Instance.new("UIStroke",bottomBar)
bottomStroke.Color=Color3.fromRGB(26,68,113)
bottomStroke.Transparency=.38

local avatar=Instance.new("ImageLabel")
avatar.BackgroundColor3=Color3.fromRGB(8,29,50)
avatar.BorderSizePixel=0
avatar.Position=UDim2.fromOffset(8,8)
avatar.Size=UDim2.fromOffset(50,50)
avatar.Image=""
avatar.Parent=bottomBar
Instance.new("UICorner",avatar).CornerRadius=UDim.new(0,12)
local avatarStroke=Instance.new("UIStroke",avatar)
avatarStroke.Color=Color3.fromRGB(51,188,255)
avatarStroke.Transparency=.22

local onlineDot=Instance.new("Frame")
onlineDot.AnchorPoint=Vector2.new(1,1)
onlineDot.Position=UDim2.new(1,-3,1,-3)
onlineDot.Size=UDim2.fromOffset(11,11)
onlineDot.BackgroundColor3=Color3.fromRGB(65,225,124)
onlineDot.BorderSizePixel=0
onlineDot.Parent=avatar
Instance.new("UICorner",onlineDot).CornerRadius=UDim.new(1,0)
local onlineStroke=Instance.new("UIStroke",onlineDot)
onlineStroke.Color=Color3.fromRGB(3,13,27)
onlineStroke.Thickness=2

local playerName=Instance.new("TextLabel")
playerName.BackgroundTransparency=1
playerName.Position=UDim2.fromOffset(70,10)
playerName.Size=UDim2.fromOffset(210,23)
playerName.Font=Enum.Font.GothamBold
playerName.TextSize=14
playerName.TextXAlignment=Enum.TextXAlignment.Left
playerName.TextColor3=Color3.fromRGB(244,249,255)
playerName.Text=LP.DisplayName
playerName.Parent=bottomBar

local playerUser=Instance.new("TextLabel")
playerUser.BackgroundTransparency=1
playerUser.Position=UDim2.fromOffset(70,34)
playerUser.Size=UDim2.fromOffset(210,18)
playerUser.Font=Enum.Font.GothamMedium
playerUser.TextSize=10
playerUser.TextXAlignment=Enum.TextXAlignment.Left
playerUser.TextColor3=Color3.fromRGB(102,145,188)
playerUser.Text="@"..LP.Name.."  |  Session active"
playerUser.Parent=bottomBar

local infoDivider=Instance.new("Frame")
infoDivider.Position=UDim2.new(.58,0,0,13)
infoDivider.Size=UDim2.fromOffset(1,40)
infoDivider.BorderSizePixel=0
infoDivider.BackgroundColor3=Color3.fromRGB(42,92,145)
infoDivider.BackgroundTransparency=.25
infoDivider.Parent=bottomBar

local infoIcon=Instance.new("TextLabel")
infoIcon.BackgroundTransparency=1
infoIcon.Position=UDim2.new(.61,0,0,14)
infoIcon.Size=UDim2.fromOffset(28,36)
infoIcon.Font=Enum.Font.GothamBold
infoIcon.TextSize=15
infoIcon.TextColor3=Color3.fromRGB(89,181,255)
infoIcon.Text="i"
infoIcon.Parent=bottomBar

local infoText=Instance.new("TextLabel")
infoText.BackgroundTransparency=1
infoText.Position=UDim2.new(.66,0,0,10)
infoText.Size=UDim2.new(.32,0,0,44)
infoText.Font=Enum.Font.GothamMedium
infoText.TextSize=9
infoText.TextWrapped=true
infoText.TextXAlignment=Enum.TextXAlignment.Left
infoText.TextYAlignment=Enum.TextYAlignment.Center
infoText.TextColor3=Color3.fromRGB(115,151,188)
infoText.Text="Keys are stored locally only after successful validation."
infoText.Parent=bottomBar

task.spawn(function()
    local ok,img=pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
    end)
    if ok and img then avatar.Image=img end
end)

task.spawn(function()
    while Gui and Gui.Parent do
        sweep.Position=UDim2.fromOffset(-160,0)
        local tw=TweenService:Create(sweep,TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.fromOffset(690,0)})
        tw:Play()
        tw.Completed:Wait()
        task.wait(.7)
    end
end)

task.spawn(function()
    while Gui and Gui.Parent do
        diagonalLight.Position=UDim2.new(-.38,0,.22,0)
        local tw=TweenService:Create(diagonalLight,TweenInfo.new(4.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(1.03,0,.73,0)})
        tw:Play()
        tw.Completed:Wait()
        task.wait(.8)
    end
end)

task.spawn(function()
    while Gui and Gui.Parent do
        local a=TweenService:Create(outerStroke,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=.42})
        a:Play(); a.Completed:Wait()
        local b=TweenService:Create(outerStroke,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=.14})
        b:Play(); b.Completed:Wait()
    end
end)

task.spawn(function()
    while Gui and Gui.Parent do
        local a=TweenService:Create(emblemGlow,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=.68,Size=UDim2.fromOffset(106,106)})
        a:Play(); a.Completed:Wait()
        local b=TweenService:Create(emblemGlow,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=.84,Size=UDim2.fromOffset(92,92)})
        b:Play(); b.Completed:Wait()
    end
end)

uiScale.Scale=math.max(.7,targetScale*.94)
TweenService:Create(uiScale,TweenInfo.new(.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=math.max(.7,targetScale)}):Play()

local busy=false
local function setStatus(t,kind)
    status.Text=tostring(t)
    local col=kind=="ok" and Color3.fromRGB(106,235,155)
        or kind=="bad" and Color3.fromRGB(255,96,108)
        or kind=="warn" and Color3.fromRGB(255,190,88)
        or Color3.fromRGB(184,211,237)
    status.TextColor3=col
    statusIcon.Text=kind=="ok" and "OK" or kind=="bad" and "!" or kind=="warn" and "..." or "OK"
    statusIcon.TextColor3=col
    statusIconStroke.Color=col
    statusIconCircle.BackgroundColor3=kind=="bad" and Color3.fromRGB(64,19,27)
        or kind=="warn" and Color3.fromRGB(57,39,10)
        or Color3.fromRGB(8,56,86)
    if kind=="ok" then
        task.spawn(function()
            local a=TweenService:Create(statusIconCircle,TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(32,32)})
            a:Play(); a.Completed:Wait()
            TweenService:Create(statusIconCircle,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(28,28)}):Play()
        end)
    end
end

local function destroy()
    if Gui then Gui:Destroy() end
    ENV[GUI_STATE_KEY]=nil
end

ENV[GUI_STATE_KEY]={Destroy=destroy}

local gateOverlay=nil
local submit

local function gateButton(parentObj,text,y,mode)
    local b=Instance.new("TextButton")
    b.AutoButtonColor=false
    b.Position=UDim2.new(0,28,0,y)
    b.Size=UDim2.new(1,-56,0,46)
    b.BorderSizePixel=0
    b.Font=Enum.Font.GothamBold
    b.TextSize=12
    b.Text=text
    b.ZIndex=63
    b.Parent=parentObj
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,11)
    local st=Instance.new("UIStroke",b)
    st.Thickness=1.1
    if mode=="discord" then
        b.BackgroundColor3=Color3.fromRGB(68,90,238)
        b.TextColor3=Color3.fromRGB(247,250,255)
        st.Color=Color3.fromRGB(122,159,255)
        st.Transparency=.12
    elseif mode=="primary" then
        b.BackgroundColor3=Color3.fromRGB(67,207,252)
        b.TextColor3=Color3.fromRGB(2,24,43)
        st.Color=Color3.fromRGB(177,244,255)
        st.Transparency=.12
    else
        b.BackgroundColor3=Color3.fromRGB(9,31,59)
        b.TextColor3=Color3.fromRGB(218,236,252)
        st.Color=Color3.fromRGB(47,105,166)
        st.Transparency=.24
    end
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(.12),{BackgroundTransparency=.08}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(.12),{BackgroundTransparency=0}):Play()
    end)
    return b
end

local function showDiscordGate(key,data,targetTitle)
    if gateOverlay then pcall(function() gateOverlay:Destroy() end) end

    gateOverlay=Instance.new("Frame")
    gateOverlay.Size=UDim2.fromScale(1,1)
    gateOverlay.BackgroundColor3=Color3.fromRGB(1,8,20)
    gateOverlay.BackgroundTransparency=.04
    gateOverlay.BorderSizePixel=0
    gateOverlay.ZIndex=55
    gateOverlay.Parent=card

    local panel=Instance.new("Frame")
    panel.AnchorPoint=Vector2.new(.5,.5)
    panel.Position=UDim2.fromScale(.5,.5)
    panel.Size=UDim2.fromOffset(570,365)
    panel.BackgroundColor3=Color3.fromRGB(4,17,36)
    panel.BorderSizePixel=0
    panel.ZIndex=56
    panel.Parent=gateOverlay
    Instance.new("UICorner",panel).CornerRadius=UDim.new(0,18)
    local ps=Instance.new("UIStroke",panel)
    ps.Color=Color3.fromRGB(72,124,255)
    ps.Transparency=.13
    ps.Thickness=1.5

    local badge=Instance.new("TextLabel")
    badge.Position=UDim2.fromOffset(28,24)
    badge.Size=UDim2.fromOffset(190,30)
    badge.BackgroundColor3=Color3.fromRGB(23,44,99)
    badge.BorderSizePixel=0
    badge.Font=Enum.Font.GothamBold
    badge.TextSize=11
    badge.TextColor3=Color3.fromRGB(168,205,255)
    badge.Text="DISCORD REQUIRED"
    badge.ZIndex=60
    badge.Parent=panel
    Instance.new("UICorner",badge).CornerRadius=UDim.new(1,0)

    local gateTitle=Instance.new("TextLabel")
    gateTitle.BackgroundTransparency=1
    gateTitle.Position=UDim2.fromOffset(28,70)
    gateTitle.Size=UDim2.new(1,-56,0,38)
    gateTitle.Font=Enum.Font.GothamBold
    gateTitle.TextSize=23
    gateTitle.TextXAlignment=Enum.TextXAlignment.Left
    gateTitle.TextColor3=Color3.fromRGB(246,250,255)
    gateTitle.Text="Verify Discord to continue"
    gateTitle.ZIndex=60
    gateTitle.Parent=panel

    local gateSub=Instance.new("TextLabel")
    gateSub.BackgroundTransparency=1
    gateSub.Position=UDim2.fromOffset(28,111)
    gateSub.Size=UDim2.new(1,-56,0,82)
    gateSub.Font=Enum.Font.GothamMedium
    gateSub.TextSize=11
    gateSub.TextWrapped=true
    gateSub.TextXAlignment=Enum.TextXAlignment.Left
    gateSub.TextYAlignment=Enum.TextYAlignment.Top
    gateSub.TextColor3=Color3.fromRGB(151,181,214)
    gateSub.Text="Verify your Discord identity to continue with "..tostring(targetTitle or "this script")..". The verification link is copied automatically when you press the button. No password, cookie, QR code or 2FA code is requested."
    gateSub.ZIndex=60
    gateSub.Parent=panel

    local gateInfo=Instance.new("TextLabel")
    gateInfo.BackgroundColor3=Color3.fromRGB(7,28,54)
    gateInfo.BorderSizePixel=0
    gateInfo.Position=UDim2.fromOffset(28,200)
    gateInfo.Size=UDim2.new(1,-56,0,45)
    gateInfo.Font=Enum.Font.GothamMedium
    gateInfo.TextSize=10
    gateInfo.TextWrapped=true
    gateInfo.TextColor3=Color3.fromRGB(122,181,235)
    gateInfo.Text="Press Verify Discord. The rest of the unlock happens automatically in this Roblox session."
    gateInfo.ZIndex=60
    gateInfo.Parent=panel
    Instance.new("UICorner",gateInfo).CornerRadius=UDim.new(0,9)

    local verifyBtn=gateButton(panel,"VERIFY DISCORD",272,"discord")

    local verifyStarted=false
    verifyBtn.Activated:Connect(function()
        if verifyStarted then return end
        local verifyUrl=tostring(data.discord_verify_url or "")
        if verifyUrl=="" then
            gateInfo.Text="Verification link unavailable. Re-enter the key to refresh the verification link."
            return
        end

        verifyStarted=true
        verifyBtn.Text="VERIFICATION OPENED"
        verifyBtn.Active=false

        local clip=rawget(ENV,"setclipboard") or rawget(_G,"setclipboard")
        if type(clip)=="function" then pcall(clip,verifyUrl) end
        openKeyPage(verifyUrl)

        gateInfo.Text="Verification opened and link copied. You can return to Roblox; this session will continue automatically."

        task.spawn(function()
            task.wait(60)
            if not gateOverlay or not gateOverlay.Parent then return end

            pcall(function() Gui.Enabled=false end)
            gateInfo.Text="Finishing verification..."
            for _=1,12 do
                local ok,current=resolveKey(key)
                if ok and type(current)=="table" and current.discord_required~=true then
                    busy=true
                    local targetSlug=tostring(current.slug or "")
                    local targetTitle2=tostring(current.title or targetSlug)
                    saveKey(key)
                    ENV.script_key=key
                    ENV.SCRIPT_KEY=key
                    _G.script_key=key
                    _G.SCRIPT_KEY=key
                    setStatus("Verification complete - loading "..targetTitle2,"ok")
                    local loaded,loadErr=loadProtected(key,targetSlug)
                    if loaded then
                        LoaderState.loaded[targetSlug]=true
                        destroy()
                        return
                    end
                    pcall(function() Gui.Enabled=true end)
                    busy=false
                    LoaderState.loaded[targetSlug]=nil
                    gateInfo.Text="Verification completed, but the protected script could not load: "..tostring(loadErr)
                    verifyStarted=false
                    verifyBtn.Active=true
                    verifyBtn.Text="VERIFY DISCORD"
                    return
                end
                task.wait(2.5)
            end

            pcall(function() Gui.Enabled=true end)
            gateInfo.Text="Verification is still pending. Re-open Verify Discord if authorization was not completed."
            verifyStarted=false
            verifyBtn.Active=true
            verifyBtn.Text="VERIFY DISCORD"
        end)
    end)


    panel.Size=UDim2.fromOffset(545,345)
    TweenService:Create(panel,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(570,365)}):Play()
end

submit=function()
    if busy then return end
    local key=tostring(input.Text or ""):match("^%s*(.-)%s*$") or ""
    if key=="" then setStatus("Enter a key first.","bad") return end

    busy=true
    setStatus("Validating key...","warn")
    task.spawn(function()
        local valid,data=resolveKey(key)
        if not valid then
            busy=false
            setStatus(tostring(data),"bad")
            return
        end

        local targetSlug=tostring(data.slug or "")
        local targetTitle=tostring(data.title or targetSlug)
        local targetPlace=tostring(data.place_id or "")
        local targetGame=tostring(data.game_id or "")
        local samePlace=(targetPlace~="" and targetPlace==tostring(game.PlaceId))
        local sameGame=(targetGame~="" and targetGame==tostring(game.GameId))

        if not samePlace and not sameGame then
            busy=false
            setStatus("This key belongs to "..targetTitle..". Open the matching Roblox game.","bad")
            return
        end

        if data.discord_required==true then
            busy=false
            setStatus("Discord verification required - verify to continue.","warn")
            showDiscordGate(key,data,targetTitle)
            return
        end

        saveKey(key)
        ENV.script_key=key
        ENV.SCRIPT_KEY=key
        _G.script_key=key
        _G.SCRIPT_KEY=key

        local hours=math.max(0,math.floor((tonumber(data.remaining_seconds) or 0)/3600))
        setStatus("Access granted - loading "..targetTitle.." | ~"..hours.."h remaining","ok")

        local ok,err=loadProtected(key,targetSlug)
        if not ok then
            busy=false
            LoaderState.loaded[targetSlug]=nil
            setStatus("Load failed: "..tostring(err),"bad")
            return
        end
        LoaderState.loaded[targetSlug]=true
        destroy()
    end)
end

check.Activated:Connect(submit)
input.FocusLost:Connect(function(enter) if enter then submit() end end)

getKey.Activated:Connect(function()
    local opened,msg=openKeyPage()
    setStatus(msg,opened and "ok" or "warn")
end)

local quickLinkOverlay=nil
local function showQuickKeyLink()
    if quickLinkOverlay then quickLinkOverlay:Destroy() end
    quickLinkOverlay=Instance.new("Frame")
    quickLinkOverlay.Size=UDim2.fromScale(1,1)
    quickLinkOverlay.BackgroundColor3=Color3.fromRGB(1,8,20)
    quickLinkOverlay.BackgroundTransparency=.08
    quickLinkOverlay.BorderSizePixel=0
    quickLinkOverlay.ZIndex=55
    quickLinkOverlay.Parent=card

    local panel=Instance.new("Frame")
    panel.AnchorPoint=Vector2.new(.5,.5)
    panel.Position=UDim2.fromScale(.5,.5)
    panel.Size=UDim2.new(1,-48,0,244)
    panel.BackgroundColor3=Color3.fromRGB(4,17,36)
    panel.BorderSizePixel=0
    panel.ZIndex=56
    panel.Parent=quickLinkOverlay
    Instance.new("UICorner",panel).CornerRadius=UDim.new(0,18)
    local outline=Instance.new("UIStroke",panel)
    outline.Color=Color3.fromRGB(72,166,255)
    outline.Transparency=.15

    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1
    label.Position=UDim2.fromOffset(24,20)
    label.Size=UDim2.new(1,-48,0,30)
    label.Font=Enum.Font.GothamBold
    label.TextSize=21
    label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextColor3=Color3.fromRGB(246,250,255)
    label.Text="Copy the Key Link"
    label.ZIndex=60
    label.Parent=panel

    local hint=Instance.new("TextLabel")
    hint.BackgroundTransparency=1
    hint.Position=UDim2.fromOffset(24,56)
    hint.Size=UDim2.new(1,-48,0,40)
    hint.Font=Enum.Font.GothamMedium
    hint.TextSize=12
    hint.TextWrapped=true
    hint.TextXAlignment=Enum.TextXAlignment.Left
    hint.TextColor3=Color3.fromRGB(151,181,214)
    hint.Text="Automatic clipboard access is unavailable. Copy the link below and paste it into your browser."
    hint.ZIndex=60
    hint.Parent=panel

    local link=Instance.new("TextBox")
    link.Position=UDim2.fromOffset(24,108)
    link.Size=UDim2.new(1,-48,0,52)
    link.BackgroundColor3=Color3.fromRGB(7,28,54)
    link.BorderSizePixel=0
    link.ClearTextOnFocus=false
    link.TextEditable=true
    link.Font=Enum.Font.GothamMedium
    link.TextSize=11
    link.TextWrapped=true
    link.TextColor3=Color3.fromRGB(153,221,255)
    link.Text=GET_KEY_QUICK_URL
    link.ZIndex=60
    link.Parent=panel
    Instance.new("UICorner",link).CornerRadius=UDim.new(0,10)
    link.Focused:Connect(function()
        link.CursorPosition=#link.Text+1
        link.SelectionStart=1
    end)

    link.FocusLost:Connect(function() link.Text=GET_KEY_QUICK_URL end)

    local close=makeButton("Back to Key System",UDim2.fromOffset(24,180),UDim2.new(1,-48,0,42),"accent",panel)
    close.ZIndex=60
    close.Activated:Connect(function()
        if quickLinkOverlay then quickLinkOverlay:Destroy(); quickLinkOverlay=nil end
    end)
end

quickKey.Activated:Connect(function()
    if copyQuickKeyLink() then
        quickKey.Text="Key Link Copied (Paste in browser)"
        setStatus("Key Link Copied (Paste in browser)","ok")
    else
        quickKey.Text="Copy Link Manually"
        setStatus("Clipboard unavailable. Copy the displayed link.","warn")
        showQuickKeyLink()
    end
end)

discordBtn.Activated:Connect(function()
    local opened,msg=openKeyPage(DISCORD_INVITE_URL)
    if opened then
        setStatus("Discord opened - join Legends Hub for scripts, updates, and support.","ok")
    else
        setStatus("Discord invite copied to clipboard.","ok")
    end
end)

premium.Activated:Connect(function()
    setStatus("Premium is not available yet.","warn")
end)

input.Focused:Connect(function()
    ins.Color=Color3.fromRGB(59,130,246)
    ins.Transparency=.1
end)
input.FocusLost:Connect(function()
    ins.Color=Color3.fromRGB(36,74,118)
    ins.Transparency=.35
end)

input.Text=""
setStatus("Ready - enter your access key.","idle")

