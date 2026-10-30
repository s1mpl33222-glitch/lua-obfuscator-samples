local a=game:GetService("CoreGui")
local b=game:GetService("Players")
local c=game:GetService("Workspace")
local d=game:GetService("Lighting")
local e=game:GetService("TweenService")
local f={s=115,v=118,n=110,y=121,c=99}
local function g()
	local h={"s","v","n","y","c"}
	local i={115,118,110,121,99}
	for j,k in ipairs(h) do
		if f[k]~=i[j] then return false end
	end
	return true
end
if not g() then return end
local l={task=task,pcall=pcall,tostring=tostring,Instance=Instance,game=game}
local function m()
	for n,o in pairs(l) do
		if _G[n]~=nil and type(_G[n])~=type(o) then return false end
	end
	return true
end
if not m() then return end
local p=os and os.clock and os.clock()
task.wait(0)
local q=os and os.clock and os.clock()
if p and q and(q-p)>2 then return end
local r="sv"..tostring(math.random(1e4,9e4))
if a:FindFirstChild(r) then a[r]:Destroy() end
pcall(function()
	local s=getrawmetatable(game)
	setreadonly(s,false)
	local t=s.__namecall
	s.__namecall=newcclosure(function(self,...)
		local u=getnamecallmethod()
		if u=="Kick"or u=="Ban" then return nil end
		if u=="FireServer" then
			local v=tostring(self):lower()
			if v:match("anti")or v:match("cheat")or v:match("ac_") then return nil end
		end
		return t(self,...)
	end)
	setreadonly(s,true)
end)
local w=Instance.new("ScreenGui")
w.Name=r
w.Parent=a
w.ResetOnSpawn=false
w.IgnoreGuiInset=true
pcall(function()
	local x=getrawmetatable(w)
	if x and setreadonly then
		setreadonly(x,false)
		local y=x.__newindex
		x.__newindex=newcclosure(function(self,k,v)
			if k=="Parent"and v==nil then return end
			if k=="Name" then return end
			return(y or rawset)(self,k,v)
		end)
		setreadonly(x,true)
	end
end)
task.spawn(function()
	while task.wait(1.5) do
		pcall(function()
			if not w.Parent then w.Parent=a end
		end)
	end
end)
local z=Instance.new("Frame")
z.Name="z"
z.Parent=w
z.BackgroundColor3=Color3.fromRGB(7,7,10)
z.Size=UDim2.new(1,0,1,0)
z.ZIndex=10
local A=Instance.new("Frame")
A.Parent=z
A.BackgroundColor3=Color3.fromRGB(12,12,17)
A.Size=UDim2.new(0,340,0,148)
A.Position=UDim2.new(0.5,-170,0.5,-74)
A.BorderSizePixel=0
A.ZIndex=11
Instance.new("UICorner",A).CornerRadius=UDim.new(0,10)
local B=Instance.new("UIStroke",A)
B.Color=Color3.fromRGB(40,130,255)
B.Thickness=1
local C=Instance.new("Frame",A)
C.BackgroundColor3=Color3.fromRGB(40,130,255)
C.Size=UDim2.new(0,36,0,2)
C.Position=UDim2.new(0,14,0,0)
C.BorderSizePixel=0
C.ZIndex=12
Instance.new("UICorner",C).CornerRadius=UDim.new(1,0)
local D=Instance.new("TextLabel",A)
D.BackgroundTransparency=1
D.Position=UDim2.new(0,14,0,14)
D.Size=UDim2.new(1,-14,0,20)
D.Font=Enum.Font.GothamBold
D.Text="Wyaat"
D.TextColor3=Color3.fromRGB(255,255,255)
D.TextSize=15
D.TextXAlignment=Enum.TextXAlignment.Left
D.ZIndex=12
local E=Instance.new("TextLabel",A)
E.BackgroundTransparency=1
E.Position=UDim2.new(0,14,0,40)
E.Size=UDim2.new(1,-14,0,14)
E.Font=Enum.Font.Gotham
E.Text="INITIALIZING..."
E.TextColor3=Color3.fromRGB(55,140,255)
E.TextSize=11
E.TextXAlignment=Enum.TextXAlignment.Left
E.ZIndex=12
local F=Instance.new("Frame",A)
F.BackgroundTransparency=1
F.Position=UDim2.new(0,14,0,66)
F.Size=UDim2.new(1,-28,0,8)
F.ZIndex=12
local G={}
for i=1,5 do
	local H=Instance.new("Frame",F)
	H.BackgroundColor3=Color3.fromRGB(25,25,36)
	H.Size=UDim2.new(0,7,0,7)
	H.Position=UDim2.new(0,(i-1)*13,0.5,-3.5)
	H.BorderSizePixel=0
	H.ZIndex=12
	Instance.new("UICorner",H).CornerRadius=UDim.new(1,0)
	G[i]=H
