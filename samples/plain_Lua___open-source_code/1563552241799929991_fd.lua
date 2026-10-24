-- WindUI Boreal
-- Version: v0.0.1
-- BuildDate: 2026-02-19
-- Description: Roblox UI Library for scripts
-- Repository: https://github.com/orialdev/WindUI-Boreal
-- Discord: http://discord.gg/B3dEqP2EX6
-- License: MIT

local a={cache={}::any}do do local function __modImpl()local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"ReplicatedStorage":WaitForChild("GetIcons",99999):InvokeServer())

local function parseIconString(e)
if type(e)=="string"then
local f=e:find":"
if f then
local g=e:sub(1,f-1)
local h=e:sub(f+1)
return g,h
end
end
return nil,e
end

function d.AddIcons(e,f)
if type(e)~="string"or type(f)~="table"then
error"AddIcons: packName must be string, iconsData must be table"
return
end

if not d.Icons[e]then
d.Icons[e]={
Icons={},
Spritesheets={}
}
end

for g,h in pairs(f)do
if type(h)=="number"or(type(h)=="string"and h:match"^rbxassetid://")then
local i=h
if type(h)=="number"then
i="rbxassetid://"..tostring(h)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0),
Parts=nil
}
d.Icons[e].Spritesheets[i]=i

elseif type(h)=="table"then
if h.Image and h.ImageRectSize and h.ImageRectPosition then
local i=h.Image
if type(i)=="number"then
i="rbxassetid://"..tostring(i)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=h.ImageRectSize,
ImageRectPosition=h.ImageRectPosition,
Parts=h.Parts
}

if not d.Icons[e].Spritesheets[i]then
d.Icons[e].Spritesheets[i]=i
end
else
warn("AddIcons: Invalid spritesheet data format for icon '"..g.."'")
end
else
warn("AddIcons: Unsupported data type for icon '"..g.."': "..type(h))
end
end
end

function d.SetIconsType(e)
d.IconsType=e
end

local e
function d.Init(f,g)
d.New=f
d.IconThemeTag=g

e=f
return d
end

function d.Icon(f,g,h)
h=h~=false
local i,j=parseIconString(f)

local l=i or g or d.IconsType
local m=j

local p=d.Icons[l]

if p and p.Icons and p.Icons[m]then
return{
p.Spritesheets[tostring(p.Icons[m].Image)],
p.Icons[m],
}
elseif p and p[m]and string.find(p[m],"rbxassetid://")then
return h and{
p[m],
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}or p[m]
end
return nil
end

function d.GetIcon(f,g)
return d.Icon(f,g,false)
end


function d.Icon2(f,g,h)
return d.Icon(f,g,true)
end

function d.Image(f)
local g={
Icon=f.Icon or nil,
Type=f.Type,
Colors=f.Colors or{(d.IconThemeTag or Color3.new(1,1,1)),Color3.new(1,1,1)},
Transparency=f.Transparency or{0,0},
Size=f.Size or UDim2.new(0,24,0,24),

IconFrame=nil,
}

local h={}
local i={}

for j,l in next,g.Colors do
h[j]={
ThemeTag=typeof(l)=="string"and l,
Color=typeof(l)=="Color3"and l,
}
end

for j,l in next,g.Transparency do
i[j]={
ThemeTag=typeof(l)=="string"and l,
Value=typeof(l)=="number"and l,
}
end


local j=d.Icon2(g.Icon,g.Type)
local l=typeof(j)=="string"and string.find(j,'rbxassetid://')

if d.New then
local m=e or d.New



local p=m("ImageLabel",{
Size=g.Size,
BackgroundTransparency=1,
ImageColor3=h[1].Color or nil,
ImageTransparency=i[1].Value or nil,
ThemeTag=h[1].ThemeTag and{
ImageColor3=h[1].ThemeTag,
ImageTransparency=i[1].ThemeTag,
},
Image=l and j or j[1],
ImageRectSize=l and nil or j[2].ImageRectSize,
ImageRectOffset=l and nil or j[2].ImageRectPosition,
})


if not l and j[2].Parts then
for r,u in next,j[2].Parts do
local v=d.Icon(u,g.Type)

m("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=h[1+r].Color or nil,
ImageTransparency=i[1+r].Value or nil,
ThemeTag=h[1+r].ThemeTag and{
ImageColor3=h[1+r].ThemeTag,
ImageTransparency=i[1+r].ThemeTag,
},
Image=v[1],
ImageRectSize=v[2].ImageRectSize,
ImageRectOffset=v[2].ImageRectPosition,
Parent=p,
})
end
end

g.IconFrame=p
else
local m=Instance.new"ImageLabel"
m.Size=g.Size
m.BackgroundTransparency=1
m.ImageColor3=h[1].Color
m.ImageTransparency=i[1].Value or nil
m.Image=l and j or j[1]
m.ImageRectSize=l and nil or j[2].ImageRectSize
m.ImageRectOffset=l and nil or j[2].ImageRectPosition


if not l and j[2].Parts then
for p,r in next,j[2].Parts do
local u=d.Icon(r,g.Type)

local v=Instance.New"ImageLabel"
v.Size=UDim2.new(1,0,1,0)
v.BackgroundTransparency=1
v.ImageColor3=h[1+p].Color
v.ImageTransparency=i[1+p].Value or nil
v.Image=u[1]
v.ImageRectSize=u[2].ImageRectSize
v.ImageRectOffset=u[2].ImageRectPosition
v.Parent=m
end
end

g.IconFrame=m
end


return g
end

return d end function a.a():typeof(__modImpl())local b=a.cache.a if not b then b={c=__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()

return{


Primary="Icon",

White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

PanelBackground="White",
PanelBackgroundTransparency=.95,

WindowBackground="Background",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",

WindowSearchBarBackground="Background",

TabBackground="Hover",
TabBackgroundHover="Hover",
TabBackgroundHoverTransparency=.97,
TabBackgroundActive="Hover",
TabBackgroundActiveTransparency=0.93,
TabText="Text",
TabTextTransparency=0.3,
TabTextTransparencyActive=0,
TabTitle="Text",
TabIcon="Icon",
TabIconTransparency=0.4,
TabIconTransparencyActive=0.1,
TabBorderTransparency=1,
TabBorderTransparencyActive=0.75,
TabBorder="White",


ElementBackground="Text",
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Background",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Primary",
CheckboxIcon="White",
CheckboxBorder="White",
CheckboxBorderTransparency=.75,

SliderIcon="Icon",

Slider="Primary",
SliderThumb="White",
SliderIconFrom="SliderIcon",
SliderIconTo="SliderIcon",

Tooltip=Color3.fromHex"4C4C4C",
TooltipText="White",
TooltipSecondary="Primary",
TooltipSecondaryText="White",

SectionExpandIcon="White",
SectionExpandIconTransparency=.4,
SectionTitle="Text",
SectionDesc="Text",
SectionIcon="Icon",
SectionIconBackground="White",
SectionIconBackgroundTransparency=.92,
SectionCounterBackground="White",
SectionCounterBackgroundTransparency=.88,
SectionCounterText="Text",
Divider="Text",
DividerTransparency=.9,
DividerLabel="Text",
DividerLabelTransparency=.25,
SectionContentDivider="White",
SectionContentDividerTransparency=.86,
SectionBox="White",
SectionBoxTransparency=.95,
SectionBoxBorder="White",
SectionBoxBorderTransparency=.75,
SectionBoxBackground="White",
SectionBoxBackgroundTransparency=.95,

SearchBarBorder="White",
SearchBarBorderTransparency=.75,

Notification="Background",
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=.4,
NotificationDuration="White",
NotificationDurationTransparency=.95,
NotificationBorder="White",
NotificationBorderTransparency=.75,

DropdownTabBorder="White",

LabelBackground="White",
LabelBackgroundTransparency=.95,
}end function a.b():typeof(__modImpl())local b=a.cache.b if not b then b={c=__modImpl()}a.cache.b=b end return b.c end end do local function __modImpl()


local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")local i=

d.Heartbeat

local j="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local l
if d:IsStudio()or not writefile then
l=a.a()
else
l=loadstring(
game.HttpGetAsync and game:HttpGetAsync(j)
or h:GetAsync(j)
)()
end

l.SetIconsType"lucide"

local m

local p={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=l,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
}
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=a.b(),
Shapes={Square=
"rbxassetid://82909646051652",
["Square-Outline"]="rbxassetid://72946211851948",Squircle=

"rbxassetid://80999662900595",SquircleOutline=
"rbxassetid://117788349049947",
["Squircle-Outline"]="rbxassetid://117817408534198",SquircleOutline2=

"rbxassetid://117817408534198",

["Shadow-sm"]="rbxassetid://84825982946844",

["Squircle-TL-TR"]="rbxassetid://73569156276236",
["Squircle-BL-BR"]="rbxassetid://93853842912264",
["Squircle-TL-TR-Outline"]="rbxassetid://136702870075563",
["Squircle-BL-BR-Outline"]="rbxassetid://75035847706564",

["Glass-0.7"]="rbxassetid://79047752995006",
["Glass-1"]="rbxassetid://97324581055162",
["Glass-1.4"]="rbxassetid://95071123641270",
}
}

function p.Init(r)
m=r
end

function p.AddSignal(r,u)
local v=r:Connect(u)
table.insert(p.Signals,v)
return v
end

function p.DisconnectAll()
for r,u in next,p.Signals do
local v=table.remove(p.Signals,r)
v:Disconnect()
end
end

function p.SafeCallback(r,...)
if not r then
return
end

local u,v=pcall(r,...)
if not u then
if m and m.Window and m.Window.Debug then local
x, z=v:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..v)

return m:Notify{
Title="DEBUG Mode: Error",
Content=not z and v or v:sub(z+1),
Duration=8,
}
end
end
end

function p.Gradient(r,u)
if m and m.Gradient then
return m:Gradient(r,u)
end

local v={}
local x={}

for z,A in next,r do
local B=tonumber(z)
if B then
B=math.clamp(B/100,0,1)
table.insert(v,ColorSequenceKeypoint.new(B,A.Color))
table.insert(x,NumberSequenceKeypoint.new(B,A.Transparency or 0))
end
end

table.sort(v,function(z,A)return z.Time<A.Time end)
table.sort(x,function(z,A)return z.Time<A.Time end)

if#v<2 then
error"ColorSequence requires at least 2 keypoints"
end

local z={
Color=ColorSequence.new(v),
Transparency=NumberSequence.new(x),
}

if u then
for A,B in pairs(u)do
z[A]=B
end
end

return z
end

function p.SetTheme(r)
p.Theme=r
p.UpdateTheme(nil,false)
end

function p.AddFontObject(r)
table.insert(p.FontObjects,r)
p.UpdateFont(p.Font)
end

function p.UpdateFont(r)
p.Font=r
for u,v in next,p.FontObjects do
v.FontFace=Font.new(r,v.FontFace.Weight,v.FontFace.Style)
end
end

function p.GetThemeProperty(r,u)
local function getValue(v,x)
local z=x[v]

if z==nil then return nil end

if typeof(z)=="string"and string.sub(z,1,1)=="#"then
return Color3.fromHex(z)
end

if typeof(z)=="Color3"then
return z
end

if typeof(z)=="number"then
return z
end

if typeof(z)=="table"and z.Color and z.Transparency then
return z
end

if typeof(z)=="function"then
return z()
end

return z
end

local v=getValue(r,u)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local x=p.GetThemeProperty(v,u)
if x~=nil then
return x
end
else
return v
end
end

local x=p.ThemeFallbacks[r]
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,u)
else
return getValue(r,{[r]=x})
end
end

v=getValue(r,p.Themes.Dark)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local z=p.GetThemeProperty(v,p.Themes.Dark)
if z~=nil then
return z
end
else
return v
end
end

if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,p.Themes.Dark)
else
return getValue(r,{[r]=x})
end
end

return nil
end

function p.AddThemeObject(r,u)
if p.Objects[r]then
for v,x in pairs(u)do
p.Objects[r].Properties[v]=x
end
else
p.Objects[r]={Object=r,Properties=u}
end

p.UpdateTheme(r,false)
return r
end

function p.AddLangObject(r)
local u=p.LocalizationObjects[r]
if not u then return end

local v=u.Object

p.SetLangForObject(r)

return v
end

function p.UpdateTheme(r,u,v,x,z,A)
local function ApplyTheme(B)
for C,F in pairs(B.Properties or{})do
local G=p.GetThemeProperty(F,p.Theme)
if G~=nil then
if typeof(G)=="Color3"then
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end

if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
elseif typeof(G)=="table"and G.Color and G.Transparency then
B.Object[C]=Color3.new(1,1,1)

local H=B.Object:FindFirstChild"LibraryGradient"
if not H then
H=Instance.new"UIGradient"
H.Name="LibraryGradient"
H.Parent=B.Object
end

H.Color=G.Color
H.Transparency=G.Transparency

for J,L in pairs(G)do
if J~="Color"and J~="Transparency"and H[J]~=nil then
H[J]=L
end
end
elseif typeof(G)=="number"then
if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
end
else

local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end
end
end
end

if r then
local B=p.Objects[r]
if B then
ApplyTheme(B)
end
else
for B,C in pairs(p.Objects)do
ApplyTheme(C)
end
end
end


function p.SetThemeTag(r,u,v,x,z)
p.AddThemeObject(r,u)
p.UpdateTheme(r,false,true,v,x,z)
end

function p.SetLangForObject(r)
if p.Localization and p.Localization.Enabled then
local u=p.LocalizationObjects[r]
if not u then return end

local v=u.Object
local x=u.TranslationId

local z=p.Localization.Translations[p.Language]
if z and z[x]then
v.Text=z[x]
else
local A=p.Localization and p.Localization.Translations and p.Localization.Translations.en or nil
if A and A[x]then
v.Text=A[x]
else
v.Text="["..x.."]"
end
end
end
end

function p.ChangeTranslationKey(r,u,v)
if p.Localization and p.Localization.Enabled then
local x=string.match(v,"^"..p.Localization.Prefix.."(.+)")
if x then
for z,A in ipairs(p.LocalizationObjects)do
if A.Object==u then
A.TranslationId=x
p.SetLangForObject(z)
return
end
end

table.insert(p.LocalizationObjects,{
TranslationId=x,
Object=u
})
p.SetLangForObject(#p.LocalizationObjects)
end
end
end

function p.UpdateLang(r)
if r then
p.Language=r
end

for u=1,#p.LocalizationObjects do
local v=p.LocalizationObjects[u]
if v.Object and v.Object.Parent~=nil then
p.SetLangForObject(u)
else
p.LocalizationObjects[u]=nil
end
end
end

function p.SetLanguage(r)
p.Language=r
p.UpdateLang()
end

function p.Icon(r,u)
return l.Icon2(r,nil,u~=false)
end

function p.AddIcons(r,u)
return l.AddIcons(r,u)
end

function p.New(r,u,v)
local x=Instance.new(r)

for z,A in next,p.DefaultProperties[r]or{}do
x[z]=A
end

for z,A in next,u or{}do
if z~="ThemeTag"then
x[z]=A
end
if p.Localization and p.Localization.Enabled and z=="Text"then
local B=string.match(A,"^"..p.Localization.Prefix.."(.+)")
if B then
local C=#p.LocalizationObjects+1
p.LocalizationObjects[C]={TranslationId=B,Object=x}

p.SetLangForObject(C)
end
end
end

for z,A in next,v or{}do
A.Parent=x
end

if u and u.ThemeTag then
p.AddThemeObject(x,u.ThemeTag)
end
if u and u.FontFace then
p.AddFontObject(x)
end
return x
end

function p.Tween(r,u,v,...)
return f:Create(r,TweenInfo.new(u,...),v)
end

function p.NewRoundFrame(r,u,v,x,z,A)
local function getImageForType(B)
return p.Shapes[B]
end

local function getSliceCenterForType(B)
return not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},B)and Rect.new(256
,256
,256
,256

)or Rect.new(512,512,512,512)
end

local B=p.New(z and"ImageButton"or"ImageLabel",{
Image=getImageForType(u),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(u),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=v.ThemeTag and v.ThemeTag
},x)

for C,F in pairs(v or{})do
if C~="ThemeTag"then
B[C]=F
end
end

local function UpdateSliceScale(C)
local F=not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},u)and(C/(256))or(C/512)
B.SliceScale=math.max(F,0.0001)
end

local C={}

function C.SetRadius(F,G)
UpdateSliceScale(G)
end

function C.SetType(F,G)
u=G
B.Image=getImageForType(G)
B.SliceCenter=getSliceCenterForType(G)
UpdateSliceScale(r)
end

function C.UpdateShape(F,G,H)
if H then
u=H
B.Image=getImageForType(H)
B.SliceCenter=getSliceCenterForType(H)
end
if G then
r=G
end
UpdateSliceScale(r)
end

function C.GetRadius(F)
return r
end

function C.GetType(F)
return u
end

UpdateSliceScale(r)

return B,A and C or nil
end

local r=p.New local u=
p.Tween

function p.SetDraggable(v)
p.CanDraggable=v
end



function p.Drag(v,x,z)
local A
local B,C,F
local G={
CanDraggable=true
}

if not x or typeof(x)~="table"then
x={v}
end

local function update(H)
if not B or not G.CanDraggable then return end

local J=H.Position-C
p.Tween(v,0.02,{Position=UDim2.new(
F.X.Scale,F.X.Offset+J.X,
F.Y.Scale,F.Y.Offset+J.Y
)}):Play()
end

for H,J in pairs(x)do
J.InputBegan:Connect(function(L)
if(L.UserInputType==Enum.UserInputType.MouseButton1 or L.UserInputType==Enum.UserInputType.Touch)and G.CanDraggable then
if A==nil then
A=J
B=true
C=L.Position
F=v.Position

if z and typeof(z)=="function"then
z(true,A)
end

L.Changed:Connect(function()
if L.UserInputState==Enum.UserInputState.End then
B=false
A=nil

if z and typeof(z)=="function"then
z(false,nil)
end
end
end)
end
end
end)

J.InputChanged:Connect(function(L)
if B and A==J then
if L.UserInputType==Enum.UserInputType.MouseMovement or L.UserInputType==Enum.UserInputType.Touch then
update(L)
end
end
end)
end

e.InputChanged:Connect(function(H)
if B and A~=nil then
if H.UserInputType==Enum.UserInputType.MouseMovement or H.UserInputType==Enum.UserInputType.Touch then
update(H)
end
end
end)

function G.Set(H,J)
G.CanDraggable=J
end

return G
end


l.Init(r,"Icon")


function p.SanitizeFilename(v)
local x=v:match"([^/]+)$"or v

x=x:gsub("%.[^%.]+$","")

x=x:gsub("[^%w%-_]","_")

if#x>50 then
x=x:sub(1,50)
end

return x
end

function p.Image(v,x,z,A,B,C,F,G)
A=A or"Temp"
x=p.SanitizeFilename(x)

local H=r("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(p.Icon(v)or F)and{
ImageColor3=C and(G or"Icon")or nil
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,z)
})
})
})
if p.Icon(v)then
H.ImageLabel:Destroy()

local J=l.Image{
Icon=v,
Size=UDim2.new(1,0,1,0),
Colors={
(C and(G or"Icon")or false),
"Button"
}
}.IconFrame
J.Parent=H
elseif string.find(v,"http")then
local J="WindUI/"..A.."/assets/."..B.."-"..x..".png"
local L,M=pcall(function()
task.spawn(function()
local L=p.Request and p.Request{
Url=v,
Method="GET",
}.Body or{}

if not d:IsStudio()and writefile then writefile(J,L)end


local M,N=pcall(getcustomasset,J)
if M then
H.ImageLabel.Image=N
else
warn(string.format("[ WindUI.Creator ] Failed to load custom asset '%s': %s",J,tostring(N)))
H:Destroy()

return
end
end)
end)
if not L then
local N=(identifyexecutor and identifyexecutor())or"Studio"
warn("[ WindUI.Creator ]  '"..N.."' doesnt support the URL Images. Error: "..tostring(M))

H:Destroy()
end
elseif v==""then
H.Visible=false
else
H.ImageLabel.Image=v
end

return H
end



function p.Color3ToHSB(v)
local x,z,A=v.R,v.G,v.B
local B=math.max(x,z,A)
local C=math.min(x,z,A)
local F=B-C

local G=0
if F~=0 then
if B==x then
G=(z-A)/F%6
elseif B==z then
G=(A-x)/F+2
else
G=(x-z)/F+4
end
G=G*60
else
G=0
end

local H=(B==0)and 0 or(F/B)
local J=B

return{
h=math.floor(G+0.5),
s=H,
b=J
}
end

function p.GetPerceivedBrightness(v)
local x=v.R
local z=v.G
local A=v.B
return 0.299*x+0.587*z+0.114*A
end

function p.GetTextColorForHSB(v,x)
local z=p.Color3ToHSB(v)local
A, B, C=z.h, z.s, z.b
if p.GetPerceivedBrightness(v)>(x or 0.5)then
return Color3.fromHSV(A/360,0,0.05)
else
return Color3.fromHSV(A/360,0,0.98)
end
end

function p.GetAverageColor(v)
local x,z,A=0,0,0
local B=v.Color.Keypoints
for C,F in ipairs(B)do

x=x+F.Value.R
z=z+F.Value.G
A=A+F.Value.B
end
local C=#B
return Color3.new(x/C,z/C,A/C)
end

function p.GenerateUniqueID(v)
return h:GenerateGUID(false)
end

return p end function a.c():typeof(__modImpl())local b=a.cache.c if not b then b={c=__modImpl()}a.cache.c=b end return b.c end end do local function __modImpl()

local b={}







function b.New(d,e,f)
local g={
Enabled=e.Enabled or false,
Translations=e.Translations or{},
Prefix=e.Prefix or"loc:",
DefaultLanguage=e.DefaultLanguage or"en"
}

f.Localization=g

return g
end



return b end function a.d():typeof(__modImpl())local b=a.cache.d if not b then b={c=__modImpl()}a.cache.d=b end return b.c end end do local function __modImpl()
local b={}

local d=a.c()
local e=d.New
local f=d.Tween


function b.New(g,h,j,l,m,p,r,u)
l=l or"Primary"
local v=u or(not r and 10 or 99)
local x
if h and h~=""then
x=e("ImageLabel",{
Image=d.Icon(h)[1],
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=l=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=l=="White"and.4 or 0,
ThemeTag={
ImageColor3=l~="White"and"Icon"or nil,
}
})
end

local z=e("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=m,
BackgroundTransparency=1
},{
d.NewRoundFrame(v,"Squircle",{
ThemeTag={
ImageColor3=l~="White"and"Button"or nil,
},
ImageColor3=l=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=l=="Primary"and 0 or l=="White"and 0 or 1
}),

d.NewRoundFrame(v,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=l=="Secondary"and 0.95 or 1
}),

d.NewRoundFrame(v,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not r
}),

d.NewRoundFrame(v,not r and"Glass-1"or"Glass-0.7",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,0,1,0),

ImageTransparency=0.6,
Name="Outline",
},{













}),

d.NewRoundFrame(v,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=l~="White"and"Text"or nil
},
ImageColor3=l=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1
},{
e("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
e("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
x,
e("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(d.Font,Enum.FontWeight.SemiBold),
Text=g or"Button",
ThemeTag={
TextColor3=(l~="Primary"and l~="White")and"Text",
},
TextColor3=l=="Primary"and Color3.new(1,1,1)or l=="White"and Color3.new(0,0,0)or nil,
AutomaticSize="XY",
TextSize=18,
})
})
})

d.AddSignal(z.MouseEnter,function()
f(z.Frame,.047,{ImageTransparency=.95}):Play()
end)
d.AddSignal(z.MouseLeave,function()
f(z.Frame,.047,{ImageTransparency=1}):Play()
end)
d.AddSignal(z.MouseButton1Up,function()
if p then
p:Close()()
end
if j then
d.SafeCallback(j)
end
end)

return z
end


return b end function a.e():typeof(__modImpl())local b=a.cache.e if not b then b={c=__modImpl()}a.cache.e=b end return b.c end end do local function __modImpl()
local b=a.c()
local d=b.New
local e=b.Tween
local f=a.e().New

local g={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=18,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={}
}

local function NormalizeButtonLayout(h)
if typeof(h)~="string"then
return"Auto"
end

local j=string.lower(h)
if j=="horizontal"then
return"Horizontal"
end
if j=="vertical"then
return"Vertical"
end

return"Auto"
end

local function ResolveHorizontalAlignment(h)
if typeof(h)~="string"then
return Enum.HorizontalAlignment.Right
end

local j=string.lower(h)
if j=="left"then
return Enum.HorizontalAlignment.Left
end
if j=="center"then
return Enum.HorizontalAlignment.Center
end

return Enum.HorizontalAlignment.Right
end

function g.Init(h)
local j={
Lower=false
}

function j.SetLower(l)
j.Lower=l
j.Frame.Size=l and g.SizeLower or g.Size
end

j.Frame=d("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=g.Size,
Parent=h,
BackgroundTransparency=1,




},{
d("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
d("UIPadding",{
PaddingBottom=UDim.new(0,29)
})
})
return j
end

function g.New(h)
h=typeof(h)=="table"and h or{}

local j={
Title=h.Title or"Notification",
Content=h.Content or nil,
Icon=h.Icon or nil,
IconThemed=h.IconThemed,
Background=h.Background,
BackgroundImageTransparency=h.BackgroundImageTransparency,
Duration=h.Duration==nil and 5 or h.Duration,
Buttons=h.Buttons or{},
CanClose=h.CanClose~=false,
ButtonLayout=NormalizeButtonLayout(h.ButtonLayout or h.ButtonsLayout),
ButtonAlignment=ResolveHorizontalAlignment(h.ButtonAlignment or h.ButtonsAlignment),
ButtonHeight=typeof(h.ButtonHeight)=="number"and math.max(28,h.ButtonHeight)or 40,
ButtonPadding=typeof(h.ButtonPadding)=="number"and math.max(0,h.ButtonPadding)or 6,
ButtonDebounce=h.ButtonDebounce~=false,
ButtonCooldown=typeof(h.ButtonCooldown)=="number"and math.max(0,h.ButtonCooldown)or 0.12,
UIElements={},
Closed=false,
}



g.NotificationIndex=g.NotificationIndex+1
j.Index=g.NotificationIndex
g.Notifications[j.Index]=j









local l

if j.Icon then





















l=b.Image(
j.Icon,
j.Title..":"..j.Icon,
0,
h.Window,
"Notification",
j.IconThemed
)
l.Size=UDim2.new(0,26,0,26)
l.Position=UDim2.new(0,g.UIPadding,0,g.UIPadding)

end

local m
if j.CanClose then
m=d("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-g.UIPadding,0,g.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.4,
},{
d("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local p=b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(0,0,1,0),
ThemeTag={
ImageTransparency="NotificationDurationTransparency",
ImageColor3="NotificationDuration",
},

})

local r=d("Frame",{
Size=UDim2.new(1,
j.Icon and-28-g.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
d("UIPadding",{
PaddingTop=UDim.new(0,g.UIPadding),
PaddingLeft=UDim.new(0,g.UIPadding),
PaddingRight=UDim.new(0,g.UIPadding),
PaddingBottom=UDim.new(0,g.UIPadding),
}),
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-g.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=18,
LayoutOrder=1,
ThemeTag={
TextColor3="NotificationTitle",
TextTransparency="NotificationTitleTransparency",
},
Text=j.Title,
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold)
}),
d("UIListLayout",{
Padding=UDim.new(0,g.UIPadding/3),
SortOrder="LayoutOrder",
})
})

if j.Content then
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,

TextSize=15,
LayoutOrder=2,
ThemeTag={
TextColor3="NotificationContent",
TextTransparency="NotificationContentTransparency",
},
Text=j.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
Parent=r
})
end

local u
local v
local x={}
if j.Buttons and#j.Buttons>0 then
local z={}
local A=0
local B=d("UIListLayout",{
Padding=UDim.new(0,j.ButtonPadding),
FillDirection="Horizontal",
HorizontalAlignment=j.ButtonAlignment,
VerticalAlignment="Center",
})

u=d("Frame",{
Size=UDim2.new(1,0,0,j.ButtonHeight),
BackgroundTransparency=1,
AutomaticSize="None",
LayoutOrder=3,
Parent=r,
},{
B,
})

local function CloseFromButton(C)
if typeof(C)=="number"and C>0 then
task.delay(C,function()
if not j.Closed then
j:Close()
end
end)
else
j:Close()
end
end

local function ApplyHorizontalLayout()
B.FillDirection=Enum.FillDirection.Horizontal
B.HorizontalAlignment=j.ButtonAlignment
B.VerticalAlignment=Enum.VerticalAlignment.Center
u.Size=UDim2.new(1,0,0,j.ButtonHeight)
u.AutomaticSize=Enum.AutomaticSize.None

for C,F in ipairs(z)do
local G=F.ButtonFrame
if F.Width then
G.Size=UDim2.new(0,F.Width,1,0)
G.AutomaticSize=Enum.AutomaticSize.None
else
G.Size=UDim2.new(0,0,1,0)
G.AutomaticSize=Enum.AutomaticSize.X
end
end
end

local function ApplyVerticalLayout()
B.FillDirection=Enum.FillDirection.Vertical
B.HorizontalAlignment=j.ButtonAlignment
B.VerticalAlignment=Enum.VerticalAlignment.Top
u.AutomaticSize=Enum.AutomaticSize.Y

for C,F in ipairs(z)do
local G=F.ButtonFrame
G.Size=UDim2.new(1,0,0,F.Height)
G.AutomaticSize=Enum.AutomaticSize.None
end
end

for C,F in next,j.Buttons do
if typeof(F)~="table"then
F={
Title=tostring(F),
}
end

local G={
Index=C,
Callback=F.Callback,
CloseOnClick=F.CloseOnClick~=false,
CloseDelay=typeof(F.CloseDelay)=="number"and math.max(0,F.CloseDelay)or 0,
CloseBeforeCallback=F.CloseBeforeCallback==true,
Debounce=F.Debounce==nil and j.ButtonDebounce or F.Debounce==true,
Cooldown=typeof(F.Cooldown)=="number"and math.max(0,F.Cooldown)or j.ButtonCooldown,
Disabled=F.Disabled==true,
Busy=false,
Width=typeof(F.Width)=="number"and math.max(0,F.Width)or nil,
Height=typeof(F.Height)=="number"and math.max(28,F.Height)or j.ButtonHeight,
Visible=F.Visible~=false,
RunAsync=(F.RunAsync==nil and F.Async==nil)or(F.RunAsync~=false and F.Async~=false),
}

local H

local function UpdateState()
local J=not j.Closed and G.Visible and not G.Disabled and not G.Busy
local L=G.ButtonFrame:FindFirstChild"Frame"
local M=G.ButtonFrame:FindFirstChild("TextLabel",true)

G.ButtonFrame.Active=J
G.ButtonFrame.Selectable=J
G.ButtonFrame.Visible=G.Visible

if L and L:IsA"ImageLabel"then
L.ImageTransparency=J and 1 or 0.92
end

if M and M:IsA"TextLabel"then
M.TextTransparency=J and 0 or 0.35
end
end

local function RunButton()
if j.Closed or G.Disabled or G.Busy or not G.Visible then
return
end

if G.Debounce then
G.Busy=true
UpdateState()
end

local function finish()
if not G.Debounce then
return
end

task.delay(G.Cooldown,function()
G.Busy=false
if G.ButtonFrame.Parent~=nil then
UpdateState()
end
end)
end

local function callbackFlow()
if G.CloseOnClick and G.CloseBeforeCallback then
CloseFromButton(G.CloseDelay)
end

b.SafeCallback(G.Callback,j,H,G.Index)

if G.CloseOnClick and not G.CloseBeforeCallback then
CloseFromButton(G.CloseDelay)
end

finish()
end

if G.RunAsync then
task.spawn(callbackFlow)
else
callbackFlow()
end
end

local J=f(
F.Title or F.Text,
F.Icon,
RunButton,
F.Variant,
u
)
J.Visible=G.Visible
J.LayoutOrder=typeof(F.LayoutOrder)=="number"and F.LayoutOrder or C

G.ButtonFrame=J

H={
Index=G.Index,
ButtonFrame=J,
Click=function()
RunButton()
end,
SetDisabled=function(L,M)
G.Disabled=M==true
UpdateState()
end,
SetVisible=function(L,M)
G.Visible=M~=false
UpdateState()
if v then
v()
end
end,
SetTitle=function(L,M)
local N=J:FindFirstChild("TextLabel",true)
if N and N:IsA"TextLabel"then
N.Text=tostring(M or"Button")
if v then
v()
end
end
end
}

UpdateState()
table.insert(x,H)
table.insert(z,G)

b.AddSignal(J:GetPropertyChangedSignal"AbsoluteSize",function()
if v then
v()
end
end)
end

v=function()
if j.Closed or u.Parent==nil then
return
end

A=A+1
local C=A

if j.ButtonLayout=="Vertical"then
ApplyVerticalLayout()
return
end

