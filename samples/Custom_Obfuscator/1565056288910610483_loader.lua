--[[
 __        __          _   _       _
 \ \      / /__  ___  | | | |_   _| |__
  \ \ /\ / / _ \/ _ \ | |_| | | | | '_ \
   \ V  V /  __/  __/ |  _  | |_| | |_) |
    \_/\_/ \___|\___| |_| |_|\__,_|_.__/

                    WeeHub
        https://weehub-site.pages.dev/
]]

local a={[6504986360]={id="\098\103\115\105",name="\066\117\098\098\108\101\032\071\117\109\032\083\105\109\117\108\097\116\111\114\032\073\078\070\073\078\073\084\089",scriptPath
="\047\115\099\114\105\112\116\047\098\103\115\105"},[3183403065]={id="\097\110\105\109\101\045\097\100\118\101\110\116\117\114\101\115",name="\065\110\105\109\101\032\065\100\118\101\110\116\117\114\101\115",
scriptPath="\047\115\099\114\105\112\116\047\097\110\105\109\101\045\097\100\118\101\110\116\117\114\101\115"}}if not game:IsLoaded()then game.Loaded:
Wait()end local b=a[game.GameId]if not b then warn(
"\087\101\101\072\117\098\058\032\116\104\105\115\032\103\097\109\101\032\105\115\032\110\111\116\032\115\117\112\112\111\114\116\101\100\032\121\101\116\046")return end local c=Color3.fromRGB(15,
35,91)local function d(e,f,g)local h=Instance.new("\085\073\083\116\114\111\107\101")h.Color=f h.
Thickness=g h.ApplyStrokeMode=Enum.ApplyStrokeMode.Border h.Parent=e return h
end local function e(f,g)f.BorderSizePixel=0 f.BackgroundColor3=Color3.new(1,1,1
)local h=f:FindFirstChild("\073\099\101\066\111\114\100\101\114")if not h then h=d(f,Color3.fromRGB(129,190
,228),1)h.Name="\073\099\101\066\111\114\100\101\114"h.LineJoinMode=Enum.LineJoinMode.Round end h.Color=g
and Color3.fromRGB(20,142,201)or Color3.fromRGB(129,190,228)local i=f:
FindFirstChild("\073\099\101\070\105\108\108")if not i then i=Instance.new("\085\073\071\114\097\100\105\101\110\116")i.Name=
"\073\099\101\070\105\108\108"i.Rotation=90 i.Parent=f end i.Color=g and ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(174,249,255)),ColorSequenceKeypoint.
new(0.5,Color3.fromRGB(85,220,248)),ColorSequenceKeypoint.new(1,Color3.fromRGB(
57,177,235))})or ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(
250,254,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(226,245,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(190,223,249))})end local function f(g
)local h=Instance.new("\085\073\071\114\097\100\105\101\110\116")h.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(190,224,255)),ColorSequenceKeypoint.
new(0.45,Color3.fromRGB(243,252,255)),ColorSequenceKeypoint.new(1,Color3.
fromRGB(165,210,250))})h.Rotation=35 h.Parent=g d(g,Color3.fromRGB(112,188,238),
2)for i=1,16 do local j=Instance.new("\084\101\120\116\076\097\098\101\108")j.Name="\073\099\101\071\108\105\110\116"j.
BackgroundTransparency=1 j.Text="\043"j.Font=Enum.Font.Gotham j.TextSize=i%3==0 and
22 or 12 j.TextColor3=Color3.new(1,1,1)j.TextTransparency=0.3 j.Size=UDim2.
fromOffset(22,22)j.Position=UDim2.new(((i*37)%97)/100,-10,((i*23)%95)/100,-10)j.
ZIndex=0 j.Parent=g end end local function g(h)h.Text="\087\101\101\072\117\098"h.Font=Enum.Font.
FredokaOne h.TextSize=36 h.TextColor3=Color3.new(1,1,1)local i=Instance.new(
"\085\073\083\116\114\111\107\101")i.Color=Color3.fromRGB(13,29,90)i.Thickness=2.5 i.LineJoinMode=Enum.
LineJoinMode.Round i.Parent=h local j=Instance.new("\085\073\071\114\097\100\105\101\110\116")j.Rotation=90 j.
Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)
),ColorSequenceKeypoint.new(0.42,Color3.fromRGB(184,250,255)),
ColorSequenceKeypoint.new(0.52,Color3.fromRGB(56,225,255)),ColorSequenceKeypoint
.new(1,Color3.fromRGB(4,154,233))})j.Parent=h end local h=game:GetService(
"\080\108\097\121\101\114\115")local i=h.LocalPlayer local j="\087\101\101\072\117\098\045\107\101\121\045"..tostring(i.UserId)..
"\046\116\120\116"local function k(l)return type(l)=="\115\116\114\105\110\103"and#l==68 and l:match(
"\094\119\101\101\095\037\120\043\036")~=nil end local function l()if type(delfile)=="\102\117\110\099\116\105\111\110"then pcall(
delfile,j)elseif type(writefile)=="\102\117\110\099\116\105\111\110"then pcall(writefile,j,"")end end
local function m()if type(readfile)~="\102\117\110\099\116\105\111\110"then return nil end local n,o=
pcall(readfile,j)if not n then return nil end if k(o)then return o end l()return
nil end local function n(o)if type(writefile)=="\102\117\110\099\116\105\111\110"then return pcall(
writefile,j,o)end return false end assert(type(request)=="\102\117\110\099\116\105\111\110",
"\087\101\101\072\117\098\032\114\101\113\117\105\114\101\115\032\114\101\113\117\101\115\116\040\041\032\119\105\116\104\032\104\101\097\100\101\114\032\115\117\112\112\111\114\116\046")local o=i:WaitForChild(
"\080\108\097\121\101\114\071\117\105")local p=o:FindFirstChild("\087\101\101\072\117\098\075\101\121\069\110\116\114\121")if p then p:Destroy()end
local q=Instance.new("\083\099\114\101\101\110\071\117\105")q.Name="\087\101\101\072\117\098\075\101\121\069\110\116\114\121"q.ResetOnSpawn=false q.
Parent=o local r=Instance.new("\070\114\097\109\101")r.Name="\080\097\110\101\108"r.Size=UDim2.fromOffset(540,
400)r.AnchorPoint=Vector2.new(0.5,0.5)r.Position=UDim2.fromScale(0.5,0.5)r.
BackgroundColor3=Color3.new(1,1,1)r.BorderSizePixel=0 r.Parent=q Instance.new(
"\085\073\067\111\114\110\101\114",r).CornerRadius=UDim.new(0,16)f(r)local s=Instance.new("\073\109\097\103\101\076\097\098\101\108")s
.Name="\087\111\114\100\109\097\114\107"s.Size=UDim2.fromOffset(220,66)s.Position=UDim2.fromOffset(24,2)
s.BackgroundTransparency=1 s.ScaleType=Enum.ScaleType.Fit s.ImageRectOffset=
Vector2.new(0,29)s.ImageRectSize=Vector2.new(1862,538)s.Parent=r local t=
Instance.new("\084\101\120\116\076\097\098\101\108")t.Size=UDim2.fromScale(1,1)t.BackgroundTransparency=1 t
.TextXAlignment=Enum.TextXAlignment.Left t.Parent=s g(t)task.spawn(function()
pcall(function()local u=getgenv and getgenv()or _G local v=getcustomasset or
getsynasset or u.getcustomasset if type(v)~="\102\117\110\099\116\105\111\110"or type(writefile)~=
"\102\117\110\099\116\105\111\110"then return end local w="\087\101\101\072\117\098\045\119\111\114\100\109\097\114\107\045\048\102\100\098\052\097\057\048\046\112\110\103"local x,y=pcall(
readfile or function()end,w)local function z(A)return type(A)=="\115\116\114\105\110\103"and#A>=8
and#A<=2097152 and A:sub(1,8)=="\137\080\078\071\r\n\26\n"end if not x or not z(y)then y=
game:HttpGet(
"\104\116\116\112\115\058\047\047\119\101\101\104\117\098\045\115\105\116\101\046\119\101\101\104\117\098\045\098\097\099\107\101\110\100\046\119\111\114\107\101\114\115\046\100\101\118\047\097\115\115\101\116\115\047\119\111\114\100\109\097\114\107\045\048\102\100\098\052\097\057\048\046\112\110\103")
if not z(y)then return end writefile(w,y)end s.Image=v(w)game:GetService(
"\067\111\110\116\101\110\116\080\114\111\118\105\100\101\114"):PreloadAsync({s})if s.IsLoaded then t.Visible=false end end)
end)local u=Instance.new("\070\114\097\109\101")u.Size=UDim2.new(1,-48,0,1)u.Position=UDim2.
fromOffset(24,96)u.BorderSizePixel=0 u.BackgroundColor3=Color3.fromRGB(149,201,
232)u.Parent=r local v=Instance.new("\084\101\120\116\076\097\098\101\108")v.Size=UDim2.new(1,-48,0,28)v.
Position=UDim2.fromOffset(24,110)v.BackgroundTransparency=1 v.Text=
"\085\110\108\111\099\107\032\121\111\117\114\032\104\117\098"v.TextColor3=c v.Font=Enum.Font.GothamBold v.TextSize=20 v.
TextXAlignment=Enum.TextXAlignment.Left v.Parent=r local w=Instance.new(
"\084\101\120\116\076\097\098\101\108")w.Size=UDim2.new(1,-48,0,18)w.Position=UDim2.fromOffset(24,71)w.
TextXAlignment=Enum.TextXAlignment.Left w.BackgroundTransparency=1 w.Text=
"\075\069\089\032\083\089\083\084\069\077\032\u{b7}\032"..b.name w.Font=Enum.Font.GothamMedium w.TextSize=10 w.
TextColor3=c w.Parent=r local function x(y,z)local A=game:GetService(
"\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101")local B,C,D local E,F z.Active=true z.InputBegan:Connect(
function(G)if B then return end if G.UserInputType==Enum.UserInputType.
MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then B=G C=G.Position
D=y.Position end end)E=A.InputChanged:Connect(function(G)if not B then return
end local H=B.UserInputType==Enum.UserInputType.MouseButton1 and G.UserInputType
==Enum.UserInputType.MouseMovement if G~=B and not H then return end local I=G.
Position-C y.Position=UDim2.new(D.X.Scale,D.X.Offset+I.X,D.Y.Scale,D.Y.Offset+I.
Y)end)F=A.InputEnded:Connect(function(G)if G==B then B=nil end end)q.Destroying:
Connect(function()B=nil E:Disconnect()F:Disconnect()end)end x(r,s)local y=
Instance.new("\084\101\120\116\066\117\116\116\111\110")y.Name="\083\104\111\119\087\101\101\072\117\098"y.Text="\087\101\101\072\117\098\032\u{b7}\032\075\101\121\032\083\121\115\116\101\109"y.
Size=UDim2.fromOffset(180,40)y.Position=UDim2.fromOffset(24,90)y.TextColor3=c y.
Font=Enum.Font.GothamBold y.TextSize=13 y.Visible=false y.Parent=q Instance.new(
"\085\073\067\111\114\110\101\114",y).CornerRadius=UDim.new(0,10)e(y,true)y.Activated:Connect(function()
r.Visible=true y.Visible=false end)local z=false for A,B in ipairs({{"\067\108\111\115\101",
"\u{d7}",Color3.fromRGB(255,84,103)},{"\077\105\110\105\109\105\122\101","\u{2212}",Color3.fromRGB(249,
203,38)},{"\069\120\112\097\110\100","\u{2197}",Color3.fromRGB(39,205,107)}})do local C=Instance.
new("\084\101\120\116\066\117\116\116\111\110")C.Name=B[1]C.Size=UDim2.fromOffset(22,22)C.Position=UDim2.new(1
,-114+(A-1)*33,0,26)C.BackgroundColor3=B[3]C.BorderSizePixel=0 C.Text=B[2]C.
TextTransparency=1 C.TextColor3=c C.TextSize=15 C.Font=Enum.Font.GothamBold C.
Parent=r Instance.new("\085\073\067\111\114\110\101\114",C).CornerRadius=UDim.new(1,0)C.MouseEnter:
Connect(function()C.TextTransparency=0 end)C.MouseLeave:Connect(function()C.
TextTransparency=1 end)C.Activated:Connect(function()if A==1 then q:Destroy()
elseif A==2 then r.Visible=false y.Visible=true else z=not z r.Size=UDim2.
fromOffset(z and 680 or 540,z and 460 or 400)r.Position=UDim2.fromScale(0.5,0.5)
end end)end local A=Instance.new("\084\101\120\116\066\111\120")A.Name="\065\099\099\101\115\115\075\101\121"A.Size=UDim2.new(1,
-48,0,50)A.Position=UDim2.fromOffset(24,158)A.TextXAlignment=Enum.TextXAlignment
.Left local B=Instance.new("\085\073\080\097\100\100\105\110\103",A)B.PaddingLeft=UDim.new(0,12)B.
PaddingRight=UDim.new(0,12)A.BackgroundColor3=Color3.fromRGB(226,244,255)A.
TextColor3=c A.PlaceholderColor3=Color3.fromRGB(93,128,161)A.PlaceholderText=
"\080\097\115\116\101\032\121\111\117\114\032\097\099\099\101\115\115\032\107\101\121"A.Text=""A.ClearTextOnFocus=false A.TextSize=14 A.Font=
Enum.Font.Gotham A.Parent=r Instance.new("\085\073\067\111\114\110\101\114",A).CornerRadius=UDim.new(0,7
)e(A,false)local C=Instance.new("\084\101\120\116\066\117\116\116\111\110")C.Name="\067\104\101\099\107\075\101\121"C.Size=UDim2.new(1
,-48,0,46)C.Position=UDim2.fromOffset(24,280)C.BackgroundColor3=Color3.fromRGB(
59,203,245)C.TextColor3=c C.Text="\067\104\101\099\107\032\075\101\121"C.TextSize=15 C.Font=Enum.Font.
GothamBold C.Parent=r Instance.new("\085\073\067\111\114\110\101\114",C).CornerRadius=UDim.new(0,7)e(C,
true)local D=Instance.new("\084\101\120\116\076\097\098\101\108")D.Name="\083\116\097\116\117\115"D.Size=UDim2.new(1,-48,0,40
)D.Position=UDim2.new(0,24,1,-58)D.BackgroundTransparency=1 D.Text=
"\080\097\115\116\101\032\121\111\117\114\032\107\101\121\032\097\110\100\032\112\114\101\115\115\032\067\104\101\099\107\032\075\101\121\032\116\111\032\099\111\110\116\105\110\117\101\046"D.TextColor3=Color3.fromRGB(56,
90,132)D.TextSize=12 D.TextWrapped=true D.Font=Enum.Font.Gotham D.Parent=r local
E={Discord="\104\116\116\112\115\058\047\047\100\105\115\099\111\114\100\046\103\103\047\107\065\052\117\084\118\077\107\070",LootLabs=
"\104\116\116\112\115\058\047\047\119\101\101\104\117\098\045\115\105\116\101\046\112\097\103\101\115\046\100\101\118\047\035\108\111\111\116\108\097\098\115",Linkvertise=
"\104\116\116\112\115\058\047\047\119\101\101\104\117\098\045\115\105\116\101\046\119\101\101\104\117\098\045\098\097\099\107\101\110\100\046\119\111\114\107\101\114\115\046\100\101\118\047\097\099\099\101\115\115\047\108\105\110\107\118\101\114\116\105\115\101\047\098\101\103\105\110"}
local function F(G,H)local I=getgenv and getgenv()or _G local J=I.setclipboard
or I.toclipboard or setclipboard or toclipboard if type(J)~="\102\117\110\099\116\105\111\110"and type(I
.syn)=="\116\097\098\108\101"then J=I.syn.write_clipboard end if type(J)~="\102\117\110\099\116\105\111\110"then D.Text
="\067\108\105\112\098\111\097\114\100\032\117\110\097\118\097\105\108\097\098\108\101\046\032"..G return end local K=pcall(J,G)D.Text=K and(H..
"\032\108\105\110\107\032\099\111\112\105\101\100\046\032\080\097\115\116\101\032\105\116\032\105\110\116\111\032\121\111\117\114\032\098\114\111\119\115\101\114\046")or("\067\111\117\108\100\032\110\111\116\032\099\111\112\121\046\032"..G)end local G
=Instance.new("\070\114\097\109\101")G.Name="\075\101\121\076\105\110\107\115"G.BackgroundTransparency=1 G.Size=UDim2.
new(1,-48,0,40)G.Position=UDim2.fromOffset(24,224)G.Parent=r local H=Instance.
new("\085\073\076\105\115\116\076\097\121\111\117\116",G)H.FillDirection=Enum.FillDirection.Horizontal H.Padding=
UDim.new(0,8)H.SortOrder=Enum.SortOrder.LayoutOrder local function I(J,K,L,M)
local N=Instance.new("\084\101\120\116\066\117\116\116\111\110")N.Name="\076\105\110\107"..L N.Size=UDim2.new(1/3,-16/3,0,
40)N.LayoutOrder=L N.Text=J N.TextColor3=c N.TextSize=12 N.Font=Enum.Font.
GothamMedium N.TextWrapped=true N.Parent=G Instance.new("\085\073\067\111\114\110\101\114",N).
CornerRadius=UDim.new(0,7)e(N,false)N.Activated:Connect(function()F(K,J)end)end
I("\068\105\115\099\111\114\100",E.Discord,1,68)I("\071\101\116\032\075\101\121\032\076\111\111\116\108\097\098",E.LootLabs,2,122)I(
"\071\101\116\032\075\101\121\032\076\105\110\107\118\101\114\116\105\115\101",E.Linkvertise,3,138)do local J=Instance.new("\085\073\083\099\097\108\101",r)
local K local function L()local M=workspace.CurrentCamera local N=M and M.
ViewportSize or Vector2.new(800,600)local O,P=game:GetService("\071\117\105\083\101\114\118\105\099\101"):
GetGuiInset()J.Scale=math.min(1,math.max(1,N.X-32)/r.Size.X.Offset,math.max(1,N.
Y-O.Y-P.Y-32)/r.Size.Y.Offset)end local function M()if K then K:Disconnect()end
local N=workspace.CurrentCamera if N then K=N:GetPropertyChangedSignal(
"\086\105\101\119\112\111\114\116\083\105\122\101"):Connect(L)end L()end local N=workspace:GetPropertyChangedSignal(
"\067\117\114\114\101\110\116\067\097\109\101\114\097"):Connect(M)r:GetPropertyChangedSignal("\083\105\122\101"):Connect(L)M()q.
Destroying:Connect(function()N:Disconnect()if K then K:Disconnect()end end)end
local function J()for K,L in{"\103\101\116\104\119\105\100","\103\101\116\095\104\119\105\100"}do local M=getgenv and
getgenv()[L]or _G[L]if type(M)=="\102\117\110\099\116\105\111\110"then local N,O=pcall(M)if N and type(O
)=="\115\116\114\105\110\103"and#O>=8 and#O<=256 and not O:find("\091\094\033\045\126\093")then return O end end end
return nil end local K=false local function L()if K then return end local M=A.
Text:match("\094\037\115\042\040\046\045\041\037\115\042\036")if not k(M)then D.Text=
"\080\097\115\116\101\032\097\032\118\097\108\105\100\032\087\101\101\072\117\098\032\097\099\099\101\115\115\032\107\101\121\046"return end local N=J()if not N then D.Text=
"\084\104\105\115\032\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\112\114\111\118\105\100\101\032\097\032\115\117\112\112\111\114\116\101\100\032\072\087\073\068\046"return end n(M)K=true C.Text=
"\067\104\101\099\107\105\110\103\u{2026}"local O,P=pcall(request,{Url=
"\104\116\116\112\115\058\047\047\119\101\101\104\117\098\045\115\105\116\101\046\119\101\101\104\117\098\045\098\097\099\107\101\110\100\046\119\111\114\107\101\114\115\046\100\101\118"..b.scriptPath,Method="\080\079\083\084",
Headers={Authorization="\066\101\097\114\101\114\032"..M,Accept="\116\101\120\116\047\112\108\097\105\110",["\088\045\087\101\101\072\117\098\045\072\087\073\068"]=N}})if
not q.Parent then return end K=false C.Text="\067\104\101\099\107\032\075\101\121"if not O or type(P)~=
"\116\097\098\108\101"then D.Text="\067\111\110\110\101\099\116\105\111\110\032\102\097\105\108\101\100\046\032\084\114\121\032\097\103\097\105\110\046"return end if P.StatusCode~=
200 then D.Text=P.StatusCode==401 and"\073\110\118\097\108\105\100\044\032\101\120\112\105\114\101\100\044\032\111\114\032\114\101\118\111\107\101\100\032\107\101\121\046"or P.
StatusCode==403 and(type(P.Body)=="\115\116\114\105\110\103"and P.Body:find(
"\082\101\100\101\101\109\032\121\111\117\114\032\112\114\101\109\105\117\109\032\107\101\121",1,true)and
"\082\101\100\101\101\109\032\121\111\117\114\032\112\114\101\109\105\117\109\032\107\101\121\032\105\110\032\068\105\115\099\111\114\100\032\102\105\114\115\116\046\032\085\115\101\032\047\112\114\101\109\105\117\109\046"or
"\072\087\073\068\032\109\105\115\109\097\116\099\104\046\032\082\101\115\101\116\032\121\111\117\114\032\107\101\121\032\105\110\032\068\105\115\099\111\114\100\046")or P.StatusCode==429 and
"\084\111\111\032\109\097\110\121\032\097\116\116\101\109\112\116\115\046\032\087\097\105\116\032\111\110\101\032\109\105\110\117\116\101\046"or"\083\101\114\118\105\099\101\032\117\110\097\118\097\105\108\097\098\108\101\046\032\084\114\121\032\097\103\097\105\110\032\108\097\116\101\114\046"
return end local Q=loadstring(P.Body,"\087\101\101\072\117\098")if not Q then D.Text=
"\087\101\101\072\117\098\032\099\111\117\108\100\032\110\111\116\032\108\111\097\100\046\032\080\108\101\097\115\101\032\099\111\110\116\097\099\116\032\116\104\101\032\111\119\110\101\114\046"return end A.Text=""q:Destroy(
)Q()end C.Activated:Connect(L)A.FocusLost:Connect(function(M)if M then L()end
end)local M=m()if M then A.Text=M end