end
local I=Instance.new("Frame",A)
I.BackgroundColor3=Color3.fromRGB(18,18,26)
I.Position=UDim2.new(0,14,0,92)
I.Size=UDim2.new(1,-28,0,4)
I.BorderSizePixel=0
I.ZIndex=12
Instance.new("UICorner",I).CornerRadius=UDim.new(1,0)
local J=Instance.new("Frame",I)
J.BackgroundColor3=Color3.fromRGB(50,145,255)
J.Size=UDim2.new(0,0,1,0)
J.BorderSizePixel=0
J.ZIndex=12
Instance.new("UICorner",J).CornerRadius=UDim.new(1,0)
local K=Instance.new("TextLabel",A)
K.BackgroundTransparency=1
K.Position=UDim2.new(0,14,1,-22)
K.Size=UDim2.new(1,-14,0,14)
K.Font=Enum.Font.Gotham
K.Text="discord.gg/svnyc  ·  fps hub"
K.TextColor3=Color3.fromRGB(38,38,52)
K.TextSize=10
K.TextXAlignment=Enum.TextXAlignment.Left
K.ZIndex=12
local L=Instance.new("TextButton",w)
L.BackgroundColor3=Color3.fromRGB(12,12,17)
L.Position=UDim2.new(0,14,0.5,-22)
L.Size=UDim2.new(0,44,0,44)
L.Font=Enum.Font.GothamBold
L.Text="FPS"
L.TextColor3=Color3.fromRGB(70,155,255)
L.TextSize=12
L.Draggable=true
L.Visible=false
L.ZIndex=5
Instance.new("UICorner",L).CornerRadius=UDim.new(1,0)
local M=Instance.new("UIStroke",L)
M.Color=Color3.fromRGB(40,130,255)
M.Thickness=1.5
local N=Instance.new("Frame",w)
N.BackgroundColor3=Color3.fromRGB(10,10,14)
N.Position=UDim2.new(0.5,-185,0.5,-140)
N.Size=UDim2.new(0,370,0,280)
N.Active=true
N.Draggable=true
N.Visible=false
N.ZIndex=2
Instance.new("UICorner",N).CornerRadius=UDim.new(0,10)
local O=Instance.new("UIStroke",N)
O.Color=Color3.fromRGB(28,28,40)
O.Thickness=1
local P=Instance.new("Frame",N)
P.BackgroundColor3=Color3.fromRGB(15,15,20)
P.Size=UDim2.new(1,0,0,36)
P.BorderSizePixel=0
P.ZIndex=3
Instance.new("UICorner",P).CornerRadius=UDim.new(0,10)
local Q=Instance.new("Frame",P)
Q.BackgroundColor3=Color3.fromRGB(40,130,255)
Q.Size=UDim2.new(0,32,0,2)
Q.Position=UDim2.new(0,12,1,-2)
Q.BorderSizePixel=0
Q.ZIndex=4
Instance.new("UICorner",Q).CornerRadius=UDim.new(1,0)
local R=Instance.new("TextLabel",P)
R.BackgroundTransparency=1
R.Position=UDim2.new(0,12,0,0)
R.Size=UDim2.new(1,-46,1,0)
R.Font=Enum.Font.GothamBold
R.Text="Wyaat  ·  fps hub"
R.TextColor3=Color3.fromRGB(220,220,232)
R.TextSize=12
R.TextXAlignment=Enum.TextXAlignment.Left
R.ZIndex=4
local S=Instance.new("TextButton",P)
S.BackgroundColor3=Color3.fromRGB(190,50,50)
S.Position=UDim2.new(1,-28,0.5,-8)
S.Size=UDim2.new(0,16,0,16)
S.Font=Enum.Font.GothamBold
S.Text="×"
S.TextColor3=Color3.fromRGB(255,255,255)
S.TextSize=12
S.ZIndex=4
Instance.new("UICorner",S).CornerRadius=UDim.new(0,4)
local T=Instance.new("ScrollingFrame",N)
T.BackgroundTransparency=1
T.Position=UDim2.new(0,10,0,44)
T.Size=UDim2.new(1,-20,1,-52)
T.CanvasSize=UDim2.new(0,0,0,270)
T.ScrollBarThickness=2
T.ScrollBarImageColor3=Color3.fromRGB(40,130,255)
T.ZIndex=3
local U=Instance.new("UIListLayout",T)
U.SortOrder=Enum.SortOrder.LayoutOrder
U.Padding=UDim.new(0,5)
local function V(lbl,sub,fn)
	local W=Instance.new("Frame",T)
	W.BackgroundColor3=Color3.fromRGB(16,16,22)
	W.Size=UDim2.new(1,0,0,50)
	W.BorderSizePixel=0
	W.ZIndex=3
	Instance.new("UICorner",W).CornerRadius=UDim.new(0,6)
	local X=Instance.new("UIStroke",W)
	X.Color=Color3.fromRGB(24,24,34)
	X.Thickness=1
	local Y=Instance.new("Frame",W)
	Y.BackgroundColor3=Color3.fromRGB(40,130,255)
	Y.Size=UDim2.new(0,2,0,26)
	Y.Position=UDim2.new(0,0,0.5,-13)
	Y.BorderSizePixel=0
	Y.ZIndex=4
	Instance.new("UICorner",Y).CornerRadius=UDim.new(1,0)
	local Z=Instance.new("TextLabel",W)
	Z.BackgroundTransparency=1
	Z.Position=UDim2.new(0,12,0,7)
	Z.Size=UDim2.new(1,-100,0,17)
	Z.Font=Enum.Font.GothamMedium
	Z.Text=lbl
	Z.TextColor3=Color3.fromRGB(210,210,225)
	Z.TextSize=12
	Z.TextXAlignment=Enum.TextXAlignment.Left
	Z.ZIndex=4
	local aa=Instance.new("TextLabel",W)
	aa.BackgroundTransparency=1
	aa.Position=UDim2.new(0,12,0,27)
	aa.Size=UDim2.new(1,-100,0,13)
	aa.Font=Enum.Font.Gotham
	aa.Text=sub
	aa.TextColor3=Color3.fromRGB(55,55,76)
	aa.TextSize=10
	aa.TextXAlignment=Enum.TextXAlignment.Left
	aa.ZIndex=4
	local ab=Instance.new("TextButton",W)
	ab.BackgroundColor3=Color3.fromRGB(25,85,195)
	ab.Position=UDim2.new(1,-84,0.5,-12)
	ab.Size=UDim2.new(0,74,0,24)
	ab.Font=Enum.Font.GothamBold
	ab.Text="RUN"
	ab.TextColor3=Color3.fromRGB(210,230,255)
	ab.TextSize=11
	ab.ZIndex=4
	Instance.new("UICorner",ab).CornerRadius=UDim.new(0,5)
	ab.MouseButton1Click:Connect(function()
		pcall(fn)
		ab.Text="✓"
		ab.BackgroundColor3=Color3.fromRGB(25,130,75)
		task.delay(1.6,function()
			ab.Text="RUN"
			ab.BackgroundColor3=Color3.fromRGB(25,85,195)
		end)
	end)
	W.MouseEnter:Connect(function()
		e:Create(W,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(20,20,28)}):Play()
	end)
	W.MouseLeave:Connect(function()
		e:Create(W,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(16,16,22)}):Play()
	end)