ApplyHorizontalLayout()
if j.ButtonLayout=="Horizontal"then
return
end

task.defer(function()
if C~=A then
return
end
if j.Closed or u.Parent==nil then
return
end

local F=B.AbsoluteContentSize.X
local G=u.AbsoluteSize.X
if F>G then
ApplyVerticalLayout()
end
end)
end
end


local z=b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
ImageTransparency=.05,
ThemeTag={
ImageColor3="Notification"
},

},{
b.NewRoundFrame(g.UICorner,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="NotificationBorder",
ImageTransparency="NotificationBorderTransparency",
},
}),
d("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="DurationFrame",
},{
d("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ClipsDescendants=true,
},{
p,
}),





}),
d("ImageLabel",{
Name="Background",
Image=j.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=j.BackgroundImageTransparency

},{
d("UICorner",{
CornerRadius=UDim.new(0,g.UICorner),
})
}),

r,
l,m,
})

local A=d("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=h.Holder
},{
z
})

j.UIElements.Main=z
j.UIElements.MainContainer=A
j.UIElements.TextContainer=r
j.UIElements.ButtonsContainer=u
j.UIElements.Buttons=x
j.UIElements.CloseButton=m
j.UIElements.Duration=p
j.UIElements.Icon=l

if v and u then
b.AddSignal(u:GetPropertyChangedSignal"AbsoluteSize",v)
b.AddSignal(r:GetPropertyChangedSignal"AbsoluteSize",v)
local B=u:FindFirstChildOfClass"UIListLayout"
if B then
b.AddSignal(B:GetPropertyChangedSignal"AbsoluteContentSize",v)
end
task.defer(v)
end

function j.Close(B)
if not j.Closed then
j.Closed=true
g.Notifications[j.Index]=nil

for C,F in ipairs(x)do
if F.SetDisabled then
F:SetDisabled(true)
end
end

e(A,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(z,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
if A.Parent~=nil then
A:Destroy()
end
end
end

task.spawn(function()
task.wait()
if j.Closed or A.Parent==nil then
return
end
e(A,0.45,{Size=UDim2.new(
1,
0,
0,
z.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(z,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if j.Duration and not j.Closed then
p.Size=UDim2.new(0,z.DurationFrame.AbsoluteSize.X,1,0)
e(z.DurationFrame.Frame,j.Duration,{Size=UDim2.new(0,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(j.Duration)
if not j.Closed then
j:Close()
end
end
end)

if m then
b.AddSignal(m.MouseButton1Click,function()
j:Close()
end)
if m:FindFirstChild"TextButton"then
b.AddSignal(m.TextButton.MouseButton1Click,function()
j:Close()
end)
end
end


return j
end

return g end function a.f():typeof(__modImpl())local b=a.cache.f if not b then b={c=__modImpl()}a.cache.f=b end return b.c end end do local function __modImpl()












local b=4294967296;local d=b-1;local function c(e,f)local g,h=0,1;while e~=0 or f~=0 do local j,l=e%2,f%2;local m=(j+l)%2;g=g+m*h;e=math.floor(e/2)f=math.floor(f/2)h=h*2 end;return g%b end;local function k(e,f,g,...)local h;if f then e=e%b;f=f%b;h=c(e,f)if g then h=k(h,g,...)end;return h elseif e then return e%b else return 0 end end;local function n(e,f,g,...)local h;if f then e=e%b;f=f%b;h=(e+f-c(e,f))/2;if g then h=n(h,g,...)end;return h elseif e then return e%b else return d end end;local function o(e)return d-e end;local function q(e,f)if f<0 then return lshift(e,-f)end;return math.floor(e%4294967296/2^f)end;local function s(e,f)if f>31 or f<-31 then return 0 end;return q(e%b,f)end;local function lshift(e,f)if f<0 then return s(e,-f)end;return e*2^f%4294967296 end;local function t(e,f)e=e%b;f=f%32;local g=n(e,2^f-1)return s(e,f)+lshift(g,32-f)end;local e={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(f)return string.gsub(f,".",function(g)return string.format("%02x",string.byte(g))end)end;local function y(f,g)local h=""for j=1,g do local l=f%256;h=string.char(l)..h;f=(f-l)/256 end;return h end;local function D(f,g)local h=0;for j=g,g+3 do h=h*256+string.byte(f,j)end;return h end;local function E(f,g)local h=64-(g+9)%64;g=y(8*g,8)f=f.."\128"..string.rep("\0",h)..g;assert(#f%64==0)return f end;local function I(f)f[1]=0x6a09e667;f[2]=0xbb67ae85;f[3]=0x3c6ef372;f[4]=0xa54ff53a;f[5]=0x510e527f;f[6]=0x9b05688c;f[7]=0x1f83d9ab;f[8]=0x5be0cd19;return f end;local function K(f,g,h)local j={}for l=1,16 do j[l]=D(f,g+(l-1)*4)end;for l=17,64 do local m=j[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=j[l-2]j[l]=(j[l-16]+p+j[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+e[A]+j[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;h[1]=(h[1]+l)%b;h[2]=(h[2]+m)%b;h[3]=(h[3]+p)%b;h[4]=(h[4]+r)%b;h[5]=(h[5]+u)%b;h[6]=(h[6]+v)%b;h[7]=(h[7]+x)%b;h[8]=(h[8]+z)%b end;local function Z(f)f=E(f,#f)local g=I{}for h=1,#f,64 do K(f,h,g)end;return w(y(g[1],4)..y(g[2],4)..y(g[3],4)..y(g[4],4)..y(g[5],4)..y(g[6],4)..y(g[7],4)..y(g[8],4))end;local f;local g={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local h={["/"]="/"}for j,l in pairs(g)do h[l]=j end;local j=function(j)return"\\"..(g[j]or string.format("u%04x",j:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,f(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,f(u,p)..":"..f(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',j)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}f=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return f(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..h[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}

local Y=(cloneref or clonereference or function(Y)return Y end)


function X.New(_,aa)

local ab=_;
local ac=aa;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return Y(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=U{
service=ab,
identifier=W(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=V(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(ab);

local ay={
identifier=W(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=U(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(ab).."?identifier="..W(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(ab).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=V(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==W(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return X end function a.g():typeof(__modImpl())local aa=a.cache.g if not aa then aa={c=__modImpl()}a.cache.g=aa end return aa.c end end do local function __modImpl()









local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"HttpService")
local ac={}



function ac.New(ad)
local ae=gethwid or function()return aa(game:GetService"Players").LocalPlayer.UserId end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://pandadevelopment.net/v2_validation?key="..tostring(ah).."&service="..tostring(ad).."&hwid="..tostring(ae())


local aj,ak=pcall(function()
return af{
Url=ai,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"}
}
end)

if aj and ak then
if ak.Success then
local al,am=pcall(function()
return ab:JSONDecode(ak.Body)
end)

if al and am then
if am.V2_Authentication and am.V2_Authentication=="success"then

return true,"Authenticated"
else
local an=am.Key_Information.Notes or"Unknown reason"

return false,"Authentication failed: "..an
end
else

return false,"JSON decode error"
end
else
warn("[Pelinda Ov2.5] HTTP request was not successful. Code: "..tostring(ak.StatusCode).." Message: "..ak.StatusMessage)
return false,"HTTP request failed: "..ak.StatusMessage
end
else

return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://pandadevelopment.net/getkey?service="..tostring(ad).."&hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end

return ac end function a.h():typeof(__modImpl())local aa=a.cache.h if not aa then aa={c=__modImpl()}a.cache.h=aa end return aa.c end end do local function __modImpl()








local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.i():typeof(__modImpl())local aa=a.cache.i if not aa then aa={c=__modImpl()}a.cache.i=aa end return aa.c end end do local function __modImpl()








local aa={}

function aa.New(ab,ac,ad)
JunkieProtected.API_KEY=ac
JunkieProtected.PROVIDER=ad
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(ae)
if not ae or ae==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local af=JunkieProtected.IsKeylessMode()
if af and af.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ag=JunkieProtected.ValidateKey{Key=ae}
if ag=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ah=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ah
end
end

local function copyLink()
local ae=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(ae)
end
end
return{
Verify=ValidateKey,
Copy=copyLink
}
end

return aa end function a.j():typeof(__modImpl())local aa=a.cache.j if not aa then aa={c=__modImpl()}a.cache.j=aa end return aa.c end end do local function __modImpl()



return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},

New=a.g().New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},

New=a.h().New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},

New=a.i().New
},
junkiedevelopment={
Name="Junkie Development",
Icon="rbxassetid://106310347705078",
Args={"ServiceId","ApiKey","Provider"},

New=a.j().New
},


}end function a.k():typeof(__modImpl())local aa=a.cache.k if not aa then aa={c=__modImpl()}a.cache.k=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"Glass-1",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.75,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.l():typeof(__modImpl())local aa=a.cache.l if not aa then aa={c=__modImpl()}a.cache.l=aa end return aa.c end end do local function __modImpl()
local aa=a.c()
local ab=aa.New
local ac=aa.Tween

local ad

local ae={
Holder=nil,

Parent=nil,
}

function ae.Init(af,ag)
ad=af
ae.Parent=ag
return ae
end

function ae.Create(af,ag)
local ah={
UICorner=28,
UIPadding=12,
UIElements={}
}

if af then ah.UIPadding=0 end
if af then ah.UICorner=26 end

ag=ag or"Dialog"

if not af then
ah.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ae.Parent or(ad and ad.UIElements and ad.UIElements.Main and ad.UIElements.Main.Main)
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ad.UICorner)
})
})
end

ah.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=ag.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ah.UIPadding),
PaddingLeft=UDim.new(0,ah.UIPadding),
PaddingRight=UDim.new(0,ah.UIPadding),
PaddingBottom=UDim.new(0,ah.UIPadding),
})
})

ah.UIElements.MainContainer=aa.NewRoundFrame(ah.UICorner,"Squircle",{
Visible=false,

ImageTransparency=af and 0.15 or 0,
Parent=af and ae.Parent or ah.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=ag.."Background",
ImageTransparency=ag.."BackgroundTransparency",
},
ZIndex=9999,
},{





ah.UIElements.Main,



















})

function ah.Open(ai)
if not af then
ah.UIElements.FullScreen.Visible=true
ah.UIElements.FullScreen.Active=true
end

task.spawn(function()
ah.UIElements.MainContainer.Visible=true

if not af then
ac(ah.UIElements.FullScreen,0.1,{BackgroundTransparency=.3}):Play()
end
ac(ah.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ah.UIElements.Main.Visible=true
end)
end)
end
function ah.Close(ai)
if not af then
ac(ah.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ah.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(.1)
ah.UIElements.FullScreen.Visible=false
end)
end
ah.UIElements.Main.Visible=false

ac(ah.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(.1)
if not af then
ah.UIElements.FullScreen:Destroy()
else
ah.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ah
end

return ae end function a.m():typeof(__modImpl())local aa=a.cache.m if not aa then aa={c=__modImpl()}a.cache.m=aa end return aa.c end end do local function __modImpl()

local aa={}


local ab=a.c()
local ac=ab.New
local ad=ab.Tween

local ae=a.e().New
local af=a.l().New
local ag=setclipboard or toclipboard

function aa.new(ah,ai,aj,ak)
local al=a.m().Init(nil,ah.WindUI.ScreenGui.KeySystem)
local am=al.Create(true)

local an={}

local ao

local ap=(ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Width)or 200

local aq=430
if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
aq=430+(ap/2)
end

am.UIElements.Main.AutomaticSize="Y"
am.UIElements.Main.Size=UDim2.new(0,aq,0,0)

local ar

if ah.Icon then

ar=ab.Image(
ah.Icon,
ah.Title..":"..ah.Icon,
0,
"Temp",
"KeySystem",
ah.IconThemed
)
ar.Size=UDim2.new(0,24,0,24)
ar.LayoutOrder=-1
end

local as=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ah.KeySystem.Title or ah.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})

local at=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16
})

local au=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ar,as
})

local av=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





au,at,
})

local aw=af("Enter Key","key",nil,"Input",function(aw)
ao=aw
end)

local ax
if ah.KeySystem.Note and ah.KeySystem.Note~=""then
ax=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ah.KeySystem.Note,
TextSize=18,
TextTransparency=.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ay=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
})
})
})


local az
if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
local aA
if ah.KeySystem.Thumbnail.Title then
aA=ac("TextLabel",{
Text=ah.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
az=ac("ImageLabel",{
Image=ah.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ap,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=am.UIElements.Main,
ScaleType="Crop"
},{
aA,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
})
})
end

ac("Frame",{

Size=UDim2.new(1,az and-ap or 0,1,0),
Position=UDim2.new(0,az and ap or 0,0,0),
BackgroundTransparency=1,
Parent=am.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
av,
ax,
aw,
ay,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})





local aA=ae("Exit","log-out",function()
am:Close()()
end,"Tertiary",ay.Frame)

if az then
aA.Parent=az
aA.Size=UDim2.new(0,0,0,42)
aA.Position=UDim2.new(0,10,1,-10)
aA.AnchorPoint=Vector2.new(0,1)
end

if ah.KeySystem.URL then
ae("Get key","key",function()
if ag then
ag(ah.KeySystem.URL)
else
ah.WindUI:Notify{
Title="Key System. Error",
Content="Clipboard API is not available in this executor.",
Icon="triangle-alert",
}
end
end,"Secondary",ay.Frame)
end

if ah.KeySystem.API then








local aB=240
local b=false
local d=ae("Get key","key",nil,"Secondary",ay.Frame)

local f=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=d.Frame,
},{
f,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
})
})

local g=ab.Image(
"chevron-down",
"chevron-down",
0,
"Temp",
"KeySystem",
true
)

g.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=d.Frame,
BackgroundTransparency=1,
},{
g
})

local h=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
})
})

local j=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aB,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=d,
Position=UDim2.new(1,0,1,15)
},{
h
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=h,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
})
})

for l,m in next,ah.KeySystem.API do
local p=ah.WindUI.Services[m.Type]
if p then
local r={}
for u,v in next,p.Args do
table.insert(r,m[v])
end

local u=p.New(table.unpack(r))
u.Type=m.Type
table.insert(an,u)

local v=m.Icon or p.Icon or"user"
local x=ab.Image(
v,
v,
0,
"Temp",
"KeySystem",
true
)
x.Size=UDim2.new(0,24,0,24)

local z=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=h,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
x,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=m.Title or p.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=m.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=m.Desc and true or false,
TextXAlignment="Left",
})
})
},true)

ab.AddSignal(z.MouseEnter,function()
ad(z,0.08,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(z.InputEnded,function()
ad(z,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(z.MouseButton1Click,function()
u.Copy()
ah.WindUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(d.MouseButton1Click,function()
if not b then
ad(j,.3,{Size=UDim2.new(0,aB,0,h.AbsoluteSize.Y+1)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(g,.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(j,.25,{Size=UDim2.new(0,aB,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(g,.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
b=not b
end)

end

local function handleSuccess(aB)
am:Close()()
writefile((ah.Folder or"Temp").."/"..ai..".key",tostring(aB))
task.wait(.4)
aj(true)
end

local aB=ae("Submit","arrow-right",function()
local aB=tostring(ao or"empty")

if ah.KeySystem.KeyValidator then
local b=ah.KeySystem.KeyValidator(aB)

if b then
if ah.KeySystem.SaveKey then
handleSuccess(aB)
else
am:Close()()
task.wait(.4)
aj(true)
end
else
ah.WindUI:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ah.KeySystem.API then
local b=type(ah.KeySystem.Key)=="table"
and table.find(ah.KeySystem.Key,aB)
or ah.KeySystem.Key==aB

if b then
if ah.KeySystem.SaveKey then
handleSuccess(aB)
else
am:Close()()
task.wait(.4)
aj(true)
end
end
else
local b,d
for f,g in next,an do
local h,j=g.Verify(aB)
if h then
b,d=true,j
break
end
d=j
end

if b then
handleSuccess(aB)
else
ah.WindUI:Notify{
Title="Key System. Error",
Content=d,
Icon="triangle-alert",
}
end
end
end,"Primary",ay)

aB.AnchorPoint=Vector2.new(1,0.5)
aB.Position=UDim2.new(1,0,0.5,0)










am:Open()
end

return aa end function a.n():typeof(__modImpl())local aa=a.cache.n if not aa then aa={c=__modImpl()}a.cache.n=aa end return aa.c end end do local function __modImpl()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.o():typeof(__modImpl())local aa=a.cache.o if not aa then aa={c=__modImpl()}a.cache.o=aa end return aa.c end end do local function __modImpl()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.c()
local ac=ab.New


local ad,ae=unpack(a.o())
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()
ah.SetVisibility(al.Visible)
end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.p():typeof(__modImpl())local aa=a.cache.p if not aa then aa={c=__modImpl()}a.cache.p=aa end return aa.c end end do local function __modImpl()



local aa=a.c()
local ab=a.p()

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.q():typeof(__modImpl())local aa=a.cache.q if not aa then aa={c=__modImpl()}a.cache.q=aa end return aa.c end end do local function __modImpl()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.p(),

AcrylicPaint=a.q(),
}

function ab.init()
local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end
ac.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.r():typeof(__modImpl())local aa=a.cache.r if not aa then aa={c=__modImpl()}a.cache.r=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New local ad=
ab.Tween


function aa.new(ae)
local af={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ag=a.m().Init(nil,ae.WindUI.ScreenGui.Popups)
local ah=ag.Create(true,"Popup")

local ai=200

local aj=430
if af.Thumbnail and af.Thumbnail.Image then
aj=430+(ai/2)
end

ah.UIElements.Main.AutomaticSize="Y"
ah.UIElements.Main.Size=UDim2.new(0,aj,0,0)



local ak

if af.Icon then
ak=ab.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.WindUI.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
ak.Size=UDim2.new(0,af.IconSize,0,af.IconSize)
ak.LayoutOrder=-1
end


local al=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=af.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,ak and-af.IconSize-14 or 0,0,0)
})

local am=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ak,al
})

local an=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





am,
})

local ao
if af.Content and af.Content~=""then
ao=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=af.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ap=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local aq
if af.Thumbnail and af.Thumbnail.Image then
local ar
if af.Thumbnail.Title then
ar=ac("TextLabel",{
Text=af.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aq=ac("ImageLabel",{
Image=af.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ai,1,0),
Parent=ah.UIElements.Main,
ScaleType="Crop"
},{
ar,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,aq and-ai or 0,1,0),
Position=UDim2.new(0,aq and ai or 0,0,0),
BackgroundTransparency=1,
Parent=ah.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
an,
ao,
ap,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local ar=a.e().New

for as,at in next,af.Buttons do
ar(at.Title,at.Icon,at.Callback,at.Variant,ap,ah)
end

ah:Open()


return af
end

return aa end function a.s():typeof(__modImpl())local aa=a.cache.s if not aa then aa={c=__modImpl()}a.cache.s=aa end return aa.c end end do local function __modImpl()
return function(aa)
return{
Dark={
Name="Dark",

Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#161616",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#101010",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#a1a1aa",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,

SliderIcon=Color3.fromHex"#908F95",
Primary=Color3.fromHex"#0091FF",
},

Light={
Name="Light",

Accent=Color3.fromHex"#FFFFFF",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#09090b",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#e9e9e9",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

TabBackground=Color3.fromHex"#ffffff",
TabBackgroundHover=Color3.fromHex"#ffffff",
TabBackgroundHoverTransparency=0.5,
TabBackgroundActive=Color3.fromHex"#ffffff",
TabBackgroundActiveTransparency=0,

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0,

LabelBackground=Color3.fromHex"#ffffff",
LabelBackgroundTransparency=0,
},

Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",
Outline=Color3.fromHex"#fecdd3",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e95f74",
Icon=Color3.fromHex"#fb7185",
},

Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",
Outline=Color3.fromHex"#bbf7d0",
Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",
},

Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fecaca",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",
},

Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",
Outline=Color3.fromHex"#c7d2fe",
Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",
},

Sky={
Name="Sky",

Accent=Color3.fromHex"#00d4ff",
Dialog=Color3.fromHex"#0a4d66",
Outline=Color3.fromHex"#4dd9ff",
Text=Color3.fromHex"#e6f7ff",
Placeholder=Color3.fromHex"#66b3cc",
Background=Color3.fromHex"#051a26",
Button=Color3.fromHex"#00a8cc",
Icon=Color3.fromHex"#2db8d9",

Toggle=Color3.fromHex"#00d9d9",
Slider=Color3.fromHex"#00d4ff",
Checkbox=Color3.fromHex"#00d4ff",

PanelBackground=Color3.fromHex"#0d3a47",
PanelBackgroundTransparency=0.8,
},

Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",
Outline=Color3.fromHex"#ddd6fe",
Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",
},

Amber={
Name="Amber",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#b45309",Transparency=0},
["100"]={Color=Color3.fromHex"#d97706",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#451a03",Transparency=0},
["100"]={Color=Color3.fromHex"#6b2e05",Transparency=0},
},{Rotation=90}),

Outline=aa:Gradient({
["0"]={Color=Color3.fromHex"#fde68a",Transparency=0},
["100"]={Color=Color3.fromHex"#fcd34d",Transparency=0},
},{Rotation=45}),

Text=aa:Gradient({
["0"]={Color=Color3.fromHex"#fffbeb",Transparency=0},
["100"]={Color=Color3.fromHex"#fff7ed",Transparency=0},
},{Rotation=45}),

Placeholder=aa:Gradient({
["0"]={Color=Color3.fromHex"#d1a326",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#1c1003",Transparency=0},
["100"]={Color=Color3.fromHex"#3f210d",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Icon=Color3.fromHex"#f59e0b",

Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Slider=Color3.fromHex"#d97706",

Checkbox=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,
},

Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",
Outline=Color3.fromHex"#a7f3d0",
Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",
},

Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",
Outline=Color3.fromHex"#bfdbfe",
Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Primary=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#5591f4",
},

Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fca5a5",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",
},

MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",
Outline=Color3.fromHex"#78dce8",
Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#6f6f6f",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",

Metadata={
PullRequest=23,
}
},

CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",
Outline=Color3.fromHex"#f9a8d4",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Slider=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",
},

Mellowsi={
Name="Mellowsi",

Accent=Color3.fromHex"#342A1E",
Dialog=Color3.fromHex"#291C13",
Outline=Color3.fromHex"#6B5A45",
Text=Color3.fromHex"#F5EBDD",
Placeholder=Color3.fromHex"#9C8A73",
Background=Color3.fromHex"#1C1002",
Button=Color3.fromHex"#342A1E",
Icon=Color3.fromHex"#C9B79C",

Toggle=Color3.fromHex"#a9873f",
Slider=Color3.fromHex"#C9A24D",
Checkbox=Color3.fromHex"#C9A24D",

Metadata={
PullRequest=52,
}
},

Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{Rotation=135}),

Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#ffffff",
Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0040",Transparency=0},
["20"]={Color=Color3.fromHex"#ff4000",Transparency=0},
["40"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["60"]={Color=Color3.fromHex"#00ff40",Transparency=0},
["80"]={Color=Color3.fromHex"#0040ff",Transparency=0},
["100"]={Color=Color3.fromHex"#4000ff",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#ff8000",Transparency=0},
["50"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["75"]={Color=Color3.fromHex"#80ff00",Transparency=0},
["100"]={Color=Color3.fromHex"#00ffff",Transparency=0},
},{Rotation=60}),

Icon=Color3.fromHex"#ffffff",
},
}
end end function a.t():typeof(__modImpl())local aa=a.cache.t if not aa then aa={c=__modImpl()}a.cache.t=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai)
local aj=ai or 10
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local al=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ak and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local am=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(aj,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(aj,"Glass-1.4",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.75,
},{













}),
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak,
al,
})
})
})

return am
end


return aa end function a.u():typeof(__modImpl())local aa=a.cache.u if not aa then aa={c=__modImpl()}a.cache.u=aa end return aa.c end end do local function __modImpl()
local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ac=ab(game:GetService"UserInputService")

local ad=a.c()
local ae=ad.New local af=
ad.Tween


function aa.New(ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=false
local ao=0

local function updateSliderSize()
local ap=ag
local aq=ap.AbsoluteCanvasSize.Y
local ar=ap.AbsoluteWindowSize.Y

if aq<=ar then
al.Visible=false
return
end

local as=math.clamp(ar/aq,0.1,1)
al.Size=UDim2.new(1,0,as,0)
al.Visible=true
end

local function updateScrollingFramePosition()
local ap=al.Position.Y.Scale
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then return end

local at=math.max(1-al.Size.Y.Scale,0)
if at<=0 then return end

local au=ap/at

ag.CanvasPosition=Vector2.new(
ag.CanvasPosition.X,
au*as
)
end

local function updateThumbPosition()
if an then return end

local ap=ag.CanvasPosition.Y
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then
al.Position=UDim2.new(0,0,0,0)
return
end

local at=ap/as
local au=math.max(1-al.Size.Y.Scale,0)
local av=math.clamp(at*au,0,au)

al.Position=UDim2.new(0,0,av,0)
end

ad.AddSignal(ak.InputBegan,function(ap)
if(ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch)then
local aq=al.AbsolutePosition.Y
local ar=aq+al.AbsoluteSize.Y

if not(ap.Position.Y>=aq and ap.Position.Y<=ar)then
local as=ak.AbsolutePosition.Y
local at=ak.AbsoluteSize.Y
local au=al.AbsoluteSize.Y

local av=ap.Position.Y-as-au/2
local aw=at-au

local ax=math.clamp(av/aw,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end
end)

ad.AddSignal(am.InputBegan,function(ap)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
an=true
ao=ap.Position.Y-al.AbsolutePosition.Y

local aq
local ar

aq=ac.InputChanged:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseMovement or as.UserInputType==Enum.UserInputType.Touch then
local at=ak.AbsolutePosition.Y
local au=ak.AbsoluteSize.Y
local av=al.AbsoluteSize.Y

local aw=as.Position.Y-at-ao
local ax=au-av

local ay=math.clamp(aw/ax,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end)

ar=ac.InputEnded:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
an=false
if aq then aq:Disconnect()end
if ar then ar:Disconnect()end
end
end)
end
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",function()
if not an then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return ak
end


return aa end function a.v():typeof(__modImpl())local aa=a.cache.v if not aa then aa={c=__modImpl()}a.cache.v=aa end return aa.c end end do local function __modImpl()
local aa=a.c()
local ab=aa.New

local ac={}

local function toNumber(ad,ae,af,ag)
local ah=typeof(ad)=="number"and ad or ae

if af~=nil then
ah=math.max(af,ah)
end
if ag~=nil then
ah=math.min(ag,ah)
end

return ah
end

local function normalizeAlignment(ad)
if ad=="Left"or ad=="Right"then
return ad
end

return"Center"
end

local function createLineProps(ad)
local ae={
ThemeTag={
BackgroundColor3=typeof(ad.Color)=="string"and ad.Color or"Divider",
BackgroundTransparency="DividerTransparency",
}
}

if typeof(ad.Color)=="Color3"then
ae.BackgroundColor3=ad.Color
ae.ThemeTag.BackgroundColor3=nil
end

if typeof(ad.Transparency)=="number"then
ae.BackgroundTransparency=math.clamp(ad.Transparency,0,1)
ae.ThemeTag.BackgroundTransparency=nil
end

if next(ae.ThemeTag)==nil then
ae.ThemeTag=nil
end

return ae
end

local function createTitleProps(ad)
local ae={
ThemeTag={
TextColor3=typeof(ad.TitleColor)=="string"and ad.TitleColor or"DividerLabel",
TextTransparency="DividerLabelTransparency",
}
}

if typeof(ad.TitleColor)=="Color3"then
ae.TextColor3=ad.TitleColor
ae.ThemeTag.TextColor3=nil
end

if typeof(ad.TitleTransparency)=="number"then
ae.TextTransparency=math.clamp(ad.TitleTransparency,0,1)
ae.ThemeTag.TextTransparency=nil
end

if next(ae.ThemeTag)==nil then
ae.ThemeTag=nil
end

return ae
end

function ac.New(ad,ae)
local af=ae.Orientation
if af~="Horizontal"and af~="Vertical"then
af=ae.ParentType=="Group"and"Vertical"or"Horizontal"
end

local ag=ae.Title or ae.Text or""
local ah=af=="Horizontal"and ag~=""

local ai=toNumber(ae.Thickness,1,1)
local aj=toNumber(ae.Inset,7,0)
local ak=toNumber(ae.TitleSpacing,8,0)
local al=normalizeAlignment(ae.TitleAlignment)

local am=toNumber(ae.Height,ah and 18 or 7,2)
local an=toNumber(ae.Width,math.max(7,ai+6),1)
local ao=createLineProps(ae)
local ap=createTitleProps(ae)

local aq
if af=="Vertical"then
aq=UDim2.new(0,an,1,-aj)
else
aq=UDim2.new(1,-aj,0,am)
end

local ar=ab("Frame",{
Parent=ae.Parent,
Size=ae.Size or aq,
BackgroundTransparency=1,
Name="Divider",
},{
ab("Frame",{
Name="Line",
Size=af=="Horizontal"and UDim2.new(1,0,0,ai)or UDim2.new(0,ai,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=ao.BackgroundTransparency or 0.9,
BackgroundColor3=ao.BackgroundColor3,
ThemeTag=ao.ThemeTag,
}),
af=="Horizontal"and ab("TextLabel",{
Name="Title",
AutomaticSize="X",
Size=UDim2.new(0,0,0,16),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Text=ag,
TextSize=toNumber(ae.TitleSize,13,8),
BackgroundTransparency=1,
Visible=ah,
TextColor3=ap.TextColor3,
TextTransparency=ap.TextTransparency,
ThemeTag=ap.ThemeTag,
})or nil,
af=="Horizontal"and ab("Frame",{
Name="LeftLine",
Size=UDim2.new(0,0,0,ai),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=ao.BackgroundTransparency or 0.9,
BackgroundColor3=ao.BackgroundColor3,
Visible=false,
ThemeTag=ao.ThemeTag,
})or nil,
af=="Horizontal"and ab("Frame",{
Name="RightLine",
Size=UDim2.new(0,0,0,ai),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=ao.BackgroundTransparency or 0.9,
BackgroundColor3=ao.BackgroundColor3,
Visible=false,
ThemeTag=ao.ThemeTag,
})or nil,
})

local as=ar:FindFirstChild"Line"
local at=ar:FindFirstChild"LeftLine"
local au=ar:FindFirstChild"RightLine"
local av=ar:FindFirstChild"Title"

local aw={
__type="Divider",
ElementFrame=ar,
Title=ag,
Orientation=af,
Thickness=ai,
TitleAlignment=al,
TitleSpacing=ak,
AutoHeight=ae.Height==nil and ae.Size==nil and af=="Horizontal",
}

local function updateHorizontalLayout()
if af~="Horizontal"then
return
end

local ax=aw.Title~=""
local ay=math.max(1,math.floor(aw.Thickness))

as.Size=UDim2.new(1,0,0,ay)
as.Position=UDim2.new(0.5,0,0.5,0)

if aw.AutoHeight then
ar.Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,ar.Size.Y.Scale,ax and 18 or 7)
end

if not ax then
as.Visible=true
if av then
av.Visible=false
end
if at then
at.Visible=false
end
if au then
au.Visible=false
end
return
end

as.Visible=false
av.Visible=true

local az=ar.AbsoluteSize.X
local aA=av.AbsoluteSize.X
local aB=aw.TitleSpacing

if aw.TitleAlignment=="Left"then
av.AnchorPoint=Vector2.new(0,0.5)
av.Position=UDim2.new(0,0,0.5,0)

at.Visible=false

local b=math.floor(aA+aB)
local d=math.max(0,az-b)

au.AnchorPoint=Vector2.new(0,0.5)
au.Position=UDim2.new(0,b,0.5,0)
au.Size=UDim2.new(0,d,0,ay)
au.Visible=d>0
return
end

if aw.TitleAlignment=="Right"then
av.AnchorPoint=Vector2.new(1,0.5)
av.Position=UDim2.new(1,0,0.5,0)

au.Visible=false

local b=math.max(0,az-(aA+aB))

at.AnchorPoint=Vector2.new(0,0.5)
at.Position=UDim2.new(0,0,0.5,0)
at.Size=UDim2.new(0,b,0,ay)
at.Visible=b>0
return
end

av.AnchorPoint=Vector2.new(0.5,0.5)
av.Position=UDim2.new(0.5,0,0.5,0)

local b=math.max(0,math.floor((az-(aA+(aB*2)))/2))

at.AnchorPoint=Vector2.new(0,0.5)
at.Position=UDim2.new(0,0,0.5,0)
at.Size=UDim2.new(0,b,0,ay)
at.Visible=b>0

au.AnchorPoint=Vector2.new(1,0.5)
au.Position=UDim2.new(1,0,0.5,0)
au.Size=UDim2.new(0,b,0,ay)
au.Visible=b>0
end

if af=="Horizontal"then
aa.AddSignal(ar:GetPropertyChangedSignal"AbsoluteSize",updateHorizontalLayout)
aa.AddSignal(av:GetPropertyChangedSignal"AbsoluteSize",updateHorizontalLayout)
else
as.Size=UDim2.new(0,aw.Thickness,1,0)
end

function aw.SetTitle(ax,ay)
aw.Title=ay and tostring(ay)or""
if av then
av.Text=aw.Title
end
updateHorizontalLayout()
end

function aw.SetThickness(ax,ay)
aw.Thickness=toNumber(ay,aw.Thickness,1)

if af=="Vertical"then
as.Size=UDim2.new(0,aw.Thickness,1,0)
return
end

updateHorizontalLayout()
end

function aw.SetTitleAlignment(ax,ay)
aw.TitleAlignment=normalizeAlignment(ay)
updateHorizontalLayout()
end

function aw.SetTitleSpacing(ax,ay)
aw.TitleSpacing=toNumber(ay,aw.TitleSpacing,0)
updateHorizontalLayout()
end

task.defer(updateHorizontalLayout)

return aw.__type,aw
end

return ac end function a.w():typeof(__modImpl())local aa=a.cache.w if not aa then aa={c=__modImpl()}a.cache.w=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ab=aa.New

local ac={}

function ac.New(ad,ae)
local af=ab("Frame",{
Parent=ae.Parent,
Size=ae.ParentType~="Group"and UDim2.new(1,-7,0,7*(ae.Columns or 1))or UDim2.new(0,7*(ae.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=af}
end

return ac end function a.x():typeof(__modImpl())local aa=a.cache.x if not aa then aa={c=__modImpl()}a.cache.x=aa end return aa.c end end do local function __modImpl()
local aa={}


local ab=a.c()
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,
Border=af.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(
ah.Icon,
ah.Icon,
0,
af.Window,
"Tag",
false
)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or nil
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or nil,
})

local ak

if typeof(ah.Color)=="table"then

ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
end



local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color or Color3.new(1,1,1),
},{
ak,
ab.NewRoundFrame(ah.Radius,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=.75
}),
ac("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
ai,
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5)
})
}),
})


