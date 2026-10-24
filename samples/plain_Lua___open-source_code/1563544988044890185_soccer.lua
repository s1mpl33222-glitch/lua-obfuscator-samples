local a={"UserInputService","TweenService","CoreGui","RunService","Players","Workspace","VirtualInputManager","TPS","Ball","Football","HumanoidRootPart","ScreenGui","Frame","UICorner","TextLabel","TextButton","UIListLayout"}
local function b(c)return game:GetService(a[c])end
local d,e,f,g,h,i,j=b(1),b(2),b(3),b(4),b(5),b(6),b(7)
local k=h.LocalPlayer
if f:FindFirstChild("ZenithMobileUI")then f.ZenithMobileUI:Destroy()end
local l,m,n,o,p=false,false,true,true,false
local q,r,s,t,u=22,0,0.6,-19,4
local v,w,x=0,0,nil
local y,z=26,16
local A={}
local function B(C)j:SendKeyEvent(true,C,false,game)task.defer(function()j:SendKeyEvent(false,C,false,game)end)end
local function D()
if x and x:IsDescendantOf(i)then return x end
local E=i:FindFirstChild(a[8])or i:FindFirstChild(a[9])or i:FindFirstChild(a[10])
if E then if E:IsA("BasePart")then x=E return E elseif E:IsA("Model")and E.PrimaryPart then x=E.PrimaryPart return E.PrimaryPart end end
for _,F in ipairs(i:GetChildren())do local G=F.Name:lower()if G:find("ball")or G:find("tps")or G:find("bola")then if F:IsA("BasePart")and F.CanCollide then x=F return F elseif F:IsA("Model")and F.PrimaryPart then x=F.PrimaryPart return F.PrimaryPart end end end
x=nil return nil
end
local function H(I)
if I:FindFirstChildOfClass("Weld")or I:FindFirstChildOfClass("WeldConstraint")or I:FindFirstChildOfClass("Motor6D")then return true end
local J=I.Parent if J and J:FindFirstChildOfClass("Humanoid")then return true end
for _,K in ipairs(I:GetChildren())do if(K:IsA("SelectionBox")or K:IsA("Highlight")or K:IsA("BillboardGui")or K:IsA("SurfaceGui"))and K.Visible then return true end end
local L=I.Position for _,M in ipairs(h:GetPlayers())do local N=M.Character if N then local O=N:FindFirstChild(a[11])if O and(L-O.Position).Magnitude<=3.5 then return true end end end
return false
end
d.InputBegan:Connect(function(P,Q)
if Q then return end
if P.KeyCode==Enum.KeyCode.P and n then l=not l if A["Auto Dive"]then A["Auto Dive"](l)end end
if P.KeyCode==Enum.KeyCode.T and o then m=not m if A["Inf Stamina"]then A["Inf Stamina"](m)end end
end)
local R,S=0,0.03
g.Heartbeat:Connect(function(T)
local U=k.Character if not U then return end
if m then
local V=U:FindFirstChildOfClass("Humanoid")local W=U:FindFirstChild(a[11])
if W and V and V.Health>0 then
local X=V.MoveDirection if X.Magnitude==0 then local Y=Vector3.new(W.AssemblyLinearVelocity.X,0,W.AssemblyLinearVelocity.Z)if Y.Magnitude>1 then X=Y.Unit end end
if X.Magnitude>0 then local Z=y-z local _=Vector3.new(X.X,0,X.Z).Unit*(Z*T)W.CFrame=W.CFrame+_ end
end
end
if not l then return end
local a0=os.clock()if(a0-R)<S then return end R=a0
local a1=U:FindFirstChild(a[11])local a2=U:FindFirstChildOfClass("Humanoid")if not a1 or not a2 then return end
if(a0-v)<r then return end
local a3=D()if not a3 or H(a3)then return end
local a4=a3.Position local a5=a1.Position local a6=(a4-a5).Magnitude
if a6<=q then
local a7=a1.CFrame:PointToObjectSpace(a4)
if a7.Z>=t and a7.Z<=u then
if math.abs(a7.X)<=1.5 then
if a7.Y>=1.0 then if(a0-w)>=s and a2.FloorMaterial~=Enum.Material.Air then w=a0 v=a0 a2.Jump=true a2:ChangeState(Enum.HumanoidStateType.Jumping)end end
return
end
if a7.X>1.5 then v=a0 B(Enum.KeyCode.E)elseif a7.X<-1.5 then v=a0 B(Enum.KeyCode.Q)end
end
end
end)
local a8=Instance.new(a[12])a8.Name="ZenithMobileUI"a8.Parent=f a8.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local a9=Instance.new(a[13])a9.Name="MainFrame"a9.Parent=a8 a9.BackgroundColor3=Color3.fromRGB(15,18,28)a9.BorderColor3=Color3.fromRGB(30,40,65)a9.BorderSizePixel=1 a9.Position=UDim2.new(0.05,0,0.2,0)a9.Size=UDim2.new(0,310,0,315)a9.ClipsDescendants=true
local b0=Instance.new(a[14])b0.CornerRadius=UDim.new(0,10)b0.Parent=a9
local b1,b2,b3,b4
local function b5(b6)local b7=b6.Position-b3 a9.Position=UDim2.new(b4.X.Scale,b4.X.Offset+b7.X,b4.Y.Scale,b4.Y.Offset+b7.Y)end
a9.InputBegan:Connect(function(b8)if b8.UserInputType==Enum.UserInputType.MouseButton1 or b8.UserInputType==Enum.UserInputType.Touch then b1=true b3=b8.Position b4=a9.Position b8.Changed:Connect(function()if b8.UserInputState==Enum.UserInputState.End then b1=false end end)end end)
a9.InputChanged:Connect(function(b9)if b9.UserInputType==Enum.UserInputType.MouseMovement or b9.UserInputType==Enum.UserInputType.Touch then b2=b9 end end)
d.InputChanged:Connect(function(c0)if c0==b2 and b1 then b5(c0)end end)
local c1=Instance.new(a[13])c1.Name="Header"c1.Parent=a9 c1.BackgroundTransparency=1 c1.Size=UDim2.new(1,0,0,45)
local c2=Instance.new(a[15])c2.Parent=c1 c2.BackgroundTransparency=1 c2.Position=UDim2.new(0,15,0,8)c2.Size=UDim2.new(0,120,0,20)c2.Font=Enum.Font.GothamBold c2.Text="YTDRACOSWOR"c2.TextColor3=Color3.fromRGB(255,255,255)c2.TextSize=16 c2.TextXAlignment=Enum.TextXAlignment.Left
local c3=Instance.new(a[15])c3.Parent=c1 c3.BackgroundTransparency=1 c3.Position=UDim2.new(0,15,0,26)c3.Size=UDim2.new(0,120,0,14)c3.Font=Enum.Font.Gotham c3.Text="Goalkeeper "c3.TextColor3=Color3.fromRGB(120,130,160)c3.TextSize=11 c3.TextXAlignment=Enum.TextXAlignment.Left
local c4=Instance.new(a[15])c4.Parent=c1 c4.BackgroundTransparency=1 c4.Position=UDim2.new(1,-95,0,12)c4.Size=UDim2.new(0,50,0,20)c4.Font=Enum.Font.GothamBold c4.Text="v1.2.2"c4.TextColor3=Color3.fromRGB(60,180,140)c4.TextSize=12
local c5=Instance.new(a[16])c5.Name="MinimizeBtn"c5.Parent=c1 c5.BackgroundColor3=Color3.fromRGB(25,30,45)c5.Position=UDim2.new(1,-38,0,9)c5.Size=UDim2.new(0,26,0,26)c5.Font=Enum.Font.GothamBold c5.Text="-"c5.TextColor3=Color3.fromRGB(200,210,240)c5.TextSize=16
local c6=Instance.new(a[14])c6.CornerRadius=UDim.new(0,6)c6.Parent=c5
local c7=Instance.new(a[13])c7.Name="Container"c7.Parent=a9 c7.BackgroundTransparency=1 c7.Position=UDim2.new(0,10,0,48)c7.Size=UDim2.new(1,-20,1,-80)
local c8=Instance.new(a[17])c8.Parent=c7 c8.SortOrder=Enum.SortOrder.LayoutOrder c8.Padding=UDim.new(0,6)
local c9=Instance.new(a[15])c9.Name="CreditsLabel"c9.Parent=a9 c9.BackgroundTransparency=1 c9.Position=UDim2.new(0,0,1,-26)c9.Size=UDim2.new(1,0,0,20)c9.Font=Enum.Font.GothamBold c9.Text="Created by YT Dracoswor"c9.TextColor3=Color3.fromRGB(110,125,160)c9.TextSize=12 c9.TextXAlignment=Enum.TextXAlignment.Center
c5.MouseButton1Click:Connect(function()
p=not p
local d0=p and UDim2.new(0,310,0,45)or UDim2.new(0,310,0,315)c5.Text=p and "+" or "-"
c7.Visible=not p c9.Visible=not p
e:Create(a9,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=d0}):Play()
end)
local function d1(d2,d3,d4,d5)
local d6=Instance.new(a[13])d6.Parent=c7 d6.BackgroundColor3=Color3.fromRGB(22,26,40)d6.Size=UDim2.new(1,0,0,50)
local d7=Instance.new(a[14])d7.CornerRadius=UDim.new(0,8)d7.Parent=d6
local d8=Instance.new(a[15])d8.Parent=d6 d8.BackgroundTransparency=1 d8.Position=UDim2.new(0,12,0,8)d8.Font=Enum.Font.GothamBold d8.Text=d2 d8.TextColor3=Color3.fromRGB(255,255,255)d8.TextSize=13 d8.TextXAlignment=Enum.TextXAlignment.Left
local d9=Instance.new(a[15])d9.Parent=d6 d9.BackgroundTransparency=1 d9.Position=UDim2.new(0,12,0,26)d9.Font=Enum.Font.Gotham d9.Text=d3 d9.TextColor3=Color3.fromRGB(110,120,150)d9.TextSize=10 d9.TextXAlignment=Enum.TextXAlignment.Left
local e0=Instance.new(a[16])e0.Parent=d6 e0.BackgroundColor3=d4 and Color3.fromRGB(65,140,240)or Color3.fromRGB(40,45,65)e0.Position=UDim2.new(1,-52,0.5,-12)e0.Size=UDim2.new(0,40,0,24)e0.Text=""
local e1=Instance.new(a[14])e1.CornerRadius=UDim.new(1,0)e1.Parent=e0
local e2=Instance.new(a[13])e2.Parent=e0 e2.BackgroundColor3=Color3.fromRGB(255,255,255)e2.Position=d4 and UDim2.new(1,-20,0.5,-8)or UDim2.new(0,4,0.5,-8)e2.Size=UDim2.new(0,16,0,16)
local e3=Instance.new(a[14])e3.CornerRadius=UDim.new(1,0)e3.Parent=e2
local e4=d4
local function e5(e6)e4=e6 local e7=e6 and UDim2.new(1,-20,0.5,-8)or UDim2.new(0,4,0.5,-8)local e8=e6 and Color3.fromRGB(65,140,240)or Color3.fromRGB(40,45,65)e:Create(e2,TweenInfo.new(0.2),{Position=e7}):Play()e:Create(e0,TweenInfo.new(0.2),{BackgroundColor3=e8}):Play()end
e0.MouseButton1Click:Connect(function()e4=not e4 e5(e4)d5(e4)end)
A[d2]=function(e9)e5(e9)end
end
d1("Auto Dive","Auto save script",false,function(f0)l=f0 end)
d1("Inf Stamina","Booster 26",false,function(f1)m=f1 end)
d1("Keybind P","Enable/Disable P Key",true,function(f2)n=f2 end)
d1("Keybind T","Enable/Disable T Key",true,function(f3)o=f3 end)