end
V("Ultimate FPS Boost","shadows · particles · decals · fog off",function()
	d.GlobalShadows=false
	d.FogEnd=9e9
	d.Brightness=2
	for _,v in ipairs(d:GetChildren()) do
		if v:IsA("PostEffect")or v:IsA("Sky") then v:Destroy() end
	end
	for _,v in ipairs(c:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material=Enum.Material.SmoothPlastic
			v.Reflectance=0
		elseif v:IsA("Decal")or v:IsA("Texture") then
			v:Destroy()
		elseif v:IsA("ParticleEmitter")or v:IsA("Fire")or v:IsA("Smoke")or v:IsA("Sparkles") then
			v.Enabled=false
		end
	end
end)
V("Low Graphics Mode","force quality level 1",function()
	settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
end)
V("Remove Audio Sources","stop + destroy all sounds",function()
	for _,v in ipairs(c:GetDescendants()) do
		if v:IsA("Sound") then v:Stop() v:Destroy() end
	end
end)
V("Garbage Collect","run full lua gc cycle",function()
	collectgarbage("collect")
end)
S.MouseButton1Click:Connect(function() w:Destroy() end)
L.MouseButton1Click:Connect(function() N.Visible=not N.Visible end)
task.spawn(function()
	local ac=TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local ad={
		{t="ESTABLISHING BYPASS...",p=0.2,dot=1},
		{t="INJECTING HOOKS...",p=0.45,dot=2},
		{t="PATCHING ANTICHEAT...",p=0.65,dot=3},
		{t="LOADING INTERFACE...",p=0.85,dot=4},
		{t="READY.",p=1.0,dot=5},
	}
	for _,s in ipairs(ad) do
		E.Text=s.t
		e:Create(J,ac,{Size=UDim2.new(s.p,0,1,0)}):Play()
		if G[s.dot] then
			e:Create(G[s.dot],TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(50,145,255)}):Play()
		end
		task.wait(s.dot==5 and 0.28 or 0.68)
	end
	local ae=TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	e:Create(z,ae,{BackgroundTransparency=1}):Play()
	e:Create(A,ae,{BackgroundTransparency=1}):Play()
	e:Create(D,ae,{TextTransparency=1}):Play()
	e:Create(E,ae,{TextTransparency=1}):Play()
	e:Create(K,ae,{TextTransparency=1}):Play()
	e:Create(B,ae,{Transparency=1}):Play()
	e:Create(C,ae,{BackgroundTransparency=1}):Play()
	e:Create(I,ae,{BackgroundTransparency=1}):Play()
	e:Create(J,ae,{BackgroundTransparency=1}):Play()
	for _,dot in ipairs(G) do
		e:Create(dot,ae,{BackgroundTransparency=1}):Play()
	end
	task.wait(0.5)
	z:Destroy()
	L.Visible=true
	N.Visible=true
end)