function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an

return ah
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=ab.GetAverageColor(an)
ad(aj,.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do ap[aq]=ar end
ad(al,.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,.06,{TextColor3=ab.GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,.06,{ImageColor3=ab.GetTextColorForHSB(an)}):Play()
end
ad(al,.06,{ImageColor3=an}):Play()
end

return ah
end

function ah.SetIcon(am,an)
ah.Icon=an

if an then
ai=ab.Image(
an,
an,
0,
af.Window,
"Tag",
false
)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.Parent=al

if typeof(ah.Color)=="Color3"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ah.Color)
elseif typeof(ah.Color)=="table"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
else
if ai then
ai:Destroy()
ai=nil
end
end
return ah
end

function ah.Destroy(am)
al:Destroy()
return ah
end

return ah
end


return aa end function a.y():typeof(__modImpl())local aa=a.cache.y if not aa then aa={c=__modImpl()}a.cache.y=aa end return aa.c end end do local function __modImpl()
local aa={}

local ab=a.c()
local ac=ab.New
local ad=ab.Tween

local function normalizePosition(ae)
local af=tostring(ae or"bottom-right"):lower()
af=af:gsub("_","-"):gsub("%s+","-")
af=af:gsub("[^%w%-]","")

local ag={
tl="top-left",
topleft="top-left",
tr="top-right",
topright="top-right",
bl="bottom-left",
bottomleft="bottom-left",
br="bottom-right",
bottomright="bottom-right",
c="center",
middle="center",
top="top-center",
bottom="bottom-center",
left="center-left",
right="center-right",
}

return ag[af]or af
end

local function getPresetPosition(ae,af,ag)
local ah={
["top-left"]={Anchor=Vector2.new(0,0),Position=UDim2.new(0,af,0,af)},
["top-center"]={Anchor=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,af)},
["top-right"]={Anchor=Vector2.new(1,0),Position=UDim2.new(1,-af,0,af)},
["center-left"]={Anchor=Vector2.new(0,0.5),Position=UDim2.new(0,af,0.5,0)},center=
{Anchor=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0)},
["center-right"]={Anchor=Vector2.new(1,0.5),Position=UDim2.new(1,-af,0.5,0)},
["bottom-left"]={Anchor=Vector2.new(0,1),Position=UDim2.new(0,af,1,-af)},
["bottom-center"]={Anchor=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-af)},
["bottom-right"]={Anchor=Vector2.new(1,1),Position=UDim2.new(1,-af,1,-af)},
}

local ai=normalizePosition(ae)
local aj=ah[ai]or ah["bottom-right"]

return aj.Anchor,UDim2.new(
aj.Position.X.Scale,
aj.Position.X.Offset+ag.X,
aj.Position.Y.Scale,
aj.Position.Y.Offset+ag.Y
)
end

function aa.New(ae,af,ag)
af=af or{}

local ah={
Enabled=af.Enabled~=false,
Text=af.Text or"Watermark",
Opacity=math.clamp(tonumber(af.Opacity)or 0.45,0,1),
Position=af.Position or"bottom-right",
Size=math.max(math.floor(tonumber(af.Size)or 14),8),
Padding=math.max(math.floor(tonumber(af.Padding)or 12),0),
Offset=typeof(af.Offset)=="Vector2"and af.Offset or Vector2.new(0,0),
Color=af.Color,
}

local ai=ac("Frame",{
Name="Watermark",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=ag,
Active=false,
ZIndex=99999,
Visible=ah.Enabled,
})

local aj=ac("TextLabel",{
Name="Label",
AutomaticSize="XY",
BackgroundTransparency=1,
Text=tostring(ah.Text),
TextSize=ah.Size,
TextTransparency=1-ah.Opacity,
TextXAlignment="Left",
TextYAlignment="Center",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag=not ah.Color and{
TextColor3="Text",
}or nil,
TextColor3=ah.Color,
RichText=af.RichText==true,
Parent=ai,
ZIndex=99999,
})

local function updatePosition(ak)
if typeof(ak)=="UDim2"then
ah.Position=ak
aj.AnchorPoint=typeof(af.AnchorPoint)=="Vector2"and af.AnchorPoint or Vector2.new(0.5,0.5)
aj.Position=ak
return
end

ah.Position=ak or"bottom-right"
local al,am=getPresetPosition(ah.Position,ah.Padding,ah.Offset)
aj.AnchorPoint=al
aj.Position=am
end

updatePosition(ah.Position)

function ah.SetEnabled(ak,al)
ah.Enabled=al~=false
ai.Visible=ah.Enabled
return ah
end

function ah.SetText(ak,al)
ah.Text=tostring(al or"")
aj.Text=ah.Text
return ah
end

function ah.SetOpacity(ak,al)
ah.Opacity=math.clamp(tonumber(al)or ah.Opacity,0,1)
ad(aj,0.1,{TextTransparency=1-ah.Opacity}):Play()
return ah
end

function ah.SetPosition(ak,al)
updatePosition(al)
return ah
end

function ah.SetOffset(ak,al)
ah.Offset=typeof(al)=="Vector2"and al or ah.Offset
updatePosition(ah.Position)
return ah
end

function ah.SetPadding(ak,al)
ah.Padding=math.max(math.floor(tonumber(al)or ah.Padding),0)
updatePosition(ah.Position)
return ah
end

function ah.SetSize(ak,al)
ah.Size=math.max(math.floor(tonumber(al)or ah.Size),8)
aj.TextSize=ah.Size
return ah
end

function ah.Destroy(ak)
ai:Destroy()
end

ah.Container=ai
ah.Label=aj

return ah
end

return aa end function a.z():typeof(__modImpl())local aa=a.cache.z if not aa then aa={c=__modImpl()}a.cache.z=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ac=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
ButtonKeybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set and ag.value~=nil then
af:Set(ag.value)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
ToggleKeybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
keybind=af.Keybind,
}
end,
Load=function(af,ag)
if af and af.Set and ag.value~=nil then
af:Set(ag.value)
end

if af and af.SetKeybind and ag.keybind then
af:SetKeybind(ag.keybind)
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return false
end

ad=ag
ae.Folder=ad.Folder
ae.Path="WindUI/"..tostring(ae.Folder).."/config/"

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

local ah=ae:AllConfigs()

for ai,aj in next,ah do
if isfile and readfile and isfile(aj..".json")then
ae.Configs[aj]=readfile(aj..".json")
end
end

return ae
end

function ae.SetPath(af,ag)
if not ag then
warn"[ WindUI.ConfigManager ] Custom path is not specified."
return false
end

ae.Path=ag
if not ag:match"/$"then
ae.Path=ag.."/"
end

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

return true
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad:SetCurrentConfig(ai)
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ac:JSONEncode(ak)
if writefile then
writefile(ai.Path,al)
end

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ac:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

for am,an in next,(al.__elements or{})do
if ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
end
end

ai.CustomData=al.__custom or{}

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ac:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
if not isfolder(ae.Path)then
makefolder(ae.Path)
return ag
end

for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.A():typeof(__modImpl())local aa=a.cache.A if not aa then aa={c=__modImpl()}a.cache.A=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New
local ad=ab.Tween


local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


function aa.New(af)
local ag={
Button=nil
}

local ah













local ai=ac("TextLabel",{
Text=af.Title,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local aj=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"move"[1],
ImageRectOffset=ab.Icon"move"[2].ImageRectPosition,
ImageRectSize=ab.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})
local ak=ac("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,36,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local al=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=af.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})


local am=ac("UIScale",{
Scale=1,
})

local an=ac("Frame",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=al,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
am,
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ac("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ac("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
aj,
ak,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),

BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ah,
ac("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai,
ac("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
}),
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ag.Button=an



function ag.SetIcon(ao,ap)
if ah then
ah:Destroy()
end
if ap then
ah=ab.Image(
ap,
af.Title,
0,
af.Folder,
"OpenButton",
true,
af.IconThemed
)
ah.Size=UDim2.new(0,22,0,22)
ah.LayoutOrder=-1
ah.Parent=ag.Button.TextButton
end
end

if af.Icon then
ag:SetIcon(af.Icon)
end



ab.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
al.Size=UDim2.new(
0,an.AbsoluteSize.X,
0,an.AbsoluteSize.Y
)
end)

ab.AddSignal(an.TextButton.MouseEnter,function()
ad(an.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(an.TextButton.MouseLeave,function()
ad(an.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local ao=ab.Drag(al)


function ag.Visible(ap,aq)
al.Visible=aq
end

function ag.SetScale(ap,aq)
am.Scale=aq
end

function ag.Edit(ap,aq)
local ar={
Title=aq.Title,
Icon=aq.Icon,
Enabled=aq.Enabled,
Position=aq.Position,
OnlyIcon=aq.OnlyIcon or false,
Draggable=aq.Draggable or nil,
OnlyMobile=aq.OnlyMobile,
CornerRadius=aq.CornerRadius or UDim.new(1,0),
StrokeThickness=aq.StrokeThickness or 2,
Scale=aq.Scale or 1,
Color=aq.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if ar.Enabled==false then
af.IsOpenButtonEnabled=false
end

if ar.OnlyMobile~=false then
ar.OnlyMobile=true
else
af.IsPC=false
end


if ar.Draggable==false and aj and ak then
aj.Visible=ar.Draggable
ak.Visible=ar.Draggable

if ao then
ao:Set(ar.Draggable)
end
end

if ar.Position and al then
al.Position=ar.Position
end

if ar.OnlyIcon==true and ai then
ai.Visible=false
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,7)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,7)
elseif ar.OnlyIcon==false then
ai.Visible=true
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,11)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,11)
end





if ai then
if ar.Title then
ai.Text=ar.Title
ab:ChangeTranslationKey(ai,ar.Title)
elseif ar.Title==nil then

end
end

if ar.Icon then
ag:SetIcon(ar.Icon)
end

an.UIStroke.UIGradient.Color=ar.Color
local as=an:FindFirstChild"Glow"
if as and as:FindFirstChild"UIGradient"then
as.UIGradient.Color=ar.Color
end

an.UICorner.CornerRadius=ar.CornerRadius
an.TextButton.UICorner.CornerRadius=UDim.new(ar.CornerRadius.Scale,ar.CornerRadius.Offset-4)
an.UIStroke.Thickness=ar.StrokeThickness

ag:SetScale(ar.Scale)
end

return ag
end



return aa end function a.B():typeof(__modImpl())local aa=a.cache.B if not aa then aa={c=__modImpl()}a.cache.B=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=ai=="Small"and 16 or 24,
TooltipArrowSizeY=ai=="Small"and 6 or 9,

PaddingX=ai=="Small"and 12 or 14,
PaddingY=ai=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ah=ah or""
aj=aj~=false

local al=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=aj,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=ai=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ah.."Text",
}
})

ak.TitleFrame=al

local am=ac("UIScale",{
Scale=.9
})

local an=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ag,
Name="Arrow",
},{
ac("ImageLabel",{
Size=UDim2.new(0,ak.TooltipArrowSizeX,0,ak.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
},{










}),
}),
ab.NewRoundFrame(ak.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

al,
ac("UIPadding",{
PaddingTop=UDim.new(0,ak.PaddingY),
PaddingLeft=UDim.new(0,ak.PaddingX),
PaddingRight=UDim.new(0,ak.PaddingX),
PaddingBottom=UDim.new(0,ak.PaddingY),
}),
})
}),
am,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ak.Container=an

function ak.Open(ao)
an.Visible=true


ad(an.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ak.Close(ao,ap)

ad(an.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

ap=ap~=false
if ap then
task.wait(.35)

an.Visible=false
an:Destroy()
end
end

return ak
end



return aa end function a.C():typeof(__modImpl())local aa=a.cache.C if not aa then aa={c=__modImpl()}a.cache.C=aa end return aa.c end end do local function __modImpl()
local aa=a.c()
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween

local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


local function Color3ToHSB(af)
local ag,ah,ai=af.R,af.G,af.B
local aj=math.max(ag,ah,ai)
local ak=math.min(ag,ah,ai)
local al=aj-ak

local am=0
if al~=0 then
if aj==ag then
am=(ah-ai)/al%6
elseif aj==ah then
am=(ai-ag)/al+2
else
am=(ag-ah)/al+4
end
am=am*60
else
am=0
end

local an=(aj==0)and 0 or(al/aj)
local ao=aj

return{
h=math.floor(am+0.5),
s=an,
b=ao
}
end

local function GetPerceivedBrightness(af)
local ag=af.R
local ah=af.G
local ai=af.B
return 0.299*ag+0.587*ah+0.114*ai
end

local function GetTextColorForHSB(af)
local ag=Color3ToHSB(af)local
ah, ai, aj=ag.h, ag.s, ag.b
if GetPerceivedBrightness(af)>0.5 then
return Color3.fromHSV(ah/360,0,0.05)
else
return Color3.fromHSV(ah/360,0,0.98)
end
end


local function getElementPosition(af,ag)
if type(ag)~="number"or ag~=math.floor(ag)then
return nil,1
end






local ah=#af


if ah==0 or ag<1 or ag>ah then
return nil,2
end

local function isDelimiter(ai)
if ai==nil then return true end
local aj=ai.__type
return aj=="Divider"or aj=="Space"or aj=="Section"or aj=="MultiSection"or aj=="Code"
end

if isDelimiter(af[ag])then
return nil,3
end

local function calculate(ai,aj)
if aj==1 then return"Squircle"end
if ai==1 then return"Squircle-TL-TR"end
if ai==aj then return"Squircle-BL-BR"end
return"Square"
end

local ai=1
local aj=0

for ak=1,ah do
local al=af[ak]
if isDelimiter(al)then
if ag>=ai and ag<=ak-1 then
local am=ag-ai+1
return calculate(am,aj)
end
ai=ak+1
aj=0
else
aj=aj+1
end
end


if ag>=ai and ag<=ah then
local ak=ag-ai+1
return calculate(ak,aj)
end

return nil,4
end


return function(af)
local ag={
Title=af.Title,
Desc=af.Desc or nil,
Hover=af.Hover,
Thumbnail=af.Thumbnail,
ThumbnailSize=af.ThumbnailSize or 80,
Image=af.Image,
IconThemed=af.IconThemed or false,
ImageSize=af.ImageSize or 30,
Color=af.Color,
Scalable=af.Scalable,
Parent=af.Parent,
Justify=af.Justify or"Between",
UIPadding=af.Window.ElementConfig.UIPadding,
UICorner=af.Window.ElementConfig.UICorner,
Size=af.Size or"Default",
UIElements={},

Index=af.Index
}

local ah=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0
local ai=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0

local aj=ag.ImageSize
local ak=ag.ThumbnailSize
local al=true


local am=0

local an
local ao
if ag.Thumbnail then
an=aa.Image(
ag.Thumbnail,
ag.Title,
af.Window.ModernLayout and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
end
if ag.Image then
ao=aa.Image(
ag.Image,
ag.Title,
af.Window.ModernLayout and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)
if typeof(ag.Color)=="string"then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Size=UDim2.new(0,aj,0,aj)

am=aj
end

local function CreateText(ap,aq)
local ar=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"
and GetTextColorForHSB(ag.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=ap or"",
TextSize=aq=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ag.Color and("Element"..aq)or nil,
},
TextColor3=ag.Color and ar or nil,
TextTransparency=aq=="Desc"and.3 or 0,
TextWrapped=true,
Size=UDim2.new(ag.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,aq=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
})
end

local ap=CreateText(ag.Title,"Title")
local aq=CreateText(ag.Desc,"Desc")
if not ag.Title or ag.Title==""then
aq.Visible=false
end
if not ag.Desc or ag.Desc==""then
aq.Visible=false
end

ag.UIElements.Title=ap
ag.UIElements.Desc=aq

ag.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ag.Justify=="Between"and"Left"or"Center",
}),
an,
ab("Frame",{
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and-af.TextOffset or 0,
0,
0
),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=af.Window.ModernLayout and(ag.Justify=="Between"and"Top"or"Center")or"Center",
HorizontalAlignment=ag.Justify~="Between"and ag.Justify or"Center",
}),
ao,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and(ao and-am-ag.UIPadding or-am)or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,(af.Window.ModernLayout and ag.UIPadding/2 or 0)+ai),
PaddingLeft=UDim.new(0,(af.Window.ModernLayout and ag.UIPadding/2 or 0)+ah),
PaddingRight=UDim.new(0,(af.Window.ModernLayout and ag.UIPadding/2 or 0)+ah),
PaddingBottom=UDim.new(0,(af.Window.ModernLayout and ag.UIPadding/2 or 0)+ai),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap,
aq
}),
})
})






local ar=aa.Image(
"lock",
"lock",
0,
af.Window.Folder,
"Lock",
false
)
ar.Size=UDim2.new(0,20,0,20)
ar.ImageLabel.ImageColor3=Color3.new(1,1,1)
ar.ImageLabel.ImageTransparency=.4

local as=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=.05,
})

local at=ab("Frame",{
Size=UDim2.new(1,ag.UIPadding*2,1,ag.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local au,av=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ar,as
},nil,true)

local aw,ax=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local ay,az=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)


local aA,aB=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1)
},
}),
},nil,true)

local b,d=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1)
},
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local f,g=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ag.Color and.05 or.93,



Parent=af.Parent,
ThemeTag={
ImageColor3=not ag.Color and"ElementBackground"or nil
},
ImageColor3=ag.Color and
(
typeof(ag.Color)=="string"
and Color3.fromHex(aa.Colors[ag.Color])
or typeof(ag.Color)=="Color3"
and ag.Color
)or nil
},{
ag.UIElements.Container,
at,
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
}),
},true,true)

ag.UIElements.Main=f
ag.UIElements.Locked=au

if ag.Hover then
aa.AddSignal(f.MouseEnter,function()
if al then
ad(f,.12,{ImageTransparency=ag.Color and.15 or.9}):Play()
ad(b,.12,{ImageTransparency=.9}):Play()
ad(aA,.12,{ImageTransparency=.8}):Play()
aa.AddSignal(f.MouseMoved,function(h,j)
b.HoverGradient.Offset=Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
aA.HoverGradient.Offset=Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(f.InputEnded,function()
if al then
ad(f,.12,{ImageTransparency=ag.Color and.05 or.93}):Play()
ad(b,.12,{ImageTransparency=1}):Play()
ad(aA,.12,{ImageTransparency=1}):Play()
end
end)
end

function ag.SetTitle(h,j)
ag.Title=j
ap.Text=j
end

function ag.SetDesc(h,j)
ag.Desc=j
aq.Text=j or""
if not j then
aq.Visible=false
elseif not aq.Visible then
aq.Visible=true
end
end


function ag.Colorize(h,j,l)
if ag.Color then
j[l]=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"
and GetTextColorForHSB(ag.Color)
or nil
end
end

if af.ElementTable then
aa.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ag.Title~=ap.Text then
ag:SetTitle(ap.Text)
af.ElementTable.Title=ap.Text
end
end)
aa.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if ag.Desc~=aq.Text then
ag:SetDesc(aq.Text)
af.ElementTable.Desc=aq.Text
end
end)
end





function ag.SetThumbnail(h,j,l)
ag.Thumbnail=j
if l then
ag.ThumbnailSize=l
ak=l
end

if an then
if j then
an:Destroy()
an=aa.Image(
j,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
else
an.Visible=false
end
else
if j then
an=aa.Image(
j,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
end
end
end

function ag.SetImage(h,j,l)
ag.Image=j
if l then
ag.ImageSize=l
aj=l
end

if ao then
ao:Destroy()
ao=nil
end

if j then
ao=aa.Image(
j,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)

if typeof(ag.Color)=="string"then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Size=UDim2.new(0,aj,0,aj)
ao.Parent=ag.UIElements.Container.TitleFrame
am=aj
else
am=0
end

local m=ao and(-am-ag.UIPadding)or 0
ag.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,m,1,0)
end

function ag.Destroy(h)
f:Destroy()
end


function ag.Lock(h,j)
al=false
au.Active=true
au.Visible=true
as.Text=j or"Locked"
end

function ag.Unlock(h)
al=true
au.Active=false
au.Visible=false
end

function ag.Highlight(h)
local j=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=aw
})

local l=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=ay
})

aw.ImageTransparency=0.65
ay.ImageTransparency=0.88

ad(j,0.75,{
Offset=Vector2.new(1,0)
}):Play()

ad(l,0.75,{
Offset=Vector2.new(1,0)
}):Play()


task.spawn(function()
task.wait(.75)
aw.ImageTransparency=1
ay.ImageTransparency=1
j:Destroy()
l:Destroy()
end)
end


function ag.UpdateShape(h)
if af.Window.ModernLayout then
local j
if af.ParentConfig.ParentType=="Group"then
j="Squircle"
else
j=getElementPosition(h.Elements,ag.Index)
end

if j and f then
g:SetType(j)
av:SetType(j)
az:SetType(j)
ax:SetType(j.."-Outline")
d:SetType(j)
aB:SetType(j.."-Outline")
end
end
end





return ag
end end function a.D():typeof(__modImpl())local aa=a.cache.D if not aa then aa={c=__modImpl()}a.cache.D=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ab=aa.New

local ac={}

local ad=a.e().New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,

Locked=af.Locked or false,
}
local ah=a.D()(af)

ag.ParagraphFrame=ah
if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for aj,ak in next,af.Buttons do
local al=ad(ak.Title,ak.Icon,ak.Callback,"White",ai,nil,nil,10)
al.Size=UDim2.new(1,0,0,38)

end
end

return ag.__type,ag

end

return ac end function a.E():typeof(__modImpl())local aa=a.cache.E if not aa then aa={c=__modImpl()}a.cache.E=aa end return aa.c end end do local function __modImpl()

local aa=a.c()local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Button",
Title=ae.Title or"Button",
Desc=ae.Desc or nil,
Icon=ae.Icon or"mouse-pointer-click",
IconThemed=ae.IconThemed or false,
Color=ae.Color,
Justify=ae.Justify or"Between",
IconAlign=ae.IconAlign or"Right",
Locked=ae.Locked or false,
LockedTitle=ae.LockedTitle,
Callback=ae.Callback or function()end,
UIElements={}
}

local ag=true

af.ButtonFrame=a.D(){
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,




Window=ae.Window,
Color=af.Color,
Justify=af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
Size=ae.Size,
}














af.UIElements.ButtonIcon=aa.Image(
af.Icon,
af.Icon,
0,
ae.Window.Folder,
"Button",
not af.Color and true or nil,
af.IconThemed
)

af.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
af.UIElements.ButtonIcon.Parent=af.Justify=="Between"and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ah)
af.Locked=true
ag=false
return af.ButtonFrame:Lock(af.LockedTitle)
end
function af.Unlock(ah)
af.Locked=false
ag=true
return af.ButtonFrame:Unlock()
end

if af.Locked then
af:Lock()
end

aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ag then
task.spawn(function()
aa.SafeCallback(af.Callback)
end)
end
end)
return af.__type,af
end

return ac end function a.F():typeof(__modImpl())local aa=a.cache.F if not aa then aa={c=__modImpl()}a.cache.F=aa end return aa.c end end do local function __modImpl()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.c()
local ad=ac.New

local ae=a.u().New

local af={}

function af.New(ag,ah)
local function NormalizeKeyCode(ai)
if typeof(ai)=="EnumItem"then
return ai.Name
elseif type(ai)=="string"then
return ai
else
return"F"
end
end

local ai={
__type="ButtonKeybind",
Title=ah.Title or"Button Keybind",
Desc=ah.Desc or nil,
Icon=ah.Icon or"mouse-pointer-click",
IconThemed=ah.IconThemed or false,
Color=ah.Color,
Justify=ah.Justify or"Between",
IconAlign=ah.IconAlign or"Right",
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
Callback=ah.Callback or function()end,
Value=NormalizeKeyCode(ah.Value)or"F",
CanChange=ah.CanChange~=false,
Picking=false,
UIElements={}
}

local aj=true
local ak=false

ai.ButtonKeybindFrame=a.D(){
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
Window=ah.Window,
Color=ai.Color,
Justify=ai.Justify,
TextOffset=85,
Hover=true,
Scalable=true,
Tab=ah.Tab,
Index=ah.Index,
ElementTable=ai,
ParentConfig=ah,
Size=ah.Size,
}

ai.UIElements.ButtonIcon=ac.Image(
ai.Icon,
ai.Icon,
0,
ah.Window.Folder,
"Button",
not ai.Color and true or nil,
ai.IconThemed
)

ai.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
ai.UIElements.ButtonIcon.Parent=ai.Justify=="Between"and ai.ButtonKeybindFrame.UIElements.Main or ai.ButtonKeybindFrame.UIElements.Container.TitleFrame
ai.UIElements.ButtonIcon.LayoutOrder=ai.IconAlign=="Left"and-99999 or 99999
ai.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
ai.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

ai.ButtonKeybindFrame:Colorize(ai.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

ai.UIElements.Keybind=ae(ai.Value,nil,ai.ButtonKeybindFrame.UIElements.Main,nil,10)
ai.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ai.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=ai.UIElements.Keybind,
Scale=0.85,
})

local function UpdateAccessoriesLayout()
local al=24+ai.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X
local am=al

ai.UIElements.Keybind.Size=UDim2.new(
0,
al,
0,
42
)

if ai.IconAlign~="Left"and ai.UIElements.ButtonIcon then
ai.UIElements.ButtonIcon.Position=UDim2.new(1,-(al+8),0.5,0)
am=am+20+8
end

local an=ai.ButtonKeybindFrame
and ai.ButtonKeybindFrame.UIElements
and ai.ButtonKeybindFrame.UIElements.Container
and ai.ButtonKeybindFrame.UIElements.Container.TitleFrame

if an and ai.Justify=="Between"then
an.Size=UDim2.new(1,-am,0,0)
end
end

ac.AddSignal(ai.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
UpdateAccessoriesLayout()
end)

UpdateAccessoriesLayout()

local function StartPicking()
if not aj or not ai.CanChange then
return
end

ai.Picking=true
ai.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=ab.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

if not an then
return
end

local ao
ao=ab.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or(an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1)or(an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2)then
ai.Picking=false
ai.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
ai.Value=an

al:Disconnect()
ao:Disconnect()
end
end)
end)
end

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.ButtonKeybindFrame:Lock(ai.LockedTitle)
end

function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.ButtonKeybindFrame:Unlock()
end

function ai.Set(al,am)
local an=NormalizeKeyCode(am)
ai.Value=an
ai.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
end

if ai.Locked then
ai:Lock()
end

ac.AddSignal(ai.UIElements.Keybind.MouseButton1Click,function()
if not aj or not ai.CanChange then
return
end

ak=true
task.defer(function()
ak=false
end)

StartPicking()
end)

ac.AddSignal(ai.ButtonKeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
ak=false
return
end

if aj then
task.spawn(function()
ac.SafeCallback(ai.Callback)
end)
end
end)

ac.AddSignal(ab.InputBegan,function(al,am)
if am or ab:GetFocusedTextBox()then
return
end

if ai.Picking or not aj then
return
end

if al.UserInputType==Enum.UserInputType.Keyboard then
if al.KeyCode.Name==ai.Value then
ac.SafeCallback(ai.Callback,al.KeyCode.Name)
end
elseif al.UserInputType==Enum.UserInputType.MouseButton1 and ai.Value=="MouseLeft"then
ac.SafeCallback(ai.Callback,"MouseLeft")
elseif al.UserInputType==Enum.UserInputType.MouseButton2 and ai.Value=="MouseRight"then
ac.SafeCallback(ai.Callback,"MouseRight")
end
end)

return ai.__type,ai
end

return af end function a.G():typeof(__modImpl())local aa=a.cache.G if not aa then aa={c=__modImpl()}a.cache.G=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()
local ac=ab.New
local ad=ab.Tween

local ae=game:GetService"UserInputService"

function aa.New(af,ag,ah,ai,aj,ak)
local al={}

local am=12
local an
if ag and ag~=""then
an=ac("ImageLabel",{
Size=UDim2.new(0,13,0,13),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ag)[1],
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local ao=ac("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=ai,
})

local ap=ab.NewRoundFrame(am,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ao,
Size=UDim2.new(0,40.8,0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
},{
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(am,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(0,20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="ToggleBar",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar"
},{
ab.NewRoundFrame(am,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.4,
},{













}),
an,
ac("UIScale",{
Scale=1,
})
}),
})
})

local aq
local ar

local as=20
local at=ap.Size.X.Offset

function al.Set(au,av,aw,ax)
if not ax then
if av then
ad(ap.Frame,0.15,{
Position=UDim2.new(0,at-as-2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(ap.Frame,0.15,{
Position=UDim2.new(0,2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
else
if av then
ap.Frame.Position=UDim2.new(0,at-as-2,0.5,0)
else
ap.Frame.Position=UDim2.new(0,2,0.5,0)
end
end

if av then
ad(ap.Layer,0.1,{
ImageTransparency=0,
}):Play()

if an then
ad(an,0.1,{
ImageTransparency=0,
}):Play()
end
else
ad(ap.Layer,0.1,{
ImageTransparency=1,
}):Play()

if an then
ad(an,0.1,{
ImageTransparency=1,
}):Play()
end
end

aw=aw~=false

task.spawn(function()
if aj and aw then
ab.SafeCallback(aj,av)
end
end)
end


function al.Animate(au,av,aw)
if not ak.Window.IsToggleDragging then
ak.Window.IsToggleDragging=true

local ax=av.Position.X
local ay=av.Position.Y
local az=ap.Frame.Position.X.Offset
local aA=false

ad(ap.Frame.Bar.UIScale,0.28,{Scale=1.5},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ap.Frame.Bar,0.28,{ImageTransparency=.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if aq then
aq:Disconnect()
end

aq=ae.InputChanged:Connect(function(aB)
if ak.Window.IsToggleDragging and(aB.UserInputType==Enum.UserInputType.MouseMovement or aB.UserInputType==Enum.UserInputType.Touch)then
if aA then
return
end

local b=math.abs(aB.Position.X-ax)
local d=math.abs(aB.Position.Y-ay)

if d>b and d>10 then
aA=true
ak.Window.IsToggleDragging=false

if aq then
aq:Disconnect()
aq=nil
end
if ar then
ar:Disconnect()
ar=nil
end

ad(ap.Frame,0.15,{
Position=UDim2.new(0,az,0.5,0)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(ap.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ap.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return
end

local f=aB.Position.X-ax
local g=math.max(2,math.min(az+f,at-as-2))local h=

(ap.Frame.Position.X.Offset-2)/(at-as-4)

ad(ap.Frame,0.05,{
Position=UDim2.new(0,g,0.5,0)
},Enum.EasingStyle.Linear,Enum.EasingDirection.Out):Play()





end
end)

if ar then
ar:Disconnect()
end

ar=ae.InputEnded:Connect(function(aB)
if ak.Window.IsToggleDragging and(aB.UserInputType==Enum.UserInputType.MouseButton1 or aB.UserInputType==Enum.UserInputType.Touch)then
ak.Window.IsToggleDragging=false

if aq then
aq:Disconnect()
aq=nil
end

if ar then
ar:Disconnect()
ar=nil
end

if aA then
return
end

local b=ap.Frame.Position.X.Offset
local d=math.abs(aB.Position.X-ax)

if d<10 then
local f=not aw.Value
aw:Set(f,true,false)
else
local f=b+as/2
local g=at/2
local h=f>g
aw:Set(h,true,false)
end

ad(ap.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ap.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end
end

return ao,al
end

return aa end function a.H():typeof(__modImpl())local aa=a.cache.H if not aa then aa={c=__modImpl()}a.cache.H=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=a.c()local ac=
ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={}

af=af or"sfsymbols:checkmark"

local al=9

local am=ab.Image(
af,
af,
0,
(aj and aj.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
am.Size=UDim2.new(1,-26+ag,1,-26+ag)
am.AnchorPoint=Vector2.new(0.5,0.5)
am.Position=UDim2.new(0.5,0,0.5,0)


local an=ab.NewRoundFrame(al,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ah,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(al,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ThemeTag={
ImageColor3="CheckboxBorder",
ImageTransparency="CheckboxBorderTransparency",
},
},{







}),

am,
})

function ak.Set(ao,ap)
if ap then
ad(an.Layer,0.06,{
ImageTransparency=0,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=0,
}):Play()
else
ad(an.Layer,0.05,{
ImageTransparency=1,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if ai then
ab.SafeCallback(ai,ap)
end
end)
end

return an,ak
end


return aa end function a.I():typeof(__modImpl())local aa=a.cache.I if not aa then aa={c=__modImpl()}a.cache.I=aa end return aa.c end end do local function __modImpl()
local aa=a.c()

local ab=a.H().New
local ac=a.I().New

local ad={}

function ad.New(ae,af)
local ag={
__type="Toggle",
Title=af.Title or"Toggle",
Desc=af.Desc or nil,
Locked=af.Locked or false,
LockedTitle=af.LockedTitle,
Value=af.Value,
Icon=af.Icon or nil,
IconSize=af.IconSize or 23,
Type=af.Type or"Toggle",
Callback=af.Callback or function()end,
UIElements={}
}
ag.ToggleFrame=a.D(){
Title=ag.Title,
Desc=ag.Desc,




Window=af.Window,
Parent=af.Parent,
TextOffset=(52),
Hover=false,
Tab=af.Tab,
Index=af.Index,
ElementTable=ag,
ParentConfig=af,
}

local ah=true

if ag.Value==nil then
ag.Value=false
end



function ag.Lock(ai)
ag.Locked=true
ah=false
return ag.ToggleFrame:Lock(ag.LockedTitle)
end
function ag.Unlock(ai)
ag.Locked=false
ah=true
return ag.ToggleFrame:Unlock()
end

if ag.Locked then
ag:Lock()
end

local ai=ag.Value

local aj,ak
if ag.Type=="Toggle"then
aj,ak=ab(ai,ag.Icon,ag.IconSize,ag.ToggleFrame.UIElements.Main,ag.Callback,af)
elseif ag.Type=="Checkbox"then
aj,ak=ac(ai,ag.Icon,ag.IconSize,ag.ToggleFrame.UIElements.Main,ag.Callback,af)
else
error("Unknown Toggle Type: "..tostring(ag.Type))
end

aj.AnchorPoint=Vector2.new(1,0.5)
aj.Position=UDim2.new(1,0,0.5,0)

function ag.Set(al,am,an,ao)
if ah then
ak:Set(am,an,ao or false)
ai=am
ag.Value=am
end
end

ag:Set(ai,false,false)

aa.AddSignal(ag.ToggleFrame.UIElements.Main.MouseButton1Click,function()
ag:Set(not ag.Value,nil,false)
end)

return ag.__type,ag
end

return ad end function a.J():typeof(__modImpl())local aa=a.cache.J if not aa then aa={c=__modImpl()}a.cache.J=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.c()
local ad=ac.New

local ae=a.H().New
local af=a.I().New
local ag=a.u().New

local ah={}

function ah.New(ai,aj)
local function NormalizeKeyCode(ak)
if typeof(ak)=="EnumItem"then
return ak.Name
elseif type(ak)=="string"then
return ak
else
return"F"
end
end

local ak={
__type="ToggleKeybind",
Title=aj.Title or"Toggle Keybind",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
Value=aj.Value,
Icon=aj.Icon or nil,
IconSize=aj.IconSize or 23,
Type=aj.Type or"Toggle",
Callback=aj.Callback or function()end,
Keybind=NormalizeKeyCode(aj.Keybind or aj.Bind or aj.Key)or"F",
CanChange=aj.CanChange~=false,
Picking=false,
UIElements={}
}

local al=true
local am=false

if ak.Value==nil then
ak.Value=false
end

local an=(40.8)

ak.ToggleKeybindFrame=a.D(){
Title=ak.Title,
Desc=ak.Desc,
Window=aj.Window,
Parent=aj.Parent,
TextOffset=an+85+8,
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
ElementTable=ak,
ParentConfig=aj,
}

local ao=ak.Value

local ap,aq
if ak.Type=="Toggle"then
ap,aq=ae(ao,ak.Icon,ak.IconSize,ak.ToggleKeybindFrame.UIElements.Main,ak.Callback,aj)
elseif ak.Type=="Checkbox"then
ap,aq=af(ao,ak.Icon,ak.IconSize,ak.ToggleKeybindFrame.UIElements.Main,ak.Callback,aj)
else
error("Unknown Toggle Type: "..tostring(ak.Type))
end

ap.AnchorPoint=Vector2.new(1,0.5)
ap.Position=UDim2.new(1,0,0.5,0)

ak.UIElements.Keybind=ag(ak.Keybind,nil,ak.ToggleKeybindFrame.UIElements.Main,nil,10)
ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
ak.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ak.UIElements.Keybind.Position=UDim2.new(1,-an-8,0.5,0)

ad("UIScale",{
Parent=ak.UIElements.Keybind,
Scale=0.85,
})

ac.AddSignal(ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

local function StartPicking()
if not al or not ak.CanChange then
return
end

ak.Picking=true
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local ar
ar=ab.InputBegan:Connect(function(as)
local at

if as.UserInputType==Enum.UserInputType.Keyboard then
at=as.KeyCode.Name
elseif as.UserInputType==Enum.UserInputType.MouseButton1 then
at="MouseLeft"
elseif as.UserInputType==Enum.UserInputType.MouseButton2 then
at="MouseRight"
end

if not at then
return
end

local au
au=ab.InputEnded:Connect(function(av)
if av.KeyCode.Name==at or(at=="MouseLeft"and av.UserInputType==Enum.UserInputType.MouseButton1)or(at=="MouseRight"and av.UserInputType==Enum.UserInputType.MouseButton2)then
ak.Picking=false
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=at
ak.Keybind=at

ar:Disconnect()
au:Disconnect()
end
end)
end)
end

function ak.Lock(ar)
ak.Locked=true
al=false
return ak.ToggleKeybindFrame:Lock(ak.LockedTitle)
end

function ak.Unlock(ar)
ak.Locked=false
al=true
return ak.ToggleKeybindFrame:Unlock()
end

function ak.Set(ar,as,at,au)
if al then
aq:Set(as,at,au or false)
ao=as
ak.Value=as
end
end

function ak.SetKeybind(ar,as)
local at=NormalizeKeyCode(as)
ak.Keybind=at
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=at
end

ak:Set(ao,false,false)

if ak.Locked then
ak:Lock()
end

ac.AddSignal(ak.UIElements.Keybind.MouseButton1Click,function()
if not al or not ak.CanChange then
return
end

am=true
task.defer(function()
am=false
end)

StartPicking()
end)

ac.AddSignal(ak.ToggleKeybindFrame.UIElements.Main.MouseButton1Click,function()
if am then
am=false
return
end

ak:Set(not ak.Value,nil,false)
end)

ac.AddSignal(ab.InputBegan,function(ar,as)
if as or ab:GetFocusedTextBox()then
return
end

if ak.Picking or not al then
return
end

if ar.UserInputType==Enum.UserInputType.Keyboard then
if ar.KeyCode.Name==ak.Keybind then
ak:Set(not ak.Value,true,false)
end
elseif(ar.UserInputType==Enum.UserInputType.MouseButton1 and ak.Keybind=="MouseLeft")
or(ar.UserInputType==Enum.UserInputType.MouseButton2 and ak.Keybind=="MouseRight")
then
ak:Set(not ak.Value,true,false)
end
end)

return ak.__type,ak
end

return ah end function a.K():typeof(__modImpl())local aa=a.cache.K if not aa then aa={c=__modImpl()}a.cache.K=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"UserInputService")
local ac=aa(game:GetService"RunService")

local ad=a.c()
local ae=ad.New
local af=ad.Tween


local ag={}

local ah=false

function ag.New(ai,aj)
local ak={
__type="Slider",
Title=aj.Title or nil,
Desc=aj.Desc or nil,
Locked=aj.Locked or nil,
LockedTitle=aj.LockedTitle,
Value=aj.Value or{},
Icons=aj.Icons or nil,
IsTooltip=aj.IsTooltip or false,
IsTextbox=aj.IsTextbox,
Step=aj.Step or 1,
Callback=aj.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=aj.Width or 130,
TextBoxWidth=30,
ThumbSize=13,
IconSize=26,
}
if type(ak.Step)~="number"or ak.Step==0 then
ak.Step=1
end

if type(ak.Icons)=="table"and next(ak.Icons)==nil then
ak.Icons={
From="sfsymbols:sunMinFill",
To="sfsymbols:sunMaxFill",
}
end
if ak.IsTextbox==nil and ak.Title==nil then ak.IsTextbox=false else ak.IsTextbox=ak.IsTextbox~=false end

local al
local am
local an
local ao=ak.Value.Default or ak.Value.Min or 0

local function GetMinMax()
local ap=ak.Value.Min or 0
local aq=ak.Value.Max or 100

if aq<=ap then
aq=ap+math.abs(ak.Step)
end

return ap,aq
end

local function GetDelta(ap)
local aq,ar=GetMinMax()
return math.clamp((ap-aq)/(ar-aq),0,1)
end

local ap=ao
local aq=GetDelta(ao)

local ar=true
local as=ak.Step%1~=0

local function FormatValue(at)
if as then
return tonumber(string.format("%.2f",at))
end
return math.floor(at+0.5)
end

local function CalculateValue(at)
if as then
return math.floor(at/ak.Step+0.5)*ak.Step
else
return math.floor(at/ak.Step+0.5)*ak.Step
end
end

local at,au
local av=32
if ak.Icons then
if ak.Icons.From then
at=ad.Image(
ak.Icons.From,
ak.Icons.From,
0,
aj.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
at.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
av=av+ak.IconSize-2
end
if ak.Icons.To then
au=ad.Image(
ak.Icons.To,
ak.Icons.To,
0,
aj.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
au.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
av=av+ak.IconSize-2
end
end
ak.SliderFrame=a.D(){
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=ak.Width,
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
}


ak.UIElements.SliderIcon=ad.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,not ak.IsTextbox and-av or(-ak.TextBoxWidth-8),0,4),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
ad.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(aq,0,1,0),
ImageTransparency=.1,
ThemeTag={
ImageColor3="Slider",
},
},{
ad.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,(ak.ThumbSize+2),0,(ak.ThumbSize+2)),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
},{
ad.NewRoundFrame(99,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=.6,
},{













}),
})
})
})

ak.UIElements.SliderContainer=ae("Frame",{
Size=UDim2.new(ak.Title==nil and 1 or 0,ak.Title==nil and 0 or ak.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=ak.SliderFrame.UIElements.Main,
},{
ae("UIListLayout",{
Padding=UDim.new(0,ak.Title~=nil and 8 or 12),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=ak.Icons and(ak.Icons.From and(ak.Icons.To and"Center"or"Left")or ak.Icons.To and"Right")or"Center",
}),
at,
ak.UIElements.SliderIcon,
au,
ae("TextBox",{
Size=UDim2.new(0,ak.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(ao),
ThemeTag={
TextColor3="Text"
},
TextTransparency=.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
Visible=ak.IsTextbox,
})
})

local aw
if ak.IsTooltip then
aw=a.C().New(ao,ak.UIElements.SliderIcon.Frame.Thumb,true,"Secondary","Small",false)
aw.Container.AnchorPoint=Vector2.new(0.5,1)
aw.Container.Position=UDim2.new(0.5,0,0,-8)
end

function ak.Lock(ax)
ak.Locked=true
ar=false
return ak.SliderFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(ax)
ak.Locked=false
ar=true
return ak.SliderFrame:Unlock()
end

if ak.Locked then
ak:Lock()
end


local ax=aj.Tab.UIElements.ContainerFrame

function ak.Set(ay,az,aA)
if ar then
if not ak.IsFocusing and not ah and(not aA or(aA.UserInputType==Enum.UserInputType.MouseButton1 or aA.UserInputType==Enum.UserInputType.Touch))then
if aA then
al=(aA.UserInputType==Enum.UserInputType.Touch)
ax.ScrollingEnabled=false
ah=true

local aB=al and aA.Position.X or ab:GetMouseLocation().X
local b=math.clamp((aB-ak.UIElements.SliderIcon.AbsolutePosition.X)/ak.UIElements.SliderIcon.AbsoluteSize.X,0,1)
local d,f=GetMinMax()
az=CalculateValue(d+b*(f-d))
az=math.clamp(az,d,f)

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(b,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
ad.SafeCallback(ak.Callback,FormatValue(az))
end

am=ac.RenderStepped:Connect(function()
local g=al and aA.Position.X or ab:GetMouseLocation().X
local h=math.clamp((g-ak.UIElements.SliderIcon.AbsolutePosition.X)/ak.UIElements.SliderIcon.AbsoluteSize.X,0,1)
local j,l=GetMinMax()
az=CalculateValue(j+h*(l-j))
az=math.clamp(az,j,l)

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(h,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
ad.SafeCallback(ak.Callback,FormatValue(az))
end
end)


an=ab.InputEnded:Connect(function(g)
if(g.UserInputType==Enum.UserInputType.MouseButton1 or g.UserInputType==Enum.UserInputType.Touch)and aA==g then
am:Disconnect()
an:Disconnect()
ah=false
ax.ScrollingEnabled=true

if aw then aw:Close(false)end
end
end)
else
local aB,b=GetMinMax()
az=math.clamp(az,aB,b)

local d=GetDelta(az)
az=CalculateValue(aB+d*(b-aB))
az=math.clamp(az,aB,b)

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(d,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
ad.SafeCallback(ak.Callback,FormatValue(az))
end
end
end
end
end

function ak.SetMax(ay,az)
ak.Value.Max=az

local aA=tonumber(ak.Value.Default)or ap
if aA>az then
ak:Set(az)
else
local aB=GetDelta(aA)
af(ak.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aB,0,1,0)}):Play()
end
end

function ak.SetMin(ay,az)
ak.Value.Min=az

local aA=tonumber(ak.Value.Default)or ap
if aA<az then
ak:Set(az)
else
local aB=GetDelta(aA)
af(ak.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aB,0,1,0)}):Play()
end
end

ad.AddSignal(ak.UIElements.SliderContainer.TextBox.FocusLost,function(ay)
if ay then
local az=tonumber(ak.UIElements.SliderContainer.TextBox.Text)
if az then
ak:Set(az)
else
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(ap)
if aw then aw.TitleFrame.Text=FormatValue(ap)end
end
end
end)

ad.AddSignal(ak.UIElements.SliderContainer.InputBegan,function(ay)
if ak.Locked or ah then
return
end

ak:Set(ao,ay)

if ay.UserInputType==Enum.UserInputType.MouseButton1 or ay.UserInputType==Enum.UserInputType.Touch then

if aw then aw:Open()end

end
end)

return ak.__type,ak
end

return ag end function a.L():typeof(__modImpl())local aa=a.cache.L if not aa then aa={c=__modImpl()}a.cache.L=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.c()
local ad=ac.New local ae=
ac.Tween

local af={
UICorner=6,
UIPadding=8,
}

local ag=a.u().New

function af.New(ah,ai)
local function NormalizeKeyCode(aj)
if typeof(aj)=="EnumItem"then
return aj.Name
elseif type(aj)=="string"then
return aj
else
return"F"
end
end

local aj={
__type="Keybind",
Title=ai.Title or"Keybind",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
Value=NormalizeKeyCode(ai.Value)or"F",
Callback=ai.Callback or function()end,
CanChange=ai.CanChange or true,
Picking=false,
UIElements={},
}

local ak=true

aj.KeybindFrame=a.D(){
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=85,
Hover=aj.CanChange,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
}

aj.UIElements.Keybind=ag(aj.Value,nil,aj.KeybindFrame.UIElements.Main,nil,10)

aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
aj.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=aj.UIElements.Keybind,
Scale=.85,
})

ac.AddSignal(aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function aj.Lock(al)
aj.Locked=true
ak=false
return aj.KeybindFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(al)
aj.Locked=false
ak=true
return aj.KeybindFrame:Unlock()
end

function aj.Set(al,am)
local an=NormalizeKeyCode(am)
aj.Value=an
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
end

if aj.Locked then
aj:Lock()
end

ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
if aj.CanChange then
aj.Picking=true
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=ab.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

local ao
ao=ab.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1 or an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2 then
aj.Picking=false

aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
aj.Value=an

al:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)

ac.AddSignal(ab.InputBegan,function(al,am)
if ab:GetFocusedTextBox()then
return
end

if not ak then
return
end

if al.UserInputType==Enum.UserInputType.Keyboard then
if al.KeyCode.Name==aj.Value then
ac.SafeCallback(aj.Callback,al.KeyCode.Name)
end
elseif al.UserInputType==Enum.UserInputType.MouseButton1 and aj.Value=="MouseLeft"then
ac.SafeCallback(aj.Callback,"MouseLeft")
elseif al.UserInputType==Enum.UserInputType.MouseButton2 and aj.Value=="MouseRight"then
ac.SafeCallback(aj.Callback,"MouseRight")
end
end)

return aj.__type,aj
end

return af end function a.M():typeof(__modImpl())local aa=a.cache.M if not aa then aa={c=__modImpl()}a.cache.M=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ab=aa.New local ac=
aa.Tween

local ad={
UICorner=8,
UIPadding=8,
}local ae=a.e()


.New
local af=a.l().New

function ad.New(ag,ah)
local ai={
__type="Input",
Title=ah.Title or"Input",
Desc=ah.Desc or nil,
Type=ah.Type or"Input",
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
InputIcon=ah.InputIcon or false,
Placeholder=ah.Placeholder or"Enter Text...",
Value=ah.Value or"",
Callback=ah.Callback or function()end,
ClearTextOnFocus=ah.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local aj=true

ai.InputFrame=a.D(){
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
ParentConfig=ah,
}

local ak=af(
ai.Placeholder,
ai.InputIcon,
ai.Type=="Textarea"and ai.InputFrame.UIElements.Container or ai.InputFrame.UIElements.Main,
ai.Type,
function(ak)
ai:Set(ak,true)
end,
nil,
10,
ai.ClearTextOnFocus
)

if ai.Type=="Input"then
ak.Size=UDim2.new(0,ai.Width,0,36)
ak.Position=UDim2.new(1,0,0.5,0)
ak.AnchorPoint=Vector2.new(1,0.5)
else
ak.Size=UDim2.new(1,0,0,148)
end

ab("UIScale",{
Parent=ak,
Scale=1,
})

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.InputFrame:Lock(ai.LockedTitle)
end
function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.InputFrame:Unlock()
end


function ai.Set(al,am,an)
if aj then
ai.Value=am
aa.SafeCallback(ai.Callback,am)

if not an then
ak.Frame.Frame.TextBox.Text=am
end
end
end

function ai.SetPlaceholder(al,am)
ak.Frame.Frame.TextBox.PlaceholderText=am
ai.Placeholder=am
end

ai:Set(ai.Value)

if ai.Locked then
ai:Lock()
end

return ai.__type,ai
end

return ad end function a.N():typeof(__modImpl())local aa=a.cache.N if not aa then aa={c=__modImpl()}a.cache.N=aa end return aa.c end end do local function __modImpl()

local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)

local ad=ab(game:GetService"UserInputService")
local ae=ab(game:GetService"Players").LocalPlayer:GetMouse()
local af=ab(game:GetService"Workspace").CurrentCamera

local ag=workspace.CurrentCamera

local ah=a.l().New

local ai=a.c()
local aj=ai.New
local ak=ai.Tween

function aa.New(al,am,an,ao,ap)
local aq={}

if not am.Callback then
ap="Menu"
end

am.UIElements.UIListLayout=aj("UIListLayout",{
Padding=UDim.new(0,an.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

am.UIElements.Menu=ai.NewRoundFrame(an.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,an.MenuPadding),
PaddingLeft=UDim.new(0,an.MenuPadding),
PaddingRight=UDim.new(0,an.MenuPadding),
PaddingBottom=UDim.new(0,an.MenuPadding),
}),
aj("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.MenuPadding)
}),
aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,am.SearchBarEnabled and-an.MenuPadding-an.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
am.UIElements.UIListLayout,
})
})
})

am.UIElements.MenuCanvas=aj("Frame",{
Size=UDim2.new(0,am.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=al.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
am.UIElements.Menu,
aj("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
})
})

local function RecalculateCanvasSize()
am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,am.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
local ar=ag.ViewportSize.Y*0.6

local as=am.UIElements.UIListLayout.AbsoluteContentSize.Y
local at=am.SearchBarEnabled and(an.SearchBarHeight+(an.MenuPadding*3))or(an.MenuPadding*2)
local au=(as)+at

if au>ar then
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(
am.UIElements.MenuCanvas.AbsoluteSize.X,
ar
)
else
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(
am.UIElements.MenuCanvas.AbsoluteSize.X,
au
)
end
end

function UpdatePosition()
local ar=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local as=am.UIElements.MenuCanvas

local at=af.ViewportSize.Y-(ar.AbsolutePosition.Y+ar.AbsoluteSize.Y)-an.MenuPadding-54
local au=as.AbsoluteSize.Y+an.MenuPadding

local av=-54
if at<au then
av=au-at-54
end

as.Position=UDim2.new(
0,
ar.AbsolutePosition.X+ar.AbsoluteSize.X,
0,
ar.AbsolutePosition.Y+ar.AbsoluteSize.Y-av+(an.MenuPadding*2)
)
end

local ar

function aq.Display(as)
local at=am.Values
local au=""

if am.Multi then
local av={}
if typeof(am.Value)=="table"then
for aw,ax in ipairs(am.Value)do
local ay=typeof(ax)=="table"and ax.Title or ax
av[ay]=true
end
end

for aw,ax in ipairs(at)do
local ay=typeof(ax)=="table"and ax.Title or ax
if av[ay]then
au=au..ay..", "
end
end

if#au>0 then
au=au:sub(1,#au-2)
end
else
au=typeof(am.Value)=="table"and am.Value.Title or am.Value or""
end

if am.UIElements.Dropdown then
am.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(au==""and"--"or au)
end
end

local function Callback(as)
aq:Display()
if am.Callback then
task.spawn(function()
ai.SafeCallback(am.Callback,am.Value)
end)
else
task.spawn(function()
ai.SafeCallback(as)
end)
end
end

function aq.LockValues(as,at)
if not at then return end

for au,av in next,am.Tabs do
if av and av.UIElements and av.UIElements.TabItem then
local aw=av.Name
local ax=false

for ay,az in next,at do
if aw==az then
ax=true
break
end
end

if ax then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

av.UIElements.TabItem.Active=false
av.Locked=true
else
if av.Selected then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=ap=="Dropdown"and 0.4 or 0.05}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=ap=="Dropdown"and 0.2 or 0}):Play()
end
end

av.UIElements.TabItem.Active=true
av.Locked=false
end
end
end
end

function aq.Refresh(as,at)
for au,av in next,am.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not av:IsA"UIListLayout"then
av:Destroy()
end
end

am.Tabs={}

if am.SearchBarEnabled then
if not ar then
ar=ah("Search...","search",am.UIElements.Menu,nil,function(au)
for av,aw in next,am.Tabs do
if string.find(string.lower(aw.Name),string.lower(au),1,true)then
aw.UIElements.TabItem.Visible=true
else
aw.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
ar.Size=UDim2.new(1,0,0,an.SearchBarHeight)
ar.Position=UDim2.new(0,0,0,0)
ar.Name="SearchBar"
end
end

for au,av in next,at do
if(av.Type~="Divider")then
local aw={
Name=typeof(av)=="table"and av.Title or av,
Desc=typeof(av)=="table"and av.Desc or nil,
Icon=typeof(av)=="table"and av.Icon or nil,
IconSize=typeof(av)=="table"and av.IconSize or nil,
Original=av,
Selected=false,
Locked=typeof(av)=="table"and av.Locked or false,
UIElements={},
}
local ax
if aw.Icon then
ax=ai.Image(
aw.Icon,
aw.Icon,
0,
al.Window.Folder,
"Dropdown",
true
)
ax.Size=UDim2.new(0,aw.IconSize or an.TabIcon,0,aw.IconSize or an.TabIcon)
ax.ImageLabel.ImageTransparency=ap=="Dropdown"and.2 or 0
aw.UIElements.TabIcon=ax
end
aw.UIElements.TabItem=ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,36),
AutomaticSize=aw.Desc and"Y",
ImageTransparency=1,
Parent=am.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not aw.Locked,
},{
ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,an.TabPadding),
PaddingLeft=UDim.new(0,an.TabPadding),
PaddingRight=UDim.new(0,an.TabPadding),
PaddingBottom=UDim.new(0,an.TabPadding),
}),
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding)
}),
ax,
aj("Frame",{
Size=UDim2.new(1,ax and-an.TabPadding-an.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
aj("TextLabel",{
Text=aw.Name,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and.4 or.05,
LayoutOrder=999,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
aj("TextLabel",{
Text=aw.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and.6 or.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=aw.Desc and true or false,
Name="Desc",
}),
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding/3),
FillDirection="Vertical",
}),
})
})
},true)

if aw.Locked then
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if am.Multi and typeof(am.Value)=="string"then
for ay,az in next,am.Values do
if typeof(az)=="table"then
if az.Title==am.Value then am.Value={az}end
else
if az==am.Value then am.Value={am.Value}end
end
end
end

if am.Multi then
local ay=false
if typeof(am.Value)=="table"then
for az,aA in ipairs(am.Value)do
local aB=typeof(aA)=="table"and aA.Title or aA
if aB==aw.Name then
ay=true
break
end
end
end
aw.Selected=ay
else
local ay=typeof(am.Value)=="table"and am.Value.Title or am.Value
aw.Selected=ay==aw.Name
end

if aw.Selected and not aw.Locked then
aw.UIElements.TabItem.ImageTransparency=.95
aw.UIElements.TabItem.Highlight.ImageTransparency=.75
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

am.Tabs[au]=aw

aq:Display()

if ap=="Dropdown"then
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then return end

if am.Multi then
if not aw.Selected then
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(am.Value,aw.Original)
else
if not am.AllowNone and#am.Value==1 then
return
end
aw.Selected=false
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end

for ay,az in next,am.Value do
if typeof(az)=="table"and(az.Title==aw.Name)or(az==aw.Name)then
table.remove(am.Value,ay)
break
end
end
end
else
for ay,az in next,am.Tabs do
ak(az.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(az.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(az.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if az.UIElements.TabIcon then
ak(az.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end
az.Selected=false
end
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
am.Value=aw.Original
end
Callback()
end)
elseif ap=="Menu"then
if not aw.Locked then
ai.AddSignal(aw.UIElements.TabItem.MouseEnter,function()
ak(aw.UIElements.TabItem,0.08,{ImageTransparency=.95}):Play()
end)
ai.AddSignal(aw.UIElements.TabItem.InputEnded,function()
ak(aw.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then return end
Callback(av.Callback or function()end)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.w()
:New{Parent=am.UIElements.Menu.Frame.ScrollingFrame}
end
end

local au=am.MenuWidth or 0
if au==0 then
for av,aw in next,am.Tabs do
if aw.UIElements.TabItem.Frame.UIListLayout then
au=math.max(au,aw.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)
end
end
end

am.UIElements.MenuCanvas.Size=UDim2.new(0,au+6+6+5+5+18+6+6,am.UIElements.MenuCanvas.Size.Y.Scale,am.UIElements.MenuCanvas.Size.Y.Offset)
Callback()

am.Values=at
end

aq:Refresh(am.Values)

function aq.Select(as,at)
if at then
am.Value=at
else
if am.Multi then
am.Value={}
else
am.Value=nil
end
end
aq:Refresh(am.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

function aq.Open(as)
if ao then
am.UIElements.Menu.Visible=true
am.UIElements.MenuCanvas.Visible=true
am.UIElements.MenuCanvas.Active=true
am.UIElements.Menu.Size=UDim2.new(
1,0,
0,0
)
ak(am.UIElements.Menu,0.1,{
Size=UDim2.new(
1,0,
1,0
),
ImageTransparency=0.05
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
am.Opened=true
end)

UpdatePosition()
end
end

function aq.Close(as)
am.Opened=false

ak(am.UIElements.Menu,0.25,{
Size=UDim2.new(
1,0,
0,0
),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
am.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(.25)
am.UIElements.MenuCanvas.Visible=false
am.UIElements.MenuCanvas.Active=false
end)
end

ai.AddSignal((am.UIElements.Dropdown and am.UIElements.Dropdown.MouseButton1Click or am.DropdownFrame.UIElements.Main.MouseButton1Click),function()
aq:Open()
end)

ai.AddSignal(ad.InputBegan,function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
local at=am.UIElements.MenuCanvas
local au,av=at.AbsolutePosition,at.AbsoluteSize

local aw=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local ax=aw.AbsolutePosition
local ay=aw.AbsoluteSize

local az=
ae.X>=ax.X and
ae.X<=ax.X+ay.X and
ae.Y>=ax.Y and
ae.Y<=ax.Y+ay.Y

local aA=
ae.X>=au.X and
ae.X<=au.X+av.X and
ae.Y>=au.Y and
ae.Y<=au.Y+av.Y

if al.Window.CanDropdown and am.Opened and not az and not aA then
aq:Close()
end
end
end)

ai.AddSignal(
am.UIElements.Dropdown and am.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"or
am.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return aq
end

return aa end function a.O():typeof(__modImpl())local aa=a.cache.O if not aa then aa={c=__modImpl()}a.cache.O=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ab=
aa(game:GetService"Workspace").CurrentCamera

local ad=a.c()
local ae=ad.New local af=
ad.Tween

local ag=a.u().New local ah=a.l()
.New
local ai=a.O().New local aj=

workspace.CurrentCamera

local ak={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function ak.New(al,am)
local an={
__type="Dropdown",
Title=am.Title or"Dropdown",
Desc=am.Desc or nil,
Locked=am.Locked or false,
LockedTitle=am.LockedTitle,
Values=am.Values or{},
MenuWidth=am.MenuWidth,
Value=am.Value,
AllowNone=am.AllowNone,
SearchBarEnabled=am.SearchBarEnabled or false,
Multi=am.Multi,
Callback=am.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if an.Multi and not an.Value then
an.Value={}
end
if an.Values and typeof(an.Value)=="number"then
an.Value=an.Values[an.Value]
end

local ao=true

an.DropdownFrame=a.D(){
Title=an.Title,
Desc=an.Desc,
Parent=am.Parent,
TextOffset=an.Callback and an.Width or 20,
Hover=not an.Callback and true or false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
ParentConfig=am,
}


if an.Callback then
an.UIElements.Dropdown=ag("",nil,an.DropdownFrame.UIElements.Main,nil,10)

an.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
an.UIElements.Dropdown.Frame.Frame.TextLabel.Size=UDim2.new(1,an.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

an.UIElements.Dropdown.Size=UDim2.new(0,an.Width,0,36)
an.UIElements.Dropdown.Position=UDim2.new(1,0,0.5,0)
an.UIElements.Dropdown.AnchorPoint=Vector2.new(1,0.5)








end

an.DropdownMenu=ai(am,an,ak,ao,"Dropdown")


an.Display=an.DropdownMenu.Display
an.Refresh=an.DropdownMenu.Refresh
an.Select=an.DropdownMenu.Select
an.Open=an.DropdownMenu.Open
an.Close=an.DropdownMenu.Close

ae("ImageLabel",{
Image=ad.Icon"chevrons-up-down"[1],
ImageRectOffset=ad.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ad.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(
1,
an.UIElements.Dropdown and-12 or 0,
0.5,
0
),
ThemeTag={
ImageColor3="Icon"
},
AnchorPoint=Vector2.new(1,0.5),
Parent=an.UIElements.Dropdown and an.UIElements.Dropdown.Frame or an.DropdownFrame.UIElements.Main
})



function an.Lock(ap)
an.Locked=true
ao=false
return an.DropdownFrame:Lock(an.LockedTitle)
end
function an.Unlock(ap)
an.Locked=false
ao=true
return an.DropdownFrame:Unlock()
end

if an.Locked then
an:Lock()
end


return an.__type,an
end

return ak end function a.P():typeof(__modImpl())local aa=a.cache.P if not aa then aa={c=__modImpl()}a.cache.P=aa end return aa.c end end do local function __modImpl()







local aa={}
local ad={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local ae={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ag)
local ai={}
for aj,ak in ipairs(ag)do
ai[ak]=true
end
return ai
end

local ag=createKeywordSet(ad.lua)
local ai=createKeywordSet(ad.rbx)
local aj=createKeywordSet(ad.operators)

local function getHighlight(ak,al)
local am=ak[al]

if ae[am.."_color"]then
return ae[am.."_color"]
end

if tonumber(am)then
return ae.numbers
elseif am=="nil"then
return ae.null
elseif am:sub(1,2)=="--"then
return ae.comment
elseif aj[am]then
return ae.operator
elseif ag[am]then
return ae.lua
elseif ai[am]then
return ae.rbx
elseif am:sub(1,1)=="\""or am:sub(1,1)=="\'"then
return ae.str
elseif am=="true"or am=="false"then
return ae.boolean
end

if ak[al+1]=="("then
if ak[al-1]==":"then
return ae.self_call
end

return ae.call
end

if ak[al-1]=="."then
if ak[al-2]=="Enum"then
return ae.rbx
end

return ae.local_property
end
end

function aa.run(ak)
local al={}
local am=""

local an=false
local ao=false
local ap=false

for aq=1,#ak do
local ar=ak:sub(aq,aq)

if ao then
if ar=="\n"and not ap then
table.insert(al,am)
table.insert(al,ar)
am=""

ao=false
elseif ak:sub(aq-1,aq)=="]]"and ap then
am=am.."]"

table.insert(al,am)
am=""

ao=false
ap=false
else
am=am..ar
end
elseif an then
if ar==an and ak:sub(aq-1,aq-1)~="\\"or ar=="\n"then
am=am..ar
an=false
else
am=am..ar
end
else
if ak:sub(aq,aq+1)=="--"then
table.insert(al,am)
am="-"
ao=true
ap=ak:sub(aq+2,aq+3)=="[["
elseif ar=="\""or ar=="\'"then
table.insert(al,am)
am=ar
an=ar
elseif aj[ar]then
table.insert(al,am)
table.insert(al,ar)
am=""
elseif ar:match"[%w_]"then
am=am..ar
else
table.insert(al,am)
table.insert(al,ar)
am=""
end
end
end

table.insert(al,am)

local aq={}

for ar,as in ipairs(al)do
local at=getHighlight(al,ar)

if at then
local au=string.format("<font color = \"#%s\">%s</font>",at:ToHex(),as:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(aq,au)
else
table.insert(aq,as)
end
end

return table.concat(aq)
end

return aa end function a.Q():typeof(__modImpl())local aa=a.cache.Q if not aa then aa={c=__modImpl()}a.cache.Q=aa end return aa.c end end do local function __modImpl()
local aa={}

local ad=a.c()
local ae=ad.New
local ag=ad.Tween

local ai=a.Q()

function aa.New(aj,ak,al,am,an)
local ao={
Radius=12,
Padding=10
}

local ap=ae("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ao.Padding+3),
PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),
PaddingBottom=UDim.new(0,ao.Padding+3),
})
})
ap.Font="Code"

local aq=ae("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ap
})

local ar=ae("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ao.Padding/2,0,ao.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=am and true or false,
},{
ad.NewRoundFrame(ao.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ae("UIScale",{
Scale=1,
}),
ae("ImageLabel",{
Image=ad.Icon"copy"[1],
ImageRectSize=ad.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ad.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ad.AddSignal(ar.MouseEnter,function()
ag(ar.Button,.05,{ImageTransparency=.95}):Play()
ag(ar.Button.UIScale,.05,{Scale=.9}):Play()
end)
ad.AddSignal(ar.InputEnded,function()
ag(ar.Button,.08,{ImageTransparency=1}):Play()
ag(ar.Button.UIScale,.08,{Scale=1}):Play()
end)

local as=ad.NewRoundFrame(ao.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
AutomaticSize="Y",
Parent=al,
},{
ad.NewRoundFrame(ao.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ad.NewRoundFrame(ao.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
Visible=ak and true or false
},{
ae("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
ae("TextLabel",{
Text=ak,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,ar and-20-(ao.Padding*2),0,0)
}),
ae("UIPadding",{

PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),

}),
ae("UIListLayout",{
Padding=UDim.new(0,ao.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
aq,
ae("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
ar,
})

ao.CodeFrame=as

ad.AddSignal(ap:GetPropertyChangedSignal"TextBounds",function()
aq.Size=UDim2.new(1,0,0,(ap.TextBounds.Y/(an or 1))+((ao.Padding+3)*2))
end)

function ao.Set(at)
ap.Text=ai.run(at)
end

function ao.Destroy()
as:Destroy()
ao=nil
end

ao.Set(aj)

ad.AddSignal(ar.MouseButton1Click,function()
if am then
am()
local at=ad.Icon"check"
ar.Button.ImageLabel.Image=at[1]
ar.Button.ImageLabel.ImageRectSize=at[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=at[2].ImageRectPosition

task.wait(1)
local au=ad.Icon"copy"
ar.Button.ImageLabel.Image=au[1]
ar.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition
end
end)
return ao
end


return aa end function a.R():typeof(__modImpl())local aa=a.cache.R if not aa then aa={c=__modImpl()}a.cache.R=aa end return aa.c end end do local function __modImpl()
local aa=a.c()local ad=
aa.New


local ae=a.R()

local ag={}

function ag.New(ai,aj)
local ak={
__type="Code",
Title=aj.Title,
Code=aj.Code,
OnCopy=aj.OnCopy,
}

local al=not ak.Locked











local am=ae.New(ak.Code,ak.Title,aj.Parent,function()
if al then
local am=ak.Title or"code"
local an,ao=pcall(function()
local an=toclipboard or setclipboard
if not an then
error"Clipboard API is not available."
end

an(ak.Code)

if ak.OnCopy then ak.OnCopy()end
end)
if not an then
aj.WindUI:Notify{
Title="Error",
Content="The "..am.." is not copied. Error: "..ao,
Icon="x",
Duration=5,
}
end
end
end,aj.WindUI.UIScale,ak)

function ak.SetCode(an,ao)
am.Set(ao)
ak.Code=ao
end

function ak.Set(an,ao)
return ak.SetCode(ao)
end

function ak.Destroy(an)
am.Destroy()
ak=nil
end

ak.ElementFrame=am.CodeFrame

return ak.__type,ak
end

return ag end function a.S():typeof(__modImpl())local aa=a.cache.S if not aa then aa={c=__modImpl()}a.cache.S=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ad=aa.New local ae=
aa.Tween

local ag=(cloneref or clonereference or function(ag)return ag end)

local ai=ag(game:GetService"UserInputService")
ag(game:GetService"TouchInputService")
local aj=ag(game:GetService"RunService")
local ak=ag(game:GetService"Players")

local al=aj.RenderStepped
local am=ak.LocalPlayer
local an=am:GetMouse()

local ao=a.e().New
local ap=a.l().New

local aq={
UICorner=9,

}

function aq.Colorpicker(ar,as,at,au)
local av={
__type="Colorpicker",
Title=as.Title,
Desc=as.Desc,
Default=as.Value or as.Default,
Callback=as.Callback,
Transparency=as.Transparency,
UIElements=as.UIElements,

TextPadding=10,
}

function av.SetHSVFromRGB(aw,ax)
local ay,az,aA=Color3.toHSV(ax)
av.Hue=ay
av.Sat=az
av.Vib=aA
end

av:SetHSVFromRGB(av.Default)

local aw=a.m().Init(at)
local ax=aw.Create()

av.ColorpickerFrame=ax

ax.UIElements.Main.Size=UDim2.new(1,0,0,0)



local ay,az,aA=av.Hue,av.Sat,av.Vib

av.UIElements.Title=ad("TextLabel",{
Text=av.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,av.TextPadding/2),
PaddingLeft=UDim.new(0,av.TextPadding/2),
PaddingRight=UDim.new(0,av.TextPadding/2),
PaddingBottom=UDim.new(0,av.TextPadding/2),
})
})





local aB=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

av.UIElements.SatVibMap=ad("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+av.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(ay,1,1),
BackgroundTransparency=0,
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

aB,
})

av.UIElements.Inputs=ad("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(av.Transparency and 240 or 210,40+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local b=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=av.Transparency,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







b,
})

local d=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
d,
})

local f={}

for g=0,1,0.1 do
table.insert(f,ColorSequenceKeypoint.new(g,Color3.fromHSV(g,1,1)))
end

local g=ad("UIGradient",{
Color=ColorSequence.new(f),
Rotation=90,
})

local h=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local j=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=h,


BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local l=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+av.TextPadding),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
g,
h,
})


function CreateNewInput(m,p)
local r=ap(m,nil,av.UIElements.Inputs)

ad("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=r.Frame,
Text=m,
})

ad("UIScale",{
Parent=r,
Scale=.85,
})

r.Frame.Frame.TextBox.Text=p
r.Size=UDim2.new(0,150,0,42)

return r
end

local function ToRGB(m)
return{
R=math.floor(m.R*255),
G=math.floor(m.G*255),
B=math.floor(m.B*255)
}
end

local m=CreateNewInput("Hex","#"..av.Default:ToHex())

local p=CreateNewInput("Red",ToRGB(av.Default).R)
local r=CreateNewInput("Green",ToRGB(av.Default).G)
local u=CreateNewInput("Blue",ToRGB(av.Default).B)
local v
if av.Transparency then
v=CreateNewInput("Alpha",((1-av.Transparency)*100).."%")
end

local x=ad("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main,
LayoutOrder=4,
},{
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local z={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()au(Color3.fromHSV(av.Hue,av.Sat,av.Vib),av.Transparency)end
}
}

for A,B in next,z do
local C=ao(B.Title,B.Icon,B.Callback,B.Variant,x,ax,false)
C.Size=UDim2.new(0.5,-3,0,40)
C.AutomaticSize="None"
end



local A,B,C
if av.Transparency then
local F=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

B=ad("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=F,

},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

C=ad("Frame",{
Size=UDim2.fromScale(1,1),
},{
ad("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ad("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

A=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+av.TextPadding),
Parent=ax.UIElements.Main,
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ad("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
C,
F,
})
end

function av.Round(F,G,H)
if H==0 then
return math.floor(G)
end
G=tostring(G)
return G:find"%."and tonumber(G:sub(1,G:find"%."+H))or G
end


function av.Update(F,G,H)
if G then ay,az,aA=Color3.toHSV(G)else ay,az,aA=av.Hue,av.Sat,av.Vib end

av.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(ay,1,1)
aB.Position=UDim2.new(az,0,1-aA,0)
aB.BackgroundColor3=Color3.fromHSV(ay,az,aA)
d.BackgroundColor3=Color3.fromHSV(ay,az,aA)
j.BackgroundColor3=Color3.fromHSV(ay,1,1)
j.Position=UDim2.new(0.5,0,ay,0)

m.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(ay,az,aA):ToHex()
p.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).R
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).G
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).B

if H or av.Transparency then
d.BackgroundTransparency=av.Transparency or H
C.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundTransparency=av.Transparency or H
B.Position=UDim2.new(0.5,0,1-av.Transparency or H,0)
v.Frame.Frame.TextBox.Text=av:Round((1-av.Transparency or H)*100,0).."%"
end
end

av:Update(av.Default,av.Transparency)




local function GetRGB()
local F=Color3.fromHSV(av.Hue,av.Sat,av.Vib)
return{R=math.floor(F.r*255),G=math.floor(F.g*255),B=math.floor(F.b*255)}
end



local function clamp(F,G,H)
return math.clamp(tonumber(F)or 0,G,H)
end

aa.AddSignal(m.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=m.Frame.Frame.TextBox.Text:gsub("#","")
local H,J=pcall(Color3.fromHex,G)
if H and typeof(J)=="Color3"then
av.Hue,av.Sat,av.Vib=Color3.toHSV(J)
av:Update()
av.Default=J
end
end
end)

local function updateColorFromInput(F,G)
aa.AddSignal(F.Frame.Frame.TextBox.FocusLost,function(H)
if H then
local J=F.Frame.Frame.TextBox
local L=GetRGB()
local M=clamp(J.Text,0,255)
J.Text=tostring(M)

L[G]=M
local N=Color3.fromRGB(L.R,L.G,L.B)
av.Hue,av.Sat,av.Vib=Color3.toHSV(N)
av:Update()
end
end)
end

updateColorFromInput(p,"R")
updateColorFromInput(r,"G")
updateColorFromInput(u,"B")

if av.Transparency then
aa.AddSignal(v.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=v.Frame.Frame.TextBox
local H=clamp(G.Text,0,100)
G.Text=tostring(H)

av.Transparency=1-H*0.01
av:Update(nil,av.Transparency)
end
end)
end



local F=av.UIElements.SatVibMap
aa.AddSignal(F.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=F.AbsolutePosition.X
local J=H+F.AbsoluteSize.X
local L=math.clamp(an.X,H,J)

local M=F.AbsolutePosition.Y
local N=M+F.AbsoluteSize.Y
local O=math.clamp(an.Y,M,N)

av.Sat=(L-H)/(J-H)
av.Vib=1-((O-M)/(N-M))
av:Update()

al:Wait()
end
end
end)

aa.AddSignal(l.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=l.AbsolutePosition.Y
local J=H+l.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Hue=((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)

if av.Transparency then
aa.AddSignal(A.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=A.AbsolutePosition.Y
local J=H+A.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Transparency=1-((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)
end

return av
end

function aq.New(ar,as)
local at={
__type="Colorpicker",
Title=as.Title or"Colorpicker",
Desc=as.Desc or nil,
Locked=as.Locked or false,
LockedTitle=as.LockedTitle,
Default=as.Default or Color3.new(1,1,1),
Callback=as.Callback or function()end,

UIScale=as.UIScale,
Transparency=as.Transparency,
UIElements={}
}

local au=true



at.ColorpickerFrame=a.D(){
Title=at.Title,
Desc=at.Desc,
Parent=as.Parent,
TextOffset=40,
Hover=false,
Tab=as.Tab,
Index=as.Index,
Window=as.Window,
ElementTable=at,
ParentConfig=as,
}

at.UIElements.Colorpicker=aa.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=at.Default,
Parent=at.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function at.Lock(av)
at.Locked=true
au=false
return at.ColorpickerFrame:Lock(at.LockedTitle)
end
function at.Unlock(av)
at.Locked=false
au=true
return at.ColorpickerFrame:Unlock()
end

if at.Locked then
at:Lock()
end


function at.Update(av,aw,ax)
at.UIElements.Colorpicker.ImageTransparency=ax or 0
at.UIElements.Colorpicker.ImageColor3=aw
at.Default=aw
if ax then
at.Transparency=ax
end
end

function at.Set(av,aw,ax)
return at:Update(aw,ax)
end

aa.AddSignal(at.UIElements.Colorpicker.MouseButton1Click,function()
if au then
aq:Colorpicker(at,as.Window,function(av,aw)
at:Update(av,aw)
at.Default=av
at.Transparency=aw
aa.SafeCallback(at.Callback,av,aw)
end).ColorpickerFrame:Open()
end
end)

return at.__type,at
end

return aq end function a.T():typeof(__modImpl())local aa=a.cache.T if not aa then aa={c=__modImpl()}a.cache.T=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ad=aa.New
local ae=aa.Tween

local ag={}

local function IsPressInput(ai)
return ai.UserInputType==Enum.UserInputType.MouseButton1
or ai.UserInputType==Enum.UserInputType.Touch
end

function ag.New(ai,aj)
local ak={
__type="Section",
Title=aj.Title or"Section",
Desc=aj.Desc,
Icon=aj.Icon,
TextXAlignment=aj.TextXAlignment or"Left",
TextSize=aj.TextSize or 19,
DescTextSize=aj.DescTextSize or 16,
Box=aj.Box or false,
BoxBorder=aj.BoxBorder or false,
FontWeight=aj.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=aj.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=aj.TextTransparency or 0.05,
DescTextTransparency=aj.DescTextTransparency or 0.4,
HoverFeedback=aj.Hover~=false,
Opened=aj.Opened or false,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
UIElements={},

HeaderSize=aj.HeaderSize or 42,
IconSize=aj.IconSize or 20,
HeaderGap=aj.HeaderGap or 10,
HeaderPaddingX=aj.HeaderPaddingX
or(aj.Window.ElementConfig.UIPadding+(aj.Window.ModernLayout and 4 or 2)),
HeaderPaddingY=aj.HeaderPaddingY
or math.max(math.floor((aj.Window.ElementConfig.UIPadding+(aj.Window.ModernLayout and 4 or 0))*0.65),6),

Elements={},

Expandable=false,
}

local al
local am=false
local an=false

local ao=ad("Frame",{
Size=UDim2.new(0,ak.IconSize+10,0,ak.IconSize+10),
BackgroundTransparency=1,
Visible=false,
})

local function createTitle(ap,aq)
return ad("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=ak.TextXAlignment,
AutomaticSize="Y",
TextSize=aq and ak.DescTextSize or ak.TextSize,
TextTransparency=aq and ak.DescTextTransparency or ak.TextTransparency,
ThemeTag={
TextColor3=aq and"SectionDesc"or"SectionTitle",
},
FontFace=Font.new(aa.Font,aq and ak.DescFontWeight or ak.FontWeight),
Text=ap,
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
})
end

local ap=ad("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=ak.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4),
}),
})

local aq=createTitle(ak.Title,false)
aq.Parent=ap

local ar
if ak.Desc and ak.Desc~=""then
ar=createTitle(ak.Desc,true)
ar.Parent=ap
end

local as=ad("Frame",{
Size=UDim2.new(0,ak.IconSize,0,ak.IconSize),
BackgroundTransparency=1,
Visible=false,
},{
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
}),
})

local at=ad("Frame",{
Size=UDim2.new(0,0,0,ak.IconSize),
AutomaticSize="X",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Right",
Padding=UDim.new(0,6),
}),
as,
})

local au=ad("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,ak.HeaderGap),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ao,
ap,
at,
})

local av=aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=aj.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag=ak.Box and{
ImageTransparency="SectionBoxBackgroundTransparency",
ImageColor3="SectionBoxBackground",
}or nil,
ImageTransparency=not ak.Box and 1 or nil,
},{
aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,aj.Window.ModernLayout and"Glass-1"or"SquircleOutline",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=ak.Box and ak.BoxBorder,
Name="Outline",
}),
ad("TextButton",{
Name="Top",
Size=UDim2.new(1,0,0,ak.HeaderSize),
AutomaticSize="Y",
BackgroundTransparency=1,
Active=false,
AutoButtonColor=false,
Text="",
ClipsDescendants=true,
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,ak.HeaderPaddingY),
PaddingBottom=UDim.new(0,ak.HeaderPaddingY),
PaddingLeft=UDim.new(0,ak.HeaderPaddingX),
PaddingRight=UDim.new(0,ak.HeaderPaddingX),
}),
au,
}),
ad("Frame",{
Name="HeaderDivider",
BackgroundTransparency=1,
Size=UDim2.new(1,-(ak.Box and aj.Window.ElementConfig.UIPadding*2 or 0),0,1),
Position=UDim2.new(0.5,0,0,ak.HeaderSize),
AnchorPoint=Vector2.new(0.5,0),
Visible=false,
ThemeTag={
BackgroundColor3="SectionContentDivider",
BackgroundTransparency="SectionContentDividerTransparency",
},
}),
ad("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Visible=false,
Position=UDim2.new(0,0,0,ak.HeaderSize),
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,ak.Box and 8 or 4),
PaddingLeft=UDim.new(0,ak.Box and aj.Window.ElementConfig.UIPadding or 0),
PaddingRight=UDim.new(0,ak.Box and aj.Window.ElementConfig.UIPadding or 0),
PaddingBottom=UDim.new(0,ak.Box and aj.Window.ElementConfig.UIPadding or 2),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,aj.Tab.Gap),
VerticalAlignment="Top",
}),
}),
})

ak.ElementFrame=av
ak.UIElements={
Main=av,
Top=av.Top,
Content=av.Content,
Icon=ao,
Title=aq,
Desc=ar,
Chevron=as.ImageLabel,
}

local function UpdateTitleSize()
local aw=ao.Visible and(ao.AbsoluteSize.X+ak.HeaderGap)or 0
local ax=at.AbsoluteSize.X>0 and(at.AbsoluteSize.X+ak.HeaderGap)or 0
ap.Size=UDim2.new(1,-(aw+ax),0,0)
end

local function UpdateContentLayout()
local aw=av.Top.AbsoluteSize.Y/aj.UIScale
av.Content.Position=UDim2.new(0,0,0,aw)
av.HeaderDivider.Position=UDim2.new(0.5,0,0,aw)
end

local function SetHoverState(aw)
if not ak.Box then
return
end

local ax=aa.GetThemeProperty("SectionBoxBackgroundTransparency",aa.Theme)
if typeof(ax)~="number"then
ax=0.95
end

local ay=math.max(ax-0.04,0)
local az=math.max(ax-0.1,0)

local aA=ax
if an then
aA=az
elseif am then
aA=ay
end

if aw then
av.ImageTransparency=aA
else
ae(av,0.12,{
ImageTransparency=aA,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function SetChevronState(aw,ax)
local ay=aw and 180 or 0
local az=aw and 0.1 or 0.25

if ax then
as.ImageLabel.Rotation=ay
as.ImageLabel.ImageTransparency=az
else
ae(as.ImageLabel,0.2,{
Rotation=ay,
ImageTransparency=az,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function SyncHeight(aw)
if not ak.Expandable then
return
end

UpdateContentLayout()

local ax=av.Top.AbsoluteSize.Y
local ay=ak.Opened and av.Content.AbsoluteSize.Y or 0
local az=(ax+ay)/aj.UIScale

local aA=UDim2.new(av.Size.X.Scale,av.Size.X.Offset,0,az)

if aw then
av.Size=aA
else
ae(av,ak.Opened and 0.33 or 0.24,{
Size=aA,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

av.HeaderDivider.Visible=ak.Opened and ak.Box and av.Content.AbsoluteSize.Y>0
end

local function EnsureExpandable()
if ak.Expandable then
return
end

ak.Expandable=true
as.Visible=true
av.Top.Active=not ak.Locked
av.Content.Visible=true
av.AutomaticSize="None"

UpdateTitleSize()
UpdateContentLayout()

if ak.Opened then
SetChevronState(true,true)
else
SetChevronState(false,true)
end

SyncHeight(true)
end

function ak.SetIcon(aw,ax)
ak.Icon=ax or nil

if al then
al:Destroy()
al=nil
end

ao.Visible=false

if ax then
al=aa.Image(
ax,
ax..":"..ak.Title,
0,
aj.Window.Folder,
ak.__type,
true,
true,
"SectionIcon"
)
al.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
al.Parent=ao
al.Position=UDim2.new(0.5,0,0.5,0)
al.AnchorPoint=Vector2.new(0.5,0.5)
ao.Visible=true
end

UpdateTitleSize()
end

function ak.SetTitle(aw,ax)
ak.Title=ax
aq.Text=ax
end

function ak.SetDesc(aw,ax)
ak.Desc=ax

if ax and ax~=""then
if not ar then
ar=createTitle(ax,true)
ar.Parent=ap
ak.UIElements.Desc=ar
end
ar.Text=ax
ar.Visible=true
elseif ar then
ar.Visible=false
ar.Text=""
end

if ak.Expandable then
SyncHeight(true)
end
end

function ak.Lock(aw)
ak.Locked=true
am=false
an=false
SetHoverState(true)

if ak.Expandable then
av.Top.Active=false
end

for ax,ay in next,ak.Elements do
if ay and ay.Lock then
ay:Lock()
end
end

return ak
end

function ak.Unlock(aw)
ak.Locked=false

if ak.Expandable then
av.Top.Active=true
end

for ax,ay in next,ak.Elements do
if ay and ay.Unlock then
ay:Unlock()
end
end

return ak
end

function ak.Destroy(aw)
for ax=#ak.Elements,1,-1 do
local ay=ak.Elements[ax]
if ay and ay.Destroy then
ay:Destroy()
end
end

av:Destroy()
end

function ak.Open(aw,ax)
if ak.Expandable then
ak.Opened=true
av.Content.Visible=true
SetChevronState(true,ax)
SyncHeight(ax)
end
end

function ak.Close(aw,ax)
if ak.Expandable then
ak.Opened=false
SetChevronState(false,ax)
SyncHeight(ax)
end
end

if ak.Icon then
ak:SetIcon(ak.Icon)
end

local aw=aj.ElementsModule

aw.Load(ak,av.Content,aw.Elements,aj.Window,aj.WindUI,function(ax)
EnsureExpandable()

if ak.Locked and ax and ax.Lock then
ax:Lock()
end

if ak.Opened then
ak:Open(true)
else
ak:Close(true)
end
end,aw,aj.UIScale,aj.Tab)

aa.AddSignal(av.Top:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateTitleSize()
UpdateContentLayout()

if ak.Expandable then
SyncHeight(true)
end
end)

aa.AddSignal(at:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateTitleSize()
end)

aa.AddSignal(av.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ak.Expandable then
SyncHeight(true)
end
end)

aa.AddSignal(av.Top.MouseEnter,function()
if not ak.HoverFeedback or ak.Locked then
return
end

am=true
SetHoverState(false)
end)

aa.AddSignal(av.Top.MouseLeave,function()
am=false
an=false
SetHoverState(false)
end)

aa.AddSignal(av.Top.InputBegan,function(ax)
if not ak.HoverFeedback or ak.Locked or not IsPressInput(ax)then
return
end

an=true
SetHoverState(false)
end)

aa.AddSignal(av.Top.InputEnded,function(ax)
if not ak.HoverFeedback or ak.Locked or not IsPressInput(ax)then
return
end

an=false
SetHoverState(false)
end)

aa.AddSignal(av.Top.Activated,function()
if ak.Locked then
return
end

if ak.Expandable then
if ak.Opened then
ak:Close()
else
ak:Open()
end
end
end)

task.defer(function()
UpdateTitleSize()
UpdateContentLayout()

if not ak.Expandable then
av.Content.Visible=false
av.Top.Active=false
av.Top.Size=UDim2.new(1,0,0,ak.HeaderSize)
av.Top.AutomaticSize="Y"
av.AutomaticSize="Y"
end

SetHoverState(true)
SetChevronState(ak.Opened,true)

if ak.Expandable then
if ak.Opened then
ak:Open(true)
else
ak:Close(true)
end
end

if ak.Locked then
ak:Lock()
end
end)

return ak.__type,ak
end

return ag end function a.U():typeof(__modImpl())local aa=a.cache.U if not aa then aa={c=__modImpl()}a.cache.U=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ad=aa.New
local ae=aa.Tween

local ag=(cloneref or clonereference or function(ag)return ag end)
local ai=ag(game:GetService"UserInputService")

local aj={}

local function IsPressInput(ak)
return ak.UserInputType==Enum.UserInputType.MouseButton1
or ak.UserInputType==Enum.UserInputType.Touch
end

local function ResolveTransparency(ak,al)
local am=aa.GetThemeProperty(ak,aa.Theme)
if typeof(am)~="number"then
return al
end
return am
end

function aj.New(ak,al)
local am={
__type="MultiSection",
Title=al.Title or"Section",
Desc=al.Desc,
Icon=al.Icon,
TextXAlignment=al.TextXAlignment or"Left",
TextSize=al.TextSize or 19,
DescTextSize=al.DescTextSize or 16,
Box=al.Box or false,
BoxBorder=al.BoxBorder or false,
FontWeight=al.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=al.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=al.TextTransparency or 0.05,
DescTextTransparency=al.DescTextTransparency or 0.4,
HoverFeedback=al.Hover~=false,
Opened=al.Opened or false,
Locked=al.Locked or false,
LockedTitle=al.LockedTitle,
UIElements={},

HeaderSize=al.HeaderSize or 42,
IconSize=al.IconSize or 20,
HeaderGap=al.HeaderGap or 10,
HeaderPaddingX=al.HeaderPaddingX
or(al.Window.ElementConfig.UIPadding+(al.Window.ModernLayout and 4 or 2)),
HeaderPaddingY=al.HeaderPaddingY
or math.max(math.floor((al.Window.ElementConfig.UIPadding+(al.Window.ModernLayout and 4 or 0))*0.65),6),

TabGap=al.TabGap or 6,
TabPaddingX=al.TabPaddingX or 12,
TabPaddingY=al.TabPaddingY or 8,
TabTextSize=al.TabTextSize or 15,
TabDescTextSize=al.TabDescTextSize or 13,

Tabs={},
Elements={},

SelectedTab=nil,
SelectedTabIndex=nil,

Expandable=false,
}

local an
local ao=false
local ap=false
local aq=false
local ar=false
local as=false

local at=al.Tab
and al.Tab.UIElements
and al.Tab.UIElements.ContainerFrame

local au="__windui_multisection_scroll_lock_count"
local av="__windui_multisection_scroll_lock_restore"

local aw=ad("Frame",{
Size=UDim2.new(0,am.IconSize+10,0,am.IconSize+10),
BackgroundTransparency=1,
Visible=false,
})

local function createTitle(ax,ay)
return ad("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=am.TextXAlignment,
AutomaticSize="Y",
TextSize=ay and am.DescTextSize or am.TextSize,
TextTransparency=ay and am.DescTextTransparency or am.TextTransparency,
ThemeTag={
TextColor3=ay and"SectionDesc"or"SectionTitle",
},
FontFace=Font.new(aa.Font,ay and am.DescFontWeight or am.FontWeight),
Text=ax,
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
})
end

local ax=ad("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=am.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4),
}),
})

local ay=createTitle(am.Title,false)
ay.Parent=ax

local az
if am.Desc and am.Desc~=""then
az=createTitle(am.Desc,true)
az.Parent=ax
end

local aA=ad("Frame",{
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
BackgroundTransparency=1,
Visible=false,
},{
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
}),
})

local aB=ad("Frame",{
Size=UDim2.new(0,0,0,am.IconSize),
AutomaticSize="X",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Right",
Padding=UDim.new(0,6),
}),
aA,
})

local b=ad("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,am.HeaderGap),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aw,
ax,
aB,
})

local d=aa.NewRoundFrame(al.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=al.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag=am.Box and{
ImageTransparency="SectionBoxBackgroundTransparency",
ImageColor3="SectionBoxBackground",
}or nil,
ImageTransparency=not am.Box and 1 or nil,
},{
aa.NewRoundFrame(al.Window.ElementConfig.UICorner,al.Window.ModernLayout and"Glass-1"or"SquircleOutline",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=am.Box and am.BoxBorder,
Name="Outline",
}),
ad("TextButton",{
Name="Top",
Size=UDim2.new(1,0,0,am.HeaderSize),
AutomaticSize="Y",
BackgroundTransparency=1,
Active=false,
AutoButtonColor=false,
Text="",
ClipsDescendants=true,
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,am.HeaderPaddingY),
PaddingBottom=UDim.new(0,am.HeaderPaddingY),
PaddingLeft=UDim.new(0,am.HeaderPaddingX),
PaddingRight=UDim.new(0,am.HeaderPaddingX),
}),
b,
}),
ad("Frame",{
Name="HeaderDivider",
BackgroundTransparency=1,
Size=UDim2.new(1,-(am.Box and al.Window.ElementConfig.UIPadding*2 or 0),0,1),
Position=UDim2.new(0.5,0,0,am.HeaderSize),
AnchorPoint=Vector2.new(0.5,0),
Visible=false,
ThemeTag={
BackgroundColor3="SectionContentDivider",
BackgroundTransparency="SectionContentDividerTransparency",
},
}),
ad("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Visible=false,
Position=UDim2.new(0,0,0,am.HeaderSize),
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,am.Box and 8 or 4),
PaddingLeft=UDim.new(0,am.Box and al.Window.ElementConfig.UIPadding or 0),
PaddingRight=UDim.new(0,am.Box and al.Window.ElementConfig.UIPadding or 0),
PaddingBottom=UDim.new(0,am.Box and al.Window.ElementConfig.UIPadding or 2),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,am.TabGap),
VerticalAlignment="Top",
}),
ad("Frame",{
Name="Tabs",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{
ad("ScrollingFrame",{
Name="Scroll",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
ScrollingDirection="X",
AutomaticCanvasSize="None",
ScrollingEnabled=true,
ElasticBehavior="Never",
ClipsDescendants=true,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,am.TabGap),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
}),
}),
ad("Frame",{
Name="TabsContent",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
}),
}),
})

am.ElementFrame=d
am.UIElements={
Main=d,
Top=d.Top,
Content=d.Content,
Tabs=d.Content.Tabs,
TabsScroll=d.Content.Tabs.Scroll,
TabsContent=d.Content.TabsContent,
Icon=aw,
Title=ay,
Desc=az,
Chevron=aA.ImageLabel,
}

local f=d.Content.Tabs.Scroll.UIListLayout

local function UpdateTitleSize()
local g=aw.Visible and(aw.AbsoluteSize.X+am.HeaderGap)or 0
local h=aB.AbsoluteSize.X>0 and(aB.AbsoluteSize.X+am.HeaderGap)or 0
ax.Size=UDim2.new(1,-(g+h),0,0)
end

local function SetWindowScrollLock(g)
if not at then
as=false
return
end

if g and not as then
as=true

local h=at:GetAttribute(au)or 0
if h<=0 then
at:SetAttribute(av,at.ScrollingEnabled)
end

at:SetAttribute(au,h+1)
at.ScrollingEnabled=false
return
end

if(not g)and as then
as=false

local h=at:GetAttribute(au)or 0
h=math.max(h-1,0)

if h>0 then
at:SetAttribute(au,h)
return
end

local j=at:GetAttribute(av)
at:SetAttribute(au,nil)
at:SetAttribute(av,nil)
at.ScrollingEnabled=typeof(j)=="boolean"and j or true
end
end

local function UpdateWindowScrollLock()
local g=aq and ar and am.Opened and not am.Locked
SetWindowScrollLock(g)
end

local function UpdateTabsAlignment()
local g=am.UIElements.Tabs
local h=am.UIElements.TabsScroll

local j=h.AbsoluteSize.X
local l=f.AbsoluteContentSize.X
local m=f.AbsoluteContentSize.Y
local p=math.max(m,0)

g.Size=UDim2.new(1,0,0,p)
h.Size=UDim2.new(1,0,0,p)
h.CanvasSize=UDim2.new(0,math.max(l,j),0,p)

if j<=0 or l<=0 then
ar=false
f.HorizontalAlignment=Enum.HorizontalAlignment.Left
h.ScrollingEnabled=false
h.CanvasPosition=Vector2.new(0,0)
UpdateWindowScrollLock()
return
end

ar=l>j

if l<=j then
f.HorizontalAlignment=Enum.HorizontalAlignment.Center
h.ScrollingEnabled=false
h.CanvasPosition=Vector2.new(0,0)
else
f.HorizontalAlignment=Enum.HorizontalAlignment.Left
h.ScrollingEnabled=true

local r=math.max(h.AbsoluteCanvasSize.X-j,0)
local u=math.clamp(h.CanvasPosition.X,0,r)

if u~=h.CanvasPosition.X then
h.CanvasPosition=Vector2.new(u,0)
end
end

UpdateWindowScrollLock()
end

local function UpdateContentLayout()
local g=d.Top.AbsoluteSize.Y/al.UIScale
d.Content.Position=UDim2.new(0,0,0,g)
d.HeaderDivider.Position=UDim2.new(0.5,0,0,g)
end

local function SetHoverState(g)
if not am.Box then
return
end

local h=ResolveTransparency("SectionBoxBackgroundTransparency",0.95)
local j=math.max(h-0.04,0)
local l=math.max(h-0.1,0)

local m=h
if ap then
m=l
elseif ao then
m=j
end

if g then
d.ImageTransparency=m
else
ae(d,0.12,{
ImageTransparency=m,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function SetChevronState(g,h)
local j=g and 180 or 0
local l=g and 0.1 or 0.25

if h then
aA.ImageLabel.Rotation=j
aA.ImageLabel.ImageTransparency=l
else
ae(aA.ImageLabel,0.2,{
Rotation=j,
ImageTransparency=l,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function SyncHeight(g)
if not am.Expandable then
return
end

UpdateTabsAlignment()
UpdateContentLayout()

local h=d.Top.AbsoluteSize.Y
local j=am.Opened and d.Content.AbsoluteSize.Y or 0
local l=(h+j)/al.UIScale

local m=UDim2.new(d.Size.X.Scale,d.Size.X.Offset,0,l)

if g then
d.Size=m
else
ae(d,am.Opened and 0.33 or 0.24,{
Size=m,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

d.HeaderDivider.Visible=am.Opened and am.Box and d.Content.AbsoluteSize.Y>0
end

local function EnsureExpandable()
if am.Expandable then
return
end

am.Expandable=true
aA.Visible=true
d.Top.Active=not am.Locked
d.Content.Visible=true
d.AutomaticSize="None"

UpdateTitleSize()
UpdateContentLayout()

if am.Opened then
SetChevronState(true,true)
else
SetChevronState(false,true)
end

SyncHeight(true)
end

local function ResolveTab(g)
if typeof(g)=="table"then
return g
end

if typeof(g)=="number"then
return am.Tabs[g]
end

if typeof(g)=="string"then
for h,j in next,am.Tabs do
if j.Title==g then
return j
end
end
end

return nil
end

local function SetTabState(g,h,j)
if not g or not g.UIElements or not g.UIElements.Button then
return
end

local l
local m
local p
local r
local u

if h=="Selected"then
l=ResolveTransparency("TabBackgroundActiveTransparency",0.93)
m=ResolveTransparency("TabBorderTransparencyActive",0.75)
p=0.05
r=0.35
u=0
elseif h=="Hover"then
l=ResolveTransparency("TabBackgroundHoverTransparency",0.97)
m=ResolveTransparency("TabBorderTransparency",1)
p=0.25
r=0.5
u=0.2
else
l=1
m=1
p=0.4
r=0.6
u=0.35
end

local v=g.UIElements.Button
local x=g.UIElements.Outline
local z=g.UIElements.Title
local A=g.UIElements.Desc
local B=g.UIElements.Icon and g.UIElements.Icon.ImageLabel

if j then
v.ImageTransparency=l
if x then
x.ImageTransparency=m
end
if z then
z.TextTransparency=p
end
if A then
A.TextTransparency=r
end
if B then
B.ImageTransparency=u
end
else
ae(v,0.1,{
ImageTransparency=l,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if x then
ae(x,0.1,{
ImageTransparency=m,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if z then
ae(z,0.1,{
TextTransparency=p,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if A then
ae(A,0.1,{
TextTransparency=r,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if B then
ae(B,0.1,{
ImageTransparency=u,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

local function SetTabElementsLocked(g)
for h,j in next,am.Tabs do
if j and j.Elements then
for l,m in next,j.Elements do
if g then
if m and m.Lock then
m:Lock()
end
else
if m and m.Unlock then
m:Unlock()
end
end
end
end
end
end

function am.SetIcon(g,h)
am.Icon=h or nil

if an then
an:Destroy()
an=nil
end

aw.Visible=false

if h then
an=aa.Image(
h,
h..":"..am.Title,
0,
al.Window.Folder,
am.__type,
true,
true,
"SectionIcon"
)
an.Size=UDim2.new(0,am.IconSize,0,am.IconSize)
an.Parent=aw
an.Position=UDim2.new(0.5,0,0.5,0)
an.AnchorPoint=Vector2.new(0.5,0.5)
aw.Visible=true
end

UpdateTitleSize()
end

function am.SetTitle(g,h)
am.Title=h
ay.Text=h
end

function am.SetDesc(g,h)
am.Desc=h

if h and h~=""then
if not az then
az=createTitle(h,true)
az.Parent=ax
am.UIElements.Desc=az
end
az.Text=h
az.Visible=true
elseif az then
az.Visible=false
az.Text=""
end

if am.Expandable then
SyncHeight(true)
end
end

function am.Lock(g)
am.Locked=true
ao=false
ap=false
aq=false
SetHoverState(true)

if am.Expandable then
d.Top.Active=false
end

SetTabElementsLocked(true)
SetWindowScrollLock(false)

return am
end

function am.Unlock(g)
am.Locked=false

if am.Expandable then
d.Top.Active=true
end

SetTabElementsLocked(false)
UpdateWindowScrollLock()

return am
end

function am.SelectTab(g,h,j)
local l=ResolveTab(h)
if not l then
return nil
end

if am.SelectedTab==l then
return l
end

if am.SelectedTab and am.SelectedTab.UIElements.Content then
am.SelectedTab.UIElements.Content.Parent=nil
SetTabState(am.SelectedTab,"Default",j)
end

am.SelectedTab=l
am.SelectedTabIndex=l.Index

l.UIElements.Content.Parent=am.UIElements.TabsContent
SetTabState(l,"Selected",j)

SyncHeight(j)
return l
end

function am.GetSelectedTab(g)
return am.SelectedTab
end

function am.GetTabs(g)
return am.Tabs
end

function am.Tab(g,h)
h=h or{}

EnsureExpandable()

local j={
__type="MultiSectionTab",
Title=h.Title or("Tab "..tostring(#am.Tabs+1)),
Desc=h.Desc,
Icon=h.Icon,
IconThemed=h.IconThemed,
Parent=am,
Elements={},
UIElements={},
Index=#am.Tabs+1,
Gap=al.Tab and al.Tab.Gap or(al.Window.ModernLayout and 1 or 6),
}

local l
if j.Icon then
l=aa.Image(
j.Icon,
j.Icon..":"..am.Title..":"..j.Title,
0,
al.Window.Folder,
"Tab",
true,
j.IconThemed,
"TabIcon"
)
l.Size=UDim2.new(0,16,0,16)
end

local m=j.Desc and j.Desc~=""
local p=m and"Left"or"Center"
local r=l and 24 or 0

local u=m and ad("TextLabel",{
Name="Desc",
BackgroundTransparency=1,
AutomaticSize="XY",
Text=j.Desc or"",
Visible=true,
TextXAlignment="Left",
TextYAlignment="Top",
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
TextSize=am.TabDescTextSize,
TextTransparency=0.6,
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,r),
}),
})or nil

local v=aa.NewRoundFrame(math.max(al.Window.ElementConfig.UICorner-2,6),"Squircle",{
Size=UDim2.new(0,0,0,0),
AutomaticSize="XY",
BackgroundTransparency=1,
AutoButtonColor=false,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
Parent=am.UIElements.TabsScroll,
},{
aa.NewRoundFrame(math.max(al.Window.ElementConfig.UICorner-2,6),al.Window.ModernLayout and"Glass-1.4"or"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline",
}),
ad("Frame",{
Name="Frame",
Size=UDim2.new(0,0,0,0),
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,am.TabPaddingY),
PaddingBottom=UDim.new(0,am.TabPaddingY),
PaddingLeft=UDim.new(0,am.TabPaddingX),
PaddingRight=UDim.new(0,am.TabPaddingX),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,m and 2 or 0),
HorizontalAlignment=p,
VerticalAlignment="Center",
}),
ad("Frame",{
Name="HeaderRow",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,0),
AutomaticSize="XY",
},{
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
HorizontalAlignment=p,
VerticalAlignment="Center",
}),
l,
ad("TextLabel",{
Name="Title",
BackgroundTransparency=1,
AutomaticSize="XY",
Text=j.Title,
TextXAlignment=m and"Left"or"Center",
TextYAlignment="Center",
ThemeTag={
TextColor3="TabTitle",
},
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
TextSize=am.TabTextSize,
TextTransparency=0.4,
}),
}),
u,
}),
},true)

local x=ad("Frame",{
Name="TabContent_"..tostring(j.Index),
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,j.Gap),
VerticalAlignment="Top",
}),
})

j.UIElements={
Button=v,
Outline=v.Outline,
Title=v.Frame.HeaderRow.Title,
Desc=u,
Icon=l,
Content=x,
ContainerFrame=(al.Tab and al.Tab.UIElements and al.Tab.UIElements.ContainerFrame)
or{ScrollingEnabled=true},
}

local z=al.ElementsModule

z.Load(
j,
x,
z.Elements,
al.Window,
al.WindUI,
function(A)
if am.Locked and A and A.Lock then
A:Lock()
end

if am.SelectedTab==j and am.Expandable then
SyncHeight(true)
end
end,
z,
al.UIScale,
j
)

aa.AddSignal(x.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if am.SelectedTab==j and am.Expandable then
SyncHeight(true)
end
end)

aa.AddSignal(v.MouseEnter,function()
if am.Locked then
return
end

if am.SelectedTab~=j then
SetTabState(j,"Hover",false)
end
end)

aa.AddSignal(v.InputEnded,function()
if am.Locked then
return
end

if am.SelectedTab~=j then
SetTabState(j,"Default",false)
end
end)

aa.AddSignal(v.MouseButton1Click,function()
if am.Locked then
return
end

am:SelectTab(j)
end)

function j.Select(A,B)
return am:SelectTab(j,B)
end

function j.Destroy(A)
for B=#j.Elements,1,-1 do
local C=j.Elements[B]
if C and C.Destroy then
C:Destroy()
end
end

if j.UIElements.Content then
j.UIElements.Content:Destroy()
end

if j.UIElements.Button then
j.UIElements.Button:Destroy()
end

local B
for C,F in next,am.Tabs do
if F==j then
B=C
break
end
end

if B then
table.remove(am.Tabs,B)
end

for C,F in next,am.Tabs do
F.Index=C
end

UpdateTabsAlignment()

if am.SelectedTab==j then
am.SelectedTab=nil
am.SelectedTabIndex=nil

if am.Tabs[1]then
am:SelectTab(am.Tabs[1],true)
else
SyncHeight(true)
end
else
SyncHeight(true)
end
end

table.insert(am.Tabs,j)
UpdateTabsAlignment()

if h.Selected or h.Opened or not am.SelectedTab then
am:SelectTab(j,true)
else
SetTabState(j,"Default",true)
end

SyncHeight(true)
return j
end

function am.Destroy(g)
aq=false
ar=false
SetWindowScrollLock(false)

for h=#am.Tabs,1,-1 do
local j=am.Tabs[h]
if j and j.Destroy then
j:Destroy()
end
end

d:Destroy()
end

function am.Open(g,h)
if am.Expandable then
am.Opened=true
d.Content.Visible=true
SetChevronState(true,h)
SyncHeight(h)
UpdateWindowScrollLock()
end
end

function am.Close(g,h)
if am.Expandable then
am.Opened=false
SetChevronState(false,h)
SyncHeight(h)
UpdateWindowScrollLock()
end
end

if am.Icon then
am:SetIcon(am.Icon)
end

aa.AddSignal(d.Top:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateTitleSize()
UpdateContentLayout()

if am.Expandable then
SyncHeight(true)
end
end)

aa.AddSignal(aB:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateTitleSize()
end)

aa.AddSignal(d.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if am.Expandable then
SyncHeight(true)
end
end)

aa.AddSignal(am.UIElements.TabsScroll:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateTabsAlignment()
end)

aa.AddSignal(f:GetPropertyChangedSignal"AbsoluteContentSize",function()
UpdateTabsAlignment()
end)

aa.AddSignal(am.UIElements.TabsScroll.MouseEnter,function()
if am.Locked then
return
end

aq=true
UpdateWindowScrollLock()
end)

aa.AddSignal(am.UIElements.TabsScroll.MouseLeave,function()
aq=false
UpdateWindowScrollLock()
end)

aa.AddSignal(ai.InputChanged,function(g)
if am.Locked then
return
end

if not aq then
return
end

if g.UserInputType~=Enum.UserInputType.MouseWheel then
return
end

local h=am.UIElements.TabsScroll
local j=math.max(h.AbsoluteCanvasSize.X-h.AbsoluteSize.X,0)
if j<=0 then
return
end

local l=-g.Position.Z*34
local m=math.clamp(h.CanvasPosition.X+l,0,j)
h.CanvasPosition=Vector2.new(m,0)
end)

aa.AddSignal(d.Top.MouseEnter,function()
if not am.HoverFeedback or am.Locked then
return
end

ao=true
SetHoverState(false)
end)

aa.AddSignal(d.Top.MouseLeave,function()
ao=false
ap=false
SetHoverState(false)
end)

aa.AddSignal(d.Top.InputBegan,function(g)
if not am.HoverFeedback or am.Locked or not IsPressInput(g)then
return
end

ap=true
SetHoverState(false)
end)

aa.AddSignal(d.Top.InputEnded,function(g)
if not am.HoverFeedback or am.Locked or not IsPressInput(g)then
return
end

ap=false
SetHoverState(false)
end)

aa.AddSignal(d.Top.Activated,function()
if am.Locked then
return
end

if am.Expandable then
if am.Opened then
am:Close()
else
am:Open()
end
end
end)

task.defer(function()
UpdateTitleSize()
UpdateContentLayout()
UpdateTabsAlignment()

if not am.Expandable then
d.Content.Visible=false
d.Top.Active=false
d.Top.Size=UDim2.new(1,0,0,am.HeaderSize)
d.Top.AutomaticSize="Y"
d.AutomaticSize="Y"
end

SetHoverState(true)
SetChevronState(am.Opened,true)

if am.Expandable then
if am.Opened then
am:Open(true)
else
am:Close(true)
end
end

if am.Locked then
am:Lock()
end

UpdateWindowScrollLock()
end)

return am.__type,am
end

return aj end function a.V():typeof(__modImpl())local aa=a.cache.V if not aa then aa={c=__modImpl()}a.cache.V=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ad=aa.New

local ae={}

local function ParseAspectRatio(ag)
if type(ag)=="string"then
local ai,aj=ag:match"(%d+):(%d+)"
if ai and aj then
return tonumber(ai)/tonumber(aj)
end
elseif type(ag)=="number"then
return ag
end
return nil
end

function ae.New(ag,ai)
local aj={
__type="Image",
Image=ai.Image or"",
AspectRatio=ai.AspectRatio or"16:9",
Radius=ai.Radius or ai.Window.ElementConfig.UICorner,
}
local ak=aa.Image(
aj.Image,
aj.Image,
aj.Radius,
ai.Window.Folder,
"Image",
false
)
if ak and ak.Parent then
ak.Parent=ai.Parent
ak.Size=UDim2.new(1,0,0,0)
ak.BackgroundTransparency=1












local al=ParseAspectRatio(aj.AspectRatio)
local am

if al then
am=ad("UIAspectRatioConstraint",{
Parent=ak,
AspectRatio=al,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function aj.Destroy(an)
ak:Destroy()
end
end

return aj.__type,aj
end

return ae end function a.W():typeof(__modImpl())local aa=a.cache.W if not aa then aa={c=__modImpl()}a.cache.W=aa end return aa.c end end do local function __modImpl()
local aa=a.c()
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="Group",
Elements={}
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or(ai.Window.ModernLayout and 1 or 6))
}),
})

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.WindUI,
function(am,an)
local ao=ai.Tab and ai.Tab.Gap or(ai.Window.ModernLayout and 1 or 6)

local ap={}
local aq=0

for ar,as in next,an do
if as.__type=="Space"then
aq=aq+(as.ElementFrame.Size.X.Offset or 6)
elseif as.__type=="Divider"then
aq=aq+(as.ElementFrame.Size.X.Offset or 1)
else
table.insert(ap,as)
end
end

local ar=#ap
if ar==0 then return end

local as=1/ar

local at=ao*(ar-1)

local au=-(at+aq)

local av=math.floor(au/ar)
local aw=au-(av*ar)

for ax,ay in next,ap do
local az=av
if ax<=math.abs(aw)then
az=az-1
end

if ay.ElementFrame then
ay.ElementFrame.Size=UDim2.new(as,az,1,0)
end
end
end,
al,
ai.UIScale,
ai.Tab
)



return aj.__type,aj
end

return ae end function a.X():typeof(__modImpl())local aa=a.cache.X if not aa then aa={c=__modImpl()}a.cache.X=aa end return aa.c end end do local function __modImpl()

local aa=a.c()
local ad=aa.New

local ae={}

local function normalizeVideo(ag)
if type(ag)~="string"then
return""
end

if ag==""then
return""
end

if string.match(ag,"^%d+$")then
return"rbxassetid://"..ag
end

return ag
end

local function normalizeHeight(ag)
if type(ag)~="number"then
return 200
end

return math.max(ag,24)
end

local function normalizeVolume(ag,ai)
if type(ag)~="number"then
return ai
end

return math.clamp(ag,0,10)
end

function ae.New(ag,ai)
local aj={
__type="Video",
Title=ai.Title or"Video",
Desc=ai.Desc or nil,
Video=normalizeVideo(ai.Video or""),
Height=normalizeHeight(ai.Height),
Looped=ai.Looped==true,
Playing=ai.Playing==true,
Volume=normalizeVolume(ai.Volume,0.5),
Visible=ai.Visible~=false,
Radius=ai.Radius or ai.Window.ElementConfig.UICorner,
}

local ak=typeof(ai.Padding)=="number"and math.max(math.floor(ai.Padding),0)or 5

local al=ad("Frame",{
Parent=ai.Parent,
Size=UDim2.new(1,0,0,aj.Height),
BackgroundTransparency=1,
Visible=aj.Visible,
Name="VideoElement",
})

local am=aa.NewRoundFrame(aj.Radius,"Squircle",{
Parent=al,
Size=UDim2.new(1,-(ak*2),1,-(ak*2)),
Position=UDim2.new(0,ak,0,ak),
BackgroundTransparency=1,
ClipsDescendants=true,
ThemeTag={
ImageColor3="ElementBackground",
},
ImageTransparency=0.93,
})

local an=ad("VideoFrame",{
Parent=am,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ClipsDescendants=true,
ZIndex=2,
Video=aj.Video,
Looped=aj.Looped,
Playing=aj.Playing,
Volume=aj.Volume,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,aj.Radius),
}),
})

local ao=aa.NewRoundFrame(aj.Radius,ai.Window.ModernLayout and"Glass-1"or"SquircleOutline",{
Name="Outline",
Parent=am,
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ZIndex=3,
ThemeTag={
ImageColor3="SectionBoxBorder",
ImageTransparency="SectionBoxBorderTransparency",
},
})

aj.ElementFrame=al
aj.UIElements={
Holder=al,
Box=am,
VideoFrame=an,
Outline=ao,
}

function aj.Play(ap)
aj.Playing=true
an.Playing=true
end

function aj.Pause(ap)
aj.Playing=false
an.Playing=false
end

function aj.SetPlaying(ap,aq)
if aq==true then
aj:Play()
return
end

aj:Pause()
end

function aj.SetVideo(ap,aq)
aj.Video=normalizeVideo(aq or"")
an.Video=aj.Video
end

function aj.SetVolume(ap,aq)
aj.Volume=normalizeVolume(aq,aj.Volume)
an.Volume=aj.Volume
end

function aj.SetLooped(ap,aq)
aj.Looped=aq==true
an.Looped=aj.Looped
end

function aj.SetVisible(ap,aq)
aj.Visible=aq~=false
al.Visible=aj.Visible
end

function aj.SetHeight(ap,aq)
aj.Height=normalizeHeight(aq)
al.Size=UDim2.new(1,0,0,aj.Height)
end

function aj.Destroy(ap)
al:Destroy()
end

return aj.__type,aj
end

return ae end function a.Y():typeof(__modImpl())local aa=a.cache.Y if not aa then aa={c=__modImpl()}a.cache.Y=aa end return aa.c end end do local function __modImpl()

return{
Elements={
Paragraph=a.E(),
Button=a.F(),
ButtonKeybind=a.G(),
Toggle=a.J(),
ToggleKeybind=a.K(),
Slider=a.L(),
Keybind=a.M(),
Input=a.N(),
Dropdown=a.P(),
Code=a.S(),
Colorpicker=a.T(),
Section=a.U(),
MultiSection=a.V(),
Divider=a.w(),
Space=a.x(),
Image=a.W(),
Group=a.X(),
Video=a.Y(),
},
Load=function(aa,ad,ae,ag,ai,aj,ak,al,am)
local function removeFromList(an,ao)
if not an then
return
end

for ap=#an,1,-1 do
if an[ap]==ao then
table.remove(an,ap)
return
end
end
end

for an,ao in next,ae do
aa[an]=function(ap,aq)
aq=aq or{}
aq.Tab=am or aa
aq.ParentType=aa.__type
aq.ParentTable=aa
aq.Index=#aa.Elements+1
aq.GlobalIndex=#ag.AllElements+1
aq.Parent=ad
aq.Window=ag
aq.WindUI=ai
aq.UIScale=al
aq.ElementsModule=ak local

ar, as=ao:New(aq)

if aq.Flag and typeof(aq.Flag)=="string"then
if ag.CurrentConfig then
ag.CurrentConfig:Register(aq.Flag,as)

if ag.PendingConfigData and ag.PendingConfigData[aq.Flag]then
local at=ag.PendingConfigData[aq.Flag]

local au=ag.ConfigManager
if au.Parser[at.__type]then
task.defer(function()
local av,aw=pcall(function()
au.Parser[at.__type].Load(as,at)
end)

if av then
ag.PendingConfigData[aq.Flag]=nil
else
warn("[ WindUI ] Failed to apply pending config for '"..aq.Flag.."': "..tostring(aw))
end
end)
end
end
else
ag.PendingFlags=ag.PendingFlags or{}
ag.PendingFlags[aq.Flag]=as
end
end

local at
for au,av in next,as do
if typeof(av)=="table"and au~="ElementFrame"and au:match"Frame$"then
at=av
break
end
end

local au=as.Destroy
local av=false

if at then
as.ElementFrame=at.UIElements.Main
function as.SetTitle(aw,ax)
at:SetTitle(ax)
end
function as.SetDesc(aw,ax)
at:SetDesc(ax)
end
function as.Highlight(aw)
at:Highlight()
end
end

function as.Destroy(aw)
if av then
return
end
av=true

if typeof(au)=="function"then
local ax,ay=pcall(function()
au(as)
end)
if not ax then
warn("[ WindUI ] Failed to destroy element '"..tostring(aq.Flag or as.__type or an).."': "..tostring(ay))
end
elseif at and at.Destroy then
at:Destroy()
end

removeFromList(ag.AllElements,as)
removeFromList(aa.Elements,as)
if aq.Tab and aq.Tab~=aa and aq.Tab.Elements then
removeFromList(aq.Tab.Elements,as)
end

if aa.UpdateAllElementShapes then
aa:UpdateAllElementShapes(aa)
end
if aq.Tab and aq.Tab~=aa and aq.Tab.UpdateAllElementShapes then
aq.Tab:UpdateAllElementShapes(aq.Tab)
end
end



table.insert(ag.AllElements,as)
table.insert(aa.Elements,as)
if aq.Tab and aq.Tab~=aa and aq.Tab.Elements then
table.insert(aq.Tab.Elements,as)
end

if ag.ModernLayout then
aa:UpdateAllElementShapes(aa)
end

if aj then
aj(as,aa.Elements)
end
return as
end
end
function aa.UpdateAllElementShapes(an,ao)
for ap,aq in next,ao.Elements do
local ar
for as,at in pairs(aq)do
if typeof(at)=="table"and as:match"Frame$"then
ar=at
break
end
end

if ar then

ar.Index=ap
if ar.UpdateShape then

ar.UpdateShape(ao)
end
end
end
end
end,

}end function a.Z():typeof(__modImpl())local aa=a.cache.Z if not aa then aa={c=__modImpl()}a.cache.Z=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
local ad=game.Players.LocalPlayer:GetMouse()

local ae=a.c()
local ag=ae.New

local ai=a.C().New
local aj=a.v().New





local ak={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(ak)end
}

function ak.Init(al,am,an,ao)
Window=al
WindUI=am
ak.ToolTipParent=an
ak.TabHighlight=ao
return ak
end

function ak.New(al,am)
local an={
__type="Tab",
Title=al.Title or"Tab",
Desc=al.Desc,
Icon=al.Icon,
IconColor=al.IconColor,
IconShape=al.IconShape,
IconThemed=al.IconThemed,
Locked=al.Locked,
ShowTabTitle=al.ShowTabTitle,
Border=al.Border,
Selected=false,
Index=nil,
LayoutOrder=al.LayoutOrder,
Parent=al.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.ModernLayout and 1 or 6,

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}

if an.IconShape then
an.TabPaddingX=2+(Window.UIPadding/4)
an.TabPaddingY=2+(Window.UIPadding/4)
an.TitlePaddingY=2+(Window.UIPadding/4)
end

ak.TabCount=ak.TabCount+1

local ao=ak.TabCount
an.Index=ao

an.UIElements.Main=ae.NewRoundFrame(an.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=al.Parent,
LayoutOrder=an.LayoutOrder,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ae.NewRoundFrame(an.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline"
},{













}),
ae.NewRoundFrame(an.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("TextLabel",{
Text=an.Title,
ThemeTag={
TextColor3="TabTitle"
},
TextTransparency=not an.Locked and 0.4 or.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,an.TitlePaddingY),


PaddingBottom=UDim.new(0,an.TitlePaddingY)
})
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,an.TabPaddingY),
PaddingLeft=UDim.new(0,an.TabPaddingX),
PaddingRight=UDim.new(0,an.TabPaddingX),
PaddingBottom=UDim.new(0,an.TabPaddingY),
})
}),
},true)

local ap=0
local aq
local ar

if an.Icon then
aq=ae.Image(
an.Icon,
an.Icon..":"..an.Title,
0,
Window.Folder,
an.__type,
an.IconColor and false or true,
an.IconThemed,
"TabIcon"
)
aq.Size=UDim2.new(0,16,0,16)
if an.IconColor then
aq.ImageLabel.ImageColor3=an.IconColor
end
if not an.IconShape then
aq.Parent=an.UIElements.Main.Frame
an.UIElements.Icon=aq
aq.ImageLabel.ImageTransparency=not an.Locked and 0 or.7
ap=-18-(Window.UIPadding/2)
an.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ap,0,0)
elseif an.IconColor then
ae.NewRoundFrame(an.IconShape~="Circle"and(an.UICorner+5-(2+(Window.UIPadding/4)))or 9999,"Squircle",{
Size=UDim2.new(0,26,0,26),
ImageColor3=an.IconColor,
Parent=an.UIElements.Main.Frame
},{
aq,
ae.NewRoundFrame(an.IconShape~="Circle"and(an.UICorner+5-(2+(Window.UIPadding/4)))or 9999,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0,
Name="Outline"
},{













}),
})
aq.AnchorPoint=Vector2.new(0.5,0.5)
aq.Position=UDim2.new(0.5,0,0.5,0)
aq.ImageLabel.ImageTransparency=0
aq.ImageLabel.ImageColor3=ae.GetTextColorForHSB(an.IconColor,0.68)
ap=-28-(Window.UIPadding/2)
an.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ap,0,0)
end





ar=ae.Image(
an.Icon,
an.Icon..":"..an.Title,
0,
Window.Folder,
an.__type,
true,
an.IconThemed
)
ar.Size=UDim2.new(0,16,0,16)
ar.ImageLabel.ImageTransparency=not an.Locked and 0 or.7
ap=-30




end

an.UIElements.ContainerFrame=ag("ScrollingFrame",{
Size=UDim2.new(1,0,1,an.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,an.Gap),
HorizontalAlignment="Center",
})
})





an.UIElements.ContainerFrameCanvas=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
an.UIElements.ContainerFrame,
ag("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=an.ShowTabTitle or false,
Name="TabTitle"
},{
ar,
ag("TextLabel",{
Text=an.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-ap,1,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextTruncate="AtEnd",
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ag("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=an.ShowTabTitle or false,
})
})

ak.Containers[ao]=an.UIElements.ContainerFrameCanvas
ak.Tabs[ao]=an

an.ContainerFrame=an.UIElements.ContainerFrameCanvas

ae.AddSignal(an.UIElements.Main.MouseButton1Click,function()
if not an.Locked then
ak:SelectTab(ao)
end
end)

if Window.ScrollBarEnabled then
aj(an.UIElements.ContainerFrame,an.UIElements.ContainerFrameCanvas,Window,3)
end

local as
local at
local au
local av=false



if an.Desc then


ae.AddSignal(an.UIElements.Main.InputBegan,function()
av=true
at=task.spawn(function()
task.wait(0.35)
if av and not as then
as=ai(an.Desc,ak.ToolTipParent,true)
as.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if as then
as.Container.Position=UDim2.new(0,ad.X,0,ad.Y-4)
end
end

updatePosition()
au=ad.Move:Connect(updatePosition)
as:Open()
end
end)
end)

end

ae.AddSignal(an.UIElements.Main.MouseEnter,function()
if not an.Locked then
ae.SetThemeTag(an.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.08)
end
end)
ae.AddSignal(an.UIElements.Main.InputEnded,function()
if an.Desc then
av=false
if at then
task.cancel(at)
at=nil
end
if au then
au:Disconnect()
au=nil
end
if as then
as:Close()
as=nil
end
end

if not an.Locked then
ae.SetThemeTag(an.UIElements.Main.Frame,{
ImageTransparency="TabBorderTransparency"
},0.08)
end
end)



function an.ScrollToTheElement(aw,ax)
an.UIElements.ContainerFrame.ScrollingEnabled=false

ae.Tween(an.UIElements.ContainerFrame,0.45,{
CanvasPosition=Vector2.new(
0,
an.Elements[ax].ElementFrame.AbsolutePosition.Y
-an.UIElements.ContainerFrame.AbsolutePosition.Y
-an.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.48)

if an.Elements[ax].Highlight then
an.Elements[ax]:Highlight()
end
an.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return an
end





local aw=a.Z()

aw.Load(an,an.UIElements.ContainerFrame,aw.Elements,Window,WindUI,nil,aw,am)



function an.LockAll(ax)

for ay,az in next,Window.AllElements do
if az.Tab and az.Tab.Index and az.Tab.Index==an.Index and az.Lock then
az:Lock()
end
end
end
function an.UnlockAll(ax)
for ay,az in next,Window.AllElements do
if az.Tab and az.Tab.Index and az.Tab.Index==an.Index and az.Unlock then
az:Unlock()
end
end
end
function an.GetLocked(ax)
local ay={}

for az,aA in next,Window.AllElements do
if aA.Tab and aA.Tab.Index and aA.Tab.Index==an.Index and aA.Locked==true then
table.insert(ay,aA)
end
end

return ay
end
function an.GetUnlocked(ax)
local ay={}

for az,aA in next,Window.AllElements do
if aA.Tab and aA.Tab.Index and aA.Tab.Index==an.Index and aA.Locked==false then
table.insert(ay,aA)
end
end

return ay
end

function an.Select(ax)
return ak:SelectTab(an.Index)
end

task.spawn(function()
local ax=ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=an.UIElements.ContainerFrame
},{
ag("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
ag("ImageLabel",{
Size=UDim2.new(0,48,0,48),
Image=ae.Icon"frown"[1],
ImageRectOffset=ae.Icon"frown"[2].ImageRectPosition,
ImageRectSize=ae.Icon"frown"[2].ImageRectSize,
ThemeTag={
ImageColor3="Icon"
},
BackgroundTransparency=1,
ImageTransparency=.6,
}),
ag("TextLabel",{
AutomaticSize="XY",
Text="This tab is empty",
ThemeTag={
TextColor3="Text"
},
TextSize=18,
TextTransparency=.5,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
})
})





local ay
ay=ae.AddSignal(an.UIElements.ContainerFrame.ChildAdded,function()
ax.Visible=false
ay:Disconnect()
end)
end)

return an
end

function ak.OnChange(al,am)
ak.OnChangeFunc=am
end

function ak.SelectTab(al,am)
if not ak.Tabs[am].Locked then
ak.SelectedTab=am

for an,ao in next,ak.Tabs do
if not ao.Locked then
ae.SetThemeTag(ao.UIElements.Main,{
ImageTransparency="TabBorderTransparency"
},0.15)
if ao.Border then
ae.SetThemeTag(ao.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency"
},0.15)
end
ae.SetThemeTag(ao.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency"
},0.15)
if ao.UIElements.Icon and not ao.IconColor then
ae.SetThemeTag(ao.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparency"
},0.15)
end
ao.Selected=false
end
end
ae.SetThemeTag(ak.Tabs[am].UIElements.Main,{
ImageTransparency="TabBackgroundActiveTransparency"
},0.15)
if ak.Tabs[am].Border then
ae.SetThemeTag(ak.Tabs[am].UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive"
},0.15)
end
ae.SetThemeTag(ak.Tabs[am].UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive"
},0.15)
if ak.Tabs[am].UIElements.Icon and not ak.Tabs[am].IconColor then
ae.SetThemeTag(ak.Tabs[am].UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparencyActive"
},0.15)
end
ak.Tabs[am].Selected=true

task.spawn(function()
for an,ao in next,ak.Containers do
ao.AnchorPoint=Vector2.new(0,0.05)
ao.Visible=false
end
ak.Containers[am].Visible=true
local an=game:GetService"TweenService"

local ao=TweenInfo.new(
0.15,
Enum.EasingStyle.Quart,
Enum.EasingDirection.Out
)
local ap=an:Create(ak.Containers[am],ao,{
AnchorPoint=Vector2.new(0,0)
})
ap:Play()
end)

ak.OnChangeFunc(am)
end
end

return ak end function a._():typeof(__modImpl())local aa=a.cache._ if not aa then aa={c=__modImpl()}a.cache._=aa end return aa.c end end do local function __modImpl()

local aa={}


local ad=a.c()
local ae=ad.New
local ag=ad.Tween

local ai=a.u().New
local aj=a.e().New
local ak=a.w()
local al=a.x()

local am=a._()

function aa.New(an,ao,ap,aq,ar)
local as={
Title=an.Title or"Section",
Icon=an.Icon,
IconThemed=an.IconThemed,
Opened=an.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local at
if as.Icon then
at=ad.Image(
as.Icon,
as.Icon,
0,
ap,
"Section",
true,
as.IconThemed
)

at.Size=UDim2.new(0,as.IconSize,0,as.IconSize)
at.ImageLabel.ImageTransparency=.25
end

local au=ae("Frame",{
Size=UDim2.new(0,as.IconSize,0,as.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ad.Icon"chevron-down"[1],
ImageRectSize=ad.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ad.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local av=ae("Frame",{
Size=UDim2.new(1,0,0,as.HeaderSize),
BackgroundTransparency=1,
Parent=ao,
ClipsDescendants=true,
LayoutOrder=an.LayoutOrder,
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,as.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
at,
ae("TextLabel",{
Text=as.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
at and(-as.IconSize-10)*2
or(-as.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ad.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
au,
ae("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,as.HeaderSize)
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ar.Gap),
VerticalAlignment="Bottom",
}),
})
})

local function EnsureExpandable()
if not as.Expandable then
as.Expandable=true
au.Visible=true

if as.Opened and as.Open then
task.defer(function()
as:Open()
end)
end
end
end


function as.Tab(aw,ax)
EnsureExpandable()
ax.Parent=av.Content
return am.New(ax,aq)
end

function as.Label(aw,ax)
ax=ax or{}
EnsureExpandable()

local ay=ax.Title or ax.Text or"Label"
local az=ai(
ay,
ax.Icon,
av.Content,
ax.Placeholder==true,
ax.Radius
)

local aA=typeof(ax.Height)=="number"and math.max(ax.Height,18)or 34
az.Size=ax.Size or UDim2.new(1,-7,0,aA)
az.Visible=ax.Visible~=false

if typeof(ax.LayoutOrder)=="number"then
az.LayoutOrder=ax.LayoutOrder
end

return az
end

function as.Button(aw,ax)
ax=ax or{}
EnsureExpandable()

local ay=typeof(ax.Height)=="number"and math.max(ax.Height,20)or 34
local az=ae("Frame",{
Name="SectionButton",
Parent=av.Content,
BackgroundTransparency=1,
Size=ax.Size or UDim2.new(1,-7,0,ay),
Visible=ax.Visible~=false,
})

if typeof(ax.LayoutOrder)=="number"then
az.LayoutOrder=ax.LayoutOrder
end

local aA={
__type="SectionButton",
Title=ax.Title or ax.Text or"Button",
Callback=ax.Callback,
ElementFrame=az,
ButtonFrame=nil,
}

local aB=aj(
aA.Title,
ax.Icon,
function()
if aA.Callback then
ad.SafeCallback(aA.Callback,aA)
end
end,
ax.Variant or"Secondary",
az,
nil,
ax.FullRounded,
ax.Radius
)

aB.AutomaticSize="None"
aB.Size=UDim2.new(1,0,1,0)
aB.Position=UDim2.new(0.5,0,0.5,0)
aB.AnchorPoint=Vector2.new(0.5,0.5)

aA.ButtonFrame=aB

function aA.SetTitle(b,d)
b.Title=tostring(d or"")

local f=b.ButtonFrame:FindFirstChild("TextLabel",true)
if f then
f.Text=b.Title
end

return b
end

function aA.SetCallback(b,d)
b.Callback=d
return b
end

function aA.SetVisible(b,d)
b.ElementFrame.Visible=d~=false
return b
end

function aA.Destroy(b)
if b.ElementFrame then
b.ElementFrame:Destroy()
b.ElementFrame=nil
b.ButtonFrame=nil
end
end

return aA
end

function as.Divider(aw,ax)
ax=ax or{}
EnsureExpandable()

local ay=table.clone(ax)
ay.Parent=av.Content
ay.ParentType=ay.ParentType or"Section"local

az, aA=ak:New(ay)
return aA.ElementFrame
end

function as.Space(aw,ax)
ax=ax or{}
EnsureExpandable()

local ay=table.clone(ax)
ay.Parent=av.Content
ay.ParentType=ay.ParentType or"Section"local

az, aA=al:New(ay)
return aA.ElementFrame
end

function as.Open(aw)
if as.Expandable then
as.Opened=true
ag(av,0.33,{
Size=UDim2.new(1,0,0,as.HeaderSize+(av.Content.AbsoluteSize.Y/aq))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ag(au.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function as.Close(aw)
if as.Expandable then
as.Opened=false
ag(av,0.26,{
Size=UDim2.new(1,0,0,as.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag(au.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ad.AddSignal(av.TextButton.MouseButton1Click,function()
if as.Expandable then
if as.Opened then
as:Close()
else
as:Open()
end
end
end)

ad.AddSignal(av.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if as.Opened then
as:Open()
end
end)

if as.Opened then
task.spawn(function()
task.wait()
as:Open()
end)
end



return as
end


return aa end function a.aa():typeof(__modImpl())local aa=a.cache.aa if not aa then aa={c=__modImpl()}a.cache.aa=aa end return aa.c end end do local function __modImpl()

return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
ButtonKeybind="square-mouse-pointer",
Toggle="toggle-right",
ToggleKeybind="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
Video="video",
}end function a.ab():typeof(__modImpl())local aa=a.cache.ab if not aa then aa={c=__modImpl()}a.cache.ab=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")

local ad={
Margin=8,
Padding=9,
}


local ae=a.c()
local ag=ae.New
local ai=ae.Tween


function ad.new(aj,ak,al)
local am={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.ab()
}


local an=ag("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(
1,
-((am.IconSize*2)+(am.Padding*2)),
0,
0
),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ao=ag("ImageLabel",{
Image=ae.Icon"x"[1],
ImageRectSize=ae.Icon"x"[2].ImageRectSize,
ImageRectOffset=ae.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
},{
ag("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})

local ap=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding),
})
})

local aq=ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("ImageLabel",{
Image=ae.Icon"search"[1],
ImageRectSize=ae.Icon"search"[2].ImageRectSize,
ImageRectOffset=ae.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
an,
ao,
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
})
})
}),
ag("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.9,
Visible=false,
}),
ap,
ag("UISizeConstraint",{
MaxSize=Vector2.new(am.Width,am.MaxHeight),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
})
})

local ar=ag("Frame",{
Size=UDim2.new(0,am.Width,0,0),
AutomaticSize="Y",
Parent=ak,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ag("UIScale",{
Scale=.9,
}),
aq,
ae.NewRoundFrame(am.Radius,"Glass-0.7",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,


ThemeTag={
ImageColor3="SearchBarBorder",
ImageTransparency="SearchBarBorderTransparency",
},
Name="Outline",
}),
})

local function CreateSearchTab(as,at,au,av,aw,ax)
local ay=ag("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av or nil
},{
ae.NewRoundFrame(am.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main"
},{
ae.NewRoundFrame(am.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding-2),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding-2),
}),
ag("ImageLabel",{
Image=ae.Icon(au)[1],
ImageRectSize=ae.Icon(au)[2].ImageRectSize,
ImageRectOffset=ae.Icon(au)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
ag("Frame",{
Size=UDim2.new(1,-am.IconSize-am.Padding,0,0),
BackgroundTransparency=1,
},{
ag("TextLabel",{
Text=as,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title"
}),
ag("TextLabel",{
Text=at or"",
Visible=at and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc"
})or nil,
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
})
}),
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
})
}),
},true),
ag("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-am.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aw,

},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.9,
}),
ag("Frame",{
Size=UDim2.new(1,-am.Padding-2,0,0),
Position=UDim2.new(0,am.Padding+2,0,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right"
})
})



ay.Main.Size=UDim2.new(
1,
0,
0,
ay.Main.Outline.Frame.Desc.Visible and(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y+6+ay.Main.Outline.Frame.Desc.TextBounds.Y)
or(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y)
)

ae.AddSignal(ay.Main.MouseEnter,function()
ai(ay.Main,.04,{ImageTransparency=.95}):Play()
ai(ay.Main.Outline,.04,{ImageTransparency=.75}):Play()
end)
ae.AddSignal(ay.Main.InputEnded,function()
ai(ay.Main,.08,{ImageTransparency=1}):Play()
ai(ay.Main.Outline,.08,{ImageTransparency=1}):Play()
end)
ae.AddSignal(ay.Main.MouseButton1Click,function()
if ax then
ax()
end
end)

return ay
end

local function ContainsText(as,at)
if not at or at==""then
return false
end

if not as or as==""then
return false
end

local au=string.lower(as)
local av=string.lower(at)

return string.find(au,av,1,true)~=nil
end

local function Search(as)
if not as or as==""then
return{}
end

local at={}
for au,av in next,aj.Tabs do
local aw=ContainsText(av.Title or"",as)
local ax={}

for ay,az in next,av.Elements do
if az.__type~="Section"and az.__type~="MultiSection"then
local aA=ContainsText(az.Title or"",as)
local aB=ContainsText(az.Desc or"",as)

if aA or aB then
ax[ay]={
Title=az.Title,
Desc=az.Desc,
Original=az,
__type=az.__type,
Index=ay,
}
end
end
end

if aw or next(ax)~=nil then
at[au]={
Tab=av,
Title=av.Title,
Icon=av.Icon,
Elements=ax,
}
end
end
return at
end

function am.Search(as,at)
at=at or""

local au=Search(at)

ap.Visible=true
aq.Frame.Results.Frame.Visible=true
for av,aw in next,ap:GetChildren()do
if aw.ClassName~="UIListLayout"and aw.ClassName~="UIPadding"then
aw:Destroy()
end
end

if au and next(au)~=nil then
for av,aw in next,au do
local ax=am.Icons.Tab
local ay=CreateSearchTab(aw.Title,nil,ax,ap,true,function()
am:Close()
aj:SelectTab(av)
end)
if aw.Elements and next(aw.Elements)~=nil then
for az,aA in next,aw.Elements do
local aB=am.Icons[aA.__type]
CreateSearchTab(aA.Title,aA.Desc,aB,ay:FindFirstChild"ParentContainer"and ay.ParentContainer.Frame or nil,false,function()
am:Close()
aj:SelectTab(av)
if aw.Tab.ScrollToTheElement then

aw.Tab:ScrollToTheElement(aA.Index)
end

end)

end
end
end
elseif at~=""then
ag("TextLabel",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=.2,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Parent=ap,
Name="NotFound",
})
else
ap.Visible=false
aq.Frame.Results.Frame.Visible=false
end
end

ae.AddSignal(an:GetPropertyChangedSignal"Text",function()
am:Search(an.Text)
end)

ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ai(ap,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(ap.UIListLayout.AbsoluteContentSize.Y+(am.Padding*2),0,am.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function am.Open(as)
task.spawn(function()
aq.Frame.Visible=true
ar.Visible=true
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Close(as,at)
task.spawn(function()
al()
aq.Frame.Visible=false
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
ar.Visible=false
if at then ar:Destroy()end
end)
end

ae.AddSignal(ao.TextButton.MouseButton1Click,function()
am:Close(true)
end)

am:Open()

return am
end

return ad end function a.ac():typeof(__modImpl())local aa=a.cache.ac if not aa then aa={c=__modImpl()}a.cache.ac=aa end return aa.c end end do local function __modImpl()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ad=aa(game:GetService"UserInputService")
local ae=aa(game:GetService"RunService")
local ag=aa(game:GetService"Players")

local ai=workspace.CurrentCamera

local aj=a.r()

local ak=a.c()
local al=ak.New
local am=ak.Tween

local function FindImageObject(an)
if not an then
return nil
end

if an:IsA"ImageLabel"or an:IsA"ImageButton"then
return an
end

local ao=an:FindFirstChild"ImageLabel"
if ao and(ao:IsA"ImageLabel"or ao:IsA"ImageButton")then
return ao
end

local ap=an:FindFirstChildWhichIsA"ImageLabel"
if ap then
return ap
end

return an:FindFirstChildWhichIsA"ImageButton"
end

local function ResolveVideoTransparencyProperty(an)
if not(an and an:IsA"VideoFrame")then
return"BackgroundTransparency"
end

local ao=pcall(function()local ao=
an.VideoTransparency
end)

return ao and"VideoTransparency"or"BackgroundTransparency"
end

local function SetVideoTransparency(an,ao)
if not(an and an:IsA"VideoFrame")then
return false
end

local ap=math.clamp(tonumber(ao)or 0,0,1)
local aq=ResolveVideoTransparencyProperty(an)
local ar=pcall(function()
an[aq]=ap
end)
if ar then
return true
end

return pcall(function()
an.BackgroundTransparency=ap
end)
end

local function TweenVideoTransparency(an,ao,ap,...)
if not(an and an:IsA"VideoFrame")then
return nil
end

local aq=math.clamp(tonumber(ap)or 0,0,1)
local ar=ResolveVideoTransparencyProperty(an)

local as={}
as[ar]=aq

local at,au=pcall(am,an,ao,as,...)

if at then
return au
end

as={
BackgroundTransparency=aq,
}

at,au=pcall(am,an,ao,as,...)

return at and au or nil
end


local an=a.u().New
local ao=a.e().New
local ap=a.v().New
local aq=a.w()
local ar=a.x()
local as=a.y()
local at=a.z()

local au=a.A()



return function(av)
local aw={
Title=av.Title or"UI Library",
Author=av.Author,
Icon=av.Icon,
IconSize=av.IconSize or 22,
IconThemed=av.IconThemed,
IconRadius=av.IconRadius or 0,
Folder=av.Folder,
Resizable=av.Resizable~=false,
Background=av.Background,
BackgroundVideo=av.BackgroundVideo,
BackgroundImageTransparency=av.BackgroundImageTransparency or 0,
ShadowTransparency=av.ShadowTransparency or 0.7,
User=av.User or{},
Footer=av.Footer or{},
Topbar=av.Topbar or{Height=52,ButtonsType="Default"},

Size=av.Size,

MinSize=av.MinSize or Vector2.new(560,350),
MaxSize=av.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=av.TopBarButtonIconSize,

ToggleKey=av.ToggleKey,
ElementsRadius=av.ElementsRadius,
Radius=av.Radius or 16,
Transparent=av.Transparent or false,
HideSearchBar=av.HideSearchBar~=false,
ScrollBarEnabled=av.ScrollBarEnabled or false,
SideBarWidth=av.SideBarWidth or 200,
Acrylic=av.Acrylic or false,
ModernLayout=av.ModernLayout or false,
IgnoreAlerts=av.IgnoreAlerts or false,
HidePanelBackground=av.HidePanelBackground or false,
AutoScale=av.AutoScale~=false,
OpenButton=av.OpenButton,
BottomDragBarEnabled=not(av.BottomDragBarEnabled==false or av.BottomDragEnabled==false),
WatermarkConfig=av.Watermark,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=av.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=av.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,
WatermarkObject=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},

IsToggleDragging=false,
}

aw.UICorner=aw.Radius

aw.TopBarButtonIconSize=aw.TopBarButtonIconSize or(aw.Topbar.ButtonsType=="Mac"and 11 or 16)

aw.ElementConfig={
UIPadding=(aw.ModernLayout and 10 or 13),
UICorner=aw.ElementsRadius or(aw.ModernLayout and 23 or 12),
}

local ax=aw.Size or UDim2.new(0,580,0,460)
aw.Size=UDim2.new(
ax.X.Scale,
math.clamp(ax.X.Offset,aw.MinSize.X,aw.MaxSize.X),
ax.Y.Scale,
math.clamp(ax.Y.Offset,aw.MinSize.Y,aw.MaxSize.Y)
)

if type(aw.Topbar)~="table"then
aw.Topbar={}
end
aw.Topbar.Height=aw.Topbar.Height or 52
aw.Topbar.ButtonsType=aw.Topbar.ButtonsType or"Default"

if not ae:IsStudio()and aw.Folder and writefile then
if not isfolder("WindUI/"..aw.Folder)then
makefolder("WindUI/"..aw.Folder)
end
if not isfolder("WindUI/"..aw.Folder.."/assets")then
makefolder("WindUI/"..aw.Folder.."/assets")
end
if not isfolder(aw.Folder)then
makefolder(aw.Folder)
end
if not isfolder(aw.Folder.."/assets")then
makefolder(aw.Folder.."/assets")
end
end

local ay=al("UICorner",{
CornerRadius=UDim.new(0,aw.UICorner)
})

if aw.Folder then
aw.ConfigManager=au:Init(aw)
end


if aw.Acrylic then local
az=aj.AcrylicPaint{UseAcrylic=aw.Acrylic}

aw.AcrylicPaint=az
end

local az=al("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(.5,.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true
},{
al("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
})
})
local aA=FindImageObject(az)
local aB=ak.NewRoundFrame(aw.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
al("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ak.Icon"expand"[1],
ImageRectOffset=ak.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ak.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local b=ak.NewRoundFrame(aw.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










aw.UIElements.SideBar=al("ScrollingFrame",{
Size=UDim2.new(
1,
aw.ScrollBarEnabled and-3-(aw.UIPadding/2)or 0,
1,
not aw.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
al("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
al("UIPadding",{



PaddingBottom=UDim.new(0,aw.UIPadding/2),
}),
al("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,aw.Gap)
})
}),
al("UIPadding",{

PaddingLeft=UDim.new(0,aw.UIPadding/2),
PaddingRight=UDim.new(0,aw.UIPadding/2),

}),

})

aw.UIElements.SideBarContainer=al("Frame",{
Size=UDim2.new(0,aw.SideBarWidth,1,aw.User.Enabled and-aw.Topbar.Height-42-(aw.UIPadding*2)or-aw.Topbar.Height),
Position=UDim2.new(0,0,0,aw.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
al("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(
1,
0,
1,
not aw.HideSearchBar and-45-aw.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
aw.UIElements.SideBar,
})

if aw.ScrollBarEnabled then
ap(aw.UIElements.SideBar,aw.UIElements.SideBarContainer.Content,aw,3)
end


aw.UIElements.MainBar=al("Frame",{
Size=UDim2.new(1,-aw.UIElements.SideBarContainer.AbsoluteSize.X,1,-aw.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ak.NewRoundFrame(aw.UICorner-(aw.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},


ZIndex=3,
Name="Background",
Visible=not aw.HidePanelBackground
}),
al("UIPadding",{

PaddingLeft=UDim.new(0,aw.UIPadding/2),
PaddingRight=UDim.new(0,aw.UIPadding/2),
PaddingBottom=UDim.new(0,aw.UIPadding/2),
})
})

local d=al("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,120,1,116),
Position=UDim2.new(0,-60,0,-58),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})



if ad.TouchEnabled and not ad.KeyboardEnabled then
aw.IsPC=false
elseif ad.KeyboardEnabled then
aw.IsPC=true
else
aw.IsPC=nil
end










local f
if aw.User then
local function GetUserThumb()local
g=ag:GetUserThumbnailAsync(
aw.User.Anonymous and 1 or ag.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return g
end


f=al("TextButton",{
Size=UDim2.new(0,
(aw.UIElements.SideBarContainer.AbsoluteSize.X)-(aw.UIPadding/2),
0,
42+(aw.UIPadding)
),
Position=UDim2.new(0,aw.UIPadding/2,1,-(aw.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=aw.User.Enabled or false,
},{
ak.NewRoundFrame(aw.UICorner-(aw.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
al("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ak.NewRoundFrame(aw.UICorner-(aw.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
al("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=.93,
},{
al("UICorner",{
CornerRadius=UDim.new(1,0)
})
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
al("TextLabel",{
Text=aw.User.Anonymous and"Anonymous"or ag.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName"
}),
al("TextLabel",{
Text=aw.User.Anonymous and"anonymous"or ag.LocalPlayer.Name,
TextSize=15,
TextTransparency=.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName"
}),
al("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
})
}),
al("UIListLayout",{
Padding=UDim.new(0,aw.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,aw.UIPadding/2),
PaddingRight=UDim.new(0,aw.UIPadding/2),
})
})
})


function aw.User.Enable(g)
aw.User.Enabled=true
am(aw.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,aw.SideBarWidth,1,-aw.Topbar.Height-42-(aw.UIPadding*2))},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f.Visible=true
end
function aw.User.Disable(g)
aw.User.Enabled=false
am(aw.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,aw.SideBarWidth,1,-aw.Topbar.Height)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f.Visible=false
end
function aw.User.SetAnonymous(g,h)
if h~=false then h=true end
aw.User.Anonymous=h
local j=FindImageObject(f.UserIcon)
if j then
j.Image=GetUserThumb()
end
f.UserIcon.Frame.DisplayName.Text=h and"Anonymous"or ag.LocalPlayer.DisplayName
f.UserIcon.Frame.UserName.Text=h and"anonymous"or ag.LocalPlayer.Name
end

if aw.User.Enabled then
aw.User:Enable()
else
aw.User:Disable()
end

if aw.User.Callback then
ak.AddSignal(f.MouseButton1Click,function()
aw.User.Callback()
end)
ak.AddSignal(f.MouseEnter,function()
am(f.UserIcon,0.04,{ImageTransparency=.95}):Play()
am(f.Outline,0.04,{ImageTransparency=.85}):Play()
end)
ak.AddSignal(f.InputEnded,function()
am(f.UserIcon,0.04,{ImageTransparency=1}):Play()
am(f.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local g
local h
local j


local l=false
local m
local p=aw.Folder or av.Title or"Temp"

local function EnsureAssetFolder()
if ae:IsStudio()or not writefile then
return
end

if not isfolder(p)then
makefolder(p)
end
if not isfolder(p.."/assets")then
makefolder(p.."/assets")
end
end

local function GetImageExtension(r)
local u=r:match"%.(%w+)$"or r:match"%.(%w+)%?"
if u then
u=u:lower()
if u=="jpg"or u=="jpeg"or u=="png"or u=="webp"then
return"."..u
end
end
return".png"
end

local function NormalizeVideo(r)
if type(r)=="number"then
r=tostring(r)
end

if type(r)~="string"then
return nil
end

r=r:gsub("^video:","")
if r==""then
return nil
end

if string.match(r,"^%d+$")then
return"rbxassetid://"..r
end

return r
end

local function ResolveVideoSource(r)
local u=NormalizeVideo(r)
if not u then
return nil
end

if string.find(u,"http")then
if not(writefile and isfile and getcustomasset)then
warn"[ WindUI.Window.Background ] Missing file functions for remote video, using raw URL"
return u
end

EnsureAssetFolder()
local v=p.."/assets/."..ak.SanitizeFilename(u)..".webm"
if not isfile(v)then
local x,z=pcall(function()
local x=ak.Request{Url=u,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(v,x.Body)
end)
if not x then
warn("[ WindUI.Window.Background ] Failed to download video: "..tostring(z))
return nil
end
end

local x,z=pcall(function()
return getcustomasset(v)
end)
if not x then
warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(z))
return nil
end

warn"[ WindUI.Window.Background ] VideoFrame may not work with custom video"
return z
end

return u
end

local function ResolveImageSource(r)
if type(r)=="number"then
r=tostring(r)
end

if type(r)~="string"or r==""then
return nil
end

if string.match(r,"^%d+$")then
r="rbxassetid://"..r
end

if not string.match(r,"^https?://.+")then
return r
end

if not(writefile and isfile and getcustomasset)then
warn"[ WindUI.Window.Background ] Missing file functions for remote image, using raw URL"
return r
end

EnsureAssetFolder()
local u=p.."/assets/."..ak.SanitizeFilename(r)..GetImageExtension(r)
if not isfile(u)then
local v,x=pcall(function()
local v=ak.Request{Url=r,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(u,v.Body)
end)
if not v then
warn("[ Window.Background ] Failed to download image: "..tostring(x))
return nil
end
end

local v,x=pcall(function()
return getcustomasset(u)
end)
if not v then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(x))
return nil
end

return x
end

local function CreateBackgroundVideo(r)
local u=ResolveVideoSource(r)
if not u then
return nil
end

local v=aw.Closed and 1 or 0
local x=al("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=u,
Looped=true,
Volume=0,
},{
al("UICorner",{
CornerRadius=UDim.new(0,aw.UICorner)
}),
})

SetVideoTransparency(x,v)
x:Play()
return x
end

local function CreateBackgroundImage(r,u)
local v=ResolveImageSource(r)
if not v then
return nil
end

return al("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=v,
ImageTransparency=u,
ScaleType="Crop",
},{
al("UICorner",{
CornerRadius=UDim.new(0,aw.UICorner)
}),
})
end

local function SetBackgroundMedia(r,u)
if m and m~=r then
m:Destroy()
end

m=r
l=u==true

if m and aw.UIElements and aw.UIElements.Main and aw.UIElements.Main:FindFirstChild"Background"then
m.Parent=aw.UIElements.Main.Background
end
end

local r=aw.BackgroundVideo
if not r and typeof(aw.Background)=="string"then
r=string.match(aw.Background,"^video:(.+)")
end

if r then
local u=CreateBackgroundVideo(r)
if u then
aw.BackgroundVideo=NormalizeVideo(r)
SetBackgroundMedia(u,true)
end
elseif typeof(aw.Background)=="string"and aw.Background~=""then
local u=string.match(aw.Background,"^https?://.+")~=nil
local v=CreateBackgroundImage(aw.Background,u and 0 or 1)
if v then
SetBackgroundMedia(v,false)
end
end


local u=ak.NewRoundFrame(99,"Squircle",{
ImageTransparency=.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
Visible=aw.BottomDragBarEnabled,
},{
al("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=aw.BottomDragBarEnabled,
ZIndex=99,
Name="Frame",
})
})

function createAuthor(v)
return al("TextLabel",{
Text=v,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=aw.UIElements.Main and aw.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor"
},
Name="Author",
})
end

local v
local x

if aw.Author then
v=createAuthor(aw.Author)
end


local z=al("TextLabel",{
Text=aw.Title,
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle"
}
})

aw.UIElements.Main=al("Frame",{
Size=aw.Size,
Position=aw.Position,
BackgroundTransparency=1,
Parent=av.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
av.WindUI.UIScaleObj,
aw.AcrylicPaint and aw.AcrylicPaint.Frame or nil,
d,
ak.NewRoundFrame(aw.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground"
},

},{
m,
u,
az,



}),
j,
ay,
aB,
b,
al("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
al("UICorner",{
CornerRadius=UDim.new(0,aw.UICorner)
}),
aw.UIElements.SideBarContainer,
aw.UIElements.MainBar,

f,

h,
al("Frame",{
Size=UDim2.new(1,0,0,aw.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
g,






al("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
al("UIListLayout",{
Padding=UDim.new(0,aw.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
al("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
z,
v,
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,4)
})
}),
al("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
Visible=false,
},{
al("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,aw.UIPadding/2)
})
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(aw.Topbar.ButtonsType=="Default"and 1 or 0,0,0.5,0),
AnchorPoint=Vector2.new(aw.Topbar.ButtonsType=="Default"and 1 or 0,0.5),
Name="Right",
},{
al("UIListLayout",{
Padding=UDim.new(0,aw.Topbar.ButtonsType=="Default"and 9 or 0),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),

}),
al("UIPadding",{
PaddingTop=UDim.new(0,aw.UIPadding),
PaddingLeft=UDim.new(0,aw.Topbar.ButtonsType=="Default"and aw.UIPadding or aw.UIPadding-2),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,aw.UIPadding),
})
})
})
})

ak.AddSignal(aw.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local A=0
local B=aw.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X/av.WindUI.UIScale





A=aw.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X/av.WindUI.UIScale
if aw.Topbar.ButtonsType~="Default"then
A=A+B+aw.UIPadding-4
end



aw.UIElements.Main.Main.Topbar.Center.Position=UDim2.new(
0,
A+(aw.UIPadding/av.WindUI.UIScale),
0.5,
0
)
aw.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-A-B-((aw.UIPadding*2)/av.WindUI.UIScale),
1,
0
)
end)

if aw.Topbar.ButtonsType~="Default"then
ak.AddSignal(aw.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal"AbsoluteSize",function()
aw.UIElements.Main.Main.Topbar.Left.Position=UDim2.new(0,(aw.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X/av.WindUI.UIScale)+aw.UIPadding-4,0,0)
end)
end

function aw.CreateTopbarButton(A,B,C,F,G,H,J,L)
local M=ak.Image(
C,
C,
0,
aw.Folder,
"WindowTopbarIcon",
aw.Topbar.ButtonsType=="Default"and true or false,
H,
"WindowTopbarButtonIcon"
)
M.Size=aw.Topbar.ButtonsType=="Default"and UDim2.new(0,L or aw.TopBarButtonIconSize,0,L or aw.TopBarButtonIconSize)or UDim2.new(0,0,0,0)
M.AnchorPoint=Vector2.new(0.5,0.5)
M.Position=UDim2.new(0.5,0,0.5,0)
local N=FindImageObject(M)
if N then
N.ImageTransparency=aw.Topbar.ButtonsType=="Default"and 0 or 1
end
if aw.Topbar.ButtonsType~="Default"and N then
N.ImageColor3=ak.GetTextColorForHSB(J)
end

local O=ak.NewRoundFrame(aw.Topbar.ButtonsType=="Default"and aw.UICorner-(aw.UIPadding/2)or 999,"Squircle",{
Size=aw.Topbar.ButtonsType=="Default"and UDim2.new(0,aw.Topbar.Height-16,0,aw.Topbar.Height-16)or UDim2.new(0,14,0,14),
LayoutOrder=G or 999,
Parent=aw.Topbar.ButtonsType=="Default"and aw.UIElements.Main.Main.Topbar.Right or nil,

ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=aw.Topbar.ButtonsType~="Default"and(J or Color3.fromHex"#ff3030")or nil,
ThemeTag=aw.Topbar.ButtonsType=="Default"and{
ImageColor3="Text"
}or nil,
ImageTransparency=aw.Topbar.ButtonsType=="Default"and 1 or 0
},{
ak.NewRoundFrame(aw.Topbar.ButtonsType=="Default"and aw.UICorner-(aw.UIPadding/2)or 999,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Black",
},
ImageTransparency=aw.Topbar.ButtonsType=="Default"and 1 or.8,
Name="Outline"
},{
aw.Topbar.ButtonsType=="Default"and al("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})or nil,
}),
M
},true)

al("Frame",{
Size=UDim2.new(0,24,0,24),
BackgroundTransparency=1,
Parent=aw.Topbar.ButtonsType~="Default"and aw.UIElements.Main.Main.Topbar.Right or nil,
LayoutOrder=G or 999
},{
aw.Topbar.ButtonsType~="Default"and O or nil,
})



aw.TopBarButtons[100-G]={
Name=B,
Object=O
}

ak.AddSignal(O.MouseButton1Click,function()
F()
end)
ak.AddSignal(O.MouseEnter,function()
if aw.Topbar.ButtonsType=="Default"then
am(O,.15,{ImageTransparency=.93}):Play()
am(O.Outline,.15,{ImageTransparency=.75}):Play()

else

if N then
am(N,.1,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
am(M,.1,{Size=UDim2.new(0,L or aw.TopBarButtonIconSize,0,L or aw.TopBarButtonIconSize)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
ak.AddSignal(O.InputEnded,function()
if aw.Topbar.ButtonsType=="Default"then
am(O,.1,{ImageTransparency=1}):Play()
am(O.Outline,.1,{ImageTransparency=1}):Play()

else

if N then
am(N,.1,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
am(M,.1,{Size=UDim2.new(0,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)

return O
end



local A=ak.Drag(
aw.UIElements.Main,
{aw.UIElements.Main.Main.Topbar,u.Frame},
function(A,B)
if not aw.Closed then
if aw.BottomDragBarEnabled then
if A and B==u.Frame then
am(u,.1,{ImageTransparency=.35}):Play()
else
am(u,.2,{ImageTransparency=.8}):Play()
end
end
aw.Position=aw.UIElements.Main.Position
aw.Dragging=A
end
end
)

if not l and aw.Background and typeof(aw.Background)=="table"then

local B=al"UIGradient"
for C,F in next,aw.Background do
B[C]=F
end

aw.UIElements.BackgroundGradient=ak.NewRoundFrame(aw.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=aw.UIElements.Main.Background,
ImageTransparency=aw.Transparent and av.WindUI.TransparencyValue or 0
},{
B
})
end














aw.OpenButtonMain=a.B().New(aw)


task.spawn(function()
if aw.Icon then

local B=al("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=aw.UIElements.Main.Main.Topbar.Left,
})

x=ak.Image(
aw.Icon,
aw.Title,
aw.IconRadius,
aw.Folder,
"Window",
true,
aw.IconThemed,
"WindowTopbarIcon"
)
x.Parent=B
x.Size=UDim2.new(0,aw.IconSize,0,aw.IconSize)
x.Position=UDim2.new(0.5,0,0.5,0)
x.AnchorPoint=Vector2.new(0.5,0.5)

aw.OpenButtonMain:SetIcon(aw.Icon)











else
aw.OpenButtonMain:SetIcon(aw.Icon)

end
end)

function aw.SetToggleKey(B,C)
aw.ToggleKey=C
end

function aw.SetTitle(B,C)
aw.Title=C
z.Text=C
end

function aw.SetAuthor(B,C)
aw.Author=C
if not v then
v=createAuthor(aw.Author)
end

v.Text=C
end

function aw.SetSize(B,C)
if typeof(C)=="UDim2"then
aw.Size=C

am(aw.UIElements.Main,0.08,{Size=C},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end


function aw.SetBackgroundVideo(B,C)
local F=NormalizeVideo(C)
if not F then
return false
end

local G=CreateBackgroundVideo(F)
if not G then
return false
end

aw.BackgroundVideo=F
aw.Background="video:"..F

SetBackgroundMedia(G,true)
m.Visible=not aw.Closed
SetVideoTransparency(m,aw.Closed and 1 or 0)

return true
end

function aw.SetBackgroundImage(B,C)
if type(C)=="number"then
C=tostring(C)
end

if type(C)~="string"or C==""then
return false
end

local F=aw.Closed and 1 or aw.BackgroundImageTransparency
local G=CreateBackgroundImage(C,F)
if not G then
return false
end

aw.Background=C
aw.BackgroundVideo=nil

SetBackgroundMedia(G,false)
m.Visible=not aw.Closed

return true
end
function aw.SetBackgroundImageTransparency(B,C)
if m and m:IsA"ImageLabel"then
m.ImageTransparency=math.floor(C*10+0.5)/10
end
aw.BackgroundImageTransparency=math.floor(C*10+0.5)/10
end

function aw.SetBackgroundTransparency(B,C)
local F=math.floor(tonumber(C)*10+0.5)/10
av.WindUI.TransparencyValue=F
aw:ToggleTransparency(F>0)
end

local B
local C
ak.Icon"minimize"
ak.Icon"maximize"

aw:CreateTopbarButton("Fullscreen",aw.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",function()
aw:ToggleFullscreen()
end,(aw.Topbar.ButtonsType=="Default"and 998 or 999),true,Color3.fromHex"#60C762",aw.Topbar.ButtonsType=="Mac"and 9 or nil)

function aw.ToggleFullscreen(F)
local G=aw.IsFullscreen

A:Set(G)

if not G then
B=aw.UIElements.Main.Position
C=aw.UIElements.Main.Size

aw.CanResize=false
else
if aw.Resizable then
aw.CanResize=true
end
end

am(aw.UIElements.Main,0.45,{Size=G and C or UDim2.new(1,-20,1,-72)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

am(aw.UIElements.Main,0.45,{Position=G and B or UDim2.new(0.5,0,0.5,26)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()



aw.IsFullscreen=not G
end


aw:CreateTopbarButton("Minimize","minus",function()
aw:Close()






















end,(aw.Topbar.ButtonsType=="Default"and 997 or 998),nil,Color3.fromHex"#F4C948")

function aw.OnOpen(F,G)
aw.OnOpenCallback=G
end
function aw.OnClose(F,G)
aw.OnCloseCallback=G
end
function aw.OnDestroy(F,G)
aw.OnDestroyCallback=G
end

if av.WindUI.UseAcrylic then
aw.AcrylicPaint.AddParent(aw.UIElements.Main)
end

function aw.SetIconSize(F,G)
local H
if typeof(G)=="number"then
H=UDim2.new(0,G,0,G)
aw.IconSize=G
elseif typeof(G)=="UDim2"then
H=G
aw.IconSize=G.X.Offset
end

if x then
x.Size=H
end
end

function aw.Open(F)
task.spawn(function()
if aw.OnOpenCallback then
task.spawn(function()
ak.SafeCallback(aw.OnOpenCallback)
end)
end


task.wait(.06)
aw.Closed=false

am(aw.UIElements.Main.Background,0.2,{
ImageTransparency=aw.Transparent and av.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if aw.UIElements.BackgroundGradient then
am(aw.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

am(aw.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if m then
if m:IsA"VideoFrame"then
m.Visible=true
local G=TweenVideoTransparency(m,0.2,0,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
if G then
G:Play()
end
else
am(m,0.2,{
ImageTransparency=aw.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if aw.OpenButtonMain and aw.IsOpenButtonEnabled then
aw.OpenButtonMain:Visible(false)
end


am(d,0.25,{ImageTransparency=aw.ShadowTransparency},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if j then
am(j,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.3)
if aw.BottomDragBarEnabled then
u.Visible=true
am(u,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
end
A:Set(true)
task.wait(.45)
if aw.Resizable then
if aA then
am(aA,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
end
aw.CanResize=true
end
end)


aw.CanDropdown=true

aw.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
aw.UIElements.Main:WaitForChild"Main".Visible=true

av.WindUI:ToggleAcrylic(true)
end)
end)
end
function aw.Close(F)
local G={}

if aw.OnCloseCallback then
task.spawn(function()
ak.SafeCallback(aw.OnCloseCallback)
end)
end

av.WindUI:ToggleAcrylic(false)

aw.UIElements.Main:WaitForChild"Main".Visible=false

aw.CanDropdown=false
aw.Closed=true

am(aw.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if aw.UIElements.BackgroundGradient then
am(aw.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

am(aw.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if m then
if m:IsA"VideoFrame"then
local H=m
local J=TweenVideoTransparency(H,0.2,1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
if J then
J:Play()
end
task.delay(0.21,function()
if aw.Closed and m==H then
H.Visible=false
end
end)
else
am(m,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
am(d,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if j then
am(j,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if aw.BottomDragBarEnabled then
am(u,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
end
if aA then
am(aA,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
end
A:Set(false)
aw.CanResize=false

task.spawn(function()
task.wait(0.4)
aw.UIElements.Main.Visible=false

if aw.OpenButtonMain and not aw.Destroyed and not aw.IsPC and aw.IsOpenButtonEnabled then
aw.OpenButtonMain:Visible(true)
end
end)

function G.Destroy(H)
task.spawn(function()
if aw.OnDestroyCallback then
task.spawn(function()
ak.SafeCallback(aw.OnDestroyCallback)
end)
end
if aw.AcrylicPaint and aw.AcrylicPaint.Model then
aw.AcrylicPaint.Model:Destroy()
end
aw.Destroyed=true
task.wait(0.4)
av.WindUI.ScreenGui:Destroy()
av.WindUI.NotificationGui:Destroy()
av.WindUI.DropdownGui:Destroy()
av.WindUI.TooltipGui:Destroy()

ak.DisconnectAll()

return
end)
end

return G
end
function aw.Destroy(F)
return aw:Close():Destroy()
end
function aw.Toggle(F)
if aw.Closed then
aw:Open()
else
aw:Close()
end
end


function aw.ToggleTransparency(F,G)

aw.Transparent=G
av.WindUI.Transparent=G

aw.UIElements.Main.Background.ImageTransparency=G and av.WindUI.TransparencyValue or 0



end

function aw.LockAll(F)
for G,H in next,aw.AllElements do
if H.Lock then H:Lock()end
end
end
function aw.UnlockAll(F)
for G,H in next,aw.AllElements do
if H.Unlock then H:Unlock()end
end
end
function aw.GetLocked(F)
local G={}

for H,J in next,aw.AllElements do
if J.Locked then table.insert(G,J)end
end

return G
end
function aw.GetUnlocked(F)
local G={}

for H,J in next,aw.AllElements do
if J.Locked==false then table.insert(G,J)end
end

return G
end

function aw.GetUIScale(F,G)
return av.WindUI.UIScale
end

function aw.SetUIScale(F,G)
av.WindUI.UIScale=G
am(av.WindUI.UIScaleObj,.2,{Scale=G},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return aw
end

function aw.SetToTheCenter(F)
am(aw.UIElements.Main,0.45,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return aw
end

function aw.SetCurrentConfig(F,G)
aw.CurrentConfig=G
end

do
local F=40
local G=ai.ViewportSize
local H=aw.UIElements.Main.AbsoluteSize

if not aw.IsFullscreen and aw.AutoScale then
local J=G.X-(F*2)
local L=G.Y-(F*2)

local M=J/H.X
local N=L/H.Y

local O=math.min(M,N)

local P=0.3
local Q=1.0

local R=math.clamp(O,P,Q)

local S=aw:GetUIScale()or 1
local T=0.05

if math.abs(R-S)>T then
aw:SetUIScale(R)
end
end
end


if aw.OpenButtonMain and aw.OpenButtonMain.Button then
ak.AddSignal(aw.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


aw:Open()
end)
end

ak.AddSignal(ad.InputBegan,function(F,G)
if G then return end

if aw.ToggleKey then
if F.KeyCode==aw.ToggleKey then
aw:Toggle()
end
end
end)

task.spawn(function()

aw:Open()
end)

function aw.EditOpenButton(F,G)
return aw.OpenButtonMain:Edit(G)
end

if aw.OpenButton and typeof(aw.OpenButton)=="table"then
aw:EditOpenButton(aw.OpenButton)
end


local F=a._()
local G=a.aa()
local H=F.Init(aw,av.WindUI,av.WindUI.TooltipGui)
H:OnChange(function(J)aw.CurrentTab=J end)

aw.TabModule=H

local function CreateSideBarLabel(J,L)
J=J or{}

local M=J.Title or J.Text or"Label"
local N=an(
M,
J.Icon,
L,
J.Placeholder==true,
J.Radius
)

local O=typeof(J.Height)=="number"and math.max(J.Height,18)or 34
N.Size=J.Size or UDim2.new(1,-7,0,O)
N.Visible=J.Visible~=false

if typeof(J.LayoutOrder)=="number"then
N.LayoutOrder=J.LayoutOrder
end

local P={
__type="SideBarLabel",
Title=M,
ElementFrame=N,
LabelFrame=N,
}

function P.SetTitle(Q,R)
Q.Title=tostring(R or"")

local S=Q.LabelFrame:FindFirstChild("TextLabel",true)
if S then
S.Text=Q.Title
end

return Q
end

function P.SetVisible(Q,R)
Q.ElementFrame.Visible=R~=false
return Q
end

function P.Destroy(Q)
if Q.ElementFrame then
Q.ElementFrame:Destroy()
Q.ElementFrame=nil
Q.LabelFrame=nil
end
end

return P
end

local function CreateSideBarButton(J,L)
J=J or{}

local M=typeof(J.Height)=="number"and math.max(J.Height,20)or 34
local N=al("Frame",{
Name="SideBarButton",
Parent=L,
BackgroundTransparency=1,
Size=J.Size or UDim2.new(1,-7,0,M),
Visible=J.Visible~=false,
})

if typeof(J.LayoutOrder)=="number"then
N.LayoutOrder=J.LayoutOrder
end

local O={
__type="SideBarButton",
Title=J.Title or J.Text or"Button",
Callback=J.Callback,
ElementFrame=N,
ButtonFrame=nil,
}

local P=ao(
O.Title,
J.Icon,
function()
if O.Callback then
ak.SafeCallback(O.Callback,O)
end
end,
J.Variant or"Secondary",
N,
nil,
J.FullRounded,
J.Radius
)

P.AutomaticSize="None"
P.Size=UDim2.new(1,0,1,0)
P.Position=UDim2.new(0.5,0,0.5,0)
P.AnchorPoint=Vector2.new(0.5,0.5)

O.ButtonFrame=P

function O.SetTitle(Q,R)
Q.Title=tostring(R or"")

local S=Q.ButtonFrame:FindFirstChild("TextLabel",true)
if S then
S.Text=Q.Title
end

return Q
end

function O.SetCallback(Q,R)
Q.Callback=R
return Q
end

function O.SetVisible(Q,R)
Q.ElementFrame.Visible=R~=false
return Q
end

function O.Destroy(Q)
if Q.ElementFrame then
Q.ElementFrame:Destroy()
Q.ElementFrame=nil
Q.ButtonFrame=nil
end
end

return O
end

local function CreateSideBarSpace(J,L)
J=J or{}

local M=table.clone(J)
M.Parent=L
M.ParentType=M.ParentType or"Window"local

N, O=ar:New(M)
return O
end

local function CreateSideBarDivider(J,L)
J=J or{}

local M=table.clone(J)
M.Parent=L
M.ParentType=M.ParentType or"Window"local

N, O=aq:New(M)
return O
end


function aw.Tab(J,L)
L.Parent=aw.UIElements.SideBar.Frame
return H.New(L,av.WindUI.UIScale)
end

function aw.SelectTab(J,L)
H:SelectTab(L)
end

function aw.Section(J,L)
return G.New(L,aw.UIElements.SideBar.Frame,aw.Folder,av.WindUI.UIScale,aw)
end

function aw.SideBarLabel(J,L)
return CreateSideBarLabel(L,aw.UIElements.SideBar.Frame)
end
aw.SidebarLabel=aw.SideBarLabel
aw.Label=aw.SideBarLabel

function aw.SideBarButton(J,L)
return CreateSideBarButton(L,aw.UIElements.SideBar.Frame)
end
aw.SidebarButton=aw.SideBarButton
aw.Button=aw.SideBarButton

function aw.SideBarSpace(J,L)
local M=CreateSideBarSpace(L,aw.UIElements.SideBar.Frame)
return M.ElementFrame
end
aw.SidebarSpace=aw.SideBarSpace
aw.Space=aw.SideBarSpace

function aw.IsResizable(J,L)
aw.Resizable=L
aw.CanResize=L
end

function aw.SetPanelBackground(J,L)
if typeof(L)=="boolean"then
aw.HidePanelBackground=L

aw.UIElements.MainBar.Background.Visible=L

if H then
for M,N in next,H.Containers do
N.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,aw.HidePanelBackground and 20 or 10)
N.ScrollingFrame.UIPadding.PaddingLeft=UDim.new(0,aw.HidePanelBackground and 20 or 10)
N.ScrollingFrame.UIPadding.PaddingRight=UDim.new(0,aw.HidePanelBackground and 20 or 10)
N.ScrollingFrame.UIPadding.PaddingBottom=UDim.new(0,aw.HidePanelBackground and 20 or 10)
end
end
end
end

function aw.Divider(J,L)
local M=CreateSideBarDivider(L,aw.UIElements.SideBar.Frame)
return M.ElementFrame
end

function aw.SideBarDivider(J,L)
return aw:Divider(L)
end
aw.SidebarDivider=aw.SideBarDivider

local J=a.m().Init(aw,nil)
function aw.Dialog(L,M)
local N={
Title=M.Title or"Dialog",
Width=M.Width or 320,
Content=M.Content,
Buttons=M.Buttons or{},

TextPadding=14,
}
local O=J.Create(false)

O.UIElements.Main.Size=UDim2.new(0,N.Width,0,0)

local P=al("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=O.UIElements.Main
},{
al("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,O.UIPadding),
VerticalAlignment="Center"
}),
al("UIPadding",{
PaddingTop=UDim.new(0,N.TextPadding/2),
PaddingLeft=UDim.new(0,N.TextPadding/2),
PaddingRight=UDim.new(0,N.TextPadding/2),
})
})

local Q
if M.Icon then
Q=ak.Image(
M.Icon,
N.Title..":"..M.Icon,
0,
aw,
"Dialog",
true,
M.IconThemed
)
Q.Size=UDim2.new(0,22,0,22)
Q.Parent=P
end

O.UIElements.UIListLayout=al("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=O.UIElements.Main
})

al("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=O.UIElements.Main,
})


O.UIElements.Title=al("TextLabel",{
Text=N.Title,
TextSize=20,
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,Q and-26-O.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=P
})
if N.Content then
al("TextLabel",{
Text=N.Content,
TextSize=18,
TextTransparency=.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=O.UIElements.Main
},{
al("UIPadding",{
PaddingLeft=UDim.new(0,N.TextPadding/2),
PaddingRight=UDim.new(0,N.TextPadding/2),
PaddingBottom=UDim.new(0,N.TextPadding/2),
})
})
end

local R=al("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local S=al("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=O.UIElements.Main,
LayoutOrder=4,
},{
R,






})


local T={}

for U,V in next,N.Buttons do
local W=ao(V.Title,V.Icon,V.Callback,V.Variant,S,O,true)
table.insert(T,W)
end

local function CheckButtonsOverflow()
R.FillDirection=Enum.FillDirection.Horizontal
R.HorizontalAlignment=Enum.HorizontalAlignment.Right
R.VerticalAlignment=Enum.VerticalAlignment.Center
S.AutomaticSize=Enum.AutomaticSize.None

for U,V in ipairs(T)do
V.Size=UDim2.new(0,0,1,0)
V.AutomaticSize=Enum.AutomaticSize.X
end

wait()

local U=R.AbsoluteContentSize.X/av.WindUI.UIScale
local V=S.AbsoluteSize.X/av.WindUI.UIScale

if U>V then
R.FillDirection=Enum.FillDirection.Vertical
R.HorizontalAlignment=Enum.HorizontalAlignment.Right
R.VerticalAlignment=Enum.VerticalAlignment.Bottom
S.AutomaticSize=Enum.AutomaticSize.Y

for W,X in ipairs(T)do
X.Size=UDim2.new(1,0,0,40)
X.AutomaticSize=Enum.AutomaticSize.None
end
else
local W=V-U
if W>0 then
local X
local Y=math.huge

for _,aC in ipairs(T)do
local aD=aC.AbsoluteSize.X/av.WindUI.UIScale
if aD<Y then
Y=aD
X=aC
end
end

if X then
X.Size=UDim2.new(0,Y+W,1,0)
X.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

ak.AddSignal(O.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
O:Open()

return O
end

local aC=false

aw:CreateTopbarButton("Close","x",function()
if not aC then
if not aw.IgnoreAlerts then
aC=true
aw:SetToTheCenter()
aw:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()aC=false end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()
aC=false
aw:Destroy()
end,
Variant="Primary",
}
}
}
else
aw:Destroy()
end
end
end,(aw.Topbar.ButtonsType=="Default"and 999 or 997),nil,Color3.fromHex"#F4695F")

function aw.Tag(aD,L)
if aw.UIElements.Main.Main.Topbar.Center.Visible==false then aw.UIElements.Main.Main.Topbar.Center.Visible=true end
return as:New(L,aw.UIElements.Main.Main.Topbar.Center)
end

function aw.Watermark(aD,L)
if typeof(L)~="table"then
L={}
end

if aw.WatermarkObject and aw.WatermarkObject.Destroy then
aw.WatermarkObject:Destroy()
aw.WatermarkObject=nil
end

aw.WatermarkObject=at:New(L,aw.UIElements.Main.Background)

return aw.WatermarkObject
end

function aw.CreateWatermark(aD,L)
return aw:Watermark(L)
end

function aw.SetBottomDragBarEnabled(aD,L)
if L~=false then L=true end

aw.BottomDragBarEnabled=L
u.Frame.Active=L

if L then
u.Visible=true
u.ImageTransparency=.8
if not aw.Closed then
am(u,.2,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
else
u.Size=UDim2.new(0,0,0,4)
end
else
am(u,.2,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
task.delay(.2,function()
if not aw.BottomDragBarEnabled then
u.Visible=false
end
end)
end
end

if aw.WatermarkConfig and aw.WatermarkConfig~=false then
aw:Watermark(typeof(aw.WatermarkConfig)=="table"and aw.WatermarkConfig or{})
end

local aD=false
local L=aw.UIElements.Main.Size
local M=Vector2.new(0,0)

local function startResizing(N)
if aw.CanResize then
aD=true
aB.Active=true
L=aw.UIElements.Main.Size
M=N.Position


if aA then
am(aA,0.1,{ImageTransparency=.35}):Play()
end

ak.AddSignal(N.Changed,function()
if N.UserInputState==Enum.UserInputState.End then
aD=false
aB.Active=false


if aA then
am(aA,0.17,{ImageTransparency=.8}):Play()
end
end
end)
end
end

ak.AddSignal(az.InputBegan,function(N)
if N.UserInputType==Enum.UserInputType.MouseButton1 or N.UserInputType==Enum.UserInputType.Touch then
if aw.CanResize then
startResizing(N)
end
end
end)

ak.AddSignal(ad.InputChanged,function(N)
if N.UserInputType==Enum.UserInputType.MouseMovement or N.UserInputType==Enum.UserInputType.Touch then
if aD and aw.CanResize then
local O=N.Position-M
local P=UDim2.new(0,L.X.Offset+O.X*2,0,L.Y.Offset+O.Y*2)

P=UDim2.new(
P.X.Scale,
math.clamp(P.X.Offset,aw.MinSize.X,aw.MaxSize.X),
P.Y.Scale,
math.clamp(P.Y.Offset,aw.MinSize.Y,aw.MaxSize.Y)
)

am(aw.UIElements.Main,0,{
Size=P
}):Play()

aw.Size=P
end
end
end)




local N=0
local O=0.4
local P
local Q=0

function onDoubleClick()
aw:SetToTheCenter()
end

u.Frame.MouseButton1Up:Connect(function()
if not aw.BottomDragBarEnabled then return end

local R=tick()
local S=aw.Position

Q=Q+1

if Q==1 then
N=R
P=S

task.spawn(function()
task.wait(O)
if Q==1 then
Q=0
P=nil
end
end)

elseif Q==2 then
if R-N<=O and S==P then
onDoubleClick()
end

Q=0
P=nil
N=0
else
Q=1
N=R
P=S
end
end)





if not aw.HideSearchBar then
local R=a.ac()
local S=false





















local T=an("Search","search",aw.UIElements.SideBarContainer,true)
T.Size=UDim2.new(1,-aw.UIPadding/2,0,39)
T.Position=UDim2.new(0,aw.UIPadding/2,0,0)

ak.AddSignal(T.MouseButton1Click,function()
if S then return end

R.new(aw.TabModule,aw.UIElements.Main,function()

S=false
if aw.Resizable then
aw.CanResize=true
end

am(b,0.1,{ImageTransparency=1}):Play()
b.Active=false
end)
am(b,0.1,{ImageTransparency=.65}):Play()
b.Active=true

S=true
aw.CanResize=false
end)
end




function aw.DisableTopbarButtons(R,S)
for T,U in next,S do
for V,W in next,aw.TopBarButtons do
if W.Name==U then
W.Object.Visible=false
end
end
end
end




























return aw
end end function a.ad():typeof(__modImpl())local aa=a.cache.ad if not aa then aa={c=__modImpl()}a.cache.ad=aa end return aa.c end end end

local aa=game:GetService"RunService"
local ad={
Window=nil,
Theme=nil,
Creator=a.c(),
LocalizationModule=a.d(),
NotificationModule=a.f(),
Themes=nil,
Transparent=false,

TransparencyValue=.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.k(),

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,
}


local ae=(cloneref or clonereference or function(ae)return ae end)

ad.cloneref=ae

ae(game:GetService"HttpService")
local ag=ae(game:GetService"Players")
local ai=ae(game:GetService"CoreGui")local aj=

ag.LocalPlayer or nil

local ak=a.n()local al=

ad.Services


local am=ad.Creator

local an=am.New local ao=
am.Tween


local ap=a.r()


local aq=protectgui or(syn and syn.protect_gui)or function()end

local ar=gethui and gethui()or(ai or game.Players.LocalPlayer:WaitForChild"PlayerGui")

local as=an("UIScale",{
Scale=ad.UIScale,
})

ad.UIScaleObj=as

ad.ScreenGui=an("ScreenGui",{
Name="WindUI",
Parent=ar,
IgnoreGuiInset=true,
ScreenInsets="None",
},{

an("Folder",{
Name="Window"
}),






an("Folder",{
Name="KeySystem"
}),
an("Folder",{
Name="Popups"
}),
an("Folder",{
Name="ToolTips"
})
})

ad.NotificationGui=an("ScreenGui",{
Name="WindUI/Notifications",
Parent=ar,
IgnoreGuiInset=true,
})
ad.DropdownGui=an("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=ar,
IgnoreGuiInset=true,
})
ad.TooltipGui=an("ScreenGui",{
Name="WindUI/Tooltips",
Parent=ar,
IgnoreGuiInset=true,
})
aq(ad.ScreenGui)
aq(ad.NotificationGui)
aq(ad.DropdownGui)
aq(ad.TooltipGui)

am.Init(ad)


function ad.SetParent(at,au)
ad.ScreenGui.Parent=au
ad.NotificationGui.Parent=au
ad.DropdownGui.Parent=au
ad.TooltipGui.Parent=au
end
ad.TransparencyValue=math.clamp(ad.TransparencyValue,0,1)

local at=ad.NotificationModule.Init(ad.NotificationGui)

function ad.Notify(au,av)
av.Holder=at.Frame
av.Window=ad.Window

return ad.NotificationModule.New(av)
end

function ad.SetNotificationLower(au,av)
at.SetLower(av)
end

function ad.SetFont(au,av)
am.UpdateFont(av)
end

function ad.OnThemeChange(au,av)
ad.OnThemeChangeFunction=av
end

function ad.AddTheme(au,av)
ad.Themes[av.Name]=av
return av
end

function ad.SetTheme(au,av)
if ad.Themes[av]then
ad.Theme=ad.Themes[av]
am.SetTheme(ad.Themes[av])

if ad.OnThemeChangeFunction then
ad.OnThemeChangeFunction(av)
end

return ad.Themes[av]
end
return nil
end

function ad.GetThemes(au)
return ad.Themes
end
function ad.GetCurrentTheme(au)
return ad.Theme.Name
end
function ad.GetTransparency(au)
return ad.Transparent or false
end
function ad.GetWindowSize(au)
if ad.Window and ad.Window.UIElements and ad.Window.UIElements.Main then
return ad.Window.UIElements.Main.Size
end
return nil
end
function ad.Localization(au,av)
return ad.LocalizationModule:New(av,am)
end

function ad.SetLanguage(au,av)
if am.Localization then
return am.SetLanguage(av)
end
return false
end

function ad.ToggleAcrylic(au,av)
if ad.Window and ad.Window.AcrylicPaint and ad.Window.AcrylicPaint.Model then
ad.Window.Acrylic=av
ad.Window.AcrylicPaint.Model.Transparency=av and 0.98 or 1
if av then
ap.Enable()
else
ap.Disable()
end
end
end


function ad.Gradient(au,av,aw)
if typeof(av)~="table"then
av={}
end

local ax={}
local ay={}

for az,aA in next,av do
local aB=tonumber(az)
if aB then
aB=math.clamp(aB/100,0,1)

local aC=aA.Color
if typeof(aC)=="string"and string.sub(aC,1,1)=="#"then
aC=Color3.fromHex(aC)
end

local aD=aA.Transparency or 0

table.insert(ax,ColorSequenceKeypoint.new(aB,aC))
table.insert(ay,NumberSequenceKeypoint.new(aB,aD))
end
end

table.sort(ax,function(az,aA)return az.Time<aA.Time end)
table.sort(ay,function(az,aA)return az.Time<aA.Time end)

if#ax==0 then
table.insert(ax,ColorSequenceKeypoint.new(0,Color3.new(1,1,1)))
table.insert(ax,ColorSequenceKeypoint.new(1,Color3.new(1,1,1)))
table.insert(ay,NumberSequenceKeypoint.new(0,0))
table.insert(ay,NumberSequenceKeypoint.new(1,0))
elseif#ax<2 then
table.insert(ax,ColorSequenceKeypoint.new(1,ax[1].Value))
table.insert(ay,NumberSequenceKeypoint.new(1,ay[1].Value))
end

local az={
Color=ColorSequence.new(ax),
Transparency=NumberSequence.new(ay),
}

if aw then
for aA,aB in pairs(aw)do
az[aA]=aB
end
end

return az
end


function ad.Popup(au,av)
av.WindUI=ad
return a.s().new(av)
end


ad.Themes=a.t()(ad)

am.Themes=ad.Themes


ad:SetTheme"Dark"
ad:SetLanguage(am.Language)


function ad.CreateWindow(au,av)
local aw=a.ad()

if not aa:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
if av.Folder then
makefolder(av.Folder)
else
makefolder(av.Title)
end
end

av.WindUI=ad
av.Parent=ad.ScreenGui.Window

if ad.Window then
warn"You cannot create more than one window"
return
end

local ax=true

local ay=ad.Themes[av.Theme or"Dark"]


am.SetTheme(ay)


local az=gethwid or function()
return ag.LocalPlayer.UserId
end

local aA=az()

if av.KeySystem then
ax=false

local function loadKeysystem()
ak.new(av,aA,function(aB)ax=aB end)
end

local aB=(av.Folder or"Temp").."/"..aA..".key"

if av.KeySystem.KeyValidator then
if av.KeySystem.SaveKey and isfile(aB)then
local aC=readfile(aB)
local aD=av.KeySystem.KeyValidator(aC)

if aD then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not av.KeySystem.API then
if av.KeySystem.SaveKey and isfile(aB)then
local aC=readfile(aB)
local aD=(type(av.KeySystem.Key)=="table")
and table.find(av.KeySystem.Key,aC)
or tostring(av.KeySystem.Key)==tostring(aC)

if aD then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(aB)then
local aC=readfile(aB)
local aD=false

for b,d in next,av.KeySystem.API do
local f=ad.Services[d.Type]
if f then
local g={}
for h,j in next,f.Args do
table.insert(g,d[j])
end

local h=f.New(table.unpack(g))
local j=h.Verify(aC)
if j then
aD=true
break
end
end
end

ax=aD
if not aD then loadKeysystem()end
else
loadKeysystem()
end
end

repeat task.wait()until ax
end

local aB=aw(av)

ad.Transparent=av.Transparent
ad.Window=aB

if av.Acrylic then
ap.init()
end













return aB
end

return ad
